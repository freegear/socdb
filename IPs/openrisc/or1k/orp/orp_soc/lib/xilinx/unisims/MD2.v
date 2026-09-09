// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/MD2.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: MD2 dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module MD2(I);

    parameter cds_action = "ignore";

    output I;

endmodule

`endcelldefine
