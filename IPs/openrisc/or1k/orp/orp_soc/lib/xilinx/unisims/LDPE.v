// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/LDPE.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: D-LATCH with async preset and gate enable

*/

`timescale  100 ps / 10 ps

`celldefine

module LDPE (Q, D, G, GE, PRE);

    parameter cds_action = "ignore";
    parameter INIT = 1'b1;

    output Q;
    reg    q_out;

    input  D, G, GE, PRE;

    tri0 GSR = glbl.GSR;

    buf B1 (Q, q_out);

	always @(GSR or PRE or D or G or GE)
	    if (GSR)
		q_out <= INIT;
	    else if (PRE)
		q_out <= 1;
	    else if (G && GE)
		q_out <= D;

    specify
	if (!PRE && G && GE)
	    (D +=> Q) = (1, 1);
	if (!PRE && GE)
	    (posedge G => (Q +: D)) = (1, 1);
	if (!PRE && G)
	    (posedge GE => (Q +: D)) = (1, 1);
	(posedge PRE => (Q +: 1'b1)) = (1, 1);
    endspecify

endmodule

`endcelldefine
