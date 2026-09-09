
`timescale 1ns/1ns

module CursorPlane(
				Clk, 
				nRST,
				FIFOClear,
				CPlaneEn,
				FrameStart,
				
				CDMADataRequest,
				CDMADataValid,
				CDMADataIn,
				
				CPlanePixFormat,
				CPlaneAlphaMode,
				CPlaneAlphaValue,
				CPlaneXSize,
				CPlaneYSize,
				CPlaneXSizeRef,
				
				CPlaneDataRequest,
				CPlaneDataValid,
				CPlaneDataIn,
				
				CurFIFOOverRun,
				CurFIFOUnderRun
);

`include "DmPara.v"

// System
input			Clk; 
input			nRST;
input			FIFOClear;
input			CPlaneEn;
input			FrameStart;

// Cursor DMA FIFO
output		 	CDMADataRequest;
input		 	CDMADataValid;
input  [DW:0] 	CDMADataIn;
			
// Plane X/Y Cordinate
input  [ 0:0]	CPlanePixFormat;	// 0: 8bit, 1: 16bit
input  [ 1:0]	CPlaneAlphaMode;	// 0: No Alpah, 2: Global Alpha, 3: Per-Pixel Alpha
input  [ 7:0] 	CPlaneAlphaValue;
input  [XW:0] 	CPlaneXSize;	// max 64x64
input  [YW:0] 	CPlaneYSize;
output [XW:0]	CPlaneXSizeRef;

// Plane Normalized Input Data(32Bit ARGB 8888)
input		 	CPlaneDataRequest;
output		 	CPlaneDataValid;
output [31:0] 	CPlaneDataIn;	// ARGB

// FIFO Error Status Interrupt
output			CurFIFOOverRun;
output			CurFIFOUnderRun;
//-------------------------------------------------------------------------------
parameter C_IDLE = 6'b000001;
parameter C_DREQ = 6'b000010;
parameter C_WD00 = 6'b000100;
parameter C_WD01 = 6'b001000;
parameter C_WD10 = 6'b010000;
parameter C_WD11 = 6'b100000;

reg [5:0]  CurStC, NxtStC;

wire  tCIdle  = CurStC[0];
wire  tCDReq  = CurStC[1];
wire  tCWD00  = CurStC[2];
wire  tCWD01  = CurStC[3];
wire  tCWD10  = CurStC[4];
wire  tCWD11  = CurStC[5];

// Cursor Plane
reg 			CursorEn;
wire 			CursorEnDis;
wire 			CursorEnEna;

wire 			CDMARequestX;
wire 			CDMARequestY;
wire		 	CDMADataRequest;
reg [DW:0] 		LatchCDMAData;

// Cursor Count
wire 			CurXCountEnd;
wire 			CurYCountEnd;
wire 			CurXCountInc;

reg  [XW:0] 	CurXCount;
reg  [YW:0] 	CurYCount;
wire [XW:0] 	CPlaneXSizeRef;

// Cursor FIFO
reg  			CurFIFOWrite;
reg  [31:0] 	CurFIFOWrData;
wire			CurFIFORead;
wire [31:0] 	CurFIFORdData;

wire			CurFIFOEmpty;
wire			CurFIFOFull;
wire			CurFIFOHalfFull;

wire			GoDMARequest = ~CurFIFOHalfFull & CDMARequestX;
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStC <= C_IDLE;
  	else if (FIFOClear)
  				CurStC <= C_IDLE;
  	else        CurStC <= NxtStC;

always @(tCIdle or tCDReq or tCWD00 or tCWD01 or tCWD10 or tCWD11 or 
		GoDMARequest or CDMADataValid or CPlanePixFormat) begin
  	NxtStC = C_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tCIdle  : 	if (GoDMARequest)		NxtStC = C_DREQ;
  	  	          	else        			NxtStC = C_IDLE;
                                        	
  	  	tCDReq  : 	if (CDMADataValid)		NxtStC = C_WD00;
  	  				else					NxtStC = C_DREQ;
                                        	
  	  	tCWD00  : 	        				NxtStC = C_WD01;
		                                	
  	  	tCWD01  : 	if (CPlanePixFormat) begin // 16bit
  	  	          		if (GoDMARequest)	NxtStC = C_DREQ;
  	  	          		else				NxtStC = C_IDLE;
  	  	          	end
  	  	          	else        			NxtStC = C_WD10;
                                        	
  	  	tCWD10  : 	        				NxtStC = C_WD11;
		                                	
  	  	tCWD11  : 	if (GoDMARequest)		NxtStC = C_DREQ;
  	  	          	else 	        		NxtStC = C_IDLE;
                                        	
  	  	default :               			NxtStC = C_IDLE;
  	endcase
end
//-------------------------------------------------------------------------------
assign CursorEnDis = CurYCountEnd | FIFOClear;
assign CursorEnEna = CPlaneEn & FrameStart;
always @(negedge nRST or posedge Clk)
	if      (!nRST)   		CursorEn <= 0;
	else if (CursorEnDis) 	CursorEn <= 0;
	else if (CursorEnEna)	CursorEn <= 1;
	else					CursorEn <= CursorEn;

//										/2							/4
assign CPlaneXSizeRef = CPlanePixFormat ? {1'b0, CPlaneXSize[XW:1]} : {2'b0, CPlaneXSize[XW:2]};

assign CDMARequestX = (CurXCount < CPlaneXSizeRef) & CDMARequestY & CursorEn;
assign CDMARequestY = (CurYCount < CPlaneYSize);

assign CDMADataRequest = tCDReq & CDMARequestX;

// Display Pixel Count
assign CurXCountEnd = (CurXCount == CPlaneXSizeRef) | FIFOClear;	// Counter Cleared By Frame Reset
assign CurYCountEnd = (CurYCount == CPlaneYSize)    | FIFOClear;
assign CurXCountInc = tCDReq & CDMADataValid & CursorEn;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		CurXCount <= 0;
	else if (CurXCountEnd) 	CurXCount <= 0;
	else if (CurXCountInc)	CurXCount <= CurXCount + 1;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		CurYCount <= 0;
	else if (CurYCountEnd) 	CurYCount <= 0;
	else if (CurXCountEnd) 	CurYCount <= CurYCount + 1;
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
	if  (!nRST)	CurFIFOWrite <= 0;
	else		CurFIFOWrite <= (tCWD00 | tCWD01 | tCWD10 | tCWD11) & ~CurFIFOFull;

always @(negedge nRST or posedge Clk)
	if  	(!nRST)			LatchCDMAData <= 0;
	else if (CDMADataValid)	LatchCDMAData <= CDMADataIn;

always @(negedge nRST or posedge Clk)
	if  (!nRST)	CurFIFOWrData <= 0;
	else begin
		if (CPlanePixFormat) begin // 16bit
			case(1'b1) // synopsys parallel_case
				tCWD00 : begin
						 CurFIFOWrData[23:0] <= {LatchCDMAData[14:10], 3'b0, 
						 						 LatchCDMAData[9:5],   3'b0, 
						 						 LatchCDMAData[4:0],   3'b0};
						 case(CPlaneAlphaMode) // synpsys parallel_case
						 	2'b00   : CurFIFOWrData[31:24] <= 8'hFF;					// No Alpha
						 	2'b10   : CurFIFOWrData[31:24] <= CPlaneAlphaValue;			// Global Alpha
						 	default : CurFIFOWrData[31:24] <= {8{LatchCDMAData[15]}};	// Per-Pixel Alpha
						 endcase
						 end
				tCWD01 : begin	
						 CurFIFOWrData[23:0] <= {LatchCDMAData[30:26], 3'b0, 
						 						 LatchCDMAData[25:21], 3'b0, 
						 						 LatchCDMAData[20:16], 3'b0};
						 case(CPlaneAlphaMode) // synpsys parallel_case
						 	2'b00   : CurFIFOWrData[31:24] <= 8'hFF;					// No Alpha
						 	2'b10   : CurFIFOWrData[31:24] <= CPlaneAlphaValue;			// Global Alpha
						 	default : CurFIFOWrData[31:24] <= {8{LatchCDMAData[31]}};	// Per-Pixel Alpha
						 endcase
						 end
				default : 	CurFIFOWrData	 <= CurFIFOWrData;
			endcase
		end
		else begin	// 8bit
			case(1'b1) // synopsys parallel_case
				tCWD00 : begin
						 CurFIFOWrData[23:0] <= {LatchCDMAData[7:5], 5'b0, 
						 						 LatchCDMAData[4:2], 5'b0, 
						 						 LatchCDMAData[1:0], 6'b0};
						 case(CPlaneAlphaMode[1]) // synpsys parallel_case
						 	1'b0    : CurFIFOWrData[31:24] <= 8'hFF;					// No Alpha
						 	1'b1    : CurFIFOWrData[31:24] <= CPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				tCWD01 : begin	
						 CurFIFOWrData[23:0] <= {LatchCDMAData[15:13], 5'b0, 
						 						 LatchCDMAData[12:10], 5'b0, 
						 						 LatchCDMAData[9:8],   6'b0};
						 case(CPlaneAlphaMode[1]) // synpsys parallel_case
						 	1'b0    : CurFIFOWrData[31:24] <= 8'hFF;					// No Alpha
						 	1'b1    : CurFIFOWrData[31:24] <= CPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				tCWD10 : begin	
						 CurFIFOWrData[23:0] <= {LatchCDMAData[23:21], 5'b0, 
						 						 LatchCDMAData[20:18], 5'b0, 
						 						 LatchCDMAData[17:16], 6'b0};
						 case(CPlaneAlphaMode[1]) // synpsys parallel_case
						 	1'b0    : CurFIFOWrData[31:24] <= 8'hFF;					// No Alpha
						 	1'b1    : CurFIFOWrData[31:24] <= CPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				tCWD11 : begin	
						 CurFIFOWrData[23:0] <= {LatchCDMAData[31:29], 5'b0, 
						 						 LatchCDMAData[28:26], 5'b0, 
						 						 LatchCDMAData[25:24], 6'b0};
						 case(CPlaneAlphaMode[1]) // synpsys parallel_case
						 	1'b0    : CurFIFOWrData[31:24] <= 8'hFF;					// No Alpha
						 	1'b1    : CurFIFOWrData[31:24] <= CPlaneAlphaValue;			// Global Alpha
						 endcase
						 end
				default : 	CurFIFOWrData	 <= CurFIFOWrData;
			endcase
		end
	end

// 16x32 Depth, -5(8bit mode) Half Full
ScFIFO16x32 #(4, 5, 32) CursorFIFO(
			.Clk			(Clk), 
			.nRST			(nRST), 
			.FIFOFlush		(FIFOClear), 
			.FIFOWrData		(CurFIFOWrData), 
			.FIFOWrite		(CurFIFOWrite), 
			.FIFORdData		(CurFIFORdData), 
			.FIFORead		(CurFIFORead),
			.FIFOHalfFull	(CurFIFOHalfFull), 
			.FIFOFull		(CurFIFOFull), 
			.FIFOEmptyWr	(),
			.FIFOAlmostEmpty(),
			.FIFOEmpty		(CurFIFOEmpty)
);

assign CurFIFORead = CPlaneDataRequest & ~CurFIFOEmpty;

assign CPlaneDataValid = CurFIFORead;

assign CPlaneDataIn = CurFIFORdData;
//-------------------------------------------------------------------------------
assign CurFIFOOverRun  = CursorEn & CurFIFOFull;
assign CurFIFOUnderRun = CursorEn & CPlaneDataRequest & CurFIFOEmpty;
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(CurFIFOUnderRun)
	if(CurFIFOUnderRun) begin
		$display("%m ERROR: Cursor Plane FIFO Error (%t)",$time);
		$stop;
	end
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
endmodule