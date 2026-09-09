// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/BUFGMUX_1.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: Global Clock Mux Buffer

*/

`timescale  100 ps / 10 ps

module BUFGMUX_1 (O, I0, I1, S);

    parameter cds_action = "ignore";

    output O;

    input  I0, I1, S;

    reg q0, q1;
    reg q0_enable, q1_enable;

    tri0 GSR = glbl.GSR;

    bufif1 B0 (O, I0, q0);
    bufif1 B1 (O, I1, q1);
    pullup P1 (O);

	always @(GSR or I0 or S or q0_enable)
 	    if (GSR)
		q0 <= 1;
 	    else if (I0)
		q0 <= !S && q0_enable;

	always @(GSR or I1 or S or q1_enable)
 	    if (GSR)
		q1 <= 0;
 	    else if (I1)
		q1 <= S && q1_enable;

	always @(GSR)
	    if (GSR) begin
		assign q0_enable = 1;
		assign q1_enable = 0;
	    end
	    else begin
		deassign q0_enable;
		deassign q1_enable;
	    end

	always @(posedge q1 or posedge I0)
	    if (q1)
		q0_enable <= 0;
	    else
		q0_enable <= !q1;

	always @(posedge q0 or posedge I1)
	    if (q0)
		q1_enable <= 0;
	    else
		q1_enable <= !q0;

    specify
    endspecify

endmodule
