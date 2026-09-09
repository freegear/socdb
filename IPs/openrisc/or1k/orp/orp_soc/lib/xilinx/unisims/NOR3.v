// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/NOR3.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: 3-INPUT NOR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module NOR3 (O, I0, I1, I2);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1, I2;

    nor O1 (O, I0, I1, I2);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
	(I2 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
