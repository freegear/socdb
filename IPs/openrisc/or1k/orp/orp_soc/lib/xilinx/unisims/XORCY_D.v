// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/XORCY_D.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: XOR for carry logic

*/

`timescale  100 ps / 10 ps

`celldefine

module XORCY_D (O, LO, CI, LI);

    parameter cds_action = "ignore";

    output O, LO;

    input  CI, LI;

	xor X1 (O, CI, LI);
	xor X2 (LO, CI, LI);

    specify
	(CI *> O) = (1, 1);
	(LI *> O) = (1, 1);
	(CI *> LO) = (1, 1);
	(LI *> LO) = (1, 1);
    endspecify

endmodule

`endcelldefine
