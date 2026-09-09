// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OFDTXI_U.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: Output D-FLIP-FLOP with clock enable

*/

`timescale  100 ps / 10 ps

`celldefine

module OFDTXI_U (O, C, CE, D, T);

    parameter cds_action = "ignore";
    parameter INIT = 1'b0;

    output O;
    reg    o_in;

    input  C, CE, D, T;

    tri0 GSR = glbl.GSR;
    tri0 GTS = glbl.GTS;

	always @(GSR)
	    if (GSR)
		assign o_in = INIT;
	    else
		deassign o_in;

	always @(posedge C)
	    if (CE)
		o_in <= D;

    or (t_in, GTS, T);
    bufif0 (O, o_in, t_in);

    specify
	(posedge C => (O +: D)) = (1, 1);
	(T => O) = (1, 1, 0);
    endspecify

endmodule

`endcelldefine
