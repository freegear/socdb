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
*   FILE          : TOP
*   AUTHOR        : CORERIVER
*   DESCRIPTION   : 
*   VERSION       : $Revision:$ ($Date:$)
*   COMMENT       :
* 
*********************************************************************/
//-----------------------------------------------------
// midas10.v
//-----------------------------------------------------
`timescale 1ns/10ps

module midas10(
XTAL1,
RESET,
ALE,
PSEN,
);
//-----------------------------------------------------------
input XTAL1;
input RESET;
output XTAL2;
output ALE;
output PSEN;
//--------------------------------------------------------

initial begin
user_init_pc_en = 0;
user_init_pc = 16'h1111;
end

//reset & clock generation block
rst_clock rst_clock(
.WDT_RUN(WDT_RUN),
.XTAL1(XTAL1),
.RESET(RESET),
.clk_cpu(clk_cpu),
.clk_peri(clk_peri),
.clk_wdt(clk_wdt),
.ext_reset(ext_reset),
.PDWN(pdwn),
.IDLE(idle)
);

reset_cnt reset_cnt(
.POR_reset(RESET),
.ext_reset(RESET),
.wdt_reset(wdt_reset),
.final_all_reset(final_all_reset),
.final_POR_ext_reset(final_POR_ext_reset)
);

core_top core_top(
.user_init_pc(user_init_pc),
.user_init_pc_en(user_init_pc_en),
.RESET_pin(RESET),
.final_all_reset(final_all_reset),
.final_POR_ext_reset(final_POR_ext_reset),
.wdt_reset(wdt_reset),
.xrom_addr(xrom_addr),
.xrom_ce_b(xrom_ce_b),
.xrom_oe_b(xrom_oe_b),
.xrom_dout(xrom_dout),
.xram_addr(xram_addr),
.xram_din(xram_din),
.xram_ce_b(xram_ce_b),
.xram_oe_b(xram_oe_b),
.xram_we_b(xram_we_b),
.xram_dout(xram_dout),
.iram_addr(iram_addr),
.iram_din(iram_din),
.iram_ce_b(iram_ce_b),
.iram_oe_b(iram_oe_b),
.iram_we_b(iram_we_b),
.iram_dout(iram_dout),
.clk_cpu(clk_cpu),
.clk_peri(clk_peri),
.clk_wdt(clk_wdt),
.WDT_RUN(WDT_RUN),
.pdwn(pdwn),
.idle(idle),
.EA(1'b0),
.ALE(ALE),
.PSEN(PSEN),
.P0_DIN(P0_DIN),
.P0_DOUT(P0_DOUT),
.P1_DIN(P1_DIN),
.P1_DOUT(P1_DOUT),
.P2_DIN(P2_DIN),
.P2_DOUT(P2_DOUT),
.P3_DIN(P3_DIN),
.P3_DOUT(P3_DOUT),
.INT0_B(INT0_B),
.INT1_B(INT1_B),
.INT2(INT2),
.INT3_B(INT3_B),
.INT4(INT4),
.INT5_B(INT5_B),
.T0_PIN(T0_PIN),
.T1_PIN(T1_PIN),
.T2_PIN(T2_PIN),
.T2EX_PIN(T2EX_PIN),
.T2_OUT(T2_OUT),
.RX_PIN(RX_PIN),
.TX_PIN(TX_PIN)
);

//XROM 64K
XROM64K xrom64k(
.CK(clk_cpu),
.A(xrom_addr),
.CSN(xrom_ce_b),
.OEN(xrom_oe_b),
.DOUT(xrom_dout)
);

//IRAM 256
wire iram_clk = clk_cpu;
IRAM256 iram256 (
.CK(iram_clk),
.CSN(iram_ce_b),
.WEN(iram_we_b),
.OEN(iram_oe_b),
.A(iram_addr),
.DI(iram_din),
.DOUT(iram_dout)
);

//XRAM 64K
XRAM64K xram64k (
.CK(clk_cpu),
.CSN(xram_ce_b),
.WEN(xram_we_b),
.OEN(xram_oe_b),
.A(xram_addr[13:0]),
.DI(xram_din),
.DOUT(xram_dout)
);

endmodule
//-------------------------------------------------------------
