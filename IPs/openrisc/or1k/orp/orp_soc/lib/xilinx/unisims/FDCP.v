// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FDCP.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: D-FLIP-FLOP with async clear, async preset

*/

`timescale  100 ps / 10 ps

`celldefine

module FDCP (Q, C, CLR, D, PRE);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CLR, D, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR or PRE)
	    if (GSR)
		assign q_out = INIT;
	    else if (CLR)
		assign q_out = 0;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(posedge C)
	    q_out <= D;

    specify
	(posedge CLR => (Q +: 1'b0)) = (1, 1);
	if (!CLR)
	(posedge PRE => (Q +: 1'b1)) = (1, 1);
	if (!CLR && !PRE)
	    (posedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
