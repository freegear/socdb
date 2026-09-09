// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_Control.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module Serializer module in I2S Controller.
//  =============================================================================

`timescale 1ns/1ps

module I2S_Control 
(
		// APB BUS
		PCLK,
		PRESETn,
		PADDR,
		PENABLE,
		PSEL,
		PWRITE,
		PWDATA,
		PRDATA,

		// Interrupt Output
		Interrupt,
		// DMA Request
		TxDMAReq,
		RxDMAReq,

		// Clock Control
		ClkMS,			// 0 when Slave mode, 1 when LRCLK/BCLK Master mode
		LRClkInv,		// 0 when normal LRCLK, 1 when Inverted LRCLK
		MClkOn,			// DTO operation on/off
		MClkOE,			// MCLK output enable(active high)
		DTORatio,		// DTORatio

		// Tx Control
		TxEnabled,		// 1 when Enabled 
		TxReset,		// 1 when user reset requested
		TxWordLength,	// 00 : 8bit, 01 : 16bit, 10 : 24 bit, 11 : 32 bit
		TxLeftJust,		// 0 when I2SMode, 1 when Left Justfied mode
		TxFifoUnderRun,	// 1 when Fifo UnderRun detected.

		// Rx Control
		RxEnabled,		// 1 when Enabled 
		RxReset,		// 1 when user reset requested
		RxWordLength,	// 00 : 8bit, 01 : 16bit, 10 : 24 bit, 11 : 32 bit
		RxLeftJust,		// 0 when I2SMode, 1 when Left Justfied mode
		RxFifoOverRun,	// 1 when Fifo OverRun detected.

		// TxFIFO
		TxFifoWData,
		nTxFifoWriteEn,
		TxFifoFull,
		TxFifoEmpty,
		TxFifoLevel,

		// RxFIFO
		RxFifoData,
		nRxFifoReadEn,
		RxFifoFull,
		RxFifoEmpty,
		RxFifoLevel
);

//
// input/output port
//
input         PCLK;
input         PRESETn;
input  [ 3:2] PADDR;
input         PENABLE;
input         PSEL;
input         PWRITE;
input  [31:0] PWDATA;
output [31:0] PRDATA;

output        Interrupt;
output        TxDMAReq;
output        RxDMAReq;

output        ClkMS;
output        LRClkInv;
output        MClkOn;
output        MClkOE;
output [27:0] DTORatio;

output        TxEnabled;
output        TxReset;
output [1:0]  TxWordLength;
output        TxLeftJust;
input         TxFifoUnderRun;

output        RxEnabled;
output        RxReset;
output [1:0]  RxWordLength;
output        RxLeftJust;
input         RxFifoOverRun;

output [31:0] TxFifoWData;
output        nTxFifoWriteEn;
input         TxFifoFull;
input         TxFifoEmpty;
input  [ 5:0] TxFifoLevel;

output [31:0] RxFifoData;
output        nRxFifoReadEn;
input         RxFifoFull;
input         RxFifoEmpty;
input  [ 5:0] RxFifoLevel;

// Register Address
parameter CLKCTRL_ADDR =2'b00;
parameter CTRL_ADDR    =2'b01;
parameter STATUS_ADDR  =2'b10;
parameter DATA_ADDR    =2'b11;

wire APBWrite;
wire APBRead;
assign APBWrite = PSEL & (~PENABLE) & PWRITE;
assign APBRead  = PSEL & (~PENABLE) & (~PWRITE);

// Clock Control register
reg        ClkMS;
reg        LRClkInv;
reg        MClkOn;
reg        MClkOE;
reg [27:0] DTORatio;
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		ClkMS <= 0;
		LRClkInv <= 0;
		MClkOn <= 0;
		MClkOE <= 0;
		DTORatio <= 0;
	end
	else if(APBWrite && (PADDR == CLKCTRL_ADDR))
	begin
		ClkMS <= PWDATA[31];
		LRClkInv <= PWDATA[30];
		MClkOn <= PWDATA[29];
		MClkOE <= PWDATA[28];
		DTORatio <= PWDATA[27:0];
	end
end
wire [31:0] ClkCtrlReg;
assign ClkCtrlReg = {ClkMS, LRClkInv, MClkOn, MClkOE, DTORatio};

// Control Register
reg       RxEn;
reg       RxReset;
reg       RxDMAIntEn;
reg       RxFifoORIntEn;
reg [1:0] RxWLen;
reg       RxLJust;
reg [5:0] RxFifoTH;

reg       TxEn;
reg       TxReset;
reg       TxDMAIntEn;
reg       TxFifoURIntEn;
reg [1:0] TxWLen;
reg       TxLJust;
reg [5:0] TxFifoTH;

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		RxEn          <= 0;
		RxDMAIntEn    <= 0;
		RxFifoORIntEn <= 0;
		RxWLen        <= 2'b01;	// 16bit/sample
		RxLJust       <= 0;
		RxFifoTH      <= 1;
		TxEn          <= 0;
		TxDMAIntEn    <= 0;
		TxFifoURIntEn <= 0;
		TxWLen        <= 2'b01;	// 16bit/sample
		TxLJust       <= 0;
		TxFifoTH      <= 1;
	end
	else if(APBWrite && (PADDR == CTRL_ADDR))
	begin
		RxEn          <= PWDATA[31];
		RxDMAIntEn    <= PWDATA[29];
		RxFifoORIntEn <= PWDATA[28];
		RxWLen        <= PWDATA[26:25];	// 16bit/sample
		RxLJust       <= PWDATA[24];
		RxFifoTH      <= PWDATA[21:16];
		TxEn          <= PWDATA[15];
		TxDMAIntEn    <= PWDATA[13];
		TxFifoURIntEn <= PWDATA[12];
		TxWLen        <= PWDATA[10:9];	// 16bit/sample
		TxLJust       <= PWDATA[8];
		TxFifoTH      <= PWDATA[5:0];
	end
end
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		RxReset <= 1;
		TxReset <= 1;
	end
	else
	begin
		if(APBWrite && (PADDR == CTRL_ADDR))
		begin
			RxReset <= PWDATA[30];
			TxReset <= PWDATA[14];
		end
		else
		begin
			if(RxReset == 1) RxReset <= 0;
			if(TxReset == 1) TxReset <= 0;
		end
	end
end
wire [31:0] CtrlReg;
assign CtrlReg = {RxEn, 1'b0, RxDMAIntEn, RxFifoORIntEn, 1'b0, RxWLen, RxLJust, 2'b00, RxFifoTH, TxEn, 1'b0, TxDMAIntEn, TxFifoURIntEn, 1'b0, TxWLen, TxLJust, 2'b00, TxFifoTH};

// Status Register
reg RxFifoORInt;
reg TxFifoURInt;
wire [31:0] StatusReg;
assign StatusReg = {RxDMAReq, RxFifoORInt, TxDMAReq, TxFifoURInt, 13'd0, RxFifoFull, RxFifoLevel, 1'b0, TxFifoFull, TxFifoLevel};


// Data Regiister
reg [31:0] TxFifoWData;
reg        nTxFifoWriteEn;
always @(posedge PCLK) TxFifoWData <= PWDATA;

always @(posedge PCLK)
begin
	if(APBWrite && (PADDR == DATA_ADDR))
		nTxFifoWriteEn <= 0;
	else
		nTxFifoWriteEn <= 1;
end

// Register Read
reg [31:0] PRDATA;
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		PRDATA <= 0;
	else if(APBRead)
	begin
		case(PADDR)
		CLKCTRL_ADDR: PRDATA <= ClkCtrlReg;
		CTRL_ADDR:    PRDATA <= CtrlReg;
		STATUS_ADDR:  PRDATA <= StatusReg;
		DATA_ADDR:    PRDATA <= (RxFifoEmpty) ? 32'h00000000 : RxFifoData;
		endcase
	end
end
assign nRxFifoReadEn = ~(APBRead && (PADDR == DATA_ADDR) && RxFifoEmpty);

// Interrupt Processing
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		RxFifoORInt <= 0;
	else if(RxReset)
		RxFifoORInt <= 0;
	else if(APBWrite && (PADDR == STATUS_ADDR) && PWDATA[30])
		RxFifoORInt <= 0;
	else if(RxFifoOverRun && RxFifoORIntEn)
		RxFifoORInt <= 1;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		TxFifoURInt <= 0;
	else if(RxReset)
		TxFifoURInt <= 0;
	else if(APBWrite && (PADDR == STATUS_ADDR) && PWDATA[28])
		TxFifoURInt <= 0;
	else if(TxFifoUnderRun && TxFifoURIntEn)
		TxFifoURInt <= 1;
end

reg Interrupt;
always @(posedge PCLK or negedge PRESETn)
	if(!PRESETn)
		Interrupt <= 0;
	else
		Interrupt <= RxFifoORInt | TxFifoURInt | (RxDMAReq & RxDMAIntEn) | (TxDMAReq & TxDMAIntEn);

// DMA Request Processing
reg TxDMAReq;
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		TxDMAReq <= 0;
	else if(TxReset)
		TxDMAReq <= 0;
	else if(TxEn && ~TxFifoFull && (TxFifoLevel <= TxFifoTH))
		TxDMAReq <= 1;
	else
		TxDMAReq <= 0;
end

reg RxDMAReq;
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		RxDMAReq <= 0;
	else if(RxReset)
		RxDMAReq <= 0;
	else if(RxEn && ~RxFifoEmpty && (RxFifoLevel > RxFifoTH))
		RxDMAReq <= 1;
	else
		RxDMAReq <= 0;
end

// Tx Enable Register
reg TxEnabled;
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		TxEnabled <= 0;
	else if(TxReset)
		TxEnabled <= 0;
	else if(TxEn)
		TxEnabled <= 1;
	else if(TxFifoEmpty)
		TxEnabled <= 0;
end

// OUtput Assign
assign TxLeftJust   = TxLJust;
assign TxWordLength = TxWLen;

assign RxEnabled    = RxEn;
assign RxLeftJust   = RxLJust;
assign RxWordLength = RxWLen;

endmodule
