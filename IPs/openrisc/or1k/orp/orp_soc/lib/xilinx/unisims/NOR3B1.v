// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/NOR3B1.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: 3-INPUT NOR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module NOR3B1 (O, I0, I1, I2);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1, I2;

    not N0 (i0_inv, I0);
    nor O1 (O, i0_inv, I1, I2);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
	(I2 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
