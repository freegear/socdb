// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/INV.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: INVERTER

*/

`timescale  100 ps / 10 ps

`celldefine

module INV (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

	not N1 (O, I);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
