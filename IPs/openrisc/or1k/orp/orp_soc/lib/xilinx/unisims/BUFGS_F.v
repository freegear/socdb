// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/BUFGS_F.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module BUFGS_F (O, I);

    output O;

    input  I;

	buf B1 (O, I);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
