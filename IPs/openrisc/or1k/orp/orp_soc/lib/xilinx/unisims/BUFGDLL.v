// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/BUFGDLL.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: BUFGDLL

*/

`timescale  100 ps / 10 ps

`celldefine

module BUFGDLL (O, I);

    parameter cds_action = "ignore";

    output O;

    input  I;

	buf B1 (O, I);

endmodule

`endcelldefine
