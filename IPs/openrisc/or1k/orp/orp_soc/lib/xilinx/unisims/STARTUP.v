// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/STARTUP.v,v 1.1 2002/03/28 20:15:31 lampret Exp $
/*

FUNCTION	: Special Function Cell, STARTUP

*/

`timescale  100 ps / 10 ps

`celldefine

module STARTUP (DONEIN, Q1Q4, Q2, Q3, CLK, GSR, GTS);

    parameter cds_action = "ignore";

    output DONEIN, Q1Q4, Q2, Q3;

    input  CLK, GSR, GTS;

    tri0   GSR, GTS;

	assign glbl.GSR = GSR;
	assign glbl.GTS = GTS;
	pullup (Q2);
	pullup (Q3);
	pullup (Q1Q4);
	pullup (DONEIN);

    specify
	(GSR,GTS,CLK *> Q2) = (0,0);
	(GSR,GTS,CLK *> Q3) = (0,0);
	(GSR,GTS,CLK *> Q1Q4) = (0,0);
	(GSR,GTS,CLK *> DONEIN) = (0,0);
    endspecify

endmodule

`endcelldefine
