// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUFSN_F_24.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: BIDIRECTIONAL BUFFER WITH INVERTING OPEN SOURCE FAST SLEW 24 MA OUTPUT

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFSN_F_24 (O, IO, I);

    output O;

    inout  IO;

    input  I;

    tri0 GTS = glbl.GTS;

    not N1_F_S_24 (in, I);
    or O1_F_S_24 (ts, GTS, in);
    bufif1 T1_F_S_24 (IO, 1'b1, ts);

    buf B1_F_S_24 (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
