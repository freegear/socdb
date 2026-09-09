// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/AND2B1.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: 2-INPUT AND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module AND2B1 (O, I0, I1);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1;

    not N0 (i0_inv, I0);
    and A1 (O, i0_inv, I1);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
