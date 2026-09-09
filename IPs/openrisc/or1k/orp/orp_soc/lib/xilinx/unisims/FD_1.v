// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FD_1.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: D-FLIP-FLOP

*/

`timescale  100 ps / 10 ps

`celldefine

module FD_1 (Q, C, D);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, D;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(negedge C)
	    q_out <= D;

    specify
	(negedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
