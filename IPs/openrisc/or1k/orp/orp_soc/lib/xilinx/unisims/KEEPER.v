// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/KEEPER.v,v 1.1 2002/03/28 20:15:28 lampret Exp $

/*

FUNCTION	: KEEPER

*/


`timescale  100 ps / 10 ps
`celldefine

module KEEPER (O);

    parameter cds_action = "ignore";

    inout O;
    reg   in;

    always @(O)
	if (O)
	    in <= 1;
	else
	    in <= 0;

    buf (pull1, pull0) B1 (O, in);

endmodule
`endcelldefine
