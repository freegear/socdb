module PaletteMem(
	Clk, nRST, Csb, Web, Oeb, WAddr, RAddr, DI, DO
);

`include "DmDef.v"

parameter AW = 8;
parameter DW = 32;

input			Clk;	// Clock
input			nRST;	// Reset
input			Csb;	// Chip enable input
input			Web;	// Write enable input
input			Oeb;	// Output enable input
input 	[AW-1:0]	WAddr, RAddr;	// address bus inputs
input	[DW-1:0]	DI;	// input data bus
output	[DW-1:0]	DO;	// output data bus

`ifdef CHIP

wire RCsb = (WAddr==RAddr) & ~Web;

// Instantiation of ASIC memory:
RA2SH256x32 artisan_ssp(
	.QA	 	(),
	.CLKA	(Clk),
	.CENA	(Csb),
	.WENA	(Web),
	.AA		(WAddr),
	.DA		(DI),
	.QB		(DO),
	.CLKB	(Clk),
	.CENB	(RCsb),
	.WENB	(1'b1),
	.AB		(RAddr),
	.DB		(32'b0)
);

`else

// Generic RAM's registers and wires
reg	[DW-1:0]	MEM [{(AW){1'b1}}:0];	// RAM content
reg	[DW-1:0]	DO_reg;			// RAM data output register

// Data output drivers
assign DO = DO_reg;

// RAM read and write
always @(posedge Clk)
	if (~Csb && ~Web)
		MEM[WAddr] <= #1 DI;

always @(posedge Clk)
	if (~Csb &&  Web)
		DO_reg <= #1 MEM[RAddr];

`endif	// !ARTISAN_SSP

endmodule
