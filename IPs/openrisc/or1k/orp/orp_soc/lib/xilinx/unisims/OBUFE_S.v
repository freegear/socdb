// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFE_S.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFE_S (O, E, I);

    parameter cds_action = "ignore";

    output O;

    input  E, I;

    tri0 GTS = glbl.GTS;

    not I1 (T, E);
    or O1 (ts, GTS, T);
    bufif0 T1 (O, I, ts);

    specify
	(I *> O) = (1, 1);
	(E *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
