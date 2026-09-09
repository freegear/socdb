// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/XORCY.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: XOR for carry logic

*/

`timescale  100 ps / 10 ps

`celldefine

module XORCY (O, CI, LI);

    parameter cds_action = "ignore";

    output O;

    input  CI, LI;

	xor X1 (O, CI, LI);

    specify
	(CI *> O) = (1, 1);
	(LI *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
