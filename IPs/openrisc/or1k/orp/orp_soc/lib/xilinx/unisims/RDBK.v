// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/RDBK.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: RDBK dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module RDBK(DATA, RIP, TRIG);

    parameter cds_action = "ignore";

    output DATA, RIP;

    input  TRIG;

endmodule

`endcelldefine
