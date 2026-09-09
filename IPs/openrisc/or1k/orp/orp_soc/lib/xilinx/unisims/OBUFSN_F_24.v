// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFSN_F_24.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: INVERTING OPEN SOURCE FAST SLEW 24 MA OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFSN_F_24 (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    not N1_F_24 (in, I);
    or O1_F_24 (ts, GTS, in);
    bufif1 T1_F_24 (O, 1'b1, ts);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
