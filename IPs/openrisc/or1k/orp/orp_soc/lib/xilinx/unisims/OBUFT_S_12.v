// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFT_S_12.v,v 1.1 2002/03/28 20:15:29 lampret Exp $

/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFT_S_12 (O, I, T);

    parameter cds_action = "ignore";

    output O;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (O, I, ts);

    specify
	(I *> O) = (1, 1);
	(T *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
