// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/ICAP_VIRTEX2.v,v 1.1 2002/03/28 20:15:27 lampret Exp $
/*

FUNCTION	: Special Function Cell, ICAP_VIRTEX2

*/

`timescale  100 ps / 10 ps

`celldefine

module ICAP_VIRTEX2 (BUSY, O, CE, CLK, I, WRITE);

    parameter cds_action = "ignore";

    output BUSY;
    output [7:0] O;
    input  CE, CLK, WRITE;
    input  [7:0] I;

endmodule

`endcelldefine
