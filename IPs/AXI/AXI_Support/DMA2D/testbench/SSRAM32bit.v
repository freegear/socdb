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

reg [31:0] memory[{ADDR_WIDTH{1'b1}}:0];

reg [31:0] RDATA;

integer i;
always @(posedge CLK)
begin
	if(CEn == 1'b0)
	begin
		if(WEn[0] == 1'b0)
			memory[ADDR][7:0] = WDATA[7:0];
		if(WEn[1] == 1'b0)
			memory[ADDR][15:8] = WDATA[15:8];
		if(WEn[2] == 1'b0)
			memory[ADDR][23:16] = WDATA[23:16];
		if(WEn[3] == 1'b0)
			memory[ADDR][31:24] = WDATA[31:24];
		RDATA <= memory[ADDR];
	end
end

endmodule
