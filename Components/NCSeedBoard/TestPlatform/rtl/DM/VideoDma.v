
`timescale 1ns/1ns

module VideoDma(
				Clk, 
				nRST,
				FIFOClear,
				VPlaneEn,
				VPlaneInterlaceEn,
				FrameStart,
				
				VPlaneStartAddr,
				VPlaneStartAddr2,
				VPlaneXSize,
				VPlaneYSize,
				VPlaneXStart,
				VPlaneYStart,
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
input			FrameStart;
			
// Plane X/Y Cordinate
input [AW:0] 	VPlaneStartAddr;
input [AW:0] 	VPlaneStartAddr2;
input [XW:0] 	VPlaneXSize;	// max 2048x2048
input [YW:0] 	VPlaneYSize;
input [XW:0] 	VPlaneXStart;
input [YW:0] 	VPlaneYStart;
input [ 9:0] 	VPlaneXRef;

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

// Video Plane
wire 			VideoDmaEn;
wire		 	VDMADataRequest;

// Video Count
reg [YW:0] 		YDmaReqCnt;
reg [XW:0] 		XDmaReqCnt;
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
wire [XW:0]	VPlaneXStartRef;
wire [11:0] VPlaneXRefM4;
wire [11:0] VPlaneXRefRef;

assign VPlaneXRefM4    = {VPlaneXRef, 2'b0};
assign VPlaneXStartRef = {1'b0, VPlaneXStart[XW:1]};
assign VPlaneXRefRef   = {1'b0, VPlaneXRefM4[11:1]};

assign VideoDmaEn = VPlaneEn & FrameStart;
assign VDMARCmd = tVDReq;
wire   VDMAEnd  = YDmaReqCnt == VPlaneYSize;
always @(negedge nRST or posedge Clk)
	if 		(!nRST)	VDMAEn <= 0;
	else if (VDMAEnd | FIFOClear)
					VDMAEn <= 0;
	else if (VideoDmaEn)
					VDMAEn <= 1;
	else			VDMAEn <= VDMAEn;

wire [AW:0] VDMAStartAddr0 = VPlaneXStartRef + (VPlaneYStart * VPlaneXRefRef);

reg  [AW:0] VDMAStartAddr1;
reg  [AW:0] VDMAStartAddr2;

always @(negedge nRST or posedge Clk)
	if 		(!nRST) VDMAStartAddr1 <= 0;
	else			VDMAStartAddr1 <= VPlaneStartAddr  + VDMAStartAddr0;

always @(negedge nRST or posedge Clk)
	if 		(!nRST) VDMAStartAddr2 <= 0;
	else			VDMAStartAddr2 <= VPlaneStartAddr2 + VDMAStartAddr0;

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
	else if (tVIdle & VideoDmaEn) begin // Initial Load Register Value
					BurstSiz 	<= VPlaneMaxBL;
					VDMARAddr1  <= VDMAStartAddr1;
					VDMARAddr2  <= VDMAStartAddr2;
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
		if (LineSel)VDMARAddr2 	<= VDMARAddr2 + VPlaneXStartRef;
		else		VDMARAddr1 	<= VDMARAddr1 + VPlaneXStartRef;

					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= YDmaReqCnt+1;
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
    else if (VDMADataValid)	BurstCnt <= BurstCnt + 1;

DmaBLQ #(VBLQCD, VBLQD, VBLQW) VDMAVBLQ(
			.nRST		(nRST), 
			.Clk		(Clk), 
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

ScFIFO64x32 #(6, VPlaneMaxBL*3, DW+1) VideoFIFO(
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

assign VidFIFORead = VDMADataRequest & ~VidFIFOEmpty & ~(VidFIFOWrite & VidFIFOAlmostEmpty);
assign VDMADataValid = VidFIFORead;
assign VDMADataIn = VidFIFORdData;
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