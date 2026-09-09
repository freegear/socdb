// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/BUFE.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: TRI-STATE BUFFER

*/

`timescale  100 ps / 10 ps

`celldefine

module BUFE (O, E, I);

    parameter cds_action = "ignore";

    output O;

    input  E, I;

	bufif1 B1 (O, I, E);

    specify
	(I  *> O)  = (1, 1);
	(E  *> O)  = (1, 1);
    endspecify

endmodule

`endcelldefine
