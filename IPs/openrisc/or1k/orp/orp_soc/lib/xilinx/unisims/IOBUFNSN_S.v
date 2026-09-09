// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUFNSN_S.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: BIDIRECTIONAL BUFFER WITH INVERTING INPUT AND INVERTING OPEN SOURCE SLOW SLEW OUTPUT

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFNSN_S (O, IO, I);

    output O;

    inout  IO;

    input  I;

    tri0 GTS = glbl.GTS;

    not N1_S (in, I);
    or O1_S (ts, GTS, in);
    bufif1 T1_S (IO, 1'b1, ts);

    not B1_S (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
