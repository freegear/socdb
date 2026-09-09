// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IBUF_PCI33_5.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: INPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module IBUF_PCI33_5 (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
