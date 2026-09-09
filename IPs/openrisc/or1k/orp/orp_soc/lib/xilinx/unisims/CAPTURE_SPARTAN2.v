// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/CAPTURE_SPARTAN2.v,v 1.1 2002/03/28 20:15:25 lampret Exp $
/*

FUNCTION	: Special Function Cell, CAPTURE_SPARTAN2

*/

`timescale  100 ps / 10 ps

`celldefine

module CAPTURE_SPARTAN2 (CAP, CLK);

    parameter cds_action = "ignore";

    input  CAP, CLK;

endmodule

`endcelldefine
