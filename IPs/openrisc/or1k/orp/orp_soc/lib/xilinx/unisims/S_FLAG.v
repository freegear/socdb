// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/S_FLAG.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: S_FLAG dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module S_FLAG (I);

    parameter cds_action = "ignore";

    input  I;

endmodule

`endcelldefine
