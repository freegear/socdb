// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/WOR2AND.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: WIRED OR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module WOR2AND (O, I0, I1);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1;

    wand O;

	or O1 (O, I0, I1);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
