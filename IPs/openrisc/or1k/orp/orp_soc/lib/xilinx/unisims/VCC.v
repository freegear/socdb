// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/VCC.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: VCC cell

*/

`timescale  100 ps / 10 ps

`celldefine

module VCC(P);

    parameter cds_action = "ignore";

    output P;

	assign P = 1'b1;

endmodule

`endcelldefine
