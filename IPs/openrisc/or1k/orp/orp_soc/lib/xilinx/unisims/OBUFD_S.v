// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFD_S.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: OPEN DRAIN SLOW SLEW OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFD_S (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    or O1_S (ts, GTS, I);
    bufif0 T1_S (O, 1'b0, ts);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
