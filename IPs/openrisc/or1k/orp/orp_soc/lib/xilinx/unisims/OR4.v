// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OR4.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: 4-INPUT OR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module OR4 (O, I0, I1, I2, I3);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1, I2, I3;

    or O1 (O, I0, I1, I2, I3);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
	(I2 *> O) = (1, 1);
	(I3 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
