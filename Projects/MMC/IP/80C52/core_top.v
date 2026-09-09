/*********************************************************************
*
*   This confidential and proprietary software may be used only as
*   authorised by a licensing agreement from CORERIVER Semiconductor
*   Co., Ltd.
*
*   (c) Copyright 2007 CORERIVER Semiconductor Co., Ltd.
*     All Rights Reserved
*
*   The entire notice above must be reproduced on all authorised
*   copies and copies may only be made to the extent permitted
*   by a licensing agreement from CORERIVER Semiconductor Co., Ltd.
*
* -------------------------------------------------------------------
*
*   FILE          : core_top.g.smt
*   AUTHOR        : CORERIVER
*   DESCRIPTION   : Gate level netlist of IP (MiDAS1.0)
*   VERSION       : 2007/06/21
*   COMMENT       : Released for SangHwa Micro Technology Inc.
* 
*********************************************************************/


module core_top ( user_init_pc, user_init_pc_en, RESET_pin, final_all_reset, 
        final_POR_ext_reset, wdt_reset, xrom_addr, xrom_ce_b, xrom_oe_b, 
        xrom_dout, xram_addr, xram_din, xram_ce_b, xram_oe_b, xram_we_b, 
        xram_dout, iram_addr, iram_din, iram_ce_b, iram_oe_b, iram_we_b, 
        iram_dout, clk_cpu, clk_peri, clk_wdt, WDT_RUN, pdwn, idle, ALE, PSEN, 
        P0_DIN, P0_DOUT, P1_DIN, P1_DOUT, P2_DIN, P2_DOUT, P3_DIN, P3_DOUT, 
        INT0_B, INT1_B, INT2, INT3_B, INT4, INT5_B, T0_PIN, T1_PIN, T2_PIN, 
        T2EX_PIN, T2_OUT, RX_PIN, RX_MODE0_PIN, TX_PIN, PWM1_OUT, PWM2_OUT, 
        EXT_SFR_DIN, EXT_SFR_DOUT, EXT_SFR_ADDR, EXT_SFR_WR );
  input [15:0] user_init_pc;
  output [15:0] xrom_addr;
  input [7:0] xrom_dout;
  output [15:0] xram_addr;
  output [7:0] xram_din;
  input [7:0] xram_dout;
  output [7:0] iram_addr;
  output [7:0] iram_din;
  input [7:0] iram_dout;
  input [7:0] P0_DIN;
  output [7:0] P0_DOUT;
  input [7:0] P1_DIN;
  output [7:0] P1_DOUT;
  input [7:0] P2_DIN;
  output [7:0] P2_DOUT;
  input [7:0] P3_DIN;
  output [7:0] P3_DOUT;
  input [7:0] EXT_SFR_DIN;
  output [7:0] EXT_SFR_DOUT;
  output [7:0] EXT_SFR_ADDR;
  input user_init_pc_en, RESET_pin, final_all_reset, final_POR_ext_reset,
         clk_cpu, clk_peri, clk_wdt, INT0_B, INT1_B, INT2, INT3_B, INT4,
         INT5_B, T0_PIN, T1_PIN, T2_PIN, T2EX_PIN, RX_PIN;
  output wdt_reset, xrom_ce_b, xrom_oe_b, xram_ce_b, xram_oe_b, xram_we_b,
         iram_ce_b, iram_oe_b, iram_we_b, WDT_RUN, pdwn, idle, ALE, PSEN,
         T2_OUT, RX_MODE0_PIN, TX_PIN, PWM1_OUT, PWM2_OUT, EXT_SFR_WR;
  wire   n19, n20, n21, n22, n23, n24, n25, n26, PCON_7_, PCON_6_, PCON_5_,
         PCON_4_, PCON_3_, PCON_2_, ALE_B_I, PSEN_B, ALE_B, EWT, EWDI,
         SFR_addr_8_, SFR_wr, IR_EN, pre_idle, pre_pdwn_idle, DIR_WR, RETI_end,
         RETI_NFC, ALEOFF, PERI_SFR_sel, read_modify, inter_LCALL, P0_sel,
         P1_sel, P2_sel, P3_sel, Z_update, interrupt_ack, STOPwake_INT0,
         STOPwake_INT1, STOPwake_WDT, TF0, TF1, t2_intr, ua_intr, wdt_intr,
         TCON_sel, EXIF_sel, IE_sel, IP_sel, EIE_sel, EIP_sel, IPH_sel,
         clear_TF0, clear_TF1, sample_INT0, sample_INT1, pre_pdwn, T0M, T0M_S1,
         T0M_S2, T0M_S5, T0M_S6, T1M, T1M_S1, T1M_S2, T1M_S4, T1M_S5, T1M_S6,
         T2M, T2M_S1, T2M_S2, TH0_sel, TL0_sel, TH1_sel, TL1_sel, TMOD_sel,
         T1_overflow, T2CON_sel, T2MOD_sel, TH2_sel, TL2_sel, RCAP2L_sel,
         RCAP2H_sel, T2_uart_clk, RCLK, TCLK, SCON_sel, SBUF_sel, SADDR_sel,
         SADEN_sel, SMOD1_update, SMOD1, SMOD0, PCON_sel, PWM1CON_sel,
         PWM2CON_sel, PWM1D_sel, PWM2D_sel, CKCON_sel, WDCON_sel, PMR_sel, n3,
         n4, n7, n8, n10, n17, n18;
  wire   [7:0] SFR_DATA;
  wire   [7:0] IDATA;
  wire   [7:0] inter_vector;
  wire   [7:0] P0_OUT;
  wire   [7:0] P1_OUT;
  wire   [7:0] P2_OUT;
  wire   [7:0] P3_OUT;
  wire   [2:0] peri_state;
  wire   [3:0] TCON30;
  wire   [7:0] INT_SFR_OUT;
  wire   [7:0] T01_SFR_OUT;
  wire   [7:0] T2_SFR_OUT;
  wire   [7:0] UART_SFR_OUT;
  wire   [7:0] PWM_SFR_OUT;
  wire   [7:0] WDT_SFR_OUT;
  wire   [7:0] PMR_OUT;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1;

  cpu cpu ( .IR_EN(IR_EN), .ACC(xram_din), .user_init_pc(user_init_pc), 
        .user_init_pc_en(user_init_pc_en), .xram_dout(xram_dout), .pre_idle(
        pre_idle), .pre_pdwn_idle(pre_pdwn_idle), .DIR_WR(DIR_WR), .PDWN(pdwn), 
        .IDLE(idle), .POR(final_POR_ext_reset), .IRAM_DIN(iram_din), 
        .RETI_NFC(RETI_NFC), .INT_EN_1_EN(RETI_end), .RESET(n7), .CLK(clk_cpu), 
        .RAM_CS_B(iram_ce_b), .RAM_WE_B(iram_we_b), .RAMADDR(iram_addr), 
        .RAMOUT(iram_dout), .ALEOFF(ALEOFF), .XMEM_L(xrom_addr[7:0]), .XMEM_H(
        xrom_addr[15:8]), .XA(xram_addr), .P0_IN(xrom_dout), .ALE_B_I(ALE_B_I), 
        .ALE_B_X(ALE_B), .PSEN_B_X(PSEN_B), .PERI_SFR_DATA(SFR_DATA), 
        .PERI_SFR_sel(PERI_SFR_sel), .IDATA(IDATA), .MAR({SFR_addr_8_, 
        EXT_SFR_ADDR}), .SFR_wr(SFR_wr), .XRAM_CE_B(xram_ce_b), .XRAM_WR_B(
        xram_we_b), .XRAM_RD_B(xram_oe_b), .read_modify(read_modify), 
        .inter_LCALL(inter_LCALL), .inter_vector({1'b0, inter_vector[6:3], 
        1'b0, inter_vector[1:0]}) );
  port0 port0 ( .sw_rst(n7), .clk(clk_peri), .P0_DOUT(P0_DOUT), .SFR_bus(
        EXT_SFR_DOUT), .P0_sel(P0_sel), .SFR_wr(n18), .pin_P0(P0_DIN), 
        .read_modify(read_modify), .P0_OUT(P0_OUT) );
  port1 port1 ( .sw_rst(n7), .clk(clk_peri), .P1_DOUT(P1_DOUT), .SFR_bus(
        EXT_SFR_DOUT), .P1_sel(P1_sel), .SFR_wr(n18), .read_modify(read_modify), .P1_OUT(P1_OUT), .pin_P1(P1_DIN) );
  port2 port2 ( .sw_rst(n7), .clk(clk_peri), .P2_DOUT(P2_DOUT), .SFR_bus({
        EXT_SFR_DOUT[7:1], n10}), .SFR_wr(n18), .P2_sel(P2_sel), .pin_P2(
        P2_DIN), .read_modify(read_modify), .P2_OUT(P2_OUT) );
  port3 port3 ( .sw_rst(n7), .clk(clk_peri), .P3_DOUT(P3_DOUT), .SFR_bus({
        EXT_SFR_DOUT[7:1], n10}), .P3_sel(P3_sel), .SFR_wr(n18), .pin_P3(
        P3_DIN), .read_modify(read_modify), .P3_OUT(P3_OUT) );
  interrupt interrupt ( .Z_update(Z_update), .EWDI(EWDI), .STOPwake_WDT(
        STOPwake_WDT), .DIR_WR(DIR_WR), .LVD_intr(1'b0), .POR(
        final_POR_ext_reset), .sw_rst(n7), .clk(clk_peri), .pin_INT0(INT0_B), 
        .pin_INT1(INT1_B), .pin_INT2(INT2), .pin_INT3(INT3_B), .pin_INT4(INT4), 
        .pin_INT5(INT5_B), .TF0(TF0), .TF1(TF1), .adc_intr(1'b0), .t2_intr(
        t2_intr), .ua_intr(ua_intr), .wdt_intr(wdt_intr), .pwm1_intr(1'b0), 
        .pwm2_intr(1'b0), .pr_st(peri_state), .RETI_end(RETI_end), .RETI_NFC(
        RETI_NFC), .SFR_wr(n18), .SFR_bus(EXT_SFR_DOUT), .TCON_sel(TCON_sel), 
        .EXIF_sel(EXIF_sel), .IE_sel(IE_sel), .IP_sel(IP_sel), .EIE_sel(
        EIE_sel), .EIP_sel(EIP_sel), .IPH_sel(IPH_sel), .clear_TF0(clear_TF0), 
        .clear_TF1(clear_TF1), .TCON30(TCON30), .inter_vector({
        SYNOPSYS_UNCONNECTED__0, inter_vector[6:3], SYNOPSYS_UNCONNECTED__1, 
        inter_vector[1:0]}), .inter_LCALL(inter_LCALL), .sample_INT0(
        sample_INT0), .sample_INT1(sample_INT1), .interrupt_ack(interrupt_ack), 
        .STOPwake_INT0(STOPwake_INT0), .STOPwake_INT1(STOPwake_INT1), 
        .INT_SFR_OUT(INT_SFR_OUT) );
  peri_cycle peri_cycle ( .end_of_inst(IR_EN), .pcon_idle(idle), .pre_pdwn(
        pre_pdwn), .POR(final_POR_ext_reset), .reset(n7), .clk(clk_peri), 
        .Z_update(Z_update), .peri_state(peri_state) );
  t0_cycle t0_cycle ( .reset(n7), .clk(clk_peri), .T0M(T0M), .T0M_S1(T0M_S1), 
        .T0M_S2(T0M_S2), .T0M_S5(T0M_S5), .T0M_S6(T0M_S6) );
  t1_cycle t1_cycle ( .reset(final_all_reset), .clk(clk_peri), .T1M(T1M), 
        .T1M_S1(T1M_S1), .T1M_S2(T1M_S2), .T1M_S4(T1M_S4), .T1M_S5(T1M_S5), 
        .T1M_S6(T1M_S6) );
  t2_cycle t2_cycle ( .reset(final_all_reset), .clk(clk_peri), .T2M(T2M), 
        .T2M_S1(T2M_S1), .T2M_S2(T2M_S2) );
  timer01 timer01 ( .Z_update(Z_update), .Z0_S1(T0M_S1), .Z0_S2(T0M_S2), 
        .Z0_S5(T0M_S5), .Z0_S6(T0M_S6), .Z1_S1(T1M_S1), .Z1_S2(T1M_S2), 
        .Z1_S4(T1M_S4), .Z1_S5(T1M_S5), .Z1_S6(T1M_S6), .sw_rst(
        final_all_reset), .clk_b(clk_peri), .SFR_wr(n17), .SFR_bus(
        EXT_SFR_DOUT), .TH0_sel(TH0_sel), .TL0_sel(TL0_sel), .TH1_sel(TH1_sel), 
        .TL1_sel(TL1_sel), .TCON_sel(TCON_sel), .TMOD_sel(TMOD_sel), 
        .clear_TF0(clear_TF0), .clear_TF1(clear_TF1), .pin_T0(T0_PIN), 
        .pin_T1(T1_PIN), .sample_INT0(sample_INT0), .sample_INT1(sample_INT1), 
        .TCON30(TCON30), .TF0(TF0), .TF1(TF1), .T1_overflow(T1_overflow), 
        .T01_SFR_OUT(T01_SFR_OUT) );
  timer2 timer2 ( .POR(final_POR_ext_reset), .Z_update(Z_update), .pr_st_0(
        peri_state[0]), .Z2_S1(T2M_S1), .Z2_S2(T2M_S2), .sw_rst(
        final_all_reset), .clk_b(clk_peri), .SFR_wr(n18), .SFR_bus({
        EXT_SFR_DOUT[7:1], n10}), .T2CON_sel(T2CON_sel), .T2MOD_sel(T2MOD_sel), 
        .TH2_sel(TH2_sel), .TL2_sel(TL2_sel), .RCAP2L_sel(RCAP2L_sel), 
        .RCAP2H_sel(RCAP2H_sel), .pin_T2(T2_PIN), .pin_T2EX(T2EX_PIN), 
        .T2_CLKOUT(T2_OUT), .t2_intr(t2_intr), .T2_uart_clk(T2_uart_clk), 
        .RCLK(RCLK), .TCLK(TCLK), .T2_SFR_OUT(T2_SFR_OUT) );
  uart uart ( .POR(final_POR_ext_reset), .Z_update(Z_update), .sw_rst(n7), 
        .clk_b(clk_peri), .pr_st(peri_state), .SFR_wr(n18), .SFR_bus({
        EXT_SFR_DOUT[7:1], n10}), .SCON_sel(SCON_sel), .SBUF_sel(SBUF_sel), 
        .SADDR_sel(SADDR_sel), .SADEN_sel(SADEN_sel), .pin_RXD(RX_PIN), 
        .SMOD1_update(SMOD1_update), .SMOD1(SMOD1), .SMOD0(SMOD0), 
        .T1_overflow(T1_overflow), .T2_uart_clk(T2_uart_clk), .TCLK(TCLK), 
        .RCLK(RCLK), .ua_intr(ua_intr), .Mode0_data_RXD(RX_MODE0_PIN), 
        .Uart_TXD(TX_PIN), .UART_SFR_OUT(UART_SFR_OUT) );
  power_control power_control ( .STOPwake_WDT(STOPwake_WDT), .POR(
        final_POR_ext_reset), .sw_rst(n7), .clk(clk_peri), .RST_pin(RESET_pin), 
        .interrupt_ack(interrupt_ack), .STOPwake_INT0(STOPwake_INT0), 
        .STOPwake_INT1(STOPwake_INT1), .SFR_wr(n18), .SFR_bus({
        EXT_SFR_DOUT[7:2], n4, n10}), .PCON_sel(PCON_sel), .SMOD1_update(
        SMOD1_update), .SMOD1(SMOD1), .SMOD0(SMOD0), .PCON({PCON_7_, PCON_6_, 
        PCON_5_, PCON_4_, PCON_3_, PCON_2_, pdwn, idle}), .pre_idle(pre_idle), 
        .pre_pdwn(pre_pdwn), .pre_pdwn_idle(pre_pdwn_idle) );
  pwm_top pwm_top ( .sw_rst(n7), .clk_b(clk_peri), .SFR_wr(n18), .PWM1CON_sel(
        PWM1CON_sel), .PWM2CON_sel(PWM2CON_sel), .PWM1D_sel(PWM1D_sel), 
        .PWM2D_sel(PWM2D_sel), .SFR_bus({EXT_SFR_DOUT[7:1], n10}), 
        .PWM_SFR_OUT(PWM_SFR_OUT), .pwm1_out(PWM1_OUT), .pwm2_out(PWM2_OUT) );
  wdt wdt ( .EWT(EWT), .CKCON_sel(CKCON_sel), .T2M(T2M), .T1M(T1M), .T0M(T0M), 
        .clk_b(clk_wdt), .reset(final_all_reset), .POR(final_POR_ext_reset), 
        .WDCON_sel(WDCON_sel), .SFR_wr(n18), .SFR_bus({EXT_SFR_DOUT[7:1], n10}), .wdt_intr(wdt_intr), .WDT_reset(wdt_reset), .WDT_SFR_OUT(WDT_SFR_OUT) );
  etc_sfr etc_sfr ( .clk_b(clk_peri), .reset(final_all_reset), .SFR_wr(n18), 
        .SFR_bus(EXT_SFR_DOUT), .PMR_sel(PMR_sel), .ALEOFF(ALEOFF), .PMR_OUT(
        PMR_OUT) );
  sfr_inf sfr_inf ( .SFR_DATA(SFR_DATA), .SFR_wr(n17), .SFR_addr({SFR_addr_8_, 
        EXT_SFR_ADDR}), .IDATA(IDATA), .PCON({PCON_7_, PCON_6_, PCON_5_, 
        PCON_4_, PCON_3_, PCON_2_, pdwn, idle}), .P0_OUT(P0_OUT), .P1_OUT(
        P1_OUT), .P2_OUT(P2_OUT), .P3_OUT(P3_OUT), .INT_SFR_OUT(INT_SFR_OUT), 
        .T01_SFR_OUT(T01_SFR_OUT), .T2_SFR_OUT(T2_SFR_OUT), .UART_SFR_OUT(
        UART_SFR_OUT), .WDT_SFR_OUT(WDT_SFR_OUT), .PWM_SFR_OUT(PWM_SFR_OUT), 
        .PMR_OUT(PMR_OUT), .SFR_bus({n19, n20, n21, n22, n23, n24, n25, n26}), 
        .PERI_SFR_sel(PERI_SFR_sel), .WDCON_sel(WDCON_sel), .PCON_sel(PCON_sel), .SCON_sel(SCON_sel), .SBUF_sel(SBUF_sel), .SADDR_sel(SADDR_sel), .SADEN_sel(
        SADEN_sel), .T2CON_sel(T2CON_sel), .T2MOD_sel(T2MOD_sel), .TH2_sel(
        TH2_sel), .TL2_sel(TL2_sel), .RCAP2L_sel(RCAP2L_sel), .RCAP2H_sel(
        RCAP2H_sel), .TH0_sel(TH0_sel), .TL0_sel(TL0_sel), .TH1_sel(TH1_sel), 
        .TL1_sel(TL1_sel), .TMOD_sel(TMOD_sel), .TCON_sel(TCON_sel), 
        .EXIF_sel(EXIF_sel), .IE_sel(IE_sel), .IP_sel(IP_sel), .EIE_sel(
        EIE_sel), .EIP_sel(EIP_sel), .IPH_sel(IPH_sel), .P0_sel(P0_sel), 
        .P1_sel(P1_sel), .P2_sel(P2_sel), .P3_sel(P3_sel), .PMR_sel(PMR_sel), 
        .PWM1CON_sel(PWM1CON_sel), .PWM2CON_sel(PWM2CON_sel), .PWM1D_sel(
        PWM1D_sel), .PWM2D_sel(PWM2D_sel), .CKCON_sel(CKCON_sel), 
        .EXT_SFR_DIN(EXT_SFR_DIN) );
  INVX1 I7 ( .A(1'b1), .Y(iram_oe_b) );
  INVX2 I9 ( .A(n25), .Y(n3) );
  INVX4 I10 ( .A(n3), .Y(EXT_SFR_DOUT[1]) );
  INVX4 I11 ( .A(n3), .Y(n4) );
  BUFX3 I12 ( .A(n19), .Y(EXT_SFR_DOUT[7]) );
  BUFX3 I13 ( .A(n20), .Y(EXT_SFR_DOUT[6]) );
  BUFX3 I14 ( .A(n22), .Y(EXT_SFR_DOUT[4]) );
  BUFX8 I15 ( .A(SFR_wr), .Y(n17) );
  BUFX4 I16 ( .A(n23), .Y(EXT_SFR_DOUT[3]) );
  BUFX4 I17 ( .A(n24), .Y(EXT_SFR_DOUT[2]) );
  BUFX4 I18 ( .A(n21), .Y(EXT_SFR_DOUT[5]) );
  INVX4 I19 ( .A(n8), .Y(n7) );
  BUFX4 I20 ( .A(SFR_wr), .Y(n18) );
  AND2X1 I21 ( .A(n18), .B(SFR_addr_8_), .Y(EXT_SFR_WR) );
  BUFX2 I22 ( .A(n26), .Y(EXT_SFR_DOUT[0]) );
  INVX1 I23 ( .A(ALE_B_I), .Y(xrom_ce_b) );
  INVX2 I24 ( .A(final_all_reset), .Y(n8) );
  OR2X2 I25 ( .A(EWDI), .B(EWT), .Y(WDT_RUN) );
  INVX1 I26 ( .A(ALE_B), .Y(ALE) );
  INVX1 I27 ( .A(PSEN_B), .Y(PSEN) );
  INVX1 I28 ( .A(PSEN_B), .Y(xrom_oe_b) );
  BUFX8 I31 ( .A(n26), .Y(n10) );
endmodule


module sfr_inf ( SFR_DATA, SFR_wr, SFR_addr, IDATA, PCON, P0_OUT, P1_OUT, 
        P2_OUT, P3_OUT, INT_SFR_OUT, T01_SFR_OUT, T2_SFR_OUT, UART_SFR_OUT, 
        WDT_SFR_OUT, PWM_SFR_OUT, PMR_OUT, SFR_bus, PERI_SFR_sel, WDCON_sel, 
        PCON_sel, SCON_sel, SBUF_sel, SADDR_sel, SADEN_sel, T2CON_sel, 
        T2MOD_sel, TH2_sel, TL2_sel, RCAP2L_sel, RCAP2H_sel, TH0_sel, TL0_sel, 
        TH1_sel, TL1_sel, TMOD_sel, TCON_sel, EXIF_sel, IE_sel, IP_sel, 
        EIE_sel, EIP_sel, IPH_sel, P0_sel, P1_sel, P2_sel, P3_sel, PMR_sel, 
        PWM1CON_sel, PWM2CON_sel, PWM1D_sel, PWM2D_sel, CKCON_sel, EXT_SFR_DIN
 );
  output [7:0] SFR_DATA;
  input [8:0] SFR_addr;
  input [7:0] IDATA;
  input [7:0] PCON;
  input [7:0] P0_OUT;
  input [7:0] P1_OUT;
  input [7:0] P2_OUT;
  input [7:0] P3_OUT;
  input [7:0] INT_SFR_OUT;
  input [7:0] T01_SFR_OUT;
  input [7:0] T2_SFR_OUT;
  input [7:0] UART_SFR_OUT;
  input [7:0] WDT_SFR_OUT;
  input [7:0] PWM_SFR_OUT;
  input [7:0] PMR_OUT;
  output [7:0] SFR_bus;
  input [7:0] EXT_SFR_DIN;
  input SFR_wr;
  output PERI_SFR_sel, WDCON_sel, PCON_sel, SCON_sel, SBUF_sel, SADDR_sel,
         SADEN_sel, T2CON_sel, T2MOD_sel, TH2_sel, TL2_sel, RCAP2L_sel,
         RCAP2H_sel, TH0_sel, TL0_sel, TH1_sel, TL1_sel, TMOD_sel, TCON_sel,
         EXIF_sel, IE_sel, IP_sel, EIE_sel, EIP_sel, IPH_sel, P0_sel, P1_sel,
         P2_sel, P3_sel, PMR_sel, PWM1CON_sel, PWM2CON_sel, PWM1D_sel,
         PWM2D_sel, CKCON_sel;
  wire   n275, n2, n3, n4, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n31, n32, n33,
         n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62, n63, n64, n65, n66, n67, n68, n83, n91, n92, n93, n99, n100,
         n101, n102, n103, n104, n105, n106, n108, n112, n121, n125, n127,
         n128, n129, n132, n133, n134, n135, n141, n150, n156, n158, n161,
         n162, n163, n164, n165, n166, n167, n169, n170, n171, n173, n174,
         n175, n176, n177, n178, n179, n180, n182, n187, n189, n190, n191,
         n192, n193, n194, n195, n196, n197, n198, n199, n200, n201, n202,
         n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, n213,
         n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, n224,
         n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235,
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246,
         n247, n248, n249, n250, n251, n252, n253, n254, n255, n256, n257,
         n258, n259, n260, n261, n262, n263, n264, n265, n266, n267, n268,
         n269, n270, n271;

  AOI221X4 U33 ( .A0(T2_SFR_OUT[7]), .A1(n25), .B0(T01_SFR_OUT[7]), .B1(n26), 
        .C0(n27), .Y(n24) );
  AOI222X4 U35 ( .A0(P2_OUT[7]), .A1(P2_sel), .B0(P1_OUT[7]), .B1(P1_sel), 
        .C0(P0_OUT[7]), .C1(P0_sel), .Y(n29) );
  AOI222X4 U38 ( .A0(INT_SFR_OUT[7]), .A1(n31), .B0(WDT_SFR_OUT[7]), .B1(n32), 
        .C0(UART_SFR_OUT[7]), .C1(n33), .Y(n22) );
  AOI221X4 U41 ( .A0(T2_SFR_OUT[6]), .A1(n25), .B0(T01_SFR_OUT[6]), .B1(n26), 
        .C0(n38), .Y(n37) );
  AOI222X4 U43 ( .A0(P2_OUT[6]), .A1(P2_sel), .B0(P1_OUT[6]), .B1(P1_sel), 
        .C0(P0_OUT[6]), .C1(P0_sel), .Y(n40) );
  AOI222X4 U46 ( .A0(INT_SFR_OUT[6]), .A1(n31), .B0(WDT_SFR_OUT[6]), .B1(n32), 
        .C0(UART_SFR_OUT[6]), .C1(n33), .Y(n35) );
  AOI221X4 U49 ( .A0(T2_SFR_OUT[5]), .A1(n25), .B0(T01_SFR_OUT[5]), .B1(n26), 
        .C0(n45), .Y(n44) );
  AOI222X4 U51 ( .A0(P2_OUT[5]), .A1(P2_sel), .B0(P1_OUT[5]), .B1(P1_sel), 
        .C0(P0_OUT[5]), .C1(P0_sel), .Y(n47) );
  AOI222X4 U54 ( .A0(INT_SFR_OUT[5]), .A1(n31), .B0(WDT_SFR_OUT[5]), .B1(n32), 
        .C0(UART_SFR_OUT[5]), .C1(n33), .Y(n42) );
  AOI221X4 U57 ( .A0(T2_SFR_OUT[4]), .A1(n25), .B0(T01_SFR_OUT[4]), .B1(n26), 
        .C0(n52), .Y(n51) );
  AOI222X4 U59 ( .A0(P2_OUT[4]), .A1(P2_sel), .B0(P1_OUT[4]), .B1(P1_sel), 
        .C0(P0_OUT[4]), .C1(P0_sel), .Y(n54) );
  AOI222X4 U62 ( .A0(INT_SFR_OUT[4]), .A1(n31), .B0(WDT_SFR_OUT[4]), .B1(n32), 
        .C0(UART_SFR_OUT[4]), .C1(n33), .Y(n49) );
  AOI221X4 U65 ( .A0(T2_SFR_OUT[3]), .A1(n25), .B0(T01_SFR_OUT[3]), .B1(n26), 
        .C0(n59), .Y(n58) );
  AOI222X4 U67 ( .A0(P2_OUT[3]), .A1(P2_sel), .B0(P1_OUT[3]), .B1(P1_sel), 
        .C0(P0_OUT[3]), .C1(P0_sel), .Y(n61) );
  AOI222X4 U70 ( .A0(INT_SFR_OUT[3]), .A1(n31), .B0(WDT_SFR_OUT[3]), .B1(n32), 
        .C0(UART_SFR_OUT[3]), .C1(n33), .Y(n56) );
  AOI221X4 U73 ( .A0(T2_SFR_OUT[2]), .A1(n25), .B0(T01_SFR_OUT[2]), .B1(n26), 
        .C0(n66), .Y(n65) );
  AOI222X4 U75 ( .A0(P2_OUT[2]), .A1(P2_sel), .B0(P1_OUT[2]), .B1(P1_sel), 
        .C0(P0_OUT[2]), .C1(P0_sel), .Y(n68) );
  AOI222X4 U78 ( .A0(INT_SFR_OUT[2]), .A1(n31), .B0(WDT_SFR_OUT[2]), .B1(n32), 
        .C0(UART_SFR_OUT[2]), .C1(n33), .Y(n63) );
  OR2X2 I215 ( .A(n99), .B(n161), .Y(n7) );
  INVX1 I216 ( .A(n170), .Y(n161) );
  NAND2X1 I217 ( .A(n249), .B(n170), .Y(n8) );
  INVX1 I218 ( .A(n101), .Y(n249) );
  AOI21X1 I219 ( .A0(n162), .A1(EXT_SFR_DIN[0]), .B0(n232), .Y(n231) );
  INVX1 I220 ( .A(n196), .Y(n162) );
  NOR2BX1 I221 ( .AN(n239), .B(n179), .Y(n238) );
  OR3X1 I222 ( .A(n99), .B(n271), .C(n102), .Y(n6) );
  OR3X1 I223 ( .A(n271), .B(n190), .C(n102), .Y(n3) );
  OR3X2 I224 ( .A(n99), .B(n270), .C(n264), .Y(n246) );
  OR2X2 I225 ( .A(n121), .B(n150), .Y(n216) );
  AND4X2 I226 ( .A(n3), .B(n6), .C(n11), .D(n250), .Y(n163) );
  INVX2 I227 ( .A(n163), .Y(n25) );
  NAND2X1 I228 ( .A(n238), .B(n271), .Y(n132) );
  AND4X2 I229 ( .A(n247), .B(n7), .C(n9), .D(n8), .Y(n164) );
  INVX2 I230 ( .A(n164), .Y(n26) );
  NOR2X2 I231 ( .A(n197), .B(n260), .Y(n263) );
  OR2X2 I232 ( .A(n101), .B(n100), .Y(n11) );
  NAND2X1 I233 ( .A(SFR_addr[0]), .B(SFR_addr[1]), .Y(n103) );
  NAND4BBX1 I234 ( .AN(n275), .BN(n191), .C(n194), .D(n195), .Y(n182) );
  NAND2BX2 I235 ( .AN(n104), .B(n170), .Y(n243) );
  NAND2X1 I236 ( .A(n112), .B(n238), .Y(n133) );
  OR2X2 I237 ( .A(n101), .B(n125), .Y(n9) );
  NOR3X1 I238 ( .A(SFR_addr[0]), .B(n121), .C(n267), .Y(n258) );
  AND4X2 I239 ( .A(n187), .B(n237), .C(n132), .D(n133), .Y(n165) );
  INVX2 I240 ( .A(n165), .Y(n31) );
  OR2X2 I241 ( .A(n102), .B(n112), .Y(n108) );
  INVX1 I242 ( .A(n271), .Y(n112) );
  AOI22X1 I243 ( .A0(n166), .A1(EXT_SFR_DIN[1]), .B0(n167), .B1(PMR_OUT[1]), 
        .Y(n213) );
  INVX1 I244 ( .A(n196), .Y(n166) );
  INVX1 I245 ( .A(n214), .Y(n167) );
  OR3X2 I246 ( .A(n190), .B(n264), .C(n105), .Y(n200) );
  INVX1 I247 ( .A(n270), .Y(n105) );
  AND2X2 I248 ( .A(PMR_sel), .B(PMR_OUT[0]), .Y(n232) );
  INVX2 I249 ( .A(n7), .Y(TH1_sel) );
  AND3X4 I250 ( .A(n271), .B(n267), .C(n265), .Y(IP_sel) );
  OAI2BB1X1 I251 ( .A0N(SFR_DATA[1]), .A1N(n173), .B0(n174), .Y(SFR_bus[1]) );
  INVX2 I252 ( .A(IDATA[0]), .Y(n202) );
  INVX1 I253 ( .A(n266), .Y(n265) );
  INVX2 I254 ( .A(n216), .Y(PCON_sel) );
  NAND2X1 I255 ( .A(n255), .B(n265), .Y(n195) );
  INVX1 I256 ( .A(n134), .Y(EXIF_sel) );
  NAND2X1 I257 ( .A(IDATA[1]), .B(SFR_wr), .Y(n174) );
  INVX1 I258 ( .A(n252), .Y(n199) );
  INVX1 I259 ( .A(SFR_addr[0]), .Y(n141) );
  OAI21X2 I260 ( .A0(n233), .A1(n177), .B0(n175), .Y(n196) );
  AOI21X1 I261 ( .A0(n249), .A1(n121), .B0(n234), .Y(n233) );
  BUFX3 I262 ( .A(SFR_addr[4]), .Y(n271) );
  NOR2X1 I263 ( .A(n271), .B(n237), .Y(IE_sel) );
  INVX1 I264 ( .A(n196), .Y(n20) );
  NAND2X2 I265 ( .A(n200), .B(n243), .Y(n32) );
  NAND2X2 I266 ( .A(SFR_addr[8]), .B(SFR_addr[7]), .Y(n197) );
  NOR3X2 I267 ( .A(n101), .B(n105), .C(n197), .Y(n239) );
  AND2X2 I268 ( .A(n261), .B(n199), .Y(n170) );
  OR2X2 I269 ( .A(SFR_addr[1]), .B(n141), .Y(n99) );
  NAND2X1 I270 ( .A(n180), .B(n141), .Y(n192) );
  NAND2X1 I271 ( .A(n258), .B(n263), .Y(n193) );
  INVX2 I272 ( .A(n195), .Y(P3_sel) );
  OAI2BB1X1 I273 ( .A0N(EXT_SFR_DIN[7]), .A1N(n20), .B0(n21), .Y(SFR_DATA[7])
         );
  OAI2BB1X1 I274 ( .A0N(EXT_SFR_DIN[6]), .A1N(n20), .B0(n34), .Y(SFR_DATA[6])
         );
  OAI2BB1X1 I275 ( .A0N(EXT_SFR_DIN[4]), .A1N(n20), .B0(n48), .Y(SFR_DATA[4])
         );
  NOR3X1 I276 ( .A(n197), .B(n270), .C(n267), .Y(n156) );
  OAI2BB1X1 I277 ( .A0N(n20), .A1N(SFR_addr[8]), .B0(n175), .Y(PERI_SFR_sel)
         );
  AOI22X1 I278 ( .A0(PCON[7]), .A1(PCON_sel), .B0(P3_OUT[7]), .B1(P3_sel), .Y(
        n28) );
  AOI22X1 I279 ( .A0(PCON[6]), .A1(PCON_sel), .B0(P3_OUT[6]), .B1(P3_sel), .Y(
        n39) );
  AOI22X1 I280 ( .A0(PCON[5]), .A1(PCON_sel), .B0(P3_OUT[5]), .B1(P3_sel), .Y(
        n46) );
  AOI22X1 I281 ( .A0(PCON[3]), .A1(PCON_sel), .B0(P3_OUT[3]), .B1(P3_sel), .Y(
        n60) );
  INVX2 I282 ( .A(n178), .Y(SADDR_sel) );
  AOI22X1 I283 ( .A0(PCON[2]), .A1(PCON_sel), .B0(P3_OUT[2]), .B1(P3_sel), .Y(
        n67) );
  AOI22X1 I284 ( .A0(PCON[4]), .A1(PCON_sel), .B0(P3_OUT[4]), .B1(P3_sel), .Y(
        n53) );
  NOR2BX1 I285 ( .AN(n271), .B(n267), .Y(n255) );
  OR2X2 I286 ( .A(n125), .B(n103), .Y(n4) );
  OR2X2 I287 ( .A(n125), .B(n99), .Y(n2) );
  OR2X2 I288 ( .A(n99), .B(n100), .Y(n10) );
  NOR2X1 I289 ( .A(n207), .B(n208), .Y(n206) );
  OAI2BB1X1 I290 ( .A0N(EXT_SFR_DIN[5]), .A1N(n20), .B0(n41), .Y(SFR_DATA[5])
         );
  OAI2BB1X1 I291 ( .A0N(EXT_SFR_DIN[3]), .A1N(n20), .B0(n55), .Y(SFR_DATA[3])
         );
  OAI2BB1X1 I292 ( .A0N(EXT_SFR_DIN[2]), .A1N(n20), .B0(n62), .Y(SFR_DATA[2])
         );
  INVX1 I293 ( .A(n169), .Y(SCON_sel) );
  INVX1 I294 ( .A(n269), .Y(n268) );
  OR3X2 I295 ( .A(n264), .B(n270), .C(n101), .Y(n169) );
  BUFX3 I296 ( .A(SFR_addr[6]), .Y(n270) );
  NOR2X1 I297 ( .A(n104), .B(n108), .Y(PWM1D_sel) );
  NOR2X2 I298 ( .A(n99), .B(n108), .Y(PWM2CON_sel) );
  INVX1 I299 ( .A(SFR_addr[2]), .Y(n269) );
  MXI2X4 I300 ( .S0(SFR_wr), .B(n202), .A(n201), .Y(SFR_bus[0]) );
  NAND4X1 I301 ( .A(n203), .B(n204), .C(n205), .D(n206), .Y(SFR_DATA[1]) );
  OR2X2 I302 ( .A(n104), .B(n100), .Y(n83) );
  OR2X2 I303 ( .A(SFR_addr[0]), .B(n158), .Y(n104) );
  INVX2 I304 ( .A(n132), .Y(EIP_sel) );
  INVX2 I305 ( .A(n4), .Y(TL1_sel) );
  NOR2X2 I306 ( .A(n125), .B(n104), .Y(TL0_sel) );
  OR2X2 I307 ( .A(SFR_addr[6]), .B(n106), .Y(n125) );
  NAND3X2 I308 ( .A(n245), .B(n169), .C(n246), .Y(n33) );
  NOR2X2 I309 ( .A(TL0_sel), .B(n248), .Y(n247) );
  OR2X2 I310 ( .A(n103), .B(n100), .Y(n171) );
  INVX2 I311 ( .A(n171), .Y(RCAP2H_sel) );
  NOR2X2 I312 ( .A(RCAP2H_sel), .B(n251), .Y(n250) );
  NOR2X4 I313 ( .A(n101), .B(n108), .Y(PWM1CON_sel) );
  NOR2X1 I314 ( .A(n225), .B(n226), .Y(n224) );
  INVX1 I315 ( .A(SFR_wr), .Y(n173) );
  BUFX3 I316 ( .A(SFR_addr[3]), .Y(n267) );
  AND3X2 I317 ( .A(n91), .B(n92), .C(n93), .Y(n175) );
  INVX1 I318 ( .A(n8), .Y(TH0_sel) );
  INVX2 I319 ( .A(n11), .Y(T2CON_sel) );
  OR4X2 I320 ( .A(PWM1D_sel), .B(PWM2D_sel), .C(PWM1CON_sel), .D(PWM2CON_sel), 
        .Y(n176) );
  NAND4X1 I321 ( .A(n253), .B(n254), .C(n268), .D(n239), .Y(n214) );
  INVX2 I322 ( .A(n246), .Y(SBUF_sel) );
  INVX2 I323 ( .A(n9), .Y(TCON_sel) );
  NAND2X1 I324 ( .A(n4), .B(n2), .Y(n248) );
  INVX2 I325 ( .A(n83), .Y(RCAP2L_sel) );
  INVX1 I326 ( .A(n133), .Y(EIE_sel) );
  NAND4X1 I327 ( .A(n221), .B(n222), .C(n223), .D(n224), .Y(SFR_DATA[0]) );
  AOI21X1 I328 ( .A0(n176), .A1(PWM_SFR_OUT[1]), .B0(n218), .Y(n204) );
  OR2X1 I329 ( .A(n268), .B(n197), .Y(n177) );
  NOR2X1 I330 ( .A(n112), .B(n245), .Y(SADEN_sel) );
  NAND3BX1 I331 ( .AN(SFR_addr[2]), .B(n105), .C(n158), .Y(n260) );
  NAND3X1 I332 ( .A(n268), .B(n270), .C(n199), .Y(n102) );
  OR2X1 I333 ( .A(n271), .B(n245), .Y(n178) );
  OAI2BB2X1 I334 ( .A0N(IDATA[3]), .A1N(SFR_wr), .B0(SFR_wr), .B1(n16), .Y(
        SFR_bus[3]) );
  INVX1 I335 ( .A(n267), .Y(n254) );
  OAI2BB2X1 I336 ( .A0N(IDATA[2]), .A1N(SFR_wr), .B0(SFR_wr), .B1(n17), .Y(
        SFR_bus[2]) );
  INVX1 I337 ( .A(n135), .Y(IPH_sel) );
  OAI2BB2X1 I338 ( .A0N(IDATA[5]), .A1N(SFR_wr), .B0(SFR_wr), .B1(n14), .Y(
        SFR_bus[5]) );
  OAI2BB2X1 I339 ( .A0N(IDATA[4]), .A1N(SFR_wr), .B0(SFR_wr), .B1(n15), .Y(
        SFR_bus[4]) );
  OAI2BB2X1 I340 ( .A0N(IDATA[6]), .A1N(SFR_wr), .B0(SFR_wr), .B1(n13), .Y(
        SFR_bus[6]) );
  OAI2BB2X1 I341 ( .A0N(SFR_wr), .A1N(IDATA[7]), .B0(SFR_wr), .B1(n12), .Y(
        SFR_bus[7]) );
  NOR2X1 I342 ( .A(n270), .B(n121), .Y(n234) );
  AOI21X1 I343 ( .A0(P3_OUT[0]), .A1(P3_sel), .B0(n235), .Y(n230) );
  AOI21X1 I344 ( .A0(P3_OUT[1]), .A1(P3_sel), .B0(n215), .Y(n212) );
  NAND3X1 I345 ( .A(SFR_addr[5]), .B(n269), .C(n267), .Y(n179) );
  NAND2BX1 I346 ( .AN(n197), .B(n262), .Y(n252) );
  NAND3BX1 I347 ( .AN(n150), .B(SFR_addr[5]), .C(n271), .Y(n135) );
  NAND2X1 I348 ( .A(n180), .B(SFR_addr[0]), .Y(n134) );
  AND2X1 I349 ( .A(n257), .B(n263), .Y(n180) );
  INVX1 I350 ( .A(SFR_addr[1]), .Y(n158) );
  BUFX3 I351 ( .A(n190), .Y(n101) );
  AND3X2 I352 ( .A(n127), .B(n128), .C(n129), .Y(n91) );
  INVX1 I353 ( .A(n26), .Y(n92) );
  BUFX3 I354 ( .A(n189), .Y(PMR_sel) );
  INVX1 I355 ( .A(n214), .Y(n189) );
  INVX1 I356 ( .A(n32), .Y(n128) );
  NAND2X1 I357 ( .A(n83), .B(n10), .Y(n251) );
  INVX1 I358 ( .A(SFR_DATA[0]), .Y(n201) );
  OR2X2 I359 ( .A(n105), .B(n106), .Y(n100) );
  NOR2X1 I360 ( .A(n103), .B(n108), .Y(PWM2D_sel) );
  NOR3X1 I361 ( .A(n182), .B(n176), .C(n25), .Y(n93) );
  INVX4 I362 ( .A(n243), .Y(CKCON_sel) );
  INVX1 I363 ( .A(n6), .Y(TH2_sel) );
  NOR2X1 I364 ( .A(PMR_sel), .B(PCON_sel), .Y(n194) );
  NAND2X1 I365 ( .A(n192), .B(n193), .Y(n191) );
  INVX1 I366 ( .A(n3), .Y(TL2_sel) );
  INVX1 I367 ( .A(n31), .Y(n129) );
  INVX1 I368 ( .A(n33), .Y(n127) );
  INVX1 I369 ( .A(n10), .Y(T2MOD_sel) );
  INVX2 I370 ( .A(n193), .Y(P0_sel) );
  INVX2 I371 ( .A(n192), .Y(P1_sel) );
  INVX1 I372 ( .A(n200), .Y(WDCON_sel) );
  INVX1 I373 ( .A(n2), .Y(TMOD_sel) );
  AOI21X1 I374 ( .A0(PWM_SFR_OUT[0]), .A1(n176), .B0(n240), .Y(n222) );
  AOI22X1 I375 ( .A0(T2_SFR_OUT[0]), .A1(n25), .B0(T01_SFR_OUT[0]), .B1(n26), 
        .Y(n221) );
  NAND2X1 I376 ( .A(INT_SFR_OUT[0]), .B(n31), .Y(n223) );
  AOI22X1 I377 ( .A0(T2_SFR_OUT[1]), .A1(n25), .B0(T01_SFR_OUT[1]), .B1(n26), 
        .Y(n203) );
  NAND2X1 I378 ( .A(INT_SFR_OUT[1]), .B(n31), .Y(n205) );
  NAND2X2 I379 ( .A(n267), .B(n265), .Y(n237) );
  INVX1 I380 ( .A(SFR_DATA[7]), .Y(n12) );
  NAND2X1 I381 ( .A(n230), .B(n231), .Y(n225) );
  OAI221X4 I382 ( .A0(n192), .A1(n227), .B0(n193), .B1(n228), .C0(n229), .Y(
        n226) );
  NAND2X1 I383 ( .A(n212), .B(n213), .Y(n207) );
  OAI221X4 I384 ( .A0(n192), .A1(n209), .B0(n193), .B1(n210), .C0(n211), .Y(
        n208) );
  NAND2X1 I385 ( .A(n198), .B(n199), .Y(n106) );
  NOR2X1 I386 ( .A(n271), .B(n268), .Y(n198) );
  AND2X2 I387 ( .A(n135), .B(n134), .Y(n187) );
  INVX1 I388 ( .A(SFR_DATA[3]), .Y(n16) );
  INVX1 I389 ( .A(SFR_DATA[5]), .Y(n14) );
  INVX1 I390 ( .A(SFR_DATA[2]), .Y(n17) );
  INVX1 I391 ( .A(SFR_DATA[4]), .Y(n15) );
  INVX1 I392 ( .A(SFR_DATA[6]), .Y(n13) );
  INVX1 I393 ( .A(n121), .Y(n253) );
  NAND2X1 I394 ( .A(n241), .B(n242), .Y(n240) );
  NAND2X1 I395 ( .A(WDT_SFR_OUT[0]), .B(n32), .Y(n242) );
  NAND2X1 I396 ( .A(UART_SFR_OUT[0]), .B(n33), .Y(n241) );
  NAND2X1 I397 ( .A(n219), .B(n220), .Y(n218) );
  NAND2X1 I398 ( .A(WDT_SFR_OUT[1]), .B(n32), .Y(n220) );
  NAND2X1 I399 ( .A(UART_SFR_OUT[1]), .B(n33), .Y(n219) );
  INVX1 I400 ( .A(n244), .Y(n264) );
  NOR3BX1 I401 ( .AN(n271), .B(n252), .C(n268), .Y(n244) );
  NOR3X1 I402 ( .A(n269), .B(n270), .C(n271), .Y(n261) );
  NAND2X1 I403 ( .A(n28), .B(n29), .Y(n27) );
  NAND2X1 I404 ( .A(n39), .B(n40), .Y(n38) );
  NAND2X1 I405 ( .A(n46), .B(n47), .Y(n45) );
  NAND2X1 I406 ( .A(n53), .B(n54), .Y(n52) );
  NAND2X1 I407 ( .A(n60), .B(n61), .Y(n59) );
  NAND2X1 I408 ( .A(n67), .B(n68), .Y(n66) );
  BUFX3 I409 ( .A(n275), .Y(P2_sel) );
  NOR3X1 I410 ( .A(n266), .B(n271), .C(n267), .Y(n275) );
  NOR2X1 I411 ( .A(n216), .B(n236), .Y(n235) );
  INVX1 I412 ( .A(PCON[0]), .Y(n236) );
  NOR2X1 I413 ( .A(n216), .B(n217), .Y(n215) );
  INVX1 I414 ( .A(PCON[1]), .Y(n217) );
  NOR2BX1 I415 ( .AN(n267), .B(SFR_addr[5]), .Y(n262) );
  NAND2X1 I416 ( .A(P2_OUT[0]), .B(P2_sel), .Y(n229) );
  NAND2X1 I417 ( .A(P2_OUT[1]), .B(P2_sel), .Y(n211) );
  INVX1 I418 ( .A(n256), .Y(n266) );
  NOR3BX1 I419 ( .AN(SFR_addr[5]), .B(n259), .C(SFR_addr[0]), .Y(n256) );
  INVX1 I420 ( .A(n263), .Y(n259) );
  INVX1 I421 ( .A(P1_OUT[0]), .Y(n227) );
  INVX1 I422 ( .A(P1_OUT[1]), .Y(n209) );
  INVX1 I423 ( .A(P0_OUT[0]), .Y(n228) );
  INVX1 I424 ( .A(P0_OUT[1]), .Y(n210) );
  OR2X2 I425 ( .A(n271), .B(SFR_addr[5]), .Y(n121) );
  NAND4X2 I426 ( .A(n267), .B(SFR_addr[5]), .C(SFR_addr[0]), .D(n263), .Y(n245) );
  AND3X2 I427 ( .A(n22), .B(n23), .C(n24), .Y(n21) );
  AOI22X1 I428 ( .A0(PMR_OUT[7]), .A1(PMR_sel), .B0(PWM_SFR_OUT[7]), .B1(n176), 
        .Y(n23) );
  AND3X2 I429 ( .A(n35), .B(n36), .C(n37), .Y(n34) );
  AOI22X1 I430 ( .A0(PMR_OUT[6]), .A1(PMR_sel), .B0(PWM_SFR_OUT[6]), .B1(n176), 
        .Y(n36) );
  AND3X2 I431 ( .A(n42), .B(n43), .C(n44), .Y(n41) );
  AOI22X1 I432 ( .A0(PMR_OUT[5]), .A1(PMR_sel), .B0(PWM_SFR_OUT[5]), .B1(n176), 
        .Y(n43) );
  AND3X2 I433 ( .A(n49), .B(n50), .C(n51), .Y(n48) );
  AOI22X1 I434 ( .A0(PMR_OUT[4]), .A1(PMR_sel), .B0(PWM_SFR_OUT[4]), .B1(n176), 
        .Y(n50) );
  AND3X2 I435 ( .A(n56), .B(n57), .C(n58), .Y(n55) );
  AOI22X1 I436 ( .A0(PMR_OUT[3]), .A1(PMR_sel), .B0(PWM_SFR_OUT[3]), .B1(n176), 
        .Y(n57) );
  AND3X2 I437 ( .A(n63), .B(n64), .C(n65), .Y(n62) );
  AOI22X1 I438 ( .A0(PMR_OUT[2]), .A1(PMR_sel), .B0(PWM_SFR_OUT[2]), .B1(n176), 
        .Y(n64) );
  NAND2BX1 I439 ( .AN(SFR_addr[0]), .B(n158), .Y(n190) );
  NOR3X1 I440 ( .A(n112), .B(SFR_addr[5]), .C(n267), .Y(n257) );
  NAND3BX1 I441 ( .AN(n103), .B(SFR_addr[2]), .C(n156), .Y(n150) );
endmodule


module etc_sfr ( clk_b, reset, SFR_wr, SFR_bus, PMR_sel, ALEOFF, PMR_OUT );
  input [7:0] SFR_bus;
  output [7:0] PMR_OUT;
  input clk_b, reset, SFR_wr, PMR_sel;
  output ALEOFF;
  wire   PMR_7_, PMR_6_, PMR_5_, PMR_4_, PMR_3_, PMR_1_, PMR_0_, N4, N5, N6,
         N7, N11, N12, N13, N14, N18, n50, n60;

  AND3X2 I22 ( .A(SFR_wr), .B(n60), .C(PMR_sel), .Y(n50) );
  AND2X2 I23 ( .A(SFR_bus[7]), .B(n50), .Y(N7) );
  AND2X2 I24 ( .A(SFR_bus[6]), .B(n50), .Y(N6) );
  AND2X2 I25 ( .A(SFR_bus[5]), .B(n50), .Y(N5) );
  AND2X2 I26 ( .A(SFR_bus[4]), .B(n50), .Y(N4) );
  AND2X2 I27 ( .A(SFR_bus[3]), .B(n50), .Y(N14) );
  AND2X2 I28 ( .A(SFR_bus[2]), .B(n50), .Y(N13) );
  OR2X2 I29 ( .A(n50), .B(reset), .Y(N18) );
  INVX1 I30 ( .A(reset), .Y(n60) );
  AND2X2 I31 ( .A(PMR_1_), .B(PMR_sel), .Y(PMR_OUT[1]) );
  AND2X2 I32 ( .A(PMR_0_), .B(PMR_sel), .Y(PMR_OUT[0]) );
  AND2X2 I33 ( .A(PMR_6_), .B(PMR_sel), .Y(PMR_OUT[6]) );
  AND2X2 I34 ( .A(PMR_5_), .B(PMR_sel), .Y(PMR_OUT[5]) );
  AND2X2 I35 ( .A(PMR_3_), .B(PMR_sel), .Y(PMR_OUT[3]) );
  AND2X2 I36 ( .A(ALEOFF), .B(PMR_sel), .Y(PMR_OUT[2]) );
  AND2X2 I37 ( .A(PMR_sel), .B(PMR_7_), .Y(PMR_OUT[7]) );
  AND2X2 I38 ( .A(PMR_4_), .B(PMR_sel), .Y(PMR_OUT[4]) );
  EDFFX1 PMR_reg_0_ ( .D(N11), .CK(clk_b), .E(N18), .Q(PMR_0_) );
  EDFFX1 PMR_reg_1_ ( .D(N12), .CK(clk_b), .E(N18), .Q(PMR_1_) );
  EDFFX1 PMR_reg_7_ ( .D(N7), .CK(clk_b), .E(N18), .Q(PMR_7_) );
  EDFFX1 PMR_reg_2_ ( .D(N13), .CK(clk_b), .E(N18), .Q(ALEOFF) );
  EDFFX1 PMR_reg_6_ ( .D(N6), .CK(clk_b), .E(N18), .Q(PMR_6_) );
  EDFFX1 PMR_reg_5_ ( .D(N5), .CK(clk_b), .E(N18), .Q(PMR_5_) );
  EDFFX1 PMR_reg_4_ ( .D(N4), .CK(clk_b), .E(N18), .Q(PMR_4_) );
  EDFFX1 PMR_reg_3_ ( .D(N14), .CK(clk_b), .E(N18), .Q(PMR_3_) );
  AND2X1 I39 ( .A(SFR_bus[1]), .B(n50), .Y(N12) );
  AND2X1 I40 ( .A(SFR_bus[0]), .B(n50), .Y(N11) );
endmodule


module wdt ( EWT, CKCON_sel, T2M, T1M, T0M, LVD_intr, clk_b, reset, POR, 
        WDCON_sel, SFR_wr, SFR_bus, wdt_intr, WDT_reset, WDT_SFR_OUT );
  input [7:0] SFR_bus;
  output [7:0] WDT_SFR_OUT;
  input CKCON_sel, clk_b, reset, POR, WDCON_sel, SFR_wr;
  output EWT, T2M, T1M, T0M, LVD_intr, wdt_intr, WDT_reset;
  wire   CKCON_7_, CKCON_6_, RWT, RWT_D, N88, N89, N90, N91, N92, N101, N102,
         N103, N104, N105, N106, N107, N108, N109, N110, N111, N112, N113,
         N114, N115, N116, N117, N118, N119, N120, N121, N122, N123, N124,
         N125, N126, N127, N128, N129, N130, N131, N132, N133, N134, N135,
         N136, N137, n2, n3, n6, n15, n21, n23, n24, n26, n28, n34, n35, n36,
         n37, n40, n41, n42, n43, n46, n48, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n880, n890, n900, n910, n920, n93, n94, n95, n96, n97,
         n98, n99, n100, n1010, n1020, n1030, n1040, n1050, n1060, n1070,
         n1080, n1090, n1100, n1110, n1120, n1130, n1140, n1150, n1160, n1170,
         n1180, n1190, n1200, n1210, n1220, n1230, n1240, n1250, n1260, n1270,
         n1280, n1290, n1300, n1310, n1320, n1330, n1340, n1350, n1360, n1370,
         n138, n139, n140, n141, n142, n143, n144, n145, n146, n147, n148,
         n149, n150, n151, n152, n153, n154, n155, n156, n157, n158, n159,
         n160, n161, n162, n163, n164, n165, n166, n167, n168, n169, n170,
         n171, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181,
         n182, n183, n184, n185, n187, n189, n191, n193, n197, n198, n199,
         n200, n201, n202, n203, n204, n205, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232;
  wire   [26:0] wdt_count;
  wire   [9:0] count_512;
  wire   [4:0] wdt_rst_cnt;

  OAI33X4 U75 ( .A0(n202), .A1(n201), .A2(n206), .B0(n206), .B1(CKCON_7_), 
        .B2(n213), .Y(n37) );
  OAI33X4 U78 ( .A0(n201), .A1(CKCON_6_), .A2(n214), .B0(n207), .B1(CKCON_7_), 
        .B2(CKCON_6_), .Y(n36) );
  INVX1 I168 ( .A(1'b1), .Y(LVD_intr) );
  NAND2X2 I170 ( .A(SFR_wr), .B(CKCON_sel), .Y(n46) );
  AOI21X1 I171 ( .A0(n21), .A1(n215), .B0(RWT), .Y(n197) );
  INVX3 I172 ( .A(n197), .Y(n229) );
  NAND3X1 I173 ( .A(wdt_rst_cnt[0]), .B(n198), .C(n2), .Y(n3) );
  INVX1 I174 ( .A(n6), .Y(n198) );
  AND2X2 I175 ( .A(n1120), .B(n228), .Y(n63) );
  NOR2X1 I176 ( .A(n15), .B(RWT), .Y(n224) );
  OR2X2 I177 ( .A(n15), .B(RWT), .Y(n199) );
  OR2X2 I178 ( .A(n15), .B(RWT), .Y(n200) );
  INVX1 I179 ( .A(n21), .Y(n15) );
  NAND2X2 I180 ( .A(WDCON_sel), .B(SFR_wr), .Y(n34) );
  OAI31X1 I181 ( .A0(n34), .A1(RWT), .A2(n40), .B0(n41), .Y(n1120) );
  OAI211X1 I182 ( .A0(SFR_bus[0]), .A1(n34), .B0(RWT_D), .C0(RWT), .Y(n41) );
  DFFRX1 wdt_count_reg_16_ ( .D(n920), .CK(clk_b), .RN(n48), .Q(wdt_count[16]), 
        .QN(n149) );
  DFFRX1 wdt_count_reg_19_ ( .D(n95), .CK(clk_b), .RN(n48), .Q(wdt_count[19]), 
        .QN(n154) );
  DFFRX1 wdt_count_reg_22_ ( .D(n98), .CK(clk_b), .RN(n48), .Q(wdt_count[22]), 
        .QN(n161) );
  DFFRX1 wdt_count_reg_0_ ( .D(n76), .CK(clk_b), .RN(n48), .Q(wdt_count[0]), 
        .QN(n1350) );
  DFFRX1 CKCON_reg_3_ ( .D(n53), .CK(clk_b), .RN(n48), .Q(T0M), .QN(n205) );
  DFFRX1 wdt_count_reg_17_ ( .D(n93), .CK(clk_b), .RN(n48), .Q(wdt_count[17]), 
        .QN(n207) );
  DFFRX1 wdt_rst_cnt_reg_0_ ( .D(n58), .CK(clk_b), .RN(n48), .Q(wdt_rst_cnt[0]), .QN(n208) );
  DFFRX1 wdt_count_reg_20_ ( .D(n96), .CK(clk_b), .RN(n48), .Q(wdt_count[20]), 
        .QN(n213) );
  DFFRX1 wdt_count_reg_23_ ( .D(n99), .CK(clk_b), .RN(n48), .Q(wdt_count[23]), 
        .QN(n214) );
  DFFRX1 CKCON_reg_5_ ( .D(n55), .CK(clk_b), .RN(n48), .Q(T2M), .QN(n217) );
  DFFRX1 CKCON_reg_4_ ( .D(n54), .CK(clk_b), .RN(n48), .Q(T1M), .QN(n218) );
  INVX4 I183 ( .A(RWT), .Y(n219) );
  INVX4 I184 ( .A(POR), .Y(n220) );
  INVX4 I185 ( .A(POR), .Y(n48) );
  AND2X4 I186 ( .A(n223), .B(n200), .Y(n221) );
  INVX1 I187 ( .A(reset), .Y(n228) );
  INVX2 I188 ( .A(reset), .Y(n226) );
  INVX2 I189 ( .A(reset), .Y(n225) );
  INVX2 I190 ( .A(CKCON_sel), .Y(n28) );
  INVX4 I191 ( .A(n46), .Y(n43) );
  INVX1 I192 ( .A(n34), .Y(n24) );
  INVX1 I193 ( .A(n228), .Y(n227) );
  INVX1 I194 ( .A(SFR_bus[3]), .Y(n35) );
  INVX1 I195 ( .A(SFR_bus[2]), .Y(n23) );
  OAI22X2 I196 ( .A0(CKCON_sel), .A1(n223), .B0(n28), .B1(n210), .Y(
        WDT_SFR_OUT[0]) );
  OAI22X2 I197 ( .A0(CKCON_sel), .A1(n203), .B0(n28), .B1(n209), .Y(
        WDT_SFR_OUT[1]) );
  OAI221X4 I198 ( .A0(n204), .A1(n23), .B0(n24), .B1(n204), .C0(n2), .Y(n1150)
         );
  DFFRX1 wdt_count_reg_1_ ( .D(n77), .CK(clk_b), .RN(n48), .Q(wdt_count[1]), 
        .QN(n156) );
  DFFRX1 EWT_reg ( .D(n64), .CK(clk_b), .RN(n220), .Q(EWT), .QN(n203) );
  NOR2BX1 U130 ( .AN(n1130), .B(reset), .Y(n65) );
  OAI221X4 I199 ( .A0(n34), .A1(n35), .B0(n24), .B1(n212), .C0(n15), .Y(n1130)
         );
  NOR2BX1 U116 ( .AN(n1040), .B(reset), .Y(n51) );
  OAI22X1 I200 ( .A0(n43), .A1(n209), .B0(n42), .B1(n46), .Y(n1040) );
  NOR2BX1 U129 ( .AN(n1110), .B(reset), .Y(n64) );
  OAI22X1 I201 ( .A0(n24), .A1(n203), .B0(n34), .B1(n42), .Y(n1110) );
  NOR2BX1 U115 ( .AN(n1030), .B(reset), .Y(n50) );
  OAI22X1 I202 ( .A0(n43), .A1(n210), .B0(n40), .B1(n46), .Y(n1030) );
  NOR2BX1 U117 ( .AN(n1050), .B(reset), .Y(n52) );
  OAI22X1 I203 ( .A0(n43), .A1(n211), .B0(n23), .B1(n46), .Y(n1050) );
  NOR2BX1 U118 ( .AN(n1060), .B(n227), .Y(n53) );
  OAI22X1 I204 ( .A0(n43), .A1(n205), .B0(n35), .B1(n46), .Y(n1060) );
  NOR2BX1 U121 ( .AN(n1090), .B(reset), .Y(n56) );
  OAI2BB2X1 I205 ( .A0N(SFR_bus[6]), .A1N(n43), .B0(n43), .B1(n206), .Y(n1090)
         );
  NOR2BX1 U122 ( .AN(n1100), .B(n227), .Y(n57) );
  OAI2BB2X1 I206 ( .A0N(SFR_bus[7]), .A1N(n43), .B0(n43), .B1(n201), .Y(n1100)
         );
  OAI22X1 I207 ( .A0(n28), .A1(n205), .B0(CKCON_sel), .B1(n212), .Y(
        WDT_SFR_OUT[3]) );
  OAI22X1 I208 ( .A0(CKCON_sel), .A1(n204), .B0(n28), .B1(n211), .Y(
        WDT_SFR_OUT[2]) );
  DFFRX1 wdt_count_reg_2_ ( .D(n78), .CK(clk_b), .RN(n220), .Q(wdt_count[2]), 
        .QN(n169) );
  DFFRX1 wdt_count_reg_3_ ( .D(n79), .CK(clk_b), .RN(n220), .Q(wdt_count[3]), 
        .QN(n171) );
  DFFRX1 wdt_count_reg_4_ ( .D(n80), .CK(clk_b), .RN(n48), .Q(wdt_count[4]), 
        .QN(n173) );
  DFFRX1 wdt_count_reg_5_ ( .D(n81), .CK(clk_b), .RN(n48), .Q(wdt_count[5]), 
        .QN(n175) );
  DFFRX1 wdt_count_reg_6_ ( .D(n82), .CK(clk_b), .RN(n220), .Q(wdt_count[6]), 
        .QN(n177) );
  DFFRX1 wdt_count_reg_7_ ( .D(n83), .CK(clk_b), .RN(n220), .Q(wdt_count[7]), 
        .QN(n179) );
  DFFRX1 WDIF_reg ( .D(n65), .CK(clk_b), .RN(n220), .Q(wdt_intr), .QN(n212) );
  DFFRX1 CKCON_reg_7_ ( .D(n57), .CK(clk_b), .RN(n220), .Q(CKCON_7_), .QN(n201) );
  AND3X2 U161 ( .A(n158), .B(n225), .C(n219), .Y(n96) );
  OAI2BB2X1 I209 ( .A0N(N121), .A1N(n221), .B0(n213), .B1(n199), .Y(n158) );
  AND3X2 U164 ( .A(n163), .B(n225), .C(n219), .Y(n99) );
  OAI2BB2X1 I210 ( .A0N(N124), .A1N(n221), .B0(n214), .B1(n200), .Y(n163) );
  DFFRX1 wdt_count_reg_8_ ( .D(n84), .CK(clk_b), .RN(n48), .Q(wdt_count[8]), 
        .QN(n181) );
  DFFRX1 wdt_count_reg_9_ ( .D(n85), .CK(clk_b), .RN(n220), .Q(wdt_count[9]), 
        .QN(n183) );
  DFFRX1 wdt_count_reg_10_ ( .D(n86), .CK(clk_b), .RN(n220), .Q(wdt_count[10]), 
        .QN(n1370) );
  DFFRX1 wdt_count_reg_11_ ( .D(n87), .CK(clk_b), .RN(n220), .Q(wdt_count[11]), 
        .QN(n139) );
  DFFRX1 wdt_count_reg_12_ ( .D(n880), .CK(clk_b), .RN(n220), .Q(wdt_count[12]), .QN(n141) );
  DFFRX1 wdt_count_reg_13_ ( .D(n890), .CK(clk_b), .RN(n220), .Q(wdt_count[13]), .QN(n143) );
  DFFRX1 CKCON_reg_6_ ( .D(n56), .CK(clk_b), .RN(n48), .Q(CKCON_6_), .QN(n206)
         );
  AND3X2 U158 ( .A(n151), .B(n225), .C(n219), .Y(n93) );
  OAI2BB2X1 I211 ( .A0N(N118), .A1N(n221), .B0(n207), .B1(n231), .Y(n151) );
  DFFRX1 wdt_count_reg_26_ ( .D(n1020), .CK(clk_b), .RN(n48), .Q(wdt_count[26]), .QN(n202) );
  DFFRX1 count_512_reg_0_ ( .D(n66), .CK(clk_b), .RN(n48), .Q(count_512[0]), 
        .QN(n1160) );
  DFFRX1 count_512_reg_1_ ( .D(n67), .CK(clk_b), .RN(n220), .Q(count_512[1]), 
        .QN(n1180) );
  DFFRX1 count_512_reg_2_ ( .D(n68), .CK(clk_b), .RN(n220), .Q(count_512[2]), 
        .QN(n1200) );
  DFFRX1 wdt_count_reg_14_ ( .D(n900), .CK(clk_b), .RN(n220), .Q(wdt_count[14]), .QN(n145) );
  DFFRX1 wdt_count_reg_15_ ( .D(n910), .CK(clk_b), .RN(n220), .Q(wdt_count[15]), .QN(n147) );
  DFFRX1 wdt_count_reg_18_ ( .D(n94), .CK(clk_b), .RN(n48), .Q(wdt_count[18]), 
        .QN(n152) );
  OR2X2 I212 ( .A(n203), .B(n215), .Y(n2) );
  DFFRX1 count_512_reg_9_ ( .D(n75), .CK(clk_b), .RN(n48), .Q(count_512[9]), 
        .QN(n215) );
  DFFRX1 wdt_rst_cnt_reg_1_ ( .D(n59), .CK(clk_b), .RN(n48), .Q(wdt_rst_cnt[1]) );
  DFFRX1 wdt_rst_cnt_reg_2_ ( .D(n60), .CK(clk_b), .RN(n48), .Q(wdt_rst_cnt[2]) );
  DFFRX1 wdt_rst_cnt_reg_3_ ( .D(n61), .CK(clk_b), .RN(n220), .Q(
        wdt_rst_cnt[3]) );
  DFFRX1 count_512_reg_3_ ( .D(n69), .CK(clk_b), .RN(n220), .Q(count_512[3]), 
        .QN(n1220) );
  DFFRX1 count_512_reg_4_ ( .D(n70), .CK(clk_b), .RN(n220), .Q(count_512[4]), 
        .QN(n1240) );
  DFFRX1 count_512_reg_5_ ( .D(n71), .CK(clk_b), .RN(n48), .Q(count_512[5]), 
        .QN(n1260) );
  DFFRX1 count_512_reg_6_ ( .D(n72), .CK(clk_b), .RN(n220), .Q(count_512[6]), 
        .QN(n1280) );
  DFFRX1 count_512_reg_7_ ( .D(n73), .CK(clk_b), .RN(n48), .Q(count_512[7]), 
        .QN(n1300) );
  DFFRX1 count_512_reg_8_ ( .D(n74), .CK(clk_b), .RN(n220), .Q(count_512[8]), 
        .QN(n1320) );
  DFFRX1 wdt_count_reg_21_ ( .D(n97), .CK(clk_b), .RN(n220), .Q(wdt_count[21]), 
        .QN(n159) );
  DFFRX1 wdt_count_reg_24_ ( .D(n100), .CK(clk_b), .RN(n220), .Q(wdt_count[24]), .QN(n164) );
  DFFRX1 wdt_count_reg_25_ ( .D(n1010), .CK(clk_b), .RN(n220), .Q(
        wdt_count[25]), .QN(n166) );
  INVX1 I213 ( .A(n224), .Y(n230) );
  INVX1 I214 ( .A(n224), .Y(n232) );
  INVX1 I215 ( .A(n224), .Y(n231) );
  AND2X2 U124 ( .A(n219), .B(n187), .Y(n59) );
  OAI2BB1X1 I216 ( .A0N(N89), .A1N(n2), .B0(n3), .Y(n187) );
  AND2X2 U125 ( .A(n219), .B(n189), .Y(n60) );
  OAI2BB1X1 I217 ( .A0N(N90), .A1N(n2), .B0(n3), .Y(n189) );
  AND2X2 U126 ( .A(n219), .B(n191), .Y(n61) );
  OAI2BB1X1 I218 ( .A0N(N91), .A1N(n2), .B0(n3), .Y(n191) );
  NOR2BX1 U120 ( .AN(n1080), .B(n227), .Y(n55) );
  OAI2BB2X1 I219 ( .A0N(SFR_bus[5]), .A1N(n43), .B0(n43), .B1(n217), .Y(n1080)
         );
  AND3X2 U167 ( .A(n168), .B(n225), .C(n219), .Y(n1020) );
  OAI2BB2X1 I220 ( .A0N(N127), .A1N(n221), .B0(n202), .B1(n231), .Y(n168) );
  NOR2BX1 U119 ( .AN(n1070), .B(reset), .Y(n54) );
  OAI2BB2X1 I221 ( .A0N(SFR_bus[4]), .A1N(n43), .B0(n43), .B1(n218), .Y(n1070)
         );
  AND3X2 U162 ( .A(n160), .B(n225), .C(n219), .Y(n97) );
  OAI2BB2X1 I222 ( .A0N(N122), .A1N(n221), .B0(n232), .B1(n159), .Y(n160) );
  AND3X2 U163 ( .A(n162), .B(n226), .C(n223), .Y(n98) );
  OAI2BB2X1 I223 ( .A0N(N123), .A1N(n221), .B0(n232), .B1(n161), .Y(n162) );
  AND3X2 U165 ( .A(n165), .B(n226), .C(n219), .Y(n100) );
  OAI2BB2X1 I224 ( .A0N(N125), .A1N(n221), .B0(n231), .B1(n164), .Y(n165) );
  AND3X2 U166 ( .A(n167), .B(n225), .C(n219), .Y(n1010) );
  OAI2BB2X1 I225 ( .A0N(N126), .A1N(n221), .B0(n230), .B1(n166), .Y(n167) );
  AND2X2 I226 ( .A(T2M), .B(CKCON_sel), .Y(WDT_SFR_OUT[5]) );
  AND2X2 I227 ( .A(T1M), .B(CKCON_sel), .Y(WDT_SFR_OUT[4]) );
  AND2X2 I228 ( .A(CKCON_sel), .B(CKCON_7_), .Y(WDT_SFR_OUT[7]) );
  AND2X2 I229 ( .A(CKCON_sel), .B(CKCON_6_), .Y(WDT_SFR_OUT[6]) );
  AND3X2 U155 ( .A(n146), .B(n228), .C(n219), .Y(n900) );
  OAI2BB2X1 I230 ( .A0N(N115), .A1N(n221), .B0(n232), .B1(n145), .Y(n146) );
  AND3X2 U156 ( .A(n148), .B(n226), .C(n219), .Y(n910) );
  OAI2BB2X1 I231 ( .A0N(N116), .A1N(n221), .B0(n231), .B1(n147), .Y(n148) );
  AND3X2 U157 ( .A(n150), .B(n226), .C(n223), .Y(n920) );
  OAI2BB2X1 I232 ( .A0N(N117), .A1N(n221), .B0(n230), .B1(n149), .Y(n150) );
  AND3X2 U159 ( .A(n153), .B(n228), .C(n219), .Y(n94) );
  OAI2BB2X1 I233 ( .A0N(N119), .A1N(n221), .B0(n230), .B1(n152), .Y(n153) );
  AND3X1 U160 ( .A(n155), .B(n225), .C(n223), .Y(n95) );
  OAI2BB2X1 I234 ( .A0N(N120), .A1N(n221), .B0(n200), .B1(n154), .Y(n155) );
  AND3X1 U131 ( .A(n1170), .B(n225), .C(n219), .Y(n66) );
  OAI2BB2X1 I235 ( .A0N(N128), .A1N(n222), .B0(n229), .B1(n1160), .Y(n1170) );
  AND3X1 U132 ( .A(n1190), .B(n225), .C(n219), .Y(n67) );
  OAI2BB2X1 I236 ( .A0N(N129), .A1N(n222), .B0(n229), .B1(n1180), .Y(n1190) );
  AND3X1 U133 ( .A(n1210), .B(n225), .C(n219), .Y(n68) );
  OAI2BB2X1 I237 ( .A0N(N130), .A1N(n222), .B0(n229), .B1(n1200), .Y(n1210) );
  AND3X1 U134 ( .A(n1230), .B(n226), .C(n219), .Y(n69) );
  OAI2BB2X1 I238 ( .A0N(N131), .A1N(n222), .B0(n229), .B1(n1220), .Y(n1230) );
  AND3X1 U135 ( .A(n1250), .B(n225), .C(n223), .Y(n70) );
  OAI2BB2X1 I239 ( .A0N(N132), .A1N(n222), .B0(n229), .B1(n1240), .Y(n1250) );
  AND3X1 U136 ( .A(n1270), .B(n226), .C(n219), .Y(n71) );
  OAI2BB2X1 I240 ( .A0N(N133), .A1N(n222), .B0(n229), .B1(n1260), .Y(n1270) );
  AND3X1 U137 ( .A(n1290), .B(n225), .C(n219), .Y(n72) );
  OAI2BB2X1 I241 ( .A0N(N134), .A1N(n222), .B0(n229), .B1(n1280), .Y(n1290) );
  AND3X1 U138 ( .A(n1310), .B(n226), .C(n223), .Y(n73) );
  OAI2BB2X1 I242 ( .A0N(N135), .A1N(n222), .B0(n229), .B1(n1300), .Y(n1310) );
  AND3X1 U139 ( .A(n1330), .B(n225), .C(n219), .Y(n74) );
  OAI2BB2X1 I243 ( .A0N(N136), .A1N(n222), .B0(n229), .B1(n1320), .Y(n1330) );
  AND2X2 I244 ( .A(n223), .B(n229), .Y(n222) );
  OR2X2 I245 ( .A(n36), .B(n37), .Y(n21) );
  AND3X1 U140 ( .A(n1340), .B(n226), .C(n223), .Y(n75) );
  OAI2BB2X1 I246 ( .A0N(N137), .A1N(n222), .B0(n215), .B1(n229), .Y(n1340) );
  AND3X1 U141 ( .A(n1360), .B(n225), .C(n223), .Y(n76) );
  OAI2BB2X1 I247 ( .A0N(N101), .A1N(n221), .B0(n199), .B1(n1350), .Y(n1360) );
  AND3X1 U142 ( .A(n157), .B(n226), .C(n219), .Y(n77) );
  OAI2BB2X1 I248 ( .A0N(N102), .A1N(n221), .B0(n232), .B1(n156), .Y(n157) );
  AND3X1 U143 ( .A(n170), .B(n226), .C(n223), .Y(n78) );
  OAI2BB2X1 I249 ( .A0N(N103), .A1N(n221), .B0(n200), .B1(n169), .Y(n170) );
  AND3X1 U144 ( .A(n172), .B(n226), .C(n219), .Y(n79) );
  OAI2BB2X1 I250 ( .A0N(N104), .A1N(n221), .B0(n230), .B1(n171), .Y(n172) );
  AND3X1 U145 ( .A(n174), .B(n228), .C(n223), .Y(n80) );
  OAI2BB2X1 I251 ( .A0N(N105), .A1N(n221), .B0(n200), .B1(n173), .Y(n174) );
  AND3X1 U146 ( .A(n176), .B(n226), .C(n219), .Y(n81) );
  OAI2BB2X1 I252 ( .A0N(N106), .A1N(n221), .B0(n200), .B1(n175), .Y(n176) );
  AND3X1 U147 ( .A(n178), .B(n228), .C(n223), .Y(n82) );
  OAI2BB2X1 I253 ( .A0N(N107), .A1N(n221), .B0(n199), .B1(n177), .Y(n178) );
  AND3X1 U148 ( .A(n180), .B(n226), .C(n223), .Y(n83) );
  OAI2BB2X1 I254 ( .A0N(N108), .A1N(n221), .B0(n200), .B1(n179), .Y(n180) );
  AND3X1 U149 ( .A(n182), .B(n228), .C(n219), .Y(n84) );
  OAI2BB2X1 I255 ( .A0N(N109), .A1N(n221), .B0(n200), .B1(n181), .Y(n182) );
  AND3X1 U150 ( .A(n184), .B(n226), .C(n219), .Y(n85) );
  OAI2BB2X1 I256 ( .A0N(N110), .A1N(n221), .B0(n199), .B1(n183), .Y(n184) );
  AND3X1 U151 ( .A(n138), .B(n225), .C(n223), .Y(n86) );
  OAI2BB2X1 I257 ( .A0N(N111), .A1N(n221), .B0(n199), .B1(n1370), .Y(n138) );
  AND3X1 U152 ( .A(n140), .B(n226), .C(n219), .Y(n87) );
  OAI2BB2X1 I258 ( .A0N(N112), .A1N(n221), .B0(n199), .B1(n139), .Y(n140) );
  AND3X1 U153 ( .A(n142), .B(n225), .C(n219), .Y(n880) );
  OAI2BB2X1 I259 ( .A0N(N113), .A1N(n221), .B0(n199), .B1(n141), .Y(n142) );
  AND3X1 U154 ( .A(n144), .B(n226), .C(n219), .Y(n890) );
  OAI2BB2X1 I260 ( .A0N(N114), .A1N(n221), .B0(n199), .B1(n143), .Y(n144) );
  NAND4X1 I261 ( .A(wdt_rst_cnt[3]), .B(wdt_rst_cnt[4]), .C(wdt_rst_cnt[1]), 
        .D(wdt_rst_cnt[2]), .Y(n6) );
  AND2X1 U127 ( .A(n219), .B(n193), .Y(n62) );
  OAI2BB1X1 I262 ( .A0N(N92), .A1N(n2), .B0(n3), .Y(n193) );
  AND2X1 U123 ( .A(n185), .B(n219), .Y(n58) );
  OAI2BB1X1 I263 ( .A0N(N88), .A1N(n2), .B0(n3), .Y(n185) );
  OAI221X4 I264 ( .A0(n208), .A1(n216), .B0(n26), .B1(n216), .C0(n2), .Y(n1140) );
  INVX1 I265 ( .A(n6), .Y(n26) );
  DFFRX1 CKCON_reg_0_ ( .D(n50), .CK(clk_b), .RN(n220), .QN(n210) );
  DFFRX1 CKCON_reg_1_ ( .D(n51), .CK(clk_b), .RN(n220), .QN(n209) );
  DFFRX1 CKCON_reg_2_ ( .D(n52), .CK(clk_b), .RN(n220), .QN(n211) );
  DFFRX1 WTRF_reg ( .D(n1150), .CK(clk_b), .RN(n220), .QN(n204) );
  DFFRX1 wdt_rst_cnt_reg_4_ ( .D(n62), .CK(clk_b), .RN(n220), .Q(
        wdt_rst_cnt[4]) );
  DFFRX1 WDT_reset_reg ( .D(n1140), .CK(clk_b), .RN(n220), .Q(WDT_reset), .QN(
        n216) );
  DFFHQX1 RWT_D_reg ( .D(RWT), .CK(clk_b), .Q(RWT_D) );
  INVX1 I266 ( .A(SFR_bus[1]), .Y(n42) );
  INVX1 I267 ( .A(SFR_bus[0]), .Y(n40) );
  wdt_DW01_inc_5_0 add_144 ( .A(wdt_rst_cnt), .SUM({N92, N91, N90, N89, N88})
         );
  wdt_DW01_inc_10_0 add_100 ( .A(count_512), .SUM({N137, N136, N135, N134, 
        N133, N132, N131, N130, N129, N128}) );
  wdt_DW01_inc_27_0 add_94 ( .A(wdt_count), .SUM({N127, N126, N125, N124, N123, 
        N122, N121, N120, N119, N118, N117, N116, N115, N114, N113, N112, N111, 
        N110, N109, N108, N107, N106, N105, N104, N103, N102, N101}) );
  DFFRX4 RWT_reg ( .D(n63), .CK(clk_b), .RN(n48), .Q(RWT), .QN(n223) );
endmodule


module wdt_DW01_inc_27_0 ( A, SUM );
  input [26:0] A;
  output [26:0] SUM;
  wire   carry_26_, carry_25_, carry_24_, carry_23_, carry_22_, carry_21_,
         carry_20_, carry_19_, carry_18_, carry_17_, carry_16_, carry_15_,
         carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, carry_9_,
         carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_16 ( .A(A[16]), .B(carry_16_), .S(SUM[16]), .CO(carry_17_) );
  CMPR22X1 U1_1_19 ( .A(A[19]), .B(carry_19_), .S(SUM[19]), .CO(carry_20_) );
  CMPR22X1 U1_1_22 ( .A(A[22]), .B(carry_22_), .S(SUM[22]), .CO(carry_23_) );
  XOR2X1 U5 ( .A(carry_26_), .B(A[26]), .Y(SUM[26]) );
  CMPR22X1 U1_1_17 ( .A(A[17]), .B(carry_17_), .S(SUM[17]), .CO(carry_18_) );
  CMPR22X1 U1_1_20 ( .A(A[20]), .B(carry_20_), .S(SUM[20]), .CO(carry_21_) );
  CMPR22X1 U1_1_23 ( .A(A[23]), .B(carry_23_), .S(SUM[23]), .CO(carry_24_) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  CMPR22X1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  CMPR22X1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  CMPR22X1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  CMPR22X1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  CMPR22X1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  CMPR22X1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  CMPR22X1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(carry_13_) );
  CMPR22X1 U1_1_13 ( .A(A[13]), .B(carry_13_), .S(SUM[13]), .CO(carry_14_) );
  CMPR22X1 U1_1_14 ( .A(A[14]), .B(carry_14_), .S(SUM[14]), .CO(carry_15_) );
  CMPR22X1 U1_1_15 ( .A(A[15]), .B(carry_15_), .S(SUM[15]), .CO(carry_16_) );
  CMPR22X1 U1_1_18 ( .A(A[18]), .B(carry_18_), .S(SUM[18]), .CO(carry_19_) );
  CMPR22X1 U1_1_21 ( .A(A[21]), .B(carry_21_), .S(SUM[21]), .CO(carry_22_) );
  CMPR22X1 U1_1_24 ( .A(A[24]), .B(carry_24_), .S(SUM[24]), .CO(carry_25_) );
  CMPR22X1 U1_1_25 ( .A(A[25]), .B(carry_25_), .S(SUM[25]), .CO(carry_26_) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module wdt_DW01_inc_10_0 ( A, SUM );
  input [9:0] A;
  output [9:0] SUM;
  wire   carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_;

  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  CMPR22X1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  CMPR22X1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  CMPR22X1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  XOR2X1 U6 ( .A(carry_9_), .B(A[9]), .Y(SUM[9]) );
endmodule


module wdt_DW01_inc_5_0 ( A, SUM );
  input [4:0] A;
  output [4:0] SUM;
  wire   carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  XOR2X1 U5 ( .A(carry_4_), .B(A[4]), .Y(SUM[4]) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module pwm_top ( sw_rst, clk_b, SFR_wr, PWM1CON_sel, PWM2CON_sel, PWM1D_sel, 
        PWM2D_sel, SFR_bus, PWM_SFR_OUT, pwm1_out, pwm2_out, PWM1_SEL, 
        PWM2_SEL );
  input [7:0] SFR_bus;
  output [7:0] PWM_SFR_OUT;
  input sw_rst, clk_b, SFR_wr, PWM1CON_sel, PWM2CON_sel, PWM1D_sel, PWM2D_sel;
  output pwm1_out, pwm2_out, PWM1_SEL, PWM2_SEL;
  wire   pwm1_reload, pwm2_reload, pwm1_en, pwm2_en, pwm1_reset, pwm2_reset,
         n1, n2;
  wire   [7:0] PWM1CON;
  wire   [7:0] PWM2CON;
  wire   [7:0] PWM1D;
  wire   [7:0] PWM2D;
  wire   [7:0] pwm1buf;
  wire   [7:0] pwm2buf;
  wire   [7:0] pwm1_cnt;
  wire   [7:0] pwm2_cnt;

  sfr_pwm sfr_pwm ( .PWM1_SEL(PWM1_SEL), .PWM2_SEL(PWM2_SEL), .sw_rst(n1), 
        .clk_b(clk_b), .SFR_wr(SFR_wr), .PWM1CON_sel(PWM1CON_sel), 
        .PWM2CON_sel(PWM2CON_sel), .PWM1D_sel(PWM1D_sel), .PWM2D_sel(PWM2D_sel), .SFR_bus(SFR_bus), .PWM_SFR_OUT(PWM_SFR_OUT), .PWM1CON(PWM1CON), .PWM2CON(
        PWM2CON), .PWM1D(PWM1D), .PWM2D(PWM2D) );
  buf_pwm1 buf_pwm1 ( .sw_rst(n1), .clk_b(clk_b), .pwm1_clear(PWM1CON[1]), 
        .PWM1D(PWM1D), .pwm1_reload(pwm1_reload), .pwm1buf(pwm1buf) );
  buf_pwm2 buf_pwm2 ( .sw_rst(n1), .clk_b(clk_b), .pwm2_clear(PWM2CON[1]), 
        .PWM2D(PWM2D), .pwm2_reload(pwm2_reload), .pwm2buf(pwm2buf) );
  comp_pwm1 comp_pwm1 ( .sw_rst(n1), .clk_b(clk_b), .PWM1CON(PWM1CON), 
        .pwm1buf(pwm1buf), .pwm1_cnt(pwm1_cnt), .pwm1_reset(pwm1_reset), 
        .pwm1_out(pwm1_out) );
  comp_pwm2 comp_pwm2 ( .sw_rst(n1), .clk_b(clk_b), .PWM2CON(PWM2CON), 
        .pwm2buf(pwm2buf), .pwm2_cnt(pwm2_cnt), .pwm2_reset(pwm2_reset), 
        .pwm2_out(pwm2_out) );
  counter_pwm1 counter_pwm1 ( .sw_rst(n1), .clk_b(clk_b), .PWM1CON(PWM1CON), 
        .PWM1D(PWM1D), .pwm1_en(pwm1_en), .pwm1_reload(pwm1_reload), 
        .pwm1_reset(pwm1_reset), .pwm1_cnt(pwm1_cnt) );
  counter_pwm2 counter_pwm2 ( .sw_rst(n1), .clk_b(clk_b), .PWM2CON(PWM2CON), 
        .PWM2D(PWM2D), .pwm2_en(pwm2_en), .pwm2_reload(pwm2_reload), 
        .pwm2_reset(pwm2_reset), .pwm2_cnt(pwm2_cnt) );
  prescale_pwm1 prescale_pwm1 ( .sw_rst(n1), .clk_b(clk_b), .PWM1CON(PWM1CON), 
        .pwm1_en(pwm1_en) );
  prescale_pwm2 prescale_pwm2 ( .sw_rst(n1), .clk_b(clk_b), .PWM2CON(PWM2CON), 
        .pwm2_en(pwm2_en) );
  INVX2 I1 ( .A(n2), .Y(n1) );
  INVX1 I2 ( .A(sw_rst), .Y(n2) );
endmodule


module prescale_pwm2 ( sw_rst, clk_b, PWM2CON, pwm2_en );
  input [7:0] PWM2CON;
  input sw_rst, clk_b;
  output pwm2_en;
  wire   pwm2_clk_en, pwm2_en_reg, pwm2_en_del, N37, N38, N39, N40, N41, N42,
         N43, n2, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18;
  wire   [6:0] pwm2_clk_cnt;

  OAI32X4 U3 ( .A0(n2), .A1(PWM2CON[6]), .A2(PWM2CON[5]), .B0(pwm2_en_del), 
        .B1(n2), .Y(pwm2_en) );
  AOI33X4 U9 ( .A0(pwm2_clk_cnt[0]), .A1(n10), .A2(PWM2CON[4]), .B0(PWM2CON[4]), .B1(pwm2_clk_cnt[2]), .B2(PWM2CON[5]), .Y(n6) );
  AOI33X4 U15 ( .A0(pwm2_clk_cnt[4]), .A1(n10), .A2(PWM2CON[4]), .B0(
        PWM2CON[4]), .B1(pwm2_clk_cnt[6]), .B2(PWM2CON[5]), .Y(n11) );
  NOR2X1 I20 ( .A(PWM2CON[4]), .B(n17), .Y(n13) );
  AOI32X1 I21 ( .A0(pwm2_clk_cnt[1]), .A1(n8), .A2(PWM2CON[5]), .B0(n9), .B1(
        n10), .Y(n7) );
  AOI32X1 I22 ( .A0(pwm2_clk_cnt[5]), .A1(n8), .A2(PWM2CON[5]), .B0(n13), .B1(
        n10), .Y(n12) );
  AND2X2 I23 ( .A(n6), .B(n7), .Y(n5) );
  DFFHQX1 pwm2_clk_en_reg ( .D(PWM2CON[0]), .CK(clk_b), .Q(pwm2_clk_en) );
  DFFTRX1 pwm2_clk_cnt_reg_0_ ( .D(N37), .CK(clk_b), .RN(n14), .Q(
        pwm2_clk_cnt[0]) );
  DFFTRX1 pwm2_clk_cnt_reg_3_ ( .D(N40), .CK(clk_b), .RN(n14), .Q(
        pwm2_clk_cnt[3]), .QN(n17) );
  DFFTRX1 pwm2_clk_cnt_reg_1_ ( .D(N38), .CK(clk_b), .RN(n14), .Q(
        pwm2_clk_cnt[1]) );
  DFFTRX1 pwm2_clk_cnt_reg_2_ ( .D(N39), .CK(clk_b), .RN(n14), .Q(
        pwm2_clk_cnt[2]) );
  DFFTRX1 pwm2_clk_cnt_reg_4_ ( .D(N41), .CK(clk_b), .RN(n14), .Q(
        pwm2_clk_cnt[4]) );
  DFFTRX1 pwm2_clk_cnt_reg_5_ ( .D(N42), .CK(clk_b), .RN(n14), .Q(
        pwm2_clk_cnt[5]) );
  OAI2BB2X1 I24 ( .A0N(n18), .A1N(PWM2CON[6]), .B0(PWM2CON[6]), .B1(n5), .Y(
        pwm2_en_reg) );
  NAND2X1 I25 ( .A(n11), .B(n12), .Y(n18) );
  INVX1 I26 ( .A(pwm2_en_reg), .Y(n2) );
  INVX1 I27 ( .A(PWM2CON[4]), .Y(n8) );
  AND2X2 I28 ( .A(n8), .B(pwm2_clk_en), .Y(n9) );
  INVX1 I29 ( .A(PWM2CON[5]), .Y(n10) );
  INVX1 I30 ( .A(n15), .Y(n14) );
  OR3X1 I31 ( .A(sw_rst), .B(PWM2CON[1]), .C(n16), .Y(n15) );
  INVX1 I32 ( .A(pwm2_clk_en), .Y(n16) );
  DFFTRX1 pwm2_clk_cnt_reg_6_ ( .D(N43), .CK(clk_b), .RN(n14), .Q(
        pwm2_clk_cnt[6]) );
  DFFHQX1 pwm2_en_del_reg ( .D(pwm2_en_reg), .CK(clk_b), .Q(pwm2_en_del) );
  prescale_pwm2_DW01_dec_7_0 sub_125 ( .A(pwm2_clk_cnt), .SUM({N43, N42, N41, 
        N40, N39, N38, N37}) );
endmodule


module prescale_pwm2_DW01_dec_7_0 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;
  wire   carry_5_, carry_4_, carry_3_, carry_2_, n5;

  OR2X2 U1_B_1 ( .A(A[1]), .B(A[0]), .Y(carry_2_) );
  OR2X2 U1_B_2 ( .A(A[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X2 U1_B_3 ( .A(A[3]), .B(carry_3_), .Y(carry_4_) );
  OR2X2 U1_B_4 ( .A(A[4]), .B(carry_4_), .Y(carry_5_) );
  XNOR2X1 U1_A_5 ( .A(A[5]), .B(carry_5_), .Y(SUM[5]) );
  XNOR2X1 U1_A_4 ( .A(A[4]), .B(carry_4_), .Y(SUM[4]) );
  XOR2X1 U6 ( .A(A[6]), .B(n5), .Y(SUM[6]) );
  NOR2X1 U7 ( .A(A[5]), .B(carry_5_), .Y(n5) );
  XNOR2X1 U1_A_1 ( .A(A[1]), .B(A[0]), .Y(SUM[1]) );
  XNOR2X1 U1_A_3 ( .A(A[3]), .B(carry_3_), .Y(SUM[3]) );
  XNOR2X1 U1_A_2 ( .A(A[2]), .B(carry_2_), .Y(SUM[2]) );
  INVX1 U8 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module prescale_pwm1 ( sw_rst, clk_b, PWM1CON, pwm1_en );
  input [7:0] PWM1CON;
  input sw_rst, clk_b;
  output pwm1_en;
  wire   pwm1_clk_en, pwm1_en_reg, pwm1_en_del, N37, N38, N39, N40, N41, N42,
         N43, n2, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18;
  wire   [6:0] pwm1_clk_cnt;

  OAI32X4 U3 ( .A0(n2), .A1(PWM1CON[6]), .A2(PWM1CON[5]), .B0(pwm1_en_del), 
        .B1(n2), .Y(pwm1_en) );
  AOI33X4 U9 ( .A0(pwm1_clk_cnt[0]), .A1(n10), .A2(PWM1CON[4]), .B0(PWM1CON[4]), .B1(pwm1_clk_cnt[2]), .B2(PWM1CON[5]), .Y(n6) );
  AOI33X4 U15 ( .A0(pwm1_clk_cnt[4]), .A1(n10), .A2(PWM1CON[4]), .B0(
        PWM1CON[4]), .B1(pwm1_clk_cnt[6]), .B2(PWM1CON[5]), .Y(n11) );
  NOR2X1 I20 ( .A(PWM1CON[4]), .B(n17), .Y(n13) );
  AOI32X1 I21 ( .A0(pwm1_clk_cnt[1]), .A1(n8), .A2(PWM1CON[5]), .B0(n9), .B1(
        n10), .Y(n7) );
  AOI32X1 I22 ( .A0(pwm1_clk_cnt[5]), .A1(n8), .A2(PWM1CON[5]), .B0(n13), .B1(
        n10), .Y(n12) );
  AND2X2 I23 ( .A(n6), .B(n7), .Y(n5) );
  DFFHQX1 pwm1_clk_en_reg ( .D(PWM1CON[0]), .CK(clk_b), .Q(pwm1_clk_en) );
  DFFTRX1 pwm1_clk_cnt_reg_0_ ( .D(N37), .CK(clk_b), .RN(n14), .Q(
        pwm1_clk_cnt[0]) );
  DFFTRX1 pwm1_clk_cnt_reg_3_ ( .D(N40), .CK(clk_b), .RN(n14), .Q(
        pwm1_clk_cnt[3]), .QN(n17) );
  DFFTRX1 pwm1_clk_cnt_reg_1_ ( .D(N38), .CK(clk_b), .RN(n14), .Q(
        pwm1_clk_cnt[1]) );
  DFFTRX1 pwm1_clk_cnt_reg_2_ ( .D(N39), .CK(clk_b), .RN(n14), .Q(
        pwm1_clk_cnt[2]) );
  DFFTRX1 pwm1_clk_cnt_reg_4_ ( .D(N41), .CK(clk_b), .RN(n14), .Q(
        pwm1_clk_cnt[4]) );
  DFFTRX1 pwm1_clk_cnt_reg_5_ ( .D(N42), .CK(clk_b), .RN(n14), .Q(
        pwm1_clk_cnt[5]) );
  OAI2BB2X1 I24 ( .A0N(n18), .A1N(PWM1CON[6]), .B0(PWM1CON[6]), .B1(n5), .Y(
        pwm1_en_reg) );
  NAND2X1 I25 ( .A(n11), .B(n12), .Y(n18) );
  INVX1 I26 ( .A(pwm1_en_reg), .Y(n2) );
  INVX1 I27 ( .A(PWM1CON[4]), .Y(n8) );
  AND2X2 I28 ( .A(n8), .B(pwm1_clk_en), .Y(n9) );
  INVX1 I29 ( .A(PWM1CON[5]), .Y(n10) );
  INVX1 I30 ( .A(n15), .Y(n14) );
  OR3X1 I31 ( .A(sw_rst), .B(PWM1CON[1]), .C(n16), .Y(n15) );
  INVX1 I32 ( .A(pwm1_clk_en), .Y(n16) );
  DFFTRX1 pwm1_clk_cnt_reg_6_ ( .D(N43), .CK(clk_b), .RN(n14), .Q(
        pwm1_clk_cnt[6]) );
  DFFHQX1 pwm1_en_del_reg ( .D(pwm1_en_reg), .CK(clk_b), .Q(pwm1_en_del) );
  prescale_pwm1_DW01_dec_7_0 sub_65 ( .A(pwm1_clk_cnt), .SUM({N43, N42, N41, 
        N40, N39, N38, N37}) );
endmodule


module prescale_pwm1_DW01_dec_7_0 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;
  wire   carry_5_, carry_4_, carry_3_, carry_2_, n5;

  OR2X2 U1_B_1 ( .A(A[1]), .B(A[0]), .Y(carry_2_) );
  OR2X2 U1_B_2 ( .A(A[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X2 U1_B_3 ( .A(A[3]), .B(carry_3_), .Y(carry_4_) );
  OR2X2 U1_B_4 ( .A(A[4]), .B(carry_4_), .Y(carry_5_) );
  XNOR2X1 U1_A_5 ( .A(A[5]), .B(carry_5_), .Y(SUM[5]) );
  XNOR2X1 U1_A_4 ( .A(A[4]), .B(carry_4_), .Y(SUM[4]) );
  XOR2X1 U6 ( .A(A[6]), .B(n5), .Y(SUM[6]) );
  NOR2X1 U7 ( .A(A[5]), .B(carry_5_), .Y(n5) );
  XNOR2X1 U1_A_1 ( .A(A[1]), .B(A[0]), .Y(SUM[1]) );
  XNOR2X1 U1_A_3 ( .A(A[3]), .B(carry_3_), .Y(SUM[3]) );
  XNOR2X1 U1_A_2 ( .A(A[2]), .B(carry_2_), .Y(SUM[2]) );
  INVX1 U8 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module counter_pwm2 ( sw_rst, clk_b, PWM2CON, PWM2D, pwm2_en, pwm2_reload, 
        pwm2_reset, pwm2_cnt, pwm2_intr );
  input [7:0] PWM2CON;
  input [7:0] PWM2D;
  output [7:0] pwm2_cnt;
  input sw_rst, clk_b, pwm2_en;
  output pwm2_reload, pwm2_reset, pwm2_intr;
  wire   pwm2_reload_tmp, pwm2_reload_dly, N16, N17, N18, N19, N20, N21, N22,
         N23, N26, N27, N28, N29, N30, N31, N32, N33, N34, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n13, n14, n15, n160, n170, n180, n190;

  EDFFX4 pwm2_cnt_reg_6_ ( .D(N22), .CK(clk_b), .E(N26), .Q(pwm2_cnt[6]), .QN(
        n15) );
  AOI211X4 U4 ( .A0(PWM2CON[3]), .A1(n3), .B0(n4), .C0(n5), .Y(pwm2_reset) );
  AOI221X4 U6 ( .A0(PWM2D[6]), .A1(PWM2CON[3]), .B0(PWM2D[7]), .B1(PWM2CON[3]), 
        .C0(n7), .Y(n6) );
  OAI33X4 U14 ( .A0(n5), .A1(pwm2_cnt[7]), .A2(pwm2_cnt[6]), .B0(n5), .B1(
        PWM2CON[3]), .B2(PWM2CON[2]), .Y(pwm2_reload_tmp) );
  NAND2X1 I28 ( .A(n14), .B(n15), .Y(n3) );
  NAND3X1 I29 ( .A(n160), .B(n170), .C(n180), .Y(n13) );
  EDFFX1 pwm2_cnt_reg_5_ ( .D(N21), .CK(clk_b), .E(N26), .Q(pwm2_cnt[5]), .QN(
        n160) );
  EDFFX1 pwm2_cnt_reg_4_ ( .D(N20), .CK(clk_b), .E(N26), .Q(pwm2_cnt[4]), .QN(
        n170) );
  EDFFX1 pwm2_cnt_reg_3_ ( .D(N19), .CK(clk_b), .E(N26), .Q(pwm2_cnt[3]), .QN(
        n180) );
  NOR2X1 I30 ( .A(n190), .B(n11), .Y(pwm2_intr) );
  INVX1 I31 ( .A(n11), .Y(pwm2_reload) );
  OR2X2 I32 ( .A(pwm2_en), .B(n10), .Y(N26) );
  EDFFX2 pwm2_cnt_reg_7_ ( .D(N23), .CK(clk_b), .E(N26), .Q(pwm2_cnt[7]), .QN(
        n14) );
  EDFFX2 pwm2_cnt_reg_2_ ( .D(N18), .CK(clk_b), .E(N26), .Q(pwm2_cnt[2]) );
  EDFFX2 pwm2_cnt_reg_1_ ( .D(N17), .CK(clk_b), .E(N26), .Q(pwm2_cnt[1]) );
  EDFFX2 pwm2_cnt_reg_0_ ( .D(N16), .CK(clk_b), .E(N26), .Q(pwm2_cnt[0]) );
  NAND2BX1 I33 ( .AN(pwm2_reload_dly), .B(pwm2_reload_tmp), .Y(n11) );
  INVX2 I34 ( .A(n10), .Y(n9) );
  OAI2BB1X1 I35 ( .A0N(N33), .A1N(pwm2_en), .B0(n9), .Y(N22) );
  OAI2BB1X1 I36 ( .A0N(N32), .A1N(pwm2_en), .B0(n9), .Y(N21) );
  OAI2BB1X1 I37 ( .A0N(N31), .A1N(pwm2_en), .B0(n9), .Y(N20) );
  OAI2BB1X1 I38 ( .A0N(N30), .A1N(pwm2_en), .B0(n9), .Y(N19) );
  OAI2BB1X1 I39 ( .A0N(N29), .A1N(pwm2_en), .B0(n9), .Y(N18) );
  OAI2BB1X1 I40 ( .A0N(N28), .A1N(pwm2_en), .B0(n9), .Y(N17) );
  EDFFTRX1 pwm2_intr_rdy_reg ( .D(1'b1), .CK(clk_b), .E(pwm2_reload), .RN(n9), 
        .QN(n190) );
  OR2X2 I41 ( .A(pwm2_reload_dly), .B(n6), .Y(n4) );
  OR4X2 I42 ( .A(pwm2_cnt[2]), .B(pwm2_cnt[1]), .C(pwm2_cnt[0]), .D(n13), .Y(
        n5) );
  OR3X2 I43 ( .A(PWM2D[1]), .B(PWM2D[0]), .C(n8), .Y(n7) );
  OR4X2 I44 ( .A(PWM2D[3]), .B(PWM2D[2]), .C(PWM2D[5]), .D(PWM2D[4]), .Y(n8)
         );
  OR2X2 I45 ( .A(PWM2CON[1]), .B(sw_rst), .Y(n10) );
  OAI2BB1X1 I46 ( .A0N(N34), .A1N(pwm2_en), .B0(n9), .Y(N23) );
  OAI2BB1X1 I47 ( .A0N(N27), .A1N(pwm2_en), .B0(n9), .Y(N16) );
  DFFHQX1 pwm2_reload_dly_reg ( .D(pwm2_reload_tmp), .CK(clk_b), .Q(
        pwm2_reload_dly) );
  counter_pwm2_DW01_inc_8_0 add_156 ( .A(pwm2_cnt), .SUM({N34, N33, N32, N31, 
        N30, N29, N28, N27}) );
endmodule


module counter_pwm2_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  XOR2X1 U5 ( .A(carry_7_), .B(A[7]), .Y(SUM[7]) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module counter_pwm1 ( sw_rst, clk_b, PWM1CON, PWM1D, pwm1_en, pwm1_reload, 
        pwm1_reset, pwm1_cnt, pwm1_intr );
  input [7:0] PWM1CON;
  input [7:0] PWM1D;
  output [7:0] pwm1_cnt;
  input sw_rst, clk_b, pwm1_en;
  output pwm1_reload, pwm1_reset, pwm1_intr;
  wire   pwm1_reload_tmp, pwm1_reload_dly, N16, N17, N18, N19, N20, N21, N22,
         N23, N26, N27, N28, N29, N30, N31, N32, N33, N34, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n13, n14, n15, n160, n170, n180, n190;

  EDFFX4 pwm1_cnt_reg_6_ ( .D(N22), .CK(clk_b), .E(N26), .Q(pwm1_cnt[6]), .QN(
        n15) );
  AOI211X4 U4 ( .A0(PWM1CON[3]), .A1(n3), .B0(n4), .C0(n5), .Y(pwm1_reset) );
  AOI221X4 U6 ( .A0(PWM1D[6]), .A1(PWM1CON[3]), .B0(PWM1D[7]), .B1(PWM1CON[3]), 
        .C0(n7), .Y(n6) );
  OAI33X4 U14 ( .A0(n5), .A1(pwm1_cnt[7]), .A2(pwm1_cnt[6]), .B0(n5), .B1(
        PWM1CON[3]), .B2(PWM1CON[2]), .Y(pwm1_reload_tmp) );
  NAND2X1 I28 ( .A(n14), .B(n15), .Y(n3) );
  NAND3X1 I29 ( .A(n160), .B(n170), .C(n180), .Y(n13) );
  EDFFX1 pwm1_cnt_reg_5_ ( .D(N21), .CK(clk_b), .E(N26), .Q(pwm1_cnt[5]), .QN(
        n160) );
  EDFFX1 pwm1_cnt_reg_4_ ( .D(N20), .CK(clk_b), .E(N26), .Q(pwm1_cnt[4]), .QN(
        n170) );
  EDFFX1 pwm1_cnt_reg_3_ ( .D(N19), .CK(clk_b), .E(N26), .Q(pwm1_cnt[3]), .QN(
        n180) );
  NOR2X1 I30 ( .A(n190), .B(n11), .Y(pwm1_intr) );
  INVX1 I31 ( .A(n11), .Y(pwm1_reload) );
  OR2X2 I32 ( .A(pwm1_en), .B(n10), .Y(N26) );
  EDFFX2 pwm1_cnt_reg_7_ ( .D(N23), .CK(clk_b), .E(N26), .Q(pwm1_cnt[7]), .QN(
        n14) );
  EDFFX2 pwm1_cnt_reg_2_ ( .D(N18), .CK(clk_b), .E(N26), .Q(pwm1_cnt[2]) );
  EDFFX2 pwm1_cnt_reg_1_ ( .D(N17), .CK(clk_b), .E(N26), .Q(pwm1_cnt[1]) );
  EDFFX2 pwm1_cnt_reg_0_ ( .D(N16), .CK(clk_b), .E(N26), .Q(pwm1_cnt[0]) );
  NAND2BX1 I33 ( .AN(pwm1_reload_dly), .B(pwm1_reload_tmp), .Y(n11) );
  INVX2 I34 ( .A(n10), .Y(n9) );
  OAI2BB1X1 I35 ( .A0N(N33), .A1N(pwm1_en), .B0(n9), .Y(N22) );
  OAI2BB1X1 I36 ( .A0N(N32), .A1N(pwm1_en), .B0(n9), .Y(N21) );
  OAI2BB1X1 I37 ( .A0N(N31), .A1N(pwm1_en), .B0(n9), .Y(N20) );
  OAI2BB1X1 I38 ( .A0N(N30), .A1N(pwm1_en), .B0(n9), .Y(N19) );
  OAI2BB1X1 I39 ( .A0N(N29), .A1N(pwm1_en), .B0(n9), .Y(N18) );
  OAI2BB1X1 I40 ( .A0N(N28), .A1N(pwm1_en), .B0(n9), .Y(N17) );
  EDFFTRX1 pwm1_intr_rdy_reg ( .D(1'b1), .CK(clk_b), .E(pwm1_reload), .RN(n9), 
        .QN(n190) );
  OR2X2 I41 ( .A(pwm1_reload_dly), .B(n6), .Y(n4) );
  OR4X2 I42 ( .A(pwm1_cnt[2]), .B(pwm1_cnt[1]), .C(pwm1_cnt[0]), .D(n13), .Y(
        n5) );
  OR3X2 I43 ( .A(PWM1D[1]), .B(PWM1D[0]), .C(n8), .Y(n7) );
  OR4X2 I44 ( .A(PWM1D[3]), .B(PWM1D[2]), .C(PWM1D[5]), .D(PWM1D[4]), .Y(n8)
         );
  OR2X2 I45 ( .A(PWM1CON[1]), .B(sw_rst), .Y(n10) );
  OAI2BB1X1 I46 ( .A0N(N34), .A1N(pwm1_en), .B0(n9), .Y(N23) );
  OAI2BB1X1 I47 ( .A0N(N27), .A1N(pwm1_en), .B0(n9), .Y(N16) );
  DFFHQX1 pwm1_reload_dly_reg ( .D(pwm1_reload_tmp), .CK(clk_b), .Q(
        pwm1_reload_dly) );
  counter_pwm1_DW01_inc_8_0 add_86 ( .A(pwm1_cnt), .SUM({N34, N33, N32, N31, 
        N30, N29, N28, N27}) );
endmodule


module counter_pwm1_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  XOR2X1 U5 ( .A(carry_7_), .B(A[7]), .Y(SUM[7]) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module comp_pwm2 ( sw_rst, clk_b, PWM2CON, pwm2buf, pwm2_cnt, pwm2_reset, 
        pwm2_out );
  input [7:0] PWM2CON;
  input [7:0] pwm2buf;
  input [7:0] pwm2_cnt;
  input sw_rst, clk_b, pwm2_reset;
  output pwm2_out;
  wire   N40, pwm2_ext, pwm2_out_ext, N78, N79, N80, N110, N111, N113, N114,
         N115, N116, N117, N118, N119, N137, n2, n3, n4, n5, n6, n7, n8, n9,
         n10, n11, n12, n13, n15, n16, n17, n18, n19, n20, n21, n22, n23, n26,
         n27, n28, n29, n30, n31, n32, n33, n34, n38, n39, n400, n41, n42, n43,
         n44, n46, n47, n48, n49, n50, n51, n53, n54, n55, n56, n57, n58;
  wire   [6:0] pwm2_out_cnt;

  OAI33X4 U14 ( .A0(n18), .A1(PWM2CON[5]), .A2(n15), .B0(n19), .B1(PWM2CON[6]), 
        .B2(n20), .Y(n8) );
  OAI33X4 U17 ( .A0(n23), .A1(pwm2_out_cnt[2]), .A2(PWM2CON[4]), .B0(
        PWM2CON[5]), .B1(pwm2_out_cnt[2]), .B2(pwm2_out_cnt[1]), .Y(n22) );
  OAI33X4 U42 ( .A0(n46), .A1(n47), .A2(n29), .B0(n48), .B1(n42), .B2(n29), 
        .Y(N111) );
  AOI221X4 U45 ( .A0(n51), .A1(n44), .B0(n47), .B1(n49), .C0(n29), .Y(n50) );
  NOR2X1 I54 ( .A(n53), .B(n23), .Y(n21) );
  NAND2X1 I55 ( .A(n27), .B(n54), .Y(n20) );
  NAND3BX1 I56 ( .AN(n23), .B(pwm2_out_cnt[2]), .C(pwm2_out_cnt[3]), .Y(n15)
         );
  DFFTRX1 pwm2_out_cnt_reg_1_ ( .D(N114), .CK(clk_b), .RN(n56), .Q(
        pwm2_out_cnt[1]), .QN(n23) );
  NOR3BX1 I57 ( .AN(n16), .B(n28), .C(n27), .Y(n10) );
  NOR3X1 I58 ( .A(pwm2_out_cnt[5]), .B(pwm2_out_cnt[6]), .C(n55), .Y(n7) );
  DFFTRX1 pwm2_out_cnt_reg_4_ ( .D(N117), .CK(clk_b), .RN(n56), .Q(
        pwm2_out_cnt[4]), .QN(n27) );
  NOR2X1 I59 ( .A(n2), .B(n29), .Y(N80) );
  AOI32X1 I60 ( .A0(PWM2CON[6]), .A1(pwm2_out_cnt[4]), .A2(PWM2CON[4]), .B0(
        n26), .B1(n27), .Y(n18) );
  OR2X2 I61 ( .A(sw_rst), .B(PWM2CON[1]), .Y(n29) );
  DFFTRX1 pwm2_out_cnt_reg_5_ ( .D(N118), .CK(clk_b), .RN(n56), .Q(
        pwm2_out_cnt[5]), .QN(n28) );
  DFFTRX1 pwm2_out_cnt_reg_3_ ( .D(N116), .CK(clk_b), .RN(n56), .Q(
        pwm2_out_cnt[3]), .QN(n54) );
  DFFTRX2 pwm2_out_cnt_reg_2_ ( .D(N115), .CK(clk_b), .RN(n56), .Q(
        pwm2_out_cnt[2]), .QN(n53) );
  DFFTRX1 pwm2_out_cnt_reg_0_ ( .D(N113), .CK(clk_b), .RN(n56), .Q(
        pwm2_out_cnt[0]), .QN(n55) );
  NOR2X2 I62 ( .A(N78), .B(n29), .Y(n56) );
  OR3X2 I63 ( .A(pwm2_reset), .B(n29), .C(n4), .Y(N137) );
  DFFTRX1 pwm2_out_cnt_reg_6_ ( .D(N119), .CK(clk_b), .RN(n56), .Q(
        pwm2_out_cnt[6]), .QN(n17) );
  INVX1 I64 ( .A(n29), .Y(n6) );
  AND2X2 I65 ( .A(pwm2_reset), .B(n6), .Y(N40) );
  INVX1 I66 ( .A(n15), .Y(n12) );
  OAI2BB1X1 I67 ( .A0N(n7), .A1N(n8), .B0(n9), .Y(N79) );
  AOI31X1 I68 ( .A0(n10), .A1(n11), .A2(n12), .B0(n13), .Y(n9) );
  NOR3X1 I69 ( .A(n57), .B(n58), .C(pwm2_reset), .Y(n34) );
  XOR2X1 I70 ( .A(pwm2buf[1]), .B(pwm2_cnt[1]), .Y(n57) );
  XOR2X1 I71 ( .A(pwm2buf[0]), .B(pwm2_cnt[0]), .Y(n58) );
  OAI31X1 I72 ( .A0(PWM2CON[4]), .A1(PWM2CON[6]), .A2(PWM2CON[5]), .B0(n56), 
        .Y(n13) );
  INVX1 I73 ( .A(n30), .Y(n4) );
  OAI211X1 I74 ( .A0(n31), .A1(n32), .B0(n33), .C0(n34), .Y(n30) );
  AND4X2 I75 ( .A(n38), .B(n39), .C(n400), .D(n41), .Y(n33) );
  AND3X2 I76 ( .A(pwm2buf[6]), .B(pwm2_cnt[6]), .C(n44), .Y(n31) );
  XNOR2X1 I77 ( .A(pwm2_cnt[7]), .B(pwm2buf[7]), .Y(n44) );
  INVX1 I78 ( .A(pwm2_cnt[5]), .Y(n42) );
  OR3X2 I79 ( .A(pwm2_cnt[7]), .B(pwm2_cnt[6]), .C(n42), .Y(n46) );
  XNOR2X1 I80 ( .A(pwm2buf[2]), .B(pwm2_cnt[2]), .Y(n41) );
  XNOR2X1 I81 ( .A(pwm2buf[3]), .B(pwm2_cnt[3]), .Y(n400) );
  XNOR2X1 I82 ( .A(pwm2buf[4]), .B(pwm2_cnt[4]), .Y(n39) );
  OR3X2 I83 ( .A(pwm2buf[6]), .B(pwm2_cnt[6]), .C(n49), .Y(n48) );
  AOI31X1 I84 ( .A0(PWM2CON[5]), .A1(PWM2CON[4]), .A2(n21), .B0(n22), .Y(n19)
         );
  OAI211X1 I85 ( .A0(pwm2buf[6]), .A1(n42), .B0(n46), .C0(n50), .Y(N110) );
  AND2X2 I86 ( .A(pwm2_cnt[5]), .B(pwm2_cnt[6]), .Y(n51) );
  XOR2X1 I87 ( .A(n42), .B(pwm2buf[5]), .Y(n38) );
  AND3X2 I88 ( .A(pwm2_out_cnt[0]), .B(PWM2CON[6]), .C(PWM2CON[5]), .Y(n11) );
  XOR2X1 I89 ( .A(n17), .B(PWM2CON[4]), .Y(n16) );
  OAI31X1 I90 ( .A0(n43), .A1(pwm2buf[6]), .A2(pwm2_cnt[6]), .B0(PWM2CON[3]), 
        .Y(n32) );
  INVX1 I91 ( .A(n44), .Y(n43) );
  INVX1 I92 ( .A(PWM2CON[4]), .Y(n26) );
  INVX1 I93 ( .A(pwm2buf[7]), .Y(n49) );
  INVX1 I94 ( .A(pwm2buf[6]), .Y(n47) );
  NAND2X1 I95 ( .A(n2), .B(n3), .Y(pwm2_out) );
  OAI211X1 I96 ( .A0(n4), .A1(pwm2_out_ext), .B0(pwm2_ext), .C0(n5), .Y(n3) );
  INVX1 I97 ( .A(PWM2CON[3]), .Y(n5) );
  EDFFX1 pwm2_out_reg_reg ( .D(N40), .CK(clk_b), .E(N137), .Q(N78), .QN(n2) );
  EDFFX1 pwm2_ext_reg ( .D(N111), .CK(clk_b), .E(N110), .Q(pwm2_ext) );
  EDFFX1 pwm2_out_ext_reg ( .D(N80), .CK(clk_b), .E(N79), .Q(pwm2_out_ext) );
  comp_pwm2_DW01_inc_7_0 add_205 ( .A(pwm2_out_cnt), .SUM({N119, N118, N117, 
        N116, N115, N114, N113}) );
endmodule


module comp_pwm2_DW01_inc_7_0 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;
  wire   carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  XOR2X1 U5 ( .A(carry_6_), .B(A[6]), .Y(SUM[6]) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module comp_pwm1 ( sw_rst, clk_b, PWM1CON, pwm1buf, pwm1_cnt, pwm1_reset, 
        pwm1_out );
  input [7:0] PWM1CON;
  input [7:0] pwm1buf;
  input [7:0] pwm1_cnt;
  input sw_rst, clk_b, pwm1_reset;
  output pwm1_out;
  wire   N40, pwm1_ext, pwm1_out_ext, N78, N79, N80, N110, N111, N113, N114,
         N115, N116, N117, N118, N119, N137, n2, n3, n4, n5, n6, n7, n8, n9,
         n10, n11, n12, n13, n15, n16, n17, n18, n19, n20, n21, n22, n23, n26,
         n27, n28, n29, n30, n31, n32, n33, n34, n38, n39, n400, n41, n42, n43,
         n44, n46, n47, n48, n49, n50, n51, n53, n54, n55, n56, n57, n58;
  wire   [6:0] pwm1_out_cnt;

  OAI33X4 U14 ( .A0(n18), .A1(PWM1CON[5]), .A2(n15), .B0(n19), .B1(PWM1CON[6]), 
        .B2(n20), .Y(n8) );
  OAI33X4 U17 ( .A0(n23), .A1(pwm1_out_cnt[2]), .A2(PWM1CON[4]), .B0(
        PWM1CON[5]), .B1(pwm1_out_cnt[2]), .B2(pwm1_out_cnt[1]), .Y(n22) );
  OAI33X4 U42 ( .A0(n46), .A1(n47), .A2(n29), .B0(n48), .B1(n42), .B2(n29), 
        .Y(N111) );
  AOI221X4 U45 ( .A0(n51), .A1(n44), .B0(n47), .B1(n49), .C0(n29), .Y(n50) );
  NOR2X1 I54 ( .A(n53), .B(n23), .Y(n21) );
  NAND2X1 I55 ( .A(n27), .B(n54), .Y(n20) );
  NAND3BX1 I56 ( .AN(n23), .B(pwm1_out_cnt[2]), .C(pwm1_out_cnt[3]), .Y(n15)
         );
  DFFTRX1 pwm1_out_cnt_reg_1_ ( .D(N114), .CK(clk_b), .RN(n56), .Q(
        pwm1_out_cnt[1]), .QN(n23) );
  NOR3BX1 I57 ( .AN(n16), .B(n28), .C(n27), .Y(n10) );
  NOR3X1 I58 ( .A(pwm1_out_cnt[5]), .B(pwm1_out_cnt[6]), .C(n55), .Y(n7) );
  DFFTRX1 pwm1_out_cnt_reg_4_ ( .D(N117), .CK(clk_b), .RN(n56), .Q(
        pwm1_out_cnt[4]), .QN(n27) );
  NOR2X1 I59 ( .A(n2), .B(n29), .Y(N80) );
  AOI32X1 I60 ( .A0(PWM1CON[6]), .A1(pwm1_out_cnt[4]), .A2(PWM1CON[4]), .B0(
        n26), .B1(n27), .Y(n18) );
  OR2X2 I61 ( .A(sw_rst), .B(PWM1CON[1]), .Y(n29) );
  DFFTRX1 pwm1_out_cnt_reg_5_ ( .D(N118), .CK(clk_b), .RN(n56), .Q(
        pwm1_out_cnt[5]), .QN(n28) );
  DFFTRX1 pwm1_out_cnt_reg_3_ ( .D(N116), .CK(clk_b), .RN(n56), .Q(
        pwm1_out_cnt[3]), .QN(n54) );
  DFFTRX2 pwm1_out_cnt_reg_2_ ( .D(N115), .CK(clk_b), .RN(n56), .Q(
        pwm1_out_cnt[2]), .QN(n53) );
  DFFTRX1 pwm1_out_cnt_reg_0_ ( .D(N113), .CK(clk_b), .RN(n56), .Q(
        pwm1_out_cnt[0]), .QN(n55) );
  NOR2X2 I62 ( .A(N78), .B(n29), .Y(n56) );
  OR3X2 I63 ( .A(pwm1_reset), .B(n29), .C(n4), .Y(N137) );
  DFFTRX1 pwm1_out_cnt_reg_6_ ( .D(N119), .CK(clk_b), .RN(n56), .Q(
        pwm1_out_cnt[6]), .QN(n17) );
  INVX1 I64 ( .A(n29), .Y(n6) );
  AND2X2 I65 ( .A(pwm1_reset), .B(n6), .Y(N40) );
  INVX1 I66 ( .A(n15), .Y(n12) );
  OAI2BB1X1 I67 ( .A0N(n7), .A1N(n8), .B0(n9), .Y(N79) );
  AOI31X1 I68 ( .A0(n10), .A1(n11), .A2(n12), .B0(n13), .Y(n9) );
  NOR3X1 I69 ( .A(n57), .B(n58), .C(pwm1_reset), .Y(n34) );
  XOR2X1 I70 ( .A(pwm1buf[1]), .B(pwm1_cnt[1]), .Y(n57) );
  XOR2X1 I71 ( .A(pwm1buf[0]), .B(pwm1_cnt[0]), .Y(n58) );
  OAI31X1 I72 ( .A0(PWM1CON[4]), .A1(PWM1CON[6]), .A2(PWM1CON[5]), .B0(n56), 
        .Y(n13) );
  INVX1 I73 ( .A(n30), .Y(n4) );
  OAI211X1 I74 ( .A0(n31), .A1(n32), .B0(n33), .C0(n34), .Y(n30) );
  AND4X2 I75 ( .A(n38), .B(n39), .C(n400), .D(n41), .Y(n33) );
  AND3X2 I76 ( .A(pwm1buf[6]), .B(pwm1_cnt[6]), .C(n44), .Y(n31) );
  XNOR2X1 I77 ( .A(pwm1_cnt[7]), .B(pwm1buf[7]), .Y(n44) );
  INVX1 I78 ( .A(pwm1_cnt[5]), .Y(n42) );
  OR3X2 I79 ( .A(pwm1_cnt[7]), .B(pwm1_cnt[6]), .C(n42), .Y(n46) );
  XNOR2X1 I80 ( .A(pwm1buf[2]), .B(pwm1_cnt[2]), .Y(n41) );
  XNOR2X1 I81 ( .A(pwm1buf[3]), .B(pwm1_cnt[3]), .Y(n400) );
  XNOR2X1 I82 ( .A(pwm1buf[4]), .B(pwm1_cnt[4]), .Y(n39) );
  OR3X2 I83 ( .A(pwm1buf[6]), .B(pwm1_cnt[6]), .C(n49), .Y(n48) );
  AOI31X1 I84 ( .A0(PWM1CON[5]), .A1(PWM1CON[4]), .A2(n21), .B0(n22), .Y(n19)
         );
  OAI211X1 I85 ( .A0(pwm1buf[6]), .A1(n42), .B0(n46), .C0(n50), .Y(N110) );
  AND2X2 I86 ( .A(pwm1_cnt[5]), .B(pwm1_cnt[6]), .Y(n51) );
  XOR2X1 I87 ( .A(n42), .B(pwm1buf[5]), .Y(n38) );
  AND3X2 I88 ( .A(pwm1_out_cnt[0]), .B(PWM1CON[6]), .C(PWM1CON[5]), .Y(n11) );
  XOR2X1 I89 ( .A(n17), .B(PWM1CON[4]), .Y(n16) );
  OAI31X1 I90 ( .A0(n43), .A1(pwm1buf[6]), .A2(pwm1_cnt[6]), .B0(PWM1CON[3]), 
        .Y(n32) );
  INVX1 I91 ( .A(n44), .Y(n43) );
  INVX1 I92 ( .A(PWM1CON[4]), .Y(n26) );
  INVX1 I93 ( .A(pwm1buf[7]), .Y(n49) );
  INVX1 I94 ( .A(pwm1buf[6]), .Y(n47) );
  NAND2X1 I95 ( .A(n2), .B(n3), .Y(pwm1_out) );
  OAI211X1 I96 ( .A0(n4), .A1(pwm1_out_ext), .B0(pwm1_ext), .C0(n5), .Y(n3) );
  INVX1 I97 ( .A(PWM1CON[3]), .Y(n5) );
  EDFFX1 pwm1_out_reg_reg ( .D(N40), .CK(clk_b), .E(N137), .Q(N78), .QN(n2) );
  EDFFX1 pwm1_ext_reg ( .D(N111), .CK(clk_b), .E(N110), .Q(pwm1_ext) );
  EDFFX1 pwm1_out_ext_reg ( .D(N80), .CK(clk_b), .E(N79), .Q(pwm1_out_ext) );
  comp_pwm1_DW01_inc_7_0 add_90 ( .A(pwm1_out_cnt), .SUM({N119, N118, N117, 
        N116, N115, N114, N113}) );
endmodule


module comp_pwm1_DW01_inc_7_0 ( A, SUM );
  input [6:0] A;
  output [6:0] SUM;
  wire   carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  XOR2X1 U5 ( .A(carry_6_), .B(A[6]), .Y(SUM[6]) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module buf_pwm2 ( sw_rst, clk_b, pwm2_clear, PWM2D, pwm2_reload, pwm2buf );
  input [7:0] PWM2D;
  output [7:0] pwm2buf;
  input sw_rst, clk_b, pwm2_clear, pwm2_reload;
  wire   N2, N3, N4, N5, N6, N7, N8, N9, N12, n40, n60, n70;

  EDFFX1 pwm2buf_reg_7_ ( .D(N9), .CK(clk_b), .E(N12), .Q(pwm2buf[7]) );
  EDFFX2 pwm2buf_reg_6_ ( .D(N8), .CK(clk_b), .E(N12), .Q(pwm2buf[6]) );
  AND3X2 I15 ( .A(n40), .B(n70), .C(pwm2_reload), .Y(n60) );
  EDFFX1 pwm2buf_reg_5_ ( .D(N7), .CK(clk_b), .E(N12), .Q(pwm2buf[5]) );
  OR3X2 I16 ( .A(sw_rst), .B(pwm2_clear), .C(n60), .Y(N12) );
  INVX1 I17 ( .A(pwm2_clear), .Y(n40) );
  INVX1 I18 ( .A(sw_rst), .Y(n70) );
  AND2X2 I19 ( .A(PWM2D[7]), .B(n60), .Y(N9) );
  AND2X2 I20 ( .A(PWM2D[6]), .B(n60), .Y(N8) );
  AND2X2 I21 ( .A(PWM2D[5]), .B(n60), .Y(N7) );
  AND2X2 I22 ( .A(PWM2D[4]), .B(n60), .Y(N6) );
  AND2X2 I23 ( .A(PWM2D[3]), .B(n60), .Y(N5) );
  AND2X2 I24 ( .A(PWM2D[2]), .B(n60), .Y(N4) );
  AND2X2 I25 ( .A(PWM2D[1]), .B(n60), .Y(N3) );
  AND2X2 I26 ( .A(PWM2D[0]), .B(n60), .Y(N2) );
  EDFFX1 pwm2buf_reg_4_ ( .D(N6), .CK(clk_b), .E(N12), .Q(pwm2buf[4]) );
  EDFFX1 pwm2buf_reg_3_ ( .D(N5), .CK(clk_b), .E(N12), .Q(pwm2buf[3]) );
  EDFFX1 pwm2buf_reg_2_ ( .D(N4), .CK(clk_b), .E(N12), .Q(pwm2buf[2]) );
  EDFFX1 pwm2buf_reg_1_ ( .D(N3), .CK(clk_b), .E(N12), .Q(pwm2buf[1]) );
  EDFFX1 pwm2buf_reg_0_ ( .D(N2), .CK(clk_b), .E(N12), .Q(pwm2buf[0]) );
endmodule


module buf_pwm1 ( sw_rst, clk_b, pwm1_clear, PWM1D, pwm1_reload, pwm1buf );
  input [7:0] PWM1D;
  output [7:0] pwm1buf;
  input sw_rst, clk_b, pwm1_clear, pwm1_reload;
  wire   N2, N3, N4, N5, N6, N7, N8, N9, N12, n40, n60, n70;

  EDFFX1 pwm1buf_reg_7_ ( .D(N9), .CK(clk_b), .E(N12), .Q(pwm1buf[7]) );
  EDFFX2 pwm1buf_reg_6_ ( .D(N8), .CK(clk_b), .E(N12), .Q(pwm1buf[6]) );
  AND3X2 I15 ( .A(n40), .B(n70), .C(pwm1_reload), .Y(n60) );
  EDFFX1 pwm1buf_reg_5_ ( .D(N7), .CK(clk_b), .E(N12), .Q(pwm1buf[5]) );
  OR3X2 I16 ( .A(sw_rst), .B(pwm1_clear), .C(n60), .Y(N12) );
  INVX1 I17 ( .A(pwm1_clear), .Y(n40) );
  INVX1 I18 ( .A(sw_rst), .Y(n70) );
  AND2X2 I19 ( .A(PWM1D[7]), .B(n60), .Y(N9) );
  AND2X2 I20 ( .A(PWM1D[6]), .B(n60), .Y(N8) );
  AND2X2 I21 ( .A(PWM1D[5]), .B(n60), .Y(N7) );
  AND2X2 I22 ( .A(PWM1D[4]), .B(n60), .Y(N6) );
  AND2X2 I23 ( .A(PWM1D[3]), .B(n60), .Y(N5) );
  AND2X2 I24 ( .A(PWM1D[2]), .B(n60), .Y(N4) );
  AND2X2 I25 ( .A(PWM1D[1]), .B(n60), .Y(N3) );
  AND2X2 I26 ( .A(PWM1D[0]), .B(n60), .Y(N2) );
  EDFFX1 pwm1buf_reg_4_ ( .D(N6), .CK(clk_b), .E(N12), .Q(pwm1buf[4]) );
  EDFFX1 pwm1buf_reg_3_ ( .D(N5), .CK(clk_b), .E(N12), .Q(pwm1buf[3]) );
  EDFFX1 pwm1buf_reg_2_ ( .D(N4), .CK(clk_b), .E(N12), .Q(pwm1buf[2]) );
  EDFFX1 pwm1buf_reg_1_ ( .D(N3), .CK(clk_b), .E(N12), .Q(pwm1buf[1]) );
  EDFFX1 pwm1buf_reg_0_ ( .D(N2), .CK(clk_b), .E(N12), .Q(pwm1buf[0]) );
endmodule


module sfr_pwm ( PWM1_SEL, PWM2_SEL, sw_rst, clk_b, SFR_wr, PWM1CON_sel, 
        PWM2CON_sel, PWM1D_sel, PWM2D_sel, SFR_bus, PWM_SFR_OUT, PWM1CON, 
        PWM2CON, PWM1D, PWM2D );
  input [7:0] SFR_bus;
  output [7:0] PWM_SFR_OUT;
  output [7:0] PWM1CON;
  output [7:0] PWM2CON;
  output [7:0] PWM1D;
  output [7:0] PWM2D;
  input sw_rst, clk_b, SFR_wr, PWM1CON_sel, PWM2CON_sel, PWM1D_sel, PWM2D_sel;
  output PWM1_SEL, PWM2_SEL;
  wire   n74, n75, N16, N17, N18, N19, N20, N21, N22, N28, N29, N30, N31, N32,
         N33, N34, N39, N40, N41, N42, N43, N44, N45, N46, N48, N49, N50, N51,
         N52, N53, N54, N55, N57, N58, N62, N66, n2, n3, n4, n5, n8, n9, n10,
         n11, n12, n13, n14, n15, n160, n170, n180, n190, n200, n210, n220,
         n23, n24, n25, n26, n27, n280, n290, n300, n320, n330, n340, n35, n36,
         n37, n390, n480, n530, n540, n550, n56, n570, n580, n59, n60, n61,
         n620, n63, n64, n65, n660, n67, n72, n73;

  EDFFX4 PWM2CON_reg_4_ ( .D(N31), .CK(clk_b), .E(N66), .Q(PWM2CON[4]), .QN(
        n550) );
  EDFFX4 PWM2CON_reg_5_ ( .D(N32), .CK(clk_b), .E(N66), .Q(PWM2CON[5]) );
  EDFFX4 PWM1CON_reg_4_ ( .D(N19), .CK(clk_b), .E(N62), .Q(PWM1CON[4]) );
  EDFFX4 PWM1CON_reg_5_ ( .D(N20), .CK(clk_b), .E(N62), .Q(PWM1CON[5]) );
  NOR2X1 I93 ( .A(n530), .B(n290), .Y(n210) );
  NOR2X1 I94 ( .A(n540), .B(n290), .Y(n25) );
  INVX1 I95 ( .A(n290), .Y(n8) );
  NOR2X1 I96 ( .A(n550), .B(n290), .Y(n170) );
  AND2X2 I97 ( .A(PWM2D_sel), .B(n56), .Y(n64) );
  INVX1 I98 ( .A(n480), .Y(n56) );
  AND3X2 I99 ( .A(n390), .B(n61), .C(n580), .Y(n570) );
  DFFTRX1 PWM2CON_reg_1_ ( .D(SFR_bus[1]), .CK(clk_b), .RN(n65), .Q(PWM2CON[1]), .QN(n300) );
  EDFFX2 PWM1CON_reg_6_ ( .D(N21), .CK(clk_b), .E(N62), .Q(PWM1CON[6]) );
  EDFFX2 PWM1CON_reg_3_ ( .D(N18), .CK(clk_b), .E(N62), .Q(PWM1CON[3]) );
  EDFFX2 PWM2CON_reg_6_ ( .D(N33), .CK(clk_b), .E(N66), .Q(PWM2CON[6]) );
  EDFFX2 PWM2CON_reg_3_ ( .D(N30), .CK(clk_b), .E(N66), .Q(PWM2CON[3]), .QN(
        n530) );
  AND2X2 I100 ( .A(PWM2D_sel), .B(n620), .Y(n580) );
  INVX2 I101 ( .A(PWM1D_sel), .Y(n390) );
  NOR2X2 I102 ( .A(n390), .B(n480), .Y(n660) );
  NOR3X4 I103 ( .A(PWM2CON_sel), .B(PWM1CON_sel), .C(n390), .Y(n67) );
  NOR2X2 I104 ( .A(n61), .B(n480), .Y(n65) );
  NOR2X2 I105 ( .A(n620), .B(n480), .Y(n63) );
  NAND2X2 I106 ( .A(SFR_wr), .B(n73), .Y(n480) );
  INVX1 I107 ( .A(PWM2CON_sel), .Y(n61) );
  INVX1 I108 ( .A(PWM1CON_sel), .Y(n620) );
  AND2X1 I109 ( .A(SFR_bus[6]), .B(n63), .Y(N21) );
  AND2X1 I110 ( .A(SFR_bus[5]), .B(n63), .Y(N20) );
  AND2X1 I111 ( .A(SFR_bus[4]), .B(n63), .Y(N19) );
  AND2X1 I112 ( .A(SFR_bus[3]), .B(n63), .Y(N18) );
  AND2X1 I113 ( .A(SFR_bus[6]), .B(n65), .Y(N33) );
  AND2X1 I114 ( .A(SFR_bus[5]), .B(n65), .Y(N32) );
  AND2X1 I115 ( .A(SFR_bus[4]), .B(n65), .Y(N31) );
  AND2X1 I116 ( .A(SFR_bus[3]), .B(n65), .Y(N30) );
  AND2X1 I117 ( .A(n660), .B(SFR_bus[7]), .Y(N46) );
  AND2X1 I118 ( .A(n660), .B(SFR_bus[6]), .Y(N45) );
  AND2X1 I119 ( .A(n660), .B(SFR_bus[5]), .Y(N44) );
  AND2X1 I120 ( .A(n660), .B(SFR_bus[4]), .Y(N43) );
  AND2X1 I121 ( .A(n660), .B(SFR_bus[3]), .Y(N42) );
  AND2X1 I122 ( .A(n660), .B(SFR_bus[2]), .Y(N41) );
  AND2X1 I123 ( .A(SFR_bus[7]), .B(n63), .Y(N22) );
  AND2X1 I124 ( .A(SFR_bus[2]), .B(n63), .Y(N17) );
  AND2X1 I125 ( .A(SFR_bus[7]), .B(n64), .Y(N55) );
  AND2X1 I126 ( .A(SFR_bus[6]), .B(n64), .Y(N54) );
  AND2X1 I127 ( .A(SFR_bus[5]), .B(n64), .Y(N53) );
  AND2X1 I128 ( .A(SFR_bus[4]), .B(n64), .Y(N52) );
  AND2X1 I129 ( .A(SFR_bus[3]), .B(n64), .Y(N51) );
  AND2X1 I130 ( .A(SFR_bus[2]), .B(n64), .Y(N50) );
  AND2X1 I131 ( .A(SFR_bus[7]), .B(n65), .Y(N34) );
  AND2X1 I132 ( .A(SFR_bus[2]), .B(n65), .Y(N29) );
  AND2X1 I133 ( .A(PWM1D[0]), .B(n67), .Y(n37) );
  AND2X1 I134 ( .A(PWM2D[7]), .B(n570), .Y(n4) );
  AND2X1 I135 ( .A(PWM1D[6]), .B(n67), .Y(n12) );
  AND2X1 I136 ( .A(PWM1D[5]), .B(n67), .Y(n160) );
  AND2X1 I137 ( .A(PWM1D[4]), .B(n67), .Y(n200) );
  AND2X1 I138 ( .A(PWM1D[3]), .B(n67), .Y(n24) );
  AND2X1 I139 ( .A(PWM1D[2]), .B(n67), .Y(n280) );
  INVX1 I140 ( .A(n73), .Y(n72) );
  OR2X1 I141 ( .A(PWM1CON_sel), .B(n61), .Y(n290) );
  AND2X1 I142 ( .A(PWM1CON[0]), .B(PWM1CON_sel), .Y(n35) );
  AND2X1 I143 ( .A(PWM2D[0]), .B(n570), .Y(n36) );
  AND2X1 I144 ( .A(n74), .B(PWM1CON_sel), .Y(n3) );
  AND2X1 I145 ( .A(PWM1D[7]), .B(n67), .Y(n5) );
  AND2X1 I146 ( .A(PWM1CON[6]), .B(PWM1CON_sel), .Y(n10) );
  AND2X1 I147 ( .A(PWM2D[6]), .B(n570), .Y(n11) );
  AND2X1 I148 ( .A(PWM1CON[5]), .B(PWM1CON_sel), .Y(n14) );
  AND2X1 I149 ( .A(PWM2D[5]), .B(n570), .Y(n15) );
  AND2X1 I150 ( .A(PWM1CON[4]), .B(PWM1CON_sel), .Y(n180) );
  AND2X1 I151 ( .A(PWM2D[4]), .B(n570), .Y(n190) );
  AND2X1 I152 ( .A(PWM1CON[3]), .B(PWM1CON_sel), .Y(n220) );
  AND2X1 I153 ( .A(PWM2D[3]), .B(n570), .Y(n23) );
  AND2X1 I154 ( .A(PWM1CON[2]), .B(PWM1CON_sel), .Y(n26) );
  AND2X1 I155 ( .A(PWM2D[2]), .B(n570), .Y(n27) );
  EDFFX1 PWM1D_reg_0_ ( .D(N39), .CK(clk_b), .E(N57), .Q(PWM1D[0]) );
  EDFFX1 PWM2D_reg_0_ ( .D(N48), .CK(clk_b), .E(N58), .Q(PWM2D[0]) );
  EDFFX1 PWM2D_reg_1_ ( .D(N49), .CK(clk_b), .E(N58), .Q(PWM2D[1]) );
  EDFFX1 PWM1D_reg_1_ ( .D(N40), .CK(clk_b), .E(N57), .Q(PWM1D[1]) );
  OR2X2 I156 ( .A(n660), .B(n72), .Y(N57) );
  OR2X2 I157 ( .A(n64), .B(n72), .Y(N58) );
  OR2X2 I158 ( .A(n63), .B(n72), .Y(N62) );
  OR2X2 I159 ( .A(n65), .B(n72), .Y(N66) );
  EDFFX1 PWM1D_reg_4_ ( .D(N43), .CK(clk_b), .E(N57), .Q(PWM1D[4]) );
  EDFFX1 PWM2D_reg_4_ ( .D(N52), .CK(clk_b), .E(N58), .Q(PWM2D[4]) );
  EDFFX1 PWM1D_reg_5_ ( .D(N44), .CK(clk_b), .E(N57), .Q(PWM1D[5]) );
  EDFFX1 PWM2D_reg_5_ ( .D(N53), .CK(clk_b), .E(N58), .Q(PWM2D[5]) );
  EDFFX1 PWM1D_reg_2_ ( .D(N41), .CK(clk_b), .E(N57), .Q(PWM1D[2]) );
  EDFFX1 PWM2D_reg_2_ ( .D(N50), .CK(clk_b), .E(N58), .Q(PWM2D[2]) );
  EDFFX1 PWM1D_reg_3_ ( .D(N42), .CK(clk_b), .E(N57), .Q(PWM1D[3]) );
  EDFFX1 PWM2D_reg_3_ ( .D(N51), .CK(clk_b), .E(N58), .Q(PWM2D[3]) );
  INVX1 I160 ( .A(sw_rst), .Y(n73) );
  INVX1 I161 ( .A(n59), .Y(PWM2_SEL) );
  INVX1 I162 ( .A(n59), .Y(PWM2CON[7]) );
  INVX1 I163 ( .A(n60), .Y(PWM1_SEL) );
  INVX1 I164 ( .A(n60), .Y(PWM1CON[7]) );
  OAI221X4 I165 ( .A0(n290), .A1(n300), .B0(n620), .B1(n320), .C0(n330), .Y(
        PWM_SFR_OUT[1]) );
  AOI22X1 I166 ( .A0(PWM2D[1]), .A1(n570), .B0(PWM1D[1]), .B1(n67), .Y(n330)
         );
  OR4X2 I167 ( .A(n340), .B(n35), .C(n36), .D(n37), .Y(PWM_SFR_OUT[0]) );
  AND2X2 I168 ( .A(PWM2CON[0]), .B(n8), .Y(n340) );
  OR4X2 I169 ( .A(n2), .B(n3), .C(n4), .D(n5), .Y(PWM_SFR_OUT[7]) );
  AND2X2 I170 ( .A(n75), .B(n8), .Y(n2) );
  OR4X2 I171 ( .A(n9), .B(n10), .C(n11), .D(n12), .Y(PWM_SFR_OUT[6]) );
  AND2X2 I172 ( .A(PWM2CON[6]), .B(n8), .Y(n9) );
  OR4X2 I173 ( .A(n13), .B(n14), .C(n15), .D(n160), .Y(PWM_SFR_OUT[5]) );
  AND2X2 I174 ( .A(PWM2CON[5]), .B(n8), .Y(n13) );
  OR4X2 I175 ( .A(n170), .B(n180), .C(n190), .D(n200), .Y(PWM_SFR_OUT[4]) );
  OR4X2 I176 ( .A(n210), .B(n220), .C(n23), .D(n24), .Y(PWM_SFR_OUT[3]) );
  OR4X2 I177 ( .A(n25), .B(n26), .C(n27), .D(n280), .Y(PWM_SFR_OUT[2]) );
  EDFFX1 PWM1CON_reg_0_ ( .D(N16), .CK(clk_b), .E(N62), .Q(PWM1CON[0]) );
  EDFFX1 PWM2CON_reg_0_ ( .D(N28), .CK(clk_b), .E(N66), .Q(PWM2CON[0]) );
  EDFFX1 PWM1CON_reg_7_ ( .D(N22), .CK(clk_b), .E(N62), .Q(n74), .QN(n60) );
  EDFFX1 PWM2CON_reg_7_ ( .D(N34), .CK(clk_b), .E(N66), .Q(n75), .QN(n59) );
  EDFFX1 PWM1D_reg_6_ ( .D(N45), .CK(clk_b), .E(N57), .Q(PWM1D[6]) );
  EDFFX1 PWM2D_reg_6_ ( .D(N54), .CK(clk_b), .E(N58), .Q(PWM2D[6]) );
  EDFFX1 PWM1D_reg_7_ ( .D(N46), .CK(clk_b), .E(N57), .Q(PWM1D[7]) );
  EDFFX1 PWM2D_reg_7_ ( .D(N55), .CK(clk_b), .E(N58), .Q(PWM2D[7]) );
  EDFFX1 PWM1CON_reg_2_ ( .D(N17), .CK(clk_b), .E(N62), .Q(PWM1CON[2]) );
  EDFFX1 PWM2CON_reg_2_ ( .D(N29), .CK(clk_b), .E(N66), .Q(PWM2CON[2]), .QN(
        n540) );
  AND2X1 I178 ( .A(n64), .B(SFR_bus[1]), .Y(N49) );
  AND2X1 I179 ( .A(n660), .B(SFR_bus[1]), .Y(N40) );
  DFFTRX1 PWM1CON_reg_1_ ( .D(n63), .CK(clk_b), .RN(SFR_bus[1]), .Q(PWM1CON[1]), .QN(n320) );
  AND2X1 I180 ( .A(SFR_bus[0]), .B(n65), .Y(N28) );
  AND2X1 I181 ( .A(SFR_bus[0]), .B(n63), .Y(N16) );
  AND2X1 I182 ( .A(SFR_bus[0]), .B(n64), .Y(N48) );
  AND2X1 I183 ( .A(n660), .B(SFR_bus[0]), .Y(N39) );
endmodule


module power_control ( STOPwake_WDT, POR, sw_rst, clk, RST_pin, interrupt_ack, 
        STOPwake_INT0, STOPwake_INT1, SFR_wr, SFR_bus, PCON_sel, SMOD1_update, 
        SMOD1, SMOD0, PCON, pre_idle, pre_pdwn, pre_pdwn_idle );
  input [7:0] SFR_bus;
  output [7:0] PCON;
  input STOPwake_WDT, POR, sw_rst, clk, RST_pin, interrupt_ack, STOPwake_INT0,
         STOPwake_INT1, SFR_wr, PCON_sel;
  output SMOD1_update, SMOD1, SMOD0, pre_idle, pre_pdwn, pre_pdwn_idle;
  wire   SFR_wr_PCON, n5, n6, n8, n9, n10, n11, n12, n13, n17, n18, n20, n21,
         n22, n23, n24, n25, n27, n29, n30, n31, n32;

  OAI32X4 U11 ( .A0(n5), .A1(STOPwake_INT0), .A2(n6), .B0(PCON[1]), .B1(n5), 
        .Y(n8) );
  NOR2BX1 I23 ( .AN(n31), .B(n30), .Y(n20) );
  AND2X2 I24 ( .A(PCON[0]), .B(n31), .Y(n22) );
  INVX2 I25 ( .A(n25), .Y(n31) );
  OAI211X1 I26 ( .A0(pre_pdwn), .A1(n20), .B0(n29), .C0(n11), .Y(n21) );
  INVX1 I27 ( .A(n21), .Y(n12) );
  OAI211X1 I28 ( .A0(pre_idle), .A1(n22), .B0(n29), .C0(n11), .Y(n23) );
  INVX1 I29 ( .A(n23), .Y(n13) );
  AND2X1 I30 ( .A(n25), .B(SFR_bus[0]), .Y(pre_idle) );
  OAI2BB2X4 I31 ( .A0N(n25), .A1N(SFR_bus[0]), .B0(n31), .B1(n32), .Y(
        pre_pdwn_idle) );
  EDFFTRX1 PCON_reg_7_ ( .D(SMOD1_update), .CK(clk), .E(SFR_wr_PCON), .RN(n29), 
        .Q(PCON[7]) );
  EDFFTRX1 PCON_reg_6_ ( .D(SFR_bus[6]), .CK(clk), .E(SFR_wr_PCON), .RN(n29), 
        .Q(PCON[6]), .QN(n24) );
  INVX2 I32 ( .A(SFR_bus[1]), .Y(n32) );
  DFFRX1 PCON_reg_1_ ( .D(n12), .CK(clk), .RN(n8), .Q(PCON[1]), .QN(n30) );
  DFFRX1 PCON_reg_0_ ( .D(n13), .CK(clk), .RN(n9), .Q(PCON[0]) );
  AND2X1 I33 ( .A(SFR_wr), .B(PCON_sel), .Y(n25) );
  NOR2X2 I34 ( .A(n31), .B(n32), .Y(pre_pdwn) );
  INVX1 I35 ( .A(n24), .Y(SMOD0) );
  INVX1 I36 ( .A(n27), .Y(SMOD1) );
  INVX1 I37 ( .A(interrupt_ack), .Y(n11) );
  INVX2 I38 ( .A(n31), .Y(SFR_wr_PCON) );
  AND2X2 I39 ( .A(SFR_bus[7]), .B(SFR_wr_PCON), .Y(SMOD1_update) );
  INVX2 I40 ( .A(sw_rst), .Y(n29) );
  INVX1 I41 ( .A(n5), .Y(n9) );
  OAI2BB2X1 I42 ( .A0N(SFR_bus[4]), .A1N(SFR_wr_PCON), .B0(SFR_wr_PCON), .B1(
        n17), .Y(n18) );
  INVX1 I43 ( .A(PCON[7]), .Y(n27) );
  OR2X2 I44 ( .A(RST_pin), .B(POR), .Y(n5) );
  OR2X2 I45 ( .A(STOPwake_WDT), .B(STOPwake_INT1), .Y(n6) );
  INVX1 I46 ( .A(POR), .Y(n10) );
  DFFSX1 PCON_reg_4_ ( .D(n18), .CK(clk), .SN(n10), .Q(PCON[4]), .QN(n17) );
  EDFFTRX1 PCON_reg_5_ ( .D(SFR_bus[5]), .CK(clk), .E(SFR_wr_PCON), .RN(n29), 
        .Q(PCON[5]) );
  EDFFTRX1 PCON_reg_3_ ( .D(SFR_bus[3]), .CK(clk), .E(SFR_wr_PCON), .RN(n29), 
        .Q(PCON[3]) );
  EDFFTRX1 PCON_reg_2_ ( .D(SFR_bus[2]), .CK(clk), .E(SFR_wr_PCON), .RN(n29), 
        .Q(PCON[2]) );
endmodule


module uart ( POR, Z_update, sw_rst, clk_b, pr_st, SFR_wr, SFR_bus, SCON_sel, 
        SBUF_sel, SADDR_sel, SADEN_sel, pin_RXD, SMOD1_update, SMOD1, SMOD0, 
        T1_overflow, T2_uart_clk, TCLK, RCLK, ua_intr, Mode0_data_RXD, 
        Uart_TXD, UART_SFR_OUT );
  input [2:0] pr_st;
  input [7:0] SFR_bus;
  output [7:0] UART_SFR_OUT;
  input POR, Z_update, sw_rst, clk_b, SFR_wr, SCON_sel, SBUF_sel, SADDR_sel,
         SADEN_sel, pin_RXD, SMOD1_update, SMOD1, SMOD0, T1_overflow,
         T2_uart_clk, TCLK, RCLK;
  output ua_intr, Mode0_data_RXD, Uart_TXD;
  wire   RX_clk, TX_clk, TX_shift_bit, TX_shift, RX_shift_bit, RX_shift,
         chosen_RX_bit, set_TI, set_RI, set_FE, now_TX_bit, Uart_mode0,
         Uart_mode1, Uart_mode2, Uart_mode3, SM2, REN, TB8, RI, SADDR_match,
         SFR_wr_SBUF, mode0_TX_ing, mode0_RX_ing, n1, n2;

  uart_sfr uart_sfr ( .POR(POR), .sw_rst(n1), .clk_b(clk_b), .pr_st(pr_st), 
        .SFR_wr(SFR_wr), .SFR_bus(SFR_bus), .SCON_sel(SCON_sel), .SBUF_sel(
        SBUF_sel), .SADEN_sel(SADEN_sel), .SADDR_sel(SADDR_sel), .Uart_mode0(
        Uart_mode0), .Uart_mode1(Uart_mode1), .Uart_mode2(Uart_mode2), 
        .Uart_mode3(Uart_mode3), .SMOD1_update(SMOD1_update), .SMOD1(SMOD1), 
        .SMOD0(SMOD0), .T1_overflow(T1_overflow), .T2_uart_clk(T2_uart_clk), 
        .TCLK(TCLK), .RCLK(RCLK), .RX_clk(RX_clk), .TX_clk(TX_clk), 
        .now_TX_bit(now_TX_bit), .TX_shift_bit(TX_shift_bit), .TX_shift(
        TX_shift), .RX_shift_bit(RX_shift_bit), .chosen_RX_bit(chosen_RX_bit), 
        .RX_shift(RX_shift), .set_TI(set_TI), .set_RI(set_RI), .set_FE(set_FE), 
        .SM2(SM2), .REN(REN), .TB8(TB8), .RI(RI), .ua_intr(ua_intr), 
        .SADDR_match(SADDR_match), .SFR_wr_SBUF(SFR_wr_SBUF), .UART_SFR_OUT(
        UART_SFR_OUT) );
  RX RX ( .POR(POR), .Z_update(Z_update), .sw_rst(n1), .clk_b(clk_b), .pr_st(
        pr_st), .mode0_TX_ing(mode0_TX_ing), .now_TX_bit(now_TX_bit), .SM2(SM2), .REN(REN), .RI(RI), .pin_RXD(pin_RXD), .SADDR_match(SADDR_match), .RX_clk(
        RX_clk), .Uart_mode0(Uart_mode0), .Uart_mode1(Uart_mode1), 
        .Uart_mode2(Uart_mode2), .Uart_mode3(Uart_mode3), .RX_shift_bit(
        RX_shift_bit), .chosen_RX_bit(chosen_RX_bit), .mode0_RX_ing(
        mode0_RX_ing), .RX_shift(RX_shift), .set_RI(set_RI), .set_FE(set_FE), 
        .Mode0_data_RXD(Mode0_data_RXD) );
  TX TX ( .POR(POR), .Z_update(Z_update), .sw_rst(n1), .clk_b(clk_b), .pr_st(
        pr_st), .now_TX_bit(now_TX_bit), .mode0_RX_ing(mode0_RX_ing), .TB8(TB8), .SFR_wr_SBUF(SFR_wr_SBUF), .TX_clk(TX_clk), .Uart_mode0(Uart_mode0), 
        .Uart_mode1(Uart_mode1), .Uart_mode2(Uart_mode2), .Uart_mode3(
        Uart_mode3), .mode0_TX_ing(mode0_TX_ing), .TX_shift_bit(TX_shift_bit), 
        .TX_shift(TX_shift), .set_TI(set_TI), .Uart_TXD(Uart_TXD) );
  INVX4 I1 ( .A(n2), .Y(n1) );
  INVX1 I2 ( .A(sw_rst), .Y(n2) );
endmodule


module TX ( POR, Z_update, sw_rst, clk_b, pr_st, now_TX_bit, mode0_RX_ing, TB8, 
        SFR_wr_SBUF, TX_clk, Uart_mode0, Uart_mode1, Uart_mode2, Uart_mode3, 
        mode0_TX_ing, TX_shift_bit, TX_shift, set_TI, Uart_TXD );
  input [2:0] pr_st;
  input POR, Z_update, sw_rst, clk_b, now_TX_bit, mode0_RX_ing, TB8,
         SFR_wr_SBUF, TX_clk, Uart_mode0, Uart_mode1, Uart_mode2, Uart_mode3;
  output mode0_TX_ing, TX_shift_bit, TX_shift, set_TI, Uart_TXD;
  wire   TX_step_one, N20, N23, TX_start, mode123_TX_ing, mode0_shift_clk,
         TX_div16_carry, N78, N82, N83, N85, N86, N88, N90, N92, N93, n8, n10,
         n11, n14, n16, n18, n200, n21, n22, n230, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n61, n62, n63, n64, n65, n66, n67, n68, n69;
  wire   [3:0] TX_div16;
  wire   [3:0] state_TX;
  wire   [3:0] TX_div16_inc;

  OAI222X4 U9 ( .A0(n11), .A1(n63), .B0(n11), .B1(n66), .C0(n8), .C1(n14), .Y(
        n58) );
  OAI222X4 U13 ( .A0(n8), .A1(n61), .B0(mode0_TX_ing), .B1(n18), .C0(n16), 
        .C1(state_TX[0]), .Y(n56) );
  OAI31X4 U19 ( .A0(n21), .A1(mode0_TX_ing), .A2(TX_start), .B0(TX_step_one), 
        .Y(n22) );
  OAI222X4 U20 ( .A0(mode0_shift_clk), .A1(n230), .B0(mode0_TX_ing), .B1(
        mode0_RX_ing), .C0(Uart_mode0), .C1(n24), .Y(Uart_TXD) );
  OAI32X4 U22 ( .A0(n63), .A1(TX_step_one), .A2(SFR_wr_SBUF), .B0(sw_rst), 
        .B1(n26), .Y(n55) );
  OAI31X4 U27 ( .A0(Uart_mode0), .A1(Uart_mode1), .A2(TB8), .B0(SFR_wr_SBUF), 
        .Y(n28) );
  OAI33X4 U29 ( .A0(n230), .A1(n29), .A2(n200), .B0(n25), .B1(n29), .B2(n30), 
        .Y(TX_shift) );
  AOI221X4 U43 ( .A0(n39), .A1(n40), .B0(state_TX[0]), .B1(n41), .C0(
        state_TX[2]), .Y(n38) );
  OAI211X4 U49 ( .A0(Uart_mode3), .A1(Uart_mode2), .B0(state_TX[1]), .C0(n61), 
        .Y(n40) );
  OAI33X4 U58 ( .A0(n46), .A1(sw_rst), .A2(Uart_mode0), .B0(n47), .B1(n42), 
        .B2(n48), .Y(N20) );
  NAND3X1 I70 ( .A(n64), .B(n65), .C(n62), .Y(mode123_TX_ing) );
  OR4X2 I71 ( .A(state_TX[0]), .B(state_TX[1]), .C(state_TX[2]), .D(
        state_TX[3]), .Y(mode0_TX_ing) );
  NOR2X1 I72 ( .A(Uart_mode0), .B(state_TX[0]), .Y(n39) );
  OR2X2 I73 ( .A(n62), .B(n61), .Y(n68) );
  DFFRX1 state_TX_reg_1_ ( .D(n51), .CK(clk_b), .RN(n49), .Q(state_TX[1]), 
        .QN(n62) );
  OAI31X1 I74 ( .A0(n42), .A1(pr_st[2]), .A2(pr_st[0]), .B0(N82), .Y(N83) );
  OAI211X1 I75 ( .A0(n36), .A1(n62), .B0(n37), .C0(n38), .Y(n35) );
  AND2X2 U67 ( .A(n67), .B(n58), .Y(n52) );
  OAI31X1 I76 ( .A0(n44), .A1(pr_st[1]), .A2(pr_st[0]), .B0(n45), .Y(n43) );
  INVX1 I77 ( .A(POR), .Y(n49) );
  DFFRHQX2 TX_step_one_reg ( .D(N20), .CK(clk_b), .RN(n49), .Q(TX_step_one) );
  EDFFTRX1 TX_div16_reg_3_ ( .D(TX_div16_inc[3]), .CK(clk_b), .E(TX_clk), .RN(
        n67), .Q(TX_div16[3]) );
  EDFFTRX1 TX_div16_reg_2_ ( .D(TX_div16_inc[2]), .CK(clk_b), .E(TX_clk), .RN(
        n67), .Q(TX_div16[2]) );
  EDFFTRX1 TX_div16_reg_1_ ( .D(TX_div16_inc[1]), .CK(clk_b), .E(TX_clk), .RN(
        n67), .Q(TX_div16[1]) );
  EDFFX1 TX_div16_reg_0_ ( .D(N23), .CK(clk_b), .E(N78), .Q(TX_div16[0]) );
  DFFRX1 state_TX_reg_2_ ( .D(n52), .CK(clk_b), .RN(n49), .Q(state_TX[2]), 
        .QN(n64) );
  DFFRX2 state_TX_reg_0_ ( .D(n50), .CK(clk_b), .RN(n49), .Q(state_TX[0]), 
        .QN(n61) );
  DFFRX1 state_TX_reg_3_ ( .D(n53), .CK(clk_b), .RN(n49), .Q(state_TX[3]), 
        .QN(n65) );
  INVX1 I78 ( .A(n35), .Y(n21) );
  INVX2 I79 ( .A(sw_rst), .Y(n67) );
  OR2X2 I80 ( .A(n18), .B(n200), .Y(n11) );
  INVX1 I81 ( .A(Uart_mode0), .Y(n230) );
  EDFFX1 set_TI_reg ( .D(N86), .CK(clk_b), .E(N85), .Q(set_TI) );
  OR2X2 I82 ( .A(TX_clk), .B(sw_rst), .Y(N78) );
  INVX1 I83 ( .A(n22), .Y(n8) );
  AND2X2 U65 ( .A(n56), .B(n67), .Y(n50) );
  OR2X2 I84 ( .A(n21), .B(n22), .Y(n18) );
  INVX1 I85 ( .A(n16), .Y(n10) );
  XOR2X1 I86 ( .A(state_TX[2]), .B(n68), .Y(n66) );
  OR3X2 I87 ( .A(sw_rst), .B(Z_update), .C(n21), .Y(N85) );
  OR3X2 I88 ( .A(sw_rst), .B(SFR_wr_SBUF), .C(TX_shift), .Y(N93) );
  INVX1 I89 ( .A(mode0_TX_ing), .Y(n200) );
  AND2X2 I90 ( .A(n21), .B(n67), .Y(N86) );
  NOR2X1 I91 ( .A(n68), .B(n64), .Y(n69) );
  DFFRX1 TX_start_reg ( .D(n54), .CK(clk_b), .RN(n49), .Q(TX_start), .QN(n63)
         );
  OAI2BB1X1 I92 ( .A0N(TX_div16_inc[0]), .A1N(TX_clk), .B0(n67), .Y(N23) );
  INVX1 I93 ( .A(pr_st[0]), .Y(n48) );
  OR3X2 I94 ( .A(sw_rst), .B(pr_st[2]), .C(n230), .Y(n47) );
  NAND2X1 I95 ( .A(TX_div16_carry), .B(TX_clk), .Y(n46) );
  INVX1 I96 ( .A(TX_step_one), .Y(n29) );
  OR2X2 I97 ( .A(Uart_mode0), .B(n31), .Y(n30) );
  INVX1 I98 ( .A(mode123_TX_ing), .Y(n31) );
  OR2X2 I99 ( .A(TX_start), .B(n11), .Y(n16) );
  INVX1 I100 ( .A(n32), .Y(n25) );
  OAI211X1 I101 ( .A0(state_TX[0]), .A1(Uart_mode1), .B0(n14), .C0(n33), .Y(
        n32) );
  AND3X2 I102 ( .A(state_TX[3]), .B(state_TX[1]), .C(n34), .Y(n33) );
  OR3X2 I103 ( .A(Uart_mode3), .B(Uart_mode2), .C(n61), .Y(n34) );
  AND2X2 I104 ( .A(TX_step_one), .B(state_TX[3]), .Y(n37) );
  INVX1 I105 ( .A(n40), .Y(n36) );
  INVX1 I106 ( .A(Uart_mode1), .Y(n41) );
  AND2X2 U66 ( .A(n67), .B(n57), .Y(n51) );
  OAI2BB2X1 I107 ( .A0N(N88), .A1N(n10), .B0(n8), .B1(n62), .Y(n57) );
  XOR2X1 I108 ( .A(state_TX[1]), .B(state_TX[0]), .Y(N88) );
  AND2X2 U68 ( .A(n67), .B(n59), .Y(n53) );
  OAI2BB2X1 I109 ( .A0N(N90), .A1N(n10), .B0(n8), .B1(n65), .Y(n59) );
  XOR2X1 I110 ( .A(state_TX[3]), .B(n69), .Y(N90) );
  AND2X2 U69 ( .A(n67), .B(n55), .Y(n54) );
  INVX1 I111 ( .A(SFR_wr_SBUF), .Y(n26) );
  INVX1 I112 ( .A(state_TX[2]), .Y(n14) );
  OAI211X1 I113 ( .A0(SFR_wr_SBUF), .A1(n27), .B0(n28), .C0(n67), .Y(N92) );
  INVX1 I114 ( .A(TX_shift), .Y(n27) );
  INVX1 I115 ( .A(pr_st[1]), .Y(n42) );
  INVX1 I116 ( .A(n43), .Y(N82) );
  INVX1 I117 ( .A(pr_st[2]), .Y(n44) );
  AND2X2 I118 ( .A(Uart_mode0), .B(n67), .Y(n45) );
  AOI211X1 I119 ( .A0(now_TX_bit), .A1(mode123_TX_ing), .B0(n25), .C0(n200), 
        .Y(n24) );
  EDFFX1 TX_shift_bit_reg ( .D(N92), .CK(clk_b), .E(N93), .Q(TX_shift_bit) );
  EDFFX1 mode0_shift_clk_reg ( .D(N82), .CK(clk_b), .E(N83), .Q(
        mode0_shift_clk) );
  TX_DW01_inc_5_0 add_83 ( .A({1'b0, TX_div16}), .SUM({TX_div16_carry, 
        TX_div16_inc}) );
endmodule


module TX_DW01_inc_5_0 ( A, SUM );
  input [4:0] A;
  output [4:0] SUM;
  wire   carry_3_, carry_2_;

  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(SUM[4]) );
endmodule


module RX ( POR, Z_update, sw_rst, clk_b, pr_st, mode0_TX_ing, now_TX_bit, SM2, 
        REN, RI, pin_RXD, SADDR_match, RX_clk, Uart_mode0, Uart_mode1, 
        Uart_mode2, Uart_mode3, RX_shift_bit, chosen_RX_bit, mode0_RX_ing, 
        RX_shift, set_RI, set_FE, Mode0_data_RXD );
  input [2:0] pr_st;
  input POR, Z_update, sw_rst, clk_b, mode0_TX_ing, now_TX_bit, SM2, REN, RI,
         pin_RXD, SADDR_match, RX_clk, Uart_mode0, Uart_mode1, Uart_mode2,
         Uart_mode3;
  output RX_shift_bit, chosen_RX_bit, mode0_RX_ing, RX_shift, set_RI, set_FE,
         Mode0_data_RXD;
  wire   current_RXD, now_RX_ing, decision_time, RX_step_one, N30, N31, N44,
         N46, N48, N49, N62, N63, RX_div16_carry, N84, N85, N87, N88, N89, N90,
         N91, N94, N95, N96, n13, n14, n15, n16, n18, n20, n21, n24, n25, n26,
         n27, n28, n29, n300, n310, n32, n33, n34, n35, n36, n37, n39, n41,
         n43, n440, n45, n460, n47, n50, n52, n53, n54, n55, n61, n620, n630,
         n64, n65, n66, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n870, n880, n890, n900, n92, n93, n940, n950, n960, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111;
  wire   [3:0] RX_div16;
  wire   [3:0] state_RX;
  wire   [3:0] RX_div16_inc;

  OAI222X4 U13 ( .A0(n18), .A1(state_RX[0]), .B0(n20), .B1(n21), .C0(n93), 
        .C1(n14), .Y(n870) );
  OAI211X4 U19 ( .A0(n27), .A1(n93), .B0(n28), .C0(n29), .Y(n20) );
  AOI222X4 U21 ( .A0(Uart_mode3), .A1(n310), .B0(n32), .B1(chosen_RX_bit), 
        .C0(Uart_mode2), .C1(n310), .Y(n27) );
  OAI33X4 U24 ( .A0(n35), .A1(chosen_RX_bit), .A2(n36), .B0(n37), .B1(n93), 
        .B2(n300), .Y(set_FE) );
  OAI222X4 U29 ( .A0(n950), .A1(n39), .B0(RX_clk), .B1(n104), .C0(n108), .C1(
        n39), .Y(n81) );
  OAI211X4 U41 ( .A0(n440), .A1(n45), .B0(REN), .C0(n460), .Y(n21) );
  OAI22X4 U52 ( .A0(n33), .A1(n29), .B0(Uart_mode0), .B1(n35), .Y(n53) );
  OAI211X4 U53 ( .A0(SADDR_match), .A1(n54), .B0(n310), .C0(n55), .Y(n35) );
  OAI222X4 U56 ( .A0(n97), .A1(n101), .B0(n97), .B1(n940), .C0(n940), .C1(n101), .Y(chosen_RX_bit) );
  NOR3X1 I102 ( .A(n104), .B(current_RXD), .C(Uart_mode0), .Y(n45) );
  NOR4X1 I103 ( .A(pr_st[1]), .B(set_RI), .C(RI), .D(n50), .Y(n440) );
  NAND4BX1 I104 ( .AN(state_RX[0]), .B(n99), .C(n98), .D(n102), .Y(now_RX_ing)
         );
  NOR3X1 I105 ( .A(state_RX[1]), .B(state_RX[2]), .C(state_RX[3]), .Y(n34) );
  NAND4X1 I106 ( .A(n105), .B(state_RX[1]), .C(n98), .D(n103), .Y(n61) );
  EDFFX1 RX_div16_reg_0_ ( .D(N87), .CK(clk_b), .E(N90), .Q(RX_div16[0]), .QN(
        n105) );
  OR2X2 I107 ( .A(n99), .B(n93), .Y(n110) );
  DFFRX1 state_RX_reg_0_ ( .D(n75), .CK(clk_b), .RN(n74), .Q(state_RX[0]), 
        .QN(n93) );
  AND4X1 I108 ( .A(RX_clk), .B(RX_div16[2]), .C(n100), .D(RX_div16[1]), .Y(
        n107) );
  EDFFX1 RX_div16_reg_3_ ( .D(N91), .CK(clk_b), .E(N90), .Q(RX_div16[3]), .QN(
        n100) );
  NAND3X1 I109 ( .A(n26), .B(n92), .C(n25), .Y(n14) );
  INVX1 I110 ( .A(n20), .Y(n92) );
  NAND3X1 I111 ( .A(n103), .B(n960), .C(n105), .Y(n66) );
  EDFFX1 RX_div16_reg_2_ ( .D(N89), .CK(clk_b), .E(N90), .Q(RX_div16[2]), .QN(
        n103) );
  NAND3X1 I112 ( .A(n98), .B(n102), .C(n99), .Y(N62) );
  INVX2 I113 ( .A(POR), .Y(n74) );
  DFFRHQX1 decision_time_reg ( .D(N30), .CK(clk_b), .RN(n74), .Q(decision_time) );
  DFFRX1 state_RX_reg_2_ ( .D(n77), .CK(clk_b), .RN(n74), .Q(state_RX[2]), 
        .QN(n98) );
  EDFFX1 RX_div16_reg_1_ ( .D(N88), .CK(clk_b), .E(N90), .Q(RX_div16[1]), .QN(
        n960) );
  DFFRX2 state_RX_reg_1_ ( .D(n76), .CK(clk_b), .RN(n74), .Q(state_RX[1]), 
        .QN(n99) );
  DFFRX1 state_RX_reg_3_ ( .D(n78), .CK(clk_b), .RN(n74), .Q(state_RX[3]), 
        .QN(n102) );
  AND2X1 I114 ( .A(RX_div16_inc[3]), .B(n106), .Y(N91) );
  AND2X1 I115 ( .A(RX_div16_inc[2]), .B(n106), .Y(N89) );
  AND2X1 I116 ( .A(RX_div16_inc[1]), .B(n106), .Y(N88) );
  INVX1 I117 ( .A(RX_clk), .Y(n39) );
  NAND3X1 I118 ( .A(RX_step_one), .B(now_RX_ing), .C(n26), .Y(n25) );
  INVX1 I119 ( .A(state_RX[3]), .Y(n13) );
  INVX1 I120 ( .A(state_RX[2]), .Y(n16) );
  INVX1 I121 ( .A(n52), .Y(n71) );
  INVX2 I122 ( .A(sw_rst), .Y(n108) );
  OR3X2 I123 ( .A(sw_rst), .B(Uart_mode0), .C(n39), .Y(n52) );
  NOR2X1 I124 ( .A(n460), .B(n52), .Y(n106) );
  OR2X2 I125 ( .A(n106), .B(n24), .Y(N90) );
  INVX2 I126 ( .A(Uart_mode0), .Y(n33) );
  INVX1 I127 ( .A(n24), .Y(n26) );
  INVX1 I128 ( .A(n18), .Y(n15) );
  EDFFX1 set_RI_reg ( .D(N85), .CK(clk_b), .E(N84), .Q(set_RI) );
  AND2X2 I129 ( .A(n53), .B(n108), .Y(N85) );
  OAI2BB1X1 I130 ( .A0N(RX_div16_carry), .A1N(n71), .B0(n72), .Y(N31) );
  OR2X2 I131 ( .A(n20), .B(n25), .Y(n18) );
  INVX1 I132 ( .A(n300), .Y(n310) );
  AND2X2 U98 ( .A(n870), .B(n108), .Y(n75) );
  OR2X2 I133 ( .A(n43), .B(sw_rst), .Y(n24) );
  INVX1 I134 ( .A(n21), .Y(n43) );
  INVX1 I135 ( .A(Uart_mode1), .Y(n36) );
  OR3X2 I136 ( .A(Uart_mode1), .B(Uart_mode0), .C(chosen_RX_bit), .Y(n37) );
  DFFSX1 before_RXD_reg ( .D(n80), .CK(clk_b), .SN(n74), .QN(n104) );
  DFFSX1 current_RXD_reg ( .D(n79), .CK(clk_b), .SN(n74), .Q(current_RXD), 
        .QN(n950) );
  EDFFX1 pin_sample8_reg ( .D(N49), .CK(clk_b), .E(N48), .QN(n97) );
  EDFFX1 pin_sample6_reg ( .D(N49), .CK(clk_b), .E(N44), .QN(n940) );
  EDFFX1 pin_sample7_reg ( .D(N49), .CK(clk_b), .E(N46), .QN(n101) );
  OR4X2 I137 ( .A(Uart_mode1), .B(n99), .C(Uart_mode3), .D(Uart_mode2), .Y(n65) );
  OR3X2 I138 ( .A(sw_rst), .B(Z_update), .C(n53), .Y(N84) );
  INVX1 I139 ( .A(chosen_RX_bit), .Y(n41) );
  INVX1 I140 ( .A(now_RX_ing), .Y(n460) );
  AND2X2 U100 ( .A(n108), .B(n890), .Y(n77) );
  OAI2BB2X1 I141 ( .A0N(N95), .A1N(n15), .B0(n14), .B1(n16), .Y(n890) );
  XNOR2X1 I142 ( .A(n109), .B(n110), .Y(N95) );
  OAI22X1 I143 ( .A0(n33), .A1(n950), .B0(Uart_mode0), .B1(n41), .Y(
        RX_shift_bit) );
  DFFRHQX1 RX_step_one_reg ( .D(N31), .CK(clk_b), .RN(n74), .Q(RX_step_one) );
  OR3X1 I144 ( .A(sw_rst), .B(n47), .C(n50), .Y(n72) );
  OAI2BB1X1 I145 ( .A0N(RX_clk), .A1N(current_RXD), .B0(n108), .Y(N49) );
  OAI2BB1X1 I146 ( .A0N(n107), .A1N(n105), .B0(n108), .Y(N44) );
  OAI2BB1X1 I147 ( .A0N(RX_div16[0]), .A1N(n107), .B0(n108), .Y(N46) );
  OAI2BB1X1 I148 ( .A0N(n71), .A1N(n73), .B0(n72), .Y(N30) );
  AND4X2 I149 ( .A(RX_div16[3]), .B(n103), .C(RX_div16[0]), .D(RX_div16_inc[1]), .Y(n73) );
  NAND2BX1 U96 ( .AN(n82), .B(n108), .Y(n79) );
  OAI2BB2X1 I150 ( .A0N(pin_RXD), .A1N(RX_clk), .B0(RX_clk), .B1(n950), .Y(n82) );
  NAND2BX1 U97 ( .AN(n81), .B(n108), .Y(n80) );
  OAI2BB1X1 I151 ( .A0N(RX_div16_inc[0]), .A1N(n106), .B0(n26), .Y(N87) );
  OAI31X1 I152 ( .A0(n66), .A1(n100), .A2(n39), .B0(n108), .Y(N48) );
  OR4X2 I153 ( .A(n13), .B(n960), .C(n100), .D(n61), .Y(n300) );
  OR4X2 I154 ( .A(Uart_mode2), .B(Uart_mode3), .C(state_RX[0]), .D(n300), .Y(
        n28) );
  AND3X2 I155 ( .A(decision_time), .B(n33), .C(n34), .Y(n32) );
  NAND3BX1 I156 ( .AN(pr_st[2]), .B(pr_st[0]), .C(Uart_mode0), .Y(n50) );
  INVX1 I157 ( .A(pr_st[1]), .Y(n47) );
  INVX1 I158 ( .A(SM2), .Y(n54) );
  AOI211X1 I159 ( .A0(SM2), .A1(n41), .B0(state_RX[0]), .C0(RI), .Y(n55) );
  OR4X2 I160 ( .A(n13), .B(n620), .C(n630), .D(n64), .Y(n29) );
  INVX1 I161 ( .A(decision_time), .Y(n620) );
  XOR2X1 I162 ( .A(n93), .B(state_RX[1]), .Y(n630) );
  OAI211X1 I163 ( .A0(state_RX[1]), .A1(Uart_mode0), .B0(n16), .C0(n65), .Y(
        n64) );
  AND2X2 U99 ( .A(n108), .B(n880), .Y(n76) );
  OAI2BB2X1 I164 ( .A0N(N94), .A1N(n15), .B0(n99), .B1(n14), .Y(n880) );
  XOR2X1 I165 ( .A(state_RX[1]), .B(state_RX[0]), .Y(N94) );
  AND2X2 U101 ( .A(n108), .B(n900), .Y(n78) );
  OAI2BB2X1 I166 ( .A0N(N96), .A1N(n15), .B0(n13), .B1(n14), .Y(n900) );
  XOR2X1 I167 ( .A(state_RX[3]), .B(n111), .Y(N96) );
  NOR2X1 I168 ( .A(n110), .B(n98), .Y(n111) );
  AND3X2 I169 ( .A(N62), .B(N63), .C(decision_time), .Y(RX_shift) );
  OAI21X1 I170 ( .A0(state_RX[2]), .A1(state_RX[1]), .B0(state_RX[3]), .Y(N63)
         );
  BUFX3 I171 ( .A(state_RX[2]), .Y(n109) );
  NAND3BX1 I172 ( .AN(now_TX_bit), .B(mode0_TX_ing), .C(Uart_mode0), .Y(
        Mode0_data_RXD) );
  AND2X2 I173 ( .A(N62), .B(Uart_mode0), .Y(mode0_RX_ing) );
  RX_DW01_inc_5_0 add_116 ( .A({1'b0, RX_div16}), .SUM({RX_div16_carry, 
        RX_div16_inc}) );
endmodule


module RX_DW01_inc_5_0 ( A, SUM );
  input [4:0] A;
  output [4:0] SUM;
  wire   carry_3_, carry_2_;

  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(SUM[4]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
endmodule


module uart_sfr ( POR, sw_rst, clk_b, pr_st, SFR_wr, SFR_bus, SCON_sel, 
        SBUF_sel, SADEN_sel, SADDR_sel, Uart_mode0, Uart_mode1, Uart_mode2, 
        Uart_mode3, SMOD1_update, SMOD1, SMOD0, T1_overflow, T2_uart_clk, TCLK, 
        RCLK, RX_clk, TX_clk, now_TX_bit, TX_shift_bit, TX_shift, RX_shift_bit, 
        chosen_RX_bit, RX_shift, set_TI, set_RI, set_FE, SM2, REN, TB8, RI, 
        ua_intr, SADDR_match, SFR_wr_SBUF, UART_SFR_OUT );
  input [2:0] pr_st;
  input [7:0] SFR_bus;
  output [7:0] UART_SFR_OUT;
  input POR, sw_rst, clk_b, SFR_wr, SCON_sel, SBUF_sel, SADEN_sel, SADDR_sel,
         SMOD1_update, SMOD1, SMOD0, T1_overflow, T2_uart_clk, TCLK, RCLK,
         TX_shift_bit, TX_shift, RX_shift_bit, chosen_RX_bit, RX_shift, set_TI,
         set_RI, set_FE;
  output Uart_mode0, Uart_mode1, Uart_mode2, Uart_mode3, RX_clk, TX_clk,
         now_TX_bit, SM2, REN, TB8, RI, ua_intr, SADDR_match, SFR_wr_SBUF;
  wire   scon_mode_1_, SADEN_7_, SADEN_5_, SADEN_4_, SADEN_3_, SADEN_0_,
         SCON_TMP_6_, FE, N26, N39, N43, N47, N49, N50, N51, N52, N53, N54,
         N55, N56, RXBUF_wr_en, N62, T2_overflow_sel, T2_uart_clk_delay0,
         T2_uart_clk_delay1, T2_uart_clk_delay2, N83, even_state, N88,
         T1_overflow_div2, N96, N97, N98, N99, N100, N101, N102, N103, N105,
         N106, N107, N108, N109, N110, N111, N112, N120, N122, N123, N124,
         N126, N128, N129, N130, N132, n2, n4, n5, n6, n7, n8, n9, n10, n11,
         n12, n14, n16, n18, n19, n20, n21, n22, n25, n260, n29, n30, n33, n36,
         n38, n40, n430, n44, n45, n46, n470, n48, n490, n500, n510, n520,
         n530, n540, n550, n560, n57, n58, n59, n61, n620, n63, n64, n65, n66,
         n67, n68, n69, n70, n71, n72, n73, n75, n76, n77, n78, n79, n80, n81,
         n82, n84, n85, n86, n87, n880, n89, n90, n91, n92, n93, n94, n95,
         n960, n990, n1000, n1010, n1030, n104, n1080, n1090, n1100, n1110,
         n1120, n113, n114, n115, n116, n117, n118, n119, n1200, n121, n1220,
         n1230, n125, n1260, n127, n1280, n1290, n1300, n131, n1320, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n145, n146, n147, n148, n149;
  wire   [7:0] SADDR;
  wire   [7:0] RXBUF;
  wire   [7:0] RX_shift_reg;

  AOI221X4 U10 ( .A0(SADDR_sel), .A1(SADDR[7]), .B0(SADEN_sel), .B1(SADEN_7_), 
        .C0(n20), .Y(n19) );
  OAI31X4 U34 ( .A0(n44), .A1(n45), .A2(n46), .B0(n470), .Y(TX_clk) );
  OAI222X4 U41 ( .A0(n520), .A1(n134), .B0(n134), .B1(n21), .C0(n530), .C1(
        n540), .Y(n510) );
  AOI221X4 U53 ( .A0(SADEN_3_), .A1(n65), .B0(SADEN_5_), .B1(n66), .C0(n67), 
        .Y(n64) );
  AOI221X4 U61 ( .A0(SADEN_0_), .A1(n70), .B0(SADEN_4_), .B1(n71), .C0(n72), 
        .Y(n63) );
  AOI33X4 U70 ( .A0(n80), .A1(n81), .A2(n82), .B0(T2_overflow_sel), .B1(RCLK), 
        .B2(SCON_TMP_6_), .Y(n79) );
  OAI32X4 U113 ( .A0(n57), .A1(n21), .A2(n550), .B0(sw_rst), .B1(n990), .Y(N26) );
  NAND3X4 U125 ( .A(TX_shift), .B(n147), .C(n500), .Y(n90) );
  AND3X2 I170 ( .A(n149), .B(SFR_wr), .C(SADDR_sel), .Y(n145) );
  OAI22X1 I171 ( .A0(n880), .A1(n93), .B0(n90), .B1(n10), .Y(N49) );
  NAND2X1 I172 ( .A(n137), .B(scon_mode_1_), .Y(n48) );
  AOI32X4 I173 ( .A0(chosen_RX_bit), .A1(set_RI), .A2(n77), .B0(n1260), .B1(
        SFR_bus[2]), .Y(n95) );
  INVX1 I174 ( .A(n530), .Y(n1260) );
  DFFRX1 SCON_reg_6_ ( .D(n113), .CK(clk_b), .RN(n1090), .Q(SCON_TMP_6_), .QN(
        n137) );
  INVX4 I175 ( .A(n77), .Y(Uart_mode0) );
  OR2X2 I176 ( .A(sw_rst), .B(n530), .Y(n57) );
  OR2X2 I177 ( .A(sw_rst), .B(n960), .Y(n87) );
  AND2X2 I178 ( .A(SCON_TMP_6_), .B(n134), .Y(Uart_mode1) );
  INVX1 I179 ( .A(POR), .Y(n1090) );
  AOI32X1 I180 ( .A0(T2_overflow_sel), .A1(TCLK), .A2(n48), .B0(Uart_mode2), 
        .B1(n490), .Y(n470) );
  DFFRX1 SCON_reg_5_ ( .D(n1120), .CK(clk_b), .RN(n1090), .Q(SM2), .QN(n1320)
         );
  DFFRX1 SCON_reg_7_ ( .D(n114), .CK(clk_b), .RN(n1090), .Q(scon_mode_1_), 
        .QN(n134) );
  EDFFX1 SCON_reg_0_ ( .D(N47), .CK(clk_b), .E(N129), .Q(RI), .QN(n136) );
  DFFRX1 SCON_reg_4_ ( .D(n1110), .CK(clk_b), .RN(n1090), .Q(REN), .QN(n143)
         );
  INVX2 I181 ( .A(n149), .Y(n148) );
  OR2X2 I182 ( .A(n1030), .B(n104), .Y(n500) );
  INVX2 I183 ( .A(SFR_wr), .Y(n104) );
  NOR3X4 I184 ( .A(n148), .B(n104), .C(n22), .Y(n146) );
  INVX2 I185 ( .A(n144), .Y(n880) );
  INVX2 I186 ( .A(SADDR_sel), .Y(n30) );
  AND2X1 I187 ( .A(n145), .B(SFR_bus[7]), .Y(N103) );
  AND2X1 I188 ( .A(n145), .B(SFR_bus[6]), .Y(N102) );
  AND2X1 I189 ( .A(n145), .B(SFR_bus[5]), .Y(N101) );
  AND2X1 I190 ( .A(n145), .B(SFR_bus[4]), .Y(N100) );
  AND2X1 I191 ( .A(n145), .B(SFR_bus[3]), .Y(N99) );
  AND2X1 I192 ( .A(n146), .B(SFR_bus[7]), .Y(N112) );
  AND2X1 I193 ( .A(n146), .B(SFR_bus[6]), .Y(N111) );
  AND2X1 I194 ( .A(n146), .B(SFR_bus[5]), .Y(N110) );
  AND2X1 I195 ( .A(n146), .B(SFR_bus[4]), .Y(N109) );
  AND2X1 I196 ( .A(n146), .B(SFR_bus[3]), .Y(N108) );
  AND2X1 I197 ( .A(n146), .B(SFR_bus[2]), .Y(N107) );
  AND2X1 I198 ( .A(SFR_bus[2]), .B(n145), .Y(N98) );
  INVX1 I199 ( .A(SCON_sel), .Y(n25) );
  DFFTRX1 T2_uart_clk_delay2_reg ( .D(T2_uart_clk_delay1), .CK(clk_b), .RN(
        n147), .Q(T2_uart_clk_delay2) );
  DFFTRX1 T2_uart_clk_delay1_reg ( .D(T2_uart_clk_delay0), .CK(clk_b), .RN(
        n147), .Q(T2_uart_clk_delay1) );
  EDFFX1 SADDR_reg_0_ ( .D(N96), .CK(clk_b), .E(N123), .Q(SADDR[0]), .QN(n1290) );
  EDFFX1 SADEN_reg_0_ ( .D(N105), .CK(clk_b), .E(N124), .Q(SADEN_0_), .QN(n135) );
  OR2X2 I200 ( .A(n520), .B(sw_rst), .Y(n1010) );
  INVX1 I201 ( .A(n57), .Y(n560) );
  INVX4 I202 ( .A(sw_rst), .Y(n147) );
  EDFFX1 SADDR_reg_1_ ( .D(N97), .CK(clk_b), .E(N123), .Q(SADDR[1]) );
  EDFFX1 SADEN_reg_1_ ( .D(N106), .CK(clk_b), .E(N124), .QN(n127) );
  OR2X2 I203 ( .A(n145), .B(sw_rst), .Y(N123) );
  OR2X2 I204 ( .A(n146), .B(sw_rst), .Y(N124) );
  NOR2X1 I205 ( .A(n148), .B(n500), .Y(n144) );
  INVX1 I206 ( .A(n500), .Y(SFR_wr_SBUF) );
  INVX1 I207 ( .A(n530), .Y(n520) );
  EDFFX1 SADEN_reg_7_ ( .D(N112), .CK(clk_b), .E(N124), .Q(SADEN_7_), .QN(n142) );
  EDFFX1 SADDR_reg_7_ ( .D(N103), .CK(clk_b), .E(N123), .Q(SADDR[7]) );
  OR3X2 I208 ( .A(n148), .B(n89), .C(n144), .Y(N130) );
  EDFFX1 SADDR_reg_6_ ( .D(N102), .CK(clk_b), .E(N123), .Q(SADDR[6]) );
  EDFFX1 SADDR_reg_2_ ( .D(N98), .CK(clk_b), .E(N123), .Q(SADDR[2]) );
  EDFFX1 SADDR_reg_4_ ( .D(N100), .CK(clk_b), .E(N123), .Q(SADDR[4]), .QN(n133) );
  EDFFX1 SADDR_reg_5_ ( .D(N101), .CK(clk_b), .E(N123), .Q(SADDR[5]) );
  EDFFX1 SADDR_reg_3_ ( .D(N99), .CK(clk_b), .E(N123), .Q(SADDR[3]) );
  EDFFX1 SADEN_reg_3_ ( .D(N108), .CK(clk_b), .E(N124), .Q(SADEN_3_), .QN(n139) );
  EDFFX1 SADEN_reg_5_ ( .D(N110), .CK(clk_b), .E(N124), .Q(SADEN_5_), .QN(n140) );
  EDFFX1 SADEN_reg_4_ ( .D(N109), .CK(clk_b), .E(N124), .Q(SADEN_4_), .QN(n141) );
  EDFFX1 SADEN_reg_6_ ( .D(N111), .CK(clk_b), .E(N124), .QN(n131) );
  EDFFX1 SADEN_reg_2_ ( .D(N107), .CK(clk_b), .E(N124), .QN(n138) );
  INVX1 I209 ( .A(SBUF_sel), .Y(n1030) );
  OR2X2 I210 ( .A(n25), .B(n104), .Y(n530) );
  INVX1 I211 ( .A(sw_rst), .Y(n149) );
  DFFHQX2 RXBUF_wr_en_reg ( .D(N62), .CK(clk_b), .Q(RXBUF_wr_en) );
  INVX2 I212 ( .A(SADEN_sel), .Y(n22) );
  INVX1 I213 ( .A(SFR_bus[7]), .Y(n550) );
  INVX1 I214 ( .A(SFR_bus[2]), .Y(n91) );
  INVX1 I215 ( .A(SFR_bus[3]), .Y(n620) );
  INVX1 I216 ( .A(SFR_bus[5]), .Y(n59) );
  INVX1 I217 ( .A(SFR_bus[4]), .Y(n61) );
  INVX1 I218 ( .A(SFR_bus[6]), .Y(n58) );
  INVX1 I219 ( .A(set_FE), .Y(n990) );
  INVX1 I220 ( .A(n90), .Y(n89) );
  OR2X2 I221 ( .A(set_FE), .B(n1010), .Y(N126) );
  INVX1 I222 ( .A(n87), .Y(N62) );
  OAI22X1 I223 ( .A0(n95), .A1(n87), .B0(n95), .B1(n57), .Y(N39) );
  AND2X2 U169 ( .A(n147), .B(n119), .Y(n114) );
  AND2X2 I224 ( .A(n510), .B(n147), .Y(n119) );
  OR2X2 I225 ( .A(SMOD0), .B(n550), .Y(n540) );
  OR3X2 I226 ( .A(Uart_mode0), .B(n16), .C(Uart_mode2), .Y(n14) );
  INVX2 I227 ( .A(n48), .Y(Uart_mode2) );
  AND2X2 U165 ( .A(n115), .B(n147), .Y(n1100) );
  OAI22X1 I228 ( .A0(n560), .A1(n1300), .B0(n57), .B1(n620), .Y(n115) );
  AND2X2 U167 ( .A(n147), .B(n117), .Y(n1120) );
  OAI22X1 I229 ( .A0(n560), .A1(n1320), .B0(n57), .B1(n59), .Y(n117) );
  AND2X2 U168 ( .A(n147), .B(n118), .Y(n113) );
  OAI22X1 I230 ( .A0(n560), .A1(n137), .B0(n57), .B1(n58), .Y(n118) );
  EDFFX1 SCON_reg_1_ ( .D(N43), .CK(clk_b), .E(N128), .QN(n1280) );
  INVX1 I231 ( .A(SMOD0), .Y(n21) );
  DFFRX1 SCON_reg_3_ ( .D(n1100), .CK(clk_b), .RN(n1090), .Q(TB8), .QN(n1300)
         );
  EDFFTRX1 RX_shift_reg_reg_5_ ( .D(RX_shift_reg[6]), .CK(clk_b), .E(RX_shift), 
        .RN(n147), .Q(RX_shift_reg[5]) );
  EDFFTRX1 RX_shift_reg_reg_4_ ( .D(RX_shift_reg[5]), .CK(clk_b), .E(RX_shift), 
        .RN(n147), .Q(RX_shift_reg[4]) );
  EDFFTRX1 RX_shift_reg_reg_3_ ( .D(RX_shift_reg[4]), .CK(clk_b), .E(RX_shift), 
        .RN(n147), .Q(RX_shift_reg[3]) );
  EDFFTRX1 RX_shift_reg_reg_0_ ( .D(RX_shift_reg[1]), .CK(clk_b), .E(RX_shift), 
        .RN(n147), .Q(RX_shift_reg[0]) );
  INVX1 I232 ( .A(n80), .Y(n45) );
  INVX1 I233 ( .A(n78), .Y(n125) );
  DFFHQX1 T2_uart_clk_delay0_reg ( .D(N83), .CK(clk_b), .Q(T2_uart_clk_delay0)
         );
  OR3X2 I234 ( .A(even_state), .B(SMOD1_update), .C(SMOD1), .Y(n490) );
  OAI221X4 I235 ( .A0(n76), .A1(n48), .B0(n77), .B1(n78), .C0(n79), .Y(RX_clk)
         );
  INVX1 I236 ( .A(n490), .Y(n76) );
  INVX1 I237 ( .A(RCLK), .Y(n81) );
  OAI221X4 I238 ( .A0(n22), .A1(n127), .B0(n25), .B1(n1280), .C0(n40), .Y(
        UART_SFR_OUT[1]) );
  AOI22X1 I239 ( .A0(RXBUF[1]), .A1(SBUF_sel), .B0(SADDR[1]), .B1(SADDR_sel), 
        .Y(n40) );
  OAI221X4 I240 ( .A0(n30), .A1(n1290), .B0(n22), .B1(n135), .C0(n430), .Y(
        UART_SFR_OUT[0]) );
  AOI22X1 I241 ( .A0(SCON_sel), .A1(RI), .B0(RXBUF[0]), .B1(SBUF_sel), .Y(n430) );
  INVX1 I242 ( .A(T1_overflow), .Y(n46) );
  OR2X2 I243 ( .A(TCLK), .B(Uart_mode2), .Y(n44) );
  OAI221X4 I244 ( .A0(n12), .A1(n136), .B0(n14), .B1(n11), .C0(n1280), .Y(
        ua_intr) );
  INVX1 I245 ( .A(n14), .Y(n12) );
  OAI22X1 I246 ( .A0(n90), .A1(n9), .B0(n92), .B1(n880), .Y(N50) );
  OAI22X1 I247 ( .A0(n148), .A1(n94), .B0(n57), .B1(n92), .Y(N43) );
  INVX1 I248 ( .A(set_TI), .Y(n94) );
  OAI22X1 I249 ( .A0(n90), .A1(n4), .B0(n58), .B1(n880), .Y(N55) );
  OAI22X1 I250 ( .A0(n90), .A1(n5), .B0(n59), .B1(n880), .Y(N54) );
  OAI22X1 I251 ( .A0(n90), .A1(n6), .B0(n61), .B1(n880), .Y(N53) );
  OAI22X1 I252 ( .A0(n90), .A1(n7), .B0(n620), .B1(n880), .Y(N52) );
  OAI22X1 I253 ( .A0(n90), .A1(n8), .B0(n91), .B1(n880), .Y(N51) );
  OR2X2 I254 ( .A(SCON_TMP_6_), .B(scon_mode_1_), .Y(n77) );
  OAI2BB2X1 I255 ( .A0N(TX_shift_bit), .A1N(n89), .B0(n550), .B1(n880), .Y(N56) );
  OR2X2 I256 ( .A(RCLK), .B(TCLK), .Y(n16) );
  NAND2X1 I257 ( .A(n18), .B(n19), .Y(UART_SFR_OUT[7]) );
  AOI32X1 I258 ( .A0(SMOD0), .A1(FE), .A2(SCON_sel), .B0(SBUF_sel), .B1(
        RXBUF[7]), .Y(n18) );
  AND3X2 I259 ( .A(SCON_sel), .B(n21), .C(scon_mode_1_), .Y(n20) );
  AND2X2 U166 ( .A(n147), .B(n116), .Y(n1110) );
  OAI22X1 I260 ( .A0(n560), .A1(n143), .B0(n57), .B1(n61), .Y(n116) );
  OAI221X4 I261 ( .A0(n22), .A1(n131), .B0(n137), .B1(n25), .C0(n260), .Y(
        UART_SFR_OUT[6]) );
  AOI22X1 I262 ( .A0(RXBUF[6]), .A1(SBUF_sel), .B0(SADDR[6]), .B1(SADDR_sel), 
        .Y(n260) );
  OAI221X4 I263 ( .A0(n22), .A1(n140), .B0(n25), .B1(n1320), .C0(n29), .Y(
        UART_SFR_OUT[5]) );
  AOI22X1 I264 ( .A0(RXBUF[5]), .A1(SBUF_sel), .B0(SADDR[5]), .B1(SADDR_sel), 
        .Y(n29) );
  OAI221X4 I265 ( .A0(n22), .A1(n139), .B0(n25), .B1(n1300), .C0(n36), .Y(
        UART_SFR_OUT[3]) );
  AOI22X1 I266 ( .A0(RXBUF[3]), .A1(SBUF_sel), .B0(SADDR[3]), .B1(SADDR_sel), 
        .Y(n36) );
  OAI221X4 I267 ( .A0(n22), .A1(n138), .B0(n25), .B1(n2), .C0(n38), .Y(
        UART_SFR_OUT[2]) );
  AOI22X1 I268 ( .A0(RXBUF[2]), .A1(SBUF_sel), .B0(SADDR[2]), .B1(SADDR_sel), 
        .Y(n38) );
  OAI221X4 I269 ( .A0(n30), .A1(n133), .B0(n22), .B1(n141), .C0(n33), .Y(
        UART_SFR_OUT[4]) );
  AOI22X1 I270 ( .A0(REN), .A1(SCON_sel), .B0(RXBUF[4]), .B1(SBUF_sel), .Y(n33) );
  AND2X2 I271 ( .A(SCON_TMP_6_), .B(scon_mode_1_), .Y(Uart_mode3) );
  OR3X2 I272 ( .A(pr_st[2]), .B(n86), .C(n1080), .Y(n78) );
  INVX1 I273 ( .A(pr_st[1]), .Y(n1080) );
  INVX1 I274 ( .A(pr_st[0]), .Y(n86) );
  OR2X2 I275 ( .A(SMOD1), .B(T1_overflow_div2), .Y(n80) );
  AND2X2 I276 ( .A(n63), .B(n64), .Y(SADDR_match) );
  XOR2X1 I277 ( .A(n1230), .B(SADDR[1]), .Y(n69) );
  XOR2X1 I278 ( .A(n121), .B(SADDR[6]), .Y(n75) );
  XOR2X1 I279 ( .A(n1220), .B(SADDR[2]), .Y(n68) );
  XOR2X1 I280 ( .A(n1200), .B(SADDR[7]), .Y(n73) );
  OAI2BB1X1 I281 ( .A0N(set_RI), .A1N(n77), .B0(n1000), .Y(N132) );
  INVX1 I282 ( .A(n1010), .Y(n1000) );
  XOR2X1 I283 ( .A(SADDR[3]), .B(RX_shift_reg[3]), .Y(n65) );
  XOR2X1 I284 ( .A(SADDR[5]), .B(RX_shift_reg[5]), .Y(n66) );
  OAI22X1 I285 ( .A0(n68), .A1(n138), .B0(n69), .B1(n127), .Y(n67) );
  XOR2X1 I286 ( .A(SADDR[0]), .B(RX_shift_reg[0]), .Y(n70) );
  XOR2X1 I287 ( .A(SADDR[4]), .B(RX_shift_reg[4]), .Y(n71) );
  OAI22X1 I288 ( .A0(n73), .A1(n142), .B0(n75), .B1(n131), .Y(n72) );
  OR2X2 I289 ( .A(set_TI), .B(n1010), .Y(N128) );
  OR2X2 I290 ( .A(set_RI), .B(n1010), .Y(N129) );
  AND2X2 I291 ( .A(T1_overflow), .B(SCON_TMP_6_), .Y(n82) );
  OR3X2 I292 ( .A(SMOD1), .B(T1_overflow), .C(sw_rst), .Y(N120) );
  AND4X2 I293 ( .A(T2_uart_clk), .B(n16), .C(n77), .D(n147), .Y(N83) );
  AND4X2 I294 ( .A(n84), .B(n85), .C(n86), .D(n147), .Y(N88) );
  INVX1 I295 ( .A(SMOD1), .Y(n85) );
  XOR2X1 I296 ( .A(pr_st[2]), .B(pr_st[1]), .Y(n84) );
  AND3X2 I297 ( .A(T1_overflow), .B(n147), .C(n45), .Y(N122) );
  INVX1 I298 ( .A(set_RI), .Y(n960) );
  EDFFTRX1 RXBUF_reg_0_ ( .D(RX_shift_reg[0]), .CK(clk_b), .E(RXBUF_wr_en), 
        .RN(n147), .Q(RXBUF[0]) );
  EDFFTRX1 RXBUF_reg_1_ ( .D(RX_shift_reg[1]), .CK(clk_b), .E(RXBUF_wr_en), 
        .RN(n147), .Q(RXBUF[1]) );
  EDFFTRX1 RI_delay_reg ( .D(RI), .CK(clk_b), .E(n125), .RN(n147), .QN(n11) );
  EDFFX1 FE_reg ( .D(N26), .CK(clk_b), .E(N126), .Q(FE) );
  EDFFTRX1 RXBUF_reg_6_ ( .D(RX_shift_reg[6]), .CK(clk_b), .E(RXBUF_wr_en), 
        .RN(n147), .Q(RXBUF[6]) );
  EDFFTRX1 RXBUF_reg_5_ ( .D(RX_shift_reg[5]), .CK(clk_b), .E(RXBUF_wr_en), 
        .RN(n147), .Q(RXBUF[5]) );
  EDFFTRX1 RXBUF_reg_3_ ( .D(RX_shift_reg[3]), .CK(clk_b), .E(RXBUF_wr_en), 
        .RN(n147), .Q(RXBUF[3]) );
  EDFFTRX1 RXBUF_reg_2_ ( .D(RX_shift_reg[2]), .CK(clk_b), .E(RXBUF_wr_en), 
        .RN(n147), .Q(RXBUF[2]) );
  EDFFTRX1 RXBUF_reg_4_ ( .D(RX_shift_reg[4]), .CK(clk_b), .E(RXBUF_wr_en), 
        .RN(n147), .Q(RXBUF[4]) );
  EDFFX1 SCON_reg_2_ ( .D(N39), .CK(clk_b), .E(N132), .QN(n2) );
  EDFFTRX1 RXBUF_reg_7_ ( .D(RX_shift_reg[7]), .CK(clk_b), .E(RXBUF_wr_en), 
        .RN(n147), .Q(RXBUF[7]) );
  EDFFTRX1 RX_shift_reg_reg_7_ ( .D(RX_shift_bit), .CK(clk_b), .E(RX_shift), 
        .RN(n147), .Q(RX_shift_reg[7]), .QN(n1200) );
  EDFFTRX1 RX_shift_reg_reg_6_ ( .D(RX_shift_reg[7]), .CK(clk_b), .E(RX_shift), 
        .RN(n147), .Q(RX_shift_reg[6]), .QN(n121) );
  EDFFTRX1 RX_shift_reg_reg_2_ ( .D(RX_shift_reg[3]), .CK(clk_b), .E(RX_shift), 
        .RN(n147), .Q(RX_shift_reg[2]), .QN(n1220) );
  EDFFTRX1 RX_shift_reg_reg_1_ ( .D(RX_shift_reg[2]), .CK(clk_b), .E(RX_shift), 
        .RN(n147), .Q(RX_shift_reg[1]), .QN(n1230) );
  EDFFX1 T1_overflow_div2_reg ( .D(N122), .CK(clk_b), .E(N120), .Q(
        T1_overflow_div2) );
  DFFHQX1 even_state_reg ( .D(N88), .CK(clk_b), .Q(even_state) );
  DFFTRX1 T2_overflow_sel_reg ( .D(T2_uart_clk_delay2), .CK(clk_b), .RN(n147), 
        .Q(T2_overflow_sel) );
  EDFFX1 TXBUF_reg_7_ ( .D(N56), .CK(clk_b), .E(N130), .QN(n4) );
  EDFFX1 TXBUF_reg_6_ ( .D(N55), .CK(clk_b), .E(N130), .QN(n5) );
  EDFFX1 TXBUF_reg_5_ ( .D(N54), .CK(clk_b), .E(N130), .QN(n6) );
  EDFFX1 TXBUF_reg_4_ ( .D(N53), .CK(clk_b), .E(N130), .QN(n7) );
  EDFFX1 TXBUF_reg_3_ ( .D(N52), .CK(clk_b), .E(N130), .QN(n8) );
  EDFFX1 TXBUF_reg_2_ ( .D(N51), .CK(clk_b), .E(N130), .QN(n9) );
  EDFFX1 TXBUF_reg_1_ ( .D(N50), .CK(clk_b), .E(N130), .QN(n10) );
  EDFFX1 TXBUF_reg_0_ ( .D(N49), .CK(clk_b), .E(N130), .Q(now_TX_bit) );
  INVX1 I299 ( .A(SFR_bus[1]), .Y(n92) );
  INVX1 I300 ( .A(SFR_bus[0]), .Y(n93) );
  AND2X1 I301 ( .A(n146), .B(SFR_bus[1]), .Y(N106) );
  AND2X1 I302 ( .A(SFR_bus[1]), .B(n145), .Y(N97) );
  AND2X1 I303 ( .A(SFR_bus[0]), .B(n145), .Y(N96) );
  OAI2BB1X1 I304 ( .A0N(SFR_bus[0]), .A1N(n560), .B0(n87), .Y(N47) );
  AND2X1 I305 ( .A(n146), .B(SFR_bus[0]), .Y(N105) );
endmodule


module timer2 ( POR, Z_update, T2MOD_T2OE, pr_st_0, Z2_S1, Z2_S2, sw_rst, 
        clk_b, SFR_wr, SFR_bus, T2CON_sel, T2MOD_sel, TH2_sel, TL2_sel, 
        RCAP2L_sel, RCAP2H_sel, pin_T2, pin_T2EX, T2_CLKOUT, t2_intr, 
        T2_uart_clk, RCLK, TCLK, T2_SFR_OUT );
  input [7:0] SFR_bus;
  output [7:0] T2_SFR_OUT;
  input POR, Z_update, pr_st_0, Z2_S1, Z2_S2, sw_rst, clk_b, SFR_wr, T2CON_sel,
         T2MOD_sel, TH2_sel, TL2_sel, RCAP2L_sel, RCAP2H_sel, pin_T2, pin_T2EX;
  output T2MOD_T2OE, T2_CLKOUT, t2_intr, T2_uart_clk, RCLK, TCLK;
  wire   T2CON_7_, T2CON_6_, T2CON_3_, T2CON_2_, T2CON_1_, T2CON_0_, T2MOD_0_,
         current_T2, current_T2EX, N29, N30, N31, clk_2, T2_flow_flag, set_TF2,
         set_EXF2, RCAP2L_7_, RCAP2L_6_, RCAP2L_5_, RCAP2L_4_, RCAP2L_3_,
         RCAP2L_2_, RCAP2H_7_, RCAP2H_6_, RCAP2H_5_, RCAP2H_4_, RCAP2H_3_,
         RCAP2H_2_, N73, N74, N75, N76, N77, N78, N79, N80, N85, N86, N87, N88,
         N89, N90, N91, N92, N101, N105, N107, N108, N109, N110, N111, N112,
         N114, N115, N116, N117, N118, N119, N120, N121, N132, N133, N134,
         N135, N136, N137, N138, N139, N147, N148, N150, N151, N152, N153,
         N154, N155, N156, N157, N158, N159, N160, N161, N162, N163, N164,
         N165, N166, N167, N168, N170, N171, N172, N173, N174, N175, N176,
         N177, N178, N179, N180, N181, N182, N183, N184, N185, N186, N187,
         N188, N189, N190, N191, N192, N193, N195, N197, N199, N200, N201,
         N202, n7, n12, n14, n15, n18, n21, n24, n27, n300, n310, n32, n35,
         n36, n38, n40, n42, n43, n50, n51, n53, n55, n58, n59, n60, n61, n62,
         n63, n66, n67, n69, n71, n72, n730, n740, n760, n770, n780, n800, n82,
         n83, n84, n850, n860, n870, n880, n890, n900, n910, n93, n94, n97,
         n98, n99, n100, n1010, n102, n103, n104, n1050, n106, n1070, n1100,
         n1120, n113, n1140, n1160, n1170, n1190, n1200, n122, n123, n125,
         n126, n128, n129, n130, n131, n1320, n1330, n1340, n1360, n1370,
         n1390, n140, n142, n143, n145, n146, n1480, n149, n1510, n1520, n1530,
         n1540, n1550, n1560, n1570, n1580, n1590, n1600, n1610, n1620, n1630,
         n1640, n1650, n1660, n1670, n1710, n1720, n1730, n1740, n1750, n1760,
         n1770, n1780, n1810, n1830, n1840, n1850, n1860, n1870, n1880, n1890,
         n1900, n1910, n1920, n194, n196, n1970, n198, n1990, n2000, n2020,
         n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, n213,
         n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, n224,
         n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235,
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246,
         n247, n248, n249, n250, n251, n252, n253, n254, n255, n256, n257,
         n258, n259, n260, n261, n262, n263, n264, n265;
  wire   [7:0] TL2;
  wire   [7:0] TH2;
  wire   SYNOPSYS_UNCONNECTED__0;

  AOI222X4 U8 ( .A0(T2CON_sel), .A1(T2CON_7_), .B0(RCAP2H_sel), .B1(RCAP2H_7_), 
        .C0(RCAP2L_sel), .C1(RCAP2L_7_), .Y(n15) );
  AOI222X4 U10 ( .A0(T2CON_sel), .A1(T2CON_6_), .B0(RCAP2H_6_), .B1(RCAP2H_sel), .C0(RCAP2L_6_), .C1(RCAP2L_sel), .Y(n18) );
  AOI222X4 U12 ( .A0(RCLK), .A1(T2CON_sel), .B0(RCAP2H_5_), .B1(RCAP2H_sel), 
        .C0(RCAP2L_5_), .C1(RCAP2L_sel), .Y(n21) );
  AOI222X4 U14 ( .A0(TCLK), .A1(T2CON_sel), .B0(RCAP2H_4_), .B1(RCAP2H_sel), 
        .C0(RCAP2L_4_), .C1(RCAP2L_sel), .Y(n24) );
  AOI222X4 U16 ( .A0(T2CON_3_), .A1(T2CON_sel), .B0(RCAP2H_3_), .B1(RCAP2H_sel), .C0(RCAP2L_3_), .C1(RCAP2L_sel), .Y(n27) );
  AOI222X4 U18 ( .A0(T2CON_2_), .A1(T2CON_sel), .B0(RCAP2H_2_), .B1(RCAP2H_sel), .C0(RCAP2L_2_), .C1(RCAP2L_sel), .Y(n300) );
  OAI222X4 U20 ( .A0(n12), .A1(n210), .B0(n14), .B1(n220), .C0(n208), .C1(n35), 
        .Y(n32) );
  OAI222X4 U21 ( .A0(n36), .A1(n229), .B0(n38), .B1(n235), .C0(n40), .C1(n218), 
        .Y(n310) );
  OAI222X4 U23 ( .A0(n12), .A1(n209), .B0(n14), .B1(n219), .C0(n35), .C1(n227), 
        .Y(n43) );
  OAI222X4 U24 ( .A0(n36), .A1(n217), .B0(n38), .B1(n236), .C0(n40), .C1(n230), 
        .Y(n42) );
  OAI33X4 U25 ( .A0(n50), .A1(n35), .A2(n51), .B0(n256), .B1(n263), .B2(n208), 
        .Y(n2000) );
  OAI33X4 U26 ( .A0(n50), .A1(n35), .A2(n53), .B0(n256), .B1(n263), .B2(n227), 
        .Y(n1990) );
  OAI33X4 U77 ( .A0(n255), .A1(n218), .A2(n800), .B0(n234), .B1(T2CON_1_), 
        .B2(n82), .Y(n780) );
  OAI33X4 U91 ( .A0(n910), .A1(n239), .A2(n800), .B0(n93), .B1(n227), .B2(n94), 
        .Y(n900) );
  AOI221X4 U115 ( .A0(N168), .A1(n259), .B0(N185), .B1(n257), .C0(n1100), .Y(
        n1070) );
  AOI221X4 U118 ( .A0(N167), .A1(n259), .B0(N184), .B1(n257), .C0(n1140), .Y(
        n113) );
  AOI221X4 U121 ( .A0(N166), .A1(n259), .B0(N183), .B1(n257), .C0(n1170), .Y(
        n1160) );
  AOI221X4 U124 ( .A0(N165), .A1(n259), .B0(N182), .B1(n257), .C0(n1200), .Y(
        n1190) );
  AOI221X4 U127 ( .A0(N164), .A1(n259), .B0(N181), .B1(n257), .C0(n123), .Y(
        n122) );
  AOI221X4 U130 ( .A0(N163), .A1(n259), .B0(N180), .B1(n257), .C0(n126), .Y(
        n125) );
  AOI221X4 U133 ( .A0(N162), .A1(n259), .B0(N179), .B1(n257), .C0(n129), .Y(
        n128) );
  AOI221X4 U136 ( .A0(N161), .A1(n259), .B0(N178), .B1(n257), .C0(n131), .Y(
        n130) );
  AOI221X4 U141 ( .A0(N160), .A1(n259), .B0(N177), .B1(n257), .C0(n1340), .Y(
        n1330) );
  AOI221X4 U144 ( .A0(N159), .A1(n259), .B0(N176), .B1(n257), .C0(n1370), .Y(
        n1360) );
  AOI221X4 U147 ( .A0(N158), .A1(n259), .B0(N175), .B1(n257), .C0(n140), .Y(
        n1390) );
  AOI221X4 U151 ( .A0(N157), .A1(n259), .B0(N174), .B1(n257), .C0(n143), .Y(
        n142) );
  AOI221X4 U155 ( .A0(N156), .A1(n259), .B0(N173), .B1(n257), .C0(n146), .Y(
        n145) );
  AOI221X4 U159 ( .A0(N155), .A1(n259), .B0(N172), .B1(n257), .C0(n149), .Y(
        n1480) );
  AOI221X4 U163 ( .A0(N154), .A1(n259), .B0(N171), .B1(n257), .C0(n1520), .Y(
        n1510) );
  AOI221X4 U167 ( .A0(N153), .A1(n259), .B0(N170), .B1(n257), .C0(n1540), .Y(
        n1530) );
  OR2X4 U169 ( .A(n263), .B(n83), .Y(n1120) );
  OAI32X4 U220 ( .A0(n93), .A1(n1850), .A2(n1860), .B0(n860), .B1(n760), .Y(
        n1780) );
  OAI33X4 U232 ( .A0(n1870), .A1(T2CON_1_), .A2(n238), .B0(n1880), .B1(
        current_T2), .B2(n238), .Y(n69) );
  AOI221X4 U237 ( .A0(clk_2), .A1(T2MOD_T2OE), .B0(clk_2), .B1(n770), .C0(
        n1890), .Y(n1870) );
  OAI32X4 U250 ( .A0(n1920), .A1(n263), .A2(n254), .B0(n59), .B1(n1910), .Y(
        N105) );
  NAND2X1 I269 ( .A(T2CON_3_), .B(n2020), .Y(n1860) );
  NAND3BX1 I270 ( .AN(T2MOD_0_), .B(n208), .C(n204), .Y(n1850) );
  NAND3BX1 I271 ( .AN(n104), .B(n203), .C(T2CON_1_), .Y(n1880) );
  NAND3X1 I272 ( .A(N186), .B(n69), .C(n1830), .Y(n760) );
  NOR2X1 I273 ( .A(n238), .B(T2MOD_T2OE), .Y(n880) );
  NAND2X1 I274 ( .A(n204), .B(T2CON_3_), .Y(n910) );
  NAND2BX2 I275 ( .AN(n66), .B(n67), .Y(N202) );
  NAND2BX2 I276 ( .AN(n66), .B(n72), .Y(N201) );
  AOI21X1 I277 ( .A0(n760), .A1(n83), .B0(N31), .Y(N195) );
  NAND2X1 I278 ( .A(n205), .B(n206), .Y(n770) );
  EDFFX1 T2CON_reg_4_ ( .D(N111), .CK(clk_b), .E(N150), .Q(TCLK), .QN(n206) );
  AND2X1 I279 ( .A(n265), .B(n84), .Y(N192) );
  AOI21X1 I280 ( .A0(n7), .A1(n730), .B0(n740), .Y(n207) );
  INVX1 I281 ( .A(n207), .Y(N199) );
  EDFFX1 T2CON_reg_5_ ( .D(N112), .CK(clk_b), .E(N150), .Q(RCLK), .QN(n205) );
  INVX1 I282 ( .A(SFR_bus[0]), .Y(n53) );
  OR2X2 I283 ( .A(Z2_S2), .B(n263), .Y(N31) );
  EDFFX2 TH2_reg_0_ ( .D(N132), .CK(clk_b), .E(N202), .Q(TH2[0]), .QN(n209) );
  EDFFX2 TH2_reg_1_ ( .D(N133), .CK(clk_b), .E(N202), .Q(TH2[1]), .QN(n210) );
  EDFFX2 TL2_reg_7_ ( .D(N121), .CK(clk_b), .E(N201), .Q(TL2[7]), .QN(n211) );
  EDFFX2 TH2_reg_6_ ( .D(N138), .CK(clk_b), .E(N202), .Q(TH2[6]), .QN(n212) );
  EDFFX2 TH2_reg_5_ ( .D(N137), .CK(clk_b), .E(N202), .Q(TH2[5]), .QN(n213) );
  EDFFX2 TH2_reg_4_ ( .D(N136), .CK(clk_b), .E(N202), .Q(TH2[4]), .QN(n214) );
  EDFFX2 TH2_reg_3_ ( .D(N135), .CK(clk_b), .E(N202), .Q(TH2[3]), .QN(n215) );
  EDFFX2 TH2_reg_2_ ( .D(N134), .CK(clk_b), .E(N202), .Q(TH2[2]), .QN(n216) );
  EDFFX2 TL2_reg_0_ ( .D(N114), .CK(clk_b), .E(N201), .Q(TL2[0]), .QN(n219) );
  EDFFX2 TL2_reg_1_ ( .D(N115), .CK(clk_b), .E(N201), .Q(TL2[1]), .QN(n220) );
  EDFFX2 TH2_reg_7_ ( .D(N139), .CK(clk_b), .E(N202), .Q(TH2[7]), .QN(n221) );
  EDFFX2 TL2_reg_3_ ( .D(N117), .CK(clk_b), .E(N201), .Q(TL2[3]), .QN(n222) );
  EDFFX2 TL2_reg_2_ ( .D(N116), .CK(clk_b), .E(N201), .Q(TL2[2]), .QN(n223) );
  EDFFX2 TL2_reg_6_ ( .D(N120), .CK(clk_b), .E(N201), .Q(TL2[6]), .QN(n224) );
  EDFFX2 TL2_reg_5_ ( .D(N119), .CK(clk_b), .E(N201), .Q(TL2[5]), .QN(n225) );
  EDFFX2 TL2_reg_4_ ( .D(N118), .CK(clk_b), .E(N201), .Q(TL2[4]), .QN(n226) );
  DFFRX1 T2MOD_reg_0_ ( .D(n1970), .CK(clk_b), .RN(n196), .Q(T2MOD_0_), .QN(
        n227) );
  OR3X2 I284 ( .A(n50), .B(n36), .C(n99), .Y(n231) );
  OR3X2 I285 ( .A(n50), .B(n38), .C(n99), .Y(n232) );
  DFFTRX1 clk_2_reg ( .D(pr_st_0), .CK(clk_b), .RN(n265), .Q(clk_2), .QN(n234)
         );
  OR2X4 I286 ( .A(n263), .B(n1010), .Y(n246) );
  EDFFX1 T2_flow_flag_reg ( .D(N195), .CK(clk_b), .E(N193), .Q(T2_flow_flag), 
        .QN(n255) );
  OAI221X4 I287 ( .A0(n236), .A1(n71), .B0(n53), .B1(n67), .C0(n1120), .Y(n131) );
  OAI221X4 I288 ( .A0(n248), .A1(n71), .B0(n62), .B1(n72), .C0(n1120), .Y(n146) );
  OAI221X4 I289 ( .A0(n252), .A1(n71), .B0(n63), .B1(n67), .C0(n1120), .Y(n126) );
  OAI221X4 I290 ( .A0(n217), .A1(n71), .B0(n53), .B1(n72), .C0(n1120), .Y(
        n1540) );
  OAI221X4 I291 ( .A0(n240), .A1(n71), .B0(n62), .B1(n67), .C0(n1120), .Y(n123) );
  OAI221X4 I292 ( .A0(n250), .A1(n71), .B0(n60), .B1(n67), .C0(n1120), .Y(
        n1170) );
  OAI221X4 I293 ( .A0(n251), .A1(n71), .B0(n59), .B1(n67), .C0(n1120), .Y(
        n1140) );
  OAI221X4 I294 ( .A0(n245), .A1(n71), .B0(n58), .B1(n67), .C0(n1120), .Y(
        n1100) );
  INVX1 I295 ( .A(SFR_bus[7]), .Y(n58) );
  OAI221X4 I296 ( .A0(n235), .A1(n71), .B0(n51), .B1(n67), .C0(n1120), .Y(n129) );
  OAI221X4 I297 ( .A0(n229), .A1(n71), .B0(n51), .B1(n72), .C0(n1120), .Y(
        n1520) );
  AND3X1 I298 ( .A(n1570), .B(n1580), .C(n1590), .Y(n1560) );
  INVX12 I299 ( .A(n258), .Y(n71) );
  OAI221X4 I300 ( .A0(n247), .A1(n71), .B0(n63), .B1(n72), .C0(n1120), .Y(n149) );
  OAI221X4 I301 ( .A0(n249), .A1(n71), .B0(n61), .B1(n67), .C0(n1120), .Y(
        n1200) );
  NOR2X4 I302 ( .A(n1590), .B(n1810), .Y(n257) );
  NOR2X4 I303 ( .A(n1830), .B(n1810), .Y(n259) );
  INVX4 I304 ( .A(n264), .Y(n263) );
  NAND3X1 I305 ( .A(n1550), .B(n69), .C(n1560), .Y(n83) );
  EDFFX1 T2CON_reg_0_ ( .D(N107), .CK(clk_b), .E(N150), .Q(T2CON_0_), .QN(n230) );
  INVX1 I306 ( .A(n1910), .Y(n106) );
  INVX1 I307 ( .A(T2CON_sel), .Y(n40) );
  EDFFX1 T2CON_reg_1_ ( .D(N108), .CK(clk_b), .E(N150), .Q(T2CON_1_), .QN(n218) );
  OR2X2 I308 ( .A(n40), .B(n50), .Y(n1910) );
  OR2X2 I309 ( .A(n106), .B(n263), .Y(N150) );
  INVX1 I310 ( .A(RCAP2H_sel), .Y(n38) );
  INVX1 I311 ( .A(RCAP2L_sel), .Y(n36) );
  EDFFX1 T2CON_reg_2_ ( .D(N109), .CK(clk_b), .E(N150), .Q(T2CON_2_), .QN(n238) );
  EDFFX1 T2CON_reg_3_ ( .D(N110), .CK(clk_b), .E(N150), .Q(T2CON_3_), .QN(n233) );
  INVX1 I312 ( .A(n760), .Y(n730) );
  OR3X2 I313 ( .A(n263), .B(n100), .C(n98), .Y(N187) );
  INVX1 I314 ( .A(n231), .Y(n100) );
  OR3X2 I315 ( .A(n263), .B(n97), .C(n98), .Y(N188) );
  INVX1 I316 ( .A(n232), .Y(n97) );
  OR2X2 I317 ( .A(n263), .B(n55), .Y(n50) );
  NOR2X1 I318 ( .A(n35), .B(n55), .Y(n256) );
  INVX2 I319 ( .A(TH2_sel), .Y(n12) );
  INVX1 I320 ( .A(SFR_bus[6]), .Y(n59) );
  INVX1 I321 ( .A(SFR_bus[3]), .Y(n62) );
  INVX1 I322 ( .A(SFR_bus[5]), .Y(n60) );
  INVX1 I323 ( .A(SFR_bus[2]), .Y(n63) );
  INVX1 I324 ( .A(SFR_bus[4]), .Y(n61) );
  INVX2 I325 ( .A(TL2_sel), .Y(n14) );
  INVX1 I326 ( .A(T2MOD_sel), .Y(n35) );
  OR2X2 I327 ( .A(n14), .B(n1320), .Y(n72) );
  OR2X2 I328 ( .A(n12), .B(n1320), .Y(n67) );
  EDFFX1 RCAP2L_reg_1_ ( .D(N74), .CK(clk_b), .E(N187), .QN(n229) );
  EDFFX1 RCAP2L_reg_0_ ( .D(N73), .CK(clk_b), .E(N187), .QN(n217) );
  EDFFX1 RCAP2H_reg_1_ ( .D(N86), .CK(clk_b), .E(N188), .QN(n235) );
  EDFFX1 RCAP2H_reg_0_ ( .D(N85), .CK(clk_b), .E(N188), .QN(n236) );
  AND2X2 I329 ( .A(n106), .B(SFR_bus[3]), .Y(N110) );
  AND2X2 I330 ( .A(n106), .B(SFR_bus[5]), .Y(N112) );
  AND2X2 I331 ( .A(n106), .B(SFR_bus[2]), .Y(N109) );
  AND2X2 I332 ( .A(n106), .B(SFR_bus[4]), .Y(N111) );
  EDFFX1 RCAP2L_reg_7_ ( .D(N80), .CK(clk_b), .E(N187), .Q(RCAP2L_7_), .QN(
        n241) );
  EDFFX1 RCAP2H_reg_7_ ( .D(N92), .CK(clk_b), .E(N188), .Q(RCAP2H_7_), .QN(
        n245) );
  EDFFX1 RCAP2H_reg_6_ ( .D(N91), .CK(clk_b), .E(N188), .Q(RCAP2H_6_), .QN(
        n251) );
  EDFFX1 RCAP2H_reg_5_ ( .D(N90), .CK(clk_b), .E(N188), .Q(RCAP2H_5_), .QN(
        n250) );
  EDFFX1 RCAP2H_reg_4_ ( .D(N89), .CK(clk_b), .E(N188), .Q(RCAP2H_4_), .QN(
        n249) );
  EDFFX1 RCAP2H_reg_3_ ( .D(N88), .CK(clk_b), .E(N188), .Q(RCAP2H_3_), .QN(
        n240) );
  EDFFX1 RCAP2H_reg_2_ ( .D(N87), .CK(clk_b), .E(N188), .Q(RCAP2H_2_), .QN(
        n252) );
  EDFFX1 RCAP2L_reg_6_ ( .D(N79), .CK(clk_b), .E(N187), .Q(RCAP2L_6_), .QN(
        n243) );
  EDFFX1 RCAP2L_reg_5_ ( .D(N78), .CK(clk_b), .E(N187), .Q(RCAP2L_5_), .QN(
        n242) );
  EDFFX1 RCAP2L_reg_4_ ( .D(N77), .CK(clk_b), .E(N187), .Q(RCAP2L_4_), .QN(
        n244) );
  EDFFX1 RCAP2L_reg_3_ ( .D(N76), .CK(clk_b), .E(N187), .Q(RCAP2L_3_), .QN(
        n248) );
  EDFFX1 RCAP2L_reg_2_ ( .D(N75), .CK(clk_b), .E(N187), .Q(RCAP2L_2_), .QN(
        n247) );
  INVX1 I333 ( .A(sw_rst), .Y(n264) );
  INVX1 I334 ( .A(n246), .Y(n98) );
  INVX1 I335 ( .A(SFR_wr), .Y(n55) );
  INVX1 I336 ( .A(n103), .Y(n860) );
  OAI2BB1X1 I337 ( .A0N(SFR_wr), .A1N(T2CON_sel), .B0(n265), .Y(n1050) );
  EDFFX1 set_TF2_reg ( .D(N192), .CK(clk_b), .E(N191), .Q(set_TF2), .QN(n253)
         );
  EDFFX1 set_EXF2_reg ( .D(N190), .CK(clk_b), .E(N189), .Q(set_EXF2), .QN(n254) );
  INVX1 I338 ( .A(sw_rst), .Y(n265) );
  OR2X2 I339 ( .A(n310), .B(n32), .Y(T2_SFR_OUT[1]) );
  OR2X2 I340 ( .A(n42), .B(n43), .Y(T2_SFR_OUT[0]) );
  OAI221X4 I341 ( .A0(n221), .A1(n12), .B0(n211), .B1(n14), .C0(n15), .Y(
        T2_SFR_OUT[7]) );
  OAI221X4 I342 ( .A0(n12), .A1(n212), .B0(n14), .B1(n224), .C0(n18), .Y(
        T2_SFR_OUT[6]) );
  OAI221X4 I343 ( .A0(n12), .A1(n213), .B0(n14), .B1(n225), .C0(n21), .Y(
        T2_SFR_OUT[5]) );
  OAI221X4 I344 ( .A0(n12), .A1(n214), .B0(n14), .B1(n226), .C0(n24), .Y(
        T2_SFR_OUT[4]) );
  OAI221X4 I345 ( .A0(n12), .A1(n215), .B0(n14), .B1(n222), .C0(n27), .Y(
        T2_SFR_OUT[3]) );
  OAI221X4 I346 ( .A0(n12), .A1(n216), .B0(n14), .B1(n223), .C0(n300), .Y(
        T2_SFR_OUT[2]) );
  OAI22X1 I347 ( .A0(n210), .A1(n246), .B0(n51), .B1(n232), .Y(N86) );
  OAI22X1 I348 ( .A0(n51), .A1(n231), .B0(n220), .B1(n246), .Y(N74) );
  OAI22X1 I349 ( .A0(n58), .A1(n231), .B0(n211), .B1(n246), .Y(N80) );
  OAI22X1 I350 ( .A0(n59), .A1(n231), .B0(n224), .B1(n246), .Y(N79) );
  OAI22X1 I351 ( .A0(n60), .A1(n231), .B0(n225), .B1(n246), .Y(N78) );
  OAI22X1 I352 ( .A0(n61), .A1(n231), .B0(n226), .B1(n246), .Y(N77) );
  OAI22X1 I353 ( .A0(n62), .A1(n231), .B0(n222), .B1(n246), .Y(N76) );
  OAI22X1 I354 ( .A0(n63), .A1(n231), .B0(n223), .B1(n246), .Y(N75) );
  OAI22X1 I355 ( .A0(n53), .A1(n231), .B0(n219), .B1(n246), .Y(N73) );
  OAI22X1 I356 ( .A0(n221), .A1(n246), .B0(n232), .B1(n58), .Y(N92) );
  OAI22X1 I357 ( .A0(n209), .A1(n246), .B0(n53), .B1(n232), .Y(N85) );
  OAI22X1 I358 ( .A0(n212), .A1(n246), .B0(n232), .B1(n59), .Y(N91) );
  OAI22X1 I359 ( .A0(n213), .A1(n246), .B0(n232), .B1(n60), .Y(N90) );
  OAI22X1 I360 ( .A0(n214), .A1(n246), .B0(n232), .B1(n61), .Y(N89) );
  OAI22X1 I361 ( .A0(n215), .A1(n246), .B0(n232), .B1(n62), .Y(N88) );
  OAI22X1 I362 ( .A0(n216), .A1(n246), .B0(n232), .B1(n63), .Y(N87) );
  DFFRX1 T2MOD_reg_1_ ( .D(n198), .CK(clk_b), .RN(n196), .Q(T2MOD_T2OE), .QN(
        n208) );
  OR3X2 I363 ( .A(n69), .B(n50), .C(n1780), .Y(n1320) );
  AND2X2 U267 ( .A(n1990), .B(n265), .Y(n1970) );
  AND2X2 U268 ( .A(n265), .B(n2000), .Y(n198) );
  INVX1 I364 ( .A(N186), .Y(n82) );
  NOR2BX1 I365 ( .AN(n1780), .B(n263), .Y(n258) );
  EDFFX1 T2CON_reg_7_ ( .D(N101), .CK(clk_b), .E(N151), .Q(T2CON_7_), .QN(n237) );
  EDFFX1 T2CON_reg_6_ ( .D(N105), .CK(clk_b), .E(N152), .Q(T2CON_6_), .QN(n228) );
  OR3X2 I366 ( .A(n263), .B(n1840), .C(n1780), .Y(n1810) );
  OR3X2 I367 ( .A(n263), .B(n69), .C(n258), .Y(n66) );
  INVX1 I368 ( .A(Z2_S1), .Y(n104) );
  INVX1 I369 ( .A(n1830), .Y(n1590) );
  INVX1 I370 ( .A(n69), .Y(n1840) );
  OR2X2 I371 ( .A(n730), .B(n740), .Y(N200) );
  INVX1 I372 ( .A(n770), .Y(n1900) );
  EDFFX1 current_T2EX_reg ( .D(N148), .CK(clk_b), .E(N31), .Q(current_T2EX), 
        .QN(n204) );
  OR2X2 I373 ( .A(n230), .B(n770), .Y(n103) );
  EDFFX1 before_T2EX_reg ( .D(N30), .CK(clk_b), .E(N31), .Q(n2020), .QN(n239)
         );
  INVX1 I374 ( .A(n1010), .Y(n99) );
  OR3X2 I375 ( .A(n263), .B(Z_update), .C(n84), .Y(N191) );
  OR3X2 I376 ( .A(n263), .B(Z_update), .C(n900), .Y(N189) );
  INVX1 I377 ( .A(Z2_S2), .Y(n800) );
  OR2X2 I378 ( .A(N31), .B(n69), .Y(N193) );
  AND2X2 I379 ( .A(n900), .B(n265), .Y(N190) );
  INVX1 I380 ( .A(n93), .Y(n870) );
  AND3X2 I381 ( .A(n194), .B(T2MOD_0_), .C(n870), .Y(n1920) );
  XOR2X1 I382 ( .A(n228), .B(T2_flow_flag), .Y(n194) );
  INVX1 I383 ( .A(n1330), .Y(N121) );
  OAI221X4 I384 ( .A0(n241), .A1(n71), .B0(n58), .B1(n72), .C0(n1120), .Y(
        n1340) );
  INVX1 I385 ( .A(n1360), .Y(N120) );
  OAI221X4 I386 ( .A0(n243), .A1(n71), .B0(n59), .B1(n72), .C0(n1120), .Y(
        n1370) );
  INVX1 I387 ( .A(n1390), .Y(N119) );
  OAI221X4 I388 ( .A0(n242), .A1(n71), .B0(n60), .B1(n72), .C0(n1120), .Y(n140) );
  INVX1 I389 ( .A(n142), .Y(N118) );
  OAI221X4 I390 ( .A0(n244), .A1(n71), .B0(n61), .B1(n72), .C0(n1120), .Y(n143) );
  INVX1 I391 ( .A(n145), .Y(N117) );
  INVX1 I392 ( .A(n1480), .Y(N116) );
  INVX1 I393 ( .A(n1510), .Y(N115) );
  INVX1 I394 ( .A(n1070), .Y(N139) );
  INVX1 I395 ( .A(n113), .Y(N138) );
  INVX1 I396 ( .A(n1160), .Y(N137) );
  INVX1 I397 ( .A(n1190), .Y(N136) );
  INVX1 I398 ( .A(n122), .Y(N135) );
  INVX1 I399 ( .A(n125), .Y(N134) );
  INVX1 I400 ( .A(n128), .Y(N133) );
  OAI22X1 I401 ( .A0(n263), .A1(n253), .B0(n58), .B1(n1910), .Y(N101) );
  OAI221X4 I402 ( .A0(T2MOD_0_), .A1(n228), .B0(n228), .B1(n208), .C0(n237), 
        .Y(t2_intr) );
  INVX1 I403 ( .A(n130), .Y(N132) );
  INVX1 I404 ( .A(n1530), .Y(N114) );
  AND3X1 I405 ( .A(Z2_S1), .B(n208), .C(n1900), .Y(n1890) );
  OR2X2 I406 ( .A(T2CON_0_), .B(n770), .Y(n93) );
  OR3X2 I407 ( .A(current_T2EX), .B(n227), .C(n93), .Y(n1830) );
  AND3X2 I408 ( .A(n770), .B(n264), .C(n780), .Y(N197) );
  AND4X2 I409 ( .A(n1640), .B(n1650), .C(n1660), .D(n1670), .Y(n1550) );
  XOR2X1 I410 ( .A(n236), .B(TH2[0]), .Y(n1580) );
  OR2X2 I411 ( .A(n102), .B(n103), .Y(n1010) );
  OR4X2 I412 ( .A(current_T2EX), .B(n233), .C(n104), .D(n239), .Y(n102) );
  AND4X2 I413 ( .A(n1740), .B(n1750), .C(n1760), .D(n1770), .Y(n1660) );
  XOR2X1 I414 ( .A(n241), .B(TL2[7]), .Y(n1740) );
  XOR2X1 I415 ( .A(n243), .B(TL2[6]), .Y(n1750) );
  XOR2X1 I416 ( .A(n242), .B(TL2[5]), .Y(n1760) );
  NOR3X1 I417 ( .A(n260), .B(n261), .C(n262), .Y(n1670) );
  XNOR2X1 I418 ( .A(n248), .B(TL2[3]), .Y(n260) );
  XNOR2X1 I419 ( .A(n247), .B(TL2[2]), .Y(n261) );
  NAND3X1 I420 ( .A(n1710), .B(n1720), .C(n1730), .Y(n262) );
  AND4X2 I421 ( .A(n1600), .B(n1610), .C(n1620), .D(n1630), .Y(n1570) );
  XOR2X1 I422 ( .A(n251), .B(TH2[6]), .Y(n1600) );
  XOR2X1 I423 ( .A(n250), .B(TH2[5]), .Y(n1610) );
  XOR2X1 I424 ( .A(n249), .B(TH2[4]), .Y(n1620) );
  XOR2X1 I425 ( .A(n244), .B(TL2[4]), .Y(n1770) );
  XOR2X1 I426 ( .A(n240), .B(TH2[3]), .Y(n1630) );
  XOR2X1 I427 ( .A(n235), .B(TH2[1]), .Y(n1650) );
  XOR2X1 I428 ( .A(n252), .B(TH2[2]), .Y(n1640) );
  XOR2X1 I429 ( .A(n217), .B(TL2[0]), .Y(n1730) );
  XOR2X1 I430 ( .A(n229), .B(TL2[1]), .Y(n1720) );
  XOR2X1 I431 ( .A(n245), .B(TH2[7]), .Y(n1710) );
  OR3X2 I432 ( .A(n263), .B(T2CON_1_), .C(n208), .Y(n740) );
  OR2X2 I433 ( .A(n238), .B(n800), .Y(n94) );
  OR2X2 I434 ( .A(set_TF2), .B(n1050), .Y(N151) );
  OR2X2 I435 ( .A(set_EXF2), .B(n1050), .Y(N152) );
  OR2X2 I436 ( .A(pin_T2), .B(n263), .Y(N147) );
  OR2X2 I437 ( .A(pin_T2EX), .B(n263), .Y(N148) );
  INVX1 I438 ( .A(n850), .Y(n84) );
  OAI211X1 I439 ( .A0(n860), .A1(n870), .B0(n880), .C0(n890), .Y(n850) );
  AND2X1 I440 ( .A(T2_flow_flag), .B(Z2_S2), .Y(n890) );
  OAI2BB1X1 I441 ( .A0N(current_T2EX), .A1N(Z2_S2), .B0(n264), .Y(N30) );
  OAI2BB1X1 I442 ( .A0N(current_T2), .A1N(Z2_S2), .B0(n265), .Y(N29) );
  INVX1 I443 ( .A(POR), .Y(n196) );
  EDFFX1 before_T2_reg ( .D(N29), .CK(clk_b), .E(N31), .Q(n203) );
  EDFFX1 current_T2_reg ( .D(N147), .CK(clk_b), .E(N31), .Q(current_T2) );
  DFFHQX1 T2_uart_clk_reg ( .D(N197), .CK(clk_b), .Q(T2_uart_clk) );
  EDFFX1 T2_CLKOUT_reg ( .D(N199), .CK(clk_b), .E(N200), .Q(T2_CLKOUT), .QN(n7) );
  INVX1 I444 ( .A(SFR_bus[1]), .Y(n51) );
  AND2X1 I445 ( .A(n106), .B(SFR_bus[1]), .Y(N108) );
  AND2X1 I446 ( .A(n106), .B(SFR_bus[0]), .Y(N107) );
  timer2_DW01_inc_17_0 add_333 ( .A({1'b0, TH2, TL2}), .SUM({N186, N185, N184, 
        N183, N182, N181, N180, N179, N178, N177, N176, N175, N174, N173, N172, 
        N171, N170}) );
  timer2_DW01_dec_17_0 sub_333 ( .A({1'b0, TH2, TL2}), .SUM({
        SYNOPSYS_UNCONNECTED__0, N168, N167, N166, N165, N164, N163, N162, 
        N161, N160, N159, N158, N157, N156, N155, N154, N153}) );
endmodule


module timer2_DW01_dec_17_0 ( A, SUM );
  input [16:0] A;
  output [16:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_;

  XNOR2X1 U1_A_7 ( .A(A[7]), .B(carry_7_), .Y(SUM[7]) );
  XNOR2X1 U1_A_6 ( .A(A[6]), .B(carry_6_), .Y(SUM[6]) );
  XNOR2X1 U1_A_5 ( .A(A[5]), .B(carry_5_), .Y(SUM[5]) );
  XNOR2X1 U1_A_4 ( .A(A[4]), .B(carry_4_), .Y(SUM[4]) );
  XNOR2X1 U1_A_3 ( .A(A[3]), .B(carry_3_), .Y(SUM[3]) );
  XNOR2X1 U1_A_2 ( .A(A[2]), .B(carry_2_), .Y(SUM[2]) );
  XNOR2X1 U1_A_1 ( .A(A[1]), .B(A[0]), .Y(SUM[1]) );
  XNOR2X1 U1_A_15 ( .A(A[15]), .B(carry_15_), .Y(SUM[15]) );
  XNOR2X1 U1_A_14 ( .A(A[14]), .B(carry_14_), .Y(SUM[14]) );
  XNOR2X1 U1_A_13 ( .A(A[13]), .B(carry_13_), .Y(SUM[13]) );
  XNOR2X1 U1_A_12 ( .A(A[12]), .B(carry_12_), .Y(SUM[12]) );
  XNOR2X1 U1_A_11 ( .A(A[11]), .B(carry_11_), .Y(SUM[11]) );
  XNOR2X1 U1_A_10 ( .A(A[10]), .B(carry_10_), .Y(SUM[10]) );
  XNOR2X1 U1_A_9 ( .A(A[9]), .B(carry_9_), .Y(SUM[9]) );
  XNOR2X1 U1_A_8 ( .A(A[8]), .B(carry_8_), .Y(SUM[8]) );
  OR2X2 U1_B_1 ( .A(A[1]), .B(A[0]), .Y(carry_2_) );
  OR2X2 U1_B_6 ( .A(A[6]), .B(carry_6_), .Y(carry_7_) );
  OR2X2 U1_B_5 ( .A(A[5]), .B(carry_5_), .Y(carry_6_) );
  OR2X2 U1_B_4 ( .A(A[4]), .B(carry_4_), .Y(carry_5_) );
  OR2X2 U1_B_3 ( .A(A[3]), .B(carry_3_), .Y(carry_4_) );
  OR2X2 U1_B_2 ( .A(A[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X2 U1_B_13 ( .A(A[13]), .B(carry_13_), .Y(carry_14_) );
  OR2X2 U1_B_12 ( .A(A[12]), .B(carry_12_), .Y(carry_13_) );
  OR2X2 U1_B_11 ( .A(A[11]), .B(carry_11_), .Y(carry_12_) );
  OR2X2 U1_B_10 ( .A(A[10]), .B(carry_10_), .Y(carry_11_) );
  OR2X2 U1_B_9 ( .A(A[9]), .B(carry_9_), .Y(carry_10_) );
  OR2X2 U1_B_8 ( .A(A[8]), .B(carry_8_), .Y(carry_9_) );
  OR2X2 U1_B_7 ( .A(A[7]), .B(carry_7_), .Y(carry_8_) );
  OR2X2 U1_B_14 ( .A(A[14]), .B(carry_14_), .Y(carry_15_) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module timer2_DW01_inc_17_0 ( A, SUM );
  input [16:0] A;
  output [16:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_;

  CMPR22X1 U1_1_14 ( .A(A[14]), .B(carry_14_), .S(SUM[14]), .CO(carry_15_) );
  CMPR22X1 U1_1_15 ( .A(A[15]), .B(carry_15_), .S(SUM[15]), .CO(SUM[16]) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  CMPR22X1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  CMPR22X1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  CMPR22X1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  CMPR22X1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  CMPR22X1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  CMPR22X1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  CMPR22X1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(carry_13_) );
  CMPR22X1 U1_1_13 ( .A(A[13]), .B(carry_13_), .S(SUM[13]), .CO(carry_14_) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module timer01 ( Z_update, Z0_S1, Z0_S2, Z0_S5, Z0_S6, Z1_S1, Z1_S2, Z1_S4, 
        Z1_S5, Z1_S6, sw_rst, clk_b, SFR_wr, SFR_bus, TH0_sel, TL0_sel, 
        TH1_sel, TL1_sel, TCON_sel, TMOD_sel, clear_TF0, clear_TF1, pin_T0, 
        pin_T1, sample_INT0, sample_INT1, TCON30, TF0, TF1, T1_overflow, 
        T01_SFR_OUT );
  input [7:0] SFR_bus;
  input [3:0] TCON30;
  output [7:0] T01_SFR_OUT;
  input Z_update, Z0_S1, Z0_S2, Z0_S5, Z0_S6, Z1_S1, Z1_S2, Z1_S4, Z1_S5,
         Z1_S6, sw_rst, clk_b, SFR_wr, TH0_sel, TL0_sel, TH1_sel, TL1_sel,
         TCON_sel, TMOD_sel, clear_TF0, clear_TF1, pin_T0, pin_T1, sample_INT0,
         sample_INT1;
  output TF0, TF1, T1_overflow;
  wire   set_TF0, set_TF1, TR0, TR1, TH0_carry, T0_mode3, n2, n3, n5, n6, n7,
         n8, n9, n10, n11, n12, n16, n17;
  wire   [7:0] TH0_TL0_OUT;
  wire   [7:0] TH1_TL1_OUT;
  wire   [7:0] TCON_TMOD_OUT;
  wire   [7:0] TMOD;

  t01_control t01_control ( .sw_rst(sw_rst), .clk_b(clk_b), .TCON_sel(TCON_sel), .TMOD_sel(TMOD_sel), .SFR_wr(SFR_wr), .SFR_bus(SFR_bus), .clear_TF0(
        clear_TF0), .clear_TF1(clear_TF1), .set_TF0(set_TF0), .set_TF1(set_TF1), .TCON30(TCON30), .TF0(TF0), .TF1(TF1), .TR0(TR0), .TR1(TR1), .TCON_TMOD_OUT(
        TCON_TMOD_OUT), .TMOD(TMOD) );
  timer0 timer0 ( .Z_update(Z_update), .Z_S1(Z0_S1), .Z_S2(Z0_S2), .Z_S5(Z0_S5), .Z_S6(Z0_S6), .sw_rst(sw_rst), .clk_b(clk_b), .SFR_bus(SFR_bus), .TH0_sel(
        TH0_sel), .TL0_sel(TL0_sel), .SFR_wr(SFR_wr), .pin_T0(pin_T0), 
        .sample_INT0(sample_INT0), .TMOD30(TMOD[3:0]), .TR0(TR0), .TR1(TR1), 
        .TH0_carry(TH0_carry), .T0_mode3(T0_mode3), .set_TF0(set_TF0), 
        .TH0_TL0_OUT(TH0_TL0_OUT) );
  timer1 timer1 ( .Z_update(Z_update), .Z_S1(Z1_S1), .Z_S2(Z1_S2), .Z_S4(Z1_S4), .Z_S5(Z1_S5), .Z_S6(Z1_S6), .sw_rst(sw_rst), .clk_b(clk_b), .SFR_bus(SFR_bus), .SFR_wr(SFR_wr), .TH1_sel(TH1_sel), .TL1_sel(TL1_sel), .pin_T1(pin_T1), 
        .sample_INT1(sample_INT1), .TH0_carry(TH0_carry), .T0_mode3(T0_mode3), 
        .TMOD74(TMOD[7:4]), .TR1(TR1), .T1_overflow(T1_overflow), .set_TF1(
        set_TF1), .TH1_TL1_OUT(TH1_TL1_OUT) );
  AOI222X4 U5 ( .A0(TH1_TL1_OUT[7]), .A1(n16), .B0(TCON_TMOD_OUT[7]), .B1(n17), 
        .C0(TH0_TL0_OUT[7]), .C1(n5), .Y(n2) );
  AOI222X4 U7 ( .A0(TH1_TL1_OUT[6]), .A1(n16), .B0(TCON_TMOD_OUT[6]), .B1(n17), 
        .C0(TH0_TL0_OUT[6]), .C1(n5), .Y(n6) );
  AOI222X4 U9 ( .A0(TH1_TL1_OUT[5]), .A1(n16), .B0(TCON_TMOD_OUT[5]), .B1(n17), 
        .C0(TH0_TL0_OUT[5]), .C1(n5), .Y(n7) );
  AOI222X4 U11 ( .A0(TH1_TL1_OUT[4]), .A1(n16), .B0(TCON_TMOD_OUT[4]), .B1(n17), .C0(TH0_TL0_OUT[4]), .C1(n5), .Y(n8) );
  AOI222X4 U13 ( .A0(TH1_TL1_OUT[3]), .A1(n16), .B0(TCON_TMOD_OUT[3]), .B1(n17), .C0(TH0_TL0_OUT[3]), .C1(n5), .Y(n9) );
  AOI222X4 U15 ( .A0(TH1_TL1_OUT[2]), .A1(n16), .B0(TCON_TMOD_OUT[2]), .B1(n17), .C0(TH0_TL0_OUT[2]), .C1(n5), .Y(n10) );
  AOI222X4 U17 ( .A0(TH1_TL1_OUT[1]), .A1(n16), .B0(TCON_TMOD_OUT[1]), .B1(n17), .C0(TH0_TL0_OUT[1]), .C1(n5), .Y(n11) );
  AOI222X4 U19 ( .A0(TH1_TL1_OUT[0]), .A1(n16), .B0(TCON_TMOD_OUT[0]), .B1(n17), .C0(TH0_TL0_OUT[0]), .C1(n5), .Y(n12) );
  OR2X4 U25 ( .A(TH0_sel), .B(TL0_sel), .Y(n5) );
  AOI2BB1X1 I26 ( .A0N(TL1_sel), .A1N(TH1_sel), .B0(n5), .Y(n3) );
  BUFX3 I27 ( .A(n3), .Y(n16) );
  NOR3X4 I28 ( .A(TL1_sel), .B(TH1_sel), .C(n5), .Y(n17) );
  INVX1 I29 ( .A(n2), .Y(T01_SFR_OUT[7]) );
  INVX1 I30 ( .A(n6), .Y(T01_SFR_OUT[6]) );
  INVX1 I31 ( .A(n7), .Y(T01_SFR_OUT[5]) );
  INVX1 I32 ( .A(n8), .Y(T01_SFR_OUT[4]) );
  INVX1 I33 ( .A(n9), .Y(T01_SFR_OUT[3]) );
  INVX1 I34 ( .A(n10), .Y(T01_SFR_OUT[2]) );
  INVX1 I35 ( .A(n12), .Y(T01_SFR_OUT[0]) );
  INVX1 I36 ( .A(n11), .Y(T01_SFR_OUT[1]) );
endmodule


module timer1 ( Z_update, Z_S1, Z_S2, Z_S4, Z_S5, Z_S6, sw_rst, clk_b, SFR_bus, 
        SFR_wr, TH1_sel, TL1_sel, pin_T1, sample_INT1, TH0_carry, T0_mode3, 
        TMOD74, TR1, T1_overflow, set_TF1, TH1_TL1_OUT );
  input [7:0] SFR_bus;
  input [3:0] TMOD74;
  output [7:0] TH1_TL1_OUT;
  input Z_update, Z_S1, Z_S2, Z_S4, Z_S5, Z_S6, sw_rst, clk_b, SFR_wr, TH1_sel,
         TL1_sel, pin_T1, sample_INT1, TH0_carry, T0_mode3, TR1;
  output T1_overflow, set_TF1;
  wire   N28, N29, N30, N31, N32, N33, N34, N35, N48, N49, N50, N51, N52, N53,
         N54, N55, TH1_carry, before_T1, current_T1, N64, N65,
         early_t1_overflow_S4, N76, TL1_carry_4, TH1_carry_7, N82, N84, N85,
         N86, N88, N89, N90, N91, N92, n8, n9, n10, n11, n12, n13, n14, n15,
         n16, n17, n19, n20, n21, n22, n25, n26, n27, n280, n290, n300, n310,
         n320, n330, n350, n36, n37, n38, n39, n40, n42, n43, n44, n45, n46,
         n47, n480, n490, n500, n510, n520, n530, n56, n58, n61, n62, n63,
         n640, n650, n66, n67, n69, n72, n73, n74, n75, n760, n77, n79, n80,
         n81, n820, n83, n840, n850, n860, n87, n880, n890, n900;
  wire   [7:0] TH1;
  wire   [7:0] TL1;
  wire   [7:0] TL1_inc;
  wire   [7:0] TH1_inc;

  OAI32X4 U16 ( .A0(n19), .A1(T0_mode3), .A2(n20), .B0(n20), .B1(n21), .Y(n17)
         );
  OAI222X4 U31 ( .A0(n40), .A1(n850), .B0(n42), .B1(n850), .C0(TMOD74[0]), 
        .C1(n43), .Y(n37) );
  AOI222X4 U67 ( .A0(n80), .A1(SFR_bus[7]), .B0(TL1_inc[7]), .B1(n83), .C0(
        n820), .C1(TH1[7]), .Y(n58) );
  AOI222X4 U69 ( .A0(n80), .A1(SFR_bus[6]), .B0(TL1_inc[6]), .B1(n83), .C0(
        n820), .C1(TH1[6]), .Y(n61) );
  AOI222X4 U71 ( .A0(n80), .A1(SFR_bus[5]), .B0(TL1_inc[5]), .B1(n83), .C0(
        n820), .C1(TH1[5]), .Y(n62) );
  AOI222X4 U73 ( .A0(n80), .A1(SFR_bus[4]), .B0(TL1_inc[4]), .B1(n83), .C0(
        n820), .C1(TH1[4]), .Y(n63) );
  AOI222X4 U75 ( .A0(n80), .A1(SFR_bus[3]), .B0(TL1_inc[3]), .B1(n83), .C0(
        n820), .C1(TH1[3]), .Y(n640) );
  AOI222X4 U77 ( .A0(n80), .A1(SFR_bus[2]), .B0(TL1_inc[2]), .B1(n83), .C0(
        n820), .C1(TH1[2]), .Y(n650) );
  AOI222X4 U79 ( .A0(n80), .A1(SFR_bus[1]), .B0(TL1_inc[1]), .B1(n83), .C0(
        n820), .C1(TH1[1]), .Y(n66) );
  AOI222X4 U81 ( .A0(n80), .A1(SFR_bus[0]), .B0(TL1_inc[0]), .B1(n83), .C0(
        n820), .C1(TH1[0]), .Y(n67) );
  OAI211X4 U88 ( .A0(n42), .A1(n40), .B0(n73), .C0(n74), .Y(n26) );
  AND2X2 I103 ( .A(n87), .B(n79), .Y(n80) );
  INVX1 I104 ( .A(n77), .Y(n79) );
  EDFFX1 TL1_reg_4_ ( .D(N32), .CK(clk_b), .E(N85), .Q(TL1[4]) );
  EDFFX1 TL1_reg_3_ ( .D(N31), .CK(clk_b), .E(N85), .Q(TL1[3]) );
  OR2X1 I105 ( .A(Z_S5), .B(n860), .Y(N65) );
  NOR2BX2 I106 ( .AN(n56), .B(n320), .Y(n840) );
  NOR2BX2 I107 ( .AN(n69), .B(n36), .Y(n83) );
  OR2X2 I108 ( .A(TMOD74[0]), .B(n42), .Y(n45) );
  DFFHQX1 T1_overflow_reg ( .D(N76), .CK(clk_b), .Q(T1_overflow) );
  NAND2X2 I109 ( .A(TL1_sel), .B(SFR_wr), .Y(n77) );
  EDFFX1 TL1_reg_0_ ( .D(N28), .CK(clk_b), .E(N85), .Q(TL1[0]) );
  EDFFX1 TL1_reg_7_ ( .D(N35), .CK(clk_b), .E(N85), .Q(TL1[7]) );
  EDFFX1 TL1_reg_5_ ( .D(N33), .CK(clk_b), .E(N85), .Q(TL1[5]) );
  EDFFX1 TL1_reg_2_ ( .D(N30), .CK(clk_b), .E(N85), .Q(TL1[2]) );
  EDFFX1 TL1_reg_1_ ( .D(N29), .CK(clk_b), .E(N85), .Q(TL1[1]) );
  EDFFX1 TH1_reg_2_ ( .D(N50), .CK(clk_b), .E(N90), .Q(TH1[2]), .QN(n14) );
  EDFFX1 TH1_reg_1_ ( .D(N49), .CK(clk_b), .E(N90), .Q(TH1[1]), .QN(n15) );
  EDFFX1 TH1_reg_0_ ( .D(N48), .CK(clk_b), .E(N90), .Q(TH1[0]), .QN(n16) );
  EDFFX1 TH1_reg_7_ ( .D(N55), .CK(clk_b), .E(N90), .Q(TH1[7]), .QN(n8) );
  EDFFX1 TH1_reg_6_ ( .D(N54), .CK(clk_b), .E(N90), .Q(TH1[6]), .QN(n10) );
  EDFFX1 TH1_reg_5_ ( .D(N53), .CK(clk_b), .E(N90), .Q(TH1[5]), .QN(n11) );
  EDFFX1 TH1_reg_4_ ( .D(N52), .CK(clk_b), .E(N90), .Q(TH1[4]), .QN(n12) );
  EDFFX1 TH1_reg_3_ ( .D(N51), .CK(clk_b), .E(N90), .Q(TH1[3]), .QN(n13) );
  NOR2X4 I110 ( .A(n36), .B(n69), .Y(n820) );
  INVX2 I111 ( .A(n81), .Y(n25) );
  AND3X1 I112 ( .A(Z_S4), .B(early_t1_overflow_S4), .C(n880), .Y(N76) );
  NAND3X1 I113 ( .A(TL1[6]), .B(TL1[5]), .C(TL1_carry_4), .Y(n900) );
  INVX4 I114 ( .A(TH1_sel), .Y(n9) );
  OR3X2 I115 ( .A(n860), .B(n80), .C(n350), .Y(N85) );
  INVX1 I116 ( .A(n36), .Y(n350) );
  NOR2X1 I117 ( .A(n860), .B(n56), .Y(n81) );
  INVX2 I118 ( .A(n87), .Y(n860) );
  OR3X2 I119 ( .A(n860), .B(n81), .C(n840), .Y(N90) );
  NAND2BX1 I120 ( .AN(n9), .B(SFR_wr), .Y(n56) );
  INVX1 I121 ( .A(sw_rst), .Y(n87) );
  OR3X2 I122 ( .A(n72), .B(n330), .C(n39), .Y(n36) );
  INVX1 I123 ( .A(n77), .Y(n72) );
  EDFFX1 set_TF1_reg ( .D(N92), .CK(clk_b), .E(N91), .Q(set_TF1) );
  INVX1 I124 ( .A(sw_rst), .Y(n880) );
  OAI2BB2X1 I125 ( .A0N(TH1_inc[1]), .A1N(n840), .B0(n25), .B1(n520), .Y(N49)
         );
  OAI2BB2X1 I126 ( .A0N(TH1_inc[7]), .A1N(n840), .B0(n25), .B1(n46), .Y(N55)
         );
  INVX1 I127 ( .A(SFR_bus[7]), .Y(n46) );
  OAI2BB2X1 I128 ( .A0N(TH1_inc[6]), .A1N(n840), .B0(n25), .B1(n47), .Y(N54)
         );
  INVX1 I129 ( .A(SFR_bus[6]), .Y(n47) );
  OAI2BB2X1 I130 ( .A0N(TH1_inc[5]), .A1N(n840), .B0(n25), .B1(n480), .Y(N53)
         );
  INVX1 I131 ( .A(SFR_bus[5]), .Y(n480) );
  OAI2BB2X1 I132 ( .A0N(TH1_inc[4]), .A1N(n840), .B0(n25), .B1(n490), .Y(N52)
         );
  INVX1 I133 ( .A(SFR_bus[4]), .Y(n490) );
  OAI2BB2X1 I134 ( .A0N(TH1_inc[3]), .A1N(n840), .B0(n25), .B1(n500), .Y(N51)
         );
  INVX1 I135 ( .A(SFR_bus[3]), .Y(n500) );
  OAI2BB2X1 I136 ( .A0N(TH1_inc[2]), .A1N(n840), .B0(n25), .B1(n510), .Y(N50)
         );
  INVX1 I137 ( .A(SFR_bus[2]), .Y(n510) );
  EDFFX1 TL1_reg_6_ ( .D(N34), .CK(clk_b), .E(N85), .Q(TL1[6]) );
  OR2X2 I138 ( .A(n860), .B(n26), .Y(n39) );
  OR2X2 I139 ( .A(n45), .B(n850), .Y(n69) );
  EDFFX1 TL1_carry_reg ( .D(N84), .CK(clk_b), .E(N86), .QN(n44) );
  OR3X2 I140 ( .A(n860), .B(Z_update), .C(n17), .Y(N91) );
  OAI31X1 I141 ( .A0(n26), .A1(n27), .A2(n280), .B0(n290), .Y(N89) );
  AND2X2 I142 ( .A(n300), .B(n880), .Y(n290) );
  INVX1 I143 ( .A(Z_S1), .Y(n330) );
  OAI211X1 I144 ( .A0(n26), .A1(n330), .B0(n300), .C0(n880), .Y(N86) );
  AND3X2 I145 ( .A(TH1_carry_7), .B(n300), .C(n310), .Y(N88) );
  INVX1 I146 ( .A(n320), .Y(n310) );
  INVX1 I147 ( .A(n45), .Y(n27) );
  AND2X2 I148 ( .A(n17), .B(n880), .Y(N92) );
  OAI2BB2X1 I149 ( .A0N(TL1[0]), .A1N(n9), .B0(n9), .B1(n16), .Y(
        TH1_TL1_OUT[0]) );
  INVX1 I150 ( .A(n61), .Y(N34) );
  XNOR2X1 I151 ( .A(TL1[6]), .B(n890), .Y(TL1_inc[6]) );
  NAND2X1 I152 ( .A(TL1_carry_4), .B(TL1[5]), .Y(n890) );
  INVX1 I153 ( .A(n58), .Y(N35) );
  XNOR2X1 I154 ( .A(TL1[7]), .B(n900), .Y(TL1_inc[7]) );
  INVX1 I155 ( .A(n63), .Y(N32) );
  OAI2BB2X1 I156 ( .A0N(TL1[1]), .A1N(n9), .B0(n9), .B1(n15), .Y(
        TH1_TL1_OUT[1]) );
  INVX1 I157 ( .A(n62), .Y(N33) );
  XOR2X1 I158 ( .A(TL1_carry_4), .B(TL1[5]), .Y(TL1_inc[5]) );
  INVX1 I159 ( .A(n640), .Y(N31) );
  INVX1 I160 ( .A(n650), .Y(N30) );
  OAI2BB2X1 I161 ( .A0N(TH1_inc[0]), .A1N(n840), .B0(n25), .B1(n530), .Y(N48)
         );
  INVX1 I162 ( .A(n66), .Y(N29) );
  INVX1 I163 ( .A(n67), .Y(N28) );
  OAI2BB2X1 I164 ( .A0N(TL1[7]), .A1N(n9), .B0(n8), .B1(n9), .Y(TH1_TL1_OUT[7]) );
  OAI2BB2X1 I165 ( .A0N(TL1[6]), .A1N(n9), .B0(n9), .B1(n10), .Y(
        TH1_TL1_OUT[6]) );
  OAI2BB2X1 I166 ( .A0N(TL1[5]), .A1N(n9), .B0(n9), .B1(n11), .Y(
        TH1_TL1_OUT[5]) );
  OAI2BB2X1 I167 ( .A0N(TL1[4]), .A1N(n9), .B0(n9), .B1(n12), .Y(
        TH1_TL1_OUT[4]) );
  OAI2BB2X1 I168 ( .A0N(TL1[3]), .A1N(n9), .B0(n9), .B1(n13), .Y(
        TH1_TL1_OUT[3]) );
  OAI2BB2X1 I169 ( .A0N(TL1[2]), .A1N(n9), .B0(n9), .B1(n14), .Y(
        TH1_TL1_OUT[2]) );
  OR4X2 I170 ( .A(n280), .B(n44), .C(n27), .D(n39), .Y(n320) );
  OAI2BB1X1 I171 ( .A0N(before_T1), .A1N(n760), .B0(TMOD74[2]), .Y(n73) );
  AND2X2 I172 ( .A(TR1), .B(n75), .Y(n74) );
  NAND2BX1 I173 ( .AN(sample_INT1), .B(TMOD74[3]), .Y(n75) );
  INVX1 I174 ( .A(TMOD74[1]), .Y(n42) );
  AND4X1 I175 ( .A(Z_S1), .B(n300), .C(n37), .D(n38), .Y(N84) );
  INVX1 I176 ( .A(n39), .Y(n38) );
  NAND2X1 I177 ( .A(TL1_carry_4), .B(n42), .Y(n43) );
  NAND2BX1 I178 ( .AN(n900), .B(TL1[7]), .Y(n850) );
  INVX1 I179 ( .A(TMOD74[0]), .Y(n40) );
  OAI2BB2X1 I180 ( .A0N(TH1_carry), .A1N(n45), .B0(n44), .B1(n45), .Y(n22) );
  NAND2X1 I181 ( .A(T0_mode3), .B(TH0_carry), .Y(n21) );
  INVX1 I182 ( .A(Z_S5), .Y(n20) );
  INVX1 I183 ( .A(n22), .Y(n19) );
  INVX1 I184 ( .A(Z_S6), .Y(n300) );
  INVX1 I185 ( .A(Z_S2), .Y(n280) );
  OR2X2 I186 ( .A(pin_T1), .B(n860), .Y(N82) );
  OAI2BB1X1 I187 ( .A0N(current_T1), .A1N(Z_S5), .B0(n87), .Y(N64) );
  EDFFX1 before_T1_reg ( .D(N64), .CK(clk_b), .E(N65), .Q(before_T1) );
  EDFFX1 current_T1_reg ( .D(N82), .CK(clk_b), .E(N65), .Q(current_T1), .QN(
        n760) );
  EDFFX1 TH1_carry_reg ( .D(N88), .CK(clk_b), .E(N89), .Q(TH1_carry) );
  EDFFTRX1 early_t1_overflow_S4_reg ( .D(n22), .CK(clk_b), .E(Z_S4), .RN(n880), 
        .Q(early_t1_overflow_S4) );
  INVX1 I188 ( .A(SFR_bus[1]), .Y(n520) );
  INVX1 I189 ( .A(SFR_bus[0]), .Y(n530) );
  timer1_DW01_inc_9_0 add_139 ( .A({1'b0, TH1}), .SUM({TH1_carry_7, TH1_inc})
         );
  timer1_DW01_inc_6_0 add_115 ( .A({1'b0, TL1[4:0]}), .SUM({TL1_carry_4, 
        TL1_inc[4:0]}) );
endmodule


module timer1_DW01_inc_6_0 ( A, SUM );
  input [5:0] A;
  output [5:0] SUM;
  wire   carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(SUM[5]) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
endmodule


module timer1_DW01_inc_9_0 ( A, SUM );
  input [8:0] A;
  output [8:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  CMPR22X1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(SUM[8]) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
endmodule


module timer0 ( Z_update, Z_S1, Z_S2, Z_S5, Z_S6, sw_rst, clk_b, SFR_bus, 
        TH0_sel, TL0_sel, SFR_wr, pin_T0, sample_INT0, TMOD30, TR0, TR1, 
        TH0_carry, T0_mode3, set_TF0, TH0_TL0_OUT );
  input [7:0] SFR_bus;
  input [3:0] TMOD30;
  output [7:0] TH0_TL0_OUT;
  input Z_update, Z_S1, Z_S2, Z_S5, Z_S6, sw_rst, clk_b, TH0_sel, TL0_sel,
         SFR_wr, pin_T0, sample_INT0, TR0, TR1;
  output TH0_carry, T0_mode3, set_TF0;
  wire   N29, N30, N31, N32, N33, N34, N35, N36, N53, N54, N55, N56, N57, N58,
         N59, N60, before_T0, current_T0, N65, N66, TL0_inc_0_, TL0_inc_1_,
         TL0_inc_2_, TL0_inc_3_, TL0_inc_4_, TL0_carry_4, TH0_carry_7, N80,
         N82, N83, N84, N86, N87, N88, N89, N90, n8, n9, n10, n11, n12, n13,
         n14, n15, n16, n17, n19, n20, n21, n22, n23, n25, n26, n27, n28, n290,
         n300, n310, n340, n350, n360, n37, n38, n40, n41, n42, n43, n44, n45,
         n46, n47, n48, n49, n50, n530, n540, n560, n570, n590, n600, n64,
         n650, n660, n67, n68, n69, n71, n72, n73, n74, n75, n76, n77, n78,
         n79, n800, n81, n820, n830, n840, n85, n860, n870, n880;
  wire   [7:0] TH0;
  wire   [7:0] TL0;
  wire   [7:0] TH0_inc;

  OAI32X4 U16 ( .A0(n19), .A1(n20), .A2(n21), .B0(n22), .B1(n23), .Y(n17) );
  OAI222X4 U30 ( .A0(n38), .A1(n85), .B0(n40), .B1(n85), .C0(TMOD30[0]), .C1(
        n41), .Y(n360) );
  OAI22X4 U48 ( .A0(n28), .A1(n20), .B0(n28), .B1(n530), .Y(n300) );
  AOI33X4 U49 ( .A0(n540), .A1(Z_S2), .A2(n19), .B0(TR1), .B1(Z_S2), .B2(
        T0_mode3), .Y(n28) );
  OAI222X4 U61 ( .A0(n8), .A1(n590), .B0(n600), .B1(n840), .C0(n42), .C1(n350), 
        .Y(N36) );
  OAI222X4 U64 ( .A0(n10), .A1(n590), .B0(n600), .B1(n79), .C0(n43), .C1(n350), 
        .Y(N35) );
  OAI222X4 U67 ( .A0(n11), .A1(n590), .B0(n600), .B1(n820), .C0(n44), .C1(n350), .Y(N34) );
  OAI222X4 U70 ( .A0(n12), .A1(n590), .B0(n600), .B1(n64), .C0(n45), .C1(n350), 
        .Y(N33) );
  OAI222X4 U73 ( .A0(n13), .A1(n590), .B0(n600), .B1(n650), .C0(n46), .C1(n350), .Y(N32) );
  OAI222X4 U76 ( .A0(n14), .A1(n590), .B0(n600), .B1(n660), .C0(n47), .C1(n350), .Y(N31) );
  OAI222X4 U79 ( .A0(n15), .A1(n590), .B0(n600), .B1(n67), .C0(n48), .C1(n350), 
        .Y(N30) );
  OAI222X4 U82 ( .A0(n16), .A1(n590), .B0(n600), .B1(n68), .C0(n49), .C1(n350), 
        .Y(N29) );
  NAND2X1 I101 ( .A(n560), .B(n530), .Y(n22) );
  NAND2BX2 I102 ( .AN(n340), .B(n71), .Y(n600) );
  AND3X1 I103 ( .A(n870), .B(n350), .C(n340), .Y(n77) );
  INVX2 I104 ( .A(n77), .Y(N83) );
  AND4X1 I105 ( .A(n290), .B(n870), .C(n360), .D(n310), .Y(N82) );
  EDFFX1 TL0_reg_4_ ( .D(N33), .CK(clk_b), .E(N83), .Q(TL0[4]) );
  EDFFX1 TL0_reg_3_ ( .D(N32), .CK(clk_b), .E(N83), .Q(TL0[3]) );
  OR2X2 I106 ( .A(n38), .B(n40), .Y(n530) );
  EDFFX1 TH0_reg_6_ ( .D(N59), .CK(clk_b), .E(N88), .Q(TH0[6]), .QN(n10) );
  EDFFX1 TL0_reg_1_ ( .D(N30), .CK(clk_b), .E(N83), .Q(TL0[1]) );
  EDFFX1 TL0_reg_0_ ( .D(N29), .CK(clk_b), .E(N83), .Q(TL0[0]) );
  EDFFX1 TH0_reg_0_ ( .D(N53), .CK(clk_b), .E(N88), .Q(TH0[0]), .QN(n16) );
  INVX2 I107 ( .A(n50), .Y(n25) );
  INVX2 I108 ( .A(n78), .Y(n26) );
  EDFFX1 TL0_reg_2_ ( .D(N31), .CK(clk_b), .E(N83), .Q(TL0[2]) );
  EDFFX1 TL0_reg_5_ ( .D(N34), .CK(clk_b), .E(N83), .Q(TL0[5]), .QN(n830) );
  EDFFX1 TL0_reg_7_ ( .D(N36), .CK(clk_b), .E(N83), .Q(TL0[7]) );
  INVX2 I109 ( .A(n870), .Y(n860) );
  NAND3X1 I110 ( .A(TL0[6]), .B(TL0[5]), .C(TL0_carry_4), .Y(n880) );
  NAND2X1 I111 ( .A(Z_S1), .B(n540), .Y(n37) );
  INVX4 I112 ( .A(TH0_sel), .Y(n9) );
  OR2X2 I113 ( .A(n860), .B(n69), .Y(n350) );
  NOR2X1 I114 ( .A(n860), .B(n570), .Y(n78) );
  INVX1 I115 ( .A(SFR_bus[3]), .Y(n46) );
  INVX1 I116 ( .A(SFR_bus[5]), .Y(n44) );
  INVX1 I117 ( .A(SFR_bus[2]), .Y(n47) );
  INVX1 I118 ( .A(SFR_bus[6]), .Y(n43) );
  EDFFX1 TH0_reg_1_ ( .D(N54), .CK(clk_b), .E(N88), .Q(TH0[1]), .QN(n15) );
  INVX1 I119 ( .A(SFR_bus[7]), .Y(n42) );
  INVX1 I120 ( .A(SFR_bus[4]), .Y(n45) );
  EDFFX1 TH0_reg_7_ ( .D(N60), .CK(clk_b), .E(N88), .Q(TH0[7]), .QN(n8) );
  EDFFX1 TH0_reg_5_ ( .D(N58), .CK(clk_b), .E(N88), .Q(TH0[5]), .QN(n11) );
  EDFFX1 TH0_reg_4_ ( .D(N57), .CK(clk_b), .E(N88), .Q(TH0[4]), .QN(n12) );
  EDFFX1 TH0_reg_3_ ( .D(N56), .CK(clk_b), .E(N88), .Q(TH0[3]), .QN(n13) );
  EDFFX1 TH0_reg_2_ ( .D(N55), .CK(clk_b), .E(N88), .Q(TH0[2]), .QN(n14) );
  OR3X2 I121 ( .A(n860), .B(n78), .C(n25), .Y(N88) );
  NAND2X1 I122 ( .A(TL0_sel), .B(SFR_wr), .Y(n69) );
  NAND2BX1 I123 ( .AN(n9), .B(SFR_wr), .Y(n570) );
  OR2X2 I124 ( .A(n340), .B(n71), .Y(n590) );
  INVX1 I125 ( .A(n530), .Y(T0_mode3) );
  INVX1 I126 ( .A(n22), .Y(n19) );
  EDFFX1 TH0_carry_reg ( .D(N86), .CK(clk_b), .E(N87), .Q(TH0_carry) );
  EDFFX1 set_TF0_reg ( .D(N90), .CK(clk_b), .E(N89), .Q(set_TF0) );
  INVX1 I127 ( .A(sw_rst), .Y(n870) );
  OAI2BB2X1 I128 ( .A0N(TH0_inc[1]), .A1N(n25), .B0(n26), .B1(n48), .Y(N54) );
  OAI2BB2X1 I129 ( .A0N(TH0_inc[7]), .A1N(n25), .B0(n26), .B1(n42), .Y(N60) );
  OAI2BB2X1 I130 ( .A0N(TH0_inc[6]), .A1N(n25), .B0(n26), .B1(n43), .Y(N59) );
  OAI2BB2X1 I131 ( .A0N(TH0_inc[5]), .A1N(n25), .B0(n26), .B1(n44), .Y(N58) );
  OAI2BB2X1 I132 ( .A0N(TH0_inc[4]), .A1N(n25), .B0(n26), .B1(n45), .Y(N57) );
  OAI2BB2X1 I133 ( .A0N(TH0_inc[3]), .A1N(n25), .B0(n26), .B1(n46), .Y(N56) );
  OAI2BB2X1 I134 ( .A0N(TH0_inc[2]), .A1N(n25), .B0(n26), .B1(n47), .Y(N55) );
  EDFFX1 TL0_reg_6_ ( .D(N35), .CK(clk_b), .E(N83), .Q(TL0[6]), .QN(n800) );
  NAND3BX1 I135 ( .AN(n860), .B(n570), .C(n300), .Y(n50) );
  OR2X2 I136 ( .A(n85), .B(n560), .Y(n71) );
  OR3X2 I137 ( .A(n860), .B(n72), .C(n37), .Y(n340) );
  INVX1 I138 ( .A(n69), .Y(n72) );
  OR2X2 I139 ( .A(Z_S5), .B(n860), .Y(N66) );
  OR3X2 I140 ( .A(n860), .B(Z_S6), .C(n310), .Y(N84) );
  OR3X2 I141 ( .A(n860), .B(Z_S6), .C(n27), .Y(N87) );
  INVX1 I142 ( .A(n28), .Y(n27) );
  OR3X2 I143 ( .A(n860), .B(Z_update), .C(n17), .Y(N89) );
  INVX1 I144 ( .A(Z_S6), .Y(n290) );
  AND4X1 I145 ( .A(n290), .B(TH0_carry_7), .C(n870), .D(n300), .Y(N86) );
  INVX1 I146 ( .A(n37), .Y(n310) );
  AND2X2 I147 ( .A(n17), .B(n870), .Y(N90) );
  OAI2BB2X1 I148 ( .A0N(TL0[0]), .A1N(n9), .B0(n9), .B1(n16), .Y(
        TH0_TL0_OUT[0]) );
  XOR2X1 I149 ( .A(n800), .B(n81), .Y(n79) );
  AND2X2 I150 ( .A(TL0_carry_4), .B(TL0[5]), .Y(n81) );
  XOR2X1 I151 ( .A(TL0_carry_4), .B(n830), .Y(n820) );
  INVX1 I152 ( .A(TL0_inc_3_), .Y(n650) );
  INVX1 I153 ( .A(TL0_inc_2_), .Y(n660) );
  OAI2BB2X1 I154 ( .A0N(TL0[1]), .A1N(n9), .B0(n9), .B1(n15), .Y(
        TH0_TL0_OUT[1]) );
  OAI2BB2X1 I155 ( .A0N(TH0_inc[0]), .A1N(n25), .B0(n26), .B1(n49), .Y(N53) );
  OAI2BB2X1 I156 ( .A0N(TL0[7]), .A1N(n9), .B0(n8), .B1(n9), .Y(TH0_TL0_OUT[7]) );
  OAI2BB2X1 I157 ( .A0N(TL0[6]), .A1N(n9), .B0(n9), .B1(n10), .Y(
        TH0_TL0_OUT[6]) );
  OAI2BB2X1 I158 ( .A0N(TL0[5]), .A1N(n9), .B0(n9), .B1(n11), .Y(
        TH0_TL0_OUT[5]) );
  OAI2BB2X1 I159 ( .A0N(TL0[4]), .A1N(n9), .B0(n9), .B1(n12), .Y(
        TH0_TL0_OUT[4]) );
  OAI2BB2X1 I160 ( .A0N(TL0[3]), .A1N(n9), .B0(n9), .B1(n13), .Y(
        TH0_TL0_OUT[3]) );
  OAI2BB2X1 I161 ( .A0N(TL0[2]), .A1N(n9), .B0(n9), .B1(n14), .Y(
        TH0_TL0_OUT[2]) );
  XOR2X1 I162 ( .A(TL0[7]), .B(n880), .Y(n840) );
  INVX1 I163 ( .A(TL0_inc_4_), .Y(n64) );
  INVX1 I164 ( .A(TL0_inc_1_), .Y(n67) );
  INVX1 I165 ( .A(TL0_inc_0_), .Y(n68) );
  OR2X2 I166 ( .A(TMOD30[0]), .B(n40), .Y(n560) );
  INVX1 I167 ( .A(TMOD30[1]), .Y(n40) );
  NAND2X1 I168 ( .A(TL0_carry_4), .B(n40), .Y(n41) );
  INVX1 I169 ( .A(n73), .Y(n540) );
  OAI211X1 I170 ( .A0(sample_INT0), .A1(n74), .B0(TR0), .C0(n75), .Y(n73) );
  INVX1 I171 ( .A(TMOD30[3]), .Y(n74) );
  OAI2BB1X1 I172 ( .A0N(before_T0), .A1N(n76), .B0(TMOD30[2]), .Y(n75) );
  NAND2BX1 I173 ( .AN(n880), .B(TL0[7]), .Y(n85) );
  INVX1 I174 ( .A(TMOD30[0]), .Y(n38) );
  NAND2X1 I175 ( .A(TH0_carry), .B(Z_S5), .Y(n23) );
  INVX1 I176 ( .A(Z_S5), .Y(n21) );
  OR2X2 I177 ( .A(pin_T0), .B(n860), .Y(N80) );
  OAI2BB1X1 I178 ( .A0N(current_T0), .A1N(Z_S5), .B0(n870), .Y(N65) );
  EDFFX1 before_T0_reg ( .D(N65), .CK(clk_b), .E(N66), .Q(before_T0) );
  EDFFX1 current_T0_reg ( .D(N80), .CK(clk_b), .E(N66), .Q(current_T0), .QN(
        n76) );
  EDFFX2 TL0_carry_reg ( .D(N82), .CK(clk_b), .E(N84), .QN(n20) );
  INVX1 I179 ( .A(SFR_bus[1]), .Y(n48) );
  INVX1 I180 ( .A(SFR_bus[0]), .Y(n49) );
  timer0_DW01_inc_9_0 add_135 ( .A({1'b0, TH0}), .SUM({TH0_carry_7, TH0_inc})
         );
  timer0_DW01_inc_6_0 add_104 ( .A({1'b0, TL0[4:0]}), .SUM({TL0_carry_4, 
        TL0_inc_4_, TL0_inc_3_, TL0_inc_2_, TL0_inc_1_, TL0_inc_0_}) );
endmodule


module timer0_DW01_inc_6_0 ( A, SUM );
  input [5:0] A;
  output [5:0] SUM;
  wire   carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(SUM[5]) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module timer0_DW01_inc_9_0 ( A, SUM );
  input [8:0] A;
  output [8:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  CMPR22X1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(SUM[8]) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
endmodule


module t01_control ( sw_rst, clk_b, TCON_sel, TMOD_sel, SFR_wr, SFR_bus, 
        clear_TF0, clear_TF1, set_TF0, set_TF1, TCON30, TF0, TF1, TR0, TR1, 
        TCON_TMOD_OUT, TMOD );
  input [7:0] SFR_bus;
  input [3:0] TCON30;
  output [7:0] TCON_TMOD_OUT;
  output [7:0] TMOD;
  input sw_rst, clk_b, TCON_sel, TMOD_sel, SFR_wr, clear_TF0, clear_TF1,
         set_TF0, set_TF1;
  output TF0, TF1, TR0, TR1;
  wire   N6, N7, N8, N9, N10, N11, N12, N13, N31, N33, N35, N37, N38, n3, n4,
         n60, n80, n100, n110, n130, n20, n21, n22, n23, n27, n310, n350, n36,
         n370, n380, n39, n40, n41, n42, n43, n44, n45;

  OAI211X4 U37 ( .A0(n41), .A1(set_TF0), .B0(n27), .C0(n45), .Y(n21) );
  OAI211X4 U42 ( .A0(n41), .A1(set_TF1), .B0(n310), .C0(n45), .Y(n23) );
  AOI21X1 I56 ( .A0(TMOD[7]), .A1(n4), .B0(n3), .Y(n350) );
  INVX1 I57 ( .A(n350), .Y(TCON_TMOD_OUT[7]) );
  AOI21X1 I58 ( .A0(TMOD[6]), .A1(n4), .B0(n60), .Y(n36) );
  INVX1 I59 ( .A(n36), .Y(TCON_TMOD_OUT[6]) );
  AOI21X1 I60 ( .A0(TMOD[5]), .A1(n4), .B0(n80), .Y(n370) );
  INVX1 I61 ( .A(n370), .Y(TCON_TMOD_OUT[5]) );
  AOI21X1 I62 ( .A0(TMOD[3]), .A1(n4), .B0(n110), .Y(n380) );
  INVX1 I63 ( .A(n380), .Y(TCON_TMOD_OUT[3]) );
  OAI2BB1X1 I64 ( .A0N(TMOD[0]), .A1N(n4), .B0(n43), .Y(TCON_TMOD_OUT[0]) );
  AOI21X1 I65 ( .A0(TMOD[2]), .A1(n4), .B0(n130), .Y(n39) );
  INVX1 I66 ( .A(n39), .Y(TCON_TMOD_OUT[2]) );
  AOI21X1 I67 ( .A0(TMOD[4]), .A1(n4), .B0(n100), .Y(n40) );
  INVX1 I68 ( .A(n40), .Y(TCON_TMOD_OUT[4]) );
  OAI2BB1X1 I69 ( .A0N(TMOD[1]), .A1N(n4), .B0(n44), .Y(TCON_TMOD_OUT[1]) );
  AOI2BB1X1 I70 ( .A0N(set_TF1), .A1N(SFR_bus[7]), .B0(n23), .Y(N33) );
  AOI2BB1X1 I71 ( .A0N(set_TF0), .A1N(SFR_bus[5]), .B0(n21), .Y(N35) );
  AND2X2 I72 ( .A(TCON_sel), .B(SFR_wr), .Y(n41) );
  EDFFX1 TCON74_reg_3_ ( .D(N33), .CK(clk_b), .E(N37), .Q(TF1) );
  AND3X2 I73 ( .A(SFR_wr), .B(TMOD_sel), .C(n45), .Y(n42) );
  INVX1 I74 ( .A(sw_rst), .Y(n45) );
  INVX2 I75 ( .A(TCON_sel), .Y(n4) );
  EDFFX1 TMOD_reg_0_ ( .D(N6), .CK(clk_b), .E(N31), .Q(TMOD[0]) );
  EDFFX1 TMOD_reg_1_ ( .D(N7), .CK(clk_b), .E(N31), .Q(TMOD[1]) );
  EDFFX1 TMOD_reg_5_ ( .D(N11), .CK(clk_b), .E(N31), .Q(TMOD[5]) );
  EDFFX1 TMOD_reg_3_ ( .D(N9), .CK(clk_b), .E(N31), .Q(TMOD[3]) );
  EDFFX1 TMOD_reg_7_ ( .D(N13), .CK(clk_b), .E(N31), .Q(TMOD[7]) );
  EDFFX1 TMOD_reg_6_ ( .D(N12), .CK(clk_b), .E(N31), .Q(TMOD[6]) );
  EDFFX1 TMOD_reg_2_ ( .D(N8), .CK(clk_b), .E(N31), .Q(TMOD[2]) );
  EDFFX1 TMOD_reg_4_ ( .D(N10), .CK(clk_b), .E(N31), .Q(TMOD[4]) );
  AND2X2 I76 ( .A(SFR_bus[7]), .B(n42), .Y(N13) );
  AND2X2 I77 ( .A(SFR_bus[6]), .B(n42), .Y(N12) );
  AND2X2 I78 ( .A(SFR_bus[5]), .B(n42), .Y(N11) );
  AND2X2 I79 ( .A(SFR_bus[4]), .B(n42), .Y(N10) );
  AND2X2 I80 ( .A(SFR_bus[3]), .B(n42), .Y(N9) );
  AND2X2 I81 ( .A(SFR_bus[2]), .B(n42), .Y(N8) );
  OR2X2 I82 ( .A(n42), .B(sw_rst), .Y(N31) );
  EDFFX1 TCON74_reg_1_ ( .D(N35), .CK(clk_b), .E(N38), .Q(TF0) );
  OR3X2 I83 ( .A(sw_rst), .B(clear_TF1), .C(n22), .Y(N37) );
  INVX1 I84 ( .A(n23), .Y(n22) );
  OR3X2 I85 ( .A(sw_rst), .B(clear_TF0), .C(n20), .Y(N38) );
  INVX1 I86 ( .A(n21), .Y(n20) );
  NAND2X1 I87 ( .A(TCON30[0]), .B(TCON_sel), .Y(n43) );
  NAND2X1 I88 ( .A(TCON30[1]), .B(TCON_sel), .Y(n44) );
  AND2X2 I89 ( .A(TCON30[2]), .B(TCON_sel), .Y(n130) );
  AND2X2 I90 ( .A(TCON30[3]), .B(TCON_sel), .Y(n110) );
  AND2X2 I91 ( .A(TF1), .B(TCON_sel), .Y(n3) );
  AND2X2 I92 ( .A(TR1), .B(TCON_sel), .Y(n60) );
  AND2X2 I93 ( .A(TF0), .B(TCON_sel), .Y(n80) );
  AND2X2 I94 ( .A(TR0), .B(TCON_sel), .Y(n100) );
  INVX1 I95 ( .A(clear_TF1), .Y(n310) );
  INVX1 I96 ( .A(clear_TF0), .Y(n27) );
  EDFFTRX1 TCON74_reg_2_ ( .D(SFR_bus[6]), .CK(clk_b), .E(n41), .RN(n45), .Q(
        TR1) );
  EDFFTRX1 TCON74_reg_0_ ( .D(SFR_bus[4]), .CK(clk_b), .E(n41), .RN(n45), .Q(
        TR0) );
  AND2X1 I97 ( .A(SFR_bus[1]), .B(n42), .Y(N7) );
  AND2X1 I98 ( .A(SFR_bus[0]), .B(n42), .Y(N6) );
endmodule


module t2_cycle ( reset, clk, T2M, T2M_S1, T2M_S2 );
  input reset, clk, T2M;
  output T2M_S1, T2M_S2;
  wire   T2M_d, N68, N70, N71, N72, N86, N87, N93, n2, n3, n4, n5, n6, n10,
         n12, n17, n21, n22, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n37, n38, n39, n41, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62;
  wire   [3:0] T2_six_state;
  wire   [1:0] T2_four_state;

  OAI32X4 U3 ( .A0(n6), .A1(n60), .A2(n50), .B0(N93), .B1(n38), .Y(n39) );
  OAI32X4 U5 ( .A0(n6), .A1(T2_six_state[3]), .A2(n50), .B0(N93), .B1(n34), 
        .Y(n35) );
  OAI32X4 U6 ( .A0(n6), .A1(T2_six_state[3]), .A2(T2_six_state[1]), .B0(N93), 
        .B1(n32), .Y(n33) );
  OAI32X4 U20 ( .A0(n53), .A1(reset), .A2(n54), .B0(reset), .B1(
        T2_six_state[0]), .Y(n17) );
  MXI2X1 I43 ( .S0(T2M_d), .B(n4), .A(n2), .Y(T2M_S1) );
  MXI2X2 I44 ( .S0(T2M_d), .B(n5), .A(n3), .Y(T2M_S2) );
  NAND2X1 I45 ( .A(T2_four_state[0]), .B(T2_four_state[1]), .Y(n12) );
  AOI32X1 I46 ( .A0(n46), .A1(n54), .A2(n50), .B0(n47), .B1(n48), .Y(n49) );
  INVX1 I47 ( .A(n6), .Y(n46) );
  INVX1 I48 ( .A(N93), .Y(n47) );
  INVX1 I49 ( .A(n49), .Y(n37) );
  DFFTRX1 T2_six_state_reg_1_ ( .D(N70), .CK(clk), .RN(n44), .Q(
        T2_six_state[1]), .QN(n50) );
  DFFHQX2 T2M_d_reg ( .D(T2M), .CK(clk), .Q(T2M_d) );
  DFFTRX1 T2_four_state_reg_1_ ( .D(N68), .CK(clk), .RN(n45), .Q(
        T2_four_state[1]), .QN(n41) );
  DFFTRX2 T2_six_state_reg_3_ ( .D(N72), .CK(clk), .RN(n44), .Q(
        T2_six_state[3]), .QN(n53) );
  DFFTRX1 T2_six_state_reg_0_ ( .D(n51), .CK(clk), .RN(n44), .Q(
        T2_six_state[0]), .QN(n51) );
  DFFTRX1 T2_four_state_reg_0_ ( .D(n52), .CK(clk), .RN(n45), .Q(
        T2_four_state[0]), .QN(n52) );
  BUFX3 I50 ( .A(T2_six_state[2]), .Y(n60) );
  NAND2X1 I51 ( .A(T2_six_state[1]), .B(T2_six_state[0]), .Y(n61) );
  INVX2 I52 ( .A(reset), .Y(n59) );
  DFFTRX1 T2_four_S1_reg ( .D(n58), .CK(clk), .RN(n59), .QN(n4) );
  OR3X2 I53 ( .A(n53), .B(n54), .C(n10), .Y(N93) );
  DFFTRX1 T2_six_state_reg_2_ ( .D(N71), .CK(clk), .RN(n44), .Q(
        T2_six_state[2]), .QN(n54) );
  OR3X2 I54 ( .A(n57), .B(n56), .C(n10), .Y(n6) );
  INVX1 I55 ( .A(n17), .Y(n10) );
  AND2X1 I56 ( .A(n57), .B(n17), .Y(N86) );
  AND2X1 I57 ( .A(n56), .B(n17), .Y(N87) );
  NOR2X1 I58 ( .A(reset), .B(n58), .Y(n55) );
  XNOR2X1 I59 ( .A(n60), .B(n61), .Y(N71) );
  AND2X2 I60 ( .A(n55), .B(n52), .Y(n30) );
  NOR2BX1 I61 ( .AN(n55), .B(n12), .Y(n31) );
  NOR3X1 I62 ( .A(T2_six_state[3]), .B(n60), .C(n50), .Y(n56) );
  AND3X2 U39 ( .A(n35), .B(n60), .C(n59), .Y(n26) );
  AND3X2 U41 ( .A(T2_six_state[3]), .B(n59), .C(n39), .Y(n28) );
  AND3X2 U42 ( .A(T2_six_state[3]), .B(n59), .C(n37), .Y(n29) );
  AND3X2 U40 ( .A(n59), .B(n60), .C(n33), .Y(n27) );
  NOR3X1 I63 ( .A(T2_six_state[3]), .B(T2_six_state[1]), .C(n60), .Y(n57) );
  AND3X2 I64 ( .A(n21), .B(n59), .C(n22), .Y(n44) );
  INVX1 I65 ( .A(T2M), .Y(n21) );
  OR4X2 I66 ( .A(n50), .B(n51), .C(n60), .D(n53), .Y(n22) );
  AND3X2 I67 ( .A(T2M), .B(n59), .C(n12), .Y(n45) );
  XOR2X1 I68 ( .A(T2_six_state[1]), .B(T2_six_state[0]), .Y(N70) );
  XOR2X1 I69 ( .A(T2_four_state[1]), .B(T2_four_state[0]), .Y(N68) );
  XOR2X1 I70 ( .A(T2_six_state[3]), .B(n62), .Y(N72) );
  NOR2X1 I71 ( .A(n61), .B(n54), .Y(n62) );
  NOR2X1 I72 ( .A(T2_four_state[0]), .B(T2_four_state[1]), .Y(n58) );
  EDFFX1 T2_six_S1_reg ( .D(N86), .CK(clk), .E(N93), .QN(n2) );
  DFFTRX1 T2_four_S2_reg ( .D(n55), .CK(clk), .RN(n41), .QN(n5) );
  EDFFX1 T2_six_S2_reg ( .D(N87), .CK(clk), .E(N93), .QN(n3) );
  DFFX1 T2_six_S4_reg ( .D(n26), .CK(clk), .QN(n34) );
  DFFX1 T2_six_S3_reg ( .D(n27), .CK(clk), .QN(n32) );
  DFFX1 T2_six_S6_reg ( .D(n28), .CK(clk), .QN(n38) );
  DFFX1 T2_six_S5_reg ( .D(n29), .CK(clk), .Q(n48) );
  DFFX4 T2_four_S3_reg ( .D(n30), .CK(clk) );
  DFFX4 T2_four_S4_reg ( .D(n31), .CK(clk) );
endmodule


module t1_cycle ( reset, clk, T1M, T1M_S1, T1M_S2, T1M_S4, T1M_S5, T1M_S6 );
  input reset, clk, T1M;
  output T1M_S1, T1M_S2, T1M_S4, T1M_S5, T1M_S6;
  wire   T1M_d, N68, N70, N71, N72, N86, N87, N90, N91, N93, n2, n3, n4, n5,
         n7, n8, n10, n11, n14, n15, n16, n17, n20, n21, n24, n25, n28, n29,
         n30, n34, n35, n36, n37, n39, n41, n42, n43, n44, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, n57, n58, n59;
  wire   [3:0] T1_six_state;
  wire   [1:0] T1_four_state;

  OAI32X4 U27 ( .A0(n55), .A1(reset), .A2(n51), .B0(reset), .B1(
        T1_six_state[0]), .Y(n25) );
  DFFHQX4 T1M_d_reg ( .D(T1M), .CK(clk), .Q(T1M_d) );
  MXI2X1 I48 ( .S0(T1M_d), .B(n8), .A(n3), .Y(T1M_S1) );
  NAND2X1 I49 ( .A(n51), .B(T1_six_state[1]), .Y(n16) );
  MX2X1 I50 ( .S0(T1M_d), .B(n49), .A(n5), .Y(T1M_S5) );
  NAND2X1 I51 ( .A(n54), .B(n55), .Y(n14) );
  NAND2X1 I52 ( .A(n43), .B(n42), .Y(n34) );
  AND4X2 I53 ( .A(n15), .B(T1_six_state[2]), .C(n57), .D(n10), .Y(n35) );
  MX2X1 I54 ( .S0(T1M_d), .B(n50), .A(n5), .Y(T1M_S4) );
  AND4X2 I55 ( .A(T1_six_state[3]), .B(n57), .C(n11), .D(n10), .Y(n36) );
  INVX2 I56 ( .A(T1M_d), .Y(n17) );
  DFFTRX1 T1_four_state_reg_1_ ( .D(N68), .CK(clk), .RN(n48), .Q(
        T1_four_state[1]), .QN(n43) );
  DFFTRX1 T1_four_S1_reg ( .D(n44), .CK(clk), .RN(n57), .QN(n8) );
  DFFTRX1 T1_six_state_reg_3_ ( .D(N72), .CK(clk), .RN(n47), .Q(
        T1_six_state[3]), .QN(n51) );
  DFFTRX1 T1_six_state_reg_1_ ( .D(N70), .CK(clk), .RN(n47), .Q(
        T1_six_state[1]), .QN(n54) );
  DFFTRX2 T1_six_state_reg_2_ ( .D(N71), .CK(clk), .RN(n47), .Q(
        T1_six_state[2]), .QN(n55) );
  DFFTRX1 T1_six_state_reg_0_ ( .D(n52), .CK(clk), .RN(n47), .Q(
        T1_six_state[0]), .QN(n52) );
  DFFTRX1 T1_four_state_reg_0_ ( .D(n42), .CK(clk), .RN(n48), .Q(
        T1_four_state[0]), .QN(n42) );
  DFFTRX1 T1_four_S2_reg ( .D(n41), .CK(clk), .RN(n43), .Q(n50), .QN(n53) );
  EDFFX1 T1_six_S3_reg ( .D(N91), .CK(clk), .E(N93), .Q(n5) );
  INVX1 I57 ( .A(n21), .Y(n10) );
  INVX1 I58 ( .A(reset), .Y(n57) );
  OAI2BB1X1 I59 ( .A0N(n55), .A1N(n51), .B0(n25), .Y(n24) );
  OR2X2 I60 ( .A(n56), .B(n24), .Y(n21) );
  OR3X2 I61 ( .A(n20), .B(n55), .C(n21), .Y(N93) );
  AND3X1 I62 ( .A(n56), .B(n55), .C(n25), .Y(N86) );
  AND3X2 I63 ( .A(n20), .B(n55), .C(n25), .Y(N87) );
  AND3X2 I64 ( .A(n14), .B(n55), .C(n10), .Y(N90) );
  INVX1 I65 ( .A(n16), .Y(n20) );
  NOR2BX1 I66 ( .AN(n56), .B(n24), .Y(N91) );
  AND2X2 I67 ( .A(n34), .B(n57), .Y(n41) );
  INVX1 I68 ( .A(n28), .Y(n46) );
  INVX1 I69 ( .A(n34), .Y(n44) );
  NOR2X1 I70 ( .A(T1_six_state[1]), .B(T1_six_state[3]), .Y(n56) );
  OAI22X1 I71 ( .A0(n17), .A1(n7), .B0(T1M_d), .B1(n2), .Y(T1M_S6) );
  OAI22X1 I72 ( .A0(n17), .A1(n53), .B0(T1M_d), .B1(n4), .Y(T1M_S2) );
  OAI31X1 I73 ( .A0(n55), .A1(n39), .A2(n51), .B0(n14), .Y(n11) );
  OAI2BB1X1 I74 ( .A0N(n37), .A1N(T1_six_state[2]), .B0(n16), .Y(n15) );
  NAND2X1 I75 ( .A(T1_six_state[1]), .B(T1_six_state[0]), .Y(n58) );
  NAND2X1 I76 ( .A(T1_four_state[0]), .B(T1_four_state[1]), .Y(n28) );
  AND3X2 I77 ( .A(n29), .B(n57), .C(n30), .Y(n47) );
  INVX1 I78 ( .A(T1M), .Y(n29) );
  OR4X2 I79 ( .A(n54), .B(n52), .C(T1_six_state[2]), .D(n51), .Y(n30) );
  AND3X2 I80 ( .A(T1M), .B(n57), .C(n28), .Y(n48) );
  XNOR2X1 I81 ( .A(T1_six_state[2]), .B(n58), .Y(N71) );
  XOR2X1 I82 ( .A(T1_six_state[1]), .B(T1_six_state[0]), .Y(N70) );
  XOR2X1 I83 ( .A(T1_four_state[1]), .B(T1_four_state[0]), .Y(N68) );
  XOR2X1 I84 ( .A(T1_six_state[3]), .B(n59), .Y(N72) );
  NOR2X1 I85 ( .A(n58), .B(n55), .Y(n59) );
  DFFTRX1 T1_four_S3_reg ( .D(n41), .CK(clk), .RN(n42), .Q(n49) );
  DFFTRX1 T1_four_S4_reg ( .D(n46), .CK(clk), .RN(n41), .QN(n7) );
  EDFFX1 T1_six_S6_reg ( .D(N90), .CK(clk), .E(N93), .QN(n2) );
  EDFFX1 T1_six_S1_reg ( .D(N86), .CK(clk), .E(N93), .QN(n3) );
  EDFFX1 T1_six_S2_reg ( .D(N87), .CK(clk), .E(N93), .QN(n4) );
  DFFX1 T1_six_S4_reg ( .D(n35), .CK(clk), .Q(n37) );
  DFFX1 T1_six_S5_reg ( .D(n36), .CK(clk), .QN(n39) );
endmodule


module t0_cycle ( reset, clk, T0M, T0M_S1, T0M_S2, T0M_S5, T0M_S6 );
  input reset, clk, T0M;
  output T0M_S1, T0M_S2, T0M_S5, T0M_S6;
  wire   T0M_d, N68, N70, N71, N72, N86, N87, N90, N91, N93, n2, n3, n4, n5,
         n6, n7, n8, n9, n10, n11, n14, n15, n16, n18, n19, n22, n23, n26, n27,
         n28, n32, n33, n34, n35, n37, n39, n40, n41, n42, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54;
  wire   [3:0] six_state;
  wire   [1:0] four_state;

  OAI32X4 U24 ( .A0(n50), .A1(reset), .A2(n47), .B0(six_state[0]), .B1(reset), 
        .Y(n23) );
  DFFHQX4 T0M_d_reg ( .D(T0M), .CK(clk), .Q(T0M_d) );
  MXI2X1 I45 ( .S0(T0M_d), .B(n8), .A(n3), .Y(T0M_S1) );
  MXI2X1 I46 ( .S0(T0M_d), .B(n9), .A(n4), .Y(T0M_S2) );
  NAND2X1 I47 ( .A(n47), .B(six_state[1]), .Y(n16) );
  MXI2X2 I48 ( .S0(T0M_d), .B(n6), .A(n5), .Y(T0M_S5) );
  NAND2X1 I49 ( .A(n49), .B(n50), .Y(n14) );
  MXI2X2 I50 ( .S0(T0M_d), .B(n7), .A(n2), .Y(T0M_S6) );
  AND4X2 I51 ( .A(n15), .B(six_state[2]), .C(n52), .D(n10), .Y(n33) );
  NAND2X1 I52 ( .A(n41), .B(n40), .Y(n32) );
  AND4X2 I53 ( .A(six_state[3]), .B(n52), .C(n11), .D(n10), .Y(n34) );
  DFFTRX1 four_state_reg_1_ ( .D(N68), .CK(clk), .RN(n46), .Q(four_state[1]), 
        .QN(n41) );
  DFFTRX1 six_state_reg_3_ ( .D(N72), .CK(clk), .RN(n45), .Q(six_state[3]), 
        .QN(n47) );
  DFFTRX1 six_state_reg_1_ ( .D(N70), .CK(clk), .RN(n45), .Q(six_state[1]), 
        .QN(n49) );
  DFFTRX2 six_state_reg_2_ ( .D(N71), .CK(clk), .RN(n45), .Q(six_state[2]), 
        .QN(n50) );
  DFFTRX1 six_state_reg_0_ ( .D(n48), .CK(clk), .RN(n45), .Q(six_state[0]), 
        .QN(n48) );
  DFFTRX1 four_state_reg_0_ ( .D(n40), .CK(clk), .RN(n46), .Q(four_state[0]), 
        .QN(n40) );
  INVX1 I54 ( .A(n19), .Y(n10) );
  INVX1 I55 ( .A(reset), .Y(n52) );
  OAI2BB1X1 I56 ( .A0N(n50), .A1N(n47), .B0(n23), .Y(n22) );
  OR2X2 I57 ( .A(n51), .B(n22), .Y(n19) );
  OR3X2 I58 ( .A(n18), .B(n50), .C(n19), .Y(N93) );
  AND3X1 I59 ( .A(n51), .B(n50), .C(n23), .Y(N86) );
  AND3X2 I60 ( .A(n18), .B(n50), .C(n23), .Y(N87) );
  AND3X2 I61 ( .A(n14), .B(n50), .C(n10), .Y(N90) );
  INVX1 I62 ( .A(n16), .Y(n18) );
  NOR2BX1 I63 ( .AN(n51), .B(n22), .Y(N91) );
  AND2X2 I64 ( .A(n32), .B(n52), .Y(n39) );
  INVX1 I65 ( .A(n26), .Y(n44) );
  INVX1 I66 ( .A(n32), .Y(n42) );
  NOR2X1 I67 ( .A(six_state[1]), .B(six_state[3]), .Y(n51) );
  OAI31X1 I68 ( .A0(n50), .A1(n37), .A2(n47), .B0(n14), .Y(n11) );
  OAI2BB1X1 I69 ( .A0N(n35), .A1N(six_state[2]), .B0(n16), .Y(n15) );
  NAND2X1 I70 ( .A(six_state[1]), .B(six_state[0]), .Y(n53) );
  NAND2X1 I71 ( .A(four_state[0]), .B(four_state[1]), .Y(n26) );
  AND3X2 I72 ( .A(n27), .B(n52), .C(n28), .Y(n45) );
  INVX1 I73 ( .A(T0M), .Y(n27) );
  OR4X2 I74 ( .A(n49), .B(n48), .C(six_state[2]), .D(n47), .Y(n28) );
  AND3X2 I75 ( .A(T0M), .B(n52), .C(n26), .Y(n46) );
  XNOR2X1 I76 ( .A(six_state[2]), .B(n53), .Y(N71) );
  XOR2X1 I77 ( .A(six_state[1]), .B(six_state[0]), .Y(N70) );
  XOR2X1 I78 ( .A(four_state[1]), .B(four_state[0]), .Y(N68) );
  XOR2X1 I79 ( .A(six_state[3]), .B(n54), .Y(N72) );
  NOR2X1 I80 ( .A(n53), .B(n50), .Y(n54) );
  DFFTRX1 four_S2_reg ( .D(n39), .CK(clk), .RN(n41), .QN(n9) );
  EDFFX1 six_S2_reg ( .D(N87), .CK(clk), .E(N93), .QN(n4) );
  DFFTRX1 four_S3_reg ( .D(n39), .CK(clk), .RN(n40), .QN(n6) );
  DFFTRX1 four_S1_reg ( .D(n42), .CK(clk), .RN(n52), .QN(n8) );
  EDFFX1 six_S6_reg ( .D(N90), .CK(clk), .E(N93), .QN(n2) );
  EDFFX1 six_S1_reg ( .D(N86), .CK(clk), .E(N93), .QN(n3) );
  EDFFX1 six_S3_reg ( .D(N91), .CK(clk), .E(N93), .QN(n5) );
  DFFTRX1 four_S4_reg ( .D(n44), .CK(clk), .RN(n39), .QN(n7) );
  DFFX1 six_S4_reg ( .D(n33), .CK(clk), .Q(n35) );
  DFFX1 six_S5_reg ( .D(n34), .CK(clk), .QN(n37) );
endmodule


module peri_cycle ( end_of_inst, pcon_idle, pre_pdwn, POR, reset, clk, 
        Z_update, peri_state );
  output [2:0] peri_state;
  input end_of_inst, pcon_idle, pre_pdwn, POR, reset, clk;
  output Z_update;
  wire   n31, n33, N13, N36, N37, N39, N41, N42, n2, n3, n4, n5, n8, n9, n10,
         n11, n12, n14, n15, n16, n17, n19, n20, n21, n22, n23, n24, n26, n28,
         n29, n30;
  wire   [1:0] mach_cycle;

  OAI32X4 U3 ( .A0(n2), .A1(n3), .A2(n4), .B0(n5), .B1(n28), .Y(n23) );
  DFFRHQX4 peri_state_reg_2_ ( .D(N42), .CK(clk), .RN(n19), .Q(peri_state[2])
         );
  OR4X1 I29 ( .A(peri_state[2]), .B(n11), .C(n26), .D(n14), .Y(n12) );
  NOR2X1 I30 ( .A(n28), .B(mach_cycle[0]), .Y(n4) );
  NOR2X1 I31 ( .A(mach_cycle[1]), .B(n2), .Y(n10) );
  OAI31X1 I32 ( .A0(n17), .A1(n31), .A2(peri_state[0]), .B0(n29), .Y(n16) );
  DFFRX1 mach_cycle_reg_1_ ( .D(n21), .CK(clk), .RN(n19), .Q(mach_cycle[1]), 
        .QN(n28) );
  DFFRX1 mach_cycle_reg_0_ ( .D(n20), .CK(clk), .RN(n19), .Q(mach_cycle[0]), 
        .QN(n24) );
  INVX4 I33 ( .A(n14), .Y(peri_state[1]) );
  DFFRHQX1 peri_state_reg_1_ ( .D(N41), .CK(clk), .RN(n19), .Q(n31) );
  OAI2BB1X2 I34 ( .A0N(end_of_inst), .A1N(n11), .B0(n12), .Y(Z_update) );
  INVX1 I35 ( .A(n33), .Y(n26) );
  INVX4 I36 ( .A(n26), .Y(peri_state[0]) );
  DFFRHQX1 peri_state_reg_0_ ( .D(N13), .CK(clk), .RN(n19), .Q(n33) );
  OR4X1 I37 ( .A(peri_state[0]), .B(n17), .C(reset), .D(peri_state[1]), .Y(n2)
         );
  INVX1 I38 ( .A(pre_pdwn), .Y(n8) );
  INVX1 I39 ( .A(reset), .Y(n29) );
  INVX1 I40 ( .A(n2), .Y(n5) );
  NOR2BX1 U27 ( .AN(n22), .B(reset), .Y(n20) );
  OAI2BB1X1 I41 ( .A0N(mach_cycle[0]), .A1N(n2), .B0(n9), .Y(n22) );
  OAI211X1 I42 ( .A0(n10), .A1(mach_cycle[0]), .B0(n24), .C0(n8), .Y(n9) );
  NOR2BX1 U28 ( .AN(n23), .B(reset), .Y(n21) );
  NAND2X1 I43 ( .A(N39), .B(n8), .Y(n3) );
  INVX1 I44 ( .A(pcon_idle), .Y(n11) );
  INVX1 I45 ( .A(n31), .Y(n14) );
  INVX1 I46 ( .A(n16), .Y(n15) );
  INVX1 I47 ( .A(peri_state[2]), .Y(n17) );
  XNOR2X1 I48 ( .A(n28), .B(mach_cycle[0]), .Y(N39) );
  AND2X2 I49 ( .A(N37), .B(n15), .Y(N42) );
  XNOR2X1 I50 ( .A(peri_state[2]), .B(n30), .Y(N37) );
  NAND2X1 I51 ( .A(peri_state[1]), .B(peri_state[0]), .Y(n30) );
  AND2X2 I52 ( .A(N36), .B(n15), .Y(N41) );
  XOR2X1 I53 ( .A(peri_state[1]), .B(peri_state[0]), .Y(N36) );
  INVX2 I54 ( .A(POR), .Y(n19) );
  OAI2BB2X1 I55 ( .A0N(n26), .A1N(n15), .B0(pre_pdwn), .B1(n2), .Y(N13) );
endmodule


module interrupt ( Z_update, EWDI, STOPwake_WDT, DIR_WR, LVD_intr, POR, sw_rst, 
        clk, pin_INT0, pin_INT1, pin_INT2, pin_INT3, pin_INT4, pin_INT5, TF0, 
        TF1, adc_intr, t2_intr, ua_intr, wdt_intr, pwm1_intr, pwm2_intr, pr_st, 
        RETI_end, RETI_NFC, SFR_wr, SFR_bus, TCON_sel, EXIF_sel, IE_sel, 
        IP_sel, EIE_sel, EIP_sel, IPH_sel, clear_TF0, clear_TF1, TCON30, 
        inter_vector, inter_LCALL, sample_INT0, sample_INT1, interrupt_ack, 
        STOPwake_INT0, STOPwake_INT1, INT_SFR_OUT );
  input [2:0] pr_st;
  input [7:0] SFR_bus;
  output [3:0] TCON30;
  output [7:0] inter_vector;
  output [7:0] INT_SFR_OUT;
  input Z_update, DIR_WR, LVD_intr, POR, sw_rst, clk, pin_INT0, pin_INT1,
         pin_INT2, pin_INT3, pin_INT4, pin_INT5, TF0, TF1, adc_intr, t2_intr,
         ua_intr, wdt_intr, pwm1_intr, pwm2_intr, RETI_end, RETI_NFC, SFR_wr,
         TCON_sel, EXIF_sel, IE_sel, IP_sel, EIE_sel, EIP_sel, IPH_sel;
  output EWDI, STOPwake_WDT, clear_TF0, clear_TF1, inter_LCALL, sample_INT0,
         sample_INT1, interrupt_ack, STOPwake_INT0, STOPwake_INT1;
  wire   ir_EX1, ir_EX0, ir_clr_IE0, ir_clr_IE1, INT_SFR_sel, n5, n6;
  wire   [7:0] IE;
  wire   [7:0] IPH;
  wire   [7:0] IP;
  wire   [4:0] new_src;
  wire   [2:0] new_pri;
  wire   [7:0] EIE;
  wire   [7:0] EIP;
  wire   [7:0] EXIF;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1;

  ir_ext ir_ext ( .Z_update(Z_update), .SFR_bus(SFR_bus), .EXIF(EXIF), 
        .pin_INT2(pin_INT2), .pin_INT3(pin_INT3), .pin_INT4(pin_INT4), 
        .pin_INT5(pin_INT5), .EXIF_sel(EXIF_sel), .TCON_sel(TCON_sel), 
        .SFR_wr(SFR_wr), .sw_rst(n5), .clk(clk), .pr_st(pr_st), .pin_INT0(
        pin_INT0), .pin_INT1(pin_INT1), .ir_EX1(ir_EX1), .ir_EX0(ir_EX0), 
        .STOPwake_INT0(STOPwake_INT0), .STOPwake_INT1(STOPwake_INT1), 
        .ir_clr_IE0(ir_clr_IE0), .ir_clr_IE1(ir_clr_IE1), .TCON30(TCON30), 
        .sample_INT0(sample_INT0), .sample_INT1(sample_INT1), .POR(POR) );
  ir_ctrl ir_ctrl ( .POR(POR), .DIR_WR(DIR_WR), .pr_st(pr_st), .RETI_end(
        RETI_end), .RETI_NFC(RETI_NFC), .INT_SFR_sel(INT_SFR_sel), .new_src(
        new_src), .new_pri(new_pri), .sw_rst(n5), .clk(clk), .inter_vector({
        SYNOPSYS_UNCONNECTED__0, inter_vector[6:3], SYNOPSYS_UNCONNECTED__1, 
        inter_vector[1:0]}), .inter_LCALL(inter_LCALL), .interrupt_ack(
        interrupt_ack), .clear_TF1(clear_TF1), .ir_clr_IE1(ir_clr_IE1), 
        .clear_TF0(clear_TF0), .ir_clr_IE0(ir_clr_IE0) );
  ir_poll ir_poll ( .STOPwake_WDT(STOPwake_WDT), .LVD_intr(LVD_intr), .EIE(EIE), .EIP(EIP), .exif_IE2(EXIF[4]), .exif_IE3(EXIF[5]), .exif_IE4(EXIF[6]), 
        .exif_IE5(EXIF[7]), .wdt_intr(wdt_intr), .pwm1_intr(pwm1_intr), 
        .pwm2_intr(pwm2_intr), .IE(IE), .IPH(IPH), .IP(IP), .adc_intr(adc_intr), .t2_intr(t2_intr), .ua_intr(ua_intr), .TF1(TF1), .tcon_IE1(TCON30[3]), .TF0(
        TF0), .tcon_IE0(TCON30[1]), .new_src(new_src), .new_pri(new_pri), 
        .ir_EX1(ir_EX1), .ir_EX0(ir_EX0) );
  ip_dp ip_dp ( .EWDI(EWDI), .sw_rst(n5), .clk(clk), .SFR_wr(SFR_wr), 
        .SFR_bus(SFR_bus), .IE_sel(IE_sel), .IP_sel(IP_sel), .IPH_sel(IPH_sel), 
        .EIE_sel(EIE_sel), .EIP_sel(EIP_sel), .EXIF_sel(EXIF_sel), .EXIF(EXIF), 
        .EIE(EIE), .EIP(EIP), .IE(IE), .IPH(IPH), .IP(IP), .INT_SFR_sel(
        INT_SFR_sel), .INT_SFR_OUT(INT_SFR_OUT) );
  INVX1 I1 ( .A(1'b1), .Y(inter_vector[2]) );
  INVX1 I3 ( .A(1'b1), .Y(inter_vector[7]) );
  INVX4 I5 ( .A(n6), .Y(n5) );
  INVX1 I6 ( .A(sw_rst), .Y(n6) );
endmodule


module ip_dp ( EWDI, sw_rst, clk, SFR_wr, SFR_bus, IE_sel, IP_sel, IPH_sel, 
        EIE_sel, EIP_sel, EXIF_sel, EXIF, EIE, EIP, IE, IPH, IP, INT_SFR_sel, 
        INT_SFR_OUT );
  input [7:0] SFR_bus;
  input [7:0] EXIF;
  output [7:0] EIE;
  output [7:0] EIP;
  output [7:0] IE;
  output [7:0] IPH;
  output [7:0] IP;
  output [7:0] INT_SFR_OUT;
  input sw_rst, clk, SFR_wr, IE_sel, IP_sel, IPH_sel, EIE_sel, EIP_sel,
         EXIF_sel;
  output EWDI, INT_SFR_sel;
  wire   N19, N20, N21, N22, N23, N24, N25, N26, N30, N31, N32, N33, N34, N35,
         N36, N37, N40, N41, N42, N43, N44, N45, N46, N47, N50, N51, N52, N53,
         N54, N55, N56, N59, N60, N61, N62, N63, N64, N65, N67, N68, N69, N70,
         N71, n4, n6, n9, n10, n13, n14, n17, n190, n210, n220, n250, n260,
         n27, n300, n310, n320, n330, n340, n350, n360, n370, n38, n39, n400,
         n410, n420, n430, n440, n450, n460, n470, n48, n49, n500, n530, n550,
         n57, n58, n590, n600, n610, n620, n630, n640, n650, n670;

  AOI221X4 U64 ( .A0(EIP[7]), .A1(n610), .B0(EXIF[7]), .B1(n650), .C0(n250), 
        .Y(n220) );
  AOI222X4 U66 ( .A0(EIE[7]), .A1(n590), .B0(IP[7]), .B1(IP_sel), .C0(IPH[7]), 
        .C1(n600), .Y(n27) );
  AOI221X4 U68 ( .A0(EIP[6]), .A1(n610), .B0(EXIF[6]), .B1(n650), .C0(n310), 
        .Y(n300) );
  AOI222X4 U70 ( .A0(EIE[6]), .A1(n590), .B0(IP[6]), .B1(IP_sel), .C0(IPH[6]), 
        .C1(n600), .Y(n320) );
  AOI221X4 U72 ( .A0(EIP[5]), .A1(n610), .B0(EXIF[5]), .B1(n650), .C0(n340), 
        .Y(n330) );
  AOI222X4 U74 ( .A0(EIE[5]), .A1(n590), .B0(IP[5]), .B1(IP_sel), .C0(IPH[5]), 
        .C1(n600), .Y(n350) );
  AOI221X4 U76 ( .A0(EIP[4]), .A1(n610), .B0(EXIF[4]), .B1(n650), .C0(n370), 
        .Y(n360) );
  AOI222X4 U78 ( .A0(EWDI), .A1(n590), .B0(IP[4]), .B1(IP_sel), .C0(IPH[4]), 
        .C1(n600), .Y(n38) );
  AOI221X4 U80 ( .A0(EIP[3]), .A1(n610), .B0(EXIF[3]), .B1(n650), .C0(n400), 
        .Y(n39) );
  AOI222X4 U82 ( .A0(EIE[3]), .A1(n590), .B0(IP[3]), .B1(IP_sel), .C0(IPH[3]), 
        .C1(n600), .Y(n410) );
  AOI221X4 U84 ( .A0(EIP[2]), .A1(n610), .B0(EXIF[2]), .B1(n650), .C0(n430), 
        .Y(n420) );
  AOI222X4 U86 ( .A0(EIE[2]), .A1(n590), .B0(IP[2]), .B1(IP_sel), .C0(IPH[2]), 
        .C1(n600), .Y(n440) );
  AOI221X4 U88 ( .A0(EIP[1]), .A1(n610), .B0(EXIF[1]), .B1(n650), .C0(n460), 
        .Y(n450) );
  AOI222X4 U90 ( .A0(EIE[1]), .A1(n590), .B0(IP[1]), .B1(IP_sel), .C0(IPH[1]), 
        .C1(n600), .Y(n470) );
  AOI221X4 U92 ( .A0(EIP[0]), .A1(n610), .B0(EXIF[0]), .B1(n650), .C0(n49), 
        .Y(n48) );
  AOI222X4 U94 ( .A0(EIE[0]), .A1(n590), .B0(IP[0]), .B1(IP_sel), .C0(IPH[0]), 
        .C1(n600), .Y(n500) );
  INVX1 I110 ( .A(EXIF_sel), .Y(n550) );
  INVX2 I111 ( .A(n14), .Y(n6) );
  EDFFX2 IPH_reg_6_ ( .D(N56), .CK(clk), .E(N70), .Q(IPH[6]) );
  EDFFX1 IPH_reg_5_ ( .D(N55), .CK(clk), .E(N70), .Q(IPH[5]) );
  OR3X1 I112 ( .A(EXIF_sel), .B(EIP_sel), .C(n530), .Y(n210) );
  INVX2 I113 ( .A(EIP_sel), .Y(n17) );
  NOR2X2 I114 ( .A(IP_sel), .B(n13), .Y(n600) );
  NOR2X2 I115 ( .A(n10), .B(n13), .Y(n640) );
  NOR2X2 I116 ( .A(n17), .B(n530), .Y(n610) );
  OR3X2 I117 ( .A(EIE_sel), .B(IPH_sel), .C(IP_sel), .Y(n530) );
  NOR2X2 I118 ( .A(n10), .B(n190), .Y(n620) );
  NOR3X4 I119 ( .A(EIP_sel), .B(n550), .C(n530), .Y(n650) );
  NOR2X2 I120 ( .A(n10), .B(n17), .Y(n630) );
  OR3X2 I121 ( .A(IP_sel), .B(IPH_sel), .C(n190), .Y(n58) );
  INVX2 I122 ( .A(n58), .Y(n590) );
  AND2X1 I123 ( .A(n640), .B(SFR_bus[6]), .Y(N56) );
  AND2X1 I124 ( .A(n640), .B(SFR_bus[5]), .Y(N55) );
  AND2X1 I125 ( .A(n620), .B(SFR_bus[7]), .Y(N26) );
  AND2X1 I126 ( .A(n620), .B(SFR_bus[6]), .Y(N25) );
  AND2X1 I127 ( .A(n620), .B(SFR_bus[5]), .Y(N24) );
  AND2X1 I128 ( .A(n620), .B(SFR_bus[4]), .Y(N23) );
  AND2X1 I129 ( .A(n620), .B(SFR_bus[3]), .Y(N22) );
  AND2X1 I130 ( .A(n620), .B(SFR_bus[2]), .Y(N21) );
  AND2X1 I131 ( .A(n630), .B(SFR_bus[7]), .Y(N37) );
  AND2X1 I132 ( .A(n630), .B(SFR_bus[6]), .Y(N36) );
  AND2X1 I133 ( .A(n630), .B(SFR_bus[5]), .Y(N35) );
  AND2X1 I134 ( .A(n630), .B(SFR_bus[4]), .Y(N34) );
  AND2X1 I135 ( .A(n630), .B(SFR_bus[3]), .Y(N33) );
  AND2X1 I136 ( .A(n630), .B(SFR_bus[2]), .Y(N32) );
  AND2X1 I137 ( .A(n640), .B(SFR_bus[4]), .Y(N54) );
  AND2X1 I138 ( .A(n640), .B(SFR_bus[3]), .Y(N53) );
  AND2X1 I139 ( .A(n640), .B(SFR_bus[2]), .Y(N52) );
  NAND2BX1 I140 ( .AN(n10), .B(IP_sel), .Y(n9) );
  OR2X1 I141 ( .A(IE_sel), .B(n210), .Y(INT_SFR_sel) );
  NAND2BX1 I142 ( .AN(n10), .B(IE_sel), .Y(n14) );
  EDFFX1 EIP_reg_0_ ( .D(N30), .CK(clk), .E(N68), .Q(EIP[0]) );
  EDFFX1 IP_reg_0_ ( .D(N59), .CK(clk), .E(N71), .Q(IP[0]) );
  EDFFX1 IPH_reg_0_ ( .D(N50), .CK(clk), .E(N70), .Q(IPH[0]) );
  EDFFX1 EIE_reg_0_ ( .D(N19), .CK(clk), .E(N67), .Q(EIE[0]) );
  EDFFX1 IP_reg_1_ ( .D(N60), .CK(clk), .E(N71), .Q(IP[1]) );
  EDFFX1 IPH_reg_1_ ( .D(N51), .CK(clk), .E(N70), .Q(IPH[1]) );
  EDFFX1 IE_reg_0_ ( .D(N40), .CK(clk), .E(N69), .Q(IE[0]) );
  EDFFX1 EIE_reg_1_ ( .D(N20), .CK(clk), .E(N67), .Q(EIE[1]) );
  EDFFX1 EIP_reg_1_ ( .D(N31), .CK(clk), .E(N68), .Q(EIP[1]) );
  EDFFX1 IE_reg_1_ ( .D(N41), .CK(clk), .E(N69), .Q(IE[1]) );
  OR2X2 I143 ( .A(n620), .B(sw_rst), .Y(N67) );
  OR2X2 I144 ( .A(n630), .B(sw_rst), .Y(N68) );
  OR2X2 I145 ( .A(n640), .B(sw_rst), .Y(N70) );
  OR2X2 I146 ( .A(n4), .B(sw_rst), .Y(N71) );
  INVX1 I147 ( .A(n210), .Y(n260) );
  INVX1 I148 ( .A(EIE_sel), .Y(n190) );
  EDFFX1 IE_reg_7_ ( .D(N47), .CK(clk), .E(N69), .Q(IE[7]) );
  EDFFX1 IE_reg_2_ ( .D(N42), .CK(clk), .E(N69), .Q(IE[2]) );
  EDFFX1 IP_reg_6_ ( .D(N65), .CK(clk), .E(N71), .Q(IP[6]) );
  EDFFX1 IP_reg_5_ ( .D(N64), .CK(clk), .E(N71), .Q(IP[5]) );
  EDFFX1 EIP_reg_3_ ( .D(N33), .CK(clk), .E(N68), .Q(EIP[3]) );
  EDFFX1 EIP_reg_2_ ( .D(N32), .CK(clk), .E(N68), .Q(EIP[2]) );
  EDFFX1 IP_reg_4_ ( .D(N63), .CK(clk), .E(N71), .Q(IP[4]) );
  EDFFX1 IP_reg_3_ ( .D(N62), .CK(clk), .E(N71), .Q(IP[3]) );
  EDFFX1 IP_reg_2_ ( .D(N61), .CK(clk), .E(N71), .Q(IP[2]) );
  EDFFX1 IPH_reg_3_ ( .D(N53), .CK(clk), .E(N70), .Q(IPH[3]) );
  EDFFX1 IPH_reg_2_ ( .D(N52), .CK(clk), .E(N70), .Q(IPH[2]) );
  EDFFX1 EIE_reg_4_ ( .D(N23), .CK(clk), .E(N67), .Q(EIE[4]), .QN(n57) );
  EDFFX1 IE_reg_6_ ( .D(N46), .CK(clk), .E(N69), .Q(IE[6]) );
  EDFFX1 IE_reg_5_ ( .D(N45), .CK(clk), .E(N69), .Q(IE[5]) );
  EDFFX1 IE_reg_4_ ( .D(N44), .CK(clk), .E(N69), .Q(IE[4]) );
  EDFFX1 IE_reg_3_ ( .D(N43), .CK(clk), .E(N69), .Q(IE[3]) );
  EDFFX1 EIE_reg_3_ ( .D(N22), .CK(clk), .E(N67), .Q(EIE[3]) );
  EDFFX1 EIE_reg_2_ ( .D(N21), .CK(clk), .E(N67), .Q(EIE[2]) );
  EDFFX1 EIP_reg_5_ ( .D(N35), .CK(clk), .E(N68), .Q(EIP[5]) );
  EDFFX1 EIP_reg_4_ ( .D(N34), .CK(clk), .E(N68), .Q(EIP[4]) );
  EDFFX1 IPH_reg_4_ ( .D(N54), .CK(clk), .E(N70), .Q(IPH[4]) );
  EDFFX1 EIE_reg_6_ ( .D(N25), .CK(clk), .E(N67), .Q(EIE[6]) );
  EDFFX1 EIE_reg_5_ ( .D(N24), .CK(clk), .E(N67), .Q(EIE[5]) );
  OR2X2 I149 ( .A(n6), .B(sw_rst), .Y(N69) );
  INVX2 I150 ( .A(n9), .Y(n4) );
  INVX1 I151 ( .A(sw_rst), .Y(n670) );
  INVX1 I152 ( .A(IPH_sel), .Y(n13) );
  AND2X2 I153 ( .A(n6), .B(SFR_bus[3]), .Y(N43) );
  AND2X2 I154 ( .A(n6), .B(SFR_bus[5]), .Y(N45) );
  AND2X2 I155 ( .A(n6), .B(SFR_bus[2]), .Y(N42) );
  AND2X2 I156 ( .A(n6), .B(SFR_bus[4]), .Y(N44) );
  AND2X2 I157 ( .A(n6), .B(SFR_bus[6]), .Y(N46) );
  AND2X2 I158 ( .A(SFR_bus[7]), .B(n6), .Y(N47) );
  AND2X2 I159 ( .A(SFR_bus[6]), .B(n4), .Y(N65) );
  AND2X2 I160 ( .A(SFR_bus[5]), .B(n4), .Y(N64) );
  AND2X2 I161 ( .A(SFR_bus[4]), .B(n4), .Y(N63) );
  AND2X2 I162 ( .A(SFR_bus[3]), .B(n4), .Y(N62) );
  AND2X2 I163 ( .A(SFR_bus[2]), .B(n4), .Y(N61) );
  NAND2X2 I164 ( .A(SFR_wr), .B(n670), .Y(n10) );
  INVX1 I165 ( .A(n57), .Y(EWDI) );
  INVX1 I166 ( .A(n48), .Y(INT_SFR_OUT[0]) );
  OAI2BB1X1 I167 ( .A0N(IE[0]), .A1N(n260), .B0(n500), .Y(n49) );
  INVX1 I168 ( .A(n450), .Y(INT_SFR_OUT[1]) );
  OAI2BB1X1 I169 ( .A0N(IE[1]), .A1N(n260), .B0(n470), .Y(n460) );
  INVX1 I170 ( .A(n220), .Y(INT_SFR_OUT[7]) );
  OAI2BB1X1 I171 ( .A0N(IE[7]), .A1N(n260), .B0(n27), .Y(n250) );
  INVX1 I172 ( .A(n39), .Y(INT_SFR_OUT[3]) );
  OAI2BB1X1 I173 ( .A0N(IE[3]), .A1N(n260), .B0(n410), .Y(n400) );
  INVX1 I174 ( .A(n300), .Y(INT_SFR_OUT[6]) );
  OAI2BB1X1 I175 ( .A0N(IE[6]), .A1N(n260), .B0(n320), .Y(n310) );
  INVX1 I176 ( .A(n330), .Y(INT_SFR_OUT[5]) );
  OAI2BB1X1 I177 ( .A0N(IE[5]), .A1N(n260), .B0(n350), .Y(n340) );
  INVX1 I178 ( .A(n360), .Y(INT_SFR_OUT[4]) );
  OAI2BB1X1 I179 ( .A0N(IE[4]), .A1N(n260), .B0(n38), .Y(n370) );
  INVX1 I180 ( .A(n420), .Y(INT_SFR_OUT[2]) );
  OAI2BB1X1 I181 ( .A0N(IE[2]), .A1N(n260), .B0(n440), .Y(n430) );
  EDFFX1 EIE_reg_7_ ( .D(N26), .CK(clk), .E(N67), .Q(EIE[7]) );
  EDFFX1 IP_reg_7_ ( .D(1'b1), .CK(clk), .E(N71), .Q(IP[7]) );
  EDFFX1 IPH_reg_7_ ( .D(1'b1), .CK(clk), .E(N70), .Q(IPH[7]) );
  EDFFX1 EIP_reg_6_ ( .D(N36), .CK(clk), .E(N68), .Q(EIP[6]) );
  EDFFX1 EIP_reg_7_ ( .D(N37), .CK(clk), .E(N68), .Q(EIP[7]) );
  AND2X1 I182 ( .A(n620), .B(SFR_bus[1]), .Y(N20) );
  AND2X1 I183 ( .A(n630), .B(SFR_bus[1]), .Y(N31) );
  AND2X1 I184 ( .A(n6), .B(SFR_bus[1]), .Y(N41) );
  AND2X1 I185 ( .A(SFR_bus[1]), .B(n4), .Y(N60) );
  AND2X1 I186 ( .A(n640), .B(SFR_bus[1]), .Y(N51) );
  AND2X1 I187 ( .A(n640), .B(SFR_bus[0]), .Y(N50) );
  AND2X1 I188 ( .A(n6), .B(SFR_bus[0]), .Y(N40) );
  AND2X1 I189 ( .A(n630), .B(SFR_bus[0]), .Y(N30) );
  AND2X1 I190 ( .A(n620), .B(SFR_bus[0]), .Y(N19) );
  AND2X1 I191 ( .A(SFR_bus[0]), .B(n4), .Y(N59) );
endmodule


module ir_poll ( STOPwake_WDT, LVD_intr, EIE, EIP, exif_IE2, exif_IE3, 
        exif_IE4, exif_IE5, wdt_intr, pwm1_intr, pwm2_intr, IE, IPH, IP, 
        adc_intr, t2_intr, ua_intr, TF1, tcon_IE1, TF0, tcon_IE0, new_src, 
        new_pri, ir_EX1, ir_EX0 );
  input [7:0] EIE;
  input [7:0] EIP;
  input [7:0] IE;
  input [7:0] IPH;
  input [7:0] IP;
  output [4:0] new_src;
  output [2:0] new_pri;
  input LVD_intr, exif_IE2, exif_IE3, exif_IE4, exif_IE5, wdt_intr, pwm1_intr,
         pwm2_intr, adc_intr, t2_intr, ua_intr, TF1, tcon_IE1, TF0, tcon_IE0;
  output STOPwake_WDT, ir_EX1, ir_EX0;
  wire   n2, n4, n5, n6, n7, n8, n9, n10, n12, n13, n15, n16, n17, n18, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n48, n49,
         n50, n51, n52, n53, n54, n55, n57, n58, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n85, n86, n87, n88, n89, n90, n91, n95, n96, n97, n100, n102,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n119, n120, n121, n122, n123, n124, n129, n130, n131, n133, n134,
         n136, n137, n138, n139, n141, n143, n144, n145, n146, n147, n149,
         n150, n151, n153, n154, n155, n156, n157, n158, n159, n160, n164,
         n165, n166, n167, n168, n169, n170, n171, n181, n182, n183, n184,
         n185, n189, n191, n192, n193, n194, n195, n196, n197, n198, n201,
         n202, n203, n207, n208, n210, n213, n214, n215, n216, n219, n220,
         n221, n222, n226, n227, n231, n235, n238, n239, n240, n241, n242,
         n243, n244, n245, n246, n247, n248, n249, n250, n251, n252, n253,
         n254, n255, n257, n259, n260, n262;

  OAI211X4 U10 ( .A0(n16), .A1(n17), .B0(n18), .C0(n253), .Y(n15) );
  OAI33X4 U16 ( .A0(n35), .A1(n36), .A2(n37), .B0(n38), .B1(n39), .B2(n40), 
        .Y(n24) );
  OAI211X4 U24 ( .A0(n53), .A1(n13), .B0(n54), .C0(n55), .Y(n26) );
  AOI222X4 U33 ( .A0(n73), .A1(n74), .B0(n75), .B1(n76), .C0(n37), .C1(n42), 
        .Y(n51) );
  OAI32X4 U97 ( .A0(n38), .A1(n254), .A2(n141), .B0(n250), .B1(n143), .Y(n88)
         );
  OAI31X4 U123 ( .A0(n154), .A1(n167), .A2(n168), .B0(n169), .Y(n139) );
  OAI211X4 U193 ( .A0(n10), .A1(n215), .B0(n41), .C0(n216), .Y(n203) );
  NAND2X1 I249 ( .A(n193), .B(n191), .Y(n182) );
  NAND2X1 I250 ( .A(n130), .B(n71), .Y(n108) );
  NAND3BX1 I251 ( .AN(n157), .B(n158), .C(n171), .Y(n160) );
  NAND3BX1 I252 ( .AN(n82), .B(n31), .C(n194), .Y(n183) );
  NAND4X1 I253 ( .A(n5), .B(n6), .C(n2), .D(n4), .Y(new_src[4]) );
  NAND3BX1 I254 ( .AN(n81), .B(n46), .C(n10), .Y(n72) );
  NAND2X1 I255 ( .A(n133), .B(n114), .Y(n81) );
  NAND3BX1 I256 ( .AN(n207), .B(n238), .C(n208), .Y(n54) );
  INVX1 I257 ( .A(n203), .Y(n238) );
  NAND3BX1 I258 ( .AN(n131), .B(n226), .C(n235), .Y(n248) );
  NAND4BX1 I259 ( .AN(n203), .B(n210), .C(n144), .D(n54), .Y(n95) );
  NAND2BX1 I260 ( .AN(n49), .B(n48), .Y(n66) );
  NAND4X1 I261 ( .A(n239), .B(n227), .C(n226), .D(n248), .Y(n149) );
  NAND2BX1 I262 ( .AN(n249), .B(n136), .Y(n82) );
  NAND4BX1 I263 ( .AN(n131), .B(IPH[6]), .C(n207), .D(n208), .Y(n210) );
  NAND2BX1 I264 ( .AN(n250), .B(n143), .Y(n37) );
  NAND3BX1 I265 ( .AN(n251), .B(n31), .C(n28), .Y(n185) );
  NAND3BX1 I266 ( .AN(n226), .B(n239), .C(n227), .Y(n57) );
  INVX1 I267 ( .A(n222), .Y(n239) );
  NAND2BX1 I268 ( .AN(n254), .B(n141), .Y(n40) );
  NAND2BX1 I269 ( .AN(n257), .B(n17), .Y(n79) );
  NAND2BX1 I270 ( .AN(n160), .B(n159), .Y(n166) );
  AND3X2 I271 ( .A(n46), .B(n43), .C(n65), .Y(n8) );
  NAND2X1 I272 ( .A(n38), .B(n35), .Y(new_pri[1]) );
  NAND3BX1 I273 ( .AN(n79), .B(n80), .C(n106), .Y(n49) );
  OAI211X1 I274 ( .A0(n240), .A1(n241), .B0(n86), .C0(n85), .Y(n242) );
  INVX1 I275 ( .A(n82), .Y(n240) );
  INVX1 I276 ( .A(n31), .Y(n241) );
  INVX1 I277 ( .A(n242), .Y(n50) );
  NAND2X1 I278 ( .A(n155), .B(n168), .Y(n157) );
  AOI31X1 I279 ( .A0(n64), .A1(n63), .A2(n243), .B0(n2), .Y(n244) );
  INVX1 I280 ( .A(n251), .Y(n243) );
  INVX1 I281 ( .A(n244), .Y(n58) );
  BUFX4 I282 ( .A(IE[7]), .Y(n262) );
  NAND2X1 I283 ( .A(tcon_IE1), .B(ir_EX1), .Y(n133) );
  NAND3X2 I284 ( .A(IE[1]), .B(TF0), .C(n262), .Y(n114) );
  NAND2X2 I285 ( .A(tcon_IE0), .B(ir_EX0), .Y(n46) );
  OR2X2 I286 ( .A(n46), .B(n221), .Y(n41) );
  OR2X2 I287 ( .A(n5), .B(n147), .Y(n38) );
  OR2X2 I288 ( .A(n62), .B(n146), .Y(new_pri[0]) );
  NAND3X1 I289 ( .A(IE[6]), .B(adc_intr), .C(n262), .Y(n131) );
  OR2X2 I290 ( .A(n37), .B(n231), .Y(n222) );
  OAI31X1 I291 ( .A0(n10), .A1(n198), .A2(n215), .B0(n42), .Y(n231) );
  NAND3X2 I292 ( .A(TF1), .B(IE[3]), .C(n262), .Y(n10) );
  NAND3X2 I293 ( .A(IE[4]), .B(ua_intr), .C(n262), .Y(n130) );
  AND3X2 I294 ( .A(n257), .B(n17), .C(n104), .Y(n100) );
  OAI211X1 I295 ( .A0(n249), .A1(n136), .B0(n137), .C0(n138), .Y(n134) );
  NOR2X1 I296 ( .A(n139), .B(n153), .Y(n245) );
  NOR2X1 I297 ( .A(n203), .B(n210), .Y(n246) );
  OAI221X4 I298 ( .A0(n38), .A1(n41), .B0(n91), .B1(n13), .C0(n259), .Y(n90)
         );
  OR2X2 I299 ( .A(n95), .B(n96), .Y(n13) );
  OR3X2 I300 ( .A(n147), .B(n95), .C(n150), .Y(n2) );
  NOR3X2 I301 ( .A(n69), .B(n66), .C(n16), .Y(n252) );
  OR3X2 I302 ( .A(n107), .B(n108), .C(n72), .Y(n16) );
  NAND3X1 I303 ( .A(IE[5]), .B(t2_intr), .C(n262), .Y(n129) );
  NAND3X1 I304 ( .A(EIE[6]), .B(pwm2_intr), .C(n262), .Y(n124) );
  INVX1 I305 ( .A(n260), .Y(new_pri[2]) );
  INVX1 I306 ( .A(n13), .Y(n73) );
  INVX1 I307 ( .A(n82), .Y(n32) );
  NAND3X1 I308 ( .A(n151), .B(n137), .C(n245), .Y(n96) );
  AND3X2 I309 ( .A(n32), .B(n194), .C(n63), .Y(n151) );
  AND3X2 I310 ( .A(n7), .B(n8), .C(n9), .Y(n4) );
  INVX1 I311 ( .A(n2), .Y(n62) );
  OAI211X1 I312 ( .A0(n50), .A1(n2), .B0(n51), .C0(n52), .Y(new_src[1]) );
  INVX1 I313 ( .A(n26), .Y(n52) );
  INVX1 I314 ( .A(n193), .Y(n189) );
  INVX1 I315 ( .A(n38), .Y(n76) );
  OR2X2 I316 ( .A(n222), .B(n227), .Y(n145) );
  INVX1 I317 ( .A(n185), .Y(n137) );
  OR2X2 I318 ( .A(n203), .B(n208), .Y(n144) );
  OR2X2 I319 ( .A(n183), .B(n193), .Y(n28) );
  OR4X1 I320 ( .A(n87), .B(n88), .C(n89), .D(n90), .Y(new_src[0]) );
  OAI211X1 I321 ( .A0(n38), .A1(n144), .B0(n145), .C0(n42), .Y(n87) );
  AND2X2 I322 ( .A(n62), .B(n134), .Y(n89) );
  INVX1 I323 ( .A(n139), .Y(n138) );
  INVX1 I324 ( .A(n95), .Y(n5) );
  INVX1 I325 ( .A(n16), .Y(n104) );
  INVX1 I326 ( .A(n194), .Y(n30) );
  OAI211X1 I327 ( .A0(n77), .A1(n7), .B0(n78), .C0(n21), .Y(n74) );
  AOI31X1 I328 ( .A0(n30), .A1(n31), .A2(n32), .B0(n33), .Y(n29) );
  INVX1 I329 ( .A(n34), .Y(n33) );
  INVX1 I330 ( .A(n108), .Y(n111) );
  INVX1 I331 ( .A(n81), .Y(n7) );
  AND2X2 I332 ( .A(n40), .B(n41), .Y(n75) );
  INVX1 I333 ( .A(n66), .Y(n112) );
  INVX1 I334 ( .A(n42), .Y(n36) );
  INVX1 I335 ( .A(n41), .Y(n39) );
  OR3X2 I336 ( .A(n181), .B(n182), .C(n183), .Y(n154) );
  INVX1 I337 ( .A(n184), .Y(n181) );
  INVX1 I338 ( .A(n96), .Y(n150) );
  OR3X2 I339 ( .A(n197), .B(n213), .C(n130), .Y(n227) );
  OR4X2 I340 ( .A(n170), .B(n171), .C(n157), .D(n154), .Y(n85) );
  AND3X2 I341 ( .A(n65), .B(n12), .C(n22), .Y(n53) );
  AND3X1 I342 ( .A(n259), .B(n57), .C(n58), .Y(n55) );
  OR3X2 I343 ( .A(n157), .B(n158), .C(n154), .Y(n86) );
  OR3X2 I344 ( .A(n165), .B(n166), .C(n154), .Y(n34) );
  AND2X2 I345 ( .A(n34), .B(n85), .Y(n169) );
  OR2X2 I346 ( .A(n130), .B(n197), .Y(n193) );
  OR2X2 I347 ( .A(n133), .B(n202), .Y(n136) );
  OR4X2 I348 ( .A(n23), .B(n24), .C(n25), .D(n26), .Y(new_src[2]) );
  AOI31X1 I349 ( .A0(n27), .A1(n28), .A2(n29), .B0(n2), .Y(n25) );
  AOI31X1 I350 ( .A0(n20), .A1(n43), .A2(n44), .B0(n13), .Y(n23) );
  OR3X2 I351 ( .A(n159), .B(n160), .C(n154), .Y(n27) );
  OAI211X1 I352 ( .A0(n154), .A1(n155), .B0(n64), .C0(n156), .Y(n153) );
  AND2X2 I353 ( .A(n27), .B(n86), .Y(n156) );
  NOR2X1 I354 ( .A(n248), .B(n222), .Y(n247) );
  NOR2X1 I355 ( .A(n114), .B(n201), .Y(n249) );
  AND3X1 I356 ( .A(n8), .B(n97), .C(n253), .Y(n91) );
  AOI32X1 I357 ( .A0(n110), .A1(n111), .A2(n112), .B0(n113), .B1(n114), .Y(n97) );
  AND3X2 I358 ( .A(n10), .B(n114), .C(n67), .Y(n110) );
  OAI221X4 I359 ( .A0(n6), .A1(n13), .B0(n245), .B1(n2), .C0(n260), .Y(
        new_src[3]) );
  INVX1 I360 ( .A(n109), .Y(n107) );
  OR3X2 I361 ( .A(n195), .B(n221), .C(n46), .Y(n42) );
  OR3X2 I362 ( .A(n189), .B(n191), .C(n183), .Y(n63) );
  OR3X2 I363 ( .A(n109), .B(n108), .C(n72), .Y(n65) );
  OR4X2 I364 ( .A(n105), .B(n106), .C(n79), .D(n16), .Y(n78) );
  OR2X2 I365 ( .A(n129), .B(n214), .Y(n207) );
  OR3X2 I366 ( .A(n202), .B(n220), .C(n133), .Y(n143) );
  OR2X2 I367 ( .A(n130), .B(n213), .Y(n208) );
  OR2X2 I368 ( .A(n10), .B(n198), .Y(n194) );
  OR2X2 I369 ( .A(n46), .B(n195), .Y(n31) );
  INVX1 I370 ( .A(n40), .Y(n216) );
  NOR3X1 I371 ( .A(n201), .B(n219), .C(n114), .Y(n250) );
  NOR3X1 I372 ( .A(n184), .B(n182), .C(n183), .Y(n251) );
  OR2X2 I373 ( .A(n133), .B(n220), .Y(n141) );
  OR4X2 I374 ( .A(n66), .B(n67), .C(n68), .D(n16), .Y(n22) );
  INVX1 I375 ( .A(n69), .Y(n68) );
  OR3X2 I376 ( .A(n196), .B(n214), .C(n129), .Y(n226) );
  OR3X2 I377 ( .A(n48), .B(n49), .C(n16), .Y(n20) );
  OR3X2 I378 ( .A(n79), .B(n80), .C(n16), .Y(n21) );
  INVX1 I379 ( .A(n130), .Y(n70) );
  INVX1 I380 ( .A(n46), .Y(n77) );
  INVX1 I381 ( .A(n158), .Y(n170) );
  INVX1 I382 ( .A(n15), .Y(n6) );
  AND3X2 I383 ( .A(n20), .B(n21), .C(n22), .Y(n18) );
  INVX1 I384 ( .A(n133), .Y(n113) );
  INVX1 I385 ( .A(n35), .Y(n146) );
  NOR3BX1 I386 ( .AN(n78), .B(n100), .C(n252), .Y(n253) );
  INVX1 I387 ( .A(n155), .Y(n167) );
  NOR2X1 I388 ( .A(n114), .B(n219), .Y(n254) );
  OR2X2 I389 ( .A(n130), .B(n72), .Y(n43) );
  OR3X2 I390 ( .A(n70), .B(n71), .C(n72), .Y(n12) );
  AND3X2 I391 ( .A(n10), .B(n260), .C(n12), .Y(n9) );
  INVX1 I392 ( .A(n10), .Y(n45) );
  INVX1 I393 ( .A(n80), .Y(n105) );
  AOI31X1 I394 ( .A0(n45), .A1(n46), .A2(n7), .B0(n252), .Y(n44) );
  INVX1 I395 ( .A(n124), .Y(n164) );
  OR3X2 I396 ( .A(n166), .B(n255), .C(n154), .Y(n64) );
  NAND3X1 I397 ( .A(n164), .B(EIP[6]), .C(n165), .Y(n255) );
  OR3X2 I398 ( .A(IPH[5]), .B(n196), .C(n129), .Y(n191) );
  OR2X2 I399 ( .A(LVD_intr), .B(n149), .Y(n147) );
  AND2X2 I400 ( .A(IE[2]), .B(n262), .Y(ir_EX1) );
  AND3X2 I401 ( .A(IP[6]), .B(IPH[6]), .C(n227), .Y(n235) );
  NAND3X1 I402 ( .A(EIE[4]), .B(wdt_intr), .C(n262), .Y(n123) );
  NAND3X1 I403 ( .A(EIE[3]), .B(exif_IE5), .C(n262), .Y(n121) );
  NAND3X1 I404 ( .A(EIE[2]), .B(exif_IE4), .C(n262), .Y(n122) );
  NAND3X1 I405 ( .A(EIE[1]), .B(exif_IE3), .C(n262), .Y(n119) );
  NAND3X1 I406 ( .A(EIE[0]), .B(exif_IE2), .C(n262), .Y(n120) );
  OR3X2 I407 ( .A(IPH[6]), .B(n192), .C(n131), .Y(n184) );
  INVX1 I408 ( .A(IP[6]), .Y(n192) );
  OR3X2 I409 ( .A(IP[5]), .B(IPH[5]), .C(n129), .Y(n71) );
  NAND2BX1 I410 ( .AN(n121), .B(EIP[3]), .Y(n171) );
  NAND2BX1 I411 ( .AN(n123), .B(EIP[4]), .Y(n159) );
  NAND2BX1 I412 ( .AN(n122), .B(EIP[2]), .Y(n158) );
  NAND2BX1 I413 ( .AN(LVD_intr), .B(n149), .Y(n35) );
  NAND2BX1 I414 ( .AN(n119), .B(EIP[1]), .Y(n168) );
  NAND2BX1 I415 ( .AN(n120), .B(EIP[0]), .Y(n155) );
  NOR2X1 I416 ( .A(EIP[1]), .B(n119), .Y(n257) );
  AND2X2 I417 ( .A(IE[0]), .B(n262), .Y(ir_EX0) );
  NOR3X1 I418 ( .A(LVD_intr), .B(n246), .C(n247), .Y(n259) );
  INVX1 I419 ( .A(IP[5]), .Y(n196) );
  INVX1 I420 ( .A(IPH[0]), .Y(n221) );
  INVX1 I421 ( .A(IP[4]), .Y(n197) );
  INVX1 I422 ( .A(IP[2]), .Y(n202) );
  INVX1 I423 ( .A(IP[1]), .Y(n201) );
  INVX1 I424 ( .A(IP[0]), .Y(n195) );
  INVX1 I425 ( .A(IP[3]), .Y(n198) );
  NAND3X1 I426 ( .A(EIE[5]), .B(pwm1_intr), .C(n262), .Y(n102) );
  OR3X2 I427 ( .A(IP[6]), .B(IPH[6]), .C(n131), .Y(n109) );
  OR2X2 I428 ( .A(EIP[0]), .B(n120), .Y(n17) );
  OR2X2 I429 ( .A(EIP[3]), .B(n121), .Y(n106) );
  OR2X2 I430 ( .A(EIP[4]), .B(n123), .Y(n48) );
  OR2X2 I431 ( .A(EIP[2]), .B(n122), .Y(n80) );
  OR2X2 I432 ( .A(EIP[5]), .B(n102), .Y(n69) );
  OR2X2 I433 ( .A(EIP[6]), .B(n124), .Y(n67) );
  NAND2BX1 I434 ( .AN(n102), .B(EIP[5]), .Y(n165) );
  INVX1 I435 ( .A(IPH[5]), .Y(n214) );
  INVX1 I436 ( .A(IPH[4]), .Y(n213) );
  INVX1 I437 ( .A(IPH[1]), .Y(n219) );
  INVX1 I438 ( .A(IPH[2]), .Y(n220) );
  INVX1 I439 ( .A(IPH[3]), .Y(n215) );
  INVX1 I440 ( .A(n123), .Y(STOPwake_WDT) );
  INVX1 I441 ( .A(LVD_intr), .Y(n260) );
endmodule


module ir_ctrl ( POR, DIR_WR, pr_st, RETI_end, RETI_NFC, INT_SFR_sel, new_src, 
        new_pri, sw_rst, clk, inter_vector, inter_LCALL, interrupt_ack, 
        clear_TF1, ir_clr_IE1, clear_TF0, ir_clr_IE0 );
  input [2:0] pr_st;
  input [4:0] new_src;
  input [2:0] new_pri;
  output [7:0] inter_vector;
  input POR, DIR_WR, RETI_end, RETI_NFC, INT_SFR_sel, sw_rst, clk;
  output inter_LCALL, interrupt_ack, clear_TF1, ir_clr_IE1, clear_TF0,
         ir_clr_IE0;
  wire   update_pri_4_, update_pri_2_, N60, N61, N62, N63, N64, N65, N66, N67,
         N68, N69, lock_valid, pri_low, current_pri_0_, current_pri_1_, n9,
         n13, n14, n15, n17, n18, n19, n20, n22, n24, n25, n26, n27, n28, n29,
         n30, n31, n34, n36, n37, n39, n40, n43, n44, n45, n46, n47, n48, n49,
         n50, n52, n54, n56, n57, n58, n59, n610, n620, n630, n640, n650, n660,
         n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96;
  wire   [3:0] ir_src;
  wire   [1:0] ir_st;

  OAI222X4 U7 ( .A0(ir_st[0]), .A1(n76), .B0(n13), .B1(n14), .C0(n76), .C1(n15), .Y(n660) );
  AOI221X4 U20 ( .A0(n29), .A1(ir_src[2]), .B0(ir_src[3]), .B1(ir_src[1]), 
        .C0(n22), .Y(n27) );
  OAI33X4 U23 ( .A0(n30), .A1(ir_src[3]), .A2(n28), .B0(n31), .B1(n82), .B2(
        n28), .Y(inter_vector[3]) );
  OAI32X4 U73 ( .A0(update_pri_4_), .A1(n77), .A2(update_pri_2_), .B0(
        update_pri_4_), .B1(n74), .Y(current_pri_0_) );
  OR2X4 U87 ( .A(ir_st[0]), .B(ir_st[1]), .Y(inter_LCALL) );
  INVX1 I91 ( .A(1'b1), .Y(inter_vector[2]) );
  INVX1 I93 ( .A(1'b1), .Y(inter_vector[7]) );
  NAND2X1 I95 ( .A(ir_st[1]), .B(ir_st[0]), .Y(n28) );
  NAND2X1 I96 ( .A(ir_src[0]), .B(ir_src[1]), .Y(n34) );
  OAI2BB2X1 I97 ( .A0N(lock_valid), .A1N(n94), .B0(n96), .B1(n95), .Y(pri_low)
         );
  NOR3X1 I98 ( .A(n72), .B(n73), .C(update_pri_4_), .Y(n9) );
  NAND2X1 I99 ( .A(n79), .B(inter_LCALL), .Y(inter_vector[1]) );
  AOI2BB1X1 I100 ( .A0N(current_pri_1_), .A1N(n88), .B0(n87), .Y(n93) );
  NOR2X1 I101 ( .A(n81), .B(ir_src[0]), .Y(n37) );
  NOR2X1 I102 ( .A(n44), .B(n18), .Y(N69) );
  AND2X1 I103 ( .A(n85), .B(RETI_end), .Y(n83) );
  NAND2X1 I104 ( .A(n76), .B(ir_st[0]), .Y(n14) );
  NOR3X1 I105 ( .A(new_pri[0]), .B(n57), .C(n18), .Y(N61) );
  OR4X2 I106 ( .A(pri_low), .B(RETI_NFC), .C(inter_LCALL), .D(n610), .Y(n24)
         );
  INVX1 I107 ( .A(sw_rst), .Y(n86) );
  OAI31X1 I108 ( .A0(n24), .A1(new_pri[0]), .A2(n49), .B0(n52), .Y(N64) );
  OAI31X1 I109 ( .A0(n24), .A1(n48), .A2(n49), .B0(n50), .Y(N66) );
  OAI31X1 I110 ( .A0(n24), .A1(n57), .A2(n48), .B0(n58), .Y(N62) );
  EDFFX1 update_pri_reg_4_ ( .D(N69), .CK(clk), .E(N68), .Q(update_pri_4_), 
        .QN(n85) );
  EDFFTRX1 ir_src_reg_1_ ( .D(new_src[1]), .CK(clk), .E(interrupt_ack), .RN(
        n86), .Q(ir_src[1]), .QN(n75) );
  DFFRX1 ir_st_reg_1_ ( .D(n640), .CK(clk), .RN(n620), .Q(ir_st[1]), .QN(n76)
         );
  EDFFTRX1 ir_src_reg_0_ ( .D(new_src[0]), .CK(clk), .E(interrupt_ack), .RN(
        n86), .Q(ir_src[0]), .QN(n78) );
  DFFRX1 ir_st_reg_0_ ( .D(n630), .CK(clk), .RN(n620), .Q(ir_st[0]), .QN(n79)
         );
  EDFFTRX1 ir_src_reg_2_ ( .D(new_src[2]), .CK(clk), .E(interrupt_ack), .RN(
        n86), .Q(ir_src[2]), .QN(n81) );
  EDFFTRX1 ir_src_reg_3_ ( .D(new_src[3]), .CK(clk), .E(interrupt_ack), .RN(
        n86), .Q(ir_src[3]), .QN(n82) );
  AOI31X1 I111 ( .A0(current_pri_1_), .A1(n83), .A2(current_pri_0_), .B0(
        sw_rst), .Y(n50) );
  AOI31X1 I112 ( .A0(current_pri_1_), .A1(n83), .A2(n89), .B0(sw_rst), .Y(n52)
         );
  AOI31X1 I113 ( .A0(n83), .A1(n54), .A2(current_pri_0_), .B0(sw_rst), .Y(n58)
         );
  AOI31X1 I114 ( .A0(n54), .A1(n83), .A2(n89), .B0(sw_rst), .Y(n59) );
  INVX1 I115 ( .A(new_pri[1]), .Y(n88) );
  INVX2 I116 ( .A(n24), .Y(interrupt_ack) );
  INVX1 I117 ( .A(n54), .Y(current_pri_1_) );
  AOI21X1 I118 ( .A0(n93), .A1(n92), .B0(n91), .Y(n95) );
  NOR2X1 I119 ( .A(lock_valid), .B(n94), .Y(n96) );
  OAI2BB1X1 I120 ( .A0N(n80), .A1N(n74), .B0(n85), .Y(n54) );
  NAND3X1 I121 ( .A(n74), .B(n80), .C(n9), .Y(lock_valid) );
  NAND2X1 I122 ( .A(current_pri_1_), .B(n88), .Y(n90) );
  INVX1 I123 ( .A(n18), .Y(n43) );
  INVX1 I124 ( .A(new_pri[0]), .Y(n48) );
  AND3X2 I125 ( .A(n47), .B(new_pri[0]), .C(n43), .Y(N67) );
  AND3X2 I126 ( .A(new_pri[0]), .B(n56), .C(n43), .Y(N63) );
  AND3X2 I127 ( .A(n47), .B(n48), .C(n43), .Y(N65) );
  INVX1 I128 ( .A(RETI_end), .Y(n45) );
  OR2X2 I129 ( .A(sw_rst), .B(n24), .Y(n18) );
  INVX1 I130 ( .A(new_src[4]), .Y(n94) );
  INVX1 I131 ( .A(n57), .Y(n56) );
  INVX1 I132 ( .A(n49), .Y(n47) );
  EDFFX1 update_pri_reg_2_ ( .D(N65), .CK(clk), .E(N64), .Q(update_pri_2_), 
        .QN(n80) );
  EDFFX1 update_pri_reg_3_ ( .D(N67), .CK(clk), .E(N66), .QN(n74) );
  EDFFX1 update_pri_reg_1_ ( .D(N63), .CK(clk), .E(N62), .Q(n73), .QN(n77) );
  OR2X2 I133 ( .A(n20), .B(sw_rst), .Y(n15) );
  INVX1 I134 ( .A(n34), .Y(n22) );
  INVX1 I135 ( .A(n28), .Y(inter_vector[0]) );
  OAI221X4 I136 ( .A0(n45), .A1(n85), .B0(n24), .B1(n44), .C0(n86), .Y(N68) );
  OAI2BB1X1 I137 ( .A0N(INT_SFR_sel), .A1N(DIR_WR), .B0(n20), .Y(n610) );
  NOR2X1 I138 ( .A(new_pri[2]), .B(n85), .Y(n91) );
  NAND3X1 I139 ( .A(n90), .B(n89), .C(new_pri[0]), .Y(n92) );
  OR3X2 I140 ( .A(new_pri[1]), .B(new_pri[0]), .C(n46), .Y(n44) );
  INVX1 I141 ( .A(new_pri[2]), .Y(n46) );
  OAI31X1 I142 ( .A0(n24), .A1(new_pri[0]), .A2(n57), .B0(n59), .Y(N60) );
  OR2X2 I143 ( .A(new_pri[2]), .B(new_pri[1]), .Y(n57) );
  NAND2BX1 I144 ( .AN(new_pri[2]), .B(new_pri[1]), .Y(n49) );
  OR2X2 I145 ( .A(n34), .B(n81), .Y(n25) );
  INVX1 I146 ( .A(n19), .Y(n20) );
  INVX1 I147 ( .A(current_pri_0_), .Y(n89) );
  INVX1 I148 ( .A(n26), .Y(n29) );
  AND2X2 U89 ( .A(n650), .B(n86), .Y(n630) );
  OAI211X1 I149 ( .A0(n79), .A1(n15), .B0(n17), .C0(n18), .Y(n650) );
  OR4X1 I150 ( .A(sw_rst), .B(ir_st[0]), .C(n76), .D(n19), .Y(n17) );
  AND3X2 I151 ( .A(inter_vector[0]), .B(ir_src[3]), .C(n25), .Y(
        inter_vector[6]) );
  AND3X2 I152 ( .A(ir_src[2]), .B(n26), .C(inter_vector[0]), .Y(
        inter_vector[5]) );
  OAI21X1 I153 ( .A0(n27), .A1(n28), .B0(ir_st[1]), .Y(inter_vector[4]) );
  NAND3BX1 I154 ( .AN(pr_st[2]), .B(pr_st[0]), .C(pr_st[1]), .Y(n19) );
  AND3X2 I155 ( .A(ir_src[0]), .B(n75), .C(n84), .Y(ir_clr_IE0) );
  AND2X1 I156 ( .A(n84), .B(n22), .Y(ir_clr_IE1) );
  AND4X2 I157 ( .A(n78), .B(n75), .C(ir_src[2]), .D(n39), .Y(clear_TF1) );
  INVX1 I158 ( .A(n40), .Y(n39) );
  AND3X2 I159 ( .A(ir_src[1]), .B(n78), .C(n84), .Y(clear_TF0) );
  OR3X2 I160 ( .A(ir_src[3]), .B(n19), .C(n28), .Y(n40) );
  OR3X2 I161 ( .A(ir_src[3]), .B(ir_src[1]), .C(ir_src[0]), .Y(n26) );
  NOR2X1 I162 ( .A(ir_src[2]), .B(n40), .Y(n84) );
  AOI211X1 I163 ( .A0(ir_src[1]), .A1(n78), .B0(n36), .C0(n37), .Y(n30) );
  INVX1 I164 ( .A(n25), .Y(n36) );
  AOI22X1 I165 ( .A0(n22), .A1(n81), .B0(ir_src[0]), .B1(n75), .Y(n31) );
  AND2X2 I166 ( .A(n85), .B(new_pri[2]), .Y(n87) );
  AND2X2 U90 ( .A(n86), .B(n660), .Y(n640) );
  INVX1 I167 ( .A(n15), .Y(n13) );
  INVX1 I168 ( .A(POR), .Y(n620) );
  EDFFX1 update_pri_reg_0_ ( .D(N61), .CK(clk), .E(N60), .Q(n72) );
endmodule


module ir_ext ( Z_update, SFR_bus, EXIF, pin_INT2, pin_INT3, pin_INT4, 
        pin_INT5, EXIF_sel, TCON_sel, SFR_wr, sw_rst, clk, pr_st, pin_INT0, 
        pin_INT1, ir_EX1, ir_EX0, STOPwake_INT0, STOPwake_INT1, ir_clr_IE0, 
        ir_clr_IE1, TCON30, sample_INT0, sample_INT1, POR );
  input [7:0] SFR_bus;
  output [7:0] EXIF;
  input [2:0] pr_st;
  output [3:0] TCON30;
  input Z_update, pin_INT2, pin_INT3, pin_INT4, pin_INT5, EXIF_sel, TCON_sel,
         SFR_wr, sw_rst, clk, pin_INT0, pin_INT1, ir_EX1, ir_EX0, ir_clr_IE0,
         ir_clr_IE1, POR;
  output STOPwake_INT0, STOPwake_INT1, sample_INT0, sample_INT1;
  wire   sample2_INT2, sample_INT2, sample2_INT3, sample_INT3, sample2_INT4,
         sample_INT4, sample2_INT5, sample_INT5, set_IE2, set_IE3, set_IE4,
         set_IE5, N31, N32, N33, N34, N35, N36, N37, N65, N70, N75, N80, N85,
         N86, N87, N88, N90, N91, N92, N93, N94, N95, N97, N99, N100, N101,
         N102, N103, N104, N105, N106, N107, N108, N109, N110, N111, N112,
         N113, n4, n5, n7, n9, n10, n11, n12, n13, n14, n15, n16, n18, n19,
         n20, n21, n22, n24, n25, n320, n330, n340, n48, n54, n55, n56, n57,
         n58, n59, n61, n62, n63, n64, n650, n66, n67, n68, n69, n72, n73, n74,
         n750, n76, n77, n78, n79, n800, n81, n82, n83, n84, n850, n860, n870,
         n880, n89, n900, n910, n920, n930, n940, n950, n96, n970, n98;

  OAI33X4 U7 ( .A0(n10), .A1(n96), .A2(n11), .B0(n12), .B1(n13), .B2(n14), .Y(
        N99) );
  OAI211X4 U11 ( .A0(ir_EX0), .A1(TCON30[0]), .B0(SFR_bus[1]), .C0(n910), .Y(
        n16) );
  OAI33X4 U12 ( .A0(n18), .A1(n96), .A2(n19), .B0(n12), .B1(n20), .B2(n14), 
        .Y(N97) );
  OR2X4 U38 ( .A(n330), .B(n96), .Y(N37) );
  NAND2X1 I104 ( .A(n72), .B(n750), .Y(n13) );
  NAND2X1 I105 ( .A(n73), .B(n74), .Y(n20) );
  EDFFTRX1 TCON30_reg_0_ ( .D(SFR_bus[0]), .CK(clk), .E(n910), .RN(n970), .Q(
        TCON30[0]), .QN(n750) );
  EDFFX1 TCON30_reg_1_ ( .D(N99), .CK(clk), .E(N100), .Q(TCON30[1]) );
  EDFFX1 TCON30_reg_3_ ( .D(N97), .CK(clk), .E(N101), .Q(TCON30[3]) );
  OAI211X1 I106 ( .A0(ir_EX1), .A1(TCON30[2]), .B0(SFR_bus[3]), .C0(n910), .Y(
        n22) );
  NAND2X2 I107 ( .A(EXIF_sel), .B(SFR_wr), .Y(n320) );
  OAI31X1 I108 ( .A0(n14), .A1(sample2_INT2), .A2(n79), .B0(n920), .Y(N106) );
  OAI31X1 I109 ( .A0(n14), .A1(sample_INT3), .A2(n800), .B0(n920), .Y(N108) );
  OAI31X1 I110 ( .A0(n14), .A1(sample_INT5), .A2(n81), .B0(n920), .Y(N112) );
  EDFFTRX2 TCON30_reg_2_ ( .D(SFR_bus[2]), .CK(clk), .E(n910), .RN(n98), .Q(
        TCON30[2]), .QN(n74) );
  EDFFX1 sample2_INT4_reg ( .D(N35), .CK(clk), .E(N37), .Q(sample2_INT4), .QN(
        n89) );
  OAI211X1 I111 ( .A0(TCON30[0]), .A1(n14), .B0(n54), .C0(n56), .Y(N100) );
  INVX1 I112 ( .A(n340), .Y(n330) );
  NOR2X2 I113 ( .A(Z_update), .B(n96), .Y(n920) );
  NOR2X2 I114 ( .A(n96), .B(n14), .Y(n930) );
  OR3X4 I115 ( .A(pr_st[1]), .B(pr_st[0]), .C(n57), .Y(n14) );
  AND3X1 I116 ( .A(sample_INT2), .B(n880), .C(n930), .Y(N107) );
  AND3X1 I117 ( .A(sample2_INT3), .B(n82), .C(n930), .Y(N109) );
  AND3X1 I118 ( .A(sample_INT4), .B(n89), .C(n930), .Y(N111) );
  AND3X1 I119 ( .A(sample2_INT5), .B(n83), .C(n930), .Y(N113) );
  NAND2X1 I120 ( .A(ir_clr_IE1), .B(TCON30[2]), .Y(n21) );
  INVX1 I121 ( .A(n12), .Y(n54) );
  OR2X2 I122 ( .A(n25), .B(n96), .Y(n24) );
  OR2X2 I123 ( .A(n910), .B(n96), .Y(n12) );
  INVX2 I124 ( .A(n320), .Y(n25) );
  NOR2X1 I125 ( .A(n96), .B(n320), .Y(n900) );
  INVX1 I126 ( .A(sw_rst), .Y(n970) );
  INVX4 I127 ( .A(n98), .Y(n96) );
  INVX1 I128 ( .A(sw_rst), .Y(n98) );
  AND2X2 I129 ( .A(TCON_sel), .B(SFR_wr), .Y(n910) );
  EDFFX1 set_IE0_reg ( .D(N103), .CK(clk), .E(N102), .QN(n77) );
  EDFFX1 set_IE1_reg ( .D(N105), .CK(clk), .E(N104), .QN(n76) );
  EDFFX1 sample_INT1_reg ( .D(N91), .CK(clk), .E(N37), .Q(sample_INT1), .QN(
        n73) );
  EDFFX1 sample_INT0_reg ( .D(N90), .CK(clk), .E(N37), .Q(sample_INT0), .QN(
        n72) );
  EDFFX1 sample_INT2_reg ( .D(N92), .CK(clk), .E(N37), .Q(sample_INT2), .QN(
        n79) );
  EDFFX1 sample_INT4_reg ( .D(N94), .CK(clk), .E(N37), .Q(sample_INT4), .QN(
        n78) );
  EDFFX1 sample2_INT5_reg ( .D(N36), .CK(clk), .E(N37), .Q(sample2_INT5), .QN(
        n81) );
  EDFFX1 sample2_INT3_reg ( .D(N34), .CK(clk), .E(N37), .Q(sample2_INT3), .QN(
        n800) );
  OAI2BB1X1 I130 ( .A0N(n940), .A1N(n48), .B0(n920), .Y(N102) );
  OAI2BB1X1 I131 ( .A0N(n950), .A1N(n48), .B0(n920), .Y(N104) );
  INVX1 I132 ( .A(n14), .Y(n48) );
  AND2X1 I133 ( .A(n940), .B(n930), .Y(N103) );
  AND2X1 I134 ( .A(n950), .B(n930), .Y(N105) );
  EDFFX1 sample_INT3_reg ( .D(N93), .CK(clk), .E(N37), .Q(sample_INT3), .QN(
        n82) );
  EDFFX1 sample_INT5_reg ( .D(N95), .CK(clk), .E(N37), .Q(sample_INT5), .QN(
        n83) );
  EDFFX1 set_IE2_reg ( .D(N107), .CK(clk), .E(N106), .Q(set_IE2), .QN(n870) );
  EDFFX1 set_IE3_reg ( .D(N109), .CK(clk), .E(N108), .Q(set_IE3), .QN(n860) );
  EDFFX1 set_IE4_reg ( .D(N111), .CK(clk), .E(N110), .Q(set_IE4), .QN(n850) );
  EDFFX1 set_IE5_reg ( .D(N113), .CK(clk), .E(N112), .Q(set_IE5), .QN(n84) );
  EDFFX1 sample2_INT2_reg ( .D(N33), .CK(clk), .E(N37), .Q(sample2_INT2), .QN(
        n880) );
  INVX1 I135 ( .A(n21), .Y(n19) );
  AND2X2 I136 ( .A(n22), .B(n76), .Y(n18) );
  OAI22X1 I137 ( .A0(n25), .A1(n68), .B0(n58), .B1(n320), .Y(n69) );
  INVX1 I138 ( .A(SFR_bus[3]), .Y(n58) );
  OAI2BB2X1 I139 ( .A0N(SFR_bus[7]), .A1N(n900), .B0(n96), .B1(n84), .Y(N65)
         );
  OAI2BB2X1 I140 ( .A0N(SFR_bus[6]), .A1N(n900), .B0(n96), .B1(n850), .Y(N70)
         );
  OAI2BB2X1 I141 ( .A0N(SFR_bus[5]), .A1N(n900), .B0(n96), .B1(n860), .Y(N75)
         );
  OAI2BB2X1 I142 ( .A0N(SFR_bus[4]), .A1N(n900), .B0(n96), .B1(n870), .Y(N80)
         );
  OAI2BB2X1 I143 ( .A0N(SFR_bus[2]), .A1N(n25), .B0(n25), .B1(n66), .Y(n67) );
  INVX1 I144 ( .A(n15), .Y(n11) );
  AND2X2 I145 ( .A(n16), .B(n77), .Y(n10) );
  OAI22X1 I146 ( .A0(n25), .A1(n64), .B0(n59), .B1(n320), .Y(n650) );
  NAND2X1 I147 ( .A(ir_clr_IE0), .B(TCON30[0]), .Y(n15) );
  OAI31X1 I148 ( .A0(n14), .A1(sample2_INT4), .A2(n78), .B0(n920), .Y(N110) );
  OAI211X1 I149 ( .A0(TCON30[2]), .A1(n14), .B0(n54), .C0(n55), .Y(N101) );
  AND2X2 I150 ( .A(n21), .B(n76), .Y(n55) );
  AND2X2 I151 ( .A(n15), .B(n77), .Y(n56) );
  INVX1 I152 ( .A(pr_st[2]), .Y(n57) );
  NAND3BX1 I153 ( .AN(pr_st[2]), .B(pr_st[0]), .C(pr_st[1]), .Y(n340) );
  OAI2BB1X1 I154 ( .A0N(sample_INT3), .A1N(n330), .B0(n970), .Y(N34) );
  OAI2BB1X1 I155 ( .A0N(sample_INT4), .A1N(n330), .B0(n98), .Y(N35) );
  OAI2BB1X1 I156 ( .A0N(sample_INT5), .A1N(n330), .B0(n970), .Y(N36) );
  OAI2BB1X1 I157 ( .A0N(sample_INT0), .A1N(n330), .B0(n970), .Y(N31) );
  OAI2BB1X1 I158 ( .A0N(sample_INT1), .A1N(n330), .B0(n970), .Y(N32) );
  OAI2BB1X1 I159 ( .A0N(sample_INT2), .A1N(n330), .B0(n970), .Y(N33) );
  OR2X2 I160 ( .A(set_IE5), .B(n24), .Y(N85) );
  OR2X2 I161 ( .A(set_IE4), .B(n24), .Y(N86) );
  OR2X2 I162 ( .A(set_IE3), .B(n24), .Y(N87) );
  OR2X2 I163 ( .A(set_IE2), .B(n24), .Y(N88) );
  OR2X2 I164 ( .A(pin_INT0), .B(n96), .Y(N90) );
  OR2X2 I165 ( .A(pin_INT1), .B(n96), .Y(N91) );
  OR2X2 I166 ( .A(pin_INT2), .B(n96), .Y(N92) );
  OR2X2 I167 ( .A(pin_INT3), .B(n96), .Y(N93) );
  OR2X2 I168 ( .A(pin_INT4), .B(n96), .Y(N94) );
  OR2X2 I169 ( .A(pin_INT5), .B(n96), .Y(N95) );
  NOR3X1 I170 ( .A(sample_INT0), .B(n4), .C(n750), .Y(n940) );
  NOR3X1 I171 ( .A(sample_INT1), .B(n5), .C(n74), .Y(n950) );
  AND3X2 I172 ( .A(n750), .B(n9), .C(ir_EX0), .Y(STOPwake_INT0) );
  AND3X2 I173 ( .A(n74), .B(n7), .C(ir_EX1), .Y(STOPwake_INT1) );
  INVX1 I174 ( .A(pin_INT1), .Y(n7) );
  INVX1 I175 ( .A(POR), .Y(n61) );
  INVX1 I176 ( .A(pin_INT0), .Y(n9) );
  DFFRX1 EXIF_reg_0_ ( .D(n63), .CK(clk), .RN(n61), .Q(EXIF[0]), .QN(n62) );
  DFFRX1 EXIF_reg_1_ ( .D(n650), .CK(clk), .RN(n61), .Q(EXIF[1]), .QN(n64) );
  EDFFX1 EXIF_reg_7_ ( .D(N65), .CK(clk), .E(N85), .Q(EXIF[7]) );
  EDFFX1 EXIF_reg_6_ ( .D(N70), .CK(clk), .E(N86), .Q(EXIF[6]) );
  EDFFX1 EXIF_reg_5_ ( .D(N75), .CK(clk), .E(N87), .Q(EXIF[5]) );
  EDFFX1 EXIF_reg_4_ ( .D(N80), .CK(clk), .E(N88), .Q(EXIF[4]) );
  DFFRX1 EXIF_reg_2_ ( .D(n67), .CK(clk), .RN(n61), .Q(EXIF[2]), .QN(n66) );
  DFFRX1 EXIF_reg_3_ ( .D(n69), .CK(clk), .RN(n61), .Q(EXIF[3]), .QN(n68) );
  EDFFX1 sample2_INT0_reg ( .D(N31), .CK(clk), .E(N37), .QN(n4) );
  EDFFX1 sample2_INT1_reg ( .D(N32), .CK(clk), .E(N37), .QN(n5) );
  INVX1 I177 ( .A(SFR_bus[1]), .Y(n59) );
  OAI2BB2X1 I178 ( .A0N(SFR_bus[0]), .A1N(n25), .B0(n25), .B1(n62), .Y(n63) );
endmodule


module port3 ( sw_rst, clk, P3_DOUT, SFR_bus, P3_sel, SFR_wr, pin_P3, 
        read_modify, P3_OUT );
  output [7:0] P3_DOUT;
  input [7:0] SFR_bus;
  input [7:0] pin_P3;
  output [7:0] P3_OUT;
  input sw_rst, clk, P3_sel, SFR_wr, read_modify;
  wire   N4, N5, N6, N7, N8, N9, N10, N11, N15, n40, n16, n18, n22, n23, n24,
         n25, n26, n27, n28, n29, n30, n31, n32;

  OAI2BB1X1 I40 ( .A0N(n24), .A1N(P3_DOUT[7]), .B0(n26), .Y(P3_OUT[7]) );
  OAI2BB1X1 I41 ( .A0N(P3_DOUT[6]), .A1N(n24), .B0(n27), .Y(P3_OUT[6]) );
  OAI2BB1X1 I42 ( .A0N(P3_DOUT[5]), .A1N(n24), .B0(n28), .Y(P3_OUT[5]) );
  OAI2BB1X1 I43 ( .A0N(P3_DOUT[3]), .A1N(n24), .B0(n30), .Y(P3_OUT[3]) );
  OAI2BB1X1 I44 ( .A0N(P3_DOUT[2]), .A1N(n24), .B0(n31), .Y(P3_OUT[2]) );
  AOI21X1 I45 ( .A0(P3_DOUT[0]), .A1(n24), .B0(n18), .Y(n22) );
  INVX1 I46 ( .A(n22), .Y(P3_OUT[0]) );
  AOI21X1 I47 ( .A0(P3_DOUT[1]), .A1(n24), .B0(n16), .Y(n23) );
  INVX1 I48 ( .A(n23), .Y(P3_OUT[1]) );
  OAI2BB1X1 I49 ( .A0N(P3_DOUT[4]), .A1N(n24), .B0(n29), .Y(P3_OUT[4]) );
  BUFX4 I50 ( .A(read_modify), .Y(n24) );
  INVX2 I51 ( .A(n24), .Y(n40) );
  INVX2 I52 ( .A(sw_rst), .Y(n32) );
  AND2X1 I53 ( .A(pin_P3[1]), .B(n40), .Y(n16) );
  OAI2BB1X1 I54 ( .A0N(SFR_bus[7]), .A1N(n25), .B0(n32), .Y(N11) );
  OAI2BB1X1 I55 ( .A0N(SFR_bus[6]), .A1N(n25), .B0(n32), .Y(N10) );
  OAI2BB1X1 I56 ( .A0N(SFR_bus[5]), .A1N(n25), .B0(n32), .Y(N9) );
  OAI2BB1X1 I57 ( .A0N(SFR_bus[4]), .A1N(n25), .B0(n32), .Y(N8) );
  OAI2BB1X1 I58 ( .A0N(SFR_bus[3]), .A1N(n25), .B0(n32), .Y(N7) );
  OAI2BB1X1 I59 ( .A0N(SFR_bus[2]), .A1N(n25), .B0(n32), .Y(N6) );
  OR2X2 I60 ( .A(n25), .B(sw_rst), .Y(N15) );
  AND2X2 I61 ( .A(SFR_wr), .B(P3_sel), .Y(n25) );
  AND2X2 I62 ( .A(pin_P3[0]), .B(n40), .Y(n18) );
  NAND2X1 I63 ( .A(pin_P3[7]), .B(n40), .Y(n26) );
  NAND2X1 I64 ( .A(pin_P3[6]), .B(n40), .Y(n27) );
  NAND2X1 I65 ( .A(pin_P3[5]), .B(n40), .Y(n28) );
  NAND2X1 I66 ( .A(pin_P3[4]), .B(n40), .Y(n29) );
  NAND2X1 I67 ( .A(pin_P3[3]), .B(n40), .Y(n30) );
  NAND2X1 I68 ( .A(pin_P3[2]), .B(n40), .Y(n31) );
  EDFFX1 P3_SFR_reg_0_ ( .D(N4), .CK(clk), .E(N15), .Q(P3_DOUT[0]) );
  EDFFX1 P3_SFR_reg_1_ ( .D(N5), .CK(clk), .E(N15), .Q(P3_DOUT[1]) );
  EDFFX1 P3_SFR_reg_7_ ( .D(N11), .CK(clk), .E(N15), .Q(P3_DOUT[7]) );
  EDFFX1 P3_SFR_reg_6_ ( .D(N10), .CK(clk), .E(N15), .Q(P3_DOUT[6]) );
  EDFFX1 P3_SFR_reg_5_ ( .D(N9), .CK(clk), .E(N15), .Q(P3_DOUT[5]) );
  EDFFX1 P3_SFR_reg_4_ ( .D(N8), .CK(clk), .E(N15), .Q(P3_DOUT[4]) );
  EDFFX1 P3_SFR_reg_3_ ( .D(N7), .CK(clk), .E(N15), .Q(P3_DOUT[3]) );
  EDFFX1 P3_SFR_reg_2_ ( .D(N6), .CK(clk), .E(N15), .Q(P3_DOUT[2]) );
  OAI2BB1X1 I69 ( .A0N(SFR_bus[1]), .A1N(n25), .B0(n32), .Y(N5) );
  OAI2BB1X1 I70 ( .A0N(SFR_bus[0]), .A1N(n25), .B0(n32), .Y(N4) );
endmodule


module port2 ( sw_rst, clk, P2_DOUT, SFR_bus, SFR_wr, P2_sel, pin_P2, 
        read_modify, P2_OUT );
  output [7:0] P2_DOUT;
  input [7:0] SFR_bus;
  input [7:0] pin_P2;
  output [7:0] P2_OUT;
  input sw_rst, clk, SFR_wr, P2_sel, read_modify;
  wire   N4, N5, N6, N7, N8, N9, N10, N11, N15, n2, n3, n40, n50, n60, n70,
         n80, n90, n100, n110, n12, n13, n14, n22, n23, n24, n25, n26, n27;

  INVX2 I40 ( .A(sw_rst), .Y(n27) );
  NAND2X1 I41 ( .A(n22), .B(n23), .Y(P2_OUT[0]) );
  NAND2X1 I42 ( .A(P2_DOUT[0]), .B(read_modify), .Y(n22) );
  NAND2X1 I43 ( .A(pin_P2[0]), .B(n40), .Y(n23) );
  NAND2X1 I44 ( .A(n24), .B(n25), .Y(P2_OUT[1]) );
  NAND2X1 I45 ( .A(P2_DOUT[1]), .B(read_modify), .Y(n24) );
  NAND2X1 I46 ( .A(pin_P2[1]), .B(n40), .Y(n25) );
  AND2X1 I47 ( .A(read_modify), .B(P2_DOUT[7]), .Y(n2) );
  AND2X1 I48 ( .A(pin_P2[7]), .B(n40), .Y(n3) );
  AND2X1 I49 ( .A(pin_P2[6]), .B(n40), .Y(n60) );
  AND2X1 I50 ( .A(pin_P2[5]), .B(n40), .Y(n80) );
  AND2X1 I51 ( .A(pin_P2[3]), .B(n40), .Y(n12) );
  AND2X1 I52 ( .A(pin_P2[2]), .B(n40), .Y(n14) );
  AND2X1 I53 ( .A(P2_DOUT[6]), .B(read_modify), .Y(n50) );
  AND2X1 I54 ( .A(P2_DOUT[5]), .B(read_modify), .Y(n70) );
  AND2X1 I55 ( .A(P2_DOUT[4]), .B(read_modify), .Y(n90) );
  AND2X1 I56 ( .A(P2_DOUT[3]), .B(read_modify), .Y(n110) );
  AND2X1 I57 ( .A(P2_DOUT[2]), .B(read_modify), .Y(n13) );
  AND2X1 I58 ( .A(pin_P2[4]), .B(n40), .Y(n100) );
  INVX1 I59 ( .A(read_modify), .Y(n40) );
  OAI2BB1X1 I60 ( .A0N(SFR_bus[7]), .A1N(n26), .B0(n27), .Y(N11) );
  OAI2BB1X1 I61 ( .A0N(SFR_bus[6]), .A1N(n26), .B0(n27), .Y(N10) );
  OAI2BB1X1 I62 ( .A0N(SFR_bus[5]), .A1N(n26), .B0(n27), .Y(N9) );
  OAI2BB1X1 I63 ( .A0N(SFR_bus[4]), .A1N(n26), .B0(n27), .Y(N8) );
  OAI2BB1X1 I64 ( .A0N(SFR_bus[3]), .A1N(n26), .B0(n27), .Y(N7) );
  OAI2BB1X1 I65 ( .A0N(SFR_bus[2]), .A1N(n26), .B0(n27), .Y(N6) );
  OR2X2 I66 ( .A(n26), .B(sw_rst), .Y(N15) );
  AND2X2 I67 ( .A(SFR_wr), .B(P2_sel), .Y(n26) );
  OR2X2 I68 ( .A(n50), .B(n60), .Y(P2_OUT[6]) );
  OR2X2 I69 ( .A(n90), .B(n100), .Y(P2_OUT[4]) );
  OR2X2 I70 ( .A(n2), .B(n3), .Y(P2_OUT[7]) );
  OR2X2 I71 ( .A(n70), .B(n80), .Y(P2_OUT[5]) );
  OR2X2 I72 ( .A(n110), .B(n12), .Y(P2_OUT[3]) );
  OR2X2 I73 ( .A(n13), .B(n14), .Y(P2_OUT[2]) );
  EDFFX1 P2_SFR_reg_0_ ( .D(N4), .CK(clk), .E(N15), .Q(P2_DOUT[0]) );
  EDFFX1 P2_SFR_reg_7_ ( .D(N11), .CK(clk), .E(N15), .Q(P2_DOUT[7]) );
  EDFFX1 P2_SFR_reg_1_ ( .D(N5), .CK(clk), .E(N15), .Q(P2_DOUT[1]) );
  EDFFX1 P2_SFR_reg_6_ ( .D(N10), .CK(clk), .E(N15), .Q(P2_DOUT[6]) );
  EDFFX1 P2_SFR_reg_5_ ( .D(N9), .CK(clk), .E(N15), .Q(P2_DOUT[5]) );
  EDFFX1 P2_SFR_reg_4_ ( .D(N8), .CK(clk), .E(N15), .Q(P2_DOUT[4]) );
  EDFFX1 P2_SFR_reg_3_ ( .D(N7), .CK(clk), .E(N15), .Q(P2_DOUT[3]) );
  EDFFX1 P2_SFR_reg_2_ ( .D(N6), .CK(clk), .E(N15), .Q(P2_DOUT[2]) );
  OAI2BB1X1 I74 ( .A0N(SFR_bus[1]), .A1N(n26), .B0(n27), .Y(N5) );
  OAI2BB1X1 I75 ( .A0N(SFR_bus[0]), .A1N(n26), .B0(n27), .Y(N4) );
endmodule


module port1 ( sw_rst, clk, P1_DOUT, SFR_bus, P1_sel, SFR_wr, read_modify, 
        P1_OUT, pin_P1 );
  output [7:0] P1_DOUT;
  input [7:0] SFR_bus;
  output [7:0] P1_OUT;
  input [7:0] pin_P1;
  input sw_rst, clk, P1_sel, SFR_wr, read_modify;
  wire   N4, N5, N6, N7, N8, N9, N10, N11, N15, n2, n3, n40, n50, n60, n70,
         n80, n90, n100, n110, n12, n13, n14, n22, n23, n24, n25, n26, n27;

  INVX2 I40 ( .A(read_modify), .Y(n40) );
  INVX2 I41 ( .A(sw_rst), .Y(n27) );
  NAND2X1 I42 ( .A(n22), .B(n23), .Y(P1_OUT[0]) );
  NAND2X1 I43 ( .A(P1_DOUT[0]), .B(read_modify), .Y(n22) );
  NAND2X1 I44 ( .A(pin_P1[0]), .B(n40), .Y(n23) );
  NAND2X1 I45 ( .A(n24), .B(n25), .Y(P1_OUT[1]) );
  NAND2X1 I46 ( .A(P1_DOUT[1]), .B(read_modify), .Y(n24) );
  NAND2X1 I47 ( .A(pin_P1[1]), .B(n40), .Y(n25) );
  AND2X1 I48 ( .A(read_modify), .B(P1_DOUT[7]), .Y(n2) );
  AND2X1 I49 ( .A(pin_P1[7]), .B(n40), .Y(n3) );
  AND2X1 I50 ( .A(pin_P1[6]), .B(n40), .Y(n60) );
  AND2X1 I51 ( .A(pin_P1[5]), .B(n40), .Y(n80) );
  AND2X1 I52 ( .A(pin_P1[4]), .B(n40), .Y(n100) );
  AND2X1 I53 ( .A(pin_P1[3]), .B(n40), .Y(n12) );
  AND2X1 I54 ( .A(pin_P1[2]), .B(n40), .Y(n14) );
  AND2X1 I55 ( .A(P1_DOUT[6]), .B(read_modify), .Y(n50) );
  AND2X1 I56 ( .A(P1_DOUT[5]), .B(read_modify), .Y(n70) );
  AND2X1 I57 ( .A(P1_DOUT[4]), .B(read_modify), .Y(n90) );
  AND2X1 I58 ( .A(P1_DOUT[3]), .B(read_modify), .Y(n110) );
  AND2X1 I59 ( .A(P1_DOUT[2]), .B(read_modify), .Y(n13) );
  OAI2BB1X1 I60 ( .A0N(SFR_bus[7]), .A1N(n26), .B0(n27), .Y(N11) );
  OAI2BB1X1 I61 ( .A0N(SFR_bus[6]), .A1N(n26), .B0(n27), .Y(N10) );
  OAI2BB1X1 I62 ( .A0N(SFR_bus[5]), .A1N(n26), .B0(n27), .Y(N9) );
  OAI2BB1X1 I63 ( .A0N(SFR_bus[4]), .A1N(n26), .B0(n27), .Y(N8) );
  OAI2BB1X1 I64 ( .A0N(SFR_bus[3]), .A1N(n26), .B0(n27), .Y(N7) );
  OAI2BB1X1 I65 ( .A0N(SFR_bus[2]), .A1N(n26), .B0(n27), .Y(N6) );
  OR2X2 I66 ( .A(n26), .B(sw_rst), .Y(N15) );
  AND2X2 I67 ( .A(SFR_wr), .B(P1_sel), .Y(n26) );
  OR2X2 I68 ( .A(n50), .B(n60), .Y(P1_OUT[6]) );
  OR2X2 I69 ( .A(n90), .B(n100), .Y(P1_OUT[4]) );
  OR2X2 I70 ( .A(n2), .B(n3), .Y(P1_OUT[7]) );
  OR2X2 I71 ( .A(n70), .B(n80), .Y(P1_OUT[5]) );
  OR2X2 I72 ( .A(n110), .B(n12), .Y(P1_OUT[3]) );
  OR2X2 I73 ( .A(n13), .B(n14), .Y(P1_OUT[2]) );
  EDFFX1 P1_SFR_reg_0_ ( .D(N4), .CK(clk), .E(N15), .Q(P1_DOUT[0]) );
  EDFFX1 P1_SFR_reg_7_ ( .D(N11), .CK(clk), .E(N15), .Q(P1_DOUT[7]) );
  EDFFX1 P1_SFR_reg_1_ ( .D(N5), .CK(clk), .E(N15), .Q(P1_DOUT[1]) );
  EDFFX1 P1_SFR_reg_6_ ( .D(N10), .CK(clk), .E(N15), .Q(P1_DOUT[6]) );
  EDFFX1 P1_SFR_reg_5_ ( .D(N9), .CK(clk), .E(N15), .Q(P1_DOUT[5]) );
  EDFFX1 P1_SFR_reg_4_ ( .D(N8), .CK(clk), .E(N15), .Q(P1_DOUT[4]) );
  EDFFX1 P1_SFR_reg_3_ ( .D(N7), .CK(clk), .E(N15), .Q(P1_DOUT[3]) );
  EDFFX1 P1_SFR_reg_2_ ( .D(N6), .CK(clk), .E(N15), .Q(P1_DOUT[2]) );
  OAI2BB1X1 I74 ( .A0N(SFR_bus[1]), .A1N(n26), .B0(n27), .Y(N5) );
  OAI2BB1X1 I75 ( .A0N(SFR_bus[0]), .A1N(n26), .B0(n27), .Y(N4) );
endmodule


module port0 ( sw_rst, clk, P0_DOUT, SFR_bus, P0_sel, SFR_wr, pin_P0, 
        read_modify, P0_OUT );
  output [7:0] P0_DOUT;
  input [7:0] SFR_bus;
  input [7:0] pin_P0;
  output [7:0] P0_OUT;
  input sw_rst, clk, P0_sel, SFR_wr, read_modify;
  wire   N4, N5, N6, N7, N8, N9, N10, N11, N15, n2, n3, n40, n50, n60, n70,
         n80, n90, n100, n110, n12, n13, n14, n22, n23, n24, n25, n26, n27;

  NAND2X1 I40 ( .A(pin_P0[0]), .B(n40), .Y(n23) );
  INVX3 I41 ( .A(read_modify), .Y(n40) );
  INVX2 I42 ( .A(sw_rst), .Y(n27) );
  NAND2X1 I43 ( .A(n22), .B(n23), .Y(P0_OUT[0]) );
  NAND2X1 I44 ( .A(P0_DOUT[0]), .B(read_modify), .Y(n22) );
  NAND2X1 I45 ( .A(n24), .B(n25), .Y(P0_OUT[1]) );
  NAND2X1 I46 ( .A(P0_DOUT[1]), .B(read_modify), .Y(n24) );
  NAND2X1 I47 ( .A(pin_P0[1]), .B(n40), .Y(n25) );
  AND2X1 I48 ( .A(read_modify), .B(P0_DOUT[7]), .Y(n2) );
  AND2X1 I49 ( .A(pin_P0[7]), .B(n40), .Y(n3) );
  AND2X1 I50 ( .A(pin_P0[6]), .B(n40), .Y(n60) );
  AND2X1 I51 ( .A(pin_P0[5]), .B(n40), .Y(n80) );
  AND2X1 I52 ( .A(pin_P0[4]), .B(n40), .Y(n100) );
  AND2X1 I53 ( .A(pin_P0[3]), .B(n40), .Y(n12) );
  AND2X1 I54 ( .A(pin_P0[2]), .B(n40), .Y(n14) );
  AND2X1 I55 ( .A(P0_DOUT[6]), .B(read_modify), .Y(n50) );
  AND2X1 I56 ( .A(P0_DOUT[5]), .B(read_modify), .Y(n70) );
  AND2X1 I57 ( .A(P0_DOUT[4]), .B(read_modify), .Y(n90) );
  AND2X1 I58 ( .A(P0_DOUT[3]), .B(read_modify), .Y(n110) );
  AND2X1 I59 ( .A(P0_DOUT[2]), .B(read_modify), .Y(n13) );
  OAI2BB1X1 I60 ( .A0N(SFR_bus[7]), .A1N(n26), .B0(n27), .Y(N11) );
  OAI2BB1X1 I61 ( .A0N(SFR_bus[6]), .A1N(n26), .B0(n27), .Y(N10) );
  OAI2BB1X1 I62 ( .A0N(SFR_bus[5]), .A1N(n26), .B0(n27), .Y(N9) );
  OAI2BB1X1 I63 ( .A0N(SFR_bus[4]), .A1N(n26), .B0(n27), .Y(N8) );
  OAI2BB1X1 I64 ( .A0N(SFR_bus[3]), .A1N(n26), .B0(n27), .Y(N7) );
  OAI2BB1X1 I65 ( .A0N(SFR_bus[2]), .A1N(n26), .B0(n27), .Y(N6) );
  OR2X2 I66 ( .A(n26), .B(sw_rst), .Y(N15) );
  AND2X2 I67 ( .A(SFR_wr), .B(P0_sel), .Y(n26) );
  OR2X2 I68 ( .A(n50), .B(n60), .Y(P0_OUT[6]) );
  OR2X2 I69 ( .A(n90), .B(n100), .Y(P0_OUT[4]) );
  OR2X2 I70 ( .A(n2), .B(n3), .Y(P0_OUT[7]) );
  OR2X2 I71 ( .A(n70), .B(n80), .Y(P0_OUT[5]) );
  OR2X2 I72 ( .A(n110), .B(n12), .Y(P0_OUT[3]) );
  OR2X2 I73 ( .A(n13), .B(n14), .Y(P0_OUT[2]) );
  EDFFX1 P0_SFR_reg_0_ ( .D(N4), .CK(clk), .E(N15), .Q(P0_DOUT[0]) );
  EDFFX1 P0_SFR_reg_7_ ( .D(N11), .CK(clk), .E(N15), .Q(P0_DOUT[7]) );
  EDFFX1 P0_SFR_reg_1_ ( .D(N5), .CK(clk), .E(N15), .Q(P0_DOUT[1]) );
  EDFFX1 P0_SFR_reg_6_ ( .D(N10), .CK(clk), .E(N15), .Q(P0_DOUT[6]) );
  EDFFX1 P0_SFR_reg_5_ ( .D(N9), .CK(clk), .E(N15), .Q(P0_DOUT[5]) );
  EDFFX1 P0_SFR_reg_4_ ( .D(N8), .CK(clk), .E(N15), .Q(P0_DOUT[4]) );
  EDFFX1 P0_SFR_reg_3_ ( .D(N7), .CK(clk), .E(N15), .Q(P0_DOUT[3]) );
  EDFFX1 P0_SFR_reg_2_ ( .D(N6), .CK(clk), .E(N15), .Q(P0_DOUT[2]) );
  OAI2BB1X1 I74 ( .A0N(SFR_bus[1]), .A1N(n26), .B0(n27), .Y(N5) );
  OAI2BB1X1 I75 ( .A0N(SFR_bus[0]), .A1N(n26), .B0(n27), .Y(N4) );
endmodule


module cpu ( IR_EN, ACC, user_init_pc, user_init_pc_en, xram_dout, pre_idle, 
        pre_pdwn_idle, DIR_WR, PDWN, IDLE, POR, IRAM_DIN, RETI_NFC, 
        INT_EN_1_EN, RESET, CLK, RAM_CS_B, RAM_WE_B, RAM_OE_B, RAMADDR, RAMOUT, 
        ALEOFF, XMEM_L, XMEM_H, XA, P0_IN, ALE_B_I, ALE_B_X, PSEN_B_X, 
        PERI_SFR_DATA, PERI_SFR_sel, IDATA, MAR, SFR_wr, XRAM_CE_B, XRAM_WR_B, 
        XRAM_RD_B, read_modify, inter_LCALL, inter_vector );
  output [7:0] ACC;
  input [15:0] user_init_pc;
  input [7:0] xram_dout;
  output [7:0] IRAM_DIN;
  output [7:0] RAMADDR;
  input [7:0] RAMOUT;
  output [7:0] XMEM_L;
  output [7:0] XMEM_H;
  output [15:0] XA;
  input [7:0] P0_IN;
  input [7:0] PERI_SFR_DATA;
  output [7:0] IDATA;
  output [8:0] MAR;
  input [7:0] inter_vector;
  input user_init_pc_en, pre_idle, pre_pdwn_idle, PDWN, IDLE, POR, RESET, CLK,
         ALEOFF, PERI_SFR_sel, inter_LCALL;
  output IR_EN, DIR_WR, RETI_NFC, INT_EN_1_EN, RAM_CS_B, RAM_WE_B, RAM_OE_B,
         ALE_B_I, ALE_B_X, PSEN_B_X, SFR_wr, XRAM_CE_B, XRAM_WR_B, XRAM_RD_B,
         read_modify;
  wire   RETI, LAST_CYCLE, MAR_RI_EN, RAM_RD_EN, ID_PCH_EN, ID_PCL_EN,
         ID_T2_EN, WM_EN, ID_WR_EN, CYCLE2, CYCLE3, CYCLE4, BYTE2, BYTE3,
         MOVX_RI, MOVX_DPI, MOVX_RI_A, MOVX_DPI_A, MOVX_INS, MOVC_INS,
         T2_XCHD_A_EN, T1_XCHD_MDR_EN, A_IDATA_EN, CY_AC_OV_UP,
         CY_AC_OV_SUB_UP, CY0_MUL_OV_UP, CY0_DIV_OV_UP, CY_UP, CY_DA_UP,
         CY_CJNE_EN, ALU_SUBBC_EN, JBC_BIT_EN, JBC_BIT_ADDR_EN, CS1, CS2, CS3,
         CS4, LS1, LS2, LS3, LS4, ALLZ_B_PC_RES_EN, ALLZ_PC_RES_EN, ALU_ADC_EN,
         ALU_ADD_EN, ALU_ANL_EN, ALU_BITC_EN, ALU_CPL_EN, ALU_ORL_EN,
         ALU_RLC_EN, ALU_RL_EN, ALU_RRC_EN, ALU_RR_EN, ALU_SUB_EN, ALU_SWAP_EN,
         ALU_XRL_EN, A_MRR_EN, A_T1_EN, B_T1_EN, B_T2RES_EN, CAR_OUT_EN,
         CAR_PC_RES_EN, C_0_EN, C_1_EN, C_ALLZ_AND_EN, C_ALLZ_B_AND_EN,
         C_ALLZ_B_EN, C_ALLZ_B_OR_EN, C_ALLZ_OR_EN, C_B_PC_RES_EN, C_CB_EN,
         C_PC_RES_EN, DIV_OP_EN, DPTR_INC_EN, DPTR_DEC_EN, DP_T2T1_EN,
         F5_ALLZ_EN, F5_B_PC_RES_EN, F5_PC_RES_EN, MAR_BAR_EN, MAR_MDR_EN,
         MAR_P0R_EN, MAR_RES_EN, MAR_RN_EN, MAR_SP_EN, MAR_T1_EN, MUL_OP_EN,
         OV_T1Z_EN, P0R_MDR_EN, P0R_P0_EN, PC1_A_EN, PC1_DP_EN, PC1_P0R_EN,
         PC1_PCCALL_EN, PC2_DP_EN, PC2_PC_EN, PC_AD11_EN, PC_PC1_EN,
         SJMP_PC_RES_EN, JMP_PC_RES_EN, PC_RET_EN, PC_T2T1_EN, SP_RES_EN,
         SP_T1_EN, T1_0_EN, T1_1_EN, T1_BITCP_EN, T1_B_EN, T1_CBP_EN,
         T1_DAD_EN, T1_MDR_EN, T1_P0R_EN, T1_RES_EN, T1_SBP_EN, T2_0_EN,
         T2_1_EN, T2_A_EN, T2_MDR_EN, T2_P0R_EN, T2_REM2_EN, T2_RES_EN,
         T2_SP_EN, WA_EN, XAH_P2R_EN, XAL_MDR_EN, XA_DP_EN, XA_OUT_EN,
         TRANS_EN, ACC_RD_XRAM, PC_INC_EN, ALLZ, CY, F5, P0R_PRE_IR, n1, n2,
         n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18;
  wire   [8:0] MAR_IN;
  wire   [7:0] IR;
  wire   [2:0] BIT_REG;
  wire   [15:0] DPTR;
  wire   [7:0] P0R;
  wire   [7:0] TMP1;
  wire   [7:0] TMP2;
  wire   [7:0] rom_code;
  wire   [15:0] PC;

  iram_intf iram_intf ( .IDATA({IDATA[7:1], n13}), .MAR_RI_EN(MAR_RI_EN), 
        .RAM_RD_EN(RAM_RD_EN), .ID_PCH_EN(ID_PCH_EN), .ID_PCL_EN(ID_PCL_EN), 
        .ID_T2_EN(ID_T2_EN), .WM_EN(WM_EN), .SFR_wr(SFR_wr), .MAR(MAR_IN), 
        .RAMADDR(RAMADDR), .IRAM_DIN(IRAM_DIN), .RAM_CS_B(RAM_CS_B), 
        .RAM_OE_B(RAM_OE_B), .RAM_WE_B(RAM_WE_B), .ID_WR_EN(ID_WR_EN) );
  IR_DECODER1 ir_decoder1_0 ( .DIR_WR(DIR_WR), .RETI(RETI), .IR(IR), .CYCLE2(
        CYCLE2), .CYCLE3(CYCLE3), .CYCLE4(CYCLE4), .BYTE2(BYTE2), .BYTE3(BYTE3) );
  IR_DECODER2 ir_decoder2_0 ( .POR(POR), .CLK(CLK), .read_modify(read_modify), 
        .RAM_RD_EN(RAM_RD_EN), .MOVX_RI(MOVX_RI), .MOVX_DPI(MOVX_DPI), 
        .MOVX_RI_A(MOVX_RI_A), .MOVX_DPI_A(MOVX_DPI_A), .MOVX_INS(MOVX_INS), 
        .MOVC_INS(MOVC_INS), .T2_XCHD_A_EN(T2_XCHD_A_EN), .T1_XCHD_MDR_EN(
        T1_XCHD_MDR_EN), .A_IDATA_EN(A_IDATA_EN), .CY_AC_OV_UP(CY_AC_OV_UP), 
        .CY_AC_OV_SUB_UP(CY_AC_OV_SUB_UP), .CY0_MUL_OV_UP(CY0_MUL_OV_UP), 
        .CY0_DIV_OV_UP(CY0_DIV_OV_UP), .CY_UP(CY_UP), .CY_DA_UP(CY_DA_UP), 
        .CY_CJNE_EN(CY_CJNE_EN), .ALU_SUBBC_EN(ALU_SUBBC_EN), .JBC_BIT_EN(
        JBC_BIT_EN), .JBC_BIT_ADDR_EN(JBC_BIT_ADDR_EN), .IR({IR[7:6], n6, n9, 
        n15, n12, IR[1], n4}), .CS1(CS1), .CS2(CS2), .CS3(CS3), .CS4(CS4), 
        .LS1(LS1), .LS2(LS2), .LS3(LS3), .LS4(LS4), .ALLZ_B_PC_RES_EN(
        ALLZ_B_PC_RES_EN), .ALLZ_PC_RES_EN(ALLZ_PC_RES_EN), .ALU_ADC_EN(
        ALU_ADC_EN), .ALU_ADD_EN(ALU_ADD_EN), .ALU_ANL_EN(ALU_ANL_EN), 
        .ALU_BITC_EN(ALU_BITC_EN), .ALU_CPL_EN(ALU_CPL_EN), .ALU_ORL_EN(
        ALU_ORL_EN), .ALU_RLC_EN(ALU_RLC_EN), .ALU_RL_EN(ALU_RL_EN), 
        .ALU_RRC_EN(ALU_RRC_EN), .ALU_RR_EN(ALU_RR_EN), .ALU_SUB_EN(ALU_SUB_EN), .ALU_SWAP_EN(ALU_SWAP_EN), .ALU_XRL_EN(ALU_XRL_EN), .A_MRR_EN(A_MRR_EN), 
        .A_T1_EN(A_T1_EN), .B_T1_EN(B_T1_EN), .B_T2RES_EN(B_T2RES_EN), 
        .CAR_OUT_EN(CAR_OUT_EN), .CAR_PC_RES_EN(CAR_PC_RES_EN), .C_0_EN(C_0_EN), .C_1_EN(C_1_EN), .C_ALLZ_AND_EN(C_ALLZ_AND_EN), .C_ALLZ_B_AND_EN(
        C_ALLZ_B_AND_EN), .C_ALLZ_B_EN(C_ALLZ_B_EN), .C_ALLZ_B_OR_EN(
        C_ALLZ_B_OR_EN), .C_ALLZ_OR_EN(C_ALLZ_OR_EN), .C_B_PC_RES_EN(
        C_B_PC_RES_EN), .C_CB_EN(C_CB_EN), .C_PC_RES_EN(C_PC_RES_EN), 
        .DIV_OP_EN(DIV_OP_EN), .DPTR_INC_EN(DPTR_INC_EN), .DPTR_DEC_EN(
        DPTR_DEC_EN), .DP_T2T1_EN(DP_T2T1_EN), .F5_ALLZ_EN(F5_ALLZ_EN), 
        .F5_B_PC_RES_EN(F5_B_PC_RES_EN), .F5_PC_RES_EN(F5_PC_RES_EN), 
        .ID_PCH_EN_g(ID_PCH_EN), .ID_PCL_EN_g(ID_PCL_EN), .ID_T2_EN_g(ID_T2_EN), .WM_EN_g(WM_EN), .INT_EN_1_EN(INT_EN_1_EN), .MAR_BAR_EN(MAR_BAR_EN), 
        .MAR_MDR_EN(MAR_MDR_EN), .MAR_P0R_EN(MAR_P0R_EN), .MAR_RES_EN(
        MAR_RES_EN), .MAR_RI_EN(MAR_RI_EN), .MAR_RN_EN(MAR_RN_EN), .MAR_SP_EN(
        MAR_SP_EN), .MAR_T1_EN(MAR_T1_EN), .MUL_OP_EN(MUL_OP_EN), .OV_T1Z_EN(
        OV_T1Z_EN), .P0R_MDR_EN(P0R_MDR_EN), .P0R_P0_EN(P0R_P0_EN), .PC1_A_EN(
        PC1_A_EN), .PC1_DP_EN(PC1_DP_EN), .PC1_P0R_EN(PC1_P0R_EN), 
        .PC1_PCCALL_EN(PC1_PCCALL_EN), .PC2_DP_EN(PC2_DP_EN), .PC2_PC_EN(
        PC2_PC_EN), .PC_AD11_EN(PC_AD11_EN), .PC_PC1_EN(PC_PC1_EN), 
        .SJMP_PC_RES_EN(SJMP_PC_RES_EN), .JMP_PC_RES_EN(JMP_PC_RES_EN), 
        .PC_RET_EN(PC_RET_EN), .PC_T2T1_EN(PC_T2T1_EN), .SP_RES_EN(SP_RES_EN), 
        .SP_T1_EN(SP_T1_EN), .T1_0_EN(T1_0_EN), .T1_1_EN(T1_1_EN), 
        .T1_BITCP_EN(T1_BITCP_EN), .T1_B_EN(T1_B_EN), .T1_CBP_EN(T1_CBP_EN), 
        .T1_DAD_EN(T1_DAD_EN), .T1_MDR_EN(T1_MDR_EN), .T1_P0R_EN(T1_P0R_EN), 
        .T1_RES_EN(T1_RES_EN), .T1_SBP_EN(T1_SBP_EN), .T2_0_EN(T2_0_EN), 
        .T2_1_EN(T2_1_EN), .T2_A_EN(T2_A_EN), .T2_MDR_EN(T2_MDR_EN), 
        .T2_P0R_EN(T2_P0R_EN), .T2_REM2_EN(T2_REM2_EN), .T2_RES_EN(T2_RES_EN), 
        .T2_SP_EN(T2_SP_EN), .WA_EN(WA_EN), .XAH_P2R_EN(XAH_P2R_EN), 
        .XAL_MDR_EN(XAL_MDR_EN), .XA_DP_EN(XA_DP_EN), .XA_OUT_EN(XA_OUT_EN) );
  FETCH_FSM fetch_fsm_0 ( .TRANS_EN(TRANS_EN), .PDWN(PDWN), .IDLE(IDLE), .POR(
        POR), .LAST_CYCLE(LAST_CYCLE), .ALEOFF(ALEOFF), .inter_LCALL(
        inter_LCALL), .pre_idle(pre_idle), .pre_pdwn_idle(pre_pdwn_idle), 
        .MOVX_RI(MOVX_RI), .MOVX_DPI(MOVX_DPI), .MOVX_RI_A(MOVX_RI_A), 
        .MOVX_DPI_A(MOVX_DPI_A), .ACC_RD_XRAM(ACC_RD_XRAM), .CLK(CLK), .RESET(
        n1), .CS1(CS1), .CS2(CS2), .CS3(CS3), .CS4(CS4), .LS1(LS1), .LS2(LS2), 
        .LS3(LS3), .LS4(LS4), .CYCLE2(CYCLE2), .CYCLE3(CYCLE3), .CYCLE4(CYCLE4), .BYTE2(BYTE2), .BYTE3(BYTE3), .PC_INC_EN(PC_INC_EN), .IR_EN(IR_EN), 
        .PSEN_B_X(PSEN_B_X), .ALE_B_X(ALE_B_X), .ALE_B_I(ALE_B_I), .XRAM_CE_B(
        XRAM_CE_B), .XRAM_WR_B(XRAM_WR_B), .XRAM_RD_B(XRAM_RD_B) );
  MEM_INTF mem_intf_0 ( .user_init_pc(user_init_pc), .user_init_pc_en(
        user_init_pc_en), .TRANS_EN(TRANS_EN), .inter_LCALL(inter_LCALL), 
        .inter_vector(inter_vector), .JBC_BIT_EN(JBC_BIT_EN), .BIT_REG(BIT_REG), .DPTR(DPTR), .ALLZ(ALLZ), .ALLZ_B_PC_RES_EN(ALLZ_B_PC_RES_EN), 
        .ALLZ_PC_RES_EN(ALLZ_PC_RES_EN), .CLK(CLK), .RESET(n1), .XA(XA), 
        .IDATA({IDATA[7:1], n13}), .ID_WR_EN(ID_WR_EN), .MAR(MAR), .P0R(P0R), 
        .CY(CY), .F5(F5), .C_B_PC_RES_EN(C_B_PC_RES_EN), .C_PC_RES_EN(
        C_PC_RES_EN), .F5_B_PC_RES_EN(F5_B_PC_RES_EN), .F5_PC_RES_EN(
        F5_PC_RES_EN), .IR75({IR[7], n7, n6}), .MDR(RAMOUT), .TMP1(TMP1), 
        .TMP2(TMP2), .ACC(ACC), .PC_AD11_EN(PC_AD11_EN), .PC_PC1_EN(PC_PC1_EN), 
        .SJMP_PC_RES_EN(SJMP_PC_RES_EN), .JMP_PC_RES_EN(JMP_PC_RES_EN), 
        .PC_RET_EN(PC_RET_EN), .PC_T2T1_EN(PC_T2T1_EN), .PC1_A_EN(PC1_A_EN), 
        .PC1_DP_EN(PC1_DP_EN), .PC1_P0R_EN(PC1_P0R_EN), .PC2_DP_EN(PC2_DP_EN), 
        .PC2_PC_EN(PC2_PC_EN), .PC1_PCCALL_EN(PC1_PCCALL_EN), .DPTR_INC_EN(
        DPTR_INC_EN), .DPTR_DEC_EN(DPTR_DEC_EN), .DP_T2T1_EN(DP_T2T1_EN), 
        .XAH_P2R_EN(XAH_P2R_EN), .XA_DP_EN(XA_DP_EN), .XAL_MDR_EN(XAL_MDR_EN), 
        .P0R_MDR_EN(P0R_MDR_EN), .P0R_P0_EN(P0R_P0_EN), .P0R_PRE_IR(P0R_PRE_IR), .P0_IN(rom_code), .CAR_PC_RES_EN(CAR_PC_RES_EN), .PC_INC_EN(PC_INC_EN), 
        .PC_ADD(1'b0), .PC(PC) );
  IR_REG ir_reg_0 ( .pre_pdwn_idle(n17), .inter_LCALL(inter_LCALL), .POR(POR), 
        .CLK(CLK), .RESET(n1), .IR_EN(IR_EN), .MOVX_INS(MOVX_INS), .MOVC_INS(
        MOVC_INS), .LS4(LS4), .CS3(n18), .CS2(CS2), .ID(rom_code), .P0R(P0R), 
        .P0R_PRE_IR(P0R_PRE_IR), .IR(IR) );
  EX_UNIT ex_unit_0 ( .MAR_IN(MAR_IN), .CLK(CLK), .WM_EN(WM_EN), .DPTR(DPTR), 
        .PERI_SFR_DATA(PERI_SFR_DATA), .PERI_SFR_sel(PERI_SFR_sel), .ALLZ(ALLZ), .A_IDATA_EN(A_IDATA_EN), .ALU_SUBBC_EN(ALU_SUBBC_EN), .T2_XCHD_A_EN(
        T2_XCHD_A_EN), .T1_XCHD_MDR_EN(T1_XCHD_MDR_EN), .BIT_REG(BIT_REG), 
        .JBC_BIT_ADDR_EN(JBC_BIT_ADDR_EN), .CY_AC_OV_UP(CY_AC_OV_UP), 
        .CY_AC_OV_SUB_UP(CY_AC_OV_SUB_UP), .CY0_MUL_OV_UP(CY0_MUL_OV_UP), 
        .CY0_DIV_OV_UP(CY0_DIV_OV_UP), .CY_UP(CY_UP), .CY_DA_UP(CY_DA_UP), 
        .CY_CJNE_EN(CY_CJNE_EN), .RESET(n1), .ACC(ACC), .TMP1(TMP1), .TMP2(
        TMP2), .P0_IN(rom_code), .IDATA(IDATA), .ID_WR_EN(ID_WR_EN), .MAR(MAR), 
        .IR20({n12, n10, n4}), .PC(PC), .CY(CY), .F5(F5), .MUL_OP_EN(MUL_OP_EN), .B_T1_EN(B_T1_EN), .OV_T1Z_EN(OV_T1Z_EN), .T1_B_EN(T1_B_EN), .T2_0_EN(
        T2_0_EN), .T2_REM2_EN(T2_REM2_EN), .DIV_OP_EN(DIV_OP_EN), .B_T2RES_EN(
        B_T2RES_EN), .C_0_EN(C_0_EN), .C_1_EN(C_1_EN), .C_ALLZ_AND_EN(
        C_ALLZ_AND_EN), .C_ALLZ_B_AND_EN(C_ALLZ_B_AND_EN), .C_ALLZ_B_EN(
        C_ALLZ_B_EN), .C_ALLZ_B_OR_EN(C_ALLZ_B_OR_EN), .C_ALLZ_OR_EN(
        C_ALLZ_OR_EN), .C_CB_EN(C_CB_EN), .F5_ALLZ_EN(F5_ALLZ_EN), .ID_PCH_EN(
        ID_PCH_EN), .ID_PCL_EN(ID_PCL_EN), .ID_T2_EN(ID_T2_EN), .MAR_BAR_EN(
        MAR_BAR_EN), .MAR_MDR_EN(MAR_MDR_EN), .MAR_P0R_EN(MAR_P0R_EN), 
        .MAR_RES_EN(MAR_RES_EN), .MAR_RI_EN(MAR_RI_EN), .MAR_RN_EN(MAR_RN_EN), 
        .MAR_SP_EN(MAR_SP_EN), .MAR_T1_EN(MAR_T1_EN), .A_MRR_EN(A_MRR_EN), 
        .A_T1_EN(A_T1_EN), .WA_EN(WA_EN), .T1_0_EN(T1_0_EN), .T1_1_EN(T1_1_EN), 
        .T1_BITCP_EN(T1_BITCP_EN), .T1_CBP_EN(T1_CBP_EN), .T1_DAD_EN(T1_DAD_EN), .T1_MDR_EN(T1_MDR_EN), .T1_P0R_EN(T1_P0R_EN), .T1_RES_EN(T1_RES_EN), 
        .T1_SBP_EN(T1_SBP_EN), .MDR(RAMOUT), .P0R(P0R), .T2_1_EN(T2_1_EN), 
        .T2_A_EN(T2_A_EN), .T2_MDR_EN(T2_MDR_EN), .T2_P0R_EN(T2_P0R_EN), 
        .T2_RES_EN(T2_RES_EN), .T2_SP_EN(T2_SP_EN), .SP_RES_EN(SP_RES_EN), 
        .SP_T1_EN(SP_T1_EN), .ALU_ADC_EN(ALU_ADC_EN), .ALU_ADD_EN(ALU_ADD_EN), 
        .ALU_ANL_EN(ALU_ANL_EN), .ALU_BITC_EN(ALU_BITC_EN), .ALU_CPL_EN(
        ALU_CPL_EN), .ALU_ORL_EN(ALU_ORL_EN), .ALU_RLC_EN(ALU_RLC_EN), 
        .ALU_RL_EN(ALU_RL_EN), .ALU_RRC_EN(ALU_RRC_EN), .ALU_RR_EN(ALU_RR_EN), 
        .ALU_SUB_EN(ALU_SUB_EN), .ALU_SWAP_EN(ALU_SWAP_EN), .ALU_XRL_EN(
        ALU_XRL_EN) );
  ETC_UNIT etc_unit_0 ( .xram_dout(xram_dout), .xrom_code(P0_IN), .CAR_OUT_EN(
        CAR_OUT_EN), .XA_OUT_EN(XA_OUT_EN), .XA(XA), .PC(PC), .ACC_RD_XRAM(
        ACC_RD_XRAM), .P2_OUT(XMEM_H), .P0_OUT(XMEM_L), .rom_code(rom_code) );
  BUFX3 I3 ( .A(IDATA[0]), .Y(n13) );
  INVX2 I4 ( .A(n3), .Y(n4) );
  INVX2 I5 ( .A(n8), .Y(n9) );
  INVX2 I6 ( .A(n11), .Y(n12) );
  BUFX1 I7 ( .A(IR[6]), .Y(n7) );
  INVX4 I8 ( .A(n2), .Y(n1) );
  INVX1 I9 ( .A(RESET), .Y(n2) );
  BUFX1 I10 ( .A(CS3), .Y(n18) );
  BUFX1 I11 ( .A(IR[1]), .Y(n10) );
  INVX1 I12 ( .A(n16), .Y(n17) );
  INVX1 I13 ( .A(n5), .Y(n6) );
  INVX1 I14 ( .A(n14), .Y(n15) );
  INVX1 I15 ( .A(IR[0]), .Y(n3) );
  INVX1 I16 ( .A(IR[5]), .Y(n5) );
  INVX1 I17 ( .A(IR[4]), .Y(n8) );
  INVX1 I18 ( .A(IR[2]), .Y(n11) );
  INVX1 I19 ( .A(IR[3]), .Y(n14) );
  INVX1 I20 ( .A(pre_pdwn_idle), .Y(n16) );
  NAND2BX1 I21 ( .AN(RETI), .B(LAST_CYCLE), .Y(RETI_NFC) );
endmodule


module ETC_UNIT ( xram_dout, xrom_code, CAR_OUT_EN, XA_OUT_EN, XA, PC, 
        ACC_RD_XRAM, P2_OUT, P0_OUT, rom_code );
  input [7:0] xram_dout;
  input [7:0] xrom_code;
  input [15:0] XA;
  input [15:0] PC;
  output [7:0] P2_OUT;
  output [7:0] P0_OUT;
  output [7:0] rom_code;
  input CAR_OUT_EN, XA_OUT_EN, ACC_RD_XRAM;
  wire   n4, n21, n22, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77,
         n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91,
         n92, n93, n94, n95, n96, n97, n98, n99, n100, n101;

  INVX4 I80 ( .A(n101), .Y(n22) );
  BUFX4 I81 ( .A(n21), .Y(n101) );
  OR2X2 I82 ( .A(CAR_OUT_EN), .B(XA_OUT_EN), .Y(n21) );
  INVX2 I83 ( .A(ACC_RD_XRAM), .Y(n4) );
  NAND2X1 I84 ( .A(n53), .B(n54), .Y(rom_code[7]) );
  NAND2X1 I85 ( .A(xrom_code[7]), .B(n4), .Y(n53) );
  NAND2X1 I86 ( .A(xram_dout[7]), .B(ACC_RD_XRAM), .Y(n54) );
  NAND2X1 I87 ( .A(n55), .B(n56), .Y(rom_code[2]) );
  NAND2X1 I88 ( .A(xrom_code[2]), .B(n4), .Y(n55) );
  NAND2X1 I89 ( .A(xram_dout[2]), .B(ACC_RD_XRAM), .Y(n56) );
  NAND2X1 I90 ( .A(n57), .B(n58), .Y(rom_code[4]) );
  NAND2X1 I91 ( .A(xrom_code[4]), .B(n4), .Y(n57) );
  NAND2X1 I92 ( .A(xram_dout[4]), .B(ACC_RD_XRAM), .Y(n58) );
  NAND2X1 I93 ( .A(n59), .B(n60), .Y(rom_code[6]) );
  NAND2X1 I94 ( .A(xrom_code[6]), .B(n4), .Y(n59) );
  NAND2X1 I95 ( .A(xram_dout[6]), .B(ACC_RD_XRAM), .Y(n60) );
  NAND2X1 I96 ( .A(n61), .B(n62), .Y(rom_code[5]) );
  NAND2X1 I97 ( .A(xrom_code[5]), .B(n4), .Y(n61) );
  NAND2X1 I98 ( .A(xram_dout[5]), .B(ACC_RD_XRAM), .Y(n62) );
  NAND2X1 I99 ( .A(n63), .B(n64), .Y(rom_code[3]) );
  NAND2X1 I100 ( .A(xrom_code[3]), .B(n4), .Y(n63) );
  NAND2X1 I101 ( .A(xram_dout[3]), .B(ACC_RD_XRAM), .Y(n64) );
  NAND2X1 I102 ( .A(n65), .B(n66), .Y(rom_code[1]) );
  NAND2X1 I103 ( .A(xrom_code[1]), .B(n4), .Y(n65) );
  NAND2X1 I104 ( .A(xram_dout[1]), .B(ACC_RD_XRAM), .Y(n66) );
  NAND2X1 I105 ( .A(n67), .B(n68), .Y(rom_code[0]) );
  NAND2X1 I106 ( .A(xrom_code[0]), .B(n4), .Y(n67) );
  NAND2X1 I107 ( .A(xram_dout[0]), .B(ACC_RD_XRAM), .Y(n68) );
  NAND2X1 I108 ( .A(n69), .B(n70), .Y(P0_OUT[0]) );
  NAND2X1 I109 ( .A(PC[0]), .B(n22), .Y(n69) );
  NAND2X1 I110 ( .A(XA[0]), .B(n101), .Y(n70) );
  NAND2X1 I111 ( .A(n71), .B(n72), .Y(P0_OUT[1]) );
  NAND2X1 I112 ( .A(PC[1]), .B(n22), .Y(n71) );
  NAND2X1 I113 ( .A(XA[1]), .B(n101), .Y(n72) );
  NAND2X1 I114 ( .A(n73), .B(n74), .Y(P0_OUT[2]) );
  NAND2X1 I115 ( .A(PC[2]), .B(n22), .Y(n73) );
  NAND2X1 I116 ( .A(XA[2]), .B(n101), .Y(n74) );
  NAND2X1 I117 ( .A(n75), .B(n76), .Y(P0_OUT[3]) );
  NAND2X1 I118 ( .A(PC[3]), .B(n22), .Y(n75) );
  NAND2X1 I119 ( .A(XA[3]), .B(n101), .Y(n76) );
  NAND2X1 I120 ( .A(n77), .B(n78), .Y(P0_OUT[4]) );
  NAND2X1 I121 ( .A(PC[4]), .B(n22), .Y(n77) );
  NAND2X1 I122 ( .A(XA[4]), .B(n101), .Y(n78) );
  NAND2X1 I123 ( .A(n79), .B(n80), .Y(P0_OUT[5]) );
  NAND2X1 I124 ( .A(PC[5]), .B(n22), .Y(n79) );
  NAND2X1 I125 ( .A(XA[5]), .B(n101), .Y(n80) );
  NAND2X1 I126 ( .A(n81), .B(n82), .Y(P0_OUT[6]) );
  NAND2X1 I127 ( .A(PC[6]), .B(n22), .Y(n81) );
  NAND2X1 I128 ( .A(XA[6]), .B(n101), .Y(n82) );
  NAND2X1 I129 ( .A(n83), .B(n84), .Y(P0_OUT[7]) );
  NAND2X1 I130 ( .A(PC[7]), .B(n22), .Y(n83) );
  NAND2X1 I131 ( .A(XA[7]), .B(n101), .Y(n84) );
  NAND2X1 I132 ( .A(n85), .B(n86), .Y(P2_OUT[0]) );
  NAND2X1 I133 ( .A(PC[8]), .B(n22), .Y(n85) );
  NAND2X1 I134 ( .A(XA[8]), .B(n101), .Y(n86) );
  NAND2X1 I135 ( .A(n87), .B(n88), .Y(P2_OUT[1]) );
  NAND2X1 I136 ( .A(PC[9]), .B(n22), .Y(n87) );
  NAND2X1 I137 ( .A(XA[9]), .B(n101), .Y(n88) );
  NAND2X1 I138 ( .A(n89), .B(n90), .Y(P2_OUT[2]) );
  NAND2X1 I139 ( .A(PC[10]), .B(n22), .Y(n89) );
  NAND2X1 I140 ( .A(XA[10]), .B(n101), .Y(n90) );
  NAND2X1 I141 ( .A(n91), .B(n92), .Y(P2_OUT[3]) );
  NAND2X1 I142 ( .A(PC[11]), .B(n22), .Y(n91) );
  NAND2X1 I143 ( .A(XA[11]), .B(n101), .Y(n92) );
  NAND2X1 I144 ( .A(n93), .B(n94), .Y(P2_OUT[4]) );
  NAND2X1 I145 ( .A(PC[12]), .B(n22), .Y(n93) );
  NAND2X1 I146 ( .A(XA[12]), .B(n101), .Y(n94) );
  NAND2X1 I147 ( .A(n95), .B(n96), .Y(P2_OUT[5]) );
  NAND2X1 I148 ( .A(PC[13]), .B(n22), .Y(n95) );
  NAND2X1 I149 ( .A(XA[13]), .B(n101), .Y(n96) );
  NAND2X1 I150 ( .A(n97), .B(n98), .Y(P2_OUT[6]) );
  NAND2X1 I151 ( .A(PC[14]), .B(n22), .Y(n97) );
  NAND2X1 I152 ( .A(XA[14]), .B(n101), .Y(n98) );
  NAND2X1 I153 ( .A(n99), .B(n100), .Y(P2_OUT[7]) );
  NAND2X1 I154 ( .A(PC[15]), .B(n22), .Y(n99) );
  NAND2X1 I155 ( .A(XA[15]), .B(n101), .Y(n100) );
endmodule


module EX_UNIT ( MAR_IN, CLK, WM_EN, DPTR, PERI_SFR_DATA, PERI_SFR_sel, ALLZ, 
        A_IDATA_EN, ALU_SUBBC_EN, T2_XCHD_A_EN, T1_XCHD_MDR_EN, BIT_REG, 
        JBC_BIT_ADDR_EN, CY_AC_OV_UP, CY_AC_OV_SUB_UP, CY0_MUL_OV_UP, 
        CY0_DIV_OV_UP, CY_UP, CY_DA_UP, CY_CJNE_EN, RESET, ACC, TMP1, TMP2, 
        P0_IN, IDATA, ID_WR_EN, MAR, IR20, PC, CY, F5, MUL_OP_EN, B_T1_EN, 
        OV_T1Z_EN, T1_B_EN, T2_0_EN, T2_REM2_EN, DIV_OP_EN, B_T2RES_EN, C_0_EN, 
        C_1_EN, C_ALLZ_AND_EN, C_ALLZ_B_AND_EN, C_ALLZ_B_EN, C_ALLZ_B_OR_EN, 
        C_ALLZ_OR_EN, C_CB_EN, F5_ALLZ_EN, ID_PCH_EN, ID_PCL_EN, ID_T2_EN, 
        MAR_BAR_EN, MAR_MDR_EN, MAR_P0R_EN, MAR_RES_EN, MAR_RI_EN, MAR_RN_EN, 
        MAR_SP_EN, MAR_T1_EN, A_MRR_EN, A_T1_EN, WA_EN, T1_0_EN, T1_1_EN, 
        T1_BITCP_EN, T1_CBP_EN, T1_DAD_EN, T1_MDR_EN, T1_P0R_EN, T1_RES_EN, 
        T1_SBP_EN, MDR, P0R, T2_1_EN, T2_A_EN, T2_MDR_EN, T2_P0R_EN, T2_RES_EN, 
        T2_SP_EN, SP_RES_EN, SP_T1_EN, ALU_ADC_EN, ALU_ADD_EN, ALU_ANL_EN, 
        ALU_BITC_EN, ALU_CPL_EN, ALU_ORL_EN, ALU_RLC_EN, ALU_RL_EN, ALU_RRC_EN, 
        ALU_RR_EN, ALU_SUB_EN, ALU_SWAP_EN, ALU_XRL_EN );
  output [8:0] MAR_IN;
  input [15:0] DPTR;
  input [7:0] PERI_SFR_DATA;
  input [2:0] BIT_REG;
  output [7:0] ACC;
  output [7:0] TMP1;
  output [7:0] TMP2;
  input [7:0] P0_IN;
  output [7:0] IDATA;
  output [8:0] MAR;
  input [2:0] IR20;
  input [15:0] PC;
  input [7:0] MDR;
  input [7:0] P0R;
  input CLK, WM_EN, PERI_SFR_sel, A_IDATA_EN, ALU_SUBBC_EN, T2_XCHD_A_EN,
         T1_XCHD_MDR_EN, JBC_BIT_ADDR_EN, CY_AC_OV_UP, CY_AC_OV_SUB_UP,
         CY0_MUL_OV_UP, CY0_DIV_OV_UP, CY_UP, CY_DA_UP, CY_CJNE_EN, RESET,
         ID_WR_EN, MUL_OP_EN, B_T1_EN, OV_T1Z_EN, T1_B_EN, T2_0_EN, T2_REM2_EN,
         DIV_OP_EN, B_T2RES_EN, C_0_EN, C_1_EN, C_ALLZ_AND_EN, C_ALLZ_B_AND_EN,
         C_ALLZ_B_EN, C_ALLZ_B_OR_EN, C_ALLZ_OR_EN, C_CB_EN, F5_ALLZ_EN,
         ID_PCH_EN, ID_PCL_EN, ID_T2_EN, MAR_BAR_EN, MAR_MDR_EN, MAR_P0R_EN,
         MAR_RES_EN, MAR_RI_EN, MAR_RN_EN, MAR_SP_EN, MAR_T1_EN, A_MRR_EN,
         A_T1_EN, WA_EN, T1_0_EN, T1_1_EN, T1_BITCP_EN, T1_CBP_EN, T1_DAD_EN,
         T1_MDR_EN, T1_P0R_EN, T1_RES_EN, T1_SBP_EN, T2_1_EN, T2_A_EN,
         T2_MDR_EN, T2_P0R_EN, T2_RES_EN, T2_SP_EN, SP_RES_EN, SP_T1_EN,
         ALU_ADC_EN, ALU_ADD_EN, ALU_ANL_EN, ALU_BITC_EN, ALU_CPL_EN,
         ALU_ORL_EN, ALU_RLC_EN, ALU_RL_EN, ALU_RRC_EN, ALU_RR_EN, ALU_SUB_EN,
         ALU_SWAP_EN, ALU_XRL_EN;
  output ALLZ, CY, F5;
  wire   n1555, n1556, n1557, n1558, n1559, n1560, n1561, ACC_IN_2_, ACC_IN_1_,
         ACC_IN_0_, n1562, n1563, n1564, n1565, n1566, n1567, n1568, n1569,
         T1_GT_T2, PSW_IN_5_, PSW_IN_4_, PSW_IN_3_, PSW_IN_1_, PSW_IN_0_,
         PSW_6_, PSW_4_, PSW_3_, PSW_1_, SP_IN_2_, SP_IN_1_, SP_IN_0_, N195,
         TMP1_IN_7_, N218, N220, N221, TMP_CY_7_, N235, N236, N237, N238, N239,
         N240, N241, N242, N243, N253, N254, N255, N256, N257, N258, N259,
         N260, N261, N262, N263, N264, N265, N266, N267, N268, N269, N270,
         N273, N274, N275, N278, N293, N294, N295, N296, N297, N298, N299,
         N300, N301, N302, N311, N315, N316, N317, N318, N319, N320, N321,
         N322, N323, N329, N330, n83, n91, n96, n97, n98, n99, n101, n102,
         n109, n110, n117, n118, n119, n120, n125, n126, n127, n128, n129,
         n138, n142, n143, n150, n160, n165, n166, n167, n169, n170, n177,
         n178, n181, n182, n183, n184, n185, n189, n191, n192, n194, n1950,
         n197, n198, n199, n200, n201, n207, n208, n211, n212, n213, n214,
         n217, n2180, n2200, n2210, n222, n223, n224, n225, n228, n229, n230,
         n231, n232, n233, n2360, n2370, n2380, n2390, n2400, n2420, n245,
         n246, n247, n248, n249, n2570, n2580, n2590, n2600, n2610, n2620,
         n2630, n2670, n2690, n2700, n271, n272, n276, n2780, n280, n282, n292,
         n2940, n3020, n303, n305, n306, n307, n309, n310, n3110, n312, n313,
         n314, n3150, n3160, n3170, n3180, n3200, n3210, n3290, n331, n332,
         n335, n336, n337, n338, n344, n345, n346, n347, n348, n349, n350,
         n351, n352, n353, n354, n355, n361, n362, n365, n369, n375, n393,
         n394, n395, n396, n397, n398, n399, n400, n401, n402, n404, n405,
         n410, n411, n412, n418, n420, n421, n422, n424, n425, n429, n430,
         n431, n432, n436, n437, n438, n439, n440, n444, n446, n450, n451,
         n452, n457, n460, n462, n463, n482, n483, n488, n489, n490, n524,
         n525, n544, n545, n562, n563, n578, n579, n595, n596, n611, n628,
         n632, n670, n675, n676, n677, n678, n679, n680, n681, n682, n683,
         n684, n685, n686, n687, n688, n689, n690, n691, n692, n693, n694,
         n695, n696, n697, n698, n699, n700, n701, n702, n703, n704, n705,
         n706, n707, n708, n709, n710, n711, n712, n713, n714, n715, n716,
         n717, n718, n719, n720, n721, n722, n723, n724, n725, n726, n727,
         n728, n729, n730, n731, n732, n733, n734, n735, n736, n737, n738,
         n739, n740, n741, n742, n743, n744, n745, n746, n747, n748, n749,
         n750, n751, n752, n753, n754, n755, n756, n757, n758, n759, n760,
         n761, n762, n763, n764, n765, n766, n767, n768, n769, n770, n771,
         n772, n773, n774, n775, n776, n777, n778, n779, n780, n781, n782,
         n783, n784, n785, n786, n787, n788, n789, n790, n791, n792, n793,
         n794, n795, n796, n797, n798, n799, n800, n801, n802, n803, n804,
         n805, n806, n807, n808, n809, n810, n811, n812, n813, n814, n815,
         n816, n817, n818, n819, n820, n821, n822, n823, n824, n825, n826,
         n827, n828, n829, n830, n831, n832, n833, n834, n835, n836, n837,
         n838, n839, n840, n841, n842, n843, n844, n845, n846, n847, n848,
         n849, n850, n851, n852, n853, n854, n855, n856, n857, n858, n859,
         n860, n861, n862, n863, n864, n865, n866, n867, n868, n869, n870,
         n871, n872, n873, n874, n875, n876, n877, n878, n879, n880, n881,
         n882, n883, n884, n885, n886, n887, n888, n889, n890, n891, n892,
         n893, n894, n895, n896, n897, n898, n899, n900, n901, n902, n903,
         n904, n905, n906, n907, n908, n909, n910, n911, n912, n913, n914,
         n915, n916, n917, n918, n919, n920, n921, n922, n923, n924, n925,
         n926, n927, n928, n929, n930, n931, n932, n933, n934, n935, n936,
         n937, n938, n939, n940, n941, n942, n943, n944, n945, n946, n947,
         n948, n949, n950, n951, n952, n953, n954, n955, n956, n957, n958,
         n959, n960, n961, n962, n963, n964, n965, n966, n967, n968, n969,
         n970, n971, n972, n973, n974, n975, n976, n977, n978, n979, n980,
         n981, n982, n983, n984, n985, n986, n987, n988, n989, n990, n991,
         n992, n993, n994, n995, n996, n997, n998, n999, n1000, n1001, n1002,
         n1003, n1004, n1005, n1006, n1007, n1008, n1009, n1010, n1011, n1012,
         n1013, n1014, n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022,
         n1023, n1024, n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032,
         n1033, n1034, n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042,
         n1043, n1044, n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052,
         n1053, n1054, n1055, n1056, n1057, n1058, n1059, n1060, n1061, n1062,
         n1063, n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072,
         n1073, n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082,
         n1083, n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092,
         n1093, n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102,
         n1103, n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112,
         n1113, n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122,
         n1123, n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132,
         n1133, n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142,
         n1143, n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152,
         n1153, n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162,
         n1163, n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172,
         n1173, n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182,
         n1183, n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1191, n1192,
         n1193, n1194, n1195, n1196, n1197, n1198, n1199, n1200, n1201, n1202,
         n1203, n1204, n1205, n1206, n1207, n1208, n1209, n1210, n1211, n1212,
         n1213, n1214, n1215, n1216, n1217, n1218, n1219, n1220, n1221, n1222,
         n1223, n1224, n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232,
         n1233, n1234, n1235, n1236, n1237, n1238, n1239, n1240, n1241, n1242,
         n1243, n1244, n1245, n1246, n1247, n1248, n1249, n1250, n1251, n1252,
         n1253, n1254, n1255, n1256, n1257, n1258, n1259, n1260, n1261, n1262,
         n1263, n1264, n1265, n1266, n1267, n1268, n1269, n1270, n1271, n1272,
         n1273, n1274, n1275, n1276, n1277, n1278, n1279, n1280, n1281, n1282,
         n1283, n1284, n1285, n1286, n1287, n1288, n1289, n1290, n1291, n1292,
         n1293, n1294, n1295, n1296, n1297, n1298, n1299, n1300, n1301, n1302,
         n1303, n1304, n1305, n1306, n1307, n1308, n1309, n1310, n1311, n1312,
         n1313, n1314, n1315, n1316, n1317, n1318, n1319, n1320, n1321, n1322,
         n1323, n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331, n1332,
         n1333, n1334, n1335, n1336, n1337, n1338, n1339, n1340, n1341, n1342,
         n1343, n1344, n1345, n1346, n1347, n1348, n1349, n1350, n1351, n1352,
         n1353, n1354, n1355, n1356, n1357, n1358, n1359, n1360, n1361, n1362,
         n1363, n1364, n1365, n1366, n1367, n1368, n1369, n1370, n1371, n1372,
         n1373, n1374, n1375, n1376, n1377, n1378, n1379, n1380, n1381, n1382,
         n1383, n1384, n1385, n1386, n1387, n1388, n1389, n1390, n1391, n1392,
         n1393, n1394, n1395, n1396, n1397, n1398, n1399, n1400, n1401, n1402,
         n1403, n1404, n1405, n1406, n1407, n1408, n1409, n1410, n1411, n1412,
         n1413, n1414, n1415, n1416, n1417, n1418, n1419, n1420, n1421, n1422,
         n1423, n1424, n1425, n1426, n1427, n1428, n1429, n1430, n1431, n1432,
         n1433, n1434, n1435, n1436, n1437, n1438, n1439, n1440, n1441, n1442,
         n1443, n1444, n1445, n1446, n1447, n1448, n1449, n1450, n1451, n1452,
         n1453, n1454, n1455, n1456, n1457, n1458, n1459, n1460, n1461, n1462,
         n1463, n1464, n1465, n1466, n1467, n1468, n1469, n1470, n1471, n1472,
         n1473, n1474, n1475, n1476, n1477, n1478, n1479, n1480, n1481, n1482,
         n1483, n1484, n1485, n1486, n1487, n1488, n1489, n1490, n1491, n1492,
         n1493, n1494, n1495, n1496, n1497, n1498, n1499, n1500, n1501, n1502,
         n1503, n1504, n1505, n1506, n1507, n1508, n1509, n1510, n1511, n1512,
         n1513, n1514, n1515, n1516, n1517, n1518, n1519, n1520, n1526, n1527,
         n1529, n1530, add_630_5_carry_3_, add_630_5_carry_2_,
         add_630_5_carry_1_, add_1_root_add_630_4_carry_3_,
         add_1_root_add_630_4_carry_2_, n1540, n1541, n1542, n1543, n1544,
         n1545, n1546, n1547, n1548, n1549, n1550, n1551, n1552, n1553, n1554;
  wire   [7:0] B_REG;
  wire   [7:0] B2_REG;
  wire   [7:0] B_REG_IN;
  wire   [7:0] SP;
  wire   [7:0] TMP1_SUB;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3;

  DFFHQX4 MAR_reg_0_ ( .D(MAR_IN[0]), .CK(CLK), .Q(MAR[0]) );
  DFFHQX4 MAR_reg_5_ ( .D(MAR_IN[5]), .CK(CLK), .Q(MAR[5]) );
  DFFHQX4 ACC_reg_0_ ( .D(ACC_IN_0_), .CK(CLK), .Q(ACC[0]) );
  AOI221X4 U63 ( .A0(P0R[0]), .A1(T2_P0R_EN), .B0(SP[0]), .B1(T2_SP_EN), .C0(
        n166), .Y(n165) );
  OAI222X4 U105 ( .A0(n126), .A1(n189), .B0(n222), .B1(n191), .C0(n127), .C1(
        n192), .Y(n2210) );
  AOI222X4 U114 ( .A0(n177), .A1(n1526), .B0(T1_B_EN), .B1(B_REG[3]), .C0(
        T1_P0R_EN), .C1(P0R[3]), .Y(n232) );
  AOI221X4 U128 ( .A0(T1_B_EN), .A1(B_REG[1]), .B0(T1_P0R_EN), .B1(P0R[1]), 
        .C0(n248), .Y(n247) );
  OAI31X4 U195 ( .A0(n309), .A1(n310), .A2(n3110), .B0(n312), .Y(n307) );
  AOI32X4 U198 ( .A0(n3150), .A1(n3160), .A2(n3170), .B0(CY_DA_UP), .B1(n314), 
        .Y(n309) );
  OAI222X4 U226 ( .A0(n822), .A1(n337), .B0(n822), .B1(n338), .C0(n102), .C1(
        n845), .Y(n336) );
  OAI32X4 U277 ( .A0(n393), .A1(n835), .A2(n394), .B0(n395), .B1(n396), .Y(
        PSW_IN_0_) );
  AOI222X4 U298 ( .A0(MAR_T1_EN), .A1(TMP1[5]), .B0(MAR_MDR_EN), .B1(MDR[5]), 
        .C0(MAR_SP_EN), .C1(SP[5]), .Y(n422) );
  OAI222X4 U305 ( .A0(n125), .A1(n411), .B0(n431), .B1(n410), .C0(n2180), .C1(
        n412), .Y(n430) );
  AOI222X4 U311 ( .A0(MAR_T1_EN), .A1(n1526), .B0(MAR_SP_EN), .B1(SP[3]), .C0(
        MAR_MDR_EN), .C1(MDR[3]), .Y(n438) );
  AOI221X4 U411 ( .A0(n489), .A1(IDATA[6]), .B0(n490), .B1(ACC[6]), .C0(n525), 
        .Y(n524) );
  AOI221X4 U433 ( .A0(n489), .A1(IDATA[5]), .B0(n490), .B1(ACC[5]), .C0(n545), 
        .Y(n544) );
  AOI221X4 U456 ( .A0(n489), .A1(IDATA[4]), .B0(n490), .B1(ACC[4]), .C0(n563), 
        .Y(n562) );
  AOI221X4 U478 ( .A0(n489), .A1(IDATA[3]), .B0(n490), .B1(ACC[3]), .C0(n579), 
        .Y(n578) );
  AOI221X4 U500 ( .A0(n489), .A1(IDATA[2]), .B0(n490), .B1(ACC[2]), .C0(n596), 
        .Y(n595) );
  BUFX3 I630 ( .A(n1568), .Y(TMP2[1]) );
  INVX4 I631 ( .A(n1509), .Y(n1035) );
  AOI211X1 I632 ( .A0(n675), .A1(PERI_SFR_DATA[1]), .B0(n1297), .C0(n1298), 
        .Y(n676) );
  INVX1 I633 ( .A(n768), .Y(n675) );
  INVX1 I634 ( .A(n676), .Y(n1161) );
  AOI22X1 I635 ( .A0(n2370), .A1(TMP2[2]), .B0(n246), .B1(TMP2[1]), .Y(n1551)
         );
  NAND2BX1 I636 ( .AN(n856), .B(n1495), .Y(n1038) );
  AOI221X4 I637 ( .A0(n715), .A1(DPTR[14]), .B0(n677), .B1(DPTR[6]), .C0(n779), 
        .Y(n1206) );
  INVX1 I638 ( .A(n727), .Y(n677) );
  NAND3X1 I639 ( .A(ID_WR_EN), .B(n678), .C(MAR[4]), .Y(n754) );
  INVX1 I640 ( .A(n482), .Y(n678) );
  OR3X1 I641 ( .A(n224), .B(n183), .C(n184), .Y(n230) );
  NAND3X2 I642 ( .A(n1337), .B(n1500), .C(n826), .Y(n727) );
  AOI2BB1X1 I643 ( .A0N(n767), .A1N(n1403), .B0(n1402), .Y(n1387) );
  AOI32X4 I644 ( .A0(n906), .A1(N237), .A2(n1519), .B0(n679), .B1(N264), .Y(
        n1360) );
  INVX1 I645 ( .A(n1090), .Y(n679) );
  OAI2BB1X1 I646 ( .A0N(n805), .A1N(B_REG[7]), .B0(n1182), .Y(n1181) );
  AOI22X1 I647 ( .A0(n680), .A1(n772), .B0(n681), .B1(PERI_SFR_DATA[3]), .Y(
        n1250) );
  INVX1 I648 ( .A(n1185), .Y(n680) );
  INVX1 I649 ( .A(n768), .Y(n681) );
  NOR2X1 I650 ( .A(n729), .B(n1561), .Y(n1549) );
  OR2X2 I651 ( .A(ALU_BITC_EN), .B(ALU_ANL_EN), .Y(n1357) );
  MX2X1 I652 ( .S0(n1517), .B(n1385), .A(n1386), .Y(n1173) );
  AOI21X1 I653 ( .A0(n118), .A1(n109), .B0(n99), .Y(n682) );
  INVX1 I654 ( .A(n682), .Y(n831) );
  OAI2BB1X1 I655 ( .A0N(ALU_SUBBC_EN), .A1N(N319), .B0(n1473), .Y(n1472) );
  AOI22X1 I656 ( .A0(n805), .A1(B_REG[3]), .B0(n1559), .B1(B_T1_EN), .Y(n683)
         );
  INVX1 I657 ( .A(n683), .Y(n1248) );
  AOI21X1 I658 ( .A0(n684), .A1(PERI_SFR_DATA[2]), .B0(n1271), .Y(n1270) );
  INVX1 I659 ( .A(n768), .Y(n684) );
  NAND3BX1 I660 ( .AN(n482), .B(MAR[4]), .C(n757), .Y(n1190) );
  OAI2BB2X1 I661 ( .A0N(n729), .A1N(n1561), .B0(n246), .B1(n1509), .Y(n1543)
         );
  AOI22X1 I662 ( .A0(n715), .A1(DPTR[11]), .B0(n685), .B1(DPTR[3]), .Y(n1256)
         );
  INVX1 I663 ( .A(n727), .Y(n685) );
  AOI32X4 I664 ( .A0(n906), .A1(N241), .A2(n1519), .B0(n686), .B1(N268), .Y(
        n1374) );
  INVX1 I665 ( .A(n1090), .Y(n686) );
  AND4X2 I666 ( .A(n712), .B(n1358), .C(n1359), .D(n1360), .Y(n687) );
  INVX1 I667 ( .A(n687), .Y(n1492) );
  OAI2BB1X1 I668 ( .A0N(n805), .A1N(B_REG[2]), .B0(n1268), .Y(n1267) );
  NAND2X1 I669 ( .A(MAR_RES_EN), .B(n1495), .Y(n916) );
  OAI2BB2X1 I670 ( .A0N(ACC[7]), .A1N(T2_REM2_EN), .B0(n167), .B1(n109), .Y(
        n166) );
  AOI22X1 I671 ( .A0(n688), .A1(n771), .B0(n689), .B1(PERI_SFR_DATA[4]), .Y(
        n1234) );
  INVX1 I672 ( .A(n1185), .Y(n688) );
  INVX1 I673 ( .A(n768), .Y(n689) );
  NAND4X1 I674 ( .A(n1178), .B(n1504), .C(n1172), .D(n1174), .Y(n1171) );
  OAI2BB1X1 I675 ( .A0N(n690), .A1N(n691), .B0(n1526), .Y(n1440) );
  INVX1 I676 ( .A(n1347), .Y(n690) );
  INVX1 I677 ( .A(n1455), .Y(n691) );
  INVX3 I678 ( .A(N274), .Y(n1526) );
  OAI2BB1X1 I679 ( .A0N(T2_P0R_EN), .A1N(P0R[6]), .B0(n1070), .Y(n1069) );
  AOI22X1 I680 ( .A0(n881), .A1(n807), .B0(n692), .B1(n1567), .Y(n1266) );
  INVX1 I681 ( .A(n463), .Y(n692) );
  NAND3BX1 I682 ( .AN(n1498), .B(n1326), .C(n1504), .Y(n1320) );
  AOI2BB2X2 I683 ( .A0N(n752), .A1N(n693), .B0(n1565), .B1(n1353), .Y(n1439)
         );
  INVX1 I684 ( .A(n1352), .Y(n693) );
  OAI2BB1X1 I685 ( .A0N(n805), .A1N(B_REG[0]), .B0(n1311), .Y(n1310) );
  NOR3X1 I686 ( .A(T1_RES_EN), .B(T1_SBP_EN), .C(T1_P0R_EN), .Y(n2630) );
  NAND2X1 I687 ( .A(n1564), .B(n91), .Y(n1067) );
  OAI211X1 I688 ( .A0(n425), .A1(n405), .B0(n920), .C0(n921), .Y(n424) );
  NAND2X1 I689 ( .A(n1335), .B(n791), .Y(n292) );
  OAI2BB1X1 I690 ( .A0N(ALU_ADC_EN), .A1N(N257), .B0(n1474), .Y(n1471) );
  OAI2BB1X1 I691 ( .A0N(n1498), .A1N(n1563), .B0(n1211), .Y(n1210) );
  NAND2X1 I692 ( .A(T2_RES_EN), .B(n890), .Y(n1056) );
  AOI21X1 I693 ( .A0(ACC[2]), .A1(n1517), .B0(n876), .Y(n871) );
  AOI2BB2X1 I694 ( .A0N(n463), .A1N(n718), .B0(n1484), .B1(n807), .Y(n1180) );
  NOR2BX1 I695 ( .AN(n761), .B(n750), .Y(n819) );
  NOR2BX1 I696 ( .AN(ACC[0]), .B(n482), .Y(n1329) );
  OAI2BB1X1 I697 ( .A0N(n1498), .A1N(n1564), .B0(n1227), .Y(n1226) );
  OAI22X1 I698 ( .A0(n138), .A1(n729), .B0(n98), .B1(n2700), .Y(n1023) );
  OAI22X1 I699 ( .A0(n3020), .A1(n949), .B0(n950), .B1(n2600), .Y(n948) );
  NAND2X1 I700 ( .A(n1517), .B(n907), .Y(n900) );
  OAI2BB1X1 I701 ( .A0N(n805), .A1N(B_REG[6]), .B0(n1201), .Y(n1200) );
  AOI21X1 I702 ( .A0(n2400), .A1(n181), .B0(n694), .Y(n983) );
  INVX1 I703 ( .A(n2380), .Y(n694) );
  AND3X2 I704 ( .A(n1335), .B(n791), .C(ID_WR_EN), .Y(n823) );
  NAND2X1 I705 ( .A(T2_RES_EN), .B(n1494), .Y(n1046) );
  OAI211X1 I706 ( .A0(n793), .A1(n405), .B0(n915), .C0(n916), .Y(n432) );
  OAI2BB1X1 I707 ( .A0N(IDATA[3]), .A1N(T2_MDR_EN), .B0(n1036), .Y(n129) );
  DFFTRX1 TMP2_reg_0_ ( .D(n160), .CK(CLK), .RN(n836), .Q(n1569), .QN(n729) );
  AOI22X1 I708 ( .A0(n715), .A1(DPTR[15]), .B0(n695), .B1(DPTR[7]), .Y(n1191)
         );
  INVX1 I709 ( .A(n727), .Y(n695) );
  OAI2BB1X1 I710 ( .A0N(ALU_SUBBC_EN), .A1N(N317), .B0(n1370), .Y(n1369) );
  OAI21X1 I711 ( .A0(n855), .A1(n912), .B0(n1122), .Y(n1121) );
  INVX1 I712 ( .A(n1485), .Y(n855) );
  AND4X2 I713 ( .A(n714), .B(n1372), .C(n1373), .D(n1374), .Y(n696) );
  INVX1 I714 ( .A(n696), .Y(n1493) );
  AOI2BB1X1 I715 ( .A0N(n748), .A1N(n96), .B0(n1060), .Y(n1059) );
  NAND4X2 I716 ( .A(n1157), .B(n716), .C(n1345), .D(n1158), .Y(n875) );
  AOI21X1 I717 ( .A0(n907), .A1(n807), .B0(n1309), .Y(n1308) );
  OAI211X1 I718 ( .A0(n697), .A1(n797), .B0(n987), .C0(n988), .Y(n225) );
  INVX1 I719 ( .A(IDATA[3]), .Y(n697) );
  OAI22X1 I720 ( .A0(n98), .A1(n2690), .B0(n138), .B1(n1035), .Y(n1033) );
  INVX1 I721 ( .A(n91), .Y(n138) );
  OAI2BB1X1 I722 ( .A0N(n1498), .A1N(n1567), .B0(n1282), .Y(n1281) );
  OAI2BB2X1 I723 ( .A0N(ACC[1]), .A1N(n1019), .B0(n864), .B1(n857), .Y(n1025)
         );
  OAI2BB1X1 I724 ( .A0N(n805), .A1N(B_REG[4]), .B0(n1232), .Y(n1231) );
  AOI21X1 I725 ( .A0(n698), .A1(PERI_SFR_DATA[6]), .B0(n1204), .Y(n1203) );
  INVX1 I726 ( .A(n768), .Y(n698) );
  NAND2X1 I727 ( .A(n911), .B(MAR[6]), .Y(n1127) );
  OAI2BB2X1 I728 ( .A0N(n314), .A1N(n1517), .B0(n855), .B1(n2670), .Y(n1080)
         );
  OAI2BB1X1 I729 ( .A0N(n1559), .A1N(SP_T1_EN), .B0(n957), .Y(n956) );
  NOR3X1 I730 ( .A(ACC[5]), .B(ACC[6]), .C(n99), .Y(n211) );
  NOR2X1 I731 ( .A(n482), .B(MAR[4]), .Y(n756) );
  NAND2X1 I732 ( .A(MAR_RES_EN), .B(n889), .Y(n921) );
  OR2X2 I733 ( .A(n1485), .B(n361), .Y(n926) );
  AND4X2 I734 ( .A(n1157), .B(n716), .C(n1345), .D(n1158), .Y(n699) );
  INVX1 I735 ( .A(n699), .Y(n1490) );
  AOI2BB1X1 I736 ( .A0N(n96), .A1N(n125), .B0(n1050), .Y(n1049) );
  NOR3X1 I737 ( .A(n1504), .B(n864), .C(n835), .Y(n700) );
  INVX1 I738 ( .A(n700), .Y(n813) );
  AOI21X1 I739 ( .A0(n701), .A1(n1558), .B0(n991), .Y(n990) );
  AOI2BB2X1 I740 ( .A0N(n463), .A1N(n719), .B0(n1493), .B1(n807), .Y(n1199) );
  OAI2BB1X1 I741 ( .A0N(n823), .A1N(IDATA[3]), .B0(n955), .Y(n282) );
  OR4X2 I742 ( .A(n1088), .B(n1089), .C(n1081), .D(n1082), .Y(n314) );
  NOR2X1 I743 ( .A(ALU_ADC_EN), .B(ALU_SUBBC_EN), .Y(n347) );
  INVX1 I744 ( .A(n976), .Y(n701) );
  AOI2BB2X1 I745 ( .A0N(n463), .A1N(n733), .B0(n890), .B1(n807), .Y(n1213) );
  OAI2BB2X1 I746 ( .A0N(IDATA[3]), .A1N(n822), .B0(n353), .B1(n351), .Y(
        PSW_IN_3_) );
  NAND2BX1 I747 ( .AN(n1190), .B(B_REG[1]), .Y(n1170) );
  OR3X1 I748 ( .A(n200), .B(n182), .C(n183), .Y(n199) );
  OAI2BB1X1 I749 ( .A0N(ALU_ADC_EN), .A1N(N259), .B0(n1384), .Y(n1380) );
  AOI22X1 I750 ( .A0(PSW_4_), .A1(n429), .B0(n418), .B1(P0R[4]), .Y(n702) );
  INVX1 I751 ( .A(n702), .Y(n922) );
  NAND2X1 I752 ( .A(MAR_RES_EN), .B(n881), .Y(n909) );
  OR3X2 I753 ( .A(n931), .B(n822), .C(CY_AC_OV_UP), .Y(n731) );
  AOI22X1 I754 ( .A0(n703), .A1(n766), .B0(n704), .B1(PERI_SFR_DATA[7]), .Y(
        n1184) );
  INVX1 I755 ( .A(n1185), .Y(n703) );
  INVX1 I756 ( .A(n768), .Y(n704) );
  AOI2BB1X1 I757 ( .A0N(n856), .A1N(n1024), .B0(n1025), .Y(n1021) );
  AND4X2 I758 ( .A(n894), .B(n895), .C(n892), .D(n893), .Y(n891) );
  NOR2X1 I759 ( .A(n734), .B(n463), .Y(n1230) );
  OAI2BB1X1 I760 ( .A0N(ALU_SUBBC_EN), .A1N(N315), .B0(n1392), .Y(n1391) );
  OAI2BB1X1 I761 ( .A0N(n705), .A1N(N243), .B0(n1083), .Y(n1082) );
  INVX1 I762 ( .A(n724), .Y(n705) );
  OAI2BB1X1 I763 ( .A0N(n1565), .A1N(n1498), .B0(n1245), .Y(n1244) );
  OAI2BB2X1 I764 ( .A0N(n91), .A1N(n1563), .B0(n855), .B1(n856), .Y(n854) );
  OAI211X1 I765 ( .A0(n421), .A1(n117), .B0(n913), .C0(n914), .Y(n706) );
  INVX1 I766 ( .A(n706), .Y(n908) );
  AOI21X1 I767 ( .A0(T1_P0R_EN), .A1(P0R[6]), .B0(n1011), .Y(n1010) );
  NAND3X1 I768 ( .A(n946), .B(n947), .C(n937), .Y(n2940) );
  NOR2X1 I769 ( .A(n1035), .B(n463), .Y(n1289) );
  AOI21X1 I770 ( .A0(n1476), .A1(n1477), .B0(n865), .Y(n860) );
  AOI21X1 I771 ( .A0(n721), .A1(n1497), .B0(n1347), .Y(n1453) );
  AOI22X1 I772 ( .A0(n715), .A1(DPTR[12]), .B0(n707), .B1(DPTR[4]), .Y(n1239)
         );
  INVX1 I773 ( .A(n727), .Y(n707) );
  OR3X1 I774 ( .A(n200), .B(n224), .C(n183), .Y(n2360) );
  OAI2BB1X1 I775 ( .A0N(ALU_ADC_EN), .A1N(N255), .B0(n1371), .Y(n1368) );
  OAI2BB1X1 I776 ( .A0N(ACC[0]), .A1N(n1518), .B0(n877), .Y(n876) );
  AND3X2 I777 ( .A(n797), .B(n1099), .C(n906), .Y(n802) );
  OAI2BB1X1 I778 ( .A0N(n805), .A1N(B_REG[1]), .B0(n1291), .Y(n1290) );
  AOI21X1 I779 ( .A0(n708), .A1(PERI_SFR_DATA[5]), .B0(n1218), .Y(n1217) );
  INVX1 I780 ( .A(n768), .Y(n708) );
  NAND2X1 I781 ( .A(n1482), .B(n907), .Y(n1115) );
  AOI221X4 I782 ( .A0(n1568), .A1(n761), .B0(T2_SP_EN), .B1(SP[1]), .C0(n1023), 
        .Y(n1022) );
  OAI22X1 I783 ( .A0(n925), .A1(n926), .B0(n369), .B1(n927), .Y(n924) );
  AOI21X1 I784 ( .A0(n1134), .A1(n1135), .B0(n842), .Y(MAR_IN[5]) );
  OAI2BB1X1 I785 ( .A0N(n825), .A1N(n745), .B0(ACC[3]), .Y(n709) );
  INVX1 I786 ( .A(n709), .Y(N195) );
  DFFX1 ACC_reg_1_ ( .D(ACC_IN_1_), .CK(CLK), .Q(ACC[1]), .QN(n825) );
  DFFX1 ACC_reg_2_ ( .D(ACC_IN_2_), .CK(CLK), .Q(ACC[2]), .QN(n745) );
  NOR2X1 I787 ( .A(n1276), .B(n762), .Y(n783) );
  NOR2BX1 I788 ( .AN(B_REG[0]), .B(n482), .Y(n1330) );
  OAI2BB1X1 I789 ( .A0N(ACC[6]), .A1N(n1518), .B0(n904), .Y(n903) );
  OAI2BB1X1 I790 ( .A0N(n805), .A1N(B_REG[5]), .B0(n1215), .Y(n1214) );
  OAI22X1 I791 ( .A0(n1553), .A1(n1552), .B0(N274), .B1(n1566), .Y(N220) );
  NAND2X1 I792 ( .A(n1517), .B(n885), .Y(n985) );
  AOI2BB1X1 I793 ( .A0N(n1108), .A1N(n754), .B0(n1290), .Y(n1287) );
  AOI22X1 I794 ( .A0(SP[4]), .A1(n808), .B0(n1558), .B1(n1488), .Y(n710) );
  INVX1 I795 ( .A(n710), .Y(n960) );
  OAI2BB2X1 I796 ( .A0N(IDATA[5]), .A1N(n822), .B0(n350), .B1(n351), .Y(
        PSW_IN_5_) );
  NAND2X1 I797 ( .A(n128), .B(n844), .Y(n846) );
  AOI2BB1X1 I798 ( .A0N(n405), .A1N(n1337), .B0(n1143), .Y(n1142) );
  INVX2 I799 ( .A(n1347), .Y(n1356) );
  OAI21X2 I800 ( .A0(n1162), .A1(n1163), .B0(n1164), .Y(n1148) );
  NAND3X1 I801 ( .A(n1165), .B(n1166), .C(n1167), .Y(n1163) );
  NAND3X1 I802 ( .A(n1168), .B(n1169), .C(n1170), .Y(n1162) );
  INVX4 I803 ( .A(T2_MDR_EN), .Y(n1018) );
  NAND2X2 I804 ( .A(n1318), .B(n1319), .Y(n1174) );
  INVX4 I805 ( .A(n1283), .Y(n1319) );
  INVX4 I806 ( .A(T1_MDR_EN), .Y(n989) );
  BUFX3 I807 ( .A(n1190), .Y(n1475) );
  NAND2X1 I808 ( .A(DPTR[1]), .B(n1305), .Y(n1166) );
  NAND2X1 I809 ( .A(DPTR[9]), .B(n715), .Y(n1167) );
  NAND2X1 I810 ( .A(n1512), .B(TMP2[7]), .Y(n929) );
  NOR2X2 I811 ( .A(n1471), .B(n1472), .Y(n1458) );
  NOR2X2 I812 ( .A(n1464), .B(n1465), .Y(n1460) );
  AOI21X1 I813 ( .A0(n1356), .A1(n1467), .B0(n2180), .Y(n1464) );
  NAND2X1 I814 ( .A(n1355), .B(n1356), .Y(n1354) );
  MXI2X1 I815 ( .S0(n246), .B(n1497), .A(n1357), .Y(n1355) );
  NAND3X2 I816 ( .A(N236), .B(n906), .C(n1519), .Y(n1158) );
  INVX2 I817 ( .A(n1504), .Y(n1503) );
  NOR2X2 I818 ( .A(n1417), .B(n1418), .Y(n1406) );
  OAI21X1 I819 ( .A0(n348), .A1(n1421), .B0(n1422), .Y(n1417) );
  OAI21X1 I820 ( .A0(n349), .A1(n1419), .B0(n1420), .Y(n1418) );
  NOR2X2 I821 ( .A(n1412), .B(n1413), .Y(n1408) );
  AOI21X1 I822 ( .A0(n1356), .A1(n1414), .B0(n736), .Y(n1412) );
  AOI32X1 I823 ( .A0(N330), .A1(n348), .A2(ALU_SUBBC_EN), .B0(N293), .B1(
        ALU_ADC_EN), .Y(n345) );
  BUFX4 I824 ( .A(MUL_OP_EN), .Y(n1517) );
  INVX2 I825 ( .A(TMP1[3]), .Y(N274) );
  BUFX4 I826 ( .A(n1562), .Y(TMP2[7]) );
  BUFX4 I827 ( .A(n1564), .Y(TMP2[5]) );
  DFFX1 MAR_reg_8_ ( .D(MAR_IN[8]), .CK(CLK), .Q(MAR[8]), .QN(n404) );
  DFFX1 PSW_reg_0_ ( .D(PSW_IN_0_), .CK(CLK), .QN(n394) );
  INVX4 I828 ( .A(n840), .Y(n834) );
  NAND4BX4 I829 ( .AN(n1320), .B(n762), .C(n763), .D(n1321), .Y(n1283) );
  NAND2X2 I830 ( .A(n1304), .B(n1306), .Y(n1286) );
  MX2X1 I831 ( .S0(n1508), .B(n1366), .A(ALU_CPL_EN), .Y(n711) );
  INVX1 I832 ( .A(n711), .Y(n712) );
  MX2X1 I833 ( .S0(TMP2[6]), .B(n1378), .A(ALU_CPL_EN), .Y(n713) );
  INVX1 I834 ( .A(n713), .Y(n714) );
  INVX1 I835 ( .A(ID_PCH_EN), .Y(n1502) );
  NAND2X2 I836 ( .A(n1092), .B(n1466), .Y(n1353) );
  OAI21X1 I837 ( .A0(n1346), .A1(n1347), .B0(n1529), .Y(n1159) );
  NOR2BX1 I838 ( .AN(n1497), .B(n1509), .Y(n1346) );
  NAND2BX2 I839 ( .AN(n1320), .B(n838), .Y(n1185) );
  BUFX3 I840 ( .A(TMP1[1]), .Y(n1529) );
  OR2X2 I841 ( .A(n835), .B(n595), .Y(n401) );
  OAI2BB2X2 I842 ( .A0N(BIT_REG[0]), .A1N(JBC_BIT_ADDR_EN), .B0(
        JBC_BIT_ADDR_EN), .B1(n271), .Y(n200) );
  INVX1 I843 ( .A(P0R[0]), .Y(n271) );
  INVX1 I844 ( .A(P0R[2]), .Y(n2690) );
  NAND2BX1 I845 ( .AN(n835), .B(n1503), .Y(n1156) );
  NOR2X1 I846 ( .A(n1363), .B(n723), .Y(n1397) );
  BUFX3 I847 ( .A(ALU_XRL_EN), .Y(n1497) );
  INVX1 I848 ( .A(P0R[1]), .Y(n2700) );
  INVX2 I849 ( .A(n1185), .Y(n1164) );
  INVX2 I850 ( .A(ALU_SUBBC_EN), .Y(n349) );
  NAND4BX1 I851 ( .AN(TMP1[0]), .B(N274), .C(n930), .D(n824), .Y(n362) );
  NOR2X1 I852 ( .A(n1529), .B(TMP1[2]), .Y(n930) );
  NOR2X1 I853 ( .A(n751), .B(n722), .Y(n824) );
  NAND3X1 I854 ( .A(n1158), .B(n1159), .C(n1160), .Y(n1153) );
  NAND2X1 I855 ( .A(N254), .B(ALU_ADC_EN), .Y(n1349) );
  AOI22X1 I856 ( .A0(N316), .A1(ALU_SUBBC_EN), .B0(ALU_SWAP_EN), .B1(TMP2[5]), 
        .Y(n1348) );
  AOI22X1 I857 ( .A0(TMP2[0]), .A1(n1352), .B0(n1353), .B1(n1508), .Y(n1350)
         );
  AOI22X1 I858 ( .A0(n1517), .A1(ACC[4]), .B0(ACC[2]), .B1(n1518), .Y(n882) );
  NAND4X2 I859 ( .A(n1406), .B(n1407), .C(n1408), .D(n1409), .Y(n890) );
  AND2X2 I860 ( .A(n809), .B(n810), .Y(n1409) );
  INVX2 I861 ( .A(n1516), .Y(n1515) );
  NAND4X2 I862 ( .A(n1458), .B(n1459), .C(n1460), .D(n1461), .Y(n889) );
  BUFX3 I863 ( .A(n1559), .Y(TMP1[3]) );
  OAI2BB1X2 I864 ( .A0N(n836), .A1N(n1202), .B0(n1203), .Y(IDATA[6]) );
  NAND2X1 I865 ( .A(n1336), .B(n1331), .Y(n1322) );
  OAI2BB2X2 I866 ( .A0N(BIT_REG[1]), .A1N(JBC_BIT_ADDR_EN), .B0(
        JBC_BIT_ADDR_EN), .B1(n2700), .Y(n213) );
  NAND2X1 I867 ( .A(n826), .B(n760), .Y(n1285) );
  OAI22X1 I868 ( .A0(n1322), .A1(n394), .B0(n292), .B1(n1334), .Y(n1333) );
  NAND2X1 I869 ( .A(N295), .B(ALU_SUB_EN), .Y(n1351) );
  AND3X2 I870 ( .A(n306), .B(n313), .C(CY_AC_OV_SUB_UP), .Y(n3200) );
  MXI2X2 I871 ( .S0(n1520), .B(N218), .A(T1_GT_T2), .Y(n949) );
  AOI22X1 I872 ( .A0(P0_IN[2]), .A1(n1515), .B0(ACC[1]), .B1(n1518), .Y(n878)
         );
  OAI22X1 I873 ( .A0(n138), .A1(n752), .B0(n742), .B1(n800), .Y(n1042) );
  OAI21X1 I874 ( .A0(TMP2[7]), .A1(n1512), .B0(n929), .Y(n365) );
  INVX1 I875 ( .A(n362), .Y(n375) );
  OAI2BB2X2 I876 ( .A0N(JBC_BIT_ADDR_EN), .A1N(BIT_REG[2]), .B0(
        JBC_BIT_ADDR_EN), .B1(n2690), .Y(n224) );
  AND2X2 I877 ( .A(n811), .B(n812), .Y(n1461) );
  INVX1 I878 ( .A(N266), .Y(n1463) );
  NOR2X2 I879 ( .A(n1447), .B(n1448), .Y(n1441) );
  OAI21X1 I880 ( .A0(n1453), .A1(n1456), .B0(n1454), .Y(n1447) );
  NAND4X1 I881 ( .A(n1449), .B(n1450), .C(n1451), .D(n1452), .Y(n1448) );
  NOR2X2 I882 ( .A(n1443), .B(n1444), .Y(n1442) );
  NOR2X1 I883 ( .A(n1090), .B(n1446), .Y(n1443) );
  NOR2X1 I884 ( .A(n724), .B(n1445), .Y(n1444) );
  NOR2X2 I885 ( .A(n1368), .B(n1369), .Y(n1358) );
  NAND2X1 I886 ( .A(n1367), .B(n1356), .Y(n1366) );
  MXI2X1 I887 ( .S0(n1527), .B(n1357), .A(n1497), .Y(n1367) );
  NOR2X2 I888 ( .A(n1361), .B(n1362), .Y(n1359) );
  AOI21X1 I889 ( .A0(n1356), .A1(n1365), .B0(N273), .Y(n1361) );
  NOR2X1 I890 ( .A(n1390), .B(n1391), .Y(n1389) );
  NOR3X1 I891 ( .A(n1396), .B(n1397), .C(n1398), .Y(n1388) );
  NOR2X2 I892 ( .A(n1380), .B(n1381), .Y(n1372) );
  OAI21X1 I893 ( .A0(n349), .A1(n1382), .B0(n1383), .Y(n1381) );
  NAND2X1 I894 ( .A(n1379), .B(n1356), .Y(n1378) );
  MXI2X1 I895 ( .S0(n1510), .B(n1357), .A(n1497), .Y(n1379) );
  NOR2X2 I896 ( .A(n1375), .B(n1376), .Y(n1373) );
  AOI21X1 I897 ( .A0(n1356), .A1(n1377), .B0(n735), .Y(n1375) );
  INVX1 I898 ( .A(N267), .Y(n1411) );
  INVX1 I899 ( .A(n943), .Y(n944) );
  INVX1 I900 ( .A(n332), .Y(n3290) );
  NAND4X2 I901 ( .A(n1372), .B(n714), .C(n1373), .D(n1374), .Y(n858) );
  AOI22X1 I902 ( .A0(P0_IN[6]), .A1(n1515), .B0(ACC[5]), .B1(n1518), .Y(n896)
         );
  OAI211X1 I903 ( .A0(n1519), .A1(ALU_SUB_EN), .B0(N329), .C0(n347), .Y(n346)
         );
  MXI2X1 I904 ( .S0(n1520), .B(n936), .A(n935), .Y(n934) );
  NOR2X1 I905 ( .A(n1484), .B(n890), .Y(n1405) );
  NOR2X1 I906 ( .A(n889), .B(n885), .Y(n1404) );
  NOR2X1 I907 ( .A(n1476), .B(n858), .Y(n1343) );
  OAI2BB1X2 I908 ( .A0N(n837), .A1N(n1216), .B0(n1217), .Y(IDATA[5]) );
  NAND4X2 I909 ( .A(n1148), .B(n1149), .C(n1150), .D(n1151), .Y(IDATA[1]) );
  OAI21X2 I910 ( .A0(n1154), .A1(n1153), .B0(n1155), .Y(n1150) );
  AOI22X1 I911 ( .A0(n1480), .A1(n1529), .B0(ACC[1]), .B1(n1507), .Y(n870) );
  OAI2BB1X2 I912 ( .A0N(n838), .A1N(n1269), .B0(n1270), .Y(IDATA[2]) );
  INVX2 I913 ( .A(n405), .Y(n911) );
  AND3X2 I914 ( .A(n2610), .B(n197), .C(n191), .Y(n2620) );
  AOI22X1 I915 ( .A0(P0_IN[4]), .A1(n1515), .B0(ACC[5]), .B1(n1517), .Y(n886)
         );
  NOR2X2 I916 ( .A(n1341), .B(n1342), .Y(ALLZ) );
  NAND2X1 I917 ( .A(n1343), .B(n1344), .Y(n1342) );
  NAND2X1 I918 ( .A(n1404), .B(n1405), .Y(n1341) );
  NOR2X1 I919 ( .A(n881), .B(n875), .Y(n1344) );
  DFFHQX1 B_REG_reg_7_ ( .D(B_REG_IN[7]), .CK(CLK), .Q(B_REG[7]) );
  DFFHQX1 B_REG_reg_3_ ( .D(B_REG_IN[3]), .CK(CLK), .Q(B_REG[3]) );
  DFFHQX1 B_REG_reg_2_ ( .D(B_REG_IN[2]), .CK(CLK), .Q(B_REG[2]) );
  DFFHQX1 B_REG_reg_0_ ( .D(B_REG_IN[0]), .CK(CLK), .Q(B_REG[0]) );
  DFFTRX1 SP_reg_7_ ( .D(n272), .CK(CLK), .RN(n837), .Q(SP[7]), .QN(n829) );
  DFFHQX1 SP_reg_1_ ( .D(SP_IN_1_), .CK(CLK), .Q(SP[1]) );
  DFFHQX1 SP_reg_0_ ( .D(SP_IN_0_), .CK(CLK), .Q(SP[0]) );
  DFFHQX2 MAR_reg_7_ ( .D(MAR_IN[7]), .CK(CLK), .Q(MAR[7]) );
  DFFHQX2 MAR_reg_6_ ( .D(MAR_IN[6]), .CK(CLK), .Q(MAR[6]) );
  DFFHQX2 MAR_reg_4_ ( .D(MAR_IN[4]), .CK(CLK), .Q(MAR[4]) );
  DFFX1 MAR_reg_3_ ( .D(MAR_IN[3]), .CK(CLK), .Q(MAR[3]), .QN(n793) );
  DFFHQX1 TMP1_reg_7_ ( .D(TMP1_IN_7_), .CK(CLK), .Q(n1555) );
  INVX2 I920 ( .A(ALU_ADC_EN), .Y(n348) );
  BUFX3 I921 ( .A(n1567), .Y(n1508) );
  DFFTRX1 TMP2_reg_2_ ( .D(n142), .CK(CLK), .RN(n841), .Q(n1567), .QN(n752) );
  AND2X2 I922 ( .A(n1117), .B(ID_WR_EN), .Y(n822) );
  BUFX3 I923 ( .A(n1560), .Y(n1527) );
  AND3X2 I924 ( .A(MAR[0]), .B(n826), .C(n757), .Y(n715) );
  AND4X2 I925 ( .A(n1348), .B(n1349), .C(n1350), .D(n1351), .Y(n716) );
  NAND2X2 I926 ( .A(n1500), .B(n756), .Y(n717) );
  INVX1 I927 ( .A(ALU_SUB_EN), .Y(n1514) );
  BUFX8 I928 ( .A(n1563), .Y(TMP2[6]) );
  OR2X2 I929 ( .A(n169), .B(n170), .Y(n720) );
  INVX1 I930 ( .A(WM_EN), .Y(n1504) );
  BUFX4 I931 ( .A(n1561), .Y(TMP1[0]) );
  OR2X2 I932 ( .A(TMP1[7]), .B(TMP1[6]), .Y(n722) );
  DFFTRX1 TMP2_reg_1_ ( .D(n150), .CK(CLK), .RN(n843), .Q(n1568), .QN(n723) );
  DFFTRX2 TMP1_reg_1_ ( .D(n2420), .CK(CLK), .RN(n841), .Q(TMP1[1]), .QN(n246)
         );
  INVX1 I933 ( .A(ALU_ANL_EN), .Y(n1496) );
  NAND2X2 I934 ( .A(n1519), .B(n906), .Y(n724) );
  MX2X1 I935 ( .S0(n1517), .B(n770), .A(n769), .Y(n725) );
  AND2X2 I936 ( .A(ALU_RRC_EN), .B(n1520), .Y(n726) );
  INVX2 I937 ( .A(n715), .Y(n1479) );
  NOR2X1 I938 ( .A(n835), .B(n488), .Y(n728) );
  DFFX2 MAR_reg_1_ ( .D(MAR_IN[1]), .CK(CLK), .Q(MAR[1]), .QN(n730) );
  DFFX1 MAR_reg_2_ ( .D(MAR_IN[2]), .CK(CLK), .Q(MAR[2]), .QN(n732) );
  DFFTRX1 TMP1_reg_4_ ( .D(n214), .CK(CLK), .RN(n836), .Q(n1558), .QN(n2180)
         );
  BUFX8 I939 ( .A(n1565), .Y(TMP2[4]) );
  DFFTRX1 TMP1_reg_6_ ( .D(n185), .CK(CLK), .RN(n837), .Q(n1556), .QN(n735) );
  DFFTRX1 TMP1_reg_5_ ( .D(n201), .CK(CLK), .RN(n836), .Q(n1557), .QN(n736) );
  NAND2X2 I940 ( .A(MAR[5]), .B(n1331), .Y(n482) );
  AND2X2 I941 ( .A(TMP2[4]), .B(n761), .Y(n737) );
  OR2X2 I942 ( .A(B_T2RES_EN), .B(B_T1_EN), .Y(n738) );
  OR2X2 I943 ( .A(SP_T1_EN), .B(SP_RES_EN), .Y(n739) );
  INVX2 I944 ( .A(T1_XCHD_MDR_EN), .Y(n192) );
  DFFTRX2 PSW_reg_7_ ( .D(n2940), .CK(CLK), .RN(n837), .Q(CY), .QN(n2600) );
  OR2X2 I945 ( .A(T2_P0R_EN), .B(T2_A_EN), .Y(n740) );
  AND2X2 I946 ( .A(PC[15]), .B(ID_PCH_EN), .Y(n741) );
  DFFX1 ACC_reg_7_ ( .D(n728), .CK(CLK), .Q(ACC[7]), .QN(n99) );
  DFFX1 ACC_reg_3_ ( .D(n790), .CK(CLK), .Q(ACC[3]), .QN(n742) );
  DFFTRX1 SP_reg_6_ ( .D(n276), .CK(CLK), .RN(n837), .Q(SP[6]), .QN(n744) );
  DFFX2 ACC_reg_5_ ( .D(n787), .CK(CLK), .Q(ACC[5]), .QN(n118) );
  DFFX2 ACC_reg_6_ ( .D(n789), .CK(CLK), .Q(ACC[6]), .QN(n109) );
  DFFX1 B_REG_reg_6_ ( .D(B_REG_IN[6]), .CK(CLK), .Q(B_REG[6]), .QN(n746) );
  DFFX1 B_REG_reg_5_ ( .D(B_REG_IN[5]), .CK(CLK), .Q(B_REG[5]), .QN(n747) );
  DFFTRX1 SP_reg_5_ ( .D(n2780), .CK(CLK), .RN(n837), .Q(SP[5]), .QN(n748) );
  DFFTRX1 PSW_reg_6_ ( .D(n336), .CK(CLK), .RN(n839), .Q(PSW_6_), .QN(n749) );
  DFFX1 B_REG_reg_4_ ( .D(B_REG_IN[4]), .CK(CLK), .Q(B_REG[4]), .QN(n222) );
  DFFTRX1 TMP2_reg_3_ ( .D(n129), .CK(CLK), .RN(n841), .Q(n1566), .QN(n750) );
  OR2X2 I947 ( .A(TMP1[5]), .B(TMP1[4]), .Y(n751) );
  BUFX3 I948 ( .A(n1560), .Y(TMP1[2]) );
  DFFTRX1 TMP1_reg_2_ ( .D(n233), .CK(CLK), .RN(n841), .Q(n1560), .QN(n2370)
         );
  DFFHQX1 SP_reg_2_ ( .D(SP_IN_2_), .CK(CLK), .Q(SP[2]) );
  NAND4X2 I949 ( .A(n1439), .B(n1440), .C(n1441), .D(n1442), .Y(n885) );
  NAND4X2 I950 ( .A(n1439), .B(n1440), .C(n1441), .D(n1442), .Y(n1495) );
  NAND2X1 I951 ( .A(n1157), .B(n716), .Y(n1154) );
  OAI2BB1X2 I952 ( .A0N(n838), .A1N(n1233), .B0(n1234), .Y(IDATA[4]) );
  AOI221X4 I953 ( .A0(T1_B_EN), .A1(B_REG[2]), .B0(T1_P0R_EN), .B1(P0R[2]), 
        .C0(n2390), .Y(n2380) );
  NAND4X2 I954 ( .A(n1358), .B(n712), .C(n1359), .D(n1360), .Y(n881) );
  NAND4X2 I955 ( .A(n813), .B(n1172), .C(n1174), .D(n1178), .Y(n863) );
  OAI2BB1X2 I956 ( .A0N(n838), .A1N(n1249), .B0(n1250), .Y(IDATA[3]) );
  INVX2 I957 ( .A(n1322), .Y(n1117) );
  NAND4X2 I958 ( .A(n1458), .B(n1459), .C(n1460), .D(n1461), .Y(n1494) );
  NOR2X2 I959 ( .A(MAR_BAR_EN), .B(MAR_P0R_EN), .Y(n803) );
  OAI211X1 I960 ( .A0(n803), .A1(n117), .B0(n421), .C0(n422), .Y(n420) );
  NAND4BBX2 I961 ( .AN(n429), .BN(n462), .C(n410), .D(n803), .Y(n405) );
  BUFX3 I962 ( .A(n1557), .Y(TMP1[5]) );
  BUFX4 I963 ( .A(n1558), .Y(TMP1[4]) );
  BUFX3 I964 ( .A(n1556), .Y(TMP1[6]) );
  NOR2X4 I965 ( .A(T1_GT_T2), .B(n483), .Y(n807) );
  NAND2BX2 I966 ( .AN(n835), .B(B_T2RES_EN), .Y(n483) );
  NAND4X2 I967 ( .A(n1406), .B(n1407), .C(n1408), .D(n759), .Y(n1491) );
  NAND2X1 I968 ( .A(n1292), .B(n1293), .Y(n874) );
  NOR2X1 I969 ( .A(n944), .B(n945), .Y(n941) );
  DFFHQX2 ACC_reg_4_ ( .D(n788), .CK(CLK), .Q(ACC[4]) );
  NOR2X2 I970 ( .A(n835), .B(n562), .Y(n788) );
  OAI31X1 I971 ( .A0(n143), .A1(OV_T1Z_EN), .A2(n845), .B0(n355), .Y(n354) );
  INVX2 I972 ( .A(n822), .Y(n845) );
  NOR2X2 I973 ( .A(n740), .B(n720), .Y(n761) );
  NOR2X4 I974 ( .A(n823), .B(n739), .Y(n808) );
  NOR2X4 I975 ( .A(n755), .B(n738), .Y(n805) );
  INVX4 I976 ( .A(n754), .Y(n755) );
  AND4X2 I977 ( .A(n1175), .B(n1172), .C(n1174), .D(n1173), .Y(n765) );
  NAND3X1 I978 ( .A(n989), .B(n1018), .C(n192), .Y(n1500) );
  NAND3X1 I979 ( .A(n989), .B(n1018), .C(n192), .Y(n757) );
  NAND3X1 I980 ( .A(n989), .B(n1018), .C(n192), .Y(n758) );
  NAND3X2 I981 ( .A(n989), .B(n1018), .C(n192), .Y(n1304) );
  NAND3X1 I982 ( .A(n1387), .B(n1388), .C(n1389), .Y(n1176) );
  AND2X2 I983 ( .A(n809), .B(n810), .Y(n759) );
  OR2X1 I984 ( .A(n724), .B(n1410), .Y(n810) );
  NOR3BX4 I985 ( .AN(n1171), .B(RESET), .C(n765), .Y(IDATA[0]) );
  NOR2X1 I986 ( .A(n1356), .B(n1401), .Y(n1396) );
  AND2X2 I987 ( .A(n1438), .B(n1496), .Y(n798) );
  AND2X1 I988 ( .A(n755), .B(IDATA[3]), .Y(n804) );
  INVX1 I989 ( .A(T1_GT_T2), .Y(n303) );
  AND2X1 I990 ( .A(n761), .B(TMP2[6]), .Y(n817) );
  AND2X1 I991 ( .A(n761), .B(TMP2[5]), .Y(n818) );
  AND2X1 I992 ( .A(n761), .B(n1508), .Y(n820) );
  BUFX4 I993 ( .A(n1567), .Y(TMP2[2]) );
  BUFX4 I994 ( .A(n1566), .Y(TMP2[3]) );
  INVX1 I995 ( .A(ACC[7]), .Y(n1554) );
  NAND3X1 I996 ( .A(n989), .B(n1018), .C(n192), .Y(n760) );
  AND2X1 I997 ( .A(n192), .B(n989), .Y(n797) );
  INVX1 I998 ( .A(T1_B_EN), .Y(n191) );
  INVX1 I999 ( .A(T1_RES_EN), .Y(n2670) );
  INVX1 I1000 ( .A(CY_AC_OV_SUB_UP), .Y(n344) );
  NAND3X1 I1001 ( .A(n989), .B(n1018), .C(n192), .Y(n1499) );
  INVX1 I1002 ( .A(ALU_BITC_EN), .Y(n1438) );
  INVX1 I1003 ( .A(MAR_T1_EN), .Y(n412) );
  INVX1 I1004 ( .A(n1476), .Y(n864) );
  BUFX3 I1005 ( .A(DIV_OP_EN), .Y(n1518) );
  INVX1 I1006 ( .A(T1_P0R_EN), .Y(n189) );
  INVX1 I1007 ( .A(MAR_SP_EN), .Y(n411) );
  NAND2BX1 I1008 ( .AN(n331), .B(C_ALLZ_B_OR_EN), .Y(n332) );
  INVX1 I1009 ( .A(SP_T1_EN), .Y(n1489) );
  INVX1 I1010 ( .A(SP_RES_EN), .Y(n1483) );
  NAND2BX1 I1011 ( .AN(n1176), .B(n1173), .Y(n907) );
  INVX1 I1012 ( .A(n764), .Y(n1484) );
  INVX1 I1013 ( .A(RESET), .Y(n843) );
  NAND4X1 I1014 ( .A(n951), .B(n952), .C(n953), .D(n954), .Y(n943) );
  NOR2X1 I1015 ( .A(n1494), .B(n1495), .Y(n953) );
  INVX1 I1016 ( .A(n764), .Y(n1485) );
  INVX2 I1017 ( .A(T2_P0R_EN), .Y(n98) );
  INVX1 I1018 ( .A(T2_RES_EN), .Y(n856) );
  INVX1 I1019 ( .A(TMP1[0]), .Y(N311) );
  NAND2X2 I1020 ( .A(n758), .B(n1303), .Y(n762) );
  NAND2X4 I1021 ( .A(n1117), .B(n1304), .Y(n763) );
  AND4X2 I1022 ( .A(n1423), .B(n1424), .C(n1425), .D(n725), .Y(n764) );
  NAND2X1 I1023 ( .A(N256), .B(ALU_ADC_EN), .Y(n1452) );
  NAND2X1 I1024 ( .A(N297), .B(n1513), .Y(n1451) );
  NOR2X1 I1025 ( .A(n798), .B(n1071), .Y(n1402) );
  NAND3X1 I1026 ( .A(n1484), .B(n718), .C(n928), .Y(n369) );
  INVX1 I1027 ( .A(T1_1_EN), .Y(n2590) );
  OR2X1 I1028 ( .A(n724), .B(n1462), .Y(n812) );
  OR2X1 I1029 ( .A(n1090), .B(n1463), .Y(n811) );
  OAI21X1 I1030 ( .A0(n365), .A1(n1403), .B0(n1435), .Y(n1434) );
  OR4X2 I1031 ( .A(n1186), .B(n1187), .C(n1188), .D(n1189), .Y(n766) );
  XNOR2X1 I1032 ( .A(TMP2[0]), .B(TMP1[0]), .Y(n767) );
  NAND2X1 I1033 ( .A(ALU_SWAP_EN), .B(TMP2[7]), .Y(n1450) );
  BUFX3 I1034 ( .A(n844), .Y(IDATA[7]) );
  NAND2X2 I1035 ( .A(PERI_SFR_sel), .B(n1164), .Y(n768) );
  NAND2X1 I1036 ( .A(N242), .B(n1519), .Y(n769) );
  NAND2X1 I1037 ( .A(N269), .B(n1519), .Y(n770) );
  OR4X2 I1038 ( .A(n1235), .B(n1236), .C(n1237), .D(n1238), .Y(n771) );
  OR4X2 I1039 ( .A(n1251), .B(n1252), .C(n1253), .D(n1254), .Y(n772) );
  NOR2X1 I1040 ( .A(n127), .B(n717), .Y(n1237) );
  INVX1 I1041 ( .A(n628), .Y(ACC_IN_0_) );
  AOI21X1 I1042 ( .A0(n1164), .A1(n1296), .B0(n1161), .Y(n1292) );
  NOR3X1 I1043 ( .A(n773), .B(n774), .C(n775), .Y(n1205) );
  NOR2X1 I1044 ( .A(n763), .B(n749), .Y(n773) );
  NOR2X1 I1045 ( .A(n717), .B(n109), .Y(n774) );
  NOR2X1 I1046 ( .A(n1475), .B(n746), .Y(n775) );
  NOR3X1 I1047 ( .A(n776), .B(n777), .C(n778), .Y(n1272) );
  NOR2X1 I1048 ( .A(n763), .B(n743), .Y(n776) );
  NOR2X1 I1049 ( .A(n717), .B(n745), .Y(n777) );
  NOR2X1 I1050 ( .A(n1475), .B(n1277), .Y(n778) );
  INVX1 I1051 ( .A(n482), .Y(n1306) );
  AND3X1 I1052 ( .A(n1166), .B(n1167), .C(n1165), .Y(n1302) );
  NOR2X1 I1053 ( .A(n762), .B(n744), .Y(n779) );
  NOR3X1 I1054 ( .A(n780), .B(n781), .C(n782), .Y(n1220) );
  NOR2X1 I1055 ( .A(n762), .B(n748), .Y(n780) );
  NOR2X1 I1056 ( .A(n1479), .B(n1222), .Y(n781) );
  NOR2X1 I1057 ( .A(n727), .B(n1221), .Y(n782) );
  NOR3X1 I1058 ( .A(n783), .B(n784), .C(n785), .Y(n1273) );
  NOR2X1 I1059 ( .A(n1479), .B(n1275), .Y(n784) );
  NOR2X1 I1060 ( .A(n727), .B(n1274), .Y(n785) );
  AND2X1 I1061 ( .A(n1169), .B(n1168), .Y(n1301) );
  NAND4X1 I1062 ( .A(n1084), .B(n1085), .C(n1086), .D(n1087), .Y(n1081) );
  AOI21X1 I1063 ( .A0(n939), .A1(n940), .B0(C_0_EN), .Y(n938) );
  MXI2X1 I1064 ( .S0(C_ALLZ_AND_EN), .B(n942), .A(n941), .Y(n939) );
  NAND2X1 I1065 ( .A(TMP2[0]), .B(TMP1[0]), .Y(n1071) );
  NOR2X1 I1066 ( .A(n2600), .B(n943), .Y(n942) );
  NOR2BX1 I1067 ( .AN(n247), .B(n979), .Y(n978) );
  AND2X2 I1068 ( .A(n1094), .B(n836), .Y(n786) );
  INVX2 I1069 ( .A(n178), .Y(n198) );
  INVX1 I1070 ( .A(n224), .Y(n182) );
  AOI21X1 I1071 ( .A0(n1544), .A1(n1543), .B0(n1542), .Y(n1546) );
  NAND3X1 I1072 ( .A(n1117), .B(PSW_1_), .C(n1499), .Y(n1168) );
  BUFX8 I1073 ( .A(TMP_CY_7_), .Y(n1520) );
  BUFX8 I1074 ( .A(n1569), .Y(TMP2[0]) );
  NOR2X1 I1075 ( .A(n835), .B(n544), .Y(n787) );
  NOR2X1 I1076 ( .A(n835), .B(n524), .Y(n789) );
  NOR2X1 I1077 ( .A(n835), .B(n578), .Y(n790) );
  AND2X2 I1078 ( .A(n1340), .B(n792), .Y(n791) );
  INVX1 I1079 ( .A(ID_PCL_EN), .Y(n1506) );
  AND4X2 I1080 ( .A(n793), .B(n732), .C(MAR[8]), .D(MAR[7]), .Y(n792) );
  BUFX3 I1081 ( .A(ID_T2_EN), .Y(n1498) );
  NOR3X1 I1082 ( .A(n794), .B(n795), .C(n796), .Y(n1219) );
  NOR2X1 I1083 ( .A(n763), .B(n350), .Y(n794) );
  NOR2X1 I1084 ( .A(n717), .B(n118), .Y(n795) );
  NOR2X1 I1085 ( .A(n1475), .B(n747), .Y(n796) );
  INVX1 I1086 ( .A(MAR[4]), .Y(n425) );
  BUFX4 I1087 ( .A(n1555), .Y(TMP1[7]) );
  OAI2BB1X1 I1088 ( .A0N(T1_BITCP_EN), .A1N(n2600), .B0(n2610), .Y(n178) );
  BUFX3 I1089 ( .A(n1555), .Y(n1512) );
  BUFX3 I1090 ( .A(n1566), .Y(n1511) );
  BUFX3 I1091 ( .A(n1556), .Y(n1510) );
  OAI2BB1X1 I1092 ( .A0N(MAR_BAR_EN), .A1N(P0R[7]), .B0(n439), .Y(n418) );
  AOI22X1 I1093 ( .A0(PC[7]), .A1(n1505), .B0(n1498), .B1(TMP2[7]), .Y(n1194)
         );
  INVX1 I1094 ( .A(B_REG[7]), .Y(n1079) );
  INVX1 I1095 ( .A(P0R[4]), .Y(n126) );
  INVX1 I1096 ( .A(P0R[5]), .Y(n117) );
  DFFHQX1 PSW_7_D_reg ( .D(CY), .CK(CLK), .Q(TMP_CY_7_) );
  INVX2 I1097 ( .A(n2670), .Y(n980) );
  INVX1 I1098 ( .A(n191), .Y(n1004) );
  INVX1 I1099 ( .A(n1514), .Y(n1513) );
  INVX4 I1100 ( .A(n839), .Y(n835) );
  INVX2 I1101 ( .A(n1517), .Y(n906) );
  INVX1 I1102 ( .A(n1497), .Y(n1403) );
  INVX1 I1103 ( .A(n1497), .Y(n1457) );
  MXI2X1 I1104 ( .S0(n944), .B(n799), .A(n3290), .Y(n946) );
  BUFX3 I1105 ( .A(WA_EN), .Y(n1477) );
  INVX1 I1106 ( .A(n842), .Y(n837) );
  INVX1 I1107 ( .A(n842), .Y(n836) );
  INVX1 I1108 ( .A(n834), .Y(n839) );
  INVX1 I1109 ( .A(n842), .Y(n840) );
  INVX1 I1110 ( .A(n834), .Y(n838) );
  NOR2X1 I1111 ( .A(ALU_SWAP_EN), .B(ALU_RL_EN), .Y(n1091) );
  NOR2X1 I1112 ( .A(n799), .B(n3290), .Y(n950) );
  INVX1 I1113 ( .A(n128), .Y(n859) );
  INVX1 I1114 ( .A(n800), .Y(n1019) );
  INVX1 I1115 ( .A(n3210), .Y(n305) );
  NOR2X1 I1116 ( .A(n3210), .B(n306), .Y(n799) );
  INVX1 I1117 ( .A(n1518), .Y(n167) );
  INVX1 I1118 ( .A(n1489), .Y(n1487) );
  INVX1 I1119 ( .A(n1483), .Y(n1481) );
  INVX1 I1120 ( .A(n1489), .Y(n1488) );
  INVX1 I1121 ( .A(n1483), .Y(n1482) );
  INVX1 I1122 ( .A(CY_AC_OV_UP), .Y(n932) );
  NAND2X2 I1123 ( .A(n1519), .B(n1517), .Y(n1090) );
  OR2X2 I1124 ( .A(ALU_RL_EN), .B(ALU_RLC_EN), .Y(n1352) );
  INVX1 I1125 ( .A(ALU_RR_EN), .Y(n1092) );
  INVX1 I1126 ( .A(n632), .Y(n1507) );
  INVX1 I1127 ( .A(A_MRR_EN), .Y(n1516) );
  INVX1 I1128 ( .A(n632), .Y(n490) );
  INVX1 I1129 ( .A(n843), .Y(n842) );
  OR3X2 I1130 ( .A(MAR_T1_EN), .B(MAR_SP_EN), .C(MAR_RES_EN), .Y(n462) );
  NAND3BX1 I1131 ( .AN(OV_T1Z_EN), .B(n845), .C(CY_AC_OV_UP), .Y(n361) );
  INVX1 I1132 ( .A(n976), .Y(n177) );
  OR2X2 I1133 ( .A(MAR_RI_EN), .B(MAR_RN_EN), .Y(n429) );
  NAND3BX1 I1134 ( .AN(n3110), .B(n3200), .C(n305), .Y(n3020) );
  OR2X2 I1135 ( .A(CY_AC_OV_UP), .B(CY_UP), .Y(n3110) );
  OR2X2 I1136 ( .A(C_ALLZ_B_OR_EN), .B(n331), .Y(n3210) );
  BUFX3 I1137 ( .A(A_T1_EN), .Y(n1480) );
  NOR2X1 I1138 ( .A(T2_A_EN), .B(T2_XCHD_A_EN), .Y(n800) );
  OR2X2 I1139 ( .A(T2_REM2_EN), .B(n801), .Y(n91) );
  AND2X2 I1140 ( .A(n1518), .B(T1_GT_T2), .Y(n801) );
  INVX1 I1141 ( .A(MAR_MDR_EN), .Y(n410) );
  INVX1 I1142 ( .A(CY0_MUL_OV_UP), .Y(n3160) );
  INVX1 I1143 ( .A(MAR_RES_EN), .Y(n912) );
  INVX1 I1144 ( .A(C_ALLZ_OR_EN), .Y(n306) );
  NAND2BX1 I1145 ( .AN(n835), .B(n845), .Y(n351) );
  INVX1 I1146 ( .A(n842), .Y(n841) );
  INVX1 I1147 ( .A(ALU_RRC_EN), .Y(n1466) );
  INVX1 I1148 ( .A(n764), .Y(n1486) );
  BUFX3 I1149 ( .A(n907), .Y(n1476) );
  INVX1 I1150 ( .A(n762), .Y(n1193) );
  NAND2X1 I1151 ( .A(n1477), .B(n889), .Y(n888) );
  NAND2X1 I1152 ( .A(n1477), .B(n1495), .Y(n884) );
  NAND2X1 I1153 ( .A(n1477), .B(n1493), .Y(n898) );
  NAND2X1 I1154 ( .A(n1477), .B(n1492), .Y(n880) );
  INVX1 I1155 ( .A(n1490), .Y(n1024) );
  NOR2X1 I1156 ( .A(n1024), .B(n1156), .Y(n1294) );
  NOR2X1 I1157 ( .A(n1476), .B(n1493), .Y(n951) );
  NOR2X1 I1158 ( .A(n1492), .B(n1490), .Y(n952) );
  NOR2X1 I1159 ( .A(n1485), .B(n1491), .Y(n954) );
  OR3X1 I1160 ( .A(T2_SP_EN), .B(T2_RES_EN), .C(T2_REM2_EN), .Y(n169) );
  NAND2X1 I1161 ( .A(n1477), .B(n875), .Y(n872) );
  INVX1 I1162 ( .A(n314), .Y(n928) );
  INVX1 I1163 ( .A(n1156), .Y(n1155) );
  NAND2X2 I1164 ( .A(n303), .B(n1518), .Y(n857) );
  NOR2BX1 I1165 ( .AN(n858), .B(n857), .Y(n853) );
  NAND4X1 I1166 ( .A(n802), .B(n2620), .C(n2630), .D(n2590), .Y(n976) );
  NAND2BX1 I1167 ( .AN(n857), .B(n889), .Y(n1057) );
  NAND2BX1 I1168 ( .AN(n856), .B(n858), .Y(n1065) );
  NAND2BX1 I1169 ( .AN(n857), .B(n881), .Y(n1039) );
  NAND2BX1 I1170 ( .AN(n856), .B(n1492), .Y(n1031) );
  NAND2BX1 I1171 ( .AN(n857), .B(n1490), .Y(n1030) );
  NAND2BX1 I1172 ( .AN(n857), .B(n1491), .Y(n1066) );
  NAND2BX1 I1173 ( .AN(n857), .B(n885), .Y(n1047) );
  NAND2BX1 I1174 ( .AN(n906), .B(n1491), .Y(n992) );
  NAND2BX1 I1175 ( .AN(n906), .B(n1493), .Y(n999) );
  NAND2X1 I1176 ( .A(n1494), .B(n980), .Y(n993) );
  NAND2X1 I1177 ( .A(n858), .B(n980), .Y(n1008) );
  NAND2X1 I1178 ( .A(n1492), .B(n980), .Y(n984) );
  OR2X2 I1179 ( .A(n822), .B(n335), .Y(n331) );
  OR4X2 I1180 ( .A(C_ALLZ_AND_EN), .B(C_0_EN), .C(C_ALLZ_B_EN), .D(
        C_ALLZ_B_AND_EN), .Y(n335) );
  INVX1 I1181 ( .A(T1_CBP_EN), .Y(n2610) );
  INVX1 I1182 ( .A(CY0_DIV_OV_UP), .Y(n3150) );
  INVX1 I1183 ( .A(C_CB_EN), .Y(n313) );
  OR2X2 I1184 ( .A(n303), .B(n483), .Y(n463) );
  INVX2 I1185 ( .A(T2_SP_EN), .Y(n96) );
  DFFTRX1 PSW_reg_2_ ( .D(n354), .CK(CLK), .RN(n843), .QN(n743) );
  NAND2X1 I1186 ( .A(N262), .B(ALU_ADD_EN), .Y(n1385) );
  NAND2X1 I1187 ( .A(n1497), .B(n734), .Y(n1467) );
  NAND2X1 I1188 ( .A(ALU_CPL_EN), .B(n750), .Y(n1454) );
  AND2X2 I1189 ( .A(n1159), .B(n1160), .Y(n1345) );
  INVX1 I1190 ( .A(N258), .Y(n1421) );
  BUFX3 I1191 ( .A(ALU_ADD_EN), .Y(n1519) );
  NOR2X1 I1192 ( .A(n1426), .B(n1427), .Y(n1425) );
  OAI21X1 I1193 ( .A0(n349), .A1(n1428), .B0(n1429), .Y(n1427) );
  NAND3X1 I1194 ( .A(n1430), .B(n1431), .C(n1432), .Y(n1426) );
  INVX1 I1195 ( .A(N322), .Y(n1428) );
  NOR2X1 I1196 ( .A(n1364), .B(n719), .Y(n1436) );
  NOR2X1 I1197 ( .A(n798), .B(n929), .Y(n1437) );
  INVX1 I1198 ( .A(n1177), .Y(n1178) );
  BUFX3 I1199 ( .A(n1197), .Y(n1478) );
  NAND2X1 I1200 ( .A(n1285), .B(n1286), .Y(n1284) );
  NAND2X1 I1201 ( .A(N318), .B(ALU_SUBBC_EN), .Y(n1449) );
  NAND2X1 I1202 ( .A(n1497), .B(n733), .Y(n1414) );
  NAND2X1 I1203 ( .A(n1497), .B(n719), .Y(n1377) );
  NAND2X1 I1204 ( .A(n1497), .B(n752), .Y(n1365) );
  NAND2X1 I1205 ( .A(N296), .B(n1513), .Y(n1370) );
  NAND2X1 I1206 ( .A(N300), .B(ALU_SUB_EN), .Y(n1383) );
  NAND2X1 I1207 ( .A(N299), .B(n1513), .Y(n1420) );
  NAND2X1 I1208 ( .A(N298), .B(ALU_SUB_EN), .Y(n1473) );
  NAND2X1 I1209 ( .A(N260), .B(ALU_ADC_EN), .Y(n1429) );
  NAND2X1 I1210 ( .A(N301), .B(n1513), .Y(n1432) );
  NOR2X1 I1211 ( .A(n1436), .B(n1437), .Y(n1423) );
  AOI21X1 I1212 ( .A0(n1433), .A1(n1347), .B0(n1434), .Y(n1424) );
  DFFHQX1 B_REG_reg_1_ ( .D(B_REG_IN[1]), .CK(CLK), .Q(B_REG[1]) );
  NAND2X1 I1213 ( .A(n489), .B(n874), .Y(n873) );
  DFFHQX1 TMP1_reg_0_ ( .D(n786), .CK(CLK), .Q(n1561) );
  DFFTRX1 TMP1_reg_3_ ( .D(n225), .CK(CLK), .RN(n841), .Q(n1559), .QN(n721) );
  OR4X1 I1214 ( .A(WA_EN), .B(A_T1_EN), .C(A_MRR_EN), .D(n489), .Y(n402) );
  INVX1 I1215 ( .A(N311), .Y(n1530) );
  INVX1 I1216 ( .A(N321), .Y(n1382) );
  INVX1 I1217 ( .A(N320), .Y(n1419) );
  MXI2X1 I1218 ( .S0(OV_T1Z_EN), .B(n362), .A(n731), .Y(n923) );
  INVX1 I1219 ( .A(IDATA[4]), .Y(n120) );
  AOI21X1 I1220 ( .A0(n1091), .A1(n1092), .B0(n1093), .Y(n1088) );
  INVX1 I1221 ( .A(n874), .Y(n1108) );
  NAND2X1 I1222 ( .A(n823), .B(IDATA[6]), .Y(n968) );
  NAND2X1 I1223 ( .A(n823), .B(IDATA[5]), .Y(n964) );
  NAND2X1 I1224 ( .A(n823), .B(IDATA[2]), .Y(n1107) );
  NAND2X1 I1225 ( .A(n823), .B(IDATA[7]), .Y(n972) );
  NAND2BX1 I1226 ( .AN(n797), .B(n863), .Y(n1096) );
  NAND2X1 I1227 ( .A(N302), .B(n1513), .Y(n1086) );
  NAND3X1 I1228 ( .A(n973), .B(n974), .C(n975), .Y(n2420) );
  NAND2X1 I1229 ( .A(n875), .B(n980), .Y(n974) );
  AOI2BB1X1 I1230 ( .A0N(n246), .A1N(n976), .B0(n977), .Y(n975) );
  NAND2BX1 I1231 ( .AN(n797), .B(n874), .Y(n973) );
  MXI2X1 I1232 ( .S0(n822), .B(IDATA[7]), .A(n938), .Y(n937) );
  INVX1 I1233 ( .A(N240), .Y(n1410) );
  INVX1 I1234 ( .A(N239), .Y(n1462) );
  INVX1 I1235 ( .A(N238), .Y(n1445) );
  INVX1 I1236 ( .A(IDATA[2]), .Y(n143) );
  NOR2X1 I1237 ( .A(n923), .B(n924), .Y(n355) );
  MX2X1 I1238 ( .S0(n928), .B(n365), .A(n929), .Y(n925) );
  NAND2X1 I1239 ( .A(n823), .B(n863), .Y(n1116) );
  INVX2 I1240 ( .A(T1_DAD_EN), .Y(n197) );
  NOR3X1 I1241 ( .A(n182), .B(n183), .C(n184), .Y(n806) );
  NAND2X1 I1242 ( .A(n718), .B(N278), .Y(n1433) );
  NOR2X1 I1243 ( .A(T1_BITCP_EN), .B(T1_0_EN), .Y(n1099) );
  NAND2BX1 I1244 ( .AN(n361), .B(N278), .Y(n927) );
  INVX1 I1245 ( .A(n223), .Y(n217) );
  INVX1 I1246 ( .A(n489), .Y(n862) );
  NAND2BX1 I1247 ( .AN(n734), .B(n91), .Y(n1058) );
  NAND2BX1 I1248 ( .AN(n1052), .B(n91), .Y(n1048) );
  NAND2X1 I1249 ( .A(ACC[7]), .B(T2_A_EN), .Y(n849) );
  DFFTRX1 SP_reg_3_ ( .D(n282), .CK(CLK), .RN(n837), .Q(SP[3]) );
  DFFTRX1 SP_reg_4_ ( .D(n280), .CK(CLK), .RN(n841), .Q(SP[4]), .QN(n125) );
  NOR2X1 I1250 ( .A(n1526), .B(n750), .Y(n1553) );
  AOI21X1 I1251 ( .A0(n1551), .A1(n1550), .B0(n1542), .Y(n1552) );
  NOR2X1 I1252 ( .A(n1526), .B(n750), .Y(n1547) );
  NAND2X1 I1253 ( .A(n1526), .B(n750), .Y(n1545) );
  INVX1 I1254 ( .A(n823), .Y(n958) );
  NAND2X1 I1255 ( .A(n1520), .B(ALU_BITC_EN), .Y(n1470) );
  INVX1 I1256 ( .A(n1161), .Y(n1149) );
  INVX1 I1257 ( .A(n1152), .Y(n1151) );
  NOR3BX1 I1258 ( .AN(n1498), .B(n723), .C(n834), .Y(n1297) );
  INVX1 I1259 ( .A(n1511), .Y(n1456) );
  OR2X2 I1260 ( .A(n1090), .B(n1411), .Y(n809) );
  INVX1 I1261 ( .A(N265), .Y(n1446) );
  NAND2X1 I1262 ( .A(n1416), .B(n1356), .Y(n1415) );
  MXI2X1 I1263 ( .S0(TMP1[5]), .B(n1357), .A(n1497), .Y(n1416) );
  NAND2X1 I1264 ( .A(n1469), .B(n1356), .Y(n1468) );
  MXI2X1 I1265 ( .S0(TMP1[4]), .B(n1357), .A(n1497), .Y(n1469) );
  OAI21X1 I1266 ( .A0(n768), .A1(n1312), .B0(n1313), .Y(n1177) );
  NOR2X1 I1267 ( .A(n1314), .B(n1315), .Y(n1313) );
  INVX1 I1268 ( .A(PERI_SFR_DATA[0]), .Y(n1312) );
  NOR3BX1 I1269 ( .AN(n1498), .B(n729), .C(n834), .Y(n1314) );
  INVX1 I1270 ( .A(PERI_SFR_sel), .Y(n1321) );
  NAND2X1 I1271 ( .A(N253), .B(ALU_ADC_EN), .Y(n1392) );
  NOR2X1 I1272 ( .A(n1323), .B(n1324), .Y(n1318) );
  NAND2X1 I1273 ( .A(n1285), .B(n837), .Y(n1323) );
  NAND3X1 I1274 ( .A(n1393), .B(n1394), .C(n1395), .Y(n1390) );
  NAND2X1 I1275 ( .A(ALU_RL_EN), .B(TMP2[7]), .Y(n1394) );
  NAND2X1 I1276 ( .A(TMP2[4]), .B(ALU_SWAP_EN), .Y(n1393) );
  NAND2X1 I1277 ( .A(N294), .B(ALU_SUB_EN), .Y(n1395) );
  NOR2X1 I1278 ( .A(TMP1[0]), .B(TMP2[0]), .Y(n1401) );
  NAND2X1 I1279 ( .A(N235), .B(ALU_ADD_EN), .Y(n1386) );
  AOI21X1 I1280 ( .A0(ALU_CPL_EN), .A1(n718), .B0(n726), .Y(n1435) );
  OAI2BB1X1 I1281 ( .A0N(n841), .A1N(n1183), .B0(n1184), .Y(n844) );
  NAND3X1 I1282 ( .A(n1194), .B(n1195), .C(n1196), .Y(n1183) );
  NAND2X1 I1283 ( .A(n1399), .B(n1400), .Y(n1398) );
  NAND2X1 I1284 ( .A(ALU_RLC_EN), .B(n1520), .Y(n1400) );
  NAND2X1 I1285 ( .A(ALU_CPL_EN), .B(n729), .Y(n1399) );
  NAND2X1 I1286 ( .A(TMP2[6]), .B(ALU_SWAP_EN), .Y(n1371) );
  NAND2X1 I1287 ( .A(n1508), .B(ALU_SWAP_EN), .Y(n1384) );
  NAND2X1 I1288 ( .A(n1509), .B(ALU_SWAP_EN), .Y(n1422) );
  NAND2X1 I1289 ( .A(TMP2[0]), .B(ALU_SWAP_EN), .Y(n1474) );
  NAND2X1 I1290 ( .A(n1511), .B(ALU_SWAP_EN), .Y(n1430) );
  NOR2X1 I1291 ( .A(n1176), .B(n1177), .Y(n1175) );
  NAND3X1 I1292 ( .A(n1207), .B(n1208), .C(n1209), .Y(n1202) );
  AOI21X1 I1293 ( .A0(n1205), .A1(n1206), .B0(n1185), .Y(n1204) );
  NAND3X1 I1294 ( .A(n1223), .B(n1224), .C(n1225), .Y(n1216) );
  AOI21X1 I1295 ( .A0(n1219), .A1(n1220), .B0(n1185), .Y(n1218) );
  NAND3X1 I1296 ( .A(n1278), .B(n1279), .C(n1280), .Y(n1269) );
  AOI21X1 I1297 ( .A0(n1272), .A1(n1273), .B0(n1185), .Y(n1271) );
  NAND3X1 I1298 ( .A(n1258), .B(n1259), .C(n1260), .Y(n1249) );
  NAND3X1 I1299 ( .A(n1241), .B(n1242), .C(n1243), .Y(n1233) );
  NAND3X1 I1300 ( .A(n1301), .B(n1170), .C(n1302), .Y(n1296) );
  NOR2X1 I1301 ( .A(n1554), .B(n717), .Y(n1188) );
  NOR2X1 I1302 ( .A(n742), .B(n717), .Y(n1253) );
  NOR2X1 I1303 ( .A(n763), .B(n2600), .Y(n1187) );
  NOR2X1 I1304 ( .A(n1475), .B(n1079), .Y(n1189) );
  NOR2X1 I1305 ( .A(n763), .B(n352), .Y(n1236) );
  NOR2X1 I1306 ( .A(n1475), .B(n222), .Y(n1238) );
  NOR2X1 I1307 ( .A(n763), .B(n353), .Y(n1252) );
  NOR2X1 I1308 ( .A(n1475), .B(n1255), .Y(n1254) );
  AOI21X1 I1309 ( .A0(n1480), .A1(n1512), .B0(n905), .Y(n901) );
  NOR2X1 I1310 ( .A(n1554), .B(n632), .Y(n905) );
  XOR3X2 I1311 ( .A(n787), .B(n788), .C(n399), .Y(n398) );
  XOR2X1 I1312 ( .A(n728), .B(n789), .Y(n399) );
  XOR3X2 I1313 ( .A(ACC_IN_1_), .B(ACC_IN_0_), .C(n400), .Y(n397) );
  XOR2X1 I1314 ( .A(n401), .B(n790), .Y(n400) );
  AOI21X1 I1315 ( .A0(n489), .A1(IDATA[7]), .B0(n899), .Y(n488) );
  NAND3X1 I1316 ( .A(n900), .B(n901), .C(n902), .Y(n899) );
  NAND2X1 I1317 ( .A(TMP2[0]), .B(ALU_RR_EN), .Y(n1431) );
  INVX1 I1318 ( .A(TMP1[7]), .Y(N278) );
  INVX1 I1319 ( .A(TMP1[2]), .Y(N273) );
  INVX1 I1320 ( .A(TMP1[4]), .Y(N275) );
  INVX1 I1321 ( .A(n611), .Y(ACC_IN_1_) );
  NAND2BX1 I1322 ( .AN(n835), .B(n869), .Y(n611) );
  NAND4X1 I1323 ( .A(n870), .B(n871), .C(n872), .D(n873), .Y(n869) );
  AOI22X1 I1324 ( .A0(n1480), .A1(n1526), .B0(P0_IN[3]), .B1(n1515), .Y(n883)
         );
  INVX1 I1325 ( .A(C_1_EN), .Y(n940) );
  MX2X1 I1326 ( .S0(n344), .B(n815), .A(n814), .Y(n931) );
  MX2X1 I1327 ( .S0(n1512), .B(n369), .A(n933), .Y(n814) );
  MX2X1 I1328 ( .S0(n3160), .B(n743), .A(n375), .Y(n815) );
  AOI22X1 I1329 ( .A0(n1480), .A1(n1510), .B0(n1517), .B1(ACC[7]), .Y(n897) );
  NAND2X1 I1330 ( .A(N261), .B(ALU_ADC_EN), .Y(n1085) );
  NAND2X1 I1331 ( .A(N323), .B(ALU_SUBBC_EN), .Y(n1084) );
  NAND2X1 I1332 ( .A(TMP2[0]), .B(ALU_RRC_EN), .Y(n1087) );
  NAND2X1 I1333 ( .A(ALU_RLC_EN), .B(TMP2[7]), .Y(n1083) );
  OAI21X1 I1334 ( .A0(n834), .A1(n1179), .B0(n1180), .Y(B_REG_IN[7]) );
  AOI21X1 I1335 ( .A0(n755), .A1(IDATA[7]), .B0(n1181), .Y(n1179) );
  INVX1 I1336 ( .A(n1506), .Y(n1505) );
  NAND3X1 I1337 ( .A(TMP2[7]), .B(n855), .C(n314), .Y(n933) );
  NAND2X1 I1338 ( .A(P0_IN[5]), .B(n1515), .Y(n895) );
  NOR2BX1 I1339 ( .AN(N270), .B(n1090), .Y(n1089) );
  AOI21X1 I1340 ( .A0(n307), .A1(n816), .B0(n948), .Y(n947) );
  AND2X2 I1341 ( .A(n305), .B(n306), .Y(n816) );
  OAI21X1 I1342 ( .A0(n834), .A1(n1198), .B0(n1199), .Y(B_REG_IN[6]) );
  AOI21X1 I1343 ( .A0(n755), .A1(IDATA[6]), .B0(n1200), .Y(n1198) );
  OAI21X1 I1344 ( .A0(n834), .A1(n1212), .B0(n1213), .Y(B_REG_IN[5]) );
  AOI21X1 I1345 ( .A0(n755), .A1(IDATA[5]), .B0(n1214), .Y(n1212) );
  OAI21X1 I1346 ( .A0(n834), .A1(n1228), .B0(n1229), .Y(B_REG_IN[4]) );
  AOI21X1 I1347 ( .A0(n889), .A1(n807), .B0(n1230), .Y(n1229) );
  AOI21X1 I1348 ( .A0(n755), .A1(IDATA[4]), .B0(n1231), .Y(n1228) );
  OAI21X1 I1349 ( .A0(n120), .A1(n989), .B0(n990), .Y(n214) );
  NAND3X1 I1350 ( .A(n992), .B(n993), .C(n994), .Y(n991) );
  OAI21X1 I1351 ( .A0(n120), .A1(n859), .B0(n1044), .Y(n119) );
  NOR2X1 I1352 ( .A(n1045), .B(n737), .Y(n1044) );
  NAND4X1 I1353 ( .A(n1046), .B(n1047), .C(n1048), .D(n1049), .Y(n1045) );
  OAI21X1 I1354 ( .A0(n120), .A1(n958), .B0(n959), .Y(n280) );
  AOI21X1 I1355 ( .A0(n1482), .A1(n889), .B0(n960), .Y(n959) );
  OAI21X1 I1356 ( .A0(n834), .A1(n1265), .B0(n1266), .Y(B_REG_IN[2]) );
  AOI21X1 I1357 ( .A0(n755), .A1(IDATA[2]), .B0(n1267), .Y(n1265) );
  OAI21X1 I1358 ( .A0(n834), .A1(n1287), .B0(n1288), .Y(B_REG_IN[1]) );
  AOI21X1 I1359 ( .A0(n1490), .A1(n807), .B0(n1289), .Y(n1288) );
  OAI21X1 I1360 ( .A0(n1108), .A1(n958), .B0(n1109), .Y(SP_IN_1_) );
  AOI21X1 I1361 ( .A0(n1481), .A1(n1490), .B0(n1110), .Y(n1109) );
  NAND3BX1 I1362 ( .AN(n835), .B(n1111), .C(n1112), .Y(n1110) );
  NAND2X1 I1363 ( .A(n1488), .B(TMP1[1]), .Y(n1112) );
  NOR2X1 I1364 ( .A(n1505), .B(ID_PCH_EN), .Y(n1326) );
  AOI21X1 I1365 ( .A0(n1073), .A1(n1074), .B0(n835), .Y(TMP1_IN_7_) );
  AOI2BB1X1 I1366 ( .A0N(N278), .A1N(n976), .B0(n1080), .Y(n1073) );
  NAND3X1 I1367 ( .A(n1020), .B(n1021), .C(n1022), .Y(n150) );
  NAND2BX1 I1368 ( .AN(n1018), .B(n874), .Y(n1020) );
  INVX1 I1369 ( .A(n228), .Y(n988) );
  AOI22X1 I1370 ( .A0(n1517), .A1(n1494), .B0(n1495), .B1(n980), .Y(n987) );
  NAND3X1 I1371 ( .A(n846), .B(n847), .C(n848), .Y(n83) );
  NOR2X1 I1372 ( .A(n853), .B(n854), .Y(n847) );
  AND4X2 I1373 ( .A(n849), .B(n850), .C(n851), .D(n852), .Y(n848) );
  NAND2X1 I1374 ( .A(n1557), .B(n1480), .Y(n894) );
  NAND2X1 I1375 ( .A(n761), .B(TMP2[7]), .Y(n852) );
  AOI21X1 I1376 ( .A0(n1481), .A1(n1495), .B0(n956), .Y(n955) );
  OAI2BB1X1 I1377 ( .A0N(n860), .A1N(n861), .B0(n839), .Y(n628) );
  NAND2BX1 I1378 ( .AN(n862), .B(n863), .Y(n861) );
  INVX1 I1379 ( .A(n292), .Y(n1303) );
  NAND2X1 I1380 ( .A(n1005), .B(n1006), .Y(n185) );
  AND4X2 I1381 ( .A(n1007), .B(n1008), .C(n1009), .D(n1010), .Y(n1006) );
  NAND2BX1 I1382 ( .AN(n989), .B(IDATA[6]), .Y(n1005) );
  NAND2X1 I1383 ( .A(n177), .B(n1510), .Y(n1009) );
  NAND2X1 I1384 ( .A(n996), .B(n997), .Y(n201) );
  AND4X2 I1385 ( .A(n998), .B(n999), .C(n1000), .D(n1001), .Y(n997) );
  NAND2BX1 I1386 ( .AN(n989), .B(IDATA[5]), .Y(n996) );
  NAND2X1 I1387 ( .A(n177), .B(n1557), .Y(n1000) );
  NAND2X1 I1388 ( .A(n981), .B(n982), .Y(n233) );
  AND4X2 I1389 ( .A(n983), .B(n984), .C(n985), .D(n986), .Y(n982) );
  NAND2BX1 I1390 ( .AN(n797), .B(IDATA[2]), .Y(n981) );
  NAND2X1 I1391 ( .A(n177), .B(n1527), .Y(n986) );
  NAND2X1 I1392 ( .A(n1246), .B(n1247), .Y(B_REG_IN[3]) );
  AOI22X1 I1393 ( .A0(n1511), .A1(n1264), .B0(n885), .B1(n807), .Y(n1246) );
  OAI21X1 I1394 ( .A0(n1248), .A1(n804), .B0(n836), .Y(n1247) );
  INVX1 I1395 ( .A(n463), .Y(n1264) );
  NAND2X1 I1396 ( .A(n1062), .B(n1063), .Y(n101) );
  NOR2X1 I1397 ( .A(n1064), .B(n817), .Y(n1063) );
  NAND2BX1 I1398 ( .AN(n859), .B(IDATA[6]), .Y(n1062) );
  NAND4X1 I1399 ( .A(n1065), .B(n1066), .C(n1067), .D(n1068), .Y(n1064) );
  NAND2X1 I1400 ( .A(n1053), .B(n1054), .Y(n110) );
  NOR2X1 I1401 ( .A(n1055), .B(n818), .Y(n1054) );
  NAND2BX1 I1402 ( .AN(n859), .B(IDATA[5]), .Y(n1053) );
  NAND4X1 I1403 ( .A(n1056), .B(n1057), .C(n1058), .D(n1059), .Y(n1055) );
  NOR2X1 I1404 ( .A(n1037), .B(n819), .Y(n1036) );
  NAND4X1 I1405 ( .A(n1038), .B(n1039), .C(n1040), .D(n1041), .Y(n1037) );
  NAND2X1 I1406 ( .A(n1026), .B(n1027), .Y(n142) );
  NOR2X1 I1407 ( .A(n1028), .B(n820), .Y(n1027) );
  NAND2BX1 I1408 ( .AN(n1018), .B(IDATA[2]), .Y(n1026) );
  NAND4X1 I1409 ( .A(n1029), .B(n1030), .C(n1031), .D(n1032), .Y(n1028) );
  OAI21X1 I1410 ( .A0(n827), .A1(n934), .B0(n932), .Y(n338) );
  OAI2BB1X1 I1411 ( .A0N(n345), .A1N(n346), .B0(CY_AC_OV_UP), .Y(n337) );
  INVX1 I1412 ( .A(IDATA[6]), .Y(n102) );
  OR2X2 I1413 ( .A(n670), .B(A_IDATA_EN), .Y(n489) );
  AND3X2 I1414 ( .A(ID_WR_EN), .B(n425), .C(n1306), .Y(n670) );
  INVX1 I1415 ( .A(n401), .Y(ACC_IN_2_) );
  NAND4X1 I1416 ( .A(n1095), .B(n1096), .C(n1097), .D(n1098), .Y(n1094) );
  NAND2X1 I1417 ( .A(n177), .B(TMP1[0]), .Y(n1098) );
  AOI22X1 I1418 ( .A0(TMP1[4]), .A1(n1480), .B0(n1518), .B1(ACC[3]), .Y(n887)
         );
  NAND2X1 I1419 ( .A(N221), .B(CY_AC_OV_SUB_UP), .Y(n935) );
  NAND2X1 I1420 ( .A(N220), .B(CY_AC_OV_SUB_UP), .Y(n936) );
  OAI21X1 I1421 ( .A0(n1547), .A1(n1546), .B0(n1545), .Y(N221) );
  OAI22X1 I1422 ( .A0(n198), .A1(n2400), .B0(n833), .B1(n197), .Y(n2390) );
  INVX1 I1423 ( .A(n2360), .Y(n2400) );
  OR3X2 I1424 ( .A(n182), .B(n200), .C(n213), .Y(n223) );
  OR3X2 I1425 ( .A(n182), .B(n184), .C(n213), .Y(n212) );
  OR3X1 I1426 ( .A(n184), .B(n213), .C(n224), .Y(n245) );
  AOI21X1 I1427 ( .A0(n1517), .A1(n875), .B0(n2570), .Y(n1095) );
  OAI2BB1X1 I1428 ( .A0N(n178), .A1N(n2580), .B0(n2590), .Y(n2570) );
  DFFX1 PSW_reg_1_ ( .D(PSW_IN_1_), .CK(CLK), .Q(PSW_1_), .QN(n753) );
  NAND4X1 I1429 ( .A(n1013), .B(n1014), .C(n1015), .D(n1016), .Y(n160) );
  NOR2X1 I1430 ( .A(n1017), .B(T2_1_EN), .Y(n1015) );
  AOI2BB2X1 I1431 ( .A0N(n864), .A1N(n856), .B0(ACC[0]), .B1(n1019), .Y(n1013)
         );
  NAND2BX1 I1432 ( .AN(n1018), .B(n863), .Y(n1014) );
  AND2X2 I1433 ( .A(P0_IN[0]), .B(n1515), .Y(n821) );
  INVX1 I1434 ( .A(n1502), .Y(n1501) );
  NOR2BX1 I1435 ( .AN(n841), .B(n1142), .Y(MAR_IN[0]) );
  OAI21X1 I1436 ( .A0(n864), .A1(n912), .B0(n1144), .Y(n1143) );
  AOI21X1 I1437 ( .A0(n1491), .A1(n980), .B0(n208), .Y(n998) );
  OAI22X2 I1438 ( .A0(n830), .A1(n197), .B0(n198), .B1(n207), .Y(n208) );
  INVX1 I1439 ( .A(n212), .Y(n207) );
  AOI21X1 I1440 ( .A0(n1517), .A1(n1486), .B0(n1950), .Y(n1007) );
  OAI22X2 I1441 ( .A0(n830), .A1(n197), .B0(n198), .B1(n194), .Y(n1950) );
  INVX1 I1442 ( .A(n199), .Y(n194) );
  OAI21X1 I1443 ( .A0(n834), .A1(n1307), .B0(n1308), .Y(B_REG_IN[0]) );
  AOI21X1 I1444 ( .A0(n755), .A1(n863), .B0(n1310), .Y(n1307) );
  NOR2BX1 I1445 ( .AN(TMP2[0]), .B(n463), .Y(n1309) );
  NAND2X1 I1446 ( .A(P0_IN[1]), .B(n1515), .Y(n877) );
  OAI2BB1X1 I1447 ( .A0N(n1517), .A1N(n881), .B0(n978), .Y(n977) );
  NOR2X1 I1448 ( .A(n229), .B(n245), .Y(n979) );
  NAND2BX1 I1449 ( .AN(n2580), .B(n181), .Y(n1101) );
  NAND2X1 I1450 ( .A(n761), .B(TMP2[0]), .Y(n1016) );
  INVX2 I1451 ( .A(n1511), .Y(n1052) );
  NAND2X1 I1452 ( .A(P0R[6]), .B(n418), .Y(n1132) );
  INVX1 I1453 ( .A(n200), .Y(n184) );
  INVX1 I1454 ( .A(n213), .Y(n183) );
  OR3X1 I1455 ( .A(n200), .B(n213), .C(n224), .Y(n2580) );
  ADDFX2 I1456 ( .A(TMP2[3]), .B(n721), .CI(add_1_root_add_630_4_carry_3_), 
        .CO(N330) );
  ADDFX2 I1457 ( .A(TMP2[3]), .B(n1526), .CI(add_630_5_carry_3_), .CO(N329) );
  ADDFX2 I1458 ( .A(TMP2[2]), .B(n1527), .CI(add_630_5_carry_2_), .CO(
        add_630_5_carry_3_) );
  INVX1 I1459 ( .A(n421), .Y(n436) );
  NAND2X1 I1460 ( .A(IR20[0]), .B(n429), .Y(n1147) );
  INVX1 I1461 ( .A(n181), .Y(n229) );
  NAND2X1 I1462 ( .A(n1512), .B(MAR_T1_EN), .Y(n1124) );
  NAND2X1 I1463 ( .A(IR20[1]), .B(MAR_RN_EN), .Y(n1140) );
  NAND2X1 I1464 ( .A(n1510), .B(MAR_T1_EN), .Y(n1131) );
  NAND2X1 I1465 ( .A(MAR_RN_EN), .B(IR20[2]), .Y(n913) );
  NAND2X1 I1466 ( .A(n436), .B(P0R[4]), .Y(n1139) );
  DFFX1 PSW_reg_4_ ( .D(PSW_IN_4_), .CK(CLK), .Q(PSW_4_), .QN(n352) );
  DFFX1 PSW_reg_3_ ( .D(PSW_IN_3_), .CK(CLK), .Q(PSW_3_), .QN(n353) );
  DFFX1 PSW_reg_5_ ( .D(PSW_IN_5_), .CK(CLK), .QN(n350) );
  ADDFX2 I1467 ( .A(TMP2[2]), .B(n2370), .CI(add_1_root_add_630_4_carry_2_), 
        .CO(add_1_root_add_630_4_carry_3_) );
  OAI2BB1X1 I1468 ( .A0N(TMP2[1]), .A1N(n246), .B0(n1072), .Y(
        add_1_root_add_630_4_carry_2_) );
  OAI22X1 I1469 ( .A0(n1509), .A1(n246), .B0(N311), .B1(TMP2[0]), .Y(n1072) );
  ADDFX2 I1470 ( .A(n1509), .B(n1529), .CI(add_630_5_carry_1_), .CO(
        add_630_5_carry_2_) );
  INVX1 I1471 ( .A(n1071), .Y(add_630_5_carry_1_) );
  NOR2X1 I1472 ( .A(TMP1[2]), .B(n752), .Y(n1541) );
  NOR2X1 I1473 ( .A(n1529), .B(n1035), .Y(n1540) );
  NAND2X1 I1474 ( .A(n1549), .B(n1548), .Y(n1550) );
  NAND2X1 I1475 ( .A(n1529), .B(n1035), .Y(n1548) );
  NOR2X1 I1476 ( .A(TMP2[2]), .B(n2370), .Y(n1542) );
  NOR2X1 I1477 ( .A(n1541), .B(n1540), .Y(n1544) );
  INVX1 I1478 ( .A(n1520), .Y(n1093) );
  NAND2X1 I1479 ( .A(n1327), .B(n1328), .Y(n1325) );
  NOR2X1 I1480 ( .A(n1332), .B(n1333), .Y(n1327) );
  MXI2X1 I1481 ( .S0(MAR[4]), .B(n1330), .A(n1329), .Y(n1328) );
  NAND4X1 I1482 ( .A(n1286), .B(MDR[1]), .C(n1285), .D(n836), .Y(n1295) );
  AOI21X1 I1483 ( .A0(n1503), .A1(n1486), .B0(n741), .Y(n1196) );
  NAND2X1 I1484 ( .A(MDR[0]), .B(n1286), .Y(n1324) );
  NAND2X1 I1485 ( .A(MDR[7]), .B(n1478), .Y(n1195) );
  INVX1 I1486 ( .A(n727), .Y(n1305) );
  OR2X2 I1487 ( .A(n825), .B(n717), .Y(n1169) );
  AOI21X1 I1488 ( .A0(n1503), .A1(n1494), .B0(n1244), .Y(n1243) );
  NAND2X1 I1489 ( .A(PC[4]), .B(n1505), .Y(n1245) );
  AOI21X1 I1490 ( .A0(WM_EN), .A1(n858), .B0(n1210), .Y(n1209) );
  NAND2X1 I1491 ( .A(PC[6]), .B(ID_PCL_EN), .Y(n1211) );
  AOI21X1 I1492 ( .A0(n1503), .A1(n890), .B0(n1226), .Y(n1225) );
  NAND2X1 I1493 ( .A(PC[5]), .B(ID_PCL_EN), .Y(n1227) );
  AOI21X1 I1494 ( .A0(n1503), .A1(n885), .B0(n1261), .Y(n1260) );
  NAND2X1 I1495 ( .A(n1262), .B(n1263), .Y(n1261) );
  NAND2X1 I1496 ( .A(PC[3]), .B(n1505), .Y(n1263) );
  NAND2X1 I1497 ( .A(n1498), .B(n1511), .Y(n1262) );
  AOI21X1 I1498 ( .A0(n1503), .A1(n1492), .B0(n1281), .Y(n1280) );
  NAND2X1 I1499 ( .A(PC[2]), .B(n1505), .Y(n1282) );
  NAND3X1 I1500 ( .A(n878), .B(n879), .C(n880), .Y(n596) );
  AOI22X1 I1501 ( .A0(TMP1[2]), .A1(n1480), .B0(n1517), .B1(ACC[3]), .Y(n879)
         );
  AND2X2 I1502 ( .A(ACC[0]), .B(B_REG[1]), .Y(B2_REG[1]) );
  NAND2X1 I1503 ( .A(n1191), .B(n1192), .Y(n1186) );
  NAND2X1 I1504 ( .A(SP[7]), .B(n1193), .Y(n1192) );
  NAND2X1 I1505 ( .A(n1256), .B(n1257), .Y(n1251) );
  NAND2X1 I1506 ( .A(SP[3]), .B(n1193), .Y(n1257) );
  NAND2X1 I1507 ( .A(n1239), .B(n1240), .Y(n1235) );
  NAND2X1 I1508 ( .A(SP[4]), .B(n1193), .Y(n1240) );
  NAND2X1 I1509 ( .A(n1478), .B(MDR[4]), .Y(n1242) );
  NAND2X1 I1510 ( .A(MDR[6]), .B(n1478), .Y(n1208) );
  NAND2X1 I1511 ( .A(MDR[5]), .B(n1478), .Y(n1224) );
  NAND2X1 I1512 ( .A(MDR[3]), .B(n1478), .Y(n1259) );
  NAND2X1 I1513 ( .A(MDR[2]), .B(n1478), .Y(n1279) );
  AND2X2 I1514 ( .A(ACC[0]), .B(B_REG[2]), .Y(B2_REG[2]) );
  AND2X2 I1515 ( .A(ACC[0]), .B(B_REG[6]), .Y(B2_REG[6]) );
  AND2X2 I1516 ( .A(ACC[0]), .B(B_REG[5]), .Y(B2_REG[5]) );
  AND2X2 I1517 ( .A(ACC[0]), .B(B_REG[4]), .Y(B2_REG[4]) );
  AND2X2 I1518 ( .A(ACC[0]), .B(B_REG[3]), .Y(B2_REG[3]) );
  NAND3X1 I1519 ( .A(n886), .B(n887), .C(n888), .Y(n563) );
  NAND3X1 I1520 ( .A(n896), .B(n897), .C(n898), .Y(n525) );
  NAND3X1 I1521 ( .A(n882), .B(n883), .C(n884), .Y(n579) );
  AND2X2 I1522 ( .A(ACC[0]), .B(B_REG[7]), .Y(B2_REG[7]) );
  AND2X2 I1523 ( .A(B_REG[0]), .B(ACC[0]), .Y(B2_REG[0]) );
  INVX1 I1524 ( .A(n393), .Y(n395) );
  OR3X2 I1525 ( .A(B_T2RES_EN), .B(B_T1_EN), .C(n402), .Y(n393) );
  XOR2X1 I1526 ( .A(n397), .B(n398), .Y(n396) );
  OAI2BB1X1 I1527 ( .A0N(n1477), .A1N(n890), .B0(n891), .Y(n545) );
  INVX1 I1528 ( .A(SP[0]), .Y(n1334) );
  OAI22X1 I1529 ( .A0(n120), .A1(n845), .B0(n352), .B1(n351), .Y(PSW_IN_4_) );
  OAI22X1 I1530 ( .A0(n351), .A1(n753), .B0(n845), .B1(n1108), .Y(PSW_IN_1_)
         );
  AND2X2 I1531 ( .A(MAR[1]), .B(n791), .Y(n826) );
  NAND3X1 I1532 ( .A(n866), .B(n867), .C(n868), .Y(n865) );
  NAND2X1 I1533 ( .A(ACC[1]), .B(n1517), .Y(n867) );
  NOR2BX1 I1534 ( .AN(n857), .B(n821), .Y(n866) );
  AOI22X1 I1535 ( .A0(n1480), .A1(TMP1[0]), .B0(ACC[0]), .B1(n490), .Y(n868)
         );
  NOR2BX1 I1536 ( .AN(MAR[0]), .B(MAR[1]), .Y(n1335) );
  NOR2BX1 I1537 ( .AN(MAR[4]), .B(MAR[5]), .Y(n1336) );
  NAND4X1 I1538 ( .A(n969), .B(n970), .C(n971), .D(n972), .Y(n272) );
  NAND2X1 I1539 ( .A(n1487), .B(n1512), .Y(n969) );
  NAND2X1 I1540 ( .A(n808), .B(SP[7]), .Y(n970) );
  NAND2X1 I1541 ( .A(n1481), .B(n1485), .Y(n971) );
  NAND4X1 I1542 ( .A(n965), .B(n966), .C(n967), .D(n968), .Y(n276) );
  NAND2X1 I1543 ( .A(n1487), .B(n1510), .Y(n965) );
  NAND2X1 I1544 ( .A(SP[6]), .B(n808), .Y(n966) );
  NAND2X1 I1545 ( .A(n1482), .B(n858), .Y(n967) );
  NAND4X1 I1546 ( .A(n961), .B(n962), .C(n963), .D(n964), .Y(n2780) );
  NAND2X1 I1547 ( .A(n1488), .B(n1557), .Y(n961) );
  NAND2X1 I1548 ( .A(SP[5]), .B(n808), .Y(n962) );
  NAND2X1 I1549 ( .A(n1481), .B(n890), .Y(n963) );
  NAND4X1 I1550 ( .A(n1104), .B(n1105), .C(n1106), .D(n1107), .Y(SP_IN_2_) );
  AOI21X1 I1551 ( .A0(n1487), .A1(n1527), .B0(n835), .Y(n1105) );
  NAND2X1 I1552 ( .A(SP[2]), .B(n808), .Y(n1104) );
  NAND2X1 I1553 ( .A(n1482), .B(n881), .Y(n1106) );
  AOI21X1 I1554 ( .A0(n1477), .A1(n1486), .B0(n903), .Y(n902) );
  NAND2X1 I1555 ( .A(P0_IN[7]), .B(n1515), .Y(n904) );
  AND4X2 I1556 ( .A(n1337), .B(n730), .C(MAR[6]), .D(n792), .Y(n1331) );
  INVX1 I1557 ( .A(MAR[0]), .Y(n1337) );
  MXI2X1 I1558 ( .S0(C_ALLZ_B_AND_EN), .B(CY), .A(C_ALLZ_B_EN), .Y(n945) );
  NOR3X1 I1559 ( .A(MAR[4]), .B(MAR[6]), .C(MAR[5]), .Y(n1340) );
  OR2X2 I1560 ( .A(C_CB_EN), .B(CY_AC_OV_SUB_UP), .Y(n310) );
  AOI32X1 I1561 ( .A0(n3110), .A1(n313), .A2(n314), .B0(C_CB_EN), .B1(n2600), 
        .Y(n312) );
  NAND2X1 I1562 ( .A(n1316), .B(n1317), .Y(n1315) );
  NAND3BX1 I1563 ( .AN(n835), .B(PC[0]), .C(ID_PCL_EN), .Y(n1316) );
  NAND3BX1 I1564 ( .AN(n835), .B(PC[8]), .C(n1501), .Y(n1317) );
  NAND2X1 I1565 ( .A(n1299), .B(n1300), .Y(n1298) );
  NAND3BX1 I1566 ( .AN(n835), .B(PC[1]), .C(ID_PCL_EN), .Y(n1299) );
  NAND3BX1 I1567 ( .AN(n835), .B(PC[9]), .C(n1501), .Y(n1300) );
  NAND2X1 I1568 ( .A(ACC[6]), .B(n1517), .Y(n893) );
  NAND2X1 I1569 ( .A(ACC[4]), .B(n1518), .Y(n892) );
  MXI2X1 I1570 ( .S0(MAR[0]), .B(n1339), .A(n1338), .Y(n1332) );
  NAND2X1 I1571 ( .A(DPTR[8]), .B(n826), .Y(n1339) );
  NAND2X1 I1572 ( .A(DPTR[0]), .B(n826), .Y(n1338) );
  OAI221X4 I1573 ( .A0(n229), .A1(n230), .B0(n198), .B1(n231), .C0(n232), .Y(
        n228) );
  INVX1 I1574 ( .A(n230), .Y(n231) );
  OAI221X4 I1575 ( .A0(n803), .A1(n97), .B0(n404), .B1(n405), .C0(n837), .Y(
        MAR_IN[8]) );
  INVX1 I1576 ( .A(P0R[7]), .Y(n97) );
  NOR2X1 I1577 ( .A(n1033), .B(n1034), .Y(n1032) );
  NOR2BX1 I1578 ( .AN(SP[2]), .B(n96), .Y(n1034) );
  AOI21X1 I1579 ( .A0(n178), .A1(n223), .B0(n995), .Y(n994) );
  INVX1 I1580 ( .A(n2200), .Y(n995) );
  AOI21X1 I1581 ( .A0(n217), .A1(n181), .B0(n2210), .Y(n2200) );
  OAI22X1 I1582 ( .A0(n198), .A1(n249), .B0(n833), .B1(n197), .Y(n248) );
  INVX1 I1583 ( .A(n245), .Y(n249) );
  OAI22X1 I1584 ( .A0(n303), .A1(n3180), .B0(CY_CJNE_EN), .B1(n2600), .Y(n3170) );
  INVX1 I1585 ( .A(CY_CJNE_EN), .Y(n3180) );
  AOI22X1 I1586 ( .A0(MAR_MDR_EN), .A1(MDR[0]), .B0(MAR_P0R_EN), .B1(P0R[0]), 
        .Y(n460) );
  NAND2X1 I1587 ( .A(MDR[7]), .B(MAR_MDR_EN), .Y(n1122) );
  INVX1 I1588 ( .A(MAR_P0R_EN), .Y(n439) );
  NAND4X1 I1589 ( .A(n1113), .B(n1114), .C(n1115), .D(n1116), .Y(SP_IN_0_) );
  AOI21X1 I1590 ( .A0(n1487), .A1(TMP1[0]), .B0(n835), .Y(n1114) );
  NAND2X1 I1591 ( .A(n808), .B(SP[0]), .Y(n1113) );
  NOR2X1 I1592 ( .A(n457), .B(n1145), .Y(n1144) );
  NAND2X1 I1593 ( .A(n1146), .B(n1147), .Y(n1145) );
  OAI221X4 I1594 ( .A0(n1334), .A1(n411), .B0(N311), .B1(n412), .C0(n460), .Y(
        n457) );
  NAND2X1 I1595 ( .A(P0R[3]), .B(n436), .Y(n1146) );
  AOI21X1 I1596 ( .A0(n1476), .A1(n980), .B0(n1100), .Y(n1097) );
  NAND3X1 I1597 ( .A(n1101), .B(n1102), .C(n1103), .Y(n1100) );
  NAND2X1 I1598 ( .A(T1_P0R_EN), .B(P0R[0]), .Y(n1103) );
  NAND2X1 I1599 ( .A(B_REG[0]), .B(n1004), .Y(n1102) );
  AOI21X1 I1600 ( .A0(n1136), .A1(n1137), .B0(n834), .Y(MAR_IN[1]) );
  NAND2X1 I1601 ( .A(MAR[1]), .B(n911), .Y(n1136) );
  AOI21X1 I1602 ( .A0(MAR_RES_EN), .A1(n875), .B0(n1138), .Y(n1137) );
  NAND3X1 I1603 ( .A(n1139), .B(n1140), .C(n1141), .Y(n1138) );
  NAND2X1 I1604 ( .A(MAR[5]), .B(n911), .Y(n1135) );
  AOI21X1 I1605 ( .A0(MAR_RES_EN), .A1(n1491), .B0(n420), .Y(n1134) );
  AOI21X1 I1606 ( .A0(n1127), .A1(n1128), .B0(n834), .Y(MAR_IN[6]) );
  AOI21X1 I1607 ( .A0(MAR_RES_EN), .A1(n1493), .B0(n1129), .Y(n1128) );
  NAND4X1 I1608 ( .A(n1130), .B(n1131), .C(n1132), .D(n1133), .Y(n1129) );
  AOI21X1 I1609 ( .A0(n1118), .A1(n1119), .B0(n834), .Y(MAR_IN[7]) );
  NAND2X1 I1610 ( .A(MAR[7]), .B(n911), .Y(n1118) );
  NOR2X1 I1611 ( .A(n1120), .B(n1121), .Y(n1119) );
  NAND3X1 I1612 ( .A(n1123), .B(n1124), .C(n1125), .Y(n1120) );
  BUFX3 I1613 ( .A(n1568), .Y(n1509) );
  NAND3BX1 I1614 ( .AN(n1076), .B(n1077), .C(n1078), .Y(n1075) );
  NAND2X1 I1615 ( .A(P0R[7]), .B(T1_P0R_EN), .Y(n1078) );
  OAI22X1 I1616 ( .A0(n191), .A1(n1079), .B0(n192), .B1(n1554), .Y(n1076) );
  MXI2X1 I1617 ( .S0(n806), .B(n181), .A(n178), .Y(n1077) );
  NAND2X1 I1618 ( .A(B_T1_EN), .B(TMP1[0]), .Y(n1311) );
  NOR2X1 I1619 ( .A(n1042), .B(n1043), .Y(n1041) );
  NOR2BX1 I1620 ( .AN(SP[3]), .B(n96), .Y(n1043) );
  NAND2X1 I1621 ( .A(P0R[7]), .B(n1126), .Y(n1125) );
  INVX1 I1622 ( .A(n803), .Y(n1126) );
  NAND2X1 I1623 ( .A(B_T1_EN), .B(n1529), .Y(n1291) );
  NAND2X1 I1624 ( .A(B_T1_EN), .B(TMP1[4]), .Y(n1232) );
  OAI2BB1X1 I1625 ( .A0N(P0R[3]), .A1N(n418), .B0(n438), .Y(n437) );
  NAND2X1 I1626 ( .A(B_T1_EN), .B(TMP1[2]), .Y(n1268) );
  NAND2X1 I1627 ( .A(B_T1_EN), .B(n1557), .Y(n1215) );
  NAND2X1 I1628 ( .A(B_T1_EN), .B(n1512), .Y(n1182) );
  NAND2X1 I1629 ( .A(B_T1_EN), .B(n1510), .Y(n1201) );
  AOI2BB1X1 I1630 ( .A0N(n189), .A1N(n117), .B0(n1002), .Y(n1001) );
  OAI21X1 I1631 ( .A0(n229), .A1(n212), .B0(n1003), .Y(n1002) );
  AOI22X1 I1632 ( .A0(B_REG[5]), .A1(n1004), .B0(ACC[5]), .B1(T1_XCHD_MDR_EN), 
        .Y(n1003) );
  OAI21X1 I1633 ( .A0(n229), .A1(n199), .B0(n1012), .Y(n1011) );
  AOI22X1 I1634 ( .A0(B_REG[6]), .A1(n1004), .B0(ACC[6]), .B1(T1_XCHD_MDR_EN), 
        .Y(n1012) );
  INVX1 I1635 ( .A(MDR[4]), .Y(n431) );
  NAND2X1 I1636 ( .A(ACC[2]), .B(n1019), .Y(n1029) );
  AND2X2 I1637 ( .A(PSW_6_), .B(n344), .Y(n827) );
  INVX1 I1638 ( .A(n444), .Y(n914) );
  OAI221X4 I1639 ( .A0(n1276), .A1(n411), .B0(n2370), .B1(n412), .C0(n446), 
        .Y(n444) );
  AOI22X1 I1640 ( .A0(MAR_MDR_EN), .A1(MDR[2]), .B0(MAR_P0R_EN), .B1(P0R[2]), 
        .Y(n446) );
  AND2X2 I1641 ( .A(n432), .B(n839), .Y(MAR_IN[3]) );
  NOR2X1 I1642 ( .A(n437), .B(n917), .Y(n915) );
  AND2X2 I1643 ( .A(n440), .B(n840), .Y(MAR_IN[2]) );
  NAND3X1 I1644 ( .A(n908), .B(n909), .C(n910), .Y(n440) );
  NAND2X1 I1645 ( .A(MAR[2]), .B(n911), .Y(n910) );
  AND2X2 I1646 ( .A(n424), .B(n838), .Y(MAR_IN[4]) );
  NOR2X1 I1647 ( .A(n430), .B(n922), .Y(n920) );
  INVX1 I1648 ( .A(n165), .Y(n1017) );
  OR2X2 I1649 ( .A(T1_SBP_EN), .B(n828), .Y(n181) );
  AND2X2 I1650 ( .A(T1_BITCP_EN), .B(CY), .Y(n828) );
  OAI21X1 I1651 ( .A0(n98), .A1(n117), .B0(n1061), .Y(n1060) );
  NAND2X1 I1652 ( .A(ACC[5]), .B(T2_A_EN), .Y(n1061) );
  OAI21X1 I1653 ( .A0(n98), .A1(n126), .B0(n1051), .Y(n1050) );
  NAND2X1 I1654 ( .A(ACC[4]), .B(T2_A_EN), .Y(n1051) );
  NAND2BX1 I1655 ( .AN(P0R[7]), .B(MAR_BAR_EN), .Y(n421) );
  NAND2X1 I1656 ( .A(n808), .B(SP[3]), .Y(n957) );
  AOI2BB1X1 I1657 ( .A0N(n96), .A1N(n744), .B0(n1069), .Y(n1068) );
  NAND2X1 I1658 ( .A(ACC[6]), .B(T2_A_EN), .Y(n1070) );
  NAND2X1 I1659 ( .A(n918), .B(n919), .Y(n917) );
  NAND2X1 I1660 ( .A(P0R[6]), .B(n436), .Y(n919) );
  NAND2X1 I1661 ( .A(n429), .B(PSW_3_), .Y(n918) );
  NAND2X1 I1662 ( .A(n808), .B(SP[1]), .Y(n1111) );
  NAND2X1 I1663 ( .A(SP[7]), .B(MAR_SP_EN), .Y(n1123) );
  NAND2X1 I1664 ( .A(P0R[7]), .B(T2_P0R_EN), .Y(n850) );
  NAND2X1 I1665 ( .A(P0R[3]), .B(T2_P0R_EN), .Y(n1040) );
  NAND2X1 I1666 ( .A(MDR[6]), .B(MAR_MDR_EN), .Y(n1133) );
  NAND2X1 I1667 ( .A(SP[6]), .B(MAR_SP_EN), .Y(n1130) );
  OR2X2 I1668 ( .A(n829), .B(n96), .Y(n851) );
  INVX1 I1669 ( .A(n450), .Y(n1141) );
  OAI221X4 I1670 ( .A0(n451), .A1(n411), .B0(n246), .B1(n412), .C0(n452), .Y(
        n450) );
  INVX1 I1671 ( .A(SP[1]), .Y(n451) );
  AOI22X1 I1672 ( .A0(MAR_MDR_EN), .A1(MDR[1]), .B0(MAR_P0R_EN), .B1(P0R[1]), 
        .Y(n452) );
  NAND2X1 I1673 ( .A(PC[12]), .B(n1501), .Y(n1241) );
  NAND2X1 I1674 ( .A(PC[13]), .B(n1501), .Y(n1223) );
  NAND2X1 I1675 ( .A(PC[10]), .B(n1501), .Y(n1278) );
  NAND2X1 I1676 ( .A(PC[14]), .B(ID_PCH_EN), .Y(n1207) );
  NAND2X1 I1677 ( .A(PC[11]), .B(ID_PCH_EN), .Y(n1258) );
  INVX1 I1678 ( .A(ACC[4]), .Y(n127) );
  INVX1 I1679 ( .A(SP[2]), .Y(n1276) );
  INVX1 I1680 ( .A(B_REG[2]), .Y(n1277) );
  INVX1 I1681 ( .A(B_REG[3]), .Y(n1255) );
  INVX1 I1682 ( .A(DPTR[5]), .Y(n1221) );
  INVX1 I1683 ( .A(DPTR[13]), .Y(n1222) );
  INVX1 I1684 ( .A(DPTR[2]), .Y(n1274) );
  INVX1 I1685 ( .A(DPTR[10]), .Y(n1275) );
  AND3X2 I1686 ( .A(n831), .B(n2600), .C(n832), .Y(n830) );
  NAND3X1 I1687 ( .A(N195), .B(ACC[4]), .C(n211), .Y(n832) );
  NOR2X1 I1688 ( .A(N195), .B(PSW_6_), .Y(n833) );
  DFFTRX2 TMP2_reg_6_ ( .D(n101), .CK(CLK), .RN(n841), .Q(n1563), .QN(n719) );
  DFFTRX2 TMP2_reg_5_ ( .D(n110), .CK(CLK), .RN(n841), .Q(n1564), .QN(n733) );
  DFFTRX2 TMP2_reg_4_ ( .D(n119), .CK(CLK), .RN(n841), .Q(n1565), .QN(n734) );
  DFFTRX2 TMP2_reg_7_ ( .D(n83), .CK(CLK), .RN(n843), .Q(n1562), .QN(n718) );
  EDFFTRX2 F5_reg ( .D(ALLZ), .CK(CLK), .E(F5_ALLZ_EN), .RN(n843), .Q(F5) );
  NAND3X1 I1689 ( .A(N263), .B(n1517), .C(n1519), .Y(n1160) );
  NOR2X1 I1690 ( .A(n1152), .B(n1294), .Y(n1293) );
  NOR2X1 I1691 ( .A(n1283), .B(n1295), .Y(n1152) );
  NAND3X1 I1692 ( .A(n1325), .B(n1164), .C(n1499), .Y(n1172) );
  AOI21X1 I1693 ( .A0(T1_MDR_EN), .A1(IDATA[7]), .B0(n1075), .Y(n1074) );
  NOR2X1 I1694 ( .A(n1283), .B(n1284), .Y(n1197) );
  NAND3X1 I1695 ( .A(SP[1]), .B(n1303), .C(n1499), .Y(n1165) );
  MXI2X4 I1696 ( .S0(TMP2[1]), .B(n1354), .A(ALU_CPL_EN), .Y(n1157) );
  OAI22X4 I1697 ( .A0(n1363), .A1(n1052), .B0(n1364), .B1(n1035), .Y(n1362) );
  OAI22X4 I1698 ( .A0(n1363), .A1(n718), .B0(n1364), .B1(n733), .Y(n1376) );
  OAI22X4 I1699 ( .A0(n1363), .A1(n719), .B0(n1364), .B1(n734), .Y(n1413) );
  MXI2X4 I1700 ( .S0(TMP2[5]), .B(n1415), .A(ALU_CPL_EN), .Y(n1407) );
  AOI22X4 I1701 ( .A0(n1511), .A1(n798), .B0(n1456), .B1(n1457), .Y(n1455) );
  OAI22X4 I1702 ( .A0(n1363), .A1(n733), .B0(n1364), .B1(n1052), .Y(n1465) );
  INVX4 I1703 ( .A(n1352), .Y(n1364) );
  INVX4 I1704 ( .A(n1353), .Y(n1363) );
  MXI2X4 I1705 ( .S0(TMP2[4]), .B(n1468), .A(ALU_CPL_EN), .Y(n1459) );
  NAND2BX4 I1706 ( .AN(ALU_ORL_EN), .B(n1470), .Y(n1347) );
  OR2X1 I1707 ( .A(T2_MDR_EN), .B(T2_XCHD_A_EN), .Y(n128) );
  OR4X1 I1708 ( .A(T2_1_EN), .B(T2_0_EN), .C(DIV_OP_EN), .D(n128), .Y(n170) );
  OR3X1 I1709 ( .A(MUL_OP_EN), .B(DIV_OP_EN), .C(n402), .Y(n632) );
  EX_UNIT_DW01_add_5_0 add_1_root_add_630_2 ( .A({1'b0, TMP2[3:0]}), .B({1'b0, 
        n1526, TMP1[2], n1529, TMP1[0]}), .CI(CY), .SUM({N293, 
        SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3}) );
  EX_UNIT_DW01_cmp2_8_1 lte_618 ( .A(TMP2), .B(TMP1), .LEQ(1'b1), .TC(1'b0), 
        .LT_LE(N218) );
  EX_UNIT_DW01_cmp2_8_0 r207 ( .A({TMP2[7:2], n1509, TMP2[0]}), .B({TMP1[7:3], 
        n1527, TMP1[1], n1530}), .LEQ(1'b0), .TC(1'b0), .LT_LE(T1_GT_T2) );
  EX_UNIT_DW01_add_9_4 add_640_7 ( .A({1'b0, TMP2[7:2], n1509, TMP2[0]}), .B({
        1'b0, TMP1[7:3], n1527, n1529, n1530}), .CI(1'b0), .SUM({N243, N242, 
        N241, N240, N239, N238, N237, N236, N235}) );
  EX_UNIT_DW01_add_9_3 add_640_6 ( .A({1'b0, B2_REG}), .B({1'b0, TMP1[7:4], 
        n1526, n1527, n1529, TMP1[0]}), .CI(1'b0), .SUM({N270, N269, N268, 
        N267, N266, N265, N264, N263, N262}) );
  EX_UNIT_DW01_add_9_2 add_640_5 ( .A({1'b0, TMP2[7:2], n1509, TMP2[0]}), .B({
        1'b0, TMP1_SUB}), .CI(1'b0), .SUM({N323, N322, N321, N320, N319, N318, 
        N317, N316, N315}) );
  EX_UNIT_DW01_sub_8_1 sub_1_root_add_638_2 ( .A({n1520, n1520, n1520, n1520, 
        n1520, n1520, n1520, n1520}), .B({TMP1[7:3], n1527, TMP1[1:0]}), .CI(
        1'b0), .DIFF(TMP1_SUB) );
  EX_UNIT_DW01_add_9_1 add_1_root_add_640_4 ( .A({1'b0, TMP2}), .B({1'b0, N278, 
        n735, n736, N275, N274, N273, n246, N311}), .CI(1'b1), .SUM({N302, 
        N301, N300, N299, N298, N297, N296, N295, N294}) );
  EX_UNIT_DW01_add_9_0 add_1_root_add_640_2 ( .A({1'b0, TMP2}), .B({1'b0, 
        TMP1[7:4], n1526, TMP1[2], n1529, n1530}), .CI(n1520), .SUM({N261, 
        N260, N259, N258, N257, N256, N255, N254, N253}) );
endmodule


module EX_UNIT_DW01_add_9_0 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_;

  CMPR32X1 U1_0 ( .A(A[0]), .B(B[0]), .C(CI), .S(SUM[0]), .CO(carry_1_) );
  ADDFX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry_7_), .S(SUM[7]), .CO(SUM[8]) );
  ADDFX2 U1_1 ( .A(A[1]), .B(B[1]), .CI(carry_1_), .S(SUM[1]), .CO(carry_2_)
         );
  ADDFX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .S(SUM[2]), .CO(carry_3_)
         );
  ADDFX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .S(SUM[3]), .CO(carry_4_)
         );
  ADDFX2 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry_6_), .S(SUM[6]), .CO(carry_7_)
         );
  ADDFX2 U1_5 ( .A(A[5]), .B(B[5]), .CI(carry_5_), .S(SUM[5]), .CO(carry_6_)
         );
  ADDFX2 U1_4 ( .A(A[4]), .B(B[4]), .CI(carry_4_), .S(SUM[4]), .CO(carry_5_)
         );
endmodule


module EX_UNIT_DW01_add_9_1 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_;

  ADDFX2 U1_1 ( .A(A[1]), .B(B[1]), .CI(carry_1_), .S(SUM[1]), .CO(carry_2_)
         );
  ADDFX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry_7_), .S(SUM[7]), .CO(SUM[8]) );
  ADDFX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .S(SUM[2]), .CO(carry_3_)
         );
  ADDFX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .S(SUM[3]), .CO(carry_4_)
         );
  ADDFX2 U1_4 ( .A(A[4]), .B(B[4]), .CI(carry_4_), .S(SUM[4]), .CO(carry_5_)
         );
  ADDFX2 U1_5 ( .A(A[5]), .B(B[5]), .CI(carry_5_), .S(SUM[5]), .CO(carry_6_)
         );
  ADDFX2 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry_6_), .S(SUM[6]), .CO(carry_7_)
         );
  OR2X1 U4 ( .A(B[0]), .B(A[0]), .Y(carry_1_) );
  XNOR2X1 U5 ( .A(A[0]), .B(B[0]), .Y(SUM[0]) );
endmodule


module EX_UNIT_DW01_sub_8_1 ( A, B, CI, DIFF, CO );
  input [7:0] A;
  input [7:0] B;
  output [7:0] DIFF;
  input CI;
  output CO;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_,
         B_not_6_, B_not_5_, B_not_4_, B_not_3_, B_not_2_, B_not_1_, B_not_0_;

  CMPR32X1 U2_5 ( .A(A[5]), .B(B_not_5_), .C(carry_5_), .S(DIFF[5]), .CO(
        carry_6_) );
  CMPR32X1 U2_2 ( .A(A[2]), .B(B_not_2_), .C(carry_2_), .S(DIFF[2]), .CO(
        carry_3_) );
  CMPR32X1 U2_4 ( .A(A[4]), .B(B_not_4_), .C(carry_4_), .S(DIFF[4]), .CO(
        carry_5_) );
  CMPR32X1 U2_1 ( .A(A[1]), .B(B_not_1_), .C(carry_1_), .S(DIFF[1]), .CO(
        carry_2_) );
  CMPR32X1 U2_3 ( .A(A[3]), .B(B_not_3_), .C(carry_3_), .S(DIFF[3]), .CO(
        carry_4_) );
  XNOR3X2 U6 ( .A(A[7]), .B(B[7]), .C(carry_7_), .Y(DIFF[7]) );
  INVX1 U7 ( .A(B[2]), .Y(B_not_2_) );
  INVX1 U8 ( .A(B[5]), .Y(B_not_5_) );
  ADDFX2 U2_6 ( .A(A[6]), .B(B_not_6_), .CI(carry_6_), .S(DIFF[6]), .CO(
        carry_7_) );
  INVX1 U9 ( .A(B[6]), .Y(B_not_6_) );
  INVX1 U10 ( .A(B[1]), .Y(B_not_1_) );
  INVX1 U11 ( .A(B[3]), .Y(B_not_3_) );
  INVX1 U12 ( .A(B[4]), .Y(B_not_4_) );
  INVX1 U13 ( .A(B[0]), .Y(B_not_0_) );
  OR2X1 U14 ( .A(B_not_0_), .B(A[0]), .Y(carry_1_) );
  XNOR2X1 U15 ( .A(A[0]), .B(B_not_0_), .Y(DIFF[0]) );
endmodule


module EX_UNIT_DW01_add_9_2 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_;

  ADDFX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .S(SUM[3]), .CO(carry_4_)
         );
  CMPR32X1 U1_6 ( .A(A[6]), .B(B[6]), .C(carry_6_), .S(SUM[6]), .CO(carry_7_)
         );
  CMPR32X1 U1_5 ( .A(A[5]), .B(B[5]), .C(carry_5_), .S(SUM[5]), .CO(carry_6_)
         );
  CMPR32X1 U1_4 ( .A(A[4]), .B(B[4]), .C(carry_4_), .S(SUM[4]), .CO(carry_5_)
         );
  CMPR32X1 U1_1 ( .A(A[1]), .B(B[1]), .C(carry_1_), .S(SUM[1]), .CO(carry_2_)
         );
  ADDFX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry_7_), .S(SUM[7]), .CO(SUM[8]) );
  ADDFX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .S(SUM[2]), .CO(carry_3_)
         );
  AND2X1 U4 ( .A(A[0]), .B(B[0]), .Y(carry_1_) );
  XOR2X1 U5 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module EX_UNIT_DW01_add_9_3 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_;

  ADDFX2 U1_1 ( .A(A[1]), .B(B[1]), .CI(carry_1_), .S(SUM[1]), .CO(carry_2_)
         );
  ADDFX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .S(SUM[2]), .CO(carry_3_)
         );
  ADDFX2 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry_6_), .S(SUM[6]), .CO(carry_7_)
         );
  ADDFX2 U1_5 ( .A(A[5]), .B(B[5]), .CI(carry_5_), .S(SUM[5]), .CO(carry_6_)
         );
  ADDFX2 U1_4 ( .A(A[4]), .B(B[4]), .CI(carry_4_), .S(SUM[4]), .CO(carry_5_)
         );
  ADDFX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .S(SUM[3]), .CO(carry_4_)
         );
  ADDFX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry_7_), .S(SUM[7]), .CO(SUM[8]) );
  AND2X1 U4 ( .A(A[0]), .B(B[0]), .Y(carry_1_) );
  XOR2X1 U5 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module EX_UNIT_DW01_add_9_4 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_;

  ADDFX2 U1_1 ( .A(A[1]), .B(B[1]), .CI(carry_1_), .S(SUM[1]), .CO(carry_2_)
         );
  ADDFX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .S(SUM[2]), .CO(carry_3_)
         );
  ADDFX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .S(SUM[3]), .CO(carry_4_)
         );
  ADDFX2 U1_4 ( .A(A[4]), .B(B[4]), .CI(carry_4_), .S(SUM[4]), .CO(carry_5_)
         );
  ADDFX2 U1_5 ( .A(A[5]), .B(B[5]), .CI(carry_5_), .S(SUM[5]), .CO(carry_6_)
         );
  ADDFX2 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry_6_), .S(SUM[6]), .CO(carry_7_)
         );
  ADDFX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry_7_), .S(SUM[7]), .CO(SUM[8]) );
  AND2X1 U4 ( .A(A[0]), .B(B[0]), .Y(carry_1_) );
  XOR2X1 U5 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module EX_UNIT_DW01_cmp2_8_0 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47;

  AOI21X1 U6 ( .A0(n32), .A1(n33), .B0(n34), .Y(n23) );
  OAI21X1 U7 ( .A0(A[1]), .A1(n38), .B0(n39), .Y(n33) );
  OAI21X1 U8 ( .A0(n23), .A1(n24), .B0(n25), .Y(n20) );
  NOR2X1 U9 ( .A(n26), .B(n27), .Y(n25) );
  OAI21X1 U10 ( .A0(A[3]), .A1(n35), .B0(n36), .Y(n34) );
  NOR2X1 U11 ( .A(n41), .B(n42), .Y(n32) );
  INVX1 U12 ( .A(A[2]), .Y(n37) );
  NOR2X1 U13 ( .A(n44), .B(n45), .Y(n19) );
  NOR2X1 U14 ( .A(A[6]), .B(n22), .Y(n21) );
  NOR2X1 U15 ( .A(A[5]), .B(n28), .Y(n27) );
  NOR2X1 U16 ( .A(A[4]), .B(n29), .Y(n26) );
  INVX1 U17 ( .A(A[7]), .Y(n18) );
  INVX1 U18 ( .A(B[4]), .Y(n29) );
  NAND2X1 U19 ( .A(B[7]), .B(n18), .Y(n17) );
  NOR2X2 U20 ( .A(B[7]), .B(n18), .Y(n15) );
  AOI21X2 U21 ( .A0(n19), .A1(n20), .B0(n21), .Y(n16) );
  INVX1 U22 ( .A(B[3]), .Y(n35) );
  NAND2X1 U23 ( .A(B[2]), .B(n37), .Y(n36) );
  NOR2X1 U24 ( .A(B[5]), .B(n46), .Y(n45) );
  NOR2X1 U25 ( .A(B[6]), .B(n47), .Y(n44) );
  INVX1 U26 ( .A(A[5]), .Y(n46) );
  NOR2X1 U27 ( .A(B[2]), .B(n37), .Y(n41) );
  NOR2X1 U28 ( .A(B[1]), .B(n43), .Y(n42) );
  INVX1 U29 ( .A(A[1]), .Y(n43) );
  INVX1 U30 ( .A(B[5]), .Y(n28) );
  INVX1 U31 ( .A(B[6]), .Y(n22) );
  NAND2X1 U32 ( .A(A[4]), .B(n29), .Y(n31) );
  INVX1 U33 ( .A(B[1]), .Y(n38) );
  NAND2X1 U34 ( .A(B[0]), .B(n40), .Y(n39) );
  INVX1 U35 ( .A(A[0]), .Y(n40) );
  INVX1 U36 ( .A(A[3]), .Y(n30) );
  INVX1 U37 ( .A(A[6]), .Y(n47) );
  OAI21X4 U38 ( .A0(n15), .A1(n16), .B0(n17), .Y(LT_LE) );
  OAI21X4 U39 ( .A0(B[3]), .A1(n30), .B0(n31), .Y(n24) );
endmodule


module EX_UNIT_DW01_cmp2_8_1 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45;

  OAI21X1 U6 ( .A0(n30), .A1(n31), .B0(n32), .Y(n25) );
  NOR2X1 U7 ( .A(n33), .B(n34), .Y(n32) );
  NOR2X1 U8 ( .A(n39), .B(n40), .Y(n30) );
  OAI21X1 U9 ( .A0(B[1]), .A1(n37), .B0(n38), .Y(n31) );
  OAI21X1 U10 ( .A0(A[7]), .A1(n15), .B0(n16), .Y(LT_LE) );
  OAI21X1 U11 ( .A0(A[5]), .A1(n27), .B0(n28), .Y(n26) );
  NOR2X1 U12 ( .A(A[3]), .B(n35), .Y(n34) );
  NOR2X1 U13 ( .A(A[1]), .B(n42), .Y(n39) );
  NOR2X1 U14 ( .A(A[2]), .B(n36), .Y(n33) );
  NOR2X1 U15 ( .A(n43), .B(n44), .Y(n24) );
  INVX1 U16 ( .A(B[7]), .Y(n15) );
  INVX1 U17 ( .A(B[2]), .Y(n36) );
  INVX1 U18 ( .A(B[6]), .Y(n21) );
  INVX1 U19 ( .A(A[4]), .Y(n29) );
  OAI22X1 U20 ( .A0(n19), .A1(n20), .B0(A[6]), .B1(n21), .Y(n17) );
  OAI21X1 U21 ( .A0(B[5]), .A1(n22), .B0(n23), .Y(n20) );
  AOI21X1 U22 ( .A0(n24), .A1(n25), .B0(n26), .Y(n19) );
  NAND2X1 U23 ( .A(A[6]), .B(n21), .Y(n23) );
  NAND2X1 U24 ( .A(n17), .B(n18), .Y(n16) );
  NAND2X1 U25 ( .A(A[7]), .B(n15), .Y(n18) );
  INVX1 U26 ( .A(B[5]), .Y(n27) );
  NAND2X1 U27 ( .A(B[4]), .B(n29), .Y(n28) );
  INVX1 U28 ( .A(B[1]), .Y(n42) );
  NOR2X1 U29 ( .A(B[4]), .B(n29), .Y(n43) );
  NOR2X1 U30 ( .A(B[3]), .B(n45), .Y(n44) );
  INVX1 U31 ( .A(A[3]), .Y(n45) );
  INVX1 U32 ( .A(B[3]), .Y(n35) );
  NAND2X1 U33 ( .A(A[0]), .B(n41), .Y(n40) );
  INVX1 U34 ( .A(B[0]), .Y(n41) );
  NAND2X1 U35 ( .A(A[2]), .B(n36), .Y(n38) );
  INVX1 U36 ( .A(A[5]), .Y(n22) );
  INVX1 U37 ( .A(A[1]), .Y(n37) );
endmodule


module EX_UNIT_DW01_add_5_0 ( A, B, CI, SUM, CO );
  input [4:0] A;
  input [4:0] B;
  output [4:0] SUM;
  input CI;
  output CO;
  wire   carry_3_, carry_2_, carry_1_;

  ADDFX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .CO(SUM[4]) );
  ADDFX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .CO(carry_3_) );
  ADDFX2 U1_1 ( .A(A[1]), .B(B[1]), .CI(carry_1_), .CO(carry_2_) );
  ADDFX2 U1_0 ( .A(A[0]), .B(B[0]), .CI(CI), .CO(carry_1_) );
endmodule


module IR_REG ( pre_pdwn_idle, inter_LCALL, POR, CLK, RESET, IR_EN, MOVX_INS, 
        MOVC_INS, LS4, CS3, CS2, ID, P0R, P0R_PRE_IR, IR );
  input [7:0] ID;
  input [7:0] P0R;
  output [7:0] IR;
  input pre_pdwn_idle, inter_LCALL, POR, CLK, RESET, IR_EN, MOVX_INS, MOVC_INS,
         LS4, CS3, CS2;
  output P0R_PRE_IR;
  wire   n47, n2, n3, n7, n8, n9, n10, n11, n12, n13, n16, n17, n21, n23, n24,
         n25, n26, n27, n28, n29, n30, n31, n33, n36, n40, n41, n42, n43, n44,
         n45;

  AOI33X4 U4 ( .A0(LS4), .A1(CS2), .A2(MOVC_INS), .B0(CS3), .B1(LS4), .B2(
        MOVX_INS), .Y(n2) );
  AOI222X4 U6 ( .A0(ID[7]), .A1(n43), .B0(IR[7]), .B1(n44), .C0(P0R[7]), .C1(
        n40), .Y(n3) );
  AOI222X4 U8 ( .A0(ID[6]), .A1(n43), .B0(n47), .B1(n44), .C0(P0R[6]), .C1(n40), .Y(n7) );
  AOI222X4 U10 ( .A0(ID[5]), .A1(n43), .B0(IR[5]), .B1(n44), .C0(P0R[5]), .C1(
        n40), .Y(n8) );
  AOI221X4 U12 ( .A0(P0R[4]), .A1(n40), .B0(IR[4]), .B1(n44), .C0(inter_LCALL), 
        .Y(n9) );
  AOI222X4 U14 ( .A0(ID[3]), .A1(n43), .B0(IR[3]), .B1(n44), .C0(P0R[3]), .C1(
        n40), .Y(n10) );
  AOI222X4 U16 ( .A0(ID[2]), .A1(n43), .B0(IR[2]), .B1(n44), .C0(P0R[2]), .C1(
        n40), .Y(n11) );
  AOI221X4 U18 ( .A0(P0R[1]), .A1(n40), .B0(IR[1]), .B1(n44), .C0(inter_LCALL), 
        .Y(n12) );
  AOI222X4 U20 ( .A0(ID[0]), .A1(n43), .B0(IR[0]), .B1(n44), .C0(P0R[0]), .C1(
        n40), .Y(n13) );
  NOR3BX1 I42 ( .AN(n45), .B(inter_LCALL), .C(n11), .Y(n25) );
  NOR3X1 I43 ( .A(RESET), .B(inter_LCALL), .C(n13), .Y(n23) );
  NOR3BX1 I44 ( .AN(n45), .B(inter_LCALL), .C(n10), .Y(n26) );
  NOR3BX1 I45 ( .AN(n45), .B(inter_LCALL), .C(n8), .Y(n28) );
  NOR3BX1 I46 ( .AN(n45), .B(inter_LCALL), .C(n3), .Y(n30) );
  NOR3X1 I47 ( .A(RESET), .B(inter_LCALL), .C(n7), .Y(n29) );
  AND3X2 I48 ( .A(n42), .B(n17), .C(n41), .Y(n40) );
  DFFRX2 IR_reg_2_ ( .D(n25), .CK(CLK), .RN(n21), .Q(IR[2]) );
  BUFX8 I49 ( .A(n47), .Y(IR[6]) );
  DFFRX1 IR_reg_0_ ( .D(n23), .CK(CLK), .RN(n21), .Q(IR[0]) );
  NOR2BX2 I50 ( .AN(n16), .B(inter_LCALL), .Y(n44) );
  NAND2X2 I51 ( .A(IR_EN), .B(n31), .Y(n16) );
  NOR3X4 I52 ( .A(pre_pdwn_idle), .B(n17), .C(n16), .Y(n43) );
  INVX1 I53 ( .A(n16), .Y(n41) );
  INVX1 I54 ( .A(pre_pdwn_idle), .Y(n42) );
  DFFRX4 IR_reg_1_ ( .D(n24), .CK(CLK), .RN(n21), .Q(IR[1]) );
  OR2X2 I55 ( .A(MOVC_INS), .B(MOVX_INS), .Y(n17) );
  INVX2 I56 ( .A(RESET), .Y(n45) );
  INVX1 I57 ( .A(n2), .Y(P0R_PRE_IR) );
  INVX2 I58 ( .A(inter_LCALL), .Y(n31) );
  OAI2BB1X1 I59 ( .A0N(ID[1]), .A1N(n43), .B0(n12), .Y(n33) );
  NOR2BX1 U38 ( .AN(n36), .B(RESET), .Y(n27) );
  OAI2BB1X1 I60 ( .A0N(ID[4]), .A1N(n43), .B0(n9), .Y(n36) );
  INVX2 I61 ( .A(POR), .Y(n21) );
  NOR2BX1 U35 ( .AN(n33), .B(RESET), .Y(n24) );
  DFFRX4 IR_reg_7_ ( .D(n30), .CK(CLK), .RN(n21), .Q(IR[7]) );
  DFFRX4 IR_reg_6_ ( .D(n29), .CK(CLK), .RN(n21), .Q(n47) );
  DFFRX4 IR_reg_5_ ( .D(n28), .CK(CLK), .RN(n21), .Q(IR[5]) );
  DFFRX4 IR_reg_4_ ( .D(n27), .CK(CLK), .RN(n21), .Q(IR[4]) );
  DFFRX4 IR_reg_3_ ( .D(n26), .CK(CLK), .RN(n21), .Q(IR[3]) );
endmodule


module MEM_INTF ( user_init_pc, user_init_pc_en, TRANS_EN, inter_LCALL, 
        inter_vector, JBC_BIT_EN, BIT_REG, DPTR, ALLZ, ALLZ_B_PC_RES_EN, 
        ALLZ_PC_RES_EN, CLK, RESET, XA, IDATA, ID_WR_EN, MAR, P0R, CY, F5, 
        C_B_PC_RES_EN, C_PC_RES_EN, F5_B_PC_RES_EN, F5_PC_RES_EN, IR75, MDR, 
        TMP1, TMP2, ACC, PC_AD11_EN, PC_PC1_EN, SJMP_PC_RES_EN, JMP_PC_RES_EN, 
        PC_RET_EN, PC_T2T1_EN, PC1_A_EN, PC1_DP_EN, PC1_P0R_EN, PC2_DP_EN, 
        PC2_PC_EN, PC1_PCCALL_EN, DPTR_INC_EN, DPTR_DEC_EN, DP_T2T1_EN, 
        XAH_P2R_EN, XA_DP_EN, XAL_MDR_EN, P0R_MDR_EN, P0R_P0_EN, P0R_PRE_IR, 
        P0_IN, CAR_PC_RES_EN, PC_INC_EN, PC_ADD, PC );
  input [15:0] user_init_pc;
  input [7:0] inter_vector;
  output [2:0] BIT_REG;
  output [15:0] DPTR;
  output [15:0] XA;
  input [7:0] IDATA;
  input [8:0] MAR;
  output [7:0] P0R;
  input [7:5] IR75;
  input [7:0] MDR;
  input [7:0] TMP1;
  input [7:0] TMP2;
  input [7:0] ACC;
  input [7:0] P0_IN;
  output [15:0] PC;
  input user_init_pc_en, TRANS_EN, inter_LCALL, JBC_BIT_EN, ALLZ,
         ALLZ_B_PC_RES_EN, ALLZ_PC_RES_EN, CLK, RESET, ID_WR_EN, CY, F5,
         C_B_PC_RES_EN, C_PC_RES_EN, F5_B_PC_RES_EN, F5_PC_RES_EN, PC_AD11_EN,
         PC_PC1_EN, SJMP_PC_RES_EN, JMP_PC_RES_EN, PC_RET_EN, PC_T2T1_EN,
         PC1_A_EN, PC1_DP_EN, PC1_P0R_EN, PC2_DP_EN, PC2_PC_EN, PC1_PCCALL_EN,
         DPTR_INC_EN, DPTR_DEC_EN, DP_T2T1_EN, XAH_P2R_EN, XA_DP_EN,
         XAL_MDR_EN, P0R_MDR_EN, P0R_P0_EN, P0R_PRE_IR, CAR_PC_RES_EN,
         PC_INC_EN, PC_ADD;
  wire   N35, N36, N37, N38, N39, N40, N41, N42, N46, N59, PC2_11_, PC2_9_,
         PC2_8_, PC2_7_, PC2_5_, PC2_4_, PC2_3_, PC2_2_, PC2_1_, N81, N82, N83,
         N84, N85, N86, N87, N88, N89, N90, N91, N92, N93, N94, N95, N96,
         PC1_NEW_14_, PC1_NEW_13_, PC1_NEW_12_, PC1_NEW_11_, PC1_NEW_10_,
         PC1_NEW_9_, PC1_NEW_8_, PC1_NEW_7_, PC1_NEW_6_, PC1_NEW_5_,
         PC1_NEW_4_, PC1_NEW_3_, PC1_NEW_2_, PC1_NEW_1_, PC1_NEW_0_,
         PC2_NEW_15_, PC2_NEW_14_, PC2_NEW_13_, PC2_NEW_12_, PC2_NEW_11_,
         PC2_NEW_10_, PC2_NEW_9_, PC2_NEW_8_, PC2_NEW_7_, PC2_NEW_6_,
         PC2_NEW_5_, PC2_NEW_4_, PC2_NEW_3_, PC2_NEW_2_, PC2_NEW_1_, rel_minus,
         N112, N123, N132, N142, N152, N184, N217, N218, N219, N220, N221,
         N222, N223, N224, N225, N226, N230, N231, N232, N233, N234, N235,
         N236, N237, N238, N239, N240, N241, N242, N243, N244, N245, N246,
         N247, N248, N249, N250, N251, N252, N253, N254, N255, N256, N257,
         N258, N259, N260, N261, n7, n10, n13, n17, n18, n19, n21, n22, n24,
         n25, n27, n28, n30, n31, n33, n3600, n3800, n4000, n4200, n44, n4600,
         n50, n51, n5900, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n97, n98, n99, n100, n101, n102, n105,
         n106, n107, n108, n109, n110, n111, n1120, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n1230, n124, n126, n127, n129,
         n130, n1320, n133, n136, n138, n139, n140, n141, n1420, n143, n144,
         n145, n146, n147, n149, n151, n155, n180, n2380, n2400, n2420, n2430,
         n2450, n2480, n2490, n2500, n2530, n2540, n2550, n318, n319, n320,
         n321, n322, n323, n324, n325, n326, n327, n328, n329, n330, n331,
         n332, n333, n334, n335, n336, n337, n338, n339, n340, n341, n342,
         n343, n344, n345, n346, n347, n348, n349, n350, n351, n352, n353,
         n354, n355, n356, n357, n358, n359, n3601, n361, n362, n363, n364,
         n365, n366, n367, n368, n369, n370, n371, n372, n373, n374, n375,
         n376, n377, n378, n379, n3801, n381, n382, n383, n384, n385, n386,
         n387, n388, n389, n390, n391, n392, n393, n394, n395, n396, n397,
         n398, n399, n4001, n401, n402, n403, n404, n405, n406, n407, n408,
         n409, n410, n411, n412, n413, n414, n415, n416, n417, n418, n419,
         n4201, n421, n422, n423, n424, n425, n426, n427, n428, n429, n430,
         n431, n432, n433, n434, n435, n436, n437, n438, n439, n440, n441,
         n442, n443, n444, n445, n446, n447, n448, n449, n450, n451, n452,
         n453, n454, n455, n456, n457, n458, n459, n4601, n461, n462, n463,
         n464, n465, n466, n467, n468, n469, n470, n471, n472, n473, n474,
         n475, n476, n477, n478, n479, n480, n481, n482, n483, n484, n485,
         n486, n487, n488, n489, n490, n491, n492, n493, n494, n495, n496,
         n497, n498, n499, n500, n501, n502, n503, n504, n505, n506, n507,
         n508, n509, n510, n511, n512, n513, n514, n515, n516, n517, n518,
         n519, n520, n521, n522, n523, n524, n525, n526, n527, n528, n529,
         n530, n531, n532, n533, n534, n535, n536, n537, n538, n539, n540,
         n541, n542, n543, n544, n545, n546, n547, n548, n549, n550, n551,
         n552, n553, n554, n555, n556, n557, n558, n559, n560, n561, n562,
         n563, n564, n565, n566, n567, n568, n569, n570, n571, n572, n573,
         n574, n575, n576, n577, n578, n579, n580, n581, n582, n583, n584,
         n585, n586, n587, n588, n589, n5901, n591, n592, n593, n594, n595,
         n596, n597, n598, n599, n600, n601, n602, n603, n604, n605, n606,
         n607, n608, n609, n610, n611, n612, n613, n614, n615, n616, n617,
         n618, n619, n620, n621, n622, n623, n624, n625, n626, n627, n628,
         n629, n630, n631, n632, n633, n634, n635, n636, n637, n638, n639,
         n640, n641, n642, n643;
  wire   [15:0] PC2_IN;
  wire   [7:0] P0R_IN;
  wire   [15:0] PC1_IN;
  wire   [15:0] DPTR_IN;
  wire   [15:0] XA_IN;

  AOI222X4 U131 ( .A0(MDR[7]), .A1(n378), .B0(P0_IN[7]), .B1(n138), .C0(
        inter_vector[7]), .C1(n139), .Y(n136) );
  AOI222X4 U133 ( .A0(MDR[6]), .A1(n378), .B0(P0_IN[6]), .B1(n138), .C0(
        inter_vector[6]), .C1(n139), .Y(n140) );
  AOI222X4 U135 ( .A0(MDR[5]), .A1(n378), .B0(P0_IN[5]), .B1(n138), .C0(
        inter_vector[5]), .C1(n139), .Y(n141) );
  AOI222X4 U137 ( .A0(MDR[4]), .A1(n378), .B0(P0_IN[4]), .B1(n138), .C0(
        inter_vector[4]), .C1(n139), .Y(n1420) );
  AOI222X4 U139 ( .A0(MDR[3]), .A1(n378), .B0(P0_IN[3]), .B1(n138), .C0(
        inter_vector[3]), .C1(n139), .Y(n143) );
  AOI222X4 U141 ( .A0(MDR[2]), .A1(n378), .B0(P0_IN[2]), .B1(n138), .C0(
        inter_vector[2]), .C1(n139), .Y(n144) );
  AOI222X4 U143 ( .A0(MDR[1]), .A1(n378), .B0(P0_IN[1]), .B1(n138), .C0(
        inter_vector[1]), .C1(n139), .Y(n145) );
  AOI222X4 U145 ( .A0(MDR[0]), .A1(n378), .B0(P0_IN[0]), .B1(n138), .C0(
        inter_vector[0]), .C1(n139), .Y(n146) );
  OR2X4 U230 ( .A(PC2_PC_EN), .B(n330), .Y(N59) );
  OR2X4 U232 ( .A(PC1_PCCALL_EN), .B(n124), .Y(N46) );
  OAI32X4 U238 ( .A0(n2420), .A1(PC_AD11_EN), .A2(n2430), .B0(n180), .B1(n2430), .Y(N184) );
  OAI22X1 I399 ( .A0(n97), .A1(n4000), .B0(n98), .B1(n120), .Y(PC1_IN[13]) );
  AOI2BB2X1 I400 ( .A0N(n612), .A1N(n13), .B0(n318), .B1(MAR[7]), .Y(n399) );
  INVX1 I401 ( .A(n332), .Y(n318) );
  AOI2BB2X1 I402 ( .A0N(n335), .A1N(n617), .B0(P0R[1]), .B1(n370), .Y(n508) );
  NAND2BX1 I403 ( .AN(n407), .B(n402), .Y(n406) );
  AOI2BB2X1 I404 ( .A0N(n342), .A1N(n502), .B0(P0R[0]), .B1(n370), .Y(n512) );
  AOI2BB2X1 I405 ( .A0N(n19), .A1N(n332), .B0(n613), .B1(DPTR[6]), .Y(n405) );
  AOI2BB2X1 I406 ( .A0N(n343), .A1N(n616), .B0(P0R[2]), .B1(n370), .Y(n501) );
  NOR2X1 I407 ( .A(n428), .B(n496), .Y(n490) );
  NAND2BX1 I408 ( .AN(n410), .B(n402), .Y(n409) );
  AND2X1 I409 ( .A(n395), .B(n354), .Y(n362) );
  AOI2BB2X1 I410 ( .A0N(n22), .A1N(n332), .B0(n613), .B1(DPTR[5]), .Y(n408) );
  INVX2 I411 ( .A(n371), .Y(n354) );
  AOI21X1 I412 ( .A0(user_init_pc[8]), .A1(n385), .B0(n510), .Y(n509) );
  NAND2BX1 I413 ( .AN(n413), .B(n402), .Y(n412) );
  AOI2BB2X1 I414 ( .A0N(PC2_3_), .A1N(n631), .B0(n450), .B1(n443), .Y(
        PC2_NEW_3_) );
  AND2X2 I415 ( .A(n388), .B(n319), .Y(n378) );
  INVX1 I416 ( .A(n331), .Y(n319) );
  AND2X2 I417 ( .A(n385), .B(user_init_pc[15]), .Y(n464) );
  AOI2BB2X1 I418 ( .A0N(n25), .A1N(n332), .B0(n613), .B1(DPTR[4]), .Y(n411) );
  NOR2X1 I419 ( .A(n320), .B(n631), .Y(n441) );
  INVX4 I420 ( .A(n388), .Y(n386) );
  AND2X2 I421 ( .A(n385), .B(user_init_pc[12]), .Y(n485) );
  AOI2BB1X1 I422 ( .A0N(n499), .A1N(n608), .B0(n498), .Y(n497) );
  AOI211X1 I423 ( .A0(n414), .A1(n402), .B0(n416), .C0(n417), .Y(n321) );
  INVX1 I424 ( .A(n321), .Y(XA_IN[3]) );
  OAI2BB1X1 I425 ( .A0N(n322), .A1N(n323), .B0(n448), .Y(PC2_NEW_15_) );
  INVX1 I426 ( .A(n363), .Y(n322) );
  OR2X2 I427 ( .A(n130), .B(n1320), .Y(n324) );
  INVX2 I428 ( .A(n324), .Y(n377) );
  AND2X2 I429 ( .A(n385), .B(user_init_pc[14]), .Y(n473) );
  OAI21X1 I430 ( .A0(n419), .A1(n17), .B0(n418), .Y(XA_IN[2]) );
  OR2X1 I431 ( .A(n631), .B(n395), .Y(n3801) );
  OAI221X4 I432 ( .A0(n492), .A1(n493), .B0(n495), .B1(N39), .C0(n494), .Y(
        n491) );
  INVX1 I433 ( .A(n17), .Y(n402) );
  MXI2X2 I434 ( .S0(n373), .B(n70), .A(n347), .Y(n348) );
  AOI2BB2X4 I435 ( .A0N(PC2_1_), .A1N(n631), .B0(n354), .B1(n454), .Y(
        PC2_NEW_1_) );
  OAI222X4 I436 ( .A0(n404), .A1(n50), .B0(n51), .B1(n332), .C0(n433), .C1(n17), .Y(XA_IN[0]) );
  NAND3X1 I437 ( .A(n629), .B(n388), .C(n430), .Y(n396) );
  OAI2BB1X1 I438 ( .A0N(n385), .A1N(user_init_pc[11]), .B0(n489), .Y(N92) );
  AND3X1 I439 ( .A(n488), .B(n180), .C(TMP2[5]), .Y(n476) );
  OR2X2 I440 ( .A(n459), .B(n622), .Y(n393) );
  OAI22X1 I441 ( .A0(n396), .A1(n44), .B0(n610), .B1(n428), .Y(XA_IN[11]) );
  OAI222X4 I442 ( .A0(n332), .A1(n423), .B0(n612), .B1(n33), .C0(n422), .C1(
        n17), .Y(XA_IN[1]) );
  MXI2X1 I443 ( .S0(n379), .B(n333), .A(n69), .Y(PC1_NEW_1_) );
  INVX1 I444 ( .A(n495), .Y(n486) );
  INVX1 I445 ( .A(n394), .Y(n180) );
  BUFX16 I446 ( .A(n373), .Y(n326) );
  MXI2X1 I447 ( .S0(n326), .B(n61), .A(n335), .Y(n325) );
  INVX8 I448 ( .A(PC_INC_EN), .Y(n446) );
  AOI2BB1X1 I449 ( .A0N(n359), .A1N(n371), .B0(n439), .Y(n327) );
  INVX2 I450 ( .A(n631), .Y(n448) );
  NAND2X1 I451 ( .A(n486), .B(n180), .Y(n466) );
  NAND2X2 I452 ( .A(n600), .B(n448), .Y(n599) );
  EDFFX2 P0R_reg_0_ ( .D(P0R_IN[0]), .CK(CLK), .E(N152), .Q(P0R[0]), .QN(N42)
         );
  OR2X2 I453 ( .A(n426), .B(n611), .Y(n352) );
  BUFX8 I454 ( .A(n368), .Y(n627) );
  NOR2X1 I455 ( .A(n631), .B(n436), .Y(n440) );
  NOR2X1 I456 ( .A(n466), .B(N38), .Y(n483) );
  NOR2X1 I457 ( .A(n466), .B(N36), .Y(n471) );
  MXI2X1 I458 ( .S0(n326), .B(n61), .A(n335), .Y(PC1_NEW_9_) );
  AND2X2 I459 ( .A(n445), .B(n446), .Y(n371) );
  MXI2X2 I460 ( .S0(ALLZ), .B(ALLZ_PC_RES_EN), .A(ALLZ_B_PC_RES_EN), .Y(n604)
         );
  BUFX3 I461 ( .A(PC_AD11_EN), .Y(n622) );
  INVX2 I462 ( .A(n622), .Y(n554) );
  INVX2 I463 ( .A(n599), .Y(n445) );
  NOR2X2 I464 ( .A(n386), .B(DP_T2T1_EN), .Y(n598) );
  MXI2X2 I465 ( .S0(n627), .B(N231), .A(N247), .Y(n422) );
  MXI2X2 I466 ( .S0(n627), .B(N237), .A(N253), .Y(n403) );
  MXI2X2 I467 ( .S0(n627), .B(N243), .A(N259), .Y(n426) );
  MXI2X2 I468 ( .S0(n627), .B(N235), .A(N251), .Y(n410) );
  MXI2X2 I469 ( .S0(n627), .B(N234), .A(N250), .Y(n413) );
  MXI2X2 I470 ( .S0(n627), .B(N233), .A(N249), .Y(n415) );
  NAND2BX2 I471 ( .AN(n124), .B(PC1_PCCALL_EN), .Y(n98) );
  MXI2X2 I472 ( .S0(n627), .B(N240), .A(N256), .Y(n429) );
  MXI2X2 I473 ( .S0(n627), .B(N239), .A(N255), .Y(n397) );
  MXI2X2 I474 ( .S0(n627), .B(N238), .A(N254), .Y(n398) );
  AND3X2 I475 ( .A(n22), .B(n19), .C(n25), .Y(n2540) );
  OAI21X1 I476 ( .A0(n490), .A1(n491), .B0(n180), .Y(n489) );
  AND3X2 I477 ( .A(n22), .B(n19), .C(n25), .Y(n2490) );
  OR3X2 I478 ( .A(P0R_PRE_IR), .B(P0R_P0_EN), .C(n149), .Y(N152) );
  EDFFX1 DPTR_reg_9_ ( .D(DPTR_IN[9]), .CK(CLK), .E(N123), .Q(DPTR[9]), .QN(n7) );
  EDFFX1 DPTR_reg_8_ ( .D(DPTR_IN[8]), .CK(CLK), .E(N123), .Q(DPTR[8]), .QN(
        n10) );
  EDFFX2 P0R_reg_2_ ( .D(P0R_IN[2]), .CK(CLK), .E(N152), .Q(P0R[2]), .QN(N40)
         );
  EDFFX2 P0R_reg_1_ ( .D(P0R_IN[1]), .CK(CLK), .E(N152), .Q(P0R[1]), .QN(N41)
         );
  AND2X4 I479 ( .A(n488), .B(n554), .Y(n328) );
  EDFFX2 P0R_reg_6_ ( .D(P0R_IN[6]), .CK(CLK), .E(N152), .Q(P0R[6]), .QN(N36)
         );
  EDFFX2 P0R_reg_4_ ( .D(P0R_IN[4]), .CK(CLK), .E(N152), .Q(P0R[4]), .QN(N38)
         );
  AND3X2 I480 ( .A(n602), .B(n603), .C(n601), .Y(n329) );
  OR2X4 I481 ( .A(n386), .B(PC2_DP_EN), .Y(n330) );
  INVX1 I482 ( .A(n630), .Y(n629) );
  OR2X2 I483 ( .A(inter_LCALL), .B(n151), .Y(n331) );
  NAND2X2 I484 ( .A(XAL_MDR_EN), .B(n390), .Y(n332) );
  EDFFX2 P0R_reg_3_ ( .D(P0R_IN[3]), .CK(CLK), .E(N152), .Q(P0R[3]), .QN(N39)
         );
  EDFFX2 P0R_reg_7_ ( .D(P0R_IN[7]), .CK(CLK), .E(N152), .Q(P0R[7]), .QN(N35)
         );
  EDFFX1 P0R_reg_5_ ( .D(P0R_IN[5]), .CK(CLK), .E(N152), .Q(P0R[5]), .QN(N37)
         );
  MXI2X2 I485 ( .S0(n627), .B(N245), .A(N261), .Y(n424) );
  MXI2X1 I486 ( .S0(n326), .B(n63), .A(n337), .Y(PC1_NEW_7_) );
  MXI2X2 I487 ( .S0(n627), .B(N232), .A(N248), .Y(n419) );
  INVX2 I488 ( .A(n2530), .Y(n2480) );
  NAND2X2 I489 ( .A(n598), .B(n445), .Y(n2530) );
  NOR2X4 I490 ( .A(n129), .B(n130), .Y(n376) );
  INVX1 I491 ( .A(P0R_MDR_EN), .Y(n151) );
  NAND2X2 I492 ( .A(n599), .B(n389), .Y(n558) );
  AND2X4 I493 ( .A(n486), .B(n554), .Y(n370) );
  OAI21X4 I494 ( .A0(n383), .A1(n384), .B0(n2480), .Y(N112) );
  INVX12 I495 ( .A(n375), .Y(n97) );
  AOI21X2 I496 ( .A0(n440), .A1(n354), .B0(n441), .Y(PC2_NEW_6_) );
  MXI2X2 I497 ( .S0(n627), .B(N236), .A(N252), .Y(n407) );
  MXI2X2 I498 ( .S0(n627), .B(N230), .A(N246), .Y(n433) );
  OR2X2 I499 ( .A(n626), .B(n446), .Y(n379) );
  NAND2X2 I500 ( .A(n599), .B(n387), .Y(n623) );
  EDFFX1 DPTR_reg_10_ ( .D(DPTR_IN[10]), .CK(CLK), .E(N123), .Q(DPTR[10]), 
        .QN(n4600) );
  OAI21X4 I501 ( .A0(n381), .A1(n382), .B0(n2480), .Y(N123) );
  AOI22X1 I502 ( .A0(n328), .A1(TMP1[2]), .B0(n622), .B1(P0R[2]), .Y(n541) );
  AOI22X1 I503 ( .A0(n328), .A1(TMP1[5]), .B0(n622), .B1(P0R[5]), .Y(n526) );
  AOI22X1 I504 ( .A0(n328), .A1(TMP1[3]), .B0(n622), .B1(P0R[3]), .Y(n536) );
  AOI22X1 I505 ( .A0(n328), .A1(TMP1[1]), .B0(P0R[1]), .B1(n622), .Y(n546) );
  AOI22X1 I506 ( .A0(n328), .A1(TMP1[4]), .B0(n622), .B1(P0R[4]), .Y(n531) );
  AOI22X1 I507 ( .A0(n328), .A1(TMP1[6]), .B0(n622), .B1(P0R[6]), .Y(n521) );
  AOI22X1 I508 ( .A0(n328), .A1(TMP1[7]), .B0(n622), .B1(P0R[7]), .Y(n516) );
  AOI22X1 I509 ( .A0(n328), .A1(TMP1[0]), .B0(P0R[0]), .B1(n622), .Y(n551) );
  AOI22X1 I510 ( .A0(TMP2[0]), .A1(n328), .B0(IR75[5]), .B1(n622), .Y(n511) );
  AOI22X1 I511 ( .A0(TMP2[1]), .A1(n328), .B0(IR75[6]), .B1(n622), .Y(n507) );
  NAND2X2 I512 ( .A(n329), .B(n350), .Y(n625) );
  NOR2X2 I513 ( .A(n631), .B(n625), .Y(n454) );
  AOI21X1 I514 ( .A0(n437), .A1(n443), .B0(n438), .Y(n349) );
  BUFX2 I515 ( .A(n604), .Y(n350) );
  MXI2X1 I516 ( .S0(n627), .B(N242), .A(N258), .Y(n427) );
  INVX1 I517 ( .A(n372), .Y(n611) );
  EDFFX1 PC_reg_7_ ( .D(N88), .CK(CLK), .E(N217), .Q(PC[7]), .QN(n63) );
  EDFFX1 XA_reg_13_ ( .D(XA_IN[13]), .CK(CLK), .E(N132), .Q(XA[13]) );
  OR2X2 I518 ( .A(n614), .B(n4000), .Y(n351) );
  NAND2X1 I519 ( .A(n351), .B(n352), .Y(XA_IN[13]) );
  MXI2X2 I520 ( .S0(n627), .B(N242), .A(N258), .Y(n353) );
  AOI2BB1X1 I521 ( .A0N(n359), .A1N(n371), .B0(n439), .Y(PC2_NEW_7_) );
  EDFFX1 DPTR_reg_12_ ( .D(DPTR_IN[12]), .CK(CLK), .E(N123), .Q(DPTR[12]), 
        .QN(n4200) );
  EDFFX1 XA_reg_12_ ( .D(XA_IN[12]), .CK(CLK), .E(N132), .Q(XA[12]) );
  OR2X2 I522 ( .A(n614), .B(n4200), .Y(n355) );
  OR2X1 I523 ( .A(n427), .B(n610), .Y(n356) );
  NAND2X1 I524 ( .A(n355), .B(n356), .Y(XA_IN[12]) );
  EDFFX1 XA_reg_15_ ( .D(XA_IN[15]), .CK(CLK), .E(N132), .Q(XA[15]) );
  OR2X2 I525 ( .A(n614), .B(n3600), .Y(n357) );
  OR2X1 I526 ( .A(n424), .B(n611), .Y(n358) );
  NAND2X1 I527 ( .A(n357), .B(n358), .Y(XA_IN[15]) );
  OR2X1 I528 ( .A(n631), .B(n626), .Y(n359) );
  AND2X1 I529 ( .A(n395), .B(n452), .Y(n374) );
  EDFFX1 PC_reg_5_ ( .D(N86), .CK(CLK), .E(N217), .Q(PC[5]), .QN(n65) );
  EDFFX1 PC_reg_4_ ( .D(N85), .CK(CLK), .E(N217), .Q(PC[4]), .QN(n66) );
  AOI21X1 I530 ( .A0(n442), .A1(n443), .B0(n444), .Y(PC2_NEW_5_) );
  AOI21X1 I531 ( .A0(n451), .A1(n452), .B0(n453), .Y(PC2_NEW_2_) );
  AOI21X1 I532 ( .A0(n455), .A1(n452), .B0(n456), .Y(PC2_NEW_11_) );
  OAI2BB1X2 I533 ( .A0N(n3801), .A1N(n354), .B0(n367), .Y(n366) );
  OAI21X1 I534 ( .A0(n362), .A1(n641), .B0(n448), .Y(PC2_NEW_12_) );
  OAI21X2 I535 ( .A0(n374), .A1(n642), .B0(n448), .Y(PC2_NEW_10_) );
  EDFFX1 DPTR_reg_14_ ( .D(DPTR_IN[14]), .CK(CLK), .E(N123), .Q(DPTR[14]), 
        .QN(n3800) );
  EDFFX1 XA_reg_14_ ( .D(XA_IN[14]), .CK(CLK), .E(N132), .Q(XA[14]) );
  OR2X2 I536 ( .A(n614), .B(n3800), .Y(n3601) );
  OR2X1 I537 ( .A(n425), .B(n611), .Y(n361) );
  NAND2X1 I538 ( .A(n3601), .B(n361), .Y(XA_IN[14]) );
  MXI2X2 I539 ( .S0(n627), .B(N244), .A(N260), .Y(n425) );
  EDFFX1 PC_reg_3_ ( .D(N84), .CK(CLK), .E(N217), .Q(PC[3]), .QN(n67) );
  AND2X1 I540 ( .A(n395), .B(n452), .Y(n363) );
  NAND2X1 I541 ( .A(n488), .B(n180), .Y(n467) );
  INVX2 I542 ( .A(n613), .Y(n612) );
  NAND3BX1 I543 ( .AN(PC_PC1_EN), .B(PC_T2T1_EN), .C(n556), .Y(n492) );
  NAND3BX1 I544 ( .AN(PC_T2T1_EN), .B(n555), .C(n556), .Y(n496) );
  INVX1 I545 ( .A(PC_RET_EN), .Y(n556) );
  NAND2X1 I546 ( .A(n431), .B(n432), .Y(n17) );
  INVX1 I547 ( .A(PC_PC1_EN), .Y(n555) );
  NAND2BX1 I548 ( .AN(n386), .B(PC1_A_EN), .Y(n133) );
  NAND2X1 I549 ( .A(TRANS_EN), .B(n388), .Y(n618) );
  INVX1 I550 ( .A(n637), .Y(n636) );
  NAND2BX1 I551 ( .AN(n386), .B(PC2_DP_EN), .Y(n5900) );
  INVX1 I552 ( .A(RESET), .Y(n389) );
  INVX1 I553 ( .A(RESET), .Y(n390) );
  INVX1 I554 ( .A(RESET), .Y(n387) );
  NOR2X1 I555 ( .A(n467), .B(n468), .Y(n461) );
  NOR2X1 I556 ( .A(n467), .B(n474), .Y(n470) );
  NOR2X1 I557 ( .A(n467), .B(n487), .Y(n482) );
  OR3X1 I558 ( .A(inter_LCALL), .B(P0R_MDR_EN), .C(n386), .Y(n149) );
  NAND2BX1 I559 ( .AN(n386), .B(inter_LCALL), .Y(n147) );
  INVX1 I560 ( .A(n385), .Y(n609) );
  INVX1 I561 ( .A(n385), .Y(n607) );
  INVX1 I562 ( .A(n385), .Y(n608) );
  MXI2X1 I563 ( .S0(n364), .B(n68), .A(n341), .Y(PC1_NEW_2_) );
  NOR2X1 I564 ( .A(n625), .B(n446), .Y(n364) );
  MXI2X1 I565 ( .S0(n365), .B(n65), .A(n340), .Y(PC1_NEW_5_) );
  NOR2X1 I566 ( .A(n625), .B(n446), .Y(n365) );
  MXI2X1 I567 ( .S0(n458), .B(n67), .A(n339), .Y(PC1_NEW_3_) );
  MXI2X1 I568 ( .S0(n457), .B(n66), .A(n338), .Y(PC1_NEW_4_) );
  OAI21X1 I569 ( .A0(n362), .A1(n640), .B0(n448), .Y(PC2_NEW_13_) );
  OAI21X1 I570 ( .A0(n362), .A1(n639), .B0(n448), .Y(PC2_NEW_14_) );
  AOI21X1 I571 ( .A0(n437), .A1(n452), .B0(n438), .Y(PC2_NEW_8_) );
  AOI21X1 I572 ( .A0(n434), .A1(n443), .B0(n435), .Y(PC2_NEW_9_) );
  NAND2X1 I573 ( .A(PC2_4_), .B(n436), .Y(n447) );
  NAND3BX1 I574 ( .AN(PC_ADD), .B(n446), .C(n395), .Y(n392) );
  AND2X1 I575 ( .A(n369), .B(n436), .Y(n368) );
  AND2X2 I576 ( .A(rel_minus), .B(n605), .Y(n369) );
  NOR2X1 I577 ( .A(n466), .B(N35), .Y(n462) );
  NOR2X1 I578 ( .A(n466), .B(N37), .Y(n477) );
  NOR2X1 I579 ( .A(n612), .B(n27), .Y(n417) );
  NOR2X1 I580 ( .A(n612), .B(n30), .Y(n421) );
  INVX1 I581 ( .A(MAR[6]), .Y(n19) );
  INVX1 I582 ( .A(MAR[3]), .Y(n28) );
  INVX1 I583 ( .A(n459), .Y(n557) );
  INVX1 I584 ( .A(n492), .Y(n488) );
  INVX1 I585 ( .A(n496), .Y(n155) );
  INVX1 I586 ( .A(XAL_MDR_EN), .Y(n432) );
  NAND2X1 I587 ( .A(n557), .B(n554), .Y(n620) );
  NAND2X1 I588 ( .A(n557), .B(n554), .Y(n621) );
  NAND2X1 I589 ( .A(PC_PC1_EN), .B(n554), .Y(n616) );
  NAND2X1 I590 ( .A(PC_PC1_EN), .B(n554), .Y(n617) );
  NAND2BX2 I591 ( .AN(n619), .B(n155), .Y(n459) );
  INVX1 I592 ( .A(n404), .Y(n613) );
  NAND3BX1 I593 ( .AN(n386), .B(n629), .C(n432), .Y(n404) );
  NAND2X1 I594 ( .A(PC_PC1_EN), .B(n554), .Y(n502) );
  NOR2X1 I595 ( .A(n629), .B(n386), .Y(n431) );
  NAND2X1 I596 ( .A(PC_RET_EN), .B(n555), .Y(n495) );
  NAND2X1 I597 ( .A(PC_PC1_EN), .B(n180), .Y(n465) );
  INVX1 I598 ( .A(XA_DP_EN), .Y(n630) );
  INVX2 I599 ( .A(n615), .Y(n614) );
  INVX1 I600 ( .A(n396), .Y(n615) );
  INVX1 I601 ( .A(n372), .Y(n610) );
  INVX1 I602 ( .A(XAH_P2R_EN), .Y(n430) );
  NAND2BX1 I603 ( .AN(n386), .B(n618), .Y(n2400) );
  NAND2X2 I604 ( .A(n598), .B(n445), .Y(n391) );
  NAND2X2 I605 ( .A(n598), .B(n445), .Y(n628) );
  INVX2 I606 ( .A(n133), .Y(n105) );
  OR2X2 I607 ( .A(CAR_PC_RES_EN), .B(n17), .Y(N142) );
  INVX1 I608 ( .A(n636), .Y(n633) );
  INVX1 I609 ( .A(n636), .Y(n634) );
  INVX1 I610 ( .A(n636), .Y(n635) );
  AND4X2 I611 ( .A(CAR_PC_RES_EN), .B(n387), .C(n430), .D(n630), .Y(n372) );
  OR4X2 I612 ( .A(n386), .B(CAR_PC_RES_EN), .C(XA_DP_EN), .D(XAH_P2R_EN), .Y(
        N132) );
  NAND2X2 I613 ( .A(TRANS_EN), .B(n390), .Y(n394) );
  NAND2X2 I614 ( .A(TRANS_EN), .B(n388), .Y(n619) );
  AND2X4 I615 ( .A(PC_INC_EN), .B(n395), .Y(n373) );
  INVX1 I616 ( .A(n403), .Y(n401) );
  INVX1 I617 ( .A(n415), .Y(n414) );
  NOR2X2 I618 ( .A(SJMP_PC_RES_EN), .B(JMP_PC_RES_EN), .Y(n603) );
  BUFX8 I619 ( .A(DPTR_DEC_EN), .Y(n631) );
  INVX1 I620 ( .A(IDATA[0]), .Y(n606) );
  NOR3BX1 I621 ( .AN(DP_T2T1_EN), .B(n599), .C(n386), .Y(n637) );
  NOR3BX1 I622 ( .AN(PC1_DP_EN), .B(PC1_A_EN), .C(n386), .Y(n375) );
  OR3X2 I623 ( .A(PC1_DP_EN), .B(PC1_A_EN), .C(N218), .Y(n124) );
  OR2X1 I624 ( .A(PC1_P0R_EN), .B(n386), .Y(N218) );
  OR3X2 I625 ( .A(PC1_A_EN), .B(PC1_DP_EN), .C(n386), .Y(n130) );
  NAND2X2 I626 ( .A(n599), .B(n389), .Y(n624) );
  BUFX4 I627 ( .A(n5900), .Y(n643) );
  INVX2 I628 ( .A(RESET), .Y(n388) );
  INVX2 I629 ( .A(n626), .Y(n395) );
  OAI21X1 I630 ( .A0(n433), .A1(n624), .B0(n596), .Y(DPTR_IN[0]) );
  AOI21X1 I631 ( .A0(n634), .A1(TMP1[0]), .B0(n597), .Y(n596) );
  NOR2X1 I632 ( .A(n628), .B(n606), .Y(n597) );
  INVX1 I633 ( .A(DPTR_INC_EN), .Y(n600) );
  INVX1 I634 ( .A(IDATA[6]), .Y(n569) );
  INVX1 I635 ( .A(IDATA[5]), .Y(n572) );
  INVX1 I636 ( .A(IDATA[2]), .Y(n581) );
  INVX1 I637 ( .A(IDATA[3]), .Y(n578) );
  INVX1 I638 ( .A(IDATA[4]), .Y(n575) );
  INVX1 I639 ( .A(IDATA[7]), .Y(n566) );
  EDFFX1 PC_reg_9_ ( .D(N90), .CK(CLK), .E(N217), .Q(PC[9]), .QN(n61) );
  EDFFX1 PC_reg_8_ ( .D(N89), .CK(CLK), .E(N217), .Q(PC[8]), .QN(n62) );
  INVX1 I640 ( .A(IDATA[1]), .Y(n561) );
  INVX2 I641 ( .A(n149), .Y(n138) );
  EDFFX1 PC_reg_15_ ( .D(N96), .CK(CLK), .E(N184), .Q(PC[15]), .QN(n70) );
  EDFFX1 PC_reg_12_ ( .D(N93), .CK(CLK), .E(N184), .Q(PC[12]), .QN(n73) );
  EDFFX1 PC_reg_10_ ( .D(N91), .CK(CLK), .E(N217), .Q(PC[10]), .QN(n75) );
  EDFFX1 PC_reg_14_ ( .D(N95), .CK(CLK), .E(N184), .Q(PC[14]), .QN(n71) );
  EDFFX1 PC_reg_13_ ( .D(N94), .CK(CLK), .E(N184), .Q(PC[13]), .QN(n72) );
  INVX2 I642 ( .A(n609), .Y(n514) );
  NAND4X2 I643 ( .A(n601), .B(n602), .C(n603), .D(n350), .Y(n436) );
  NAND4X2 I644 ( .A(n604), .B(n602), .C(n603), .D(n601), .Y(n626) );
  AOI21X1 I645 ( .A0(n633), .A1(TMP2[7]), .B0(n585), .Y(n584) );
  NOR2X1 I646 ( .A(n628), .B(n566), .Y(n585) );
  AOI21X1 I647 ( .A0(n634), .A1(TMP2[5]), .B0(n589), .Y(n588) );
  NOR2X1 I648 ( .A(n2530), .B(n572), .Y(n589) );
  AOI21X1 I649 ( .A0(n634), .A1(TMP2[3]), .B0(n593), .Y(n592) );
  NOR2X1 I650 ( .A(n391), .B(n578), .Y(n593) );
  NOR4X2 I651 ( .A(n461), .B(n462), .C(n463), .D(n464), .Y(n4601) );
  NOR2X1 I652 ( .A(n347), .B(n465), .Y(n463) );
  NOR4X2 I653 ( .A(n476), .B(n477), .C(n478), .D(n479), .Y(n475) );
  NOR2X1 I654 ( .A(n609), .B(n480), .Y(n479) );
  NOR2X1 I655 ( .A(n345), .B(n465), .Y(n478) );
  OAI21X1 I656 ( .A0(n353), .A1(n624), .B0(n5901), .Y(DPTR_IN[12]) );
  AOI21X1 I657 ( .A0(n633), .A1(TMP2[4]), .B0(n591), .Y(n5901) );
  NOR2X1 I658 ( .A(n628), .B(n575), .Y(n591) );
  OAI21X1 I659 ( .A0(n397), .A1(n624), .B0(n559), .Y(DPTR_IN[9]) );
  AOI21X1 I660 ( .A0(n632), .A1(TMP2[1]), .B0(n560), .Y(n559) );
  NOR2X1 I661 ( .A(n628), .B(n561), .Y(n560) );
  OAI21X1 I662 ( .A0(n407), .A1(n624), .B0(n567), .Y(DPTR_IN[6]) );
  AOI21X1 I663 ( .A0(n635), .A1(TMP1[6]), .B0(n568), .Y(n567) );
  NOR2X1 I664 ( .A(n628), .B(n569), .Y(n568) );
  OAI21X1 I665 ( .A0(n415), .A1(n624), .B0(n576), .Y(DPTR_IN[3]) );
  AOI21X1 I666 ( .A0(n632), .A1(TMP1[3]), .B0(n577), .Y(n576) );
  INVX1 I667 ( .A(n636), .Y(n632) );
  NOR2X1 I668 ( .A(n628), .B(n578), .Y(n577) );
  OAI21X1 I669 ( .A0(n425), .A1(n459), .B0(n469), .Y(N95) );
  NOR4X2 I670 ( .A(n470), .B(n471), .C(n472), .D(n473), .Y(n469) );
  NOR2X1 I671 ( .A(n346), .B(n465), .Y(n472) );
  OAI21X1 I672 ( .A0(n353), .A1(n459), .B0(n481), .Y(N93) );
  NOR4X2 I673 ( .A(n482), .B(n483), .C(n484), .D(n485), .Y(n481) );
  NOR2X1 I674 ( .A(n344), .B(n465), .Y(n484) );
  OAI21X1 I675 ( .A0(n398), .A1(n393), .B0(n509), .Y(N89) );
  AOI21X1 I676 ( .A0(n511), .A1(n512), .B0(n618), .Y(n510) );
  OAI21X1 I677 ( .A0(n425), .A1(n558), .B0(n586), .Y(DPTR_IN[14]) );
  AOI21X1 I678 ( .A0(n633), .A1(TMP2[6]), .B0(n587), .Y(n586) );
  NOR2X1 I679 ( .A(n391), .B(n569), .Y(n587) );
  OAI21X1 I680 ( .A0(n398), .A1(n558), .B0(n562), .Y(DPTR_IN[8]) );
  AOI21X1 I681 ( .A0(n633), .A1(TMP2[0]), .B0(n563), .Y(n562) );
  NOR2X1 I682 ( .A(n391), .B(n606), .Y(n563) );
  OAI21X1 I683 ( .A0(n429), .A1(n620), .B0(n497), .Y(N91) );
  AOI21X1 I684 ( .A0(n500), .A1(n501), .B0(n619), .Y(n498) );
  OAI21X1 I685 ( .A0(n397), .A1(n621), .B0(n503), .Y(N90) );
  NOR2X1 I686 ( .A(n504), .B(n505), .Y(n503) );
  NOR2X1 I687 ( .A(n607), .B(n506), .Y(n505) );
  AOI21X1 I688 ( .A0(n507), .A1(n508), .B0(n394), .Y(n504) );
  OAI21X1 I689 ( .A0(n429), .A1(n623), .B0(n594), .Y(DPTR_IN[10]) );
  AOI21X1 I690 ( .A0(n635), .A1(TMP2[2]), .B0(n595), .Y(n594) );
  NOR2X1 I691 ( .A(n391), .B(n581), .Y(n595) );
  OAI21X1 I692 ( .A0(n403), .A1(n623), .B0(n564), .Y(DPTR_IN[7]) );
  AOI21X1 I693 ( .A0(n634), .A1(TMP1[7]), .B0(n565), .Y(n564) );
  NOR2X1 I694 ( .A(n2530), .B(n566), .Y(n565) );
  OAI21X1 I695 ( .A0(n410), .A1(n558), .B0(n570), .Y(DPTR_IN[5]) );
  AOI21X1 I696 ( .A0(n635), .A1(TMP1[5]), .B0(n571), .Y(n570) );
  NOR2X1 I697 ( .A(n391), .B(n572), .Y(n571) );
  OAI21X1 I698 ( .A0(n413), .A1(n623), .B0(n573), .Y(DPTR_IN[4]) );
  AOI21X1 I699 ( .A0(n632), .A1(TMP1[4]), .B0(n574), .Y(n573) );
  NOR2X1 I700 ( .A(n2530), .B(n575), .Y(n574) );
  OAI21X1 I701 ( .A0(n419), .A1(n558), .B0(n579), .Y(DPTR_IN[2]) );
  AOI21X1 I702 ( .A0(n635), .A1(TMP1[2]), .B0(n580), .Y(n579) );
  NOR2X1 I703 ( .A(n391), .B(n581), .Y(n580) );
  OAI21X1 I704 ( .A0(n422), .A1(n623), .B0(n582), .Y(DPTR_IN[1]) );
  AOI21X1 I705 ( .A0(n632), .A1(TMP1[1]), .B0(n583), .Y(n582) );
  NOR2X1 I706 ( .A(n2530), .B(n561), .Y(n583) );
  NAND2X1 I707 ( .A(n399), .B(n4001), .Y(XA_IN[7]) );
  NAND2X1 I708 ( .A(n401), .B(n402), .Y(n4001) );
  NAND2X1 I709 ( .A(n405), .B(n406), .Y(XA_IN[6]) );
  NAND2X1 I710 ( .A(n408), .B(n409), .Y(XA_IN[5]) );
  NAND2X1 I711 ( .A(n411), .B(n412), .Y(XA_IN[4]) );
  NOR2X1 I712 ( .A(n28), .B(n332), .Y(n416) );
  NOR2X1 I713 ( .A(n4201), .B(n421), .Y(n418) );
  NOR2X1 I714 ( .A(n31), .B(n332), .Y(n4201) );
  INVX4 I715 ( .A(n2380), .Y(N217) );
  OAI21X2 I716 ( .A0(n393), .A1(n392), .B0(n2400), .Y(n2380) );
  INVX1 I717 ( .A(n2400), .Y(n2430) );
  AND2X2 I718 ( .A(n2450), .B(n155), .Y(n2420) );
  INVX1 I719 ( .A(n392), .Y(n2450) );
  INVX1 I720 ( .A(TMP2[7]), .Y(n468) );
  INVX1 I721 ( .A(TMP2[6]), .Y(n474) );
  INVX1 I722 ( .A(TMP2[4]), .Y(n487) );
  NOR2X1 I723 ( .A(n337), .B(n616), .Y(n518) );
  NOR2X1 I724 ( .A(n336), .B(n617), .Y(n523) );
  NOR2X1 I725 ( .A(n338), .B(n616), .Y(n533) );
  NOR2X1 I726 ( .A(n339), .B(n617), .Y(n538) );
  NOR2X1 I727 ( .A(n333), .B(n616), .Y(n548) );
  NOR2X1 I728 ( .A(n334), .B(n617), .Y(n553) );
  NOR2X1 I729 ( .A(n340), .B(n502), .Y(n528) );
  NOR2X1 I730 ( .A(n341), .B(n502), .Y(n543) );
  EDFFX1 PC_reg_1_ ( .D(N82), .CK(CLK), .E(N217), .Q(PC[1]), .QN(n69) );
  EDFFX1 PC_reg_0_ ( .D(N81), .CK(CLK), .E(N217), .Q(PC[0]), .QN(n76) );
  EDFFX1 DPTR_reg_1_ ( .D(DPTR_IN[1]), .CK(CLK), .E(N112), .Q(DPTR[1]), .QN(
        n33) );
  EDFFX1 DPTR_reg_0_ ( .D(DPTR_IN[0]), .CK(CLK), .E(N112), .Q(DPTR[0]), .QN(
        n50) );
  INVX1 I731 ( .A(n1320), .Y(n129) );
  EDFFX1 DPTR_reg_15_ ( .D(DPTR_IN[15]), .CK(CLK), .E(N123), .Q(DPTR[15]), 
        .QN(n3600) );
  EDFFX1 DPTR_reg_7_ ( .D(DPTR_IN[7]), .CK(CLK), .E(N112), .Q(DPTR[7]), .QN(
        n13) );
  EDFFX1 PC1_reg_11_ ( .D(PC1_IN[11]), .CK(CLK), .E(N46), .Q(n638) );
  EDFFX1 PC2_reg_4_ ( .D(PC2_IN[4]), .CK(CLK), .E(N59), .Q(PC2_4_) );
  EDFFX1 PC_reg_2_ ( .D(N83), .CK(CLK), .E(N217), .Q(PC[2]), .QN(n68) );
  EDFFX1 PC1_reg_12_ ( .D(PC1_IN[12]), .CK(CLK), .E(N46), .QN(n344) );
  EDFFX1 PC1_reg_10_ ( .D(PC1_IN[10]), .CK(CLK), .E(N46), .QN(n343) );
  EDFFX1 PC1_reg_9_ ( .D(PC1_IN[9]), .CK(CLK), .E(N46), .QN(n335) );
  EDFFX1 PC1_reg_8_ ( .D(PC1_IN[8]), .CK(CLK), .E(N46), .QN(n342) );
  EDFFX1 PC1_reg_7_ ( .D(PC1_IN[7]), .CK(CLK), .E(N46), .QN(n337) );
  EDFFX1 PC1_reg_6_ ( .D(PC1_IN[6]), .CK(CLK), .E(N46), .QN(n336) );
  EDFFX1 PC1_reg_5_ ( .D(PC1_IN[5]), .CK(CLK), .E(N46), .QN(n340) );
  EDFFX1 PC1_reg_4_ ( .D(PC1_IN[4]), .CK(CLK), .E(N46), .QN(n338) );
  EDFFX1 PC1_reg_3_ ( .D(PC1_IN[3]), .CK(CLK), .E(N46), .QN(n339) );
  EDFFX1 PC1_reg_2_ ( .D(PC1_IN[2]), .CK(CLK), .E(N46), .QN(n341) );
  EDFFX1 PC1_reg_1_ ( .D(PC1_IN[1]), .CK(CLK), .E(N46), .QN(n333) );
  EDFFX1 PC1_reg_0_ ( .D(PC1_IN[0]), .CK(CLK), .E(N46), .QN(n334) );
  EDFFX1 DPTR_reg_13_ ( .D(DPTR_IN[13]), .CK(CLK), .E(N123), .Q(DPTR[13]), 
        .QN(n4000) );
  EDFFX1 DPTR_reg_11_ ( .D(DPTR_IN[11]), .CK(CLK), .E(N123), .Q(DPTR[11]), 
        .QN(n44) );
  EDFFX1 DPTR_reg_6_ ( .D(DPTR_IN[6]), .CK(CLK), .E(N112), .Q(DPTR[6]), .QN(
        n18) );
  EDFFX1 DPTR_reg_5_ ( .D(DPTR_IN[5]), .CK(CLK), .E(N112), .Q(DPTR[5]), .QN(
        n21) );
  EDFFX1 DPTR_reg_4_ ( .D(DPTR_IN[4]), .CK(CLK), .E(N112), .Q(DPTR[4]), .QN(
        n24) );
  EDFFX1 DPTR_reg_3_ ( .D(DPTR_IN[3]), .CK(CLK), .E(N112), .Q(DPTR[3]), .QN(
        n27) );
  EDFFX1 DPTR_reg_2_ ( .D(DPTR_IN[2]), .CK(CLK), .E(N112), .Q(DPTR[2]), .QN(
        n30) );
  EDFFX1 PC_reg_11_ ( .D(N92), .CK(CLK), .E(N184), .Q(PC[11]), .QN(n74) );
  EDFFX1 PC_reg_6_ ( .D(N87), .CK(CLK), .E(N217), .Q(PC[6]), .QN(n64) );
  INVX2 I732 ( .A(n147), .Y(n139) );
  EDFFX1 PC1_reg_15_ ( .D(PC1_IN[15]), .CK(CLK), .E(N46), .QN(n347) );
  EDFFX1 PC1_reg_14_ ( .D(PC1_IN[14]), .CK(CLK), .E(N46), .QN(n346) );
  EDFFX1 PC1_reg_13_ ( .D(PC1_IN[13]), .CK(CLK), .E(N46), .QN(n345) );
  INVX1 I733 ( .A(TMP2[3]), .Y(n493) );
  MX2X1 I734 ( .S0(n326), .B(PC[11]), .A(n638), .Y(PC1_NEW_11_) );
  NOR2X1 I735 ( .A(PC2_5_), .B(n631), .Y(n444) );
  NOR2X1 I736 ( .A(n631), .B(n625), .Y(n442) );
  OAI22X1 I737 ( .A0(n614), .A1(n7), .B0(n397), .B1(n610), .Y(XA_IN[9]) );
  OAI22X1 I738 ( .A0(n614), .A1(n10), .B0(n398), .B1(n611), .Y(XA_IN[8]) );
  OAI22X1 I739 ( .A0(n614), .A1(n4600), .B0(n429), .B1(n610), .Y(XA_IN[10]) );
  NAND3X1 I740 ( .A(n447), .B(n448), .C(n449), .Y(PC2_NEW_4_) );
  NOR2X1 I741 ( .A(PC2_2_), .B(n631), .Y(n453) );
  NOR2X1 I742 ( .A(n631), .B(n436), .Y(n451) );
  NOR2X1 I743 ( .A(PC2_7_), .B(n631), .Y(n439) );
  NOR2X1 I744 ( .A(PC2_9_), .B(n631), .Y(n435) );
  NOR2X1 I745 ( .A(n631), .B(n436), .Y(n434) );
  NOR2X1 I746 ( .A(PC2_11_), .B(n631), .Y(n456) );
  NOR2X1 I747 ( .A(n631), .B(n626), .Y(n450) );
  NOR2X1 I748 ( .A(PC2_8_), .B(n631), .Y(n438) );
  NOR2X1 I749 ( .A(n631), .B(n625), .Y(n437) );
  OAI21X1 I750 ( .A0(n403), .A1(n620), .B0(n513), .Y(N88) );
  AOI21X1 I751 ( .A0(user_init_pc[7]), .A1(n514), .B0(n515), .Y(n513) );
  AOI21X1 I752 ( .A0(n516), .A1(n517), .B0(n619), .Y(n515) );
  AOI21X1 I753 ( .A0(MDR[7]), .A1(n370), .B0(n518), .Y(n517) );
  OAI21X1 I754 ( .A0(n407), .A1(n621), .B0(n519), .Y(N87) );
  AOI21X1 I755 ( .A0(user_init_pc[6]), .A1(n514), .B0(n520), .Y(n519) );
  AOI21X1 I756 ( .A0(n521), .A1(n522), .B0(n394), .Y(n520) );
  AOI21X1 I757 ( .A0(MDR[6]), .A1(n370), .B0(n523), .Y(n522) );
  OAI21X1 I758 ( .A0(n410), .A1(n393), .B0(n524), .Y(N86) );
  AOI21X1 I759 ( .A0(user_init_pc[5]), .A1(n514), .B0(n525), .Y(n524) );
  AOI21X1 I760 ( .A0(n526), .A1(n527), .B0(n618), .Y(n525) );
  AOI21X1 I761 ( .A0(MDR[5]), .A1(n370), .B0(n528), .Y(n527) );
  OAI21X1 I762 ( .A0(n413), .A1(n620), .B0(n529), .Y(N85) );
  AOI21X1 I763 ( .A0(user_init_pc[4]), .A1(n514), .B0(n530), .Y(n529) );
  AOI21X1 I764 ( .A0(n531), .A1(n532), .B0(n619), .Y(n530) );
  AOI21X1 I765 ( .A0(MDR[4]), .A1(n370), .B0(n533), .Y(n532) );
  OAI21X1 I766 ( .A0(n415), .A1(n621), .B0(n534), .Y(N84) );
  AOI21X1 I767 ( .A0(user_init_pc[3]), .A1(n514), .B0(n535), .Y(n534) );
  AOI21X1 I768 ( .A0(n536), .A1(n537), .B0(n394), .Y(n535) );
  AOI21X1 I769 ( .A0(MDR[3]), .A1(n370), .B0(n538), .Y(n537) );
  OAI21X1 I770 ( .A0(n419), .A1(n393), .B0(n539), .Y(N83) );
  AOI21X1 I771 ( .A0(user_init_pc[2]), .A1(n514), .B0(n540), .Y(n539) );
  AOI21X1 I772 ( .A0(n541), .A1(n542), .B0(n618), .Y(n540) );
  AOI21X1 I773 ( .A0(MDR[2]), .A1(n370), .B0(n543), .Y(n542) );
  OAI21X1 I774 ( .A0(n422), .A1(n620), .B0(n544), .Y(N82) );
  AOI21X1 I775 ( .A0(user_init_pc[1]), .A1(n514), .B0(n545), .Y(n544) );
  AOI21X1 I776 ( .A0(n546), .A1(n547), .B0(n619), .Y(n545) );
  AOI21X1 I777 ( .A0(MDR[1]), .A1(n370), .B0(n548), .Y(n547) );
  OAI21X1 I778 ( .A0(n433), .A1(n621), .B0(n549), .Y(N81) );
  AOI21X1 I779 ( .A0(user_init_pc[0]), .A1(n514), .B0(n550), .Y(n549) );
  AOI21X1 I780 ( .A0(n551), .A1(n552), .B0(n394), .Y(n550) );
  AOI21X1 I781 ( .A0(MDR[0]), .A1(n370), .B0(n553), .Y(n552) );
  INVX1 I782 ( .A(JMP_PC_RES_EN), .Y(n605) );
  OAI22X1 I783 ( .A0(n3600), .A1(n97), .B0(n98), .B1(n118), .Y(PC1_IN[15]) );
  INVX1 I784 ( .A(TMP1[7]), .Y(n118) );
  OAI22X1 I785 ( .A0(n3800), .A1(n97), .B0(n98), .B1(n119), .Y(PC1_IN[14]) );
  INVX1 I786 ( .A(TMP1[6]), .Y(n119) );
  INVX1 I787 ( .A(TMP1[5]), .Y(n120) );
  OAI22X1 I788 ( .A0(n4200), .A1(n97), .B0(n98), .B1(n121), .Y(PC1_IN[12]) );
  INVX1 I789 ( .A(TMP1[4]), .Y(n121) );
  OAI22X1 I790 ( .A0(n44), .A1(n97), .B0(n98), .B1(n122), .Y(PC1_IN[11]) );
  INVX1 I791 ( .A(TMP1[3]), .Y(n122) );
  OAI22X1 I792 ( .A0(n4600), .A1(n97), .B0(n98), .B1(n1230), .Y(PC1_IN[10]) );
  INVX1 I793 ( .A(TMP1[2]), .Y(n1230) );
  OAI22X1 I794 ( .A0(n7), .A1(n97), .B0(n98), .B1(n99), .Y(PC1_IN[9]) );
  INVX1 I795 ( .A(TMP1[1]), .Y(n99) );
  OAI22X1 I796 ( .A0(n10), .A1(n97), .B0(n98), .B1(n100), .Y(PC1_IN[8]) );
  INVX1 I797 ( .A(TMP1[0]), .Y(n100) );
  NAND3X1 I798 ( .A(MAR[1]), .B(MAR[7]), .C(n2500), .Y(n381) );
  NAND3X1 I799 ( .A(n31), .B(n28), .C(n2490), .Y(n382) );
  NAND3X1 I800 ( .A(MAR[7]), .B(n51), .C(n2550), .Y(n383) );
  NAND3X1 I801 ( .A(n31), .B(n28), .C(n2540), .Y(n384) );
  NAND2X1 I802 ( .A(P0R[7]), .B(PC1_P0R_EN), .Y(n1320) );
  OAI211X1 I803 ( .A0(n13), .A1(n97), .B0(n101), .C0(n102), .Y(PC1_IN[7]) );
  NAND2X1 I804 ( .A(ACC[7]), .B(n105), .Y(n101) );
  AOI22X1 I805 ( .A0(N226), .A1(n377), .B0(n376), .B1(P0R[7]), .Y(n102) );
  OAI211X1 I806 ( .A0(n18), .A1(n97), .B0(n106), .C0(n107), .Y(PC1_IN[6]) );
  NAND2X1 I807 ( .A(ACC[6]), .B(n105), .Y(n106) );
  AOI22X1 I808 ( .A0(N225), .A1(n377), .B0(n376), .B1(P0R[6]), .Y(n107) );
  OAI211X1 I809 ( .A0(n21), .A1(n97), .B0(n108), .C0(n109), .Y(PC1_IN[5]) );
  NAND2X1 I810 ( .A(ACC[5]), .B(n105), .Y(n108) );
  AOI22X1 I811 ( .A0(N224), .A1(n377), .B0(n376), .B1(P0R[5]), .Y(n109) );
  OAI211X1 I812 ( .A0(n24), .A1(n97), .B0(n110), .C0(n111), .Y(PC1_IN[4]) );
  NAND2X1 I813 ( .A(ACC[4]), .B(n105), .Y(n110) );
  AOI22X1 I814 ( .A0(N223), .A1(n377), .B0(n376), .B1(P0R[4]), .Y(n111) );
  OAI211X1 I815 ( .A0(n27), .A1(n97), .B0(n1120), .C0(n113), .Y(PC1_IN[3]) );
  NAND2X1 I816 ( .A(ACC[3]), .B(n105), .Y(n1120) );
  AOI22X1 I817 ( .A0(N222), .A1(n377), .B0(n376), .B1(P0R[3]), .Y(n113) );
  OAI211X1 I818 ( .A0(n30), .A1(n97), .B0(n114), .C0(n115), .Y(PC1_IN[2]) );
  NAND2X1 I819 ( .A(ACC[2]), .B(n105), .Y(n114) );
  AOI22X1 I820 ( .A0(N221), .A1(n377), .B0(n376), .B1(P0R[2]), .Y(n115) );
  OAI211X1 I821 ( .A0(n33), .A1(n97), .B0(n116), .C0(n117), .Y(PC1_IN[1]) );
  NAND2X1 I822 ( .A(ACC[1]), .B(n105), .Y(n116) );
  AOI22X1 I823 ( .A0(N220), .A1(n377), .B0(n376), .B1(P0R[1]), .Y(n117) );
  OAI211X1 I824 ( .A0(n50), .A1(n97), .B0(n126), .C0(n127), .Y(PC1_IN[0]) );
  NAND2X1 I825 ( .A(ACC[0]), .B(n105), .Y(n126) );
  AOI22X1 I826 ( .A0(N219), .A1(n377), .B0(n376), .B1(P0R[0]), .Y(n127) );
  INVX1 I827 ( .A(n136), .Y(P0R_IN[7]) );
  INVX1 I828 ( .A(n140), .Y(P0R_IN[6]) );
  INVX1 I829 ( .A(n141), .Y(P0R_IN[5]) );
  INVX1 I830 ( .A(n1420), .Y(P0R_IN[4]) );
  INVX1 I831 ( .A(n143), .Y(P0R_IN[3]) );
  INVX1 I832 ( .A(n144), .Y(P0R_IN[2]) );
  INVX1 I833 ( .A(n145), .Y(P0R_IN[1]) );
  INVX1 I834 ( .A(n146), .Y(P0R_IN[0]) );
  OAI22X1 I835 ( .A0(n21), .A1(n643), .B0(n330), .B1(n65), .Y(PC2_IN[5]) );
  OAI22X1 I836 ( .A0(n24), .A1(n643), .B0(n330), .B1(n66), .Y(PC2_IN[4]) );
  OAI22X1 I837 ( .A0(n27), .A1(n643), .B0(n330), .B1(n67), .Y(PC2_IN[3]) );
  OAI22X1 I838 ( .A0(n30), .A1(n643), .B0(n330), .B1(n68), .Y(PC2_IN[2]) );
  OAI22X1 I839 ( .A0(n33), .A1(n643), .B0(n330), .B1(n69), .Y(PC2_IN[1]) );
  OAI22X1 I840 ( .A0(n50), .A1(n643), .B0(n330), .B1(n76), .Y(PC2_IN[0]) );
  OAI22X1 I841 ( .A0(n3600), .A1(n643), .B0(n330), .B1(n70), .Y(PC2_IN[15]) );
  OAI22X1 I842 ( .A0(n3800), .A1(n643), .B0(n330), .B1(n71), .Y(PC2_IN[14]) );
  OAI22X1 I843 ( .A0(n4000), .A1(n643), .B0(n330), .B1(n72), .Y(PC2_IN[13]) );
  OAI22X1 I844 ( .A0(n4200), .A1(n643), .B0(n330), .B1(n73), .Y(PC2_IN[12]) );
  OAI22X1 I845 ( .A0(n44), .A1(n643), .B0(n330), .B1(n74), .Y(PC2_IN[11]) );
  OAI22X1 I846 ( .A0(n4600), .A1(n643), .B0(n330), .B1(n75), .Y(PC2_IN[10]) );
  OAI22X1 I847 ( .A0(n7), .A1(n643), .B0(n330), .B1(n61), .Y(PC2_IN[9]) );
  OAI22X1 I848 ( .A0(n10), .A1(n643), .B0(n330), .B1(n62), .Y(PC2_IN[8]) );
  OAI22X1 I849 ( .A0(n13), .A1(n643), .B0(n330), .B1(n63), .Y(PC2_IN[7]) );
  OAI22X1 I850 ( .A0(n18), .A1(n643), .B0(n330), .B1(n64), .Y(PC2_IN[6]) );
  NAND2X1 I851 ( .A(PC_PC1_EN), .B(n638), .Y(n494) );
  AND2X2 I852 ( .A(user_init_pc_en), .B(n386), .Y(n385) );
  INVX1 I853 ( .A(MAR[5]), .Y(n22) );
  INVX1 I854 ( .A(MAR[0]), .Y(n51) );
  INVX1 I855 ( .A(MAR[4]), .Y(n25) );
  AND3X1 I856 ( .A(MAR[8]), .B(ID_WR_EN), .C(MAR[0]), .Y(n2500) );
  AND3X1 I857 ( .A(MAR[8]), .B(ID_WR_EN), .C(MAR[1]), .Y(n2550) );
  INVX1 I858 ( .A(MAR[2]), .Y(n31) );
  INVX1 I859 ( .A(MAR[1]), .Y(n423) );
  INVX1 I860 ( .A(user_init_pc[13]), .Y(n480) );
  INVX1 I861 ( .A(user_init_pc[10]), .Y(n499) );
  INVX1 I862 ( .A(user_init_pc[9]), .Y(n506) );
  EDFFX1 PC2_reg_12_ ( .D(PC2_IN[12]), .CK(CLK), .E(N59), .QN(n641) );
  EDFFX1 PC2_reg_10_ ( .D(PC2_IN[10]), .CK(CLK), .E(N59), .QN(n642) );
  EDFFX1 PC2_reg_11_ ( .D(PC2_IN[11]), .CK(CLK), .E(N59), .Q(PC2_11_) );
  EDFFX1 PC2_reg_9_ ( .D(PC2_IN[9]), .CK(CLK), .E(N59), .Q(PC2_9_) );
  EDFFX1 PC2_reg_8_ ( .D(PC2_IN[8]), .CK(CLK), .E(N59), .Q(PC2_8_) );
  EDFFX1 PC2_reg_7_ ( .D(PC2_IN[7]), .CK(CLK), .E(N59), .Q(PC2_7_) );
  EDFFX1 PC2_reg_6_ ( .D(PC2_IN[6]), .CK(CLK), .E(N59), .Q(n320) );
  EDFFX1 PC2_reg_5_ ( .D(PC2_IN[5]), .CK(CLK), .E(N59), .Q(PC2_5_) );
  EDFFX1 PC2_reg_3_ ( .D(PC2_IN[3]), .CK(CLK), .E(N59), .Q(PC2_3_) );
  EDFFX1 PC2_reg_2_ ( .D(PC2_IN[2]), .CK(CLK), .E(N59), .Q(PC2_2_) );
  EDFFX1 PC2_reg_1_ ( .D(PC2_IN[1]), .CK(CLK), .E(N59), .Q(PC2_1_) );
  EDFFX1 PC2_reg_0_ ( .D(PC2_IN[0]), .CK(CLK), .E(N59), .QN(n367) );
  EDFFX1 PC2_reg_15_ ( .D(PC2_IN[15]), .CK(CLK), .E(N59), .Q(n323) );
  EDFFX1 PC2_reg_14_ ( .D(PC2_IN[14]), .CK(CLK), .E(N59), .QN(n639) );
  EDFFX1 PC2_reg_13_ ( .D(PC2_IN[13]), .CK(CLK), .E(N59), .QN(n640) );
  EDFFTRX1 rel_minus_reg ( .D(n129), .CK(CLK), .E(PC1_P0R_EN), .RN(n387), .Q(
        rel_minus) );
  EDFFX1 BIT_REG_reg_1_ ( .D(P0_IN[1]), .CK(CLK), .E(JBC_BIT_EN), .Q(
        BIT_REG[1]) );
  EDFFX1 BIT_REG_reg_0_ ( .D(P0_IN[0]), .CK(CLK), .E(JBC_BIT_EN), .Q(
        BIT_REG[0]) );
  EDFFX1 BIT_REG_reg_2_ ( .D(P0_IN[2]), .CK(CLK), .E(JBC_BIT_EN), .Q(
        BIT_REG[2]) );
  EDFFX1 XA_reg_11_ ( .D(XA_IN[11]), .CK(CLK), .E(N132), .Q(XA[11]) );
  EDFFX1 XA_reg_10_ ( .D(XA_IN[10]), .CK(CLK), .E(N132), .Q(XA[10]) );
  EDFFX1 XA_reg_9_ ( .D(XA_IN[9]), .CK(CLK), .E(N132), .Q(XA[9]) );
  EDFFX1 XA_reg_8_ ( .D(XA_IN[8]), .CK(CLK), .E(N132), .Q(XA[8]) );
  EDFFX1 XA_reg_7_ ( .D(XA_IN[7]), .CK(CLK), .E(N142), .Q(XA[7]) );
  EDFFX1 XA_reg_6_ ( .D(XA_IN[6]), .CK(CLK), .E(N142), .Q(XA[6]) );
  EDFFX1 XA_reg_5_ ( .D(XA_IN[5]), .CK(CLK), .E(N142), .Q(XA[5]) );
  EDFFX1 XA_reg_4_ ( .D(XA_IN[4]), .CK(CLK), .E(N142), .Q(XA[4]) );
  EDFFX1 XA_reg_3_ ( .D(XA_IN[3]), .CK(CLK), .E(N142), .Q(XA[3]) );
  EDFFX1 XA_reg_2_ ( .D(XA_IN[2]), .CK(CLK), .E(N142), .Q(XA[2]) );
  EDFFX1 XA_reg_1_ ( .D(XA_IN[1]), .CK(CLK), .E(N142), .Q(XA[1]) );
  EDFFX1 XA_reg_0_ ( .D(XA_IN[0]), .CK(CLK), .E(N142), .Q(XA[0]) );
  OAI21X1 I863 ( .A0(n426), .A1(n623), .B0(n588), .Y(DPTR_IN[13]) );
  OAI21X1 I864 ( .A0(n426), .A1(n459), .B0(n475), .Y(N94) );
  NOR2X1 I865 ( .A(n631), .B(n626), .Y(n455) );
  NAND2X1 I866 ( .A(n445), .B(n446), .Y(n452) );
  NAND3X1 I867 ( .A(n445), .B(PC2_4_), .C(n446), .Y(n449) );
  NOR2X1 I868 ( .A(n436), .B(n446), .Y(n458) );
  NOR2X1 I869 ( .A(n626), .B(n446), .Y(n457) );
  NAND2X1 I870 ( .A(n445), .B(n446), .Y(n443) );
  AOI22X1 I871 ( .A0(TMP2[2]), .A1(n328), .B0(n622), .B1(IR75[7]), .Y(n500) );
  MXI2X1 I872 ( .S0(n326), .B(n62), .A(n342), .Y(PC1_NEW_8_) );
  MXI2X2 I873 ( .S0(n326), .B(n64), .A(n336), .Y(PC1_NEW_6_) );
  OAI21X1 I874 ( .A0(n428), .A1(n558), .B0(n592), .Y(DPTR_IN[11]) );
  MXI2X1 I875 ( .S0(n326), .B(n71), .A(n346), .Y(PC1_NEW_14_) );
  MXI2X1 I876 ( .S0(n326), .B(n72), .A(n345), .Y(PC1_NEW_13_) );
  MXI2X1 I877 ( .S0(n326), .B(n73), .A(n344), .Y(PC1_NEW_12_) );
  MXI2X1 I878 ( .S0(n326), .B(n75), .A(n343), .Y(PC1_NEW_10_) );
  OAI21X1 I879 ( .A0(n424), .A1(n459), .B0(n4601), .Y(N96) );
  OAI21X1 I880 ( .A0(n424), .A1(n624), .B0(n584), .Y(DPTR_IN[15]) );
  MXI2X4 I881 ( .S0(n326), .B(n76), .A(n334), .Y(PC1_NEW_0_) );
  MXI2X4 I882 ( .S0(n627), .B(N241), .A(N257), .Y(n428) );
  MXI2X4 I883 ( .S0(CY), .B(C_PC_RES_EN), .A(C_B_PC_RES_EN), .Y(n602) );
  MXI2X4 I884 ( .S0(F5), .B(F5_PC_RES_EN), .A(F5_B_PC_RES_EN), .Y(n601) );
  MEM_INTF_DW01_add_16_1 add_294 ( .A({PC2_NEW_15_, PC2_NEW_14_, PC2_NEW_13_, 
        PC2_NEW_12_, PC2_NEW_11_, PC2_NEW_10_, PC2_NEW_9_, PC2_NEW_8_, n327, 
        PC2_NEW_6_, PC2_NEW_5_, PC2_NEW_4_, PC2_NEW_3_, PC2_NEW_2_, PC2_NEW_1_, 
        n366}), .B({n348, PC1_NEW_14_, PC1_NEW_13_, PC1_NEW_12_, PC1_NEW_11_, 
        PC1_NEW_10_, n325, PC1_NEW_8_, PC1_NEW_7_, PC1_NEW_6_, PC1_NEW_5_, 
        PC1_NEW_4_, PC1_NEW_3_, PC1_NEW_2_, PC1_NEW_1_, PC1_NEW_0_}), .CI(1'b0), .SUM({N261, N260, N259, N258, N257, N256, N255, N254, N253, N252, N251, N250, 
        N249, N248, N247, N246}) );
  MEM_INTF_DW01_sub_16_1 sub_294 ( .A({PC2_NEW_15_, PC2_NEW_14_, PC2_NEW_13_, 
        PC2_NEW_12_, PC2_NEW_11_, PC2_NEW_10_, PC2_NEW_9_, n349, PC2_NEW_7_, 
        PC2_NEW_6_, PC2_NEW_5_, PC2_NEW_4_, PC2_NEW_3_, PC2_NEW_2_, PC2_NEW_1_, 
        n366}), .B({n348, PC1_NEW_14_, PC1_NEW_13_, PC1_NEW_12_, PC1_NEW_11_, 
        PC1_NEW_10_, PC1_NEW_9_, PC1_NEW_8_, PC1_NEW_7_, PC1_NEW_6_, 
        PC1_NEW_5_, PC1_NEW_4_, PC1_NEW_3_, PC1_NEW_2_, PC1_NEW_1_, PC1_NEW_0_}), .CI(1'b0), .DIFF({N245, N244, N243, N242, N241, N240, N239, N238, N237, 
        N236, N235, N234, N233, N232, N231, N230}) );
  MEM_INTF_DW01_inc_8_0 add_248 ( .A({N35, N36, N37, N38, N39, N40, N41, N42}), 
        .SUM({N226, N225, N224, N223, N222, N221, N220, N219}) );
endmodule


module MEM_INTF_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CMPR22X1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  CMPR22X1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  CMPR22X1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  CMPR22X1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  CMPR22X1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  CMPR22X1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  XOR2X1 U5 ( .A(carry_7_), .B(A[7]), .Y(SUM[7]) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module MEM_INTF_DW01_sub_16_1 ( A, B, CI, DIFF, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] DIFF;
  input CI;
  output CO;
  wire   n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77,
         n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91,
         n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104,
         n105, n106, n107, n108, n109, n110, n111, n112, n113, n114, n115,
         n116, n117, n118, n119, n120, n121, n122, n123, n124, n125, n126,
         n127, n128, n129, n130, n131, n132, n133, n134, n135, n136, n137,
         n138, n139, n140, n141, n142, n143, n144, n145, n146, n147, n148,
         n149, n150, n151, n152, n153, n154, n155, n156, n157, n158, n159,
         n160, n161, n162, n163, n164, n165, n166, n167, n168, n169, n170,
         n171, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181,
         n182, n183, n184, n185, n186, n187, n188, n189, n190, n191, n192,
         n193, n194, n195, n196, n197, n198, n199, n200, n201, n202, n203,
         n204, n205, n206, n207, n208, n209, n210, n211, n212, n213, n214,
         n215, n216, n217, n218, n219, n220, n221, n222, n223, n224, n225;

  OAI2BB1X1 U4 ( .A0N(n214), .A1N(A[14]), .B0(n185), .Y(n138) );
  XNOR2X1 U5 ( .A(n112), .B(n118), .Y(DIFF[3]) );
  NAND3X1 U6 ( .A(n186), .B(n58), .C(n183), .Y(n167) );
  AND2X2 U7 ( .A(n84), .B(n174), .Y(n181) );
  AND3X2 U8 ( .A(n188), .B(n186), .C(n187), .Y(n50) );
  OR2X2 U9 ( .A(n215), .B(n203), .Y(n187) );
  AOI31X2 U10 ( .A0(n50), .A1(n61), .A2(n181), .B0(n175), .Y(n159) );
  OR2X2 U11 ( .A(n200), .B(B[11]), .Y(n152) );
  AOI21X1 U12 ( .A0(n178), .A1(n84), .B0(n179), .Y(n73) );
  NAND2BX1 U13 ( .AN(n196), .B(n213), .Y(n106) );
  OR2X1 U14 ( .A(n213), .B(A[2]), .Y(n58) );
  AOI22X1 U15 ( .A0(n136), .A1(n185), .B0(n201), .B1(n214), .Y(n135) );
  NAND4X1 U16 ( .A(n102), .B(n97), .C(n98), .D(n183), .Y(n94) );
  NAND2BX1 U17 ( .AN(n142), .B(n146), .Y(n144) );
  OAI2BB1X1 U18 ( .A0N(n111), .A1N(n51), .B0(n186), .Y(n95) );
  INVX1 U19 ( .A(n55), .Y(n51) );
  NAND2BX1 U20 ( .AN(n210), .B(n198), .Y(n149) );
  OAI2BB1X1 U21 ( .A0N(n134), .A1N(n154), .B0(n158), .Y(n156) );
  XOR2X1 U22 ( .A(n70), .B(n54), .Y(DIFF[9]) );
  NOR2X2 U23 ( .A(n194), .B(n208), .Y(n69) );
  OAI2BB1X1 U24 ( .A0N(n52), .A1N(n57), .B0(n150), .Y(n151) );
  INVX1 U25 ( .A(n64), .Y(n52) );
  NAND2BX1 U26 ( .AN(n211), .B(n193), .Y(n184) );
  AOI22X1 U27 ( .A0(n188), .A1(n72), .B0(n75), .B1(n53), .Y(n54) );
  INVX1 U28 ( .A(n71), .Y(n53) );
  OAI2BB1X1 U29 ( .A0N(n122), .A1N(n218), .B0(n128), .Y(n130) );
  OR3X1 U30 ( .A(n64), .B(n150), .C(n148), .Y(n59) );
  AND2X1 U31 ( .A(n199), .B(n220), .Y(n63) );
  NAND2BX1 U32 ( .AN(n214), .B(n202), .Y(n185) );
  OR2X1 U33 ( .A(n212), .B(n205), .Y(n154) );
  OR2X2 U34 ( .A(n209), .B(A[8]), .Y(n188) );
  OAI21X1 U35 ( .A0(n73), .A1(n176), .B0(n177), .Y(n175) );
  OAI2BB1X1 U36 ( .A0N(n184), .A1N(n142), .B0(n141), .Y(n136) );
  OAI2BB1X1 U37 ( .A0N(n149), .A1N(n148), .B0(n147), .Y(n142) );
  INVX1 U38 ( .A(n191), .Y(n190) );
  NAND2X2 U39 ( .A(n159), .B(n160), .Y(n134) );
  AOI21X1 U40 ( .A0(n161), .A1(n162), .B0(n163), .Y(n160) );
  INVX1 U41 ( .A(B[1]), .Y(n219) );
  INVX1 U42 ( .A(n225), .Y(n224) );
  NAND2X1 U43 ( .A(n216), .B(n189), .Y(n165) );
  NAND2X1 U44 ( .A(n216), .B(n189), .Y(n84) );
  INVX1 U45 ( .A(A[1]), .Y(n122) );
  INVX1 U46 ( .A(n69), .Y(n186) );
  NAND2X1 U47 ( .A(n224), .B(n207), .Y(n102) );
  INVX1 U48 ( .A(n84), .Y(n83) );
  OAI2BB1X1 U49 ( .A0N(n153), .A1N(n68), .B0(n152), .Y(n148) );
  XNOR2X1 U50 ( .A(n132), .B(n56), .Y(DIFF[15]) );
  INVX1 U51 ( .A(n217), .Y(n216) );
  NAND3X1 U52 ( .A(n165), .B(n188), .C(n166), .Y(n71) );
  INVX1 U53 ( .A(n204), .Y(n203) );
  NAND2X1 U54 ( .A(B[0]), .B(n129), .Y(n101) );
  NAND2X1 U55 ( .A(n194), .B(n208), .Y(n96) );
  NAND2X1 U56 ( .A(n190), .B(n209), .Y(n74) );
  NAND4X2 U57 ( .A(n93), .B(n94), .C(n95), .D(n96), .Y(n75) );
  NAND4BX1 U58 ( .AN(n63), .B(n103), .C(n102), .D(n104), .Y(n93) );
  INVX1 U59 ( .A(n207), .Y(n206) );
  NAND2X1 U60 ( .A(A[7]), .B(n217), .Y(n82) );
  XOR2X1 U61 ( .A(B[15]), .B(A[15]), .Y(n56) );
  NAND2X2 U62 ( .A(n119), .B(n120), .Y(n112) );
  AOI21X1 U63 ( .A0(n127), .A1(n58), .B0(n123), .Y(n119) );
  INVX1 U64 ( .A(n195), .Y(n194) );
  INVX1 U65 ( .A(n223), .Y(n222) );
  INVX1 U66 ( .A(n106), .Y(n123) );
  NOR2BX1 U67 ( .AN(n101), .B(n100), .Y(n97) );
  NOR2BX1 U68 ( .AN(n206), .B(n224), .Y(n182) );
  NAND2X1 U69 ( .A(B[11]), .B(n200), .Y(n153) );
  OAI21X1 U70 ( .A0(n71), .A1(n164), .B0(n76), .Y(n163) );
  NOR2X1 U71 ( .A(n222), .B(n180), .Y(n178) );
  INVX1 U72 ( .A(n82), .Y(n179) );
  NAND2X1 U73 ( .A(n149), .B(n147), .Y(n150) );
  AOI21X1 U74 ( .A0(n126), .A1(n101), .B0(n127), .Y(n125) );
  OAI21X1 U75 ( .A0(n143), .A1(n144), .B0(n145), .Y(DIFF[13]) );
  INVX1 U76 ( .A(B[6]), .Y(n223) );
  INVX1 U77 ( .A(n219), .Y(n218) );
  INVX1 U78 ( .A(n221), .Y(n220) );
  AND2X2 U79 ( .A(n182), .B(n183), .Y(n55) );
  NAND2X1 U80 ( .A(A[4]), .B(n221), .Y(n111) );
  INVX1 U81 ( .A(A[0]), .Y(n129) );
  NAND2X1 U82 ( .A(n59), .B(n151), .Y(DIFF[12]) );
  INVX1 U83 ( .A(n148), .Y(n57) );
  BUFX2 U84 ( .A(A[10]), .Y(n205) );
  NAND2X1 U85 ( .A(n60), .B(n111), .Y(n61) );
  INVX1 U86 ( .A(n55), .Y(n60) );
  NAND2X1 U87 ( .A(n203), .B(n215), .Y(n76) );
  AND2X2 U88 ( .A(n66), .B(n149), .Y(n65) );
  INVX1 U89 ( .A(A[6]), .Y(n180) );
  OAI2BB1X1 U90 ( .A0N(n112), .A1N(n62), .B0(n110), .Y(n107) );
  AND2X1 U91 ( .A(n183), .B(n102), .Y(n62) );
  AND2X1 U92 ( .A(n66), .B(n134), .Y(n64) );
  NOR2BX1 U93 ( .AN(n185), .B(n137), .Y(n133) );
  NAND2X1 U94 ( .A(n65), .B(n184), .Y(n137) );
  INVX1 U95 ( .A(n96), .Y(n109) );
  INVX1 U96 ( .A(n58), .Y(n99) );
  NAND2X1 U97 ( .A(n153), .B(n152), .Y(n155) );
  NAND2X1 U98 ( .A(n184), .B(n141), .Y(n143) );
  NAND2X1 U99 ( .A(n187), .B(n76), .Y(n70) );
  NAND2X1 U100 ( .A(n88), .B(n90), .Y(n91) );
  AND2X1 U101 ( .A(n154), .B(n158), .Y(n67) );
  OAI21X2 U102 ( .A0(n155), .A1(n156), .B0(n157), .Y(DIFF[11]) );
  NOR2X1 U103 ( .A(n169), .B(n170), .Y(n161) );
  NAND2X1 U104 ( .A(A[1]), .B(n219), .Y(n105) );
  XNOR2X1 U105 ( .A(n130), .B(n131), .Y(DIFF[1]) );
  NAND2X1 U106 ( .A(n192), .B(n211), .Y(n141) );
  NAND2X1 U107 ( .A(n222), .B(n180), .Y(n88) );
  NAND2X1 U108 ( .A(A[6]), .B(n223), .Y(n90) );
  NAND2X1 U109 ( .A(n205), .B(n212), .Y(n158) );
  NAND2X1 U110 ( .A(n197), .B(n210), .Y(n147) );
  NAND2X1 U111 ( .A(n224), .B(n207), .Y(n115) );
  NAND2X1 U112 ( .A(n206), .B(n225), .Y(n117) );
  NOR2BX1 U113 ( .AN(n222), .B(A[6]), .Y(n85) );
  INVX1 U114 ( .A(n193), .Y(n192) );
  INVX1 U115 ( .A(n202), .Y(n201) );
  INVX1 U116 ( .A(n198), .Y(n197) );
  AOI21X1 U117 ( .A0(n140), .A1(n134), .B0(n136), .Y(n139) );
  INVX1 U118 ( .A(n137), .Y(n140) );
  NOR2X1 U119 ( .A(n109), .B(n69), .Y(n108) );
  NOR2X1 U120 ( .A(n69), .B(n99), .Y(n98) );
  NAND2X1 U121 ( .A(n75), .B(n91), .Y(n92) );
  NAND2X1 U122 ( .A(n143), .B(n144), .Y(n145) );
  NAND2X1 U123 ( .A(n155), .B(n156), .Y(n157) );
  NOR2X1 U124 ( .A(n69), .B(n99), .Y(n103) );
  NAND2X1 U125 ( .A(n73), .B(n74), .Y(n72) );
  AOI21X1 U126 ( .A0(n79), .A1(n75), .B0(n80), .Y(n78) );
  AOI21X1 U127 ( .A0(n81), .A1(n82), .B0(n83), .Y(n80) );
  NOR2X1 U128 ( .A(n85), .B(n83), .Y(n79) );
  AOI21X1 U129 ( .A0(n112), .A1(n115), .B0(n116), .Y(n114) );
  INVX1 U130 ( .A(n117), .Y(n116) );
  AOI21X1 U131 ( .A0(n75), .A1(n88), .B0(n89), .Y(n87) );
  INVX1 U132 ( .A(n90), .Y(n89) );
  NOR2BX1 U133 ( .AN(n111), .B(n55), .Y(n110) );
  NAND2X1 U134 ( .A(n115), .B(n117), .Y(n118) );
  OAI2BB1X1 U135 ( .A0N(n133), .A1N(n134), .B0(n135), .Y(n132) );
  NAND2X1 U136 ( .A(n109), .B(n187), .Y(n164) );
  NAND2X1 U137 ( .A(n82), .B(n84), .Y(n86) );
  NAND2X1 U138 ( .A(n187), .B(n188), .Y(n176) );
  NAND2X1 U139 ( .A(n74), .B(n188), .Y(n77) );
  NAND2X1 U140 ( .A(n111), .B(n183), .Y(n113) );
  NAND2X1 U141 ( .A(n106), .B(n58), .Y(n124) );
  NAND2BX1 U142 ( .AN(n74), .B(n187), .Y(n177) );
  NOR2X1 U143 ( .A(n167), .B(n168), .Y(n162) );
  NAND2X1 U144 ( .A(n187), .B(n188), .Y(n168) );
  NAND2X1 U145 ( .A(n105), .B(n106), .Y(n104) );
  AND2X2 U146 ( .A(n154), .B(n153), .Y(n66) );
  OAI21X1 U147 ( .A0(n75), .A1(n91), .B0(n92), .Y(DIFF[6]) );
  XOR2X1 U148 ( .A(n86), .B(n87), .Y(DIFF[7]) );
  XOR2X1 U149 ( .A(n107), .B(n108), .Y(DIFF[5]) );
  XOR2X1 U150 ( .A(n113), .B(n114), .Y(DIFF[4]) );
  XOR2X1 U151 ( .A(n124), .B(n125), .Y(DIFF[2]) );
  NAND3X1 U152 ( .A(n101), .B(n58), .C(n121), .Y(n120) );
  NAND2X1 U153 ( .A(n218), .B(n122), .Y(n121) );
  NAND2X1 U154 ( .A(n222), .B(n180), .Y(n166) );
  NAND2X1 U155 ( .A(n218), .B(n122), .Y(n126) );
  INVX1 U156 ( .A(n128), .Y(n127) );
  AND2X2 U157 ( .A(n205), .B(n212), .Y(n68) );
  NOR2BX1 U158 ( .AN(n218), .B(A[1]), .Y(n100) );
  NAND2X1 U159 ( .A(n222), .B(n180), .Y(n174) );
  NAND2X1 U160 ( .A(A[1]), .B(n219), .Y(n128) );
  NAND2X1 U161 ( .A(n218), .B(n122), .Y(n173) );
  NAND2X1 U162 ( .A(A[6]), .B(n223), .Y(n81) );
  NAND3X1 U163 ( .A(n102), .B(n165), .C(n174), .Y(n169) );
  OAI22X1 U164 ( .A0(n171), .A1(n172), .B0(n123), .B1(n173), .Y(n170) );
  NAND2X1 U165 ( .A(n106), .B(n129), .Y(n171) );
  NAND2X1 U166 ( .A(n220), .B(n199), .Y(n183) );
  XOR2X1 U167 ( .A(n138), .B(n139), .Y(DIFF[14]) );
  XOR2X1 U168 ( .A(n77), .B(n78), .Y(DIFF[8]) );
  OAI21X1 U169 ( .A0(B[0]), .A1(n129), .B0(n131), .Y(DIFF[0]) );
  INVX1 U170 ( .A(B[3]), .Y(n225) );
  INVX1 U171 ( .A(B[7]), .Y(n217) );
  OAI21X1 U172 ( .A0(n218), .A1(n122), .B0(B[0]), .Y(n172) );
  INVX1 U173 ( .A(B[4]), .Y(n221) );
  INVX1 U174 ( .A(A[3]), .Y(n207) );
  NAND2X1 U175 ( .A(B[0]), .B(n129), .Y(n131) );
  INVX1 U176 ( .A(B[10]), .Y(n212) );
  INVX1 U177 ( .A(B[12]), .Y(n210) );
  INVX1 U178 ( .A(A[4]), .Y(n199) );
  INVX1 U179 ( .A(A[13]), .Y(n193) );
  INVX1 U180 ( .A(A[12]), .Y(n198) );
  INVX1 U181 ( .A(A[14]), .Y(n202) );
  INVX1 U182 ( .A(A[5]), .Y(n195) );
  INVX1 U183 ( .A(A[8]), .Y(n191) );
  INVX1 U184 ( .A(A[11]), .Y(n200) );
  INVX1 U185 ( .A(A[9]), .Y(n204) );
  INVX1 U186 ( .A(A[7]), .Y(n189) );
  INVX1 U187 ( .A(B[13]), .Y(n211) );
  INVX1 U188 ( .A(B[14]), .Y(n214) );
  INVX1 U189 ( .A(B[8]), .Y(n209) );
  INVX1 U190 ( .A(B[9]), .Y(n215) );
  INVX1 U191 ( .A(B[2]), .Y(n213) );
  INVX1 U192 ( .A(B[5]), .Y(n208) );
  INVX1 U193 ( .A(A[2]), .Y(n196) );
  XOR2X1 U194 ( .A(n134), .B(n67), .Y(DIFF[10]) );
  NAND2X1 U195 ( .A(n65), .B(n134), .Y(n146) );
endmodule


module MEM_INTF_DW01_add_16_1 ( A, B, CI, SUM, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136,
         n137, n138, n139, n140, n141, n142, n143, n144, n145, n146, n147,
         n148, n149, n150, n151, n152, n153, n154, n155, n156, n157, n158,
         n159, n160, n161, n162, n163, n164, n165, n166, n167, n168, n169,
         n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180,
         n181, n182, n183, n184, n185, n186, n187, n188, n189, n190, n191,
         n192, n193, n194, n195, n196, n197, n198, n199, n200, n201, n202,
         n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, n213,
         n214, n215, n216, n217, n218, n219, n220, n221, n222, n223, n224,
         n225, n226, n227, n228, n229, n230, n231, n232, n233, n234, n235,
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246;

  INVX2 U5 ( .A(n215), .Y(n214) );
  AND2X2 U6 ( .A(n80), .B(n86), .Y(n89) );
  XNOR2X1 U7 ( .A(n49), .B(n116), .Y(SUM[5]) );
  AOI2BB1X1 U8 ( .A0N(n79), .A1N(n73), .B0(n197), .Y(n195) );
  XNOR2X1 U9 ( .A(n87), .B(n106), .Y(SUM[6]) );
  NAND3BX1 U10 ( .AN(n62), .B(n184), .C(n66), .Y(n196) );
  XNOR2X1 U11 ( .A(n121), .B(n122), .Y(SUM[4]) );
  AOI2BB2X1 U12 ( .A0N(n245), .A1N(n246), .B0(n232), .B1(n236), .Y(n193) );
  NOR3X1 U13 ( .A(n73), .B(n80), .C(n62), .Y(n197) );
  INVX1 U14 ( .A(n184), .Y(n73) );
  NAND2BX1 U15 ( .AN(n235), .B(n232), .Y(n86) );
  AND3X1 U16 ( .A(n113), .B(n114), .C(n184), .Y(n190) );
  NAND2X1 U17 ( .A(n240), .B(n234), .Y(n119) );
  NOR2X1 U18 ( .A(n66), .B(n78), .Y(n77) );
  NAND2X1 U19 ( .A(n224), .B(n211), .Y(n114) );
  NAND2X1 U20 ( .A(n226), .B(n203), .Y(n163) );
  AND2X1 U21 ( .A(n245), .B(n246), .Y(n67) );
  AOI22X1 U22 ( .A0(n120), .A1(n58), .B0(n115), .B1(n113), .Y(n49) );
  AND2X2 U23 ( .A(n176), .B(n172), .Y(n178) );
  NAND2X1 U24 ( .A(n230), .B(n207), .Y(n157) );
  OAI2BB1X1 U25 ( .A0N(n119), .A1N(n120), .B0(n124), .Y(n121) );
  NAND3X1 U26 ( .A(n94), .B(n95), .C(n107), .Y(n87) );
  AND2X1 U27 ( .A(n74), .B(n184), .Y(n72) );
  OR2X1 U28 ( .A(n52), .B(n168), .Y(n53) );
  INVX1 U29 ( .A(B[1]), .Y(n244) );
  INVX1 U30 ( .A(n232), .Y(n231) );
  INVX1 U31 ( .A(n236), .Y(n235) );
  INVX2 U32 ( .A(n143), .Y(n152) );
  INVX2 U33 ( .A(n244), .Y(n243) );
  NAND2X2 U34 ( .A(n176), .B(n177), .Y(n173) );
  NAND2X2 U35 ( .A(n173), .B(n174), .Y(n175) );
  AND2X2 U36 ( .A(n195), .B(n196), .Y(n61) );
  OR2X2 U37 ( .A(n237), .B(A[10]), .Y(n172) );
  OR2X2 U38 ( .A(n227), .B(n212), .Y(n184) );
  NAND2BX1 U39 ( .AN(n158), .B(n157), .Y(n144) );
  INVX1 U40 ( .A(n234), .Y(n233) );
  NAND2X1 U41 ( .A(n172), .B(n171), .Y(n166) );
  NAND2X1 U42 ( .A(n171), .B(n165), .Y(n174) );
  NAND3X2 U43 ( .A(n51), .B(n61), .C(n179), .Y(n50) );
  NAND2X1 U44 ( .A(B[11]), .B(n208), .Y(n165) );
  OAI21X1 U45 ( .A0(n152), .A1(n144), .B0(n153), .Y(n149) );
  INVX1 U46 ( .A(n240), .Y(n239) );
  INVX1 U47 ( .A(n87), .Y(n75) );
  OAI21X1 U48 ( .A0(A[1]), .A1(n243), .B0(n135), .Y(n136) );
  NAND2X1 U49 ( .A(n54), .B(n55), .Y(n56) );
  NAND3BX1 U50 ( .AN(n101), .B(n126), .C(n127), .Y(n120) );
  AND2X2 U51 ( .A(n74), .B(n180), .Y(n51) );
  OAI21X2 U52 ( .A0(n173), .A1(n174), .B0(n175), .Y(SUM[11]) );
  NAND2BX1 U53 ( .AN(n166), .B(n163), .Y(n158) );
  OAI21X1 U54 ( .A0(n64), .A1(n162), .B0(n163), .Y(n155) );
  NAND2X1 U55 ( .A(n164), .B(n165), .Y(n162) );
  NAND2X1 U56 ( .A(n229), .B(n206), .Y(n156) );
  INVX1 U57 ( .A(n242), .Y(n241) );
  INVX1 U58 ( .A(n201), .Y(n200) );
  INVX1 U59 ( .A(n238), .Y(n237) );
  INVX1 U60 ( .A(n213), .Y(n212) );
  BUFX3 U61 ( .A(B[6]), .Y(n246) );
  OAI21X1 U62 ( .A0(n154), .A1(n155), .B0(n156), .Y(n145) );
  INVX1 U63 ( .A(n157), .Y(n154) );
  OAI21X1 U64 ( .A0(n108), .A1(n109), .B0(n110), .Y(n107) );
  NAND2X1 U65 ( .A(n53), .B(n169), .Y(SUM[12]) );
  OAI21X1 U66 ( .A0(n149), .A1(n150), .B0(n151), .Y(SUM[14]) );
  NOR2X1 U67 ( .A(n70), .B(n198), .Y(SUM[0]) );
  NAND2X1 U68 ( .A(n56), .B(n161), .Y(SUM[13]) );
  INVX1 U69 ( .A(n218), .Y(n217) );
  INVX1 U70 ( .A(B[7]), .Y(n236) );
  OAI21X1 U71 ( .A0(n137), .A1(n57), .B0(n138), .Y(SUM[15]) );
  OAI21X1 U72 ( .A0(n152), .A1(n166), .B0(n170), .Y(n52) );
  OAI21X1 U73 ( .A0(n152), .A1(n166), .B0(n170), .Y(n167) );
  NAND2X1 U74 ( .A(n218), .B(n199), .Y(n194) );
  INVX1 U75 ( .A(n160), .Y(n55) );
  NAND2X2 U76 ( .A(n193), .B(n194), .Y(n76) );
  INVX1 U77 ( .A(n159), .Y(n54) );
  OAI21X1 U78 ( .A0(n152), .A1(n158), .B0(n155), .Y(n159) );
  OR2X1 U79 ( .A(n241), .B(A[4]), .Y(n113) );
  NAND2X1 U80 ( .A(n235), .B(n231), .Y(n80) );
  AND2X2 U81 ( .A(n139), .B(n140), .Y(n57) );
  NAND3X2 U82 ( .A(n51), .B(n61), .C(n179), .Y(n143) );
  AND2X2 U83 ( .A(n65), .B(n171), .Y(n64) );
  NOR2X1 U84 ( .A(n76), .B(n192), .Y(n191) );
  INVX1 U85 ( .A(n98), .Y(n110) );
  NAND2X1 U86 ( .A(n123), .B(n124), .Y(n115) );
  AND2X1 U87 ( .A(n119), .B(n113), .Y(n58) );
  NOR2BX1 U88 ( .AN(n80), .B(n66), .Y(n84) );
  NAND2X1 U89 ( .A(n163), .B(n164), .Y(n168) );
  NAND2X1 U90 ( .A(n220), .B(n201), .Y(n128) );
  NOR2X1 U91 ( .A(n182), .B(n183), .Y(n181) );
  NAND3X1 U92 ( .A(n63), .B(n114), .C(n119), .Y(n98) );
  NAND2X1 U93 ( .A(n219), .B(n200), .Y(n112) );
  NAND2X1 U94 ( .A(n225), .B(n202), .Y(n164) );
  NAND2X1 U95 ( .A(n239), .B(n233), .Y(n124) );
  NAND2X1 U96 ( .A(n241), .B(A[4]), .Y(n123) );
  NAND2X1 U97 ( .A(n223), .B(n210), .Y(n95) );
  NAND2X1 U98 ( .A(n217), .B(A[8]), .Y(n79) );
  OAI2BB1X1 U99 ( .A0N(n216), .A1N(B[15]), .B0(n148), .Y(n137) );
  OR2X2 U100 ( .A(n216), .B(B[15]), .Y(n148) );
  NAND2X1 U101 ( .A(n227), .B(n212), .Y(n74) );
  NAND2X1 U102 ( .A(n237), .B(A[10]), .Y(n176) );
  OR2X1 U103 ( .A(n246), .B(n245), .Y(n85) );
  NAND2X1 U104 ( .A(n246), .B(n245), .Y(n90) );
  NAND2X1 U105 ( .A(n221), .B(n204), .Y(n147) );
  INVX1 U106 ( .A(A[1]), .Y(n104) );
  INVX1 U107 ( .A(n220), .Y(n219) );
  INVX1 U108 ( .A(n209), .Y(n208) );
  INVX1 U109 ( .A(n203), .Y(n202) );
  INVX1 U110 ( .A(n207), .Y(n206) );
  INVX1 U111 ( .A(n211), .Y(n210) );
  INVX1 U112 ( .A(n224), .Y(n223) );
  INVX1 U113 ( .A(n228), .Y(n227) );
  BUFX3 U114 ( .A(A[6]), .Y(n245) );
  OAI21X1 U115 ( .A0(n59), .A1(n60), .B0(n135), .Y(n133) );
  NOR2X1 U116 ( .A(A[1]), .B(n243), .Y(n59) );
  NAND2X1 U117 ( .A(A[0]), .B(n214), .Y(n60) );
  AND2X1 U118 ( .A(n214), .B(A[0]), .Y(n69) );
  AND2X1 U119 ( .A(n214), .B(A[0]), .Y(n70) );
  AND2X1 U120 ( .A(n214), .B(A[0]), .Y(n68) );
  INVX1 U121 ( .A(n205), .Y(n204) );
  INVX1 U122 ( .A(n226), .Y(n225) );
  INVX1 U123 ( .A(n230), .Y(n229) );
  INVX1 U124 ( .A(n222), .Y(n221) );
  AOI21X2 U125 ( .A0(n189), .A1(n190), .B0(n191), .Y(n179) );
  NAND3BX1 U126 ( .AN(n76), .B(n110), .C(n181), .Y(n180) );
  INVX1 U127 ( .A(n145), .Y(n153) );
  NAND2X1 U128 ( .A(n167), .B(n168), .Y(n169) );
  INVX1 U129 ( .A(n144), .Y(n141) );
  OAI22X2 U130 ( .A0(n75), .A1(n76), .B0(n62), .B1(n77), .Y(n71) );
  NAND2X1 U131 ( .A(n79), .B(n80), .Y(n78) );
  NOR2BX1 U132 ( .AN(n165), .B(n64), .Y(n170) );
  NAND3X1 U133 ( .A(n113), .B(n114), .C(n115), .Y(n94) );
  OAI21X1 U134 ( .A0(n75), .A1(n83), .B0(n84), .Y(n81) );
  NAND2X1 U135 ( .A(n85), .B(n86), .Y(n83) );
  NAND2X1 U136 ( .A(n128), .B(n112), .Y(n132) );
  NAND2X1 U137 ( .A(n123), .B(n113), .Y(n122) );
  NAND2X1 U138 ( .A(n50), .B(n172), .Y(n177) );
  NAND2X1 U139 ( .A(n156), .B(n157), .Y(n160) );
  NAND2X1 U140 ( .A(n85), .B(n90), .Y(n106) );
  NAND2X1 U141 ( .A(n142), .B(n147), .Y(n150) );
  NAND2X1 U142 ( .A(n220), .B(n201), .Y(n100) );
  NOR2BX1 U143 ( .AN(n115), .B(n76), .Y(n189) );
  NAND2X1 U144 ( .A(n220), .B(n201), .Y(n105) );
  NAND2X1 U145 ( .A(n244), .B(n104), .Y(n99) );
  NAND2X1 U146 ( .A(n117), .B(n184), .Y(n192) );
  INVX1 U147 ( .A(n95), .Y(n117) );
  INVX1 U148 ( .A(n114), .Y(n118) );
  AND2X2 U149 ( .A(n218), .B(n199), .Y(n62) );
  INVX1 U150 ( .A(n112), .Y(n101) );
  NAND2X1 U151 ( .A(n244), .B(n104), .Y(n130) );
  INVX1 U152 ( .A(n147), .Y(n146) );
  NAND3X1 U153 ( .A(n141), .B(n142), .C(n50), .Y(n140) );
  AOI21X1 U154 ( .A0(n145), .A1(n142), .B0(n146), .Y(n139) );
  XOR2X1 U155 ( .A(n71), .B(n72), .Y(SUM[9]) );
  XOR2X1 U156 ( .A(n120), .B(n125), .Y(SUM[3]) );
  XOR2X1 U157 ( .A(n239), .B(n233), .Y(n125) );
  XOR2X1 U158 ( .A(n88), .B(n89), .Y(SUM[7]) );
  NOR2X1 U159 ( .A(n117), .B(n118), .Y(n116) );
  OAI21X1 U160 ( .A0(n132), .A1(n133), .B0(n134), .Y(SUM[2]) );
  NAND2X1 U161 ( .A(n132), .B(n133), .Y(n134) );
  XNOR2X1 U162 ( .A(n70), .B(n136), .Y(SUM[1]) );
  NAND3BX1 U163 ( .AN(n104), .B(n128), .C(n243), .Y(n127) );
  NAND3BX1 U164 ( .AN(n129), .B(n130), .C(n131), .Y(n126) );
  NAND2X1 U165 ( .A(n220), .B(n201), .Y(n131) );
  NAND2X1 U166 ( .A(n159), .B(n160), .Y(n161) );
  NAND2X1 U167 ( .A(n137), .B(n57), .Y(n138) );
  NAND2X1 U168 ( .A(n111), .B(n112), .Y(n109) );
  OR2X2 U169 ( .A(A[4]), .B(n241), .Y(n63) );
  OR2X2 U170 ( .A(B[11]), .B(n208), .Y(n171) );
  OR2X2 U171 ( .A(n221), .B(n204), .Y(n142) );
  NAND3BX1 U172 ( .AN(n104), .B(n105), .C(n243), .Y(n111) );
  NAND2X1 U173 ( .A(n243), .B(A[1]), .Y(n135) );
  NOR2X1 U174 ( .A(n101), .B(n102), .Y(n96) );
  NOR3BX1 U175 ( .AN(n243), .B(n103), .C(n104), .Y(n102) );
  INVX1 U176 ( .A(n105), .Y(n103) );
  NOR2X1 U177 ( .A(A[1]), .B(n243), .Y(n187) );
  OAI2BB1X1 U178 ( .A0N(n220), .A1N(n201), .B0(n184), .Y(n183) );
  NOR2X1 U179 ( .A(n185), .B(n186), .Y(n182) );
  NOR2X1 U180 ( .A(n187), .B(n188), .Y(n185) );
  AND2X2 U181 ( .A(A[10]), .B(n237), .Y(n65) );
  OAI2BB1X1 U182 ( .A0N(n243), .A1N(A[1]), .B0(n112), .Y(n186) );
  NAND2X1 U183 ( .A(n90), .B(n91), .Y(n88) );
  OAI21X1 U184 ( .A0(n92), .A1(n93), .B0(n85), .Y(n91) );
  AOI21X1 U185 ( .A0(n96), .A1(n97), .B0(n98), .Y(n92) );
  NAND2X1 U186 ( .A(n94), .B(n95), .Y(n93) );
  AND2X2 U187 ( .A(n67), .B(n86), .Y(n66) );
  NAND2X1 U188 ( .A(n149), .B(n150), .Y(n151) );
  XOR2X1 U189 ( .A(n81), .B(n82), .Y(SUM[8]) );
  NOR2BX1 U190 ( .AN(n79), .B(n62), .Y(n82) );
  NOR2X1 U191 ( .A(A[0]), .B(n214), .Y(n198) );
  AND3X2 U192 ( .A(n68), .B(n99), .C(n100), .Y(n108) );
  INVX1 U193 ( .A(B[3]), .Y(n240) );
  INVX1 U194 ( .A(A[7]), .Y(n232) );
  INVX1 U195 ( .A(B[10]), .Y(n238) );
  INVX1 U196 ( .A(A[3]), .Y(n234) );
  INVX1 U197 ( .A(B[0]), .Y(n215) );
  NAND3X1 U198 ( .A(n69), .B(n99), .C(n100), .Y(n97) );
  INVX1 U199 ( .A(B[12]), .Y(n226) );
  INVX1 U200 ( .A(B[13]), .Y(n230) );
  INVX1 U201 ( .A(B[14]), .Y(n222) );
  INVX1 U202 ( .A(B[9]), .Y(n228) );
  INVX1 U203 ( .A(B[5]), .Y(n224) );
  INVX1 U204 ( .A(B[2]), .Y(n220) );
  INVX1 U205 ( .A(A[12]), .Y(n203) );
  INVX1 U206 ( .A(A[13]), .Y(n207) );
  INVX1 U207 ( .A(A[14]), .Y(n205) );
  INVX1 U208 ( .A(A[5]), .Y(n211) );
  INVX1 U209 ( .A(A[2]), .Y(n201) );
  INVX1 U210 ( .A(A[9]), .Y(n213) );
  INVX1 U211 ( .A(A[11]), .Y(n209) );
  INVX1 U212 ( .A(A[8]), .Y(n199) );
  INVX1 U213 ( .A(B[4]), .Y(n242) );
  INVX1 U214 ( .A(A[15]), .Y(n216) );
  NAND2X1 U215 ( .A(A[0]), .B(n214), .Y(n188) );
  NAND2X1 U216 ( .A(n214), .B(A[0]), .Y(n129) );
  INVX1 U217 ( .A(B[8]), .Y(n218) );
  XOR2X1 U218 ( .A(n143), .B(n178), .Y(SUM[10]) );
endmodule


module FETCH_FSM ( TRANS_EN, PDWN, IDLE, POR, LAST_CYCLE, ALEOFF, inter_LCALL, 
        pre_idle, pre_pdwn_idle, MOVX_RI, MOVX_DPI, MOVX_RI_A, MOVX_DPI_A, 
        ACC_WR_XRAM, ACC_RD_XRAM, CLK, RESET, CS1, CS2, CS3, CS4, LS1, LS2, 
        LS3, LS4, CYCLE2, CYCLE3, CYCLE4, BYTE2, BYTE3, PC_INC_EN, IR_EN, 
        PSEN_B_X, ALE_B_X, ALE_B_I, XRAM_CE_B, XRAM_WR_B, XRAM_RD_B );
  input PDWN, IDLE, POR, ALEOFF, inter_LCALL, pre_idle, pre_pdwn_idle, MOVX_RI,
         MOVX_DPI, MOVX_RI_A, MOVX_DPI_A, CLK, RESET, CYCLE2, CYCLE3, CYCLE4,
         BYTE2, BYTE3;
  output TRANS_EN, LAST_CYCLE, ACC_WR_XRAM, ACC_RD_XRAM, CS1, CS2, CS3, CS4,
         LS1, LS2, LS3, LS4, PC_INC_EN, IR_EN, PSEN_B_X, ALE_B_X, ALE_B_I,
         XRAM_CE_B, XRAM_WR_B, XRAM_RD_B;
  wire   N25, BCR_1_, PSEN_B_next, PSEN_TMP, RST_d0, ALE_tmp1, ALE_new, CS2_d1,
         CS2_d3, CS2_d2, N114, N116, N118, N126, N127, n2, n3, n4, n5, n6, n7,
         n10, n14, n16, n18, n19, n21, n22, n23, n28, n29, n30, n31, n32, n33,
         n34, n36, n41, n42, n44, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n67, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82,
         n83, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113;
  wire   [1:0] BS;
  wire   [2:0] LSR;
  wire   [2:0] MCR;
  wire   [2:0] LS_next;

  AOI221X4 U4 ( .A0(LS4), .A1(n6), .B0(PSEN_TMP), .B1(n7), .C0(RESET), .Y(n5)
         );
  OAI211X4 U18 ( .A0(CS2), .A1(n18), .B0(n19), .C0(n86), .Y(n16) );
  OAI32X4 U31 ( .A0(n30), .A1(pre_pdwn_idle), .A2(RESET), .B0(RESET), .B1(n31), 
        .Y(LS_next[2]) );
  DFFRHQX4 LSR_reg_1_ ( .D(LS_next[1]), .CK(CLK), .RN(n57), .Q(LSR[1]) );
  DFFRHQX4 IR_EN_reg ( .D(N25), .CK(CLK), .RN(n57), .Q(IR_EN) );
  AND2X4 I100 ( .A(n6), .B(n78), .Y(PC_INC_EN) );
  OAI221X4 I101 ( .A0(n73), .A1(n21), .B0(n23), .B1(n28), .C0(n86), .Y(n59) );
  NAND2X1 I102 ( .A(n90), .B(n79), .Y(n98) );
  OAI221X4 I103 ( .A0(n75), .A1(n21), .B0(n23), .B1(n80), .C0(n86), .Y(n61) );
  NAND4X2 I104 ( .A(n91), .B(n99), .C(n100), .D(n101), .Y(n113) );
  AOI211X4 I105 ( .A0(LSR[1]), .A1(LSR[2]), .B0(n32), .C0(LSR[0]), .Y(
        LS_next[0]) );
  NAND2BX1 I106 ( .AN(n16), .B(n72), .Y(N114) );
  OAI21X1 I107 ( .A0(IDLE), .A1(PSEN_TMP), .B0(n10), .Y(PSEN_B_X) );
  NAND2BX1 I108 ( .AN(n16), .B(n71), .Y(N116) );
  AOI21X1 I109 ( .A0(n33), .A1(n7), .B0(n32), .Y(LS_next[1]) );
  NAND2X1 I110 ( .A(n76), .B(n111), .Y(n105) );
  INVX1 I111 ( .A(CYCLE4), .Y(n111) );
  NAND2X1 I112 ( .A(n107), .B(n108), .Y(n97) );
  INVX2 I113 ( .A(n79), .Y(n91) );
  INVX4 I114 ( .A(n113), .Y(CS2) );
  INVX2 I115 ( .A(n94), .Y(CS1) );
  INVX2 I116 ( .A(n7), .Y(LS2) );
  NOR2X1 I117 ( .A(n79), .B(n102), .Y(CS3) );
  INVX4 I118 ( .A(n33), .Y(LS1) );
  NAND2BX1 I119 ( .AN(n105), .B(n106), .Y(n101) );
  NAND2X1 I120 ( .A(n109), .B(MCR[0]), .Y(n100) );
  NAND2X1 I121 ( .A(n100), .B(n101), .Y(n28) );
  NOR2X1 I122 ( .A(CYCLE2), .B(CYCLE3), .Y(n110) );
  INVX2 I123 ( .A(n97), .Y(n99) );
  NAND2X1 I124 ( .A(n77), .B(n112), .Y(BS[1]) );
  INVX1 I125 ( .A(pre_pdwn_idle), .Y(n6) );
  DFFSX1 MCR_reg_0_ ( .D(n59), .CK(CLK), .SN(n57), .Q(MCR[0]), .QN(n73) );
  OAI21X2 I126 ( .A0(n95), .A1(BS[1]), .B0(n96), .Y(n93) );
  NOR2X1 I127 ( .A(inter_LCALL), .B(n29), .Y(n96) );
  NOR2X1 I128 ( .A(n97), .B(n91), .Y(n95) );
  NAND3X1 I129 ( .A(MCR[2]), .B(n74), .C(MCR[0]), .Y(n109) );
  NAND2X2 I130 ( .A(n79), .B(n28), .Y(n94) );
  NOR3BX2 I131 ( .AN(n6), .B(IR_EN), .C(n93), .Y(n36) );
  DFFRHQX2 LSR_reg_2_ ( .D(LS_next[2]), .CK(CLK), .RN(n57), .Q(LSR[2]) );
  DFFTRX2 ACC_RD_XRAM_reg ( .D(n70), .CK(CLK), .RN(n71), .Q(ACC_RD_XRAM) );
  DFFSX1 MCR_reg_2_ ( .D(n61), .CK(CLK), .SN(n57), .Q(MCR[2]), .QN(n75) );
  AND3X2 I132 ( .A(n75), .B(n74), .C(n73), .Y(n76) );
  DFFRX1 BCR_reg_1_ ( .D(n63), .CK(CLK), .RN(n57), .Q(BCR_1_), .QN(n77) );
  OR3X2 I133 ( .A(pre_pdwn_idle), .B(pre_idle), .C(RESET), .Y(n32) );
  NAND2BX2 I134 ( .AN(n82), .B(LSR[0]), .Y(n33) );
  DFFRHQX2 LSR_reg_0_ ( .D(LS_next[0]), .CK(CLK), .RN(n57), .Q(LSR[0]) );
  NAND2BX2 I135 ( .AN(n83), .B(LSR[2]), .Y(n29) );
  NAND2BX4 I136 ( .AN(n81), .B(LSR[1]), .Y(n7) );
  DFFHQX1 CS2_d2_reg ( .D(CS2_d1), .CK(CLK), .Q(CS2_d2) );
  INVX1 I137 ( .A(n29), .Y(TRANS_EN) );
  INVX1 I138 ( .A(n93), .Y(n78) );
  INVX1 I139 ( .A(n30), .Y(LS3) );
  AOI2BB1X4 I140 ( .A0N(n110), .A1N(n105), .B0(MCR[1]), .Y(n79) );
  XNOR2X1 I141 ( .A(n98), .B(n99), .Y(n80) );
  OAI2BB1X1 I142 ( .A0N(CS2_d3), .A1N(n42), .B0(ALE_new), .Y(ALE_B_I) );
  INVX1 I143 ( .A(n42), .Y(n3) );
  INVX1 I144 ( .A(n94), .Y(LAST_CYCLE) );
  OR2X2 I145 ( .A(MOVX_DPI_A), .B(MOVX_RI_A), .Y(n72) );
  OR2X2 I146 ( .A(n72), .B(n71), .Y(n42) );
  DFFHQX1 XRAM_WR_B_reg ( .D(N114), .CK(CLK), .Q(XRAM_WR_B) );
  DFFHQX1 XRAM_RD_B_reg ( .D(N116), .CK(CLK), .Q(XRAM_RD_B) );
  NAND2X1 I147 ( .A(n94), .B(n113), .Y(n92) );
  OR2X2 I148 ( .A(MOVX_DPI), .B(MOVX_RI), .Y(n71) );
  INVX2 I149 ( .A(RESET), .Y(n86) );
  DFFHQX1 XRAM_CE_B_reg ( .D(N118), .CK(CLK), .Q(XRAM_CE_B) );
  NAND2X1 I150 ( .A(CYCLE2), .B(n104), .Y(n106) );
  INVX1 I151 ( .A(CYCLE3), .Y(n104) );
  NOR2X1 I152 ( .A(n99), .B(n91), .Y(CS4) );
  INVX1 I153 ( .A(n28), .Y(n90) );
  OR3X1 I154 ( .A(LS4), .B(LS3), .C(n18), .Y(n19) );
  OR3X2 I155 ( .A(RESET), .B(n3), .C(n14), .Y(N118) );
  INVX1 I156 ( .A(n70), .Y(n14) );
  DFFTRX1 ACC_WR_XRAM_reg ( .D(n70), .CK(CLK), .RN(n72), .Q(ACC_WR_XRAM) );
  NAND2X1 I157 ( .A(n103), .B(n99), .Y(n102) );
  OAI21X1 I158 ( .A0(n104), .A1(n105), .B0(n100), .Y(n103) );
  DFFRX1 MCR_reg_1_ ( .D(n60), .CK(CLK), .RN(n57), .Q(MCR[1]), .QN(n74) );
  INVX2 I159 ( .A(n29), .Y(LS4) );
  AND3X2 U98 ( .A(n64), .B(n58), .C(n86), .Y(n62) );
  OAI2BB2X1 I160 ( .A0N(N126), .A1N(n36), .B0(n36), .B1(n87), .Y(n64) );
  INVX1 I161 ( .A(BS[0]), .Y(N126) );
  AND3X2 U99 ( .A(n65), .B(n58), .C(n86), .Y(n63) );
  OAI2BB2X1 I162 ( .A0N(N127), .A1N(n36), .B0(n36), .B1(n77), .Y(n65) );
  XNOR2X1 I163 ( .A(BS[1]), .B(BS[0]), .Y(N127) );
  AOI21X1 I164 ( .A0(n33), .A1(n7), .B0(n94), .Y(n18) );
  AOI21X1 I165 ( .A0(LS3), .A1(n92), .B0(n18), .Y(n44) );
  DFFRX1 BCR_reg_0_ ( .D(n62), .CK(CLK), .RN(n57), .QN(n87) );
  NOR3X1 I166 ( .A(n91), .B(n97), .C(n30), .Y(N25) );
  INVX1 I167 ( .A(n21), .Y(n22) );
  DFFHQX1 PSEN_TMP_reg ( .D(PSEN_B_next), .CK(CLK), .Q(PSEN_TMP) );
  NAND2X1 I168 ( .A(n109), .B(MCR[2]), .Y(n107) );
  NAND3X1 I169 ( .A(n73), .B(n74), .C(CYCLE4), .Y(n108) );
  OR2X2 I170 ( .A(LSR[2]), .B(LSR[0]), .Y(n81) );
  OR2X2 I171 ( .A(LSR[2]), .B(LSR[1]), .Y(n82) );
  OR2X2 I172 ( .A(LSR[1]), .B(LSR[0]), .Y(n83) );
  NAND3BX1 I173 ( .AN(LSR[2]), .B(LSR[1]), .C(LSR[0]), .Y(n30) );
  OAI31X1 I174 ( .A0(n2), .A1(n3), .A2(n4), .B0(n5), .Y(PSEN_B_next) );
  INVX1 I175 ( .A(n92), .Y(n2) );
  OAI21X1 I176 ( .A0(BYTE2), .A1(BYTE3), .B0(n87), .Y(n112) );
  OAI221X4 I177 ( .A0(BYTE2), .A1(BCR_1_), .B0(BCR_1_), .B1(n34), .C0(n87), 
        .Y(BS[0]) );
  INVX1 I178 ( .A(BYTE3), .Y(n34) );
  AND3X2 U97 ( .A(n67), .B(n58), .C(n86), .Y(n60) );
  OAI21X1 I179 ( .A0(n23), .A1(n88), .B0(n89), .Y(n67) );
  NAND2X1 I180 ( .A(MCR[1]), .B(n22), .Y(n89) );
  XNOR2X1 I181 ( .A(n90), .B(n91), .Y(n88) );
  OR2X2 I182 ( .A(LS4), .B(IR_EN), .Y(n21) );
  OR2X2 I183 ( .A(IR_EN), .B(n29), .Y(n23) );
  OR2X2 I184 ( .A(LS4), .B(RST_d0), .Y(ALE_tmp1) );
  INVX1 I185 ( .A(IR_EN), .Y(n58) );
  INVX1 I186 ( .A(PSEN_TMP), .Y(n4) );
  INVX4 I187 ( .A(POR), .Y(n57) );
  INVX1 I188 ( .A(PDWN), .Y(n10) );
  AND2X2 I189 ( .A(n41), .B(ALE_B_I), .Y(ALE_B_X) );
  AOI211X1 I190 ( .A0(ALEOFF), .A1(n3), .B0(PDWN), .C0(IDLE), .Y(n41) );
  DFFHQX1 RST_d0_reg ( .D(RESET), .CK(CLK), .Q(RST_d0) );
  DFFHQX1 ALE_new_reg ( .D(ALE_tmp1), .CK(CLK), .Q(ALE_new) );
  DFFHQX1 CS2_d3_reg ( .D(CS2_d2), .CK(CLK), .Q(CS2_d3) );
  INVX1 I191 ( .A(pre_idle), .Y(n31) );
  DFFHQX1 CS2_d1_reg ( .D(CS2), .CK(CLK), .Q(CS2_d1) );
  OAI221X4 I192 ( .A0(n113), .A1(n7), .B0(n29), .B1(n113), .C0(n44), .Y(n70)
         );
endmodule


module IR_DECODER2 ( POR, CLK, PC_HOLD, read_modify, RAM_RD_EN, MOVX_RI, 
        MOVX_DPI, MOVX_RI_A, MOVX_DPI_A, MOVX_INS, MOVC_INS, T2_XCHD_A_EN, 
        T1_XCHD_MDR_EN, A_IDATA_EN, CY_AC_OV_UP, CY_AC_OV_SUB_UP, 
        CY0_MUL_OV_UP, CY0_DIV_OV_UP, CY_UP, CY_DA_UP, CY_CJNE_EN, 
        ALU_SUBBC_EN, JBC_BIT_EN, JBC_BIT_ADDR_EN, IR, CS1, CS2, CS3, CS4, LS1, 
        LS2, LS3, LS4, ALLZ_B_PC_RES_EN, ALLZ_PC_RES_EN, ALU_ADC_EN, 
        ALU_ADD_EN, ALU_ANL_EN, ALU_BITC_EN, ALU_CPL_EN, ALU_ORL_EN, 
        ALU_RLC_EN, ALU_RL_EN, ALU_RRC_EN, ALU_RR_EN, ALU_SUB_EN, ALU_SWAP_EN, 
        ALU_XRL_EN, A_MRR_EN, A_T1_EN, B_T1_EN, B_T2RES_EN, CAR_OUT_EN, 
        CAR_PC_RES_EN, C_0_EN, C_1_EN, C_ALLZ_AND_EN, C_ALLZ_B_AND_EN, 
        C_ALLZ_B_EN, C_ALLZ_B_OR_EN, C_ALLZ_OR_EN, C_B_PC_RES_EN, C_CB_EN, 
        C_PC_RES_EN, DIV_OP_EN, DPTR_INC_EN, DPTR_DEC_EN, DP_T2T1_EN, 
        F5_ALLZ_EN, F5_B_PC_RES_EN, F5_PC_RES_EN, ID_PCH_EN_g, ID_PCL_EN_g, 
        ID_T2_EN_g, WM_EN_g, INT_EN_1_EN, MAR_BAR_EN, MAR_MDR_EN, MAR_P0R_EN, 
        MAR_RES_EN, MAR_RI_EN, MAR_RN_EN, MAR_SP_EN, MAR_T1_EN, MUL_OP_EN, 
        OV_T1Z_EN, P0R_MDR_EN, P0R_P0_EN, PC1_A_EN, PC1_DP_EN, PC1_P0R_EN, 
        PC1_PCCALL_EN, PC2_DP_EN, PC2_PC_EN, PC_AD11_EN, PC_PC1_EN, 
        SJMP_PC_RES_EN, JMP_PC_RES_EN, PC_RET_EN, PC_T2T1_EN, SP_RES_EN, 
        SP_T1_EN, T1_0_EN, T1_1_EN, T1_BITCP_EN, T1_B_EN, T1_CBP_EN, T1_DAD_EN, 
        T1_MDR_EN, T1_P0R_EN, T1_RES_EN, T1_SBP_EN, T2_0_EN, T2_1_EN, T2_A_EN, 
        T2_MDR_EN, T2_P0R_EN, T2_REM2_EN, T2_RES_EN, T2_SP_EN, WA_EN, 
        XAH_P2R_EN, XAL_MDR_EN, XA_DP_EN, XA_OUT_EN );
  input [7:0] IR;
  input POR, CLK, CS1, CS2, CS3, CS4, LS1, LS2, LS3, LS4;
  output PC_HOLD, read_modify, RAM_RD_EN, MOVX_RI, MOVX_DPI, MOVX_RI_A,
         MOVX_DPI_A, MOVX_INS, MOVC_INS, T2_XCHD_A_EN, T1_XCHD_MDR_EN,
         A_IDATA_EN, CY_AC_OV_UP, CY_AC_OV_SUB_UP, CY0_MUL_OV_UP,
         CY0_DIV_OV_UP, CY_UP, CY_DA_UP, CY_CJNE_EN, ALU_SUBBC_EN, JBC_BIT_EN,
         JBC_BIT_ADDR_EN, ALLZ_B_PC_RES_EN, ALLZ_PC_RES_EN, ALU_ADC_EN,
         ALU_ADD_EN, ALU_ANL_EN, ALU_BITC_EN, ALU_CPL_EN, ALU_ORL_EN,
         ALU_RLC_EN, ALU_RL_EN, ALU_RRC_EN, ALU_RR_EN, ALU_SUB_EN, ALU_SWAP_EN,
         ALU_XRL_EN, A_MRR_EN, A_T1_EN, B_T1_EN, B_T2RES_EN, CAR_OUT_EN,
         CAR_PC_RES_EN, C_0_EN, C_1_EN, C_ALLZ_AND_EN, C_ALLZ_B_AND_EN,
         C_ALLZ_B_EN, C_ALLZ_B_OR_EN, C_ALLZ_OR_EN, C_B_PC_RES_EN, C_CB_EN,
         C_PC_RES_EN, DIV_OP_EN, DPTR_INC_EN, DPTR_DEC_EN, DP_T2T1_EN,
         F5_ALLZ_EN, F5_B_PC_RES_EN, F5_PC_RES_EN, ID_PCH_EN_g, ID_PCL_EN_g,
         ID_T2_EN_g, WM_EN_g, INT_EN_1_EN, MAR_BAR_EN, MAR_MDR_EN, MAR_P0R_EN,
         MAR_RES_EN, MAR_RI_EN, MAR_RN_EN, MAR_SP_EN, MAR_T1_EN, MUL_OP_EN,
         OV_T1Z_EN, P0R_MDR_EN, P0R_P0_EN, PC1_A_EN, PC1_DP_EN, PC1_P0R_EN,
         PC1_PCCALL_EN, PC2_DP_EN, PC2_PC_EN, PC_AD11_EN, PC_PC1_EN,
         SJMP_PC_RES_EN, JMP_PC_RES_EN, PC_RET_EN, PC_T2T1_EN, SP_RES_EN,
         SP_T1_EN, T1_0_EN, T1_1_EN, T1_BITCP_EN, T1_B_EN, T1_CBP_EN,
         T1_DAD_EN, T1_MDR_EN, T1_P0R_EN, T1_RES_EN, T1_SBP_EN, T2_0_EN,
         T2_1_EN, T2_A_EN, T2_MDR_EN, T2_P0R_EN, T2_REM2_EN, T2_RES_EN,
         T2_SP_EN, WA_EN, XAH_P2R_EN, XAL_MDR_EN, XA_DP_EN, XA_OUT_EN;
  wire   ID_PCH_EN, ID_T2_EN, WM_EN, n1, n10, n13, n14, n15, n47, n56, n98,
         n107, n109, n112, n144, n147, n161, n165, n189, n215, n216, n217,
         n218, n235, n236, n237, n244, n271, n339, n443, n495, n496, n497,
         n498, n499, n500, n501, n502, n503, n504, n505, n506, n507, n508,
         n509, n510, n512, n513, n514, n515, n516, n518, n519, n520, n521,
         n523, n524, n525, n527, n529, n530, n531, n532, n533, n534, n535,
         n536, n537, n538, n539, n540, n541, n542, n543, n544, n545, n546,
         n548, n550, n551, n552, n553, n554, n555, n556, n557, n558, n559,
         n560, n561, n563, n564, n565, n566, n567, n568, n569, n570, n571,
         n572, n573, n574, n575, n576, n577, n578, n579, n580, n581, n582,
         n585, n587, n589, n591, n593, n594, n595, n596, n597, n598, n599,
         n600, n601, n602, n603, n604, n605, n606, n607, n608, n609, n610,
         n611, n612, n613, n614, n615, n616, n617, n618, n619, n620, n621,
         n622, n623, n624, n625, n626, n627, n628, n629, n630, n631, n632,
         n633, n634, n635, n636, n637, n638, n639, n640, n641, n642, n643,
         n644, n645, n646, n647, n648, n649, n650, n651, n652, n653, n654,
         n655, n656, n657, n658, n659, n660, n661, n662, n663, n664, n665,
         n666, n667, n668, n669, n670, n671, n672, n673, n674, n675, n676,
         n677, n678, n679, n680, n681, n682, n683, n684, n685, n686, n687,
         n688, n689, n690, n691, n692, n693, n694, n695, n696, n697, n698,
         n699, n700, n701, n702, n703, n704, n705, n706, n707, n708, n709,
         n710, n711, n712, n713, n714, n715, n716, n717, n718, n719, n720,
         n721, n722, n723, n724, n725, n726, n727, n728, n729, n730, n731,
         n732, n733, n734, n735, n736, n737, n738, n739, n740, n741, n742,
         n743, n744, n745, n746, n747, n748, n749, n750, n751, n752, n753,
         n754, n755, n756, n757, n758, n759, n760, n761, n762, n763, n764,
         n765, n766, n767, n768, n769, n770, n771, n772, n773, n774, n775,
         n776, n777, n778, n779, n780, n781, n782, n783, n784, n785, n786,
         n787, n788, n789, n790, n791, n792, n793, n794, n795, n796, n797,
         n798, n799, n800, n801, n802, n803, n804, n805, n806, n807, n808,
         n809, n810, n811, n812, n813, n814, n815, n816, n817, n818, n819,
         n820, n821, n822, n823, n824, n825, n826, n827, n828, n829, n830,
         n831, n832, n833, n834, n835, n836, n837, n838, n839, n840, n841,
         n842, n843, n844, n845, n846, n847, n848, n849, n850, n851, n852,
         n853, n854, n855, n856, n857, n858, n859, n860, n861, n862, n863,
         n864, n865, n866, n867, n868, n869, n870, n871, n872, n873, n874,
         n875, n876, n877, n878, n879, n880, n881, n882, n883, n884, n885,
         n886, n887, n888, n889, n890, n891, n892, n893, n894, n895, n896,
         n897, n898, n899, n900, n901, n902, n903, n904, n905, n906, n907,
         n908, n909, n910, n911, n912, n913, n914, n915, n916, n917, n918,
         n919, n920, n921, n922, n923, n924, n925, n926, n927, n928, n929,
         n930, n931, n932, n933, n934, n935, n936, n937, n938, n939, n940,
         n941, n942, n943, n944, n945, n946, n947, n948, n949, n950, n951,
         n952, n953, n954, n955, n956, n957, n958, n959, n960, n961, n962,
         n963, n964, n965, n966, n967, n968, n969, n970, n971, n972, n973,
         n974, n975, n976, n977, n978, n979, n980, n981;

  OAI2BB1X1 I605 ( .A0N(n634), .A1N(n695), .B0(n912), .Y(n911) );
  OAI2BB2X1 I606 ( .A0N(n974), .A1N(n576), .B0(n750), .B1(n614), .Y(n827) );
  AOI211X1 I607 ( .A0(n838), .A1(n556), .B0(n650), .C0(n961), .Y(n495) );
  INVX1 I608 ( .A(n495), .Y(n646) );
  INVX2 I609 ( .A(n578), .Y(n961) );
  AND3X2 I610 ( .A(n964), .B(n932), .C(n496), .Y(n969) );
  INVX1 I611 ( .A(n931), .Y(n496) );
  OR3X2 I612 ( .A(n570), .B(n979), .C(n970), .Y(n13) );
  OAI2BB1X1 I613 ( .A0N(n638), .A1N(n956), .B0(n545), .Y(n700) );
  AOI2BB1X1 I614 ( .A0N(n805), .A1N(n691), .B0(n804), .Y(n803) );
  NOR2X1 I615 ( .A(n737), .B(n738), .Y(n736) );
  OAI2BB1X1 I616 ( .A0N(n675), .A1N(n553), .B0(n704), .Y(T1_SBP_EN) );
  OAI2BB1X2 I617 ( .A0N(n579), .A1N(n576), .B0(n600), .Y(n676) );
  NAND2BX1 I618 ( .AN(MAR_SP_EN), .B(n735), .Y(T2_SP_EN) );
  AND4X2 I619 ( .A(n926), .B(n816), .C(n854), .D(n655), .Y(n923) );
  NAND4X1 I620 ( .A(n955), .B(n836), .C(n905), .D(n659), .Y(n904) );
  AOI21X1 I621 ( .A0(n608), .A1(n676), .B0(n573), .Y(n707) );
  NOR2X1 I622 ( .A(n663), .B(n664), .Y(T2_REM2_EN) );
  NAND4BX1 I623 ( .AN(n762), .B(n761), .C(n738), .D(n629), .Y(n680) );
  AND4X2 I624 ( .A(n896), .B(n897), .C(n821), .D(n497), .Y(n514) );
  INVX1 I625 ( .A(PC_RET_EN), .Y(n497) );
  OAI21X1 I626 ( .A0(n676), .A1(n622), .B0(n553), .Y(n523) );
  OAI211X4 I627 ( .A0(n794), .A1(n10), .B0(n822), .C0(n823), .Y(MAR_P0R_EN) );
  NAND2X1 I628 ( .A(n610), .B(n939), .Y(n729) );
  NAND4X1 I629 ( .A(n768), .B(n816), .C(n655), .D(n656), .Y(n561) );
  NAND2BX1 I630 ( .AN(n565), .B(n974), .Y(n842) );
  OAI31X4 I631 ( .A0(n956), .A1(n778), .A2(n10), .B0(n777), .Y(PC2_DP_EN) );
  NAND3X2 I632 ( .A(n512), .B(n523), .C(n673), .Y(T2_MDR_EN) );
  NAND4BX1 I633 ( .AN(n596), .B(n597), .C(n598), .D(n768), .Y(n551) );
  AOI21X1 I634 ( .A0(n579), .A1(n567), .B0(n500), .Y(n501) );
  AOI2BB1X1 I635 ( .A0N(n818), .A1N(n616), .B0(n498), .Y(n499) );
  INVX1 I636 ( .A(n527), .Y(n498) );
  INVX2 I637 ( .A(n499), .Y(MAR_MDR_EN) );
  INVX1 I638 ( .A(n839), .Y(n818) );
  OAI211X4 I639 ( .A0(n10), .A1(n667), .B0(n706), .C0(n707), .Y(T1_P0R_EN) );
  OR3X2 I640 ( .A(n650), .B(n750), .C(n778), .Y(n647) );
  OAI211X4 I641 ( .A0(n963), .A1(n971), .B0(n161), .C0(n633), .Y(n762) );
  INVX1 I642 ( .A(n567), .Y(n971) );
  NAND3BX1 I643 ( .AN(n705), .B(n505), .C(n854), .Y(n681) );
  NAND3X1 I644 ( .A(n713), .B(n712), .C(n714), .Y(T1_MDR_EN) );
  NOR2BX1 I645 ( .AN(n566), .B(n98), .Y(n690) );
  AND3X1 I646 ( .A(n646), .B(n645), .C(n644), .Y(n643) );
  INVX2 I647 ( .A(n579), .Y(n963) );
  INVX2 I648 ( .A(n576), .Y(n968) );
  NOR2X2 I649 ( .A(n747), .B(n967), .Y(PC_RET_EN) );
  OAI2BB1X1 I650 ( .A0N(n738), .A1N(n501), .B0(n970), .Y(n801) );
  NOR4BX1 I651 ( .AN(n652), .B(n651), .C(n561), .D(n56), .Y(n560) );
  OR2X2 I652 ( .A(n597), .B(n852), .Y(n825) );
  NAND3BX1 I653 ( .AN(n638), .B(n979), .C(n581), .Y(n878) );
  NAND2X1 I654 ( .A(n798), .B(n557), .Y(n860) );
  INVX1 I655 ( .A(n637), .Y(n798) );
  NAND2BX1 I656 ( .AN(n845), .B(n970), .Y(n662) );
  OR4X2 I657 ( .A(n107), .B(n681), .C(n665), .D(n787), .Y(n786) );
  NOR2X1 I658 ( .A(n755), .B(n663), .Y(T2_0_EN) );
  NAND2X1 I659 ( .A(n810), .B(n576), .Y(n600) );
  INVX1 I660 ( .A(n809), .Y(n810) );
  INVX1 I661 ( .A(n764), .Y(n500) );
  INVX1 I662 ( .A(n501), .Y(n717) );
  INVX1 I663 ( .A(n567), .Y(n972) );
  AOI22X1 I664 ( .A0(n970), .A1(n14), .B0(MOVC_INS), .B1(n979), .Y(n888) );
  AOI2BB2X1 I665 ( .A0N(n637), .A1N(n636), .B0(n634), .B1(n635), .Y(n630) );
  AOI2BB1X1 I666 ( .A0N(n680), .A1N(n681), .B0(n616), .Y(n678) );
  AND3X2 I667 ( .A(n271), .B(n339), .C(n502), .Y(n566) );
  INVX1 I668 ( .A(n564), .Y(n502) );
  NOR2X1 I669 ( .A(n856), .B(n961), .Y(n596) );
  NAND2X1 I670 ( .A(n871), .B(n965), .Y(n606) );
  INVX2 I671 ( .A(n638), .Y(n871) );
  AOI2BB1X1 I672 ( .A0N(n560), .A1N(n957), .B0(n640), .Y(n639) );
  NOR2BX1 I673 ( .AN(n600), .B(n559), .Y(n165) );
  OR2X2 I674 ( .A(n962), .B(n637), .Y(n667) );
  NAND2BX2 I675 ( .AN(T2_RES_EN), .B(n742), .Y(MAR_RES_EN) );
  OR3X2 I676 ( .A(n650), .B(n637), .C(n956), .Y(n874) );
  NAND2BX1 I677 ( .AN(n906), .B(n744), .Y(n808) );
  INVX2 I678 ( .A(n962), .Y(n744) );
  OAI2BB1X1 I679 ( .A0N(n10), .A1N(n616), .B0(n531), .Y(n611) );
  INVX2 I680 ( .A(n961), .Y(n601) );
  OR2X2 I681 ( .A(n576), .B(n567), .Y(n539) );
  AND3X1 I682 ( .A(n649), .B(n648), .C(n647), .Y(n642) );
  AND2X2 I683 ( .A(n680), .B(LS1), .Y(n760) );
  AND2X2 I684 ( .A(n608), .B(n609), .Y(T1_B_EN) );
  OR2X2 I685 ( .A(n976), .B(n962), .Y(n628) );
  AOI21X1 I686 ( .A0(n569), .A1(n963), .B0(n638), .Y(n503) );
  INVX1 I687 ( .A(n503), .Y(n865) );
  NOR2X1 I688 ( .A(n520), .B(n800), .Y(MOVX_RI) );
  OR2X2 I689 ( .A(n568), .B(n961), .Y(n598) );
  NOR2BX1 I690 ( .AN(n653), .B(n603), .Y(n56) );
  AND2X1 I691 ( .A(n960), .B(n959), .Y(n937) );
  NAND4X1 I692 ( .A(n720), .B(n955), .C(n845), .D(n764), .Y(n763) );
  AND2X2 I693 ( .A(n905), .B(n808), .Y(n629) );
  OAI211X1 I694 ( .A0(n968), .A1(n664), .B0(n749), .C0(n575), .Y(n748) );
  AND4X1 I695 ( .A(n566), .B(n761), .C(n831), .D(n550), .Y(n866) );
  AOI2BB1X2 I696 ( .A0N(n189), .A1N(n675), .B0(n10), .Y(PC1_P0R_EN) );
  NAND2X1 I697 ( .A(n789), .B(n519), .Y(n815) );
  AOI2BB1X1 I698 ( .A0N(n795), .A1N(n750), .B0(n665), .Y(n792) );
  NAND2BX1 I699 ( .AN(n98), .B(n244), .Y(n107) );
  AND2X2 I700 ( .A(n793), .B(n633), .Y(n631) );
  OR4X2 I701 ( .A(n745), .B(n530), .C(MAR_BAR_EN), .D(n746), .Y(RAM_RD_EN) );
  NAND4BX1 I702 ( .AN(n189), .B(n784), .C(n772), .D(n667), .Y(n783) );
  NAND4X1 I703 ( .A(n864), .B(n794), .C(n865), .D(n662), .Y(n863) );
  AND3X4 I704 ( .A(n978), .B(CS4), .C(n504), .Y(JBC_BIT_EN) );
  INVX1 I705 ( .A(n598), .Y(n504) );
  INVX1 I706 ( .A(n793), .Y(n632) );
  INVX1 I707 ( .A(n954), .Y(n951) );
  NAND3X2 I708 ( .A(IR[6]), .B(n930), .C(IR[4]), .Y(n544) );
  INVX2 I709 ( .A(n544), .Y(n695) );
  OAI21X2 I710 ( .A0(n509), .A1(n663), .B0(n899), .Y(DIV_OP_EN) );
  INVX1 I711 ( .A(n800), .Y(n599) );
  NAND2X1 I712 ( .A(n552), .B(n729), .Y(n742) );
  NAND2X1 I713 ( .A(n634), .B(n601), .Y(n505) );
  NAND2X1 I714 ( .A(n634), .B(n601), .Y(n506) );
  NAND2X2 I715 ( .A(CS2), .B(n978), .Y(n743) );
  NAND3X1 I716 ( .A(IR[0]), .B(n964), .C(n951), .Y(n795) );
  INVX2 I717 ( .A(DIV_OP_EN), .Y(n898) );
  NAND2X1 I718 ( .A(n965), .B(n695), .Y(n605) );
  INVX1 I719 ( .A(n778), .Y(n701) );
  NAND2X1 I720 ( .A(IR[3]), .B(n964), .Y(n809) );
  NAND2X1 I721 ( .A(n834), .B(n544), .Y(n653) );
  INVX1 I722 ( .A(CS2), .Y(n614) );
  INVX2 I723 ( .A(n724), .Y(JBC_BIT_ADDR_EN) );
  INVX1 I724 ( .A(IR[3]), .Y(n940) );
  NAND2X1 I725 ( .A(LS2), .B(CS2), .Y(n737) );
  NAND2BX1 I726 ( .AN(n809), .B(n744), .Y(n761) );
  NAND2BX1 I727 ( .AN(n747), .B(n716), .Y(n821) );
  NAND2X1 I728 ( .A(LS1), .B(n974), .Y(n755) );
  NAND2X1 I729 ( .A(n969), .B(n871), .Y(n738) );
  NAND2X1 I730 ( .A(n577), .B(n925), .Y(n800) );
  INVX1 I731 ( .A(n519), .Y(n520) );
  AND3X2 I732 ( .A(n515), .B(n960), .C(n900), .Y(n509) );
  NOR2X1 I733 ( .A(n743), .B(n516), .Y(JMP_PC_RES_EN) );
  NAND2X2 I734 ( .A(CS2), .B(n979), .Y(n966) );
  NAND2X2 I735 ( .A(n798), .B(n601), .Y(n610) );
  INVX2 I736 ( .A(n568), .Y(n965) );
  BUFX4 I737 ( .A(n650), .Y(n957) );
  INVX1 I738 ( .A(n821), .Y(P0R_MDR_EN) );
  AOI21X1 I739 ( .A0(n632), .A1(n552), .B0(n555), .Y(n714) );
  AND3X2 I740 ( .A(n576), .B(n715), .C(n553), .Y(n555) );
  NOR2X1 I741 ( .A(n772), .B(n966), .Y(PC_AD11_EN) );
  INVX1 I742 ( .A(n553), .Y(n960) );
  OR2X2 I743 ( .A(n165), .B(n755), .Y(n507) );
  INVX1 I744 ( .A(n580), .Y(n956) );
  NOR3X2 I745 ( .A(n534), .B(n535), .C(n536), .Y(n508) );
  AND2X2 I746 ( .A(n577), .B(IR[2]), .Y(n579) );
  NOR2X1 I747 ( .A(n539), .B(n859), .Y(n855) );
  NAND3X2 I748 ( .A(IR[1]), .B(n981), .C(n943), .Y(n637) );
  NAND2X1 I749 ( .A(n599), .B(n924), .Y(n856) );
  NOR2X2 I750 ( .A(n615), .B(n907), .Y(ALU_RLC_EN) );
  NAND2X1 I751 ( .A(n520), .B(n638), .Y(n811) );
  NAND2BX1 I752 ( .AN(n836), .B(n653), .Y(n768) );
  NOR2X1 I753 ( .A(n973), .B(n872), .Y(C_CB_EN) );
  INVX2 I754 ( .A(n856), .Y(n634) );
  INVX2 I755 ( .A(n755), .Y(n608) );
  NAND2X1 I756 ( .A(n969), .B(n601), .Y(n710) );
  NAND2X1 I757 ( .A(IR[3]), .B(n981), .Y(n906) );
  NOR2X1 I758 ( .A(n615), .B(n647), .Y(ALU_RR_EN) );
  BUFX3 I759 ( .A(IR[7]), .Y(n964) );
  NAND2X1 I760 ( .A(n579), .B(n580), .Y(n339) );
  NAND2BX1 I761 ( .AN(n809), .B(n580), .Y(n271) );
  OAI21X1 I762 ( .A0(n569), .A1(n520), .B0(n865), .Y(n765) );
  NAND2X1 I763 ( .A(LS1), .B(n977), .Y(n900) );
  INVX2 I764 ( .A(n795), .Y(n715) );
  INVX1 I765 ( .A(n768), .Y(n595) );
  NAND2X1 I766 ( .A(n975), .B(n580), .Y(n764) );
  NAND4X1 I767 ( .A(n508), .B(n766), .C(n767), .D(n768), .Y(n692) );
  NOR2X1 I768 ( .A(n615), .B(n874), .Y(C_ALLZ_B_OR_EN) );
  NAND4BBX1 I769 ( .AN(n537), .BN(n538), .C(n799), .D(n929), .Y(ALU_ADD_EN) );
  OAI2BB1X1 I770 ( .A0N(n879), .A1N(n880), .B0(n978), .Y(n641) );
  INVX1 I771 ( .A(n799), .Y(MUL_OP_EN) );
  NOR2X1 I772 ( .A(n667), .B(n743), .Y(PC_T2T1_EN) );
  INVX1 I773 ( .A(n10), .Y(n112) );
  AOI21X1 I774 ( .A0(n977), .A1(n708), .B0(n709), .Y(n706) );
  NAND2X1 I775 ( .A(n785), .B(IR[4]), .Y(n939) );
  NAND2X1 I776 ( .A(n975), .B(n695), .Y(n655) );
  NAND2X1 I777 ( .A(IR[1]), .B(n940), .Y(n952) );
  INVX1 I778 ( .A(n883), .Y(n895) );
  NOR2X1 I779 ( .A(n953), .B(n743), .Y(ALLZ_B_PC_RES_EN) );
  INVX1 I780 ( .A(n850), .Y(n976) );
  NOR3BX1 I781 ( .AN(IR[2]), .B(n952), .C(n964), .Y(n850) );
  NAND2X1 I782 ( .A(n580), .B(n965), .Y(n443) );
  NOR3BX2 I783 ( .AN(n977), .B(n957), .C(n506), .Y(ALU_BITC_EN) );
  INVX2 I784 ( .A(n836), .Y(n835) );
  NAND3X2 I785 ( .A(IR[0]), .B(n942), .C(n951), .Y(n836) );
  NOR2X1 I786 ( .A(n636), .B(n637), .Y(n535) );
  INVX2 I787 ( .A(n906), .Y(n789) );
  NAND3X1 I788 ( .A(n924), .B(n981), .C(n951), .Y(n603) );
  INVX1 I789 ( .A(n603), .Y(n887) );
  NAND2X1 I790 ( .A(n579), .B(n811), .Y(n844) );
  BUFX4 I791 ( .A(CS3), .Y(n974) );
  NAND2X1 I792 ( .A(n895), .B(n695), .Y(n649) );
  NOR2X2 I793 ( .A(n743), .B(n606), .Y(C_PC_RES_EN) );
  NOR2X2 I794 ( .A(n966), .B(n605), .Y(C_B_PC_RES_EN) );
  NAND2X1 I795 ( .A(n933), .B(n934), .Y(n799) );
  NAND2X1 I796 ( .A(n513), .B(n937), .Y(n933) );
  INVX1 I797 ( .A(IR[1]), .Y(n932) );
  NOR3BX2 I798 ( .AN(n977), .B(n957), .C(n710), .Y(DP_T2T1_EN) );
  BUFX3 I799 ( .A(n750), .Y(n962) );
  INVX1 I800 ( .A(IR[2]), .Y(n925) );
  INVX2 I801 ( .A(LS1), .Y(n691) );
  INVX1 I802 ( .A(n831), .Y(n677) );
  NOR2X2 I803 ( .A(n973), .B(n662), .Y(T1_XCHD_MDR_EN) );
  NAND4X1 I804 ( .A(IR[0]), .B(n932), .C(n925), .D(n940), .Y(n772) );
  NAND2X1 I805 ( .A(n969), .B(n695), .Y(n831) );
  NAND2X1 I806 ( .A(n630), .B(n631), .Y(n594) );
  NAND2X1 I807 ( .A(n695), .B(n715), .Y(n597) );
  NAND3X2 I808 ( .A(n540), .B(n541), .C(n542), .Y(T2_P0R_EN) );
  OAI21X1 I809 ( .A0(n639), .A1(n973), .B0(n47), .Y(WA_EN) );
  NAND2X2 I810 ( .A(CS2), .B(n978), .Y(n967) );
  INVX2 I811 ( .A(n737), .Y(n716) );
  OAI21X1 I812 ( .A0(n692), .A1(n718), .B0(n719), .Y(n712) );
  NOR2X1 I813 ( .A(n615), .B(n625), .Y(n719) );
  NAND2X2 I814 ( .A(n598), .B(n916), .Y(n675) );
  NAND3X1 I815 ( .A(n832), .B(n508), .C(n833), .Y(n788) );
  NOR3X1 I816 ( .A(n595), .B(n564), .C(n672), .Y(n832) );
  NOR2X2 I817 ( .A(n615), .B(n641), .Y(CY_AC_OV_UP) );
  BUFX8 I818 ( .A(CS1), .Y(n977) );
  NOR2X1 I819 ( .A(n967), .B(n884), .Y(CAR_PC_RES_EN) );
  INVX1 I820 ( .A(n742), .Y(ID_PCH_EN) );
  INVX1 I821 ( .A(POR), .Y(n1) );
  DFFRHQX1 ID_T2_EN_g_reg ( .D(ID_T2_EN), .CK(CLK), .RN(n1), .Q(ID_T2_EN_g) );
  AND2X2 I822 ( .A(n519), .B(n965), .Y(n510) );
  OR2X4 I823 ( .A(n551), .B(n594), .Y(read_modify) );
  AND3X2 I824 ( .A(n669), .B(n671), .C(n670), .Y(n512) );
  AND2X2 I825 ( .A(n938), .B(n936), .Y(n513) );
  AND2X2 I826 ( .A(n901), .B(n959), .Y(n515) );
  INVX1 I827 ( .A(n554), .Y(n959) );
  OR2X2 I828 ( .A(n778), .B(n956), .Y(n516) );
  NOR2X4 I829 ( .A(n966), .B(n610), .Y(PC_PC1_EN) );
  INVX2 I830 ( .A(n525), .Y(n955) );
  OR2X2 I831 ( .A(n571), .B(n957), .Y(n518) );
  NOR2X1 I832 ( .A(n774), .B(n615), .Y(PC1_DP_EN) );
  NOR3X2 I833 ( .A(n924), .B(n964), .C(IR[2]), .Y(n543) );
  INVX2 I834 ( .A(IR[0]), .Y(n924) );
  AND3X2 I835 ( .A(IR[6]), .B(n948), .C(n980), .Y(n519) );
  INVX1 I836 ( .A(IR[4]), .Y(n948) );
  BUFX2 I837 ( .A(IR[5]), .Y(n980) );
  INVX2 I838 ( .A(LS2), .Y(n616) );
  NOR2X1 I839 ( .A(n615), .B(n518), .Y(CY_CJNE_EN) );
  AOI2BB1X2 I840 ( .A0N(n686), .A1N(n968), .B0(n676), .Y(n571) );
  NAND3X2 I841 ( .A(n932), .B(n940), .C(IR[2]), .Y(n954) );
  INVX2 I842 ( .A(n980), .Y(n930) );
  NOR2X2 I843 ( .A(n973), .B(n801), .Y(MAR_T1_EN) );
  OAI21X1 I844 ( .A0(n855), .A1(n856), .B0(n857), .Y(n705) );
  INVX2 I845 ( .A(n967), .Y(n782) );
  NAND2X2 I846 ( .A(n543), .B(n927), .Y(n778) );
  NOR2X1 I847 ( .A(n565), .B(n958), .Y(XAH_P2R_EN) );
  NOR2X4 I848 ( .A(n973), .B(n648), .Y(ALU_SWAP_EN) );
  NOR2X1 I849 ( .A(n973), .B(n740), .Y(SP_T1_EN) );
  NAND2X2 I850 ( .A(n744), .B(n545), .Y(n663) );
  NOR2X4 I851 ( .A(n954), .B(n546), .Y(n545) );
  AND2X2 I852 ( .A(n970), .B(n974), .Y(n553) );
  OAI21X1 I853 ( .A0(n678), .A1(n679), .B0(n977), .Y(n669) );
  OAI2BB1X1 I854 ( .A0N(n553), .A1N(n729), .B0(n821), .Y(T2_RES_EN) );
  AND2X2 I855 ( .A(n553), .B(n729), .Y(n538) );
  NAND2X2 I856 ( .A(n514), .B(n898), .Y(ALU_SUB_EN) );
  AND2X2 I857 ( .A(n979), .B(n974), .Y(n554) );
  NAND2X1 I858 ( .A(n554), .B(n675), .Y(n784) );
  INVX1 I859 ( .A(n928), .Y(n537) );
  INVX1 I860 ( .A(n964), .Y(n942) );
  NAND2X1 I861 ( .A(n716), .B(n717), .Y(n713) );
  NOR3BX2 I862 ( .AN(n533), .B(n615), .C(n778), .Y(ALU_RRC_EN) );
  INVX1 I863 ( .A(n598), .Y(n621) );
  INVX1 I864 ( .A(n589), .Y(CY_AC_OV_SUB_UP) );
  INVX1 I865 ( .A(n582), .Y(XAL_MDR_EN) );
  AND2X1 I866 ( .A(n782), .B(n741), .Y(T1_RES_EN) );
  INVX1 I867 ( .A(n910), .Y(ALLZ_PC_RES_EN) );
  OR2X1 I868 ( .A(n973), .B(n644), .Y(n521) );
  NOR2X1 I869 ( .A(n615), .B(n645), .Y(ALU_RL_EN) );
  INVX1 I870 ( .A(n554), .Y(n958) );
  NAND2X1 I871 ( .A(n558), .B(n634), .Y(n875) );
  OR2X1 I872 ( .A(n902), .B(n144), .Y(n215) );
  INVX1 I873 ( .A(n443), .Y(n144) );
  NOR2X1 I874 ( .A(n615), .B(n877), .Y(C_ALLZ_AND_EN) );
  AOI21X1 I875 ( .A0(n617), .A1(n618), .B0(n958), .Y(XA_DP_EN) );
  INVX1 I876 ( .A(n585), .Y(OV_T1Z_EN) );
  NAND2X1 I877 ( .A(n738), .B(n831), .Y(n741) );
  NAND2X1 I878 ( .A(n835), .B(n702), .Y(n633) );
  NAND2X1 I879 ( .A(n887), .B(n744), .Y(n652) );
  INVX1 I880 ( .A(n864), .Y(n672) );
  OAI21X1 I881 ( .A0(n715), .A1(n579), .B0(n744), .Y(n864) );
  NAND2X1 I882 ( .A(n557), .B(n969), .Y(n877) );
  NAND2X1 I883 ( .A(n579), .B(n695), .Y(n845) );
  NAND2X1 I884 ( .A(n975), .B(n519), .Y(n657) );
  NAND2X1 I885 ( .A(n975), .B(n871), .Y(n656) );
  NAND2X1 I886 ( .A(n871), .B(n634), .Y(n854) );
  NAND2X1 I887 ( .A(n871), .B(n789), .Y(n658) );
  NOR3X1 I888 ( .A(n524), .B(n946), .C(n881), .Y(n945) );
  AND2X1 I889 ( .A(n744), .B(n835), .Y(n524) );
  NAND2X1 I890 ( .A(n789), .B(n695), .Y(n816) );
  NAND2X1 I891 ( .A(n558), .B(n969), .Y(n873) );
  AND2X1 I892 ( .A(n850), .B(n601), .Y(n525) );
  NAND2X1 I893 ( .A(n895), .B(n580), .Y(n644) );
  NAND2X1 I894 ( .A(n895), .B(n871), .Y(n648) );
  NAND2X1 I895 ( .A(n567), .B(n810), .Y(n161) );
  NAND2X1 I896 ( .A(CS2), .B(n13), .Y(n901) );
  NAND2X1 I897 ( .A(n576), .B(n634), .Y(n893) );
  INVX1 I898 ( .A(n765), .Y(n720) );
  AND2X1 I899 ( .A(n810), .B(n695), .Y(n559) );
  AND4X1 I900 ( .A(n970), .B(n567), .C(n715), .D(n977), .Y(DPTR_DEC_EN) );
  INVX2 I901 ( .A(n970), .Y(n625) );
  OR2X1 I902 ( .A(ALU_RLC_EN), .B(ALU_RRC_EN), .Y(CY_UP) );
  INVX1 I903 ( .A(n884), .Y(MOVC_INS) );
  NAND2X1 I904 ( .A(n969), .B(n519), .Y(n618) );
  NOR2BX1 I905 ( .AN(CS1), .B(n885), .Y(A_T1_EN) );
  NAND2X1 I906 ( .A(n969), .B(n744), .Y(n607) );
  NAND2X1 I907 ( .A(n759), .B(n977), .Y(n527) );
  OAI21X1 I908 ( .A0(n818), .A1(n691), .B0(n819), .Y(MAR_RI_EN) );
  OAI21X1 I909 ( .A0(n691), .A1(n710), .B0(n711), .Y(n708) );
  NAND2BX1 I910 ( .AN(PC_RET_EN), .B(n742), .Y(SP_RES_EN) );
  NAND2X1 I911 ( .A(n580), .B(n887), .Y(n244) );
  OR2X2 I912 ( .A(n788), .B(n668), .Y(n529) );
  AOI21X1 I913 ( .A0(n689), .A1(n690), .B0(n691), .Y(n688) );
  NAND2X1 I914 ( .A(n969), .B(n580), .Y(n617) );
  AND2X1 I915 ( .A(n580), .B(n715), .Y(n564) );
  INVX1 I916 ( .A(n761), .Y(n787) );
  AND2X1 I917 ( .A(n572), .B(n977), .Y(B_T2RES_EN) );
  AND2X1 I918 ( .A(n580), .B(n599), .Y(MOVX_RI_A) );
  NAND2X1 I919 ( .A(n596), .B(LS3), .Y(n626) );
  AND2X1 I920 ( .A(n793), .B(n794), .Y(n563) );
  NOR2X1 I921 ( .A(n594), .B(n627), .Y(n624) );
  NAND2X1 I922 ( .A(n789), .B(n580), .Y(n604) );
  AND2X2 I923 ( .A(n579), .B(n748), .Y(n530) );
  AND2X1 I924 ( .A(CS2), .B(n15), .Y(n531) );
  OR2X2 I925 ( .A(n931), .B(n532), .Y(n568) );
  NAND2X1 I926 ( .A(n932), .B(n981), .Y(n532) );
  NAND2X1 I927 ( .A(n962), .B(n961), .Y(n702) );
  NAND2BX1 I928 ( .AN(n778), .B(n653), .Y(n793) );
  NOR2X1 I929 ( .A(n961), .B(n957), .Y(n533) );
  NAND2X1 I930 ( .A(n812), .B(n813), .Y(n769) );
  NOR3X1 I931 ( .A(n654), .B(n661), .C(n814), .Y(n813) );
  NAND2X1 I932 ( .A(n837), .B(n838), .Y(n534) );
  NOR2X1 I933 ( .A(n836), .B(n971), .Y(n536) );
  NAND2X1 I934 ( .A(n979), .B(n949), .Y(n880) );
  INVX2 I935 ( .A(n976), .Y(n975) );
  INVX1 I936 ( .A(n772), .Y(n785) );
  NAND2X1 I937 ( .A(LS2), .B(n974), .Y(n664) );
  BUFX3 I938 ( .A(LS4), .Y(n978) );
  NOR2X1 I939 ( .A(n637), .B(n956), .Y(n858) );
  NAND2X1 I940 ( .A(n922), .B(n634), .Y(n876) );
  BUFX3 I941 ( .A(LS4), .Y(n979) );
  BUFX3 I942 ( .A(LS3), .Y(n970) );
  AND3X1 I943 ( .A(n576), .B(n545), .C(n553), .Y(n573) );
  INVX1 I944 ( .A(n974), .Y(n852) );
  NOR2X1 I945 ( .A(n878), .B(n615), .Y(C_0_EN) );
  OAI2BB1X1 I946 ( .A0N(n608), .A1N(n675), .B0(n853), .Y(MAR_BAR_EN) );
  AND2X1 I947 ( .A(n554), .B(n729), .Y(n574) );
  NAND3X1 I948 ( .A(LS1), .B(n668), .C(n977), .Y(n540) );
  NAND2X1 I949 ( .A(n666), .B(n608), .Y(n541) );
  NAND2X1 I950 ( .A(n665), .B(n112), .Y(n542) );
  OAI21X1 I951 ( .A0(n829), .A1(n691), .B0(n830), .Y(n828) );
  NOR2X1 I952 ( .A(n686), .B(n968), .Y(n684) );
  OR2X1 I953 ( .A(n962), .B(n737), .Y(n575) );
  NAND3BX1 I954 ( .AN(IR[3]), .B(n925), .C(n924), .Y(n931) );
  NAND2X1 I955 ( .A(n964), .B(n924), .Y(n546) );
  INVX1 I956 ( .A(IR[6]), .Y(n941) );
  BUFX8 I957 ( .A(n615), .Y(n973) );
  INVX1 I958 ( .A(n548), .Y(n685) );
  NAND2X1 I959 ( .A(n621), .B(n782), .Y(n915) );
  INVX1 I960 ( .A(n591), .Y(T2_XCHD_A_EN) );
  INVX1 I961 ( .A(T1_XCHD_MDR_EN), .Y(n591) );
  NOR2X1 I962 ( .A(n615), .B(n875), .Y(C_ALLZ_B_EN) );
  INVX1 I963 ( .A(XAH_P2R_EN), .Y(n582) );
  INVX1 I964 ( .A(ALU_SUBBC_EN), .Y(n589) );
  NOR2X1 I965 ( .A(n510), .B(n144), .Y(n548) );
  INVX1 I966 ( .A(n784), .Y(F5_ALLZ_EN) );
  INVX1 I967 ( .A(n215), .Y(n953) );
  NAND2BX1 I968 ( .AN(n559), .B(n597), .Y(n622) );
  NAND3X1 I969 ( .A(n903), .B(n904), .C(n977), .Y(n896) );
  OAI21X1 I970 ( .A0(n677), .A1(n902), .B0(n782), .Y(n897) );
  INVX4 I971 ( .A(n521), .Y(ALU_CPL_EN) );
  NOR2X1 I972 ( .A(n973), .B(n890), .Y(ALU_XRL_EN) );
  NAND2BX1 I973 ( .AN(n957), .B(n891), .Y(n890) );
  NAND4X1 I974 ( .A(n815), .B(n657), .C(n892), .D(n893), .Y(n891) );
  NAND2X1 I975 ( .A(n782), .B(n510), .Y(n910) );
  NAND2X1 I976 ( .A(n720), .B(n628), .Y(n718) );
  INVX1 I977 ( .A(n815), .Y(n661) );
  NAND2X1 I978 ( .A(n656), .B(n655), .Y(n849) );
  NAND2X1 I979 ( .A(n674), .B(n675), .Y(n673) );
  NOR2X1 I980 ( .A(n443), .B(n967), .Y(n908) );
  INVX1 I981 ( .A(n854), .Y(n725) );
  INVX1 I982 ( .A(n816), .Y(n654) );
  INVX1 I983 ( .A(n658), .Y(n814) );
  NAND3X1 I984 ( .A(n914), .B(n784), .C(n915), .Y(ALU_ANL_EN) );
  INVX1 I985 ( .A(CY_UP), .Y(n47) );
  NAND2X1 I986 ( .A(n887), .B(n601), .Y(n659) );
  NAND2X1 I987 ( .A(n567), .B(n887), .Y(n602) );
  NOR2X1 I988 ( .A(n625), .B(n955), .Y(n679) );
  INVX1 I989 ( .A(n657), .Y(n848) );
  INVX1 I990 ( .A(n873), .Y(n920) );
  NOR2X1 I991 ( .A(n973), .B(n626), .Y(T1_BITCP_EN) );
  NAND3X1 I992 ( .A(n641), .B(n642), .C(n643), .Y(n640) );
  NAND2X1 I993 ( .A(n621), .B(n716), .Y(n724) );
  NOR2X1 I994 ( .A(n958), .B(n610), .Y(n709) );
  NOR2X1 I995 ( .A(n972), .B(n625), .Y(n870) );
  NOR2X1 I996 ( .A(n615), .B(n649), .Y(CY_DA_UP) );
  INVX1 I997 ( .A(n618), .Y(MOVX_DPI) );
  INVX1 I998 ( .A(T2_REM2_EN), .Y(n585) );
  INVX2 I999 ( .A(n587), .Y(B_T1_EN) );
  INVX1 I1000 ( .A(CY0_MUL_OV_UP), .Y(n587) );
  NAND3X1 I1001 ( .A(n764), .B(n604), .C(n563), .Y(n668) );
  OR2X2 I1002 ( .A(n215), .B(n216), .Y(n189) );
  OR4X2 I1003 ( .A(n510), .B(n217), .C(n218), .D(n147), .Y(n216) );
  INVX1 I1004 ( .A(n606), .Y(n217) );
  INVX1 I1005 ( .A(n607), .Y(n147) );
  AND2X2 I1006 ( .A(n109), .B(n112), .Y(PC1_PCCALL_EN) );
  INVX1 I1007 ( .A(n610), .Y(n109) );
  NAND2X1 I1008 ( .A(n652), .B(n633), .Y(n733) );
  NAND2X1 I1009 ( .A(n629), .B(n659), .Y(n734) );
  OR2X2 I1010 ( .A(MOVX_DPI_A), .B(MOVX_RI_A), .Y(n15) );
  INVX1 I1011 ( .A(n617), .Y(MOVX_DPI_A) );
  NOR2X1 I1012 ( .A(n973), .B(n873), .Y(C_ALLZ_OR_EN) );
  OR2X2 I1013 ( .A(n15), .B(n14), .Y(MOVX_INS) );
  INVX1 I1014 ( .A(n605), .Y(n218) );
  NAND2X1 I1015 ( .A(n619), .B(n620), .Y(WM_EN) );
  NAND2X1 I1016 ( .A(n977), .B(n623), .Y(n619) );
  OAI21X1 I1017 ( .A0(n621), .A1(n622), .B0(n552), .Y(n620) );
  OAI21X1 I1018 ( .A0(n624), .A1(n625), .B0(n626), .Y(n623) );
  INVX1 I1019 ( .A(n710), .Y(n665) );
  NAND3X1 I1020 ( .A(n610), .B(n667), .C(n597), .Y(n797) );
  AND2X2 I1021 ( .A(n604), .B(n161), .Y(n550) );
  INVX1 I1022 ( .A(n667), .Y(n666) );
  INVX1 I1023 ( .A(n771), .Y(PC_HOLD) );
  NAND2X1 I1024 ( .A(n557), .B(n701), .Y(n907) );
  NAND3X1 I1025 ( .A(n677), .B(n978), .C(CS2), .Y(n670) );
  NAND2X1 I1026 ( .A(n672), .B(n552), .Y(n671) );
  NAND2X1 I1027 ( .A(n572), .B(n977), .Y(n899) );
  INVX1 I1028 ( .A(n769), .Y(n767) );
  INVX1 I1029 ( .A(n770), .Y(n766) );
  OAI21X1 I1030 ( .A0(n947), .A1(n972), .B0(n602), .Y(n881) );
  NOR3X1 I1031 ( .A(n835), .B(n975), .C(n789), .Y(n947) );
  NAND2X1 I1032 ( .A(n695), .B(n894), .Y(n926) );
  NAND2X1 I1033 ( .A(n576), .B(n835), .Y(n837) );
  NAND2X1 I1034 ( .A(n846), .B(n847), .Y(n770) );
  AOI21X1 I1035 ( .A0(n975), .A1(n539), .B0(n851), .Y(n846) );
  NOR2X1 I1036 ( .A(n848), .B(n849), .Y(n847) );
  NOR2X1 I1037 ( .A(n961), .B(n963), .Y(n851) );
  NAND2X1 I1038 ( .A(n601), .B(n715), .Y(n838) );
  AND2X4 I1039 ( .A(CS2), .B(n970), .Y(n552) );
  OAI21X1 I1040 ( .A0(n917), .A1(n918), .B0(n977), .Y(n914) );
  NAND4X1 I1041 ( .A(n877), .B(n876), .C(n919), .D(n875), .Y(n918) );
  NOR2X1 I1042 ( .A(n923), .B(n957), .Y(n917) );
  NOR2X1 I1043 ( .A(n920), .B(n921), .Y(n919) );
  INVX1 I1044 ( .A(n653), .Y(n636) );
  INVX1 I1045 ( .A(n664), .Y(n674) );
  INVX1 I1046 ( .A(n811), .Y(n834) );
  NAND2X1 I1047 ( .A(CS2), .B(n13), .Y(n938) );
  NAND2BX1 I1048 ( .AN(n615), .B(n944), .Y(n928) );
  OAI21X1 I1049 ( .A0(n945), .A1(n957), .B0(n649), .Y(n944) );
  INVX1 I1050 ( .A(n874), .Y(n921) );
  NOR2X1 I1051 ( .A(n743), .B(n607), .Y(SJMP_PC_RES_EN) );
  NAND2X1 I1052 ( .A(n965), .B(n539), .Y(n916) );
  AND2X2 I1053 ( .A(n882), .B(n963), .Y(n556) );
  NAND2X2 I1054 ( .A(n798), .B(n539), .Y(n747) );
  AND2X2 I1055 ( .A(n576), .B(n978), .Y(n557) );
  AND2X2 I1056 ( .A(n567), .B(n978), .Y(n558) );
  NAND3X1 I1057 ( .A(n808), .B(n628), .C(n652), .Y(n946) );
  NAND2BX1 I1058 ( .AN(n622), .B(n571), .Y(n902) );
  NAND2X1 I1059 ( .A(n558), .B(n701), .Y(n645) );
  NAND2X1 I1060 ( .A(n519), .B(n894), .Y(n892) );
  INVX1 I1061 ( .A(n663), .Y(n609) );
  NOR2X1 I1062 ( .A(n957), .B(n961), .Y(n903) );
  AOI21X1 I1063 ( .A0(n871), .A1(n894), .B0(n913), .Y(n912) );
  NAND2X1 I1064 ( .A(n658), .B(n656), .Y(n913) );
  INVX1 I1065 ( .A(n979), .Y(n650) );
  NOR3BX1 I1066 ( .AN(n977), .B(n963), .C(n889), .Y(A_IDATA_EN) );
  NAND2X1 I1067 ( .A(n519), .B(n978), .Y(n889) );
  OAI21X1 I1068 ( .A0(n765), .A1(n886), .B0(n978), .Y(n885) );
  NAND2X1 I1069 ( .A(n845), .B(n244), .Y(n886) );
  NOR2X1 I1070 ( .A(n888), .B(n615), .Y(A_MRR_EN) );
  NAND2X1 I1071 ( .A(n677), .B(n716), .Y(n802) );
  NAND2BX1 I1072 ( .AN(PC1_P0R_EN), .B(n773), .Y(PC2_PC_EN) );
  OAI21X2 I1073 ( .A0(n803), .A1(n973), .B0(n507), .Y(MAR_RN_EN) );
  NOR2BX1 I1074 ( .AN(n970), .B(n550), .Y(n804) );
  NAND3X1 I1075 ( .A(n970), .B(n705), .C(n977), .Y(n704) );
  NOR2X1 I1076 ( .A(n615), .B(n876), .Y(C_ALLZ_B_AND_EN) );
  NAND2X1 I1077 ( .A(LS3), .B(n107), .Y(n711) );
  AOI21X1 I1078 ( .A0(n717), .A1(n112), .B0(n820), .Y(n819) );
  NOR3BX1 I1079 ( .AN(n977), .B(n628), .C(n691), .Y(n820) );
  NOR2X1 I1080 ( .A(n973), .B(n703), .Y(T2_1_EN) );
  NAND3BX1 I1081 ( .AN(n840), .B(n841), .C(n842), .Y(n839) );
  OAI21X1 I1082 ( .A0(n770), .A1(n843), .B0(n977), .Y(n841) );
  INVX1 I1083 ( .A(n881), .Y(n879) );
  OR2X2 I1084 ( .A(MOVX_DPI), .B(MOVX_RI), .Y(n14) );
  NAND3X1 I1085 ( .A(n824), .B(n825), .C(n826), .Y(n754) );
  NAND2X1 I1086 ( .A(n632), .B(CS2), .Y(n824) );
  NAND2X1 I1087 ( .A(n715), .B(n827), .Y(n826) );
  NAND2X1 I1088 ( .A(n576), .B(n965), .Y(n867) );
  NOR2BX1 I1089 ( .AN(n827), .B(n963), .Y(n840) );
  NAND2X1 I1090 ( .A(n773), .B(n776), .Y(PC1_A_EN) );
  BUFX3 I1091 ( .A(n593), .Y(CY0_MUL_OV_UP) );
  NOR3BX1 I1092 ( .AN(n977), .B(n883), .C(n972), .Y(n593) );
  NAND2X1 I1093 ( .A(n723), .B(n724), .Y(T1_CBP_EN) );
  NAND3X1 I1094 ( .A(n725), .B(n970), .C(n977), .Y(n723) );
  NOR2X1 I1095 ( .A(n973), .B(n860), .Y(INT_EN_1_EN) );
  NOR3BX1 I1096 ( .AN(CS1), .B(n957), .C(n663), .Y(CY0_DIV_OV_UP) );
  AOI2BB1X2 I1097 ( .A0N(n687), .A1N(n625), .B0(n688), .Y(n682) );
  OAI21X2 I1098 ( .A0(n684), .A1(n685), .B0(n608), .Y(n683) );
  NOR2X1 I1099 ( .A(n696), .B(n697), .Y(n687) );
  NAND4X1 I1100 ( .A(n955), .B(n339), .C(n844), .D(n845), .Y(n843) );
  NAND2X1 I1101 ( .A(n979), .B(n741), .Y(n740) );
  NOR2X1 I1102 ( .A(n692), .B(n693), .Y(n689) );
  NAND3X1 I1103 ( .A(n659), .B(n652), .C(n694), .Y(n693) );
  NAND2X1 I1104 ( .A(n580), .B(n835), .Y(n794) );
  OAI21X1 I1105 ( .A0(n529), .A1(n786), .B0(n782), .Y(n780) );
  NOR2X1 I1106 ( .A(n769), .B(n806), .Y(n805) );
  NAND3X1 I1107 ( .A(n807), .B(n271), .C(n629), .Y(n806) );
  AOI21X1 I1108 ( .A0(n810), .A1(n811), .B0(n787), .Y(n807) );
  AOI21X1 I1109 ( .A0(n790), .A1(CS4), .B0(n791), .Y(n779) );
  AOI21X1 I1110 ( .A0(n796), .A1(n571), .B0(n957), .Y(n790) );
  AOI21X1 I1111 ( .A0(n792), .A1(n563), .B0(n959), .Y(n791) );
  NOR2X1 I1112 ( .A(n797), .B(n675), .Y(n796) );
  NAND2X1 I1113 ( .A(n554), .B(n783), .Y(n771) );
  INVX1 I1114 ( .A(n703), .Y(n759) );
  NOR2X1 I1115 ( .A(T1_RES_EN), .B(n574), .Y(n781) );
  INVX1 I1116 ( .A(n865), .Y(n697) );
  NOR2X1 I1117 ( .A(MOVX_RI_A), .B(MOVX_RI), .Y(n565) );
  NAND3X1 I1118 ( .A(n955), .B(n628), .C(n629), .Y(n627) );
  NOR2X1 I1119 ( .A(n973), .B(n861), .Y(ID_T2_EN) );
  OAI21X1 I1120 ( .A0(n862), .A1(n863), .B0(n970), .Y(n861) );
  NAND2X1 I1121 ( .A(n801), .B(n866), .Y(n862) );
  AOI2BB1X1 I1122 ( .A0N(n552), .A1N(n112), .B0(n747), .Y(n746) );
  NAND3X1 I1123 ( .A(n13), .B(n14), .C(n613), .Y(n612) );
  NAND2X1 I1124 ( .A(n614), .B(n615), .Y(n613) );
  OAI21X1 I1125 ( .A0(n757), .A1(n616), .B0(n758), .Y(n756) );
  NOR2X1 I1126 ( .A(n759), .B(n760), .Y(n758) );
  NOR2X1 I1127 ( .A(n692), .B(n763), .Y(n757) );
  NAND4X1 I1128 ( .A(n751), .B(n507), .C(n752), .D(n753), .Y(n745) );
  NAND2X1 I1129 ( .A(n677), .B(n552), .Y(n752) );
  NAND2BX1 I1130 ( .AN(n615), .B(n756), .Y(n751) );
  NAND3X1 I1131 ( .A(n519), .B(n970), .C(n977), .Y(n749) );
  NAND2X1 I1132 ( .A(n611), .B(n612), .Y(XA_OUT_EN) );
  AOI2BB1X1 I1133 ( .A0N(n738), .A1N(n966), .B0(ID_PCH_EN), .Y(n929) );
  AOI21X1 I1134 ( .A0(n969), .A1(n539), .B0(n858), .Y(n857) );
  NAND2X1 I1135 ( .A(n962), .B(n544), .Y(n859) );
  AND3X2 I1136 ( .A(n948), .B(n941), .C(n980), .Y(n567) );
  OAI21X1 I1137 ( .A0(LS2), .A1(LS1), .B0(n977), .Y(n936) );
  AOI21X1 I1138 ( .A0(n789), .A1(n539), .B0(n817), .Y(n812) );
  NOR2X1 I1139 ( .A(n961), .B(n809), .Y(n817) );
  NAND3X1 I1140 ( .A(n638), .B(n544), .C(n968), .Y(n635) );
  NOR2X1 I1141 ( .A(n935), .B(n971), .Y(n934) );
  INVX1 I1142 ( .A(n545), .Y(n935) );
  AND2X2 I1143 ( .A(n795), .B(n809), .Y(n569) );
  INVX1 I1144 ( .A(n952), .Y(n927) );
  NAND2BX1 I1145 ( .AN(n906), .B(n601), .Y(n905) );
  BUFX3 I1146 ( .A(n942), .Y(n981) );
  NAND4X1 I1147 ( .A(n603), .B(n778), .C(n637), .D(n836), .Y(n894) );
  NOR2X1 I1148 ( .A(n545), .B(n715), .Y(n686) );
  OR2X2 I1149 ( .A(LS2), .B(LS1), .Y(n570) );
  OAI21X1 I1150 ( .A0(n950), .A1(n968), .B0(n837), .Y(n949) );
  NOR3X1 I1151 ( .A(n887), .B(n975), .C(n789), .Y(n950) );
  NAND2X1 I1152 ( .A(n979), .B(n545), .Y(n883) );
  NOR2X1 I1153 ( .A(n957), .B(n962), .Y(n922) );
  NOR2X1 I1154 ( .A(n545), .B(n810), .Y(n882) );
  AND2X2 I1155 ( .A(LS2), .B(n609), .Y(n572) );
  NOR2X1 I1156 ( .A(n869), .B(n615), .Y(DPTR_INC_EN) );
  NAND2X1 I1157 ( .A(n870), .B(n581), .Y(n869) );
  NAND2BX1 I1158 ( .AN(n615), .B(n828), .Y(n822) );
  NAND2X1 I1159 ( .A(LS1), .B(n754), .Y(n823) );
  OAI21X1 I1160 ( .A0(n581), .A1(n715), .B0(n775), .Y(n774) );
  NOR2X1 I1161 ( .A(n616), .B(n971), .Y(n775) );
  NAND2X1 I1162 ( .A(n581), .B(n557), .Y(n872) );
  NAND3X1 I1163 ( .A(n581), .B(n744), .C(n716), .Y(n773) );
  NAND3X1 I1164 ( .A(n581), .B(n601), .C(n716), .Y(n777) );
  NAND4X1 I1165 ( .A(n657), .B(n658), .C(n659), .D(n660), .Y(n651) );
  AOI21X1 I1166 ( .A0(n519), .A1(n545), .B0(n661), .Y(n660) );
  NAND2X1 I1167 ( .A(n581), .B(n702), .Y(n884) );
  NOR2X1 I1168 ( .A(n973), .B(n721), .Y(T1_DAD_EN) );
  NAND2X1 I1169 ( .A(n722), .B(n545), .Y(n721) );
  NOR2X1 I1170 ( .A(n544), .B(n625), .Y(n722) );
  OR4X2 I1171 ( .A(n235), .B(n236), .C(n237), .D(n56), .Y(n98) );
  NOR2X1 I1172 ( .A(n603), .B(n968), .Y(n235) );
  AND2X1 I1173 ( .A(n545), .B(n601), .Y(n237) );
  INVX1 I1174 ( .A(n602), .Y(n236) );
  OAI21X1 I1175 ( .A0(n548), .A1(n960), .B0(n739), .Y(T1_0_EN) );
  NAND3X1 I1176 ( .A(n567), .B(n545), .C(n608), .Y(n739) );
  AOI21X1 I1177 ( .A0(n674), .A1(n729), .B0(n736), .Y(n735) );
  NAND4BX1 I1178 ( .AN(T2_SP_EN), .B(n726), .C(n727), .D(n728), .Y(T1_1_EN) );
  NAND2X1 I1179 ( .A(n622), .B(n553), .Y(n728) );
  NAND2X1 I1180 ( .A(n716), .B(n729), .Y(n727) );
  INVX1 I1181 ( .A(n730), .Y(n726) );
  AOI21X1 I1182 ( .A0(n731), .A1(n732), .B0(n615), .Y(n730) );
  NAND2X1 I1183 ( .A(n525), .B(LS2), .Y(n731) );
  OAI21X1 I1184 ( .A0(n733), .A1(n734), .B0(n970), .Y(n732) );
  AOI2BB1X1 I1185 ( .A0N(n834), .A1N(n795), .B0(n762), .Y(n833) );
  NAND3X1 I1186 ( .A(LS1), .B(n681), .C(n977), .Y(n853) );
  NAND2X1 I1187 ( .A(n787), .B(LS2), .Y(n830) );
  NOR2X1 I1188 ( .A(n788), .B(n741), .Y(n829) );
  NAND4X1 I1189 ( .A(n779), .B(n780), .C(n771), .D(n781), .Y(P0R_P0_EN) );
  NAND2BX1 I1190 ( .AN(n628), .B(LS2), .Y(n703) );
  NAND3X1 I1191 ( .A(n698), .B(n699), .C(n700), .Y(n696) );
  NAND2X1 I1192 ( .A(n701), .B(n702), .Y(n698) );
  NAND2X1 I1193 ( .A(n701), .B(n539), .Y(n699) );
  NAND2X1 I1194 ( .A(n545), .B(n695), .Y(n694) );
  NAND2X1 I1195 ( .A(LS2), .B(n754), .Y(n753) );
  INVX1 I1196 ( .A(n931), .Y(n943) );
  NAND3BX1 I1197 ( .AN(n908), .B(n909), .C(n910), .Y(ALU_ORL_EN) );
  NAND3BX1 I1198 ( .AN(n957), .B(n911), .C(n977), .Y(n909) );
  AND3X2 I1199 ( .A(n980), .B(n941), .C(IR[4]), .Y(n576) );
  NAND3BX1 I1200 ( .AN(IR[6]), .B(n930), .C(n948), .Y(n750) );
  AND2X2 I1201 ( .A(n927), .B(n964), .Y(n577) );
  AND3X2 I1202 ( .A(n930), .B(n941), .C(IR[4]), .Y(n578) );
  AND3X2 I1203 ( .A(IR[6]), .B(n980), .C(IR[4]), .Y(n580) );
  AND4X1 I1204 ( .A(n978), .B(n695), .C(n581), .D(CS1), .Y(C_1_EN) );
  AND2X2 I1205 ( .A(n599), .B(IR[0]), .Y(n581) );
  AOI21X2 I1206 ( .A0(n598), .A1(n868), .B0(n966), .Y(F5_B_PC_RES_EN) );
  NOR2X2 I1207 ( .A(n967), .B(n867), .Y(F5_PC_RES_EN) );
  NAND2X1 I1208 ( .A(n567), .B(n965), .Y(n868) );
  DFFRHQX2 ID_PCH_EN_g_reg ( .D(ID_PCH_EN), .CK(CLK), .RN(n1), .Q(ID_PCH_EN_g)
         );
  DFFRHQX2 ID_PCL_EN_g_reg ( .D(n574), .CK(CLK), .RN(n1), .Q(ID_PCL_EN_g) );
  DFFRHQX2 WM_EN_g_reg ( .D(WM_EN), .CK(CLK), .RN(n1), .Q(WM_EN_g) );
  OAI21X4 I1209 ( .A0(n682), .A1(n973), .B0(n683), .Y(T2_A_EN) );
  INVX4 I1210 ( .A(PC2_DP_EN), .Y(n776) );
  OAI21X4 I1211 ( .A0(n10), .A1(n747), .B0(n802), .Y(MAR_SP_EN) );
  NAND2X4 I1212 ( .A(LS1), .B(CS2), .Y(n10) );
  NOR2X4 I1213 ( .A(n973), .B(n646), .Y(ALU_SUBBC_EN) );
  NAND3BX4 I1214 ( .AN(IR[4]), .B(n930), .C(IR[6]), .Y(n638) );
  NOR2X4 I1215 ( .A(n973), .B(n880), .Y(ALU_ADC_EN) );
  INVX8 I1216 ( .A(n977), .Y(n615) );
  AND3X1 I1217 ( .A(CS1), .B(n13), .C(MOVC_INS), .Y(CAR_OUT_EN) );
endmodule


module IR_DECODER1 ( DIR_WR, RETI, IR, CYCLE2, CYCLE3, CYCLE4, BYTE2, BYTE3 );
  input [7:0] IR;
  output DIR_WR, RETI, CYCLE2, CYCLE3, CYCLE4, BYTE2, BYTE3;
  wire   n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
         n144, n145, n146, n147, n148, n149, n150, n151, n152, n153, n154,
         n155, n156, n157, n158, n159, n160, n161, n162, n163, n164, n165,
         n166, n167, n168, n169, n170, n171, n172, n173, n174, n175, n176,
         n177, n178, n179, n180, n181, n182, n183, n184, n185, n186, n187,
         n188, n189, n190, n191, n192, n193, n194, n195, n196, n197, n198,
         n199, n200, n201, n202, n203, n204, n205, n206, n207, n208, n209,
         n210, n211, n212, n213, n214, n215, n216, n217, n218, n219, n220,
         n221, n222, n223;

  OR2X2 I106 ( .A(n131), .B(n106), .Y(n184) );
  OR2X2 I107 ( .A(IR[6]), .B(IR[7]), .Y(n121) );
  OAI2BB1X1 I108 ( .A0N(n154), .A1N(n115), .B0(n213), .Y(n212) );
  NAND2X1 I109 ( .A(n216), .B(n217), .Y(n223) );
  NOR3X1 I110 ( .A(IR[3]), .B(IR[5]), .C(n132), .Y(n146) );
  NAND3X1 I111 ( .A(n189), .B(IR[4]), .C(IR[5]), .Y(n174) );
  AND3X2 I112 ( .A(n156), .B(n157), .C(n158), .Y(n128) );
  OAI31X1 I113 ( .A0(n143), .A1(n121), .A2(n122), .B0(n144), .Y(n142) );
  AOI2BB1X1 I114 ( .A0N(n174), .A1N(n161), .B0(n186), .Y(n185) );
  OAI2BB1X1 I115 ( .A0N(n188), .A1N(n179), .B0(n169), .Y(n205) );
  OR2X2 I116 ( .A(IR[5]), .B(IR[4]), .Y(n203) );
  OR2X1 I117 ( .A(n143), .B(n155), .Y(n110) );
  OR2X1 I118 ( .A(n120), .B(n121), .Y(n102) );
  NAND2X1 I119 ( .A(n127), .B(n172), .Y(n116) );
  AND4X1 I120 ( .A(n208), .B(n147), .C(n222), .D(n166), .Y(n207) );
  OR2X1 I121 ( .A(n126), .B(n127), .Y(n99) );
  NAND2BX1 I122 ( .AN(n131), .B(n130), .Y(n129) );
  NAND2X2 I123 ( .A(n195), .B(n101), .Y(n131) );
  OAI2BB1X1 I124 ( .A0N(n102), .A1N(n99), .B0(n124), .Y(n111) );
  NAND4X1 I125 ( .A(n182), .B(n183), .C(n184), .D(n185), .Y(n150) );
  NAND2X1 I126 ( .A(IR[6]), .B(n193), .Y(n179) );
  INVX2 I127 ( .A(IR[7]), .Y(n193) );
  BUFX3 I128 ( .A(IR[0]), .Y(n222) );
  INVX2 I129 ( .A(n222), .Y(n195) );
  NAND2X1 I130 ( .A(n151), .B(n152), .Y(n138) );
  NAND4BX2 I131 ( .AN(IR[3]), .B(n166), .C(n222), .D(IR[2]), .Y(n127) );
  NAND2X4 I132 ( .A(IR[7]), .B(n202), .Y(n132) );
  INVX8 I133 ( .A(IR[6]), .Y(n202) );
  NOR3BX1 I134 ( .AN(IR[4]), .B(n132), .C(IR[5]), .Y(n103) );
  INVX1 I135 ( .A(IR[1]), .Y(n166) );
  NAND2X1 I136 ( .A(n173), .B(n187), .Y(n209) );
  OAI21X1 I137 ( .A0(n221), .A1(n189), .B0(n176), .Y(n219) );
  INVX1 I138 ( .A(n188), .Y(n173) );
  NAND3X1 I139 ( .A(IR[4]), .B(n202), .C(IR[5]), .Y(n123) );
  AOI21X1 I140 ( .A0(n200), .A1(n201), .B0(n100), .Y(n182) );
  OAI21X1 I141 ( .A0(n196), .A1(n197), .B0(n198), .Y(n183) );
  NAND2X1 I142 ( .A(n128), .B(n129), .Y(CYCLE4) );
  INVX1 I143 ( .A(n127), .Y(n175) );
  NAND3X1 I144 ( .A(n116), .B(n222), .C(n117), .Y(n135) );
  AND3X2 I145 ( .A(IR[4]), .B(n202), .C(IR[5]), .Y(n104) );
  OR2X2 I146 ( .A(n132), .B(n203), .Y(n188) );
  INVX1 I147 ( .A(IR[2]), .Y(n208) );
  INVX2 I148 ( .A(IR[3]), .Y(n147) );
  OAI21X1 I149 ( .A0(n126), .A1(n203), .B0(n123), .Y(n201) );
  AOI21X1 I150 ( .A0(n214), .A1(n101), .B0(n215), .Y(n213) );
  NAND2X1 I151 ( .A(n104), .B(n193), .Y(n155) );
  INVX1 I152 ( .A(n121), .Y(n149) );
  INVX1 I153 ( .A(n179), .Y(n189) );
  NAND2X2 I154 ( .A(IR[4]), .B(n148), .Y(n125) );
  NAND2X1 I155 ( .A(n125), .B(n203), .Y(n115) );
  NAND4X1 I156 ( .A(n107), .B(n108), .C(n134), .D(n135), .Y(CYCLE3) );
  INVX1 I157 ( .A(n133), .Y(n107) );
  NAND4X2 I158 ( .A(IR[1]), .B(n195), .C(n208), .D(n147), .Y(n143) );
  AND2X2 I159 ( .A(n175), .B(n149), .Y(n100) );
  NAND2X2 I160 ( .A(IR[5]), .B(n190), .Y(n122) );
  AND3X2 I161 ( .A(n166), .B(n147), .C(IR[2]), .Y(n101) );
  NAND2X1 I162 ( .A(n208), .B(n147), .Y(n137) );
  INVX2 I163 ( .A(n150), .Y(n139) );
  NOR3BX1 I164 ( .AN(IR[4]), .B(n132), .C(IR[5]), .Y(n170) );
  NAND2X2 I165 ( .A(IR[7]), .B(IR[6]), .Y(n126) );
  INVX2 I166 ( .A(IR[5]), .Y(n148) );
  AND2X2 I167 ( .A(n153), .B(n110), .Y(n105) );
  NAND2X1 I168 ( .A(n171), .B(n172), .Y(n117) );
  NAND2X1 I169 ( .A(n199), .B(n143), .Y(n197) );
  NAND4X2 I170 ( .A(n138), .B(n105), .C(n139), .D(n140), .Y(CYCLE2) );
  AND4X2 I171 ( .A(n179), .B(n191), .C(n192), .D(n155), .Y(n106) );
  AOI21X1 I172 ( .A0(n174), .A1(n188), .B0(n143), .Y(n186) );
  NAND3X1 I173 ( .A(n126), .B(n143), .C(n209), .Y(n152) );
  NAND2BX1 I174 ( .AN(n210), .B(n211), .Y(n151) );
  OAI2BB1X1 I175 ( .A0N(n220), .A1N(n219), .B0(n175), .Y(n153) );
  NAND2X1 I176 ( .A(n199), .B(n147), .Y(n187) );
  INVX1 I177 ( .A(n143), .Y(n154) );
  INVX1 I178 ( .A(n174), .Y(n145) );
  INVX1 I179 ( .A(n126), .Y(n136) );
  NAND3X1 I180 ( .A(n180), .B(IR[5]), .C(n136), .Y(n108) );
  NOR2X1 I181 ( .A(n223), .B(n193), .Y(n200) );
  NAND2X1 I182 ( .A(IR[2]), .B(IR[1]), .Y(n199) );
  NAND2X1 I183 ( .A(n176), .B(n177), .Y(n172) );
  NAND2BX1 I184 ( .AN(n223), .B(n170), .Y(n134) );
  NOR2BX1 I185 ( .AN(IR[1]), .B(IR[2]), .Y(n141) );
  NOR2X1 I186 ( .A(IR[7]), .B(n123), .Y(n118) );
  INVX2 I187 ( .A(IR[4]), .Y(n190) );
  INVX1 I188 ( .A(n110), .Y(RETI) );
  INVX1 I189 ( .A(n187), .Y(n161) );
  NAND3X1 I190 ( .A(n153), .B(n114), .C(n181), .Y(BYTE2) );
  NOR2X1 I191 ( .A(n133), .B(n150), .Y(n181) );
  NAND2X1 I192 ( .A(n151), .B(n152), .Y(n114) );
  NAND2X1 I193 ( .A(n141), .B(n142), .Y(n140) );
  NAND3X1 I194 ( .A(n122), .B(n203), .C(n125), .Y(n176) );
  NOR2X1 I195 ( .A(n145), .B(n146), .Y(n144) );
  NAND2BX1 I196 ( .AN(n126), .B(n212), .Y(n211) );
  NAND3BX1 I197 ( .AN(n109), .B(n219), .C(n209), .Y(n210) );
  NAND2X1 I198 ( .A(n204), .B(n205), .Y(n133) );
  AOI21X1 I199 ( .A0(n206), .A1(n136), .B0(n207), .Y(n204) );
  NAND2BX1 I200 ( .AN(n126), .B(n194), .Y(n220) );
  INVX1 I201 ( .A(n103), .Y(n192) );
  NAND2X1 I202 ( .A(n194), .B(n149), .Y(n191) );
  NOR2X1 I203 ( .A(n173), .B(n145), .Y(n171) );
  INVX1 I204 ( .A(n122), .Y(n194) );
  NAND3X1 I205 ( .A(n135), .B(n134), .C(n128), .Y(BYTE3) );
  NAND4X1 I206 ( .A(n111), .B(n112), .C(n113), .D(n114), .Y(DIR_WR) );
  OAI21X1 I207 ( .A0(n118), .A1(n119), .B0(n169), .Y(n112) );
  INVX1 I208 ( .A(n125), .Y(n124) );
  AOI21X1 I209 ( .A0(n203), .A1(n218), .B0(n195), .Y(n214) );
  NAND2X1 I210 ( .A(IR[5]), .B(IR[4]), .Y(n218) );
  OAI21X1 I211 ( .A0(n164), .A1(n165), .B0(n102), .Y(n163) );
  NAND3X1 I212 ( .A(IR[6]), .B(IR[7]), .C(n166), .Y(n164) );
  NAND2X1 I213 ( .A(n222), .B(IR[2]), .Y(n165) );
  NAND3X1 I214 ( .A(n161), .B(n127), .C(n131), .Y(n159) );
  NOR2X1 I215 ( .A(IR[7]), .B(n123), .Y(n167) );
  NOR2X1 I216 ( .A(n178), .B(n179), .Y(n177) );
  NAND2X1 I217 ( .A(n180), .B(IR[1]), .Y(n178) );
  INVX1 I218 ( .A(n137), .Y(n180) );
  OAI21X1 I219 ( .A0(n167), .A1(n168), .B0(n169), .Y(n156) );
  NAND2X1 I220 ( .A(n162), .B(n163), .Y(n157) );
  AOI2BB2X1 I221 ( .A0N(n160), .A1N(n143), .B0(n109), .B1(n159), .Y(n158) );
  NAND2X1 I222 ( .A(n223), .B(n147), .Y(n196) );
  AND2X2 I223 ( .A(IR[7]), .B(n104), .Y(n109) );
  INVX1 I224 ( .A(n223), .Y(n169) );
  NAND2X1 I225 ( .A(n216), .B(n217), .Y(n120) );
  NOR2X1 I226 ( .A(IR[1]), .B(IR[0]), .Y(n216) );
  NOR2X1 I227 ( .A(IR[3]), .B(IR[2]), .Y(n217) );
  AOI22X1 I228 ( .A0(n100), .A1(n115), .B0(n116), .B1(n117), .Y(n113) );
  NOR2X1 I229 ( .A(n147), .B(n125), .Y(n206) );
  NOR2X1 I230 ( .A(IR[3]), .B(n125), .Y(n162) );
  NOR2X1 I231 ( .A(n125), .B(n223), .Y(n215) );
  NAND2X1 I232 ( .A(n149), .B(n115), .Y(n160) );
  NOR2X1 I233 ( .A(n121), .B(n122), .Y(n119) );
  NOR2X1 I234 ( .A(n121), .B(n122), .Y(n168) );
  NOR2X1 I235 ( .A(IR[4]), .B(n132), .Y(n130) );
  NOR2X1 I236 ( .A(n122), .B(n132), .Y(n198) );
  NOR2X1 I237 ( .A(n190), .B(n132), .Y(n221) );
endmodule


module iram_intf ( IDATA, MAR_RI_EN, RAM_RD_EN, ID_PCH_EN, ID_PCL_EN, ID_T2_EN, 
        WM_EN, SFR_wr, MAR, RAMADDR, IRAM_DIN, RAM_CS_B, RAM_OE_B, RAM_WE_B, 
        ID_WR_EN );
  input [7:0] IDATA;
  input [8:0] MAR;
  output [7:0] RAMADDR;
  output [7:0] IRAM_DIN;
  input MAR_RI_EN, RAM_RD_EN, ID_PCH_EN, ID_PCL_EN, ID_T2_EN, WM_EN;
  output SFR_wr, RAM_CS_B, RAM_OE_B, RAM_WE_B, ID_WR_EN;
  wire   n1, n4, n6, n8, n10, n12, n14, n16, n18, n20, n22, n24, n26, n28, n30,
         n32, n34;

  OR2X2 I8 ( .A(ID_T2_EN), .B(WM_EN), .Y(SFR_wr) );
  OR3X2 I9 ( .A(ID_PCL_EN), .B(ID_PCH_EN), .C(SFR_wr), .Y(ID_WR_EN) );
  NOR2X1 I10 ( .A(RAM_RD_EN), .B(MAR_RI_EN), .Y(RAM_OE_B) );
  INVX1 I11 ( .A(n4), .Y(IRAM_DIN[0]) );
  INVX1 I12 ( .A(IDATA[0]), .Y(n4) );
  AND2X2 I13 ( .A(RAM_OE_B), .B(RAM_WE_B), .Y(RAM_CS_B) );
  INVX1 I14 ( .A(n6), .Y(IRAM_DIN[1]) );
  INVX1 I15 ( .A(IDATA[1]), .Y(n6) );
  OR2X2 I16 ( .A(n1), .B(MAR[8]), .Y(RAM_WE_B) );
  INVX1 I17 ( .A(ID_WR_EN), .Y(n1) );
  INVX1 I18 ( .A(n34), .Y(RAMADDR[7]) );
  INVX1 I19 ( .A(MAR[7]), .Y(n34) );
  INVX1 I20 ( .A(n32), .Y(RAMADDR[6]) );
  INVX1 I21 ( .A(MAR[6]), .Y(n32) );
  INVX1 I22 ( .A(n30), .Y(RAMADDR[5]) );
  INVX1 I23 ( .A(MAR[5]), .Y(n30) );
  INVX1 I24 ( .A(n28), .Y(RAMADDR[4]) );
  INVX1 I25 ( .A(MAR[4]), .Y(n28) );
  INVX1 I26 ( .A(n26), .Y(RAMADDR[3]) );
  INVX1 I27 ( .A(MAR[3]), .Y(n26) );
  INVX1 I28 ( .A(n24), .Y(RAMADDR[2]) );
  INVX1 I29 ( .A(MAR[2]), .Y(n24) );
  INVX1 I30 ( .A(n22), .Y(RAMADDR[1]) );
  INVX1 I31 ( .A(MAR[1]), .Y(n22) );
  INVX1 I32 ( .A(n20), .Y(RAMADDR[0]) );
  INVX1 I33 ( .A(MAR[0]), .Y(n20) );
  INVX1 I34 ( .A(n18), .Y(IRAM_DIN[7]) );
  INVX1 I35 ( .A(IDATA[7]), .Y(n18) );
  INVX1 I36 ( .A(n16), .Y(IRAM_DIN[6]) );
  INVX1 I37 ( .A(IDATA[6]), .Y(n16) );
  INVX1 I38 ( .A(n14), .Y(IRAM_DIN[5]) );
  INVX1 I39 ( .A(IDATA[5]), .Y(n14) );
  INVX1 I40 ( .A(n12), .Y(IRAM_DIN[4]) );
  INVX1 I41 ( .A(IDATA[4]), .Y(n12) );
  INVX1 I42 ( .A(n10), .Y(IRAM_DIN[3]) );
  INVX1 I43 ( .A(IDATA[3]), .Y(n10) );
  INVX1 I44 ( .A(n8), .Y(IRAM_DIN[2]) );
  INVX1 I45 ( .A(IDATA[2]), .Y(n8) );
endmodule

