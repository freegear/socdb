// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacAPBMux.v
// File Revision       : 1.0
//  -----------------------------------------------------------------------------
//  Purpose            : This is a part of DMA Controler.
//  =============================================================================
`timescale 1ns/1ps

module DmacAPBMux (
	// APB interface
	PCLK, 
	PRESETn, 
	PENABLE, 
	PSEL,
	PWRITE, 
	PADDR, 
	PWDATA,
	PRDATA,

	PCLK0,
	PRESETn0,
	PENABLE0, 
	PSEL0,
	PWRITE0, 
	PADDR0, 
	PWDATA0,
	PRDATA0,

	PCLK1,
	PRESETn1,
	PENABLE1, 
	PSEL1,
	PWRITE1, 
	PADDR1, 
	PWDATA1,
	PRDATA1
);

// if you want to build 2x2 DMAC, PADDR_MAX should be 6
// if you want to build 2x4 DMAC, PADDR_MAX should be 7
parameter PADDR_MAX = 6;

// APB interface
input         PCLK;
input         PRESETn;
input         PENABLE; 
input         PSEL;
input         PWRITE;
input  [PADDR_MAX:2]  PADDR;
input  [31:0] PWDATA;
output [31:0] PRDATA;

output        PCLK0;
output        PRESETn0;
output        PENABLE0; 
output        PSEL0;
output        PWRITE0;
output [PADDR_MAX-1:2]  PADDR0;
output [31:0] PWDATA0;
input  [31:0] PRDATA0;

output        PCLK1;
output        PRESETn1;
output        PENABLE1; 
output        PSEL1;
output        PWRITE1;
output [PADDR_MAX-1:2]  PADDR1;
output [31:0] PWDATA1;
input  [31:0] PRDATA1;

// default assignment
assign PCLK0    = PCLK;
assign PRESETn0 = PRESETn;
assign PENABLE0 = PENABLE;
assign PWRITE0  = PWRITE;
assign PADDR0   = PADDR[PADDR_MAX-1:2];
assign PWDATA0  = PWDATA;
assign PSEL0    = PSEL & (~PADDR[PADDR_MAX]);

assign PCLK1    = PCLK;
assign PRESETn1 = PRESETn;
assign PENABLE1 = PENABLE;
assign PWRITE1  = PWRITE;
assign PADDR1   = PADDR[PADDR_MAX-1:2];
assign PWDATA1  = PWDATA;
assign PSEL1    = PSEL & (PADDR[PADDR_MAX]);


assign PRDATA   = (PADDR[PADDR_MAX] == 0) ? PRDATA0 : PRDATA1;

endmodule
