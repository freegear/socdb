// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SSRAM32bit.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Synchronous SRAM
//                     : This module is for test purpose only.
//  =============================================================================

`timescale 1ns/10ps

module SSRAM32bit 
(
		CLK     , 

		ADDR    ,
		CEn     ,
		WEn     ,
		RDATA   ,
		WDATA
);

//
// module parameter
//
parameter ADDR_WIDTH = 12;	// Memory Address Width : should be at least 12(4KB)

input  CLK;
input  [ADDR_WIDTH-1:0] ADDR;
input  CEn;
input  [3:0] WEn;
input  [31:0] WDATA;
output [31:0] RDATA;

SSRAM8bit #(.ADDR_WIDTH(ADDR_WIDTH)) ram0(
	.CLK(CLK),
	.ADDR(ADDR),
	.CEn(CEn),
	.WEn(WEn[0]),
	.WDATA(WDATA[7:0]),
	.RDATA(RDATA[7:0])
);

SSRAM8bit #(.ADDR_WIDTH(ADDR_WIDTH)) ram1(
	.CLK(CLK),
	.ADDR(ADDR),
	.CEn(CEn),
	.WEn(WEn[1]),
	.WDATA(WDATA[15:8]),
	.RDATA(RDATA[15:8])
);

SSRAM8bit #(.ADDR_WIDTH(ADDR_WIDTH)) ram2(
	.CLK(CLK),
	.ADDR(ADDR),
	.CEn(CEn),
	.WEn(WEn[2]),
	.WDATA(WDATA[23:16]),
	.RDATA(RDATA[23:16])
);

SSRAM8bit #(.ADDR_WIDTH(ADDR_WIDTH)) ram3(
	.CLK(CLK),
	.ADDR(ADDR),
	.CEn(CEn),
	.WEn(WEn[3]),
	.WDATA(WDATA[31:24]),
	.RDATA(RDATA[31:24])
);

endmodule
