// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FDDRRSE.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: Dual Data Rate MUX

*/

`timescale  100 ps / 10 ps

`celldefine

module FDDRRSE (Q, C0, C1, CE, D0, D1, R, S);

    parameter cds_action = "ignore";
    parameter INIT = 1'h0;

    output Q;
    reg    q_out;

    input  C0, C1, CE, D0, D1, R, S;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C0)
	    if (R)
		q_out <= 0;
	    else if (S)
		q_out <= 1;
	    else if (CE)
		q_out <= D0;

	always @(posedge C1)
	    if (R)
		q_out <= 0;
	    else if (S)
		q_out <= 1;
	    else if (CE)
		q_out <= D1;

    specify
	if (R)
	    (posedge C0 => (Q +: 1'b0)) = (1, 1);
	if (!R && S)
	    (posedge C0 => (Q +: 1'b1)) = (1, 1);
	if (!R && !S && CE)
	    (posedge C0 => (Q +: D0)) = (1, 1);
	if (R)
	    (posedge C1 => (Q +: 1'b0)) = (1, 1);
	if (!R && S)
	    (posedge C1 => (Q +: 1'b1)) = (1, 1);
	if (!R && !S && CE)
	    (posedge C1 => (Q +: D1)) = (1, 1);
    endspecify

endmodule

`endcelldefine
