// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IBUFG_SSTL2_I.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module IBUFG_SSTL2_I (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
