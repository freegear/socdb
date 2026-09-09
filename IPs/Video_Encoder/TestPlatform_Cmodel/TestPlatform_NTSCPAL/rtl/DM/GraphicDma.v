
`timescale 1ns/1ns

module GraphicDma(
				Clk, 
				nRST,
				FIFOClear,
				GPlaneEn,
				FrameStart,
				
				GPlaneStartAddr,
				GPlaneXSize,
				GPlaneYSize,
				GPlanePixFormat,
				GPlaneXStart,
				GPlaneYStart,
				GPlaneXRef,

				GDMARDataValid,
				GDMARLast,
				GDMARData,
				GDMARCmd,
				GDMARCmdAck,
				GDMARBurstLen,
				GDMARAddr,
								
				GDMADataRequest,
				GDMADataValid,
				GDMADataIn,
				
				GDMAOverRun,
				GDMAUnderRun
);

`include "DmPara.v"

// System
input			Clk; 
input			nRST;
input			FIFOClear;
input			GPlaneEn;
input			FrameStart;
			
// Plane X/Y Cordinate
input [AW:0] 	GPlaneStartAddr;
input [XW:0] 	GPlaneXSize;	// max 2048x2048
input [YW:0] 	GPlaneYSize;
input [ 2:0]	GPlanePixFormat;	// 0: 8bit, 2: RGB565, 3:ARGB1555, 4:RGB888, 5:ARGB8888
input [ 9:0]	GPlaneXRef;
input [XW:0]	GPlaneXStart;
input [YW:0]	GPlaneYStart;

// Graphic DMA
input			GDMARDataValid;
input			GDMARLast;
input [DW:0]	GDMARData;
input			GDMARCmdAck;
output			GDMARCmd;
output [ 4:0]	GDMARBurstLen;
output [AW:0]	GDMARAddr;

// Graphic DMA FIFO
input		 	GDMADataRequest;
output		 	GDMADataValid;
output [DW:0] 	GDMADataIn;

output			GDMAOverRun;
output			GDMAUnderRun;
//-------------------------------------------------------------------------------
parameter G_IDLE = 4'b0001;
parameter G_DREQ = 4'b0010;
parameter G_DCAL = 4'b0100;
parameter G_DEND = 4'b1000;

reg [3:0]  CurStG, NxtStG;

wire  tGIdle  = CurStG[0];
wire  tGDReq  = CurStG[1];
wire  tGDCal  = CurStG[2];
wire  tGDEnd  = CurStG[3];

// Graphic Plane
wire 			GraphicDmaEn;
wire		 	GDMADataRequest;

// Graphic Count
reg [YW:0] 		YDmaReqCnt;
reg [XW:0] 		XDmaReqCnt;
reg [ 3:0] 		BurstSiz;

wire 			GBLQWrite, GBLQRead;
wire 			iGBLQRead;
wire 			GBLQHFull, GBLQQFull;
wire 			GBLQFull;
wire 			GBLQEmpty;
wire [GBLQW:0]	GBLQWrData = BurstSiz;
wire [GBLQW:0]	GBLQRdData;
reg  [3:0] 		BurstCnt;
wire  			BurstEnd;

// Graphic DMA
wire 			GDMARCmd;
reg  [ 4:0]		GDMARBurstLen;
reg  [AW:0]		GDMARAddr;

// Graphic DMA FIFO
reg				GDMARDataValidD;
wire  			GraFIFOWrite;
reg  [DW:0] 	GraFIFOWrData;
wire			GraFIFORead;
wire [DW:0] 	GraFIFORdData;

wire			GraFIFOAlmostEmpty;
wire			GraFIFOEmpty;
wire			GraFIFOFull;
wire			GraFIFOHalfFull;

wire			ReqMask = GPlanePixFormat[0] ? ~GBLQQFull : // 8bit
						  GPlanePixFormat[1] ? ~GBLQHFull : // 16bit
						   					   ~GBLQFull  ; // 32bit
reg 			GDMAEn;
wire			GoDMARequest = ReqMask & GDMAEn;
wire			XDmaReqEnd   = XDmaReqCnt == GPlaneXSize;
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStG <= G_IDLE;
  	else if (FIFOClear)
  				CurStG <= G_IDLE;
  	else        CurStG <= NxtStG;

always @(tGIdle or tGDReq or tGDCal or tGDEnd or GDMAEn or
		GraphicDmaEn or GoDMARequest or GDMARCmdAck or XDmaReqEnd) begin
  	NxtStG = G_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tGIdle  : 	if (GraphicDmaEn)		NxtStG = G_DCAL;
  	  	          	else        			NxtStG = G_IDLE;

		tGDCal	:	if (!GDMAEn)			NxtStG = G_IDLE;
  	  				else if (XDmaReqEnd)	NxtStG = G_DEND;
  	  				else if (GoDMARequest)	NxtStG = G_DREQ;
  	  				else					NxtStG = G_DCAL;

  	  	tGDReq  : 	if (GDMARCmdAck) 		NxtStG = G_DCAL;
  	  				else					NxtStG = G_DREQ;

  	  	tGDEnd  : 	if (!GDMAEn)			NxtStG = G_IDLE;
  	  				else 					NxtStG = G_DCAL;

  	  	default :               			NxtStG = G_IDLE;
  	endcase
end
//-------------------------------------------------------------------------------
reg  [XW:0]		GPlaneXStartRef;
wire [11:0] 	GPlaneXRefM4;
reg  [11:0] 	GPlaneXRefRef;

always @(GPlanePixFormat or GPlaneXStart)
	case(1'b1) // synopsys parallel_case
		GPlanePixFormat[1] 	: GPlaneXStartRef = {1'b0, GPlaneXStart[XW:1]}; // 16bit, /2
		GPlanePixFormat[0]  : GPlaneXStartRef = {2'b0, GPlaneXStart[XW:2]}; // 8bit, /4
		default 			: GPlaneXStartRef =  	   GPlaneXStart[XW:0] ; // 32bit
	endcase

assign GPlaneXRefM4 = {GPlaneXRef, 2'b0};

always @(GPlanePixFormat or GPlaneXRefM4)
	case(1'b1) // synopsys parallel_case
		GPlanePixFormat[1] 	: GPlaneXRefRef = {1'b0, GPlaneXRefM4[11:1]}; // 16bit, /2
		GPlanePixFormat[0]  : GPlaneXRefRef = {2'b0, GPlaneXRefM4[11:2]}; // 8bit, /4
		default 			: GPlaneXRefRef = {	     GPlaneXRefM4[11:0]} ; // 32bit
	endcase

reg [AW:0] GDMAStartAddr;
always @(negedge nRST or posedge Clk)
	if 		(!nRST) GDMAStartAddr <= 0;
	else			GDMAStartAddr <= GPlaneStartAddr + GPlaneXStartRef + (GPlaneYStart * GPlaneXRefRef);

assign GraphicDmaEn = GPlaneEn & FrameStart;
assign GDMARCmd = tGDReq;
wire   GDMAEnd  = YDmaReqCnt == GPlaneYSize;

always @(negedge nRST or posedge Clk)
	if 		(!nRST)	GDMAEn <= 0;
	else if (GDMAEnd | FIFOClear)
					GDMAEn <= 0;
	else if (GraphicDmaEn)
					GDMAEn <= 1;
	else			GDMAEn <= GDMAEn;

always @(negedge nRST or posedge Clk)
begin
	if 		(!nRST) begin
					BurstSiz 	<= 0;
					GDMARAddr  	<= 0;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= 0;
	end
	else if (tGIdle & GraphicDmaEn) begin // Initial Load Register Value
					BurstSiz 	<= GPlaneMaxBL;
					GDMARAddr   <= GDMAStartAddr;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= 0;
	end
	else if (tGDCal) begin
		if (GPlaneXSize-XDmaReqCnt > GPlaneMaxBL)
					BurstSiz 	<= GPlaneMaxBL;
		else 		BurstSiz 	<= GPlaneXSize-XDmaReqCnt;
	end
	else if (tGDReq & GDMARCmdAck) begin
		if (BurstSiz == 0)	
					GDMARAddr  	<= GDMARAddr + 1;
		else 		GDMARAddr  	<= GDMARAddr + BurstSiz;
					XDmaReqCnt	<= XDmaReqCnt + BurstSiz;
	end
	else if (tGDEnd) begin
					GDMARAddr  	<= GDMARAddr + GPlaneXStartRef;
					XDmaReqCnt 	<= 0;
					YDmaReqCnt	<= YDmaReqCnt+1;
	end
	else if (GDMAEnd)YDmaReqCnt <= 0;
end

always @(BurstSiz)
	if (BurstSiz == 0)	GDMARBurstLen = 0;
	else				GDMARBurstLen = {BurstSiz, 2'b0} - 1;	// 32bit Access
//-------------------------------------------------------------------------------
assign GBLQWrite  = ~GBLQFull  & tGDReq & GDMARCmdAck;
assign iGBLQRead  = ~GBLQEmpty & BurstEnd;
assign GBLQRead   = iGBLQRead;
assign BurstEnd   = GDMADataValid & (BurstCnt == GBLQRdData -1);

always@(negedge nRST or posedge Clk)
    if      (!nRST)  		BurstCnt <= 0;
    else if (iGBLQRead) 	BurstCnt <= 0;
    else if (GDMADataValid)	BurstCnt <= BurstCnt + 1;

DmaBLQ #(GBLQCD, GBLQD, GBLQW) GDMAGBLQ(
			.nRST		(nRST), 
			.Clk		(Clk), 
			.WriteEn	(GBLQWrite), 
			.ReadEn		(GBLQRead), 
			.WrData		(GBLQWrData), 
			.RdData		(GBLQRdData), 
			.HFullFlag	(GBLQHFull),
			.QFullFlag	(GBLQQFull),
			.FullFlag	(GBLQFull), 
			.EmptyFlag	(GBLQEmpty)
);
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
	if  (!nRST)	GDMARDataValidD <= 0;
	else		GDMARDataValidD <= GDMARDataValid;

assign GraFIFOWrite = GDMARDataValidD & ~GraFIFOFull;

always @(negedge nRST or posedge Clk)
	if  (!nRST)	GraFIFOWrData <= 0;
	else 		GraFIFOWrData <= GDMARData;

ScFIFO64x32 #(6, GPlaneMaxBL, DW+1) GraphicFIFO( // should be GPlaneMaxBL*8-1, if palette applied
			.Clk			(Clk), 
			.nRST			(nRST), 
			.FIFOFlush		(FIFOClear), 
			.FIFOWrData		(GraFIFOWrData), 
			.FIFOWrite		(GraFIFOWrite), 
			.FIFORdData		(GraFIFORdData), 
			.FIFORead		(GraFIFORead),
			.FIFOHalfFull	(GraFIFOHalfFull), 
			.FIFOFull		(GraFIFOFull), 
			.FIFOEmptyWr	(),
			.FIFOAlmostEmpty(GraFIFOAlmostEmpty),
			.FIFOEmpty		(GraFIFOEmpty)
);

assign GraFIFORead = GDMADataRequest & ~GraFIFOEmpty & ~(GraFIFOWrite & GraFIFOAlmostEmpty);
assign GDMADataValid = GraFIFORead;
assign GDMADataIn = GraFIFORdData;
//-------------------------------------------------------------------------------
assign GDMAOverRun  = GDMARDataValid  & GraFIFOFull;
assign GDMAUnderRun = GDMADataRequest & GraFIFOEmpty;
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(GDMAOverRun)
	if(GDMAOverRun) begin
		$display("%m ERROR: Graphic Plane DMA FIFO Error (%t)",$time);
		$stop;
	end

integer BLQWrCount, BLQRdCount;
always @(negedge nRST or posedge Clk)
	if 		(!nRST) 	BLQWrCount <= 0;
	else if (GBLQWrite) BLQWrCount <= BLQWrCount+1;

always @(negedge nRST or posedge Clk)
	if 		(!nRST) 	BLQRdCount <= 0;
	else if (GBLQRead) 	BLQRdCount <= BLQRdCount+1;

integer ReadExceedWrite;
always @(negedge nRST or posedge Clk)
	if 		(!nRST) 			ReadExceedWrite <= 0;
	else if (GDMARDataValid) 	ReadExceedWrite <= ReadExceedWrite+1;

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
endmodule