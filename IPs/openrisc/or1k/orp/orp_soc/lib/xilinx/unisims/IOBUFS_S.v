// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUFS_S.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: BIDIRECTIONAL BUFFER WITH OPEN SOURCE SLOW SLEW OUTPUT

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFS_S (O, IO, I);

    output O;

    inout  IO;

    input  I;

    tri0 GTS = glbl.GTS;

    or O1_S (ts, GTS, I);
    bufif1 T1_S (IO, 1'b1, ts);

    buf B1_S (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
