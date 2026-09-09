// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LDP_1.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: D-LATCH with async preset

*/

`timescale  100 ps / 10 ps

`celldefine

module LDP_1 (Q, D, G, PRE);

    parameter cds_action = "ignore";
    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  D, G, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or PRE or D or G)
	    if (GSR)
		q_out <= INIT;
	    else if (PRE)
		q_out <= 1;
	    else if (!G)
		q_out <= D;

    specify
	if (!PRE && !G)
	    (D +=> Q) = (1, 1);
	if (!PRE)
	    (negedge G => (Q +: D)) = (1, 1);
	(posedge PRE => (Q +: 1'b1)) = (1, 1);
    endspecify

endmodule

`endcelldefine
