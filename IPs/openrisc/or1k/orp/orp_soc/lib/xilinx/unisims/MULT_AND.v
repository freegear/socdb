// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/MULT_AND.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: 2-INPUT AND

*/

`timescale  100 ps / 10 ps

`celldefine

module MULT_AND (LO, I0, I1);

    parameter cds_action = "ignore";

    output LO;

    input  I0, I1;

    and A1 (LO, I0, I1);

    specify
	(I0 *> LO) = (1, 1);
	(I1 *> LO) = (1, 1);
    endspecify

endmodule

`endcelldefine
