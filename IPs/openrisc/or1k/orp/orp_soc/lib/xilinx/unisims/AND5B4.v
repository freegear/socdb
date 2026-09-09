// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/AND5B4.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: 5-INPUT AND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module AND5B4 (O, I0, I1, I2, I3, I4);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1, I2, I3, I4;

    not N3 (i3_inv, I3);
    not N2 (i2_inv, I2);
    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    and A1 (O, i0_inv, i1_inv, i2_inv, i3_inv, I4);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
	(I2 *> O) = (1, 1);
	(I3 *> O) = (1, 1);
	(I4 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
