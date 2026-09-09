// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFEN_F_24.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: INVERTING ACTIVE-LOW TRISTATE FAST SLEW 24 MA OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFEN_F_24 (O, E, I);

    parameter cds_action = "ignore";

    output O;

    input  E, I;

    tri0 GTS = glbl.GTS;

    not I1 (T, E);
    or O1 (ts, GTS, T);
    notif0 T1 (O, I, ts);

    specify
	(I *> O) = (1, 1);
	(E *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
