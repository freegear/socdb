// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IBUFGDS_LVDS_33.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module IBUFGDS_LVDS_33 (O, I, IB);

    parameter cds_action = "ignore";

    output O;

    reg o_out;

    input  I, IB;

    buf b_0 (O, o_out);

    always @(I or IB) begin
	if (I == 1'b1 && IB == 1'b0)
	    o_out <= I;
	else if (I == 1'b0 && IB == 1'b1)
	    o_out <= I;
    end

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine

