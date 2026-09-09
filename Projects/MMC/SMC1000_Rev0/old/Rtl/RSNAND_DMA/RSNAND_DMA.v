// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : RSNAND_DMA.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : RS & NAND DMA Controller
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps
module RSNAND_DMA
(	RESETn,
	CLK,

	Start,
	Size,
	Mode,
	Bypass,
//	DecodeEnd,
	RSDe_Wait,
	RSEn_Wait,
	DecodeEndCnt,
	SyndProcess,

	NandREQ, // Nand DATA request
	SplitSize, // Nand 1 time request DATA Transfer Size
	StartAddr,
	TransferEnd,
//	BlkCnt,
	BigBlk,
	SmallBlk, 
	SmallBlk2,
	SmallBlk3,

	Nand_WEn,
	Nand_REn,

	RAM_ADDR,

	RAM_WEn,
	//RAM_REn,
	
	BlockStart,
	RSParityCatch,
	RSEn_Start,
	RSDe_First_Start,
	RSDe_Start

);

input 	RESETn;
input	CLK;

input 	Start;
input	[10:0]	Size;
input	Mode; // Mode 0 : Encoder 1: Decoder
input	Bypass;
//input	DecodeEnd;
input	[2:0]	DecodeEndCnt; // From Decoder Module
output	RSDe_Wait; // Previous Decoding Not Complete
output	RSEn_Wait;
output	SyndProcess;

input	NandREQ;
input	[3:0]	SplitSize;
input	[10:0]	StartAddr;
output	TransferEnd;
//output	[2:0]	BlkCnt;
output	BigBlk;
output	SmallBlk; 
output	SmallBlk2;
output	SmallBlk3;

output	Nand_WEn;
output	Nand_REn;

output	[10:0]	RAM_ADDR;

output 	RAM_WEn;
//output	RAM_REn;

output	BlockStart;
output	RSParityCatch;
output	RSEn_Start;
output	RSDe_First_Start;
output	RSDe_Start;

// 1. RSEn and nonDMA Write

// IDLE => Init0 => Encoding => Init1 => Encoding 
//					=> Wait

`define DMA_IDLE 	8'b00000001
`define DMA_INIT0	8'b00000010
`define DMA_INIT1	8'b00000100
`define DMA_TRANS	8'b00001000
`define DMA_WAIT	8'b00010000
`define DMA_WAIT1	8'b00100000 // for decode
`define DMA_WAIT2	8'b01000000 // for decode
`define DMA_DONE	8'b10000000

reg [7:0] 	NextDMAState;
reg	[7:0]	DMAState;

wire	InitCnt0;
wire	BlkDatCnt0;
wire	TransferDone;
wire	BlkCnt0;
wire	SplitCnt0;
wire	BigBlk;
wire	SmallBlk;
wire	SmallBlk2;
wire	SmallBlk3;
wire	DecodeEndCnt0;
wire 	WaitCnt0;
wire	DecodeNotDone;

reg		[1:0]	InitCnt ;
reg		[1:0]	NextInitCnt ;
reg		[8:0]	BlkDatCnt;
reg		[8:0]	NextBlkDatCnt;
reg		[10:0]	DatCnt;
reg		[10:0]	NextDatCnt;
reg		[2:0]	BlkCnt;
reg		[2:0]	NextBlkCnt;
reg		[3:0]	SplitCnt;
reg		[3:0]	NextSplitCnt;
//reg 	[2:0]	NextDecodeEndCnt;
//reg		[2:0]	DecodeEndCnt;
reg 	[3:0]	WaitCnt;
reg 	[3:0] 	NextWaitCnt;
reg 	[10:0]	Address;
reg		[10:0]	NextAddress;

assign InitCnt0 	= (InitCnt == 0); 
assign BlkDatCnt0 	= (BlkDatCnt == 0);
assign TransferDone	= (DatCnt == Size);
assign BlkCnt0 		= (BlkCnt == 0); 
assign SplitCnt0 	= (SplitCnt == 0); 
assign DecodeEndCnt0 = (DecodeEndCnt == 0);
assign WaitCnt0 = (WaitCnt == 0);

assign BigBlk = (Size == 2047);
assign SmallBlk = (Size == 511);
assign SmallBlk2 = (Size == 1023);
assign SmallBlk3 = (Size == 1535);
assign DecodeNotDone = (BlkCnt != (DecodeEndCnt -1));

always @(Bypass or Start or InitCnt or NextInitCnt or DMAState or Mode)
begin
	NextInitCnt = InitCnt;
	if (~Bypass & Start & ~Mode) // RS Encoding
		NextInitCnt = 2 ;
	else if (~Bypass & Start & Mode) // RS Decoding
		NextInitCnt = 1 ;
	else if (DMAState == `DMA_INIT0)
		NextInitCnt = InitCnt -1 ;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	InitCnt <= 0;
	else
	InitCnt <= NextInitCnt;
end

always @(BlkCnt or Start or BigBlk or SmallBlk or 
SmallBlk2 or SmallBlk3 or BlkDatCnt0)
begin
	NextBlkCnt = BlkCnt;
	if (Start & BigBlk)
		NextBlkCnt = 4;
	else if (Start & SmallBlk3)
		NextBlkCnt = 3;
	else if (Start & SmallBlk2)
		NextBlkCnt = 2;
	else if (Start & SmallBlk)
		NextBlkCnt = 1;
	else if ((BigBlk|SmallBlk)&BlkDatCnt0)
		NextBlkCnt = BlkCnt -1 ;
end

always @(BlkDatCnt or Start or DMAState or BlkDatCnt0)
begin
	NextBlkDatCnt = BlkDatCnt;
	if (Start|BlkDatCnt0)
	NextBlkDatCnt = 511;
	else if (DMAState == `DMA_TRANS)
	NextBlkDatCnt = BlkDatCnt -1;
end

always @(DatCnt or Start or DMAState)
begin
	NextDatCnt = DatCnt;
	if (Start)
	NextDatCnt = 0;
	else if (DMAState == `DMA_TRANS)
	NextDatCnt = DatCnt +1;
end

always @(Address or Start or DMAState or StartAddr)
begin
	NextAddress = Address;
	if (Start)
	NextAddress = StartAddr;
	else if (DMAState == `DMA_TRANS)
	NextAddress = Address + 1; 
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	Address = 0;
	else
	Address = NextAddress;
end


always @(SplitCnt or SplitSize or SplitCnt0 or DMAState or NandREQ)
begin
	NextSplitCnt = SplitCnt;
	if (SplitCnt0&NandREQ)
	NextSplitCnt = SplitSize;
	else if ((DMAState == `DMA_TRANS)&(~SplitCnt0)) // 2007.7.11 split count bug
	NextSplitCnt = 	SplitCnt - 1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	BlkCnt <= 0;
	else
	BlkCnt <= NextBlkCnt;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	BlkDatCnt <= 0;
	else
	BlkDatCnt <= NextBlkDatCnt;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	DatCnt <= 0;
	else
	DatCnt <= NextDatCnt;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	SplitCnt <= 0;
	else
	SplitCnt <= NextSplitCnt;
end

always @(WaitCnt or NextWaitCnt or DMAState or Mode)
begin
	NextWaitCnt = WaitCnt;
	if (Mode & (DMAState == `DMA_TRANS))
	NextWaitCnt = 8;
	else if (Mode & (DMAState == `DMA_WAIT1))
	NextWaitCnt = WaitCnt - 1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	WaitCnt <= 0;
	else
	WaitCnt <= NextWaitCnt;
end

assign SyndProcess = Mode& ((DMAState == `DMA_WAIT1)|(DMAState == `DMA_TRANS));




always @(DMAState or NandREQ or Bypass or Start or InitCnt0 or
		 BlkCnt0 or BlkDatCnt0 or SplitCnt0 or TransferDone or 
		Mode or DecodeNotDone or WaitCnt0)
begin
	NextDMAState = DMAState;
	case (DMAState)
	`DMA_IDLE :
		if (Bypass & Start & NandREQ)
		NextDMAState = `DMA_TRANS;
		else if (Bypass & Start)
		NextDMAState = `DMA_WAIT;
		else if (Start)			
		NextDMAState = `DMA_INIT0;
	`DMA_INIT0:
		if (InitCnt0 & NandREQ)
		NextDMAState = `DMA_TRANS;
		else if (InitCnt0 & ~NandREQ)// 2007.07.13. InitCnt0 Ãß°¡ 
		NextDMAState = `DMA_WAIT;
	`DMA_INIT1:
		if (NandREQ)
		NextDMAState = `DMA_TRANS;
		else 
		NextDMAState = `DMA_WAIT;
	`DMA_TRANS:
		if (Bypass & TransferDone)
		NextDMAState = `DMA_IDLE;
		else if (~Mode & TransferDone)
		NextDMAState = `DMA_DONE;
		else if (Mode & ~Bypass & ~BlkCnt0 & BlkDatCnt0) // for RS Dec 8 parity
		NextDMAState = `DMA_WAIT1;
		else if (~Bypass & ~BlkCnt0 & BlkDatCnt0) // RS Initial
		NextDMAState = `DMA_INIT1;
		else if (SplitCnt0 & ~NandREQ)
		NextDMAState = `DMA_WAIT;
	`DMA_WAIT1: // Decoding Parity Calculate
		if (DecodeNotDone)
		NextDMAState = `DMA_WAIT2;
		else if (WaitCnt0 & BlkCnt0)
		NextDMAState = `DMA_DONE;
		else if(WaitCnt0)
		NextDMAState = `DMA_INIT1;
	`DMA_WAIT2: // Wait Decoding done
		if	(~DecodeNotDone)
		NextDMAState = `DMA_WAIT1;
	`DMA_WAIT:
		if (NandREQ)
		NextDMAState = `DMA_TRANS;
	`DMA_DONE:
		if (Mode & DecodeEndCnt0)
		NextDMAState = `DMA_IDLE;
		else if (~Mode)
		NextDMAState = `DMA_IDLE;
	default: NextDMAState = `DMA_IDLE;
	endcase
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	DMAState <= `DMA_IDLE;
	else
	DMAState <= NextDMAState;
end

assign RAM_ADDR = Address;

assign Nand_WEn = 	~Mode & (DMAState == `DMA_TRANS);
//assign RAM_REn 	= Nand_WEn;
assign Nand_REn = 	Mode &  (DMAState == `DMA_TRANS);
assign RAM_WEn 	= Nand_REn;

wire	RSParityCatch = ~Bypass & ~Mode & ((DMAState == `DMA_INIT1)|(DMAState == `DMA_DONE));

wire	BlockStart = ~Bypass & ~Mode & Start ;

assign RSEn_Start = ~Bypass & ~Mode & ((DMAState == `DMA_INIT0)|(DMAState == `DMA_INIT1)); 

assign RSDe_First_Start = ~Bypass & Mode & Start;

assign RSDe_Start = ~Bypass &  Mode & ((DMAState == `DMA_INIT0)|(DMAState == `DMA_INIT1));

assign RSDe_Wait = ((~Bypass)&(Mode))? (DMAState == `DMA_IDLE)|(DMAState == `DMA_WAIT)|(DMAState == `DMA_WAIT2): 1'b1; // Nand Read Wait
assign RSEn_Wait = ((~Bypass)&(~Mode))? ~(DMAState == `DMA_TRANS) : 1'b1; // Nand Write Wait

reg TransferEnd;
reg	NextTransferEnd;
always @(TransferEnd or NextDMAState or DMAState)
begin
	NextTransferEnd = TransferEnd;
	if ((NextDMAState== `DMA_IDLE) &(DMAState != `DMA_IDLE))
	NextTransferEnd = 1;
	else
	NextTransferEnd = 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	TransferEnd <= 0;
	else
	TransferEnd <= NextTransferEnd;
end

endmodule
