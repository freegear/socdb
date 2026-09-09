// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LDC_1.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: D-LATCH with async clear

*/

`timescale  100 ps / 10 ps

`celldefine

module LDC_1 (Q, CLR, D, G);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  CLR, D, G;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR or D or G)
	    if (GSR)
		q_out <= INIT;
	    else if (CLR)
		q_out <= 0;
	    else if (!G)
		q_out <= D;

    specify
	if (!CLR && !G)
	    (D +=> Q) = (1, 1);
	if (!CLR)
	    (negedge G => (Q +: D)) = (1, 1);
	(posedge CLR => (Q +: 1'b0)) = (1, 1);
    endspecify

endmodule

`endcelldefine
