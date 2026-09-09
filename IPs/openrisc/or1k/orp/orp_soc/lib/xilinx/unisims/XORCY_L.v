// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/XORCY_L.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: XOR for carry logic

*/

`timescale  100 ps / 10 ps

`celldefine

module XORCY_L (LO, CI, LI);

    parameter cds_action = "ignore";

    output LO;

    input  CI, LI;

	xor X1 (LO, CI, LI);

    specify
	  (CI *> LO) = (1, 1);
	  (LI *> LO) = (1, 1);
    endspecify

endmodule

`endcelldefine
