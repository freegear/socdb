// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/CAPTURE_VIRTEX.v,v 1.1 2002/03/28 20:15:25 lampret Exp $
/*

FUNCTION	: Special Function Cell, CAPTURE_VIRTEX

*/

`timescale  100 ps / 10 ps

`celldefine

module CAPTURE_VIRTEX (CAP, CLK);

    parameter cds_action = "ignore";

    input  CAP, CLK;

endmodule

`endcelldefine
