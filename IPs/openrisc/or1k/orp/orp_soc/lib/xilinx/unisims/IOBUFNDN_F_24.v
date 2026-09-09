// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUFNDN_F_24.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: BIDIRECTIONAL BUFFER WITH INVERTING INPUT AND INVERTING OPEN DRAIN FAST SLEW 24 MA OUTPUT

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFNDN_F_24 (O, IO, I);

    output O;

    inout  IO;

    input  I;

    tri0 GTS = glbl.GTS;

    not N1_F_24 (in, I);
    or O1_F_24 (ts, GTS, in);
    bufif0 T1_F_24 (IO, 1'b0, ts);

    not B1_F_24 (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
