// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FDRSE.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync reset, sync set and clock enable

*/

`timescale  100 ps / 10 ps

`celldefine

module FDRSE (Q, C, CE, D, R, S);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CE, D, R, S;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C)
	    if (R)
		q_out <= 0;
	    else if (S)
		q_out <= 1;
	    else if (CE)
		q_out <= D;

    specify
	if (R)
	    (posedge C => (Q +: 1'b0)) = (1, 1);
	if (!R && S)
	    (posedge C => (Q +: 1'b1)) = (1, 1);
	if (!R && !S && CE)
	    (posedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
