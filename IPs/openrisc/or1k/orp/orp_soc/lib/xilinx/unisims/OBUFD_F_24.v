// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFD_F_24.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: OPEN DRAIN FAST SLEW 24 MA OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFD_F_24 (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    or O1_F_24 (ts, GTS, I);
    bufif0 T1_F_24 (O, 1'b0, ts);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
