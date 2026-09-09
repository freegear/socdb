// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFDN_24.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: INVERTING OPEN DRAIN 24 MA OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFDN_24 (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    not N1_24 (in, I);
    or O1_24 (ts, GTS, in);
    bufif0 T1_24 (O, 1'b0, ts);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
