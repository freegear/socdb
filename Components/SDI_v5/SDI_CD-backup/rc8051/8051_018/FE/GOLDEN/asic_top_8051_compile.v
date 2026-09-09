
module asic_top_8051 ( PI_clk, PI_rst_p, PI_int0, PI_int1, PI_t0, PI_t1, 
        PI_rxd, PB_p1_io, PO_rom_adr, PI_rom_data, PO_addr_xdat, PB_xdat, 
        PO_txd, PO_clkb, PO_en_xdat, PO_wr_xdat, PO_rd_xdat );
  inout [7:0] PB_p1_io;
  output [15:0] PO_rom_adr;
  input [7:0] PI_rom_data;
  output [15:0] PO_addr_xdat;
  inout [7:0] PB_xdat;
  input PI_clk, PI_rst_p, PI_int0, PI_int1, PI_t0, PI_t1, PI_rxd;
  output PO_txd, PO_clkb, PO_en_xdat, PO_wr_xdat, PO_rd_xdat;
  wire   n107, n0_clk, n0_rst_p, n0_int0, n0_t0, n0_t1, n0_rxd, n7_p1_en,
         n6_p1_en, n5_p1_en, n4_p1_en, n3_p1_en, n2_p1_en, n1_p1_en, n0_p1_en,
         n7_rom_data, n6_rom_data, n5_rom_data, n4_rom_data, n3_rom_data,
         n2_rom_data, n1_rom_data, n0_rom_data, n7_xdat_o, n0_xdat_i,
         n6_xdat_o, n1_xdat_i, n5_xdat_o, n2_xdat_i, n4_xdat_o, n3_xdat_i,
         n3_xdat_o, n4_xdat_i, n2_xdat_o, n5_xdat_i, n1_xdat_o, n6_xdat_i,
         n0_xdat_o, n7_xdat_i, n185, n186, n187, n188, n189, n190, n191, n192,
         n193, n194, n195, n196, n197, n198, n199, n200, n201, n202, n203,
         n204, n205, n206, n207, n208, n209, n210, n211, n212, n213, n214,
         n215, n216, n217, n218, n219, n220, n111;

  PDISDGZ U0_clk ( .PAD(PI_clk), .C(n0_clk) );
  PDISDGZ U1_rst_p ( .PAD(PI_rst_p), .C(n0_rst_p) );
  pc8051_top U68_pc8051_top ( .clk(n0_clk), .rst_p(n0_rst_p), .int0_i(n0_int0), 
        .int1_i(n0_int0), .all_t0_i(n0_t0), .all_t1_i(n0_t1), .all_rxd_i(
        n0_rxd), .p1_i({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .p1_en({n7_p1_en, n6_p1_en, n5_p1_en, n4_p1_en, n3_p1_en, n2_p1_en, 
        n1_p1_en, n0_p1_en}), .all_txd_o(n217), .clkb(n107), .rom_adr_o({n185, 
        n186, n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197, 
        n198, n199, n200}), .rom_data_i({n7_rom_data, n6_rom_data, n5_rom_data, 
        n4_rom_data, n3_rom_data, n2_rom_data, n1_rom_data, n0_rom_data}), 
        .addr_xdat({n201, n202, n203, n204, n205, n206, n207, n208, n209, n210, 
        n211, n212, n213, n214, n215, n216}), .out_xdat({n7_xdat_o, n6_xdat_o, 
        n5_xdat_o, n4_xdat_o, n3_xdat_o, n2_xdat_o, n1_xdat_o, n0_xdat_o}), 
        .in_xdat_a({n7_xdat_i, n6_xdat_i, n5_xdat_i, n4_xdat_i, n3_xdat_i, 
        n2_xdat_i, n1_xdat_i, n0_xdat_i}), .en_xdat(n218), .wr_xdat_d1(n219), 
        .rd_xdat(n220) );
  BUFX6 U66 ( .A(n219), .Y(n111) );
  PDISDGZ U67 ( .PAD(PI_int0), .C(n0_int0) );
  PDISDGZ U68 ( .PAD(PI_t0), .C(n0_t0) );
  PDISDGZ U69 ( .PAD(PI_t1), .C(n0_t1) );
  PDISDGZ U70 ( .PAD(PI_rxd), .C(n0_rxd) );
  PDB24SDGZ U71 ( .I(1'b0), .OEN(n7_p1_en), .PAD(PB_p1_io[7]) );
  PDB24SDGZ U72 ( .I(1'b0), .OEN(n6_p1_en), .PAD(PB_p1_io[6]) );
  PDB24SDGZ U73 ( .I(1'b0), .OEN(n5_p1_en), .PAD(PB_p1_io[5]) );
  PDB24SDGZ U74 ( .I(1'b0), .OEN(n4_p1_en), .PAD(PB_p1_io[4]) );
  PDB24SDGZ U75 ( .I(1'b0), .OEN(n3_p1_en), .PAD(PB_p1_io[3]) );
  PDB24SDGZ U76 ( .I(1'b0), .OEN(n2_p1_en), .PAD(PB_p1_io[2]) );
  PDB24SDGZ U77 ( .I(1'b0), .OEN(n1_p1_en), .PAD(PB_p1_io[1]) );
  PDB24SDGZ U78 ( .I(1'b0), .OEN(n0_p1_en), .PAD(PB_p1_io[0]) );
  PDO24CDG U79 ( .I(n185), .PAD(PO_rom_adr[15]) );
  PDO24CDG U80 ( .I(n186), .PAD(PO_rom_adr[14]) );
  PDO24CDG U81 ( .I(n187), .PAD(PO_rom_adr[13]) );
  PDO24CDG U82 ( .I(n188), .PAD(PO_rom_adr[12]) );
  PDO24CDG U83 ( .I(n189), .PAD(PO_rom_adr[11]) );
  PDO24CDG U84 ( .I(n190), .PAD(PO_rom_adr[10]) );
  PDO24CDG U85 ( .I(n191), .PAD(PO_rom_adr[9]) );
  PDO24CDG U86 ( .I(n192), .PAD(PO_rom_adr[8]) );
  PDO24CDG U87 ( .I(n193), .PAD(PO_rom_adr[7]) );
  PDO24CDG U88 ( .I(n194), .PAD(PO_rom_adr[6]) );
  PDO24CDG U89 ( .I(n195), .PAD(PO_rom_adr[5]) );
  PDO24CDG U90 ( .I(n196), .PAD(PO_rom_adr[4]) );
  PDO24CDG U91 ( .I(n197), .PAD(PO_rom_adr[3]) );
  PDO24CDG U92 ( .I(n198), .PAD(PO_rom_adr[2]) );
  PDO24CDG U93 ( .I(n199), .PAD(PO_rom_adr[1]) );
  PDO24CDG U94 ( .I(n200), .PAD(PO_rom_adr[0]) );
  PDISDGZ U95 ( .PAD(PI_rom_data[7]), .C(n7_rom_data) );
  PDISDGZ U96 ( .PAD(PI_rom_data[6]), .C(n6_rom_data) );
  PDISDGZ U97 ( .PAD(PI_rom_data[5]), .C(n5_rom_data) );
  PDISDGZ U98 ( .PAD(PI_rom_data[4]), .C(n4_rom_data) );
  PDISDGZ U99 ( .PAD(PI_rom_data[3]), .C(n3_rom_data) );
  PDISDGZ U100 ( .PAD(PI_rom_data[2]), .C(n2_rom_data) );
  PDISDGZ U101 ( .PAD(PI_rom_data[1]), .C(n1_rom_data) );
  PDISDGZ U102 ( .PAD(PI_rom_data[0]), .C(n0_rom_data) );
  PDO24CDG U103 ( .I(n201), .PAD(PO_addr_xdat[15]) );
  PDO24CDG U104 ( .I(n202), .PAD(PO_addr_xdat[14]) );
  PDO24CDG U105 ( .I(n203), .PAD(PO_addr_xdat[13]) );
  PDO24CDG U106 ( .I(n204), .PAD(PO_addr_xdat[12]) );
  PDO24CDG U107 ( .I(n205), .PAD(PO_addr_xdat[11]) );
  PDO24CDG U108 ( .I(n206), .PAD(PO_addr_xdat[10]) );
  PDO24CDG U109 ( .I(n207), .PAD(PO_addr_xdat[9]) );
  PDO24CDG U110 ( .I(n208), .PAD(PO_addr_xdat[8]) );
  PDO24CDG U111 ( .I(n209), .PAD(PO_addr_xdat[7]) );
  PDO24CDG U112 ( .I(n210), .PAD(PO_addr_xdat[6]) );
  PDO24CDG U113 ( .I(n211), .PAD(PO_addr_xdat[5]) );
  PDO24CDG U114 ( .I(n212), .PAD(PO_addr_xdat[4]) );
  PDO24CDG U115 ( .I(n213), .PAD(PO_addr_xdat[3]) );
  PDO24CDG U116 ( .I(n214), .PAD(PO_addr_xdat[2]) );
  PDO24CDG U117 ( .I(n215), .PAD(PO_addr_xdat[1]) );
  PDO24CDG U118 ( .I(n216), .PAD(PO_addr_xdat[0]) );
  PDB24SDGZ U119 ( .I(n7_xdat_o), .OEN(n111), .PAD(PB_xdat[7]), .C(n0_xdat_i)
         );
  PDB24SDGZ U120 ( .I(n6_xdat_o), .OEN(n111), .PAD(PB_xdat[6]), .C(n1_xdat_i)
         );
  PDB24SDGZ U121 ( .I(n5_xdat_o), .OEN(n111), .PAD(PB_xdat[5]), .C(n2_xdat_i)
         );
  PDB24SDGZ U122 ( .I(n4_xdat_o), .OEN(n111), .PAD(PB_xdat[4]), .C(n3_xdat_i)
         );
  PDB24SDGZ U123 ( .I(n3_xdat_o), .OEN(n111), .PAD(PB_xdat[3]), .C(n4_xdat_i)
         );
  PDB24SDGZ U124 ( .I(n2_xdat_o), .OEN(n111), .PAD(PB_xdat[2]), .C(n5_xdat_i)
         );
  PDB24SDGZ U125 ( .I(n1_xdat_o), .OEN(n111), .PAD(PB_xdat[1]), .C(n6_xdat_i)
         );
  PDB24SDGZ U126 ( .I(n0_xdat_o), .OEN(n111), .PAD(PB_xdat[0]), .C(n7_xdat_i)
         );
  PDO24CDG U127 ( .I(n217), .PAD(PO_txd) );
  PDO04CDG U128 ( .I(n107), .PAD(PO_clkb) );
  PDO24CDG U129 ( .I(n218), .PAD(PO_en_xdat) );
  PDO24CDG U130 ( .I(n111), .PAD(PO_wr_xdat) );
  PDO24CDG U131 ( .I(n220), .PAD(PO_rd_xdat) );
endmodule


module pc8051_top ( clk, rst_p, int0_i, int1_i, all_t0_i, all_t1_i, all_rxd_i, 
        p1_i, p1_o, p1_en, all_txd_o, clkb, rom_adr_o, rom_data_i, addr_xdat, 
        out_xdat, in_xdat_a, en_xdat, wr_xdat_d1, rd_xdat );
  input [7:0] p1_i;
  output [7:0] p1_o;
  output [7:0] p1_en;
  output [15:0] rom_adr_o;
  input [7:0] rom_data_i;
  output [15:0] addr_xdat;
  output [7:0] out_xdat;
  input [7:0] in_xdat_a;
  input clk, rst_p, int0_i, int1_i, all_t0_i, all_t1_i, all_rxd_i;
  output all_txd_o, clkb, en_xdat, wr_xdat_d1, rd_xdat;
  wire   ale_d1, ale, wr_xdat, wr_idat, rd_idat, idat_en, n2, n3, n4, n5, n6,
         n7, n8, n9, n10, n11, n12;
  wire   [7:0] xaddr_low;
  wire   [7:0] xaddr_high;
  wire   [7:0] in_idat_a;
  wire   [7:0] p0_i;
  wire   [7:0] p2_i;
  wire   [7:0] p3_i;
  wire   [7:0] addr_a;
  wire   [7:0] out_idat;

  u_cpu U3_cpu ( .clk(clk), .rst_p(rst_p), .in_xrom_a(rom_data_i), .in_idat_a(
        in_idat_a), .in_xdat_a(in_xdat_a), .p0_in({1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0}), .p1_in(p1_i), .p2_in({1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0}), .p3_in({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0}), .rxdi(all_rxd_i), .t0_pin(all_t0_i), .t1_pin(all_t1_i), 
        .int0_pin(int0_i), .int1_pin(int1_i), .addr_xrom_a(rom_adr_o), 
        .addr_a(addr_a), .out_idat(out_idat), .wr_idat(wr_idat), .rd_idat(
        rd_idat), .xaddr_high(xaddr_high), .out_xdat(out_xdat), .ale(ale), 
        .p1_out(p1_o), .p1_en(p1_en), .wr_xdat(wr_xdat), .rd_xdat(rd_xdat), 
        .txdo(all_txd_o) );
  spsram_256x8 spsram_256x8 ( .Q(in_idat_a), .CLK(clkb), .CEN(idat_en), .WEN(
        wr_idat), .A(addr_a), .D(out_idat) );
  AND2X2 U16 ( .A(wr_idat), .B(rd_idat), .Y(idat_en) );
  AND2X2 U17 ( .A(wr_xdat), .B(rd_xdat), .Y(n3) );
  AO22X2 U18 ( .A0(out_xdat[1]), .A1(ale_d1), .B0(xaddr_low[1]), .B1(n12), .Y(
        n5) );
  AO22X2 U19 ( .A0(out_xdat[2]), .A1(ale_d1), .B0(xaddr_low[2]), .B1(n12), .Y(
        n6) );
  AO22X2 U20 ( .A0(out_xdat[0]), .A1(ale_d1), .B0(xaddr_low[0]), .B1(n12), .Y(
        n4) );
  AO22X2 U21 ( .A0(out_xdat[3]), .A1(ale_d1), .B0(xaddr_low[3]), .B1(n12), .Y(
        n7) );
  AO22X2 U22 ( .A0(out_xdat[4]), .A1(ale_d1), .B0(xaddr_low[4]), .B1(n12), .Y(
        n8) );
  AO22X2 U23 ( .A0(out_xdat[5]), .A1(ale_d1), .B0(xaddr_low[5]), .B1(n12), .Y(
        n9) );
  AO22X2 U24 ( .A0(out_xdat[6]), .A1(ale_d1), .B0(xaddr_low[6]), .B1(n12), .Y(
        n10) );
  AO22X2 U25 ( .A0(out_xdat[7]), .A1(ale_d1), .B0(xaddr_low[7]), .B1(n12), .Y(
        n11) );
  CLKINVX1 U26 ( .A(clk), .Y(clkb) );
  CLKINVX1 U27 ( .A(rst_p), .Y(n2) );
  DFFRX1 ale_d1_reg ( .D(ale), .CK(clk), .RN(n2), .Q(ale_d1), .QN(n12) );
  DFFRX1 xaddr_low_reg_0_ ( .D(n4), .CK(clk), .RN(n2), .Q(xaddr_low[0]) );
  DFFRX1 xaddr_low_reg_1_ ( .D(n5), .CK(clk), .RN(n2), .Q(xaddr_low[1]) );
  DFFRX1 xaddr_low_reg_2_ ( .D(n6), .CK(clk), .RN(n2), .Q(xaddr_low[2]) );
  DFFRX1 xaddr_low_reg_3_ ( .D(n7), .CK(clk), .RN(n2), .Q(xaddr_low[3]) );
  DFFRX1 xaddr_low_reg_4_ ( .D(n8), .CK(clk), .RN(n2), .Q(xaddr_low[4]) );
  DFFRX1 xaddr_low_reg_5_ ( .D(n9), .CK(clk), .RN(n2), .Q(xaddr_low[5]) );
  DFFRX1 xaddr_low_reg_6_ ( .D(n10), .CK(clk), .RN(n2), .Q(xaddr_low[6]) );
  DFFRX1 xaddr_low_reg_7_ ( .D(n11), .CK(clk), .RN(n2), .Q(xaddr_low[7]) );
  DFFSX2 wr_xdat_d1_reg ( .D(wr_xdat), .CK(clk), .SN(n2), .Q(wr_xdat_d1) );
  DFFRX1 addr_xdat_reg_0_ ( .D(xaddr_low[0]), .CK(clk), .RN(n2), .Q(
        addr_xdat[0]) );
  DFFRX1 addr_xdat_reg_1_ ( .D(xaddr_low[1]), .CK(clk), .RN(n2), .Q(
        addr_xdat[1]) );
  DFFRX1 addr_xdat_reg_2_ ( .D(xaddr_low[2]), .CK(clk), .RN(n2), .Q(
        addr_xdat[2]) );
  DFFRX1 addr_xdat_reg_3_ ( .D(xaddr_low[3]), .CK(clk), .RN(n2), .Q(
        addr_xdat[3]) );
  DFFRX1 addr_xdat_reg_4_ ( .D(xaddr_low[4]), .CK(clk), .RN(n2), .Q(
        addr_xdat[4]) );
  DFFRX1 addr_xdat_reg_5_ ( .D(xaddr_low[5]), .CK(clk), .RN(n2), .Q(
        addr_xdat[5]) );
  DFFRX1 addr_xdat_reg_6_ ( .D(xaddr_low[6]), .CK(clk), .RN(n2), .Q(
        addr_xdat[6]) );
  DFFRX1 addr_xdat_reg_7_ ( .D(xaddr_low[7]), .CK(clk), .RN(n2), .Q(
        addr_xdat[7]) );
  DFFRX1 addr_xdat_reg_8_ ( .D(xaddr_high[0]), .CK(clk), .RN(n2), .Q(
        addr_xdat[8]) );
  DFFRX1 addr_xdat_reg_9_ ( .D(xaddr_high[1]), .CK(clk), .RN(n2), .Q(
        addr_xdat[9]) );
  DFFRX1 addr_xdat_reg_10_ ( .D(xaddr_high[2]), .CK(clk), .RN(n2), .Q(
        addr_xdat[10]) );
  DFFRX1 addr_xdat_reg_11_ ( .D(xaddr_high[3]), .CK(clk), .RN(n2), .Q(
        addr_xdat[11]) );
  DFFRX1 addr_xdat_reg_12_ ( .D(xaddr_high[4]), .CK(clk), .RN(n2), .Q(
        addr_xdat[12]) );
  DFFRX1 addr_xdat_reg_13_ ( .D(xaddr_high[5]), .CK(clk), .RN(n2), .Q(
        addr_xdat[13]) );
  DFFRX1 addr_xdat_reg_14_ ( .D(xaddr_high[6]), .CK(clk), .RN(n2), .Q(
        addr_xdat[14]) );
  DFFRX1 addr_xdat_reg_15_ ( .D(xaddr_high[7]), .CK(clk), .RN(n2), .Q(
        addr_xdat[15]) );
  DFFSX2 en_xdat_reg ( .D(n3), .CK(clk), .SN(n2), .Q(en_xdat) );
endmodule


module u_cpu ( clk, rst_p, in_xrom_a, in_idat_a, in_xdat_a, p0_in, p1_in, 
        p2_in, p3_in, rxdi, t0_pin, t1_pin, int0_pin, int1_pin, addr_xrom_a, 
        psen, addr_a, out_idat, wr_idat, rd_idat, xaddr_high, out_xdat, ale, 
        p0_out, p1_out, p2_out, p3_out, p0_en, p1_en, p2_en, p3_en, wr_xdat, 
        rd_xdat, rxdo, txdo, xdat_en, sel_code_xdat );
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
  input clk, rst_p, rxdi, t0_pin, t1_pin, int0_pin, int1_pin;
  output psen, wr_idat, rd_idat, ale, wr_xdat, rd_xdat, rxdo, txdo, xdat_en,
         sel_code_xdat;
  wire   wr_idat_p, rd_idat_p, wr_xdat_p, rd_xdat_p, ale_neg, N1, en_int,
         msb_a, msb_r, cy, ac, ov, cy_psw, bit_dat_in_r, ld_instr, inc_pc,
         inc_pc2, inc_pc3, ld_pc, ld_pcl, ld_pch, ld_acc, ld_acc_chd,
         sel_addr0, wr_sfr, ld_dpl, ld_dph, inc_dptr, sel_xdat, sel_xaddr_low,
         sel_xaddr_high, inc_sp, dec_sp, ld_latch_acc, set_c, rst_c, cpl_c,
         ld_c, set_ac, rst_ac, set_v, rst_v, ld_b, en_div, sel_page_addr,
         bit_addr, rmw, reti, end_instr, ld_operand2, ld_xrom, ld_idat, ld_sfr,
         ld_apc, ld_adptr, n100, n4, n6, n8, n1000, n12, n14, n16, n18, n20,
         n22, n24, n26, n28, n30, n32, n34, n36, n38, n40, n42, n44, n46, n48,
         n50, n52, n54, n56, n58, n60, n62, n64, n66;
  wire   [7:0] code;
  wire   [7:0] out_acc_r;
  wire   [7:0] combus;
  wire   [7:0] out_dimod_r;
  wire   [7:0] in_xrom1_r;
  wire   [3:0] sel_combus;
  wire   [2:0] sel_addr1;
  wire   [2:0] sel_op1;
  wire   [2:0] sel_op2;
  wire   [2:0] sel_pc;
  wire   [4:0] sel_alu;
  wire   [2:0] addr_bank_a;
  wire   [1:0] sel_bit_dat_out;
  wire   [2:0] sel_in_cy_bit;

  u_con U0_con ( .code(code), .clk(clk), .rst_p(rst_p), .en_int(en_int), 
        .msb_a(msb_a), .msb_r(msb_r), .cy(cy), .ac(ac), .ov(ov), .out_acc_r(
        out_acc_r), .cy_psw(cy_psw), .combus(combus), .out_dimod_r(out_dimod_r), .in_xrom1_r(in_xrom1_r), .bit_dat_in_r(bit_dat_in_r), .ld_instr(ld_instr), 
        .wr_idat(wr_idat_p), .rd_idat(rd_idat_p), .end_instr(end_instr), 
        .ld_pc(ld_pc), .ld_pcl(ld_pcl), .ld_pch(ld_pch), .ld_acc(ld_acc), 
        .ld_acc_chd(ld_acc_chd), .inc_pc(inc_pc), .inc_pc2(inc_pc2), .inc_pc3(
        inc_pc3), .sel_combus(sel_combus), .sel_addr0(sel_addr0), .sel_addr1(
        sel_addr1), .wr_sfr(wr_sfr), .ld_dpl(ld_dpl), .ld_dph(ld_dph), 
        .inc_dptr(inc_dptr), .wr_xdat(wr_xdat_p), .rd_xdat(rd_xdat_p), .ale(
        ale_neg), .sel_xad(sel_xdat), .sel_xaddr_low(sel_xaddr_low), 
        .sel_xaddr_high(sel_xaddr_high), .inc_sp(inc_sp), .dec_sp(dec_sp), 
        .ld_latch_acc(ld_latch_acc), .set_c(set_c), .rst_c(rst_c), .cpl_c(
        cpl_c), .ld_c(ld_c), .set_ac(set_ac), .rst_ac(rst_ac), .set_v(set_v), 
        .rst_v(rst_v), .sel_op1(sel_op1), .sel_op2(sel_op2), .ld_b(ld_b), 
        .en_div(en_div), .sel_pc(sel_pc), .sel_page_addr(sel_page_addr), 
        .bit_addr(bit_addr), .rmw(rmw), .sel_alu(sel_alu), .addr_bank_a(
        addr_bank_a), .sel_bit_dat_out(sel_bit_dat_out), .sel_in_cy_bit(
        sel_in_cy_bit), .reti(reti), .ld_xrom(ld_xrom), .ld_idat(ld_idat), 
        .ld_sfr(ld_sfr), .ld_operand2(ld_operand2), .sel_code_xdat(
        sel_code_xdat), .ld_adptr(ld_adptr), .ld_apc(ld_apc) );
  u_datapath U1_datapath ( .ld_apc(ld_apc), .ld_adptr(ld_adptr), .ld_xrom(
        ld_xrom), .ld_idat(ld_idat), .ld_sfr(ld_sfr), .ld_operand2(ld_operand2), .end_instr(end_instr), .clk(clk), .rst_p(rst_p), .ld_instr(ld_instr), 
        .inc_pc(inc_pc), .inc_pc2(inc_pc2), .inc_pc3(inc_pc3), .ld_pc(ld_pc), 
        .ld_pcl(ld_pcl), .ld_pch(ld_pch), .ld_acc(ld_acc), .ld_acc_chd(
        ld_acc_chd), .sel_addr0(sel_addr0), .sel_addr1(sel_addr1), .in_xrom_a(
        in_xrom_a), .in_idat_a(in_idat_a), .in_xdat_a(in_xdat_a), .sel_combus(
        sel_combus), .wr_sfr(wr_sfr), .ld_dpl(ld_dpl), .ld_dph(ld_dph), 
        .inc_dptr(inc_dptr), .sel_xad(sel_xdat), .sel_xaddr_high(
        sel_xaddr_high), .sel_xaddr_low(sel_xaddr_low), .inc_sp(inc_sp), 
        .dec_sp(dec_sp), .ld_latch_acc(ld_latch_acc), .set_c(set_c), .rst_c(
        rst_c), .cpl_c(cpl_c), .ld_c(ld_c), .set_ac(set_ac), .rst_ac(rst_ac), 
        .set_v(set_v), .rst_v(rst_v), .sel_op1(sel_op1), .sel_op2(sel_op2), 
        .ld_b(ld_b), .en_div(en_div), .sel_pc(sel_pc), .bit_addr(bit_addr), 
        .rmw(rmw), .t0_pin(t0_pin), .t1_pin(t1_pin), .int0_pin(int0_pin), 
        .int1_pin(int1_pin), .rxdi(rxdi), .addr_bank_a(addr_bank_a), .code(
        code), .sel_bit_dat_out(sel_bit_dat_out), .sel_in_cy_bit(sel_in_cy_bit), .p0_in(p0_in), .p1_in(p1_in), .p2_in(p2_in), .p3_in({1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1, 1'b1, 1'b1, 1'b1}), .sel_alu(sel_alu), .reti(reti), 
        .addr_xrom_a(addr_xrom_a), .addr_a(addr_a), .msb_a(msb_a), .msb_r(
        msb_r), .en_int(en_int), .xaddr_high(xaddr_high), .cy(cy), .ac(ac), 
        .ov(ov), .sel_page_addr(sel_page_addr), .out_acc_r(out_acc_r), 
        .cy_psw(cy_psw), .combus(combus), .out_dimod_r(out_dimod_r), 
        .in_xrom1_r(in_xrom1_r), .bit_dat_in_r(bit_dat_in_r), .p0_out(p0_out), 
        .p1_out(p1_out), .p2_out(p2_out), .p3_out(p3_out), .txdo(txdo), .rxdo(
        rxdo), .out_xdat(out_xdat), .out_idat(out_idat) );
  INVX1 U9 ( .A(1'b1), .Y(psen) );
  CLKINVX1 U11 ( .A(wr_idat_p), .Y(wr_idat) );
  CLKINVX1 U12 ( .A(rd_idat_p), .Y(rd_idat) );
  DFFRX1 ale_reg ( .D(ale_neg), .CK(N1), .RN(n100), .Q(ale) );
  DFFRX1 xdat_en_reg ( .D(wr_xdat), .CK(N1), .RN(n100), .Q(xdat_en) );
  CLKINVX1 U13 ( .A(n4), .Y(p3_en[0]) );
  CLKINVX1 U14 ( .A(n6), .Y(p3_en[1]) );
  CLKINVX1 U15 ( .A(n8), .Y(p3_en[2]) );
  CLKINVX1 U16 ( .A(n1000), .Y(p3_en[3]) );
  CLKINVX1 U17 ( .A(n12), .Y(p3_en[4]) );
  CLKINVX1 U18 ( .A(n14), .Y(p3_en[5]) );
  CLKINVX1 U19 ( .A(n16), .Y(p3_en[6]) );
  CLKINVX1 U20 ( .A(n18), .Y(p3_en[7]) );
  CLKINVX1 U21 ( .A(n20), .Y(p2_en[0]) );
  CLKINVX1 U22 ( .A(n22), .Y(p2_en[1]) );
  CLKINVX1 U23 ( .A(n24), .Y(p2_en[2]) );
  CLKINVX1 U24 ( .A(n26), .Y(p2_en[3]) );
  CLKINVX1 U25 ( .A(n28), .Y(p2_en[4]) );
  CLKINVX1 U26 ( .A(n30), .Y(p2_en[5]) );
  CLKINVX1 U27 ( .A(n32), .Y(p2_en[6]) );
  CLKINVX1 U28 ( .A(n34), .Y(p2_en[7]) );
  CLKINVX1 U29 ( .A(n52), .Y(p0_en[0]) );
  CLKINVX1 U30 ( .A(n54), .Y(p0_en[1]) );
  CLKINVX1 U31 ( .A(n56), .Y(p0_en[2]) );
  CLKINVX1 U32 ( .A(n58), .Y(p0_en[3]) );
  CLKINVX1 U33 ( .A(n60), .Y(p0_en[4]) );
  CLKINVX1 U34 ( .A(n62), .Y(p0_en[5]) );
  CLKINVX1 U35 ( .A(n64), .Y(p0_en[6]) );
  CLKINVX1 U36 ( .A(n66), .Y(p0_en[7]) );
  CLKINVX1 U37 ( .A(wr_xdat_p), .Y(wr_xdat) );
  CLKINVX1 U38 ( .A(rd_xdat_p), .Y(rd_xdat) );
  CLKINVX1 U39 ( .A(clk), .Y(N1) );
  CLKINVX1 U40 ( .A(rst_p), .Y(n100) );
  CLKINVX1 U41 ( .A(p3_out[0]), .Y(n4) );
  CLKINVX1 U42 ( .A(p3_out[1]), .Y(n6) );
  CLKINVX1 U43 ( .A(p3_out[2]), .Y(n8) );
  CLKINVX1 U44 ( .A(p3_out[3]), .Y(n1000) );
  CLKINVX1 U45 ( .A(p3_out[4]), .Y(n12) );
  CLKINVX1 U46 ( .A(p3_out[5]), .Y(n14) );
  CLKINVX1 U47 ( .A(p3_out[6]), .Y(n16) );
  CLKINVX1 U48 ( .A(p3_out[7]), .Y(n18) );
  CLKINVX1 U49 ( .A(p2_out[0]), .Y(n20) );
  CLKINVX1 U50 ( .A(p2_out[1]), .Y(n22) );
  CLKINVX1 U51 ( .A(p2_out[2]), .Y(n24) );
  CLKINVX1 U52 ( .A(p2_out[3]), .Y(n26) );
  CLKINVX1 U53 ( .A(p2_out[4]), .Y(n28) );
  CLKINVX1 U54 ( .A(p2_out[5]), .Y(n30) );
  CLKINVX1 U55 ( .A(p2_out[6]), .Y(n32) );
  CLKINVX1 U56 ( .A(p2_out[7]), .Y(n34) );
  CLKINVX1 U57 ( .A(p0_out[0]), .Y(n52) );
  CLKINVX1 U58 ( .A(p0_out[1]), .Y(n54) );
  CLKINVX1 U59 ( .A(p0_out[2]), .Y(n56) );
  CLKINVX1 U60 ( .A(p0_out[3]), .Y(n58) );
  CLKINVX1 U61 ( .A(p0_out[4]), .Y(n60) );
  CLKINVX1 U62 ( .A(p0_out[5]), .Y(n62) );
  CLKINVX1 U63 ( .A(p0_out[6]), .Y(n64) );
  CLKINVX1 U64 ( .A(p0_out[7]), .Y(n66) );
  CLKINVX1 U65 ( .A(n50), .Y(p1_en[7]) );
  CLKINVX1 U66 ( .A(p1_out[7]), .Y(n50) );
  CLKINVX1 U67 ( .A(n48), .Y(p1_en[6]) );
  CLKINVX1 U68 ( .A(p1_out[6]), .Y(n48) );
  CLKINVX1 U69 ( .A(n46), .Y(p1_en[5]) );
  CLKINVX1 U70 ( .A(p1_out[5]), .Y(n46) );
  CLKINVX1 U71 ( .A(n44), .Y(p1_en[4]) );
  CLKINVX1 U72 ( .A(p1_out[4]), .Y(n44) );
  CLKINVX1 U73 ( .A(n42), .Y(p1_en[3]) );
  CLKINVX1 U74 ( .A(p1_out[3]), .Y(n42) );
  CLKINVX1 U75 ( .A(n40), .Y(p1_en[2]) );
  CLKINVX1 U76 ( .A(p1_out[2]), .Y(n40) );
  CLKINVX1 U77 ( .A(n38), .Y(p1_en[1]) );
  CLKINVX1 U78 ( .A(p1_out[1]), .Y(n38) );
  CLKINVX1 U79 ( .A(n36), .Y(p1_en[0]) );
  CLKINVX1 U80 ( .A(p1_out[0]), .Y(n36) );
endmodule


module u_datapath ( ld_apc, ld_adptr, ld_xrom, ld_idat, ld_sfr, ld_operand2, 
        end_instr, clk, rst_p, ld_instr, inc_pc, inc_pc2, inc_pc3, ld_pc, 
        ld_pcl, ld_pch, ld_acc, ld_acc_chd, sel_addr0, sel_addr1, in_xrom_a, 
        in_idat_a, in_xdat_a, sel_combus, wr_sfr, ld_dpl, ld_dph, inc_dptr, 
        sel_xad, sel_xaddr_high, sel_xaddr_low, inc_sp, dec_sp, ld_latch_acc, 
        set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac, set_v, rst_v, sel_op1, 
        sel_op2, ld_b, en_div, sel_pc, bit_addr, rmw, t0_pin, t1_pin, int0_pin, 
        int1_pin, rxdi, addr_bank_a, code, sel_bit_dat_out, sel_in_cy_bit, 
        p0_in, p1_in, p2_in, p3_in, sel_alu, reti, addr_xrom_a, addr_a, msb_a, 
        msb_r, en_int, xaddr_high, cy, ac, ov, sel_page_addr, out_acc_r, 
        cy_psw, combus, out_dimod_r, in_xrom1_r, bit_dat_in_r, p0_out, p1_out, 
        p2_out, p3_out, txdo, rxdo, out_xdat, out_idat );
  input [2:0] sel_addr1;
  input [7:0] in_xrom_a;
  input [7:0] in_idat_a;
  input [7:0] in_xdat_a;
  input [3:0] sel_combus;
  input [2:0] sel_op1;
  input [2:0] sel_op2;
  input [2:0] sel_pc;
  input [2:0] addr_bank_a;
  output [7:0] code;
  input [1:0] sel_bit_dat_out;
  input [2:0] sel_in_cy_bit;
  input [7:0] p0_in;
  input [7:0] p1_in;
  input [7:0] p2_in;
  input [7:0] p3_in;
  input [4:0] sel_alu;
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
  input ld_apc, ld_adptr, ld_xrom, ld_idat, ld_sfr, ld_operand2, end_instr,
         clk, rst_p, ld_instr, inc_pc, inc_pc2, inc_pc3, ld_pc, ld_pcl, ld_pch,
         ld_acc, ld_acc_chd, sel_addr0, wr_sfr, ld_dpl, ld_dph, inc_dptr,
         sel_xad, sel_xaddr_high, sel_xaddr_low, inc_sp, dec_sp, ld_latch_acc,
         set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac, set_v, rst_v, ld_b, en_div,
         bit_addr, rmw, t0_pin, t1_pin, int0_pin, int1_pin, rxdi, reti,
         sel_page_addr;
  output msb_a, msb_r, en_int, cy, ac, ov, cy_psw, bit_dat_in_r, txdo, rxdo;
  wire   n1480, n1483, addr2_a_3_, addr2_a_2_, addr2_a_1_, out_psw_6_,
         out_psw_4_, out_psw_3_, N109, bit_dat_in, N110, in_cy_bit,
         latch_pc_7_, latch_pc_6_, latch_pc_5_, latch_pc_4_, latch_pc_3_,
         latch_pc_2_, latch_pc_1_, latch_pc_0_, op2_7_, op2_4_, op2_0_,
         latch_acc_7_, latch_acc_6_, latch_acc_5_, latch_acc_4_, latch_acc_3_,
         latch_acc_2_, latch_acc_1_, N309, N310, N311, N312, N313, N314, N315,
         N316, N317, N318, N319, N320, N321, N322, N323, N324, N327, N328,
         N329, N330, N331, N332, N333, N334, N335, N336, N337, N338, N339,
         N340, N341, N342, n1482, n1481, \out_idat0[0] , \out_idat0[1] ,
         \out_idat0[2] , \out_idat0[3] , \out_idat0[4] , \out_idat0[5] ,
         \out_idat0[6] , \out_idat0[7] , n10, n11, n12, n15, n23, n26, n33,
         n34, n37, n38, n41, n42, n45, n48, n52, n53, n61, n70, n76, n77, n78,
         n81, n82, n87, n90, n91, n98, n104, n105, n108, n11000, n114, n115,
         n117, n179, n223, n231, n242, n248, n251, n252, n253, n254, n269,
         n279, n281, n287, n294, n297, n3150, n3160, n3230, n3240, n3310,
         n3320, n3390, n3400, n347, n348, n355, n356, n359, n363, n372, n374,
         n375, n402, n403, n406, n407, n408, n409, n410, n411, n412, n432,
         n481, n482, n483, n484, n485, n486, n487, n488, n489, n491, n492,
         n493, n494, n495, n496, n497, n498, n499, n500, n501, n502, n503,
         n504, n505, n506, n507, n508, n509, n510, n511, n512, n513, n514,
         n515, n516, n517, n518, n519, n520, n521, n522, n523, n524, n525,
         n526, n527, n528, n529, n530, n531, n532, n533, n534, n535, n536,
         n537, n538, n539, n540, n541, n542, n543, n544, n545, n546, n547,
         n548, n549, n550, n551, n552, n553, n555, n556, n557, n558, n559,
         n560, n561, n562, n563, n564, n565, n566, n567, n568, n569, n570,
         n571, n572, n573, n574, n575, n576, n577, n578, n579, n580, n581,
         n582, n583, n584, n585, n586, n587, n588, n589, n590, n591, n592,
         n593, n594, n595, n596, n597, n598, n599, n600, n601, n602, n604,
         n605, n606, n607, n608, n609, n611, n612, n613, n614, n615, n616,
         n617, n618, n619, n620, n621, n622, n623, n624, n625, n626, n627,
         n628, n629, n630, n631, n632, n633, n634, n635, n636, n637, n638,
         n639, n640, n641, n642, n643, n644, n645, n646, n647, n648, n649,
         n650, n651, n652, n653, n654, n655, n656, n657, n658, n659, n660,
         n661, n662, n663, n664, n665, n666, n667, n668, n669, n670, n671,
         n672, n673, n674, n675, n676, n677, n678, n679, n680, n681, n682,
         n683, n684, n685, n686, n687, n688, n689, n690, n691, n692, n693,
         n694, n695, n696, n697, n698, n699, n700, n701, n702, n703, n704,
         n705, n706, n707, n708, n709, n710, n711, n712, n713, n714, n715,
         n716, n717, n718, n719, n720, n721, n722, n723, n724, n725, n728,
         n729, n730, n731, n732, n733, n734, n735, n736, n737, n738, n740,
         n741, n742, n743, n744, n745, n746, n747, n748, n749, n750, n751,
         n752, n753, n754, n755, n756, n757, n758, n759, n760, n761, n762,
         n763, n764, n765, n766, n767, n768, n769, n770, n771, n772, n773,
         n774, n775, n776, n777, n778, n779, n780, n781, n782, n783, n784,
         n785, n786, n787, n788, n789, n790, n791, n792, n793, n794, n795,
         n796, n797, n798, n799, n800, n801, n802, n803, n804, n805, n806,
         n807, n808, n809, n810, n811, n812, n813, n814, n815, n816, n817,
         n818, n819, n820, n821, n822, n823, n824, n825, n826, n827, n828,
         n829, n830, n831, n832, n833, n834, n835, n836, n837, n838, n839,
         n840, n841, n842, n843, n844, n845, n846, n847, n848, n849, n850,
         n851, n852, n853, n854, n855, n856, n857, n858, n859, n860, n861,
         n862, n863, n864, n865, n866, n867, n868, n869, n870, n871, n872,
         n873, n874, n875, n876, n877, n878, n879, n880, n881, n882, n883,
         n884, n885, n886, n887, n888, n889, n890, n891, n892, n893, n894,
         n895, n896, n897, n898, n899, n900, n901, n902, n903, n904, n905,
         n906, n907, n908, n909, n910, n911, n912, n913, n914, n915, n916,
         n917, n918, n919, n920, n921, n922, n923, n924, n925, n926, n927,
         n928, n929, n930, n931, n932, n933, n934, n935, n936, n937, n938,
         n939, n940, n941, n942, n943, n944, n945, n946, n947, n948, n949,
         n950, n951, n952, n953, n954, n955, n956, n957, n958, n959, n960,
         n961, n962, n963, n964, n965, n966, n967, n968, n969, n970, n971,
         n972, n973, n974, n975, n976, n977, n978, n979, n980, n981, n982,
         n983, n984, n985, n986, n987, n988, n989, n990, n991, n992, n993,
         n994, n995, n996, n997, n998, n999, n1000, n1001, n1002, n1003, n1004,
         n1005, n1006, n1007, n1008, n1009, n1010, n1011, n1012, n1013, n1014,
         n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022, n1023, n1024,
         n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032, n1033, n1034,
         n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042, n1043, n1044,
         n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052, n1053, n1054,
         n1055, n1056, n1057, n1058, n1059, n1060, n1061, n1062, n1063, n1064,
         n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072, n1073, n1074,
         n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082, n1083, n1084,
         n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092, n1093, n1094,
         n1095, n1096, n1097, n1098, n1099, n110000, n1101, n1102, n1103,
         n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113,
         n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123,
         n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133,
         n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142, n1143,
         n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152, n1153,
         n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162, n1163,
         n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172, n1173,
         n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182, n1183,
         n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1191, n1192, n1193,
         n1194, n1195, n1196, n1197, n1198, n1199, n1200, n1201, n1202, n1203,
         n1204, n1205, n1206, n1207, n1208, n1209, n1210, n1211, n1212, n1213,
         n1214, n1215, n1216, n1217, n1218, n1219, n1220, n1221, n1222, n1223,
         n1224, n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232, n1233,
         n1234, n1235, n1236, n1237, n1238, n1239, n1240, n1241, n1242, n1243,
         n1244, n1245, n1246, n1247, n1248, n1249, n1250, n1251, n1252, n1253,
         n1254, n1255, n1256, n1257, n1258, n1259, n1260, n1261, n1262, n1263,
         n1264, n1265, n1266, n1267, n1268, n1269, n1270, n1271, n1272, n1273,
         n1274, n1275, n1276, n1277, n1278, n1279, n1280, n1281, n1282, n1283,
         n1284, n1285, n1286, n1287, n1288, n1289, n1290, n1291, n1292, n1293,
         n1294, n1295, n1296, n1297, n1298, n1299, n1300, n1301, n1302, n1303,
         n1304, n1305, n1306, n1307, n1308, n1309, n1310, n1311, n1312, n1313,
         n1314, n1315, n1316, n1317, n1318, n1319, n1320, n1321, n1322, n1323,
         n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331, n1332, n1333,
         n1334, n1335, n1336, n1337, n1338, n1339, n1340, n1341, n1342, n1343,
         n1344, n1345, n1346, n1347, n1348, n1349, n1350, n1351, n1352, n1353,
         n1354, n1355, n1356, n1357, n1358, n1359, n1360, n1361, n1362, n1363,
         n1364, n1365, n1366, n1367, n1368, n1369, n1370, n1371, n1372, n1373,
         n1374, n1375, n1376, n1377, n1378, n1379, n1380, n1381, n1382, n1383,
         n1384, n1385, n1386, n1387, n1388, n1389, n1390, n1391, n1392, n1393,
         n1394, n1395, n1396, n1397, n1398, n1399, n1400, n1401, n1402, n1403,
         n1404, n1405, n1406, n1407, n1408, n1409, n1410, n1411, n1412, n1413,
         n1414, n1415, n1416, n1417, n1418, n1419, n1420, n1421, n1422, n1423,
         n1424, n1425, n1426, n1427, n1428, n1429, n1430, n1431, n1432, n1433,
         n1434, n1435, n1436, n1437, n1438, n1439, n1440, n1441, n1442, n1443,
         n1444, n1445, n1446, n1447, n1448, n1449, n1450, n1451, n1452, n1453,
         n1454, n1455, n1456, n1457, n1458, n1459, n1460, n1461, n1462, n1463,
         n1464, n1465, n1466, n1467, n1468, n1469, n1470, n1471, n1472, n1473,
         n1474, n1475, n1476, n1477, n1478, n1479;
  wire   [15:0] out_dptr_r;
  wire   [7:0] in_idat_r;
  wire   [7:0] out_sfr_a;
  wire   [7:0] in_xrom_r;
  wire   [7:0] out_sp_r;
  wire   [15:0] in_rel_adder;
  wire   [15:0] out_pc_r;
  wire   [15:0] rel_addr_a;
  wire   [15:0] page_addr_a;
  wire   [7:0] out_sfr_r;
  wire   [7:0] xrom;
  wire   [2:0] int_vec;
  wire   [2:0] int_vec1;
  wire   [2:0] int_vec3;
  wire   [2:0] int_vec2;
  wire   [7:0] acc_chd;
  wire   [7:0] in_b;
  wire   [7:0] out_b;
  wire   [7:0] op1;
  wire   [7:0] alu_a;
  wire   [7:0] alu_r;
  wire   [15:0] a_plus_pc;
  wire   [15:0] a_plus_dptr;
  wire   [15:0] in_pc;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3;
  assign out_idat[0] = \out_idat0[0] ;
  assign combus[0] = \out_idat0[0] ;
  assign out_idat[1] = \out_idat0[1] ;
  assign combus[1] = \out_idat0[1] ;
  assign out_idat[2] = \out_idat0[2] ;
  assign combus[2] = \out_idat0[2] ;
  assign out_idat[3] = \out_idat0[3] ;
  assign combus[3] = \out_idat0[3] ;
  assign out_idat[4] = \out_idat0[4] ;
  assign combus[4] = \out_idat0[4] ;
  assign out_idat[5] = \out_idat0[5] ;
  assign combus[5] = \out_idat0[5] ;
  assign out_idat[6] = \out_idat0[6] ;
  assign combus[6] = \out_idat0[6] ;
  assign out_idat[7] = \out_idat0[7] ;
  assign combus[7] = \out_idat0[7] ;

  sign U4_sign ( .a(in_xrom_r), .b(in_rel_adder) );
  pc U0_pc ( .clk(clk), .rst_p(rst_p), .ld_pc(ld_pc), .ld_pcl(ld_pcl), 
        .ld_pch(ld_pch), .inc_pc(inc_pc), .in_pc(in_pc), .out_pc_r(out_pc_r)
         );
  page_addr U27_page_addr ( .pc(out_pc_r[15:11]), .code(code[7:5]), .xrom(xrom), .page_addr_a(page_addr_a) );
  u_sfr U1_sfr ( .end_instr(end_instr), .clk(clk), .rst_p(rst_p), .ld_acc(
        ld_acc), .ld_acc_chd(ld_acc_chd), .addr_sfr({n736, addr_a[6], n1481, 
        addr_a[4], n1482, n732, n734, n731}), .in_sfr({\out_idat0[7] , 
        \out_idat0[6] , \out_idat0[5] , \out_idat0[4] , \out_idat0[3] , 
        \out_idat0[2] , \out_idat0[1] , \out_idat0[0] }), .wr_sfr(wr_sfr), 
        .ld_dpl(ld_dpl), .ld_dph(ld_dph), .inc_dptr(inc_dptr), .inc_sp(inc_sp), 
        .dec_sp(dec_sp), .set_c(set_c), .rst_c(rst_c), .cpl_c(cpl_c), .ld_c(
        ld_c), .set_ac(set_ac), .rst_ac(rst_ac), .set_v(set_v), .rst_v(rst_v), 
        .acc_chd(acc_chd), .in_b(in_b), .ld_b(ld_b), .in_cy_bit(in_cy_bit), 
        .rmw(rmw), .t0_pin(t0_pin), .t1_pin(t1_pin), .int0_pin(int0_pin), 
        .int1_pin(int1_pin), .p0_in(p0_in), .p1_in(p1_in), .p2_in(p2_in), 
        .p3_in(p3_in), .reti(reti), .out_sfr_a(out_sfr_a), .out_acc_r(
        out_acc_r), .out_dptr_r(out_dptr_r), .out_dimod_r(out_dimod_r), 
        .out_sp_r(out_sp_r), .out_psw({cy_psw, out_psw_6_, 
        SYNOPSYS_UNCONNECTED__0, out_psw_4_, out_psw_3_, 
        SYNOPSYS_UNCONNECTED__1, SYNOPSYS_UNCONNECTED__2, 
        SYNOPSYS_UNCONNECTED__3}), .out_b(out_b), .p0_out(p0_out), .p1_out(
        p1_out), .p2_out(p2_out), .p3_out(p3_out), .txdo(txdo), .rxdi(rxdi), 
        .rxdo(rxdo), .int_vec(int_vec), .en_int(en_int) );
  u_alu U3_alu ( .en_div(en_div), .clk(clk), .rst_p(rst_p), .OP_B({op2_7_, 
        n617, n615, op2_4_, n613, n614, n566, op2_0_}), .OP_A(op1), .SEL(
        sel_alu), .IN_C(cy_psw), .IN_AC(out_psw_6_), .ALU(alu_a), .CY(cy), 
        .AC(ac), .OV(ov), .IN_B(in_b), .acc_chd(acc_chd) );
  NAND3X1 U640 ( .A(n606), .B(n642), .C(n557), .Y(n548) );
  NAND2X6 U641 ( .A(n549), .B(n911), .Y(op1[7]) );
  INVX3 U642 ( .A(n548), .Y(n549) );
  NOR2X1 U643 ( .A(n917), .B(n918), .Y(n606) );
  OR2X1 U644 ( .A(n841), .B(n922), .Y(n557) );
  OR2X1 U645 ( .A(n791), .B(n912), .Y(n642) );
  NOR2X4 U646 ( .A(n609), .B(n915), .Y(n914) );
  OR2X4 U647 ( .A(n1046), .B(n550), .Y(n179) );
  OR2X2 U648 ( .A(n616), .B(n551), .Y(n550) );
  CLKINVX1 U649 ( .A(n1045), .Y(n551) );
  INVX20 U650 ( .A(n643), .Y(\out_idat0[1] ) );
  NOR2X6 U651 ( .A(n644), .B(n645), .Y(n643) );
  NAND2X2 U652 ( .A(n552), .B(n1478), .Y(n1387) );
  NAND2X4 U653 ( .A(n673), .B(n1006), .Y(n1409) );
  MX2X4 U654 ( .S0(sel_addr0), .B(addr_bank_a[0]), .A(n1466), .Y(n673) );
  OR2X1 U655 ( .A(n1390), .B(n749), .Y(n563) );
  NAND2X1 U656 ( .A(n1396), .B(n1374), .Y(n1372) );
  MXI2X1 U657 ( .S0(n1478), .B(out_sp_r[7]), .A(msb_r), .Y(n1420) );
  AOI2BB2X4 U658 ( .A0N(n1410), .A1N(n1411), .B0(n1409), .B1(n1375), .Y(n731)
         );
  INVX4 U659 ( .A(n1409), .Y(n1411) );
  NOR2X2 U660 ( .A(sel_addr1[1]), .B(sel_addr1[2]), .Y(n552) );
  INVX8 U661 ( .A(sel_addr1[2]), .Y(n1460) );
  NOR2X8 U662 ( .A(n1059), .B(n735), .Y(addr_a[4]) );
  INVX3 U663 ( .A(n601), .Y(n553) );
  CLKBUFX2 U664 ( .A(n1481), .Y(addr_a[5]) );
  INVX8 U665 ( .A(sel_addr1[0]), .Y(n1478) );
  NOR2X1 U666 ( .A(n1420), .B(n600), .Y(n1418) );
  INVX8 U667 ( .A(n1478), .Y(n1477) );
  MXI2X1 U668 ( .S0(sel_addr1[2]), .B(n1419), .A(n1418), .Y(n1413) );
  NAND3X2 U669 ( .A(n1414), .B(n1413), .C(n564), .Y(n1370) );
  MXI2X2 U670 ( .S0(sel_addr0), .B(out_psw_4_), .A(n1421), .Y(n735) );
  NAND4X2 U671 ( .A(n1422), .B(n568), .C(n1423), .D(n1424), .Y(n1421) );
  INVX2 U672 ( .A(n1369), .Y(n1483) );
  NAND2X2 U673 ( .A(n1370), .B(n1374), .Y(n1369) );
  CLKMX2X8 U674 ( .S0(sel_addr0), .B(addr_bank_a[0]), .A(n1466), .Y(n555) );
  CLKINVX12 U675 ( .A(n555), .Y(n733) );
  NOR2X1 U676 ( .A(n1384), .B(n569), .Y(n1416) );
  INVX1 U677 ( .A(n833), .Y(n556) );
  NOR3BX2 U678 ( .AN(n1311), .B(n356), .C(n1312), .Y(n355) );
  NAND2X1 U679 ( .A(latch_pc_2_), .B(n626), .Y(n1311) );
  CLKINVX3 U680 ( .A(sel_op2[2]), .Y(n908) );
  NAND3X4 U681 ( .A(n910), .B(n908), .C(n907), .Y(n834) );
  NOR3BX2 U682 ( .AN(n1286), .B(n348), .C(n1287), .Y(n347) );
  OAI21X2 U683 ( .A0(n1162), .A1(n882), .B0(n1288), .Y(n348) );
  NOR2X1 U684 ( .A(n1314), .B(n1315), .Y(n1310) );
  NOR2X1 U685 ( .A(n1321), .B(n1322), .Y(n1308) );
  INVX1 U686 ( .A(sel_op1[0]), .Y(n976) );
  CLKINVX3 U687 ( .A(a_plus_dptr[4]), .Y(n1129) );
  CLKINVX3 U688 ( .A(n108), .Y(n287) );
  NAND4X1 U689 ( .A(n1156), .B(n1157), .C(n1158), .D(n294), .Y(n108) );
  OAI21X1 U690 ( .A0(n1062), .A1(n34), .B0(n1063), .Y(n11000) );
  NAND4X1 U691 ( .A(n1212), .B(n1213), .C(n1214), .D(n3230), .Y(n48) );
  NOR2X1 U692 ( .A(n1218), .B(n1219), .Y(n1214) );
  NOR2X1 U693 ( .A(n1225), .B(n1226), .Y(n1212) );
  NOR2X1 U694 ( .A(n1440), .B(n1441), .Y(n1433) );
  NOR2X1 U695 ( .A(n1388), .B(n1442), .Y(n1441) );
  NOR2X1 U696 ( .A(n1393), .B(n783), .Y(n1427) );
  NOR2X1 U697 ( .A(n849), .B(n850), .Y(n843) );
  NAND3X2 U698 ( .A(n987), .B(n589), .C(n988), .Y(n986) );
  NAND3X2 U699 ( .A(n999), .B(n590), .C(n1000), .Y(n998) );
  NOR2X1 U700 ( .A(n889), .B(n890), .Y(n883) );
  CLKINVX1 U701 ( .A(sel_combus[0]), .Y(n1350) );
  OAI21X1 U702 ( .A0(n1178), .A1(n1179), .B0(n1180), .Y(n1173) );
  NAND2X1 U703 ( .A(in_xdat_a[1]), .B(n1181), .Y(n1180) );
  NOR3BX1 U704 ( .AN(n1190), .B(n3160), .C(n1191), .Y(n3150) );
  OAI21X1 U705 ( .A0(n1162), .A1(n841), .B0(n1192), .Y(n3160) );
  CLKINVX1 U706 ( .A(a_plus_dptr[5]), .Y(n1124) );
  AND2X2 U707 ( .A(sel_combus[1]), .B(n1350), .Y(n639) );
  AND2X2 U708 ( .A(sel_combus[3]), .B(n1347), .Y(n611) );
  INVX3 U709 ( .A(in_idat_a[2]), .Y(n888) );
  INVX8 U710 ( .A(in_xrom_a[4]), .Y(n872) );
  NOR2X1 U711 ( .A(n866), .B(n867), .Y(n864) );
  NOR2X1 U712 ( .A(n856), .B(n857), .Y(n854) );
  INVX8 U713 ( .A(in_xrom_a[5]), .Y(n862) );
  CLKINVX6 U714 ( .A(in_xrom_a[7]), .Y(n841) );
  NOR2X1 U715 ( .A(n1289), .B(n1290), .Y(n1285) );
  NOR2X1 U716 ( .A(n1296), .B(n1297), .Y(n1283) );
  NAND3X1 U717 ( .A(sel_combus[2]), .B(sel_combus[3]), .C(n625), .Y(n1161) );
  NAND2X1 U718 ( .A(n611), .B(n639), .Y(n1162) );
  NAND4BX1 U719 ( .AN(n1326), .B(n1327), .C(n1328), .D(n1329), .Y(in_pc[0]) );
  INVX1 U720 ( .A(n70), .Y(n808) );
  NAND2X1 U721 ( .A(n1002), .B(n1003), .Y(n70) );
  NOR2X1 U722 ( .A(n879), .B(n880), .Y(n873) );
  NOR2X1 U723 ( .A(n1165), .B(n1166), .Y(n1157) );
  OAI21X1 U724 ( .A0(n1170), .A1(n959), .B0(n1324), .Y(n1321) );
  NAND2X1 U725 ( .A(in_idat_a[2]), .B(n1172), .Y(n1324) );
  OAI21X1 U726 ( .A0(n1170), .A1(n952), .B0(n1299), .Y(n1296) );
  NAND2X1 U727 ( .A(in_idat_a[3]), .B(n1172), .Y(n1299) );
  NOR3BX1 U728 ( .AN(n1240), .B(n3320), .C(n1241), .Y(n3310) );
  OAI21X1 U729 ( .A0(n1162), .A1(n862), .B0(n1242), .Y(n3320) );
  NOR3BX1 U730 ( .AN(n1215), .B(n3240), .C(n1216), .Y(n3230) );
  OAI21X1 U731 ( .A0(n1162), .A1(n852), .B0(n1217), .Y(n3240) );
  INVX1 U732 ( .A(out_sp_r[2]), .Y(n1453) );
  INVX8 U733 ( .A(in_xrom_a[6]), .Y(n852) );
  NOR2X1 U734 ( .A(n579), .B(n916), .Y(n913) );
  NAND2X2 U735 ( .A(n1370), .B(n1374), .Y(n1408) );
  AND2X2 U736 ( .A(n638), .B(n611), .Y(n626) );
  INVX8 U737 ( .A(in_xrom_a[2]), .Y(n892) );
  INVX8 U738 ( .A(in_xrom_a[3]), .Y(n882) );
  NOR2X1 U739 ( .A(n876), .B(n877), .Y(n874) );
  NOR2X1 U740 ( .A(n859), .B(n860), .Y(n853) );
  OAI21X1 U741 ( .A0(n1142), .A1(n1103), .B0(n1143), .Y(in_pc[2]) );
  NAND4BX1 U742 ( .AN(n1099), .B(n110000), .C(n1101), .D(n1102), .Y(in_pc[7])
         );
  NOR2X1 U743 ( .A(n114), .B(n824), .Y(n822) );
  INVX3 U744 ( .A(n104), .Y(n821) );
  NAND2X1 U745 ( .A(n1060), .B(n1061), .Y(n104) );
  INVX1 U746 ( .A(n11000), .Y(n1061) );
  MXI2X2 U747 ( .S0(sel_addr0), .B(out_psw_3_), .A(n1432), .Y(n1375) );
  NAND4X2 U748 ( .A(n1433), .B(n565), .C(n1434), .D(n1435), .Y(n1432) );
  NOR2X1 U749 ( .A(n1438), .B(n1439), .Y(n1434) );
  NOR2X1 U750 ( .A(n1429), .B(n1430), .Y(n1422) );
  NOR2X1 U751 ( .A(n1427), .B(n1428), .Y(n1423) );
  NAND2X2 U752 ( .A(n1377), .B(n1374), .Y(n1022) );
  NAND4X1 U753 ( .A(n1378), .B(n563), .C(n1379), .D(n1380), .Y(n1377) );
  CLKINVX1 U754 ( .A(n1333), .Y(n372) );
  NOR2X1 U755 ( .A(n1338), .B(n1339), .Y(n1332) );
  NAND2X6 U756 ( .A(n1351), .B(n1352), .Y(n375) );
  CLKINVX1 U757 ( .A(n1070), .Y(addr2_a_2_) );
  NOR2X2 U758 ( .A(n816), .B(n817), .Y(n815) );
  INVX3 U759 ( .A(n986), .Y(n90) );
  NOR2X2 U760 ( .A(n588), .B(n559), .Y(n816) );
  INVX3 U761 ( .A(n998), .Y(n81) );
  AND3X6 U762 ( .A(n806), .B(n807), .C(n808), .Y(n805) );
  INVX1 U763 ( .A(n1016), .Y(n52) );
  INVX1 U764 ( .A(n1027), .Y(n41) );
  NAND2X4 U765 ( .A(n1371), .B(n1372), .Y(n1481) );
  OR2X2 U766 ( .A(n1394), .B(n769), .Y(n561) );
  OR2X2 U767 ( .A(n1394), .B(n770), .Y(n562) );
  OR2X2 U768 ( .A(n1390), .B(n748), .Y(n564) );
  OR2X2 U769 ( .A(n1394), .B(n768), .Y(n565) );
  OR3X8 U770 ( .A(n893), .B(n894), .C(n895), .Y(n566) );
  OR2X2 U771 ( .A(n1390), .B(n750), .Y(n567) );
  OR2X2 U772 ( .A(n1394), .B(n767), .Y(n568) );
  AND2X2 U773 ( .A(n605), .B(n1049), .Y(n586) );
  AND2X2 U774 ( .A(n1074), .B(n737), .Y(n587) );
  AND2X2 U775 ( .A(n818), .B(n819), .Y(n588) );
  OR2X2 U776 ( .A(n559), .B(n989), .Y(n589) );
  OR2X2 U777 ( .A(n991), .B(n560), .Y(n590) );
  AND2X1 U778 ( .A(n1075), .B(n738), .Y(n591) );
  OR2X2 U779 ( .A(n1019), .B(n574), .Y(n592) );
  OR2X1 U780 ( .A(n1021), .B(n570), .Y(n593) );
  INVX1 U781 ( .A(in_idat_r[1]), .Y(n1055) );
  OR2X2 U782 ( .A(n742), .B(n1211), .Y(n595) );
  OR2X2 U783 ( .A(n742), .B(n1259), .Y(n596) );
  OR2X2 U784 ( .A(n742), .B(n1305), .Y(n597) );
  OR2X2 U785 ( .A(n741), .B(n1236), .Y(n598) );
  OR2X2 U786 ( .A(n741), .B(n1282), .Y(n599) );
  INVX1 U787 ( .A(a_plus_dptr[7]), .Y(n1105) );
  INVX3 U788 ( .A(n105), .Y(n644) );
  CLKINVX2 U789 ( .A(n1054), .Y(n105) );
  CLKINVX8 U790 ( .A(n602), .Y(code[2]) );
  DFFRHQX4 code_reg_4_ ( .D(n544), .CK(clk), .RN(n481), .Q(code[4]) );
  INVX3 U791 ( .A(sel_addr1[1]), .Y(n601) );
  INVX3 U792 ( .A(sel_addr1[1]), .Y(n600) );
  NAND3X2 U793 ( .A(n1477), .B(n601), .C(n1460), .Y(n1384) );
  MXI2X2 U794 ( .S0(n553), .B(n1473), .A(n1472), .Y(n1468) );
  NAND3X2 U795 ( .A(n1478), .B(n1460), .C(sel_addr1[1]), .Y(n1388) );
  NAND3X2 U796 ( .A(n600), .B(n1478), .C(sel_addr1[2]), .Y(n1394) );
  NAND3X2 U797 ( .A(sel_addr1[2]), .B(n1478), .C(sel_addr1[1]), .Y(n1383) );
  NOR2X2 U798 ( .A(n1400), .B(n1401), .Y(n1399) );
  NOR3BX1 U799 ( .AN(sel_addr1[1]), .B(n1105), .C(n1477), .Y(n1419) );
  NOR3X1 U800 ( .A(n1478), .B(sel_addr1[1]), .C(n755), .Y(n1471) );
  NOR3BX1 U801 ( .AN(in_idat_r[0]), .B(n1478), .C(sel_addr1[1]), .Y(n1470) );
  NAND3X4 U802 ( .A(n1477), .B(n1460), .C(sel_addr1[1]), .Y(n1393) );
  AND2X2 U803 ( .A(n1396), .B(n1374), .Y(n604) );
  CLKINVX12 U804 ( .A(sel_addr0), .Y(n1374) );
  NAND3X2 U805 ( .A(sel_addr1[2]), .B(n601), .C(n1477), .Y(n1390) );
  NAND2X2 U806 ( .A(bit_addr), .B(n1373), .Y(n1371) );
  INVX6 U807 ( .A(n1376), .Y(n1059) );
  CLKINVX4 U808 ( .A(out_sfr_a[7]), .Y(n791) );
  NOR3X2 U809 ( .A(n1416), .B(n1415), .C(n1417), .Y(n1414) );
  NAND2X6 U810 ( .A(n586), .B(n1050), .Y(n657) );
  CLKINVX1 U811 ( .A(n1052), .Y(n605) );
  DFFRHQX8 code_reg_3_ ( .D(n543), .CK(clk), .RN(n481), .Q(code[3]) );
  DFFRHQX8 code_reg_1_ ( .D(n541), .CK(clk), .RN(n481), .Q(code[1]) );
  DFFRHQX8 code_reg_6_ ( .D(n546), .CK(clk), .RN(n481), .Q(code[6]) );
  DFFRHQX8 code_reg_5_ ( .D(n545), .CK(clk), .RN(n481), .Q(code[5]) );
  SDFFRX1 addr2_r_reg_0_ ( .SI(n1466), .SE(n1374), .D(addr_bank_a[0]), .CK(clk), .RN(n481), .QN(n780) );
  INVX1 U812 ( .A(n608), .Y(n607) );
  NOR2X8 U813 ( .A(n913), .B(n914), .Y(n911) );
  CLKBUFX2 U814 ( .A(n1043), .Y(n608) );
  INVX3 U815 ( .A(in_idat_a[0]), .Y(n1043) );
  NOR2X2 U816 ( .A(n1043), .B(n834), .Y(n1046) );
  CLKINVX8 U817 ( .A(in_idat_a[7]), .Y(n609) );
  CLKINVX1 U818 ( .A(in_idat_a[7]), .Y(n833) );
  NAND3X4 U819 ( .A(n976), .B(n979), .C(sel_op1[2]), .Y(n915) );
  INVX20 U820 ( .A(n656), .Y(\out_idat0[0] ) );
  NAND2X2 U821 ( .A(bit_addr), .B(n1369), .Y(n1376) );
  DFFQX1 int_vec1_reg_2_ ( .D(int_vec[2]), .CK(clk), .Q(int_vec1[2]) );
  DFFQX1 int_vec1_reg_1_ ( .D(int_vec[1]), .CK(clk), .Q(int_vec1[1]) );
  DFFQX1 int_vec1_reg_0_ ( .D(int_vec[0]), .CK(clk), .Q(int_vec1[0]) );
  DFFQX1 int_vec2_reg_2_ ( .D(int_vec1[2]), .CK(clk), .Q(int_vec2[2]) );
  DFFQX1 int_vec2_reg_1_ ( .D(int_vec1[1]), .CK(clk), .Q(int_vec2[1]) );
  DFFQX1 int_vec2_reg_0_ ( .D(int_vec1[0]), .CK(clk), .Q(int_vec2[0]) );
  INVX3 U822 ( .A(n901), .Y(n830) );
  CLKINVX3 U823 ( .A(sel_op1[1]), .Y(n979) );
  CLKINVX3 U824 ( .A(bit_addr), .Y(n1006) );
  INVX6 U825 ( .A(sel_op2[1]), .Y(n907) );
  CLKINVX3 U826 ( .A(sel_op2[0]), .Y(n910) );
  NOR2X1 U827 ( .A(n868), .B(n834), .Y(n867) );
  NOR2X1 U828 ( .A(n888), .B(n834), .Y(n887) );
  DFFRX1 in_xrom1_r_reg_5_ ( .D(n513), .CK(clk), .RN(n481), .Q(in_xrom1_r[5]), 
        .QN(n766) );
  OR2X1 U829 ( .A(n835), .B(n683), .Y(n897) );
  CLKMX2X3 U830 ( .S0(sel_addr0), .B(out_psw_4_), .A(n1421), .Y(n684) );
  CLKINVX4 U831 ( .A(in_idat_a[4]), .Y(n868) );
  CLKINVX3 U832 ( .A(in_idat_a[5]), .Y(n858) );
  AND2X2 U833 ( .A(n1349), .B(n1350), .Y(n625) );
  CLKINVX1 U834 ( .A(sel_combus[1]), .Y(n1349) );
  AND2X2 U835 ( .A(sel_combus[0]), .B(sel_combus[1]), .Y(n638) );
  AOI21X1 U836 ( .A0(in_idat_a[1]), .A1(n968), .B0(n969), .Y(n961) );
  CLKAND2X2 U837 ( .A(n636), .B(n611), .Y(n627) );
  NOR2X1 U838 ( .A(n950), .B(n951), .Y(n947) );
  MXI2X4 U839 ( .S0(sel_addr0), .B(addr_bank_a[1]), .A(n1454), .Y(n1072) );
  NOR2X2 U840 ( .A(n1402), .B(n1403), .Y(n1398) );
  NOR3X1 U841 ( .A(n1316), .B(n1317), .C(n1318), .Y(n1309) );
  NOR3X1 U842 ( .A(n1291), .B(n1292), .C(n1293), .Y(n1284) );
  INVX3 U843 ( .A(sel_op1[2]), .Y(n977) );
  INVX3 U844 ( .A(in_idat_a[3]), .Y(n878) );
  AND2X2 U845 ( .A(sel_combus[0]), .B(n1349), .Y(n636) );
  NOR2X1 U846 ( .A(n560), .B(n835), .Y(n876) );
  NOR2X1 U847 ( .A(n878), .B(n834), .Y(n877) );
  NOR2X1 U848 ( .A(n559), .B(n835), .Y(n886) );
  DFFRHQX8 code_reg_7_ ( .D(n547), .CK(clk), .RN(n481), .Q(code[7]) );
  INVX3 U849 ( .A(n738), .Y(n725) );
  CLKINVX1 U850 ( .A(n1227), .Y(n1169) );
  CLKBUFX2 U851 ( .A(n1483), .Y(n738) );
  NAND2X1 U852 ( .A(n637), .B(n639), .Y(n1199) );
  AND2X1 U853 ( .A(sel_combus[2]), .B(n1344), .Y(n637) );
  MXI2X1 U854 ( .S0(sel_addr0), .B(addr_bank_a[2]), .A(n1443), .Y(n728) );
  NOR2X2 U855 ( .A(n936), .B(n937), .Y(n933) );
  OR2X6 U856 ( .A(n822), .B(n823), .Y(n658) );
  OR2X1 U857 ( .A(n882), .B(n842), .Y(n651) );
  OR2X1 U858 ( .A(n892), .B(n842), .Y(n652) );
  OAI2BB2X1 U859 ( .A0N(n612), .A1N(in_idat_r[1]), .B0(n287), .B1(bit_addr), 
        .Y(n1054) );
  BUFX6 U860 ( .A(n785), .Y(op2_7_) );
  NOR2X1 U861 ( .A(n1425), .B(n1426), .Y(n1424) );
  NOR2X2 U862 ( .A(n580), .B(n835), .Y(n616) );
  NOR2X1 U863 ( .A(n1173), .B(n1174), .Y(n1156) );
  DFFRX1 out_sfr_r_reg_3_ ( .D(n495), .CK(clk), .RN(n481), .Q(out_sfr_r[3]), 
        .QN(n582) );
  AND2X2 U864 ( .A(n661), .B(n662), .Y(n941) );
  NAND4BBX2 U865 ( .AN(n1136), .BN(n665), .C(n621), .D(n622), .Y(in_pc[3]) );
  CLKINVX1 U866 ( .A(n33), .Y(n1034) );
  NAND2X4 U867 ( .A(sel_bit_dat_out[1]), .B(n403), .Y(n1067) );
  NOR2X1 U868 ( .A(n1405), .B(n1406), .Y(n1397) );
  NOR2X1 U869 ( .A(n1161), .B(n762), .Y(n1160) );
  NOR2X1 U870 ( .A(n1390), .B(n751), .Y(n1428) );
  CLKINVX1 U871 ( .A(n838), .Y(n909) );
  NOR2X1 U872 ( .A(n1461), .B(n1462), .Y(n1456) );
  NAND2X1 U873 ( .A(out_b[1]), .B(n909), .Y(n898) );
  CLKINVX4 U874 ( .A(in_idat_a[6]), .Y(n848) );
  OR2X1 U875 ( .A(n624), .B(n1177), .Y(n1176) );
  CLKINVX8 U876 ( .A(n725), .Y(msb_a) );
  NAND3X1 U877 ( .A(sel_op2[0]), .B(n908), .C(n907), .Y(n835) );
  NAND2X1 U878 ( .A(n629), .B(n625), .Y(n1170) );
  INVX1 U879 ( .A(n1325), .Y(n1172) );
  INVX1 U880 ( .A(n1167), .Y(n1229) );
  INVX1 U881 ( .A(n1199), .Y(n1181) );
  INVX1 U882 ( .A(n1195), .Y(n1164) );
  INVX1 U883 ( .A(n1175), .Y(n1337) );
  BUFX6 U884 ( .A(n1483), .Y(n736) );
  NAND2X1 U885 ( .A(n629), .B(n638), .Y(n1195) );
  NAND2X1 U886 ( .A(n637), .B(n636), .Y(n1175) );
  NAND2BX1 U887 ( .AN(n804), .B(n803), .Y(n802) );
  AND2X2 U888 ( .A(n1344), .B(n1347), .Y(n629) );
  NAND2X1 U889 ( .A(n629), .B(n636), .Y(n1325) );
  CLKINVX1 U890 ( .A(n803), .Y(n1037) );
  NAND3X1 U891 ( .A(n976), .B(sel_op1[1]), .C(n977), .Y(n919) );
  OR2X1 U892 ( .A(n926), .B(n912), .Y(n631) );
  NAND3BX1 U893 ( .AN(n810), .B(n995), .C(n1025), .Y(n794) );
  NAND2X1 U894 ( .A(n982), .B(n984), .Y(n810) );
  NAND2X1 U895 ( .A(n647), .B(n628), .Y(n803) );
  NAND2X1 U896 ( .A(n991), .B(n989), .Y(n809) );
  NAND2X1 U897 ( .A(n591), .B(n646), .Y(n994) );
  NAND2X1 U898 ( .A(n587), .B(n647), .Y(n996) );
  NAND2X1 U899 ( .A(n1015), .B(n1013), .Y(n793) );
  INVX1 U900 ( .A(sel_combus[2]), .Y(n1347) );
  CLKINVX1 U901 ( .A(n985), .Y(n1008) );
  CLKINVX1 U902 ( .A(n819), .Y(n1007) );
  CLKINVX1 U903 ( .A(sel_pc[0]), .Y(n1331) );
  NOR2BX4 U904 ( .AN(out_sfr_a[1]), .B(n901), .Y(n893) );
  NAND2X1 U905 ( .A(n1370), .B(n1374), .Y(n1373) );
  CLKINVX8 U906 ( .A(n821), .Y(n645) );
  NOR2X1 U907 ( .A(n852), .B(n922), .Y(n923) );
  INVX1 U908 ( .A(a_plus_dptr[2]), .Y(n1147) );
  INVX1 U909 ( .A(n990), .Y(n987) );
  INVX3 U910 ( .A(a_plus_dptr[6]), .Y(n1111) );
  CLKINVX1 U911 ( .A(out_sfr_a[6]), .Y(n926) );
  INVX1 U912 ( .A(n1001), .Y(n999) );
  NOR2X2 U913 ( .A(n957), .B(n958), .Y(n954) );
  NAND2X1 U914 ( .A(n591), .B(n672), .Y(n995) );
  NAND2X1 U915 ( .A(n672), .B(n587), .Y(n985) );
  NAND2X1 U916 ( .A(n672), .B(n648), .Y(n1010) );
  NAND2X1 U917 ( .A(n674), .B(n648), .Y(n991) );
  NAND2X1 U918 ( .A(n672), .B(n628), .Y(n819) );
  NAND2X1 U919 ( .A(n674), .B(n587), .Y(n1015) );
  NAND2X1 U920 ( .A(n591), .B(n674), .Y(n982) );
  AND2X2 U921 ( .A(n1059), .B(n730), .Y(n648) );
  OR2X2 U922 ( .A(n1056), .B(n1051), .Y(n612) );
  NOR2X1 U923 ( .A(n1381), .B(n1382), .Y(n1380) );
  NAND2X2 U924 ( .A(alu_a[0]), .B(n627), .Y(n1351) );
  NOR2X4 U925 ( .A(n903), .B(n179), .Y(n902) );
  NAND3X2 U926 ( .A(n904), .B(n905), .C(n906), .Y(n903) );
  NAND4X4 U927 ( .A(n651), .B(n873), .C(n874), .D(n875), .Y(n613) );
  NAND4X4 U928 ( .A(n652), .B(n883), .C(n884), .D(n885), .Y(n614) );
  NAND4X4 U929 ( .A(n654), .B(n853), .C(n854), .D(n855), .Y(n615) );
  NOR2X1 U930 ( .A(n1385), .B(n1386), .Y(n1379) );
  NAND4X2 U931 ( .A(n1399), .B(n1398), .C(n567), .D(n1397), .Y(n1396) );
  NOR2X1 U932 ( .A(n1458), .B(n1459), .Y(n1457) );
  NOR2X1 U933 ( .A(n1447), .B(n1448), .Y(n1446) );
  NOR2X1 U934 ( .A(n1384), .B(n573), .Y(n1425) );
  NOR2X1 U935 ( .A(n1383), .B(n1129), .Y(n1426) );
  NAND2BX2 U936 ( .AN(n842), .B(in_xrom_a[0]), .Y(n905) );
  NAND3X2 U937 ( .A(n898), .B(n899), .C(n900), .Y(n894) );
  OR2X1 U938 ( .A(n872), .B(n842), .Y(n655) );
  NAND4X2 U939 ( .A(n655), .B(n863), .C(n864), .D(n865), .Y(op2_4_) );
  NOR2X1 U940 ( .A(n581), .B(n840), .Y(n889) );
  NOR2X1 U941 ( .A(n582), .B(n840), .Y(n879) );
  NOR2X1 U942 ( .A(n573), .B(n835), .Y(n866) );
  NOR2X1 U943 ( .A(n569), .B(n835), .Y(n831) );
  NOR2X1 U944 ( .A(n831), .B(n832), .Y(n828) );
  NAND4X2 U945 ( .A(n1308), .B(n1309), .C(n1310), .D(n355), .Y(n98) );
  NOR2X1 U946 ( .A(n574), .B(n835), .Y(n856) );
  NOR2X1 U947 ( .A(n858), .B(n834), .Y(n857) );
  NOR2X1 U948 ( .A(n846), .B(n847), .Y(n844) );
  NOR2X1 U949 ( .A(n570), .B(n835), .Y(n846) );
  NOR2X1 U950 ( .A(n848), .B(n834), .Y(n847) );
  NAND4X4 U951 ( .A(n653), .B(n843), .C(n844), .D(n845), .Y(n617) );
  NOR2X2 U952 ( .A(n927), .B(n928), .Y(n925) );
  NOR2X1 U953 ( .A(n583), .B(n916), .Y(n927) );
  NOR2X2 U954 ( .A(n886), .B(n887), .Y(n884) );
  NAND2BX1 U955 ( .AN(n842), .B(in_xrom_a[1]), .Y(n900) );
  NAND4BX1 U956 ( .AN(n826), .B(n827), .C(n828), .D(n829), .Y(n785) );
  INVX1 U957 ( .A(a_plus_dptr[1]), .Y(n1155) );
  OR2X1 U958 ( .A(n585), .B(n916), .Y(n659) );
  NAND4BX2 U959 ( .AN(n1150), .B(n618), .C(n619), .D(n620), .Y(in_pc[1]) );
  AOI21X1 U960 ( .A0(page_addr_a[1]), .A1(n1153), .B0(n1154), .Y(n618) );
  AOI21X1 U961 ( .A0(rel_addr_a[1]), .A1(n1151), .B0(n1152), .Y(n619) );
  NAND2X2 U962 ( .A(n1080), .B(in_xrom_a[1]), .Y(n620) );
  NOR2X1 U963 ( .A(n588), .B(n560), .Y(n813) );
  NOR2X1 U964 ( .A(n813), .B(n814), .Y(n812) );
  NAND4X2 U965 ( .A(n1283), .B(n1284), .C(n1285), .D(n347), .Y(n87) );
  OR2X1 U966 ( .A(n584), .B(n916), .Y(n661) );
  DFFRX1 out_sfr_r_reg_2_ ( .D(n494), .CK(clk), .RN(n481), .Q(out_sfr_r[2]), 
        .QN(n581) );
  NOR2X1 U967 ( .A(n1144), .B(n1145), .Y(n1143) );
  NAND4X1 U968 ( .A(n1260), .B(n1261), .C(n1262), .D(n3390), .Y(n78) );
  NOR3X2 U969 ( .A(n1040), .B(n1041), .C(n1042), .Y(n223) );
  AND2X4 U970 ( .A(n1033), .B(n1034), .Y(n668) );
  NAND4X1 U971 ( .A(n1237), .B(n1238), .C(n1239), .D(n3310), .Y(n61) );
  NOR2X1 U972 ( .A(n1250), .B(n1251), .Y(n1237) );
  NOR3X1 U973 ( .A(n1245), .B(n1246), .C(n1247), .Y(n1238) );
  NOR2X1 U974 ( .A(n1243), .B(n1244), .Y(n1239) );
  OR2X1 U975 ( .A(n582), .B(n916), .Y(n663) );
  NOR2X1 U976 ( .A(n800), .B(n801), .Y(n799) );
  AOI21X1 U977 ( .A0(rel_addr_a[3]), .A1(n1354), .B0(n1138), .Y(n621) );
  AOI21X1 U978 ( .A0(page_addr_a[3]), .A1(n1153), .B0(n1137), .Y(n622) );
  OAI21X1 U979 ( .A0(n1035), .A1(n34), .B0(n1036), .Y(n33) );
  NOR2X1 U980 ( .A(n796), .B(n797), .Y(n795) );
  OAI21X1 U981 ( .A0(n77), .A1(n1103), .B0(n1125), .Y(in_pc[4]) );
  NOR3X1 U982 ( .A(n1220), .B(n1221), .C(n1222), .Y(n1213) );
  OR2X1 U983 ( .A(n581), .B(n916), .Y(n666) );
  OAI21X1 U984 ( .A0(n269), .A1(n1103), .B0(n1114), .Y(in_pc[5]) );
  NOR2X1 U985 ( .A(n811), .B(n983), .Y(n981) );
  NOR2X1 U986 ( .A(n811), .B(n993), .Y(n992) );
  NOR2X1 U987 ( .A(n794), .B(n1024), .Y(n1023) );
  NOR2X1 U988 ( .A(n794), .B(n1014), .Y(n1012) );
  NAND3BX1 U989 ( .AN(n1107), .B(n1108), .C(n1109), .Y(in_pc[6]) );
  NOR2X1 U990 ( .A(n34), .B(n989), .Y(n1001) );
  NOR2X1 U991 ( .A(n34), .B(n991), .Y(n990) );
  NOR2X1 U992 ( .A(n34), .B(n1021), .Y(n1020) );
  NAND3BX4 U993 ( .AN(n623), .B(n1332), .C(n372), .Y(n1032) );
  OR3X2 U994 ( .A(n1031), .B(n1345), .C(n1346), .Y(n623) );
  NOR2X1 U995 ( .A(n1390), .B(n753), .Y(n1450) );
  NAND2X1 U996 ( .A(latch_pc_1_), .B(n626), .Y(n1159) );
  NOR2X1 U997 ( .A(n1390), .B(n752), .Y(n1439) );
  NOR2X1 U998 ( .A(n1394), .B(n764), .Y(n1415) );
  NOR2X1 U999 ( .A(n1387), .B(n558), .Y(n1417) );
  NAND2X1 U1000 ( .A(out_b[0]), .B(n909), .Y(n904) );
  NOR2X1 U1001 ( .A(n1388), .B(n1431), .Y(n1430) );
  NOR2X1 U1002 ( .A(n1391), .B(n1392), .Y(n1378) );
  NOR2X1 U1003 ( .A(n1394), .B(n766), .Y(n1405) );
  NOR2X1 U1004 ( .A(n1463), .B(n1464), .Y(n1455) );
  NOR2X1 U1005 ( .A(n838), .B(n891), .Y(n890) );
  NOR2X1 U1006 ( .A(n838), .B(n881), .Y(n880) );
  NOR2X1 U1007 ( .A(n1161), .B(n761), .Y(n1312) );
  NOR2X1 U1008 ( .A(n869), .B(n870), .Y(n863) );
  OR2X1 U1009 ( .A(n840), .B(n682), .Y(n899) );
  NAND2X1 U1010 ( .A(latch_pc_3_), .B(n626), .Y(n1286) );
  NOR2X1 U1011 ( .A(n1161), .B(n760), .Y(n1287) );
  NOR3BX1 U1012 ( .AN(n1263), .B(n3400), .C(n1264), .Y(n3390) );
  OAI21X1 U1013 ( .A0(n1162), .A1(n872), .B0(n1265), .Y(n3400) );
  INVX1 U1014 ( .A(n76), .Y(n1003) );
  NOR2X1 U1015 ( .A(n1161), .B(n758), .Y(n1241) );
  NAND2X1 U1016 ( .A(latch_pc_5_), .B(n626), .Y(n1240) );
  NOR2X1 U1017 ( .A(n1161), .B(n757), .Y(n1216) );
  CLKINVX1 U1018 ( .A(n915), .Y(n968) );
  OAI21X1 U1019 ( .A0(n1161), .A1(n763), .B0(n1348), .Y(n1031) );
  OAI21X1 U1020 ( .A0(n1170), .A1(n967), .B0(n1171), .Y(n1165) );
  NAND2X1 U1021 ( .A(in_idat_a[1]), .B(n1172), .Y(n1171) );
  OAI21X1 U1022 ( .A0(n1170), .A1(n945), .B0(n1276), .Y(n1273) );
  NOR2X1 U1023 ( .A(n1178), .B(n1320), .Y(n1317) );
  NOR2X1 U1024 ( .A(n1178), .B(n1295), .Y(n1292) );
  NOR2X1 U1025 ( .A(n1199), .B(n1223), .Y(n1222) );
  NOR2X1 U1026 ( .A(n1199), .B(n1248), .Y(n1247) );
  INVX1 U1027 ( .A(out_sfr_r[1]), .Y(n970) );
  NOR2X1 U1028 ( .A(n1199), .B(n1319), .Y(n1318) );
  INVX1 U1029 ( .A(in_xdat_a[2]), .Y(n1319) );
  NOR2X1 U1030 ( .A(n1199), .B(n1294), .Y(n1293) );
  INVX1 U1031 ( .A(in_xdat_a[3]), .Y(n1294) );
  AO22X1 U1032 ( .A0(in_idat_r[1]), .A1(n402), .B0(ld_idat), .B1(in_idat_a[1]), 
        .Y(n501) );
  AO22X1 U1033 ( .A0(in_idat_r[2]), .A1(n402), .B0(ld_idat), .B1(in_idat_a[2]), 
        .Y(n502) );
  AO22X1 U1034 ( .A0(in_idat_r[3]), .A1(n402), .B0(ld_idat), .B1(in_idat_a[3]), 
        .Y(n503) );
  AO22X1 U1035 ( .A0(in_idat_r[4]), .A1(n402), .B0(ld_idat), .B1(in_idat_a[4]), 
        .Y(n504) );
  AO22X1 U1036 ( .A0(in_idat_r[5]), .A1(n402), .B0(ld_idat), .B1(in_idat_a[5]), 
        .Y(n505) );
  AO22X1 U1037 ( .A0(in_idat_r[6]), .A1(n402), .B0(ld_idat), .B1(in_idat_a[6]), 
        .Y(n506) );
  AO22X2 U1038 ( .A0(ld_operand2), .A1(in_xrom_a[4]), .B0(in_xrom1_r[4]), .B1(
        n254), .Y(n512) );
  AO22X2 U1039 ( .A0(ld_operand2), .A1(in_xrom_a[6]), .B0(in_xrom1_r[6]), .B1(
        n254), .Y(n514) );
  AO22X2 U1040 ( .A0(ld_operand2), .A1(in_xrom_a[3]), .B0(in_xrom1_r[3]), .B1(
        n254), .Y(n511) );
  AO22X2 U1041 ( .A0(ld_operand2), .A1(in_xrom_a[2]), .B0(in_xrom1_r[2]), .B1(
        n254), .Y(n510) );
  AO22X2 U1042 ( .A0(ld_operand2), .A1(in_xrom_a[7]), .B0(in_xrom1_r[7]), .B1(
        n254), .Y(n515) );
  AO22X2 U1043 ( .A0(ld_operand2), .A1(in_xrom_a[1]), .B0(in_xrom1_r[1]), .B1(
        n254), .Y(n509) );
  AO22X1 U1044 ( .A0(in_xrom_r[1]), .A1(n253), .B0(ld_xrom), .B1(in_xrom_a[1]), 
        .Y(n517) );
  AO22X1 U1045 ( .A0(in_xrom_r[0]), .A1(n253), .B0(ld_xrom), .B1(in_xrom_a[0]), 
        .Y(n516) );
  AO22X1 U1046 ( .A0(in_xrom_r[3]), .A1(n253), .B0(ld_xrom), .B1(in_xrom_a[3]), 
        .Y(n519) );
  AO22X1 U1047 ( .A0(in_xrom_r[4]), .A1(n253), .B0(ld_xrom), .B1(in_xrom_a[4]), 
        .Y(n520) );
  AO22X1 U1048 ( .A0(in_xrom_r[5]), .A1(n253), .B0(ld_xrom), .B1(in_xrom_a[5]), 
        .Y(n521) );
  AO22X1 U1049 ( .A0(in_xrom_r[6]), .A1(n253), .B0(ld_xrom), .B1(in_xrom_a[6]), 
        .Y(n522) );
  AO22X1 U1050 ( .A0(in_xrom_r[7]), .A1(n253), .B0(ld_xrom), .B1(in_xrom_a[7]), 
        .Y(n523) );
  AO22X1 U1051 ( .A0(in_xrom_r[2]), .A1(n253), .B0(ld_xrom), .B1(in_xrom_a[2]), 
        .Y(n518) );
  AO22X1 U1052 ( .A0(ld_instr), .A1(in_xrom_a[2]), .B0(n1480), .B1(n411), .Y(
        n542) );
  DFFRX2 in_idat1_r_reg_0_ ( .D(in_idat_r[0]), .CK(clk), .RN(n481), .QN(n755)
         );
  DFFQX1 int_vec3_reg_0_ ( .D(int_vec2[0]), .CK(clk), .Q(int_vec3[0]) );
  CLKINVX1 U1053 ( .A(n725), .Y(addr_a[7]) );
  NAND3X1 U1054 ( .A(sel_op2[0]), .B(n908), .C(sel_op2[1]), .Y(n842) );
  NAND3X1 U1055 ( .A(n910), .B(n908), .C(sel_op2[1]), .Y(n901) );
  CLKINVX1 U1056 ( .A(n743), .Y(n1153) );
  CLKINVX1 U1057 ( .A(n745), .Y(n1354) );
  CLKINVX1 U1058 ( .A(n745), .Y(n1151) );
  CLKINVX1 U1059 ( .A(sel_xad), .Y(n12) );
  NAND3X1 U1060 ( .A(n910), .B(sel_op2[2]), .C(n907), .Y(n838) );
  NAND3X1 U1061 ( .A(sel_op2[0]), .B(sel_op2[2]), .C(n907), .Y(n840) );
  CLKINVX1 U1062 ( .A(n919), .Y(n965) );
  NAND2X1 U1063 ( .A(n637), .B(n638), .Y(n1177) );
  NAND2X1 U1064 ( .A(n625), .B(n611), .Y(n1178) );
  NAND2X1 U1065 ( .A(n629), .B(n639), .Y(n1227) );
  NAND2X1 U1066 ( .A(n637), .B(n625), .Y(n1167) );
  NAND2X1 U1067 ( .A(n1057), .B(n1058), .Y(n1051) );
  NOR2X1 U1068 ( .A(n1037), .B(n1007), .Y(n1058) );
  NOR2X1 U1069 ( .A(n809), .B(n1011), .Y(n1057) );
  NOR2X1 U1070 ( .A(n1006), .B(addr2_a_2_), .Y(n1075) );
  CLKINVX1 U1071 ( .A(n793), .Y(n997) );
  AND2X1 U1072 ( .A(n1059), .B(addr2_a_2_), .Y(n628) );
  CLKINVX1 U1073 ( .A(n1011), .Y(n792) );
  NOR2X1 U1074 ( .A(n793), .B(n794), .Y(n790) );
  CLKINVX1 U1075 ( .A(n994), .Y(n1026) );
  CLKINVX1 U1076 ( .A(n802), .Y(n798) );
  CLKINVX1 U1077 ( .A(n1009), .Y(n1069) );
  CLKINVX1 U1078 ( .A(n996), .Y(n1038) );
  CLKBUFX2 U1079 ( .A(n1483), .Y(n737) );
  CLKINVX1 U1080 ( .A(n825), .Y(n824) );
  CLKINVX1 U1081 ( .A(sel_bit_dat_out[1]), .Y(n1068) );
  NAND3X1 U1082 ( .A(n1331), .B(n1306), .C(n1307), .Y(n1103) );
  CLKINVX1 U1083 ( .A(n1106), .Y(n1080) );
  CLKBUFX2 U1084 ( .A(n1084), .Y(n743) );
  CLKBUFX2 U1085 ( .A(n1081), .Y(n745) );
  CLKBUFX2 U1086 ( .A(n1084), .Y(n744) );
  CLKBUFX2 U1087 ( .A(n1081), .Y(n746) );
  CLKBUFX2 U1088 ( .A(n1086), .Y(n742) );
  CLKBUFX2 U1089 ( .A(n1086), .Y(n741) );
  CLKINVX1 U1090 ( .A(n1120), .Y(n1141) );
  CLKINVX1 U1091 ( .A(ld_xrom), .Y(n253) );
  CLKINVX1 U1092 ( .A(ld_sfr), .Y(n26) );
  CLKINVX1 U1093 ( .A(ld_operand2), .Y(n254) );
  CLKINVX1 U1094 ( .A(sel_in_cy_bit[2]), .Y(n408) );
  CLKINVX1 U1095 ( .A(n747), .Y(n252) );
  NOR2X1 U1096 ( .A(ld_adptr), .B(ld_apc), .Y(n630) );
  CLKINVX1 U1097 ( .A(n432), .Y(n412) );
  NAND2BX1 U1098 ( .AN(ld_apc), .B(ld_adptr), .Y(n432) );
  NAND3X1 U1099 ( .A(n979), .B(n977), .C(sel_op1[0]), .Y(n922) );
  NAND3X1 U1100 ( .A(n979), .B(n976), .C(n977), .Y(n921) );
  NAND3X1 U1101 ( .A(sel_op1[1]), .B(n977), .C(sel_op1[0]), .Y(n912) );
  NAND2X1 U1102 ( .A(n1408), .B(n604), .Y(n1395) );
  OR2X1 U1103 ( .A(n935), .B(n912), .Y(n632) );
  OR2X1 U1104 ( .A(n942), .B(n912), .Y(n633) );
  OR2X1 U1105 ( .A(n949), .B(n912), .Y(n634) );
  NOR2X1 U1106 ( .A(n281), .B(n1103), .Y(n1136) );
  OR2X1 U1107 ( .A(n956), .B(n912), .Y(n635) );
  NAND2X1 U1108 ( .A(n646), .B(n648), .Y(n1009) );
  NAND4X1 U1109 ( .A(n994), .B(n995), .C(n996), .D(n997), .Y(n811) );
  NOR2X1 U1110 ( .A(n1008), .B(n1026), .Y(n1025) );
  NAND4X1 U1111 ( .A(n819), .B(n1009), .C(n1010), .D(n1039), .Y(n804) );
  CLKINVX1 U1112 ( .A(n809), .Y(n1039) );
  NAND4X1 U1113 ( .A(n1009), .B(n803), .C(n1010), .D(n792), .Y(n820) );
  NAND2X1 U1114 ( .A(n646), .B(n628), .Y(n1021) );
  NAND2X1 U1115 ( .A(n648), .B(n647), .Y(n989) );
  NAND2X1 U1116 ( .A(n591), .B(n647), .Y(n984) );
  NAND2X1 U1117 ( .A(n646), .B(n587), .Y(n1013) );
  NOR2X1 U1118 ( .A(n1195), .B(n956), .Y(n1315) );
  NOR2X1 U1119 ( .A(n1195), .B(n949), .Y(n1290) );
  NOR2X1 U1120 ( .A(n1195), .B(n926), .Y(n1219) );
  NOR2X1 U1121 ( .A(n1195), .B(n935), .Y(n1244) );
  NOR2X1 U1122 ( .A(n1195), .B(n942), .Y(n1267) );
  NAND2X1 U1123 ( .A(n1019), .B(n1021), .Y(n1011) );
  CLKINVX1 U1124 ( .A(sel_combus[3]), .Y(n1344) );
  NAND2X1 U1125 ( .A(n1071), .B(n997), .Y(n825) );
  NOR2X1 U1126 ( .A(n810), .B(n1073), .Y(n1071) );
  NAND2X1 U1127 ( .A(n985), .B(n996), .Y(n1073) );
  CLKINVX1 U1128 ( .A(n820), .Y(n818) );
  CLKINVX1 U1129 ( .A(n995), .Y(n1064) );
  NAND3X1 U1130 ( .A(sel_pc[0]), .B(n363), .C(n1307), .Y(n1106) );
  NAND3X1 U1131 ( .A(n1306), .B(sel_pc[0]), .C(n1307), .Y(n1088) );
  NAND3X1 U1132 ( .A(n1306), .B(n1331), .C(sel_pc[2]), .Y(n1120) );
  NAND3X1 U1133 ( .A(n363), .B(n1331), .C(sel_pc[2]), .Y(n1081) );
  NAND3X1 U1134 ( .A(n363), .B(sel_pc[0]), .C(sel_pc[2]), .Y(n1086) );
  CLKINVX1 U1135 ( .A(sel_pc[2]), .Y(n1307) );
  NAND3X1 U1136 ( .A(n1331), .B(n363), .C(n1307), .Y(n1084) );
  AND2X2 U1137 ( .A(sel_xaddr_low), .B(sel_xad), .Y(n640) );
  CLKINVX1 U1138 ( .A(n23), .Y(n15) );
  NAND2BX1 U1139 ( .AN(sel_xaddr_low), .B(sel_xad), .Y(n23) );
  NOR2X1 U1140 ( .A(n742), .B(n1139), .Y(n1138) );
  NOR2X1 U1141 ( .A(n1111), .B(n741), .Y(n1110) );
  CLKINVX1 U1142 ( .A(n363), .Y(n1306) );
  CLKINVX1 U1143 ( .A(sel_in_cy_bit[1]), .Y(n410) );
  CLKBUFX2 U1144 ( .A(ld_latch_acc), .Y(n747) );
  NOR2X2 U1145 ( .A(n929), .B(n930), .Y(n924) );
  NAND3X1 U1146 ( .A(sel_op1[2]), .B(n979), .C(sel_op1[0]), .Y(n916) );
  NOR2BX4 U1147 ( .AN(n641), .B(n1022), .Y(addr_a[6]) );
  OR2X1 U1148 ( .A(n1006), .B(n1370), .Y(n641) );
  CLKINVX1 U1149 ( .A(bit_addr), .Y(n1412) );
  NAND2X1 U1150 ( .A(n830), .B(out_sfr_a[3]), .Y(n875) );
  NAND2X1 U1151 ( .A(n830), .B(out_sfr_a[5]), .Y(n855) );
  NAND2X1 U1152 ( .A(n830), .B(out_sfr_a[4]), .Y(n865) );
  NAND2X1 U1153 ( .A(n830), .B(out_sfr_a[2]), .Y(n885) );
  NAND2X1 U1154 ( .A(n830), .B(out_sfr_a[6]), .Y(n845) );
  CLKINVX1 U1155 ( .A(a_plus_dptr[3]), .Y(n1139) );
  MXI2X2 U1156 ( .S0(bit_addr), .B(n1395), .A(n728), .Y(n732) );
  NOR2X1 U1157 ( .A(n862), .B(n922), .Y(n932) );
  OAI21X1 U1158 ( .A0(n375), .A1(n1032), .B0(n1330), .Y(n1329) );
  CLKINVX1 U1159 ( .A(n1103), .Y(n1330) );
  OAI21X1 U1160 ( .A0(n375), .A1(n1032), .B0(n1093), .Y(n1092) );
  CLKINVX1 U1161 ( .A(n1088), .Y(n1093) );
  CLKINVX1 U1162 ( .A(out_sfr_a[5]), .Y(n935) );
  NAND2X4 U1163 ( .A(alu_a[2]), .B(n627), .Y(n1313) );
  NAND4BX2 U1164 ( .AN(n939), .B(n940), .C(n941), .D(n633), .Y(op1[4]) );
  NOR2X1 U1165 ( .A(n872), .B(n922), .Y(n939) );
  NOR2X1 U1166 ( .A(n943), .B(n944), .Y(n940) );
  CLKINVX1 U1167 ( .A(out_sfr_a[4]), .Y(n942) );
  NOR2X1 U1168 ( .A(n287), .B(n1103), .Y(n1150) );
  NOR2X1 U1169 ( .A(n287), .B(n1088), .Y(n1076) );
  NAND2X2 U1170 ( .A(alu_a[3]), .B(n627), .Y(n1288) );
  NOR2X1 U1171 ( .A(n882), .B(n922), .Y(n946) );
  CLKINVX1 U1172 ( .A(out_sfr_a[3]), .Y(n949) );
  CLKINVX1 U1173 ( .A(n98), .Y(n1142) );
  NOR2X1 U1174 ( .A(n892), .B(n922), .Y(n953) );
  NOR2X1 U1175 ( .A(n114), .B(n912), .Y(n1040) );
  NAND3X1 U1176 ( .A(n1028), .B(n593), .C(n1029), .Y(n1027) );
  CLKINVX1 U1177 ( .A(n1030), .Y(n1028) );
  NAND2BX1 U1178 ( .AN(bit_addr), .B(n48), .Y(n1029) );
  CLKINVX1 U1179 ( .A(out_sfr_a[2]), .Y(n956) );
  CLKINVX1 U1180 ( .A(n87), .Y(n281) );
  NAND2X1 U1181 ( .A(alu_a[6]), .B(n627), .Y(n1217) );
  NAND2X1 U1182 ( .A(alu_a[4]), .B(n627), .Y(n1265) );
  NAND2X1 U1183 ( .A(out_sfr_a[1]), .B(n964), .Y(n963) );
  CLKINVX1 U1184 ( .A(n912), .Y(n964) );
  NAND3X1 U1185 ( .A(n1017), .B(n592), .C(n1018), .Y(n1016) );
  CLKINVX1 U1186 ( .A(n1020), .Y(n1017) );
  NAND2BX1 U1187 ( .AN(bit_addr), .B(n61), .Y(n1018) );
  NAND2X1 U1188 ( .A(alu_a[5]), .B(n627), .Y(n1242) );
  CLKINVX1 U1189 ( .A(n78), .Y(n77) );
  CLKINVX1 U1190 ( .A(n48), .Y(n1113) );
  NAND2BX1 U1191 ( .AN(n1103), .B(n38), .Y(n1102) );
  CLKINVX1 U1192 ( .A(n61), .Y(n269) );
  NAND2X1 U1193 ( .A(out_sfr_a[1]), .B(n1164), .Y(n1158) );
  NAND2X1 U1194 ( .A(n674), .B(n628), .Y(n1019) );
  NAND2X1 U1195 ( .A(out_sfr_a[1]), .B(n825), .Y(n1060) );
  AND2X1 U1196 ( .A(n555), .B(n1072), .Y(n646) );
  AND2X1 U1197 ( .A(addr2_a_1_), .B(n555), .Y(n647) );
  NOR2X1 U1198 ( .A(n1195), .B(n791), .Y(n1194) );
  NOR2X1 U1199 ( .A(n729), .B(n1006), .Y(n1074) );
  CLKINVX1 U1200 ( .A(n1072), .Y(addr2_a_1_) );
  NOR2X1 U1201 ( .A(n862), .B(n1106), .Y(n1117) );
  NAND2BX1 U1202 ( .AN(n744), .B(page_addr_a[10]), .Y(n649) );
  NOR2X1 U1203 ( .A(n882), .B(n1106), .Y(n1137) );
  NOR2X1 U1204 ( .A(n852), .B(n1106), .Y(n1112) );
  CLKINVX1 U1205 ( .A(a_plus_dptr[14]), .Y(n1211) );
  CLKINVX1 U1206 ( .A(a_plus_dptr[12]), .Y(n1259) );
  CLKINVX1 U1207 ( .A(a_plus_dptr[10]), .Y(n1305) );
  CLKINVX1 U1208 ( .A(ld_idat), .Y(n402) );
  NOR2X1 U1209 ( .A(n1155), .B(n742), .Y(n1154) );
  CLKINVX1 U1210 ( .A(n251), .Y(n231) );
  NAND2BX1 U1211 ( .AN(n1479), .B(inc_pc3), .Y(n251) );
  CLKINVX1 U1212 ( .A(sel_in_cy_bit[0]), .Y(n409) );
  NOR2X1 U1213 ( .A(inc_pc3), .B(n1479), .Y(n650) );
  CLKINVX1 U1214 ( .A(sel_page_addr), .Y(n10) );
  CLKINVX1 U1215 ( .A(n1022), .Y(n491) );
  CLKINVX1 U1216 ( .A(n375), .Y(n1048) );
  CLKINVX1 U1217 ( .A(n1032), .Y(n1047) );
  NAND2X4 U1218 ( .A(n896), .B(n897), .Y(n895) );
  OAI21X1 U1219 ( .A0(n269), .A1(n1088), .B0(n1231), .Y(in_pc[13]) );
  OAI21X1 U1220 ( .A0(n281), .A1(n1088), .B0(n1277), .Y(in_pc[11]) );
  NAND4BX1 U1221 ( .AN(n1076), .B(n1077), .C(n1078), .D(n1079), .Y(in_pc[9])
         );
  NAND4BX1 U1222 ( .AN(n1089), .B(n1090), .C(n1091), .D(n1092), .Y(in_pc[8])
         );
  OAI21X1 U1223 ( .A0(n1113), .A1(n1088), .B0(n1206), .Y(in_pc[14]) );
  OAI21X1 U1224 ( .A0(n77), .A1(n1088), .B0(n1254), .Y(in_pc[12]) );
  OAI21X1 U1225 ( .A0(n1142), .A1(n1088), .B0(n1300), .Y(in_pc[10]) );
  CLKINVX1 U1226 ( .A(n1162), .Y(n1353) );
  NOR2X1 U1227 ( .A(n1387), .B(n576), .Y(n1429) );
  NOR2X1 U1228 ( .A(n1387), .B(n577), .Y(n1440) );
  NOR2X1 U1229 ( .A(n1387), .B(n578), .Y(n1386) );
  NOR2X1 U1230 ( .A(n1387), .B(n575), .Y(n1403) );
  OR2X1 U1231 ( .A(n852), .B(n842), .Y(n653) );
  NAND4X2 U1232 ( .A(n1455), .B(n562), .C(n1456), .D(n1457), .Y(n1454) );
  OR2X1 U1233 ( .A(n862), .B(n842), .Y(n654) );
  NAND4X2 U1234 ( .A(n1444), .B(n561), .C(n1445), .D(n1446), .Y(n1443) );
  NOR2X2 U1235 ( .A(n1451), .B(n1452), .Y(n1444) );
  NOR2X2 U1236 ( .A(n1449), .B(n1450), .Y(n1445) );
  NOR2X1 U1237 ( .A(n841), .B(n842), .Y(n826) );
  NOR2X1 U1238 ( .A(n836), .B(n837), .Y(n827) );
  NOR2X1 U1239 ( .A(n1384), .B(n574), .Y(n1400) );
  NOR2X1 U1240 ( .A(n1383), .B(n1124), .Y(n1401) );
  NOR2X1 U1241 ( .A(n1384), .B(n559), .Y(n1447) );
  NOR2X1 U1242 ( .A(n1383), .B(n1147), .Y(n1448) );
  NAND3X2 U1243 ( .A(n1467), .B(n1468), .C(n1469), .Y(n1466) );
  MXI2X1 U1244 ( .S0(n553), .B(n1476), .A(n1475), .Y(n1467) );
  MXI2X1 U1245 ( .S0(sel_addr1[2]), .B(n1471), .A(n1470), .Y(n1469) );
  NOR2X1 U1246 ( .A(n569), .B(n919), .Y(n918) );
  NOR2X1 U1247 ( .A(n920), .B(n921), .Y(n917) );
  NOR2X1 U1248 ( .A(n1384), .B(n570), .Y(n1381) );
  NOR2X1 U1249 ( .A(n1383), .B(n1111), .Y(n1382) );
  NOR2X1 U1250 ( .A(n1436), .B(n1437), .Y(n1435) );
  NOR2X1 U1251 ( .A(n1384), .B(n560), .Y(n1436) );
  NOR2X1 U1252 ( .A(n1383), .B(n1139), .Y(n1437) );
  NOR2X1 U1253 ( .A(n1384), .B(n1055), .Y(n1458) );
  NOR2X1 U1254 ( .A(n1383), .B(n1155), .Y(n1459) );
  NAND2X1 U1255 ( .A(n830), .B(out_sfr_a[0]), .Y(n1045) );
  NOR2X8 U1256 ( .A(n657), .B(n658), .Y(n656) );
  CLKINVX1 U1257 ( .A(n1010), .Y(n1056) );
  NOR2X1 U1258 ( .A(n585), .B(n840), .Y(n859) );
  NOR2X1 U1259 ( .A(n583), .B(n840), .Y(n849) );
  NOR2X1 U1260 ( .A(n579), .B(n840), .Y(n836) );
  DFFRX1 addr2_r_reg_7_ ( .D(n737), .CK(clk), .RN(n481), .Q(msb_r) );
  NOR2X1 U1261 ( .A(n570), .B(n919), .Y(n930) );
  NOR2X1 U1262 ( .A(n931), .B(n921), .Y(n929) );
  DFFRX1 in_xrom1_r_reg_7_ ( .D(n515), .CK(clk), .RN(n481), .Q(in_xrom1_r[7]), 
        .QN(n764) );
  NOR2X1 U1263 ( .A(n848), .B(n915), .Y(n928) );
  NAND2X2 U1264 ( .A(alu_a[1]), .B(n627), .Y(n1163) );
  AOI21X1 U1265 ( .A0(rel_addr_a[0]), .A1(n1354), .B0(n1355), .Y(n1328) );
  NOR2X1 U1266 ( .A(n980), .B(n1106), .Y(n1326) );
  NOR2X1 U1267 ( .A(n1359), .B(n1360), .Y(n1327) );
  NOR2X1 U1268 ( .A(n574), .B(n919), .Y(n937) );
  NOR2X1 U1269 ( .A(n938), .B(n921), .Y(n936) );
  DFFRX1 in_xrom1_r_reg_1_ ( .D(n509), .CK(clk), .RN(n481), .Q(in_xrom1_r[1]), 
        .QN(n770) );
  DFFRX1 in_xrom1_r_reg_2_ ( .D(n510), .CK(clk), .RN(n481), .Q(in_xrom1_r[2]), 
        .QN(n769) );
  DFFRX1 in_xrom1_r_reg_3_ ( .D(n511), .CK(clk), .RN(n481), .Q(in_xrom1_r[3]), 
        .QN(n768) );
  AND2X2 U1270 ( .A(n659), .B(n660), .Y(n934) );
  OR2X1 U1271 ( .A(n858), .B(n915), .Y(n660) );
  DFFRX1 out_sfr_r_reg_0_ ( .D(n492), .CK(clk), .RN(n481), .Q(out_sfr_r[0]), 
        .QN(n681) );
  DFFRX1 out_sfr_r_reg_5_ ( .D(n497), .CK(clk), .RN(n481), .Q(out_sfr_r[5]), 
        .QN(n585) );
  DFFRX1 out_sfr_r_reg_6_ ( .D(n498), .CK(clk), .RN(n481), .Q(out_sfr_r[6]), 
        .QN(n583) );
  DFFRX1 out_sfr_r_reg_4_ ( .D(n496), .CK(clk), .RN(n481), .Q(out_sfr_r[4]), 
        .QN(n584) );
  DFFRX1 out_sfr_r_reg_7_ ( .D(n499), .CK(clk), .RN(n481), .Q(out_sfr_r[7]), 
        .QN(n579) );
  OR2X1 U1272 ( .A(n868), .B(n915), .Y(n662) );
  NOR2X1 U1273 ( .A(n573), .B(n919), .Y(n944) );
  NOR2X1 U1274 ( .A(n945), .B(n921), .Y(n943) );
  OAI22X1 U1275 ( .A0(n746), .A1(n1146), .B0(n1147), .B1(n741), .Y(n1145) );
  OAI21X1 U1276 ( .A0(n744), .A1(n1148), .B0(n1149), .Y(n1144) );
  NOR2X1 U1277 ( .A(n560), .B(n919), .Y(n951) );
  NOR2X1 U1278 ( .A(n952), .B(n921), .Y(n950) );
  AND2X2 U1279 ( .A(n663), .B(n664), .Y(n948) );
  OR2X1 U1280 ( .A(n878), .B(n915), .Y(n664) );
  NOR2X1 U1281 ( .A(n798), .B(n570), .Y(n796) );
  NOR3X2 U1282 ( .A(n973), .B(n974), .C(n975), .Y(n972) );
  NOR2X1 U1283 ( .A(n980), .B(n922), .Y(n973) );
  AND3X2 U1284 ( .A(n1140), .B(n1121), .C(n1141), .Y(n665) );
  OAI21X1 U1285 ( .A0(n1004), .A1(n34), .B0(n1005), .Y(n76) );
  NOR2X1 U1286 ( .A(n1007), .B(n1008), .Y(n1004) );
  NAND2X1 U1287 ( .A(n78), .B(n1006), .Y(n1005) );
  NOR2X1 U1288 ( .A(n1273), .B(n1274), .Y(n1260) );
  NOR3X1 U1289 ( .A(n1268), .B(n1269), .C(n1270), .Y(n1261) );
  NOR2X1 U1290 ( .A(n1266), .B(n1267), .Y(n1262) );
  CLKINVX1 U1291 ( .A(out_sfr_a[0]), .Y(n114) );
  AND2X2 U1292 ( .A(n666), .B(n667), .Y(n955) );
  OR2X1 U1293 ( .A(n888), .B(n915), .Y(n667) );
  NOR2X1 U1294 ( .A(n798), .B(n574), .Y(n800) );
  NAND4X2 U1295 ( .A(n1187), .B(n1188), .C(n1189), .D(n3150), .Y(n38) );
  NOR3X1 U1296 ( .A(n1196), .B(n1197), .C(n1198), .Y(n1188) );
  NOR2X1 U1297 ( .A(n1202), .B(n1203), .Y(n1187) );
  NOR2X1 U1298 ( .A(n1193), .B(n1194), .Y(n1189) );
  NOR2X1 U1299 ( .A(n580), .B(n919), .Y(n975) );
  NOR2X1 U1300 ( .A(n978), .B(n921), .Y(n974) );
  NOR2X1 U1301 ( .A(n559), .B(n919), .Y(n958) );
  NOR2X1 U1302 ( .A(n959), .B(n921), .Y(n957) );
  NOR2X1 U1303 ( .A(n967), .B(n921), .Y(n966) );
  AND2X8 U1304 ( .A(n668), .B(n669), .Y(n789) );
  OA22X1 U1305 ( .A0(n790), .A1(n791), .B0(n792), .B1(n569), .Y(n669) );
  NAND2X1 U1306 ( .A(alu_a[7]), .B(n627), .Y(n1192) );
  NOR2X1 U1307 ( .A(n1037), .B(n1038), .Y(n1035) );
  NAND2X1 U1308 ( .A(n38), .B(n1006), .Y(n1036) );
  NOR2X1 U1309 ( .A(n1126), .B(n1127), .Y(n1125) );
  OAI22X1 U1310 ( .A0(n746), .A1(n1128), .B0(n742), .B1(n1129), .Y(n1127) );
  OAI21X1 U1311 ( .A0(n1120), .A1(n1130), .B0(n1131), .Y(n1126) );
  NAND2X1 U1312 ( .A(n1363), .B(n406), .Y(in_cy_bit) );
  NOR4X1 U1313 ( .A(n1115), .B(n1116), .C(n1117), .D(n1118), .Y(n1114) );
  NOR3X1 U1314 ( .A(n1120), .B(n1121), .C(n1122), .Y(n1116) );
  OAI22X1 U1315 ( .A0(n746), .A1(n1123), .B0(n1124), .B1(n742), .Y(n1115) );
  NOR2X1 U1316 ( .A(n841), .B(n1106), .Y(n1099) );
  AOI21X1 U1317 ( .A0(page_addr_a[7]), .A1(n1153), .B0(n1104), .Y(n110000) );
  NAND2X1 U1318 ( .A(rel_addr_a[7]), .B(n1354), .Y(n1101) );
  AOI21X1 U1319 ( .A0(rel_addr_a[6]), .A1(n1354), .B0(n1110), .Y(n1109) );
  AOI21X1 U1320 ( .A0(page_addr_a[6]), .A1(n1153), .B0(n1112), .Y(n1108) );
  NOR2X1 U1321 ( .A(n1113), .B(n1103), .Y(n1107) );
  OAI21X1 U1322 ( .A0(n37), .A1(n1088), .B0(n1182), .Y(in_pc[15]) );
  NOR2X1 U1323 ( .A(n1183), .B(n1184), .Y(n1182) );
  CLKINVX1 U1324 ( .A(n38), .Y(n37) );
  NAND3X1 U1325 ( .A(n676), .B(n1186), .C(n675), .Y(n1183) );
  OAI22X1 U1326 ( .A0(n1023), .A1(n926), .B0(n34), .B1(n1015), .Y(n797) );
  NAND2X1 U1327 ( .A(n1013), .B(n996), .Y(n1024) );
  OAI22X1 U1328 ( .A0(n1012), .A1(n935), .B0(n34), .B1(n1013), .Y(n801) );
  NAND2X1 U1329 ( .A(n1015), .B(n996), .Y(n1014) );
  OAI22X1 U1330 ( .A0(n981), .A1(n956), .B0(n34), .B1(n982), .Y(n817) );
  NAND2X1 U1331 ( .A(n984), .B(n985), .Y(n983) );
  OAI22X1 U1332 ( .A0(n992), .A1(n949), .B0(n34), .B1(n984), .Y(n814) );
  NAND2X1 U1333 ( .A(n982), .B(n985), .Y(n993) );
  AND2X2 U1334 ( .A(n670), .B(n671), .Y(n1053) );
  OR2X1 U1335 ( .A(n114), .B(n994), .Y(n670) );
  OR2X1 U1336 ( .A(n580), .B(n1009), .Y(n671) );
  NOR2X1 U1337 ( .A(n34), .B(n1010), .Y(n1052) );
  NOR2X1 U1338 ( .A(n34), .B(n1019), .Y(n1030) );
  NOR2X1 U1339 ( .A(n1069), .B(n1026), .Y(n1062) );
  NAND2X1 U1340 ( .A(n1064), .B(out_sfr_a[1]), .Y(n1063) );
  NOR2BX1 U1341 ( .AN(n1072), .B(n673), .Y(n672) );
  NOR2X1 U1342 ( .A(n1175), .B(n581), .Y(n1314) );
  NOR2X1 U1343 ( .A(n1175), .B(n582), .Y(n1289) );
  NOR2X1 U1344 ( .A(n1175), .B(n583), .Y(n1218) );
  NOR2X1 U1345 ( .A(n1175), .B(n585), .Y(n1243) );
  NOR2X1 U1346 ( .A(n1175), .B(n579), .Y(n1193) );
  NOR2X1 U1347 ( .A(n1175), .B(n584), .Y(n1266) );
  AND2X1 U1348 ( .A(addr2_a_1_), .B(n733), .Y(n674) );
  CLKINVX1 U1349 ( .A(n403), .Y(bit_dat_in) );
  CLKINVX1 U1350 ( .A(in_xrom_a[1]), .Y(n971) );
  CLKINVX1 U1351 ( .A(in_xrom_a[0]), .Y(n980) );
  NOR2X1 U1352 ( .A(n1207), .B(n1208), .Y(n1206) );
  NAND3X1 U1353 ( .A(n677), .B(n1210), .C(n595), .Y(n1207) );
  NOR2X1 U1354 ( .A(n746), .B(n1209), .Y(n1208) );
  NOR2X1 U1355 ( .A(n1232), .B(n1233), .Y(n1231) );
  NAND3X1 U1356 ( .A(n678), .B(n1235), .C(n598), .Y(n1232) );
  NOR2X1 U1357 ( .A(n746), .B(n1234), .Y(n1233) );
  NOR2X1 U1358 ( .A(n1255), .B(n1256), .Y(n1254) );
  NAND3X1 U1359 ( .A(n679), .B(n1258), .C(n596), .Y(n1255) );
  NOR2X1 U1360 ( .A(n746), .B(n1257), .Y(n1256) );
  NOR2X1 U1361 ( .A(n1278), .B(n1279), .Y(n1277) );
  NAND3X1 U1362 ( .A(n680), .B(n1281), .C(n599), .Y(n1278) );
  NOR2X1 U1363 ( .A(n745), .B(n1280), .Y(n1279) );
  CLKINVX1 U1364 ( .A(rel_addr_a[14]), .Y(n1209) );
  CLKINVX1 U1365 ( .A(rel_addr_a[13]), .Y(n1234) );
  CLKINVX1 U1366 ( .A(rel_addr_a[12]), .Y(n1257) );
  CLKINVX1 U1367 ( .A(rel_addr_a[11]), .Y(n1280) );
  NOR2X1 U1368 ( .A(n1301), .B(n1302), .Y(n1300) );
  NAND3X1 U1369 ( .A(n649), .B(n1304), .C(n597), .Y(n1301) );
  NOR2X1 U1370 ( .A(n746), .B(n1303), .Y(n1302) );
  NAND2X1 U1371 ( .A(rel_addr_a[9]), .B(n1151), .Y(n1078) );
  CLKINVX1 U1372 ( .A(rel_addr_a[10]), .Y(n1303) );
  NOR2X1 U1373 ( .A(n746), .B(n1098), .Y(n1089) );
  CLKINVX1 U1374 ( .A(rel_addr_a[8]), .Y(n1098) );
  NOR2X1 U1375 ( .A(n1082), .B(n1083), .Y(n1077) );
  NOR2X1 U1376 ( .A(n741), .B(n1087), .Y(n1082) );
  NOR2X1 U1377 ( .A(n743), .B(n1085), .Y(n1083) );
  CLKINVX1 U1378 ( .A(a_plus_dptr[9]), .Y(n1087) );
  NOR2X1 U1379 ( .A(n743), .B(n1119), .Y(n1118) );
  CLKINVX1 U1380 ( .A(page_addr_a[5]), .Y(n1119) );
  NOR2X1 U1381 ( .A(n742), .B(n1362), .Y(n1359) );
  CLKINVX1 U1382 ( .A(a_plus_dptr[0]), .Y(n1362) );
  NOR2X1 U1383 ( .A(n743), .B(n1361), .Y(n1360) );
  CLKINVX1 U1384 ( .A(page_addr_a[0]), .Y(n1361) );
  NOR2X1 U1385 ( .A(n707), .B(n1120), .Y(n1355) );
  NOR2X1 U1386 ( .A(n707), .B(n1120), .Y(n1152) );
  CLKINVX1 U1387 ( .A(a_plus_dptr[13]), .Y(n1236) );
  CLKINVX1 U1388 ( .A(a_plus_dptr[11]), .Y(n1282) );
  NOR2X1 U1389 ( .A(n1094), .B(n1095), .Y(n1090) );
  NOR2X1 U1390 ( .A(n741), .B(n1097), .Y(n1094) );
  NOR2X1 U1391 ( .A(n743), .B(n1096), .Y(n1095) );
  CLKINVX1 U1392 ( .A(a_plus_dptr[8]), .Y(n1097) );
  NOR2X1 U1393 ( .A(n1132), .B(n1133), .Y(n1131) );
  NOR2X1 U1394 ( .A(n872), .B(n1106), .Y(n1132) );
  NOR2X1 U1395 ( .A(n743), .B(n1134), .Y(n1133) );
  CLKINVX1 U1396 ( .A(page_addr_a[4]), .Y(n1134) );
  NAND2X1 U1397 ( .A(n1080), .B(in_xrom_a[2]), .Y(n1149) );
  CLKINVX1 U1398 ( .A(rel_addr_a[5]), .Y(n1123) );
  NAND2BX1 U1399 ( .AN(n741), .B(a_plus_dptr[15]), .Y(n675) );
  NAND2BX1 U1400 ( .AN(n744), .B(page_addr_a[15]), .Y(n676) );
  NAND2BX1 U1401 ( .AN(n744), .B(page_addr_a[14]), .Y(n677) );
  NAND2BX1 U1402 ( .AN(n743), .B(page_addr_a[13]), .Y(n678) );
  NAND2BX1 U1403 ( .AN(n744), .B(page_addr_a[12]), .Y(n679) );
  NAND2BX1 U1404 ( .AN(n744), .B(page_addr_a[11]), .Y(n680) );
  MXI2X1 U1405 ( .S0(n747), .B(n978), .A(n594), .Y(n482) );
  CLKBUFX2 U1406 ( .A(inc_pc2), .Y(n1479) );
  CLKINVX1 U1407 ( .A(rel_addr_a[2]), .Y(n1146) );
  CLKINVX1 U1408 ( .A(rel_addr_a[4]), .Y(n1128) );
  CLKINVX1 U1409 ( .A(n1375), .Y(addr2_a_3_) );
  CLKINVX1 U1410 ( .A(ld_instr), .Y(n411) );
  NOR2X1 U1411 ( .A(n1388), .B(n1389), .Y(n1385) );
  INVX3 U1412 ( .A(out_sp_r[6]), .Y(n1389) );
  INVX3 U1413 ( .A(out_sp_r[3]), .Y(n1442) );
  NOR2X1 U1414 ( .A(n1388), .B(n1453), .Y(n1452) );
  NOR2X1 U1415 ( .A(n1387), .B(n571), .Y(n1451) );
  CLKINVX1 U1416 ( .A(out_b[3]), .Y(n881) );
  CLKINVX1 U1417 ( .A(out_b[2]), .Y(n891) );
  INVX3 U1418 ( .A(out_sp_r[4]), .Y(n1431) );
  NOR2X1 U1419 ( .A(n1393), .B(n784), .Y(n1438) );
  NOR2X1 U1420 ( .A(n1390), .B(n754), .Y(n1462) );
  NOR2X1 U1421 ( .A(n1393), .B(n781), .Y(n1461) );
  NOR2X1 U1422 ( .A(n1393), .B(n782), .Y(n1449) );
  NOR2X2 U1423 ( .A(n1388), .B(n1404), .Y(n1402) );
  INVX3 U1424 ( .A(out_sp_r[5]), .Y(n1404) );
  NOR2X1 U1425 ( .A(n1387), .B(n572), .Y(n1463) );
  NOR2X1 U1426 ( .A(n1388), .B(n1465), .Y(n1464) );
  NOR2X1 U1427 ( .A(n1393), .B(n772), .Y(n1392) );
  NOR2X1 U1428 ( .A(n1394), .B(n765), .Y(n1391) );
  NOR2X1 U1429 ( .A(n1393), .B(n773), .Y(n1406) );
  NAND2X1 U1430 ( .A(in_idat_r[0]), .B(n1051), .Y(n1049) );
  NAND2BX4 U1431 ( .AN(n834), .B(in_idat_a[1]), .Y(n896) );
  OR2X2 U1432 ( .A(n840), .B(n681), .Y(n906) );
  NOR2X1 U1433 ( .A(n584), .B(n840), .Y(n869) );
  NOR2X1 U1434 ( .A(n838), .B(n871), .Y(n870) );
  CLKINVX1 U1435 ( .A(out_b[4]), .Y(n871) );
  NOR2X1 U1436 ( .A(n838), .B(n861), .Y(n860) );
  CLKINVX1 U1437 ( .A(out_b[5]), .Y(n861) );
  NOR2X1 U1438 ( .A(n838), .B(n851), .Y(n850) );
  CLKINVX1 U1439 ( .A(out_b[6]), .Y(n851) );
  NOR2X1 U1440 ( .A(n838), .B(n839), .Y(n837) );
  CLKINVX1 U1441 ( .A(out_b[7]), .Y(n839) );
  INVX1 U1442 ( .A(out_sp_r[1]), .Y(n1465) );
  CLKINVX1 U1443 ( .A(out_acc_r[6]), .Y(n931) );
  CLKINVX1 U1444 ( .A(out_acc_r[7]), .Y(n920) );
  CLKINVX1 U1445 ( .A(out_acc_r[5]), .Y(n938) );
  NAND2X1 U1446 ( .A(in_idat_r[4]), .B(n809), .Y(n807) );
  NOR2X1 U1447 ( .A(n1161), .B(n759), .Y(n1264) );
  NAND2X1 U1448 ( .A(latch_pc_4_), .B(n626), .Y(n1263) );
  CLKINVX1 U1449 ( .A(out_acc_r[4]), .Y(n945) );
  NAND2X1 U1450 ( .A(latch_pc_6_), .B(n626), .Y(n1215) );
  NAND2X1 U1451 ( .A(in_idat_r[4]), .B(n820), .Y(n1002) );
  NAND4BX2 U1452 ( .AN(n960), .B(n961), .C(n962), .D(n963), .Y(op1[1]) );
  NOR2X1 U1453 ( .A(n971), .B(n922), .Y(n960) );
  AOI21X1 U1454 ( .A0(n965), .A1(in_idat_r[1]), .B0(n966), .Y(n962) );
  NOR2X1 U1455 ( .A(n1161), .B(n756), .Y(n1191) );
  NAND2X1 U1456 ( .A(latch_pc_7_), .B(n626), .Y(n1190) );
  CLKINVX1 U1457 ( .A(out_acc_r[3]), .Y(n952) );
  NOR2X1 U1458 ( .A(n916), .B(n1044), .Y(n1041) );
  CLKINVX1 U1459 ( .A(out_sfr_r[0]), .Y(n1044) );
  NOR2X1 U1460 ( .A(n970), .B(n916), .Y(n969) );
  CLKINVX1 U1461 ( .A(out_acc_r[2]), .Y(n959) );
  AOI2BB2X4 U1462 ( .A0N(n1066), .A1N(n685), .B0(n1066), .B1(n1067), .Y(n1065)
         );
  OR2X1 U1463 ( .A(cy_psw), .B(n1068), .Y(n685) );
  CLKINVX1 U1464 ( .A(sel_bit_dat_out[0]), .Y(n1066) );
  MXI2X4 U1465 ( .S0(n737), .B(N109), .A(N110), .Y(n403) );
  CLKINVX1 U1466 ( .A(out_acc_r[0]), .Y(n978) );
  CLKINVX1 U1467 ( .A(out_acc_r[1]), .Y(n967) );
  NAND2X1 U1468 ( .A(latch_pc_0_), .B(n626), .Y(n1348) );
  CLKINVX1 U1469 ( .A(alu_r[1]), .Y(n1179) );
  OAI21X1 U1470 ( .A0(n1178), .A1(n1342), .B0(n1343), .Y(n1338) );
  CLKINVX1 U1471 ( .A(alu_r[0]), .Y(n1342) );
  NAND2X1 U1472 ( .A(in_xdat_a[0]), .B(n1181), .Y(n1343) );
  OAI21X1 U1473 ( .A0(n1175), .A1(n970), .B0(n1176), .Y(n1174) );
  OAI21X1 U1474 ( .A0(n1177), .A1(n594), .B0(n1340), .Y(n1339) );
  INVX1 U1475 ( .A(n1170), .Y(n1341) );
  NAND2X1 U1476 ( .A(in_idat_a[4]), .B(n1172), .Y(n1276) );
  OAI21X1 U1477 ( .A0(n1170), .A1(n938), .B0(n1253), .Y(n1250) );
  NAND2X1 U1478 ( .A(in_idat_a[5]), .B(n1172), .Y(n1253) );
  OAI21X1 U1479 ( .A0(n1170), .A1(n931), .B0(n1230), .Y(n1225) );
  NAND2X1 U1480 ( .A(in_idat_a[6]), .B(n1172), .Y(n1230) );
  OAI21X1 U1481 ( .A0(n1170), .A1(n920), .B0(n1205), .Y(n1202) );
  OAI21X1 U1482 ( .A0(n1055), .A1(n1167), .B0(n1168), .Y(n1166) );
  NAND2X1 U1483 ( .A(n1169), .B(in_xrom_r[1]), .Y(n1168) );
  OAI21X1 U1484 ( .A0(n559), .A1(n1167), .B0(n1323), .Y(n1322) );
  NAND2X1 U1485 ( .A(n1169), .B(in_xrom_r[2]), .Y(n1323) );
  OAI21X1 U1486 ( .A0(n569), .A1(n1167), .B0(n1204), .Y(n1203) );
  NAND2X1 U1487 ( .A(n1169), .B(in_xrom_r[7]), .Y(n1204) );
  OAI21X1 U1488 ( .A0(n1227), .A1(n577), .B0(n1298), .Y(n1297) );
  NAND2X1 U1489 ( .A(in_idat_r[3]), .B(n1229), .Y(n1298) );
  OAI21X1 U1490 ( .A0(n1227), .A1(n578), .B0(n1228), .Y(n1226) );
  NAND2X1 U1491 ( .A(in_idat_r[6]), .B(n1229), .Y(n1228) );
  OAI21X1 U1492 ( .A0(n1227), .A1(n575), .B0(n1252), .Y(n1251) );
  NAND2X1 U1493 ( .A(in_idat_r[5]), .B(n1229), .Y(n1252) );
  OAI21X1 U1494 ( .A0(n1227), .A1(n576), .B0(n1275), .Y(n1274) );
  NAND2X1 U1495 ( .A(in_idat_r[4]), .B(n1229), .Y(n1275) );
  NOR2X1 U1496 ( .A(n1177), .B(n779), .Y(n1316) );
  NOR2X1 U1497 ( .A(n1177), .B(n778), .Y(n1291) );
  NOR2X1 U1498 ( .A(n1177), .B(n775), .Y(n1220) );
  NOR2X1 U1499 ( .A(n1177), .B(n776), .Y(n1245) );
  NOR2X1 U1500 ( .A(n1177), .B(n774), .Y(n1196) );
  NOR2X1 U1501 ( .A(n1177), .B(n777), .Y(n1268) );
  CLKINVX1 U1502 ( .A(alu_r[2]), .Y(n1320) );
  CLKINVX1 U1503 ( .A(alu_r[3]), .Y(n1295) );
  NOR2X1 U1504 ( .A(n1178), .B(n1224), .Y(n1221) );
  CLKINVX1 U1505 ( .A(alu_r[6]), .Y(n1224) );
  NOR2X1 U1506 ( .A(n1178), .B(n1249), .Y(n1246) );
  CLKINVX1 U1507 ( .A(alu_r[5]), .Y(n1249) );
  NOR2X1 U1508 ( .A(n1178), .B(n1272), .Y(n1269) );
  CLKINVX1 U1509 ( .A(alu_r[4]), .Y(n1272) );
  NOR2X1 U1510 ( .A(n1178), .B(n1201), .Y(n1197) );
  CLKINVX1 U1511 ( .A(alu_r[7]), .Y(n1201) );
  INVX1 U1512 ( .A(in_xdat_a[6]), .Y(n1223) );
  INVX1 U1513 ( .A(in_xdat_a[5]), .Y(n1248) );
  NOR2X1 U1514 ( .A(n1199), .B(n1200), .Y(n1198) );
  INVX1 U1515 ( .A(in_xdat_a[7]), .Y(n1200) );
  NOR2X1 U1516 ( .A(n1199), .B(n1271), .Y(n1270) );
  INVX1 U1517 ( .A(in_xdat_a[4]), .Y(n1271) );
  NAND3X1 U1518 ( .A(n1334), .B(n1335), .C(n1336), .Y(n1333) );
  NAND2X1 U1519 ( .A(n1229), .B(in_idat_r[0]), .Y(n1334) );
  NAND2X1 U1520 ( .A(out_sfr_r[0]), .B(n1337), .Y(n1335) );
  NAND2X1 U1521 ( .A(n1164), .B(out_sfr_a[0]), .Y(n1336) );
  NOR2BX1 U1522 ( .AN(in_xrom_r[0]), .B(n1227), .Y(n1346) );
  NAND2X1 U1523 ( .A(in_idat_r[7]), .B(n804), .Y(n1033) );
  OAI21X1 U1524 ( .A0(cy_psw), .A1(n407), .B0(n1364), .Y(n406) );
  NOR2X1 U1525 ( .A(n410), .B(sel_in_cy_bit[2]), .Y(n1364) );
  XNOR2X1 U1526 ( .A(n403), .B(sel_in_cy_bit[0]), .Y(n407) );
  MXI2X1 U1527 ( .S0(n409), .B(n1366), .A(n1365), .Y(n1363) );
  NOR2X1 U1528 ( .A(n403), .B(n1367), .Y(n1366) );
  NOR2X1 U1529 ( .A(bit_dat_in), .B(n1368), .Y(n1365) );
  OAI21X1 U1530 ( .A0(cy_psw), .A1(sel_in_cy_bit[2]), .B0(n410), .Y(n1367) );
  NOR2X1 U1531 ( .A(n746), .B(n1185), .Y(n1184) );
  CLKINVX1 U1532 ( .A(rel_addr_a[15]), .Y(n1185) );
  AO21X2 U1533 ( .A0(N342), .A1(n231), .B0(n242), .Y(n539) );
  AO22X2 U1534 ( .A0(N324), .A1(n1479), .B0(out_pc_r[15]), .B1(n650), .Y(n242)
         );
  AO22X1 U1535 ( .A0(out_sfr_a[0]), .A1(ld_sfr), .B0(out_sfr_r[0]), .B1(n26), 
        .Y(n492) );
  AO22X1 U1536 ( .A0(out_sfr_a[2]), .A1(ld_sfr), .B0(out_sfr_r[2]), .B1(n26), 
        .Y(n494) );
  AO22X1 U1537 ( .A0(out_sfr_a[3]), .A1(ld_sfr), .B0(out_sfr_r[3]), .B1(n26), 
        .Y(n495) );
  AO22X1 U1538 ( .A0(out_sfr_a[5]), .A1(ld_sfr), .B0(out_sfr_r[5]), .B1(n26), 
        .Y(n497) );
  AO22X1 U1539 ( .A0(out_sfr_a[6]), .A1(ld_sfr), .B0(out_sfr_r[6]), .B1(n26), 
        .Y(n498) );
  OAI2BB1X1 U1540 ( .A0N(N338), .A1N(n231), .B0(n686), .Y(n535) );
  AOI22X1 U1541 ( .A0(N320), .A1(n1479), .B0(out_pc_r[11]), .B1(n650), .Y(n686) );
  OAI2BB1X1 U1542 ( .A0N(N339), .A1N(n231), .B0(n687), .Y(n536) );
  AOI22X1 U1543 ( .A0(N321), .A1(n1479), .B0(out_pc_r[12]), .B1(n650), .Y(n687) );
  OAI2BB1X1 U1544 ( .A0N(N340), .A1N(n231), .B0(n688), .Y(n537) );
  AOI22X1 U1545 ( .A0(N322), .A1(n1479), .B0(out_pc_r[13]), .B1(n650), .Y(n688) );
  OAI2BB1X1 U1546 ( .A0N(N341), .A1N(n231), .B0(n689), .Y(n538) );
  AOI22X1 U1547 ( .A0(N323), .A1(n1479), .B0(out_pc_r[14]), .B1(n650), .Y(n689) );
  OAI2BB1X1 U1548 ( .A0N(out_acc_r[1]), .A1N(n12), .B0(n690), .Y(out_xdat[1])
         );
  AOI22X1 U1549 ( .A0(out_dptr_r[1]), .A1(n640), .B0(in_idat_r[1]), .B1(n15), 
        .Y(n690) );
  OAI2BB1X1 U1550 ( .A0N(out_acc_r[2]), .A1N(n12), .B0(n691), .Y(out_xdat[2])
         );
  AOI22X1 U1551 ( .A0(out_dptr_r[2]), .A1(n640), .B0(in_idat_r[2]), .B1(n15), 
        .Y(n691) );
  NAND2X1 U1552 ( .A(n1080), .B(in_xrom_r[7]), .Y(n1186) );
  NAND2X1 U1553 ( .A(n1080), .B(in_xrom_r[2]), .Y(n1304) );
  NAND2X1 U1554 ( .A(n1080), .B(in_xrom_r[6]), .Y(n1210) );
  NAND2X1 U1555 ( .A(n1080), .B(in_xrom_r[5]), .Y(n1235) );
  NAND2X1 U1556 ( .A(n1080), .B(in_xrom_r[4]), .Y(n1258) );
  NAND2X1 U1557 ( .A(n1080), .B(in_xrom_r[3]), .Y(n1281) );
  NAND2X1 U1558 ( .A(n1080), .B(in_xrom_r[1]), .Y(n1079) );
  NAND2X1 U1559 ( .A(n1080), .B(in_xrom_r[0]), .Y(n1091) );
  OAI2BB1X1 U1560 ( .A0N(N335), .A1N(n231), .B0(n692), .Y(n532) );
  AOI22X1 U1561 ( .A0(N317), .A1(n1479), .B0(out_pc_r[8]), .B1(n650), .Y(n692)
         );
  OAI2BB1X1 U1562 ( .A0N(N336), .A1N(n231), .B0(n693), .Y(n533) );
  AOI22X1 U1563 ( .A0(n1479), .A1(N318), .B0(out_pc_r[9]), .B1(n650), .Y(n693)
         );
  OAI2BB1X1 U1564 ( .A0N(N337), .A1N(n231), .B0(n694), .Y(n534) );
  AOI22X1 U1565 ( .A0(N319), .A1(n1479), .B0(out_pc_r[10]), .B1(n650), .Y(n694) );
  AO22X1 U1566 ( .A0(in_xrom_r[0]), .A1(n10), .B0(in_xrom_a[0]), .B1(
        sel_page_addr), .Y(xrom[0]) );
  AO22X1 U1567 ( .A0(in_xrom_r[5]), .A1(n10), .B0(in_xrom_a[5]), .B1(
        sel_page_addr), .Y(xrom[5]) );
  CLKINVX1 U1568 ( .A(page_addr_a[2]), .Y(n1148) );
  AO22X1 U1569 ( .A0(in_xrom_r[2]), .A1(n10), .B0(in_xrom_a[2]), .B1(
        sel_page_addr), .Y(xrom[2]) );
  OAI2BB1X1 U1570 ( .A0N(out_acc_r[4]), .A1N(n12), .B0(n695), .Y(out_xdat[4])
         );
  AOI22X1 U1571 ( .A0(out_dptr_r[4]), .A1(n640), .B0(in_idat_r[4]), .B1(n15), 
        .Y(n695) );
  OAI2BB1X1 U1572 ( .A0N(out_acc_r[5]), .A1N(n12), .B0(n696), .Y(out_xdat[5])
         );
  AOI22X1 U1573 ( .A0(out_dptr_r[5]), .A1(n640), .B0(in_idat_r[5]), .B1(n15), 
        .Y(n696) );
  OAI2BB1X1 U1574 ( .A0N(out_acc_r[3]), .A1N(n12), .B0(n697), .Y(out_xdat[3])
         );
  AOI22X1 U1575 ( .A0(out_dptr_r[3]), .A1(n640), .B0(in_idat_r[3]), .B1(n15), 
        .Y(n697) );
  OAI2BB1X1 U1576 ( .A0N(out_acc_r[6]), .A1N(n12), .B0(n698), .Y(out_xdat[6])
         );
  AOI22X1 U1577 ( .A0(out_dptr_r[6]), .A1(n640), .B0(in_idat_r[6]), .B1(n15), 
        .Y(n698) );
  OAI2BB1X1 U1578 ( .A0N(out_acc_r[7]), .A1N(n12), .B0(n699), .Y(out_xdat[7])
         );
  AOI22X1 U1579 ( .A0(out_dptr_r[7]), .A1(n640), .B0(in_idat_r[7]), .B1(n15), 
        .Y(n699) );
  NAND2X1 U1580 ( .A(cy_psw), .B(n408), .Y(n1368) );
  NAND3X1 U1581 ( .A(n786), .B(n787), .C(n788), .Y(out_xdat[0]) );
  NAND2X1 U1582 ( .A(out_dptr_r[0]), .B(n640), .Y(n786) );
  NAND2X1 U1583 ( .A(n15), .B(in_idat_r[0]), .Y(n787) );
  CLKINVX1 U1584 ( .A(sel_xaddr_high), .Y(n11) );
  NOR2BX1 U1585 ( .AN(out_dptr_r[8]), .B(n11), .Y(xaddr_high[0]) );
  NOR2BX1 U1586 ( .AN(out_dptr_r[10]), .B(n11), .Y(xaddr_high[2]) );
  NOR2BX1 U1587 ( .AN(out_dptr_r[13]), .B(n11), .Y(xaddr_high[5]) );
  NOR2BX1 U1588 ( .AN(out_dptr_r[12]), .B(n11), .Y(xaddr_high[4]) );
  NOR2BX1 U1589 ( .AN(out_dptr_r[9]), .B(n11), .Y(xaddr_high[1]) );
  NOR2BX1 U1590 ( .AN(out_dptr_r[11]), .B(n11), .Y(xaddr_high[3]) );
  AO22X1 U1591 ( .A0(n747), .A1(out_acc_r[4]), .B0(latch_acc_4_), .B1(n252), 
        .Y(n486) );
  AO22X1 U1592 ( .A0(n747), .A1(out_acc_r[5]), .B0(latch_acc_5_), .B1(n252), 
        .Y(n487) );
  NOR2BX1 U1593 ( .AN(out_dptr_r[15]), .B(n11), .Y(xaddr_high[7]) );
  NOR2BX1 U1594 ( .AN(out_dptr_r[14]), .B(n11), .Y(xaddr_high[6]) );
  AO22X1 U1595 ( .A0(n747), .A1(out_acc_r[3]), .B0(latch_acc_3_), .B1(n252), 
        .Y(n485) );
  AO22X1 U1596 ( .A0(n747), .A1(out_acc_r[6]), .B0(latch_acc_6_), .B1(n252), 
        .Y(n488) );
  AO22X1 U1597 ( .A0(n747), .A1(out_acc_r[7]), .B0(latch_acc_7_), .B1(n252), 
        .Y(n489) );
  AO22X1 U1598 ( .A0(ld_operand2), .A1(in_xrom_a[5]), .B0(in_xrom1_r[5]), .B1(
        n254), .Y(n513) );
  AO22X2 U1599 ( .A0(ld_operand2), .A1(in_xrom_a[0]), .B0(in_xrom1_r[0]), .B1(
        n254), .Y(n508) );
  OAI2BB1X1 U1600 ( .A0N(N328), .A1N(n231), .B0(n700), .Y(n525) );
  AOI22X1 U1601 ( .A0(N310), .A1(n1479), .B0(out_pc_r[1]), .B1(n650), .Y(n700)
         );
  AO21X2 U1602 ( .A0(N327), .A1(n231), .B0(n248), .Y(n524) );
  AO22X2 U1603 ( .A0(N309), .A1(n1479), .B0(out_pc_r[0]), .B1(n650), .Y(n248)
         );
  OAI2BB1X1 U1604 ( .A0N(N329), .A1N(n231), .B0(n701), .Y(n526) );
  AOI22X1 U1605 ( .A0(N311), .A1(n1479), .B0(out_pc_r[2]), .B1(n650), .Y(n701)
         );
  OAI2BB1X1 U1606 ( .A0N(N330), .A1N(n231), .B0(n702), .Y(n527) );
  AOI22X1 U1607 ( .A0(N312), .A1(n1479), .B0(out_pc_r[3]), .B1(n650), .Y(n702)
         );
  OAI2BB1X1 U1608 ( .A0N(N331), .A1N(n231), .B0(n703), .Y(n528) );
  AOI22X1 U1609 ( .A0(N313), .A1(n1479), .B0(out_pc_r[4]), .B1(n650), .Y(n703)
         );
  OAI2BB1X1 U1610 ( .A0N(N332), .A1N(n231), .B0(n704), .Y(n529) );
  AOI22X1 U1611 ( .A0(N314), .A1(n1479), .B0(out_pc_r[5]), .B1(n650), .Y(n704)
         );
  OAI2BB1X1 U1612 ( .A0N(N333), .A1N(n231), .B0(n705), .Y(n530) );
  AOI22X1 U1613 ( .A0(N315), .A1(n1479), .B0(out_pc_r[6]), .B1(n650), .Y(n705)
         );
  OAI2BB1X1 U1614 ( .A0N(N334), .A1N(n231), .B0(n706), .Y(n531) );
  AOI22X1 U1615 ( .A0(N316), .A1(n1479), .B0(out_pc_r[7]), .B1(n650), .Y(n706)
         );
  AO22X1 U1616 ( .A0(in_xrom_r[4]), .A1(n10), .B0(in_xrom_a[4]), .B1(
        sel_page_addr), .Y(xrom[4]) );
  AO22X1 U1617 ( .A0(in_xrom_r[1]), .A1(n10), .B0(in_xrom_a[1]), .B1(
        sel_page_addr), .Y(xrom[1]) );
  AO22X1 U1618 ( .A0(in_xrom_r[3]), .A1(n10), .B0(in_xrom_a[3]), .B1(
        sel_page_addr), .Y(xrom[3]) );
  AO22X1 U1619 ( .A0(in_xrom_r[6]), .A1(n10), .B0(in_xrom_a[6]), .B1(
        sel_page_addr), .Y(xrom[6]) );
  AO22X1 U1620 ( .A0(in_xrom_r[7]), .A1(n10), .B0(sel_page_addr), .B1(
        in_xrom_a[7]), .Y(xrom[7]) );
  NAND2X1 U1621 ( .A(int_vec3[2]), .B(n1356), .Y(n1122) );
  MXI2X1 U1622 ( .S0(int_vec3[0]), .B(n279), .A(n1135), .Y(n1130) );
  NOR2BX1 U1623 ( .AN(int_vec3[1]), .B(int_vec3[2]), .Y(n279) );
  CLKINVX1 U1624 ( .A(n1122), .Y(n1135) );
  NAND2X1 U1625 ( .A(n1122), .B(n1357), .Y(n1140) );
  NAND2X1 U1626 ( .A(int_vec3[1]), .B(n1358), .Y(n1357) );
  CLKINVX1 U1627 ( .A(int_vec3[2]), .Y(n1358) );
  NOR2X1 U1628 ( .A(n1140), .B(n708), .Y(n707) );
  AND2X2 U1629 ( .A(int_vec3[0]), .B(n1356), .Y(n708) );
  CLKINVX1 U1630 ( .A(int_vec3[0]), .Y(n1121) );
  CLKINVX1 U1631 ( .A(int_vec3[1]), .Y(n1356) );
  AO22X1 U1632 ( .A0(ld_instr), .A1(in_xrom_a[0]), .B0(code[0]), .B1(n411), 
        .Y(n540) );
  CLKINVX3 U1633 ( .A(rst_p), .Y(n481) );
  OAI2BB1X1 U1634 ( .A0N(n412), .A1N(a_plus_dptr[7]), .B0(n709), .Y(
        addr_xrom_a[7]) );
  AOI22X1 U1635 ( .A0(a_plus_pc[7]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[7]), 
        .Y(n709) );
  OAI2BB1X1 U1636 ( .A0N(n412), .A1N(a_plus_dptr[4]), .B0(n710), .Y(
        addr_xrom_a[4]) );
  AOI22X1 U1637 ( .A0(a_plus_pc[4]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[4]), 
        .Y(n710) );
  OAI2BB1X1 U1638 ( .A0N(n412), .A1N(a_plus_dptr[5]), .B0(n711), .Y(
        addr_xrom_a[5]) );
  AOI22X1 U1639 ( .A0(a_plus_pc[5]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[5]), 
        .Y(n711) );
  OAI2BB1X1 U1640 ( .A0N(n412), .A1N(a_plus_dptr[6]), .B0(n712), .Y(
        addr_xrom_a[6]) );
  AOI22X1 U1641 ( .A0(a_plus_pc[6]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[6]), 
        .Y(n712) );
  OAI2BB1X1 U1642 ( .A0N(n412), .A1N(a_plus_dptr[8]), .B0(n713), .Y(
        addr_xrom_a[8]) );
  AOI22X1 U1643 ( .A0(a_plus_pc[8]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[8]), 
        .Y(n713) );
  OAI2BB1X1 U1644 ( .A0N(n412), .A1N(a_plus_dptr[9]), .B0(n714), .Y(
        addr_xrom_a[9]) );
  AOI22X1 U1645 ( .A0(ld_apc), .A1(a_plus_pc[9]), .B0(n630), .B1(out_pc_r[9]), 
        .Y(n714) );
  OAI2BB1X1 U1646 ( .A0N(n412), .A1N(a_plus_dptr[10]), .B0(n715), .Y(
        addr_xrom_a[10]) );
  AOI22X1 U1647 ( .A0(a_plus_pc[10]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[10]), .Y(n715) );
  OAI2BB1X1 U1648 ( .A0N(n412), .A1N(a_plus_dptr[11]), .B0(n716), .Y(
        addr_xrom_a[11]) );
  AOI22X1 U1649 ( .A0(a_plus_pc[11]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[11]), .Y(n716) );
  OAI2BB1X1 U1650 ( .A0N(n412), .A1N(a_plus_dptr[12]), .B0(n717), .Y(
        addr_xrom_a[12]) );
  AOI22X1 U1651 ( .A0(a_plus_pc[12]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[12]), .Y(n717) );
  OAI2BB1X1 U1652 ( .A0N(n412), .A1N(a_plus_dptr[13]), .B0(n718), .Y(
        addr_xrom_a[13]) );
  AOI22X1 U1653 ( .A0(a_plus_pc[13]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[13]), .Y(n718) );
  OAI2BB1X1 U1654 ( .A0N(n412), .A1N(a_plus_dptr[14]), .B0(n719), .Y(
        addr_xrom_a[14]) );
  AOI22X1 U1655 ( .A0(a_plus_pc[14]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[14]), .Y(n719) );
  OAI2BB1X1 U1656 ( .A0N(n412), .A1N(a_plus_dptr[15]), .B0(n720), .Y(
        addr_xrom_a[15]) );
  AOI22X1 U1657 ( .A0(a_plus_pc[15]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[15]), .Y(n720) );
  OAI2BB1X1 U1658 ( .A0N(n412), .A1N(a_plus_dptr[1]), .B0(n721), .Y(
        addr_xrom_a[1]) );
  AOI22X1 U1659 ( .A0(a_plus_pc[1]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[1]), 
        .Y(n721) );
  OAI2BB1X1 U1660 ( .A0N(n412), .A1N(a_plus_dptr[2]), .B0(n722), .Y(
        addr_xrom_a[2]) );
  AOI22X1 U1661 ( .A0(a_plus_pc[2]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[2]), 
        .Y(n722) );
  OAI2BB1X1 U1662 ( .A0N(n412), .A1N(a_plus_dptr[3]), .B0(n723), .Y(
        addr_xrom_a[3]) );
  AOI22X1 U1663 ( .A0(a_plus_pc[3]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[3]), 
        .Y(n723) );
  OAI2BB1X1 U1664 ( .A0N(n412), .A1N(a_plus_dptr[0]), .B0(n724), .Y(
        addr_xrom_a[0]) );
  AOI22X1 U1665 ( .A0(a_plus_pc[0]), .A1(ld_apc), .B0(n630), .B1(out_pc_r[0]), 
        .Y(n724) );
  DFFRX1 in_idat1_r_reg_4_ ( .D(in_idat_r[4]), .CK(clk), .RN(n481), .QN(n751)
         );
  DFFRX1 in_idat1_r_reg_5_ ( .D(in_idat_r[5]), .CK(clk), .RN(n481), .QN(n750)
         );
  DFFRX1 addr2_r_reg_5_ ( .D(n604), .CK(clk), .RN(n481), .QN(n773) );
  DFFRX1 in_idat1_r_reg_7_ ( .D(in_idat_r[7]), .CK(clk), .RN(n481), .QN(n748)
         );
  DFFRX1 in_idat1_r_reg_6_ ( .D(in_idat_r[6]), .CK(clk), .RN(n481), .QN(n749)
         );
  DFFRX1 in_idat1_r_reg_3_ ( .D(in_idat_r[3]), .CK(clk), .RN(n481), .QN(n752)
         );
  DFFRX1 in_idat1_r_reg_2_ ( .D(in_idat_r[2]), .CK(clk), .RN(n481), .QN(n753)
         );
  DFFRX1 in_idat1_r_reg_1_ ( .D(in_idat_r[1]), .CK(clk), .RN(n481), .QN(n754)
         );
  DFFRX1 latch_acc_reg_0_ ( .D(n482), .CK(clk), .RN(n481), .QN(n594) );
  DFFRX1 latch_acc_reg_2_ ( .D(n484), .CK(clk), .RN(n481), .Q(latch_acc_2_), 
        .QN(n779) );
  DFFRX1 latch_acc_reg_3_ ( .D(n485), .CK(clk), .RN(n481), .Q(latch_acc_3_), 
        .QN(n778) );
  DFFRX1 latch_acc_reg_5_ ( .D(n487), .CK(clk), .RN(n481), .Q(latch_acc_5_), 
        .QN(n776) );
  DFFRX1 latch_acc_reg_6_ ( .D(n488), .CK(clk), .RN(n481), .Q(latch_acc_6_), 
        .QN(n775) );
  DFFRX1 latch_pc_reg_9_ ( .D(n533), .CK(clk), .RN(n481), .QN(n762) );
  DFFRX1 latch_pc_reg_10_ ( .D(n534), .CK(clk), .RN(n481), .QN(n761) );
  DFFRX1 latch_pc_reg_11_ ( .D(n535), .CK(clk), .RN(n481), .QN(n760) );
  DFFRX1 latch_pc_reg_12_ ( .D(n536), .CK(clk), .RN(n481), .QN(n759) );
  DFFRX1 latch_pc_reg_13_ ( .D(n537), .CK(clk), .RN(n481), .QN(n758) );
  DFFRX1 latch_pc_reg_14_ ( .D(n538), .CK(clk), .RN(n481), .QN(n757) );
  DFFRX1 latch_pc_reg_1_ ( .D(n525), .CK(clk), .RN(n481), .Q(latch_pc_1_) );
  DFFRX1 latch_pc_reg_2_ ( .D(n526), .CK(clk), .RN(n481), .Q(latch_pc_2_) );
  DFFRX1 latch_pc_reg_3_ ( .D(n527), .CK(clk), .RN(n481), .Q(latch_pc_3_) );
  DFFRX1 latch_pc_reg_4_ ( .D(n528), .CK(clk), .RN(n481), .Q(latch_pc_4_) );
  DFFRX1 latch_pc_reg_5_ ( .D(n529), .CK(clk), .RN(n481), .Q(latch_pc_5_) );
  DFFRX1 latch_pc_reg_6_ ( .D(n530), .CK(clk), .RN(n481), .Q(latch_pc_6_) );
  DFFQX1 alu_r_reg_6_ ( .D(alu_a[6]), .CK(clk), .Q(alu_r[6]) );
  DFFQX1 alu_r_reg_5_ ( .D(alu_a[5]), .CK(clk), .Q(alu_r[5]) );
  DFFQX1 alu_r_reg_3_ ( .D(alu_a[3]), .CK(clk), .Q(alu_r[3]) );
  DFFQX1 alu_r_reg_2_ ( .D(alu_a[2]), .CK(clk), .Q(alu_r[2]) );
  DFFQX1 alu_r_reg_1_ ( .D(alu_a[1]), .CK(clk), .Q(alu_r[1]) );
  DFFQX1 alu_r_reg_0_ ( .D(alu_a[0]), .CK(clk), .Q(alu_r[0]) );
  DFFRX1 latch_acc_reg_1_ ( .D(n483), .CK(clk), .RN(n481), .Q(latch_acc_1_), 
        .QN(n624) );
  DFFRX1 latch_pc_reg_0_ ( .D(n524), .CK(clk), .RN(n481), .Q(latch_pc_0_) );
  DFFRX1 latch_pc_reg_8_ ( .D(n532), .CK(clk), .RN(n481), .QN(n763) );
  DFFRX1 latch_acc_reg_4_ ( .D(n486), .CK(clk), .RN(n481), .Q(latch_acc_4_), 
        .QN(n777) );
  DFFRX1 latch_acc_reg_7_ ( .D(n489), .CK(clk), .RN(n481), .Q(latch_acc_7_), 
        .QN(n774) );
  DFFRX1 latch_pc_reg_15_ ( .D(n539), .CK(clk), .RN(n481), .QN(n756) );
  DFFRX1 latch_pc_reg_7_ ( .D(n531), .CK(clk), .RN(n481), .Q(latch_pc_7_) );
  DFFQX1 alu_r_reg_7_ ( .D(alu_a[7]), .CK(clk), .Q(alu_r[7]) );
  DFFQX1 alu_r_reg_4_ ( .D(alu_a[4]), .CK(clk), .Q(alu_r[4]) );
  DFFRX1 bit_dat_in_r_reg ( .D(bit_dat_in), .CK(clk), .RN(n481), .Q(
        bit_dat_in_r) );
  DFFQX1 int_vec3_reg_2_ ( .D(int_vec2[2]), .CK(clk), .Q(int_vec3[2]) );
  DFFQX1 int_vec3_reg_1_ ( .D(int_vec2[1]), .CK(clk), .Q(int_vec3[1]) );
  NOR2X1 U1666 ( .A(n1477), .B(n1474), .Y(n1473) );
  MXI2X1 U1667 ( .S0(sel_addr0), .B(addr_bank_a[2]), .A(n1443), .Y(n729) );
  NOR2X1 U1668 ( .A(n833), .B(n834), .Y(n832) );
  NOR2X1 U1669 ( .A(n608), .B(n915), .Y(n1042) );
  NOR2X1 U1670 ( .A(n1325), .B(n608), .Y(n1345) );
  NAND2X1 U1671 ( .A(n556), .B(n1172), .Y(n1205) );
  AO22X1 U1672 ( .A0(in_idat_r[0]), .A1(n402), .B0(ld_idat), .B1(n607), .Y(
        n500) );
  CLKINVX1 U1673 ( .A(page_addr_a[9]), .Y(n1085) );
  AO22X1 U1674 ( .A0(in_idat_r[7]), .A1(n402), .B0(ld_idat), .B1(n556), .Y(
        n507) );
  AO22X1 U1675 ( .A0(ld_instr), .A1(in_xrom_a[1]), .B0(code[1]), .B1(n411), 
        .Y(n541) );
  CLKINVX1 U1676 ( .A(page_addr_a[8]), .Y(n1096) );
  NOR3X1 U1677 ( .A(n1460), .B(n1477), .C(n771), .Y(n1472) );
  MXI2X1 U1678 ( .S0(sel_addr0), .B(addr_bank_a[2]), .A(n1443), .Y(n730) );
  MXI2X1 U1679 ( .S0(sel_addr0), .B(addr_bank_a[2]), .A(n1443), .Y(n1070) );
  AOI2BB2X1 U1680 ( .A0N(n1410), .A1N(n1411), .B0(n1409), .B1(n1375), .Y(
        addr_a[0]) );
  MXI2X1 U1681 ( .S0(bit_addr), .B(n1395), .A(n1070), .Y(addr_a[2]) );
  MXI2X4 U1682 ( .S0(bit_addr), .B(n1407), .A(n1072), .Y(n734) );
  MXI2X1 U1683 ( .S0(bit_addr), .B(n1407), .A(n1072), .Y(addr_a[1]) );
  u_datapath_DW01_add_16_4 add_354 ( .A({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, out_acc_r}), .B(out_dptr_r), .CI(1'b0), .SUM(a_plus_dptr)
         );
  MXI2X1 U1684 ( .S0(n1059), .B(n1022), .A(n1375), .Y(addr_a[3]) );
  CLKINVX1 U1685 ( .A(n791), .Y(n740) );
  NOR2X1 U1686 ( .A(n1105), .B(n741), .Y(n1104) );
  MXI2X4 U1687 ( .S0(sel_addr1[2]), .B(a_plus_dptr[0]), .A(out_sp_r[0]), .Y(
        n1474) );
  NOR3X1 U1688 ( .A(n1478), .B(sel_addr1[2]), .C(n780), .Y(n1476) );
  NOR3BX1 U1689 ( .AN(in_xrom_r[0]), .B(sel_addr1[2]), .C(n1477), .Y(n1475) );
  MXI2X4 U1690 ( .S0(n1059), .B(n1022), .A(n1375), .Y(n1482) );
  NAND2X2 U1691 ( .A(n684), .B(n1408), .Y(n1407) );
  NAND2X1 U1692 ( .A(n830), .B(n740), .Y(n829) );
  AO22X1 U1693 ( .A0(out_sfr_a[1]), .A1(ld_sfr), .B0(out_sfr_r[1]), .B1(n26), 
        .Y(n493) );
  AO22X1 U1694 ( .A0(out_sfr_a[4]), .A1(ld_sfr), .B0(out_sfr_r[4]), .B1(n26), 
        .Y(n496) );
  OAI21X1 U1695 ( .A0(n810), .A1(n811), .B0(out_sfr_a[4]), .Y(n806) );
  NAND2X1 U1696 ( .A(out_acc_r[0]), .B(n12), .Y(n788) );
  NAND2X1 U1697 ( .A(n1341), .B(out_acc_r[0]), .Y(n1340) );
  AO22X1 U1698 ( .A0(n740), .A1(ld_sfr), .B0(out_sfr_r[7]), .B1(n26), .Y(n499)
         );
  AOI21X1 U1699 ( .A0(n1370), .A1(n1374), .B0(n1412), .Y(n1410) );
  INVX12 U1700 ( .A(n789), .Y(\out_idat0[7] ) );
  NAND2X6 U1701 ( .A(n795), .B(n41), .Y(\out_idat0[6] ) );
  NAND2X6 U1702 ( .A(n799), .B(n52), .Y(\out_idat0[5] ) );
  INVX12 U1703 ( .A(n805), .Y(\out_idat0[4] ) );
  NAND2X6 U1704 ( .A(n812), .B(n81), .Y(\out_idat0[3] ) );
  NAND2X6 U1705 ( .A(n815), .B(n90), .Y(\out_idat0[2] ) );
  INVX12 U1706 ( .A(n902), .Y(op2_0_) );
  NAND4BX4 U1707 ( .AN(n923), .B(n924), .C(n925), .D(n631), .Y(op1[6]) );
  NAND4BX4 U1708 ( .AN(n932), .B(n933), .C(n934), .D(n632), .Y(op1[5]) );
  NAND4BX4 U1709 ( .AN(n946), .B(n947), .C(n948), .D(n634), .Y(op1[3]) );
  NAND4BX4 U1710 ( .AN(n953), .B(n954), .C(n955), .D(n635), .Y(op1[2]) );
  NAND2X6 U1711 ( .A(n972), .B(n223), .Y(op1[0]) );
  INVX8 U1712 ( .A(n817), .Y(n91) );
  NAND2BX4 U1713 ( .AN(bit_addr), .B(n98), .Y(n988) );
  INVX8 U1714 ( .A(n814), .Y(n82) );
  NAND2BX4 U1715 ( .AN(bit_addr), .B(n87), .Y(n1000) );
  INVX8 U1716 ( .A(n801), .Y(n53) );
  INVX8 U1717 ( .A(n34), .Y(n45) );
  INVX8 U1718 ( .A(n797), .Y(n42) );
  NOR2X8 U1719 ( .A(n375), .B(n1031), .Y(n374) );
  NOR2X8 U1720 ( .A(n375), .B(n1032), .Y(n359) );
  NAND2X6 U1721 ( .A(n1047), .B(n1048), .Y(n117) );
  OAI21X4 U1722 ( .A0(n375), .A1(n1032), .B0(n1006), .Y(n1050) );
  INVX8 U1723 ( .A(n823), .Y(n115) );
  OAI21X4 U1724 ( .A0(n34), .A1(n995), .B0(n1053), .Y(n823) );
  INVX12 U1725 ( .A(n1065), .Y(n34) );
  NOR3BX4 U1726 ( .AN(n1159), .B(n297), .C(n1160), .Y(n294) );
  OAI21X4 U1727 ( .A0(n1162), .A1(n971), .B0(n1163), .Y(n297) );
  OAI21X4 U1728 ( .A0(n1162), .A1(n892), .B0(n1313), .Y(n356) );
  NAND2X6 U1729 ( .A(in_xrom_a[0]), .B(n1353), .Y(n1352) );
  AO22X1 U1730 ( .A0(n747), .A1(out_acc_r[2]), .B0(latch_acc_2_), .B1(n252), 
        .Y(n484) );
  CLKINVX1 U1731 ( .A(sel_pc[1]), .Y(n363) );
  AO22X1 U1732 ( .A0(n747), .A1(out_acc_r[1]), .B0(latch_acc_1_), .B1(n252), 
        .Y(n483) );
  DFFRX1 addr2_r_reg_3_ ( .D(addr2_a_3_), .CK(clk), .RN(n481), .QN(n784) );
  DFFRX1 addr2_r_reg_4_ ( .D(n684), .CK(clk), .RN(n481), .QN(n783) );
  AO22X1 U1733 ( .A0(ld_instr), .A1(in_xrom_a[3]), .B0(code[3]), .B1(n411), 
        .Y(n543) );
  DFFRX1 addr2_r_reg_2_ ( .D(addr2_a_2_), .CK(clk), .RN(n481), .QN(n782) );
  AO22X1 U1734 ( .A0(ld_instr), .A1(in_xrom_a[4]), .B0(code[4]), .B1(n411), 
        .Y(n544) );
  DFFRX1 addr2_r_reg_1_ ( .D(addr2_a_1_), .CK(clk), .RN(n481), .QN(n781) );
  AO22X1 U1735 ( .A0(ld_instr), .A1(in_xrom_a[6]), .B0(code[6]), .B1(n411), 
        .Y(n546) );
  AO22X1 U1736 ( .A0(ld_instr), .A1(in_xrom_a[5]), .B0(code[5]), .B1(n411), 
        .Y(n545) );
  AO22X1 U1737 ( .A0(ld_instr), .A1(in_xrom_a[7]), .B0(code[7]), .B1(n411), 
        .Y(n547) );
  u_datapath_DW01_add_16_3 add_465 ( .A({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, out_acc_r}), .B(out_pc_r), .CI(1'b0), .SUM(a_plus_pc) );
  u_datapath_DW01_add_16_2 add_434 ( .A(out_pc_r), .B({1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0}), .CI(1'b0), .SUM({N342, N341, N340, N339, N338, N337, N336, N335, N334, N333, 
        N332, N331, N330, N329, N328, N327}) );
  u_datapath_DW01_inc_16_0 add_433 ( .A(out_pc_r), .SUM({N324, N323, N322, 
        N321, N320, N319, N318, N317, N316, N315, N314, N313, N312, N311, N310, 
        N309}) );
  u_datapath_DW01_add_16_1 add_387 ( .A(in_rel_adder), .B(out_pc_r), .CI(1'b0), 
        .SUM(rel_addr_a) );
  u_datapath_MUX_OP_8_3_2 C1170 ( .D0_1(n607), .D0_0(out_sfr_a[0]), .D1_1(
        in_idat_a[1]), .D1_0(out_sfr_a[1]), .D2_1(in_idat_a[2]), .D2_0(
        out_sfr_a[2]), .D3_1(in_idat_a[3]), .D3_0(out_sfr_a[3]), .D4_1(
        in_idat_a[4]), .D4_0(out_sfr_a[4]), .D5_1(in_idat_a[5]), .D5_0(
        out_sfr_a[5]), .D6_1(in_idat_a[6]), .D6_0(out_sfr_a[6]), .D7_1(n556), 
        .D7_0(n740), .S0(n555), .S1(addr2_a_1_), .S2(addr2_a_2_), .Z_1(N110), 
        .Z_0(N109) );
  DFFRX4 code_reg_2_ ( .D(n542), .CK(clk), .RN(n481), .Q(n1480), .QN(n602) );
  DFFRX4 code_reg_0_ ( .D(n540), .CK(clk), .RN(n481), .Q(code[0]) );
  DFFRX4 in_xrom_r_reg_7_ ( .D(n523), .CK(clk), .RN(n481), .Q(in_xrom_r[7]), 
        .QN(n558) );
  DFFRX4 in_xrom_r_reg_6_ ( .D(n522), .CK(clk), .RN(n481), .Q(in_xrom_r[6]), 
        .QN(n578) );
  DFFRX4 in_xrom_r_reg_5_ ( .D(n521), .CK(clk), .RN(n481), .Q(in_xrom_r[5]), 
        .QN(n575) );
  DFFRX4 in_xrom_r_reg_4_ ( .D(n520), .CK(clk), .RN(n481), .Q(in_xrom_r[4]), 
        .QN(n576) );
  DFFRX4 in_xrom_r_reg_3_ ( .D(n519), .CK(clk), .RN(n481), .Q(in_xrom_r[3]), 
        .QN(n577) );
  DFFRX4 in_xrom_r_reg_2_ ( .D(n518), .CK(clk), .RN(n481), .Q(in_xrom_r[2]), 
        .QN(n571) );
  DFFRX4 in_xrom_r_reg_1_ ( .D(n517), .CK(clk), .RN(n481), .Q(in_xrom_r[1]), 
        .QN(n572) );
  DFFRX4 in_xrom_r_reg_0_ ( .D(n516), .CK(clk), .RN(n481), .Q(in_xrom_r[0]) );
  DFFRX4 in_xrom1_r_reg_6_ ( .D(n514), .CK(clk), .RN(n481), .Q(in_xrom1_r[6]), 
        .QN(n765) );
  DFFRX4 in_xrom1_r_reg_4_ ( .D(n512), .CK(clk), .RN(n481), .Q(in_xrom1_r[4]), 
        .QN(n767) );
  DFFRX4 in_xrom1_r_reg_0_ ( .D(n508), .CK(clk), .RN(n481), .Q(in_xrom1_r[0]), 
        .QN(n771) );
  DFFRX4 in_idat_r_reg_7_ ( .D(n507), .CK(clk), .RN(n481), .Q(in_idat_r[7]), 
        .QN(n569) );
  DFFRX4 in_idat_r_reg_6_ ( .D(n506), .CK(clk), .RN(n481), .Q(in_idat_r[6]), 
        .QN(n570) );
  DFFRX4 in_idat_r_reg_5_ ( .D(n505), .CK(clk), .RN(n481), .Q(in_idat_r[5]), 
        .QN(n574) );
  DFFRX4 in_idat_r_reg_4_ ( .D(n504), .CK(clk), .RN(n481), .Q(in_idat_r[4]), 
        .QN(n573) );
  DFFRX4 in_idat_r_reg_3_ ( .D(n503), .CK(clk), .RN(n481), .Q(in_idat_r[3]), 
        .QN(n560) );
  DFFRX4 in_idat_r_reg_2_ ( .D(n502), .CK(clk), .RN(n481), .Q(in_idat_r[2]), 
        .QN(n559) );
  DFFRX4 in_idat_r_reg_1_ ( .D(n501), .CK(clk), .RN(n481), .Q(in_idat_r[1]), 
        .QN(n683) );
  DFFRX4 in_idat_r_reg_0_ ( .D(n500), .CK(clk), .RN(n481), .Q(in_idat_r[0]), 
        .QN(n580) );
  DFFRX4 out_sfr_r_reg_1_ ( .D(n493), .CK(clk), .RN(n481), .Q(out_sfr_r[1]), 
        .QN(n682) );
  DFFRX4 addr2_r_reg_6_ ( .D(n491), .CK(clk), .RN(n481), .QN(n772) );
endmodule


module u_datapath_MUX_OP_8_3_2 ( D0_1, D0_0, D1_1, D1_0, D2_1, D2_0, D3_1, 
        D3_0, D4_1, D4_0, D5_1, D5_0, D6_1, D6_0, D7_1, D7_0, S0, S1, S2, Z_1, 
        Z_0 );
  input D0_1, D0_0, D1_1, D1_0, D2_1, D2_0, D3_1, D3_0, D4_1, D4_0, D5_1, D5_0,
         D6_1, D6_0, D7_1, D7_0, S0, S1, S2;
  output Z_1, Z_0;
  wire   n1, n2, n3, n4;

  CLKMX2X3 U7 ( .S0(S2), .B(n2), .A(n1), .Y(Z_0) );
  CLKMX2X3 U8 ( .S0(S2), .B(n4), .A(n3), .Y(Z_1) );
  MX4X1 U2 ( .S1(S1), .S0(S0), .D(D3_0), .C(D2_0), .B(D1_0), .A(D0_0), .Y(n1)
         );
  MX4X1 U3 ( .S1(S1), .S0(S0), .D(D7_0), .C(D6_0), .B(D5_0), .A(D4_0), .Y(n2)
         );
  MX4X1 U5 ( .S1(S1), .S0(S0), .D(D3_1), .C(D2_1), .B(D1_1), .A(D0_1), .Y(n3)
         );
  MX4X1 U6 ( .S1(S1), .S0(S0), .D(D7_1), .C(D6_1), .B(D5_1), .A(D4_1), .Y(n4)
         );
endmodule


module u_datapath_DW01_add_16_1 ( A, B, CI, SUM, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  input CI;
  output CO;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15;

  AND2X2 U4 ( .A(B[0]), .B(A[0]), .Y(n1) );
  CLKINVX1 U5 ( .A(n2), .Y(carry_15_) );
  CLKINVX1 U6 ( .A(n13), .Y(carry_4_) );
  CLKINVX1 U7 ( .A(n12), .Y(carry_5_) );
  CLKINVX1 U8 ( .A(n14), .Y(carry_3_) );
  CLKINVX1 U9 ( .A(n11), .Y(carry_6_) );
  CLKINVX1 U10 ( .A(n10), .Y(carry_7_) );
  CLKINVX1 U11 ( .A(n6), .Y(carry_11_) );
  CLKINVX1 U12 ( .A(n5), .Y(carry_12_) );
  CLKINVX1 U13 ( .A(n4), .Y(carry_13_) );
  CLKINVX1 U14 ( .A(n3), .Y(carry_14_) );
  CLKINVX1 U15 ( .A(n9), .Y(carry_8_) );
  CLKINVX1 U16 ( .A(n8), .Y(carry_9_) );
  CLKINVX1 U17 ( .A(n7), .Y(carry_10_) );
  CLKINVX1 U18 ( .A(n15), .Y(carry_2_) );
  XOR3X1 U1_15 ( .A(A[15]), .B(B[15]), .C(carry_15_), .Y(SUM[15]) );
  XOR2X1 U19 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
  AFHCONX2 U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .S(SUM[1]), .CON(n15) );
  AFHCONX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .S(SUM[2]), .CON(n14) );
  AFHCONX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .S(SUM[3]), .CON(n13) );
  AFHCONX2 U1_4 ( .A(A[4]), .B(B[4]), .CI(carry_4_), .S(SUM[4]), .CON(n12) );
  AFHCONX2 U1_5 ( .A(A[5]), .B(B[5]), .CI(carry_5_), .S(SUM[5]), .CON(n11) );
  AFHCONX2 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry_6_), .S(SUM[6]), .CON(n10) );
  AFHCONX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry_7_), .S(SUM[7]), .CON(n9) );
  AFHCONX2 U1_8 ( .A(A[8]), .B(B[8]), .CI(carry_8_), .S(SUM[8]), .CON(n8) );
  AFHCONX2 U1_9 ( .A(A[9]), .B(B[9]), .CI(carry_9_), .S(SUM[9]), .CON(n7) );
  AFHCONX2 U1_10 ( .A(A[10]), .B(B[10]), .CI(carry_10_), .S(SUM[10]), .CON(n6)
         );
  AFHCONX2 U1_11 ( .A(A[11]), .B(B[11]), .CI(carry_11_), .S(SUM[11]), .CON(n5)
         );
  AFHCONX2 U1_12 ( .A(A[12]), .B(B[12]), .CI(carry_12_), .S(SUM[12]), .CON(n4)
         );
  AFHCONX2 U1_13 ( .A(A[13]), .B(B[13]), .CI(carry_13_), .S(SUM[13]), .CON(n3)
         );
  AFHCONX2 U1_14 ( .A(A[14]), .B(B[14]), .CI(carry_14_), .S(SUM[14]), .CON(n2)
         );
endmodule


module u_datapath_DW01_inc_16_0 ( A, SUM );
  input [15:0] A;
  output [15:0] SUM;
  wire   carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, carry_9_,
         carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14;

  XNOR2X1 U5 ( .A(n1), .B(A[15]), .Y(SUM[15]) );
  CLKINVX1 U6 ( .A(n14), .Y(carry_2_) );
  CLKINVX1 U7 ( .A(n13), .Y(carry_3_) );
  CLKINVX1 U8 ( .A(n12), .Y(carry_4_) );
  CLKINVX1 U9 ( .A(n11), .Y(carry_5_) );
  CLKINVX1 U10 ( .A(n10), .Y(carry_6_) );
  CLKINVX1 U11 ( .A(n9), .Y(carry_7_) );
  CLKINVX1 U12 ( .A(n8), .Y(carry_8_) );
  CLKINVX1 U13 ( .A(n7), .Y(carry_9_) );
  CLKINVX1 U14 ( .A(n4), .Y(carry_12_) );
  CLKINVX1 U15 ( .A(n3), .Y(carry_13_) );
  CLKINVX1 U16 ( .A(n2), .Y(carry_14_) );
  CLKINVX1 U17 ( .A(n6), .Y(carry_10_) );
  CLKINVX1 U18 ( .A(n5), .Y(carry_11_) );
  CLKINVX1 U19 ( .A(A[0]), .Y(SUM[0]) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n14) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n13) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n12) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n11) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n10) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n9) );
  AHHCONX2 U1_1_7 ( .A(A[7]), .CI(carry_7_), .S(SUM[7]), .CON(n8) );
  AHHCONX2 U1_1_8 ( .A(A[8]), .CI(carry_8_), .S(SUM[8]), .CON(n7) );
  AHHCONX2 U1_1_9 ( .A(A[9]), .CI(carry_9_), .S(SUM[9]), .CON(n6) );
  AHHCONX2 U1_1_10 ( .A(A[10]), .CI(carry_10_), .S(SUM[10]), .CON(n5) );
  AHHCONX2 U1_1_11 ( .A(A[11]), .CI(carry_11_), .S(SUM[11]), .CON(n4) );
  AHHCONX2 U1_1_12 ( .A(A[12]), .CI(carry_12_), .S(SUM[12]), .CON(n3) );
  AHHCONX2 U1_1_13 ( .A(A[13]), .CI(carry_13_), .S(SUM[13]), .CON(n2) );
  AHHCONX2 U1_1_14 ( .A(A[14]), .CI(carry_14_), .S(SUM[14]), .CON(n1) );
endmodule


module u_datapath_DW01_add_16_2 ( A, B, CI, SUM, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14;

  AND2X2 U4 ( .A(A[2]), .B(A[1]), .Y(n1) );
  AND2X2 U5 ( .A(A[9]), .B(n12), .Y(n2) );
  AND2X2 U6 ( .A(A[10]), .B(n2), .Y(n3) );
  AND2X2 U7 ( .A(A[11]), .B(n3), .Y(n4) );
  AND2X2 U8 ( .A(A[12]), .B(n4), .Y(n5) );
  AND2X2 U9 ( .A(A[13]), .B(n5), .Y(n6) );
  AND2X2 U10 ( .A(A[3]), .B(n1), .Y(n7) );
  AND2X2 U11 ( .A(A[4]), .B(n7), .Y(n8) );
  AND2X2 U12 ( .A(A[5]), .B(n8), .Y(n9) );
  AND2X2 U13 ( .A(A[6]), .B(n9), .Y(n10) );
  AND2X2 U14 ( .A(A[7]), .B(n10), .Y(n11) );
  AND2X2 U15 ( .A(A[8]), .B(n11), .Y(n12) );
  AND2X2 U16 ( .A(A[14]), .B(n6), .Y(n13) );
  CLKINVX1 U17 ( .A(n14), .Y(SUM[0]) );
  CLKINVX1 U18 ( .A(A[0]), .Y(n14) );
  XOR2X1 U19 ( .A(A[15]), .B(n13), .Y(SUM[15]) );
  XOR2X1 U20 ( .A(A[14]), .B(n6), .Y(SUM[14]) );
  XOR2X1 U21 ( .A(A[13]), .B(n5), .Y(SUM[13]) );
  XOR2X1 U22 ( .A(A[12]), .B(n4), .Y(SUM[12]) );
  XOR2X1 U23 ( .A(A[11]), .B(n3), .Y(SUM[11]) );
  XOR2X1 U24 ( .A(A[10]), .B(n2), .Y(SUM[10]) );
  XOR2X1 U25 ( .A(A[9]), .B(n12), .Y(SUM[9]) );
  XOR2X1 U26 ( .A(A[8]), .B(n11), .Y(SUM[8]) );
  XOR2X1 U27 ( .A(A[7]), .B(n10), .Y(SUM[7]) );
  XOR2X1 U28 ( .A(A[6]), .B(n9), .Y(SUM[6]) );
  XOR2X1 U29 ( .A(A[5]), .B(n8), .Y(SUM[5]) );
  XOR2X1 U30 ( .A(A[4]), .B(n7), .Y(SUM[4]) );
  XOR2X1 U31 ( .A(A[3]), .B(n1), .Y(SUM[3]) );
  XOR2X1 U32 ( .A(A[2]), .B(A[1]), .Y(SUM[2]) );
  CLKINVX1 U33 ( .A(A[1]), .Y(SUM[1]) );
endmodule


module u_datapath_DW01_add_16_3 ( A, B, CI, SUM, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  input CI;
  output CO;
  wire   carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15;

  CLKINVX1 U4 ( .A(n9), .Y(carry_8_) );
  CLKINVX1 U5 ( .A(n15), .Y(carry_2_) );
  CLKINVX1 U6 ( .A(n14), .Y(carry_3_) );
  CLKINVX1 U7 ( .A(n13), .Y(carry_4_) );
  CLKINVX1 U8 ( .A(n12), .Y(carry_5_) );
  CLKINVX1 U9 ( .A(n11), .Y(carry_6_) );
  CLKINVX1 U10 ( .A(n10), .Y(carry_7_) );
  AND2X1 U11 ( .A(B[0]), .B(A[0]), .Y(n1) );
  AND2X2 U12 ( .A(B[8]), .B(carry_8_), .Y(n2) );
  AND2X2 U13 ( .A(B[9]), .B(n2), .Y(n3) );
  AND2X2 U14 ( .A(B[10]), .B(n3), .Y(n4) );
  AND2X2 U15 ( .A(B[11]), .B(n4), .Y(n5) );
  AND2X2 U16 ( .A(B[12]), .B(n5), .Y(n6) );
  AND2X2 U17 ( .A(B[13]), .B(n6), .Y(n7) );
  AND2X2 U18 ( .A(B[14]), .B(n7), .Y(n8) );
  XOR2X1 U19 ( .A(B[15]), .B(n8), .Y(SUM[15]) );
  XOR2X1 U20 ( .A(B[14]), .B(n7), .Y(SUM[14]) );
  XOR2X1 U21 ( .A(B[13]), .B(n6), .Y(SUM[13]) );
  XOR2X1 U22 ( .A(B[12]), .B(n5), .Y(SUM[12]) );
  XOR2X1 U23 ( .A(B[11]), .B(n4), .Y(SUM[11]) );
  XOR2X1 U24 ( .A(B[10]), .B(n3), .Y(SUM[10]) );
  XOR2X1 U25 ( .A(B[9]), .B(n2), .Y(SUM[9]) );
  XOR2X1 U26 ( .A(B[8]), .B(carry_8_), .Y(SUM[8]) );
  XOR2X1 U27 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
  AFHCONX2 U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .S(SUM[1]), .CON(n15) );
  AFHCONX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .S(SUM[2]), .CON(n14) );
  AFHCONX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .S(SUM[3]), .CON(n13) );
  AFHCONX2 U1_4 ( .A(A[4]), .B(B[4]), .CI(carry_4_), .S(SUM[4]), .CON(n12) );
  AFHCONX2 U1_5 ( .A(A[5]), .B(B[5]), .CI(carry_5_), .S(SUM[5]), .CON(n11) );
  AFHCONX2 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry_6_), .S(SUM[6]), .CON(n10) );
  AFHCONX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry_7_), .S(SUM[7]), .CON(n9) );
endmodule


module u_datapath_DW01_add_16_4 ( A, B, CI, SUM, CO );
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
         n137, n138, n139, n140, n141, n142, n143, n144;

  INVX1 U5 ( .A(B[0]), .Y(n110) );
  XNOR2X1 U6 ( .A(n96), .B(n97), .Y(SUM[4]) );
  XNOR2X1 U7 ( .A(n50), .B(n87), .Y(SUM[6]) );
  NOR2X1 U8 ( .A(n143), .B(n144), .Y(SUM[0]) );
  XNOR2X1 U9 ( .A(n89), .B(n90), .Y(SUM[5]) );
  CLKINVX2 U10 ( .A(n114), .Y(n117) );
  NAND2BX2 U11 ( .AN(n117), .B(n115), .Y(n116) );
  NAND2X1 U12 ( .A(B[2]), .B(A[2]), .Y(n81) );
  NOR2X4 U13 ( .A(B[6]), .B(A[6]), .Y(n58) );
  CLKINVX1 U14 ( .A(n99), .Y(n98) );
  OR2X1 U15 ( .A(A[1]), .B(B[1]), .Y(n55) );
  AND2X1 U16 ( .A(n56), .B(A[1]), .Y(n106) );
  OR2X1 U17 ( .A(A[2]), .B(B[2]), .Y(n56) );
  NAND3X1 U18 ( .A(n93), .B(n81), .C(n94), .Y(n91) );
  NOR2X1 U19 ( .A(n53), .B(n57), .Y(n90) );
  AOI2BB2X1 U20 ( .A0N(n77), .A1N(n92), .B0(n84), .B1(n91), .Y(n89) );
  NOR2X1 U21 ( .A(n77), .B(n98), .Y(n97) );
  NAND2X1 U22 ( .A(n141), .B(n101), .Y(n95) );
  NOR2X1 U23 ( .A(n88), .B(n58), .Y(n87) );
  OAI21X1 U24 ( .A0(n114), .A1(n115), .B0(n116), .Y(SUM[2]) );
  OAI21X1 U25 ( .A0(n111), .A1(n112), .B0(n113), .Y(SUM[3]) );
  NAND2X1 U26 ( .A(n101), .B(n103), .Y(n111) );
  CLKINVX1 U27 ( .A(n76), .Y(n88) );
  NAND2X1 U28 ( .A(n99), .B(n103), .Y(n73) );
  NOR2X2 U29 ( .A(B[5]), .B(A[5]), .Y(n53) );
  OR2X1 U30 ( .A(B[2]), .B(A[2]), .Y(n121) );
  NAND3X1 U31 ( .A(B[1]), .B(A[1]), .C(n121), .Y(n94) );
  NAND3X1 U32 ( .A(n104), .B(n81), .C(n105), .Y(n100) );
  NOR2X1 U33 ( .A(n82), .B(n83), .Y(n78) );
  CLKINVX1 U34 ( .A(A[0]), .Y(n109) );
  NAND2X1 U35 ( .A(n80), .B(n81), .Y(n79) );
  OR2X2 U36 ( .A(B[3]), .B(A[3]), .Y(n101) );
  OR2X2 U37 ( .A(B[4]), .B(A[4]), .Y(n141) );
  CLKAND2X2 U38 ( .A(n54), .B(n55), .Y(n108) );
  OAI21X1 U39 ( .A0(n143), .A1(n122), .B0(n123), .Y(SUM[1]) );
  CLKINVX3 U40 ( .A(n124), .Y(n143) );
  NAND2X1 U41 ( .A(B[3]), .B(A[3]), .Y(n103) );
  NAND2X1 U42 ( .A(B[0]), .B(A[0]), .Y(n124) );
  NAND2X1 U43 ( .A(B[7]), .B(A[7]), .Y(n68) );
  NAND2X1 U44 ( .A(B[4]), .B(A[4]), .Y(n99) );
  NAND2X1 U45 ( .A(n137), .B(n138), .Y(n93) );
  NOR2X1 U46 ( .A(n109), .B(n110), .Y(n137) );
  NOR2X1 U47 ( .A(n139), .B(n140), .Y(n138) );
  NAND2X1 U48 ( .A(B[6]), .B(A[6]), .Y(n76) );
  XNOR2X1 U49 ( .A(n49), .B(B[9]), .Y(SUM[9]) );
  OR2X2 U50 ( .A(n62), .B(n63), .Y(n49) );
  CLKINVX1 U51 ( .A(n95), .Y(n84) );
  CLKINVX1 U52 ( .A(n73), .Y(n92) );
  AOI21X1 U53 ( .A0(n100), .A1(n101), .B0(n102), .Y(n96) );
  NAND2X1 U54 ( .A(n111), .B(n112), .Y(n113) );
  NAND3X1 U55 ( .A(n94), .B(n81), .C(n93), .Y(n112) );
  XNOR2X1 U56 ( .A(n65), .B(n66), .Y(SUM[7]) );
  NAND2X1 U57 ( .A(n67), .B(n68), .Y(n66) );
  OAI21X1 U58 ( .A0(n69), .A1(n70), .B0(n71), .Y(n65) );
  NOR2X1 U59 ( .A(n78), .B(n79), .Y(n70) );
  NAND2X1 U60 ( .A(n81), .B(n121), .Y(n114) );
  INVX3 U61 ( .A(n141), .Y(n77) );
  NAND3X1 U62 ( .A(n93), .B(n81), .C(n94), .Y(n136) );
  NOR2X1 U63 ( .A(n53), .B(n77), .Y(n142) );
  NOR2X1 U64 ( .A(n53), .B(n95), .Y(n135) );
  NOR2X1 U65 ( .A(n51), .B(n52), .Y(n50) );
  AO21X1 U66 ( .A0(n142), .A1(n73), .B0(n57), .Y(n51) );
  AND2X2 U67 ( .A(n135), .B(n136), .Y(n52) );
  CLKINVX1 U68 ( .A(n103), .Y(n102) );
  OAI21X1 U69 ( .A0(n118), .A1(n119), .B0(n120), .Y(n115) );
  XNOR2X1 U70 ( .A(n130), .B(n132), .Y(SUM[10]) );
  XNOR2X1 U71 ( .A(n127), .B(n129), .Y(SUM[12]) );
  NAND2X1 U72 ( .A(n68), .B(n133), .Y(n64) );
  OAI21X1 U73 ( .A0(n134), .A1(n88), .B0(n67), .Y(n133) );
  NOR2X1 U74 ( .A(n58), .B(n50), .Y(n134) );
  CLKINVX1 U75 ( .A(n131), .Y(n130) );
  CLKINVX1 U76 ( .A(n128), .Y(n127) );
  XOR2X1 U77 ( .A(n125), .B(n126), .Y(SUM[14]) );
  XNOR2X1 U78 ( .A(n64), .B(n63), .Y(SUM[8]) );
  NAND2BX1 U79 ( .AN(n124), .B(n122), .Y(n123) );
  OAI21X1 U80 ( .A0(A[1]), .A1(B[1]), .B0(n120), .Y(n122) );
  NOR2X1 U81 ( .A(A[0]), .B(B[0]), .Y(n144) );
  NOR2X1 U82 ( .A(A[1]), .B(B[1]), .Y(n139) );
  NAND2X1 U83 ( .A(B[1]), .B(A[1]), .Y(n120) );
  NOR2X1 U84 ( .A(A[1]), .B(B[1]), .Y(n118) );
  NOR2X1 U85 ( .A(A[2]), .B(B[2]), .Y(n140) );
  OR2X2 U86 ( .A(B[7]), .B(A[7]), .Y(n67) );
  AOI21X1 U87 ( .A0(n72), .A1(n73), .B0(n74), .Y(n71) );
  OAI21X1 U88 ( .A0(n58), .A1(n75), .B0(n76), .Y(n74) );
  NOR3X1 U89 ( .A(n77), .B(n58), .C(n53), .Y(n72) );
  NAND2X1 U90 ( .A(A[5]), .B(B[5]), .Y(n75) );
  NAND2X1 U91 ( .A(n107), .B(n108), .Y(n104) );
  NAND2X1 U92 ( .A(n106), .B(B[1]), .Y(n105) );
  NOR2X1 U93 ( .A(n109), .B(n110), .Y(n107) );
  NAND2X1 U94 ( .A(B[1]), .B(A[1]), .Y(n80) );
  NAND2X1 U95 ( .A(A[0]), .B(B[0]), .Y(n83) );
  NOR2X1 U96 ( .A(A[1]), .B(B[1]), .Y(n82) );
  OR2X1 U97 ( .A(A[2]), .B(B[2]), .Y(n54) );
  AND2X1 U98 ( .A(B[5]), .B(A[5]), .Y(n57) );
  NAND2X1 U99 ( .A(n84), .B(n85), .Y(n69) );
  NOR3X1 U100 ( .A(n86), .B(n58), .C(n53), .Y(n85) );
  NOR2X1 U101 ( .A(A[2]), .B(B[2]), .Y(n86) );
  NAND2X1 U102 ( .A(A[0]), .B(B[0]), .Y(n119) );
  XNOR2X1 U103 ( .A(n59), .B(B[15]), .Y(SUM[15]) );
  OR2X2 U104 ( .A(n125), .B(n126), .Y(n59) );
  XNOR2X1 U105 ( .A(n60), .B(B[13]), .Y(SUM[13]) );
  OR2X2 U106 ( .A(n128), .B(n129), .Y(n60) );
  NAND3X1 U107 ( .A(B[8]), .B(B[9]), .C(n64), .Y(n131) );
  NAND3X1 U108 ( .A(B[10]), .B(B[11]), .C(n130), .Y(n128) );
  NAND3X1 U109 ( .A(B[12]), .B(B[13]), .C(n127), .Y(n125) );
  XNOR2X1 U110 ( .A(n61), .B(B[11]), .Y(SUM[11]) );
  OR2X2 U111 ( .A(n131), .B(n132), .Y(n61) );
  CLKINVX1 U112 ( .A(n64), .Y(n62) );
  CLKINVX1 U113 ( .A(B[8]), .Y(n63) );
  CLKINVX1 U114 ( .A(B[10]), .Y(n132) );
  CLKINVX1 U115 ( .A(B[12]), .Y(n129) );
  CLKINVX1 U116 ( .A(B[14]), .Y(n126) );
endmodule


module u_alu ( en_div, clk, rst_p, OP_B, OP_A, SEL, IN_C, IN_AC, ALU, CY, AC, 
        OV, IN_B, acc_chd );
  input [7:0] OP_B;
  input [7:0] OP_A;
  input [4:0] SEL;
  output [7:0] ALU;
  output [7:0] IN_B;
  output [7:0] acc_chd;
  input en_div, clk, rst_p, IN_C, IN_AC;
  output CY, AC, OV;
  wire   s_CY_RRC, s_CY_RLC, ocy, s_AC_ADDC, s_CY_ADDC, s_OV_ADDC, n8, n9, n10,
         n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23;
  wire   [7:0] s_SWAP;
  wire   [7:0] s_RRC;
  wire   [7:0] s_RR;
  wire   [7:0] s_RLC;
  wire   [7:0] s_RL;
  wire   [7:0] s_INV;
  wire   [7:0] s_XOR;
  wire   [7:0] s_OR;
  wire   [7:0] s_AND;
  wire   [7:0] s_DA;
  wire   [7:0] s_Q;
  wire   [7:0] s_R;
  wire   [15:0] s_M;
  wire   [7:0] oOP_B;
  wire   [3:0] s_sel;
  wire   [7:0] s_ADDC;
  wire   [7:0] s_ram_chd;

  swap U2_swap ( .d({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .q(s_SWAP)
         );
  rrc U3_rrc ( .d({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .in_cy(IN_C), 
        .out_cy(s_CY_RRC), .q(s_RRC) );
  rr U4_rr ( .d({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .q(s_RR) );
  rlc U5_rlc ( .d({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .in_cy(IN_C), 
        .out_cy(s_CY_RLC), .q(s_RLC) );
  rl U6_rl ( .d({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .q(s_RL) );
  da U7_da ( .d({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .ac(IN_AC), .cy(
        IN_C), .q(s_DA) );
  UDIV8x8 U8_div ( .A({OP_A[7], n23, n22, n21, n20, n19, n12, OP_A[0]}), .B({
        OP_B[7:5], n11, OP_B[3:0]}), .Quotient(s_Q), .Remainder(s_R) );
  mul U9_mul ( .op1({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .op2({
        OP_B[7:5], n11, OP_B[3:0]}), .m(s_M) );
  sel_arth U10_sel_arth ( .iop2({OP_B[7:5], n11, OP_B[3:0]}), .icin(IN_C), 
        .sel(SEL[2:0]), .oop2(oOP_B), .ocin(ocy) );
  sel_al U11_sel_al ( .isel(SEL), .osel(s_sel) );
  adc U12_adc ( .dataa({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .datab(
        oOP_B), .cin(ocy), .ac(s_AC_ADDC), .cout(s_CY_ADDC), .overflow(
        s_OV_ADDC), .result(s_ADDC) );
  xchd U_xchd ( .in_acc({n9, n23, n22, n21, n20, n19, n12, OP_A[0]}), .in_ram(
        {OP_B[7:5], n11, OP_B[3:0]}), .out_acc(acc_chd), .out_ram(s_ram_chd)
         );
  mux16t1_8 U18_sel_alu ( .a0(s_ADDC), .a1(s_M[7:0]), .a2(s_Q), .a3(s_DA), 
        .a4(s_AND), .a5(s_OR), .a6(s_XOR), .a7({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0}), .a8(s_INV), .a9(s_RL), .b0(s_RLC), .b1(s_RR), .b2(
        s_RRC), .b3(s_SWAP), .b4({1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1}), .b5(s_ram_chd), .sel(s_sel), .qq(ALU) );
  alu_flag_d_m U19_alu_flag ( .al(SEL), .m(s_M[15:8]), .r(s_R), .dividor({
        OP_B[7:5], n11, OP_B[3:0]}), .cy_addc(s_CY_ADDC), .cy_rlc(s_CY_RLC), 
        .cy_rrc(s_CY_RRC), .ac_addc(s_AC_ADDC), .ov_addc(s_OV_ADDC), .cy(CY), 
        .ac(AC), .ov(OV), .IN_B(IN_B) );
  CLKINVX8 U43 ( .A(n10), .Y(n11) );
  INVX4 U44 ( .A(OP_B[4]), .Y(n10) );
  BUFX12 U45 ( .A(OP_A[3]), .Y(n20) );
  CLKBUFX2 U46 ( .A(OP_A[7]), .Y(n9) );
  BUFX12 U47 ( .A(OP_A[5]), .Y(n22) );
  BUFX12 U48 ( .A(OP_A[6]), .Y(n23) );
  BUFX8 U49 ( .A(OP_A[4]), .Y(n21) );
  BUFX12 U50 ( .A(OP_A[2]), .Y(n19) );
  CLKINVX1 U51 ( .A(OP_A[0]), .Y(s_INV[0]) );
  BUFX8 U52 ( .A(OP_A[1]), .Y(n12) );
  CLKINVX1 U53 ( .A(n9), .Y(s_INV[7]) );
  NOR2X1 U54 ( .A(s_INV[7]), .B(n13), .Y(s_AND[7]) );
  NAND2X1 U55 ( .A(n13), .B(s_INV[7]), .Y(s_OR[7]) );
  NAND2X1 U56 ( .A(n14), .B(s_INV[6]), .Y(s_OR[6]) );
  CLKINVX1 U57 ( .A(n22), .Y(s_INV[5]) );
  CLKINVX1 U58 ( .A(n23), .Y(s_INV[6]) );
  CLKINVX1 U59 ( .A(n19), .Y(s_INV[2]) );
  XNOR2X1 U60 ( .A(n19), .B(n17), .Y(s_XOR[2]) );
  XNOR2X1 U61 ( .A(n20), .B(n16), .Y(s_XOR[3]) );
  XNOR2X1 U62 ( .A(n23), .B(n14), .Y(s_XOR[6]) );
  XNOR2X1 U63 ( .A(n22), .B(n15), .Y(s_XOR[5]) );
  NOR2X1 U64 ( .A(s_INV[6]), .B(n14), .Y(s_AND[6]) );
  NOR2X1 U65 ( .A(s_INV[0]), .B(n8), .Y(s_AND[0]) );
  NAND2X1 U66 ( .A(n8), .B(s_INV[0]), .Y(s_OR[0]) );
  NAND2X1 U67 ( .A(n15), .B(s_INV[5]), .Y(s_OR[5]) );
  NOR2X1 U68 ( .A(s_INV[5]), .B(n15), .Y(s_AND[5]) );
  CLKINVX1 U69 ( .A(n20), .Y(s_INV[3]) );
  CLKINVX1 U70 ( .A(n21), .Y(s_INV[4]) );
  XNOR2X1 U71 ( .A(n21), .B(n10), .Y(s_XOR[4]) );
  NOR2X1 U72 ( .A(s_INV[4]), .B(n10), .Y(s_AND[4]) );
  NAND2X1 U73 ( .A(n16), .B(s_INV[3]), .Y(s_OR[3]) );
  NAND2X1 U74 ( .A(n17), .B(s_INV[2]), .Y(s_OR[2]) );
  NAND2X1 U75 ( .A(n10), .B(s_INV[4]), .Y(s_OR[4]) );
  NOR2X1 U76 ( .A(s_INV[2]), .B(n17), .Y(s_AND[2]) );
  NOR2X1 U77 ( .A(s_INV[3]), .B(n16), .Y(s_AND[3]) );
  CLKINVX1 U78 ( .A(OP_B[6]), .Y(n14) );
  CLKINVX1 U79 ( .A(OP_B[1]), .Y(n18) );
  CLKINVX1 U80 ( .A(OP_B[0]), .Y(n8) );
  CLKINVX1 U81 ( .A(OP_B[5]), .Y(n15) );
  NOR2X1 U82 ( .A(s_INV[1]), .B(n18), .Y(s_AND[1]) );
  NAND2X1 U83 ( .A(n18), .B(s_INV[1]), .Y(s_OR[1]) );
  CLKINVX1 U84 ( .A(OP_B[7]), .Y(n13) );
  CLKINVX1 U85 ( .A(OP_B[3]), .Y(n16) );
  CLKINVX1 U86 ( .A(OP_B[2]), .Y(n17) );
  XNOR2X1 U87 ( .A(n12), .B(n18), .Y(s_XOR[1]) );
  CLKINVX1 U88 ( .A(n12), .Y(s_INV[1]) );
  XNOR2X1 U89 ( .A(OP_A[0]), .B(n8), .Y(s_XOR[0]) );
  XNOR2X1 U90 ( .A(n9), .B(n13), .Y(s_XOR[7]) );
endmodule


module alu_flag_d_m ( al, m, r, dividor, cy_addc, cy_rlc, cy_rrc, ac_addc, 
        ov_addc, cy, ac, ov, IN_B );
  input [4:0] al;
  input [7:0] m;
  input [7:0] r;
  input [7:0] dividor;
  output [7:0] IN_B;
  input cy_addc, cy_rlc, cy_rrc, ac_addc, ov_addc;
  output cy, ac, ov;
  wire   n3, n4, n5, n6, n7, n9, n10, n11, n12, n13, n14, n15, n16, n17, n20,
         n22, n23, n28, n31, n32, n37, n38, n39, n40, n41, n42, n43, n44, n45,
         n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59,
         n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73,
         n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87,
         n88, n89;

  CLKINVX1 U48 ( .A(r[0]), .Y(n87) );
  CLKINVX1 U49 ( .A(m[7]), .Y(n12) );
  INVX1 U50 ( .A(n71), .Y(n73) );
  INVX1 U51 ( .A(n74), .Y(n76) );
  INVX1 U52 ( .A(n68), .Y(n70) );
  INVX1 U53 ( .A(n65), .Y(n67) );
  INVX1 U54 ( .A(n77), .Y(n79) );
  INVX1 U55 ( .A(n80), .Y(n82) );
  INVX1 U56 ( .A(n83), .Y(n85) );
  NAND2X1 U57 ( .A(n39), .B(n5), .Y(ov) );
  OAI21X1 U58 ( .A0(n44), .A1(n43), .B0(n37), .Y(n5) );
  NAND2X1 U59 ( .A(n37), .B(m[1]), .Y(n83) );
  NAND2X1 U60 ( .A(n37), .B(m[2]), .Y(n80) );
  AOI2BB2X1 U61 ( .A0N(n88), .A1N(n40), .B0(n86), .B1(n87), .Y(IN_B[0]) );
  INVX1 U62 ( .A(n86), .Y(n88) );
  NAND2X1 U63 ( .A(n37), .B(m[0]), .Y(n86) );
  CLKINVX1 U64 ( .A(r[1]), .Y(n84) );
  MXI2X1 U65 ( .S0(al[3]), .B(n58), .A(n57), .Y(cy) );
  NAND3BX1 U66 ( .AN(dividor[1]), .B(n52), .C(n53), .Y(n22) );
  NOR3X1 U67 ( .A(n60), .B(al[3]), .C(n54), .Y(n40) );
  AND4X1 U68 ( .A(al[2]), .B(al[0]), .C(n89), .D(n56), .Y(n37) );
  NAND4X1 U69 ( .A(n9), .B(n10), .C(n11), .D(n12), .Y(n43) );
  CLKINVX1 U70 ( .A(m[4]), .Y(n9) );
  CLKINVX1 U71 ( .A(m[5]), .Y(n10) );
  CLKINVX1 U72 ( .A(m[6]), .Y(n11) );
  CLKINVX1 U73 ( .A(r[5]), .Y(n72) );
  CLKINVX1 U74 ( .A(r[6]), .Y(n69) );
  CLKINVX1 U75 ( .A(m[3]), .Y(n16) );
  CLKINVX1 U76 ( .A(r[4]), .Y(n75) );
  CLKINVX1 U77 ( .A(r[7]), .Y(n66) );
  CLKINVX1 U78 ( .A(r[3]), .Y(n78) );
  NAND2X1 U79 ( .A(cy_addc), .B(n55), .Y(n63) );
  AOI2BB2X1 U80 ( .A0N(n85), .A1N(n40), .B0(n83), .B1(n84), .Y(IN_B[1]) );
  CLKINVX1 U81 ( .A(r[2]), .Y(n81) );
  AOI21X1 U82 ( .A0(n40), .A1(n41), .B0(n42), .Y(n39) );
  CLKINVX1 U83 ( .A(n3), .Y(n41) );
  NAND2X1 U84 ( .A(n37), .B(m[7]), .Y(n65) );
  NAND2X1 U85 ( .A(n37), .B(m[5]), .Y(n71) );
  NAND2X1 U86 ( .A(n37), .B(m[4]), .Y(n74) );
  NAND2X1 U87 ( .A(n37), .B(m[6]), .Y(n68) );
  NAND2X1 U88 ( .A(n37), .B(m[3]), .Y(n77) );
  INVX1 U89 ( .A(n4), .Y(n42) );
  NAND2X1 U90 ( .A(n45), .B(ov_addc), .Y(n4) );
  NOR2X1 U91 ( .A(n20), .B(n38), .Y(n45) );
  NAND3X1 U92 ( .A(n64), .B(n55), .C(al[1]), .Y(n60) );
  CLKINVX1 U93 ( .A(al[4]), .Y(n55) );
  NAND3X1 U94 ( .A(n54), .B(n55), .C(n56), .Y(n20) );
  CLKINVX1 U95 ( .A(al[2]), .Y(n54) );
  AOI2BB2X1 U96 ( .A0N(n67), .A1N(n40), .B0(n65), .B1(n66), .Y(IN_B[7]) );
  AOI2BB2X1 U97 ( .A0N(n70), .A1N(n40), .B0(n68), .B1(n69), .Y(IN_B[6]) );
  AOI2BB2X1 U98 ( .A0N(n73), .A1N(n40), .B0(n71), .B1(n72), .Y(IN_B[5]) );
  AOI2BB2X1 U99 ( .A0N(n82), .A1N(n40), .B0(n80), .B1(n81), .Y(IN_B[2]) );
  AOI2BB2X1 U100 ( .A0N(n79), .A1N(n40), .B0(n77), .B1(n78), .Y(IN_B[3]) );
  NAND4X2 U101 ( .A(n13), .B(n14), .C(n15), .D(n16), .Y(n44) );
  INVX1 U102 ( .A(m[0]), .Y(n13) );
  CLKINVX3 U103 ( .A(m[1]), .Y(n14) );
  CLKINVX3 U104 ( .A(m[2]), .Y(n15) );
  NAND3X1 U105 ( .A(n59), .B(al[2]), .C(cy_rlc), .Y(n58) );
  NAND2BX1 U106 ( .AN(al[2]), .B(n51), .Y(n57) );
  CLKINVX1 U107 ( .A(n60), .Y(n59) );
  OAI21X1 U108 ( .A0(cy_addc), .A1(n60), .B0(n28), .Y(n51) );
  NAND2BX1 U109 ( .AN(al[1]), .B(n61), .Y(n28) );
  OAI21X1 U110 ( .A0(n62), .A1(n55), .B0(n63), .Y(n61) );
  NAND2X1 U111 ( .A(cy_rrc), .B(n64), .Y(n62) );
  OAI33X1 U112 ( .A0(n20), .A1(al[1]), .A2(n31), .B0(n20), .B1(n17), .B2(n32), 
        .Y(ac) );
  CLKINVX1 U113 ( .A(al[1]), .Y(n17) );
  NAND2BX1 U114 ( .AN(al[0]), .B(n31), .Y(n32) );
  CLKINVX1 U115 ( .A(ac_addc), .Y(n31) );
  CLKINVX1 U116 ( .A(dividor[0]), .Y(n52) );
  CLKINVX1 U117 ( .A(dividor[2]), .Y(n53) );
  NAND2X1 U118 ( .A(n46), .B(n47), .Y(n3) );
  NOR3X1 U119 ( .A(dividor[7]), .B(dividor[5]), .C(dividor[6]), .Y(n47) );
  NOR2X1 U120 ( .A(n22), .B(n48), .Y(n46) );
  NAND2X1 U121 ( .A(n49), .B(n50), .Y(n48) );
  CLKINVX1 U122 ( .A(dividor[3]), .Y(n49) );
  CLKINVX1 U123 ( .A(dividor[4]), .Y(n50) );
  NOR2X1 U124 ( .A(al[4]), .B(al[1]), .Y(n89) );
  CLKINVX1 U125 ( .A(al[0]), .Y(n64) );
  CLKINVX1 U126 ( .A(al[3]), .Y(n56) );
  AND2X1 U127 ( .A(al[0]), .B(al[1]), .Y(n38) );
  AOI2BB2X1 U128 ( .A0N(n76), .A1N(n40), .B0(n74), .B1(n75), .Y(IN_B[4]) );
  INVX8 U129 ( .A(n43), .Y(n7) );
  INVX8 U130 ( .A(n44), .Y(n6) );
  INVX8 U131 ( .A(n51), .Y(n23) );
endmodule


module mux16t1_8 ( a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b3, b4, 
        b5, sel, qq );
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
  wire   n2, n4, n7, n15, n24, n29, n30, n38, n39, n45, n47, n48, n51, n56,
         n57, n65, n66, n72, n74, n75, n77, n80, n81, n82, n83, n84, n93, n103,
         n104, n105, n125, n126, n127, n128, n129, n130, n131, n132, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n160, n161, n162, n163, n164, n165, n166,
         n167, n168, n169, n170, n171, n172, n173, n174, n175, n176, n177,
         n178, n179, n180, n181, n182, n183, n184, n185, n186, n187, n188,
         n189, n190, n191, n192, n193, n194, n195, n196, n197, n198, n199,
         n200, n201, n202, n203, n204, n205, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n239, n240, n241, n242, n243,
         n244, n245, n246, n247, n248, n249, n250, n251, n252, n253, n254,
         n255, n256, n257, n258, n259, n260, n261, n262, n263, n264, n265,
         n266, n267, n268, n269, n270, n271, n272, n273, n274, n275, n276,
         n277, n278, n279, n280, n281, n282, n283, n284, n285, n286, n287,
         n288, n289, n290, n291, n292, n293, n294, n295, n296, n297, n298,
         n299, n300, n301, n302, n303, n304, n305, n306, n307, n308, n309,
         n310, n311, n312, n313, n314, n315, n316, n317, n318, n319, n320,
         n321, n322, n323, n324, n325, n326, n327, n328, n329, n330, n331,
         n332, n333, n334, n335, n336, n337, n338, n339, n340, n341, n342,
         n343, n344, n345, n346, n347, n348, n349, n350, n351, n352, n353,
         n354, n355, n356, n357, n358, n359, n360, n361, n362, n363, n364,
         n365, n366, n367, n368, n369, n370, n371, n372, n373, n374, n375,
         n376, n377, n378;

  OAI21X1 U135 ( .A0(n264), .A1(n299), .B0(n300), .Y(n66) );
  INVX1 U136 ( .A(a3[2]), .Y(n299) );
  OAI21X1 U137 ( .A0(n264), .A1(n276), .B0(n277), .Y(n75) );
  INVX1 U138 ( .A(a3[1]), .Y(n276) );
  CLKINVX1 U139 ( .A(n57), .Y(n305) );
  INVX3 U140 ( .A(n296), .Y(n65) );
  NAND2X2 U141 ( .A(n297), .B(n298), .Y(n296) );
  NAND3X1 U142 ( .A(n282), .B(n283), .C(n77), .Y(n72) );
  AOI22X1 U143 ( .A0(b5[1]), .A1(n133), .B0(b4[1]), .B1(n126), .Y(n283) );
  NOR2X1 U144 ( .A(n290), .B(n291), .Y(n282) );
  NOR2BX1 U145 ( .AN(n284), .B(n285), .Y(n77) );
  INVX1 U146 ( .A(a2[0]), .Y(n250) );
  INVX1 U147 ( .A(b0[1]), .Y(n288) );
  INVX1 U148 ( .A(a0[1]), .Y(n281) );
  NOR2X1 U149 ( .A(n220), .B(n221), .Y(n203) );
  NOR2X1 U150 ( .A(n206), .B(n207), .Y(n205) );
  NAND4X4 U151 ( .A(n224), .B(n225), .C(n226), .D(n65), .Y(qq[2]) );
  NOR2X1 U152 ( .A(n242), .B(n243), .Y(n224) );
  NOR2X1 U153 ( .A(n227), .B(n228), .Y(n226) );
  INVX1 U154 ( .A(n72), .Y(n246) );
  INVX1 U155 ( .A(n143), .Y(n247) );
  INVX1 U156 ( .A(n145), .Y(n248) );
  CLKINVX2 U157 ( .A(n303), .Y(n56) );
  AND2X2 U158 ( .A(sel[0]), .B(n373), .Y(n137) );
  CLKAND2X2 U159 ( .A(sel[1]), .B(sel[0]), .Y(n138) );
  NAND2X1 U160 ( .A(n304), .B(n305), .Y(n303) );
  AOI21X1 U161 ( .A0(a1[3]), .A1(n132), .B0(n308), .Y(n304) );
  AOI22X1 U162 ( .A0(a4[1]), .A1(n247), .B0(a5[1]), .B1(n134), .Y(n125) );
  INVX1 U163 ( .A(n262), .Y(n278) );
  NAND2X1 U164 ( .A(n127), .B(n136), .Y(n159) );
  NAND2X1 U165 ( .A(n136), .B(n128), .Y(n280) );
  INVX1 U166 ( .A(n171), .Y(n144) );
  NAND2X1 U167 ( .A(n130), .B(n136), .Y(n143) );
  NAND2X1 U168 ( .A(n130), .B(n135), .Y(n145) );
  AND2X2 U169 ( .A(sel[3]), .B(n349), .Y(n127) );
  NAND2X1 U170 ( .A(n131), .B(n136), .Y(n294) );
  NAND2X1 U171 ( .A(n135), .B(n128), .Y(n262) );
  INVX1 U172 ( .A(a8[7]), .Y(n359) );
  AND2X2 U173 ( .A(n131), .B(n138), .Y(n133) );
  NAND2X1 U174 ( .A(n128), .B(n138), .Y(n264) );
  AND2X2 U175 ( .A(sel[2]), .B(n272), .Y(n130) );
  AND2X2 U176 ( .A(n373), .B(n374), .Y(n136) );
  NAND2X1 U177 ( .A(n131), .B(n137), .Y(n292) );
  NAND2X1 U178 ( .A(n127), .B(n138), .Y(n323) );
  NAND2X1 U179 ( .A(n130), .B(n138), .Y(n171) );
  AND2X2 U180 ( .A(sel[1]), .B(n374), .Y(n135) );
  CLKINVX1 U181 ( .A(sel[2]), .Y(n349) );
  CLKINVX1 U182 ( .A(a6[2]), .Y(n244) );
  INVX1 U183 ( .A(n255), .Y(n254) );
  CLKINVX1 U184 ( .A(sel[0]), .Y(n374) );
  CLKINVX4 U185 ( .A(n66), .Y(n298) );
  INVX1 U186 ( .A(n310), .Y(n47) );
  INVX1 U187 ( .A(n48), .Y(n312) );
  NAND2X1 U188 ( .A(a1[0]), .B(n132), .Y(n256) );
  NAND2X1 U189 ( .A(a0[0]), .B(n260), .Y(n258) );
  CLKINVX1 U190 ( .A(n81), .Y(n257) );
  NOR2X2 U191 ( .A(n234), .B(n235), .Y(n225) );
  NAND4X2 U192 ( .A(n203), .B(n204), .C(n205), .D(n56), .Y(qq[3]) );
  NOR2X2 U193 ( .A(n213), .B(n214), .Y(n204) );
  NOR2X1 U194 ( .A(n280), .B(n281), .Y(n279) );
  CLKINVX1 U195 ( .A(n265), .Y(n82) );
  NAND4BX1 U196 ( .AN(n139), .B(n125), .C(n246), .D(n74), .Y(qq[1]) );
  NAND3X1 U197 ( .A(n231), .B(n232), .C(n233), .Y(n227) );
  CLKINVX1 U198 ( .A(n280), .Y(n260) );
  CLKINVX1 U199 ( .A(n241), .Y(n165) );
  INVX1 U200 ( .A(n294), .Y(n156) );
  CLKINVX1 U201 ( .A(n159), .Y(n372) );
  NOR2X1 U202 ( .A(n280), .B(n316), .Y(n315) );
  CLKINVX1 U203 ( .A(a0[4]), .Y(n316) );
  NAND2X1 U204 ( .A(n127), .B(n135), .Y(n241) );
  AND2X2 U205 ( .A(n131), .B(n135), .Y(n126) );
  INVX1 U206 ( .A(n323), .Y(n167) );
  INVX1 U207 ( .A(n292), .Y(n166) );
  CLKAND2X2 U208 ( .A(n272), .B(n349), .Y(n128) );
  CLKINVX1 U209 ( .A(sel[3]), .Y(n272) );
  OAI21X1 U210 ( .A0(n159), .A1(n359), .B0(n360), .Y(n358) );
  NAND2X1 U211 ( .A(a9[7]), .B(n129), .Y(n360) );
  NAND3X1 U212 ( .A(n162), .B(n163), .C(n164), .Y(n157) );
  NAND2X1 U213 ( .A(b3[6]), .B(n166), .Y(n163) );
  NAND2X1 U214 ( .A(b0[6]), .B(n165), .Y(n164) );
  NAND3X1 U215 ( .A(n217), .B(n218), .C(n219), .Y(n213) );
  NAND2X1 U216 ( .A(b1[3]), .B(n167), .Y(n219) );
  NAND2X1 U217 ( .A(b0[3]), .B(n165), .Y(n217) );
  OAI21X1 U218 ( .A0(n159), .A1(n160), .B0(n161), .Y(n158) );
  NAND2X1 U219 ( .A(a9[6]), .B(n129), .Y(n161) );
  CLKINVX1 U220 ( .A(a8[6]), .Y(n160) );
  OAI21X1 U221 ( .A0(n159), .A1(n185), .B0(n186), .Y(n184) );
  NAND2X1 U222 ( .A(a9[5]), .B(n129), .Y(n186) );
  CLKINVX1 U223 ( .A(a8[5]), .Y(n185) );
  NOR2X1 U224 ( .A(n280), .B(n309), .Y(n308) );
  CLKINVX1 U225 ( .A(a0[3]), .Y(n309) );
  NOR2X1 U226 ( .A(n159), .B(n325), .Y(n319) );
  CLKINVX1 U227 ( .A(a8[4]), .Y(n325) );
  OAI21X1 U228 ( .A0(n159), .A1(n215), .B0(n216), .Y(n214) );
  NAND2X1 U229 ( .A(a9[3]), .B(n129), .Y(n216) );
  CLKINVX1 U230 ( .A(a8[3]), .Y(n215) );
  AND2X2 U231 ( .A(n127), .B(n137), .Y(n129) );
  AND2X2 U232 ( .A(sel[2]), .B(sel[3]), .Y(n131) );
  AND2X1 U233 ( .A(n137), .B(n128), .Y(n132) );
  AND2X1 U234 ( .A(n130), .B(n137), .Y(n134) );
  CLKINVX1 U235 ( .A(sel[1]), .Y(n373) );
  OAI21X1 U236 ( .A0(n264), .A1(n306), .B0(n307), .Y(n57) );
  CLKINVX1 U237 ( .A(a3[3]), .Y(n306) );
  NAND2X1 U238 ( .A(a2[3]), .B(n278), .Y(n307) );
  OAI21X1 U239 ( .A0(n264), .A1(n313), .B0(n314), .Y(n48) );
  CLKINVX1 U240 ( .A(a3[4]), .Y(n313) );
  NAND2X1 U241 ( .A(a2[4]), .B(n278), .Y(n314) );
  OAI21X1 U242 ( .A0(n264), .A1(n335), .B0(n336), .Y(n7) );
  NAND2X1 U243 ( .A(a2[7]), .B(n278), .Y(n336) );
  CLKINVX1 U244 ( .A(a3[7]), .Y(n335) );
  OAI21X1 U245 ( .A0(n143), .A1(n151), .B0(n152), .Y(n150) );
  NAND2X1 U246 ( .A(a5[6]), .B(n134), .Y(n152) );
  CLKINVX1 U247 ( .A(a4[6]), .Y(n151) );
  NOR2X1 U248 ( .A(n145), .B(n244), .Y(n243) );
  NOR2X1 U249 ( .A(n145), .B(n222), .Y(n221) );
  CLKINVX1 U250 ( .A(a6[3]), .Y(n222) );
  NOR2X1 U251 ( .A(n145), .B(n170), .Y(n169) );
  CLKINVX1 U252 ( .A(a6[6]), .Y(n170) );
  NOR2X1 U253 ( .A(n145), .B(n192), .Y(n191) );
  CLKINVX1 U254 ( .A(a6[5]), .Y(n192) );
  NOR2X1 U255 ( .A(n294), .B(n295), .Y(n290) );
  CLKINVX1 U256 ( .A(b2[1]), .Y(n295) );
  NOR2X1 U257 ( .A(n143), .B(n271), .Y(n270) );
  CLKINVX1 U258 ( .A(a4[0]), .Y(n271) );
  NOR2X1 U259 ( .A(n280), .B(n302), .Y(n301) );
  CLKINVX1 U260 ( .A(a0[2]), .Y(n302) );
  OAI21X1 U261 ( .A0(n143), .A1(n178), .B0(n179), .Y(n177) );
  CLKINVX1 U262 ( .A(a4[5]), .Y(n178) );
  NAND2X1 U263 ( .A(a5[5]), .B(n134), .Y(n179) );
  NOR2X1 U264 ( .A(n292), .B(n293), .Y(n291) );
  CLKINVX1 U265 ( .A(b3[1]), .Y(n293) );
  NAND2X1 U266 ( .A(n262), .B(n255), .Y(n253) );
  NOR2X1 U267 ( .A(n145), .B(n200), .Y(n197) );
  CLKINVX1 U268 ( .A(a6[4]), .Y(n200) );
  NOR2X1 U269 ( .A(n241), .B(n322), .Y(n321) );
  CLKINVX1 U270 ( .A(b0[4]), .Y(n322) );
  NOR2X1 U271 ( .A(n323), .B(n324), .Y(n320) );
  CLKINVX1 U272 ( .A(b1[4]), .Y(n324) );
  NOR2X1 U273 ( .A(n143), .B(n202), .Y(n201) );
  CLKINVX1 U274 ( .A(a4[4]), .Y(n202) );
  NOR2X1 U275 ( .A(n292), .B(n356), .Y(n351) );
  CLKINVX1 U276 ( .A(b3[7]), .Y(n356) );
  OAI21X1 U277 ( .A0(n143), .A1(n229), .B0(n230), .Y(n228) );
  CLKINVX1 U278 ( .A(a4[2]), .Y(n229) );
  NAND2X1 U279 ( .A(a5[2]), .B(n134), .Y(n230) );
  OAI21X1 U280 ( .A0(n143), .A1(n208), .B0(n209), .Y(n207) );
  CLKINVX1 U281 ( .A(a4[3]), .Y(n208) );
  NAND2X1 U282 ( .A(a5[3]), .B(n134), .Y(n209) );
  AOI21X1 U283 ( .A0(n255), .A1(n250), .B0(n261), .Y(n84) );
  CLKINVX1 U284 ( .A(n253), .Y(n261) );
  NAND2X1 U285 ( .A(n256), .B(n258), .Y(n259) );
  AOI21X1 U286 ( .A0(n249), .A1(n250), .B0(n251), .Y(qq[0]) );
  NOR2X1 U287 ( .A(n252), .B(n253), .Y(n251) );
  NOR2X1 U288 ( .A(n252), .B(n254), .Y(n249) );
  NAND4X1 U289 ( .A(n256), .B(n257), .C(n258), .D(n82), .Y(n252) );
  CLKINVX1 U290 ( .A(n273), .Y(n74) );
  NAND2X1 U291 ( .A(n274), .B(n275), .Y(n273) );
  AOI21X1 U292 ( .A0(a1[1]), .A1(n132), .B0(n279), .Y(n274) );
  CLKINVX1 U293 ( .A(n75), .Y(n275) );
  AOI21X2 U294 ( .A0(a1[2]), .A1(n132), .B0(n301), .Y(n297) );
  CLKINVX1 U295 ( .A(n343), .Y(n29) );
  NAND3X1 U296 ( .A(n344), .B(n345), .C(n346), .Y(n343) );
  NAND2X1 U297 ( .A(a0[6]), .B(n260), .Y(n344) );
  CLKINVX1 U298 ( .A(n30), .Y(n345) );
  NAND2X1 U299 ( .A(n311), .B(n312), .Y(n310) );
  AOI21X1 U300 ( .A0(a1[4]), .A1(n132), .B0(n315), .Y(n311) );
  CLKINVX1 U301 ( .A(n337), .Y(n38) );
  NAND3X1 U302 ( .A(n338), .B(n339), .C(n340), .Y(n337) );
  NAND2X1 U303 ( .A(a0[5]), .B(n260), .Y(n338) );
  CLKINVX1 U304 ( .A(n39), .Y(n339) );
  NAND2X1 U305 ( .A(n104), .B(n103), .Y(n81) );
  CLKINVX1 U306 ( .A(n363), .Y(n104) );
  CLKINVX1 U307 ( .A(n368), .Y(n103) );
  OAI21X1 U308 ( .A0(n159), .A1(n236), .B0(n237), .Y(n235) );
  NAND2X1 U309 ( .A(a9[2]), .B(n129), .Y(n237) );
  CLKINVX1 U310 ( .A(a8[2]), .Y(n236) );
  OAI21X1 U311 ( .A0(n159), .A1(n286), .B0(n287), .Y(n285) );
  CLKINVX1 U312 ( .A(a8[1]), .Y(n286) );
  NAND2X1 U313 ( .A(a9[1]), .B(n129), .Y(n287) );
  NAND3X1 U314 ( .A(n187), .B(n188), .C(n189), .Y(n183) );
  NAND2X1 U315 ( .A(b3[5]), .B(n166), .Y(n188) );
  NAND2X1 U316 ( .A(b0[5]), .B(n165), .Y(n189) );
  NAND2X1 U317 ( .A(b1[5]), .B(n167), .Y(n187) );
  NAND3X1 U318 ( .A(n238), .B(n239), .C(n240), .Y(n234) );
  NAND2X1 U319 ( .A(b0[2]), .B(n165), .Y(n240) );
  NAND2X1 U320 ( .A(b1[2]), .B(n167), .Y(n238) );
  NAND2X1 U321 ( .A(b3[2]), .B(n166), .Y(n239) );
  CLKINVX1 U322 ( .A(n80), .Y(n284) );
  OAI21X1 U323 ( .A0(n241), .A1(n288), .B0(n289), .Y(n80) );
  NAND2X1 U324 ( .A(b1[1]), .B(n167), .Y(n289) );
  NAND2X1 U325 ( .A(a3[0]), .B(n263), .Y(n255) );
  INVX1 U326 ( .A(n264), .Y(n263) );
  NAND2X1 U327 ( .A(b3[4]), .B(n166), .Y(n329) );
  NAND2X1 U328 ( .A(b5[7]), .B(n133), .Y(n355) );
  CLKINVX1 U329 ( .A(n24), .Y(n357) );
  OAI21X1 U330 ( .A0(n241), .A1(n361), .B0(n362), .Y(n24) );
  NAND2X1 U331 ( .A(b1[7]), .B(n167), .Y(n362) );
  CLKINVX1 U332 ( .A(b0[7]), .Y(n361) );
  NAND2X1 U333 ( .A(a2[1]), .B(n278), .Y(n277) );
  NAND2X1 U334 ( .A(a2[2]), .B(n278), .Y(n300) );
  NAND4X1 U335 ( .A(n146), .B(n147), .C(n148), .D(n29), .Y(qq[6]) );
  NOR2X1 U336 ( .A(n168), .B(n169), .Y(n146) );
  NOR2X1 U337 ( .A(n157), .B(n158), .Y(n147) );
  NOR2X1 U338 ( .A(n149), .B(n150), .Y(n148) );
  NAND4X1 U339 ( .A(n194), .B(n195), .C(n196), .D(n47), .Y(qq[4]) );
  AOI21X1 U340 ( .A0(a5[4]), .A1(n134), .B0(n201), .Y(n194) );
  NOR2X1 U341 ( .A(n197), .B(n198), .Y(n196) );
  CLKINVX1 U342 ( .A(n45), .Y(n195) );
  NAND2X1 U343 ( .A(a1[6]), .B(n132), .Y(n346) );
  OAI21X1 U344 ( .A0(n264), .A1(n341), .B0(n342), .Y(n39) );
  CLKINVX1 U345 ( .A(a3[5]), .Y(n341) );
  NAND2X1 U346 ( .A(a2[5]), .B(n278), .Y(n342) );
  NAND4X1 U347 ( .A(n173), .B(n174), .C(n175), .D(n38), .Y(qq[5]) );
  NOR2X1 U348 ( .A(n183), .B(n184), .Y(n174) );
  NOR2X1 U349 ( .A(n176), .B(n177), .Y(n175) );
  NOR2X1 U350 ( .A(n190), .B(n191), .Y(n173) );
  CLKINVX1 U351 ( .A(n331), .Y(n4) );
  NAND3X1 U352 ( .A(n332), .B(n333), .C(n334), .Y(n331) );
  NAND2X1 U353 ( .A(a0[7]), .B(n260), .Y(n332) );
  CLKINVX1 U354 ( .A(n7), .Y(n333) );
  OAI21X1 U355 ( .A0(n264), .A1(n347), .B0(n348), .Y(n30) );
  NAND2X1 U356 ( .A(a2[6]), .B(n278), .Y(n348) );
  CLKINVX1 U357 ( .A(a3[6]), .Y(n347) );
  NAND2X1 U358 ( .A(a1[5]), .B(n132), .Y(n340) );
  NAND3X1 U359 ( .A(n369), .B(n370), .C(n371), .Y(n368) );
  NOR2X1 U360 ( .A(n375), .B(n376), .Y(n369) );
  NAND2X1 U361 ( .A(a8[0]), .B(n372), .Y(n371) );
  NAND2X1 U362 ( .A(n350), .B(n15), .Y(n2) );
  NOR2X1 U363 ( .A(n351), .B(n352), .Y(n350) );
  NOR2BX1 U364 ( .AN(n357), .B(n358), .Y(n15) );
  NAND3X1 U365 ( .A(n353), .B(n354), .C(n355), .Y(n352) );
  NAND2X1 U366 ( .A(n364), .B(n365), .Y(n363) );
  AOI22X1 U367 ( .A0(b2[0]), .A1(n156), .B0(b3[0]), .B1(n166), .Y(n364) );
  CLKINVX1 U368 ( .A(n105), .Y(n365) );
  NAND2X1 U369 ( .A(n266), .B(n267), .Y(n265) );
  AOI21X1 U370 ( .A0(a5[0]), .A1(n134), .B0(n270), .Y(n266) );
  CLKINVX1 U371 ( .A(n93), .Y(n267) );
  NAND3X1 U372 ( .A(n51), .B(n317), .C(n318), .Y(n45) );
  NAND2X1 U373 ( .A(a9[4]), .B(n129), .Y(n317) );
  NOR3X1 U374 ( .A(n319), .B(n320), .C(n321), .Y(n318) );
  CLKINVX1 U375 ( .A(n326), .Y(n51) );
  NOR2X1 U376 ( .A(n323), .B(n378), .Y(n375) );
  CLKINVX1 U377 ( .A(b1[0]), .Y(n378) );
  AO22X4 U378 ( .A0(a6[1]), .A1(n248), .B0(a7[1]), .B1(n144), .Y(n139) );
  NAND2X1 U379 ( .A(a1[7]), .B(n132), .Y(n334) );
  NAND4X1 U380 ( .A(n140), .B(n141), .C(n142), .D(n4), .Y(qq[7]) );
  AOI22X1 U381 ( .A0(a4[7]), .A1(n247), .B0(a5[7]), .B1(n134), .Y(n141) );
  INVX1 U382 ( .A(n2), .Y(n142) );
  AOI22X1 U383 ( .A0(a6[7]), .A1(n248), .B0(a7[7]), .B1(n144), .Y(n140) );
  NAND3X1 U384 ( .A(n153), .B(n154), .C(n155), .Y(n149) );
  NAND2X1 U385 ( .A(b4[6]), .B(n126), .Y(n153) );
  NAND2X1 U386 ( .A(b5[6]), .B(n133), .Y(n154) );
  OAI21X1 U387 ( .A0(n145), .A1(n268), .B0(n269), .Y(n93) );
  NAND2X1 U388 ( .A(a7[0]), .B(n144), .Y(n269) );
  CLKINVX1 U389 ( .A(a6[0]), .Y(n268) );
  NAND2X1 U390 ( .A(n366), .B(n367), .Y(n105) );
  NAND2X1 U391 ( .A(b4[0]), .B(n126), .Y(n366) );
  NAND2X1 U392 ( .A(b5[0]), .B(n133), .Y(n367) );
  NAND3X1 U393 ( .A(n180), .B(n181), .C(n182), .Y(n176) );
  NAND2X1 U394 ( .A(b4[5]), .B(n126), .Y(n180) );
  NAND2X1 U395 ( .A(b5[5]), .B(n133), .Y(n181) );
  NAND2X1 U396 ( .A(b2[5]), .B(n156), .Y(n182) );
  NAND4X1 U397 ( .A(n327), .B(n328), .C(n329), .D(n330), .Y(n326) );
  NAND2X1 U398 ( .A(b4[4]), .B(n126), .Y(n327) );
  NAND2X1 U399 ( .A(b5[4]), .B(n133), .Y(n328) );
  NAND2X1 U400 ( .A(b2[4]), .B(n156), .Y(n330) );
  NAND2X1 U401 ( .A(b4[2]), .B(n126), .Y(n231) );
  NAND2X1 U402 ( .A(b2[2]), .B(n156), .Y(n233) );
  NAND2X1 U403 ( .A(b5[2]), .B(n133), .Y(n232) );
  NAND3X1 U404 ( .A(n210), .B(n211), .C(n212), .Y(n206) );
  NAND2X1 U405 ( .A(b4[3]), .B(n126), .Y(n210) );
  NAND2X1 U406 ( .A(b2[3]), .B(n156), .Y(n212) );
  NAND2X1 U407 ( .A(b5[3]), .B(n133), .Y(n211) );
  NOR2X1 U408 ( .A(n171), .B(n245), .Y(n242) );
  CLKINVX1 U409 ( .A(a7[2]), .Y(n245) );
  NOR2X1 U410 ( .A(n171), .B(n223), .Y(n220) );
  CLKINVX1 U411 ( .A(a7[3]), .Y(n223) );
  NOR2X1 U412 ( .A(n171), .B(n193), .Y(n190) );
  CLKINVX1 U413 ( .A(a7[5]), .Y(n193) );
  NOR2X1 U414 ( .A(n171), .B(n172), .Y(n168) );
  CLKINVX1 U415 ( .A(a7[6]), .Y(n172) );
  NOR2X1 U416 ( .A(n171), .B(n199), .Y(n198) );
  CLKINVX1 U417 ( .A(a7[4]), .Y(n199) );
  NOR2X1 U418 ( .A(n241), .B(n377), .Y(n376) );
  CLKINVX1 U419 ( .A(b0[0]), .Y(n377) );
  NAND2X1 U420 ( .A(b4[7]), .B(n126), .Y(n353) );
  NAND2X1 U421 ( .A(b2[7]), .B(n156), .Y(n354) );
  NAND2X1 U422 ( .A(b2[6]), .B(n156), .Y(n155) );
  NAND2X1 U423 ( .A(a9[0]), .B(n129), .Y(n370) );
  NAND2X1 U424 ( .A(b3[3]), .B(n166), .Y(n218) );
  NAND2X1 U425 ( .A(b1[6]), .B(n167), .Y(n162) );
  NOR2X6 U426 ( .A(n84), .B(n259), .Y(n83) );
endmodule


module xchd ( in_acc, in_ram, out_acc, out_ram );
  input [7:0] in_acc;
  input [7:0] in_ram;
  output [7:0] out_acc;
  output [7:0] out_ram;
  wire   \out_acc[0] , \out_ram[0] , n1, n3, n5, n7, n9, n11, n13, n15, n17,
         n19, n21, n23, n25, n27;
  assign out_acc[0] = \out_acc[0] ;
  assign \out_acc[0]  = in_ram[0];
  assign out_ram[0] = \out_ram[0] ;
  assign \out_ram[0]  = in_acc[0];

  INVX1 U1 ( .A(n27), .Y(out_acc[7]) );
  INVX1 U2 ( .A(n5), .Y(out_ram[3]) );
  INVX1 U3 ( .A(n3), .Y(out_ram[2]) );
  INVX1 U4 ( .A(n13), .Y(out_ram[7]) );
  INVX1 U5 ( .A(n11), .Y(out_ram[6]) );
  INVX1 U6 ( .A(n9), .Y(out_ram[5]) );
  INVX1 U7 ( .A(n7), .Y(out_ram[4]) );
  INVX1 U8 ( .A(n1), .Y(out_ram[1]) );
  CLKINVX1 U9 ( .A(in_acc[7]), .Y(n27) );
  CLKINVX1 U10 ( .A(in_acc[2]), .Y(n3) );
  CLKINVX1 U11 ( .A(in_acc[3]), .Y(n5) );
  CLKINVX1 U12 ( .A(n23), .Y(out_acc[5]) );
  CLKINVX1 U13 ( .A(in_acc[5]), .Y(n23) );
  CLKINVX1 U14 ( .A(n25), .Y(out_acc[6]) );
  CLKINVX1 U15 ( .A(in_acc[6]), .Y(n25) );
  CLKINVX1 U16 ( .A(n21), .Y(out_acc[4]) );
  CLKINVX1 U17 ( .A(in_acc[4]), .Y(n21) );
  CLKINVX1 U18 ( .A(in_ram[7]), .Y(n13) );
  CLKINVX1 U19 ( .A(in_ram[6]), .Y(n11) );
  CLKINVX1 U20 ( .A(in_ram[5]), .Y(n9) );
  CLKINVX1 U21 ( .A(in_ram[4]), .Y(n7) );
  CLKINVX1 U22 ( .A(n15), .Y(out_acc[1]) );
  CLKINVX1 U23 ( .A(in_ram[1]), .Y(n15) );
  CLKINVX1 U24 ( .A(n19), .Y(out_acc[3]) );
  CLKINVX1 U25 ( .A(in_ram[3]), .Y(n19) );
  CLKINVX1 U26 ( .A(n17), .Y(out_acc[2]) );
  CLKINVX1 U27 ( .A(in_ram[2]), .Y(n17) );
  CLKINVX1 U28 ( .A(in_acc[1]), .Y(n1) );
endmodule


module adc ( dataa, datab, cin, ac, cout, overflow, result );
  input [7:0] dataa;
  input [7:0] datab;
  output [7:0] result;
  input cin;
  output ac, cout, overflow;
  wire   n55, n61, n62, n63;

  NAND2X1 U24 ( .A(dataa[7]), .B(n55), .Y(n62) );
  CLKINVX1 U25 ( .A(result[7]), .Y(n55) );
  NAND2X1 U26 ( .A(result[7]), .B(n63), .Y(n61) );
  CLKINVX1 U27 ( .A(dataa[7]), .Y(n63) );
  MXI2X1 U28 ( .S0(datab[7]), .B(n62), .A(n61), .Y(overflow) );
  adc_DW01_add_5_1 add_1_root_add_17_2 ( .A({1'b0, dataa[3:0]}), .B({1'b0, 
        datab[3:0]}), .CI(cin), .SUM({ac, result[3:0]}) );
  adc_DW01_add_5_2 add_1_root_add_18_2 ( .A({1'b0, dataa[7:4]}), .B({1'b0, 
        datab[7:4]}), .CI(ac), .SUM({cout, result[7:4]}) );
endmodule


module adc_DW01_add_5_2 ( A, B, CI, SUM, CO );
  input [4:0] A;
  input [4:0] B;
  output [4:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79;

  INVX1 U5 ( .A(n72), .Y(n67) );
  INVX1 U6 ( .A(n59), .Y(n61) );
  NAND3X1 U7 ( .A(n55), .B(n56), .C(n57), .Y(n52) );
  INVX1 U8 ( .A(n60), .Y(n58) );
  CLKINVX1 U9 ( .A(CI), .Y(n70) );
  CLKINVX1 U10 ( .A(n68), .Y(n77) );
  CLKINVX1 U11 ( .A(n71), .Y(n78) );
  NOR2X1 U12 ( .A(B[3]), .B(A[3]), .Y(n49) );
  NOR2X1 U13 ( .A(n78), .B(n70), .Y(n76) );
  NOR2X1 U14 ( .A(n60), .B(n70), .Y(n66) );
  XNOR2X1 U15 ( .A(n79), .B(n70), .Y(SUM[0]) );
  NOR2X1 U16 ( .A(n77), .B(n78), .Y(n79) );
  XNOR2X1 U17 ( .A(n73), .B(n74), .Y(SUM[1]) );
  NOR2X1 U18 ( .A(n75), .B(n67), .Y(n74) );
  NOR2X1 U19 ( .A(n76), .B(n77), .Y(n73) );
  CLKINVX1 U20 ( .A(n69), .Y(n75) );
  XNOR2X1 U21 ( .A(n53), .B(n54), .Y(SUM[3]) );
  NOR2X1 U22 ( .A(n49), .B(n50), .Y(n54) );
  CLKINVX1 U23 ( .A(n52), .Y(n53) );
  OAI21X1 U24 ( .A0(n67), .A1(n68), .B0(n69), .Y(n62) );
  XNOR2X1 U25 ( .A(n63), .B(n64), .Y(SUM[2]) );
  NOR2X1 U26 ( .A(n65), .B(n61), .Y(n64) );
  NOR2X1 U27 ( .A(n66), .B(n62), .Y(n63) );
  CLKINVX1 U28 ( .A(n56), .Y(n65) );
  NAND2BX1 U29 ( .AN(n61), .B(n62), .Y(n55) );
  NAND3X1 U30 ( .A(n58), .B(n59), .C(CI), .Y(n57) );
  NAND2X1 U31 ( .A(n71), .B(n72), .Y(n60) );
  NOR2X1 U32 ( .A(n49), .B(n51), .Y(SUM[4]) );
  NOR2X1 U33 ( .A(n50), .B(n52), .Y(n51) );
  NAND2X1 U34 ( .A(B[2]), .B(A[2]), .Y(n56) );
  NAND2X1 U35 ( .A(B[1]), .B(A[1]), .Y(n69) );
  NAND2X1 U36 ( .A(B[0]), .B(A[0]), .Y(n68) );
  OR2X1 U37 ( .A(B[0]), .B(A[0]), .Y(n71) );
  OR2X1 U38 ( .A(B[1]), .B(A[1]), .Y(n72) );
  AND2X1 U39 ( .A(B[3]), .B(A[3]), .Y(n50) );
  OR2X1 U40 ( .A(B[2]), .B(A[2]), .Y(n59) );
endmodule


module adc_DW01_add_5_1 ( A, B, CI, SUM, CO );
  input [4:0] A;
  input [4:0] B;
  output [4:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84;

  AOI22X1 U5 ( .A0(n49), .A1(n50), .B0(n51), .B1(n52), .Y(SUM[4]) );
  INVX1 U6 ( .A(CI), .Y(n81) );
  INVX1 U7 ( .A(n69), .Y(n55) );
  NAND3X1 U8 ( .A(n72), .B(n57), .C(n73), .Y(n68) );
  CLKINVX1 U9 ( .A(n63), .Y(n75) );
  OAI21X1 U10 ( .A0(B[1]), .A1(A[1]), .B0(A[0]), .Y(n60) );
  NAND2X1 U11 ( .A(n53), .B(n69), .Y(n70) );
  CLKINVX1 U12 ( .A(n52), .Y(n67) );
  XNOR2X1 U13 ( .A(n64), .B(n65), .Y(SUM[3]) );
  NOR2X1 U14 ( .A(n66), .B(n67), .Y(n65) );
  CLKINVX1 U15 ( .A(n54), .Y(n66) );
  NOR2X1 U16 ( .A(n55), .B(n56), .Y(n50) );
  NAND2X1 U17 ( .A(n53), .B(n54), .Y(n51) );
  NOR2X1 U18 ( .A(n58), .B(n59), .Y(n49) );
  NAND2X1 U19 ( .A(B[3]), .B(A[3]), .Y(n52) );
  NAND2X1 U20 ( .A(B[2]), .B(A[2]), .Y(n69) );
  OR2X1 U21 ( .A(B[2]), .B(A[2]), .Y(n53) );
  AOI21X1 U22 ( .A0(n68), .A1(n53), .B0(n55), .Y(n64) );
  OR2X1 U23 ( .A(B[3]), .B(A[3]), .Y(n54) );
  OAI21X1 U24 ( .A0(n68), .A1(n70), .B0(n71), .Y(SUM[2]) );
  NAND2X1 U25 ( .A(n68), .B(n70), .Y(n71) );
  CLKINVX1 U26 ( .A(B[0]), .Y(n61) );
  NOR2X1 U27 ( .A(n60), .B(n61), .Y(n59) );
  OAI21X1 U28 ( .A0(A[0]), .A1(B[0]), .B0(n82), .Y(n83) );
  NAND2X1 U29 ( .A(B[0]), .B(A[0]), .Y(n82) );
  OAI21X1 U30 ( .A0(n80), .A1(n81), .B0(n82), .Y(n79) );
  NOR2X1 U31 ( .A(A[0]), .B(B[0]), .Y(n80) );
  NOR2X1 U32 ( .A(n62), .B(n63), .Y(n58) );
  NOR2X1 U33 ( .A(A[0]), .B(B[0]), .Y(n62) );
  OAI21X1 U34 ( .A0(CI), .A1(n83), .B0(n84), .Y(SUM[0]) );
  NAND2BX1 U35 ( .AN(n81), .B(n83), .Y(n84) );
  CLKINVX1 U36 ( .A(n60), .Y(n74) );
  NAND2X1 U37 ( .A(n52), .B(n57), .Y(n56) );
  NAND2X1 U38 ( .A(n61), .B(n77), .Y(n76) );
  CLKINVX1 U39 ( .A(A[0]), .Y(n77) );
  NAND2X1 U40 ( .A(n75), .B(n76), .Y(n72) );
  NAND2X1 U41 ( .A(B[0]), .B(n74), .Y(n73) );
  OAI21X1 U42 ( .A0(B[1]), .A1(A[1]), .B0(CI), .Y(n63) );
  NAND2X1 U43 ( .A(B[1]), .B(A[1]), .Y(n57) );
  XNOR2X1 U44 ( .A(n78), .B(n79), .Y(SUM[1]) );
  OAI21X1 U45 ( .A0(B[1]), .A1(A[1]), .B0(n57), .Y(n78) );
endmodule


module sel_al ( isel, osel );
  input [4:0] isel;
  output [3:0] osel;
  wire   n47, n48, n49, n50, n51, n52, n53, n54, n55;

  NAND2X1 U53 ( .A(n50), .B(n53), .Y(osel[0]) );
  CLKINVX1 U54 ( .A(isel[3]), .Y(n48) );
  NAND2X1 U55 ( .A(n48), .B(n49), .Y(n52) );
  NAND2X1 U56 ( .A(isel[0]), .B(n54), .Y(n53) );
  CLKINVX1 U57 ( .A(n47), .Y(osel[3]) );
  OAI21X1 U58 ( .A0(isel[4]), .A1(isel[2]), .B0(n52), .Y(n47) );
  OAI21X1 U59 ( .A0(isel[2]), .A1(n48), .B0(n49), .Y(osel[2]) );
  NAND2X1 U60 ( .A(n50), .B(n51), .Y(osel[1]) );
  OAI21X1 U61 ( .A0(isel[3]), .A1(isel[2]), .B0(isel[4]), .Y(n50) );
  NAND3X1 U62 ( .A(n55), .B(n48), .C(n47), .Y(n54) );
  OAI21X1 U63 ( .A0(isel[2]), .A1(n52), .B0(isel[1]), .Y(n51) );
  CLKINVX1 U64 ( .A(isel[4]), .Y(n49) );
  CLKINVX1 U65 ( .A(isel[2]), .Y(n55) );
endmodule


module sel_arth ( iop2, icin, sel, oop2, ocin );
  input [7:0] iop2;
  input [2:0] sel;
  output [7:0] oop2;
  input icin;
  output ocin;
  wire   n12, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39, n40;

  INVX1 U29 ( .A(n29), .Y(n21) );
  CLKINVX1 U30 ( .A(sel[1]), .Y(n34) );
  NAND3X1 U31 ( .A(sel[1]), .B(n39), .C(n35), .Y(n29) );
  CLKINVX1 U32 ( .A(sel[2]), .Y(n39) );
  NAND2X1 U33 ( .A(n27), .B(n40), .Y(oop2[2]) );
  NAND2X1 U34 ( .A(n26), .B(n40), .Y(oop2[3]) );
  NAND2X1 U35 ( .A(n25), .B(n40), .Y(oop2[4]) );
  NAND2X1 U36 ( .A(n23), .B(n40), .Y(oop2[6]) );
  NAND2X1 U37 ( .A(n24), .B(n40), .Y(oop2[5]) );
  NAND2X1 U38 ( .A(n19), .B(n20), .Y(oop2[7]) );
  INVX1 U39 ( .A(n30), .Y(oop2[0]) );
  NOR2X1 U40 ( .A(n31), .B(n32), .Y(n30) );
  CLKINVX1 U41 ( .A(sel[0]), .Y(n35) );
  CLKINVX1 U42 ( .A(n36), .Y(n22) );
  NAND2X1 U43 ( .A(n39), .B(n34), .Y(n36) );
  CLKBUFX2 U44 ( .A(n20), .Y(n40) );
  NAND3X1 U45 ( .A(sel[2]), .B(n34), .C(n35), .Y(n20) );
  NAND2X1 U46 ( .A(n40), .B(n33), .Y(n32) );
  AOI22X1 U47 ( .A0(iop2[0]), .A1(n36), .B0(n37), .B1(n29), .Y(n31) );
  NAND2X1 U48 ( .A(n28), .B(n40), .Y(oop2[1]) );
  MXI2X1 U49 ( .S0(iop2[1]), .B(n22), .A(n21), .Y(n28) );
  MXI2X1 U50 ( .S0(iop2[2]), .B(n22), .A(n21), .Y(n27) );
  MXI2X1 U51 ( .S0(iop2[6]), .B(n22), .A(n21), .Y(n23) );
  MXI2X1 U52 ( .S0(iop2[5]), .B(n22), .A(n21), .Y(n24) );
  MXI2X1 U53 ( .S0(iop2[4]), .B(n22), .A(n21), .Y(n25) );
  MXI2X1 U54 ( .S0(iop2[3]), .B(n22), .A(n21), .Y(n26) );
  CLKINVX1 U55 ( .A(iop2[0]), .Y(n37) );
  MXI2X1 U56 ( .S0(iop2[7]), .B(n22), .A(n21), .Y(n19) );
  NAND3X1 U57 ( .A(sel[1]), .B(n39), .C(sel[0]), .Y(n33) );
  MXI2X1 U58 ( .S0(icin), .B(n38), .A(n29), .Y(ocin) );
  NAND2X1 U59 ( .A(sel[0]), .B(n22), .Y(n38) );
  INVX12 U60 ( .A(iop2[0]), .Y(n12) );
endmodule


module mul ( op1, op2, m );
  input [7:0] op1;
  input [7:0] op2;
  output [15:0] m;


  mul_DW02_mult_8_8_0 mult_7 ( .A(op1), .B(op2), .TC(1'b0), .PRODUCT(m) );
endmodule


module mul_DW02_mult_8_8_0 ( A, B, TC, PRODUCT );
  input [7:0] A;
  input [7:0] B;
  output [15:0] PRODUCT;
  input TC;
  wire   ab, ab0, ab1, ab2, ab3, ab4, ab5, ab6, ab7, ab8, ab9, ab10, ab11,
         ab12, ab13, ab14, ab15, ab16, ab17, ab18, ab19, ab20, ab21, ab22,
         ab23, ab24, SUMB, SUMB0, SUMB1, SUMB2, SUMB3, SUMB4, SUMB5, SUMB6,
         SUMB7, SUMB8, SUMB9, SUMB10, SUMB11, SUMB12, SUMB13, SUMB14, SUMB15,
         SUMB16, SUMB17, SUMB18, SUMB19, SUMB20, SUMB21, SUMB22, SUMB23,
         SUMB24, SUMB25, SUMB26, SUMB27, SUMB28, SUMB29, SUMB30, SUMB31,
         SUMB32, SUMB33, SUMB34, SUMB35, SUMB36, SUMB37, SUMB38, SUMB39,
         SUMB40, SUMB41, SUMB42, CARRYB, CARRYB0, CARRYB1, CARRYB2, CARRYB3,
         CARRYB4, CARRYB5, CARRYB6, CARRYB7, CARRYB8, CARRYB9, CARRYB10,
         CARRYB11, CARRYB12, CARRYB13, CARRYB14, CARRYB15, CARRYB16, CARRYB17,
         CARRYB18, CARRYB19, CARRYB20, CARRYB21, CARRYB22, CARRYB23, CARRYB24,
         CARRYB25, CARRYB26, CARRYB27, CARRYB28, CARRYB29, CARRYB30, CARRYB31,
         CARRYB32, CARRYB33, CARRYB34, CARRYB35, CARRYB36, CARRYB37, CARRYB38,
         CARRYB39, CARRYB40, CARRYB41, CARRYB42, CARRYB43, CARRYB44, CARRYB45,
         CARRYB46, CARRYB47, PROD1_6_, PROD1_5_, PROD1_4_, PROD1_3_, PROD1_2_,
         CLA_SUM_14_, CLA_SUM_13_, CLA_SUM_12_, CLA_SUM_11_, CLA_SUM_10_,
         CLA_SUM_9_, CLA_SUM_8_, CLA_CARRY_14_, CLA_CARRY_13_, CLA_CARRY_12_,
         CLA_CARRY_11_, CLA_CARRY_10_, CLA_CARRY_9_, CLA_CARRY_8_, n10, n11,
         n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n53, n54, n55, n56, n57, n58, n59, n60,
         n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74,
         n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88,
         n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
         n113, n114, n115, n116, n117, n118, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130;

  INVX8 U5 ( .A(A[1]), .Y(n121) );
  AND2X2 U6 ( .A(A[2]), .B(B[2]), .Y(n10) );
  AND2X2 U7 ( .A(A[2]), .B(B[1]), .Y(n11) );
  AND2X2 U8 ( .A(A[2]), .B(B[5]), .Y(n12) );
  AND2X2 U9 ( .A(A[2]), .B(B[3]), .Y(n13) );
  CLKAND2X2 U10 ( .A(A[3]), .B(B[3]), .Y(n14) );
  AND2X2 U11 ( .A(A[4]), .B(B[3]), .Y(n15) );
  CLKAND2X2 U12 ( .A(A[3]), .B(B[2]), .Y(n16) );
  CLKAND2X2 U13 ( .A(A[4]), .B(B[2]), .Y(n17) );
  AND2X2 U14 ( .A(A[5]), .B(B[2]), .Y(n18) );
  AND2X2 U15 ( .A(A[2]), .B(B[6]), .Y(n19) );
  AND2X2 U16 ( .A(A[4]), .B(B[1]), .Y(n20) );
  CLKAND2X2 U17 ( .A(A[5]), .B(B[1]), .Y(n21) );
  AND2X2 U18 ( .A(A[2]), .B(B[4]), .Y(n22) );
  AND2X2 U19 ( .A(A[3]), .B(B[1]), .Y(n23) );
  AND2X2 U20 ( .A(A[3]), .B(B[4]), .Y(n24) );
  CLKAND2X2 U21 ( .A(B[1]), .B(A[7]), .Y(n25) );
  CLKAND2X2 U22 ( .A(B[2]), .B(A[7]), .Y(n26) );
  AND2X2 U23 ( .A(A[5]), .B(B[3]), .Y(n27) );
  CLKAND2X2 U24 ( .A(A[3]), .B(B[5]), .Y(n28) );
  AND2X2 U25 ( .A(A[5]), .B(B[5]), .Y(n29) );
  CLKAND2X2 U26 ( .A(A[6]), .B(B[2]), .Y(n30) );
  CLKAND2X2 U27 ( .A(A[3]), .B(B[6]), .Y(n31) );
  AND2X2 U28 ( .A(A[4]), .B(B[6]), .Y(n32) );
  CLKAND2X2 U29 ( .A(A[6]), .B(B[1]), .Y(n33) );
  AND2X2 U30 ( .A(A[4]), .B(B[5]), .Y(n34) );
  AND2X2 U31 ( .A(A[4]), .B(B[4]), .Y(n35) );
  AND2X2 U32 ( .A(A[5]), .B(B[4]), .Y(n36) );
  CLKAND2X2 U33 ( .A(B[3]), .B(A[7]), .Y(n37) );
  CLKAND2X2 U34 ( .A(B[4]), .B(A[7]), .Y(n38) );
  CLKAND2X2 U35 ( .A(B[5]), .B(A[7]), .Y(n39) );
  CLKAND2X2 U36 ( .A(B[6]), .B(A[7]), .Y(n40) );
  CLKAND2X2 U37 ( .A(A[6]), .B(B[3]), .Y(n41) );
  CLKAND2X2 U38 ( .A(A[6]), .B(B[5]), .Y(n42) );
  AND2X2 U39 ( .A(A[5]), .B(B[6]), .Y(n43) );
  CLKAND2X2 U40 ( .A(A[6]), .B(B[6]), .Y(n44) );
  CLKAND2X2 U41 ( .A(A[6]), .B(B[4]), .Y(n45) );
  INVX1 U42 ( .A(n81), .Y(CARRYB26) );
  INVX3 U43 ( .A(n67), .Y(CARRYB12) );
  INVX3 U44 ( .A(n84), .Y(CARRYB23) );
  INVX3 U45 ( .A(n100), .Y(CARRYB35) );
  INVX1 U46 ( .A(n114), .Y(ab3) );
  INVX3 U47 ( .A(n76), .Y(CARRYB17) );
  INVX3 U48 ( .A(n69), .Y(CARRYB10) );
  CLKINVX3 U49 ( .A(n104), .Y(CARRYB45) );
  CLKINVX3 U50 ( .A(n106), .Y(CARRYB43) );
  CLKINVX3 U51 ( .A(n83), .Y(CARRYB24) );
  CLKINVX1 U52 ( .A(n110), .Y(ab) );
  INVX1 U53 ( .A(n102), .Y(CARRYB47) );
  INVX1 U54 ( .A(n116), .Y(ab5) );
  CLKINVX3 U55 ( .A(n103), .Y(CARRYB46) );
  INVX1 U56 ( .A(n54), .Y(CLA_CARRY_9_) );
  INVX1 U57 ( .A(n55), .Y(CLA_CARRY_10_) );
  INVX1 U58 ( .A(n57), .Y(CLA_CARRY_12_) );
  INVX1 U59 ( .A(n56), .Y(CLA_CARRY_11_) );
  CLKINVX3 U60 ( .A(n91), .Y(CARRYB30) );
  INVX3 U61 ( .A(n77), .Y(CARRYB16) );
  INVX3 U62 ( .A(n79), .Y(CARRYB14) );
  INVX1 U63 ( .A(n86), .Y(CARRYB21) );
  INVX1 U64 ( .A(n108), .Y(CARRYB41) );
  INVX3 U65 ( .A(n72), .Y(CARRYB7) );
  INVX1 U66 ( .A(n58), .Y(CLA_CARRY_13_) );
  INVX1 U67 ( .A(n120), .Y(ab9) );
  CLKINVX1 U68 ( .A(n53), .Y(CLA_CARRY_8_) );
  INVX1 U69 ( .A(n94), .Y(CARRYB27) );
  INVX1 U70 ( .A(n101), .Y(CARRYB34) );
  CLKINVX3 U71 ( .A(n75), .Y(CARRYB18) );
  CLKINVX1 U72 ( .A(B[7]), .Y(n109) );
  CLKINVX3 U73 ( .A(n78), .Y(CARRYB15) );
  CLKINVX3 U74 ( .A(n68), .Y(CARRYB11) );
  CLKINVX3 U75 ( .A(n71), .Y(CARRYB8) );
  INVX1 U76 ( .A(n130), .Y(PRODUCT[0]) );
  INVX1 U77 ( .A(n59), .Y(CLA_CARRY_14_) );
  INVX1 U78 ( .A(n66), .Y(CARRYB) );
  INVX1 U79 ( .A(n105), .Y(CARRYB44) );
  INVX1 U80 ( .A(n60), .Y(CARRYB5) );
  NOR2X1 U81 ( .A(n109), .B(n119), .Y(ab8) );
  INVX1 U82 ( .A(n107), .Y(CARRYB42) );
  INVX1 U83 ( .A(n61), .Y(CARRYB4) );
  INVX1 U84 ( .A(n62), .Y(CARRYB3) );
  INVX1 U85 ( .A(n65), .Y(CARRYB0) );
  INVX1 U86 ( .A(n63), .Y(CARRYB2) );
  INVX1 U87 ( .A(n64), .Y(CARRYB1) );
  NOR2X1 U88 ( .A(n109), .B(n111), .Y(ab0) );
  INVX3 U89 ( .A(n73), .Y(CARRYB6) );
  NOR2X1 U90 ( .A(n109), .B(n113), .Y(ab2) );
  INVX3 U91 ( .A(n80), .Y(CARRYB13) );
  NOR2X1 U92 ( .A(n109), .B(n115), .Y(ab4) );
  INVX1 U93 ( .A(n87), .Y(CARRYB20) );
  NOR2X1 U94 ( .A(n109), .B(n117), .Y(ab6) );
  CLKINVX1 U95 ( .A(A[2]), .Y(n119) );
  CLKINVX1 U96 ( .A(A[3]), .Y(n117) );
  CLKINVX1 U97 ( .A(A[4]), .Y(n115) );
  CLKINVX1 U98 ( .A(A[5]), .Y(n113) );
  CLKINVX1 U99 ( .A(A[6]), .Y(n111) );
  NOR2BX1 U100 ( .AN(A[7]), .B(n109), .Y(SUMB) );
  CLKINVX1 U101 ( .A(n118), .Y(ab7) );
  CLKINVX1 U102 ( .A(n95), .Y(CARRYB40) );
  NAND2X1 U103 ( .A(A[3]), .B(B[0]), .Y(n118) );
  NAND2X1 U104 ( .A(A[5]), .B(B[0]), .Y(n114) );
  INVX1 U105 ( .A(n88), .Y(CARRYB33) );
  NAND2X1 U106 ( .A(A[4]), .B(B[0]), .Y(n116) );
  CLKINVX1 U107 ( .A(n112), .Y(ab1) );
  CLKINVX1 U108 ( .A(n74), .Y(CARRYB19) );
  NAND2X1 U109 ( .A(A[6]), .B(B[0]), .Y(n112) );
  INVX1 U110 ( .A(n129), .Y(ab24) );
  NAND2X1 U111 ( .A(A[0]), .B(B[1]), .Y(n129) );
  INVX1 U112 ( .A(n96), .Y(CARRYB39) );
  INVX1 U113 ( .A(n89), .Y(CARRYB32) );
  INVX1 U114 ( .A(n128), .Y(ab23) );
  NAND2X1 U115 ( .A(A[0]), .B(B[2]), .Y(n128) );
  INVX1 U116 ( .A(n125), .Y(ab20) );
  NAND2X1 U117 ( .A(A[0]), .B(B[5]), .Y(n125) );
  INVX1 U118 ( .A(n124), .Y(ab19) );
  NAND2X1 U119 ( .A(A[0]), .B(B[6]), .Y(n124) );
  NAND2X1 U120 ( .A(A[2]), .B(B[0]), .Y(n120) );
  INVX1 U121 ( .A(n82), .Y(CARRYB25) );
  INVX1 U122 ( .A(n90), .Y(CARRYB31) );
  INVX1 U123 ( .A(n98), .Y(CARRYB37) );
  INVX1 U124 ( .A(n99), .Y(CARRYB36) );
  INVX1 U125 ( .A(n97), .Y(CARRYB38) );
  NOR2X1 U126 ( .A(n122), .B(n121), .Y(ab17) );
  CLKINVX1 U127 ( .A(B[0]), .Y(n122) );
  NOR2BX1 U128 ( .AN(B[1]), .B(n121), .Y(ab16) );
  NOR2BX1 U129 ( .AN(B[2]), .B(n121), .Y(ab15) );
  NOR2BX1 U130 ( .AN(B[3]), .B(n121), .Y(ab14) );
  INVX1 U131 ( .A(n126), .Y(ab21) );
  NAND2X1 U132 ( .A(A[0]), .B(B[4]), .Y(n126) );
  INVX1 U133 ( .A(n127), .Y(ab22) );
  NAND2X1 U134 ( .A(A[0]), .B(B[3]), .Y(n127) );
  INVX1 U135 ( .A(n85), .Y(CARRYB22) );
  CLKINVX3 U136 ( .A(n93), .Y(CARRYB28) );
  INVX1 U137 ( .A(n123), .Y(ab18) );
  NAND2X1 U138 ( .A(A[0]), .B(B[7]), .Y(n123) );
  INVX1 U139 ( .A(n92), .Y(CARRYB29) );
  NOR2X1 U140 ( .A(n109), .B(n121), .Y(ab10) );
  INVX3 U141 ( .A(n70), .Y(CARRYB9) );
  NOR2BX1 U142 ( .AN(B[6]), .B(n121), .Y(ab11) );
  NOR2BX1 U143 ( .AN(B[4]), .B(n121), .Y(ab13) );
  NOR2BX1 U144 ( .AN(B[5]), .B(n121), .Y(ab12) );
  NAND2X1 U145 ( .A(A[0]), .B(B[0]), .Y(n130) );
  NAND2X1 U147 ( .A(CARRYB), .B(SUMB), .Y(n59) );
  XOR2X1 U148 ( .A(CARRYB), .B(SUMB), .Y(CLA_SUM_14_) );
  NAND2X1 U149 ( .A(CARRYB0), .B(SUMB0), .Y(n58) );
  XOR2X1 U150 ( .A(CARRYB0), .B(SUMB0), .Y(CLA_SUM_13_) );
  NAND2X1 U151 ( .A(CARRYB1), .B(SUMB1), .Y(n57) );
  XOR2X1 U152 ( .A(CARRYB1), .B(SUMB1), .Y(CLA_SUM_12_) );
  NAND2X1 U153 ( .A(CARRYB2), .B(SUMB2), .Y(n56) );
  XOR2X1 U154 ( .A(CARRYB2), .B(SUMB2), .Y(CLA_SUM_11_) );
  NAND2X1 U155 ( .A(CARRYB3), .B(SUMB3), .Y(n55) );
  XOR2X1 U156 ( .A(CARRYB3), .B(SUMB3), .Y(CLA_SUM_10_) );
  NAND2X1 U157 ( .A(CARRYB4), .B(SUMB4), .Y(n54) );
  XOR2X1 U158 ( .A(CARRYB4), .B(SUMB4), .Y(CLA_SUM_9_) );
  NAND2X1 U159 ( .A(CARRYB5), .B(SUMB5), .Y(n53) );
  XOR2X1 U160 ( .A(CARRYB5), .B(SUMB5), .Y(CLA_SUM_8_) );
  NAND2X1 U162 ( .A(ab11), .B(ab18), .Y(n108) );
  XOR2X1 U163 ( .A(ab11), .B(ab18), .Y(SUMB37) );
  NAND2X1 U165 ( .A(ab12), .B(ab19), .Y(n107) );
  XOR2X1 U166 ( .A(ab12), .B(ab19), .Y(SUMB38) );
  NAND2X1 U170 ( .A(ab13), .B(ab20), .Y(n106) );
  XOR2X1 U171 ( .A(ab13), .B(ab20), .Y(SUMB39) );
  NAND2X1 U173 ( .A(ab14), .B(ab21), .Y(n105) );
  XOR2X1 U174 ( .A(ab14), .B(ab21), .Y(SUMB40) );
  NAND2X1 U175 ( .A(ab15), .B(ab22), .Y(n104) );
  XOR2X1 U176 ( .A(ab15), .B(ab22), .Y(SUMB41) );
  NAND2X1 U177 ( .A(ab16), .B(ab23), .Y(n103) );
  XOR2X1 U178 ( .A(ab16), .B(ab23), .Y(SUMB42) );
  NAND2X1 U179 ( .A(ab17), .B(ab24), .Y(n102) );
  XOR2X1 U180 ( .A(ab17), .B(ab24), .Y(PRODUCT[1]) );
  NAND2X1 U181 ( .A(B[0]), .B(A[7]), .Y(n110) );
  mul_DW01_add_14_0 FS_1 ( .A({1'b0, CLA_SUM_14_, CLA_SUM_13_, CLA_SUM_12_, 
        CLA_SUM_11_, CLA_SUM_10_, CLA_SUM_9_, CLA_SUM_8_, SUMB6, PROD1_6_, 
        PROD1_5_, PROD1_4_, PROD1_3_, PROD1_2_}), .B({CLA_CARRY_14_, 
        CLA_CARRY_13_, CLA_CARRY_12_, CLA_CARRY_11_, CLA_CARRY_10_, 
        CLA_CARRY_9_, CLA_CARRY_8_, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .CI(1'b0), .SUM(PRODUCT[15:2]) );
  AFHCONX2 S3_2_6 ( .A(n19), .B(CARRYB41), .CI(ab10), .S(SUMB31), .CON(n101)
         );
  AFHCONX2 S2_2_5 ( .A(n12), .B(CARRYB42), .CI(SUMB37), .S(SUMB32), .CON(n100)
         );
  AFHCONX2 S2_2_4 ( .A(n22), .B(CARRYB43), .CI(SUMB38), .S(SUMB33), .CON(n99)
         );
  AFHCONX2 S2_2_3 ( .A(n13), .B(CARRYB44), .CI(SUMB39), .S(SUMB34), .CON(n98)
         );
  AFHCONX2 S2_2_2 ( .A(n10), .B(CARRYB45), .CI(SUMB40), .S(SUMB35), .CON(n97)
         );
  AFHCONX2 S2_2_1 ( .A(n11), .B(CARRYB46), .CI(SUMB41), .S(SUMB36), .CON(n96)
         );
  AFHCONX2 S1_2_0 ( .A(ab9), .B(CARRYB47), .CI(SUMB42), .S(PROD1_2_), .CON(n95) );
  AFHCONX2 S3_3_6 ( .A(n31), .B(CARRYB34), .CI(ab8), .S(SUMB25), .CON(n94) );
  AFHCONX2 S2_3_5 ( .A(n28), .B(CARRYB35), .CI(SUMB31), .S(SUMB26), .CON(n93)
         );
  AFHCONX2 S2_3_4 ( .A(n24), .B(CARRYB36), .CI(SUMB32), .S(SUMB27), .CON(n92)
         );
  AFHCONX2 S2_3_3 ( .A(n14), .B(CARRYB37), .CI(SUMB33), .S(SUMB28), .CON(n91)
         );
  AFHCONX2 S2_3_2 ( .A(n16), .B(CARRYB38), .CI(SUMB34), .S(SUMB29), .CON(n90)
         );
  AFHCONX2 S2_3_1 ( .A(n23), .B(CARRYB39), .CI(SUMB35), .S(SUMB30), .CON(n89)
         );
  AFHCONX2 S1_3_0 ( .A(ab7), .B(CARRYB40), .CI(SUMB36), .S(PROD1_3_), .CON(n88) );
  AFHCONX2 S3_4_6 ( .A(n32), .B(CARRYB27), .CI(ab6), .S(SUMB19), .CON(n87) );
  AFHCONX2 S2_4_5 ( .A(n34), .B(CARRYB28), .CI(SUMB25), .S(SUMB20), .CON(n86)
         );
  AFHCONX2 S2_4_4 ( .A(n35), .B(CARRYB29), .CI(SUMB26), .S(SUMB21), .CON(n85)
         );
  AFHCONX2 S2_4_3 ( .A(n15), .B(CARRYB30), .CI(SUMB27), .S(SUMB22), .CON(n84)
         );
  AFHCONX2 S2_4_2 ( .A(n17), .B(CARRYB31), .CI(SUMB28), .S(SUMB23), .CON(n83)
         );
  AFHCONX2 S2_4_1 ( .A(n20), .B(CARRYB32), .CI(SUMB29), .S(SUMB24), .CON(n82)
         );
  AFHCONX2 S1_4_0 ( .A(ab5), .B(CARRYB33), .CI(SUMB30), .S(PROD1_4_), .CON(n81) );
  AFHCONX2 S3_5_6 ( .A(n43), .B(CARRYB20), .CI(ab4), .S(SUMB13), .CON(n80) );
  AFHCONX2 S2_5_5 ( .A(n29), .B(CARRYB21), .CI(SUMB19), .S(SUMB14), .CON(n79)
         );
  AFHCONX2 S2_5_4 ( .A(n36), .B(CARRYB22), .CI(SUMB20), .S(SUMB15), .CON(n78)
         );
  AFHCONX2 S2_5_3 ( .A(n27), .B(CARRYB23), .CI(SUMB21), .S(SUMB16), .CON(n77)
         );
  AFHCONX2 S2_5_2 ( .A(n18), .B(CARRYB24), .CI(SUMB22), .S(SUMB17), .CON(n76)
         );
  AFHCONX2 S2_5_1 ( .A(n21), .B(CARRYB25), .CI(SUMB23), .S(SUMB18), .CON(n75)
         );
  AFHCONX2 S1_5_0 ( .A(ab3), .B(CARRYB26), .CI(SUMB24), .S(PROD1_5_), .CON(n74) );
  AFHCONX2 S3_6_6 ( .A(n44), .B(CARRYB13), .CI(ab2), .S(SUMB7), .CON(n73) );
  AFHCONX2 S2_6_5 ( .A(n42), .B(CARRYB14), .CI(SUMB13), .S(SUMB8), .CON(n72)
         );
  AFHCONX2 S2_6_4 ( .A(n45), .B(CARRYB15), .CI(SUMB14), .S(SUMB9), .CON(n71)
         );
  AFHCONX2 S2_6_3 ( .A(n41), .B(CARRYB16), .CI(SUMB15), .S(SUMB10), .CON(n70)
         );
  AFHCONX2 S2_6_2 ( .A(n30), .B(CARRYB17), .CI(SUMB16), .S(SUMB11), .CON(n69)
         );
  AFHCONX2 S2_6_1 ( .A(n33), .B(CARRYB18), .CI(SUMB17), .S(SUMB12), .CON(n68)
         );
  AFHCONX2 S1_6_0 ( .A(ab1), .B(CARRYB19), .CI(SUMB18), .S(PROD1_6_), .CON(n67) );
  AFHCONX2 S5_6 ( .A(n40), .B(CARRYB6), .CI(ab0), .S(SUMB0), .CON(n66) );
  AFHCONX2 S4_5 ( .A(n39), .B(CARRYB7), .CI(SUMB7), .S(SUMB1), .CON(n65) );
  AFHCONX2 S4_4 ( .A(n38), .B(CARRYB8), .CI(SUMB8), .S(SUMB2), .CON(n64) );
  AFHCONX2 S4_3 ( .A(n37), .B(CARRYB9), .CI(SUMB9), .S(SUMB3), .CON(n63) );
  AFHCONX2 S4_2 ( .A(n26), .B(CARRYB10), .CI(SUMB10), .S(SUMB4), .CON(n62) );
  AFHCONX2 S4_1 ( .A(n25), .B(CARRYB11), .CI(SUMB11), .S(SUMB5), .CON(n61) );
  AFHCONX2 S4_0 ( .A(ab), .B(CARRYB12), .CI(SUMB12), .S(SUMB6), .CON(n60) );
endmodule


module mul_DW01_add_14_0 ( A, B, CI, SUM, CO );
  input [13:0] A;
  input [13:0] B;
  output [13:0] SUM;
  input CI;
  output CO;
  wire   \SUM0[0] , n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
         n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74,
         n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88,
         n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
         n113, n114, n115, n116, n117, n118, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145,
         n146;
  assign SUM[0] = \SUM0[0] ;
  assign \SUM0[0]  = A[0];

  XNOR2X1 U5 ( .A(n93), .B(n95), .Y(SUM[12]) );
  CLKINVX1 U6 ( .A(B[11]), .Y(n104) );
  CLKINVX1 U7 ( .A(B[8]), .Y(n121) );
  CLKINVX1 U8 ( .A(n112), .Y(n107) );
  CLKINVX1 U9 ( .A(A[10]), .Y(n114) );
  CLKINVX1 U10 ( .A(n103), .Y(n98) );
  CLKINVX1 U11 ( .A(n126), .Y(n69) );
  INVX1 U12 ( .A(n106), .Y(n99) );
  INVX1 U13 ( .A(n97), .Y(n93) );
  INVX1 U14 ( .A(n92), .Y(n91) );
  INVX1 U15 ( .A(n115), .Y(n108) );
  INVX1 U16 ( .A(n144), .Y(n62) );
  INVX1 U17 ( .A(B[7]), .Y(n145) );
  INVX1 U18 ( .A(A[7]), .Y(n146) );
  INVX1 U19 ( .A(n120), .Y(n57) );
  INVX1 U20 ( .A(A[8]), .Y(n122) );
  NAND2X1 U21 ( .A(B[9]), .B(A[9]), .Y(n53) );
  INVX1 U22 ( .A(n116), .Y(n52) );
  NAND2X1 U23 ( .A(B[10]), .B(A[10]), .Y(n109) );
  NAND2X1 U24 ( .A(B[11]), .B(A[11]), .Y(n100) );
  INVX1 U25 ( .A(n119), .Y(n49) );
  INVX1 U26 ( .A(n123), .Y(n54) );
  INVX1 U27 ( .A(n130), .Y(n72) );
  CLKINVX1 U28 ( .A(n76), .Y(n74) );
  CLKINVX1 U29 ( .A(n81), .Y(n79) );
  INVX1 U30 ( .A(n124), .Y(n59) );
  INVX1 U31 ( .A(A[5]), .Y(n140) );
  INVX1 U32 ( .A(n127), .Y(n75) );
  NAND2X1 U33 ( .A(B[1]), .B(A[1]), .Y(n83) );
  NAND2X1 U34 ( .A(B[4]), .B(A[4]), .Y(n76) );
  NAND2X1 U35 ( .A(B[3]), .B(A[3]), .Y(n81) );
  NAND2X1 U36 ( .A(B[2]), .B(A[2]), .Y(n86) );
  INVX1 U37 ( .A(n135), .Y(n80) );
  INVX1 U38 ( .A(n132), .Y(n85) );
  INVX1 U39 ( .A(n125), .Y(n64) );
  NAND2X1 U40 ( .A(B[6]), .B(A[6]), .Y(n68) );
  INVX1 U41 ( .A(n141), .Y(n67) );
  XNOR2X1 U42 ( .A(B[12]), .B(n96), .Y(n95) );
  INVX1 U43 ( .A(A[12]), .Y(n96) );
  OAI21X1 U44 ( .A0(n107), .A1(n108), .B0(n109), .Y(n106) );
  NOR2X1 U45 ( .A(n93), .B(n94), .Y(n90) );
  NOR2X1 U46 ( .A(A[12]), .B(B[12]), .Y(n94) );
  OAI21X1 U47 ( .A0(n98), .A1(n99), .B0(n100), .Y(n97) );
  XNOR2X1 U48 ( .A(n99), .B(n101), .Y(SUM[11]) );
  NOR2X1 U49 ( .A(n102), .B(n98), .Y(n101) );
  CLKINVX1 U50 ( .A(n100), .Y(n102) );
  XNOR2X1 U51 ( .A(n108), .B(n110), .Y(SUM[10]) );
  NOR2X1 U52 ( .A(n111), .B(n107), .Y(n110) );
  CLKINVX1 U53 ( .A(n109), .Y(n111) );
  NAND2X1 U54 ( .A(B[12]), .B(A[12]), .Y(n92) );
  NOR2X1 U55 ( .A(n90), .B(n91), .Y(n89) );
  OAI21X1 U56 ( .A0(n49), .A1(n52), .B0(n53), .Y(n115) );
  XNOR2X1 U57 ( .A(n49), .B(n50), .Y(SUM[9]) );
  NOR2X1 U58 ( .A(n51), .B(n52), .Y(n50) );
  CLKINVX1 U59 ( .A(n53), .Y(n51) );
  NAND2X1 U60 ( .A(B[7]), .B(A[7]), .Y(n63) );
  NAND2X1 U61 ( .A(B[8]), .B(A[8]), .Y(n58) );
  NAND2X1 U62 ( .A(n145), .B(n146), .Y(n144) );
  NAND2X1 U63 ( .A(n113), .B(n114), .Y(n112) );
  CLKINVX1 U64 ( .A(B[10]), .Y(n113) );
  NAND2X1 U65 ( .A(n104), .B(n105), .Y(n103) );
  INVX1 U66 ( .A(A[11]), .Y(n105) );
  NAND2X1 U67 ( .A(n121), .B(n122), .Y(n120) );
  NAND2X1 U68 ( .A(n117), .B(n118), .Y(n116) );
  INVX1 U69 ( .A(B[9]), .Y(n117) );
  INVX1 U70 ( .A(A[9]), .Y(n118) );
  OAI21X1 U71 ( .A0(n54), .A1(n57), .B0(n58), .Y(n119) );
  XNOR2X1 U72 ( .A(n54), .B(n55), .Y(SUM[8]) );
  NOR2X1 U73 ( .A(n56), .B(n57), .Y(n55) );
  CLKINVX1 U74 ( .A(n58), .Y(n56) );
  OAI21X1 U75 ( .A0(n62), .A1(n59), .B0(n63), .Y(n123) );
  XNOR2X1 U76 ( .A(n59), .B(n60), .Y(SUM[7]) );
  NOR2X1 U77 ( .A(n61), .B(n62), .Y(n60) );
  CLKINVX1 U78 ( .A(n63), .Y(n61) );
  XNOR2X1 U79 ( .A(n72), .B(n73), .Y(SUM[4]) );
  NOR2X1 U80 ( .A(n74), .B(n75), .Y(n73) );
  XNOR2X1 U81 ( .A(n77), .B(n78), .Y(SUM[3]) );
  NOR2X1 U82 ( .A(n79), .B(n80), .Y(n78) );
  OAI21X1 U83 ( .A0(n72), .A1(n75), .B0(n76), .Y(n126) );
  OAI21X1 U84 ( .A0(n67), .A1(n64), .B0(n68), .Y(n124) );
  OAI21X1 U85 ( .A0(n80), .A1(n77), .B0(n81), .Y(n130) );
  INVX1 U86 ( .A(n131), .Y(n77) );
  OAI21X1 U87 ( .A0(n85), .A1(n83), .B0(n86), .Y(n131) );
  XNOR2X1 U88 ( .A(n82), .B(n83), .Y(SUM[2]) );
  NOR2X1 U89 ( .A(n84), .B(n85), .Y(n82) );
  CLKINVX1 U90 ( .A(n86), .Y(n84) );
  XNOR2X1 U91 ( .A(n64), .B(n65), .Y(SUM[6]) );
  NOR2X1 U92 ( .A(n66), .B(n67), .Y(n65) );
  CLKINVX1 U93 ( .A(n68), .Y(n66) );
  NAND2X1 U94 ( .A(n128), .B(n129), .Y(n127) );
  CLKINVX1 U95 ( .A(B[4]), .Y(n128) );
  INVX1 U96 ( .A(A[4]), .Y(n129) );
  XNOR2X1 U97 ( .A(n69), .B(n70), .Y(SUM[5]) );
  AOI21X1 U98 ( .A0(B[5]), .A1(A[5]), .B0(n71), .Y(n70) );
  NAND2X1 U99 ( .A(n142), .B(n143), .Y(n141) );
  CLKINVX1 U100 ( .A(B[6]), .Y(n142) );
  INVX1 U101 ( .A(A[6]), .Y(n143) );
  NAND2X1 U102 ( .A(n133), .B(n134), .Y(n132) );
  CLKINVX1 U103 ( .A(B[2]), .Y(n133) );
  INVX1 U104 ( .A(A[2]), .Y(n134) );
  INVX1 U105 ( .A(n138), .Y(n71) );
  NAND2X1 U106 ( .A(n139), .B(n140), .Y(n138) );
  CLKINVX1 U107 ( .A(B[5]), .Y(n139) );
  NAND2X1 U108 ( .A(n136), .B(n137), .Y(n135) );
  CLKINVX1 U109 ( .A(B[3]), .Y(n136) );
  INVX1 U110 ( .A(A[3]), .Y(n137) );
  NOR2X1 U111 ( .A(n87), .B(n88), .Y(SUM[1]) );
  NOR2X1 U112 ( .A(A[1]), .B(B[1]), .Y(n88) );
  CLKINVX1 U113 ( .A(n83), .Y(n87) );
  OAI2BB2X1 U114 ( .A0N(B[5]), .A1N(A[5]), .B0(n71), .B1(n69), .Y(n125) );
  XNOR2X4 U115 ( .A(n89), .B(B[13]), .Y(SUM[13]) );
endmodule


module UDIV8x8 ( A, B, Quotient, Remainder );
  input [7:0] A;
  input [7:0] B;
  output [7:0] Quotient;
  output [7:0] Remainder;
  wire   notB_7_, notB_1_, notB_0_, PartRem1_0_, PartRem2_6_, PartRem2_5_,
         PartRem2_4_, PartRem2_3_, PartRem2_2_, PartRem2_1_, PartRem2_0_,
         PartRem3_6_, PartRem3_5_, PartRem3_4_, PartRem3_3_, PartRem3_2_,
         PartRem3_1_, PartRem3_0_, PartRem4_6_, PartRem4_5_, PartRem4_4_,
         PartRem4_3_, PartRem4_2_, PartRem4_1_, PartRem4_0_, PartRem5_6_,
         PartRem5_5_, PartRem5_4_, PartRem5_3_, PartRem5_2_, PartRem5_1_,
         PartRem5_0_, PartRem6_6_, PartRem6_5_, PartRem6_4_, PartRem6_3_,
         PartRem6_2_, PartRem6_1_, PartRem6_0_, PartRem7_6_, PartRem7_5_,
         PartRem7_4_, PartRem7_3_, PartRem7_2_, PartRem7_1_, PartRem7_0_,
         Compare1_0_, Compare1_1_, Compare1_2_, Compare1_3_, Compare1_4_,
         Compare1_5_, Compare1_6_, Compare2_0_, Compare2_1_, Compare2_2_,
         Compare2_3_, Compare2_4_, Compare2_5_, Compare2_6_, Compare3_0_,
         Compare3_1_, Compare3_2_, Compare3_3_, Compare3_4_, Compare3_5_,
         Compare3_6_, Compare4_0_, Compare4_1_, Compare4_2_, Compare4_3_,
         Compare4_4_, Compare4_5_, Compare4_6_, Compare5_0_, Compare5_1_,
         Compare5_2_, Compare5_3_, Compare5_4_, Compare5_5_, Compare5_6_,
         Compare6_0_, Compare6_1_, Compare6_2_, Compare6_3_, Compare6_4_,
         Compare6_5_, Compare6_6_, Compare7_0_, Compare7_1_, Compare7_2_,
         Compare7_3_, Compare7_4_, Compare7_5_, Compare7_6_, Compare8_0_,
         Compare8_1_, Compare8_2_, Compare8_3_, Compare8_4_, Compare8_5_,
         Compare8_6_, Compare8_7_, n42, n43, n44, n45, n46, n47, n48, n49, n55,
         n56, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, add_1_root_add_61_2_carry_7_,
         add_1_root_add_61_2_carry_6_, add_1_root_add_61_2_carry_5_,
         add_1_root_add_61_2_carry_4_, add_1_root_add_61_2_carry_3_,
         add_1_root_add_61_2_carry_2_, add_1_root_add_61_2_carry_1_, n117,
         n118, n119, n120, n121, n122, n123;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3, 
        SYNOPSYS_UNCONNECTED__4, SYNOPSYS_UNCONNECTED__5;

  CLKINVX1 U90 ( .A(n105), .Y(PartRem3_3_) );
  CLKINVX3 U91 ( .A(n104), .Y(PartRem3_4_) );
  INVX6 U92 ( .A(B[7]), .Y(notB_7_) );
  CLKINVX8 U93 ( .A(B[0]), .Y(notB_0_) );
  INVX3 U94 ( .A(n114), .Y(PartRem2_0_) );
  MXI2X1 U95 ( .S0(Quotient[6]), .B(Compare2_0_), .A(A[6]), .Y(n114) );
  CLKINVX1 U96 ( .A(n111), .Y(PartRem2_4_) );
  CLKINVX1 U97 ( .A(n112), .Y(PartRem2_3_) );
  INVX1 U98 ( .A(n119), .Y(add_1_root_add_61_2_carry_3_) );
  INVX4 U99 ( .A(B[5]), .Y(n62) );
  INVX3 U100 ( .A(B[6]), .Y(n63) );
  INVX3 U101 ( .A(B[3]), .Y(n60) );
  CLKBUFX4 U102 ( .A(n58), .Y(notB_1_) );
  CLKINVX2 U103 ( .A(n56), .Y(n55) );
  NAND2X8 U104 ( .A(n116), .B(B[0]), .Y(add_1_root_add_61_2_carry_1_) );
  CLKINVX8 U105 ( .A(A[7]), .Y(n116) );
  MXI2X2 U106 ( .S0(Quotient[1]), .B(Compare7_3_), .A(PartRem6_2_), .Y(n70) );
  INVX2 U107 ( .A(n87), .Y(PartRem6_0_) );
  INVX1 U108 ( .A(n115), .Y(PartRem1_0_) );
  CLKINVX1 U109 ( .A(n120), .Y(add_1_root_add_61_2_carry_4_) );
  CLKINVX1 U110 ( .A(n123), .Y(add_1_root_add_61_2_carry_7_) );
  CLKINVX1 U111 ( .A(n122), .Y(add_1_root_add_61_2_carry_6_) );
  CLKINVX3 U112 ( .A(n118), .Y(add_1_root_add_61_2_carry_2_) );
  CLKINVX2 U113 ( .A(n100), .Y(PartRem4_1_) );
  CLKINVX1 U114 ( .A(n90), .Y(PartRem5_4_) );
  INVX1 U115 ( .A(n92), .Y(PartRem5_2_) );
  CLKINVX1 U116 ( .A(n99), .Y(PartRem4_2_) );
  CLKINVX3 U117 ( .A(n101), .Y(PartRem4_0_) );
  CLKINVX3 U118 ( .A(n91), .Y(PartRem5_3_) );
  INVX3 U119 ( .A(n94), .Y(PartRem5_0_) );
  INVX2 U120 ( .A(n93), .Y(PartRem5_1_) );
  INVX1 U121 ( .A(n85), .Y(PartRem6_2_) );
  CLKINVX1 U122 ( .A(n106), .Y(PartRem2_1_) );
  CLKINVX3 U123 ( .A(n86), .Y(PartRem6_1_) );
  INVX1 U124 ( .A(n74), .Y(PartRem7_1_) );
  CLKINVX1 U125 ( .A(n95), .Y(PartRem3_5_) );
  CLKINVX1 U126 ( .A(n98), .Y(PartRem4_3_) );
  CLKINVX1 U127 ( .A(n97), .Y(PartRem4_4_) );
  INVX1 U128 ( .A(n102), .Y(PartRem2_5_) );
  NOR2X1 U129 ( .A(n48), .B(n110), .Y(PartRem2_6_) );
  CLKINVX1 U130 ( .A(A[7]), .Y(n56) );
  INVX1 U131 ( .A(n83), .Y(PartRem6_4_) );
  INVX1 U132 ( .A(n64), .Y(PartRem7_6_) );
  INVX1 U133 ( .A(n82), .Y(PartRem6_5_) );
  INVX1 U134 ( .A(n68), .Y(PartRem7_4_) );
  MXI2X1 U135 ( .S0(Quotient[1]), .B(Compare7_4_), .A(PartRem6_3_), .Y(n68) );
  MXI2X1 U136 ( .S0(Quotient[1]), .B(Compare7_5_), .A(PartRem6_4_), .Y(n66) );
  INVX1 U137 ( .A(n88), .Y(PartRem4_5_) );
  MXI2X1 U138 ( .S0(Quotient[3]), .B(Compare5_5_), .A(PartRem4_4_), .Y(n80) );
  INVX1 U139 ( .A(n84), .Y(PartRem6_3_) );
  INVX1 U140 ( .A(Compare5_6_), .Y(n89) );
  INVX3 U141 ( .A(n70), .Y(PartRem7_3_) );
  INVX1 U142 ( .A(n72), .Y(PartRem7_2_) );
  MXI2X1 U143 ( .S0(Quotient[4]), .B(n96), .A(n95), .Y(PartRem4_6_) );
  CLKINVX1 U144 ( .A(Compare4_6_), .Y(n96) );
  MXI2X1 U145 ( .S0(Quotient[1]), .B(Compare7_2_), .A(PartRem6_1_), .Y(n72) );
  MXI2X1 U146 ( .S0(Quotient[4]), .B(Compare4_5_), .A(PartRem3_4_), .Y(n88) );
  CLKINVX3 U147 ( .A(n109), .Y(PartRem3_0_) );
  NAND2X1 U148 ( .A(add_1_root_add_61_2_carry_3_), .B(n60), .Y(n120) );
  NAND2X1 U149 ( .A(add_1_root_add_61_2_carry_4_), .B(n61), .Y(n121) );
  MXI2X1 U150 ( .S0(Quotient[3]), .B(Compare5_0_), .A(A[3]), .Y(n94) );
  OAI21X1 U151 ( .A0(notB_0_), .A1(n49), .B0(n55), .Y(n115) );
  NAND2X1 U152 ( .A(add_1_root_add_61_2_carry_7_), .B(notB_7_), .Y(n49) );
  MXI2X1 U153 ( .S0(Quotient[5]), .B(Compare3_5_), .A(PartRem2_4_), .Y(n95) );
  MXI2X1 U154 ( .S0(Quotient[5]), .B(n107), .A(n106), .Y(PartRem3_2_) );
  INVX1 U155 ( .A(Compare3_2_), .Y(n107) );
  MXI2X1 U156 ( .S0(Quotient[1]), .B(Compare7_1_), .A(PartRem6_0_), .Y(n74) );
  CLKINVX3 U157 ( .A(n108), .Y(PartRem3_1_) );
  INVX1 U158 ( .A(n76), .Y(PartRem7_0_) );
  CLKINVX1 U159 ( .A(A[0]), .Y(n78) );
  CLKINVX1 U160 ( .A(Compare8_1_), .Y(n77) );
  MXI2X1 U161 ( .S0(Quotient[6]), .B(Compare2_1_), .A(PartRem1_0_), .Y(n106)
         );
  MXI2X1 U162 ( .S0(Quotient[1]), .B(Compare7_0_), .A(A[1]), .Y(n76) );
  INVX1 U163 ( .A(Compare2_6_), .Y(n110) );
  CLKINVX3 U164 ( .A(n113), .Y(PartRem2_2_) );
  MXI2X1 U165 ( .S0(Quotient[2]), .B(n81), .A(n80), .Y(PartRem6_6_) );
  CLKINVX1 U166 ( .A(Compare6_6_), .Y(n81) );
  MXI2X1 U167 ( .S0(Quotient[2]), .B(Compare6_4_), .A(PartRem5_3_), .Y(n83) );
  MXI2X1 U168 ( .S0(Quotient[2]), .B(Compare6_5_), .A(PartRem5_4_), .Y(n82) );
  CLKINVX1 U169 ( .A(n80), .Y(PartRem5_5_) );
  CLKINVX1 U170 ( .A(n66), .Y(PartRem7_5_) );
  MXI2X1 U171 ( .S0(Quotient[0]), .B(n69), .A(n68), .Y(Remainder[5]) );
  CLKINVX1 U172 ( .A(Compare8_5_), .Y(n69) );
  MXI2X1 U173 ( .S0(Quotient[0]), .B(n67), .A(n66), .Y(Remainder[6]) );
  CLKINVX1 U174 ( .A(Compare8_6_), .Y(n67) );
  MXI2X1 U175 ( .S0(Quotient[3]), .B(n89), .A(n88), .Y(PartRem5_6_) );
  MXI2X1 U176 ( .S0(Quotient[1]), .B(Compare7_6_), .A(PartRem6_5_), .Y(n64) );
  MXI2X1 U177 ( .S0(Quotient[3]), .B(Compare5_3_), .A(PartRem4_2_), .Y(n91) );
  MXI2X1 U178 ( .S0(Quotient[2]), .B(Compare6_3_), .A(PartRem5_2_), .Y(n84) );
  MXI2X1 U179 ( .S0(Quotient[3]), .B(Compare5_2_), .A(PartRem4_1_), .Y(n92) );
  MXI2X1 U180 ( .S0(Quotient[3]), .B(Compare5_4_), .A(PartRem4_3_), .Y(n90) );
  MXI2X1 U181 ( .S0(Quotient[2]), .B(Compare6_2_), .A(PartRem5_1_), .Y(n85) );
  MXI2X1 U182 ( .S0(Quotient[0]), .B(n71), .A(n70), .Y(Remainder[4]) );
  CLKINVX1 U183 ( .A(Compare8_4_), .Y(n71) );
  MXI2X1 U184 ( .S0(Quotient[0]), .B(n65), .A(n64), .Y(Remainder[7]) );
  CLKINVX1 U185 ( .A(Compare8_7_), .Y(n65) );
  MXI2X1 U186 ( .S0(Quotient[0]), .B(n73), .A(n72), .Y(Remainder[3]) );
  CLKINVX1 U187 ( .A(Compare8_3_), .Y(n73) );
  MXI2X1 U188 ( .S0(Quotient[4]), .B(Compare4_0_), .A(A[4]), .Y(n101) );
  MXI2X1 U189 ( .S0(Quotient[2]), .B(Compare6_0_), .A(A[2]), .Y(n87) );
  MXI2X1 U190 ( .S0(Quotient[5]), .B(Compare3_0_), .A(A[5]), .Y(n109) );
  MXI2X1 U191 ( .S0(Quotient[4]), .B(Compare4_3_), .A(PartRem3_2_), .Y(n98) );
  MXI2X1 U192 ( .S0(Quotient[3]), .B(Compare5_1_), .A(PartRem4_0_), .Y(n93) );
  MXI2X1 U193 ( .S0(Quotient[4]), .B(Compare4_2_), .A(PartRem3_1_), .Y(n99) );
  MXI2X1 U194 ( .S0(Quotient[4]), .B(Compare4_1_), .A(PartRem3_0_), .Y(n100)
         );
  MXI2X1 U195 ( .S0(Quotient[4]), .B(Compare4_4_), .A(PartRem3_3_), .Y(n97) );
  MXI2X1 U196 ( .S0(Quotient[2]), .B(Compare6_1_), .A(PartRem5_0_), .Y(n86) );
  NAND2X1 U197 ( .A(add_1_root_add_61_2_carry_5_), .B(n62), .Y(n122) );
  CLKINVX1 U198 ( .A(n121), .Y(add_1_root_add_61_2_carry_5_) );
  NAND2X1 U199 ( .A(add_1_root_add_61_2_carry_6_), .B(n63), .Y(n123) );
  MXI2X1 U200 ( .S0(Quotient[0]), .B(n75), .A(n74), .Y(Remainder[2]) );
  CLKINVX1 U201 ( .A(Compare8_2_), .Y(n75) );
  CLKINVX1 U202 ( .A(n49), .Y(Quotient[7]) );
  MXI2X1 U203 ( .S0(Quotient[5]), .B(n103), .A(n102), .Y(PartRem3_6_) );
  INVX1 U204 ( .A(Compare3_6_), .Y(n103) );
  MXI2X1 U205 ( .S0(Quotient[5]), .B(Compare3_4_), .A(PartRem2_3_), .Y(n104)
         );
  MXI2X1 U206 ( .S0(Quotient[5]), .B(Compare3_3_), .A(PartRem2_2_), .Y(n105)
         );
  MXI2X1 U207 ( .S0(Quotient[5]), .B(Compare3_1_), .A(PartRem2_0_), .Y(n108)
         );
  NAND2BX1 U208 ( .AN(B[2]), .B(add_1_root_add_61_2_carry_2_), .Y(n119) );
  NAND2BX1 U209 ( .AN(B[1]), .B(add_1_root_add_61_2_carry_1_), .Y(n118) );
  CLKINVX1 U210 ( .A(B[1]), .Y(n58) );
  CLKINVX1 U211 ( .A(B[2]), .Y(n59) );
  MXI2X1 U212 ( .S0(Quotient[0]), .B(n79), .A(n78), .Y(Remainder[0]) );
  CLKINVX1 U213 ( .A(Compare8_0_), .Y(n79) );
  MXI2X1 U214 ( .S0(Quotient[0]), .B(n77), .A(n76), .Y(Remainder[1]) );
  NAND2X1 U215 ( .A(Compare2_3_), .B(Quotient[6]), .Y(n112) );
  NAND2X1 U216 ( .A(Compare2_4_), .B(Quotient[6]), .Y(n111) );
  CLKINVX1 U217 ( .A(Quotient[6]), .Y(n48) );
  NAND2X1 U218 ( .A(Compare2_2_), .B(Quotient[6]), .Y(n113) );
  NAND2X1 U219 ( .A(Compare2_5_), .B(Quotient[6]), .Y(n102) );
  INVX8 U220 ( .A(B[4]), .Y(n61) );
  INVX12 U221 ( .A(Quotient[5]), .Y(n47) );
  INVX12 U222 ( .A(Quotient[4]), .Y(n46) );
  INVX12 U223 ( .A(Quotient[3]), .Y(n45) );
  INVX12 U224 ( .A(Quotient[2]), .Y(n44) );
  INVX12 U225 ( .A(Quotient[1]), .Y(n43) );
  INVX12 U226 ( .A(Quotient[0]), .Y(n42) );
  INVX8 U227 ( .A(add_1_root_add_61_2_carry_1_), .Y(n117) );
  XNOR2X4 U229 ( .A(n122), .B(n63), .Y(Compare1_6_) );
  XNOR2X4 U230 ( .A(n121), .B(n62), .Y(Compare1_5_) );
  XNOR2X4 U231 ( .A(n120), .B(n61), .Y(Compare1_4_) );
  XNOR2X4 U232 ( .A(B[3]), .B(add_1_root_add_61_2_carry_3_), .Y(Compare1_3_)
         );
  XNOR2X4 U233 ( .A(B[2]), .B(add_1_root_add_61_2_carry_2_), .Y(Compare1_2_)
         );
  XNOR2X4 U234 ( .A(B[1]), .B(add_1_root_add_61_2_carry_1_), .Y(Compare1_1_)
         );
  OAI21X4 U235 ( .A0(B[0]), .A1(n56), .B0(add_1_root_add_61_2_carry_1_), .Y(
        Compare1_0_) );
  UDIV8x8_DW01_add_9_7 add_1_root_add_146_2 ( .A({1'b0, PartRem5_6_, 
        PartRem5_5_, PartRem5_4_, PartRem5_3_, PartRem5_2_, PartRem5_1_, 
        PartRem5_0_, A[2]}), .B({1'b0, notB_7_, n63, n62, n61, n60, n59, 
        notB_1_, notB_0_}), .CI(1'b1), .SUM({Quotient[2], 
        SYNOPSYS_UNCONNECTED__0, Compare6_6_, Compare6_5_, Compare6_4_, 
        Compare6_3_, Compare6_2_, Compare6_1_, Compare6_0_}) );
  UDIV8x8_DW01_add_9_6 add_1_root_add_181_2 ( .A({1'b0, PartRem7_6_, 
        PartRem7_5_, PartRem7_4_, PartRem7_3_, PartRem7_2_, PartRem7_1_, 
        PartRem7_0_, A[0]}), .B({1'b0, notB_7_, n63, n62, n61, n60, n59, 
        notB_1_, notB_0_}), .CI(1'b1), .SUM({Quotient[0], Compare8_7_, 
        Compare8_6_, Compare8_5_, Compare8_4_, Compare8_3_, Compare8_2_, 
        Compare8_1_, Compare8_0_}) );
  UDIV8x8_DW01_add_9_2 add_1_root_add_163_2 ( .A({1'b0, PartRem6_6_, 
        PartRem6_5_, PartRem6_4_, PartRem6_3_, PartRem6_2_, PartRem6_1_, 
        PartRem6_0_, A[1]}), .B({1'b0, notB_7_, n63, n62, n61, n60, n59, 
        notB_1_, notB_0_}), .CI(1'b1), .SUM({Quotient[1], 
        SYNOPSYS_UNCONNECTED__1, Compare7_6_, Compare7_5_, Compare7_4_, 
        Compare7_3_, Compare7_2_, Compare7_1_, Compare7_0_}) );
  UDIV8x8_DW01_add_9_4 add_1_root_add_95_2 ( .A({1'b0, PartRem2_6_, 
        PartRem2_5_, PartRem2_4_, PartRem2_3_, PartRem2_2_, PartRem2_1_, 
        PartRem2_0_, A[5]}), .B({1'b0, notB_7_, n63, n62, n61, n60, n59, 
        notB_1_, notB_0_}), .CI(1'b1), .SUM({Quotient[5], 
        SYNOPSYS_UNCONNECTED__2, Compare3_6_, Compare3_5_, Compare3_4_, 
        Compare3_3_, Compare3_2_, Compare3_1_, Compare3_0_}) );
  UDIV8x8_DW01_add_9_3 add_1_root_add_129_2 ( .A({1'b0, PartRem4_6_, 
        PartRem4_5_, PartRem4_4_, PartRem4_3_, PartRem4_2_, PartRem4_1_, 
        PartRem4_0_, A[3]}), .B({1'b0, notB_7_, n63, n62, n61, n60, n59, 
        notB_1_, notB_0_}), .CI(1'b1), .SUM({Quotient[3], 
        SYNOPSYS_UNCONNECTED__3, Compare5_6_, Compare5_5_, Compare5_4_, 
        Compare5_3_, Compare5_2_, Compare5_1_, Compare5_0_}) );
  UDIV8x8_DW01_add_9_1 add_1_root_add_112_2 ( .A({1'b0, PartRem3_6_, 
        PartRem3_5_, PartRem3_4_, PartRem3_3_, PartRem3_2_, PartRem3_1_, 
        PartRem3_0_, A[4]}), .B({1'b0, notB_7_, n63, n62, n61, n60, n59, 
        notB_1_, notB_0_}), .CI(1'b1), .SUM({Quotient[4], 
        SYNOPSYS_UNCONNECTED__4, Compare4_6_, Compare4_5_, Compare4_4_, 
        Compare4_3_, Compare4_2_, Compare4_1_, Compare4_0_}) );
  UDIV8x8_DW01_add_9_8 add_1_root_add_78_2 ( .A({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, PartRem1_0_, A[6]}), .B({1'b0, notB_7_, n63, n62, n61, n60, 
        n59, notB_1_, notB_0_}), .CI(1'b1), .SUM({Quotient[6], 
        SYNOPSYS_UNCONNECTED__5, Compare2_6_, Compare2_5_, Compare2_4_, 
        Compare2_3_, Compare2_2_, Compare2_1_, Compare2_0_}) );
endmodule


module UDIV8x8_DW01_add_9_8 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64,
         n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78,
         n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91;

  NAND2X1 U5 ( .A(1'b1), .B(n69), .Y(n66) );
  CLKINVX1 U6 ( .A(n73), .Y(n70) );
  CLKINVX1 U7 ( .A(n55), .Y(n49) );
  NAND2X1 U8 ( .A(n56), .B(n57), .Y(n55) );
  NAND2BX2 U9 ( .AN(B[2]), .B(1'b1), .Y(n58) );
  CLKINVX2 U10 ( .A(n65), .Y(n54) );
  INVX3 U11 ( .A(A[0]), .Y(n91) );
  NAND2X1 U12 ( .A(B[4]), .B(B[7]), .Y(n51) );
  NAND2X1 U13 ( .A(n61), .B(n60), .Y(n79) );
  NAND2X1 U14 ( .A(n86), .B(n87), .Y(n85) );
  NAND2X2 U15 ( .A(n90), .B(n91), .Y(n63) );
  CLKINVX1 U16 ( .A(B[6]), .Y(n65) );
  INVX3 U17 ( .A(B[1]), .Y(n61) );
  NAND2X1 U18 ( .A(n77), .B(n78), .Y(n74) );
  CLKINVX1 U19 ( .A(n81), .Y(n84) );
  INVX1 U20 ( .A(n58), .Y(n81) );
  NOR3X4 U21 ( .A(n49), .B(n50), .C(n51), .Y(SUM[8]) );
  NAND2X2 U22 ( .A(n54), .B(B[5]), .Y(n50) );
  NAND2X1 U23 ( .A(n74), .B(B[3]), .Y(n73) );
  NAND2X1 U24 ( .A(n70), .B(B[4]), .Y(n69) );
  CLKINVX1 U25 ( .A(n85), .Y(n83) );
  NAND2X1 U26 ( .A(n79), .B(n63), .Y(n87) );
  CLKINVX3 U27 ( .A(A[1]), .Y(n60) );
  NOR2X1 U28 ( .A(n60), .B(n61), .Y(n59) );
  CLKINVX1 U29 ( .A(B[0]), .Y(n90) );
  NAND2X1 U30 ( .A(B[1]), .B(A[1]), .Y(n86) );
  NAND2X1 U31 ( .A(A[1]), .B(B[1]), .Y(n82) );
  NAND2X1 U32 ( .A(n63), .B(n89), .Y(SUM[0]) );
  NAND2X1 U33 ( .A(B[0]), .B(A[0]), .Y(n89) );
  XNOR2X1 U34 ( .A(n88), .B(n63), .Y(SUM[1]) );
  OAI21X1 U35 ( .A0(A[1]), .A1(B[1]), .B0(n86), .Y(n88) );
  OAI21X1 U36 ( .A0(n74), .A1(n75), .B0(n76), .Y(SUM[3]) );
  NAND2X1 U37 ( .A(n74), .B(n75), .Y(n76) );
  OAI21X1 U38 ( .A0(n70), .A1(n71), .B0(n72), .Y(SUM[4]) );
  NAND2X1 U39 ( .A(n70), .B(n71), .Y(n72) );
  XNOR2X1 U40 ( .A(n64), .B(n54), .Y(SUM[6]) );
  OAI22X1 U41 ( .A0(n83), .A1(n84), .B0(n81), .B1(n85), .Y(SUM[2]) );
  OAI21X1 U42 ( .A0(n66), .A1(n67), .B0(n68), .Y(SUM[5]) );
  NAND2X1 U43 ( .A(n66), .B(n67), .Y(n68) );
  NAND3X1 U44 ( .A(n63), .B(n79), .C(n58), .Y(n78) );
  NOR2X1 U45 ( .A(n81), .B(n82), .Y(n80) );
  NAND4X1 U46 ( .A(n62), .B(n63), .C(n58), .D(B[3]), .Y(n56) );
  NAND3X1 U47 ( .A(n58), .B(B[3]), .C(n59), .Y(n57) );
  NAND2X1 U48 ( .A(n61), .B(n60), .Y(n62) );
  NAND2X1 U49 ( .A(n66), .B(B[5]), .Y(n64) );
  CLKINVX1 U50 ( .A(B[4]), .Y(n71) );
  CLKINVX1 U51 ( .A(B[3]), .Y(n75) );
  CLKINVX1 U52 ( .A(B[5]), .Y(n67) );
  CLKINVX1 U53 ( .A(n80), .Y(n77) );
endmodule


module UDIV8x8_DW01_add_9_1 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124;

  CLKINVX1 U5 ( .A(n116), .Y(n115) );
  INVX1 U6 ( .A(A[1]), .Y(n75) );
  CLKINVX1 U7 ( .A(n92), .Y(n98) );
  NAND2X1 U8 ( .A(n105), .B(n106), .Y(n73) );
  INVX1 U9 ( .A(n52), .Y(n61) );
  NAND2X1 U10 ( .A(n76), .B(n75), .Y(n109) );
  NOR2X1 U11 ( .A(n75), .B(n76), .Y(n74) );
  NAND2X1 U12 ( .A(n107), .B(n108), .Y(n101) );
  NOR2X1 U13 ( .A(n110), .B(n111), .Y(n107) );
  NAND2X1 U14 ( .A(n76), .B(n75), .Y(n77) );
  NAND2X1 U15 ( .A(n119), .B(n120), .Y(n117) );
  INVX1 U16 ( .A(n73), .Y(n67) );
  NOR2X1 U17 ( .A(n83), .B(n84), .Y(n82) );
  NAND2X1 U18 ( .A(B[2]), .B(A[2]), .Y(n68) );
  NAND2X1 U19 ( .A(B[6]), .B(A[6]), .Y(n63) );
  NOR2X1 U20 ( .A(n112), .B(n113), .Y(n111) );
  NAND2X1 U21 ( .A(B[3]), .B(A[3]), .Y(n80) );
  NAND2X1 U22 ( .A(n62), .B(n63), .Y(n52) );
  CLKINVX1 U23 ( .A(B[3]), .Y(n105) );
  INVX1 U24 ( .A(A[3]), .Y(n106) );
  NAND2BX2 U25 ( .AN(B[2]), .B(n118), .Y(n72) );
  NAND2BX1 U26 ( .AN(B[5]), .B(n91), .Y(n57) );
  NAND2BX1 U27 ( .AN(B[6]), .B(n85), .Y(n56) );
  NAND2X1 U28 ( .A(n54), .B(n55), .Y(n53) );
  NAND2BX1 U29 ( .AN(B[4]), .B(n99), .Y(n95) );
  NAND2X2 U30 ( .A(n123), .B(n124), .Y(n78) );
  CLKINVX1 U31 ( .A(B[1]), .Y(n76) );
  CLKINVX1 U32 ( .A(n117), .Y(n114) );
  CLKINVX1 U33 ( .A(n101), .Y(n102) );
  CLKINVX1 U34 ( .A(n94), .Y(n96) );
  NAND3BX1 U35 ( .AN(n69), .B(n70), .C(n71), .Y(n58) );
  NAND2X1 U36 ( .A(n79), .B(n80), .Y(n69) );
  NAND3X1 U37 ( .A(n72), .B(n73), .C(n74), .Y(n71) );
  NAND4X1 U38 ( .A(n77), .B(n78), .C(n72), .D(n73), .Y(n70) );
  NOR2X1 U39 ( .A(n67), .B(n68), .Y(n64) );
  NAND2X1 U40 ( .A(n92), .B(n93), .Y(n86) );
  NAND2X1 U41 ( .A(n94), .B(n95), .Y(n93) );
  NAND3X1 U42 ( .A(n78), .B(n109), .C(n72), .Y(n108) );
  CLKINVX1 U43 ( .A(n68), .Y(n110) );
  AOI21X1 U44 ( .A0(n86), .A1(n57), .B0(n87), .Y(n81) );
  CLKINVX1 U45 ( .A(n88), .Y(n87) );
  NAND2X1 U46 ( .A(n80), .B(n100), .Y(n94) );
  NAND2X1 U47 ( .A(n101), .B(n73), .Y(n100) );
  NAND2X1 U48 ( .A(n60), .B(n61), .Y(n59) );
  NOR2X1 U49 ( .A(n64), .B(n65), .Y(n60) );
  CLKINVX1 U50 ( .A(n66), .Y(n65) );
  CLKINVX1 U51 ( .A(n95), .Y(n54) );
  NAND2X1 U52 ( .A(n68), .B(n72), .Y(n116) );
  NAND2X1 U53 ( .A(n109), .B(n78), .Y(n120) );
  CLKINVX1 U54 ( .A(n80), .Y(n104) );
  CLKINVX1 U55 ( .A(n63), .Y(n83) );
  CLKINVX1 U56 ( .A(n56), .Y(n84) );
  NOR3X2 U57 ( .A(n49), .B(n50), .C(n51), .Y(SUM[8]) );
  OAI22X1 U58 ( .A0(n52), .A1(n56), .B0(n52), .B1(n57), .Y(n50) );
  OAI22X1 U59 ( .A0(n52), .A1(n53), .B0(B[7]), .B1(A[7]), .Y(n51) );
  NOR2X1 U60 ( .A(n58), .B(n59), .Y(n49) );
  XNOR2X1 U61 ( .A(n81), .B(n82), .Y(SUM[6]) );
  OAI21X1 U62 ( .A0(n86), .A1(n89), .B0(n90), .Y(SUM[5]) );
  NAND2X1 U63 ( .A(n86), .B(n89), .Y(n90) );
  NAND2X1 U64 ( .A(n57), .B(n88), .Y(n89) );
  NAND2X1 U65 ( .A(n78), .B(n122), .Y(SUM[0]) );
  NAND2X1 U66 ( .A(B[0]), .B(A[0]), .Y(n122) );
  XNOR2X1 U67 ( .A(n102), .B(n103), .Y(SUM[3]) );
  NOR2X1 U68 ( .A(n104), .B(n67), .Y(n103) );
  INVX3 U69 ( .A(A[2]), .Y(n118) );
  OAI22X1 U70 ( .A0(n114), .A1(n115), .B0(n116), .B1(n117), .Y(SUM[2]) );
  XNOR2X1 U71 ( .A(n121), .B(n78), .Y(SUM[1]) );
  OAI21X1 U72 ( .A0(A[1]), .A1(B[1]), .B0(n119), .Y(n121) );
  XNOR2X1 U73 ( .A(n96), .B(n97), .Y(SUM[4]) );
  NOR2X1 U74 ( .A(n98), .B(n54), .Y(n97) );
  NAND2X1 U75 ( .A(B[7]), .B(A[7]), .Y(n62) );
  NAND2X1 U76 ( .A(A[1]), .B(B[1]), .Y(n113) );
  CLKINVX1 U77 ( .A(n72), .Y(n112) );
  INVX3 U78 ( .A(A[5]), .Y(n91) );
  INVX3 U79 ( .A(A[4]), .Y(n99) );
  NAND2X1 U80 ( .A(B[5]), .B(A[5]), .Y(n66) );
  NAND2X1 U81 ( .A(B[4]), .B(A[4]), .Y(n79) );
  NAND2X1 U82 ( .A(B[5]), .B(A[5]), .Y(n55) );
  CLKINVX1 U83 ( .A(A[6]), .Y(n85) );
  NAND2X1 U84 ( .A(B[1]), .B(A[1]), .Y(n119) );
  NAND2X1 U85 ( .A(B[4]), .B(A[4]), .Y(n92) );
  NAND2X1 U86 ( .A(B[5]), .B(A[5]), .Y(n88) );
  INVX3 U87 ( .A(A[0]), .Y(n124) );
  CLKINVX1 U88 ( .A(B[0]), .Y(n123) );
endmodule


module UDIV8x8_DW01_add_9_3 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123;

  INVX1 U5 ( .A(A[2]), .Y(n115) );
  AND2X2 U6 ( .A(n52), .B(n51), .Y(n49) );
  NAND2X8 U7 ( .A(n49), .B(n53), .Y(n50) );
  OA22X1 U8 ( .A0(n71), .A1(n72), .B0(B[7]), .B1(A[7]), .Y(n51) );
  OA21X1 U9 ( .A0(n65), .A1(n66), .B0(n67), .Y(n52) );
  INVX12 U10 ( .A(n50), .Y(SUM[8]) );
  INVX1 U11 ( .A(n100), .Y(n63) );
  INVX1 U12 ( .A(n104), .Y(n108) );
  INVX1 U13 ( .A(n110), .Y(n106) );
  CLKINVX1 U14 ( .A(n113), .Y(n112) );
  INVX1 U15 ( .A(A[0]), .Y(n123) );
  CLKINVX1 U16 ( .A(n76), .Y(n83) );
  CLKINVX1 U17 ( .A(n70), .Y(n65) );
  INVX1 U18 ( .A(n82), .Y(n68) );
  INVX1 U19 ( .A(A[3]), .Y(n99) );
  INVX1 U20 ( .A(A[4]), .Y(n93) );
  INVX1 U21 ( .A(n91), .Y(n73) );
  OAI21X1 U22 ( .A0(n73), .A1(n87), .B0(n88), .Y(n81) );
  NAND2X1 U23 ( .A(n116), .B(n117), .Y(n114) );
  INVX1 U24 ( .A(n94), .Y(n87) );
  CLKINVX1 U25 ( .A(n66), .Y(n79) );
  INVX1 U26 ( .A(n95), .Y(n58) );
  CLKINVX1 U27 ( .A(n88), .Y(n90) );
  INVX1 U28 ( .A(n69), .Y(n59) );
  OR2X4 U29 ( .A(n54), .B(n55), .Y(n53) );
  NAND2X1 U30 ( .A(B[5]), .B(A[5]), .Y(n76) );
  NAND2X1 U31 ( .A(B[6]), .B(A[6]), .Y(n69) );
  NAND2X1 U32 ( .A(B[7]), .B(A[7]), .Y(n70) );
  NAND2X1 U33 ( .A(n103), .B(n121), .Y(SUM[0]) );
  NAND2X1 U34 ( .A(B[0]), .B(A[0]), .Y(n121) );
  NAND2BX1 U35 ( .AN(B[2]), .B(n115), .Y(n104) );
  NAND2BX1 U36 ( .AN(B[6]), .B(n80), .Y(n66) );
  NAND2BX1 U37 ( .AN(B[5]), .B(n86), .Y(n82) );
  NOR2X1 U38 ( .A(n108), .B(n109), .Y(n107) );
  NAND2X1 U39 ( .A(n118), .B(n119), .Y(n105) );
  CLKINVX1 U40 ( .A(B[1]), .Y(n118) );
  CLKINVX1 U41 ( .A(A[1]), .Y(n119) );
  NAND2X1 U42 ( .A(n75), .B(n76), .Y(n60) );
  NAND2X1 U43 ( .A(n92), .B(n93), .Y(n91) );
  INVX1 U44 ( .A(n97), .Y(n64) );
  NAND2X1 U45 ( .A(n98), .B(n99), .Y(n97) );
  NAND2X1 U46 ( .A(n122), .B(n123), .Y(n103) );
  CLKINVX1 U47 ( .A(n114), .Y(n111) );
  XNOR2X1 U48 ( .A(n77), .B(n78), .Y(SUM[6]) );
  NOR2X1 U49 ( .A(n79), .B(n59), .Y(n78) );
  XNOR2X1 U50 ( .A(n84), .B(n85), .Y(SUM[5]) );
  NOR2X1 U51 ( .A(n83), .B(n68), .Y(n85) );
  INVX1 U52 ( .A(n81), .Y(n84) );
  XNOR2X1 U53 ( .A(n63), .B(n96), .Y(SUM[3]) );
  NOR2X1 U54 ( .A(n58), .B(n64), .Y(n96) );
  OAI22X1 U55 ( .A0(n111), .A1(n112), .B0(n113), .B1(n114), .Y(SUM[2]) );
  XNOR2X1 U56 ( .A(n87), .B(n89), .Y(SUM[4]) );
  NOR2X1 U57 ( .A(n90), .B(n73), .Y(n89) );
  AOI21X1 U58 ( .A0(n81), .A1(n82), .B0(n83), .Y(n77) );
  NAND2X1 U59 ( .A(n101), .B(n102), .Y(n100) );
  NAND3X1 U60 ( .A(n103), .B(n104), .C(n105), .Y(n102) );
  NOR2X1 U61 ( .A(n106), .B(n107), .Y(n101) );
  NOR2X1 U62 ( .A(n63), .B(n64), .Y(n54) );
  NAND2X1 U63 ( .A(n56), .B(n57), .Y(n55) );
  NOR2X1 U64 ( .A(n58), .B(n59), .Y(n57) );
  NOR2X1 U65 ( .A(n60), .B(n61), .Y(n56) );
  CLKINVX1 U66 ( .A(n62), .Y(n61) );
  NAND3X1 U67 ( .A(n68), .B(n69), .C(n70), .Y(n67) );
  NAND2X1 U68 ( .A(n73), .B(n70), .Y(n72) );
  NAND2X1 U69 ( .A(n74), .B(n69), .Y(n71) );
  CLKINVX1 U70 ( .A(n60), .Y(n74) );
  OAI21X1 U71 ( .A0(n63), .A1(n64), .B0(n95), .Y(n94) );
  NAND2X1 U72 ( .A(n104), .B(n110), .Y(n113) );
  NAND2X1 U73 ( .A(n105), .B(n103), .Y(n117) );
  XNOR2X1 U74 ( .A(n120), .B(n103), .Y(SUM[1]) );
  OAI21X1 U75 ( .A0(A[1]), .A1(B[1]), .B0(n116), .Y(n120) );
  NAND2X1 U76 ( .A(A[1]), .B(B[1]), .Y(n109) );
  NAND2X1 U77 ( .A(B[4]), .B(A[4]), .Y(n75) );
  NAND2X1 U78 ( .A(B[7]), .B(A[7]), .Y(n62) );
  NAND2X1 U79 ( .A(B[2]), .B(A[2]), .Y(n110) );
  CLKINVX1 U80 ( .A(B[4]), .Y(n92) );
  CLKINVX1 U81 ( .A(A[6]), .Y(n80) );
  NAND2X1 U82 ( .A(B[3]), .B(A[3]), .Y(n95) );
  INVX1 U83 ( .A(A[5]), .Y(n86) );
  CLKINVX1 U84 ( .A(B[3]), .Y(n98) );
  NAND2X1 U85 ( .A(B[1]), .B(A[1]), .Y(n116) );
  NAND2X1 U86 ( .A(B[4]), .B(A[4]), .Y(n88) );
  CLKINVX1 U87 ( .A(B[0]), .Y(n122) );
endmodule


module UDIV8x8_DW01_add_9_4 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126;

  CLKINVX1 U5 ( .A(A[4]), .Y(n108) );
  NAND2X2 U6 ( .A(n118), .B(n119), .Y(n70) );
  CLKINVX1 U7 ( .A(A[2]), .Y(n119) );
  NAND2X1 U8 ( .A(n125), .B(n126), .Y(n78) );
  AND2X8 U9 ( .A(n49), .B(n50), .Y(SUM[8]) );
  AND4X4 U10 ( .A(n51), .B(n52), .C(n53), .D(n54), .Y(n50) );
  INVX1 U11 ( .A(n99), .Y(n80) );
  CLKINVX1 U12 ( .A(B[2]), .Y(n118) );
  NAND2BX1 U13 ( .AN(B[1]), .B(n122), .Y(n79) );
  INVX1 U14 ( .A(n59), .Y(n81) );
  OR3X2 U15 ( .A(n65), .B(n66), .C(n67), .Y(n49) );
  NAND2X1 U16 ( .A(B[6]), .B(A[6]), .Y(n59) );
  NAND4X1 U17 ( .A(n59), .B(n62), .C(n63), .D(n56), .Y(n51) );
  NAND3X1 U18 ( .A(n78), .B(n79), .C(n70), .Y(n102) );
  NAND3X1 U19 ( .A(n58), .B(n59), .C(n56), .Y(n53) );
  NAND3X1 U20 ( .A(n75), .B(n76), .C(n77), .Y(n65) );
  NAND2X1 U21 ( .A(n82), .B(n71), .Y(n75) );
  NOR2X1 U22 ( .A(n80), .B(n81), .Y(n76) );
  NAND4X1 U23 ( .A(n78), .B(n70), .C(n79), .D(n71), .Y(n77) );
  NAND2X1 U24 ( .A(B[2]), .B(A[2]), .Y(n83) );
  NAND2BX1 U25 ( .AN(B[6]), .B(n87), .Y(n57) );
  NAND2X1 U26 ( .A(n120), .B(n121), .Y(n117) );
  NAND2X1 U27 ( .A(n55), .B(n56), .Y(n54) );
  INVX1 U28 ( .A(n116), .Y(n115) );
  NAND2X1 U29 ( .A(B[3]), .B(A[3]), .Y(n99) );
  NAND2X1 U30 ( .A(B[7]), .B(A[7]), .Y(n56) );
  INVX1 U31 ( .A(n92), .Y(n58) );
  NAND2X1 U32 ( .A(n93), .B(n94), .Y(n92) );
  INVX1 U33 ( .A(A[5]), .Y(n94) );
  NAND2X1 U34 ( .A(B[5]), .B(A[5]), .Y(n62) );
  NAND3X1 U35 ( .A(n72), .B(n73), .C(n74), .Y(n66) );
  NOR2X1 U36 ( .A(n68), .B(n69), .Y(n67) );
  NAND2BX1 U37 ( .AN(B[4]), .B(n108), .Y(n64) );
  NAND2X1 U38 ( .A(n70), .B(n83), .Y(n116) );
  CLKINVX1 U39 ( .A(n83), .Y(n82) );
  CLKINVX1 U40 ( .A(n117), .Y(n114) );
  CLKINVX1 U41 ( .A(n57), .Y(n86) );
  NAND2X1 U42 ( .A(n60), .B(n61), .Y(n52) );
  AOI21X1 U43 ( .A0(n95), .A1(n96), .B0(n97), .Y(n90) );
  OAI21X1 U44 ( .A0(n98), .A1(n99), .B0(n100), .Y(n97) );
  NOR2X1 U45 ( .A(n103), .B(n104), .Y(n95) );
  NAND3X1 U46 ( .A(n101), .B(n83), .C(n102), .Y(n96) );
  NAND2X1 U47 ( .A(n78), .B(n124), .Y(SUM[0]) );
  NAND2X1 U48 ( .A(B[0]), .B(A[0]), .Y(n124) );
  INVX1 U49 ( .A(n64), .Y(n63) );
  NAND3X1 U50 ( .A(n101), .B(n83), .C(n102), .Y(n109) );
  CLKINVX1 U51 ( .A(A[6]), .Y(n87) );
  AOI21X1 U52 ( .A0(n109), .A1(n71), .B0(n80), .Y(n105) );
  NAND2X1 U53 ( .A(n79), .B(n78), .Y(n121) );
  INVX1 U54 ( .A(n57), .Y(n55) );
  NOR2X1 U55 ( .A(n88), .B(n89), .Y(n84) );
  NOR2X1 U56 ( .A(n58), .B(n90), .Y(n89) );
  NAND2X1 U57 ( .A(n71), .B(n99), .Y(n110) );
  CLKINVX1 U58 ( .A(n62), .Y(n88) );
  CLKINVX1 U59 ( .A(n64), .Y(n98) );
  CLKINVX1 U60 ( .A(n71), .Y(n104) );
  CLKINVX1 U61 ( .A(n64), .Y(n103) );
  CLKINVX1 U62 ( .A(n100), .Y(n107) );
  CLKINVX1 U63 ( .A(B[0]), .Y(n125) );
  INVX3 U64 ( .A(A[0]), .Y(n126) );
  CLKINVX1 U65 ( .A(B[7]), .Y(n61) );
  OAI22X1 U66 ( .A0(n114), .A1(n115), .B0(n116), .B1(n117), .Y(SUM[2]) );
  XNOR2X1 U67 ( .A(n90), .B(n91), .Y(SUM[5]) );
  NOR2X1 U68 ( .A(n88), .B(n58), .Y(n91) );
  XNOR2X1 U69 ( .A(n84), .B(n85), .Y(SUM[6]) );
  NOR2X1 U70 ( .A(n81), .B(n86), .Y(n85) );
  CLKINVX1 U71 ( .A(B[3]), .Y(n112) );
  INVX3 U72 ( .A(A[3]), .Y(n113) );
  XNOR2X1 U73 ( .A(n105), .B(n106), .Y(SUM[4]) );
  NOR2X1 U74 ( .A(n98), .B(n107), .Y(n106) );
  OAI21X1 U75 ( .A0(n109), .A1(n110), .B0(n111), .Y(SUM[3]) );
  NAND2X1 U76 ( .A(n109), .B(n110), .Y(n111) );
  XNOR2X1 U77 ( .A(n123), .B(n78), .Y(SUM[1]) );
  OAI21X1 U78 ( .A0(A[1]), .A1(B[1]), .B0(n120), .Y(n123) );
  INVX3 U79 ( .A(A[1]), .Y(n122) );
  NAND3X1 U80 ( .A(A[1]), .B(B[1]), .C(n70), .Y(n101) );
  CLKINVX1 U81 ( .A(B[5]), .Y(n93) );
  NAND2X1 U82 ( .A(B[4]), .B(A[4]), .Y(n72) );
  NAND2X1 U83 ( .A(B[5]), .B(A[5]), .Y(n73) );
  NAND2X1 U84 ( .A(B[7]), .B(A[7]), .Y(n74) );
  NAND2X1 U85 ( .A(B[1]), .B(A[1]), .Y(n120) );
  NAND2X1 U86 ( .A(B[1]), .B(A[1]), .Y(n69) );
  NAND2X1 U87 ( .A(n70), .B(n71), .Y(n68) );
  CLKINVX1 U88 ( .A(A[7]), .Y(n60) );
  NAND2X1 U89 ( .A(B[4]), .B(A[4]), .Y(n100) );
  NAND2X8 U90 ( .A(n112), .B(n113), .Y(n71) );
endmodule


module UDIV8x8_DW01_add_9_2 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125;

  INVX1 U5 ( .A(A[4]), .Y(n100) );
  INVX12 U6 ( .A(n52), .Y(SUM[8]) );
  AND2X6 U7 ( .A(n55), .B(n54), .Y(n49) );
  OR4X4 U8 ( .A(n62), .B(n56), .C(n65), .D(n50), .Y(n53) );
  CLKINVX1 U9 ( .A(n66), .Y(n50) );
  OAI2BB1X1 U10 ( .A0N(n60), .A1N(n61), .B0(n51), .Y(n54) );
  CLKINVX1 U11 ( .A(n56), .Y(n51) );
  NAND2X6 U12 ( .A(n53), .B(n49), .Y(n52) );
  OA22X2 U13 ( .A0(n56), .A1(n57), .B0(B[7]), .B1(A[7]), .Y(n55) );
  INVX3 U14 ( .A(A[1]), .Y(n75) );
  CLKINVX1 U15 ( .A(n96), .Y(n58) );
  CLKINVX1 U16 ( .A(A[5]), .Y(n92) );
  NAND2X1 U17 ( .A(n63), .B(n64), .Y(n56) );
  CLKINVX1 U18 ( .A(A[3]), .Y(n107) );
  CLKINVX1 U19 ( .A(n93), .Y(n99) );
  NAND2X1 U20 ( .A(n106), .B(n107), .Y(n73) );
  CLKINVX1 U21 ( .A(n95), .Y(n97) );
  NAND2X1 U22 ( .A(n93), .B(n94), .Y(n86) );
  INVX1 U23 ( .A(n73), .Y(n67) );
  INVX1 U24 ( .A(n64), .Y(n83) );
  CLKINVX1 U25 ( .A(n102), .Y(n103) );
  OAI22X1 U26 ( .A0(n115), .A1(n116), .B0(n117), .B1(n118), .Y(SUM[2]) );
  CLKINVX1 U27 ( .A(n117), .Y(n116) );
  NAND2X1 U28 ( .A(B[6]), .B(A[6]), .Y(n64) );
  NAND2X1 U29 ( .A(B[2]), .B(A[2]), .Y(n68) );
  NAND2BX2 U30 ( .AN(B[2]), .B(n119), .Y(n72) );
  NAND2X1 U31 ( .A(n80), .B(n101), .Y(n95) );
  NAND2BX1 U32 ( .AN(B[4]), .B(n100), .Y(n96) );
  NAND2BX1 U33 ( .AN(B[6]), .B(n85), .Y(n60) );
  NAND2X1 U34 ( .A(n91), .B(n92), .Y(n61) );
  CLKINVX1 U35 ( .A(B[5]), .Y(n91) );
  NAND2X1 U36 ( .A(B[7]), .B(A[7]), .Y(n63) );
  NAND2X1 U37 ( .A(n58), .B(n59), .Y(n57) );
  CLKINVX1 U38 ( .A(n118), .Y(n115) );
  CLKINVX1 U39 ( .A(B[1]), .Y(n76) );
  NAND2X1 U40 ( .A(n108), .B(n109), .Y(n102) );
  NAND3BX1 U41 ( .AN(n69), .B(n70), .C(n71), .Y(n62) );
  NAND2X1 U42 ( .A(n120), .B(n121), .Y(n118) );
  NAND2X1 U43 ( .A(n124), .B(n125), .Y(n78) );
  XNOR2X1 U44 ( .A(n97), .B(n98), .Y(SUM[4]) );
  NOR2X1 U45 ( .A(n99), .B(n58), .Y(n98) );
  OAI21X1 U46 ( .A0(n86), .A1(n89), .B0(n90), .Y(SUM[5]) );
  NAND2X1 U47 ( .A(n86), .B(n89), .Y(n90) );
  NAND2X1 U48 ( .A(n61), .B(n88), .Y(n89) );
  XNOR2X1 U49 ( .A(n81), .B(n82), .Y(SUM[6]) );
  NOR2X1 U50 ( .A(n83), .B(n84), .Y(n82) );
  AOI21X1 U51 ( .A0(n86), .A1(n61), .B0(n87), .Y(n81) );
  NOR2X1 U52 ( .A(n67), .B(n68), .Y(n65) );
  NAND2X1 U53 ( .A(n95), .B(n96), .Y(n94) );
  NAND2X1 U54 ( .A(n76), .B(n75), .Y(n110) );
  NAND2X1 U55 ( .A(n76), .B(n75), .Y(n77) );
  NOR2X1 U56 ( .A(n75), .B(n76), .Y(n74) );
  CLKINVX1 U57 ( .A(n80), .Y(n105) );
  INVX1 U58 ( .A(n60), .Y(n84) );
  INVX1 U59 ( .A(n88), .Y(n87) );
  NAND2X1 U60 ( .A(n68), .B(n72), .Y(n117) );
  XNOR2X1 U61 ( .A(n103), .B(n104), .Y(SUM[3]) );
  NOR2X1 U62 ( .A(n105), .B(n67), .Y(n104) );
  CLKINVX3 U63 ( .A(A[2]), .Y(n119) );
  CLKINVX1 U64 ( .A(B[3]), .Y(n106) );
  NAND2X1 U65 ( .A(B[3]), .B(A[3]), .Y(n80) );
  NOR2X1 U66 ( .A(n113), .B(n114), .Y(n112) );
  NAND2X1 U67 ( .A(A[1]), .B(B[1]), .Y(n114) );
  CLKINVX1 U68 ( .A(n72), .Y(n113) );
  NAND2X1 U69 ( .A(B[5]), .B(A[5]), .Y(n66) );
  NAND2X1 U70 ( .A(n102), .B(n73), .Y(n101) );
  NAND2X1 U71 ( .A(B[4]), .B(A[4]), .Y(n79) );
  NAND2X1 U72 ( .A(B[5]), .B(A[5]), .Y(n59) );
  CLKINVX1 U73 ( .A(A[6]), .Y(n85) );
  NAND2X1 U74 ( .A(B[1]), .B(A[1]), .Y(n120) );
  NAND2X1 U75 ( .A(B[4]), .B(A[4]), .Y(n93) );
  NAND2X1 U76 ( .A(B[5]), .B(A[5]), .Y(n88) );
  XNOR2X1 U77 ( .A(n122), .B(n78), .Y(SUM[1]) );
  OAI21X1 U78 ( .A0(A[1]), .A1(B[1]), .B0(n120), .Y(n122) );
  NAND2X1 U79 ( .A(n79), .B(n80), .Y(n69) );
  NAND3X1 U80 ( .A(n72), .B(n73), .C(n74), .Y(n71) );
  NAND4X1 U81 ( .A(n77), .B(n78), .C(n72), .D(n73), .Y(n70) );
  NAND3X1 U82 ( .A(n78), .B(n110), .C(n72), .Y(n109) );
  NOR2X1 U83 ( .A(n111), .B(n112), .Y(n108) );
  CLKINVX1 U84 ( .A(n68), .Y(n111) );
  NAND2X1 U85 ( .A(n110), .B(n78), .Y(n121) );
  NAND2X1 U86 ( .A(n78), .B(n123), .Y(SUM[0]) );
  NAND2X1 U87 ( .A(B[0]), .B(A[0]), .Y(n123) );
  CLKINVX1 U88 ( .A(A[0]), .Y(n125) );
  CLKINVX1 U89 ( .A(B[0]), .Y(n124) );
endmodule


module UDIV8x8_DW01_add_9_6 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128, n129, n130, n131, n132, n133, n134, n135, n136;

  NAND2X8 U5 ( .A(n59), .B(n58), .Y(n57) );
  NAND2X2 U6 ( .A(n116), .B(n117), .Y(n101) );
  NOR2X1 U7 ( .A(n119), .B(n120), .Y(n116) );
  INVX1 U8 ( .A(n79), .Y(n73) );
  NAND2X2 U9 ( .A(B[7]), .B(A[7]), .Y(n62) );
  NAND2X1 U10 ( .A(n73), .B(n62), .Y(n71) );
  CLKAND2X2 U11 ( .A(n61), .B(n60), .Y(n49) );
  NAND3X2 U12 ( .A(n63), .B(n62), .C(n49), .Y(n50) );
  INVX3 U13 ( .A(n50), .Y(n56) );
  AOI211X1 U14 ( .A0(n53), .A1(n54), .B0(n67), .C0(n51), .Y(n52) );
  CLKINVX1 U15 ( .A(n66), .Y(n51) );
  INVX1 U16 ( .A(n52), .Y(n55) );
  AND2X4 U17 ( .A(n71), .B(n72), .Y(n58) );
  OAI21X1 U18 ( .A0(A[1]), .A1(B[1]), .B0(n136), .Y(n53) );
  AOI21X1 U19 ( .A0(B[1]), .A1(A[1]), .B0(n68), .Y(n54) );
  NAND2X4 U20 ( .A(n56), .B(n55), .Y(n59) );
  NAND2X1 U21 ( .A(n64), .B(n65), .Y(n63) );
  INVX12 U22 ( .A(n57), .Y(SUM[8]) );
  CLKINVX1 U23 ( .A(A[3]), .Y(n103) );
  INVX1 U24 ( .A(A[6]), .Y(n84) );
  CLKINVX1 U25 ( .A(n125), .Y(n124) );
  CLKINVX1 U26 ( .A(A[2]), .Y(n128) );
  NAND2X1 U27 ( .A(n127), .B(n128), .Y(n66) );
  NAND2X1 U28 ( .A(n83), .B(n84), .Y(n79) );
  CLKINVX1 U29 ( .A(A[0]), .Y(n135) );
  INVX1 U30 ( .A(n88), .Y(n64) );
  CLKINVX1 U31 ( .A(n78), .Y(n81) );
  NAND2X1 U32 ( .A(n96), .B(n97), .Y(n98) );
  INVX1 U33 ( .A(n112), .Y(n115) );
  NAND3X1 U34 ( .A(n91), .B(n92), .C(n93), .Y(n67) );
  NAND2X1 U35 ( .A(n104), .B(n105), .Y(n92) );
  NAND2X1 U36 ( .A(n104), .B(n105), .Y(n89) );
  NAND2X1 U37 ( .A(n102), .B(n103), .Y(n91) );
  NAND2X1 U38 ( .A(n94), .B(n95), .Y(n90) );
  INVX1 U39 ( .A(n69), .Y(n68) );
  NAND2X1 U40 ( .A(n99), .B(n100), .Y(n97) );
  NAND2X1 U41 ( .A(n129), .B(n130), .Y(n126) );
  NAND2X1 U42 ( .A(n118), .B(n136), .Y(n130) );
  NAND2X1 U43 ( .A(B[5]), .B(A[5]), .Y(n61) );
  NAND2X1 U44 ( .A(B[6]), .B(A[6]), .Y(n60) );
  NAND2BX1 U45 ( .AN(B[7]), .B(n77), .Y(n72) );
  NAND2X1 U46 ( .A(B[4]), .B(A[4]), .Y(n106) );
  NAND2X1 U47 ( .A(B[3]), .B(A[3]), .Y(n107) );
  NAND2X1 U48 ( .A(B[2]), .B(A[2]), .Y(n69) );
  NOR2X1 U49 ( .A(n121), .B(n122), .Y(n120) );
  NAND2BX1 U50 ( .AN(B[1]), .B(n131), .Y(n118) );
  BUFX3 U51 ( .A(n70), .Y(n136) );
  NAND2X1 U52 ( .A(n134), .B(n135), .Y(n70) );
  CLKINVX1 U53 ( .A(A[5]), .Y(n95) );
  NAND2X1 U54 ( .A(n89), .B(n90), .Y(n88) );
  CLKINVX1 U55 ( .A(A[4]), .Y(n105) );
  NOR2X1 U56 ( .A(n80), .B(n73), .Y(n82) );
  NOR2X1 U57 ( .A(n113), .B(n115), .Y(n114) );
  OAI21X1 U58 ( .A0(n96), .A1(n97), .B0(n98), .Y(SUM[5]) );
  XNOR2X1 U59 ( .A(n81), .B(n82), .Y(SUM[6]) );
  CLKINVX1 U60 ( .A(n126), .Y(n123) );
  NAND2X1 U61 ( .A(n94), .B(n95), .Y(n93) );
  NAND2X1 U62 ( .A(n106), .B(n107), .Y(n65) );
  OAI21X1 U63 ( .A0(n85), .A1(n67), .B0(n86), .Y(n78) );
  AOI21X1 U64 ( .A0(n64), .A1(n65), .B0(n87), .Y(n86) );
  CLKINVX1 U65 ( .A(n61), .Y(n87) );
  NAND2X1 U66 ( .A(n69), .B(n66), .Y(n125) );
  AOI21X1 U67 ( .A0(n78), .A1(n79), .B0(n80), .Y(n74) );
  AOI21X1 U68 ( .A0(n101), .A1(n112), .B0(n113), .Y(n108) );
  NAND2X1 U69 ( .A(n90), .B(n61), .Y(n96) );
  NAND2X1 U70 ( .A(n89), .B(n65), .Y(n99) );
  NAND3X1 U71 ( .A(n92), .B(n91), .C(n101), .Y(n100) );
  NAND2X1 U72 ( .A(n102), .B(n103), .Y(n112) );
  NOR2X1 U73 ( .A(n110), .B(n111), .Y(n109) );
  CLKINVX1 U74 ( .A(n106), .Y(n111) );
  CLKINVX1 U75 ( .A(n89), .Y(n110) );
  CLKINVX1 U76 ( .A(n60), .Y(n80) );
  CLKINVX1 U77 ( .A(n107), .Y(n113) );
  INVX3 U78 ( .A(n101), .Y(n85) );
  XNOR2X1 U79 ( .A(n108), .B(n109), .Y(SUM[4]) );
  XNOR2X1 U80 ( .A(n74), .B(n75), .Y(SUM[7]) );
  XNOR2X1 U81 ( .A(n85), .B(n114), .Y(SUM[3]) );
  CLKINVX1 U82 ( .A(B[2]), .Y(n127) );
  CLKINVX1 U83 ( .A(A[7]), .Y(n77) );
  CLKINVX1 U84 ( .A(B[6]), .Y(n83) );
  NAND3X1 U85 ( .A(n70), .B(n66), .C(n118), .Y(n117) );
  CLKINVX1 U86 ( .A(n69), .Y(n119) );
  OAI21X1 U87 ( .A0(A[1]), .A1(B[1]), .B0(n129), .Y(n132) );
  NAND2X1 U88 ( .A(A[1]), .B(B[1]), .Y(n122) );
  CLKINVX1 U89 ( .A(n66), .Y(n121) );
  NAND2X1 U90 ( .A(B[1]), .B(A[1]), .Y(n129) );
  CLKINVX1 U91 ( .A(A[1]), .Y(n131) );
  OAI22X1 U92 ( .A0(n123), .A1(n124), .B0(n125), .B1(n126), .Y(SUM[2]) );
  AOI21X1 U93 ( .A0(B[7]), .A1(A[7]), .B0(n76), .Y(n75) );
  CLKINVX1 U94 ( .A(n72), .Y(n76) );
  CLKINVX1 U95 ( .A(B[4]), .Y(n104) );
  CLKINVX1 U96 ( .A(B[5]), .Y(n94) );
  CLKINVX1 U97 ( .A(B[3]), .Y(n102) );
  XNOR2X1 U98 ( .A(n132), .B(n136), .Y(SUM[1]) );
  CLKINVX1 U99 ( .A(B[0]), .Y(n134) );
  NAND2X1 U100 ( .A(n136), .B(n133), .Y(SUM[0]) );
  NAND2X1 U101 ( .A(B[0]), .B(A[0]), .Y(n133) );
endmodule


module UDIV8x8_DW01_add_9_7 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103,
         n104, n105, n106, n107, n108, n109, n110, n111, n112, n113, n114,
         n115, n116, n117, n118, n119, n120, n121, n122, n123, n124, n125,
         n126, n127, n128;

  AND4X6 U5 ( .A(n52), .B(n53), .C(n54), .D(n55), .Y(n51) );
  NAND2X4 U6 ( .A(n114), .B(n115), .Y(n76) );
  INVX1 U7 ( .A(A[3]), .Y(n115) );
  NAND2X1 U8 ( .A(n123), .B(n124), .Y(n75) );
  INVX1 U9 ( .A(A[2]), .Y(n124) );
  NOR2X1 U10 ( .A(n73), .B(n74), .Y(n67) );
  INVX1 U11 ( .A(n75), .Y(n74) );
  INVX1 U12 ( .A(B[1]), .Y(n111) );
  NAND2BX4 U13 ( .AN(n49), .B(n51), .Y(n50) );
  AOI21X1 U14 ( .A0(n66), .A1(n67), .B0(n68), .Y(n49) );
  INVX8 U15 ( .A(n50), .Y(SUM[8]) );
  INVX1 U16 ( .A(n98), .Y(n64) );
  INVX3 U17 ( .A(n76), .Y(n73) );
  INVX1 U18 ( .A(n90), .Y(n59) );
  INVX1 U19 ( .A(A[4]), .Y(n105) );
  NAND2BX1 U20 ( .AN(n119), .B(n117), .Y(n118) );
  CLKINVX1 U21 ( .A(n71), .Y(n91) );
  CLKINVX1 U22 ( .A(n96), .Y(n103) );
  NAND2X1 U23 ( .A(B[7]), .B(A[7]), .Y(n57) );
  NAND2X1 U24 ( .A(B[6]), .B(A[6]), .Y(n60) );
  NAND2X1 U25 ( .A(B[3]), .B(A[3]), .Y(n70) );
  NAND2X1 U26 ( .A(B[2]), .B(A[2]), .Y(n78) );
  NAND2X1 U27 ( .A(n127), .B(n128), .Y(n81) );
  CLKINVX1 U28 ( .A(n89), .Y(n92) );
  NAND4X1 U29 ( .A(n63), .B(n60), .C(n64), .D(n57), .Y(n52) );
  CLKINVX1 U30 ( .A(n65), .Y(n63) );
  NAND4X1 U31 ( .A(n57), .B(n69), .C(n60), .D(n70), .Y(n68) );
  CLKINVX1 U32 ( .A(n65), .Y(n69) );
  NAND3X1 U33 ( .A(n59), .B(n60), .C(n57), .Y(n54) );
  NAND3X1 U34 ( .A(n95), .B(n96), .C(n97), .Y(n89) );
  NAND3X1 U35 ( .A(n108), .B(n78), .C(n109), .Y(n99) );
  NAND2X1 U36 ( .A(n110), .B(n75), .Y(n109) );
  NAND3X1 U37 ( .A(n81), .B(n113), .C(n75), .Y(n108) );
  NAND2X1 U38 ( .A(n56), .B(n57), .Y(n55) );
  CLKINVX1 U39 ( .A(n58), .Y(n56) );
  CLKINVX1 U40 ( .A(A[1]), .Y(n112) );
  OAI21X1 U41 ( .A0(n120), .A1(n121), .B0(n122), .Y(n117) );
  NAND3X1 U42 ( .A(n77), .B(n78), .C(n79), .Y(n66) );
  NAND2X1 U43 ( .A(B[5]), .B(A[5]), .Y(n71) );
  NAND2X1 U44 ( .A(n104), .B(n105), .Y(n98) );
  NAND2X1 U45 ( .A(n61), .B(n62), .Y(n53) );
  NAND2X1 U46 ( .A(n71), .B(n72), .Y(n65) );
  NAND2BX1 U47 ( .AN(B[5]), .B(n94), .Y(n90) );
  NAND2X1 U48 ( .A(n87), .B(n88), .Y(n58) );
  CLKINVX1 U49 ( .A(A[6]), .Y(n88) );
  CLKINVX1 U50 ( .A(B[3]), .Y(n114) );
  CLKINVX1 U51 ( .A(A[0]), .Y(n128) );
  XNOR2X1 U52 ( .A(n83), .B(n84), .Y(SUM[6]) );
  NOR2X1 U53 ( .A(n85), .B(n86), .Y(n84) );
  XNOR2X1 U54 ( .A(n101), .B(n102), .Y(SUM[4]) );
  NOR2X1 U55 ( .A(n64), .B(n103), .Y(n102) );
  XNOR2X1 U56 ( .A(n92), .B(n93), .Y(SUM[5]) );
  NOR2X1 U57 ( .A(n91), .B(n59), .Y(n93) );
  CLKINVX1 U58 ( .A(n116), .Y(n119) );
  XNOR2X1 U59 ( .A(n107), .B(n99), .Y(SUM[3]) );
  NAND2X1 U60 ( .A(n76), .B(n70), .Y(n107) );
  OAI21X1 U61 ( .A0(n116), .A1(n117), .B0(n118), .Y(SUM[2]) );
  NAND2X1 U62 ( .A(n100), .B(n98), .Y(n95) );
  NAND3X1 U63 ( .A(n76), .B(n98), .C(n99), .Y(n97) );
  CLKINVX1 U64 ( .A(n70), .Y(n100) );
  NOR2X1 U65 ( .A(n111), .B(n112), .Y(n110) );
  NAND2X1 U66 ( .A(n75), .B(n78), .Y(n116) );
  AOI21X1 U67 ( .A0(n76), .A1(n99), .B0(n106), .Y(n101) );
  CLKINVX1 U68 ( .A(n70), .Y(n106) );
  AOI21X1 U69 ( .A0(n89), .A1(n90), .B0(n91), .Y(n83) );
  NAND2X1 U70 ( .A(n111), .B(n112), .Y(n113) );
  CLKINVX1 U71 ( .A(A[1]), .Y(n82) );
  CLKINVX1 U72 ( .A(n60), .Y(n85) );
  CLKINVX1 U73 ( .A(n58), .Y(n86) );
  NAND2X1 U74 ( .A(n81), .B(n126), .Y(SUM[0]) );
  NAND2X1 U75 ( .A(B[0]), .B(A[0]), .Y(n126) );
  CLKINVX1 U76 ( .A(n81), .Y(n121) );
  NOR2X1 U77 ( .A(A[1]), .B(B[1]), .Y(n120) );
  CLKINVX1 U78 ( .A(B[2]), .Y(n123) );
  NAND2X1 U79 ( .A(B[4]), .B(A[4]), .Y(n72) );
  XNOR2X1 U80 ( .A(n125), .B(n81), .Y(SUM[1]) );
  OAI21X1 U81 ( .A0(A[1]), .A1(B[1]), .B0(n122), .Y(n125) );
  CLKINVX1 U82 ( .A(B[4]), .Y(n104) );
  CLKINVX1 U83 ( .A(B[6]), .Y(n87) );
  NAND2X1 U84 ( .A(B[1]), .B(A[1]), .Y(n122) );
  INVX1 U85 ( .A(A[5]), .Y(n94) );
  NAND2X1 U86 ( .A(B[1]), .B(A[1]), .Y(n79) );
  NAND2X1 U87 ( .A(n80), .B(n81), .Y(n77) );
  NAND2X1 U88 ( .A(n111), .B(n82), .Y(n80) );
  CLKINVX1 U89 ( .A(B[7]), .Y(n62) );
  CLKINVX1 U90 ( .A(A[7]), .Y(n61) );
  NAND2X1 U91 ( .A(B[4]), .B(A[4]), .Y(n96) );
  CLKINVX1 U92 ( .A(B[0]), .Y(n127) );
endmodule


module da ( d, ac, cy, q );
  input [7:0] d;
  output [7:0] q;
  input ac, cy;
  wire   d_0_, N12, N13, N14, N24, N25, N26, n38, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, add_14_carry_7_,
         add_12_carry_4_, n101, n102, n103;
  assign q[0] = d_0_;
  assign d_0_ = d[0];

  NAND2X2 U36 ( .A(N12), .B(n64), .Y(n98) );
  NAND2X1 U37 ( .A(n88), .B(n89), .Y(n50) );
  AND3X1 U38 ( .A(n84), .B(n81), .C(n82), .Y(n43) );
  CLKINVX1 U39 ( .A(n61), .Y(n47) );
  NAND2BX1 U40 ( .AN(n91), .B(n86), .Y(n45) );
  NOR2BX1 U41 ( .AN(n63), .B(d[3]), .Y(n62) );
  INVX1 U42 ( .A(n81), .Y(add_12_carry_4_) );
  NAND2BX1 U43 ( .AN(n83), .B(n50), .Y(n49) );
  OAI21X1 U44 ( .A0(n61), .A1(n64), .B0(n65), .Y(q[2]) );
  NAND3BX1 U45 ( .AN(n56), .B(n81), .C(n82), .Y(n74) );
  AND2X2 U46 ( .A(n73), .B(n72), .Y(n44) );
  NAND2X1 U47 ( .A(n98), .B(n100), .Y(N13) );
  NAND2X1 U48 ( .A(n88), .B(n72), .Y(n56) );
  NAND2X1 U49 ( .A(n72), .B(N24), .Y(n71) );
  XNOR2X1 U50 ( .A(add_14_carry_7_), .B(n73), .Y(N26) );
  CLKINVX1 U51 ( .A(d[7]), .Y(n73) );
  NOR2X1 U52 ( .A(n78), .B(n80), .Y(n94) );
  NAND2X1 U53 ( .A(N24), .B(n85), .Y(add_14_carry_7_) );
  NOR2X1 U54 ( .A(n62), .B(add_12_carry_4_), .Y(q[3]) );
  NAND3X1 U55 ( .A(n58), .B(n59), .C(n60), .Y(q[4]) );
  XNOR2X1 U56 ( .A(n103), .B(n73), .Y(n91) );
  NAND3X1 U57 ( .A(n92), .B(n98), .C(n93), .Y(n103) );
  NOR2X1 U58 ( .A(N24), .B(n78), .Y(n92) );
  NOR2X1 U59 ( .A(n80), .B(n85), .Y(n93) );
  CLKINVX1 U60 ( .A(d[4]), .Y(n80) );
  CLKINVX1 U61 ( .A(d[5]), .Y(N24) );
  CLKINVX1 U62 ( .A(d[2]), .Y(n64) );
  CLKINVX1 U63 ( .A(d[3]), .Y(n78) );
  CLKINVX1 U64 ( .A(d[6]), .Y(n85) );
  NAND3X1 U65 ( .A(n77), .B(n81), .C(n82), .Y(n67) );
  NOR2X1 U66 ( .A(n56), .B(n64), .Y(n77) );
  NOR2X1 U67 ( .A(n56), .B(n85), .Y(n84) );
  AOI21X1 U68 ( .A0(n47), .A1(N25), .B0(n43), .Y(n48) );
  NAND2X1 U69 ( .A(add_14_carry_7_), .B(n90), .Y(N25) );
  NAND2X1 U70 ( .A(d[6]), .B(d[5]), .Y(n90) );
  AND2X2 U71 ( .A(n67), .B(n66), .Y(n65) );
  NAND2X1 U72 ( .A(N13), .B(n50), .Y(n66) );
  NAND3X1 U73 ( .A(n79), .B(n81), .C(n82), .Y(n59) );
  NOR2X1 U74 ( .A(n56), .B(n80), .Y(n79) );
  NAND2X1 U75 ( .A(d[4]), .B(n47), .Y(n60) );
  OAI21X1 U76 ( .A0(n87), .A1(n56), .B0(n51), .Y(n86) );
  CLKINVX1 U77 ( .A(n82), .Y(n87) );
  NAND2X1 U78 ( .A(n45), .B(n46), .Y(q[7]) );
  NAND2X1 U79 ( .A(n47), .B(N26), .Y(n46) );
  XNOR2X1 U80 ( .A(n102), .B(n85), .Y(n83) );
  NAND2X1 U81 ( .A(n94), .B(n95), .Y(n102) );
  XNOR2X1 U82 ( .A(n101), .B(N24), .Y(n52) );
  NAND2X1 U83 ( .A(n97), .B(n98), .Y(n101) );
  NOR2X1 U84 ( .A(n80), .B(n78), .Y(n97) );
  CLKINVX1 U85 ( .A(n50), .Y(n51) );
  NAND2X1 U86 ( .A(N14), .B(n50), .Y(n63) );
  XNOR2X1 U87 ( .A(n98), .B(n78), .Y(N14) );
  NAND2BX1 U88 ( .AN(n99), .B(n50), .Y(n58) );
  XNOR2X1 U89 ( .A(n89), .B(n80), .Y(n99) );
  CLKINVX1 U90 ( .A(d_0_), .Y(n75) );
  OAI21X1 U91 ( .A0(N12), .A1(n61), .B0(n68), .Y(q[1]) );
  OAI21X1 U92 ( .A0(n51), .A1(n52), .B0(n53), .Y(q[5]) );
  NAND2X1 U93 ( .A(n48), .B(n49), .Y(q[6]) );
  OAI21X1 U94 ( .A0(d[2]), .A1(d[1]), .B0(d[3]), .Y(n81) );
  OAI21X1 U95 ( .A0(d[6]), .A1(d[5]), .B0(d[7]), .Y(n82) );
  MXI2X1 U96 ( .S0(d[1]), .B(n76), .A(n50), .Y(n68) );
  INVX1 U97 ( .A(n74), .Y(n76) );
  OAI21X1 U98 ( .A0(d[2]), .A1(d[1]), .B0(d[3]), .Y(n89) );
  NOR2X1 U99 ( .A(N24), .B(n96), .Y(n95) );
  NOR2X1 U100 ( .A(d[2]), .B(d[1]), .Y(n96) );
  CLKINVX1 U101 ( .A(d[1]), .Y(N12) );
  NAND2X1 U102 ( .A(d[2]), .B(d[1]), .Y(n100) );
  OAI22X1 U103 ( .A0(n69), .A1(n70), .B0(d[6]), .B1(n71), .Y(n61) );
  NOR3X1 U104 ( .A(n44), .B(d[3]), .C(ac), .Y(n70) );
  NOR3X1 U105 ( .A(n98), .B(ac), .C(n44), .Y(n69) );
  MXI2X1 U106 ( .S0(d[5]), .B(n55), .A(n54), .Y(n53) );
  NOR3X1 U107 ( .A(add_12_carry_4_), .B(d[7]), .C(n56), .Y(n55) );
  NOR3X1 U108 ( .A(n57), .B(ac), .C(add_12_carry_4_), .Y(n54) );
  OAI22X1 U109 ( .A0(d[6]), .A1(cy), .B0(cy), .B1(d[7]), .Y(n57) );
  CLKINVX1 U110 ( .A(cy), .Y(n72) );
  CLKINVX1 U111 ( .A(ac), .Y(n88) );
  AOI21X4 U112 ( .A0(n51), .A1(n74), .B0(n75), .Y(n38) );
endmodule


module rl ( d, q );
  input [7:0] d;
  output [7:0] q;
  wire   \q[1] , n1, n3, n5, n7, n9, n11, n13;
  assign q[1] = \q[1] ;
  assign \q[1]  = d[0];

  INVX1 U1 ( .A(n13), .Y(q[7]) );
  INVX1 U2 ( .A(n11), .Y(q[6]) );
  INVX1 U3 ( .A(n9), .Y(q[5]) );
  INVX1 U4 ( .A(n7), .Y(q[4]) );
  INVX1 U5 ( .A(n1), .Y(q[0]) );
  CLKINVX1 U6 ( .A(d[7]), .Y(n1) );
  CLKINVX1 U7 ( .A(n5), .Y(q[3]) );
  CLKINVX1 U8 ( .A(d[5]), .Y(n11) );
  CLKINVX1 U9 ( .A(d[2]), .Y(n5) );
  CLKINVX1 U10 ( .A(d[6]), .Y(n13) );
  CLKINVX1 U11 ( .A(d[4]), .Y(n9) );
  CLKINVX1 U12 ( .A(d[3]), .Y(n7) );
  CLKINVX1 U13 ( .A(n3), .Y(q[2]) );
  CLKINVX1 U14 ( .A(d[1]), .Y(n3) );
endmodule


module rlc ( d, in_cy, out_cy, q );
  input [7:0] d;
  output [7:0] q;
  input in_cy;
  output out_cy;
  wire   \q0[1] , n1, n3, n5, n7, n9, n11, n13, n15;
  assign q[1] = \q0[1] ;
  assign \q0[1]  = d[0];

  CLKINVX1 U1 ( .A(n13), .Y(q[7]) );
  INVX1 U2 ( .A(n7), .Y(q[4]) );
  INVX1 U3 ( .A(n9), .Y(q[5]) );
  CLKINVX1 U4 ( .A(n15), .Y(out_cy) );
  CLKINVX1 U5 ( .A(d[7]), .Y(n15) );
  CLKINVX1 U6 ( .A(d[6]), .Y(n13) );
  CLKINVX1 U7 ( .A(d[3]), .Y(n7) );
  INVX1 U8 ( .A(n11), .Y(q[6]) );
  CLKINVX1 U9 ( .A(d[5]), .Y(n11) );
  INVX1 U10 ( .A(n5), .Y(q[3]) );
  CLKINVX1 U11 ( .A(d[2]), .Y(n5) );
  CLKINVX1 U12 ( .A(d[4]), .Y(n9) );
  INVX1 U13 ( .A(n3), .Y(q[2]) );
  CLKINVX1 U14 ( .A(d[1]), .Y(n3) );
  CLKINVX1 U15 ( .A(n1), .Y(q[0]) );
  CLKINVX1 U16 ( .A(in_cy), .Y(n1) );
endmodule


module rr ( d, q );
  input [7:0] d;
  output [7:0] q;
  wire   \q[7] , n1, n3, n5, n7, n9, n11, n13;
  assign q[7] = \q[7] ;
  assign \q[7]  = d[0];

  INVX1 U1 ( .A(n9), .Y(q[4]) );
  INVX1 U2 ( .A(n5), .Y(q[2]) );
  INVX1 U3 ( .A(n11), .Y(q[5]) );
  INVX1 U4 ( .A(n3), .Y(q[1]) );
  INVX1 U5 ( .A(n13), .Y(q[6]) );
  CLKINVX1 U6 ( .A(d[7]), .Y(n13) );
  CLKINVX1 U7 ( .A(d[2]), .Y(n3) );
  CLKINVX1 U8 ( .A(d[6]), .Y(n11) );
  CLKINVX1 U9 ( .A(d[5]), .Y(n9) );
  CLKINVX1 U10 ( .A(d[3]), .Y(n5) );
  INVX1 U11 ( .A(n7), .Y(q[3]) );
  CLKINVX1 U12 ( .A(d[4]), .Y(n7) );
  INVX1 U13 ( .A(n1), .Y(q[0]) );
  CLKINVX1 U14 ( .A(d[1]), .Y(n1) );
endmodule


module rrc ( d, in_cy, out_cy, q );
  input [7:0] d;
  output [7:0] q;
  input in_cy;
  output out_cy;
  wire   out_cy, n1, n3, n5, n7, n9, n11, n13, n15;
  assign out_cy = d[0];

  INVX1 U1 ( .A(n5), .Y(q[2]) );
  INVX1 U2 ( .A(n11), .Y(q[5]) );
  INVX1 U3 ( .A(n9), .Y(q[4]) );
  INVX1 U4 ( .A(n7), .Y(q[3]) );
  INVX1 U5 ( .A(n13), .Y(q[6]) );
  CLKINVX1 U6 ( .A(d[7]), .Y(n13) );
  CLKINVX1 U7 ( .A(n3), .Y(q[1]) );
  CLKINVX1 U8 ( .A(d[2]), .Y(n3) );
  CLKINVX1 U9 ( .A(d[6]), .Y(n11) );
  CLKINVX1 U10 ( .A(d[5]), .Y(n9) );
  CLKINVX1 U11 ( .A(d[3]), .Y(n5) );
  CLKINVX1 U12 ( .A(d[4]), .Y(n7) );
  INVX1 U13 ( .A(n1), .Y(q[0]) );
  CLKINVX1 U14 ( .A(d[1]), .Y(n1) );
  CLKINVX1 U15 ( .A(n15), .Y(q[7]) );
  CLKINVX1 U16 ( .A(in_cy), .Y(n15) );
endmodule


module swap ( d, q );
  input [7:0] d;
  output [7:0] q;
  wire   \q[4] , n1, n3, n5, n7, n9, n11, n13;
  assign q[4] = \q[4] ;
  assign \q[4]  = d[0];

  INVX1 U1 ( .A(n13), .Y(q[7]) );
  INVX1 U2 ( .A(n1), .Y(q[0]) );
  INVX1 U3 ( .A(n5), .Y(q[2]) );
  INVX1 U4 ( .A(n7), .Y(q[3]) );
  CLKINVX1 U5 ( .A(d[7]), .Y(n7) );
  CLKINVX1 U6 ( .A(n3), .Y(q[1]) );
  CLKINVX1 U7 ( .A(d[5]), .Y(n3) );
  CLKINVX1 U8 ( .A(d[6]), .Y(n5) );
  CLKINVX1 U9 ( .A(d[3]), .Y(n13) );
  INVX1 U10 ( .A(n11), .Y(q[6]) );
  CLKINVX1 U11 ( .A(d[2]), .Y(n11) );
  CLKINVX1 U12 ( .A(d[4]), .Y(n1) );
  INVX1 U13 ( .A(n9), .Y(q[5]) );
  CLKINVX1 U14 ( .A(d[1]), .Y(n9) );
endmodule


module u_sfr ( end_instr, clk, rst_p, ld_acc, ld_acc_chd, addr_sfr, in_sfr, 
        wr_sfr, ld_dpl, ld_dph, inc_dptr, inc_sp, dec_sp, set_c, rst_c, cpl_c, 
        ld_c, set_ac, rst_ac, set_v, rst_v, acc_chd, in_b, ld_b, in_cy_bit, 
        rmw, t0_pin, t1_pin, int0_pin, int1_pin, p0_in, p1_in, p2_in, p3_in, 
        reti, out_sfr_a, out_acc_r, out_dptr_r, out_dimod_r, out_sp_r, out_psw, 
        out_b, p0_out, p1_out, p2_out, p3_out, txdo, rxdi, rxdo, int_vec, 
        en_int );
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
  input end_instr, clk, rst_p, ld_acc, ld_acc_chd, wr_sfr, ld_dpl, ld_dph,
         inc_dptr, inc_sp, dec_sp, set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac,
         set_v, rst_v, ld_b, in_cy_bit, rmw, t0_pin, t1_pin, int0_pin,
         int1_pin, reti, rxdi;
  output txdo, rxdo, en_int;
  wire   rst_tf1, rst_ie1, rst_tf0, rst_ie0, tf0, tf0_sync, tf1, tf1_sync,
         set_ie0, set_ie1, shift12, uart_int, parity, disint, n2, n101, n135,
         n166, n167, n168, n169, n170, n171, n172, n173, n174, n175, n176,
         n177, n178, n179, n180, n181, n182, n183, n184, n185, n186, n187,
         n188, n189, n190, n191, n192, n193, n194, n195, n196, n197, n198,
         n199, n200, n201, n202, n203, n204, n205, n206, n207, n208, n209,
         n210, n211, n212, n213, n214, n215, n216, n217, n218, n219, n220,
         n221, n222, n223, n224, n225, n226, n227, n228, n229, n230, n231,
         n232, n233, n234, n235, n236, n237, n238, n239, n240, n241, n242,
         n243, n244, n245, n246, n247, n248, n249, n250, n251, n252, n253,
         n254, n255, n256, n257, n258, n259, n260, n261, n262, n263, n264,
         n265, n266, n267, n268, n269, n270, n271, n272, n273, n274, n275,
         n276, n277, n278, n279, n280, n281, n282, n283, n284, n285, n286,
         n287, n288, n289, n290, n291, n292, n293, n294, n295, n296, n297,
         n298, n299, n300, n301, n302, n303, n304, n305, n306, n307, n308,
         n309, n310, n311, n312, n313, n314, n315, n316, n317, n318, n319,
         n320, n321, n322, n323, n324, n325, n326, n327, n328, n329, n330,
         n331, n332, n333, n334, n335, n336, n337, n338, n339, n340, n341,
         n342, n343, n344, n345, n346, n347, n348, n349, n350, n351, n352,
         n353, n354, n355, n356, n357, n358, n359, n360, n361, n362, n363,
         n364, n365, n366, n367, n368, n369, n370, n371, n372, n373, n374,
         n375, n376, n377, n378, n379, n380, n381, n382, n383, n384, n385,
         n386, n387, n388, n389, n390, n391, n392, n393, n394, n395, n396,
         n397, n398, n399, n400, n401, n402, n403, n404, n405, n406, n407,
         n408, n409, n410, n411, n412, n413, n414, n415, n416, n417, n418,
         n419, n420, n421, n422, n423, n424, n425, n426, n427, n428, n429,
         n430, n431, n432, n433, n434, n435, n436, n437, n438, n439, n440,
         n441, n442, n443, n444, n445, n446, n447, n448, n449, n450, n451,
         n452, n453, n454, n455, n456, n457, n458, n459, n460, n461, n462,
         n463, n464, n465, n466, n467, n468, n469, n470, n471, n472, n473,
         n474, n475, n476, n477, n478, n479, n480, n481, n482, n483, n484,
         n485, n486, n487, n488, n489, n490, n491, n492, n493, n494, n495,
         n496, n497, n498, n499, n500, n501, n502, n503, n504, n505, n506,
         n507, n508, n509, n510, n511, n512, n513, n514, n515, n516, n517,
         n518, n519, n520, n521, n522, n523, n524, n525, n526, n527, n528,
         n529, n530, n531, n532, n533, n534, n535, n536, n537, n538, n539,
         n540, n541, n542, n543, n544, n545, n546, n547, n548, n549, n550,
         n551, n552, n553, n554, n555, n556, n557, n558, n559, n560, n561,
         n562, n563, n564, n565, n566, n567, n568, n569, n570, n571, n572,
         n573, n574, n575, n576, n577, n578, n579, n580, n581, n582, n583,
         n584, n585, n586, n587, n588, n589, n590, n591, n592, n593, n594,
         n595, n596, n597, n598, n599, n600, n601;
  wire   [2:0] isrc_cur;
  wire   [7:0] p0;
  wire   [7:0] tcon;
  wire   [7:0] tmod;
  wire   [7:0] tl0;
  wire   [7:0] tl1;
  wire   [7:0] th0;
  wire   [7:0] th1;
  wire   [7:0] p1;
  wire   [7:0] scon;
  wire   [7:0] pcon;
  wire   [7:0] sbuf;
  wire   [7:0] p2;
  wire   [7:0] ie;
  wire   [7:0] p3;
  wire   [7:0] ip;

  gpio0 U_port0 ( .clk(clk), .rst_p(rst_p), .wr(n203), .rmw(rmw), .combus(
        in_sfr), .prt0_addr({addr_sfr[7:6], n208, n207, n206, n196, n204, n195}), .p0_in(p0_in), .p0(p0), .p0_out(p0_out) );
  sp U0_sp ( .clk(clk), .rst_p(rst_p), .wr(n203), .inc_sp(inc_sp), .dec_sp(
        dec_sp), .addr_sp({addr_sfr[7:6], n208, n207, n206, n197, n204, n195}), 
        .in_sp(in_sfr), .out_sp(out_sp_r) );
  dptr U1_dptr ( .clk(clk), .rst_p(rst_p), .ld_dpl(ld_dpl), .ld_dph(ld_dph), 
        .wr(n203), .inc_dptr(inc_dptr), .addr_dptr({addr_sfr[7:6], n208, n207, 
        n206, n196, n204, n195}), .in_dptr(in_sfr), .out_dptr(out_dptr_r) );
  dimod U1_dimod ( .clk(clk), .rst_p(rst_p), .wr(n203), .addr_dimod({
        addr_sfr[7:6], n208, n207, n206, n198, n204, n194}), .in_dimod(in_sfr), 
        .out_dimod(out_dimod_r) );
  one_shot_2 one_shot_tf0 ( .rst_p(rst_p), .clk(clk), .d(tf0), .q(tf0_sync) );
  one_shot_1 one_shot_tf1 ( .rst_p(rst_p), .clk(clk), .d(tf1), .q(tf1_sync) );
  tcon U_tcon ( .clk(clk), .rst_p(rst_p), .in_tcon(in_sfr), .addr_tcon({
        addr_sfr[7:6], n208, n207, n206, n198, n204, n173}), .wr(n203), 
        .set_tf0(tf0_sync), .rst_tf0(rst_tf0), .set_tf1(tf1_sync), .rst_tf1(
        rst_tf1), .set_ie0(set_ie0), .rst_ie0(rst_ie0), .set_ie1(set_ie1), 
        .rst_ie1(rst_ie1), .out_tcon(tcon) );
  tmod U_tmod ( .clk(clk), .rst_p(rst_p), .wr(n203), .in_tmod(in_sfr), 
        .addr_tmod({addr_sfr[7:6], n208, n207, n206, n197, n204, n195}), 
        .out_tmod(tmod) );
  u_tc U12_u_tc ( .clk(clk), .rst_p(rst_p), .wr(n203), .in_tc(in_sfr), 
        .addr_tc({addr_sfr[7:6], n208, n207, n206, n198, n204, n173}), 
        .t0_pin(t0_pin), .t1_pin(t1_pin), .int0_pin(int0_pin), .int1_pin(
        int1_pin), .sel_tc0(tmod[2]), .sel_tc1(tmod[6]), .gate0(tmod[3]), 
        .gate1(tmod[7]), .tr0(tcon[4]), .tr1(tcon[6]), .tm0(tmod[1:0]), .tm1(
        tmod[5:4]), .tf0(tf0), .tf1(tf1), .tl0(tl0), .tl1(tl1), .th0(th0), 
        .th1(th1), .shift12(shift12) );
  gpio1 U_port1 ( .clk(clk), .rst_p(rst_p), .wr(n203), .rmw(rmw), .combus(
        in_sfr), .prt1_addr({addr_sfr[7:6], n208, n207, n206, n196, n204, n195}), .p1_in(p1_in), .p1(p1), .p1_out(p1_out) );
  u_uart U_uart ( .clk(clk), .rst_p(rst_p), .rxdi(rxdi), .rxdo(rxdo), .in_sfr(
        in_sfr), .addr_sfr({addr_sfr[7:6], n208, n207, n206, n197, n204, n195}), .wr(n203), .shift12(shift12), .tf1(tf1_sync), .txdo(txdo), .uart_int(
        uart_int), .scon(scon), .pcon(pcon), .sbuf(sbuf) );
  gpio2 U_port2 ( .clk(clk), .rst_p(rst_p), .wr(n203), .rmw(rmw), .combus(
        in_sfr), .prt2_addr({addr_sfr[7:6], n208, n207, n206, n197, n204, n195}), .p2_in(p2_in), .p2(p2), .p2_out(p2_out) );
  ie U_ie ( .clk(clk), .rst_p(rst_p), .in_ie(in_sfr), .addr_ie({addr_sfr[7:6], 
        n208, n207, n206, n196, n204, n172}), .wr(n203), .out_ie(ie) );
  gpio3 U_port3 ( .clk(clk), .rst_p(rst_p), .wr(n203), .rmw(rmw), .combus(
        in_sfr), .prt3_addr({addr_sfr[7:6], n208, n207, n206, n198, n204, n173}), .p3_in(p3_in), .p3(p3), .p3_out(p3_out) );
  ip U_ip ( .clk(clk), .rst_p(rst_p), .in_ip(in_sfr), .addr_ip({addr_sfr[7:6], 
        n208, n207, n206, n196, n204, n172}), .wr(n203), .out_ip(ip) );
  psw U3_psw ( .rst_p(rst_p), .in_psw(in_sfr[7:1]), .clk(clk), .addr_psw({
        addr_sfr[7:6], n208, n207, n206, n198, n204, n195}), .wr(n203), 
        .in_cy_bit(in_cy_bit), .set_c(set_c), .rst_c(rst_c), .cpl_c(cpl_c), 
        .ld_c(ld_c), .set_ac(set_ac), .rst_ac(rst_ac), .set_v(set_v), .rst_v(
        rst_v), .parity(parity), .out_psw(out_psw) );
  acc U2_acc ( .clk(clk), .rst_p(rst_p), .ld_acc(ld_acc), .ld_acc_chd(
        ld_acc_chd), .wr(n203), .addr_acc({addr_sfr[7:6], n208, n207, n206, 
        n198, n204, n195}), .in_acc(in_sfr), .acc_chd(acc_chd), .out_acc_r(
        out_acc_r) );
  parity_gen U4_parity ( .p_acc(out_acc_r), .parity(parity) );
  b U4_b ( .clk(clk), .rst_p(rst_p), .in_b(in_b), .in_dat(in_sfr), .addr_b({
        addr_sfr[7:6], n208, n207, n206, n197, n204, n195}), .wr(n203), .ld_b(
        ld_b), .out_b(out_b) );
  u_int U27_int ( .disint(disint), .end_instr(end_instr), .ti_ri(uart_int), 
        .clk(clk), .rst_p(rst_p), .ex_int_a(int0_pin), .ex_int_b(int1_pin), 
        .it_a(tcon[0]), .it_b(tcon[2]), .tf_a(tcon[5]), .tf_b(tcon[7]), .ie_j(
        ie[7]), .ie(ie[4:0]), .ip(ip[4:0]), .ie_a(tcon[1]), .ie_b(tcon[3]), 
        .smpl_ex_a(set_ie0), .smpl_ex_b(set_ie1), .int_vec(int_vec), .reti(
        reti), .isrc_cur(isrc_cur), .en_int(en_int) );
  INVX1 U179 ( .A(n167), .Y(n166) );
  NAND2BX1 U180 ( .AN(n208), .B(p1[0]), .Y(n167) );
  NOR2X4 U181 ( .A(n195), .B(n599), .Y(n597) );
  AND2X8 U182 ( .A(n556), .B(n557), .Y(n180) );
  NAND2X4 U183 ( .A(n181), .B(n178), .Y(n257) );
  NAND2X4 U184 ( .A(n553), .B(n178), .Y(n225) );
  INVX4 U185 ( .A(n513), .Y(n252) );
  BUFX20 U186 ( .A(addr_sfr[4]), .Y(n207) );
  NAND2X6 U187 ( .A(n555), .B(n169), .Y(n223) );
  AND2X8 U188 ( .A(n180), .B(n193), .Y(n169) );
  NAND2X4 U189 ( .A(n597), .B(n598), .Y(n593) );
  NAND4X2 U190 ( .A(n527), .B(n528), .C(n529), .D(n530), .Y(n526) );
  NOR2X2 U191 ( .A(n229), .B(n577), .Y(n576) );
  AND2X8 U192 ( .A(n195), .B(n180), .Y(n178) );
  AND2X8 U193 ( .A(n179), .B(n169), .Y(n174) );
  NAND2X4 U194 ( .A(n537), .B(n178), .Y(n250) );
  NAND3X6 U195 ( .A(n524), .B(n201), .C(n525), .Y(out_sfr_a[0]) );
  AND2X2 U196 ( .A(n192), .B(n166), .Y(n574) );
  INVX6 U197 ( .A(n208), .Y(n580) );
  INVX4 U198 ( .A(n518), .Y(n259) );
  NAND2X4 U199 ( .A(n181), .B(n169), .Y(n518) );
  INVX3 U200 ( .A(n578), .Y(n540) );
  NAND3X2 U201 ( .A(n196), .B(n579), .C(n557), .Y(n578) );
  AND2X2 U202 ( .A(n192), .B(n168), .Y(n564) );
  NOR2BX1 U203 ( .AN(n208), .B(n573), .Y(n168) );
  NAND2X6 U204 ( .A(n208), .B(n570), .Y(n235) );
  INVX8 U205 ( .A(n207), .Y(n570) );
  INVX6 U206 ( .A(addr_sfr[0]), .Y(n193) );
  NOR2X1 U207 ( .A(n267), .B(n522), .Y(n521) );
  NOR2X1 U208 ( .A(n269), .B(n523), .Y(n520) );
  NAND4X1 U209 ( .A(n504), .B(n505), .C(n506), .D(n507), .Y(n481) );
  NOR2X1 U210 ( .A(n221), .B(n449), .Y(n446) );
  NOR2X1 U211 ( .A(n225), .B(n451), .Y(n444) );
  NAND4X1 U212 ( .A(n380), .B(n381), .C(n382), .D(n383), .Y(n357) );
  NOR2X1 U213 ( .A(n269), .B(n270), .Y(n265) );
  NOR2X1 U214 ( .A(n267), .B(n268), .Y(n266) );
  NAND2BX1 U215 ( .AN(n396), .B(n397), .Y(out_sfr_a[3]) );
  AOI2BB1X1 U216 ( .A0N(n200), .A1N(n223), .B0(n551), .Y(n527) );
  AND2X4 U217 ( .A(n206), .B(n554), .Y(n181) );
  INVX1 U218 ( .A(tcon[0]), .Y(n548) );
  INVX1 U219 ( .A(tmod[0]), .Y(n549) );
  INVX1 U220 ( .A(th0[0]), .Y(n550) );
  CLKINVX1 U221 ( .A(p0[0]), .Y(n534) );
  INVX3 U222 ( .A(n206), .Y(n544) );
  INVX3 U223 ( .A(n204), .Y(n554) );
  NAND2BX1 U224 ( .AN(n438), .B(n439), .Y(out_sfr_a[2]) );
  NAND2BX1 U225 ( .AN(n313), .B(n314), .Y(out_sfr_a[5]) );
  NAND2BX1 U226 ( .AN(n271), .B(n272), .Y(out_sfr_a[6]) );
  AND2X2 U227 ( .A(n519), .B(n186), .Y(n182) );
  OAI21X1 U228 ( .A0(n481), .A1(n482), .B0(n601), .Y(n480) );
  NOR2X1 U229 ( .A(n520), .B(n521), .Y(n519) );
  OAI21X1 U230 ( .A0(n357), .A1(n358), .B0(n601), .Y(n356) );
  AND2X2 U231 ( .A(n263), .B(n191), .Y(n199) );
  NAND2X2 U232 ( .A(out_psw[0]), .B(n559), .Y(n525) );
  INVX1 U233 ( .A(scon[1]), .Y(n501) );
  NOR2X1 U234 ( .A(n267), .B(n436), .Y(n435) );
  NOR2X1 U235 ( .A(n223), .B(n450), .Y(n445) );
  NOR2X1 U236 ( .A(n225), .B(n552), .Y(n551) );
  NOR3X1 U237 ( .A(n545), .B(n546), .C(n547), .Y(n528) );
  NOR2X1 U238 ( .A(n261), .B(n550), .Y(n545) );
  NOR2X1 U239 ( .A(n257), .B(n549), .Y(n546) );
  NOR2X1 U240 ( .A(n510), .B(n534), .Y(n533) );
  AOI21X1 U241 ( .A0(out_dptr_r[0]), .A1(n174), .B0(n542), .Y(n529) );
  INVX12 U242 ( .A(n193), .Y(n195) );
  CLKINVX3 U243 ( .A(n593), .Y(n591) );
  CLKAND2X3 U244 ( .A(n204), .B(n544), .Y(n179) );
  INVX3 U245 ( .A(n582), .Y(n234) );
  BUFX20 U246 ( .A(addr_sfr[5]), .Y(n208) );
  NOR2X6 U247 ( .A(n171), .B(n170), .Y(n201) );
  OR2X6 U248 ( .A(n184), .B(n183), .Y(n170) );
  AND2X8 U249 ( .A(n561), .B(n601), .Y(n171) );
  NOR2X2 U250 ( .A(n544), .B(n554), .Y(n553) );
  NOR3X1 U251 ( .A(n531), .B(n532), .C(n533), .Y(n530) );
  NAND2X2 U252 ( .A(n526), .B(n601), .Y(n524) );
  NOR3X1 U253 ( .A(n570), .B(n198), .C(n204), .Y(n569) );
  BUFX3 U254 ( .A(n205), .Y(n198) );
  NAND3X2 U255 ( .A(n568), .B(n569), .C(n206), .Y(n219) );
  NOR2X1 U256 ( .A(n219), .B(n448), .Y(n447) );
  NAND2X2 U257 ( .A(n592), .B(n192), .Y(n267) );
  NAND2X2 U258 ( .A(n560), .B(n192), .Y(n269) );
  NAND2X4 U259 ( .A(n590), .B(n591), .Y(n242) );
  NAND2BX1 U260 ( .AN(n264), .B(out_acc_r[7]), .Y(n191) );
  NAND2X2 U261 ( .A(n562), .B(n563), .Y(n561) );
  NAND2X2 U262 ( .A(n199), .B(n209), .Y(out_sfr_a[7]) );
  NAND4X1 U263 ( .A(n244), .B(n245), .C(n246), .D(n247), .Y(n210) );
  NAND2X2 U264 ( .A(n179), .B(n178), .Y(n513) );
  NAND2X2 U265 ( .A(addr_sfr[6]), .B(n589), .Y(n264) );
  CLKINVX4 U266 ( .A(n242), .Y(n589) );
  NOR2X2 U267 ( .A(n196), .B(n204), .Y(n598) );
  OAI21X2 U268 ( .A0(n211), .A1(n210), .B0(n601), .Y(n209) );
  CLKINVX1 U269 ( .A(out_b[2]), .Y(n478) );
  CLKINVX1 U270 ( .A(n269), .Y(n559) );
  CLKINVX1 U271 ( .A(sbuf[2]), .Y(n448) );
  CLKINVX1 U272 ( .A(tl0[2]), .Y(n450) );
  INVX1 U273 ( .A(p2[7]), .Y(n243) );
  INVX1 U274 ( .A(p1[7]), .Y(n241) );
  CLKINVX1 U275 ( .A(th1[0]), .Y(n577) );
  INVX1 U276 ( .A(scon[7]), .Y(n239) );
  CLKINVX1 U277 ( .A(scon[0]), .Y(n588) );
  CLKINVX1 U278 ( .A(ie[0]), .Y(n586) );
  CLKINVX1 U279 ( .A(ip[0]), .Y(n587) );
  CLKINVX1 U280 ( .A(ie[2]), .Y(n458) );
  CLKINVX1 U281 ( .A(ip[2]), .Y(n459) );
  CLKINVX1 U282 ( .A(ie[6]), .Y(n291) );
  CLKINVX1 U283 ( .A(sbuf[1]), .Y(n489) );
  CLKINVX1 U284 ( .A(sbuf[0]), .Y(n567) );
  INVX3 U285 ( .A(out_psw[7]), .Y(n270) );
  NAND3X2 U286 ( .A(n540), .B(n193), .C(n181), .Y(n261) );
  INVX8 U287 ( .A(addr_sfr[6]), .Y(n212) );
  BUFX12 U288 ( .A(n205), .Y(n196) );
  CLKINVX3 U289 ( .A(addr_sfr[7]), .Y(n599) );
  CLKINVX1 U290 ( .A(n193), .Y(n194) );
  CLKINVX1 U291 ( .A(n193), .Y(n173) );
  CLKINVX1 U292 ( .A(n193), .Y(n172) );
  BUFX12 U293 ( .A(n212), .Y(n601) );
  INVX4 U294 ( .A(n510), .Y(n248) );
  NAND2X4 U295 ( .A(n535), .B(n169), .Y(n510) );
  AOI21X1 U296 ( .A0(p0[7]), .A1(n248), .B0(n249), .Y(n247) );
  AOI21X1 U297 ( .A0(tcon[7]), .A1(n259), .B0(n260), .Y(n244) );
  NOR3X1 U298 ( .A(n574), .B(n575), .C(n576), .Y(n562) );
  NOR2X1 U299 ( .A(n392), .B(n393), .Y(n176) );
  NAND2X1 U300 ( .A(n176), .B(n185), .Y(n355) );
  INVX1 U301 ( .A(tl0[5]), .Y(n325) );
  INVX1 U302 ( .A(out_b[3]), .Y(n436) );
  INVX1 U303 ( .A(tl1[2]), .Y(n451) );
  INVX1 U304 ( .A(out_b[6]), .Y(n311) );
  INVX1 U305 ( .A(tl0[6]), .Y(n283) );
  INVX1 U306 ( .A(pcon[0]), .Y(n538) );
  INVX1 U307 ( .A(scon[4]), .Y(n377) );
  INVX1 U308 ( .A(th1[6]), .Y(n287) );
  INVX1 U309 ( .A(scon[5]), .Y(n335) );
  INVX1 U310 ( .A(ip[6]), .Y(n292) );
  INVX1 U311 ( .A(scon[3]), .Y(n418) );
  INVX1 U312 ( .A(sbuf[4]), .Y(n365) );
  INVX1 U313 ( .A(sbuf[3]), .Y(n406) );
  INVX1 U314 ( .A(sbuf[5]), .Y(n323) );
  INVX3 U315 ( .A(n571), .Y(n557) );
  NAND2BX4 U316 ( .AN(n177), .B(n181), .Y(n229) );
  NAND2X2 U317 ( .A(n539), .B(n540), .Y(n254) );
  BUFX16 U318 ( .A(addr_sfr[1]), .Y(n204) );
  NAND2X1 U319 ( .A(n206), .B(n591), .Y(n582) );
  NAND2X1 U320 ( .A(n207), .B(n580), .Y(n175) );
  BUFX6 U321 ( .A(addr_sfr[2]), .Y(n205) );
  NOR2X1 U322 ( .A(n254), .B(n538), .Y(n531) );
  NOR2X1 U323 ( .A(n250), .B(n536), .Y(n532) );
  NAND2X4 U324 ( .A(n182), .B(n480), .Y(out_sfr_a[1]) );
  NOR3X1 U325 ( .A(n583), .B(n584), .C(n585), .Y(n581) );
  NOR2X1 U326 ( .A(n237), .B(n587), .Y(n584) );
  NOR2X1 U327 ( .A(n175), .B(n588), .Y(n583) );
  NOR2X1 U328 ( .A(n235), .B(n586), .Y(n585) );
  NOR2X1 U329 ( .A(n518), .B(n548), .Y(n547) );
  NAND2X1 U330 ( .A(n359), .B(n360), .Y(n358) );
  NAND2X1 U331 ( .A(n483), .B(n484), .Y(n482) );
  NAND2X1 U332 ( .A(n317), .B(n318), .Y(n316) );
  NAND2X1 U333 ( .A(n400), .B(n401), .Y(n399) );
  NAND2X1 U334 ( .A(n350), .B(n188), .Y(n313) );
  OAI21X1 U335 ( .A0(n315), .A1(n316), .B0(n601), .Y(n314) );
  NAND2X1 U336 ( .A(n433), .B(n190), .Y(n396) );
  OAI21X1 U337 ( .A0(n398), .A1(n399), .B0(n601), .Y(n397) );
  NAND2X1 U338 ( .A(n475), .B(n189), .Y(n438) );
  OAI21X1 U339 ( .A0(n440), .A1(n441), .B0(n212), .Y(n439) );
  NAND2X1 U340 ( .A(n442), .B(n443), .Y(n441) );
  NOR2X1 U341 ( .A(n452), .B(n453), .Y(n442) );
  NAND2X1 U342 ( .A(n308), .B(n187), .Y(n271) );
  OAI21X1 U343 ( .A0(n273), .A1(n274), .B0(n601), .Y(n272) );
  NAND2X1 U344 ( .A(n275), .B(n276), .Y(n274) );
  CLKBUFX2 U345 ( .A(wr_sfr), .Y(n203) );
  CLKINVX1 U346 ( .A(p3[7]), .Y(n222) );
  CLKINVX1 U347 ( .A(p3[3]), .Y(n407) );
  NAND4X1 U348 ( .A(n338), .B(n339), .C(n340), .D(n341), .Y(n315) );
  NAND4X1 U349 ( .A(n463), .B(n464), .C(n465), .D(n466), .Y(n440) );
  NAND4X1 U350 ( .A(n421), .B(n422), .C(n423), .D(n424), .Y(n398) );
  AOI21X1 U351 ( .A0(out_dptr_r[15]), .A1(n252), .B0(n253), .Y(n246) );
  CLKINVX1 U352 ( .A(p3[0]), .Y(n573) );
  NOR2X1 U353 ( .A(n269), .B(n437), .Y(n434) );
  NOR2X1 U354 ( .A(n219), .B(n220), .Y(n218) );
  INVX1 U355 ( .A(sbuf[7]), .Y(n220) );
  CLKINVX1 U356 ( .A(p3[2]), .Y(n449) );
  CLKINVX1 U357 ( .A(p2[0]), .Y(n572) );
  NOR2X1 U358 ( .A(n513), .B(n543), .Y(n542) );
  INVX1 U359 ( .A(out_dptr_r[8]), .Y(n543) );
  CLKINVX1 U360 ( .A(p3[5]), .Y(n324) );
  CLKINVX1 U361 ( .A(p3[6]), .Y(n282) );
  NAND4X1 U362 ( .A(n296), .B(n297), .C(n298), .D(n299), .Y(n273) );
  NAND2X1 U363 ( .A(n195), .B(n540), .Y(n177) );
  NAND2X4 U364 ( .A(addr_sfr[7]), .B(n580), .Y(n571) );
  NOR2X1 U365 ( .A(n208), .B(n601), .Y(n560) );
  NOR2X1 U366 ( .A(n580), .B(n601), .Y(n592) );
  NOR2X2 U367 ( .A(n544), .B(n554), .Y(n555) );
  BUFX8 U368 ( .A(n205), .Y(n197) );
  NAND2X1 U369 ( .A(n207), .B(n208), .Y(n237) );
  NAND2X2 U370 ( .A(n192), .B(n580), .Y(n240) );
  NOR2X1 U371 ( .A(n571), .B(n193), .Y(n568) );
  NOR2X1 U372 ( .A(n541), .B(n206), .Y(n539) );
  NAND2X2 U373 ( .A(n192), .B(n208), .Y(n221) );
  NOR2X1 U374 ( .A(n206), .B(n204), .Y(n537) );
  CLKINVX1 U375 ( .A(n207), .Y(n579) );
  NOR3BX2 U376 ( .AN(n208), .B(n206), .C(n207), .Y(n590) );
  CLKINVX1 U377 ( .A(n203), .Y(n600) );
  CLKINVX1 U378 ( .A(p1[4]), .Y(n378) );
  CLKINVX1 U379 ( .A(p2[4]), .Y(n379) );
  CLKINVX1 U380 ( .A(p1[1]), .Y(n502) );
  CLKINVX1 U381 ( .A(p2[1]), .Y(n503) );
  CLKINVX1 U382 ( .A(p1[3]), .Y(n419) );
  CLKINVX1 U383 ( .A(p2[3]), .Y(n420) );
  CLKINVX1 U384 ( .A(p1[2]), .Y(n461) );
  CLKINVX1 U385 ( .A(p2[2]), .Y(n462) );
  CLKINVX1 U386 ( .A(p1[5]), .Y(n336) );
  CLKINVX1 U387 ( .A(p2[5]), .Y(n337) );
  CLKINVX1 U388 ( .A(p1[6]), .Y(n294) );
  CLKINVX1 U389 ( .A(p2[6]), .Y(n295) );
  NOR2X1 U390 ( .A(n309), .B(n310), .Y(n308) );
  NOR2X1 U391 ( .A(n476), .B(n477), .Y(n475) );
  NOR2X1 U392 ( .A(n351), .B(n352), .Y(n350) );
  NOR3X1 U393 ( .A(n564), .B(n565), .C(n566), .Y(n563) );
  NOR2X1 U394 ( .A(n219), .B(n567), .Y(n566) );
  NOR2X1 U395 ( .A(n434), .B(n435), .Y(n433) );
  NOR2X1 U396 ( .A(n581), .B(n582), .Y(n575) );
  NOR4X1 U397 ( .A(n215), .B(n216), .C(n217), .D(n218), .Y(n214) );
  NOR4X1 U398 ( .A(n402), .B(n403), .C(n404), .D(n405), .Y(n401) );
  NOR2X1 U399 ( .A(n410), .B(n411), .Y(n400) );
  NOR2X1 U400 ( .A(n219), .B(n406), .Y(n405) );
  NOR2X1 U401 ( .A(n285), .B(n286), .Y(n275) );
  NOR4X1 U402 ( .A(n277), .B(n278), .C(n279), .D(n280), .Y(n276) );
  OAI21X1 U403 ( .A0(n229), .A1(n287), .B0(n288), .Y(n286) );
  NOR4X1 U404 ( .A(n485), .B(n486), .C(n487), .D(n488), .Y(n484) );
  NOR2X1 U405 ( .A(n493), .B(n494), .Y(n483) );
  NOR2X1 U406 ( .A(n219), .B(n489), .Y(n488) );
  NOR4X1 U407 ( .A(n319), .B(n320), .C(n321), .D(n322), .Y(n318) );
  NOR2X1 U408 ( .A(n327), .B(n328), .Y(n317) );
  NOR2X1 U409 ( .A(n219), .B(n323), .Y(n322) );
  NOR4X1 U410 ( .A(n444), .B(n445), .C(n446), .D(n447), .Y(n443) );
  OAI21X1 U411 ( .A0(n229), .A1(n454), .B0(n455), .Y(n453) );
  NOR4X1 U412 ( .A(n361), .B(n362), .C(n363), .D(n364), .Y(n360) );
  NOR2X1 U413 ( .A(n369), .B(n370), .Y(n359) );
  NOR2X1 U414 ( .A(n219), .B(n365), .Y(n364) );
  NAND2X1 U415 ( .A(n594), .B(n595), .Y(disint) );
  CLKINVX1 U416 ( .A(reti), .Y(n595) );
  NAND2X1 U417 ( .A(n596), .B(n234), .Y(n594) );
  CLKINVX1 U418 ( .A(isrc_cur[0]), .Y(n2) );
  CLKINVX1 U419 ( .A(n525), .Y(n558) );
  NOR2X1 U420 ( .A(n225), .B(n284), .Y(n277) );
  INVX1 U421 ( .A(tl1[6]), .Y(n284) );
  NOR2X1 U422 ( .A(n219), .B(n281), .Y(n280) );
  INVX1 U423 ( .A(sbuf[6]), .Y(n281) );
  NOR2X1 U424 ( .A(n225), .B(n368), .Y(n361) );
  INVX1 U425 ( .A(tl1[4]), .Y(n368) );
  NOR2X1 U426 ( .A(n221), .B(n366), .Y(n363) );
  INVX1 U427 ( .A(p3[4]), .Y(n366) );
  NOR2X1 U428 ( .A(n223), .B(n367), .Y(n362) );
  INVX1 U429 ( .A(tl0[4]), .Y(n367) );
  OAI22X1 U430 ( .A0(n235), .A1(n236), .B0(n237), .B1(n238), .Y(n233) );
  CLKINVX1 U431 ( .A(ip[7]), .Y(n238) );
  CLKINVX1 U432 ( .A(ie[7]), .Y(n236) );
  OAI22X1 U433 ( .A0(n235), .A1(n416), .B0(n237), .B1(n417), .Y(n415) );
  CLKINVX1 U434 ( .A(ie[3]), .Y(n416) );
  CLKINVX1 U435 ( .A(ip[3]), .Y(n417) );
  OAI22X1 U436 ( .A0(n235), .A1(n375), .B0(n237), .B1(n376), .Y(n374) );
  CLKINVX1 U437 ( .A(ie[4]), .Y(n375) );
  CLKINVX1 U438 ( .A(ip[4]), .Y(n376) );
  AOI21X1 U439 ( .A0(out_dptr_r[12]), .A1(n252), .B0(n386), .Y(n382) );
  NOR2X1 U440 ( .A(n254), .B(n387), .Y(n386) );
  CLKINVX1 U441 ( .A(pcon[4]), .Y(n387) );
  AOI21X1 U442 ( .A0(out_dptr_r[9]), .A1(n252), .B0(n511), .Y(n506) );
  NOR2X1 U443 ( .A(n254), .B(n512), .Y(n511) );
  CLKINVX1 U444 ( .A(pcon[1]), .Y(n512) );
  AOI21X1 U445 ( .A0(out_dptr_r[11]), .A1(n252), .B0(n427), .Y(n423) );
  NOR2X1 U446 ( .A(n254), .B(n428), .Y(n427) );
  CLKINVX1 U447 ( .A(pcon[3]), .Y(n428) );
  OAI22X1 U448 ( .A0(n235), .A1(n499), .B0(n237), .B1(n500), .Y(n498) );
  CLKINVX1 U449 ( .A(ip[1]), .Y(n500) );
  CLKINVX1 U450 ( .A(ie[1]), .Y(n499) );
  OAI22X1 U451 ( .A0(n235), .A1(n333), .B0(n237), .B1(n334), .Y(n332) );
  CLKINVX1 U452 ( .A(ie[5]), .Y(n333) );
  CLKINVX1 U453 ( .A(ip[5]), .Y(n334) );
  NOR2X1 U454 ( .A(n267), .B(n394), .Y(n393) );
  INVX1 U455 ( .A(out_b[4]), .Y(n394) );
  NOR2X1 U456 ( .A(n267), .B(n311), .Y(n310) );
  NOR2X1 U457 ( .A(n267), .B(n353), .Y(n352) );
  INVX1 U458 ( .A(out_b[5]), .Y(n353) );
  NOR2X1 U459 ( .A(n267), .B(n478), .Y(n477) );
  INVX1 U460 ( .A(out_b[1]), .Y(n522) );
  OAI21X1 U461 ( .A0(n229), .A1(n371), .B0(n372), .Y(n370) );
  INVX1 U462 ( .A(th1[4]), .Y(n371) );
  OAI21X1 U463 ( .A0(n373), .A1(n374), .B0(n234), .Y(n372) );
  NOR2X1 U464 ( .A(n175), .B(n377), .Y(n373) );
  OAI21X1 U465 ( .A0(n229), .A1(n495), .B0(n496), .Y(n494) );
  INVX1 U466 ( .A(th1[1]), .Y(n495) );
  OAI21X1 U467 ( .A0(n497), .A1(n498), .B0(n234), .Y(n496) );
  NOR2X1 U468 ( .A(n175), .B(n501), .Y(n497) );
  OAI21X1 U469 ( .A0(n229), .A1(n412), .B0(n413), .Y(n411) );
  INVX1 U470 ( .A(th1[3]), .Y(n412) );
  OAI21X1 U471 ( .A0(n414), .A1(n415), .B0(n234), .Y(n413) );
  NOR2X1 U472 ( .A(n175), .B(n418), .Y(n414) );
  OAI21X1 U473 ( .A0(n229), .A1(n329), .B0(n330), .Y(n328) );
  INVX1 U474 ( .A(th1[5]), .Y(n329) );
  OAI21X1 U475 ( .A0(n331), .A1(n332), .B0(n234), .Y(n330) );
  NOR2X1 U476 ( .A(n175), .B(n335), .Y(n331) );
  INVX3 U477 ( .A(tl0[0]), .Y(n200) );
  INVX3 U478 ( .A(tl1[0]), .Y(n552) );
  AOI21X1 U479 ( .A0(p0[2]), .A1(n248), .B0(n467), .Y(n466) );
  NOR2X1 U480 ( .A(n250), .B(n468), .Y(n467) );
  AOI21X1 U481 ( .A0(p0[5]), .A1(n248), .B0(n342), .Y(n341) );
  NOR2X1 U482 ( .A(n250), .B(n343), .Y(n342) );
  AOI21X1 U483 ( .A0(p0[6]), .A1(n248), .B0(n300), .Y(n299) );
  NOR2X1 U484 ( .A(n250), .B(n301), .Y(n300) );
  AOI21X1 U485 ( .A0(out_dptr_r[7]), .A1(n174), .B0(n256), .Y(n245) );
  NOR2X1 U486 ( .A(n261), .B(n391), .Y(n390) );
  CLKINVX1 U487 ( .A(th0[4]), .Y(n391) );
  NOR2X1 U488 ( .A(n261), .B(n517), .Y(n516) );
  CLKINVX1 U489 ( .A(th0[1]), .Y(n517) );
  NOR2X1 U490 ( .A(n261), .B(n432), .Y(n431) );
  CLKINVX1 U491 ( .A(th0[3]), .Y(n432) );
  NOR2X1 U492 ( .A(n261), .B(n474), .Y(n473) );
  CLKINVX1 U493 ( .A(th0[2]), .Y(n474) );
  NOR2X1 U494 ( .A(n261), .B(n349), .Y(n348) );
  CLKINVX1 U495 ( .A(th0[5]), .Y(n349) );
  NOR2X1 U496 ( .A(n261), .B(n307), .Y(n306) );
  CLKINVX1 U497 ( .A(th0[6]), .Y(n307) );
  NOR2X1 U498 ( .A(n250), .B(n385), .Y(n384) );
  CLKINVX1 U499 ( .A(out_sp_r[4]), .Y(n385) );
  NOR2X1 U500 ( .A(n250), .B(n509), .Y(n508) );
  CLKINVX1 U501 ( .A(out_sp_r[1]), .Y(n509) );
  NOR2X1 U502 ( .A(n250), .B(n426), .Y(n425) );
  CLKINVX1 U503 ( .A(out_sp_r[3]), .Y(n426) );
  NOR2X1 U504 ( .A(n254), .B(n470), .Y(n469) );
  CLKINVX1 U505 ( .A(pcon[2]), .Y(n470) );
  NOR2X1 U506 ( .A(n254), .B(n345), .Y(n344) );
  CLKINVX1 U507 ( .A(pcon[5]), .Y(n345) );
  NOR2X1 U508 ( .A(n254), .B(n303), .Y(n302) );
  CLKINVX1 U509 ( .A(pcon[6]), .Y(n303) );
  NOR2X1 U510 ( .A(n257), .B(n389), .Y(n388) );
  CLKINVX1 U511 ( .A(tmod[4]), .Y(n389) );
  NOR2X1 U512 ( .A(n257), .B(n515), .Y(n514) );
  CLKINVX1 U513 ( .A(tmod[1]), .Y(n515) );
  NOR2X1 U514 ( .A(n257), .B(n430), .Y(n429) );
  CLKINVX1 U515 ( .A(tmod[3]), .Y(n430) );
  NOR2X1 U516 ( .A(n257), .B(n472), .Y(n471) );
  CLKINVX1 U517 ( .A(tmod[2]), .Y(n472) );
  NOR2X1 U518 ( .A(n257), .B(n347), .Y(n346) );
  CLKINVX1 U519 ( .A(tmod[5]), .Y(n347) );
  NOR2X1 U520 ( .A(n257), .B(n305), .Y(n304) );
  CLKINVX1 U521 ( .A(tmod[6]), .Y(n305) );
  NOR2X1 U522 ( .A(n254), .B(n255), .Y(n253) );
  INVX1 U523 ( .A(pcon[7]), .Y(n255) );
  NOR2X1 U524 ( .A(n221), .B(n490), .Y(n487) );
  INVX1 U525 ( .A(p3[1]), .Y(n490) );
  NOR2BX4 U526 ( .AN(out_acc_r[0]), .B(n264), .Y(n183) );
  OAI21X1 U527 ( .A0(n456), .A1(n457), .B0(n234), .Y(n455) );
  NOR2X1 U528 ( .A(n175), .B(n460), .Y(n456) );
  OAI22X1 U529 ( .A0(n235), .A1(n458), .B0(n237), .B1(n459), .Y(n457) );
  INVX1 U530 ( .A(scon[2]), .Y(n460) );
  OAI21X1 U531 ( .A0(n289), .A1(n290), .B0(n234), .Y(n288) );
  NOR2X1 U532 ( .A(n175), .B(n293), .Y(n289) );
  OAI22X1 U533 ( .A0(n235), .A1(n291), .B0(n237), .B1(n292), .Y(n290) );
  INVX1 U534 ( .A(scon[6]), .Y(n293) );
  AOI21X1 U535 ( .A0(tcon[4]), .A1(n259), .B0(n390), .Y(n380) );
  AOI21X1 U536 ( .A0(out_dptr_r[4]), .A1(n174), .B0(n388), .Y(n381) );
  AOI21X1 U537 ( .A0(p0[4]), .A1(n248), .B0(n384), .Y(n383) );
  AOI21X1 U538 ( .A0(tcon[1]), .A1(n259), .B0(n516), .Y(n504) );
  AOI21X1 U539 ( .A0(out_dptr_r[1]), .A1(n174), .B0(n514), .Y(n505) );
  AOI21X1 U540 ( .A0(p0[1]), .A1(n248), .B0(n508), .Y(n507) );
  AOI21X1 U541 ( .A0(tcon[6]), .A1(n259), .B0(n306), .Y(n296) );
  AOI21X1 U542 ( .A0(out_dptr_r[14]), .A1(n252), .B0(n302), .Y(n298) );
  AOI21X1 U543 ( .A0(out_dptr_r[6]), .A1(n174), .B0(n304), .Y(n297) );
  AOI21X1 U544 ( .A0(tcon[5]), .A1(n259), .B0(n348), .Y(n338) );
  AOI21X1 U545 ( .A0(out_dptr_r[13]), .A1(n252), .B0(n344), .Y(n340) );
  AOI21X1 U546 ( .A0(out_dptr_r[5]), .A1(n174), .B0(n346), .Y(n339) );
  AOI21X1 U547 ( .A0(tcon[2]), .A1(n259), .B0(n473), .Y(n463) );
  AOI21X1 U548 ( .A0(out_dptr_r[10]), .A1(n252), .B0(n469), .Y(n465) );
  AOI21X1 U549 ( .A0(out_dptr_r[2]), .A1(n174), .B0(n471), .Y(n464) );
  AOI21X1 U550 ( .A0(tcon[3]), .A1(n259), .B0(n431), .Y(n421) );
  AOI21X1 U551 ( .A0(out_dptr_r[3]), .A1(n174), .B0(n429), .Y(n422) );
  AOI21X1 U552 ( .A0(p0[3]), .A1(n248), .B0(n425), .Y(n424) );
  NOR2X1 U553 ( .A(n225), .B(n409), .Y(n402) );
  INVX1 U554 ( .A(tl1[3]), .Y(n409) );
  NOR2X1 U555 ( .A(n225), .B(n326), .Y(n319) );
  INVX1 U556 ( .A(tl1[5]), .Y(n326) );
  NOR2X1 U557 ( .A(n223), .B(n491), .Y(n486) );
  INVX1 U558 ( .A(tl0[1]), .Y(n491) );
  NOR2X1 U559 ( .A(n223), .B(n408), .Y(n403) );
  INVX1 U560 ( .A(tl0[3]), .Y(n408) );
  NOR2X1 U561 ( .A(n223), .B(n224), .Y(n216) );
  INVX1 U562 ( .A(tl0[7]), .Y(n224) );
  OAI21X1 U563 ( .A0(n229), .A1(n230), .B0(n231), .Y(n228) );
  INVX1 U564 ( .A(th1[7]), .Y(n230) );
  OAI21X1 U565 ( .A0(n232), .A1(n233), .B0(n234), .Y(n231) );
  NOR2X1 U566 ( .A(n175), .B(n239), .Y(n232) );
  NOR2X1 U567 ( .A(n269), .B(n395), .Y(n392) );
  CLKINVX1 U568 ( .A(out_psw[4]), .Y(n395) );
  INVX1 U569 ( .A(out_psw[1]), .Y(n523) );
  NOR2X1 U570 ( .A(n269), .B(n312), .Y(n309) );
  INVX1 U571 ( .A(out_psw[6]), .Y(n312) );
  NOR2X1 U572 ( .A(n269), .B(n354), .Y(n351) );
  INVX1 U573 ( .A(out_psw[5]), .Y(n354) );
  NOR2X1 U574 ( .A(n269), .B(n479), .Y(n476) );
  INVX1 U575 ( .A(out_psw[2]), .Y(n479) );
  CLKINVX1 U576 ( .A(out_psw[3]), .Y(n437) );
  NOR2X1 U577 ( .A(n221), .B(n222), .Y(n217) );
  NOR2X1 U578 ( .A(n225), .B(n226), .Y(n215) );
  INVX1 U579 ( .A(tl1[7]), .Y(n226) );
  NOR2X1 U580 ( .A(n261), .B(n262), .Y(n260) );
  INVX1 U581 ( .A(th0[7]), .Y(n262) );
  NOR2X1 U582 ( .A(n225), .B(n492), .Y(n485) );
  INVX1 U583 ( .A(tl1[1]), .Y(n492) );
  NOR2X1 U584 ( .A(n250), .B(n251), .Y(n249) );
  CLKINVX1 U585 ( .A(out_sp_r[7]), .Y(n251) );
  NOR2X1 U586 ( .A(n257), .B(n258), .Y(n256) );
  INVX1 U587 ( .A(tmod[7]), .Y(n258) );
  NOR2X1 U588 ( .A(n265), .B(n266), .Y(n263) );
  INVX1 U589 ( .A(out_b[7]), .Y(n268) );
  NOR2BX4 U590 ( .AN(out_b[0]), .B(n267), .Y(n184) );
  NAND2BX1 U591 ( .AN(n264), .B(out_acc_r[4]), .Y(n185) );
  NAND2BX1 U592 ( .AN(n264), .B(out_acc_r[1]), .Y(n186) );
  NAND2BX1 U593 ( .AN(n264), .B(out_acc_r[6]), .Y(n187) );
  NAND2BX1 U594 ( .AN(n264), .B(out_acc_r[5]), .Y(n188) );
  NAND2BX1 U595 ( .AN(n264), .B(out_acc_r[2]), .Y(n189) );
  NAND2BX1 U596 ( .AN(n264), .B(out_acc_r[3]), .Y(n190) );
  CLKINVX1 U597 ( .A(out_sp_r[0]), .Y(n536) );
  INVX1 U598 ( .A(th1[2]), .Y(n454) );
  CLKINVX1 U599 ( .A(out_sp_r[5]), .Y(n343) );
  CLKINVX1 U600 ( .A(out_sp_r[6]), .Y(n301) );
  CLKINVX1 U601 ( .A(out_sp_r[2]), .Y(n468) );
  NOR3BX1 U602 ( .AN(isrc_cur[2]), .B(isrc_cur[1]), .C(isrc_cur[0]), .Y(
        rst_tf1) );
  NOR3BX1 U603 ( .AN(isrc_cur[1]), .B(n2), .C(isrc_cur[2]), .Y(rst_ie1) );
  NOR3BX1 U604 ( .AN(isrc_cur[0]), .B(isrc_cur[2]), .C(isrc_cur[1]), .Y(
        rst_ie0) );
  NOR3BX1 U605 ( .AN(isrc_cur[1]), .B(isrc_cur[2]), .C(isrc_cur[0]), .Y(
        rst_tf0) );
  NOR2X1 U606 ( .A(n206), .B(n204), .Y(n535) );
  NAND2X1 U607 ( .A(n195), .B(n204), .Y(n541) );
  NOR3BX1 U608 ( .AN(n208), .B(n600), .C(addr_sfr[6]), .Y(n596) );
  NOR3X4 U609 ( .A(n593), .B(n206), .C(n570), .Y(n192) );
  CLKBUFX2 U610 ( .A(n201), .Y(n202) );
  NOR2X6 U611 ( .A(n207), .B(n197), .Y(n556) );
  NAND2X2 U612 ( .A(n213), .B(n214), .Y(n211) );
  NOR2X1 U613 ( .A(n221), .B(n407), .Y(n404) );
  OAI22X1 U614 ( .A0(n240), .A1(n378), .B0(n242), .B1(n379), .Y(n369) );
  OAI22X1 U615 ( .A0(n240), .A1(n502), .B0(n242), .B1(n503), .Y(n493) );
  NOR2X1 U616 ( .A(n242), .B(n572), .Y(n565) );
  NOR2X2 U617 ( .A(n228), .B(n227), .Y(n213) );
  NOR2X1 U618 ( .A(n223), .B(n283), .Y(n278) );
  NOR2X1 U619 ( .A(n223), .B(n325), .Y(n320) );
  NOR2X1 U620 ( .A(n221), .B(n282), .Y(n279) );
  NOR2X1 U621 ( .A(n221), .B(n324), .Y(n321) );
  OAI22X1 U622 ( .A0(n240), .A1(n294), .B0(n242), .B1(n295), .Y(n285) );
  OAI22X1 U623 ( .A0(n240), .A1(n336), .B0(n242), .B1(n337), .Y(n327) );
  OAI22X1 U624 ( .A0(n240), .A1(n461), .B0(n242), .B1(n462), .Y(n452) );
  OAI22X1 U625 ( .A0(n240), .A1(n419), .B0(n242), .B1(n420), .Y(n410) );
  OAI22X1 U626 ( .A0(n240), .A1(n241), .B0(n242), .B1(n243), .Y(n227) );
  CLKBUFX20 U627 ( .A(addr_sfr[3]), .Y(n206) );
  NAND2BX4 U628 ( .AN(n355), .B(n356), .Y(out_sfr_a[4]) );
  NOR3X6 U629 ( .A(n183), .B(n558), .C(n184), .Y(n135) );
  NAND2X6 U630 ( .A(n202), .B(n525), .Y(n101) );
endmodule


module one_shot_2 ( rst_p, clk, d, q );
  input rst_p, clk, d;
  output q;
  wire   n1, n2, n3;

  NOR2BX1 U6 ( .AN(d), .B(n2), .Y(q) );
  CLKINVX1 U7 ( .A(d), .Y(n3) );
  CLKINVX1 U8 ( .A(rst_p), .Y(n1) );
  DFFSX2 d_del_reg ( .D(n3), .CK(clk), .SN(n1), .QN(n2) );
endmodule


module one_shot_1 ( rst_p, clk, d, q );
  input rst_p, clk, d;
  output q;
  wire   n1, n2, n3;

  CLKINVX1 U6 ( .A(d), .Y(n3) );
  NOR2BX1 U7 ( .AN(d), .B(n2), .Y(q) );
  CLKINVX1 U8 ( .A(rst_p), .Y(n1) );
  DFFSX2 d_del_reg ( .D(n3), .CK(clk), .SN(n1), .QN(n2) );
endmodule


module u_int ( disint, end_instr, ti_ri, clk, rst_p, ex_int_a, ex_int_b, it_a, 
        it_b, tf_a, tf_b, ie_j, ie, ip, ie_a, ie_b, smpl_ex_a, smpl_ex_b, 
        int_vec, reti, isrc_cur, en_int );
  input [4:0] ie;
  input [4:0] ip;
  output [2:0] int_vec;
  output [2:0] isrc_cur;
  input disint, end_instr, ti_ri, clk, rst_p, ex_int_a, ex_int_b, it_a, it_b,
         tf_a, tf_b, ie_j, ie_a, ie_b, reti;
  output smpl_ex_a, smpl_ex_b, en_int;
  wire   s_oie_a, s_oie_b, N11, N12, N13, N14, N15, N18, N20, N21, N22, N23,
         N24, N25, n2, n3, n4, n5, n6, n7, n8, n9, n10, n110, n120, n130;
  wire   [4:0] int;

  ex_int_smpl_1 smpl0 ( .clk(clk), .ex_int(ex_int_a), .it(it_a), .rst_p(rst_p), 
        .oie(s_oie_a) );
  ex_int_smpl_0 smpl1 ( .clk(clk), .ex_int(ex_int_b), .it(it_b), .rst_p(rst_p), 
        .oie(s_oie_b) );
  mux2t1_1_1 ux0 ( .a(1'b0), .b(s_oie_a), .sel(it_a), .c(smpl_ex_a) );
  mux2t1_1_0 ux1 ( .a(1'b0), .b(s_oie_b), .sel(it_b), .c(smpl_ex_b) );
  priority prio ( .disint(disint), .ie(ie), .reti(reti), .clk(clk), .rst_p(
        rst_p), .int(int), .ip(ip), .ie7(ie_j), .int_vec(int_vec), .isrc_cur(
        isrc_cur), .en_int(en_int) );
  NOR2BX1 U21 ( .AN(ti_ri), .B(n3), .Y(N24) );
  NAND2BX1 U22 ( .AN(rst_p), .B(end_instr), .Y(n8) );
  OAI31X1 U23 ( .A0(n4), .A1(ie_b), .A2(ie_a), .B0(n5), .Y(n3) );
  NAND3BX1 U24 ( .AN(ti_ri), .B(n6), .C(n7), .Y(n4) );
  NOR3BX1 U25 ( .AN(ie_j), .B(rst_p), .C(reti), .Y(n5) );
  CLKINVX1 U26 ( .A(tf_a), .Y(n7) );
  NAND3BX1 U27 ( .AN(rst_p), .B(n2), .C(n3), .Y(N25) );
  CLKINVX1 U28 ( .A(reti), .Y(n2) );
  NOR2X1 U29 ( .A(n9), .B(n8), .Y(N15) );
  NOR2X1 U30 ( .A(n10), .B(n8), .Y(N14) );
  NOR2X1 U31 ( .A(n110), .B(n8), .Y(N13) );
  NOR2X1 U32 ( .A(n120), .B(n8), .Y(N12) );
  NOR2X1 U33 ( .A(n130), .B(n8), .Y(N11) );
  NAND2BX1 U34 ( .AN(rst_p), .B(n8), .Y(N18) );
  NOR2BX1 U35 ( .AN(tf_b), .B(n3), .Y(N23) );
  NOR2BX1 U36 ( .AN(ie_b), .B(n3), .Y(N22) );
  NOR2BX1 U37 ( .AN(tf_a), .B(n3), .Y(N21) );
  NOR2BX1 U38 ( .AN(ie_a), .B(n3), .Y(N20) );
  CLKINVX1 U39 ( .A(tf_b), .Y(n6) );
  TLATX1 int_reg_4_ ( .D(N15), .G(N18), .Q(int[4]) );
  TLATX1 int_reg_3_ ( .D(N14), .G(N18), .Q(int[3]) );
  TLATX1 int_reg_2_ ( .D(N13), .G(N18), .Q(int[2]) );
  TLATX1 int_reg_1_ ( .D(N12), .G(N18), .Q(int[1]) );
  TLATX1 int_reg_0_ ( .D(N11), .G(N18), .Q(int[0]) );
  TLATX1 latch_int_reg_4_ ( .D(N24), .G(N25), .QN(n9) );
  TLATX1 latch_int_reg_3_ ( .D(N23), .G(N25), .QN(n10) );
  TLATX1 latch_int_reg_2_ ( .D(N22), .G(N25), .QN(n110) );
  TLATX1 latch_int_reg_1_ ( .D(N21), .G(N25), .QN(n120) );
  TLATX1 latch_int_reg_0_ ( .D(N20), .G(N25), .QN(n130) );
endmodule


module ex_int_smpl_1 ( clk, ex_int, it, rst_p, lint, oie );
  input clk, ex_int, it, rst_p;
  output lint, oie;
  wire   tmp, tmp1, n2, n3, n4, n5, n6;

  AO22X1 U9 ( .A0(tmp), .A1(n2), .B0(it), .B1(n3), .Y(n6) );
  AO22X1 U10 ( .A0(tmp), .A1(it), .B0(tmp1), .B1(n2), .Y(n5) );
  XNOR2X1 U11 ( .A(it), .B(ex_int), .Y(lint) );
  NOR2BX1 U12 ( .AN(tmp), .B(tmp1), .Y(oie) );
  CLKINVX1 U13 ( .A(it), .Y(n2) );
  CLKINVX1 U14 ( .A(ex_int), .Y(n3) );
  CLKINVX1 U15 ( .A(rst_p), .Y(n4) );
  DFFRX1 tmp1_reg ( .D(n5), .CK(clk), .RN(n4), .Q(tmp1) );
  DFFRX1 tmp_reg ( .D(n6), .CK(clk), .RN(n4), .Q(tmp) );
endmodule


module ex_int_smpl_0 ( clk, ex_int, it, rst_p, lint, oie );
  input clk, ex_int, it, rst_p;
  output lint, oie;
  wire   tmp, tmp1, n2, n3, n4, n5, n6;

  AO22X1 U9 ( .A0(tmp), .A1(n2), .B0(it), .B1(n3), .Y(n6) );
  AO22X1 U10 ( .A0(tmp), .A1(it), .B0(tmp1), .B1(n2), .Y(n5) );
  XNOR2X1 U11 ( .A(it), .B(ex_int), .Y(lint) );
  NOR2BX1 U12 ( .AN(tmp), .B(tmp1), .Y(oie) );
  CLKINVX1 U13 ( .A(it), .Y(n2) );
  CLKINVX1 U14 ( .A(ex_int), .Y(n3) );
  CLKINVX1 U15 ( .A(rst_p), .Y(n4) );
  DFFRX1 tmp1_reg ( .D(n5), .CK(clk), .RN(n4), .Q(tmp1) );
  DFFRX1 tmp_reg ( .D(n6), .CK(clk), .RN(n4), .Q(tmp) );
endmodule


module mux2t1_1_1 ( a, b, sel, c );
  input a, b, sel;
  output c;
  wire   n2;

  AO22X1 U6 ( .A0(sel), .A1(b), .B0(a), .B1(n2), .Y(c) );
  CLKINVX1 U7 ( .A(sel), .Y(n2) );
endmodule


module mux2t1_1_0 ( a, b, sel, c );
  input a, b, sel;
  output c;
  wire   n2;

  AO22X1 U6 ( .A0(sel), .A1(b), .B0(a), .B1(n2), .Y(c) );
  CLKINVX1 U7 ( .A(sel), .Y(n2) );
endmodule


module priority ( disint, ie, reti, clk, rst_p, int, ip, ie7, int_vec, 
        isrc_cur, en_int );
  input [4:0] ie;
  input [4:0] int;
  input [4:0] ip;
  output [2:0] int_vec;
  output [2:0] isrc_cur;
  input disint, reti, clk, rst_p, ie7;
  output en_int;
  wire   int_proc, isrc, isrc0, isrc1, isrc2, isrc3, isrc4, N9, N10, N11,
         int_dept_1_, int_lev, int_lev0, int_lev1, int_lev2, reti1, N51, N99,
         N104, n2, n3, n4, n5, n6, n7, n8, n100, n110, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n34, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n510, n52, n53, n54, n55, n60, n61, n62, n63, n64, n65,
         n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84;
  wire   [1:0] cur_lev;

  one_shot_0 one_shot_reti ( .rst_p(rst_p), .clk(clk), .d(reti), .q(reti1) );
  CLKINVX1 U84 ( .A(n34), .Y(n32) );
  CLKINVX1 U85 ( .A(n100), .Y(n23) );
  CLKINVX1 U86 ( .A(n3), .Y(n4) );
  CLKINVX1 U87 ( .A(n12), .Y(n16) );
  CLKINVX1 U88 ( .A(n15), .Y(n17) );
  NAND2BX1 U89 ( .AN(n23), .B(n13), .Y(n34) );
  NAND2BX1 U90 ( .AN(n83), .B(n34), .Y(n3) );
  NAND2BX1 U91 ( .AN(n84), .B(n40), .Y(n100) );
  NAND2BX1 U92 ( .AN(disint), .B(n60), .Y(n510) );
  OAI33X1 U93 ( .A0(n100), .A1(n110), .A2(n12), .B0(n13), .B1(n14), .B2(n15), 
        .Y(n2) );
  OAI33X1 U94 ( .A0(n100), .A1(n110), .A2(n16), .B0(n13), .B1(n17), .B2(n14), 
        .Y(n5) );
  OR2X2 U95 ( .A(n32), .B(N51), .Y(n41) );
  CLKINVX1 U96 ( .A(n7), .Y(n8) );
  AO22X2 U97 ( .A0(n83), .A1(n84), .B0(n38), .B1(n39), .Y(n73) );
  CLKINVX1 U98 ( .A(n84), .Y(n39) );
  OAI221X1 U99 ( .A0(n40), .A1(n32), .B0(n83), .B1(n34), .C0(n41), .Y(n38) );
  CLKINVX1 U100 ( .A(n44), .Y(n40) );
  CLKINVX1 U101 ( .A(n13), .Y(n25) );
  NAND2BX1 U102 ( .AN(n26), .B(n28), .Y(n15) );
  NAND2X1 U103 ( .A(n22), .B(n30), .Y(n12) );
  DFFRX1 int_dept_reg_0_ ( .D(n73), .CK(clk), .RN(n60), .Q(N51), .QN(n83) );
  CLKINVX1 U104 ( .A(n19), .Y(n110) );
  CLKINVX1 U105 ( .A(n30), .Y(n29) );
  CLKINVX1 U106 ( .A(n18), .Y(n14) );
  OAI21X1 U107 ( .A0(en_int), .A1(n45), .B0(n46), .Y(n44) );
  OAI31X1 U108 ( .A0(n47), .A1(cur_lev[1]), .A2(cur_lev[0]), .B0(int_proc), 
        .Y(n45) );
  CLKINVX1 U109 ( .A(ie7), .Y(n47) );
  NAND2BX1 U110 ( .AN(N51), .B(n34), .Y(n7) );
  OAI211X1 U111 ( .A0(n42), .A1(n15), .B0(n43), .C0(n44), .Y(n13) );
  NOR3BX1 U112 ( .AN(ie7), .B(n84), .C(int_proc), .Y(n43) );
  CLKINVX1 U113 ( .A(n48), .Y(en_int) );
  OAI211X1 U114 ( .A0(n46), .A1(n79), .B0(ie7), .C0(n49), .Y(n48) );
  AOI31X1 U115 ( .A0(n17), .A1(n79), .A2(n50), .B0(n510), .Y(n49) );
  CLKINVX1 U116 ( .A(n42), .Y(n50) );
  NOR2BX1 U117 ( .AN(n7), .B(n61), .Y(n76) );
  NOR2BX1 U118 ( .AN(n3), .B(n62), .Y(n78) );
  NAND2BX1 U119 ( .AN(n31), .B(n32), .Y(n63) );
  AOI31X1 U120 ( .A0(n84), .A1(n82), .A2(N51), .B0(n79), .Y(n31) );
  AO22X2 U121 ( .A0(n2), .A1(n83), .B0(isrc2), .B1(n7), .Y(n66) );
  AO22X2 U122 ( .A0(n2), .A1(N51), .B0(isrc), .B1(n3), .Y(n69) );
  AO22X2 U123 ( .A0(isrc4), .A1(n7), .B0(n8), .B1(n6), .Y(n64) );
  AO22X2 U124 ( .A0(isrc3), .A1(n7), .B0(n8), .B1(n5), .Y(n65) );
  AO22X2 U125 ( .A0(isrc1), .A1(n3), .B0(n4), .B1(n6), .Y(n67) );
  AO22X2 U126 ( .A0(isrc0), .A1(n3), .B0(n4), .B1(n5), .Y(n68) );
  AO21X2 U127 ( .A0(int_vec[0]), .A1(n84), .B0(n6), .Y(n70) );
  AO21X2 U128 ( .A0(int_vec[1]), .A1(n84), .B0(n5), .Y(n71) );
  AO21X2 U129 ( .A0(int_vec[2]), .A1(n84), .B0(n2), .Y(n72) );
  OAI222X1 U130 ( .A0(n25), .A1(n80), .B0(n83), .B1(n80), .C0(N51), .C1(n100), 
        .Y(n75) );
  OAI222X1 U131 ( .A0(n25), .A1(n81), .B0(N51), .B1(n81), .C0(n83), .C1(n100), 
        .Y(n77) );
  OAI221X1 U132 ( .A0(n100), .A1(n19), .B0(n13), .B1(n18), .C0(n20), .Y(n6) );
  AOI32X1 U133 ( .A0(n21), .A1(n22), .A2(n23), .B0(n24), .B1(n25), .Y(n20) );
  NAND4BX1 U134 ( .AN(n29), .B(int[3]), .C(ip[3]), .D(ie[3]), .Y(n21) );
  OA21X2 U135 ( .A0(n26), .A1(n27), .B0(n28), .Y(n24) );
  OAI31X1 U136 ( .A0(n34), .A1(n84), .A2(n82), .B0(n37), .Y(n74) );
  AOI22X1 U137 ( .A0(N99), .A1(n84), .B0(N104), .B1(n23), .Y(n37) );
  XNOR2X1 U138 ( .A(N51), .B(n82), .Y(N104) );
  XNOR2X1 U139 ( .A(int_dept_1_), .B(N51), .Y(N99) );
  NAND3BX1 U140 ( .AN(ip[0]), .B(ie[0]), .C(int[0]), .Y(n18) );
  NAND3X1 U141 ( .A(ie[1]), .B(int[1]), .C(ip[1]), .Y(n22) );
  OAI211X1 U142 ( .A0(n52), .A1(n53), .B0(n27), .C0(n18), .Y(n42) );
  CLKINVX1 U143 ( .A(int[4]), .Y(n52) );
  NAND2BX1 U144 ( .AN(ip[4]), .B(ie[4]), .Y(n53) );
  NAND3BX1 U145 ( .AN(n110), .B(n55), .C(n16), .Y(n46) );
  AOI33X1 U146 ( .A0(int[4]), .A1(ie[4]), .A2(ip[4]), .B0(int[3]), .B1(ie[3]), 
        .B2(ip[3]), .Y(n55) );
  NAND3BX1 U147 ( .AN(ip[3]), .B(ie[3]), .C(int[3]), .Y(n27) );
  CLKBUFX2 U148 ( .A(reti1), .Y(n84) );
  CLKINVX1 U149 ( .A(n54), .Y(n26) );
  NAND3BX1 U150 ( .AN(ip[2]), .B(ie[2]), .C(int[2]), .Y(n54) );
  NOR2BX1 U151 ( .AN(N11), .B(n79), .Y(isrc_cur[0]) );
  NOR2BX1 U152 ( .AN(N9), .B(n79), .Y(isrc_cur[2]) );
  NOR2BX1 U153 ( .AN(N10), .B(n79), .Y(isrc_cur[1]) );
  NAND3X1 U154 ( .A(ie[2]), .B(int[2]), .C(ip[2]), .Y(n30) );
  CLKINVX1 U155 ( .A(rst_p), .Y(n60) );
  NAND3X1 U156 ( .A(ie[0]), .B(int[0]), .C(ip[0]), .Y(n19) );
  NAND3BX1 U157 ( .AN(ip[1]), .B(ie[1]), .C(int[1]), .Y(n28) );
  DFFRX1 int_proc_reg ( .D(n63), .CK(clk), .RN(n60), .Q(int_proc), .QN(n79) );
  DFFRX1 int_lev_reg ( .D(n75), .CK(clk), .RN(n60), .Q(int_lev2), .QN(n80) );
  DFFRX1 int_lev_reg0 ( .D(n77), .CK(clk), .RN(n60), .Q(int_lev0), .QN(n81) );
  DFFRX1 int_lev_reg1 ( .D(n76), .CK(clk), .RN(n60), .Q(int_lev1), .QN(n61) );
  DFFRX1 int_lev_reg2 ( .D(n78), .CK(clk), .RN(n60), .Q(int_lev), .QN(n62) );
  DFFRX1 int_dept_reg_1_ ( .D(n74), .CK(clk), .RN(n60), .Q(int_dept_1_), .QN(
        n82) );
  DFFRX1 isrc_reg ( .D(n64), .CK(clk), .RN(n60), .Q(isrc4) );
  DFFRX1 isrc_reg0 ( .D(n65), .CK(clk), .RN(n60), .Q(isrc3) );
  DFFRX1 isrc_reg1 ( .D(n66), .CK(clk), .RN(n60), .Q(isrc2) );
  DFFRX1 isrc_reg2 ( .D(n67), .CK(clk), .RN(n60), .Q(isrc1) );
  DFFRX1 isrc_reg3 ( .D(n68), .CK(clk), .RN(n60), .Q(isrc0) );
  DFFRX1 isrc_reg4 ( .D(n69), .CK(clk), .RN(n60), .Q(isrc) );
  DFFRX1 int_vec_reg_0_ ( .D(n70), .CK(clk), .RN(n60), .Q(int_vec[0]) );
  DFFRX1 int_vec_reg_1_ ( .D(n71), .CK(clk), .RN(n60), .Q(int_vec[1]) );
  DFFRX1 int_vec_reg_2_ ( .D(n72), .CK(clk), .RN(n60), .Q(int_vec[2]) );
  priority_MUX_OP_2_1_5 U16 ( .D0_0(int_lev1), .D0_1(int_lev2), .D0_2(isrc2), 
        .D0_3(isrc3), .D0_4(isrc4), .D1_0(int_lev), .D1_1(int_lev0), .D1_2(
        isrc), .D1_3(isrc0), .D1_4(isrc1), .S0(n83), .Z_0(cur_lev[1]), .Z_1(
        cur_lev[0]), .Z_2(N9), .Z_3(N10), .Z_4(N11) );
endmodule


module priority_MUX_OP_2_1_5 ( D0_0, D0_1, D0_2, D0_3, D0_4, D1_0, D1_1, D1_2, 
        D1_3, D1_4, S0, Z_0, Z_1, Z_2, Z_3, Z_4 );
  input D0_0, D0_1, D0_2, D0_3, D0_4, D1_0, D1_1, D1_2, D1_3, D1_4, S0;
  output Z_0, Z_1, Z_2, Z_3, Z_4;


  MX2X2 U6 ( .S0(S0), .B(D1_0), .A(D0_0), .Y(Z_0) );
  MX2X2 U7 ( .S0(S0), .B(D1_4), .A(D0_4), .Y(Z_4) );
  MX2X2 U8 ( .S0(S0), .B(D1_2), .A(D0_2), .Y(Z_2) );
  MX2X2 U9 ( .S0(S0), .B(D1_3), .A(D0_3), .Y(Z_3) );
  MX2X2 U10 ( .S0(S0), .B(D1_1), .A(D0_1), .Y(Z_1) );
endmodule


module one_shot_0 ( rst_p, clk, d, q );
  input rst_p, clk, d;
  output q;
  wire   n1, n2, n3;

  CLKINVX1 U6 ( .A(d), .Y(n3) );
  NOR2BX1 U7 ( .AN(d), .B(n2), .Y(q) );
  CLKINVX1 U8 ( .A(rst_p), .Y(n1) );
  DFFSX2 d_del_reg ( .D(n3), .CK(clk), .SN(n1), .QN(n2) );
endmodule


module b ( clk, rst_p, in_b, in_dat, addr_b, wr, ld_b, out_b );
  input [7:0] in_b;
  input [7:0] in_dat;
  input [7:0] addr_b;
  output [7:0] out_b;
  input clk, rst_p, wr, ld_b;
  wire   n3, n5, n6, n7, n8, n9, n10, n11, n16, n17, n18, n19, n20, n21, n22,
         n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50,
         n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64,
         n65, n66, n67;

  INVX1 U27 ( .A(n47), .Y(n46) );
  AND2X1 U28 ( .A(out_b[0]), .B(n28), .Y(n27) );
  DFFRX1 out_b_reg_4_ ( .D(n23), .CK(clk), .RN(n18), .Q(out_b[4]) );
  DFFRX1 out_b_reg_7_ ( .D(n26), .CK(clk), .RN(n18), .Q(out_b[7]) );
  OAI22X2 U29 ( .A0(in_b[1]), .A1(n61), .B0(n61), .B1(ld_b), .Y(n54) );
  INVX1 U30 ( .A(n62), .Y(n61) );
  INVX3 U31 ( .A(n60), .Y(n58) );
  OAI22X2 U32 ( .A0(in_b[7]), .A1(n36), .B0(n36), .B1(ld_b), .Y(n34) );
  INVX1 U33 ( .A(n37), .Y(n36) );
  OAI22X2 U34 ( .A0(in_b[6]), .A1(n40), .B0(n40), .B1(ld_b), .Y(n33) );
  INVX1 U35 ( .A(n41), .Y(n40) );
  OAI22X2 U36 ( .A0(in_b[5]), .A1(n43), .B0(n43), .B1(ld_b), .Y(n32) );
  INVX1 U37 ( .A(n44), .Y(n43) );
  OAI22X2 U38 ( .A0(in_b[3]), .A1(n49), .B0(n49), .B1(ld_b), .Y(n30) );
  INVX1 U39 ( .A(n50), .Y(n49) );
  NAND2X2 U40 ( .A(in_b[0]), .B(ld_b), .Y(n60) );
  OAI22X2 U41 ( .A0(in_b[4]), .A1(n46), .B0(n46), .B1(ld_b), .Y(n31) );
  CLKINVX1 U42 ( .A(ld_b), .Y(n17) );
  NAND2X1 U43 ( .A(in_dat[1]), .B(n38), .Y(n62) );
  CLKINVX1 U44 ( .A(n59), .Y(n38) );
  AND2X2 U45 ( .A(n17), .B(n59), .Y(n28) );
  NAND2X1 U46 ( .A(in_dat[7]), .B(n38), .Y(n37) );
  NAND2X1 U47 ( .A(in_dat[6]), .B(n38), .Y(n41) );
  NAND2X1 U48 ( .A(in_dat[5]), .B(n38), .Y(n44) );
  OAI22X1 U49 ( .A0(in_b[2]), .A1(n52), .B0(n52), .B1(ld_b), .Y(n29) );
  CLKINVX1 U50 ( .A(n53), .Y(n52) );
  NAND2X1 U51 ( .A(in_dat[2]), .B(n38), .Y(n53) );
  NAND2X1 U52 ( .A(in_dat[3]), .B(n38), .Y(n50) );
  NAND3X1 U53 ( .A(n63), .B(n64), .C(n65), .Y(n59) );
  NOR2X1 U54 ( .A(addr_b[3]), .B(addr_b[2]), .Y(n63) );
  NOR2X1 U55 ( .A(n66), .B(n67), .Y(n65) );
  NAND2X1 U56 ( .A(wr), .B(n17), .Y(n67) );
  NAND2X1 U57 ( .A(n16), .B(addr_b[7]), .Y(n66) );
  AND2X1 U58 ( .A(addr_b[5]), .B(addr_b[4]), .Y(n16) );
  NOR2X1 U59 ( .A(n56), .B(n57), .Y(n19) );
  NOR3X1 U60 ( .A(n58), .B(n38), .C(n27), .Y(n56) );
  NOR3X1 U61 ( .A(n58), .B(in_dat[0]), .C(n27), .Y(n57) );
  NAND2X1 U62 ( .A(in_dat[4]), .B(n38), .Y(n47) );
  NAND2X1 U63 ( .A(n54), .B(n55), .Y(n20) );
  NAND2X1 U64 ( .A(out_b[1]), .B(n28), .Y(n55) );
  NAND2X1 U65 ( .A(n29), .B(n51), .Y(n21) );
  NAND2X1 U66 ( .A(out_b[2]), .B(n28), .Y(n51) );
  NAND2X1 U67 ( .A(n31), .B(n45), .Y(n23) );
  NAND2X1 U68 ( .A(out_b[4]), .B(n28), .Y(n45) );
  NAND2X1 U69 ( .A(n32), .B(n42), .Y(n24) );
  NAND2X1 U70 ( .A(out_b[5]), .B(n28), .Y(n42) );
  NAND2X1 U71 ( .A(n33), .B(n39), .Y(n25) );
  NAND2X1 U72 ( .A(out_b[6]), .B(n28), .Y(n39) );
  NAND2X1 U73 ( .A(n34), .B(n35), .Y(n26) );
  NAND2X1 U74 ( .A(out_b[7]), .B(n28), .Y(n35) );
  NAND2X1 U75 ( .A(n30), .B(n48), .Y(n22) );
  NAND2X1 U76 ( .A(out_b[3]), .B(n28), .Y(n48) );
  CLKINVX1 U77 ( .A(rst_p), .Y(n18) );
  DFFRX1 out_b_reg_6_ ( .D(n25), .CK(clk), .RN(n18), .Q(out_b[6]) );
  DFFRX1 out_b_reg_3_ ( .D(n22), .CK(clk), .RN(n18), .Q(out_b[3]) );
  DFFRX1 out_b_reg_2_ ( .D(n21), .CK(clk), .RN(n18), .Q(out_b[2]) );
  DFFRX1 out_b_reg_5_ ( .D(n24), .CK(clk), .RN(n18), .Q(out_b[5]) );
  DFFRX1 out_b_reg_1_ ( .D(n20), .CK(clk), .RN(n18), .Q(out_b[1]) );
  DFFRX1 out_b_reg_0_ ( .D(n19), .CK(clk), .RN(n18), .Q(out_b[0]) );
  NOR3BX1 U78 ( .AN(addr_b[6]), .B(addr_b[1]), .C(addr_b[0]), .Y(n64) );
  INVX8 U79 ( .A(n29), .Y(n9) );
  INVX8 U80 ( .A(n30), .Y(n8) );
  INVX8 U81 ( .A(n31), .Y(n7) );
  INVX8 U82 ( .A(n32), .Y(n6) );
  INVX8 U83 ( .A(n33), .Y(n5) );
  INVX8 U84 ( .A(n34), .Y(n3) );
  AOI2BB2X4 U85 ( .A0N(in_dat[0]), .A1N(n58), .B0(n59), .B1(n60), .Y(n11) );
  INVX8 U86 ( .A(n54), .Y(n10) );
endmodule


module parity_gen ( p_acc, parity );
  input [7:0] p_acc;
  output parity;
  wire   n5, n6, n7, n8, n9, n10;

  XNOR2X1 U6 ( .A(n5), .B(n6), .Y(parity) );
  XNOR2X1 U7 ( .A(p_acc[5]), .B(p_acc[4]), .Y(n10) );
  XNOR2X1 U8 ( .A(p_acc[3]), .B(p_acc[2]), .Y(n8) );
  XNOR2X1 U9 ( .A(n7), .B(n8), .Y(n6) );
  XNOR2X1 U10 ( .A(n9), .B(n10), .Y(n5) );
  XNOR2X1 U11 ( .A(p_acc[1]), .B(p_acc[0]), .Y(n7) );
  XOR2X1 U12 ( .A(p_acc[7]), .B(p_acc[6]), .Y(n9) );
endmodule


module acc ( clk, rst_p, ld_acc, ld_acc_chd, wr, addr_acc, in_acc, acc_chd, 
        out_acc_r );
  input [7:0] addr_acc;
  input [7:0] in_acc;
  input [7:0] acc_chd;
  output [7:0] out_acc_r;
  input clk, rst_p, ld_acc, ld_acc_chd, wr;
  wire   n12, n19, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46,
         n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
         n61, n62, n63, n64, n65, n66;

  OA21X2 U30 ( .A0(ld_acc_chd), .A1(n35), .B0(n58), .Y(n30) );
  CLKINVX1 U31 ( .A(addr_acc[7]), .Y(n66) );
  NAND2X1 U32 ( .A(ld_acc_chd), .B(n58), .Y(n36) );
  CLKINVX1 U33 ( .A(n59), .Y(n35) );
  CLKINVX1 U34 ( .A(ld_acc), .Y(n58) );
  NAND2X1 U35 ( .A(acc_chd[0]), .B(n61), .Y(n60) );
  CLKINVX1 U36 ( .A(n36), .Y(n61) );
  NOR3X1 U37 ( .A(addr_acc[4]), .B(addr_acc[3]), .C(addr_acc[2]), .Y(n31) );
  NAND2X1 U38 ( .A(n62), .B(n63), .Y(n59) );
  NOR2X1 U39 ( .A(ld_acc_chd), .B(ld_acc), .Y(n62) );
  NAND4X1 U40 ( .A(wr), .B(n64), .C(n31), .D(n65), .Y(n63) );
  NOR2X1 U41 ( .A(addr_acc[0]), .B(n66), .Y(n64) );
  AOI22X1 U42 ( .A0(n30), .A1(n56), .B0(n56), .B1(n57), .Y(n22) );
  INVX1 U43 ( .A(n12), .Y(n56) );
  CLKINVX1 U44 ( .A(in_acc[0]), .Y(n57) );
  OAI21X1 U45 ( .A0(n59), .A1(n32), .B0(n60), .Y(n12) );
  OAI21X1 U46 ( .A0(n30), .A1(n53), .B0(n54), .Y(n23) );
  AOI2BB2X1 U47 ( .A0N(n36), .A1N(n55), .B0(out_acc_r[1]), .B1(n35), .Y(n54)
         );
  CLKINVX1 U48 ( .A(in_acc[1]), .Y(n53) );
  CLKINVX1 U49 ( .A(acc_chd[1]), .Y(n55) );
  OAI21X1 U50 ( .A0(n30), .A1(n50), .B0(n51), .Y(n24) );
  AOI2BB2X1 U51 ( .A0N(n36), .A1N(n52), .B0(out_acc_r[2]), .B1(n35), .Y(n51)
         );
  CLKINVX1 U52 ( .A(in_acc[2]), .Y(n50) );
  CLKINVX1 U53 ( .A(acc_chd[2]), .Y(n52) );
  OAI21X1 U54 ( .A0(n30), .A1(n47), .B0(n48), .Y(n25) );
  AOI2BB2X1 U55 ( .A0N(n36), .A1N(n49), .B0(out_acc_r[3]), .B1(n35), .Y(n48)
         );
  CLKINVX1 U56 ( .A(in_acc[3]), .Y(n47) );
  CLKINVX1 U57 ( .A(acc_chd[3]), .Y(n49) );
  OAI21X1 U58 ( .A0(n30), .A1(n44), .B0(n45), .Y(n26) );
  AOI2BB2X1 U59 ( .A0N(n36), .A1N(n46), .B0(out_acc_r[4]), .B1(n35), .Y(n45)
         );
  CLKINVX1 U60 ( .A(in_acc[4]), .Y(n44) );
  CLKINVX1 U61 ( .A(acc_chd[4]), .Y(n46) );
  OAI21X1 U62 ( .A0(n30), .A1(n38), .B0(n39), .Y(n28) );
  AOI2BB2X1 U63 ( .A0N(n36), .A1N(n40), .B0(out_acc_r[6]), .B1(n35), .Y(n39)
         );
  CLKINVX1 U64 ( .A(in_acc[6]), .Y(n38) );
  CLKINVX1 U65 ( .A(acc_chd[6]), .Y(n40) );
  OAI21X1 U66 ( .A0(n30), .A1(n33), .B0(n34), .Y(n29) );
  AOI2BB2X1 U67 ( .A0N(n36), .A1N(n37), .B0(out_acc_r[7]), .B1(n35), .Y(n34)
         );
  CLKINVX1 U68 ( .A(in_acc[7]), .Y(n33) );
  CLKINVX1 U69 ( .A(acc_chd[7]), .Y(n37) );
  OAI21X1 U70 ( .A0(n30), .A1(n41), .B0(n42), .Y(n27) );
  AOI2BB2X1 U71 ( .A0N(n36), .A1N(n43), .B0(out_acc_r[5]), .B1(n35), .Y(n42)
         );
  CLKINVX1 U72 ( .A(in_acc[5]), .Y(n41) );
  CLKINVX1 U73 ( .A(acc_chd[5]), .Y(n43) );
  CLKINVX1 U74 ( .A(rst_p), .Y(n21) );
  NOR2X1 U75 ( .A(addr_acc[1]), .B(n19), .Y(n65) );
  NAND2X1 U76 ( .A(addr_acc[6]), .B(addr_acc[5]), .Y(n19) );
  DFFRX4 out_acc_r_reg_7_ ( .D(n29), .CK(clk), .RN(n21), .Q(out_acc_r[7]) );
  DFFRX4 out_acc_r_reg_6_ ( .D(n28), .CK(clk), .RN(n21), .Q(out_acc_r[6]) );
  DFFRX4 out_acc_r_reg_5_ ( .D(n27), .CK(clk), .RN(n21), .Q(out_acc_r[5]) );
  DFFRX4 out_acc_r_reg_4_ ( .D(n26), .CK(clk), .RN(n21), .Q(out_acc_r[4]) );
  DFFRX4 out_acc_r_reg_3_ ( .D(n25), .CK(clk), .RN(n21), .Q(out_acc_r[3]) );
  DFFRX4 out_acc_r_reg_2_ ( .D(n24), .CK(clk), .RN(n21), .Q(out_acc_r[2]) );
  DFFRX4 out_acc_r_reg_1_ ( .D(n23), .CK(clk), .RN(n21), .Q(out_acc_r[1]) );
  DFFRX4 out_acc_r_reg_0_ ( .D(n22), .CK(clk), .RN(n21), .Q(out_acc_r[0]), 
        .QN(n32) );
endmodule


module psw ( rst_p, in_psw, clk, addr_psw, wr, in_cy_bit, set_c, rst_c, cpl_c, 
        ld_c, set_ac, rst_ac, set_v, rst_v, parity, out_psw );
  input [6:0] in_psw;
  input [7:0] addr_psw;
  output [7:0] out_psw;
  input rst_p, clk, wr, in_cy_bit, set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac,
         set_v, rst_v, parity;
  wire   y, n2, n3, n4, n9, n10, n11, n12, n16, n17, n18, n19, n20, n21, n22,
         n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n4500, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60;

  mux2t1_1_2 u0 ( .a(in_psw[6]), .b(n24), .sel(cpl_c), .c(y) );
  NOR2X2 U27 ( .A(rst_p), .B(n60), .Y(out_psw[0]) );
  INVX1 U28 ( .A(parity), .Y(n60) );
  CLKINVX1 U29 ( .A(n12), .Y(n52) );
  NAND3X1 U30 ( .A(n32), .B(n3), .C(n2), .Y(n44) );
  CLKINVX1 U31 ( .A(set_v), .Y(n53) );
  NOR2BX1 U32 ( .AN(n42), .B(n43), .Y(n17) );
  INVX1 U33 ( .A(rst_c), .Y(n42) );
  NOR2X1 U34 ( .A(n44), .B(set_c), .Y(n43) );
  CLKINVX1 U35 ( .A(n50), .Y(n34) );
  NAND2X1 U36 ( .A(in_psw[1]), .B(n34), .Y(n51) );
  NAND2X1 U37 ( .A(in_psw[5]), .B(n34), .Y(n40) );
  NAND3X1 U38 ( .A(n34), .B(n48), .C(y), .Y(n3) );
  INVX1 U39 ( .A(n4500), .Y(n2) );
  CLKINVX1 U40 ( .A(ld_c), .Y(n48) );
  NAND3X1 U41 ( .A(n55), .B(n56), .C(n57), .Y(n50) );
  NOR3X1 U42 ( .A(addr_psw[3]), .B(addr_psw[5]), .C(addr_psw[2]), .Y(n56) );
  NOR2X1 U43 ( .A(n58), .B(n59), .Y(n57) );
  CLKINVX1 U44 ( .A(wr), .Y(n58) );
  CLKINVX1 U45 ( .A(n32), .Y(n31) );
  NOR2X1 U46 ( .A(rst_v), .B(n35), .Y(n22) );
  CLKINVX1 U47 ( .A(n11), .Y(n35) );
  NAND2X1 U48 ( .A(n51), .B(n52), .Y(n11) );
  MXI2X1 U49 ( .S0(cpl_c), .B(n47), .A(n46), .Y(n4500) );
  NAND2X1 U50 ( .A(ld_c), .B(in_cy_bit), .Y(n46) );
  INVX1 U51 ( .A(y), .Y(n47) );
  NOR2X1 U52 ( .A(rst_ac), .B(n39), .Y(n18) );
  INVX1 U53 ( .A(n9), .Y(n39) );
  NAND2X1 U54 ( .A(n40), .B(n41), .Y(n9) );
  NAND2X1 U55 ( .A(n49), .B(n50), .Y(n32) );
  NOR3X1 U56 ( .A(ld_c), .B(n24), .C(cpl_c), .Y(n49) );
  MXI2X1 U57 ( .S0(n34), .B(n33), .A(n25), .Y(n23) );
  CLKINVX1 U58 ( .A(in_psw[0]), .Y(n33) );
  MXI2X1 U59 ( .S0(n34), .B(n36), .A(n27), .Y(n21) );
  CLKINVX1 U60 ( .A(in_psw[2]), .Y(n36) );
  MXI2X1 U61 ( .S0(n34), .B(n37), .A(n28), .Y(n20) );
  CLKINVX1 U62 ( .A(in_psw[3]), .Y(n37) );
  OAI21X1 U63 ( .A0(n34), .A1(n26), .B0(n53), .Y(n12) );
  MXI2X1 U64 ( .S0(n34), .B(n38), .A(n29), .Y(n19) );
  CLKINVX1 U65 ( .A(in_psw[4]), .Y(n38) );
  INVX1 U66 ( .A(n10), .Y(n41) );
  OAI21X1 U67 ( .A0(n34), .A1(n30), .B0(n54), .Y(n10) );
  CLKINVX1 U68 ( .A(set_ac), .Y(n54) );
  CLKINVX1 U69 ( .A(rst_p), .Y(n16) );
  DFFRX1 out_psw_reg_1_ ( .D(n23), .CK(clk), .RN(n16), .Q(out_psw[1]), .QN(n25) );
  DFFRX1 out_psw_reg_5_ ( .D(n19), .CK(clk), .RN(n16), .Q(out_psw[5]), .QN(n29) );
  DFFRX1 out_psw_reg_2_ ( .D(n22), .CK(clk), .RN(n16), .Q(out_psw[2]), .QN(n26) );
  NOR2X1 U70 ( .A(addr_psw[1]), .B(addr_psw[0]), .Y(n55) );
  NAND3X1 U71 ( .A(addr_psw[6]), .B(addr_psw[7]), .C(addr_psw[4]), .Y(n59) );
  NOR2X8 U72 ( .A(set_c), .B(n31), .Y(n4) );
  DFFRX4 out_psw_reg_3_ ( .D(n21), .CK(clk), .RN(n16), .Q(out_psw[3]), .QN(n27) );
  DFFRX4 out_psw_reg_4_ ( .D(n20), .CK(clk), .RN(n16), .Q(out_psw[4]), .QN(n28) );
  DFFRX4 out_psw_reg_6_ ( .D(n18), .CK(clk), .RN(n16), .Q(out_psw[6]), .QN(n30) );
  DFFRX4 out_psw_reg_7_ ( .D(n17), .CK(clk), .RN(n16), .Q(out_psw[7]), .QN(n24) );
endmodule


module mux2t1_1_2 ( a, b, sel, c );
  input a, b, sel;
  output c;
  wire   n3, n4;

  MXI2X1 U6 ( .S0(sel), .B(n4), .A(n3), .Y(c) );
  CLKINVX1 U7 ( .A(b), .Y(n4) );
  CLKINVX1 U8 ( .A(a), .Y(n3) );
endmodule


module ip ( clk, rst_p, in_ip, addr_ip, wr, out_ip );
  input [7:0] in_ip;
  input [7:0] addr_ip;
  output [7:0] out_ip;
  input clk, rst_p, wr;
  wire   n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35;

  NOR2X1 U15 ( .A(n31), .B(n32), .Y(n23) );
  NAND4X1 U16 ( .A(addr_ip[5]), .B(addr_ip[7]), .C(addr_ip[4]), .D(wr), .Y(n32) );
  NAND4X1 U17 ( .A(addr_ip[3]), .B(n33), .C(n34), .D(n35), .Y(n31) );
  CLKINVX1 U18 ( .A(addr_ip[0]), .Y(n33) );
  DFFRX1 out_ip_reg_3_ ( .D(n9), .CK(clk), .RN(n5), .Q(out_ip[3]), .QN(n18) );
  DFFRX1 out_ip_reg_4_ ( .D(n10), .CK(clk), .RN(n5), .Q(out_ip[4]), .QN(n17)
         );
  MXI2X1 U19 ( .S0(n23), .B(n26), .A(n21), .Y(n6) );
  CLKINVX1 U20 ( .A(in_ip[0]), .Y(n26) );
  MXI2X1 U21 ( .S0(n23), .B(n25), .A(n20), .Y(n7) );
  CLKINVX1 U22 ( .A(in_ip[1]), .Y(n25) );
  MXI2X1 U23 ( .S0(n23), .B(n24), .A(n19), .Y(n8) );
  CLKINVX1 U24 ( .A(in_ip[2]), .Y(n24) );
  MXI2X1 U25 ( .S0(n23), .B(n22), .A(n18), .Y(n9) );
  CLKINVX1 U26 ( .A(in_ip[3]), .Y(n22) );
  MXI2X1 U27 ( .S0(n23), .B(n30), .A(n17), .Y(n10) );
  CLKINVX1 U28 ( .A(in_ip[4]), .Y(n30) );
  MXI2X1 U29 ( .S0(n23), .B(n28), .A(n15), .Y(n12) );
  CLKINVX1 U30 ( .A(in_ip[6]), .Y(n28) );
  MXI2X1 U31 ( .S0(n23), .B(n27), .A(n14), .Y(n13) );
  CLKINVX1 U32 ( .A(in_ip[7]), .Y(n27) );
  MXI2X1 U33 ( .S0(n23), .B(n29), .A(n16), .Y(n11) );
  CLKINVX1 U34 ( .A(in_ip[5]), .Y(n29) );
  CLKINVX1 U35 ( .A(rst_p), .Y(n5) );
  DFFRX1 out_ip_reg_0_ ( .D(n6), .CK(clk), .RN(n5), .Q(out_ip[0]), .QN(n21) );
  DFFRX1 out_ip_reg_1_ ( .D(n7), .CK(clk), .RN(n5), .Q(out_ip[1]), .QN(n20) );
  DFFRX1 out_ip_reg_7_ ( .D(n13), .CK(clk), .RN(n5), .Q(out_ip[7]), .QN(n14)
         );
  DFFRX1 out_ip_reg_2_ ( .D(n8), .CK(clk), .RN(n5), .Q(out_ip[2]), .QN(n19) );
  DFFRX1 out_ip_reg_5_ ( .D(n11), .CK(clk), .RN(n5), .Q(out_ip[5]), .QN(n16)
         );
  DFFRX1 out_ip_reg_6_ ( .D(n12), .CK(clk), .RN(n5), .Q(out_ip[6]), .QN(n15)
         );
  CLKINVX1 U36 ( .A(addr_ip[1]), .Y(n35) );
  NOR2X1 U37 ( .A(addr_ip[6]), .B(addr_ip[2]), .Y(n34) );
endmodule


module gpio3 ( clk, rst_p, wr, rmw, combus, prt3_addr, p3_in, p3, p3_out );
  input [7:0] combus;
  input [7:0] prt3_addr;
  input [7:0] p3_in;
  output [7:0] p3;
  output [7:0] p3_out;
  input clk, rst_p, wr, rmw;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46;

  NOR2X1 U25 ( .A(n42), .B(n43), .Y(n34) );
  NAND4X1 U26 ( .A(prt3_addr[5]), .B(prt3_addr[7]), .C(prt3_addr[4]), .D(wr), 
        .Y(n43) );
  NAND3X1 U27 ( .A(n44), .B(n45), .C(n46), .Y(n42) );
  CLKINVX1 U28 ( .A(prt3_addr[3]), .Y(n45) );
  MXI2X1 U29 ( .S0(n34), .B(n33), .A(n20), .Y(n9) );
  CLKINVX1 U30 ( .A(combus[0]), .Y(n33) );
  MXI2X1 U31 ( .S0(n34), .B(n41), .A(n22), .Y(n10) );
  CLKINVX1 U32 ( .A(combus[1]), .Y(n41) );
  MXI2X1 U33 ( .S0(n34), .B(n40), .A(n23), .Y(n11) );
  CLKINVX1 U34 ( .A(combus[2]), .Y(n40) );
  MXI2X1 U35 ( .S0(n34), .B(n39), .A(n18), .Y(n12) );
  CLKINVX1 U36 ( .A(combus[3]), .Y(n39) );
  MXI2X1 U37 ( .S0(n34), .B(n38), .A(n21), .Y(n13) );
  CLKINVX1 U38 ( .A(combus[4]), .Y(n38) );
  MXI2X1 U39 ( .S0(n34), .B(n35), .A(n17), .Y(n16) );
  CLKINVX1 U40 ( .A(combus[7]), .Y(n35) );
  MXI2X1 U41 ( .S0(n34), .B(n36), .A(n24), .Y(n15) );
  CLKINVX1 U42 ( .A(combus[6]), .Y(n36) );
  MXI2X1 U43 ( .S0(n34), .B(n37), .A(n19), .Y(n14) );
  CLKINVX1 U44 ( .A(combus[5]), .Y(n37) );
  MXI2X1 U45 ( .S0(rmw), .B(n24), .A(n26), .Y(p3[6]) );
  CLKINVX1 U46 ( .A(p3_in[6]), .Y(n26) );
  MXI2X1 U47 ( .S0(rmw), .B(n23), .A(n30), .Y(p3[2]) );
  CLKINVX1 U48 ( .A(p3_in[2]), .Y(n30) );
  MXI2X1 U49 ( .S0(rmw), .B(n21), .A(n28), .Y(p3[4]) );
  CLKINVX1 U50 ( .A(p3_in[4]), .Y(n28) );
  MXI2X1 U51 ( .S0(rmw), .B(n18), .A(n29), .Y(p3[3]) );
  CLKINVX1 U52 ( .A(p3_in[3]), .Y(n29) );
  MXI2X1 U53 ( .S0(rmw), .B(n19), .A(n27), .Y(p3[5]) );
  CLKINVX1 U54 ( .A(p3_in[5]), .Y(n27) );
  MXI2X1 U55 ( .S0(rmw), .B(n20), .A(n32), .Y(p3[0]) );
  CLKINVX1 U56 ( .A(p3_in[0]), .Y(n32) );
  MXI2X1 U57 ( .S0(rmw), .B(n22), .A(n31), .Y(p3[1]) );
  CLKINVX1 U58 ( .A(p3_in[1]), .Y(n31) );
  MXI2X1 U59 ( .S0(rmw), .B(n17), .A(n25), .Y(p3[7]) );
  CLKINVX1 U60 ( .A(p3_in[7]), .Y(n25) );
  CLKINVX1 U61 ( .A(rst_p), .Y(n8) );
  DFFSX2 p3_out_reg_0_ ( .D(n9), .CK(clk), .SN(n8), .Q(p3_out[0]), .QN(n20) );
  DFFSX2 p3_out_reg_1_ ( .D(n10), .CK(clk), .SN(n8), .Q(p3_out[1]), .QN(n22)
         );
  DFFSX2 p3_out_reg_4_ ( .D(n13), .CK(clk), .SN(n8), .Q(p3_out[4]), .QN(n21)
         );
  DFFSX2 p3_out_reg_3_ ( .D(n12), .CK(clk), .SN(n8), .Q(p3_out[3]), .QN(n18)
         );
  DFFSX2 p3_out_reg_6_ ( .D(n15), .CK(clk), .SN(n8), .Q(p3_out[6]), .QN(n24)
         );
  DFFSX2 p3_out_reg_2_ ( .D(n11), .CK(clk), .SN(n8), .Q(p3_out[2]), .QN(n23)
         );
  DFFSX2 p3_out_reg_7_ ( .D(n16), .CK(clk), .SN(n8), .Q(p3_out[7]), .QN(n17)
         );
  DFFSX2 p3_out_reg_5_ ( .D(n14), .CK(clk), .SN(n8), .Q(p3_out[5]), .QN(n19)
         );
  NOR2X1 U62 ( .A(prt3_addr[1]), .B(prt3_addr[0]), .Y(n46) );
  NOR2X1 U63 ( .A(prt3_addr[6]), .B(prt3_addr[2]), .Y(n44) );
endmodule


module ie ( clk, rst_p, in_ie, addr_ie, wr, out_ie );
  input [7:0] in_ie;
  input [7:0] addr_ie;
  output [7:0] out_ie;
  input clk, rst_p, wr;
  wire   n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36;

  NOR2X1 U16 ( .A(n32), .B(n33), .Y(n24) );
  NAND4X1 U17 ( .A(addr_ie[5]), .B(addr_ie[7]), .C(addr_ie[3]), .D(wr), .Y(n33) );
  NAND3X1 U18 ( .A(n34), .B(n35), .C(n36), .Y(n32) );
  CLKINVX1 U19 ( .A(addr_ie[2]), .Y(n35) );
  DFFRX1 out_ie_reg_7_ ( .D(n14), .CK(clk), .RN(n6), .Q(out_ie[7]), .QN(n15)
         );
  DFFRX1 out_ie_reg_3_ ( .D(n10), .CK(clk), .RN(n6), .Q(out_ie[3]), .QN(n19)
         );
  DFFRX1 out_ie_reg_4_ ( .D(n11), .CK(clk), .RN(n6), .Q(out_ie[4]), .QN(n18)
         );
  MXI2X1 U20 ( .S0(n24), .B(n26), .A(n22), .Y(n7) );
  CLKINVX1 U21 ( .A(in_ie[0]), .Y(n26) );
  MXI2X1 U22 ( .S0(n24), .B(n25), .A(n21), .Y(n8) );
  CLKINVX1 U23 ( .A(in_ie[1]), .Y(n25) );
  MXI2X1 U24 ( .S0(n24), .B(n23), .A(n20), .Y(n9) );
  CLKINVX1 U25 ( .A(in_ie[2]), .Y(n23) );
  MXI2X1 U26 ( .S0(n24), .B(n31), .A(n19), .Y(n10) );
  CLKINVX1 U27 ( .A(in_ie[3]), .Y(n31) );
  MXI2X1 U28 ( .S0(n24), .B(n30), .A(n18), .Y(n11) );
  CLKINVX1 U29 ( .A(in_ie[4]), .Y(n30) );
  MXI2X1 U30 ( .S0(n24), .B(n28), .A(n16), .Y(n13) );
  CLKINVX1 U31 ( .A(in_ie[6]), .Y(n28) );
  MXI2X1 U32 ( .S0(n24), .B(n27), .A(n15), .Y(n14) );
  CLKINVX1 U33 ( .A(in_ie[7]), .Y(n27) );
  MXI2X1 U34 ( .S0(n24), .B(n29), .A(n17), .Y(n12) );
  CLKINVX1 U35 ( .A(in_ie[5]), .Y(n29) );
  CLKINVX1 U36 ( .A(rst_p), .Y(n6) );
  DFFRX1 out_ie_reg_0_ ( .D(n7), .CK(clk), .RN(n6), .Q(out_ie[0]), .QN(n22) );
  DFFRX1 out_ie_reg_1_ ( .D(n8), .CK(clk), .RN(n6), .Q(out_ie[1]), .QN(n21) );
  DFFRX1 out_ie_reg_2_ ( .D(n9), .CK(clk), .RN(n6), .Q(out_ie[2]), .QN(n20) );
  DFFRX1 out_ie_reg_5_ ( .D(n12), .CK(clk), .RN(n6), .Q(out_ie[5]), .QN(n17)
         );
  DFFRX1 out_ie_reg_6_ ( .D(n13), .CK(clk), .RN(n6), .Q(out_ie[6]), .QN(n16)
         );
  NOR2X1 U37 ( .A(addr_ie[1]), .B(addr_ie[0]), .Y(n36) );
  NOR2X1 U38 ( .A(addr_ie[6]), .B(addr_ie[4]), .Y(n34) );
endmodule


module gpio2 ( clk, rst_p, wr, rmw, combus, prt2_addr, p2_in, p2, p2_out );
  input [7:0] combus;
  input [7:0] prt2_addr;
  input [7:0] p2_in;
  output [7:0] p2;
  output [7:0] p2_out;
  input clk, rst_p, wr, rmw;
  wire   n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45;

  NAND3BX1 U24 ( .AN(prt2_addr[3]), .B(n44), .C(n45), .Y(n41) );
  MXI2X1 U25 ( .S0(rmw), .B(n21), .A(n30), .Y(p2[1]) );
  MXI2X1 U26 ( .S0(rmw), .B(n17), .A(n28), .Y(p2[3]) );
  CLKINVX1 U27 ( .A(prt2_addr[0]), .Y(n43) );
  NOR2X1 U28 ( .A(n41), .B(n42), .Y(n33) );
  NAND4X1 U29 ( .A(prt2_addr[5]), .B(prt2_addr[7]), .C(n43), .D(wr), .Y(n42)
         );
  MXI2X1 U30 ( .S0(n33), .B(n34), .A(n20), .Y(n8) );
  CLKINVX1 U31 ( .A(combus[0]), .Y(n34) );
  MXI2X1 U32 ( .S0(n33), .B(n32), .A(n21), .Y(n9) );
  CLKINVX1 U33 ( .A(combus[1]), .Y(n32) );
  MXI2X1 U34 ( .S0(n33), .B(n40), .A(n22), .Y(n10) );
  CLKINVX1 U35 ( .A(combus[2]), .Y(n40) );
  MXI2X1 U36 ( .S0(n33), .B(n39), .A(n17), .Y(n11) );
  CLKINVX1 U37 ( .A(combus[3]), .Y(n39) );
  MXI2X1 U38 ( .S0(n33), .B(n38), .A(n18), .Y(n12) );
  CLKINVX1 U39 ( .A(combus[4]), .Y(n38) );
  MXI2X1 U40 ( .S0(n33), .B(n35), .A(n16), .Y(n15) );
  CLKINVX1 U41 ( .A(combus[7]), .Y(n35) );
  MXI2X1 U42 ( .S0(n33), .B(n36), .A(n23), .Y(n14) );
  CLKINVX1 U43 ( .A(combus[6]), .Y(n36) );
  MXI2X1 U44 ( .S0(n33), .B(n37), .A(n19), .Y(n13) );
  CLKINVX1 U45 ( .A(combus[5]), .Y(n37) );
  CLKINVX1 U46 ( .A(p2_in[1]), .Y(n30) );
  CLKINVX1 U47 ( .A(p2_in[3]), .Y(n28) );
  MXI2X1 U48 ( .S0(rmw), .B(n16), .A(n24), .Y(p2[7]) );
  CLKINVX1 U49 ( .A(p2_in[7]), .Y(n24) );
  MXI2X1 U50 ( .S0(rmw), .B(n20), .A(n31), .Y(p2[0]) );
  CLKINVX1 U51 ( .A(p2_in[0]), .Y(n31) );
  MXI2X1 U52 ( .S0(rmw), .B(n22), .A(n29), .Y(p2[2]) );
  CLKINVX1 U53 ( .A(p2_in[2]), .Y(n29) );
  MXI2X1 U54 ( .S0(rmw), .B(n18), .A(n27), .Y(p2[4]) );
  CLKINVX1 U55 ( .A(p2_in[4]), .Y(n27) );
  MXI2X1 U56 ( .S0(rmw), .B(n19), .A(n26), .Y(p2[5]) );
  CLKINVX1 U57 ( .A(p2_in[5]), .Y(n26) );
  MXI2X1 U58 ( .S0(rmw), .B(n23), .A(n25), .Y(p2[6]) );
  CLKINVX1 U59 ( .A(p2_in[6]), .Y(n25) );
  CLKINVX1 U60 ( .A(rst_p), .Y(n7) );
  DFFSX2 p2_out_reg_0_ ( .D(n8), .CK(clk), .SN(n7), .Q(p2_out[0]), .QN(n20) );
  DFFSX2 p2_out_reg_1_ ( .D(n9), .CK(clk), .SN(n7), .Q(p2_out[1]), .QN(n21) );
  DFFSX2 p2_out_reg_7_ ( .D(n15), .CK(clk), .SN(n7), .Q(p2_out[7]), .QN(n16)
         );
  DFFSX2 p2_out_reg_4_ ( .D(n12), .CK(clk), .SN(n7), .Q(p2_out[4]), .QN(n18)
         );
  DFFSX2 p2_out_reg_3_ ( .D(n11), .CK(clk), .SN(n7), .Q(p2_out[3]), .QN(n17)
         );
  DFFSX2 p2_out_reg_2_ ( .D(n10), .CK(clk), .SN(n7), .Q(p2_out[2]), .QN(n22)
         );
  DFFSX2 p2_out_reg_5_ ( .D(n13), .CK(clk), .SN(n7), .Q(p2_out[5]), .QN(n19)
         );
  DFFSX2 p2_out_reg_6_ ( .D(n14), .CK(clk), .SN(n7), .Q(p2_out[6]), .QN(n23)
         );
  NOR2X1 U61 ( .A(prt2_addr[2]), .B(prt2_addr[1]), .Y(n45) );
  NOR2X1 U62 ( .A(prt2_addr[6]), .B(prt2_addr[4]), .Y(n44) );
endmodule


module u_uart ( clk, rst_p, rxdi, rxdo, in_sfr, addr_sfr, wr, shift12, tf1, 
        txdo, uart_int, scon, pcon, sbuf );
  input [7:0] in_sfr;
  input [7:0] addr_sfr;
  output [7:0] scon;
  output [7:0] pcon;
  output [7:0] sbuf;
  input clk, rst_p, rxdi, wr, shift12, tf1;
  output rxdo, txdo, uart_int;
  wire   sbuf_rxd_tmp_11_, sbuf_rxd_tmp_10_, sbuf_rxd_tmp_9_, sbuf_rxd_tmp_8_,
         sbuf_txd_9_, sbuf_txd_8_, sbuf_txd_7_, sbuf_txd_6_, sbuf_txd_5_,
         sbuf_txd_4_, sbuf_txd_3_, sbuf_txd_2_, sbuf_txd_1_, sbuf_txd_0_,
         sbuf_rxd_tmp_7_, sbuf_rxd_tmp_6_, sbuf_rxd_tmp_5_, sbuf_rxd_tmp_4_,
         sbuf_rxd_tmp_3_, sbuf_rxd_tmp_1_, sbuf_rxd_tmp_0_, tx_done, rx_done,
         div12, rec_sync, receive, txd, trans1, trans, trans2, trans3,
         shift12_1, shift_trans, smod_clk_trans, shift_rec, smod_clk_rec, N239,
         N240, N241, N242, N243, N244, N245, N246, N247, N248, N249, N308,
         N309, N310, N312, N313, N314, n3, n4, n5, n6, n7, n8, n9, n11, n12,
         n13, n15, n20, n21, n22, n24, n25, n26, n27, n28, n29, n30, n32, n33,
         n34, n35, n36, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n56, n60, n61, n68, n69, n70, n72, n73, n77, n79, n81, n82, n84, n85,
         n87, n88, n90, n92, n94, n97, n104, n105, n109, n110, n111, n112,
         n113, n114, n116, n118, n124, n125, n126, n127, n128, n130, n131,
         n133, n134, n135, n136, n137, n138, n139, n142, n143, n144, n146,
         n147, n148, n149, n152, n153, n154, n156, n157, n158, n159, n160,
         n162, n163, n164, n166, n177, n179, n182, n183, n186, n187, n188,
         n189, n190, n191, n192, n193, n194, n195, n196, n197, n198, n199,
         n200, n201, n202, n203, n204, n205, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n2390, n2400, n2410, n2420, n2430,
         n2440, n2450, n2460, n2470, n2480, n2490, n250, n251, n252, n253,
         n254, n255, n256, n257, n258, n259, n260, n261, n262, n263, n264,
         n265, n266, n267, n268, n269, n270, n271, n272, n273, n274, n275,
         n276, n277, n278, n279, n280, n281, n282, n283, n284, n285, n286,
         n287, n288, n289, n290, n291, n292, n293, n294, n295, n296, n297,
         n298, n299, n300, n301, n302, n303, n304, n305, n306, n307, n3080,
         n3090, n3100, n311, n3120, n3130, n3140, n315, n316, n317, n318, n319,
         n320, n321, n322, n323, n324, n325, n326, n327, n328, n329, n330,
         n331, n332, n333, n334, n335, n336, n337, n338, n339, n340, n341,
         n342, n343, n344, n345, n346, n347, n348, n349, n350, n351, n352,
         n353, n354, n355, n356, n357, n358, n359, n360, n361, n362, n363,
         n364, n365, n366, n367, n368, n369, n370, n371, n372, n373, n374,
         n375, n376, n377, n378, n379, n380, n381, n382, n383, n384, n385,
         n386, n387, n388, n389, n390, n391, n392, n393, n394, n395, n396,
         n397, n398, n399, n400, n401, n402, n403, n404, n405, n406, n407,
         n408, n409, n410, n411, n412;
  wire   [7:0] cnt1_8;
  wire   [3:0] cnt0_4;
  wire   [3:0] trans_cnt;
  wire   [3:0] rec_cnt;
  wire   [1:0] rx_same;

  OAI211X1 U272 ( .A0(n135), .A1(n128), .B0(n136), .C0(n116), .Y(n113) );
  AND2X2 U273 ( .A(n356), .B(sbuf_txd_2_), .Y(n288) );
  NOR3X1 U274 ( .A(sbuf_txd_4_), .B(sbuf_txd_3_), .C(sbuf_txd_2_), .Y(n293) );
  OR2X2 U275 ( .A(tx_done), .B(rx_done), .Y(n3100) );
  DFFQX1 trans1_reg ( .D(trans), .CK(clk), .Q(trans1) );
  DFFQX1 trans2_reg ( .D(trans1), .CK(clk), .Q(trans2) );
  CLKINVX1 U276 ( .A(in_sfr[4]), .Y(n84) );
  OR2X2 U277 ( .A(n28), .B(n27), .Y(n3140) );
  NAND2X2 U278 ( .A(n391), .B(n392), .Y(n333) );
  NAND2X1 U279 ( .A(n387), .B(n388), .Y(n386) );
  NAND2X1 U280 ( .A(n381), .B(n382), .Y(n380) );
  AO21X1 U281 ( .A0(scon[7]), .A1(n289), .B0(tf1), .Y(n43) );
  AO22X1 U282 ( .A0(sbuf[0]), .A1(rx_done), .B0(sbuf_rxd_tmp_3_), .B1(n290), 
        .Y(n215) );
  AO22X1 U283 ( .A0(sbuf[1]), .A1(rx_done), .B0(sbuf_rxd_tmp_4_), .B1(n290), 
        .Y(n216) );
  AO22X1 U284 ( .A0(sbuf[2]), .A1(rx_done), .B0(sbuf_rxd_tmp_5_), .B1(n290), 
        .Y(n217) );
  AO22X1 U285 ( .A0(sbuf[3]), .A1(rx_done), .B0(sbuf_rxd_tmp_6_), .B1(n290), 
        .Y(n218) );
  AO22X1 U286 ( .A0(sbuf[4]), .A1(rx_done), .B0(sbuf_rxd_tmp_7_), .B1(n290), 
        .Y(n219) );
  AO22X1 U287 ( .A0(sbuf[5]), .A1(rx_done), .B0(sbuf_rxd_tmp_8_), .B1(n290), 
        .Y(n220) );
  AO22X1 U288 ( .A0(sbuf[6]), .A1(rx_done), .B0(sbuf_rxd_tmp_9_), .B1(n290), 
        .Y(n221) );
  AO22X1 U289 ( .A0(sbuf[7]), .A1(rx_done), .B0(sbuf_rxd_tmp_10_), .B1(n290), 
        .Y(n222) );
  OR2X1 U290 ( .A(pcon[7]), .B(smod_clk_rec), .Y(n47) );
  OR2X1 U291 ( .A(pcon[7]), .B(smod_clk_trans), .Y(n45) );
  OR2X1 U292 ( .A(scon[0]), .B(scon[1]), .Y(uart_int) );
  CLKINVX1 U293 ( .A(n393), .Y(n355) );
  CLKINVX1 U294 ( .A(addr_sfr[2]), .Y(n110) );
  CLKINVX1 U295 ( .A(n73), .Y(n26) );
  CLKINVX1 U296 ( .A(in_sfr[1]), .Y(n60) );
  CLKINVX1 U297 ( .A(n69), .Y(n356) );
  NAND2X1 U298 ( .A(addr_sfr[0]), .B(n340), .Y(n73) );
  NOR2BX1 U299 ( .AN(n340), .B(addr_sfr[0]), .Y(n315) );
  CLKINVX1 U300 ( .A(n385), .Y(n362) );
  NAND2X1 U301 ( .A(n5), .B(n26), .Y(n393) );
  CLKINVX1 U302 ( .A(n349), .Y(n348) );
  CLKINVX1 U303 ( .A(addr_sfr[0]), .Y(n350) );
  NAND2BX1 U304 ( .AN(txd), .B(n5), .Y(rxdo) );
  CLKINVX1 U305 ( .A(in_sfr[0]), .Y(n61) );
  CLKINVX1 U306 ( .A(in_sfr[2]), .Y(n56) );
  CLKINVX1 U307 ( .A(in_sfr[3]), .Y(n87) );
  CLKINVX1 U308 ( .A(in_sfr[5]), .Y(n81) );
  CLKINVX1 U309 ( .A(in_sfr[6]), .Y(n77) );
  CLKINVX1 U310 ( .A(in_sfr[7]), .Y(n72) );
  CLKINVX1 U311 ( .A(n68), .Y(n354) );
  NAND4X1 U312 ( .A(addr_sfr[7]), .B(n400), .C(n401), .D(wr), .Y(n349) );
  CLKINVX1 U313 ( .A(addr_sfr[5]), .Y(n401) );
  NOR2X1 U314 ( .A(n399), .B(n349), .Y(n340) );
  NAND4X1 U315 ( .A(addr_sfr[3]), .B(addr_sfr[4]), .C(n110), .D(n109), .Y(n399) );
  NAND2X1 U316 ( .A(n39), .B(n402), .Y(n29) );
  CLKINVX1 U317 ( .A(n36), .Y(n402) );
  NAND2X1 U318 ( .A(n68), .B(n97), .Y(n69) );
  AND4X2 U319 ( .A(n345), .B(n346), .C(n347), .D(n348), .Y(n344) );
  NOR2X1 U320 ( .A(addr_sfr[3]), .B(n350), .Y(n346) );
  NOR2X1 U321 ( .A(n110), .B(addr_sfr[4]), .Y(n347) );
  CLKINVX1 U322 ( .A(n109), .Y(n345) );
  NAND2X1 U323 ( .A(n7), .B(n26), .Y(n385) );
  CLKINVX1 U324 ( .A(n7), .Y(n5) );
  CLKINVX1 U325 ( .A(n128), .Y(n130) );
  CLKINVX1 U326 ( .A(n133), .Y(n134) );
  CLKINVX1 U327 ( .A(n114), .Y(n112) );
  NOR2X1 U328 ( .A(n389), .B(n390), .Y(n231) );
  NOR3BX1 U329 ( .AN(n385), .B(n333), .C(n288), .Y(n390) );
  NOR3BX1 U330 ( .AN(n61), .B(n333), .C(n288), .Y(n389) );
  NOR2X1 U331 ( .A(n394), .B(n395), .Y(n230) );
  NOR2X1 U332 ( .A(n317), .B(n398), .Y(n394) );
  NOR3BX1 U333 ( .AN(n61), .B(n317), .C(n396), .Y(n395) );
  NAND2X1 U334 ( .A(n397), .B(n393), .Y(n398) );
  DFFRX1 scon_reg_1_ ( .D(n267), .CK(clk), .RN(n186), .Q(scon[1]) );
  DFFRX1 scon_reg_0_ ( .D(n266), .CK(clk), .RN(n186), .Q(scon[0]) );
  DFFRX1 scon_reg_7_ ( .D(n273), .CK(clk), .RN(n186), .Q(scon[7]), .QN(n280)
         );
  DFFRX1 scon_reg_5_ ( .D(n271), .CK(clk), .RN(n186), .Q(scon[5]), .QN(n3080)
         );
  DFFRX1 scon_reg_4_ ( .D(n270), .CK(clk), .RN(n186), .Q(scon[4]), .QN(n292)
         );
  DFFRX1 scon_reg_6_ ( .D(n272), .CK(clk), .RN(n186), .Q(scon[6]), .QN(n289)
         );
  DFFRX1 pcon_reg_7_ ( .D(n265), .CK(clk), .RN(n186), .Q(pcon[7]), .QN(n325)
         );
  DFFRX1 sbuf_rxd_reg_1_ ( .D(n216), .CK(clk), .RN(n186), .Q(sbuf[1]) );
  DFFRX1 sbuf_rxd_reg_4_ ( .D(n219), .CK(clk), .RN(n186), .Q(sbuf[4]) );
  DFFRX1 sbuf_rxd_reg_7_ ( .D(n222), .CK(clk), .RN(n186), .Q(sbuf[7]) );
  OAI22X1 U335 ( .A0(n334), .A1(n315), .B0(n56), .B1(n335), .Y(n268) );
  OAI21X1 U336 ( .A0(n336), .A1(sbuf_rxd_tmp_11_), .B0(n337), .Y(n334) );
  CLKINVX1 U337 ( .A(n315), .Y(n335) );
  MXI2X1 U338 ( .S0(n315), .B(n84), .A(n292), .Y(n270) );
  MXI2X1 U339 ( .S0(n315), .B(n72), .A(n280), .Y(n273) );
  MXI2X1 U340 ( .S0(n315), .B(n77), .A(n289), .Y(n272) );
  NAND2BX1 U341 ( .AN(n33), .B(n41), .Y(n97) );
  NAND3X1 U342 ( .A(n29), .B(n73), .C(n3140), .Y(n68) );
  OAI2BB1X1 U343 ( .A0N(n36), .A1N(n28), .B0(n97), .Y(n32) );
  CLKINVX1 U344 ( .A(n41), .Y(n39) );
  CLKINVX1 U345 ( .A(n28), .Y(n33) );
  CLKINVX1 U346 ( .A(n40), .Y(n38) );
  NAND2BX1 U347 ( .AN(n26), .B(n41), .Y(n40) );
  CLKINVX1 U348 ( .A(n397), .Y(n396) );
  DFFRX1 rec_cnt_reg_0_ ( .D(n199), .CK(clk), .RN(n186), .Q(rec_cnt[0]), .QN(
        n305) );
  DFFRX1 rec_cnt_reg_3_ ( .D(n202), .CK(clk), .RN(n186), .Q(rec_cnt[3]), .QN(
        n301) );
  NAND2BX1 U349 ( .AN(n134), .B(n113), .Y(n114) );
  NAND2BX1 U350 ( .AN(n319), .B(n139), .Y(n133) );
  NAND2BX1 U351 ( .AN(n290), .B(n319), .Y(n128) );
  NAND2X1 U352 ( .A(n289), .B(n280), .Y(n7) );
  CLKINVX1 U353 ( .A(n164), .Y(n163) );
  NAND2BX1 U354 ( .AN(n130), .B(n116), .Y(n164) );
  NAND2BX1 U355 ( .AN(n133), .B(n113), .Y(n118) );
  CLKINVX1 U356 ( .A(n24), .Y(n27) );
  NOR2BX1 U357 ( .AN(N248), .B(n320), .Y(n251) );
  CLKINVX1 U358 ( .A(n113), .Y(n111) );
  CLKINVX1 U359 ( .A(n139), .Y(n131) );
  OAI221X1 U360 ( .A0(n287), .A1(n113), .B0(n278), .B1(n114), .C0(n118), .Y(
        n204) );
  OAI221X1 U361 ( .A0(n298), .A1(n113), .B0(n287), .B1(n114), .C0(n118), .Y(
        n203) );
  OAI221X1 U362 ( .A0(n278), .A1(n113), .B0(n296), .B1(n114), .C0(n118), .Y(
        n205) );
  OAI221X1 U363 ( .A0(n296), .A1(n113), .B0(n286), .B1(n114), .C0(n118), .Y(
        n206) );
  OAI221X1 U364 ( .A0(n286), .A1(n113), .B0(n279), .B1(n114), .C0(n118), .Y(
        n207) );
  OAI221X1 U365 ( .A0(n297), .A1(n113), .B0(n285), .B1(n114), .C0(n118), .Y(
        n209) );
  OAI221X1 U366 ( .A0(n279), .A1(n113), .B0(n297), .B1(n114), .C0(n118), .Y(
        n208) );
  OAI221X1 U367 ( .A0(n285), .A1(n113), .B0(n114), .B1(n277), .C0(n118), .Y(
        n210) );
  CLKINVX1 U368 ( .A(n160), .Y(n138) );
  NAND2BX1 U369 ( .AN(n290), .B(n5), .Y(n160) );
  DFFRX1 tx_done_reg ( .D(n2410), .CK(clk), .RN(n186), .Q(tx_done), .QN(n302)
         );
  NAND4X1 U370 ( .A(n276), .B(n274), .C(n281), .D(n291), .Y(n36) );
  NAND2X1 U371 ( .A(rec_cnt[1]), .B(rec_cnt[0]), .Y(n404) );
  NAND2X1 U372 ( .A(n406), .B(trans_cnt[0]), .Y(n408) );
  NOR2BX1 U373 ( .AN(N245), .B(n320), .Y(n2480) );
  NOR2BX1 U374 ( .AN(N243), .B(n320), .Y(n2460) );
  NOR2BX1 U375 ( .AN(N244), .B(n320), .Y(n2470) );
  NOR2BX1 U376 ( .AN(N246), .B(n320), .Y(n2490) );
  NOR2BX1 U377 ( .AN(N247), .B(n320), .Y(n250) );
  NOR2BX1 U378 ( .AN(N240), .B(n322), .Y(n256) );
  XNOR2X1 U379 ( .A(n410), .B(n323), .Y(N240) );
  CLKINVX1 U380 ( .A(n411), .Y(n410) );
  NOR2BX1 U381 ( .AN(n47), .B(n48), .Y(n193) );
  NOR2BX1 U382 ( .AN(n45), .B(n48), .Y(n224) );
  NOR2X1 U383 ( .A(cnt0_4[0]), .B(n322), .Y(n254) );
  CLKINVX1 U384 ( .A(n43), .Y(n48) );
  CLKINVX1 U385 ( .A(rxdi), .Y(n125) );
  MXI2X1 U386 ( .S0(n315), .B(n61), .A(n339), .Y(n266) );
  NOR2X1 U387 ( .A(n341), .B(scon[0]), .Y(n339) );
  NOR2X1 U388 ( .A(n342), .B(n3100), .Y(n341) );
  MXI2X1 U389 ( .S0(n344), .B(n61), .A(n332), .Y(n258) );
  NAND2X1 U390 ( .A(sbuf_txd_1_), .B(n354), .Y(n391) );
  NAND2X1 U391 ( .A(n355), .B(in_sfr[1]), .Y(n392) );
  OAI22X1 U392 ( .A0(n338), .A1(n315), .B0(n60), .B1(n335), .Y(n267) );
  NOR2X1 U393 ( .A(scon[1]), .B(tx_done), .Y(n338) );
  MXI2X1 U394 ( .S0(n344), .B(n60), .A(n331), .Y(n259) );
  NAND3X1 U395 ( .A(n383), .B(n92), .C(n384), .Y(n232) );
  NAND2X1 U396 ( .A(n356), .B(sbuf_txd_3_), .Y(n383) );
  CLKINVX1 U397 ( .A(n386), .Y(n92) );
  NAND2X1 U398 ( .A(n362), .B(in_sfr[1]), .Y(n384) );
  MXI2X1 U399 ( .S0(n344), .B(n56), .A(n330), .Y(n260) );
  NAND2X1 U400 ( .A(n354), .B(sbuf_txd_2_), .Y(n387) );
  NAND2X1 U401 ( .A(n355), .B(in_sfr[2]), .Y(n388) );
  NAND3X1 U402 ( .A(n378), .B(n90), .C(n379), .Y(n233) );
  NAND2X1 U403 ( .A(sbuf_txd_4_), .B(n356), .Y(n378) );
  CLKINVX1 U404 ( .A(n380), .Y(n90) );
  NAND2X1 U405 ( .A(n362), .B(in_sfr[2]), .Y(n379) );
  NAND3X1 U406 ( .A(n373), .B(n88), .C(n374), .Y(n234) );
  NAND2X1 U407 ( .A(n356), .B(sbuf_txd_5_), .Y(n373) );
  CLKINVX1 U408 ( .A(n375), .Y(n88) );
  NAND2X1 U409 ( .A(n362), .B(in_sfr[3]), .Y(n374) );
  NAND2X1 U410 ( .A(n354), .B(sbuf_txd_3_), .Y(n381) );
  NAND2X1 U411 ( .A(n355), .B(in_sfr[3]), .Y(n382) );
  MXI2X1 U412 ( .S0(n315), .B(n87), .A(n324), .Y(n269) );
  MXI2X1 U413 ( .S0(n344), .B(n87), .A(n329), .Y(n261) );
  MXI2X1 U414 ( .S0(n344), .B(n84), .A(n328), .Y(n262) );
  NAND2X1 U415 ( .A(n376), .B(n377), .Y(n375) );
  NAND2X1 U416 ( .A(sbuf_txd_4_), .B(n354), .Y(n376) );
  NAND2X1 U417 ( .A(n355), .B(in_sfr[4]), .Y(n377) );
  NAND3X1 U418 ( .A(n368), .B(n85), .C(n369), .Y(n235) );
  NAND2X1 U419 ( .A(n356), .B(sbuf_txd_6_), .Y(n368) );
  CLKINVX1 U420 ( .A(n370), .Y(n85) );
  NAND2X1 U421 ( .A(n362), .B(in_sfr[4]), .Y(n369) );
  NAND2X1 U422 ( .A(n366), .B(n367), .Y(n365) );
  NAND2X1 U423 ( .A(n354), .B(sbuf_txd_6_), .Y(n366) );
  NAND2X1 U424 ( .A(n355), .B(in_sfr[6]), .Y(n367) );
  MXI2X1 U425 ( .S0(n315), .B(n81), .A(n3080), .Y(n271) );
  MXI2X1 U426 ( .S0(n344), .B(n72), .A(n325), .Y(n265) );
  MXI2X1 U427 ( .S0(n344), .B(n77), .A(n326), .Y(n264) );
  MXI2X1 U428 ( .S0(n344), .B(n81), .A(n327), .Y(n263) );
  NAND2X1 U429 ( .A(n371), .B(n372), .Y(n370) );
  NAND2X1 U430 ( .A(n354), .B(sbuf_txd_5_), .Y(n371) );
  NAND2X1 U431 ( .A(n355), .B(in_sfr[5]), .Y(n372) );
  NAND3X1 U432 ( .A(n357), .B(n358), .C(n79), .Y(n237) );
  NAND2X1 U433 ( .A(n356), .B(sbuf_txd_8_), .Y(n357) );
  NAND2X1 U434 ( .A(n362), .B(in_sfr[6]), .Y(n358) );
  CLKINVX1 U435 ( .A(n359), .Y(n79) );
  NAND3BX1 U436 ( .AN(n351), .B(n352), .C(n353), .Y(n238) );
  AOI21X1 U437 ( .A0(n354), .A1(sbuf_txd_8_), .B0(n355), .Y(n353) );
  NAND2X1 U438 ( .A(sbuf_txd_9_), .B(n356), .Y(n352) );
  NOR2X1 U439 ( .A(n73), .B(n72), .Y(n351) );
  NAND2X1 U440 ( .A(n360), .B(n361), .Y(n359) );
  NAND2X1 U441 ( .A(sbuf_txd_7_), .B(n354), .Y(n360) );
  NAND2X1 U442 ( .A(n355), .B(in_sfr[7]), .Y(n361) );
  NAND3X1 U443 ( .A(n363), .B(n364), .C(n82), .Y(n236) );
  NAND2X1 U444 ( .A(sbuf_txd_7_), .B(n356), .Y(n363) );
  NAND2X1 U445 ( .A(n362), .B(in_sfr[5]), .Y(n364) );
  CLKINVX1 U446 ( .A(n365), .Y(n82) );
  NAND3BX1 U447 ( .AN(n5), .B(shift_trans), .C(n316), .Y(n41) );
  NAND3X1 U448 ( .A(shift12_1), .B(n5), .C(n316), .Y(n28) );
  AND2X2 U449 ( .A(trans), .B(n73), .Y(n316) );
  AND2X2 U450 ( .A(sbuf_txd_1_), .B(n356), .Y(n317) );
  AO21X2 U451 ( .A0(n21), .A1(txd), .B0(n22), .Y(n2420) );
  AOI31X1 U452 ( .A0(trans), .A1(n295), .A2(n24), .B0(n21), .Y(n22) );
  CLKINVX1 U453 ( .A(n25), .Y(n21) );
  OAI221X1 U454 ( .A0(trans), .A1(n26), .B0(n27), .B1(n28), .C0(n29), .Y(n25)
         );
  OAI31X1 U455 ( .A0(n29), .A1(sbuf_txd_0_), .A2(n24), .B0(n30), .Y(n2410) );
  AOI32X1 U456 ( .A0(n316), .A1(tx_done), .A2(n32), .B0(n27), .B1(n33), .Y(n30) );
  AO21X2 U457 ( .A0(n34), .A1(trans), .B0(n26), .Y(n2430) );
  OAI211X1 U458 ( .A0(n33), .A1(n295), .B0(n27), .C0(n35), .Y(n34) );
  CLKINVX1 U459 ( .A(n32), .Y(n35) );
  NAND2X1 U460 ( .A(sbuf_txd_0_), .B(n354), .Y(n397) );
  OAI2BB2X1 U461 ( .A0N(n26), .A1N(scon[7]), .B0(n68), .B1(n318), .Y(n2400) );
  AO22X2 U462 ( .A0(trans_cnt[0]), .A1(n38), .B0(n291), .B1(n39), .Y(n226) );
  AO22X2 U463 ( .A0(trans_cnt[1]), .A1(n38), .B0(N308), .B1(n39), .Y(n227) );
  XNOR2X1 U464 ( .A(trans_cnt[0]), .B(n276), .Y(N308) );
  AO22X2 U465 ( .A0(trans_cnt[2]), .A1(n38), .B0(N309), .B1(n39), .Y(n228) );
  XNOR2X1 U466 ( .A(n407), .B(n274), .Y(N309) );
  CLKINVX1 U467 ( .A(n408), .Y(n407) );
  AO22X2 U468 ( .A0(trans_cnt[3]), .A1(n38), .B0(N310), .B1(n39), .Y(n229) );
  XNOR2X1 U469 ( .A(n409), .B(n281), .Y(N310) );
  NOR2X1 U470 ( .A(n408), .B(n274), .Y(n409) );
  OAI221X1 U471 ( .A0(n68), .A1(n275), .B0(n69), .B1(n318), .C0(n70), .Y(n2390) );
  AOI33X1 U472 ( .A0(scon[3]), .A1(scon[7]), .A2(n26), .B0(scon[6]), .B1(n280), 
        .B2(n26), .Y(n70) );
  NAND4BX1 U473 ( .AN(rec_cnt[2]), .B(n3090), .C(rec_cnt[3]), .D(rec_cnt[0]), 
        .Y(n135) );
  AOI32X1 U474 ( .A0(n137), .A1(scon[4]), .A2(n138), .B0(n131), .B1(rx_done), 
        .Y(n136) );
  NOR2BX1 U475 ( .AN(n321), .B(scon[0]), .Y(n137) );
  NAND3BX1 U476 ( .AN(n292), .B(shift_rec), .C(n146), .Y(n116) );
  NAND3X1 U477 ( .A(rec_sync), .B(shift12), .C(n5), .Y(n139) );
  AND3X2 U478 ( .A(shift_rec), .B(receive), .C(n7), .Y(n319) );
  NAND4X1 U479 ( .A(n318), .B(n282), .C(n293), .D(n104), .Y(n24) );
  AND4X2 U480 ( .A(n283), .B(n294), .C(n105), .D(n275), .Y(n104) );
  CLKINVX1 U481 ( .A(n166), .Y(n146) );
  NAND3BX1 U482 ( .AN(n5), .B(rx_done), .C(n134), .Y(n166) );
  NOR2BX1 U483 ( .AN(N249), .B(n320), .Y(n252) );
  AO21X2 U484 ( .A0(n111), .A1(sbuf_rxd_tmp_11_), .B0(n124), .Y(n214) );
  OAI33X1 U485 ( .A0(n111), .A1(n125), .A2(n126), .B0(n111), .B1(n127), .B2(
        n128), .Y(n124) );
  NAND2BX1 U486 ( .AN(n3120), .B(rx_same[1]), .Y(n127) );
  AOI221X1 U487 ( .A0(rx_same[0]), .A1(n130), .B0(rx_same[1]), .B1(n130), .C0(
        n131), .Y(n126) );
  AO22X2 U488 ( .A0(n305), .A1(n130), .B0(n163), .B1(rec_cnt[0]), .Y(n199) );
  AO22X2 U489 ( .A0(N314), .A1(n130), .B0(n163), .B1(rec_cnt[3]), .Y(n202) );
  XNOR2X1 U490 ( .A(n405), .B(n301), .Y(N314) );
  NOR2X1 U491 ( .A(n404), .B(n299), .Y(n405) );
  AO22X2 U492 ( .A0(N313), .A1(n130), .B0(n163), .B1(rec_cnt[2]), .Y(n201) );
  XNOR2X1 U493 ( .A(n403), .B(n299), .Y(N313) );
  CLKINVX1 U494 ( .A(n404), .Y(n403) );
  AO22X2 U495 ( .A0(N312), .A1(n130), .B0(n163), .B1(rec_cnt[1]), .Y(n200) );
  XNOR2X1 U496 ( .A(rec_cnt[0]), .B(n3090), .Y(N312) );
  AO22X2 U497 ( .A0(sbuf_rxd_tmp_9_), .A1(n111), .B0(sbuf_rxd_tmp_10_), .B1(
        n112), .Y(n212) );
  AO22X2 U498 ( .A0(n111), .A1(sbuf_rxd_tmp_10_), .B0(n112), .B1(
        sbuf_rxd_tmp_11_), .Y(n213) );
  OAI222X1 U499 ( .A0(n125), .A1(n142), .B0(n116), .B1(n125), .C0(n143), .C1(
        n144), .Y(n223) );
  NAND2BX1 U500 ( .AN(n300), .B(n142), .Y(n144) );
  NAND2BX1 U501 ( .AN(scon[4]), .B(n146), .Y(n142) );
  CLKINVX1 U502 ( .A(n116), .Y(n143) );
  NOR2X1 U503 ( .A(sbuf_txd_8_), .B(sbuf_txd_7_), .Y(n105) );
  OAI221X1 U504 ( .A0(n113), .A1(n277), .B0(n114), .B1(n304), .C0(n116), .Y(
        n211) );
  OAI31X1 U505 ( .A0(n116), .A1(rxdi), .A2(n300), .B0(n158), .Y(n195) );
  AOI32X1 U506 ( .A0(n138), .A1(n159), .A2(n134), .B0(rx_done), .B1(receive), 
        .Y(n158) );
  NOR2BX1 U507 ( .AN(scon[4]), .B(scon[0]), .Y(n159) );
  XNOR2X1 U508 ( .A(div12), .B(n177), .Y(n253) );
  NAND3BX1 U509 ( .AN(cnt0_4[3]), .B(n306), .C(n179), .Y(n177) );
  XNOR2X1 U510 ( .A(cnt0_4[2]), .B(cnt0_4[1]), .Y(n179) );
  NAND2BX1 U511 ( .AN(n182), .B(n183), .Y(n162) );
  AND4X2 U512 ( .A(cnt1_8[3]), .B(n187), .C(n188), .D(n189), .Y(n183) );
  NAND4BX1 U513 ( .AN(cnt1_8[7]), .B(n192), .C(n190), .D(n191), .Y(n182) );
  NAND2X1 U514 ( .A(cnt0_4[1]), .B(cnt0_4[0]), .Y(n411) );
  NOR2X1 U515 ( .A(n5), .B(n343), .Y(n342) );
  NAND2X1 U516 ( .A(scon[5]), .B(n284), .Y(n343) );
  NAND3X1 U517 ( .A(n290), .B(n302), .C(n7), .Y(n336) );
  AND2X2 U518 ( .A(n321), .B(n162), .Y(n320) );
  AND4X2 U519 ( .A(n323), .B(cnt0_4[1]), .C(cnt0_4[3]), .D(cnt0_4[0]), .Y(n322) );
  NAND2BX1 U520 ( .AN(pcon[7]), .B(n43), .Y(n44) );
  NOR2BX1 U521 ( .AN(N239), .B(n322), .Y(n255) );
  XNOR2X1 U522 ( .A(cnt0_4[0]), .B(n303), .Y(N239) );
  NOR2BX1 U523 ( .AN(N241), .B(n322), .Y(n257) );
  XNOR2X1 U524 ( .A(n412), .B(n307), .Y(N241) );
  NOR2X1 U525 ( .A(n411), .B(n323), .Y(n412) );
  NOR2BX1 U526 ( .AN(N242), .B(n320), .Y(n2450) );
  NAND2X1 U527 ( .A(n336), .B(n311), .Y(n337) );
  CLKBUFX2 U528 ( .A(trans_cnt[1]), .Y(n406) );
  AO22X2 U529 ( .A0(rx_same[0]), .A1(n152), .B0(n153), .B1(rxdi), .Y(n197) );
  CLKINVX1 U530 ( .A(n152), .Y(n153) );
  NAND2BX1 U531 ( .AN(n128), .B(n154), .Y(n152) );
  AND4X2 U532 ( .A(rec_cnt[0]), .B(n301), .C(rec_cnt[2]), .D(rec_cnt[1]), .Y(
        n154) );
  AO22X2 U533 ( .A0(rx_same[1]), .A1(n147), .B0(n148), .B1(rxdi), .Y(n198) );
  CLKINVX1 U534 ( .A(n147), .Y(n148) );
  NAND2BX1 U535 ( .AN(n128), .B(n149), .Y(n147) );
  AND4X2 U536 ( .A(n3090), .B(n299), .C(rec_cnt[3]), .D(n305), .Y(n149) );
  AO22X2 U537 ( .A0(n46), .A1(n43), .B0(smod_clk_rec), .B1(n44), .Y(n194) );
  CLKINVX1 U538 ( .A(n47), .Y(n46) );
  AO22X2 U539 ( .A0(n42), .A1(n43), .B0(smod_clk_trans), .B1(n44), .Y(n225) );
  CLKINVX1 U540 ( .A(n45), .Y(n42) );
  OAI2BB1X1 U541 ( .A0N(rec_sync), .A1N(receive), .B0(n162), .Y(n2440) );
  NAND2BX1 U542 ( .AN(n156), .B(n133), .Y(n196) );
  OAI211X1 U543 ( .A0(n157), .A1(n5), .B0(rx_done), .C0(n298), .Y(n156) );
  AND4X2 U544 ( .A(rec_cnt[3]), .B(rec_cnt[0]), .C(n3090), .D(n299), .Y(n157)
         );
  CLKINVX2 U545 ( .A(rst_p), .Y(n186) );
  NAND2BX1 U546 ( .AN(n8), .B(n9), .Y(n6) );
  AOI31X1 U547 ( .A0(n318), .A1(n275), .A2(sbuf_txd_8_), .B0(n20), .Y(n8) );
  OAI221X1 U548 ( .A0(sbuf_rxd_tmp_0_), .A1(n284), .B0(n11), .B1(n12), .C0(
        receive), .Y(n9) );
  NAND2BX1 U549 ( .AN(receive), .B(trans3), .Y(n20) );
  NAND4BX1 U550 ( .AN(n15), .B(n3130), .C(sbuf_rxd_tmp_0_), .D(sbuf_rxd_tmp_1_), .Y(n11) );
  NAND3BX1 U551 ( .AN(sbuf_rxd_tmp_9_), .B(n277), .C(n284), .Y(n15) );
  NAND4BX1 U552 ( .AN(n13), .B(sbuf_rxd_tmp_5_), .C(sbuf_rxd_tmp_7_), .D(
        sbuf_rxd_tmp_6_), .Y(n12) );
  NAND3BX1 U553 ( .AN(n278), .B(sbuf_rxd_tmp_3_), .C(sbuf_rxd_tmp_4_), .Y(n13)
         );
  OAI2BB1X1 U554 ( .A0N(txd), .A1N(n3), .B0(n4), .Y(txdo) );
  CLKINVX1 U555 ( .A(n6), .Y(n3) );
  AOI32X1 U556 ( .A0(n5), .A1(div12), .A2(n6), .B0(txd), .B1(n7), .Y(n4) );
  DFFRX1 sbuf_rxd_reg_0_ ( .D(n215), .CK(clk), .RN(n186), .Q(sbuf[0]) );
  DFFRX1 scon_reg_2_ ( .D(n268), .CK(clk), .RN(n186), .Q(scon[2]), .QN(n311)
         );
  DFFRX1 sbuf_rxd_reg_2_ ( .D(n217), .CK(clk), .RN(n186), .Q(sbuf[2]) );
  DFFRX1 sbuf_rxd_reg_3_ ( .D(n218), .CK(clk), .RN(n186), .Q(sbuf[3]) );
  DFFRX1 sbuf_rxd_reg_6_ ( .D(n221), .CK(clk), .RN(n186), .Q(sbuf[6]) );
  DFFRX1 sbuf_rxd_reg_5_ ( .D(n220), .CK(clk), .RN(n186), .Q(sbuf[5]) );
  DFFRX1 scon_reg_3_ ( .D(n269), .CK(clk), .RN(n186), .Q(scon[3]), .QN(n324)
         );
  DFFRX1 pcon_reg_0_ ( .D(n258), .CK(clk), .RN(n186), .Q(pcon[0]), .QN(n332)
         );
  DFFRX1 pcon_reg_1_ ( .D(n259), .CK(clk), .RN(n186), .Q(pcon[1]), .QN(n331)
         );
  DFFRX1 pcon_reg_3_ ( .D(n261), .CK(clk), .RN(n186), .Q(pcon[3]), .QN(n329)
         );
  DFFRX1 pcon_reg_2_ ( .D(n260), .CK(clk), .RN(n186), .Q(pcon[2]), .QN(n330)
         );
  DFFRX1 pcon_reg_4_ ( .D(n262), .CK(clk), .RN(n186), .Q(pcon[4]), .QN(n328)
         );
  DFFRX1 pcon_reg_5_ ( .D(n263), .CK(clk), .RN(n186), .Q(pcon[5]), .QN(n327)
         );
  DFFRX1 pcon_reg_6_ ( .D(n264), .CK(clk), .RN(n186), .Q(pcon[6]), .QN(n326)
         );
  DFFSX2 rx_done_reg ( .D(n196), .CK(clk), .SN(n186), .Q(rx_done), .QN(n290)
         );
  DFFRX1 sbuf_txd_reg_2_ ( .D(n232), .CK(clk), .RN(n186), .Q(sbuf_txd_2_) );
  DFFRX1 sbuf_txd_reg_3_ ( .D(n233), .CK(clk), .RN(n186), .Q(sbuf_txd_3_) );
  DFFRX1 sbuf_txd_reg_5_ ( .D(n235), .CK(clk), .RN(n186), .Q(sbuf_txd_5_), 
        .QN(n283) );
  DFFRX1 sbuf_txd_reg_6_ ( .D(n236), .CK(clk), .RN(n186), .Q(sbuf_txd_6_), 
        .QN(n294) );
  DFFRX1 receive_reg ( .D(n195), .CK(clk), .RN(n186), .Q(receive), .QN(n321)
         );
  DFFRX1 sbuf_txd_reg_8_ ( .D(n238), .CK(clk), .RN(n186), .Q(sbuf_txd_8_) );
  DFFRX1 sbuf_txd_reg_9_ ( .D(n2390), .CK(clk), .RN(n186), .Q(sbuf_txd_9_), 
        .QN(n275) );
  DFFRX1 cnt1_8_reg_0_ ( .D(n2450), .CK(clk), .RN(n186), .Q(cnt1_8[0]), .QN(
        n187) );
  DFFRX1 sbuf_txd_reg_7_ ( .D(n237), .CK(clk), .RN(n186), .Q(sbuf_txd_7_) );
  DFFRX1 trans_reg ( .D(n2430), .CK(clk), .RN(n186), .Q(trans) );
  DFFRX1 shift_rec_reg ( .D(n193), .CK(clk), .RN(n186), .Q(shift_rec) );
  DFFRX1 sbuf_txd_reg_4_ ( .D(n234), .CK(clk), .RN(n186), .Q(sbuf_txd_4_) );
  DFFRX1 rec_sync_reg ( .D(n2440), .CK(clk), .RN(n186), .Q(rec_sync) );
  DFFRX1 rec_cnt_reg_2_ ( .D(n201), .CK(clk), .RN(n186), .Q(rec_cnt[2]), .QN(
        n299) );
  DFFRX1 cnt0_4_reg_1_ ( .D(n255), .CK(clk), .RN(n186), .Q(cnt0_4[1]), .QN(
        n303) );
  DFFRX1 cnt0_4_reg_0_ ( .D(n254), .CK(clk), .RN(n186), .Q(cnt0_4[0]), .QN(
        n306) );
  DFFRX1 sbuf_txd_reg_1_ ( .D(n231), .CK(clk), .RN(n186), .Q(sbuf_txd_1_), 
        .QN(n282) );
  DFFRX1 rec_cnt_reg_1_ ( .D(n200), .CK(clk), .RN(n186), .Q(rec_cnt[1]), .QN(
        n3090) );
  DFFRX1 sbuf_txd_reg_0_ ( .D(n230), .CK(clk), .RN(n186), .Q(sbuf_txd_0_), 
        .QN(n295) );
  DFFRX1 sbuf_rxd_tmp_reg_6_ ( .D(n209), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_6_), .QN(n297) );
  DFFRX1 cnt0_4_reg_3_ ( .D(n257), .CK(clk), .RN(n186), .Q(cnt0_4[3]), .QN(
        n307) );
  DFFRX1 sbuf_rxd_tmp_reg_7_ ( .D(n210), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_7_), .QN(n285) );
  DFFRX1 sbuf_rxd_tmp_reg_5_ ( .D(n208), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_5_), .QN(n279) );
  DFFRX1 sbuf_rxd_tmp_reg_3_ ( .D(n206), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_3_), .QN(n296) );
  DFFRX1 sbuf_rxd_tmp_reg_4_ ( .D(n207), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_4_), .QN(n286) );
  DFFRX1 sbuf_rxd_tmp_reg_0_ ( .D(n203), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_0_), .QN(n298) );
  DFFRX1 sbuf_rxd_tmp_reg_1_ ( .D(n204), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_1_), .QN(n287) );
  DFFRX1 sbuf_rxd_tmp_reg_9_ ( .D(n212), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_9_), .QN(n304) );
  DFFRX1 sbuf_rxd_tmp_reg_10_ ( .D(n213), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_10_), .QN(n3130) );
  DFFRX1 cnt0_4_reg_2_ ( .D(n256), .CK(clk), .RN(n186), .Q(cnt0_4[2]), .QN(
        n323) );
  DFFRX1 sbuf_rxd_tmp_reg_11_ ( .D(n214), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_11_), .QN(n284) );
  DFFRX1 rx_same_reg_0_ ( .D(n197), .CK(clk), .RN(n186), .Q(rx_same[0]), .QN(
        n3120) );
  DFFRX1 trans_cnt_reg_0_ ( .D(n226), .CK(clk), .RN(n186), .Q(trans_cnt[0]), 
        .QN(n291) );
  DFFRX1 trans_cnt_reg_2_ ( .D(n228), .CK(clk), .RN(n186), .Q(trans_cnt[2]), 
        .QN(n274) );
  DFFRX1 trans_cnt_reg_3_ ( .D(n229), .CK(clk), .RN(n186), .Q(trans_cnt[3]), 
        .QN(n281) );
  DFFRX1 sbuf_txd_reg_10_ ( .D(n2400), .CK(clk), .RN(n186), .QN(n318) );
  DFFRX1 smod_clk_rec_reg ( .D(n194), .CK(clk), .RN(n186), .Q(smod_clk_rec) );
  DFFRX1 sbuf_rxd_tmp_reg_8_ ( .D(n211), .CK(clk), .RN(n186), .Q(
        sbuf_rxd_tmp_8_), .QN(n277) );
  DFFRX1 smod_clk_trans_reg ( .D(n225), .CK(clk), .RN(n186), .Q(smod_clk_trans) );
  DFFRX1 sbuf_rxd_tmp_reg_2_ ( .D(n205), .CK(clk), .RN(n186), .QN(n278) );
  DFFSX2 rxdi_r_reg ( .D(n223), .CK(clk), .SN(n186), .QN(n300) );
  DFFRX1 trans_cnt_reg_1_ ( .D(n227), .CK(clk), .RN(n186), .Q(trans_cnt[1]), 
        .QN(n276) );
  DFFRX1 cnt1_8_reg_3_ ( .D(n2480), .CK(clk), .RN(n186), .Q(cnt1_8[3]) );
  DFFRX1 rx_same_reg_1_ ( .D(n198), .CK(clk), .RN(n186), .Q(rx_same[1]) );
  DFFRX1 cnt1_8_reg_7_ ( .D(n252), .CK(clk), .RN(n186), .Q(cnt1_8[7]) );
  DFFQX1 shift12_1_reg ( .D(shift12), .CK(clk), .Q(shift12_1) );
  DFFRX1 cnt1_8_reg_6_ ( .D(n251), .CK(clk), .RN(n186), .Q(cnt1_8[6]), .QN(
        n192) );
  DFFRX1 shift_trans_reg ( .D(n224), .CK(clk), .RN(n186), .Q(shift_trans) );
  DFFRX1 cnt1_8_reg_1_ ( .D(n2460), .CK(clk), .RN(n186), .Q(cnt1_8[1]), .QN(
        n188) );
  DFFRX1 cnt1_8_reg_2_ ( .D(n2470), .CK(clk), .RN(n186), .Q(cnt1_8[2]), .QN(
        n189) );
  DFFRX1 cnt1_8_reg_4_ ( .D(n2490), .CK(clk), .RN(n186), .Q(cnt1_8[4]), .QN(
        n190) );
  DFFRX1 cnt1_8_reg_5_ ( .D(n250), .CK(clk), .RN(n186), .Q(cnt1_8[5]), .QN(
        n191) );
  DFFRX1 txd_reg ( .D(n2420), .CK(clk), .RN(n186), .Q(txd) );
  DFFRX1 div12_reg ( .D(n253), .CK(clk), .RN(n186), .Q(div12) );
  DFFQX1 trans3_reg ( .D(trans2), .CK(clk), .Q(trans3) );
  CLKINVX1 U557 ( .A(addr_sfr[1]), .Y(n109) );
  CLKINVX1 U558 ( .A(addr_sfr[6]), .Y(n400) );
  INVX8 U559 ( .A(n333), .Y(n94) );
  u_uart_DW01_inc_8_0 add_160 ( .A(cnt1_8), .SUM({N249, N248, N247, N246, N245, 
        N244, N243, N242}) );
endmodule


module u_uart_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n5,
         n6;

  CLKINVX1 U5 ( .A(n6), .Y(carry_2_) );
  CLKINVX1 U6 ( .A(n4), .Y(carry_4_) );
  CLKINVX1 U7 ( .A(n2), .Y(carry_6_) );
  XNOR2X1 U8 ( .A(n1), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U9 ( .A(n5), .Y(carry_3_) );
  CLKINVX1 U10 ( .A(n3), .Y(carry_5_) );
  CLKINVX1 U11 ( .A(A[0]), .Y(SUM[0]) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n6) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n5) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n4) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n3) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n2) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n1) );
endmodule


module gpio1 ( clk, rst_p, wr, rmw, combus, prt1_addr, p1_in, p1, p1_out );
  input [7:0] combus;
  input [7:0] prt1_addr;
  input [7:0] p1_in;
  output [7:0] p1;
  output [7:0] p1_out;
  input clk, rst_p, wr, rmw;
  wire   n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45;

  NAND3BX1 U24 ( .AN(prt1_addr[3]), .B(n44), .C(n45), .Y(n41) );
  CLKINVX1 U25 ( .A(prt1_addr[0]), .Y(n43) );
  NOR2X1 U26 ( .A(n41), .B(n42), .Y(n33) );
  NAND4X1 U27 ( .A(prt1_addr[4]), .B(prt1_addr[7]), .C(n43), .D(wr), .Y(n42)
         );
  MXI2X1 U28 ( .S0(rmw), .B(n18), .A(n27), .Y(p1[4]) );
  MXI2X1 U29 ( .S0(rmw), .B(n21), .A(n30), .Y(p1[1]) );
  MXI2X1 U30 ( .S0(rmw), .B(n17), .A(n28), .Y(p1[3]) );
  MXI2X1 U31 ( .S0(rmw), .B(n22), .A(n29), .Y(p1[2]) );
  MXI2X1 U32 ( .S0(rmw), .B(n19), .A(n26), .Y(p1[5]) );
  MXI2X1 U33 ( .S0(rmw), .B(n23), .A(n25), .Y(p1[6]) );
  MXI2X1 U34 ( .S0(n33), .B(n34), .A(n20), .Y(n8) );
  CLKINVX1 U35 ( .A(combus[0]), .Y(n34) );
  MXI2X1 U36 ( .S0(n33), .B(n32), .A(n21), .Y(n9) );
  CLKINVX1 U37 ( .A(combus[1]), .Y(n32) );
  MXI2X1 U38 ( .S0(n33), .B(n40), .A(n22), .Y(n10) );
  CLKINVX1 U39 ( .A(combus[2]), .Y(n40) );
  MXI2X1 U40 ( .S0(n33), .B(n39), .A(n17), .Y(n11) );
  CLKINVX1 U41 ( .A(combus[3]), .Y(n39) );
  MXI2X1 U42 ( .S0(n33), .B(n38), .A(n18), .Y(n12) );
  CLKINVX1 U43 ( .A(combus[4]), .Y(n38) );
  MXI2X1 U44 ( .S0(n33), .B(n35), .A(n16), .Y(n15) );
  CLKINVX1 U45 ( .A(combus[7]), .Y(n35) );
  MXI2X1 U46 ( .S0(n33), .B(n36), .A(n23), .Y(n14) );
  CLKINVX1 U47 ( .A(combus[6]), .Y(n36) );
  MXI2X1 U48 ( .S0(n33), .B(n37), .A(n19), .Y(n13) );
  CLKINVX1 U49 ( .A(combus[5]), .Y(n37) );
  MXI2X1 U50 ( .S0(rmw), .B(n20), .A(n31), .Y(p1[0]) );
  CLKINVX1 U51 ( .A(p1_in[0]), .Y(n31) );
  MXI2X1 U52 ( .S0(rmw), .B(n16), .A(n24), .Y(p1[7]) );
  CLKINVX1 U53 ( .A(p1_in[7]), .Y(n24) );
  CLKINVX1 U54 ( .A(rst_p), .Y(n7) );
  CLKINVX1 U55 ( .A(p1_in[5]), .Y(n26) );
  CLKINVX1 U56 ( .A(p1_in[6]), .Y(n25) );
  CLKINVX1 U57 ( .A(p1_in[3]), .Y(n28) );
  CLKINVX1 U58 ( .A(p1_in[2]), .Y(n29) );
  CLKINVX1 U59 ( .A(p1_in[1]), .Y(n30) );
  CLKINVX1 U60 ( .A(p1_in[4]), .Y(n27) );
  DFFSX2 p1_out_reg_0_ ( .D(n8), .CK(clk), .SN(n7), .Q(p1_out[0]), .QN(n20) );
  DFFSX2 p1_out_reg_1_ ( .D(n9), .CK(clk), .SN(n7), .Q(p1_out[1]), .QN(n21) );
  DFFSX2 p1_out_reg_7_ ( .D(n15), .CK(clk), .SN(n7), .Q(p1_out[7]), .QN(n16)
         );
  DFFSX2 p1_out_reg_4_ ( .D(n12), .CK(clk), .SN(n7), .Q(p1_out[4]), .QN(n18)
         );
  DFFSX2 p1_out_reg_3_ ( .D(n11), .CK(clk), .SN(n7), .Q(p1_out[3]), .QN(n17)
         );
  DFFSX2 p1_out_reg_2_ ( .D(n10), .CK(clk), .SN(n7), .Q(p1_out[2]), .QN(n22)
         );
  DFFSX2 p1_out_reg_5_ ( .D(n13), .CK(clk), .SN(n7), .Q(p1_out[5]), .QN(n19)
         );
  DFFSX2 p1_out_reg_6_ ( .D(n14), .CK(clk), .SN(n7), .Q(p1_out[6]), .QN(n23)
         );
  NOR2X1 U61 ( .A(prt1_addr[2]), .B(prt1_addr[1]), .Y(n45) );
  NOR2X1 U62 ( .A(prt1_addr[6]), .B(prt1_addr[5]), .Y(n44) );
endmodule


module u_tc ( clk, rst_p, wr, in_tc, addr_tc, t0_pin, t1_pin, int0_pin, 
        int1_pin, sel_tc0, sel_tc1, gate0, gate1, tr0, tr1, tm0, tm1, tf0, tf1, 
        tl0, tl1, th0, th1, shift12 );
  input [7:0] in_tc;
  input [7:0] addr_tc;
  input [1:0] tm0;
  input [1:0] tm1;
  output [7:0] tl0;
  output [7:0] tl1;
  output [7:0] th0;
  output [7:0] th1;
  input clk, rst_p, wr, t0_pin, t1_pin, int0_pin, int1_pin, sel_tc0, sel_tc1,
         gate0, gate1, tr0, tr1;
  output tf0, tf1, shift12;
  wire   div12_3_, div12_1_, div12_0_, tf1_0, N223, N224, N225, N242, N243,
         N244, N245, N246, N247, N248, N249, N250, N251, N252, N253, N254,
         N255, N256, N257, N258, N259, N260, N261, N262, N263, N264, N265,
         N266, N267, N268, N269, N270, N271, N272, N273, N274, N275, N276,
         N277, N278, N279, N280, N281, N282, N283, N284, N285, N286, N287,
         N288, N289, N290, N291, N292, N293, N294, N295, N296, N297, N298,
         N299, N300, N301, N302, N303, N312, N322, N323, N324, N325, N326,
         N327, N328, N329, N330, N331, N332, N333, N334, N335, N336, N337, n17,
         n19, n20, n24, n25, n27, n28, n29, n30, n31, n33, n34, n35, n37, n38,
         n40, n41, n43, n44, n46, n47, n55, n62, n65, n69, n73, n75, n76, n80,
         n83, n85, n87, n88, n90, n95, n100, n105, n109, n110, n111, n113,
         n114, n120, n123, n142, n144, n149, n151, n153, n155, n157, n159,
         n161, n162, n164, n166, n168, n171, n172, n174, n177, n178, n181,
         n186, n190, n191, n192, n193, n194, n195, n196, n197, n199, n200,
         n201, n202, n209, n210, n212, n213, n214, n215, n216, n217, n218,
         n219, n220, n221, n222, n2230, n2240, n2250, n226, n227, n228, n229,
         n230, n231, n232, n233, n234, n235, n236, n237, n238, n239, n240,
         n241, n2420, n2430, n2440, n2450, n2460, n2470, n2480, n2490, n2500,
         n2510, n2520, n2540, n2550, n2560, n2570, n2580, n2590, n2600, n2610,
         n2620, n2630, n2640, n2650, n2660, n2670, n2680, n2690, n2700, n2710,
         n2720, n2730, n2740, n2750, n2760, n2770, n2780, n2790, n2800, n2810,
         n2820, n2830, n2840, n2850, n2860, n2870, n2880, n2890, n2900, n2910,
         n2920, n2930, n2940, n2950, n2960, n2970, n2980, n2990, n3000, n3010,
         n3020, n3030, n304, n305, n306, n307, n308, n309, n310, n311, n3120,
         n313, n314, n315, n316, n317, n318, n319, n320, n321, n3220, n3230,
         n3240, n3250, n3260, n3270, n3280, n3290, n3300, n3310, n3320, n3330,
         n3340, n3350, n3360, n3370, n338, n339, n340, n341, n342, n343, n344,
         n345, n346, n347, n348, n349, n350, n351, n352, n353, n354, n355,
         n356, n357, n358, n359, n360, n361, n362, n363, n364, n365, n366,
         n367, n368, n369, n370, n371, n372, n373, n374, n375, n376, n377,
         n378, n379, n380, n381, n382, n383, n384, n385, n386, n387, n388,
         n389, n390, n391, n392, n393, n394, n395, n396, n397, n398, n399,
         n400, n401, n402, n403, n404, n405, n406, n407, n408, n409, n410,
         n411, n412, n413, n414, n415, n416, n417, n418, n419, n420, n421,
         n422, n423, n424, n425, n426, n427, n428, n429, n430, n431, n432,
         n433, n434, n435, n436, n437, n438, n439, n440, n441, n442, n443,
         n444, n445, n446, n447, n448, n449, n450, n451, n452, n453, n454,
         n455, n456, n457, n458, n459, n460, n461, n462, n463, n464, n465,
         n466, n467, n468, n469, n470, n471, n472, n473, n474, n475, n476,
         n477, n478, n479, n480, n481, n482, n483, n484, n485, n486, n487,
         n488, n489, n490, n491, n492, n493, n494, n495, n496, n497, n498,
         n499, n500, n501, n502, n503, n504, n505, n506, n507, n508, n509,
         n510, n511, n512, n513, n514, n515, n516, n517, n518, n519, n520,
         n521, n522, n523, n524, n525, n526, n527, n528, n529, n530, n531,
         n532, n533, n534, n535, n536, n537, n538, n539, n540, n541, n542,
         n543, n544, n545, n546, n547, n548, n549, n550, n551, n552, n553,
         n554, n555, n556, n557, n558, n559, n560, n561, n562;

  CLKAND2X2 U248 ( .A(n428), .B(th1[0]), .Y(n2540) );
  AND3X1 U249 ( .A(addr_tc[1]), .B(n555), .C(n2800), .Y(n2550) );
  AND2X2 U250 ( .A(n69), .B(n366), .Y(n2560) );
  AND2X2 U251 ( .A(n69), .B(n416), .Y(n2570) );
  OR2X2 U252 ( .A(n460), .B(n502), .Y(n2580) );
  OR2X2 U253 ( .A(n460), .B(n495), .Y(n2590) );
  OR2X2 U254 ( .A(n460), .B(n488), .Y(n2600) );
  OR2X2 U255 ( .A(n460), .B(n481), .Y(n2610) );
  DFFRX1 th0_reg_1_ ( .D(n241), .CK(clk), .RN(n212), .Q(th0[1]), .QN(n2650) );
  CLKINVX1 U256 ( .A(n499), .Y(n43) );
  DFFRX1 th0_reg_0_ ( .D(n240), .CK(clk), .RN(n212), .Q(th0[0]), .QN(n2640) );
  AND3X1 U257 ( .A(addr_tc[2]), .B(n559), .C(n2800), .Y(n2750) );
  INVX1 U258 ( .A(n3360), .Y(n2420) );
  INVX1 U259 ( .A(n3310), .Y(n2430) );
  OAI21X1 U260 ( .A0(n144), .A1(n369), .B0(n69), .Y(n85) );
  NAND2X1 U261 ( .A(n202), .B(n558), .Y(n75) );
  NAND3X2 U262 ( .A(n527), .B(n528), .C(n529), .Y(n342) );
  INVX1 U263 ( .A(n492), .Y(n40) );
  NAND3X2 U264 ( .A(n532), .B(n533), .C(n534), .Y(n3370) );
  INVX1 U265 ( .A(n485), .Y(n37) );
  NAND3X2 U266 ( .A(n535), .B(n536), .C(n537), .Y(n3320) );
  NAND2X1 U267 ( .A(N281), .B(n531), .Y(n535) );
  NAND3X2 U268 ( .A(n538), .B(n539), .C(n540), .Y(n3260) );
  NAND2X1 U269 ( .A(N282), .B(n531), .Y(n538) );
  INVX1 U270 ( .A(n478), .Y(n33) );
  NAND3X1 U271 ( .A(n541), .B(n542), .C(n543), .Y(n3220) );
  NAND3X1 U272 ( .A(n547), .B(n548), .C(n549), .Y(n313) );
  NAND3X1 U273 ( .A(n544), .B(n545), .C(n546), .Y(n319) );
  NAND3X1 U274 ( .A(tm1[0]), .B(n514), .C(n181), .Y(n459) );
  OR2X2 U275 ( .A(n2740), .B(n509), .Y(n506) );
  AO21X1 U276 ( .A0(int1_pin), .A1(gate1), .B0(n171), .Y(n2740) );
  CLKINVX1 U277 ( .A(n73), .Y(n144) );
  CLKINVX1 U278 ( .A(n69), .Y(n359) );
  NAND2X1 U279 ( .A(n2550), .B(n554), .Y(n69) );
  NAND2X1 U280 ( .A(n2750), .B(n554), .Y(n73) );
  CLKINVX1 U281 ( .A(n3280), .Y(n316) );
  CLKINVX1 U282 ( .A(n186), .Y(n181) );
  NAND2BX1 U283 ( .AN(n172), .B(n47), .Y(n186) );
  CLKINVX1 U284 ( .A(n114), .Y(n172) );
  CLKINVX1 U285 ( .A(n47), .Y(n305) );
  NAND2X1 U286 ( .A(in_tc[1]), .B(n172), .Y(n452) );
  NAND2X1 U287 ( .A(in_tc[1]), .B(n305), .Y(n501) );
  NAND2X1 U288 ( .A(in_tc[1]), .B(n359), .Y(n403) );
  CLKINVX1 U289 ( .A(n31), .Y(n29) );
  NAND2X1 U290 ( .A(n166), .B(n110), .Y(n318) );
  NAND2X1 U291 ( .A(addr_tc[0]), .B(n2550), .Y(n47) );
  NAND2X1 U292 ( .A(n166), .B(n88), .Y(n3280) );
  NAND2X1 U293 ( .A(addr_tc[0]), .B(n2750), .Y(n114) );
  CLKINVX1 U294 ( .A(addr_tc[2]), .Y(n555) );
  CLKINVX1 U295 ( .A(n525), .Y(n531) );
  CLKINVX1 U296 ( .A(n83), .Y(n382) );
  AND2X2 U297 ( .A(n69), .B(n88), .Y(n2760) );
  NOR2X1 U298 ( .A(n359), .B(n375), .Y(n2770) );
  CLKINVX1 U299 ( .A(addr_tc[0]), .Y(n554) );
  CLKINVX1 U300 ( .A(n370), .Y(n110) );
  NOR2X1 U301 ( .A(n73), .B(n105), .Y(n524) );
  CLKINVX1 U302 ( .A(in_tc[0]), .Y(n105) );
  AOI21X1 U303 ( .A0(n346), .A1(n73), .B0(n347), .Y(n240) );
  CLKINVX1 U304 ( .A(n348), .Y(n346) );
  NOR2X1 U305 ( .A(in_tc[0]), .B(n348), .Y(n347) );
  NAND2X1 U306 ( .A(n349), .B(n350), .Y(n348) );
  NOR2X1 U307 ( .A(n407), .B(n408), .Y(n232) );
  NOR2X1 U308 ( .A(n414), .B(n415), .Y(n407) );
  NOR3BX1 U309 ( .AN(n105), .B(n409), .C(n410), .Y(n408) );
  NAND2X1 U310 ( .A(n411), .B(n69), .Y(n414) );
  NAND2X1 U311 ( .A(n172), .B(in_tc[2]), .Y(n448) );
  NAND2X1 U312 ( .A(n305), .B(in_tc[2]), .Y(n494) );
  NAND2X1 U313 ( .A(n359), .B(in_tc[2]), .Y(n396) );
  NAND2X1 U314 ( .A(n172), .B(in_tc[3]), .Y(n444) );
  NAND2X1 U315 ( .A(n305), .B(in_tc[3]), .Y(n487) );
  NAND2X1 U316 ( .A(n359), .B(in_tc[3]), .Y(n389) );
  NAND2X1 U317 ( .A(in_tc[5]), .B(n359), .Y(n374) );
  NAND2X1 U318 ( .A(in_tc[6]), .B(n359), .Y(n364) );
  NAND2X1 U319 ( .A(n172), .B(in_tc[5]), .Y(n436) );
  NAND2X1 U320 ( .A(n172), .B(in_tc[6]), .Y(n432) );
  NAND2X1 U321 ( .A(in_tc[7]), .B(n359), .Y(n358) );
  NAND2X1 U322 ( .A(in_tc[7]), .B(n172), .Y(n427) );
  CLKINVX1 U323 ( .A(n455), .Y(n428) );
  NAND2BX1 U324 ( .AN(n85), .B(n73), .Y(n197) );
  CLKINVX1 U325 ( .A(n460), .Y(n34) );
  NAND2X1 U326 ( .A(n461), .B(n505), .Y(n31) );
  NAND2X1 U327 ( .A(n457), .B(n34), .Y(n505) );
  AND2X2 U328 ( .A(n34), .B(n455), .Y(n2780) );
  AND2X2 U329 ( .A(n19), .B(n455), .Y(n2790) );
  CLKINVX1 U330 ( .A(n168), .Y(n166) );
  NAND2BX1 U331 ( .AN(n144), .B(n162), .Y(n168) );
  AND4X1 U332 ( .A(n2810), .B(addr_tc[3]), .C(wr), .D(addr_tc[7]), .Y(n2800)
         );
  NOR3X1 U333 ( .A(addr_tc[6]), .B(addr_tc[5]), .C(addr_tc[4]), .Y(n2810) );
  CLKINVX1 U334 ( .A(n162), .Y(n530) );
  NAND2X1 U335 ( .A(n85), .B(n69), .Y(n83) );
  CLKINVX1 U336 ( .A(n85), .Y(n384) );
  AND2X2 U337 ( .A(n2570), .B(n85), .Y(n2820) );
  NAND2X1 U338 ( .A(n162), .B(n550), .Y(n525) );
  CLKINVX1 U339 ( .A(n164), .Y(n550) );
  NAND3X1 U340 ( .A(n367), .B(n368), .C(n73), .Y(n366) );
  NAND3X1 U341 ( .A(n76), .B(n370), .C(n75), .Y(n367) );
  CLKINVX1 U342 ( .A(n411), .Y(n410) );
  NAND2X1 U343 ( .A(n419), .B(n558), .Y(n370) );
  CLKINVX1 U344 ( .A(n2870), .Y(n375) );
  CLKINVX1 U345 ( .A(n75), .Y(n88) );
  CLKINVX1 U346 ( .A(n76), .Y(n418) );
  CLKINVX1 U347 ( .A(n3120), .Y(n309) );
  NOR2X1 U348 ( .A(n453), .B(n454), .Y(n222) );
  NOR4X1 U349 ( .A(n172), .B(n2850), .C(n2840), .D(n2540), .Y(n453) );
  NOR4X1 U350 ( .A(in_tc[0]), .B(n2850), .C(n2840), .D(n2540), .Y(n454) );
  DFFRX1 th1_reg_0_ ( .D(n222), .CK(clk), .RN(n212), .Q(th1[0]) );
  CLKINVX1 U351 ( .A(n341), .Y(n241) );
  NOR2X1 U352 ( .A(n342), .B(n343), .Y(n341) );
  OAI22X1 U353 ( .A0(n3280), .A1(n344), .B0(n318), .B1(n345), .Y(n343) );
  CLKINVX1 U354 ( .A(N331), .Y(n345) );
  DFFRX1 th0_reg_2_ ( .D(n2420), .CK(clk), .RN(n212), .Q(th0[2]), .QN(n2660)
         );
  DFFRX1 th1_reg_1_ ( .D(n2230), .CK(clk), .RN(n212), .Q(th1[1]) );
  DFFRX1 th1_reg_2_ ( .D(n2240), .CK(clk), .RN(n212), .Q(th1[2]) );
  DFFRX1 tl1_reg_3_ ( .D(n217), .CK(clk), .RN(n212), .Q(tl1[3]), .QN(n2980) );
  DFFRX1 tl0_reg_3_ ( .D(n235), .CK(clk), .RN(n212), .Q(tl0[3]), .QN(n2940) );
  DFFRX1 tl1_reg_5_ ( .D(n219), .CK(clk), .RN(n212), .Q(tl1[5]), .QN(n2970) );
  NOR2X1 U355 ( .A(n3370), .B(n338), .Y(n3360) );
  OAI22X1 U356 ( .A0(n3280), .A1(n339), .B0(n318), .B1(n340), .Y(n338) );
  CLKINVX1 U357 ( .A(N332), .Y(n340) );
  NOR2X1 U358 ( .A(n3320), .B(n3330), .Y(n3310) );
  OAI22X1 U359 ( .A0(n3280), .A1(n3340), .B0(n318), .B1(n3350), .Y(n3330) );
  CLKINVX1 U360 ( .A(N333), .Y(n3350) );
  NAND2X1 U361 ( .A(n172), .B(in_tc[4]), .Y(n440) );
  NAND2X1 U362 ( .A(n305), .B(in_tc[4]), .Y(n480) );
  CLKINVX1 U363 ( .A(n3250), .Y(n2440) );
  NOR2X1 U364 ( .A(n3260), .B(n3270), .Y(n3250) );
  OAI22X1 U365 ( .A0(n3280), .A1(n3290), .B0(n318), .B1(n3300), .Y(n3270) );
  CLKINVX1 U366 ( .A(N334), .Y(n3300) );
  MXI2X1 U367 ( .S0(n29), .B(n2620), .A(n476), .Y(n218) );
  INVX1 U368 ( .A(n30), .Y(n476) );
  NAND2X1 U369 ( .A(n477), .B(n33), .Y(n30) );
  AOI2BB2X1 U370 ( .A0N(n459), .A1N(n482), .B0(N326), .B1(n2830), .Y(n477) );
  CLKINVX1 U371 ( .A(n385), .Y(n376) );
  NAND2X1 U372 ( .A(n359), .B(in_tc[4]), .Y(n385) );
  CLKINVX1 U373 ( .A(n28), .Y(n471) );
  NAND2X1 U374 ( .A(n472), .B(n473), .Y(n28) );
  NAND2X1 U375 ( .A(N327), .B(n2830), .Y(n473) );
  NAND2X1 U376 ( .A(in_tc[5]), .B(n305), .Y(n472) );
  NAND3BX1 U377 ( .AN(n313), .B(n314), .C(n315), .Y(n2470) );
  NAND2X1 U378 ( .A(N302), .B(n316), .Y(n315) );
  NAND2X1 U379 ( .A(N337), .B(n317), .Y(n314) );
  CLKINVX1 U380 ( .A(n318), .Y(n317) );
  NAND3BX1 U381 ( .AN(n319), .B(n320), .C(n321), .Y(n2460) );
  NAND2X1 U382 ( .A(N301), .B(n316), .Y(n321) );
  NAND2X1 U383 ( .A(N336), .B(n317), .Y(n320) );
  NAND3BX1 U384 ( .AN(n3220), .B(n3230), .C(n3240), .Y(n2450) );
  NAND2X1 U385 ( .A(N300), .B(n316), .Y(n3240) );
  NAND2X1 U386 ( .A(N335), .B(n317), .Y(n3230) );
  CLKINVX1 U387 ( .A(n25), .Y(n464) );
  NAND2X1 U388 ( .A(n465), .B(n466), .Y(n25) );
  NAND2X1 U389 ( .A(N328), .B(n2830), .Y(n466) );
  NAND2X1 U390 ( .A(in_tc[6]), .B(n305), .Y(n465) );
  CLKINVX1 U391 ( .A(n20), .Y(n517) );
  NAND2X1 U392 ( .A(n518), .B(n519), .Y(n20) );
  NAND2X1 U393 ( .A(N329), .B(n2830), .Y(n519) );
  NAND2X1 U394 ( .A(in_tc[7]), .B(n305), .Y(n518) );
  NOR2X1 U395 ( .A(n507), .B(n305), .Y(n461) );
  AOI21X1 U396 ( .A0(n459), .A1(n508), .B0(n506), .Y(n507) );
  NAND3X1 U397 ( .A(n513), .B(n514), .C(n181), .Y(n460) );
  AND2X2 U398 ( .A(n520), .B(n521), .Y(n2830) );
  NAND2X1 U399 ( .A(n73), .B(n551), .Y(n162) );
  OAI21X1 U400 ( .A0(n552), .A1(n553), .B0(n69), .Y(n551) );
  NOR2X1 U401 ( .A(n370), .B(n2880), .Y(n553) );
  NOR2X1 U402 ( .A(n556), .B(n369), .Y(n552) );
  NAND2X1 U403 ( .A(n114), .B(n456), .Y(n455) );
  NAND2X1 U404 ( .A(n457), .B(n458), .Y(n456) );
  NAND2X1 U405 ( .A(n459), .B(n460), .Y(n458) );
  AND2X2 U406 ( .A(N264), .B(n2790), .Y(n2840) );
  AND2X2 U407 ( .A(N247), .B(n2780), .Y(n2850) );
  CLKINVX1 U408 ( .A(n459), .Y(n19) );
  AOI21X1 U409 ( .A0(N295), .A1(n316), .B0(n352), .Y(n349) );
  NOR2X1 U410 ( .A(n318), .B(n353), .Y(n352) );
  CLKINVX1 U411 ( .A(N330), .Y(n353) );
  CLKINVX1 U412 ( .A(n508), .Y(n520) );
  NOR2BX1 U413 ( .AN(n520), .B(n521), .Y(n2860) );
  NAND2BX1 U414 ( .AN(n311), .B(n47), .Y(n3120) );
  OAI32X1 U415 ( .A0(n31), .A1(n172), .A2(n2670), .B0(n29), .B1(n174), .Y(n230) );
  AOI221X1 U416 ( .A0(N272), .A1(n19), .B0(N255), .B1(n34), .C0(n2860), .Y(
        n174) );
  NAND3X1 U417 ( .A(n69), .B(n73), .C(n87), .Y(n164) );
  NAND2X1 U418 ( .A(n417), .B(n370), .Y(n416) );
  NAND2X1 U419 ( .A(n111), .B(n418), .Y(n417) );
  CLKINVX1 U420 ( .A(N243), .Y(n502) );
  CLKINVX1 U421 ( .A(N244), .Y(n495) );
  CLKINVX1 U422 ( .A(N245), .Y(n488) );
  CLKINVX1 U423 ( .A(N246), .Y(n481) );
  NOR2X1 U424 ( .A(n459), .B(n475), .Y(n474) );
  CLKINVX1 U425 ( .A(N261), .Y(n475) );
  NAND2X1 U426 ( .A(n2820), .B(N330), .Y(n413) );
  NAND2X1 U427 ( .A(n420), .B(n382), .Y(n411) );
  NAND3X1 U428 ( .A(n421), .B(n422), .C(n423), .Y(n420) );
  NAND2X1 U429 ( .A(N287), .B(n88), .Y(n422) );
  NAND2X1 U430 ( .A(n87), .B(N273), .Y(n421) );
  NAND2X1 U431 ( .A(n412), .B(n413), .Y(n415) );
  NAND2X1 U432 ( .A(n412), .B(n413), .Y(n409) );
  CLKINVX1 U433 ( .A(n351), .Y(n350) );
  CLKINVX1 U434 ( .A(N296), .Y(n344) );
  CLKINVX1 U435 ( .A(N297), .Y(n339) );
  CLKINVX1 U436 ( .A(N298), .Y(n3340) );
  CLKINVX1 U437 ( .A(N299), .Y(n3290) );
  OAI2BB2X1 U438 ( .A0N(N275), .A1N(n87), .B0(n75), .B1(n399), .Y(n398) );
  CLKINVX1 U439 ( .A(N289), .Y(n399) );
  OAI2BB2X1 U440 ( .A0N(N276), .A1N(n87), .B0(n75), .B1(n392), .Y(n391) );
  CLKINVX1 U441 ( .A(N290), .Y(n392) );
  OAI2BB2X1 U442 ( .A0N(N277), .A1N(n87), .B0(n75), .B1(n383), .Y(n381) );
  CLKINVX1 U443 ( .A(N291), .Y(n383) );
  NOR2X1 U444 ( .A(n88), .B(n87), .Y(n556) );
  NOR2X1 U445 ( .A(n76), .B(n111), .Y(n2870) );
  CLKINVX1 U446 ( .A(N260), .Y(n482) );
  CLKINVX1 U447 ( .A(N259), .Y(n489) );
  CLKINVX1 U448 ( .A(N258), .Y(n496) );
  CLKINVX1 U449 ( .A(n506), .Y(n457) );
  CLKINVX1 U450 ( .A(n202), .Y(n419) );
  CLKINVX1 U451 ( .A(n201), .Y(n558) );
  CLKINVX1 U452 ( .A(n369), .Y(n368) );
  OAI211X1 U453 ( .A0(n171), .A1(n2890), .B0(n75), .C0(n76), .Y(n193) );
  NOR2BX1 U454 ( .AN(N224), .B(n2900), .Y(n2510) );
  XNOR2X1 U455 ( .A(n560), .B(n2910), .Y(N224) );
  CLKINVX1 U456 ( .A(n561), .Y(n560) );
  NAND2X1 U457 ( .A(n201), .B(n419), .Y(n76) );
  OAI2BB2X1 U458 ( .A0N(N274), .A1N(n87), .B0(n75), .B1(n406), .Y(n405) );
  CLKINVX1 U459 ( .A(N288), .Y(n406) );
  CLKINVX1 U460 ( .A(N257), .Y(n503) );
  NOR2X1 U461 ( .A(in_tc[0]), .B(n311), .Y(n310) );
  NAND2X1 U462 ( .A(n307), .B(n308), .Y(n306) );
  MXI2X1 U463 ( .S0(n29), .B(n3010), .A(n504), .Y(n214) );
  OAI21X1 U464 ( .A0(in_tc[0]), .A1(n311), .B0(n3120), .Y(n504) );
  NAND2X1 U465 ( .A(th0[1]), .B(n530), .Y(n528) );
  NAND2X1 U466 ( .A(N279), .B(n531), .Y(n527) );
  NAND2X1 U467 ( .A(in_tc[1]), .B(n144), .Y(n529) );
  NAND4BX1 U468 ( .AN(n400), .B(n401), .C(n402), .D(n403), .Y(n233) );
  NOR2X1 U469 ( .A(n85), .B(n2960), .Y(n400) );
  NAND2X1 U470 ( .A(n2820), .B(N331), .Y(n401) );
  OAI21X1 U471 ( .A0(n404), .A1(n405), .B0(n382), .Y(n402) );
  NAND4X1 U472 ( .A(n449), .B(n450), .C(n451), .D(n452), .Y(n2230) );
  NAND2X1 U473 ( .A(n428), .B(th1[1]), .Y(n451) );
  NAND2X1 U474 ( .A(N265), .B(n2790), .Y(n449) );
  NAND2X1 U475 ( .A(N248), .B(n2780), .Y(n450) );
  MXI2X1 U476 ( .S0(n29), .B(n3000), .A(n497), .Y(n215) );
  CLKINVX1 U477 ( .A(n41), .Y(n497) );
  NAND2X1 U478 ( .A(n498), .B(n43), .Y(n41) );
  AOI2BB2X1 U479 ( .A0N(n459), .A1N(n503), .B0(N323), .B1(n2830), .Y(n498) );
  NAND3X1 U480 ( .A(n2580), .B(n500), .C(n501), .Y(n499) );
  NAND2X1 U481 ( .A(th1[1]), .B(n2860), .Y(n500) );
  NAND2X1 U482 ( .A(th0[2]), .B(n530), .Y(n533) );
  NAND2X1 U483 ( .A(N280), .B(n531), .Y(n532) );
  NAND2X1 U484 ( .A(n144), .B(in_tc[2]), .Y(n534) );
  NAND4BX1 U485 ( .AN(n393), .B(n394), .C(n395), .D(n396), .Y(n234) );
  NOR2X1 U486 ( .A(n85), .B(n2950), .Y(n393) );
  NAND2X1 U487 ( .A(n2820), .B(N332), .Y(n394) );
  OAI21X1 U488 ( .A0(n397), .A1(n398), .B0(n382), .Y(n395) );
  NAND4X1 U489 ( .A(n445), .B(n446), .C(n447), .D(n448), .Y(n2240) );
  NAND2X1 U490 ( .A(n428), .B(th1[2]), .Y(n447) );
  NAND2X1 U491 ( .A(N266), .B(n2790), .Y(n445) );
  NAND2X1 U492 ( .A(N249), .B(n2780), .Y(n446) );
  MXI2X1 U493 ( .S0(n29), .B(n2990), .A(n490), .Y(n216) );
  CLKINVX1 U494 ( .A(n38), .Y(n490) );
  NAND2X1 U495 ( .A(n491), .B(n40), .Y(n38) );
  AOI2BB2X1 U496 ( .A0N(n459), .A1N(n496), .B0(N324), .B1(n2830), .Y(n491) );
  NAND3X1 U497 ( .A(n2590), .B(n493), .C(n494), .Y(n492) );
  NAND2X1 U498 ( .A(th1[2]), .B(n2860), .Y(n493) );
  NAND2X1 U499 ( .A(th0[3]), .B(n530), .Y(n536) );
  NAND2X1 U500 ( .A(n144), .B(in_tc[3]), .Y(n537) );
  NAND4BX1 U501 ( .AN(n386), .B(n387), .C(n388), .D(n389), .Y(n235) );
  NOR2X1 U502 ( .A(n85), .B(n2940), .Y(n386) );
  NAND2X1 U503 ( .A(n2820), .B(N333), .Y(n387) );
  OAI21X1 U504 ( .A0(n390), .A1(n391), .B0(n382), .Y(n388) );
  NAND4X1 U505 ( .A(n441), .B(n442), .C(n443), .D(n444), .Y(n2250) );
  NAND2X1 U506 ( .A(n428), .B(th1[3]), .Y(n443) );
  NAND2X1 U507 ( .A(N267), .B(n2790), .Y(n441) );
  NAND2X1 U508 ( .A(N250), .B(n2780), .Y(n442) );
  MXI2X1 U509 ( .S0(n29), .B(n2980), .A(n483), .Y(n217) );
  CLKINVX1 U510 ( .A(n35), .Y(n483) );
  NAND2X1 U511 ( .A(n484), .B(n37), .Y(n35) );
  AOI2BB2X1 U512 ( .A0N(n459), .A1N(n489), .B0(N325), .B1(n2830), .Y(n484) );
  NAND3X1 U513 ( .A(n2600), .B(n486), .C(n487), .Y(n485) );
  NAND2X1 U514 ( .A(th1[3]), .B(n2860), .Y(n486) );
  NAND2X1 U515 ( .A(th0[4]), .B(n530), .Y(n539) );
  NAND2X1 U516 ( .A(n144), .B(in_tc[4]), .Y(n540) );
  NAND4BX1 U517 ( .AN(n376), .B(n377), .C(n378), .D(n379), .Y(n236) );
  NAND2X1 U518 ( .A(tl0[4]), .B(n384), .Y(n377) );
  OAI21X1 U519 ( .A0(n380), .A1(n381), .B0(n382), .Y(n378) );
  NAND2X1 U520 ( .A(n2820), .B(N334), .Y(n379) );
  NAND4X1 U521 ( .A(n437), .B(n438), .C(n439), .D(n440), .Y(n226) );
  NAND2X1 U522 ( .A(n428), .B(th1[4]), .Y(n439) );
  NAND2X1 U523 ( .A(N268), .B(n2790), .Y(n437) );
  NAND2X1 U524 ( .A(N251), .B(n2780), .Y(n438) );
  NAND3X1 U525 ( .A(n2610), .B(n479), .C(n480), .Y(n478) );
  NAND2X1 U526 ( .A(th1[4]), .B(n2860), .Y(n479) );
  NAND4X1 U527 ( .A(n371), .B(n372), .C(n373), .D(n374), .Y(n3020) );
  NAND2X1 U528 ( .A(N292), .B(n2760), .Y(n372) );
  NAND2X1 U529 ( .A(N335), .B(n2570), .Y(n373) );
  NAND2X1 U530 ( .A(th0[5]), .B(n2770), .Y(n371) );
  NAND4X1 U531 ( .A(n361), .B(n362), .C(n363), .D(n364), .Y(n3030) );
  NAND2X1 U532 ( .A(N293), .B(n2760), .Y(n362) );
  NAND2X1 U533 ( .A(N336), .B(n2570), .Y(n363) );
  NAND2X1 U534 ( .A(th0[6]), .B(n2770), .Y(n361) );
  NAND4X1 U535 ( .A(n355), .B(n356), .C(n357), .D(n358), .Y(n304) );
  NAND2X1 U536 ( .A(N294), .B(n2760), .Y(n356) );
  NAND2X1 U537 ( .A(N337), .B(n2570), .Y(n357) );
  NAND2X1 U538 ( .A(th0[7]), .B(n2770), .Y(n355) );
  CLKINVX1 U539 ( .A(n354), .Y(n239) );
  MXI2X1 U540 ( .S0(n2560), .B(tl0[7]), .A(n304), .Y(n354) );
  MXI2X1 U541 ( .S0(n461), .B(n2690), .A(n24), .Y(n220) );
  INVX1 U542 ( .A(n462), .Y(n24) );
  NAND2X1 U543 ( .A(n463), .B(n464), .Y(n462) );
  MXI2X1 U544 ( .S0(n461), .B(n2970), .A(n27), .Y(n219) );
  CLKINVX1 U545 ( .A(n469), .Y(n27) );
  NAND2X1 U546 ( .A(n470), .B(n471), .Y(n469) );
  AOI21X1 U547 ( .A0(th1[5]), .A1(n2860), .B0(n474), .Y(n470) );
  NAND2X1 U548 ( .A(th0[5]), .B(n530), .Y(n542) );
  NAND2X1 U549 ( .A(N283), .B(n531), .Y(n541) );
  NAND2X1 U550 ( .A(in_tc[5]), .B(n144), .Y(n543) );
  NAND2X1 U551 ( .A(th0[6]), .B(n530), .Y(n545) );
  NAND2X1 U552 ( .A(N284), .B(n531), .Y(n544) );
  NAND2X1 U553 ( .A(in_tc[6]), .B(n144), .Y(n546) );
  NAND4X1 U554 ( .A(n433), .B(n434), .C(n435), .D(n436), .Y(n227) );
  NAND2X1 U555 ( .A(n428), .B(th1[5]), .Y(n435) );
  NAND2X1 U556 ( .A(N269), .B(n2790), .Y(n433) );
  NAND2X1 U557 ( .A(N252), .B(n2780), .Y(n434) );
  NAND4X1 U558 ( .A(n429), .B(n430), .C(n431), .D(n432), .Y(n228) );
  NAND2X1 U559 ( .A(n428), .B(th1[6]), .Y(n431) );
  NAND2X1 U560 ( .A(N270), .B(n2790), .Y(n429) );
  NAND2X1 U561 ( .A(N253), .B(n2780), .Y(n430) );
  NAND2X1 U562 ( .A(th0[7]), .B(n530), .Y(n548) );
  NAND2X1 U563 ( .A(N285), .B(n531), .Y(n547) );
  NAND2X1 U564 ( .A(in_tc[7]), .B(n144), .Y(n549) );
  NAND4X1 U565 ( .A(n424), .B(n425), .C(n426), .D(n427), .Y(n229) );
  NAND2X1 U566 ( .A(th1[7]), .B(n428), .Y(n426) );
  NAND2X1 U567 ( .A(N271), .B(n2790), .Y(n424) );
  NAND2X1 U568 ( .A(N254), .B(n2780), .Y(n425) );
  MXI2X1 U569 ( .S0(n461), .B(n2730), .A(n17), .Y(n221) );
  INVX1 U570 ( .A(n515), .Y(n17) );
  NAND2X1 U571 ( .A(n516), .B(n517), .Y(n515) );
  CLKINVX1 U572 ( .A(n360), .Y(n238) );
  MXI2X1 U573 ( .S0(n2560), .B(tl0[6]), .A(n3030), .Y(n360) );
  CLKINVX1 U574 ( .A(n365), .Y(n237) );
  MXI2X1 U575 ( .S0(n2560), .B(tl0[5]), .A(n3020), .Y(n365) );
  NAND4X1 U576 ( .A(n511), .B(n307), .C(n512), .D(n308), .Y(n311) );
  NAND2X1 U577 ( .A(N256), .B(n19), .Y(n511) );
  NAND2X1 U578 ( .A(N322), .B(n2830), .Y(n512) );
  NAND3X1 U579 ( .A(tm1[1]), .B(n513), .C(n181), .Y(n508) );
  NAND2X1 U580 ( .A(th1[0]), .B(n2860), .Y(n308) );
  NAND2X1 U581 ( .A(N242), .B(n34), .Y(n307) );
  OAI222X1 U582 ( .A0(n194), .A1(n195), .B0(n196), .B1(n83), .C0(n197), .C1(
        n213), .Y(n2480) );
  AOI221X1 U583 ( .A0(N303), .A1(n88), .B0(N312), .B1(n110), .C0(n2870), .Y(
        n196) );
  NAND2BX1 U584 ( .AN(n164), .B(N286), .Y(n195) );
  CLKINVX1 U585 ( .A(n197), .Y(n194) );
  OAI22X1 U586 ( .A0(n525), .A1(n526), .B0(n162), .B1(n2640), .Y(n351) );
  CLKINVX1 U587 ( .A(N278), .Y(n526) );
  NAND2X1 U588 ( .A(tl0[0]), .B(n384), .Y(n412) );
  AOI21X1 U589 ( .A0(th1[6]), .A1(n2860), .B0(n467), .Y(n463) );
  NOR2X1 U590 ( .A(n459), .B(n468), .Y(n467) );
  CLKINVX1 U591 ( .A(N262), .Y(n468) );
  AOI21X1 U592 ( .A0(th1[7]), .A1(n2860), .B0(n522), .Y(n516) );
  NOR2X1 U593 ( .A(n459), .B(n523), .Y(n522) );
  CLKINVX1 U594 ( .A(N263), .Y(n523) );
  NOR3BX1 U595 ( .AN(n69), .B(n190), .C(n144), .Y(n231) );
  AOI32X1 U596 ( .A0(n110), .A1(N312), .A2(n191), .B0(tf1_0), .B1(n192), .Y(
        n190) );
  CLKINVX1 U597 ( .A(n191), .Y(n192) );
  NAND2BX1 U598 ( .AN(n193), .B(n164), .Y(n191) );
  NAND4X1 U599 ( .A(tl0[7]), .B(tl0[6]), .C(n199), .D(n200), .Y(n111) );
  NOR2BX1 U600 ( .AN(tl0[5]), .B(n2630), .Y(n199) );
  AND4X1 U601 ( .A(tl0[3]), .B(tl0[2]), .C(tl0[1]), .D(tl0[0]), .Y(n200) );
  NAND4X1 U602 ( .A(tl1[7]), .B(tl1[6]), .C(n177), .D(n178), .Y(n521) );
  NOR2BX1 U603 ( .AN(tl1[5]), .B(n2620), .Y(n177) );
  AND4X1 U604 ( .A(tl1[3]), .B(tl1[2]), .C(tl1[1]), .D(tl1[0]), .Y(n178) );
  NAND3X1 U605 ( .A(tr0), .B(n557), .C(n210), .Y(n369) );
  NAND2X1 U606 ( .A(sel_tc0), .B(n2920), .Y(n557) );
  AOI222X1 U607 ( .A0(t0_pin), .A1(sel_tc0), .B0(int0_pin), .B1(gate0), .C0(
        n209), .C1(n2890), .Y(n210) );
  CLKINVX1 U608 ( .A(sel_tc0), .Y(n209) );
  CLKINVX1 U609 ( .A(n109), .Y(n87) );
  NAND2BX1 U610 ( .AN(tm0[0]), .B(n202), .Y(n109) );
  NAND2X1 U611 ( .A(th0[0]), .B(n2870), .Y(n423) );
  CLKINVX1 U612 ( .A(tm0[1]), .Y(n202) );
  MXI2X1 U613 ( .S0(sel_tc1), .B(n510), .A(shift12), .Y(n509) );
  CLKINVX1 U614 ( .A(tm1[0]), .Y(n513) );
  CLKINVX1 U615 ( .A(tm1[1]), .Y(n514) );
  CLKINVX1 U616 ( .A(tm0[0]), .Y(n201) );
  NOR2X1 U617 ( .A(n375), .B(n2650), .Y(n404) );
  NOR2X1 U618 ( .A(n375), .B(n2660), .Y(n397) );
  NOR2X1 U619 ( .A(n375), .B(n2700), .Y(n390) );
  NOR2X1 U620 ( .A(n375), .B(n2710), .Y(n380) );
  CLKINVX1 U621 ( .A(tr1), .Y(n171) );
  OR2X2 U622 ( .A(n2890), .B(n171), .Y(n2880) );
  NOR2BX1 U623 ( .AN(N225), .B(n2900), .Y(n2520) );
  XNOR2X1 U624 ( .A(n562), .B(n2720), .Y(N225) );
  NOR2X1 U625 ( .A(n561), .B(n2910), .Y(n562) );
  NAND2BX1 U626 ( .AN(tf1_0), .B(n2670), .Y(tf1) );
  NAND2X1 U627 ( .A(div12_1_), .B(div12_0_), .Y(n561) );
  NOR2X1 U628 ( .A(t1_pin), .B(n2930), .Y(n510) );
  AND4X2 U629 ( .A(n2910), .B(div12_0_), .C(div12_3_), .D(div12_1_), .Y(n2900)
         );
  NOR2BX1 U630 ( .AN(N223), .B(n2900), .Y(n2500) );
  XNOR2X1 U631 ( .A(div12_0_), .B(n2680), .Y(N223) );
  NOR2X1 U632 ( .A(div12_0_), .B(n2900), .Y(n2490) );
  CLKINVX2 U633 ( .A(rst_p), .Y(n212) );
  DFFRX1 tl0_reg_2_ ( .D(n234), .CK(clk), .RN(n212), .Q(tl0[2]), .QN(n2950) );
  DFFRX1 tl1_reg_2_ ( .D(n216), .CK(clk), .RN(n212), .Q(tl1[2]), .QN(n2990) );
  DFFRX1 tl0_reg_1_ ( .D(n233), .CK(clk), .RN(n212), .Q(tl0[1]), .QN(n2960) );
  DFFRX1 tl1_reg_1_ ( .D(n215), .CK(clk), .RN(n212), .Q(tl1[1]), .QN(n3000) );
  DFFRX1 shift12_reg ( .D(n2900), .CK(clk), .RN(n212), .Q(shift12), .QN(n2890)
         );
  DFFRX1 div12_reg_0_ ( .D(n2490), .CK(clk), .RN(n212), .Q(div12_0_) );
  DFFRX1 div12_reg_1_ ( .D(n2500), .CK(clk), .RN(n212), .Q(div12_1_), .QN(
        n2680) );
  DFFRX1 div12_reg_3_ ( .D(n2520), .CK(clk), .RN(n212), .Q(div12_3_), .QN(
        n2720) );
  DFFRX1 tf0_reg ( .D(n2480), .CK(clk), .RN(n212), .Q(tf0), .QN(n213) );
  DFFRX1 div12_reg_2_ ( .D(n2510), .CK(clk), .RN(n212), .QN(n2910) );
  DFFRX1 tf1_1_reg ( .D(n230), .CK(clk), .RN(n212), .QN(n2670) );
  DFFRX1 t1_pin_r_reg ( .D(t1_pin), .CK(clk), .RN(n212), .QN(n2930) );
  DFFRX1 t0_pin_r_reg ( .D(t0_pin), .CK(clk), .RN(n212), .QN(n2920) );
  DFFRX1 tf1_0_reg ( .D(n231), .CK(clk), .RN(n212), .Q(tf1_0) );
  CLKINVX1 U634 ( .A(addr_tc[1]), .Y(n559) );
  INVX12 U635 ( .A(in_tc[2]), .Y(n95) );
  INVX12 U636 ( .A(in_tc[3]), .Y(n90) );
  INVX12 U637 ( .A(in_tc[4]), .Y(n80) );
  INVX8 U638 ( .A(n3020), .Y(n65) );
  INVX8 U639 ( .A(n3030), .Y(n62) );
  INVX8 U640 ( .A(n304), .Y(n55) );
  AOI21X4 U641 ( .A0(in_tc[0]), .A1(n305), .B0(n306), .Y(n46) );
  NOR2X8 U642 ( .A(n309), .B(n310), .Y(n44) );
  NOR2X8 U643 ( .A(n524), .B(n351), .Y(n161) );
  INVX8 U644 ( .A(n342), .Y(n159) );
  INVX8 U645 ( .A(n3370), .Y(n157) );
  INVX8 U646 ( .A(n3320), .Y(n155) );
  INVX8 U647 ( .A(n3260), .Y(n153) );
  INVX8 U648 ( .A(n3220), .Y(n151) );
  INVX8 U649 ( .A(n319), .Y(n149) );
  INVX8 U650 ( .A(n313), .Y(n142) );
  INVX12 U651 ( .A(in_tc[5]), .Y(n123) );
  INVX12 U652 ( .A(in_tc[6]), .Y(n120) );
  INVX12 U653 ( .A(in_tc[7]), .Y(n113) );
  INVX12 U654 ( .A(in_tc[1]), .Y(n100) );
  u_tc_DW01_inc_8_0 add_200 ( .A(tl1), .SUM({N329, N328, N327, N326, N325, 
        N324, N323, N322}) );
  u_tc_DW01_inc_17_1 add_190 ( .A({1'b0, th1, tl1}), .SUM({N272, N271, N270, 
        N269, N268, N267, N266, N265, N264, N263, N262, N261, N260, N259, N258, 
        N257, N256}) );
  u_tc_DW01_inc_14_1 add_184 ( .A({1'b0, th1, tl1[4:0]}), .SUM({N255, N254, 
        N253, N252, N251, N250, N249, N248, N247, N246, N245, N244, N243, N242}) );
  u_tc_DW01_inc_17_0 add_137 ( .A({1'b0, th0, tl0}), .SUM({N303, N302, N301, 
        N300, N299, N298, N297, N296, N295, N294, N293, N292, N291, N290, N289, 
        N288, N287}) );
  u_tc_DW01_inc_14_0 add_130 ( .A({1'b0, th0, tl0[4:0]}), .SUM({N286, N285, 
        N284, N283, N282, N281, N280, N279, N278, N277, N276, N275, N274, N273}) );
  u_tc_DW01_inc_9_0 r112 ( .A({1'b0, tl0}), .SUM({N312, N337, N336, N335, N334, 
        N333, N332, N331, N330}) );
  DFFRX4 th0_reg_7_ ( .D(n2470), .CK(clk), .RN(n212), .Q(th0[7]) );
  DFFRX4 th0_reg_6_ ( .D(n2460), .CK(clk), .RN(n212), .Q(th0[6]) );
  DFFRX4 th0_reg_5_ ( .D(n2450), .CK(clk), .RN(n212), .Q(th0[5]) );
  DFFRX4 th0_reg_4_ ( .D(n2440), .CK(clk), .RN(n212), .Q(th0[4]), .QN(n2710)
         );
  DFFRX4 th0_reg_3_ ( .D(n2430), .CK(clk), .RN(n212), .Q(th0[3]), .QN(n2700)
         );
  DFFRX4 tl0_reg_7_ ( .D(n239), .CK(clk), .RN(n212), .Q(tl0[7]) );
  DFFRX4 tl0_reg_6_ ( .D(n238), .CK(clk), .RN(n212), .Q(tl0[6]) );
  DFFRX4 tl0_reg_5_ ( .D(n237), .CK(clk), .RN(n212), .Q(tl0[5]) );
  DFFRX4 tl0_reg_4_ ( .D(n236), .CK(clk), .RN(n212), .Q(tl0[4]), .QN(n2630) );
  DFFRX4 tl0_reg_0_ ( .D(n232), .CK(clk), .RN(n212), .Q(tl0[0]) );
  DFFRX4 th1_reg_7_ ( .D(n229), .CK(clk), .RN(n212), .Q(th1[7]) );
  DFFRX4 th1_reg_6_ ( .D(n228), .CK(clk), .RN(n212), .Q(th1[6]) );
  DFFRX4 th1_reg_5_ ( .D(n227), .CK(clk), .RN(n212), .Q(th1[5]) );
  DFFRX4 th1_reg_4_ ( .D(n226), .CK(clk), .RN(n212), .Q(th1[4]) );
  DFFRX4 th1_reg_3_ ( .D(n2250), .CK(clk), .RN(n212), .Q(th1[3]) );
  DFFRX4 tl1_reg_7_ ( .D(n221), .CK(clk), .RN(n212), .Q(tl1[7]), .QN(n2730) );
  DFFRX4 tl1_reg_6_ ( .D(n220), .CK(clk), .RN(n212), .Q(tl1[6]), .QN(n2690) );
  DFFRX4 tl1_reg_4_ ( .D(n218), .CK(clk), .RN(n212), .Q(tl1[4]), .QN(n2620) );
  DFFRX4 tl1_reg_0_ ( .D(n214), .CK(clk), .RN(n212), .Q(tl1[0]), .QN(n3010) );
endmodule


module u_tc_DW01_inc_9_0 ( A, SUM );
  input [8:0] A;
  output [8:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1, n2,
         n3, n4, n5, n6, n7;

  CLKINVX1 U5 ( .A(n1), .Y(SUM[8]) );
  CLKINVX1 U6 ( .A(n5), .Y(carry_4_) );
  CLKINVX1 U7 ( .A(n2), .Y(carry_7_) );
  CLKINVX1 U8 ( .A(n3), .Y(carry_6_) );
  CLKINVX1 U9 ( .A(n4), .Y(carry_5_) );
  CLKINVX1 U10 ( .A(n6), .Y(carry_3_) );
  CLKINVX1 U11 ( .A(n7), .Y(carry_2_) );
  CLKINVX1 U12 ( .A(A[0]), .Y(SUM[0]) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n7) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n6) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n5) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n4) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n3) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n2) );
  AHHCONX2 U1_1_7 ( .A(A[7]), .CI(carry_7_), .S(SUM[7]), .CON(n1) );
endmodule


module u_tc_DW01_inc_14_0 ( A, SUM );
  input [13:0] A;
  output [13:0] SUM;
  wire   carry_12_, carry_11_, carry_10_, carry_9_, carry_8_, carry_7_,
         carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n5,
         n6, n7, n8, n9, n10, n11, n12;

  CLKINVX1 U5 ( .A(n1), .Y(SUM[13]) );
  CLKINVX1 U6 ( .A(n10), .Y(carry_4_) );
  CLKINVX1 U7 ( .A(n9), .Y(carry_5_) );
  CLKINVX1 U8 ( .A(n5), .Y(carry_9_) );
  CLKINVX1 U9 ( .A(n6), .Y(carry_8_) );
  CLKINVX1 U10 ( .A(n7), .Y(carry_7_) );
  CLKINVX1 U11 ( .A(n8), .Y(carry_6_) );
  CLKINVX1 U12 ( .A(n2), .Y(carry_12_) );
  CLKINVX1 U13 ( .A(n3), .Y(carry_11_) );
  CLKINVX1 U14 ( .A(n4), .Y(carry_10_) );
  CLKINVX1 U15 ( .A(n11), .Y(carry_3_) );
  CLKINVX1 U16 ( .A(n12), .Y(carry_2_) );
  CLKINVX1 U17 ( .A(A[0]), .Y(SUM[0]) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n12) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n11) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n10) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n9) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n8) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n7) );
  AHHCONX2 U1_1_7 ( .A(A[7]), .CI(carry_7_), .S(SUM[7]), .CON(n6) );
  AHHCONX2 U1_1_8 ( .A(A[8]), .CI(carry_8_), .S(SUM[8]), .CON(n5) );
  AHHCONX2 U1_1_9 ( .A(A[9]), .CI(carry_9_), .S(SUM[9]), .CON(n4) );
  AHHCONX2 U1_1_10 ( .A(A[10]), .CI(carry_10_), .S(SUM[10]), .CON(n3) );
  AHHCONX2 U1_1_11 ( .A(A[11]), .CI(carry_11_), .S(SUM[11]), .CON(n2) );
  AHHCONX2 U1_1_12 ( .A(A[12]), .CI(carry_12_), .S(SUM[12]), .CON(n1) );
endmodule


module u_tc_DW01_inc_17_0 ( A, SUM );
  input [16:0] A;
  output [16:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15;

  CLKINVX1 U5 ( .A(n1), .Y(SUM[16]) );
  CLKINVX1 U6 ( .A(n13), .Y(carry_4_) );
  CLKINVX1 U7 ( .A(n10), .Y(carry_7_) );
  CLKINVX1 U8 ( .A(n11), .Y(carry_6_) );
  CLKINVX1 U9 ( .A(n8), .Y(carry_9_) );
  CLKINVX1 U10 ( .A(n7), .Y(carry_10_) );
  CLKINVX1 U11 ( .A(n6), .Y(carry_11_) );
  CLKINVX1 U12 ( .A(n5), .Y(carry_12_) );
  CLKINVX1 U13 ( .A(n4), .Y(carry_13_) );
  CLKINVX1 U14 ( .A(n3), .Y(carry_14_) );
  CLKINVX1 U15 ( .A(n2), .Y(carry_15_) );
  CLKINVX1 U16 ( .A(n12), .Y(carry_5_) );
  CLKINVX1 U17 ( .A(n14), .Y(carry_3_) );
  CLKINVX1 U18 ( .A(n15), .Y(carry_2_) );
  CLKINVX1 U19 ( .A(n9), .Y(carry_8_) );
  CLKINVX1 U20 ( .A(A[0]), .Y(SUM[0]) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n15) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n14) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n13) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n12) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n11) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n10) );
  AHHCONX2 U1_1_7 ( .A(A[7]), .CI(carry_7_), .S(SUM[7]), .CON(n9) );
  AHHCONX2 U1_1_8 ( .A(A[8]), .CI(carry_8_), .S(SUM[8]), .CON(n8) );
  AHHCONX2 U1_1_9 ( .A(A[9]), .CI(carry_9_), .S(SUM[9]), .CON(n7) );
  AHHCONX2 U1_1_10 ( .A(A[10]), .CI(carry_10_), .S(SUM[10]), .CON(n6) );
  AHHCONX2 U1_1_11 ( .A(A[11]), .CI(carry_11_), .S(SUM[11]), .CON(n5) );
  AHHCONX2 U1_1_12 ( .A(A[12]), .CI(carry_12_), .S(SUM[12]), .CON(n4) );
  AHHCONX2 U1_1_13 ( .A(A[13]), .CI(carry_13_), .S(SUM[13]), .CON(n3) );
  AHHCONX2 U1_1_14 ( .A(A[14]), .CI(carry_14_), .S(SUM[14]), .CON(n2) );
  AHHCONX2 U1_1_15 ( .A(A[15]), .CI(carry_15_), .S(SUM[15]), .CON(n1) );
endmodule


module u_tc_DW01_inc_14_1 ( A, SUM );
  input [13:0] A;
  output [13:0] SUM;
  wire   carry_12_, carry_11_, carry_10_, carry_9_, carry_8_, carry_7_,
         carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n5,
         n6, n7, n8, n9, n10, n11, n12;

  CLKINVX1 U5 ( .A(n1), .Y(SUM[13]) );
  CLKINVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
  CLKINVX1 U7 ( .A(n9), .Y(carry_5_) );
  CLKINVX1 U8 ( .A(n10), .Y(carry_4_) );
  CLKINVX1 U9 ( .A(n8), .Y(carry_6_) );
  CLKINVX1 U10 ( .A(n7), .Y(carry_7_) );
  CLKINVX1 U11 ( .A(n6), .Y(carry_8_) );
  CLKINVX1 U12 ( .A(n5), .Y(carry_9_) );
  CLKINVX1 U13 ( .A(n4), .Y(carry_10_) );
  CLKINVX1 U14 ( .A(n3), .Y(carry_11_) );
  CLKINVX1 U15 ( .A(n2), .Y(carry_12_) );
  CLKINVX1 U16 ( .A(n11), .Y(carry_3_) );
  CLKINVX1 U17 ( .A(n12), .Y(carry_2_) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n12) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n11) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n10) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n9) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n8) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n7) );
  AHHCONX2 U1_1_7 ( .A(A[7]), .CI(carry_7_), .S(SUM[7]), .CON(n6) );
  AHHCONX2 U1_1_8 ( .A(A[8]), .CI(carry_8_), .S(SUM[8]), .CON(n5) );
  AHHCONX2 U1_1_9 ( .A(A[9]), .CI(carry_9_), .S(SUM[9]), .CON(n4) );
  AHHCONX2 U1_1_10 ( .A(A[10]), .CI(carry_10_), .S(SUM[10]), .CON(n3) );
  AHHCONX2 U1_1_11 ( .A(A[11]), .CI(carry_11_), .S(SUM[11]), .CON(n2) );
  AHHCONX2 U1_1_12 ( .A(A[12]), .CI(carry_12_), .S(SUM[12]), .CON(n1) );
endmodule


module u_tc_DW01_inc_17_1 ( A, SUM );
  input [16:0] A;
  output [16:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15;

  CLKINVX1 U5 ( .A(n1), .Y(SUM[16]) );
  CLKINVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
  CLKINVX1 U7 ( .A(n10), .Y(carry_7_) );
  CLKINVX1 U8 ( .A(n11), .Y(carry_6_) );
  CLKINVX1 U9 ( .A(n13), .Y(carry_4_) );
  CLKINVX1 U10 ( .A(n8), .Y(carry_9_) );
  CLKINVX1 U11 ( .A(n7), .Y(carry_10_) );
  CLKINVX1 U12 ( .A(n6), .Y(carry_11_) );
  CLKINVX1 U13 ( .A(n5), .Y(carry_12_) );
  CLKINVX1 U14 ( .A(n4), .Y(carry_13_) );
  CLKINVX1 U15 ( .A(n3), .Y(carry_14_) );
  CLKINVX1 U16 ( .A(n2), .Y(carry_15_) );
  CLKINVX1 U17 ( .A(n15), .Y(carry_2_) );
  CLKINVX1 U18 ( .A(n12), .Y(carry_5_) );
  CLKINVX1 U19 ( .A(n9), .Y(carry_8_) );
  CLKINVX1 U20 ( .A(n14), .Y(carry_3_) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n15) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n14) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n13) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n12) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n11) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n10) );
  AHHCONX2 U1_1_7 ( .A(A[7]), .CI(carry_7_), .S(SUM[7]), .CON(n9) );
  AHHCONX2 U1_1_8 ( .A(A[8]), .CI(carry_8_), .S(SUM[8]), .CON(n8) );
  AHHCONX2 U1_1_9 ( .A(A[9]), .CI(carry_9_), .S(SUM[9]), .CON(n7) );
  AHHCONX2 U1_1_10 ( .A(A[10]), .CI(carry_10_), .S(SUM[10]), .CON(n6) );
  AHHCONX2 U1_1_11 ( .A(A[11]), .CI(carry_11_), .S(SUM[11]), .CON(n5) );
  AHHCONX2 U1_1_12 ( .A(A[12]), .CI(carry_12_), .S(SUM[12]), .CON(n4) );
  AHHCONX2 U1_1_13 ( .A(A[13]), .CI(carry_13_), .S(SUM[13]), .CON(n3) );
  AHHCONX2 U1_1_14 ( .A(A[14]), .CI(carry_14_), .S(SUM[14]), .CON(n2) );
  AHHCONX2 U1_1_15 ( .A(A[15]), .CI(carry_15_), .S(SUM[15]), .CON(n1) );
endmodule


module u_tc_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n5,
         n6;

  CLKINVX1 U5 ( .A(n2), .Y(carry_6_) );
  XNOR2X1 U6 ( .A(n1), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U7 ( .A(n4), .Y(carry_4_) );
  CLKINVX1 U8 ( .A(n5), .Y(carry_3_) );
  CLKINVX1 U9 ( .A(n6), .Y(carry_2_) );
  CLKINVX1 U10 ( .A(n3), .Y(carry_5_) );
  CLKINVX1 U11 ( .A(A[0]), .Y(SUM[0]) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n6) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n5) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n4) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n3) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n2) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n1) );
endmodule


module tmod ( clk, rst_p, wr, in_tmod, addr_tmod, out_tmod );
  input [7:0] in_tmod;
  input [7:0] addr_tmod;
  output [7:0] out_tmod;
  input clk, rst_p, wr;
  wire   n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37;

  NOR2X1 U16 ( .A(n33), .B(n34), .Y(n25) );
  NAND3X1 U17 ( .A(n35), .B(n36), .C(n37), .Y(n34) );
  NAND4X1 U18 ( .A(addr_tmod[3]), .B(addr_tmod[0]), .C(addr_tmod[7]), .D(wr), 
        .Y(n33) );
  CLKINVX1 U19 ( .A(addr_tmod[4]), .Y(n36) );
  DFFRX1 out_tmod_reg_4_ ( .D(n12), .CK(clk), .RN(n7), .Q(out_tmod[4]), .QN(
        n19) );
  DFFRX1 out_tmod_reg_5_ ( .D(n13), .CK(clk), .RN(n7), .Q(out_tmod[5]), .QN(
        n18) );
  DFFRX1 out_tmod_reg_2_ ( .D(n10), .CK(clk), .RN(n7), .Q(out_tmod[2]), .QN(
        n21) );
  DFFRX1 out_tmod_reg_6_ ( .D(n14), .CK(clk), .RN(n7), .Q(out_tmod[6]), .QN(
        n17) );
  DFFRX1 out_tmod_reg_7_ ( .D(n15), .CK(clk), .RN(n7), .Q(out_tmod[7]), .QN(
        n16) );
  MXI2X1 U20 ( .S0(n25), .B(n26), .A(n23), .Y(n8) );
  CLKINVX1 U21 ( .A(in_tmod[0]), .Y(n26) );
  MXI2X1 U22 ( .S0(n25), .B(n24), .A(n22), .Y(n9) );
  CLKINVX1 U23 ( .A(in_tmod[1]), .Y(n24) );
  MXI2X1 U24 ( .S0(n25), .B(n32), .A(n21), .Y(n10) );
  CLKINVX1 U25 ( .A(in_tmod[2]), .Y(n32) );
  MXI2X1 U26 ( .S0(n25), .B(n31), .A(n20), .Y(n11) );
  CLKINVX1 U27 ( .A(in_tmod[3]), .Y(n31) );
  MXI2X1 U28 ( .S0(n25), .B(n30), .A(n19), .Y(n12) );
  CLKINVX1 U29 ( .A(in_tmod[4]), .Y(n30) );
  MXI2X1 U30 ( .S0(n25), .B(n28), .A(n17), .Y(n14) );
  CLKINVX1 U31 ( .A(in_tmod[6]), .Y(n28) );
  MXI2X1 U32 ( .S0(n25), .B(n27), .A(n16), .Y(n15) );
  CLKINVX1 U33 ( .A(in_tmod[7]), .Y(n27) );
  MXI2X1 U34 ( .S0(n25), .B(n29), .A(n18), .Y(n13) );
  CLKINVX1 U35 ( .A(in_tmod[5]), .Y(n29) );
  CLKINVX1 U36 ( .A(rst_p), .Y(n7) );
  DFFRX1 out_tmod_reg_0_ ( .D(n8), .CK(clk), .RN(n7), .Q(out_tmod[0]), .QN(n23) );
  DFFRX1 out_tmod_reg_1_ ( .D(n9), .CK(clk), .RN(n7), .Q(out_tmod[1]), .QN(n22) );
  DFFRX1 out_tmod_reg_3_ ( .D(n11), .CK(clk), .RN(n7), .Q(out_tmod[3]), .QN(
        n20) );
  NOR2X1 U37 ( .A(addr_tmod[2]), .B(addr_tmod[1]), .Y(n37) );
  NOR2X1 U38 ( .A(addr_tmod[6]), .B(addr_tmod[5]), .Y(n35) );
endmodule


module tcon ( clk, rst_p, in_tcon, addr_tcon, wr, set_tf0, rst_tf0, set_tf1, 
        rst_tf1, set_ie0, rst_ie0, set_ie1, rst_ie1, out_tcon );
  input [7:0] in_tcon;
  input [7:0] addr_tcon;
  output [7:0] out_tcon;
  input clk, rst_p, wr, set_tf0, rst_tf0, set_tf1, rst_tf1, set_ie0, rst_ie0,
         set_ie1, rst_ie1;
  wire   set_tf0_d1, set_tf1_d1, set_ie0_d1, set_ie1_d1, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82;

  DFFRX1 tcon_reg_0_ ( .D(n31), .CK(clk), .RN(n22), .Q(out_tcon[0]), .QN(n38)
         );
  NAND3BX1 U32 ( .AN(addr_tcon[4]), .B(n80), .C(n81), .Y(n79) );
  CLKINVX1 U33 ( .A(n52), .Y(n48) );
  CLKINVX1 U34 ( .A(n53), .Y(n52) );
  CLKINVX1 U35 ( .A(addr_tcon[0]), .Y(n82) );
  NOR2X1 U36 ( .A(n78), .B(n79), .Y(n53) );
  NAND4X1 U37 ( .A(addr_tcon[7]), .B(n82), .C(addr_tcon[3]), .D(wr), .Y(n78)
         );
  DFFRX1 tcon_reg_1_ ( .D(n32), .CK(clk), .RN(n22), .Q(out_tcon[2]), .QN(n37)
         );
  DFFRX1 tcon_tf1_reg ( .D(n29), .CK(clk), .RN(n22), .Q(out_tcon[7]), .QN(n42)
         );
  DFFRX1 tcon_tf0_reg ( .D(n30), .CK(clk), .RN(n22), .Q(out_tcon[5]), .QN(n40)
         );
  DFFRX1 tcon_reg_3_ ( .D(n34), .CK(clk), .RN(n22), .Q(out_tcon[6]), .QN(n35)
         );
  DFFRX1 tcon_reg_2_ ( .D(n33), .CK(clk), .RN(n22), .Q(out_tcon[4]), .QN(n36)
         );
  MXI2X1 U38 ( .S0(n48), .B(n51), .A(n38), .Y(n31) );
  CLKINVX1 U39 ( .A(in_tcon[0]), .Y(n51) );
  NAND2BX1 U40 ( .AN(set_ie0), .B(n66), .Y(n28) );
  OAI21X1 U41 ( .A0(in_tcon[1]), .A1(n67), .B0(n68), .Y(n66) );
  NAND2X1 U42 ( .A(n67), .B(n69), .Y(n68) );
  NAND3X1 U43 ( .A(n23), .B(n43), .C(n53), .Y(n67) );
  MXI2X1 U44 ( .S0(n48), .B(n50), .A(n37), .Y(n32) );
  CLKINVX1 U45 ( .A(in_tcon[2]), .Y(n50) );
  NAND2BX1 U46 ( .AN(set_ie1), .B(n72), .Y(n27) );
  OAI21X1 U47 ( .A0(in_tcon[3]), .A1(n73), .B0(n74), .Y(n72) );
  NAND2X1 U48 ( .A(n73), .B(n75), .Y(n74) );
  NAND3X1 U49 ( .A(n24), .B(n45), .C(n53), .Y(n73) );
  MXI2X1 U50 ( .S0(n48), .B(n49), .A(n36), .Y(n33) );
  CLKINVX1 U51 ( .A(in_tcon[4]), .Y(n49) );
  NAND2BX1 U52 ( .AN(set_tf1), .B(n60), .Y(n29) );
  OAI21X1 U53 ( .A0(in_tcon[7]), .A1(n61), .B0(n62), .Y(n60) );
  NAND2X1 U54 ( .A(n61), .B(n63), .Y(n62) );
  NAND3X1 U55 ( .A(n26), .B(n41), .C(n53), .Y(n61) );
  MXI2X1 U56 ( .S0(n48), .B(n47), .A(n35), .Y(n34) );
  CLKINVX1 U57 ( .A(in_tcon[6]), .Y(n47) );
  NAND2BX1 U58 ( .AN(set_tf0), .B(n54), .Y(n30) );
  OAI21X1 U59 ( .A0(in_tcon[5]), .A1(n55), .B0(n56), .Y(n54) );
  NAND2X1 U60 ( .A(n55), .B(n57), .Y(n56) );
  NAND3X1 U61 ( .A(n25), .B(n39), .C(n53), .Y(n55) );
  NAND2X1 U62 ( .A(n64), .B(n65), .Y(n63) );
  CLKINVX1 U63 ( .A(n42), .Y(n64) );
  CLKINVX1 U64 ( .A(rst_tf1), .Y(n65) );
  NAND2X1 U65 ( .A(n76), .B(n77), .Y(n75) );
  CLKINVX1 U66 ( .A(n46), .Y(n76) );
  CLKINVX1 U67 ( .A(rst_ie1), .Y(n77) );
  NAND2X1 U68 ( .A(n70), .B(n71), .Y(n69) );
  CLKINVX1 U69 ( .A(n44), .Y(n70) );
  CLKINVX1 U70 ( .A(rst_ie0), .Y(n71) );
  NAND2X1 U71 ( .A(n58), .B(n59), .Y(n57) );
  CLKINVX1 U72 ( .A(n40), .Y(n58) );
  CLKINVX1 U73 ( .A(rst_tf0), .Y(n59) );
  CLKINVX1 U74 ( .A(rst_p), .Y(n22) );
  DFFRX1 tcon_ie1_reg ( .D(n27), .CK(clk), .RN(n22), .Q(out_tcon[3]), .QN(n46)
         );
  DFFRX1 tcon_ie0_reg ( .D(n28), .CK(clk), .RN(n22), .Q(out_tcon[1]), .QN(n44)
         );
  DFFRX1 set_ie1_d1_reg ( .D(set_ie1), .CK(clk), .RN(n22), .Q(set_ie1_d1), 
        .QN(n24) );
  DFFRX1 set_ie0_d1_reg ( .D(set_ie0), .CK(clk), .RN(n22), .Q(set_ie0_d1), 
        .QN(n23) );
  DFFRX1 set_tf1_d1_reg ( .D(set_tf1), .CK(clk), .RN(n22), .Q(set_tf1_d1), 
        .QN(n26) );
  DFFRX1 set_tf0_d1_reg ( .D(set_tf0), .CK(clk), .RN(n22), .Q(set_tf0_d1), 
        .QN(n25) );
  DFFRX1 set_ie1_d2_reg ( .D(set_ie1_d1), .CK(clk), .RN(n22), .QN(n45) );
  DFFRX1 set_ie0_d2_reg ( .D(set_ie0_d1), .CK(clk), .RN(n22), .QN(n43) );
  DFFRX1 set_tf1_d2_reg ( .D(set_tf1_d1), .CK(clk), .RN(n22), .QN(n41) );
  DFFRX1 set_tf0_d2_reg ( .D(set_tf0_d1), .CK(clk), .RN(n22), .QN(n39) );
  NOR2X1 U75 ( .A(addr_tcon[2]), .B(addr_tcon[1]), .Y(n81) );
  NOR2X1 U76 ( .A(addr_tcon[6]), .B(addr_tcon[5]), .Y(n80) );
endmodule


module dimod ( clk, rst_p, wr, addr_dimod, in_dimod, out_dimod );
  input [7:0] addr_dimod;
  input [7:0] in_dimod;
  output [7:0] out_dimod;
  input clk, rst_p, wr;
  wire   n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35, n36;

  NOR2X1 U15 ( .A(n31), .B(n32), .Y(n23) );
  NAND4X1 U16 ( .A(addr_dimod[2]), .B(addr_dimod[7]), .C(n33), .D(wr), .Y(n32)
         );
  NAND3X1 U17 ( .A(n34), .B(n35), .C(n36), .Y(n31) );
  CLKINVX1 U18 ( .A(addr_dimod[0]), .Y(n33) );
  CLKINVX1 U19 ( .A(addr_dimod[4]), .Y(n34) );
  DFFRX1 out_dimod_reg_1_ ( .D(n7), .CK(clk), .RN(n5), .Q(out_dimod[1]), .QN(
        n20) );
  MXI2X1 U20 ( .S0(n23), .B(n26), .A(n21), .Y(n6) );
  CLKINVX1 U21 ( .A(in_dimod[0]), .Y(n26) );
  MXI2X1 U22 ( .S0(n23), .B(n25), .A(n20), .Y(n7) );
  CLKINVX1 U23 ( .A(in_dimod[1]), .Y(n25) );
  MXI2X1 U24 ( .S0(n23), .B(n24), .A(n19), .Y(n8) );
  CLKINVX1 U25 ( .A(in_dimod[2]), .Y(n24) );
  MXI2X1 U26 ( .S0(n23), .B(n22), .A(n18), .Y(n9) );
  CLKINVX1 U27 ( .A(in_dimod[3]), .Y(n22) );
  MXI2X1 U28 ( .S0(n23), .B(n30), .A(n17), .Y(n10) );
  CLKINVX1 U29 ( .A(in_dimod[4]), .Y(n30) );
  MXI2X1 U30 ( .S0(n23), .B(n28), .A(n15), .Y(n12) );
  CLKINVX1 U31 ( .A(in_dimod[6]), .Y(n28) );
  MXI2X1 U32 ( .S0(n23), .B(n27), .A(n14), .Y(n13) );
  CLKINVX1 U33 ( .A(in_dimod[7]), .Y(n27) );
  MXI2X1 U34 ( .S0(n23), .B(n29), .A(n16), .Y(n11) );
  CLKINVX1 U35 ( .A(in_dimod[5]), .Y(n29) );
  CLKINVX1 U36 ( .A(rst_p), .Y(n5) );
  DFFRX1 out_dimod_reg_0_ ( .D(n6), .CK(clk), .RN(n5), .Q(out_dimod[0]), .QN(
        n21) );
  DFFRX1 out_dimod_reg_2_ ( .D(n8), .CK(clk), .RN(n5), .Q(out_dimod[2]), .QN(
        n19) );
  DFFRX1 out_dimod_reg_3_ ( .D(n9), .CK(clk), .RN(n5), .Q(out_dimod[3]), .QN(
        n18) );
  DFFRX1 out_dimod_reg_4_ ( .D(n10), .CK(clk), .RN(n5), .Q(out_dimod[4]), .QN(
        n17) );
  DFFRX1 out_dimod_reg_5_ ( .D(n11), .CK(clk), .RN(n5), .Q(out_dimod[5]), .QN(
        n16) );
  DFFRX1 out_dimod_reg_6_ ( .D(n12), .CK(clk), .RN(n5), .Q(out_dimod[6]), .QN(
        n15) );
  DFFRX1 out_dimod_reg_7_ ( .D(n13), .CK(clk), .RN(n5), .Q(out_dimod[7]), .QN(
        n14) );
  NOR2X1 U37 ( .A(addr_dimod[3]), .B(addr_dimod[1]), .Y(n36) );
  NOR2X1 U38 ( .A(addr_dimod[6]), .B(addr_dimod[5]), .Y(n35) );
endmodule


module dptr ( clk, rst_p, ld_dpl, ld_dph, wr, inc_dptr, addr_dptr, in_dptr, 
        out_dptr );
  input [7:0] addr_dptr;
  input [7:0] in_dptr;
  output [15:0] out_dptr;
  input clk, rst_p, ld_dpl, ld_dph, wr, inc_dptr;
  wire   N34, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47,
         N48, N49, n7, n8, n10, n11, n12, n13, n14, n15, n26, n30, n32, n33,
         n340, n350, n360, n370, n380, n390, n400, n410, n420, n430, n440,
         n450, n460, n470, n480, n490, n50, n51, n52, n53, n54, n55, n56, n57,
         n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71,
         n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85,
         n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110,
         n111, n112, n113, n114, n115, n116, n117, n118, n119, n120;

  AND2X2 U53 ( .A(n74), .B(n75), .Y(n52) );
  AND2X2 U54 ( .A(N42), .B(n58), .Y(n53) );
  AND2X2 U55 ( .A(N34), .B(n58), .Y(n54) );
  INVX1 U56 ( .A(n15), .Y(n97) );
  INVX1 U57 ( .A(n14), .Y(n95) );
  DFFRX1 out_dptr_reg_10_ ( .D(n460), .CK(clk), .RN(n350), .Q(out_dptr[10]) );
  DFFRX1 out_dptr_reg_8_ ( .D(n440), .CK(clk), .RN(n350), .Q(out_dptr[8]) );
  INVX1 U58 ( .A(n13), .Y(n93) );
  AND2X1 U59 ( .A(out_dptr[8]), .B(n59), .Y(n55) );
  NOR3X1 U60 ( .A(n8), .B(n79), .C(n75), .Y(n58) );
  AND2X2 U61 ( .A(n117), .B(n82), .Y(n85) );
  NAND2X1 U62 ( .A(inc_dptr), .B(n78), .Y(n117) );
  CLKINVX1 U63 ( .A(n8), .Y(n82) );
  CLKINVX1 U64 ( .A(n75), .Y(n78) );
  NAND2X1 U65 ( .A(n82), .B(n77), .Y(n59) );
  NAND2X1 U66 ( .A(n78), .B(n79), .Y(n77) );
  CLKINVX1 U67 ( .A(n59), .Y(n74) );
  CLKINVX1 U68 ( .A(inc_dptr), .Y(n79) );
  CLKINVX1 U69 ( .A(in_dptr[1]), .Y(n105) );
  NAND2X1 U70 ( .A(n118), .B(n119), .Y(n8) );
  CLKINVX1 U71 ( .A(ld_dpl), .Y(n118) );
  NAND2X1 U72 ( .A(n32), .B(n120), .Y(n119) );
  OR2X2 U73 ( .A(n32), .B(ld_dph), .Y(n75) );
  CLKINVX1 U74 ( .A(addr_dptr[0]), .Y(n120) );
  CLKINVX1 U75 ( .A(in_dptr[0]), .Y(n76) );
  CLKINVX1 U76 ( .A(in_dptr[2]), .Y(n107) );
  CLKINVX1 U77 ( .A(in_dptr[3]), .Y(n109) );
  CLKINVX1 U78 ( .A(in_dptr[5]), .Y(n113) );
  CLKINVX1 U79 ( .A(in_dptr[6]), .Y(n115) );
  CLKINVX1 U80 ( .A(in_dptr[7]), .Y(n83) );
  CLKINVX1 U81 ( .A(n30), .Y(n32) );
  NAND4BX1 U82 ( .AN(n33), .B(addr_dptr[7]), .C(n340), .D(wr), .Y(n30) );
  NOR2BX1 U83 ( .AN(n76), .B(n101), .Y(n103) );
  CLKINVX1 U84 ( .A(n100), .Y(n102) );
  NOR2X1 U85 ( .A(n72), .B(n73), .Y(n440) );
  NOR3X1 U86 ( .A(n53), .B(n52), .C(n55), .Y(n73) );
  NOR3BX1 U87 ( .AN(n76), .B(n53), .C(n55), .Y(n72) );
  AOI21X1 U88 ( .A0(n76), .A1(n98), .B0(n99), .Y(n360) );
  NOR2X1 U89 ( .A(n54), .B(n101), .Y(n98) );
  NOR2X1 U90 ( .A(n54), .B(n100), .Y(n99) );
  NAND2X1 U91 ( .A(n96), .B(n97), .Y(n370) );
  NAND2X1 U92 ( .A(N35), .B(n58), .Y(n96) );
  OAI21X1 U93 ( .A0(n82), .A1(n105), .B0(n106), .Y(n15) );
  DFFRX1 out_dptr_reg_9_ ( .D(n450), .CK(clk), .RN(n350), .Q(out_dptr[9]) );
  DFFRX1 out_dptr_reg_15_ ( .D(n51), .CK(clk), .RN(n350), .Q(out_dptr[15]) );
  DFFRX1 out_dptr_reg_14_ ( .D(n50), .CK(clk), .RN(n350), .Q(out_dptr[14]) );
  NAND2X1 U94 ( .A(n94), .B(n95), .Y(n380) );
  NAND2X1 U95 ( .A(N36), .B(n58), .Y(n94) );
  OAI21X1 U96 ( .A0(n82), .A1(n107), .B0(n108), .Y(n14) );
  NAND2X1 U97 ( .A(n92), .B(n93), .Y(n390) );
  NAND2X1 U98 ( .A(N37), .B(n58), .Y(n92) );
  OAI21X1 U99 ( .A0(n82), .A1(n109), .B0(n110), .Y(n13) );
  CLKINVX1 U100 ( .A(in_dptr[4]), .Y(n111) );
  NAND2X1 U101 ( .A(n90), .B(n91), .Y(n400) );
  NAND2X1 U102 ( .A(N38), .B(n58), .Y(n90) );
  INVX1 U103 ( .A(n12), .Y(n91) );
  OAI21X1 U104 ( .A0(n82), .A1(n111), .B0(n112), .Y(n12) );
  NAND2X1 U105 ( .A(n80), .B(n81), .Y(n430) );
  NAND2X1 U106 ( .A(N41), .B(n58), .Y(n80) );
  INVX1 U107 ( .A(n7), .Y(n81) );
  OAI21X1 U108 ( .A0(n82), .A1(n83), .B0(n84), .Y(n7) );
  NAND2X1 U109 ( .A(n86), .B(n87), .Y(n420) );
  NAND2X1 U110 ( .A(N40), .B(n58), .Y(n86) );
  INVX1 U111 ( .A(n10), .Y(n87) );
  OAI21X1 U112 ( .A0(n82), .A1(n115), .B0(n116), .Y(n10) );
  NAND2X1 U113 ( .A(n88), .B(n89), .Y(n410) );
  NAND2X1 U114 ( .A(N39), .B(n58), .Y(n88) );
  INVX1 U115 ( .A(n11), .Y(n89) );
  OAI21X1 U116 ( .A0(n82), .A1(n113), .B0(n114), .Y(n11) );
  NAND2X1 U117 ( .A(n104), .B(n82), .Y(n100) );
  CLKINVX1 U118 ( .A(n104), .Y(n101) );
  NAND2X1 U119 ( .A(n70), .B(n71), .Y(n450) );
  AOI22X1 U120 ( .A0(N43), .A1(n58), .B0(out_dptr[9]), .B1(n59), .Y(n70) );
  NAND2X1 U121 ( .A(in_dptr[1]), .B(n52), .Y(n71) );
  NAND2X1 U122 ( .A(n68), .B(n69), .Y(n460) );
  AOI22X1 U123 ( .A0(N44), .A1(n58), .B0(out_dptr[10]), .B1(n59), .Y(n68) );
  NAND2X1 U124 ( .A(in_dptr[2]), .B(n52), .Y(n69) );
  NAND2X1 U125 ( .A(n66), .B(n67), .Y(n470) );
  AOI22X1 U126 ( .A0(N45), .A1(n58), .B0(out_dptr[11]), .B1(n59), .Y(n66) );
  NAND2X1 U127 ( .A(in_dptr[3]), .B(n52), .Y(n67) );
  NAND2X1 U128 ( .A(n64), .B(n65), .Y(n480) );
  AOI22X1 U129 ( .A0(N46), .A1(n58), .B0(out_dptr[12]), .B1(n59), .Y(n64) );
  NAND2X1 U130 ( .A(in_dptr[4]), .B(n52), .Y(n65) );
  NAND2X1 U131 ( .A(n56), .B(n57), .Y(n51) );
  AOI22X1 U132 ( .A0(N49), .A1(n58), .B0(out_dptr[15]), .B1(n59), .Y(n56) );
  NAND2X1 U133 ( .A(n52), .B(in_dptr[7]), .Y(n57) );
  NAND2X1 U134 ( .A(n60), .B(n61), .Y(n50) );
  AOI22X1 U135 ( .A0(N48), .A1(n58), .B0(out_dptr[14]), .B1(n59), .Y(n60) );
  NAND2X1 U136 ( .A(in_dptr[6]), .B(n52), .Y(n61) );
  NAND2X1 U137 ( .A(n62), .B(n63), .Y(n490) );
  AOI22X1 U138 ( .A0(N47), .A1(n58), .B0(out_dptr[13]), .B1(n59), .Y(n62) );
  NAND2X1 U139 ( .A(in_dptr[5]), .B(n52), .Y(n63) );
  NAND2X1 U140 ( .A(out_dptr[0]), .B(n85), .Y(n104) );
  NAND2X1 U141 ( .A(out_dptr[1]), .B(n85), .Y(n106) );
  NAND2X1 U142 ( .A(out_dptr[2]), .B(n85), .Y(n108) );
  NAND2X1 U143 ( .A(out_dptr[5]), .B(n85), .Y(n114) );
  NAND2X1 U144 ( .A(out_dptr[3]), .B(n85), .Y(n110) );
  NAND2X1 U145 ( .A(out_dptr[4]), .B(n85), .Y(n112) );
  NAND2X1 U146 ( .A(out_dptr[6]), .B(n85), .Y(n116) );
  NAND2X1 U147 ( .A(out_dptr[7]), .B(n85), .Y(n84) );
  CLKINVX1 U148 ( .A(rst_p), .Y(n350) );
  NOR2X8 U149 ( .A(n102), .B(n103), .Y(n26) );
  NOR2BX1 U150 ( .AN(addr_dptr[1]), .B(addr_dptr[2]), .Y(n340) );
  OR4X1 U151 ( .A(addr_dptr[4]), .B(addr_dptr[3]), .C(addr_dptr[6]), .D(
        addr_dptr[5]), .Y(n33) );
  dptr_DW01_inc_16_0 add_33 ( .A(out_dptr), .SUM({N49, N48, N47, N46, N45, N44, 
        N43, N42, N41, N40, N39, N38, N37, N36, N35, N34}) );
  DFFRX4 out_dptr_reg_13_ ( .D(n490), .CK(clk), .RN(n350), .Q(out_dptr[13]) );
  DFFRX4 out_dptr_reg_12_ ( .D(n480), .CK(clk), .RN(n350), .Q(out_dptr[12]) );
  DFFRX4 out_dptr_reg_11_ ( .D(n470), .CK(clk), .RN(n350), .Q(out_dptr[11]) );
  DFFRX4 out_dptr_reg_7_ ( .D(n430), .CK(clk), .RN(n350), .Q(out_dptr[7]) );
  DFFRX4 out_dptr_reg_6_ ( .D(n420), .CK(clk), .RN(n350), .Q(out_dptr[6]) );
  DFFRX4 out_dptr_reg_5_ ( .D(n410), .CK(clk), .RN(n350), .Q(out_dptr[5]) );
  DFFRX4 out_dptr_reg_4_ ( .D(n400), .CK(clk), .RN(n350), .Q(out_dptr[4]) );
  DFFRX4 out_dptr_reg_3_ ( .D(n390), .CK(clk), .RN(n350), .Q(out_dptr[3]) );
  DFFRX4 out_dptr_reg_2_ ( .D(n380), .CK(clk), .RN(n350), .Q(out_dptr[2]) );
  DFFRX4 out_dptr_reg_1_ ( .D(n370), .CK(clk), .RN(n350), .Q(out_dptr[1]) );
  DFFRX4 out_dptr_reg_0_ ( .D(n360), .CK(clk), .RN(n350), .Q(out_dptr[0]) );
endmodule


module dptr_DW01_inc_16_0 ( A, SUM );
  input [15:0] A;
  output [15:0] SUM;
  wire   carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, carry_9_,
         carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14;

  XNOR2X1 U5 ( .A(n1), .B(A[15]), .Y(SUM[15]) );
  CLKINVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
  CLKINVX1 U7 ( .A(n14), .Y(carry_2_) );
  CLKINVX1 U8 ( .A(n8), .Y(carry_8_) );
  CLKINVX1 U9 ( .A(n13), .Y(carry_3_) );
  CLKINVX1 U10 ( .A(n10), .Y(carry_6_) );
  CLKINVX1 U11 ( .A(n7), .Y(carry_9_) );
  CLKINVX1 U12 ( .A(n5), .Y(carry_11_) );
  CLKINVX1 U13 ( .A(n2), .Y(carry_14_) );
  CLKINVX1 U14 ( .A(n12), .Y(carry_4_) );
  CLKINVX1 U15 ( .A(n11), .Y(carry_5_) );
  CLKINVX1 U16 ( .A(n9), .Y(carry_7_) );
  CLKINVX1 U17 ( .A(n3), .Y(carry_13_) );
  CLKINVX1 U18 ( .A(n6), .Y(carry_10_) );
  CLKINVX1 U19 ( .A(n4), .Y(carry_12_) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n14) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n13) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n12) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n11) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n10) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n9) );
  AHHCONX2 U1_1_7 ( .A(A[7]), .CI(carry_7_), .S(SUM[7]), .CON(n8) );
  AHHCONX2 U1_1_8 ( .A(A[8]), .CI(carry_8_), .S(SUM[8]), .CON(n7) );
  AHHCONX2 U1_1_9 ( .A(A[9]), .CI(carry_9_), .S(SUM[9]), .CON(n6) );
  AHHCONX2 U1_1_10 ( .A(A[10]), .CI(carry_10_), .S(SUM[10]), .CON(n5) );
  AHHCONX2 U1_1_11 ( .A(A[11]), .CI(carry_11_), .S(SUM[11]), .CON(n4) );
  AHHCONX2 U1_1_12 ( .A(A[12]), .CI(carry_12_), .S(SUM[12]), .CON(n3) );
  AHHCONX2 U1_1_13 ( .A(A[13]), .CI(carry_13_), .S(SUM[13]), .CON(n2) );
  AHHCONX2 U1_1_14 ( .A(A[14]), .CI(carry_14_), .S(SUM[14]), .CON(n1) );
endmodule


module sp ( clk, rst_p, wr, inc_sp, dec_sp, addr_sp, in_sp, out_sp );
  input [7:0] addr_sp;
  input [7:0] in_sp;
  output [7:0] out_sp;
  input clk, rst_p, wr, inc_sp, dec_sp;
  wire   N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36,
         N37, N38, n3, n7, n8, n9, n10, n11, n12, n13, n21, n22, n230, n240,
         n250, n260, n270, n280, n290, n300, n310, n320, n330, n340, n350,
         n360, n370, n380, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84;

  AND2X2 U31 ( .A(N23), .B(n47), .Y(n300) );
  INVX1 U32 ( .A(n57), .Y(n9) );
  INVX1 U33 ( .A(n53), .Y(n8) );
  INVX1 U34 ( .A(n49), .Y(n7) );
  CLKINVX1 U35 ( .A(n77), .Y(n10) );
  NAND2X1 U36 ( .A(in_sp[1]), .B(n46), .Y(n72) );
  CLKINVX1 U37 ( .A(n66), .Y(n48) );
  CLKINVX1 U38 ( .A(n67), .Y(n47) );
  NAND3X1 U39 ( .A(n66), .B(n62), .C(n67), .Y(n41) );
  CLKINVX1 U40 ( .A(n62), .Y(n46) );
  CLKINVX1 U41 ( .A(addr_sp[0]), .Y(n84) );
  NOR2X1 U42 ( .A(n62), .B(n63), .Y(n68) );
  CLKINVX1 U43 ( .A(in_sp[0]), .Y(n63) );
  NAND2X1 U44 ( .A(in_sp[2]), .B(n46), .Y(n76) );
  NAND2X1 U45 ( .A(in_sp[3]), .B(n46), .Y(n80) );
  NAND2X1 U46 ( .A(in_sp[5]), .B(n46), .Y(n56) );
  NAND2X1 U47 ( .A(in_sp[6]), .B(n46), .Y(n52) );
  NAND2X1 U48 ( .A(in_sp[7]), .B(n46), .Y(n45) );
  NAND4BX1 U49 ( .AN(n310), .B(n82), .C(n83), .D(wr), .Y(n62) );
  OR2X1 U50 ( .A(addr_sp[3]), .B(addr_sp[2]), .Y(n310) );
  NAND3X1 U51 ( .A(dec_sp), .B(n81), .C(n62), .Y(n66) );
  CLKINVX1 U52 ( .A(inc_sp), .Y(n81) );
  NAND2X1 U53 ( .A(inc_sp), .B(n62), .Y(n67) );
  DFFRX1 out_sp_reg_7_ ( .D(n290), .CK(clk), .RN(n21), .Q(out_sp[7]), .QN(n330) );
  NAND2X1 U54 ( .A(in_sp[4]), .B(n46), .Y(n60) );
  AOI22X1 U55 ( .A0(n61), .A1(n62), .B0(n61), .B1(n63), .Y(n22) );
  INVX1 U56 ( .A(n64), .Y(n61) );
  OAI21X1 U57 ( .A0(n41), .A1(n40), .B0(n65), .Y(n64) );
  NOR2X1 U58 ( .A(n320), .B(n300), .Y(n65) );
  OAI21X1 U59 ( .A0(n41), .A1(n39), .B0(n12), .Y(n230) );
  CLKINVX1 U60 ( .A(n69), .Y(n12) );
  NAND3X1 U61 ( .A(n70), .B(n71), .C(n72), .Y(n69) );
  NAND2X1 U62 ( .A(N24), .B(n47), .Y(n71) );
  OAI21X1 U63 ( .A0(n41), .A1(n380), .B0(n11), .Y(n240) );
  CLKINVX1 U64 ( .A(n73), .Y(n11) );
  NAND3X1 U65 ( .A(n74), .B(n75), .C(n76), .Y(n73) );
  NAND2X1 U66 ( .A(N25), .B(n47), .Y(n75) );
  OAI21X1 U67 ( .A0(n41), .A1(n370), .B0(n10), .Y(n250) );
  NAND3X1 U68 ( .A(n78), .B(n79), .C(n80), .Y(n77) );
  NAND2X1 U69 ( .A(N26), .B(n47), .Y(n79) );
  OAI21X1 U70 ( .A0(n41), .A1(n360), .B0(n9), .Y(n260) );
  NAND3X1 U71 ( .A(n58), .B(n59), .C(n60), .Y(n57) );
  NAND2X1 U72 ( .A(N27), .B(n47), .Y(n59) );
  OAI21X1 U73 ( .A0(n41), .A1(n330), .B0(n3), .Y(n290) );
  CLKINVX1 U74 ( .A(n42), .Y(n3) );
  NAND3X1 U75 ( .A(n43), .B(n44), .C(n45), .Y(n42) );
  NAND2X1 U76 ( .A(N30), .B(n47), .Y(n44) );
  OAI21X1 U77 ( .A0(n41), .A1(n340), .B0(n7), .Y(n280) );
  NAND3X1 U78 ( .A(n50), .B(n51), .C(n52), .Y(n49) );
  NAND2X1 U79 ( .A(N29), .B(n47), .Y(n51) );
  OAI21X1 U80 ( .A0(n41), .A1(n350), .B0(n8), .Y(n270) );
  NAND3X1 U81 ( .A(n54), .B(n55), .C(n56), .Y(n53) );
  NAND2X1 U82 ( .A(N28), .B(n47), .Y(n55) );
  AND2X2 U83 ( .A(N31), .B(n48), .Y(n320) );
  NAND2X1 U84 ( .A(N32), .B(n48), .Y(n70) );
  NAND2X1 U85 ( .A(N33), .B(n48), .Y(n74) );
  NAND2X1 U86 ( .A(N34), .B(n48), .Y(n78) );
  NAND2X1 U87 ( .A(N35), .B(n48), .Y(n58) );
  NAND2X1 U88 ( .A(N36), .B(n48), .Y(n54) );
  NAND2X1 U89 ( .A(N37), .B(n48), .Y(n50) );
  NAND2X1 U90 ( .A(N38), .B(n48), .Y(n43) );
  CLKINVX1 U91 ( .A(rst_p), .Y(n21) );
  DFFSX2 out_sp_reg_1_ ( .D(n230), .CK(clk), .SN(n21), .Q(out_sp[1]), .QN(n39)
         );
  NOR3BX1 U92 ( .AN(addr_sp[7]), .B(n84), .C(addr_sp[1]), .Y(n83) );
  NOR3X1 U93 ( .A(addr_sp[4]), .B(addr_sp[6]), .C(addr_sp[5]), .Y(n82) );
  NOR3X6 U94 ( .A(n68), .B(n300), .C(n320), .Y(n13) );
  sp_DW01_dec_8_0 sub_29 ( .A(out_sp), .SUM({N38, N37, N36, N35, N34, N33, N32, 
        N31}) );
  sp_DW01_inc_8_0 add_28 ( .A(out_sp), .SUM({N30, N29, N28, N27, N26, N25, N24, 
        N23}) );
  DFFRX4 out_sp_reg_6_ ( .D(n280), .CK(clk), .RN(n21), .Q(out_sp[6]), .QN(n340) );
  DFFRX4 out_sp_reg_5_ ( .D(n270), .CK(clk), .RN(n21), .Q(out_sp[5]), .QN(n350) );
  DFFRX4 out_sp_reg_4_ ( .D(n260), .CK(clk), .RN(n21), .Q(out_sp[4]), .QN(n360) );
  DFFRX4 out_sp_reg_3_ ( .D(n250), .CK(clk), .RN(n21), .Q(out_sp[3]), .QN(n370) );
  DFFSX4 out_sp_reg_2_ ( .D(n240), .CK(clk), .SN(n21), .Q(out_sp[2]), .QN(n380) );
  DFFSX4 out_sp_reg_0_ ( .D(n22), .CK(clk), .SN(n21), .Q(out_sp[0]), .QN(n40)
         );
endmodule


module sp_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n5,
         n6;

  CLKINVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  XNOR2X1 U6 ( .A(n1), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1 U7 ( .A(n5), .Y(carry_3_) );
  CLKINVX1 U8 ( .A(n6), .Y(carry_2_) );
  CLKINVX1 U9 ( .A(n4), .Y(carry_4_) );
  CLKINVX1 U10 ( .A(n3), .Y(carry_5_) );
  CLKINVX1 U11 ( .A(n2), .Y(carry_6_) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n6) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n5) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n4) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n3) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n2) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n1) );
endmodule


module sp_DW01_dec_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  OR2X1 U1_B_1 ( .A(A[1]), .B(A[0]), .Y(carry_2_) );
  XNOR2X1 U1_A_1 ( .A(A[1]), .B(A[0]), .Y(SUM[1]) );
  XNOR2X1 U1_A_2 ( .A(A[2]), .B(carry_2_), .Y(SUM[2]) );
  XNOR2X1 U1_A_3 ( .A(A[3]), .B(carry_3_), .Y(SUM[3]) );
  XNOR2X1 U1_A_4 ( .A(A[4]), .B(carry_4_), .Y(SUM[4]) );
  XNOR2X1 U1_A_5 ( .A(A[5]), .B(carry_5_), .Y(SUM[5]) );
  XNOR2X1 U1_A_6 ( .A(A[6]), .B(carry_6_), .Y(SUM[6]) );
  XNOR2X1 U1_A_7 ( .A(A[7]), .B(carry_7_), .Y(SUM[7]) );
  OR2X1 U1_B_6 ( .A(A[6]), .B(carry_6_), .Y(carry_7_) );
  OR2X1 U1_B_3 ( .A(A[3]), .B(carry_3_), .Y(carry_4_) );
  OR2X1 U1_B_4 ( .A(A[4]), .B(carry_4_), .Y(carry_5_) );
  OR2X1 U1_B_5 ( .A(A[5]), .B(carry_5_), .Y(carry_6_) );
  OR2X1 U1_B_2 ( .A(A[2]), .B(carry_2_), .Y(carry_3_) );
  CLKINVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module gpio0 ( clk, rst_p, wr, rmw, combus, prt0_addr, p0_in, p0, p0_out );
  input [7:0] combus;
  input [7:0] prt0_addr;
  input [7:0] p0_in;
  output [7:0] p0;
  output [7:0] p0_out;
  input clk, rst_p, wr, rmw;
  wire   n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43;

  AND4X2 U24 ( .A(n41), .B(n42), .C(n43), .D(wr), .Y(n33) );
  NOR2X1 U25 ( .A(prt0_addr[3]), .B(prt0_addr[2]), .Y(n41) );
  MXI2X1 U26 ( .S0(n33), .B(n34), .A(n20), .Y(n8) );
  CLKINVX1 U27 ( .A(combus[0]), .Y(n34) );
  MXI2X1 U28 ( .S0(n33), .B(n32), .A(n21), .Y(n9) );
  CLKINVX1 U29 ( .A(combus[1]), .Y(n32) );
  MXI2X1 U30 ( .S0(n33), .B(n40), .A(n22), .Y(n10) );
  CLKINVX1 U31 ( .A(combus[2]), .Y(n40) );
  MXI2X1 U32 ( .S0(n33), .B(n39), .A(n17), .Y(n11) );
  CLKINVX1 U33 ( .A(combus[3]), .Y(n39) );
  MXI2X1 U34 ( .S0(n33), .B(n38), .A(n19), .Y(n12) );
  CLKINVX1 U35 ( .A(combus[4]), .Y(n38) );
  MXI2X1 U36 ( .S0(n33), .B(n35), .A(n16), .Y(n15) );
  CLKINVX1 U37 ( .A(combus[7]), .Y(n35) );
  MXI2X1 U38 ( .S0(n33), .B(n36), .A(n23), .Y(n14) );
  CLKINVX1 U39 ( .A(combus[6]), .Y(n36) );
  MXI2X1 U40 ( .S0(n33), .B(n37), .A(n18), .Y(n13) );
  CLKINVX1 U41 ( .A(combus[5]), .Y(n37) );
  MXI2X1 U42 ( .S0(rmw), .B(n22), .A(n29), .Y(p0[2]) );
  CLKINVX1 U43 ( .A(p0_in[2]), .Y(n29) );
  MXI2X1 U44 ( .S0(rmw), .B(n18), .A(n26), .Y(p0[5]) );
  CLKINVX1 U45 ( .A(p0_in[5]), .Y(n26) );
  MXI2X1 U46 ( .S0(rmw), .B(n23), .A(n25), .Y(p0[6]) );
  CLKINVX1 U47 ( .A(p0_in[6]), .Y(n25) );
  MXI2X1 U48 ( .S0(rmw), .B(n20), .A(n31), .Y(p0[0]) );
  CLKINVX1 U49 ( .A(p0_in[0]), .Y(n31) );
  MXI2X1 U50 ( .S0(rmw), .B(n16), .A(n24), .Y(p0[7]) );
  CLKINVX1 U51 ( .A(p0_in[7]), .Y(n24) );
  MXI2X1 U52 ( .S0(rmw), .B(n19), .A(n27), .Y(p0[4]) );
  CLKINVX1 U53 ( .A(p0_in[4]), .Y(n27) );
  MXI2X1 U54 ( .S0(rmw), .B(n21), .A(n30), .Y(p0[1]) );
  CLKINVX1 U55 ( .A(p0_in[1]), .Y(n30) );
  MXI2X1 U56 ( .S0(rmw), .B(n17), .A(n28), .Y(p0[3]) );
  CLKINVX1 U57 ( .A(p0_in[3]), .Y(n28) );
  CLKINVX1 U58 ( .A(rst_p), .Y(n7) );
  DFFSX2 p0_out_reg_0_ ( .D(n8), .CK(clk), .SN(n7), .Q(p0_out[0]), .QN(n20) );
  DFFSX2 p0_out_reg_1_ ( .D(n9), .CK(clk), .SN(n7), .Q(p0_out[1]), .QN(n21) );
  DFFSX2 p0_out_reg_7_ ( .D(n15), .CK(clk), .SN(n7), .Q(p0_out[7]), .QN(n16)
         );
  DFFSX2 p0_out_reg_3_ ( .D(n11), .CK(clk), .SN(n7), .Q(p0_out[3]), .QN(n17)
         );
  DFFSX2 p0_out_reg_4_ ( .D(n12), .CK(clk), .SN(n7), .Q(p0_out[4]), .QN(n19)
         );
  DFFSX2 p0_out_reg_2_ ( .D(n10), .CK(clk), .SN(n7), .Q(p0_out[2]), .QN(n22)
         );
  DFFSX2 p0_out_reg_5_ ( .D(n13), .CK(clk), .SN(n7), .Q(p0_out[5]), .QN(n18)
         );
  DFFSX2 p0_out_reg_6_ ( .D(n14), .CK(clk), .SN(n7), .Q(p0_out[6]), .QN(n23)
         );
  NOR3BX1 U59 ( .AN(prt0_addr[7]), .B(prt0_addr[1]), .C(prt0_addr[0]), .Y(n43)
         );
  NOR3X1 U60 ( .A(prt0_addr[4]), .B(prt0_addr[6]), .C(prt0_addr[5]), .Y(n42)
         );
endmodule


module page_addr ( pc, code, xrom, page_addr_a );
  input [4:0] pc;
  input [2:0] code;
  input [7:0] xrom;
  output [15:0] page_addr_a;
  wire   n1, n3, n5, n7, n9, n11, n13, n15, n17, n19, n21, n23, n25, n27, n29,
         n31;

  INVX1 U1 ( .A(n15), .Y(page_addr_a[7]) );
  INVX1 U2 ( .A(n3), .Y(page_addr_a[1]) );
  INVX1 U3 ( .A(n7), .Y(page_addr_a[3]) );
  INVX1 U4 ( .A(n9), .Y(page_addr_a[4]) );
  INVX1 U5 ( .A(n5), .Y(page_addr_a[2]) );
  INVX1 U6 ( .A(n13), .Y(page_addr_a[6]) );
  CLKINVX1 U7 ( .A(n11), .Y(page_addr_a[5]) );
  CLKINVX1 U8 ( .A(xrom[5]), .Y(n11) );
  CLKINVX1 U9 ( .A(n1), .Y(page_addr_a[0]) );
  CLKINVX1 U10 ( .A(xrom[0]), .Y(n1) );
  CLKINVX1 U11 ( .A(xrom[2]), .Y(n5) );
  CLKINVX1 U12 ( .A(xrom[4]), .Y(n9) );
  CLKINVX1 U13 ( .A(xrom[1]), .Y(n3) );
  CLKINVX1 U14 ( .A(xrom[3]), .Y(n7) );
  CLKINVX1 U15 ( .A(xrom[6]), .Y(n13) );
  CLKINVX1 U16 ( .A(xrom[7]), .Y(n15) );
  CLKINVX1 U17 ( .A(n17), .Y(page_addr_a[8]) );
  CLKINVX1 U18 ( .A(code[0]), .Y(n17) );
  CLKINVX1 U19 ( .A(n31), .Y(page_addr_a[15]) );
  CLKINVX1 U20 ( .A(pc[4]), .Y(n31) );
  CLKINVX1 U21 ( .A(n29), .Y(page_addr_a[14]) );
  CLKINVX1 U22 ( .A(pc[3]), .Y(n29) );
  CLKINVX1 U23 ( .A(n27), .Y(page_addr_a[13]) );
  CLKINVX1 U24 ( .A(pc[2]), .Y(n27) );
  CLKINVX1 U25 ( .A(n25), .Y(page_addr_a[12]) );
  CLKINVX1 U26 ( .A(pc[1]), .Y(n25) );
  CLKINVX1 U27 ( .A(n23), .Y(page_addr_a[11]) );
  CLKINVX1 U28 ( .A(pc[0]), .Y(n23) );
  CLKINVX1 U29 ( .A(n21), .Y(page_addr_a[10]) );
  CLKINVX1 U30 ( .A(code[2]), .Y(n21) );
  CLKINVX1 U31 ( .A(n19), .Y(page_addr_a[9]) );
  CLKINVX1 U32 ( .A(code[1]), .Y(n19) );
endmodule


module pc ( clk, rst_p, ld_pc, ld_pcl, ld_pch, inc_pc, in_pc, out_pc_r );
  input [15:0] in_pc;
  output [15:0] out_pc_r;
  input clk, rst_p, ld_pc, ld_pcl, ld_pch, inc_pc;
  wire   N15, N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28,
         N29, N30, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n1500, n1600, n170, n180, n190, n200, n210, n220, n230, n250, n260,
         n270, n280, n290, n300, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107,
         n108, n109, n110, n111, n112, n113, n114, n115, n116, n117, n118,
         n119, n120, n121, n122, n123, n124, n125, n126, n127, n128, n129,
         n130, n131, n132, n133, n134, n135, n136, n137, n138, n139, n140,
         n141, n142, n143, n144, n145, n146, n147, n148, n149, n15000, n151,
         n152, n153, n154, n155, n156, n157, n158, n159, n16000, n161, n162;

  INVX3 U46 ( .A(ld_pc), .Y(n114) );
  NAND2X2 U47 ( .A(n58), .B(n112), .Y(n260) );
  INVX3 U48 ( .A(n9), .Y(n112) );
  NAND2X1 U49 ( .A(n113), .B(n114), .Y(n9) );
  AND3X2 U50 ( .A(n157), .B(n113), .C(inc_pc), .Y(n45) );
  DFFRHQX8 out_pc_r_reg_8_ ( .D(n37), .CK(clk), .RN(n280), .Q(out_pc_r[8]) );
  DFFRHQX8 out_pc_r_reg_9_ ( .D(n38), .CK(clk), .RN(n280), .Q(out_pc_r[9]) );
  DFFRHQX8 out_pc_r_reg_11_ ( .D(n40), .CK(clk), .RN(n280), .Q(out_pc_r[11])
         );
  DFFRHQX8 out_pc_r_reg_13_ ( .D(n42), .CK(clk), .RN(n280), .Q(out_pc_r[13])
         );
  DFFRHQX8 out_pc_r_reg_10_ ( .D(n39), .CK(clk), .RN(n280), .Q(out_pc_r[10])
         );
  DFFRHQX8 out_pc_r_reg_12_ ( .D(n41), .CK(clk), .RN(n280), .Q(out_pc_r[12])
         );
  DFFRHQX8 out_pc_r_reg_14_ ( .D(n43), .CK(clk), .RN(n280), .Q(out_pc_r[14])
         );
  DFFRHQX8 out_pc_r_reg_15_ ( .D(n44), .CK(clk), .RN(n280), .Q(out_pc_r[15])
         );
  NAND2X2 U51 ( .A(n114), .B(n124), .Y(n69) );
  CLKBUFX3 U52 ( .A(n56), .Y(n161) );
  CLKBUFX3 U53 ( .A(n67), .Y(n159) );
  INVX3 U54 ( .A(n230), .Y(n67) );
  NAND2X1 U55 ( .A(n45), .B(n114), .Y(n58) );
  NAND2X1 U56 ( .A(n113), .B(n114), .Y(n56) );
  INVX1 U57 ( .A(n128), .Y(n127) );
  INVX1 U58 ( .A(n122), .Y(n121) );
  INVX1 U59 ( .A(n68), .Y(n66) );
  INVX1 U60 ( .A(n130), .Y(n129) );
  INVX1 U61 ( .A(n126), .Y(n125) );
  INVX1 U62 ( .A(n120), .Y(n119) );
  INVX1 U63 ( .A(n132), .Y(n131) );
  CLKBUFX2 U64 ( .A(n67), .Y(n158) );
  CLKINVX1 U65 ( .A(n161), .Y(n270) );
  CLKBUFX2 U66 ( .A(n67), .Y(n16000) );
  CLKBUFX2 U67 ( .A(n56), .Y(n162) );
  CLKINVX1 U68 ( .A(n260), .Y(n104) );
  CLKINVX1 U69 ( .A(n260), .Y(n99) );
  CLKINVX1 U70 ( .A(n260), .Y(n94) );
  CLKINVX1 U71 ( .A(n260), .Y(n89) );
  CLKINVX1 U72 ( .A(n260), .Y(n84) );
  CLKINVX1 U73 ( .A(n260), .Y(n79) );
  CLKINVX1 U74 ( .A(n260), .Y(n74) );
  CLKINVX1 U75 ( .A(n260), .Y(n111) );
  NAND2X6 U76 ( .A(n45), .B(n114), .Y(n230) );
  CLKINVX1 U77 ( .A(n220), .Y(n2) );
  NAND2X1 U78 ( .A(n58), .B(n123), .Y(n220) );
  CLKINVX1 U79 ( .A(n4), .Y(n123) );
  NAND2X1 U80 ( .A(n114), .B(n124), .Y(n4) );
  CLKINVX1 U81 ( .A(ld_pcl), .Y(n113) );
  NAND2X1 U82 ( .A(ld_pch), .B(n113), .Y(n124) );
  CLKINVX1 U83 ( .A(ld_pch), .Y(n157) );
  NOR2X1 U84 ( .A(n16000), .B(n155), .Y(n153) );
  NOR2X1 U85 ( .A(n270), .B(n156), .Y(n155) );
  CLKINVX1 U86 ( .A(in_pc[6]), .Y(n156) );
  NOR2X1 U87 ( .A(n159), .B(n151), .Y(n149) );
  NOR2X1 U88 ( .A(n270), .B(n152), .Y(n151) );
  CLKINVX1 U89 ( .A(in_pc[5]), .Y(n152) );
  NOR2X1 U90 ( .A(n16000), .B(n147), .Y(n145) );
  NOR2X1 U91 ( .A(n270), .B(n148), .Y(n147) );
  CLKINVX1 U92 ( .A(in_pc[4]), .Y(n148) );
  NOR2X1 U93 ( .A(n16000), .B(n143), .Y(n141) );
  NOR2X1 U94 ( .A(n270), .B(n144), .Y(n143) );
  CLKINVX1 U95 ( .A(in_pc[3]), .Y(n144) );
  NOR2X1 U96 ( .A(n16000), .B(n139), .Y(n137) );
  NOR2X1 U97 ( .A(n270), .B(n140), .Y(n139) );
  CLKINVX1 U98 ( .A(in_pc[2]), .Y(n140) );
  NOR2X1 U99 ( .A(n16000), .B(n135), .Y(n133) );
  NOR2X1 U100 ( .A(n270), .B(n136), .Y(n135) );
  CLKINVX1 U101 ( .A(in_pc[1]), .Y(n136) );
  NOR2X1 U102 ( .A(n16000), .B(n117), .Y(n115) );
  NOR2X1 U103 ( .A(n270), .B(n118), .Y(n117) );
  CLKINVX1 U104 ( .A(in_pc[0]), .Y(n118) );
  NAND2X1 U105 ( .A(in_pc[7]), .B(n161), .Y(n54) );
  OAI22X1 U106 ( .A0(N28), .A1(n127), .B0(n127), .B1(n159), .Y(n61) );
  NAND2X1 U107 ( .A(in_pc[13]), .B(n69), .Y(n128) );
  OAI22X1 U108 ( .A0(N26), .A1(n121), .B0(n121), .B1(n159), .Y(n63) );
  NAND2X1 U109 ( .A(in_pc[11]), .B(n69), .Y(n122) );
  OAI22X1 U110 ( .A0(N24), .A1(n105), .B0(n105), .B1(n159), .Y(n65) );
  CLKINVX1 U111 ( .A(n106), .Y(n105) );
  NAND2X1 U112 ( .A(in_pc[9]), .B(n69), .Y(n106) );
  OAI22X1 U113 ( .A0(N23), .A1(n66), .B0(n66), .B1(n159), .Y(n57) );
  NAND2X1 U114 ( .A(in_pc[8]), .B(n69), .Y(n68) );
  OAI22X1 U115 ( .A0(N29), .A1(n129), .B0(n129), .B1(n158), .Y(n60) );
  NAND2X1 U116 ( .A(in_pc[14]), .B(n69), .Y(n130) );
  OAI22X1 U117 ( .A0(N27), .A1(n125), .B0(n125), .B1(n158), .Y(n62) );
  NAND2X1 U118 ( .A(in_pc[12]), .B(n69), .Y(n126) );
  OAI22X1 U119 ( .A0(N25), .A1(n119), .B0(n119), .B1(n158), .Y(n64) );
  NAND2X1 U120 ( .A(in_pc[10]), .B(n69), .Y(n120) );
  OAI21X1 U121 ( .A0(n100), .A1(n101), .B0(n102), .Y(n300) );
  NOR2X1 U122 ( .A(N16), .B(n161), .Y(n101) );
  AOI21X1 U123 ( .A0(in_pc[1]), .A1(n161), .B0(n159), .Y(n100) );
  NAND2X1 U124 ( .A(n103), .B(n104), .Y(n102) );
  OAI21X1 U125 ( .A0(n95), .A1(n96), .B0(n97), .Y(n31) );
  NOR2X1 U126 ( .A(N17), .B(n162), .Y(n96) );
  AOI21X1 U127 ( .A0(in_pc[2]), .A1(n161), .B0(n158), .Y(n95) );
  NAND2X1 U128 ( .A(n98), .B(n99), .Y(n97) );
  OAI21X1 U129 ( .A0(n90), .A1(n91), .B0(n92), .Y(n32) );
  NOR2X1 U130 ( .A(N18), .B(n161), .Y(n91) );
  AOI21X1 U131 ( .A0(in_pc[3]), .A1(n161), .B0(n159), .Y(n90) );
  NAND2X1 U132 ( .A(n93), .B(n94), .Y(n92) );
  OAI21X1 U133 ( .A0(n85), .A1(n86), .B0(n87), .Y(n33) );
  NOR2X1 U134 ( .A(N19), .B(n161), .Y(n86) );
  AOI21X1 U135 ( .A0(in_pc[4]), .A1(n161), .B0(n158), .Y(n85) );
  NAND2X1 U136 ( .A(n88), .B(n89), .Y(n87) );
  OAI21X1 U137 ( .A0(n80), .A1(n81), .B0(n82), .Y(n34) );
  NOR2X1 U138 ( .A(N20), .B(n162), .Y(n81) );
  AOI21X1 U139 ( .A0(in_pc[5]), .A1(n161), .B0(n159), .Y(n80) );
  NAND2X1 U140 ( .A(n83), .B(n84), .Y(n82) );
  OAI21X1 U141 ( .A0(n75), .A1(n76), .B0(n77), .Y(n35) );
  NOR2X1 U142 ( .A(N21), .B(n162), .Y(n76) );
  AOI21X1 U143 ( .A0(in_pc[6]), .A1(n161), .B0(n158), .Y(n75) );
  NAND2X1 U144 ( .A(n78), .B(n79), .Y(n77) );
  OAI21X1 U145 ( .A0(n70), .A1(n71), .B0(n72), .Y(n36) );
  NOR2X1 U146 ( .A(N22), .B(n162), .Y(n71) );
  AOI21X1 U147 ( .A0(in_pc[7]), .A1(n161), .B0(n159), .Y(n70) );
  NAND2X1 U148 ( .A(n73), .B(n74), .Y(n72) );
  OAI21X1 U149 ( .A0(n107), .A1(n108), .B0(n109), .Y(n290) );
  NOR2X1 U150 ( .A(N15), .B(n162), .Y(n108) );
  AOI21X1 U151 ( .A0(in_pc[0]), .A1(n161), .B0(n158), .Y(n107) );
  NAND2X1 U152 ( .A(n110), .B(n111), .Y(n109) );
  NOR2X1 U153 ( .A(N16), .B(n161), .Y(n134) );
  NOR2X1 U154 ( .A(N21), .B(n162), .Y(n154) );
  NOR2X1 U155 ( .A(N20), .B(n162), .Y(n15000) );
  NOR2X1 U156 ( .A(N19), .B(n162), .Y(n146) );
  NOR2X1 U157 ( .A(N18), .B(n162), .Y(n142) );
  NOR2X1 U158 ( .A(N17), .B(n162), .Y(n138) );
  NOR2X1 U159 ( .A(N22), .B(n162), .Y(n55) );
  NOR2X1 U160 ( .A(N15), .B(n161), .Y(n116) );
  OAI22X1 U161 ( .A0(N30), .A1(n131), .B0(n131), .B1(n158), .Y(n59) );
  NAND2X1 U162 ( .A(in_pc[15]), .B(n69), .Y(n132) );
  OAI2BB1X1 U163 ( .A0N(out_pc_r[11]), .A1N(n2), .B0(n63), .Y(n40) );
  OAI2BB1X1 U164 ( .A0N(out_pc_r[13]), .A1N(n2), .B0(n61), .Y(n42) );
  OAI2BB1X1 U165 ( .A0N(out_pc_r[12]), .A1N(n2), .B0(n62), .Y(n41) );
  OAI2BB1X1 U166 ( .A0N(out_pc_r[14]), .A1N(n2), .B0(n60), .Y(n43) );
  OAI2BB1X1 U167 ( .A0N(out_pc_r[8]), .A1N(n2), .B0(n57), .Y(n37) );
  OAI2BB1X1 U168 ( .A0N(out_pc_r[9]), .A1N(n2), .B0(n65), .Y(n38) );
  OAI2BB1X1 U169 ( .A0N(out_pc_r[10]), .A1N(n2), .B0(n64), .Y(n39) );
  OAI2BB1X1 U170 ( .A0N(out_pc_r[15]), .A1N(n2), .B0(n59), .Y(n44) );
  CLKINVX1 U171 ( .A(n53), .Y(n110) );
  CLKINVX1 U172 ( .A(n52), .Y(n103) );
  CLKINVX1 U173 ( .A(n51), .Y(n98) );
  CLKINVX1 U174 ( .A(n50), .Y(n93) );
  CLKINVX1 U175 ( .A(n49), .Y(n88) );
  CLKINVX1 U176 ( .A(n48), .Y(n83) );
  CLKINVX1 U177 ( .A(n47), .Y(n78) );
  CLKINVX1 U178 ( .A(n46), .Y(n73) );
  CLKINVX1 U179 ( .A(rst_p), .Y(n280) );
  DFFRX1 out_pc_r_reg_2_ ( .D(n31), .CK(clk), .RN(n280), .Q(out_pc_r[2]), .QN(
        n51) );
  DFFRX1 out_pc_r_reg_3_ ( .D(n32), .CK(clk), .RN(n280), .Q(out_pc_r[3]), .QN(
        n50) );
  DFFRX1 out_pc_r_reg_1_ ( .D(n300), .CK(clk), .RN(n280), .Q(out_pc_r[1]), 
        .QN(n52) );
  DFFRX1 out_pc_r_reg_4_ ( .D(n33), .CK(clk), .RN(n280), .Q(out_pc_r[4]), .QN(
        n49) );
  DFFRX1 out_pc_r_reg_5_ ( .D(n34), .CK(clk), .RN(n280), .Q(out_pc_r[5]), .QN(
        n48) );
  DFFRX1 out_pc_r_reg_6_ ( .D(n35), .CK(clk), .RN(n280), .Q(out_pc_r[6]), .QN(
        n47) );
  DFFRX1 out_pc_r_reg_7_ ( .D(n36), .CK(clk), .RN(n280), .Q(out_pc_r[7]), .QN(
        n46) );
  AOI21X4 U180 ( .A0(n54), .A1(n230), .B0(n55), .Y(n8) );
  INVX8 U181 ( .A(n260), .Y(n7) );
  INVX8 U182 ( .A(n57), .Y(n6) );
  INVX8 U183 ( .A(n58), .Y(n5) );
  INVX8 U184 ( .A(n65), .Y(n3) );
  NOR2X8 U185 ( .A(n115), .B(n116), .Y(n250) );
  INVX8 U186 ( .A(n64), .Y(n210) );
  INVX8 U187 ( .A(n63), .Y(n200) );
  INVX8 U188 ( .A(n62), .Y(n190) );
  INVX8 U189 ( .A(n61), .Y(n180) );
  INVX8 U190 ( .A(n60), .Y(n170) );
  INVX8 U191 ( .A(n59), .Y(n1600) );
  NOR2X8 U192 ( .A(n133), .B(n134), .Y(n1500) );
  NOR2X8 U193 ( .A(n137), .B(n138), .Y(n14) );
  NOR2X8 U194 ( .A(n141), .B(n142), .Y(n13) );
  NOR2X8 U195 ( .A(n145), .B(n146), .Y(n12) );
  NOR2X8 U196 ( .A(n149), .B(n15000), .Y(n11) );
  NOR2X8 U197 ( .A(n153), .B(n154), .Y(n10) );
  pc_DW01_inc_16_0 add_28 ( .A(out_pc_r), .SUM({N30, N29, N28, N27, N26, N25, 
        N24, N23, N22, N21, N20, N19, N18, N17, N16, N15}) );
  DFFRX4 out_pc_r_reg_0_ ( .D(n290), .CK(clk), .RN(n280), .Q(out_pc_r[0]), 
        .QN(n53) );
endmodule


module pc_DW01_inc_16_0 ( A, SUM );
  input [15:0] A;
  output [15:0] SUM;
  wire   carry_14_, carry_13_, carry_12_, carry_11_, carry_10_, carry_9_,
         carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14;

  XNOR2X1 U5 ( .A(n1), .B(A[15]), .Y(SUM[15]) );
  CLKINVX1 U6 ( .A(n8), .Y(carry_8_) );
  CLKINVX1 U7 ( .A(n7), .Y(carry_9_) );
  CLKINVX1 U8 ( .A(n4), .Y(carry_12_) );
  CLKINVX1 U9 ( .A(n3), .Y(carry_13_) );
  CLKINVX1 U10 ( .A(n14), .Y(carry_2_) );
  CLKINVX1 U11 ( .A(n13), .Y(carry_3_) );
  CLKINVX1 U12 ( .A(n12), .Y(carry_4_) );
  CLKINVX1 U13 ( .A(n11), .Y(carry_5_) );
  CLKINVX1 U14 ( .A(n10), .Y(carry_6_) );
  CLKINVX1 U15 ( .A(n9), .Y(carry_7_) );
  CLKINVX1 U16 ( .A(n2), .Y(carry_14_) );
  CLKINVX1 U17 ( .A(n6), .Y(carry_10_) );
  CLKINVX1 U18 ( .A(n5), .Y(carry_11_) );
  CLKINVX1 U19 ( .A(A[0]), .Y(SUM[0]) );
  AHHCONX2 U1_1_1 ( .A(A[1]), .CI(A[0]), .S(SUM[1]), .CON(n14) );
  AHHCONX2 U1_1_2 ( .A(A[2]), .CI(carry_2_), .S(SUM[2]), .CON(n13) );
  AHHCONX2 U1_1_3 ( .A(A[3]), .CI(carry_3_), .S(SUM[3]), .CON(n12) );
  AHHCONX2 U1_1_4 ( .A(A[4]), .CI(carry_4_), .S(SUM[4]), .CON(n11) );
  AHHCONX2 U1_1_5 ( .A(A[5]), .CI(carry_5_), .S(SUM[5]), .CON(n10) );
  AHHCONX2 U1_1_6 ( .A(A[6]), .CI(carry_6_), .S(SUM[6]), .CON(n9) );
  AHHCONX2 U1_1_7 ( .A(A[7]), .CI(carry_7_), .S(SUM[7]), .CON(n8) );
  AHHCONX2 U1_1_8 ( .A(A[8]), .CI(carry_8_), .S(SUM[8]), .CON(n7) );
  AHHCONX2 U1_1_9 ( .A(A[9]), .CI(carry_9_), .S(SUM[9]), .CON(n6) );
  AHHCONX2 U1_1_10 ( .A(A[10]), .CI(carry_10_), .S(SUM[10]), .CON(n5) );
  AHHCONX2 U1_1_11 ( .A(A[11]), .CI(carry_11_), .S(SUM[11]), .CON(n4) );
  AHHCONX2 U1_1_12 ( .A(A[12]), .CI(carry_12_), .S(SUM[12]), .CON(n3) );
  AHHCONX2 U1_1_13 ( .A(A[13]), .CI(carry_13_), .S(SUM[13]), .CON(n2) );
  AHHCONX2 U1_1_14 ( .A(A[14]), .CI(carry_14_), .S(SUM[14]), .CON(n1) );
endmodule


module sign ( a, b );
  input [7:0] a;
  output [15:0] b;
  wire   n3, n5, n7, n9, n11, n13, n15, n25;

  CLKINVX1 U4 ( .A(n25), .Y(b[11]) );
  CLKINVX1 U5 ( .A(n25), .Y(b[12]) );
  CLKINVX1 U6 ( .A(n25), .Y(b[13]) );
  CLKINVX1 U7 ( .A(n25), .Y(b[14]) );
  CLKINVX1 U8 ( .A(n25), .Y(b[9]) );
  CLKINVX1 U9 ( .A(n25), .Y(b[10]) );
  CLKINVX1 U10 ( .A(n25), .Y(b[15]) );
  CLKINVX1 U11 ( .A(n25), .Y(b[8]) );
  CLKINVX1 U12 ( .A(a[7]), .Y(n25) );
  CLKINVX1 U13 ( .A(n25), .Y(b[7]) );
  CLKINVX1 U14 ( .A(n15), .Y(b[6]) );
  CLKINVX1 U15 ( .A(a[6]), .Y(n15) );
  CLKINVX1 U16 ( .A(n13), .Y(b[5]) );
  CLKINVX1 U17 ( .A(a[5]), .Y(n13) );
  CLKINVX1 U18 ( .A(n11), .Y(b[4]) );
  CLKINVX1 U19 ( .A(a[4]), .Y(n11) );
  CLKINVX1 U20 ( .A(n9), .Y(b[3]) );
  CLKINVX1 U21 ( .A(a[3]), .Y(n9) );
  CLKINVX1 U22 ( .A(n7), .Y(b[2]) );
  CLKINVX1 U23 ( .A(a[2]), .Y(n7) );
  CLKINVX1 U24 ( .A(n5), .Y(b[1]) );
  CLKINVX1 U25 ( .A(a[1]), .Y(n5) );
  CLKINVX1 U26 ( .A(n3), .Y(b[0]) );
  CLKINVX1 U27 ( .A(a[0]), .Y(n3) );
endmodule


module u_con ( code, clk, rst_p, en_int, msb_a, msb_r, cy, ac, ov, out_acc_r, 
        cy_psw, combus, out_dimod_r, in_xrom1_r, bit_dat_in_r, ld_instr, 
        wr_idat, rd_idat, end_instr, ld_pc, ld_pcl, ld_pch, ld_acc, ld_acc_chd, 
        inc_pc, inc_pc2, inc_pc3, sel_combus, sel_addr0, sel_addr1, wr_sfr, 
        ld_dpl, ld_dph, inc_dptr, wr_xdat, rd_xdat, ale, sel_xad, 
        sel_xaddr_low, sel_xaddr_high, inc_sp, dec_sp, ld_latch_acc, set_c, 
        rst_c, cpl_c, ld_c, set_ac, rst_ac, set_v, rst_v, sel_op1, sel_op2, 
        ld_b, en_div, sel_pc, sel_page_addr, bit_addr, rmw, sel_alu, 
        addr_bank_a, sel_bit_dat_out, sel_in_cy_bit, reti, psen, ld_xrom, 
        ld_idat, ld_sfr, ld_operand2, sel_code_xdat, ld_adptr, ld_apc );
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
  input clk, rst_p, en_int, msb_a, msb_r, cy, ac, ov, cy_psw, bit_dat_in_r;
  output ld_instr, wr_idat, rd_idat, end_instr, ld_pc, ld_pcl, ld_pch, ld_acc,
         ld_acc_chd, inc_pc, inc_pc2, inc_pc3, sel_addr0, wr_sfr, ld_dpl,
         ld_dph, inc_dptr, wr_xdat, rd_xdat, ale, sel_xad, sel_xaddr_low,
         sel_xaddr_high, inc_sp, dec_sp, ld_latch_acc, set_c, rst_c, cpl_c,
         ld_c, set_ac, rst_ac, set_v, rst_v, ld_b, en_div, sel_page_addr,
         bit_addr, rmw, reti, psen, ld_xrom, ld_idat, ld_sfr, ld_operand2,
         sel_code_xdat, ld_adptr, ld_apc;
  wire   timing_cnt_3_, timing_cnt_2_, timing_cnt_1_, extend_mux, extend_wr,
         extend_rd, en_int1, N211, N282, N283, N284, N287, N288, N289, N482,
         N483, N484, N490, N491, N492, N495, N496, n25, n31, n32, n50, n52,
         n53, n54, n55, n59, n61, n66, n238, n241, n249, n2870, n2890, n290,
         n304, n306, n307, n308, n309, n310, n311, n312, n313, n315, n316,
         n317, n333, n334, n335, n336, n337, n338, n339, n340, n341, n342,
         n343, n344, n345, n346, n347, n348, n349, n350, n351, n354, n355,
         n356, n357, n358, n359, n360, n361, n362, n363, n364, n365, n404,
         n423, n424, n426, n427, n428, n469, n470, n471, n479, n559, n560,
         n561, n562, n563, n564, n565, n566, n567, n568, n569, n570, n571,
         n572, n573, n574, n577, n578, n579, n580, n581, n582, n583, n584,
         n585, n586, n587, n588, n589, n590, n591, n592, n593, n594, n596,
         n597, n598, n599, n602, n603, n604, n605, n606, n607, n608, n609,
         n610, n611, n612, n613, n614, n616, n617, n618, n619, n621, n622,
         n624, n625, n626, n627, n628, n629, n630, n631, n632, n633, n634,
         n635, n636, n637, n638, n639, n640, n641, n642, n643, n645, n646,
         n648, n650, n651, n653, n655, n656, n657, n658, n659, n660, n661,
         n662, n663, n664, n665, n666, n667, n668, n669, n670, n671, n672,
         n673, n674, n675, n676, n677, n678, n679, n680, n681, n682, n683,
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
         n1224, n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232, n1233,
         n1234, n1235, n1236;
  wire   [3:0] t_2;
  wire   [2:0] itcnt;

  one_shot_3 one_shot_en_int ( .rst_p(rst_p), .clk(clk), .d(en_int), .q(
        en_int1) );
  INVX1 U639 ( .A(1'b1), .Y(psen) );
  CLKBUFX2 U641 ( .A(n650), .Y(n577) );
  CLKINVX6 U642 ( .A(n640), .Y(n650) );
  NAND2X1 U643 ( .A(n640), .B(n598), .Y(n613) );
  AND4X8 U644 ( .A(code[1]), .B(n1188), .C(n1212), .D(n715), .Y(n640) );
  NOR2X1 U645 ( .A(n934), .B(n694), .Y(n933) );
  CLKINVX1 U646 ( .A(n1188), .Y(n599) );
  NAND2X4 U647 ( .A(n1187), .B(n642), .Y(n900) );
  CLKINVX8 U648 ( .A(n900), .Y(n737) );
  INVX2 U649 ( .A(n1188), .Y(addr_bank_a[0]) );
  CLKBUFX2 U650 ( .A(n768), .Y(n578) );
  BUFX6 U651 ( .A(n669), .Y(n1221) );
  NAND2X4 U652 ( .A(n779), .B(n1013), .Y(n772) );
  INVX12 U653 ( .A(n671), .Y(n1013) );
  NAND2X4 U654 ( .A(n667), .B(n1013), .Y(n725) );
  INVX8 U655 ( .A(n1219), .Y(n842) );
  BUFX8 U656 ( .A(n659), .Y(n1219) );
  NAND2X6 U657 ( .A(n1194), .B(n1188), .Y(n671) );
  INVX8 U658 ( .A(n1166), .Y(n1194) );
  INVX3 U659 ( .A(n881), .Y(sel_op2[2]) );
  NOR2X1 U660 ( .A(code[5]), .B(code[4]), .Y(n1195) );
  NAND2X2 U661 ( .A(n678), .B(n1131), .Y(n694) );
  NAND2X1 U662 ( .A(code[3]), .B(n696), .Y(n1131) );
  NAND3X1 U663 ( .A(n1199), .B(n1228), .C(n1229), .Y(n669) );
  NAND2X2 U664 ( .A(n585), .B(n641), .Y(n790) );
  NAND2X1 U665 ( .A(n1220), .B(n833), .Y(n1158) );
  INVX3 U666 ( .A(n876), .Y(n872) );
  NAND2X1 U667 ( .A(n1062), .B(n750), .Y(n1205) );
  NAND2X1 U668 ( .A(n715), .B(n843), .Y(n751) );
  INVX3 U669 ( .A(n1070), .Y(n1180) );
  NAND2X2 U670 ( .A(n614), .B(n943), .Y(n686) );
  NOR2X4 U671 ( .A(code[1]), .B(n1188), .Y(n1187) );
  INVX3 U672 ( .A(code[7]), .Y(n1186) );
  INVX4 U673 ( .A(code[6]), .Y(n1184) );
  INVX3 U674 ( .A(code[4]), .Y(n1168) );
  NAND2X2 U675 ( .A(n1180), .B(n751), .Y(n724) );
  INVX3 U676 ( .A(n812), .Y(n781) );
  NAND2X2 U677 ( .A(n840), .B(n691), .Y(n839) );
  NAND2X1 U678 ( .A(n880), .B(n842), .Y(n873) );
  INVX1 U679 ( .A(n771), .Y(n880) );
  NAND2X2 U680 ( .A(code[3]), .B(n1127), .Y(n876) );
  OAI21X1 U681 ( .A0(n1128), .A1(n1221), .B0(n1129), .Y(n1127) );
  NOR2X1 U682 ( .A(n750), .B(n694), .Y(n1128) );
  INVX6 U683 ( .A(n790), .Y(n667) );
  NAND2X6 U684 ( .A(n667), .B(n737), .Y(n800) );
  NAND2X1 U685 ( .A(n782), .B(n783), .Y(sel_alu[3]) );
  NAND2X2 U686 ( .A(n334), .B(n1059), .Y(n290) );
  INVX1 U687 ( .A(n333), .Y(n1059) );
  INVX1 U688 ( .A(n1061), .Y(n334) );
  NAND4X1 U689 ( .A(n339), .B(n341), .C(n1060), .D(n340), .Y(n333) );
  INVX3 U690 ( .A(n683), .Y(n743) );
  NAND2X2 U691 ( .A(n622), .B(n989), .Y(ld_pc) );
  CLKAND2X6 U692 ( .A(n2890), .B(n1046), .Y(n622) );
  NOR2X1 U693 ( .A(n1047), .B(n1048), .Y(n1046) );
  NOR2X1 U694 ( .A(n59), .B(n1218), .Y(n664) );
  INVX1 U695 ( .A(n946), .Y(n59) );
  NOR2X4 U696 ( .A(n850), .B(n851), .Y(n848) );
  CLKINVX3 U697 ( .A(sel_pc[1]), .Y(n849) );
  CLKAND2X6 U698 ( .A(n838), .B(n839), .Y(n597) );
  NAND2X2 U699 ( .A(n683), .B(n846), .Y(n845) );
  NOR2X4 U700 ( .A(n875), .B(n872), .Y(n870) );
  NAND2X1 U701 ( .A(n1062), .B(n1180), .Y(n727) );
  NAND2X2 U702 ( .A(n1137), .B(n812), .Y(n863) );
  NAND2X1 U703 ( .A(n938), .B(n716), .Y(n868) );
  NAND4BX1 U704 ( .AN(n728), .B(n729), .C(n730), .D(n731), .Y(sel_combus[1])
         );
  NAND3BX1 U705 ( .AN(n754), .B(n755), .C(n756), .Y(sel_combus[0]) );
  OAI21X1 U706 ( .A0(n820), .A1(n805), .B0(n1062), .Y(n773) );
  NAND2X1 U707 ( .A(n632), .B(n639), .Y(n844) );
  NAND2X6 U708 ( .A(n1233), .B(n1235), .Y(n945) );
  NAND2X2 U709 ( .A(code[3]), .B(n1138), .Y(n771) );
  INVX3 U710 ( .A(n1055), .Y(n750) );
  NOR2X2 U711 ( .A(n852), .B(n725), .Y(n851) );
  NOR2BX1 U712 ( .AN(n853), .B(n693), .Y(n852) );
  NOR2X4 U713 ( .A(n1218), .B(n772), .Y(n850) );
  NAND2X1 U714 ( .A(n822), .B(n605), .Y(sel_alu[0]) );
  NOR2X1 U715 ( .A(n792), .B(n831), .Y(n822) );
  CLKINVX6 U716 ( .A(code[1]), .Y(n1216) );
  INVX3 U717 ( .A(n968), .Y(n1010) );
  BUFX3 U718 ( .A(n716), .Y(n1220) );
  NAND3X2 U719 ( .A(n661), .B(n662), .C(n663), .Y(set_c) );
  INVX1 U720 ( .A(n664), .Y(n663) );
  NOR2X1 U721 ( .A(n1019), .B(n1020), .Y(n1016) );
  CLKINVX1 U722 ( .A(n1229), .Y(n1230) );
  CLKAND2X4 U723 ( .A(code[5]), .B(code[4]), .Y(n581) );
  AND2X2 U724 ( .A(n1181), .B(n1000), .Y(n582) );
  AND2X4 U725 ( .A(code[4]), .B(n1185), .Y(n585) );
  AND3X2 U726 ( .A(n834), .B(n685), .C(n1153), .Y(n586) );
  AND2X2 U727 ( .A(n802), .B(n803), .Y(n587) );
  CLKINVX1 U728 ( .A(n843), .Y(n841) );
  INVX1 U729 ( .A(n807), .Y(n1130) );
  AND2X1 U730 ( .A(n695), .B(n1133), .Y(n588) );
  AND2X1 U731 ( .A(n750), .B(n751), .Y(n589) );
  NAND2X2 U732 ( .A(n1195), .B(n1196), .Y(n1137) );
  CLKAND2X2 U733 ( .A(n695), .B(n696), .Y(n629) );
  NAND2X2 U734 ( .A(n812), .B(n1137), .Y(n696) );
  NAND2X1 U735 ( .A(n586), .B(n940), .Y(n1143) );
  NAND3X1 U736 ( .A(n942), .B(n943), .C(n944), .Y(n941) );
  NAND3X2 U737 ( .A(n941), .B(n706), .C(n686), .Y(sel_pc[1]) );
  AOI21X1 U738 ( .A0(n1012), .A1(n1013), .B0(n1014), .Y(n1006) );
  NAND2X6 U739 ( .A(n781), .B(n1013), .Y(n827) );
  NAND3X6 U740 ( .A(n1199), .B(n580), .C(n1231), .Y(n604) );
  NAND3X6 U741 ( .A(code[2]), .B(n715), .C(code[1]), .Y(n843) );
  AND2X8 U742 ( .A(n855), .B(n854), .Y(n847) );
  INVX1 U743 ( .A(n1151), .Y(n940) );
  AND2X6 U744 ( .A(code[5]), .B(n1168), .Y(n639) );
  NOR2X1 U745 ( .A(n599), .B(n1193), .Y(n1192) );
  NAND3X4 U746 ( .A(n1212), .B(n715), .C(code[1]), .Y(n1193) );
  NAND2X2 U747 ( .A(n1192), .B(n781), .Y(n1093) );
  CLKINVX8 U748 ( .A(n768), .Y(n840) );
  NAND2X1 U749 ( .A(n586), .B(n940), .Y(n865) );
  INVX8 U750 ( .A(code[5]), .Y(n1185) );
  NAND3X1 U751 ( .A(n810), .B(n1152), .C(n651), .Y(n1151) );
  NAND2X1 U752 ( .A(n632), .B(n585), .Y(n1152) );
  NAND2X1 U753 ( .A(n739), .B(n1062), .Y(n1207) );
  INVX4 U754 ( .A(n609), .Y(n651) );
  AND4X2 U755 ( .A(code[5]), .B(code[4]), .C(n1184), .D(n1186), .Y(n609) );
  NAND2BX4 U756 ( .AN(n643), .B(n642), .Y(n801) );
  AND2X4 U757 ( .A(code[2]), .B(n715), .Y(n642) );
  NAND2X2 U758 ( .A(n1198), .B(n1199), .Y(n659) );
  NAND2X4 U759 ( .A(n1180), .B(n737), .Y(n768) );
  NOR2X4 U760 ( .A(n633), .B(n842), .Y(n867) );
  INVX8 U761 ( .A(n945), .Y(n1199) );
  NAND2X8 U762 ( .A(n596), .B(n597), .Y(sel_addr1[2]) );
  AND2X6 U763 ( .A(n845), .B(n749), .Y(n596) );
  AND2X2 U764 ( .A(n1200), .B(n1231), .Y(n598) );
  NAND4X2 U765 ( .A(n930), .B(n931), .C(n932), .D(n933), .Y(n878) );
  NAND3X8 U766 ( .A(n849), .B(n848), .C(n847), .Y(sel_addr1[1]) );
  NAND2X6 U767 ( .A(code[3]), .B(n667), .Y(n678) );
  NOR2X2 U768 ( .A(n878), .B(n879), .Y(n869) );
  NAND3BX2 U769 ( .AN(n865), .B(n866), .C(n867), .Y(n856) );
  DFFRHQX8 timing_cnt_reg_1_ ( .D(n572), .CK(clk), .RN(n560), .Q(timing_cnt_1_) );
  DFFRX4 timing_cnt_reg_2_ ( .D(n573), .CK(clk), .RN(n560), .Q(timing_cnt_2_), 
        .QN(n1233) );
  DFFRX4 timing_cnt_reg_3_ ( .D(n574), .CK(clk), .RN(n560), .Q(timing_cnt_3_), 
        .QN(n1235) );
  DFFRX4 timing_cnt_reg_0_ ( .D(n571), .CK(clk), .RN(n560), .Q(n580), .QN(
        n1229) );
  NAND2X4 U770 ( .A(n651), .B(n810), .Y(n943) );
  CLKAND2X2 U771 ( .A(code[7]), .B(code[6]), .Y(n641) );
  NAND2X2 U772 ( .A(n632), .B(n581), .Y(n1070) );
  AND2X1 U773 ( .A(n632), .B(n581), .Y(n633) );
  NAND2X2 U774 ( .A(n986), .B(n683), .Y(n855) );
  NAND2X2 U775 ( .A(n1015), .B(n1093), .Y(n986) );
  NAND4X2 U776 ( .A(code[4]), .B(n1185), .C(n1184), .D(n1186), .Y(n812) );
  BUFX6 U777 ( .A(n659), .Y(n1218) );
  INVX8 U778 ( .A(n604), .Y(n693) );
  AOI21X4 U779 ( .A0(n1007), .A1(n1008), .B0(n354), .Y(n313) );
  NAND2X2 U780 ( .A(n1006), .B(n313), .Y(n1005) );
  CLKINVX1 U781 ( .A(n1041), .Y(n348) );
  INVX6 U782 ( .A(n735), .Y(n779) );
  INVX1 U783 ( .A(n688), .Y(sel_op2[0]) );
  INVX1 U784 ( .A(n911), .Y(n689) );
  CLKINVX2 U785 ( .A(n1220), .Y(n739) );
  CLKINVX4 U786 ( .A(n579), .Y(n1090) );
  NAND4X1 U787 ( .A(code[6]), .B(code[4]), .C(n1185), .D(n1186), .Y(n685) );
  NAND3X1 U788 ( .A(code[0]), .B(code[4]), .C(n1194), .Y(n1015) );
  INVX8 U789 ( .A(n1221), .Y(n691) );
  NAND3X2 U790 ( .A(n990), .B(n991), .C(n992), .Y(n885) );
  INVX8 U791 ( .A(code[2]), .Y(n1212) );
  CLKINVX1 U792 ( .A(n697), .Y(sel_op1[1]) );
  INVX3 U793 ( .A(n727), .Y(n805) );
  NAND2X1 U794 ( .A(n581), .B(n939), .Y(n1055) );
  CLKINVX3 U795 ( .A(n1206), .Y(n939) );
  AOI21X1 U796 ( .A0(n698), .A1(n697), .B0(n1221), .Y(sel_op1[0]) );
  CLKINVX3 U797 ( .A(n681), .Y(n1213) );
  INVX1 U798 ( .A(n1134), .Y(n695) );
  NAND2X1 U799 ( .A(n1214), .B(n1199), .Y(n864) );
  INVX1 U800 ( .A(n613), .Y(n614) );
  NAND2X1 U801 ( .A(N289), .B(n993), .Y(n991) );
  INVX1 U802 ( .A(N282), .Y(n951) );
  NAND2X8 U803 ( .A(n617), .B(n914), .Y(n616) );
  INVX12 U804 ( .A(n616), .Y(bit_addr) );
  NAND3X2 U805 ( .A(n582), .B(n827), .C(n758), .Y(rmw) );
  NAND3X1 U806 ( .A(n691), .B(n692), .C(msb_a), .Y(n697) );
  CLKINVX4 U807 ( .A(n1114), .Y(n1203) );
  INVX1 U808 ( .A(n692), .Y(n1181) );
  NAND2X6 U809 ( .A(n800), .B(n827), .Y(n846) );
  CLKINVX2 U810 ( .A(n1077), .Y(n828) );
  NAND3BX2 U811 ( .AN(n789), .B(n726), .C(n1204), .Y(n1114) );
  CLKINVX1 U812 ( .A(n865), .Y(n935) );
  INVX1 U813 ( .A(n290), .Y(n1018) );
  NOR2X2 U814 ( .A(n863), .B(n868), .Y(n866) );
  NAND2X1 U815 ( .A(n737), .B(n696), .Y(n603) );
  NAND2X1 U816 ( .A(n1062), .B(n667), .Y(n777) );
  NAND3X1 U817 ( .A(n1199), .B(n1228), .C(n1229), .Y(n853) );
  NAND2X2 U818 ( .A(n1207), .B(n1208), .Y(n789) );
  NAND2X2 U819 ( .A(n1157), .B(n1201), .Y(n877) );
  NAND2X1 U820 ( .A(n666), .B(n667), .Y(n661) );
  INVX3 U821 ( .A(n863), .Y(n862) );
  NAND2X4 U822 ( .A(n1168), .B(n1185), .Y(n1211) );
  INVX1 U823 ( .A(n317), .Y(n1017) );
  INVX1 U824 ( .A(n351), .Y(n1044) );
  INVX1 U825 ( .A(n1045), .Y(n350) );
  OR2X1 U826 ( .A(n979), .B(n1069), .Y(n608) );
  NAND2X1 U827 ( .A(n693), .B(n1130), .Y(n1129) );
  NAND4X1 U828 ( .A(n306), .B(n307), .C(n308), .D(n309), .Y(n611) );
  OR2X1 U829 ( .A(n579), .B(n584), .Y(n612) );
  AND2X1 U830 ( .A(n1112), .B(n691), .Y(ld_dph) );
  OAI21X1 U831 ( .A0(n689), .A1(n690), .B0(n691), .Y(n687) );
  CLKINVX8 U832 ( .A(n743), .Y(n617) );
  NAND2BX1 U833 ( .AN(n740), .B(n738), .Y(n705) );
  CLKINVX1 U834 ( .A(sel_op2[2]), .Y(n648) );
  NAND3X2 U835 ( .A(n769), .B(n724), .C(n877), .Y(n875) );
  NAND2X4 U836 ( .A(n853), .B(n864), .Y(n683) );
  CLKINVX3 U837 ( .A(n777), .Y(n1078) );
  CLKINVX1 U838 ( .A(n827), .Y(n658) );
  NAND2X1 U839 ( .A(n898), .B(n1143), .Y(n688) );
  NAND2BX1 U840 ( .AN(n1081), .B(n739), .Y(n1174) );
  OA21X1 U841 ( .A0(n982), .A1(n1218), .B0(n983), .Y(n602) );
  NAND2BX1 U842 ( .AN(n1222), .B(n909), .Y(n908) );
  AND2X1 U843 ( .A(n666), .B(n1138), .Y(inc_dptr) );
  NAND2BX1 U844 ( .AN(n1003), .B(n994), .Y(ld_xrom) );
  OAI21X1 U845 ( .A0(n779), .A1(n1135), .B0(n1083), .Y(n931) );
  INVX1 U846 ( .A(n709), .Y(n1135) );
  NAND2X1 U847 ( .A(n603), .B(n800), .Y(n692) );
  NAND4X1 U848 ( .A(n337), .B(n338), .C(n336), .D(n335), .Y(n1061) );
  NAND3X2 U849 ( .A(n750), .B(n737), .C(n842), .Y(n749) );
  NAND3X1 U850 ( .A(n873), .B(n604), .C(n874), .Y(n871) );
  NAND2X1 U851 ( .A(n1138), .B(n1062), .Y(n726) );
  NAND2X1 U852 ( .A(n837), .B(n920), .Y(n1000) );
  CLKINVX1 U853 ( .A(n830), .Y(n1157) );
  AND2X1 U854 ( .A(n1138), .B(n1013), .Y(n621) );
  NAND2BX2 U855 ( .AN(n621), .B(n1205), .Y(sel_in_cy_bit[1]) );
  CLKINVX1 U856 ( .A(n844), .Y(n1138) );
  NAND2X1 U857 ( .A(n665), .B(cy), .Y(n662) );
  NAND2X1 U858 ( .A(n842), .B(n885), .Y(n884) );
  CLKINVX1 U859 ( .A(combus[5]), .Y(n341) );
  INVX1 U860 ( .A(combus[7]), .Y(n1060) );
  OAI21X1 U861 ( .A0(n710), .A1(n1218), .B0(n711), .Y(sel_combus[2]) );
  NOR2X1 U862 ( .A(n712), .B(ld_acc_chd), .Y(n711) );
  NOR3X1 U863 ( .A(n717), .B(n718), .C(n719), .Y(n710) );
  NAND2X1 U864 ( .A(n713), .B(n706), .Y(n712) );
  NAND4X1 U865 ( .A(n774), .B(n775), .C(n776), .D(n777), .Y(sel_alu[4]) );
  NAND4X1 U866 ( .A(n701), .B(n702), .C(n607), .D(n703), .Y(sel_combus[3]) );
  AND3X2 U867 ( .A(n823), .B(n776), .C(n824), .Y(n605) );
  NAND2BX1 U868 ( .AN(n817), .B(n816), .Y(n815) );
  NAND3X1 U869 ( .A(n796), .B(n587), .C(n797), .Y(sel_alu[2]) );
  NOR2X1 U870 ( .A(n798), .B(n799), .Y(n797) );
  NAND2X1 U871 ( .A(n1157), .B(n737), .Y(n734) );
  NAND3X1 U872 ( .A(n673), .B(n674), .C(n675), .Y(sel_pc[2]) );
  AOI2BB2X1 U873 ( .A0N(n1071), .A1N(n1221), .B0(n999), .B1(n693), .Y(n606) );
  INVX2 U874 ( .A(n650), .Y(n1062) );
  NAND2X1 U875 ( .A(n639), .B(n641), .Y(n830) );
  XNOR2X1 U876 ( .A(n306), .B(combus[0]), .Y(n971) );
  CLKAND2X2 U877 ( .A(code[7]), .B(n1184), .Y(n632) );
  NAND2X1 U878 ( .A(n641), .B(n581), .Y(n807) );
  NOR2X1 U879 ( .A(code[7]), .B(n1184), .Y(n1182) );
  AOI21X2 U880 ( .A0(n858), .A1(n859), .B0(n860), .Y(n857) );
  CLKINVX1 U881 ( .A(n843), .Y(n1083) );
  NAND3X2 U882 ( .A(n1090), .B(n1091), .C(n583), .Y(n854) );
  INVX1 U883 ( .A(n930), .Y(n979) );
  NAND2X2 U884 ( .A(n639), .B(n939), .Y(n1153) );
  INVX12 U885 ( .A(n1228), .Y(n1231) );
  OAI21X1 U886 ( .A0(n724), .A1(n947), .B0(n948), .Y(n946) );
  INVX1 U887 ( .A(N284), .Y(n947) );
  CLKINVX1 U888 ( .A(n791), .Y(n780) );
  INVX3 U889 ( .A(n801), .Y(n778) );
  CLKINVX1 U890 ( .A(combus[4]), .Y(n340) );
  NAND2X2 U891 ( .A(n350), .B(n1044), .Y(n974) );
  AOI21X1 U892 ( .A0(n625), .A1(n1220), .B0(n801), .Y(n798) );
  AND4X1 U893 ( .A(n1140), .B(n1141), .C(n1142), .D(n688), .Y(n607) );
  NAND2BX1 U894 ( .AN(n685), .B(n1013), .Y(n1170) );
  AOI2BB1X1 U895 ( .A0N(n608), .A1N(n1068), .B0(n604), .Y(n1066) );
  NAND4X2 U896 ( .A(n358), .B(n359), .C(n360), .D(n361), .Y(n968) );
  NAND2X1 U897 ( .A(n1201), .B(code[0]), .Y(n791) );
  NAND2X1 U898 ( .A(code[6]), .B(n1186), .Y(n1206) );
  NAND2X1 U899 ( .A(n343), .B(n1043), .Y(n1042) );
  CLKINVX1 U900 ( .A(n342), .Y(n1043) );
  NOR2X1 U901 ( .A(n304), .B(n611), .Y(n610) );
  XNOR2X1 U902 ( .A(n612), .B(itcnt[2]), .Y(N482) );
  INVX8 U903 ( .A(msb_a), .Y(n655) );
  CLKINVX1 U904 ( .A(msb_a), .Y(n976) );
  CLKINVX1 U905 ( .A(n648), .Y(ld_b) );
  CLKINVX1 U906 ( .A(n759), .Y(ld_c) );
  NAND2X1 U907 ( .A(n1112), .B(n842), .Y(n1080) );
  CLKINVX1 U908 ( .A(ov), .Y(n238) );
  CLKINVX1 U909 ( .A(n928), .Y(ld_acc_chd) );
  NAND2X1 U910 ( .A(n842), .B(n1114), .Y(n759) );
  NAND2X1 U911 ( .A(n666), .B(n739), .Y(n738) );
  NOR2X1 U912 ( .A(n752), .B(n753), .Y(n745) );
  NOR2X1 U913 ( .A(n743), .B(n744), .Y(n741) );
  NAND2X1 U914 ( .A(n758), .B(n759), .Y(n757) );
  CLKINVX1 U915 ( .A(n753), .Y(n249) );
  NOR2X1 U916 ( .A(n840), .B(n916), .Y(n910) );
  CLKINVX1 U917 ( .A(n914), .Y(n913) );
  CLKINVX1 U918 ( .A(n725), .Y(n999) );
  CLKINVX1 U919 ( .A(n1218), .Y(n923) );
  CLKINVX1 U920 ( .A(n479), .Y(sel_code_xdat) );
  NOR2X1 U921 ( .A(sel_code_xdat), .B(n1221), .Y(sel_xad) );
  CLKINVX1 U922 ( .A(n1162), .Y(cpl_c) );
  CLKINVX1 U923 ( .A(n744), .Y(n1112) );
  NOR2X1 U924 ( .A(sel_in_cy_bit[2]), .B(n805), .Y(n1073) );
  CLKINVX1 U925 ( .A(sel_in_cy_bit[1]), .Y(n1204) );
  NOR2X4 U926 ( .A(n658), .B(n1213), .Y(n1202) );
  NAND2X4 U927 ( .A(n1210), .B(n773), .Y(n1209) );
  NOR2X2 U928 ( .A(n1078), .B(n828), .Y(n1210) );
  CLKINVX1 U929 ( .A(n864), .Y(n858) );
  INVX3 U930 ( .A(n891), .Y(n898) );
  CLKINVX1 U931 ( .A(n1000), .Y(n690) );
  NAND3X1 U932 ( .A(n882), .B(n883), .C(n884), .Y(rst_c) );
  NAND2X1 U933 ( .A(n813), .B(n605), .Y(sel_alu[1]) );
  NOR2X1 U934 ( .A(n814), .B(n785), .Y(n813) );
  NAND3X1 U935 ( .A(n777), .B(n818), .C(n819), .Y(n814) );
  NAND2X1 U936 ( .A(n820), .B(n821), .Y(n818) );
  CLKINVX1 U937 ( .A(n890), .Y(n666) );
  AOI21X1 U938 ( .A0(n582), .A1(n709), .B0(n1219), .Y(n707) );
  MXI2X1 U939 ( .S0(msb_a), .B(n727), .A(n726), .Y(n717) );
  NAND2X1 U940 ( .A(n820), .B(n1013), .Y(n744) );
  NAND2X1 U941 ( .A(n877), .B(n1215), .Y(n753) );
  NAND2X1 U942 ( .A(n1157), .B(n1013), .Y(n1215) );
  NAND2BX1 U943 ( .AN(n776), .B(n691), .Y(n928) );
  CLKINVX1 U944 ( .A(n821), .Y(n811) );
  CLKINVX1 U945 ( .A(n763), .Y(n752) );
  NAND3X1 U946 ( .A(n1174), .B(n1082), .C(n1175), .Y(n740) );
  NAND2X1 U947 ( .A(n898), .B(n750), .Y(n1175) );
  NAND2X1 U948 ( .A(n665), .B(n61), .Y(n883) );
  INVX1 U949 ( .A(cy), .Y(n61) );
  CLKINVX1 U950 ( .A(n742), .Y(n760) );
  CLKINVX1 U951 ( .A(n1085), .Y(n755) );
  CLKINVX1 U952 ( .A(n816), .Y(n786) );
  CLKINVX1 U953 ( .A(ac), .Y(n66) );
  NAND4X1 U954 ( .A(n910), .B(n911), .C(n912), .D(n913), .Y(n909) );
  NOR2X1 U955 ( .A(n915), .B(n692), .Y(n912) );
  CLKINVX1 U956 ( .A(n698), .Y(n916) );
  CLKINVX1 U957 ( .A(n773), .Y(sel_bit_dat_out[1]) );
  CLKBUFX2 U958 ( .A(n669), .Y(n1222) );
  CLKINVX1 U959 ( .A(n915), .Y(n1001) );
  NOR3X1 U960 ( .A(n704), .B(n984), .C(n985), .Y(n983) );
  NOR2X1 U961 ( .A(n987), .B(n988), .Y(n982) );
  OAI21X1 U962 ( .A0(n1219), .A1(n877), .B0(n874), .Y(n926) );
  CLKINVX1 U963 ( .A(n733), .Y(n907) );
  NOR2X1 U964 ( .A(n734), .B(n1219), .Y(n975) );
  CLKINVX1 U965 ( .A(n800), .Y(n987) );
  CLKINVX1 U966 ( .A(n734), .Y(n922) );
  NAND2X1 U967 ( .A(n249), .B(n25), .Y(n479) );
  NOR2X1 U968 ( .A(sel_code_xdat), .B(n604), .Y(ale) );
  CLKINVX1 U969 ( .A(n1080), .Y(ld_dpl) );
  NOR2BX1 U970 ( .AN(msb_a), .B(n606), .Y(ld_sfr) );
  OAI21X1 U971 ( .A0(n1221), .A1(n1116), .B0(n1171), .Y(n677) );
  NAND2X1 U972 ( .A(n666), .B(n750), .Y(n1171) );
  NOR2X1 U973 ( .A(n1110), .B(n1111), .Y(n680) );
  NAND2X1 U974 ( .A(n800), .B(n827), .Y(n1111) );
  OAI21X1 U975 ( .A0(n988), .A1(n995), .B0(n693), .Y(n994) );
  NAND2X1 U976 ( .A(n734), .B(n769), .Y(n995) );
  NAND2X1 U977 ( .A(n680), .B(n1109), .Y(n1063) );
  NAND2X1 U978 ( .A(n680), .B(n681), .Y(n679) );
  NOR2X1 U979 ( .A(rmw), .B(n619), .Y(n618) );
  OR3X2 U980 ( .A(n1110), .B(n915), .C(n1178), .Y(n619) );
  NOR2BX1 U981 ( .AN(n1063), .B(n604), .Y(ld_operand2) );
  NAND2X1 U982 ( .A(n1109), .B(n725), .Y(n1178) );
  NAND2BX1 U983 ( .AN(n404), .B(n479), .Y(n52) );
  NAND2X1 U984 ( .A(n666), .B(n1180), .Y(n1162) );
  CLKINVX1 U985 ( .A(n1004), .Y(ld_pcl) );
  CLKINVX1 U986 ( .A(n726), .Y(sel_in_cy_bit[2]) );
  AOI21X1 U987 ( .A0(n776), .A1(n763), .B0(n604), .Y(ld_latch_acc) );
  CLKINVX1 U988 ( .A(n724), .Y(n993) );
  NOR2X2 U989 ( .A(n1220), .B(n1081), .Y(ld_apc) );
  NOR2X1 U990 ( .A(n1220), .B(n891), .Y(en_div) );
  CLKINVX1 U991 ( .A(n1082), .Y(ld_adptr) );
  NAND2X1 U992 ( .A(n1013), .B(n943), .Y(n681) );
  OAI21X1 U993 ( .A0(n1136), .A1(n863), .B0(n1083), .Y(n709) );
  CLKINVX1 U994 ( .A(n861), .Y(n1136) );
  CLKINVX1 U995 ( .A(combus[0]), .Y(n335) );
  NOR2X1 U996 ( .A(n1231), .B(n1229), .Y(n1214) );
  INVX3 U997 ( .A(n895), .Y(n820) );
  NAND2X1 U998 ( .A(n1083), .B(n1138), .Y(n769) );
  CLKINVX1 U999 ( .A(combus[3]), .Y(n338) );
  CLKINVX1 U1000 ( .A(combus[2]), .Y(n337) );
  CLKINVX1 U1001 ( .A(combus[1]), .Y(n336) );
  NAND2X1 U1002 ( .A(n1180), .B(n1013), .Y(n1208) );
  NOR2X1 U1003 ( .A(n1038), .B(n971), .Y(n345) );
  NAND3X1 U1004 ( .A(n1039), .B(n1040), .C(n348), .Y(n1038) );
  CLKINVX1 U1005 ( .A(n973), .Y(n1039) );
  CLKINVX1 U1006 ( .A(n972), .Y(n1040) );
  NOR2X2 U1007 ( .A(n1231), .B(n1229), .Y(n1198) );
  NAND2X1 U1008 ( .A(n979), .B(n691), .Y(n874) );
  NAND2X1 U1009 ( .A(n779), .B(n1062), .Y(n1077) );
  NAND2X1 U1010 ( .A(n844), .B(n853), .Y(n860) );
  CLKINVX1 U1011 ( .A(n868), .Y(n937) );
  INVX4 U1012 ( .A(n1056), .Y(n2890) );
  NAND2X4 U1013 ( .A(n626), .B(n1057), .Y(n1056) );
  NAND3X4 U1014 ( .A(n691), .B(n1058), .C(n290), .Y(n1057) );
  NAND2X1 U1015 ( .A(n693), .B(n778), .Y(n891) );
  NAND2X1 U1016 ( .A(n780), .B(n920), .Y(n698) );
  NAND2X2 U1017 ( .A(n898), .B(n1158), .Y(n881) );
  NAND2X1 U1018 ( .A(n737), .B(n1143), .Y(n911) );
  NAND2X1 U1019 ( .A(n830), .B(n807), .Y(n672) );
  NAND2X1 U1020 ( .A(n1083), .B(n691), .Y(n1134) );
  CLKINVX1 U1021 ( .A(combus[6]), .Y(n339) );
  NAND2X1 U1022 ( .A(n780), .B(n781), .Y(n774) );
  NAND2X1 U1023 ( .A(n778), .B(n779), .Y(n775) );
  OAI21X1 U1024 ( .A0(n737), .A1(n1083), .B0(n779), .Y(n763) );
  NOR2X1 U1025 ( .A(n741), .B(n742), .Y(n729) );
  OAI21X1 U1026 ( .A0(n745), .A1(n1219), .B0(n746), .Y(n728) );
  CLKINVX1 U1027 ( .A(n705), .Y(n730) );
  NAND3X1 U1028 ( .A(n1062), .B(n943), .C(n691), .Y(n1004) );
  NAND4BX1 U1029 ( .AN(n733), .B(n760), .C(n761), .D(n762), .Y(n754) );
  NAND3BX1 U1030 ( .AN(n1218), .B(n757), .C(msb_a), .Y(n756) );
  AOI21X1 U1031 ( .A0(n752), .A1(n683), .B0(ld_acc_chd), .Y(n762) );
  NOR2X1 U1032 ( .A(ld_b), .B(n684), .Y(n702) );
  NOR2X1 U1033 ( .A(n704), .B(n705), .Y(n703) );
  NOR2X1 U1034 ( .A(n707), .B(n708), .Y(n701) );
  NAND2X1 U1035 ( .A(n1004), .B(n686), .Y(n733) );
  AOI22X1 U1036 ( .A0(n770), .A1(n780), .B0(n778), .B1(n739), .Y(n819) );
  NAND2X1 U1037 ( .A(n772), .B(n1179), .Y(n915) );
  OAI21X1 U1038 ( .A0(n739), .A1(n779), .B0(n737), .Y(n1179) );
  NAND2X1 U1039 ( .A(n780), .B(n693), .Y(n890) );
  NOR3X1 U1040 ( .A(n696), .B(n1148), .C(n1149), .Y(n1147) );
  NAND2X1 U1041 ( .A(n830), .B(n807), .Y(n1148) );
  NAND2X1 U1042 ( .A(n855), .B(n854), .Y(n704) );
  NAND2X1 U1043 ( .A(n1083), .B(n667), .Y(n776) );
  OA21X1 U1044 ( .A0(n820), .A1(n1078), .B0(n1062), .Y(sel_bit_dat_out[0]) );
  NAND3X1 U1045 ( .A(n780), .B(n820), .C(n691), .Y(n1082) );
  NOR2X1 U1046 ( .A(n808), .B(n809), .Y(n796) );
  NAND3X1 U1047 ( .A(n720), .B(n634), .C(n721), .Y(n719) );
  NOR2X1 U1048 ( .A(n722), .B(n723), .Y(n720) );
  NAND2X1 U1049 ( .A(n724), .B(n725), .Y(n722) );
  NAND2X1 U1050 ( .A(n780), .B(n691), .Y(n1081) );
  OAI21X1 U1051 ( .A0(n770), .A1(n804), .B0(n780), .Y(n803) );
  NOR2X1 U1052 ( .A(n805), .B(n806), .Y(n802) );
  NAND2X1 U1053 ( .A(n1139), .B(n607), .Y(n1085) );
  NOR3X1 U1054 ( .A(ld_b), .B(n1154), .C(n1155), .Y(n1139) );
  NOR2X1 U1055 ( .A(n1222), .B(n734), .Y(n1154) );
  NOR2X1 U1056 ( .A(n897), .B(n830), .Y(n1155) );
  CLKINVX1 U1057 ( .A(n986), .Y(n721) );
  NAND2BX1 U1058 ( .AN(n837), .B(n811), .Y(n816) );
  OR2X1 U1059 ( .A(n624), .B(n751), .Y(n821) );
  OR2X1 U1060 ( .A(n737), .B(n778), .Y(n624) );
  NAND2X1 U1061 ( .A(n1089), .B(n854), .Y(n742) );
  NAND2X1 U1062 ( .A(n691), .B(n986), .Y(n1089) );
  OAI21X1 U1063 ( .A0(n739), .A1(n770), .B0(n737), .Y(n767) );
  NOR2X1 U1064 ( .A(n1144), .B(n1145), .Y(n1142) );
  NOR2X1 U1065 ( .A(n1146), .B(n890), .Y(n1145) );
  NOR2X1 U1066 ( .A(n1147), .B(n891), .Y(n1144) );
  NOR2X1 U1067 ( .A(n943), .B(n696), .Y(n1146) );
  NOR2X1 U1068 ( .A(ld_acc_chd), .B(n747), .Y(n746) );
  NAND2X1 U1069 ( .A(n748), .B(n749), .Y(n747) );
  NAND3X1 U1070 ( .A(n750), .B(n751), .C(n691), .Y(n748) );
  OAI21X1 U1071 ( .A0(n780), .A1(n821), .B0(n804), .Y(n823) );
  NOR2X1 U1072 ( .A(n825), .B(n795), .Y(n824) );
  NAND2X1 U1073 ( .A(n587), .B(n794), .Y(n793) );
  CLKINVX1 U1074 ( .A(n795), .Y(n794) );
  INVX1 U1075 ( .A(n815), .Y(n785) );
  AND2X1 U1076 ( .A(n833), .B(n892), .Y(n625) );
  CLKINVX1 U1077 ( .A(n833), .Y(n700) );
  OAI211X1 U1078 ( .A0(msb_a), .A1(n602), .B0(n31), .C0(n32), .Y(wr_idat) );
  CLKINVX1 U1079 ( .A(n981), .Y(n31) );
  AOI21X1 U1080 ( .A0(n975), .A1(n976), .B0(n977), .Y(n32) );
  NAND2X1 U1081 ( .A(n901), .B(n902), .Y(rd_idat) );
  NOR3BX1 U1082 ( .AN(n924), .B(n925), .C(n926), .Y(n901) );
  NAND3BX1 U1083 ( .AN(n996), .B(n997), .C(n758), .Y(n988) );
  NAND2X1 U1084 ( .A(n1001), .B(n1002), .Y(n996) );
  NOR3X1 U1085 ( .A(n998), .B(n690), .C(n999), .Y(n997) );
  NAND2X1 U1086 ( .A(n841), .B(n739), .Y(n1002) );
  NOR2X1 U1087 ( .A(n635), .B(n1222), .Y(n984) );
  CLKINVX1 U1088 ( .A(n706), .Y(n684) );
  NAND2X1 U1089 ( .A(n706), .B(n749), .Y(n985) );
  NAND2X1 U1090 ( .A(n1055), .B(n807), .Y(n1133) );
  NAND2X1 U1091 ( .A(n693), .B(n878), .Y(n924) );
  OAI21X1 U1092 ( .A0(n1221), .A1(n927), .B0(n928), .Y(n925) );
  CLKINVX1 U1093 ( .A(n723), .Y(n927) );
  OAI21X1 U1094 ( .A0(n1013), .A1(n1201), .B0(n1130), .Y(n25) );
  NAND2X1 U1095 ( .A(n907), .B(n1197), .Y(dec_sp) );
  NAND2X1 U1096 ( .A(n999), .B(n842), .Y(n1197) );
  NOR3X1 U1097 ( .A(n1221), .B(n670), .C(n671), .Y(sel_xaddr_low) );
  CLKINVX1 U1098 ( .A(n672), .Y(n670) );
  OAI21X1 U1099 ( .A0(n1104), .A1(n604), .B0(n1105), .Y(n1003) );
  NOR4X1 U1100 ( .A(n1113), .B(n1114), .C(n1115), .D(n689), .Y(n1104) );
  NOR2X1 U1101 ( .A(ld_dph), .B(n1106), .Y(n1105) );
  NAND2X1 U1102 ( .A(n1116), .B(n1117), .Y(n1115) );
  OAI21X1 U1103 ( .A0(n1172), .A1(n1173), .B0(n1013), .Y(n1116) );
  NAND2X1 U1104 ( .A(n817), .B(n1055), .Y(n1172) );
  NAND3X1 U1105 ( .A(n1191), .B(n681), .C(n721), .Y(n1120) );
  NAND2X1 U1106 ( .A(n804), .B(n1062), .Y(n1191) );
  NAND2X1 U1107 ( .A(n778), .B(n1180), .Y(n952) );
  NAND2X1 U1108 ( .A(n1084), .B(n755), .Y(ld_acc) );
  NOR3X1 U1109 ( .A(n740), .B(n1086), .C(n1087), .Y(n1084) );
  NOR2X1 U1110 ( .A(n1222), .B(n763), .Y(n1087) );
  NOR2X1 U1111 ( .A(n634), .B(n1218), .Y(n1086) );
  NAND2X1 U1112 ( .A(n626), .B(n686), .Y(sel_pc[0]) );
  NAND2X1 U1113 ( .A(n1118), .B(n1119), .Y(n1113) );
  CLKINVX1 U1114 ( .A(n1120), .Y(n1119) );
  NOR2X1 U1115 ( .A(n589), .B(n1121), .Y(n1118) );
  NAND3X1 U1116 ( .A(n1122), .B(n1123), .C(n1124), .Y(end_instr) );
  NOR3X1 U1117 ( .A(n740), .B(n677), .C(n1169), .Y(n1123) );
  NOR3X1 U1118 ( .A(n1125), .B(n1085), .C(n981), .Y(n1124) );
  NAND2X1 U1119 ( .A(n842), .B(n1176), .Y(n1122) );
  AOI21X1 U1120 ( .A0(n682), .A1(n683), .B0(n684), .Y(n673) );
  NOR2X1 U1121 ( .A(n676), .B(n677), .Y(n675) );
  NAND2BX1 U1122 ( .AN(n1219), .B(n679), .Y(n674) );
  NOR2X1 U1123 ( .A(n1058), .B(n1112), .Y(n1117) );
  NOR2X1 U1124 ( .A(n1096), .B(n1097), .Y(n1095) );
  OAI2BB2X1 U1125 ( .A0N(n898), .A1N(n750), .B0(n1098), .B1(n1221), .Y(n1097)
         );
  NOR2X1 U1126 ( .A(n618), .B(n604), .Y(n1096) );
  NOR4X1 U1127 ( .A(n916), .B(n1099), .C(n922), .D(n1100), .Y(n1098) );
  NAND2X1 U1128 ( .A(n1094), .B(n1095), .Y(inc_pc) );
  NOR2BX1 U1129 ( .AN(n1229), .B(n50), .Y(n571) );
  AOI2BB1X1 U1130 ( .A0N(n1055), .A1N(n890), .B0(n627), .Y(n626) );
  AND3X1 U1131 ( .A(n1062), .B(n696), .C(n691), .Y(n627) );
  NAND4BX1 U1132 ( .AN(n1159), .B(n759), .C(n1160), .D(n55), .Y(n1125) );
  NOR2X1 U1133 ( .A(n1161), .B(inc_dptr), .Y(n1160) );
  NAND4BX1 U1134 ( .AN(sel_page_addr), .B(n1162), .C(n1163), .D(n1164), .Y(
        n1159) );
  NAND2X1 U1135 ( .A(n1080), .B(n1004), .Y(n1161) );
  NOR2X1 U1136 ( .A(n770), .B(n781), .Y(n889) );
  CLKINVX1 U1137 ( .A(n686), .Y(ld_pch) );
  NOR2X1 U1138 ( .A(n699), .B(n671), .Y(sel_in_cy_bit[0]) );
  NOR2X1 U1139 ( .A(n633), .B(n700), .Y(n699) );
  AND2X1 U1140 ( .A(n881), .B(n668), .Y(n628) );
  NAND2X1 U1141 ( .A(n886), .B(n668), .Y(n665) );
  NOR2X1 U1142 ( .A(n887), .B(n888), .Y(n886) );
  NOR2X1 U1143 ( .A(n889), .B(n890), .Y(n888) );
  NOR2X1 U1144 ( .A(n625), .B(n891), .Y(n887) );
  NAND2X1 U1145 ( .A(n737), .B(n750), .Y(n1109) );
  NAND3X1 U1146 ( .A(n804), .B(n1013), .C(n693), .Y(n1164) );
  NOR2BX1 U1147 ( .AN(n1121), .B(n1222), .Y(n1169) );
  NAND2X1 U1148 ( .A(n666), .B(n779), .Y(n882) );
  NAND2X1 U1149 ( .A(n666), .B(n1149), .Y(n1163) );
  NOR2X1 U1150 ( .A(n718), .B(n1072), .Y(n1071) );
  NAND2X1 U1151 ( .A(n1073), .B(n827), .Y(n1072) );
  CLKINVX1 U1152 ( .A(n671), .Y(n1008) );
  CLKINVX1 U1153 ( .A(n54), .Y(n53) );
  NAND2BX1 U1154 ( .AN(n52), .B(n55), .Y(n54) );
  AOI21X1 U1155 ( .A0(n935), .A1(n830), .B0(n715), .Y(n934) );
  NOR2X1 U1156 ( .A(n1036), .B(n578), .Y(n1019) );
  CLKINVX1 U1157 ( .A(n316), .Y(n1036) );
  NAND2X1 U1158 ( .A(n1037), .B(n345), .Y(n316) );
  NOR2X1 U1159 ( .A(n974), .B(n1042), .Y(n1037) );
  NAND2X1 U1160 ( .A(n935), .B(n937), .Y(n936) );
  NOR2X1 U1161 ( .A(n641), .B(n939), .Y(n938) );
  NOR2X1 U1162 ( .A(n1229), .B(n945), .Y(n1200) );
  NOR2X1 U1163 ( .A(n1216), .B(n1068), .Y(addr_bank_a[1]) );
  CLKINVX8 U1164 ( .A(n584), .Y(n1091) );
  INVX3 U1165 ( .A(n1193), .Y(n1201) );
  NAND2X1 U1166 ( .A(n639), .B(n939), .Y(n817) );
  NOR2X4 U1167 ( .A(n970), .B(n969), .Y(n1009) );
  NAND3X1 U1168 ( .A(n861), .B(n735), .C(n862), .Y(n859) );
  NAND2X2 U1169 ( .A(n585), .B(n641), .Y(n861) );
  NAND3BX1 U1170 ( .AN(n844), .B(n841), .C(n842), .Y(n838) );
  OR3X4 U1171 ( .A(n629), .B(n630), .C(n631), .Y(sel_op1[2]) );
  AND2X1 U1172 ( .A(n693), .B(n694), .Y(n630) );
  AND3X1 U1173 ( .A(n692), .B(n691), .C(n655), .Y(n631) );
  NAND2X1 U1174 ( .A(n632), .B(n585), .Y(n895) );
  CLKINVX8 U1175 ( .A(n583), .Y(n1050) );
  NAND2X1 U1176 ( .A(n650), .B(n791), .Y(n837) );
  NAND2X1 U1177 ( .A(n1217), .B(n843), .Y(n1068) );
  NAND2X1 U1178 ( .A(n1201), .B(n672), .Y(n1217) );
  NAND2X1 U1179 ( .A(N288), .B(n949), .Y(n990) );
  NAND2X4 U1180 ( .A(N287), .B(n840), .Y(n992) );
  XNOR2X1 U1181 ( .A(n307), .B(combus[1]), .Y(n1041) );
  NOR2X1 U1182 ( .A(n1212), .B(n1068), .Y(addr_bank_a[2]) );
  NAND2X1 U1183 ( .A(n632), .B(n639), .Y(n833) );
  NOR2X1 U1184 ( .A(ov), .B(n628), .Y(rst_v) );
  XNOR2X1 U1185 ( .A(n311), .B(combus[4]), .Y(n351) );
  XNOR2X1 U1186 ( .A(n312), .B(combus[5]), .Y(n1045) );
  NOR2X1 U1187 ( .A(ac), .B(n668), .Y(rst_ac) );
  OAI22X1 U1188 ( .A0(n1220), .A1(n929), .B0(n735), .B1(n843), .Y(n723) );
  OAI21X1 U1189 ( .A0(n779), .A1(n700), .B0(n778), .Y(n832) );
  NOR2X1 U1190 ( .A(n784), .B(n785), .Y(n783) );
  NOR2X1 U1191 ( .A(n792), .B(n793), .Y(n782) );
  OAI21X1 U1192 ( .A0(n786), .A1(n685), .B0(n787), .Y(n784) );
  OAI21X1 U1193 ( .A0(n786), .A1(n834), .B0(n835), .Y(n792) );
  NOR2X1 U1194 ( .A(sel_in_cy_bit[1]), .B(n836), .Y(n835) );
  NOR2X1 U1195 ( .A(n791), .B(n810), .Y(n836) );
  NOR2X1 U1196 ( .A(n791), .B(n810), .Y(n809) );
  OAI21X1 U1197 ( .A0(n732), .A1(n733), .B0(msb_a), .Y(n731) );
  AOI21X1 U1198 ( .A0(n734), .A1(n735), .B0(n736), .Y(n732) );
  NAND2X1 U1199 ( .A(n737), .B(n691), .Y(n736) );
  OAI21X1 U1200 ( .A0(n764), .A1(n765), .B0(n766), .Y(n761) );
  NOR2X1 U1201 ( .A(n660), .B(n1219), .Y(n766) );
  NAND3X1 U1202 ( .A(n771), .B(n772), .C(n725), .Y(n764) );
  NOR2X1 U1203 ( .A(n811), .B(n812), .Y(n808) );
  CLKINVX1 U1204 ( .A(n1150), .Y(n897) );
  NAND2X1 U1205 ( .A(n735), .B(n892), .Y(n1149) );
  CLKINVX1 U1206 ( .A(n1137), .Y(n804) );
  NOR2BX1 U1207 ( .AN(n694), .B(n1221), .Y(n708) );
  NAND2X1 U1208 ( .A(n1074), .B(n1075), .Y(n718) );
  NOR3X1 U1209 ( .A(sel_bit_dat_out[0]), .B(sel_in_cy_bit[1]), .C(n1076), .Y(
        n1075) );
  NOR3X1 U1210 ( .A(n915), .B(n1079), .C(n789), .Y(n1074) );
  NAND2X1 U1211 ( .A(n771), .B(n1077), .Y(n1076) );
  CLKINVX1 U1212 ( .A(n651), .Y(n770) );
  NOR2X1 U1213 ( .A(n790), .B(n801), .Y(n825) );
  AND2X1 U1214 ( .A(n249), .B(n930), .Y(n634) );
  NAND2X1 U1215 ( .A(n585), .B(n641), .Y(n892) );
  NAND2X1 U1216 ( .A(n678), .B(n800), .Y(n799) );
  NOR2X1 U1217 ( .A(n807), .B(n801), .Y(n806) );
  NAND2X1 U1218 ( .A(n1143), .B(n1150), .Y(n1141) );
  NAND2X1 U1219 ( .A(n689), .B(n691), .Y(n1140) );
  NAND2X1 U1220 ( .A(n714), .B(n691), .Y(n713) );
  NOR2X1 U1221 ( .A(n715), .B(n1220), .Y(n714) );
  NOR2X1 U1222 ( .A(n788), .B(n789), .Y(n787) );
  NOR2X1 U1223 ( .A(n790), .B(n791), .Y(n788) );
  NAND2X1 U1224 ( .A(n826), .B(n827), .Y(n795) );
  NOR2X1 U1225 ( .A(n828), .B(n829), .Y(n826) );
  NOR2X1 U1226 ( .A(n801), .B(n830), .Y(n829) );
  AOI2BB1X1 U1227 ( .A0N(n715), .A1N(n1220), .B0(n636), .Y(n635) );
  AND2X1 U1228 ( .A(n1130), .B(n737), .Y(n636) );
  NAND2BX1 U1229 ( .AN(n637), .B(n771), .Y(n998) );
  AND2X1 U1230 ( .A(n737), .B(n696), .Y(n637) );
  NAND2X1 U1231 ( .A(n903), .B(n904), .Y(n902) );
  NAND4X1 U1232 ( .A(n905), .B(n906), .C(n907), .D(n908), .Y(n903) );
  CLKINVX1 U1233 ( .A(msb_a), .Y(n904) );
  NAND2X1 U1234 ( .A(n922), .B(n923), .Y(n905) );
  NAND2X1 U1235 ( .A(n842), .B(n660), .Y(n978) );
  NAND2X1 U1236 ( .A(n1126), .B(n876), .Y(n981) );
  NOR2X1 U1237 ( .A(n1132), .B(n588), .Y(n1126) );
  AOI21X1 U1238 ( .A0(n769), .A1(n931), .B0(n1219), .Y(n1132) );
  OAI21X1 U1239 ( .A0(n602), .A1(n655), .B0(n656), .Y(wr_sfr) );
  NAND2X1 U1240 ( .A(n657), .B(n658), .Y(n656) );
  NOR2X1 U1241 ( .A(n1219), .B(n660), .Y(n657) );
  OAI21X1 U1242 ( .A0(msb_a), .A1(n606), .B0(n1064), .Y(ld_idat) );
  NOR3X1 U1243 ( .A(n1065), .B(n1066), .C(n1067), .Y(n1064) );
  NOR2X1 U1244 ( .A(n897), .B(n1070), .Y(n1065) );
  NOR3X1 U1245 ( .A(n1221), .B(n1220), .C(n929), .Y(n1067) );
  NAND2BX1 U1246 ( .AN(end_instr), .B(n645), .Y(n50) );
  NAND2X1 U1247 ( .A(n635), .B(n1170), .Y(n1121) );
  NOR2X1 U1248 ( .A(n1051), .B(n1052), .Y(n1047) );
  NAND2X1 U1249 ( .A(n1013), .B(n691), .Y(n1052) );
  NOR3X1 U1250 ( .A(n1053), .B(n739), .C(n1054), .Y(n1051) );
  MXI2X1 U1251 ( .S0(n610), .B(n817), .A(n1055), .Y(n1053) );
  NOR2X1 U1252 ( .A(n1107), .B(n1222), .Y(n1106) );
  NOR2X1 U1253 ( .A(n1063), .B(n1108), .Y(n1107) );
  OAI21X1 U1254 ( .A0(n900), .A1(n1220), .B0(n681), .Y(n1108) );
  NOR2X1 U1255 ( .A(n1021), .B(n952), .Y(n1020) );
  NOR2X1 U1256 ( .A(n1022), .B(n1023), .Y(n1021) );
  NAND2X1 U1257 ( .A(n1024), .B(n1025), .Y(n1023) );
  NAND3X1 U1258 ( .A(n1031), .B(n1032), .C(n1033), .Y(n1022) );
  NOR2X1 U1259 ( .A(n1003), .B(n1101), .Y(n1094) );
  NAND2X1 U1260 ( .A(n1102), .B(n688), .Y(n1101) );
  NOR3X1 U1261 ( .A(sel_page_addr), .B(ld_instr), .C(n1103), .Y(n1102) );
  AOI21X1 U1262 ( .A0(n771), .A1(n1015), .B0(n1218), .Y(n1103) );
  NOR2X1 U1263 ( .A(n1222), .B(n678), .Y(n676) );
  CLKINVX1 U1264 ( .A(n678), .Y(n1058) );
  NOR2X1 U1265 ( .A(n638), .B(n50), .Y(n572) );
  XOR2X1 U1266 ( .A(n1230), .B(n1231), .Y(n638) );
  NOR2BX1 U1267 ( .AN(N495), .B(n50), .Y(n573) );
  XNOR2X1 U1268 ( .A(n1232), .B(n1233), .Y(N495) );
  CLKINVX1 U1269 ( .A(n1234), .Y(n1232) );
  NOR2BX1 U1270 ( .AN(N496), .B(n50), .Y(n574) );
  XNOR2X1 U1271 ( .A(n1236), .B(n1235), .Y(N496) );
  NOR2X1 U1272 ( .A(n1234), .B(n1233), .Y(n1236) );
  NAND2X1 U1273 ( .A(n1177), .B(n618), .Y(n1176) );
  NOR2X1 U1274 ( .A(n1120), .B(n1189), .Y(n1177) );
  NAND2X1 U1275 ( .A(n841), .B(n739), .Y(n1190) );
  NOR2X1 U1276 ( .A(n1220), .B(n929), .Y(n1100) );
  CLKINVX1 U1277 ( .A(n1049), .Y(sel_page_addr) );
  NOR2X1 U1278 ( .A(n685), .B(n671), .Y(n682) );
  NAND2X1 U1279 ( .A(n769), .B(n1093), .Y(n1099) );
  NAND2X1 U1280 ( .A(n706), .B(n1049), .Y(n1048) );
  NOR2X1 U1281 ( .A(n715), .B(n1220), .Y(n1069) );
  NOR2X1 U1282 ( .A(n900), .B(n1222), .Y(n899) );
  NOR2X1 U1283 ( .A(n604), .B(n1093), .Y(inc_pc3) );
  CLKINVX1 U1284 ( .A(n1015), .Y(n1014) );
  NAND2X1 U1285 ( .A(n893), .B(n894), .Y(n668) );
  NAND2X1 U1286 ( .A(n896), .B(n897), .Y(n893) );
  NOR2X1 U1287 ( .A(n898), .B(n899), .Y(n896) );
  NAND2X1 U1288 ( .A(n1088), .B(n760), .Y(inc_sp) );
  AOI22X1 U1289 ( .A0(n693), .A1(n1092), .B0(n583), .B1(n1090), .Y(n1088) );
  NAND2X1 U1290 ( .A(n721), .B(n772), .Y(n1092) );
  NOR2X1 U1291 ( .A(n604), .B(n1015), .Y(inc_pc2) );
  CLKINVX1 U1292 ( .A(n423), .Y(n55) );
  CLKINVX1 U1293 ( .A(n428), .Y(n427) );
  NAND3BX1 U1294 ( .AN(sel_code_xdat), .B(n426), .C(n55), .Y(n428) );
  NAND2X1 U1295 ( .A(n1228), .B(n1230), .Y(n1234) );
  NAND2X1 U1296 ( .A(t_2[1]), .B(t_2[0]), .Y(n1226) );
  NOR2BX1 U1297 ( .AN(n579), .B(n645), .Y(n561) );
  XNOR2X1 U1298 ( .A(in_xrom1_r[0]), .B(combus[0]), .Y(n361) );
  NAND4X2 U1299 ( .A(code[5]), .B(n1168), .C(n1184), .D(n1186), .Y(n810) );
  XNOR2X1 U1300 ( .A(in_xrom1_r[3]), .B(combus[3]), .Y(n358) );
  XNOR2X1 U1301 ( .A(in_xrom1_r[2]), .B(combus[2]), .Y(n359) );
  XNOR2X1 U1302 ( .A(in_xrom1_r[1]), .B(combus[1]), .Y(n360) );
  INVX8 U1303 ( .A(code[0]), .Y(n1188) );
  OR2X1 U1304 ( .A(code[1]), .B(code[0]), .Y(n643) );
  AOI21X1 U1305 ( .A0(N283), .A1(n949), .B0(n950), .Y(n948) );
  CLKINVX1 U1306 ( .A(n952), .Y(n949) );
  XNOR2X1 U1307 ( .A(in_xrom1_r[4]), .B(combus[4]), .Y(n967) );
  NAND2X4 U1308 ( .A(n362), .B(n967), .Y(n969) );
  XNOR2X1 U1309 ( .A(in_xrom1_r[5]), .B(combus[5]), .Y(n362) );
  XNOR2X1 U1310 ( .A(out_acc_r[7]), .B(combus[7]), .Y(n343) );
  XNOR2X1 U1311 ( .A(n310), .B(combus[6]), .Y(n342) );
  NOR2X1 U1312 ( .A(n238), .B(n628), .Y(set_v) );
  NAND2X1 U1313 ( .A(n1134), .B(n1156), .Y(n1150) );
  NOR2X1 U1314 ( .A(n66), .B(n668), .Y(set_ac) );
  NAND2X1 U1315 ( .A(n693), .B(n917), .Y(n906) );
  NAND4X1 U1316 ( .A(n918), .B(n919), .C(n734), .D(n725), .Y(n917) );
  NAND2X1 U1317 ( .A(n920), .B(n921), .Y(n919) );
  CLKINVX1 U1318 ( .A(msb_r), .Y(n660) );
  NOR2BX1 U1319 ( .AN(extend_wr), .B(n25), .Y(wr_xdat) );
  NOR2X1 U1320 ( .A(n1034), .B(n1035), .Y(n1031) );
  XNOR2X1 U1321 ( .A(n306), .B(in_xrom1_r[0]), .Y(n1034) );
  XNOR2X1 U1322 ( .A(n307), .B(in_xrom1_r[1]), .Y(n1035) );
  CLKINVX1 U1323 ( .A(out_acc_r[1]), .Y(n307) );
  CLKINVX1 U1324 ( .A(out_acc_r[2]), .Y(n308) );
  CLKINVX1 U1325 ( .A(out_acc_r[5]), .Y(n312) );
  CLKINVX1 U1326 ( .A(out_acc_r[4]), .Y(n311) );
  CLKINVX1 U1327 ( .A(out_acc_r[3]), .Y(n309) );
  NAND4BX1 U1328 ( .AN(out_acc_r[7]), .B(n310), .C(n311), .D(n312), .Y(n304)
         );
  NOR2X1 U1329 ( .A(n1026), .B(n1027), .Y(n1025) );
  XNOR2X1 U1330 ( .A(n311), .B(in_xrom1_r[4]), .Y(n1026) );
  XNOR2X1 U1331 ( .A(n312), .B(in_xrom1_r[5]), .Y(n1027) );
  XOR2X1 U1332 ( .A(n309), .B(in_xrom1_r[3]), .Y(n1033) );
  XOR2X1 U1333 ( .A(n308), .B(in_xrom1_r[2]), .Y(n1032) );
  OAI22X1 U1334 ( .A0(n965), .A1(out_dimod_r[0]), .B0(n1221), .B1(n955), .Y(
        n962) );
  NOR2X1 U1335 ( .A(out_dimod_r[1]), .B(n858), .Y(n965) );
  CLKINVX1 U1336 ( .A(out_acc_r[0]), .Y(n306) );
  NOR2X1 U1337 ( .A(bit_dat_in_r), .B(n651), .Y(n1012) );
  CLKINVX1 U1338 ( .A(out_acc_r[6]), .Y(n310) );
  OAI33X1 U1339 ( .A0(n469), .A1(out_dimod_r[2]), .A2(n404), .B0(n52), .B1(
        n470), .B2(n471), .Y(n423) );
  NAND2BX1 U1340 ( .AN(timing_cnt_2_), .B(timing_cnt_3_), .Y(n471) );
  MXI2X1 U1341 ( .S0(n1229), .B(n954), .A(n953), .Y(n470) );
  NAND3BX1 U1342 ( .AN(sel_code_xdat), .B(n962), .C(n963), .Y(n469) );
  NOR2X1 U1343 ( .A(n960), .B(n961), .Y(n953) );
  NAND2X1 U1344 ( .A(out_dimod_r[2]), .B(n955), .Y(n961) );
  XNOR2X1 U1345 ( .A(out_dimod_r[1]), .B(n1231), .Y(n960) );
  NOR2BX1 U1346 ( .AN(extend_mux), .B(sel_code_xdat), .Y(sel_xaddr_high) );
  AND2X2 U1347 ( .A(n645), .B(n404), .Y(ld_instr) );
  NAND2X1 U1348 ( .A(out_dimod_r[1]), .B(n964), .Y(n963) );
  NAND3X1 U1349 ( .A(n1235), .B(n1231), .C(n1229), .Y(n964) );
  NOR2X1 U1350 ( .A(n955), .B(n956), .Y(n954) );
  MXI2X1 U1351 ( .S0(out_dimod_r[2]), .B(n958), .A(n957), .Y(n956) );
  NOR2X1 U1352 ( .A(out_dimod_r[1]), .B(n1231), .Y(n958) );
  NOR2X1 U1353 ( .A(n1228), .B(n959), .Y(n957) );
  NAND2X1 U1354 ( .A(n1165), .B(n693), .Y(n1049) );
  NOR2X1 U1355 ( .A(n1166), .B(n1167), .Y(n1165) );
  NAND2X1 U1356 ( .A(addr_bank_a[0]), .B(n1168), .Y(n1167) );
  NOR2X1 U1357 ( .A(n1028), .B(n1029), .Y(n1024) );
  XNOR2X1 U1358 ( .A(n310), .B(in_xrom1_r[6]), .Y(n1028) );
  XNOR2X1 U1359 ( .A(out_acc_r[7]), .B(n1030), .Y(n1029) );
  CLKINVX1 U1360 ( .A(in_xrom1_r[7]), .Y(n1030) );
  CLKINVX1 U1361 ( .A(out_dimod_r[0]), .Y(n955) );
  CLKINVX1 U1362 ( .A(out_dimod_r[1]), .Y(n959) );
  AO22X2 U1363 ( .A0(t_2[0]), .A1(n52), .B0(n593), .B1(n53), .Y(n567) );
  AO22X2 U1364 ( .A0(t_2[1]), .A1(n52), .B0(N490), .B1(n53), .Y(n568) );
  XNOR2X1 U1365 ( .A(t_2[0]), .B(n594), .Y(N490) );
  AO22X2 U1366 ( .A0(t_2[2]), .A1(n52), .B0(N491), .B1(n53), .Y(n569) );
  XNOR2X1 U1367 ( .A(n1225), .B(n590), .Y(N491) );
  CLKINVX1 U1368 ( .A(n1226), .Y(n1225) );
  AO22X2 U1369 ( .A0(t_2[3]), .A1(n52), .B0(N492), .B1(n53), .Y(n570) );
  XNOR2X1 U1370 ( .A(n1227), .B(n592), .Y(N492) );
  NOR2X1 U1371 ( .A(n1226), .B(n590), .Y(n1227) );
  AO21X2 U1372 ( .A0(extend_rd), .A1(n55), .B0(n427), .Y(n564) );
  AO21X2 U1373 ( .A0(extend_mux), .A1(n55), .B0(n427), .Y(n566) );
  NOR2BX1 U1374 ( .AN(extend_rd), .B(n249), .Y(rd_xdat) );
  OAI32X1 U1375 ( .A0(n423), .A1(n25), .A2(n424), .B0(n591), .B1(n423), .Y(
        n565) );
  CLKINVX1 U1376 ( .A(n426), .Y(n424) );
  CLKINVX1 U1377 ( .A(bit_dat_in_r), .Y(n1011) );
  OR4X1 U1378 ( .A(t_2[3]), .B(t_2[2]), .C(t_2[0]), .D(t_2[1]), .Y(n426) );
  NOR2BX1 U1379 ( .AN(N482), .B(n645), .Y(n563) );
  NOR2X1 U1380 ( .A(n646), .B(n645), .Y(n562) );
  XOR2X1 U1381 ( .A(itcnt[0]), .B(n584), .Y(n646) );
  CLKINVX1 U1382 ( .A(rst_p), .Y(n560) );
  NOR2BX1 U1383 ( .AN(en_int1), .B(rst_p), .Y(N483) );
  NAND3BX1 U1384 ( .AN(N211), .B(n559), .C(n560), .Y(N484) );
  CLKINVX1 U1385 ( .A(en_int1), .Y(n559) );
  NOR2X1 U1386 ( .A(n1224), .B(n583), .Y(N211) );
  NOR2X1 U1387 ( .A(itcnt[0]), .B(itcnt[1]), .Y(n1224) );
  DFFRX1 extend_wr_reg ( .D(n565), .CK(clk), .RN(n560), .Q(extend_wr), .QN(
        n591) );
  DFFRX1 t_2_reg_0_ ( .D(n567), .CK(clk), .RN(n560), .Q(t_2[0]), .QN(n593) );
  DFFRX1 t_2_reg_2_ ( .D(n569), .CK(clk), .RN(n560), .Q(t_2[2]), .QN(n590) );
  DFFRX1 t_2_reg_1_ ( .D(n568), .CK(clk), .RN(n560), .Q(t_2[1]), .QN(n594) );
  DFFRX1 t_2_reg_3_ ( .D(n570), .CK(clk), .RN(n560), .Q(t_2[3]), .QN(n592) );
  DFFRX1 extend_rd_reg ( .D(n564), .CK(clk), .RN(n560), .Q(extend_rd) );
  DFFRX1 extend_mux_reg ( .D(n566), .CK(clk), .RN(n560), .Q(extend_mux) );
  TLATX1 en_itcnt_reg ( .D(N483), .G(N484), .QN(n645) );
  NOR2X1 U1388 ( .A(n1011), .B(n810), .Y(n1007) );
  NAND3X1 U1389 ( .A(n651), .B(n810), .C(n895), .Y(n894) );
  NOR2X1 U1390 ( .A(n1231), .B(n945), .Y(n942) );
  NOR3X1 U1391 ( .A(n1228), .B(n945), .C(n580), .Y(n404) );
  NAND4X1 U1392 ( .A(code[7]), .B(n1168), .C(n1185), .D(n1184), .Y(n716) );
  NAND2X1 U1393 ( .A(n739), .B(code[3]), .Y(n918) );
  NAND2X1 U1394 ( .A(n693), .B(code[3]), .Y(n1156) );
  NAND2X1 U1395 ( .A(code[3]), .B(n779), .Y(n930) );
  INVX8 U1396 ( .A(code[3]), .Y(n715) );
  NAND3X1 U1397 ( .A(code[2]), .B(n715), .C(code[1]), .Y(n929) );
  CLKINVX1 U1398 ( .A(n577), .Y(n921) );
  NOR2X1 U1399 ( .A(n580), .B(n650), .Y(n944) );
  NOR2X1 U1400 ( .A(n577), .B(n651), .Y(reti) );
  NAND3X1 U1401 ( .A(n767), .B(n578), .C(n769), .Y(n765) );
  NOR2X1 U1402 ( .A(n578), .B(n951), .Y(n950) );
  NAND2X1 U1403 ( .A(n769), .B(n578), .Y(n1079) );
  NAND3X1 U1404 ( .A(n952), .B(n724), .C(n578), .Y(n1110) );
  MXI2X1 U1405 ( .S0(cy_psw), .B(n834), .A(n685), .Y(n1054) );
  NAND2X1 U1406 ( .A(n1220), .B(n834), .Y(n1173) );
  NAND3X1 U1407 ( .A(n685), .B(n834), .C(n817), .Y(n920) );
  NAND2X4 U1408 ( .A(n1182), .B(n1183), .Y(n834) );
  NAND3X1 U1409 ( .A(n930), .B(n1190), .C(n771), .Y(n1189) );
  NAND3X6 U1410 ( .A(code[7]), .B(code[6]), .C(n1183), .Y(n735) );
  NOR2X1 U1411 ( .A(code[7]), .B(code[6]), .Y(n1196) );
  OAI21X1 U1412 ( .A0(n715), .A1(n1220), .B0(n873), .Y(n879) );
  NAND3X6 U1413 ( .A(n1212), .B(n1216), .C(n715), .Y(n1166) );
  OAI21X1 U1414 ( .A0(n811), .A1(n651), .B0(n832), .Y(n831) );
  OAI22X1 U1415 ( .A0(n827), .A1(n1011), .B0(n1018), .B1(n800), .Y(n317) );
  OAI21X1 U1416 ( .A0(n827), .A1(n978), .B0(n874), .Y(n977) );
  OAI21X4 U1417 ( .A0(n655), .A1(n687), .B0(n688), .Y(sel_op2[1]) );
  NOR3BX4 U1418 ( .AN(n856), .B(n857), .C(n843), .Y(sel_addr1[0]) );
  AOI2BB2X4 U1419 ( .A0N(n871), .A1N(n872), .B0(n869), .B1(n870), .Y(n653) );
  NAND2BX4 U1420 ( .AN(n843), .B(n936), .Y(n932) );
  INVX8 U1421 ( .A(n966), .Y(n365) );
  INVX8 U1422 ( .A(n967), .Y(n363) );
  INVX8 U1423 ( .A(n968), .Y(n357) );
  INVX8 U1424 ( .A(n969), .Y(n356) );
  INVX8 U1425 ( .A(n970), .Y(n355) );
  INVX8 U1426 ( .A(n971), .Y(n349) );
  INVX8 U1427 ( .A(n972), .Y(n347) );
  INVX8 U1428 ( .A(n973), .Y(n346) );
  INVX8 U1429 ( .A(n974), .Y(n344) );
  INVX8 U1430 ( .A(n980), .Y(n315) );
  INVX8 U1431 ( .A(n989), .Y(n2870) );
  INVX8 U1432 ( .A(n885), .Y(n241) );
  OAI21X4 U1433 ( .A0(n980), .A1(n1005), .B0(n842), .Y(n989) );
  AOI21X4 U1434 ( .A0(n1009), .A1(n1010), .B0(n724), .Y(n354) );
  NAND2X6 U1435 ( .A(n364), .B(n966), .Y(n970) );
  XNOR2X4 U1436 ( .A(in_xrom1_r[6]), .B(combus[6]), .Y(n966) );
  XNOR2X4 U1437 ( .A(in_xrom1_r[7]), .B(combus[7]), .Y(n364) );
  NAND2X6 U1438 ( .A(n1016), .B(n1017), .Y(n980) );
  XNOR2X4 U1439 ( .A(n308), .B(combus[2]), .Y(n972) );
  XNOR2X4 U1440 ( .A(n309), .B(combus[3]), .Y(n973) );
  NAND3X8 U1441 ( .A(n584), .B(n1050), .C(n579), .Y(n706) );
  NAND3X6 U1442 ( .A(n1202), .B(n758), .C(n1203), .Y(n914) );
  INVX8 U1443 ( .A(n1209), .Y(n758) );
  INVX8 U1444 ( .A(n1211), .Y(n1183) );
  BUFX20 U1445 ( .A(n653), .Y(sel_addr0) );
  u_con_DW01_cmp2_8_5 gte_1428_2 ( .A(in_xrom1_r), .B(out_acc_r), .LEQ(1'b1), 
        .TC(1'b0), .LT_LE(N288) );
  u_con_DW01_cmp2_8_4 gte_1428 ( .A(combus), .B(out_acc_r), .LEQ(1'b1), .TC(
        1'b0), .LT_LE(N287) );
  u_con_DW01_cmp2_8_3 lt_1405_2 ( .A(out_acc_r), .B(in_xrom1_r), .LEQ(1'b0), 
        .TC(1'b0), .LT_LE(N283) );
  u_con_DW01_cmp2_8_2 lt_1405 ( .A(out_acc_r), .B(combus), .LEQ(1'b0), .TC(
        1'b0), .LT_LE(N282) );
  u_con_DW01_cmp2_8_1 r102 ( .A(in_xrom1_r), .B(combus), .LEQ(1'b1), .TC(1'b0), 
        .LT_LE(N289) );
  u_con_DW01_cmp2_8_0 r99 ( .A(combus), .B(in_xrom1_r), .LEQ(1'b0), .TC(1'b0), 
        .LT_LE(N284) );
  BUFX20 U1446 ( .A(timing_cnt_1_), .Y(n1228) );
  DFFRX4 itcnt_reg_2_ ( .D(n563), .CK(clk), .RN(n560), .Q(itcnt[2]), .QN(n583)
         );
  DFFRX4 itcnt_reg_1_ ( .D(n562), .CK(clk), .RN(n560), .Q(itcnt[1]), .QN(n584)
         );
  DFFRX4 itcnt_reg_0_ ( .D(n561), .CK(clk), .RN(n560), .Q(itcnt[0]), .QN(n579)
         );
endmodule


module u_con_DW01_cmp2_8_0 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53;

  INVX1 U6 ( .A(n50), .Y(n25) );
  NAND4X1 U7 ( .A(n40), .B(n41), .C(n42), .D(n43), .Y(n18) );
  CLKINVX1 U8 ( .A(n30), .Y(n41) );
  NAND2X1 U9 ( .A(B[3]), .B(n33), .Y(n40) );
  NAND2X1 U10 ( .A(B[2]), .B(n46), .Y(n42) );
  OAI21X1 U11 ( .A0(B[0]), .A1(n18), .B0(n19), .Y(n17) );
  NOR2X1 U12 ( .A(n18), .B(n34), .Y(n16) );
  NAND3X1 U13 ( .A(n37), .B(B[1]), .C(n44), .Y(n43) );
  NOR2X1 U14 ( .A(n18), .B(n38), .Y(n35) );
  INVX1 U15 ( .A(B[1]), .Y(n39) );
  INVX1 U16 ( .A(B[2]), .Y(n45) );
  NAND3X1 U17 ( .A(n47), .B(n25), .C(n48), .Y(n30) );
  NAND2X1 U18 ( .A(B[5]), .B(n53), .Y(n47) );
  NAND2X1 U19 ( .A(B[4]), .B(n49), .Y(n48) );
  NAND2X1 U20 ( .A(A[4]), .B(n32), .Y(n31) );
  AOI2BB2X1 U21 ( .A0N(B[7]), .A1N(n28), .B0(n27), .B1(n25), .Y(n23) );
  NAND2X1 U22 ( .A(n51), .B(n52), .Y(n50) );
  CLKINVX1 U23 ( .A(A[0]), .Y(n34) );
  CLKINVX1 U24 ( .A(A[2]), .Y(n46) );
  CLKINVX1 U25 ( .A(A[3]), .Y(n33) );
  CLKINVX1 U26 ( .A(A[6]), .Y(n29) );
  CLKINVX1 U27 ( .A(A[7]), .Y(n28) );
  NOR2X1 U28 ( .A(n18), .B(n37), .Y(n36) );
  CLKINVX1 U29 ( .A(A[4]), .Y(n49) );
  NOR3BX2 U30 ( .AN(n15), .B(n16), .C(n17), .Y(LT_LE) );
  NOR2X1 U31 ( .A(n35), .B(n36), .Y(n15) );
  CLKINVX1 U32 ( .A(A[1]), .Y(n44) );
  NAND2X1 U33 ( .A(A[1]), .B(n39), .Y(n38) );
  NAND2X1 U34 ( .A(A[2]), .B(n45), .Y(n37) );
  NOR3X1 U35 ( .A(n20), .B(n21), .C(n22), .Y(n19) );
  NAND2X1 U36 ( .A(n23), .B(n24), .Y(n22) );
  NOR2X1 U37 ( .A(n30), .B(n31), .Y(n21) );
  NOR3X1 U38 ( .A(n33), .B(B[3]), .C(n30), .Y(n20) );
  CLKINVX1 U39 ( .A(A[5]), .Y(n53) );
  NAND3X1 U40 ( .A(n25), .B(n26), .C(A[5]), .Y(n24) );
  CLKINVX1 U41 ( .A(B[5]), .Y(n26) );
  INVX1 U42 ( .A(B[4]), .Y(n32) );
  NOR2X1 U43 ( .A(B[6]), .B(n29), .Y(n27) );
  NAND2X1 U44 ( .A(B[6]), .B(n29), .Y(n52) );
  NAND2X1 U45 ( .A(B[7]), .B(n28), .Y(n51) );
endmodule


module u_con_DW01_cmp2_8_1 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57;

  NAND2X1 U6 ( .A(n55), .B(n45), .Y(n22) );
  NOR2X1 U7 ( .A(n43), .B(n44), .Y(n42) );
  INVX1 U8 ( .A(n39), .Y(n28) );
  NOR3X1 U9 ( .A(n46), .B(n52), .C(n47), .Y(n43) );
  INVX1 U10 ( .A(n22), .Y(n47) );
  NAND4X2 U11 ( .A(n31), .B(n40), .C(n41), .D(n42), .Y(n21) );
  NAND3X1 U12 ( .A(n22), .B(n48), .C(n23), .Y(n41) );
  NAND2X1 U13 ( .A(n52), .B(n46), .Y(n23) );
  NAND3X1 U14 ( .A(n31), .B(n54), .C(n32), .Y(n25) );
  NAND3X1 U15 ( .A(n50), .B(n28), .C(n51), .Y(n35) );
  NOR2X1 U16 ( .A(n33), .B(n34), .Y(n24) );
  OR2X2 U17 ( .A(n15), .B(n16), .Y(n39) );
  CLKINVX1 U18 ( .A(B[1]), .Y(n46) );
  NOR2X1 U19 ( .A(B[0]), .B(n21), .Y(n17) );
  NOR4X1 U20 ( .A(n17), .B(n18), .C(n19), .D(n20), .Y(LT_LE) );
  NAND3X1 U21 ( .A(n24), .B(n25), .C(n26), .Y(n18) );
  NOR2X1 U22 ( .A(n21), .B(n23), .Y(n19) );
  NOR2X1 U23 ( .A(n21), .B(n22), .Y(n20) );
  CLKINVX1 U24 ( .A(B[2]), .Y(n45) );
  CLKINVX1 U25 ( .A(n35), .Y(n31) );
  NAND2X1 U26 ( .A(B[3]), .B(n49), .Y(n40) );
  NOR2X1 U27 ( .A(n55), .B(n45), .Y(n44) );
  CLKINVX1 U28 ( .A(B[3]), .Y(n32) );
  NAND2X1 U29 ( .A(B[5]), .B(n38), .Y(n50) );
  NAND2X1 U30 ( .A(B[4]), .B(n57), .Y(n51) );
  NOR3X1 U31 ( .A(B[5]), .B(n38), .C(n39), .Y(n33) );
  NOR2X1 U32 ( .A(n35), .B(n36), .Y(n34) );
  NAND2X1 U33 ( .A(n56), .B(n37), .Y(n36) );
  CLKINVX1 U34 ( .A(B[4]), .Y(n37) );
  AOI2BB2X1 U35 ( .A0N(B[7]), .A1N(n29), .B0(n27), .B1(n28), .Y(n26) );
  NOR2X1 U36 ( .A(B[6]), .B(n30), .Y(n27) );
  AND2X1 U37 ( .A(B[7]), .B(n29), .Y(n15) );
  AND2X1 U38 ( .A(B[6]), .B(n30), .Y(n16) );
  CLKINVX1 U39 ( .A(n54), .Y(n49) );
  CLKINVX1 U40 ( .A(A[5]), .Y(n38) );
  CLKINVX1 U41 ( .A(A[7]), .Y(n29) );
  CLKINVX1 U42 ( .A(n57), .Y(n56) );
  CLKINVX1 U43 ( .A(A[4]), .Y(n57) );
  CLKINVX1 U44 ( .A(A[0]), .Y(n48) );
  CLKBUFX2 U45 ( .A(A[3]), .Y(n54) );
  CLKBUFX2 U46 ( .A(A[1]), .Y(n52) );
  CLKBUFX2 U47 ( .A(A[2]), .Y(n55) );
  CLKINVX1 U48 ( .A(n53), .Y(n30) );
  CLKBUFX2 U49 ( .A(A[6]), .Y(n53) );
endmodule


module u_con_DW01_cmp2_8_2 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60;

  NAND2X1 U6 ( .A(n52), .B(n53), .Y(n29) );
  NAND4X2 U7 ( .A(n42), .B(n43), .C(n44), .D(n45), .Y(n17) );
  INVX1 U8 ( .A(n25), .Y(n43) );
  NOR2X1 U9 ( .A(n15), .B(n16), .Y(LT_LE) );
  NAND3X1 U10 ( .A(n18), .B(n19), .C(n20), .Y(n15) );
  NAND2X1 U11 ( .A(n60), .B(n47), .Y(n41) );
  NOR4X1 U12 ( .A(n21), .B(n22), .C(n23), .D(n24), .Y(n20) );
  NOR2X1 U13 ( .A(n25), .B(n26), .Y(n24) );
  NAND3X1 U14 ( .A(n49), .B(n50), .C(n51), .Y(n25) );
  NAND2X1 U15 ( .A(B[5]), .B(n28), .Y(n49) );
  INVX1 U16 ( .A(n29), .Y(n50) );
  NAND2X1 U17 ( .A(n58), .B(n27), .Y(n26) );
  NAND2X1 U18 ( .A(B[6]), .B(n56), .Y(n53) );
  NAND2X1 U19 ( .A(B[7]), .B(n30), .Y(n52) );
  NOR2X1 U20 ( .A(n38), .B(n39), .Y(n18) );
  NOR2X1 U21 ( .A(n17), .B(n41), .Y(n38) );
  NOR2X1 U22 ( .A(n17), .B(n40), .Y(n39) );
  CLKINVX1 U23 ( .A(B[6]), .Y(n37) );
  NAND2X1 U24 ( .A(B[3]), .B(n31), .Y(n42) );
  NAND2X1 U25 ( .A(B[2]), .B(n48), .Y(n44) );
  NAND3X1 U26 ( .A(n41), .B(n46), .C(B[1]), .Y(n45) );
  CLKINVX1 U27 ( .A(n57), .Y(n46) );
  NAND2X1 U28 ( .A(n57), .B(n35), .Y(n34) );
  CLKINVX1 U29 ( .A(B[1]), .Y(n35) );
  NOR2X1 U30 ( .A(n32), .B(n33), .Y(n19) );
  NOR2X1 U31 ( .A(n29), .B(n36), .Y(n32) );
  NOR2X1 U32 ( .A(n17), .B(n34), .Y(n33) );
  NAND2X1 U33 ( .A(n55), .B(n37), .Y(n36) );
  NOR2X1 U34 ( .A(B[0]), .B(n17), .Y(n16) );
  CLKINVX1 U35 ( .A(B[2]), .Y(n47) );
  NOR3X1 U36 ( .A(B[3]), .B(n31), .C(n25), .Y(n21) );
  NOR2X1 U37 ( .A(B[7]), .B(n30), .Y(n22) );
  NOR3X1 U38 ( .A(B[5]), .B(n28), .C(n29), .Y(n23) );
  NAND2X1 U39 ( .A(B[4]), .B(n59), .Y(n51) );
  CLKINVX1 U40 ( .A(B[4]), .Y(n27) );
  CLKINVX1 U41 ( .A(n60), .Y(n48) );
  CLKINVX1 U42 ( .A(A[0]), .Y(n40) );
  CLKINVX1 U43 ( .A(n59), .Y(n58) );
  CLKINVX1 U44 ( .A(A[4]), .Y(n59) );
  CLKINVX1 U45 ( .A(n56), .Y(n55) );
  CLKINVX1 U46 ( .A(A[6]), .Y(n56) );
  CLKINVX1 U47 ( .A(n54), .Y(n30) );
  CLKBUFX2 U48 ( .A(A[7]), .Y(n54) );
  CLKINVX1 U49 ( .A(A[5]), .Y(n28) );
  CLKINVX1 U50 ( .A(A[3]), .Y(n31) );
  CLKBUFX2 U51 ( .A(A[1]), .Y(n57) );
  CLKBUFX2 U52 ( .A(A[2]), .Y(n60) );
endmodule


module u_con_DW01_cmp2_8_3 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54;

  NOR2X1 U6 ( .A(n48), .B(n38), .Y(n40) );
  NAND2X1 U7 ( .A(n48), .B(n38), .Y(n37) );
  NOR2X1 U8 ( .A(n51), .B(n42), .Y(n41) );
  CLKINVX1 U9 ( .A(n54), .Y(n42) );
  CLKINVX1 U10 ( .A(n51), .Y(n45) );
  OAI2BB1X1 U11 ( .A0N(B[7]), .A1N(n15), .B0(n16), .Y(LT_LE) );
  OAI21X1 U12 ( .A0(n47), .A1(n32), .B0(n33), .Y(n31) );
  CLKINVX1 U13 ( .A(A[3]), .Y(n32) );
  NAND2X1 U14 ( .A(A[4]), .B(n50), .Y(n33) );
  CLKINVX1 U15 ( .A(A[2]), .Y(n38) );
  NOR2X1 U16 ( .A(n43), .B(n44), .Y(n39) );
  NOR2X1 U17 ( .A(n54), .B(n45), .Y(n44) );
  CLKINVX1 U18 ( .A(B[0]), .Y(n46) );
  NOR2X1 U19 ( .A(n25), .B(n26), .Y(n20) );
  OAI21X1 U20 ( .A0(A[5]), .A1(n27), .B0(n28), .Y(n26) );
  NOR2X1 U21 ( .A(n30), .B(n31), .Y(n25) );
  CLKINVX1 U22 ( .A(n52), .Y(n27) );
  NOR2X1 U23 ( .A(n34), .B(n35), .Y(n30) );
  OAI21X1 U24 ( .A0(A[3]), .A1(n36), .B0(n37), .Y(n35) );
  NOR3X1 U25 ( .A(n39), .B(n40), .C(n41), .Y(n34) );
  CLKINVX1 U26 ( .A(n47), .Y(n36) );
  CLKINVX1 U27 ( .A(B[6]), .Y(n24) );
  CLKINVX1 U28 ( .A(A[7]), .Y(n15) );
  CLKBUFX2 U29 ( .A(A[1]), .Y(n54) );
  OAI2BB2X1 U30 ( .A0N(A[7]), .A1N(n19), .B0(n17), .B1(n18), .Y(n16) );
  CLKINVX1 U31 ( .A(B[7]), .Y(n19) );
  NOR2X1 U32 ( .A(n53), .B(n24), .Y(n17) );
  NOR2X1 U33 ( .A(n20), .B(n21), .Y(n18) );
  CLKINVX1 U34 ( .A(n50), .Y(n49) );
  CLKINVX1 U35 ( .A(B[4]), .Y(n50) );
  CLKBUFX2 U36 ( .A(A[6]), .Y(n53) );
  NAND2X1 U37 ( .A(n49), .B(n29), .Y(n28) );
  CLKINVX1 U38 ( .A(A[4]), .Y(n29) );
  CLKBUFX2 U39 ( .A(B[1]), .Y(n51) );
  OAI21X1 U40 ( .A0(n52), .A1(n22), .B0(n23), .Y(n21) );
  CLKINVX1 U41 ( .A(A[5]), .Y(n22) );
  NAND2X1 U42 ( .A(n53), .B(n24), .Y(n23) );
  CLKBUFX2 U43 ( .A(B[2]), .Y(n48) );
  CLKBUFX2 U44 ( .A(B[3]), .Y(n47) );
  CLKBUFX2 U45 ( .A(B[5]), .Y(n52) );
  NOR2X1 U46 ( .A(A[0]), .B(n46), .Y(n43) );
endmodule


module u_con_DW01_cmp2_8_4 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53;

  INVX1 U6 ( .A(n34), .Y(n37) );
  NAND3X1 U7 ( .A(n23), .B(n52), .C(n43), .Y(n41) );
  NAND4X1 U8 ( .A(n40), .B(n37), .C(n41), .D(n42), .Y(n22) );
  NOR2X1 U9 ( .A(n22), .B(n39), .Y(n18) );
  NOR2X1 U10 ( .A(n50), .B(n51), .Y(n40) );
  NAND3X1 U11 ( .A(n45), .B(n29), .C(n46), .Y(n34) );
  NAND2X1 U12 ( .A(B[5]), .B(n31), .Y(n45) );
  NAND2X1 U13 ( .A(B[4]), .B(n47), .Y(n46) );
  NAND2X1 U14 ( .A(A[4]), .B(n36), .Y(n35) );
  CLKINVX1 U15 ( .A(B[4]), .Y(n36) );
  AND3X2 U16 ( .A(n15), .B(n16), .C(n17), .Y(n26) );
  OR2X2 U17 ( .A(n34), .B(n35), .Y(n15) );
  NAND2X1 U18 ( .A(n28), .B(n29), .Y(n27) );
  NAND2X1 U19 ( .A(n48), .B(n49), .Y(n32) );
  NAND2X1 U20 ( .A(B[7]), .B(n33), .Y(n48) );
  NAND2X1 U21 ( .A(B[6]), .B(n30), .Y(n49) );
  CLKINVX1 U22 ( .A(A[1]), .Y(n43) );
  CLKINVX1 U23 ( .A(A[6]), .Y(n30) );
  CLKINVX1 U24 ( .A(A[7]), .Y(n33) );
  CLKINVX1 U25 ( .A(A[5]), .Y(n31) );
  NAND2X1 U26 ( .A(A[1]), .B(n53), .Y(n24) );
  NOR4X1 U27 ( .A(n18), .B(n19), .C(n20), .D(n21), .Y(LT_LE) );
  NAND3X1 U28 ( .A(n25), .B(n26), .C(n27), .Y(n19) );
  NOR2X1 U29 ( .A(n22), .B(n24), .Y(n20) );
  NOR2X1 U30 ( .A(n22), .B(n23), .Y(n21) );
  CLKINVX1 U31 ( .A(A[0]), .Y(n39) );
  NAND2X1 U32 ( .A(A[2]), .B(n44), .Y(n23) );
  NOR2X1 U33 ( .A(A[2]), .B(n44), .Y(n51) );
  NOR2X1 U34 ( .A(A[3]), .B(n38), .Y(n50) );
  NAND3X1 U35 ( .A(n37), .B(n38), .C(A[3]), .Y(n25) );
  CLKINVX1 U36 ( .A(n32), .Y(n29) );
  CLKINVX1 U37 ( .A(A[4]), .Y(n47) );
  OR2X2 U38 ( .A(B[7]), .B(n33), .Y(n16) );
  OR3X2 U39 ( .A(n31), .B(B[5]), .C(n32), .Y(n17) );
  NOR2X1 U40 ( .A(B[6]), .B(n30), .Y(n28) );
  CLKINVX1 U41 ( .A(n53), .Y(n52) );
  CLKINVX1 U42 ( .A(B[1]), .Y(n53) );
  CLKINVX1 U43 ( .A(B[2]), .Y(n44) );
  CLKINVX1 U44 ( .A(B[3]), .Y(n38) );
  NAND3X1 U45 ( .A(n23), .B(B[0]), .C(n24), .Y(n42) );
endmodule


module u_con_DW01_cmp2_8_5 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51;

  NOR2X1 U6 ( .A(n44), .B(n42), .Y(n41) );
  CLKINVX1 U7 ( .A(n50), .Y(n42) );
  OAI21X1 U8 ( .A0(n49), .A1(n26), .B0(n27), .Y(n25) );
  NAND2X1 U9 ( .A(B[4]), .B(n48), .Y(n27) );
  CLKINVX1 U10 ( .A(B[5]), .Y(n26) );
  OAI21X1 U11 ( .A0(n46), .A1(n35), .B0(n36), .Y(n34) );
  CLKINVX1 U12 ( .A(B[3]), .Y(n35) );
  NAND2X1 U13 ( .A(n51), .B(n37), .Y(n36) );
  NOR3X1 U14 ( .A(n38), .B(n39), .C(n40), .Y(n33) );
  NOR2X1 U15 ( .A(n51), .B(n37), .Y(n39) );
  NOR2X1 U16 ( .A(n50), .B(n45), .Y(n40) );
  CLKINVX1 U17 ( .A(B[6]), .Y(n23) );
  OAI2BB1X1 U18 ( .A0N(B[7]), .A1N(n15), .B0(n16), .Y(LT_LE) );
  OAI22X1 U19 ( .A0(n17), .A1(n18), .B0(B[7]), .B1(n15), .Y(n16) );
  CLKINVX1 U20 ( .A(A[7]), .Y(n15) );
  NOR2X1 U21 ( .A(A[6]), .B(n23), .Y(n17) );
  NOR2X1 U22 ( .A(n28), .B(n29), .Y(n24) );
  OAI21X1 U23 ( .A0(B[3]), .A1(n30), .B0(n31), .Y(n29) );
  NOR2X1 U24 ( .A(n33), .B(n34), .Y(n28) );
  CLKINVX1 U25 ( .A(n46), .Y(n30) );
  NAND2X1 U26 ( .A(A[6]), .B(n23), .Y(n22) );
  CLKINVX1 U27 ( .A(A[2]), .Y(n37) );
  NOR2X1 U28 ( .A(n19), .B(n20), .Y(n18) );
  OAI21X1 U29 ( .A0(B[5]), .A1(n21), .B0(n22), .Y(n20) );
  NOR2X1 U30 ( .A(n24), .B(n25), .Y(n19) );
  CLKINVX1 U31 ( .A(n49), .Y(n21) );
  CLKBUFX2 U32 ( .A(B[1]), .Y(n50) );
  CLKBUFX2 U33 ( .A(B[2]), .Y(n51) );
  CLKINVX1 U34 ( .A(n45), .Y(n44) );
  CLKINVX1 U35 ( .A(A[1]), .Y(n45) );
  CLKINVX1 U36 ( .A(n48), .Y(n47) );
  CLKINVX1 U37 ( .A(A[4]), .Y(n48) );
  NAND2X1 U38 ( .A(n47), .B(n32), .Y(n31) );
  CLKINVX1 U39 ( .A(B[4]), .Y(n32) );
  CLKBUFX2 U40 ( .A(A[3]), .Y(n46) );
  CLKBUFX2 U41 ( .A(A[5]), .Y(n49) );
  CLKINVX1 U42 ( .A(A[0]), .Y(n43) );
  NOR3X1 U43 ( .A(n41), .B(B[0]), .C(n43), .Y(n38) );
endmodule


module one_shot_3 ( rst_p, clk, d, q );
  input rst_p, clk, d;
  output q;
  wire   n1, n2, n3;

  CLKINVX1 U6 ( .A(d), .Y(n3) );
  NOR2BX1 U7 ( .AN(d), .B(n2), .Y(q) );
  CLKINVX1 U8 ( .A(rst_p), .Y(n1) );
  DFFSX2 d_del_reg ( .D(n3), .CK(clk), .SN(n1), .QN(n2) );
endmodule

