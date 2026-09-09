// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/BUFT.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: TRI-STATE BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module BUFT (O, I, T);

    parameter cds_action = "ignore";

    output O;

    input  I, T;

	bufif0 T1 (O, I, T);

    specify
	(I *> O) = (1, 1);
	(T *> O) = (1, 1);
    endspecify

endmodule

`endcelldefine
