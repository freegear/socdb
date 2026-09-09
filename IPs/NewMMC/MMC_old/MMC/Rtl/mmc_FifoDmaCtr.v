`timescale 1ns/1ps

//`include "mmcParams.v"
module mmc_DataFifo_DMA (
// Inputs
		PCLK,
		PRESETn,
		SDreset,
		FRST, // FIFO reset signal

		DatMode,
		DMASize,
		TxActiveSync, // Tx fifo enable
		TxRdPtrIncSync, // Tx의 경우 data state machine은 read pointer를 증가 시킨다.
		PWData,

		RxActiveSync, // from Data control state machine
		RxRdPtrInc,
		RxFWrData,

		RxWriteEnSync,
		TxWriteEnSync,

// Outputs
		RxUnderrun,
		TxOverrun,

		TFDET,   // 0: fifo full 1: 0~63
		TFHalf,  // 0: 33~64,  1: 0~32
       	TFEmpty, // 0: 1~64,   1: 0
       	TFREmpty, // 0: 1~64,   1: 0
	
      	RFFull,  //  1: 64
       	RFHalf,  //  0: 0~31,  1: 32~6
       	RFDET,
       	FFCNT,
		FIFORdData,
		EnDMA,
		DREQ
		);

parameter AW = 7;
// Inputs
input  			PCLK;       // AHB Bus Clock
input			PRESETn;    // AHB Bus Reset
input			SDreset;
input			FRST; 		// FIFO reset


input	[1:0]	DatMode;	// Data mode for DMA request signal generation
input	[6:0]	DMASize;    // 1회 DMA로 전송되는 DATA size
//--------------------------------------------------------

input  			TxActiveSync;   // Transmission in progress
input			TxRdPtrIncSync;	// Tx Pointer increase
input	[31:0]	PWData ;  	// bus to card

input			RxActiveSync;   // Reception in progress
input			RxRdPtrInc;
input	[31:0]	RxFWrData;	// card to bus(fifo)

input			RxWriteEnSync;
input			TxWriteEnSync;



output			RxUnderrun;
output			TxOverrun;

output			TFDET;		
output			TFHalf;
output			TFEmpty;
output			TFREmpty;

output			RFFull;
output			RFHalf;

output			RFDET;

output	[6:0]	FFCNT; // FIFO data  (byte 단위)
output	[31:0]	FIFORdData;
input			EnDMA;
output			DREQ;

reg [31:0]	FIFOWdata;
reg			FIFOWrite;
reg			FIFORead;
wire	[31:0]	FIFORdData;
wire	[(AW-1):0]	DatCnt;

assign 	FFCNT = DatCnt;
wire	FIFOFlush;
assign	FIFOFlush = FRST;
mmc_FIFO #(AW) mmcFIFO(
    .Clk			(PCLK),
    .nRST			(PRESETn),
    .SDreset		(SDreset),
    .FIFOWrite		(FIFOWrite),
    .FIFOWrData		(FIFOWdata),
    .FIFORead		(FIFORead),
    .FIFORdData		(FIFORdData),
    .FIFOFlush		(FIFOFlush),
    .FIFOFull		(FIFOFull),
    .FIFOHalfFull	(FIFOHalfFull),
    .FIFOHalfEmpty	(FIFOHalfEmpty),
    .FIFOAlmostEmpty(FIFOAlmostEmpty),
    .FIFOEmpty		(FIFOEmpty),
    .FIFOReadEmpty	(FIFOReadEmpty),
    .DatCnt			(DatCnt)
);

reg dTxRdPtrIncSync;
reg dRxWriteEnSync;
always @(posedge PCLK or negedge PRESETn)
begin
    if (!PRESETn)
    begin
    dRxWriteEnSync <= 	1'b0;
    dTxRdPtrIncSync<=	1'b0;
    end
    else
    begin
		if (SDreset)
		begin
		dRxWriteEnSync <= 	1'b0;
    		dTxRdPtrIncSync<=	1'b0;
		end
		else
		begin
		dTxRdPtrIncSync<=TxRdPtrIncSync;
		dRxWriteEnSync <=RxWriteEnSync;
		end
    end
end

//-------------------------------------------------------------------------------------------
//	FIFO Write source select
//	FIFO에 쓰여질 값 선택 (Rx or Tx)
//	Tx는 bus를 통해  FIFO를 write 하고 이 data가 MMC로 가게 됨
//	Rx는 MMC의 데이터가 FIFO에 write함
//-------------------------------------------------------------------------------------------
always @(TxActiveSync or RxActiveSync or PWData or RxFWrData)
begin
	if (TxActiveSync)
		FIFOWdata = PWData ; // APB bus write data
	else if (RxActiveSync)
		FIFOWdata = RxFWrData; // Data path write data
	else	
		FIFOWdata = 32'd0;
end

wire	RxWriteEnable;
assign RxWriteEnable = RxWriteEnSync ^ dRxWriteEnSync;

always @(TxActiveSync or RxActiveSync or RxWriteEnable or TxWriteEnSync )
begin
	if (TxActiveSync)
		FIFOWrite = TxWriteEnSync; //
	else if (RxActiveSync)
		FIFOWrite = RxWriteEnable; // Data path write data
	else	
		FIFOWrite = 1'b0;
end

always @(TxActiveSync or RxActiveSync or TxRdPtrIncSync or RxRdPtrInc or dTxRdPtrIncSync)
begin
	if (TxActiveSync)
		FIFORead = TxRdPtrIncSync ^ dTxRdPtrIncSync; 
	else if (RxActiveSync)
		FIFORead = RxRdPtrInc; 
	else	
		FIFORead = 1'b0;
end

wire	TFFull;
wire	RFFull;
wire	TFHalf;
wire	RFHalf;
wire	TFEmpty;
wire	TFREmpty;
wire	RFEmpty;

wire	RxUnderrun;
wire	TxOverrun;

wire	TFDET;
wire	RFDET;

assign	TFFull	= FIFOFull & TxActiveSync;
assign	RFFull	= FIFOFull & RxActiveSync;
assign	TFHalf	= FIFOHalfEmpty & TxActiveSync;
assign	RFHalf	= FIFOHalfFull & RxActiveSync;
assign	TFEmpty	= FIFOEmpty & TxActiveSync;// Write Side Empty
assign	TFREmpty= FIFOReadEmpty & TxActiveSync;// Write internal read Side Empty
//assign	RFEmpty	= FIFOEmpty & RxActiveSync;	
assign	RFEmpty	= FIFOReadEmpty & RxActiveSync;	// Read Side Empty

assign RxUnderrun = RFEmpty & FIFORead ;
assign TxOverrun = TFFull & FIFOWrite;

assign TFDET = TxActiveSync & ~FIFOFull	 ;
//assign RFDET = RxActiveSync & ~FIFOEmpty ;
assign RFDET = RxActiveSync & ~FIFOReadEmpty ;

//------------------------------------------------------------------------------
// DMA block 
//------------------------------------------------------------------------------
// DREQ 	: DMA request

// EnDMA  Datmode 
// (EnDMA == 1'b1)&&(Datmode == 2'b11) Transmit DMA
// (EnDMA == 1'b1)&&(Datmode == 2'b10) Receive DMA
// Tx -> Rx으로 바로갈 때 FIFO가 비어있지 않거나
// Rx -> Tx로 바로갈 때(?) 문제 생길 수 있음..
// 따라서  No Operation 상태로 가서 FIFO를 Flush하고 다음 동작을 해야한다.

reg	NextDREQ;
reg	DREQ;
parameter FIFOSize = {1'b1,{AW{1'b0}}};

always @(EnDMA or DatMode or DMASize or DatCnt or DREQ or FIFOFull)
begin
	NextDREQ = DREQ;
	if ((EnDMA == 1'b1)&&(DatMode == 2'b11)) // Transmit DMA
		begin
		if ( ((FIFOSize) - {FIFOFull,DatCnt}) >= DMASize ) // 쓸 수 있는 용량이 남아 있으면
			NextDREQ = 1'b1;
		else
			NextDREQ = 1'b0;
		end
	else if ((EnDMA == 1'b1)&&(DatMode == 2'b10)) //Receive DMA
		begin
		if ( {FIFOFull,DatCnt} >= DMASize )// 1회 전송크기 이상 있으면
			NextDREQ = 1'b1;
		else
			NextDREQ = 1'b0;
		end
	else
		NextDREQ = 1'b0;
end

always @(posedge PCLK or negedge PRESETn )
begin
	if (!PRESETn)
	DREQ <= 1'b0;
	else
		begin
		if (SDreset)
		DREQ <= 1'b0;
		else
		DREQ <= NextDREQ;
		end
end

endmodule

// --============================== End ======================================--
