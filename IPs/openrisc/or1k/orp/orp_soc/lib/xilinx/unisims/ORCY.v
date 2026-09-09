// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/ORCY.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: OR for carry logic

*/

`timescale  100 ps / 10 ps

`celldefine

module ORCY (O, CI, I);

    parameter cds_action = "ignore";

    output O;

    input  CI, I;

	or X1 (O, CI, I);

    specify
	(CI *> O) = (1, 1);
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
