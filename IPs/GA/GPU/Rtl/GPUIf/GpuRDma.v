
`timescale 1ns/1ns

module GpuRDma(
				Clk, 
				nRST,
				FIFOClear,
				CBClear,
				
				CBStartAddr,
				CBSize,
				CBDmaEn,

				DMARDataValid,
				DMARData,
				DMARCmd,
				DMARCmdAck,
				DMARBurstLen,
				DMARAddr,
				
				CBReadRequest,
				CBReadData,
				CBEmpty
);

`include "GpuPara.v"

// System
input			Clk; 
input			nRST;
input			FIFOClear;
input			CBClear;
			
input [31:0] 	CBStartAddr;
input [ 4:0] 	CBSize;
input			CBDmaEn;

// CB DMA
input			DMARDataValid;
input [DW:0]	DMARData;
input			DMARCmdAck;
output			DMARCmd;
output [ 4:0]	DMARBurstLen;
output [31:0]	DMARAddr;

input			CBReadRequest;
output [31:0]	CBReadData;
output			CBEmpty;
//-------------------------------------------------------------------------------
parameter B_IDLE = 4'b0001;
parameter B_DREQ = 4'b0010;
parameter B_DCAL = 4'b0100;
parameter B_DEND = 4'b1000;

reg [3:0]  CurStB, NxtStB;

wire  tBIdle  = CurStB[0];
wire  tBDReq  = CurStB[1];
wire  tBDCal  = CurStB[2];
wire  tBDEnd  = CurStB[3];

// CB Plane
wire 			CBDmaEn;

// CB Count
reg [ 4:0] 		XDmaReqCnt;
reg [ 2:0] 		BurstSiz;

// CB DMA
wire 			DMARCmd;
reg  [ 4:0]		DMARBurstLen;
reg  [31:0]		DMARAddr;

wire 			BBLQWrite, BBLQRead;
wire 			iBBLQRead;
wire 			BBLQHFull, BBLQQFull;
wire 			BBLQFull;
wire 			BBLQEmpty;
wire [BBLQW:0]	BBLQWrData = BurstSiz;
wire [BBLQW:0]	BBLQRdData;
reg  [3:0] 		BurstCnt;
wire  			BurstEnd;

// CB DMA FIFO
wire			DMADataValid;
reg				DMARDataValidD;
wire  			CBWrite;
reg  [DW:0] 	CBWrData;
wire			iCBRead;
wire			CBRead;
wire [DW:0] 	CBRdData;

wire			CBAlmostEmpty;
wire			CBEmpty;
wire			CBFull;
wire			CBHalfFull;

reg 			DMAEn;
wire			GoDMARequest = DMAEn & ~BBLQFull;
wire			XDmaReqEnd   = XDmaReqCnt == CBSize;
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
  	if (!nRST) 	CurStB <= B_IDLE;
  	else if (FIFOClear)
  				CurStB <= B_IDLE;
  	else        CurStB <= NxtStB;

always @(tBIdle or tBDReq or tBDCal or tBDEnd or DMAEn or
		CBDmaEn or GoDMARequest or DMARCmdAck or XDmaReqEnd) begin
  	NxtStB = B_IDLE;
  	case(1'b1)	// synopsys parallel_case
  	  	tBIdle  : 	if (CBDmaEn)			NxtStB = B_DCAL;
  	  	          	else        			NxtStB = B_IDLE;

		tBDCal	:	if (!DMAEn)				NxtStB = B_IDLE;
  	  				else if (XDmaReqEnd)	NxtStB = B_DEND;
  	  				else if (GoDMARequest)	NxtStB = B_DREQ;
  	  				else					NxtStB = B_DCAL;

  	  	tBDReq  : 	if (DMARCmdAck) 		NxtStB = B_DCAL;
  	  				else					NxtStB = B_DREQ;

  	  	tBDEnd  : 	if (!DMAEn)				NxtStB = B_IDLE;
  	  				else 					NxtStB = B_DCAL;

  	  	default :               			NxtStB = B_IDLE;
  	endcase
end
//-------------------------------------------------------------------------------
assign DMARCmd = tBDReq;
wire   DMAEnd  = XDmaReqEnd;

always @(negedge nRST or posedge Clk)
	if 		(!nRST)	DMAEn <= 0;
	else if (DMAEnd | FIFOClear)
					DMAEn <= 0;
	else if (CBDmaEn)
					DMAEn <= 1;
	else			DMAEn <= DMAEn;

always @(negedge nRST or posedge Clk)
begin
	if 		(!nRST) begin
					BurstSiz 	<= 0;
					DMARAddr  	<= 0;
					XDmaReqCnt 	<= 0;
	end
	else if (tBIdle & CBDmaEn) begin // Initial Load Register Value
					BurstSiz 	<= CBMaxBL;
					DMARAddr    <= CBStartAddr;
					XDmaReqCnt 	<= 0;
	end
	else if (tBDCal) begin
		if (CBSize-XDmaReqCnt > CBMaxBL)
					BurstSiz 	<= CBMaxBL;
		else 		BurstSiz 	<= CBSize-XDmaReqCnt;
	end
	else if (tBDReq & DMARCmdAck) begin
		if (BurstSiz == 0)	
					DMARAddr  	<= DMARAddr + 8;	// 64bit
		else 		DMARAddr  	<= DMARAddr + {BurstSiz, 3'b0};
					XDmaReqCnt	<= XDmaReqCnt + BurstSiz;
	end
	else if (tBDEnd) begin
					DMARAddr  	<= DMARAddr;
					XDmaReqCnt 	<= 0;
	end
end

always @(BurstSiz)
	if (BurstSiz == 0)	DMARBurstLen = 0;
	else				DMARBurstLen = {BurstSiz, 3'b0} - 1;	// 64bit Access
//-------------------------------------------------------------------------------
assign BBLQWrite  = ~BBLQFull  & tBDReq & DMARCmdAck;
assign iBBLQRead  = ~BBLQEmpty & BurstEnd;
assign BBLQRead   = iBBLQRead;
assign BurstEnd   = DMADataValid & (BurstCnt == BBLQRdData -1);

always@(negedge nRST or posedge Clk)
    if      (!nRST)  		BurstCnt <= 0;
    else if (iBBLQRead) 	BurstCnt <= 0;
    else if (DMADataValid)	BurstCnt <= BurstCnt + 1;

DmaBLQ #(BBLQCD, BBLQD, BBLQW) GDMABBLQ(
			.nRST		(nRST), 
			.Clk		(Clk), 
			.WriteEn	(BBLQWrite), 
			.ReadEn		(BBLQRead), 
			.WrData		(BBLQWrData), 
			.RdData		(BBLQRdData), 
			.HFullFlag	(BBLQHFull),
			.QFullFlag	(BBLQQFull),
			.FullFlag	(BBLQFull), 
			.EmptyFlag	(BBLQEmpty)
);
//-------------------------------------------------------------------------------
always @(negedge nRST or posedge Clk)
	if  (!nRST)	DMARDataValidD <= 0;
	else		DMARDataValidD <= DMARDataValid;

assign CBWrite = DMARDataValidD & ~CBFull;

always @(negedge nRST or posedge Clk)
	if  (!nRST)	CBWrData <= 0;
	else 		CBWrData <= DMARData;

// 32x64
ScFIFO32x64 #(5, CBMaxBL, DW+1) CBFIFO(
			.Clk			(Clk), 
			.nRST			(nRST), 
			.FIFOFlush		(FIFOClear), 
			.FIFOWrData		(CBWrData), 
			.FIFOWrite		(CBWrite), 
			.FIFORdData		(CBRdData), 
			.FIFORead		(CBRead),
			.FIFOHalfFull	(CBHalfFull), 
			.FIFOFull		(CBFull), 
			.FIFOEmptyWr	(),
			.FIFOAlmostEmpty(CBAlmostEmpty),
			.FIFOEmpty		(CBEmpty)
);

reg	ReqCnt;
always @(negedge nRST or posedge Clk)
	if  	(!nRST)		ReqCnt <= 0;
	else if (FIFOClear | CBClear)	
						ReqCnt <= 0;
	else if (iCBRead)	ReqCnt <= ReqCnt + 1;

assign DMADataValid = CBRead;
assign iCBRead      = CBReadRequest & ~CBEmpty;// & ~(CBWrite & CBAlmostEmpty);
assign CBRead       = iCBRead & ~ReqCnt;

reg [DW:0] LatchCBRdData;
always @(negedge nRST or posedge Clk)
	if  	(!nRST)		LatchCBRdData <= 0;
	else if (iCBRead)	LatchCBRdData <= CBRdData;

assign CBReadData   = iCBRead & ~ReqCnt ? CBRdData[31:0] : LatchCBRdData[63:32];
//-------------------------------------------------------------------------------
assign DMAOverRun  = DMARDataValidD  & CBFull;
assign DMAUnderRun  = CBEmpty & CBReadRequest;
//-------------------------------------------------------------------------------
// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(DMAOverRun)
	if(DMAOverRun) begin
		$display("%m ERROR: Command Buffer Error (%t)",$time);
		$stop;
	end
// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on
// -----------------------------------------------------------------------------
endmodule
