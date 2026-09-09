// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FDC_1.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: D-FLIP-FLOP with async clear

*/

`timescale  100 ps / 10 ps

`celldefine

module FDC_1 (Q, C, CLR, D);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CLR, D;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR)
	    if (GSR)
		assign q_out = INIT;
	    else if (CLR)
		assign q_out = 0;
	    else
		deassign q_out;

	always @(negedge C)
	    q_out <= D;

    specify
	(posedge CLR => (Q +: 1'b0)) = (1, 1);
	if (!CLR)
	    (negedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
