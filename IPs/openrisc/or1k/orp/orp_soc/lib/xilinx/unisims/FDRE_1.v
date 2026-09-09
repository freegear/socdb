// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FDRE_1.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: D-FLIP-FLOP with sync reset and clock enable

*/

`timescale  100 ps / 10 ps

`celldefine

module FDRE_1 (Q, C, CE, D, R);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CE, D, R;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(negedge C)
	    if (R)
		q_out <= 0;
	    else if (CE)
		q_out <= D;

    specify
	if (R)
	    (negedge C => (Q +: 1'b0)) = (1, 1);
	if (!R && CE)
	    (negedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
