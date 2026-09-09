// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OFDXI_U.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: Output D-FLIP-FLOP with clock enable

*/

`timescale  100 ps / 10 ps

`celldefine

module OFDXI_U (Q, C, CE, D);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output Q;
    reg    q_out;

    input  C, CE, D;

    tri0 GSR = glbl.GSR;
    tri0 GTS = glbl.GTS;

    bufif0 B1 (Q, q_out, GTS);

	always @(GSR)
	    if (GSR)
		assign q_out = INIT;
	    else
		deassign q_out;

	always @(posedge C)
	    if (CE)
		q_out <= D;

    specify
	(posedge C => (Q +: D)) = (1, 1);
    endspecify

endmodule

`endcelldefine
