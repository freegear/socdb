// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFS_24.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: OPEN SOURCE 24 MA OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFS_24 (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    or O1_24 (ts, GTS, I);
    bufif1 T1_24 (O, 1'b1, ts);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
