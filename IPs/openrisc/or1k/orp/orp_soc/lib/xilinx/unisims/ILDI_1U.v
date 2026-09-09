// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/ILDI_1U.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: D-LATCH

*/

`timescale  100 ps / 10 ps

`celldefine

module ILDI_1U (Q, D, G);

    parameter cds_action = "ignore";
    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  D, G;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or D or G)
	    if (GSR)
		q_out <= INIT;
	    else if (!G)
		q_out <= D;

    specify
	if (!G)
	    (D +=> Q) = (1, 1);
	(negedge G => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
