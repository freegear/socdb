// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FDS_1.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync set

*/

`timescale  100 ps / 10 ps

`celldefine

module FDS_1 (Q, C, D, S);

    parameter cds_action = "ignore";
    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  C, D, S;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(negedge C)
	    if (S)
		q_out <= 1;
	    else
		q_out <= D;

    specify
	if (S)
	    (negedge C => (Q +: 1'b1)) = (1, 1);
	if (!S)
	    (negedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
