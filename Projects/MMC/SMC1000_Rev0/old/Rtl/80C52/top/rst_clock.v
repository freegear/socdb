/*********************************************************************
*
*   This confidential and proprietary software may be used only as
*   authorised by a licensing agreement from CORERIVER Semiconductor
*   Co., Ltd.
*
*   (c) Copyright 2006 CORERIVER Semiconductor Co., Ltd.
*     All Rights Reserved
*
*   The entire notice above must be reproduced on all authorised
*   copies and copies may only be made to the extent permitted
*   by a licensing agreement from CORERIVER Semiconductor Co., Ltd.
*
* -------------------------------------------------------------------
*
*   FILE          : rst_clock.v
*   AUTHOR        : CORERIVER
*   DESCRIPTION   : 
*   VERSION       : $Revision:$ ($Date:$)
*   COMMENT       :
* 
*********************************************************************/
module rst_clock(
WDT_RUN,
XTAL1,
RESET,
clk_cpu,
clk_peri,
clk_wdt,
ext_reset,
PDWN,
IDLE
);
//---------------------------------------------
input WDT_RUN;
input XTAL1;
input RESET;
output clk_cpu;
output clk_peri;
output clk_wdt;
output ext_reset;
input PDWN;
input IDLE;

reg	E_CPU, E_PERI, E_WDT;

always	@(XTAL1 or PDWN or IDLE or WDT_RUN) begin
	if (XTAL1 == 1'b0) begin
	    E_CPU  <= ~(PDWN | IDLE);
	    E_PERI <= ~PDWN;
	    E_WDT  <= ~PDWN | WDT_RUN;
	end
end

assign clk_cpu  = XTAL1 & E_CPU;
assign clk_peri = XTAL1 & E_PERI;
assign clk_wdt  = XTAL1 & E_WDT;

assign ext_reset = RESET;

endmodule

