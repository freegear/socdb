// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OBUFN_S.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: INVERTING SLOW SLEW OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module OBUFN_S (O, I);

    parameter cds_action = "ignore";

    output O;
    reg    o_out;

    input  I;

    tri0 GTS = glbl.GTS;

    not B1 (O, o_out);

	always @(GTS or I)
	    if (GTS)
		o_out <= 1'bz;
	    else
		o_out <= I;

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
