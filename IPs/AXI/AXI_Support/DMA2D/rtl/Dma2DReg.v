// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : Dma2DReg.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : part of 2D DMA Controller(APB register)
//  =============================================================================
`timescale 1ns/1ps

module Dma2DReg (
	// APB interface
	PCLK, 
	PRESETn, 
	PENABLE, 
	PSEL,
	PWRITE, 
	PADDR, 
	PWDATA,
	PRDATA,

	// Register Output
	SrcAddr,
	DestAddr,
	ByteCnt,
	LineCnt,
	AddrUpd,

	// write interface for other DMA part
	SrcAddrWE,
	DestAddrWE,
	LineCntWE,

	SrcAddrWData,
	DestAddrWData,
	LineCntWData,

	Active,
	Enabled,

	ErrorInterruptIn,
	StopInterruptIn,

	Interrupt			// Output : Interrupt output
);

// APB interface
input         PCLK;
input         PRESETn;
input         PENABLE; 
input         PSEL;
input         PWRITE;
input  [4:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

input         SrcAddrWE;
input         DestAddrWE;
input         LineCntWE;

input  [31:0] SrcAddrWData;
input  [31:0] DestAddrWData;
input  [31:0] LineCntWData;

input         Active;
output        Enabled;

input         ErrorInterruptIn;
input         StopInterruptIn;

output        Interrupt;

// Register Output
output [31:0] SrcAddr;
output [31:0] DestAddr;
output [15:0] ByteCnt;
output [31:0] LineCnt;
output [31:0] AddrUpd;

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

wire        PCLK;
wire        PRESETn;
wire        PENABLE;
wire        PSEL;
wire        PWRITE;
wire [4:2]  PADDR;
wire [31:0] PWDATA;
reg  [31:0] PRDATA;

// 5 programmable register
reg  [31:0] SrcAddr;
reg  [31:0] DestAddr;
reg  [15:0] ByteCnt;
reg  [31:0] LineCnt;
reg  [31:0] AddrUpd;

// Status Register
reg         Enable;
reg         StopIntEn;
reg         StopInt;
reg         ErrInt;

wire        Enabled;
assign      Enabled = Enable & (~StopInt) & ~(ErrInt);

// address for each register
parameter SrcAddrAddr    = 3'b000;
parameter DestAddrAddr   = 3'b001;
parameter ByteCntAddr    = 3'b010;
parameter LineCntAddr    = 3'b011;
parameter AddrUpdAddr    = 3'b100;
parameter StatusAddr     = 3'b101;
//
// APB interface part
//
wire APB_WriteEnable;
wire APB_ReadEnable;

assign APB_WriteEnable = PSEL & (~PENABLE) & PWRITE;
assign APB_ReadEnable  = PSEL & (~PENABLE) & (~PWRITE);

// Register writings
always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		SrcAddr <= 0;
	else if(APB_WriteEnable & PADDR == SrcAddrAddr)
		SrcAddr <= PWDATA[31:0];
	else if(SrcAddrWE == 1'b1)
		SrcAddr <= SrcAddrWData;
end

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		DestAddr <= 0;
	else if(APB_WriteEnable & PADDR == DestAddrAddr)
		DestAddr <= PWDATA[31:0];
	else if(DestAddrWE == 1'b1)
		DestAddr <= DestAddrWData;
end

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		ByteCnt <= 0;
	else if(APB_WriteEnable && PADDR == ByteCntAddr)
		ByteCnt <= PWDATA[15:0];
end

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		LineCnt <= 0;
	else if(APB_WriteEnable && PADDR == LineCntAddr)
		LineCnt <= PWDATA[31:0];
	else if(LineCntWE == 1'b1)
		LineCnt <= LineCntWData;
end

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		AddrUpd <= 0;
	else if(APB_WriteEnable && PADDR == AddrUpdAddr)
		AddrUpd <= PWDATA[31:0];
end

always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		Enable <= 0;
		StopIntEn <= 0;
		StopInt <= 0;
		ErrInt <= 0;
	end
	else if(APB_WriteEnable & PADDR == StatusAddr)
	begin
		Enable <= PWDATA[31];
		StopIntEn <= PWDATA[4];
		if(PWDATA[1] == 1)
			StopInt <= 0;
		if(PWDATA[0] == 1)
			ErrInt <= 0;
	end
	else
	begin
		ErrInt   <= ErrInt   | ErrorInterruptIn;
		StopInt  <= StopInt  | StopInterruptIn;
	end
end

assign Interrupt = ErrInt|(StopInt&StopIntEn);

// Register reading
always @ (posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		PRDATA <= 32'h00000000;
	else if(PSEL & (~PENABLE) & (~PWRITE))
	begin
		case(PADDR)
		SrcAddrAddr  : PRDATA <= SrcAddr;
		DestAddrAddr : PRDATA <= DestAddr;
		ByteCntAddr  : PRDATA <= {16'h0000, ByteCnt};
		LineCntAddr  : PRDATA <= LineCnt;
		AddrUpdAddr  : PRDATA <= AddrUpd;
		StatusAddr   : PRDATA <= {Enable, 3'b000, Active, 2'b00, 20'h00000, StopIntEn, 2'b00, StopInt, ErrInt};
		default      : PRDATA <= 32'd0;
		endcase
	end
end

endmodule
