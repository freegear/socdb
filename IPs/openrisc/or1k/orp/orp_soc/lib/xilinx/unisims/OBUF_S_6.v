// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUF_S_6.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUF_S_6 (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

    tri0 GTS = glbl.GTS;

    bufif0 B1 (O, I, GTS);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
