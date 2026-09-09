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

reg [7:0] memory0[{(ADDR_WIDTH-1){1'b1}}:0];
reg [7:0] memory1[{(ADDR_WIDTH-1){1'b1}}:0];
reg [7:0] memory2[{(ADDR_WIDTH-1){1'b1}}:0];
reg [7:0] memory3[{(ADDR_WIDTH-1){1'b1}}:0];

reg [31:0] RDATA;

integer i;
always @(posedge CLK)
begin
	if(CEn == 1'b0)
	begin
		if(WEn[0] == 1'b0)
			memory0[ADDR] = WDATA[7:0];
		if(WEn[1] == 1'b0)
			memory1[ADDR] = WDATA[15:8];
		if(WEn[2] == 1'b0)
			memory2[ADDR] = WDATA[23:16];
		if(WEn[3] == 1'b0)
			memory3[ADDR] = WDATA[31:24];
		RDATA <= {memory3[ADDR], memory2[ADDR], memory1[ADDR], memory0[ADDR]};
	end
end

endmodule
