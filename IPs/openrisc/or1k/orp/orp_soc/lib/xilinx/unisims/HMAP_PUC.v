// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/HMAP_PUC.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: HMAP_PUC dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module HMAP_PUC (I1, I2, I3, O);

    parameter cds_action = "ignore";

    input  I1, I2, I3, O;

endmodule

`endcelldefine
