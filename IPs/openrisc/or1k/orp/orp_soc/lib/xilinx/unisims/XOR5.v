// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/XOR5.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: 5-INPUT XOR GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module XOR5 (O, I0, I1, I2, I3, I4);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1, I2, I3, I4;

	xor X1 (O, I0, I1, I2, I3, I4);

    specify
	(I0 *> O) = (1, 1);
	(I1 *> O) = (1, 1);
	(I2 *> O) = (1, 1);
	(I3 *> O) = (1, 1);
	(I4 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
