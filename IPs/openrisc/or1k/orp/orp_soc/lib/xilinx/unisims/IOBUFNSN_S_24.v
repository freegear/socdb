// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUFNSN_S_24.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: BIDIRECTIONAL BUFFER WITH INVERTING INPUT AND INVERTING OPEN SOURCE SLOW SLEW 24 MA OUTPUT

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFNSN_S_24 (O, IO, I);

    output O;

    inout  IO;

    input  I;

    tri0 GTS = glbl.GTS;

    not N1_S_24 (in, I);
    or O1_S_24 (ts, GTS, in);
    bufif1 T1_S_24 (IO, 1'b1, ts);

    not B1_S_24 (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
