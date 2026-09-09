// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/CY4_26.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: Carry modes functions

*/

`timescale  100 ps / 10 ps

`celldefine

module CY4_26 (C0, C1, C2, C3, C4, C5, C6, C7);

    parameter cds_action = "ignore";

    output C0, C1, C2, C3, C4, C5, C6, C7;

	supply0 C7;
	supply1 C6;
	supply1 C5;
	supply1 C4;
	supply0 C3;
	supply0 C2;
	supply0 C1;
	supply0 C0;

endmodule

`endcelldefine
