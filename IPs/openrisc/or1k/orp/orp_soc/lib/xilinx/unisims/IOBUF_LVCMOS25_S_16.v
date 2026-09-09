// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/IOBUF_LVCMOS25_S_16.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: INPUT TRI-STATE OUTPUT BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module IOBUF_LVCMOS25_S_16 (O, IO, I, T);

    output O;

    inout  IO;

    input  I, T;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (IO, I, ts);

    buf B1 (O, IO);

    specify
	(IO *> O) = (1, 1);
	(I *> IO) = (1, 1);
	(T *> IO) = (1, 1);
    endspecify

endmodule

`endcelldefine
