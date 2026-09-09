// $Header: /cvsroot/anonymous/or1k/orp/orp_soc/lib/xilinx/unisims/BSCAN_VIRTEX.v,v 1.1 2002/03/28 20:15:25 lampret Exp $

/*

FUNCTION	: BSCAN_VIRTEX dummy simulation module

*/

`timescale  100 ps / 10 ps

`celldefine

module BSCAN_VIRTEX (TDO1, TDO2, DRCK1, DRCK2, RESET, SEL1, SEL2, SHIFT, TDI, UPDATE);

    parameter cds_action = "ignore";

    input TDO1, TDO2;

    output DRCK1, DRCK2, RESET, SEL1, SEL2, SHIFT, TDI, UPDATE;

    pulldown (TDI);
    pulldown (RESET);
    pulldown (SHIFT);
    pulldown (UPDATE);
    pulldown (SEL1);
    pulldown (DRCK1);
    pulldown (SEL2);
    pulldown (DRCK2);

    specify
	(TDO1, TDO2 *> TDI) = (0,0);
	(TDO1, TDO2 *> RESET) = (0,0);
	(TDO1, TDO2 *> SHIFT) = (0,0);
	(TDO1, TDO2 *> UPDATE) = (0,0);
	(TDO1, TDO2 *> SEL1) = (0,0);
	(TDO1, TDO2 *> DRCK1) = (0,0);
	(TDO1, TDO2 *> SEL2) = (0,0);
	(TDO1, TDO2 *> DRCK2) = (0,0);
    endspecify

endmodule

`endcelldefine
