`timescale 1ns/10ps

module VifWDma (
					nRST,
					Clk,
					HSize,
					VSize,
					WrOffset,
					SWReset,
					DmaI2PEn,
					FieldPCLK1,
    				
					FIFOEmpty, 
					FIFOHalfFull,
					FIFORead, 
					FIFORdData,
					
					DmaEnable,
					DmaStart,
					HEnd,
    				
					DmaAdr,
					DmaDat,
					DmaReq,
					DmaLen,
					DmaBeb,
					DmaRdy,
					DmaBusy
);

`include "VifPara.v"

// System
input				nRST;
input				Clk;

input[ImageSize-1:0] HSize;
input[ImageSize-1:0] VSize;
input[ADDR_WIDTH-3:0]WrOffset;
input				DmaI2PEn;
input				FieldPCLK1;
input				SWReset;

input				FIFOEmpty;
input				FIFOHalfFull;

output				FIFORead;
input[DATA_WIDTH-1:0]FIFORdData;

input				DmaEnable;
input				DmaStart;
input				HEnd;
input				DmaRdy, DmaBusy;
output[ADDR_WIDTH-3:0]DmaAdr;
output[DATA_WIDTH-1:0]DmaDat;
output				DmaReq;
output[4:0] 		DmaLen;
output[NUM_BYTE-1:0]DmaBeb;
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

reg  [ImageSize-1:0]XDmaReqCnt;
reg  [ImageSize-1:0]YDmaReqCnt;
wire				XDmaReqEnd;
wire				YDmaReqEnd;
wire     			DmaReq;
wire [DATA_WIDTH-1:0]DmaDat;
reg  [ADDR_WIDTH-3:0]DmaAdr;

reg  [BCD-1:0]   	BurstCnt;

wire				WriteAck;
wire				DataAck;
wire				WDatEnd;
wire				ReMained;
wire				IncCnt;
                		
reg 				DmaEnd;

reg [ImageSize-2:0] ReMainedSiz;
reg [3:0] 			BurstSiz;
reg [4:0] 			DmaLen;

reg					HWrEndSysClk0;
reg					HWrEndSysClk1;
reg					HWrEndSysClk;
//-------------------------------------------------------
// Write Control State Machine
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStW <= W_IDLE;
  	else if (SWReset)
  				CurStW <= W_IDLE;
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

assign ReMained = (ReMainedSiz < MaxBurst) & DmaEnable;
assign WriteAck = (~FIFOHalfFull | (ReMained & HWrEndSysClk & ~FIFOEmpty)) & DmaEnable & ~DmaEnd;
assign DataAck  =  DmaBusy;
assign WDatEnd  = ((BurstCnt == 0) | XDmaReqEnd) & DmaRdy;
assign IncCnt   =  tWWDat & DmaRdy;

assign FIFORead  = ~FIFOEmpty & DmaRdy;
//-------------------------------------------------------
// Meta FF.
always @(negedge nRST or posedge Clk)
begin
	if (!nRST) begin
			HWrEndSysClk0  <= 0;
			HWrEndSysClk1  <= 0;
	end
	else begin
			HWrEndSysClk0  <= HEnd;
			HWrEndSysClk1  <= HWrEndSysClk0;
	end
end

always @(negedge nRST or posedge Clk)
begin
	if (!nRST)
			HWrEndSysClk <= 0;
	else if (SWReset | FIFOEmpty)
			HWrEndSysClk <= 0;
	else if (HWrEndSysClk1)
			HWrEndSysClk <= 1;
	else	HWrEndSysClk <= HWrEndSysClk;
end
//-------------------------------------------------------
// DMA
assign DmaReq = tWWReq & DataAck;
assign DmaDat = FIFORdData;

reg Field;
always @(negedge nRST or posedge Clk)
	if (!nRST)	Field <= 0;
	else if (DmaEnable & YDmaReqEnd)
				Field <= Field + 1;

always @(negedge nRST or posedge Clk)
begin
	if (!nRST) begin
						XDmaReqCnt  <= 0;
						DmaAdr  	<= 0;
	end
	else if (SWReset) begin
						XDmaReqCnt  <= 0;
		if (DmaI2PEn)	DmaAdr  	<= DmaAdr;
		else			DmaAdr  	<= 0;
	end
	else if (DmaStart) begin
						XDmaReqCnt  <= 0;
		if (DmaI2PEn & FieldPCLK1)	
//		if (DmaI2PEn & Field)
						DmaAdr  	<= WrOffset + HSize[ImageSize-1:1];	// Odd  Field
		else			DmaAdr  	<= WrOffset;						// Even Field
	end
	else if (XDmaReqEnd) begin
						XDmaReqCnt 	<= 0;
		 if (DmaI2PEn)	DmaAdr  	<= DmaAdr + HSize[ImageSize-1:1];
		 else			DmaAdr  	<= DmaAdr;
	end
	else if (IncCnt) begin
					 	XDmaReqCnt 	<= XDmaReqCnt + 2;
						DmaAdr  	<= DmaAdr + 1;	// 32bit Aligned Address
	end
//	else if (YDmaReqEnd) begin
//		if (DmaI2PEn & Field)	
//						DmaAdr  	<= WrOffset + HSize[ImageSize-1:1];	// Odd  Field
//		else			DmaAdr  	<= WrOffset;						// Even Field
//	end
end

always @(negedge nRST or posedge Clk)
begin
	if (!nRST) begin
						BurstSiz 	 = 0;
						BurstCnt	<= 0;
						ReMainedSiz <= 0;
	end
	else if (SWReset) begin
						BurstSiz 	 = 0;
						BurstCnt	<= 0;
						ReMainedSiz <= 0;
	end
	else if (DmaStart | XDmaReqEnd) begin
						BurstSiz	 = MaxBurst;
						ReMainedSiz <= HSize[ImageSize-1:1];
	end
	else if (tWIdle) begin
		if (ReMained)	BurstSiz 	 = ReMainedSiz;
		else			BurstSiz 	 = MaxBurst;
	end
	else if (tWWReq) begin
						BurstCnt	<= BurstSiz - 1;
	end
	else if (IncCnt) 	BurstCnt	<= BurstCnt - 1;
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
//-------------------------------------------------------

endmodule
