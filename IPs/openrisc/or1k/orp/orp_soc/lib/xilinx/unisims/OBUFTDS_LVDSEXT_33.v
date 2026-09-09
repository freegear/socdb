// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFTDS_LVDSEXT_33.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFTDS_LVDSEXT_33 (O, OB, I, T);

    parameter cds_action = "ignore";

    output O, OB;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 B1 (O, I, ts);
    notif0 N1 (OB, I, ts);

    specify
	(I *> O) = (1, 1);
	(T *> O) = (1, 1);
	(I *> OB) = (1, 1);
	(T *> OB) = (1, 1);
    endspecify

endmodule

`endcelldefine

