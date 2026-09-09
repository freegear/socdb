// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/MUXCY_L.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: 2 to 1 Multiplexer for Carry Logic

*/

`timescale  100 ps / 10 ps

`celldefine

module MUXCY_L (LO, CI, DI, S);

    parameter cds_action = "ignore";

    output LO;
    reg    lo_out;

    input  CI, DI, S;

    buf B1 (LO, lo_out);

	always @(CI or DI or S) begin
	    if (S)
		lo_out <= CI;
	    else
		lo_out <= DI;
	end

    specify
	(CI => LO) = (1, 1);
	(DI => LO) = (1, 1);
	(S  => LO) = (1, 1);
    endspecify

endmodule

`endcelldefine
