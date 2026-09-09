// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUFN_24.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: BIDIRECTIONAL BUFFER WITH INVERTING INPUT AND 24 MA OUTPUT

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFN_24 (O, IO, I, T);

    output O;

    inout  IO;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (IO, I, ts);

    not B1 (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
	(T *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
