
`timescale 1ns/1ns

`include "DmDef.v"

module VideoPlane(
				Clk, 
				nRST,
				FIFOClear,
				VPlaneEn,
				FrameStart,
				
				VDMADataRequest,
				VDMADataValid,
				VDMADataIn,
				
				VPlaneCSCEn,
				VPlaneGammaEn,
				VPlanePixFormat,
				VPlaneAlphaMode,
				VPlaneAlphaValue,
				VPlaneXSize,
				VPlaneYSize,
				VPlaneXSizeRef,

`ifdef SCALER
				PreFilterEn,
				DnScaleEn,
				UpScaleEn,
				ScaleInXSize,
				ScaleInYSize,
				ScaleXRatio,
				ScaleYRatio,
`endif
				VPlaneGamma10, VPlaneGamma0F, VPlaneGamma0E, VPlaneGamma0D, VPlaneGamma0C, 
		 		VPlaneGamma0B, VPlaneGamma0A, VPlaneGamma09, VPlaneGamma08, 
		 		VPlaneGamma07, VPlaneGamma06, VPlaneGamma05, VPlaneGamma04, 
		 		VPlaneGamma03, VPlaneGamma02, VPlaneGamma01, VPlaneGamma00,
		 	
				VPlaneDataRequest,
				VPlaneDataValid,
				VPlaneDataIn,
				VPlaneDataHold,
				
				VidFIFOOverRun,
				VidFIFOUnderRun
);

`include "DmPara.v"

// System
input			Clk; 
input			nRST;
input			FIFOClear;
input			VPlaneEn;
input			FrameStart;

// Video DMA FIFO
output		 	VDMADataRequest;
input		 	VDMADataValid;
input  [DW:0] 	VDMADataIn;

// Plane X/Y Cordinate
input			VPlaneCSCEn;
input			VPlaneGammaEn;
input  [ 1:0]	VPlanePixFormat;	// 0: Y0CbY1Cr, 1:Y0CrY1Cb, 2:CrY0CbY1, 3:CbY0CrY1
input  [ 1:0]	VPlaneAlphaMode;	// 0: No Alpah, 2: Global Alpha
input  [ 7:0] 	VPlaneAlphaValue;
input  [XW:0] 	VPlaneXSize;
input  [YW:0] 	VPlaneYSize;
output [XW:0]	VPlaneXSizeRef;

// Scaler
`ifdef SCALER
input 			PreFilterEn;
input 			DnScaleEn;
input 			UpScaleEn;
input [XW:0]	ScaleInXSize;
input [YW:0]	ScaleInYSize;
input [15:0] 	ScaleXRatio;
input [15:0] 	ScaleYRatio;
`endif

// Video Gamma
input [23:0] 	VPlaneGamma10, VPlaneGamma0F, VPlaneGamma0E, VPlaneGamma0D, VPlaneGamma0C; 
input [23:0] 	VPlaneGamma0B, VPlaneGamma0A, VPlaneGamma09, VPlaneGamma08; 
input [23:0] 	VPlaneGamma07, VPlaneGamma06, VPlaneGamma05, VPlaneGamma04; 
input [23:0] 	VPlaneGamma03, VPlaneGamma02, VPlaneGamma01, VPlaneGamma00;

// Plane Normalized Input Data(32Bit ARGB 8888)
input		 	VPlaneDataRequest;
output		 	VPlaneDataValid;
output [31:0] 	VPlaneDataIn;	// ARGB
output			VPlaneDataHold;

// FIFO Error Status Interrupt
output			VidFIFOOverRun;
output			VidFIFOUnderRun;
//-------------------------------------------------------------------------------
parameter V_IDLE = 5'b00001;
parameter V_DREQ = 5'b00010;
parameter V_WD00 = 5'b00100;
parameter V_WD01 = 5'b01000;
parameter V_WAIT = 5'b10000;

reg [4:0]  CurStV, NxtStV;

wire  tVIdle  = CurStV[0];
wire  tVDReq  = CurStV[1];
wire  tVWD00  = CurStV[2];
wire  tVWD01  = CurStV[3];
wire  tVWait  = CurStV[4];

// Video Plane
reg 			VideoEn;
wire 			VideoEnDis;
wire 			VideoEnEna;

wire			VWaitEnd;
reg  [1:0]		VWaitCount;

wire 			VDMARequestX;
wire 			VDMARequestY;
wire		 	VDMADataRequest;
reg [DW:0] 		LatchVDMAData;

// Video Count
wire 			VidXCountEnd;
wire 			VidYCountEnd;
wire 			VidXCountInc;

reg  [XW:0] 	VidXCount;
reg  [YW:0] 	VidYCount;
reg  [XW:0] 	VPlaneXSizeRef;

reg  [15:0] 	FSMIn;
reg 			FSMValidIn;

// Scaler Core
`ifdef SCALER
wire			DnScaleReqHold;
wire			BpScaleEn;
wire [15:0] 	ScaleIn;
wire			ScaleValidIn;
wire [15:0] 	ScaleOut;
wire			ScaleValidOut;
wire [15:0] 	DnScaleOut;
wire			DnScaleValidOut;
wire [15:0] 	UpScaleOut;
wire			UpScaleValidOut;

wire			UScaleEnd;
wire			VZoomRequest;

reg 			ScaleOutEn;
wire 			ScaleOutEnDis;
wire 			ScaleOutEnEna;

reg [XW:0]		ScaleOutXCount;
reg [YW:0]		ScaleOutYCount;
wire			ScaleOutXEnd;
wire			ScaleOutXInc;
wire			ScaleOutYEnd;

reg				ScaleValidOutHalf;
wire			GoFDataRequest;
wire   			VscOutFIFOWrite;
reg  [15:0] 	VscOutFIFOWrData;
wire			iVscOutFIFORead, VscOutFIFORead;
wire [15:0] 	VscOutFIFORdData;
wire			VscOutFIFOEmpty;
wire			VscOutFIFOFull;
wire			VscOutFIFOHalfFull;
wire			VscOutFIFOAlmostFull;
wire			VscOutFIFOAlmostEmpty;

parameter F_IDLE = 3'b001;
parameter F_DREQ = 3'b010;
parameter F_READ = 3'b100;

reg [2:0]  CurStF, NxtStF;

wire  tFIdle  = CurStF[0];
wire  tFDReq  = CurStF[1];
wire  tFRead  = CurStF[2];
`endif

// Video Format Converter 422 to 444
wire [15:0]		VidFCIn;
wire [23:0]		VidFCOut;
wire			VidFCValidIn;
wire			VidFCValidOut;

// Video Color Space Converter
wire [23:0]		VidCSCIn;
wire [23:0]		VidCSCOut;
wire			VidCSCValidIn;
wire 			VidCSCValidOut;

// Video Gamma
wire 			VPlaneGammaValidIn;
wire 			VPlaneGammaValidOut;
wire [23:0]		VPlaneGammaIn;
wire [23:0]		VPlaneGammaOut;
reg  [7:0] 		VPlaneGammaAlpha;

// Video FIFO
wire 			VidFIFOWrite;
wire [31:0] 	VidFIFOWrData;
wire			VidFIFORead;
wire [31:0] 	VidFIFORdData;

wire			VidFIFOEmpty;
wire			VidFIFOFull;
wire			VidFIFOHalfFull;
wire			VidFIFOAlmostEmpty;

`ifdef SCALER
wire			GoDMARequest = (UpScaleEn & VZoomRequest)|// & ~VscOutFIFOHalfFull & ~VidFIFOHalfFull) | 
							   (BpScaleEn & VDMARequestX & ~VidFIFOHalfFull) |
							   (DnScaleEn & VDMARequestX & ~VscOutFIFOAlmostFull & ~DnScaleReqHold);
`else
wire			GoDMARequest = VDMARequestX & ~VidFIFOHalfFull;
`endif
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStV <= V_IDLE;
  	else if (FIFOClear)
  				CurStV <= V_IDLE;
  	else        CurStV <= NxtStV;

always @(tVIdle or tVDReq or tVWD00 or tVWD01 or tVWait or 
		VWaitEnd or GoDMARequest or VDMADataValid or VidXCountEnd) begin
  	NxtStV = V_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tVIdle  : 	if (GoDMARequest)	NxtStV = V_DREQ;
  	  	          	else        		NxtStV = V_IDLE;
                                        	
  	  	tVDReq  : 	if (VDMADataValid)	NxtStV = V_WD00;
  	  				else				NxtStV = V_DREQ;
                                        	
  	  	tVWD00  : 	    				NxtStV = V_WD01;
		                                	
  	  	tVWD01  : 	if (VidXCountEnd)   NxtStV = V_WAIT;
  	  				else if (GoDMARequest)	NxtStV = V_DREQ;
  	  				else				NxtStV = V_IDLE;
                                        	
		tVWait	:	if (VWaitEnd)		NxtStV = V_IDLE;
					else				NxtStV = V_WAIT;

  	  	default :               		NxtStV = V_IDLE;
  	endcase
end
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
	if      (!nRST)   	VWaitCount <= 0;
	else if (!VideoEn) 	VWaitCount <= 0;
	else if (tVWait)	VWaitCount <= VWaitCount + 1;

assign VWaitEnd = &VWaitCount;

assign VideoEnDis = VidYCountEnd | FIFOClear;
assign VideoEnEna = VPlaneEn & FrameStart;
always @(negedge nRST or posedge Clk)
	if      (!nRST)   		VideoEn <= 0;
	else if (VideoEnDis) 	VideoEn <= 0;
	else if (VideoEnEna)	VideoEn <= 1;
	else					VideoEn <= VideoEn;

`ifdef SCALER
always @(ScaleInXSize)
	VPlaneXSizeRef = {1'b0, ScaleInXSize[XW:1]}; // 16bit, /2

assign VDMARequestX = (VidXCount < ScaleInXSize) & VDMARequestY & VideoEn;
assign VDMARequestY = (VidYCount < ScaleInYSize);
`else
always @(VPlaneXSize)
	VPlaneXSizeRef = {1'b0, VPlaneXSize[XW:1]}; // 16bit, /2

assign VDMARequestX = (VidXCount < VPlaneXSize) & VDMARequestY & VideoEn;
assign VDMARequestY = (VidYCount < VPlaneYSize);
`endif

assign VDMADataRequest = tVDReq & VDMARequestX;

// Display Pixel Count
assign VidXCountEnd = (VidXCount == VPlaneXSizeRef) | FIFOClear;	// Counter Cleared By Frame Reset
`ifdef SCALER
assign VidYCountEnd = (VidYCount == ScaleInYSize)   | FIFOClear;
`else
assign VidYCountEnd = (VidYCount == VPlaneYSize)    | FIFOClear;
`endif
//assign VidXCountInc = tVDReq & VDMADataValid & VideoEn;
assign VidXCountInc = tVWD00 & VideoEn;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		VidXCount <= 0;
	else if (VidXCountEnd) 	VidXCount <= 0;
	else if (VidXCountInc)	VidXCount <= VidXCount + 1;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		VidYCount <= 0;
	else if (VidYCountEnd) 	VidYCount <= 0;
	else if (VidXCountEnd) 	VidYCount <= VidYCount + 1;

always @(negedge nRST or posedge Clk)
	if  	(!nRST)			LatchVDMAData <= 0;
	else if (VDMADataValid)	LatchVDMAData <= VDMADataIn;
//-------------------------------------------------------------------------------
// 0: Y0CbY1Cr, 1:Y0CrY1Cb, 2:CrY0CbY1, 3:CbY0CrY1
reg [7:0] Y0;
reg [7:0] Y1;
reg [7:0] Cb;
reg [7:0] Cr;

always @(VPlanePixFormat or LatchVDMAData)
	case(VPlanePixFormat) // synopsys parallel_case
		0  		: Y0 = LatchVDMAData[ 7: 0];
		1  	   	: Y0 = LatchVDMAData[ 7: 0];
		2		: Y0 = LatchVDMAData[15: 8];
		default : Y0 = LatchVDMAData[15: 8];
	endcase

always @(VPlanePixFormat or LatchVDMAData)
	case(VPlanePixFormat) // synopsys parallel_case
		0  		: Y1 = LatchVDMAData[23:16];
		1  	   	: Y1 = LatchVDMAData[23:16];
		2		: Y1 = LatchVDMAData[31:24];
		default : Y1 = LatchVDMAData[31:24];
	endcase

always @(VPlanePixFormat or LatchVDMAData)
	case(VPlanePixFormat) // synopsys parallel_case
		0  		: Cb = LatchVDMAData[15: 8];
		1  	   	: Cb = LatchVDMAData[31:24];
		2		: Cb = LatchVDMAData[23:16];
		default : Cb = LatchVDMAData[ 7: 0];
	endcase

always @(VPlanePixFormat or LatchVDMAData)
	case(VPlanePixFormat) // synopsys parallel_case
		0  		: Cr = LatchVDMAData[31:24];
		1  	   	: Cr = LatchVDMAData[15: 8];
		2		: Cr = LatchVDMAData[ 7: 0];
		default : Cr = LatchVDMAData[23:16];
	endcase

always @(negedge nRST or posedge Clk)
	if  (!nRST)		  	FSMIn <= 0;
	else begin
		case(1'b1) // synopsys parallel_case
			tVWD00  : 	FSMIn <= {Y0, Cb};
			tVWD01  : 	FSMIn <= {Y1, Cr};
			default : 	FSMIn <= FSMIn;
		endcase
	end

always @(negedge nRST or posedge Clk)
	if  (!nRST)	FSMValidIn <= 0;
	else		FSMValidIn <= (tVWD00 | tVWD01);
//-------------------------------------------------------------------------------
// Scaler Input Formatter
`ifdef SCALER
assign BpScaleEn = (~UpScaleEn & ~DnScaleEn) & VPlaneEn;

assign ScaleIn      = FSMIn;
assign ScaleValidIn = FSMValidIn;

wire [XW+1:0] UpScaleXTSize = VPlaneXSize+16;

wire ZoomHold;

reg  DnScaleAct;
reg  UpScaleAct;
always @(negedge nRST or posedge Clk)
	if  (!nRST)	DnScaleAct <= 0;
	else		DnScaleAct <= DnScaleEn & ScaleOutEn;

always @(negedge nRST or posedge Clk)
	if  (!nRST)	UpScaleAct <= 0;
	else		UpScaleAct <= UpScaleEn & ScaleOutEn;

ScTop VideoScaler(
			.clk      		(Clk),
			.rstb       	(nRST),
        	
			.pf_en			(PreFilterEn),
			.sen 			(DnScaleAct),
			.shratio 		(ScaleXRatio),
			.svratio 		(ScaleYRatio),
			.sreqhold		(DnScaleReqHold),
			.shav    		(ScaleValidIn),
			.syin    		(ScaleIn[15:8]),
			.scin    		(ScaleIn[7:0]),
			.seno   		(DnScaleValidOut),
			.syout   		(DnScaleOut[15:8]),
			.scout   		(DnScaleOut[7:0]),
        	
			.zen     		(UpScaleAct),
			.den 			(UpScaleAct),
			.hcycle     	(UpScaleXTSize),
			.hsize      	(VPlaneXSize),
			.vsize      	(VPlaneYSize),
			.inhsize    	(ScaleInXSize),
			.invsize    	(ScaleInYSize),
			.hratio     	(ScaleXRatio),
			.vratio     	(ScaleYRatio),
			.zoom_end		(UScaleEnd),
			.zoom_vzero		(UpYCountIsZero),
        	
			.di_hold 		(ZoomHold),

			.rrdy       	(ScaleValidIn),
			.dma_dat   		(ScaleIn),
			.req        	(VZoomRequest),
			
			.zhavo       	(UpScaleValidOut),
			.zyout       	(UpScaleOut[15:8]),
			.zcout       	(UpScaleOut[7:0])
);

assign ZoomHold  = VscOutFIFOHalfFull & ~UpScaleValidOut;

assign ScaleValidOut = UpScaleEn ? UpScaleValidOut : DnScaleValidOut;
assign ScaleOut      = UpScaleEn ? UpScaleOut      : DnScaleOut;
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
	if  	(!nRST) 		ScaleValidOutHalf <= 0;
	else if (!ScaleValidOut)ScaleValidOutHalf <= 0;
	else if (ScaleValidOut)	ScaleValidOutHalf <= ScaleValidOutHalf + 1;

assign VscOutFIFOWrite = ScaleValidOutHalf & ~VscOutFIFOFull;

always @(negedge nRST or posedge Clk)
	if  	(!nRST) 		VscOutFIFOWrData <= 0;
	else					VscOutFIFOWrData <= ScaleOut;

//ScFIFO2048x16 #(11, 1024, 16) VscOutFIFO(
ScFIFO2048x16 #(11, 2048-8, 16) VscOutFIFO(
			.Clk			(Clk), 
			.nRST			(nRST), 
			.FIFOFlush		(FIFOClear), 
			.FIFOWrData		(VscOutFIFOWrData), 
			.FIFOWrite		(VscOutFIFOWrite), 
			.FIFORdData		(VscOutFIFORdData), 
			.FIFORead		(VscOutFIFORead),
			.FIFOHalfFull	(VscOutFIFOHalfFull), 
			.FIFOAlmostFull	(VscOutFIFOAlmostFull),
			.FIFOFull		(VscOutFIFOFull), 
			.FIFOEmptyWr	(),
			.FIFOAlmostEmpty(VscOutFIFOAlmostEmpty),
			.FIFOEmpty		(VscOutFIFOEmpty)
);

assign iVscOutFIFORead = (tFDReq | tFRead) & ~VscOutFIFOEmpty;
assign VscOutFIFORead  = iVscOutFIFORead;

always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStF <= F_IDLE;
  	else if (FIFOClear)
  				CurStF <= F_IDLE;
  	else        CurStF <= NxtStF;

assign GoFDataRequest = (DnScaleAct & ~VidFIFOHalfFull & 
						(VscOutFIFOAlmostEmpty | 
						(~VscOutFIFOEmpty & ScaleOutYCount == VPlaneYSize-1))) |

					    (UpScaleAct & ~VidFIFOHalfFull & 
					    (VscOutFIFOHalfFull    | 
//					    (~VscOutFIFOEmpty & ScaleOutYCount != 0 & UpYCountIsZero)));
					    (~VscOutFIFOEmpty & ScaleOutYCount != 0 & (UpYCountIsZero | VscOutFIFOAlmostEmpty))));

always @(tFIdle or tFDReq or tFRead or GoFDataRequest) begin
  	NxtStF = F_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tFIdle  : 	if (GoFDataRequest)	NxtStF = F_DREQ;
  	  	          	else        		NxtStF = F_IDLE;
                                        	
  	  	tFDReq  : 						NxtStF = F_READ;

  	  	tFRead  : 	if (GoFDataRequest)	NxtStF = F_DREQ;
  	  	          	else				NxtStF = F_IDLE;
                                        	
  	  	default :               		NxtStF = F_IDLE;
  	endcase
end

assign ScaleOutEnDis = ScaleOutYEnd | FIFOClear;
assign ScaleOutEnEna = VPlaneEn & (DnScaleEn | UpScaleEn) & FrameStart;
always @(negedge nRST or posedge Clk)
	if      (!nRST)   		ScaleOutEn <= 0;
	else if (ScaleOutEnDis) ScaleOutEn <= 0;
	else if (ScaleOutEnEna)	ScaleOutEn <= 1;
	else					ScaleOutEn <= ScaleOutEn;

assign ScaleOutXEnd = (ScaleOutXCount == VPlaneXSize-1) | FIFOClear;
assign ScaleOutXInc = iVscOutFIFORead;//(tFDReq | tFRead) & ScaleOutEn;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		ScaleOutXCount <= 0;
	else if (ScaleOutXEnd) 	ScaleOutXCount <= 0;
	else if (ScaleOutXInc)	ScaleOutXCount <= ScaleOutXCount + 1;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   		ScaleOutYCount <= 0;
	else if (ScaleOutYEnd) 	ScaleOutYCount <= 0;
	else if (ScaleOutXEnd) 	ScaleOutYCount <= ScaleOutYCount + 1;

assign ScaleOutYEnd   = (ScaleOutYCount == VPlaneYSize) | FIFOClear;
//-------------------------------------------------------------------------------
// Format Converter 422 to 444
// 2 Clock Delay
assign VidFCValidIn = BpScaleEn ? FSMValidIn : iVscOutFIFORead;
assign VidFCIn      = BpScaleEn ? FSMIn      : VscOutFIFORdData;
`else
assign VidFCValidIn = FSMValidIn;
assign VidFCIn      = FSMIn;
`endif

VideoFC VideoFC(
			.Clk			(Clk),
			.nRST			(nRST),
			.ValidIn		(VidFCValidIn),
			.Yin			(VidFCIn[15:8]),
			.Cin			(VidFCIn[7:0]),
			.ValidOut		(VidFCValidOut),
			.Yout			(VidFCOut[23:16]),
			.CbOut			(VidFCOut[15: 8]),
			.CrOut			(VidFCOut[ 7: 0])
);
//-------------------------------------------------------------------------------
// Video Color Space Converter
assign VidCSCIn      = VidFCOut;
assign VidCSCValidIn = VidFCValidOut;

// 1 Clock Delay
VideoCSC VideoCSC(
			.Clk  			(Clk),
			.nRST 			(nRST),
			.ValidIn		(VidCSCValidIn),
			.Yin  			(VidCSCIn[23:16]),
			.Cbin 			(VidCSCIn[15: 8]),
			.Crin 			(VidCSCIn[ 7: 0]),
			.ValidOut		(VidCSCValidOut),
			.Rout 			(VidCSCOut[23:16]),
			.Gout 			(VidCSCOut[15: 8]),
			.Bout 			(VidCSCOut[ 7: 0])
);
//-------------------------------------------------------------------------------
// Video Gamma
// 1 Clock Delay
assign VPlaneGammaValidIn = VidCSCValidOut;
assign VPlaneGammaIn      = VidCSCOut;

PlaneGamma VPlaneGamma( 
			.Clk 			(Clk), 
			.nRST			(nRST),
			.GammaEn		(VPlaneGammaEn),
			.RegGamma10		(VPlaneGamma10), 
			.RegGamma0F		(VPlaneGamma0F), 
			.RegGamma0E		(VPlaneGamma0E), 
			.RegGamma0D		(VPlaneGamma0D), 
			.RegGamma0C		(VPlaneGamma0C), 
		 	.RegGamma0B		(VPlaneGamma0B), 
		 	.RegGamma0A		(VPlaneGamma0A), 
		 	.RegGamma09		(VPlaneGamma09), 
		 	.RegGamma08		(VPlaneGamma08), 
		 	.RegGamma07		(VPlaneGamma07), 
		 	.RegGamma06		(VPlaneGamma06), 
		 	.RegGamma05		(VPlaneGamma05), 
		 	.RegGamma04		(VPlaneGamma04), 
		 	.RegGamma03		(VPlaneGamma03), 
		 	.RegGamma02		(VPlaneGamma02), 
		 	.RegGamma01		(VPlaneGamma01), 
		 	.RegGamma00		(VPlaneGamma00),
		 	
		 	.GammaValidIn	(VPlaneGammaValidIn),
		 	.RGammaIn 		(VPlaneGammaIn[23:16]),  
		 	.GGammaIn 		(VPlaneGammaIn[15: 8]),  
		 	.BGammaIn 		(VPlaneGammaIn[ 7: 0]),
		 	.GammaValidOut	(VPlaneGammaValidOut),
		 	.RGammaOut		(VPlaneGammaOut[23:16]), 
		 	.GGammaOut		(VPlaneGammaOut[15: 8]), 
		 	.BGammaOut		(VPlaneGammaOut[ 7: 0])
);

assign VidFIFOWrite = VPlaneGammaValidOut & ~VidFIFOFull;

always @(VPlaneAlphaMode or VPlaneAlphaValue)
	case(VPlaneAlphaMode) // synpsys parallel_case
		2'b00   : VPlaneGammaAlpha = 8'hFF;			// No Alpha
		default : VPlaneGammaAlpha = VPlaneAlphaValue;	// Global Alpha
	endcase

assign VidFIFOWrData = {VPlaneGammaAlpha, VPlaneGammaOut};
//-------------------------------------------------------------------------------
// 64x32 Depth, -7(16bit mode(2) + fc(2) + csc(2) + gamma(1)) Half Full : current version
ScFIFO64x32 #(6, 7, 32) VideoFIFO(
			.Clk			(Clk), 
			.nRST			(nRST), 
			.FIFOFlush		(FIFOClear), 
			.FIFOWrData		(VidFIFOWrData), 
			.FIFOWrite		(VidFIFOWrite), 
			.FIFORdData		(VidFIFORdData), 
			.FIFORead		(VidFIFORead),
			.FIFOHalfFull	(VidFIFOHalfFull), 
			.FIFOFull		(VidFIFOFull), 
			.FIFOEmptyWr	(),
			.FIFOAlmostEmpty(VidFIFOAlmostEmpty),
			.FIFOEmpty		(VidFIFOEmpty)
);

assign VidFIFORead = VPlaneDataRequest & ~VidFIFOEmpty;
assign VPlaneDataValid = VidFIFORead;
assign VPlaneDataIn = VidFIFORdData;
//-------------------------------------------------------------------------------
`ifdef SCALER
assign VidFIFOOverRun  = ScaleOutEn & VPlaneGammaValidOut & VidFIFOFull;
assign VidFIFOUnderRun = ScaleOutEn & VPlaneDataRequest & VidFIFOEmpty;
assign VPlaneDataHold  = ScaleOutEn & VidFIFOAlmostEmpty;
`else
assign VidFIFOOverRun  = VideoEn & VPlaneGammaValidOut & VidFIFOFull;
assign VidFIFOUnderRun = VideoEn & VPlaneDataRequest & VidFIFOEmpty;
assign VPlaneDataHold  = VideoEn & VidFIFOAlmostEmpty;
`endif
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(VidFIFOUnderRun or VidFIFOOverRun)
	if(VidFIFOUnderRun || VidFIFOOverRun) begin
		$display("%m ERROR: Video Plane FIFO Error (%t)",$time);
		$stop;
	end

`ifdef SCALER
wire VscOutFIFOOverRun  = ScaleValidOutHalf & VscOutFIFOFull;
wire VscOutFIFOUnderRun = (tFDReq | tFRead) & VscOutFIFOEmpty;

always @(VscOutFIFOOverRun or VscOutFIFOUnderRun)
	if(VscOutFIFOOverRun || VscOutFIFOUnderRun) begin
		$display("%m ERROR: Video Scaler FIFO Error (%t)",$time);
		//$stop;
	end

integer ScaleOutCount;
always @(negedge nRST or posedge Clk)
	if  	(!nRST) 			ScaleOutCount <= 0;
	else if (ScaleOutCount==VPlaneXSize-1)			ScaleOutCount <= 0;
	else if (VPlaneDataValid)	ScaleOutCount <= ScaleOutCount + 1;
`endif
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
endmodule
