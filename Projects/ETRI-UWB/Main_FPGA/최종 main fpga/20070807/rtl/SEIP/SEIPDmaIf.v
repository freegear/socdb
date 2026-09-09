
module SEIPDmaIf (
				PCLK,
				PRESETB,

				RxFIFOWrite,
				RxFIFOWrData,
				RxFIFOReadCpu,
				RxFIFORdDataCpu,
				RxFIFOFlush,
				RxFIFODataCnt,
				RxFIFOEmpty,
				RxFIFOFull,

				RxDmaEn,
				RxDmaSize,
				RxDmaReset,
				RxDmaRequest,
				RxDmaErr,
				RxDmaReq,

				TxFIFORead,
				TxFIFORdData,
				TxFIFOWriteCpu,
				TxFIFOWrDataCpu,
				TxFIFOFlush,
				TxFIFODataCnt,
				TxFIFOEmpty,
				TxFIFOFull,

				TxDmaEn,
				TxDmaSize,
				TxDmaReset,
				TxDmaRequest,
				TxDmaErr,
				TxDmaReq,

				RXSYNC,
				RXRDY,
				RXWE,
				RXD,

				TXSYNC,
				TXRDY,
				TXRD,
				TXD
);

`include "SEIPPara.v"

input			PCLK;
input			PRESETB;

// RX FIFO Register Interface
input			RxFIFOWrite;
input  [31:0]	RxFIFOWrData;
input           RxFIFOReadCpu;
output  [31:0]  RxFIFORdDataCpu;
input			RxFIFOFlush;
output[RXAW-1:0]RxFIFODataCnt;
output			RxFIFOEmpty;
output			RxFIFOFull;

input			RxDmaEn;
input  [RXAW-1:0]	RxDmaSize;
input			RxDmaReset;

// PCM RX Interface
input			RXSYNC;
input			RXRDY;
output			RXWE;
output [31:0]	RXD;

// RX DMA Interface
output			RxDmaRequest;
output			RxDmaErr;
output			RxDmaReq;

// TX FIFO Register Interface
input			TxFIFORead;
output  [31:0]	TxFIFORdData;
input           TxFIFOWriteCpu;
input   [31:0]  TxFIFOWrDataCpu;
input			TxFIFOFlush;
output[TXAW-1:0]TxFIFODataCnt;
output			TxFIFOEmpty;
output			TxFIFOFull;

input			TxDmaEn;
input  [TXAW-1:0]	TxDmaSize;
input			TxDmaReset;

// PCM TX Interface
input			TXSYNC;
output			TXRDY;
input			TXRD;
input  [31:0]	TXD;

// TX DMA Interface
output			TxDmaRequest;
output			TxDmaErr;
output			TxDmaReq;
//----------------------------------------------------------------------
// PCM RX
wire			RxFIFORead;
wire [31:0]		RxFIFORdData;
wire [RXAW-1:0] RxFIFODataCnt;

// RX DMA FIFO
PcmFIFO #(RXAW, 32) PcmRxFIFO (	// 8x32
		.Clk			(PCLK), 
		.nRST			(PRESETB), 
		.FIFOFlush		(RxFIFOFlush), 
		.FIFOWrData		(RxFIFOWrData), 
		.FIFOWrite		(RxFIFOWrite), 
		.FIFORdData		(RxFIFORdData), 
		.FIFORead		(RxFIFORead | RxFIFOReadCpu),
		.FIFOHalfFull	(RxFIFOHalfFull), 
		.FIFOFull		(RxFIFOFull), 
		.FIFOEmptyWr	(),
		.FIFOAlmostEmpty(RxFIFOAlmostEmpty),
		.FIFOEmpty		(RxFIFOEmpty),
		.FIFODataCnt	(RxFIFODataCnt)
);

assign RxFIFORdDataCpu = RxFIFORdData;
//----------------------------------------------------------------------
// RX Interface Control FSM
parameter R_IDLE  = 3'b001;
parameter R_SYNC  = 3'b010;
parameter R_RDY   = 3'b100;

reg [2:0]  CurStR, NxtStR;

wire  tRIdle  = CurStR[0];
wire  tRSync  = CurStR[1];
wire  tRRdy   = CurStR[2];

always @(negedge PRESETB or posedge PCLK)
    if (!PRESETB)   CurStR <= R_IDLE;
    else            CurStR <= NxtStR;

always @(tRIdle or tRSync or tRRdy or RxFIFOEmpty or RXSYNC or RXRDY) begin
    NxtStR = R_IDLE;
    case(1'b1)  // synopsys parallel_case
        tRIdle  :   if (~RxFIFOEmpty)	NxtStR = R_SYNC;
                    else                NxtStR = R_IDLE;

        tRSync  :   if (RXSYNC)         NxtStR = R_RDY;
                    else                NxtStR = R_SYNC;

        tRRdy   :   if (RXRDY)          NxtStR = R_IDLE;
                    else                NxtStR = R_RDY;

        default :                       NxtStR = R_IDLE;
    endcase
end

assign RXWE = tRRdy;
assign RXD  = RxFIFORdData;

assign RxFIFORead = tRRdy & RXRDY;
//----------------------------------------------------------------------
// RX DMA Request Generation
reg		NextRxDmaReqeust;
reg		RxDmaRequest;
wire [RXAW:0] RxFIFOSize = {1'b1, {RXAW{1'b0}}};

wire	iRxDmaReq;
assign	iRxDmaReq = (RxFIFOSize - RxFIFODataCnt) >= RxDmaSize;

always @(RxDmaEn or iRxDmaReq or RxDmaRequest)
begin
	NextRxDmaReqeust = RxDmaRequest;
	if (iRxDmaReq & RxDmaEn) // FIFO에 쓸 수 있는 용량이 남아 있으면
		NextRxDmaReqeust = 1'b1;
	else
		NextRxDmaReqeust = 1'b0;
end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB)	RxDmaRequest <= 1'b0;
	else begin
		if (RxDmaReset)
					RxDmaRequest <= 1'b0;
		else		RxDmaRequest <= NextRxDmaReqeust;
	end

assign RxDmaErr  = RXWE & RxFIFOEmpty;
assign RxDmaReq  = iRxDmaReq;
//----------------------------------------------------------------------
// PCM TX
// TX DMA FIFO
wire [31:0]		TxFIFOWrDataInt;
wire			TxFIFOWrite;
wire [31:0]		TxFIFORdData;
wire [TXAW-1:0] TxFIFODataCnt;

wire [31:0]		TxFIFOWrData = TxFIFOWriteCpu ? TxFIFOWrDataCpu : TxFIFOWrDataInt;

// RX DMA FIFO
PcmFIFO #(TXAW, 32) PcmTxFIFO (	// 8x32
		.Clk			(PCLK), 
		.nRST			(PRESETB), 
		.FIFOFlush		(TxFIFOFlush), 
		.FIFOWrData		(TxFIFOWrData), 
		.FIFOWrite		(TxFIFOWrite | TxFIFOWriteCpu), 
		.FIFORdData		(TxFIFORdData), 
		.FIFORead		(TxFIFORead),
		.FIFOHalfFull	(TxFIFOHalfFull), 
		.FIFOFull		(TxFIFOFull), 
		.FIFOEmptyWr	(),
		.FIFOAlmostEmpty(TxFIFOAlmostEmpty),
		.FIFOEmpty		(TxFIFOEmpty),
		.FIFODataCnt	(TxFIFODataCnt)
);
//----------------------------------------------------------------------
// TX Interface Control FSM
parameter T_IDLE  = 3'b001;
parameter T_SYNC  = 3'b010;
parameter T_RDY   = 3'b100;

reg [2:0]  CurStT, NxtStT;

wire  tTIdle  = CurStT[0];
wire  tTSync  = CurStT[1];
wire  tTRdy   = CurStT[2];

always @(negedge PRESETB or posedge PCLK)
    if (!PRESETB)   CurStT <= T_IDLE;
    else            CurStT <= NxtStT;

always @(tTIdle or tTSync or tTRdy or TxFIFOFull or TXSYNC or TXRD) begin
    NxtStT = T_IDLE;
    case(1'b1)  // synopsys parallel_case
        tTIdle  :   if (~TxFIFOFull)	NxtStT = T_SYNC;
                    else                NxtStT = T_IDLE;

        tTSync  :   if (TXSYNC)         NxtStT = T_RDY;
                    else                NxtStT = T_SYNC;

        tTRdy   :   if (TXRD)         	NxtStT = T_IDLE;
                    else                NxtStT = T_RDY;

        default :                       NxtStT = T_IDLE;
    endcase
end

assign TXRDY = tTRdy;
assign TxFIFOWrDataInt = TXD;

assign TxFIFOWrite = tTRdy & TXRD & TXRDY;
//----------------------------------------------------------------------
// TX DMA Request Generation
reg		NextTxDmaReqeust;
reg		TxDmaRequest;

wire	iTxDmaReq;

assign 	iTxDmaReq = TxFIFODataCnt >= TxDmaSize;

always @(TxDmaEn or iTxDmaReq or TxDmaRequest)
begin
	NextTxDmaReqeust = TxDmaRequest;
	if (iTxDmaReq & TxDmaEn)// DMA 1회 전송크기 이상 있으면
		NextTxDmaReqeust = 1'b1;
	else
		NextTxDmaReqeust = 1'b0;
end

always @(negedge PRESETB or posedge PCLK)
	if (!PRESETB)	TxDmaRequest <= 1'b0;
	else begin
		if (TxDmaReset)
					TxDmaRequest <= 1'b0;
		else		TxDmaRequest <= NextTxDmaReqeust;
	end

assign TxDmaErr  = TXRD & RxFIFOFull;
assign TxDmaReq  = iTxDmaReq;
//----------------------------------------------------------------------

endmodule
