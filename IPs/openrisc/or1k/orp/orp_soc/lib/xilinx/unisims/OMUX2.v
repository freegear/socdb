// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/OMUX2.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: OUTPUT MULTIPLEXER2

*/

`timescale  100 ps / 10 ps

`celldefine

module OMUX2 (O, D0, D1, S0);

    parameter cds_action = "ignore";

    output O;
    reg    o_out;

    input  D0, D1, S0;

    tri0 GTS = glbl.GTS;

    bufif0 B1 (O, o_out, GTS);

	always @(D0 or D1 or S0) begin
	    if (S0)
		o_out <= D1;
	    else
		o_out <= D0;
	end

    specify
	(D0 *> O) = (1, 1);
	(D1 *> O) = (1, 1);
	(S0 *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
