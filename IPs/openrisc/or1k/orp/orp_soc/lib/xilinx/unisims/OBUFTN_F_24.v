// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFTN_F_24.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: INVERTING TRI-STATE FAST SLEW 24 MA OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFTN_F_24 (O, I, T);

    parameter cds_action = "ignore";

    output O;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    notif0 T1 (O, I, ts);

    specify
	(I *> O) = (1, 1);
	(T *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
