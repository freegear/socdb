// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/NAND12.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: 12-INPUT NAND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module NAND12 (O, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11;

    nand O1 (O, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11);

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
    endspecify

endmodule

`endcelldefine
