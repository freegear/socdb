// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/AND2.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: 2-INPUT AND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module AND2 (O, I0, I1);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1;

    and A1 (O, I0, I1);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
