// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFS_F.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: OPEN SOURCE FAST SLEW OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFS_F (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    or O1_F (ts, GTS, I);
    bufif1 T1_F (O, 1'b1, ts);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
