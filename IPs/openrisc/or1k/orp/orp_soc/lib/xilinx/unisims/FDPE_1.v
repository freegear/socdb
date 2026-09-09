// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FDPE_1.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: D-FLIP-FLOP with async preset and clock enable

*/

`timescale  100 ps / 10 ps

`celldefine

module FDPE_1 (Q, C, CE, D, PRE);

    parameter cds_action = "ignore";
    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  C, CE, D, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or PRE)
	    if (GSR)
		assign q_out = INIT;
	    else if (PRE)
		assign q_out = 1;
	    else
		deassign q_out;

	always @(negedge C)
	    if (CE)
		q_out <= D;

    specify
	(posedge PRE => (Q +: 1'b1)) = (1, 1);
	if (!PRE && CE)
	    (negedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
