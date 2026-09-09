// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/GND.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: GND cell

*/

`timescale  100 ps / 10 ps

`celldefine

module GND(G);

    parameter cds_action = "ignore";

    output G;

	assign G = 1'b0;

endmodule

`endcelldefine
