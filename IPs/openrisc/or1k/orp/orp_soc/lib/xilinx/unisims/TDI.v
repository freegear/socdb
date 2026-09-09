// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/TDI.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: TDI dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module TDI(I);

    parameter cds_action = "ignore";

    inout I;

endmodule

`endcelldefine
