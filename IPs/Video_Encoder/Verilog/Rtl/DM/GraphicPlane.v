
`timescale 1ns/1ns

module GraphicPlane(
				Clk, 
				nRST,
				FIFOClear,
				GPlaneEn,
				FrameStart,
				
				GDMADataRequest,
				GDMADataValid,
				GDMADataIn,
				GraphicEn,
				
				PalMemWrite,
				PalMemWrAddr,
				PalMemWrData,
				PalMemRead,
				PalMemRdData,
				
				GPlaneGammaEn,
				GPlanePixFormat,
				GPlaneAlphaMode,
				GPlaneAlphaValue,
				GPlaneXSize,
				GPlaneYSize,
				GPlaneXSizeRef,
				
				GPlaneGamma10, GPlaneGamma0F, GPlaneGamma0E, GPlaneGamma0D, GPlaneGamma0C, 
		 		GPlaneGamma0B, GPlaneGamma0A, GPlaneGamma09, GPlaneGamma08, 
		 		GPlaneGamma07, GPlaneGamma06, GPlaneGamma05, GPlaneGamma04, 
		 		GPlaneGamma03, GPlaneGamma02, GPlaneGamma01, GPlaneGamma00,
		 	
				GPlaneDataRequest,
				GPlaneDataValid,
				GPlaneDataIn,
				
				GraFIFOOverRun,
				GraFIFOUnderRun
);

`include "DmPara.v"

// System
input			Clk; 
input			nRST;
input			FIFOClear;
input			GPlaneEn;
input			FrameStart;

// Graphic DMA FIFO
output		 	GDMADataRequest;
input		 	GDMADataValid;
input  [DW:0] 	GDMADataIn;
output			GraphicEn;

// Palette Memory
input		 	PalMemWrite;
input  [ 7:0] 	PalMemWrAddr;
input  [23:0] 	PalMemWrData;
input			PalMemRead;
output [23:0]	PalMemRdData;

// Plane X/Y Cordinate
input			GPlaneGammaEn;
input  [ 2:0]	GPlanePixFormat;	// 0: 8bit, 2: RGB565, 3:ARGB1555, 4:RGB888, 5:ARGB8888
input  [ 1:0]	GPlaneAlphaMode;	// 0: No Alpah, 2: Global Alpha, 3: Per-Pixel Alpha
input  [ 7:0] 	GPlaneAlphaValue;
input  [GW:0] 	GPlaneXSize;	// max 64x64
input  [GW:0] 	GPlaneYSize;
output [GW:0]	GPlaneXSizeRef;

// Graphic Gamma
input [23:0] 	GPlaneGamma10, GPlaneGamma0F, GPlaneGamma0E, GPlaneGamma0D, GPlaneGamma0C; 
input [23:0] 	GPlaneGamma0B, GPlaneGamma0A, GPlaneGamma09, GPlaneGamma08; 
input [23:0] 	GPlaneGamma07, GPlaneGamma06, GPlaneGamma05, GPlaneGamma04; 
input [23:0] 	GPlaneGamma03, GPlaneGamma02, GPlaneGamma01, GPlaneGamma00;

// Plane Normalized Input Data(32Bit ARGB 8888)
input		 	GPlaneDataRequest;
output		 	GPlaneDataValid;
output [31:0] 	GPlaneDataIn;	// ARGB

// FIFO Error Status Interrupt
output			GraFIFOOverRun;
output			GraFIFOUnderRun;
//-------------------------------------------------------------------------------
parameter G_IDLE = 6'b000001;
parameter G_DREQ = 6'b000010;
parameter G_WD00 = 6'b000100;
parameter G_WD01 = 6'b001000;
parameter G_WD10 = 6'b010000;
parameter G_WD11 = 6'b100000;

reg [5:0]  CurStG, NxtStG;

wire  tGIdle  = CurStG[0];
wire  tGDReq  = CurStG[1];
wire  tGWD00  = CurStG[2];
wire  tGWD01  = CurStG[3];
wire  tGWD10  = CurStG[4];
wire  tGWD11  = CurStG[5];

wire  nGWD00  = NxtStG[2];
wire  nGWD01  = NxtStG[3];
wire  nGWD10  = NxtStG[4];
wire  nGWD11  = NxtStG[5];

// Graphic Plane
reg 			GraphicEn;
wire 			GraphicEnDis;
wire 			GraphicEnEna;

wire 			GDMARequestX;
wire 			GDMARequestY;
wire		 	GDMADataRequest;
reg [DW:0] 		LatchGDMAData;

// Graphic Count
wire 			GraXCountEnd;
wire 			GraYCountEnd;
wire 			GraXCountInc;

reg  [GW:0] 	GraXCount;
reg  [GW:0] 	GraYCount;
reg  [GW:0] 	GPlaneXSizeRef;

// Graphic Gamma
reg	 [31:0]		GPlaneGammaIn;
wire [23:0]		GPlaneGammaOut;

// Graphic Palette Memory
wire [23:0] 	PalMemRdData;
wire 			PalMemReadInt;
reg	 [ 7:0]		PalMemRdAddrInt;
wire 			PalMemReadAll;
wire [ 7:0]		PalMemRdAddr;

// Graphic FIFO
wire  			GraFIFOWrite;
wire [31:0] 	GraFIFOWrData;
wire			GraFIFORead;
wire [31:0] 	GraFIFORdData;

wire			GraFIFOEmpty;
wire			GraFIFOFull;
wire			GraFIFOHalfFull;

wire			GoDMARequest = ~GraFIFOHalfFull & GDMARequestX;

wire			GPlanePixFormat8  = (GPlanePixFormat==0);
wire			GPlanePixFormat16 =  GPlanePixFormat[1];
wire			GPlanePixFormat32 =  GPlanePixFormat[2];
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStG <= G_IDLE;
  	else if (FIFOClear)
  				CurStG <= G_IDLE;
  	else        CurStG <= NxtStG;

always @(tGIdle or tGDReq or tGWD00 or tGWD01 or tGWD10 or tGWD11 or 
		GoDMARequest or GDMADataValid or GPlanePixFormat16 or GPlanePixFormat32) begin
  	NxtStG = G_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tGIdle  : 	if (GoDMARequest)		NxtStG = G_DREQ;
  	  	          	else        			NxtStG = G_IDLE;
                                        	
  	  	tGDReq  : 	if (GDMADataValid)		NxtStG = G_WD00;
  	  				else					NxtStG = G_DREQ;
                                        	
  	  	tGWD00  : 	if (GPlanePixFormat32) begin
  	  	          		if (GoDMARequest)	NxtStG = G_DREQ;
  	  	          		else				NxtStG = G_IDLE;
  	  	          	end
  	  	          	else        			NxtStG = G_WD01;
		                                	
  	  	tGWD01  : 	if (GPlanePixFormat16) begin
  	  					if (GoDMARequest)	NxtStG = G_DREQ;
  	  					else				NxtStG = G_IDLE;
  	  				end
  	  	          	else        			NxtStG = G_WD10;
                                        	
  	  	tGWD10  : 	        				NxtStG = G_WD11;
		                                	
  	  	tGWD11  : 	if (GoDMARequest)		NxtStG = G_DREQ;
  	  	          	else 	        		NxtStG = G_IDLE;
                                        	
  	  	default :               			NxtStG = G_IDLE;
  	endcase
end
//-------------------------------------------------------------------------------
assign GraphicEnDis = FIFOClear;
assign GraphicEnEna = GPlaneEn & FrameStart;
always @(negedge nRST or posedge Clk)
	if      (!nRST)   		GraphicEn <= 0;
	else if (GraphicEnDis) 	GraphicEn <= 0;
	else if (GraphicEnEna)	GraphicEn <= 1;
	else					GraphicEn <= GraphicEn;

always @(GPlanePixFormat16 or GPlanePixFormat32 or GPlaneXSize)
	case(1'b1) // synopsys parallel_case
		GPlanePixFormat16 : GPlaneXSizeRef = {1'b0, GPlaneXSize[GW:1]}; // 16bit, /2
		GPlanePixFormat32 : GPlaneXSizeRef =  	    GPlaneXSize[GW:0] ; // 32bit
		default 		  : GPlaneXSizeRef = {2'b0, GPlaneXSize[GW:2]}; // 8bit, /4
	endcase

assign GDMARequestX = (GraXCount < GPlaneXSizeRef) & GDMARequestY & GraphicEn;
assign GDMARequestY = (GraYCount < GPlaneYSize);

assign GDMADataRequest = tGDReq & GDMARequestX;

// Display Pixel Count
assign GraXCountEnd = (GraXCount == GPlaneXSizeRef) | FIFOClear;	// Counter Cleared By Frame Reset
assign GraYCountEnd = (GraYCount == GPlaneYSize)    | FIFOClear;
assign GraXCountInc = tGDReq & GDMADataValid & GraphicEn;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		GraXCount <= 0;
	else if (GraXCountEnd) 	GraXCount <= 0;
	else if (GraXCountInc)	GraXCount <= GraXCount + 1;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		GraYCount <= 0;
	else if (GraYCountEnd) 	GraYCount <= 0;
	else if (GraXCountEnd) 	GraYCount <= GraYCount + 1;

always @(negedge nRST or posedge Clk)
	if  	(!nRST)			LatchGDMAData <= 0;
	else if (GDMADataValid)	LatchGDMAData <= GDMADataIn;
//-------------------------------------------------------------------------------
// Palette Memory Synchronous Single Port Memory 256x24
assign PalMemReadInt = GPlanePixFormat8 & (nGWD00 | nGWD01 | nGWD10 | nGWD11);
assign PalMemReadAll = PalMemReadInt | PalMemRead;
assign PalMemRdAddr  = PalMemRead ? PalMemWrAddr : PalMemReadInt ? PalMemRdAddrInt : 0;

always @(nGWD00 or nGWD01 or nGWD10 or nGWD11 or LatchGDMAData or GDMADataIn)
	case(1'b1) // synopsys parallel_case full_case
		nGWD00 : PalMemRdAddrInt = GDMADataIn[7:0];
		nGWD01 : PalMemRdAddrInt = LatchGDMAData[15:8];
		nGWD10 : PalMemRdAddrInt = LatchGDMAData[23:16];
		nGWD11 : PalMemRdAddrInt = LatchGDMAData[31:24];
	endcase

PaletteMem #(8, 24) GPaletteMem(
			.Clk 		(Clk), 
			.nRST 		(nRST), 
			.Csb  		(1'b0),
			.Web  		(~PalMemWrite), 
			.Oeb  		(~PalMemReadAll), 
			.WAddr		(PalMemWrAddr), 
			.RAddr		(PalMemRdAddr), 
			.DI  		(PalMemWrData), 
			.DO  		(PalMemRdData)
);
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
	if  (!nRST)	GPlaneGammaIn <= 0;
	else begin
		case(GPlanePixFormat) // synopsys parallel_case

		  5 : // ARGB8888
			case(1'b1) // synopsys parallel_case
				tGWD00 : begin
						 GPlaneGammaIn[23:0] <= LatchGDMAData[23:0];
						 case(GPlaneAlphaMode) // synpsys parallel_case
						 	2'b00   : GPlaneGammaIn[31:24] <= 8'hFF;				// No Alpha
						 	2'b10   : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;		// Global Alpha
						 	default : GPlaneGammaIn[31:24] <= LatchGDMAData[31:24];	// Per-Pixel Alpha
						 endcase
						 end
				default : 	GPlaneGammaIn	 <= GPlaneGammaIn;
			endcase

		  4 : // RGB8888
			case(1'b1) // synopsys parallel_case
				tGWD00 : begin
						 GPlaneGammaIn[23:0] <= LatchGDMAData[23:0];
						 case(GPlaneAlphaMode) // synpsys parallel_case
						 	2'b00   : GPlaneGammaIn[31:24] <= 8'hFF;				// No Alpha
						 	default : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;		// Global Alpha
						 endcase
						 end
				default : 	GPlaneGammaIn	 <= GPlaneGammaIn;
			endcase

		  3 : // ARGB1555
			case(1'b1) // synopsys parallel_case
				tGWD00 : begin
						 GPlaneGammaIn[23:0] <= {LatchGDMAData[14:10], 3'b0, 
						 						 LatchGDMAData[9:5],   3'b0, 
						 						 LatchGDMAData[4:0],   3'b0};
						 case(GPlaneAlphaMode) // synpsys parallel_case
						 	2'b00   : GPlaneGammaIn[31:24] <= 8'hFF;					// No Alpha
						 	2'b10   : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;			// Global Alpha
						 	default : GPlaneGammaIn[31:24] <= {8{LatchGDMAData[15]}};	// Per-Pixel Alpha
						 endcase
						 end
				tGWD01 : begin	
						 GPlaneGammaIn[23:0] <= {LatchGDMAData[30:26], 3'b0, 
						 						 LatchGDMAData[25:21], 3'b0, 
						 						 LatchGDMAData[20:16], 3'b0};
						 case(GPlaneAlphaMode) // synpsys parallel_case
						 	2'b00   : GPlaneGammaIn[31:24] <= 8'hFF;					// No Alpha
						 	2'b10   : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;			// Global Alpha
						 	default : GPlaneGammaIn[31:24] <= {8{LatchGDMAData[31]}};	// Per-Pixel Alpha
						 endcase
						 end
				default : 	GPlaneGammaIn	 <= GPlaneGammaIn;
			endcase

		  2 : // RGB565
			case(1'b1) // synopsys parallel_case
				tGWD00 : begin
						 GPlaneGammaIn[23:0] <= {LatchGDMAData[15:11], 3'b0, 
						 						 LatchGDMAData[10:5],  2'b0, 
						 						 LatchGDMAData[4:0],   3'b0};
						 case(GPlaneAlphaMode) // synpsys parallel_case
						 	2'b00   : GPlaneGammaIn[31:24] <= 8'hFF;					// No Alpha
						 	default : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				tGWD01 : begin	
						 GPlaneGammaIn[23:0] <= {LatchGDMAData[31:27], 3'b0, 
						 						 LatchGDMAData[26:21], 2'b0, 
						 						 LatchGDMAData[20:16], 3'b0};
						 case(GPlaneAlphaMode) // synpsys parallel_case
						 	2'b00   : GPlaneGammaIn[31:24] <= 8'hFF;					// No Alpha
						 	default : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				default : 	GPlaneGammaIn	 <= GPlaneGammaIn;
			endcase

		  default :	// 8bit
			case(1'b1) // synopsys parallel_case
				tGWD00 : begin
						 GPlaneGammaIn[23:0] <=  PalMemRdData;
						 case(GPlaneAlphaMode[1]) // synpsys parallel_case
						 	1'b0    : GPlaneGammaIn[31:24] <= 8'hFF;					// No Alpha
						 	1'b1    : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				tGWD01 : begin	
						 GPlaneGammaIn[23:0] <= PalMemRdData;
						 case(GPlaneAlphaMode[1]) // synpsys parallel_case
						 	1'b0    : GPlaneGammaIn[31:24] <= 8'hFF;					// No Alpha
						 	1'b1    : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				tGWD10 : begin	
						 GPlaneGammaIn[23:0] <= PalMemRdData;
						 case(GPlaneAlphaMode[1]) // synpsys parallel_case
						 	1'b0    : GPlaneGammaIn[31:24] <= 8'hFF;					// No Alpha
						 	1'b1    : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				tGWD11 : begin	
						 GPlaneGammaIn[23:0] <= PalMemRdData;
						 case(GPlaneAlphaMode[1]) // synpsys parallel_case
						 	1'b0    : GPlaneGammaIn[31:24] <= 8'hFF;					// No Alpha
						 	1'b1    : GPlaneGammaIn[31:24] <= GPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				default : 	GPlaneGammaIn	 <= GPlaneGammaIn;
			endcase
		  endcase
	end

// Graphic Gamma
reg GPlaneGammaValidIn;
always @(negedge nRST or posedge Clk)
	if  (!nRST)	GPlaneGammaValidIn <= 0;
	else		GPlaneGammaValidIn <= (tGWD00 | tGWD01 | tGWD10 | tGWD11);

reg [7:0] GraGammaAlpha;
always @(negedge nRST or posedge Clk)
	if  (!nRST)	GraGammaAlpha <= 0;
	else		GraGammaAlpha <= GPlaneGammaIn[31:24];

wire GPlaneGammaValidOut;

// 1 Clock Delay
PlaneGamma GPlaneGamma( 
			.Clk 			(Clk), 
			.nRST			(nRST),
			.GammaEn		(GPlaneGammaEn),
			.RegGamma10		(GPlaneGamma10), 
			.RegGamma0F		(GPlaneGamma0F), 
			.RegGamma0E		(GPlaneGamma0E), 
			.RegGamma0D		(GPlaneGamma0D), 
			.RegGamma0C		(GPlaneGamma0C), 
		 	.RegGamma0B		(GPlaneGamma0B), 
		 	.RegGamma0A		(GPlaneGamma0A), 
		 	.RegGamma09		(GPlaneGamma09), 
		 	.RegGamma08		(GPlaneGamma08), 
		 	.RegGamma07		(GPlaneGamma07), 
		 	.RegGamma06		(GPlaneGamma06), 
		 	.RegGamma05		(GPlaneGamma05), 
		 	.RegGamma04		(GPlaneGamma04), 
		 	.RegGamma03		(GPlaneGamma03), 
		 	.RegGamma02		(GPlaneGamma02), 
		 	.RegGamma01		(GPlaneGamma01), 
		 	.RegGamma00		(GPlaneGamma00),
		 	
		 	.GammaValidIn	(GPlaneGammaValidIn),
		 	.RGammaIn 		(GPlaneGammaIn[23:16]),  
		 	.GGammaIn 		(GPlaneGammaIn[15: 8]),  
		 	.BGammaIn 		(GPlaneGammaIn[ 7: 0]),
		 	.GammaValidOut	(GPlaneGammaValidOut),
		 	.RGammaOut		(GPlaneGammaOut[23:16]), 
		 	.GGammaOut		(GPlaneGammaOut[15: 8]), 
		 	.BGammaOut		(GPlaneGammaOut[ 7: 0])
);

assign GraFIFOWrite  = GPlaneGammaValidOut & ~GraFIFOFull;
assign GraFIFOWrData = {GraGammaAlpha, GPlaneGammaOut};

// 32x32 Depth, -5(8bit mode(5) + gamma(1)) Half Full
ScFIFO64x32 #(6, 6, 32) GraphicFIFO(
			.Clk			(Clk), 
			.nRST			(nRST), 
			.FIFOFlush		(~GraphicEn), 
			.FIFOWrData		(GraFIFOWrData), 
			.FIFOWrite		(GraFIFOWrite), 
			.FIFORdData		(GraFIFORdData), 
			.FIFORead		(GraFIFORead),
			.FIFOHalfFull	(GraFIFOHalfFull), 
			.FIFOFull		(GraFIFOFull), 
			.FIFOEmptyWr	(),
			.FIFOAlmostEmpty(),
			.FIFOEmpty		(GraFIFOEmpty)
);

assign GraFIFORead = GPlaneDataRequest & ~GraFIFOEmpty;

assign GPlaneDataValid = GraFIFORead;

assign GPlaneDataIn = GraFIFORdData;
//-------------------------------------------------------------------------------
assign GraFIFOOverRun  = GraphicEn & GraFIFOFull;
assign GraFIFOUnderRun = GraphicEn & GPlaneDataRequest & GraFIFOEmpty;
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(GraFIFOUnderRun)
	if(GraFIFOUnderRun) begin
		$display("%m ERROR: Graphic Plane FIFO Error (%t)",$time);
		$stop;
	end
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------

endmodule