// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LDE_1.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: D-LATCH with gate enable

*/

`timescale  100 ps / 10 ps

`celldefine

module LDE_1 (Q, D, G, GE);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  D, G, GE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or D or G or GE)
	    if (GSR)
		q_out <= INIT;
	    else if (!G && GE)
		q_out <= D;

    specify
	if (!G && GE)
	    (D +=> Q) = (1, 1);
	if (GE)
	    (negedge G => (Q +: D)) = (1, 1);
	if (!G)
	    (posedge GE => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
