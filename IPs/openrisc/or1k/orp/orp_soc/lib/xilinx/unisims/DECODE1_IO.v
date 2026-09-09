// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/DECODE1_IO.v,v 1.1 2002/03/28 20:15:26 lampret Exp $

/*

FUNCTION	: 1-INPUT Decoder

*/

`timescale  100 ps / 10 ps

`celldefine

module DECODE1_IO (O, I);

    output O;

    input  I;

    wand   O;

	bufif0 DECODER (O, I, I);

    specify
	(I *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
