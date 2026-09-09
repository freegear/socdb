// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/ILFLXI_1.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: FAST INPUT LATCH

*/

`timescale  100 ps / 10 ps

`celldefine

module ILFLXI_1 (Q, D, G, GE, GF);

    parameter cds_action = "ignore";
    parameter INIT = 1'b1;

    output Q;
    reg    q_out;
    reg    o;

    input  D, G, GE, GF;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(D or GF)
	    if (!GF)
		o = D;

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(D or G or GE)
	    if (!G && GE)
		q_out <= o;

    specify
	(D => Q) = (1, 1);
	(negedge G => (Q +: D)) = (1, 1);
	(posedge GE => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
