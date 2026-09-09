// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUFND.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: BIDIRECTIONAL BUFFER WITH INVERTING INPUT AND OPEN DRAIN OUTPUT

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFND (O, IO, I);

    output O;

    inout  IO;

    input  I;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, I);
    bufif0 T1 (IO, 1'b0, ts);

    not B1 (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
