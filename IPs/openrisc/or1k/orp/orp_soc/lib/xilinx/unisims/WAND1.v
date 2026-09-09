// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/WAND1.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: 1-INPUT WIRED AND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module WAND1 (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

    wand O;

	bufif0 T1 (O, I, I);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
