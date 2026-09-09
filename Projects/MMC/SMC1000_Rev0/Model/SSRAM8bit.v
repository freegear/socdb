// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SSRAM8bit.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Synchronous SRAM
//                     : This module is for test purpose only.
//  =============================================================================

`timescale 1ns/10ps

module SSRAM8bit 
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
parameter ADDR_WIDTH = 11;	// Memory Address Width : should be at least 12(4KB)

input  CLK;
input  [ADDR_WIDTH-1:0] ADDR;
input  CEn;
input  WEn;
input  [7:0] WDATA;
output [7:0] RDATA;

reg [7:0] memory[{(ADDR_WIDTH){1'b1}}:0];

reg [7:0] RDATA;

always @(posedge CLK)
begin
	if(CEn == 1'b0)
	begin
		if(WEn == 1'b0)
		begin
			memory[ADDR] = WDATA;
			RDATA = memory[ADDR];
		end
		else
			RDATA = memory[ADDR];
	end
end

endmodule
