////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2006 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: I.31
//  \   \         Application: netgen
//  /   /         Filename: audio_translate.v
// /___/   /\     Timestamp: Wed Jan 03 15:29:04 2007
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -insert_glbl true -w -dir netgen/translate -ofmt verilog -sim audio.ngd audio_translate.v 
// Device	: 4vlx200ff1513-10
// Input file	: audio.ngd
// Output file	: E:\ENCODER\bhbh\xst3_audio\audio\I2S_AUDIO\netgen\translate\audio_translate.v
// # of Modules	: 1
// Design Name	: audio
// Xilinx        : D:\Xilinx
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Development System Reference Guide, Chapter 23
//     Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module audio (
  clk, reset_n, sdto, L3_SDAT, L3_SCLK, sdti, ethernet_cs_n, L3_MODE, ADC_rdy_diag, DAC_rdy_diag, sclk, mclk, lrck
);
  input clk;
  input reset_n;
  input sdto;
  inout L3_SDAT;
  output L3_SCLK;
  output sdti;
  output ethernet_cs_n;
  output L3_MODE;
  output ADC_rdy_diag;
  output DAC_rdy_diag;
  output sclk;
  output mclk;
  output lrck;
  wire \UL3/SDO_13 ;
  wire clk_BUFGP;
  wire reset_n_IBUF_14;
  wire L3_SCLK_OBUF_15;
  wire sdto_IBUF_16;
  wire ethernet_cs_n_OBUF_17;
  wire \UL3/L3_EN_18 ;
  wire DAC_rdy_diag_OBUF_19;
  wire _not0002;
  wire _not0003;
  wire left_chan;
  wire ADC_rdy;
  wire \u0/DAC_rdy ;
  wire \u0/_not0001_20 ;
  wire \u0/_and0000_21 ;
  wire \u0/N21 ;
  wire \UL3/_and0000_22 ;
  wire \UL3/_and0001_23 ;
  wire \UL3/SD_COUNTER_CTRL_24 ;
  wire \UL3/_cmp_lt0000 ;
  wire \UL3/_cmp_lt0001 ;
  wire \UL3/_mux0005 ;
  wire \UL3/_mux0006 ;
  wire \UL3/_mux0007 ;
  wire \UL3/_mux0008 ;
  wire \UL3/_or0000_25 ;
  wire \UL3/L3_CK_26 ;
  wire \UL3/L3_CTRL_CLK_27 ;
  wire \UL3/_not0007_28 ;
  wire \UL3/_not0009 ;
  wire \UL3/nRESET_inv ;
  wire \UL3/L3_DIV_CLK_Eqn_1 ;
  wire \UL3/L3_DIV_CLK_Eqn_2 ;
  wire \UL3/L3_DIV_CLK_Eqn_3 ;
  wire \UL3/L3_DIV_CLK_Eqn_4 ;
  wire \UL3/L3_DIV_CLK_Eqn_5 ;
  wire \UL3/L3_DIV_CLK_Eqn_6 ;
  wire \UL3/L3_DIV_CLK_Eqn_7 ;
  wire \UL3/L3_DIV_CLK_Eqn_8 ;
  wire \UL3/L3_DIV_CLK_Eqn_9 ;
  wire \UL3/L3_DIV_CLK_Eqn_10 ;
  wire \UL3/L3_DIV_CLK_Eqn_11_29 ;
  wire \UL3/L3_DIV_CLK_Eqn_12 ;
  wire \UL3/L3_DIV_CLK_Eqn_13 ;
  wire \UL3/L3_DIV_CLK_Eqn_14 ;
  wire \UL3/L3_DIV_CLK_Eqn_15 ;
  wire \UL3/L3_DIV_CLK_Eqn_16 ;
  wire \UL3/L3_DIV_CLK_Eqn_17 ;
  wire \UL3/L3_DIV_CLK_Eqn_18 ;
  wire \UL3/L3_DIV_CLK_Eqn_19 ;
  wire \UL3/L3_DIV_CLK_Eqn_20 ;
  wire \UL3/L3_DIV_CLK_Eqn_21_30 ;
  wire \UL3/L3_DIV_CLK_Eqn_22 ;
  wire \UL3/L3_DIV_CLK_Eqn_23 ;
  wire \UL3/L3_DIV_CLK_Eqn_24 ;
  wire \UL3/L3_DIV_CLK_Eqn_25 ;
  wire \UL3/Result<0>1 ;
  wire \UL3/Result<1>1 ;
  wire \UL3/Result<2>1 ;
  wire \UL3/Result<3>1 ;
  wire \UL3/Result<4>1 ;
  wire \UL3/Result<5>1 ;
  wire \UL3/L3_DIV_CLK_Eqn_bis_0 ;
  wire \UL3/N2 ;
  wire \UL3/Mrom_LUT_DATA_f5 ;
  wire \UL3/N4 ;
  wire \UL3/Mrom_LUT_DATA_f51_31 ;
  wire \UL3/N7 ;
  wire \UL3/Mrom_LUT_DATA_f52 ;
  wire \UL3/N8 ;
  wire \UL3/N10 ;
  wire \UL3/Mrom_LUT_DATA_f53 ;
  wire \UL3/N11 ;
  wire \UL3/N12 ;
  wire \UL3/Mrom_LUT_DATA_f54 ;
  wire \UL3/N13 ;
  wire \UL3/Mrom_LUT_DATA_f55 ;
  wire \UL3/N14 ;
  wire \UL3/Mrom_LUT_DATA_f56 ;
  wire \UL3/N18 ;
  wire \UL3/N19 ;
  wire \UL3/N20 ;
  wire \UL3/N21 ;
  wire \UL3/N22 ;
  wire \UL3/N23 ;
  wire \UL3/N24 ;
  wire \UL3/L3_DIV_CLK_Eqn_0_mand1 ;
  wire \UL3/N131 ;
  wire \UL3/N141 ;
  wire \UL3/N261 ;
  wire N21;
  wire N23;
  wire N25;
  wire N27;
  wire N29;
  wire N31;
  wire N33;
  wire N35;
  wire N37;
  wire N39;
  wire N41;
  wire N43;
  wire N45;
  wire N47;
  wire N49;
  wire N51;
  wire N53;
  wire N55;
  wire N57;
  wire \UL3/_mux0006_map8 ;
  wire \UL3/_mux0006_map12 ;
  wire \UL3/_mux0006_map14 ;
  wire \UL3/_mux0006_map16 ;
  wire \UL3/_mux0006_map21 ;
  wire \UL3/_mux0006_map31 ;
  wire \UL3/_mux0006_map33 ;
  wire N153;
  wire \UL3/_mux0007_map49 ;
  wire \UL3/_mux0007_map60 ;
  wire \UL3/_mux0007_map65 ;
  wire \UL3/_mux0005_map75 ;
  wire \UL3/_mux0005_map80 ;
  wire \UL3/_mux0005_map85 ;
  wire \UL3/_mux0005_map88 ;
  wire \UL3/_mux0005_map94 ;
  wire N305;
  wire N314;
  wire \UL3/_mux0008_map101 ;
  wire \UL3/_mux0008_map112 ;
  wire \UL3/_mux0008_map125 ;
  wire \UL3/_mux0008_map128 ;
  wire \UL3/_mux0008_map133 ;
  wire \UL3/_mux0008_map137 ;
  wire \UL3/_mux0008_map141 ;
  wire \UL3/_mux0008_map145 ;
  wire \UL3/_mux0008_map154 ;
  wire \UL3/_mux0008_map159 ;
  wire \UL3/_mux0008_map164 ;
  wire \UL3/_mux0008_map171 ;
  wire \UL3/_mux0008_map185 ;
  wire \UL3/_mux0008_map188 ;
  wire \UL3/_mux0008_map198 ;
  wire \UL3/_mux0008_map202 ;
  wire \UL3/_mux0008_map204 ;
  wire \u0/cnt_r_1_rt_32 ;
  wire \u0/cnt_r_2_rt_33 ;
  wire \u0/cnt_r_3_rt_34 ;
  wire \u0/cnt_r_4_rt_35 ;
  wire \u0/cnt_r_5_rt_36 ;
  wire \u0/cnt_r_6_rt_37 ;
  wire \u0/cnt_r_7_rt_38 ;
  wire \u0/cnt_r_8_rt_39 ;
  wire \UL3/L3_DIV_CLK_2_rt_40 ;
  wire \UL3/L3_DIV_CLK_11_rt_41 ;
  wire \u0/cnt_r_9_rt_42 ;
  wire N627;
  wire N629;
  wire N631;
  wire N633;
  wire N635;
  wire N637;
  wire N641;
  wire N643;
  wire N645;
  wire N647;
  wire N649;
  wire N651;
  wire N653;
  wire N654;
  wire \UL3/Mcompar__cmp_lt0004_cy<8>_inv ;
  wire \UL3/SD_COUNTER_2_1_43 ;
  wire \UL3/SD_COUNTER_3_1_44 ;
  wire \UL3/SD_COUNTER_0_1_45 ;
  wire \UL3/SD_COUNTER_1_1_46 ;
  wire \UL3/SD_COUNTER_2_2_47 ;
  wire \UL3/SD_COUNTER_3_2_48 ;
  wire N658;
  wire N659;
  wire N660;
  wire N661;
  wire N662;
  wire N663;
  wire N664;
  wire N665;
  wire \UL3/L3_CTRL_CLK1 ;
  wire N666;
  wire N667;
  wire N668;
  wire N669;
  wire N670;
  wire N671;
  wire N673;
  wire N674;
  wire N676;
  wire N678;
  wire N679;
  wire N680;
  wire N681;
  wire N682;
  wire \u0/_mux0000<18>_SW0/O ;
  wire \u0/_mux0000<17>_SW0/O ;
  wire \u0/_mux0000<19>_SW0/O ;
  wire \u0/_mux0000<15>_SW0/O ;
  wire \u0/_mux0000<16>_SW0/O ;
  wire \u0/_mux0000<14>_SW0/O ;
  wire \u0/_mux0000<12>_SW0/O ;
  wire \u0/_mux0000<13>_SW0/O ;
  wire \u0/_mux0000<10>_SW0/O ;
  wire \u0/_mux0000<9>_SW0/O ;
  wire \u0/_mux0000<11>_SW0/O ;
  wire \u0/_mux0000<7>_SW0/O ;
  wire \u0/_mux0000<6>_SW0/O ;
  wire \u0/_mux0000<8>_SW0/O ;
  wire \u0/_mux0000<4>_SW0/O ;
  wire \u0/_mux0000<5>_SW0/O ;
  wire \u0/_mux0000<3>_SW0/O ;
  wire \u0/_mux0000<1>_SW0/O ;
  wire \u0/_mux0000<2>_SW0/O ;
  wire \UL3/_mux0006123/O ;
  wire \UL3/_mux000561/O ;
  wire \u0/_and0002_SW0/O ;
  wire \UL3/_mux0008170/O ;
  wire \UL3/_mux0008302/O ;
  wire \UL3/_mux0008476/O ;
  wire \UL3/_mux000810/O ;
  wire \UL3/_and0000_SW1/O ;
  wire \UL3/_and0001_SW1/O ;
  wire \u0/_not0001_SW1/O ;
  wire \UL3/_not0007_SW1/O ;
  wire \u0/_and0000_SW1/O ;
  wire \UL3/_mux0008160/O ;
  wire \UL3/_mux0008453_SW0/O ;
  wire \UL3/_mux0007140_SW0/O ;
  wire \clk_BUFGP/IBUFG_49 ;
  wire GND;
  wire VCC;
  wire [19 : 0] \u0/DAC_r ;
  wire [9 : 0] \u0/cnt_r ;
  wire [19 : 0] left_ADC;
  wire [19 : 0] right_ADC;
  wire [19 : 0] \u0/ADC_r ;
  wire [19 : 0] \u0/_mux0000 ;
  wire [9 : 0] \u0/Result ;
  wire [8 : 0] \u0/Mcount_cnt_r_cy ;
  wire [4 : 0] \UL3/LUT_INDEX ;
  wire [5 : 0] \UL3/SD_COUNTER ;
  wire [10 : 0] \UL3/SD_DATA ;
  wire [7 : 0] \UL3/SD_DATA1 ;
  wire [8 : 8] \UL3/_mux0003 ;
  wire [4 : 0] \UL3/_mux0004 ;
  wire [25 : 0] \UL3/L3_DIV_CLK ;
  wire [25 : 1] \UL3/Result ;
  wire [8 : 0] \UL3/Mcompar__cmp_lt0004_cy ;
  wire [0 : 0] \UL3/Mcount_SD_COUNTER_lut ;
  wire [24 : 0] \UL3/Mcount_L3_DIV_CLK_cy ;
  X_ZERO XST_GND (
    .O(DAC_rdy_diag_OBUF_19)
  );
  X_ONE XST_VCC (
    .O(ethernet_cs_n_OBUF_17)
  );
  defparam right_ADC_0.INIT = 1'b0;
  X_FF right_ADC_0 (
    .I(\u0/ADC_r [0]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[0]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_1.INIT = 1'b0;
  X_FF right_ADC_1 (
    .I(\u0/ADC_r [1]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[1]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_2.INIT = 1'b0;
  X_FF right_ADC_2 (
    .I(\u0/ADC_r [2]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[2]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_3.INIT = 1'b0;
  X_FF right_ADC_3 (
    .I(\u0/ADC_r [3]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[3]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_4.INIT = 1'b0;
  X_FF right_ADC_4 (
    .I(\u0/ADC_r [4]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[4]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_5.INIT = 1'b0;
  X_FF right_ADC_5 (
    .I(\u0/ADC_r [5]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[5]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_6.INIT = 1'b0;
  X_FF right_ADC_6 (
    .I(\u0/ADC_r [6]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[6]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_7.INIT = 1'b0;
  X_FF right_ADC_7 (
    .I(\u0/ADC_r [7]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[7]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_8.INIT = 1'b0;
  X_FF right_ADC_8 (
    .I(\u0/ADC_r [8]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[8]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_9.INIT = 1'b0;
  X_FF right_ADC_9 (
    .I(\u0/ADC_r [9]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[9]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_10.INIT = 1'b0;
  X_FF right_ADC_10 (
    .I(\u0/ADC_r [10]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[10]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_11.INIT = 1'b0;
  X_FF right_ADC_11 (
    .I(\u0/ADC_r [11]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[11]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_12.INIT = 1'b0;
  X_FF right_ADC_12 (
    .I(\u0/ADC_r [12]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[12]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_13.INIT = 1'b0;
  X_FF right_ADC_13 (
    .I(\u0/ADC_r [13]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[13]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_14.INIT = 1'b0;
  X_FF right_ADC_14 (
    .I(\u0/ADC_r [14]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[14]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_15.INIT = 1'b0;
  X_FF right_ADC_15 (
    .I(\u0/ADC_r [15]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[15]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_16.INIT = 1'b0;
  X_FF right_ADC_16 (
    .I(\u0/ADC_r [16]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[16]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_17.INIT = 1'b0;
  X_FF right_ADC_17 (
    .I(\u0/ADC_r [17]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[17]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_18.INIT = 1'b0;
  X_FF right_ADC_18 (
    .I(\u0/ADC_r [18]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[18]),
    .SET(GND),
    .RST(GND)
  );
  defparam right_ADC_19.INIT = 1'b0;
  X_FF right_ADC_19 (
    .I(\u0/ADC_r [19]),
    .CE(_not0002),
    .CLK(clk_BUFGP),
    .O(right_ADC[19]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_0.INIT = 1'b0;
  X_FF left_ADC_0 (
    .I(\u0/ADC_r [0]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[0]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_1.INIT = 1'b0;
  X_FF left_ADC_1 (
    .I(\u0/ADC_r [1]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[1]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_2.INIT = 1'b0;
  X_FF left_ADC_2 (
    .I(\u0/ADC_r [2]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[2]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_3.INIT = 1'b0;
  X_FF left_ADC_3 (
    .I(\u0/ADC_r [3]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[3]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_4.INIT = 1'b0;
  X_FF left_ADC_4 (
    .I(\u0/ADC_r [4]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[4]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_5.INIT = 1'b0;
  X_FF left_ADC_5 (
    .I(\u0/ADC_r [5]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[5]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_6.INIT = 1'b0;
  X_FF left_ADC_6 (
    .I(\u0/ADC_r [6]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[6]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_7.INIT = 1'b0;
  X_FF left_ADC_7 (
    .I(\u0/ADC_r [7]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[7]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_8.INIT = 1'b0;
  X_FF left_ADC_8 (
    .I(\u0/ADC_r [8]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[8]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_9.INIT = 1'b0;
  X_FF left_ADC_9 (
    .I(\u0/ADC_r [9]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[9]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_10.INIT = 1'b0;
  X_FF left_ADC_10 (
    .I(\u0/ADC_r [10]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[10]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_11.INIT = 1'b0;
  X_FF left_ADC_11 (
    .I(\u0/ADC_r [11]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[11]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_12.INIT = 1'b0;
  X_FF left_ADC_12 (
    .I(\u0/ADC_r [12]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[12]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_13.INIT = 1'b0;
  X_FF left_ADC_13 (
    .I(\u0/ADC_r [13]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[13]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_14.INIT = 1'b0;
  X_FF left_ADC_14 (
    .I(\u0/ADC_r [14]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[14]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_15.INIT = 1'b0;
  X_FF left_ADC_15 (
    .I(\u0/ADC_r [15]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[15]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_16.INIT = 1'b0;
  X_FF left_ADC_16 (
    .I(\u0/ADC_r [16]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[16]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_17.INIT = 1'b0;
  X_FF left_ADC_17 (
    .I(\u0/ADC_r [17]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[17]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_18.INIT = 1'b0;
  X_FF left_ADC_18 (
    .I(\u0/ADC_r [18]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[18]),
    .SET(GND),
    .RST(GND)
  );
  defparam left_ADC_19.INIT = 1'b0;
  X_FF left_ADC_19 (
    .I(\u0/ADC_r [19]),
    .CE(_not0003),
    .CLK(clk_BUFGP),
    .O(left_ADC[19]),
    .SET(GND),
    .RST(GND)
  );
  defparam \u0/DAC_r_0 .INIT = 1'b0;
  X_FF \u0/DAC_r_0  (
    .I(\u0/_mux0000 [0]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [0]),
    .SET(GND)
  );
  defparam \u0/DAC_r_1 .INIT = 1'b0;
  X_FF \u0/DAC_r_1  (
    .I(\u0/_mux0000 [1]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [1]),
    .SET(GND)
  );
  defparam \u0/DAC_r_2 .INIT = 1'b0;
  X_FF \u0/DAC_r_2  (
    .I(\u0/_mux0000 [2]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [2]),
    .SET(GND)
  );
  defparam \u0/DAC_r_3 .INIT = 1'b0;
  X_FF \u0/DAC_r_3  (
    .I(\u0/_mux0000 [3]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [3]),
    .SET(GND)
  );
  defparam \u0/DAC_r_4 .INIT = 1'b0;
  X_FF \u0/DAC_r_4  (
    .I(\u0/_mux0000 [4]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [4]),
    .SET(GND)
  );
  defparam \u0/DAC_r_5 .INIT = 1'b0;
  X_FF \u0/DAC_r_5  (
    .I(\u0/_mux0000 [5]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [5]),
    .SET(GND)
  );
  defparam \u0/DAC_r_6 .INIT = 1'b0;
  X_FF \u0/DAC_r_6  (
    .I(\u0/_mux0000 [6]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [6]),
    .SET(GND)
  );
  defparam \u0/DAC_r_7 .INIT = 1'b0;
  X_FF \u0/DAC_r_7  (
    .I(\u0/_mux0000 [7]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [7]),
    .SET(GND)
  );
  defparam \u0/DAC_r_8 .INIT = 1'b0;
  X_FF \u0/DAC_r_8  (
    .I(\u0/_mux0000 [8]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [8]),
    .SET(GND)
  );
  defparam \u0/DAC_r_9 .INIT = 1'b0;
  X_FF \u0/DAC_r_9  (
    .I(\u0/_mux0000 [9]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [9]),
    .SET(GND)
  );
  defparam \u0/DAC_r_10 .INIT = 1'b0;
  X_FF \u0/DAC_r_10  (
    .I(\u0/_mux0000 [10]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [10]),
    .SET(GND)
  );
  defparam \u0/DAC_r_11 .INIT = 1'b0;
  X_FF \u0/DAC_r_11  (
    .I(\u0/_mux0000 [11]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [11]),
    .SET(GND)
  );
  defparam \u0/DAC_r_12 .INIT = 1'b0;
  X_FF \u0/DAC_r_12  (
    .I(\u0/_mux0000 [12]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [12]),
    .SET(GND)
  );
  defparam \u0/DAC_r_13 .INIT = 1'b0;
  X_FF \u0/DAC_r_13  (
    .I(\u0/_mux0000 [13]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [13]),
    .SET(GND)
  );
  defparam \u0/DAC_r_14 .INIT = 1'b0;
  X_FF \u0/DAC_r_14  (
    .I(\u0/_mux0000 [14]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [14]),
    .SET(GND)
  );
  defparam \u0/DAC_r_15 .INIT = 1'b0;
  X_FF \u0/DAC_r_15  (
    .I(\u0/_mux0000 [15]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [15]),
    .SET(GND)
  );
  defparam \u0/DAC_r_16 .INIT = 1'b0;
  X_FF \u0/DAC_r_16  (
    .I(\u0/_mux0000 [16]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [16]),
    .SET(GND)
  );
  defparam \u0/DAC_r_17 .INIT = 1'b0;
  X_FF \u0/DAC_r_17  (
    .I(\u0/_mux0000 [17]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [17]),
    .SET(GND)
  );
  defparam \u0/DAC_r_18 .INIT = 1'b0;
  X_FF \u0/DAC_r_18  (
    .I(\u0/_mux0000 [18]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [18]),
    .SET(GND)
  );
  defparam \u0/DAC_r_19 .INIT = 1'b0;
  X_FF \u0/DAC_r_19  (
    .I(\u0/_mux0000 [19]),
    .CE(\u0/_not0001_20 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/DAC_r [19]),
    .SET(GND)
  );
  defparam \u0/ADC_r_0 .INIT = 1'b0;
  X_FF \u0/ADC_r_0  (
    .I(sdto_IBUF_16),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [0]),
    .SET(GND)
  );
  defparam \u0/ADC_r_1 .INIT = 1'b0;
  X_FF \u0/ADC_r_1  (
    .I(\u0/ADC_r [0]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [1]),
    .SET(GND)
  );
  defparam \u0/ADC_r_2 .INIT = 1'b0;
  X_FF \u0/ADC_r_2  (
    .I(\u0/ADC_r [1]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [2]),
    .SET(GND)
  );
  defparam \u0/ADC_r_3 .INIT = 1'b0;
  X_FF \u0/ADC_r_3  (
    .I(\u0/ADC_r [2]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [3]),
    .SET(GND)
  );
  defparam \u0/ADC_r_4 .INIT = 1'b0;
  X_FF \u0/ADC_r_4  (
    .I(\u0/ADC_r [3]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [4]),
    .SET(GND)
  );
  defparam \u0/ADC_r_5 .INIT = 1'b0;
  X_FF \u0/ADC_r_5  (
    .I(\u0/ADC_r [4]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [5]),
    .SET(GND)
  );
  defparam \u0/ADC_r_6 .INIT = 1'b0;
  X_FF \u0/ADC_r_6  (
    .I(\u0/ADC_r [5]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [6]),
    .SET(GND)
  );
  defparam \u0/ADC_r_7 .INIT = 1'b0;
  X_FF \u0/ADC_r_7  (
    .I(\u0/ADC_r [6]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [7]),
    .SET(GND)
  );
  defparam \u0/ADC_r_8 .INIT = 1'b0;
  X_FF \u0/ADC_r_8  (
    .I(\u0/ADC_r [7]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [8]),
    .SET(GND)
  );
  defparam \u0/ADC_r_9 .INIT = 1'b0;
  X_FF \u0/ADC_r_9  (
    .I(\u0/ADC_r [8]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [9]),
    .SET(GND)
  );
  defparam \u0/ADC_r_10 .INIT = 1'b0;
  X_FF \u0/ADC_r_10  (
    .I(\u0/ADC_r [9]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [10]),
    .SET(GND)
  );
  defparam \u0/ADC_r_11 .INIT = 1'b0;
  X_FF \u0/ADC_r_11  (
    .I(\u0/ADC_r [10]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [11]),
    .SET(GND)
  );
  defparam \u0/ADC_r_12 .INIT = 1'b0;
  X_FF \u0/ADC_r_12  (
    .I(\u0/ADC_r [11]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [12]),
    .SET(GND)
  );
  defparam \u0/ADC_r_13 .INIT = 1'b0;
  X_FF \u0/ADC_r_13  (
    .I(\u0/ADC_r [12]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [13]),
    .SET(GND)
  );
  defparam \u0/ADC_r_14 .INIT = 1'b0;
  X_FF \u0/ADC_r_14  (
    .I(\u0/ADC_r [13]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [14]),
    .SET(GND)
  );
  defparam \u0/ADC_r_15 .INIT = 1'b0;
  X_FF \u0/ADC_r_15  (
    .I(\u0/ADC_r [14]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [15]),
    .SET(GND)
  );
  defparam \u0/ADC_r_16 .INIT = 1'b0;
  X_FF \u0/ADC_r_16  (
    .I(\u0/ADC_r [15]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [16]),
    .SET(GND)
  );
  defparam \u0/ADC_r_17 .INIT = 1'b0;
  X_FF \u0/ADC_r_17  (
    .I(\u0/ADC_r [16]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [17]),
    .SET(GND)
  );
  defparam \u0/ADC_r_18 .INIT = 1'b0;
  X_FF \u0/ADC_r_18  (
    .I(\u0/ADC_r [17]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [18]),
    .SET(GND)
  );
  defparam \u0/ADC_r_19 .INIT = 1'b0;
  X_FF \u0/ADC_r_19  (
    .I(\u0/ADC_r [18]),
    .CE(\u0/_and0000_21 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/ADC_r [19]),
    .SET(GND)
  );
  defparam \u0/cnt_r_0 .INIT = 1'b0;
  X_FF \u0/cnt_r_0  (
    .I(\u0/Result [0]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [0]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_1 .INIT = 1'b0;
  X_FF \u0/cnt_r_1  (
    .I(\u0/Result [1]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [1]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_2 .INIT = 1'b0;
  X_FF \u0/cnt_r_2  (
    .I(\u0/Result [2]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [2]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_3 .INIT = 1'b0;
  X_FF \u0/cnt_r_3  (
    .I(\u0/Result [3]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [3]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_4 .INIT = 1'b0;
  X_FF \u0/cnt_r_4  (
    .I(\u0/Result [4]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [4]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_5 .INIT = 1'b0;
  X_FF \u0/cnt_r_5  (
    .I(\u0/Result [5]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [5]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_6 .INIT = 1'b0;
  X_FF \u0/cnt_r_6  (
    .I(\u0/Result [6]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [6]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_7 .INIT = 1'b0;
  X_FF \u0/cnt_r_7  (
    .I(\u0/Result [7]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [7]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_8 .INIT = 1'b0;
  X_FF \u0/cnt_r_8  (
    .I(\u0/Result [8]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [8]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \u0/cnt_r_9 .INIT = 1'b0;
  X_FF \u0/cnt_r_9  (
    .I(\u0/Result [9]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\u0/cnt_r [9]),
    .CE(VCC),
    .SET(GND)
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<0>  (
    .IB(DAC_rdy_diag_OBUF_19),
    .IA(ethernet_cs_n_OBUF_17),
    .SEL(\u0/Result [0]),
    .O(\u0/Mcount_cnt_r_cy [0])
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<1>  (
    .IB(\u0/Mcount_cnt_r_cy [0]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\u0/cnt_r_1_rt_32 ),
    .O(\u0/Mcount_cnt_r_cy [1])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<1>  (
    .I0(\u0/Mcount_cnt_r_cy [0]),
    .I1(\u0/cnt_r_1_rt_32 ),
    .O(\u0/Result [1])
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<2>  (
    .IB(\u0/Mcount_cnt_r_cy [1]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\u0/cnt_r_2_rt_33 ),
    .O(\u0/Mcount_cnt_r_cy [2])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<2>  (
    .I0(\u0/Mcount_cnt_r_cy [1]),
    .I1(\u0/cnt_r_2_rt_33 ),
    .O(\u0/Result [2])
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<3>  (
    .IB(\u0/Mcount_cnt_r_cy [2]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\u0/cnt_r_3_rt_34 ),
    .O(\u0/Mcount_cnt_r_cy [3])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<3>  (
    .I0(\u0/Mcount_cnt_r_cy [2]),
    .I1(\u0/cnt_r_3_rt_34 ),
    .O(\u0/Result [3])
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<4>  (
    .IB(\u0/Mcount_cnt_r_cy [3]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\u0/cnt_r_4_rt_35 ),
    .O(\u0/Mcount_cnt_r_cy [4])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<4>  (
    .I0(\u0/Mcount_cnt_r_cy [3]),
    .I1(\u0/cnt_r_4_rt_35 ),
    .O(\u0/Result [4])
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<5>  (
    .IB(\u0/Mcount_cnt_r_cy [4]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\u0/cnt_r_5_rt_36 ),
    .O(\u0/Mcount_cnt_r_cy [5])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<5>  (
    .I0(\u0/Mcount_cnt_r_cy [4]),
    .I1(\u0/cnt_r_5_rt_36 ),
    .O(\u0/Result [5])
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<6>  (
    .IB(\u0/Mcount_cnt_r_cy [5]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\u0/cnt_r_6_rt_37 ),
    .O(\u0/Mcount_cnt_r_cy [6])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<6>  (
    .I0(\u0/Mcount_cnt_r_cy [5]),
    .I1(\u0/cnt_r_6_rt_37 ),
    .O(\u0/Result [6])
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<7>  (
    .IB(\u0/Mcount_cnt_r_cy [6]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\u0/cnt_r_7_rt_38 ),
    .O(\u0/Mcount_cnt_r_cy [7])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<7>  (
    .I0(\u0/Mcount_cnt_r_cy [6]),
    .I1(\u0/cnt_r_7_rt_38 ),
    .O(\u0/Result [7])
  );
  X_MUX2 \u0/Mcount_cnt_r_cy<8>  (
    .IB(\u0/Mcount_cnt_r_cy [7]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\u0/cnt_r_8_rt_39 ),
    .O(\u0/Mcount_cnt_r_cy [8])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<8>  (
    .I0(\u0/Mcount_cnt_r_cy [7]),
    .I1(\u0/cnt_r_8_rt_39 ),
    .O(\u0/Result [8])
  );
  X_XOR2 \u0/Mcount_cnt_r_xor<9>  (
    .I0(\u0/Mcount_cnt_r_cy [8]),
    .I1(\u0/cnt_r_9_rt_42 ),
    .O(\u0/Result [9])
  );
  defparam \UL3/L3_CTRL_CLK .INIT = 1'b0;
  X_FF \UL3/L3_CTRL_CLK  (
    .I(\UL3/_not0009 ),
    .CE(\UL3/Mcompar__cmp_lt0004_cy [8]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_CTRL_CLK1 ),
    .SET(GND)
  );
  defparam \UL3/L3_CK .INIT = 1'b1;
  X_FF \UL3/L3_CK  (
    .I(\UL3/_mux0006 ),
    .SET(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/L3_CK_26 ),
    .CE(VCC),
    .RST(GND)
  );
  defparam \UL3/L3_EN .INIT = 1'b1;
  X_FF \UL3/L3_EN  (
    .I(\UL3/_mux0007 ),
    .SET(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/L3_EN_18 ),
    .CE(VCC),
    .RST(GND)
  );
  defparam \UL3/SDO .INIT = 1'b1;
  X_FF \UL3/SDO  (
    .I(\UL3/_mux0008 ),
    .SET(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SDO_13 ),
    .CE(VCC),
    .RST(GND)
  );
  defparam \UL3/LUT_INDEX_0 .INIT = 1'b0;
  X_FF \UL3/LUT_INDEX_0  (
    .I(\UL3/_mux0004 [4]),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/LUT_INDEX [0]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/LUT_INDEX_1 .INIT = 1'b0;
  X_FF \UL3/LUT_INDEX_1  (
    .I(\UL3/_mux0004 [3]),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/LUT_INDEX [1]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/LUT_INDEX_2 .INIT = 1'b0;
  X_FF \UL3/LUT_INDEX_2  (
    .I(\UL3/_mux0004 [2]),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/LUT_INDEX [2]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/LUT_INDEX_3 .INIT = 1'b0;
  X_FF \UL3/LUT_INDEX_3  (
    .I(\UL3/_mux0004 [1]),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/LUT_INDEX [3]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/LUT_INDEX_4 .INIT = 1'b0;
  X_FF \UL3/LUT_INDEX_4  (
    .I(\UL3/_mux0004 [0]),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/LUT_INDEX [4]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/SD_DATA1_0 .INIT = 1'b0;
  X_FF \UL3/SD_DATA1_0  (
    .I(\UL3/Mrom_LUT_DATA_f5 ),
    .CE(\UL3/_and0001_23 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA1 [0]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA1_1 .INIT = 1'b0;
  X_FF \UL3/SD_DATA1_1  (
    .I(\UL3/Mrom_LUT_DATA_f51_31 ),
    .CE(\UL3/_and0001_23 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA1 [1]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA1_2 .INIT = 1'b0;
  X_FF \UL3/SD_DATA1_2  (
    .I(\UL3/Mrom_LUT_DATA_f52 ),
    .CE(\UL3/_and0001_23 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA1 [2]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA1_3 .INIT = 1'b0;
  X_FF \UL3/SD_DATA1_3  (
    .I(\UL3/N8 ),
    .CE(\UL3/_and0001_23 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA1 [3]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA1_4 .INIT = 1'b0;
  X_FF \UL3/SD_DATA1_4  (
    .I(\UL3/Mrom_LUT_DATA_f53 ),
    .CE(\UL3/_and0001_23 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA1 [4]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA1_5 .INIT = 1'b0;
  X_FF \UL3/SD_DATA1_5  (
    .I(\UL3/Mrom_LUT_DATA_f54 ),
    .CE(\UL3/_and0001_23 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA1 [5]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA1_6 .INIT = 1'b0;
  X_FF \UL3/SD_DATA1_6  (
    .I(\UL3/Mrom_LUT_DATA_f55 ),
    .CE(\UL3/_and0001_23 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA1 [6]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA1_7 .INIT = 1'b0;
  X_FF \UL3/SD_DATA1_7  (
    .I(\UL3/Mrom_LUT_DATA_f56 ),
    .CE(\UL3/_and0001_23 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA1 [7]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_COUNTER_CTRL .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_CTRL  (
    .I(\UL3/_mux0005 ),
    .CE(\UL3/_cmp_lt0000 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER_CTRL_24 ),
    .SET(GND)
  );
  defparam \UL3/SD_DATA_0 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_0  (
    .I(\UL3/Mrom_LUT_DATA_f5 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [0]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_1 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_1  (
    .I(\UL3/Mrom_LUT_DATA_f51_31 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [1]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_2 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_2  (
    .I(\UL3/Mrom_LUT_DATA_f52 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [2]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_3 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_3  (
    .I(\UL3/N8 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [3]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_4 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_4  (
    .I(\UL3/Mrom_LUT_DATA_f53 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [4]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_5 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_5  (
    .I(\UL3/Mrom_LUT_DATA_f54 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [5]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_6 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_6  (
    .I(\UL3/Mrom_LUT_DATA_f55 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [6]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_7 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_7  (
    .I(\UL3/Mrom_LUT_DATA_f56 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [7]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_8 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_8  (
    .I(\UL3/_mux0003 [8]),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [8]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_9 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_9  (
    .I(\UL3/_cmp_lt0001 ),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [9]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/SD_DATA_10 .INIT = 1'b0;
  X_FF \UL3/SD_DATA_10  (
    .I(ethernet_cs_n_OBUF_17),
    .CE(\UL3/_and0000_22 ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_DATA [10]),
    .SET(GND),
    .RST(GND)
  );
  defparam \UL3/Mrom_LUT_DATA1 .INIT = 8'hFE;
  X_LUT3 \UL3/Mrom_LUT_DATA1  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [1]),
    .ADR2(\UL3/LUT_INDEX [2]),
    .O(\UL3/N2 )
  );
  defparam \UL3/Mrom_LUT_DATA3 .INIT = 16'hFFFB;
  X_LUT4 \UL3/Mrom_LUT_DATA3  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [0]),
    .ADR2(\UL3/LUT_INDEX [2]),
    .ADR3(\UL3/LUT_INDEX [1]),
    .O(\UL3/N4 )
  );
  defparam \UL3/Mrom_LUT_DATA6 .INIT = 16'hA280;
  X_LUT4 \UL3/Mrom_LUT_DATA6  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [0]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/LUT_INDEX [2]),
    .O(\UL3/N7 )
  );
  X_MUX2 \UL3/Mrom_LUT_DATA_f5_1  (
    .IA(\UL3/N7 ),
    .IB(\UL3/N4 ),
    .SEL(\UL3/LUT_INDEX [4]),
    .O(\UL3/Mrom_LUT_DATA_f52 )
  );
  defparam \UL3/Mrom_LUT_DATA7 .INIT = 16'hCCC8;
  X_LUT4 \UL3/Mrom_LUT_DATA7  (
    .ADR0(\UL3/LUT_INDEX [2]),
    .ADR1(\UL3/LUT_INDEX [4]),
    .ADR2(\UL3/LUT_INDEX [3]),
    .ADR3(\UL3/LUT_INDEX [1]),
    .O(\UL3/N8 )
  );
  defparam \UL3/Mrom_LUT_DATA9 .INIT = 16'h0100;
  X_LUT4 \UL3/Mrom_LUT_DATA9  (
    .ADR0(\UL3/LUT_INDEX [2]),
    .ADR1(\UL3/LUT_INDEX [3]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/LUT_INDEX [0]),
    .O(\UL3/N10 )
  );
  X_MUX2 \UL3/Mrom_LUT_DATA_f5_2  (
    .IA(\UL3/N10 ),
    .IB(\UL3/N2 ),
    .SEL(\UL3/LUT_INDEX [4]),
    .O(\UL3/Mrom_LUT_DATA_f53 )
  );
  defparam \UL3/Mrom_LUT_DATA10 .INIT = 16'hFFFE;
  X_LUT4 \UL3/Mrom_LUT_DATA10  (
    .ADR0(\UL3/LUT_INDEX [2]),
    .ADR1(\UL3/LUT_INDEX [3]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/LUT_INDEX [0]),
    .O(\UL3/N11 )
  );
  defparam \UL3/Mrom_LUT_DATA11 .INIT = 16'hF090;
  X_LUT4 \UL3/Mrom_LUT_DATA11  (
    .ADR0(\UL3/LUT_INDEX [1]),
    .ADR1(\UL3/LUT_INDEX [2]),
    .ADR2(\UL3/LUT_INDEX [0]),
    .ADR3(\UL3/LUT_INDEX [3]),
    .O(\UL3/N12 )
  );
  X_MUX2 \UL3/Mrom_LUT_DATA_f5_3  (
    .IA(\UL3/N12 ),
    .IB(\UL3/N11 ),
    .SEL(\UL3/LUT_INDEX [4]),
    .O(\UL3/Mrom_LUT_DATA_f54 )
  );
  defparam \UL3/Mrom_LUT_DATA12 .INIT = 16'hFFAB;
  X_LUT4 \UL3/Mrom_LUT_DATA12  (
    .ADR0(\UL3/LUT_INDEX [2]),
    .ADR1(\UL3/LUT_INDEX [0]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/LUT_INDEX [3]),
    .O(\UL3/N13 )
  );
  X_MUX2 \UL3/Mrom_LUT_DATA_f5_4  (
    .IA(\UL3/N13 ),
    .IB(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/LUT_INDEX [4]),
    .O(\UL3/Mrom_LUT_DATA_f55 )
  );
  defparam \UL3/Mrom_LUT_DATA13 .INIT = 16'hFEBA;
  X_LUT4 \UL3/Mrom_LUT_DATA13  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [0]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/LUT_INDEX [2]),
    .O(\UL3/N14 )
  );
  X_MUX2 \UL3/Mrom_LUT_DATA_f5_5  (
    .IA(\UL3/N14 ),
    .IB(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/LUT_INDEX [4]),
    .O(\UL3/Mrom_LUT_DATA_f56 )
  );
  defparam \UL3/SD_COUNTER_0 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_0  (
    .I(\UL3/Mcount_SD_COUNTER_lut [0]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER [0]),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_1 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_1  (
    .I(\UL3/Result [1]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER [1]),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_2 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_2  (
    .I(\UL3/Result [2]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER [2]),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_3 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_3  (
    .I(\UL3/Result [3]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER [3]),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_4 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_4  (
    .I(\UL3/Result [4]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER [4]),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_5 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_5  (
    .I(\UL3/Result [5]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER [5]),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_0 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_0  (
    .I(\UL3/Result<0>1 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [0]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_1 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_1  (
    .I(\UL3/Result<1>1 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [1]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_2 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_2  (
    .I(\UL3/Result<2>1 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [2]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_3 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_3  (
    .I(\UL3/Result<3>1 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [3]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_4 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_4  (
    .I(\UL3/Result<4>1 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [4]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_5 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_5  (
    .I(\UL3/Result<5>1 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [5]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_6 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_6  (
    .I(\UL3/Result [6]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [6]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_7 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_7  (
    .I(\UL3/Result [7]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [7]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_8 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_8  (
    .I(\UL3/Result [8]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [8]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_9 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_9  (
    .I(\UL3/Result [9]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [9]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_10 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_10  (
    .I(\UL3/Result [10]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [10]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_11 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_11  (
    .I(\UL3/Result [11]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [11]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_12 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_12  (
    .I(\UL3/Result [12]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [12]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_13 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_13  (
    .I(\UL3/Result [13]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [13]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_14 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_14  (
    .I(\UL3/Result [14]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [14]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_15 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_15  (
    .I(\UL3/Result [15]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [15]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_16 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_16  (
    .I(\UL3/Result [16]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [16]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_17 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_17  (
    .I(\UL3/Result [17]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [17]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_18 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_18  (
    .I(\UL3/Result [18]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [18]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_19 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_19  (
    .I(\UL3/Result [19]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [19]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_20 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_20  (
    .I(\UL3/Result [20]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [20]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_21 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_21  (
    .I(\UL3/Result [21]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [21]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_22 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_22  (
    .I(\UL3/Result [22]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [22]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_23 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_23  (
    .I(\UL3/Result [23]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [23]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_24 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_24  (
    .I(\UL3/Result [24]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [24]),
    .CE(VCC),
    .SET(GND)
  );
  defparam \UL3/L3_DIV_CLK_25 .INIT = 1'b0;
  X_FF \UL3/L3_DIV_CLK_25  (
    .I(\UL3/Result [25]),
    .RST(\UL3/nRESET_inv ),
    .CLK(clk_BUFGP),
    .O(\UL3/L3_DIV_CLK [25]),
    .CE(VCC),
    .SET(GND)
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<0>  (
    .IB(ethernet_cs_n_OBUF_17),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_2_rt_40 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [0])
  );
  defparam \UL3/Mcompar__cmp_lt0004_lut<1> .INIT = 8'h01;
  X_LUT3 \UL3/Mcompar__cmp_lt0004_lut<1>  (
    .ADR0(\UL3/L3_DIV_CLK [3]),
    .ADR1(\UL3/L3_DIV_CLK [4]),
    .ADR2(\UL3/L3_DIV_CLK [5]),
    .O(\UL3/N18 )
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<1>  (
    .IB(\UL3/Mcompar__cmp_lt0004_cy [0]),
    .IA(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/N18 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [1])
  );
  defparam \UL3/Mcompar__cmp_lt0004_lut<2> .INIT = 8'h80;
  X_LUT3 \UL3/Mcompar__cmp_lt0004_lut<2>  (
    .ADR0(\UL3/L3_DIV_CLK [6]),
    .ADR1(\UL3/L3_DIV_CLK [7]),
    .ADR2(\UL3/L3_DIV_CLK [8]),
    .O(\UL3/N19 )
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<2>  (
    .IB(\UL3/Mcompar__cmp_lt0004_cy [1]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/N19 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [2])
  );
  defparam \UL3/Mcompar__cmp_lt0004_lut<3> .INIT = 4'h1;
  X_LUT2 \UL3/Mcompar__cmp_lt0004_lut<3>  (
    .ADR0(\UL3/L3_DIV_CLK [9]),
    .ADR1(\UL3/L3_DIV_CLK [10]),
    .O(\UL3/N20 )
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<3>  (
    .IB(\UL3/Mcompar__cmp_lt0004_cy [2]),
    .IA(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/N20 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [3])
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<4>  (
    .IB(\UL3/Mcompar__cmp_lt0004_cy [3]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_11_rt_41 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [4])
  );
  defparam \UL3/Mcompar__cmp_lt0004_lut<5> .INIT = 16'h0001;
  X_LUT4 \UL3/Mcompar__cmp_lt0004_lut<5>  (
    .ADR0(\UL3/L3_DIV_CLK [12]),
    .ADR1(\UL3/L3_DIV_CLK [13]),
    .ADR2(\UL3/L3_DIV_CLK [14]),
    .ADR3(\UL3/L3_DIV_CLK [15]),
    .O(\UL3/N21 )
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<5>  (
    .IB(\UL3/Mcompar__cmp_lt0004_cy [4]),
    .IA(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/N21 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [5])
  );
  defparam \UL3/Mcompar__cmp_lt0004_lut<6> .INIT = 16'h0001;
  X_LUT4 \UL3/Mcompar__cmp_lt0004_lut<6>  (
    .ADR0(\UL3/L3_DIV_CLK [16]),
    .ADR1(\UL3/L3_DIV_CLK [17]),
    .ADR2(\UL3/L3_DIV_CLK [18]),
    .ADR3(\UL3/L3_DIV_CLK [19]),
    .O(\UL3/N22 )
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<6>  (
    .IB(\UL3/Mcompar__cmp_lt0004_cy [5]),
    .IA(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/N22 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [6])
  );
  defparam \UL3/Mcompar__cmp_lt0004_lut<7> .INIT = 16'h0001;
  X_LUT4 \UL3/Mcompar__cmp_lt0004_lut<7>  (
    .ADR0(\UL3/L3_DIV_CLK [20]),
    .ADR1(\UL3/L3_DIV_CLK [21]),
    .ADR2(\UL3/L3_DIV_CLK [22]),
    .ADR3(\UL3/L3_DIV_CLK [23]),
    .O(\UL3/N23 )
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<7>  (
    .IB(\UL3/Mcompar__cmp_lt0004_cy [6]),
    .IA(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/N23 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [7])
  );
  defparam \UL3/Mcompar__cmp_lt0004_lut<8> .INIT = 4'h1;
  X_LUT2 \UL3/Mcompar__cmp_lt0004_lut<8>  (
    .ADR0(\UL3/L3_DIV_CLK [24]),
    .ADR1(\UL3/L3_DIV_CLK [25]),
    .O(\UL3/N24 )
  );
  X_MUX2 \UL3/Mcompar__cmp_lt0004_cy<8>  (
    .IB(\UL3/Mcompar__cmp_lt0004_cy [7]),
    .IA(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/N24 ),
    .O(\UL3/Mcompar__cmp_lt0004_cy [8])
  );
  X_AND2 \UL3/L3_DIV_CLK_Eqn_0_mand  (
    .I0(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .I1(\UL3/L3_DIV_CLK [0]),
    .O(\UL3/L3_DIV_CLK_Eqn_0_mand1 )
  );
  defparam \UL3/Mcount_L3_DIV_CLK_lut<0> .INIT = 4'h4;
  X_LUT2 \UL3/Mcount_L3_DIV_CLK_lut<0>  (
    .ADR0(\UL3/L3_DIV_CLK [0]),
    .ADR1(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .O(\UL3/Result<0>1 )
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<0>  (
    .IB(DAC_rdy_diag_OBUF_19),
    .IA(\UL3/L3_DIV_CLK_Eqn_0_mand1 ),
    .SEL(\UL3/Result<0>1 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [0])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<1>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [0]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_1 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [1])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<1>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [0]),
    .I1(\UL3/L3_DIV_CLK_Eqn_1 ),
    .O(\UL3/Result<1>1 )
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<2>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [1]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_2 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [2])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<2>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [1]),
    .I1(\UL3/L3_DIV_CLK_Eqn_2 ),
    .O(\UL3/Result<2>1 )
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<3>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [2]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_3 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [3])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<3>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [2]),
    .I1(\UL3/L3_DIV_CLK_Eqn_3 ),
    .O(\UL3/Result<3>1 )
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<4>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [3]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_4 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [4])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<4>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [3]),
    .I1(\UL3/L3_DIV_CLK_Eqn_4 ),
    .O(\UL3/Result<4>1 )
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<5>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [4]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_5 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [5])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<5>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [4]),
    .I1(\UL3/L3_DIV_CLK_Eqn_5 ),
    .O(\UL3/Result<5>1 )
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<6>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [5]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_6 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [6])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<6>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [5]),
    .I1(\UL3/L3_DIV_CLK_Eqn_6 ),
    .O(\UL3/Result [6])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<7>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [6]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_7 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [7])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<7>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [6]),
    .I1(\UL3/L3_DIV_CLK_Eqn_7 ),
    .O(\UL3/Result [7])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<8>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [7]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_8 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [8])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<8>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [7]),
    .I1(\UL3/L3_DIV_CLK_Eqn_8 ),
    .O(\UL3/Result [8])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<9>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [8]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_9 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [9])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<9>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [8]),
    .I1(\UL3/L3_DIV_CLK_Eqn_9 ),
    .O(\UL3/Result [9])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<10>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [9]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_10 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [10])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<10>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [9]),
    .I1(\UL3/L3_DIV_CLK_Eqn_10 ),
    .O(\UL3/Result [10])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<11>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [10]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_11_29 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [11])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<11>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [10]),
    .I1(\UL3/L3_DIV_CLK_Eqn_11_29 ),
    .O(\UL3/Result [11])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<12>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [11]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_12 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [12])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<12>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [11]),
    .I1(\UL3/L3_DIV_CLK_Eqn_12 ),
    .O(\UL3/Result [12])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<13>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [12]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_13 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [13])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<13>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [12]),
    .I1(\UL3/L3_DIV_CLK_Eqn_13 ),
    .O(\UL3/Result [13])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<14>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [13]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_14 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [14])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<14>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [13]),
    .I1(\UL3/L3_DIV_CLK_Eqn_14 ),
    .O(\UL3/Result [14])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<15>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [14]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_15 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [15])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<15>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [14]),
    .I1(\UL3/L3_DIV_CLK_Eqn_15 ),
    .O(\UL3/Result [15])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<16>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [15]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_16 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [16])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<16>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [15]),
    .I1(\UL3/L3_DIV_CLK_Eqn_16 ),
    .O(\UL3/Result [16])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<17>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [16]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_17 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [17])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<17>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [16]),
    .I1(\UL3/L3_DIV_CLK_Eqn_17 ),
    .O(\UL3/Result [17])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<18>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [17]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_18 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [18])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<18>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [17]),
    .I1(\UL3/L3_DIV_CLK_Eqn_18 ),
    .O(\UL3/Result [18])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<19>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [18]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_19 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [19])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<19>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [18]),
    .I1(\UL3/L3_DIV_CLK_Eqn_19 ),
    .O(\UL3/Result [19])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<20>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [19]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_20 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [20])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<20>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [19]),
    .I1(\UL3/L3_DIV_CLK_Eqn_20 ),
    .O(\UL3/Result [20])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<21>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [20]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_21_30 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [21])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<21>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [20]),
    .I1(\UL3/L3_DIV_CLK_Eqn_21_30 ),
    .O(\UL3/Result [21])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<22>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [21]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_22 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [22])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<22>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [21]),
    .I1(\UL3/L3_DIV_CLK_Eqn_22 ),
    .O(\UL3/Result [22])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<23>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [22]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_23 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [23])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<23>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [22]),
    .I1(\UL3/L3_DIV_CLK_Eqn_23 ),
    .O(\UL3/Result [23])
  );
  X_MUX2 \UL3/Mcount_L3_DIV_CLK_cy<24>  (
    .IB(\UL3/Mcount_L3_DIV_CLK_cy [23]),
    .IA(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/L3_DIV_CLK_Eqn_24 ),
    .O(\UL3/Mcount_L3_DIV_CLK_cy [24])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<24>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [23]),
    .I1(\UL3/L3_DIV_CLK_Eqn_24 ),
    .O(\UL3/Result [24])
  );
  X_XOR2 \UL3/Mcount_L3_DIV_CLK_xor<25>  (
    .I0(\UL3/Mcount_L3_DIV_CLK_cy [24]),
    .I1(\UL3/L3_DIV_CLK_Eqn_25 ),
    .O(\UL3/Result [25])
  );
  defparam \UL3/L3_SCLK1 .INIT = 4'hE;
  X_LUT2 \UL3/L3_SCLK1  (
    .ADR0(\UL3/L3_CTRL_CLK1 ),
    .ADR1(\UL3/L3_CK_26 ),
    .O(L3_SCLK_OBUF_15)
  );
  defparam \UL3/Mcount_SD_COUNTER_lut<0>1 .INIT = 4'h2;
  X_LUT2 \UL3/Mcount_SD_COUNTER_lut<0>1  (
    .ADR0(\UL3/SD_COUNTER_CTRL_24 ),
    .ADR1(\UL3/SD_COUNTER [0]),
    .O(\UL3/Mcount_SD_COUNTER_lut [0])
  );
  defparam \UL3/Mcount_SD_COUNTER_xor<1>11 .INIT = 8'h28;
  X_LUT3 \UL3/Mcount_SD_COUNTER_xor<1>11  (
    .ADR0(\UL3/SD_COUNTER_CTRL_24 ),
    .ADR1(\UL3/SD_COUNTER [0]),
    .ADR2(\UL3/SD_COUNTER [1]),
    .O(\UL3/Result [1])
  );
  defparam \UL3/Mcount_SD_COUNTER_xor<2>11 .INIT = 16'h28A0;
  X_LUT4 \UL3/Mcount_SD_COUNTER_xor<2>11  (
    .ADR0(\UL3/SD_COUNTER_CTRL_24 ),
    .ADR1(\UL3/SD_COUNTER [0]),
    .ADR2(\UL3/SD_COUNTER [2]),
    .ADR3(\UL3/SD_COUNTER [1]),
    .O(\UL3/Result [2])
  );
  defparam \UL3/Mcount_SD_COUNTER_xor<4>11 .INIT = 16'hA028;
  X_LUT4 \UL3/Mcount_SD_COUNTER_xor<4>11  (
    .ADR0(\UL3/SD_COUNTER_CTRL_24 ),
    .ADR1(\UL3/SD_COUNTER [3]),
    .ADR2(\UL3/SD_COUNTER [4]),
    .ADR3(\UL3/N141 ),
    .O(\UL3/Result [4])
  );
  defparam \u0/_mux0000<0>1 .INIT = 16'hA280;
  X_LUT4 \u0/_mux0000<0>1  (
    .ADR0(\u0/DAC_rdy ),
    .ADR1(N678),
    .ADR2(left_ADC[0]),
    .ADR3(right_ADC[0]),
    .O(\u0/_mux0000 [0])
  );
  defparam \u0/_mux0000<18> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<18>  (
    .ADR0(\u0/DAC_r [17]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N21),
    .O(\u0/_mux0000 [18])
  );
  defparam \u0/_mux0000<17> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<17>  (
    .ADR0(\u0/DAC_r [16]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N23),
    .O(\u0/_mux0000 [17])
  );
  defparam \u0/_mux0000<19> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<19>  (
    .ADR0(\u0/DAC_r [18]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N25),
    .O(\u0/_mux0000 [19])
  );
  defparam \u0/_mux0000<15> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<15>  (
    .ADR0(\u0/DAC_r [14]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N27),
    .O(\u0/_mux0000 [15])
  );
  defparam \u0/_mux0000<16> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<16>  (
    .ADR0(\u0/DAC_r [15]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N29),
    .O(\u0/_mux0000 [16])
  );
  defparam \u0/_mux0000<14> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<14>  (
    .ADR0(\u0/DAC_r [13]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N31),
    .O(\u0/_mux0000 [14])
  );
  defparam \u0/_mux0000<12> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<12>  (
    .ADR0(\u0/DAC_r [11]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N33),
    .O(\u0/_mux0000 [12])
  );
  defparam \u0/_mux0000<13> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<13>  (
    .ADR0(\u0/DAC_r [12]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N35),
    .O(\u0/_mux0000 [13])
  );
  defparam \u0/_mux0000<10> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<10>  (
    .ADR0(\u0/DAC_r [9]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N37),
    .O(\u0/_mux0000 [10])
  );
  defparam \u0/_mux0000<9> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<9>  (
    .ADR0(\u0/DAC_r [8]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N39),
    .O(\u0/_mux0000 [9])
  );
  defparam \u0/_mux0000<11> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<11>  (
    .ADR0(\u0/DAC_r [10]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N41),
    .O(\u0/_mux0000 [11])
  );
  defparam \u0/_mux0000<7> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<7>  (
    .ADR0(\u0/DAC_r [6]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N43),
    .O(\u0/_mux0000 [7])
  );
  defparam \u0/_mux0000<6> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<6>  (
    .ADR0(\u0/DAC_r [5]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N45),
    .O(\u0/_mux0000 [6])
  );
  defparam \u0/_mux0000<8> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<8>  (
    .ADR0(\u0/DAC_r [7]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N47),
    .O(\u0/_mux0000 [8])
  );
  defparam \u0/_mux0000<4> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<4>  (
    .ADR0(\u0/DAC_r [3]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N49),
    .O(\u0/_mux0000 [4])
  );
  defparam \u0/_mux0000<5> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<5>  (
    .ADR0(\u0/DAC_r [4]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N51),
    .O(\u0/_mux0000 [5])
  );
  defparam \u0/_mux0000<3> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<3>  (
    .ADR0(\u0/DAC_r [2]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N53),
    .O(\u0/_mux0000 [3])
  );
  defparam \u0/_mux0000<1> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<1>  (
    .ADR0(\u0/DAC_r [0]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N55),
    .O(\u0/_mux0000 [1])
  );
  defparam \u0/_mux0000<2> .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<2>  (
    .ADR0(\u0/DAC_r [1]),
    .ADR1(\u0/DAC_rdy ),
    .ADR2(N57),
    .O(\u0/_mux0000 [2])
  );
  defparam \UL3/_mux000621 .INIT = 8'h18;
  X_LUT3 \UL3/_mux000621  (
    .ADR0(\UL3/SD_COUNTER [4]),
    .ADR1(\UL3/SD_COUNTER [2]),
    .ADR2(\UL3/SD_COUNTER [3]),
    .O(\UL3/_mux0006_map8 )
  );
  defparam \UL3/_mux000629 .INIT = 8'h02;
  X_LUT3 \UL3/_mux000629  (
    .ADR0(\UL3/SD_COUNTER [0]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [5]),
    .O(\UL3/_mux0006_map12 )
  );
  defparam \UL3/_mux000645 .INIT = 16'hF888;
  X_LUT4 \UL3/_mux000645  (
    .ADR0(\UL3/LUT_INDEX [4]),
    .ADR1(\UL3/N2 ),
    .ADR2(\UL3/_mux0006_map8 ),
    .ADR3(\UL3/_mux0006_map12 ),
    .O(\UL3/_mux0006_map14 )
  );
  defparam \UL3/_mux000660 .INIT = 8'hF8;
  X_LUT3 \UL3/_mux000660  (
    .ADR0(\UL3/SD_COUNTER [0]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [5]),
    .O(\UL3/_mux0006_map16 )
  );
  defparam \UL3/_mux000671 .INIT = 16'h22F2;
  X_LUT4 \UL3/_mux000671  (
    .ADR0(\UL3/SD_COUNTER [4]),
    .ADR1(\UL3/SD_COUNTER [0]),
    .ADR2(\UL3/SD_COUNTER [2]),
    .ADR3(\UL3/SD_COUNTER [3]),
    .O(\UL3/_mux0006_map21 )
  );
  defparam \UL3/_mux0006104 .INIT = 16'h313B;
  X_LUT4 \UL3/_mux0006104  (
    .ADR0(\UL3/SD_COUNTER [3]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [2]),
    .ADR3(\UL3/SD_COUNTER [4]),
    .O(\UL3/_mux0006_map31 )
  );
  defparam \UL3/_mux0006136 .INIT = 4'hE;
  X_LUT2 \UL3/_mux0006136  (
    .ADR0(\UL3/_mux0006_map14 ),
    .ADR1(\UL3/_mux0006_map33 ),
    .O(\UL3/_mux0006 )
  );
  defparam \u0/_and0001_SW0 .INIT = 16'hFF7F;
  X_LUT4 \u0/_and0001_SW0  (
    .ADR0(\u0/cnt_r [5]),
    .ADR1(\u0/cnt_r [4]),
    .ADR2(\u0/cnt_r [3]),
    .ADR3(\u0/cnt_r [6]),
    .O(N153)
  );
  defparam \u0/_and0001 .INIT = 16'h0020;
  X_LUT4 \u0/_and0001  (
    .ADR0(N679),
    .ADR1(\u0/cnt_r [8]),
    .ADR2(\u0/cnt_r [7]),
    .ADR3(N153),
    .O(\u0/DAC_rdy )
  );
  defparam \UL3/_mux000747 .INIT = 16'h1006;
  X_LUT4 \UL3/_mux000747  (
    .ADR0(\UL3/SD_COUNTER [1]),
    .ADR1(\UL3/SD_COUNTER [4]),
    .ADR2(\UL3/SD_COUNTER [0]),
    .ADR3(\UL3/SD_COUNTER [2]),
    .O(\UL3/_mux0007_map49 )
  );
  defparam \UL3/_mux0007111 .INIT = 8'h72;
  X_LUT3 \UL3/_mux0007111  (
    .ADR0(\UL3/SD_COUNTER [4]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [2]),
    .O(\UL3/_mux0007_map65 )
  );
  defparam \UL3/_mux000529 .INIT = 16'h22F2;
  X_LUT4 \UL3/_mux000529  (
    .ADR0(\UL3/SD_COUNTER [4]),
    .ADR1(\UL3/SD_COUNTER [2]),
    .ADR2(\UL3/SD_COUNTER [5]),
    .ADR3(\UL3/SD_COUNTER [0]),
    .O(\UL3/_mux0005_map80 )
  );
  defparam \UL3/_mux000593 .INIT = 8'h01;
  X_LUT3 \UL3/_mux000593  (
    .ADR0(\UL3/SD_COUNTER [0]),
    .ADR1(\UL3/SD_COUNTER [5]),
    .ADR2(\UL3/N131 ),
    .O(\UL3/_mux0005_map94 )
  );
  defparam \UL3/_mux000595 .INIT = 8'hF8;
  X_LUT3 \UL3/_mux000595  (
    .ADR0(\UL3/SD_COUNTER_CTRL_24 ),
    .ADR1(\UL3/_mux0005_map88 ),
    .ADR2(\UL3/_mux0005_map94 ),
    .O(\UL3/_mux0005 )
  );
  defparam \u0/_and0002 .INIT = 16'h0020;
  X_LUT4 \u0/_and0002  (
    .ADR0(\u0/cnt_r [8]),
    .ADR1(\u0/cnt_r [7]),
    .ADR2(\u0/cnt_r [6]),
    .ADR3(N305),
    .O(ADC_rdy)
  );
  defparam \UL3/_mux0004<3>2 .INIT = 16'h221F;
  X_LUT4 \UL3/_mux0004<3>2  (
    .ADR0(\UL3/LUT_INDEX [1]),
    .ADR1(\UL3/LUT_INDEX [4]),
    .ADR2(\UL3/N2 ),
    .ADR3(\UL3/N261 ),
    .O(\UL3/_mux0004 [3])
  );
  defparam \UL3/_mux0004<2>1 .INIT = 16'h4414;
  X_LUT4 \UL3/_mux0004<2>1  (
    .ADR0(\UL3/LUT_INDEX [4]),
    .ADR1(\UL3/LUT_INDEX [2]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/N261 ),
    .O(\UL3/_mux0004 [2])
  );
  defparam \UL3/_mux0004<3>11 .INIT = 4'h7;
  X_LUT2 \UL3/_mux0004<3>11  (
    .ADR0(\UL3/LUT_INDEX [0]),
    .ADR1(N681),
    .O(\UL3/N261 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_251 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_251  (
    .ADR0(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .ADR1(\UL3/L3_DIV_CLK [25]),
    .O(\UL3/L3_DIV_CLK_Eqn_25 )
  );
  defparam \UL3/_mux000849 .INIT = 16'hEAC0;
  X_LUT4 \UL3/_mux000849  (
    .ADR0(\UL3/SD_COUNTER [5]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/_mux0006_map8 ),
    .ADR3(N680),
    .O(\UL3/_mux0008_map112 )
  );
  defparam \UL3/_mux0008137 .INIT = 16'hFAF8;
  X_LUT4 \UL3/_mux0008137  (
    .ADR0(\UL3/SDO_13 ),
    .ADR1(\UL3/_mux0008_map125 ),
    .ADR2(\UL3/_mux0008_map101 ),
    .ADR3(\UL3/_mux0008_map112 ),
    .O(\UL3/_mux0008_map128 )
  );
  defparam \UL3/_mux0008278 .INIT = 8'h08;
  X_LUT3 \UL3/_mux0008278  (
    .ADR0(\UL3/SD_COUNTER [3]),
    .ADR1(\UL3/SD_DATA1 [6]),
    .ADR2(N682),
    .O(\UL3/_mux0008_map164 )
  );
  defparam \UL3/_mux0008366 .INIT = 16'hA0FC;
  X_LUT4 \UL3/_mux0008366  (
    .ADR0(\UL3/SD_DATA1 [5]),
    .ADR1(\UL3/SD_DATA [6]),
    .ADR2(\UL3/SD_COUNTER_1_1_46 ),
    .ADR3(\UL3/SD_COUNTER_3_2_48 ),
    .O(\UL3/_mux0008_map185 )
  );
  defparam \UL3/_mux0008371 .INIT = 8'h20;
  X_LUT3 \UL3/_mux0008371  (
    .ADR0(\UL3/SD_DATA1 [3]),
    .ADR1(\UL3/SD_COUNTER_1_1_46 ),
    .ADR2(\UL3/SD_COUNTER_3_1_44 ),
    .O(\UL3/_mux0008_map188 )
  );
  defparam \UL3/_mux0008502 .INIT = 8'hDC;
  X_LUT3 \UL3/_mux0008502  (
    .ADR0(\UL3/SD_COUNTER [5]),
    .ADR1(\UL3/_mux0008_map128 ),
    .ADR2(\UL3/_mux0008_map204 ),
    .O(\UL3/_mux0008 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_241 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_241  (
    .ADR0(\UL3/L3_DIV_CLK [24]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_24 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_231 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_231  (
    .ADR0(\UL3/L3_DIV_CLK [23]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_23 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_221 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_221  (
    .ADR0(\UL3/L3_DIV_CLK [22]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_22 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_211 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_211  (
    .ADR0(\UL3/L3_DIV_CLK [21]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_21_30 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_201 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_201  (
    .ADR0(\UL3/L3_DIV_CLK [20]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_20 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_191 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_191  (
    .ADR0(\UL3/L3_DIV_CLK [19]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_19 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_181 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_181  (
    .ADR0(\UL3/L3_DIV_CLK [18]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_18 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_171 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_171  (
    .ADR0(\UL3/L3_DIV_CLK [17]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_17 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_161 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_161  (
    .ADR0(\UL3/L3_DIV_CLK [16]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_16 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_151 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_151  (
    .ADR0(\UL3/L3_DIV_CLK [15]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_15 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_141 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_141  (
    .ADR0(\UL3/L3_DIV_CLK [14]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_14 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_131 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_131  (
    .ADR0(\UL3/L3_DIV_CLK [13]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_13 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_121 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_121  (
    .ADR0(\UL3/L3_DIV_CLK [12]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_12 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_111 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_111  (
    .ADR0(\UL3/L3_DIV_CLK [11]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_11_29 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_101 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_101  (
    .ADR0(\UL3/L3_DIV_CLK [10]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_10 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_91 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_91  (
    .ADR0(\UL3/L3_DIV_CLK [9]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_9 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_81 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_81  (
    .ADR0(\UL3/L3_DIV_CLK [8]),
    .ADR1(\UL3/L3_DIV_CLK_Eqn_bis_0 ),
    .O(\UL3/L3_DIV_CLK_Eqn_8 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_71 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_71  (
    .ADR0(\UL3/L3_DIV_CLK [7]),
    .ADR1(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .O(\UL3/L3_DIV_CLK_Eqn_7 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_61 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_61  (
    .ADR0(\UL3/L3_DIV_CLK [6]),
    .ADR1(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .O(\UL3/L3_DIV_CLK_Eqn_6 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_51 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_51  (
    .ADR0(\UL3/L3_DIV_CLK [5]),
    .ADR1(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .O(\UL3/L3_DIV_CLK_Eqn_5 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_41 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_41  (
    .ADR0(\UL3/L3_DIV_CLK [4]),
    .ADR1(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .O(\UL3/L3_DIV_CLK_Eqn_4 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_31 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_31  (
    .ADR0(\UL3/L3_DIV_CLK [3]),
    .ADR1(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .O(\UL3/L3_DIV_CLK_Eqn_3 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_21 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_21  (
    .ADR0(\UL3/L3_DIV_CLK [2]),
    .ADR1(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .O(\UL3/L3_DIV_CLK_Eqn_2 )
  );
  defparam \UL3/L3_DIV_CLK_Eqn_11 .INIT = 4'h8;
  X_LUT2 \UL3/L3_DIV_CLK_Eqn_11  (
    .ADR0(\UL3/L3_DIV_CLK [1]),
    .ADR1(\UL3/Mcompar__cmp_lt0004_cy<8>_inv ),
    .O(\UL3/L3_DIV_CLK_Eqn_1 )
  );
  X_BUF reset_n_IBUF (
    .I(reset_n),
    .O(reset_n_IBUF_14)
  );
  X_BUF sdto_IBUF (
    .I(sdto),
    .O(sdto_IBUF_16)
  );
  defparam \u0/cnt_r_1_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_1_rt  (
    .ADR0(\u0/cnt_r [1]),
    .O(\u0/cnt_r_1_rt_32 ),
    .ADR1(GND)
  );
  defparam \u0/cnt_r_2_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_2_rt  (
    .ADR0(\u0/cnt_r [2]),
    .O(\u0/cnt_r_2_rt_33 ),
    .ADR1(GND)
  );
  defparam \u0/cnt_r_3_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_3_rt  (
    .ADR0(\u0/cnt_r [3]),
    .O(\u0/cnt_r_3_rt_34 ),
    .ADR1(GND)
  );
  defparam \u0/cnt_r_4_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_4_rt  (
    .ADR0(\u0/cnt_r [4]),
    .O(\u0/cnt_r_4_rt_35 ),
    .ADR1(GND)
  );
  defparam \u0/cnt_r_5_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_5_rt  (
    .ADR0(\u0/cnt_r [5]),
    .O(\u0/cnt_r_5_rt_36 ),
    .ADR1(GND)
  );
  defparam \u0/cnt_r_6_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_6_rt  (
    .ADR0(\u0/cnt_r [6]),
    .O(\u0/cnt_r_6_rt_37 ),
    .ADR1(GND)
  );
  defparam \u0/cnt_r_7_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_7_rt  (
    .ADR0(\u0/cnt_r [7]),
    .O(\u0/cnt_r_7_rt_38 ),
    .ADR1(GND)
  );
  defparam \u0/cnt_r_8_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_8_rt  (
    .ADR0(\u0/cnt_r [8]),
    .O(\u0/cnt_r_8_rt_39 ),
    .ADR1(GND)
  );
  defparam \UL3/L3_DIV_CLK_2_rt .INIT = 4'hA;
  X_LUT2 \UL3/L3_DIV_CLK_2_rt  (
    .ADR0(\UL3/L3_DIV_CLK [2]),
    .O(\UL3/L3_DIV_CLK_2_rt_40 ),
    .ADR1(GND)
  );
  defparam \UL3/L3_DIV_CLK_11_rt .INIT = 4'hA;
  X_LUT2 \UL3/L3_DIV_CLK_11_rt  (
    .ADR0(\UL3/L3_DIV_CLK [11]),
    .O(\UL3/L3_DIV_CLK_11_rt_41 ),
    .ADR1(GND)
  );
  defparam \u0/cnt_r_9_rt .INIT = 4'hA;
  X_LUT2 \u0/cnt_r_9_rt  (
    .ADR0(\u0/cnt_r [9]),
    .O(\u0/cnt_r_9_rt_42 ),
    .ADR1(GND)
  );
  defparam \UL3/_mux0008205 .INIT = 16'h4440;
  X_LUT4 \UL3/_mux0008205  (
    .ADR0(\UL3/SD_COUNTER [4]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/_mux0008_map141 ),
    .ADR3(\UL3/_mux0008_map133 ),
    .O(\UL3/_mux0008_map145 )
  );
  defparam \UL3/_mux000810_SW0 .INIT = 8'h1F;
  X_LUT3 \UL3/_mux000810_SW0  (
    .ADR0(\UL3/SD_DATA1 [7]),
    .ADR1(\UL3/SD_COUNTER [0]),
    .ADR2(\UL3/SD_COUNTER [5]),
    .O(N629)
  );
  defparam \UL3/_mux0008266 .INIT = 16'h00AC;
  X_LUT4 \UL3/_mux0008266  (
    .ADR0(\UL3/SD_DATA1 [2]),
    .ADR1(\UL3/SD_DATA [5]),
    .ADR2(\UL3/SD_COUNTER_3_2_48 ),
    .ADR3(\UL3/SD_COUNTER_2_2_47 ),
    .O(\UL3/_mux0008_map159 )
  );
  defparam \UL3/_mux0004<0>_SW1 .INIT = 16'h8000;
  X_LUT4 \UL3/_mux0004<0>_SW1  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [2]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/LUT_INDEX [0]),
    .O(N631)
  );
  defparam \UL3/_mux0004<0> .INIT = 16'h20EC;
  X_LUT4 \UL3/_mux0004<0>  (
    .ADR0(N631),
    .ADR1(\UL3/LUT_INDEX [4]),
    .ADR2(\UL3/_or0000_25 ),
    .ADR3(\UL3/N2 ),
    .O(\UL3/_mux0004 [0])
  );
  defparam \UL3/_and0000 .INIT = 16'h0103;
  X_LUT4 \UL3/_and0000  (
    .ADR0(\UL3/LUT_INDEX [4]),
    .ADR1(\UL3/N131 ),
    .ADR2(N633),
    .ADR3(\UL3/N2 ),
    .O(\UL3/_and0000_22 )
  );
  defparam \UL3/_and0001 .INIT = 16'h0103;
  X_LUT4 \UL3/_and0001  (
    .ADR0(\UL3/LUT_INDEX [4]),
    .ADR1(\UL3/N141 ),
    .ADR2(N635),
    .ADR3(\UL3/N2 ),
    .O(\UL3/_and0001_23 )
  );
  defparam \UL3/_mux0007140 .INIT = 16'hFCF8;
  X_LUT4 \UL3/_mux0007140  (
    .ADR0(\UL3/_mux0007_map60 ),
    .ADR1(\UL3/L3_EN_18 ),
    .ADR2(N637),
    .ADR3(\UL3/_mux0007_map65 ),
    .O(\UL3/_mux0007 )
  );
  defparam \UL3/_or0000_SW0 .INIT = 16'hFF7F;
  X_LUT4 \UL3/_or0000_SW0  (
    .ADR0(\UL3/SD_COUNTER [1]),
    .ADR1(\UL3/SD_COUNTER [4]),
    .ADR2(\UL3/SD_COUNTER [2]),
    .ADR3(\UL3/SD_COUNTER [3]),
    .O(N314)
  );
  defparam \UL3/_mux0008182 .INIT = 16'h0F02;
  X_LUT4 \UL3/_mux0008182  (
    .ADR0(\UL3/SD_COUNTER [3]),
    .ADR1(\UL3/SD_COUNTER [2]),
    .ADR2(\UL3/SD_COUNTER [0]),
    .ADR3(\UL3/_mux0008_map137 ),
    .O(\UL3/_mux0008_map141 )
  );
  defparam \UL3/_mux0004<4>1 .INIT = 16'h143C;
  X_LUT4 \UL3/_mux0004<4>1  (
    .ADR0(\UL3/LUT_INDEX [4]),
    .ADR1(\UL3/LUT_INDEX [0]),
    .ADR2(\UL3/_or0000_25 ),
    .ADR3(\UL3/N2 ),
    .O(\UL3/_mux0004 [4])
  );
  defparam \u0/_not0001 .INIT = 16'hA280;
  X_LUT4 \u0/_not0001  (
    .ADR0(\u0/N21 ),
    .ADR1(\u0/cnt_r [8]),
    .ADR2(\u0/cnt_r [3]),
    .ADR3(N641),
    .O(\u0/_not0001_20 )
  );
  defparam \UL3/_not0007 .INIT = 16'h7FFF;
  X_LUT4 \UL3/_not0007  (
    .ADR0(\UL3/SD_COUNTER [3]),
    .ADR1(\UL3/SD_COUNTER [2]),
    .ADR2(\UL3/SD_COUNTER [1]),
    .ADR3(N643),
    .O(\UL3/_not0007_28 )
  );
  defparam \u0/_and0000 .INIT = 16'h2000;
  X_LUT4 \u0/_and0000  (
    .ADR0(\u0/cnt_r [1]),
    .ADR1(N645),
    .ADR2(\u0/cnt_r [0]),
    .ADR3(\u0/cnt_r [2]),
    .O(\u0/_and0000_21 )
  );
  defparam \UL3/Mcount_SD_COUNTER_xor<5>1_SW1 .INIT = 16'h8000;
  X_LUT4 \UL3/Mcount_SD_COUNTER_xor<5>1_SW1  (
    .ADR0(\UL3/SD_COUNTER [2]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [0]),
    .ADR3(\UL3/SD_COUNTER [4]),
    .O(N647)
  );
  defparam \UL3/Mcount_SD_COUNTER_xor<5>1 .INIT = 16'h28A0;
  X_LUT4 \UL3/Mcount_SD_COUNTER_xor<5>1  (
    .ADR0(\UL3/SD_COUNTER_CTRL_24 ),
    .ADR1(\UL3/SD_COUNTER [3]),
    .ADR2(\UL3/SD_COUNTER [5]),
    .ADR3(N647),
    .O(\UL3/Result [5])
  );
  defparam _not00031.INIT = 16'h6A00;
  X_LUT4 _not00031 (
    .ADR0(\u0/cnt_r [9]),
    .ADR1(\u0/cnt_r [7]),
    .ADR2(\u0/cnt_r [8]),
    .ADR3(ADC_rdy),
    .O(_not0003)
  );
  defparam _not00021.INIT = 16'h9500;
  X_LUT4 _not00021 (
    .ADR0(\u0/cnt_r [9]),
    .ADR1(\u0/cnt_r [7]),
    .ADR2(\u0/cnt_r [8]),
    .ADR3(ADC_rdy),
    .O(_not0002)
  );
  defparam \UL3/_mux0008160_SW0 .INIT = 16'hA00C;
  X_LUT4 \UL3/_mux0008160_SW0  (
    .ADR0(\UL3/SD_DATA [1]),
    .ADR1(\UL3/SD_DATA [9]),
    .ADR2(\UL3/SD_COUNTER_3_1_44 ),
    .ADR3(\UL3/SD_COUNTER_2_2_47 ),
    .O(N649)
  );
  defparam \UL3/_mux0008327_SW0 .INIT = 16'h00AC;
  X_LUT4 \UL3/_mux0008327_SW0  (
    .ADR0(\UL3/SD_DATA1 [0]),
    .ADR1(\UL3/SD_DATA [3]),
    .ADR2(\UL3/SD_COUNTER_3_2_48 ),
    .ADR3(\UL3/SD_COUNTER_2_2_47 ),
    .O(N627)
  );
  defparam \UL3/_mux0004<1>_SW2 .INIT = 8'h7F;
  X_LUT3 \UL3/_mux0004<1>_SW2  (
    .ADR0(\UL3/LUT_INDEX [2]),
    .ADR1(\UL3/LUT_INDEX [1]),
    .ADR2(\UL3/LUT_INDEX [0]),
    .O(N651)
  );
  defparam \UL3/_mux0004<1> .INIT = 16'h4414;
  X_LUT4 \UL3/_mux0004<1>  (
    .ADR0(\UL3/LUT_INDEX [4]),
    .ADR1(\UL3/LUT_INDEX [3]),
    .ADR2(\UL3/_or0000_25 ),
    .ADR3(N651),
    .O(\UL3/_mux0004 [1])
  );
  defparam \UL3/_mux0008453_SW1 .INIT = 16'hF5E4;
  X_LUT4 \UL3/_mux0008453_SW1  (
    .ADR0(\UL3/SD_COUNTER [1]),
    .ADR1(\UL3/_mux0008_map171 ),
    .ADR2(\UL3/_mux0008_map159 ),
    .ADR3(N627),
    .O(N654)
  );
  defparam \UL3/_mux0008453 .INIT = 16'hFDEC;
  X_LUT4 \UL3/_mux0008453  (
    .ADR0(\UL3/SD_COUNTER [0]),
    .ADR1(\UL3/_mux0008_map164 ),
    .ADR2(N654),
    .ADR3(N653),
    .O(\UL3/_mux0008_map202 )
  );
  defparam \UL3/_cmp_lt00001 .INIT = 16'h01FF;
  X_LUT4 \UL3/_cmp_lt00001  (
    .ADR0(\UL3/LUT_INDEX [2]),
    .ADR1(\UL3/LUT_INDEX [3]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/LUT_INDEX [4]),
    .O(\UL3/_cmp_lt0000 )
  );
  defparam \UL3/SD_COUNTER_2_1 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_2_1  (
    .I(\UL3/Result [2]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER_2_1_43 ),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_3_1 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_3_1  (
    .I(\UL3/Result [3]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER_3_1_44 ),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_0_1 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_0_1  (
    .I(\UL3/Mcount_SD_COUNTER_lut [0]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER_0_1_45 ),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_1_1 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_1_1  (
    .I(\UL3/Result [1]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER_1_1_46 ),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_2_2 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_2_2  (
    .I(\UL3/Result [2]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER_2_2_47 ),
    .SET(GND)
  );
  defparam \UL3/SD_COUNTER_3_2 .INIT = 1'b0;
  X_FF \UL3/SD_COUNTER_3_2  (
    .I(\UL3/Result [3]),
    .CE(\UL3/_not0007_28 ),
    .RST(\UL3/nRESET_inv ),
    .CLK(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/SD_COUNTER_3_2_48 ),
    .SET(GND)
  );
  X_MUX2 \UL3/Mrom_LUT_DATA_f51  (
    .IA(N658),
    .IB(N659),
    .SEL(\UL3/LUT_INDEX [1]),
    .O(\UL3/Mrom_LUT_DATA_f5 )
  );
  defparam \UL3/Mrom_LUT_DATA_f51_F .INIT = 16'hC8CA;
  X_LUT4 \UL3/Mrom_LUT_DATA_f51_F  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [4]),
    .ADR2(\UL3/LUT_INDEX [2]),
    .ADR3(\UL3/LUT_INDEX [0]),
    .O(N658)
  );
  defparam \UL3/Mrom_LUT_DATA_f51_G .INIT = 16'hFF49;
  X_LUT4 \UL3/Mrom_LUT_DATA_f51_G  (
    .ADR0(\UL3/LUT_INDEX [2]),
    .ADR1(\UL3/LUT_INDEX [3]),
    .ADR2(\UL3/LUT_INDEX [0]),
    .ADR3(\UL3/LUT_INDEX [4]),
    .O(N659)
  );
  X_MUX2 \UL3/Mrom_LUT_DATA_f5_01  (
    .IA(N660),
    .IB(N661),
    .SEL(\UL3/LUT_INDEX [1]),
    .O(\UL3/Mrom_LUT_DATA_f51_31 )
  );
  defparam \UL3/Mrom_LUT_DATA_f5_01_F .INIT = 16'hEC8C;
  X_LUT4 \UL3/Mrom_LUT_DATA_f5_01_F  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [4]),
    .ADR2(\UL3/LUT_INDEX [0]),
    .ADR3(\UL3/LUT_INDEX [2]),
    .O(N660)
  );
  defparam \UL3/Mrom_LUT_DATA_f5_01_G .INIT = 16'hFF91;
  X_LUT4 \UL3/Mrom_LUT_DATA_f5_01_G  (
    .ADR0(\UL3/LUT_INDEX [2]),
    .ADR1(\UL3/LUT_INDEX [0]),
    .ADR2(\UL3/LUT_INDEX [3]),
    .ADR3(\UL3/LUT_INDEX [4]),
    .O(N661)
  );
  X_MUX2 \UL3/_mux0008238  (
    .IA(N662),
    .IB(N663),
    .SEL(\UL3/SD_COUNTER [2]),
    .O(\UL3/_mux0008_map154 )
  );
  defparam \UL3/_mux0008238_F .INIT = 16'h2000;
  X_LUT4 \UL3/_mux0008238_F  (
    .ADR0(\UL3/SD_COUNTER [3]),
    .ADR1(\UL3/SD_COUNTER [0]),
    .ADR2(\UL3/SD_COUNTER [1]),
    .ADR3(\UL3/SD_DATA1 [1]),
    .O(N662)
  );
  defparam \UL3/_mux0008238_G .INIT = 16'h0100;
  X_LUT4 \UL3/_mux0008238_G  (
    .ADR0(\UL3/SD_COUNTER [3]),
    .ADR1(\UL3/SD_COUNTER [4]),
    .ADR2(\UL3/SD_COUNTER [0]),
    .ADR3(\UL3/SD_DATA [10]),
    .O(N663)
  );
  X_MUX2 \UL3/_mux000897  (
    .IA(N664),
    .IB(N665),
    .SEL(\UL3/SD_COUNTER [3]),
    .O(\UL3/_mux0008_map125 )
  );
  defparam \UL3/_mux000897_F .INIT = 16'h0001;
  X_LUT4 \UL3/_mux000897_F  (
    .ADR0(\UL3/SD_COUNTER [2]),
    .ADR1(\UL3/SD_COUNTER [5]),
    .ADR2(\UL3/SD_COUNTER [4]),
    .ADR3(\UL3/SD_COUNTER [1]),
    .O(N664)
  );
  defparam \UL3/_mux000897_G .INIT = 16'h0206;
  X_LUT4 \UL3/_mux000897_G  (
    .ADR0(\UL3/SD_COUNTER [2]),
    .ADR1(\UL3/SD_COUNTER [4]),
    .ADR2(\UL3/SD_COUNTER [1]),
    .ADR3(\UL3/SD_COUNTER [0]),
    .O(N665)
  );
  X_CKBUF \UL3/L3_CTRL_CLK_BUFG  (
    .I(\UL3/L3_CTRL_CLK1 ),
    .O(\UL3/L3_CTRL_CLK_27 )
  );
  X_INV \u0/Mcount_cnt_r_lut<0>_INV_0  (
    .I(\u0/cnt_r [0]),
    .O(\u0/Result [0])
  );
  X_INV \UL3/Mcompar__cmp_lt0004_cy<8>_inv_INV_0  (
    .I(\UL3/Mcompar__cmp_lt0004_cy [8]),
    .O(\UL3/L3_DIV_CLK_Eqn_bis_0 )
  );
  X_INV \UL3/nRESET_inv1_INV_0  (
    .I(reset_n_IBUF_14),
    .O(\UL3/nRESET_inv )
  );
  X_INV \UL3/_not00091_INV_0  (
    .I(\UL3/L3_CTRL_CLK_27 ),
    .O(\UL3/_not0009 )
  );
  X_INV \UL3/Mcompar__cmp_lt0004_cy<8>_inv_1_INV_0  (
    .I(\UL3/Mcompar__cmp_lt0004_cy [8]),
    .O(\UL3/Mcompar__cmp_lt0004_cy<8>_inv )
  );
  defparam \UL3/_mux0003<8>1 .INIT = 16'h1404;
  X_LUT4 \UL3/_mux0003<8>1  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [2]),
    .ADR2(\UL3/LUT_INDEX [1]),
    .ADR3(\UL3/LUT_INDEX [0]),
    .O(N666)
  );
  X_MUX2 \UL3/_mux0003<8>_f5  (
    .IA(N666),
    .IB(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/LUT_INDEX [4]),
    .O(\UL3/_mux0003 [8])
  );
  defparam \UL3/Mcount_SD_COUNTER_xor<3>11 .INIT = 16'h6CCC;
  X_LUT4 \UL3/Mcount_SD_COUNTER_xor<3>11  (
    .ADR0(\UL3/SD_COUNTER [2]),
    .ADR1(\UL3/SD_COUNTER [3]),
    .ADR2(\UL3/SD_COUNTER [1]),
    .ADR3(\UL3/SD_COUNTER [0]),
    .O(N667)
  );
  X_MUX2 \UL3/Mcount_SD_COUNTER_xor<3>1_f5  (
    .IA(DAC_rdy_diag_OBUF_19),
    .IB(N667),
    .SEL(\UL3/SD_COUNTER_CTRL_24 ),
    .O(\UL3/Result [3])
  );
  defparam \UL3/_mux0007981 .INIT = 16'hFF5D;
  X_LUT4 \UL3/_mux0007981  (
    .ADR0(\UL3/SD_COUNTER [0]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [2]),
    .ADR3(\UL3/SD_COUNTER [3]),
    .O(N668)
  );
  X_MUX2 \UL3/_mux000798_f5  (
    .IA(N668),
    .IB(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/SD_COUNTER [5]),
    .O(\UL3/_mux0007_map60 )
  );
  defparam \UL3/_mux0005161 .INIT = 16'hFEBA;
  X_LUT4 \UL3/_mux0005161  (
    .ADR0(\UL3/SD_COUNTER [3]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [2]),
    .ADR3(\UL3/SD_COUNTER [0]),
    .O(N669)
  );
  defparam \UL3/_mux0005162 .INIT = 8'hFE;
  X_LUT3 \UL3/_mux0005162  (
    .ADR0(\UL3/SD_COUNTER [3]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [2]),
    .O(N670)
  );
  X_MUX2 \UL3/_mux000516_f5  (
    .IA(N670),
    .IB(N669),
    .SEL(\UL3/SD_COUNTER [4]),
    .O(\UL3/_mux0005_map75 )
  );
  defparam \UL3/_mux0005491 .INIT = 16'hFFEA;
  X_LUT4 \UL3/_mux0005491  (
    .ADR0(\UL3/LUT_INDEX [3]),
    .ADR1(\UL3/LUT_INDEX [1]),
    .ADR2(\UL3/LUT_INDEX [2]),
    .ADR3(\UL3/LUT_INDEX [4]),
    .O(N671)
  );
  X_MUX2 \UL3/_mux000549_f5  (
    .IA(N671),
    .IB(ethernet_cs_n_OBUF_17),
    .SEL(\UL3/SD_COUNTER [0]),
    .O(\UL3/_mux0005_map85 )
  );
  defparam \UL3/_mux00084141 .INIT = 16'h0F02;
  X_LUT4 \UL3/_mux00084141  (
    .ADR0(\UL3/SD_DATA [2]),
    .ADR1(\UL3/SD_COUNTER_2_1_43 ),
    .ADR2(\UL3/SD_COUNTER_3_2_48 ),
    .ADR3(\UL3/SD_COUNTER_1_1_46 ),
    .O(N673)
  );
  defparam \UL3/_mux00084142 .INIT = 16'h0100;
  X_LUT4 \UL3/_mux00084142  (
    .ADR0(\UL3/SD_COUNTER_1_1_46 ),
    .ADR1(\UL3/SD_COUNTER_2_1_43 ),
    .ADR2(\UL3/SD_COUNTER_3_2_48 ),
    .ADR3(\UL3/SD_DATA [2]),
    .O(N674)
  );
  X_MUX2 \UL3/_mux0008414_f5  (
    .IA(N674),
    .IB(N673),
    .SEL(\UL3/SD_DATA [4]),
    .O(\UL3/_mux0008_map198 )
  );
  defparam \UL3/_cmp_lt000111 .INIT = 16'h0103;
  X_LUT4 \UL3/_cmp_lt000111  (
    .ADR0(\UL3/LUT_INDEX [1]),
    .ADR1(\UL3/LUT_INDEX [3]),
    .ADR2(\UL3/LUT_INDEX [2]),
    .ADR3(\UL3/LUT_INDEX [0]),
    .O(N676)
  );
  X_MUX2 \UL3/_cmp_lt00011_f5  (
    .IA(N676),
    .IB(DAC_rdy_diag_OBUF_19),
    .SEL(\UL3/LUT_INDEX [4]),
    .O(\UL3/_cmp_lt0001 )
  );
  defparam clk_0.LOC = "N22";
  X_IPAD clk_0 (
    .PAD(clk)
  );
  defparam reset_n_1.LOC = "AH19";
  X_IPAD reset_n_1 (
    .PAD(reset_n)
  );
  defparam sdto_2.LOC = "M20";
  X_IPAD sdto_2 (
    .PAD(sdto)
  );
  X_OPAD L3_SDAT_3 (
    .PAD(L3_SDAT)
  );
  X_OPAD L3_SCLK_4 (
    .PAD(L3_SCLK)
  );
  defparam sdti_5.LOC = "L19";
  X_OPAD sdti_5 (
    .PAD(sdti)
  );
  X_OPAD ethernet_cs_n_6 (
    .PAD(ethernet_cs_n)
  );
  X_OPAD L3_MODE_7 (
    .PAD(L3_MODE)
  );
  X_OPAD ADC_rdy_diag_8 (
    .PAD(ADC_rdy_diag)
  );
  X_OPAD DAC_rdy_diag_9 (
    .PAD(DAC_rdy_diag)
  );
  defparam sclk_10.LOC = "K21";
  X_OPAD sclk_10 (
    .PAD(sclk)
  );
  defparam mclk_11.LOC = "N20";
  X_OPAD mclk_11 (
    .PAD(mclk)
  );
  defparam lrck_12.LOC = "P21";
  X_OPAD lrck_12 (
    .PAD(lrck)
  );
  X_BUF \u0/Madd_left_chan_cnt_Mxor_Result<5>_Result1/LUT3_D_BUF  (
    .I(left_chan),
    .O(N678)
  );
  defparam \u0/Madd_left_chan_cnt_Mxor_Result<5>_Result1 .INIT = 8'h6A;
  X_LUT3 \u0/Madd_left_chan_cnt_Mxor_Result<5>_Result1  (
    .ADR0(\u0/cnt_r [9]),
    .ADR1(\u0/cnt_r [8]),
    .ADR2(\u0/cnt_r [7]),
    .O(left_chan)
  );
  X_BUF \u0/_mux0000<18>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<18>_SW0/O ),
    .O(N21)
  );
  defparam \u0/_mux0000<18>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<18>_SW0  (
    .ADR0(right_ADC[18]),
    .ADR1(left_chan),
    .ADR2(left_ADC[18]),
    .O(\u0/_mux0000<18>_SW0/O )
  );
  X_BUF \u0/_mux0000<17>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<17>_SW0/O ),
    .O(N23)
  );
  defparam \u0/_mux0000<17>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<17>_SW0  (
    .ADR0(right_ADC[17]),
    .ADR1(left_chan),
    .ADR2(left_ADC[17]),
    .O(\u0/_mux0000<17>_SW0/O )
  );
  X_BUF \u0/_mux0000<19>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<19>_SW0/O ),
    .O(N25)
  );
  defparam \u0/_mux0000<19>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<19>_SW0  (
    .ADR0(right_ADC[19]),
    .ADR1(left_chan),
    .ADR2(left_ADC[19]),
    .O(\u0/_mux0000<19>_SW0/O )
  );
  X_BUF \u0/_mux0000<15>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<15>_SW0/O ),
    .O(N27)
  );
  defparam \u0/_mux0000<15>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<15>_SW0  (
    .ADR0(right_ADC[15]),
    .ADR1(left_chan),
    .ADR2(left_ADC[15]),
    .O(\u0/_mux0000<15>_SW0/O )
  );
  X_BUF \u0/_mux0000<16>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<16>_SW0/O ),
    .O(N29)
  );
  defparam \u0/_mux0000<16>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<16>_SW0  (
    .ADR0(right_ADC[16]),
    .ADR1(left_chan),
    .ADR2(left_ADC[16]),
    .O(\u0/_mux0000<16>_SW0/O )
  );
  X_BUF \u0/_mux0000<14>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<14>_SW0/O ),
    .O(N31)
  );
  defparam \u0/_mux0000<14>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<14>_SW0  (
    .ADR0(right_ADC[14]),
    .ADR1(left_chan),
    .ADR2(left_ADC[14]),
    .O(\u0/_mux0000<14>_SW0/O )
  );
  X_BUF \u0/_mux0000<12>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<12>_SW0/O ),
    .O(N33)
  );
  defparam \u0/_mux0000<12>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<12>_SW0  (
    .ADR0(right_ADC[12]),
    .ADR1(left_chan),
    .ADR2(left_ADC[12]),
    .O(\u0/_mux0000<12>_SW0/O )
  );
  X_BUF \u0/_mux0000<13>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<13>_SW0/O ),
    .O(N35)
  );
  defparam \u0/_mux0000<13>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<13>_SW0  (
    .ADR0(right_ADC[13]),
    .ADR1(left_chan),
    .ADR2(left_ADC[13]),
    .O(\u0/_mux0000<13>_SW0/O )
  );
  X_BUF \u0/_mux0000<10>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<10>_SW0/O ),
    .O(N37)
  );
  defparam \u0/_mux0000<10>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<10>_SW0  (
    .ADR0(right_ADC[10]),
    .ADR1(left_chan),
    .ADR2(left_ADC[10]),
    .O(\u0/_mux0000<10>_SW0/O )
  );
  X_BUF \u0/_mux0000<9>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<9>_SW0/O ),
    .O(N39)
  );
  defparam \u0/_mux0000<9>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<9>_SW0  (
    .ADR0(right_ADC[9]),
    .ADR1(left_chan),
    .ADR2(left_ADC[9]),
    .O(\u0/_mux0000<9>_SW0/O )
  );
  X_BUF \u0/_mux0000<11>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<11>_SW0/O ),
    .O(N41)
  );
  defparam \u0/_mux0000<11>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<11>_SW0  (
    .ADR0(right_ADC[11]),
    .ADR1(left_chan),
    .ADR2(left_ADC[11]),
    .O(\u0/_mux0000<11>_SW0/O )
  );
  X_BUF \u0/_mux0000<7>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<7>_SW0/O ),
    .O(N43)
  );
  defparam \u0/_mux0000<7>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<7>_SW0  (
    .ADR0(right_ADC[7]),
    .ADR1(left_chan),
    .ADR2(left_ADC[7]),
    .O(\u0/_mux0000<7>_SW0/O )
  );
  X_BUF \u0/_mux0000<6>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<6>_SW0/O ),
    .O(N45)
  );
  defparam \u0/_mux0000<6>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<6>_SW0  (
    .ADR0(right_ADC[6]),
    .ADR1(left_chan),
    .ADR2(left_ADC[6]),
    .O(\u0/_mux0000<6>_SW0/O )
  );
  X_BUF \u0/_mux0000<8>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<8>_SW0/O ),
    .O(N47)
  );
  defparam \u0/_mux0000<8>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<8>_SW0  (
    .ADR0(right_ADC[8]),
    .ADR1(left_chan),
    .ADR2(left_ADC[8]),
    .O(\u0/_mux0000<8>_SW0/O )
  );
  X_BUF \u0/_mux0000<4>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<4>_SW0/O ),
    .O(N49)
  );
  defparam \u0/_mux0000<4>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<4>_SW0  (
    .ADR0(right_ADC[4]),
    .ADR1(left_chan),
    .ADR2(left_ADC[4]),
    .O(\u0/_mux0000<4>_SW0/O )
  );
  X_BUF \u0/_mux0000<5>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<5>_SW0/O ),
    .O(N51)
  );
  defparam \u0/_mux0000<5>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<5>_SW0  (
    .ADR0(right_ADC[5]),
    .ADR1(left_chan),
    .ADR2(left_ADC[5]),
    .O(\u0/_mux0000<5>_SW0/O )
  );
  X_BUF \u0/_mux0000<3>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<3>_SW0/O ),
    .O(N53)
  );
  defparam \u0/_mux0000<3>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<3>_SW0  (
    .ADR0(right_ADC[3]),
    .ADR1(left_chan),
    .ADR2(left_ADC[3]),
    .O(\u0/_mux0000<3>_SW0/O )
  );
  X_BUF \u0/_mux0000<1>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<1>_SW0/O ),
    .O(N55)
  );
  defparam \u0/_mux0000<1>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<1>_SW0  (
    .ADR0(right_ADC[1]),
    .ADR1(left_chan),
    .ADR2(left_ADC[1]),
    .O(\u0/_mux0000<1>_SW0/O )
  );
  X_BUF \u0/_mux0000<2>_SW0/LUT3_L_BUF  (
    .I(\u0/_mux0000<2>_SW0/O ),
    .O(N57)
  );
  defparam \u0/_mux0000<2>_SW0 .INIT = 8'hE2;
  X_LUT3 \u0/_mux0000<2>_SW0  (
    .ADR0(right_ADC[2]),
    .ADR1(left_chan),
    .ADR2(left_ADC[2]),
    .O(\u0/_mux0000<2>_SW0/O )
  );
  X_BUF \UL3/_mux0006123/LUT4_L_BUF  (
    .I(\UL3/_mux0006123/O ),
    .O(\UL3/_mux0006_map33 )
  );
  defparam \UL3/_mux0006123 .INIT = 16'hCCC8;
  X_LUT4 \UL3/_mux0006123  (
    .ADR0(\UL3/_mux0006_map16 ),
    .ADR1(\UL3/L3_CK_26 ),
    .ADR2(\UL3/_mux0006_map21 ),
    .ADR3(\UL3/_mux0006_map31 ),
    .O(\UL3/_mux0006123/O )
  );
  X_BUF \UL3/_mux000561/LUT4_L_BUF  (
    .I(\UL3/_mux000561/O ),
    .O(\UL3/_mux0005_map88 )
  );
  defparam \UL3/_mux000561 .INIT = 16'hFFAE;
  X_LUT4 \UL3/_mux000561  (
    .ADR0(\UL3/_mux0005_map75 ),
    .ADR1(\UL3/_mux0005_map85 ),
    .ADR2(\UL3/SD_COUNTER [5]),
    .ADR3(\UL3/_mux0005_map80 ),
    .O(\UL3/_mux000561/O )
  );
  X_BUF \u0/_cmp_eq000011/LUT3_D_BUF  (
    .I(\u0/N21 ),
    .O(N679)
  );
  defparam \u0/_cmp_eq000011 .INIT = 8'h80;
  X_LUT3 \u0/_cmp_eq000011  (
    .ADR0(\u0/cnt_r [1]),
    .ADR1(\u0/cnt_r [2]),
    .ADR2(\u0/cnt_r [0]),
    .O(\u0/N21 )
  );
  X_BUF \u0/_and0002_SW0/LUT4_L_BUF  (
    .I(\u0/_and0002_SW0/O ),
    .O(N305)
  );
  defparam \u0/_and0002_SW0 .INIT = 16'hFEFF;
  X_LUT4 \u0/_and0002_SW0  (
    .ADR0(\u0/cnt_r [5]),
    .ADR1(\u0/cnt_r [4]),
    .ADR2(\u0/cnt_r [3]),
    .ADR3(\u0/N21 ),
    .O(\u0/_and0002_SW0/O )
  );
  X_BUF \UL3/_mux0008411/LUT4_D_BUF  (
    .I(\UL3/N131 ),
    .O(N680)
  );
  defparam \UL3/_mux0008411 .INIT = 16'hFFFE;
  X_LUT4 \UL3/_mux0008411  (
    .ADR0(\UL3/SD_COUNTER [4]),
    .ADR1(\UL3/SD_COUNTER [1]),
    .ADR2(\UL3/SD_COUNTER [3]),
    .ADR3(\UL3/SD_COUNTER [2]),
    .O(\UL3/N131 )
  );
  X_BUF \UL3/_or0000/LUT4_D_BUF  (
    .I(\UL3/_or0000_25 ),
    .O(N681)
  );
  defparam \UL3/_or0000 .INIT = 16'h0189;
  X_LUT4 \UL3/_or0000  (
    .ADR0(\UL3/SD_COUNTER [5]),
    .ADR1(\UL3/SD_COUNTER [0]),
    .ADR2(N314),
    .ADR3(\UL3/N131 ),
    .O(\UL3/_or0000_25 )
  );
  X_BUF \UL3/_mux0008131/LUT3_D_BUF  (
    .I(\UL3/N141 ),
    .O(N682)
  );
  defparam \UL3/_mux0008131 .INIT = 8'h7F;
  X_LUT3 \UL3/_mux0008131  (
    .ADR0(\UL3/SD_COUNTER_1_1_46 ),
    .ADR1(\UL3/SD_COUNTER_0_1_45 ),
    .ADR2(\UL3/SD_COUNTER_2_2_47 ),
    .O(\UL3/N141 )
  );
  X_BUF \UL3/_mux0008170/LUT4_L_BUF  (
    .I(\UL3/_mux0008170/O ),
    .O(\UL3/_mux0008_map137 )
  );
  defparam \UL3/_mux0008170 .INIT = 16'hC0EA;
  X_LUT4 \UL3/_mux0008170  (
    .ADR0(\UL3/SD_DATA [8]),
    .ADR1(\UL3/SD_DATA [0]),
    .ADR2(\UL3/SD_COUNTER_3_2_48 ),
    .ADR3(\UL3/SD_COUNTER_2_2_47 ),
    .O(\UL3/_mux0008170/O )
  );
  X_BUF \UL3/_mux0008302/LUT4_L_BUF  (
    .I(\UL3/_mux0008302/O ),
    .O(\UL3/_mux0008_map171 )
  );
  defparam \UL3/_mux0008302 .INIT = 16'hCA00;
  X_LUT4 \UL3/_mux0008302  (
    .ADR0(\UL3/SD_DATA [7]),
    .ADR1(\UL3/SD_DATA1 [4]),
    .ADR2(\UL3/SD_COUNTER_3_2_48 ),
    .ADR3(\UL3/SD_COUNTER_2_2_47 ),
    .O(\UL3/_mux0008302/O )
  );
  X_BUF \UL3/_mux0008476/LUT4_L_BUF  (
    .I(\UL3/_mux0008476/O ),
    .O(\UL3/_mux0008_map204 )
  );
  defparam \UL3/_mux0008476 .INIT = 16'hFEFC;
  X_LUT4 \UL3/_mux0008476  (
    .ADR0(\UL3/SD_COUNTER [4]),
    .ADR1(\UL3/_mux0008_map154 ),
    .ADR2(\UL3/_mux0008_map145 ),
    .ADR3(\UL3/_mux0008_map202 ),
    .O(\UL3/_mux0008476/O )
  );
  X_BUF \UL3/_mux000810/LUT4_L_BUF  (
    .I(\UL3/_mux000810/O ),
    .O(\UL3/_mux0008_map101 )
  );
  defparam \UL3/_mux000810 .INIT = 16'hF111;
  X_LUT4 \UL3/_mux000810  (
    .ADR0(\UL3/N131 ),
    .ADR1(N629),
    .ADR2(\UL3/LUT_INDEX [4]),
    .ADR3(\UL3/N2 ),
    .O(\UL3/_mux000810/O )
  );
  X_BUF \UL3/_and0000_SW1/LUT3_L_BUF  (
    .I(\UL3/_and0000_SW1/O ),
    .O(N633)
  );
  defparam \UL3/_and0000_SW1 .INIT = 8'hFB;
  X_LUT3 \UL3/_and0000_SW1  (
    .ADR0(\UL3/SD_COUNTER [5]),
    .ADR1(reset_n_IBUF_14),
    .ADR2(\UL3/SD_COUNTER [0]),
    .O(\UL3/_and0000_SW1/O )
  );
  X_BUF \UL3/_and0001_SW1/LUT4_L_BUF  (
    .I(\UL3/_and0001_SW1/O ),
    .O(N635)
  );
  defparam \UL3/_and0001_SW1 .INIT = 16'hFFBF;
  X_LUT4 \UL3/_and0001_SW1  (
    .ADR0(\UL3/SD_COUNTER [5]),
    .ADR1(\UL3/SD_COUNTER [4]),
    .ADR2(reset_n_IBUF_14),
    .ADR3(\UL3/SD_COUNTER [3]),
    .O(\UL3/_and0001_SW1/O )
  );
  X_BUF \u0/_not0001_SW1/LUT4_L_BUF  (
    .I(\u0/_not0001_SW1/O ),
    .O(N641)
  );
  defparam \u0/_not0001_SW1 .INIT = 16'hC444;
  X_LUT4 \u0/_not0001_SW1  (
    .ADR0(N153),
    .ADR1(\u0/cnt_r [7]),
    .ADR2(\u0/cnt_r [6]),
    .ADR3(\u0/cnt_r [3]),
    .O(\u0/_not0001_SW1/O )
  );
  X_BUF \UL3/_not0007_SW1/LUT4_L_BUF  (
    .I(\UL3/_not0007_SW1/O ),
    .O(N643)
  );
  defparam \UL3/_not0007_SW1 .INIT = 16'h8000;
  X_LUT4 \UL3/_not0007_SW1  (
    .ADR0(\UL3/SD_COUNTER [0]),
    .ADR1(\UL3/SD_COUNTER [4]),
    .ADR2(\UL3/SD_COUNTER [5]),
    .ADR3(\UL3/SD_COUNTER_CTRL_24 ),
    .O(\UL3/_not0007_SW1/O )
  );
  X_BUF \u0/_and0000_SW1/LUT4_L_BUF  (
    .I(\u0/_and0000_SW1/O ),
    .O(N645)
  );
  defparam \u0/_and0000_SW1 .INIT = 16'hFCF8;
  X_LUT4 \u0/_and0000_SW1  (
    .ADR0(\u0/cnt_r [6]),
    .ADR1(\u0/cnt_r [8]),
    .ADR2(\u0/cnt_r [3]),
    .ADR3(\u0/cnt_r [7]),
    .O(\u0/_and0000_SW1/O )
  );
  X_BUF \UL3/_mux0008160/LUT2_L_BUF  (
    .I(\UL3/_mux0008160/O ),
    .O(\UL3/_mux0008_map133 )
  );
  defparam \UL3/_mux0008160 .INIT = 4'h8;
  X_LUT2 \UL3/_mux0008160  (
    .ADR0(\UL3/SD_COUNTER [0]),
    .ADR1(N649),
    .O(\UL3/_mux0008160/O )
  );
  X_BUF \UL3/_mux0008453_SW0/LUT4_L_BUF  (
    .I(\UL3/_mux0008453_SW0/O ),
    .O(N653)
  );
  defparam \UL3/_mux0008453_SW0 .INIT = 16'hFFA8;
  X_LUT4 \UL3/_mux0008453_SW0  (
    .ADR0(\UL3/SD_COUNTER [2]),
    .ADR1(\UL3/_mux0008_map185 ),
    .ADR2(\UL3/_mux0008_map188 ),
    .ADR3(\UL3/_mux0008_map198 ),
    .O(\UL3/_mux0008453_SW0/O )
  );
  X_BUF \UL3/_mux0007140_SW0/LUT4_L_BUF  (
    .I(\UL3/_mux0007140_SW0/O ),
    .O(N637)
  );
  defparam \UL3/_mux0007140_SW0 .INIT = 16'hFF08;
  X_LUT4 \UL3/_mux0007140_SW0  (
    .ADR0(\UL3/_mux0007_map49 ),
    .ADR1(\UL3/SD_COUNTER [3]),
    .ADR2(\UL3/SD_COUNTER [5]),
    .ADR3(\UL3/N8 ),
    .O(\UL3/_mux0007140_SW0/O )
  );
  X_CKBUF \clk_BUFGP/BUFG  (
    .I(\clk_BUFGP/IBUFG_49 ),
    .O(clk_BUFGP)
  );
  X_CKBUF \clk_BUFGP/IBUFG  (
    .I(clk),
    .O(\clk_BUFGP/IBUFG_49 )
  );
  X_OBUF L3_SDAT_OBUF (
    .I(\UL3/SDO_13 ),
    .O(L3_SDAT)
  );
  X_OBUF L3_SCLK_OBUF (
    .I(L3_SCLK_OBUF_15),
    .O(L3_SCLK)
  );
  X_OBUF sdti_OBUF (
    .I(\u0/DAC_r [19]),
    .O(sdti)
  );
  X_OBUF ethernet_cs_n_OBUF (
    .I(ethernet_cs_n_OBUF_17),
    .O(ethernet_cs_n)
  );
  X_OBUF L3_MODE_OBUF (
    .I(\UL3/L3_EN_18 ),
    .O(L3_MODE)
  );
  X_OBUF ADC_rdy_diag_OBUF (
    .I(DAC_rdy_diag_OBUF_19),
    .O(ADC_rdy_diag)
  );
  X_OBUF DAC_rdy_diag_OBUF (
    .I(DAC_rdy_diag_OBUF_19),
    .O(DAC_rdy_diag)
  );
  X_OBUF sclk_OBUF (
    .I(\u0/cnt_r [3]),
    .O(sclk)
  );
  X_OBUF mclk_OBUF (
    .I(\u0/cnt_r [1]),
    .O(mclk)
  );
  X_OBUF lrck_OBUF (
    .I(\u0/cnt_r [9]),
    .O(lrck)
  );
  X_ZERO NlwBlock_audio_GND (
    .O(GND)
  );
  X_ONE NlwBlock_audio_VCC (
    .O(VCC)
  );
endmodule


`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

    wire GSR;
    wire GTS;
    wire PRLD;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

