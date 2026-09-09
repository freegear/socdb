// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFDS_LVDSEXT_25.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFDS_LVDSEXT_25 (O, OB, I);

    parameter cds_action = "ignore";

    output O, OB;

    input  I;

    tri0 GTS = glbl.GTS;

	bufif0 B1 (O, I, GTS);
	notif0 N1 (OB, I, GTS);

    specify
	(I *> O) = (1, 1);
	(I *> OB) = (1, 1);
    endspecify

endmodule

`endcelldefine

