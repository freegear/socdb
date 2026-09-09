// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/PULLUP.v,v 1.1 2002/03/28 20:15:30 lampret Exp $

/*

FUNCTION	: pullup cell

*/

`timescale  100 ps / 10 ps

`celldefine

module PULLUP (O);

    parameter cds_action = "ignore";

    output O;
	pullup (A);
	buf (weak0,weak1) #(1,1) (O,A);

endmodule

`endcelldefine
