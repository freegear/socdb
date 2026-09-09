// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : APB2AHB.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : APB2AHB glue logic for DMAC
//                     : This module is NOT a generation APB-to-AHB interface.
//  =============================================================================

`timescale 1ns/1ps

module APB2AHB
(
		CLK     ,  // AHB/APB Clock
		RESETn  ,  // AHB/APB Reset

		// APB signals
		PADDR    ,  // APB Address
		PWRITE   ,  // APB Write/Read
		PSEL     ,  // APB Select
		PENABLE  ,  // APB Enable
		PRDATA   ,  // APB Read Data
		PWDATA   ,  // APB Write Data
		PREADY   ,  // APB Ready

		// AHB signals
		HSEL     ,  // AHB Selection
		HWRITE   ,  // AHB Write/Read
		HTRANS   ,  // AHB HTRANS[1]
		HADDR    ,  // AHB Address
		HSIZE    ,  // AHB Size : Word only
		HREADYIN ,  // AHB HREADY_input
		HWDATA   ,  // AHB write data bus
		HREADYOUT,  // AHB HREADY_output
		HRESP    ,  // AHB response
		HRDATA      // AHB read data bus
);

input  CLK;
input  RESETn;

input  [11:2] PADDR;
input  PWRITE;
input  PSEL;
input  PENABLE;
output [31:0] PRDATA;
input  [31:0] PWDATA;
output PREADY;

output HSEL;
output HWRITE;
output HTRANS;
output [11:2] HADDR;
output [2:0] HSIZE;
output HREADYIN;
output [31:0] HWDATA;
input  HREADYOUT;
input  [1:0] HRESP;
input  [31:0] HRDATA;

// Next assignment suffices for APB-to-AHB glue logic for DMAC(PL080)
assign HSEL = PSEL;
assign HWRITE = PWRITE;
assign HTRANS = PSEL & (~PENABLE);	// should be preserved until HREADYOUT gets high ?
assign HADDR = PADDR;
assign HSIZE = 3'b010;	// always WORD
assign HREADYIN = HREADYOUT;
assign HWDATA = PWDATA;
assign PRDATA = HRDATA;
assign PREADY = HREADYOUT;

endmodule
