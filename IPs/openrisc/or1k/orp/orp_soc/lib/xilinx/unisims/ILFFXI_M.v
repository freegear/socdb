// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/ILFFXI_M.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: FAST INPUT LATCH

*/

`timescale  100 ps / 10 ps

`celldefine

module ILFFXI_M (Q, C, CE, D, GF);

    parameter cds_action = "ignore";
    parameter INIT = 1'b1;

    output Q;
    reg    q_out;
    reg    o;

    input  C, CE, D, GF;

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

	always @(posedge C)
	    if (CE)
		q_out <= o;

    specify
	(posedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
