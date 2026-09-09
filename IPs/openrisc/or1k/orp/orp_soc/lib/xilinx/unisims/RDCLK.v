// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/RDCLK.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: RDCLK dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module RDCLK(I);

    parameter cds_action = "ignore";

    input I;

endmodule

`endcelldefine
