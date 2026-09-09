// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/MD0.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: mdo dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module MD0(I);

    parameter cds_action = "ignore";

    output I;

endmodule

`endcelldefine
