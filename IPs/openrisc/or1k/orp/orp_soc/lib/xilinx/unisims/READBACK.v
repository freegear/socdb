// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/READBACK.v,v 1.1 2002/03/28 20:15:31 lampret Exp $

/*

FUNCTION	: READBACK dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module READBACK (DATA, RIP, CLK, TRIG);

    parameter cds_action = "ignore";

    output DATA, RIP;

    input  CLK, TRIG;

endmodule

`endcelldefine
