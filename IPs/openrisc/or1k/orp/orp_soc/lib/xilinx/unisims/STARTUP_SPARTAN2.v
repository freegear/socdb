// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/STARTUP_SPARTAN2.v,v 1.1 2002/03/28 20:15:31 lampret Exp $
/*

FUNCTION	: Special Function Cell, STARTUP_SPARTAN2

*/

`timescale  100 ps / 10 ps

`celldefine

module STARTUP_SPARTAN2 (CLK, GSR, GTS);

    parameter cds_action = "ignore";

    input  CLK, GSR, GTS;

    tri0 GSR, GTS;

	assign glbl.GSR = GSR;
	assign glbl.GTS = GTS;

endmodule

`endcelldefine
