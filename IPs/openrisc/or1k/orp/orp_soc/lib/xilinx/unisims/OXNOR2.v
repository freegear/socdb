// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OXNOR2.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: OUTPUT XNOR2

*/

`timescale  100 ps / 10 ps

`celldefine

module OXNOR2 (O, I0, F);

    parameter cds_action = "ignore";

    output O;

    input  I0, F;

    tri0 GTS = glbl.GTS;

	xnor X1 (i_ts, F, I0);
	bufif0 B1 (O, i_ts, GTS);

    specify
	(I0 *> O) = (1, 1);
	(F  *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
