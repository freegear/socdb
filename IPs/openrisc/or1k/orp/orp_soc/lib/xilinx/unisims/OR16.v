// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OR16.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: 16-INPUT OR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module OR16 (O, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15;

    or O1 (O, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
	(I2 *> O) = (1, 1);
	(I3 *> O) = (1, 1);
	(I4 *> O) = (1, 1);
	(I5 *> O) = (1, 1);
	(I6 *> O) = (1, 1);
	(I7 *> O) = (1, 1);
	(I8 *> O) = (1, 1);
	(I9 *> O) = (1, 1);
	(I10 *> O) = (1, 1);
	(I11 *> O) = (1, 1);
	(I12 *> O) = (1, 1);
	(I13 *> O) = (1, 1);
	(I14 *> O) = (1, 1);
	(I15 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
