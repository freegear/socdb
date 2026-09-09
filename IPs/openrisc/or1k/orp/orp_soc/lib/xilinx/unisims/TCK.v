// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/TCK.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: TCK dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module TCK(I);

    parameter cds_action = "ignore";

    inout I;

endmodule

`endcelldefine
