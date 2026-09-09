// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : addrlatcher.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : 8051 address latch for P_mem and D_mem address map
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module addrlatcher(
RESETn,
CLK,
ALE,
xrom_addr,
xrom_ce_b,
xram_ce_b,
xrom_oe_b,
xram_oe_b,
mem_addr,
mem_ce_b,
mem_oe_b
);

input 			RESETn;
input 			CLK;
input 			ALE;
input	[15:0] 	xrom_addr;
input 			xrom_ce_b;
input			xram_ce_b;
input			xrom_oe_b;
input			xram_oe_b;

output	[15:0]	mem_addr;
output			mem_ce_b;
output			mem_oe_b;

wire	mem_ce_b;
wire	mem_oe_b;

assign	mem_ce_b = xrom_ce_b & xram_ce_b;
assign	mem_oe_b = xrom_oe_b & xram_oe_b;

reg 	[15:0]	addr;
reg		[15:0]	nextaddr;

always @(ALE or addr or xrom_addr)
begin
	nextaddr = addr;
	if (ALE)
	nextaddr = xrom_addr;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	addr <= 0;
	else
	addr <= nextaddr;
end

assign mem_addr = addr;

endmodule

