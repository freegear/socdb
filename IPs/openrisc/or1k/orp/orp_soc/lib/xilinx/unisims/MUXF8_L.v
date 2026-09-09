// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/MUXF8_L.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps

`celldefine

module MUXF8_L (LO, I0, I1, S);

    parameter cds_action = "ignore";

    output LO;
    reg    lo_out;

    input  I0, I1, S;

    buf B1 (LO, lo_out);

	always @(I0 or I1 or S) begin
	    if (S)
		lo_out <= I1;
	    else
		lo_out <= I0;
	end

    specify
	(I0 => LO) = (1, 1);
	(I1 => LO) = (1, 1);
	(S  => LO) = (1, 1);
    endspecify

endmodule

`endcelldefine
