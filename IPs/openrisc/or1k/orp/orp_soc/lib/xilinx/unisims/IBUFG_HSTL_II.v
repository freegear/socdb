// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IBUFG_HSTL_II.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module IBUFG_HSTL_II (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
