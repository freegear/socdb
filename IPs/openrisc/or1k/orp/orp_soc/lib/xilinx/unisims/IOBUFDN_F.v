// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUFDN_F.v,v 1.1 2002/03/28 20:15:27 lampret Exp $

/*

FUNCTION	: BIDIRECTIONAL BUFFER WITH INVERTING OPEN DRAIN FAST SLEW OUTPUT

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUFDN_F (O, IO, I);

    output O;

    inout  IO;

    input  I;

    tri0 GTS = glbl.GTS;

    not N1_F (in, I);
    or O1_F (ts, GTS, in);
    bufif0 T1_F (IO, 1'b0, ts);

    buf B1_F (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
