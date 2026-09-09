// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/MUXCY_D.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps

`celldefine

module MUXCY_D (O, LO, CI, DI, S);

    parameter cds_action = "ignore";

    output O, LO;
    reg    o_out, lo_out;

    input  CI, DI, S;

    buf B1 (O, o_out);
    buf B2 (LO, lo_out);

	always @(CI or DI or S) begin
	    if (S)
		o_out <= CI;
	    else
		o_out <= DI;
	end

	always @(CI or DI or S) begin
	    if (S)
		lo_out <= CI;
	    else
		lo_out <= DI;
	end

    specify
	(CI => O) = (1, 1);
	(DI => O) = (1, 1);
	(S  => O) = (1, 1);
	(CI => LO) = (1, 1);
	(DI => LO) = (1, 1);
	(S  => LO) = (1, 1);
    endspecify

endmodule

`endcelldefine
