// Verilog file generated from Magma Bedrock database
// Fri Jul  1 17:08:27 2005
// Bedrock Root: Magma_root

// Entity:rc8051RtlTop Model:rc8051RtlTop Library:L0
module rc8051RtlTop (scan_en, test_mode, clk, rst_p, int0_i, int1_i, all_t0_i, 
     all_t1_i, all_rxd_i, all_txd_o, clkb, rom_adr_o, rom_data_i, addr_xdat, 
     out_xdat, in_xdat_a, en_xdat, wr_xdat_d1, rd_xdat, p1_io, BistMode, 
     BistFail, Finish, ErrMap);
  input scan_en, test_mode, clk, rst_p, int0_i, int1_i, all_t0_i, all_t1_i, 
     all_rxd_i, BistMode;
  output all_txd_o, clkb, en_xdat, wr_xdat_d1, rd_xdat, BistFail, Finish, 
     ErrMap;
  input [7:0] rom_data_i;
  input [7:0] in_xdat_a;
  output [15:0] rom_adr_o;
  output [15:0] addr_xdat;
  output [7:0] out_xdat;
  inout [7:0] p1_io;
  wire \xaddr_low[0] , \xaddr_low[1] , \xaddr_low[2] , \xaddr_low[3] , 
     \xaddr_low[4] , \xaddr_low[5] , \xaddr_low[6] , \xaddr_low[7] , 
     \xaddr_high[0] , \xaddr_high[1] , \xaddr_high[2] , \xaddr_high[3] , 
     \xaddr_high[4] , \xaddr_high[5] , \xaddr_high[6] , \xaddr_high[7] , 
     \p1_o[0] , \p1_o[1] , \p1_o[2] , \p1_o[3] , \p1_o[4] , \p1_o[5] , 
     \p1_o[6] , \p1_o[7] , \in_idat_a[0] , \in_idat_a[1] , \in_idat_a[2] , 
     \in_idat_a[3] , \in_idat_a[4] , \in_idat_a[5] , \in_idat_a[6] , 
     \in_idat_a[7] , \addr_a[0] , \addr_a[1] , \addr_a[2] , \addr_a[3] , 
     \addr_a[4] , \addr_a[5] , \addr_a[6] , \addr_a[7] , \out_idat[0] , 
     \out_idat[1] , \out_idat[2] , \out_idat[3] , \out_idat[4] , \out_idat[5] , 
     \out_idat[6] , \out_idat[7] , N0, N1, N2, N3, N4, N5, N6, N7, clk0, n82, 
     n83, n84, n85, n86, clkb0, n104, n105, n106, n107, n108, n109, n110, n111, 
     n136, n137, n138, n139, n140, n141, n142, n143, n147, n148, n149, n150, 
     n151, n152, n153, n154, n155, ale_d1, ale, wr_xdat, wr_idat, rd_idat, 
     idat_en, n406, n407, n408, n409, n410, n411, n412, n413, n414, n415, n416, 
     n417, n418, n419, n420, n421, n422, n423, n424, n425, n426, n427, n428, 
     n429, n430, n431, n432, n433, n434, n435, n436, n437, n438, n439, n440, 
     n441, n442, n443, n444, n445, n446, n447, n449, n450, n451, n452, n237, 
     n238, n239, n240, n241, n242, n243, n244, n5, n7, n8, n10, n12, n14, n16, 
     n18, n20, n22, n24, n26, n28, n30, n32, n34, n52, n53, n54, N7839, N7846, 
     N7845, N7868, N10034, N11943, N7959, N7870, N12354, N7953, N7869, N11442, 
     N7867, N10469, N7956, N7958, N10201, N7957, N8369, N10468, N7871, N7962, 
     N7886, N7902, N10868, N10867, N9923, N9783, N9796, N9763, N9785, N9780, 
     N9742, N11028, N11027, N7066, N4072, N1950, N10453, N2036, N11548, N3243, 
     N12269, n438_1, n448_1, n448_2, N7886_1, N7962_1, N7902_1, n432_1, n3_2, 
     ale_d1_1, n52_1, n440_1, n441_1, n442_1, n446_1, n3_3, n3_4, n3_5, n3_6, 
     n432_2, ale_d1_2, n440_2, n441_2, n442_2, n446_2, rst_p0_2, n3, rst_p0, 
     clkb0_1, clk0_1, clk0_2, clk0_3, clk0_4, clk0_5, clk0_6, clk0_7, clk0_8, 
     clk0_9, clk0_10, clk0_11, clk0_12, clk0_13, clk0_14, clk0_15, clk0_16, 
     clk0_17, clk0_18, clk0_19, clk0_20, clk0_21, clk0_22, clk0_23, clk0_24, 
     clkb0_2, clkb0_3, clk0_25, clk0_26, clk0_27, n52_2, n52_3, n52_4, n52_5, 
     n3_1, n3_7, n3_8, n3_9;
  supply1 VDD;
  supply0 VSS;
  AND2X1 U173_C1 (.A(wr_idat), .B(rd_idat), .Y(idat_en));
  CLKINVX20 clk0_L0_1 (.A(clk0_10), .Y(clk0_4));
  SDFFRHQX1 addr_xdat_reg_6_ (.CK(clk0_4), .D(\xaddr_low[6] ), .Q(n432), 
     .RN(N9923), .SE(n3_5), .SI(n433));
  u_cpu_test_1 U3_cpu (.clk(), .rst_p(rst_p0_2), .in_xrom_a({n104, n105, n106, 
     n107, n108, n109, n110, n111}), .in_idat_a({\in_idat_a[7] , \in_idat_a[6] , 
     \in_idat_a[5] , \in_idat_a[4] , \in_idat_a[3] , \in_idat_a[2] , 
     \in_idat_a[1] , \in_idat_a[0] }), .in_xdat_a({n136, n137, n138, n139, n140, 
     n141, n142, n143}), .p0_in({VSS, VSS, VSS, VSS, VSS, VSS, VSS, VSS}), .p1_in({
     n147, n148, n149, n150, n151, n152, n153, n154}), .p2_in({VSS, VSS, VSS, VSS, 
     VSS, VSS, VSS, VSS}), .p3_in({VSS, VSS, VSS, VSS, VSS, VSS, VSS, VSS}), 
     .rxdi(n86), .t0_pin(n84), .t1_pin(n85), .int0_pin(n82), .int1_pin(n83), 
     .addr_xrom_a({n407, n408, n409, n410, n411, n412, n413, n414, n415, n416, 
     n417, n418, n419, n420, n421, n422}), .psen(), .addr_a({\addr_a[7] , 
     \addr_a[6] , \addr_a[5] , \addr_a[4] , \addr_a[3] , \addr_a[2] , 
     \addr_a[1] , \addr_a[0] }), .out_idat({\out_idat[7] , \out_idat[6] , 
     \out_idat[5] , \out_idat[4] , \out_idat[3] , \out_idat[2] , \out_idat[1] , 
     \out_idat[0] }), .wr_idat(wr_idat), .rd_idat(rd_idat), .xaddr_high({
     \xaddr_high[7] , \xaddr_high[6] , \xaddr_high[5] , \xaddr_high[4] , 
     \xaddr_high[3] , \xaddr_high[2] , \xaddr_high[1] , \xaddr_high[0] }), 
     .out_xdat({n439, n440, n441, n442, n443, n444, n445, n446}), .ale(ale), 
     .p0_out(), .p1_out({\p1_o[7] , \p1_o[6] , \p1_o[5] , \p1_o[4] , \p1_o[3] , 
     \p1_o[2] , \p1_o[1] , \p1_o[0] }), .p2_out(), .p3_out(), .p0_en(), .p1_en({
     N7, N6, N5, N4, N3, N2, N1, N0}), .p2_en(), .p3_en(), .wr_xdat(wr_xdat), 
     .rd_xdat(n449), .rxdo(), .txdo(n406), .xdat_en(), .sel_code_xdat(), 
     .rc8051RtlTop_test_mode_in(n52_1), 
     .rc8051RtlTop_rc8051RtlTop_test_ds_1_in(n53), 
     .rc8051RtlTop_test_point_535_in(n54), .test_si2(n111), .test_so2(n34), 
     .test_si1(n110), .test_so1(n32), .test_si3(n109), .test_so3(n30), 
     .test_si4(n108), .test_so4(n28), .test_si5(n107), .test_so5(n26), 
     .test_si6(n106), .test_so6(n24), .test_si7(n105), .test_so7(n22), 
     .test_si8(n104), .test_so8(n20), .test_si9(n143), .test_so9(n18), 
     .test_si10(n142), .test_so10(n16), .test_si11(n141), .test_so11(n14), 
     .test_si12(n140), .test_so12(n12), .test_si13(n139), .test_so13(n10), 
     .test_si14(n138), .test_so14(n8), .test_si15(n137), .test_so15(n7), 
     .test_se(n3_6), .clk0_26(clk0_26), .clk0_9(clk0_3), .clk0_21(clk0_21), 
     .clk0_11(clk0_6), .clk0_8(clk0_2), .clk0_14(clk0_14), .clk0_10(clk0_4), 
     .clk0_17(clk0_17));
  PADIZ40 PRB_81 ();
  SDFFRHQX4 addr_xdat_reg_13_ (.CK(clk0_14), .D(\xaddr_high[5] ), .Q(n425), 
     .RN(N9923), .SE(n3_5), .SI(n426));
  CLKBUFX20 CLK_SYNC_SKEW_11 (.A(clk0_19), .Y(clk0_20));
  CLKBUFX16 CLK_SYNC_SKEW_10 (.A(clk0_18), .Y(clk0_19));
  PDIDGZ PI_in_xdat_a_5 (.C(n138), .PAD(in_xdat_a[5]));
  PVSS3DGZ VSS9 (.VSS(VSS));
  PDO04CDG PO_BistFail (.I(n450), .PAD(BistFail));
  PADOZ40 PRB_46 ();
  PADOZ40 PRB_67 ();
  PDB04SDGZ PB_p1_io_7 (.C(n147), .I(\p1_o[7] ), .OEN(N7957), .PAD(p1_io[7]));
  PVSS3DGZ VSS7 (.VSS(VSS));
  PDB04SDGZ PB_p1_io_4 (.C(n150), .I(\p1_o[4] ), .OEN(N7871), .PAD(p1_io[4]));
  NOR2BX2 U4_C2 (.AN(N7), .B(n3), .Y(N7957));
  PDB04SDGZ PB_p1_io_0 (.C(n154), .I(\p1_o[0] ), .OEN(N10868), .PAD(p1_io[0]));
  PVDD2DGZ VD33_4 ();
  NAND2BX1 U9_C2_1 (.AN(n3), .B(N2), .Y(N7886));
  NAND2BX1 U10_C2_1 (.AN(n3), .B(N1), .Y(N7902));
  PADOZ40 PRB_88 ();
  PADOZ40 PRB_92 ();
  PADIZ40 PRB_89 ();
  PADOZ40 PRB_86 ();
  PADIZ40 PRB_85 ();
  DLY3X1 BH1_BUF4 (.A(n52), .Y(n52_5));
  CLKINVX16 U184_C1_1 (.A(clk0_24), .Y(clkb0_1));
  BUFX3 BH1_BUF5 (.A(n3_7), .Y(n3));
  PDIDGZ PI_all_rxd_i (.C(n86), .PAD(all_rxd_i));
  PVDD1DGZ VDD5 (.VDD(VDD));
  CLKBUFX16 CLK_SYNC_SKEW_3 (.A(clk0_9), .Y(clk0_12));
  CLKBUFX20 CLK_SYNC_SKEW_2 (.A(clk0_10), .Y(clk0_11));
  PDIDGZ PI_clk (.C(clk0), .PAD(clk));
  PADOZ40 PRB_65 ();
  PADIZ40 PRB_62 ();
  PADOZ40 PRB_13 ();
  PDO04CDG PO_addr_xdat_6 (.I(n432_2), .PAD(addr_xdat[6]));
  PDO04CDG PO_addr_xdat_4 (.I(n434), .PAD(addr_xdat[4]));
  PADOZ40 PRB_76 ();
  PADIZ40 PRB_22 ();
  PDO04CDG PO_addr_xdat_0 (.I(n438_1), .PAD(addr_xdat[0]));
  PADOZ40 PRB_23 ();
  SDFFRHQX4 addr_xdat_reg_10_ (.CK(clk0_14), .D(\xaddr_high[2] ), .Q(n428), 
     .RN(N9923), .SE(n3_5), .SI(n429));
  BUFX3 BW2_BUF6493 (.A(rst_p0), .Y(rst_p0_2));
  INVX8 U185_C1 (.A(n54), .Y(N9923));
  SDFFSRX1 xaddr_low_reg_0_ (.CK(clk0_26), .D(N9783), .Q(\xaddr_low[0] ), 
     .QN(n237), .RN(N9923), .SE(n3_4), .SI(n448_2), .SN(VDD));
  CLKBUFX16 CLK_SYNC_SKEW_15 (.A(clk0_7), .Y(clk0_24));
  PADIZ40 PRB_4 ();
  PDIDGZ PI_rom_data_i_2 (.C(n109), .PAD(rom_data_i[2]));
  PADIZ40 PRB_25 ();
  PADIZ40 PRB ();
  CLKBUFX16 CLK_SYNC_SKEW_7 (.A(clk0_5), .Y(clk0_16));
  CLKINVX16 clk0_L0 (.A(clk0_9), .Y(clk0_5));
  CLKBUFX16 CLK_SYNC_SKEW_6 (.A(clk0_13), .Y(clk0_15));
  SDFFRHQX4 addr_xdat_reg_11_ (.CK(clk0_14), .D(\xaddr_high[3] ), .Q(n427), 
     .RN(N9923), .SE(n3_5), .SI(n428));
  SDFFRHQX4 addr_xdat_reg_4_ (.CK(clk0_4), .D(\xaddr_low[4] ), .Q(n434), 
     .RN(N9923), .SE(n3_5), .SI(n435));
  PADIZ40 PRB_8 ();
  PDO04CDG PO_out_xdat_4 (.I(n442_2), .PAD(out_xdat[4]));
  PADOZ40 PRB_11 ();
  PDO04CDG PO_rom_adr_o_2 (.I(N7956), .PAD(rom_adr_o[2]));
  MX2X4 U12_C4_1 (.A(n407), .B(\xaddr_low[7] ), .S0(n3_6), .Y(N7846));
  PDO04CDG PO_rom_adr_o_3 (.I(N10469), .PAD(rom_adr_o[3]));
  PDO04CDG PO_en_xdat (.I(n447), .PAD(en_xdat));
  SDFFSRX1 xaddr_low_reg_1_ (.CK(clk0_4), .D(N9796), .Q(\xaddr_low[1] ), 
     .QN(n238), .RN(N9923), .SE(n3_4), .SI(\xaddr_low[0] ), .SN(VDD));
  SDFFSRX1 xaddr_low_reg_2_ (.CK(clk0_4), .D(N9763), .Q(\xaddr_low[2] ), 
     .QN(n239), .RN(N9923), .SE(n3_5), .SI(\xaddr_low[1] ), .SN(VDD));
  SDFFRHQX4 addr_xdat_reg_1_ (.CK(clk0_4), .D(\xaddr_low[1] ), .Q(n437), 
     .RN(N9923), .SE(n3_5), .SI(n438_1));
  INVX4 BW2_INV2415 (.A(n432_1), .Y(n432_2));
  OAI21X1 U175_C4_1 (.A0(n244), .A1(ale_d1_2), .B0(N4072), .Y(N10867));
  OAI21X1 U178_C4_1 (.A0(n241), .A1(ale_d1_2), .B0(N2036), .Y(N9780));
  INVX4 BW2_INV9104 (.A(ale_d1_1), .Y(ale_d1_2));
  PDO04CDG PO_addr_xdat_14 (.I(n424), .PAD(addr_xdat[14]));
  PADOZ40 PRB_48 ();
  PADIZ40 PRB_50 ();
  PDO04CDG PO_rom_adr_o_9 (.I(N7870), .PAD(rom_adr_o[9]));
  PADOZ40 PRB_42 ();
  PADOZ40 PRB_53 ();
  PADOZ40 PRB_38 ();
  MX2X2 U21_C4_1 (.A(n416), .B(n22), .S0(n3_3), .Y(N7869));
  PDO04CDG PO_rom_adr_o_7 (.I(N7953), .PAD(rom_adr_o[7]));
  CLKINVX20 clk0_L0_2 (.A(clk0_10), .Y(clk0_6));
  SDFFSX4 en_xdat_reg (.CK(clk0_6), .D(N11027), .Q(n447), .QN(), .SE(n3_2), 
     .SI(ale_d1_2), .SN(N9923));
  PADIZ40 PRB_35 ();
  BUFX8 BW2_BUF3425 (.A(n3_2), .Y(n3_6));
  PDIDGZ PI_rom_data_i_7 (.C(n104), .PAD(rom_data_i[7]));
  PADOZ40 PRB_80 ();
  SDFFSRX4 xaddr_low_reg_7_ (.CK(clk0_4), .D(N10867), .Q(\xaddr_low[7] ), 
     .QN(n244), .RN(N9923), .SE(n3_5), .SI(\xaddr_low[6] ), .SN(VDD));
  OAI21X1 U176_C4_1 (.A0(n243), .A1(ale_d1_2), .B0(N12269), .Y(N11028));
  PVSS3DGZ VSS2 (.VSS(VSS));
  PDO04CDG PO_addr_xdat_13 (.I(n425), .PAD(addr_xdat[13]));
  INVX1 BW2_INV_D11050 (.A(n446), .Y(n446_1));
  CLKBUFX20 CLK_SYNC_SKEW_20 (.A(clk0_20), .Y(clk0_25));
  PDO04CDG PO_rom_adr_o_10 (.I(N7959), .PAD(rom_adr_o[10]));
  PADIZ40 PRB_56 ();
  PADIZ40 PRB_49 ();
  PDO04CDG PO_ErrMap (.I(n452), .PAD(ErrMap));
  PADOZ40 PRB_98 ();
  PADIZ40 PRB_68 ();
  DLY3X1 BH1_BUF7 (.A(n3_9), .Y(n3_8));
  PVDD1DGZ VDD4 (.VDD(VDD));
  PDB04SDGZ PB_p1_io_5 (.C(n149), .I(\p1_o[5] ), .OEN(N10468), .PAD(p1_io[5]));
  PDIDGZ PI_in_xdat_a_2 (.C(n141), .PAD(in_xdat_a[2]));
  PDB04SDGZ PB_p1_io_1 (.C(n153), .I(\p1_o[1] ), .OEN(N7902_1), .PAD(p1_io[1]));
  PADOZ40 PRB_73 ();
  NOR2BX2 U11_C2 (.AN(N0), .B(n3), .Y(N10868));
  INVX2 BW1_INV7902 (.A(N7902), .Y(N7902_1));
  NOR2BX2 U6_C2 (.AN(N5), .B(n3), .Y(N10468));
  PADIZ40 PRB_95 ();
  PADIZ40 PRB_91 ();
  BUFX4 BW1_BUF288 (.A(n52_2), .Y(n52_1));
  PDIDGZ PI_in_xdat_a_6 (.C(n137), .PAD(in_xdat_a[6]));
  DLY3X1 BH1_BUF1 (.A(n52_3), .Y(n52_2));
  CLKBUFX20 CLK_SYNC_SKEW_17 (.A(clkb0_2), .Y(clkb0_3));
  PADIZ40 PRB_70 ();
  BUFX4 BW2_BUF7896_1 (.A(n3_3), .Y(n3_4));
  PDO02CDG PO_clkb (.I(N7839), .PAD(clkb));
  PADIZ40 PRB_58 ();
  CLKINVX20 clk0_S0 (.A(clk0), .Y(clk0_8));
  PDIDGZ PI_test_mode (.C(n52), .PAD(test_mode));
  PDIDGZ PI_all_t0_i (.C(n84), .PAD(all_t0_i));
  PADIZ40 PRB_64 ();
  PADIZ40 PRB_77 ();
  PDO04CDG PO_addr_xdat_8 (.I(n430), .PAD(addr_xdat[8]));
  INVX1 BW2_INV_D1358 (.A(n441), .Y(n441_1));
  PDO04CDG PO_addr_xdat_3 (.I(n435), .PAD(addr_xdat[3]));
  PADIZ40 PRB_75 ();
  PVDD1DGZ VDD3 (.VDD(VDD));
  PVSS3DGZ VSS4 (.VSS(VSS));
  PDO04CDG PO_addr_xdat_1 (.I(n437), .PAD(addr_xdat[1]));
  CLKBUFX20 CLK_SYNC_SKEW_21 (.A(clk0_25), .Y(clk0_26));
  PADIZ40 PRB_83 ();
  PDO04CDG PO_out_xdat_1 (.I(n445), .PAD(out_xdat[1]));
  NAND2X1 U182_C4_3 (.A(n446_2), .B(ale_d1_2), .Y(N11548));
  PDIDGZ PI_rom_data_i_6 (.C(n105), .PAD(rom_data_i[6]));
  PADIZ40 PRB_27 ();
  PADIZ40 PRB_79 ();
  PADOZ40 PRB_1 ();
  PDIDGZ PI_rom_data_i_4 (.C(n107), .PAD(rom_data_i[4]));
  PVSS3DGZ VSS3 (.VSS(VSS));
  PDO04CDG PO_rom_adr_o_0 (.I(N10201), .PAD(rom_adr_o[0]));
  INVX4 BW2_INV221 (.A(n440_1), .Y(n440_2));
  PADIZ40 PRB_14 ();
  PADIZ40 PRB_10 ();
  PADOZ40 PRB_9 ();
  PADIZ40 PRB_12 ();
  MX2X2 U18_C4_1 (.A(n413), .B(n16), .S0(n3_6), .Y(N7870));
  MX2X4 U14_C4_1 (.A(n409), .B(n8), .S0(n3_6), .Y(N7868));
  INVX1 BW2_INV_D2415 (.A(n432), .Y(n432_1));
  PVDD2DGZ VD33_1 ();
  CLKINVX16 clk0_L0_5 (.A(clk0_8), .Y(clk0_1));
  BUFX4 BW2_BUF7896_2 (.A(n3_4), .Y(n3_5));
  NAND2X1 U179_C4_3 (.A(n443), .B(ale_d1_2), .Y(N7066));
  NAND2X1 U175_C4_3 (.A(n439), .B(ale_d1_2), .Y(N4072));
  PADIZ40 PRB_2 ();
  NAND2X1 U177_C4_3 (.A(n441_2), .B(ale_d1_2), .Y(N1950));
  SDFFSRX1 xaddr_low_reg_6_ (.CK(clk0_4), .D(N11028), .Q(\xaddr_low[6] ), 
     .QN(n243), .RN(N9923), .SE(n3_5), .SI(\xaddr_low[5] ), .SN(VDD));
  SDFFRHQX4 addr_xdat_reg_15_ (.CK(clk0_14), .D(\xaddr_high[7] ), .Q(n423), 
     .RN(N9923), .SE(n3_6), .SI(n424));
  PVDD1DGZ VDD1 (.VDD(VDD));
  PDO04CDG PO_rom_adr_o_14 (.I(N7845), .PAD(rom_adr_o[14]));
  PADOZ40 PRB_55 ();
  PDO04CDG PO_rom_adr_o_8 (.I(N12354), .PAD(rom_adr_o[8]));
  PADOZ40 PRB_44 ();
  CLKINVX16 clk0_L0_4 (.A(clk0_10), .Y(clk0_3));
  MX2X2 U19_C4_1 (.A(n414), .B(n18), .S0(n3_3), .Y(N12354));
  PDO04CDG PO_rom_adr_o_5 (.I(N11442), .PAD(rom_adr_o[5]));
  PDO04CDG PO_rom_adr_o_1 (.I(N7958), .PAD(rom_adr_o[1]));
  AND2X1 U174_C1 (.A(wr_xdat), .B(n449), .Y(N11027));
  MX2X2 U23_C4_1 (.A(n418), .B(n26), .S0(n3_2), .Y(N7867));
  MX2X2 U27_C4_1 (.A(n422), .B(n34), .S0(n3_2), .Y(N10201));
  OAI21X1 U180_C4_1 (.A0(n239), .A1(ale_d1_2), .B0(N3243), .Y(N9763));
  SDFFRHQX4 addr_xdat_reg_9_ (.CK(clk0_4), .D(\xaddr_high[1] ), .Q(n429), 
     .RN(N9923), .SE(n3_5), .SI(n430));
  SDFFRHQX4 addr_xdat_reg_8_ (.CK(clk0_4), .D(\xaddr_high[0] ), .Q(n430), 
     .RN(N9923), .SE(n3_5), .SI(n431));
  PADIZ40 PRB_31 ();
  INVX4 BW2_INV1358 (.A(n441_1), .Y(n441_2));
  PADIZ40 PRB_29 ();
  CLKBUFX20 CLK_SYNC_SKEW_12 (.A(clk0_27), .Y(clk0_21));
  INVX3 BW2_INV11050 (.A(n446_1), .Y(n446_2));
  CLKINVX20 clk0_L0_6 (.A(clk0_11), .Y(clk0_2));
  PADIZ40 PRB_54 ();
  PDO04CDG PO_Finish (.I(n451), .PAD(Finish));
  PADIZ40 PRB_45 ();
  PADOZ40 PRB_69 ();
  BUFX4 BW2_BUF7896 (.A(n3), .Y(n3_3));
  PDIDGZ PI_in_xdat_a_4 (.C(n139), .PAD(in_xdat_a[4]));
  PDB04SDGZ PB_p1_io_6 (.C(n148), .I(\p1_o[6] ), .OEN(N8369), .PAD(p1_io[6]));
  PDIDGZ PI_in_xdat_a_3 (.C(n140), .PAD(in_xdat_a[3]));
  PADIZ40 PRB_72 ();
  PADOZ40 PRB_71 ();
  INVX2 BW1_INV7886 (.A(N7886), .Y(N7886_1));
  NAND2BX1 U8_C2_1 (.AN(n3), .B(N3), .Y(N7962));
  PADOZ40 PRB_96 ();
  PADIZ40 PRB_99 ();
  PADOZ40 PRB_94 ();
  PVSS3DGZ VSS6 (.VSS(VSS));
  PDIDGZ PI_in_xdat_a_7 (.C(n136), .PAD(in_xdat_a[7]));
  DLY3X1 BH1_BUF3 (.A(n52_5), .Y(n52_4));
  CLKINVX16 U184_C1 (.A(clk0_23), .Y(clkb0));
  DLY3X1 BH1_BUF6 (.A(n3_8), .Y(n3_7));
  PADOZ40 PRB_61 ();
  PADIZ40 PRB_60 ();
  CLKBUFX20 CLK_SYNC_SKEW (.A(clk0_8), .Y(clk0_9));
  PDO04CDG PO_all_txd_o (.I(n406), .PAD(all_txd_o));
  PADOZ40 PRB_63 ();
  PDIDGZ PI_rst_p (.C(rst_p0), .PAD(rst_p));
  PDIDGZ PI_all_t1_i (.C(n85), .PAD(all_t1_i));
  PADOZ40 PRB_17 ();
  PDO04CDG PO_addr_xdat_7 (.I(n431), .PAD(addr_xdat[7]));
  PADIZ40 PRB_20 ();
  PDO04CDG PO_out_xdat_6 (.I(n440_2), .PAD(out_xdat[6]));
  PADOZ40 PRB_19 ();
  PDO04CDG PO_out_xdat_7 (.I(n439), .PAD(out_xdat[7]));
  PDO04CDG PO_addr_xdat_2 (.I(n436), .PAD(addr_xdat[2]));
  INVX1 BW2_INV_D10472 (.A(n442), .Y(n442_1));
  CLKBUFX20 CLK_SYNC_SKEW_9 (.A(clk0_7), .Y(clk0_18));
  PDO04CDG PO_out_xdat_0 (.I(n446_2), .PAD(out_xdat[0]));
  PADOZ40 PRB_82 ();
  OAI21X1 U182_C4_1 (.A0(n237), .A1(ale_d1_2), .B0(N11548), .Y(N9783));
  PDIDGZ PI_rom_data_i_5 (.C(n106), .PAD(rom_data_i[5]));
  PADOZ40 PRB_3 ();
  PDIDGZ PI_rom_data_i_3 (.C(n108), .PAD(rom_data_i[3]));
  PADOZ40 PRB_26 ();
  PADIZ40 PRB_6 ();
  PADOZ40 PRB_30 ();
  CLKBUFX16 CLK_SYNC_SKEW_4 (.A(clk0_5), .Y(clk0_13));
  SDFFRHQX4 addr_xdat_reg_12_ (.CK(clk0_14), .D(\xaddr_high[4] ), .Q(n426), 
     .RN(N9923), .SE(n3_5), .SI(n427));
  PDO04CDG PO_out_xdat_3 (.I(n443), .PAD(out_xdat[3]));
  PDO04CDG PO_addr_xdat_12 (.I(n426), .PAD(addr_xdat[12]));
  PADOZ40 PRB_78 ();
  PVDD2DGZ VD33_2 ();
  MX2X4 U16_C4_1 (.A(n411), .B(n12), .S0(n3_6), .Y(N11943));
  PADOZ40 PRB_32 ();
  PADOZ40 PRB_34 ();
  PADOZ40 PRB_57 ();
  OAI21X1 U181_C4_1 (.A0(n238), .A1(ale_d1_2), .B0(N10453), .Y(N9796));
  SDFFRHQX1 addr_xdat_reg_0_ (.CK(clk0_4), .D(\xaddr_low[0] ), .Q(n438), 
     .RN(N9923), .SE(n3_5), .SI(n7));
  BUFX3 BW1_BUF211 (.A(n438), .Y(n438_1));
  SDFFRHQX4 addr_xdat_reg_3_ (.CK(clk0_4), .D(\xaddr_low[3] ), .Q(n435), 
     .RN(N9923), .SE(n3_5), .SI(n436));
  OAI21X1 U177_C4_1 (.A0(n242), .A1(ale_d1_2), .B0(N1950), .Y(N9742));
  NAND2X1 U176_C4_3 (.A(n440_2), .B(ale_d1_2), .Y(N12269));
  INVX1 BW2_INV_D9104 (.A(ale_d1), .Y(ale_d1_1));
  PADOZ40 PRB_28 ();
  PDO04CDG PO_rom_adr_o_15 (.I(N7846), .PAD(rom_adr_o[15]));
  PADIZ40 PRB_52 ();
  PADOZ40 PRB_40 ();
  PVSS3DGZ VSS1 (.VSS(VSS));
  PDIDGZ PI_BistMode (.C(n155), .PAD(BistMode));
  PDO04CDG PO_rom_adr_o_6 (.I(N7869), .PAD(rom_adr_o[6]));
  PADIZ40 PRB_37 ();
  PDO04CDG PO_rd_xdat (.I(n449), .PAD(rd_xdat));
  INVX4 BW1_INV2716 (.A(n448_1), .Y(n448_2));
  MX2X2 U24_C4_1 (.A(n419), .B(n28), .S0(n3_2), .Y(N10469));
  MX2X2 U25_C4_1 (.A(n420), .B(n30), .S0(n3_2), .Y(N7956));
  MX2X4 U17_C4_1 (.A(n412), .B(n14), .S0(n3_6), .Y(N7959));
  Bisted_SPSRAM256X8_test_1 uBisted_SPSRAM256X8 (.CLK(), .CEN(idat_en), 
     .WEN(wr_idat), .Q({\in_idat_a[7] , \in_idat_a[6] , \in_idat_a[5] , 
     \in_idat_a[4] , \in_idat_a[3] , \in_idat_a[2] , \in_idat_a[1] , 
     \in_idat_a[0] }), .D({\out_idat[7] , \out_idat[6] , \out_idat[5] , 
     \out_idat[4] , \out_idat[3] , \out_idat[2] , \out_idat[1] , \out_idat[0] }), 
     .A({\addr_a[7] , \addr_a[6] , \addr_a[5] , \addr_a[4] , \addr_a[3] , 
     \addr_a[2] , \addr_a[1] , \addr_a[0] }), .BistMode(n155), .BistFail(n450), 
     .Finish(n451), .ErrMap(n452), .test_si(n447), .test_so(n5), .test_se(n3_4), 
     .clkb0_2(clkb0_1), .clkb0_0(clkb0), .clkb0_3(clkb0_3));
  PDO04CDG PO_out_xdat_2 (.I(n444), .PAD(out_xdat[2]));
  PADIZ40 PRB_18 ();
  SDFFSRX1 xaddr_low_reg_3_ (.CK(clk0_4), .D(N9785), .Q(\xaddr_low[3] ), 
     .QN(n240), .RN(N9923), .SE(n3_5), .SI(\xaddr_low[2] ), .SN(VDD));
  PVDD2DGZ VD33_3 ();
  PADOZ40 PRB_7 ();
  PADIZ40 PRB_87 ();
  CLKINVX20 clk0_L0_3 (.A(clk0_8), .Y(clk0_7));
  PADIZ40 PRB_43 ();
  PDO04CDG PO_wr_xdat_d1 (.I(n448_2), .PAD(wr_xdat_d1));
  PDO04CDG PO_rom_adr_o_13 (.I(N7868), .PAD(rom_adr_o[13]));
  PADIZ40 PRB_47 ();
  PADIZ40 PRB_97 ();
  PADIZ40 PRB_66 ();
  DLY3X1 BH1_BUF8 (.A(n3_1), .Y(n3_9));
  PDIDGZ PI_in_xdat_a_1 (.C(n142), .PAD(in_xdat_a[1]));
  PDB04SDGZ PB_p1_io_3 (.C(n151), .I(\p1_o[3] ), .OEN(N7962_1), .PAD(p1_io[3]));
  PDIDGZ PI_in_xdat_a_0 (.C(n143), .PAD(in_xdat_a[0]));
  PADIZ40 PRB_74 ();
  PDB04SDGZ PB_p1_io_2 (.C(n152), .I(\p1_o[2] ), .OEN(N7886_1), .PAD(p1_io[2]));
  INVX2 BW1_INV7962 (.A(N7962), .Y(N7962_1));
  NOR2BX2 U7_C2 (.AN(N4), .B(n3), .Y(N7871));
  NOR2BX2 U5_C2 (.AN(N6), .B(n3), .Y(N8369));
  PADOZ40 PRB_90 ();
  PADIZ40 PRB_93 ();
  CLKBUFX16 CLK_SYNC_SKEW_13 (.A(clk0_18), .Y(clk0_22));
  PADOZ40 PRB_84 ();
  CLKBUFX20 CLK_SYNC_SKEW_16 (.A(clkb0_1), .Y(clkb0_2));
  CLKBUFX16 CLK_SYNC_SKEW_14 (.A(clk0_22), .Y(clk0_23));
  DLY3X1 BH1_BUF2 (.A(n52_4), .Y(n52_3));
  PDIDGZ PI_scan_en (.C(n3_1), .PAD(scan_en));
  INVX1 U75_C1 (.A(clk0_1), .Y(N7839));
  PADOZ40 PRB_59 ();
  CLKBUFX20 CLK_SYNC_SKEW_1 (.A(clk0_12), .Y(clk0_10));
  PDIDGZ PI_int0_i (.C(n82), .PAD(int0_i));
  PVSS3DGZ VSS8 (.VSS(VSS));
  PDIDGZ PI_int1_i (.C(n83), .PAD(int1_i));
  PDO04CDG PO_out_xdat_5 (.I(n441_2), .PAD(out_xdat[5]));
  PDO04CDG PO_addr_xdat_11 (.I(n427), .PAD(addr_xdat[11]));
  INVX4 BW2_INV10472 (.A(n442_1), .Y(n442_2));
  PADOZ40 PRB_21 ();
  PADOZ40 PRB_15 ();
  PDO04CDG PO_addr_xdat_5 (.I(n433), .PAD(addr_xdat[5]));
  PADIZ40 PRB_16 ();
  PVSS3DGZ VSS5 (.VSS(VSS));
  CLKBUFX20 CLK_SYNC_SKEW_22 (.A(clk0_20), .Y(clk0_27));
  INVX1 U3_C1 (.A(rst_p0), .Y(n53));
  XOR2X2 \test_point_535/U6_C4  (.A(rst_p0_2), .B(n52_1), .Y(n54));
  NAND2X1 U181_C4_3 (.A(n445), .B(ale_d1_2), .Y(N10453));
  PDO04CDG PO_addr_xdat_15 (.I(n423), .PAD(addr_xdat[15]));
  SDFFRHQX1 ale_d1_reg (.CK(clk0_14), .D(ale), .Q(ale_d1), .RN(N9923), .SE(n3_6), 
     .SI(n423));
  SDFFRHQX4 addr_xdat_reg_5_ (.CK(clk0_4), .D(\xaddr_low[5] ), .Q(n433), 
     .RN(N9923), .SE(n3_5), .SI(n434));
  PDIDGZ PI_rom_data_i_1 (.C(n110), .PAD(rom_data_i[1]));
  PDIDGZ PI_rom_data_i_0 (.C(n111), .PAD(rom_data_i[0]));
  SDFFRHQX4 addr_xdat_reg_14_ (.CK(clk0_14), .D(\xaddr_high[6] ), .Q(n424), 
     .RN(N9923), .SE(n3_6), .SI(n425));
  CLKBUFX20 CLK_SYNC_SKEW_5 (.A(clk0_15), .Y(clk0_14));
  CLKBUFX16 CLK_SYNC_SKEW_8 (.A(clk0_16), .Y(clk0_17));
  PADIZ40 PRB_24 ();
  PDO04CDG PO_addr_xdat_10 (.I(n428), .PAD(addr_xdat[10]));
  INVX1 BW2_INV_D221 (.A(n440), .Y(n440_1));
  PDO04CDG PO_addr_xdat_9 (.I(n429), .PAD(addr_xdat[9]));
  PADIZ40 PRB_33 ();
  MX2X4 U13_C4_1 (.A(n408), .B(n432_2), .S0(n3_6), .Y(N7845));
  SDFFSRX1 xaddr_low_reg_5_ (.CK(clk0_4), .D(N9742), .Q(\xaddr_low[5] ), 
     .QN(n242), .RN(N9923), .SE(n3_5), .SI(\xaddr_low[4] ), .SN(VDD));
  PADOZ40 PRB_36 ();
  SDFFRHQX4 addr_xdat_reg_7_ (.CK(clk0_4), .D(\xaddr_low[7] ), .Q(n431), 
     .RN(N9923), .SE(n3_4), .SI(n136));
  NAND2X1 U180_C4_3 (.A(n444), .B(ale_d1_2), .Y(N3243));
  OAI21X1 U179_C4_1 (.A0(n240), .A1(ale_d1_2), .B0(N7066), .Y(N9785));
  SDFFRHQX4 addr_xdat_reg_2_ (.CK(clk0_4), .D(\xaddr_low[2] ), .Q(n436), 
     .RN(N9923), .SE(n3_5), .SI(n437));
  PVDD1DGZ VDD2 (.VDD(VDD));
  NAND2X1 U178_C4_3 (.A(n442_2), .B(ale_d1_2), .Y(N2036));
  SDFFSRX1 xaddr_low_reg_4_ (.CK(clk0_4), .D(N9780), .Q(\xaddr_low[4] ), 
     .QN(n241), .RN(N9923), .SE(n3_5), .SI(\xaddr_low[3] ), .SN(VDD));
  PADOZ40 PRB_5 ();
  PDO04CDG PO_rom_adr_o_12 (.I(N10034), .PAD(rom_adr_o[12]));
  PADOZ40 PRB_51 ();
  BUFX2 BW1_BUF247_1 (.A(n3_5), .Y(n3_2));
  PADIZ40 PRB_41 ();
  PDO04CDG PO_rom_adr_o_11 (.I(N11943), .PAD(rom_adr_o[11]));
  MX2X2 U20_C4_1 (.A(n415), .B(n20), .S0(n3_3), .Y(N7953));
  MX2X2 U22_C4_1 (.A(n417), .B(n24), .S0(n3_3), .Y(N11442));
  PADIZ40 PRB_39 ();
  MX2X4 U15_C4_1 (.A(n410), .B(n10), .S0(n3_6), .Y(N10034));
  SDFFSX1 wr_xdat_d1_reg (.CK(clk0_6), .D(wr_xdat), .Q(), .QN(n448_1), .SE(n3_2), 
     .SI(n5), .SN(N9923));
  PDO04CDG PO_rom_adr_o_4 (.I(N7867), .PAD(rom_adr_o[4]));
  MX2X2 U26_C4_1 (.A(n421), .B(n32), .S0(n3_6), .Y(N7958));
endmodule

// Entity:Bisted_SPSRAM256X8_test_1 Model:Bisted_SPSRAM256X8_test_1 Library:L0
module Bisted_SPSRAM256X8_test_1 (CLK, CEN, WEN, Q, D, A, BistMode, BistFail, 
     Finish, ErrMap, test_si, test_so, test_se, clkb0_2, clkb0_0, clkb0_3);
  input CLK, CEN, WEN, BistMode, test_si, test_se, clkb0_2, clkb0_0, clkb0_3;
  output BistFail, Finish, ErrMap, test_so;
  input [7:0] D;
  input [7:0] A;
  output [7:0] Q;
  wire \bist_ctrl_n[0] , \bist_ctrl_n[1] , \bist_ctrl_n[2] , \bist_ctrl_n[3] , 
     \bist_ctrl_n[4] , \bist_ctrl_n[5] , \bist_ctrl_n[6] , \bist_ctrl_n[7] , 
     \bist_ctrl_n[8] , \bist_ctrl_n[9] , \bist_ctrl_n[10] , \bist_ctrl_n[11] , 
     \bist_ctrl_n[12] , \bist_ctrl_n[13] , \bist_ctrl_n[14] , \bist_ctrl_n[15] , 
     \bist_ctrl_n[16] , \mem_ctrl_n[0] , SYNOPSYS_UNCONNECTED__0;
  supply0 VSS;
  SPSRAM256X8_wrapper_SPSRAM256X8 WRAPPED_RAM_i0 (.CLK(), .CEN(CEN), .WEN(WEN), 
     .Q({Q[7], Q[6], Q[5], Q[4], Q[3], Q[2], Q[1], Q[0]}), .D({D[7], D[6], D[5], 
     D[4], D[3], D[2], D[1], D[0]}), .A({A[7], A[6], A[5], A[4], A[3], A[2], A[1], 
     A[0]}), .mem_ctrl({VSS, \mem_ctrl_n[0] }), .bist_ctrl({\bist_ctrl_n[16] , 
     \bist_ctrl_n[15] , \bist_ctrl_n[14] , \bist_ctrl_n[13] , \bist_ctrl_n[12] , 
     \bist_ctrl_n[11] , \bist_ctrl_n[10] , \bist_ctrl_n[9] , \bist_ctrl_n[8] , 
     \bist_ctrl_n[7] , \bist_ctrl_n[6] , \bist_ctrl_n[5] , \bist_ctrl_n[4] , 
     \bist_ctrl_n[3] , \bist_ctrl_n[2] , \bist_ctrl_n[1] , \bist_ctrl_n[0] }), 
     .clkb0_0(clkb0_0));
  BistCtrl_SPSRAM256X8_test_1 BistCtrl_i0 (.Tclk(), .BistMode(BistMode), 
     .mem_ctrl({SYNOPSYS_UNCONNECTED__0, \mem_ctrl_n[0] }), .Q_i({Q[7], Q[6], 
     Q[5], Q[4], Q[3], Q[2], Q[1], Q[0]}), .bist_ctrl({\bist_ctrl_n[16] , 
     \bist_ctrl_n[15] , \bist_ctrl_n[14] , \bist_ctrl_n[13] , \bist_ctrl_n[12] , 
     \bist_ctrl_n[11] , \bist_ctrl_n[10] , \bist_ctrl_n[9] , \bist_ctrl_n[8] , 
     \bist_ctrl_n[7] , \bist_ctrl_n[6] , \bist_ctrl_n[5] , \bist_ctrl_n[4] , 
     \bist_ctrl_n[3] , \bist_ctrl_n[2] , \bist_ctrl_n[1] , \bist_ctrl_n[0] }), 
     .BistFail(BistFail), .ErrMap(ErrMap), .Finish(Finish), .test_si(test_si), 
     .test_so(test_so), .test_se(test_se), .clkb0_3(clkb0_3), .clkb0_2(clkb0_2));
endmodule

// Entity:BistCtrl_SPSRAM256X8_test_1 Model:BistCtrl_SPSRAM256X8_test_1 Library:L0
module BistCtrl_SPSRAM256X8_test_1 (Tclk, BistMode, mem_ctrl, Q_i, bist_ctrl, 
     BistFail, ErrMap, Finish, test_si, test_so, test_se, clkb0_3, clkb0_2);
  input Tclk, BistMode, test_si, test_se, clkb0_3, clkb0_2;
  output BistFail, ErrMap, Finish, test_so;
  input [7:0] Q_i;
  output [1:0] mem_ctrl;
  output [16:0] bist_ctrl;
  wire S41, S45, S46, S44, S42, S43, S47, n4, n5;
  supply0 VSS;
  ST_MAG_SPSRAM256X8_test_1 S48 (.Tclk(), .BistMode(BistMode), .S0({bist_ctrl[7], 
     bist_ctrl[6], bist_ctrl[5], bist_ctrl[4], bist_ctrl[3], bist_ctrl[2], 
     bist_ctrl[1], bist_ctrl[0]}), .S1(S41), .S2(S45), .S3(S46), .S4(S44), 
     .test_si(test_si), .test_so(n5), .test_se(test_se), .clkb0_2(clkb0_2));
  ST_MAL_SPSRAM256X8_test_1 ST_MAL_i0 (.Tclk(), .BistMode(BistMode), 
     .BistFail(BistFail), .S12(S47), .S13({bist_ctrl[15], bist_ctrl[14], 
     bist_ctrl[13], bist_ctrl[12], bist_ctrl[11], bist_ctrl[10], bist_ctrl[9], 
     bist_ctrl[8]}), .S14({Q_i[7], Q_i[6], Q_i[5], Q_i[4], Q_i[3], Q_i[2], Q_i[1], 
     Q_i[0]}), .ErrMap(ErrMap), .test_si(n4), .test_so(test_so), 
     .test_se(test_se), .clkb0_2(clkb0_2), .clkb0_3(clkb0_3));
  ST_MPG_SPSRAM256X8 ST_MPG_i0 (.S7({bist_ctrl[15], bist_ctrl[14], bist_ctrl[13], 
     bist_ctrl[12], bist_ctrl[11], bist_ctrl[10], bist_ctrl[9], bist_ctrl[8]}), 
     .S8(S42), .S9(S43));
  ST_MTC_SPSRAM256X8_test_1 S49 (.Tclk(), .S18(), .S19(mem_ctrl[0]), .S4(S44), 
     .S2(S45), .S3(S46), .S1(S41), .S8(S42), .S9(S43), .BistMode(BistMode), 
     .S12(S47), .Finish(Finish), .test_si(n5), .test_so(n4), .test_se(test_se), 
     .clkb0_3(clkb0_3), .clkb0_2(clkb0_2));
  BUFX1 BL1_ASSIGN_BUF38 (.A(VSS), .Y(mem_ctrl[1]));
  BUFX2 BL1_ASSIGN_BUF18 (.A(BistMode), .Y(bist_ctrl[16]));
endmodule

// Entity:ST_MAG_SPSRAM256X8_test_1 Model:ST_MAG_SPSRAM256X8_test_1 Library:L0
module ST_MAG_SPSRAM256X8_test_1 (Tclk, BistMode, S0, S1, S2, S3, S4, test_si, 
     test_so, test_se, clkb0_2);
  input Tclk, BistMode, S1, S4, test_si, test_se, clkb0_2;
  output S2, S3, test_so;
  output [7:0] S0;
  wire N49, N50, N51, N52, N53, N54, N55, N56, N57, N58, N59, N60, N61, N62, 
     N63, N64, n38, n39, n40, n41, n42, n43, n45, n46, N10374, U45_C3__n, 
     N11387, N11386, N8056, N8041, N11621, N8040, N10965, N8067, N7434, N8057, 
     N11621_1, U45_C3__n_1, N10965_1, N8067_1, N8057_1, N8056_1, N8041_1, 
     N8040_1, N7434_1, S3_1, S3_6, S2_1, S2_6;
  ST_MAG_SPSRAM256X8_DW01_dec_8_0 sub_43 (.A({test_so, S0[6], S0[5], S0[4], 
     S0[3], S0[2], S0[1], S0[0]}), .SUM({N64, N63, N62, N61, N60, N59, N58, N57}));
  ST_MAG_SPSRAM256X8_DW01_inc_8_0 add_40 (.A({test_so, S0[6], S0[5], S0[4], 
     S0[3], S0[2], S0[1], S0[0]}), .SUM({N56, N55, N54, N53, N52, N51, N50, N49}));
  BUFX1 BL1_ASSIGN_BUF30 (.A(test_so), .Y(S0[7]));
  AND2X1 U51_C1_1 (.A(n39), .B(n38), .Y(S3_1));
  AOI22X1 U59_C5_5 (.A0(N54), .A1(N11387), .B0(N62), .B1(N11386), .Y(N11621_1));
  SDFFX1 S5_reg_4_ (.CK(N10374), .D(N7434), .Q(S0[4]), .QN(n39), .SE(test_se), 
     .SI(S0[3]));
  AND4X1 U48_C1_7 (.A(S2_6), .B(S2_1), .C(S0[3]), .D(S0[2]), .Y(S2));
  AOI22X1 U65_C5_5 (.A0(N51), .A1(N11387), .B0(N59), .B1(N11386), .Y(N8040_1));
  AOI22X1 U43_C5_5 (.A0(N49), .A1(N11387), .B0(N57), .B1(N11386), .Y(N8057_1));
  AND2X1 U48_C1_1 (.A(S0[1]), .B(S0[0]), .Y(S2_1));
  OAI2BB1X1 U67_C5_6 (.A0N(U45_C3__n), .A1N(S0[1]), .B0(N8041_1), .Y(N8041));
  AOI22X1 U63_C5_5 (.A0(N52), .A1(N11387), .B0(N60), .B1(N11386), .Y(N8067_1));
  SDFFX1 S5_reg_6_ (.CK(N10374), .D(N10965), .Q(S0[6]), .QN(n41), .SE(test_se), 
     .SI(S0[5]));
  SDFFX1 S5_reg_7_ (.CK(N10374), .D(N8056), .Q(test_so), .QN(n46), .SE(test_se), 
     .SI(S0[6]));
  AND3X1 U45_C3_2 (.A(U45_C3__n_1), .B(S1), .C(BistMode), .Y(N11387));
  AOI22X1 U57_C5_5 (.A0(N55), .A1(N11387), .B0(N63), .B1(N11386), .Y(N10965_1));
  NOR2BX1 U42_C1 (.AN(BistMode), .B(S4), .Y(U45_C3__n));
  SDFFX1 S5_reg_5_ (.CK(N10374), .D(N11621), .Q(S0[5]), .QN(n43), .SE(test_se), 
     .SI(S0[4]));
  AND4X1 U51_C1_7 (.A(n41), .B(n40), .C(S3_6), .D(S3_1), .Y(S3));
  AND4X1 U48_C1_6 (.A(test_so), .B(S0[6]), .C(S0[5]), .D(S0[4]), .Y(S2_6));
  AND4X1 U51_C1_6 (.A(n46), .B(n45), .C(n43), .D(n42), .Y(S3_6));
  OAI2BB1X1 U59_C5_6 (.A0N(U45_C3__n), .A1N(S0[5]), .B0(N11621_1), .Y(N11621));
  CLKINVX16 U47_C1 (.A(clkb0_2), .Y(N10374));
  INVX1 U45_C3_2_MP_INV (.A(U45_C3__n), .Y(U45_C3__n_1));
  AOI22X1 U55_C5_5 (.A0(N56), .A1(N11387), .B0(N64), .B1(N11386), .Y(N8056_1));
  OAI2BB1X1 U55_C5_6 (.A0N(U45_C3__n), .A1N(test_so), .B0(N8056_1), .Y(N8056));
  OAI2BB1X1 U65_C5_6 (.A0N(U45_C3__n), .A1N(S0[2]), .B0(N8040_1), .Y(N8040));
  AOI22X1 U67_C5_5 (.A0(N50), .A1(N11387), .B0(N58), .B1(N11386), .Y(N8041_1));
  OAI2BB1X1 U43_C5_6 (.A0N(U45_C3__n), .A1N(S0[0]), .B0(N8057_1), .Y(N8057));
  SDFFX1 S5_reg_3_ (.CK(N10374), .D(N8067), .Q(S0[3]), .QN(n40), .SE(test_se), 
     .SI(S0[2]));
  OAI2BB1X1 U61_C5_6 (.A0N(U45_C3__n), .A1N(S0[4]), .B0(N7434_1), .Y(N7434));
  AOI22X1 U61_C5_5 (.A0(N53), .A1(N11387), .B0(N61), .B1(N11386), .Y(N7434_1));
  SDFFX1 S5_reg_1_ (.CK(N10374), .D(N8041), .Q(S0[1]), .QN(n45), .SE(test_se), 
     .SI(S0[0]));
  OAI2BB1X1 U63_C5_6 (.A0N(U45_C3__n), .A1N(S0[3]), .B0(N8067_1), .Y(N8067));
  SDFFX1 S5_reg_0_ (.CK(N10374), .D(N8057), .Q(S0[0]), .QN(n38), .SE(test_se), 
     .SI(test_si));
  SDFFX1 S5_reg_2_ (.CK(N10374), .D(N8040), .Q(S0[2]), .QN(n42), .SE(test_se), 
     .SI(S0[1]));
  OAI2BB1X1 U57_C5_6 (.A0N(U45_C3__n), .A1N(S0[6]), .B0(N10965_1), .Y(N10965));
  NOR3BX2 U44_C2_2 (.AN(BistMode), .B(U45_C3__n), .C(S1), .Y(N11386));
endmodule

// Entity:ST_MAG_SPSRAM256X8_DW01_dec_8_0 Model:ST_MAG_SPSRAM256X8_DW01_dec_8_0 Library:L0
module ST_MAG_SPSRAM256X8_DW01_dec_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire U1_B_2_C1__n, U1_B_3_C1__n, U1_B_4_C1__n, U1_B_5_C1__n, U1_B_6_C1__n, 
     N7577;
  XNOR2X1 U1_A_5_C1 (.A(U1_B_5_C1__n), .B(A[5]), .Y(SUM[5]));
  OR2X1 U1_B_3_C1 (.A(U1_B_3_C1__n), .B(A[3]), .Y(U1_B_4_C1__n));
  XNOR2X1 U1_A_3_C1 (.A(U1_B_3_C1__n), .B(A[3]), .Y(SUM[3]));
  OR2X1 U1_B_1_C1 (.A(A[1]), .B(A[0]), .Y(U1_B_2_C1__n));
  XOR2X1 U1_A_1_C1 (.A(A[1]), .B(SUM[0]), .Y(SUM[1]));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  OR2X1 U1_B_2_C1 (.A(U1_B_2_C1__n), .B(A[2]), .Y(U1_B_3_C1__n));
  XNOR2X1 U1_A_2_C1 (.A(U1_B_2_C1__n), .B(A[2]), .Y(SUM[2]));
  OR2X1 U1_B_4_C1 (.A(U1_B_4_C1__n), .B(A[4]), .Y(U1_B_5_C1__n));
  XNOR2X1 U1_A_4_C1 (.A(U1_B_4_C1__n), .B(A[4]), .Y(SUM[4]));
  XNOR2X1 U1_A_6_C1 (.A(U1_B_6_C1__n), .B(A[6]), .Y(SUM[6]));
  OR2X1 U1_B_6_C1 (.A(U1_B_6_C1__n), .B(A[6]), .Y(N7577));
  OR2X1 U1_B_5_C1 (.A(U1_B_5_C1__n), .B(A[5]), .Y(U1_B_6_C1__n));
  XNOR2X1 U1_A_7_C1 (.A(A[7]), .B(N7577), .Y(SUM[7]));
endmodule

// Entity:ST_MAG_SPSRAM256X8_DW01_inc_8_0 Model:ST_MAG_SPSRAM256X8_DW01_inc_8_0 Library:L0
module ST_MAG_SPSRAM256X8_DW01_inc_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  XOR2X1 U5_C1 (.A(carry_7_), .B(A[7]), .Y(SUM[7]));
endmodule

// Entity:ST_MAL_SPSRAM256X8_test_1 Model:ST_MAL_SPSRAM256X8_test_1 Library:L0
module ST_MAL_SPSRAM256X8_test_1 (Tclk, BistMode, BistFail, S12, S13, S14, 
     ErrMap, test_si, test_so, test_se, clkb0_2, clkb0_3);
  input Tclk, BistMode, S12, test_si, test_se, clkb0_2, clkb0_3;
  output BistFail, ErrMap, test_so;
  input [7:0] S13;
  input [7:0] S14;
  wire ErrMap_1, n140, n15, N8043, N10665, N8042, N12049, N8066, N11960, N8063, 
     N11096, U20_C2__n, N11853, N10495, N12020, N12020_5, N12020_6, BistMode_1, 
     N11853_1;
  supply1 VDD;
  BUFX2 BL1_ASSIGN_BUF19 (.A(test_so), .Y(BistFail));
  NOR4X1 U20_C2_9 (.A(N8043), .B(N8042), .C(N12049), .D(N10665), .Y(N12020_6));
  XOR2X1 U31_C1 (.A(S14[3]), .B(S13[3]), .Y(N10665));
  XOR2X1 U25_C1 (.A(S14[6]), .B(S13[6]), .Y(N8066));
  NOR4X1 U20_C2_8 (.A(N8066), .B(N8063), .C(N11960), .D(N11096), .Y(N12020_5));
  XOR2X1 U27_C1 (.A(S14[4]), .B(S13[4]), .Y(N8063));
  AND3X1 U20_C2_11 (.A(S12), .B(BistMode), .C(N12020), .Y(U20_C2__n));
  XOR2X1 U29_C1 (.A(S14[1]), .B(S13[1]), .Y(N12049));
  XOR2X1 U26_C1 (.A(S14[7]), .B(S13[7]), .Y(N11960));
  NAND2X1 U20_C2_10 (.A(N12020_6), .B(N12020_5), .Y(N12020));
  SDFFNSX1 S16_reg (.CKN(clkb0_3), .D(U20_C2__n), .Q(ErrMap_1), .QN(n140), 
     .SE(test_se), .SI(test_si), .SN(VDD));
  CLKBUFX16 CLK_SYNC_SKEW_19 (.A(N11853), .Y(N11853_1));
  AOI21X1 U33_C3_1 (.A0(n15), .A1(n140), .B0(BistMode_1), .Y(N10495));
  XOR2X1 U32_C1 (.A(S14[2]), .B(S13[2]), .Y(N8043));
  XOR2X1 U28_C1 (.A(S14[5]), .B(S13[5]), .Y(N11096));
  XOR2X1 U30_C1 (.A(S14[0]), .B(S13[0]), .Y(N8042));
  INVX1 U33_C3_1_MP_INV (.A(BistMode), .Y(BistMode_1));
  SDFFX2 S17_reg (.CK(N11853_1), .D(N10495), .Q(test_so), .QN(n15), .SE(test_se), 
     .SI(ErrMap_1));
  BUFX4 BW1_BUF4059 (.A(ErrMap_1), .Y(ErrMap));
  CLKINVX16 U23_C1 (.A(clkb0_2), .Y(N11853));
endmodule

// Entity:ST_MPG_SPSRAM256X8 Model:ST_MPG_SPSRAM256X8 Library:L0
module ST_MPG_SPSRAM256X8 (S7, S8, S9);
  input S8, S9;
  output [7:0] S7;
  BUFX1 BL1_ASSIGN_BUF35 (.A(S9), .Y(S7[1]));
  BUFX1 BL1_ASSIGN_BUF37 (.A(S9), .Y(S7[3]));
  BUFX1 BL1_ASSIGN_BUF31 (.A(S7[0]), .Y(S7[2]));
  BUFX1 BL1_ASSIGN_BUF34 (.A(S9), .Y(S7[5]));
  BUFX1 BL1_ASSIGN_BUF36 (.A(S9), .Y(S7[7]));
  BUFX1 BL1_ASSIGN_BUF33 (.A(S7[0]), .Y(S7[4]));
  BUFX1 BL1_ASSIGN_BUF32 (.A(S7[0]), .Y(S7[6]));
  XOR2X1 U11_C1 (.A(S9), .B(S8), .Y(S7[0]));
endmodule

// Entity:ST_MTC_SPSRAM256X8_test_1 Model:ST_MTC_SPSRAM256X8_test_1 Library:L0
module ST_MTC_SPSRAM256X8_test_1 (Tclk, S18, S19, S4, S2, S3, S1, S8, S9, 
     BistMode, S12, Finish, test_si, test_so, test_se, clkb0_3, clkb0_2);
  input Tclk, S2, S3, BistMode, test_si, test_se, clkb0_3, clkb0_2;
  output S18, S19, S4, S1, S8, S9, S12, Finish, test_so;
  wire Finish_1, \State[0] , \State[1] , \State[2] , n83, n84, n85, n86, n87, 
     U131_C1__n, U131_C1__n_1, U116_C1__n, U116_C1__n_1, N10170, N6780, N6775, 
     N10169, U125_C1__n, U103_C1__n, U103_C1__n_1, U103_C1__n_2, U103_C1__n_3, 
     U103_C1__n_4, U135_C1__n, U118_C1__n, N7126, U128_C2__n, U128_C2__n_1, 
     U96_C3__n, U96_C3__n_1, U94_C3__n, U166_C2__n, N11660, U111_C3__n, 
     U111_C3__n_1, U153_C3__n, U153_C3__n_1, N8068, U150_C3__n, N8045, N11362, 
     U141_C2__n_2, N8047, N7359, U163_C5__n, N6127, N4667, N7135, N2867, N10911, 
     U132_C4__n_2, U132_C4__n_3, S2_1, U128_C2__n_3, N7126_1, BistMode_1, 
     U153_C3__n_6, N6775_1, U103_C1__n_5, U103_C1__n_6, U150_C3__n_3, 
     U141_C2__n_4, U141_C2__n_5, U128_C2__n_2, U125_C1__n_1, U116_C1__n_2, 
     U111_C3__n_2, U150_C3__n_4, U94_C3__n_2, U135_C1__n_1, N6780_1, S4_1, 
     S19_4, U103_C1__n_7, S1_3, N7359_1;
  supply1 VDD;
  supply0 VSS;
  BUFX1 BL1_ASSIGN_BUF169 (.A(VSS), .Y(S18));
  MXI2X1 U163_C5_2 (.A(S8), .B(n87), .S0(U111_C3__n), .Y(U163_C5__n));
  INVX1 U142_C3_7_MP_INV (.A(U128_C2__n), .Y(U128_C2__n_2));
  OAI221X1 U142_C3_7 (.A0(U125_C1__n), .A1(U118_C1__n), .B0(U128_C2__n_2), 
     .B1(S3), .C0(U103_C1__n_4), .Y(U141_C2__n_5));
  NAND3BX1 U128_C2_2 (.AN(U103_C1__n), .B(U128_C2__n_3), .C(U128_C2__n_2), 
     .Y(S12));
  AOI31X1 U150_C3_2 (.A0(U94_C3__n_2), .A1(U150_C3__n_4), .A2(U150_C3__n), 
     .B0(BistMode_1), .Y(N8045));
  OR2X1 U122_C1 (.A(n85), .B(n84), .Y(U135_C1__n));
  OAI22X1 U136_C4_4 (.A0(S2), .A1(N10170), .B0(U128_C2__n_2), .B1(S3), .Y(S4_1));
  NOR2BX1 U141_C2_2 (.AN(U141_C2__n_2), .B(BistMode_1), .Y(N8047));
  NAND3X1 U103_C1_4 (.A(U103_C1__n_6), .B(U103_C1__n_5), .C(S1_3), .Y(S1));
  OR2X1 U130_C1 (.A(U131_C1__n_1), .B(U118_C1__n), .Y(U111_C3__n));
  OR2X1 U158_C1 (.A(n85), .B(\State[0] ), .Y(U118_C1__n));
  AND2X1 U166_C2 (.A(U166_C2__n), .B(BistMode), .Y(N11660));
  NAND2X1 U124_C1 (.A(U125_C1__n_1), .B(U116_C1__n_2), .Y(U103_C1__n_4));
  SDFFNSX1 State_reg_1_ (.CKN(clkb0_3), .D(N8068), .Q(\State[1] ), .QN(n86), 
     .SE(test_se), .SI(\State[0] ), .SN(VDD));
  INVX1 U124_C1_MP_INV (.A(U125_C1__n), .Y(U125_C1__n_1));
  AOI211X1 U97_C2_4 (.A0(U135_C1__n_1), .A1(N6780_1), .B0(U103_C1__n_3), 
     .C0(N10169), .Y(U94_C3__n_2));
  INVX1 U112_C2_5_MP_INV (.A(N7126), .Y(N7126_1));
  OR2X1 U157_C1 (.A(n86), .B(\State[2] ), .Y(N6780));
  INVX1 U124_C1_MP_INV_1 (.A(U116_C1__n), .Y(U116_C1__n_2));
  INVX1 U153_C3_4_MP_INV (.A(N6775), .Y(N6775_1));
  OR2X1 U127_C1 (.A(U118_C1__n), .B(U116_C1__n_1), .Y(U96_C3__n));
  NOR2X1 U135_C1 (.A(U135_C1__n), .B(U116_C1__n_1), .Y(U128_C2__n));
  SDFFNSX1 State_reg_3_ (.CKN(clkb0_3), .D(N11362), .Q(test_so), .QN(n85), 
     .SE(test_se), .SI(\State[2] ), .SN(VDD));
  SDFFX1 S36_reg (.CK(N7359_1), .D(N6127), .Q(S8), .QN(n87), .SE(test_se), 
     .SI(Finish_1));
  CLKBUFX16 CLK_SYNC_SKEW_18 (.A(N7359), .Y(N7359_1));
  SDFFNSX1 Finish_reg (.CKN(clkb0_3), .D(N11660), .Q(Finish_1), .QN(), 
     .SE(test_se), .SI(test_si), .SN(VDD));
  NOR2X1 U118_C1 (.A(U118_C1__n), .B(N6780), .Y(N7126));
  OAI221X1 U112_C2_5 (.A0(U125_C1__n), .A1(U118_C1__n), .B0(U135_C1__n), 
     .B1(N6780), .C0(N7126_1), .Y(U128_C2__n_1));
  AOI21X1 U106_C3_3 (.A0(U116_C1__n_2), .A1(N6780_1), .B0(N10169), 
     .Y(U103_C1__n_7));
  SDFFNSX1 State_reg_2_ (.CKN(clkb0_3), .D(N8045), .Q(\State[2] ), .QN(n83), 
     .SE(test_se), .SI(\State[1] ), .SN(VDD));
  OR2X1 U162_C1 (.A(test_so), .B(n84), .Y(U131_C1__n));
  SDFFNSX1 State_reg_0_ (.CKN(clkb0_3), .D(N8047), .Q(\State[0] ), .QN(n84), 
     .SE(test_se), .SI(S8), .SN(VDD));
  INVX1 U97_C2_4_MP_INV_1 (.A(U135_C1__n), .Y(U135_C1__n_1));
  INVX1 U132_C4_2_MP_INV (.A(U128_C2__n_1), .Y(U128_C2__n_3));
  OR2X1 U160_C1 (.A(n83), .B(\State[1] ), .Y(U116_C1__n_1));
  NOR2X1 U114_C1 (.A(U135_C1__n), .B(U131_C1__n_1), .Y(U166_C2__n));
  OR2X1 U126_C1 (.A(n86), .B(n83), .Y(U131_C1__n_1));
  INVX1 U97_C2_4_MP_INV_2 (.A(N6780), .Y(N6780_1));
  NOR2X1 U121_C1 (.A(U131_C1__n), .B(U116_C1__n_1), .Y(N10169));
  NOR2X1 U119_C1 (.A(U131_C1__n), .B(N6780), .Y(U103_C1__n_3));
  OR2X1 U131_C1 (.A(U131_C1__n_1), .B(U131_C1__n), .Y(N10170));
  OR4X1 U136_C4_7 (.A(U103_C1__n_1), .B(S4_1), .C(N7126), .D(N6775), .Y(S4));
  OAI2BB2X1 U140_C3_1 (.A0N(S3), .A1N(N7126), .B0(U116_C1__n), .B1(N6780), 
     .Y(U153_C3__n_1));
  AND3X1 U96_C3_5 (.A(U103_C1__n_6), .B(U103_C1__n_5), .C(S19_4), .Y(S19));
  NAND2X1 U153_C3_4 (.A(S2_1), .B(N6775_1), .Y(N2867));
  BUFX4 BW1_BUF5111 (.A(Finish_1), .Y(Finish));
  NOR2X1 U125_C1 (.A(U131_C1__n), .B(U125_C1__n), .Y(U103_C1__n_1));
  INVX1 U97_C2_4_MP_INV (.A(U94_C3__n_2), .Y(U94_C3__n));
  NOR2X1 U123_C1 (.A(U131_C1__n_1), .B(U116_C1__n), .Y(U103_C1__n_2));
  OR2X1 U161_C1 (.A(\State[2] ), .B(\State[1] ), .Y(U125_C1__n));
  NOR2X1 U116_C1 (.A(U116_C1__n_1), .B(U116_C1__n), .Y(N6775));
  OR4X1 U94_C3_3 (.A(U96_C3__n_1), .B(U94_C3__n), .C(N7126), .D(N6775), .Y(S9));
  OR2X1 U159_C1 (.A(test_so), .B(\State[0] ), .Y(U116_C1__n));
  NOR2X1 U117_C1 (.A(U135_C1__n), .B(U125_C1__n), .Y(U96_C3__n_1));
  CLKINVX16 U156_C1 (.A(clkb0_2), .Y(N7359));
  NOR4BX1 U111_C3_4 (.AN(U111_C3__n_1), .B(U96_C3__n_1), .C(U166_C2__n), 
     .D(U128_C2__n), .Y(U153_C3__n));
  AOI31X1 U153_C3_2 (.A0(U153_C3__n_6), .A1(U153_C3__n), .A2(U103_C1__n_6), 
     .B0(BistMode_1), .Y(N8068));
  AOI31X1 U132_C4_2 (.A0(U153_C3__n), .A1(U132_C4__n_2), .A2(U128_C2__n_3), 
     .B0(BistMode_1), .Y(N11362));
  NOR2BX1 U163_C5_1 (.AN(U163_C5__n), .B(BistMode_1), .Y(N6127));
  AOI211X1 U153_C3_8 (.A0(N2867), .A1(N10911), .B0(U153_C3__n_1), .C0(N10169), 
     .Y(U153_C3__n_6));
  NOR4BBX1 U96_C3_4 (.AN(U103_C1__n_4), .BN(U96_C3__n), .C(U96_C3__n_1), 
     .D(U103_C1__n_3), .Y(S19_4));
  AOI21X1 U142_C3_6 (.A0(U103_C1__n_1), .A1(S2_1), .B0(U111_C3__n_2), 
     .Y(U141_C2__n_4));
  OAI21X1 U132_C4_5 (.A0(S2_1), .A1(N10170), .B0(U96_C3__n), .Y(U132_C4__n_3));
  INVX1 U153_C3_5_MP_INV (.A(U103_C1__n_1), .Y(U103_C1__n_5));
  NAND2X1 U147_C4_3 (.A(S2_1), .B(N10170), .Y(N4667));
  NAND2X1 U153_C3_5 (.A(U103_C1__n_5), .B(S2), .Y(N10911));
  NAND2X1 U147_C4_4 (.A(S2), .B(N6775_1), .Y(N7135));
  INVX1 U153_C3_2_MP_INV (.A(U103_C1__n_2), .Y(U103_C1__n_6));
  NOR3BX1 U103_C1_3 (.AN(U103_C1__n_4), .B(U103_C1__n), .C(U103_C1__n_3), 
     .Y(S1_3));
  NAND3X1 U106_C3_5 (.A(U103_C1__n_7), .B(N6775_1), .C(N10170), .Y(U103_C1__n));
  AOI2BB2X1 U150_C3_6 (.A0N(n87), .A1N(U111_C3__n), .B0(U128_C2__n), .B1(S3), 
     .Y(U150_C3__n_4));
  INVX1 U132_C4_5_MP_INV_1 (.A(S2), .Y(S2_1));
  NAND4BBX1 U141_C2_1 (.AN(U141_C2__n_5), .BN(U153_C3__n_1), .C(U141_C2__n_4), 
     .D(U150_C3__n), .Y(U141_C2__n_2));
  OR2X1 U111_C3 (.A(n87), .B(U111_C3__n), .Y(U111_C3__n_1));
  INVX1 U132_C4_2_MP_INV_1 (.A(BistMode), .Y(BistMode_1));
  AOI21X1 U147_C4_5 (.A0(N7135), .A1(N4667), .B0(U166_C2__n), .Y(U150_C3__n_3));
  INVX1 U132_C4_5_MP_INV (.A(U132_C4__n_3), .Y(U132_C4__n_2));
  AND3X1 U147_C4_7 (.A(U96_C3__n), .B(U150_C3__n_3), .C(U103_C1__n_6), 
     .Y(U150_C3__n));
  INVX1 U142_C3_6_MP_INV (.A(U111_C3__n), .Y(U111_C3__n_2));
endmodule

// Entity:SPSRAM256X8_wrapper_SPSRAM256X8 Model:SPSRAM256X8_wrapper_SPSRAM256X8 Library:L0
module SPSRAM256X8_wrapper_SPSRAM256X8 (CLK, CEN, WEN, Q, D, A, mem_ctrl, 
     bist_ctrl, clkb0_0);
  input CLK, CEN, WEN, clkb0_0;
  input [7:0] D;
  input [7:0] A;
  input [1:0] mem_ctrl;
  input [16:0] bist_ctrl;
  output [7:0] Q;
  wire \D_n[0] , \D_n[1] , \D_n[2] , \D_n[3] , \D_n[4] , \D_n[5] , \D_n[6] , 
     \D_n[7] , \A_n[0] , \A_n[1] , \A_n[2] , \A_n[3] , \A_n[4] , \A_n[5] , 
     \A_n[6] , \A_n[7] , N6128, N11397, N11396, N10151, N6102, N8058, N1697, 
     N3103, N4974, N3381, N4981, D_0_1;
  supply0 VSS;
  SPSRAM256X8 SRAM_i0 (.A({\A_n[7] , \A_n[6] , \A_n[5] , \A_n[4] , \A_n[3] , 
     \A_n[2] , \A_n[1] , \A_n[0] }), .CEN(N6128), .CLK(clkb0_0), .D({\D_n[7] , 
     \D_n[6] , \D_n[5] , \D_n[4] , \D_n[3] , \D_n[2] , \D_n[1] , \D_n[0] }), 
     .OEN(VSS), .Q({Q[7], Q[6], Q[5], Q[4], Q[3], Q[2], Q[1], Q[0]}), 
     .WEN(N11397));
  MX2X1 U89_C1_1 (.A(A[7]), .B(bist_ctrl[7]), .S0(bist_ctrl[16]), .Y(\A_n[7] ));
  MX2X1 U86_C1_1 (.A(CEN), .B(mem_ctrl[1]), .S0(bist_ctrl[16]), .Y(N6128));
  MX2X1 U101_C1_1 (.A(A[1]), .B(bist_ctrl[1]), .S0(bist_ctrl[16]), .Y(\A_n[1] ));
  MX2X1 U95_C1_1 (.A(A[2]), .B(bist_ctrl[2]), .S0(bist_ctrl[16]), .Y(\A_n[2] ));
  MX2X1 U92_C1_1 (.A(A[0]), .B(bist_ctrl[0]), .S0(bist_ctrl[16]), .Y(\A_n[0] ));
  MX2X1 U98_C1_1 (.A(A[3]), .B(bist_ctrl[3]), .S0(bist_ctrl[16]), .Y(\A_n[3] ));
  MX2X1 U79_C1_1 (.A(WEN), .B(mem_ctrl[0]), .S0(bist_ctrl[16]), .Y(N11397));
  MX2X1 U110_C1_1 (.A(A[6]), .B(bist_ctrl[6]), .S0(bist_ctrl[16]), .Y(\A_n[6] ));
  NAND2X1 U70_C1 (.A(bist_ctrl[16]), .B(bist_ctrl[14]), .Y(N10151));
  NAND2X1 U72_C1 (.A(bist_ctrl[16]), .B(bist_ctrl[15]), .Y(N6102));
  NAND2X1 U84_C2_2 (.A(bist_ctrl[12]), .B(bist_ctrl[16]), .Y(N4974));
  INVX1 U66_C2_1_MP_INV (.A(D[0]), .Y(D_0_1));
  NAND2X1 U73_C2_2 (.A(bist_ctrl[13]), .B(bist_ctrl[16]), .Y(N1697));
  OAI2BB1X4 U84_C2_1 (.A0N(D[4]), .A1N(N11396), .B0(N4974), .Y(\D_n[4] ));
  MX2X1 U107_C1_1 (.A(A[5]), .B(bist_ctrl[5]), .S0(bist_ctrl[16]), .Y(\A_n[5] ));
  MX2X1 U104_C1_1 (.A(A[4]), .B(bist_ctrl[4]), .S0(bist_ctrl[16]), .Y(\A_n[4] ));
  NAND2X1 U66_C2_2 (.A(bist_ctrl[8]), .B(bist_ctrl[16]), .Y(N3381));
  OAI21X1 U66_C2_1 (.A0(D_0_1), .A1(bist_ctrl[16]), .B0(N3381), .Y(\D_n[0] ));
  INVX1 U82_C1 (.A(bist_ctrl[16]), .Y(N11396));
  NAND2X1 U77_C2_2 (.A(bist_ctrl[11]), .B(bist_ctrl[16]), .Y(N8058));
  NAND2X1 U75_C2_2 (.A(bist_ctrl[10]), .B(bist_ctrl[16]), .Y(N4981));
  OAI2BB1X4 U69_C3_1 (.A0N(D[6]), .A1N(N11396), .B0(N10151), .Y(\D_n[6] ));
  OAI2BB1X1 U75_C2_1 (.A0N(D[2]), .A1N(N11396), .B0(N4981), .Y(\D_n[2] ));
  OAI2BB1X1 U77_C2_1 (.A0N(D[3]), .A1N(N11396), .B0(N8058), .Y(\D_n[3] ));
  NAND2X1 U64_C2_2 (.A(bist_ctrl[9]), .B(bist_ctrl[16]), .Y(N3103));
  OAI2BB1X4 U71_C3_1 (.A0N(D[7]), .A1N(N11396), .B0(N6102), .Y(\D_n[7] ));
  OAI2BB1X2 U64_C2_1 (.A0N(D[1]), .A1N(N11396), .B0(N3103), .Y(\D_n[1] ));
  OAI2BB1X4 U73_C2_1 (.A0N(D[5]), .A1N(N11396), .B0(N1697), .Y(\D_n[5] ));
endmodule

// Entity:u_cpu_test_1 Model:u_cpu_test_1 Library:L0
module u_cpu_test_1 (clk, rst_p, in_xrom_a, in_idat_a, in_xdat_a, p0_in, p1_in, 
     p2_in, p3_in, rxdi, t0_pin, t1_pin, int0_pin, int1_pin, addr_xrom_a, psen, 
     addr_a, out_idat, wr_idat, rd_idat, xaddr_high, out_xdat, ale, p0_out, 
     p1_out, p2_out, p3_out, p0_en, p1_en, p2_en, p3_en, wr_xdat, rd_xdat, rxdo, 
     txdo, xdat_en, sel_code_xdat, rc8051RtlTop_test_mode_in, 
     rc8051RtlTop_rc8051RtlTop_test_ds_1_in, rc8051RtlTop_test_point_535_in, 
     test_si2, test_so2, test_si1, test_so1, test_si3, test_so3, test_si4, 
     test_so4, test_si5, test_so5, test_si6, test_so6, test_si7, test_so7, 
     test_si8, test_so8, test_si9, test_so9, test_si10, test_so10, test_si11, 
     test_so11, test_si12, test_so12, test_si13, test_so13, test_si14, 
     test_so14, test_si15, test_so15, test_se, clk0_26, clk0_9, clk0_21, 
     clk0_11, clk0_8, clk0_14, clk0_10, clk0_17);
  input clk, rst_p, rxdi, t0_pin, t1_pin, int0_pin, int1_pin, 
     rc8051RtlTop_test_mode_in, rc8051RtlTop_rc8051RtlTop_test_ds_1_in, 
     rc8051RtlTop_test_point_535_in, test_si2, test_si1, test_si3, test_si4, 
     test_si5, test_si6, test_si7, test_si8, test_si9, test_si10, test_si11, 
     test_si12, test_si13, test_si14, test_si15, test_se, clk0_26, clk0_9, 
     clk0_21, clk0_11, clk0_8, clk0_14, clk0_10, clk0_17;
  output psen, wr_idat, rd_idat, ale, wr_xdat, rd_xdat, rxdo, txdo, xdat_en, 
     sel_code_xdat, test_so2, test_so1, test_so3, test_so4, test_so5, test_so6, 
     test_so7, test_so8, test_so9, test_so10, test_so11, test_so12, test_so13, 
     test_so14, test_so15;
  input [7:0] in_xrom_a;
  input [7:0] in_idat_a;
  input [7:0] in_xdat_a;
  input [7:0] p0_in;
  input [7:0] p1_in;
  input [7:0] p2_in;
  input [7:0] p3_in;
  output [15:0] addr_xrom_a;
  output [7:0] addr_a;
  output [7:0] out_idat;
  output [7:0] xaddr_high;
  output [7:0] out_xdat;
  output [7:0] p0_out;
  output [7:0] p1_out;
  output [7:0] p2_out;
  output [7:0] p3_out;
  output [7:0] p0_en;
  output [7:0] p1_en;
  output [7:0] p2_en;
  output [7:0] p3_en;
  wire \code[0] , \code[1] , \code[2] , \code[3] , \code[4] , \code[5] , 
     \code[6] , \code[7] , \out_acc_r[0] , \out_acc_r[1] , \out_acc_r[2] , 
     \out_acc_r[3] , \out_acc_r[4] , \out_acc_r[5] , \out_acc_r[6] , 
     \out_acc_r[7] , \combus[0] , \combus[1] , \combus[2] , \combus[3] , 
     \combus[4] , \combus[5] , \combus[6] , \combus[7] , \out_dimod_r[0] , 
     \out_dimod_r[1] , \out_dimod_r[2] , \out_dimod_r[3] , \out_dimod_r[4] , 
     \out_dimod_r[5] , \out_dimod_r[6] , \out_dimod_r[7] , \in_xrom1_r[0] , 
     \in_xrom1_r[1] , \in_xrom1_r[2] , \in_xrom1_r[3] , \in_xrom1_r[4] , 
     \in_xrom1_r[5] , \in_xrom1_r[6] , \in_xrom1_r[7] , \sel_combus[0] , 
     \sel_combus[1] , \sel_combus[2] , \sel_combus[3] , \sel_addr1[0] , 
     \sel_addr1[1] , \sel_addr1[2] , \sel_op1[0] , \sel_op1[1] , \sel_op1[2] , 
     \sel_op2[0] , \sel_op2[1] , \sel_op2[2] , \sel_pc[0] , \sel_pc[1] , 
     \sel_pc[2] , \sel_alu[0] , \sel_alu[1] , \sel_alu[2] , \sel_alu[3] , 
     \sel_alu[4] , \addr_bank_a[0] , \addr_bank_a[1] , \addr_bank_a[2] , 
     \sel_bit_dat_out[0] , \sel_bit_dat_out[1] , \sel_in_cy_bit[0] , 
     \sel_in_cy_bit[1] , \sel_in_cy_bit[2] , wr_idat_p, rd_idat_p, wr_xdat_p, 
     rd_xdat_p, ale_neg, en_int, msb_a, msb_r, cy, ac, ov, cy_psw, bit_dat_in_r, 
     ld_instr, inc_pc, inc_pc2, inc_pc3, ld_pc, ld_pcl, ld_pch, ld_acc, 
     ld_acc_chd, sel_addr0, wr_sfr, ld_dpl, ld_dph, inc_dptr, sel_xdat, 
     sel_xaddr_low, sel_xaddr_high, inc_sp, dec_sp, ld_latch_acc, set_c, rst_c, 
     cpl_c, ld_c, set_ac, rst_ac, set_v, rst_v, ld_b, en_div, sel_page_addr, 
     bit_addr, rmw, reti, end_instr, ld_operand2, ld_xrom, ld_idat, ld_sfr, 
     ld_apc, ld_adptr, n55, N11026, N10028, rc8051RtlTop_test_point_535_in_1, 
     test_se_1;
  supply1 VDD;
  supply0 VSS;
  u_datapath_test_1 U1_datapath (.ld_apc(ld_apc), .ld_adptr(ld_adptr), 
     .ld_xrom(ld_xrom), .ld_idat(ld_idat), .ld_sfr(ld_sfr), 
     .ld_operand2(ld_operand2), .end_instr(end_instr), .clk(), .rst_p(rst_p), 
     .ld_instr(ld_instr), .inc_pc(inc_pc), .inc_pc2(inc_pc2), .inc_pc3(inc_pc3), 
     .ld_pc(ld_pc), .ld_pcl(ld_pcl), .ld_pch(ld_pch), .ld_acc(ld_acc), 
     .ld_acc_chd(ld_acc_chd), .sel_addr0(sel_addr0), .sel_addr1({\sel_addr1[2] , 
     \sel_addr1[1] , \sel_addr1[0] }), .in_xrom_a({in_xrom_a[7], in_xrom_a[6], 
     in_xrom_a[5], in_xrom_a[4], in_xrom_a[3], in_xrom_a[2], in_xrom_a[1], 
     in_xrom_a[0]}), .in_idat_a({in_idat_a[7], in_idat_a[6], in_idat_a[5], 
     in_idat_a[4], in_idat_a[3], in_idat_a[2], in_idat_a[1], in_idat_a[0]}), 
     .in_xdat_a({in_xdat_a[7], in_xdat_a[6], in_xdat_a[5], in_xdat_a[4], 
     in_xdat_a[3], in_xdat_a[2], in_xdat_a[1], in_xdat_a[0]}), .sel_combus({
     \sel_combus[3] , \sel_combus[2] , \sel_combus[1] , \sel_combus[0] }), 
     .wr_sfr(wr_sfr), .ld_dpl(ld_dpl), .ld_dph(ld_dph), .inc_dptr(inc_dptr), 
     .sel_xad(sel_xdat), .sel_xaddr_high(sel_xaddr_high), 
     .sel_xaddr_low(sel_xaddr_low), .inc_sp(inc_sp), .dec_sp(dec_sp), 
     .ld_latch_acc(ld_latch_acc), .set_c(set_c), .rst_c(rst_c), .cpl_c(cpl_c), 
     .ld_c(ld_c), .set_ac(set_ac), .rst_ac(rst_ac), .set_v(set_v), 
     .rst_v(rst_v), .sel_op1({\sel_op1[2] , \sel_op1[1] , \sel_op1[0] }), 
     .sel_op2({\sel_op2[2] , \sel_op2[1] , \sel_op2[0] }), .ld_b(ld_b), 
     .en_div(en_div), .sel_pc({\sel_pc[2] , \sel_pc[1] , \sel_pc[0] }), 
     .bit_addr(bit_addr), .rmw(rmw), .t0_pin(t0_pin), .t1_pin(t1_pin), 
     .int0_pin(int0_pin), .int1_pin(int1_pin), .rxdi(rxdi), .addr_bank_a({
     \addr_bank_a[2] , \addr_bank_a[1] , \addr_bank_a[0] }), .code({\code[7] , 
     \code[6] , \code[5] , \code[4] , \code[3] , \code[2] , \code[1] , 
     \code[0] }), .sel_bit_dat_out({\sel_bit_dat_out[1] , \sel_bit_dat_out[0] }), 
     .sel_in_cy_bit({\sel_in_cy_bit[2] , \sel_in_cy_bit[1] , \sel_in_cy_bit[0] }), 
     .p0_in({p0_in[7], p0_in[6], p0_in[5], p0_in[4], p0_in[3], p0_in[2], 
     p0_in[1], p0_in[0]}), .p1_in({p1_in[7], p1_in[6], p1_in[5], p1_in[4], 
     p1_in[3], p1_in[2], p1_in[1], p1_in[0]}), .p2_in({p2_in[7], p2_in[6], 
     p2_in[5], p2_in[4], p2_in[3], p2_in[2], p2_in[1], p2_in[0]}), .p3_in({VDD, 
     VDD, VDD, VDD, VDD, VDD, VDD, VDD}), .sel_alu({\sel_alu[4] , \sel_alu[3] , 
     \sel_alu[2] , \sel_alu[1] , \sel_alu[0] }), .reti(reti), .addr_xrom_a({
     addr_xrom_a[15], addr_xrom_a[14], addr_xrom_a[13], addr_xrom_a[12], 
     addr_xrom_a[11], addr_xrom_a[10], addr_xrom_a[9], addr_xrom_a[8], 
     addr_xrom_a[7], addr_xrom_a[6], addr_xrom_a[5], addr_xrom_a[4], 
     addr_xrom_a[3], addr_xrom_a[2], addr_xrom_a[1], addr_xrom_a[0]}), .addr_a({
     addr_a[7], addr_a[6], addr_a[5], addr_a[4], addr_a[3], addr_a[2], 
     addr_a[1], addr_a[0]}), .msb_a(msb_a), .msb_r(msb_r), .en_int(en_int), 
     .xaddr_high({xaddr_high[7], xaddr_high[6], xaddr_high[5], xaddr_high[4], 
     xaddr_high[3], xaddr_high[2], xaddr_high[1], xaddr_high[0]}), .cy(cy), 
     .ac(ac), .ov(ov), .sel_page_addr(sel_page_addr), .out_acc_r({
     \out_acc_r[7] , \out_acc_r[6] , \out_acc_r[5] , \out_acc_r[4] , 
     \out_acc_r[3] , \out_acc_r[2] , \out_acc_r[1] , \out_acc_r[0] }), 
     .cy_psw(cy_psw), .combus({\combus[7] , \combus[6] , \combus[5] , 
     \combus[4] , \combus[3] , \combus[2] , \combus[1] , \combus[0] }), 
     .out_dimod_r({\out_dimod_r[7] , \out_dimod_r[6] , \out_dimod_r[5] , 
     \out_dimod_r[4] , \out_dimod_r[3] , \out_dimod_r[2] , \out_dimod_r[1] , 
     \out_dimod_r[0] }), .in_xrom1_r({\in_xrom1_r[7] , \in_xrom1_r[6] , 
     \in_xrom1_r[5] , \in_xrom1_r[4] , \in_xrom1_r[3] , \in_xrom1_r[2] , 
     \in_xrom1_r[1] , \in_xrom1_r[0] }), .bit_dat_in_r(bit_dat_in_r), .p0_out({
     p0_out[7], p0_out[6], p0_out[5], p0_out[4], p0_out[3], p0_out[2], 
     p0_out[1], p0_out[0]}), .p1_out({p1_en[7], p1_en[6], p1_en[5], p1_en[4], 
     p1_en[3], p1_en[2], p1_en[1], p1_en[0]}), .p2_out({p2_out[7], p2_out[6], 
     p2_out[5], p2_out[4], p2_out[3], p2_out[2], p2_out[1], p2_out[0]}), 
     .p3_out({p3_out[7], p3_out[6], p3_out[5], p3_out[4], p3_out[3], p3_out[2], 
     p3_out[1], p3_out[0]}), .txdo(txdo), .rxdo(rxdo), .out_xdat({out_xdat[7], 
     out_xdat[6], out_xdat[5], out_xdat[4], out_xdat[3], out_xdat[2], 
     out_xdat[1], out_xdat[0]}), .out_idat({out_idat[7], out_idat[6], out_idat[5], 
     out_idat[4], out_idat[3], out_idat[2], out_idat[1], out_idat[0]}), 
     .rc8051RtlTop_test_mode_in(rc8051RtlTop_test_mode_in), 
     .rc8051RtlTop_rc8051RtlTop_test_ds_1_in(rc8051RtlTop_rc8051RtlTop_test_ds_1_in), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si3(n55), .test_so3(test_so2), .test_si4(test_si3), 
     .test_so4(test_so3), .test_si5(test_si4), .test_so5(test_so4), 
     .test_si6(test_si5), .test_so6(test_so5), .test_si7(test_si6), 
     .test_so7(test_so6), .test_si8(test_si7), .test_so8(test_so7), 
     .test_si9(test_si8), .test_so9(test_so8), .test_si10(test_si9), 
     .test_so10(test_so9), .test_si11(test_si10), .test_so11(test_so10), 
     .test_si12(test_si11), .test_so12(test_so11), .test_si13(test_si12), 
     .test_so13(test_so12), .test_si14(test_si13), .test_so14(test_so13), 
     .test_si1(test_si14), .test_so1(test_so14), .test_si2(test_si15), 
     .test_so2(test_so15), .test_se(test_se_1), .clk0_21(clk0_21), 
     .clk0_26(clk0_26), .clk0_9(clk0_9), .clk0_8(clk0_8), .clk0_14(clk0_14), 
     .clk0_11(clk0_11), .clk0_10(clk0_10));
  u_con_test_1 U0_con (.code({\code[7] , \code[6] , \code[5] , \code[4] , 
     \code[3] , \code[2] , \code[1] , \code[0] }), .clk(), .rst_p(rst_p), 
     .en_int(en_int), .msb_a(msb_a), .msb_r(msb_r), .cy(cy), .ac(ac), .ov(ov), 
     .out_acc_r({\out_acc_r[7] , \out_acc_r[6] , \out_acc_r[5] , \out_acc_r[4] , 
     \out_acc_r[3] , \out_acc_r[2] , \out_acc_r[1] , \out_acc_r[0] }), 
     .cy_psw(cy_psw), .combus({\combus[7] , \combus[6] , \combus[5] , 
     \combus[4] , \combus[3] , \combus[2] , \combus[1] , \combus[0] }), 
     .out_dimod_r({\out_dimod_r[7] , \out_dimod_r[6] , \out_dimod_r[5] , 
     \out_dimod_r[4] , \out_dimod_r[3] , \out_dimod_r[2] , \out_dimod_r[1] , 
     \out_dimod_r[0] }), .in_xrom1_r({\in_xrom1_r[7] , \in_xrom1_r[6] , 
     \in_xrom1_r[5] , \in_xrom1_r[4] , \in_xrom1_r[3] , \in_xrom1_r[2] , 
     \in_xrom1_r[1] , \in_xrom1_r[0] }), .bit_dat_in_r(bit_dat_in_r), 
     .ld_instr(ld_instr), .wr_idat(wr_idat_p), .rd_idat(rd_idat_p), 
     .end_instr(end_instr), .ld_pc(ld_pc), .ld_pcl(ld_pcl), .ld_pch(ld_pch), 
     .ld_acc(ld_acc), .ld_acc_chd(ld_acc_chd), .inc_pc(inc_pc), 
     .inc_pc2(inc_pc2), .inc_pc3(inc_pc3), .sel_combus({\sel_combus[3] , 
     \sel_combus[2] , \sel_combus[1] , \sel_combus[0] }), .sel_addr0(sel_addr0), 
     .sel_addr1({\sel_addr1[2] , \sel_addr1[1] , \sel_addr1[0] }), 
     .wr_sfr(wr_sfr), .ld_dpl(ld_dpl), .ld_dph(ld_dph), .inc_dptr(inc_dptr), 
     .wr_xdat(wr_xdat_p), .rd_xdat(rd_xdat_p), .ale(ale_neg), 
     .sel_xad(sel_xdat), .sel_xaddr_low(sel_xaddr_low), 
     .sel_xaddr_high(sel_xaddr_high), .inc_sp(inc_sp), .dec_sp(dec_sp), 
     .ld_latch_acc(ld_latch_acc), .set_c(set_c), .rst_c(rst_c), .cpl_c(cpl_c), 
     .ld_c(ld_c), .set_ac(set_ac), .rst_ac(rst_ac), .set_v(set_v), 
     .rst_v(rst_v), .sel_op1({\sel_op1[2] , \sel_op1[1] , \sel_op1[0] }), 
     .sel_op2({\sel_op2[2] , \sel_op2[1] , \sel_op2[0] }), .ld_b(ld_b), 
     .en_div(en_div), .sel_pc({\sel_pc[2] , \sel_pc[1] , \sel_pc[0] }), 
     .sel_page_addr(sel_page_addr), .bit_addr(bit_addr), .rmw(rmw), .sel_alu({
     \sel_alu[4] , \sel_alu[3] , \sel_alu[2] , \sel_alu[1] , \sel_alu[0] }), 
     .addr_bank_a({\addr_bank_a[2] , \addr_bank_a[1] , \addr_bank_a[0] }), 
     .sel_bit_dat_out({\sel_bit_dat_out[1] , \sel_bit_dat_out[0] }), 
     .sel_in_cy_bit({\sel_in_cy_bit[2] , \sel_in_cy_bit[1] , \sel_in_cy_bit[0] }), 
     .reti(reti), .psen(), .ld_xrom(ld_xrom), .ld_idat(ld_idat), 
     .ld_sfr(ld_sfr), .ld_operand2(ld_operand2), .sel_code_xdat(sel_code_xdat), 
     .ld_adptr(ld_adptr), .ld_apc(ld_apc), 
     .rc8051RtlTop_test_mode_in(rc8051RtlTop_test_mode_in), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si(test_si2), .test_so(n55), .test_se(test_se), .clk0_14(clk0_14));
  INVX1 U37_C1 (.A(wr_xdat_p), .Y(wr_xdat));
  INVX1 U40_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N10028));
  SDFFRHQX1 ale_reg (.CK(N11026), .D(ale_neg), .Q(ale), .RN(N10028), 
     .SE(test_se), .SI(test_si1));
  BUFX4 BW1_BUF247_2 (.A(test_se), .Y(test_se_1));
  CLKINVX16 U39_C1 (.A(clk0_17), .Y(N11026));
  SDFFRHQX1 xdat_en_reg (.CK(N11026), .D(wr_xdat), .Q(test_so1), .RN(N10028), 
     .SE(test_se), .SI(ale));
  BUFX1 BL1_ASSIGN_BUF28 (.A(test_so1), .Y(xdat_en));
  INVX1 U12_C1 (.A(rd_idat_p), .Y(rd_idat));
  INVX1 U11_C1 (.A(wr_idat_p), .Y(wr_idat));
  BUFX1 BL1_ASSIGN_BUF65 (.A(VSS), .Y(psen));
  BUFX1 BL1_ASSIGN_BUF53 (.A(p2_out[2]), .Y(p2_en[2]));
  BUFX1 BL1_ASSIGN_BUF40 (.A(p0_out[7]), .Y(p0_en[7]));
  BUFX2 BL1_ASSIGN_BUF8 (.A(p1_en[7]), .Y(p1_out[7]));
  BUFX3 BL1_ASSIGN_BUF2 (.A(p1_en[2]), .Y(p1_out[2]));
  BUFX2 BL1_ASSIGN_BUF0 (.A(p1_en[0]), .Y(p1_out[0]));
  BUFX2 BL1_ASSIGN_BUF6 (.A(p1_en[6]), .Y(p1_out[6]));
  BUFX2 BL1_ASSIGN_BUF1 (.A(p1_en[1]), .Y(p1_out[1]));
  BUFX2 BL1_ASSIGN_BUF3 (.A(p1_en[3]), .Y(p1_out[3]));
  BUFX2 BL1_ASSIGN_BUF4 (.A(p1_en[4]), .Y(p1_out[4]));
  BUFX2 BL1_ASSIGN_BUF5 (.A(p1_en[5]), .Y(p1_out[5]));
  BUFX1 BL1_ASSIGN_BUF64 (.A(p3_out[0]), .Y(p3_en[0]));
  BUFX1 BL1_ASSIGN_BUF63 (.A(p3_out[1]), .Y(p3_en[1]));
  BUFX1 BL1_ASSIGN_BUF43 (.A(p0_out[4]), .Y(p0_en[4]));
  BUFX1 BL1_ASSIGN_BUF62 (.A(p3_out[2]), .Y(p3_en[2]));
  BUFX1 BL1_ASSIGN_BUF41 (.A(p0_out[6]), .Y(p0_en[6]));
  BUFX1 BL1_ASSIGN_BUF49 (.A(p2_out[7]), .Y(p2_en[7]));
  BUFX1 BL1_ASSIGN_BUF42 (.A(p0_out[5]), .Y(p0_en[5]));
  BUFX1 BL1_ASSIGN_BUF50 (.A(p2_out[6]), .Y(p2_en[6]));
  BUFX1 BL1_ASSIGN_BUF54 (.A(p2_out[1]), .Y(p2_en[1]));
  BUFX1 BL1_ASSIGN_BUF55 (.A(p2_out[0]), .Y(p2_en[0]));
  BUFX1 BL1_ASSIGN_BUF51 (.A(p2_out[5]), .Y(p2_en[5]));
  BUFX1 BL1_ASSIGN_BUF52 (.A(p2_out[3]), .Y(p2_en[3]));
  INVX4 U38_C1 (.A(rd_xdat_p), .Y(rd_xdat));
  BUFX2 BW1_BUF290 (.A(rc8051RtlTop_test_point_535_in), 
     .Y(rc8051RtlTop_test_point_535_in_1));
  BUFX1 BL1_ASSIGN_BUF57 (.A(p3_out[7]), .Y(p3_en[7]));
  BUFX1 BL1_ASSIGN_BUF24 (.A(p2_out[4]), .Y(p2_en[4]));
  BUFX1 BL1_ASSIGN_BUF45 (.A(p0_out[2]), .Y(p0_en[2]));
  BUFX1 BL1_ASSIGN_BUF58 (.A(p3_out[6]), .Y(p3_en[6]));
  BUFX1 BL1_ASSIGN_BUF61 (.A(p3_out[3]), .Y(p3_en[3]));
  BUFX1 BL1_ASSIGN_BUF46 (.A(p0_out[1]), .Y(p0_en[1]));
  BUFX1 BL1_ASSIGN_BUF47 (.A(p0_out[0]), .Y(p0_en[0]));
  BUFX1 BL1_ASSIGN_BUF59 (.A(p3_out[5]), .Y(p3_en[5]));
  BUFX1 BL1_ASSIGN_BUF44 (.A(p0_out[3]), .Y(p0_en[3]));
  BUFX1 BL1_ASSIGN_BUF60 (.A(p3_out[4]), .Y(p3_en[4]));
endmodule

// Entity:u_con_test_1 Model:u_con_test_1 Library:L0
module u_con_test_1 (code, clk, rst_p, en_int, msb_a, msb_r, cy, ac, ov, 
     out_acc_r, cy_psw, combus, out_dimod_r, in_xrom1_r, bit_dat_in_r, ld_instr, 
     wr_idat, rd_idat, end_instr, ld_pc, ld_pcl, ld_pch, ld_acc, ld_acc_chd, 
     inc_pc, inc_pc2, inc_pc3, sel_combus, sel_addr0, sel_addr1, wr_sfr, ld_dpl, 
     ld_dph, inc_dptr, wr_xdat, rd_xdat, ale, sel_xad, sel_xaddr_low, 
     sel_xaddr_high, inc_sp, dec_sp, ld_latch_acc, set_c, rst_c, cpl_c, ld_c, 
     set_ac, rst_ac, set_v, rst_v, sel_op1, sel_op2, ld_b, en_div, sel_pc, 
     sel_page_addr, bit_addr, rmw, sel_alu, addr_bank_a, sel_bit_dat_out, 
     sel_in_cy_bit, reti, psen, ld_xrom, ld_idat, ld_sfr, ld_operand2, 
     sel_code_xdat, ld_adptr, ld_apc, rc8051RtlTop_test_mode_in, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_14);
  input clk, rst_p, en_int, msb_a, msb_r, cy, ac, ov, cy_psw, bit_dat_in_r, 
     rc8051RtlTop_test_mode_in, rc8051RtlTop_test_point_535_in, test_si, 
     test_se, clk0_14;
  output ld_instr, wr_idat, rd_idat, end_instr, ld_pc, ld_pcl, ld_pch, ld_acc, 
     ld_acc_chd, inc_pc, inc_pc2, inc_pc3, sel_addr0, wr_sfr, ld_dpl, ld_dph, 
     inc_dptr, wr_xdat, rd_xdat, ale, sel_xad, sel_xaddr_low, sel_xaddr_high, 
     inc_sp, dec_sp, ld_latch_acc, set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac, 
     set_v, rst_v, ld_b, en_div, sel_page_addr, bit_addr, rmw, reti, psen, 
     ld_xrom, ld_idat, ld_sfr, ld_operand2, sel_code_xdat, ld_adptr, ld_apc, 
     test_so;
  input [7:0] code;
  input [7:0] out_acc_r;
  input [7:0] combus;
  input [7:0] out_dimod_r;
  input [7:0] in_xrom1_r;
  output [3:0] sel_combus;
  output [2:0] sel_addr1;
  output [2:0] sel_op1;
  output [2:0] sel_op2;
  output [2:0] sel_pc;
  output [4:0] sel_alu;
  output [2:0] addr_bank_a;
  output [1:0] sel_bit_dat_out;
  output [2:0] sel_in_cy_bit;
  wire ld_b_1, sel_addr1_0_3, \timing_cnt[0] , \timing_cnt[1] , \timing_cnt[2] , 
     \t_2[0] , \t_2[1] , \t_2[2] , \t_2[3] , \itcnt[0] , \itcnt[1] , \itcnt[2] , 
     extend_mux, extend_wr, extend_rd, en_int1, N283, N284, N285, N288, N289, 
     N290, n560, n561, n563, n565, n566, n569, n570, n571, n572, sel_addr0_1, 
     n620, sel_op2_0_1, sel_page_addr_1, n2, U683_C1__n, N8513, N10062, 
     U1109_C1__n, U961_C1__n, U736_C1__n, N8328, U983_C2__n, N8540, U690_C1__n, 
     U958_C1__n, N10177, N8329, U1202_C2__n, N8543, N8545, U960_C2__n, 
     U960_C2__n_1, U907_C1__n, U1035_C1__n, U888_C1__n, U888_C1__n_1, 
     U888_C1__n_2, N10466, N8594, N8364, U1226_C2__n, U1226_C2__n_1, U712_C2__n, 
     U1268_C1__n, U934_C1__n, N8436, N8440, N8442, N2703, N8439, U1139_C1__n, 
     U931_C1__n, N8370, U976_C4__n, U976_C4__n_1, U752_C1__n, U752_C1__n_1, 
     N10858, N7690, N8459, N8462, N12081, U1063_C2__n, N12077, N8400, 
     U1329_C4__n, U1224_C1__n_1, N8409, N8412, N10575, U1226_C2__n_3, 
     U1226_C2__n_4, U1226_C2__n_6, U1226_C2__n_7, N8406, N8424, N8423, N8422, 
     U860_C1__n, U1052_C2__n, N12088, N8581, U1213_C1__n, U946_C2__n_3, 
     U998_C1__n, N8579, N10030, N10029, N8514, U1206_C1__n, U979_C1__n, N1650, 
     N8522, N8521, N11348, U1091_C1__n, U699_C1__n, N8463, N8467, U734_C2__n, 
     N8466, U874_C2__n, U874_C2__n_1, N8508, N8564, N8356, U1302_C1__n, N11360, 
     N8425, N8565, U1304_C1__n, N8456, N8571, U778_C3__n_1, U1120_C1__n, 
     U778_C3__n_5, U710_C3__n, U657_C3__n, U970_C3__n, U970_C3__n_1, 
     U970_C3__n_2, N7180, U669_C2__n, N7287, N7236, U1069_C1__n, N7168, N7144, 
     N7181, U1307_C1__n, U1251_C2__n, N10027, N9770, N9737, N10943, N10942, 
     U1365_C1__n, N11878, N11877, N11876, N11875, N9784, N10644, N10642, N10641, 
     N9781, N9739, N11398, U812_C1__n, N7357, U1341_C1__n, U1341_C1__n_1, 
     N10356, N9773, N9931, U1246_C1__n, N9772, U1367_C1__n, N11838, N9771, 
     U1243_C1__n, N10287, N9704, N12301, N9775, N11369, U1308_C3__n, N11054, 
     U1234_C1__n, U1234_C1__n_1, U1234_C1__n_2, U1234_C1__n_3, U1234_C1__n_4, 
     U1234_C1__n_5, U1234_C1__n_6, U1234_C1__n_7, N10270, N9794, N10741, N9777, 
     U805_C1__n, U805_C1__n_1, N9718, N9727, N10758, N10084, N10082, N10705, 
     N9720, N7955, N6937, N4159, N10050, N10141, N4016, N2881, N7840, N7305, 
     N7544, N1390, N8381, N3399, N7917, N10621, N5784, N6093, N10353, N10782, 
     N11025, N12194, N1777, N1776, N2058, N1714, N12035, N11968, N1271, N10255, 
     N10215, N7467, N3260, N281, N10333, N9732, U1325_C1__n_2, U1308_C3__n_1, 
     N11055_1, U1164_C1__n_3, U970_C3__n_6, itcnt_1_1, U961_C1__n_1, N8459_1, 
     U958_C1__n_1, U1329_C4__n_3, U1226_C2__n_8, U1226_C2__n_9, out_dimod_r_1_1, 
     N8409_1, code_4_1, n648_1, n654_1, n73_1, N8513_3, N10270_1, N10270_6, 
     U907_C1__n_1, code_1_1, U934_C1__n_1, n703_1, U1091_C1__n_2, msb_a_1, 
     U931_C1__n_2, U1035_C1__n_1, N7145_3, U734_C2__n_3, wr_sfr_1, 
     U1202_C2__n_1, N8467_1, U699_C1__n_1, U683_C1__n_1, en_itcnt_2, wr_idat_1, 
     U1226_C2__n_11, N11360_1, U1302_C1__n_1, N8439_1, U976_C4__n_5, ov_1, 
     U888_C1__n_3, U888_C1__n_4, n766_1, U736_C1__n_1, n780_1, N8540_1, 
     sel_pc_2_1, sel_pc_2_3, N8567_1, sel_op2_1_1, N8514_1, U874_C2__n_4, 
     sel_in_cy_bit_0_1, U752_C1__n_4, N7178_4, N7178_5, U668_C2__n_1, 
     U752_C1__n_2, U752_C1__n_6, U752_C1__n_5, N7163_1, N7163_2, N1650_4, 
     N10255_4, N10255_5, sel_combus_2_1, N8424_1, n859_1, N1650_5, n729_1, 
     N2056_1, U970_C3__n_5, U970_C3__n_10, U778_C3__n_6, sel_alu_0_1, n1099_1, 
     N8373_1, N8373_4, U860_C1__n_1, n813_1, U710_C3__n_4, U710_C3__n_7, 
     U778_C3__n_7, U778_C3__n_8, sel_alu_4_1, U1304_C1__n_1, N8565_1, rst_c_2, 
     cy_1, N8492_1, U874_C2__n_5, rd_idat_1, N12088_1, N8581_2, U1213_C1__n_1, 
     U1226_C2__n_12, ld_acc_2, N10466_2, N10621_1, U946_C2__n_7, U946_C2__n_8, 
     N7305_3, U1226_C2__n_14, U1226_C2__n_18, end_instr_2, N8594_1, N8545_1, 
     N9759, U687_C1__n, U635_C1__n, U635_C1__n_1, U1115_C1__n, U673_C1__n, 
     U841_C1__n, U841_C1__n_1, N1699, N9892, U731_C1__n, U843_C1__n, U730_C1__n, 
     U730_C1__n_1, U730_C1__n_2, U916_C1__n, U1134_C3_1_C3__n, U661_C1__n, 
     N9869, N9871, N9880, N9883, N12221, U1156_C1__n_1, U1156_C1__n_2, N9887, 
     N9888, N9889, N9870, N9868, N9872, N4696, N9216, N7562, U764_C1__n, 
     U663_C1__n, U663_C1__n_1, U1382_C1__n, U686_C1__n, U1377_C1__n, N10703, 
     N511, N7672, N3477, U681_C1__n, U680_C1__n, U680_C1__n_1, U638_C1__n, 
     U833_C1__n, U718_C4__n, U729_C1__n, U718_C4__n_2, U718_C4__n_3, N7007, 
     N1593, U906_C1__n, U662_C1__n, U662_C1__n_1, U642_C3__n, U642_C3__n_1, 
     U707_C2__n, N8595, N4897, N5005, U682_C3__n, N8465, N1456, U652_C1__n, 
     N10801, U692_C3__n, U692_C3__n_1, U692_C3__n_2, U692_C3__n_3, U692_C3__n_4, 
     N10133, U692_C3__n_6, N10865, N4824, N4835, N4603, N4946, N8569, N10766, 
     N4591, N4948, N7151, N4834, N4929, N1909, N4842, N11309, N4213, N2103, 
     N8502, N1502, N1781, N3913, N9884, N7565, N4906, U663_C1__n_2, 
     U664_C1__n_1, U662_C1__n_2, U687_C1__n_2, N9216_1, U715_C1__n_1, 
     U673_C1__n_1, U841_C1__n_2, U686_C1__n_1, U670_C1__n_1, U670_C1__n_2, 
     N9892_3, N8589_1, N8589_3, n560_1, U681_C1__n_3, U718_C4__n_6, 
     U718_C4__n_8, U841_C1__n_3, U707_C2__n_1, N1456_1, N4582_1, N10703_1, 
     N4823_1, N4833_1, U764_C1__n_1, U642_C3__n_2, sel_in_cy_bit_2_1, N4897_1, 
     U682_C3__n_1, N10787_1, N5958_1, U692_C3__n_7, U692_C3__n_10, N5958_3, 
     N5348_2, U692_C3__n_8, U692_C3__n_9, U692_C3__n_12, U692_C3__n_13, 
     U692_C3__n_14, U692_C3__n_17, N8589_4, U718_C4__n_9, sel_addr1_1_1, 
     sel_addr1_1_2, N10705_1, U718_C4__n_4, N1719_1, N4066_3, sel_addr1_0_1, 
     sel_addr1_0_2, N3477_1, N3388_1, sel_addr1_2_1, U843_C1__n_1, U730_C1__n_3, 
     U730_C1__n_4, U730_C1__n_6, U916_C1__n_1, U1134_C3_1_C3__n_4, 
     U1134_C3_1_C3__n_6, U1134_C3_1_C3__n_7, N2154_1, N5011_3, N5011_5, N6103_1, 
     N6103_3, N6103_4, N6103_5, N1781_1, N1781_2, N1781_3, N1781_4, ld_pc_1, 
     ld_pc_2, ld_pc_3, ld_pc_4, out_acc_r_5_1, out_acc_r_4_1, out_acc_r_3_1, 
     in_xrom1_r_6_1, in_xrom1_r_5_1, in_xrom1_r_3_1, in_xrom1_r_4_1, 
     in_xrom1_r_2_1, in_xrom1_r_1_1, N11369_1, U1134_C3_1_C3__n_2, combus_7_1, 
     combus_6_1, combus_0_1, N1781_5, bit_dat_in_r_1, ld_pc_5, combus_3_1, 
     combus_2_1, combus_1_1, en_div_1, N9892_4, N8589_5, U958_C1__n_2, rmw_1, 
     U1035_C1__n_2, U841_C1__n_4, N9216_2, N9216_3, U841_C1__n_5, U715_C1__n_3, 
     U715_C1__n_4, U635_C1__n_3, U664_C1__n_2, U664_C1__n_3, N511_1, 
     U670_C1__n_3, U635_C1__n_4, U635_C1__n_5, N10703_2, test_so_1, 
     U1115_C1__n_2, U715_C1__n_2, U635_C1__n_2, N10466_1, rmw_2, sel_alu_3_1, 
     addr_bank_a_2_1, addr_bank_a_1_1, U692_C3__n_15, sel_addr1_2_2, N8513_1, 
     U680_C1__n_2, U1382_C1__n_1, U662_C1__n_3;
  supply1 VDD;
  supply0 VSS;
  XOR2X1 U813_C1 (.A(\itcnt[2] ), .B(N11398), .Y(U812_C1__n));
  AND3X2 U1108_C2_2 (.A(n565), .B(\itcnt[1] ), .C(\itcnt[0] ), .Y(U998_C1__n));
  INVX1 U1329_C4_MP_INV (.A(out_dimod_r[1]), .Y(out_dimod_r_1_1));
  XOR2X1 U806_C1 (.A(out_acc_r[7]), .B(combus[7]), .Y(U805_C1__n));
  u_con_DW01_cmp2_8_2 lt_1408 (.A({out_acc_r[7], out_acc_r[6], out_acc_r[5], 
     out_acc_r[4], out_acc_r[3], out_acc_r[2], out_acc_r[1], out_acc_r[0]}), .B({
     combus[7], combus[6], combus[5], combus[4], combus[3], combus[2], 
     combus[1], combus[0]}), .LEQ(VSS), .TC(VSS), .LT_LE(N283), .GE_GT());
  INVX1 U776_C3_3_MP_INV_1 (.A(n560), .Y(n560_1));
  NOR2X1 U860_C1 (.A(U635_C1__n_3), .B(U860_C1__n), .Y(U1052_C2__n));
  NAND2X1 U1051_C1 (.A(U715_C1__n_4), .B(N9892_4), .Y(N8422));
  MX2X1 U1308_C3_5 (.A(N4582_1), .B(U662_C1__n), .S0(U1308_C3__n), .Y(N11055_1));
  NAND2X1 U836_C1_C1 (.A(U841_C1__n_4), .B(N511_1), .Y(sel_in_cy_bit_2_1));
  AOI31X1 U1166_C2_7 (.A0(N9892), .A1(N11055_1), .A2(N11054), .B0(U958_C1__n_1), 
     .Y(U1164_C1__n_3));
  AOI22X1 U780_C2_4 (.A0(N4948), .A1(U1035_C1__n_2), .B0(U635_C1__n_5), 
     .B1(U961_C1__n), .Y(sel_alu_4_1));
  OAI21X1 U781_C2_2 (.A0(sel_in_cy_bit[2]), .A1(msb_a), .B0(N10353), .Y(N7180));
  OAI221X4 U1032_C2_5 (.A0(U958_C1__n_1), .A1(N8594), .B0(msb_a), .B1(N8521), 
     .C0(N11348), .Y(ld_idat));
  NOR2X1 U1302_C1 (.A(ac), .B(U1302_C1__n), .Y(rst_ac));
  INVX1 U1159_C1_4_C4_7_MP_INV_2 (.A(combus[6]), .Y(combus_6_1));
  XNOR2X1 U1335_C1 (.A(out_acc_r[0]), .B(in_xrom1_r[0]), .Y(U1234_C1__n_5));
  INVX1 U1275_C1_MP_INV (.A(in_xrom1_r[4]), .Y(in_xrom1_r_4_1));
  INVX1 U1273_C1_MP_INV (.A(in_xrom1_r[2]), .Y(in_xrom1_r_2_1));
  NOR4BX1 U1325_C1_1 (.AN(U1325_C1__n_2), .B(out_acc_r[5]), .C(out_acc_r[4]), 
     .D(out_acc_r[0]), .Y(U1308_C3__n_1));
  XNOR2X1 U1338_C1 (.A(out_acc_r[2]), .B(in_xrom1_r[2]), .Y(U1234_C1__n_3));
  INVX2 U1028_C2_1_MP_INV (.A(wr_sfr_1), .Y(wr_sfr));
  INVX1 U1296_C3_11_MP_INV_2 (.A(N9869), .Y(n766_1));
  NOR2X2 U826_C1 (.A(U958_C1__n_1), .B(U1091_C1__n_2), .Y(ld_acc_chd));
  AOI2BB2X1 U954_C1_4 (.A0N(msb_a), .A1N(N5784), .B0(N8589_5), .B1(N8564), 
     .Y(rd_idat_1));
  OAI21X1 U1178_C2_1 (.A0(N8589_4), .A1(N4591), .B0(N10177), .Y(N8370));
  INVX1 U752_C1_4_MP_INV_1 (.A(U752_C1__n_1), .Y(U752_C1__n_6));
  NAND4X1 U956_C2_9 (.A(N7007), .B(U752_C1__n), .C(U699_C1__n), .D(U1202_C2__n), 
     .Y(N1776));
  AOI31X4 U692_C3_3 (.A0(U692_C3__n_14), .A1(U692_C3__n_13), .A2(U692_C3__n_10), 
     .B0(U692_C3__n_6), .Y(sel_addr0_1));
  INVX1 \U692_C3_1/C1_1  (.A(N9216_3), .Y(U692_C3__n_4));
  NOR4X1 U970_C3_7 (.A(U998_C1__n), .B(U970_C3__n_1), .C(U970_C3__n), 
     .D(U1304_C1__n), .Y(U970_C3__n_10));
  AOI22X1 U669_C2_11 (.A0(N10082), .A1(U1052_C2__n), .B0(N4835), .B1(N7955), 
     .Y(N7163_1));
  NAND4X1 U970_C3_2 (.A(U718_C4__n_3), .B(U970_C3__n_5), .C(U970_C3__n_10), 
     .D(U752_C1__n_1), .Y(sel_combus[3]));
  OAI22X1 U951_C2_2 (.A0(msb_a), .A1(U752_C1__n), .B0(U730_C1__n), .B1(msb_r), 
     .Y(N7181));
  INVX1 U1385_C1_MP_INV (.A(U686_C1__n_1), .Y(U686_C1__n));
  NOR2X2 U686_C1_2 (.A(U686_C1__n_1), .B(U670_C1__n_1), .Y(U670_C1__n_2));
  AND2X2 U1104_C1 (.A(U764_C1__n), .B(N10766), .Y(U683_C1__n));
  NAND2BX1 U1385_C1 (.AN(code[7]), .B(code[6]), .Y(U686_C1__n_1));
  INVX1 U1357_C2_1_MP_INV (.A(N8545), .Y(N8545_1));
  INVX1 U1226_C2_7_MP_INV (.A(N8594), .Y(N8594_1));
  NOR2X1 U1049_C1_6 (.A(N8545), .B(N8364), .Y(N8581_2));
  NAND2X1 U985_C1 (.A(N9892_4), .B(N10703_2), .Y(N8594));
  NAND4X2 U657_C3_5 (.A(N8456), .B(N8440), .C(N8373_4), .D(N10050), 
     .Y(sel_alu[1]));
  BUFX3 BL3_S_BUF_3 (.A(N10466_1), .Y(N10466));
  INVX1 U836_C1_C1_MP_INV (.A(sel_in_cy_bit_2_1), .Y(sel_in_cy_bit[2]));
  NAND3BX1 U979_C1_5 (.AN(sel_bit_dat_out[0]), .B(U692_C3__n), .C(N1650_4), 
     .Y(N1650_5));
  NOR3X1 U776_C3_3 (.A(N8589_1), .B(n561), .C(n560_1), .Y(N8589_3));
  OAI2BB2X1 U1317_C4_1 (.A0N(N11875), .A1N(N10943), .B0(n620), .B1(N8409), 
     .Y(N9784));
  NOR4BX1 U627_C3_3 (.AN(code[7]), .B(code[4]), .C(code[6]), .D(code[5]), 
     .Y(N9892_3));
  NOR2X4 U663_C1 (.A(U663_C1__n_2), .B(U663_C1__n), .Y(U664_C1__n_1));
  NAND2BX2 U658_C1 (.AN(code[5]), .B(code[4]), .Y(U663_C1__n_2));
  NAND3X1 U765_C1_2 (.A(N8589_5), .B(code[3]), .C(N8513), .Y(N10084));
  INVX1 U1024_C1_1_MP_INV_1 (.A(N8513), .Y(N8513_3));
  NOR2X2 U640_C2_4 (.A(U681_C1__n_3), .B(U1115_C1__n_2), .Y(U681_C1__n));
  AOI32X1 U1219_C2_2 (.A0(U934_C1__n_1), .A1(U1139_C1__n), .A2(N8439_1), 
     .B0(U976_C4__n_5), .B1(N8356), .Y(U1302_C1__n_1));
  INVX2 U750_C2_1_MP_INV (.A(U683_C1__n), .Y(U683_C1__n_1));
  NOR3X2 U642_C3_3 (.A(U642_C3__n_1), .B(N5958_1), .C(U642_C3__n_2), .Y(N5958_3));
  NAND4X1 U640_C2_3 (.A(N8569), .B(N4603), .C(N10865), .D(code[5]), 
     .Y(U681_C1__n_3));
  INVX1 U767_C1 (.A(U661_C1__n), .Y(N11309));
  OAI21X1 U1179_C2_1 (.A0(N9892), .A1(U736_C1__n_1), .B0(N10858), 
     .Y(U970_C3__n_2));
  AOI21X1 U1206_C1_2 (.A0(\timing_cnt[2] ), .A1(N8514_1), .B0(en_div_1), 
     .Y(U1206_C1__n));
  OAI211X1 U1114_C2_4 (.A0(U1115_C1__n_2), .A1(N8513_3), .B0(N10703), 
     .C0(N10062), .Y(U1109_C1__n));
  NOR3BX1 U712_C2_2 (.AN(U712_C2__n), .B(ld_apc), .C(ld_adptr), .Y(N10858));
  NAND2X1 U1069_C1 (.A(U718_C4__n_2), .B(U1069_C1__n), .Y(sel_pc[0]));
  AND2X1 U1320_C1 (.A(extend_rd), .B(N10029), .Y(rd_xdat));
  NOR2BX1 U1253_C1 (.AN(en_int1), .B(rst_p), .Y(N9704));
  NAND3X1 U1343_C4_10 (.A(out_dimod_r[2]), .B(out_dimod_r_1_1), .C(N4824), 
     .Y(N281));
  NAND3BX1 U1251_C2_2 (.AN(U1251_C2__n), .B(n73_1), .C(U1226_C2__n_7), 
     .Y(N10027));
  OAI2BB1X2 U1378_C1_13 (.A0N(N1719_1), .A1N(N10787_1), .B0(sel_addr1_0_1), 
     .Y(sel_addr1_0_2));
  NAND2BX1 U718_C4_5 (.AN(N8589_3), .B(N3913), .Y(N1593));
  NAND2X1 U931_C1 (.A(U642_C3__n), .B(U931_C1__n), .Y(U976_C4__n));
  NOR3BX2 U1120_C1_7 (.AN(U778_C3__n_6), .B(sel_in_cy_bit[1]), .C(U1120_C1__n), 
     .Y(U778_C3__n_5));
  INVX1 U688_C1 (.A(U729_C1__n), .Y(N4948));
  INVX1 U1383_C1 (.A(U715_C1__n_2), .Y(N4833_1));
  OAI211X1 U1116_C3_4 (.A0(U683_C1__n_1), .A1(U1035_C1__n_1), .B0(U730_C1__n), 
     .C0(U979_C1__n), .Y(U1120_C1__n));
  NOR2BX1 U888_C1_2 (.AN(U1377_C1__n), .B(U888_C1__n), .Y(N10466_2));
  AOI21X2 U716_C2_1 (.A0(U1377_C1__n), .A1(N8423), .B0(N8589_4), .Y(ld_operand2));
  NAND4BX1 U1066_C2_7 (.AN(sel_in_cy_bit[2]), .B(N1699), .C(N1650), 
     .D(U730_C1__n), .Y(N2881));
  NAND3X1 U675_C2_2 (.A(U687_C1__n_2), .B(code[0]), .C(code[4]), 
     .Y(U680_C1__n_2));
  BUFX8 BL3_S_BUF_21 (.A(addr_bank_a_1_1), .Y(addr_bank_a[1]));
  INVX1 U1375_C1 (.A(N10865), .Y(addr_bank_a[0]));
  NAND4X1 U946_C2_11 (.A(U680_C1__n_1), .B(U692_C3__n_8), .C(N8594), 
     .D(N10621_1), .Y(N10621));
  SDFFSRX4 timing_cnt_reg_0_ (.CK(clk0_14), .D(N9773), .Q(\timing_cnt[0] ), 
     .QN(n561), .RN(N9737), .SE(test_se), .SI(\t_2[3] ), .SN(VDD));
  AOI21X1 U1372_C2_3 (.A0(itcnt_1_1), .A1(n566), .B0(n565), .Y(N8381));
  NAND2BX1 U1361_C4_3 (.AN(U1251_C2__n), .B(U1307_C1__n), .Y(N7840));
  SDFFSRX1 t_2_reg_0_ (.CK(clk0_14), .D(N10942), .Q(\t_2[0] ), .QN(n569), 
     .RN(N9737), .SE(test_se), .SI(n2), .SN(VDD));
  u_con_DW01_cmp2_8_4 gte_1432 (.A({combus[7], combus[6], combus[5], combus[4], 
     combus[3], combus[2], combus[1], combus[0]}), .B({out_acc_r[7], out_acc_r[6], 
     out_acc_r[5], out_acc_r[4], out_acc_r[3], out_acc_r[2], out_acc_r[1], 
     out_acc_r[0]}), .LEQ(VDD), .TC(VSS), .LT_LE(N288), .GE_GT());
  NAND2X1 U701_C1 (.A(N9727), .B(n560), .Y(N8328));
  INVX1 U1296_C3_13_MP_INV (.A(U736_C1__n), .Y(U736_C1__n_1));
  INVX1 U1134_C3_1_MP_INV_1 (.A(U1382_C1__n), .Y(n648_1));
  AOI22X1 U1141_C1_3 (.A0(U1035_C1__n_2), .A1(N8513), .B0(n1099_1), 
     .B1(U961_C1__n), .Y(U778_C3__n_7));
  NOR2BX1 U1094_C1 (.AN(U707_C2__n), .B(U635_C1__n_5), .Y(N1456_1));
  MX2X1 U1166_C2_2 (.A(U662_C1__n_1), .B(N8459_1), .S0(cy_psw), .Y(N11054));
  NAND3X1 U1191_C2_2 (.A(U692_C3__n), .B(N7007), .C(U960_C2__n_1), .Y(N8463));
  AOI31X1 U1163_C2_1 (.A0(N6103_5), .A1(N9868), .A2(N6103_4), .B0(U888_C1__n_1), 
     .Y(N7562));
  OAI211X1 U644_C1_7 (.A0(N1456_1), .A1(N10177), .B0(N7917), .C0(N3399), 
     .Y(sel_op1[2]));
  INVX1 U1304_C1_1_MP_INV (.A(U1304_C1__n), .Y(U1304_C1__n_1));
  AOI32X4 U1028_C2_1 (.A0(n654_1), .A1(N4835), .A2(msb_r), .B0(msb_a), 
     .B1(N7144), .Y(wr_sfr_1));
  INVX1 U1281_C1_MP_INV (.A(out_acc_r[4]), .Y(out_acc_r_4_1));
  NOR3X1 U1159_C1_4_C4_5 (.A(combus_3_1), .B(combus_2_1), .C(U1134_C3_1_C3__n_6), 
     .Y(U1134_C3_1_C3__n_7));
  NAND3X1 U1163_C2_10 (.A(N9872), .B(N6103_1), .C(N11369_1), .Y(N6103_3));
  NOR3X1 U1156_C1_9 (.A(N9871), .B(N5011_3), .C(N9883), .Y(N5011_5));
  XNOR2X1 U1285_C1 (.A(out_acc_r_3_1), .B(combus_3_1), .Y(N9883));
  XNOR2X1 U1339_C1 (.A(out_acc_r[5]), .B(in_xrom1_r[5]), .Y(U1234_C1__n));
  NAND2X1 U1296_C3_8 (.A(cy), .B(N8425), .Y(N11968));
  NAND2X1 U730_C1_1 (.A(U730_C1__n), .B(U730_C1__n_4), .Y(U916_C1__n_1));
  AOI2BB1X1 U970_C3_3 (.A0N(N4929), .A1N(N8424), .B0(U970_C3__n_2), 
     .Y(U970_C3__n_5));
  NOR4BBX1 U669_C2_12 (.AN(N3477), .BN(N1714), .C(ld_acc_chd), .D(U970_C3__n_2), 
     .Y(N7163_2));
  NAND2X1 U751_C1 (.A(U715_C1__n_4), .B(U683_C1__n), .Y(U752_C1__n));
  NOR2X1 U699_C1 (.A(U699_C1__n_1), .B(N8406), .Y(N8467));
  INVX1 U930_C2_1_MP_INV (.A(U699_C1__n_1), .Y(U699_C1__n));
  AOI21X1 U972_C2_4 (.A0(N10703_2), .A1(N1456), .B0(U874_C2__n_4), .Y(N2056_1));
  AOI211X1 U956_C2_11 (.A0(N1777), .A1(N1776), .B0(N8540), .C0(N8508), .Y(N5784));
  NAND4X1 U669_C2_8 (.A(N8579), .B(N7544), .C(N7163_2), .D(N7163_1), 
     .Y(sel_combus[1]));
  AOI22X1 U668_C2_5 (.A0(msb_r), .A1(N7287), .B0(U730_C1__n_1), .B1(msb_a), 
     .Y(N7236));
  INVX2 U728_C2_2_MP_INV (.A(msb_a), .Y(msb_a_1));
  INVX2 U961_C1_MP_INV (.A(U961_C1__n), .Y(U961_C1__n_1));
  AND2X1 U927_C1 (.A(U906_C1__n), .B(U686_C1__n), .Y(N8459));
  OAI211X4 U1088_C3_6 (.A0(n566), .A1(\itcnt[2] ), .B0(N8579), .C0(N1271), 
     .Y(inc_sp));
  AND2X1 U1222_C1_3 (.A(sel_in_cy_bit_0_1), .B(U673_C1__n), .Y(sel_in_cy_bit[0]));
  NOR2BX1 U906_C1 (.AN(U906_C1__n), .B(U686_C1__n_1), .Y(U642_C3__n_2));
  NOR3X1 U1226_C2_7 (.A(rmw_1), .B(N8594_1), .C(N8364), .Y(N7305_3));
  OAI32X1 U1357_C2_1 (.A0(U663_C1__n), .A1(code[5]), .A2(U736_C1__n_1), 
     .B0(U718_C4__n), .B1(N8545_1), .Y(U1226_C2__n_1));
  NAND2BX4 U1384_C1 (.AN(U635_C1__n_1), .B(U664_C1__n_3), .Y(N7007));
  NAND2X1 U845_C1 (.A(N4948), .B(U841_C1__n_4), .Y(U979_C1__n));
  NAND3X1 U780_C2_6 (.A(sel_alu_4_1), .B(U1091_C1__n_2), .C(N8456), 
     .Y(sel_alu[4]));
  INVX1 U1277_C1_MP_INV (.A(in_xrom1_r[6]), .Y(in_xrom1_r_6_1));
  INVX1 U1159_C1_4_C4_7_MP_INV (.A(U1134_C3_1_C3__n_2), .Y(U1134_C3_1_C3__n));
  NAND2X1 U690_C1_1 (.A(U833_C1__n), .B(U690_C1__n), .Y(U958_C1__n));
  NOR2BX1 U1248_C1 (.AN(U1341_C1__n_1), .B(\timing_cnt[0] ), .Y(N9773));
  NAND2X1 U1219_C2 (.A(N8589_5), .B(U1035_C1__n_2), .Y(N8356));
  NAND2X1 U673_C1_1 (.A(code[5]), .B(code[4]), .Y(U841_C1__n_2));
  OAI2BB2X1 U1313_C4_1 (.A0N(N11877), .A1N(N10943), .B0(n570), .B1(N8409), 
     .Y(N11876));
  INVX2 BL2_INV37 (.A(U664_C1__n_1), .Y(U664_C1__n_2));
  OAI2BB1X1 U1224_C1 (.A0N(N4016), .A1N(N10141), .B0(n560), .Y(N8412));
  SDFFSRX1 t_2_reg_1_ (.CK(clk0_14), .D(N9784), .Q(\t_2[1] ), .QN(n620), 
     .RN(N9737), .SE(test_se), .SI(\t_2[0] ), .SN(VDD));
  NAND4X1 U1255_C3_3 (.A(N4603), .B(N4946), .C(code[7]), .D(code[4]), 
     .Y(U1139_C1__n));
  NOR4X1 U1071_C4_8 (.A(sel_page_addr), .B(ld_pcl), .C(ld_dpl), .D(inc_dptr), 
     .Y(U1226_C2__n_18));
  NAND2X1 U925_C1 (.A(N511_1), .B(U1035_C1__n_2), .Y(N8514));
  NAND2BX1 U1182_C2_3 (.AN(N8442), .B(N2703), .Y(N1390));
  NOR2BX1 U1216_C1_4 (.AN(N10858), .B(ld_b), .Y(U1226_C2__n_12));
  NOR2X1 U1045_C1_8 (.A(sel_pc_2_1), .B(U1226_C2__n_6), .Y(sel_pc_2_3));
  SDFFRHQX2 itcnt_reg_1_ (.CK(clk0_14), .D(N11838), .Q(\itcnt[1] ), .RN(N9737), 
     .SE(test_se), .SI(\itcnt[0] ));
  NOR2X1 U873_C1 (.A(U1307_C1__n), .B(N10029), .Y(sel_code_xdat));
  AND2X1 U1070_C1 (.A(U681_C1__n), .B(U958_C1__n_2), .Y(ld_pcl));
  INVX8 BL2_INV36 (.A(U635_C1__n_2), .Y(U635_C1__n_3));
  NOR2X1 U1163_C2_21 (.A(sel_page_addr), .B(U970_C3__n), .Y(ld_pc_1));
  NAND2BX1 U661_C1_1 (.AN(code[1]), .B(code[0]), .Y(U715_C1__n_1));
  BUFX4 BA1_BUF444 (.A(N9892_3), .Y(N9892_4));
  XNOR2X1 U1354_C1 (.A(out_dimod_r[1]), .B(N4824), .Y(N12077));
  NAND3X1 U1343_C4_12 (.A(out_dimod_r[0]), .B(n561), .C(N8400), .Y(N10141));
  NOR2X1 U1378_C1_6 (.A(N511), .B(n561), .Y(N1719_1));
  BUFX8 BL3_S_BUF_27 (.A(U1382_C1__n_1), .Y(U1382_C1__n));
  AND3X1 U710_C3_6 (.A(U710_C3__n_4), .B(N8514), .C(N8436), .Y(U710_C3__n_7));
  OAI21X2 U652_C1_2 (.A0(N10801), .A1(U958_C1__n_1), .B0(N10084), 
     .Y(U692_C3__n_3));
  AOI22X1 U1120_C1_5 (.A0(N8459), .A1(N12194), .B0(U961_C1__n), .B1(N8439), 
     .Y(U778_C3__n_6));
  AOI22X1 U778_C3_6 (.A0(U642_C3__n_1), .A1(N2058), .B0(U664_C1__n_3), 
     .B1(U961_C1__n), .Y(U778_C3__n_8));
  OAI2BB2X2 U837_C1_1 (.A0N(U670_C1__n_3), .A1N(U841_C1__n_4), .B0(N4842), 
     .B1(U635_C1__n_3), .Y(sel_in_cy_bit[1]));
  NOR2X1 U1106_C1 (.A(N4582_1), .B(N4591), .Y(N10758));
  NAND4X1 U781_C2_15 (.A(n859_1), .B(U888_C1__n_1), .C(N10255_5), .D(N10255_4), 
     .Y(N10255));
  NAND2X1 U683_C1 (.A(U1115_C1__n), .B(U683_C1__n), .Y(N10062));
  NOR4X1 U1310_C1_3 (.A(N8589_4), .B(code[4]), .C(U687_C1__n), .D(N10865), 
     .Y(sel_page_addr_1));
  NOR2X1 U1109_C1 (.A(N4834), .B(U1109_C1__n), .Y(addr_bank_a_2_1));
  NAND3X1 U964_C2_2 (.A(N8589_5), .B(U670_C1__n_3), .C(U1035_C1__n_2), 
     .Y(U712_C2__n));
  NOR2X1 U812_C1 (.A(N9759), .B(U812_C1__n), .Y(N7357));
  INVX1 U1251_C2_2_MP_INV (.A(sel_code_xdat), .Y(n73_1));
  OAI31X1 U1343_C4_1 (.A0(out_dimod_r[2]), .A1(out_dimod_r_1_1), .A2(N4824), 
     .B0(N281), .Y(N8400));
  INVX1 U654_C2_2_MP_INV (.A(sel_op2_1_1), .Y(sel_op2[1]));
  INVX1 U698_C1 (.A(test_so_1), .Y(N9727));
  SDFFSRX1 t_2_reg_3_ (.CK(clk0_14), .D(N11876), .Q(\t_2[3] ), .QN(n570), 
     .RN(N9737), .SE(test_se), .SI(\t_2[2] ), .SN(VDD));
  OAI222X1 U1039_C3_6 (.A0(U958_C1__n_1), .A1(N12081), .B0(N4582_1), 
     .B1(U736_C1__n_1), .C0(N9216_3), .C1(N8462), .Y(U1226_C2__n_6));
  OAI211X1 U1049_C1_7 (.A0(N4582_1), .A1(U907_C1__n), .B0(N8581_2), .C0(N12088), 
     .Y(N8581));
  NAND2BX2 U635_C1 (.AN(U635_C1__n_1), .B(U635_C1__n_5), .Y(U730_C1__n));
  INVX1 U843_C1_2_MP_INV (.A(U730_C1__n_6), .Y(U730_C1__n_2));
  NAND3X1 U843_C1_2 (.A(U843_C1__n_1), .B(sel_in_cy_bit_2_1), .C(N8462), 
     .Y(U730_C1__n_6));
  NAND3X4 U707_C2_2 (.A(n780_1), .B(U707_C2__n), .C(U729_C1__n), .Y(N8595));
  NAND3X4 U1376_C3_8 (.A(N1502), .B(N8502), .C(sel_addr1_2_1), .Y(sel_addr1_2_2));
  AOI21X1 U1156_C1_3 (.A0(N9718), .A1(N5011_5), .B0(N9869), .Y(U1156_C1__n_2));
  AOI21X1 U1304_C1_1 (.A0(U1304_C1__n_1), .A1(U1302_C1__n), .B0(ov), .Y(rst_v));
  INVX1 U1159_C1_4_C4_7_MP_INV_1 (.A(combus[7]), .Y(combus_7_1));
  XNOR2X1 U1283_C1 (.A(out_acc_r[2]), .B(combus_2_1), .Y(N12221));
  NOR2X1 U1326_C3_2 (.A(out_acc_r[7]), .B(out_acc_r[6]), .Y(U1325_C1__n_2));
  INVX1 U1285_C1_MP_INV (.A(out_acc_r[3]), .Y(out_acc_r_3_1));
  XOR2X1 U1272_C1 (.A(in_xrom1_r[0]), .B(combus[0]), .Y(N11369));
  NOR2X1 U1234_C1_1 (.A(U1234_C1__n_7), .B(U1234_C1__n_6), .Y(N10270_1));
  BUFX1 BL1_BUF262 (.A(combus[2]), .Y(combus_2_1));
  NAND2X2 U1382_C1 (.A(U730_C1__n), .B(U1382_C1__n), .Y(N7672));
  NOR2X1 U840_C2_2 (.A(U730_C1__n_3), .B(sel_bit_dat_out[1]), .Y(U730_C1__n_4));
  OAI211X1 U1010_C2_4 (.A0(N8543), .A1(N8424), .B0(N3477), .C0(U970_C3__n_6), 
     .Y(N7145_3));
  INVX1 U1377_C1_MP_INV (.A(N3477_1), .Y(N3477));
  OAI31X1 U734_C2_3 (.A0(U752_C1__n_2), .A1(U734_C2__n), .A2(U692_C3__n_2), 
     .B0(N8589_5), .Y(N6093));
  INVX1 U790_C1_MP_INV (.A(N4897_1), .Y(N4897));
  NAND2X1 U743_C1 (.A(U958_C1__n_2), .B(N4897_1), .Y(N10133));
  AOI31X1 U874_C2_2 (.A0(U916_C1__n), .A1(U874_C2__n_5), .A2(U874_C2__n_1), 
     .B0(N8424), .Y(N8508));
  NAND3BX1 U781_C2_17 (.AN(ld_acc_chd), .B(sel_combus_2_1), .C(U970_C3__n_6), 
     .Y(sel_combus[2]));
  AOI221X1 U1036_C3_5 (.A0(U958_C1__n_2), .A1(N10030), .B0(N4835), .B1(N10029), 
     .C0(U1226_C2__n_4), .Y(ld_acc_2));
  OR2X1 U669_C2_7 (.A(N10030), .B(N10029), .Y(N7955));
  AOI22X1 U951_C2_8 (.A0(msb_a_1), .A1(N7144), .B0(N4835), .B1(N7181), 
     .Y(wr_idat_1));
  AOI22X1 U976_C4_5 (.A0(U736_C1__n), .A1(N6937), .B0(U976_C4__n_1), 
     .B1(U976_C4__n), .Y(U752_C1__n_4));
  NAND2X1 U686_C1_1 (.A(code[5]), .B(code[4]), .Y(U670_C1__n_1));
  INVX8 BL2_INV38 (.A(U664_C1__n_2), .Y(U664_C1__n_3));
  INVX2 U1268_C1_MP_INV (.A(code[4]), .Y(code_4_1));
  INVX2 U1115_C1_MP_INV (.A(U841_C1__n_3), .Y(U841_C1__n));
  INVX4 U706_C1 (.A(N9216_3), .Y(N4835));
  INVX1 BL2_INV33 (.A(U715_C1__n_2), .Y(U715_C1__n_3));
  INVX2 BL2_INV34 (.A(U715_C1__n_3), .Y(U715_C1__n_4));
  OAI2BB1X1 U1177_C3_10 (.A0N(n766_1), .A1N(N288), .B0(N8565_1), .Y(N8565));
  NOR2X1 U1164_C1_7_C2_4 (.A(U958_C1__n_1), .B(N8465), .Y(N2154_1));
  INVX1 U840_C2_2_MP_INV (.A(U730_C1__n_4), .Y(U730_C1__n_1));
  NAND3X1 U1075_C2_4 (.A(U1302_C1__n), .B(N4159), .C(N11360), .Y(N8425));
  XNOR2X1 U1314_C1 (.A(n570), .B(N11878), .Y(N11877));
  NAND2X1 U1364_C1 (.A(\timing_cnt[1] ), .B(\timing_cnt[0] ), .Y(N9931));
  NOR2X2 U673_C1_2 (.A(U673_C1__n_1), .B(U841_C1__n_2), .Y(U841_C1__n_1));
  AND2X1 U1246_C1 (.A(U1341_C1__n_1), .B(U1246_C1__n), .Y(N9772));
  NOR2X1 U1097_C2 (.A(N10787_1), .B(N10703), .Y(U682_C3__n_1));
  SDFFRHQX1 extend_mux_reg (.CK(clk0_14), .D(N9770), .Q(extend_mux), .RN(N9737), 
     .SE(test_se), .SI(test_si));
  NAND2BX1 U1061_C2_2 (.AN(rmw_1), .B(N10466), .Y(N11025));
  NAND3X2 U1105_C2_2 (.A(N9727), .B(n560), .C(N4824), .Y(U669_C2__n));
  AOI22X1 U1239_C3_2 (.A0(N8589_5), .A1(N8522), .B0(U841_C1__n_5), .B1(N8370), 
     .Y(N11348));
  NOR2X1 U682_C3_6 (.A(N5958_3), .B(N5005), .Y(N2103));
  NAND2X1 U976_C4_4 (.A(U707_C2__n), .B(N8439_1), .Y(N6937));
  INVX1 U976_C4_7_MP_INV (.A(U752_C1__n_4), .Y(U752_C1__n_5));
  AOI32X1 U1085_C3_1 (.A0(U841_C1__n_4), .A1(N1456), .A2(U958_C1__n_2), 
     .B0(U670_C1__n_3), .B1(U736_C1__n), .Y(U1069_C1__n));
  AOI22X2 U718_C4_11 (.A0(U718_C4__n_9), .A1(N4835), .B0(U681_C1__n), 
     .B1(U718_C4__n_4), .Y(sel_addr1_1_2));
  INVX1 U745_C2_1_MP_INV (.A(N8514), .Y(N8514_1));
  BUFX2 BW1_BUF2645 (.A(ld_b_1), .Y(ld_b));
  AOI21X1 U1024_C1_1 (.A0(U635_C1__n_3), .A1(U1115_C1__n_2), .B0(N8513_3), 
     .Y(U1307_C1__n));
  NAND2BX2 U666_C1 (.AN(code[3]), .B(code[2]), .Y(U661_C1__n));
  NOR2X1 U1115_C1 (.A(U1115_C1__n_2), .B(code[0]), .Y(U841_C1__n_3));
  XNOR2X2 \test_point_518/U6_C4  (.A(rst_p), .B(rc8051RtlTop_test_mode_in), 
     .Y(N9737));
  AND2X1 U1307_C1 (.A(extend_wr), .B(U1307_C1__n), .Y(wr_xdat));
  OAI2BB1X1 U1355_C3_1 (.A0N(extend_mux), .A1N(U1226_C2__n_7), .B0(N10027), 
     .Y(N9770));
  NOR2BX1 U1378_C1_12 (.AN(N9720), .B(n563), .Y(sel_addr1_0_1));
  NAND2X2 U833_C1 (.A(U833_C1__n), .B(U690_C1__n), .Y(U718_C4__n));
  OAI21X1 U657_C3_6 (.A0(U1035_C1__n_2), .A1(N8571), .B0(n813_1), .Y(N10050));
  OAI21X1 U935_C1_3 (.A0(U710_C3__n), .A1(U961_C1__n), .B0(n1099_1), .Y(N7467));
  OR2X1 U778_C3_5 (.A(U1035_C1__n_2), .B(N8571), .Y(N2058));
  INVX1 U1166_C2_2_MP_INV (.A(N8459), .Y(N8459_1));
  INVX1 U912_C1_1_MP_INV (.A(U841_C1__n_5), .Y(n703_1));
  NOR2X1 U929_C1 (.A(N10703), .B(N4823_1), .Y(U1091_C1__n));
  INVX1 U781_C2_12_MP_INV (.A(N7007), .Y(n729_1));
  INVX1 U1202_C2_1_MP_INV_1 (.A(U1202_C2__n), .Y(U1202_C2__n_1));
  NOR2X1 U1249_C1 (.A(N8589_4), .B(U680_C1__n_1), .Y(inc_pc3));
  BUFX2 BW1_BUF3244 (.A(sel_page_addr_1), .Y(sel_page_addr));
  AND3X1 U803_C1_2 (.A(N11309), .B(code_1_1), .C(N10865), .Y(U1035_C1__n));
  AOI222X1 U946_C2_13 (.A0(N8424_1), .A1(N10621), .B0(N4835), .B1(N10333), 
     .C0(N8589_5), .C1(N11025), .Y(U946_C2__n_3));
  XNOR2X1 U1277_C1 (.A(in_xrom1_r_6_1), .B(combus[6]), .Y(N9870));
  INVX1 U1003_C1 (.A(U718_C4__n_2), .Y(ld_pch));
  INVX1 U1097_C2_MP_INV (.A(U682_C3__n_1), .Y(U682_C3__n));
  MX2X1 U1329_C4_7 (.A(N9216_3), .B(U1063_C2__n), .S0(out_dimod_r[1]), 
     .Y(U1329_C4__n_3));
  u_con_DW01_cmp2_8_1 r102 (.A({in_xrom1_r[7], in_xrom1_r[6], in_xrom1_r[5], 
     in_xrom1_r[4], in_xrom1_r[3], in_xrom1_r[2], in_xrom1_r[1], in_xrom1_r[0]}), 
     .B({combus[7], combus[6], combus[5], combus[4], combus[3], combus[2], 
     combus[1], combus[0]}), .LEQ(VDD), .TC(VSS), .LT_LE(N290), .GE_GT());
  BUFX3 BL2_BUF175 (.A(test_so), .Y(test_so_1));
  NOR2X1 U1163_C2_16 (.A(N9794), .B(N1781_1), .Y(N1781_2));
  INVX1 U1163_C2_15_MP_INV (.A(bit_dat_in_r), .Y(bit_dat_in_r_1));
  AOI222X1 U710_C3_3 (.A0(U961_C1__n), .A1(N8439), .B0(N9892_4), 
     .B1(U1035_C1__n_2), .C0(U635_C1__n_5), .C1(U710_C3__n), .Y(U710_C3__n_4));
  NOR2X2 U736_C1 (.A(n703_1), .B(U736_C1__n_1), .Y(cpl_c));
  NAND3BX1 U668_C2_1 (.AN(N8463), .B(N9869), .C(U668_C2__n_1), .Y(N7287));
  INVX1 U636_C1 (.A(U642_C3__n_1), .Y(N7151));
  BUFX1 BL2_BUF144 (.A(rmw), .Y(rmw_1));
  NOR2X2 U916_C1 (.A(U916_C1__n), .B(U669_C2__n), .Y(bit_addr));
  OAI21X2 U1163_C2_25 (.A0(N1781), .A1(N9216_3), .B0(ld_pc_4), .Y(ld_pc));
  NOR2BX1 U1303_C1 (.AN(ac), .B(U1302_C1__n), .Y(set_ac));
  XNOR2X1 U1294_C1 (.A(out_acc_r[1]), .B(combus_1_1), .Y(N10741));
  BUFX1 BL1_BUF284 (.A(combus[1]), .Y(combus_1_1));
  NOR2X1 U1163_C2_11 (.A(N9888), .B(N6103_3), .Y(N6103_4));
  XNOR2X1 U1278_C1 (.A(in_xrom1_r_3_1), .B(combus_3_1), .Y(N9888));
  INVX1 U1287_C1_MP_INV (.A(out_acc_r[5]), .Y(out_acc_r_5_1));
  XNOR2X1 U1337_C1 (.A(out_acc_r[4]), .B(in_xrom1_r[4]), .Y(U1234_C1__n_1));
  NOR2X1 U730_C1_2 (.A(U730_C1__n_6), .B(U916_C1__n_1), .Y(U916_C1__n));
  INVX1 U1296_C3_11_MP_INV_1 (.A(U888_C1__n_2), .Y(U888_C1__n_4));
  AOI21X1 U932_C1_1 (.A0(U715_C1__n_4), .A1(N1456), .B0(n648_1), .Y(U874_C2__n));
  INVX1 U768_C1 (.A(U652_C1__n), .Y(N4929));
  INVX1 U752_C1_4_MP_INV (.A(U752_C1__n), .Y(U752_C1__n_2));
  NOR2X1 U692_C3_9 (.A(U692_C3__n_3), .B(U692_C3__n_12), .Y(U692_C3__n_14));
  NAND2X1 U958_C1 (.A(N10703_2), .B(U958_C1__n_2), .Y(N10177));
  BUFX16 BL3_S_BUF_18 (.A(rmw_2), .Y(rmw));
  INVX1 U1094_C1_MP_INV (.A(N1456_1), .Y(N1456));
  BUFX1 BL1_BUF313 (.A(en_div), .Y(en_div_1));
  OAI211X1 U747_C2_4 (.A0(N9216_3), .A1(N7236), .B0(N7178_5), .C0(N7178_4), 
     .Y(sel_combus[0]));
  INVX1 U1134_C3_1_MP_INV_2 (.A(U730_C1__n), .Y(n654_1));
  NAND2X2 U662_C1 (.A(U662_C1__n_1), .B(U662_C1__n), .Y(U642_C3__n_1));
  NAND2X4 U905_C2_2 (.A(U906_C1__n), .B(U707_C2__n_1), .Y(U707_C2__n));
  NOR2X1 U659_C2 (.A(U998_C1__n), .B(U970_C3__n), .Y(N10705));
  INVX1 U672_C1 (.A(code[5]), .Y(N4946));
  AOI211X1 U976_C4_7 (.A0(N8589_5), .A1(N1390), .B0(sel_op2[0]), 
     .C0(U752_C1__n_5), .Y(U752_C1__n_1));
  OAI21X1 U1205_C2_1 (.A0(U635_C1__n_3), .A1(U662_C1__n_1), .B0(N8543), 
     .Y(N8545));
  NAND2X1 U1265_C1 (.A(N511_1), .B(code[3]), .Y(U692_C3__n_15));
  NAND2X2 U715_C1 (.A(U715_C1__n_2), .B(U841_C1__n_1), .Y(N9869));
  AOI222X1 U1296_C3_11 (.A0(U888_C1__n_3), .A1(N285), .B0(U888_C1__n_4), 
     .B1(N284), .C0(n766_1), .C1(N283), .Y(N7168));
  AOI22X1 U1177_C3_9 (.A0(U888_C1__n_3), .A1(N290), .B0(U888_C1__n_4), .B1(N289), 
     .Y(N8565_1));
  INVX1 U1296_C3_11_MP_INV (.A(U888_C1__n_1), .Y(U888_C1__n_3));
  INVX1 U1177_C3_12_MP_INV_1 (.A(cy), .Y(cy_1));
  INVX8 BL2_INV32 (.A(N9216_2), .Y(N9216_3));
  SDFFSRX4 timing_cnt_reg_2_ (.CK(clk0_14), .D(N9772), .Q(\timing_cnt[2] ), 
     .QN(n560), .RN(N9737), .SE(test_se), .SI(\timing_cnt[1] ), .SN(VDD));
  NOR2X4 U784_C1 (.A(U841_C1__n), .B(U934_C1__n_1), .Y(reti));
  NOR2X2 U764_C1 (.A(U764_C1__n_1), .B(U673_C1__n_1), .Y(N511));
  XOR2X1 U1318_C1 (.A(\t_2[1] ), .B(\t_2[0] ), .Y(N11875));
  INVX8 BL2_INV40 (.A(U635_C1__n_4), .Y(U635_C1__n_5));
  NAND3X4 U676_C1_2 (.A(U1115_C1__n), .B(U635_C1__n_5), .C(N10865), 
     .Y(U680_C1__n_1));
  AND2X1 U1341_C1 (.A(U1341_C1__n_1), .B(U1341_C1__n), .Y(N10356));
  INVX1 U769_C1 (.A(U663_C1__n), .Y(N10766));
  NAND2X2 U1257_C1 (.A(U664_C1__n_3), .B(code[3]), .Y(N8465));
  NAND3X1 U1185_C1_3 (.A(\timing_cnt[2] ), .B(N9727), .C(N11360_1), .Y(N11360));
  INVX1 U1263_C1 (.A(code[7]), .Y(N8569));
  NAND3BX1 U1239_C3_5 (.AN(U1109_C1__n), .B(N4897), .C(U1202_C2__n), .Y(N8522));
  NOR2X4 U661_C1_2 (.A(U715_C1__n_1), .B(U661_C1__n), .Y(U715_C1__n_2));
  NAND2X1 U1370_C1 (.A(\itcnt[1] ), .B(\itcnt[0] ), .Y(N11398));
  INVX2 U738_C1 (.A(U669_C2__n), .Y(N10082));
  NOR4BX1 U1206_C1_6 (.AN(n563), .B(n561), .C(test_so_1), .D(U1206_C1__n), 
     .Y(ld_b_1));
  NAND2X2 U687_C1 (.A(U687_C1__n_2), .B(N10865), .Y(U635_C1__n_1));
  INVX1 U1164_C1_7_MP_INV (.A(U970_C3__n), .Y(U970_C3__n_6));
  OR3X1 U1372_C2_5 (.A(rst_p), .B(en_int1), .C(N8381), .Y(N12301));
  INVX1 U725_C1_MP_INV (.A(U673_C1__n_1), .Y(U673_C1__n));
  MXI2X1 U1224_C1_6 (.A(N10575), .B(N8412), .S0(test_so_1), .Y(U1226_C2__n_8));
  NAND2X1 U986_C1 (.A(n563), .B(n561), .Y(U1063_C2__n));
  NOR2X1 U1098_C3_1 (.A(n563), .B(test_so_1), .Y(N9216_1));
  INVX1 U962_C2_4_MP_INV (.A(U635_C1__n), .Y(n780_1));
  AOI21X1 U930_C2_1 (.A0(N7151), .A1(N8459_1), .B0(U841_C1__n), .Y(U699_C1__n_1));
  INVX1 U799_C1_2_MP_INV (.A(U687_C1__n_2), .Y(U687_C1__n));
  INVX1 U1219_C2_2_MP_INV_1 (.A(N8439), .Y(N8439_1));
  NAND3X1 U1290_C2_2 (.A(U635_C1__n_2), .B(bit_dat_in_r), .C(N8439), .Y(N9775));
  NAND2X2 U841_C1 (.A(U841_C1__n_4), .B(U841_C1__n_5), .Y(N1699));
  NAND2X1 U692_C3_7 (.A(U888_C1__n_1), .B(U692_C3__n_9), .Y(U692_C3__n_12));
  AOI22X1 U1066_C2_2 (.A0(U958_C1__n_2), .A1(N2881), .B0(n729_1), .B1(N8589_5), 
     .Y(N8521));
  INVX1 U1256_C2_2_MP_INV (.A(U1115_C1__n_2), .Y(U1115_C1__n));
  NOR2X4 U900_C1 (.A(N8589_4), .B(U680_C1__n), .Y(inc_pc2));
  INVX1 U758_C2_1_MP_INV (.A(code[1]), .Y(code_1_1));
  INVX1 U781_C2_8_MP_INV (.A(N8424), .Y(N8424_1));
  NOR2X1 U1367_C1 (.A(N9759), .B(U1367_C1__n), .Y(N11838));
  XOR2X1 U1368_C1 (.A(itcnt_1_1), .B(\itcnt[0] ), .Y(U1367_C1__n));
  NAND2X1 U1329_C4 (.A(out_dimod_r_1_1), .B(U958_C1__n_2), .Y(U1329_C4__n));
  XOR2X1 U811_C1 (.A(out_acc_r[6]), .B(in_xrom1_r[6]), .Y(U1234_C1__n_7));
  one_shot_3_test_1 one_shot_en_int (.rst_p(rst_p), .clk(), .d(en_int), 
     .q(en_int1), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si(\itcnt[2] ), .test_so(n2), .test_se(test_se), .clk0_14(clk0_14));
  SDFFRHQX2 timing_cnt_reg_3_ (.CK(clk0_14), .D(N10287), .Q(test_so), .RN(N9737), 
     .SE(test_se), .SI(\timing_cnt[2] ));
  INVX1 U684_C1 (.A(U670_C1__n_3), .Y(N4582_1));
  AOI21X1 U1052_C2_2 (.A0(U715_C1__n_4), .A1(U976_C4__n), .B0(U1052_C2__n), 
     .Y(N12088_1));
  OAI21X1 U926_C2_1 (.A0(U715_C1__n_4), .A1(N8406), .B0(U976_C4__n), 
     .Y(U874_C2__n_1));
  OAI21X1 U1163_C2_15 (.A0(U730_C1__n), .A1(bit_dat_in_r_1), .B0(N9775), 
     .Y(N1781_1));
  NAND4X1 U1209_C2_5 (.A(U662_C1__n), .B(N4582_1), .C(N9892), .D(N8459_1), 
     .Y(N12035));
  AOI22X1 U744_C1_4 (.A0(U934_C1__n), .A1(U710_C3__n), .B0(N4948), 
     .B1(U1035_C1__n_2), .Y(sel_alu_0_1));
  NOR2X4 U884_C1 (.A(msb_a_1), .B(N8521), .Y(ld_sfr));
  NOR3X2 U728_C2_2 (.A(msb_a_1), .B(U958_C1__n_1), .C(U874_C2__n), 
     .Y(sel_op1[1]));
  AOI2BB1X1 U870_C1_1 (.A0N(U1304_C1__n), .A1N(U1302_C1__n_1), .B0(ov_1), 
     .Y(set_v));
  NAND4X1 U1159_C1_4_C4_7 (.A(combus_7_1), .B(combus_6_1), 
     .C(U1134_C3_1_C3__n_7), .D(U1134_C3_1_C3__n_4), .Y(U1134_C3_1_C3__n_2));
  XNOR2X1 U1334_C1 (.A(out_acc_r[1]), .B(in_xrom1_r[1]), .Y(U1234_C1__n_4));
  XNOR2X1 U1276_C1 (.A(in_xrom1_r_5_1), .B(combus[5]), .Y(N4696));
  NAND2BX1 U1159_C1_4_C4_4 (.AN(combus_1_1), .B(combus_0_1), 
     .Y(U1134_C3_1_C3__n_6));
  XOR2X1 U807_C1 (.A(out_acc_r[6]), .B(combus[6]), .Y(U805_C1__n_1));
  XOR2X1 U1281_C1 (.A(out_acc_r_4_1), .B(combus[4]), .Y(N9880));
  BUFX1 BL1_ASSIGN_BUF163 (.A(VSS), .Y(psen));
  NOR2X1 U1163_C2_17 (.A(U1156_C1__n_1), .B(N1781_5), .Y(N1781_3));
  AOI2BB1X4 U1091_C1_1 (.A0N(U1091_C1__n), .A1N(N10030), .B0(N8589_4), 
     .Y(ld_latch_acc));
  OAI21X1 U956_C2_5 (.A0(N9216_3), .A1(U752_C1__n), .B0(N8589_4), .Y(N1777));
  AOI21X1 U1019_C1_5 (.A0(N4582_1), .A1(N8513_3), .B0(N10177), .Y(N10782));
  AOI22X1 U781_C2_8 (.A0(U1202_C2__n_1), .A1(N8424_1), .B0(N4835), .B1(N10255), 
     .Y(sel_combus_2_1));
  AOI21X4 U1376_C3_4 (.A0(N3388_1), .A1(N10703_2), .B0(N3477_1), 
     .Y(sel_addr1_2_1));
  OAI21X1 U1009_C2_3 (.A0(n648_1), .A1(U734_C2__n), .B0(N4835), .Y(N9732));
  AOI211X2 U1058_C1_3 (.A0(U683_C1__n_1), .A1(N8513_3), .B0(U635_C1__n_3), 
     .C0(U958_C1__n_1), .Y(sel_xaddr_low));
  NAND4BBX1 U1009_C2_2 (.AN(U998_C1__n), .BN(N7145_3), .C(U718_C4__n_3), 
     .D(N9732), .Y(N7144));
  OAI2BB1X1 U669_C2_10 (.A0N(U960_C2__n), .A1N(U752_C1__n), .B0(U958_C1__n_2), 
     .Y(N3260));
  AND2X1 U817_C1 (.A(U958_C1__n_2), .B(U1052_C2__n), .Y(ld_dph));
  NAND3X1 U951_C2_10 (.A(wr_idat_1), .B(N10133), .C(U1226_C2__n_11), .Y(wr_idat));
  BUFX3 BL2_BUF161 (.A(U670_C1__n_2), .Y(U670_C1__n_3));
  NAND3BX1 U1139_C1_2 (.AN(U642_C3__n_1), .B(U1139_C1__n), .C(U1268_C1__n), 
     .Y(U931_C1__n_2));
  NAND4X1 U791_C3_3 (.A(N8569), .B(code_4_1), .C(code[5]), .D(code[6]), 
     .Y(U662_C1__n_3));
  NAND4X1 U795_C3_3_INV (.A(code[7]), .B(code[6]), .C(code[5]), .D(code[4]), 
     .Y(N8513_1));
  NOR2X1 U682_C3 (.A(N10703_2), .B(code[3]), .Y(N5005));
  AOI21X1 U1181_C2_1 (.A0(U715_C1__n_4), .A1(N9892_4), .B0(U718_C4__n_9), 
     .Y(U960_C2__n_1));
  NOR3X2 U987_C1_2 (.A(U718_C4__n), .B(U961_C1__n_1), .C(U860_C1__n), 
     .Y(ld_adptr));
  NOR2X4 U729_C1 (.A(U635_C1__n_3), .B(U729_C1__n), .Y(U718_C4__n_9));
  BUFX8 BL3_S_BUF_19 (.A(sel_alu_3_1), .Y(sel_alu[3]));
  AOI21X1 U1163_C2_24 (.A0(U1134_C3_1_C3__n_2), .A1(N2154_1), .B0(ld_pc_3), 
     .Y(ld_pc_4));
  INVX1 U731_C1_MP_INV (.A(U843_C1__n_1), .Y(U843_C1__n));
  OAI21X1 U1163_C2_18 (.A0(U1134_C3_1_C3__n), .A1(U1382_C1__n), .B0(N1781_3), 
     .Y(N1781_4));
  NOR2X1 U1100_C1 (.A(N10703), .B(N8328), .Y(N9720));
  NOR4BX1 U1366_C4_3 (.AN(n620), .B(\t_2[3] ), .C(\t_2[2] ), .D(\t_2[0] ), 
     .Y(U1251_C2__n));
  XNOR2X1 U1247_C1 (.A(\timing_cnt[2] ), .B(N9931), .Y(U1246_C1__n));
  NOR4BX4 U643_C3_3 (.AN(code[4]), .B(code[7]), .C(code[6]), .D(code[5]), 
     .Y(U635_C1__n));
  AND2X1 U1243_C1 (.A(U1341_C1__n_1), .B(U1243_C1__n), .Y(N10287));
  OAI21X1 U682_C3_8 (.A0(U683_C1__n_1), .A1(N4591), .B0(N4897), .Y(U692_C3__n_7));
  INVX1 U1019_C1_7_MP_INV (.A(U1226_C2__n_11), .Y(U1226_C2__n));
  AOI211X1 U1226_C2_9 (.A0(N4835), .A1(N7305), .B0(U1226_C2__n_1), 
     .C0(U1226_C2__n), .Y(U1226_C2__n_3));
  BUFX8 BL3_S_BUF_20 (.A(addr_bank_a_2_1), .Y(addr_bank_a[2]));
  NAND2X2 U670_C1 (.A(U715_C1__n_2), .B(U670_C1__n_2), .Y(U1377_C1__n));
  INVX3 U737_C1_MP_INV_C1_1 (.A(N511), .Y(N4842));
  NAND3X1 U1254_C2_2 (.A(N8569), .B(N4603), .C(code[5]), .Y(U1268_C1__n));
  NOR2X1 U650_C1 (.A(U661_C1__n), .B(code_1_1), .Y(N10703_1));
  INVX2 U1166_C2_7_MP_INV (.A(U958_C1__n_2), .Y(U958_C1__n_1));
  INVX2 BL2_INV35 (.A(U635_C1__n_1), .Y(U635_C1__n_2));
  NAND4X4 U718_C4_14 (.A(U718_C4__n_3), .B(N7565), .C(sel_addr1_1_1), 
     .D(sel_addr1_1_2), .Y(sel_addr1[1]));
  INVX1 U1049_C1_2_MP_INV (.A(U1213_C1__n_1), .Y(U1213_C1__n));
  AOI21X1 U998_C1_1 (.A0(U638_C1__n), .A1(U958_C1__n_2), .B0(U998_C1__n), 
     .Y(N8579));
  NAND3X1 U946_C2_3 (.A(U946_C2__n_8), .B(U946_C2__n_7), .C(U946_C2__n_3), 
     .Y(inc_pc));
  NOR2BX2 U1347_C1 (.AN(extend_mux), .B(sel_code_xdat), .Y(sel_xaddr_high));
  NAND2BX1 U1224_C1_1 (.AN(out_dimod_r[2]), .B(U1224_C1__n_1), .Y(N10575));
  INVX1 U1087_C1_MP_INV (.A(U1226_C2__n_7), .Y(U1226_C2__n_9));
  INVX1 C30562 (.A(n561), .Y(N4906));
  NOR2X1 U1365_C1 (.A(n572), .B(U1365_C1__n), .Y(N11878));
  NAND2X1 U928_C1 (.A(U664_C1__n_3), .B(U1035_C1__n_2), .Y(N8436));
  NAND2X1 U934_C1 (.A(U961_C1__n), .B(U934_C1__n), .Y(N8440));
  INVX1 U657_C3_6_MP_INV (.A(U662_C1__n), .Y(n813_1));
  NOR2X1 U961_C1 (.A(N8589_4), .B(U961_C1__n_1), .Y(U736_C1__n));
  OAI21X1 U908_C2_1 (.A0(U934_C1__n), .A1(N8439), .B0(U635_C1__n_2), .Y(N8462));
  NAND4BX1 U778_C3_3 (.AN(U731_C1__n), .B(U778_C3__n_8), .C(U778_C3__n_5), 
     .D(U778_C3__n_1), .Y(sel_alu_3_1));
  NOR2X1 U781_C2_12 (.A(n729_1), .B(N4897_1), .Y(N10255_4));
  NOR2BX1 U692_C3_2 (.AN(U692_C3__n_8), .B(U1202_C2__n_1), .Y(U692_C3__n_9));
  NAND3X4 U1256_C2_2 (.A(N4591), .B(N4834), .C(code[1]), .Y(U1115_C1__n_2));
  INVX4 U711_C1 (.A(code[0]), .Y(N10865));
  NOR2BX1 U1163_C2_22 (.AN(U1069_C1__n), .B(ld_pc_5), .Y(ld_pc_2));
  OAI21X2 U750_C2_1 (.A0(U635_C1__n_3), .A1(U683_C1__n_1), .B0(N10062), 
     .Y(N10029));
  OAI2BB2X1 U1315_C4_1 (.A0N(N10943), .A1N(N10641), .B0(n572), .B1(N8409), 
     .Y(N9781));
  INVX1 U763_C3_2_MP_INV (.A(\itcnt[1] ), .Y(itcnt_1_1));
  SDFFRHQX1 extend_rd_reg (.CK(clk0_14), .D(N10644), .Q(extend_rd), .RN(N9737), 
     .SE(test_se), .SI(extend_mux));
  OAI2BB1X1 U1356_C3_1 (.A0N(extend_rd), .A1N(U1226_C2__n_7), .B0(N10027), 
     .Y(N10644));
  u_con_DW01_cmp2_8_0 r99 (.A({combus[7], combus[6], combus[5], combus[4], 
     combus[3], combus[2], combus[1], combus[0]}), .B({in_xrom1_r[7], 
     in_xrom1_r[6], in_xrom1_r[5], in_xrom1_r[4], in_xrom1_r[3], in_xrom1_r[2], 
     in_xrom1_r[1], in_xrom1_r[0]}), .LEQ(VSS), .TC(VSS), .LT_LE(N285), .GE_GT());
  INVX1 BL2_INV31 (.A(N9216), .Y(N9216_2));
  INVX1 U737_C1_MP_INV_C1_MP_INV (.A(U692_C3__n_8), .Y(U692_C3__n_2));
  NAND2X1 U989_C1 (.A(N4948), .B(U715_C1__n_4), .Y(U960_C2__n));
  NAND3X1 U1133_C2_2 (.A(N4833_1), .B(U907_C1__n), .C(U1035_C1__n_1), 
     .Y(U710_C3__n));
  NAND3X1 U960_C2_2 (.A(N9869), .B(U960_C2__n_1), .C(U960_C2__n), .Y(U888_C1__n));
  OAI2BB1X1 U1163_C2_23 (.A0N(U1164_C1__n_3), .A1N(U635_C1__n_2), .B0(ld_pc_2), 
     .Y(ld_pc_3));
  NOR2X1 U731_C1 (.A(sel_in_cy_bit[1]), .B(U731_C1__n), .Y(U843_C1__n_1));
  BUFX12 BL3_S_BUF_25 (.A(sel_addr1_2_2), .Y(sel_addr1[2]));
  OR4X2 U732_C3_3 (.A(n654_1), .B(U730_C1__n_1), .C(U874_C2__n_4), .D(N8467_1), 
     .Y(rmw_2));
  NAND2BX4 U1376_C3_2 (.AN(N9869), .B(U958_C1__n_2), .Y(N8502));
  INVX1 U1036_C3_5_MP_INV (.A(ld_acc_2), .Y(ld_acc));
  NAND4X1 U1156_C1_7 (.A(N9880), .B(N10741), .C(N9777), .D(N12221), .Y(N5011_3));
  BUFX1 BL1_BUF223 (.A(combus[3]), .Y(combus_3_1));
  INVX1 U1159_C1_4_C4_4_MP_INV (.A(combus[0]), .Y(combus_0_1));
  XOR2X1 U1275_C1 (.A(in_xrom1_r_4_1), .B(combus[4]), .Y(N9872));
  XNOR2X1 U1287_C1 (.A(out_acc_r_5_1), .B(combus[5]), .Y(N9871));
  XNOR2X1 U1333_C1 (.A(out_acc_r[3]), .B(in_xrom1_r[3]), .Y(U1234_C1__n_2));
  INVX1 U1163_C2_17_MP_INV (.A(N1781_2), .Y(N1781_5));
  OAI221X1 U1296_C3_13 (.A0(N9216_3), .A1(N7168), .B0(N4823_1), 
     .B1(U736_C1__n_1), .C0(N11968), .Y(set_c));
  AOI2BB2X1 U1015_C2_4 (.A0N(N9216_3), .A1N(N10062), .B0(U958_C1__n_2), 
     .B1(N8466), .Y(N8492_1));
  INVX1 U682_C3_11_MP_INV (.A(U692_C3__n_10), .Y(U692_C3__n_1));
  NOR2X1 U946_C2_8 (.A(U752_C1__n_2), .B(N8406), .Y(N10621_1));
  NOR2X1 U652_C1 (.A(U652_C1__n), .B(N10758), .Y(N10801));
  AOI31X1 U972_C2_2 (.A0(U1091_C1__n_2), .A1(N8467), .A2(N2056_1), .B0(N9216_3), 
     .Y(U970_C3__n_1));
  NOR2X1 U692_C3_14 (.A(U692_C3__n_3), .B(U692_C3__n_17), .Y(U692_C3__n_6));
  AOI21X1 U654_C2_4 (.A0(U874_C2__n_1), .A1(U699_C1__n), .B0(N8424), .Y(N8567_1));
  BUFX20 BW1_BUF2855 (.A(sel_addr0_1), .Y(sel_addr0));
  NOR4BBX1 U1226_C2_11 (.AN(U1226_C2__n_18), .BN(U1226_C2__n_14), .C(cpl_c), 
     .D(U1226_C2__n_4), .Y(end_instr_2));
  AOI21X1 U654_C2_2 (.A0(msb_a), .A1(N8567_1), .B0(sel_op2[0]), .Y(sel_op2_1_1));
  INVX1 U906_C1_MP_INV (.A(U642_C3__n_2), .Y(U642_C3__n));
  INVX8 BL3_S_INV_1 (.A(N8513_1), .Y(N8513));
  OAI31X1 U983_C2_2 (.A0(\timing_cnt[0] ), .A1(n563), .A2(N8328), 
     .B0(U718_C4__n_2), .Y(U983_C2__n));
  BUFX12 BL2_BUF159 (.A(U841_C1__n_1), .Y(U841_C1__n_5));
  NOR2X1 U905_C2_1 (.A(code[7]), .B(code[6]), .Y(U707_C2__n_1));
  INVX1 U1146_C1_3_MP_INV (.A(U1035_C1__n), .Y(U1035_C1__n_1));
  NOR4BX2 U1378_C1_10 (.AN(N5348_2), .B(N8595), .C(N4835), .D(U841_C1__n_5), 
     .Y(N4066_3));
  NOR4X2 U682_C3_11 (.A(U692_C3__n_7), .B(N2103), .C(U682_C3__n_1), .D(N4213), 
     .Y(U692_C3__n_10));
  NAND2X1 U840_C2_1 (.A(U979_C1__n), .B(N8456), .Y(U730_C1__n_3));
  NAND4X2 U710_C3_2 (.A(N8465), .B(U1382_C1__n), .C(U778_C3__n_1), 
     .D(U710_C3__n_7), .Y(sel_alu[2]));
  XNOR2X1 U1280_C1 (.A(in_xrom1_r[7]), .B(combus[7]), .Y(N9868));
  NOR2X1 U1156_C1 (.A(N10270), .B(U888_C1__n_2), .Y(U1156_C1__n_1));
  NOR2X1 U702_C1 (.A(test_so_1), .B(\timing_cnt[2] ), .Y(U690_C1__n));
  XNOR2X1 U1316_C1 (.A(\t_2[2] ), .B(U1365_C1__n), .Y(N10641));
  INVX1 U1139_C1_2_MP_INV (.A(U931_C1__n_2), .Y(U931_C1__n));
  XOR2X1 U1342_C1 (.A(\timing_cnt[1] ), .B(\timing_cnt[0] ), .Y(U1341_C1__n));
  INVX1 U1264_C1_MP_INV (.A(U764_C1__n_1), .Y(U764_C1__n));
  NAND2X2 U1119_C1 (.A(U673_C1__n), .B(U663_C1__n_1), .Y(U860_C1__n));
  NAND2X1 U854_C1 (.A(U833_C1__n), .B(U690_C1__n), .Y(N8424));
  OAI32X1 U1045_C1_4 (.A0(U662_C1__n_1), .A1(U635_C1__n_3), .A2(U669_C2__n), 
     .B0(N9216_3), .B1(N8423), .Y(sel_pc_2_1));
  OAI21X1 U1182_C2_1 (.A0(N8595), .A1(N10766), .B0(U1035_C1__n_2), .Y(N2703));
  AOI221X1 U752_C1_4 (.A0(U683_C1__n), .A1(N8370), .B0(U958_C1__n_2), 
     .B1(U752_C1__n_2), .C0(U752_C1__n_6), .Y(N7690));
  INVX1 U627_C3_3_MP_INV (.A(N9892_4), .Y(N9892));
  NOR2X1 U1268_C1 (.A(code_4_1), .B(U1268_C1__n), .Y(U934_C1__n));
  OAI211X1 U1216_C1_5 (.A0(N4897), .A1(N9216_3), .B0(U1226_C2__n_12), .C0(N7690), 
     .Y(U1226_C2__n_4));
  BUFX4 BL2_BUF158 (.A(U841_C1__n_3), .Y(U841_C1__n_4));
  SDFFSRX2 itcnt_reg_0_ (.CK(clk0_14), .D(N9739), .Q(\itcnt[0] ), .QN(n566), 
     .RN(N9737), .SE(test_se), .SI(extend_wr), .SN(VDD));
  NAND2X4 U638_C1 (.A(U638_C1__n), .B(N10082), .Y(U718_C4__n_3));
  INVX1 U718_C4_11_MP_INV (.A(U718_C4__n), .Y(U718_C4__n_4));
  NAND4BX1 U1226_C2_13 (.AN(U1226_C2__n_6), .B(end_instr_2), .C(U1226_C2__n_7), 
     .D(U1226_C2__n_3), .Y(end_instr));
  BUFX8 BL3_S_BUF_26 (.A(U680_C1__n_2), .Y(U680_C1__n));
  NOR2X1 U1026_C1 (.A(sel_code_xdat), .B(N8589_4), .Y(ale));
  NAND2BX2 U725_C1 (.AN(code[6]), .B(code[7]), .Y(U673_C1__n_1));
  NAND2X1 U1224_C1_7 (.A(U1226_C2__n_8), .B(N8409), .Y(U1226_C2__n_7));
  AOI2BB1X1 U1063_C2_1 (.A0N(U1063_C2__n), .A1N(N8328), .B0(sel_code_xdat), 
     .Y(N8409));
  NOR2X1 U637_C2_1 (.A(N8595), .B(N9884), .Y(N10787_1));
  INVX1 U754_C2_1_MP_INV (.A(U976_C4__n_5), .Y(U976_C4__n_1));
  INVX1 U935_C1_3_MP_INV (.A(U707_C2__n), .Y(n1099_1));
  OAI21X2 U1031_C2_1 (.A0(N7007), .A1(N9216_3), .B0(N8540_1), .Y(dec_sp));
  NAND2X1 U664_C1 (.A(U715_C1__n_2), .B(U664_C1__n_1), .Y(U1382_C1__n_1));
  OR2X1 U1120_C1_4 (.A(U1035_C1__n_2), .B(N8571), .Y(N12194));
  NAND4BX2 U744_C1_7 (.AN(U657_C3__n), .B(sel_alu_0_1), .C(U778_C3__n_5), 
     .D(N8514), .Y(sel_alu[0]));
  OAI21X1 U1190_C2_1 (.A0(N10703), .A1(U729_C1__n), .B0(N8594), .Y(N8466));
  INVX1 U826_C1_MP_INV (.A(U1091_C1__n), .Y(U1091_C1__n_2));
  NAND2BX2 U718_C4_8 (.AN(N7007), .B(N1593), .Y(N7565));
  INVX1 U1065_C1_MP_INV (.A(N8540), .Y(N8540_1));
  INVX2 U1267_C1 (.A(code[2]), .Y(N4834));
  INVX1 U1163_C2_22_MP_INV (.A(ld_pc_1), .Y(ld_pc_5));
  AND3X2 U763_C3_2 (.A(n566), .B(\itcnt[2] ), .C(itcnt_1_1), .Y(U970_C3__n));
  NAND4BX1 U1343_C4_14 (.AN(out_dimod_r[0]), .B(out_dimod_r[2]), .C(N12077), 
     .D(\timing_cnt[0] ), .Y(N4016));
  NOR2X1 U1340_C1 (.A(end_instr), .B(en_itcnt_2), .Y(U1341_C1__n_1));
  NOR2X1 U1163_C2_12 (.A(N9870), .B(N4696), .Y(N6103_5));
  NOR2X1 U704_C1 (.A(N4906), .B(n563), .Y(U833_C1__n));
  NAND2X1 U776_C3_1 (.A(n563), .B(N9727), .Y(N8589_1));
  AND4X1 U1052_C2_5 (.A(N8465), .B(U730_C1__n_2), .C(N12088_1), .D(N12081), 
     .Y(N12088));
  NAND4X1 U1051_C1_7 (.A(U1377_C1__n), .B(N8462), .C(N8423), .D(N8422), 
     .Y(N10215));
  NOR3X2 U957_C2_2 (.A(N9892), .B(N8589_4), .C(U1035_C1__n_1), .Y(en_div));
  AOI31X1 U1071_C4_4 (.A0(U635_C1__n_2), .A1(N8589_5), .A2(n1099_1), .B0(ld_c), 
     .Y(U1226_C2__n_14));
  NAND3BX1 U1005_C2_6 (.AN(N8463), .B(U734_C2__n_3), .C(N8594), .Y(U734_C2__n));
  BUFX3 BW1_BUF2943 (.A(sel_op2_0_1), .Y(sel_op2[0]));
  INVX1 U644_C1_6_MP_INV (.A(U874_C2__n), .Y(U874_C2__n_4));
  NOR4BX1 U781_C2_13 (.AN(N7180), .B(N8466), .C(N10029), .D(N1650_5), 
     .Y(N10255_5));
  INVX1 U870_C1_1_MP_INV (.A(ov), .Y(ov_1));
  AOI2BB1X2 U677_C2_1 (.A0N(sel_op1[1]), .A1N(N8406), .B0(U718_C4__n), 
     .Y(sel_op1[0]));
  AND4X1 U1234_C1_7 (.A(U1234_C1__n_5), .B(U1234_C1__n_4), .C(N10270_6), 
     .D(N10270_1), .Y(N10270));
  XNOR2X1 U1273_C1 (.A(in_xrom1_r_2_1), .B(combus_2_1), .Y(N9887));
  NOR2X1 U1163_C2_8 (.A(N9887), .B(N9889), .Y(N6103_1));
  NOR4BX1 U1325_C1_4 (.AN(U1308_C3__n_1), .B(out_acc_r[3]), .C(out_acc_r[2]), 
     .D(out_acc_r[1]), .Y(U1308_C3__n));
  XNOR2X1 U1300_C1 (.A(out_acc_r[0]), .B(combus[0]), .Y(N9777));
  XNOR2X1 U1271_C1 (.A(in_xrom1_r_1_1), .B(combus_1_1), .Y(N9889));
  NOR4X2 U885_C1_3 (.A(N7672), .B(n766_1), .C(U888_C1__n_4), .D(U888_C1__n_3), 
     .Y(N8423));
  INVX1 U979_C1_5_MP_INV (.A(N1650_5), .Y(N1650));
  NAND2X2 U734_C2_2 (.A(U1213_C1__n_1), .B(N6093), .Y(ld_xrom));
  NAND3X1 U996_C1_4 (.A(U670_C1__n_3), .B(U958_C1__n_2), .C(U907_C1__n_1), 
     .Y(N1714));
  AOI221X1 U1049_C1_2 (.A0(U958_C1__n_2), .A1(N10215), .B0(N8589_5), .B1(N8581), 
     .C0(ld_dph), .Y(U1213_C1__n_1));
  INVX1 U907_C1_MP_INV (.A(U907_C1__n), .Y(U907_C1__n_1));
  NOR2X1 U874_C2_3 (.A(U888_C1__n), .B(U874_C2__n_4), .Y(U874_C2__n_5));
  OAI21X2 U797_C1_1 (.A0(N1456_1), .A1(N4591), .B0(N8465), .Y(U652_C1__n));
  NAND2X1 U644_C1_2 (.A(U652_C1__n), .B(N8589_5), .Y(N3399));
  OAI2BB1X1 U669_C2_9 (.A0N(N8540_1), .A1N(N3260), .B0(msb_a), .Y(N7544));
  NOR4BBX1 U747_C2_9 (.AN(N8579), .BN(N7690), .C(U1304_C1__n), .D(N8540), 
     .Y(N7178_5));
  XOR2X1 U810_C1 (.A(out_acc_r[7]), .B(in_xrom1_r[7]), .Y(U1234_C1__n_6));
  NOR2X1 U705_C1 (.A(code[5]), .B(code[4]), .Y(U906_C1__n));
  NOR3BX2 U1095_C2_2 (.AN(U686_C1__n_1), .B(N10766), .C(N9892_4), .Y(N5348_2));
  NOR2X1 U792_C3_1 (.A(code[7]), .B(code[5]), .Y(U662_C1__n_2));
  NAND3X1 U792_C3_3 (.A(U662_C1__n_2), .B(code[4]), .C(code[6]), 
     .Y(U662_C1__n_1));
  BUFX8 BL3_S_BUF_24 (.A(U692_C3__n_15), .Y(U692_C3__n));
  NAND2X1 U1019_C1 (.A(U682_C3__n), .B(U692_C3__n_8), .Y(N8329));
  NAND2X1 U737_C1_MP_INV_C1 (.A(N511_1), .B(N10703_2), .Y(U692_C3__n_8));
  NAND3X1 U1226_C2_8 (.A(U692_C3__n), .B(N7305_3), .C(N10466), .Y(N7305));
  NAND2X1 U842_C1 (.A(U841_C1__n_4), .B(U664_C1__n_3), .Y(N8456));
  NAND2X1 U1075_C2_2 (.A(N8589_5), .B(N8442), .Y(N4159));
  AOI2BB1X1 U823_C1_1 (.A0N(sel_in_cy_bit[2]), .A1N(U843_C1__n), .B0(N9216_3), 
     .Y(ld_c));
  INVX1 U1177_C3_12_MP_INV (.A(rst_c_2), .Y(rst_c));
  SDFFSRX1 t_2_reg_2_ (.CK(clk0_14), .D(N9781), .Q(\t_2[2] ), .QN(n572), 
     .RN(N9737), .SE(test_se), .SI(\t_2[1] ), .SN(VDD));
  XOR2X1 U1244_C1 (.A(test_so_1), .B(N9771), .Y(U1243_C1__n));
  NAND2BX1 U1264_C1 (.AN(code[4]), .B(code[5]), .Y(U764_C1__n_1));
  INVX1 U658_C1_MP_INV (.A(U663_C1__n_2), .Y(U663_C1__n_1));
  NOR2X1 U1185_C1_1 (.A(U1063_C2__n), .B(N8514), .Y(N11360_1));
  INVX1 U700_C1 (.A(n563), .Y(N4824));
  NOR3X4 U749_C1_2 (.A(N9892), .B(U961_C1__n_1), .C(N8424), .Y(ld_apc));
  NOR2X1 U805_C1 (.A(U805_C1__n_1), .B(U805_C1__n), .Y(N9718));
  NOR2X2 U896_C1 (.A(N4842), .B(U736_C1__n_1), .Y(inc_dptr));
  AOI21X2 U1378_C1_14 (.A0(N5958_3), .A1(N4066_3), .B0(sel_addr1_0_2), 
     .Y(sel_addr1_0_3));
  NOR2X2 U1269_C1 (.A(U1115_C1__n_2), .B(N10865), .Y(U961_C1__n));
  AOI2BB1X1 U1222_C1_2 (.A0N(U841_C1__n_5), .A1N(U764_C1__n), .B0(U635_C1__n_3), 
     .Y(sel_in_cy_bit_0_1));
  BUFX3 BL2_BUF154 (.A(U1035_C1__n), .Y(U1035_C1__n_2));
  INVX1 U781_C2_15_MP_INV (.A(U638_C1__n), .Y(n859_1));
  OAI21X1 U1088_C3_4 (.A0(U638_C1__n), .A1(U718_C4__n_9), .B0(N8589_5), 
     .Y(N1271));
  AND2X1 U983_C2_1 (.A(U681_C1__n), .B(U983_C2__n), .Y(N8540));
  NAND2X2 U680_C1 (.A(U680_C1__n), .B(U680_C1__n_1), .Y(U638_C1__n));
  INVX1 U718_C4_10_MP_INV (.A(N10705), .Y(N10705_1));
  INVX8 U628_C1 (.A(code[3]), .Y(N4591));
  SDFFSRX1 extend_wr_reg (.CK(clk0_14), .D(N10642), .Q(extend_wr), .QN(n571), 
     .RN(N9737), .SE(test_se), .SI(extend_rd), .SN(VDD));
  MXI2X1 U1329_C4_3 (.A(U1329_C4__n_3), .B(U1329_C4__n), .S0(out_dimod_r[0]), 
     .Y(U1224_C1__n_1));
  MX2X1 U1319_C4_1 (.A(N8409_1), .B(N10943), .S0(n569), .Y(N10942));
  NAND2X1 U718_C4_6 (.A(U833_C1__n), .B(U690_C1__n), .Y(N3913));
  NOR2X1 U637_C2_2 (.A(U663_C1__n_2), .B(U663_C1__n), .Y(N9884));
  OAI211X1 U962_C2_4 (.A0(n780_1), .A1(U961_C1__n_1), .B0(N8440), .C0(N8436), 
     .Y(N8442));
  NAND3X1 U935_C1_5 (.A(N7467), .B(N8436), .C(U1091_C1__n_2), .Y(U657_C3__n));
  INVX1 U657_C3_7_MP_INV (.A(U860_C1__n), .Y(U860_C1__n_1));
  OAI2BB2X1 U912_C1_1_C3_1 (.A0N(N9892_4), .A1N(U841_C1__n_4), .B0(n703_1), 
     .B1(U635_C1__n_3), .Y(U731_C1__n));
  NAND2X1 U1035_C1 (.A(U841_C1__n_5), .B(U1035_C1__n_2), .Y(U888_C1__n_2));
  NAND2X1 U907_C1 (.A(U841_C1__n_5), .B(U907_C1__n_1), .Y(U888_C1__n_1));
  OAI21X1 U783_C2_1 (.A0(N10703), .A1(U729_C1__n), .B0(U960_C2__n), .Y(N10030));
  AOI211X1 U1019_C1_7 (.A0(N4835), .A1(N8329), .B0(U692_C3__n_3), .C0(N10782), 
     .Y(U1226_C2__n_11));
  NOR2X2 U727_C1 (.A(sel_code_xdat), .B(U718_C4__n), .Y(sel_xad));
  AOI2BB1X1 U745_C2_1 (.A0N(en_div_1), .A1N(N8514_1), .B0(N8589_4), 
     .Y(sel_op2[2]));
  INVX4 U650_C1_MP_INV (.A(N10703_1), .Y(N10703));
  BUFX3 BL2_BUF162 (.A(N10703_1), .Y(N10703_2));
  u_con_DW01_cmp2_8_3 lt_1408_2 (.A({out_acc_r[7], out_acc_r[6], out_acc_r[5], 
     out_acc_r[4], out_acc_r[3], out_acc_r[2], out_acc_r[1], out_acc_r[0]}), .B({
     in_xrom1_r[7], in_xrom1_r[6], in_xrom1_r[5], in_xrom1_r[4], in_xrom1_r[3], 
     in_xrom1_r[2], in_xrom1_r[1], in_xrom1_r[0]}), .LEQ(VSS), .TC(VSS), 
     .LT_LE(N284), .GE_GT());
  TLATX1 en_itcnt_reg (.D(N9704), .G(N12301), .Q(en_itcnt_2), .QN(N9759));
  BUFX16 BW1_BUF2669 (.A(sel_addr1_0_3), .Y(sel_addr1[0]));
  NOR2BX1 U1369_C1 (.AN(n566), .B(N9759), .Y(N9739));
  u_con_DW01_cmp2_8_5 gte_1432_2 (.A({in_xrom1_r[7], in_xrom1_r[6], 
     in_xrom1_r[5], in_xrom1_r[4], in_xrom1_r[3], in_xrom1_r[2], in_xrom1_r[1], 
     in_xrom1_r[0]}), .B({out_acc_r[7], out_acc_r[6], out_acc_r[5], out_acc_r[4], 
     out_acc_r[3], out_acc_r[2], out_acc_r[1], out_acc_r[0]}), .LEQ(VDD), 
     .TC(VSS), .LT_LE(N289), .GE_GT());
  NOR3X1 U681_C1_3 (.A(U718_C4__n_6), .B(n561), .C(n560_1), .Y(U718_C4__n_8));
  OAI31X1 U1232_C1_1 (.A0(U635_C1__n_3), .A1(bit_dat_in_r), .A2(U934_C1__n_1), 
     .B0(U680_C1__n), .Y(N9794));
  AOI21X1 U668_C2_8 (.A0(U715_C1__n_4), .A1(U934_C1__n), .B0(U692_C3__n_2), 
     .Y(U668_C2__n_1));
  NAND4X1 U939_C1_3 (.A(U841_C1__n), .B(N4833_1), .C(U961_C1__n_1), 
     .D(U907_C1__n), .Y(N8571));
  AOI211X1 U1005_C2_5 (.A0(N8595), .A1(U715_C1__n_4), .B0(U730_C1__n_1), 
     .C0(N8467_1), .Y(U734_C2__n_3));
  NAND2X1 U1209_C2_1 (.A(U635_C1__n_2), .B(N12035), .Y(N12081));
  NOR3BX1 U657_C3_10 (.AN(N8373_1), .B(U657_C3__n), .C(U1120_C1__n), .Y(N8373_4));
  NAND2X1 U781_C2_5 (.A(N1699), .B(msb_a), .Y(N10353));
  NAND3X1 U644_C1_6 (.A(msb_a_1), .B(U958_C1__n_2), .C(U874_C2__n_4), .Y(N7917));
  NAND2X2 U1376_C3_3 (.A(N7672), .B(N10082), .Y(N1502));
  INVX1 U1219_C2_2_MP_INV (.A(U1302_C1__n_1), .Y(U1302_C1__n));
  NOR2X1 U1159_C1_4_C4_2 (.A(combus[5]), .B(combus[4]), .Y(U1134_C3_1_C3__n_4));
  INVX1 U1271_C1_MP_INV (.A(in_xrom1_r[1]), .Y(in_xrom1_r_1_1));
  INVX1 U1276_C1_MP_INV (.A(in_xrom1_r[5]), .Y(in_xrom1_r_5_1));
  INVX1 U1163_C2_10_MP_INV (.A(N11369), .Y(N11369_1));
  INVX1 U1278_C1_MP_INV (.A(in_xrom1_r[3]), .Y(in_xrom1_r_3_1));
  AND4X1 U1234_C1_6 (.A(U1234_C1__n_3), .B(U1234_C1__n_2), .C(U1234_C1__n_1), 
     .D(U1234_C1__n), .Y(N10270_6));
  INVX1 U678_C1 (.A(U664_C1__n_3), .Y(N4823_1));
  AOI21X1 U742_C1_1 (.A0(N1699), .A1(U860_C1__n), .B0(U841_C1__n), 
     .Y(sel_bit_dat_out[1]));
  NAND4BX1 U954_C1_5 (.AN(ld_acc_chd), .B(rd_idat_1), .C(N10133), .D(N8492_1), 
     .Y(rd_idat));
  NAND2BX1 U954_C1 (.AN(U692_C3__n_1), .B(N4929), .Y(N8564));
  NOR2X1 U1376_C3_5 (.A(N4842), .B(N9216_3), .Y(N3388_1));
  NOR3BX1 U692_C3_8 (.AN(N10062), .B(U652_C1__n), .C(U692_C3__n_4), 
     .Y(U692_C3__n_13));
  INVX1 U1005_C2_5_MP_INV (.A(N8467), .Y(N8467_1));
  NOR2X2 U1377_C1 (.A(U1377_C1__n), .B(N9216_3), .Y(N3477_1));
  OAI211X1 U692_C3_13 (.A0(U692_C3__n), .A1(N9216_3), .B0(N8589_4), .C0(N10133), 
     .Y(U692_C3__n_17));
  NAND2BX1 U965_C1 (.AN(en_div_1), .B(N11360), .Y(U1304_C1__n));
  AOI221X1 U747_C2_8 (.A0(N10082), .A1(N10030), .B0(ld_c), .B1(msb_a), 
     .C0(ld_acc_chd), .Y(N7178_4));
  AND2X1 U830_C1 (.A(N4835), .B(U1052_C2__n), .Y(ld_dpl));
  BUFX4 BL3_S_BUF_28 (.A(U662_C1__n_3), .Y(U662_C1__n));
  BUFX2 BL2_BUF160 (.A(N511), .Y(N511_1));
  NOR3BX4 U697_C2_2 (.AN(N9759), .B(N8328), .C(U1063_C2__n), .Y(ld_instr));
  INVX1 U671_C1 (.A(code[6]), .Y(N4603));
  NAND2X1 U642_C3_1 (.A(U1268_C1__n), .B(U1139_C1__n), .Y(N5958_1));
  NAND2X1 U794_C1 (.A(N9892_4), .B(code[3]), .Y(U1202_C2__n));
  NOR2X1 U682_C3_5 (.A(N5348_2), .B(N10703), .Y(N4213));
  OAI21X1 U1064_C2_1 (.A0(U841_C1__n), .A1(U707_C2__n), .B0(n859_1), .Y(N8364));
  AOI21X1 U966_C1_1 (.A0(U860_C1__n), .A1(N8456), .B0(U841_C1__n), 
     .Y(sel_bit_dat_out[0]));
  AND3X1 U1141_C1_5 (.A(N1699), .B(U778_C3__n_7), .C(N8440), .Y(U778_C3__n_1));
  NOR4BX1 U888_C1_4 (.AN(N10466_2), .B(n729_1), .C(U888_C1__n_4), 
     .D(U888_C1__n_3), .Y(N10466_1));
  AOI222X1 U1177_C3_12 (.A0(cy_1), .A1(N8425), .B0(N4835), .B1(N8565), 
     .C0(N4948), .C1(U736_C1__n), .Y(rst_c_2));
  NOR2X1 U1245_C1 (.A(n560), .B(N9931), .Y(N9771));
  SDFFSRX4 timing_cnt_reg_1_ (.CK(clk0_14), .D(N10356), .Q(\timing_cnt[1] ), 
     .QN(n563), .RN(N9737), .SE(test_se), .SI(\timing_cnt[0] ), .SN(VDD));
  AOI21X1 U1202_C2_1 (.A0(U715_C1__n_4), .A1(N8513), .B0(U1202_C2__n_1), 
     .Y(N8543));
  INVX4 BL1_INV0 (.A(N8589_4), .Y(N8589_5));
  NAND2X1 U1363_C1 (.A(\t_2[1] ), .B(\t_2[0] ), .Y(U1365_C1__n));
  INVX2 BL2_INV39 (.A(U635_C1__n), .Y(U635_C1__n_4));
  INVX1 U770_C1 (.A(U692_C3__n), .Y(N1909));
  INVX4 U692_C3_13_MP_INV (.A(N8589_3), .Y(N8589_4));
  NOR2X1 U1118_C1 (.A(code[4]), .B(U1268_C1__n), .Y(N8439));
  NAND3X1 U1098_C3_3 (.A(N9216_1), .B(n560), .C(N4906), .Y(N9216));
  INVX4 BW1_INV8537 (.A(U958_C1__n), .Y(U958_C1__n_2));
  NAND4X4 U793_C3_3 (.A(code_4_1), .B(N4946), .C(code[6]), .D(code[7]), 
     .Y(U729_C1__n));
  AOI2BB1X1 U758_C2_1 (.A0N(U661_C1__n), .A1N(code_1_1), .B0(code[3]), 
     .Y(U907_C1__n));
  OAI211X4 U1045_C1_9 (.A0(N8465), .A1(U958_C1__n_1), .B0(sel_pc_2_3), 
     .C0(U970_C3__n_6), .Y(sel_pc[2]));
  AOI21X1 U1361_C4_1 (.A0(n571), .A1(N7840), .B0(U1226_C2__n_9), .Y(N10642));
  NOR2BX4 U718_C4_10 (.AN(U718_C4__n_2), .B(N10705_1), .Y(sel_addr1_1_1));
  NOR3BX1 U1213_C1_3 (.AN(U712_C2__n), .B(ld_instr), .C(U1213_C1__n), 
     .Y(U946_C2__n_8));
  NAND2BX1 U946_C2_7 (.AN(N1909), .B(U680_C1__n), .Y(N10333));
  NOR2X1 U1213_C1_2 (.A(sel_page_addr), .B(sel_op2[0]), .Y(U946_C2__n_7));
  SDFFSRX2 itcnt_reg_2_ (.CK(clk0_14), .D(N7357), .Q(\itcnt[2] ), .QN(n565), 
     .RN(N9737), .SE(test_se), .SI(\itcnt[1] ), .SN(VDD));
  NAND2X4 U641_C1 (.A(code[7]), .B(code[6]), .Y(U663_C1__n));
  INVX1 U1087_C1_MP_INV_1 (.A(N8409), .Y(N8409_1));
  NOR2X1 U1087_C1 (.A(U1226_C2__n_9), .B(N8409_1), .Y(N10943));
  NAND2X1 U681_C1_1 (.A(n563), .B(N9727), .Y(U718_C4__n_6));
  AOI211X1 U1146_C1_3 (.A0(U931_C1__n), .A1(N8459_1), .B0(N8589_4), 
     .C0(U1035_C1__n_1), .Y(sel_op2_0_1));
  AOI22X1 U657_C3_7 (.A0(U860_C1__n_1), .A1(U710_C3__n), .B0(N9892_4), 
     .B1(U1035_C1__n_2), .Y(N8373_1));
  NAND2X1 U1065_C1 (.A(U970_C3__n_6), .B(N8540_1), .Y(sel_pc[1]));
  INVX1 U1232_C1_1_MP_INV (.A(U934_C1__n), .Y(U934_C1__n_1));
  AOI21X2 U1138_C2_1 (.A0(N7151), .A1(N8459_1), .B0(U961_C1__n_1), .Y(N8406));
  NOR4BX1 U979_C1_4 (.AN(U979_C1__n), .B(U843_C1__n), .C(U692_C3__n_2), 
     .D(U888_C1__n), .Y(N1650_4));
  NOR2X1 U790_C1 (.A(U729_C1__n), .B(N4591), .Y(N4897_1));
  NOR3X1 U1163_C2_20 (.A(U1156_C1__n_2), .B(N7562), .C(N1781_4), .Y(N1781));
  NAND2X1 U681_C1_4 (.A(U681_C1__n), .B(U718_C4__n_8), .Y(U718_C4__n_2));
  NOR3X2 U799_C1_2 (.A(code[3]), .B(code[2]), .C(code[1]), .Y(U687_C1__n_2));
  NOR2X1 U1113_C1 (.A(code_1_1), .B(U1109_C1__n), .Y(addr_bank_a_1_1));
  AOI21X1 U754_C2_1 (.A0(U715_C1__n_4), .A1(U958_C1__n_2), .B0(N8370), 
     .Y(U976_C4__n_5));
endmodule

// Entity:one_shot_3_test_1 Model:one_shot_3_test_1 Library:L0
module one_shot_3_test_1 (rst_p, clk, d, q, rc8051RtlTop_test_point_535_in, 
     test_si, test_so, test_se, clk0_14);
  input rst_p, clk, d, rc8051RtlTop_test_point_535_in, test_si, test_se, 
     clk0_14;
  output q, test_so;
  wire N12253, N12252;
  SDFFSX1 d_del_reg (.CK(clk0_14), .D(N12253), .Q(test_so), .QN(), .SE(test_se), 
     .SI(test_si), .SN(N12252));
  NOR2BX1 U7_C1 (.AN(test_so), .B(N12253), .Y(q));
  INVX1 U8_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N12252));
  INVX1 U6_C1 (.A(d), .Y(N12253));
endmodule

// Entity:u_con_DW01_cmp2_8_0 Model:u_con_DW01_cmp2_8_0 Library:L0
module u_con_DW01_cmp2_8_0 (A, B, LEQ, TC, LT_LE, GE_GT);
  input LEQ, TC;
  output LT_LE, GE_GT;
  input [7:0] A;
  input [7:0] B;
  wire N7107, N7128, U14_C1__n, N7309, N7106, N11359, N7124, N7300, N7915, 
     N4675_1, LT_LE_1, B_6_1, A_6_1, B_5_1, A_4_1, A_5_1, B_3_1, B_4_1, B_1_1, 
     A_2_1, A_3_1, A_7_1, A_2_2, A_1_1;
  AOI21X1 U37_C1_3 (.A0(B_6_1), .A1(A[6]), .B0(N7915), .Y(N7124));
  INVX1 U37_C1_3_MP_INV (.A(B[6]), .Y(B_6_1));
  INVX1 U39_C3_2_MP_INV_1 (.A(A[7]), .Y(A_7_1));
  NAND2BX1 U39_C3 (.AN(B[7]), .B(A[7]), .Y(N7300));
  INVX1 U39_C3_2_MP_INV (.A(LT_LE_1), .Y(LT_LE));
  AOI22X1 U39_C3_2 (.A0(N7300), .A1(N7124), .B0(B[7]), .B1(A_7_1), .Y(LT_LE_1));
  INVX1 U14_C1_4_MP_INV_1 (.A(B[4]), .Y(B_4_1));
  INVX1 U12_C2_5_MP_INV (.A(A[4]), .Y(A_4_1));
  INVX1 U14_C1_4_MP_INV (.A(B[3]), .Y(B_3_1));
  AOI221X1 U12_C2_5 (.A0(B[4]), .A1(A_4_1), .B0(B[5]), .B1(A_5_1), .C0(N7309), 
     .Y(N7106));
  AOI21X1 U37_C1_5 (.A0(B[6]), .A1(A_6_1), .B0(N11359), .Y(N7915));
  AOI222X1 U25_C2_7 (.A0(N7128), .A1(N7107), .B0(B[2]), .B1(A_2_1), .C0(B[3]), 
     .C1(A_3_1), .Y(U14_C1__n));
  AOI21X1 U26_C2_5 (.A0(B_1_1), .A1(A_1_1), .B0(A[0]), .Y(N4675_1));
  INVX1 U37_C1_2_MP_INV (.A(B[5]), .Y(B_5_1));
  AOI221X1 U14_C1_4 (.A0(B_3_1), .A1(A[3]), .B0(B_4_1), .B1(A[4]), 
     .C0(U14_C1__n), .Y(N7309));
  AOI21X1 U37_C1_2 (.A0(B_5_1), .A1(A[5]), .B0(N7106), .Y(N11359));
  NAND2BX1 U25_C2 (.AN(B[2]), .B(A_2_2), .Y(N7128));
  INVX1 U12_C2_5_MP_INV_1 (.A(A[5]), .Y(A_5_1));
  INVX1 U37_C1_5_MP_INV (.A(A[6]), .Y(A_6_1));
  INVX1 U25_C2_7_MP_INV_1 (.A(A[3]), .Y(A_3_1));
  INVX1 U25_C2_7_MP_INV (.A(A_2_2), .Y(A_2_1));
  BUFX1 BL1_BUF263 (.A(A[2]), .Y(A_2_2));
  OAI2BB2X1 U26_C2_2 (.A0N(B[0]), .A1N(N4675_1), .B0(B_1_1), .B1(A_1_1), 
     .Y(N7107));
  BUFX1 BL1_BUF285 (.A(A[1]), .Y(A_1_1));
  INVX1 U26_C2_5_MP_INV (.A(B[1]), .Y(B_1_1));
endmodule

// Entity:u_con_DW01_cmp2_8_1 Model:u_con_DW01_cmp2_8_1 Library:L0
module u_con_DW01_cmp2_8_1 (A, B, LEQ, TC, LT_LE, GE_GT);
  input LEQ, TC;
  output LT_LE, GE_GT;
  input [7:0] A;
  input [7:0] B;
  wire U25_C2__n, U25_C2__n_3, N10506, N11322, N6458, N6987, N11845, N11703, 
     N3421, N8823_1, N11320_1, B_6_1, A_6_1, B_5_1, A_4_1, A_5_1, B_3_1, B_4_1, 
     A_1_1, B_1_1, A_2_1, A_3_1, B_3_2, B_2_1, B_1_2;
  OAI2BB1X1 U31_C2_2 (.A0N(N6987), .A1N(N6458), .B0(N3421), .Y(LT_LE));
  NAND2BX1 U31_C2_3 (.AN(A[7]), .B(B[7]), .Y(N3421));
  NAND2BX1 U31_C2 (.AN(B[7]), .B(A[7]), .Y(N6987));
  BUFX1 BL1_BUF287 (.A(B[1]), .Y(B_1_2));
  AOI21X1 U12_C2_10 (.A0(B_1_2), .A1(A_1_1), .B0(B[0]), .Y(N8823_1));
  AOI22X1 U12_C2_12 (.A0(A[0]), .A1(N8823_1), .B0(B_1_1), .B1(A[1]), 
     .Y(N11320_1));
  INVX1 U12_C2_10_MP_INV (.A(A[1]), .Y(A_1_1));
  NAND2BX1 U12_C2_4 (.AN(B_2_1), .B(A[2]), .Y(N11845));
  INVX1 U25_C2_7_MP_INV_1 (.A(B[4]), .Y(B_4_1));
  INVX1 U25_C2_9_MP_INV_1 (.A(A[5]), .Y(A_5_1));
  INVX1 U25_C2_7_MP_INV (.A(B_3_2), .Y(B_3_1));
  AOI21X1 U24_C3_3 (.A0(B_5_1), .A1(A[5]), .B0(N10506), .Y(N11322));
  INVX1 U12_C2_15_MP_INV (.A(A[2]), .Y(A_2_1));
  INVX1 U12_C2_12_MP_INV (.A(B_1_2), .Y(B_1_1));
  BUFX1 BL1_BUF265 (.A(B[2]), .Y(B_2_1));
  AOI222X1 U12_C2_15 (.A0(N11845), .A1(N11320_1), .B0(B_2_1), .B1(A_2_1), 
     .C0(B_3_2), .C1(A_3_1), .Y(U25_C2__n));
  INVX1 U24_C3_3_MP_INV (.A(B[5]), .Y(B_5_1));
  AOI21X1 U24_C3_5 (.A0(B_6_1), .A1(A[6]), .B0(N11703), .Y(N6458));
  AOI21X1 U24_C3_7 (.A0(B[6]), .A1(A_6_1), .B0(N11322), .Y(N11703));
  AOI221X1 U25_C2_7 (.A0(B_3_1), .A1(A[3]), .B0(B_4_1), .B1(A[4]), 
     .C0(U25_C2__n), .Y(U25_C2__n_3));
  INVX1 U24_C3_5_MP_INV (.A(B[6]), .Y(B_6_1));
  INVX1 U24_C3_7_MP_INV (.A(A[6]), .Y(A_6_1));
  INVX1 U25_C2_9_MP_INV (.A(A[4]), .Y(A_4_1));
  INVX1 U12_C2_15_MP_INV_1 (.A(A[3]), .Y(A_3_1));
  AOI221X1 U25_C2_9 (.A0(B[4]), .A1(A_4_1), .B0(B[5]), .B1(A_5_1), 
     .C0(U25_C2__n_3), .Y(N10506));
  BUFX1 BL1_BUF226 (.A(B[3]), .Y(B_3_2));
endmodule

// Entity:u_con_DW01_cmp2_8_2 Model:u_con_DW01_cmp2_8_2 Library:L0
module u_con_DW01_cmp2_8_2 (A, B, LEQ, TC, LT_LE, GE_GT);
  input LEQ, TC;
  output LT_LE, GE_GT;
  input [7:0] A;
  input [7:0] B;
  wire U13_C2__n_3, N9958, N6967, U17_C2__n, N11722, N6973, N6149, N282, N283, 
     LT_LE_1, A_7_1, B_7_1, A_6_1, B_5_1, B_6_1, A_4_1, A_5_1, B_3_1, B_4_1, 
     A_2_1, A_3_1, B_1_1, B_2_1, B_3_2, B_2_2, B_1_2;
  INVX1 U22_C2_3_MP_INV_1 (.A(A[7]), .Y(A_7_1));
  AOI21X1 U22_C2_5 (.A0(B_7_1), .A1(A[7]), .B0(N6973), .Y(N6149));
  INVX1 U22_C2_5_MP_INV (.A(B[7]), .Y(B_7_1));
  AOI21X1 U22_C2_3 (.A0(B[7]), .A1(A_7_1), .B0(N6149), .Y(LT_LE_1));
  INVX1 U22_C2_3_MP_INV (.A(LT_LE_1), .Y(LT_LE));
  NAND2BX1 U14_C1_2 (.AN(A[0]), .B(B[0]), .Y(N282));
  BUFX1 BL1_BUF266 (.A(B[2]), .Y(B_2_2));
  BUFX1 BL1_BUF288 (.A(B[1]), .Y(B_1_2));
  AOI221X1 U20_C2_9 (.A0(B_3_1), .A1(A[3]), .B0(B_4_1), .B1(A[4]), .C0(N9958), 
     .Y(N6967));
  INVX1 U20_C2_9_MP_INV (.A(B_3_2), .Y(B_3_1));
  INVX1 U17_C2_4_MP_INV_1 (.A(B[6]), .Y(B_6_1));
  AOI221X1 U20_C2_11 (.A0(B[4]), .A1(A_4_1), .B0(B[5]), .B1(A_5_1), .C0(N6967), 
     .Y(U17_C2__n));
  NAND2BX1 U14_C1_3 (.AN(A[1]), .B(B_1_2), .Y(N283));
  INVX1 U13_C2_7_MP_INV (.A(B_1_2), .Y(B_1_1));
  INVX1 U13_C2_7_MP_INV_1 (.A(B_2_2), .Y(B_2_1));
  INVX1 U22_C2_2_MP_INV (.A(A[6]), .Y(A_6_1));
  INVX1 U20_C2_11_MP_INV_1 (.A(A[5]), .Y(A_5_1));
  AOI221X1 U17_C2_4 (.A0(B_5_1), .A1(A[5]), .B0(B_6_1), .B1(A[6]), 
     .C0(U17_C2__n), .Y(N11722));
  INVX1 U17_C2_4_MP_INV (.A(B[5]), .Y(B_5_1));
  INVX1 U20_C2_9_MP_INV_1 (.A(B[4]), .Y(B_4_1));
  INVX1 U20_C2_11_MP_INV (.A(A[4]), .Y(A_4_1));
  AOI21X1 U22_C2_2 (.A0(B[6]), .A1(A_6_1), .B0(N11722), .Y(N6973));
  INVX1 U13_C2_9_MP_INV (.A(A[2]), .Y(A_2_1));
  AOI222X1 U13_C2_7 (.A0(N283), .A1(N282), .B0(B_1_1), .B1(A[1]), .C0(B_2_1), 
     .C1(A[2]), .Y(U13_C2__n_3));
  BUFX1 BL1_BUF227 (.A(B[3]), .Y(B_3_2));
  INVX1 U13_C2_9_MP_INV_1 (.A(A[3]), .Y(A_3_1));
  AOI221X1 U13_C2_9 (.A0(B_2_2), .A1(A_2_1), .B0(B_3_2), .B1(A_3_1), 
     .C0(U13_C2__n_3), .Y(N9958));
endmodule

// Entity:u_con_DW01_cmp2_8_3 Model:u_con_DW01_cmp2_8_3 Library:L0
module u_con_DW01_cmp2_8_3 (A, B, LEQ, TC, LT_LE, GE_GT);
  input LEQ, TC;
  output LT_LE, GE_GT;
  input [7:0] A;
  input [7:0] B;
  wire N7157, N11076, U13_C2__n, N11946, N11945, N10569, N7550, N12134, N2816, 
     LT_LE_1, A_7_1, B_7_1, A_6_1, B_5_1, B_6_1, A_4_1, A_5_1, B_3_1, B_4_1, 
     A_2_1, A_3_1, B_1_1, B_2_1;
  INVX1 U6_C2_11_MP_INV_1 (.A(A[5]), .Y(A_5_1));
  AOI221X1 U6_C2_11 (.A0(B[4]), .A1(A_4_1), .B0(B[5]), .B1(A_5_1), .C0(N11076), 
     .Y(U13_C2__n));
  INVX1 U10_C2_5_MP_INV (.A(B[7]), .Y(B_7_1));
  INVX1 U10_C2_3_MP_INV (.A(LT_LE_1), .Y(LT_LE));
  AOI21X1 U10_C2_3 (.A0(B[7]), .A1(A_7_1), .B0(N10569), .Y(LT_LE_1));
  AOI21X1 U10_C2_5 (.A0(B_7_1), .A1(A[7]), .B0(N11945), .Y(N10569));
  INVX1 U10_C2_3_MP_INV_1 (.A(A[7]), .Y(A_7_1));
  AOI21X1 U10_C2_2 (.A0(B[6]), .A1(A_6_1), .B0(N11946), .Y(N11945));
  INVX1 U10_C2_2_MP_INV (.A(A[6]), .Y(A_6_1));
  INVX1 U13_C2_4_MP_INV_1 (.A(B[6]), .Y(B_6_1));
  INVX1 U13_C2_4_MP_INV (.A(B[5]), .Y(B_5_1));
  AOI222X1 U9_C2_8 (.A0(N7550), .A1(N12134), .B0(B_1_1), .B1(A[1]), .C0(B_2_1), 
     .C1(A[2]), .Y(N2816));
  INVX1 U9_C2_10_MP_INV (.A(A[2]), .Y(A_2_1));
  AOI221X1 U9_C2_10 (.A0(B[2]), .A1(A_2_1), .B0(B[3]), .B1(A_3_1), .C0(N2816), 
     .Y(N7157));
  INVX1 U6_C2_9_MP_INV_1 (.A(B[4]), .Y(B_4_1));
  INVX1 U6_C2_11_MP_INV (.A(A[4]), .Y(A_4_1));
  AOI221X1 U13_C2_4 (.A0(B_5_1), .A1(A[5]), .B0(B_6_1), .B1(A[6]), 
     .C0(U13_C2__n), .Y(N11946));
  INVX1 U9_C2_10_MP_INV_1 (.A(A[3]), .Y(A_3_1));
  AOI221X1 U6_C2_9 (.A0(B_3_1), .A1(A[3]), .B0(B_4_1), .B1(A[4]), .C0(N7157), 
     .Y(N11076));
  INVX1 U9_C2_8_MP_INV_1 (.A(B[2]), .Y(B_2_1));
  INVX1 U6_C2_9_MP_INV (.A(B[3]), .Y(B_3_1));
  NAND2BX1 U9_C2_3 (.AN(A[0]), .B(B[0]), .Y(N7550));
  NAND2BX1 U9_C2_4 (.AN(A[1]), .B(B[1]), .Y(N12134));
  INVX1 U9_C2_8_MP_INV (.A(B[1]), .Y(B_1_1));
endmodule

// Entity:u_con_DW01_cmp2_8_4 Model:u_con_DW01_cmp2_8_4 Library:L0
module u_con_DW01_cmp2_8_4 (A, B, LEQ, TC, LT_LE, GE_GT);
  input LEQ, TC;
  output LT_LE, GE_GT;
  input [7:0] A;
  input [7:0] B;
  wire N11533, N11532, U11_C2__n, N7132, N7131, N9133, N2025, N10933, N3368, 
     U17_C2__n_3, LT_LE_1, A_7_1, B_7_1, A_6_1, B_5_1, B_6_1, A_4_1, A_5_1, 
     B_3_1, B_4_1, A_2_1, A_3_1, B_0_1, A_1_1, A_3_2, A_2_2, A_1_2;
  AOI21X1 U34_C2_5 (.A0(B[7]), .A1(A_7_1), .B0(N3368), .Y(LT_LE_1));
  INVX1 U34_C2_5_MP_INV (.A(LT_LE_1), .Y(LT_LE));
  INVX1 U14_C2_10_MP_INV (.A(A[4]), .Y(A_4_1));
  AOI221X1 U14_C2_10 (.A0(B[4]), .A1(A_4_1), .B0(B[5]), .B1(A_5_1), .C0(N11532), 
     .Y(U11_C2__n));
  INVX1 U14_C2_10_MP_INV_1 (.A(A[5]), .Y(A_5_1));
  AOI21X1 U34_C2_3 (.A0(B[6]), .A1(A_6_1), .B0(N7132), .Y(N7131));
  AOI21X1 U34_C2_7 (.A0(B_7_1), .A1(A[7]), .B0(N7131), .Y(N3368));
  INVX1 U34_C2_5_MP_INV_1 (.A(A[7]), .Y(A_7_1));
  INVX1 U11_C2_4_MP_INV (.A(B[5]), .Y(B_5_1));
  INVX1 U34_C2_3_MP_INV (.A(A[6]), .Y(A_6_1));
  INVX1 U11_C2_4_MP_INV_1 (.A(B[6]), .Y(B_6_1));
  AOI221X1 U11_C2_4 (.A0(B_5_1), .A1(A[5]), .B0(B_6_1), .B1(A[6]), 
     .C0(U11_C2__n), .Y(N7132));
  NAND2BX1 U17_C2_6 (.AN(B[0]), .B(A[0]), .Y(N9133));
  AOI21X1 U17_C2_9 (.A0(A_1_1), .A1(N9133), .B0(B[1]), .Y(N10933));
  INVX1 U17_C2_13_MP_INV (.A(B[0]), .Y(B_0_1));
  BUFX1 BL1_BUF286 (.A(A[1]), .Y(A_1_2));
  INVX1 U34_C2_7_MP_INV (.A(B[7]), .Y(B_7_1));
  INVX1 U17_C2_10_MP_INV_1 (.A(A_3_2), .Y(A_3_1));
  BUFX1 BL1_BUF264 (.A(A[2]), .Y(A_2_2));
  NAND2BX1 U17_C2_8 (.AN(B[2]), .B(A_2_2), .Y(N2025));
  INVX1 U14_C2_8_MP_INV_1 (.A(B[4]), .Y(B_4_1));
  INVX1 U14_C2_8_MP_INV (.A(B[3]), .Y(B_3_1));
  BUFX1 BL1_BUF225 (.A(A[3]), .Y(A_3_2));
  AOI221X1 U14_C2_8 (.A0(B_3_1), .A1(A_3_2), .B0(B_4_1), .B1(A[4]), .C0(N11533), 
     .Y(N11532));
  AOI222X1 U17_C2_10 (.A0(B[2]), .A1(A_2_1), .B0(B[3]), .B1(A_3_1), 
     .C0(U17_C2__n_3), .C1(N2025), .Y(N11533));
  INVX1 U17_C2_10_MP_INV (.A(A_2_2), .Y(A_2_1));
  INVX1 U17_C2_9_MP_INV (.A(A_1_2), .Y(A_1_1));
  AOI31X1 U17_C2_13 (.A0(B_0_1), .A1(A_1_2), .A2(A[0]), .B0(N10933), 
     .Y(U17_C2__n_3));
endmodule

// Entity:u_con_DW01_cmp2_8_5 Model:u_con_DW01_cmp2_8_5 Library:L0
module u_con_DW01_cmp2_8_5 (A, B, LEQ, TC, LT_LE, GE_GT);
  input LEQ, TC;
  output LT_LE, GE_GT;
  input [7:0] A;
  input [7:0] B;
  wire U6_C2__n, U6_C2__n_3, N7295, N3836, N7025, N10521, N10186, N4708, N2108, 
     N2107_1, N6588_1, B_6_1, A_6_1, B_5_1, A_4_1, A_5_1, B_3_1, B_4_1, A_1_1, 
     B_1_1, A_2_1, A_3_1;
  AOI21X1 U21_C3_5 (.A0(B[6]), .A1(A_6_1), .B0(N3836), .Y(N4708));
  NAND2BX1 U18_C2 (.AN(B[7]), .B(A[7]), .Y(N10521));
  NAND2BX1 U18_C2_3 (.AN(A[7]), .B(B[7]), .Y(N10186));
  OAI2BB1X1 U18_C2_2 (.A0N(N7025), .A1N(N10521), .B0(N10186), .Y(LT_LE));
  AOI21X1 U21_C3_3 (.A0(B_6_1), .A1(A[6]), .B0(N4708), .Y(N7025));
  AOI221X1 U6_C2_9 (.A0(B[4]), .A1(A_4_1), .B0(B[5]), .B1(A_5_1), 
     .C0(U6_C2__n_3), .Y(N7295));
  AOI21X1 U21_C3_2 (.A0(B_5_1), .A1(A[5]), .B0(N7295), .Y(N3836));
  INVX1 U21_C3_2_MP_INV (.A(B[5]), .Y(B_5_1));
  INVX1 U6_C2_9_MP_INV_1 (.A(A[5]), .Y(A_5_1));
  INVX1 U6_C2_9_MP_INV (.A(A[4]), .Y(A_4_1));
  INVX1 U21_C3_5_MP_INV (.A(A[6]), .Y(A_6_1));
  INVX1 U21_C3_3_MP_INV (.A(B[6]), .Y(B_6_1));
  INVX1 U9_C2_13_MP_INV (.A(A[2]), .Y(A_2_1));
  AOI221X1 U6_C2_7 (.A0(B_3_1), .A1(A[3]), .B0(B_4_1), .B1(A[4]), .C0(U6_C2__n), 
     .Y(U6_C2__n_3));
  AOI222X1 U9_C2_13 (.A0(N6588_1), .A1(N2108), .B0(B[2]), .B1(A_2_1), .C0(B[3]), 
     .C1(A_3_1), .Y(U6_C2__n));
  INVX1 U9_C2_13_MP_INV_1 (.A(A[3]), .Y(A_3_1));
  INVX1 U6_C2_7_MP_INV_1 (.A(B[4]), .Y(B_4_1));
  INVX1 U6_C2_7_MP_INV (.A(B[3]), .Y(B_3_1));
  NAND2BX1 U9_C2_6 (.AN(B[2]), .B(A[2]), .Y(N2108));
  AOI22X1 U9_C2_11 (.A0(A[0]), .A1(N2107_1), .B0(B_1_1), .B1(A[1]), .Y(N6588_1));
  AOI21X1 U9_C2_9 (.A0(B[1]), .A1(A_1_1), .B0(B[0]), .Y(N2107_1));
  INVX1 U9_C2_9_MP_INV (.A(A[1]), .Y(A_1_1));
  INVX1 U9_C2_11_MP_INV (.A(B[1]), .Y(B_1_1));
endmodule

// Entity:u_datapath_test_1 Model:u_datapath_test_1 Library:L0
module u_datapath_test_1 (ld_apc, ld_adptr, ld_xrom, ld_idat, ld_sfr, 
     ld_operand2, end_instr, clk, rst_p, ld_instr, inc_pc, inc_pc2, inc_pc3, 
     ld_pc, ld_pcl, ld_pch, ld_acc, ld_acc_chd, sel_addr0, sel_addr1, in_xrom_a, 
     in_idat_a, in_xdat_a, sel_combus, wr_sfr, ld_dpl, ld_dph, inc_dptr, 
     sel_xad, sel_xaddr_high, sel_xaddr_low, inc_sp, dec_sp, ld_latch_acc, 
     set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac, set_v, rst_v, sel_op1, sel_op2, 
     ld_b, en_div, sel_pc, bit_addr, rmw, t0_pin, t1_pin, int0_pin, int1_pin, 
     rxdi, addr_bank_a, code, sel_bit_dat_out, sel_in_cy_bit, p0_in, p1_in, 
     p2_in, p3_in, sel_alu, reti, addr_xrom_a, addr_a, msb_a, msb_r, en_int, 
     xaddr_high, cy, ac, ov, sel_page_addr, out_acc_r, cy_psw, combus, 
     out_dimod_r, in_xrom1_r, bit_dat_in_r, p0_out, p1_out, p2_out, p3_out, 
     txdo, rxdo, out_xdat, out_idat, rc8051RtlTop_test_mode_in, 
     rc8051RtlTop_rc8051RtlTop_test_ds_1_in, rc8051RtlTop_test_point_535_in, 
     test_si3, test_so3, test_si4, test_so4, test_si5, test_so5, test_si6, 
     test_so6, test_si7, test_so7, test_si8, test_so8, test_si9, test_so9, 
     test_si10, test_so10, test_si11, test_so11, test_si12, test_so12, 
     test_si13, test_so13, test_si14, test_so14, test_si1, test_so1, test_si2, 
     test_so2, test_se, clk0_21, clk0_26, clk0_9, clk0_8, clk0_14, clk0_11, 
     clk0_10);
  input ld_apc, ld_adptr, ld_xrom, ld_idat, ld_sfr, ld_operand2, end_instr, clk, 
     rst_p, ld_instr, inc_pc, inc_pc2, inc_pc3, ld_pc, ld_pcl, ld_pch, ld_acc, 
     ld_acc_chd, sel_addr0, wr_sfr, ld_dpl, ld_dph, inc_dptr, sel_xad, 
     sel_xaddr_high, sel_xaddr_low, inc_sp, dec_sp, ld_latch_acc, set_c, rst_c, 
     cpl_c, ld_c, set_ac, rst_ac, set_v, rst_v, ld_b, en_div, bit_addr, rmw, 
     t0_pin, t1_pin, int0_pin, int1_pin, rxdi, reti, sel_page_addr, 
     rc8051RtlTop_test_mode_in, rc8051RtlTop_rc8051RtlTop_test_ds_1_in, 
     rc8051RtlTop_test_point_535_in, test_si3, test_si4, test_si5, test_si6, 
     test_si7, test_si8, test_si9, test_si10, test_si11, test_si12, test_si13, 
     test_si14, test_si1, test_si2, test_se, clk0_21, clk0_26, clk0_9, clk0_8, 
     clk0_14, clk0_11, clk0_10;
  output msb_a, msb_r, en_int, cy, ac, ov, cy_psw, bit_dat_in_r, txdo, rxdo, 
     test_so3, test_so4, test_so5, test_so6, test_so7, test_so8, test_so9, 
     test_so10, test_so11, test_so12, test_so13, test_so14, test_so1, test_so2;
  input [2:0] sel_addr1;
  input [7:0] in_xrom_a;
  input [7:0] in_idat_a;
  input [7:0] in_xdat_a;
  input [3:0] sel_combus;
  input [2:0] sel_op1;
  input [2:0] sel_op2;
  input [2:0] sel_pc;
  input [2:0] addr_bank_a;
  input [1:0] sel_bit_dat_out;
  input [2:0] sel_in_cy_bit;
  input [7:0] p0_in;
  input [7:0] p1_in;
  input [7:0] p2_in;
  input [7:0] p3_in;
  input [4:0] sel_alu;
  output [7:0] code;
  output [15:0] addr_xrom_a;
  output [7:0] addr_a;
  output [7:0] xaddr_high;
  output [7:0] out_acc_r;
  output [7:0] combus;
  output [7:0] out_dimod_r;
  output [7:0] in_xrom1_r;
  output [7:0] p0_out;
  output [7:0] p1_out;
  output [7:0] p2_out;
  output [7:0] p3_out;
  output [7:0] out_xdat;
  output [7:0] out_idat;
  wire addr_a_6_1, addr_a_5_1, addr_a_4_1, addr_a_3_1, addr_a_2_1, addr_a_1_1, 
     addr_a_0_1, combus_3_2, combus_2_2, out_xdat_7_1, out_xdat_3_2, 
     out_xdat_2_2, out_xdat_1_2, \out_dptr_r[0] , \out_dptr_r[1] , 
     \out_dptr_r[2] , \out_dptr_r[3] , \out_dptr_r[4] , \out_dptr_r[5] , 
     \out_dptr_r[6] , \out_dptr_r[7] , \out_dptr_r[8] , \out_dptr_r[9] , 
     \out_dptr_r[10] , \out_dptr_r[11] , \out_dptr_r[12] , \out_dptr_r[13] , 
     \out_dptr_r[14] , \out_dptr_r[15] , \in_idat_r[0] , \in_idat_r[1] , 
     \in_idat_r[2] , \in_idat_r[3] , \in_idat_r[4] , \in_idat_r[5] , 
     \in_idat_r[6] , \in_idat_r[7] , \out_sfr_a[0] , \out_sfr_a[1] , 
     \out_sfr_a[2] , \out_sfr_a[3] , \out_sfr_a[4] , \out_sfr_a[5] , 
     \out_sfr_a[6] , \out_sfr_a[7] , \in_xrom_r[0] , \in_xrom_r[1] , 
     \in_xrom_r[2] , \in_xrom_r[3] , \in_xrom_r[4] , \in_xrom_r[5] , 
     \in_xrom_r[6] , \in_xrom_r[7] , \out_sp_r[0] , \out_sp_r[1] , 
     \out_sp_r[2] , \out_sp_r[3] , \out_sp_r[4] , \out_sp_r[5] , \out_sp_r[6] , 
     \out_sp_r[7] , \in_rel_adder[0] , \in_rel_adder[1] , \in_rel_adder[2] , 
     \in_rel_adder[3] , \in_rel_adder[4] , \in_rel_adder[5] , \in_rel_adder[6] , 
     \in_rel_adder[7] , \in_rel_adder[8] , \in_rel_adder[9] , 
     \in_rel_adder[10] , \in_rel_adder[11] , \in_rel_adder[12] , 
     \in_rel_adder[13] , \in_rel_adder[14] , \in_rel_adder[15] , 
     \rel_addr_a[0] , \rel_addr_a[1] , \rel_addr_a[2] , \rel_addr_a[3] , 
     \rel_addr_a[4] , \rel_addr_a[5] , \rel_addr_a[6] , \rel_addr_a[7] , 
     \rel_addr_a[8] , \rel_addr_a[9] , \rel_addr_a[10] , \rel_addr_a[11] , 
     \rel_addr_a[12] , \rel_addr_a[13] , \rel_addr_a[14] , \rel_addr_a[15] , 
     \page_addr_a[0] , \page_addr_a[1] , \page_addr_a[2] , \page_addr_a[3] , 
     \page_addr_a[4] , \page_addr_a[5] , \page_addr_a[6] , \page_addr_a[7] , 
     \page_addr_a[8] , \page_addr_a[9] , \page_addr_a[10] , \page_addr_a[11] , 
     \page_addr_a[12] , \page_addr_a[13] , \page_addr_a[14] , \page_addr_a[15] , 
     \xrom[0] , \xrom[1] , \xrom[2] , \xrom[3] , \xrom[4] , \xrom[5] , 
     \xrom[6] , \xrom[7] , \int_vec[0] , \int_vec[1] , \int_vec[2] , 
     \int_vec1[0] , \int_vec1[1] , \int_vec1[2] , \int_vec2[0] , \int_vec2[1] , 
     \int_vec2[2] , \acc_chd[0] , \acc_chd[1] , \acc_chd[2] , \acc_chd[3] , 
     \acc_chd[4] , \acc_chd[5] , \acc_chd[6] , \acc_chd[7] , \in_b[0] , 
     \in_b[1] , \in_b[2] , \in_b[3] , \in_b[4] , \in_b[5] , \in_b[6] , 
     \in_b[7] , \out_b[0] , \out_b[1] , \out_b[2] , \out_b[3] , \out_b[4] , 
     \out_b[5] , \out_b[6] , \out_b[7] , \op1[1] , \op1[2] , \op1[3] , \op1[4] , 
     \op1[5] , \op1[6] , \op1[7] , acc_chd_0_1, \op2[1] , \op2[2] , \op2[3] , 
     \op2[4] , \op2[5] , \op2[6] , \op2[7] , \alu_a[0] , \alu_a[1] , \alu_a[2] , 
     \alu_a[3] , \alu_a[4] , \alu_a[5] , \alu_a[6] , \alu_a[7] , \latch_acc[0] , 
     \latch_acc[1] , \latch_acc[3] , \latch_acc[4] , \latch_acc[5] , 
     \latch_acc[6] , \latch_acc[7] , \in_pc[0] , \in_pc[1] , \in_pc[2] , 
     \in_pc[3] , \in_pc[4] , \in_pc[5] , \in_pc[6] , \in_pc[7] , \in_pc[8] , 
     \in_pc[9] , \in_pc[10] , \in_pc[11] , \in_pc[12] , \in_pc[13] , 
     \in_pc[14] , \in_pc[15] , addr2_a_2_, addr2_a_1_, addr2_a_0_, addr2_r_4_, 
     addr2_r_3_, addr2_r_2_, addr2_r_1_, addr2_r_0_, out_psw_6_, out_psw_4_, 
     out_psw_3_, N109, N110, in_cy_bit, out_pc_r_15_, out_pc_r_14_, 
     out_pc_r_13_, out_pc_r_12_, out_pc_r_11_, out_pc_r_10_, out_pc_r_9_, 
     out_pc_r_8_, out_pc_r_7_, out_pc_r_6_, out_pc_r_5_, out_pc_r_4_, 
     out_pc_r_3_, out_pc_r_2_, a_plus_pc_1_, a_plus_pc_2_, a_plus_pc_3_, 
     a_plus_pc_4_, a_plus_pc_5_, a_plus_pc_6_, a_plus_pc_7_, N309, N310, N311, 
     N312, N313, N314, N315, N316, N317, N318, N319, N320, N321, N322, N323, 
     N324, N327, n536, n537, n538, n539, n540, n541, n542, n543, n544, n619, 
     n620, n621, n622, n623, n624, n625, n632, n633, n634, n637, n638, n639, 
     n640, n641, n642, n643, n644, n645, n646, n647, n648, n649, n650, n653, 
     n654, n655, n656, n657, n658, n659, n660, n672, n673, n674, n675, n676, 
     n677, n678, n679, n680, n681, n682, out_idat_4_1, out_idat_5_1, n763, n789, 
     n790, n791, n792, n793, n794, n796, n797, n798, n799, n800, n801, n802, 
     n803, n804, n805, n806, n807, n808, n809, n810, n811, n812, n813, n814, 
     n815, n816, n817, n818, n819, n820, n821, add_465_carry_8_, 
     add_465_carry_7_, add_465_carry_6_, add_465_carry_5_, add_465_carry_4_, 
     add_465_carry_3_, add_465_carry_2_, add_434_carry_2_, \latch_pc[0] , 
     \out_sfr_r[0] , \int_vec3[1] , \int_vec3[0] , SYNOPSYS_UNCONNECTED__3, n4, 
     n11, n29, n33, n36, n47, n51, n56, n58, n60, n62, n64, n66, n68, n70, n73, 
     n75, n77, n80, n84, n86, n89, n91, n94, n97, n102, n104, n106, n120, n126, 
     n130, n137, n139, n141, n144, n146, SYNOPSYS_UNCONNECTED__0, 
     SYNOPSYS_UNCONNECTED__1, SYNOPSYS_UNCONNECTED__2, U1670_C1__n, U1669_C1__n, 
     U1668_C1__n, U1667_C1__n, U1666_C1__n, U1665_C1__n, N11792, N11791, 
     U1554_C1__n, U1560_C1__n, U1677_C1__n, U1676_C1__n, U1675_C1__n, 
     U1674_C1__n, U1572_C1__n, N5181, N10596, N5182, N10595, N11339, N11964, 
     N11963, N11287, N11286, N11223, N5175, N12053, N11144, N11142, N6248, 
     N10875, N5126, N5170, N5171, N5194, N5140, N10655, N5169, N2333, N5196, 
     N5177, N4077, N10054, N4061, N4062, N4064, U947_C2__n, U947_C2__n_1, 
     N10864, N10863, N3521, N9993, N9992, N10227, N3522, N11158, N10605, N3520, 
     N11039, N3549, N10457, N11037, N3545, N3503, N3616, N9208, N9181, N10772, 
     N9192, N9204, N9195, N9881, N9874, N9867, N11469, N9891, N12228, N8342, 
     N8484, N11208, N8382, N12251, N12147, N9735, N9711, N9707, N11706, N11705, 
     N9736, N9744, N11111, N11110, U1701_C1__n, N12032, N9390, N11984, N11983, 
     N9394, N9388, N9389, N11033, N11032, N9541, N11863, N11862, U1691_C1__n, 
     N9539, N9540, N10922, U1687_C1__n, U1685_C1__n, N6328, N6326, N6329, N6331, 
     N6327, N6345, N6336, N6335, N6334, N6333, N12038, N6337, N10779, N6332, 
     N6341, N10917, N11486, N11485, N6340, N6112, N5883, N10437, N10436, N10435, 
     N10434, N5884, N11432, N11431, N11430, N11429, N5885, N12190, N12189, 
     N12188, N12187, N5886, N12262, N12261, N12259, N5879, N10208, N10207, 
     N10206, N10205, N5880, N11595, N11594, N11593, N11592, N5881, N10993, 
     N10992, N10991, N10990, N5890, N5882, N11930, N11929, N11928, N11927, 
     N5900, N5899, N5888, N5889, N10102, N11997, N11690, N5887, N11064, N11689, 
     N7737, N11556, U864_C1__n, U864_C1__n_1, N11553, U865_C1__n, U865_C1__n_1, 
     U1007_C1__n, N10997, N10996, N7740, U721_C1__n, U1008_C1__n, N11918, 
     N11917, N7736, N10221, U737_C3__n, U737_C3__n_1, N11444, N11443, N7741, 
     U738_C2__n, U738_C2__n_1, N7799, U852_C2__n, N10401, U720_C2__n, N7749, 
     N7734, U1766_C1__n, N12202, U1762_C1__n, N7735, U1759_C1__n, N11078, N7745, 
     U885_C2__n, N7748, N6611, N6599, U896_C1__n, N11435, U1192_C1__n, N6593, 
     U1075_C1__n, U1075_C1__n_1, N6594, U948_C1__n, N12098, U1077_C1__n, 
     U1396_C1__n, N10172, N10171, N6614, U1141_C1__n, U1067_C1__n, U1021_C1__n, 
     U1020_C1__n, U1020_C1__n_1, U1068_C3__n, U1068_C3__n_1, U1068_C3__n_2, 
     U1068_C3__n_3, N10719, N6616, N10022, N6619, U1139_C1__n, N11767, N6612, 
     N12295, U1070_C1__n, U1070_C1__n_1, U1061_C1__n, U1010_C1__n, 
     U1010_C1__n_1, U1013_C3__n, U1013_C3__n_1, U1013_C3__n_2, U1013_C3__n_3, 
     U1171_C1__n, N6051, N10412, N12117, N12116, N11909, N6053, N12200, 
     U1380_C2__n_1, N11563, N11562, N6055, N11007, N5119, N6040, N6054, N10852, 
     U1185_C2__n, N10343, N8171, U1179_C2__n, N8169, N8168, N10578, U1169_C2__n, 
     N10909, N11502, N11501, N8173, N11385, U899_C2__n, N8172, N12130, 
     U895_C1__n, N8164, U893_C1__n, N12244, N8163, N7482, N7480, U839_C1__n, 
     U839_C1__n_1, N10597, N7481, N7487, N11343, N11342, N7484, N10877, N7486, 
     N10311, N7485, N7488, N11489, N10450, N7468, N7418, N11324, N5990, N5997, 
     N6895, N11550, N7041, N3021, N6651, N5599, N2912, N1690, N8597, N11073, 
     N1875, N3146, N4148, N11181, N7556, N11775, N11774, N4856, N11700, N2059, 
     N2040, N11107, N2304, N11921, N1423, N10647, N7961, N11391, N3123, N12336, 
     N11991, N10628, N10920, N3481, N6845, N1469, N9240, N10884, U1172_C3__n_2, 
     U948_C1__n_2, N11209_1, n783_1, n1074_1, in_xrom_a_7_1, U893_C1__n_2, 
     U893_C1__n_4, U852_C2__n_1, U1766_C1__n_2, U1766_C1__n_4, N12201_1, 
     U1068_C3__n_4, out_sfr_a_3_1, out_sfr_a_4_1, out_sfr_a_5_1, U1171_C1__n_2, 
     U1013_C3__n_4, N11767_1, in_xrom_a_1_1, N11984_2, out_pc_r_2_1, 
     add_434_carry_2_1, in_xrom_a_0_1, U1070_C1__n_2, U1013_C3__n_5, N11862_2, 
     in_xrom_a_6_1, in_xrom_a_2_1, in_xrom_a_4_1, in_xrom_a_5_1, sel_op2_1_1, 
     sel_op2_2_1, out_acc_r_1_1, U896_C1__n_2, U896_C1__n_4, out_acc_r_5_1, 
     out_acc_r_6_1, out_acc_r_7_1, out_sfr_a_7_1, sel_op1_1_1, U1068_C3__n_5, 
     N11342_1, N11200_1, N11110_2, U1759_C1__n_2, U1759_C1__n_4, sel_op2_0_1, 
     N11032_2, N10922_2, N7736_1, sel_op1_0_1, N10851_1, N10436_2, 
     out_acc_r_2_1, n1457_1, N10400_1, N10312_1, U982_C1__n_1, U982_C1__n_3, 
     in_xrom_a_3_1, N10021_1, N9744_1, N9388_2, U895_C1__n_2, U895_C1__n_4, 
     U738_C2__n_2, N10997_1, U1762_C1__n_2, U1762_C1__n_4, N11037_1, 
     U1010_C1__n_2, U947_C2__n_5, sel_op1_2_1, N7481_1, U1010_C1__n_3, N6618_1, 
     N3545_1, U1192_C1__n_2, U1192_C1__n_4, N6345_2, N6340_2, N6337_2, N6334_2, 
     N6332_2, N6329_2, N6037_1, out_sfr_a_6_1, out_acc_r_4_1, N5883_2, N11774_2, 
     in_pc_15_1, in_pc_15_2, sel_pc_1_1, U1554_C1__n_1, n1383_1, sel_pc_0_1, 
     sel_pc_2_1, in_pc_14_1, in_pc_14_2, N8484_1, in_pc_13_1, in_pc_13_2, 
     in_pc_12_1, in_pc_12_2, in_pc_11_1, in_pc_11_2, in_pc_10_1, in_pc_10_2, 
     in_pc_9_1, in_pc_9_2, in_pc_8_1, in_pc_8_2, in_pc_7_2, in_pc_7_3, N12228_2, 
     N9881_1, in_pc_6_2, in_pc_6_3, N8482_1, in_pc_5_1, N1707_1, in_pc_4_1, 
     in_pc_4_2, N11469_1, N8480_1, in_pc_3_1, in_pc_2_2, in_pc_2_3, N11600_1, 
     in_pc_1_1, N9891_1, N8475_1, N8475_2, in_pc_0_1, op2_7_1, op2_7_2, N3549_1, 
     op2_6_1, op2_6_2, op2_5_1, op2_4_1, N8108_2, op1_7_1, op1_7_2, N10864_1, 
     op1_6_1, op1_6_2, U947_C2__n_4, op1_4_1, op1_4_2, op1_3_2, N10863_1, 
     op1_2_2, op1_1_1, op1_1_2, out_xdat_1_1, N4062_1, out_xdat_2_1, 
     out_xdat_3_1, addr_xrom_a_0_2, N4061_1, addr_xrom_a_1_1, addr_xrom_a_2_1, 
     addr_xrom_a_3_1, addr_xrom_a_4_1, addr_xrom_a_5_1, addr_xrom_a_6_1, 
     addr_xrom_a_7_1, N11339_1, out_pc_r_8_1, N10596_1, ld_apc_1, out_pc_r_9_1, 
     out_pc_r_10_1, out_pc_r_11_1, out_pc_r_12_1, out_pc_r_13_1, out_pc_r_14_1, 
     N10544, N5598, N5641, N5611, N12054, N10077, N6226, N8905, U1777_C2__n, 
     N10115, U1771_C3__n_2, U1771_C3__n_3, U1771_C3__n_4, N9107, N3927, N1626, 
     U833_C1__n, U964_C3__n, U964_C3__n_1, U964_C3__n_2, U783_C1__n, 
     U783_C1__n_1, U953_C3__n, U953_C3__n_2, U1225_C1__n, U951_C3__n_1, 
     U950_C4__n_2, U782_C1__n, U949_C3__n_1, U1419_C4__n_2, N3922, U903_C3__n_1, 
     U902_C4__n_2, N3924, U841_C3__n_1, U842_C4__n_2, N3917, U967_C1__n_1, 
     U847_C4__n_2, N3925, N11163, N5009, N3937, N1321, N2970, N4846, N4847, 
     N4595, N4586, N10631, N4849, N2131, N4635, N2523, N3848, N4941, N4900, 
     N6847, N10187, N3100, N4992, N1559, N9895, N3850, N1549, N10747, N5004, 
     N5006, N8500, N3326, N4979, N4977, N10024, N4638, N6996, N2356, N11024, 
     N4622, N2314, out_dptr_r_3_1, N11689_1, N10187_1, N11324_1, N7737_1, 
     U1771_C3__n_5, N11556_1, U1770_C2__n_1, U1770_C2__n_3, U1770_C2__n_5, 
     U1771_C3__n_8, sel_addr1_1_1, sel_addr1_2_1, N10832_2, n633_1, N12195_2, 
     N1626_2, n632_1, N3927_2, U1771_C3__n_9, sel_addr0_1, U783_C1__n_2, 
     U964_C3__n_3, N6054_1, U1425_C2__n_1, U1425_C2__n_2, U1425_C2__n_5, 
     U783_C1__n_3, n789_1, n622_1, U1419_C4__n_5, U1419_C4__n_6, U1419_C4__n_8, 
     addr2_r_3_1, n619_1, n646_1, U953_C3__n_3, N6040_1, U1423_C2__n_3, 
     U1423_C2__n_5, n790_1, U902_C4__n_5, U902_C4__n_6, U902_C4__n_8, 
     addr2_r_2_1, n623_1, n645_1, U950_C4__n_5, U950_C4__n_6, U950_C4__n_8, 
     addr2_r_4_1, n621_1, n647_1, U842_C4__n_5, U842_C4__n_6, U842_C4__n_8, 
     addr2_r_1_1, n650_1, n644_1, U847_C4__n_5, U847_C4__n_6, U847_C4__n_8, 
     n544_1, addr2_r_0_1, n625_1, n643_1, op1_3_1, op1_3_3, op2_4_2, op2_4_3, 
     op2_4_4, op1_5_1, op1_5_2, op1_5_3, n763_1, n763_2, n763_3, N10311_1, 
     op1_2_1, op1_2_3, op2_3_1, op2_3_2, op2_3_3, op2_2_1, op2_2_2, N11489_1, 
     op2_1_1, op2_1_2, op2_1_3, acc_chd_0_2, acc_chd_0_3, acc_chd_0_4, N3289_1, 
     N3289_2, N3289_3, op2_5_2, op2_5_3, op2_5_4, N3407_1, N3407_2, N3407_3, 
     N3407_4, N10597_1, N2970_1, N2970_2, N2970_3, n688_1, n688_2, N3082_1, 
     N3082_2, N3082_3, n761_1, N7480_1, N11163_1, N11163_2, N11163_3, 
     out_idat_3_1, out_idat_3_2, out_idat_3_3, N11563_1, N10172_1, N5009_1, 
     N5009_2, N5009_3, N5009_4, out_idat_2_1, out_idat_2_2, out_idat_2_3, 
     N6614_1, N10171_1, N3937_1, N3937_2, N3937_3, N3937_5, out_idat_1_1, 
     N12117_1, N10022_1, N1321_3, N1321_4, N1321_5, N10401_1, out_idat_0_2, 
     out_idat_0_3, bit_addr_1, out_acc_r_1_2, out_acc_r_2_2, test_se_1, 
     test_se_2, N9867_1, N9874_1, N8342_1, out_idat_6_1, combus_3_1, combus_2_1, 
     combus_0_1, combus_1_1, op1_7_3, N3407_6, N1321_1, N9993_1, N9993_2, 
     N9992_1, U947_C2__n_2, N10457_3, sel_op1_2_2, code_7_1, N12195_21, 
     N1626_21, N12147_1, test_se_3, test_se_4, test_se_5, N3082, N2970_4, 
     N11163_4, N3937_4, N11209, out_idat_6_3, out_idat_7_1, U948_C1__n_1, 
     N3289_5, N3407_5, N3289_4, N10457_1, U1771_C3__n_1, U948_C1__n_3, op1_1_3, 
     N10863_2, N5140_1, N10832_3, code_4_1;
  supply1 VDD;
  supply0 VSS;
  MXI2X4 U847_C4_4 (.A(U847_C4__n_2), .B(addr_bank_a[0]), .S0(sel_addr0), 
     .Y(N3925));
  SDFFRHQX1 in_idat1_r_reg_1_ (.CK(clk0_11), .D(\in_idat_r[1] ), .Q(n794), 
     .RN(N12147_1), .SE(test_se_3), .SI(n36));
  OAI2BB1X4 U812_C2_7 (.A0N(in_idat_a[0]), .A1N(N10864_1), .B0(n763_3), .Y(n763));
  BUFX4 BL1_ASSIGN_BUF9 (.A(addr_a[7]), .Y(msb_a));
  MXI2X1 U1628_C3_1 (.A(n679), .B(out_acc_r_4_1), .S0(ld_latch_acc), .Y(N5884));
  MXI2X1 U1312_C4_1 (.A(n645), .B(in_xrom_a_2_1), .S0(ld_xrom), .Y(N10205));
  NOR2X2 U843_C2_2 (.A(N9107), .B(n634), .Y(N1559));
  AOI22X1 U950_C4_13 (.A0(U1771_C3__n_1), .A1(N5140), .B0(N3927_2), 
     .B1(\out_sp_r[4] ), .Y(U950_C4__n_6));
  MXI2X1 U1629_C3_1 (.A(n680), .B(n1457_1), .S0(ld_latch_acc), .Y(N10434));
  INVX1 U965_C1 (.A(\out_sp_r[7] ), .Y(N7468));
  SDFFSRX1 latch_acc_reg_2_ (.CK(clk0_11), .D(N10435), .Q(test_so1), .QN(n681), 
     .RN(N12147_1), .SE(test_se_5), .SI(\latch_acc[1] ), .SN(VDD));
  XNOR2X1 U1569_C1 (.A(\out_dptr_r[13] ), .B(U1674_C1__n), .Y(N11286));
  NOR2X1 U902_C4_7 (.A(N9107), .B(n637), .Y(N4622));
  INVX1 U739_C1 (.A(N3917), .Y(addr2_a_1_));
  INVX1 U1013_C3_3_MP_INV (.A(U1013_C3__n_2), .Y(U1013_C3__n_4));
  INVX1 U938_C1_2_MP_INV_1 (.A(N3924), .Y(n1074_1));
  AOI22X1 U902_C4_12 (.A0(n623_1), .A1(N12195_21), .B0(N1626_21), .B1(n645_1), 
     .Y(U902_C4__n_5));
  INVX2 U861_C1 (.A(N11553), .Y(N7745));
  OAI22X1 U900_C1_7 (.A0(n800), .A1(N7741), .B0(n817), .B1(N11443), 
     .Y(U1762_C1__n_2));
  AOI22X1 U1170_C1_2 (.A0(\in_xrom_r[6] ), .A1(N10996), .B0(out_acc_r[6]), 
     .B1(N10997), .Y(N11502));
  AOI22X1 U1527_C3_14 (.A0(in_xrom_a[3]), .A1(N9874_1), .B0(\rel_addr_a[3] ), 
     .B1(N9867_1), .Y(in_pc_3_1));
  SDFFSRX1 latch_pc_reg_1_ (.CK(clk0_11), .D(N9744), .Q(n66), .QN(n810), 
     .RN(N12147), .SE(test_se_5), .SI(\latch_pc[0] ), .SN(VDD));
  NAND2X1 U1760_C1_3 (.A(N12201_1), .B(N12130), .Y(N11163_1));
  NAND2X1 U1047_C1 (.A(U864_C1__n_1), .B(U721_C1__n), .Y(N11917));
  NAND2X1 U1402_C1 (.A(\out_dptr_r[5] ), .B(out_acc_r[5]), .Y(N11064));
  NOR2X1 U950_C4_7 (.A(N9107), .B(n642), .Y(N2356));
  NAND2BX1 U949_C3_1 (.AN(U1771_C3__n_8), .B(n792), .Y(U949_C3__n_1));
  SDFFSRX1 in_idat_r_reg_6_ (.CK(clk0_10), .D(N10990), .Q(\in_idat_r[6] ), 
     .QN(n640), .RN(N12147_1), .SE(test_se_2), .SI(\in_idat_r[5] ), .SN(VDD));
  AOI222X1 U1504_C3_6 (.A0(N9881_1), .A1(N5140), .B0(N3289_5), .B1(N12228_2), 
     .C0(n672), .C1(N1707_1), .Y(in_pc_4_2));
  INVX1 U1508_C2_7_MP_INV (.A(N8484), .Y(N8484_1));
  AOI2BB2X1 U1521_C2_7 (.A0N(N1321_1), .A1N(N8484), .B0(\page_addr_a[8] ), 
     .B1(N8342_1), .Y(in_pc_8_1));
  AOI222X1 U1502_C2_9 (.A0(N2970), .A1(N12228_2), .B0(\page_addr_a[6] ), 
     .B1(N8342_1), .C0(\rel_addr_a[6] ), .C1(N9867_1), .Y(in_pc_6_3));
  INVX1 U1599_C5_6_MP_INV (.A(N6337_2), .Y(N6337));
  OAI221X1 U1172_C3_7 (.A0(U948_C1__n_2), .A1(N11767), .B0(N4595), .B1(N6612), 
     .C0(N2304), .Y(U1172_C3__n_2));
  OAI22X1 U1394_C3_1 (.A0(n641), .A1(U947_C2__n_4), .B0(out_acc_r_5_1), 
     .B1(U947_C2__n_1), .Y(N10605));
  OR3X1 U832_C2_3 (.A(sel_pc_2_1), .B(sel_pc[1]), .C(sel_pc[0]), .Y(N9867));
  SDFFSRX2 in_xrom1_r_reg_6_ (.CK(clk0_14), .D(N5899), .Q(in_xrom1_r[6]), 
     .QN(n622), .RN(N12147), .SE(test_se_3), .SI(in_xrom1_r[5]), .SN(VDD));
  INVX1 U1543_C4_1_MP_INV (.A(in_xrom_a[6]), .Y(in_xrom_a_6_1));
  NOR2X1 U797_C1 (.A(sel_combus[1]), .B(sel_combus[0]), .Y(U865_C1__n_1));
  MXI2X1 U1316_C4_1 (.A(n647), .B(in_xrom_a_4_1), .S0(ld_xrom), .Y(N11595));
  NOR2X1 U1706_C2_5 (.A(N11563_1), .B(out_idat_3_2), .Y(out_idat_3_3));
  INVX1 U1120_C1 (.A(\out_sfr_a[0] ), .Y(N4595));
  NOR2X1 U928_C1 (.A(n638), .B(N10457_1), .Y(N8173));
  NAND2BX1 U1763_C1_5 (.AN(N5009_2), .B(N7749), .Y(N5009_3));
  AOI22X1 U784_C2_1 (.A0(\out_b[0] ), .A1(N3503), .B0(\out_sfr_r[0] ), 
     .B1(N3545_1), .Y(N6618_1));
  BUFX20 BW1_BUF1628 (.A(out_idat_7_1), .Y(out_idat[7]));
  INVX1 U1710_C3_7_MP_INV (.A(N3549), .Y(N3549_1));
  AOI2BB2X1 U1710_C3_6 (.A0N(n656), .A1N(N3545), .B0(\out_b[7] ), .B1(N3503), 
     .Y(op2_7_1));
  BUFX3 BL2_BUF134 (.A(U947_C2__n), .Y(U947_C2__n_2));
  INVX1 U699_C1_2_MP_INV (.A(sel_op1_2_2), .Y(sel_op1_2_1));
  SDFFSRX1 in_xrom_r_reg_6_ (.CK(clk0_14), .D(N11593), .Q(\in_xrom_r[6] ), 
     .QN(n648), .RN(N12147), .SE(test_se_5), .SI(\in_xrom_r[5] ), .SN(VDD));
  OR2X1 U1634_C1 (.A(n673), .B(\int_vec3[1] ), .Y(N9204));
  AOI21X2 U1777_C2_1 (.A0(N11689_1), .A1(U1777_C2__n), .B0(N7737_1), .Y(N10115));
  OAI2BB1X1 U1342_C2_6 (.A0N(ld_apc), .A1N(a_plus_pc_3_), .B0(addr_xrom_a_3_1), 
     .Y(addr_xrom_a[3]));
  XOR2X1 U1702_C1 (.A(out_pc_r_3_), .B(U1701_C1__n), .Y(N11485));
  OAI2BB1X1 U1357_C3_6 (.A0N(ld_apc), .A1N(a_plus_pc_4_), .B0(addr_xrom_a_4_1), 
     .Y(addr_xrom_a[4]));
  INVX1 U558_C5_6_MP_INV_2 (.A(N10596), .Y(N10596_1));
  OAI222X1 U587_C5_6 (.A0(N11963), .A1(N11339_1), .B0(ld_apc_1), .B1(N11964), 
     .C0(out_pc_r_14_1), .C1(N10596_1), .Y(addr_xrom_a[14]));
  XOR2X1 U1688_C1 (.A(out_pc_r_10_), .B(U1687_C1__n), .Y(N6112));
  SDFFX1 int_vec2_reg_2_ (.CK(clk0_11), .D(\int_vec1[2] ), .Q(\int_vec2[2] ), 
     .QN(), .SE(test_se_5), .SI(\int_vec2[1] ));
  NOR2X1 U1019_C1 (.A(U948_C1__n), .B(U1396_C1__n), .Y(U1068_C3__n_3));
  BUFX1 BL2_BUF7 (.A(out_idat[6]), .Y(out_idat_6_3));
  NAND2X1 U1395_C1 (.A(\in_idat_r[2] ), .B(U948_C1__n), .Y(N6614));
  OAI2BB1X4 U1722_C1_8 (.A0N(in_idat_a[1]), .A1N(N11037_1), .B0(op2_1_3), 
     .Y(\op2[1] ));
  NAND2X1 U852_C2 (.A(in_xrom_a[0]), .B(U852_C2__n_1), .Y(N10401));
  OAI221X4 U28_C4_6 (.A0(n641), .A1(N4062), .B0(sel_xad), .B1(out_acc_r_5_1), 
     .C0(N3146), .Y(out_xdat[5]));
  BUFX16 BL1_BUF441 (.A(bit_addr), .Y(bit_addr_1));
  NAND3X1 U1109_C2_2 (.A(sel_op1_2_2), .B(sel_op1_1_1), .C(sel_op1[0]), 
     .Y(N10863_2));
  u_alu_test_1 U3_alu (.en_div(en_div), .clk(), .rst_p(rst_p), .OP_B({\op2[7] , 
     \op2[6] , \op2[5] , \op2[4] , \op2[3] , \op2[2] , \op2[1] , acc_chd_0_1}), 
     .OP_A({op1_7_3, \op1[6] , \op1[5] , \op1[4] , \op1[3] , \op1[2] , \op1[1] , 
     n763}), .SEL({sel_alu[4], sel_alu[3], sel_alu[2], sel_alu[1], sel_alu[0]}), 
     .IN_C(cy_psw), .IN_AC(out_psw_6_), .ALU({\alu_a[7] , \alu_a[6] , 
     \alu_a[5] , \alu_a[4] , \alu_a[3] , \alu_a[2] , \alu_a[1] , \alu_a[0] }), 
     .CY(cy), .AC(ac), .OV(ov), .IN_B({\in_b[7] , \in_b[6] , \in_b[5] , 
     \in_b[4] , \in_b[3] , \in_b[2] , \in_b[1] , \in_b[0] }), .acc_chd({
     \acc_chd[7] , \acc_chd[6] , \acc_chd[5] , \acc_chd[4] , \acc_chd[3] , 
     \acc_chd[2] , \acc_chd[1] , \acc_chd[0] }), 
     .rc8051RtlTop_rc8051RtlTop_test_ds_1_in(rc8051RtlTop_rc8051RtlTop_test_ds_1_in), 
     .rc8051RtlTop_test_mode_in(rc8051RtlTop_test_mode_in), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si1(n11), .test_so1(test_so11), .test_si2(test_si12), 
     .test_so2(test_so12), .test_si3(test_si13), .test_so3(test_so13), 
     .test_si4(test_si14), .test_so4(n4), .test_se(test_se_4), 
     .clk0_26(clk0_26), .clk0_5(clk0_10));
  MXI2X1 U1541_C4_1 (.A(n536), .B(in_xrom_a_0_1), .S0(ld_instr), .Y(N5881));
  OAI21X1 U34_C4_6 (.A0(sel_xad), .A1(out_acc_r_2_1), .B0(out_xdat_2_1), 
     .Y(out_xdat_2_2));
  NAND2X1 U24_C4_4 (.A(\out_dptr_r[7] ), .B(N4064), .Y(N8597));
  ADDFX1 U1565 (.A(out_acc_r[3]), .B(out_pc_r_3_), .CI(add_465_carry_3_), 
     .CO(add_465_carry_4_), .S(a_plus_pc_3_));
  AOI22X1 U34_C4_5 (.A0(\in_idat_r[2] ), .A1(N4062_1), .B0(\out_dptr_r[2] ), 
     .B1(N4064), .Y(out_xdat_2_1));
  OAI2BB2X4 U727_C2_2 (.A0N(\out_dptr_r[1] ), .A1N(out_acc_r_1_2), .B0(N10544), 
     .B1(N5598), .Y(N5641));
  INVX1 U1773_C1_MP_INV (.A(U1771_C3__n_5), .Y(U1771_C3__n_2));
  NOR2X1 U902_C4_6 (.A(N10832_2), .B(addr2_r_2_1), .Y(N11024));
  INVX1 U1173_C3_1_MP_INV_1 (.A(N11767), .Y(N11767_1));
  AOI222X1 U1173_C3_1 (.A0(U948_C1__n_1), .A1(N10412), .B0(\out_sfr_a[1] ), 
     .B1(U1171_C1__n), .C0(\out_sfr_a[1] ), .C1(N11767_1), .Y(N12117));
  AND2X1 U1075_C1 (.A(U1075_C1__n_1), .B(U1075_C1__n), .Y(U948_C1__n));
  BUFX1 BL1_ASSIGN_BUF13 (.A(combus_3_2), .Y(out_idat[3]));
  NOR2BX1 U1057_C1 (.AN(sel_combus[1]), .B(sel_combus[0]), .Y(U1007_C1__n));
  NOR2BX1 U1755_C2_3 (.AN(N11435), .B(N3082_1), .Y(N3082_2));
  AOI21X4 U1754_C1_6 (.A0(\alu_a[1] ), .A1(N7745), .B0(N3937_5), .Y(N3937_4));
  SDFFSRX1 latch_pc_reg_14_ (.CK(clk0_14), .D(N6334), .Q(n89), .QN(n797), 
     .RN(N12147_1), .SE(test_se_5), .SI(n86), .SN(VDD));
  AOI21X1 U893_C1_1 (.A0(in_xrom_a[7]), .A1(U852_C2__n_1), .B0(U893_C1__n), 
     .Y(N12244));
  SDFFRHQX1 latch_pc_reg_0_ (.CK(clk0_14), .D(N6341), .Q(\latch_pc[0] ), 
     .RN(N12147_1), .SE(test_se_5), .SI(\latch_acc[7] ));
  SDFFSX1 alu_r_reg_4_ (.CK(clk0_14), .D(\alu_a[4] ), .Q(n58), .QN(n818), 
     .SE(test_se_3), .SI(n33), .SN(VDD));
  NOR2BX1 U894_C2_4 (.AN(N8164), .B(N2970_1), .Y(N2970_2));
  BUFX3 BW1_BUF960 (.A(out_xdat_2_2), .Y(out_xdat[2]));
  BUFX16 BW1_BUF881 (.A(addr_a_3_1), .Y(addr_a[3]));
  OAI21X2 U1423_C2 (.A0(U1423_C2__n_5), .A1(U1423_C2__n_3), .B0(sel_addr0_1), 
     .Y(U1225_C1__n));
  INVX1 U950_C4_6_MP_INV (.A(addr2_r_4_), .Y(addr2_r_4_1));
  AOI22X1 U1523_C2_8 (.A0(in_xrom_a[7]), .A1(N9874_1), .B0(U1771_C3__n_2), 
     .B1(N9881_1), .Y(in_pc_7_2));
  XOR2X1 U1680_C1 (.A(out_pc_r_14_), .B(N6336), .Y(N6335));
  SDFFSRX4 code_reg_3_ (.CK(clk0_14), .D(N9735), .Q(code[3]), .QN(n539), 
     .RN(N12147), .SE(test_se), .SI(code[2]), .SN(VDD));
  OAI211X1 U1512_C2_10 (.A0(N9881), .A1(N5175), .B0(in_pc_12_2), .C0(in_pc_12_1), 
     .Y(\in_pc[12] ));
  XOR2X1 U1684_C1 (.A(out_pc_r_12_), .B(N6328), .Y(N6326));
  NAND2X1 U1296_C3_2 (.A(ld_idat), .B(in_idat_a[6]), .Y(N2059));
  SDFFSRX2 in_xrom1_r_reg_4_ (.CK(clk0_14), .D(N5888), .Q(in_xrom1_r[4]), 
     .QN(n621), .RN(N12147), .SE(test_se_3), .SI(in_xrom1_r[3]), .SN(VDD));
  SDFFSRX4 code_reg_2_ (.CK(clk0_14), .D(N11690), .Q(code[2]), .QN(n538), 
     .RN(N12147), .SE(test_se), .SI(code[1]), .SN(VDD));
  OAI22X1 U891_C1_7 (.A0(n799), .A1(N7741), .B0(n818), .B1(N11443), 
     .Y(U1759_C1__n_2));
  OAI2BB1X2 U726_C4_2 (.A0N(sel_bit_dat_out[0]), .A1N(N6594), .B0(N10884), 
     .Y(U948_C1__n_3));
  MXI2X1 U1289_C4_1 (.A(n632), .B(in_xrom_a_7_1), .S0(sel_page_addr), 
     .Y(\xrom[7] ));
  SDFFSRX1 in_xrom_r_reg_0_ (.CK(clk0_14), .D(N10207), .Q(\in_xrom_r[0] ), 
     .QN(n643), .RN(N12147), .SE(test_se_3), .SI(in_xrom1_r[7]), .SN(VDD));
  AOI22X1 U1719_C3_8 (.A0(in_idat_a[3]), .A1(N11037_1), .B0(\in_idat_r[3] ), 
     .B1(N10457_3), .Y(N8108_2));
  MXI2X1 U1327_C4_1 (.A(n653), .B(N4586), .S0(ld_sfr), .Y(N5885));
  AOI2BB2X1 U913_C1_2 (.A0N(n656), .A1N(N10863), .B0(in_idat_a[7]), 
     .B1(N10864_1), .Y(N11039));
  OAI2BB2X1 U1716_C1_1_C3_6 (.A0N(N3503), .A1N(\out_b[3] ), .B0(in_xrom_a_3_1), 
     .B1(N3616), .Y(op2_3_1));
  NOR2X1 U1722_C1_5 (.A(N8173), .B(N3100), .Y(op2_1_1));
  NAND2X1 U1722_C1_6 (.A(N7418), .B(op2_1_1), .Y(op2_1_2));
  NAND2X1 U1729_C3_2 (.A(in_idat_a[5]), .B(N10864_1), .Y(N10647));
  AOI22X1 U1725_C3_6 (.A0(in_xrom_a[7]), .A1(N9992_1), .B0(\out_sfr_a[7] ), 
     .B1(N9993_2), .Y(op1_7_1));
  AOI21X1 U1525_C3_8 (.A0(\page_addr_a[5] ), .A1(N8342_1), .B0(N6845), 
     .Y(N8482_1));
  INVX1 BL2_INV11 (.A(N10457_1), .Y(N10457_3));
  MXI2X1 U1307_C4_1 (.A(n619), .B(in_xrom_a_3_1), .S0(ld_operand2), .Y(N10102));
  INVX1 U245_C5_6_MP_INV (.A(N6334_2), .Y(N6334));
  INVX1 U1551_C2_2_MP_INV (.A(U1554_C1__n_1), .Y(U1554_C1__n));
  XOR2X1 U1468_C1 (.A(N6040_1), .B(N8905), .Y(U953_C3__n_3));
  NOR2X1 U1422_C3_3 (.A(N9107), .B(n640), .Y(N4638));
  AND2X1 U1699_C1 (.A(out_pc_r_4_), .B(N12032), .Y(N11983));
  ADDFHX1 U1562 (.A(out_acc_r[7]), .B(out_pc_r_7_), .CI(add_465_carry_7_), 
     .CO(add_465_carry_8_), .S(a_plus_pc_7_));
  AOI222X1 U251_C5_6 (.A0(N11705), .A1(N10437), .B0(inc_pc2), .B1(N320), 
     .C0(out_pc_r_11_), .C1(N9736), .Y(N10436_2));
  NOR2BX1 U1665_C1 (.AN(U1665_C1__n), .B(out_pc_r_14_1), .Y(N11792));
  OAI222X1 U599_C5_6 (.A0(N11339_1), .A1(N11144), .B0(ld_apc_1), .B1(N12053), 
     .C0(out_pc_r_11_1), .C1(N10596_1), .Y(addr_xrom_a[11]));
  INVX1 U880_C1 (.A(\out_sfr_a[1] ), .Y(N4586));
  NAND2X1 U854_C1_3 (.A(U1068_C3__n), .B(N7482), .Y(N10628));
  AOI22X1 U971_C1_1 (.A0(U948_C1__n_1), .A1(U1020_C1__n), .B0(\in_idat_r[5] ), 
     .B1(U1020_C1__n_1), .Y(N11342_1));
  OAI2BB1X4 U1166_C4_8 (.A0N(in_idat_a[0]), .A1N(N11037_1), .B0(acc_chd_0_4), 
     .Y(acc_chd_0_1));
  INVX1 U1626_C3_1_MP_INV (.A(out_acc_r[6]), .Y(out_acc_r_6_1));
  SDFFSRX4 in_xrom1_r_reg_3_ (.CK(clk0_14), .D(N10102), .Q(in_xrom1_r[3]), 
     .QN(n619), .RN(N12147), .SE(test_se_3), .SI(in_xrom1_r[2]), .SN(VDD));
  SDFFSRX1 out_sfr_r_reg_4_ (.CK(clk0_14), .D(N12188), .Q(n137), .QN(n659), 
     .RN(N12147_1), .SE(test_se_2), .SI(n130), .SN(VDD));
  SDFFSRX4 code_reg_7_ (.CK(clk0_14), .D(N12251), .Q(code[7]), .QN(n543), 
     .RN(N12147), .SE(test_se), .SI(code[6]), .SN(VDD));
  MXI2X1 U1310_C4_1 (.A(n644), .B(in_xrom_a_1_1), .S0(ld_xrom), .Y(N10206));
  AOI22X1 U1450_C2_1 (.A0(\in_xrom_r[4] ), .A1(N10996), .B0(out_acc_r[4]), 
     .B1(N10997), .Y(N10851_1));
  NAND2X1 U30_C4_4 (.A(\out_dptr_r[4] ), .B(N4064), .Y(N9240));
  NAND2X1 U38_C4_4 (.A(\out_dptr_r[0] ), .B(N4064), .Y(N12336));
  AOI22X1 U842_C4_13 (.A0(U1771_C3__n_1), .A1(N4077), .B0(N3927_2), 
     .B1(\out_sp_r[1] ), .Y(U842_C4__n_6));
  INVX1 U1777_C2_1_MP_INV_1 (.A(N7737), .Y(N7737_1));
  INVX1 U1551_C2_2_MP_INV_1 (.A(N10115), .Y(n1383_1));
  XOR2X1 U1578_C1 (.A(\out_dptr_r[9] ), .B(U1560_C1__n), .Y(N5126));
  NOR2X1 U1419_C4_7 (.A(N9107), .B(n639), .Y(N1549));
  BUFX4 BW1_BUF1554 (.A(out_idat_6_3), .Y(out_idat_6_1));
  AND4X1 U1048_C3_3 (.A(U1013_C3__n_3), .B(U1013_C3__n_5), .C(N6612), .D(N11767), 
     .Y(N12116));
  AND2X1 U1141_C1 (.A(U1141_C1__n), .B(U1075_C1__n), .Y(N10719));
  BUFX1 BW1_BUF952 (.A(combus_2_2), .Y(combus_2_1));
  NOR3X4 U1774_C2_2 (.A(sel_addr1_2_1), .B(sel_addr1[0]), .C(sel_addr1[1]), 
     .Y(N12195_2));
  NOR2BX1 U872_C1 (.AN(sel_combus[0]), .B(sel_combus[1]), .Y(U864_C1__n_1));
  SDFFSRX1 latch_pc_reg_15_ (.CK(clk0_14), .D(N6337), .Q(n91), .QN(n796), 
     .RN(N12147_1), .SE(test_se_5), .SI(n89), .SN(VDD));
  AOI22X1 U966_C2_8 (.A0(N9881_1), .A1(N5196), .B0(in_xrom_a[2]), .B1(N9874_1), 
     .Y(in_pc_2_2));
  BUFX8 BW2_BUF12147 (.A(N12147), .Y(N12147_1));
  SDFFSX1 alu_r_reg_0_ (.CK(clk0_14), .D(\alu_a[0] ), .Q(n94), .QN(n814), 
     .SE(test_se_3), .SI(msb_r), .SN(VDD));
  OAI22X1 U897_C1_7 (.A0(n798), .A1(N7741), .B0(n819), .B1(N11443), 
     .Y(U896_C1__n_2));
  NOR2X1 U1767_C3_5 (.A(U982_C1__n_3), .B(N1321_3), .Y(N1321_4));
  INVX1 U723_C2_3_MP_INV (.A(N10187_1), .Y(N10187));
  BUFX16 BW1_BUF878 (.A(addr_a_6_1), .Y(addr_a[6]));
  SDFFRHQX1 in_idat1_r_reg_2_ (.CK(clk0_11), .D(\in_idat_r[2] ), .Q(n793), 
     .RN(N12147_1), .SE(test_se_3), .SI(n794));
  BUFX3 BL1_BUF452 (.A(out_acc_r[2]), .Y(out_acc_r_2_2));
  NAND4X1 U1263_C1_6 (.A(n673), .B(\int_vec3[1] ), .C(\int_vec3[0] ), 
     .D(N11469_1), .Y(N1690));
  NAND2X1 U1529_C2_2 (.A(N3937), .B(N12228_2), .Y(N7041));
  NAND2X1 U1285_C1_2 (.A(\rel_addr_a[1] ), .B(N9867_1), .Y(N10920));
  NAND2X1 U900_C1_3 (.A(\latch_acc[3] ), .B(U737_C3__n_1), .Y(N11991));
  NOR2X1 U847_C4_7 (.A(N9107), .B(n624), .Y(N4977));
  SDFFSRX1 in_xrom1_r_reg_0_ (.CK(clk0_14), .D(N11928), .Q(in_xrom1_r[0]), 
     .QN(n625), .RN(N12147), .SE(test_se_3), .SI(\in_idat_r[7] ), .SN(VDD));
  INVX2 BW1_INV9867 (.A(N9867), .Y(N9867_1));
  INVX1 U1089_C2_2_MP_INV (.A(sel_pc[1]), .Y(sel_pc_1_1));
  INVX1 U726_C4_6_MP_INV (.A(N11209), .Y(N11209_1));
  MXI2X1 U1313_C4_1 (.A(n632), .B(in_xrom_a_7_1), .S0(ld_xrom), .Y(N11592));
  SDFFSRX2 in_xrom1_r_reg_7_ (.CK(clk0_14), .D(N11929), .Q(in_xrom1_r[7]), 
     .QN(n633), .RN(N12147), .SE(test_se_3), .SI(in_xrom1_r[6]), .SN(VDD));
  INVX1 U902_C4_12_MP_INV_1 (.A(n645), .Y(n645_1));
  NAND2X1 U1706_C2_4 (.A(N12098), .B(out_idat_3_1), .Y(out_idat_3_2));
  NAND2X1 U1295_C3_2 (.A(ld_idat), .B(in_idat_a[7]), .Y(N5997));
  OAI222X1 U1189_C2_2 (.A0(N4846), .A1(N7736), .B0(n638), .B1(N11918), .C0(n653), 
     .C1(N11917), .Y(N6037_1));
  OAI2BB2X1 U885_C2_3 (.A0N(in_idat_a[5]), .A1N(N7736_1), .B0(n641), .B1(N11918), 
     .Y(U885_C2__n));
  OAI2BB1X1 U1716_C1_1_C3_8 (.A0N(N3549_1), .A1N(\out_sfr_a[3] ), .B0(op2_3_2), 
     .Y(op2_3_3));
  SDFFSRX1 out_sfr_r_reg_2_ (.CK(clk0_14), .D(N12190), .Q(n126), .QN(n655), 
     .RN(N12147_1), .SE(test_se_4), .SI(n120), .SN(VDD));
  NOR2BX1 U1731_C3_9_C2_4 (.AN(op1_2_2), .B(N4992), .Y(op1_2_1));
  OAI21X1 U1166_C4_5 (.A0(in_xrom_a_0_1), .A1(N3616), .B0(N6619), 
     .Y(acc_chd_0_2));
  INVX1 BL2_INV6 (.A(N9993), .Y(N9993_1));
  NOR3X1 U793_C2_2 (.A(sel_op1_2_2), .B(sel_op1_1_1), .C(sel_op1_0_1), .Y(N9993));
  MXI2X1 U1283_C4_1 (.A(n646), .B(in_xrom_a_3_1), .S0(sel_page_addr), 
     .Y(\xrom[3] ));
  SDFFX1 int_vec3_reg_1_ (.CK(clk0_14), .D(\int_vec2[1] ), .Q(\int_vec3[1] ), 
     .QN(n674), .SE(test_se_5), .SI(\int_vec3[0] ));
  SDFFSRX1 latch_acc_reg_3_ (.CK(clk0_11), .D(N10434), .Q(\latch_acc[3] ), 
     .QN(n680), .RN(N12147_1), .SE(test_se_5), .SI(test_si2), .SN(VDD));
  INVX1 U235_C5_6_MP_INV (.A(N11984_2), .Y(N11984));
  AOI22X1 U1345_C2_5 (.A0(U953_C3__n), .A1(N11339), .B0(out_pc_r_5_), 
     .B1(N10596), .Y(addr_xrom_a_5_1));
  SDFFX1 int_vec1_reg_0_ (.CK(clk0_11), .D(\int_vec[0] ), .Q(\int_vec1[0] ), 
     .QN(), .SE(test_se_5), .SI(\in_xrom_r[7] ));
  XOR2X1 U1690_C1 (.A(out_pc_r_9_), .B(N9539), .Y(N9540));
  INVX1 U587_C5_6_MP_INV (.A(out_pc_r_14_), .Y(out_pc_r_14_1));
  OAI222X1 U554_C5_6 (.A0(N5126), .A1(N11339_1), .B0(ld_apc_1), .B1(N10875), 
     .C0(out_pc_r_9_1), .C1(N10596_1), .Y(addr_xrom_a[9]));
  INVX4 U1660_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N12147));
  NOR4BX1 U1071_C1_3 (.AN(U1068_C3__n_2), .B(N10719), .C(U1068_C3__n_4), 
     .D(N12295), .Y(N6053));
  NAND4X1 U1068_C3_3 (.A(U1068_C3__n_3), .B(U1068_C3__n_2), .C(U1068_C3__n_1), 
     .D(U1068_C3__n), .Y(N6616));
  NAND2X1 U1707_C2_4 (.A(N11909), .B(out_idat_2_1), .Y(out_idat_2_2));
  NAND3X2 U1711_C3_9 (.A(op2_6_2), .B(op2_6_1), .C(N10772), .Y(\op2[6] ));
  AOI21X1 U1536_C1_7 (.A0(N1423), .A1(N11921), .B0(sel_in_cy_bit[2]), .Y(N11775));
  MXI2X1 U1627_C3_1 (.A(n678), .B(out_acc_r_5_1), .S0(ld_latch_acc), .Y(N11432));
  NAND2X1 U1188_C1 (.A(\out_sfr_a[1] ), .B(N10221), .Y(N10852));
  NAND3X4 U711_C3_9 (.A(op1_4_2), .B(op1_4_1), .C(N11158), .Y(\op1[4] ));
  sign U4_sign (.a({\in_xrom_r[7] , \in_xrom_r[6] , \in_xrom_r[5] , 
     \in_xrom_r[4] , \in_xrom_r[3] , \in_xrom_r[2] , \in_xrom_r[1] , 
     \in_xrom_r[0] }), .b({\in_rel_adder[15] , \in_rel_adder[14] , 
     \in_rel_adder[13] , \in_rel_adder[12] , \in_rel_adder[11] , 
     \in_rel_adder[10] , \in_rel_adder[9] , \in_rel_adder[8] , 
     \in_rel_adder[7] , \in_rel_adder[6] , \in_rel_adder[5] , \in_rel_adder[4] , 
     \in_rel_adder[3] , \in_rel_adder[2] , \in_rel_adder[1] , \in_rel_adder[0] }));
  MXI2X1 U1543_C4_1 (.A(n542), .B(in_xrom_a_6_1), .S0(ld_instr), .Y(N11706));
  NOR2X2 U1771_C3_1 (.A(U1771_C3__n_5), .B(U1771_C3__n_9), .Y(U1771_C3__n_4));
  BUFX8 BL3_S_BUF_23 (.A(N10832_3), .Y(N10832_2));
  INVX1 U1658_C5_6_MP_INV (.A(N9388_2), .Y(N9388));
  XOR2X1 U1462_C1 (.A(N6226), .B(N5194), .Y(N5140_1));
  NAND2X1 U888_C1_3 (.A(\latch_acc[1] ), .B(U737_C3__n_1), .Y(N11550));
  NAND2X1 U1572_C1 (.A(\out_dptr_r[14] ), .B(U1572_C1__n), .Y(N5181));
  BUFX20 BW1_BUF884 (.A(addr_a_0_1), .Y(addr_a[0]));
  NOR2X1 U1419_C4_6 (.A(N10832_2), .B(addr2_r_3_1), .Y(N3850));
  AND2X1 U1010_C1 (.A(U1010_C1__n_1), .B(U1010_C1__n), .Y(U1013_C3__n_3));
  NAND2X1 U1070_C1 (.A(U1070_C1__n_1), .B(U1070_C1__n), .Y(U1013_C3__n));
  AND3X1 U1056_C2_2 (.A(bit_addr_1), .B(addr_a[7]), .C(n1074_1), .Y(U1061_C1__n));
  MXI2X1 U1279_C4_1 (.A(n625), .B(in_xrom_a_0_1), .S0(ld_operand2), .Y(N11928));
  INVX1 U812_C2_4_MP_INV (.A(N10311), .Y(N10311_1));
  OAI221X4 U24_C4_6 (.A0(n634), .A1(N4062), .B0(sel_xad), .B1(out_acc_r_7_1), 
     .C0(N8597), .Y(out_xdat_7_1));
  AOI22X1 U1458_C2_1 (.A0(\in_xrom_r[1] ), .A1(N10996), .B0(out_acc_r_1_2), 
     .B1(N10997), .Y(N11200_1));
  NAND2X1 U1758_C1_3 (.A(N10851_1), .B(N8171), .Y(N3289_1));
  SDFFSRX1 latch_acc_reg_7_ (.CK(clk0_14), .D(N11430), .Q(\latch_acc[7] ), 
     .QN(n676), .RN(N12147_1), .SE(test_se_5), .SI(\latch_acc[6] ), .SN(VDD));
  INVX1 U1754_C1_6_MP_INV_1 (.A(N3937_3), .Y(N3937_5));
  NAND4BBX1 U1767_C3_4 (.AN(N7740), .BN(N10401_1), .C(N11444), .D(N7799), 
     .Y(N1321_3));
  NAND2BX2 U1771_C3_5 (.AN(N7468), .B(N3927_2), .Y(N4941));
  SDFFRHQX1 addr2_r_reg_0_ (.CK(clk0_10), .D(addr2_a_0_), .Q(addr2_r_0_), 
     .RN(N12147_1), .SE(test_se_2), .SI(n4));
  NOR2X2 U1771_C3_6 (.A(N10832_2), .B(n811), .Y(N4900));
  INVX1 U953_C3_14_MP_INV (.A(n790), .Y(n790_1));
  NAND2X1 U1502_C2_10 (.A(in_pc_6_3), .B(in_pc_6_2), .Y(\in_pc[6] ));
  AOI21X1 U1759_C1_1 (.A0(in_xrom_a[4]), .A1(U852_C2__n_1), .B0(U1759_C1__n), 
     .Y(N11078));
  MXI2X1 U1546_C4_1 (.A(n541), .B(in_xrom_a_5_1), .S0(ld_instr), .Y(N9707));
  OAI211X1 U1510_C2_10 (.A0(N9881), .A1(N11286), .B0(in_pc_13_2), 
     .C0(in_pc_13_1), .Y(\in_pc[13] ));
  XOR2X1 U1678_C1 (.A(out_pc_r_15_), .B(N6333), .Y(N12038));
  INVX8 U1709_C2_5_MP_INV (.A(out_idat_0_3), .Y(combus[0]));
  BUFX12 BL3_S_BUF_5 (.A(U948_C1__n_3), .Y(U948_C1__n_1));
  NOR2BX4 U1164_C1 (.AN(inc_pc3), .B(inc_pc2), .Y(N11705));
  OAI22X1 U1421_C3_1 (.A0(n803), .A1(N7741), .B0(n814), .B1(N11443), 
     .Y(U738_C2__n_1));
  MXI2X1 U1294_C4_1 (.A(n644), .B(in_xrom_a_1_1), .S0(sel_page_addr), 
     .Y(\xrom[1] ));
  AND2X1 U1642_C1 (.A(sel_xaddr_high), .B(\out_dptr_r[14] ), .Y(xaddr_high[6]));
  INVX1 U1419_C4_12_MP_INV_1 (.A(n646), .Y(n646_1));
  OAI21X1 U815_C1_1 (.A0(N3289_4), .A1(bit_addr_1), .B0(N10312_1), 
     .Y(out_idat_4_1));
  OAI21X4 U838_C1_1 (.A0(N3407_4), .A1(bit_addr_1), .B0(N10597_1), 
     .Y(out_idat_7_1));
  AOI21X1 U1729_C3_9_C3_7 (.A0(\out_sfr_a[5] ), .A1(N9993_2), .B0(op1_5_2), 
     .Y(op1_5_3));
  INVX1 U1720_C1_4_MP_INV (.A(N11489), .Y(N11489_1));
  INVX1 U1323_C4_1_MP_INV (.A(\out_sfr_a[4] ), .Y(out_sfr_a_4_1));
  OAI2BB2X1 U1179_C2_3 (.A0N(in_idat_a[7]), .A1N(N7736_1), .B0(n634), 
     .B1(N11918), .Y(U1179_C2__n));
  SDFFSRX1 out_sfr_r_reg_7_ (.CK(clk0_14), .D(N11429), .Q(test_so2), .QN(n656), 
     .RN(N12147_1), .SE(test_se_2), .SI(n141), .SN(VDD));
  INVX1 U1319_C4_1_MP_INV (.A(\out_sfr_a[6] ), .Y(out_sfr_a_6_1));
  AOI22X1 U1514_C2_7 (.A0(N11163), .A1(N8484_1), .B0(\page_addr_a[11] ), 
     .B1(N8342_1), .Y(in_pc_11_1));
  INVX1 U826_C3_9_C2_4_MP_INV (.A(op2_5_1), .Y(op2_5_4));
  OAI2BB1X1 U1730_C3_9_C2_5 (.A0N(N9993_2), .A1N(\out_sfr_a[3] ), .B0(op1_3_1), 
     .Y(op1_3_3));
  OAI21X1 U1652_C5_4 (.A0(N9736), .A1(N11705), .B0(N327), .Y(N11700));
  SDFFSRX1 latch_pc_reg_4_ (.CK(clk0_11), .D(N11984), .Q(n70), .QN(n807), 
     .RN(N12147), .SE(test_se_5), .SI(n102), .SN(VDD));
  INVX1 U1703_C1_MP_INV_1 (.A(add_434_carry_2_), .Y(add_434_carry_2_1));
  AOI2BB1X1 U1380_C2_2 (.A0N(U948_C1__n_2), .A1N(U1070_C1__n_1), 
     .B0(U1380_C2__n_1), .Y(N11563));
  AOI22X1 U1357_C3_5 (.A0(N5140), .A1(N11339), .B0(out_pc_r_4_), .B1(N10596), 
     .Y(addr_xrom_a_4_1));
  NOR2BX1 U1670_C1 (.AN(U1670_C1__n), .B(out_pc_r_9_1), .Y(U1669_C1__n));
  INVX1 U227_C5_6_MP_INV (.A(N6332_2), .Y(N6332));
  OAI222X1 U595_C5_6 (.A0(N5175), .A1(N11339_1), .B0(ld_apc_1), .B1(N11223), 
     .C0(out_pc_r_12_1), .C1(N10596_1), .Y(addr_xrom_a[12]));
  XOR2X1 U1696_C1 (.A(out_pc_r_6_), .B(N9389), .Y(N11033));
  AOI22X1 U1731_C3_7 (.A0(\in_idat_r[2] ), .A1(U947_C2__n_2), .B0(out_acc_r_2_2), 
     .B1(U947_C2__n_5), .Y(op1_2_2));
  INVX1 U1706_C2_5_MP_INV (.A(N11563), .Y(N11563_1));
  OAI2BB1X1 U1382_C1_1 (.A0N(U1068_C3__n_1), .A1N(N6053), .B0(\in_idat_r[2] ), 
     .Y(N12200));
  OAI21X2 U855_C1_4 (.A0(N3082), .A1(bit_addr_1), .B0(n761_1), .Y(out_idat_5_1));
  NAND3X4 U1110_C2_2 (.A(sel_addr1_1_1), .B(sel_addr1[2]), .C(sel_addr1[0]), 
     .Y(U1771_C3__n_8));
  NAND2BX1 U967_C1_1 (.AN(U1771_C3__n_8), .B(n544_1), .Y(U967_C1__n_1));
  NAND2X1 U812_C2_5 (.A(n763_1), .B(N7485), .Y(n763_2));
  AOI21X1 U1536_C1_4 (.A0(sel_in_cy_bit[0]), .A1(N11209_1), 
     .B0(sel_in_cy_bit[1]), .Y(N8382));
  u_datapath_DW01_inc_16_0 add_433 (.A({out_pc_r_15_, out_pc_r_14_, out_pc_r_13_, 
     out_pc_r_12_, out_pc_r_11_, out_pc_r_10_, out_pc_r_9_, out_pc_r_8_, 
     out_pc_r_7_, out_pc_r_6_, out_pc_r_5_, out_pc_r_4_, out_pc_r_3_, 
     out_pc_r_2_, add_434_carry_2_, N327}), .SUM({N324, N323, N322, N321, N320, 
     N319, N318, N317, N316, N315, N314, N313, N312, N311, N310, N309}));
  INVX1 U1314_C4_1_MP_INV (.A(in_xrom_a[5]), .Y(in_xrom_a_5_1));
  OAI21X4 U1770_C2 (.A0(U1770_C2__n_5), .A1(U1771_C3__n_4), .B0(sel_addr0_1), 
     .Y(U833_C1__n));
  INVX8 U1664_C1 (.A(U833_C1__n), .Y(addr_a[7]));
  OAI22X2 U1779_C2_2 (.A0(N12054), .A1(N10077), .B0(out_dptr_r_3_1), 
     .B1(n1457_1), .Y(N6226));
  XOR2X1 U1465_C1 (.A(\out_dptr_r[6] ), .B(out_acc_r[6]), .Y(N6054));
  NOR2X1 U727_C2 (.A(\out_dptr_r[1] ), .B(out_acc_r_1_2), .Y(N5598));
  INVX1 U1464_C1_MP_INV (.A(U964_C3__n_3), .Y(U964_C3__n));
  OAI22X2 U778_C2_1 (.A0(U783_C1__n_2), .A1(U782_C1__n), .B0(bit_addr_1), 
     .B1(N3917), .Y(addr_a_1_1));
  AND2X1 U1258_C1 (.A(N3925), .B(addr2_a_1_), .Y(U1077_C1__n));
  INVX2 U740_C1 (.A(N3925), .Y(addr2_a_0_));
  NOR2X1 U1146_C1 (.A(U783_C1__n_2), .B(n1074_1), .Y(U1075_C1__n));
  BUFX1 BL1_ASSIGN_BUF10 (.A(combus[0]), .Y(out_idat[0]));
  AOI22X1 U950_C4_12 (.A0(n621_1), .A1(N12195_21), .B0(N1626_21), .B1(n647_1), 
     .Y(U950_C4__n_5));
  BUFX4 BW1_BUF955 (.A(out_xdat_7_1), .Y(out_xdat[7]));
  OAI22X1 U887_C1_7 (.A0(n801), .A1(N7741), .B0(n816), .B1(N11443), 
     .Y(U1766_C1__n_2));
  OAI211X1 U707_C1_10 (.A0(n804), .A1(U738_C2__n), .B0(U893_C1__n_4), .C0(N1469), 
     .Y(U893_C1__n));
  SDFFSRX1 latch_pc_reg_12_ (.CK(clk0_14), .D(N6329), .Q(n84), .QN(n799), 
     .RN(N12147), .SE(test_se_5), .SI(n106), .SN(VDD));
  MXI2X1 U1632_C3_1 (.A(n675), .B(N4847), .S0(ld_latch_acc), .Y(N10917));
  SDFFSX1 alu_r_reg_3_ (.CK(clk0_14), .D(\alu_a[3] ), .Q(n33), .QN(n817), 
     .SE(test_se_3), .SI(n56), .SN(VDD));
  NAND2X1 U1005_C1 (.A(U864_C1__n), .B(U1008_C1__n), .Y(U738_C2__n));
  XOR2X1 U1463_C1 (.A(\out_dptr_r[4] ), .B(out_acc_r[4]), .Y(N5194));
  SDFFRHQX1 in_idat1_r_reg_6_ (.CK(clk0_11), .D(\in_idat_r[6] ), .Q(n789), 
     .RN(N12147_1), .SE(test_se_2), .SI(n790));
  NAND2BX1 U903_C3_1 (.AN(U1771_C3__n_8), .B(n793), .Y(U903_C3__n_1));
  INVX1 U833_C1_MP_INV (.A(U783_C1__n_2), .Y(U783_C1__n));
  NOR3X1 U1525_C3_10 (.A(n672), .B(N9204), .C(N11469), .Y(N6845));
  AOI222X1 U249_C5_6 (.A0(N6326), .A1(N11705), .B0(inc_pc2), .B1(N321), 
     .C0(out_pc_r_12_), .C1(N9736), .Y(N6329_2));
  INVX1 U1636_C3_1_MP_INV (.A(N9891_1), .Y(N9891));
  NAND2X1 U1263_C1_2 (.A(\rel_addr_a[4] ), .B(N9867_1), .Y(N2912));
  NAND3X4 U1775_C2_2 (.A(sel_addr1_1_1), .B(sel_addr1_2_1), .C(sel_addr1[0]), 
     .Y(N9107));
  INVX1 U1383_C2_2_MP_INV (.A(U1070_C1__n), .Y(U1070_C1__n_2));
  AOI21X4 U892_C2_6 (.A0(\alu_a[7] ), .A1(N7745), .B0(N3407_3), .Y(N3407_4));
  AND2X1 U1646_C1 (.A(sel_xaddr_high), .B(\out_dptr_r[10] ), .Y(xaddr_high[2]));
  NAND3X1 U1094_C2_2 (.A(sel_pc_2_1), .B(sel_pc[1]), .C(sel_pc_0_1), .Y(N12228));
  BUFX4 BW2_BUF12127 (.A(test_se), .Y(test_se_3));
  NAND2X1 U813_C1 (.A(in_xrom_a[0]), .B(N9992), .Y(N10311));
  NOR3X4 U1776_C1_2 (.A(sel_addr1[0]), .B(sel_addr1[1]), .C(sel_addr1[2]), 
     .Y(N1626_2));
  MXI2X1 U1325_C4_1 (.A(n660), .B(out_sfr_a_3_1), .S0(ld_sfr), .Y(N12189));
  OAI21X1 U1295_C3_1 (.A0(n634), .A1(ld_idat), .B0(N5997), .Y(N11930));
  AOI2BB2X1 U763_C1_2 (.A0N(n653), .A1N(N3545), .B0(\out_b[1] ), .B1(N3503), 
     .Y(N7418));
  NOR2X1 U1716_C1_1_C3_4 (.A(N3545), .B(n660), .Y(N2131));
  AOI22X1 U1711_C3_7 (.A0(in_xrom_a[6]), .A1(N10450), .B0(\out_sfr_a[6] ), 
     .B1(N3549_1), .Y(op2_6_2));
  SDFFSRX1 out_sfr_r_reg_1_ (.CK(clk0_14), .D(N5885), .Q(n120), .QN(n653), 
     .RN(N12147_1), .SE(test_se_2), .SI(\out_sfr_r[0] ), .SN(VDD));
  NAND2BX4 U826_C3_9_C2_6 (.AN(op2_5_3), .B(N9181), .Y(\op2[5] ));
  NAND2X1 U963_C1 (.A(\in_idat_r[0] ), .B(N10457_3), .Y(N6619));
  NAND3X1 U698_C2_2 (.A(sel_op1_2_2), .B(sel_op1_1_1), .C(sel_op1_0_1), 
     .Y(N10864));
  MXI2X1 U1321_C4_1 (.A(n658), .B(out_sfr_a_5_1), .S0(ld_sfr), .Y(N12187));
  AOI22X1 U1454_C2_1 (.A0(\in_xrom_r[3] ), .A1(N10996), .B0(out_acc_r[3]), 
     .B1(N10997), .Y(N12201_1));
  AOI22X1 U1507_C2_8 (.A0(\in_xrom_r[7] ), .A1(N9874_1), .B0(\rel_addr_a[15] ), 
     .B1(N9867_1), .Y(in_pc_15_2));
  INVX1 U1773_C1_MP_INV_1 (.A(N11556), .Y(N11556_1));
  OAI2BB1X1 U1354_C3_6 (.A0N(ld_apc), .A1N(a_plus_pc_2_), .B0(addr_xrom_a_2_1), 
     .Y(addr_xrom_a[2]));
  XOR2X1 U1700_C1 (.A(out_pc_r_4_), .B(N12032), .Y(N9390));
  SDFFX1 int_vec1_reg_2_ (.CK(clk0_11), .D(\int_vec[2] ), .Q(\int_vec1[2] ), 
     .QN(), .SE(test_se_5), .SI(\int_vec1[1] ));
  XOR2X1 U1692_C1 (.A(out_pc_r_8_), .B(U1691_C1__n), .Y(N10779));
  XOR2X1 U1686_C1 (.A(out_pc_r_11_), .B(U1685_C1__n), .Y(N10437));
  OAI222X4 U558_C5_6 (.A0(N5171), .A1(N11339_1), .B0(out_pc_r_8_1), 
     .B1(N10596_1), .C0(ld_apc_1), .C1(N5170), .Y(addr_xrom_a[8]));
  XOR2X1 U1673_C1 (.A(out_acc_r[0]), .B(N327), .Y(N10054));
  AOI31X1 U1380_C2_3 (.A0(U1070_C1__n), .A1(U1013_C3__n_4), .A2(N12116), 
     .B0(out_sfr_a_3_1), .Y(U1380_C2__n_1));
  OAI2BB1X1 U944_C1_1 (.A0N(U1068_C3__n), .A1N(N7482), .B0(\in_idat_r[6] ), 
     .Y(N11343));
  NOR2BX1 U1707_C2_3 (.AN(N12200), .B(N6614_1), .Y(out_idat_2_1));
  AOI2BB2X1 U939_C1_2 (.A0N(n655), .A1N(N10863), .B0(in_idat_a[2]), 
     .B1(N10864_1), .Y(N10227));
  SDFFSRX4 code_reg_0_ (.CK(clk0_14), .D(N5881), .Q(code[0]), .QN(n536), 
     .RN(N12147), .SE(test_se), .SI(bit_dat_in_r), .SN(VDD));
  INVX1 U1625_C3_1_MP_INV (.A(out_acc_r[7]), .Y(out_acc_r_7_1));
  INVX1 U1046_C2_2_MP_INV (.A(sel_op2[1]), .Y(sel_op2_1_1));
  SDFFSRX1 out_sfr_r_reg_5_ (.CK(clk0_14), .D(N12187), .Q(n139), .QN(n658), 
     .RN(N12147_1), .SE(test_se_2), .SI(n137), .SN(VDD));
  AOI22X1 U1517_C3_7 (.A0(N5009), .A1(N8484_1), .B0(\page_addr_a[10] ), 
     .B1(N8342_1), .Y(in_pc_10_1));
  INVX1 U1545_C4_1_MP_INV (.A(in_xrom_a[7]), .Y(in_xrom_a_7_1));
  OR2X1 U1780_C2_3 (.A(\out_dptr_r[2] ), .B(out_acc_r_2_2), .Y(N8500));
  OAI21X1 U36_C4_6 (.A0(sel_xad), .A1(out_acc_r_1_1), .B0(out_xdat_1_1), 
     .Y(out_xdat_1_2));
  OAI2BB1X1 U1351_C2_6 (.A0N(ld_apc), .A1N(a_plus_pc_1_), .B0(addr_xrom_a_1_1), 
     .Y(addr_xrom_a[1]));
  NOR2X1 U960_C1 (.A(\out_dptr_r[5] ), .B(out_acc_r[5]), .Y(N5887));
  MXI2X1 U1630_C3_1 (.A(n681), .B(out_acc_r_2_1), .S0(ld_latch_acc), .Y(N10435));
  AND2X1 U1676_C1 (.A(\out_dptr_r[11] ), .B(U1676_C1__n), .Y(U1675_C1__n));
  INVX1 U1376_C1 (.A(N3922), .Y(N12259));
  INVX1 U1419_C4_6_MP_INV (.A(addr2_r_3_), .Y(addr2_r_3_1));
  INVX1 U1048_C3_3_MP_INV (.A(U1013_C3__n_1), .Y(U1013_C3__n_5));
  NAND2X1 U1140_C1 (.A(U1141_C1__n), .B(U1067_C1__n), .Y(U1068_C3__n_1));
  BUFX16 BW1_BUF882 (.A(addr_a_2_1), .Y(addr_a[2]));
  NAND2BX1 U953_C3_6 (.AN(n620), .B(N12195_2), .Y(N2523));
  NAND2X1 U1006_C1 (.A(U864_C1__n), .B(U1007_C1__n), .Y(U852_C2__n));
  SDFFSX1 alu_r_reg_1_ (.CK(clk0_14), .D(\alu_a[1] ), .Q(n51), .QN(n815), 
     .SE(test_se_3), .SI(n94), .SN(VDD));
  AOI21X1 U1766_C1_1 (.A0(in_xrom_a[2]), .A1(U852_C2__n_1), .B0(U1766_C1__n), 
     .Y(N12202));
  INVX1 U738_C2_1_MP_INV (.A(U738_C2__n), .Y(U738_C2__n_2));
  SDFFSRX1 latch_acc_reg_0_ (.CK(clk0_11), .D(N10917), .Q(\latch_acc[0] ), 
     .QN(n675), .RN(N12147_1), .SE(test_se_5), .SI(n47), .SN(VDD));
  AOI21X1 U897_C1_9 (.A0(in_xdat_a[5]), .A1(U737_C3__n), .B0(U896_C1__n_2), 
     .Y(U896_C1__n_4));
  NAND2BX1 U1763_C1_4 (.AN(N5009_1), .B(N12202), .Y(N5009_2));
  INVX2 U1629_C3_1_MP_INV (.A(out_acc_r[3]), .Y(n1457_1));
  NOR2X1 U1419_C4_15 (.A(N1549), .B(N3850), .Y(U1419_C4__n_8));
  NOR2X1 U950_C4_15 (.A(N2356), .B(N6996), .Y(U950_C4__n_8));
  BUFX3 BW1_BUF247_4 (.A(test_se_3), .Y(test_se_2));
  INVX1 U1523_C2_8_MP_INV (.A(N9881), .Y(N9881_1));
  AOI21X1 U1636_C3_1 (.A0(n674), .A1(\int_vec3[0] ), .B0(N9195), .Y(N9891_1));
  MXI2X1 U1547_C4_1 (.A(n539), .B(in_xrom_a_3_1), .S0(ld_instr), .Y(N9735));
  OAI211X1 U1519_C2_10 (.A0(N9881), .A1(N5126), .B0(in_pc_9_2), .C0(in_pc_9_1), 
     .Y(\in_pc[9] ));
  AND2X1 U1683_C1 (.A(out_pc_r_12_), .B(N6328), .Y(N6331));
  NOR2X1 U842_C4_7 (.A(N9107), .B(n638), .Y(N5006));
  AOI21X4 U1758_C1_6 (.A0(\alu_a[4] ), .A1(N7745), .B0(N3289_3), .Y(N3289_4));
  NAND3X1 U1516_C2_5 (.A(in_pc_0_1), .B(N8475_2), .C(N8475_1), .Y(\in_pc[0] ));
  SDFFSX1 alu_r_reg_6_ (.CK(clk0_14), .D(\alu_a[6] ), .Q(n62), .QN(n820), 
     .SE(test_se_3), .SI(n60), .SN(VDD));
  NAND3BX1 U726_C4_6 (.AN(sel_bit_dat_out[0]), .B(sel_bit_dat_out[1]), 
     .C(N11209_1), .Y(N10884));
  SDFFSRX1 in_xrom_r_reg_3_ (.CK(clk0_14), .D(N5880), .Q(\in_xrom_r[3] ), 
     .QN(n646), .RN(N12147), .SE(test_se_1), .SI(\in_xrom_r[2] ), .SN(VDD));
  SDFFRHQX2 bit_dat_in_r_reg (.CK(clk0_14), .D(N11209), .Q(bit_dat_in_r), 
     .RN(N12147), .SE(test_se_3), .SI(n64));
  INVX1 U1500_C1 (.A(in_idat_a[1]), .Y(N4846));
  SDFFSRX1 in_idat_r_reg_1_ (.CK(clk0_14), .D(N10208), .Q(\in_idat_r[1] ), 
     .QN(n638), .RN(N12147_1), .SE(test_se_2), .SI(\in_idat_r[0] ), .SN(VDD));
  NOR2BX1 U1731_C3_9_C2_3 (.AN(N9992_1), .B(in_xrom_a_2_1), .Y(N4992));
  AOI21X4 U1763_C1_6 (.A0(\alu_a[2] ), .A1(N7745), .B0(N5009_3), .Y(N5009_4));
  AOI2BB2X1 U1714_C3_6 (.A0N(n659), .A1N(N3545), .B0(\out_b[4] ), .B1(N3503), 
     .Y(op2_4_1));
  BUFX8 BW2_BUF915 (.A(test_se_2), .Y(test_se_4));
  INVX1 U1317_C4_1_MP_INV (.A(\out_sfr_a[7] ), .Y(out_sfr_a_7_1));
  BUFX2 BL2_BUF133 (.A(N9992), .Y(N9992_1));
  OR2X1 U1525_C3_3 (.A(N3082), .B(N12228), .Y(N6895));
  AOI2BB2X1 U826_C3_6 (.A0N(n658), .A1N(N3545), .B0(\out_b[5] ), .B1(N3503), 
     .Y(op2_5_1));
  NAND3X1 U1046_C2_2 (.A(sel_op2[2]), .B(sel_op2_1_1), .C(sel_op2[0]), .Y(N3545));
  INVX1 BL2_INV4 (.A(N3289_4), .Y(N3289_5));
  XNOR2X1 U1471_C1 (.A(N10544), .B(N5177), .Y(N4077));
  AOI22X1 U1351_C2_5 (.A0(N4077), .A1(N11339), .B0(add_434_carry_2_), 
     .B1(N10596), .Y(addr_xrom_a_1_1));
  AOI21X2 U1425_C2 (.A0(U1425_C2__n_5), .A1(U1425_C2__n_2), .B0(sel_addr0), 
     .Y(U783_C1__n_3));
  AOI22X1 U1360_C3_5 (.A0(U964_C3__n), .A1(N11339), .B0(out_pc_r_6_), 
     .B1(N10596), .Y(addr_xrom_a_6_1));
  OAI2BB1X1 U1333_C2_6 (.A0N(ld_apc), .A1N(a_plus_pc_7_), .B0(addr_xrom_a_7_1), 
     .Y(addr_xrom_a[7]));
  XOR2X1 U1694_C1 (.A(out_pc_r_7_), .B(N9541), .Y(N11863));
  AND2X1 U1685_C1 (.A(out_pc_r_11_), .B(U1685_C1__n), .Y(N6328));
  AOI22X1 U1333_C2_5 (.A0(U1771_C3__n_2), .A1(N11339), .B0(out_pc_r_7_), 
     .B1(N10596), .Y(addr_xrom_a_7_1));
  AOI2BB2X1 U1711_C3_6 (.A0N(n657), .A1N(N3545), .B0(\out_b[6] ), .B1(N3503), 
     .Y(op2_6_1));
  NAND2X1 U824_C2_3 (.A(N7487), .B(N11343), .Y(n688_1));
  OAI2BB1X1 U839_C1_3 (.A0N(U1068_C3__n_2), .A1N(N7482), .B0(\in_idat_r[7] ), 
     .Y(U839_C1__n_1));
  NAND2BX4 U1720_C1_6 (.AN(op2_2_2), .B(N7488), .Y(\op2[2] ));
  SDFFSRX1 latch_acc_reg_6_ (.CK(clk0_11), .D(N11431), .Q(\latch_acc[6] ), 
     .QN(n677), .RN(N12147_1), .SE(test_se_5), .SI(\latch_acc[5] ), .SN(VDD));
  BUFX3 BL1_ASSIGN_BUF16 (.A(out_idat_6_3), .Y(combus[6]));
  INVX1 U919_C1_2_MP_INV (.A(N10863), .Y(N10863_1));
  BUFX3 BL2_BUF137 (.A(sel_op1[2]), .Y(sel_op1_2_2));
  MXI2X1 U1281_C4_1 (.A(n649), .B(in_xrom_a_5_1), .S0(sel_page_addr), 
     .Y(\xrom[5] ));
  INVX1 U1771_C3_10_MP_INV_1 (.A(n632), .Y(n632_1));
  AOI22X1 U36_C4_5 (.A0(\in_idat_r[1] ), .A1(N4062_1), .B0(\out_dptr_r[1] ), 
     .B1(N4064), .Y(out_xdat_1_1));
  AOI22X1 U902_C4_13 (.A0(U1771_C3__n_1), .A1(N5196), .B0(N3927_2), 
     .B1(\out_sp_r[2] ), .Y(U902_C4__n_6));
  NAND2X1 U28_C4_4 (.A(\out_dptr_r[5] ), .B(N4064), .Y(N3146));
  XNOR2X1 U770_C1 (.A(\out_dptr_r[7] ), .B(out_acc_r[7]), .Y(N11556));
  INVX1 U1348_C2_6_MP_INV_1 (.A(N4061), .Y(N4061_1));
  XOR2X1 U1571_C1 (.A(\out_dptr_r[15] ), .B(N5181), .Y(N10595));
  INVX1 U847_C4_6_MP_INV (.A(addr2_r_0_), .Y(addr2_r_0_1));
  BUFX1 BW1_BUF954 (.A(combus[0]), .Y(combus_0_1));
  NAND3X1 U856_C2_6 (.A(U1013_C3__n_5), .B(U1010_C1__n), .C(N8163), .Y(N11073));
  AND2X1 U1069_C1 (.A(U1075_C1__n), .B(U1021_C1__n), .Y(N12295));
  BUFX16 BW1_BUF879 (.A(addr_a_5_1), .Y(addr_a[5]));
  AND2X2 U1008_C1 (.A(U865_C1__n), .B(U1008_C1__n), .Y(N10221));
  AOI22X4 U1771_C3_10 (.A0(n633_1), .A1(N12195_2), .B0(N1626_2), .B1(n632_1), 
     .Y(U1770_C2__n_1));
  OAI22X1 U709_C1_7 (.A0(n797), .A1(N7741), .B0(n820), .B1(N11443), 
     .Y(U895_C1__n_2));
  INVX1 U1456_C2_1_MP_INV (.A(N10997), .Y(N10997_1));
  NAND2X1 U709_C1_3 (.A(\latch_acc[6] ), .B(U737_C3__n_1), .Y(N5599));
  SDFFSRX1 latch_pc_reg_10_ (.CK(clk0_14), .D(N5883), .Q(n104), .QN(n801), 
     .RN(N12147), .SE(test_se_5), .SI(n80), .SN(VDD));
  NAND2BX1 U1760_C1_4 (.AN(N11163_1), .B(N7735), .Y(N11163_2));
  NAND2X1 U1763_C1_3 (.A(N10400_1), .B(N7734), .Y(N5009_1));
  BUFX8 BL3_S_BUF_22 (.A(N5140_1), .Y(N5140));
  SDFFSRX4 in_idat_r_reg_3_ (.CK(clk0_11), .D(N5890), .Q(\in_idat_r[3] ), 
     .QN(n639), .RN(N12147_1), .SE(test_se_2), .SI(\in_idat_r[2] ), .SN(VDD));
  NAND4X2 U902_C4_17 (.A(U903_C3__n_1), .B(U902_C4__n_8), .C(U902_C4__n_6), 
     .D(U902_C4__n_5), .Y(U902_C4__n_2));
  NOR2X1 U950_C4_6 (.A(N10832_2), .B(addr2_r_4_1), .Y(N6996));
  NAND4X1 U1527_C3_16 (.A(in_pc_3_1), .B(N8480_1), .C(N11391), .D(N11181), 
     .Y(\in_pc[3] ));
  AOI22X1 U1519_C2_8 (.A0(\in_xrom_r[1] ), .A1(N9874_1), .B0(\rel_addr_a[9] ), 
     .B1(N9867_1), .Y(in_pc_9_2));
  AOI22X1 U1268_C2_6 (.A0(N9891), .A1(N11469_1), .B0(\rel_addr_a[0] ), 
     .B1(N9867_1), .Y(N8475_1));
  INVX1 U247_C5_6_MP_INV (.A(N6345_2), .Y(N6345));
  MXI2X1 U1309_C4_1 (.A(n650), .B(in_xrom_a_1_1), .S0(ld_operand2), .Y(N10993));
  NAND2BX1 U1124_C1 (.AN(N12295), .B(N6612), .Y(N10412));
  SDFFSRX4 code_reg_6_ (.CK(clk0_14), .D(N11706), .Q(code[6]), .QN(n542), 
     .RN(N12147), .SE(test_se), .SI(code[5]), .SN(VDD));
  NOR2X1 U1536_C1_12 (.A(sel_in_cy_bit[1]), .B(sel_in_cy_bit[0]), .Y(N11774_2));
  AND2X1 U1645_C1 (.A(sel_xaddr_high), .B(\out_dptr_r[11] ), .Y(xaddr_high[3]));
  MXI2X1 U1291_C4_1 (.A(n648), .B(in_xrom_a_6_1), .S0(sel_page_addr), 
     .Y(\xrom[6] ));
  MXI2X1 U1303_C4_1 (.A(n633), .B(in_xrom_a_7_1), .S0(ld_operand2), .Y(N11929));
  NOR3X1 U1774_C2_3 (.A(sel_addr1_2_1), .B(sel_addr1[0]), .C(sel_addr1[1]), 
     .Y(N12195_21));
  SDFFSRX2 in_idat_r_reg_2_ (.CK(clk0_11), .D(N5882), .Q(\in_idat_r[2] ), 
     .QN(n637), .RN(N12147_1), .SE(test_se_2), .SI(\in_idat_r[1] ), .SN(VDD));
  OAI21X4 U1708_C1_4 (.A0(bit_addr_1), .A1(N3937_4), .B0(out_idat_1_1), 
     .Y(combus[1]));
  AOI22X1 U711_C3_7 (.A0(\in_idat_r[4] ), .A1(U947_C2__n_2), .B0(out_acc_r[4]), 
     .B1(U947_C2__n_5), .Y(op1_4_2));
  AOI2BB1X1 U1179_C2_2 (.A0N(n656), .A1N(N11917), .B0(U1179_C2__n), .Y(N8169));
  NAND2BX1 U1166_C4_6 (.AN(acc_chd_0_2), .B(N6618_1), .Y(acc_chd_0_3));
  AOI22X1 U1392_C2_2 (.A0(in_idat_a[7]), .A1(N11037_1), .B0(\in_idat_r[7] ), 
     .B1(N10457_3), .Y(N9192));
  INVX1 U814_C2_2_MP_INV_1 (.A(U947_C2__n_1), .Y(U947_C2__n_5));
  NAND3X1 U1725_C3_9 (.A(op1_7_2), .B(op1_7_1), .C(N11039), .Y(\op1[7] ));
  NOR2X1 U826_C3_9_C2_4 (.A(op2_5_4), .B(N9895), .Y(op2_5_2));
  INVX1 U1109_C2_2_MP_INV (.A(sel_op1[1]), .Y(sel_op1_1_1));
  NOR2X1 U1505_C2_4 (.A(N9204), .B(N11469), .Y(N1707_1));
  SDFFX1 int_vec3_reg_0_ (.CK(clk0_14), .D(\int_vec2[0] ), .Q(\int_vec3[0] ), 
     .QN(n672), .SE(test_se_5), .SI(\int_vec2[2] ));
  OAI21X2 U1780_C2_2 (.A0(N5641), .A1(N5611), .B0(N8500), .Y(N12054));
  AOI222X1 U1348_C2_6 (.A0(N4061_1), .A1(N11339), .B0(N327), .B1(N10596), 
     .C0(ld_apc), .C1(N10054), .Y(addr_xrom_a_0_2));
  AOI222X1 U1658_C5_6 (.A0(N9394), .A1(N11705), .B0(inc_pc2), .B1(N314), 
     .C0(out_pc_r_5_), .C1(N9736), .Y(N9388_2));
  XNOR2X1 U810_C1 (.A(out_pc_r_8_), .B(add_465_carry_8_), .Y(N5170));
  AND2X1 U1693_C1 (.A(out_pc_r_7_), .B(N9541), .Y(U1691_C1__n));
  XNOR2X1 U808_C1 (.A(out_pc_r_14_), .B(U1665_C1__n), .Y(N11964));
  INVX1 U558_C5_6_MP_INV (.A(N11339), .Y(N11339_1));
  NOR2X4 U1771_C3_12 (.A(N1559), .B(N4900), .Y(U1770_C2__n_3));
  AOI222X1 U818_C1_2 (.A0(U948_C1__n_1), .A1(N7486), .B0(\in_idat_r[4] ), 
     .B1(N7484), .C0(\out_sfr_a[4] ), .C1(N10877), .Y(N10312_1));
  INVX1 U1071_C1_3_MP_INV (.A(U1068_C3__n), .Y(U1068_C3__n_4));
  INVX1 U1707_C2_5_MP_INV (.A(N10171), .Y(N10171_1));
  AOI22X1 U1389_C2_2 (.A0(in_idat_a[4]), .A1(N11037_1), .B0(\in_idat_r[4] ), 
     .B1(N10457_3), .Y(N9208));
  SDFFSRX1 latch_pc_reg_2_ (.CK(clk0_11), .D(N11110), .Q(n68), .QN(n809), 
     .RN(N12147), .SE(test_se_5), .SI(n66), .SN(VDD));
  OAI221X4 U26_C4_6 (.A0(n640), .A1(N4062), .B0(sel_xad), .B1(out_acc_r_6_1), 
     .C0(N11107), .Y(out_xdat[6]));
  NAND2X1 U1168_C1 (.A(\out_sfr_a[6] ), .B(N10221), .Y(N11501));
  NAND3X4 U1728_C3_9 (.A(op1_6_2), .B(op1_6_1), .C(N3520), .Y(\op1[6] ));
  u_datapath_MUX_OP_8_3_2 C1170 (.D0_1(in_idat_a[0]), .D0_0(\out_sfr_a[0] ), 
     .D1_1(in_idat_a[1]), .D1_0(\out_sfr_a[1] ), .D2_1(in_idat_a[2]), 
     .D2_0(\out_sfr_a[2] ), .D3_1(in_idat_a[3]), .D3_0(\out_sfr_a[3] ), 
     .D4_1(in_idat_a[4]), .D4_0(\out_sfr_a[4] ), .D5_1(in_idat_a[5]), 
     .D5_0(\out_sfr_a[5] ), .D6_1(in_idat_a[6]), .D6_0(\out_sfr_a[6] ), 
     .D7_1(in_idat_a[7]), .D7_0(\out_sfr_a[7] ), .S0(addr2_a_0_), 
     .S1(addr2_a_1_), .S2(addr2_a_2_), .Z_1(N110), .Z_0(N109));
  NAND2X1 U1755_C2_2 (.A(N6611), .B(N6599), .Y(N3082_1));
  AOI22X1 U1419_C4_13 (.A0(U1771_C3__n_1), .A1(N5169), .B0(N3927_2), 
     .B1(\out_sp_r[3] ), .Y(U1419_C4__n_6));
  NOR4X1 U964_C3_14 (.A(U964_C3__n_2), .B(N10024), .C(N4638), .D(U964_C3__n_1), 
     .Y(U1425_C2__n_5));
  ADDFX1 U1564 (.A(out_acc_r_2_2), .B(out_pc_r_2_), .CI(add_465_carry_2_), 
     .CO(add_465_carry_3_), .S(a_plus_pc_2_));
  INVX1 U1480_C1 (.A(\out_sp_r[6] ), .Y(N5119));
  XOR2X1 U1461_C1 (.A(\out_dptr_r[2] ), .B(out_acc_r_2_2), .Y(N2333));
  AND2X1 U1674_C1 (.A(\out_dptr_r[13] ), .B(U1674_C1__n), .Y(U1572_C1__n));
  MX2X4 U787_C2_1 (.A(N110), .B(N109), .S0(addr_a[7]), .Y(N11209));
  NAND2X1 U1298_C3_2 (.A(ld_idat), .B(in_idat_a[4]), .Y(N7961));
  AND2X1 U1136_C1 (.A(U1141_C1__n), .B(U1061_C1__n), .Y(U1013_C3__n_2));
  AND2X1 U1021_C1 (.A(U1067_C1__n), .B(U1021_C1__n), .Y(U1020_C1__n));
  NOR2X1 U1079_C1 (.A(U783_C1__n_2), .B(N3924), .Y(U1067_C1__n));
  INVX1 U1776_C1_2_MP_INV (.A(N1626_2), .Y(N1626));
  MXI2X1 U1311_C4_1 (.A(n648), .B(in_xrom_a_6_1), .S0(ld_xrom), .Y(N11593));
  SDFFSX1 alu_r_reg_2_ (.CK(clk0_14), .D(\alu_a[2] ), .Q(n56), .QN(n816), 
     .SE(test_se_3), .SI(n51), .SN(VDD));
  AOI21X1 U1192_C1_1 (.A0(in_xrom_a[1]), .A1(U852_C2__n_1), .B0(U1192_C1__n), 
     .Y(N6593));
  NOR2X1 U791_C1 (.A(sel_combus[3]), .B(sel_combus[2]), .Y(U865_C1__n));
  SDFFSRX1 latch_pc_reg_9_ (.CK(clk0_11), .D(N10922), .Q(n80), .QN(n802), 
     .RN(N12147), .SE(test_se_5), .SI(n97), .SN(VDD));
  NAND2X1 U719_C1 (.A(\out_sfr_a[3] ), .B(N10221), .Y(N12130));
  INVX2 U1307_C4_1_MP_INV (.A(in_xrom_a[3]), .Y(in_xrom_a_3_1));
  SDFFSRX1 addr2_r_reg_7_ (.CK(clk0_11), .D(addr_a[7]), .Q(msb_r), .QN(n811), 
     .RN(N12147_1), .SE(test_se_3), .SI(n146), .SN(VDD));
  OAI2BB1X1 U839_C1_1 (.A0N(U1013_C3__n_3), .A1N(N8163), .B0(\out_sfr_a[7] ), 
     .Y(U839_C1__n));
  SDFFRHQX1 in_idat1_r_reg_3_ (.CK(clk0_11), .D(\in_idat_r[3] ), .Q(n792), 
     .RN(N12147_1), .SE(test_se_3), .SI(n793));
  SDFFRHQX2 in_idat1_r_reg_7_ (.CK(clk0_11), .D(\in_idat_r[7] ), .Q(test_so14), 
     .RN(N12147_1), .SE(test_se_2), .SI(n789));
  INVX1 U1523_C2_9_MP_INV (.A(N12228), .Y(N12228_2));
  AOI21X1 U896_C1_1 (.A0(in_xrom_a[5]), .A1(U852_C2__n_1), .B0(U896_C1__n), 
     .Y(N11435));
  OR3X1 U1096_C2_3 (.A(sel_pc[2]), .B(sel_pc[1]), .C(sel_pc_0_1), .Y(N9874));
  INVX1 U829_C5_6_MP_INV (.A(N5883_2), .Y(N5883));
  XOR2X1 U1682_C1 (.A(out_pc_r_13_), .B(N6331), .Y(N6327));
  OAI2BB1X1 U794_C1_3 (.A0N(U1068_C3__n), .A1N(U1013_C3__n_5), .B0(U948_C1__n_1), 
     .Y(N2040));
  NAND3X1 U1089_C2_2 (.A(sel_pc[2]), .B(sel_pc_1_1), .C(sel_pc[0]), .Y(N9881));
  OAI211X1 U887_C1_10 (.A0(n809), .A1(U738_C2__n), .B0(U1766_C1__n_4), 
     .C0(N3123), .Y(U1766_C1__n));
  INVX1 U894_C2_6_MP_INV (.A(N2970_4), .Y(N2970));
  NAND2X1 U966_C2_10 (.A(in_pc_2_3), .B(in_pc_2_2), .Y(\in_pc[2] ));
  MXI2X1 U1304_C4_1 (.A(n622), .B(in_xrom_a_6_1), .S0(ld_operand2), .Y(N5899));
  INVX1 U1419_C4_12_MP_INV (.A(n619), .Y(n619_1));
  NAND2X1 U1396_C1 (.A(\in_idat_r[3] ), .B(U1396_C1__n), .Y(N10172));
  OAI21X1 U1297_C3_1 (.A0(n641), .A1(ld_idat), .B0(N3021), .Y(N10991));
  AOI21X2 U812_C2_6 (.A0(\out_sfr_a[0] ), .A1(N9993_2), .B0(n763_2), .Y(n763_3));
  NAND2BX1 U1760_C1_5 (.AN(N11163_2), .B(N8172), .Y(N11163_3));
  BUFX16 BL3_S_BUF_7 (.A(op1_1_3), .Y(\op1[1] ));
  INVX1 U1708_C1_3_MP_INV_1 (.A(N10022), .Y(N10022_1));
  NAND2BX4 U1731_C3_9_C2_6 (.AN(op1_2_3), .B(N10227), .Y(\op1[2] ));
  AOI22X1 U1728_C3_6 (.A0(in_xrom_a[6]), .A1(N9992_1), .B0(\out_sfr_a[6] ), 
     .B1(N9993_2), .Y(op1_6_1));
  MXI2X1 U1265_C4_1 (.A(n647), .B(in_xrom_a_4_1), .S0(sel_page_addr), 
     .Y(\xrom[4] ));
  INVX1 U698_C2_2_MP_INV (.A(sel_op1[0]), .Y(sel_op1_0_1));
  NOR3X1 U867_C2_2 (.A(sel_op1_2_2), .B(sel_op1_1_1), .C(sel_op1[0]), 
     .Y(U947_C2__n));
  INVX1 U251_C5_6_MP_INV (.A(N10436_2), .Y(N10436));
  SDFFSRX1 latch_acc_reg_1_ (.CK(clk0_11), .D(N11486), .Q(\latch_acc[1] ), 
     .QN(n682), .RN(N12147_1), .SE(test_se_5), .SI(\latch_acc[0] ), .SN(VDD));
  AOI222X1 U239_C5_6 (.A0(N11705), .A1(N11111), .B0(inc_pc2), .B1(N311), 
     .C0(out_pc_r_2_), .C1(N9736), .Y(N11110_2));
  NAND2X1 U948_C1 (.A(U948_C1__n_1), .B(U948_C1__n), .Y(N12098));
  ADDFX1 U1566 (.A(out_acc_r[4]), .B(out_pc_r_4_), .CI(add_465_carry_4_), 
     .CO(add_465_carry_5_), .S(a_plus_pc_4_));
  NOR2BX1 U1669_C1 (.AN(U1669_C1__n), .B(out_pc_r_10_1), .Y(U1668_C1__n));
  XNOR2X1 U806_C1 (.A(out_pc_r_12_), .B(U1667_C1__n), .Y(N11223));
  INVX1 U595_C5_6_MP_INV (.A(out_pc_r_12_), .Y(out_pc_r_12_1));
  OAI2BB1X1 U1360_C3_6 (.A0N(ld_apc), .A1N(a_plus_pc_6_), .B0(addr_xrom_a_6_1), 
     .Y(addr_xrom_a[6]));
  AOI22X1 U1730_C3_7 (.A0(\in_idat_r[3] ), .A1(U947_C2__n_2), .B0(out_acc_r[3]), 
     .B1(U947_C2__n_5), .Y(op1_3_2));
  NAND2X1 U818_C1 (.A(U1068_C3__n_1), .B(U1013_C3__n_4), .Y(N7486));
  INVX1 U1172_C3_7_MP_INV_1 (.A(U948_C1__n_1), .Y(U948_C1__n_2));
  OAI21X2 U1707_C2_6 (.A0(N5009_4), .A1(bit_addr_1), .B0(out_idat_2_3), 
     .Y(combus_2_2));
  OAI221X4 U30_C4_6 (.A0(n642), .A1(N4062), .B0(sel_xad), .B1(out_acc_r_4_1), 
     .C0(N9240), .Y(out_xdat[4]));
  SDFFSRX1 in_idat1_r_reg_0_ (.CK(clk0_14), .D(\in_idat_r[0] ), .Q(n36), 
     .QN(n544), .RN(N12147_1), .SE(test_se_3), .SI(code_7_1), .SN(VDD));
  OAI21X2 U1707_C2_7 (.A0(N5009_4), .A1(bit_addr_1), .B0(out_idat_2_3), 
     .Y(combus[2]));
  SDFFSRX2 in_xrom1_r_reg_5_ (.CK(clk0_14), .D(N5889), .Q(in_xrom1_r[5]), 
     .QN(n620), .RN(N12147), .SE(test_se_3), .SI(in_xrom1_r[4]), .SN(VDD));
  INVX1 U239_C5_6_MP_INV (.A(N11110_2), .Y(N11110));
  AOI222X1 U966_C2_9 (.A0(N5009), .A1(N12228_2), .B0(\page_addr_a[2] ), 
     .B1(N8342_1), .C0(\rel_addr_a[2] ), .C1(N9867_1), .Y(in_pc_2_3));
  NAND4X4 U1771_C3_14 (.A(U1771_C3__n_3), .B(U1770_C2__n_3), .C(U1770_C2__n_1), 
     .D(N4941), .Y(U1770_C2__n_5));
  INVX1 U840_C2_2_MP_INV (.A(N3927_2), .Y(N3927));
  AOI22X1 U847_C4_13 (.A0(U1771_C3__n_1), .A1(N4061_1), .B0(N3927_2), 
     .B1(\out_sp_r[0] ), .Y(U847_C4__n_6));
  INVX1 U1777_C2_1_MP_INV (.A(N11689), .Y(N11689_1));
  AOI22X1 U1551_C2_2 (.A0(out_acc_r[7]), .A1(N11791), .B0(\out_dptr_r[7] ), 
     .B1(n1383_1), .Y(U1554_C1__n_1));
  NOR2BX1 U1560_C1 (.AN(\out_dptr_r[9] ), .B(U1560_C1__n), .Y(U1677_C1__n));
  NOR2X1 U847_C4_6 (.A(N10832_2), .B(addr2_r_0_1), .Y(N4979));
  AND2X1 U1259_C1 (.A(N3925), .B(N3917), .Y(U1141_C1__n));
  NAND3X1 U1013_C3_3 (.A(U1171_C1__n_2), .B(U1013_C3__n_3), .C(U1013_C3__n_4), 
     .Y(U1171_C1__n));
  NOR3X1 U938_C1_2 (.A(n783_1), .B(n1074_1), .C(U833_C1__n), .Y(U1139_C1__n));
  INVX1 U847_C4_12_MP_INV (.A(n625), .Y(n625_1));
  SDFFSX1 alu_r_reg_5_ (.CK(clk0_14), .D(\alu_a[5] ), .Q(n60), .QN(n819), 
     .SE(test_se_3), .SI(n58), .SN(VDD));
  SDFFSRX1 latch_pc_reg_11_ (.CK(clk0_14), .D(N10436), .Q(n106), .QN(n800), 
     .RN(N12147), .SE(test_se_5), .SI(n104), .SN(VDD));
  NAND2X1 U1003_C1 (.A(U865_C1__n_1), .B(U864_C1__n), .Y(N11443));
  AOI22X1 U1502_C2_8 (.A0(in_xrom_a[6]), .A1(N9874_1), .B0(U964_C3__n), 
     .B1(N9881_1), .Y(in_pc_6_2));
  AOI21X1 U900_C1_9 (.A0(in_xdat_a[3]), .A1(U737_C3__n), .B0(U1762_C1__n_2), 
     .Y(U1762_C1__n_4));
  AOI21X1 U891_C1_9 (.A0(in_xdat_a[4]), .A1(U737_C3__n), .B0(U1759_C1__n_2), 
     .Y(U1759_C1__n_4));
  AND2X2 U1050_C1 (.A(U721_C1__n), .B(U1008_C1__n), .Y(U737_C3__n_1));
  NAND2X1 U1415_C1 (.A(\out_dptr_r[4] ), .B(out_acc_r[4]), .Y(N11324));
  SDFFSRX1 addr2_r_reg_5_ (.CK(clk0_11), .D(N12261), .Q(n144), .QN(n813), 
     .RN(N12147_1), .SE(test_se_3), .SI(addr2_r_4_), .SN(VDD));
  MXI2X4 U902_C4_4 (.A(U902_C4__n_2), .B(addr_bank_a[2]), .S0(sel_addr0), 
     .Y(N3924));
  NOR2X2 U782_C1 (.A(U783_C1__n), .B(U782_C1__n), .Y(addr_a_4_1));
  AOI222X1 U1523_C2_9 (.A0(N3407_5), .A1(N12228_2), .B0(\page_addr_a[7] ), 
     .B1(N8342_1), .C0(\rel_addr_a[7] ), .C1(N9867_1), .Y(in_pc_7_3));
  OAI211X1 U1517_C3_10 (.A0(N9881), .A1(N6248), .B0(in_pc_10_2), .C0(in_pc_10_1), 
     .Y(\in_pc[10] ));
  AOI2BB2X1 U1285_C1_5 (.A0N(N9891_1), .A1N(N11469), .B0(\page_addr_a[1] ), 
     .B1(N8342_1), .Y(N11600_1));
  SDFFSX1 int_vec3_reg_2_ (.CK(clk0_11), .D(\int_vec2[2] ), .Q(n47), .QN(n673), 
     .SE(test_se_5), .SI(\int_vec3[1] ), .SN(VDD));
  NOR3X4 U1040_C2_2 (.A(sel_addr1_1_1), .B(sel_addr1_2_1), .C(sel_addr1[0]), 
     .Y(U1771_C3__n_1));
  NOR2X1 U847_C4_15 (.A(N4977), .B(N4979), .Y(U847_C4__n_8));
  SDFFSRX1 in_idat_r_reg_7_ (.CK(clk0_11), .D(N11930), .Q(\in_idat_r[7] ), 
     .QN(n634), .RN(N12147_1), .SE(test_se_2), .SI(\in_idat_r[6] ), .SN(VDD));
  OR3X1 U1095_C2_3 (.A(sel_pc[2]), .B(sel_pc[1]), .C(sel_pc[0]), .Y(N8342));
  AND2X1 U1643_C1 (.A(sel_xaddr_high), .B(\out_dptr_r[13] ), .Y(xaddr_high[5]));
  MXI2X1 U1266_C4_1 (.A(n643), .B(in_xrom_a_0_1), .S0(sel_page_addr), 
     .Y(\xrom[0] ));
  AND2X1 U800_C1 (.A(sel_combus[1]), .B(sel_combus[0]), .Y(U1008_C1__n));
  INVX1 U950_C4_12_MP_INV (.A(n621), .Y(n621_1));
  INVX1 U1501_C1 (.A(in_idat_a[0]), .Y(N4849));
  MX2X1 U1300_C3_1 (.A(\in_idat_r[2] ), .B(in_idat_a[2]), .S0(ld_idat), 
     .Y(N5882));
  AOI2BB2X1 U916_C1_2 (.A0N(n659), .A1N(N10863), .B0(in_idat_a[4]), 
     .B1(N10864_1), .Y(N11158));
  OAI2BB2X1 U1169_C2_3 (.A0N(in_idat_a[6]), .A1N(N7736_1), .B0(n640), 
     .B1(N11918), .Y(U1169_C2__n));
  AOI22X1 U947_C2_2 (.A0(\in_idat_r[1] ), .A1(U947_C2__n_2), .B0(out_acc_r_1_2), 
     .B1(U947_C2__n_5), .Y(N3521));
  AOI21X4 U1166_C4_7 (.A0(\out_sfr_a[0] ), .A1(N3549_1), .B0(acc_chd_0_3), 
     .Y(acc_chd_0_4));
  INVX1 U934_C1_2_MP_INV (.A(N11037), .Y(N11037_1));
  NOR2X1 U1714_C3_9_C2_3 (.A(N3616), .B(in_xrom_a_4_1), .Y(N10747));
  BUFX12 BW1_BUF1164 (.A(\op1[7] ), .Y(op1_7_3));
  OAI21X1 U826_C3_9_C2_5 (.A0(out_sfr_a_5_1), .A1(N3549), .B0(op2_5_2), 
     .Y(op2_5_3));
  AND2X2 U865_C1 (.A(U865_C1__n_1), .B(U865_C1__n), .Y(N10997));
  OAI2BB1X1 U1654_C5_6 (.A0N(inc_pc2), .A1N(N310), .B0(N9744_1), .Y(N9744));
  INVX1 U1464_C1_MP_INV_1 (.A(N6054), .Y(N6054_1));
  INVX1 U231_C5_6_MP_INV (.A(N11032_2), .Y(N11032));
  AND2X1 U1701_C1 (.A(out_pc_r_3_), .B(U1701_C1__n), .Y(N12032));
  SDFFX1 int_vec1_reg_1_ (.CK(clk0_11), .D(\int_vec[1] ), .Q(\int_vec1[1] ), 
     .QN(), .SE(test_se_5), .SI(\int_vec1[0] ));
  NAND2X1 U583_C5_2 (.A(out_pc_r_15_), .B(N10596), .Y(N7556));
  INVX1 U603_C5_6_MP_INV (.A(out_pc_r_10_), .Y(out_pc_r_10_1));
  XNOR2X1 U803_C1 (.A(out_pc_r_15_), .B(N11792), .Y(N5182));
  SDFFSRX1 latch_pc_reg_6_ (.CK(clk0_11), .D(N11032), .Q(n75), .QN(n805), 
     .RN(N12147), .SE(test_se_5), .SI(n73), .SN(VDD));
  NOR2X1 U855_C1_3 (.A(N7480_1), .B(N11342), .Y(n761_1));
  NAND2X1 U1172_C3_5 (.A(\in_idat_r[0] ), .B(N12295), .Y(N2304));
  INVX1 U1707_C2_3_MP_INV (.A(N6614), .Y(N6614_1));
  AOI21X2 U1722_C1_7 (.A0(\out_sfr_a[1] ), .A1(N3549_1), .B0(op2_1_2), 
     .Y(op2_1_3));
  AND2X2 U1007_C1 (.A(U865_C1__n), .B(U1007_C1__n), .Y(N10996));
  NAND2X1 U891_C1_3 (.A(\latch_acc[4] ), .B(U737_C3__n_1), .Y(N4148));
  BUFX2 BL1_ASSIGN_BUF14 (.A(out_idat[4]), .Y(combus[4]));
  AOI22X1 U1710_C3_7 (.A0(in_xrom_a[7]), .A1(N10450), .B0(\out_sfr_a[7] ), 
     .B1(N3549_1), .Y(op2_7_2));
  pc_test_1 U0_pc (.clk(), .rst_p(rst_p), .ld_pc(ld_pc), .ld_pcl(ld_pcl), 
     .ld_pch(ld_pch), .inc_pc(inc_pc), .in_pc({\in_pc[15] , \in_pc[14] , 
     \in_pc[13] , \in_pc[12] , \in_pc[11] , \in_pc[10] , \in_pc[9] , \in_pc[8] , 
     \in_pc[7] , \in_pc[6] , \in_pc[5] , \in_pc[4] , \in_pc[3] , \in_pc[2] , 
     \in_pc[1] , \in_pc[0] }), .out_pc_r({out_pc_r_15_, out_pc_r_14_, 
     out_pc_r_13_, out_pc_r_12_, out_pc_r_11_, out_pc_r_10_, out_pc_r_9_, 
     out_pc_r_8_, out_pc_r_7_, out_pc_r_6_, out_pc_r_5_, out_pc_r_4_, 
     out_pc_r_3_, out_pc_r_2_, add_434_carry_2_, N327}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si(test_si3), .test_so(n29), .test_se(test_se), .clk0_14(clk0_14));
  MXI2X1 U1544_C4_1 (.A(n538), .B(in_xrom_a_2_1), .S0(ld_instr), .Y(N11690));
  INVX1 U1468_C1_MP_INV_1 (.A(N6040), .Y(N6040_1));
  NAND2BX4 U1771_C3 (.AN(U1771_C3__n_8), .B(test_so14), .Y(U1771_C3__n_3));
  AOI22X1 U1354_C3_5 (.A0(N5196), .A1(N11339), .B0(out_pc_r_2_), .B1(N10596), 
     .Y(addr_xrom_a_2_1));
  INVX1 U1483_C1 (.A(\out_sp_r[5] ), .Y(N11007));
  NAND2X1 U1781_C1 (.A(\out_dptr_r[0] ), .B(out_acc_r[0]), .Y(N10544));
  XNOR2X1 U1573_C1 (.A(\out_dptr_r[10] ), .B(U1677_C1__n), .Y(N6248));
  OAI21X1 U1299_C3_1 (.A0(n639), .A1(ld_idat), .B0(N1875), .Y(N5890));
  NAND2X1 U1299_C3_2 (.A(ld_idat), .B(in_idat_a[3]), .Y(N1875));
  INVX1 U854_C1_1_MP_INV (.A(U1010_C1__n_1), .Y(U1010_C1__n_3));
  AND2X1 U1061_C1 (.A(U1075_C1__n_1), .B(U1061_C1__n), .Y(U1013_C3__n_1));
  NAND2X1 U1225_C1 (.A(U783_C1__n_2), .B(U1225_C1__n), .Y(addr_a_5_1));
  INVX1 U1771_C3_10_MP_INV (.A(n633), .Y(n633_1));
  NAND2BX1 U1758_C1_4 (.AN(N3289_1), .B(N11078), .Y(N3289_2));
  INVX1 BL2_INV2 (.A(N3407_4), .Y(N3407_5));
  OAI2BB2X1 U1456_C2_1 (.A0N(\in_xrom_r[0] ), .A1N(N10996), .B0(N4847), 
     .B1(N10997_1), .Y(N7740));
  AOI21X1 U1762_C1_1 (.A0(in_xrom_a[3]), .A1(U852_C2__n_1), .B0(U1762_C1__n), 
     .Y(N7735));
  OAI211X1 U888_C1_10 (.A0(n810), .A1(U738_C2__n), .B0(U1192_C1__n_4), 
     .C0(N11550), .Y(U1192_C1__n));
  OAI211X1 U897_C1_10 (.A0(n806), .A1(U738_C2__n), .B0(U896_C1__n_4), .C0(N4856), 
     .Y(U896_C1__n));
  NAND2BX1 U1754_C1_4 (.AN(N3937_1), .B(N6593), .Y(N3937_2));
  NAND4X1 U953_C3_12 (.A(U953_C3__n_2), .B(N4635), .C(N2523), .D(N3848), 
     .Y(U1423_C2__n_3));
  SDFFRHQX1 addr2_r_reg_3_ (.CK(clk0_11), .D(N12259), .Q(addr2_r_3_), 
     .RN(N12147_1), .SE(test_se_2), .SI(addr2_r_2_));
  MXI2X2 U950_C4_4 (.A(U950_C4__n_2), .B(out_psw_4_), .S0(sel_addr0), 
     .Y(U782_C1__n));
  INVX1 U1375_C1 (.A(U782_C1__n), .Y(N5879));
  OAI211X1 U1521_C2_10 (.A0(N9881), .A1(N5171), .B0(in_pc_8_2), .C0(in_pc_8_1), 
     .Y(\in_pc[8] ));
  AND2X1 U1681_C1 (.A(out_pc_r_13_), .B(N6331), .Y(N6336));
  NAND3X1 U1088_C2_2 (.A(sel_pc[2]), .B(sel_pc[1]), .C(sel_pc_0_1), .Y(N11469));
  AOI22X1 U1512_C2_8 (.A0(\in_xrom_r[4] ), .A1(N9874_1), .B0(\rel_addr_a[12] ), 
     .B1(N9867_1), .Y(in_pc_12_2));
  AOI22X1 U737_C3_2 (.A0(in_xdat_a[0]), .A1(U737_C3__n), .B0(\latch_acc[0] ), 
     .B1(U737_C3__n_1), .Y(N11444));
  NAND2X1 U1067_C1 (.A(U1075_C1__n_1), .B(U1067_C1__n), .Y(U1068_C3__n));
  AOI2BB2X1 U982_C1_7 (.A0N(N4849), .A1N(N7736), .B0(\out_sfr_a[0] ), 
     .B1(N10221), .Y(U982_C1__n_1));
  MXI2X1 U1305_C4_1 (.A(n620), .B(in_xrom_a_5_1), .S0(ld_operand2), .Y(N5889));
  SDFFSRX1 latch_acc_reg_5_ (.CK(clk0_11), .D(N11432), .Q(\latch_acc[5] ), 
     .QN(n678), .RN(N12147_1), .SE(test_se_5), .SI(\latch_acc[4] ), .SN(VDD));
  NAND2BX1 U1536_C1_6 (.AN(N11775), .B(N11774), .Y(in_cy_bit));
  BUFX8 BW2_BUF724 (.A(test_se_1), .Y(test_se_5));
  NOR3X2 U1776_C1_3 (.A(sel_addr1[0]), .B(sel_addr1[1]), .C(sel_addr1[2]), 
     .Y(N1626_21));
  AOI22X1 U934_C1_2 (.A0(in_idat_a[2]), .A1(N11037_1), .B0(\in_idat_r[2] ), 
     .B1(N10457_3), .Y(N7488));
  SDFFSRX1 in_idat_r_reg_5_ (.CK(clk0_11), .D(N10991), .Q(\in_idat_r[5] ), 
     .QN(n641), .RN(N12147_1), .SE(test_se_2), .SI(\in_idat_r[4] ), .SN(VDD));
  NAND2BX1 U1729_C3_9_C3_6 (.AN(N10605), .B(op1_5_1), .Y(op1_5_2));
  AOI21X1 U1185_C2_2 (.A0(in_idat_a[4]), .A1(N7736_1), .B0(U1185_C2__n), 
     .Y(N10343));
  INVX1 U784_C2_1_MP_INV_1 (.A(N3545), .Y(N3545_1));
  AOI2BB1X1 U1169_C2_2 (.A0N(n657), .A1N(N11917), .B0(U1169_C2__n), .Y(N10909));
  NAND2BX4 U1714_C3_9_C2_6 (.AN(op2_4_3), .B(N9208), .Y(\op2[4] ));
  NOR2BX1 U1730_C3_9_C2_4 (.AN(op1_3_2), .B(N3326), .Y(op1_3_1));
  AOI2BB2X1 U1268_C2_7 (.A0N(N9881), .A1N(N4061), .B0(in_xrom_a[0]), 
     .B1(N9874_1), .Y(N8475_2));
  INVX1 U1321_C4_1_MP_INV (.A(\out_sfr_a[5] ), .Y(out_sfr_a_5_1));
  NOR3X1 U702_C2_2 (.A(sel_op2[2]), .B(sel_op2[1]), .C(sel_op2_0_1), .Y(N10457));
  NOR2X4 U831_C1 (.A(inc_pc3), .B(inc_pc2), .Y(N9736));
  SDFFSRX1 latch_pc_reg_3_ (.CK(clk0_11), .D(N6340), .Q(n102), .QN(n808), 
     .RN(N12147), .SE(test_se_5), .SI(n68), .SN(VDD));
  OAI2BB1X1 U1345_C2_6 (.A0N(ld_apc), .A1N(a_plus_pc_5_), .B0(addr_xrom_a_5_1), 
     .Y(addr_xrom_a[5]));
  NAND4X2 U842_C4_17 (.A(U841_C3__n_1), .B(U842_C4__n_8), .C(U842_C4__n_5), 
     .D(U842_C4__n_6), .Y(U842_C4__n_2));
  AND2X1 U1697_C1 (.A(out_pc_r_5_), .B(N11983), .Y(N9389));
  NOR2BX1 U1671_C1 (.AN(add_465_carry_8_), .B(out_pc_r_8_1), .Y(U1670_C1__n));
  OAI221X1 U583_C5_6 (.A0(N11339_1), .A1(N10595), .B0(ld_apc_1), .B1(N5182), 
     .C0(N7556), .Y(addr_xrom_a[15]));
  INVX1 U591_C5_6_MP_INV (.A(out_pc_r_13_), .Y(out_pc_r_13_1));
  XNOR2X1 U805_C1 (.A(out_pc_r_11_), .B(U1668_C1__n), .Y(N12053));
  AOI22X1 U1732_C3_6 (.A0(in_xrom_a[1]), .A1(N9992_1), .B0(\out_sfr_a[1] ), 
     .B1(N9993_2), .Y(op1_1_1));
  OAI211X1 U1709_C2_4 (.A0(N1321), .A1(bit_addr_1), .B0(N10021_1), .C0(N6051), 
     .Y(out_idat_0_2));
  INVX1 U1325_C4_1_MP_INV (.A(\out_sfr_a[3] ), .Y(out_sfr_a_3_1));
  OAI21X2 U1706_C2_7 (.A0(N11163_4), .A1(bit_addr_1), .B0(out_idat_3_3), 
     .Y(combus[3]));
  MXI2X1 U1626_C3_1 (.A(n677), .B(out_acc_r_6_1), .S0(ld_latch_acc), .Y(N11431));
  BUFX3 BL1_ASSIGN_BUF15 (.A(out_idat[5]), .Y(combus[5]));
  AOI2BB2X1 U910_C1_2 (.A0N(n657), .A1N(N10863), .B0(in_idat_a[6]), 
     .B1(N10864_1), .Y(N3520));
  NAND2X1 U1527_C3_3 (.A(N9881_1), .B(N5169), .Y(N11181));
  MXI2X1 U1293_C4_1 (.A(n645), .B(in_xrom_a_2_1), .S0(sel_page_addr), 
     .Y(\xrom[2] ));
  SDFFSRX1 in_xrom_r_reg_4_ (.CK(clk0_14), .D(N11595), .Q(\in_xrom_r[4] ), 
     .QN(n647), .RN(N12147), .SE(test_se), .SI(\in_xrom_r[3] ), .SN(VDD));
  BUFX3 BW1_BUF959 (.A(out_xdat_3_2), .Y(out_xdat[3]));
  NAND2BX1 U953_C3_1 (.AN(U953_C3__n_3), .B(U1771_C3__n_1), .Y(U953_C3__n_2));
  XOR2X1 U1469_C1 (.A(\out_dptr_r[5] ), .B(out_acc_r_5_1), .Y(N6040));
  NOR2X1 U1406_C1 (.A(\out_dptr_r[6] ), .B(out_acc_r[6]), .Y(N11689));
  NAND2BX1 U1551_C2 (.AN(\out_dptr_r[7] ), .B(N10115), .Y(N11791));
  XNOR2X1 U1570_C1 (.A(\out_dptr_r[14] ), .B(U1572_C1__n), .Y(N11963));
  NOR2X2 U842_C4_15 (.A(N5006), .B(N5004), .Y(U842_C4__n_8));
  BUFX16 BW1_BUF883 (.A(addr_a_1_1), .Y(addr_a[1]));
  NAND3X1 U765_C2_6 (.A(U1013_C3__n_5), .B(U1010_C1__n_1), .C(N8163), .Y(N5990));
  NAND2X1 U1143_C1 (.A(U1139_C1__n), .B(U1075_C1__n_1), .Y(U1070_C1__n_1));
  BUFX4 BL1_ASSIGN_BUF11 (.A(combus_1_1), .Y(out_idat[1]));
  NAND2BX1 U953_C3_7 (.AN(n649), .B(N1626_2), .Y(N3848));
  INVX1 U1763_C1_6_MP_INV (.A(N5009_4), .Y(N5009));
  AOI21X1 U707_C1_9 (.A0(in_xdat_a[7]), .A1(U737_C3__n), .B0(U893_C1__n_2), 
     .Y(U893_C1__n_4));
  INVX1 U1754_C1_6_MP_INV (.A(N3937_4), .Y(N3937));
  AOI21X1 U887_C1_9 (.A0(in_xdat_a[2]), .A1(U737_C3__n), .B0(U1766_C1__n_2), 
     .Y(U1766_C1__n_4));
  NAND2X1 U897_C1_3 (.A(\latch_acc[5] ), .B(U737_C3__n_1), .Y(N4856));
  OAI211X1 U891_C1_10 (.A0(n807), .A1(U738_C2__n), .B0(U1759_C1__n_4), 
     .C0(N4148), .Y(U1759_C1__n));
  NAND2X1 U1178_C1 (.A(\out_sfr_a[7] ), .B(N10221), .Y(N10578));
  AOI21X2 U723_C2_1 (.A0(N10187), .A1(N6226), .B0(N11324_1), .Y(N8905));
  SDFFRHQX1 in_idat1_r_reg_5_ (.CK(clk0_11), .D(\in_idat_r[5] ), .Q(n790), 
     .RN(N12147_1), .SE(test_se_2), .SI(n791));
  OAI222X1 U953_C3_14 (.A0(n790_1), .A1(U1771_C3__n_8), .B0(N9107), .B1(n641), 
     .C0(n813), .C1(N10832_2), .Y(U1423_C2__n_5));
  BUFX4 BL1_BUF448 (.A(out_acc_r[1]), .Y(out_acc_r_1_2));
  OAI2BB1X1 U1633_C3_1 (.A0N(n673), .A1N(\int_vec3[1] ), .B0(N9204), .Y(N9195));
  NAND4X1 U1525_C3_14 (.A(in_pc_5_1), .B(N8482_1), .C(N6895), .D(N3481), 
     .Y(\in_pc[5] ));
  AOI22X1 U1517_C3_8 (.A0(\in_xrom_r[2] ), .A1(N9874_1), .B0(\rel_addr_a[10] ), 
     .B1(N9867_1), .Y(in_pc_10_2));
  SDFFSRX1 latch_pc_reg_7_ (.CK(clk0_11), .D(N11862), .Q(n77), .QN(n804), 
     .RN(N12147), .SE(test_se_5), .SI(n75), .SN(VDD));
  OAI21X1 U1296_C3_1 (.A0(n640), .A1(ld_idat), .B0(N2059), .Y(N10990));
  OAI221X4 U38_C4_6 (.A0(n624), .A1(N4062), .B0(sel_xad), .B1(N4847), 
     .C0(N12336), .Y(out_xdat[0]));
  INVX2 BW1_INV8342 (.A(N8342), .Y(N8342_1));
  INVX1 U1096_C2_2_MP_INV (.A(sel_pc[0]), .Y(sel_pc_0_1));
  NAND2X1 U1536_C1_9 (.A(sel_in_cy_bit[1]), .B(N11208), .Y(N11921));
  MXI2X1 U1315_C4_1 (.A(n646), .B(in_xrom_a_3_1), .S0(ld_xrom), .Y(N5880));
  AND2X1 U1640_C1 (.A(sel_xaddr_high), .B(\out_dptr_r[9] ), .Y(xaddr_high[1]));
  AOI22X1 U842_C4_12 (.A0(n650_1), .A1(N12195_21), .B0(N1626_21), .B1(n644_1), 
     .Y(U842_C4__n_5));
  NOR2BX1 U1706_C2_3 (.AN(N11562), .B(N10172_1), .Y(out_idat_3_1));
  BUFX12 BW1_BUF953 (.A(combus[1]), .Y(combus_1_1));
  NAND2X1 U894_C2_5 (.A(N2970_2), .B(N10909), .Y(N2970_3));
  NOR2X1 U1197_C1 (.A(n654), .B(N10863), .Y(N11385));
  NOR2X1 U1716_C1_1_C3_7 (.A(op2_3_1), .B(N2131), .Y(op2_3_2));
  OAI2BB1X1 U1714_C3_9_C2_5 (.A0N(N3549_1), .A1N(\out_sfr_a[4] ), .B0(op2_4_2), 
     .Y(op2_4_3));
  AOI22X1 U814_C2_2 (.A0(\in_idat_r[0] ), .A1(U947_C2__n_2), .B0(out_acc_r[0]), 
     .B1(U947_C2__n_5), .Y(N7485));
  NOR2X1 U1714_C3_9_C2_4 (.A(op2_4_4), .B(N10747), .Y(op2_4_2));
  NOR2X1 U826_C3_9_C2_3 (.A(N3616), .B(in_xrom_a_5_1), .Y(N9895));
  NOR3X1 U823_C2_2 (.A(sel_op1_2_2), .B(sel_op1[1]), .C(sel_op1_0_1), .Y(N9992));
  NAND2X1 U1755_C2_4 (.A(N3082_2), .B(N7748), .Y(N3082_3));
  AOI22X1 U1521_C2_8 (.A0(\in_xrom_r[0] ), .A1(N9874_1), .B0(\rel_addr_a[8] ), 
     .B1(N9867_1), .Y(in_pc_8_2));
  INVX1 U1630_C3_1_MP_INV (.A(out_acc_r_2_2), .Y(out_acc_r_2_1));
  AOI22X1 U1342_C2_5 (.A0(N5169), .A1(N11339), .B0(out_pc_r_3_), .B1(N10596), 
     .Y(addr_xrom_a_3_1));
  INVX1 U1624_C5_6_MP_INV (.A(N11862_2), .Y(N11862));
  XNOR2X1 U804_C1 (.A(out_pc_r_10_), .B(U1669_C1__n), .Y(N11142));
  AND2X1 U1691_C1 (.A(out_pc_r_8_), .B(U1691_C1__n), .Y(N9539));
  NOR2BX1 U1667_C1 (.AN(U1667_C1__n), .B(out_pc_r_12_1), .Y(U1666_C1__n));
  OAI222X1 U603_C5_6 (.A0(N6248), .A1(N11339_1), .B0(ld_apc_1), .B1(N11142), 
     .C0(out_pc_r_10_1), .C1(N10596_1), .Y(addr_xrom_a[10]));
  SDFFSRX1 addr2_r_reg_6_ (.CK(clk0_11), .D(U783_C1__n_3), .Q(n146), .QN(n812), 
     .RN(N12147_1), .SE(test_se_3), .SI(n144), .SN(VDD));
  AOI22X1 U970_C1_1 (.A0(U948_C1__n_1), .A1(N10719), .B0(\in_idat_r[0] ), 
     .B1(N6616), .Y(N10021_1));
  AOI22X1 U788_C1_1 (.A0(U948_C1__n_1), .A1(U1020_C1__n_1), .B0(\in_idat_r[6] ), 
     .B1(U1020_C1__n), .Y(N7481_1));
  NOR2X1 U1707_C2_5 (.A(out_idat_2_2), .B(N10171_1), .Y(out_idat_2_3));
  BUFX16 BW1_BUF1624 (.A(out_idat_4_1), .Y(out_idat[4]));
  OAI211X1 U1536_C1_13 (.A0(sel_in_cy_bit[2]), .A1(cy_psw), .B0(N11774_2), 
     .C0(N11209), .Y(N11774));
  AND2X1 U811_C1 (.A(sel_xaddr_low), .B(sel_xad), .Y(N4064));
  NAND2X1 U894_C2_3 (.A(N11501), .B(N11502), .Y(N2970_1));
  AOI22X4 U711_C3_6 (.A0(in_xrom_a[4]), .A1(N9992_1), .B0(\out_sfr_a[4] ), 
     .B1(N9993_2), .Y(op1_4_1));
  u_sfr_test_1 U1_sfr (.end_instr(end_instr), .clk(), .rst_p(rst_p), 
     .ld_acc(ld_acc), .ld_acc_chd(ld_acc_chd), .addr_sfr({addr_a[7], addr_a[6], 
     addr_a[5], addr_a[4], addr_a[3], addr_a[2], addr_a[1], addr_a[0]}), 
     .in_sfr({out_idat[7], out_idat_6_1, out_idat[5], out_idat[4], combus_3_1, 
     combus_2_1, combus_1_1, combus_0_1}), .wr_sfr(wr_sfr), .ld_dpl(ld_dpl), 
     .ld_dph(ld_dph), .inc_dptr(inc_dptr), .inc_sp(inc_sp), .dec_sp(dec_sp), 
     .set_c(set_c), .rst_c(rst_c), .cpl_c(cpl_c), .ld_c(ld_c), .set_ac(set_ac), 
     .rst_ac(rst_ac), .set_v(set_v), .rst_v(rst_v), .acc_chd({\acc_chd[7] , 
     \acc_chd[6] , \acc_chd[5] , \acc_chd[4] , \acc_chd[3] , \acc_chd[2] , 
     \acc_chd[1] , \acc_chd[0] }), .in_b({\in_b[7] , \in_b[6] , \in_b[5] , 
     \in_b[4] , \in_b[3] , \in_b[2] , \in_b[1] , \in_b[0] }), .ld_b(ld_b), 
     .in_cy_bit(in_cy_bit), .rmw(rmw), .t0_pin(t0_pin), .t1_pin(t1_pin), 
     .int0_pin(int0_pin), .int1_pin(int1_pin), .p0_in({p0_in[7], p0_in[6], 
     p0_in[5], p0_in[4], p0_in[3], p0_in[2], p0_in[1], p0_in[0]}), .p1_in({
     p1_in[7], p1_in[6], p1_in[5], p1_in[4], p1_in[3], p1_in[2], p1_in[1], 
     p1_in[0]}), .p2_in({p2_in[7], p2_in[6], p2_in[5], p2_in[4], p2_in[3], 
     p2_in[2], p2_in[1], p2_in[0]}), .p3_in({p3_in[7], p3_in[6], p3_in[5], 
     p3_in[4], p3_in[3], p3_in[2], p3_in[1], p3_in[0]}), .reti(reti), 
     .out_sfr_a({\out_sfr_a[7] , \out_sfr_a[6] , \out_sfr_a[5] , \out_sfr_a[4] , 
     \out_sfr_a[3] , \out_sfr_a[2] , \out_sfr_a[1] , \out_sfr_a[0] }), 
     .out_acc_r({out_acc_r[7], out_acc_r[6], out_acc_r[5], out_acc_r[4], 
     out_acc_r[3], out_acc_r[2], out_acc_r[1], out_acc_r[0]}), .out_dptr_r({
     \out_dptr_r[15] , \out_dptr_r[14] , \out_dptr_r[13] , \out_dptr_r[12] , 
     \out_dptr_r[11] , \out_dptr_r[10] , \out_dptr_r[9] , \out_dptr_r[8] , 
     \out_dptr_r[7] , \out_dptr_r[6] , \out_dptr_r[5] , \out_dptr_r[4] , 
     \out_dptr_r[3] , \out_dptr_r[2] , \out_dptr_r[1] , \out_dptr_r[0] }), 
     .out_dimod_r({out_dimod_r[7], out_dimod_r[6], out_dimod_r[5], 
     out_dimod_r[4], out_dimod_r[3], out_dimod_r[2], out_dimod_r[1], 
     out_dimod_r[0]}), .out_sp_r({\out_sp_r[7] , \out_sp_r[6] , \out_sp_r[5] , 
     \out_sp_r[4] , \out_sp_r[3] , \out_sp_r[2] , \out_sp_r[1] , \out_sp_r[0] }), 
     .out_psw({cy_psw, out_psw_6_, SYNOPSYS_UNCONNECTED__0, out_psw_4_, 
     out_psw_3_, SYNOPSYS_UNCONNECTED__1, SYNOPSYS_UNCONNECTED__2, 
     SYNOPSYS_UNCONNECTED__3}), .out_b({\out_b[7] , \out_b[6] , \out_b[5] , 
     \out_b[4] , \out_b[3] , \out_b[2] , \out_b[1] , \out_b[0] }), .p0_out({
     p0_out[7], p0_out[6], p0_out[5], p0_out[4], p0_out[3], p0_out[2], 
     p0_out[1], p0_out[0]}), .p1_out({p1_out[7], p1_out[6], p1_out[5], p1_out[4], 
     p1_out[3], p1_out[2], p1_out[1], p1_out[0]}), .p2_out({p2_out[7], p2_out[6], 
     p2_out[5], p2_out[4], p2_out[3], p2_out[2], p2_out[1], p2_out[0]}), 
     .p3_out({p3_out[7], p3_out[6], p3_out[5], p3_out[4], p3_out[3], p3_out[2], 
     p3_out[1], p3_out[0]}), .txdo(txdo), .rxdi(rxdi), .rxdo(rxdo), .int_vec({
     \int_vec[2] , \int_vec[1] , \int_vec[0] }), .en_int(en_int), 
     .rc8051RtlTop_test_mode_in(rc8051RtlTop_test_mode_in), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si1(n29), .test_so1(test_so3), .test_si2(test_si4), 
     .test_so2(test_so4), .test_si3(test_si5), .test_so3(test_so5), 
     .test_si4(test_si6), .test_so4(test_so6), .test_si5(test_si7), 
     .test_so5(test_so7), .test_si6(test_si8), .test_so6(test_so8), 
     .test_si7(test_si9), .test_so7(test_so9), .test_si8(test_si10), 
     .test_so8(test_so10), .test_si9(test_si11), .test_so9(n11), 
     .test_se(test_se_3), .clk0_26(clk0_26), .clk0_8(clk0_9), .clk0_10(clk0_11), 
     .clk0_21(clk0_21), .clk0_9(clk0_10), .clk0_5(clk0_8));
  MXI2X1 U1545_C4_1 (.A(n543), .B(in_xrom_a_7_1), .S0(ld_instr), .Y(N12251));
  NOR2BX1 U964_C3_1 (.AN(U1771_C3__n_1), .B(U964_C3__n_3), .Y(U964_C3__n_2));
  AOI22X1 U32_C4_5 (.A0(\in_idat_r[3] ), .A1(N4062_1), .B0(\out_dptr_r[3] ), 
     .B1(N4064), .Y(out_xdat_3_1));
  INVX1 U1656_C5_6_MP_INV (.A(N6340_2), .Y(N6340));
  NOR2X1 U964_C3_5 (.A(N3927), .B(N5119), .Y(N6847));
  XOR2X1 U1472_C1 (.A(\out_dptr_r[1] ), .B(out_acc_r_1_2), .Y(N5177));
  AND2X1 U1675_C1 (.A(\out_dptr_r[12] ), .B(U1675_C1__n), .Y(U1674_C1__n));
  NAND2X1 U1171_C1 (.A(\out_sfr_a[0] ), .B(U1171_C1__n), .Y(N6051));
  INVX1 U765_C2_2_MP_INV (.A(U1010_C1__n), .Y(U1010_C1__n_2));
  AOI222X1 U854_C1_1 (.A0(U948_C1__n_1), .A1(U1010_C1__n_3), .B0(\in_idat_r[5] ), 
     .B1(N10628), .C0(\out_sfr_a[5] ), .C1(N11073), .Y(N7480));
  NAND2X1 U1009_C1 (.A(U1061_C1__n), .B(U1021_C1__n), .Y(U1010_C1__n_1));
  INVX2 U938_C1_2_MP_INV (.A(bit_addr_1), .Y(n783_1));
  AOI22X1 U847_C4_12 (.A0(n625_1), .A1(N12195_2), .B0(N1626_2), .B1(n643_1), 
     .Y(U847_C4__n_5));
  BUFX1 BL2_BUF164 (.A(code[7]), .Y(code_7_1));
  BUFX1 BL2_BUF30 (.A(N1321), .Y(N1321_1));
  AOI22X1 U1180_C1_2 (.A0(\in_xrom_r[7] ), .A1(N10996), .B0(out_acc_r[7]), 
     .B1(N10997), .Y(N8168));
  NOR2BX1 U789_C1 (.AN(sel_combus[2]), .B(sel_combus[3]), .Y(U721_C1__n));
  OAI211X1 U900_C1_10 (.A0(n808), .A1(U738_C2__n), .B0(U1762_C1__n_4), 
     .C0(N11991), .Y(U1762_C1__n));
  INVX1 U1767_C3_6_MP_INV (.A(N1321_4), .Y(N1321_5));
  INVX1 U1760_C1_6_MP_INV (.A(N11163_4), .Y(N11163));
  INVX2 U1627_C3_1_MP_INV (.A(out_acc_r[5]), .Y(out_acc_r_5_1));
  SDFFRHQX1 addr2_r_reg_2_ (.CK(clk0_10), .D(addr2_a_2_), .Q(addr2_r_2_), 
     .RN(N12147_1), .SE(test_se_2), .SI(addr2_r_1_));
  NAND2BX1 U951_C3_1 (.AN(U1771_C3__n_8), .B(n791), .Y(U951_C3__n_1));
  INVX1 U1377_C1 (.A(U1225_C1__n), .Y(N12261));
  AOI32X1 U1527_C3_12 (.A0(n672), .A1(N9195), .A2(N11469_1), 
     .B0(\page_addr_a[3] ), .B1(N8342_1), .Y(N8480_1));
  AOI22X1 U785_C1_2 (.A0(\in_xrom_r[5] ), .A1(N10996), .B0(out_acc_r[5]), 
     .B1(N10997), .Y(N6611));
  NAND3X1 U1097_C2_2 (.A(sel_pc_2_1), .B(sel_pc[1]), .C(sel_pc[0]), .Y(N8484));
  AOI2BB2X1 U1510_C2_7 (.A0N(N3082), .A1N(N8484), .B0(\page_addr_a[13] ), 
     .B1(N8342_1), .Y(in_pc_13_1));
  AND2X1 U1679_C1 (.A(out_pc_r_14_), .B(N6336), .Y(N6333));
  NOR2X2 U1709_C2_5 (.A(out_idat_0_2), .B(U1172_C3__n_2), .Y(out_idat_0_3));
  SDFFSRX1 in_xrom1_r_reg_1_ (.CK(clk0_14), .D(N10993), .Q(in_xrom1_r[1]), 
     .QN(n650), .RN(N12147), .SE(test_se_3), .SI(in_xrom1_r[0]), .SN(VDD));
  INVX1 U1628_C3_1_MP_INV (.A(out_acc_r[4]), .Y(out_acc_r_4_1));
  AOI21X1 U738_C2_1 (.A0(\latch_pc[0] ), .A1(U738_C2__n_2), .B0(U738_C2__n_1), 
     .Y(N7799));
  INVX1 U1542_C4_1_MP_INV (.A(in_xrom_a[1]), .Y(in_xrom_a_1_1));
  INVX1 U964_C3_10_MP_INV (.A(n622), .Y(n622_1));
  INVX1 U847_C4_12_MP_INV_1 (.A(n643), .Y(n643_1));
  NAND2X1 U945_C1 (.A(U948_C1__n_1), .B(U1396_C1__n), .Y(N10171));
  MXI2X1 U1328_C4_1 (.A(n654), .B(N4595), .S0(ld_sfr), .Y(N12262));
  INVX1 U913_C1_2_MP_INV (.A(N10864), .Y(N10864_1));
  AOI2BB2X1 U958_C1_2 (.A0N(n655), .A1N(N3545), .B0(\out_b[2] ), .B1(N3503), 
     .Y(N11489));
  AOI21X1 U899_C2_2 (.A0(in_idat_a[3]), .A1(N7736_1), .B0(U899_C2__n), .Y(N8172));
  AOI21X4 U1760_C1_6 (.A0(\alu_a[3] ), .A1(N7745), .B0(N11163_3), .Y(N11163_4));
  NAND2BX4 U1730_C3_9_C2_6 (.AN(op1_3_3), .B(N3522), .Y(\op1[3] ));
  INVX1 U705_C1 (.A(N3616), .Y(N10450));
  OAI211X1 U1514_C2_10 (.A0(N9881), .A1(N11144), .B0(in_pc_11_2), 
     .C0(in_pc_11_1), .Y(\in_pc[11] ));
  NAND3X1 U703_C2_2 (.A(sel_op2_2_1), .B(sel_op2[1]), .C(sel_op2_0_1), .Y(N3549));
  BUFX8 BL3_S_BUF_14 (.A(N10863_2), .Y(N10863));
  AOI2BB2X1 U1507_C2_7 (.A0N(N3407_6), .A1N(N8484), .B0(\page_addr_a[15] ), 
     .B1(N8342_1), .Y(in_pc_15_1));
  NAND2BX1 U1554_C1 (.AN(U1554_C1__n_1), .B(\out_dptr_r[8] ), .Y(U1560_C1__n));
  NOR2BX2 U1085_C1 (.AN(ld_adptr), .B(ld_apc), .Y(N11339));
  INVX1 U855_C1_3_MP_INV (.A(N7480), .Y(N7480_1));
  INVX1 U1703_C1_MP_INV (.A(out_pc_r_2_), .Y(out_pc_r_2_1));
  XNOR2X1 U809_C1 (.A(out_pc_r_9_), .B(U1670_C1__n), .Y(N10875));
  AOI222X1 U227_C5_6 (.A0(N11705), .A1(N10779), .B0(inc_pc2), .B1(N317), 
     .C0(out_pc_r_8_), .C1(N9736), .Y(N6332_2));
  NOR2BX1 U1668_C1 (.AN(U1668_C1__n), .B(out_pc_r_11_1), .Y(U1667_C1__n));
  AOI222X1 U231_C5_6 (.A0(N11705), .A1(N11033), .B0(inc_pc2), .B1(N315), 
     .C0(out_pc_r_6_), .C1(N9736), .Y(N11032_2));
  AOI2BB1X1 U885_C2_2 (.A0N(n658), .A1N(N11917), .B0(U885_C2__n), .Y(N7748));
  NOR2X1 U1020_C1 (.A(U1020_C1__n_1), .B(U1020_C1__n), .Y(U1068_C3__n_2));
  INVX1 U788_C1_1_MP_INV (.A(N7481_1), .Y(N7481));
  OAI2BB1X2 U1720_C1_5 (.A0N(\out_sfr_a[2] ), .A1N(N3549_1), .B0(op2_2_1), 
     .Y(op2_2_2));
  INVX1 U967_C1_1_MP_INV (.A(n544), .Y(n544_1));
  NAND2BX1 U1091_C1 (.AN(sel_xaddr_low), .B(sel_xad), .Y(N4062));
  NAND3BX4 U1732_C3_9 (.AN(op1_1_2), .B(N3521), .C(op1_1_1), .Y(op1_1_3));
  NAND2BX1 U726_C4 (.AN(cy_psw), .B(sel_bit_dat_out[1]), .Y(N6594));
  NAND2BX1 U841_C3_1 (.AN(U1771_C3__n_8), .B(n794), .Y(U841_C3__n_1));
  SDFFSRX1 in_xrom_r_reg_5_ (.CK(clk0_14), .D(N11594), .Q(\in_xrom_r[5] ), 
     .QN(n649), .RN(N12147), .SE(test_se_5), .SI(\in_xrom_r[4] ), .SN(VDD));
  INVX8 U1770_C2_MP_INV (.A(sel_addr0), .Y(sel_addr0_1));
  NAND2X1 U26_C4_4 (.A(\out_dptr_r[6] ), .B(N4064), .Y(N11107));
  XOR2X1 U1466_C1 (.A(N12054), .B(N10655), .Y(N5169));
  NAND2X1 U1405_C1 (.A(\out_dptr_r[6] ), .B(out_acc_r[6]), .Y(N7737));
  XOR2X2 U1464_C1 (.A(N6054_1), .B(U1777_C2__n), .Y(U964_C3__n_3));
  XNOR2X1 U1550_C1 (.A(\out_dptr_r[12] ), .B(U1675_C1__n), .Y(N5175));
  INVX1 U902_C4_6_MP_INV (.A(addr2_r_2_), .Y(addr2_r_2_1));
  NAND2X1 U1062_C1 (.A(U1077_C1__n), .B(U1061_C1__n), .Y(U1010_C1__n));
  NAND2X1 U1138_C2 (.A(U1139_C1__n), .B(U1021_C1__n), .Y(N6612));
  NOR2X1 U1013_C3_2 (.A(U1013_C3__n_1), .B(U1013_C3__n), .Y(U1171_C1__n_2));
  BUFX1 BL1_ASSIGN_BUF12 (.A(combus_2_2), .Y(out_idat[2]));
  AOI22X1 U1419_C4_12 (.A0(n619_1), .A1(N12195_2), .B0(N1626_21), .B1(n646_1), 
     .Y(U1419_C4__n_5));
  AOI21X4 U1755_C2_5 (.A0(\alu_a[5] ), .A1(N7745), .B0(N3082_3), .Y(N3082));
  NAND2X1 U707_C1_3 (.A(\latch_acc[7] ), .B(U737_C3__n_1), .Y(N1469));
  AOI21X1 U895_C1_1 (.A0(in_xrom_a[6]), .A1(U852_C2__n_1), .B0(U895_C1__n), 
     .Y(N8164));
  AOI22X1 U1452_C2_1 (.A0(\in_xrom_r[2] ), .A1(N10996), .B0(out_acc_r_2_2), 
     .B1(N10997), .Y(N10400_1));
  AOI21X1 U709_C1_9 (.A0(in_xdat_a[6]), .A1(U737_C3__n), .B0(U895_C1__n_2), 
     .Y(U895_C1__n_4));
  NOR2X1 U1754_C1_5 (.A(N6037_1), .B(N3937_2), .Y(N3937_3));
  NAND2X1 U721_C1 (.A(U865_C1__n_1), .B(U721_C1__n), .Y(N11918));
  NOR2X1 U723_C2_3 (.A(\out_dptr_r[4] ), .B(out_acc_r[4]), .Y(N10187_1));
  MXI2X2 U781_C4_1 (.A(U783_C1__n_1), .B(N3922), .S0(U783_C1__n_2), 
     .Y(addr_a_3_1));
  NOR2X1 U1422_C3_2 (.A(N10832_2), .B(n812), .Y(N10024));
  NOR2X2 U783_C1 (.A(U783_C1__n), .B(U783_C1__n_1), .Y(addr_a_6_1));
  AOI22X1 U1529_C2_5 (.A0(N9881_1), .A1(N4077), .B0(in_xrom_a[1]), .B1(N9874_1), 
     .Y(in_pc_1_1));
  AOI22X1 U1525_C3_12 (.A0(in_xrom_a[5]), .A1(N9874_1), .B0(\rel_addr_a[5] ), 
     .B1(N9867_1), .Y(in_pc_5_1));
  INVX1 U1263_C1_6_MP_INV (.A(N11469), .Y(N11469_1));
  NAND4X1 U1504_C3_8 (.A(in_pc_4_2), .B(in_pc_4_1), .C(N2912), .D(N1690), 
     .Y(\in_pc[4] ));
  NAND3X2 U716_C2_2 (.A(sel_addr1[0]), .B(sel_addr1[1]), .C(sel_addr1_2_1), 
     .Y(N10832_3));
  AND2X1 U1076_C1 (.A(U1077_C1__n), .B(U1067_C1__n), .Y(U1020_C1__n_1));
  SDFFSRX2 in_xrom1_r_reg_2_ (.CK(clk0_14), .D(N5900), .Q(in_xrom1_r[2]), 
     .QN(n623), .RN(N12147), .SE(test_se_3), .SI(in_xrom1_r[1]), .SN(VDD));
  AND2X1 U1647_C1 (.A(sel_xaddr_high), .B(\out_dptr_r[15] ), .Y(xaddr_high[7]));
  BUFX16 BL3_S_BUF_29 (.A(code_4_1), .Y(code[4]));
  MXI2X1 U1542_C4_1 (.A(n537), .B(in_xrom_a_1_1), .S0(ld_instr), .Y(N11997));
  SDFFSX1 alu_r_reg_7_ (.CK(clk0_14), .D(\alu_a[7] ), .Q(n64), .QN(n821), 
     .SE(test_se_3), .SI(n62), .SN(VDD));
  INVX1 U842_C4_12_MP_INV_1 (.A(n644), .Y(n644_1));
  INVX1 U1706_C2_3_MP_INV (.A(N10172), .Y(N10172_1));
  MXI2X1 U1302_C3_1 (.A(n624), .B(N4849), .S0(ld_idat), .Y(N11927));
  OAI22X1 U1185_C2_3 (.A0(n642), .A1(N11918), .B0(n659), .B1(N11917), 
     .Y(U1185_C2__n));
  INVX1 U1169_C2_3_MP_INV (.A(N7736), .Y(N7736_1));
  MXI2X1 U1323_C4_1 (.A(n659), .B(out_sfr_a_4_1), .S0(ld_sfr), .Y(N12188));
  SDFFSRX1 out_sfr_r_reg_3_ (.CK(clk0_14), .D(N12189), .Q(n130), .QN(n660), 
     .RN(N12147_1), .SE(test_se_4), .SI(n126), .SN(VDD));
  INVX1 U1394_C3_1_MP_INV_1 (.A(U947_C2__n_2), .Y(U947_C2__n_4));
  MXI2X1 U1319_C4_1 (.A(n657), .B(out_sfr_a_6_1), .S0(ld_sfr), .Y(N5886));
  NAND3X1 U699_C1_2 (.A(sel_op1_2_1), .B(sel_op1_1_1), .C(sel_op1_0_1), 
     .Y(U947_C2__n_1));
  NAND3X1 U1041_C2_2 (.A(sel_op2_2_1), .B(sel_op2[1]), .C(sel_op2[0]), .Y(N3616));
  NAND2X1 U1184_C1 (.A(\out_sfr_a[4] ), .B(N10221), .Y(N8171));
  OAI211X1 U1507_C2_10 (.A0(N9881), .A1(N10595), .B0(in_pc_15_2), 
     .C0(in_pc_15_1), .Y(\in_pc[15] ));
  OAI21X2 U1778_C2_1 (.A0(N8905), .A1(N5887), .B0(N11064), .Y(U1777_C2__n));
  INVX1 U1348_C2_6_MP_INV (.A(addr_xrom_a_0_2), .Y(addr_xrom_a[0]));
  AOI222X1 U235_C5_6 (.A0(N9390), .A1(N11705), .B0(inc_pc2), .B1(N313), 
     .C0(out_pc_r_4_), .C1(N9736), .Y(N11984_2));
  SDFFX1 int_vec2_reg_1_ (.CK(clk0_11), .D(\int_vec1[1] ), .Q(\int_vec2[1] ), 
     .QN(), .SE(test_se_5), .SI(\int_vec2[0] ));
  AND2X1 U1689_C1 (.A(out_pc_r_9_), .B(N9539), .Y(U1687_C1__n));
  AND2X1 U1687_C1 (.A(out_pc_r_10_), .B(U1687_C1__n), .Y(U1685_C1__n));
  INVX1 U558_C5_6_MP_INV_3 (.A(ld_apc), .Y(ld_apc_1));
  SDFFSRX1 latch_pc_reg_5_ (.CK(clk0_11), .D(N9388), .Q(n73), .QN(n806), 
     .RN(N12147), .SE(test_se_5), .SI(n70), .SN(VDD));
  INVX1 U838_C1_1_MP_INV (.A(N10597), .Y(N10597_1));
  OAI21X2 U824_C2_5 (.A0(N2970_4), .A1(bit_addr_1), .B0(n688_2), .Y(out_idat[6]));
  AOI22X1 U1383_C2_2 (.A0(U948_C1__n_1), .A1(U1070_C1__n_2), .B0(\out_sfr_a[2] ), 
     .B1(N6651), .Y(N11909));
  INVX1 U879_C1 (.A(\out_sfr_a[2] ), .Y(N10631));
  INVX1 U893_C1_1_MP_INV (.A(U852_C2__n), .Y(U852_C2__n_1));
  INVX4 U1110_C2_2_MP_INV_1 (.A(sel_addr1[1]), .Y(sel_addr1_1_1));
  BUFX3 BL1_ASSIGN_BUF17 (.A(out_idat_7_1), .Y(combus[7]));
  SDFFSRX1 out_sfr_r_reg_6_ (.CK(clk0_14), .D(N5886), .Q(n141), .QN(n657), 
     .RN(N12147_1), .SE(test_se_2), .SI(n139), .SN(VDD));
  SDFFSRX1 latch_pc_reg_8_ (.CK(clk0_11), .D(N6332), .Q(n97), .QN(n803), 
     .RN(N12147), .SE(test_se_5), .SI(n77), .SN(VDD));
  INVX1 U1316_C4_1_MP_INV (.A(in_xrom_a[4]), .Y(in_xrom_a_4_1));
  INVX1 U1631_C3_1_MP_INV (.A(out_acc_r_1_2), .Y(out_acc_r_1_1));
  INVX1 U36_C4_5_MP_INV_1 (.A(N4062), .Y(N4062_1));
  ADDFX1 U1563 (.A(out_acc_r_1_2), .B(add_434_carry_2_), .CI(N6055), 
     .CO(add_465_carry_2_), .S(a_plus_pc_1_));
  INVX1 U1779_C2_2_MP_INV (.A(\out_dptr_r[3] ), .Y(out_dptr_r_3_1));
  NAND2X1 U887_C1_3 (.A(test_so1), .B(U737_C3__n_1), .Y(N3123));
  INVX1 U1468_C1_MP_INV (.A(U953_C3__n_3), .Y(U953_C3__n));
  NOR2X1 U842_C4_6 (.A(N10832_2), .B(addr2_r_1_1), .Y(N5004));
  INVX1 U1137_C1 (.A(N3924), .Y(addr2_a_2_));
  NAND2X1 U1139_C1 (.A(U1141_C1__n), .B(U1139_C1__n), .Y(N11767));
  AND2X1 U1077_C1 (.A(U1077_C1__n), .B(U1075_C1__n), .Y(U1396_C1__n));
  OAI22X2 U780_C3_1 (.A0(U783_C1__n_2), .A1(U1225_C1__n), .B0(bit_addr_1), 
     .B1(N3924), .Y(addr_a_2_1));
  INVX1 U950_C4_12_MP_INV_1 (.A(n647), .Y(n647_1));
  NAND2X1 U864_C1 (.A(U864_C1__n_1), .B(U864_C1__n), .Y(N11553));
  NAND2X1 U1191_C1 (.A(\out_sfr_a[2] ), .B(N10221), .Y(N7734));
  SDFFSRX1 latch_pc_reg_13_ (.CK(clk0_14), .D(N6345), .Q(n86), .QN(n798), 
     .RN(N12147), .SE(test_se_5), .SI(n84), .SN(VDD));
  INVX1 U1544_C4_1_MP_INV (.A(in_xrom_a[2]), .Y(in_xrom_a_2_1));
  AOI21X1 U888_C1_9 (.A0(in_xdat_a[1]), .A1(U737_C3__n), .B0(U1192_C1__n_2), 
     .Y(U1192_C1__n_4));
  INVX1 BL2_INV3 (.A(N3407_5), .Y(N3407_6));
  INVX8 U1775_C2_2_MP_INV (.A(sel_addr1[2]), .Y(sel_addr1_2_1));
  NAND2BX1 U953_C3_5 (.AN(N11007), .B(N3927_2), .Y(N4635));
  BUFX16 BW1_BUF880 (.A(addr_a_4_1), .Y(addr_a[4]));
  NAND4X1 U950_C4_17 (.A(U951_C3__n_1), .B(U950_C4__n_8), .C(U950_C4__n_6), 
     .D(U950_C4__n_5), .Y(U950_C4__n_2));
  INVX2 U1425_C2_MP_INV (.A(U783_C1__n_3), .Y(U783_C1__n_1));
  NAND2X1 U1523_C2_10 (.A(in_pc_7_3), .B(in_pc_7_2), .Y(\in_pc[7] ));
  AOI222X1 U245_C5_6 (.A0(N6335), .A1(N11705), .B0(inc_pc2), .B1(N323), 
     .C0(out_pc_r_14_), .C1(N9736), .Y(N6334_2));
  SDFFSRX4 code_reg_4_ (.CK(clk0_14), .D(N9711), .Q(code_4_1), .QN(n540), 
     .RN(N12147), .SE(test_se), .SI(code[3]), .SN(VDD));
  AOI22X1 U1514_C2_8 (.A0(\in_xrom_r[3] ), .A1(N9874_1), .B0(\rel_addr_a[11] ), 
     .B1(N9867_1), .Y(in_pc_11_2));
  MXI2X1 U1654_C5_5 (.A(N11705), .B(N9736), .S0(add_434_carry_2_), .Y(N9744_1));
  SDFFRHQX1 in_idat1_r_reg_4_ (.CK(clk0_11), .D(\in_idat_r[4] ), .Q(n791), 
     .RN(N12147_1), .SE(test_se_2), .SI(n792));
  OAI21X1 U1298_C3_1 (.A0(n642), .A1(ld_idat), .B0(N7961), .Y(N10992));
  INVX2 BW1_INV9874 (.A(N9874), .Y(N9874_1));
  NOR2BX1 U790_C1 (.AN(sel_combus[3]), .B(sel_combus[2]), .Y(U864_C1__n));
  INVX1 U832_C2_2_MP_INV (.A(sel_pc[2]), .Y(sel_pc_2_1));
  SDFFSRX1 in_xrom_r_reg_2_ (.CK(clk0_14), .D(N10205), .Q(\in_xrom_r[2] ), 
     .QN(n645), .RN(N12147), .SE(test_se_5), .SI(\in_xrom_r[1] ), .SN(VDD));
  INVX1 U842_C4_12_MP_INV (.A(n650), .Y(n650_1));
  OAI21X2 U1706_C2_6 (.A0(N11163_4), .A1(bit_addr_1), .B0(out_idat_3_3), 
     .Y(combus_3_2));
  SDFFSRX1 out_sfr_r_reg_0_ (.CK(clk0_14), .D(N12262), .Q(\out_sfr_r[0] ), 
     .QN(n654), .RN(N12147_1), .SE(test_se_2), .SI(n91), .SN(VDD));
  OAI2BB1X1 U1731_C3_9_C2_5 (.A0N(\out_sfr_a[2] ), .A1N(N9993_2), .B0(op1_2_1), 
     .Y(op1_2_3));
  OAI22X1 U720_C2_3 (.A0(n637), .A1(N11918), .B0(n655), .B1(N11917), 
     .Y(U720_C2__n));
  OAI22X1 U899_C2_3 (.A0(n639), .A1(N11918), .B0(n660), .B1(N11917), 
     .Y(U899_C2__n));
  MXI2X1 U1301_C3_1 (.A(n638), .B(N4846), .S0(ld_idat), .Y(N10208));
  MXI2X1 U1317_C4_1 (.A(n656), .B(out_sfr_a_7_1), .S0(ld_sfr), .Y(N11429));
  INVX1 U1714_C3_9_C2_4_MP_INV (.A(op2_4_1), .Y(op2_4_4));
  AOI22X1 U1519_C2_7 (.A0(N3937), .A1(N8484_1), .B0(\page_addr_a[9] ), 
     .B1(N8342_1), .Y(in_pc_9_1));
  INVX1 BL2_INV10 (.A(N10457), .Y(N10457_1));
  NAND3X1 U866_C1_2 (.A(sel_op2_2_1), .B(sel_op2_1_1), .C(sel_op2_0_1), 
     .Y(N11037));
  AOI22X1 U1508_C2_8 (.A0(\in_xrom_r[6] ), .A1(N9874_1), .B0(\rel_addr_a[14] ), 
     .B1(N9867_1), .Y(in_pc_14_2));
  OAI21X1 U1577_C2_1 (.A0(\out_dptr_r[8] ), .A1(U1554_C1__n), .B0(U1560_C1__n), 
     .Y(N5171));
  NOR2X2 U1084_C2 (.A(ld_apc), .B(ld_adptr), .Y(N10596));
  INVX1 U1073_C1_3_MP_INV (.A(U1068_C3__n_1), .Y(U1068_C3__n_5));
  AOI222X1 U1656_C5_6 (.A0(N11705), .A1(N11485), .B0(inc_pc2), .B1(N312), 
     .C0(out_pc_r_3_), .C1(N9736), .Y(N6340_2));
  SDFFX1 int_vec2_reg_0_ (.CK(clk0_11), .D(\int_vec1[0] ), .Q(\int_vec2[0] ), 
     .QN(), .SE(test_se_5), .SI(\int_vec1[2] ));
  AOI222X1 U1624_C5_6 (.A0(N11863), .A1(N11705), .B0(inc_pc2), .B1(N316), 
     .C0(out_pc_r_7_), .C1(N9736), .Y(N11862_2));
  INVX1 U599_C5_6_MP_INV (.A(out_pc_r_11_), .Y(out_pc_r_11_1));
  AND2X1 U1695_C1 (.A(out_pc_r_6_), .B(N9389), .Y(N9541));
  AOI22X1 U1728_C3_7 (.A0(\in_idat_r[6] ), .A1(U947_C2__n_2), .B0(out_acc_r[6]), 
     .B1(U947_C2__n_5), .Y(op1_6_2));
  NAND2X1 U799_C1 (.A(U1068_C3__n_3), .B(N6053), .Y(N7484));
  NAND3X1 U794_C1_2 (.A(U839_C1__n_1), .B(U839_C1__n), .C(N2040), .Y(N10597));
  MXI2X1 U1326_C4_1 (.A(n655), .B(N10631), .S0(ld_sfr), .Y(N12190));
  NOR3BX4 U840_C2_2 (.AN(sel_addr1[1]), .B(sel_addr1[0]), .C(sel_addr1[2]), 
     .Y(N3927_2));
  INVX1 U1784_C1 (.A(out_acc_r[0]), .Y(N4847));
  AOI22X1 U919_C1_2 (.A0(in_idat_a[3]), .A1(N10864_1), .B0(n130), .B1(N10863_1), 
     .Y(N3522));
  NAND2BX1 U1536_C1_10 (.AN(N8382), .B(cy_psw), .Y(N1423));
  MXI2X1 U1314_C4_1 (.A(n649), .B(in_xrom_a_5_1), .S0(ld_xrom), .Y(N11594));
  SDFFSRX1 in_xrom_r_reg_1_ (.CK(clk0_14), .D(N10206), .Q(\in_xrom_r[1] ), 
     .QN(n644), .RN(N12147), .SE(test_se), .SI(\in_xrom_r[0] ), .SN(VDD));
  OAI21X1 U32_C4_6 (.A0(sel_xad), .A1(n1457_1), .B0(out_xdat_3_1), 
     .Y(out_xdat_3_2));
  INVX1 U1771_C3_1_MP_INV (.A(U1771_C3__n_1), .Y(U1771_C3__n_9));
  XOR2X1 U1467_C1 (.A(\out_dptr_r[3] ), .B(n1457_1), .Y(N10655));
  MXI2X1 U1631_C3_1 (.A(n682), .B(out_acc_r_1_1), .S0(ld_latch_acc), .Y(N11486));
  XNOR2X1 U1470_C1 (.A(\out_dptr_r[0] ), .B(out_acc_r[0]), .Y(N4061));
  AND2X1 U1677_C1 (.A(\out_dptr_r[10] ), .B(U1677_C1__n), .Y(U1676_C1__n));
  NOR2X1 U902_C4_15 (.A(N4622), .B(N11024), .Y(U902_C4__n_8));
  SDFFRHQX1 addr2_r_reg_1_ (.CK(clk0_10), .D(addr2_a_1_), .Q(addr2_r_1_), 
     .RN(N12147_1), .SE(test_se_2), .SI(addr2_r_0_));
  NOR4BX1 U1059_C3_3 (.AN(N6612), .B(U1013_C3__n_2), .C(U1013_C3__n), 
     .D(N11767_1), .Y(N8163));
  NAND2X1 U1142_C2 (.A(U1139_C1__n), .B(U1077_C1__n), .Y(U1070_C1__n));
  BUFX4 BW1_BUF951 (.A(combus_3_2), .Y(combus_3_1));
  INVX1 U1279_C4_1_MP_INV (.A(in_xrom_a[0]), .Y(in_xrom_a_0_1));
  NOR2X1 U812_C2_4 (.A(N10311_1), .B(N11385), .Y(n763_1));
  OAI22X1 U888_C1_7 (.A0(n802), .A1(N7741), .B0(n815), .B1(N11443), 
     .Y(U1192_C1__n_2));
  OAI22X1 U707_C1_7 (.A0(n796), .A1(N7741), .B0(n821), .B1(N11443), 
     .Y(U893_C1__n_2));
  MXI2X1 U1625_C3_1 (.A(n676), .B(out_acc_r_7_1), .S0(ld_latch_acc), .Y(N11430));
  INVX1 U249_C5_6_MP_INV (.A(N6329_2), .Y(N6329));
  NAND2X1 U892_C2_3 (.A(N10578), .B(N8168), .Y(N3407_1));
  NOR2BX1 U892_C2_4 (.AN(N12244), .B(N3407_1), .Y(N3407_2));
  INVX1 U723_C2_1_MP_INV (.A(N11324), .Y(N11324_1));
  SDFFRHQX1 addr2_r_reg_4_ (.CK(clk0_11), .D(N5879), .Q(addr2_r_4_), 
     .RN(N12147_1), .SE(test_se_3), .SI(addr2_r_3_));
  NAND4X1 U1419_C4_17 (.A(U949_C3__n_1), .B(U1419_C4__n_8), .C(U1419_C4__n_6), 
     .D(U1419_C4__n_5), .Y(U1419_C4__n_2));
  INVX1 U964_C3_MP_INV (.A(n789), .Y(n789_1));
  AOI22X1 U1508_C2_7 (.A0(N2970), .A1(N8484_1), .B0(\page_addr_a[14] ), 
     .B1(N8342_1), .Y(in_pc_14_1));
  AOI22X1 U1510_C2_8 (.A0(\in_xrom_r[5] ), .A1(N9874_1), .B0(\rel_addr_a[13] ), 
     .B1(N9867_1), .Y(in_pc_13_2));
  NAND4X1 U1529_C2_7 (.A(in_pc_1_1), .B(N7041), .C(N11600_1), .D(N10920), 
     .Y(\in_pc[1] ));
  NAND2X1 U1527_C3_7 (.A(N11163), .B(N12228_2), .Y(N11391));
  OAI221X1 U982_C1_9 (.A0(n624), .A1(N11918), .B0(n654), .B1(N11917), 
     .C0(U982_C1__n_1), .Y(U982_C1__n_3));
  NAND3X1 U1383_C2_6 (.A(U1070_C1__n_1), .B(U1013_C3__n_4), .C(N12116), 
     .Y(N6651));
  SDFFSRX1 in_idat_r_reg_0_ (.CK(clk0_14), .D(N11927), .Q(\in_idat_r[0] ), 
     .QN(n624), .RN(N12147_1), .SE(test_se_3), .SI(test_si1), .SN(VDD));
  XOR2X1 U1158_C1 (.A(sel_in_cy_bit[0]), .B(N11209), .Y(N11208));
  AND2X1 U1644_C1 (.A(sel_xaddr_high), .B(\out_dptr_r[12] ), .Y(xaddr_high[4]));
  AOI22X1 U1504_C3_5 (.A0(in_xrom_a[4]), .A1(N9874_1), .B0(\page_addr_a[4] ), 
     .B1(N8342_1), .Y(in_pc_4_1));
  OAI2BB2X1 U964_C3_10 (.A0N(n622_1), .A1N(N12195_2), .B0(N1626), .B1(n648), 
     .Y(U1425_C2__n_1));
  AND2X1 U1641_C1 (.A(sel_xaddr_high), .B(\out_dptr_r[8] ), .Y(xaddr_high[0]));
  SDFFSRX1 in_idat_r_reg_4_ (.CK(clk0_11), .D(N10992), .Q(\in_idat_r[4] ), 
     .QN(n642), .RN(N12147_1), .SE(test_se_2), .SI(\in_idat_r[3] ), .SN(VDD));
  NOR2X1 U1708_C1_3 (.A(N12117_1), .B(N10022_1), .Y(out_idat_1_1));
  NAND2BX1 U1758_C1_5 (.AN(N3289_2), .B(N10343), .Y(N3289_3));
  NOR2X1 U1720_C1_3 (.A(N3616), .B(in_xrom_a_2_1), .Y(N2314));
  NOR2X1 U1720_C1_4 (.A(N11489_1), .B(N2314), .Y(op2_2_1));
  NAND3X4 U1710_C3_9 (.A(op2_7_2), .B(op2_7_1), .C(N9192), .Y(\op2[7] ));
  AOI2BB2X1 U1729_C3_9_C3_5 (.A0N(N10863), .A1N(n658), .B0(N9992_1), 
     .B1(in_xrom_a[5]), .Y(op1_5_1));
  NOR2BX1 U1730_C3_9_C2_3 (.AN(N9992_1), .B(in_xrom_a_3_1), .Y(N3326));
  NOR3X2 U1042_C2_2 (.A(sel_op2_2_1), .B(sel_op2[1]), .C(sel_op2[0]), .Y(N3503));
  MXI2X1 U1308_C4_1 (.A(n623), .B(in_xrom_a_2_1), .S0(ld_operand2), .Y(N5900));
  NAND2X1 U1525_C3_6 (.A(U953_C3__n), .B(N9881_1), .Y(N3481));
  OAI2BB1X1 U1652_C5_2 (.A0N(inc_pc2), .A1N(N309), .B0(N11700), .Y(N6341));
  SDFFSRX1 latch_acc_reg_4_ (.CK(clk0_11), .D(N5884), .Q(\latch_acc[4] ), 
     .QN(n679), .RN(N12147_1), .SE(test_se_5), .SI(\latch_acc[3] ), .SN(VDD));
  XOR2X1 U1704_C1 (.A(out_pc_r_2_1), .B(add_434_carry_2_1), .Y(N11111));
  XOR2X1 U1698_C1 (.A(out_pc_r_5_), .B(N11983), .Y(N9394));
  INVX1 U554_C5_6_MP_INV (.A(out_pc_r_9_), .Y(out_pc_r_9_1));
  AOI222X1 U829_C5_6 (.A0(N6112), .A1(N11705), .B0(inc_pc2), .B1(N319), 
     .C0(out_pc_r_10_), .C1(N9736), .Y(N5883_2));
  OAI222X1 U591_C5_6 (.A0(N11339_1), .A1(N11286), .B0(ld_apc_1), .B1(N11287), 
     .C0(out_pc_r_13_1), .C1(N10596_1), .Y(addr_xrom_a[13]));
  INVX1 U558_C5_6_MP_INV_1 (.A(out_pc_r_8_), .Y(out_pc_r_8_1));
  MXI2X4 U842_C4_4 (.A(U842_C4__n_2), .B(addr_bank_a[1]), .S0(sel_addr0), 
     .Y(N3917));
  OAI2BB1X1 U1379_C1_1 (.A0N(U1068_C3__n_1), .A1N(N6053), .B0(\in_idat_r[3] ), 
     .Y(N11562));
  OAI21X1 U1399_C2_1 (.A0(N6616), .A1(N10719), .B0(\in_idat_r[1] ), .Y(N10022));
  AOI22X1 U1387_C2_2 (.A0(in_idat_a[5]), .A1(N11037_1), .B0(\in_idat_r[5] ), 
     .B1(N10457_3), .Y(N9181));
  AOI22X1 U1390_C2_2 (.A0(in_idat_a[6]), .A1(N11037_1), .B0(\in_idat_r[6] ), 
     .B1(N10457_3), .Y(N10772));
  u_datapath_DW01_add_16_1 add_387 (.A({\in_rel_adder[15] , \in_rel_adder[14] , 
     \in_rel_adder[13] , \in_rel_adder[12] , \in_rel_adder[11] , 
     \in_rel_adder[10] , \in_rel_adder[9] , \in_rel_adder[8] , 
     \in_rel_adder[7] , \in_rel_adder[6] , \in_rel_adder[5] , \in_rel_adder[4] , 
     \in_rel_adder[3] , \in_rel_adder[2] , \in_rel_adder[1] , \in_rel_adder[0] }), 
     .B({out_pc_r_15_, out_pc_r_14_, out_pc_r_13_, out_pc_r_12_, out_pc_r_11_, 
     out_pc_r_10_, out_pc_r_9_, out_pc_r_8_, out_pc_r_7_, out_pc_r_6_, 
     out_pc_r_5_, out_pc_r_4_, out_pc_r_3_, out_pc_r_2_, add_434_carry_2_, N327}), 
     .CI(VSS), .SUM({\rel_addr_a[15] , \rel_addr_a[14] , \rel_addr_a[13] , 
     \rel_addr_a[12] , \rel_addr_a[11] , \rel_addr_a[10] , \rel_addr_a[9] , 
     \rel_addr_a[8] , \rel_addr_a[7] , \rel_addr_a[6] , \rel_addr_a[5] , 
     \rel_addr_a[4] , \rel_addr_a[3] , \rel_addr_a[2] , \rel_addr_a[1] , 
     \rel_addr_a[0] }), .CO());
  NAND4X2 U847_C4_17 (.A(U967_C1__n_1), .B(U847_C4__n_8), .C(U847_C4__n_6), 
     .D(U847_C4__n_5), .Y(U847_C4__n_2));
  NAND2X1 U1754_C1_3 (.A(N11200_1), .B(N10852), .Y(N3937_1));
  INVX1 U866_C1_2_MP_INV (.A(sel_op2[0]), .Y(sel_op2_0_1));
  page_addr U27_page_addr (.pc({out_pc_r_15_, out_pc_r_14_, out_pc_r_13_, 
     out_pc_r_12_, out_pc_r_11_}), .code({code[7], code[6], code[5]}), .xrom({
     \xrom[7] , \xrom[6] , \xrom[5] , \xrom[4] , \xrom[3] , \xrom[2] , 
     \xrom[1] , \xrom[0] }), .page_addr_a({\page_addr_a[15] , \page_addr_a[14] , 
     \page_addr_a[13] , \page_addr_a[12] , \page_addr_a[11] , \page_addr_a[10] , 
     \page_addr_a[9] , \page_addr_a[8] , \page_addr_a[7] , \page_addr_a[6] , 
     \page_addr_a[5] , \page_addr_a[4] , \page_addr_a[3] , \page_addr_a[2] , 
     \page_addr_a[1] , \page_addr_a[0] }));
  NAND2X1 U1004_C1 (.A(U865_C1__n), .B(U864_C1__n_1), .Y(N7736));
  NOR2BX1 U1780_C2 (.AN(\out_dptr_r[2] ), .B(out_acc_r_2_1), .Y(N5611));
  NOR2X1 U964_C3_11 (.A(U1425_C2__n_1), .B(N6847), .Y(U1425_C2__n_2));
  NOR2X1 U1703_C1 (.A(out_pc_r_2_1), .B(add_434_carry_2_1), .Y(U1701_C1__n));
  NOR2X1 U1779_C2 (.A(\out_dptr_r[3] ), .B(out_acc_r[3]), .Y(N10077));
  XOR2X1 U1460_C1 (.A(N5641), .B(N2333), .Y(N5196));
  XNOR2X1 U1549_C1 (.A(\out_dptr_r[11] ), .B(U1676_C1__n), .Y(N11144));
  OAI22X2 U776_C2_1 (.A0(U783_C1__n_2), .A1(N3922), .B0(bit_addr_1), .B1(N3925), 
     .Y(addr_a_0_1));
  INVX1 U842_C4_6_MP_INV (.A(addr2_r_1_), .Y(addr2_r_1_1));
  AND2X1 U1145_C1 (.A(addr2_a_1_), .B(addr2_a_0_), .Y(U1075_C1__n_1));
  AND2X1 U1144_C1 (.A(N3917), .B(addr2_a_0_), .Y(U1021_C1__n));
  NAND2BX4 U833_C1 (.AN(n783_1), .B(U833_C1__n), .Y(U783_C1__n_2));
  MXI2X1 U1278_C4_1 (.A(n643), .B(in_xrom_a_0_1), .S0(ld_xrom), .Y(N10207));
  BUFX1 BW1_BUF247_3 (.A(test_se), .Y(test_se_1));
  NAND2X1 U892_C2_5 (.A(N3407_2), .B(N8169), .Y(N3407_3));
  SDFFSRX2 in_xrom_r_reg_7_ (.CK(clk0_14), .D(N11592), .Q(\in_xrom_r[7] ), 
     .QN(n632), .RN(N12147), .SE(test_se_5), .SI(\in_xrom_r[6] ), .SN(VDD));
  NAND3X1 U1121_C2_2 (.A(sel_combus[3]), .B(sel_combus[2]), .C(U865_C1__n_1), 
     .Y(N7741));
  OAI211X1 U709_C1_10 (.A0(n805), .A1(U738_C2__n), .B0(U895_C1__n_4), .C0(N5599), 
     .Y(U895_C1__n));
  AOI21X1 U1767_C3_6 (.A0(\alu_a[0] ), .A1(N7745), .B0(N1321_5), .Y(N1321));
  INVX1 U1767_C3_4_MP_INV (.A(N10401), .Y(N10401_1));
  BUFX3 BW1_BUF961 (.A(out_xdat_1_2), .Y(out_xdat[1]));
  AOI22X1 U765_C2_2 (.A0(U948_C1__n_1), .A1(U1010_C1__n_2), .B0(\out_sfr_a[6] ), 
     .B1(N5990), .Y(N7487));
  NOR2X1 U964_C3 (.A(U1771_C3__n_8), .B(n789_1), .Y(U964_C3__n_1));
  MXI2X2 U1419_C4_4 (.A(U1419_C4__n_2), .B(out_psw_3_), .S0(sel_addr0), 
     .Y(N3922));
  AOI2BB2X1 U1512_C2_7 (.A0N(N3289_4), .A1N(N8484), .B0(\page_addr_a[12] ), 
     .B1(N8342_1), .Y(in_pc_12_1));
  NAND2X1 U1181_C1 (.A(\out_sfr_a[5] ), .B(N10221), .Y(N6599));
  MXI2X1 U1548_C4_1 (.A(n540), .B(in_xrom_a_4_1), .S0(ld_instr), .Y(N9711));
  NAND2BX1 U799_C1_1 (.AN(U1013_C3__n), .B(N12116), .Y(N10877));
  AOI222X1 U247_C5_6 (.A0(N6327), .A1(N11705), .B0(inc_pc2), .B1(N322), 
     .C0(out_pc_r_13_), .C1(N9736), .Y(N6345_2));
  AOI222X1 U1599_C5_6 (.A0(N12038), .A1(N11705), .B0(inc_pc2), .B1(N324), 
     .C0(out_pc_r_15_), .C1(N9736), .Y(N6337_2));
  SDFFSRX4 code_reg_5_ (.CK(clk0_14), .D(N9707), .Q(code[5]), .QN(n541), 
     .RN(N12147), .SE(test_se), .SI(code[4]), .SN(VDD));
  INVX1 U830_C5_6_MP_INV (.A(N10922_2), .Y(N10922));
  AND2X2 U1049_C1 (.A(U721_C1__n), .B(U1007_C1__n), .Y(U737_C3__n));
  SDFFSRX4 code_reg_1_ (.CK(clk0_14), .D(N11997), .Q(code[1]), .QN(n537), 
     .RN(N12147), .SE(test_se), .SI(code[0]), .SN(VDD));
  MXI2X1 U1306_C4_1 (.A(n621), .B(in_xrom_a_4_1), .S0(ld_operand2), .Y(N5888));
  INVX1 U902_C4_12_MP_INV (.A(n623), .Y(n623_1));
  BUFX20 BW1_BUF1627 (.A(out_idat_5_1), .Y(out_idat[5]));
  NAND2X1 U1297_C3_2 (.A(ld_idat), .B(in_idat_a[5]), .Y(N3021));
  AOI22X1 U1725_C3_7 (.A0(\in_idat_r[7] ), .A1(U947_C2__n_2), .B0(out_acc_r[7]), 
     .B1(U947_C2__n_5), .Y(op1_7_2));
  AOI21X4 U894_C2_6 (.A0(\alu_a[6] ), .A1(N7745), .B0(N2970_3), .Y(N2970_4));
  AOI21X1 U720_C2_2 (.A0(in_idat_a[2]), .A1(N7736_1), .B0(U720_C2__n), .Y(N7749));
  INVX1 U1708_C1_3_MP_INV (.A(N12117), .Y(N12117_1));
  NAND2X4 U1729_C3_9_C3_8 (.A(N10647), .B(op1_5_3), .Y(\op1[5] ));
  NOR2X1 U1722_C1_4 (.A(N3616), .B(in_xrom_a_1_1), .Y(N3100));
  AOI2BB2X1 U1516_C2_4 (.A0N(N1321_1), .A1N(N12228), .B0(\page_addr_a[0] ), 
     .B1(N8342_1), .Y(in_pc_0_1));
  INVX1 U1042_C2_2_MP_INV (.A(sel_op2[2]), .Y(sel_op2_2_1));
  INVX1 BL2_INV7 (.A(N9993_1), .Y(N9993_2));
  OAI211X1 U1508_C2_10 (.A0(N9881), .A1(N11963), .B0(in_pc_14_2), 
     .C0(in_pc_14_1), .Y(\in_pc[14] ));
  XOR2X2 U1773_C1 (.A(N11556_1), .B(N10115), .Y(U1771_C3__n_5));
  AND2X1 U1672_C1 (.A(out_acc_r[0]), .B(N327), .Y(N6055));
  INVX1 U971_C1_1_MP_INV (.A(N11342_1), .Y(N11342));
  ADDFX1 U1567 (.A(out_acc_r[5]), .B(out_pc_r_5_), .CI(add_465_carry_5_), 
     .CO(add_465_carry_6_), .S(a_plus_pc_5_));
  AOI222X1 U830_C5_6 (.A0(N9540), .A1(N11705), .B0(inc_pc2), .B1(N318), 
     .C0(out_pc_r_9_), .C1(N9736), .Y(N10922_2));
  NOR2BX1 U1666_C1 (.AN(U1666_C1__n), .B(out_pc_r_13_1), .Y(U1665_C1__n));
  XNOR2X1 U807_C1 (.A(out_pc_r_13_), .B(U1666_C1__n), .Y(N11287));
  ADDFX1 U1568 (.A(out_acc_r[6]), .B(out_pc_r_6_), .CI(add_465_carry_6_), 
     .CO(add_465_carry_7_), .S(a_plus_pc_6_));
  OAI22X1 U1732_C3_7 (.A0(N4846), .A1(N10864), .B0(n653), .B1(N10863), 
     .Y(op1_1_2));
  NOR4BX1 U1073_C1_3 (.AN(U1068_C3__n_3), .B(N10719), .C(U1068_C3__n_5), 
     .D(N12295), .Y(N7482));
  NOR2X1 U824_C2_4 (.A(n688_1), .B(N7481), .Y(n688_2));
  NAND2BX4 U1716_C1_1_C3_9 (.AN(op2_3_3), .B(N8108_2), .Y(\op2[3] ));
endmodule

// Entity:page_addr Model:page_addr Library:L0
module page_addr (pc, code, xrom, page_addr_a);
  input [4:0] pc;
  input [2:0] code;
  input [7:0] xrom;
  output [15:0] page_addr_a;
  BUFX1 BL1_ASSIGN_BUF104 (.A(pc[4]), .Y(page_addr_a[15]));
  BUFX1 BL1_ASSIGN_BUF66 (.A(code[0]), .Y(page_addr_a[8]));
  BUFX1 BL1_ASSIGN_BUF101 (.A(pc[2]), .Y(page_addr_a[13]));
  BUFX1 BL1_ASSIGN_BUF99 (.A(pc[0]), .Y(page_addr_a[11]));
  BUFX1 BL1_ASSIGN_BUF100 (.A(pc[1]), .Y(page_addr_a[12]));
  BUFX1 BL1_ASSIGN_BUF91 (.A(xrom[0]), .Y(page_addr_a[0]));
  BUFX1 BL1_ASSIGN_BUF67 (.A(code[1]), .Y(page_addr_a[9]));
  BUFX1 BL1_ASSIGN_BUF102 (.A(pc[3]), .Y(page_addr_a[14]));
  BUFX1 BL1_ASSIGN_BUF98 (.A(xrom[7]), .Y(page_addr_a[7]));
  BUFX1 BL1_ASSIGN_BUF68 (.A(code[2]), .Y(page_addr_a[10]));
  BUFX1 BL1_ASSIGN_BUF92 (.A(xrom[1]), .Y(page_addr_a[1]));
  BUFX1 BL1_ASSIGN_BUF95 (.A(xrom[4]), .Y(page_addr_a[4]));
  BUFX1 BL1_ASSIGN_BUF93 (.A(xrom[2]), .Y(page_addr_a[2]));
  BUFX1 BL1_ASSIGN_BUF96 (.A(xrom[5]), .Y(page_addr_a[5]));
  BUFX1 BL1_ASSIGN_BUF94 (.A(xrom[3]), .Y(page_addr_a[3]));
  BUFX1 BL1_ASSIGN_BUF97 (.A(xrom[6]), .Y(page_addr_a[6]));
endmodule

// Entity:pc_test_1 Model:pc_test_1 Library:L0
module pc_test_1 (clk, rst_p, ld_pc, ld_pcl, ld_pch, inc_pc, in_pc, out_pc_r, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_14);
  input clk, rst_p, ld_pc, ld_pcl, ld_pch, inc_pc, 
     rc8051RtlTop_test_point_535_in, test_si, test_se, clk0_14;
  output test_so;
  input [15:0] in_pc;
  output [15:0] out_pc_r;
  wire N15, N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, 
     N29, N30, N11323, N10574, N7417_1, N4851, N4589, N4850, N4587, N4594, 
     N4822, N11364, N7133, N4605, N2866, N5010, N4966, N4965, N10817, N4126, 
     N4599, U52_C1__n_1, U52_C1__n_2, U59_C2__n_1, N19_1, in_pc_4_1, N10015_1, 
     out_pc_r_4_1, N28_1, in_pc_13_1, N4585_1, out_pc_r_13_1, N21_1, in_pc_6_1, 
     out_pc_r_6_1, N25_1, in_pc_10_1, out_pc_r_10_1, N26_1, in_pc_11_1, 
     out_pc_r_11_1, N27_1, in_pc_12_1, out_pc_r_12_1, N16_1, in_pc_1_1, 
     out_pc_r_1_1, N22_1, in_pc_7_1, out_pc_r_7_1, N18_1, in_pc_3_1, 
     out_pc_r_3_1, N23_1, in_pc_8_1, out_pc_r_8_1, N30_1, in_pc_15_1, 
     out_pc_r_15_1, N17_1, in_pc_2_1, out_pc_r_2_1, N20_1, in_pc_5_1, 
     out_pc_r_5_1, N15_1, in_pc_0_1, out_pc_r_0_1, N29_1, in_pc_14_1, 
     out_pc_r_14_1, N24_1, in_pc_9_1, out_pc_r_9_1, U52_C1__n_3, U52_C1__n_4, 
     N4585_2, N10015_2, U59_C2__n_2;
  pc_DW01_inc_16_0 add_28 (.A({test_so, out_pc_r[14], out_pc_r[13], out_pc_r[12], 
     out_pc_r[11], out_pc_r[10], out_pc_r[9], out_pc_r[8], out_pc_r[7], 
     out_pc_r[6], out_pc_r[5], out_pc_r[4], out_pc_r[3], out_pc_r[2], 
     out_pc_r[1], out_pc_r[0]}), .SUM({N30, N29, N28, N27, N26, N25, N24, N23, 
     N22, N21, N20, N19, N18, N17, N16, N15}));
  INVX1 U67_C5_6_MP_INV_2 (.A(test_so), .Y(out_pc_r_15_1));
  BUFX8 BL3_S_BUF_1 (.A(N10015_2), .Y(N10015_1));
  INVX1 U91_C5_6_MP_INV_2 (.A(out_pc_r[1]), .Y(out_pc_r_1_1));
  INVX4 BL2_INV1 (.A(U52_C1__n_3), .Y(U52_C1__n_4));
  OAI222X1 U91_C5_6 (.A0(U52_C1__n_4), .A1(N16_1), .B0(in_pc_1_1), 
     .B1(U59_C2__n_1), .C0(N10015_1), .C1(out_pc_r_1_1), .Y(N4851));
  INVX1 U60_C1 (.A(ld_pch), .Y(N10574));
  SDFFRHQX4 out_pc_r_reg_11_ (.CK(clk0_14), .D(N4966), .Q(out_pc_r[11]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[10]));
  NOR2X2 U54_C1 (.A(ld_pc), .B(ld_pcl), .Y(U59_C2__n_2));
  INVX1 U91_C5_6_MP_INV (.A(N16), .Y(N16_1));
  AOI2BB1X2 U55_C3_1 (.A0N(ld_pcl), .A1N(N10574), .B0(ld_pc), .Y(N7417_1));
  NAND2X1 U59_C2_1 (.A(inc_pc), .B(N10574), .Y(U52_C1__n_1));
  SDFFRHQX2 out_pc_r_reg_6_ (.CK(clk0_14), .D(N7133), .Q(out_pc_r[6]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[5]));
  OAI222X1 U69_C5_6 (.A0(U52_C1__n_4), .A1(N29_1), .B0(in_pc_14_1), .B1(N7417_1), 
     .C0(N4585_1), .C1(out_pc_r_14_1), .Y(N4126));
  INVX1 U69_C5_6_MP_INV_2 (.A(out_pc_r[14]), .Y(out_pc_r_14_1));
  SDFFRHQX2 out_pc_r_reg_15_ (.CK(clk0_14), .D(N4599), .Q(test_so), .RN(N11323), 
     .SE(test_se), .SI(out_pc_r[14]));
  OAI222X1 U67_C5_6 (.A0(U52_C1__n_4), .A1(N30_1), .B0(in_pc_15_1), .B1(N7417_1), 
     .C0(N4585_1), .C1(out_pc_r_15_1), .Y(N4599));
  INVX3 U92_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N11323));
  INVX1 U69_C5_6_MP_INV (.A(N29), .Y(N29_1));
  INVX1 U67_C5_6_MP_INV_1 (.A(in_pc[15]), .Y(in_pc_15_1));
  INVX1 U69_C5_6_MP_INV_1 (.A(in_pc[14]), .Y(in_pc_14_1));
  BUFX1 BL1_ASSIGN_BUF103 (.A(test_so), .Y(out_pc_r[15]));
  INVX1 U67_C5_6_MP_INV (.A(N30), .Y(N30_1));
  INVX1 U85_C5_6_MP_INV_2 (.A(out_pc_r[7]), .Y(out_pc_r_7_1));
  INVX1 U62_C5_6_MP_INV_2 (.A(out_pc_r[6]), .Y(out_pc_r_6_1));
  OAI222X1 U62_C5_6 (.A0(U52_C1__n_4), .A1(N21_1), .B0(in_pc_6_1), 
     .B1(U59_C2__n_1), .C0(N10015_1), .C1(out_pc_r_6_1), .Y(N7133));
  OAI222X1 U85_C5_6 (.A0(U52_C1__n_4), .A1(N22_1), .B0(in_pc_7_1), 
     .B1(U59_C2__n_1), .C0(N10015_1), .C1(out_pc_r_7_1), .Y(N4850));
  INVX1 U83_C5_6_MP_INV_2 (.A(out_pc_r[8]), .Y(out_pc_r_8_1));
  INVX1 U85_C5_6_MP_INV_1 (.A(in_pc[7]), .Y(in_pc_7_1));
  SDFFRHQX4 out_pc_r_reg_9_ (.CK(clk0_14), .D(N2866), .Q(out_pc_r[9]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[8]));
  INVX1 U62_C5_6_MP_INV (.A(N21), .Y(N21_1));
  SDFFRHQX2 out_pc_r_reg_8_ (.CK(clk0_14), .D(N4605), .Q(out_pc_r[8]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[7]));
  INVX1 U83_C5_6_MP_INV (.A(N23), .Y(N23_1));
  INVX1 U83_C5_6_MP_INV_1 (.A(in_pc[8]), .Y(in_pc_8_1));
  OAI222X1 U83_C5_6 (.A0(U52_C1__n_4), .A1(N23_1), .B0(in_pc_8_1), .B1(N7417_1), 
     .C0(N4585_1), .C1(out_pc_r_8_1), .Y(N4605));
  INVX1 U87_C5_6_MP_INV_1 (.A(in_pc[5]), .Y(in_pc_5_1));
  INVX1 U64_C5_6_MP_INV_1 (.A(in_pc[4]), .Y(in_pc_4_1));
  INVX1 U71_C5_6_MP_INV_2 (.A(out_pc_r[13]), .Y(out_pc_r_13_1));
  INVX1 U71_C5_6_MP_INV (.A(N28), .Y(N28_1));
  INVX1 U64_C5_6_MP_INV_2 (.A(out_pc_r[4]), .Y(out_pc_r_4_1));
  OAI222X1 U87_C5_6 (.A0(U52_C1__n_4), .A1(N20_1), .B0(in_pc_5_1), 
     .B1(U59_C2__n_1), .C0(N10015_1), .C1(out_pc_r_5_1), .Y(N4589));
  OAI222X1 U64_C5_6 (.A0(U52_C1__n_4), .A1(N19_1), .B0(in_pc_4_1), 
     .B1(U59_C2__n_1), .C0(N10015_1), .C1(out_pc_r_4_1), .Y(N11364));
  INVX1 U64_C5_6_MP_INV (.A(N19), .Y(N19_1));
  SDFFRHQX2 out_pc_r_reg_7_ (.CK(clk0_14), .D(N4850), .Q(out_pc_r[7]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[6]));
  SDFFRHQX2 out_pc_r_reg_14_ (.CK(clk0_14), .D(N4126), .Q(out_pc_r[14]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[13]));
  INVX1 U85_C5_6_MP_INV (.A(N22), .Y(N22_1));
  INVX1 U62_C5_6_MP_INV_1 (.A(in_pc[6]), .Y(in_pc_6_1));
  INVX1 U73_C5_6_MP_INV_1 (.A(in_pc[12]), .Y(in_pc_12_1));
  INVX1 U65_C5_6_MP_INV_1 (.A(in_pc[2]), .Y(in_pc_2_1));
  NAND2X1 U52_C1 (.A(U52_C1__n_4), .B(U59_C2__n_1), .Y(N10015_2));
  INVX1 U91_C5_6_MP_INV_1 (.A(in_pc[1]), .Y(in_pc_1_1));
  INVX1 U79_C5_6_MP_INV_2 (.A(out_pc_r[10]), .Y(out_pc_r_10_1));
  INVX1 U89_C5_6_MP_INV (.A(N18), .Y(N18_1));
  OAI222X1 U89_C5_6 (.A0(U52_C1__n_4), .A1(N18_1), .B0(in_pc_3_1), 
     .B1(U59_C2__n_1), .C0(N10015_1), .C1(out_pc_r_3_1), .Y(N4822));
  INVX1 U79_C5_6_MP_INV_1 (.A(in_pc[10]), .Y(in_pc_10_1));
  INVX1 U89_C5_6_MP_INV_1 (.A(in_pc[3]), .Y(in_pc_3_1));
  SDFFRHQX4 out_pc_r_reg_5_ (.CK(clk0_14), .D(N4589), .Q(out_pc_r[5]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[4]));
  SDFFRHQX4 out_pc_r_reg_13_ (.CK(clk0_14), .D(N10817), .Q(out_pc_r[13]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[12]));
  OAI222X1 U71_C5_6 (.A0(U52_C1__n_4), .A1(N28_1), .B0(in_pc_13_1), .B1(N7417_1), 
     .C0(N4585_1), .C1(out_pc_r_13_1), .Y(N10817));
  INVX1 U77_C5_6_MP_INV_1 (.A(in_pc[0]), .Y(in_pc_0_1));
  SDFFRHQX4 out_pc_r_reg_2_ (.CK(clk0_14), .D(N4594), .Q(out_pc_r[2]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[1]));
  OAI222X1 U65_C5_6 (.A0(U52_C1__n_4), .A1(N17_1), .B0(in_pc_2_1), 
     .B1(U59_C2__n_1), .C0(N10015_1), .C1(out_pc_r_2_1), .Y(N4594));
  INVX1 U65_C5_6_MP_INV_2 (.A(out_pc_r[2]), .Y(out_pc_r_2_1));
  INVX1 U73_C5_6_MP_INV (.A(N27), .Y(N27_1));
  OAI222X1 U73_C5_6 (.A0(U52_C1__n_4), .A1(N27_1), .B0(in_pc_12_1), .B1(N7417_1), 
     .C0(N4585_1), .C1(out_pc_r_12_1), .Y(N4965));
  INVX1 U73_C5_6_MP_INV_2 (.A(out_pc_r[12]), .Y(out_pc_r_12_1));
  INVX1 U75_C5_6_MP_INV_1 (.A(in_pc[11]), .Y(in_pc_11_1));
  INVX1 U79_C5_6_MP_INV (.A(N25), .Y(N25_1));
  OAI222X1 U79_C5_6 (.A0(U52_C1__n_4), .A1(N25_1), .B0(in_pc_10_1), .B1(N7417_1), 
     .C0(N4585_1), .C1(out_pc_r_10_1), .Y(N5010));
  SDFFRHQX4 out_pc_r_reg_3_ (.CK(clk0_14), .D(N4822), .Q(out_pc_r[3]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[2]));
  INVX1 U89_C5_6_MP_INV_2 (.A(out_pc_r[3]), .Y(out_pc_r_3_1));
  SDFFRHQX4 out_pc_r_reg_0_ (.CK(clk0_14), .D(N4587), .Q(out_pc_r[0]), 
     .RN(N11323), .SE(test_se), .SI(test_si));
  INVX1 U81_C5_6_MP_INV_1 (.A(in_pc[9]), .Y(in_pc_9_1));
  OAI222X1 U81_C5_6 (.A0(U52_C1__n_4), .A1(N24_1), .B0(in_pc_9_1), .B1(N7417_1), 
     .C0(N4585_1), .C1(out_pc_r_9_1), .Y(N2866));
  INVX1 U71_C5_6_MP_INV_1 (.A(in_pc[13]), .Y(in_pc_13_1));
  INVX1 U87_C5_6_MP_INV (.A(N20), .Y(N20_1));
  INVX1 U81_C5_6_MP_INV_2 (.A(out_pc_r[9]), .Y(out_pc_r_9_1));
  INVX1 U81_C5_6_MP_INV (.A(N24), .Y(N24_1));
  INVX1 U87_C5_6_MP_INV_2 (.A(out_pc_r[5]), .Y(out_pc_r_5_1));
  SDFFRHQX4 out_pc_r_reg_4_ (.CK(clk0_14), .D(N11364), .Q(out_pc_r[4]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[3]));
  SDFFRHQX4 out_pc_r_reg_10_ (.CK(clk0_14), .D(N5010), .Q(out_pc_r[10]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[9]));
  INVX1 U65_C5_6_MP_INV (.A(N17), .Y(N17_1));
  SDFFRHQX4 out_pc_r_reg_12_ (.CK(clk0_14), .D(N4965), .Q(out_pc_r[12]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[11]));
  INVX1 U77_C5_6_MP_INV (.A(N15), .Y(N15_1));
  NAND2X1 U50_C1 (.A(U52_C1__n_4), .B(N7417_1), .Y(N4585_2));
  SDFFRHQX4 out_pc_r_reg_1_ (.CK(clk0_14), .D(N4851), .Q(out_pc_r[1]), 
     .RN(N11323), .SE(test_se), .SI(out_pc_r[0]));
  NAND2BX1 U59_C2_2 (.AN(U52_C1__n_1), .B(U59_C2__n_1), .Y(U52_C1__n_2));
  INVX1 BL2_INV0 (.A(U52_C1__n_2), .Y(U52_C1__n_3));
  OAI222X1 U75_C5_6 (.A0(U52_C1__n_4), .A1(N26_1), .B0(in_pc_11_1), .B1(N7417_1), 
     .C0(N4585_1), .C1(out_pc_r_11_1), .Y(N4966));
  BUFX8 BL3_S_BUF (.A(N4585_2), .Y(N4585_1));
  INVX1 U77_C5_6_MP_INV_2 (.A(out_pc_r[0]), .Y(out_pc_r_0_1));
  INVX1 U75_C5_6_MP_INV_2 (.A(out_pc_r[11]), .Y(out_pc_r_11_1));
  OAI222X1 U77_C5_6 (.A0(U52_C1__n_4), .A1(N15_1), .B0(in_pc_0_1), 
     .B1(U59_C2__n_1), .C0(N10015_1), .C1(out_pc_r_0_1), .Y(N4587));
  INVX1 U75_C5_6_MP_INV (.A(N26), .Y(N26_1));
  BUFX8 BL3_S_BUF_2 (.A(U59_C2__n_2), .Y(U59_C2__n_1));
endmodule

// Entity:pc_DW01_inc_16_0 Model:pc_DW01_inc_16_0 Library:L0
module pc_DW01_inc_16_0 (A, SUM);
  input [15:0] A;
  output [15:0] SUM;
  wire carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, 
     carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, 
     carry_2_;
  ADDHX1 U1_1_14 (.A(A[14]), .B(carry_14_), .CO(carry_15_), .S(SUM[14]));
  ADDHX1 U1_1_11 (.A(A[11]), .B(carry_11_), .CO(carry_12_), .S(SUM[11]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_9 (.A(A[9]), .B(carry_9_), .CO(carry_10_), .S(SUM[9]));
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDHX1 U1_1_12 (.A(A[12]), .B(carry_12_), .CO(carry_13_), .S(SUM[12]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  ADDHX1 U1_1_10 (.A(A[10]), .B(carry_10_), .CO(carry_11_), .S(SUM[10]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_13 (.A(A[13]), .B(carry_13_), .CO(carry_14_), .S(SUM[13]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_8 (.A(A[8]), .B(carry_8_), .CO(carry_9_), .S(SUM[8]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  ADDHX1 U1_1_7 (.A(A[7]), .B(carry_7_), .CO(carry_8_), .S(SUM[7]));
  XOR2X1 U5_C1 (.A(carry_15_), .B(A[15]), .Y(SUM[15]));
endmodule

// Entity:sign Model:sign Library:L0
module sign (a, b);
  input [7:0] a;
  output [15:0] b;
  BUFX1 BL1_ASSIGN_BUF79 (.A(a[5]), .Y(b[5]));
  BUFX1 BL1_ASSIGN_BUF83 (.A(a[7]), .Y(b[13]));
  BUFX1 BL1_ASSIGN_BUF74 (.A(a[0]), .Y(b[0]));
  BUFX1 BL1_ASSIGN_BUF81 (.A(a[7]), .Y(b[12]));
  BUFX1 BL1_ASSIGN_BUF84 (.A(a[7]), .Y(b[11]));
  BUFX1 BL1_ASSIGN_BUF88 (.A(a[7]), .Y(b[10]));
  BUFX1 BL1_ASSIGN_BUF86 (.A(a[7]), .Y(b[9]));
  BUFX1 BL1_ASSIGN_BUF75 (.A(a[1]), .Y(b[1]));
  BUFX1 BL1_ASSIGN_BUF78 (.A(a[4]), .Y(b[4]));
  BUFX1 BL1_ASSIGN_BUF76 (.A(a[2]), .Y(b[2]));
  BUFX1 BL1_ASSIGN_BUF89 (.A(a[7]), .Y(b[15]));
  BUFX1 BL1_ASSIGN_BUF82 (.A(a[7]), .Y(b[7]));
  BUFX1 BL1_ASSIGN_BUF87 (.A(a[7]), .Y(b[8]));
  BUFX1 BL1_ASSIGN_BUF85 (.A(a[7]), .Y(b[14]));
  BUFX1 BL1_ASSIGN_BUF80 (.A(a[6]), .Y(b[6]));
  BUFX1 BL1_ASSIGN_BUF77 (.A(a[3]), .Y(b[3]));
endmodule

// Entity:u_alu_test_1 Model:u_alu_test_1 Library:L0
module u_alu_test_1 (en_div, clk, rst_p, OP_B, OP_A, SEL, IN_C, IN_AC, ALU, CY, 
     AC, OV, IN_B, acc_chd, rc8051RtlTop_rc8051RtlTop_test_ds_1_in, 
     rc8051RtlTop_test_mode_in, rc8051RtlTop_test_point_535_in, test_si1, 
     test_so1, test_si2, test_so2, test_si3, test_so3, test_si4, test_so4, 
     test_se, clk0_26, clk0_5);
  input en_div, clk, rst_p, IN_C, IN_AC, rc8051RtlTop_rc8051RtlTop_test_ds_1_in, 
     rc8051RtlTop_test_mode_in, rc8051RtlTop_test_point_535_in, test_si1, 
     test_si2, test_si3, test_si4, test_se, clk0_26, clk0_5;
  output CY, AC, OV, test_so1, test_so2, test_so3, test_so4;
  input [7:0] OP_B;
  input [7:0] OP_A;
  input [4:0] SEL;
  output [7:0] ALU;
  output [7:0] IN_B;
  output [7:0] acc_chd;
  wire \s_SWAP[0] , \s_SWAP[1] , \s_SWAP[2] , \s_SWAP[3] , \s_SWAP[4] , 
     \s_SWAP[5] , \s_SWAP[6] , \s_SWAP[7] , \s_RRC[0] , \s_RRC[1] , \s_RRC[2] , 
     \s_RRC[3] , \s_RRC[4] , \s_RRC[5] , \s_RRC[6] , \s_RRC[7] , \s_RR[0] , 
     \s_RR[1] , \s_RR[2] , \s_RR[3] , \s_RR[4] , \s_RR[5] , \s_RR[6] , 
     \s_RR[7] , \s_RLC[0] , \s_RLC[1] , \s_RLC[2] , \s_RLC[3] , \s_RLC[4] , 
     \s_RLC[5] , \s_RLC[6] , \s_RLC[7] , \s_RL[0] , \s_RL[1] , \s_RL[2] , 
     \s_RL[3] , \s_RL[4] , \s_RL[5] , \s_RL[6] , \s_RL[7] , \s_INV[0] , 
     \s_INV[1] , \s_INV[2] , \s_INV[3] , \s_INV[4] , \s_INV[5] , \s_INV[6] , 
     \s_INV[7] , \s_XOR[0] , \s_XOR[1] , \s_XOR[2] , \s_XOR[3] , \s_XOR[4] , 
     \s_XOR[5] , \s_XOR[6] , \s_XOR[7] , \s_OR[0] , \s_OR[1] , \s_OR[2] , 
     \s_OR[3] , \s_OR[4] , \s_OR[5] , \s_OR[6] , \s_OR[7] , \s_AND[0] , 
     \s_AND[1] , \s_AND[2] , \s_AND[3] , \s_AND[4] , \s_AND[5] , \s_AND[6] , 
     \s_AND[7] , \s_DA[0] , \s_DA[1] , \s_DA[2] , \s_DA[3] , \s_DA[4] , 
     \s_DA[5] , \s_DA[6] , \s_DA[7] , \s_Q[0] , \s_Q[1] , \s_Q[2] , \s_Q[3] , 
     \s_Q[4] , \s_Q[5] , \s_Q[6] , \s_Q[7] , \s_R[0] , \s_R[1] , \s_R[2] , 
     \s_R[3] , \s_R[4] , \s_R[5] , \s_R[6] , \s_R[7] , \s_sel[0] , \s_sel[1] , 
     \s_sel[2] , \s_sel[3] , \s_M[0] , \s_M[1] , \s_M[2] , \s_M[3] , \s_M[4] , 
     \s_M[5] , \s_M[6] , \s_M[7] , \s_M[8] , \s_M[9] , \s_M[10] , \s_M[11] , 
     \s_M[12] , \s_M[13] , \s_M[14] , \s_M[15] , \oOP_B[0] , \oOP_B[1] , 
     \oOP_B[2] , \oOP_B[3] , \oOP_B[4] , \oOP_B[5] , \oOP_B[6] , \oOP_B[7] , 
     \s_ADDC[0] , \s_ADDC[1] , \s_ADDC[2] , \s_ADDC[3] , \s_ADDC[4] , 
     \s_ADDC[5] , \s_ADDC[6] , \s_ADDC[7] , \s_ram_chd[0] , \s_ram_chd[1] , 
     \s_ram_chd[2] , \s_ram_chd[3] , \s_ram_chd[4] , \s_ram_chd[5] , 
     \s_ram_chd[6] , \s_ram_chd[7] , s_CY_RRC, s_CY_RLC, enMul, n_0_net_, ocy, 
     s_AC_ADDC, s_CY_ADDC, s_OV_ADDC, n28, test_se_1, OP_B_6_1, OP_B_7_1, 
     OP_A_4_1, OP_A_0_1, OP_B_4_1, OP_A_6_1, OP_A_1_1, OP_A_3_1, OP_A_2_1, 
     OP_A_5_1, OP_B_3_1, OP_B_0_1, OP_B_1_1, OP_B_2_1;
  supply1 VDD;
  supply0 VSS;
  da U7_da (.d({OP_A[7], OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], OP_A[1], 
     OP_A[0]}), .ac(IN_AC), .cy(IN_C), .q({\s_DA[7] , \s_DA[6] , \s_DA[5] , 
     \s_DA[4] , \s_DA[3] , \s_DA[2] , \s_DA[1] , \s_DA[0] }));
  alu_flag_d_m U19_alu_flag (.al({SEL[4], SEL[3], SEL[2], SEL[1], SEL[0]}), .m({
     \s_M[15] , \s_M[14] , \s_M[13] , \s_M[12] , \s_M[11] , \s_M[10] , \s_M[9] , 
     \s_M[8] }), .r({\s_R[7] , \s_R[6] , \s_R[5] , \s_R[4] , \s_R[3] , \s_R[2] , 
     \s_R[1] , \s_R[0] }), .dividor({OP_B[7], OP_B[6], OP_B[5], OP_B[4], OP_B[3], 
     OP_B[2], OP_B[1], OP_B[0]}), .cy_addc(s_CY_ADDC), .cy_rlc(s_CY_RLC), 
     .cy_rrc(s_CY_RRC), .ac_addc(s_AC_ADDC), .ov_addc(s_OV_ADDC), .cy(CY), 
     .ac(AC), .ov(OV), .IN_B({IN_B[7], IN_B[6], IN_B[5], IN_B[4], IN_B[3], 
     IN_B[2], IN_B[1], IN_B[0]}));
  rrc U3_rrc (.d({OP_A[7], OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], OP_A[1], 
     OP_A[0]}), .in_cy(IN_C), .out_cy(s_CY_RRC), .q({\s_RRC[7] , \s_RRC[6] , 
     \s_RRC[5] , \s_RRC[4] , \s_RRC[3] , \s_RRC[2] , \s_RRC[1] , \s_RRC[0] }));
  sel_al U11_sel_al (.isel({SEL[4], SEL[3], SEL[2], SEL[1], SEL[0]}), .osel({
     \s_sel[3] , \s_sel[2] , \s_sel[1] , \s_sel[0] }));
  rlc U5_rlc (.d({OP_A[7], OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], OP_A[1], 
     OP_A[0]}), .in_cy(IN_C), .out_cy(s_CY_RLC), .q({\s_RLC[7] , \s_RLC[6] , 
     \s_RLC[5] , \s_RLC[4] , \s_RLC[3] , \s_RLC[2] , \s_RLC[1] , \s_RLC[0] }));
  xchd U_xchd (.in_acc({OP_A[7], OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], 
     OP_A[1], OP_A[0]}), .in_ram({OP_B[7], OP_B[6], OP_B[5], OP_B[4], OP_B[3], 
     OP_B[2], OP_B[1], OP_B[0]}), .out_acc({acc_chd[7], acc_chd[6], acc_chd[5], 
     acc_chd[4], acc_chd[3], acc_chd[2], acc_chd[1], acc_chd[0]}), .out_ram({
     \s_ram_chd[7] , \s_ram_chd[6] , \s_ram_chd[5] , \s_ram_chd[4] , 
     \s_ram_chd[3] , \s_ram_chd[2] , \s_ram_chd[1] , \s_ram_chd[0] }));
  adc U12_adc (.dataa({OP_A[7], OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], 
     OP_A[1], OP_A[0]}), .datab({\oOP_B[7] , \oOP_B[6] , \oOP_B[5] , \oOP_B[4] , 
     \oOP_B[3] , \oOP_B[2] , \oOP_B[1] , \oOP_B[0] }), .cin(ocy), .ac(s_AC_ADDC), 
     .cout(s_CY_ADDC), .overflow(s_OV_ADDC), .result({\s_ADDC[7] , \s_ADDC[6] , 
     \s_ADDC[5] , \s_ADDC[4] , \s_ADDC[3] , \s_ADDC[2] , \s_ADDC[1] , 
     \s_ADDC[0] }));
  DW_mult_pipe_a_width8_b_width8_num_stages5_stall_mode1_rst_mode1_test_1
  U9_DW_mult_pipe (.clk(), .rst_n(n_0_net_), .en(enMul), .tc(VSS), .a({OP_A[7], 
     OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], OP_A[1], OP_A[0]}), .b({OP_B[7], 
     OP_B[6], OP_B[5], OP_B[4], OP_B[3], OP_B[2], OP_B[1], OP_B[0]}), .product({
     \s_M[15] , \s_M[14] , \s_M[13] , \s_M[12] , \s_M[11] , \s_M[10] , \s_M[9] , 
     \s_M[8] , \s_M[7] , \s_M[6] , \s_M[5] , \s_M[4] , \s_M[3] , \s_M[2] , 
     \s_M[1] , \s_M[0] }), 
     .rc8051RtlTop_rc8051RtlTop_test_ds_1_in(rc8051RtlTop_rc8051RtlTop_test_ds_1_in), 
     .rc8051RtlTop_test_mode_in(rc8051RtlTop_test_mode_in), .test_si1(n28), 
     .test_so1(test_so2), .test_si2(test_si3), .test_so2(test_so3), 
     .test_si3(test_si4), .test_so3(test_so4), .test_se(test_se_1), 
     .clk0_26(clk0_26), .clk0_5(clk0_5));
  rr U4_rr (.d({OP_A[7], OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], OP_A[1], 
     OP_A[0]}), .q({\s_RR[7] , \s_RR[6] , \s_RR[5] , \s_RR[4] , \s_RR[3] , 
     \s_RR[2] , \s_RR[1] , \s_RR[0] }));
  div_test_1 U8_div (.clk(), .rst_p(rst_p), .Load(en_div), .Dividend({OP_A[7], 
     OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], OP_A[1], OP_A[0]}), .Divisor({
     OP_B[7], OP_B[6], OP_B[5], OP_B[4], OP_B[3], OP_B[2], OP_B[1], OP_B[0]}), 
     .Quotient({\s_Q[7] , \s_Q[6] , \s_Q[5] , \s_Q[4] , \s_Q[3] , \s_Q[2] , 
     \s_Q[1] , \s_Q[0] }), .Remainder({\s_R[7] , \s_R[6] , \s_R[5] , \s_R[4] , 
     \s_R[3] , \s_R[2] , \s_R[1] , \s_R[0] }), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si1(test_si1), .test_so1(test_so1), .test_si2(test_si2), 
     .test_so2(n28), .test_se(test_se), .clk0_5(clk0_5), .clk0_26(clk0_26));
  swap U2_swap (.d({OP_A[7], OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], 
     OP_A[1], OP_A[0]}), .q({\s_SWAP[7] , \s_SWAP[6] , \s_SWAP[5] , \s_SWAP[4] , 
     \s_SWAP[3] , \s_SWAP[2] , \s_SWAP[1] , \s_SWAP[0] }));
  sel_arth U10_sel_arth (.iop2({OP_B[7], OP_B[6], OP_B[5], OP_B[4], OP_B[3], 
     OP_B[2], OP_B[1], OP_B[0]}), .icin(IN_C), .sel({SEL[2], SEL[1], SEL[0]}), 
     .oop2({\oOP_B[7] , \oOP_B[6] , \oOP_B[5] , \oOP_B[4] , \oOP_B[3] , 
     \oOP_B[2] , \oOP_B[1] , \oOP_B[0] }), .ocin(ocy));
  BUFX1 BL2_BUF67 (.A(OP_A[6]), .Y(OP_A_6_1));
  BUFX3 BW1_BUF247_5 (.A(test_se), .Y(test_se_1));
  INVX1 U92_C1 (.A(rst_p), .Y(n_0_net_));
  XOR2X1 U71_C1 (.A(OP_B_0_1), .B(OP_A_0_1), .Y(\s_XOR[0] ));
  BUFX1 BL2_BUF55 (.A(OP_A[0]), .Y(OP_A_0_1));
  NOR2BX1 U90_C1 (.AN(OP_B_6_1), .B(\s_INV[6] ), .Y(\s_AND[6] ));
  NOR2BX1 U58_C1 (.AN(OP_B_7_1), .B(\s_INV[7] ), .Y(\s_AND[7] ));
  NAND2BX1 U56_C1 (.AN(OP_B_7_1), .B(\s_INV[7] ), .Y(\s_OR[7] ));
  XOR2X1 U78_C1 (.A(OP_B_6_1), .B(OP_A_6_1), .Y(\s_XOR[6] ));
  XOR2X1 U91_C1 (.A(OP_B_7_1), .B(OP_A[7]), .Y(\s_XOR[7] ));
  INVX1 U82_C1 (.A(OP_A_6_1), .Y(\s_INV[6] ));
  BUFX1 BL2_BUF37 (.A(OP_B[7]), .Y(OP_B_7_1));
  INVX1 U79_C1 (.A(OP_A[7]), .Y(\s_INV[7] ));
  NAND2BX1 U70_C1 (.AN(OP_B_6_1), .B(\s_INV[6] ), .Y(\s_OR[6] ));
  BUFX1 BL2_BUF32 (.A(OP_B[6]), .Y(OP_B_6_1));
  NOR2BX1 U52_C1 (.AN(OP_B_3_1), .B(\s_INV[3] ), .Y(\s_AND[3] ));
  NAND2BX1 U55_C1 (.AN(OP_B_3_1), .B(\s_INV[3] ), .Y(\s_OR[3] ));
  XOR2X1 U74_C1 (.A(OP_B_4_1), .B(OP_A_4_1), .Y(\s_XOR[4] ));
  XOR2X1 U72_C1 (.A(OP_B[5]), .B(OP_A_5_1), .Y(\s_XOR[5] ));
  BUFX1 BL2_BUF104 (.A(OP_A[5]), .Y(OP_A_5_1));
  NOR2BX1 U89_C1 (.AN(OP_B[5]), .B(\s_INV[5] ), .Y(\s_AND[5] ));
  INVX1 U75_C1 (.A(OP_A_5_1), .Y(\s_INV[5] ));
  BUFX1 BL2_BUF110 (.A(OP_B[1]), .Y(OP_B_1_1));
  NAND2BX1 U63_C1 (.AN(OP_B_0_1), .B(\s_INV[0] ), .Y(\s_OR[0] ));
  NOR2BX1 U59_C1 (.AN(OP_B_0_1), .B(\s_INV[0] ), .Y(\s_AND[0] ));
  INVX1 U77_C1 (.A(OP_A_0_1), .Y(\s_INV[0] ));
  BUFX1 BL2_BUF108 (.A(OP_B[0]), .Y(OP_B_0_1));
  BUFX1 BL2_BUF44 (.A(OP_A[4]), .Y(OP_A_4_1));
  NAND2BX1 U60_C1 (.AN(OP_B_2_1), .B(\s_INV[2] ), .Y(\s_OR[2] ));
  INVX1 U46_C1 (.A(OP_A_3_1), .Y(\s_INV[3] ));
  XOR2X1 U73_C1 (.A(OP_B_3_1), .B(OP_A_3_1), .Y(\s_XOR[3] ));
  BUFX1 BL2_BUF106 (.A(OP_B[3]), .Y(OP_B_3_1));
  BUFX1 BL2_BUF89 (.A(OP_A[3]), .Y(OP_A_3_1));
  NAND2BX1 U64_C1 (.AN(OP_B_1_1), .B(\s_INV[1] ), .Y(\s_OR[1] ));
  BUFX1 BL2_BUF95 (.A(OP_A[2]), .Y(OP_A_2_1));
  BUFX1 BL2_BUF114 (.A(OP_B[2]), .Y(OP_B_2_1));
  NOR2BX1 U61_C1 (.AN(OP_B_1_1), .B(\s_INV[1] ), .Y(\s_AND[1] ));
  INVX1 U76_C1 (.A(OP_A_2_1), .Y(\s_INV[2] ));
  BUFX1 BL2_BUF66 (.A(OP_B[4]), .Y(OP_B_4_1));
  mux16t1_8 U18_sel_alu (.a0({\s_ADDC[7] , \s_ADDC[6] , \s_ADDC[5] , \s_ADDC[4] , 
     \s_ADDC[3] , \s_ADDC[2] , \s_ADDC[1] , \s_ADDC[0] }), .a1({\s_M[7] , 
     \s_M[6] , \s_M[5] , \s_M[4] , \s_M[3] , \s_M[2] , \s_M[1] , \s_M[0] }), 
     .a2({\s_Q[7] , \s_Q[6] , \s_Q[5] , \s_Q[4] , \s_Q[3] , \s_Q[2] , \s_Q[1] , 
     \s_Q[0] }), .a3({\s_DA[7] , \s_DA[6] , \s_DA[5] , \s_DA[4] , \s_DA[3] , 
     \s_DA[2] , \s_DA[1] , \s_DA[0] }), .a4({\s_AND[7] , \s_AND[6] , \s_AND[5] , 
     \s_AND[4] , \s_AND[3] , \s_AND[2] , \s_AND[1] , \s_AND[0] }), .a5({\s_OR[7] , 
     \s_OR[6] , \s_OR[5] , \s_OR[4] , \s_OR[3] , \s_OR[2] , \s_OR[1] , 
     \s_OR[0] }), .a6({\s_XOR[7] , \s_XOR[6] , \s_XOR[5] , \s_XOR[4] , \s_XOR[3] , 
     \s_XOR[2] , \s_XOR[1] , \s_XOR[0] }), .a7({VSS, VSS, VSS, VSS, VSS, VSS, VSS, 
     VSS}), .a8({\s_INV[7] , \s_INV[6] , \s_INV[5] , \s_INV[4] , \s_INV[3] , 
     \s_INV[2] , \s_INV[1] , \s_INV[0] }), .a9({\s_RL[7] , \s_RL[6] , \s_RL[5] , 
     \s_RL[4] , \s_RL[3] , \s_RL[2] , \s_RL[1] , \s_RL[0] }), .b0({\s_RLC[7] , 
     \s_RLC[6] , \s_RLC[5] , \s_RLC[4] , \s_RLC[3] , \s_RLC[2] , \s_RLC[1] , 
     \s_RLC[0] }), .b1({\s_RR[7] , \s_RR[6] , \s_RR[5] , \s_RR[4] , \s_RR[3] , 
     \s_RR[2] , \s_RR[1] , \s_RR[0] }), .b2({\s_RRC[7] , \s_RRC[6] , \s_RRC[5] , 
     \s_RRC[4] , \s_RRC[3] , \s_RRC[2] , \s_RRC[1] , \s_RRC[0] }), .b3({
     \s_SWAP[7] , \s_SWAP[6] , \s_SWAP[5] , \s_SWAP[4] , \s_SWAP[3] , 
     \s_SWAP[2] , \s_SWAP[1] , \s_SWAP[0] }), .b4({VDD, VDD, VDD, VDD, VDD, VDD, 
     VDD, VDD}), .b5({\s_ram_chd[7] , \s_ram_chd[6] , \s_ram_chd[5] , 
     \s_ram_chd[4] , \s_ram_chd[3] , \s_ram_chd[2] , \s_ram_chd[1] , 
     \s_ram_chd[0] }), .sel({\s_sel[3] , \s_sel[2] , \s_sel[1] , \s_sel[0] }), 
     .qq({ALU[7], ALU[6], ALU[5], ALU[4], ALU[3], ALU[2], ALU[1], ALU[0]}));
  rl U6_rl (.d({OP_A[7], OP_A[6], OP_A[5], OP_A[4], OP_A[3], OP_A[2], OP_A[1], 
     OP_A[0]}), .q({\s_RL[7] , \s_RL[6] , \s_RL[5] , \s_RL[4] , \s_RL[3] , 
     \s_RL[2] , \s_RL[1] , \s_RL[0] }));
  BUFX1 BL2_BUF78 (.A(OP_A[1]), .Y(OP_A_1_1));
  INVX1 U87_C1 (.A(OP_A_1_1), .Y(\s_INV[1] ));
  XOR2X1 U86_C1 (.A(OP_B_1_1), .B(OP_A_1_1), .Y(\s_XOR[1] ));
  NAND2BX1 U88_C1 (.AN(OP_B[5]), .B(\s_INV[5] ), .Y(\s_OR[5] ));
  NAND2BX1 U65_C1 (.AN(OP_B_4_1), .B(\s_INV[4] ), .Y(\s_OR[4] ));
  NOR2BX1 U62_C1 (.AN(OP_B_4_1), .B(\s_INV[4] ), .Y(\s_AND[4] ));
  INVX1 U81_C1 (.A(OP_A_4_1), .Y(\s_INV[4] ));
  NOR4BX1 U54_C3_3 (.AN(\s_sel[0] ), .B(\s_sel[3] ), .C(\s_sel[2] ), 
     .D(\s_sel[1] ), .Y(enMul));
  XOR2X1 U85_C1 (.A(OP_B_2_1), .B(OP_A_2_1), .Y(\s_XOR[2] ));
  NOR2BX1 U69_C1 (.AN(OP_B_2_1), .B(\s_INV[2] ), .Y(\s_AND[2] ));
endmodule

// Entity:DW_mult_pipe_a_width8_b_width8_num_stages5_stall_mode1_rst_mode1_test_1 Model:DW_mult_pipe_a_width8_b_width8_num_stages5_stall_mode1_rst_mode1_test_1 Library:L0
module DW_mult_pipe_a_width8_b_width8_num_stages5_stall_mode1_rst_mode1_test_1 (
     clk, rst_n, en, tc, a, b, product, rc8051RtlTop_rc8051RtlTop_test_ds_1_in, 
     rc8051RtlTop_test_mode_in, test_si1, test_so1, test_si2, test_so2, 
     test_si3, test_so3, test_se, clk0_26, clk0_5);
  input clk, rst_n, en, tc, rc8051RtlTop_rc8051RtlTop_test_ds_1_in, 
     rc8051RtlTop_test_mode_in, test_si1, test_si2, test_si3, test_se, clk0_26, 
     clk0_5;
  output test_so1, test_so2, test_so3;
  input [7:0] a;
  input [7:0] b;
  output [15:0] product;
  wire n1490, n1491, n1037, n1038, n1039, n1040, n1041, n1042, n1043, n1044, 
     n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052, n1055, n1056, 
     n1057, n1058, n1060, n1061, n1062, n1063, n1064, n1065, n1066, n1067, 
     n1068, n1069, n1070, n1071, n1072, n1073, n1074, n1075, n1076, n1077, 
     n1078, n1079, n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087, 
     n1088, n1089, n1090, n1091, n1092, n1093, n1094, n1095, n1096, n1097, 
     n1098, n1099, n1100, n1101, n1102, n1103, n1421, n1422, n1423, n1424, 
     n1425, n1426, n1427, n1428, n1429, n1430, n1431, n1432, n1434, n1435, 
     n1448, U_MULT_SUMB, U_MULT_SUMB0, U_MULT_SUMB1, U_MULT_SUMB2, U_MULT_SUMB3, 
     U_MULT_SUMB4, U_MULT_SUMB5, U_MULT_SUMB6, U_MULT_SUMB7, U_MULT_SUMB8, 
     U_MULT_SUMB9, U_MULT_SUMB10, U_MULT_SUMB11, U_MULT_SUMB12, U_MULT_SUMB13, 
     U_MULT_SUMB14, U_MULT_SUMB15, U_MULT_SUMB16, U_MULT_SUMB17, U_MULT_SUMB18, 
     U_MULT_SUMB19, U_MULT_SUMB20, U_MULT_SUMB21, U_MULT_SUMB22, U_MULT_SUMB23, 
     U_MULT_SUMB24, U_MULT_SUMB25, U_MULT_SUMB26, U_MULT_SUMB27, U_MULT_SUMB28, 
     U_MULT_SUMB29, U_MULT_SUMB30, U_MULT_SUMB31, U_MULT_SUMB32, U_MULT_SUMB33, 
     U_MULT_SUMB34, U_MULT_SUMB35, U_MULT_SUMB36, U_MULT_CARRYB, U_MULT_CARRYB0, 
     U_MULT_CARRYB1, U_MULT_CARRYB2, U_MULT_CARRYB3, U_MULT_CARRYB4, 
     U_MULT_CARRYB5, U_MULT_CARRYB6, U_MULT_CARRYB7, U_MULT_CARRYB8, 
     U_MULT_CARRYB9, U_MULT_CARRYB10, U_MULT_CARRYB11, U_MULT_CARRYB12, 
     U_MULT_CARRYB13, U_MULT_CARRYB14, U_MULT_CARRYB15, U_MULT_CARRYB16, 
     U_MULT_CARRYB17, U_MULT_CARRYB18, U_MULT_CARRYB19, U_MULT_CARRYB20, 
     U_MULT_CARRYB21, U_MULT_CARRYB22, U_MULT_CARRYB23, U_MULT_CARRYB24, 
     U_MULT_CARRYB25, U_MULT_CARRYB26, U_MULT_CARRYB27, U_MULT_CARRYB28, 
     U_MULT_CARRYB29, U_MULT_CARRYB30, U_MULT_CARRYB31, U_MULT_CARRYB32, 
     U_MULT_CARRYB33, U_MULT_CARRYB34, U_MULT_CARRYB35, U_MULT_CARRYB36, 
     U_MULT_CARRYB37, U_MULT_CARRYB38, U_MULT_CARRYB39, U_MULT_CARRYB40, 
     U_MULT_CARRYB41, U_MULT_CLA_SUM_7_, U_MULT_CLA_SUM_6_, U_MULT_CLA_SUM_4_, 
     U_MULT_CLA_SUM_3_, U_MULT_CLA_CARRY_7_, n3, n4, n5, n6, n7, n8, n9, n10, 
     n11, n12, n13, n14, n15, n16, n17, n18, n20, n21, n22, n23, n24, n25, n26, 
     n27, n28, n29, n30, n31, n32, n33, n34, n35, N10276, N10280, N5768, N5644, 
     N11737, N11736, N11735, N8161, N5643, N11148, N11147, N11146, N5823, N5645, 
     N10233, N5648, N10232, N11145, N5639, N11809, N5753, N12167, U291_C1__n, 
     U290_C1__n, U288_C1__n, U278_C2__n, U278_C2__n_1, U278_C2__n_2, 
     U278_C2__n_3, U275_C2__n, U275_C2__n_1, U275_C2__n_2, U292_C1__n, 
     U285_C2__n, U285_C2__n_1, N11124, N11123, N11122, N11121, N12245, N5755, 
     N12198, N5676, N12186, N12185, N12184, N12183, N12197, N5754, N11453, 
     N5677, clk_r_REG25_S2_syn40_C3__n, N11454, N11452, N5773, U300_C1__n, 
     U293_C1__n, U289_C1__n, U273_C2__n, U280_C2__n, U280_C2__n_1, U280_C2__n_2, 
     N5692, N11357, N11356, U276_C2__n, U276_C2__n_1, U276_C2__n_2, N12313, 
     N12312, N5774, N5694, N11379, N11378, N11377, N5693, N12293, N12292, 
     N12291, N12290, N5772, N5698, N10304, N5356, N5104, N5697, N10525, N10524, 
     N10523, N10522, N5771, N5700, N10654, N10653, N10652, N5699, N10529, 
     N10528, N10527, N10526, N5778, N5684, N12327, N12326, N12325, N5682, 
     N11101, N11100, N11099, N11098, N5777, N5688, N10620, N10619, N5687, 
     N11105, N11104, N11103, N11102, N5776, N5690, N5824, N11428, N10594, 
     N10593, N10592, N5689, N12308, N12307, N12306, N12305, N5683, N5705, 
     N10433, N10432, N10512, N10511, N10510, U549_C1__n, U549_C1__n_1, N11222, 
     N5672, N11730, N11729, N11728, N11727, N11221, N5758, N10564, N5673, 
     N11120, U539_C1__n, U539_C1__n_1, N11117, N10563, N5760, N11175, N5671, 
     U545_C1__n, U545_C1__n_1, N11724, N11723, N11174, N5669, N11238, N5780, 
     N5782, N5516, U543_C1__n, U543_C1__n_1, N5729, N10267, N5825, N10513, 
     N5667, N5734, N12024, N12023, N5733, N10057, N10056, N10266, N10265, 
     N10264, N5653, N5730, N10954, N10953, N5728, N10952, N5727, N5732, N10410, 
     N5647, N8419, N4119, N9669, N4125, N4133, N8493, N12178, N8460, N6802, 
     N11133, N7549, N1558, N10808, N2265, N2094, N11813, N9939, N1272, N2735, 
     N251, N11235, N9241, N11424, N5689_1, N5692_1, N11357_1, N11124_1, 
     U276_C2__n_4, rst_n_1, U278_C2__n_4, N11102_1, n1448_1, en_1, N11737_1, 
     en_2, a_0_1, a_1_1, b_2_1, N11737_2, test_se_1, en_3, en_4, en_5;
  ADDFX1 U_MULT_S3_3_6 (.A(N5705), .B(U_MULT_CARRYB35), .CI(N10433), 
     .CO(U_MULT_CARRYB28), .S(U_MULT_SUMB25));
  NOR2X1 U331_C1 (.A(n1066), .B(n1062), .Y(U543_C1__n));
  NOR2X1 U340_C1 (.A(n1067), .B(n1063), .Y(N5671));
  SDFFRX1 clk_r_REG18_S4 (.CK(clk0_26), .D(N5755), .Q(product[11]), .QN(n1049), 
     .RN(N11737_2), .SE(test_se), .SI(n24));
  ADDFX1 U_MULT_S3_5_6 (.A(N12307), .B(U_MULT_CARRYB21), .CI(N12306), 
     .CO(U_MULT_CARRYB14), .S(U_MULT_SUMB13));
  SDFFRX1 clk_r_REG61_S1 (.CK(clk0_5), .D(N10526), .Q(n1434), .QN(n1070), 
     .RN(N11737_2), .SE(test_se_1), .SI(test_si3));
  OAI21X1 clk_r_REG62_S1_syn40_C3_1 (.A0(n1071), .A1(en_4), .B0(N12178), 
     .Y(N10527));
  MXI2X1 U373_C4_1 (.A(N5689_1), .B(N10592), .S0(n1434), .Y(N12308));
  SDFFRX1 clk_r_REG1_S2 (.CK(clk0_5), .D(N11809), .Q(n35), .QN(n1093), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1421));
  XOR2X1 U556_C1 (.A(U_MULT_SUMB2), .B(U_MULT_CARRYB3), .Y(U292_C1__n));
  NAND3X1 U292_C1_2 (.A(U_MULT_SUMB3), .B(U_MULT_CARRYB4), .C(U292_C1__n), 
     .Y(U285_C2__n));
  NAND2X1 clk_r_REG55_S1_syn40_C3_3 (.A(en_4), .B(b[7]), .Y(N2265));
  SDFFRX1 clk_r_REG25_S2 (.CK(clk0_26), .D(N11454), .Q(n18), .QN(n1085), 
     .RN(N11737_2), .SE(test_se), .SI(test_si2));
  SDFFRX1 clk_r_REG27_S4 (.CK(clk0_26), .D(N5773), .Q(product[8]), .QN(n1046), 
     .RN(N11737_2), .SE(test_se), .SI(n17));
  SDFFRX1 clk_r_REG13_S2 (.CK(clk0_5), .D(N11378), .Q(n27), .QN(n1083), 
     .RN(N11737_2), .SE(test_se), .SI(product[14]));
  NOR2X1 U383_C1 (.A(test_so3), .B(n1448), .Y(N5687));
  INVX1 U280_C2_1_MP_INV (.A(N11357_1), .Y(N11357));
  INVX1 U275_C2_1_MP_INV (.A(N11124_1), .Y(N11124));
  NAND2BX1 U273_C2 (.AN(U285_C2__n_1), .B(N11124_1), .Y(U273_C2__n));
  MXI2X1 clk_r_REG16_S2_syn40_C3_1 (.A(n1091), .B(N11122), .S0(en_5), .Y(N11121));
  MXI2X1 clk_r_REG17_S3_syn40_C3_1 (.A(n1090), .B(n1091), .S0(en_5), .Y(N12245));
  MXI2X1 clk_r_REG18_S4_syn40_C3_1 (.A(n1049), .B(n1090), .S0(en_5), .Y(N5755));
  MXI2X1 clk_r_REG9_S4_syn40_C3_1 (.A(n1043), .B(n1078), .S0(en_5), .Y(N5697));
  SDFFRX1 clk_r_REG19_S2 (.CK(clk0_5), .D(N12186), .Q(n23), .QN(n1089), 
     .RN(N11737_2), .SE(test_se), .SI(product[11]));
  INVX1 BW1_INV11737 (.A(N11737), .Y(N11737_1));
  SDFFRX1 clk_r_REG22_S2 (.CK(clk0_26), .D(N5754), .Q(n21), .QN(n1087), 
     .RN(N11737_2), .SE(test_se), .SI(product[10]));
  XOR2X1 U550_C1 (.A(U_MULT_SUMB5), .B(U_MULT_CARRYB6), .Y(U288_C1__n));
  NAND3X1 U291_C1_2 (.A(U_MULT_SUMB4), .B(U_MULT_CARRYB5), .C(U291_C1__n), 
     .Y(U275_C2__n_2));
  MXI2X1 clk_r_REG3_S4_syn40_C3_1 (.A(n1050), .B(n1092), .S0(en_4), .Y(N12167));
  NAND3X1 U290_C1_2 (.A(U_MULT_SUMB5), .B(U_MULT_CARRYB6), .C(U290_C1__n), 
     .Y(U278_C2__n_2));
  SDFFRX1 clk_r_REG3_S4 (.CK(clk0_5), .D(N12167), .Q(product[0]), .QN(n1050), 
     .RN(N11737_2), .SE(test_se_1), .SI(n34));
  OAI21X1 clk_r_REG28_S2_syn40_C3_1 (.A0(n1101), .A1(en_5), .B0(N11813), 
     .Y(N8161));
  NOR2X1 U286_C1 (.A(U276_C2__n_2), .B(U276_C2__n_4), .Y(N12293));
  NOR2X1 U382_C1 (.A(n1448), .B(n1428), .Y(N11105));
  ADDFX1 U_MULT_S14_7 (.A(N5687), .B(N11105), .CI(N11104), .CO(U_MULT_CARRYB), 
     .S(U_MULT_SUMB));
  XOR2X1 U381_C1 (.A(n1448), .B(U_MULT_CARRYB), .Y(N12312));
  NOR2BX1 U281_C2 (.AN(U278_C2__n_2), .B(U278_C2__n), .Y(N12183));
  INVX1 clk_r_REG64_S1_MP_INV (.A(n1448_1), .Y(n1448));
  NAND2X1 clk_r_REG43_S2_syn40_C3_2 (.A(n1491), .B(en_3), .Y(N9241));
  BUFX8 BW2_BUF1890 (.A(en_3), .Y(en_4));
  NOR2X1 U315_C1 (.A(n1068), .B(n1058), .Y(N10264));
  ADDFX1 U_MULT_S1_4_0 (.A(N10056), .B(U_MULT_CARRYB34), .CI(U_MULT_SUMB30), 
     .CO(U_MULT_CARRYB27), .S(U_MULT_CLA_SUM_4_));
  SDFFRX1 clk_r_REG57_S1 (.CK(clk0_5), .D(N12326), .Q(n1430), .QN(n1066), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1429));
  NOR2X1 U342_C1 (.A(n1068), .B(n1063), .Y(N5673));
  NOR2X1 U355_C1 (.A(n1067), .B(n1065), .Y(N10510));
  ADDFX1 U_MULT_S2_3_3 (.A(N5730), .B(U_MULT_CARRYB38), .CI(U_MULT_SUMB33), 
     .CO(U_MULT_CARRYB31), .S(U_MULT_SUMB28));
  NOR2X1 U372_C1 (.A(n1071), .B(n1065), .Y(N10593));
  MXI2X1 U375_C4_1 (.A(N11102_1), .B(N11103), .S0(n1425), .Y(N11428));
  NAND3X1 clk_r_REG1_S2_syn40_C3_5 (.A(n1429), .B(n1421), .C(en_4), .Y(N10808));
  AOI21X1 U297_C1_1 (.A0(U_MULT_SUMB4), .A1(U_MULT_CARRYB5), .B0(U291_C1__n), 
     .Y(U275_C2__n_1));
  SDFFRX1 clk_r_REG47_S3 (.CK(clk0_5), .D(N11736), .Q(n3), .QN(n1102), 
     .RN(N11737_2), .SE(test_se_1), .SI(n4));
  SDFFRX1 clk_r_REG45_S4 (.CK(clk0_5), .D(N10653), .Q(product[2]), .QN(n1041), 
     .RN(N11737_2), .SE(test_se_1), .SI(n5));
  MXI2X1 clk_r_REG42_S4_syn40_C3_1 (.A(n1052), .B(n1094), .S0(en_3), .Y(N5639));
  MXI2X1 clk_r_REG44_S3_syn40_C3_1 (.A(n1074), .B(n1075), .S0(en_3), .Y(N10654));
  SDFFRX1 clk_r_REG39_S4 (.CK(clk0_5), .D(N5648), .Q(product[4]), .QN(n1038), 
     .RN(N11737_2), .SE(test_se_1), .SI(n9));
  NAND2X1 clk_r_REG59_S1_syn40_C3_3 (.A(en_4), .B(a[3]), .Y(N2094));
  XOR2X1 U542_C1 (.A(U543_C1__n_1), .B(U543_C1__n), .Y(N5667));
  NOR2X1 U328_C1 (.A(n1062), .B(n1057), .Y(N5760));
  NOR2X1 U337_C1 (.A(n1067), .B(n1061), .Y(N5825));
  NOR2X1 U336_C1 (.A(n1066), .B(n1061), .Y(N10563));
  ADDFX1 U_MULT_S2_2_1 (.A(N11120), .B(N11117), .CI(N11175), 
     .CO(U_MULT_CARRYB40), .S(U_MULT_SUMB36));
  OAI21X1 clk_r_REG57_S1_syn40_C3_1 (.A0(n1066), .A1(en_3), .B0(N1272), 
     .Y(N12326));
  OAI21X1 clk_r_REG34_S2_syn40_C3_1 (.A0(n1073), .A1(en_4), .B0(N11133), 
     .Y(N10652));
  OAI21X1 clk_r_REG56_S1_syn40_C3_1 (.A0(n1057), .A1(en_4), .B0(N9669), 
     .Y(N12325));
  ADDFX1 U_MULT_S2_5_2 (.A(N10266), .B(U_MULT_CARRYB25), .CI(U_MULT_SUMB22), 
     .CO(U_MULT_CARRYB18), .S(U_MULT_SUMB17));
  ADDFX1 U_MULT_S2_5_3 (.A(N5732), .B(U_MULT_CARRYB24), .CI(U_MULT_SUMB21), 
     .CO(U_MULT_CARRYB17), .S(U_MULT_SUMB16));
  ADDFX1 U_MULT_S2_4_5 (.A(N5758), .B(U_MULT_CARRYB29), .CI(U_MULT_SUMB25), 
     .CO(U_MULT_CARRYB22), .S(U_MULT_SUMB20));
  NAND2X1 clk_r_REG34_S2_syn40_C3_2 (.A(n1490), .B(en_4), .Y(N11133));
  OAI21X1 clk_r_REG60_S1_syn40_C3_1 (.A0(n1069), .A1(en_4), .B0(N4119), 
     .Y(N5778));
  OAI21X1 clk_r_REG49_S1_syn40_C3_1 (.A0(n1060), .A1(en_4), .B0(N2735), 
     .Y(N5688));
  NAND2X1 clk_r_REG56_S1_syn40_C3_3 (.A(en_4), .B(a_0_1), .Y(N9669));
  ADDFX1 U_MULT_S2_2_4 (.A(N5671), .B(N11724), .CI(N5669), .CO(U_MULT_CARRYB37), 
     .S(U_MULT_SUMB33));
  NOR2X1 U306_C1 (.A(n1069), .B(n1063), .Y(N10410));
  ADDFX1 U_MULT_S2_4_3 (.A(N10564), .B(U_MULT_CARRYB31), .CI(U_MULT_SUMB27), 
     .CO(U_MULT_CARRYB24), .S(U_MULT_SUMB22));
  NAND2X1 clk_r_REG63_S1_syn40_C3_3 (.A(en_4), .B(a[7]), .Y(N1558));
  SDFFRX1 clk_r_REG30_S4 (.CK(clk0_5), .D(N11148), .Q(product[7]), .QN(n1040), 
     .RN(N11737_2), .SE(test_se_1), .SI(n15));
  AND2X1 U278_C2_1 (.A(U278_C2__n_3), .B(U278_C2__n_2), .Y(U275_C2__n));
  MXI2X1 clk_r_REG29_S3_syn40_C3_1 (.A(n1100), .B(n1101), .S0(en_5), .Y(N5643));
  OAI21X1 U280_C2_1 (.A0(U280_C2__n_1), .A1(U280_C2__n), .B0(U280_C2__n_2), 
     .Y(N11357_1));
  NOR2BX1 U284_C2 (.AN(U275_C2__n_2), .B(U275_C2__n_1), .Y(N12198));
  NOR2X1 U370_C1 (.A(n1070), .B(n1065), .Y(N12307));
  NOR2X1 U347_C1 (.A(n1071), .B(n1062), .Y(N11728));
  NAND2X1 clk_r_REG31_S2_syn40_C3_2 (.A(en_4), .B(U_MULT_CLA_SUM_6_), .Y(N4125));
  ADDFX1 U_MULT_S2_6_2 (.A(N5727), .B(U_MULT_CARRYB18), .CI(U_MULT_SUMB16), 
     .CO(U_MULT_CARRYB11), .S(U_MULT_SUMB11));
  NAND2X1 clk_r_REG52_S1_syn40_C3_3 (.A(en_4), .B(b[4]), .Y(N8419));
  NAND2X1 clk_r_REG49_S1_syn40_C3_3 (.A(en_4), .B(b[1]), .Y(N2735));
  SDFFRX1 clk_r_REG48_S4 (.CK(clk0_5), .D(N11735), .Q(product[1]), .QN(n1037), 
     .RN(N11737_2), .SE(test_se_1), .SI(n3));
  NOR2X1 U338_C1 (.A(n1067), .B(n1062), .Y(N5516));
  NOR2X1 U324_C1 (.A(n1063), .B(n1057), .Y(U543_C1__n_1));
  AND2X1 U545_C1 (.A(U545_C1__n_1), .B(U545_C1__n), .Y(N11724));
  OAI21X1 clk_r_REG53_S1_syn40_C3_1 (.A0(n1064), .A1(en_4), .B0(N11424), 
     .Y(N11100));
  MXI2X1 clk_r_REG32_S3_syn40_C3_1 (.A(n1098), .B(n1099), .S0(en_4), .Y(N11146));
  MXI2X1 U374_C4_1 (.A(N11102_1), .B(N11103), .S0(n1423), .Y(N10594));
  MXI2X1 U378_C4_1 (.A(N11102_1), .B(N11103), .S0(n1421), .Y(N5776));
  MXI2X1 clk_r_REG4_S2_syn40_C3_1 (.A(n1077), .B(N10524), .S0(en_5), .Y(N10523));
  ADDFX1 U_MULT_S4_3 (.A(N5690), .B(U_MULT_CARRYB10), .CI(U_MULT_SUMB9), 
     .CO(U_MULT_CARRYB3), .S(U_MULT_SUMB3));
  ADDFX1 U_MULT_S4_5 (.A(N5824), .B(U_MULT_CARRYB8), .CI(U_MULT_SUMB7), 
     .CO(U_MULT_CARRYB1), .S(U_MULT_SUMB1));
  AOI21X1 U296_C1_1 (.A0(U_MULT_SUMB3), .A1(U_MULT_CARRYB4), .B0(U292_C1__n), 
     .Y(U285_C2__n_1));
  MXI2X1 clk_r_REG23_S3_syn40_C3_1 (.A(n1086), .B(n1087), .S0(en_5), .Y(N11453));
  SDFFRX1 clk_r_REG23_S3 (.CK(clk0_26), .D(N11453), .Q(n20), .QN(n1086), 
     .RN(N11737_1), .SE(test_se), .SI(n21));
  MXI2X1 clk_r_REG27_S4_syn40_C3_1 (.A(n1046), .B(n1084), .S0(en_5), .Y(N5773));
  SDFFRX1 clk_r_REG6_S4 (.CK(clk0_5), .D(N5771), .Q(product[12]), .QN(n1042), 
     .RN(N11737_2), .SE(test_se), .SI(n32));
  NAND2X1 U380_C1 (.A(U_MULT_SUMB), .B(U_MULT_CARRYB0), .Y(N12313));
  AND2X1 U273_C2_1 (.A(U285_C2__n), .B(U273_C2__n), .Y(U280_C2__n_1));
  NOR2BX1 U283_C2 (.AN(N11356), .B(N5692), .Y(N5698));
  INVX1 U271_C2_1_MP_INV (.A(N5692), .Y(N5692_1));
  SDFFRX1 clk_r_REG14_S3 (.CK(clk0_5), .D(N11377), .Q(n26), .QN(n1082), 
     .RN(N11737_2), .SE(test_se), .SI(n27));
  MXI2X1 clk_r_REG19_S2_syn40_C3_1 (.A(n1089), .B(N5676), .S0(en_5), .Y(N12186));
  XNOR2X1 U353_C1 (.A(U276_C2__n), .B(N12293), .Y(N12292));
  MXI2X1 clk_r_REG20_S3_syn40_C3_1 (.A(n1088), .B(n1089), .S0(en_5), .Y(N12185));
  MXI2X1 clk_r_REG12_S4_syn40_C3_1 (.A(n1044), .B(n1080), .S0(en_5), .Y(N5772));
  INVX1 \test_point_534/U6_C4_1_MP_INV  (.A(rst_n), .Y(rst_n_1));
  MXI2X1 clk_r_REG22_S2_syn40_C3_1 (.A(n1087), .B(N12197), .S0(en_5), .Y(N5754));
  ADDFX1 U_MULT_S5_6 (.A(N10432), .B(U_MULT_CARRYB7), .CI(N10512), 
     .CO(U_MULT_CARRYB0), .S(U_MULT_SUMB0));
  XOR2X1 U552_C1 (.A(U_MULT_SUMB4), .B(U_MULT_CARRYB5), .Y(U290_C1__n));
  NAND2X1 U247_C1 (.A(test_so3), .B(n1448), .Y(N11103));
  NOR2BX1 U246_C1 (.AN(test_so3), .B(n1448), .Y(N11102));
  XOR2X1 U558_C1 (.A(U_MULT_SUMB1), .B(U_MULT_CARRYB2), .Y(U289_C1__n));
  DFFRHQX1 clk_r_REG64_S1 (.CK(clk0_5), .D(N10619), .Q(n1448_1), .RN(rst_n));
  SDFFRX1 clk_r_REG8_S3 (.CK(clk0_5), .D(N5104), .Q(n30), .QN(n1078), 
     .RN(N11737_2), .SE(test_se), .SI(n31));
  XOR2X1 U362_C1 (.A(U275_C2__n), .B(N12198), .Y(N5676));
  NOR2BX1 U244_C1 (.AN(test_so3), .B(n1055), .Y(N11104));
  SDFFRX1 clk_r_REG5_S3 (.CK(clk0_5), .D(N10522), .Q(n32), .QN(n1076), 
     .RN(N11737_2), .SE(test_se), .SI(n33));
  MXI2X1 clk_r_REG7_S2_syn40_C3_1 (.A(n1079), .B(N10304), .S0(en_5), .Y(N5356));
  NOR2X1 U503_C1 (.A(n1448), .B(en_5), .Y(N10619));
  XNOR2X1 U245_C1 (.A(N10280), .B(N10276), .Y(N5768));
  NOR2X1 U311_C1 (.A(n1067), .B(n1058), .Y(N10953));
  XOR2X1 U548_C1 (.A(U549_C1__n_1), .B(U549_C1__n), .Y(N5782));
  MXI2X1 clk_r_REG48_S4_syn40_C3_1 (.A(n1037), .B(n1102), .S0(en_4), .Y(N11735));
  ADDFX1 U_MULT_S1_3_0 (.A(N10264), .B(U_MULT_CARRYB41), .CI(U_MULT_SUMB36), 
     .CO(U_MULT_CARRYB34), .S(U_MULT_CLA_SUM_3_));
  NOR2X1 U305_C1 (.A(n1068), .B(n1064), .Y(N5647));
  ADDFX1 U_MULT_S2_3_4 (.A(N5673), .B(U_MULT_CARRYB37), .CI(U_MULT_SUMB32), 
     .CO(U_MULT_CARRYB30), .S(U_MULT_SUMB27));
  XOR2X1 U544_C1 (.A(U545_C1__n_1), .B(U545_C1__n), .Y(N10267));
  ADDFX1 U_MULT_S2_6_5 (.A(N11729), .B(U_MULT_CARRYB15), .CI(U_MULT_SUMB13), 
     .CO(U_MULT_CARRYB8), .S(U_MULT_SUMB8));
  OAI21X1 clk_r_REG1_S2_syn40_C3_1 (.A0(n1093), .A1(en_4), .B0(N10808), 
     .Y(N11809));
  OAI21X1 clk_r_REG0_S1_syn40_C3_1 (.A0(n1058), .A1(en_4), .B0(N4133), 
     .Y(N10620));
  ADDFX1 U_MULT_S4_2 (.A(N10594), .B(U_MULT_CARRYB11), .CI(U_MULT_SUMB10), 
     .CO(U_MULT_CARRYB4), .S(U_MULT_SUMB4));
  MXI2X1 clk_r_REG38_S3_syn40_C3_1 (.A(n1096), .B(n1097), .S0(en_4), .Y(N10233));
  SDFFRX1 clk_r_REG43_S2 (.CK(clk0_5), .D(N5700), .Q(n6), .QN(n1075), 
     .RN(N11737_2), .SE(test_se_1), .SI(product[3]));
  ADDFX1 U_MULT_S2_3_2 (.A(N10954), .B(U_MULT_CARRYB39), .CI(U_MULT_SUMB34), 
     .CO(U_MULT_CARRYB32), .S(U_MULT_SUMB29));
  OAI21X1 clk_r_REG40_S2_syn40_C3_1 (.A0(n1095), .A1(en_4), .B0(N8460), 
     .Y(N10232));
  MXI2X1 clk_r_REG41_S3_syn40_C3_1 (.A(n1094), .B(n1095), .S0(en_4), .Y(N11145));
  NAND2X1 clk_r_REG58_S1_syn40_C3_3 (.A(en_4), .B(a[2]), .Y(N6802));
  ADDFX1 U_MULT_S2_4_2 (.A(N5653), .B(U_MULT_CARRYB32), .CI(U_MULT_SUMB28), 
     .CO(U_MULT_CARRYB25), .S(U_MULT_SUMB23));
  NOR2X1 U335_C1 (.A(n1066), .B(n1060), .Y(U539_C1__n));
  ADDFX1 U_MULT_S1_2_0 (.A(N10953), .B(N5728), .CI(N10952), .CO(U_MULT_CARRYB41), 
     .S(n1491));
  NOR2X1 U316_C1 (.A(n1068), .B(n1060), .Y(N10265));
  AND2X1 U541_C1 (.A(N5760), .B(N10563), .Y(N10513));
  SDFFRX1 clk_r_REG59_S1 (.CK(clk0_5), .D(N5684), .Q(n1432), .QN(n1068), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1431));
  SDFFRX1 clk_r_REG32_S3 (.CK(clk0_5), .D(N11146), .Q(n13), .QN(n1098), 
     .RN(N11737_2), .SE(test_se_1), .SI(n14));
  NAND2X1 clk_r_REG60_S1_syn40_C3_3 (.A(en_4), .B(a[4]), .Y(N4119));
  SDFFRX1 clk_r_REG34_S2 (.CK(clk0_5), .D(N10652), .Q(n12), .QN(n1073), 
     .RN(N11737_2), .SE(test_se_1), .SI(product[6]));
  ADDFX1 U_MULT_S2_6_1 (.A(N5734), .B(U_MULT_CARRYB19), .CI(U_MULT_SUMB17), 
     .CO(U_MULT_CARRYB12), .S(U_MULT_SUMB12));
  ADDFX1 U_MULT_S2_5_1 (.A(N12023), .B(U_MULT_CARRYB26), .CI(U_MULT_SUMB23), 
     .CO(U_MULT_CARRYB19), .S(U_MULT_SUMB18));
  NOR2X1 U319_C1 (.A(n1069), .B(n1060), .Y(N10057));
  SDFFRX1 clk_r_REG36_S4 (.CK(clk0_5), .D(N10529), .Q(product[5]), .QN(n1051), 
     .RN(N11737_2), .SE(test_se_1), .SI(n11));
  NOR2X1 U368_C1 (.A(n1069), .B(n1065), .Y(N12305));
  BUFX1 BL2_BUF83 (.A(a[1]), .Y(a_1_1));
  NOR2X1 U346_C1 (.A(n1070), .B(n1063), .Y(N11727));
  NOR2X1 U313_C1 (.A(n1068), .B(n1062), .Y(N5730));
  NOR2X1 U314_C1 (.A(n1069), .B(n1061), .Y(N5653));
  OAI21X1 clk_r_REG63_S1_syn40_C3_1 (.A0(n1056), .A1(en_4), .B0(N1558), 
     .Y(N10528));
  SDFFRX2 clk_r_REG63_S1 (.CK(clk0_5), .D(N10528), .Q(test_so3), .QN(n1056), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1435));
  NOR2X1 U322_C1 (.A(n1071), .B(n1058), .Y(N12024));
  ADDFX1 U_MULT_S14_7_2 (.A(N11102), .B(N5689), .CI(U_MULT_SUMB6), 
     .CO(U_MULT_CLA_CARRY_7_), .S(U_MULT_CLA_SUM_7_));
  SDFFRX1 clk_r_REG29_S3 (.CK(clk0_5), .D(N5643), .Q(n15), .QN(n1100), 
     .RN(N11737_2), .SE(test_se_1), .SI(n16));
  NOR2X1 U350_C1 (.A(n1448), .B(n1055), .Y(N5689));
  NOR2X1 U349_C1 (.A(n1071), .B(n1063), .Y(N11730));
  ADDFX1 U_MULT_S2_5_5 (.A(N11221), .B(U_MULT_CARRYB22), .CI(U_MULT_SUMB19), 
     .CO(U_MULT_CARRYB15), .S(U_MULT_SUMB14));
  ADDFX1 U_MULT_S3_4_6 (.A(N12305), .B(U_MULT_CARRYB28), .CI(N5683), 
     .CO(U_MULT_CARRYB21), .S(U_MULT_SUMB19));
  NOR2X1 U308_C1 (.A(n1071), .B(n1061), .Y(N5727));
  NOR2X1 U345_C1 (.A(n1070), .B(n1064), .Y(N11221));
  NAND2X1 clk_r_REG50_S1_syn40_C3_3 (.A(en_4), .B(b_2_1), .Y(N7549));
  AND2X1 U549_C1 (.A(U549_C1__n_1), .B(U549_C1__n), .Y(N11222));
  AND2X1 U543_C1 (.A(U543_C1__n_1), .B(U543_C1__n), .Y(N5729));
  XOR2X1 U546_C1 (.A(N11723), .B(N11174), .Y(N5669));
  NOR2X1 U348_C1 (.A(n1071), .B(n1064), .Y(N11729));
  OAI21X1 clk_r_REG31_S2_syn40_C3_1 (.A0(n1099), .A1(en_4), .B0(N4125), 
     .Y(N11147));
  OAI21X1 clk_r_REG37_S2_syn40_C3_1 (.A0(n1097), .A1(en_4), .B0(N11235), 
     .Y(N5645));
  MXI2X1 clk_r_REG2_S3_syn40_C3_1 (.A(n1092), .B(n1093), .S0(en_4), .Y(N5753));
  ADDFX1 U_MULT_S4_1 (.A(N10511), .B(U_MULT_CARRYB12), .CI(U_MULT_SUMB11), 
     .CO(U_MULT_CARRYB5), .S(U_MULT_SUMB5));
  ADDFX1 U_MULT_S4_4 (.A(N11428), .B(U_MULT_CARRYB9), .CI(U_MULT_SUMB8), 
     .CO(U_MULT_CARRYB2), .S(U_MULT_SUMB2));
  XOR2X1 U554_C1 (.A(U_MULT_SUMB3), .B(U_MULT_CARRYB4), .Y(U291_C1__n));
  NAND2X1 U351_C1 (.A(n1448), .B(n1428), .Y(N10592));
  NAND2X1 clk_r_REG62_S1_syn40_C3_3 (.A(en_4), .B(a[6]), .Y(N12178));
  MXI2X1 clk_r_REG21_S4_syn40_C3_1 (.A(n1048), .B(n1088), .S0(en_5), .Y(N12184));
  SDFFRX1 clk_r_REG21_S4 (.CK(clk0_26), .D(N12184), .Q(product[10]), .QN(n1048), 
     .RN(N11737_2), .SE(test_se), .SI(n22));
  SDFFRX1 clk_r_REG26_S3 (.CK(clk0_26), .D(N11452), .Q(n17), .QN(n1084), 
     .RN(N11737_2), .SE(test_se), .SI(n18));
  XOR2X1 U354_C1 (.A(N5774), .B(N5694), .Y(N11379));
  MXI2X1 clk_r_REG13_S2_syn40_C3_1 (.A(n1083), .B(N11379), .S0(en_5), .Y(N11378));
  AOI21X1 U293_C1_1 (.A0(U_MULT_SUMB1), .A1(U_MULT_CARRYB2), .B0(U293_C1__n), 
     .Y(N5692));
  XOR2X1 U363_C1 (.A(N11124), .B(N11123), .Y(N11122));
  NOR2BX1 U285_C2 (.AN(U285_C2__n), .B(U285_C2__n_1), .Y(N11123));
  SDFFRX1 clk_r_REG20_S3 (.CK(clk0_26), .D(N12185), .Q(n22), .QN(n1088), 
     .RN(N11737_2), .SE(test_se), .SI(n23));
  MXI2X1 clk_r_REG15_S4_syn40_C3_1 (.A(n1045), .B(n1082), .S0(en_5), .Y(N5693));
  SDFFRX1 clk_r_REG15_S4 (.CK(clk0_5), .D(N5693), .Q(product[15]), .QN(n1045), 
     .RN(N11737_2), .SE(test_se), .SI(n26));
  SDFFRX1 clk_r_REG9_S4 (.CK(clk0_5), .D(N5697), .Q(product[13]), .QN(n1043), 
     .RN(N11737_2), .SE(test_se), .SI(n30));
  MXI2X1 clk_r_REG10_S2_syn40_C3_1 (.A(n1081), .B(N12292), .S0(en_5), .Y(N12291));
  MX2X1 \test_point_534/U6_C4_2  (.A(rst_n_1), 
     .B(rc8051RtlTop_rc8051RtlTop_test_ds_1_in), .S0(rc8051RtlTop_test_mode_in), 
     .Y(N11737));
  BUFX8 BW2_BUF7963 (.A(N11737_1), .Y(N11737_2));
  SDFFRX1 clk_r_REG55_S1 (.CK(clk0_5), .D(N5682), .Q(n1428), .QN(n1055), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1427));
  AOI21X1 U295_C1_1 (.A0(U_MULT_SUMB5), .A1(U_MULT_CARRYB6), .B0(U290_C1__n), 
     .Y(U278_C2__n));
  NAND2X1 clk_r_REG28_S2_syn40_C3_2 (.A(en_5), .B(U_MULT_CLA_SUM_7_), .Y(N11813));
  NAND3X1 U289_C1_2 (.A(U_MULT_SUMB2), .B(U_MULT_CARRYB3), .C(U289_C1__n), 
     .Y(U280_C2__n_2));
  BUFX4 BW2_BUF3426 (.A(en_2), .Y(en_5));
  SDFFRX1 clk_r_REG28_S2 (.CK(clk0_5), .D(N8161), .Q(n16), .QN(n1101), 
     .RN(N11737_2), .SE(test_se_1), .SI(product[8]));
  MXI2X1 clk_r_REG14_S3_syn40_C3_1 (.A(n1082), .B(n1083), .S0(en_5), .Y(N11377));
  XOR2X1 U560_C1 (.A(U_MULT_SUMB0), .B(U_MULT_CARRYB1), .Y(U293_C1__n));
  OAI21X1 clk_r_REG25_S2_syn40_C3_4 (.A0(U_MULT_CLA_CARRY_7_), .A1(U288_C1__n), 
     .B0(U278_C2__n_4), .Y(clk_r_REG25_S2_syn40_C3__n));
  MXI2X1 clk_r_REG5_S3_syn40_C3_1 (.A(n1076), .B(n1077), .S0(en_5), .Y(N10522));
  AOI21X1 U299_C1_1 (.A0(U_MULT_SUMB0), .A1(U_MULT_CARRYB1), .B0(U300_C1__n), 
     .Y(U276_C2__n_4));
  XOR2X1 U562_C1 (.A(U_MULT_SUMB), .B(U_MULT_CARRYB0), .Y(U300_C1__n));
  AND2X1 U537_C1 (.A(N10280), .B(N10276), .Y(N5728));
  OAI21X1 clk_r_REG58_S1_syn40_C3_1 (.A0(n1067), .A1(en_3), .B0(N6802), 
     .Y(N12327));
  NOR2X1 U330_C1 (.A(n1066), .B(n1058), .Y(N10276));
  OAI21X1 clk_r_REG59_S1_syn40_C3_1 (.A0(n1068), .A1(en_3), .B0(N2094), 
     .Y(N5684));
  AND2X1 U547_C1 (.A(N11723), .B(N11174), .Y(N5780));
  ADDFX1 U_MULT_S2_2_5 (.A(N11238), .B(N5780), .CI(N5782), .CO(U_MULT_CARRYB36), 
     .S(U_MULT_SUMB32));
  ADDFX1 U_MULT_S2_2_3 (.A(N5516), .B(N5729), .CI(N10267), .CO(U_MULT_CARRYB38), 
     .S(U_MULT_SUMB34));
  ADDFX1 U_MULT_S3_2_6 (.A(N10510), .B(N11222), .CI(N5672), .CO(U_MULT_CARRYB35), 
     .S(U_MULT_SUMB31));
  SDFFRX1 clk_r_REG53_S1 (.CK(clk0_5), .D(N11100), .Q(n1426), .QN(n1064), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1425));
  MXI2X1 U364_C4_1 (.A(N5689_1), .B(N10592), .S0(n1435), .Y(N10512));
  MXI2X1 U376_C4_1 (.A(N11102_1), .B(N11103), .S0(n1426), .Y(N5824));
  BUFX1 BW1_BUF1890 (.A(en_4), .Y(en_2));
  OAI21X1 clk_r_REG43_S2_syn40_C3_1 (.A0(n1075), .A1(en_3), .B0(N9241), 
     .Y(N5700));
  SDFFRX1 clk_r_REG40_S2 (.CK(clk0_5), .D(N10232), .Q(n8), .QN(n1095), 
     .RN(N11737_2), .SE(test_se_1), .SI(product[4]));
  INVX2 BW2_INV1890 (.A(en_1), .Y(en_3));
  SDFFRX1 clk_r_REG41_S3 (.CK(clk0_5), .D(N11145), .Q(n7), .QN(n1094), 
     .RN(N11737_2), .SE(test_se_1), .SI(n8));
  MXI2X1 clk_r_REG39_S4_syn40_C3_1 (.A(n1038), .B(n1096), .S0(en_4), .Y(N5648));
  SDFFRX1 clk_r_REG38_S3 (.CK(clk0_5), .D(N10233), .Q(n9), .QN(n1096), 
     .RN(N11737_2), .SE(test_se_1), .SI(n10));
  XOR2X1 U538_C1 (.A(U539_C1__n_1), .B(U539_C1__n), .Y(N10952));
  AND2X1 U539_C1 (.A(U539_C1__n_1), .B(U539_C1__n), .Y(N11117));
  MXI2X1 U356_C4_1 (.A(N5689_1), .B(N10592), .S0(n1430), .Y(N5672));
  NOR2X1 U312_C1 (.A(n1068), .B(n1061), .Y(N10954));
  NOR2X1 U327_C1 (.A(n1061), .B(n1057), .Y(U539_C1__n_1));
  NOR2X1 U329_C1 (.A(n1060), .B(n1057), .Y(N10280));
  SDFFRX1 clk_r_REG56_S1 (.CK(clk0_5), .D(N12325), .Q(n1429), .QN(n1057), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1428));
  MXI2X1 clk_r_REG35_S3_syn40_C3_1 (.A(n1072), .B(n1073), .S0(en_4), .Y(N5699));
  NOR2X1 U344_C1 (.A(n1069), .B(n1064), .Y(N5758));
  NOR2X1 U317_C1 (.A(n1070), .B(n1061), .Y(N10266));
  SDFFRX1 clk_r_REG37_S2 (.CK(clk0_5), .D(N5645), .Q(n10), .QN(n1097), 
     .RN(N11737_2), .SE(test_se_1), .SI(product[5]));
  SDFFRX1 clk_r_REG35_S3 (.CK(clk0_5), .D(N5699), .Q(n11), .QN(n1072), 
     .RN(N11737_2), .SE(test_se_1), .SI(n12));
  SDFFRX2 clk_r_REG60_S1 (.CK(clk0_5), .D(N5778), .Q(test_so2), .QN(n1069), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1432));
  NOR2X1 U323_C1 (.A(n1071), .B(n1060), .Y(N5734));
  OAI21X1 clk_r_REG51_S1_syn40_C3_1 (.A0(n1062), .A1(en_4), .B0(N9939), 
     .Y(N11098));
  NOR2X1 U334_C1 (.A(n1066), .B(n1064), .Y(N11723));
  ADDFX1 U_MULT_S2_4_1 (.A(N10057), .B(U_MULT_CARRYB33), .CI(U_MULT_SUMB29), 
     .CO(U_MULT_CARRYB26), .S(U_MULT_SUMB24));
  MXI2X1 clk_r_REG36_S4_syn40_C3_1 (.A(n1051), .B(n1072), .S0(en_4), .Y(N10529));
  NAND2X1 clk_r_REG0_S1_syn40_C3_3 (.A(en_4), .B(b[0]), .Y(N4133));
  SDFFRX1 clk_r_REG31_S2 (.CK(clk0_5), .D(N11147), .Q(n14), .QN(n1099), 
     .RN(N11737_2), .SE(test_se_1), .SI(product[7]));
  BUFX8 BW2_BUF2508 (.A(test_se), .Y(test_se_1));
  SDFFRX1 clk_r_REG4_S2 (.CK(clk0_5), .D(N10523), .Q(n33), .QN(n1077), 
     .RN(N11737_2), .SE(test_se), .SI(product[0]));
  INVX1 clk_r_REG25_S2_syn40_C3_4_MP_INV (.A(U278_C2__n_1), .Y(U278_C2__n_4));
  SDFFRX1 clk_r_REG49_S1 (.CK(clk0_5), .D(N5688), .Q(n1422), .QN(n1060), 
     .RN(N11737_2), .SE(test_se_1), .SI(product[1]));
  OAI21X1 clk_r_REG61_S1_syn40_C3_1 (.A0(n1070), .A1(en_4), .B0(N251), 
     .Y(N10526));
  MXI2X1 U371_C4_1 (.A(N5689_1), .B(N10592), .S0(test_so2), .Y(N12306));
  ADDFX1 U_MULT_S2_6_3 (.A(N11728), .B(U_MULT_CARRYB17), .CI(U_MULT_SUMB15), 
     .CO(U_MULT_CARRYB10), .S(U_MULT_SUMB10));
  SDFFRX1 clk_r_REG51_S1 (.CK(clk0_5), .D(N11098), .Q(n1424), .QN(n1062), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1423));
  NAND2X1 clk_r_REG61_S1_syn40_C3_3 (.A(en_4), .B(a[5]), .Y(N251));
  SDFFRX1 clk_r_REG33_S4 (.CK(clk0_5), .D(N5823), .Q(product[6]), .QN(n1039), 
     .RN(N11737_2), .SE(test_se_1), .SI(n13));
  SDFFRX1 clk_r_REG12_S4 (.CK(clk0_26), .D(N5772), .Q(product[14]), .QN(n1044), 
     .RN(N11737_2), .SE(test_se), .SI(n28));
  NOR2X1 U326_C1 (.A(n1065), .B(n1057), .Y(N11174));
  NOR2X1 U325_C1 (.A(n1064), .B(n1057), .Y(U545_C1__n_1));
  NOR2X1 U332_C1 (.A(n1066), .B(n1065), .Y(U549_C1__n));
  NAND2X1 clk_r_REG53_S1_syn40_C3_3 (.A(en_4), .B(b[5]), .Y(N11424));
  ADDFX1 U_MULT_S2_6_4 (.A(N11730), .B(U_MULT_CARRYB16), .CI(U_MULT_SUMB14), 
     .CO(U_MULT_CARRYB9), .S(U_MULT_SUMB9));
  SDFFRX1 clk_r_REG62_S1 (.CK(clk0_5), .D(N10527), .Q(n1435), .QN(n1071), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1434));
  MXI2X1 U357_C4_1 (.A(N11102_1), .B(N11103), .S0(n1422), .Y(N10511));
  OAI21X1 U275_C2_1 (.A0(U275_C2__n_1), .A1(U275_C2__n), .B0(U275_C2__n_2), 
     .Y(N11124_1));
  ADDFX1 U_MULT_S4_0 (.A(N5776), .B(U_MULT_CARRYB13), .CI(U_MULT_SUMB12), 
     .CO(U_MULT_CARRYB6), .S(U_MULT_SUMB6));
  INVX1 U373_C4_1_MP_INV (.A(N5689), .Y(N5689_1));
  SDFFRX1 clk_r_REG2_S3 (.CK(clk0_5), .D(N5753), .Q(n34), .QN(n1092), 
     .RN(N11737_2), .SE(test_se_1), .SI(n35));
  MXI2X1 clk_r_REG24_S4_syn40_C3_1 (.A(n1047), .B(n1086), .S0(en_5), .Y(N5677));
  MXI2X1 clk_r_REG25_S2_syn40_C3_3 (.A(n1085), .B(clk_r_REG25_S2_syn40_C3__n), 
     .S0(en_5), .Y(N11454));
  MXI2X1 clk_r_REG26_S3_syn40_C3_1 (.A(n1084), .B(n1085), .S0(en_5), .Y(N11452));
  AOI21X1 U276_C2_1 (.A0(U276_C2__n_1), .A1(U276_C2__n), .B0(U276_C2__n_2), 
     .Y(N5774));
  INVX1 U299_C1_1_MP_INV (.A(U276_C2__n_4), .Y(U276_C2__n_1));
  AND3X1 U300_C1_2 (.A(U_MULT_SUMB0), .B(U_MULT_CARRYB1), .C(U300_C1__n), 
     .Y(U276_C2__n_2));
  OAI2BB1X1 U271_C2_1 (.A0N(N5692_1), .A1N(N11357_1), .B0(N11356), 
     .Y(U276_C2__n));
  NAND3X1 U298_C1_2 (.A(U_MULT_SUMB1), .B(U_MULT_CARRYB2), .C(U293_C1__n), 
     .Y(N11356));
  XOR2X1 U358_C1 (.A(U280_C2__n_1), .B(N10525), .Y(N10524));
  SDFFRX1 clk_r_REG17_S3 (.CK(clk0_26), .D(N12245), .Q(n24), .QN(n1090), 
     .RN(N11737_2), .SE(test_se), .SI(n25));
  SDFFRX1 clk_r_REG16_S2 (.CK(clk0_5), .D(N11121), .Q(n25), .QN(n1091), 
     .RN(N11737_2), .SE(test_se), .SI(product[15]));
  SDFFRX1 clk_r_REG11_S3 (.CK(clk0_26), .D(N12290), .Q(n28), .QN(n1080), 
     .RN(N11737_2), .SE(test_se), .SI(n29));
  MXI2X1 clk_r_REG11_S3_syn40_C3_1 (.A(n1080), .B(n1081), .S0(en_5), .Y(N12290));
  BUFX1 BL1_ASSIGN_BUF20 (.A(test_so1), .Y(product[9]));
  SDFFRX2 clk_r_REG24_S4 (.CK(clk0_26), .D(N5677), .Q(test_so1), .QN(n1047), 
     .RN(N11737_1), .SE(test_se), .SI(n20));
  MXI2X1 U365_C4_1 (.A(N11102_1), .B(N11103), .S0(n1427), .Y(N10432));
  AOI21X1 U294_C1_1 (.A0(U_MULT_SUMB2), .A1(U_MULT_CARRYB3), .B0(U289_C1__n), 
     .Y(U280_C2__n));
  OAI21X1 clk_r_REG55_S1_syn40_C3_1 (.A0(n1055), .A1(en_2), .B0(N2265), 
     .Y(N5682));
  MXI2X1 clk_r_REG30_S4_syn40_C3_1 (.A(n1040), .B(n1100), .S0(en_5), .Y(N11148));
  INVX1 U375_C4_1_MP_INV (.A(N11102), .Y(N11102_1));
  SDFFRX1 clk_r_REG10_S2 (.CK(clk0_5), .D(N12291), .Q(n29), .QN(n1081), 
     .RN(N11737_2), .SE(test_se), .SI(product[13]));
  MXI2X1 clk_r_REG8_S3_syn40_C3_1 (.A(n1078), .B(n1079), .S0(en_5), .Y(N5104));
  XOR2X1 U359_C1 (.A(N5698), .B(N11357), .Y(N10304));
  XOR2X1 U361_C1 (.A(U278_C2__n_4), .B(N12183), .Y(N12197));
  MXI2X1 clk_r_REG6_S4_syn40_C3_1 (.A(n1042), .B(n1076), .S0(en_5), .Y(N5771));
  XOR2X1 U379_C1 (.A(N12313), .B(N12312), .Y(N5694));
  SDFFRX1 clk_r_REG7_S2 (.CK(clk0_5), .D(N5356), .Q(n31), .QN(n1079), 
     .RN(N11737_2), .SE(test_se), .SI(product[12]));
  NAND2X1 clk_r_REG40_S2_syn40_C3_2 (.A(en_3), .B(U_MULT_CLA_SUM_3_), .Y(N8460));
  XOR2X1 U540_C1 (.A(N5760), .B(N10563), .Y(N11175));
  NOR2X1 U366_C1 (.A(n1068), .B(n1065), .Y(N5705));
  NAND2X1 clk_r_REG37_S2_syn40_C3_2 (.A(en_4), .B(U_MULT_CLA_SUM_4_), .Y(N11235));
  MXI2X1 clk_r_REG47_S3_syn40_C3_1 (.A(n1102), .B(n1103), .S0(en_3), .Y(N11736));
  ADDFX1 U_MULT_S2_3_5 (.A(N5647), .B(U_MULT_CARRYB36), .CI(U_MULT_SUMB31), 
     .CO(U_MULT_CARRYB29), .S(U_MULT_SUMB26));
  NOR2X1 U339_C1 (.A(n1067), .B(n1064), .Y(N11238));
  SDFFRX1 clk_r_REG58_S1 (.CK(clk0_5), .D(N12327), .Q(n1431), .QN(n1067), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1430));
  MXI2X1 U377_C4_1 (.A(N11102_1), .B(N11103), .S0(n1424), .Y(N5690));
  SDFFRX1 clk_r_REG54_S1 (.CK(clk0_5), .D(N11101), .Q(n1427), .QN(n1065), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1426));
  ADDFX1 U_MULT_S3_6_6 (.A(N10593), .B(U_MULT_CARRYB14), .CI(N12308), 
     .CO(U_MULT_CARRYB7), .S(U_MULT_SUMB7));
  OAI21X1 clk_r_REG54_S1_syn40_C3_1 (.A0(n1065), .A1(en_4), .B0(N8493), 
     .Y(N11101));
  SDFFRX1 clk_r_REG44_S3 (.CK(clk0_5), .D(N10654), .Q(n5), .QN(n1074), 
     .RN(N11737_2), .SE(test_se_1), .SI(n6));
  ADDFX1 U_MULT_S2_4_4 (.A(N10410), .B(U_MULT_CARRYB30), .CI(U_MULT_SUMB26), 
     .CO(U_MULT_CARRYB23), .S(U_MULT_SUMB21));
  MXI2X1 U367_C4_1 (.A(N5689_1), .B(N10592), .S0(n1431), .Y(N10433));
  MXI2X1 clk_r_REG45_S4_syn40_C3_1 (.A(n1041), .B(n1074), .S0(en_3), .Y(N10653));
  SDFFRX1 clk_r_REG46_S2 (.CK(clk0_5), .D(N5644), .Q(n4), .QN(n1103), 
     .RN(N11737_2), .SE(test_se_1), .SI(product[2]));
  NAND2X1 clk_r_REG57_S1_syn40_C3_3 (.A(en_4), .B(a_1_1), .Y(N1272));
  ADDFX1 U_MULT_S2_2_2 (.A(N5825), .B(N10513), .CI(N5667), .CO(U_MULT_CARRYB39), 
     .S(U_MULT_SUMB35));
  INVX1 BW2_INV_D1890 (.A(en), .Y(en_1));
  MXI2X1 clk_r_REG46_S2_syn40_C3_1 (.A(n1103), .B(N5768), .S0(en_3), .Y(N5644));
  ADDFX1 U_MULT_S2_3_1 (.A(N10265), .B(U_MULT_CARRYB40), .CI(U_MULT_SUMB35), 
     .CO(U_MULT_CARRYB33), .S(U_MULT_SUMB30));
  NOR2X1 U341_C1 (.A(n1067), .B(n1060), .Y(N11120));
  MXI2X1 U352_C4_1 (.A(N5689_1), .B(N10592), .S0(n1429), .Y(U549_C1__n_1));
  MXI2X1 clk_r_REG33_S4_syn40_C3_1 (.A(n1039), .B(n1098), .S0(en_4), .Y(N5823));
  MXI2X1 U369_C4_1 (.A(N5689_1), .B(N10592), .S0(n1432), .Y(N5683));
  ADDFX1 U_MULT_S2_5_4 (.A(N11727), .B(U_MULT_CARRYB23), .CI(U_MULT_SUMB20), 
     .CO(U_MULT_CARRYB16), .S(U_MULT_SUMB15));
  NOR2X1 U343_C1 (.A(n1069), .B(n1062), .Y(N10564));
  NOR2X1 U307_C1 (.A(n1070), .B(n1062), .Y(N5732));
  ADDFX1 U_MULT_S1_5_0 (.A(N5733), .B(U_MULT_CARRYB27), .CI(U_MULT_SUMB24), 
     .CO(U_MULT_CARRYB20), .S(n1490));
  NOR2X1 U321_C1 (.A(n1070), .B(n1060), .Y(N12023));
  BUFX1 BL2_BUF61 (.A(a[0]), .Y(a_0_1));
  SDFFRX1 clk_r_REG42_S4 (.CK(clk0_5), .D(N5639), .Q(product[3]), .QN(n1052), 
     .RN(N11737_2), .SE(test_se_1), .SI(n7));
  BUFX1 BL2_BUF117 (.A(b[2]), .Y(b_2_1));
  NOR2X1 U333_C1 (.A(n1066), .B(n1063), .Y(U545_C1__n));
  NOR2X1 U318_C1 (.A(n1069), .B(n1058), .Y(N10056));
  NAND2X1 clk_r_REG54_S1_syn40_C3_2 (.A(en_4), .B(b[6]), .Y(N8493));
  SDFFRX1 clk_r_REG0_S1 (.CK(clk0_5), .D(N10620), .Q(n1421), .QN(n1058), 
     .RN(N11737_2), .SE(test_se_1), .SI(test_si1));
  ADDFX1 U_MULT_S1_6_0 (.A(N12024), .B(U_MULT_CARRYB20), .CI(U_MULT_SUMB18), 
     .CO(U_MULT_CARRYB13), .S(U_MULT_CLA_SUM_6_));
  NAND2BX1 U278_C2 (.AN(U278_C2__n), .B(U278_C2__n_1), .Y(U278_C2__n_3));
  AND2X1 U288_C1 (.A(U_MULT_CLA_CARRY_7_), .B(U288_C1__n), .Y(U278_C2__n_1));
  NOR2BX1 U282_C2 (.AN(U280_C2__n_2), .B(U280_C2__n), .Y(N10525));
  OAI21X1 clk_r_REG52_S1_syn40_C3_1 (.A0(n1063), .A1(en_4), .B0(N8419), 
     .Y(N11099));
  SDFFRX1 clk_r_REG50_S1 (.CK(clk0_5), .D(N5777), .Q(n1423), .QN(n1061), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1422));
  NOR2X1 U320_C1 (.A(n1070), .B(n1058), .Y(N5733));
  SDFFRX1 clk_r_REG52_S1 (.CK(clk0_5), .D(N11099), .Q(n1425), .QN(n1063), 
     .RN(N11737_2), .SE(test_se_1), .SI(n1424));
  OAI21X1 clk_r_REG50_S1_syn40_C3_1 (.A0(n1061), .A1(en_4), .B0(N7549), 
     .Y(N5777));
  NAND2X1 clk_r_REG51_S1_syn40_C3_3 (.A(en_4), .B(b[3]), .Y(N9939));
endmodule

// Entity:adc Model:adc Library:L0
module adc (dataa, datab, cin, ac, cout, overflow, result);
  input cin;
  output ac, cout, overflow;
  input [7:0] dataa;
  input [7:0] datab;
  output [7:0] result;
  wire N4854, result_7_1, dataa_7_1;
  supply0 VSS;
  adc_DW01_add_5_0 add_1_root_add_18_2 (.A({VSS, dataa[7], dataa[6], dataa[5], 
     dataa[4]}), .B({VSS, datab[7], datab[6], datab[5], datab[4]}), .CI(ac), .SUM({
     cout, result[7], result[6], result[5], result[4]}), .CO());
  adc_DW01_add_5_2 add_1_root_add_17_2 (.A({VSS, dataa[3], dataa[2], dataa[1], 
     dataa[0]}), .B({VSS, datab[3], datab[2], datab[1], datab[0]}), .CI(cin), 
     .SUM({ac, result[3], result[2], result[1], result[0]}), .CO());
  INVX1 U26_C5_1_MP_INV (.A(result[7]), .Y(result_7_1));
  BUFX1 BL1_BUF310 (.A(dataa[7]), .Y(dataa_7_1));
  OAI31X1 U26_C5_1 (.A0(result_7_1), .A1(datab[7]), .A2(dataa_7_1), .B0(N4854), 
     .Y(overflow));
  NAND3BX1 U26_C5_7 (.AN(result[7]), .B(dataa_7_1), .C(datab[7]), .Y(N4854));
endmodule

// Entity:adc_DW01_add_5_0 Model:adc_DW01_add_5_0 Library:L0
module adc_DW01_add_5_0 (A, B, CI, SUM, CO);
  input CI;
  output CO;
  input [4:0] A;
  input [4:0] B;
  output [4:0] SUM;
  wire U42_C2__n, U42_C2__n_1, U15_C2__n, N7688, N10704, U18_C1__n, N10975, 
     N10537, N7669, U41_C2__n_2, U7_C1_2_C2__n, N4879, U13_C2__n, N6875, N4884, 
     N7413, N7005, N4879_1, N10975_1, U7_C1_2_C2__n_1, U13_C2__n_1, N6875_1, 
     N10704_1, U42_C2__n_2, N7413_1, N7688_1, U18_C1__n_1, A_0_1, A_2_1;
  XOR2X2 U12_C1 (.A(N10704_1), .B(N4884), .Y(SUM[3]));
  INVX1 U13_C2_5_MP_INV (.A(U42_C2__n), .Y(U42_C2__n_2));
  OAI21X2 U13_C2_5 (.A0(N6875), .A1(U42_C2__n_2), .B0(U42_C2__n_1), .Y(N4884));
  NAND2X1 U47_C1 (.A(B[2]), .B(A_2_1), .Y(U42_C2__n_1));
  INVX1 U6_C1_1_MP_INV (.A(N7413_1), .Y(N7413));
  XOR2X1 U36_C2 (.A(N7669), .B(N7005), .Y(SUM[1]));
  AOI31X1 U6_C1_1 (.A0(CI), .A1(U7_C1_2_C2__n), .A2(N4879), .B0(N7688_1), 
     .Y(N7413_1));
  INVX1 U19_C2_MP_INV (.A(N10975), .Y(N10975_1));
  NAND2X1 U18_C1 (.A(N4879), .B(U18_C1__n), .Y(N10975));
  INVX1 U50_C1_C1_MP_INV (.A(U7_C1_2_C2__n_1), .Y(U7_C1_2_C2__n));
  AOI2BB2X1 U41_C2_1 (.A0N(B[3]), .A1N(A[3]), .B0(U42_C2__n_1), .B1(U41_C2__n_2), 
     .Y(SUM[4]));
  INVX1 U38_C1_1_MP_INV (.A(U18_C1__n), .Y(U18_C1__n_1));
  INVX1 U6_C1_1_MP_INV_1 (.A(N7688), .Y(N7688_1));
  NAND2X1 U7_C1_2_C2_1 (.A(B[0]), .B(A_0_1), .Y(U13_C2__n_1));
  NOR2X1 U50_C1_C1 (.A(B[1]), .B(A[1]), .Y(U7_C1_2_C2__n_1));
  INVX1 U12_C1_MP_INV (.A(N10704), .Y(N10704_1));
  XNOR2X1 U32_C1 (.A(B[3]), .B(A[3]), .Y(N10704));
  XOR2X1 U29_C2 (.A(N10537), .B(N7413_1), .Y(SUM[2]));
  BUFX1 BL2_BUF73 (.A(A[2]), .Y(A_2_1));
  OR2X1 U49_C1 (.A(B[2]), .B(A_2_1), .Y(U42_C2__n));
  NAND2X1 U31_C1 (.A(U42_C2__n_1), .B(U42_C2__n), .Y(N10537));
  AOI22X1 U42_C2_3 (.A0(B[3]), .A1(A[3]), .B0(N7413), .B1(U42_C2__n), 
     .Y(U41_C2__n_2));
  AOI21X1 U38_C1_1 (.A0(CI), .A1(N4879), .B0(U18_C1__n_1), .Y(N7005));
  NAND2X1 U34_C1 (.A(U7_C1_2_C2__n), .B(U15_C2__n), .Y(N7669));
  INVX1 U9_C1_C1_MP_INV (.A(N4879_1), .Y(N4879));
  NAND2BX4 U13_C2_3 (.AN(U13_C2__n), .B(U15_C2__n), .Y(N6875_1));
  NOR2X1 U9_C1_C1 (.A(B[0]), .B(A_0_1), .Y(N4879_1));
  NOR2BX1 U15_C2 (.AN(U15_C2__n), .B(U13_C2__n), .Y(N7688));
  AOI31X1 U13_C2_9 (.A0(CI), .A1(U7_C1_2_C2__n), .A2(N4879), .B0(N6875_1), 
     .Y(N6875));
  BUFX1 BL2_BUF50 (.A(A[0]), .Y(A_0_1));
  NAND2X1 U48_C1 (.A(B[0]), .B(A_0_1), .Y(U18_C1__n));
  NOR2X1 U7_C1_2_C2_2 (.A(U7_C1_2_C2__n_1), .B(U13_C2__n_1), .Y(U13_C2__n));
  NAND2X1 U10_C1 (.A(B[1]), .B(A[1]), .Y(U15_C2__n));
  XOR2X1 U19_C2 (.A(CI), .B(N10975_1), .Y(SUM[0]));
endmodule

// Entity:adc_DW01_add_5_2 Model:adc_DW01_add_5_2 Library:L0
module adc_DW01_add_5_2 (A, B, CI, SUM, CO);
  input CI;
  output CO;
  input [4:0] A;
  input [4:0] B;
  output [4:0] SUM;
  wire N7686, N7687, U37_C1__n, N10328, N2127, U35_C2__n, U35_C2__n_1, N4592, 
     N4953, N4827, N4593, N11756, N4832, N10391, N8110, U37_C1__n_3, 
     U37_C1__n_4, U35_C2__n_2, N10373_2, A_0_1, N2127_1, N10328_1, N7687_1, 
     CI_1, A_2_1;
  NAND2X1 U35_C2_5 (.A(B[3]), .B(A[3]), .Y(N10391));
  AOI21X2 U35_C2_8 (.A0(N10373_2), .A1(N2127_1), .B0(U35_C2__n_2), 
     .Y(U35_C2__n_1));
  NOR2X4 U35_C2_2 (.A(U35_C2__n_1), .B(U35_C2__n), .Y(SUM[4]));
  INVX1 U8_C1_MP_INV (.A(N7687), .Y(N7687_1));
  NOR2X1 U9_C1_C1 (.A(B[3]), .B(A[3]), .Y(U35_C2__n));
  AOI21X1 U31_C2_1 (.A0(B[3]), .A1(A[3]), .B0(U35_C2__n), .Y(N7687));
  XOR3X2 U21_C1_3 (.A(CI), .B(A[0]), .C(B[0]), .Y(SUM[0]));
  NAND2X1 U5_C1 (.A(B[2]), .B(A_2_1), .Y(N10328_1));
  NOR2X1 U12_C1 (.A(B[2]), .B(A_2_1), .Y(N2127));
  NOR2X1 U37_C1_3 (.A(B[1]), .B(A[1]), .Y(N11756));
  OAI221X4 U37_C1_6 (.A0(U37_C1__n_3), .A1(N8110), .B0(N11756), .B1(U37_C1__n_4), 
     .C0(U37_C1__n), .Y(N10373_2));
  INVX2 U37_C1_4_MP_INV (.A(A[0]), .Y(A_0_1));
  OAI21X1 U22_C1_2 (.A0(N4827), .A1(CI_1), .B0(N4832), .Y(N4593));
  INVX1 U5_C1_MP_INV (.A(N10328_1), .Y(N10328));
  AOI21X1 U20_C2_1 (.A0(N10373_2), .A1(N2127_1), .B0(N10328), .Y(N4592));
  NOR2X1 U22_C1 (.A(B[0]), .B(A[0]), .Y(N4827));
  XOR2X1 U8_C1 (.A(N7687_1), .B(N4592), .Y(SUM[3]));
  BUFX1 BL2_BUF100 (.A(A[2]), .Y(A_2_1));
  NAND2BX4 U37_C1_4 (.AN(A_0_1), .B(B[0]), .Y(U37_C1__n_4));
  NOR2X1 U38_C3_3 (.A(B[0]), .B(A[0]), .Y(N8110));
  NAND2X1 U35_C2_7 (.A(N10328_1), .B(N10391), .Y(U35_C2__n_2));
  NOR2BX1 U24_C1 (.AN(N10328_1), .B(N2127), .Y(N4953));
  OAI21X1 U29_C2_1 (.A0(B[1]), .A1(A[1]), .B0(U37_C1__n), .Y(N7686));
  XNOR2X1 U6_C2 (.A(N7686), .B(N4593), .Y(SUM[1]));
  INVX1 U22_C1_2_MP_INV (.A(CI), .Y(CI_1));
  INVX1 U35_C2_8_MP_INV (.A(N2127), .Y(N2127_1));
  NAND2X2 U14_C1 (.A(B[1]), .B(A[1]), .Y(U37_C1__n));
  NAND2X1 U22_C1_3 (.A(B[0]), .B(A[0]), .Y(N4832));
  XOR2X1 U23_C1 (.A(N4953), .B(N10373_2), .Y(SUM[2]));
  OAI21X2 U38_C3_4 (.A0(B[1]), .A1(A[1]), .B0(CI), .Y(U37_C1__n_3));
endmodule

// Entity:alu_flag_d_m Model:alu_flag_d_m Library:L0
module alu_flag_d_m (al, m, r, dividor, cy_addc, cy_rlc, cy_rrc, ac_addc, 
     ov_addc, cy, ac, ov, IN_B);
  input cy_addc, cy_rlc, cy_rrc, ac_addc, ov_addc;
  output cy, ac, ov;
  input [4:0] al;
  input [7:0] m;
  input [7:0] r;
  input [7:0] dividor;
  output [7:0] IN_B;
  wire U52_C2__n, N7071, N12182, U48_C5__n, N11961, N7081, N6917, N10632, N9141, 
     N6482, N11336, N1480, N11225, N6917_5, N6917_6, N10984_1, N7036_1, N7036_6, 
     N7036_7, ov_2, N12182_2, al_4_1, al_3_1, al_1_1, N7071_2, al_2_1, al_0_1, 
     IN_B_0_1, IN_B_1_1, IN_B_2_1, IN_B_3_1, IN_B_4_1, IN_B_5_1, IN_B_6_1, 
     IN_B_7_1, dividor_3_1, dividor_0_1, dividor_1_1, al_0_2, al_1_2;
  NOR4X1 U59_C4_12 (.A(m[7]), .B(m[5]), .C(m[3]), .D(m[1]), .Y(N6917_5));
  NAND2X1 U59_C4_14 (.A(N6917_6), .B(N6917_5), .Y(N6917));
  NOR4BX1 U59_C4_23 (.AN(N7036_1), .B(dividor[6]), .C(dividor[4]), 
     .D(dividor[2]), .Y(N7036_7));
  NOR2X1 U59_C4_17 (.A(dividor_3_1), .B(N7071), .Y(N7036_1));
  BUFX1 BL2_BUF107 (.A(dividor[3]), .Y(dividor_3_1));
  NAND3BX1 U49_C2_2 (.AN(U52_C2__n), .B(al_1_1), .C(al_0_2), .Y(N12182));
  NAND2X1 U48_C5_3 (.A(al_1_1), .B(ac_addc), .Y(N10632));
  AOI21X1 U59_C4_15 (.A0(al_1_2), .A1(al_0_2), .B0(U48_C5__n), .Y(N10984_1));
  OR3X1 U52_C2_3 (.A(al_1_1), .B(al_0_2), .C(U52_C2__n), .Y(N7071));
  AOI21X1 U48_C5_1 (.A0(N9141), .A1(N10632), .B0(U48_C5__n), .Y(ac));
  BUFX1 BL2_BUF149 (.A(al[0]), .Y(al_0_2));
  NAND4X1 U47_C5_19 (.A(al_3_1), .B(al_2_1), .C(al_1_1), .D(N11961), .Y(N11225));
  INVX1 U81_C4_1_MP_INV (.A(IN_B_1_1), .Y(IN_B[1]));
  INVX1 U76_C4_1_MP_INV (.A(IN_B_2_1), .Y(IN_B[2]));
  AOI22X1 U76_C4_1 (.A0(m[2]), .A1(N12182_2), .B0(r[2]), .B1(N7071_2), 
     .Y(IN_B_2_1));
  INVX1 U79_C4_1_MP_INV (.A(IN_B_7_1), .Y(IN_B[7]));
  AOI22X1 U81_C4_1 (.A0(m[1]), .A1(N12182_2), .B0(r[1]), .B1(N7071_2), 
     .Y(IN_B_1_1));
  AOI22X1 U74_C4_1 (.A0(m[6]), .A1(N12182_2), .B0(r[6]), .B1(N7071_2), 
     .Y(IN_B_6_1));
  NOR4X1 U59_C4_13 (.A(m[6]), .B(m[4]), .C(m[2]), .D(m[0]), .Y(N6917_6));
  AOI22X1 U80_C4_1 (.A0(m[0]), .A1(N12182_2), .B0(r[0]), .B1(N7071_2), 
     .Y(IN_B_0_1));
  INVX1 U80_C4_1_MP_INV (.A(IN_B_0_1), .Y(IN_B[0]));
  AOI22X1 U75_C4_1 (.A0(m[3]), .A1(N12182_2), .B0(r[3]), .B1(N7071_2), 
     .Y(IN_B_3_1));
  AOI22X1 U78_C4_1 (.A0(m[5]), .A1(N12182_2), .B0(r[5]), .B1(N7071_2), 
     .Y(IN_B_5_1));
  AOI22X1 U77_C4_1 (.A0(m[4]), .A1(N12182_2), .B0(r[4]), .B1(N7071_2), 
     .Y(IN_B_4_1));
  INVX1 U77_C4_1_MP_INV (.A(IN_B_4_1), .Y(IN_B[4]));
  INVX1 U75_C4_1_MP_INV (.A(IN_B_3_1), .Y(IN_B[3]));
  INVX1 U78_C4_1_MP_INV (.A(IN_B_5_1), .Y(IN_B[5]));
  NAND3X1 U47_C5_16 (.A(cy_rrc), .B(al[4]), .C(al_0_1), .Y(N11336));
  OAI31X1 U47_C5_3 (.A0(cy_addc), .A1(al[3]), .A2(al[2]), .B0(N6482), .Y(N7081));
  INVX1 U66_C2_2_MP_INV (.A(al[2]), .Y(al_2_1));
  INVX1 U59_C4_25_MP_INV (.A(ov_2), .Y(ov));
  NOR4X1 U59_C4_22 (.A(dividor[7]), .B(dividor[5]), .C(dividor_1_1), 
     .D(dividor_0_1), .Y(N7036_6));
  BUFX1 BL2_BUF109 (.A(dividor[0]), .Y(dividor_0_1));
  AOI222X1 U59_C4_25 (.A0(N6917), .A1(N12182_2), .B0(N7036_7), .B1(N7036_6), 
     .C0(ov_addc), .C1(N10984_1), .Y(ov_2));
  BUFX1 BL2_BUF111 (.A(dividor[1]), .Y(dividor_1_1));
  INVX2 U59_C4_25_MP_INV_1 (.A(N12182), .Y(N12182_2));
  INVX1 U59_C4_17_MP_INV (.A(N7071), .Y(N7071_2));
  AOI22X1 U79_C4_1 (.A0(m[7]), .A1(N12182_2), .B0(r[7]), .B1(N7071_2), 
     .Y(IN_B_7_1));
  INVX1 U74_C4_1_MP_INV (.A(IN_B_6_1), .Y(IN_B[6]));
  OAI2BB1X1 U47_C5_1 (.A0N(cy_addc), .A1N(al_4_1), .B0(N11336), .Y(N11961));
  INVX1 U68_C2_2_MP_INV (.A(al[4]), .Y(al_4_1));
  BUFX1 BL2_BUF152 (.A(al[1]), .Y(al_1_2));
  NAND3X1 U68_C2_2 (.A(al_4_1), .B(al_3_1), .C(al[2]), .Y(U52_C2__n));
  INVX1 U49_C2_2_MP_INV (.A(al_1_2), .Y(al_1_1));
  NAND3BX1 U48_C5_6 (.AN(ac_addc), .B(al_1_2), .C(al_0_1), .Y(N9141));
  INVX1 U68_C2_2_MP_INV_1 (.A(al[3]), .Y(al_3_1));
  INVX1 U47_C5_9_MP_INV (.A(al_0_2), .Y(al_0_1));
  NAND3X1 U47_C5_14 (.A(cy_rlc), .B(al[3]), .C(al[2]), .Y(N6482));
  NAND2X1 U47_C5_8 (.A(N1480), .B(N11225), .Y(cy));
  NAND4X1 U47_C5_9 (.A(al_4_1), .B(al_1_2), .C(al_0_1), .D(N7081), .Y(N1480));
  NAND3X1 U66_C2_2 (.A(al_4_1), .B(al_3_1), .C(al_2_1), .Y(U48_C5__n));
endmodule

// Entity:da Model:da Library:L0
module da (d, ac, cy, q);
  input ac, cy;
  input [7:0] d;
  output [7:0] q;
  wire N11639, N6380, N10212, N7057, N11534, N7059, N11782, N7061, N9928, 
     N11451, U76_C3__n, N10535, U76_C3__n_1, d_6_1, ac_1, q_5_1, N11639_2, 
     q_7_1, U42_C1_MP_INV_C1__n, U83_C1_4_C4__n, U83_C1_4_C4__n_1, 
     U65_C3_4_C2__n, U65_C3_4_C2__n_1, U51_C4_2_C4__n, U51_C4_2_C4__n_1, 
     U51_C4_2_C4__n_2, N8473, N8568, N11274, U42_C1_MP_INV_C1__n_1, 
     U65_C3_4_C2__n_3, U51_C4_2_C4__n_5, U51_C4_2_C4__n_6, U83_C1_4_C4__n_3, 
     U51_C4_2_C4__n_7, U51_C4_2_C4__n_8, d_7_1, N11274_1, N11451_1, d_2_1, 
     U51_C4_2_C4__n_9, U51_C4_2_C4__n_3, d_1_1, d_4_1, d_3_1, d_5_1, 
     U83_C1_4_C4__n_2;
  BUFX1 BL1_ASSIGN_BUF162 (.A(d[0]), .Y(q[0]));
  NAND2BX1 U78_C2_4_C4_5 (.AN(U83_C1_4_C4__n_1), .B(N11274_1), .Y(N11274));
  INVX1 U76_C3_1_MP_INV_1 (.A(U76_C3__n), .Y(U76_C3__n_1));
  XOR2X1 U84_C1 (.A(d[7]), .B(N11639), .Y(N6380));
  OAI2BB1X1 U78_C2_2 (.A0N(d[2]), .A1N(d[1]), .B0(U42_C1_MP_INV_C1__n), 
     .Y(N11451));
  AOI21X1 U76_C3_1 (.A0(N8568), .A1(U51_C4_2_C4__n_2), .B0(U76_C3__n_1), 
     .Y(q[3]));
  INVX1 U78_C2_4_C4_1_MP_INV (.A(N11451), .Y(N11451_1));
  OAI21X2 U77_C1_6 (.A0(N6380), .A1(U51_C4_2_C4__n_2), .B0(q_7_1), .Y(q[7]));
  AOI22X1 U51_C4_2_C4_2 (.A0(U51_C4_2_C4__n_3), .A1(U51_C4_2_C4__n_9), 
     .B0(d_1_1), .B1(U51_C4_2_C4__n_2), .Y(q[1]));
  INVX1 U78_C2_4_MP_INV_1 (.A(ac), .Y(ac_1));
  NOR2X2 U83_C1_4_C4_4 (.A(U83_C1_4_C4__n_1), .B(U51_C4_2_C4__n_8), 
     .Y(U51_C4_2_C4__n));
  NOR2X1 U65_C3_4_C2_2 (.A(U65_C3_4_C2__n_1), .B(ac), .Y(U51_C4_2_C4__n_5));
  NAND3X1 U91_C3_2 (.A(d_4_1), .B(d_3_1), .C(U42_C1_MP_INV_C1__n), .Y(N7061));
  NAND4X1 U85_C3_4 (.A(d_4_1), .B(d_3_1), .C(U42_C1_MP_INV_C1__n), .D(N11639_2), 
     .Y(N11639));
  BUFX2 BL2_BUF54 (.A(d[4]), .Y(d_4_1));
  OAI21X1 U78_C2_4_C4_1 (.A0(N11451_1), .A1(U51_C4_2_C4__n_2), .B0(N11274), 
     .Y(q[2]));
  BUFX8 BL2_BUF90 (.A(d[3]), .Y(d_3_1));
  BUFX3 BL2_BUF105 (.A(d[5]), .Y(d_5_1));
  XOR2X1 U53_C1 (.A(d_4_1), .B(U83_C1_4_C4__n_1), .Y(q[4]));
  NOR2X1 U85_C3_2 (.A(d_6_1), .B(N8473), .Y(N11639_2));
  XOR2X1 U69_C1 (.A(d_6_1), .B(N7057), .Y(N7059));
  INVX1 U44_C2_MP_INV_1_C1_MP_INV (.A(U83_C1_4_C4__n_3), .Y(U83_C1_4_C4__n));
  OAI2BB1X1 U94_C2_2 (.A0N(d[6]), .A1N(d_5_1), .B0(U83_C1_4_C4__n), .Y(N11534));
  AOI22X1 U77_C1_5 (.A0(U51_C4_2_C4__n_1), .A1(N10212), .B0(d[7]), 
     .B1(U51_C4_2_C4__n), .Y(q_7_1));
  INVX1 U38_C1_2_C3_2_MP_INV (.A(U65_C3_4_C2__n_3), .Y(U65_C3_4_C2__n));
  XOR2X1 U90_C1 (.A(d_5_1), .B(N7061), .Y(N9928));
  XOR2X1 U67_C1 (.A(d[7]), .B(U83_C1_4_C4__n), .Y(N10212));
  OAI22X4 U94_C2_8 (.A0(N7059), .A1(U51_C4_2_C4__n_2), .B0(U83_C1_4_C4__n_1), 
     .B1(N11782), .Y(q[6]));
  INVX1 U78_C2_4_C4_4_MP_INV (.A(d[2]), .Y(d_2_1));
  INVX4 U76_C3_1_MP_INV_C1 (.A(d_3_1), .Y(N8568));
  XOR2X1 U58_C1 (.A(d_3_1), .B(U42_C1_MP_INV_C1__n), .Y(U76_C3__n));
  AOI2BB2X1 U95_C2_5 (.A0N(N9928), .A1N(U51_C4_2_C4__n_2), .B0(d_5_1), 
     .B1(U51_C4_2_C4__n), .Y(q_5_1));
  INVX1 U51_C4_2_C4_3_MP_INV (.A(d[1]), .Y(d_1_1));
  NOR2X1 U51_C4_2_C4_3 (.A(U51_C4_2_C4__n), .B(d_1_1), .Y(U51_C4_2_C4__n_9));
  NOR2X2 U98_C1_C1 (.A(d[1]), .B(d[2]), .Y(U42_C1_MP_INV_C1__n_1));
  INVX1 U98_C1_C1_MP_INV (.A(U42_C1_MP_INV_C1__n_1), .Y(U42_C1_MP_INV_C1__n));
  AOI211X1 U94_C2_12 (.A0(d[7]), .A1(U83_C1_4_C4__n), .B0(d_6_1), .C0(cy), 
     .Y(N10535));
  INVX1 U44_C2_MP_INV_1_C1_1 (.A(d_5_1), .Y(N8473));
  NOR3X1 U38_C1_2_C3_2 (.A(d[6]), .B(d_5_1), .C(cy), .Y(U65_C3_4_C2__n_3));
  NOR4BX1 U57_C3_3 (.AN(d_4_1), .B(N8473), .C(U42_C1_MP_INV_C1__n_1), .D(N8568), 
     .Y(N7057));
  INVX1 U44_C2_MP_INV (.A(d[6]), .Y(d_6_1));
  NOR2X4 U44_C2_MP_INV_1_C1 (.A(d[6]), .B(d_5_1), .Y(U83_C1_4_C4__n_3));
  AOI31X1 U94_C2_4 (.A0(ac_1), .A1(U65_C3_4_C2__n), .A2(N11534), .B0(N10535), 
     .Y(N11782));
  INVX1 U83_C1_4_C4_3_MP_INV (.A(d[7]), .Y(d_7_1));
  OAI21X1 U83_C1_4_C4_3 (.A0(U83_C1_4_C4__n_3), .A1(d_7_1), 
     .B0(U51_C4_2_C4__n_7), .Y(U51_C4_2_C4__n_8));
  NAND2BX1 U65_C3_4_C2_3 (.AN(U65_C3_4_C2__n_3), .B(U51_C4_2_C4__n_5), 
     .Y(U51_C4_2_C4__n_6));
  NOR2X1 U78_C2_4_C4_4 (.A(d_2_1), .B(ac), .Y(N11274_1));
  NOR2X2 U65_C3_4_C2_4 (.A(U83_C1_4_C4__n_1), .B(U51_C4_2_C4__n_6), 
     .Y(U51_C4_2_C4__n_1));
  NOR2X1 U83_C1_4_C4_2 (.A(cy), .B(ac), .Y(U51_C4_2_C4__n_7));
  NOR2X2 U47_C2_C1 (.A(U83_C1_4_C4__n_1), .B(ac), .Y(U51_C4_2_C4__n_2));
  NOR2X1 U65_C3_4_C2 (.A(d[7]), .B(cy), .Y(U65_C3_4_C2__n_1));
  INVX1 U51_C4_2_C4_2_MP_INV (.A(U51_C4_2_C4__n_1), .Y(U51_C4_2_C4__n_3));
  OAI2BB1X2 U95_C2_6 (.A0N(N8473), .A1N(U51_C4_2_C4__n_1), .B0(q_5_1), .Y(q[5]));
  BUFX8 BL3_S_BUF_6 (.A(U83_C1_4_C4__n_2), .Y(U83_C1_4_C4__n_1));
  NOR2X2 U42_C1_MP_INV_C1 (.A(U42_C1_MP_INV_C1__n_1), .B(N8568), 
     .Y(U83_C1_4_C4__n_2));
endmodule

// Entity:div_test_1 Model:div_test_1 Library:L0
module div_test_1 (clk, rst_p, Load, Dividend, Divisor, Quotient, Remainder, 
     rc8051RtlTop_test_point_535_in, test_si1, test_so1, test_si2, test_so2, 
     test_se, clk0_5, clk0_26);
  input clk, rst_p, Load, rc8051RtlTop_test_point_535_in, test_si1, test_si2, 
     test_se, clk0_5, clk0_26;
  output test_so1, test_so2;
  input [7:0] Dividend;
  input [7:0] Divisor;
  output [7:0] Quotient;
  output [7:0] Remainder;
  wire \CurrentCount[0] , \CurrentCount[1] , \CurrentCount[2] , 
     \CurrentCount[3] , \CurrentCount[4] , \CurrentCount[5] , \CurrentState[0] , 
     \CurrentState[1] , \CurrentState[2] , \RegB[0] , \RegB[1] , \RegB[2] , 
     \RegB[3] , \RegB[4] , \RegB[5] , \RegB[6] , \RegA_minus_RegB[0] , 
     \RegA_minus_RegB[1] , \RegA_minus_RegB[2] , \RegA_minus_RegB[3] , 
     \RegA_minus_RegB[4] , \RegA_minus_RegB[5] , \RegA_minus_RegB[6] , N37, N92, 
     N93, N94, N95, N96, N97, N124, N125, N126, N127, N128, N129, N130, n930, 
     n940, n950, n960, n970, n98, n99, n100, n134, n135, n136, n137, n138, n139, 
     n140, n141, n142, n143, n144, n145, n146, n147, n148, n149, n150, n151, 
     n152, n153, n154, n155, n156, n157, N9966, N9965, N5766, U125_C3__n, 
     U125_C3__n_1, U125_C3__n_2, U172_C2__n, U130_C1__n, U146_C2__n, 
     U146_C2__n_1, U146_C2__n_2, N10634, N10633, N10637, N5770, N5636, N9953, 
     N9952, N9950, N11749, N11748, N11747, N11746, N5746, N10101, N5625, N5626, 
     N12268, N12267, N12266, N2332, N12275, N12274, N12273, N10100, N5750, 
     N12079, N12078, N5605, N5606, N9947, N9946, N9945, N5826, N12066, N5764, 
     N5662, N11366, N11365, N10282, N10281, N5661, N10279, N9223, N7911, N8378, 
     N7844, N4109, N11844, N7291, N10106, N7972, N10103, N11980, N11290, N11500, 
     N4830, N1846, N2012, N9981, N10571, N1432, N12057, N11229, N2733, N247, 
     N4005, N6900, N9384, N8730, U125_C3__n_6, N12274_3, U146_C2__n_7, 
     U130_C1__n_2, Load_1, N5766_1, U146_C2__n_6, U146_C2__n_8, N12273_3, 
     N11749_1, U172_C2__n_1, N10100_3, N9952_1, N9947_2, N9946_3, N9945_3, 
     N5826_3, N5770_1, N5770_2, N10634_1, Load_2, Divisor_6_1, Dividend_0_1, 
     Dividend_3_1, Dividend_2_1;
  supply1 VDD;
  supply0 VSS;
  SDFFSRX1 RegA_reg_6_ (.CK(clk0_5), .D(N10281), .Q(Quotient[6]), .QN(n142), 
     .RN(N9965), .SE(test_se), .SI(Quotient[5]), .SN(VDD));
  SDFFSRX1 RegA_reg_5_ (.CK(clk0_5), .D(N10282), .Q(Quotient[5]), .QN(n147), 
     .RN(N9965), .SE(test_se), .SI(Quotient[4]), .SN(VDD));
  SDFFSRX1 RegA_reg_8_ (.CK(clk0_5), .D(N9947), .Q(Remainder[0]), .QN(n151), 
     .RN(N9965), .SE(test_se), .SI(Quotient[7]), .SN(VDD));
  SDFFSRX1 RegA_reg_9_ (.CK(clk0_26), .D(N5826), .Q(Remainder[1]), .QN(n155), 
     .RN(N9965), .SE(test_se), .SI(Remainder[0]), .SN(VDD));
  AOI222X1 U178_C3_9 (.A0(N129), .A1(N10637), .B0(Remainder[5]), .B1(N10633), 
     .C0(U146_C2__n_8), .C1(\RegA_minus_RegB[6] ), .Y(N10100_3));
  div_DW01_sub_8_0 sub_89 (.A({Remainder[7], Remainder[6], Remainder[5], 
     test_so1, Remainder[3], Remainder[2], Remainder[1], Remainder[0]}), .B({
     test_so2, \RegB[6] , \RegB[5] , \RegB[4] , \RegB[3] , \RegB[2] , \RegB[1] , 
     \RegB[0] }), .CI(VSS), .DIFF({N37, \RegA_minus_RegB[6] , 
     \RegA_minus_RegB[5] , \RegA_minus_RegB[4] , \RegA_minus_RegB[3] , 
     \RegA_minus_RegB[2] , \RegA_minus_RegB[1] , \RegA_minus_RegB[0] }), .CO());
  NAND2X1 U181_C3_3 (.A(U146_C2__n_6), .B(Remainder[6]), .Y(N11229));
  NAND2X1 U204_C3_3 (.A(N96), .B(N11749), .Y(N10106));
  OAI211X1 U196_C3_10 (.A0(n151), .A1(N10634), .B0(N9947_2), .C0(N12057), 
     .Y(N9947));
  AOI22X1 U173_C3_7 (.A0(Remainder[7]), .A1(N10634_1), .B0(U146_C2__n_8), 
     .B1(N37), .Y(N5770_2));
  AOI22X1 U173_C3_6 (.A0(N130), .A1(N10637), .B0(Remainder[6]), .B1(N10633), 
     .Y(N5770_1));
  AOI21X2 U200_C3_1 (.A0(\CurrentState[1] ), .A1(N9952), .B0(U172_C2__n_1), 
     .Y(N11749));
  NAND2X1 U184_C3_3 (.A(U146_C2__n_6), .B(Remainder[5]), .Y(N11980));
  OAI211X1 U193_C3_10 (.A0(n150), .A1(N10634), .B0(N9946_3), .C0(N7844), 
     .Y(N9946));
  NAND2X1 U193_C3_3 (.A(U146_C2__n_6), .B(Remainder[3]), .Y(N7844));
  OAI211X1 U181_C3_10 (.A0(n152), .A1(N10634), .B0(N12273_3), .C0(N11229), 
     .Y(N12273));
  OAI221X1 U206_C3_6 (.A0(U125_C3__n), .A1(\CurrentState[1] ), .B0(n138), 
     .B1(N11749), .C0(N1846), .Y(N5750));
  AOI222X1 U181_C3_9 (.A0(N128), .A1(N10637), .B0(test_so1), .B1(N10633), 
     .C0(U146_C2__n_8), .C1(\RegA_minus_RegB[5] ), .Y(N12273_3));
  OAI2BB2X1 U211_C4_1 (.A0N(N93), .A1N(N11748), .B0(n135), .B1(N11749), 
     .Y(N5625));
  SDFFSRX1 CurrentCount_reg_3_ (.CK(clk0_26), .D(N12268), .Q(\CurrentCount[3] ), 
     .QN(n139), .RN(N9965), .SE(test_se), .SI(\CurrentCount[2] ), .SN(VDD));
  OAI2BB2X1 U209_C4_1 (.A0N(N95), .A1N(N11748), .B0(n139), .B1(N11749), 
     .Y(N12268));
  AND4X1 U155_C1_4 (.A(n144), .B(n139), .C(n138), .D(n134), .Y(U125_C3__n_6));
  SDFFSX1 CurrentCount_reg_0_ (.CK(clk0_26), .D(N5750), .Q(\CurrentCount[0] ), 
     .QN(n138), .SE(test_se), .SI(test_si1), .SN(N9965));
  OAI21X1 U167_C4_1 (.A0(n940), .A1(Load_2), .B0(N247), .Y(N12078));
  NAND2X1 U160_C4_2 (.A(Load_2), .B(Divisor[0]), .Y(N7972));
  SDFFSRX1 RegA_reg_7_ (.CK(clk0_5), .D(N10279), .Q(Quotient[7]), .QN(n157), 
     .RN(N9965), .SE(test_se), .SI(Quotient[6]), .SN(VDD));
  OAI21X1 U166_C4_1 (.A0(n950), .A1(Load_2), .B0(N8378), .Y(N5605));
  BUFX3 BL1_BUF314 (.A(Load), .Y(Load_2));
  NAND2X1 U138_C5_2 (.A(Load_2), .B(Dividend[5]), .Y(N11844));
  NAND2X1 U136_C5_2 (.A(Load_2), .B(Dividend[6]), .Y(N4830));
  OAI221X1 U168_C5_6 (.A0(n142), .A1(N5764), .B0(n157), .B1(U146_C2__n_2), 
     .C0(N4005), .Y(N10279));
  SDFFSRX1 RegA_reg_10_ (.CK(clk0_26), .D(N9946), .Q(Remainder[2]), .QN(n150), 
     .RN(N9965), .SE(test_se), .SI(Remainder[1]), .SN(VDD));
  AOI222X1 U193_C3_9 (.A0(N125), .A1(N10637), .B0(Remainder[1]), .B1(N10633), 
     .C0(U146_C2__n_8), .C1(\RegA_minus_RegB[2] ), .Y(N9946_3));
  NAND2X1 U190_C3_3 (.A(U146_C2__n_6), .B(Remainder[2]), .Y(N7291));
  BUFX1 BL1_ASSIGN_BUF21 (.A(test_so1), .Y(Remainder[4]));
  SDFFSRX1 RegB_reg_5_ (.CK(clk0_5), .D(N2332), .Q(\RegB[5] ), .QN(n98), 
     .RN(N9965), .SE(test_se), .SI(\RegB[4] ), .SN(VDD));
  NAND2X1 U144_C5_2 (.A(Load_2), .B(Dividend[1]), .Y(N1432));
  INVX1 U130_C1_2_MP_INV_2 (.A(N5766), .Y(N5766_1));
  OAI22X1 U170_C3_3 (.A0(U125_C3__n), .A1(N5746), .B0(n143), .B1(U172_C2__n), 
     .Y(N10101));
  NAND2X1 U134_C5_2 (.A(Load_2), .B(Dividend_2_1), .Y(N11290));
  SDFFSRX1 RegA_reg_2_ (.CK(clk0_5), .D(N11366), .Q(Quotient[2]), .QN(n141), 
     .RN(N9965), .SE(test_se), .SI(Quotient[1]), .SN(VDD));
  NAND2X1 U142_C5_2 (.A(Load_2), .B(Dividend_3_1), .Y(N10103));
  NAND2X1 U163_C4_3 (.A(Load_2), .B(Divisor[5]), .Y(N7911));
  SDFFSRX1 RegA_reg_3_ (.CK(clk0_5), .D(N5661), .Q(Quotient[3]), .QN(n148), 
     .RN(N9965), .SE(test_se), .SI(Quotient[2]), .SN(VDD));
  NAND2X1 U161_C4_2 (.A(Load_2), .B(Divisor[7]), .Y(N6900));
  OAI221X1 U144_C5_6 (.A0(n136), .A1(U146_C2__n_2), .B0(n149), .B1(N5764), 
     .C0(N1432), .Y(N5662));
  INVX3 U214_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N9965));
  NAND3X1 U150_C4_6 (.A(U130_C1__n_2), .B(N9223), .C(N5766_1), .Y(N9953));
  SDFFSRX1 CurrentState_reg_1_ (.CK(clk0_5), .D(N9953), .Q(\CurrentState[1] ), 
     .QN(n143), .RN(N9965), .SE(test_se), .SI(\CurrentState[0] ), .SN(VDD));
  NOR3X1 U202_C2_2 (.A(n137), .B(\CurrentState[1] ), .C(\CurrentState[0] ), 
     .Y(U130_C1__n));
  SDFFSRX1 CurrentState_reg_2_ (.CK(clk0_5), .D(N9950), .Q(\CurrentState[2] ), 
     .QN(n137), .RN(N9965), .SE(test_se), .SI(\CurrentState[1] ), .SN(VDD));
  OAI2BB1X1 U153_C3_1 (.A0N(n146), .A1N(U125_C3__n_1), .B0(n137), .Y(N9952));
  BUFX1 BL2_BUF63 (.A(Dividend[0]), .Y(Dividend_0_1));
  SDFFSRX1 RegB_reg_7_ (.CK(clk0_5), .D(N9966), .Q(test_so2), .QN(n100), 
     .RN(N9965), .SE(test_se), .SI(\RegB[6] ), .SN(VDD));
  OAI211X1 U196_C3_8 (.A0(U130_C1__n), .A1(N5766), .B0(Quotient[7]), .C0(Load_1), 
     .Y(N12057));
  OAI21X1 U150_C4_1 (.A0(U125_C3__n_1), .A1(N37), .B0(n137), .Y(N5636));
  OAI21X1 U162_C4_1 (.A0(n99), .A1(Load_2), .B0(N10571), .Y(N12275));
  NAND2X1 U140_C5_2 (.A(Load_2), .B(Dividend[4]), .Y(N2733));
  OAI21X1 U160_C4_1 (.A0(n930), .A1(Load_2), .B0(N7972), .Y(N12079));
  OAI2BB2X1 U203_C4_1 (.A0N(N97), .A1N(N11748), .B0(n145), .B1(N11749), 
     .Y(N11747));
  INVX1 U146_C2_2_MP_INV_1 (.A(U146_C2__n_1), .Y(U146_C2__n_6));
  NAND2X1 U173_C3_8 (.A(N5770_2), .B(N5770_1), .Y(N5770));
  NOR2X2 U149_C1 (.A(Load_2), .B(N5766_1), .Y(N10633));
  NAND2X1 U178_C3_3 (.A(U146_C2__n_6), .B(Remainder[7]), .Y(N4109));
  SDFFSRX1 CurrentCount_reg_5_ (.CK(clk0_26), .D(N11747), .Q(\CurrentCount[5] ), 
     .QN(n145), .RN(N9965), .SE(test_se), .SI(\CurrentCount[4] ), .SN(VDD));
  AOI222X1 U190_C3_9 (.A0(N124), .A1(N10637), .B0(Remainder[0]), .B1(N10633), 
     .C0(U146_C2__n_8), .C1(\RegA_minus_RegB[1] ), .Y(N5826_3));
  SDFFRHQX2 RegA_reg_15_ (.CK(clk0_26), .D(N5770), .Q(Remainder[7]), .RN(N9965), 
     .SE(test_se), .SI(Remainder[6]));
  SDFFSRX1 RegA_reg_0_ (.CK(clk0_5), .D(N12066), .Q(Quotient[0]), .QN(n149), 
     .RN(N9965), .SE(test_se), .SI(\CurrentState[2] ), .SN(VDD));
  NAND2BX1 U176_C4_3 (.AN(\CurrentState[0] ), .B(N37), .Y(N11500));
  AOI21X1 U176_C4_1 (.A0(N9952_1), .A1(N11500), .B0(n143), .Y(N9950));
  INVX1 U146_C2_2_MP_INV (.A(U146_C2__n_2), .Y(U146_C2__n_7));
  div_DW01_dec_6_0 r74 (.A({\CurrentCount[5] , \CurrentCount[4] , 
     \CurrentCount[3] , \CurrentCount[2] , \CurrentCount[1] , \CurrentCount[0] }), 
     .SUM({N97, N96, N95, N94, N93, N92}));
  SDFFSRX1 RegB_reg_3_ (.CK(clk0_5), .D(N5606), .Q(\RegB[3] ), .QN(n960), 
     .RN(N9965), .SE(test_se), .SI(\RegB[2] ), .SN(VDD));
  SDFFSRX1 RegB_reg_1_ (.CK(clk0_5), .D(N12078), .Q(\RegB[1] ), .QN(n940), 
     .RN(N9965), .SE(test_se), .SI(\RegB[0] ), .SN(VDD));
  SDFFSX1 CurrentCount_reg_4_ (.CK(clk0_26), .D(N12267), .Q(\CurrentCount[4] ), 
     .QN(n134), .SE(test_se), .SI(\CurrentCount[3] ), .SN(N9965));
  OAI221X1 U204_C3_6 (.A0(U125_C3__n), .A1(\CurrentState[1] ), .B0(n134), 
     .B1(N11749), .C0(N10106), .Y(N12267));
  div_DW01_add_7_0 add_124 (.A({Remainder[6], Remainder[5], test_so1, 
     Remainder[3], Remainder[2], Remainder[1], Remainder[0]}), .B({\RegB[6] , 
     \RegB[5] , \RegB[4] , \RegB[3] , \RegB[2] , \RegB[1] , \RegB[0] }), .CI(VSS), 
     .SUM({N130, N129, N128, N127, N126, N125, N124}), .CO());
  NAND3X1 U146_C2_2 (.A(U146_C2__n_7), .B(U146_C2__n_1), .C(U146_C2__n), 
     .Y(N10634));
  NAND2BX1 U170_C3 (.AN(U125_C3__n_1), .B(N37), .Y(N11746));
  OAI211X1 U208_C3_4 (.A0(n143), .A1(N11749_1), .B0(U130_C1__n_2), .C0(N5766_1), 
     .Y(N11748));
  OR3X1 U172_C2_3 (.A(U172_C2__n), .B(Load_2), .C(\CurrentState[1] ), 
     .Y(U146_C2__n_1));
  INVX1 U146_C2_2_MP_INV_2 (.A(U146_C2__n), .Y(U146_C2__n_8));
  AND3X1 U155_C1_5 (.A(n145), .B(n135), .C(U125_C3__n_6), .Y(U125_C3__n_1));
  SDFFSRX2 RegA_reg_12_ (.CK(clk0_26), .D(N12274), .Q(test_so1), .QN(n153), 
     .RN(N9965), .SE(test_se), .SI(Remainder[3]), .SN(VDD));
  NAND2X1 U187_C3_3 (.A(U146_C2__n_6), .B(test_so1), .Y(N2012));
  OAI211X1 U187_C3_10 (.A0(n154), .A1(N10634), .B0(N9945_3), .C0(N2012), 
     .Y(N9945));
  OAI211X1 U184_C3_10 (.A0(n153), .A1(N10634), .B0(N12274_3), .C0(N11980), 
     .Y(N12274));
  SDFFSRX1 CurrentCount_reg_1_ (.CK(clk0_26), .D(N5625), .Q(\CurrentCount[1] ), 
     .QN(n135), .RN(N9965), .SE(test_se), .SI(\CurrentCount[0] ), .SN(VDD));
  SDFFSRX1 RegA_reg_14_ (.CK(clk0_26), .D(N10100), .Q(Remainder[6]), .QN(n156), 
     .RN(N9965), .SE(test_se), .SI(Remainder[5]), .SN(VDD));
  OAI2BB2X1 U210_C4_1 (.A0N(N94), .A1N(N11748), .B0(n144), .B1(N11749), 
     .Y(N5626));
  SDFFSRX1 CurrentCount_reg_2_ (.CK(clk0_26), .D(N5626), .Q(\CurrentCount[2] ), 
     .QN(n144), .RN(N9965), .SE(test_se), .SI(\CurrentCount[1] ), .SN(VDD));
  OAI211X1 U178_C3_10 (.A0(n156), .A1(N10634), .B0(N4109), .C0(N10100_3), 
     .Y(N10100));
  NAND2X1 U206_C3_3 (.A(N92), .B(N11749), .Y(N1846));
  SDFFSRX1 RegA_reg_13_ (.CK(clk0_26), .D(N12273), .Q(Remainder[5]), .QN(n152), 
     .RN(N9965), .SE(test_se), .SI(test_si2), .SN(VDD));
  SDFFSRX1 RegB_reg_2_ (.CK(clk0_5), .D(N5605), .Q(\RegB[2] ), .QN(n950), 
     .RN(N9965), .SE(test_se), .SI(\RegB[1] ), .SN(VDD));
  NAND2X1 U165_C4_3 (.A(Load_2), .B(Divisor[3]), .Y(N9981));
  SDFFSRX1 RegB_reg_0_ (.CK(clk0_5), .D(N12079), .Q(\RegB[0] ), .QN(n930), 
     .RN(N9965), .SE(test_se), .SI(Remainder[7]), .SN(VDD));
  NAND2X1 U166_C4_2 (.A(Load_2), .B(Divisor[2]), .Y(N8378));
  OAI221X1 U138_C5_6 (.A0(n140), .A1(N5764), .B0(n147), .B1(U146_C2__n_2), 
     .C0(N11844), .Y(N10282));
  NAND2X1 U168_C5_2 (.A(Load_2), .B(Dividend[7]), .Y(N4005));
  OAI221X1 U136_C5_6 (.A0(n142), .A1(U146_C2__n_2), .B0(n147), .B1(N5764), 
     .C0(N4830), .Y(N10281));
  OAI21X1 U165_C4_1 (.A0(n960), .A1(Load_2), .B0(N9981), .Y(N5606));
  AOI222X1 U184_C3_9 (.A0(N127), .A1(N10637), .B0(Remainder[3]), .B1(N10633), 
     .C0(U146_C2__n_8), .C1(\RegA_minus_RegB[4] ), .Y(N12274_3));
  OAI211X1 U190_C3_10 (.A0(n155), .A1(N10634), .B0(N7291), .C0(N5826_3), 
     .Y(N5826));
  AOI222X1 U187_C3_9 (.A0(N126), .A1(N10637), .B0(Remainder[2]), .B1(N10633), 
     .C0(U146_C2__n_8), .C1(\RegA_minus_RegB[3] ), .Y(N9945_3));
  SDFFSRX1 RegA_reg_11_ (.CK(clk0_26), .D(N9945), .Q(Remainder[3]), .QN(n154), 
     .RN(N9965), .SE(test_se), .SI(Remainder[2]), .SN(VDD));
  SDFFSRX1 RegB_reg_4_ (.CK(clk0_5), .D(N12266), .Q(\RegB[4] ), .QN(n970), 
     .RN(N9965), .SE(test_se), .SI(\RegB[3] ), .SN(VDD));
  NAND2X1 U164_C4_2 (.A(Load_2), .B(Divisor[4]), .Y(N9384));
  SDFFSRX1 RegA_reg_1_ (.CK(clk0_5), .D(N5662), .Q(Quotient[1]), .QN(n136), 
     .RN(N9965), .SE(test_se), .SI(Quotient[0]), .SN(VDD));
  OR2X1 U154_C1 (.A(n146), .B(n137), .Y(U172_C2__n));
  SDFFSRX1 RegA_reg_4_ (.CK(clk0_5), .D(N11365), .Q(Quotient[4]), .QN(n140), 
     .RN(N9965), .SE(test_se), .SI(Quotient[3]), .SN(VDD));
  OAI221X1 U142_C5_6 (.A0(n141), .A1(N5764), .B0(n148), .B1(U146_C2__n_2), 
     .C0(N10103), .Y(N5661));
  BUFX1 BL2_BUF103 (.A(Dividend[2]), .Y(Dividend_2_1));
  BUFX1 BL2_BUF93 (.A(Dividend[3]), .Y(Dividend_3_1));
  NAND2X1 U167_C4_3 (.A(Load_2), .B(Divisor[1]), .Y(N247));
  OAI221X1 U134_C5_6 (.A0(n136), .A1(N5764), .B0(n141), .B1(U146_C2__n_2), 
     .C0(N11290), .Y(N11366));
  OAI221X1 U140_C5_6 (.A0(n140), .A1(U146_C2__n_2), .B0(n148), .B1(N5764), 
     .C0(N2733), .Y(N11365));
  OAI21X1 U161_C4_1 (.A0(n100), .A1(Load_2), .B0(N6900), .Y(N9966));
  INVX1 U130_C1_2_MP_INV (.A(U130_C1__n), .Y(U130_C1__n_2));
  INVX1 U176_C4_1_MP_INV (.A(N9952), .Y(N9952_1));
  OR2X1 U212_C1 (.A(\CurrentState[2] ), .B(\CurrentState[0] ), .Y(U125_C3__n));
  SDFFSRX1 RegB_reg_6_ (.CK(clk0_5), .D(N12275), .Q(\RegB[6] ), .QN(n99), 
     .RN(N9965), .SE(test_se), .SI(\RegB[5] ), .SN(VDD));
  OAI21X1 U164_C4_1 (.A0(n970), .A1(Load_2), .B0(N9384), .Y(N12266));
  NAND3X1 U130_C1_2 (.A(U130_C1__n_2), .B(Load_1), .C(N5766_1), .Y(U146_C2__n_2));
  NAND2X1 U128_C2 (.A(U146_C2__n_2), .B(Load_1), .Y(N5764));
  NAND2X1 U162_C4_2 (.A(Load_2), .B(Divisor_6_1), .Y(N10571));
  AOI22X1 U170_C3_2 (.A0(\CurrentState[1] ), .A1(N11746), .B0(n143), .B1(Load_2), 
     .Y(N5746));
  NAND2X1 U150_C4_3 (.A(\CurrentState[1] ), .B(N5636), .Y(N9223));
  NAND2X1 U133_C5_2 (.A(Load_2), .B(Dividend_0_1), .Y(N8730));
  BUFX1 BL2_BUF36 (.A(Divisor[6]), .Y(Divisor_6_1));
  INVX1 U173_C3_7_MP_INV (.A(N10634), .Y(N10634_1));
  INVX1 U200_C3_1_MP_INV (.A(U172_C2__n), .Y(U172_C2__n_1));
  OAI2BB1X1 U147_C3_1 (.A0N(n143), .A1N(N5766), .B0(Load_1), .Y(U125_C3__n_2));
  OR4X1 U125_C3_4 (.A(n143), .B(U125_C3__n_2), .C(U125_C3__n_1), .D(U125_C3__n), 
     .Y(U146_C2__n));
  SDFFSRX1 CurrentState_reg_0_ (.CK(clk0_5), .D(N10101), .Q(\CurrentState[0] ), 
     .QN(n146), .RN(N9965), .SE(test_se), .SI(\CurrentCount[5] ), .SN(VDD));
  NOR2X2 U148_C1 (.A(U130_C1__n_2), .B(U125_C3__n_2), .Y(N10637));
  INVX1 U208_C3_4_MP_INV_1 (.A(N11749), .Y(N11749_1));
  AOI22X1 U196_C3_9 (.A0(U146_C2__n_8), .A1(\RegA_minus_RegB[0] ), 
     .B0(U146_C2__n_6), .B1(Remainder[1]), .Y(N9947_2));
  OAI221X1 U133_C5_6 (.A0(U125_C3__n_2), .A1(N5766_1), .B0(n149), 
     .B1(U146_C2__n_2), .C0(N8730), .Y(N12066));
  NOR2X1 U201_C1 (.A(n146), .B(\CurrentState[2] ), .Y(N5766));
  INVX1 U130_C1_2_MP_INV_1 (.A(Load_2), .Y(Load_1));
  OAI21X1 U163_C4_1 (.A0(n98), .A1(Load_2), .B0(N7911), .Y(N2332));
endmodule

// Entity:div_DW01_add_7_0 Model:div_DW01_add_7_0 Library:L0
module div_DW01_add_7_0 (A, B, CI, SUM, CO);
  input CI;
  output CO;
  input [6:0] A;
  input [6:0] B;
  output [6:0] SUM;
  wire carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, N12175, N10277;
  XOR2X1 U5_C1 (.A(B[0]), .B(A[0]), .Y(SUM[0]));
  AND2X1 U4_C1 (.A(B[0]), .B(A[0]), .Y(N10277));
  XOR2X1 U1_6_C2_1 (.A(carry_6_), .B(N12175), .Y(SUM[6]));
  XOR2X1 U1_6_C2 (.A(B[6]), .B(A[6]), .Y(N12175));
  ADDFX1 U1_5 (.A(A[5]), .B(B[5]), .CI(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDFX1 U1_4 (.A(A[4]), .B(B[4]), .CI(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDFX1 U1_3 (.A(A[3]), .B(B[3]), .CI(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDFX1 U1_1 (.A(A[1]), .B(B[1]), .CI(N10277), .CO(carry_2_), .S(SUM[1]));
  ADDFX1 U1_2 (.A(A[2]), .B(B[2]), .CI(carry_2_), .CO(carry_3_), .S(SUM[2]));
endmodule

// Entity:div_DW01_dec_6_0 Model:div_DW01_dec_6_0 Library:L0
module div_DW01_dec_6_0 (A, SUM);
  input [5:0] A;
  output [5:0] SUM;
  wire U1_B_2_C1__n, U1_B_3_C1__n, U1_B_4_C1__n, N7859;
  XNOR2X1 U1_A_4_C1 (.A(U1_B_4_C1__n), .B(A[4]), .Y(SUM[4]));
  OR2X1 U1_B_4_C1 (.A(U1_B_4_C1__n), .B(A[4]), .Y(N7859));
  XNOR2X1 U1_A_5_C1 (.A(A[5]), .B(N7859), .Y(SUM[5]));
  XOR2X1 U1_A_1_C1 (.A(A[1]), .B(SUM[0]), .Y(SUM[1]));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  XNOR2X1 U1_A_2_C1 (.A(U1_B_2_C1__n), .B(A[2]), .Y(SUM[2]));
  XNOR2X1 U1_A_3_C1 (.A(U1_B_3_C1__n), .B(A[3]), .Y(SUM[3]));
  OR2X1 U1_B_2_C1 (.A(U1_B_2_C1__n), .B(A[2]), .Y(U1_B_3_C1__n));
  OR2X1 U1_B_3_C1 (.A(U1_B_3_C1__n), .B(A[3]), .Y(U1_B_4_C1__n));
  OR2X1 U1_B_1_C1 (.A(A[1]), .B(A[0]), .Y(U1_B_2_C1__n));
endmodule

// Entity:div_DW01_sub_8_0 Model:div_DW01_sub_8_0 Library:L0
module div_DW01_sub_8_0 (A, B, CI, DIFF, CO);
  input CI;
  output CO;
  input [7:0] A;
  input [7:0] B;
  output [7:0] DIFF;
  wire \B_not[1] , \B_not[2] , \B_not[3] , \B_not[4] , \B_not[5] , \B_not[6] , 
     carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, N7901, N10278;
  ADDFX1 U2_6 (.A(A[6]), .B(\B_not[6] ), .CI(carry_6_), .CO(carry_7_), 
     .S(DIFF[6]));
  ADDFX1 U2_1 (.A(A[1]), .B(\B_not[1] ), .CI(N10278), .CO(carry_2_), .S(DIFF[1]));
  NAND2BX1 U14_C1 (.AN(A[0]), .B(B[0]), .Y(N10278));
  INVX1 U7_C1 (.A(B[1]), .Y(\B_not[1] ));
  XNOR2X1 U2_7_C2 (.A(B[7]), .B(A[7]), .Y(N7901));
  XOR2X1 U15_C1 (.A(B[0]), .B(A[0]), .Y(DIFF[0]));
  XOR2X1 U2_7_C2_1 (.A(carry_7_), .B(N7901), .Y(DIFF[7]));
  INVX1 U8_C1 (.A(B[6]), .Y(\B_not[6] ));
  INVX1 U10_C1 (.A(B[4]), .Y(\B_not[4] ));
  ADDFX1 U2_2 (.A(A[2]), .B(\B_not[2] ), .CI(carry_2_), .CO(carry_3_), 
     .S(DIFF[2]));
  ADDFX1 U2_3 (.A(A[3]), .B(\B_not[3] ), .CI(carry_3_), .CO(carry_4_), 
     .S(DIFF[3]));
  INVX1 U12_C1 (.A(B[2]), .Y(\B_not[2] ));
  INVX1 U11_C1 (.A(B[3]), .Y(\B_not[3] ));
  ADDFX1 U2_4 (.A(A[4]), .B(\B_not[4] ), .CI(carry_4_), .CO(carry_5_), 
     .S(DIFF[4]));
  ADDFX1 U2_5 (.A(A[5]), .B(\B_not[5] ), .CI(carry_5_), .CO(carry_6_), 
     .S(DIFF[5]));
  INVX1 U9_C1 (.A(B[5]), .Y(\B_not[5] ));
endmodule

// Entity:mux16t1_8 Model:mux16t1_8 Library:L0
module mux16t1_8 (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3, b4, 
     b5, sel, qq);
  input [7:0] a0;
  input [7:0] a1;
  input [7:0] a2;
  input [7:0] a3;
  input [7:0] a4;
  input [7:0] a5;
  input [7:0] a6;
  input [7:0] a7;
  input [7:0] a8;
  input [7:0] a9;
  input [7:0] b0;
  input [7:0] b1;
  input [7:0] b2;
  input [7:0] b3;
  input [7:0] b4;
  input [7:0] b5;
  input [3:0] sel;
  output [7:0] qq;
  wire U278_C1__n, U278_C1__n_1, U288_C1__n, N10367, N10366, U285_C1__n, N5762, 
     N11566, N5725, U229_C1__n, U286_C1__n, N5702, N5668, N11564, N5724, 
     U356_C1__n, U280_C1__n, U283_C1__n, N11239, N5649, N5665, N11591, N5830, 
     N5651, N5761, N11885, U248_C1__n, U354_C1__n, N10849, U217_C3__n, N10394, 
     N11884, N5597, N11614, U221_C1__n, U349_C1__n, U349_C1__n_1, N5714, N10819, 
     U226_C2__n, N10755, U360_C1__n, N5717, N11967, N10672, N8186, U367_C1__n, 
     N5831, U214_C3__n, N5743, N11670, N5835, U394_C1__n, U395_C1__n, N11461, 
     U448_C1__n, N12258, N11924, N10805, N10614, N1328, U448_C1__n_2, 
     U448_C1__n_3, N11566_1, U445_C1__n_4, U445_C1__n_5, N11924_1, N11427_1, 
     N11427_2, U221_C1__n_1, U221_C1__n_2, U395_C1__n_3, U395_C1__n_4, N10971_1, 
     N5827_1, N5708_2, N5708_3, U349_C1__n_2, U349_C1__n_3, U349_C1__n_5, 
     N5822_1, U226_C2__n_3, U226_C2__n_4, U360_C1__n_2, U360_C1__n_3, 
     U217_C3__n_3, U217_C3__n_4, U367_C1__n_3, U367_C1__n_4, U394_C1__n_3, 
     U394_C1__n_4, U354_C1__n_3, U354_C1__n_4, U214_C3__n_3, U214_C3__n_4, 
     U356_C1__n_2, U356_C1__n_3, N5707_1, N5707_2, U248_C1__n_1, U248_C1__n_2, 
     N3933, N2252, N5607, N4984, qq_4_1, qq_4_2, N10394_1, U354_C1__n_1, qq_7_1, 
     qq_7_2, N5743_1, a0_6_1, qq_5_1, U360_C1__n_1, qq_3_1, N12258_1, qq_2_1, 
     qq_2_2, qq_2_3, N10366_1, qq_1_1, qq_1_2, qq_1_4, qq_0_1, qq_0_2, N11967_1, 
     qq_5_2, qq_1_5;
  NAND2X4 U444_C2_4 (.A(N11924), .B(qq_3_1), .Y(qq[3]));
  NAND2X1 U241_C3_2 (.A(a0[5]), .B(N5762), .Y(N3933));
  AOI21X1 U444_C2_3 (.A0(a0[3]), .A1(N5762), .B0(N12258_1), .Y(qq_3_1));
  AOI22X1 U360_C1_8 (.A0(a4[5]), .A1(N11564), .B0(a7[5]), .B1(N5702), 
     .Y(U360_C1__n_2));
  AOI22X1 U197_C2_5 (.A0(b0[6]), .A1(N5651), .B0(b3[6]), .B1(N5649), 
     .Y(N10971_1));
  AOI22X2 U461_C2_1 (.A0(a2[6]), .A1(N10367), .B0(a3[6]), .B1(N10366), 
     .Y(U349_C1__n_5));
  AOI22X1 U332_C2_1 (.A0(b0[7]), .A1(N5651), .B0(b1[7]), .B1(N5830), .Y(N5831));
  AOI22X1 U248_C1_7 (.A0(a8[0]), .A1(N5761), .B0(a9[0]), .B1(N11885), 
     .Y(U248_C1__n_1));
  AOI22X1 U249_C1_6 (.A0(b4[0]), .A1(N5665), .B0(b5[0]), .B1(N11591), 
     .Y(N5707_1));
  INVX1 U356_C1_9_MP_INV (.A(U356_C1__n_2), .Y(U356_C1__n_3));
  AOI22X1 U356_C1_8 (.A0(a6[0]), .A1(N5668), .B0(a7[0]), .B1(N5702), 
     .Y(U356_C1__n_2));
  NAND4X1 U202_C3_7 (.A(U349_C1__n_3), .B(U349_C1__n_2), .C(N10971_1), 
     .D(N10805), .Y(U349_C1__n));
  NOR2BX4 U366_C3_4 (.AN(N11670), .B(qq_7_1), .Y(qq_7_2));
  AOI221X4 U356_C1_9 (.A0(a4[0]), .A1(N11564), .B0(a5[0]), .B1(N5724), 
     .C0(U356_C1__n_3), .Y(U356_C1__n));
  AND4X1 U248_C1_10 (.A(U248_C1__n_2), .B(U248_C1__n_1), .C(N5707_2), 
     .D(N5707_1), .Y(U248_C1__n));
  NAND2X1 U247_C1 (.A(N11566_1), .B(a1[0]), .Y(N11967));
  AOI222X1 U367_C1_10 (.A0(a1[7]), .A1(N11566_1), .B0(a4[7]), .B1(N11564), 
     .C0(a5[7]), .C1(N5724), .Y(U367_C1__n_3));
  AOI222X1 U353_C2_9 (.A0(a7[6]), .A1(N5702), .B0(b4[6]), .B1(N5665), .C0(b5[6]), 
     .C1(N11591), .Y(N5708_3));
  INVX1 U367_C1_11_MP_INV (.A(U367_C1__n_3), .Y(U367_C1__n_4));
  AOI221X1 U367_C1_11 (.A0(a6[7]), .A1(N5668), .B0(a7[7]), .B1(N5702), 
     .C0(U367_C1__n_4), .Y(U367_C1__n));
  AND2X2 U278_C1 (.A(U278_C1__n_1), .B(U278_C1__n), .Y(N10367));
  NAND2X1 U209_C1_4 (.A(a0[2]), .B(N5762), .Y(N2252));
  AND2X2 U283_C1 (.A(U283_C1__n), .B(U278_C1__n_1), .Y(N5651));
  AND2X2 U291_C1 (.A(sel[2]), .B(sel[1]), .Y(U229_C1__n));
  INVX1 U209_C1_5_MP_INV (.A(N10366), .Y(N10366_1));
  NAND2X1 U277_C1 (.A(U288_C1__n), .B(U285_C1__n), .Y(N11566));
  AOI22X1 U411_C2_1 (.A0(b2[4]), .A1(N11239), .B0(b3[4]), .B1(N5649), .Y(N10849));
  AND2X2 U285_C1 (.A(U285_C1__n), .B(U278_C1__n), .Y(N5762));
  NOR3BX2 U215_C3_2 (.AN(U349_C1__n_5), .B(N5762), .C(U349_C1__n), .Y(N10819));
  INVX2 U461_C2_1_MP_INV (.A(U349_C1__n_5), .Y(U349_C1__n_1));
  AOI221X1 U214_C3_13 (.A0(b2[7]), .A1(N11239), .B0(b3[7]), .B1(N5649), 
     .C0(U214_C3__n), .Y(N5743));
  INVX1 U366_C3_3_MP_INV (.A(N5743), .Y(N5743_1));
  INVX1 U394_C1_11_MP_INV (.A(U394_C1__n_3), .Y(U394_C1__n_4));
  AOI222X1 U395_C1_10 (.A0(a4[2]), .A1(N11564), .B0(b4[2]), .B1(N5665), 
     .C0(b5[2]), .C1(N11591), .Y(U395_C1__n_3));
  AOI21X1 U218_C3_5 (.A0(a0[1]), .A1(N5762), .B0(qq_1_2), .Y(qq_1_4));
  AOI222X1 U307_C3_1 (.A0(a8[3]), .A1(N5761), .B0(a9[3]), .B1(N11885), 
     .C0(b1[3]), .C1(N5830), .Y(N11461));
  AOI22X1 U217_C3_10 (.A0(b4[4]), .A1(N5665), .B0(b5[4]), .B1(N11591), 
     .Y(U217_C3__n_4));
  INVX1 U216_C3_3_MP_INV (.A(N10394), .Y(N10394_1));
  AOI22X1 U217_C3_9 (.A0(b0[4]), .A1(N5651), .B0(b1[4]), .B1(N5830), 
     .Y(U217_C3__n_3));
  NOR2BX1 U294_C2 (.AN(sel[0]), .B(sel[3]), .Y(U288_C1__n));
  NAND2BX1 U209_C1_5 (.AN(N10366_1), .B(a3[2]), .Y(N5607));
  NOR2BX1 U289_C2 (.AN(sel[2]), .B(sel[1]), .Y(U286_C1__n));
  AND2X2 U230_C1 (.A(U286_C1__n), .B(U283_C1__n), .Y(N11239));
  NOR2X1 U290_C1 (.A(sel[1]), .B(sel[2]), .Y(U285_C1__n));
  AOI22X1 U459_C2_2 (.A0(a2[5]), .A1(N10367), .B0(a3[5]), .B1(N10366), .Y(N5717));
  AOI22X1 U469_C1_6 (.A0(a8[1]), .A1(N5761), .B0(a9[1]), .B1(N11885), 
     .Y(N11427_1));
  AND4X1 U221_C1_10 (.A(U221_C1__n_2), .B(U221_C1__n_1), .C(N11427_2), 
     .D(N11427_1), .Y(U221_C1__n));
  AOI22X1 U221_C1_7 (.A0(b4[1]), .A1(N5665), .B0(b5[1]), .B1(N11591), 
     .Y(U221_C1__n_1));
  AOI22X1 U469_C1_7 (.A0(b0[1]), .A1(N5651), .B0(b1[1]), .B1(N5830), 
     .Y(N11427_2));
  AOI22X1 U221_C1_8 (.A0(b2[1]), .A1(N11239), .B0(b3[1]), .B1(N5649), 
     .Y(U221_C1__n_2));
  AOI22X1 U307_C3_8 (.A0(b0[3]), .A1(N5651), .B0(b5[3]), .B1(N11591), 
     .Y(U448_C1__n_2));
  AND2X2 U229_C1 (.A(U288_C1__n), .B(U229_C1__n), .Y(N5702));
  NOR2BX1 U392_C3_4 (.AN(U395_C1__n), .B(qq_2_2), .Y(qq_2_3));
  AND2X2 U286_C1 (.A(U286_C1__n), .B(U278_C1__n), .Y(N11564));
  INVX1 U444_C2_3_MP_INV (.A(N12258), .Y(N12258_1));
  NAND3X1 U307_C3_11 (.A(U448_C1__n_3), .B(U448_C1__n_2), .C(N11461), 
     .Y(U448_C1__n));
  AOI22X1 U226_C2_9 (.A0(a8[5]), .A1(N5761), .B0(a9[5]), .B1(N11885), 
     .Y(U226_C2__n_3));
  NAND2X1 U303_C2_2 (.A(b2[5]), .B(N11239), .Y(N10614));
  NAND4X1 U226_C2_12 (.A(U226_C2__n_4), .B(U226_C2__n_3), .C(N5822_1), 
     .D(N10614), .Y(U226_C2__n));
  NAND2BX1 U241_C3_3_INV (.AN(U360_C1__n_1), .B(N10755), .Y(qq_5_2));
  INVX1 U211_C1 (.A(a1[1]), .Y(N5725));
  INVX1 U438_C1 (.A(a1[2]), .Y(N8186));
  AOI22X1 U446_C2_8 (.A0(a4[3]), .A1(N11564), .B0(a7[3]), .B1(N5702), 
     .Y(U445_C1__n_4));
  AOI222X1 U354_C1_10 (.A0(a1[4]), .A1(N11566_1), .B0(a4[4]), .B1(N11564), 
     .C0(a5[4]), .C1(N5724), .Y(U354_C1__n_3));
  AND3X2 U445_C1_4 (.A(U445_C1__n_5), .B(U445_C1__n_4), .C(N11924_1), .Y(N11924));
  NAND2BX1 U392_C3_3 (.AN(qq_2_1), .B(N5835), .Y(qq_2_2));
  INVX2 U247_C1_MP_INV (.A(N11566), .Y(N11566_1));
  AOI22X1 U445_C1_3 (.A0(a2[3]), .A1(N10367), .B0(a3[3]), .B1(N10366), 
     .Y(N11924_1));
  NAND2X1 U235_C2_2 (.A(b1[6]), .B(N5830), .Y(N1328));
  NAND3X4 U241_C3_5 (.A(N5717), .B(N3933), .C(qq_5_1), .Y(qq[5]));
  OAI2BB1X4 U216_C3_5 (.A0N(N5762), .A1N(a0[4]), .B0(qq_4_2), .Y(qq[4]));
  AOI22X1 U390_C2_2 (.A0(a2[0]), .A1(N10367), .B0(a3[0]), .B1(N10366), 
     .Y(N10672));
  AOI22X1 U202_C3_4 (.A0(a1[6]), .A1(N11566_1), .B0(a6[6]), .B1(N5668), 
     .Y(U349_C1__n_2));
  AOI22X2 U262_C3_2 (.A0(a2[7]), .A1(N10367), .B0(a3[7]), .B1(N10366), 
     .Y(N11670));
  AOI21X4 U224_C2_1 (.A0(a0_6_1), .A1(N5714), .B0(N10819), .Y(qq[6]));
  AOI21X1 U212_C2_4 (.A0(a0[0]), .A1(N5762), .B0(qq_0_1), .Y(qq_0_2));
  INVX1 U241_C3_3_MP_INV (.A(U360_C1__n), .Y(U360_C1__n_1));
  AOI22X1 U249_C1_7 (.A0(b2[0]), .A1(N11239), .B0(b3[0]), .B1(N5649), 
     .Y(N5707_2));
  AOI22X1 U214_C3_9 (.A0(a8[7]), .A1(N5761), .B0(a9[7]), .B1(N11885), 
     .Y(U214_C3__n_3));
  INVX1 U224_C2_1_MP_INV (.A(a0[6]), .Y(a0_6_1));
  AOI22X1 U214_C3_10 (.A0(b4[7]), .A1(N5665), .B0(b5[7]), .B1(N11591), 
     .Y(U214_C3__n_4));
  NAND2BX1 U366_C3_3 (.AN(N5743_1), .B(U367_C1__n), .Y(qq_7_1));
  NAND3X2 U212_C2_6 (.A(U248_C1__n), .B(U356_C1__n), .C(qq_0_2), .Y(qq[0]));
  AOI22X1 U235_C2_5 (.A0(a8[6]), .A1(N5761), .B0(a9[6]), .B1(N11885), 
     .Y(N5827_1));
  INVX1 U212_C2_3_MP_INV (.A(N11967), .Y(N11967_1));
  AND4X1 U202_C3_5 (.A(N5827_1), .B(N5708_3), .C(N5708_2), .D(N1328), 
     .Y(U349_C1__n_3));
  NAND2X1 U197_C2_2 (.A(b2[6]), .B(N11239), .Y(N10805));
  NAND2BX1 U212_C2_3 (.AN(N11967_1), .B(N10672), .Y(qq_0_1));
  AOI22X1 U353_C2_8 (.A0(a4[6]), .A1(N11564), .B0(a5[6]), .B1(N5724), 
     .Y(N5708_2));
  AND2X2 U279_C1 (.A(U286_C1__n), .B(U280_C1__n), .Y(N5649));
  NOR2X1 U292_C1 (.A(sel[3]), .B(sel[0]), .Y(U278_C1__n));
  NAND2BX1 U216_C3_3 (.AN(N10394_1), .B(N11884), .Y(qq_4_1));
  AND2X2 U288_C1 (.A(U288_C1__n), .B(U278_C1__n_1), .Y(N10366));
  NOR2BX1 U293_C2 (.AN(sel[1]), .B(sel[2]), .Y(U278_C1__n_1));
  AND2X2 U228_C1 (.A(U283_C1__n), .B(U229_C1__n), .Y(N5665));
  AOI22X1 U457_C2_2 (.A0(a2[4]), .A1(N10367), .B0(a3[4]), .B1(N10366), 
     .Y(N11884));
  AND2X2 U287_C1 (.A(U285_C1__n), .B(U280_C1__n), .Y(N11885));
  OAI2BB1X4 U366_C3_5 (.A0N(N5762), .A1N(a0[7]), .B0(qq_7_2), .Y(qq[7]));
  NOR2X2 U349_C1 (.A(U349_C1__n_1), .B(U349_C1__n), .Y(N5714));
  AOI22X1 U248_C1_8 (.A0(b0[0]), .A1(N5651), .B0(b1[0]), .B1(N5830), 
     .Y(U248_C1__n_2));
  NAND3X1 U214_C3_12 (.A(U214_C3__n_4), .B(U214_C3__n_3), .C(N5831), 
     .Y(U214_C3__n));
  AOI221X1 U394_C1_11 (.A0(b0[2]), .A1(N5651), .B0(b1[2]), .B1(N5830), 
     .C0(U394_C1__n_4), .Y(U394_C1__n));
  AND2X2 U276_C1 (.A(U280_C1__n), .B(U229_C1__n), .Y(N11591));
  NOR2BX1 U298_C2 (.AN(sel[3]), .B(sel[0]), .Y(U283_C1__n));
  AOI22X1 U307_C3_9 (.A0(b2[3]), .A1(N11239), .B0(b3[3]), .B1(N5649), 
     .Y(U448_C1__n_3));
  AOI22X1 U303_C2_5 (.A0(b3[5]), .A1(N5649), .B0(b5[5]), .B1(N11591), 
     .Y(N5822_1));
  AOI22X1 U226_C2_10 (.A0(b0[5]), .A1(N5651), .B0(b1[5]), .B1(N5830), 
     .Y(U226_C2__n_4));
  NAND3X1 U217_C3_12 (.A(U217_C3__n_4), .B(U217_C3__n_3), .C(N10849), 
     .Y(U217_C3__n));
  AOI221X1 U217_C3_13 (.A0(a8[4]), .A1(N5761), .B0(a9[4]), .B1(N11885), 
     .C0(U217_C3__n), .Y(N10394));
  NAND2BX2 U195_C1_5 (.AN(N10366_1), .B(a3[1]), .Y(N4984));
  AND2X1 U297_C1 (.A(sel[3]), .B(sel[0]), .Y(U280_C1__n));
  AND2X2 U280_C1 (.A(U280_C1__n), .B(U278_C1__n_1), .Y(N5830));
  AND2X2 U284_C1 (.A(U285_C1__n), .B(U283_C1__n), .Y(N5761));
  AOI22X1 U393_C3_2 (.A0(a6[2]), .A1(N5668), .B0(a7[2]), .B1(N5702), .Y(N5835));
  NAND2BX1 U218_C3_3 (.AN(qq_1_1), .B(N5597), .Y(qq_1_2));
  AND2X2 U281_C1 (.A(U288_C1__n), .B(U286_C1__n), .Y(N5724));
  AOI22X1 U220_C3_2 (.A0(a4[1]), .A1(N11564), .B0(a6[1]), .B1(N5668), .Y(N11614));
  BUFX8 BL3_S_BUF_4 (.A(qq_1_5), .Y(qq[1]));
  NAND4X2 U218_C3_7 (.A(N4984), .B(qq_1_4), .C(N11614), .D(U221_C1__n), 
     .Y(qq_1_5));
  NAND4X2 U392_C3_7 (.A(N2252), .B(U394_C1__n), .C(N5607), .D(qq_2_3), .Y(qq[2]));
  AND2X2 U282_C1 (.A(U278_C1__n), .B(U229_C1__n), .Y(N5668));
  AOI222X1 U394_C1_10 (.A0(a8[2]), .A1(N5761), .B0(a9[2]), .B1(N11885), 
     .C0(b3[2]), .C1(N5649), .Y(U394_C1__n_3));
  INVX1 U395_C1_11_MP_INV (.A(U395_C1__n_3), .Y(U395_C1__n_4));
  AOI221X1 U395_C1_11 (.A0(a5[2]), .A1(N5724), .B0(b2[2]), .B1(N11239), 
     .C0(U395_C1__n_4), .Y(U395_C1__n));
  AOI21X1 U448_C1_1 (.A0(a6[3]), .A1(N5668), .B0(U448_C1__n), .Y(N12258));
  INVX1 U360_C1_9_MP_INV (.A(U360_C1__n_2), .Y(U360_C1__n_3));
  AOI221X1 U226_C2_13 (.A0(a1[5]), .A1(N11566_1), .B0(a6[5]), .B1(N5668), 
     .C0(U226_C2__n), .Y(N10755));
  INVX1 U354_C1_11_MP_INV (.A(U354_C1__n_3), .Y(U354_C1__n_4));
  AOI221X1 U360_C1_9 (.A0(a5[5]), .A1(N5724), .B0(b4[5]), .B1(N5665), 
     .C0(U360_C1__n_3), .Y(U360_C1__n));
  OAI2BB2X1 U218_C3_2 (.A0N(a2[1]), .A1N(N10367), .B0(N5725), .B1(N11566), 
     .Y(qq_1_1));
  INVX3 BL3_S_INV (.A(qq_5_2), .Y(qq_5_1));
  INVX1 U216_C3_4_MP_INV (.A(U354_C1__n), .Y(U354_C1__n_1));
  AOI222X1 U446_C2_9 (.A0(a1[3]), .A1(N11566_1), .B0(a5[3]), .B1(N5724), 
     .C0(b4[3]), .C1(N5665), .Y(U445_C1__n_5));
  AOI22X1 U219_C3_2 (.A0(a5[1]), .A1(N5724), .B0(a7[1]), .B1(N5702), .Y(N5597));
  NOR2X4 U216_C3_4 (.A(qq_4_1), .B(U354_C1__n_1), .Y(qq_4_2));
  AOI221X1 U354_C1_11 (.A0(a6[4]), .A1(N5668), .B0(a7[4]), .B1(N5702), 
     .C0(U354_C1__n_4), .Y(U354_C1__n));
  OAI2BB2X1 U392_C3_2 (.A0N(a2[2]), .A1N(N10367), .B0(N8186), .B1(N11566), 
     .Y(qq_2_1));
endmodule

// Entity:rl Model:rl Library:L0
module rl (d, q);
  input [7:0] d;
  output [7:0] q;
  BUFX1 BL1_ASSIGN_BUF151 (.A(d[3]), .Y(q[4]));
  BUFX1 BL1_ASSIGN_BUF139 (.A(d[1]), .Y(q[2]));
  BUFX1 BL1_ASSIGN_BUF140 (.A(d[2]), .Y(q[3]));
  BUFX1 BL1_ASSIGN_BUF156 (.A(d[0]), .Y(q[1]));
  BUFX1 BL1_ASSIGN_BUF114 (.A(d[4]), .Y(q[5]));
  BUFX1 BL1_ASSIGN_BUF126 (.A(d[6]), .Y(q[7]));
  BUFX1 BL1_ASSIGN_BUF132 (.A(d[7]), .Y(q[0]));
  BUFX1 BL1_ASSIGN_BUF115 (.A(d[5]), .Y(q[6]));
endmodule

// Entity:rlc Model:rlc Library:L0
module rlc (d, in_cy, out_cy, q);
  input in_cy;
  output out_cy;
  input [7:0] d;
  output [7:0] q;
  BUFX1 BL1_ASSIGN_BUF71 (.A(in_cy), .Y(q[0]));
  BUFX1 BL1_ASSIGN_BUF135 (.A(d[1]), .Y(q[2]));
  BUFX1 BL1_ASSIGN_BUF128 (.A(d[7]), .Y(out_cy));
  BUFX1 BL1_ASSIGN_BUF160 (.A(d[0]), .Y(q[1]));
  BUFX1 BL1_ASSIGN_BUF147 (.A(d[3]), .Y(q[4]));
  BUFX1 BL1_ASSIGN_BUF144 (.A(d[2]), .Y(q[3]));
  BUFX1 BL1_ASSIGN_BUF119 (.A(d[5]), .Y(q[6]));
  BUFX1 BL1_ASSIGN_BUF110 (.A(d[4]), .Y(q[5]));
  BUFX1 BL1_ASSIGN_BUF122 (.A(d[6]), .Y(q[7]));
endmodule

// Entity:rr Model:rr Library:L0
module rr (d, q);
  input [7:0] d;
  output [7:0] q;
  wire d_3_1;
  BUFX1 BL1_ASSIGN_BUF130 (.A(d[7]), .Y(q[6]));
  BUFX1 BL1_ASSIGN_BUF142 (.A(d[2]), .Y(q[1]));
  BUFX1 BL1_ASSIGN_BUF112 (.A(d[4]), .Y(q[3]));
  BUFX1 BL1_ASSIGN_BUF117 (.A(d[5]), .Y(q[4]));
  BUFX1 BL1_ASSIGN_BUF149 (.A(d_3_1), .Y(q[2]));
  BUFX1 BL2_BUF94 (.A(d[3]), .Y(d_3_1));
  BUFX1 BL1_ASSIGN_BUF124 (.A(d[6]), .Y(q[5]));
  BUFX1 BL1_ASSIGN_BUF158 (.A(d[0]), .Y(q[7]));
  BUFX1 BL1_ASSIGN_BUF137 (.A(d[1]), .Y(q[0]));
endmodule

// Entity:rrc Model:rrc Library:L0
module rrc (d, in_cy, out_cy, q);
  input in_cy;
  output out_cy;
  input [7:0] d;
  output [7:0] q;
  BUFX1 BL1_ASSIGN_BUF161 (.A(d[0]), .Y(out_cy));
  BUFX1 BL1_ASSIGN_BUF109 (.A(d[4]), .Y(q[3]));
  BUFX1 BL1_ASSIGN_BUF120 (.A(d[5]), .Y(q[4]));
  BUFX1 BL1_ASSIGN_BUF146 (.A(d[3]), .Y(q[2]));
  BUFX1 BL1_ASSIGN_BUF145 (.A(d[2]), .Y(q[1]));
  BUFX1 BL1_ASSIGN_BUF121 (.A(d[6]), .Y(q[5]));
  BUFX1 BL1_ASSIGN_BUF127 (.A(d[7]), .Y(q[6]));
  BUFX1 BL1_ASSIGN_BUF72 (.A(in_cy), .Y(q[7]));
  BUFX1 BL1_ASSIGN_BUF134 (.A(d[1]), .Y(q[0]));
endmodule

// Entity:sel_al Model:sel_al Library:L0
module sel_al (isel, osel);
  input [4:0] isel;
  output [3:0] osel;
  wire U85_C1__n, U69_C1__n, N10149, U67_C1__n, N6719, N7195, N7188, N11241, 
     N9457, N7906, N11847, N11846, N1482, N10455, N10313_1, N11785_1, osel_0_1, 
     isel_1_1, isel_0_1, U67_C1__n_2, isel_3_1, N7188_1, U85_C1__n_1, N7910_2, 
     U69_C1__n_1, N11847_2, N11241_1, N9596, N7910, N9457_2;
  INVX1 U85_C1_MP_INV (.A(U85_C1__n), .Y(U85_C1__n_1));
  INVX1 U56_C2_4_MP_INV (.A(N9457_2), .Y(N9457));
  NAND3X1 U67_C1_2 (.A(isel_1_1), .B(isel[0]), .C(U67_C1__n_2), .Y(N6719));
  AOI2BB2X1 U72_C1_5 (.A0N(N9596), .A1N(N10149), .B0(isel[0]), .B1(N7910_2), 
     .Y(osel_0_1));
  NAND2X1 U81_C1_3 (.A(isel_1_1), .B(isel_0_1), .Y(N10455));
  INVX1 U81_C1_3_MP_INV_1 (.A(isel[0]), .Y(isel_0_1));
  INVX1 U90_C2_2_MP_INV (.A(isel[3]), .Y(isel_3_1));
  AOI211X1 U56_C2_4 (.A0(isel[1]), .A1(U67_C1__n_2), .B0(N9596), .C0(N11241), 
     .Y(N9457_2));
  OAI211X1 U54_C2_4 (.A0(isel[0]), .A1(U85_C1__n_1), .B0(U69_C1__n_1), 
     .C0(N9457_2), .Y(N7910));
  AOI31X1 U86_C4_3 (.A0(N10313_1), .A1(isel_3_1), .A2(isel[4]), .B0(N7910), 
     .Y(N11785_1));
  OAI222X4 U63_C4_6 (.A0(N9596), .A1(N11241_1), .B0(U69_C1__n_1), .B1(N9457), 
     .C0(U85_C1__n), .C1(N7910), .Y(osel[2]));
  AOI222X1 U86_C4_16 (.A0(U69_C1__n), .A1(N9457_2), .B0(U85_C1__n_1), 
     .B1(N11785_1), .C0(isel[1]), .C1(N7906), .Y(N11847_2));
  NAND3X1 U69_C1_2 (.A(isel_1_1), .B(isel[0]), .C(U69_C1__n), .Y(N10149));
  INVX1 U72_C1_5_MP_INV (.A(N7910), .Y(N7910_2));
  NAND2BX1 U52_C4_4 (.AN(N11847), .B(N1482), .Y(osel[1]));
  INVX1 U86_C4_16_MP_INV (.A(N11847_2), .Y(N11847));
  INVX1 U58_C2_4_MP_INV (.A(N7188), .Y(N7188_1));
  INVX1 U67_C1_2_MP_INV (.A(U67_C1__n), .Y(U67_C1__n_2));
  OAI2BB1X1 U52_C4_2 (.A0N(U67_C1__n_2), .A1N(N7188_1), .B0(N9596), .Y(N11846));
  NAND2BX1 U52_C4_5 (.AN(N7195), .B(N11846), .Y(N1482));
  OAI211X1 U58_C2_4 (.A0(U67_C1__n), .A1(N7195), .B0(N7188_1), .C0(N6719), 
     .Y(N9596));
  OAI211X1 U72_C1_7 (.A0(N7188), .A1(N6719), .B0(osel_0_1), .C0(N11847_2), 
     .Y(osel[0]));
  NOR2X1 U85_C1 (.A(isel[2]), .B(U85_C1__n_1), .Y(U69_C1__n));
  NAND3BX1 U90_C2_2 (.AN(isel[4]), .B(isel[2]), .C(isel_3_1), .Y(U67_C1__n));
  INVX1 U81_C1_3_MP_INV (.A(isel[1]), .Y(isel_1_1));
  OAI2BB1X1 U55_C3_1 (.A0N(isel_0_1), .A1N(U69_C1__n), .B0(N10149), .Y(N11241));
  NAND2X1 U78_C1 (.A(isel[1]), .B(isel_0_1), .Y(N7195));
  OAI31X1 U61_C3_1 (.A0(isel[0]), .A1(U85_C1__n_1), .A2(N9457), .B0(N7910), 
     .Y(osel[3]));
  INVX1 U54_C2_4_MP_INV (.A(U69_C1__n), .Y(U69_C1__n_1));
  NOR2BX2 U84_C2 (.AN(isel[3]), .B(isel[4]), .Y(U85_C1__n));
  OAI22X1 U86_C4_4 (.A0(N9596), .A1(U67_C1__n), .B0(N7910), .B1(U85_C1__n_1), 
     .Y(N7906));
  AOI21X1 U86_C4_11 (.A0(isel[1]), .A1(N7195), .B0(isel[2]), .Y(N10313_1));
  AOI211X1 U81_C1_5 (.A0(isel[2]), .A1(N10455), .B0(isel[4]), .C0(isel[3]), 
     .Y(N7188));
  INVX1 U63_C4_6_MP_INV (.A(N11241), .Y(N11241_1));
endmodule

// Entity:sel_arth Model:sel_arth Library:L0
module sel_arth (iop2, icin, sel, oop2, ocin);
  input icin;
  output ocin;
  input [7:0] iop2;
  input [2:0] sel;
  output [7:0] oop2;
  wire N11299, N10790, N7864, N11569, N8061, N6956, N1854, N11683, N7864_1, 
     N1720, oop2_4_1, N7864_2, oop2_3_1, oop2_2_1, iop2_2_1, oop2_1_1, oop2_0_1, 
     oop2_0_2, oop2_5_1, iop2_7_1, sel_0_1;
  AOI21X4 U52_C2_6_C1_4 (.A0(iop2[5]), .A1(N11299), .B0(N7864_2), .Y(oop2_5_1));
  OAI21X4 U59_C1_5 (.A0(iop2[1]), .A1(N11569), .B0(oop2_1_1), .Y(oop2[1]));
  OAI21X1 U35_C2_4 (.A0(iop2_2_1), .A1(N11299), .B0(N10790), .Y(N1720));
  AOI21X1 U59_C1_4 (.A0(iop2[1]), .A1(N11299), .B0(N7864_2), .Y(oop2_1_1));
  NAND2X1 U35_C2_6 (.A(N1720), .B(oop2_2_1), .Y(oop2[2]));
  BUFX1 BL2_BUF151 (.A(sel[0]), .Y(sel_0_1));
  NOR2X1 U50_C2_1 (.A(sel[1]), .B(sel_0_1), .Y(N7864_1));
  NOR2X2 U43_C1 (.A(sel[2]), .B(sel[1]), .Y(N11299));
  NAND2X1 U60_C3_4 (.A(N8061), .B(N7864), .Y(oop2_0_1));
  INVX2 U42_C1 (.A(N10790), .Y(N11569));
  AOI21X4 U60_C3_5 (.A0(iop2[0]), .A1(N11299), .B0(oop2_0_1), .Y(oop2_0_2));
  OAI21X4 U60_C3_6 (.A0(iop2[0]), .A1(N11569), .B0(oop2_0_2), .Y(oop2[0]));
  AOI21X1 U37_C2_6_C1_4 (.A0(iop2[4]), .A1(N11299), .B0(N7864_2), .Y(oop2_4_1));
  OAI211X4 U55_C1_5 (.A0(iop2_7_1), .A1(N11569), .B0(N7864), .C0(N11683), 
     .Y(oop2[7]));
  NAND2X1 U55_C1_2 (.A(iop2_7_1), .B(N11299), .Y(N11683));
  BUFX1 BL2_BUF42 (.A(iop2[7]), .Y(iop2_7_1));
  OAI211X1 U56_C1_5 (.A0(iop2[6]), .A1(N11569), .B0(N7864), .C0(N6956), 
     .Y(oop2[6]));
  NAND2X1 U56_C1_2 (.A(iop2[6]), .B(N11299), .Y(N6956));
  NAND3X1 U32_C4_5 (.A(sel_0_1), .B(icin), .C(N11299), .Y(N1854));
  NAND2X1 U50_C2_2 (.A(sel[2]), .B(N7864_1), .Y(N7864));
  NOR3BX1 U41_C2_2 (.AN(sel[1]), .B(sel[2]), .C(sel_0_1), .Y(N10790));
  NAND3BX1 U45_C2_2 (.AN(sel[2]), .B(sel_0_1), .C(sel[1]), .Y(N8061));
  OAI21X1 U32_C4_1 (.A0(icin), .A1(N11569), .B0(N1854), .Y(ocin));
  INVX1 U37_C2_6_C1_4_MP_INV (.A(N7864), .Y(N7864_2));
  INVX1 U35_C2_4_MP_INV (.A(iop2[2]), .Y(iop2_2_1));
  OAI21X1 U52_C2_6_C1_5 (.A0(iop2[5]), .A1(N11569), .B0(oop2_5_1), .Y(oop2[5]));
  AOI21X1 U57_C1_6_C1_4 (.A0(iop2[3]), .A1(N11299), .B0(N7864_2), .Y(oop2_3_1));
  OAI21X1 U57_C1_6_C1_5 (.A0(iop2[3]), .A1(N11569), .B0(oop2_3_1), .Y(oop2[3]));
  OAI21X2 U37_C2_6_C1_5 (.A0(iop2[4]), .A1(N11569), .B0(oop2_4_1), .Y(oop2[4]));
  AOI21X1 U35_C2_5 (.A0(iop2[2]), .A1(N11299), .B0(N7864_2), .Y(oop2_2_1));
endmodule

// Entity:swap Model:swap Library:L0
module swap (d, q);
  input [7:0] d;
  output [7:0] q;
  BUFX1 BL1_ASSIGN_BUF141 (.A(d[2]), .Y(q[6]));
  BUFX1 BL1_ASSIGN_BUF116 (.A(d[5]), .Y(q[1]));
  BUFX1 BL1_ASSIGN_BUF157 (.A(d[0]), .Y(q[4]));
  BUFX1 BL1_ASSIGN_BUF131 (.A(d[7]), .Y(q[3]));
  BUFX1 BL1_ASSIGN_BUF138 (.A(d[1]), .Y(q[5]));
  BUFX1 BL1_ASSIGN_BUF125 (.A(d[6]), .Y(q[2]));
  BUFX1 BL1_ASSIGN_BUF150 (.A(d[3]), .Y(q[7]));
  BUFX1 BL1_ASSIGN_BUF113 (.A(d[4]), .Y(q[0]));
endmodule

// Entity:xchd Model:xchd Library:L0
module xchd (in_acc, in_ram, out_acc, out_ram);
  input [7:0] in_acc;
  input [7:0] in_ram;
  output [7:0] out_acc;
  output [7:0] out_ram;
  wire in_acc_4_1, in_acc_6_1, in_ram_2_1;
  BUFX1 BL1_ASSIGN_BUF154 (.A(in_ram[6]), .Y(out_ram[6]));
  BUFX1 BL1_ASSIGN_BUF153 (.A(in_ram[5]), .Y(out_ram[5]));
  BUFX1 BL1_ASSIGN_BUF143 (.A(in_acc[2]), .Y(out_ram[2]));
  BUFX1 BL1_ASSIGN_BUF148 (.A(in_acc[3]), .Y(out_ram[3]));
  BUFX1 BL1_ASSIGN_BUF136 (.A(in_acc[1]), .Y(out_ram[1]));
  BUFX1 BL1_ASSIGN_BUF152 (.A(in_ram[4]), .Y(out_ram[4]));
  BUFX1 BL1_ASSIGN_BUF129 (.A(in_acc[7]), .Y(out_acc[7]));
  BUFX1 BL2_BUF74 (.A(in_acc[6]), .Y(in_acc_6_1));
  BUFX1 BL1_ASSIGN_BUF155 (.A(in_ram[7]), .Y(out_ram[7]));
  BUFX1 BL1_ASSIGN_BUF159 (.A(in_acc[0]), .Y(out_ram[0]));
  BUFX1 BL1_ASSIGN_BUF118 (.A(in_acc[5]), .Y(out_acc[5]));
  BUFX1 BL2_BUF51 (.A(in_acc[4]), .Y(in_acc_4_1));
  BUFX1 BL1_ASSIGN_BUF106 (.A(in_ram[1]), .Y(out_acc[1]));
  BUFX1 BL2_BUF116 (.A(in_ram[2]), .Y(in_ram_2_1));
  BUFX1 BL1_ASSIGN_BUF105 (.A(in_ram[0]), .Y(out_acc[0]));
  BUFX1 BL1_ASSIGN_BUF108 (.A(in_ram[3]), .Y(out_acc[3]));
  BUFX1 BL1_ASSIGN_BUF111 (.A(in_acc_4_1), .Y(out_acc[4]));
  BUFX1 BL1_ASSIGN_BUF123 (.A(in_acc_6_1), .Y(out_acc[6]));
  BUFX1 BL1_ASSIGN_BUF107 (.A(in_ram_2_1), .Y(out_acc[2]));
endmodule

// Entity:u_datapath_DW01_add_16_1 Model:u_datapath_DW01_add_16_1 Library:L0
module u_datapath_DW01_add_16_1 (A, B, CI, SUM, CO);
  input CI;
  output CO;
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  wire carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, 
     carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, 
     carry_2_, N11510, N10375;
  XOR2X1 U1_15_C2 (.A(B[15]), .B(A[15]), .Y(N11510));
  ADDFX1 U1_2 (.A(A[2]), .B(B[2]), .CI(carry_2_), .CO(carry_3_), .S(SUM[2]));
  ADDFX1 U1_3 (.A(A[3]), .B(B[3]), .CI(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDFX1 U1_4 (.A(A[4]), .B(B[4]), .CI(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDFX1 U1_1 (.A(A[1]), .B(B[1]), .CI(N10375), .CO(carry_2_), .S(SUM[1]));
  ADDFX1 U1_11 (.A(A[11]), .B(B[11]), .CI(carry_11_), .CO(carry_12_), 
     .S(SUM[11]));
  ADDFX1 U1_10 (.A(A[10]), .B(B[10]), .CI(carry_10_), .CO(carry_11_), 
     .S(SUM[10]));
  ADDFX1 U1_9 (.A(A[9]), .B(B[9]), .CI(carry_9_), .CO(carry_10_), .S(SUM[9]));
  ADDFX1 U1_12 (.A(A[12]), .B(B[12]), .CI(carry_12_), .CO(carry_13_), 
     .S(SUM[12]));
  AND2X1 U4_C1 (.A(B[0]), .B(A[0]), .Y(N10375));
  XOR2X1 U5_C1 (.A(B[0]), .B(A[0]), .Y(SUM[0]));
  ADDFX1 U1_14 (.A(A[14]), .B(B[14]), .CI(carry_14_), .CO(carry_15_), 
     .S(SUM[14]));
  ADDFX1 U1_7 (.A(A[7]), .B(B[7]), .CI(carry_7_), .CO(carry_8_), .S(SUM[7]));
  ADDFX1 U1_13 (.A(A[13]), .B(B[13]), .CI(carry_13_), .CO(carry_14_), 
     .S(SUM[13]));
  ADDFX1 U1_8 (.A(A[8]), .B(B[8]), .CI(carry_8_), .CO(carry_9_), .S(SUM[8]));
  ADDFX1 U1_6 (.A(A[6]), .B(B[6]), .CI(carry_6_), .CO(carry_7_), .S(SUM[6]));
  ADDFX1 U1_5 (.A(A[5]), .B(B[5]), .CI(carry_5_), .CO(carry_6_), .S(SUM[5]));
  XOR2X1 U1_15_C2_1 (.A(carry_15_), .B(N11510), .Y(SUM[15]));
endmodule

// Entity:u_datapath_DW01_inc_16_0 Model:u_datapath_DW01_inc_16_0 Library:L0
module u_datapath_DW01_inc_16_0 (A, SUM);
  input [15:0] A;
  output [15:0] SUM;
  wire carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, 
     carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, 
     carry_2_;
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  ADDHX1 U1_1_14 (.A(A[14]), .B(carry_14_), .CO(carry_15_), .S(SUM[14]));
  XOR2X1 U5_C1 (.A(carry_15_), .B(A[15]), .Y(SUM[15]));
  ADDHX1 U1_1_12 (.A(A[12]), .B(carry_12_), .CO(carry_13_), .S(SUM[12]));
  ADDHX1 U1_1_13 (.A(A[13]), .B(carry_13_), .CO(carry_14_), .S(SUM[13]));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  ADDHX1 U1_1_7 (.A(A[7]), .B(carry_7_), .CO(carry_8_), .S(SUM[7]));
  ADDHX1 U1_1_10 (.A(A[10]), .B(carry_10_), .CO(carry_11_), .S(SUM[10]));
  ADDHX1 U1_1_8 (.A(A[8]), .B(carry_8_), .CO(carry_9_), .S(SUM[8]));
  ADDHX1 U1_1_9 (.A(A[9]), .B(carry_9_), .CO(carry_10_), .S(SUM[9]));
  ADDHX1 U1_1_11 (.A(A[11]), .B(carry_11_), .CO(carry_12_), .S(SUM[11]));
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
endmodule

// Entity:u_datapath_MUX_OP_8_3_2 Model:u_datapath_MUX_OP_8_3_2 Library:L0
module u_datapath_MUX_OP_8_3_2 (D0_1, D0_0, D1_1, D1_0, D2_1, D2_0, D3_1, D3_0, 
     D4_1, D4_0, D5_1, D5_0, D6_1, D6_0, D7_1, D7_0, S0, S1, S2, Z_1, Z_0);
  input D0_1, D0_0, D1_1, D1_0, D2_1, D2_0, D3_1, D3_0, D4_1, D4_0, D5_1, D5_0, 
     D6_1, D6_0, D7_1, D7_0, S0, S1, S2;
  output Z_1, Z_0;
  wire n1, n2, n3, n4;
  MX4X1 U11 (.A(D0_1), .B(D1_1), .C(D2_1), .D(D3_1), .S0(S0), .S1(S1), .Y(n3));
  MX4X1 U9 (.A(D4_0), .B(D5_0), .C(D6_0), .D(D7_0), .S0(S0), .S1(S1), .Y(n2));
  MX2X1 U7_C4_1 (.A(n1), .B(n2), .S0(S2), .Y(Z_0));
  MX4X1 U8 (.A(D0_0), .B(D1_0), .C(D2_0), .D(D3_0), .S0(S0), .S1(S1), .Y(n1));
  MX4X1 U12 (.A(D4_1), .B(D5_1), .C(D6_1), .D(D7_1), .S0(S0), .S1(S1), .Y(n4));
  MX2X1 U10_C4_1 (.A(n3), .B(n4), .S0(S2), .Y(Z_1));
endmodule

// Entity:u_sfr_test_1 Model:u_sfr_test_1 Library:L0
module u_sfr_test_1 (end_instr, clk, rst_p, ld_acc, ld_acc_chd, addr_sfr, 
     in_sfr, wr_sfr, ld_dpl, ld_dph, inc_dptr, inc_sp, dec_sp, set_c, rst_c, 
     cpl_c, ld_c, set_ac, rst_ac, set_v, rst_v, acc_chd, in_b, ld_b, in_cy_bit, 
     rmw, t0_pin, t1_pin, int0_pin, int1_pin, p0_in, p1_in, p2_in, p3_in, reti, 
     out_sfr_a, out_acc_r, out_dptr_r, out_dimod_r, out_sp_r, out_psw, out_b, 
     p0_out, p1_out, p2_out, p3_out, txdo, rxdi, rxdo, int_vec, en_int, 
     rc8051RtlTop_test_mode_in, rc8051RtlTop_test_point_535_in, test_si1, 
     test_so1, test_si2, test_so2, test_si3, test_so3, test_si4, test_so4, 
     test_si5, test_so5, test_si6, test_so6, test_si7, test_so7, test_si8, 
     test_so8, test_si9, test_so9, test_se, clk0_26, clk0_8, clk0_10, clk0_21, 
     clk0_9, clk0_5);
  input end_instr, clk, rst_p, ld_acc, ld_acc_chd, wr_sfr, ld_dpl, ld_dph, 
     inc_dptr, inc_sp, dec_sp, set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac, set_v, 
     rst_v, ld_b, in_cy_bit, rmw, t0_pin, t1_pin, int0_pin, int1_pin, reti, 
     rxdi, rc8051RtlTop_test_mode_in, rc8051RtlTop_test_point_535_in, test_si1, 
     test_si2, test_si3, test_si4, test_si5, test_si6, test_si7, test_si8, 
     test_si9, test_se, clk0_26, clk0_8, clk0_10, clk0_21, clk0_9, clk0_5;
  output txdo, rxdo, en_int, test_so1, test_so2, test_so3, test_so4, test_so5, 
     test_so6, test_so7, test_so8, test_so9;
  input [7:0] addr_sfr;
  input [7:0] in_sfr;
  input [7:0] acc_chd;
  input [7:0] in_b;
  input [7:0] p0_in;
  input [7:0] p1_in;
  input [7:0] p2_in;
  input [7:0] p3_in;
  output [7:0] out_sfr_a;
  output [7:0] out_acc_r;
  output [15:0] out_dptr_r;
  output [7:0] out_dimod_r;
  output [7:0] out_sp_r;
  output [7:0] out_psw;
  output [7:0] out_b;
  output [7:0] p0_out;
  output [7:0] p1_out;
  output [7:0] p2_out;
  output [7:0] p3_out;
  output [2:0] int_vec;
  wire \isrc_cur[0] , \isrc_cur[1] , \isrc_cur[2] , \p0[0] , \p0[1] , \p0[2] , 
     \p0[3] , \p0[4] , \p0[5] , \p0[6] , \p0[7] , \tcon[0] , \tcon[1] , 
     \tcon[2] , \tcon[3] , \tcon[4] , \tcon[5] , \tcon[6] , \tcon[7] , 
     \tmod[0] , \tmod[1] , \tmod[2] , \tmod[3] , \tmod[4] , \tmod[5] , 
     \tmod[6] , \tmod[7] , \tl0[0] , \tl0[1] , \tl0[2] , \tl0[3] , \tl0[4] , 
     \tl0[5] , \tl0[6] , \tl0[7] , \tl1[0] , \tl1[1] , \tl1[2] , \tl1[3] , 
     \tl1[4] , \tl1[5] , \tl1[6] , \tl1[7] , \th0[0] , \th0[1] , \th0[2] , 
     \th0[3] , \th0[4] , \th0[5] , \th0[6] , \th0[7] , \th1[0] , \th1[1] , 
     \th1[2] , \th1[3] , \th1[4] , \th1[5] , \th1[6] , \th1[7] , \p1[0] , 
     \p1[1] , \p1[2] , \p1[3] , \p1[4] , \p1[5] , \p1[6] , \p1[7] , \scon[0] , 
     \scon[1] , \scon[2] , \scon[3] , \scon[4] , \scon[5] , \scon[6] , 
     \scon[7] , \pcon[0] , \pcon[1] , \pcon[2] , \pcon[3] , \pcon[4] , 
     \pcon[5] , \pcon[6] , \pcon[7] , \sbuf[0] , \sbuf[1] , \sbuf[2] , 
     \sbuf[3] , \sbuf[4] , \sbuf[5] , \sbuf[6] , \sbuf[7] , \p2[0] , \p2[1] , 
     \p2[2] , \p2[3] , \p2[4] , \p2[5] , \p2[6] , \p2[7] , \ie[0] , \ie[1] , 
     \ie[2] , \ie[3] , \ie[4] , \ie[5] , \ie[6] , \ie[7] , \p3[0] , \p3[1] , 
     \p3[2] , \p3[3] , \p3[4] , \p3[5] , \p3[6] , \p3[7] , \ip[0] , \ip[1] , 
     \ip[2] , \ip[3] , \ip[4] , \ip[5] , \ip[6] , \ip[7] , rst_tf1, rst_ie1, 
     rst_tf0, rst_ie0, tf0, tf0_sync, tf1, tf1_sync, set_ie0, set_ie1, shift12, 
     uart_int, parity, disint, n6, n7, tmod_7_1, tcon_7_1, n16, n17, n20, n21, 
     ip_7_1, ie_7_1, n26, tl1_7_1, n30, n31, n34, n35, n36, n37, U421_C1__n, 
     N10989, U381_C1__n, N6778, U388_C1__n, U400_C1__n, N11130, U396_C1__n, 
     N12234, N10573, N7422, N7421, N11462, N7419, N10336, N10335, N7411, N11275, 
     N11619, N11618, N8939, N8776, N1553, N8162, N10558, N7874, N12133, N1429, 
     N11169, N2355, N9443, disint_1, n173_1, isrc_cur_2_1, U223_C3__n_4, 
     U396_C1__n_1, U223_C3__n_5, N6774_1, N12234_1, out_sfr_a_3_1, U231_C3__n_4, 
     U400_C1__n_1, U231_C3__n_5, N7019_1, N11130_1, out_sfr_a_4_1, U213_C3__n_4, 
     U388_C1__n_1, U213_C3__n_5, N7113_1, out_sfr_a_5_1, U212_C3__n_4, 
     U381_C1__n_1, U273_C1__n_3, U273_C1__n_4, N10305_1, U212_C3__n_5, 
     U212_C3__n_6, N10070_1, N10070_2, N6778_1, out_sfr_a_6_1, U214_C3__n_4, 
     U421_C1__n_1, U275_C1__n_3, U275_C1__n_4, N10766_1, U214_C3__n_5, 
     U214_C3__n_6, N6996_1, N6996_2, N10989_1, out_sfr_a_7_1, U256_C2__n, N1597, 
     N8107, N5008, U194_C2__n, U213_C3_18_C4__n_1, U213_C3_18_C4__n_3, 
     U213_C3_18_C4__n_5, N7312, N7310, N12322, N10791, N7051, N4902, 
     U224_C3__n_1, U224_C3__n_5, N4607, U230_C3__n_2, U230_C3__n_3, N4935, 
     N4936, N8524, N1299, N11128, N3942, N3144, N4880, N2269, N4944, N3952, 
     N9202, N1617, N6531, N4826, N1374, N4873, N2308, N4947, N4916, N2779, 
     N3012, N7560, N2980, N10040, N11745, N949, N3136, N7129, N1348, N6698, 
     N4658, N12132, N4883, N4601, N4602, N4987, N1564, N11798, N4912, N10791_1, 
     addr_sfr_3_1, addr_sfr_7_1, N7310_1, N12322_1, U334_C1__n_2, U334_C1__n_3, 
     N8107_1, U334_C1__n_5, N8475_1, N5008_1, U256_C2__n_2, U256_C2__n_3, 
     U256_C2__n_5, addr_sfr_2_1, N4918_2, addr_sfr_0_1, N2877_1, N2877_2, 
     U249_C1__n_1, N2810_1, U240_C1__n_1, U240_C1__n_2, N4596_1, U240_C1__n_4, 
     U185_C1__n_1, U185_C1__n_3, N4933_2, addr_sfr_1_1, N4610_2, 
     U213_C3_18_C4__n_6, U213_C3_18_C4__n_7, U213_C3_18_C4__n_9, 
     U213_C3_18_C4__n_10, U213_C3_18_C4__n_13, U213_C3_18_C4__n_2, addr_sfr_5_1, 
     addr_sfr_6_1, U224_C3__n_2, U224_C3__n_6, U224_C3__n_8, U224_C3__n_9, 
     out_sfr_a_4_2, out_sfr_a_4_3, out_sfr_a_4_4, out_sfr_a_4_5, out_sfr_a_4_6, 
     out_sfr_a_4_7, out_sfr_a_4_8, out_sfr_a_4_9, out_sfr_a_4_10, N12133_1, 
     U231_C3__n_6, out_sfr_a_3_2, out_sfr_a_3_3, out_sfr_a_3_4, out_sfr_a_3_5, 
     out_sfr_a_3_6, out_sfr_a_3_7, out_sfr_a_3_8, out_sfr_a_3_9, out_sfr_a_3_10, 
     N9443_1, U223_C3__n_6, out_sfr_a_5_2, out_sfr_a_5_3, out_sfr_a_5_6, 
     out_sfr_a_5_7, out_sfr_a_5_8, out_sfr_a_5_9, out_sfr_a_5_10, 
     out_sfr_a_5_12, out_sfr_a_5_13, N7874_1, tl0_5_1, N5017_1, out_sfr_a_0_1, 
     out_sfr_a_0_3, out_sfr_a_0_4, out_sfr_a_0_5, out_sfr_a_0_6, out_sfr_a_0_7, 
     out_sfr_a_0_8, out_sfr_a_0_9, out_sfr_a_0_10, out_sfr_a_0_11, 
     out_sfr_a_0_12, out_sfr_a_0_14, out_sfr_a_0_15, sbuf_0_1, th1_0_1, N8939_1, 
     out_sfr_a_2_1, out_sfr_a_2_2, out_sfr_a_2_3, out_sfr_a_2_4, out_sfr_a_2_5, 
     out_sfr_a_2_6, out_sfr_a_2_7, out_sfr_a_2_8, out_sfr_a_2_10, 
     out_sfr_a_2_11, out_sfr_a_2_12, out_sfr_a_2_14, out_sfr_a_2_15, sbuf_2_1, 
     out_sfr_a_1_3, out_sfr_a_1_4, out_sfr_a_1_5, out_sfr_a_1_6, out_sfr_a_1_7, 
     out_sfr_a_1_8, out_sfr_a_1_9, out_sfr_a_1_10, out_sfr_a_1_11, 
     out_sfr_a_1_12, out_sfr_a_1_14, out_sfr_a_1_15, ie_1_1, ip_1_1, scon_1_1, 
     test_se_1, test_se_2, test_se_3, test_se_4, N50081, U256_C2__n_51, 
     U256_C2__n_52, U256_C2__n_511, N17021, N2810_21, test_se_5, 
     rc8051RtlTop_test_point_535_in_1, in_sfr_0_1, test_se_6, in_sfr_2_1, 
     U224_C3__n_7, N2810_2, N4596, N4918_3, U213_C3_18_C4__n, N8475, N4610_3, 
     N4933, N1702, N4904_2, out_sfr_a_4_11, out_sfr_a_0_2, out_sfr_a_7_2, 
     out_sfr_a_2_16, out_sfr_a_3_11, out_sfr_a_4_12, N1702_1, U256_C2__n_53;
  OAI2BB1X1 U375_C2_6 (.A0N(\tcon[3] ), .A1N(N1597), .B0(N12234_1), .Y(N12234));
  NAND2X1 U368_C2_2 (.A(out_dptr_r[4]), .B(N2877_2), .Y(N2355));
  NAND2BX1 U334_C1_1 (.AN(addr_sfr[6]), .B(addr_sfr[5]), .Y(N8107_1));
  b_test_1 U4_b (.clk(), .rst_p(rst_p), .in_b({in_b[7], in_b[6], in_b[5], 
     in_b[4], in_b[3], in_b[2], in_b[1], in_b[0]}), .in_dat({in_sfr[7], in_sfr[6], 
     in_sfr[5], in_sfr[4], in_sfr[3], in_sfr[2], in_sfr[1], in_sfr[0]}), 
     .addr_b({addr_sfr[7], addr_sfr[6], addr_sfr[5], addr_sfr[4], addr_sfr[3], 
     addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .wr(wr_sfr), .ld_b(ld_b), .out_b({
     out_b[7], out_b[6], out_b[5], out_b[4], out_b[3], out_b[2], out_b[1], 
     out_b[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(n31), .test_so(n30), .test_se(test_se_1), .clk0_5(clk0_9), 
     .clk0_8(clk0_10), .clk0_21(clk0_21), .clk0_26(clk0_26));
  gpio1_test_1 U_port1 (.clk(), .rst_p(rst_p), .wr(wr_sfr), .rmw(rmw), .combus({
     in_sfr[7], in_sfr[6], in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, 
     in_sfr[1], in_sfr_0_1}), .prt1_addr({addr_sfr[7], addr_sfr[6], addr_sfr[5], 
     addr_sfr[4], addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .p1_in({
     p1_in[7], p1_in[6], p1_in[5], p1_in[4], p1_in[3], p1_in[2], p1_in[1], 
     p1_in[0]}), .p1({\p1[7] , \p1[6] , \p1[5] , \p1[4] , \p1[3] , \p1[2] , 
     \p1[1] , \p1[0] }), .p1_out({p1_out[7], p1_out[6], p1_out[5], p1_out[4], 
     p1_out[3], p1_out[2], p1_out[1], p1_out[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(n21), .test_so(n20), .test_se(test_se_5), .clk0_26(clk0_26), 
     .clk0_21(clk0_21), .clk0_3(clk0_5));
  one_shot_1_test_1 one_shot_tf1 (.rst_p(rst_p), .clk(), .d(tf1), .q(tf1_sync), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(n6), .test_so(test_so9), .test_se(test_se_5), .clk0_4(clk0_8));
  NOR2X4 U241_C3_1 (.A(addr_sfr[6]), .B(addr_sfr_7_1), .Y(U256_C2__n_2));
  NOR2X1 U202_C2_4 (.A(U185_C1__n_3), .B(N8939_1), .Y(N7560));
  NAND3X1 U186_C1_2 (.A(addr_sfr_0_1), .B(addr_sfr_1_1), .C(addr_sfr[3]), 
     .Y(N4933_2));
  INVX1 U260_C2_1_MP_INV (.A(addr_sfr[3]), .Y(addr_sfr_3_1));
  INVX1 U470_C1 (.A(\tmod[2] ), .Y(N7421));
  NOR2X1 U284_C1_5 (.A(U213_C3_18_C4__n_13), .B(sbuf_0_1), .Y(N9202));
  INVX1 U202_C2_4_MP_INV (.A(N8939), .Y(N8939_1));
  NOR2X2 U324_C1 (.A(U185_C1__n_3), .B(addr_sfr[6]), .Y(N4902));
  BUFX8 BW2_BUF7015 (.A(test_se_1), .Y(test_se_5));
  OAI2BB1X1 U223_C3_18_C4_12 (.A0N(\p1[3] ), .A1N(U213_C3_18_C4__n), 
     .B0(out_sfr_a_3_1), .Y(out_sfr_a_3_11));
  AOI22X1 U231_C3_12 (.A0(\p2[4] ), .A1(N4902), .B0(\th1[4] ), .B1(N4904_2), 
     .Y(U231_C3__n_5));
  NOR2X4 U223_C3_18_C4_15 (.A(N9443_1), .B(U223_C3__n_6), .Y(out_sfr_a_3_7));
  NAND2X1 U213_C3_18_C4_1 (.A(\p1[5] ), .B(U213_C3_18_C4__n), 
     .Y(U213_C3_18_C4__n_3));
  INVX1 U284_C1_5_MP_INV (.A(\sbuf[0] ), .Y(sbuf_0_1));
  NOR2BX4 U366_C2_6_C3_2 (.AN(N4918_3), .B(tl0_5_1), .Y(N4658));
  OAI2BB1X4 U230_C3_20 (.A0N(out_b[1]), .A1N(N8475), .B0(N4916), 
     .Y(out_sfr_a_1_7));
  AOI22X2 U274_C1_5 (.A0(out_b[6]), .A1(N8475), .B0(out_psw[6]), .B1(N50081), 
     .Y(U273_C1__n_3));
  BUFX4 BW2_BUF11159 (.A(in_sfr[2]), .Y(in_sfr_2_1));
  OAI2BB1X2 U230_C3_21 (.A0N(U213_C3_18_C4__n), .A1N(\p1[1] ), .B0(N2779), 
     .Y(out_sfr_a_1_8));
  NOR2X2 U213_C3_18_C4_22 (.A(out_sfr_a_5_8), .B(out_sfr_a_5_7), 
     .Y(out_sfr_a_5_12));
  NOR2X4 U326_C1_2 (.A(U334_C1__n_5), .B(N8475_1), .Y(N8475));
  OAI2BB1X1 U213_C3_18_C4_17 (.A0N(out_acc_r[5]), .A1N(U213_C3_18_C4__n_1), 
     .B0(U213_C3__n_4), .Y(out_sfr_a_5_7));
  NAND2X1 U326_C1_1 (.A(addr_sfr[6]), .B(addr_sfr[5]), .Y(N8475_1));
  AOI22X1 U273_C1_3 (.A0(out_acc_r[6]), .A1(U213_C3_18_C4__n_1), .B0(\p1[6] ), 
     .B1(U213_C3_18_C4__n), .Y(N10305_1));
  OAI2BB1X2 U230_C3_23 (.A0N(U213_C3_18_C4__n_1), .A1N(out_acc_r[1]), .B0(N7129), 
     .Y(out_sfr_a_1_10));
  OAI2BB1X1 U388_C1_7 (.A0N(\scon[5] ), .A1N(N7310), .B0(U388_C1__n_1), 
     .Y(U388_C1__n));
  AOI22X1 U400_C1_6 (.A0(N7312), .A1(\ie[4] ), .B0(N12322), .B1(\ip[4] ), 
     .Y(U400_C1__n_1));
  OAI2BB1X2 U230_C3_17 (.A0N(out_dptr_r[1]), .A1N(N2877_2), .B0(N2308), 
     .Y(out_sfr_a_1_4));
  NOR2BX4 U261_C1 (.AN(addr_sfr[5]), .B(addr_sfr[4]), .Y(N7312));
  BUFX2 BW1_BUF247_10 (.A(test_se_5), .Y(test_se_3));
  NOR2X2 U249_C1_2 (.A(N2810_1), .B(U256_C2__n_5), .Y(N2810_2));
  NAND2X1 U183_C1_1 (.A(addr_sfr[0]), .B(U249_C1__n_1), .Y(N4596_1));
  NAND2X2 U262_C1 (.A(addr_sfr[4]), .B(addr_sfr[5]), .Y(N12322_1));
  NOR2BX1 U340_C1_3 (.AN(addr_sfr[3]), .B(addr_sfr[2]), .Y(U213_C3_18_C4__n_9));
  NAND2X1 U213_C3_18_C4_19 (.A(out_sfr_a_5_3), .B(U213_C3__n_5), 
     .Y(out_sfr_a_5_9));
  AOI22X1 U212_C3_17 (.A0(\th0[6] ), .A1(N4933), .B0(\tl1[6] ), .B1(N4610_3), 
     .Y(out_sfr_a_6_1));
  NOR3X4 U230_C3_28 (.A(out_sfr_a_1_9), .B(out_sfr_a_1_6), .C(N3136), 
     .Y(out_sfr_a_1_15));
  OAI2BB1X1 U231_C3_19_C4_10 (.A0N(\p3[4] ), .A1N(N8107), .B0(N2355), 
     .Y(out_sfr_a_4_2));
  NAND4X4 U223_C3_18_C4_21 (.A(out_sfr_a_3_8), .B(out_sfr_a_3_10), 
     .C(out_sfr_a_3_7), .D(out_sfr_a_3_9), .Y(out_sfr_a[3]));
  NOR2X2 U231_C3_19_C4_15 (.A(N12133_1), .B(U231_C3__n_6), .Y(out_sfr_a_4_7));
  NAND2X1 U210_C2_4 (.A(\pcon[1] ), .B(N4596), .Y(N4947));
  BUFX4 BW2_BUF5114 (.A(rc8051RtlTop_test_point_535_in), 
     .Y(rc8051RtlTop_test_point_535_in_1));
  INVX1 U594_C1 (.A(\ie[0] ), .Y(N11618));
  INVX1 U406_C2_2_C5_3_MP_INV (.A(\ip[1] ), .Y(ip_1_1));
  NOR3X2 U300_C1_11 (.A(N4602), .B(N4987), .C(N1617), .Y(N4607));
  INVX1 U597_C1 (.A(\ip[2] ), .Y(N7419));
  NOR2X1 U358_C2_3 (.A(N7310_1), .B(N11275), .Y(N6698));
  INVX1 U608_C2_2_MP_INV (.A(\isrc_cur[2] ), .Y(isrc_cur_2_1));
  INVX2 U262_C1_MP_INV (.A(N12322_1), .Y(N12322));
  NAND4X4 U213_C3_18_C4_25 (.A(out_sfr_a_5_12), .B(out_sfr_a_5_13), 
     .C(out_sfr_a_5_2), .D(out_sfr_a_5_10), .Y(out_sfr_a[5]));
  AOI22X1 U223_C3_4 (.A0(out_sp_r[3]), .A1(U224_C3__n_7), .B0(\p0[3] ), 
     .B1(U224_C3__n_1), .Y(N6774_1));
  BUFX4 BL3_S_BUF_17 (.A(U256_C2__n_53), .Y(U256_C2__n_52));
  NOR2X1 U264_C1_1 (.A(addr_sfr[3]), .B(addr_sfr[1]), .Y(U224_C3__n_2));
  OAI22X1 U625_C1_8 (.A0(N4935), .A1(N10791), .B0(U185_C1__n_3), .B1(N5017_1), 
     .Y(out_sfr_a_0_4));
  NOR2X2 U625_C1_15 (.A(out_sfr_a_0_5), .B(out_sfr_a_0_1), .Y(out_sfr_a_0_11));
  NAND2X1 U371_C2_2 (.A(out_dptr_r[7]), .B(N2877_2), .Y(N10558));
  OAI2BB1X1 U625_C1_5 (.A0N(\p0[0] ), .A1N(U224_C3__n_1), .B0(N4936), 
     .Y(out_sfr_a_0_1));
  NAND4X2 U625_C1_22 (.A(out_sfr_a_0_15), .B(out_sfr_a_0_12), .C(out_sfr_a_0_11), 
     .D(out_sfr_a_0_14), .Y(out_sfr_a_0_2));
  NAND4BX4 U212_C3_19 (.AN(N6778), .B(out_sfr_a_6_1), .C(N10070_1), .D(N10070_2), 
     .Y(out_sfr_a[6]));
  tmod_test_1 U_tmod (.clk(), .rst_p(rst_p), .wr(wr_sfr), .in_tmod({in_sfr[7], 
     in_sfr[6], in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, in_sfr[1], 
     in_sfr_0_1}), .addr_tmod({addr_sfr[7], addr_sfr[6], addr_sfr[5], addr_sfr[4], 
     addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .out_tmod({\tmod[7] , 
     \tmod[6] , \tmod[5] , \tmod[4] , \tmod[3] , \tmod[2] , \tmod[1] , 
     \tmod[0] }), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(tcon_7_1), .test_so(tmod_7_1), .test_se(test_se_5), 
     .clk0_5(clk0_8), .clk0_4(clk0_5));
  u_uart_test_1 U_uart (.clk(), .rst_p(rst_p), .rxdi(rxdi), .rxdo(rxdo), 
     .in_sfr({in_sfr[7], in_sfr[6], in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, 
     in_sfr[1], in_sfr_0_1}), .addr_sfr({addr_sfr[7], addr_sfr[6], addr_sfr[5], 
     addr_sfr[4], addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), 
     .wr(wr_sfr), .shift12(shift12), .tf1(tf1_sync), .txdo(txdo), 
     .uart_int(uart_int), .scon({\scon[7] , \scon[6] , \scon[5] , \scon[4] , 
     \scon[3] , \scon[2] , \scon[1] , \scon[0] }), .pcon({\pcon[7] , \pcon[6] , 
     \pcon[5] , \pcon[4] , \pcon[3] , \pcon[2] , \pcon[1] , \pcon[0] }), .sbuf({
     \sbuf[7] , \sbuf[6] , \sbuf[5] , \sbuf[4] , \sbuf[3] , \sbuf[2] , 
     \sbuf[1] , \sbuf[0] }), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si1(tmod_7_1), .test_so1(test_so6), .test_si2(test_si7), 
     .test_so2(test_so7), .test_si3(test_si8), .test_so3(test_so8), 
     .test_si4(test_si9), .test_so4(n7), .test_se(test_se_2), .clk0_4(clk0_5), 
     .clk0_5(clk0_8));
  INVX1 U548_C1 (.A(\tmod[1] ), .Y(N10573));
  OAI2BB1X2 U625_C1_10 (.A0N(\pcon[0] ), .A1N(N4596), .B0(out_sfr_a_0_3), 
     .Y(out_sfr_a_0_6));
  BUFX8 BL3_S_BUF_16 (.A(N1702_1), .Y(N1702));
  NAND2BX1 U202_C2_2 (.AN(N8776), .B(N1597), .Y(N3012));
  NAND2X1 U448_C1 (.A(\pcon[2] ), .B(N4596), .Y(N11462));
  INVX3 U340_C1_7_MP_INV (.A(U213_C3_18_C4__n_13), .Y(U213_C3_18_C4__n_5));
  NAND2X1 U231_C3_6 (.A(\sbuf[4] ), .B(U213_C3_18_C4__n_5), .Y(N12133));
  NAND4X1 U340_C1_7 (.A(U213_C3_18_C4__n_9), .B(U213_C3_18_C4__n_7), 
     .C(U213_C3_18_C4__n_10), .D(U213_C3_18_C4__n_6), .Y(U213_C3_18_C4__n_13));
  INVX1 U224_C3_7_MP_INV (.A(\sbuf[2] ), .Y(sbuf_2_1));
  INVX1 U609_C1 (.A(\scon[2] ), .Y(N10335));
  AND4X1 U214_C3_12 (.A(U275_C1__n_4), .B(U275_C1__n_3), .C(N11169), 
     .D(N10766_1), .Y(U214_C3__n_6));
  BUFX16 BL3_S_BUF_10 (.A(out_sfr_a_7_2), .Y(out_sfr_a[7]));
  ie_test_1 U_ie (.clk(), .rst_p(rst_p), .in_ie({in_sfr[7], in_sfr[6], in_sfr[5], 
     in_sfr[4], in_sfr[3], in_sfr_2_1, in_sfr[1], in_sfr_0_1}), .addr_ie({
     addr_sfr[7], addr_sfr[6], addr_sfr[5], addr_sfr[4], addr_sfr[3], 
     addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .wr(wr_sfr), .out_ie({\ie[7] , 
     \ie[6] , \ie[5] , \ie[4] , \ie[3] , \ie[2] , \ie[1] , \ie[0] }), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si1(n26), .test_so1(test_so4), .test_si2(test_si5), 
     .test_so2(ie_7_1), .test_se(test_se_4), .clk0_7(clk0_10));
  OAI2BB1X1 U625_C1_9 (.A0N(out_dptr_r[0]), .A1N(N2877_2), .B0(N12132), 
     .Y(out_sfr_a_0_5));
  NOR2X4 U235_C3_2 (.A(addr_sfr[3]), .B(addr_sfr[2]), .Y(U334_C1__n_2));
  NAND2X1 U284_C1_7 (.A(addr_sfr[6]), .B(out_acc_r[0]), .Y(N5017_1));
  dimod_test_1 U1_dimod (.clk(), .rst_p(rst_p), .wr(wr_sfr), .addr_dimod({
     addr_sfr[7], addr_sfr[6], addr_sfr[5], addr_sfr[4], addr_sfr[3], 
     addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .in_dimod({in_sfr[7], in_sfr[6], 
     in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, in_sfr[1], in_sfr_0_1}), 
     .out_dimod({out_dimod_r[7], out_dimod_r[6], out_dimod_r[5], out_dimod_r[4], 
     out_dimod_r[3], out_dimod_r[2], out_dimod_r[1], out_dimod_r[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si(n37), .test_so(n36), .test_se(test_se_4), .clk0_7(clk0_10));
  dptr_test_1 U1_dptr (.clk(), .rst_p(rst_p), .ld_dpl(ld_dpl), .ld_dph(ld_dph), 
     .wr(wr_sfr), .inc_dptr(inc_dptr), .addr_dptr({addr_sfr[7], addr_sfr[6], 
     addr_sfr[5], addr_sfr[4], addr_sfr[3], addr_sfr[2], addr_sfr[1], 
     addr_sfr[0]}), .in_dptr({in_sfr[7], in_sfr[6], in_sfr[5], in_sfr[4], 
     in_sfr[3], in_sfr_2_1, in_sfr[1], in_sfr_0_1}), .out_dptr({out_dptr_r[15], 
     out_dptr_r[14], out_dptr_r[13], out_dptr_r[12], out_dptr_r[11], 
     out_dptr_r[10], out_dptr_r[9], out_dptr_r[8], out_dptr_r[7], out_dptr_r[6], 
     out_dptr_r[5], out_dptr_r[4], out_dptr_r[3], out_dptr_r[2], out_dptr_r[1], 
     out_dptr_r[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(n36), .test_so(n35), .test_se(test_se_4), .clk0_21(clk0_21), 
     .clk0_4(clk0_8), .clk0_8(clk0_10));
  OAI2BB2X4 U230_C3_16 (.A0N(N4933), .A1N(\th0[1] ), .B0(N4607), .B1(N10791), 
     .Y(out_sfr_a_1_3));
  INVX2 U347_C3_3_MP_INV (.A(addr_sfr[7]), .Y(addr_sfr_7_1));
  NOR3X2 U188_C1_2 (.A(U256_C2__n_51), .B(addr_sfr_0_1), .C(U256_C2__n), 
     .Y(N1702_1));
  NOR2X4 U186_C1_3 (.A(U240_C1__n_4), .B(N4933_2), .Y(N4933));
  INVX4 U266_C1_2_MP_INV (.A(addr_sfr[0]), .Y(addr_sfr_0_1));
  NAND2BX1 U356_C2_3 (.AN(N10573), .B(N1702), .Y(N10040));
  NAND2X1 U224_C3_8 (.A(\p2[2] ), .B(N4902), .Y(N11798));
  NOR2BX1 U434_C1 (.AN(\p2[0] ), .B(addr_sfr[6]), .Y(N8939));
  NAND2X1 U300_C1_5 (.A(\p3[1] ), .B(N8107), .Y(N4916));
  NAND2X1 U213_C3_18_C4_9 (.A(\p3[5] ), .B(N8107), .Y(N11128));
  OAI2BB1X1 U231_C3_19_C4_12 (.A0N(\p1[4] ), .A1N(U213_C3_18_C4__n), 
     .B0(out_sfr_a_4_1), .Y(out_sfr_a_4_12));
  INVX1 U231_C3_19_C4_15_MP_INV_1 (.A(U231_C3__n_5), .Y(U231_C3__n_6));
  OAI2BB1X1 U625_C1_12 (.A0N(\p1[0] ), .A1N(U213_C3_18_C4__n), .B0(N2980), 
     .Y(out_sfr_a_0_8));
  AOI22X1 U223_C3_16 (.A0(\th0[3] ), .A1(N4933), .B0(\tl1[3] ), .B1(N4610_3), 
     .Y(out_sfr_a_3_1));
  AOI22X1 U363_C2_5 (.A0(\tl0[6] ), .A1(N4918_3), .B0(\tmod[6] ), .B1(N1702), 
     .Y(N6778_1));
  NAND2X1 U226_C4_4 (.A(\tl0[0] ), .B(N4918_3), .Y(N8524));
  NAND2X1 U226_C4_5 (.A(\tl1[0] ), .B(N4610_3), .Y(N1299));
  NAND2X1 U284_C1_2 (.A(\p3[0] ), .B(N8107), .Y(N4944));
  BUFX3 BW1_BUF247_6 (.A(test_se), .Y(test_se_1));
  OAI2BB1X1 U625_C1_13 (.A0N(out_b[0]), .A1N(N8475), .B0(N4944), 
     .Y(out_sfr_a_0_9));
  AOI22X1 U275_C1_3 (.A0(out_acc_r[7]), .A1(U213_C3_18_C4__n_1), .B0(\p1[7] ), 
     .B1(U213_C3_18_C4__n), .Y(N10766_1));
  NOR2X4 U258_C1_2 (.A(U334_C1__n_5), .B(N5008_1), .Y(N5008));
  OAI2BB1X1 U223_C3_18_C4_10 (.A0N(\p3[3] ), .A1N(N8107), .B0(N8162), 
     .Y(out_sfr_a_3_2));
  NOR2X2 U231_C3_19_C4_18 (.A(out_sfr_a_4_6), .B(out_sfr_a_4_4), 
     .Y(out_sfr_a_4_10));
  NAND2X1 U231_C3_19_C4_14 (.A(out_sfr_a_4_3), .B(U231_C3__n_4), 
     .Y(out_sfr_a_4_6));
  NAND2X1 U213_C3_18_C4_11 (.A(out_psw[5]), .B(N5008), .Y(N3144));
  OAI2BB1X1 U396_C1_7 (.A0N(\scon[3] ), .A1N(N7310), .B0(U396_C1__n_1), 
     .Y(U396_C1__n));
  AND3X1 U608_C2_2 (.A(isrc_cur_2_1), .B(\isrc_cur[1] ), .C(\isrc_cur[0] ), 
     .Y(rst_ie1));
  AOI21X2 U231_C3_19_C4_16 (.A0(n173_1), .A1(U400_C1__n), .B0(N11130), 
     .Y(out_sfr_a_4_8));
  NAND2X1 U210_C2_2 (.A(out_dptr_r[9]), .B(N2810_2), .Y(N2308));
  BUFX8 BW2_BUF1944 (.A(test_se_3), .Y(test_se_6));
  AOI22X1 U365_C2_5 (.A0(out_dptr_r[13]), .A1(N2810_21), .B0(\pcon[5] ), 
     .B1(N4596), .Y(U213_C3__n_4));
  NOR2X1 U249_C1_3 (.A(N2810_1), .B(U256_C2__n_5), .Y(N2810_21));
  NAND2BX2 U263_C1 (.AN(addr_sfr[5]), .B(addr_sfr[4]), .Y(N7310_1));
  NAND3X4 U194_C2_3 (.A(U194_C2__n), .B(U185_C1__n_1), .C(addr_sfr_3_1), 
     .Y(U185_C1__n_3));
  NOR3X4 U240_C1_2 (.A(U240_C1__n_4), .B(U256_C2__n), .C(addr_sfr_0_1), 
     .Y(N4904_2));
  NAND3X4 U349_C3_4 (.A(U240_C1__n_1), .B(U240_C1__n_2), .C(addr_sfr[2]), 
     .Y(U240_C1__n_4));
  NAND4X1 U230_C3_22 (.A(U230_C3__n_3), .B(U230_C3__n_2), .C(N4912), .D(N11745), 
     .Y(out_sfr_a_1_9));
  parity_gen U4_parity (.p_acc({out_acc_r[7], out_acc_r[6], out_acc_r[5], 
     out_acc_r[4], out_acc_r[3], out_acc_r[2], out_acc_r[1], out_acc_r[0]}), 
     .parity(parity));
  AOI22X1 U212_C3_12 (.A0(\p2[6] ), .A1(N4902), .B0(\th1[6] ), .B1(N4904_2), 
     .Y(U212_C3__n_5));
  NOR2BX1 U406_C2_2_C5_2 (.AN(N7312), .B(ie_1_1), .Y(N4602));
  INVX8 U241_C3_4_MP_INV_1 (.A(addr_sfr[2]), .Y(addr_sfr_2_1));
  INVX1 U185_C1_MP_INV (.A(addr_sfr[6]), .Y(addr_sfr_6_1));
  INVX1 U603_C1 (.A(\ie[2] ), .Y(N10336));
  NOR3X2 U292_C1_11 (.A(N4880), .B(N4873), .C(N2269), .Y(N7051));
  NOR2X1 U192_C1_3 (.A(N12322_1), .B(N7411), .Y(N1374));
  NOR2X4 U230_C3_24 (.A(out_sfr_a_1_5), .B(out_sfr_a_1_4), .Y(out_sfr_a_1_11));
  NOR2X1 U281_C2_3 (.A(N7310_1), .B(N10335), .Y(N2269));
  AOI22X1 U421_C1_6 (.A0(N7312), .A1(\ie[7] ), .B0(N12322), .B1(\ip[7] ), 
     .Y(U421_C1__n_1));
  INVX1 U263_C1_MP_INV (.A(N7310_1), .Y(N7310));
  BUFX16 BL3_S_BUF_11 (.A(out_sfr_a_2_16), .Y(out_sfr_a[2]));
  NAND4X4 U224_C3_29 (.A(out_sfr_a_2_15), .B(out_sfr_a_2_14), .C(out_sfr_a_2_12), 
     .D(out_sfr_a_2_11), .Y(out_sfr_a_2_16));
  NOR2X4 U336_C1_3 (.A(U256_C2__n_52), .B(U224_C3__n_9), .Y(U224_C3__n_1));
  NAND3X1 U241_C3_6 (.A(U256_C2__n_2), .B(U256_C2__n_3), .C(addr_sfr_2_1), 
     .Y(U256_C2__n_53));
  NOR2X1 U625_C1_18 (.A(out_sfr_a_0_6), .B(out_sfr_a_0_4), .Y(out_sfr_a_0_14));
  NAND2X1 U264_C1_2 (.A(addr_sfr[0]), .B(U224_C3__n_2), .Y(U224_C3__n_6));
  INVX1 U213_C3_18_C4_12_MP_INV (.A(N7874), .Y(N7874_1));
  NOR2X1 U213_C3_18_C4_12 (.A(N7874_1), .B(N4658), .Y(out_sfr_a_5_2));
  NAND2X4 U230_C3_2 (.A(\p0[1] ), .B(U224_C3__n_1), .Y(U230_C3__n_3));
  NAND4BX4 U214_C3_18 (.AN(N10989), .B(out_sfr_a_7_1), .C(N6996_2), .D(N6996_1), 
     .Y(out_sfr_a_7_2));
  OAI2BB1X2 U224_C3_15 (.A0N(out_dptr_r[2]), .A1N(N2877_2), .B0(N949), 
     .Y(out_sfr_a_2_4));
  tcon_test_1 U_tcon (.clk(), .rst_p(rst_p), .in_tcon({in_sfr[7], in_sfr[6], 
     in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, in_sfr[1], in_sfr_0_1}), 
     .addr_tcon({addr_sfr[7], addr_sfr[6], addr_sfr[5], addr_sfr[4], 
     addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .wr(wr_sfr), 
     .set_tf0(tf0_sync), .rst_tf0(rst_tf0), .set_tf1(tf1_sync), 
     .rst_tf1(rst_tf1), .set_ie0(set_ie0), .rst_ie0(rst_ie0), .set_ie1(set_ie1), 
     .rst_ie1(rst_ie1), .out_tcon({\tcon[7] , \tcon[6] , \tcon[5] , \tcon[4] , 
     \tcon[3] , \tcon[2] , \tcon[1] , \tcon[0] }), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(n16), .test_so(tcon_7_1), .test_se(test_se_6), .clk0_4(clk0_8));
  NOR2X1 U230_C3_6 (.A(U213_C3_18_C4__n_13), .B(N11619), .Y(N3136));
  NOR2X1 U224_C3_7 (.A(U213_C3_18_C4__n_13), .B(sbuf_2_1), .Y(N1564));
  NOR2X2 U349_C3_2 (.A(addr_sfr[4]), .B(addr_sfr[5]), .Y(U240_C1__n_2));
  OAI2BB1X1 U224_C3_16 (.A0N(\tcon[2] ), .A1N(N1597), .B0(N11462), 
     .Y(out_sfr_a_2_5));
  OAI2BB1X1 U372_C2_6 (.A0N(\tcon[7] ), .A1N(N1597), .B0(N10989_1), .Y(N10989));
  INVX1 U231_C3_19_C4_15_MP_INV (.A(N12133), .Y(N12133_1));
  NOR2X4 U266_C1_3 (.A(U256_C2__n_511), .B(N4918_2), .Y(N4918_3));
  NAND3X1 U266_C1_2 (.A(addr_sfr_0_1), .B(addr_sfr[1]), .C(addr_sfr[3]), 
     .Y(N4918_2));
  AOI22X1 U274_C1_6 (.A0(n173_1), .A1(U381_C1__n), .B0(\p3[6] ), .B1(N8107), 
     .Y(U273_C1__n_4));
  BUFX8 BW1_BUF247_8 (.A(test_se_5), .Y(test_se_2));
  AOI22X1 U212_C3_4 (.A0(out_sp_r[6]), .A1(U224_C3__n_7), .B0(\p0[6] ), 
     .B1(U224_C3__n_1), .Y(N10070_1));
  BUFX16 BL3_S_BUF_8 (.A(out_sfr_a_4_11), .Y(out_sfr_a[4]));
  NOR2X1 U224_C3_22 (.A(out_sfr_a_2_8), .B(out_sfr_a_2_4), .Y(out_sfr_a_2_11));
  NOR2X4 U235_C3_3 (.A(addr_sfr[1]), .B(addr_sfr[0]), .Y(U334_C1__n_3));
  NAND2X4 U284_C1_4 (.A(out_psw[0]), .B(N5008), .Y(N3952));
  ip_test_1 U_ip (.clk(), .rst_p(rst_p), .in_ip({in_sfr[7], in_sfr[6], in_sfr[5], 
     in_sfr[4], in_sfr[3], in_sfr_2_1, in_sfr[1], in_sfr_0_1}), .addr_ip({
     addr_sfr[7], addr_sfr[6], addr_sfr[5], addr_sfr[4], addr_sfr[3], 
     addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .wr(wr_sfr), .out_ip({\ip[7] , 
     \ip[6] , \ip[5] , \ip[4] , \ip[3] , \ip[2] , \ip[1] , \ip[0] }), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(ie_7_1), .test_so(ip_7_1), .test_se(test_se_3), .clk0_4(clk0_8), 
     .clk0_7(clk0_10));
  u_int_test_1 U27_int (.disint(disint), .end_instr(end_instr), .ti_ri(uart_int), 
     .clk(), .rst_p(rst_p), .ex_int_a(int0_pin), .ex_int_b(int1_pin), 
     .it_a(\tcon[0] ), .it_b(\tcon[2] ), .tf_a(\tcon[5] ), .tf_b(\tcon[7] ), 
     .ie_j(\ie[7] ), .ie({\ie[4] , \ie[3] , \ie[2] , \ie[1] , \ie[0] }), .ip({
     \ip[4] , \ip[3] , \ip[2] , \ip[1] , \ip[0] }), .ie_a(\tcon[1] ), 
     .ie_b(\tcon[3] ), .smpl_ex_a(set_ie0), .smpl_ex_b(set_ie1), .int_vec({
     int_vec[2], int_vec[1], int_vec[0]}), .reti(reti), .isrc_cur({\isrc_cur[2] , 
     \isrc_cur[1] , \isrc_cur[0] }), .en_int(en_int), 
     .rc8051RtlTop_test_mode_in(rc8051RtlTop_test_mode_in), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(tl1_7_1), .test_so(n26), .test_se(test_se_6), .clk0_7(clk0_10), 
     .clk0_4(clk0_8));
  gpio2_test_1 U_port2 (.clk(), .rst_p(rst_p), .wr(wr_sfr), .rmw(rmw), .combus({
     in_sfr[7], in_sfr[6], in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, 
     in_sfr[1], in_sfr_0_1}), .prt2_addr({addr_sfr[7], addr_sfr[6], addr_sfr[5], 
     addr_sfr[4], addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .p2_in({
     p2_in[7], p2_in[6], p2_in[5], p2_in[4], p2_in[3], p2_in[2], p2_in[1], 
     p2_in[0]}), .p2({\p2[7] , \p2[6] , \p2[5] , \p2[4] , \p2[3] , \p2[2] , 
     \p2[1] , \p2[0] }), .p2_out({p2_out[7], p2_out[6], p2_out[5], p2_out[4], 
     p2_out[3], p2_out[2], p2_out[1], p2_out[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si1(n20), .test_so1(test_so5), .test_si2(test_si6), .test_so2(n17), 
     .test_se(test_se_5), .clk0_21(clk0_21));
  NOR2BX1 U194_C2_1 (.AN(addr_sfr[5]), .B(addr_sfr[4]), .Y(U185_C1__n_1));
  NOR2X1 U260_C2_1 (.A(addr_sfr_3_1), .B(addr_sfr[6]), .Y(N10791_1));
  NOR4X4 U347_C3_3 (.A(addr_sfr[0]), .B(addr_sfr[2]), .C(addr_sfr[1]), 
     .D(addr_sfr_7_1), .Y(U194_C2__n));
  NOR2X2 U213_C3_18_C4_23 (.A(out_sfr_a_5_9), .B(out_sfr_a_5_6), 
     .Y(out_sfr_a_5_13));
  OAI2BB1X4 U625_C1_11 (.A0N(\tmod[0] ), .A1N(N1702), .B0(N3012), 
     .Y(out_sfr_a_0_7));
  NAND2BX1 U354_C2_3 (.AN(N7421), .B(N1702), .Y(N6531));
  NAND2X1 U230_C3_7 (.A(\p2[1] ), .B(N4902), .Y(N7129));
  NOR2X1 U185_C1 (.A(U185_C1__n_3), .B(addr_sfr_6_1), .Y(U213_C3_18_C4__n_1));
  OAI2BB1X1 U224_C3_18 (.A0N(out_b[2]), .A1N(N8475), .B0(N4883), 
     .Y(out_sfr_a_2_7));
  NAND2X1 U213_C3_18_C4_10 (.A(out_b[5]), .B(N8475), .Y(N3942));
  INVX1 U223_C3_18_C4_15_MP_INV_1 (.A(U223_C3__n_5), .Y(U223_C3__n_6));
  AOI22X1 U223_C3_11 (.A0(\p2[3] ), .A1(N4902), .B0(\th1[3] ), .B1(N4904_2), 
     .Y(U223_C3__n_5));
  NAND2BX1 U202_C2_6 (.AN(th1_0_1), .B(N4904_2), .Y(N2980));
  BUFX8 BL3_S_BUF_12 (.A(out_sfr_a_3_11), .Y(out_sfr_a_3_4));
  INVX1 U366_C2_6_C3_2_MP_INV (.A(\tl0[5] ), .Y(tl0_5_1));
  AOI22X1 U375_C2_5 (.A0(\tl0[3] ), .A1(N4918_3), .B0(\tmod[3] ), .B1(N17021), 
     .Y(N12234_1));
  OAI2BB1X1 U224_C3_13 (.A0N(\tl1[2] ), .A1N(N4610_3), .B0(U224_C3__n_5), 
     .Y(out_sfr_a_2_2));
  AOI22X2 U276_C1_5 (.A0(out_b[7]), .A1(N8475), .B0(out_psw[7]), .B1(N50081), 
     .Y(U275_C1__n_3));
  AOI22X1 U231_C3_19_C4_11 (.A0(out_b[4]), .A1(N8475), .B0(out_psw[4]), 
     .B1(N50081), .Y(out_sfr_a_4_3));
  NOR2X1 U230_C3_25 (.A(out_sfr_a_1_8), .B(out_sfr_a_1_7), .Y(out_sfr_a_1_12));
  OAI2BB1X1 U223_C3_18_C4_13 (.A0N(out_acc_r[3]), .A1N(U213_C3_18_C4__n_1), 
     .B0(N6774_1), .Y(out_sfr_a_3_5));
  NOR2X4 U254_C1_2 (.A(U334_C1__n_5), .B(U213_C3_18_C4__n_2), 
     .Y(U213_C3_18_C4__n));
  OAI2BB1X1 U231_C3_19_C4_13 (.A0N(out_acc_r[4]), .A1N(U213_C3_18_C4__n_1), 
     .B0(N7019_1), .Y(out_sfr_a_4_5));
  NOR2X1 U258_C1_3 (.A(U334_C1__n_5), .B(N5008_1), .Y(N50081));
  NAND2X1 U223_C3_18_C4_14 (.A(out_sfr_a_3_3), .B(U223_C3__n_4), 
     .Y(out_sfr_a_3_6));
  NAND2X1 U300_C1_7 (.A(out_psw[1]), .B(N5008), .Y(N2779));
  NOR3X1 U607_C2_2 (.A(isrc_cur_2_1), .B(\isrc_cur[1] ), .C(\isrc_cur[0] ), 
     .Y(rst_tf1));
  NOR2BX2 U255_C1 (.AN(addr_sfr[1]), .B(addr_sfr[3]), .Y(U249_C1__n_1));
  NAND2X1 U353_C2_2 (.A(out_dptr_r[10]), .B(N2810_2), .Y(N949));
  AOI22X1 U213_C3_18_C4_20 (.A0(U388_C1__n), .A1(n173_1), .B0(\sbuf[5] ), 
     .B1(U213_C3_18_C4__n_5), .Y(out_sfr_a_5_10));
  AOI22X1 U374_C2_5 (.A0(out_dptr_r[11]), .A1(N2810_21), .B0(\pcon[3] ), 
     .B1(N4596), .Y(U223_C3__n_4));
  AOI31X1 U624_C2_1 (.A0(wr_sfr), .A1(addr_sfr[5]), .A2(n173_1), .B0(reti), 
     .Y(disint_1));
  AOI21X2 U223_C3_18_C4_16 (.A0(n173_1), .A1(U396_C1__n), .B0(N12234), 
     .Y(out_sfr_a_3_8));
  OAI2BB1X1 U230_C3_18 (.A0N(\tcon[1] ), .A1N(N1597), .B0(N4947), 
     .Y(out_sfr_a_1_5));
  NOR2BX1 U340_C1_4 (.AN(addr_sfr[0]), .B(addr_sfr[1]), .Y(U213_C3_18_C4__n_10));
  NAND3X1 U265_C1_2 (.A(addr_sfr[3]), .B(addr_sfr[1]), .C(addr_sfr[0]), 
     .Y(N4610_2));
  AOI22X1 U214_C3_16 (.A0(\th0[7] ), .A1(N4933), .B0(\tl1[7] ), .B1(N4610_3), 
     .Y(out_sfr_a_7_1));
  OAI2BB1X4 U230_C3_19 (.A0N(\th1[1] ), .A1N(N4904_2), .B0(N10040), 
     .Y(out_sfr_a_1_6));
  INVX1 U254_C1_1_MP_INV (.A(addr_sfr[5]), .Y(addr_sfr_5_1));
  NOR2X1 U231_C3_19_C4_17 (.A(out_sfr_a_4_5), .B(out_sfr_a_4_2), 
     .Y(out_sfr_a_4_9));
  AOI22X1 U231_C3_17 (.A0(\th0[4] ), .A1(N4933), .B0(\tl1[4] ), .B1(N4610_3), 
     .Y(out_sfr_a_4_1));
  NAND2X2 U260_C2_2 (.A(N10791_1), .B(U194_C2__n), .Y(N10791));
  INVX1 U593_C1 (.A(\ip[0] ), .Y(N7411));
  INVX1 U624_C2_1_MP_INV (.A(disint_1), .Y(disint));
  NOR2BX1 U281_C2_2 (.AN(N7312), .B(N10336), .Y(N4880));
  NOR2X1 U300_C1_3 (.A(N7310_1), .B(scon_1_1), .Y(N1617));
  AOI22X1 U396_C1_6 (.A0(N7312), .A1(\ie[3] ), .B0(N12322), .B1(\ip[3] ), 
     .Y(U396_C1__n_1));
  AOI22X1 U381_C1_6 (.A0(N7312), .A1(\ie[6] ), .B0(N12322), .B1(\ip[6] ), 
     .Y(U381_C1__n_1));
  OAI2BB1X2 U381_C1_7 (.A0N(\scon[6] ), .A1N(N7310), .B0(U381_C1__n_1), 
     .Y(U381_C1__n));
  OAI2BB1X1 U400_C1_7 (.A0N(\scon[4] ), .A1N(N7310), .B0(U400_C1__n_1), 
     .Y(U400_C1__n));
  AND4X2 U212_C3_15 (.A(U212_C3__n_6), .B(U212_C3__n_5), .C(U212_C3__n_4), 
     .D(N1429), .Y(N10070_2));
  AOI22X1 U231_C3_4 (.A0(out_sp_r[4]), .A1(U224_C3__n_7), .B0(\p0[4] ), 
     .B1(U224_C3__n_1), .Y(N7019_1));
  NOR2X4 U241_C3_2 (.A(addr_sfr[4]), .B(addr_sfr[5]), .Y(U256_C2__n_3));
  OAI2BB1X1 U224_C3_12 (.A0N(U224_C3__n_7), .A1N(out_sp_r[2]), .B0(N4826), 
     .Y(out_sfr_a_2_1));
  AND4X2 U214_C3_14 (.A(U214_C3__n_6), .B(U214_C3__n_5), .C(U214_C3__n_4), 
     .D(N10558), .Y(N6996_2));
  NAND2BX1 U331_C1_1 (.AN(addr_sfr[0]), .B(U249_C1__n_1), .Y(N2877_1));
  INVX2 U624_C2_1_MP_INV_1 (.A(N10791), .Y(n173_1));
  NAND2X1 U226_C4_2 (.A(out_sp_r[0]), .B(U224_C3__n_7), .Y(N4936));
  NAND2X2 U230_C3_1 (.A(out_sp_r[1]), .B(U224_C3__n_7), .Y(U230_C3__n_2));
  NOR3X4 U224_C3_25 (.A(out_sfr_a_2_10), .B(out_sfr_a_2_3), .C(N1564), 
     .Y(out_sfr_a_2_14));
  acc_test_1 U2_acc (.clk(), .rst_p(rst_p), .ld_acc(ld_acc), 
     .ld_acc_chd(ld_acc_chd), .wr(wr_sfr), .addr_acc({addr_sfr[7], addr_sfr[6], 
     addr_sfr[5], addr_sfr[4], addr_sfr[3], addr_sfr[2], addr_sfr[1], 
     addr_sfr[0]}), .in_acc({in_sfr[7], in_sfr[6], in_sfr[5], in_sfr[4], 
     in_sfr[3], in_sfr_2_1, in_sfr[1], in_sfr_0_1}), .acc_chd({acc_chd[7], 
     acc_chd[6], acc_chd[5], acc_chd[4], acc_chd[3], acc_chd[2], acc_chd[1], 
     acc_chd[0]}), .out_acc_r({out_acc_r[7], out_acc_r[6], out_acc_r[5], 
     out_acc_r[4], out_acc_r[3], out_acc_r[2], out_acc_r[1], out_acc_r[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(n35), .test_so(n34), .test_se(test_se_1), .clk0_21(clk0_21), 
     .clk0_8(clk0_10));
  gpio0_test_1 U_port0 (.clk(), .rst_p(rst_p), .wr(wr_sfr), .rmw(rmw), .combus({
     in_sfr[7], in_sfr[6], in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, 
     in_sfr[1], in_sfr_0_1}), .prt0_addr({addr_sfr[7], addr_sfr[6], addr_sfr[5], 
     addr_sfr[4], addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .p0_in({
     p0_in[7], p0_in[6], p0_in[5], p0_in[4], p0_in[3], p0_in[2], p0_in[1], 
     p0_in[0]}), .p0({\p0[7] , \p0[6] , \p0[5] , \p0[4] , \p0[3] , \p0[2] , 
     \p0[1] , \p0[0] }), .p0_out({p0_out[7], p0_out[6], p0_out[5], p0_out[4], 
     p0_out[3], p0_out[2], p0_out[1], p0_out[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(ip_7_1), .test_so(n21), .test_se(test_se_5), .clk0_21(clk0_21));
  NAND2X1 U354_C2_4 (.A(\tl0[2] ), .B(N4918_3), .Y(N4826));
  AOI22X1 U213_C3_18_C4_13 (.A0(\tcon[5] ), .A1(N1597), .B0(\tmod[5] ), 
     .B1(N1702), .Y(out_sfr_a_5_3));
  NOR3X2 U256_C2_2 (.A(U256_C2__n_51), .B(addr_sfr[0]), .C(U256_C2__n), 
     .Y(N1597));
  INVX1 U592_C1 (.A(\tcon[0] ), .Y(N8776));
  OAI2BB1X1 U369_C2_6 (.A0N(\tcon[4] ), .A1N(N1597), .B0(N11130_1), .Y(N11130));
  NAND2X1 U223_C3_8 (.A(\sbuf[3] ), .B(U213_C3_18_C4__n_5), .Y(N9443));
  NOR3X4 U625_C1_19 (.A(out_sfr_a_0_10), .B(out_sfr_a_0_7), .C(N9202), 
     .Y(out_sfr_a_0_15));
  NAND3X4 U241_C3_7 (.A(U256_C2__n_2), .B(U256_C2__n_3), .C(addr_sfr_2_1), 
     .Y(U256_C2__n_511));
  INVX1 U208_C1 (.A(\sbuf[1] ), .Y(N11619));
  INVX1 U595_C1 (.A(\scon[0] ), .Y(N11275));
  AOI22X1 U213_C3_4 (.A0(out_sp_r[5]), .A1(U224_C3__n_7), .B0(\p0[5] ), 
     .B1(U224_C3__n_1), .Y(N7113_1));
  NAND4X4 U230_C3_31 (.A(out_sfr_a_1_15), .B(out_sfr_a_1_14), .C(out_sfr_a_1_12), 
     .D(out_sfr_a_1_11), .Y(out_sfr_a[1]));
  u_tc_test_1 U12_u_tc (.clk(), .rst_p(rst_p), .wr(wr_sfr), .in_tc({in_sfr[7], 
     in_sfr[6], in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, in_sfr[1], 
     in_sfr_0_1}), .addr_tc({addr_sfr[7], addr_sfr[6], addr_sfr[5], addr_sfr[4], 
     addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .t0_pin(t0_pin), 
     .t1_pin(t1_pin), .int0_pin(int0_pin), .int1_pin(int1_pin), 
     .sel_tc0(\tmod[2] ), .sel_tc1(\tmod[6] ), .gate0(\tmod[3] ), 
     .gate1(\tmod[7] ), .tr0(\tcon[4] ), .tr1(\tcon[6] ), .tm0({\tmod[1] , 
     \tmod[0] }), .tm1({\tmod[5] , \tmod[4] }), .tf0(tf0), .tf1(tf1), .tl0({
     \tl0[7] , \tl0[6] , \tl0[5] , \tl0[4] , \tl0[3] , \tl0[2] , \tl0[1] , 
     \tl0[0] }), .tl1({\tl1[7] , \tl1[6] , \tl1[5] , \tl1[4] , \tl1[3] , \tl1[2] , 
     \tl1[1] , \tl1[0] }), .th0({\th0[7] , \th0[6] , \th0[5] , \th0[4] , \th0[3] , 
     \th0[2] , \th0[1] , \th0[0] }), .th1({\th1[7] , \th1[6] , \th1[5] , \th1[4] , 
     \th1[3] , \th1[2] , \th1[1] , \th1[0] }), .shift12(shift12), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si1(n30), .test_so1(test_so3), .test_si2(test_si4), 
     .test_so2(tl1_7_1), .test_se(test_se_5), .clk0_3(clk0_5), 
     .clk0_26(clk0_26));
  NOR2X4 U334_C1_2 (.A(U334_C1__n_5), .B(N8107_1), .Y(N8107));
  NAND2X1 U249_C1_1 (.A(addr_sfr[0]), .B(U249_C1__n_1), .Y(N2810_1));
  NAND4X4 U235_C3_5 (.A(U334_C1__n_2), .B(addr_sfr[4]), .C(U334_C1__n_3), 
     .D(addr_sfr[7]), .Y(U334_C1__n_5));
  one_shot_2_test_1 one_shot_tf0 (.rst_p(rst_p), .clk(), .d(tf0), .q(tf0_sync), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(n7), .test_so(n6), .test_se(test_se_5), .clk0_4(clk0_8));
  psw_test_1 U3_psw (.rst_p(rst_p), .in_psw({in_sfr[7], in_sfr[6], in_sfr[5], 
     in_sfr[4], in_sfr[3], in_sfr_2_1, in_sfr[1]}), .clk(), .addr_psw({
     addr_sfr[7], addr_sfr[6], addr_sfr[5], addr_sfr[4], addr_sfr[3], 
     addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .wr(wr_sfr), .in_cy_bit(in_cy_bit), 
     .set_c(set_c), .rst_c(rst_c), .cpl_c(cpl_c), .ld_c(ld_c), .set_ac(set_ac), 
     .rst_ac(rst_ac), .set_v(set_v), .rst_v(rst_v), .parity(parity), .out_psw({
     out_psw[7], out_psw[6], out_psw[5], out_psw[4], out_psw[3], out_psw[2], 
     out_psw[1], out_psw[0]}), 
     .rc8051RtlTop_test_mode_in(rc8051RtlTop_test_mode_in), .test_si1(n34), 
     .test_so1(test_so2), .test_si2(test_si3), .test_so2(n31), 
     .test_se(test_se), .clk0_21(clk0_21), .clk0_8(clk0_10));
  INVX1 U186_C1_2_MP_INV (.A(addr_sfr[1]), .Y(addr_sfr_1_1));
  NOR2BX1 U340_C1_2 (.AN(addr_sfr[4]), .B(addr_sfr[5]), .Y(U213_C3_18_C4__n_7));
  NOR3X2 U188_C1_3 (.A(U256_C2__n_51), .B(addr_sfr_0_1), .C(U256_C2__n), 
     .Y(N17021));
  NAND2X1 U213_C3_18_C4_16 (.A(out_sfr_a_5_1), .B(N7113_1), .Y(out_sfr_a_5_6));
  NOR2X4 U265_C1_3 (.A(U256_C2__n_511), .B(N4610_2), .Y(N4610_3));
  AOI22X1 U369_C2_5 (.A0(\tl0[4] ), .A1(N4918_3), .B0(\tmod[4] ), .B1(N17021), 
     .Y(N11130_1));
  OAI2BB1X1 U224_C3_21 (.A0N(U213_C3_18_C4__n_1), .A1N(out_acc_r[2]), 
     .B0(N11798), .Y(out_sfr_a_2_10));
  NAND2X1 U224_C3_2 (.A(\p0[2] ), .B(U224_C3__n_1), .Y(U224_C3__n_5));
  NOR2X4 U625_C1_16 (.A(out_sfr_a_0_9), .B(out_sfr_a_0_8), .Y(out_sfr_a_0_12));
  NAND2X1 U292_C1_5 (.A(\p3[2] ), .B(N8107), .Y(N4883));
  BUFX8 BL3_S_BUF_13 (.A(out_sfr_a_4_12), .Y(out_sfr_a_4_4));
  NAND2X1 U230_C3_10 (.A(\tl1[1] ), .B(N4610_3), .Y(N4912));
  OAI2BB1X1 U224_C3_17 (.A0N(\th1[2] ), .A1N(N4904_2), .B0(N6531), 
     .Y(out_sfr_a_2_6));
  INVX1 U202_C2_6_MP_INV (.A(\th1[0] ), .Y(th1_0_1));
  AOI22X1 U372_C2_5 (.A0(\tl0[7] ), .A1(N4918_3), .B0(\tmod[7] ), .B1(N1702), 
     .Y(N10989_1));
  NAND2X1 U356_C2_4 (.A(\tl0[1] ), .B(N4918_3), .Y(N11745));
  AOI22X1 U213_C3_16 (.A0(\th0[5] ), .A1(N4933), .B0(\tl1[5] ), .B1(N4610_3), 
     .Y(out_sfr_a_5_1));
  NAND2X1 U292_C1_7 (.A(out_psw[2]), .B(N5008), .Y(N4601));
  AOI22X1 U223_C3_18_C4_11 (.A0(out_b[3]), .A1(N8475), .B0(out_psw[3]), 
     .B1(N5008), .Y(out_sfr_a_3_3));
  BUFX8 BW2_BUF7885 (.A(in_sfr[0]), .Y(in_sfr_0_1));
  NOR2X1 U224_C3_23 (.A(out_sfr_a_2_7), .B(out_sfr_a_2_6), .Y(out_sfr_a_2_12));
  NOR2X1 U223_C3_18_C4_17 (.A(out_sfr_a_3_5), .B(out_sfr_a_3_2), 
     .Y(out_sfr_a_3_9));
  OAI2BB1X1 U224_C3_19 (.A0N(U213_C3_18_C4__n), .A1N(\p1[2] ), .B0(N4601), 
     .Y(out_sfr_a_2_8));
  NOR2X2 U223_C3_18_C4_18 (.A(out_sfr_a_3_6), .B(out_sfr_a_3_4), 
     .Y(out_sfr_a_3_10));
  NAND2BX1 U254_C1_1 (.AN(addr_sfr[6]), .B(addr_sfr_5_1), .Y(U213_C3_18_C4__n_2));
  NAND4X1 U213_C3_18_C4_18 (.A(U213_C3_18_C4__n_3), .B(N3942), .C(N3144), 
     .D(N11128), .Y(out_sfr_a_5_8));
  OAI2BB1X2 U421_C1_7 (.A0N(\scon[7] ), .A1N(N7310), .B0(U421_C1__n_1), 
     .Y(U421_C1__n));
  AOI22X1 U388_C1_6 (.A0(N7312), .A1(\ie[5] ), .B0(N12322), .B1(\ip[5] ), 
     .Y(U388_C1__n_1));
  NOR2X4 U183_C1_2 (.A(N4596_1), .B(U240_C1__n_4), .Y(N4596));
  NAND2X1 U192_C1_5 (.A(out_dptr_r[8]), .B(N2810_2), .Y(N12132));
  NOR3BX1 U619_C2_2 (.AN(\isrc_cur[0] ), .B(\isrc_cur[2] ), .C(\isrc_cur[1] ), 
     .Y(rst_ie0));
  AOI22X1 U362_C2_5 (.A0(out_dptr_r[14]), .A1(N2810_2), .B0(\pcon[6] ), 
     .B1(N4596), .Y(U212_C3__n_4));
  AOI22X1 U371_C2_5 (.A0(out_dptr_r[15]), .A1(N2810_2), .B0(\pcon[7] ), 
     .B1(N4596), .Y(U214_C3__n_4));
  AOI22X1 U368_C2_5 (.A0(out_dptr_r[12]), .A1(N2810_21), .B0(\pcon[4] ), 
     .B1(N4596), .Y(U231_C3__n_4));
  AOI21X1 U625_C1_7 (.A0(\th0[0] ), .A1(N4933), .B0(N7560), .Y(out_sfr_a_0_3));
  NOR2X1 U340_C1_1 (.A(addr_sfr[6]), .B(addr_sfr_7_1), .Y(U213_C3_18_C4__n_6));
  AOI22X1 U214_C3_11 (.A0(\p2[7] ), .A1(N4902), .B0(\th1[7] ), .B1(N4904_2), 
     .Y(U214_C3__n_5));
  NAND2X1 U197_C1 (.A(\th0[2] ), .B(N4933), .Y(N7422));
  AOI22X1 U213_C3_11 (.A0(\p2[5] ), .A1(N4902), .B0(\th1[5] ), .B1(N4904_2), 
     .Y(U213_C3__n_5));
  sp_test_1 U0_sp (.clk(), .rst_p(rst_p), .wr(wr_sfr), .inc_sp(inc_sp), 
     .dec_sp(dec_sp), .addr_sp({addr_sfr[7], addr_sfr[6], addr_sfr[5], 
     addr_sfr[4], addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .in_sp({
     in_sfr[7], in_sfr[6], in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, 
     in_sfr[1], in_sfr_0_1}), .out_sp({out_sp_r[7], out_sp_r[6], out_sp_r[5], 
     out_sp_r[4], out_sp_r[3], out_sp_r[2], out_sp_r[1], out_sp_r[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si1(test_si1), .test_so1(test_so1), .test_si2(test_si2), 
     .test_so2(n37), .test_se(test_se_4), .clk0_7(clk0_10));
  NOR2X1 U406_C2_2_C5_3 (.A(N12322_1), .B(ip_1_1), .Y(N4987));
  OAI21X1 U224_C3_14 (.A0(N7051), .A1(N10791), .B0(N7422), .Y(out_sfr_a_2_3));
  NAND2BX2 U258_C1_1 (.AN(addr_sfr[5]), .B(addr_sfr[6]), .Y(N5008_1));
  INVX1 U406_C2_2_C5_2_MP_INV (.A(\ie[1] ), .Y(ie_1_1));
  NOR2BX1 U358_C2_2 (.AN(N7312), .B(N11618), .Y(N1348));
  BUFX8 BW1_BUF247_11 (.A(test_se_3), .Y(test_se_4));
  NOR2X4 U331_C1_2 (.A(N2877_1), .B(U256_C2__n_52), .Y(N2877_2));
  NOR3X2 U192_C1_11 (.A(N1348), .B(N1374), .C(N6698), .Y(N4935));
  NOR2X1 U292_C1_3 (.A(N12322_1), .B(N7419), .Y(N4873));
  NOR3BX1 U606_C2_2 (.AN(\isrc_cur[1] ), .B(\isrc_cur[2] ), .C(\isrc_cur[0] ), 
     .Y(rst_tf0));
  AOI22X1 U276_C1_6 (.A0(n173_1), .A1(U421_C1__n), .B0(\p3[7] ), .B1(N8107), 
     .Y(U275_C1__n_4));
  AND4X2 U212_C3_13 (.A(U273_C1__n_4), .B(U273_C1__n_3), .C(N1553), .D(N10305_1), 
     .Y(U212_C3__n_6));
  NAND2BX1 U336_C1_2 (.AN(addr_sfr[0]), .B(U224_C3__n_8), .Y(U224_C3__n_9));
  NAND3X1 U241_C3_4 (.A(U256_C2__n_2), .B(U256_C2__n_3), .C(addr_sfr_2_1), 
     .Y(U256_C2__n_5));
  NOR2X4 U264_C1_3 (.A(U256_C2__n_5), .B(U224_C3__n_6), .Y(U224_C3__n_7));
  BUFX16 BL3_S_BUF_9 (.A(out_sfr_a_0_2), .Y(out_sfr_a[0]));
  NAND2X1 U365_C2_2 (.A(out_dptr_r[5]), .B(N2877_2), .Y(N7874));
  NOR2X1 U336_C1_1 (.A(addr_sfr[3]), .B(addr_sfr[1]), .Y(U224_C3__n_8));
  NAND4X2 U231_C3_19_C4_21 (.A(out_sfr_a_4_8), .B(out_sfr_a_4_10), 
     .C(out_sfr_a_4_7), .D(out_sfr_a_4_9), .Y(out_sfr_a_4_11));
  NAND2X1 U362_C2_2 (.A(out_dptr_r[6]), .B(N2877_2), .Y(N1429));
  NAND2X1 U374_C2_2 (.A(out_dptr_r[3]), .B(N2877_2), .Y(N8162));
  gpio3_test_1 U_port3 (.clk(), .rst_p(rst_p), .wr(wr_sfr), .rmw(rmw), .combus({
     in_sfr[7], in_sfr[6], in_sfr[5], in_sfr[4], in_sfr[3], in_sfr_2_1, 
     in_sfr[1], in_sfr_0_1}), .prt3_addr({addr_sfr[7], addr_sfr[6], addr_sfr[5], 
     addr_sfr[4], addr_sfr[3], addr_sfr[2], addr_sfr[1], addr_sfr[0]}), .p3_in({
     p3_in[7], p3_in[6], p3_in[5], p3_in[4], p3_in[3], p3_in[2], p3_in[1], 
     p3_in[0]}), .p3({\p3[7] , \p3[6] , \p3[5] , \p3[4] , \p3[3] , \p3[2] , 
     \p3[1] , \p3[0] }), .p3_out({p3_out[7], p3_out[6], p3_out[5], p3_out[4], 
     p3_out[3], p3_out[2], p3_out[1], p3_out[0]}), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in_1), 
     .test_si(n17), .test_so(n16), .test_se(test_se_1), .clk0_21(clk0_21));
  NAND3X1 U625_C1_14 (.A(N3952), .B(N8524), .C(N1299), .Y(out_sfr_a_0_10));
  NAND3X4 U241_C3_5 (.A(U256_C2__n_2), .B(U256_C2__n_3), .C(addr_sfr_2_1), 
     .Y(U256_C2__n_51));
  NAND2BX4 U253_C1 (.AN(addr_sfr[1]), .B(addr_sfr[3]), .Y(U256_C2__n));
  NAND2X1 U214_C3_8 (.A(\sbuf[7] ), .B(U213_C3_18_C4__n_5), .Y(N11169));
  NAND2X1 U212_C3_6 (.A(\sbuf[6] ), .B(U213_C3_18_C4__n_5), .Y(N1553));
  OAI2BB1X1 U363_C2_6 (.A0N(\tcon[6] ), .A1N(N1597), .B0(N6778_1), .Y(N6778));
  INVX1 U223_C3_18_C4_15_MP_INV (.A(N9443), .Y(N9443_1));
  NOR2X2 U349_C3_1 (.A(addr_sfr[6]), .B(addr_sfr_7_1), .Y(U240_C1__n_1));
  NOR3X4 U224_C3_26 (.A(out_sfr_a_2_5), .B(out_sfr_a_2_2), .C(out_sfr_a_2_1), 
     .Y(out_sfr_a_2_15));
  INVX1 U300_C1_3_MP_INV (.A(\scon[1] ), .Y(scon_1_1));
  AOI22X1 U214_C3_4 (.A0(out_sp_r[7]), .A1(U224_C3__n_7), .B0(\p0[7] ), 
     .B1(U224_C3__n_1), .Y(N6996_1));
  NOR2X4 U230_C3_27 (.A(out_sfr_a_1_10), .B(out_sfr_a_1_3), .Y(out_sfr_a_1_14));
endmodule

// Entity:acc_test_1 Model:acc_test_1 Library:L0
module acc_test_1 (clk, rst_p, ld_acc, ld_acc_chd, wr, addr_acc, in_acc, 
     acc_chd, out_acc_r, rc8051RtlTop_test_point_535_in, test_si, test_so, 
     test_se, clk0_21, clk0_8);
  input clk, rst_p, ld_acc, ld_acc_chd, wr, rc8051RtlTop_test_point_535_in, 
     test_si, test_se, clk0_21, clk0_8;
  output test_so;
  input [7:0] addr_acc;
  input [7:0] in_acc;
  input [7:0] acc_chd;
  output [7:0] out_acc_r;
  wire out_acc_r_6_1, out_acc_r_5_1, out_acc_r_4_2, out_acc_r_3_1, 
     out_acc_r_2_2, out_acc_r_1_2, out_acc_r_0_2, U34_C1__n, U34_C1__n_1, N9975, 
     N9974, N9973, N12084, N5765, N5660, N11414, N11413, N12008, N12007, 
     N9225_5, N9225_6, N9225_7, N12084_1, U34_C1__n_2, N12008_1, N12007_1, 
     N11414_1, N11413_1, N9974_1, N5765_1, N5660_1, out_acc_r_4_1, 
     out_acc_r_1_1, out_acc_r_2_1, out_acc_r_0_1;
  NOR4BX1 U35_C3_9 (.AN(addr_acc[6]), .B(addr_acc[2]), .C(addr_acc[4]), 
     .D(addr_acc[3]), .Y(N9225_7));
  NOR2BX1 U35_C3_7 (.AN(wr), .B(addr_acc[0]), .Y(N9225_5));
  AOI31X1 U35_C3_1 (.A0(N9225_7), .A1(N9225_6), .A2(N9225_5), .B0(ld_acc), 
     .Y(U34_C1__n_2));
  NOR2BX2 U32_C1 (.AN(ld_acc_chd), .B(ld_acc), .Y(U34_C1__n_1));
  NOR4BBX1 U35_C3_8 (.AN(addr_acc[5]), .BN(addr_acc[7]), .C(ld_acc_chd), 
     .D(addr_acc[1]), .Y(N9225_6));
  BUFX4 BW1_BUF7731 (.A(out_acc_r_1_2), .Y(out_acc_r[1]));
  INVX1 U49_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N9973));
  BUFX4 BW1_BUF7732 (.A(out_acc_r_0_2), .Y(out_acc_r[0]));
  BUFX1 BL1_BUF453 (.A(out_acc_r[0]), .Y(out_acc_r_0_1));
  OAI2BB1X1 U13_C5_6 (.A0N(in_acc[2]), .A1N(U34_C1__n), .B0(N11413_1), 
     .Y(N11413));
  SDFFRHQX2 out_acc_r_reg_1_ (.CK(clk0_21), .D(N5765), .Q(out_acc_r_1_2), 
     .RN(N9973), .SE(test_se), .SI(out_acc_r_0_1));
  SDFFRHQX4 out_acc_r_reg_2_ (.CK(clk0_21), .D(N11413), .Q(out_acc_r_2_2), 
     .RN(N9973), .SE(test_se), .SI(out_acc_r_1_1));
  OAI2BB1X1 U30_C5_6 (.A0N(in_acc[4]), .A1N(U34_C1__n), .B0(N5660_1), .Y(N5660));
  BUFX1 BL1_BUF443 (.A(out_acc_r[4]), .Y(out_acc_r_4_1));
  BUFX8 BW1_BUF7727 (.A(out_acc_r_5_1), .Y(out_acc_r[5]));
  AOI22X1 U11_C5_5 (.A0(acc_chd[3]), .A1(U34_C1__n_1), .B0(out_acc_r[3]), 
     .B1(N9975), .Y(N12008_1));
  AOI22X1 U31_C5_5 (.A0(acc_chd[1]), .A1(U34_C1__n_1), .B0(out_acc_r_1_1), 
     .B1(N9975), .Y(N5765_1));
  OAI2BB1X1 U31_C5_6 (.A0N(in_acc[1]), .A1N(U34_C1__n), .B0(N5765_1), .Y(N5765));
  AOI22X1 U13_C5_5 (.A0(acc_chd[2]), .A1(U34_C1__n_1), .B0(out_acc_r_2_1), 
     .B1(N9975), .Y(N11413_1));
  BUFX1 BL1_BUF445 (.A(out_acc_r[1]), .Y(out_acc_r_1_1));
  BUFX8 BW1_BUF7728 (.A(out_acc_r_4_2), .Y(out_acc_r[4]));
  SDFFRHQX1 out_acc_r_reg_4_ (.CK(clk0_21), .D(N5660), .Q(out_acc_r_4_2), 
     .RN(N9973), .SE(test_se), .SI(out_acc_r[3]));
  BUFX12 BW1_BUF7729 (.A(out_acc_r_3_1), .Y(out_acc_r[3]));
  AOI22X1 U7_C5_5 (.A0(acc_chd[5]), .A1(U34_C1__n_1), .B0(out_acc_r[5]), 
     .B1(N9975), .Y(N12007_1));
  SDFFRHQX1 out_acc_r_reg_5_ (.CK(clk0_8), .D(N12007), .Q(out_acc_r_5_1), 
     .RN(N9973), .SE(test_se), .SI(out_acc_r_4_1));
  BUFX1 BL1_BUF449 (.A(out_acc_r[2]), .Y(out_acc_r_2_1));
  AOI22X1 U17_C5_5 (.A0(acc_chd[0]), .A1(U34_C1__n_1), .B0(out_acc_r_0_1), 
     .B1(N9975), .Y(N12084_1));
  OAI2BB1X1 U7_C5_6 (.A0N(in_acc[5]), .A1N(U34_C1__n), .B0(N12007_1), .Y(N12007));
  BUFX8 BW1_BUF7730 (.A(out_acc_r_2_2), .Y(out_acc_r[2]));
  AOI22X1 U30_C5_5 (.A0(acc_chd[4]), .A1(U34_C1__n_1), .B0(out_acc_r_4_1), 
     .B1(N9975), .Y(N5660_1));
  OAI2BB1X1 U17_C5_6 (.A0N(in_acc[0]), .A1N(U34_C1__n), .B0(N12084_1), 
     .Y(N12084));
  BUFX4 BL1_ASSIGN_BUF69 (.A(test_so), .Y(out_acc_r[7]));
  OAI2BB1X1 U11_C5_6 (.A0N(in_acc[3]), .A1N(U34_C1__n), .B0(N12008_1), 
     .Y(N12008));
  SDFFRHQX2 out_acc_r_reg_3_ (.CK(clk0_21), .D(N12008), .Q(out_acc_r_3_1), 
     .RN(N9973), .SE(test_se), .SI(out_acc_r_2_1));
  SDFFRHQX2 out_acc_r_reg_7_ (.CK(clk0_8), .D(N9974), .Q(test_so), .RN(N9973), 
     .SE(test_se), .SI(out_acc_r[6]));
  BUFX8 BW1_BUF7726 (.A(out_acc_r_6_1), .Y(out_acc_r[6]));
  INVX1 U35_C3_1_MP_INV (.A(U34_C1__n_2), .Y(U34_C1__n));
  OAI2BB1X1 U3_C5_6 (.A0N(in_acc[7]), .A1N(U34_C1__n), .B0(N9974_1), .Y(N9974));
  NOR2X2 U34_C1 (.A(U34_C1__n_1), .B(U34_C1__n), .Y(N9975));
  AOI22X1 U3_C5_5 (.A0(acc_chd[7]), .A1(U34_C1__n_1), .B0(test_so), .B1(N9975), 
     .Y(N9974_1));
  AOI22X1 U5_C5_5 (.A0(acc_chd[6]), .A1(U34_C1__n_1), .B0(out_acc_r[6]), 
     .B1(N9975), .Y(N11414_1));
  OAI2BB1X1 U5_C5_6 (.A0N(in_acc[6]), .A1N(U34_C1__n), .B0(N11414_1), .Y(N11414));
  SDFFRHQX1 out_acc_r_reg_0_ (.CK(clk0_21), .D(N12084), .Q(out_acc_r_0_2), 
     .RN(N9973), .SE(test_se), .SI(test_si));
  SDFFRHQX1 out_acc_r_reg_6_ (.CK(clk0_8), .D(N11414), .Q(out_acc_r_6_1), 
     .RN(N9973), .SE(test_se), .SI(out_acc_r[5]));
endmodule

// Entity:b_test_1 Model:b_test_1 Library:L0
module b_test_1 (clk, rst_p, in_b, in_dat, addr_b, wr, ld_b, out_b, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_5, clk0_8, 
     clk0_21, clk0_26);
  input clk, rst_p, wr, ld_b, rc8051RtlTop_test_point_535_in, test_si, test_se, 
     clk0_5, clk0_8, clk0_21, clk0_26;
  output test_so;
  input [7:0] in_b;
  input [7:0] in_dat;
  input [7:0] addr_b;
  output [7:0] out_b;
  wire U30_C1__n, N11418, N11417, N11416, N11415, N12006, N5767, N5654, N12343, 
     N12342, N11195, U30_C1__n_3, U30_C1__n_6, U30_C1__n_8, N12343_1, N12342_1, 
     N12006_1, N11417_1, N11415_1, N11195_1, N5767_1, N5654_1;
  NOR2BX1 U27_C3_3 (.AN(addr_b[5]), .B(addr_b[0]), .Y(U30_C1__n_3));
  NOR4BBX1 U27_C3_6 (.AN(wr), .BN(addr_b[7]), .C(addr_b[3]), .D(addr_b[1]), 
     .Y(U30_C1__n_6));
  AND4X1 U27_C3_9 (.A(addr_b[6]), .B(addr_b[4]), .C(U30_C1__n_8), 
     .D(U30_C1__n_3), .Y(U30_C1__n));
  NOR3BX1 U27_C3_8 (.AN(U30_C1__n_6), .B(ld_b), .C(addr_b[2]), .Y(U30_C1__n_8));
  SDFFRHQX2 out_b_reg_4_ (.CK(clk0_5), .D(N11417), .Q(out_b[4]), .RN(N11416), 
     .SE(test_se), .SI(out_b[3]));
  SDFFRHQX2 out_b_reg_6_ (.CK(clk0_26), .D(N12006), .Q(out_b[6]), .RN(N11416), 
     .SE(test_se), .SI(out_b[5]));
  SDFFRHQX2 out_b_reg_3_ (.CK(clk0_5), .D(N11195), .Q(out_b[3]), .RN(N11416), 
     .SE(test_se), .SI(out_b[2]));
  SDFFRHQX2 out_b_reg_5_ (.CK(clk0_5), .D(N11415), .Q(out_b[5]), .RN(N11416), 
     .SE(test_se), .SI(out_b[4]));
  SDFFRHQX2 out_b_reg_2_ (.CK(clk0_5), .D(N12342), .Q(out_b[2]), .RN(N11416), 
     .SE(test_se), .SI(out_b[1]));
  AOI22X1 U15_C5_5 (.A0(in_dat[1]), .A1(U30_C1__n), .B0(out_b[1]), .B1(N11418), 
     .Y(N12343_1));
  SDFFRHQX2 out_b_reg_7_ (.CK(clk0_21), .D(N5767), .Q(test_so), .RN(N11416), 
     .SE(test_se), .SI(out_b[6]));
  SDFFRHQX2 out_b_reg_0_ (.CK(clk0_8), .D(N5654), .Q(out_b[0]), .RN(N11416), 
     .SE(test_se), .SI(test_si));
  OAI2BB1X1 U15_C5_6 (.A0N(ld_b), .A1N(in_b[1]), .B0(N12343_1), .Y(N12343));
  INVX2 U39_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N11416));
  OAI2BB1X1 U17_C5_6 (.A0N(ld_b), .A1N(in_b[0]), .B0(N5654_1), .Y(N5654));
  OAI2BB1X1 U11_C5_6 (.A0N(ld_b), .A1N(in_b[3]), .B0(N11195_1), .Y(N11195));
  OAI2BB1X1 U7_C5_6 (.A0N(ld_b), .A1N(in_b[5]), .B0(N11415_1), .Y(N11415));
  OAI2BB1X1 U13_C5_6 (.A0N(ld_b), .A1N(in_b[2]), .B0(N12342_1), .Y(N12342));
  OAI2BB1X1 U5_C5_6 (.A0N(ld_b), .A1N(in_b[6]), .B0(N12006_1), .Y(N12006));
  OAI2BB1X1 U9_C5_6 (.A0N(ld_b), .A1N(in_b[4]), .B0(N11417_1), .Y(N11417));
  AOI22X1 U9_C5_5 (.A0(in_dat[4]), .A1(U30_C1__n), .B0(out_b[4]), .B1(N11418), 
     .Y(N11417_1));
  AOI22X1 U13_C5_5 (.A0(in_dat[2]), .A1(U30_C1__n), .B0(out_b[2]), .B1(N11418), 
     .Y(N12342_1));
  OAI2BB1X1 U3_C5_6 (.A0N(ld_b), .A1N(in_b[7]), .B0(N5767_1), .Y(N5767));
  SDFFRHQX2 out_b_reg_1_ (.CK(clk0_5), .D(N12343), .Q(out_b[1]), .RN(N11416), 
     .SE(test_se), .SI(out_b[0]));
  AOI22X1 U5_C5_5 (.A0(in_dat[6]), .A1(U30_C1__n), .B0(out_b[6]), .B1(N11418), 
     .Y(N12006_1));
  AOI22X1 U11_C5_5 (.A0(in_dat[3]), .A1(U30_C1__n), .B0(out_b[3]), .B1(N11418), 
     .Y(N11195_1));
  NOR2X1 U30_C1 (.A(ld_b), .B(U30_C1__n), .Y(N11418));
  AOI22X1 U3_C5_5 (.A0(in_dat[7]), .A1(U30_C1__n), .B0(test_so), .B1(N11418), 
     .Y(N5767_1));
  AOI22X1 U7_C5_5 (.A0(in_dat[5]), .A1(U30_C1__n), .B0(out_b[5]), .B1(N11418), 
     .Y(N11415_1));
  BUFX1 BL1_ASSIGN_BUF133 (.A(test_so), .Y(out_b[7]));
  AOI22X1 U17_C5_5 (.A0(in_dat[0]), .A1(U30_C1__n), .B0(out_b[0]), .B1(N11418), 
     .Y(N5654_1));
endmodule

// Entity:dimod_test_1 Model:dimod_test_1 Library:L0
module dimod_test_1 (clk, rst_p, wr, addr_dimod, in_dimod, out_dimod, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_7);
  input clk, rst_p, wr, rc8051RtlTop_test_point_535_in, test_si, test_se, 
     clk0_7;
  output test_so;
  input [7:0] addr_dimod;
  input [7:0] in_dimod;
  output [7:0] out_dimod;
  wire n7, n8, n9, n10, n11, n12, n13, n14, n26, n28, n30, n32, N8938, N11659, 
     N11658, N11091, N11090, N8765, N8895, N11881, N11880, N8894, N2634, N4070, 
     N7075, N11403, N2039, N10504, N275, N11759, N8938_1, N8938_2, N8938_7;
  supply1 VDD;
  NAND2X1 U22_C4_2 (.A(in_dimod[4]), .B(N8938), .Y(N11403));
  OAI21X1 U22_C4_1 (.A0(n11), .A1(N8938), .B0(N11403), .Y(N11091));
  SDFFSRX1 out_dimod_reg_4_ (.CK(clk0_7), .D(N11091), .Q(n28), .QN(n11), 
     .RN(N11658), .SE(test_se), .SI(n26), .SN(VDD));
  SDFFSRX1 out_dimod_reg_3_ (.CK(clk0_7), .D(N11659), .Q(n26), .QN(n10), 
     .RN(N11658), .SE(test_se), .SI(out_dimod[2]), .SN(VDD));
  SDFFSRX1 out_dimod_reg_1_ (.CK(clk0_7), .D(N8894), .Q(out_dimod[1]), .QN(n8), 
     .RN(N11658), .SE(test_se), .SI(out_dimod[0]), .SN(VDD));
  SDFFSRX1 out_dimod_reg_2_ (.CK(clk0_7), .D(N11880), .Q(out_dimod[2]), .QN(n9), 
     .RN(N11658), .SE(test_se), .SI(out_dimod[1]), .SN(VDD));
  OAI21X1 U28_C4_1 (.A0(n8), .A1(N8938), .B0(N2634), .Y(N8894));
  OAI21X1 U27_C4_1 (.A0(n9), .A1(N8938), .B0(N11759), .Y(N11880));
  OAI21X1 U26_C4_1 (.A0(n10), .A1(N8938), .B0(N275), .Y(N11659));
  SDFFSRX1 out_dimod_reg_7_ (.CK(clk0_7), .D(N8895), .Q(test_so), .QN(n14), 
     .RN(N11658), .SE(test_se), .SI(n32), .SN(VDD));
  OAI21X1 U25_C4_1 (.A0(n14), .A1(N8938), .B0(N2039), .Y(N8895));
  NAND2X1 U26_C4_2 (.A(in_dimod[3]), .B(N8938), .Y(N275));
  NAND2X1 U23_C4_2 (.A(in_dimod[5]), .B(N8938), .Y(N10504));
  NOR2BX1 U16_C3_2 (.AN(addr_dimod[7]), .B(addr_dimod[3]), .Y(N8938_2));
  AND4X2 U16_C3_8 (.A(wr), .B(addr_dimod[2]), .C(N8938_7), .D(N8938_2), 
     .Y(N8938));
  NOR4BX1 U16_C3_7 (.AN(N8938_1), .B(addr_dimod[6]), .C(addr_dimod[4]), 
     .D(addr_dimod[0]), .Y(N8938_7));
  NOR2X1 U16_C3_1 (.A(addr_dimod[5]), .B(addr_dimod[1]), .Y(N8938_1));
  NAND2X1 U27_C4_2 (.A(in_dimod[2]), .B(N8938), .Y(N11759));
  SDFFSRX1 out_dimod_reg_0_ (.CK(clk0_7), .D(N11881), .Q(out_dimod[0]), .QN(n7), 
     .RN(N11658), .SE(test_se), .SI(test_si), .SN(VDD));
  NAND2X1 U28_C4_2 (.A(in_dimod[1]), .B(N8938), .Y(N2634));
  OAI21X1 U29_C4_1 (.A0(n7), .A1(N8938), .B0(N7075), .Y(N11881));
  NAND2X1 U29_C4_2 (.A(in_dimod[0]), .B(N8938), .Y(N7075));
  INVX1 U30_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N11658));
  NAND2X1 U25_C4_2 (.A(in_dimod[7]), .B(N8938), .Y(N2039));
  SDFFSRX1 out_dimod_reg_5_ (.CK(clk0_7), .D(N11090), .Q(n30), .QN(n12), 
     .RN(N11658), .SE(test_se), .SI(n28), .SN(VDD));
  OAI21X1 U23_C4_1 (.A0(n12), .A1(N8938), .B0(N10504), .Y(N11090));
  SDFFSRX1 out_dimod_reg_6_ (.CK(clk0_7), .D(N8765), .Q(n32), .QN(n13), 
     .RN(N11658), .SE(test_se), .SI(n30), .SN(VDD));
  OAI21X1 U24_C4_1 (.A0(n13), .A1(N8938), .B0(N4070), .Y(N8765));
  NAND2X1 U24_C4_2 (.A(in_dimod[6]), .B(N8938), .Y(N4070));
endmodule

// Entity:dptr_test_1 Model:dptr_test_1 Library:L0
module dptr_test_1 (clk, rst_p, ld_dpl, ld_dph, wr, inc_dptr, addr_dptr, 
     in_dptr, out_dptr, rc8051RtlTop_test_point_535_in, test_si, test_so, 
     test_se, clk0_21, clk0_4, clk0_8);
  input clk, rst_p, ld_dpl, ld_dph, wr, inc_dptr, 
     rc8051RtlTop_test_point_535_in, test_si, test_se, clk0_21, clk0_4, clk0_8;
  output test_so;
  input [7:0] addr_dptr;
  input [7:0] in_dptr;
  output [15:0] out_dptr;
  wire N34, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, 
     N48, N49, n430, n440, n450, n460, n470, n480, n490, n50, n51, n52, n53, 
     n54, n55, n56, n57, n58, U69_C1__n, U63_C3__n, U63_C3__n_1, U62_C2__n, 
     N8889, N12220, N12219, N8933, N10088, N8932, N11641, N7466, N8888, N12123, 
     N12122, N8946, N11677, N11676, N8943, N11994, N11993, N8945, N11031, 
     N11030, U60_C1__n_2, U69_C1__n_2, N12219_1, inc_dptr_1, U63_C3__n_2, 
     N8889_2, N12220_1, N12123_1, N12122_1, N11994_1, N11993_1, N11677_1, 
     N11676_1, N11641_1, N11031_1, N11030_1, N8946_1, N8945_1, N8943_1, N8932_1, 
     N8888_1, N7466_1, in_dptr_6_1, in_dptr_7_1, in_dptr_5_1, in_dptr_3_1, 
     in_dptr_4_1, in_dptr_2_1, in_dptr_1_1;
  supply1 VDD;
  dptr_DW01_inc_16_0 add_33 (.A({test_so, out_dptr[14], out_dptr[13], 
     out_dptr[12], out_dptr[11], out_dptr[10], out_dptr[9], out_dptr[8], 
     out_dptr[7], out_dptr[6], out_dptr[5], out_dptr[4], out_dptr[3], 
     out_dptr[2], out_dptr[1], out_dptr[0]}), .SUM({N49, N48, N47, N46, N45, N44, 
     N43, N42, N41, N40, N39, N38, N37, N36, N35, N34}));
  SDFFSRX2 out_dptr_reg_12_ (.CK(clk0_8), .D(N8945), .Q(out_dptr[12]), .QN(n460), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[11]), .SN(VDD));
  SDFFSRX4 out_dptr_reg_2_ (.CK(clk0_4), .D(N7466), .Q(out_dptr[2]), .QN(n51), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[1]), .SN(VDD));
  BUFX1 BL1_BUF277 (.A(in_dptr[2]), .Y(in_dptr_2_1));
  AOI22X1 U91_C5_5 (.A0(N44), .A1(N8889_2), .B0(in_dptr_2_1), .B1(N12220_1), 
     .Y(N11994_1));
  SDFFSRX4 out_dptr_reg_0_ (.CK(clk0_4), .D(N8932), .Q(out_dptr[0]), .QN(n430), 
     .RN(N8933), .SE(test_se), .SI(test_si), .SN(VDD));
  SDFFSRX2 out_dptr_reg_10_ (.CK(clk0_8), .D(N11994), .Q(out_dptr[10]), 
     .QN(n440), .RN(N8933), .SE(test_se), .SI(out_dptr[9]), .SN(VDD));
  AOI2BB2X1 U111_C5_5 (.A0N(n430), .A1N(N10088), .B0(N34), .B1(N8889_2), 
     .Y(N8932_1));
  SDFFSRX4 out_dptr_reg_1_ (.CK(clk0_4), .D(N11641), .Q(out_dptr[1]), .QN(n50), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[0]), .SN(VDD));
  NOR4BX1 U60_C1_1 (.AN(U60_C1__n_2), .B(addr_dptr[6]), .C(addr_dptr[4]), 
     .D(addr_dptr[2]), .Y(U69_C1__n_2));
  OAI21X1 U105_C5_6 (.A0(n58), .A1(U62_C2__n), .B0(N8943_1), .Y(N8943));
  NAND2BX1 U62_C2 (.AN(U63_C3__n), .B(U62_C2__n), .Y(N12220));
  SDFFSRX4 out_dptr_reg_3_ (.CK(clk0_4), .D(N8888), .Q(out_dptr[3]), .QN(n52), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[2]), .SN(VDD));
  SDFFSRX4 out_dptr_reg_5_ (.CK(clk0_21), .D(N12122), .Q(out_dptr[5]), .QN(n54), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[4]), .SN(VDD));
  SDFFSRX4 out_dptr_reg_4_ (.CK(clk0_4), .D(N12123), .Q(out_dptr[4]), .QN(n53), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[3]), .SN(VDD));
  AOI2BB2X1 U95_C5_5 (.A0N(n54), .A1N(N10088), .B0(N39), .B1(N8889_2), 
     .Y(N12122_1));
  OAI2BB1X1 U95_C5_6 (.A0N(in_dptr_5_1), .A1N(U63_C3__n_2), .B0(N12122_1), 
     .Y(N12122));
  OAI2BB1X1 U97_C5_6 (.A0N(in_dptr_4_1), .A1N(U63_C3__n_2), .B0(N12123_1), 
     .Y(N12123));
  AOI2BB2X1 U97_C5_5 (.A0N(n53), .A1N(N10088), .B0(N38), .B1(N8889_2), 
     .Y(N12123_1));
  OAI2BB1X1 U109_C5_6 (.A0N(in_dptr_3_1), .A1N(U63_C3__n_2), .B0(N8888_1), 
     .Y(N8888));
  OAI2BB1X1 U99_C5_6 (.A0N(in_dptr_2_1), .A1N(U63_C3__n_2), .B0(N7466_1), 
     .Y(N7466));
  AOI2BB2X1 U109_C5_5 (.A0N(n52), .A1N(N10088), .B0(N37), .B1(N8889_2), 
     .Y(N8888_1));
  AOI2BB2X1 U99_C5_5 (.A0N(n51), .A1N(N10088), .B0(N36), .B1(N8889_2), 
     .Y(N7466_1));
  AOI22X1 U107_C5_5 (.A0(N42), .A1(N8889_2), .B0(in_dptr[0]), .B1(N12220_1), 
     .Y(N11676_1));
  OAI21X1 U107_C5_6 (.A0(n57), .A1(U62_C2__n), .B0(N11676_1), .Y(N11676));
  OAI21X1 U83_C5_6 (.A0(n490), .A1(U62_C2__n), .B0(N12219_1), .Y(N12219));
  SDFFSRX1 out_dptr_reg_15_ (.CK(clk0_4), .D(N12219), .Q(test_so), .QN(n490), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[14]), .SN(VDD));
  AOI22X1 U83_C5_5 (.A0(N49), .A1(N8889_2), .B0(in_dptr_7_1), .B1(N12220_1), 
     .Y(N12219_1));
  AOI2BB2X1 U101_C5_5 (.A0N(n56), .A1N(N10088), .B0(N41), .B1(N8889_2), 
     .Y(N11677_1));
  OAI2BB1X1 U93_C5_6 (.A0N(in_dptr_6_1), .A1N(U63_C3__n_2), .B0(N8946_1), 
     .Y(N8946));
  BUFX1 BL1_BUF238 (.A(in_dptr[3]), .Y(in_dptr_3_1));
  OAI2BB1X1 U101_C5_6 (.A0N(in_dptr_7_1), .A1N(U63_C3__n_2), .B0(N11677_1), 
     .Y(N11677));
  BUFX1 BL1_BUF217 (.A(in_dptr[5]), .Y(in_dptr_5_1));
  BUFX1 BL1_BUF256 (.A(in_dptr[4]), .Y(in_dptr_4_1));
  BUFX2 BL1_ASSIGN_BUF73 (.A(test_so), .Y(out_dptr[15]));
  OAI21X1 U85_C5_6 (.A0(n480), .A1(U62_C2__n), .B0(N11030_1), .Y(N11030));
  BUFX1 BL1_BUF200 (.A(in_dptr[7]), .Y(in_dptr_7_1));
  AOI22X1 U85_C5_5 (.A0(N48), .A1(N8889_2), .B0(in_dptr_6_1), .B1(N12220_1), 
     .Y(N11030_1));
  SDFFSRX2 out_dptr_reg_11_ (.CK(clk0_8), .D(N11993), .Q(out_dptr[11]), 
     .QN(n450), .RN(N8933), .SE(test_se), .SI(out_dptr[10]), .SN(VDD));
  AOI22X1 U87_C5_5 (.A0(N47), .A1(N8889_2), .B0(in_dptr_5_1), .B1(N12220_1), 
     .Y(N11031_1));
  SDFFSRX2 out_dptr_reg_14_ (.CK(clk0_8), .D(N11030), .Q(out_dptr[14]), 
     .QN(n480), .RN(N8933), .SE(test_se), .SI(out_dptr[13]), .SN(VDD));
  AOI22X1 U103_C5_5 (.A0(N45), .A1(N8889_2), .B0(in_dptr_3_1), .B1(N12220_1), 
     .Y(N11993_1));
  OAI21X1 U89_C5_6 (.A0(n460), .A1(U62_C2__n), .B0(N8945_1), .Y(N8945));
  OAI21X1 U87_C5_6 (.A0(n470), .A1(U62_C2__n), .B0(N11031_1), .Y(N11031));
  SDFFSRX2 out_dptr_reg_13_ (.CK(clk0_8), .D(N11031), .Q(out_dptr[13]), 
     .QN(n470), .RN(N8933), .SE(test_se), .SI(out_dptr[12]), .SN(VDD));
  AOI22X1 U89_C5_5 (.A0(N46), .A1(N8889_2), .B0(in_dptr_4_1), .B1(N12220_1), 
     .Y(N8945_1));
  OAI21X1 U103_C5_6 (.A0(n450), .A1(U62_C2__n), .B0(N11993_1), .Y(N11993));
  INVX2 U83_C5_5_MP_INV (.A(N8889), .Y(N8889_2));
  OAI2BB1X1 U65_C3_1 (.A0N(inc_dptr), .A1N(U63_C3__n), .B0(U63_C3__n_1), 
     .Y(N10088));
  NOR2BX1 U71_C1 (.AN(U69_C1__n), .B(ld_dph), .Y(U63_C3__n));
  OAI2BB1X1 U111_C5_6 (.A0N(in_dptr[0]), .A1N(U63_C3__n_2), .B0(N8932_1), 
     .Y(N8932));
  OAI2BB1X1 U113_C5_6 (.A0N(in_dptr_1_1), .A1N(U63_C3__n_2), .B0(N11641_1), 
     .Y(N11641));
  AOI2BB2X1 U113_C5_5 (.A0N(n50), .A1N(N10088), .B0(N35), .B1(N8889_2), 
     .Y(N11641_1));
  NOR2X1 U75_C3_2 (.A(addr_dptr[5]), .B(addr_dptr[3]), .Y(U60_C1__n_2));
  SDFFSRX4 out_dptr_reg_7_ (.CK(clk0_8), .D(N11677), .Q(out_dptr[7]), .QN(n56), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[6]), .SN(VDD));
  SDFFSRX4 out_dptr_reg_8_ (.CK(clk0_8), .D(N11676), .Q(out_dptr[8]), .QN(n57), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[7]), .SN(VDD));
  SDFFSRX4 out_dptr_reg_6_ (.CK(clk0_21), .D(N8946), .Q(out_dptr[6]), .QN(n55), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[5]), .SN(VDD));
  AOI2BB2X1 U93_C5_5 (.A0N(n55), .A1N(N10088), .B0(N40), .B1(N8889_2), 
     .Y(N8946_1));
  BUFX1 BL1_BUF183 (.A(in_dptr[6]), .Y(in_dptr_6_1));
  INVX1 U83_C5_5_MP_INV_1 (.A(N12220), .Y(N12220_1));
  OAI21X1 U91_C5_6 (.A0(n440), .A1(U62_C2__n), .B0(N11994_1), .Y(N11994));
  INVX2 U115_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N8933));
  AOI22X1 U105_C5_5 (.A0(N43), .A1(N8889_2), .B0(in_dptr_1_1), .B1(N12220_1), 
     .Y(N8943_1));
  AOI2BB1X1 U69_C1_1 (.A0N(addr_dptr[0]), .A1N(U69_C1__n), .B0(ld_dpl), 
     .Y(U63_C3__n_1));
  SDFFSRX2 out_dptr_reg_9_ (.CK(clk0_4), .D(N8943), .Q(out_dptr[9]), .QN(n58), 
     .RN(N8933), .SE(test_se), .SI(out_dptr[8]), .SN(VDD));
  INVX1 U63_C3_1_MP_INV_1 (.A(U63_C3__n_1), .Y(U63_C3__n_2));
  NAND3X1 U64_C2_2 (.A(inc_dptr), .B(U63_C3__n_1), .C(U63_C3__n), .Y(N8889));
  NAND4X1 U60_C1_4 (.A(wr), .B(addr_dptr[7]), .C(addr_dptr[1]), .D(U69_C1__n_2), 
     .Y(U69_C1__n));
  BUFX1 BL1_BUF299 (.A(in_dptr[1]), .Y(in_dptr_1_1));
  INVX1 U63_C3_1_MP_INV (.A(inc_dptr), .Y(inc_dptr_1));
  AOI21X2 U63_C3_1 (.A0(inc_dptr_1), .A1(U63_C3__n), .B0(U63_C3__n_2), 
     .Y(U62_C2__n));
endmodule

// Entity:dptr_DW01_inc_16_0 Model:dptr_DW01_inc_16_0 Library:L0
module dptr_DW01_inc_16_0 (A, SUM);
  input [15:0] A;
  output [15:0] SUM;
  wire carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, 
     carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, 
     carry_2_;
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  ADDHX1 U1_1_10 (.A(A[10]), .B(carry_10_), .CO(carry_11_), .S(SUM[10]));
  ADDHX1 U1_1_13 (.A(A[13]), .B(carry_13_), .CO(carry_14_), .S(SUM[13]));
  ADDHX1 U1_1_11 (.A(A[11]), .B(carry_11_), .CO(carry_12_), .S(SUM[11]));
  ADDHX1 U1_1_12 (.A(A[12]), .B(carry_12_), .CO(carry_13_), .S(SUM[12]));
  ADDHX1 U1_1_9 (.A(A[9]), .B(carry_9_), .CO(carry_10_), .S(SUM[9]));
  ADDHX1 U1_1_7 (.A(A[7]), .B(carry_7_), .CO(carry_8_), .S(SUM[7]));
  ADDHX1 U1_1_8 (.A(A[8]), .B(carry_8_), .CO(carry_9_), .S(SUM[8]));
  ADDHX1 U1_1_14 (.A(A[14]), .B(carry_14_), .CO(carry_15_), .S(SUM[14]));
  XOR2X1 U5_C1 (.A(carry_15_), .B(A[15]), .Y(SUM[15]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
endmodule

// Entity:gpio0_test_1 Model:gpio0_test_1 Library:L0
module gpio0_test_1 (clk, rst_p, wr, rmw, combus, prt0_addr, p0_in, p0, p0_out, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_21);
  input clk, rst_p, wr, rmw, rc8051RtlTop_test_point_535_in, test_si, test_se, 
     clk0_21;
  output test_so;
  input [7:0] combus;
  input [7:0] prt0_addr;
  input [7:0] p0_in;
  output [7:0] p0;
  output [7:0] p0_out;
  wire n25, n26, n27, n28, n29, n30, n31, n32, N8778, N10319, N10318, N11848, 
     N8940, N9964, N9963, N9962, N9961, N8942, N8094, N10308, N1625, N7020, 
     N6388, N11215, N7134, N10847, N10451, N2033, N2019, N1453, N1481, N2760, 
     N10840, N9793, N8778_5, N8778_6, prt0_addr_1_1, rmw_1;
  NAND2X1 U55_C4_3 (.A(rmw_1), .B(p0_in[0]), .Y(N8094));
  NAND2X1 U50_C4_3 (.A(rmw_1), .B(p0_in[5]), .Y(N2760));
  OAI21X1 U55_C4_1 (.A0(rmw_1), .A1(n32), .B0(N8094), .Y(p0[0]));
  AND4X2 U34_C3_8 (.A(prt0_addr[7]), .B(prt0_addr_1_1), .C(N8778_6), .D(N8778_5), 
     .Y(N8778));
  NOR3X1 U34_C3_5 (.A(prt0_addr[6]), .B(prt0_addr[5]), .C(prt0_addr[2]), 
     .Y(N8778_5));
  INVX1 U34_C3_8_MP_INV (.A(prt0_addr[1]), .Y(prt0_addr_1_1));
  NOR4BX1 U34_C3_6 (.AN(wr), .B(prt0_addr[0]), .C(prt0_addr[4]), 
     .D(prt0_addr[3]), .Y(N8778_6));
  OAI21X1 U50_C4_1 (.A0(rmw_1), .A1(n27), .B0(N2760), .Y(p0[5]));
  SDFFSX1 p0_out_reg_3_ (.CK(clk0_21), .D(N10319), .Q(p0_out[3]), .QN(n28), 
     .SE(test_se), .SI(p0_out[2]), .SN(N10318));
  SDFFSX1 p0_out_reg_4_ (.CK(clk0_21), .D(N11848), .Q(p0_out[4]), .QN(n30), 
     .SE(test_se), .SI(p0_out[3]), .SN(N10318));
  SDFFSX1 p0_out_reg_2_ (.CK(clk0_21), .D(N8942), .Q(p0_out[2]), .QN(n25), 
     .SE(test_se), .SI(p0_out[1]), .SN(N10318));
  OAI21X1 U53_C4_1 (.A0(rmw_1), .A1(n30), .B0(N7020), .Y(p0[4]));
  OAI21X1 U40_C4_1 (.A0(n30), .A1(N8778), .B0(N7134), .Y(N11848));
  OAI21X1 U41_C4_1 (.A0(n27), .A1(N8778), .B0(N9793), .Y(N8940));
  NAND2X1 U41_C4_2 (.A(combus[5]), .B(N8778), .Y(N9793));
  SDFFSX1 p0_out_reg_5_ (.CK(clk0_21), .D(N8940), .Q(p0_out[5]), .QN(n27), 
     .SE(test_se), .SI(p0_out[4]), .SN(N10318));
  NAND2X1 U42_C4_2 (.A(combus[6]), .B(N8778), .Y(N10308));
  SDFFSX1 p0_out_reg_7_ (.CK(clk0_21), .D(N9963), .Q(test_so), .QN(n31), 
     .SE(test_se), .SI(p0_out[6]), .SN(N10318));
  NAND2X1 U43_C4_2 (.A(combus[7]), .B(N8778), .Y(N2019));
  OAI21X1 U43_C4_1 (.A0(n31), .A1(N8778), .B0(N2019), .Y(N9963));
  SDFFSX1 p0_out_reg_6_ (.CK(clk0_21), .D(N9964), .Q(p0_out[6]), .QN(n29), 
     .SE(test_se), .SI(p0_out[5]), .SN(N10318));
  OAI21X1 U42_C4_1 (.A0(n29), .A1(N8778), .B0(N10308), .Y(N9964));
  BUFX1 BL1_ASSIGN_BUF39 (.A(test_so), .Y(p0_out[7]));
  INVX2 U55_C4_1_MP_INV (.A(rmw), .Y(rmw_1));
  OAI21X1 U54_C4_1 (.A0(rmw_1), .A1(n31), .B0(N1453), .Y(p0[7]));
  NAND2X1 U48_C4_3 (.A(rmw_1), .B(p0_in[2]), .Y(N11215));
  NAND2X1 U51_C4_3 (.A(rmw_1), .B(p0_in[3]), .Y(N2033));
  NAND2X1 U46_C4_2 (.A(combus[1]), .B(N8778), .Y(N1481));
  OAI21X1 U45_C4_1 (.A0(n25), .A1(N8778), .B0(N1625), .Y(N8942));
  OAI21X1 U44_C4_1 (.A0(n28), .A1(N8778), .B0(N6388), .Y(N10319));
  INVX1 U56_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N10318));
  NAND2X1 U45_C4_2 (.A(combus[2]), .B(N8778), .Y(N1625));
  NAND2X1 U47_C4_2 (.A(combus[0]), .B(N8778), .Y(N10847));
  OAI21X1 U47_C4_1 (.A0(n32), .A1(N8778), .B0(N10847), .Y(N9962));
  NAND2X1 U40_C4_2 (.A(combus[4]), .B(N8778), .Y(N7134));
  NAND2X1 U44_C4_2 (.A(combus[3]), .B(N8778), .Y(N6388));
  NAND2X1 U53_C4_3 (.A(rmw_1), .B(p0_in[4]), .Y(N7020));
  SDFFSX1 p0_out_reg_1_ (.CK(clk0_21), .D(N9961), .Q(p0_out[1]), .QN(n26), 
     .SE(test_se), .SI(p0_out[0]), .SN(N10318));
  SDFFSX1 p0_out_reg_0_ (.CK(clk0_21), .D(N9962), .Q(p0_out[0]), .QN(n32), 
     .SE(test_se), .SI(test_si), .SN(N10318));
  OAI21X1 U46_C4_1 (.A0(n26), .A1(N8778), .B0(N1481), .Y(N9961));
  OAI21X1 U52_C4_1 (.A0(rmw_1), .A1(n29), .B0(N10451), .Y(p0[6]));
  OAI21X1 U51_C4_1 (.A0(rmw_1), .A1(n28), .B0(N2033), .Y(p0[3]));
  NAND2X1 U49_C4_3 (.A(rmw_1), .B(p0_in[1]), .Y(N10840));
  OAI21X1 U48_C4_1 (.A0(rmw_1), .A1(n25), .B0(N11215), .Y(p0[2]));
  OAI21X1 U49_C4_1 (.A0(rmw_1), .A1(n26), .B0(N10840), .Y(p0[1]));
  NAND2X1 U54_C4_3 (.A(rmw_1), .B(p0_in[7]), .Y(N1453));
  NAND2X1 U52_C4_3 (.A(rmw_1), .B(p0_in[6]), .Y(N10451));
endmodule

// Entity:gpio1_test_1 Model:gpio1_test_1 Library:L0
module gpio1_test_1 (clk, rst_p, wr, rmw, combus, prt1_addr, p1_in, p1, p1_out, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_26, 
     clk0_21, clk0_3);
  input clk, rst_p, wr, rmw, rc8051RtlTop_test_point_535_in, test_si, test_se, 
     clk0_26, clk0_21, clk0_3;
  output test_so;
  input [7:0] combus;
  input [7:0] prt1_addr;
  input [7:0] p1_in;
  output [7:0] p1;
  output [7:0] p1_out;
  wire n25, n26, n27, n28, n29, n30, n31, n32, N11013, N8908, N8789, N10725, 
     N10724, N9934, N9933, N9932, N8907, N8790, N1790, N6840, N8468, N7751, 
     N1404, N7866, N8505, N10416, N11656, N1861, N9925, N11166, N12160, N2759, 
     N3323, N6797, N11013_5, N11013_6, prt1_addr_1_1, rmw_1, p1_2_1;
  NOR3BX1 U33_C3_5 (.AN(wr), .B(prt1_addr[5]), .C(prt1_addr[6]), .Y(N11013_5));
  NOR4BX1 U33_C3_6 (.AN(prt1_addr[4]), .B(prt1_addr[0]), .C(prt1_addr[3]), 
     .D(prt1_addr[2]), .Y(N11013_6));
  INVX1 U33_C3_8_MP_INV (.A(prt1_addr[1]), .Y(prt1_addr_1_1));
  AND4X2 U33_C3_8 (.A(prt1_addr[7]), .B(prt1_addr_1_1), .C(N11013_6), 
     .D(N11013_5), .Y(N11013));
  SDFFSX4 p1_out_reg_6_ (.CK(clk0_26), .D(N8790), .Q(p1_out[6]), .QN(n31), 
     .SE(test_se), .SI(p1_out[5]), .SN(N8789));
  SDFFSX4 p1_out_reg_2_ (.CK(clk0_26), .D(N9934), .Q(p1_out[2]), .QN(n27), 
     .SE(test_se), .SI(p1_out[1]), .SN(N8789));
  OAI21X1 U51_C4_1 (.A0(rmw_1), .A1(n26), .B0(N2759), .Y(p1[1]));
  NAND2X1 U45_C4_2 (.A(combus[2]), .B(N11013), .Y(N1790));
  OAI21X1 U46_C4_1 (.A0(n26), .A1(N11013), .B0(N3323), .Y(N10724));
  NAND2X1 U47_C4_2 (.A(combus[0]), .B(N11013), .Y(N7866));
  INVX2 U48_C4_1_MP_INV (.A(rmw), .Y(rmw_1));
  OAI21X1 U54_C4_1 (.A0(rmw_1), .A1(n31), .B0(N8505), .Y(p1[6]));
  NAND2X1 U51_C4_3 (.A(rmw_1), .B(p1_in[1]), .Y(N2759));
  NAND2X1 U52_C4_3 (.A(rmw_1), .B(p1_in[4]), .Y(N6840));
  NAND2X1 U49_C4_3 (.A(rmw_1), .B(p1_in[2]), .Y(N11656));
  NAND2X1 U55_C4_3 (.A(rmw_1), .B(p1_in[5]), .Y(N6797));
  NAND2X1 U54_C4_3 (.A(rmw_1), .B(p1_in[6]), .Y(N8505));
  OAI21X1 U50_C4_1 (.A0(rmw_1), .A1(n28), .B0(N11166), .Y(p1[3]));
  NAND2X1 U53_C4_3 (.A(rmw_1), .B(p1_in[7]), .Y(N1861));
  SDFFSX4 p1_out_reg_3_ (.CK(clk0_3), .D(N9933), .Q(p1_out[3]), .QN(n28), 
     .SE(test_se), .SI(p1_out[2]), .SN(N8789));
  NAND2X1 U50_C4_3 (.A(rmw_1), .B(p1_in[3]), .Y(N11166));
  OAI21X1 U52_C4_1 (.A0(rmw_1), .A1(n29), .B0(N6840), .Y(p1[4]));
  NAND2X1 U48_C4_3 (.A(rmw_1), .B(p1_in[0]), .Y(N1404));
  BUFX2 BL1_ASSIGN_BUF7 (.A(test_so), .Y(p1_out[7]));
  OAI21X1 U41_C4_1 (.A0(n32), .A1(N11013), .B0(N12160), .Y(N8907));
  OAI21X1 U45_C4_1 (.A0(n27), .A1(N11013), .B0(N1790), .Y(N9934));
  SDFFSX4 p1_out_reg_1_ (.CK(clk0_26), .D(N10724), .Q(p1_out[1]), .QN(n26), 
     .SE(test_se), .SI(p1_out[0]), .SN(N8789));
  OAI21X1 U40_C4_1 (.A0(n29), .A1(N11013), .B0(N10416), .Y(N9932));
  BUFX8 BL3_S_BUF_15 (.A(p1_2_1), .Y(p1[2]));
  SDFFSX4 p1_out_reg_4_ (.CK(clk0_26), .D(N9932), .Q(p1_out[4]), .QN(n29), 
     .SE(test_se), .SI(p1_out[3]), .SN(N8789));
  NAND2X1 U44_C4_2 (.A(combus[3]), .B(N11013), .Y(N9925));
  OAI21X1 U44_C4_1 (.A0(n28), .A1(N11013), .B0(N9925), .Y(N9933));
  NAND2X1 U40_C4_2 (.A(combus[4]), .B(N11013), .Y(N10416));
  OAI21X1 U55_C4_1 (.A0(rmw_1), .A1(n32), .B0(N6797), .Y(p1[5]));
  OAI21X1 U49_C4_1 (.A0(rmw_1), .A1(n27), .B0(N11656), .Y(p1_2_1));
  SDFFSX4 p1_out_reg_5_ (.CK(clk0_26), .D(N8907), .Q(p1_out[5]), .QN(n32), 
     .SE(test_se), .SI(p1_out[4]), .SN(N8789));
  SDFFSX2 p1_out_reg_7_ (.CK(clk0_21), .D(N8908), .Q(test_so), .QN(n30), 
     .SE(test_se), .SI(p1_out[6]), .SN(N8789));
  NAND2X1 U43_C4_2 (.A(combus[7]), .B(N11013), .Y(N8468));
  SDFFSX4 p1_out_reg_0_ (.CK(clk0_26), .D(N10725), .Q(p1_out[0]), .QN(n25), 
     .SE(test_se), .SI(test_si), .SN(N8789));
  OAI21X1 U42_C4_1 (.A0(n31), .A1(N11013), .B0(N7751), .Y(N8790));
  OAI21X1 U47_C4_1 (.A0(n25), .A1(N11013), .B0(N7866), .Y(N10725));
  NAND2X1 U46_C4_2 (.A(combus[1]), .B(N11013), .Y(N3323));
  OAI21X1 U48_C4_1 (.A0(rmw_1), .A1(n25), .B0(N1404), .Y(p1[0]));
  NAND2X1 U41_C4_2 (.A(combus[5]), .B(N11013), .Y(N12160));
  OAI21X1 U43_C4_1 (.A0(n30), .A1(N11013), .B0(N8468), .Y(N8908));
  NAND2X1 U42_C4_2 (.A(combus[6]), .B(N11013), .Y(N7751));
  OAI21X1 U53_C4_1 (.A0(rmw_1), .A1(n30), .B0(N1861), .Y(p1[7]));
  INVX2 U56_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N8789));
endmodule

// Entity:gpio2_test_1 Model:gpio2_test_1 Library:L0
module gpio2_test_1 (clk, rst_p, wr, rmw, combus, prt2_addr, p2_in, p2, p2_out, 
     rc8051RtlTop_test_point_535_in, test_si1, test_so1, test_si2, test_so2, 
     test_se, clk0_21);
  input clk, rst_p, wr, rmw, rc8051RtlTop_test_point_535_in, test_si1, test_si2, 
     test_se, clk0_21;
  output test_so1, test_so2;
  input [7:0] combus;
  input [7:0] prt2_addr;
  input [7:0] p2_in;
  output [7:0] p2;
  output [7:0] p2_out;
  wire n25, n26, n27, n28, n29, n30, n31, n32, N8820, N8824, N8815, N8837, 
     N12152, N9008, N11972, N10134, N6236, N11948, N10194, N8501, N5715, N6948, 
     N11650, N11488, N6543, N1300, N1721, N2076, N12229, N2351, N10216, N285, 
     N7977, N11579, N8820_5, N8820_6, rmw_1, prt2_addr_4_1, N8820_1;
  NAND4BBX1 U33_C3_9 (.AN(prt2_addr[6]), .BN(prt2_addr_4_1), .C(N8820_6), 
     .D(N8820_5), .Y(N8820));
  BUFX1 BL1_ASSIGN_BUF23 (.A(test_so1), .Y(p2_out[4]));
  NOR3BX1 U33_C3_5 (.AN(prt2_addr[7]), .B(prt2_addr[2]), .C(prt2_addr[3]), 
     .Y(N8820_5));
  BUFX1 BL1_BUF558 (.A(prt2_addr[4]), .Y(prt2_addr_4_1));
  NOR4BBX1 U33_C3_6 (.AN(wr), .BN(prt2_addr[5]), .C(prt2_addr[1]), 
     .D(prt2_addr[0]), .Y(N8820_6));
  OAI21X1 U48_C4_1 (.A0(rmw_1), .A1(n25), .B0(N7977), .Y(p2[0]));
  OAI21X1 U55_C4_1 (.A0(rmw_1), .A1(n32), .B0(N6543), .Y(p2[5]));
  NAND2X1 U48_C4_3 (.A(rmw_1), .B(p2_in[0]), .Y(N7977));
  NAND2X1 U55_C4_3 (.A(rmw_1), .B(p2_in[5]), .Y(N6543));
  SDFFSX1 p2_out_reg_0_ (.CK(clk0_21), .D(N10134), .Q(p2_out[0]), .QN(n25), 
     .SE(test_se), .SI(test_si1), .SN(N8815));
  SDFFSX1 p2_out_reg_2_ (.CK(clk0_21), .D(N11948), .Q(p2_out[2]), .QN(n26), 
     .SE(test_se), .SI(p2_out[1]), .SN(N8815));
  SDFFSX1 p2_out_reg_6_ (.CK(clk0_21), .D(N9008), .Q(p2_out[6]), .QN(n31), 
     .SE(test_se), .SI(p2_out[5]), .SN(N8815));
  NAND2X1 U44_C4_2 (.A(combus[3]), .B(N8820_1), .Y(N285));
  OAI21X1 U43_C4_1 (.A0(n30), .A1(N8820_1), .B0(N8501), .Y(N11972));
  SDFFSX1 p2_out_reg_3_ (.CK(clk0_21), .D(N8824), .Q(p2_out[3]), .QN(n27), 
     .SE(test_se), .SI(p2_out[2]), .SN(N8815));
  OAI21X1 U44_C4_1 (.A0(n27), .A1(N8820_1), .B0(N285), .Y(N8824));
  OAI21X1 U50_C4_1 (.A0(rmw_1), .A1(n27), .B0(N5715), .Y(p2[3]));
  OAI21X1 U52_C4_1 (.A0(rmw_1), .A1(n29), .B0(N10216), .Y(p2[4]));
  OAI21X1 U40_C4_1 (.A0(n29), .A1(N8820_1), .B0(N2076), .Y(N8837));
  NAND2X1 U50_C4_3 (.A(rmw_1), .B(p2_in[3]), .Y(N5715));
  NAND2X1 U40_C4_2 (.A(combus[4]), .B(N8820_1), .Y(N2076));
  SDFFSX1 p2_out_reg_4_ (.CK(clk0_21), .D(N8837), .Q(test_so1), .QN(n29), 
     .SE(test_se), .SI(p2_out[3]), .SN(N8815));
  NAND2X1 U52_C4_3 (.A(rmw_1), .B(p2_in[4]), .Y(N10216));
  OAI21X1 U47_C4_1 (.A0(n25), .A1(N8820_1), .B0(N1300), .Y(N10134));
  NAND2X1 U47_C4_2 (.A(combus[0]), .B(N8820_1), .Y(N1300));
  OAI21X1 U49_C4_1 (.A0(rmw_1), .A1(n26), .B0(N1721), .Y(p2[2]));
  INVX1 U56_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N8815));
  OAI21X1 U45_C4_1 (.A0(n26), .A1(N8820_1), .B0(N11579), .Y(N11948));
  INVX2 BW1_INV8820 (.A(N8820), .Y(N8820_1));
  OAI21X1 U41_C4_1 (.A0(n32), .A1(N8820_1), .B0(N11488), .Y(N12152));
  NAND2X1 U45_C4_2 (.A(combus[2]), .B(N8820_1), .Y(N11579));
  BUFX1 BL1_ASSIGN_BUF48 (.A(test_so2), .Y(p2_out[7]));
  NAND2X1 U46_C4_2 (.A(combus[1]), .B(N8820_1), .Y(N6948));
  SDFFSX1 p2_out_reg_1_ (.CK(clk0_21), .D(N6236), .Q(p2_out[1]), .QN(n28), 
     .SE(test_se), .SI(p2_out[0]), .SN(N8815));
  OAI21X1 U46_C4_1 (.A0(n28), .A1(N8820_1), .B0(N6948), .Y(N6236));
  SDFFSX1 p2_out_reg_7_ (.CK(clk0_21), .D(N11972), .Q(test_so2), .QN(n30), 
     .SE(test_se), .SI(p2_out[6]), .SN(N8815));
  NAND2X1 U43_C4_2 (.A(combus[7]), .B(N8820_1), .Y(N8501));
  OAI21X1 U51_C4_1 (.A0(rmw_1), .A1(n28), .B0(N11650), .Y(p2[1]));
  SDFFSX1 p2_out_reg_5_ (.CK(clk0_21), .D(N12152), .Q(p2_out[5]), .QN(n32), 
     .SE(test_se), .SI(test_si2), .SN(N8815));
  NAND2X1 U49_C4_3 (.A(rmw_1), .B(p2_in[2]), .Y(N1721));
  NAND2X1 U53_C4_3 (.A(rmw_1), .B(p2_in[7]), .Y(N10194));
  NAND2X1 U54_C4_3 (.A(rmw_1), .B(p2_in[6]), .Y(N12229));
  OAI21X1 U53_C4_1 (.A0(rmw_1), .A1(n30), .B0(N10194), .Y(p2[7]));
  NAND2X1 U51_C4_3 (.A(rmw_1), .B(p2_in[1]), .Y(N11650));
  INVX2 U48_C4_1_MP_INV (.A(rmw), .Y(rmw_1));
  OAI21X1 U54_C4_1 (.A0(rmw_1), .A1(n31), .B0(N12229), .Y(p2[6]));
  OAI21X1 U42_C4_1 (.A0(n31), .A1(N8820_1), .B0(N2351), .Y(N9008));
  NAND2X1 U41_C4_2 (.A(combus[5]), .B(N8820_1), .Y(N11488));
  NAND2X1 U42_C4_2 (.A(combus[6]), .B(N8820_1), .Y(N2351));
endmodule

// Entity:gpio3_test_1 Model:gpio3_test_1 Library:L0
module gpio3_test_1 (clk, rst_p, wr, rmw, combus, prt3_addr, p3_in, p3, p3_out, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_21);
  input clk, rst_p, wr, rmw, rc8051RtlTop_test_point_535_in, test_si, test_se, 
     clk0_21;
  output test_so;
  input [7:0] combus;
  input [7:0] prt3_addr;
  input [7:0] p3_in;
  output [7:0] p3;
  output [7:0] p3_out;
  wire n25, n26, n27, n28, n29, n30, n31, N10718, N10717, N6231, N12248, N12247, 
     N6230, N10105, N10104, N6229, N6237, N8838, N5975, N7035, N4071, N9929, 
     N7174, N6475, N12348, N4882, N10581, N2777, N10775, N9500, N10664, 
     N10718_1, N10718_2, N10718_7, rmw_1, rmw_2;
  BUFX2 BL2_BUF147 (.A(rmw), .Y(rmw_2));
  BUFX1 BL1_ASSIGN_BUF56 (.A(test_so), .Y(p3_out[7]));
  NOR4BBX1 U34_C3_7 (.AN(prt3_addr[5]), .BN(N10718_1), .C(prt3_addr[1]), 
     .D(prt3_addr[3]), .Y(N10718_7));
  NOR2BX1 U34_C3_1 (.AN(wr), .B(prt3_addr[2]), .Y(N10718_1));
  AND4X2 U34_C3_8 (.A(prt3_addr[7]), .B(prt3_addr[4]), .C(N10718_7), 
     .D(N10718_2), .Y(N10718));
  NOR2X1 U34_C3_2 (.A(prt3_addr[6]), .B(prt3_addr[0]), .Y(N10718_2));
  MX2X1 U33_C4_1 (.A(p3_in[0]), .B(p3_out[0]), .S0(rmw_2), .Y(p3[0]));
  SDFFSX1 p3_out_reg_5_ (.CK(clk0_21), .D(N12248), .Q(p3_out[5]), .QN(n31), 
     .SE(test_se), .SI(p3_out[4]), .SN(N6231));
  SDFFSX1 p3_out_reg_3_ (.CK(clk0_21), .D(N6229), .Q(p3_out[3]), .QN(n28), 
     .SE(test_se), .SI(p3_out[2]), .SN(N6231));
  SDFFSX1 p3_out_reg_4_ (.CK(clk0_21), .D(N10717), .Q(p3_out[4]), .QN(n30), 
     .SE(test_se), .SI(p3_out[3]), .SN(N6231));
  SDFFSX1 p3_out_reg_6_ (.CK(clk0_21), .D(N12247), .Q(p3_out[6]), .QN(n25), 
     .SE(test_se), .SI(p3_out[5]), .SN(N6231));
  SDFFSX1 p3_out_reg_0_ (.CK(clk0_21), .D(N10105), .Q(p3_out[0]), .QN(), 
     .SE(test_se), .SI(test_si), .SN(N6231));
  NAND2X1 U48_C4_2 (.A(combus[1]), .B(N10718), .Y(N6475));
  NAND2X1 U54_C4_3 (.A(rmw_1), .B(p3_in[1]), .Y(N4882));
  OAI21X1 U48_C4_1 (.A0(n29), .A1(N10718), .B0(N6475), .Y(N10104));
  OAI21X1 U54_C4_1 (.A0(rmw_1), .A1(n29), .B0(N4882), .Y(p3[1]));
  NAND2X1 U47_C4_2 (.A(combus[2]), .B(N10718), .Y(N4071));
  OAI21X1 U52_C4_1 (.A0(rmw_1), .A1(n27), .B0(N9929), .Y(p3[2]));
  NAND2X1 U56_C4_3 (.A(rmw_1), .B(p3_in[5]), .Y(N10581));
  NAND2X1 U52_C4_3 (.A(rmw_1), .B(p3_in[2]), .Y(N9929));
  SDFFSX1 p3_out_reg_1_ (.CK(clk0_21), .D(N10104), .Q(p3_out[1]), .QN(n29), 
     .SE(test_se), .SI(p3_out[0]), .SN(N6231));
  OAI21X1 U43_C4_1 (.A0(n31), .A1(N10718), .B0(N7174), .Y(N12248));
  NAND2X1 U53_C4_3 (.A(rmw_1), .B(p3_in[3]), .Y(N10775));
  OAI21X1 U53_C4_1 (.A0(rmw_1), .A1(n28), .B0(N10775), .Y(p3[3]));
  NAND2X1 U44_C4_2 (.A(combus[6]), .B(N10718), .Y(N9500));
  OAI21X1 U44_C4_1 (.A0(n25), .A1(N10718), .B0(N9500), .Y(N12247));
  NAND2X1 U51_C4_3 (.A(rmw_1), .B(p3_in[7]), .Y(N10664));
  OAI21X1 U56_C4_1 (.A0(rmw_1), .A1(n31), .B0(N10581), .Y(p3[5]));
  SDFFSX1 p3_out_reg_2_ (.CK(clk0_21), .D(N6237), .Q(p3_out[2]), .QN(n27), 
     .SE(test_se), .SI(p3_out[1]), .SN(N6231));
  OAI21X1 U47_C4_1 (.A0(n27), .A1(N10718), .B0(N4071), .Y(N6237));
  INVX2 U54_C4_1_MP_INV (.A(rmw_2), .Y(rmw_1));
  MX2X1 U49_C4_1 (.A(p3_out[0]), .B(combus[0]), .S0(N10718), .Y(N10105));
  NAND2X1 U43_C4_2 (.A(combus[5]), .B(N10718), .Y(N7174));
  INVX1 U58_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N6231));
  OAI21X1 U45_C4_1 (.A0(n26), .A1(N10718), .B0(N5975), .Y(N6230));
  SDFFSX1 p3_out_reg_7_ (.CK(clk0_21), .D(N6230), .Q(test_so), .QN(n26), 
     .SE(test_se), .SI(p3_out[6]), .SN(N6231));
  OAI21X1 U55_C4_1 (.A0(rmw_1), .A1(n30), .B0(N12348), .Y(p3[4]));
  OAI21X1 U51_C4_1 (.A0(rmw_1), .A1(n26), .B0(N10664), .Y(p3[7]));
  OAI21X1 U50_C4_1 (.A0(rmw_1), .A1(n25), .B0(N8838), .Y(p3[6]));
  NAND2X1 U50_C4_3 (.A(rmw_1), .B(p3_in[6]), .Y(N8838));
  NAND2X1 U42_C4_2 (.A(combus[4]), .B(N10718), .Y(N7035));
  OAI21X1 U46_C4_1 (.A0(n28), .A1(N10718), .B0(N2777), .Y(N6229));
  OAI21X1 U42_C4_1 (.A0(n30), .A1(N10718), .B0(N7035), .Y(N10717));
  NAND2X1 U55_C4_3 (.A(rmw_1), .B(p3_in[4]), .Y(N12348));
  NAND2X1 U46_C4_2 (.A(combus[3]), .B(N10718), .Y(N2777));
  NAND2X1 U45_C4_2 (.A(combus[7]), .B(N10718), .Y(N5975));
endmodule

// Entity:ie_test_1 Model:ie_test_1 Library:L0
module ie_test_1 (clk, rst_p, in_ie, addr_ie, wr, out_ie, 
     rc8051RtlTop_test_point_535_in, test_si1, test_so1, test_si2, test_so2, 
     test_se, clk0_7);
  input clk, rst_p, wr, rc8051RtlTop_test_point_535_in, test_si1, test_si2, 
     test_se, clk0_7;
  output test_so1, test_so2;
  input [7:0] in_ie;
  input [7:0] addr_ie;
  output [7:0] out_ie;
  wire n7, n8, n9, n10, n11, n12, n13, n14, N11947, N6235, N11751, N6234, 
     N11598, N11597, N6233, N11434, N11433, N6232, N6983, N10429, N8491, N10039, 
     N4843, N7409, N1437, N11536, N11947_1, N11947_2, N11947_7, addr_ie_1_1;
  supply1 VDD;
  BUFX1 BL1_ASSIGN_BUF25 (.A(test_so1), .Y(out_ie[0]));
  NAND2X1 U27_C4_2 (.A(in_ie[2]), .B(N11947), .Y(N10039));
  SDFFSRX1 out_ie_reg_0_ (.CK(clk0_7), .D(N11433), .Q(test_so1), .QN(n7), 
     .RN(N11751), .SE(test_se), .SI(test_si1), .SN(VDD));
  SDFFSRX1 out_ie_reg_3_ (.CK(clk0_7), .D(N11434), .Q(out_ie[3]), .QN(n10), 
     .RN(N11751), .SE(test_se), .SI(out_ie[2]), .SN(VDD));
  SDFFSRX1 out_ie_reg_2_ (.CK(clk0_7), .D(N6232), .Q(out_ie[2]), .QN(n9), 
     .RN(N11751), .SE(test_se), .SI(out_ie[1]), .SN(VDD));
  SDFFSRX1 out_ie_reg_1_ (.CK(clk0_7), .D(N6233), .Q(out_ie[1]), .QN(n8), 
     .RN(N11751), .SE(test_se), .SI(test_si2), .SN(VDD));
  OAI21X1 U27_C4_1 (.A0(n9), .A1(N11947), .B0(N10039), .Y(N6232));
  NAND2X1 U26_C4_2 (.A(in_ie[3]), .B(N11947), .Y(N6983));
  OAI21X1 U26_C4_1 (.A0(n10), .A1(N11947), .B0(N6983), .Y(N11434));
  SDFFSRX1 out_ie_reg_7_ (.CK(clk0_7), .D(N11597), .Q(test_so2), .QN(n14), 
     .RN(N11751), .SE(test_se), .SI(out_ie[6]), .SN(VDD));
  NAND2X1 U22_C4_2 (.A(in_ie[4]), .B(N11947), .Y(N4843));
  OAI21X1 U22_C4_1 (.A0(n11), .A1(N11947), .B0(N4843), .Y(N11598));
  BUFX1 BL1_ASSIGN_BUF167 (.A(test_so2), .Y(out_ie[7]));
  SDFFSRX1 out_ie_reg_5_ (.CK(clk0_7), .D(N6235), .Q(out_ie[5]), .QN(n12), 
     .RN(N11751), .SE(test_se), .SI(out_ie[4]), .SN(VDD));
  SDFFSRX1 out_ie_reg_6_ (.CK(clk0_7), .D(N6234), .Q(out_ie[6]), .QN(n13), 
     .RN(N11751), .SE(test_se), .SI(out_ie[5]), .SN(VDD));
  AND4X1 U16_C3_7 (.A(wr), .B(addr_ie[5]), .C(addr_ie_1_1), .D(N11947_1), 
     .Y(N11947_7));
  AND4X2 U16_C3_8 (.A(addr_ie[7]), .B(addr_ie[3]), .C(N11947_7), .D(N11947_2), 
     .Y(N11947));
  NOR2X1 U16_C3_2 (.A(addr_ie[4]), .B(addr_ie[0]), .Y(N11947_2));
  NOR2X1 U16_C3_1 (.A(addr_ie[6]), .B(addr_ie[2]), .Y(N11947_1));
  INVX1 U16_C3_7_MP_INV (.A(addr_ie[1]), .Y(addr_ie_1_1));
  OAI21X1 U28_C4_1 (.A0(n8), .A1(N11947), .B0(N11536), .Y(N6233));
  NAND2X1 U28_C4_2 (.A(in_ie[1]), .B(N11947), .Y(N11536));
  SDFFSRX1 out_ie_reg_4_ (.CK(clk0_7), .D(N11598), .Q(out_ie[4]), .QN(n11), 
     .RN(N11751), .SE(test_se), .SI(out_ie[3]), .SN(VDD));
  OAI21X1 U29_C4_1 (.A0(n7), .A1(N11947), .B0(N7409), .Y(N11433));
  NAND2X1 U29_C4_2 (.A(in_ie[0]), .B(N11947), .Y(N7409));
  OAI21X1 U24_C4_1 (.A0(n13), .A1(N11947), .B0(N10429), .Y(N6234));
  NAND2X1 U23_C4_2 (.A(in_ie[5]), .B(N11947), .Y(N1437));
  INVX1 U30_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N11751));
  OAI21X1 U25_C4_1 (.A0(n14), .A1(N11947), .B0(N8491), .Y(N11597));
  NAND2X1 U25_C4_2 (.A(in_ie[7]), .B(N11947), .Y(N8491));
  NAND2X1 U24_C4_2 (.A(in_ie[6]), .B(N11947), .Y(N10429));
  OAI21X1 U23_C4_1 (.A0(n12), .A1(N11947), .B0(N1437), .Y(N6235));
endmodule

// Entity:ip_test_1 Model:ip_test_1 Library:L0
module ip_test_1 (clk, rst_p, in_ip, addr_ip, wr, out_ip, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_4, clk0_7);
  input clk, rst_p, wr, rc8051RtlTop_test_point_535_in, test_si, test_se, 
     clk0_4, clk0_7;
  output test_so;
  input [7:0] in_ip;
  input [7:0] addr_ip;
  output [7:0] out_ip;
  wire n7, n8, n9, n10, n11, n12, n13, n14, N10438, N6125, N6246, N6227, N12168, 
     N11150, N6225, N5989, N11149, N5747, N3839, N10210, N7013, N10428, N10651, 
     N1621, N10446, N11601, N10438_5, N10438_6, addr_ip_2_1, addr_ip_6_1;
  supply1 VDD;
  SDFFSRX1 out_ip_reg_5_ (.CK(clk0_7), .D(N6125), .Q(out_ip[5]), .QN(n12), 
     .RN(N6246), .SE(test_se), .SI(out_ip[4]), .SN(VDD));
  NAND2X1 U21_C4_2 (.A(in_ip[5]), .B(N10438), .Y(N7013));
  OAI21X1 U21_C4_1 (.A0(n12), .A1(N10438), .B0(N7013), .Y(N6125));
  SDFFSRX1 out_ip_reg_7_ (.CK(clk0_7), .D(N12168), .Q(test_so), .QN(n14), 
     .RN(N6246), .SE(test_se), .SI(out_ip[6]), .SN(VDD));
  SDFFSRX1 out_ip_reg_3_ (.CK(clk0_4), .D(N6225), .Q(out_ip[3]), .QN(n10), 
     .RN(N6246), .SE(test_se), .SI(out_ip[2]), .SN(VDD));
  OAI21X1 U20_C4_1 (.A0(n11), .A1(N10438), .B0(N10446), .Y(N11150));
  SDFFSRX1 out_ip_reg_1_ (.CK(clk0_7), .D(N5747), .Q(out_ip[1]), .QN(n8), 
     .RN(N6246), .SE(test_se), .SI(out_ip[0]), .SN(VDD));
  OAI21X1 U26_C4_1 (.A0(n8), .A1(N10438), .B0(N11601), .Y(N5747));
  NAND2X1 U26_C4_2 (.A(in_ip[1]), .B(N10438), .Y(N11601));
  SDFFSRX1 out_ip_reg_2_ (.CK(clk0_7), .D(N11149), .Q(out_ip[2]), .QN(n9), 
     .RN(N6246), .SE(test_se), .SI(out_ip[1]), .SN(VDD));
  OAI21X1 U25_C4_1 (.A0(n9), .A1(N10438), .B0(N10210), .Y(N11149));
  NAND2X1 U25_C4_2 (.A(in_ip[2]), .B(N10438), .Y(N10210));
  NAND2X1 U22_C4_2 (.A(in_ip[7]), .B(N10438), .Y(N10428));
  OAI21X1 U22_C4_1 (.A0(n14), .A1(N10438), .B0(N10428), .Y(N12168));
  SDFFSRX1 out_ip_reg_6_ (.CK(clk0_7), .D(N6227), .Q(out_ip[6]), .QN(n13), 
     .RN(N6246), .SE(test_se), .SI(out_ip[5]), .SN(VDD));
  NOR4BBX1 U17_C1_6 (.AN(addr_ip[5]), .BN(addr_ip[4]), .C(addr_ip[1]), 
     .D(addr_ip[0]), .Y(N10438_6));
  AND4X2 U17_C1_8 (.A(wr), .B(addr_ip_2_1), .C(N10438_6), .D(N10438_5), 
     .Y(N10438));
  INVX1 U17_C1_8_MP_INV (.A(addr_ip[2]), .Y(addr_ip_2_1));
  INVX1 U17_C1_5_MP_INV (.A(addr_ip[6]), .Y(addr_ip_6_1));
  SDFFSRX1 out_ip_reg_4_ (.CK(clk0_7), .D(N11150), .Q(out_ip[4]), .QN(n11), 
     .RN(N6246), .SE(test_se), .SI(out_ip[3]), .SN(VDD));
  NAND2X1 U27_C4_2 (.A(in_ip[0]), .B(N10438), .Y(N10651));
  OAI21X1 U27_C4_1 (.A0(n7), .A1(N10438), .B0(N10651), .Y(N5989));
  OAI21X1 U24_C4_1 (.A0(n10), .A1(N10438), .B0(N3839), .Y(N6225));
  NAND2X1 U24_C4_2 (.A(in_ip[3]), .B(N10438), .Y(N3839));
  NAND2X1 U20_C4_2 (.A(in_ip[4]), .B(N10438), .Y(N10446));
  AND3X1 U17_C1_5 (.A(addr_ip[7]), .B(addr_ip_6_1), .C(addr_ip[3]), .Y(N10438_5));
  SDFFSRX1 out_ip_reg_0_ (.CK(clk0_7), .D(N5989), .Q(out_ip[0]), .QN(n7), 
     .RN(N6246), .SE(test_se), .SI(test_si), .SN(VDD));
  NAND2X1 U23_C4_2 (.A(in_ip[6]), .B(N10438), .Y(N1621));
  OAI21X1 U23_C4_1 (.A0(n13), .A1(N10438), .B0(N1621), .Y(N6227));
  INVX1 U28_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N6246));
  BUFX1 BL1_ASSIGN_BUF168 (.A(test_so), .Y(out_ip[7]));
endmodule

// Entity:one_shot_1_test_1 Model:one_shot_1_test_1 Library:L0
module one_shot_1_test_1 (rst_p, clk, d, q, rc8051RtlTop_test_point_535_in, 
     test_si, test_so, test_se, clk0_4);
  input rst_p, clk, d, rc8051RtlTop_test_point_535_in, test_si, test_se, clk0_4;
  output q, test_so;
  wire N8893, N10945;
  SDFFSX2 d_del_reg (.CK(clk0_4), .D(N8893), .Q(test_so), .QN(), .SE(test_se), 
     .SI(test_si), .SN(N10945));
  INVX1 U8_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N10945));
  NOR2BX1 U7_C1 (.AN(test_so), .B(N8893), .Y(q));
  INVX1 U6_C1 (.A(d), .Y(N8893));
endmodule

// Entity:one_shot_2_test_1 Model:one_shot_2_test_1 Library:L0
module one_shot_2_test_1 (rst_p, clk, d, q, rc8051RtlTop_test_point_535_in, 
     test_si, test_so, test_se, clk0_4);
  input rst_p, clk, d, rc8051RtlTop_test_point_535_in, test_si, test_se, clk0_4;
  output q, test_so;
  wire N11574, N11573;
  NOR2BX1 U6_C1 (.AN(test_so), .B(N11574), .Y(q));
  SDFFSX1 d_del_reg (.CK(clk0_4), .D(N11574), .Q(test_so), .QN(), .SE(test_se), 
     .SI(test_si), .SN(N11573));
  INVX1 U8_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N11573));
  INVX1 U7_C1 (.A(d), .Y(N11574));
endmodule

// Entity:parity_gen Model:parity_gen Library:L0
module parity_gen (p_acc, parity);
  output parity;
  input [7:0] p_acc;
  wire N11190, N11189, N7922, N7884, N10685, N10684;
  XOR2X1 U7_C2 (.A(p_acc[1]), .B(p_acc[0]), .Y(N7922));
  XOR2X1 U9_C2 (.A(p_acc[5]), .B(p_acc[4]), .Y(N11190));
  XNOR2X1 U7_C2_1 (.A(N7922), .B(N7884), .Y(N10684));
  XNOR2X1 U9_C2_1 (.A(N11190), .B(N11189), .Y(N10685));
  XOR2X1 U6_C1 (.A(N10685), .B(N10684), .Y(parity));
  XNOR2X1 U10_C1 (.A(p_acc[7]), .B(p_acc[6]), .Y(N11189));
  XNOR2X1 U8_C1 (.A(p_acc[3]), .B(p_acc[2]), .Y(N7884));
endmodule

// Entity:psw_test_1 Model:psw_test_1 Library:L0
module psw_test_1 (rst_p, in_psw, clk, addr_psw, wr, in_cy_bit, set_c, rst_c, 
     cpl_c, ld_c, set_ac, rst_ac, set_v, rst_v, parity, out_psw, 
     rc8051RtlTop_test_mode_in, test_si1, test_so1, test_si2, test_so2, test_se, 
     clk0_21, clk0_8);
  input rst_p, clk, wr, in_cy_bit, set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac, 
     set_v, rst_v, parity, rc8051RtlTop_test_mode_in, test_si1, test_si2, 
     test_se, clk0_21, clk0_8;
  output test_so1, test_so2;
  input [6:0] in_psw;
  input [7:0] addr_psw;
  output [7:0] out_psw;
  wire y, n17, n18, n19, n20, n28, N11688, N5621, N5622, N10076, N10074, N10073, 
     N10072, N11687, N10546, N5603, N10363, N7924, N10898, N1424, N1616, N9731, 
     N2133_1, N10071_1, N11688_1, N11688_4, N11688_6, set_c_1, N11688_2, 
     U45_C1__n_1, set_v_1, U44_C1__n_1, set_ac_1;
  supply1 VDD;
  mux2t1_1_2 u0 (.a(in_psw[6]), .b(n28), .sel(cpl_c), .c(y));
  AOI31X1 U34_C3_3 (.A0(set_c_1), .A1(N1616), .A2(N10071_1), .B0(rst_c), 
     .Y(N10546));
  AND2X1 U34_C3_11 (.A(ld_c), .B(in_cy_bit), .Y(N2133_1));
  INVX1 U34_C3_3_MP_INV (.A(set_c), .Y(set_c_1));
  MXI2X1 U34_C3_2 (.A(N2133_1), .B(y), .S0(cpl_c), .Y(N10071_1));
  NAND2BX1 U34_C3_10 (.AN(ld_c), .B(N11687), .Y(N1616));
  SDFFRHQX1 out_psw_reg_2_ (.CK(clk0_21), .D(N10074), .Q(out_psw[2]), .RN(N5622), 
     .SE(test_se), .SI(out_psw[1]));
  SDFFSRX1 out_psw_reg_4_ (.CK(clk0_8), .D(N10073), .Q(out_psw[4]), .QN(n19), 
     .RN(N5622), .SE(test_se), .SI(test_si2), .SN(VDD));
  SDFFSRX1 out_psw_reg_7_ (.CK(clk0_8), .D(N10546), .Q(test_so2), .QN(n28), 
     .RN(N5622), .SE(test_se), .SI(out_psw[6]), .SN(VDD));
  OAI21X1 U46_C4_1 (.A0(n18), .A1(N11688), .B0(N10363), .Y(N10072));
  XNOR2X1 \test_point_528/U6_C4  (.A(rst_p), .B(rc8051RtlTop_test_mode_in), 
     .Y(N5622));
  SDFFSRX1 out_psw_reg_3_ (.CK(clk0_21), .D(N10072), .Q(test_so1), .QN(n18), 
     .RN(N5622), .SE(test_se), .SI(out_psw[2]), .SN(VDD));
  OAI21X1 U43_C4_1 (.A0(n20), .A1(N11688), .B0(N1424), .Y(N5621));
  NAND2X1 U47_C4_2 (.A(in_psw[0]), .B(N11688), .Y(N7924));
  NOR2BX1 U33_C1 (.AN(parity), .B(rst_p), .Y(out_psw[0]));
  SDFFRHQX4 out_psw_reg_6_ (.CK(clk0_8), .D(N5603), .Q(out_psw[6]), .RN(N5622), 
     .SE(test_se), .SI(out_psw[5]));
  MXI2X1 U44_C1_5 (.A(out_psw[6]), .B(in_psw[5]), .S0(N11688), .Y(U44_C1__n_1));
  BUFX3 BL1_ASSIGN_BUF70 (.A(test_so2), .Y(out_psw[7]));
  NAND3BX1 U34_C3_14 (.AN(cpl_c), .B(test_so2), .C(N11688_2), .Y(N10898));
  INVX1 U44_C1_1_MP_INV (.A(set_ac), .Y(set_ac_1));
  OAI2BB1X1 U34_C3_4 (.A0N(y), .A1N(N11688), .B0(N10898), .Y(N11687));
  AOI21X1 U44_C1_1 (.A0(set_ac_1), .A1(U44_C1__n_1), .B0(rst_ac), .Y(N5603));
  SDFFSRX1 out_psw_reg_1_ (.CK(clk0_21), .D(N10076), .Q(out_psw[1]), .QN(n17), 
     .RN(N5622), .SE(test_se), .SI(test_si1), .SN(VDD));
  NAND2X1 U43_C4_2 (.A(in_psw[4]), .B(N11688), .Y(N1424));
  OAI21X1 U47_C4_1 (.A0(n17), .A1(N11688), .B0(N7924), .Y(N10076));
  BUFX1 BL1_ASSIGN_BUF27 (.A(test_so1), .Y(out_psw[3]));
  SDFFSRX1 out_psw_reg_5_ (.CK(clk0_21), .D(N5621), .Q(out_psw[5]), .QN(n20), 
     .RN(N5622), .SE(test_se), .SI(out_psw[4]), .SN(VDD));
  NAND2X1 U46_C4_2 (.A(in_psw[2]), .B(N11688), .Y(N10363));
  AOI21X1 U45_C1_1 (.A0(set_v_1), .A1(U45_C1__n_1), .B0(rst_v), .Y(N10074));
  INVX1 U34_C3_14_MP_INV (.A(N11688), .Y(N11688_2));
  INVX1 U45_C1_1_MP_INV (.A(set_v), .Y(set_v_1));
  MXI2X1 U45_C1_5 (.A(out_psw[2]), .B(in_psw[1]), .S0(N11688), .Y(U45_C1__n_1));
  OAI21X1 U42_C4_1 (.A0(n19), .A1(N11688), .B0(N9731), .Y(N10073));
  NAND2X1 U42_C4_2 (.A(in_psw[3]), .B(N11688), .Y(N9731));
  NOR4BBX1 U29_C3_6 (.AN(addr_psw[7]), .BN(addr_psw[6]), .C(addr_psw[3]), 
     .D(addr_psw[2]), .Y(N11688_6));
  AND4X2 U29_C3_8 (.A(addr_psw[4]), .B(N11688_6), .C(N11688_4), .D(N11688_1), 
     .Y(N11688));
  NOR2X1 U29_C3_1 (.A(addr_psw[5]), .B(addr_psw[1]), .Y(N11688_1));
  NOR2BX1 U29_C3_4 (.AN(wr), .B(addr_psw[0]), .Y(N11688_4));
endmodule

// Entity:mux2t1_1_2 Model:mux2t1_1_2 Library:L0
module mux2t1_1_2 (a, b, sel, c);
  input a, b, sel;
  output c;
  MX2X1 U8_C1_1 (.A(a), .B(b), .S0(sel), .Y(c));
endmodule

// Entity:sp_test_1 Model:sp_test_1 Library:L0
module sp_test_1 (clk, rst_p, wr, inc_sp, dec_sp, addr_sp, in_sp, out_sp, 
     rc8051RtlTop_test_point_535_in, test_si1, test_so1, test_si2, test_so2, 
     test_se, clk0_7);
  input clk, rst_p, wr, inc_sp, dec_sp, rc8051RtlTop_test_point_535_in, 
     test_si1, test_si2, test_se, clk0_7;
  output test_so1, test_so2;
  input [7:0] addr_sp;
  input [7:0] in_sp;
  output [7:0] out_sp;
  wire N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36, 
     N37, N38, U32_C2__n, U35_C2__n, U35_C2__n_1, N8772, N11332, N11331, N11330, 
     N8774, N11423, N11329, N8771, N8931, N12350, U32_C2__n_1, U32_C2__n_3, 
     U32_C2__n_7, N12350_1, N12350_2, N11423_1, N11423_2, N11332_1, N11332_2, 
     N11330_1, N11330_2, N11329_1, N11329_2, N8931_1, N8931_2, N8774_1, N8774_2, 
     N8771_1, N8771_2, N8772_1;
  sp_DW01_inc_8_0 add_28 (.A({test_so2, out_sp[6], test_so1, out_sp[4], 
     out_sp[3], out_sp[2], out_sp[1], out_sp[0]}), .SUM({N30, N29, N28, N27, N26, 
     N25, N24, N23}));
  sp_DW01_dec_8_0 sub_29 (.A({test_so2, out_sp[6], test_so1, out_sp[4], 
     out_sp[3], out_sp[2], out_sp[1], out_sp[0]}), .SUM({N38, N37, N36, N35, N34, 
     N33, N32, N31}));
  SDFFRHQX4 out_sp_reg_6_ (.CK(clk0_7), .D(N8931), .Q(out_sp[6]), .RN(N11331), 
     .SE(test_se), .SI(test_si2));
  SDFFRHQX2 out_sp_reg_5_ (.CK(clk0_7), .D(N8771), .Q(test_so1), .RN(N11331), 
     .SE(test_se), .SI(out_sp[4]));
  SDFFRHQX2 out_sp_reg_7_ (.CK(clk0_7), .D(N12350), .Q(test_so2), .RN(N11331), 
     .SE(test_se), .SI(out_sp[6]));
  SDFFRHQX4 out_sp_reg_4_ (.CK(clk0_7), .D(N11329), .Q(out_sp[4]), .RN(N11331), 
     .SE(test_se), .SI(out_sp[3]));
  AOI22X1 U43_C3_7 (.A0(U35_C2__n), .A1(N35), .B0(in_sp[4]), .B1(U32_C2__n), 
     .Y(N11329_2));
  NAND2X1 U43_C3_8 (.A(N11329_2), .B(N11329_1), .Y(N11329));
  NOR2BX2 U33_C1 (.AN(inc_sp), .B(U32_C2__n), .Y(U35_C2__n_1));
  NOR3BX4 U32_C2_2 (.AN(dec_sp), .B(inc_sp), .C(U32_C2__n), .Y(U35_C2__n));
  NAND2X1 U42_C3_8 (.A(N8771_2), .B(N8771_1), .Y(N8771));
  AOI22X1 U43_C3_6 (.A0(U35_C2__n_1), .A1(N27), .B0(out_sp[4]), .B1(N8772_1), 
     .Y(N11329_1));
  AOI22X1 U48_C3_7 (.A0(U35_C2__n), .A1(N32), .B0(in_sp[1]), .B1(U32_C2__n), 
     .Y(N11330_2));
  AOI22X1 U44_C3_6 (.A0(U35_C2__n_1), .A1(N26), .B0(out_sp[3]), .B1(N8772_1), 
     .Y(N11423_1));
  BUFX2 BL1_ASSIGN_BUF90 (.A(test_so2), .Y(out_sp[7]));
  NOR4BBX1 U36_C3_7 (.AN(addr_sp[0]), .BN(U32_C2__n_1), .C(addr_sp[4]), 
     .D(addr_sp[2]), .Y(U32_C2__n_7));
  NOR2X1 U36_C3_3 (.A(addr_sp[6]), .B(addr_sp[3]), .Y(U32_C2__n_3));
  NOR2X1 U36_C3_1 (.A(addr_sp[5]), .B(addr_sp[1]), .Y(U32_C2__n_1));
  SDFFRHQX4 out_sp_reg_3_ (.CK(clk0_7), .D(N11423), .Q(out_sp[3]), .RN(N11331), 
     .SE(test_se), .SI(out_sp[2]));
  AOI22X1 U45_C3_7 (.A0(U35_C2__n), .A1(N33), .B0(in_sp[2]), .B1(U32_C2__n), 
     .Y(N8774_2));
  NAND2X1 U44_C3_8 (.A(N11423_2), .B(N11423_1), .Y(N11423));
  AND4X2 U36_C3_8 (.A(wr), .B(addr_sp[7]), .C(U32_C2__n_7), .D(U32_C2__n_3), 
     .Y(U32_C2__n));
  AOI22X1 U48_C3_6 (.A0(U35_C2__n_1), .A1(N24), .B0(out_sp[1]), .B1(N8772_1), 
     .Y(N11330_1));
  NAND2X1 U47_C3_8 (.A(N11332_2), .B(N11332_1), .Y(N11332));
  AOI22X1 U47_C3_6 (.A0(U35_C2__n_1), .A1(N23), .B0(out_sp[0]), .B1(N8772_1), 
     .Y(N11332_1));
  SDFFSX2 out_sp_reg_0_ (.CK(clk0_7), .D(N11332), .Q(out_sp[0]), .QN(), 
     .SE(test_se), .SI(test_si1), .SN(N11331));
  BUFX1 BL1_ASSIGN_BUF29 (.A(test_so1), .Y(out_sp[5]));
  NAND2X1 U45_C3_8 (.A(N8774_2), .B(N8774_1), .Y(N8774));
  AOI22X1 U45_C3_6 (.A0(U35_C2__n_1), .A1(N25), .B0(out_sp[2]), .B1(N8772_1), 
     .Y(N8774_1));
  SDFFSX2 out_sp_reg_1_ (.CK(clk0_7), .D(N11330), .Q(out_sp[1]), .QN(), 
     .SE(test_se), .SI(out_sp[0]), .SN(N11331));
  SDFFSX2 out_sp_reg_2_ (.CK(clk0_7), .D(N8774), .Q(out_sp[2]), .QN(), 
     .SE(test_se), .SI(out_sp[1]), .SN(N11331));
  AOI22X1 U47_C3_7 (.A0(U35_C2__n), .A1(N31), .B0(in_sp[0]), .B1(U32_C2__n), 
     .Y(N11332_2));
  NAND2X1 U48_C3_8 (.A(N11330_2), .B(N11330_1), .Y(N11330));
  INVX1 BW1_INV8772 (.A(N8772), .Y(N8772_1));
  AOI22X1 U41_C3_6 (.A0(U35_C2__n_1), .A1(N29), .B0(out_sp[6]), .B1(N8772_1), 
     .Y(N8931_1));
  OR3X1 U35_C2_3 (.A(U35_C2__n_1), .B(U35_C2__n), .C(U32_C2__n), .Y(N8772));
  NAND2X1 U46_C3_8 (.A(N12350_2), .B(N12350_1), .Y(N12350));
  AOI22X1 U41_C3_7 (.A0(U35_C2__n), .A1(N37), .B0(in_sp[6]), .B1(U32_C2__n), 
     .Y(N8931_2));
  AOI22X1 U42_C3_6 (.A0(U35_C2__n_1), .A1(N28), .B0(test_so1), .B1(N8772_1), 
     .Y(N8771_1));
  NAND2X1 U41_C3_8 (.A(N8931_2), .B(N8931_1), .Y(N8931));
  AOI22X1 U46_C3_7 (.A0(U35_C2__n), .A1(N38), .B0(in_sp[7]), .B1(U32_C2__n), 
     .Y(N12350_2));
  AOI22X1 U42_C3_7 (.A0(U35_C2__n), .A1(N36), .B0(in_sp[5]), .B1(U32_C2__n), 
     .Y(N8771_2));
  AOI22X1 U46_C3_6 (.A0(U35_C2__n_1), .A1(N30), .B0(test_so2), .B1(N8772_1), 
     .Y(N12350_1));
  INVX2 U49_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N11331));
  AOI22X1 U44_C3_7 (.A0(U35_C2__n), .A1(N34), .B0(in_sp[3]), .B1(U32_C2__n), 
     .Y(N11423_2));
endmodule

// Entity:sp_DW01_dec_8_0 Model:sp_DW01_dec_8_0 Library:L0
module sp_DW01_dec_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire U1_B_2_C1__n, U1_B_3_C1__n, U1_B_4_C1__n, U1_B_5_C1__n, U1_B_6_C1__n, 
     N10666;
  XNOR2X1 U1_A_3_C1 (.A(U1_B_3_C1__n), .B(A[3]), .Y(SUM[3]));
  OR2X1 U1_B_4_C1 (.A(U1_B_4_C1__n), .B(A[4]), .Y(U1_B_5_C1__n));
  XNOR2X1 U1_A_6_C1 (.A(U1_B_6_C1__n), .B(A[6]), .Y(SUM[6]));
  XNOR2X1 U1_A_7_C1 (.A(A[7]), .B(N10666), .Y(SUM[7]));
  OR2X1 U1_B_5_C1 (.A(U1_B_5_C1__n), .B(A[5]), .Y(U1_B_6_C1__n));
  OR2X1 U1_B_6_C1 (.A(U1_B_6_C1__n), .B(A[6]), .Y(N10666));
  XNOR2X1 U1_A_5_C1 (.A(U1_B_5_C1__n), .B(A[5]), .Y(SUM[5]));
  XNOR2X1 U1_A_4_C1 (.A(U1_B_4_C1__n), .B(A[4]), .Y(SUM[4]));
  OR2X1 U1_B_3_C1 (.A(U1_B_3_C1__n), .B(A[3]), .Y(U1_B_4_C1__n));
  OR2X1 U1_B_1_C1 (.A(A[1]), .B(A[0]), .Y(U1_B_2_C1__n));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  XOR2X1 U1_A_1_C1 (.A(A[1]), .B(SUM[0]), .Y(SUM[1]));
  XNOR2X1 U1_A_2_C1 (.A(U1_B_2_C1__n), .B(A[2]), .Y(SUM[2]));
  OR2X1 U1_B_2_C1 (.A(U1_B_2_C1__n), .B(A[2]), .Y(U1_B_3_C1__n));
endmodule

// Entity:sp_DW01_inc_8_0 Model:sp_DW01_inc_8_0 Library:L0
module sp_DW01_inc_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;
  XOR2X1 U5_C1 (.A(carry_7_), .B(A[7]), .Y(SUM[7]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
endmodule

// Entity:tcon_test_1 Model:tcon_test_1 Library:L0
module tcon_test_1 (clk, rst_p, in_tcon, addr_tcon, wr, set_tf0, rst_tf0, 
     set_tf1, rst_tf1, set_ie0, rst_ie0, set_ie1, rst_ie1, out_tcon, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_4);
  input clk, rst_p, wr, set_tf0, rst_tf0, set_tf1, rst_tf1, set_ie0, rst_ie0, 
     set_ie1, rst_ie1, rc8051RtlTop_test_point_535_in, test_si, test_se, clk0_4;
  output test_so;
  input [7:0] in_tcon;
  input [7:0] addr_tcon;
  output [7:0] out_tcon;
  wire set_tf0_d2, set_tf0_d1, set_tf1_d2, set_tf1_d1, set_ie0_d2, set_ie0_d1, 
     set_ie1_d2, set_ie1_d1, n24, n25, n26, n27, n28, n29, n30, n31, N10944, 
     N8892, N10116, N8937, N11113, N11112, N8936, N10064, N10063, N8935, N10342, 
     N10341, N8934, N11371, N4068, N6533, N11655, N11304, N1459, N11711, N10785, 
     N9160, N8892_1, N8892_4, N8892_6, N11113_2, N8892_2, N10341_2, N8936_2, 
     N8935_2;
  supply1 VDD;
  INVX1 U46_C2_7_MP_INV (.A(N10341_2), .Y(N10341));
  NOR3X1 U46_C2_5 (.A(rst_ie1), .B(n25), .C(N10342), .Y(N1459));
  NOR3X1 U57_C2_2 (.A(set_ie1_d2), .B(set_ie1_d1), .C(N8892_2), .Y(N10342));
  AND4X1 U34_C3_8 (.A(addr_tcon[7]), .B(N8892_6), .C(N8892_4), .D(N8892_1), 
     .Y(N8892));
  AOI211X1 U46_C2_7 (.A0(in_tcon[3]), .A1(N10342), .B0(set_ie1), .C0(N1459), 
     .Y(N10341_2));
  SDFFRHQX1 set_ie1_d2_reg (.CK(clk0_4), .D(set_ie1_d1), .Q(set_ie1_d2), 
     .RN(N10944), .SE(test_se), .SI(set_ie1_d1));
  INVX1 U55_C2_2_MP_INV (.A(N8892), .Y(N8892_2));
  AOI211X1 U51_C2_7 (.A0(in_tcon[1]), .A1(N10063), .B0(set_ie0), .C0(N9160), 
     .Y(N8935_2));
  SDFFSRX1 tcon_ie1_reg (.CK(clk0_4), .D(N10341), .Q(out_tcon[3]), .QN(n25), 
     .RN(N10944), .SE(test_se), .SI(out_tcon[1]), .SN(VDD));
  SDFFSRX1 tcon_ie0_reg (.CK(clk0_4), .D(N8935), .Q(out_tcon[1]), .QN(n24), 
     .RN(N10944), .SE(test_se), .SI(set_tf1_d2), .SN(VDD));
  NOR3X1 U51_C2_5 (.A(rst_ie0), .B(n24), .C(N10063), .Y(N9160));
  NOR2BX1 U34_C3_4 (.AN(addr_tcon[3]), .B(addr_tcon[1]), .Y(N8892_4));
  AOI211X1 U40_C2_7 (.A0(in_tcon[5]), .A1(N11112), .B0(set_tf0), .C0(N4068), 
     .Y(N8936_2));
  NOR3X1 U43_C2_5 (.A(rst_tf1), .B(n31), .C(N8937), .Y(N6533));
  INVX1 U43_C2_7_MP_INV (.A(N11113_2), .Y(N11113));
  SDFFSRX1 tcon_tf1_reg (.CK(clk0_4), .D(N11113), .Q(test_so), .QN(n31), 
     .RN(N10944), .SE(test_se), .SI(out_tcon[5]), .SN(VDD));
  NOR3X1 U40_C2_5 (.A(rst_tf0), .B(n30), .C(N11112), .Y(N4068));
  NAND2X1 U38_C4_2 (.A(in_tcon[4]), .B(N8892), .Y(N10785));
  NAND2X1 U39_C4_2 (.A(in_tcon[6]), .B(N8892), .Y(N11304));
  OAI21X1 U39_C4_1 (.A0(n29), .A1(N8892), .B0(N11304), .Y(N10064));
  OAI21X1 U49_C4_1 (.A0(n27), .A1(N8892), .B0(N11711), .Y(N11371));
  OAI21X1 U38_C4_1 (.A0(n28), .A1(N8892), .B0(N10785), .Y(N10116));
  NAND2X1 U49_C4_2 (.A(in_tcon[2]), .B(N8892), .Y(N11711));
  SDFFSRX1 tcon_reg_3_ (.CK(clk0_4), .D(N10064), .Q(out_tcon[6]), .QN(n29), 
     .RN(N10944), .SE(test_se), .SI(out_tcon[4]), .SN(VDD));
  SDFFSRX1 tcon_reg_2_ (.CK(clk0_4), .D(N10116), .Q(out_tcon[4]), .QN(n28), 
     .RN(N10944), .SE(test_se), .SI(out_tcon[2]), .SN(VDD));
  SDFFSRX1 tcon_reg_1_ (.CK(clk0_4), .D(N11371), .Q(out_tcon[2]), .QN(n27), 
     .RN(N10944), .SE(test_se), .SI(out_tcon[0]), .SN(VDD));
  AOI211X1 U43_C2_7 (.A0(in_tcon[7]), .A1(N8937), .B0(set_tf1), .C0(N6533), 
     .Y(N11113_2));
  NOR3X1 U55_C2_2 (.A(set_tf1_d2), .B(set_tf1_d1), .C(N8892_2), .Y(N8937));
  SDFFRHQX1 set_tf1_d1_reg (.CK(clk0_4), .D(set_tf1), .Q(set_tf1_d1), 
     .RN(N10944), .SE(test_se), .SI(set_tf0_d2));
  SDFFRHQX1 set_tf0_d2_reg (.CK(clk0_4), .D(set_tf0_d1), .Q(set_tf0_d2), 
     .RN(N10944), .SE(test_se), .SI(set_tf0_d1));
  BUFX1 BL1_ASSIGN_BUF164 (.A(test_so), .Y(out_tcon[7]));
  NOR3X1 U54_C2_2 (.A(set_tf0_d2), .B(set_tf0_d1), .C(N8892_2), .Y(N11112));
  SDFFRHQX1 set_tf1_d2_reg (.CK(clk0_4), .D(set_tf1_d1), .Q(set_tf1_d2), 
     .RN(N10944), .SE(test_se), .SI(set_tf1_d1));
  SDFFRHQX1 set_tf0_d1_reg (.CK(clk0_4), .D(set_tf0), .Q(set_tf0_d1), 
     .RN(N10944), .SE(test_se), .SI(set_ie1_d2));
  INVX1 U40_C2_7_MP_INV (.A(N8936_2), .Y(N8936));
  INVX2 U58_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N10944));
  SDFFRHQX1 set_ie0_d1_reg (.CK(clk0_4), .D(set_ie0), .Q(set_ie0_d1), 
     .RN(N10944), .SE(test_se), .SI(test_si));
  NOR3X1 U56_C2_2 (.A(set_ie0_d2), .B(set_ie0_d1), .C(N8892_2), .Y(N10063));
  SDFFRHQX1 set_ie1_d1_reg (.CK(clk0_4), .D(set_ie1), .Q(set_ie1_d1), 
     .RN(N10944), .SE(test_se), .SI(set_ie0_d2));
  NAND2X1 U50_C4_2 (.A(in_tcon[0]), .B(N8892), .Y(N11655));
  SDFFSRX1 tcon_reg_0_ (.CK(clk0_4), .D(N8934), .Q(out_tcon[0]), .QN(n26), 
     .RN(N10944), .SE(test_se), .SI(out_tcon[3]), .SN(VDD));
  INVX1 U51_C2_7_MP_INV (.A(N8935_2), .Y(N8935));
  SDFFRHQX1 set_ie0_d2_reg (.CK(clk0_4), .D(set_ie0_d1), .Q(set_ie0_d2), 
     .RN(N10944), .SE(test_se), .SI(set_ie0_d1));
  OAI21X1 U50_C4_1 (.A0(n26), .A1(N8892), .B0(N11655), .Y(N8934));
  NOR2X1 U34_C3_1 (.A(addr_tcon[4]), .B(addr_tcon[0]), .Y(N8892_1));
  NOR4BX1 U34_C3_6 (.AN(wr), .B(addr_tcon[2]), .C(addr_tcon[6]), 
     .D(addr_tcon[5]), .Y(N8892_6));
  SDFFSRX1 tcon_tf0_reg (.CK(clk0_4), .D(N8936), .Q(out_tcon[5]), .QN(n30), 
     .RN(N10944), .SE(test_se), .SI(out_tcon[6]), .SN(VDD));
endmodule

// Entity:tmod_test_1 Model:tmod_test_1 Library:L0
module tmod_test_1 (clk, rst_p, wr, in_tmod, addr_tmod, out_tmod, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_5, clk0_4);
  input clk, rst_p, wr, rc8051RtlTop_test_point_535_in, test_si, test_se, 
     clk0_5, clk0_4;
  output test_so;
  input [7:0] in_tmod;
  input [7:0] addr_tmod;
  output [7:0] out_tmod;
  wire n8, n9, n10, n11, n12, n13, n14, n15, N11370, N9003, N9006, N11333, 
     N12179, N9005, N10011, N10010, N8911, N8783, N7848, N10226, N12083, N12345, 
     N2038, N2276, N11482, N2352, N11370_1, N11370_4, N11370_6, addr_tmod_6_1;
  supply1 VDD;
  SDFFSRX1 out_tmod_reg_3_ (.CK(clk0_4), .D(N10011), .Q(out_tmod[3]), .QN(n11), 
     .RN(N9006), .SE(test_se), .SI(out_tmod[2]), .SN(VDD));
  OAI21X1 U29_C4_1 (.A0(n8), .A1(N11370), .B0(N10226), .Y(N10010));
  NAND2X1 U26_C4_2 (.A(in_tmod[3]), .B(N11370), .Y(N2352));
  OAI21X1 U25_C4_1 (.A0(n15), .A1(N11370), .B0(N2038), .Y(N9003));
  SDFFSRX1 out_tmod_reg_0_ (.CK(clk0_5), .D(N10010), .Q(out_tmod[0]), .QN(n8), 
     .RN(N9006), .SE(test_se), .SI(test_si), .SN(VDD));
  NAND2X1 U25_C4_2 (.A(in_tmod[7]), .B(N11370), .Y(N2038));
  SDFFSRX1 out_tmod_reg_4_ (.CK(clk0_4), .D(N9005), .Q(out_tmod[4]), .QN(n12), 
     .RN(N9006), .SE(test_se), .SI(out_tmod[3]), .SN(VDD));
  SDFFSRX1 out_tmod_reg_1_ (.CK(clk0_4), .D(N8783), .Q(out_tmod[1]), .QN(n9), 
     .RN(N9006), .SE(test_se), .SI(out_tmod[0]), .SN(VDD));
  NAND2X1 U29_C4_2 (.A(in_tmod[0]), .B(N11370), .Y(N10226));
  AND4X2 U16_C3_8 (.A(addr_tmod[0]), .B(N11370_6), .C(N11370_4), .D(N11370_1), 
     .Y(N11370));
  INVX1 U16_C3_6_MP_INV (.A(addr_tmod[6]), .Y(addr_tmod_6_1));
  AND4X1 U16_C3_6 (.A(wr), .B(addr_tmod[7]), .C(addr_tmod_6_1), .D(addr_tmod[3]), 
     .Y(N11370_6));
  SDFFSRX1 out_tmod_reg_7_ (.CK(clk0_4), .D(N9003), .Q(test_so), .QN(n15), 
     .RN(N9006), .SE(test_se), .SI(out_tmod[6]), .SN(VDD));
  NAND2X1 U28_C4_2 (.A(in_tmod[1]), .B(N11370), .Y(N12083));
  OAI21X1 U28_C4_1 (.A0(n9), .A1(N11370), .B0(N12083), .Y(N8783));
  SDFFSRX1 out_tmod_reg_6_ (.CK(clk0_4), .D(N11333), .Q(out_tmod[6]), .QN(n14), 
     .RN(N9006), .SE(test_se), .SI(out_tmod[5]), .SN(VDD));
  OAI21X1 U22_C4_1 (.A0(n12), .A1(N11370), .B0(N12345), .Y(N9005));
  BUFX1 BL1_ASSIGN_BUF165 (.A(test_so), .Y(out_tmod[7]));
  OAI21X1 U26_C4_1 (.A0(n11), .A1(N11370), .B0(N2352), .Y(N10011));
  NOR2X1 U16_C3_1 (.A(addr_tmod[5]), .B(addr_tmod[1]), .Y(N11370_1));
  NOR2X1 U16_C3_4 (.A(addr_tmod[4]), .B(addr_tmod[2]), .Y(N11370_4));
  OAI21X1 U24_C4_1 (.A0(n14), .A1(N11370), .B0(N7848), .Y(N11333));
  NAND2X1 U23_C4_2 (.A(in_tmod[5]), .B(N11370), .Y(N11482));
  INVX1 U30_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N9006));
  NAND2X1 U27_C4_2 (.A(in_tmod[2]), .B(N11370), .Y(N2276));
  OAI21X1 U27_C4_1 (.A0(n10), .A1(N11370), .B0(N2276), .Y(N8911));
  NAND2X1 U24_C4_2 (.A(in_tmod[6]), .B(N11370), .Y(N7848));
  SDFFSRX1 out_tmod_reg_5_ (.CK(clk0_4), .D(N12179), .Q(out_tmod[5]), .QN(n13), 
     .RN(N9006), .SE(test_se), .SI(out_tmod[4]), .SN(VDD));
  OAI21X1 U23_C4_1 (.A0(n13), .A1(N11370), .B0(N11482), .Y(N12179));
  NAND2X1 U22_C4_2 (.A(in_tmod[4]), .B(N11370), .Y(N12345));
  SDFFSRX1 out_tmod_reg_2_ (.CK(clk0_4), .D(N8911), .Q(out_tmod[2]), .QN(n10), 
     .RN(N9006), .SE(test_se), .SI(out_tmod[1]), .SN(VDD));
endmodule

// Entity:u_int_test_1 Model:u_int_test_1 Library:L0
module u_int_test_1 (disint, end_instr, ti_ri, clk, rst_p, ex_int_a, ex_int_b, 
     it_a, it_b, tf_a, tf_b, ie_j, ie, ip, ie_a, ie_b, smpl_ex_a, smpl_ex_b, 
     int_vec, reti, isrc_cur, en_int, rc8051RtlTop_test_mode_in, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_7, clk0_4);
  input disint, end_instr, ti_ri, clk, rst_p, ex_int_a, ex_int_b, it_a, it_b, 
     tf_a, tf_b, ie_j, ie_a, ie_b, reti, rc8051RtlTop_test_mode_in, 
     rc8051RtlTop_test_point_535_in, test_si, test_se, clk0_7, clk0_4;
  output smpl_ex_a, smpl_ex_b, en_int, test_so;
  input [4:0] ie;
  input [4:0] ip;
  output [2:0] int_vec;
  output [2:0] isrc_cur;
  wire \latch_int[0] , \latch_int[1] , \latch_int[2] , \latch_int[3] , 
     \latch_int[4] , \int[0] , \int[1] , \int[2] , \int[3] , \int[4] , s_oie_a, 
     s_oie_b, n11, n12, U35_C1__n, N11199, N11198, N11196, N11193, N5745, 
     N12055, U39_C1__n, N5630, N9999, N9998, N9997, N9996, N11173, U29_C3__n_2, 
     U29_C3__n_3, U35_C1__n_1, U35_C1__n_3, N11198_2;
  supply0 VSS;
  mux2t1_1_0 ux1 (.a(VSS), .b(s_oie_b), .sel(it_b), .c(smpl_ex_b));
  ex_int_smpl_0_test_1 smpl1 (.clk(), .ex_int(ex_int_b), .it(it_b), 
     .rst_p(rst_p), .lint(), .oie(s_oie_b), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si(n11), .test_so(test_so), .test_se(test_se), .clk0_4(clk0_4));
  ex_int_smpl_1_test_1 smpl0 (.clk(), .ex_int(ex_int_a), .it(it_a), 
     .rst_p(rst_p), .lint(), .oie(s_oie_a), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si(n12), .test_so(n11), .test_se(test_se), .clk0_4(clk0_4));
  priority_test_1 prio (.disint(disint), .ie({ie[4], ie[3], ie[2], ie[1], ie[0]}), 
     .reti(reti), .clk(), .rst_p(rst_p), .int({\int[4] , \int[3] , \int[2] , 
     \int[1] , \int[0] }), .ip({ip[4], ip[3], ip[2], ip[1], ip[0]}), .ie7(ie_j), 
     .int_vec({int_vec[2], int_vec[1], int_vec[0]}), .isrc_cur({isrc_cur[2], 
     isrc_cur[1], isrc_cur[0]}), .en_int(en_int), 
     .rc8051RtlTop_test_mode_in(rc8051RtlTop_test_mode_in), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si(test_si), .test_so(n12), .test_se(test_se), .clk0_4(clk0_4), 
     .clk0_7(clk0_7));
  mux2t1_1_1 ux0 (.a(VSS), .b(s_oie_a), .sel(it_a), .c(smpl_ex_a));
  TLATX1 latch_int_reg_0_ (.D(N11199), .G(N11198), .Q(\latch_int[0] ), .QN());
  AND2X1 U35_C1 (.A(ie_a), .B(U35_C1__n), .Y(N11199));
  NOR2X1 U29_C3_3 (.A(ti_ri), .B(ie_b), .Y(U29_C3__n_2));
  AND2X1 U34_C1 (.A(ie_b), .B(U35_C1__n), .Y(N11193));
  TLATX1 int_reg_4_ (.D(N11173), .G(N9999), .Q(\int[4] ), .QN());
  TLATNX1 latch_int_reg_4_ (.D(N12055), .GN(N11198_2), .Q(\latch_int[4] ), .QN());
  NOR2BX1 U24_C1 (.AN(end_instr), .B(rst_p), .Y(U39_C1__n));
  NAND3BX1 U29_C3_8 (.AN(reti), .B(U35_C1__n_1), .C(ie_j), .Y(U35_C1__n_3));
  NOR2BX1 U25_C1 (.AN(ti_ri), .B(U35_C1__n_3), .Y(N12055));
  AND2X1 U36_C1 (.A(\latch_int[4] ), .B(U39_C1__n), .Y(N11173));
  INVX1 U29_C3_8_MP_INV (.A(U35_C1__n_3), .Y(U35_C1__n));
  AOI21X1 U29_C3_6 (.A0(U29_C3__n_3), .A1(U29_C3__n_2), .B0(rst_p), 
     .Y(U35_C1__n_1));
  TLATX1 latch_int_reg_1_ (.D(N11196), .G(N11198), .Q(\latch_int[1] ), .QN());
  AND2X1 U33_C1 (.A(tf_b), .B(U35_C1__n), .Y(N5745));
  NOR3X1 U29_C3_4 (.A(tf_b), .B(tf_a), .C(ie_a), .Y(U29_C3__n_3));
  TLATX1 latch_int_reg_3_ (.D(N5745), .G(N11198), .Q(\latch_int[3] ), .QN());
  AND2X1 U32_C1 (.A(tf_a), .B(U35_C1__n), .Y(N11196));
  TLATX1 int_reg_0_ (.D(N9997), .G(N9999), .Q(\int[0] ), .QN());
  OR2X1 U27_C1 (.A(rst_p), .B(U39_C1__n), .Y(N9999));
  NOR3X1 U26_C2_2 (.A(rst_p), .B(reti), .C(U35_C1__n), .Y(N11198_2));
  INVX1 U26_C2_2_MP_INV (.A(N11198_2), .Y(N11198));
  AND2X1 U39_C1 (.A(\latch_int[1] ), .B(U39_C1__n), .Y(N5630));
  TLATX1 latch_int_reg_2_ (.D(N11193), .G(N11198), .Q(\latch_int[2] ), .QN());
  TLATX1 int_reg_1_ (.D(N5630), .G(N9999), .Q(\int[1] ), .QN());
  AND2X1 U38_C1 (.A(\latch_int[2] ), .B(U39_C1__n), .Y(N9996));
  TLATX1 int_reg_2_ (.D(N9996), .G(N9999), .Q(\int[2] ), .QN());
  AND2X1 U37_C1 (.A(\latch_int[3] ), .B(U39_C1__n), .Y(N9998));
  AND2X1 U40_C1 (.A(\latch_int[0] ), .B(U39_C1__n), .Y(N9997));
  TLATX1 int_reg_3_ (.D(N9998), .G(N9999), .Q(\int[3] ), .QN());
endmodule

// Entity:ex_int_smpl_0_test_1 Model:ex_int_smpl_0_test_1 Library:L0
module ex_int_smpl_0_test_1 (clk, ex_int, it, rst_p, lint, oie, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_4);
  input clk, ex_int, it, rst_p, rc8051RtlTop_test_point_535_in, test_si, 
     test_se, clk0_4;
  output lint, oie, test_so;
  wire n9, n10, n4, N11063, N5609, N12111;
  supply1 VDD;
  AND2X1 U11_C1 (.A(test_so), .B(n9), .Y(oie));
  INVX1 U17_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N5609));
  SDFFSRX1 tmp_reg (.CK(clk0_4), .D(N12111), .Q(test_so), .QN(n10), .RN(N5609), 
     .SE(test_se), .SI(n4), .SN(VDD));
  SDFFSRX1 tmp1_reg (.CK(clk0_4), .D(N11063), .Q(n4), .QN(n9), .RN(N5609), 
     .SE(test_se), .SI(test_si), .SN(VDD));
  MXI2X1 U15_C3_1 (.A(n10), .B(ex_int), .S0(it), .Y(N12111));
  MXI2X1 U14_C3_1 (.A(n9), .B(n10), .S0(it), .Y(N11063));
  XNOR2X1 U12_C1 (.A(it), .B(ex_int), .Y(lint));
endmodule

// Entity:ex_int_smpl_1_test_1 Model:ex_int_smpl_1_test_1 Library:L0
module ex_int_smpl_1_test_1 (clk, ex_int, it, rst_p, lint, oie, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_4);
  input clk, ex_int, it, rst_p, rc8051RtlTop_test_point_535_in, test_si, 
     test_se, clk0_4;
  output lint, oie, test_so;
  wire n9, n10, n4, N11172, N11171, N5749;
  supply1 VDD;
  SDFFSRX1 tmp1_reg (.CK(clk0_4), .D(N11172), .Q(n4), .QN(n9), .RN(N11171), 
     .SE(test_se), .SI(test_si), .SN(VDD));
  INVX1 U17_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N11171));
  SDFFSRX1 tmp_reg (.CK(clk0_4), .D(N5749), .Q(test_so), .QN(n10), .RN(N11171), 
     .SE(test_se), .SI(n4), .SN(VDD));
  MXI2X1 U14_C3_1 (.A(n9), .B(n10), .S0(it), .Y(N11172));
  AND2X1 U11_C1 (.A(test_so), .B(n9), .Y(oie));
  XNOR2X1 U12_C1 (.A(it), .B(ex_int), .Y(lint));
  MXI2X1 U15_C3_1 (.A(n10), .B(ex_int), .S0(it), .Y(N5749));
endmodule

// Entity:mux2t1_1_0 Model:mux2t1_1_0 Library:L0
module mux2t1_1_0 (a, b, sel, c);
  input a, b, sel;
  output c;
  MX2X1 U9_C1_1 (.A(a), .B(b), .S0(sel), .Y(c));
endmodule

// Entity:mux2t1_1_1 Model:mux2t1_1_1 Library:L0
module mux2t1_1_1 (a, b, sel, c);
  input a, b, sel;
  output c;
  MX2X1 U9_C1_1 (.A(a), .B(b), .S0(sel), .Y(c));
endmodule

// Entity:priority_test_1 Model:priority_test_1 Library:L0
module priority_test_1 (disint, ie, reti, clk, rst_p, int, ip, ie7, int_vec, 
     isrc_cur, en_int, rc8051RtlTop_test_mode_in, 
     rc8051RtlTop_test_point_535_in, test_si, test_so, test_se, clk0_4, clk0_7);
  input disint, reti, clk, rst_p, ie7, rc8051RtlTop_test_mode_in, 
     rc8051RtlTop_test_point_535_in, test_si, test_se, clk0_4, clk0_7;
  output en_int, test_so;
  input [4:0] ie;
  input [4:0] int;
  input [4:0] ip;
  output [2:0] int_vec;
  output [2:0] isrc_cur;
  wire \cur_lev[0] , \cur_lev[1] , int_proc, isrc, isrc0, isrc1, isrc2, isrc3, 
     isrc4, N9, N10, N11, int_dept_1_, int_lev, int_lev0, int_lev1, int_lev2, 
     reti1, N51, n79, n80, n81, n82, n83, n84, n101, n102, n103, n1040, n105, 
     N11644, N7921, U127_C1__n, U127_C1__n_1, N10228, N11345, N11344, N7920, 
     N7952, N11582, N11581, N12110, U113_C1__n, U143_C3__n, U104_C1__n, 
     U104_C1__n_1, U108_C1__n, N5763, N5664, N5663, N11634, N11633, N11632, 
     N11631, N10261, N11733, N11732, N11731, N5298, N11780, N11779, N11778, 
     N11777, N5748, N10733, N5617, N5618, N10716, N10714, N10736, N10734, N5752, 
     N10566, N10565, N5600, N11830, N1815, N11252, N5417, N6971, N8526, N10463, 
     N7568, N11072, N11538, N539, N7952_1, U104_C1__n_2, N11631_1, N11344_2, 
     ip_1_1, reti1_1, N12110_2, cur_lev_1_1, N11345_1, U127_C1__n_2, N11733_1, 
     U104_C1__n_3, U104_C1__n_4, N5664_2, N10736_1, N10716_1, N10714_1, 
     N10261_1, N10463_1, U147_C3__n_3, U108_C1__n_1;
  supply1 VDD;
  supply0 VSS;
  priority_MUX_OP_2_1_5 U16 (.D0_0(int_lev1), .D0_1(int_lev2), .D0_2(isrc2), 
     .D0_3(isrc3), .D0_4(isrc4), .D1_0(int_lev), .D1_1(int_lev0), .D1_2(isrc), 
     .D1_3(isrc0), .D1_4(isrc1), .S0(n103), .Z_0(\cur_lev[1] ), 
     .Z_1(\cur_lev[0] ), .Z_2(N9), .Z_3(N10), .Z_4(N11));
  one_shot_0_test_1 one_shot_reti (.rst_p(rst_p), .clk(), .d(reti), .q(reti1), 
     .rc8051RtlTop_test_point_535_in(rc8051RtlTop_test_point_535_in), 
     .test_si(isrc1), .test_so(test_so), .test_se(test_se), .clk0_4(clk0_4));
  XOR2X1 U156_C1 (.A(int_dept_1_), .B(n103), .Y(N5617));
  OAI2BB1X1 U149_C3_1 (.A0N(int_vec[0]), .A1N(N5663), .B0(N11634), .Y(N11633));
  SDFFSRX1 isrc_reg (.CK(clk0_7), .D(N10733), .Q(isrc2), .QN(n81), .RN(N11632), 
     .SE(test_se), .SI(int_vec[2]), .SN(VDD));
  OAI22X1 U142_C3_1 (.A0(N51), .A1(N11733), .B0(n81), .B1(N11778), .Y(N10733));
  SDFFRHQX1 int_vec_reg_2_ (.CK(clk0_7), .D(N11732), .Q(int_vec[2]), .RN(N11632), 
     .SE(test_se), .SI(int_vec[1]));
  AOI21X1 U150_C3_1 (.A0(int_vec[1]), .A1(N5663), .B0(N11631), .Y(N10261_1));
  OAI2BB1X1 U151_C3_1 (.A0N(int_vec[2]), .A1N(N5663), .B0(N11733), .Y(N11732));
  INVX1 U150_C3_1_MP_INV (.A(N10261_1), .Y(N10261));
  SDFFRHQX1 int_vec_reg_1_ (.CK(clk0_7), .D(N10261), .Q(int_vec[1]), .RN(N11632), 
     .SE(test_se), .SI(int_vec[0]));
  AOI32X1 U175_C1_6 (.A0(ip[4]), .A1(int[4]), .A2(ie[4]), .B0(ip[3]), 
     .B1(N11345_1), .Y(N7952_1));
  NAND2X1 U165_C1 (.A(int[3]), .B(ie[3]), .Y(N11345));
  NAND3BX1 U179_C3_5 (.AN(ip[4]), .B(ie[4]), .C(int[4]), .Y(N11538));
  INVX1 U175_C1_6_MP_INV (.A(N11345), .Y(N11345_1));
  NAND2BX1 U124_C4_11 (.AN(N11344), .B(N5763), .Y(N539));
  OAI2BB1X1 U124_C4_6 (.A0N(ip_1_1), .A1N(N11644), .B0(N8526), .Y(N5763));
  AOI33X1 U116_C5_1 (.A0(U104_C1__n), .A1(N11581), .A2(N11344_2), 
     .B0(U127_C1__n_1), .B1(U127_C1__n_2), .B2(U104_C1__n_1), .Y(N11631_1));
  OAI2BB1X1 U128_C2_1 (.A0N(ip_1_1), .A1N(N11644), .B0(N7920), .Y(N11581));
  OAI221X1 U132_C4_5 (.A0(N11345_1), .A1(N10228), .B0(N7921), .B1(N11644), 
     .C0(U127_C1__n_2), .Y(N5664));
  INVX1 U128_C2_1_MP_INV (.A(ip[1]), .Y(ip_1_1));
  INVX1 U170_C2_2_MP_INV (.A(N11344_2), .Y(N11344));
  OAI211X1 U179_C3_7 (.A0(ip[3]), .A1(N11345), .B0(N11538), .C0(N11344_2), 
     .Y(N11582));
  NAND3X1 U167_C2_2 (.A(ip[2]), .B(int[2]), .C(ie[2]), .Y(N7921));
  NAND3BX1 U171_C2_2 (.AN(ip[2]), .B(ie[2]), .C(int[2]), .Y(N7920));
  NAND3BX1 U124_C4_13 (.AN(ip[3]), .B(N11345_1), .C(N7920), .Y(N8526));
  NOR2BX1 U186_C1 (.AN(N11), .B(n101), .Y(isrc_cur[0]));
  SDFFSRX1 int_dept_reg_1_ (.CK(clk0_4), .D(N10716), .Q(int_dept_1_), .QN(n102), 
     .RN(N11632), .SE(test_se), .SI(N51), .SN(VDD));
  OAI2BB1X1 U158_C3_4 (.A0N(N51), .A1N(U143_C3__n), .B0(U108_C1__n_1), 
     .Y(N11830));
  AOI21X1 U153_C5_4 (.A0(n103), .A1(U104_C1__n), .B0(n1040), .Y(N5417));
  SDFFSRX2 int_dept_reg_0_ (.CK(clk0_4), .D(N5752), .Q(N51), .QN(n103), 
     .RN(N11632), .SE(test_se), .SI(test_si), .SN(VDD));
  OAI211X1 U158_C3_9 (.A0(reti1_1), .A1(N51), .B0(N1815), .C0(N11830), .Y(N5752));
  INVX1 U158_C3_4_MP_INV (.A(U108_C1__n), .Y(U108_C1__n_1));
  OAI2BB1X1 U154_C3_7 (.A0N(reti1), .A1N(N5617), .B0(N10716_1), .Y(N10716));
  AOI32X1 U154_C3_4 (.A0(reti1_1), .A1(int_dept_1_), .A2(U108_C1__n), 
     .B0(U104_C1__n_1), .B1(N5618), .Y(N10716_1));
  INVX1 U121_C4_2_MP_INV_2 (.A(U104_C1__n_1), .Y(U104_C1__n_4));
  NOR2X1 U112_C1 (.A(reti1), .B(U113_C1__n), .Y(U104_C1__n_1));
  AND2X1 U166_C1 (.A(int[1]), .B(ie[1]), .Y(N11644));
  OAI2BB1X1 U169_C3_1 (.A0N(ip[1]), .A1N(N11644), .B0(N7921), .Y(U127_C1__n_1));
  AOI2BB1X1 U143_C3_2 (.A0N(N11582), .A1N(N11581), .B0(U143_C3__n), 
     .Y(U104_C1__n_2));
  AOI21X1 U152_C5_2 (.A0(N51), .A1(U104_C1__n_1), .B0(N7568), .Y(N10714_1));
  AND3X1 U143_C3_4 (.A(n101), .B(ie7), .C(U104_C1__n_2), .Y(U104_C1__n));
  INVX1 U153_C5_2_MP_INV (.A(N10736_1), .Y(N10736));
  NOR2X1 U147_C3_5 (.A(N11582), .B(N11581), .Y(N10463_1));
  NOR2X1 U104_C1 (.A(U104_C1__n_1), .B(U104_C1__n), .Y(U108_C1__n));
  NAND2BX1 U163_C1_2 (.AN(N6971), .B(U108_C1__n), .Y(N10734));
  AOI21X1 U152_C5_4 (.A0(U104_C1__n), .A1(N51), .B0(n105), .Y(N7568));
  AOI21X1 U153_C5_2 (.A0(U104_C1__n_1), .A1(n103), .B0(N5417), .Y(N10736_1));
  INVX1 U113_C1_MP_INV (.A(reti1), .Y(reti1_1));
  XOR2X1 U157_C1 (.A(int_dept_1_), .B(N51), .Y(N5618));
  NAND2X1 U113_C1 (.A(reti1_1), .B(U113_C1__n), .Y(U143_C3__n));
  NAND3BX1 U170_C2_2 (.AN(ip[0]), .B(ie[0]), .C(int[0]), .Y(N11344_2));
  INVX1 U124_C4_15_MP_INV (.A(N5664), .Y(N5664_2));
  NAND2BX1 U175_C1_7 (.AN(N10228), .B(N7952_1), .Y(N7952));
  INVX1 U116_C5_1_MP_INV_1 (.A(U127_C1__n), .Y(U127_C1__n_2));
  AOI22X1 U124_C4_5 (.A0(U104_C1__n), .A1(N539), .B0(U104_C1__n_1), .B1(N11072), 
     .Y(N11634));
  INVX1 U152_C5_2_MP_INV (.A(N10714_1), .Y(N10714));
  SDFFSRX1 int_lev_reg (.CK(clk0_4), .D(N10736), .Q(int_lev2), .QN(n1040), 
     .RN(N11632), .SE(test_se), .SI(int_dept_1_), .SN(VDD));
  OAI32X1 U121_C4_2 (.A0(U104_C1__n_3), .A1(N11581), .A2(N11344), 
     .B0(U104_C1__n_4), .B1(N10228), .Y(N11733_1));
  INVX1 U121_C4_2_MP_INV_1 (.A(U104_C1__n), .Y(U104_C1__n_3));
  NAND3X1 U158_C3_7 (.A(reti1_1), .B(U108_C1__n), .C(N51), .Y(N1815));
  AOI31X1 U163_C1_3 (.A0(reti1), .A1(n102), .A2(N51), .B0(n101), .Y(N6971));
  NAND2X1 U147_C3_6 (.A(n101), .B(N10463_1), .Y(N10463));
  NOR2X1 U111_C1 (.A(n103), .B(U108_C1__n), .Y(N11731));
  INVX1 U144_C3_4_MP_INV (.A(\cur_lev[1] ), .Y(cur_lev_1_1));
  NOR2BX1 U161_C1 (.AN(int_lev1), .B(N11778), .Y(N5600));
  OAI21X1 U137_C3_1 (.A0(n80), .A1(N11778), .B0(N11252), .Y(N5748));
  NAND3BX1 U144_C3_4 (.AN(\cur_lev[0] ), .B(ie7), .C(cur_lev_1_1), .Y(N12110));
  OAI2BB2X1 U141_C3_1 (.A0N(N51), .A1N(N11733_1), .B0(n84), .B1(N11731), 
     .Y(N11779));
  INVX1 U116_C5_1_MP_INV (.A(N11631_1), .Y(N11631));
  NOR2BX1 U188_C1 (.AN(N9), .B(n101), .Y(isrc_cur[2]));
  NOR2BX1 U187_C1 (.AN(N10), .B(n101), .Y(isrc_cur[1]));
  INVX1 U190_C1 (.A(rst_p), .Y(N10565));
  XNOR2X2 \test_point_533/U6_C4  (.A(rst_p), .B(rc8051RtlTop_test_mode_in), 
     .Y(N11632));
  AND3X1 U182_C2_2 (.A(ip[0]), .B(int[0]), .C(ie[0]), .Y(U127_C1__n));
  INVX1 U121_C4_2_MP_INV (.A(N11733_1), .Y(N11733));
  SDFFSRX1 int_proc_reg (.CK(clk0_7), .D(N10734), .Q(int_proc), .QN(n101), 
     .RN(N11632), .SE(test_se), .SI(int_lev0), .SN(VDD));
  SDFFRX1 int_lev_reg2 (.CK(clk0_7), .D(N10566), .Q(int_lev), .QN(), .RN(N10565), 
     .SE(VSS), .SI(int_lev));
  MXI2X1 U139_C3_1 (.A(n83), .B(N11631_1), .S0(N11731), .Y(N11780));
  AND2X1 U108_C1 (.A(U143_C3__n), .B(U108_C1__n), .Y(N5663));
  SDFFRX1 int_lev_reg1 (.CK(clk0_7), .D(N5600), .Q(int_lev1), .QN(), .RN(N10565), 
     .SE(VSS), .SI(int_lev1));
  NAND2X1 U137_C3_3 (.A(N11778), .B(N11631), .Y(N11252));
  MXI2X1 U138_C3_1 (.A(n79), .B(N11634), .S0(N11778), .Y(N11777));
  MXI2X1 U140_C3_1 (.A(n82), .B(N11634), .S0(N11731), .Y(N5298));
  SDFFRHQX1 int_vec_reg_0_ (.CK(clk0_7), .D(N11633), .Q(int_vec[0]), .RN(N11632), 
     .SE(test_se), .SI(int_proc));
  NOR2X1 U136_C1 (.A(U108_C1__n), .B(N51), .Y(N11778));
  NOR2BX1 U162_C1 (.AN(int_lev), .B(N11731), .Y(N10566));
  SDFFSRX1 int_lev_reg0 (.CK(clk0_7), .D(N10714), .Q(int_lev0), .QN(n105), 
     .RN(N11632), .SE(test_se), .SI(int_lev2), .SN(VDD));
  OR2X1 U127_C1 (.A(U127_C1__n_1), .B(U127_C1__n), .Y(N10228));
  INVX1 U144_C3_2_MP_INV (.A(N12110), .Y(N12110_2));
  OAI31X1 U144_C3_2 (.A0(n101), .A1(en_int), .A2(N12110_2), .B0(N7952), 
     .Y(U113_C1__n));
  OAI221X1 U124_C4_15 (.A0(ip[1]), .A1(N7921), .B0(ip[3]), .B1(N10228), 
     .C0(N5664_2), .Y(N11072));
  NOR3BX1 U147_C3_10 (.AN(ie7), .B(U147_C3__n_3), .C(disint), .Y(en_int));
  OAI211X1 U147_C3_9 (.A0(n101), .A1(N7952), .B0(N10565), .C0(N10463), 
     .Y(U147_C3__n_3));
  SDFFSRX1 isrc_reg1 (.CK(clk0_7), .D(N11777), .Q(isrc4), .QN(n79), .RN(N11632), 
     .SE(test_se), .SI(isrc3), .SN(VDD));
  SDFFSRX1 isrc_reg2 (.CK(clk0_7), .D(N11779), .Q(isrc), .QN(n84), .RN(N11632), 
     .SE(test_se), .SI(isrc4), .SN(VDD));
  SDFFSRX1 isrc_reg0 (.CK(clk0_7), .D(N5748), .Q(isrc3), .QN(n80), .RN(N11632), 
     .SE(test_se), .SI(isrc2), .SN(VDD));
  SDFFSRX1 isrc_reg4 (.CK(clk0_7), .D(N5298), .Q(isrc1), .QN(n82), .RN(N11632), 
     .SE(test_se), .SI(isrc0), .SN(VDD));
  SDFFSRX1 isrc_reg3 (.CK(clk0_7), .D(N11780), .Q(isrc0), .QN(n83), .RN(N11632), 
     .SE(test_se), .SI(isrc), .SN(VDD));
endmodule

// Entity:one_shot_0_test_1 Model:one_shot_0_test_1 Library:L0
module one_shot_0_test_1 (rst_p, clk, d, q, rc8051RtlTop_test_point_535_in, 
     test_si, test_so, test_se, clk0_4);
  input rst_p, clk, d, rc8051RtlTop_test_point_535_in, test_si, test_se, clk0_4;
  output q, test_so;
  wire N9968, N9967;
  SDFFSX1 d_del_reg (.CK(clk0_4), .D(N9968), .Q(test_so), .QN(), .SE(test_se), 
     .SI(test_si), .SN(N9967));
  NOR2BX1 U7_C1 (.AN(test_so), .B(N9968), .Y(q));
  INVX1 U8_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N9967));
  INVX1 U6_C1 (.A(d), .Y(N9968));
endmodule

// Entity:priority_MUX_OP_2_1_5 Model:priority_MUX_OP_2_1_5 Library:L0
module priority_MUX_OP_2_1_5 (D0_0, D0_1, D0_2, D0_3, D0_4, D1_0, D1_1, D1_2, 
     D1_3, D1_4, S0, Z_0, Z_1, Z_2, Z_3, Z_4);
  input D0_0, D0_1, D0_2, D0_3, D0_4, D1_0, D1_1, D1_2, D1_3, D1_4, S0;
  output Z_0, Z_1, Z_2, Z_3, Z_4;
  MX2X1 U8_C4_1 (.A(D0_4), .B(D1_4), .S0(S0), .Y(Z_4));
  MX2X1 U6_C4_1 (.A(D0_0), .B(D1_0), .S0(S0), .Y(Z_0));
  MX2X1 U7_C4_1 (.A(D0_1), .B(D1_1), .S0(S0), .Y(Z_1));
  MX2X1 U9_C4_1 (.A(D0_3), .B(D1_3), .S0(S0), .Y(Z_3));
  MX2X1 U10_C4_1 (.A(D0_2), .B(D1_2), .S0(S0), .Y(Z_2));
endmodule

// Entity:u_tc_test_1 Model:u_tc_test_1 Library:L0
module u_tc_test_1 (clk, rst_p, wr, in_tc, addr_tc, t0_pin, t1_pin, int0_pin, 
     int1_pin, sel_tc0, sel_tc1, gate0, gate1, tr0, tr1, tm0, tm1, tf0, tf1, 
     tl0, tl1, th0, th1, shift12, rc8051RtlTop_test_point_535_in, test_si1, 
     test_so1, test_si2, test_so2, test_se, clk0_3, clk0_26);
  input clk, rst_p, wr, t0_pin, t1_pin, int0_pin, int1_pin, sel_tc0, sel_tc1, 
     gate0, gate1, tr0, tr1, rc8051RtlTop_test_point_535_in, test_si1, test_si2, 
     test_se, clk0_3, clk0_26;
  output tf0, tf1, shift12, test_so1, test_so2;
  input [7:0] in_tc;
  input [7:0] addr_tc;
  input [1:0] tm0;
  input [1:0] tm1;
  output [7:0] tl0;
  output [7:0] tl1;
  output [7:0] th0;
  output [7:0] th1;
  wire \div12[0] , \div12[1] , \div12[2] , \div12[3] , t0_pin_r, tf1_0, tf1_1, 
     N242, N243, N244, N245, N246, N247, N248, N249, N250, N251, N252, N253, 
     N254, N255, N256, N257, N258, N259, N260, N261, N262, N263, N264, N265, 
     N266, N267, N268, N269, N270, N271, N272, N273, N274, N275, N276, N277, 
     N278, N279, N280, N281, N282, N283, N284, N285, N286, N287, N288, N289, 
     N290, N291, N292, N293, N294, N295, N296, N297, N298, N299, N300, N301, 
     N302, N303, N312, N322, N323, N324, N325, N326, N327, N328, N329, N330, 
     N331, N332, N333, N334, N335, N336, N337, n218, n2590, n2600, n2610, n2620, 
     n2630, n2640, n2650, n2660, n2670, n2680, n2690, n2700, n2710, n2720, 
     n2730, n2740, n2750, n2760, n2770, n2790, n2800, n2810, n2820, n2830, 
     n2840, n2850, n2860, n2870, n2880, n2890, n2900, n2910, n2920, n2930, 
     n2940, n2950, n306, n9, U428_C1__n, N10009, U426_C1__n, U426_C1__n_1, 
     N8912, N8782, U275_C3__n, U252_C3__n, U258_C1__n, U259_C1__n, U259_C1__n_1, 
     U397_C2__n, U311_C3__n, U311_C3__n_1, N11816, U273_C1__n, U273_C1__n_1, 
     N11092, N11794, N8813, U256_C1__n, U256_C1__n_1, U319_C1__n, U319_C1__n_1, 
     N10960, N10959, U277_C1__n, N8880, N11617, N11616, N11615, N8876, 
     U313_C3__n, U266_C1__n, U418_C1__n, U250_C2__n, N11472, N11471, N11514, 
     N11513, N11512, U429_C1__n, N10161, N10160, U253_C2__n, N8879, N10977, 
     N8877, N10247, N10246, U312_C2__n, N8913, N10859, N10827, N8885, N12173, 
     N10881, N8805, N8804, N8818, N11248, N11247, N8819, N10196, N10553, N8873, 
     U330_C3__n, U283_C1__n, N8723, N8872, N9960, N9535, N8875, N10601, N10600, 
     N8725, N8900, N11475, N8720, N8902, N10883, N10882, N8722, N9018, N8899, 
     N10249, N10248, N8874, N12256, N8836, N12255, N8724, N9015, N8919, N8920, 
     N8787, N11761, N11760, N11680, N11679, N11678, N8909, N12339, N12338, 
     N11014, N6344, N11821, N2479, N9730, N10389, N1314, N5404, N7756, N5185, 
     N1555, N4147, N6477, N7863, N11038, N10055, N5429, N6953, N12068, N11051, 
     N6540, N10326, N6476, N11494, N4840, N4831, N10058, N1713, N1862, N1605, 
     N1700, N10701, N2158, N1600, N10792, N11405, N1447, N12036, N12086, N11170, 
     N11586, N10750, N10748, N2850, N12009, N2873, N10853, N11537, N11347, 
     N11226, N9748, N9754, N9497, N9499, N7757, U411_C5__n_4, U411_C5__n_5, 
     U411_C5__n_6, U335_C1__n_2, U318_C1__n_1, N8788_1, N8788_2, addr_tc_2_1, 
     U311_C3__n_4, U259_C1__n_4, U259_C1__n_5, U397_C2__n_1, U318_C1__n_4, 
     U250_C2__n_2, U250_C2__n_3, U313_C3__n_2, N12256_1, N12256_2, tm0_1_1, 
     N8874_1, N10960_1, N12174_1, N10959_1, U256_C1__n_2, U256_C1__n_3, 
     U319_C1__n_2, tr1_1, U312_C2__n_1, N11680_1, N11680_2, N11471_1, 
     U266_C1__n_1, N11472_1, N11249_1, N8879_1, U273_C1__n_4, N9007_1, N11015_1, 
     N11794_1, N10978_1, N10883_1, N10883_2, N8902_1, N8884_1, N10860_1, 
     N8886_1, N10600_1, N10600_2, N8817_1, N8757_1, N8807_1, N8819_1, N9535_1, 
     N9535_2, N9960_1, N9018_1, N9018_2, N8918_1, N8909_1, N8909_2, N9016_1, 
     N9016_2, N9017_1, N9017_2, N10826_1, N10976_1, N10552_1, N10197_1, N8809_1, 
     N11092_1, N10880_1, N10879_1, N8910_1, N8724_1, N8724_2, N11474_1, 
     in_tc_6_1, in_tc_7_1, in_tc_5_1, in_tc_3_1, in_tc_4_1, in_tc_2_1, 
     in_tc_1_1, addr_tc_0_1, addr_tc_1_1, addr_tc_2_2, test_se_1, N8913_1, 
     test_se_2, U431_C1__n;
  supply1 VDD;
  supply0 VSS;
  AOI22X1 U405_C3_6 (.A0(int0_pin), .A1(gate0), .B0(sel_tc0), .B1(N8876), 
     .Y(U313_C3__n_2));
  AOI22X1 U355_C1_10 (.A0(N9960), .A1(N8872), .B0(tl0[5]), .B1(U283_C1__n), 
     .Y(N9535_1));
  INVX1 U355_C1_2_MP_INV (.A(N9960_1), .Y(N9960));
  u_tc_DW01_inc_14_1 add_184 (.A({VSS, th1[7], test_so1, th1[5], th1[4], th1[3], 
     th1[2], th1[1], th1[0], tl1[4], tl1[3], tl1[2], tl1[1], tl1[0]}), .SUM({N255, 
     N254, N253, N252, N251, N250, N249, N248, N247, N246, N245, N244, N243, 
     N242}));
  u_tc_DW01_inc_17_0 add_137 (.A({VSS, th0[7], th0[6], th0[5], th0[4], th0[3], 
     th0[2], th0[1], th0[0], tl0[7], tl0[6], tl0[5], tl0[4], tl0[3], tl0[2], 
     tl0[1], tl0[0]}), .SUM({N303, N302, N301, N300, N299, N298, N297, N296, N295, 
     N294, N293, N292, N291, N290, N289, N288, N287}));
  SDFFSRX1 tl1_reg_0_ (.CK(clk0_3), .D(N8787), .Q(tl1[0]), .QN(n2630), 
     .RN(N8782), .SE(test_se_2), .SI(tl0[7]), .SN(VDD));
  OAI211X1 U368_C4_13 (.A0(n2870), .A1(U312_C2__n), .B0(N11537), .C0(N10853), 
     .Y(N8885));
  AOI22X1 U399_C5_7 (.A0(N286), .A1(N10959), .B0(N312), .B1(N11617), .Y(N11513));
  OAI211X1 U363_C4_13 (.A0(n2820), .A1(U312_C2__n), .B0(N1447), .C0(N11405), 
     .Y(N8818));
  INVX1 U256_C1_MP_INV (.A(U256_C1__n_1), .Y(U256_C1__n_2));
  OAI2BB1X1 U378_C4_9 (.A0N(N8884_1), .A1N(N11051), .B0(U312_C2__n), .Y(N10748));
  NAND2X1 U139_C4_4 (.A(U256_C1__n), .B(N10246), .Y(N6344));
  XNOR2X1 U430_C1 (.A(\div12[2] ), .B(U428_C1__n), .Y(U429_C1__n));
  XNOR2X1 U427_C1 (.A(n2810), .B(N10009), .Y(U426_C1__n));
  OAI211X1 U374_C4_13 (.A0(n2830), .A1(U312_C2__n), .B0(N9499), .C0(N9497), 
     .Y(N8804));
  NAND2X1 U309_C3_3 (.A(in_tc_1_1), .B(U259_C1__n_5), .Y(N6476));
  OAI2BB1X1 U284_C3_8 (.A0N(N9730), .A1N(N8817_1), .B0(N8879_1), .Y(N1700));
  OAI2BB1X1 U286_C3_8 (.A0N(N9007_1), .A1N(N4147), .B0(N8879_1), .Y(N10058));
  AOI22X1 U288_C3_9 (.A0(U273_C1__n_4), .A1(N247), .B0(U311_C3__n_1), .B1(N264), 
     .Y(N10552_1));
  AOI222X1 U298_C5_6 (.A0(U311_C3__n_1), .A1(N258), .B0(in_tc_2_1), 
     .B1(U259_C1__n_1), .C0(th1[2]), .C1(N11092), .Y(N12338));
  MX2X1 U304_C3_6 (.A(N8819), .B(th1[3]), .S0(N8879), .Y(N10196));
  AOI222X1 U307_C5_6 (.A0(U311_C3__n_1), .A1(N259), .B0(in_tc_3_1), 
     .B1(U259_C1__n_1), .C0(th1[3]), .C1(N11092), .Y(N10249));
  OAI21X1 U286_C3_6 (.A0(n2790), .A1(N8879_1), .B0(N10058), .Y(N11247));
  OAI21X1 U309_C3_6 (.A0(n2800), .A1(N8879_1), .B0(N2850), .Y(N11248));
  AND4X1 U424_C3_3 (.A(n306), .B(\div12[3] ), .C(\div12[1] ), .D(\div12[0] ), 
     .Y(U426_C1__n_1));
  NOR2BX1 U433_C1 (.AN(n2940), .B(U426_C1__n_1), .Y(N10160));
  OAI21X1 U305_C3_2 (.A0(n2670), .A1(N11794_1), .B0(N6477), .Y(N10248));
  NAND2X1 U259_C1 (.A(U259_C1__n_4), .B(U259_C1__n), .Y(U397_C2__n));
  OR2X1 U264_C1_1 (.A(addr_tc_0_1), .B(U258_C1__n), .Y(U256_C1__n));
  OAI21X1 U288_C3_6 (.A0(n2760), .A1(N8879_1), .B0(N11170), .Y(N8873));
  OAI21X1 U344_C3_2 (.A0(n2900), .A1(N8879_1), .B0(N11038), .Y(N10247));
  SDFFSRX4 tl0_reg_0_ (.CK(clk0_3), .D(N8724), .Q(tl0[0]), .QN(n2650), 
     .RN(N8782), .SE(test_se_2), .SI(th1[7]), .SN(VDD));
  OAI32X1 U139_C4_1 (.A0(tr1_1), .A1(n2710), .A2(U277_C1__n), .B0(U313_C3__n), 
     .B1(N10960_1), .Y(N10246));
  NAND2X1 U365_C4_10 (.A(N11680_2), .B(N11680_1), .Y(N11680));
  SDFFSRX2 tl0_reg_1_ (.CK(clk0_3), .D(N10600), .Q(tl0[1]), .QN(n2740), 
     .RN(N8782), .SE(test_se_2), .SI(tl0[0]), .SN(VDD));
  OAI211X1 U376_C4_13 (.A0(n2840), .A1(U312_C2__n), .B0(N1862), .C0(N1605), 
     .Y(N8805));
  OAI211X1 U380_C4_13 (.A0(n2860), .A1(U312_C2__n), .B0(N1600), .C0(N10792), 
     .Y(N12173));
  OAI2BB1X1 U368_C4_9 (.A0N(N5429), .A1N(N10826_1), .B0(U312_C2__n), .Y(N11537));
  OAI2BB1X1 U309_C3_8 (.A0N(N6476), .A1N(N11249_1), .B0(N8879_1), .Y(N2850));
  SDFFSRX1 th1_reg_0_ (.CK(clk0_26), .D(N8873), .Q(th1[0]), .QN(n2760), 
     .RN(N8782), .SE(test_se_2), .SI(th0[7]), .SN(VDD));
  SDFFSRX2 tl0_reg_7_ (.CK(clk0_3), .D(N10883), .Q(tl0[7]), .QN(n2700), 
     .RN(N8782), .SE(test_se_2), .SI(tl0[6]), .SN(VDD));
  AOI22X1 U392_C5_1 (.A0(N330), .A1(N8723), .B0(U319_C1__n), .B1(N273), 
     .Y(N8836));
  AOI22X1 U389_C5_1 (.A0(N331), .A1(N8723), .B0(U319_C1__n), .B1(N274), 
     .Y(N8875));
  NAND3BX1 U397_C2_2 (.AN(tm1[0]), .B(tm1[1]), .C(U397_C2__n_1), .Y(U311_C3__n));
  SDFFSRX1 th1_reg_7_ (.CK(clk0_3), .D(N10977), .Q(th1[7]), .QN(n2920), 
     .RN(N8782), .SE(test_se_2), .SI(test_si2), .SN(VDD));
  OAI21X1 U354_C3_2 (.A0(n2920), .A1(N8879_1), .B0(N12068), .Y(N10977));
  BUFX1 BL1_BUF370 (.A(addr_tc[2]), .Y(addr_tc_2_2));
  NAND4X1 U275_C3_6 (.A(wr), .B(addr_tc[7]), .C(addr_tc[3]), .D(U275_C3__n), 
     .Y(U252_C3__n));
  BUFX1 BL1_ASSIGN_BUF166 (.A(test_so2), .Y(tl1[7]));
  BUFX1 BL1_BUF188 (.A(in_tc[6]), .Y(in_tc_6_1));
  AOI22X1 U403_C4_7 (.A0(U273_C1__n_4), .A1(N255), .B0(U311_C3__n_1), .B1(N272), 
     .Y(N8809_1));
  NAND2BX1 U405_C3 (.AN(t0_pin), .B(t0_pin_r), .Y(N8876));
  AOI22X1 U376_C4_10 (.A0(N281), .A1(N10959), .B0(N333), .B1(N11617), 
     .Y(N10880_1));
  AOI22X1 U391_C4_9 (.A0(N12255), .A1(N11471_1), .B0(th0[0]), .B1(N11472), 
     .Y(N8724_1));
  AOI22X1 U385_C4_10 (.A0(in_tc_2_1), .A1(U256_C1__n_3), .B0(tl0[2]), 
     .B1(U266_C1__n), .Y(N8909_2));
  NOR2X1 U330_C3_1 (.A(U330_C3__n), .B(U256_C1__n_3), .Y(U283_C1__n));
  NAND3X1 U325_C5_5 (.A(N312), .B(N8880), .C(N11617), .Y(N11226));
  NAND3X1 U405_C3_8 (.A(tr0), .B(U313_C3__n_2), .C(N2158), .Y(U313_C3__n));
  AOI22X1 U359_C1_9 (.A0(N8902), .A1(N8872), .B0(tl0[7]), .B1(U283_C1__n), 
     .Y(N10883_1));
  NAND2BX1 U405_C3_3 (.AN(sel_tc0), .B(n2710), .Y(N2158));
  AOI22X1 U357_C1_1 (.A0(N293), .A1(N10960), .B0(N336), .B1(N8723), .Y(N8874_1));
  NAND2X1 U284_C3_3 (.A(in_tc_4_1), .B(U259_C1__n_5), .Y(N9730));
  OAI211X1 U370_C4_13 (.A0(n2880), .A1(U312_C2__n), .B0(N4840), .C0(N4831), 
     .Y(N10827));
  SDFFSRX4 th0_reg_0_ (.CK(clk0_3), .D(N12173), .Q(th0[0]), .QN(n2860), 
     .RN(N8782), .SE(test_se_2), .SI(tf1_1), .SN(VDD));
  SDFFSRX2 th0_reg_2_ (.CK(clk0_3), .D(N8818), .Q(th0[2]), .QN(n2820), 
     .RN(N8782), .SE(test_se_2), .SI(th0[1]), .SN(VDD));
  AOI22X1 U348_C4_10 (.A0(N328), .A1(N8725), .B0(test_so1), .B1(N11092), 
     .Y(N8788_1));
  OAI21X1 U348_C4_7 (.A0(n2600), .A1(U273_C1__n_1), .B0(N11347), .Y(N12339));
  INVX1 U311_C3_3_MP_INV (.A(U311_C3__n_1), .Y(U311_C3__n_4));
  OR2X1 U311_C3_2 (.A(U259_C1__n_1), .B(N1555), .Y(U273_C1__n_1));
  AOI22X1 U365_C4_9 (.A0(in_tc_4_1), .A1(U256_C1__n_3), .B0(tl0[4]), 
     .B1(U266_C1__n), .Y(N11680_2));
  NAND2X1 U399_C5_5 (.A(tf0), .B(U266_C1__n), .Y(N2479));
  INVX1 U266_C1_MP_INV (.A(U266_C1__n), .Y(U266_C1__n_1));
  AOI22X1 U346_C4_10 (.A0(N329), .A1(N8725), .B0(th1[7]), .B1(N11092), 
     .Y(N9017_1));
  SDFFRHQX1 tf0_reg (.CK(clk0_3), .D(N11512), .Q(tf0), .RN(N8782), 
     .SE(test_se_2), .SI(n9));
  INVX1 U399_C5_2_MP_INV (.A(N11472), .Y(N11472_1));
  SDFFSRX2 th0_reg_4_ (.CK(clk0_3), .D(N8804), .Q(th0[4]), .QN(n2830), 
     .RN(N8782), .SE(test_se_2), .SI(th0[3]), .SN(VDD));
  NOR2X1 U418_C1_2 (.A(n2690), .B(n2650), .Y(U250_C2__n_2));
  INVX1 U415_C1_MP_INV (.A(tm0[1]), .Y(tm0_1_1));
  OR4X1 U419_C3_3 (.A(n2750), .B(n2700), .C(n2660), .D(n2620), .Y(U418_C1__n));
  u_tc_DW01_inc_9_0 r112 (.A({VSS, tl0[7], tl0[6], tl0[5], tl0[4], tl0[3], 
     tl0[2], tl0[1], tl0[0]}), .SUM({N312, N337, N336, N335, N334, N333, N332, 
     N331, N330}));
  SDFFSRX1 th1_reg_5_ (.CK(clk0_26), .D(N8877), .Q(th1[5]), .QN(n2910), 
     .RN(N8782), .SE(test_se_2), .SI(th1[4]), .SN(VDD));
  AOI22X1 U368_C4_10 (.A0(N285), .A1(N10959), .B0(N337), .B1(N11617), 
     .Y(N10826_1));
  OAI211X1 U372_C4_13 (.A0(n2890), .A1(U312_C2__n), .B0(N2873), .C0(N12009), 
     .Y(N10859));
  AOI22X1 U350_C4_11 (.A0(U311_C3__n_1), .A1(N261), .B0(in_tc_5_1), 
     .B1(U259_C1__n_1), .Y(N9016_2));
  INVX1 U330_C3_5_MP_INV (.A(N10960), .Y(N10960_1));
  OAI2BB1X1 U363_C4_9 (.A0N(N11821), .A1N(N10197_1), .B0(U312_C2__n), .Y(N1447));
  AOI22X1 U359_C1_10 (.A0(in_tc_7_1), .A1(U256_C1__n_3), .B0(th0[7]), 
     .B1(N11472), .Y(N10883_2));
  NAND2X1 U423_C1 (.A(\div12[1] ), .B(\div12[0] ), .Y(U428_C1__n));
  SDFFSRX1 div12_reg_3_ (.CK(clk0_3), .D(N8912), .Q(\div12[3] ), .QN(n2810), 
     .RN(N8782), .SE(test_se_2), .SI(\div12[2] ), .SN(VDD));
  NOR2X1 U428_C1 (.A(n306), .B(U428_C1__n), .Y(N10009));
  OAI2BB1X1 U296_C3_4 (.A0N(N12338), .A1N(N11015_1), .B0(N11794_1), .Y(N6540));
  OAI2BB1X1 U304_C3_10 (.A0N(in_tc_3_1), .A1N(U259_C1__n_5), .B0(N8819_1), 
     .Y(N8819));
  AOI22X1 U304_C3_9 (.A0(U273_C1__n_4), .A1(N250), .B0(U311_C3__n_1), .B1(N267), 
     .Y(N8819_1));
  OAI2BB1X1 U288_C3_8 (.A0N(N6953), .A1N(N10552_1), .B0(N8879_1), .Y(N11170));
  OAI21X1 U292_C3_2 (.A0(n2640), .A1(N11794_1), .B0(N5404), .Y(N8919));
  AOI22X1 U292_C3_7 (.A0(N326), .A1(N8725), .B0(U273_C1__n_4), .B1(N246), 
     .Y(N8918_1));
  NOR2X2 U323_C2 (.A(U318_C1__n_4), .B(U311_C3__n), .Y(N8725));
  SDFFSRX1 th1_reg_3_ (.CK(clk0_26), .D(N10196), .Q(th1[3]), .QN(), .RN(N8782), 
     .SE(test_se_2), .SI(th1[2]), .SN(VDD));
  OAI21X1 U296_C3_2 (.A0(n2590), .A1(N11794_1), .B0(N6540), .Y(N11014));
  XOR2X1 U432_C1 (.A(\div12[1] ), .B(\div12[0] ), .Y(U431_C1__n));
  OAI21X1 U300_C3_2 (.A0(n2720), .A1(N11794_1), .B0(N10326), .Y(N8720));
  SDFFSRX1 shift12_reg (.CK(clk0_3), .D(U426_C1__n_1), .Q(shift12), .QN(n2710), 
     .RN(N8782), .SE(test_se_2), .SI(\div12[3] ), .SN(VDD));
  NAND3BX1 U255_C2_2 (.AN(U252_C3__n), .B(addr_tc_2_1), .C(addr_tc_1_1), 
     .Y(U258_C1__n));
  BUFX1 BL1_BUF205 (.A(in_tc[7]), .Y(in_tc_7_1));
  SDFFSRX1 tl0_reg_5_ (.CK(clk0_3), .D(N9535), .Q(tl0[5]), .QN(n2750), 
     .RN(N8782), .SE(test_se_2), .SI(tl0[4]), .SN(VDD));
  OAI21X1 U345_C3_2 (.A0(n2910), .A1(N8879_1), .B0(N1314), .Y(N8877));
  INVX1 U139_C4_1_MP_INV (.A(tr1), .Y(tr1_1));
  AOI211X1 U411_C5_8 (.A0(int1_pin), .A1(gate1), .B0(t1_pin), .C0(n218), 
     .Y(U411_C5__n_4));
  AOI22X1 U372_C4_10 (.A0(N283), .A1(N10959), .B0(N335), .B1(N11617), 
     .Y(N10860_1));
  SDFFSRX2 tl0_reg_4_ (.CK(clk0_3), .D(N11680), .Q(tl0[4]), .QN(n2620), 
     .RN(N8782), .SE(test_se_2), .SI(tl0[3]), .SN(VDD));
  INVX1 BW1_INV8913 (.A(N8913), .Y(N8913_1));
  OAI2BB1X1 U374_C4_9 (.A0N(N10879_1), .A1N(N10055), .B0(U312_C2__n), .Y(N9499));
  NAND2X1 U372_C4_7 (.A(N300), .B(N8913_1), .Y(N12009));
  SDFFSRX2 tl1_reg_2_ (.CK(clk0_26), .D(N11014), .Q(tl1[2]), .QN(n2590), 
     .RN(N8782), .SE(test_se_2), .SI(tl1[1]), .SN(VDD));
  SDFFSRX2 th0_reg_6_ (.CK(clk0_3), .D(N10827), .Q(th0[6]), .QN(n2880), 
     .RN(N8782), .SE(test_se_2), .SI(th0[5]), .SN(VDD));
  SDFFSRX1 tl0_reg_6_ (.CK(clk0_3), .D(N12256), .Q(tl0[6]), .QN(n2660), 
     .RN(N8782), .SE(test_se_2), .SI(tl0[5]), .SN(VDD));
  BUFX1 BL1_BUF316 (.A(addr_tc[0]), .Y(addr_tc_0_1));
  OAI2BB1X1 U385_C4_2 (.A0N(N289), .A1N(N10960), .B0(N11679), .Y(N11678));
  AOI22X1 U383_C5_1 (.A0(N333), .A1(N8723), .B0(U319_C1__n), .B1(N276), 
     .Y(N10882));
  INVX1 U397_C2_2_MP_INV (.A(U397_C2__n), .Y(U397_C2__n_1));
  BUFX1 BL1_BUF243 (.A(in_tc[3]), .Y(in_tc_3_1));
  INVX1 BW2_INV_D11179 (.A(test_se), .Y(test_se_1));
  NAND4BBX1 U252_C3_4 (.AN(U252_C3__n), .BN(addr_tc_1_1), .C(addr_tc_0_1), 
     .D(addr_tc_2_2), .Y(U259_C1__n));
  NAND2X1 U344_C3_5 (.A(in_tc_6_1), .B(U259_C1__n_5), .Y(N1713));
  OR4X1 U254_C3_4 (.A(addr_tc_2_1), .B(addr_tc_1_1), .C(addr_tc_0_1), 
     .D(U252_C3__n), .Y(U256_C1__n_1));
  INVX1 U259_C1_MP_INV_1 (.A(U259_C1__n), .Y(U259_C1__n_5));
  AOI22X1 U357_C1_10 (.A0(in_tc_6_1), .A1(U256_C1__n_3), .B0(th0[6]), 
     .B1(N11472), .Y(N12256_2));
  AOI22X1 U378_C4_10 (.A0(N279), .A1(N10959), .B0(N331), .B1(N11617), 
     .Y(N8884_1));
  AOI22X1 U380_C4_10 (.A0(N278), .A1(N10959), .B0(N330), .B1(N11617), 
     .Y(N12174_1));
  INVX1 U359_C1_1_MP_INV (.A(N8902_1), .Y(N8902));
  NAND2X1 U388_C4_10 (.A(N10600_2), .B(N10600_1), .Y(N10600));
  OR4X1 U325_C5_8 (.A(n2950), .B(U319_C1__n_1), .C(N8880), .D(N11616), .Y(N9748));
  NAND2X1 U325_C5_1 (.A(N9748), .B(N11226), .Y(N11615));
  AOI21X1 U411_C5_10 (.A0(int1_pin), .A1(gate1), .B0(sel_tc1), .Y(U411_C5__n_5));
  OAI2BB1X1 U382_C4_2 (.A0N(N290), .A1N(N10960), .B0(N10882), .Y(N8722));
  NAND2X1 U355_C1_12 (.A(N9535_2), .B(N9535_1), .Y(N9535));
  NAND2X1 U333_C1 (.A(tm0[1]), .B(tm0[0]), .Y(U277_C1__n));
  SDFFSRX2 th0_reg_7_ (.CK(clk0_3), .D(N8885), .Q(th0[7]), .QN(n2870), 
     .RN(N8782), .SE(test_se_2), .SI(th0[6]), .SN(VDD));
  AOI22X1 U355_C1_11 (.A0(in_tc_5_1), .A1(U256_C1__n_3), .B0(th0[5]), 
     .B1(N11472), .Y(N9535_2));
  NAND2X1 U363_C4_7 (.A(N297), .B(N8913_1), .Y(N11405));
  AOI22X1 U388_C4_9 (.A0(in_tc_1_1), .A1(U256_C1__n_3), .B0(tl0[1]), 
     .B1(U266_C1__n), .Y(N10600_2));
  OAI2BB1X1 U348_C4_9 (.A0N(N8788_2), .A1N(N8788_1), .B0(U273_C1__n_1), 
     .Y(N11347));
  AOI21X1 U311_C3_3 (.A0(U311_C3__n_4), .A1(U311_C3__n), .B0(N11816), .Y(N1555));
  OAI21X1 U346_C4_7 (.A0(n2680), .A1(U273_C1__n_1), .B0(N12086), .Y(N8899));
  INVX2 U296_C3_2_MP_INV (.A(N11794), .Y(N11794_1));
  OAI2BB1X1 U346_C4_9 (.A0N(N9017_2), .A1N(N9017_1), .B0(U273_C1__n_1), 
     .Y(N12086));
  AOI211X1 U330_C3_5 (.A0(tm0_1_1), .A1(N10960_1), .B0(U313_C3__n), 
     .C0(U256_C1__n_2), .Y(U330_C3__n));
  NAND2X1 U378_C4_3 (.A(in_tc_1_1), .B(U256_C1__n_2), .Y(N11051));
  AOI22X1 U348_C4_11 (.A0(U311_C3__n_1), .A1(N262), .B0(in_tc_6_1), 
     .B1(U259_C1__n_1), .Y(N8788_2));
  NAND2X1 U374_C4_3 (.A(in_tc_4_1), .B(U256_C1__n_2), .Y(N10055));
  NAND2X1 U418_C1_4 (.A(U250_C2__n_3), .B(U250_C2__n_2), .Y(U250_C2__n));
  NAND2X1 U357_C1_11 (.A(N12256_2), .B(N12256_1), .Y(N12256));
  NOR2X1 U416_C1 (.A(tm0[1]), .B(tm0[0]), .Y(U319_C1__n));
  u_tc_DW01_inc_14_0 add_130 (.A({VSS, th0[7], th0[6], th0[5], th0[4], th0[3], 
     th0[2], th0[1], th0[0], tl0[4], tl0[3], tl0[2], tl0[1], tl0[0]}), .SUM({N286, 
     N285, N284, N283, N282, N281, N280, N279, N278, N277, N276, N275, N274, 
     N273}));
  OAI21X1 U350_C4_7 (.A0(n2730), .A1(U273_C1__n_1), .B0(N9754), .Y(N8900));
  AOI222X1 U361_C5_6 (.A0(U311_C3__n_1), .A1(N256), .B0(in_tc[0]), 
     .B1(U259_C1__n_1), .C0(th1[0]), .C1(N11092), .Y(N8920));
  OAI2BB1X1 U372_C4_9 (.A0N(N11494), .A1N(N10860_1), .B0(U312_C2__n), .Y(N2873));
  INVX2 U256_C1_MP_INV_1 (.A(U256_C1__n), .Y(U256_C1__n_3));
  OR3X1 U312_C2_3 (.A(U319_C1__n_1), .B(U312_C2__n_1), .C(N10960_1), .Y(N8913));
  OAI211X4 U139_C4_9 (.A0(U313_C3__n), .A1(N10959_1), .B0(U256_C1__n_1), 
     .C0(N6344), .Y(U312_C2__n));
  NAND3X1 U399_C5_15 (.A(N303), .B(N11471_1), .C(N10960), .Y(N12036));
  OAI211X1 U378_C4_13 (.A0(n2850), .A1(U312_C2__n), .B0(N10750), .C0(N10748), 
     .Y(N10881));
  SDFFSRX1 div12_reg_2_ (.CK(clk0_3), .D(N10161), .Q(\div12[2] ), .QN(n306), 
     .RN(N8782), .SE(test_se_2), .SI(\div12[1] ), .SN(VDD));
  NOR2BX1 U429_C1 (.AN(U429_C1__n), .B(U426_C1__n_1), .Y(N10161));
  NAND2X1 U374_C4_7 (.A(N299), .B(N8913_1), .Y(N9497));
  SDFFSRX1 th1_reg_2_ (.CK(clk0_26), .D(N11247), .Q(th1[2]), .QN(n2790), 
     .RN(N8782), .SE(test_se_2), .SI(th1[1]), .SN(VDD));
  AOI22X1 U284_C3_9 (.A0(U273_C1__n_4), .A1(N251), .B0(U311_C3__n_1), .B1(N268), 
     .Y(N8817_1));
  AOI22X1 U286_C3_9 (.A0(U273_C1__n_4), .A1(N249), .B0(U311_C3__n_1), .B1(N266), 
     .Y(N9007_1));
  NOR2BX2 U318_C1 (.AN(U318_C1__n_4), .B(U311_C3__n), .Y(N11092));
  SDFFSRX1 tl1_reg_4_ (.CK(clk0_26), .D(N8919), .Q(tl1[4]), .QN(n2640), 
     .RN(N8782), .SE(test_se_2), .SI(tl1[3]), .SN(VDD));
  AOI22X1 U305_C3_7 (.A0(N325), .A1(N8725), .B0(U273_C1__n_4), .B1(N245), 
     .Y(N8757_1));
  AOI222X1 U302_C5_6 (.A0(U311_C3__n_1), .A1(N257), .B0(in_tc_1_1), 
     .B1(U259_C1__n_1), .C0(th1[1]), .C1(N11092), .Y(N11475));
  OAI2BB1X1 U305_C3_4 (.A0N(N8757_1), .A1N(N10249), .B0(N11794_1), .Y(N6477));
  AOI22X1 U296_C3_7 (.A0(N324), .A1(N8725), .B0(U273_C1__n_4), .B1(N244), 
     .Y(N11015_1));
  SDFFSRX1 tl1_reg_3_ (.CK(clk0_3), .D(N10248), .Q(tl1[3]), .QN(n2670), 
     .RN(N8782), .SE(test_se_2), .SI(tl1[2]), .SN(VDD));
  NAND2X1 U368_C4_7 (.A(N302), .B(N8913_1), .Y(N10853));
  SDFFSRX1 div12_reg_0_ (.CK(clk0_3), .D(N10160), .Q(\div12[0] ), .QN(n2940), 
     .RN(N8782), .SE(test_se_2), .SI(test_si1), .SN(VDD));
  INVX1 U255_C2_2_MP_INV (.A(addr_tc_2_2), .Y(addr_tc_2_1));
  NOR2BX2 U258_C1 (.AN(addr_tc_0_1), .B(U258_C1__n), .Y(U259_C1__n_1));
  OAI2BB1X1 U344_C3_4 (.A0N(N8807_1), .A1N(N1713), .B0(N8879_1), .Y(N11038));
  AOI22X1 U344_C3_8 (.A0(U273_C1__n_4), .A1(N253), .B0(U311_C3__n_1), .B1(N270), 
     .Y(N8807_1));
  SDFFSRX1 tf1_1_reg (.CK(clk0_3), .D(N8813), .Q(tf1_1), .QN(n2930), .RN(N8782), 
     .SE(test_se_2), .SI(tf1_0), .SN(VDD));
  AOI22X1 U374_C4_10 (.A0(N282), .A1(N10959), .B0(N334), .B1(N11617), 
     .Y(N10879_1));
  AOI22X1 U365_C4_8 (.A0(N11760), .A1(N11471_1), .B0(th0[4]), .B1(N11472), 
     .Y(N11680_1));
  SDFFSRX2 tl0_reg_3_ (.CK(clk0_3), .D(N9018), .Q(tl0[3]), .QN(n2690), 
     .RN(N8782), .SE(test_se_2), .SI(tl0[2]), .SN(VDD));
  OAI2BB1X1 U370_C4_9 (.A0N(N8886_1), .A1N(N7863), .B0(U312_C2__n), .Y(N4831));
  NAND2X1 U372_C4_3 (.A(in_tc_5_1), .B(U256_C1__n_2), .Y(N11494));
  NAND2X1 U380_C4_7 (.A(N295), .B(N8913_1), .Y(N1600));
  SDFFSRX1 th1_reg_4_ (.CK(clk0_26), .D(N10553), .Q(th1[4]), .QN(n2770), 
     .RN(N8782), .SE(test_se_2), .SI(th1[3]), .SN(VDD));
  SDFFSRX1 th0_reg_5_ (.CK(clk0_3), .D(N10859), .Q(th0[5]), .QN(n2890), 
     .RN(N8782), .SE(test_se_2), .SI(th0[4]), .SN(VDD));
  NOR2BX2 U414_C1 (.AN(tm0[0]), .B(tm0[1]), .Y(N10960));
  OAI2BB1X1 U391_C4_2 (.A0N(N287), .A1N(N10960), .B0(N8836), .Y(N12255));
  AOI22X1 U386_C5_1 (.A0(N332), .A1(N8723), .B0(U319_C1__n), .B1(N275), 
     .Y(N11679));
  NOR2X1 U253_C2_1 (.A(U259_C1__n_5), .B(U253_C2__n), .Y(N8879));
  INVX8 U434_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N8782));
  BUFX1 BL1_BUF282 (.A(in_tc[2]), .Y(in_tc_2_1));
  BUFX1 BL1_BUF352 (.A(addr_tc[1]), .Y(addr_tc_1_1));
  NOR3X1 U275_C3_3 (.A(addr_tc[6]), .B(addr_tc[5]), .C(addr_tc[4]), 
     .Y(U275_C3__n));
  BUFX1 BL1_BUF222 (.A(in_tc[5]), .Y(in_tc_5_1));
  BUFX1 BL1_BUF261 (.A(in_tc[4]), .Y(in_tc_4_1));
  INVX2 U309_C3_6_MP_INV (.A(N8879), .Y(N8879_1));
  AOI22X1 U363_C4_10 (.A0(N280), .A1(N10959), .B0(N332), .B1(N11617), 
     .Y(N10197_1));
  AOI22X1 U355_C1_2 (.A0(N292), .A1(N10960), .B0(N335), .B1(N8723), .Y(N9960_1));
  NOR3BX2 U250_C2_2 (.AN(N11616), .B(U256_C1__n_3), .C(U250_C2__n), .Y(N11472));
  NOR2X2 U319_C1 (.A(U319_C1__n_1), .B(U319_C1__n_2), .Y(N10959));
  NAND2X1 U359_C1_11 (.A(N10883_2), .B(N10883_1), .Y(N10883));
  AOI22X1 U382_C4_9 (.A0(N8722), .A1(N11471_1), .B0(th0[3]), .B1(N11472), 
     .Y(N9018_1));
  AOI32X1 U411_C5_2 (.A0(tr1), .A1(sel_tc1), .A2(U411_C5__n_4), 
     .B0(U411_C5__n_6), .B1(U411_C5__n_5), .Y(N11816));
  AOI22X1 U385_C4_9 (.A0(N11678), .A1(N11471_1), .B0(th0[2]), .B1(N11472), 
     .Y(N8909_1));
  NOR2BX1 U411_C5_11 (.AN(tr1), .B(n2710), .Y(U411_C5__n_6));
  AOI22X1 U357_C1_9 (.A0(N8874), .A1(N8872), .B0(tl0[6]), .B1(U283_C1__n), 
     .Y(N12256_1));
  SDFFSRX1 t1_pin_r_reg (.CK(clk0_3), .D(t1_pin), .Q(n9), .QN(n218), .RN(N8782), 
     .SE(test_se_2), .SI(t0_pin_r), .SN(VDD));
  NAND2X1 U288_C3_3 (.A(in_tc[0]), .B(U259_C1__n_5), .Y(N6953));
  SDFFSRX2 th0_reg_3_ (.CK(clk0_3), .D(N8805), .Q(th0[3]), .QN(n2840), 
     .RN(N8782), .SE(test_se_2), .SI(th0[2]), .SN(VDD));
  SDFFSRX2 th0_reg_1_ (.CK(clk0_3), .D(N10881), .Q(th0[1]), .QN(n2850), 
     .RN(N8782), .SE(test_se_2), .SI(th0[0]), .SN(VDD));
  NAND2X1 U380_C4_3 (.A(in_tc[0]), .B(U256_C1__n_2), .Y(N10389));
  NAND2X1 U376_C4_3 (.A(in_tc_3_1), .B(U256_C1__n_2), .Y(N5185));
  INVX1 U403_C4_3_MP_INV (.A(N11092), .Y(N11092_1));
  AOI22X1 U346_C4_11 (.A0(U311_C3__n_1), .A1(N263), .B0(in_tc_7_1), 
     .B1(U259_C1__n_1), .Y(N9017_2));
  AOI2BB1X1 U273_C1_1 (.A0N(U273_C1__n), .A1N(N11816), .B0(U273_C1__n_1), 
     .Y(N11794));
  AOI2BB1X2 U313_C3_1 (.A0N(U313_C3__n), .A1N(U256_C1__n_2), .B0(U256_C1__n_3), 
     .Y(U266_C1__n));
  AOI22X1 U391_C4_10 (.A0(in_tc[0]), .A1(U256_C1__n_3), .B0(tl0[0]), 
     .B1(U266_C1__n), .Y(N8724_2));
  SDFFSRX4 tl1_reg_7_ (.CK(clk0_3), .D(N8899), .Q(test_so2), .QN(n2680), 
     .RN(N8782), .SE(test_se_2), .SI(tl1[6]), .SN(VDD));
  INVX1 U365_C4_8_MP_INV (.A(N11471), .Y(N11471_1));
  OAI211X1 U399_C5_2 (.A0(U266_C1__n), .A1(N11472_1), .B0(N2479), .C0(N12036), 
     .Y(N11514));
  u_tc_DW01_inc_17_1 add_190 (.A({VSS, th1[7], test_so1, th1[5], th1[4], th1[3], 
     th1[2], th1[1], th1[0], test_so2, tl1[6], tl1[5], tl1[4], tl1[3], tl1[2], 
     tl1[1], tl1[0]}), .SUM({N272, N271, N270, N269, N268, N267, N266, N265, N264, 
     N263, N262, N261, N260, N259, N258, N257, N256}));
  INVX1 U357_C1_1_MP_INV (.A(N8874_1), .Y(N8874));
  OAI2BB1X1 U365_C4_1 (.A0N(N291), .A1N(N10960), .B0(N11761), .Y(N11760));
  INVX1 U319_C1_MP_INV (.A(U319_C1__n), .Y(U319_C1__n_2));
  u_tc_DW01_inc_8_0 add_200 (.A({test_so2, tl1[6], tl1[5], tl1[4], tl1[3], 
     tl1[2], tl1[1], tl1[0]}), .SUM({N329, N328, N327, N326, N325, N324, N323, 
     N322}));
  AOI222X1 U294_C5_6 (.A0(U311_C3__n_1), .A1(N260), .B0(in_tc_4_1), 
     .B1(U259_C1__n_1), .C0(th1[4]), .C1(N11092), .Y(N9015));
  AOI22X1 U370_C4_10 (.A0(N284), .A1(N10959), .B0(N336), .B1(N11617), 
     .Y(N8886_1));
  OAI2BB1X1 U376_C4_9 (.A0N(N5185), .A1N(N10880_1), .B0(U312_C2__n), .Y(N1605));
  AOI22X1 U350_C4_10 (.A0(N327), .A1(N8725), .B0(th1[5]), .B1(N11092), 
     .Y(N9016_1));
  INVX1 U139_C4_9_MP_INV (.A(N10959), .Y(N10959_1));
  NAND2X1 U256_C1 (.A(U256_C1__n_1), .B(U256_C1__n), .Y(U319_C1__n_1));
  NAND2X1 U378_C4_7 (.A(N296), .B(N8913_1), .Y(N10750));
  SDFFSRX2 tl1_reg_1_ (.CK(clk0_3), .D(N8720), .Q(tl1[1]), .QN(n2720), 
     .RN(N8782), .SE(test_se_2), .SI(tl1[0]), .SN(VDD));
  NOR2BX1 U426_C1 (.AN(U426_C1__n), .B(U426_C1__n_1), .Y(N8912));
  OAI21X1 U352_C3_5 (.A0(n2630), .A1(N11794_1), .B0(N7757), .Y(N8787));
  AOI22X1 U352_C3_8 (.A0(N322), .A1(N8725), .B0(U273_C1__n_4), .B1(N242), 
     .Y(N8910_1));
  AOI22X1 U309_C3_9 (.A0(U273_C1__n_4), .A1(N248), .B0(U311_C3__n_1), .B1(N265), 
     .Y(N11249_1));
  OAI21X1 U284_C3_6 (.A0(n2770), .A1(N8879_1), .B0(N1700), .Y(N10553));
  NAND2X1 U286_C3_3 (.A(in_tc_2_1), .B(U259_C1__n_5), .Y(N4147));
  OAI2BB1X1 U292_C3_4 (.A0N(N9015), .A1N(N8918_1), .B0(N11794_1), .Y(N5404));
  OAI2BB1X1 U352_C3_7 (.A0N(N8920), .A1N(N8910_1), .B0(N11794_1), .Y(N7757));
  OAI2BB1X1 U300_C3_4 (.A0N(N11475), .A1N(N11474_1), .B0(N11794_1), .Y(N10326));
  NOR2X1 U337_C3_2 (.A(n2730), .B(n2680), .Y(U335_C1__n_2));
  SDFFSRX1 th1_reg_1_ (.CK(clk0_26), .D(N11248), .Q(th1[1]), .QN(n2800), 
     .RN(N8782), .SE(test_se_2), .SI(th1[0]), .SN(VDD));
  AOI22X1 U300_C3_7 (.A0(N323), .A1(N8725), .B0(U273_C1__n_4), .B1(N243), 
     .Y(N11474_1));
  NOR4BX1 U335_C1_4 (.AN(U318_C1__n_1), .B(n2720), .C(n2670), .D(n2630), 
     .Y(U318_C1__n_4));
  SDFFRHQX1 div12_reg_1_ (.CK(clk0_3), .D(U431_C1__n), .Q(\div12[1] ), 
     .RN(N8782), .SE(test_se_2), .SI(\div12[0] ));
  NAND2X1 U354_C3_5 (.A(in_tc_7_1), .B(U259_C1__n_5), .Y(N10701));
  OAI2BB1X1 U354_C3_4 (.A0N(N10978_1), .A1N(N10701), .B0(N8879_1), .Y(N12068));
  SDFFSRX1 tf1_0_reg (.CK(clk0_3), .D(N11615), .Q(tf1_0), .QN(n2950), .RN(N8782), 
     .SE(test_se_2), .SI(tf0), .SN(VDD));
  OAI2BB1X1 U345_C3_4 (.A0N(N11586), .A1N(N10976_1), .B0(N8879_1), .Y(N1314));
  AOI22X1 U354_C3_8 (.A0(U273_C1__n_4), .A1(N254), .B0(U311_C3__n_1), .B1(N271), 
     .Y(N10978_1));
  OAI211X1 U328_C2_4 (.A0(tr1_1), .A1(n2710), .B0(N10960_1), .C0(N10959_1), 
     .Y(N8880));
  NAND2X1 U391_C4_11 (.A(N8724_2), .B(N8724_1), .Y(N8724));
  OAI31X1 U403_C4_2 (.A0(n2930), .A1(U259_C1__n_5), .A2(N11794_1), .B0(N7756), 
     .Y(N8813));
  NAND2X1 U376_C4_7 (.A(N298), .B(N8913_1), .Y(N1862));
  NAND2X1 U370_C4_7 (.A(N301), .B(N8913_1), .Y(N4840));
  NAND2X1 U370_C4_3 (.A(in_tc_6_1), .B(U256_C1__n_2), .Y(N7863));
  NOR4BX1 U335_C1_1 (.AN(U335_C1__n_2), .B(n2640), .C(n2600), .D(n2590), 
     .Y(U318_C1__n_1));
  AOI22X1 U345_C3_8 (.A0(U273_C1__n_4), .A1(N252), .B0(U311_C3__n_1), .B1(N269), 
     .Y(N10976_1));
  SDFFSRX1 tl1_reg_5_ (.CK(clk0_26), .D(N8900), .Q(tl1[5]), .QN(n2730), 
     .RN(N8782), .SE(test_se_2), .SI(tl1[4]), .SN(VDD));
  BUFX1 BL1_ASSIGN_BUF26 (.A(test_so1), .Y(th1[6]));
  NOR3X1 U418_C1_3 (.A(n2740), .B(n2610), .C(U418_C1__n), .Y(U250_C2__n_3));
  SDFFSRX4 tl0_reg_2_ (.CK(clk0_3), .D(N8909), .Q(tl0[2]), .QN(n2610), 
     .RN(N8782), .SE(test_se_2), .SI(tl0[1]), .SN(VDD));
  NOR3BX4 U394_C2_2 (.AN(tm1[0]), .B(tm1[1]), .C(U397_C2__n), .Y(U311_C3__n_1));
  BUFX1 BL1_BUF304 (.A(in_tc[1]), .Y(in_tc_1_1));
  OR3X1 U396_C2_3 (.A(tm1[1]), .B(tm1[0]), .C(U397_C2__n), .Y(U273_C1__n));
  NAND2X1 U345_C3_5 (.A(in_tc_5_1), .B(U259_C1__n_5), .Y(N11586));
  SDFFSRX2 th1_reg_6_ (.CK(clk0_26), .D(N10247), .Q(test_so1), .QN(n2900), 
     .RN(N8782), .SE(test_se_2), .SI(th1[5]), .SN(VDD));
  INVX8 BW2_INV11179 (.A(test_se_1), .Y(test_se_2));
  INVX1 U259_C1_MP_INV (.A(U259_C1__n_1), .Y(U259_C1__n_4));
  NAND2X1 U266_C1 (.A(U266_C1__n_1), .B(U256_C1__n), .Y(N11471));
  AOI22X1 U366_C5_1 (.A0(N334), .A1(N8723), .B0(U319_C1__n), .B1(N277), 
     .Y(N11761));
  OR2X1 U425_C1 (.A(tf1_1), .B(tf1_0), .Y(tf1));
  AOI22X1 U388_C4_8 (.A0(N11471_1), .A1(N10601), .B0(th0[1]), .B1(N11472), 
     .Y(N10600_1));
  NAND2X1 U382_C4_11 (.A(N9018_2), .B(N9018_1), .Y(N9018));
  NOR2X1 U283_C1 (.A(U283_C1__n), .B(U256_C1__n_3), .Y(N8872));
  AOI22X1 U359_C1_1 (.A0(N294), .A1(N10960), .B0(N337), .B1(N8723), .Y(N8902_1));
  NAND2X1 U385_C4_11 (.A(N8909_2), .B(N8909_1), .Y(N8909));
  OAI2BB1X1 U388_C4_1 (.A0N(N288), .A1N(N10960), .B0(N8875), .Y(N10601));
  NOR2X1 U415_C1 (.A(tm0_1_1), .B(tm0[0]), .Y(N11616));
  OAI2BB1X1 U334_C3_1 (.A0N(U250_C2__n), .A1N(N11616), .B0(U277_C1__n), 
     .Y(N8723));
  SDFFRHQX1 t0_pin_r_reg (.CK(clk0_3), .D(t0_pin), .Q(t0_pin_r), .RN(N8782), 
     .SE(test_se_2), .SI(shift12));
  INVX1 U312_C2_2_MP_INV (.A(U312_C2__n), .Y(U312_C2__n_1));
  OAI2BB1X1 U380_C4_9 (.A0N(N12174_1), .A1N(N10389), .B0(U312_C2__n), .Y(N10792));
  NAND2X1 U363_C4_3 (.A(in_tc_2_1), .B(U256_C1__n_2), .Y(N11821));
  OAI2BB1X1 U350_C4_9 (.A0N(N9016_2), .A1N(N9016_1), .B0(U273_C1__n_1), 
     .Y(N9754));
  OAI2BB1X1 U403_C4_3 (.A0N(N8809_1), .A1N(N11092_1), .B0(N11794_1), .Y(N7756));
  INVX2 U253_C2_2_MP_INV (.A(U273_C1__n), .Y(U273_C1__n_4));
  AOI22X1 U382_C4_10 (.A0(in_tc_3_1), .A1(U256_C1__n_3), .B0(tl0[3]), 
     .B1(U266_C1__n), .Y(N9018_2));
  AOI21X1 U253_C2_2 (.A0(U311_C3__n_4), .A1(U273_C1__n), .B0(N11816), 
     .Y(U253_C2__n));
  NOR2X2 U277_C1 (.A(U319_C1__n_1), .B(U277_C1__n), .Y(N11617));
  OAI2BB2X1 U399_C5_11 (.A0N(U256_C1__n_1), .A1N(N11514), .B0(U266_C1__n), 
     .B1(N11513), .Y(N11512));
  SDFFSRX1 tl1_reg_6_ (.CK(clk0_26), .D(N12339), .Q(tl1[6]), .QN(n2600), 
     .RN(N8782), .SE(test_se_2), .SI(tl1[5]), .SN(VDD));
  NAND2X1 U368_C4_3 (.A(in_tc_7_1), .B(U256_C1__n_2), .Y(N5429));
endmodule

// Entity:u_tc_DW01_inc_14_0 Model:u_tc_DW01_inc_14_0 Library:L0
module u_tc_DW01_inc_14_0 (A, SUM);
  input [13:0] A;
  output [13:0] SUM;
  wire carry_12_, carry_11_, carry_10_, carry_9_, carry_8_, carry_7_, carry_6_, 
     carry_5_, carry_4_, carry_3_, carry_2_;
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  INVX1 U5_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_10 (.A(A[10]), .B(carry_10_), .CO(carry_11_), .S(SUM[10]));
  ADDHX1 U1_1_9 (.A(A[9]), .B(carry_9_), .CO(carry_10_), .S(SUM[9]));
  ADDHX1 U1_1_8 (.A(A[8]), .B(carry_8_), .CO(carry_9_), .S(SUM[8]));
  CMPR22X1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDHX1 U1_1_7 (.A(A[7]), .B(carry_7_), .CO(carry_8_), .S(SUM[7]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  CMPR22X1 U1_1_12 (.A(A[12]), .B(carry_12_), .CO(SUM[13]), .S(SUM[12]));
  ADDHX1 U1_1_11 (.A(A[11]), .B(carry_11_), .CO(carry_12_), .S(SUM[11]));
endmodule

// Entity:u_tc_DW01_inc_14_1 Model:u_tc_DW01_inc_14_1 Library:L0
module u_tc_DW01_inc_14_1 (A, SUM);
  input [13:0] A;
  output [13:0] SUM;
  wire carry_12_, carry_11_, carry_10_, carry_9_, carry_8_, carry_7_, carry_6_, 
     carry_5_, carry_4_, carry_3_, carry_2_;
  ADDHX1 U1_1_10 (.A(A[10]), .B(carry_10_), .CO(carry_11_), .S(SUM[10]));
  CMPR22X1 U1_1_12 (.A(A[12]), .B(carry_12_), .CO(SUM[13]), .S(SUM[12]));
  ADDHX1 U1_1_11 (.A(A[11]), .B(carry_11_), .CO(carry_12_), .S(SUM[11]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_7 (.A(A[7]), .B(carry_7_), .CO(carry_8_), .S(SUM[7]));
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  ADDHX1 U1_1_9 (.A(A[9]), .B(carry_9_), .CO(carry_10_), .S(SUM[9]));
  ADDHX1 U1_1_8 (.A(A[8]), .B(carry_8_), .CO(carry_9_), .S(SUM[8]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  INVX1 U5_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
endmodule

// Entity:u_tc_DW01_inc_17_0 Model:u_tc_DW01_inc_17_0 Library:L0
module u_tc_DW01_inc_17_0 (A, SUM);
  input [16:0] A;
  output [16:0] SUM;
  wire carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, 
     carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, 
     carry_2_;
  ADDHX1 U1_1_13 (.A(A[13]), .B(carry_13_), .CO(carry_14_), .S(SUM[13]));
  ADDHX1 U1_1_12 (.A(A[12]), .B(carry_12_), .CO(carry_13_), .S(SUM[12]));
  ADDHX1 U1_1_14 (.A(A[14]), .B(carry_14_), .CO(carry_15_), .S(SUM[14]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  INVX1 U5_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_7 (.A(A[7]), .B(carry_7_), .CO(carry_8_), .S(SUM[7]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDHX1 U1_1_8 (.A(A[8]), .B(carry_8_), .CO(carry_9_), .S(SUM[8]));
  ADDHX1 U1_1_9 (.A(A[9]), .B(carry_9_), .CO(carry_10_), .S(SUM[9]));
  ADDHX1 U1_1_15 (.A(A[15]), .B(carry_15_), .CO(SUM[16]), .S(SUM[15]));
  ADDHX1 U1_1_10 (.A(A[10]), .B(carry_10_), .CO(carry_11_), .S(SUM[10]));
  ADDHX1 U1_1_11 (.A(A[11]), .B(carry_11_), .CO(carry_12_), .S(SUM[11]));
endmodule

// Entity:u_tc_DW01_inc_17_1 Model:u_tc_DW01_inc_17_1 Library:L0
module u_tc_DW01_inc_17_1 (A, SUM);
  input [16:0] A;
  output [16:0] SUM;
  wire carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, 
     carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, 
     carry_2_;
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_13 (.A(A[13]), .B(carry_13_), .CO(carry_14_), .S(SUM[13]));
  ADDHX1 U1_1_7 (.A(A[7]), .B(carry_7_), .CO(carry_8_), .S(SUM[7]));
  CMPR22X1 U1_1_15 (.A(A[15]), .B(carry_15_), .CO(SUM[16]), .S(SUM[15]));
  ADDHX1 U1_1_14 (.A(A[14]), .B(carry_14_), .CO(carry_15_), .S(SUM[14]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDHX1 U1_1_9 (.A(A[9]), .B(carry_9_), .CO(carry_10_), .S(SUM[9]));
  ADDHX1 U1_1_12 (.A(A[12]), .B(carry_12_), .CO(carry_13_), .S(SUM[12]));
  ADDHX1 U1_1_10 (.A(A[10]), .B(carry_10_), .CO(carry_11_), .S(SUM[10]));
  ADDHX1 U1_1_11 (.A(A[11]), .B(carry_11_), .CO(carry_12_), .S(SUM[11]));
  ADDHX1 U1_1_8 (.A(A[8]), .B(carry_8_), .CO(carry_9_), .S(SUM[8]));
  INVX1 U5_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
endmodule

// Entity:u_tc_DW01_inc_8_0 Model:u_tc_DW01_inc_8_0 Library:L0
module u_tc_DW01_inc_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  XOR2X1 U5_C1 (.A(carry_7_), .B(A[7]), .Y(SUM[7]));
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
endmodule

// Entity:u_tc_DW01_inc_9_0 Model:u_tc_DW01_inc_9_0 Library:L0
module u_tc_DW01_inc_9_0 (A, SUM);
  input [8:0] A;
  output [8:0] SUM;
  wire carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;
  INVX1 U5_C1 (.A(A[0]), .Y(SUM[0]));
  CMPR22X1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  CMPR22X1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  CMPR22X1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  ADDHX1 U1_1_7 (.A(A[7]), .B(carry_7_), .CO(SUM[8]), .S(SUM[7]));
  CMPR22X1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  CMPR22X1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  CMPR22X1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
endmodule

// Entity:u_uart_test_1 Model:u_uart_test_1 Library:L0
module u_uart_test_1 (clk, rst_p, rxdi, rxdo, in_sfr, addr_sfr, wr, shift12, 
     tf1, txdo, uart_int, scon, pcon, sbuf, rc8051RtlTop_test_point_535_in, 
     test_si1, test_so1, test_si2, test_so2, test_si3, test_so3, test_si4, 
     test_so4, test_se, clk0_4, clk0_5);
  input clk, rst_p, rxdi, wr, shift12, tf1, rc8051RtlTop_test_point_535_in, 
     test_si1, test_si2, test_si3, test_si4, test_se, clk0_4, clk0_5;
  output rxdo, txdo, uart_int, test_so1, test_so2, test_so3, test_so4;
  input [7:0] in_sfr;
  input [7:0] addr_sfr;
  output [7:0] scon;
  output [7:0] pcon;
  output [7:0] sbuf;
  wire txdo_1, \cnt1_8[0] , \cnt1_8[1] , \cnt1_8[2] , \cnt1_8[3] , \cnt1_8[4] , 
     \cnt1_8[5] , \cnt1_8[6] , \cnt1_8[7] , \trans_cnt[0] , \trans_cnt[1] , 
     \trans_cnt[2] , \trans_cnt[3] , \rec_cnt[0] , \rec_cnt[1] , \rec_cnt[2] , 
     \rec_cnt[3] , \rx_same[0] , \rx_same[1] , tx_done, rx_done, div12, 
     rec_sync, receive, trans1, trans, trans2, smod_clk_trans, smod_clk_rec, 
     N242, N243, N244, N245, N246, N247, N248, N249, n2, n196, n198, n199, n200, 
     n201, n202, n203, n204, n205, n206, n207, n208, n209, n210, n211, n212, 
     n213, n214, n215, n297, n298, n299, n300, n301, n302, n303, n304, n305, 
     n306, n307, n3080, n3090, n3100, n311, n3120, n3130, n3140, n315, n316, 
     n317, n318, n319, n320, n321, n322, n323, n324, n325, n326, n327, n328, 
     n329, n330, n331, n332, n333, n335, n336, n337, n338, n339, n340, n341, 
     n342, n343, n344, n345, n346, n347, n348, n349, n350, n359, 
     \sbuf_rxd_tmp[11] , \sbuf_rxd_tmp[7] , \sbuf_rxd_tmp[6] , 
     \sbuf_rxd_tmp[5] , \sbuf_rxd_tmp[4] , \sbuf_rxd_tmp[3] , \sbuf_rxd_tmp[2] , 
     \sbuf_rxd_tmp[1] , \sbuf_rxd_tmp[0] , \sbuf_txd[9] , \sbuf_txd[8] , 
     \sbuf_txd[7] , \sbuf_txd[6] , \sbuf_txd[5] , \sbuf_txd[4] , \sbuf_txd[3] , 
     \sbuf_txd[2] , \sbuf_txd[0] , \cnt0_4[2] , \cnt0_4[1] , n19, n20, n50, n56, 
     n66, n70, n118, n127, n130, n132, U372_C1__n, N10441, N11985, U336_C2__n, 
     U336_C2__n_1, U311_C2__n, U337_C2__n, U460_C5__n, N8791, N10048, N10047, 
     U467_C3__n, N9985, U446_C1__n, N11440, N11439, N12304, N12303, U473_C3__n, 
     N8842, N8843, N12145, N8915, U282_C1__n, U288_C2__n, U333_C1__n, 
     U407_C2__n, U329_C1__n, U329_C1__n_1, N11184, N11183, N8916, U303_C1__n, 
     N10118, N10117, N8904, U484_C1__n, U470_C1__n, N12278, N11899, N11898, 
     N8866, N8917, N12103, N8897, N8928, U369_C1__n, U503_C1__n, N9020, 
     U501_C1__n, N8927, U506_C1__n, N11277, N8924, N8922, N8921, N8914, N8747, 
     N11313, N8749, N11311, U421_C3__n, U493_C2__n, N8925, N8844, N8835, N9011, 
     N11211, N11210, N9010, N10813, N10812, N8903, N10493, N8781, N8756, N7410, 
     N7526, N8780, N8745, U487_C1__n, N11557, N8755, N10683, N10682, N11498, 
     N11497, N8744, N8751, N10049, N8746, N8797, U156_C3__n, U309_C1__n, N8796, 
     N8799, N10423, N11807, N9921, N8786, N8753, N8779, N9002, N11572, N11571, 
     N9001, N10907, N10906, N11468, N11467, N8760, N8867, N10924, N9012, N10923, 
     N8761, N8762, N8763, N8870, N11974, N11973, N8829, N8830, N10032, N10031, 
     N8871, N9984, N9983, N8826, N8827, N11228, N8677, N8811, N9052, N8869, 
     N8832, N10360, N10359, N8831, N10878, N7733, N8896, U402_C5__n, N10315, 
     N8806, U504_C1__n, N10314, N7286, N7862, N1387, N8453, N6718, N2156, N8582, 
     N1381, N11523, N8525, N3071, N4067, N7138, N6107, N6530, N7566, N9112, 
     N1843, N1586, N1580, N1871, N10293, N1421, N10484, N2802, N9994, N9247, 
     N11057, N3845, N12304_2, N12304_3, rxdi_1, U446_C1__n_1, U336_C2__n_3, 
     U488_C1__n_2, U484_C1__n_1, U484_C1__n_4, N8761_1, N8761_4, N8761_6, 
     N6107_2, U156_C3__n_3, U156_C3__n_4, U311_C2__n_1, U309_C1__n_2, 
     U372_C1__n_1, U288_C2__n_2, U333_C1__n_1, U329_C1__n_2, N11440_3, N11184_6, 
     N11184_7, N10560_1, N10560_2, N11183_2, N11211_1, N10118_1, U303_C1__n_1, 
     N11210_1, N10923_2, N10813_1, U460_C5__n_2, N10117_1, N9011_1, N9010_1, 
     in_sfr_0_1, N10031_1, N8535_3, N8867_1, N8835_1, N8427_1, N9247_2, 
     N11468_1, N11899_1, N8747_1, N10585_7, N10585_8, N10585_9, N10441_1, 
     N1871_1, in_sfr_6_1, in_sfr_7_1, in_sfr_5_1, in_sfr_3_1, in_sfr_4_1, 
     in_sfr_2_1, in_sfr_1_1, addr_sfr_0_1, addr_sfr_6_1, addr_sfr_1_1, 
     addr_sfr_2_1, addr_sfr_4_1, addr_sfr_3_1, addr_sfr_5_1, test_se_1, 
     N10047_1, test_se_2, n334;
  supply1 VDD;
  OR4X1 U459_C3_3 (.A(\trans_cnt[3] ), .B(\trans_cnt[2] ), .C(\trans_cnt[1] ), 
     .D(\trans_cnt[0] ), .Y(U329_C1__n));
  NAND2BX1 U281_C5_21 (.AN(n2), .B(N1871_1), .Y(N1871));
  AOI22X1 U402_C5_3 (.A0(in_sfr_0_1), .A1(N10031), .B0(n317), .B1(N8427_1), 
     .Y(U402_C5__n));
  SDFFSRX1 sbuf_rxd_reg_1_ (.CK(clk0_4), .D(N9052), .Q(sbuf[1]), .QN(n207), 
     .RN(N10047_1), .SE(test_se), .SI(sbuf[0]), .SN(VDD));
  OAI2BB1X1 U4_C5 (.A0N(N1871), .A1N(N10441), .B0(U372_C1__n), .Y(N11985));
  AND2X1 U500_C1 (.A(U470_C1__n), .B(N242), .Y(N10493));
  SDFFSRX1 rec_cnt_reg_1_ (.CK(clk0_4), .D(N8797), .Q(\rec_cnt[1] ), .QN(n326), 
     .RN(N10047_1), .SE(test_se_2), .SI(\rec_cnt[0] ), .SN(VDD));
  OAI2BB2X1 U455_C4_1 (.A0N(U446_C1__n), .A1N(N8746), .B0(n326), .B1(N7410), 
     .Y(N8797));
  OAI22X1 U476_C3_1 (.A0(n298), .A1(n210), .B0(rx_done), .B1(n3120), .Y(N11973));
  OAI22X1 U478_C3_1 (.A0(n298), .A1(n208), .B0(rx_done), .B1(n3130), .Y(N8869));
  AOI2BB1X1 U371_C1_1 (.A0N(smod_clk_rec), .A1N(pcon[7]), .B0(U473_C3__n), 
     .Y(N8921));
  OAI21X1 U324_C3_1 (.A0(n306), .A1(N10031), .B0(N7862), .Y(N8826));
  OAI32X1 U440_C5_3 (.A0(n340), .A1(n3100), .A2(U446_C1__n_1), .B0(rxdi_1), 
     .B1(N11468_1), .Y(N11467));
  NAND2X1 U298_C1 (.A(U460_C5__n_2), .B(U446_C1__n_1), .Y(N7410));
  INVX1 U440_C5_3_MP_INV (.A(N11468), .Y(N11468_1));
  OAI21X1 U440_C5_6 (.A0(n299), .A1(U309_C1__n_2), .B0(N3071), .Y(N8760));
  NAND2X2 U309_C1 (.A(U311_C2__n_1), .B(U309_C1__n_2), .Y(N8796));
  SDFFSRX1 sbuf_rxd_tmp_reg_3_ (.CK(clk0_4), .D(N8779), .Q(\sbuf_rxd_tmp[3] ), 
     .QN(n338), .RN(N10047_1), .SE(test_se_2), .SI(\sbuf_rxd_tmp[2] ), .SN(VDD));
  AND4X1 U281_C5_14 (.A(\sbuf_rxd_tmp[6] ), .B(\sbuf_rxd_tmp[5] ), 
     .C(\sbuf_rxd_tmp[3] ), .D(\sbuf_rxd_tmp[2] ), .Y(N10585_8));
  OAI221X1 U347_C4_5 (.A0(n302), .A1(N8796), .B0(n338), .B1(U309_C1__n_2), 
     .C0(N8786), .Y(N8779));
  AND4X2 U285_C1_8 (.A(addr_sfr[7]), .B(N8761_6), .C(N8761_4), .D(N8761_1), 
     .Y(N8761));
  BUFX1 BL1_BUF366 (.A(addr_sfr[1]), .Y(addr_sfr_1_1));
  BUFX1 BL1_BUF384 (.A(addr_sfr[2]), .Y(addr_sfr_2_1));
  NAND2BX1 U281_C5_18 (.AN(n359), .B(N10441_1), .Y(N10441));
  INVX1 U338_C2_2_MP_INV (.A(U336_C2__n_3), .Y(U336_C2__n_1));
  SDFFSRX1 receive_reg (.CK(clk0_4), .D(N8867), .Q(receive), .QN(n359), 
     .RN(N10047_1), .SE(test_se_2), .SI(rec_sync), .SN(VDD));
  OAI2BB1X1 U499_C3_1 (.A0N(receive), .A1N(rec_sync), .B0(U484_C1__n), .Y(N8922));
  NOR3X1 U446_C1_3 (.A(\rec_cnt[0] ), .B(n331), .C(U446_C1__n_1), .Y(N11440_3));
  MXI2X1 U444_C3_1 (.A(rxdi_1), .B(n3100), .S0(N11440), .Y(N11439));
  SDFFSRX1 sbuf_rxd_tmp_reg_0_ (.CK(clk0_5), .D(N9001), .Q(\sbuf_rxd_tmp[0] ), 
     .QN(n304), .RN(N10047_1), .SE(test_se_2), .SI(sbuf[7]), .SN(VDD));
  SDFFSX1 rxdi_r_reg (.CK(clk0_4), .D(N10048), .Q(n19), .QN(n341), 
     .SE(test_se_2), .SI(\rx_same[1] ), .SN(N10047_1));
  NAND4X1 U467_C3_7 (.A(\rec_cnt[3] ), .B(\rec_cnt[0] ), .C(n335), .D(n326), 
     .Y(N11523));
  NOR2X1 U156_C3_3 (.A(\rec_cnt[2] ), .B(n331), .Y(U156_C3__n_3));
  NAND4X1 U429_C4_7 (.A(scon[4]), .B(n317), .C(U372_C1__n), .D(N6107_2), 
     .Y(N6107));
  MXI2X1 U460_C5_3 (.A(n341), .B(rxdi_1), .S0(N8791), .Y(N10048));
  BUFX1 BL1_BUF229 (.A(in_sfr[3]), .Y(in_sfr_3_1));
  SDFFSX1 trans3_reg (.CK(clk0_5), .D(trans2), .Q(n56), .QN(n2), .SE(test_se_2), 
     .SI(trans2), .SN(VDD));
  OAI211X4 U102_C3_4 (.A0(N11184), .A1(N11183_2), .B0(U333_C1__n_1), .C0(N8916), 
     .Y(U303_C1__n));
  OR2X1 U329_C1 (.A(U329_C1__n_2), .B(U329_C1__n), .Y(N8916));
  XNOR2X1 U414_C1 (.A(\trans_cnt[2] ), .B(U487_C1__n), .Y(N10315));
  OR4X1 U491_C3_3 (.A(n334), .B(n332), .C(n327), .D(\cnt0_4[2] ), .Y(U369_C1__n));
  INVX1 U305_C1_MP_INV_1 (.A(U329_C1__n_1), .Y(U329_C1__n_2));
  OAI2BB2X1 U415_C4_1 (.A0N(U329_C1__n_1), .A1N(N10682), .B0(n342), .B1(N8780), 
     .Y(N11498));
  NAND2X1 U467_C3_3 (.A(U372_C1__n_1), .B(N11523), .Y(U467_C3__n));
  SDFFSRX1 cnt1_8_reg_3_ (.CK(clk0_5), .D(N8917), .Q(\cnt1_8[3] ), .QN(n198), 
     .RN(N10047_1), .SE(test_se_2), .SI(\cnt1_8[2] ), .SN(VDD));
  SDFFRHQX1 cnt1_8_reg_4_ (.CK(clk0_4), .D(N8897), .Q(\cnt1_8[4] ), 
     .RN(N10047_1), .SE(test_se_2), .SI(\cnt1_8[3] ));
  AND2X1 U365_C1 (.A(U470_C1__n), .B(N246), .Y(N8897));
  SDFFSRX1 scon_reg_1_ (.CK(clk0_5), .D(N8896), .Q(scon[1]), .QN(n343), 
     .RN(N10047), .SE(test_se), .SI(scon[0]), .SN(VDD));
  SDFFSRX1 scon_reg_2_ (.CK(clk0_5), .D(N10878), .Q(scon[2]), .QN(n214), 
     .RN(N10047), .SE(test_se), .SI(scon[1]), .SN(VDD));
  NAND2X1 U380_C4_4 (.A(\sbuf_txd[9] ), .B(N10117), .Y(N6530));
  SDFFSRX1 sbuf_txd_reg_6_ (.CK(clk0_5), .D(N9010), .Q(\sbuf_txd[6] ), 
     .QN(n3080), .RN(N10047), .SE(test_se_2), .SI(\sbuf_txd[5] ), .SN(VDD));
  SDFFSRX1 sbuf_txd_reg_8_ (.CK(clk0_5), .D(N10923), .Q(\sbuf_txd[8] ), 
     .QN(n307), .RN(N10047), .SE(test_se_2), .SI(\sbuf_txd[7] ), .SN(VDD));
  AND4X1 U352_C1_7 (.A(n321), .B(n320), .C(n3090), .D(n3080), .Y(N11184_7));
  AND2X1 U504_C1 (.A(U504_C1__n), .B(U369_C1__n), .Y(N10314));
  NAND2X1 U405_C4_2 (.A(in_sfr_1_1), .B(N10118_1), .Y(N1586));
  AND2X1 U506_C1 (.A(U506_C1__n), .B(U369_C1__n), .Y(N11277));
  OAI2BB1X1 U401_C5_2 (.A0N(in_sfr_1_1), .A1N(N10031), .B0(N4067), .Y(N8896));
  INVX1 U401_C5_4_MP_INV (.A(N10031), .Y(N10031_1));
  OAI211X1 U375_C4_8 (.A0(n319), .A1(U303_C1__n), .B0(N1381), .C0(N10813_1), 
     .Y(N10813));
  NOR2X2 U291_C1 (.A(addr_sfr_0_1), .B(U288_C2__n), .Y(N10031));
  OAI21X1 U397_C3_1 (.A0(n202), .A1(N8761), .B0(N2156), .Y(N8762));
  SDFFSRX1 scon_reg_6_ (.CK(clk0_5), .D(N9983), .Q(scon[6]), .QN(n330), 
     .RN(N10047), .SE(test_se), .SI(scon[5]), .SN(VDD));
  NOR2BX1 U421_C3_5 (.AN(N11311), .B(N11184), .Y(N10560_1));
  INVX1 U418_C3_1_MP_INV (.A(N11899), .Y(N11899_1));
  NOR3X1 U408_C2_2 (.A(n215), .B(U407_C2__n), .C(U372_C1__n), .Y(U329_C1__n_1));
  AOI22X1 U405_C4_6 (.A0(in_sfr[0]), .A1(N8914), .B0(\sbuf_txd[2] ), .B1(N10117), 
     .Y(N8747_1));
  AND4X1 U352_C1_9 (.A(n305), .B(n301), .C(N11184_7), .D(N11184_6), .Y(N11184));
  NAND3BX1 U425_C3_7 (.AN(U407_C2__n), .B(tx_done), .C(N11899), .Y(N7566));
  OAI222X1 U409_C4_10 (.A0(U333_C1__n_1), .A1(N10924), .B0(n297), .B1(N10117_1), 
     .C0(n300), .C1(U303_C1__n), .Y(N9012));
  SDFFSRX1 shift_rec_reg (.CK(clk0_5), .D(N8921), .Q(n66), .QN(n322), 
     .RN(N10047_1), .SE(test_se_2), .SI(n20), .SN(VDD));
  SDFFSRX1 sbuf_rxd_tmp_reg_10_ (.CK(clk0_5), .D(N11807), .Q(n130), .QN(n316), 
     .RN(N10047_1), .SE(test_se), .SI(n127), .SN(VDD));
  MXI2X1 U473_C3_2 (.A(smod_clk_rec), .B(n350), .S0(N8842), .Y(N8843));
  NAND2X1 U400_C3_2 (.A(in_sfr[0]), .B(N8761), .Y(N1387));
  MXI2X1 U472_C3_2 (.A(smod_clk_trans), .B(n349), .S0(N12145), .Y(N8915));
  BUFX8 BW2_BUF12335 (.A(test_se_1), .Y(test_se_2));
  SDFFSRX1 sbuf_rxd_tmp_reg_8_ (.CK(clk0_5), .D(N8799), .Q(n118), .QN(n315), 
     .RN(N10047_1), .SE(test_se), .SI(\sbuf_rxd_tmp[7] ), .SN(VDD));
  BUFX8 BW2_BUF10047 (.A(N10047), .Y(N10047_1));
  BUFX1 BL1_BUF290 (.A(in_sfr[1]), .Y(in_sfr_1_1));
  OAI21X1 U379_C3_1 (.A0(n344), .A1(N8761), .B0(N8525), .Y(N9984));
  BUFX1 BL1_BUF174 (.A(in_sfr[6]), .Y(in_sfr_6_1));
  BUFX1 BL1_BUF191 (.A(in_sfr[7]), .Y(in_sfr_7_1));
  SDFFSRX2 pcon_reg_7_ (.CK(clk0_5), .D(N9984), .Q(pcon[7]), .QN(n344), 
     .RN(N10047), .SE(test_se), .SI(pcon[6]), .SN(VDD));
  NOR2BX1 U288_C2 (.AN(addr_sfr_0_1), .B(U288_C2__n), .Y(U333_C1__n));
  INVX1 U311_C2_2_MP_INV_1 (.A(U372_C1__n), .Y(U372_C1__n_1));
  AND3X1 U493_C2_2 (.A(n334), .B(n332), .C(U493_C2__n), .Y(N8925));
  AOI31X1 U402_C5_6 (.A0(n311), .A1(n298), .A2(N9247), .B0(N10031), .Y(N8427_1));
  OAI221X1 U424_C4_5 (.A0(N11184), .A1(N11183_2), .B0(trans), .B1(U333_C1__n), 
     .C0(N8916), .Y(N11311));
  OAI22X1 U334_C3_1 (.A0(n299), .A1(N8796), .B0(n316), .B1(U309_C1__n_2), 
     .Y(N11807));
  AND2X1 U368_C1 (.A(U470_C1__n), .B(N243), .Y(N8903));
  OAI22X1 U474_C3_1 (.A0(n298), .A1(n212), .B0(rx_done), .B1(n303), .Y(N8830));
  NOR2BX1 U312_C1 (.AN(U336_C2__n_3), .B(n298), .Y(U446_C1__n));
  SDFFSRX1 smod_clk_trans_reg (.CK(clk0_5), .D(N8915), .Q(smod_clk_trans), 
     .QN(n349), .RN(N10047_1), .SE(test_se), .SI(smod_clk_rec), .SN(VDD));
  BUFX1 BL1_ASSIGN_BUF22 (.A(test_so2), .Y(sbuf[5]));
  SDFFSRX1 sbuf_rxd_reg_3_ (.CK(clk0_4), .D(N8832), .Q(sbuf[3]), .QN(n209), 
     .RN(N10047_1), .SE(test_se), .SI(sbuf[2]), .SN(VDD));
  AOI21X1 U485_C1_1 (.A0(scon[7]), .A1(n330), .B0(tf1), .Y(U473_C3__n));
  INVX1 U309_C1_MP_INV (.A(U311_C2__n), .Y(U311_C2__n_1));
  NOR3X1 U156_C3_4 (.A(\rec_cnt[1] ), .B(n336), .C(U446_C1__n_1), 
     .Y(U156_C3__n_4));
  NOR3X1 U450_C1_3 (.A(\rec_cnt[3] ), .B(n326), .C(U446_C1__n_1), .Y(N12304_3));
  OAI221X1 U342_C4_5 (.A0(n3140), .A1(N8796), .B0(n339), .B1(U309_C1__n_2), 
     .C0(N8786), .Y(N8753));
  OAI221X1 U343_C4_5 (.A0(n304), .A1(U309_C1__n_2), .B0(n339), .B1(N8796), 
     .C0(N8786), .Y(N9001));
  AND4X1 U281_C5_15 (.A(\sbuf_rxd_tmp[1] ), .B(n316), .C(n315), .D(n303), 
     .Y(N10585_9));
  SDFFSRX1 sbuf_rxd_tmp_reg_6_ (.CK(clk0_5), .D(N9002), .Q(\sbuf_rxd_tmp[6] ), 
     .QN(n337), .RN(N10047_1), .SE(test_se), .SI(\sbuf_rxd_tmp[5] ), .SN(VDD));
  OAI221X1 U344_C4_5 (.A0(n3120), .A1(N8796), .B0(n337), .B1(U309_C1__n_2), 
     .C0(N8786), .Y(N9002));
  AND4X1 U284_C3_3 (.A(wr), .B(addr_sfr[7]), .C(addr_sfr_4_1), .D(addr_sfr_3_1), 
     .Y(U282_C1__n));
  BUFX1 BL1_BUF402 (.A(addr_sfr[4]), .Y(addr_sfr_4_1));
  NOR2BX1 U285_C1_4 (.AN(addr_sfr_1_1), .B(addr_sfr_3_1), .Y(N8761_4));
  BUFX1 BL1_BUF420 (.A(addr_sfr[3]), .Y(addr_sfr_3_1));
  NAND2BX1 U484_C1 (.AN(U484_C1__n_4), .B(n359), .Y(U470_C1__n));
  NOR3X1 U338_C2_2 (.A(n359), .B(n322), .C(U372_C1__n), .Y(U336_C2__n_3));
  OAI2BB2X1 U356_C4_1 (.A0N(U446_C1__n), .A1N(N8756), .B0(n335), .B1(N7410), 
     .Y(N7526));
  AND2X1 U470_C1 (.A(U470_C1__n), .B(N249), .Y(N12278));
  XNOR2X1 U453_C1 (.A(n331), .B(N11497), .Y(N8744));
  INVX1 U450_C1_3_MP_INV (.A(U446_C1__n), .Y(U446_C1__n_1));
  NAND3BX1 U446_C1_4 (.AN(\rec_cnt[2] ), .B(N11440_3), .C(n326), .Y(N11440));
  SDFFSRX1 rx_same_reg_0_ (.CK(clk0_4), .D(N12303), .Q(\rx_same[0] ), .QN(n340), 
     .RN(N10047_1), .SE(test_se_2), .SI(rx_done), .SN(VDD));
  OAI221X1 U348_C4_5 (.A0(n3140), .A1(U309_C1__n_2), .B0(n338), .B1(N8796), 
     .C0(N8786), .Y(N11572));
  NAND2X1 U310_C1 (.A(U311_C2__n), .B(U309_C1__n_2), .Y(N8786));
  AND3X1 U439_C2_2 (.A(shift12), .B(rec_sync), .C(U372_C1__n), .Y(U336_C2__n));
  AOI211X1 U156_C3_7 (.A0(U156_C3__n_4), .A1(U156_C3__n_3), .B0(U460_C5__n), 
     .C0(U156_C3__n), .Y(U309_C1__n));
  AOI22X1 U375_C4_6 (.A0(in_sfr_6_1), .A1(N8914), .B0(\sbuf_txd[8] ), 
     .B1(N10117), .Y(N10813_1));
  OR2X1 U509_C1 (.A(scon[1]), .B(scon[0]), .Y(uart_int));
  SDFFSRX1 cnt0_4_reg_3_ (.CK(clk0_5), .D(N8927), .Q(n50), .QN(n332), 
     .RN(N10047), .SE(test_se_2), .SI(\cnt0_4[2] ), .SN(VDD));
  SDFFRHQX1 cnt1_8_reg_1_ (.CK(clk0_5), .D(N8903), .Q(\cnt1_8[1] ), 
     .RN(N10047_1), .SE(test_se_2), .SI(\cnt1_8[0] ));
  AOI21X2 U303_C1_1 (.A0(U329_C1__n_2), .A1(N11183_2), .B0(U303_C1__n_1), 
     .Y(N10117));
  XOR2X1 U416_C1 (.A(\trans_cnt[1] ), .B(\trans_cnt[0] ), .Y(N10682));
  NOR2X1 U487_C1 (.A(n348), .B(U487_C1__n), .Y(N11557));
  XOR2X1 U494_C1 (.A(n327), .B(\cnt0_4[2] ), .Y(U493_C2__n));
  SDFFSRX1 sbuf_rxd_tmp_reg_11_ (.CK(clk0_5), .D(N8760), .Q(\sbuf_rxd_tmp[11] ), 
     .QN(n299), .RN(N10047_1), .SE(test_se_2), .SI(n130), .SN(VDD));
  SDFFRHQX1 cnt1_8_reg_7_ (.CK(clk0_5), .D(N12278), .Q(\cnt1_8[7] ), 
     .RN(N10047_1), .SE(test_se_2), .SI(\cnt1_8[6] ));
  SDFFSRX1 div12_reg (.CK(clk0_5), .D(N8844), .Q(div12), .QN(n324), 
     .RN(N10047_1), .SE(test_se_2), .SI(\cnt1_8[7] ), .SN(VDD));
  NOR4BX1 U488_C1_4 (.AN(U484_C1__n_1), .B(\cnt1_8[6] ), .C(\cnt1_8[5] ), 
     .D(\cnt1_8[4] ), .Y(U484_C1__n_4));
  SDFFSRX1 tx_done_reg (.CK(clk0_5), .D(N8866), .Q(tx_done), .QN(n311), 
     .RN(N10047_1), .SE(test_se_1), .SI(trans), .SN(VDD));
  SDFFSRX1 shift_trans_reg (.CK(clk0_5), .D(N8924), .Q(test_so3), .QN(n215), 
     .RN(N10047_1), .SE(test_se_2), .SI(n66), .SN(VDD));
  AOI22X1 U373_C4_6 (.A0(in_sfr_2_1), .A1(N8914), .B0(\sbuf_txd[4] ), 
     .B1(N10117), .Y(N9011_1));
  OAI22X1 U331_C3_1 (.A0(n297), .A1(U303_C1__n), .B0(n325), .B1(U333_C1__n_1), 
     .Y(N9921));
  SDFFSRX1 sbuf_txd_reg_3_ (.CK(clk0_5), .D(N9011), .Q(\sbuf_txd[3] ), .QN(n320), 
     .RN(N10047), .SE(test_se_2), .SI(\sbuf_txd[2] ), .SN(VDD));
  OAI211X1 U387_C4_8 (.A0(n3090), .A1(U303_C1__n), .B0(N1421), .C0(N11211_1), 
     .Y(N11211));
  XNOR2X1 U505_C1 (.A(\cnt0_4[2] ), .B(U503_C1__n), .Y(U504_C1__n));
  NAND2X1 U483_C1 (.A(test_so1), .B(\cnt0_4[1] ), .Y(U503_C1__n));
  SDFFSRX1 trans_cnt_reg_0_ (.CK(clk0_5), .D(N8745), .Q(\trans_cnt[0] ), 
     .QN(n346), .RN(N10047_1), .SE(test_se_2), .SI(n56), .SN(VDD));
  SDFFSRX1 sbuf_txd_reg_4_ (.CK(clk0_5), .D(N11211), .Q(\sbuf_txd[4] ), 
     .QN(n3090), .RN(N10047), .SE(test_se_2), .SI(\sbuf_txd[3] ), .SN(VDD));
  NAND2X1 U387_C4_2 (.A(in_sfr_4_1), .B(N10118_1), .Y(N1421));
  OAI21X1 U395_C3_1 (.A0(n345), .A1(N10031), .B0(N6718), .Y(N7733));
  INVX3 U508_C1 (.A(rc8051RtlTop_test_point_535_in), .Y(N10047));
  SDFFSRX1 pcon_reg_5_ (.CK(clk0_5), .D(N8870), .Q(pcon[5]), .QN(n204), 
     .RN(N10047), .SE(test_se), .SI(pcon[4]), .SN(VDD));
  AND4X1 U352_C1_6 (.A(n319), .B(n307), .C(n300), .D(n297), .Y(N11184_6));
  SDFFSRX1 pcon_reg_1_ (.CK(clk0_5), .D(N8677), .Q(pcon[1]), .QN(n200), 
     .RN(N10047), .SE(test_se), .SI(pcon[0]), .SN(VDD));
  SDFFSRX1 trans_reg (.CK(clk0_5), .D(N8749), .Q(trans), .QN(n318), 
     .RN(N10047_1), .SE(test_se_2), .SI(\trans_cnt[3] ), .SN(VDD));
  AOI31X1 U281_C5_20 (.A0(\sbuf_txd[8] ), .A1(n300), .A2(n297), .B0(receive), 
     .Y(N1871_1));
  NOR3X1 U407_C2_2 (.A(n196), .B(U407_C2__n), .C(U372_C1__n_1), .Y(N11183));
  NAND2X1 U333_C1 (.A(U372_C1__n), .B(U333_C1__n), .Y(N10118));
  XNOR2X1 U502_C1 (.A(n332), .B(N9020), .Y(U501_C1__n));
  INVX1 U409_C4_10_MP_INV (.A(N10117), .Y(N10117_1));
  SDFFX1 trans1_reg (.CK(clk0_5), .D(trans), .Q(trans1), .QN(), .SE(test_se_2), 
     .SI(smod_clk_trans));
  MXI2X1 U391_C1_2 (.A(n299), .B(n214), .S0(N10359), .Y(N8831));
  OAI22X1 U335_C3_1 (.A0(n303), .A1(U309_C1__n_2), .B0(n316), .B1(N8796), 
     .Y(N10423));
  SDFFSX1 shift12_1_reg (.CK(clk0_5), .D(shift12), .Q(n20), .QN(n196), 
     .SE(test_se_1), .SI(scon[7]), .SN(VDD));
  NAND2X1 U318_C3_2 (.A(in_sfr_5_1), .B(N10031), .Y(N1580));
  AOI2BB1X1 U370_C1_1 (.A0N(smod_clk_trans), .A1N(pcon[7]), .B0(U473_C3__n), 
     .Y(N8924));
  SDFFSRX1 scon_reg_4_ (.CK(clk0_5), .D(N8826), .Q(scon[4]), .QN(n306), 
     .RN(N10047_1), .SE(test_se), .SI(scon[3]), .SN(VDD));
  SDFFSRX1 sbuf_rxd_reg_7_ (.CK(clk0_5), .D(N10032), .Q(sbuf[7]), .QN(n213), 
     .RN(N10047_1), .SE(test_se), .SI(sbuf[6]), .SN(VDD));
  OAI21X1 U400_C3_1 (.A0(n199), .A1(N8761), .B0(N1387), .Y(N10360));
  NAND2X1 U377_C3_2 (.A(in_sfr_6_1), .B(N8761), .Y(N9994));
  BUFX1 BL1_BUF208 (.A(in_sfr[5]), .Y(in_sfr_5_1));
  NAND2X1 U317_C3_2 (.A(in_sfr_6_1), .B(N10031), .Y(N11057));
  NAND2X1 U398_C3_2 (.A(in_sfr_2_1), .B(N8761), .Y(N8582));
  BUFX1 BL1_BUF268 (.A(in_sfr[2]), .Y(in_sfr_2_1));
  SDFFSRX1 trans_cnt_reg_2_ (.CK(clk0_5), .D(N8806), .Q(\trans_cnt[2] ), 
     .QN(n348), .RN(N10047), .SE(test_se_2), .SI(\trans_cnt[1] ), .SN(VDD));
  NOR2X2 U306_C1 (.A(U372_C1__n), .B(U333_C1__n_1), .Y(N8914));
  INVX1 U326_C5_6_MP_INV (.A(in_sfr[0]), .Y(in_sfr_0_1));
  SDFFSRX1 sbuf_rxd_tmp_reg_7_ (.CK(clk0_5), .D(N10906), .Q(\sbuf_rxd_tmp[7] ), 
     .QN(n3120), .RN(N10047_1), .SE(test_se), .SI(\sbuf_rxd_tmp[6] ), .SN(VDD));
  NOR2X1 U490_C3_2 (.A(\cnt1_8[1] ), .B(\cnt1_8[0] ), .Y(U488_C1__n_2));
  OAI221X1 U349_C4_5 (.A0(n303), .A1(N8796), .B0(n315), .B1(U309_C1__n_2), 
     .C0(U460_C5__n_2), .Y(N8799));
  SDFFSRX1 rec_cnt_reg_2_ (.CK(clk0_4), .D(N7526), .Q(\rec_cnt[2] ), .QN(n335), 
     .RN(N10047_1), .SE(test_se_2), .SI(\rec_cnt[1] ), .SN(VDD));
  NOR2BX1 U429_C4_5 (.AN(n359), .B(n298), .Y(N6107_2));
  SDFFSRX1 sbuf_rxd_reg_4_ (.CK(clk0_5), .D(N11973), .Q(sbuf[4]), .QN(n210), 
     .RN(N10047_1), .SE(test_se), .SI(sbuf[3]), .SN(VDD));
  OAI22X1 U477_C3_1 (.A0(n298), .A1(n209), .B0(rx_done), .B1(n337), .Y(N8832));
  OAI21X1 U318_C3_1 (.A0(n329), .A1(N10031), .B0(N1580), .Y(N8871));
  INVX1 U402_C5_8_MP_INV (.A(N9247_2), .Y(N9247));
  NOR3X1 U337_C2_2 (.A(n322), .B(n306), .C(U337_C2__n), .Y(U460_C5__n));
  NAND2X1 U440_C5_8 (.A(U309_C1__n_2), .B(N11467), .Y(N3071));
  OAI2BB1X1 U429_C4_1 (.A0N(rx_done), .A1N(U336_C2__n), .B0(N6107), 
     .Y(U156_C3__n));
  AND4X1 U281_C5_13 (.A(\sbuf_rxd_tmp[7] ), .B(\sbuf_rxd_tmp[4] ), 
     .C(\sbuf_rxd_tmp[0] ), .D(n299), .Y(N10585_7));
  AOI32X1 U281_C5_6 (.A0(N10585_9), .A1(N10585_8), .A2(N10585_7), 
     .B0(\sbuf_rxd_tmp[11] ), .B1(n304), .Y(N10441_1));
  SDFFSRX1 sbuf_rxd_reg_0_ (.CK(clk0_4), .D(N11228), .Q(sbuf[0]), .QN(n206), 
     .RN(N10047_1), .SE(test_se_2), .SI(n19), .SN(VDD));
  OAI221X1 U346_C4_5 (.A0(n302), .A1(U309_C1__n_2), .B0(n3130), .B1(N8796), 
     .C0(N8786), .Y(N10907));
  SDFFSRX1 sbuf_rxd_tmp_reg_5_ (.CK(clk0_5), .D(N11571), .Q(\sbuf_rxd_tmp[5] ), 
     .QN(n3130), .RN(N10047_1), .SE(test_se), .SI(\sbuf_rxd_tmp[4] ), .SN(VDD));
  BUFX1 BL1_BUF438 (.A(addr_sfr[5]), .Y(addr_sfr_5_1));
  NOR2BX1 U285_C1_1 (.AN(addr_sfr_0_1), .B(addr_sfr_4_1), .Y(N8761_1));
  BUFX1 BL1_BUF330 (.A(addr_sfr[0]), .Y(addr_sfr_0_1));
  INVX1 U448_C3_1_MP_INV (.A(rxdi), .Y(rxdi_1));
  NOR2X1 U454_C1 (.A(n335), .B(N8781), .Y(N11497));
  OAI2BB1X1 U464_C3_4 (.A0N(rx_done), .A1N(receive), .B0(N8867_1), .Y(N8867));
  OAI2BB2X1 U452_C4_1 (.A0N(U446_C1__n), .A1N(N8744), .B0(n331), .B1(N7410), 
     .Y(N8751));
  NAND2X1 U481_C1 (.A(\rec_cnt[1] ), .B(\rec_cnt[0] ), .Y(N8781));
  XNOR2X1 U357_C1 (.A(\rec_cnt[2] ), .B(N8781), .Y(N8756));
  NAND2X1 U450_C1_4 (.A(N12304_3), .B(N12304_2), .Y(N12304));
  SDFFSRX1 sbuf_rxd_tmp_reg_4_ (.CK(clk0_4), .D(N10907), .Q(\sbuf_rxd_tmp[4] ), 
     .QN(n302), .RN(N10047_1), .SE(test_se), .SI(\sbuf_rxd_tmp[3] ), .SN(VDD));
  SDFFSRX1 rx_same_reg_1_ (.CK(clk0_4), .D(N11439), .Q(\rx_same[1] ), .QN(n3100), 
     .RN(N10047_1), .SE(test_se_2), .SI(\rx_same[0] ), .SN(VDD));
  NOR2BX1 U336_C2 (.AN(U336_C2__n_1), .B(U336_C2__n), .Y(U311_C2__n));
  SDFFSRX1 sbuf_rxd_tmp_reg_1_ (.CK(clk0_4), .D(N8753), .Q(\sbuf_rxd_tmp[1] ), 
     .QN(n339), .RN(N10047_1), .SE(test_se_2), .SI(\sbuf_rxd_tmp[0] ), .SN(VDD));
  OAI21X1 U440_C5_5 (.A0(\rx_same[1] ), .A1(\rx_same[0] ), .B0(U446_C1__n), 
     .Y(N8453));
  SDFFSRX1 rec_cnt_reg_0_ (.CK(clk0_4), .D(N10049), .Q(\rec_cnt[0] ), .QN(n336), 
     .RN(N10047_1), .SE(test_se_2), .SI(pcon[7]), .SN(VDD));
  OAI211X1 U383_C4_8 (.A0(n3080), .A1(U303_C1__n), .B0(N9010_1), .C0(N2802), 
     .Y(N9010));
  SDFFSRX1 sbuf_txd_reg_1_ (.CK(clk0_5), .D(N8747), .Q(n70), .QN(n305), 
     .RN(N10047), .SE(test_se_2), .SI(\sbuf_txd[0] ), .SN(VDD));
  SDFFSRX1 trans_cnt_reg_3_ (.CK(clk0_5), .D(N10683), .Q(\trans_cnt[3] ), 
     .QN(n347), .RN(N10047_1), .SE(test_se_2), .SI(\trans_cnt[2] ), .SN(VDD));
  OAI2BB2X1 U411_C4_1 (.A0N(U329_C1__n_1), .A1N(N8755), .B0(n347), .B1(N8780), 
     .Y(N10683));
  SDFFSRX1 trans_cnt_reg_1_ (.CK(clk0_5), .D(N11498), .Q(\trans_cnt[1] ), 
     .QN(n342), .RN(N10047_1), .SE(test_se_2), .SI(\trans_cnt[0] ), .SN(VDD));
  AND2X1 U501_C1 (.A(U501_C1__n), .B(U369_C1__n), .Y(N8927));
  NAND2X1 U482_C1 (.A(\trans_cnt[1] ), .B(\trans_cnt[0] ), .Y(U487_C1__n));
  SDFFSRX1 cnt0_4_reg_0_ (.CK(clk0_5), .D(n334), .Q(test_so1), .QN(n334), 
     .RN(N10047), .SE(test_se_2), .SI(test_si1), .SN(VDD));
  SDFFSX2 rx_done_reg (.CK(clk0_5), .D(N9985), .Q(rx_done), .QN(n298), 
     .SE(test_se_2), .SI(receive), .SN(N10047_1));
  SDFFRHQX1 cnt1_8_reg_6_ (.CK(clk0_4), .D(N8928), .Q(\cnt1_8[6] ), 
     .RN(N10047_1), .SE(test_se_2), .SI(\cnt1_8[5] ));
  NOR4BX1 U488_C1_1 (.AN(U488_C1__n_2), .B(n198), .C(\cnt1_8[7] ), 
     .D(\cnt1_8[2] ), .Y(U484_C1__n_1));
  AND2X1 U367_C1 (.A(U470_C1__n), .B(N244), .Y(N10812));
  SDFFSRX1 sbuf_txd_reg_9_ (.CK(clk0_5), .D(N9012), .Q(\sbuf_txd[9] ), .QN(n300), 
     .RN(N10047), .SE(test_se), .SI(\sbuf_txd[8] ), .SN(VDD));
  OAI211X1 U380_C4_7 (.A0(n307), .A1(U303_C1__n), .B0(N6530), .C0(N10923_2), 
     .Y(N10923));
  NOR2X1 U503_C1 (.A(n333), .B(U503_C1__n), .Y(N9020));
  SDFFSRX1 sbuf_txd_reg_5_ (.CK(clk0_5), .D(N11210), .Q(\sbuf_txd[5] ), 
     .QN(n321), .RN(N10047), .SE(test_se_2), .SI(\sbuf_txd[4] ), .SN(VDD));
  NAND2X1 U373_C4_2 (.A(in_sfr_3_1), .B(N10118_1), .Y(N7286));
  AOI22X1 U389_C4_6 (.A0(in_sfr_1_1), .A1(N8914), .B0(\sbuf_txd[3] ), 
     .B1(N10117), .Y(N8835_1));
  XOR2X1 U507_C1 (.A(test_so1), .B(\cnt0_4[1] ), .Y(U506_C1__n));
  NAND2X1 U389_C4_2 (.A(in_sfr_2_1), .B(N10118_1), .Y(N3845));
  OAI211X1 U373_C4_8 (.A0(n320), .A1(U303_C1__n), .B0(N9011_1), .C0(N7286), 
     .Y(N9011));
  AOI22X1 U385_C4_6 (.A0(in_sfr_4_1), .A1(N8914), .B0(\sbuf_txd[6] ), 
     .B1(N10117), .Y(N11210_1));
  NAND2X1 U395_C3_2 (.A(in_sfr_3_1), .B(N10031), .Y(N6718));
  AOI21X1 U380_C4_6 (.A0(in_sfr_7_1), .A1(U333_C1__n), .B0(N10118_1), 
     .Y(N10923_2));
  SDFFSRX1 pcon_reg_3_ (.CK(clk0_5), .D(N8762), .Q(pcon[3]), .QN(n202), 
     .RN(N10047), .SE(test_se), .SI(pcon[2]), .SN(VDD));
  OAI21X1 U396_C3_1 (.A0(n203), .A1(N8761), .B0(N1843), .Y(N8763));
  NAND2X1 U399_C3_2 (.A(in_sfr_1_1), .B(N8761), .Y(N10484));
  INVX1 U387_C4_2_MP_INV (.A(N10118), .Y(N10118_1));
  OAI211X1 U418_C3_1 (.A0(n328), .A1(N11183), .B0(N11899_1), .C0(N11184), 
     .Y(N11313));
  OAI222X1 U326_C5_6 (.A0(in_sfr_0_1), .A1(N10118), .B0(n305), .B1(N10117_1), 
     .C0(n328), .C1(U303_C1__n), .Y(N8904));
  OR2X1 U327_C1 (.A(n318), .B(U333_C1__n), .Y(U407_C2__n));
  OAI2BB1X1 U418_C3_3 (.A0N(trans), .A1N(N11313), .B0(U333_C1__n_1), .Y(N8749));
  SDFFX1 trans2_reg (.CK(clk0_5), .D(trans1), .Q(trans2), .QN(), .SE(test_se_2), 
     .SI(trans1));
  OAI21X1 U425_C3_1 (.A0(\sbuf_txd[0] ), .A1(N8916), .B0(N11183_2), .Y(N11898));
  SDFFSRX1 sbuf_txd_reg_10_ (.CK(clk0_5), .D(N9921), .Q(n132), .QN(n297), 
     .RN(N10047), .SE(test_se), .SI(\sbuf_txd[9] ), .SN(VDD));
  SDFFSRX1 scon_reg_7_ (.CK(clk0_5), .D(N8827), .Q(scon[7]), .QN(n325), 
     .RN(N10047), .SE(test_se), .SI(scon[6]), .SN(VDD));
  OR2X1 U473_C3 (.A(pcon[7]), .B(U473_C3__n), .Y(N8842));
  NOR3X1 U402_C5_8 (.A(\sbuf_rxd_tmp[11] ), .B(n329), .C(U372_C1__n), 
     .Y(N9247_2));
  NOR2X2 U432_C1 (.A(scon[7]), .B(scon[6]), .Y(U372_C1__n));
  AOI22X1 U409_C4_2 (.A0(scon[6]), .A1(n325), .B0(scon[7]), .B1(scon[3]), 
     .Y(N10924));
  SDFFSRX1 pcon_reg_0_ (.CK(clk0_5), .D(N10360), .Q(pcon[0]), .QN(n199), 
     .RN(N10047), .SE(test_se), .SI(div12), .SN(VDD));
  OAI22X1 U475_C3_1 (.A0(n298), .A1(n211), .B0(rx_done), .B1(n315), .Y(N8829));
  OAI21X1 U398_C3_1 (.A0(n201), .A1(N8761), .B0(N8582), .Y(N8811));
  OAI21X1 U317_C3_1 (.A0(n330), .A1(N10031), .B0(N11057), .Y(N9983));
  NAND2X1 U397_C3_2 (.A(in_sfr_3_1), .B(N8761), .Y(N2156));
  BUFX1 BL1_BUF247 (.A(in_sfr[4]), .Y(in_sfr_4_1));
  NAND2X1 U379_C3_2 (.A(in_sfr_7_1), .B(N8761), .Y(N8525));
  OAI21X1 U377_C3_1 (.A0(n205), .A1(N8761), .B0(N9994), .Y(N11974));
  u_uart_DW01_inc_8_0 add_160 (.A({\cnt1_8[7] , \cnt1_8[6] , \cnt1_8[5] , 
     \cnt1_8[4] , \cnt1_8[3] , \cnt1_8[2] , \cnt1_8[1] , \cnt1_8[0] }), .SUM({
     N249, N248, N247, N246, N245, N244, N243, N242}));
  SDFFSRX1 txd_reg (.CK(clk0_5), .D(U421_C3__n), .Q(test_so4), .QN(n323), 
     .RN(N10047_1), .SE(test_se_1), .SI(tx_done), .SN(VDD));
  NAND2X1 U305_C1 (.A(U333_C1__n_1), .B(U329_C1__n_2), .Y(N8780));
  NAND3BX1 U458_C2_2 (.AN(tx_done), .B(U372_C1__n_1), .C(n298), .Y(N10359));
  MXI2X1 U4_C5_2 (.A(n324), .B(n323), .S0(N11985), .Y(txdo_1));
  XOR2X1 U492_C1 (.A(div12), .B(N8925), .Y(N8844));
  SDFFSRX1 sbuf_rxd_reg_2_ (.CK(clk0_4), .D(N8869), .Q(sbuf[2]), .QN(n208), 
     .RN(N10047_1), .SE(test_se), .SI(sbuf[1]), .SN(VDD));
  SDFFSRX1 rec_cnt_reg_3_ (.CK(clk0_4), .D(N8751), .Q(\rec_cnt[3] ), .QN(n331), 
     .RN(N10047_1), .SE(test_se_2), .SI(\rec_cnt[2] ), .SN(VDD));
  SDFFSRX1 scon_reg_5_ (.CK(clk0_5), .D(N8871), .Q(scon[5]), .QN(n329), 
     .RN(N10047_1), .SE(test_se), .SI(scon[4]), .SN(VDD));
  SDFFSRX1 sbuf_rxd_reg_6_ (.CK(clk0_5), .D(N8830), .Q(sbuf[6]), .QN(n212), 
     .RN(N10047_1), .SE(test_se), .SI(test_si3), .SN(VDD));
  BUFX1 BW1_BUF247_9 (.A(test_se), .Y(test_se_1));
  SDFFSRX1 sbuf_rxd_reg_5_ (.CK(clk0_5), .D(N8829), .Q(test_so2), .QN(n211), 
     .RN(N10047), .SE(test_se), .SI(sbuf[4]), .SN(VDD));
  AND3X1 U464_C3_9 (.A(scon[4]), .B(U372_C1__n), .C(U311_C2__n), .Y(N8535_3));
  MXI2X1 U358_C4_1 (.A(N7410), .B(U446_C1__n_1), .S0(n336), .Y(N10049));
  INVX2 U309_C1_MP_INV_1 (.A(U309_C1__n), .Y(U309_C1__n_2));
  OAI21X1 U460_C5_1 (.A0(scon[4]), .A1(U337_C2__n), .B0(U460_C5__n_2), .Y(N8791));
  NAND3X1 U311_C2_2 (.A(rx_done), .B(U372_C1__n_1), .C(U311_C2__n), 
     .Y(U337_C2__n));
  NAND4X1 U467_C3_9 (.A(rx_done), .B(n304), .C(U467_C3__n), .D(U311_C2__n_1), 
     .Y(N9985));
  OAI22X1 U480_C3_1 (.A0(n298), .A1(n206), .B0(rx_done), .B1(n338), .Y(N11228));
  OAI221X1 U345_C4_5 (.A0(n3130), .A1(U309_C1__n_2), .B0(n337), .B1(N8796), 
     .C0(N8786), .Y(N11571));
  NOR4BBX1 U285_C1_6 (.AN(wr), .BN(addr_sfr_2_1), .C(addr_sfr_5_1), 
     .D(addr_sfr_6_1), .Y(N8761_6));
  NAND4BBX1 U282_C1_4 (.AN(addr_sfr_1_1), .BN(addr_sfr_6_1), .C(U282_C1__n), 
     .D(U288_C2__n_2), .Y(U288_C2__n));
  BUFX1 BL1_BUF348 (.A(addr_sfr[6]), .Y(addr_sfr_6_1));
  NOR2X1 U282_C1_2 (.A(addr_sfr_5_1), .B(addr_sfr_2_1), .Y(U288_C2__n_2));
  AND2X1 U366_C1 (.A(U470_C1__n), .B(N245), .Y(N8917));
  BUFX3 BW1_BUF8678 (.A(txdo_1), .Y(txdo));
  SDFFRHQX1 rec_sync_reg (.CK(clk0_4), .D(N8922), .Q(rec_sync), .RN(N10047_1), 
     .SE(test_se_2), .SI(\rec_cnt[3] ));
  AND2X1 U361_C1 (.A(U470_C1__n), .B(N248), .Y(N8928));
  INVX1 U488_C1_4_MP_INV (.A(U484_C1__n_4), .Y(U484_C1__n));
  NOR2X1 U450_C1_2 (.A(n336), .B(n335), .Y(N12304_2));
  MXI2X1 U448_C3_1 (.A(rxdi_1), .B(n340), .S0(N12304), .Y(N12303));
  OAI221X1 U350_C4_5 (.A0(n3120), .A1(U309_C1__n_2), .B0(n315), .B1(N8796), 
     .C0(N8786), .Y(N10906));
  SDFFSRX1 sbuf_rxd_tmp_reg_2_ (.CK(clk0_4), .D(N11572), .Q(\sbuf_rxd_tmp[2] ), 
     .QN(n3140), .RN(N10047_1), .SE(test_se_2), .SI(\sbuf_rxd_tmp[1] ), 
     .SN(VDD));
  INVX1 U298_C1_MP_INV (.A(U460_C5__n), .Y(U460_C5__n_2));
  NAND2BX1 U440_C5_4 (.AN(U336_C2__n), .B(N8453), .Y(N11468));
  AOI33X1 U464_C3_3 (.A0(n317), .A1(rx_done), .A2(N8535_3), .B0(rxdi_1), 
     .B1(n19), .B2(U460_C5__n), .Y(N8867_1));
  OAI2BB1X1 U401_C5_4 (.A0N(n343), .A1N(n311), .B0(N10031_1), .Y(N4067));
  AOI22X1 U383_C4_6 (.A0(in_sfr_5_1), .A1(N8914), .B0(\sbuf_txd[7] ), 
     .B1(N10117), .Y(N9010_1));
  MXI2X1 U417_C4_1 (.A(N8780), .B(U329_C1__n_2), .S0(n346), .Y(N8745));
  SDFFRHQX1 cnt1_8_reg_0_ (.CK(clk0_5), .D(N10493), .Q(\cnt1_8[0] ), 
     .RN(N10047_1), .SE(test_se_2), .SI(n50));
  NAND2X1 U385_C4_2 (.A(in_sfr_5_1), .B(N10118_1), .Y(N9112));
  INVX1 U303_C1_1_MP_INV (.A(U303_C1__n), .Y(U303_C1__n_1));
  OAI2BB2X1 U413_C4_1 (.A0N(U329_C1__n_1), .A1N(N10315), .B0(n348), .B1(N8780), 
     .Y(N8806));
  XNOR2X1 U412_C1 (.A(n347), .B(N11557), .Y(N8755));
  XOR2X1 U456_C1 (.A(\rec_cnt[1] ), .B(\rec_cnt[0] ), .Y(N8746));
  SDFFRHQX1 cnt1_8_reg_5_ (.CK(clk0_4), .D(N12103), .Q(\cnt1_8[5] ), 
     .RN(N10047_1), .SE(test_se_2), .SI(\cnt1_8[4] ));
  AND2X1 U364_C1 (.A(U470_C1__n), .B(N247), .Y(N12103));
  SDFFRHQX1 cnt1_8_reg_2_ (.CK(clk0_5), .D(N10812), .Q(\cnt1_8[2] ), 
     .RN(N10047_1), .SE(test_se_2), .SI(\cnt1_8[1] ));
  SDFFSRX1 scon_reg_0_ (.CK(clk0_5), .D(U402_C5__n), .Q(scon[0]), .QN(n317), 
     .RN(N10047), .SE(test_se), .SI(n132), .SN(VDD));
  OAI22X1 U479_C3_1 (.A0(n298), .A1(n207), .B0(rx_done), .B1(n302), .Y(N9052));
  SDFFSRX1 cnt0_4_reg_2_ (.CK(clk0_5), .D(N10314), .Q(\cnt0_4[2] ), .QN(n333), 
     .RN(N10047), .SE(test_se_2), .SI(\cnt0_4[1] ), .SN(VDD));
  AOI22X1 U387_C4_6 (.A0(in_sfr_3_1), .A1(N8914), .B0(\sbuf_txd[5] ), 
     .B1(N10117), .Y(N11211_1));
  SDFFSRX1 scon_reg_3_ (.CK(clk0_5), .D(N7733), .Q(scon[3]), .QN(n345), 
     .RN(N10047), .SE(test_se), .SI(scon[2]), .SN(VDD));
  SDFFSRX1 cnt0_4_reg_1_ (.CK(clk0_5), .D(N11277), .Q(\cnt0_4[1] ), .QN(n327), 
     .RN(N10047), .SE(test_se_2), .SI(test_si2), .SN(VDD));
  OAI211X1 U389_C4_8 (.A0(n301), .A1(U303_C1__n), .B0(N8835_1), .C0(N3845), 
     .Y(N8835));
  SDFFSRX1 sbuf_txd_reg_7_ (.CK(clk0_5), .D(N10813), .Q(\sbuf_txd[7] ), 
     .QN(n319), .RN(N10047), .SE(test_se_2), .SI(\sbuf_txd[6] ), .SN(VDD));
  INVX1 U424_C4_5_MP_INV (.A(N11183), .Y(N11183_2));
  NAND2X1 U383_C4_2 (.A(in_sfr_6_1), .B(N10118_1), .Y(N2802));
  OAI211X1 U385_C4_8 (.A0(n321), .A1(U303_C1__n), .B0(N9112), .C0(N11210_1), 
     .Y(N11210));
  NAND2X1 U375_C4_2 (.A(in_sfr_7_1), .B(N10118_1), .Y(N1381));
  OAI21X1 U316_C3_1 (.A0(n325), .A1(N10031), .B0(N10293), .Y(N8827));
  SDFFSRX1 pcon_reg_4_ (.CK(clk0_5), .D(N8763), .Q(pcon[4]), .QN(n203), 
     .RN(N10047), .SE(test_se), .SI(pcon[3]), .SN(VDD));
  SDFFSRX1 sbuf_txd_reg_0_ (.CK(clk0_5), .D(N8904), .Q(\sbuf_txd[0] ), .QN(n328), 
     .RN(N10047), .SE(test_se_2), .SI(\sbuf_rxd_tmp[11] ), .SN(VDD));
  OAI21X1 U399_C3_1 (.A0(n200), .A1(N8761), .B0(N10484), .Y(N8677));
  NOR2X1 U421_C3_6 (.A(\sbuf_txd[0] ), .B(n318), .Y(N10560_2));
  AOI2BB1X1 U332_C3_1 (.A0N(U329_C1__n_2), .A1N(U329_C1__n), .B0(N11183), 
     .Y(N11899));
  OAI2BB1X1 U425_C3_2 (.A0N(N11898), .A1N(N11184), .B0(N7566), .Y(N8866));
  OAI211X1 U405_C4_8 (.A0(n305), .A1(U303_C1__n), .B0(N8747_1), .C0(N1586), 
     .Y(N8747));
  SDFFSRX1 sbuf_txd_reg_2_ (.CK(clk0_5), .D(N8835), .Q(\sbuf_txd[2] ), .QN(n301), 
     .RN(N10047), .SE(test_se_2), .SI(n70), .SN(VDD));
  INVX1 U305_C1_MP_INV (.A(U333_C1__n), .Y(U333_C1__n_1));
  AOI2BB2X1 U421_C3_2 (.A0N(test_so4), .A1N(N11311), .B0(N10560_2), 
     .B1(N10560_1), .Y(U421_C3__n));
  MX2X1 U391_C1_5 (.A(N8831), .B(in_sfr_2_1), .S0(N10031), .Y(N10878));
  SDFFSRX1 smod_clk_rec_reg (.CK(clk0_5), .D(N8843), .Q(smod_clk_rec), .QN(n350), 
     .RN(N10047_1), .SE(test_se), .SI(test_si4), .SN(VDD));
  OR2X1 U472_C3 (.A(pcon[7]), .B(U473_C3__n), .Y(N12145));
  SDFFSRX1 pcon_reg_6_ (.CK(clk0_5), .D(N11974), .Q(pcon[6]), .QN(n205), 
     .RN(N10047), .SE(test_se), .SI(pcon[5]), .SN(VDD));
  NAND2BX1 U372_C1 (.AN(test_so4), .B(U372_C1__n), .Y(rxdo));
  SDFFSRX1 sbuf_rxd_tmp_reg_9_ (.CK(clk0_5), .D(N10423), .Q(n127), .QN(n303), 
     .RN(N10047_1), .SE(test_se), .SI(n118), .SN(VDD));
  OAI22X1 U471_C3_1 (.A0(n298), .A1(n213), .B0(rx_done), .B1(n316), .Y(N10032));
  SDFFSRX1 pcon_reg_2_ (.CK(clk0_5), .D(N8811), .Q(pcon[2]), .QN(n201), 
     .RN(N10047), .SE(test_se), .SI(pcon[1]), .SN(VDD));
  NAND2X1 U378_C3_2 (.A(in_sfr_5_1), .B(N8761), .Y(N7138));
  OAI21X1 U378_C3_1 (.A0(n204), .A1(N8761), .B0(N7138), .Y(N8870));
  NAND2X1 U396_C3_2 (.A(in_sfr_4_1), .B(N8761), .Y(N1843));
  NAND2X1 U324_C3_2 (.A(in_sfr_4_1), .B(N10031), .Y(N7862));
  NAND2X1 U316_C3_2 (.A(in_sfr_7_1), .B(N10031), .Y(N10293));
endmodule

// Entity:u_uart_DW01_inc_8_0 Model:u_uart_DW01_inc_8_0 Library:L0
module u_uart_DW01_inc_8_0 (A, SUM);
  input [7:0] A;
  output [7:0] SUM;
  wire carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;
  ADDHX1 U1_1_5 (.A(A[5]), .B(carry_5_), .CO(carry_6_), .S(SUM[5]));
  INVX1 U6_C1 (.A(A[0]), .Y(SUM[0]));
  ADDHX1 U1_1_1 (.A(A[1]), .B(A[0]), .CO(carry_2_), .S(SUM[1]));
  ADDHX1 U1_1_2 (.A(A[2]), .B(carry_2_), .CO(carry_3_), .S(SUM[2]));
  ADDHX1 U1_1_3 (.A(A[3]), .B(carry_3_), .CO(carry_4_), .S(SUM[3]));
  ADDHX1 U1_1_4 (.A(A[4]), .B(carry_4_), .CO(carry_5_), .S(SUM[4]));
  ADDHX1 U1_1_6 (.A(A[6]), .B(carry_6_), .CO(carry_7_), .S(SUM[6]));
  XOR2X1 U5_C1 (.A(carry_7_), .B(A[7]), .Y(SUM[7]));
endmodule
