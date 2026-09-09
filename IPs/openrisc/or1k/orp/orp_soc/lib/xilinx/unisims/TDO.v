// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/TDO.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: TDO dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module TDO(O);

    parameter cds_action = "ignore";

    input O;

endmodule

`endcelldefine
