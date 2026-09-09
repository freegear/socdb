// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FDDRCPE.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: Dual Data Rate MUX

*/

`timescale  100 ps / 10 ps

`celldefine

module FDDRCPE (Q, C0, C1, CE, CLR, D0, D1, PRE);

    parameter cds_action = "ignore";
    parameter INIT = 1'h0;

    output Q;
    reg    q_out;

    input  C0, C1, CE, CLR, D0, D1, PRE;

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

	always @(posedge C0)
	    if (CE)
		q_out <= D0;

	always @(posedge C1)
	    if (CE)
		q_out <= D1;

    specify
	(posedge CLR => (Q +: 1'b0)) = (1, 1);
	if (!CLR)
	    (posedge PRE => (Q +: 1'b1)) = (1, 1);
	if (!CLR && !PRE && CE)
	    (posedge C0 => (Q +: D0)) = (1, 1);
	if (!CLR && !PRE && CE)
	    (posedge C1 => (Q +: D1)) = (1, 1);
    endspecify

endmodule

`endcelldefine
