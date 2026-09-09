// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LDCPE_1.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: D-LATCH with async clear, async preset and gate enable

*/

`timescale  100 ps / 10 ps

`celldefine

module LDCPE_1 (Q, CLR, D, G, GE, PRE);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  CLR, D, G, GE, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or CLR or PRE or D or G or GE)
	    if (GSR)
		q_out <= INIT;
	    else if (CLR)
		q_out <= 0;
	    else if (PRE)
		q_out <= 1;
	    else if (!G && GE)
		q_out <= D;

    specify
	if (!CLR && !PRE && !G && GE)
	    (D +=> Q) = (1, 1);
	if (!CLR && !PRE && GE)
	    (negedge G => (Q +: D)) = (1, 1);
	if (!CLR && !PRE && !G)
	    (posedge GE => (Q +: D)) = (1, 1);
	if (!CLR)
	    (posedge PRE => (Q +: 1'b1)) = (1, 1);
	(posedge CLR => (Q +: 1'b0)) = (1, 1);
    endspecify

endmodule

`endcelldefine
