// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/C_FLAG.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: C_FLAG dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module C_FLAG (I);

    parameter cds_action = "ignore";

    input  I;

endmodule

`endcelldefine
