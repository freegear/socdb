// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/BSCAN.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: BSCAN dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module BSCAN(DRCK, IDLE, SEL1, SEL2, TDO, TCK, TDI, TDO1, TDO2, TMS);

    parameter cds_action = "ignore";

    output DRCK, IDLE, SEL1, SEL2, TDO;
    input  TCK, TDI, TDO1, TDO2, TMS;

    pulldown (DRCK);
    pulldown (IDLE);
    pulldown (SEL1);
    pulldown (SEL2);

    specify
	(TDI, TMS, TCK, TDO1, TDO2 *> SEL2) = (0,0);
	(TDI, TMS, TCK, TDO1, TDO2 *> SEL1) = (0,0);
	(TDI, TMS, TCK, TDO1, TDO2 *> DRCK) = (0,0);
	(TDI, TMS, TCK, TDO1, TDO2 *> IDLE) = (0,0);
    endspecify

endmodule

`endcelldefine
