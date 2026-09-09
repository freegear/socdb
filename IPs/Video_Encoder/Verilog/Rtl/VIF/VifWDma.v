`timescale 1ns/10ps

module VifWDma(
	nRST		,
	Clk			,
	HSize		,
	VSize		,
	WrOffset,
	FIFOClear	,

	FIFOEmpty, FIFOHalfFull,
	FIFORead, FIFORdData,
	
	DmaEn,
	DmaEnable	,
	DmaStart	,

	DmaAdr,
	DmaDat		,
	DmaReq		,
	DmaLen		,
	DmaBeb		,
	DmaRdy,
	DmaBusy
);

`include "VifPara.v"

// System
input	nRST;
input	Clk;

input	[ImageSize-1:0] HSize;
input	[ImageSize-1:0] VSize;
input	[ADDR_WIDTH-3:0]WrOffset;
output	FIFOClear;

input	FIFOEmpty;
input	FIFOHalfFull;

output	FIFORead;
input   [DATA_WIDTH-1:0]   FIFORdData;

input	DmaEn;
input	DmaEnable;
input	DmaStart;
input	DmaRdy, DmaBusy;
output	[ADDR_WIDTH-3:0] DmaAdr;
output	[DATA_WIDTH-1:0] DmaDat;
output	DmaReq;
output	[4:0] DmaLen;
output	[NUM_BYTE-1:0] DmaBeb;
//-------------------------------------------------------
parameter W_IDLE = 4'b0001;
parameter W_WREQ = 4'b0010;
parameter W_WDAT = 4'b0100;
parameter W_WEND = 4'b1000;

reg [3:0]  CurStW, NxtStW;

wire  tWIdle  = CurStW[0];
wire  tWWReq  = CurStW[1];
wire  tWWDat  = CurStW[2];
wire  tWWEnd  = CurStW[3];

reg    [ImageSize-1:0]	XDmaReqCnt;
reg    [ImageSize-1:0]	YDmaReqCnt;
wire			XDmaReqEnd;
wire			YDmaReqEnd;
wire     		DmaReq;
wire   [DATA_WIDTH-1:0]   DmaDat;
reg    [ADDR_WIDTH-3:0]   DmaAdr;

reg    [BCD-1:0]   BurstCnt;

wire			WriteAck;
wire			DataAck;
wire			WDatEnd;
wire 			ReMained;

reg 			DmaEnd;

reg [ImageSize-2:0] ReMainedSiz;
reg [3:0] BurstSiz;
reg [4:0] DmaLen;
//-------------------------------------------------------
// Write Control State Machine
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStW <= W_IDLE;
  	else        CurStW <= NxtStW;

always @(tWIdle or tWWReq or tWWDat or tWWEnd or WriteAck or DataAck or WDatEnd) begin
  	NxtStW = W_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tWIdle  : 	if (WriteAck)	NxtStW = W_WREQ;
  	  	          	else        	NxtStW = W_IDLE;
                                        	
  	  	tWWReq  : 	if (DataAck)	NxtStW = W_WDAT;
  	  				else			NxtStW = W_WREQ;

  	  	tWWDat  : 	if (WDatEnd) 	NxtStW = W_WEND;
  	  	          	else        	NxtStW = W_WDAT;
		
  	  	tWWEnd  : 					NxtStW = W_IDLE;

  	  	default :               	NxtStW = W_IDLE;
  	endcase
end

assign ReMained = (ReMainedSiz < MaxBurst)   & DmaEnable;
assign WriteAck = (~FIFOHalfFull | (ReMained & ~FIFOEmpty)) & DmaEnable & ~DmaEnd;
assign DataAck  =  ~DmaBusy;
assign WDatEnd  = ((BurstCnt == 0) | XDmaReqEnd) & tWWDat;

assign FIFORead  = ~FIFOEmpty & DmaRdy;
//-------------------------------------------------------
// DMA
assign DmaReq = tWWReq;
assign DmaDat = FIFORdData;

always @(negedge nRST or posedge Clk)
begin
	if (!nRST) begin
						DmaAdr  	<= 0;
						XDmaReqCnt  <= 0;
	end
	else if (DmaStart) begin
						DmaAdr  	<= WrOffset;
						XDmaReqCnt  <= 0;
	end
	else if (XDmaReqEnd) begin
						XDmaReqCnt 	<= 0;
	end
	else if (tWWDat) begin
					 	XDmaReqCnt 	<= XDmaReqCnt + 2;
						DmaAdr  	<= DmaAdr + 1;	// 32bit Aligned Address
	end
end

always @(negedge nRST or posedge Clk)
begin
	if (!nRST) begin
						BurstSiz 	 = 0;
						BurstCnt	<= 0;
						ReMainedSiz <= 0;
	end
	else if (DmaStart | XDmaReqEnd) begin
						BurstSiz	 = MaxBurst;
						ReMainedSiz <= HSize[ImageSize-1:1];
	end
	else if (tWIdle) begin
		if (ReMained)	BurstSiz 	 = 1;
		else			BurstSiz 	 = MaxBurst;
	end
	else if (tWWReq) begin
						BurstCnt	<= BurstSiz - 1;
	end
	else if (tWWDat) 	BurstCnt	<= BurstCnt - 1;
	else if (tWWEnd & ~XDmaReqEnd)	
						ReMainedSiz <= ReMainedSiz - BurstSiz;
end

always @(BurstSiz)
	if (BurstSiz == 0)	DmaLen = 0;
	else				DmaLen = {BurstSiz, 2'b0} - 1;
//-------------------------------------------------------
// DMA End Generation
assign XDmaReqEnd = (XDmaReqCnt == HSize) & DmaEnable;
assign YDmaReqEnd = (YDmaReqCnt == VSize);

always @(negedge nRST or posedge Clk)
	if      (!nRST)   	 YDmaReqCnt <= 0;
	else if (YDmaReqEnd) YDmaReqCnt <= 0;
	else if (XDmaReqEnd) YDmaReqCnt <= YDmaReqCnt + 1'b1;

assign DmaBeb = 0;

always @(negedge nRST or posedge Clk)
	if      (!nRST)   	 DmaEnd <= 0;
	else if (!DmaEnable) DmaEnd <= 0;
	else if (YDmaReqEnd) DmaEnd <= 1;
	else				 DmaEnd <= DmaEnd;

assign FIFOClear = DmaEnd;
//-------------------------------------------------------

endmodule