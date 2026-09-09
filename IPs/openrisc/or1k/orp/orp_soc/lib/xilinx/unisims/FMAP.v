// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/FMAP.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: FMAP dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module FMAP (I1, I2, I3, I4, O);

    parameter cds_action = "ignore";

    input  I1, I2, I3, I4, O;

endmodule

`endcelldefine
