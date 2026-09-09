// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/MUXF6_D.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps

`celldefine

module MUXF6_D (O, LO, I0, I1, S);

    parameter cds_action = "ignore";

    output O, LO;
    reg    o_out, lo_out;

    input  I0, I1, S;

    buf B1 (O, o_out);
    buf B2 (LO, lo_out);

	always @(I0 or I1 or S) begin
	    if (S)
		o_out <= I1;
	    else
		o_out <= I0;
	end

	always @(I0 or I1 or S) begin
	    if (S)
		lo_out <= I1;
	    else
		lo_out <= I0;
	end

    specify
	(I0 => O) = (1, 1);
	(I1 => O) = (1, 1);
	(S  => O) = (1, 1);
	(I0 => LO) = (1, 1);
	(I1 => LO) = (1, 1);
	(S  => LO) = (1, 1);
    endspecify

endmodule

`endcelldefine
