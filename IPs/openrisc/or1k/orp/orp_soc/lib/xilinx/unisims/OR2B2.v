// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OR2B2.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: 2-INPUT OR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module OR2B2 (O, I0, I1);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1;

    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    or O1 (O, i0_inv, i1_inv);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
