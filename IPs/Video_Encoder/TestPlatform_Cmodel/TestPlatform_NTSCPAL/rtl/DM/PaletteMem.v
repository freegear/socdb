module PaletteMem(
	clk, rst, ce, we, oe, addr, di, do
);

`include "DmDef.v"

//
// Default address and data buses width
//
parameter aw = 8;
parameter dw = 24;

//
// Generic synchronous single-port RAM interface
//
input			clk;	// Clock
input			rst;	// Reset
input			ce;	// Chip enable input
input			we;	// Write enable input
input			oe;	// Output enable input
input 	[aw-1:0]	addr;	// address bus inputs
input	[dw-1:0]	di;	// input data bus
output	[dw-1:0]	do;	// output data bus

//
// Internal wires and registers
//


`ifdef CHIP

//
// Instantiation of ASIC memory:
//
// Artisan Synchronous Single-Port RAM (ra1sh)
//
RA1SH512x24 artisan_ssp(
	.CLK(clk),
	.CEN(~ce),
	.WEN(~we),
	.A({1'b0, addr}),
	.D(di),
//	.OEN(~oe),
	.Q(do)
);

`else

`ifdef XILINX

//
// Instantiation of FPGA memory:
//
// Virtex/Spartan2
//
ramb4_s16 ramb4_s16(
	.clk(clk),
	.rst(rst),
	.addr(addr),
	.di(di),
	.en(ce),
	.we(we),
	.do(do)
);

`else

//
// Generic single-port synchronous RAM model
//

//
// Generic RAM's registers and wires
//
reg	[dw-1:0]	mem [(2<<aw)-1:0];	// RAM content
reg	[dw-1:0]	do_reg;			// RAM data output register

//
// Data output drivers
//
//assign do = (oe) ? do_reg : {dw{1'bz}};
assign do = do_reg;

//
// RAM read and write
//
always @(posedge clk)
	if (ce && !we)
		do_reg <= #1 mem[addr];
	else if (ce && we) begin
		mem[addr] <= #1 di;
		do_reg <= #1 di;
	end

`endif	// !XILINX
`endif	// !ARTISAN_SSP

endmodule