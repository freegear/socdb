// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech          
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// File Name           : mmc_FifoDmaCtr.v
// File Revision       : Ver 3.0 - CT2000 (TSMC)
// Revision History    : 
// 
//  -----------------------------------------------------------------------------
// Description         : Fifo control module of mmc/sd 
//  ----------------------------------------------------------------

`timescale 1ns/1ps

module mmc_FifoDmaCtr (
// Inputs
		PCLK, 
		PRESETn,
		SDreset,
		FRST, // FIFO reset signal

		DatMode,
		DMASize,
		TxActive, // Tx fifo enable
		TxRdPtrInc, // Tx의 경우 data state machine은 read pointer를 증가 시킨다.
		PWData,

		RxActive, // from Data control state machine
		RxRdPtrInc,
		RxFWrData,

		RxWriteEn,
		TxWriteEn,

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

parameter AW = 5;
// Inputs
input  			PCLK;       // AHB Bus Clock
input			PRESETn;    // AHB Bus Reset
input			SDreset;
input			FRST; 		// FIFO reset


input	[1:0]	DatMode;	// Data mode for DMA request signal generation
input	[5:0]	DMASize;    // 1회 DMA로 전송되는 DATA size
//--------------------------------------------------------

input  			TxActive;   // Transmission in progress
input			TxRdPtrInc;	// Tx Pointer increase
input	[31:0]	PWData ;  	// bus to card

input			RxActive;   // Reception in progress
input			RxRdPtrInc;
input	[31:0]	RxFWrData;	// card to bus(fifo)

input			RxWriteEn;
input			TxWriteEn;



output			RxUnderrun;
output			TxOverrun;

output			TFDET;		
output			TFHalf;
output			TFEmpty;
output			TFREmpty;

output			RFFull;
output			RFHalf;

output			RFDET;

output	[(AW-1):0]	FFCNT; // FIFO data  (byte 단위)
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


wire	FIFOFull;
wire	FIFOHalfFull;
wire	FIFOHalfEmpty;
wire	FIFOAlmostEmpty;
wire	FIFOEmpty;
wire	FIFOReadEmpty;


mmc_Fifo #(AW) mmcFifo(
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

reg dTxRdPtrInc;
reg dRxWriteEn;
always @(posedge PCLK or negedge PRESETn)
begin
    if (!PRESETn)
    begin
    dRxWriteEn <= 	1'b0;
    dTxRdPtrInc<=	1'b0;
    end
    else
    begin
		if (SDreset)
		begin
		dRxWriteEn <= 	1'b0;
    	dTxRdPtrInc<=	1'b0;
		end
		else
		begin
		dTxRdPtrInc<=TxRdPtrInc;
		dRxWriteEn <=RxWriteEn;
		end
    end
end

//-------------------------------------------------------------------------------------------
//	FIFO Write source select
//	FIFO에 쓰여질 값 선택 (Rx or Tx)
//	Tx는 bus를 통해  FIFO를 write 하고 이 data가 MMC로 가게 됨
//	Rx는 MMC의 데이터가 FIFO에 write함
//-------------------------------------------------------------------------------------------
always @(TxActive or RxActive or PWData or RxFWrData)
begin
	if (TxActive)
		FIFOWdata = PWData ; // APB bus write data
	else if (RxActive)
		FIFOWdata = RxFWrData; // Data path write data
	else	
		FIFOWdata = 32'd0;
end

wire	RxWriteEnable;
assign RxWriteEnable = RxWriteEn ^ dRxWriteEn;

always @(TxActive or RxActive or RxWriteEnable or TxWriteEn )
begin
	if (TxActive)
		FIFOWrite = TxWriteEn; //
	else if (RxActive)
		FIFOWrite = RxWriteEnable; // Data path write data
	else	
		FIFOWrite = 1'b0;
end

always @(TxActive or RxActive or TxRdPtrInc or RxRdPtrInc or dTxRdPtrInc)
begin
	if (TxActive)
		FIFORead = TxRdPtrInc ^ dTxRdPtrInc; 
	else if (RxActive)
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

assign	TFFull	= FIFOFull & TxActive;
assign	RFFull	= FIFOFull & RxActive;
assign	TFHalf	= FIFOHalfEmpty & TxActive;
assign	RFHalf	= FIFOHalfFull & RxActive;
assign	TFEmpty	= FIFOEmpty & TxActive;// Write Side Empty
assign	TFREmpty= FIFOReadEmpty & TxActive;// Write internal read Side Empty
//assign	RFEmpty	= FIFOEmpty & RxActive;	
assign	RFEmpty	= FIFOReadEmpty & RxActive;	// Read Side Empty

assign RxUnderrun = RFEmpty & FIFORead ;
assign TxOverrun = TFFull & FIFOWrite;

assign TFDET = TxActive & ~FIFOFull	 ;
//assign RFDET = RxActive & ~FIFOEmpty ;
assign RFDET = RxActive & ~FIFOReadEmpty ;

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
