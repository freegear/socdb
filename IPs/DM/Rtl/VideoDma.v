
`timescale 1ns/1ns

module VideoDma(
				Clk, 
				nRST,
				FIFOClear,
				VPlaneEn,
				VPlaneInterlaceEn,
				VPlaneN2PUpEn,
				FrameStart,
`ifdef BYPASS
				VideoBPEn,
				VIFDataRequest,
				VIFDataValid,
				VIFDataIn,
`endif							
				VPlaneStartAddr,
				VPlaneStartAddr2,
				VPlaneXSize,
				VPlaneYSize,
				VPlaneXRef,

				VDMARDataValid,
				VDMARLast,
				VDMARData,
				VDMARCmd,
				VDMARCmdAck,
				VDMARBurstLen,
				VDMARAddr,
								
				VDMADataRequest,
				VDMADataValid,
				VDMADataIn,
				VideoEn,
				
				VDMAOverRun,
				VDMAUnderRun
);

`include "DmPara.v"

// System
input			Clk; 
input			nRST;
input			FIFOClear;
input			VPlaneEn;
input			VPlaneInterlaceEn;
input			VPlaneN2PUpEn;
input			FrameStart;

`ifdef BYPASS
// External Video Interface
input			VideoBPEn;
output			VIFDataRequest;
input			VIFDataValid;
input  [DW:0] 	VIFDataIn;
`endif

// Plane X/Y Cordinate
input [AW:0] 	VPlaneStartAddr;
input [AW:0] 	VPlaneStartAddr2;
input [VW:0] 	VPlaneXSize;	// max 2048x2048
input [VW:0] 	VPlaneYSize;
input [VW+1:0] 	VPlaneXRef;

// Video DMA
input			VDMARDataValid;
input			VDMARLast;
input [DW:0]	VDMARData;
input			VDMARCmdAck;
output			VDMARCmd;
output [ 4:0]	VDMARBurstLen;
output [AW:0]	VDMARAddr;

// Video DMA FIFO
input		 	VDMADataRequest;
output		 	VDMADataValid;
output [DW:0] 	VDMADataIn;
input			VideoEn;

output			VDMAOverRun;
output			VDMAUnderRun;
//-------------------------------------------------------------------------------
parameter V_IDLE = 4'b0001;
parameter V_DREQ = 4'b0010;
parameter V_DCAL = 4'b0100;
parameter V_DEND = 4'b1000;

reg [3:0]  CurStV, NxtStV;

wire  tVIdle  = CurStV[0];
wire  tVDReq  = CurStV[1];
wire  tVDCal  = CurStV[2];
wire  tVDEnd  = CurStV[3];

`ifdef BYPASS
reg				VideoBPEnACLK0;
reg				VideoBPEnACLK;
`endif

// Video Plane
wire 			VideoDmaEn;
wire		 	VDMADataRequest;

// Video Count
reg [ 2:0]		N2PUpCnt;	// NTSC480 to PAL576 Up Scale Count 5 -> 6, insert 1 line each 6 line
wire			N2PUpCntEnd   = N2PUpCnt == 6;
wire			N2PUpAddrHold = N2PUpCnt == 5;

reg [VW:0] 		YDmaReqCnt;
reg [VW:0] 		XDmaReqCnt;
reg [ 3:0] 		BurstSiz;
reg				LineSel;

wire 			VBLQWrite, VBLQRead;
wire 			iVBLQRead;
wire 			VBLQHFull, VBLQQFull;
wire 			VBLQFull;
wire 			VBLQEmpty;
wire [VBLQW:0]	VBLQWrData = BurstSiz;
wire [VBLQW:0]	VBLQRdData;
reg  [3:0] 		BurstCnt;
wire  			BurstEnd;

// Video DMA
wire 			VDMARCmd;
reg  [ 4:0]		VDMARBurstLen;
reg  [AW:0]		VDMARAddr1;
reg  [AW:0]		VDMARAddr2;

// Video DMA FIFO
reg				VDMARDataValidD;
wire  			VidFIFOWrite;
reg  [DW:0] 	VidFIFOWrData;
wire			VidFIFORead;
wire [DW:0] 	VidFIFORdData;

wire			VidFIFOAlmostEmpty;
wire			VidFIFOEmpty;
wire			VidFIFOFull;
wire			VidFIFOHalfFull;

wire			ReqMask = ~VBLQHFull; // 16bit
reg 			VDMAEn;
wire			GoDMARequest = ReqMask & VDMAEn;
wire			XDmaReqEnd   = XDmaReqCnt == VPlaneXSize;
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStV <= V_IDLE;
  	else if (FIFOClear)
  				CurStV <= V_IDLE;
  	else        CurStV <= NxtStV;

always @(tVIdle or tVDReq or tVDCal or tVDEnd or VDMAEn or
		VideoDmaEn or GoDMARequest or VDMARCmdAck or XDmaReqEnd) begin
  	NxtStV = V_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tVIdle  : 	if (VideoDmaEn)			NxtStV = V_DCAL;
  	  	          	else        			NxtStV = V_IDLE;

		tVDCal	:	if (!VDMAEn)			NxtStV = V_IDLE;
  	  				else if (XDmaReqEnd)	NxtStV = V_DEND;
  	  				else if (GoDMARequest)	NxtStV = V_DREQ;
  	  				else					NxtStV = V_DCAL;

  	  	tVDReq  : 	if (VDMARCmdAck) 		NxtStV = V_DCAL;
  	  				else					NxtStV = V_DREQ;

  	  	tVDEnd  : 	if (!VDMAEn)			NxtStV = V_IDLE;
  	  				else 					NxtStV = V_DCAL;

  	  	default :               			NxtStV = V_IDLE;
  	endcase
end
//-------------------------------------------------------------------------------
assign VideoDmaEn = VPlaneEn & FrameStart;
assign VDMARCmd = tVDReq;
wire   VDMAEnd  = YDmaReqCnt == VPlaneYSize;

always @(negedge nRST or posedge Clk)
	if 		(!nRST)	VDMAEn <= 0;
`ifdef BYPASS
	else if (VDMAEnd | FIFOClear | VideoBPEnACLK)	// DMA should not enabled at bypass mode
`else
	else if (VDMAEnd | FIFOClear)
`endif
					VDMAEn <= 0;
	else if (VideoDmaEn)
					VDMAEn <= 1;
	else			VDMAEn <= VDMAEn;

always @(negedge nRST or posedge Clk)
	if 		(!nRST) begin
					N2PUpCnt	<= 0;
	end
	else if (FIFOClear | (tVIdle & VideoDmaEn) | N2PUpCntEnd) begin
					N2PUpCnt	<= 0;
	end
	else if (tVDCal & XDmaReqEnd) begin
		if (VPlaneN2PUpEn)
					N2PUpCnt	<= N2PUpCnt + 1;
	end

always @(negedge nRST or posedge Clk)
begin
	if 		(!nRST) begin
					BurstSiz 	<= 0;
					VDMARAddr1 	<= 0;
					VDMARAddr2 	<= 0;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= 0;
					LineSel 	<= 0;
	end
	else if (FIFOClear) begin
					BurstSiz 	<= 0;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= 0;
	end
	else if (tVIdle & VideoDmaEn) begin // Initial Load Register Value
					BurstSiz 	<= VPlaneMaxBL;
					VDMARAddr1  <= VPlaneStartAddr;
					VDMARAddr2  <= VPlaneStartAddr2;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= 0;
					LineSel 	<= 0;
	end
	else if (tVDCal) begin
		if (VPlaneXSize-XDmaReqCnt > VPlaneMaxBL)
					BurstSiz 	<= VPlaneMaxBL;
		else 		BurstSiz 	<= VPlaneXSize-XDmaReqCnt;
	end
	else if (tVDReq & VDMARCmdAck) begin
		if (BurstSiz == 0) begin	
			if (LineSel)		
					VDMARAddr2 	<= VDMARAddr2 + 1;
			else	VDMARAddr1 	<= VDMARAddr1 + 1;
		end
		else begin
			if (LineSel)		
					VDMARAddr2 	<= VDMARAddr2 + BurstSiz;
			else	VDMARAddr1 	<= VDMARAddr1 + BurstSiz;
		end
					XDmaReqCnt	<= XDmaReqCnt + BurstSiz;
	end
	else if (tVDEnd) begin
		if (LineSel) begin
			if (N2PUpAddrHold)
					//VDMARAddr2 	<= VDMARAddr2 + VPlaneXRef - (VPlaneXSize + VPlaneXRef);
					VDMARAddr2 	<= VDMARAddr2 - VPlaneXSize;
			else
					VDMARAddr2 	<= VDMARAddr2 + VPlaneXRef;
		end
		else begin
			if (N2PUpAddrHold)
					//VDMARAddr1 	<= VDMARAddr1 + VPlaneXRef - (VPlaneXSize + VPlaneXRef);
					VDMARAddr1 	<= VDMARAddr1 - VPlaneXSize;
			else
					VDMARAddr1 	<= VDMARAddr1 + VPlaneXRef;
		end

					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= YDmaReqCnt + 1;
		if (VPlaneInterlaceEn)
					LineSel 	<= LineSel + 1;
	end
	else if (VDMAEnd) begin
					YDmaReqCnt 	<= 0;
					LineSel 	<= 0;
	end 
end

always @(BurstSiz)
	if (BurstSiz == 0)	VDMARBurstLen = 0;
	else				VDMARBurstLen = {BurstSiz, 2'b0} - 1;	// 32bit Access

assign VDMARAddr = LineSel ? VDMARAddr2 : VDMARAddr1;
//-------------------------------------------------------------------------------
assign VBLQWrite  = ~VBLQFull  & tVDReq & VDMARCmdAck;
assign iVBLQRead  = ~VBLQEmpty & BurstEnd;
assign VBLQRead   = iVBLQRead;
assign BurstEnd   = VDMADataValid & (BurstCnt == VBLQRdData -1);

always@(negedge nRST or posedge Clk)
    if      (!nRST)  		BurstCnt <= 0;
    else if (iVBLQRead) 	BurstCnt <= 0;
`ifdef BYPASS
    else if (VDMADataValid & ~VideoBPEnACLK)
`else
    else if (VDMADataValid)
`endif
    						BurstCnt <= BurstCnt + 1;

DmaBLQ #(VBLQCD, VBLQD, VBLQW) VDMAVBLQ(
			.nRST		(nRST), 
			.Clk		(Clk), 
			.Flush		(FIFOClear | ~VideoEn),
			.WriteEn	(VBLQWrite), 
			.ReadEn		(VBLQRead), 
			.WrData		(VBLQWrData), 
			.RdData		(VBLQRdData), 
			.HFullFlag	(VBLQHFull),
			.QFullFlag	(VBLQQFull),
			.FullFlag	(VBLQFull), 
			.EmptyFlag	(VBLQEmpty)
);
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
	if  (!nRST)	VDMARDataValidD <= 0;
	else		VDMARDataValidD <= VDMARDataValid;

assign VidFIFOWrite = VDMARDataValidD & ~VidFIFOFull;

always @(negedge nRST or posedge Clk)
	if  (!nRST)	VidFIFOWrData <= 0;
	else 		VidFIFOWrData <= VDMARData;

`ifdef SCALER
ScFIFO64x32 #(6, VPlaneMaxBL*3, DW+1) VideoFIFO(
`else
//ScFIFO32x32 #(5, VPlaneMaxBL*3, DW+1) VideoFIFO(
ScFIFO64x32 #(6, VPlaneMaxBL*3, DW+1) VideoFIFO(
`endif
			.Clk			(Clk), 
			.nRST			(nRST), 
			.FIFOFlush		(FIFOClear | ~VideoEn), 
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
//-------------------------------------------------------------------------------
assign VidFIFORead   = VDMADataRequest & ~VidFIFOEmpty & ~(VidFIFOWrite & VidFIFOAlmostEmpty);
//-------------------------------------------------------------------------------
`ifdef BYPASS
// External Video Mode
always @(negedge nRST or posedge Clk)
	if (!nRST) 	VideoBPEnACLK0 <= 0;
	else		VideoBPEnACLK0 <= VideoBPEn;

always @(negedge nRST or posedge Clk)
	if (!nRST) 	VideoBPEnACLK <= 0;
	else		VideoBPEnACLK <= VideoBPEnACLK0;

assign VIFDataRequest = VideoBPEnACLK & VDMADataRequest;

assign VDMADataValid  = VideoBPEnACLK ? VIFDataValid : VidFIFORead;
assign VDMADataIn     = VideoBPEnACLK ? VIFDataIn    : VidFIFORdData;
`else
assign VDMADataValid  = VidFIFORead;
assign VDMADataIn     = VidFIFORdData;
`endif
//-------------------------------------------------------------------------------
assign VDMAOverRun  = VDMARDataValid  & VidFIFOFull;
assign VDMAUnderRun = VDMADataRequest & VidFIFOEmpty;
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(VDMAOverRun)
	if(VDMAOverRun) begin
		$display("%m ERROR: Video Plane DMA FIFO Error (%t)",$time);
		$stop;
	end
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
endmodule