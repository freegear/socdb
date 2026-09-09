
module rc8051RtlTop ( clk, rst_p, int0_i, int1_i, all_t0_i, all_t1_i, 
        all_rxd_i, p1_i, p1_o, p1_en, all_txd_o, clkb, rom_adr_o, rom_data_i, 
        addr_xdat, out_xdat, in_xdat_a, en_xdat, wr_xdat_d1, rd_xdat, BistMode, 
        BistFail, Finish, ErrMap );
  input [7:0] p1_i;
  output [7:0] p1_o;
  output [7:0] p1_en;
  output [15:0] rom_adr_o;
  input [7:0] rom_data_i;
  output [15:0] addr_xdat;
  output [7:0] out_xdat;
  input [7:0] in_xdat_a;
  input clk, rst_p, int0_i, int1_i, all_t0_i, all_t1_i, all_rxd_i, BistMode;
  output all_txd_o, clkb, en_xdat, wr_xdat_d1, rd_xdat, BistFail, Finish,
         ErrMap;
  wire   clk0, rst_p0, n98, n99, n100, n101, n102, n103, n104, n105, n106,
         n107, n108, n109, n110, clkb0, n144, n145, n146, n147, n148, n149,
         n150, n151, n176, n177, n178, n179, n180, n181, n182, n183, n187,
         ale_d1, ale, wr_xdat, wr_idat, rd_idat, idat_en, n65, n454, n455,
         n456, n457, n458, n459, n460, n461, n462, n463, n464, n465, n466,
         n467, n468, n469, n470, n471, n472, n473, n474, n475, n476, n477,
         n478, n479, n480, n481, n482, n483, n484, n485, n486, n487, n488,
         n489, n490, n491, n492, n493, n494, n495, n496, n497, n498, n499,
         n500, n501, n502, n503, n504, n505, n506, n507, n508, n509, n510,
         n511, n512, n513, n514, n515, n516, n285, n286, n287, n288, n289,
         n290, n291, n292, n293, n294, n358, n359, n360;
  wire   [7:0] xaddr_low;
  wire   [7:0] xaddr_high;
  wire   [7:0] in_idat_a;
  wire   [7:0] p0_i;
  wire   [7:0] p2_i;
  wire   [7:0] p3_i;
  wire   [7:0] addr_a;
  wire   [7:0] out_idat;

  u_cpu U3_cpu ( .clk(clk0), .rst_p(rst_p0), .in_xrom_a({n144, n145, n146, 
        n147, n148, n149, n150, n151}), .in_idat_a(in_idat_a), .in_xdat_a({
        n176, n177, n178, n179, n180, n181, n182, n183}), .p0_in({1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .p1_in({n103, n104, n105, n106, 
        n107, n108, n109, n110}), .p2_in({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0}), .p3_in({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .rxdi(n102), .t0_pin(n100), .t1_pin(n101), .int0_pin(n98), .int1_pin(
        n99), .addr_xrom_a({n471, n472, n473, n474, n475, n476, n477, n478, 
        n479, n480, n481, n482, n483, n484, n485, n486}), .addr_a(addr_a), 
        .out_idat(out_idat), .wr_idat(wr_idat), .rd_idat(rd_idat), 
        .xaddr_high(xaddr_high), .out_xdat({n503, n504, n505, n506, n507, n508, 
        n509, n510}), .ale(ale), .p1_out({n454, n455, n456, n457, n458, n459, 
        n460, n461}), .p1_en({n462, n463, n464, n465, n466, n467, n468, n469}), 
        .wr_xdat(wr_xdat), .rd_xdat(n513), .txdo(n470) );
  Bisted_SPSRAM256X8 uBisted_SPSRAM256X8 ( .CLK(clkb0), .CEN(idat_en), .WEN(
        wr_idat), .Q(in_idat_a), .D(out_idat), .A(addr_a), .BistMode(n187), 
        .BistFail(n514), .Finish(n515), .ErrMap(n516) );
  PDO02CDG U66 ( .I(n65), .PAD(clkb) );
  CLKINVX1 U67 ( .A(clk0), .Y(n65) );
  PDISDGZ U98 ( .PAD(rst_p), .C(rst_p0) );
  PDISDGZ U99 ( .PAD(clk), .C(clk0) );
  CLKINVX1 U206 ( .A(rd_idat), .Y(n359) );
  CLKINVX1 U207 ( .A(wr_idat), .Y(n360) );
  AND2X2 U208 ( .A(wr_xdat), .B(n513), .Y(n286) );
  DFFRX1 ale_d1_reg ( .D(ale), .CK(clk0), .RN(n285), .Q(ale_d1), .QN(n358) );
  NOR2X1 U209 ( .A(n359), .B(n360), .Y(idat_en) );
  AO22X1 U210 ( .A0(n510), .A1(ale_d1), .B0(xaddr_low[0]), .B1(n358), .Y(n287)
         );
  AO22X1 U211 ( .A0(n509), .A1(ale_d1), .B0(xaddr_low[1]), .B1(n358), .Y(n288)
         );
  AO22X1 U212 ( .A0(n508), .A1(ale_d1), .B0(xaddr_low[2]), .B1(n358), .Y(n289)
         );
  AO22X1 U213 ( .A0(n507), .A1(ale_d1), .B0(xaddr_low[3]), .B1(n358), .Y(n290)
         );
  AO22X1 U214 ( .A0(n506), .A1(ale_d1), .B0(xaddr_low[4]), .B1(n358), .Y(n291)
         );
  AO22X1 U215 ( .A0(n505), .A1(ale_d1), .B0(xaddr_low[5]), .B1(n358), .Y(n292)
         );
  AO22X1 U216 ( .A0(n504), .A1(ale_d1), .B0(xaddr_low[6]), .B1(n358), .Y(n293)
         );
  AO22X1 U217 ( .A0(n503), .A1(ale_d1), .B0(xaddr_low[7]), .B1(n358), .Y(n294)
         );
  INVX3 U218 ( .A(clk0), .Y(clkb0) );
  CLKINVX2 U219 ( .A(rst_p0), .Y(n285) );
  DFFSX1 en_xdat_reg ( .D(n286), .CK(clk0), .SN(n285), .Q(n511) );
  DFFSX1 wr_xdat_d1_reg ( .D(wr_xdat), .CK(clk0), .SN(n285), .Q(n512) );
  DFFRX1 addr_xdat_reg_0_ ( .D(xaddr_low[0]), .CK(clk0), .RN(n285), .Q(n502)
         );
  DFFRX1 addr_xdat_reg_1_ ( .D(xaddr_low[1]), .CK(clk0), .RN(n285), .Q(n501)
         );
  DFFRX1 addr_xdat_reg_2_ ( .D(xaddr_low[2]), .CK(clk0), .RN(n285), .Q(n500)
         );
  DFFRX1 addr_xdat_reg_3_ ( .D(xaddr_low[3]), .CK(clk0), .RN(n285), .Q(n499)
         );
  DFFRX1 addr_xdat_reg_4_ ( .D(xaddr_low[4]), .CK(clk0), .RN(n285), .Q(n498)
         );
  DFFRX1 addr_xdat_reg_5_ ( .D(xaddr_low[5]), .CK(clk0), .RN(n285), .Q(n497)
         );
  DFFRX1 addr_xdat_reg_6_ ( .D(xaddr_low[6]), .CK(clk0), .RN(n285), .Q(n496)
         );
  DFFRX1 addr_xdat_reg_7_ ( .D(xaddr_low[7]), .CK(clk0), .RN(n285), .Q(n495)
         );
  DFFRX1 addr_xdat_reg_8_ ( .D(xaddr_high[0]), .CK(clk0), .RN(n285), .Q(n494)
         );
  DFFRX1 addr_xdat_reg_9_ ( .D(xaddr_high[1]), .CK(clk0), .RN(n285), .Q(n493)
         );
  DFFRX1 addr_xdat_reg_10_ ( .D(xaddr_high[2]), .CK(clk0), .RN(n285), .Q(n492)
         );
  DFFRX1 addr_xdat_reg_11_ ( .D(xaddr_high[3]), .CK(clk0), .RN(n285), .Q(n491)
         );
  DFFRX1 addr_xdat_reg_12_ ( .D(xaddr_high[4]), .CK(clk0), .RN(n285), .Q(n490)
         );
  DFFRX1 addr_xdat_reg_13_ ( .D(xaddr_high[5]), .CK(clk0), .RN(n285), .Q(n489)
         );
  DFFRX1 addr_xdat_reg_14_ ( .D(xaddr_high[6]), .CK(clk0), .RN(n285), .Q(n488)
         );
  DFFRX1 addr_xdat_reg_15_ ( .D(xaddr_high[7]), .CK(clk0), .RN(n285), .Q(n487)
         );
  DFFRX1 xaddr_low_reg_0_ ( .D(n287), .CK(clk0), .RN(n285), .Q(xaddr_low[0])
         );
  DFFRX1 xaddr_low_reg_1_ ( .D(n288), .CK(clk0), .RN(n285), .Q(xaddr_low[1])
         );
  DFFRX1 xaddr_low_reg_2_ ( .D(n289), .CK(clk0), .RN(n285), .Q(xaddr_low[2])
         );
  DFFRX1 xaddr_low_reg_3_ ( .D(n290), .CK(clk0), .RN(n285), .Q(xaddr_low[3])
         );
  DFFRX1 xaddr_low_reg_4_ ( .D(n291), .CK(clk0), .RN(n285), .Q(xaddr_low[4])
         );
  DFFRX1 xaddr_low_reg_5_ ( .D(n292), .CK(clk0), .RN(n285), .Q(xaddr_low[5])
         );
  DFFRX1 xaddr_low_reg_6_ ( .D(n293), .CK(clk0), .RN(n285), .Q(xaddr_low[6])
         );
  DFFRX1 xaddr_low_reg_7_ ( .D(n294), .CK(clk0), .RN(n285), .Q(xaddr_low[7])
         );
  PDISDGZ U220 ( .PAD(int0_i), .C(n98) );
  PDISDGZ U221 ( .PAD(int1_i), .C(n99) );
  PDISDGZ U222 ( .PAD(all_t0_i), .C(n100) );
  PDISDGZ U223 ( .PAD(all_t1_i), .C(n101) );
  PDISDGZ U224 ( .PAD(all_rxd_i), .C(n102) );
  PDISDGZ U225 ( .PAD(p1_i[7]), .C(n103) );
  PDISDGZ U226 ( .PAD(p1_i[6]), .C(n104) );
  PDISDGZ U227 ( .PAD(p1_i[5]), .C(n105) );
  PDISDGZ U228 ( .PAD(p1_i[4]), .C(n106) );
  PDISDGZ U229 ( .PAD(p1_i[3]), .C(n107) );
  PDISDGZ U230 ( .PAD(p1_i[2]), .C(n108) );
  PDISDGZ U231 ( .PAD(p1_i[1]), .C(n109) );
  PDISDGZ U232 ( .PAD(p1_i[0]), .C(n110) );
  PDO08CDG U233 ( .I(n454), .PAD(p1_o[7]) );
  PDO08CDG U234 ( .I(n455), .PAD(p1_o[6]) );
  PDO08CDG U235 ( .I(n456), .PAD(p1_o[5]) );
  PDO08CDG U236 ( .I(n457), .PAD(p1_o[4]) );
  PDO08CDG U237 ( .I(n458), .PAD(p1_o[3]) );
  PDO08CDG U238 ( .I(n459), .PAD(p1_o[2]) );
  PDO08CDG U239 ( .I(n460), .PAD(p1_o[1]) );
  PDO08CDG U240 ( .I(n461), .PAD(p1_o[0]) );
  PDO08CDG U241 ( .I(n462), .PAD(p1_en[7]) );
  PDO08CDG U242 ( .I(n463), .PAD(p1_en[6]) );
  PDO08CDG U243 ( .I(n464), .PAD(p1_en[5]) );
  PDO08CDG U244 ( .I(n465), .PAD(p1_en[4]) );
  PDO08CDG U245 ( .I(n466), .PAD(p1_en[3]) );
  PDO08CDG U246 ( .I(n467), .PAD(p1_en[2]) );
  PDO08CDG U247 ( .I(n468), .PAD(p1_en[1]) );
  PDO08CDG U248 ( .I(n469), .PAD(p1_en[0]) );
  PDO08CDG U249 ( .I(n470), .PAD(all_txd_o) );
  PDO08CDG U250 ( .I(n471), .PAD(rom_adr_o[15]) );
  PDO08CDG U251 ( .I(n472), .PAD(rom_adr_o[14]) );
  PDO08CDG U252 ( .I(n473), .PAD(rom_adr_o[13]) );
  PDO08CDG U253 ( .I(n474), .PAD(rom_adr_o[12]) );
  PDO08CDG U254 ( .I(n475), .PAD(rom_adr_o[11]) );
  PDO08CDG U255 ( .I(n476), .PAD(rom_adr_o[10]) );
  PDO08CDG U256 ( .I(n477), .PAD(rom_adr_o[9]) );
  PDO08CDG U257 ( .I(n478), .PAD(rom_adr_o[8]) );
  PDO08CDG U258 ( .I(n479), .PAD(rom_adr_o[7]) );
  PDO08CDG U259 ( .I(n480), .PAD(rom_adr_o[6]) );
  PDO08CDG U260 ( .I(n481), .PAD(rom_adr_o[5]) );
  PDO08CDG U261 ( .I(n482), .PAD(rom_adr_o[4]) );
  PDO08CDG U262 ( .I(n483), .PAD(rom_adr_o[3]) );
  PDO08CDG U263 ( .I(n484), .PAD(rom_adr_o[2]) );
  PDO08CDG U264 ( .I(n485), .PAD(rom_adr_o[1]) );
  PDO08CDG U265 ( .I(n486), .PAD(rom_adr_o[0]) );
  PDISDGZ U266 ( .PAD(rom_data_i[7]), .C(n144) );
  PDISDGZ U267 ( .PAD(rom_data_i[6]), .C(n145) );
  PDISDGZ U268 ( .PAD(rom_data_i[5]), .C(n146) );
  PDISDGZ U269 ( .PAD(rom_data_i[4]), .C(n147) );
  PDISDGZ U270 ( .PAD(rom_data_i[3]), .C(n148) );
  PDISDGZ U271 ( .PAD(rom_data_i[2]), .C(n149) );
  PDISDGZ U272 ( .PAD(rom_data_i[1]), .C(n150) );
  PDISDGZ U273 ( .PAD(rom_data_i[0]), .C(n151) );
  PDO08CDG U274 ( .I(n487), .PAD(addr_xdat[15]) );
  PDO08CDG U275 ( .I(n488), .PAD(addr_xdat[14]) );
  PDO08CDG U276 ( .I(n489), .PAD(addr_xdat[13]) );
  PDO08CDG U277 ( .I(n490), .PAD(addr_xdat[12]) );
  PDO08CDG U278 ( .I(n491), .PAD(addr_xdat[11]) );
  PDO08CDG U279 ( .I(n492), .PAD(addr_xdat[10]) );
  PDO08CDG U280 ( .I(n493), .PAD(addr_xdat[9]) );
  PDO08CDG U281 ( .I(n494), .PAD(addr_xdat[8]) );
  PDO08CDG U282 ( .I(n495), .PAD(addr_xdat[7]) );
  PDO08CDG U283 ( .I(n496), .PAD(addr_xdat[6]) );
  PDO08CDG U284 ( .I(n497), .PAD(addr_xdat[5]) );
  PDO08CDG U285 ( .I(n498), .PAD(addr_xdat[4]) );
  PDO08CDG U286 ( .I(n499), .PAD(addr_xdat[3]) );
  PDO08CDG U287 ( .I(n500), .PAD(addr_xdat[2]) );
  PDO08CDG U288 ( .I(n501), .PAD(addr_xdat[1]) );
  PDO08CDG U289 ( .I(n502), .PAD(addr_xdat[0]) );
  PDO08CDG U290 ( .I(n503), .PAD(out_xdat[7]) );
  PDO08CDG U291 ( .I(n504), .PAD(out_xdat[6]) );
  PDO08CDG U292 ( .I(n505), .PAD(out_xdat[5]) );
  PDO08CDG U293 ( .I(n506), .PAD(out_xdat[4]) );
  PDO08CDG U294 ( .I(n507), .PAD(out_xdat[3]) );
  PDO08CDG U295 ( .I(n508), .PAD(out_xdat[2]) );
  PDO08CDG U296 ( .I(n509), .PAD(out_xdat[1]) );
  PDO08CDG U297 ( .I(n510), .PAD(out_xdat[0]) );
  PDISDGZ U298 ( .PAD(in_xdat_a[7]), .C(n176) );
  PDISDGZ U299 ( .PAD(in_xdat_a[6]), .C(n177) );
  PDISDGZ U300 ( .PAD(in_xdat_a[5]), .C(n178) );
  PDISDGZ U301 ( .PAD(in_xdat_a[4]), .C(n179) );
  PDISDGZ U302 ( .PAD(in_xdat_a[3]), .C(n180) );
  PDISDGZ U303 ( .PAD(in_xdat_a[2]), .C(n181) );
  PDISDGZ U304 ( .PAD(in_xdat_a[1]), .C(n182) );
  PDISDGZ U305 ( .PAD(in_xdat_a[0]), .C(n183) );
  PDO08CDG U306 ( .I(n511), .PAD(en_xdat) );
  PDO08CDG U307 ( .I(n512), .PAD(wr_xdat_d1) );
  PDO08CDG U308 ( .I(n513), .PAD(rd_xdat) );
  PDISDGZ U309 ( .PAD(BistMode), .C(n187) );
  PDO08CDG U310 ( .I(n514), .PAD(BistFail) );
  PDO08CDG U311 ( .I(n515), .PAD(Finish) );
  PDO08CDG U312 ( .I(n516), .PAD(ErrMap) );
endmodule


module Bisted_SPSRAM256X8 ( CLK, CEN, WEN, Q, D, A, BistMode, BistFail, Finish, 
        ErrMap );
  output [7:0] Q;
  input [7:0] D;
  input [7:0] A;
  input CLK, CEN, WEN, BistMode;
  output BistFail, Finish, ErrMap;
  wire   n1, n2;
  wire   [1:0] mem_ctrl_n;
  wire   [16:0] bist_ctrl_n;
  wire   SYNOPSYS_UNCONNECTED__0;

  BistCtrl_SPSRAM256X8 BistCtrl_i0 ( .Tclk(CLK), .BistMode(BistMode), 
        .mem_ctrl({SYNOPSYS_UNCONNECTED__0, mem_ctrl_n[0]}), .Q_i(Q), 
        .bist_ctrl(bist_ctrl_n), .BistFail(BistFail), .ErrMap(ErrMap), 
        .Finish(Finish) );
  SPSRAM256X8_wrapper_SPSRAM256X8 WRAPPED_RAM_i0 ( .CLK(CLK), .CEN(CEN), .WEN(
        WEN), .Q(Q), .D(D), .A({n2, A[6:1], n1}), .mem_ctrl({1'b0, 
        mem_ctrl_n[0]}), .bist_ctrl(bist_ctrl_n) );
  BUFX2 U1 ( .A(A[7]), .Y(n2) );
  CLKBUFX2 U3 ( .A(A[0]), .Y(n1) );
endmodule


module SPSRAM256X8_wrapper_SPSRAM256X8 ( CLK, CEN, WEN, Q, D, A, mem_ctrl, 
        bist_ctrl );
  output [7:0] Q;
  input [7:0] D;
  input [7:0] A;
  input [1:0] mem_ctrl;
  input [16:0] bist_ctrl;
  input CLK, CEN, WEN;
  wire   CEN_n, WEN_n, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28;
  wire   [7:0] D_n;
  wire   [7:0] A_n;

  SPSRAM256X8 SRAM_i0 ( .Q(Q), .CLK(CLK), .CEN(CEN_n), .WEN(WEN_n), .A(A_n), 
        .D(D_n) );
  MX2X1 U26 ( .S0(n27), .B(bist_ctrl[2]), .A(A[2]), .Y(A_n[2]) );
  CLKINVX1 U27 ( .A(bist_ctrl[16]), .Y(n28) );
  CLKMX2X2 U28 ( .S0(n26), .B(bist_ctrl[0]), .A(A[0]), .Y(A_n[0]) );
  CLKMX2X2 U29 ( .S0(n27), .B(bist_ctrl[4]), .A(A[4]), .Y(A_n[4]) );
  MXI2X2 U30 ( .S0(n27), .B(n24), .A(n23), .Y(A_n[5]) );
  CLKINVX1 U31 ( .A(D[6]), .Y(n7) );
  CLKINVX1 U32 ( .A(D[4]), .Y(n11) );
  CLKINVX1 U33 ( .A(D[3]), .Y(n13) );
  INVX1 U34 ( .A(D[1]), .Y(n17) );
  INVX4 U35 ( .A(D[5]), .Y(n9) );
  CLKINVX4 U36 ( .A(D[7]), .Y(n5) );
  INVX1 U37 ( .A(D[2]), .Y(n15) );
  INVX1 U38 ( .A(D[0]), .Y(n19) );
  CLKMX2X2 U39 ( .S0(n25), .B(bist_ctrl[7]), .A(A[7]), .Y(A_n[7]) );
  INVX1 U40 ( .A(n28), .Y(n27) );
  INVX1 U41 ( .A(n28), .Y(n25) );
  INVX1 U42 ( .A(n28), .Y(n26) );
  MXI2X1 U43 ( .S0(n26), .B(n6), .A(n5), .Y(D_n[7]) );
  INVX1 U44 ( .A(bist_ctrl[15]), .Y(n6) );
  MXI2X1 U45 ( .S0(n25), .B(n8), .A(n7), .Y(D_n[6]) );
  INVX1 U46 ( .A(bist_ctrl[14]), .Y(n8) );
  MXI2X1 U47 ( .S0(n25), .B(n12), .A(n11), .Y(D_n[4]) );
  INVX1 U48 ( .A(bist_ctrl[12]), .Y(n12) );
  MXI2X1 U49 ( .S0(n26), .B(n10), .A(n9), .Y(D_n[5]) );
  INVX1 U50 ( .A(bist_ctrl[13]), .Y(n10) );
  MXI2X1 U51 ( .S0(n26), .B(n14), .A(n13), .Y(D_n[3]) );
  INVX1 U52 ( .A(bist_ctrl[11]), .Y(n14) );
  MXI2X1 U53 ( .S0(n25), .B(n16), .A(n15), .Y(D_n[2]) );
  INVX1 U54 ( .A(bist_ctrl[10]), .Y(n16) );
  MXI2X1 U55 ( .S0(n26), .B(n18), .A(n17), .Y(D_n[1]) );
  CLKINVX1 U56 ( .A(bist_ctrl[9]), .Y(n18) );
  MXI2X1 U57 ( .S0(n25), .B(n20), .A(n19), .Y(D_n[0]) );
  CLKINVX1 U58 ( .A(bist_ctrl[8]), .Y(n20) );
  MXI2X1 U59 ( .S0(n25), .B(n4), .A(n3), .Y(WEN_n) );
  CLKINVX1 U60 ( .A(mem_ctrl[0]), .Y(n4) );
  INVX1 U61 ( .A(WEN), .Y(n3) );
  MX2X1 U62 ( .S0(n27), .B(bist_ctrl[6]), .A(A[6]), .Y(A_n[6]) );
  MX2X1 U63 ( .S0(n27), .B(bist_ctrl[1]), .A(A[1]), .Y(A_n[1]) );
  CLKINVX1 U64 ( .A(bist_ctrl[5]), .Y(n24) );
  MX2X1 U65 ( .S0(n27), .B(bist_ctrl[3]), .A(A[3]), .Y(A_n[3]) );
  MXI2X1 U66 ( .S0(n26), .B(n22), .A(n21), .Y(CEN_n) );
  CLKINVX1 U67 ( .A(mem_ctrl[1]), .Y(n22) );
  CLKINVX1 U68 ( .A(CEN), .Y(n21) );
  INVX1 U69 ( .A(A[5]), .Y(n23) );
endmodule


module BistCtrl_SPSRAM256X8 ( Tclk, BistMode, mem_ctrl, Q_i, bist_ctrl, 
        BistFail, ErrMap, Finish );
  output [1:0] mem_ctrl;
  input [7:0] Q_i;
  output [16:0] bist_ctrl;
  input Tclk, BistMode;
  output BistFail, ErrMap, Finish;
  wire   S41, S45, S46, S44, S42, S43, S47, n3;

  ST_MAG_SPSRAM256X8 S48 ( .Tclk(Tclk), .BistMode(BistMode), .S0(
        bist_ctrl[7:0]), .S1(S41), .S2(S45), .S3(S46), .S4(S44) );
  ST_MPG_SPSRAM256X8 ST_MPG_i0 ( .S7(bist_ctrl[15:8]), .S8(S42), .S9(S43) );
  ST_MAL_SPSRAM256X8 ST_MAL_i0 ( .Tclk(Tclk), .BistMode(BistMode), .BistFail(
        BistFail), .S12(S47), .S13(bist_ctrl[15:8]), .S14(Q_i), .ErrMap(ErrMap) );
  ST_MTC_SPSRAM256X8 S49 ( .Tclk(Tclk), .S19(mem_ctrl[0]), .S4(S44), .S2(S45), 
        .S3(S46), .S1(S41), .S8(S42), .S9(S43), .BistMode(BistMode), .S12(S47), 
        .Finish(Finish) );
  CLKINVX1 U1 ( .A(1'b1), .Y(mem_ctrl[1]) );
  CLKINVX1 U3 ( .A(BistMode), .Y(n3) );
  INVX1 U4 ( .A(n3), .Y(bist_ctrl[16]) );
endmodule


module ST_MTC_SPSRAM256X8 ( Tclk, S18, S19, S4, S2, S3, S1, S8, S9, BistMode, 
        S12, Finish );
  input Tclk, S2, S3, BistMode;
  output S18, S19, S4, S1, S8, S9, S12, Finish;
  wire   N19, n2, n3, n4, n5, n7, n8, n11, n12, n13, n14, n16, n17, n18, n190,
         n20, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n69, n70, n71, n72, n73, n76, n77, n78, n79, n80, n81,
         n82;
  wire   [3:0] State;

  CLKINVX1 U81 ( .A(1'b1), .Y(S18) );
  INVX1 U83 ( .A(BistMode), .Y(n7) );
  NAND3BX1 U84 ( .AN(State[3]), .B(State[2]), .C(n36), .Y(n26) );
  CLKINVX1 U85 ( .A(n24), .Y(n2) );
  DFFX1 State_reg_1_ ( .D(n71), .CK(N19), .Q(State[1]), .QN(n77) );
  DFFX1 State_reg_3_ ( .D(n73), .CK(N19), .Q(State[3]), .QN(n79) );
  CLKINVX1 U86 ( .A(n42), .Y(n190) );
  CLKINVX1 U87 ( .A(n32), .Y(n57) );
  NAND2BX1 U88 ( .AN(n7), .B(n59), .Y(n24) );
  NAND2BX1 U89 ( .AN(n78), .B(n2), .Y(n11) );
  NAND2BX1 U90 ( .AN(n79), .B(n17), .Y(n31) );
  NAND2BX1 U91 ( .AN(n82), .B(n79), .Y(n42) );
  NAND2BX1 U92 ( .AN(n76), .B(n190), .Y(n32) );
  NAND3BX1 U93 ( .AN(n30), .B(n45), .C(n46), .Y(S9) );
  CLKINVX1 U94 ( .A(n26), .Y(n18) );
  CLKINVX1 U95 ( .A(n62), .Y(n46) );
  NAND3BX1 U96 ( .AN(n18), .B(n31), .C(n52), .Y(n62) );
  CLKINVX1 U97 ( .A(n64), .Y(n17) );
  CLKINVX1 U98 ( .A(n44), .Y(n34) );
  CLKINVX1 U99 ( .A(n47), .Y(n30) );
  CLKINVX1 U100 ( .A(n63), .Y(n36) );
  AND4X1 U101 ( .A(n55), .B(n45), .C(n56), .D(n35), .Y(S19) );
  NAND2BX1 U102 ( .AN(n77), .B(n57), .Y(n35) );
  NOR2BX1 U103 ( .AN(n47), .B(n39), .Y(n56) );
  AOI32X1 U104 ( .A0(n78), .A1(n77), .A2(n59), .B0(n34), .B1(n190), .Y(n55) );
  CLKINVX1 U105 ( .A(n58), .Y(n39) );
  CLKINVX1 U106 ( .A(n53), .Y(n59) );
  NOR2X1 U107 ( .A(n77), .B(n11), .Y(n81) );
  NAND3BX1 U108 ( .AN(n65), .B(n58), .C(n45), .Y(S1) );
  NAND3BX1 U109 ( .AN(n190), .B(n48), .C(n26), .Y(n65) );
  OAI221X1 U110 ( .A0(n82), .A1(n31), .B0(S2), .B1(n48), .C0(n49), .Y(S4) );
  AOI211X1 U111 ( .A0(n50), .A1(n36), .B0(n51), .C0(n39), .Y(n49) );
  CLKINVX1 U112 ( .A(n52), .Y(n51) );
  NOR2BX1 U113 ( .AN(n12), .B(n53), .Y(n50) );
  OA21X2 U114 ( .A0(S2), .A1(n32), .B0(n33), .Y(n27) );
  AOI32X1 U115 ( .A0(n82), .A1(S2), .A2(n34), .B0(n17), .B1(n190), .Y(n33) );
  OAI222X1 U116 ( .A0(n36), .A1(n24), .B0(S3), .B1(n24), .C0(n37), .C1(n7), 
        .Y(n70) );
  AOI221X1 U117 ( .A0(n38), .A1(n78), .B0(n39), .B1(n40), .C0(n41), .Y(n37) );
  OAI32X1 U118 ( .A0(n77), .A1(S2), .A2(n76), .B0(n5), .B1(n42), .Y(n41) );
  OAI221X1 U119 ( .A0(n40), .A1(n76), .B0(n12), .B1(n31), .C0(n44), .Y(n38) );
  AO21X1 U120 ( .A0(BistMode), .A1(n22), .B0(n23), .Y(n71) );
  NAND4BX1 U121 ( .AN(n25), .B(n26), .C(n27), .D(n28), .Y(n22) );
  OAI31X1 U122 ( .A0(n24), .A1(n77), .A2(n80), .B0(n11), .Y(n23) );
  CLKINVX1 U123 ( .A(n35), .Y(n25) );
  AO21X1 U124 ( .A0(n2), .A1(n3), .B0(n4), .Y(n73) );
  OAI33X1 U125 ( .A0(n5), .A1(n79), .A2(n7), .B0(n8), .B1(n77), .B2(n76), .Y(
        n4) );
  NAND3BX1 U126 ( .AN(n7), .B(S2), .C(n82), .Y(n8) );
  CLKINVX1 U127 ( .A(n43), .Y(n5) );
  NAND2BX1 U128 ( .AN(n17), .B(n44), .Y(n43) );
  CLKINVX1 U129 ( .A(S2), .Y(n40) );
  CLKINVX1 U130 ( .A(S3), .Y(n12) );
  NAND3BX1 U131 ( .AN(n60), .B(n61), .C(n46), .Y(S12) );
  OA22X1 U132 ( .A0(n53), .A1(n63), .B0(n42), .B1(n64), .Y(n61) );
  OAI31X1 U133 ( .A0(n44), .A1(n82), .A2(n79), .B0(n48), .Y(n60) );
  AOI31X1 U134 ( .A0(S3), .A1(n78), .A2(n29), .B0(n30), .Y(n28) );
  CLKINVX1 U135 ( .A(n31), .Y(n29) );
  CLKINVX1 U136 ( .A(Tclk), .Y(N19) );
  NAND3BX1 U137 ( .AN(n78), .B(State[3]), .C(n34), .Y(n47) );
  NAND2BX1 U138 ( .AN(State[1]), .B(n76), .Y(n44) );
  NAND2BX1 U139 ( .AN(State[1]), .B(n57), .Y(n52) );
  NAND3BX1 U140 ( .AN(State[3]), .B(n82), .C(n17), .Y(n45) );
  NAND2BX1 U141 ( .AN(State[2]), .B(State[1]), .Y(n64) );
  NAND2BX1 U142 ( .AN(State[1]), .B(n82), .Y(n63) );
  CLKBUFX3 U143 ( .A(State[0]), .Y(n82) );
  NAND2BX1 U144 ( .AN(n76), .B(State[3]), .Y(n53) );
  NAND3BX1 U145 ( .AN(State[3]), .B(n82), .C(n34), .Y(n58) );
  OAI221X1 U146 ( .A0(n11), .A1(n12), .B0(n13), .B1(n7), .C0(n14), .Y(n72) );
  AOI221X1 U147 ( .A0(State[2]), .A1(n16), .B0(n17), .B1(n82), .C0(n18), .Y(
        n13) );
  AOI31X1 U148 ( .A0(n78), .A1(n77), .A2(n2), .B0(n81), .Y(n14) );
  AO21X1 U149 ( .A0(n190), .A1(S2), .B0(n20), .Y(n16) );
  NAND4BX1 U150 ( .AN(State[3]), .B(n82), .C(State[2]), .D(State[1]), .Y(n48)
         );
  OAI33X1 U151 ( .A0(n77), .A1(n82), .A2(n80), .B0(n77), .B1(State[3]), .B2(S2), .Y(n20) );
  OAI32X1 U152 ( .A0(n54), .A1(n80), .A2(n7), .B0(n24), .B1(n3), .Y(n69) );
  NOR3BX1 U153 ( .AN(State[1]), .B(n53), .C(n82), .Y(n54) );
  NAND3BX1 U154 ( .AN(n82), .B(n80), .C(State[1]), .Y(n3) );
  DFFX1 State_reg_2_ ( .D(n72), .CK(N19), .Q(State[2]), .QN(n76) );
  DFFX1 State_reg_0_ ( .D(n70), .CK(N19), .Q(State[0]), .QN(n78) );
  DFFX1 S36_reg ( .D(n69), .CK(N19), .Q(S8), .QN(n80) );
  DFFX1 Finish_reg ( .D(n81), .CK(N19), .Q(Finish) );
endmodule


module ST_MAL_SPSRAM256X8 ( Tclk, BistMode, BistFail, S12, S13, S14, ErrMap );
  input [7:0] S13;
  input [7:0] S14;
  input Tclk, BistMode, S12;
  output BistFail, ErrMap;
  wire   N14, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n140, n15;

  AOI211X1 U18 ( .A0(n2), .A1(n3), .B0(n4), .C0(n5), .Y(n140) );
  CLKINVX1 U19 ( .A(S12), .Y(n4) );
  CLKINVX1 U20 ( .A(BistMode), .Y(n5) );
  AND4X1 U21 ( .A(n10), .B(n11), .C(n12), .D(n13), .Y(n2) );
  CLKINVX1 U22 ( .A(Tclk), .Y(N14) );
  XNOR2X1 U23 ( .A(S14[0]), .B(S13[0]), .Y(n9) );
  XNOR2X1 U24 ( .A(S14[4]), .B(S13[4]), .Y(n13) );
  XNOR2X1 U25 ( .A(S14[5]), .B(S13[5]), .Y(n12) );
  XNOR2X1 U26 ( .A(S14[7]), .B(S13[7]), .Y(n10) );
  XNOR2X1 U27 ( .A(S14[6]), .B(S13[6]), .Y(n11) );
  AND4X1 U28 ( .A(n6), .B(n7), .C(n8), .D(n9), .Y(n3) );
  XNOR2X1 U29 ( .A(S14[3]), .B(S13[3]), .Y(n6) );
  XNOR2X1 U30 ( .A(S14[2]), .B(S13[2]), .Y(n7) );
  XNOR2X1 U31 ( .A(S14[1]), .B(S13[1]), .Y(n8) );
  AO22X1 U32 ( .A0(ErrMap), .A1(BistMode), .B0(BistMode), .B1(BistFail), .Y(
        n15) );
  DFFX1 S16_reg ( .D(n140), .CK(N14), .Q(ErrMap) );
  DFFX1 S17_reg ( .D(n15), .CK(N14), .Q(BistFail) );
endmodule


module ST_MPG_SPSRAM256X8 ( S7, S8, S9 );
  output [7:0] S7;
  input S8, S9;
  wire   n2, n6;

  CLKINVX1 U3 ( .A(S7[0]), .Y(n2) );
  CLKINVX1 U4 ( .A(S9), .Y(n6) );
  CLKINVX1 U5 ( .A(n2), .Y(S7[2]) );
  CLKINVX1 U6 ( .A(n2), .Y(S7[4]) );
  CLKINVX1 U7 ( .A(n2), .Y(S7[6]) );
  CLKINVX1 U8 ( .A(n6), .Y(S7[1]) );
  CLKINVX1 U9 ( .A(n6), .Y(S7[3]) );
  CLKINVX1 U10 ( .A(n6), .Y(S7[5]) );
  CLKINVX1 U11 ( .A(n6), .Y(S7[7]) );
  XOR2X1 U12 ( .A(S8), .B(S9), .Y(S7[0]) );
endmodule


module ST_MAG_SPSRAM256X8 ( Tclk, BistMode, S0, S1, S2, S3, S4 );
  output [7:0] S0;
  input Tclk, BistMode, S1, S4;
  output S2, S3;
  wire   N12, N49, N50, N51, N52, N53, N54, N55, N56, N57, N58, N59, N60, N61,
         N62, N63, N64, n2, n3, n5, n6, n7, n8, n9, n10, n11, n120, n13, n19,
         n22, n23, n29, n30, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
         n42, n43, n44, n45, n46, n47, n48, n490;

  AND2X1 U44 ( .A(BistMode), .B(S4), .Y(n490) );
  AND2X2 U45 ( .A(S1), .B(n490), .Y(n48) );
  CLKINVX1 U46 ( .A(n13), .Y(n5) );
  NAND2BX1 U47 ( .AN(S1), .B(n490), .Y(n13) );
  DFFX1 S5_reg_0_ ( .D(n32), .CK(N12), .Q(S0[0]), .QN(n43) );
  DFFX1 S5_reg_3_ ( .D(n35), .CK(N12), .Q(S0[3]), .QN(n45) );
  DFFX1 S5_reg_6_ ( .D(n38), .CK(N12), .Q(S0[6]), .QN(n41) );
  DFFX1 S5_reg_4_ ( .D(n36), .CK(N12), .Q(S0[4]), .QN(n40) );
  DFFX1 S5_reg_1_ ( .D(n33), .CK(N12), .Q(S0[1]), .QN(n46) );
  DFFX1 S5_reg_5_ ( .D(n37), .CK(N12), .Q(S0[5]), .QN(n44) );
  DFFX1 S5_reg_2_ ( .D(n34), .CK(N12), .Q(S0[2]), .QN(n47) );
  DFFX1 S5_reg_7_ ( .D(n39), .CK(N12), .Q(S0[7]), .QN(n42) );
  CLKINVX1 U48 ( .A(n19), .Y(n2) );
  NAND2BX1 U49 ( .AN(S4), .B(BistMode), .Y(n19) );
  CLKINVX1 U50 ( .A(Tclk), .Y(N12) );
  AND4X1 U51 ( .A(S0[0]), .B(S0[1]), .C(n29), .D(n30), .Y(S2) );
  NOR2BX1 U52 ( .AN(S0[2]), .B(n45), .Y(n29) );
  AND4X1 U53 ( .A(S0[4]), .B(S0[5]), .C(S0[6]), .D(S0[7]), .Y(n30) );
  AND4X1 U54 ( .A(n43), .B(n46), .C(n22), .D(n23), .Y(S3) );
  NOR2BX1 U55 ( .AN(n47), .B(S0[3]), .Y(n22) );
  AND4X1 U56 ( .A(n40), .B(n44), .C(n41), .D(n42), .Y(n23) );
  AO21X1 U57 ( .A0(S0[0]), .A1(n2), .B0(n120), .Y(n32) );
  AO22X1 U58 ( .A0(N49), .A1(n48), .B0(N57), .B1(n5), .Y(n120) );
  AO21X1 U59 ( .A0(S0[3]), .A1(n2), .B0(n9), .Y(n35) );
  AO22X1 U60 ( .A0(N52), .A1(n48), .B0(N60), .B1(n5), .Y(n9) );
  AO21X1 U61 ( .A0(S0[4]), .A1(n2), .B0(n8), .Y(n36) );
  AO22X1 U62 ( .A0(N53), .A1(n48), .B0(N61), .B1(n5), .Y(n8) );
  AO21X1 U63 ( .A0(S0[6]), .A1(n2), .B0(n6), .Y(n38) );
  AO22X1 U64 ( .A0(N55), .A1(n48), .B0(N63), .B1(n5), .Y(n6) );
  AO21X1 U65 ( .A0(S0[1]), .A1(n2), .B0(n11), .Y(n33) );
  AO22X1 U66 ( .A0(N50), .A1(n48), .B0(N58), .B1(n5), .Y(n11) );
  AO21X1 U67 ( .A0(S0[5]), .A1(n2), .B0(n7), .Y(n37) );
  AO22X1 U68 ( .A0(N54), .A1(n48), .B0(N62), .B1(n5), .Y(n7) );
  AO21X1 U69 ( .A0(S0[2]), .A1(n2), .B0(n10), .Y(n34) );
  AO22X1 U70 ( .A0(N51), .A1(n48), .B0(N59), .B1(n5), .Y(n10) );
  AO21X1 U71 ( .A0(S0[7]), .A1(n2), .B0(n3), .Y(n39) );
  AO22X1 U72 ( .A0(N56), .A1(n48), .B0(N64), .B1(n5), .Y(n3) );
  ST_MAG_SPSRAM256X8_DW01_dec_8_0 sub_43 ( .A(S0), .SUM({N64, N63, N62, N61, 
        N60, N59, N58, N57}) );
  ST_MAG_SPSRAM256X8_DW01_inc_8_0 add_40 ( .A(S0), .SUM({N56, N55, N54, N53, 
        N52, N51, N50, N49}) );
endmodule


module ST_MAG_SPSRAM256X8_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1;

  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  XNOR2X1 U5 ( .A(carry_7_), .B(n1), .Y(SUM[7]) );
  CLKINVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
  CLKINVX1 U7 ( .A(A[7]), .Y(n1) );
endmodule


module ST_MAG_SPSRAM256X8_DW01_dec_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  OR2X1 U1_B_1 ( .A(A[1]), .B(A[0]), .Y(carry_2_) );
  OR2X1 U1_B_3 ( .A(A[3]), .B(carry_3_), .Y(carry_4_) );
  OR2X1 U1_B_4 ( .A(A[4]), .B(carry_4_), .Y(carry_5_) );
  OR2X1 U1_B_5 ( .A(A[5]), .B(carry_5_), .Y(carry_6_) );
  OR2X1 U1_B_2 ( .A(A[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X1 U1_B_6 ( .A(A[6]), .B(carry_6_), .Y(carry_7_) );
  XNOR2X1 U1_A_3 ( .A(A[3]), .B(carry_3_), .Y(SUM[3]) );
  XNOR2X1 U1_A_4 ( .A(A[4]), .B(carry_4_), .Y(SUM[4]) );
  XNOR2X1 U1_A_6 ( .A(A[6]), .B(carry_6_), .Y(SUM[6]) );
  XNOR2X1 U1_A_1 ( .A(A[1]), .B(A[0]), .Y(SUM[1]) );
  XNOR2X1 U1_A_5 ( .A(A[5]), .B(carry_5_), .Y(SUM[5]) );
  XNOR2X1 U1_A_2 ( .A(A[2]), .B(carry_2_), .Y(SUM[2]) );
  XNOR2X1 U1_A_7 ( .A(A[7]), .B(carry_7_), .Y(SUM[7]) );
  CLKINVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
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
         n50, n52, n54, n56, n58, n60, n62, n64, n66, n68;
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
        .msb_a(n68), .msb_r(msb_r), .cy(cy), .ac(ac), .ov(ov), .out_acc_r(
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
        .in_xrom1_r(in_xrom1_r), .bit_dat_in_r(bit_dat_in_r), .p0_out(p0_en), 
        .p1_out(p1_en), .p2_out(p2_en), .p3_out(p3_en), .txdo(txdo), .rxdo(
        rxdo), .out_xdat(out_xdat), .out_idat(out_idat) );
  CLKINVX1 U9 ( .A(1'b1), .Y(psen) );
  CLKBUFX2 U11 ( .A(msb_a), .Y(n68) );
  INVX1 U12 ( .A(rd_idat_p), .Y(rd_idat) );
  CLKINVX1 U13 ( .A(wr_idat_p), .Y(wr_idat) );
  INVX1 U14 ( .A(p3_en[2]), .Y(n8) );
  INVX1 U15 ( .A(p3_en[3]), .Y(n1000) );
  INVX1 U16 ( .A(p3_en[1]), .Y(n6) );
  INVX1 U17 ( .A(p0_en[1]), .Y(n54) );
  DFFRX1 ale_reg ( .D(ale_neg), .CK(N1), .RN(n100), .Q(ale) );
  DFFRX1 xdat_en_reg ( .D(wr_xdat), .CK(N1), .RN(n100), .Q(xdat_en) );
  CLKINVX1 U18 ( .A(n12), .Y(p3_out[4]) );
  CLKINVX1 U19 ( .A(n14), .Y(p3_out[5]) );
  CLKINVX1 U20 ( .A(n16), .Y(p3_out[6]) );
  CLKINVX1 U21 ( .A(n18), .Y(p3_out[7]) );
  CLKINVX1 U22 ( .A(n28), .Y(p2_out[4]) );
  CLKINVX1 U23 ( .A(n30), .Y(p2_out[5]) );
  CLKINVX1 U24 ( .A(n32), .Y(p2_out[6]) );
  CLKINVX1 U25 ( .A(n34), .Y(p2_out[7]) );
  CLKINVX1 U26 ( .A(n58), .Y(p0_out[3]) );
  CLKINVX1 U27 ( .A(n60), .Y(p0_out[4]) );
  CLKINVX1 U28 ( .A(n62), .Y(p0_out[5]) );
  CLKINVX1 U29 ( .A(n64), .Y(p0_out[6]) );
  CLKINVX1 U30 ( .A(n66), .Y(p0_out[7]) );
  CLKINVX1 U31 ( .A(n4), .Y(p3_out[0]) );
  CLKINVX1 U32 ( .A(n6), .Y(p3_out[1]) );
  CLKINVX1 U33 ( .A(n8), .Y(p3_out[2]) );
  CLKINVX1 U34 ( .A(n1000), .Y(p3_out[3]) );
  CLKINVX1 U35 ( .A(n20), .Y(p2_out[0]) );
  CLKINVX1 U36 ( .A(n22), .Y(p2_out[1]) );
  CLKINVX1 U37 ( .A(n24), .Y(p2_out[2]) );
  CLKINVX1 U38 ( .A(n26), .Y(p2_out[3]) );
  CLKINVX1 U39 ( .A(n52), .Y(p0_out[0]) );
  CLKINVX1 U40 ( .A(n54), .Y(p0_out[1]) );
  CLKINVX1 U41 ( .A(n56), .Y(p0_out[2]) );
  CLKINVX1 U42 ( .A(wr_xdat_p), .Y(wr_xdat) );
  CLKINVX1 U43 ( .A(rd_xdat_p), .Y(rd_xdat) );
  CLKINVX1 U44 ( .A(n36), .Y(p1_out[0]) );
  CLKINVX1 U45 ( .A(p1_en[0]), .Y(n36) );
  CLKINVX1 U46 ( .A(n38), .Y(p1_out[1]) );
  CLKINVX1 U47 ( .A(p1_en[1]), .Y(n38) );
  CLKINVX1 U48 ( .A(n40), .Y(p1_out[2]) );
  CLKINVX1 U49 ( .A(p1_en[2]), .Y(n40) );
  CLKINVX1 U50 ( .A(n42), .Y(p1_out[3]) );
  INVX1 U51 ( .A(p1_en[3]), .Y(n42) );
  CLKINVX1 U52 ( .A(n44), .Y(p1_out[4]) );
  INVX1 U53 ( .A(p1_en[4]), .Y(n44) );
  CLKINVX1 U54 ( .A(n46), .Y(p1_out[5]) );
  INVX1 U55 ( .A(p1_en[5]), .Y(n46) );
  CLKINVX1 U56 ( .A(n48), .Y(p1_out[6]) );
  INVX1 U57 ( .A(p1_en[6]), .Y(n48) );
  CLKINVX1 U58 ( .A(n50), .Y(p1_out[7]) );
  INVX1 U59 ( .A(p1_en[7]), .Y(n50) );
  CLKINVX1 U60 ( .A(clk), .Y(N1) );
  INVX1 U61 ( .A(rst_p), .Y(n100) );
  INVX1 U62 ( .A(p3_en[4]), .Y(n12) );
  INVX1 U63 ( .A(p3_en[5]), .Y(n14) );
  INVX1 U64 ( .A(p3_en[6]), .Y(n16) );
  INVX1 U65 ( .A(p3_en[7]), .Y(n18) );
  INVX1 U66 ( .A(p2_en[4]), .Y(n28) );
  INVX1 U67 ( .A(p2_en[5]), .Y(n30) );
  INVX1 U68 ( .A(p2_en[6]), .Y(n32) );
  INVX1 U69 ( .A(p2_en[7]), .Y(n34) );
  INVX1 U70 ( .A(p0_en[3]), .Y(n58) );
  INVX1 U71 ( .A(p0_en[4]), .Y(n60) );
  INVX1 U72 ( .A(p0_en[5]), .Y(n62) );
  INVX1 U73 ( .A(p0_en[6]), .Y(n64) );
  INVX1 U74 ( .A(p0_en[7]), .Y(n66) );
  CLKINVX1 U75 ( .A(p3_en[0]), .Y(n4) );
  CLKINVX1 U76 ( .A(p2_en[0]), .Y(n20) );
  CLKINVX1 U77 ( .A(p2_en[1]), .Y(n22) );
  CLKINVX1 U78 ( .A(p2_en[2]), .Y(n24) );
  CLKINVX1 U79 ( .A(p2_en[3]), .Y(n26) );
  CLKINVX1 U80 ( .A(p0_en[0]), .Y(n52) );
  CLKINVX1 U81 ( .A(p0_en[2]), .Y(n56) );
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
  wire   n1616, n1618, n1620, n1621, n1622, addr2_a_4_, addr2_a_2_, addr2_a_1_,
         addr2_a_0_, out_psw_6_, out_psw_4_, out_psw_3_, N109, bit_dat_in,
         N110, in_cy_bit, out_pc_r_15_, out_pc_r_14_, out_pc_r_13_,
         out_pc_r_12_, out_pc_r_11_, out_pc_r_10_, out_pc_r_9_, out_pc_r_8_,
         out_pc_r_7_, out_pc_r_6_, out_pc_r_5_, out_pc_r_4_, out_pc_r_3_,
         out_pc_r_2_, latch_pc_1_, latch_pc_0_, op2_6_, op2_4_, op2_2_, op2_0_,
         a_plus_pc_1_, a_plus_pc_2_, a_plus_pc_3_, a_plus_pc_4_, a_plus_pc_5_,
         a_plus_pc_6_, a_plus_pc_7_, a_plus_pc_8_, a_plus_pc_9_, a_plus_pc_10_,
         a_plus_pc_11_, a_plus_pc_12_, a_plus_pc_13_, a_plus_pc_14_,
         a_plus_pc_15_, a_plus_dptr_15_, N309, N310, N311, N312, N313, N314,
         N315, N316, N317, N318, N319, N320, N321, N322, N323, N324, N327,
         N329, N330, N331, N332, N333, N334, N335, N336, N337, N338, N339,
         N340, N341, N342, n1613, n1611, n1609, \out_idat0[0] , \out_idat0[1] ,
         \out_idat0[2] , \out_idat0[3] , \out_idat0[4] , \out_idat0[5] ,
         \out_idat0[6] , \out_idat0[7] , n10, n11, n12, n15, n20, n22, n23,
         n26, n34, n36, n39, n43, n44, n47, n50, n54, n55, n61, n70, n75, n76,
         n77, n80, n81, n86, n89, n90, n93, n101, n102, n104, n106, n108,
         n10900, n11000, n111, n177, n221, n228, n229, n231, n232, n233, n234,
         n235, n236, n237, n238, n239, n240, n241, n242, n243, n244, n245,
         n248, n249, n250, n251, n258, n266, n276, n278, n284, n291, n294,
         n3120, n3130, n3200, n3210, n328, n3290, n3360, n3370, n344, n345,
         n352, n353, n356, n360, n362, n369, n371, n372, n399, n400, n403,
         n404, n407, n408, n409, n410, n411, n422, n423, n424, n425, n427,
         n428, n429, n483, n484, n486, n487, n488, n489, n491, n492, n493,
         n494, n495, n496, n497, n498, n499, n500, n501, n504, n505, n506,
         n507, n508, n509, n510, n511, n512, n513, n514, n515, n516, n517,
         n518, n519, n520, n521, n522, n523, n524, n525, n526, n527, n528,
         n529, n530, n531, n532, n533, n534, n535, n536, n537, n538, n539,
         n540, n541, n542, n543, n544, n545, n546, n547, n548, n549, n550,
         n551, n552, n553, n554, n555, n556, n557, n558, n559, n560, n561,
         n562, n563, n564, n565, n566, n567, n568, n569, n570, n571, n572,
         n573, n574, n575, n576, n577, n578, n579, n580, n581, n582, n583,
         n584, n585, n586, n587, n588, n589, n590, n591, n592, n593, n594,
         n595, n596, n597, n598, n599, n600, n601, n602, n603, n604, n605,
         n606, n607, n608, n609, n610, n611, n613, n614, n615, n616, n617,
         n618, n619, n620, n621, n623, n625, n626, n627, n628, n629, n630,
         n631, n632, n633, n634, n635, n636, n637, n641, n645, n646, n648,
         n649, n650, n652, n654, n656, n657, n658, n659, n661, n662, n663,
         n664, n665, n667, n668, n669, n670, n671, n672, n674, n675, n676,
         n677, n678, n679, n680, n681, n682, n683, n684, n685, n686, n687,
         n688, n689, n690, n691, n692, n693, n694, n695, n696, n697, n698,
         n699, n701, n702, n703, n704, n705, n706, n707, n708, n709, n710,
         n711, n712, n713, n714, n715, n716, n717, n718, n719, n720, n721,
         n722, n723, n724, n725, n726, n727, n728, n729, n730, n731, n732,
         n733, n734, n735, n736, n737, n738, n739, n740, n741, n742, n743,
         n744, n745, n746, n747, n748, n749, n750, n751, n752, n753, n754,
         n755, n756, n757, n758, n760, n761, n762, n763, n764, n765, n766,
         n767, n768, n769, n770, n771, n772, n773, n774, n775, n776, n777,
         n778, n779, n780, n781, n782, n783, n784, n785, n786, n787, n788,
         n789, n790, n791, n792, n793, n794, n795, n796, n797, n798, n799,
         n800, n801, n802, n803, n804, n805, n806, n807, n808, n809, n810,
         n811, n812, n813, n814, n815, n816, n817, n818, n819, n820, n821,
         n822, n823, n824, n825, n826, n827, n828, n829, n830, n831, n832,
         n833, n834, n835, n836, n837, n838, n839, n840, n841, n842, n843,
         n844, n845, n846, n847, n848, n849, n850, n851, n852, n853, n854,
         n855, n856, n857, n858, n859, n860, n861, n862, n863, n864, n865,
         n866, n867, n868, n869, n870, n871, n872, n873, n874, n875, n876,
         n877, n878, n879, n880, n881, n882, n883, n884, n885, n886, n887,
         n888, n889, n890, n891, n892, n893, n894, n895, n896, n897, n898,
         n899, n900, n901, n902, n903, n904, n905, n906, n907, n908, n909,
         n910, n911, n912, n913, n914, n915, n916, n917, n918, n919, n920,
         n921, n922, n923, n924, n925, n926, n927, n928, n929, n930, n931,
         n932, n933, n934, n935, n936, n937, n938, n939, n940, n941, n942,
         n943, n944, n945, n946, n947, n948, n949, n950, n951, n952, n953,
         n954, n955, n956, n957, n958, n959, n960, n961, n962, n963, n964,
         n965, n966, n967, n968, n969, n970, n971, n972, n973, n974, n975,
         n976, n977, n978, n979, n980, n981, n982, n983, n984, n985, n986,
         n987, n988, n989, n990, n991, n992, n993, n994, n995, n996, n997,
         n998, n999, n1000, n1001, n1002, n1003, n1004, n1005, n1006, n1007,
         n1008, n1009, n1010, n1011, n1012, n1013, n1014, n1015, n1016, n1017,
         n1018, n1019, n1020, n1021, n1022, n1023, n1024, n1025, n1026, n1027,
         n1028, n1029, n1030, n1031, n1032, n1033, n1034, n1035, n1036, n1037,
         n1038, n1039, n1040, n1041, n1042, n1043, n1044, n1045, n1046, n1047,
         n1048, n1049, n1050, n1051, n1052, n1053, n1054, n1055, n1056, n1057,
         n1058, n1059, n1060, n1061, n1062, n1063, n1064, n1065, n1066, n1067,
         n1068, n1069, n1070, n1071, n1072, n1073, n1074, n1075, n1076, n1077,
         n1078, n1079, n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087,
         n1088, n1089, n109000, n1091, n1092, n1093, n1094, n1095, n1096,
         n1097, n1098, n1099, n110000, n1101, n1102, n1103, n1104, n1105,
         n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113, n1114, n1115,
         n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123, n1124, n1125,
         n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133, n1134, n1135,
         n1136, n1137, n1138, n1139, n1140, n1141, n1142, n1143, n1144, n1145,
         n1146, n1147, n1148, n1149, n1150, n1151, n1152, n1153, n1154, n1155,
         n1156, n1157, n1158, n1159, n1160, n1161, n1162, n1163, n1164, n1165,
         n1166, n1167, n1168, n1169, n1170, n1171, n1172, n1173, n1174, n1175,
         n1176, n1177, n1178, n1179, n1180, n1181, n1182, n1183, n1184, n1185,
         n1186, n1187, n1188, n1189, n1190, n1191, n1192, n1193, n1194, n1195,
         n1196, n1197, n1198, n1199, n1200, n1201, n1202, n1203, n1204, n1205,
         n1206, n1207, n1208, n1209, n1210, n1211, n1212, n1213, n1214, n1215,
         n1216, n1217, n1218, n1219, n1220, n1221, n1222, n1223, n1224, n1225,
         n1226, n1227, n1228, n1229, n1230, n1231, n1232, n1233, n1234, n1235,
         n1236, n1237, n1238, n1239, n1240, n1241, n1242, n1243, n1244, n1245,
         n1246, n1247, n1248, n1249, n1250, n1251, n1252, n1253, n1254, n1255,
         n1256, n1257, n1258, n1259, n1260, n1261, n1262, n1263, n1264, n1265,
         n1266, n1267, n1268, n1269, n1270, n1271, n1272, n1273, n1274, n1275,
         n1276, n1277, n1278, n1279, n1280, n1281, n1282, n1283, n1284, n1285,
         n1286, n1287, n1288, n1289, n1290, n1291, n1292, n1293, n1294, n1295,
         n1296, n1297, n1298, n1299, n1300, n1301, n1302, n1303, n1304, n1305,
         n1306, n1307, n1308, n1309, n1310, n1311, n1312, n1313, n1314, n1315,
         n1316, n1317, n1318, n1319, n1320, n1321, n1322, n1323, n1324, n1325,
         n1326, n1327, n1328, n1329, n1330, n1331, n1332, n1333, n1334, n1335,
         n1336, n1337, n1338, n1339, n1340, n1341, n1342, n1343, n1344, n1345,
         n1346, n1347, n1348, n1349, n1350, n1351, n1352, n1353, n1354, n1355,
         n1356, n1357, n1358, n1359, n1360, n1361, n1362, n1363, n1364, n1365,
         n1366, n1367, n1368, n1369, n1370, n1371, n1372, n1373, n1374, n1375,
         n1376, n1377, n1378, n1379, n1380, n1381, n1382, n1383, n1384, n1385,
         n1386, n1387, n1388, n1389, n1390, n1391, n1392, n1393, n1394, n1395,
         n1396, n1397, n1398, n1399, n1400, n1401, n1402, n1403, n1404, n1405,
         n1406, n1407, n1408, n1409, n1410, n1411, n1412, n1413, n1414, n1415,
         n1416, n1417, n1418, n1419, n1420, n1421, n1422, n1423, n1424, n1425,
         n1426, n1427, n1428, n1429, n1430, n1431, n1432, n1433, n1434, n1435,
         n1436, n1437, n1438, n1439, n1440, n1441, n1442, n1443, n1444, n1445,
         n1446, n1447, n1448, n1449, n1450, n1451, n1452, n1453, n1454, n1455,
         n1456, n1457, n1458, n1459, n1460, n1461, n1462, n1463, n1464, n1465,
         n1466, n1467, n1468, n1469, n1470, n1471, n1472, n1473, n1474, n1475,
         n1476, n1477, n1478, n1479, n1480, n1481, n1482, n1483, n1484, n1485,
         n1486, n1487, n1488, n1489, n1490, n1491, n1492, n1493, n1494, n1495,
         n1496, n1497, n1498, n1499, n1500, n1501, n1502, n1503, n1504, n1505,
         n1506, n1507, n1508, n1509, n1510, n1511, n1512, n1513, n1514, n1515,
         n1516, n1517, n1518, n1519, n1520, n1521, n1522, n1523, n1524, n1525,
         n1526, n1527, n1528, n1529, n1530, n1531, n1532, n1533, n1534, n1535,
         n1536, n1537, n1538, n1539, n1540, n1541, n1542, n1543, n1544, n1545,
         n1546, n1547, n1548, n1549, n1550, n1551, n1552, n1553, n1554, n1555,
         n1556, n1557, n1558, n1559, n1560, n1561, n1562, n1563, n1564, n1565,
         n1566, n1567, n1568, n1569, n1570, n1571, n1572, n1573, n1574, n1575,
         n1576, n1577, n1578, n1579, n1580, n1581, n1582, n1583, n1584, n1585,
         n1586, n1587, n1588, n1589, n1590, n1591, n1592, n1593, n1594, n1595,
         n1596, n1597, n1598, n1599, n1600, n1601, n1602, n1603, n1604, n1605,
         n1606, n1607, add_465_carry_15_, add_465_carry_14_, add_465_carry_13_,
         add_465_carry_12_, add_465_carry_11_, add_465_carry_10_,
         add_465_carry_9_, add_465_carry_8_, add_465_carry_7_,
         add_465_carry_6_, add_465_carry_5_, add_465_carry_4_,
         add_465_carry_3_, add_465_carry_2_, add_465_carry_1_,
         add_434_carry_15_, add_434_carry_14_, add_434_carry_13_,
         add_434_carry_12_, add_434_carry_11_, add_434_carry_10_,
         add_434_carry_9_, add_434_carry_8_, add_434_carry_7_,
         add_434_carry_6_, add_434_carry_5_, add_434_carry_4_,
         add_434_carry_3_, add_434_carry_2_;
  wire   [15:0] out_dptr_r;
  wire   [7:0] in_idat_r;
  wire   [7:0] out_sfr_a;
  wire   [7:0] in_xrom_r;
  wire   [7:0] out_sp_r;
  wire   [15:0] in_rel_adder;
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
  wire   [7:0] latch_acc;
  wire   [15:0] in_pc;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3;
  assign combus[0] = \out_idat0[0] ;
  assign out_idat[0] = \out_idat0[0] ;
  assign combus[1] = \out_idat0[1] ;
  assign out_idat[1] = \out_idat0[1] ;
  assign combus[2] = \out_idat0[2] ;
  assign out_idat[2] = \out_idat0[2] ;
  assign combus[3] = \out_idat0[3] ;
  assign out_idat[3] = \out_idat0[3] ;
  assign combus[4] = \out_idat0[4] ;
  assign out_idat[4] = \out_idat0[4] ;
  assign combus[5] = \out_idat0[5] ;
  assign out_idat[5] = \out_idat0[5] ;
  assign combus[6] = \out_idat0[6] ;
  assign out_idat[6] = \out_idat0[6] ;
  assign combus[7] = \out_idat0[7] ;
  assign out_idat[7] = \out_idat0[7] ;

  sign U4_sign ( .a(in_xrom_r), .b(in_rel_adder) );
  pc U0_pc ( .clk(clk), .rst_p(rst_p), .ld_pc(ld_pc), .ld_pcl(ld_pcl), 
        .ld_pch(ld_pch), .inc_pc(inc_pc), .in_pc(in_pc), .out_pc_r({
        out_pc_r_15_, out_pc_r_14_, out_pc_r_13_, out_pc_r_12_, out_pc_r_11_, 
        out_pc_r_10_, out_pc_r_9_, out_pc_r_8_, out_pc_r_7_, out_pc_r_6_, 
        out_pc_r_5_, out_pc_r_4_, out_pc_r_3_, out_pc_r_2_, add_434_carry_2_, 
        N327}) );
  page_addr U27_page_addr ( .pc({out_pc_r_15_, out_pc_r_14_, out_pc_r_13_, 
        out_pc_r_12_, out_pc_r_11_}), .code({code[7], n641, n636}), .xrom(xrom), .page_addr_a(page_addr_a) );
  u_sfr U1_sfr ( .end_instr(end_instr), .clk(clk), .rst_p(rst_p), .ld_acc(
        ld_acc), .ld_acc_chd(ld_acc_chd), .addr_sfr({msb_a, n1609, n1611, 
        n1613, addr_a[3:2], n1616, n1618}), .in_sfr({\out_idat0[7] , 
        \out_idat0[6] , \out_idat0[5] , \out_idat0[4] , \out_idat0[3] , 
        \out_idat0[2] , \out_idat0[1] , \out_idat0[0] }), .wr_sfr(wr_sfr), 
        .ld_dpl(ld_dpl), .ld_dph(ld_dph), .inc_dptr(inc_dptr), .inc_sp(inc_sp), 
        .dec_sp(dec_sp), .set_c(set_c), .rst_c(rst_c), .cpl_c(cpl_c), .ld_c(
        ld_c), .set_ac(set_ac), .rst_ac(rst_ac), .set_v(set_v), .rst_v(rst_v), 
        .acc_chd(acc_chd), .in_b(in_b), .ld_b(ld_b), .in_cy_bit(in_cy_bit), 
        .rmw(rmw), .t0_pin(t0_pin), .t1_pin(t1_pin), .int0_pin(int0_pin), 
        .int1_pin(int1_pin), .p0_in(p0_in), .p1_in(p1_in), .p2_in(p2_in), 
        .p3_in(p3_in), .reti(reti), .out_sfr_a(out_sfr_a), .out_acc_r({
        out_acc_r[7:4], n1620, out_acc_r[2], n1621, n1622}), .out_dptr_r(
        out_dptr_r), .out_dimod_r(out_dimod_r), .out_sp_r(out_sp_r), .out_psw(
        {cy_psw, out_psw_6_, SYNOPSYS_UNCONNECTED__0, out_psw_4_, out_psw_3_, 
        SYNOPSYS_UNCONNECTED__1, SYNOPSYS_UNCONNECTED__2, 
        SYNOPSYS_UNCONNECTED__3}), .out_b(out_b), .p0_out(p0_out), .p1_out(
        p1_out), .p2_out(p2_out), .p3_out(p3_out), .txdo(txdo), .rxdi(rxdi), 
        .rxdo(rxdo), .int_vec(int_vec), .en_int(en_int) );
  u_alu U3_alu ( .en_div(en_div), .clk(clk), .rst_p(rst_p), .OP_B({n803, 
        op2_6_, n802, op2_4_, n679, op2_2_, n801, op2_0_}), .OP_A(op1), .SEL(
        sel_alu), .IN_C(cy_psw), .IN_AC(out_psw_6_), .ALU(alu_a), .CY(cy), 
        .AC(ac), .OV(ov), .IN_B(in_b), .acc_chd(acc_chd) );
  AO22X4 U499 ( .A0(in_idat_r[7]), .A1(n399), .B0(ld_idat), .B1(in_idat_a[7]), 
        .Y(n519) );
  AO22X4 U500 ( .A0(in_idat_r[6]), .A1(n399), .B0(ld_idat), .B1(in_idat_a[6]), 
        .Y(n518) );
  AO22X4 U501 ( .A0(in_idat_r[5]), .A1(n399), .B0(ld_idat), .B1(in_idat_a[5]), 
        .Y(n517) );
  AO22X4 U502 ( .A0(in_idat_r[4]), .A1(n399), .B0(ld_idat), .B1(in_idat_a[4]), 
        .Y(n516) );
  AO22X4 U503 ( .A0(in_idat_r[3]), .A1(n399), .B0(ld_idat), .B1(in_idat_a[3]), 
        .Y(n515) );
  AO22X4 U504 ( .A0(in_idat_r[2]), .A1(n399), .B0(ld_idat), .B1(in_idat_a[2]), 
        .Y(n514) );
  AO22X4 U505 ( .A0(in_idat_r[1]), .A1(n399), .B0(ld_idat), .B1(in_idat_a[1]), 
        .Y(n513) );
  AO22X4 U506 ( .A0(in_idat_r[0]), .A1(n399), .B0(ld_idat), .B1(in_idat_a[0]), 
        .Y(n512) );
  MXI2X4 U642 ( .S0(n1457), .B(n1504), .A(out_psw_4_), .Y(n1455) );
  CLKINVX12 U643 ( .A(sel_addr0), .Y(n1457) );
  INVX4 U644 ( .A(n760), .Y(n762) );
  CLKINVX3 U645 ( .A(n1568), .Y(n613) );
  CLKINVX3 U646 ( .A(n675), .Y(n605) );
  NOR2X1 U647 ( .A(n493), .B(n1469), .Y(n1511) );
  NOR2X4 U648 ( .A(n1471), .B(n607), .Y(n1486) );
  NOR2X2 U649 ( .A(n1556), .B(n1557), .Y(n1555) );
  NOR2X1 U650 ( .A(n766), .B(n1469), .Y(n1468) );
  INVX3 U651 ( .A(addr_a[7]), .Y(n755) );
  OR2X2 U652 ( .A(n597), .B(n1273), .Y(n560) );
  OR2X2 U653 ( .A(n597), .B(n1245), .Y(n561) );
  INVX4 U654 ( .A(n1499), .Y(n618) );
  NAND2X2 U655 ( .A(n1494), .B(n758), .Y(n562) );
  CLKINVX6 U656 ( .A(n1481), .Y(n1480) );
  NAND4BX4 U657 ( .AN(n877), .B(n878), .C(n879), .D(n880), .Y(n802) );
  NOR2X6 U658 ( .A(n762), .B(n1602), .Y(n1451) );
  INVX1 U659 ( .A(n984), .Y(n563) );
  INVX1 U660 ( .A(n1499), .Y(n564) );
  INVX4 U661 ( .A(n1455), .Y(addr2_a_4_) );
  CLKBUFX2 U662 ( .A(msb_a), .Y(addr_a[7]) );
  NOR3X1 U663 ( .A(n1466), .B(n1467), .C(n1468), .Y(n1465) );
  NOR2X2 U664 ( .A(n1470), .B(n783), .Y(n1467) );
  NAND2X6 U665 ( .A(n676), .B(n657), .Y(n1471) );
  NAND2X4 U666 ( .A(n1480), .B(n562), .Y(n1493) );
  NAND3BX4 U667 ( .AN(sel_addr1[1]), .B(n672), .C(n1562), .Y(n1473) );
  NAND3X4 U668 ( .A(n1553), .B(n1554), .C(n1555), .Y(n1552) );
  MXI2X4 U669 ( .S0(n657), .B(n1559), .A(n1558), .Y(n1553) );
  NAND2X2 U670 ( .A(n562), .B(addr2_a_4_), .Y(n1492) );
  INVX8 U671 ( .A(sel_addr1[1]), .Y(n1601) );
  NOR2X4 U672 ( .A(n1470), .B(n784), .Y(n1487) );
  NOR2X6 U673 ( .A(n1473), .B(n671), .Y(n670) );
  NOR2X8 U674 ( .A(n764), .B(n664), .Y(n1496) );
  INVX8 U675 ( .A(n1605), .Y(n1604) );
  NOR3X6 U676 ( .A(n764), .B(n1499), .C(n1497), .Y(n1502) );
  NOR2X4 U677 ( .A(n623), .B(n664), .Y(n1500) );
  NOR2X6 U678 ( .A(n667), .B(n665), .Y(n664) );
  NAND3X6 U679 ( .A(n1568), .B(n1562), .C(n1601), .Y(n667) );
  NAND3X8 U680 ( .A(n1568), .B(n1606), .C(n1601), .Y(n1470) );
  NAND4BX2 U681 ( .AN(n917), .B(n918), .C(n919), .D(n920), .Y(n801) );
  NOR2X8 U682 ( .A(n1471), .B(n790), .Y(n1499) );
  INVX4 U683 ( .A(sel_op1[0]), .Y(n1007) );
  NAND2X1 U684 ( .A(n853), .B(out_sfr_a[1]), .Y(n920) );
  INVX1 U685 ( .A(sel_op2[0]), .Y(n934) );
  INVX4 U686 ( .A(in_idat_a[5]), .Y(n881) );
  NAND2BX1 U687 ( .AN(n1602), .B(n50), .Y(n1063) );
  INVX12 U688 ( .A(in_idat_a[7]), .Y(n857) );
  NOR2X1 U689 ( .A(n959), .B(n960), .Y(n957) );
  NAND3X2 U690 ( .A(n1005), .B(n1006), .C(sel_op1[0]), .Y(n954) );
  NAND2X1 U691 ( .A(n735), .B(n705), .Y(n1052) );
  NOR2X2 U692 ( .A(out_dptr_r[1]), .B(n1621), .Y(n1600) );
  INVX6 U693 ( .A(in_idat_a[4]), .Y(n892) );
  NOR2X1 U694 ( .A(n910), .B(n911), .Y(n908) );
  NOR2X1 U695 ( .A(n913), .B(n914), .Y(n907) );
  INVX6 U696 ( .A(in_idat_a[6]), .Y(n872) );
  AOI21X1 U697 ( .A0(out_sfr_r[5]), .A1(n1206), .B0(n1284), .Y(n1280) );
  NAND2BX1 U698 ( .AN(n1602), .B(n61), .Y(n1048) );
  CLKINVX1 U699 ( .A(n606), .Y(n607) );
  NOR2X1 U700 ( .A(n583), .B(n953), .Y(n999) );
  NOR2X1 U701 ( .A(n589), .B(n948), .Y(n680) );
  NOR2X1 U702 ( .A(n945), .B(n946), .Y(n943) );
  INVX1 U703 ( .A(n1030), .Y(n80) );
  NAND3X1 U704 ( .A(n1031), .B(n1032), .C(n1033), .Y(n1030) );
  NOR2X2 U705 ( .A(n922), .B(n923), .Y(n919) );
  NAND2X4 U706 ( .A(n1001), .B(n221), .Y(op1[0]) );
  NOR3X2 U707 ( .A(n1002), .B(n1003), .C(n1004), .Y(n1001) );
  NOR2X1 U708 ( .A(n940), .B(n954), .Y(n1002) );
  MXI2X2 U709 ( .S0(sel_addr0), .B(addr_bank_a[0]), .A(n1569), .Y(n1088) );
  OAI21X1 U710 ( .A0(n1222), .A1(n912), .B0(n1360), .Y(n1357) );
  OAI21X1 U711 ( .A0(n1222), .A1(n938), .B0(n1402), .Y(n1391) );
  OAI21X1 U712 ( .A0(n1216), .A1(n800), .B0(n1394), .Y(n1393) );
  INVX12 U713 ( .A(in_idat_a[2]), .Y(n912) );
  AOI21X1 U714 ( .A0(out_sfr_r[3]), .A1(n1206), .B0(n1328), .Y(n1324) );
  INVX12 U715 ( .A(in_idat_a[0]), .Y(n938) );
  NAND2X1 U716 ( .A(n732), .B(n1058), .Y(n1024) );
  NAND2X1 U717 ( .A(n1027), .B(n1028), .Y(n812) );
  CLKINVX3 U718 ( .A(in_xrom_a[1]), .Y(n928) );
  OR2X1 U719 ( .A(n984), .B(n944), .Y(n690) );
  INVX3 U720 ( .A(n1045), .Y(n54) );
  NAND3X2 U721 ( .A(n1046), .B(n1047), .C(n1048), .Y(n1045) );
  NAND3X2 U722 ( .A(n1061), .B(n1062), .C(n1063), .Y(n1060) );
  ADDFX2 U723 ( .A(out_acc_r[3]), .B(out_pc_r_3_), .CI(add_465_carry_3_), .S(
        a_plus_pc_3_), .CO(add_465_carry_4_) );
  CLKINVX1 U724 ( .A(n658), .Y(n1515) );
  XNOR2X1 U725 ( .A(out_dptr_r[4]), .B(n980), .Y(n1516) );
  AOI21X1 U726 ( .A0(n824), .A1(n825), .B0(n576), .Y(n823) );
  INVX3 U727 ( .A(n1602), .Y(n1016) );
  INVX1 U728 ( .A(n1066), .Y(n579) );
  AOI21X1 U729 ( .A0(n806), .A1(n807), .B0(n808), .Y(n805) );
  NOR2X1 U730 ( .A(n882), .B(n883), .Y(n878) );
  NAND4BX1 U731 ( .AN(n973), .B(n974), .C(n975), .D(n692), .Y(op1[4]) );
  NOR2X1 U732 ( .A(n976), .B(n977), .Y(n975) );
  NAND4BX1 U733 ( .AN(n955), .B(n956), .C(n957), .D(n678), .Y(op1[6]) );
  NOR2X1 U734 ( .A(n961), .B(n962), .Y(n956) );
  NAND4BX1 U735 ( .AN(n941), .B(n942), .C(n943), .D(n693), .Y(op1[7]) );
  NOR2X1 U736 ( .A(n949), .B(n950), .Y(n942) );
  NOR2X4 U737 ( .A(n730), .B(n729), .Y(n728) );
  AOI21X1 U738 ( .A0(out_sfr_r[7]), .A1(n1206), .B0(n1234), .Y(n1229) );
  DFFRHQX4 code_reg_0_ ( .D(n552), .CK(clk), .RN(n483), .Q(code[0]) );
  INVX3 U739 ( .A(n1620), .Y(n620) );
  OR2X1 U740 ( .A(n597), .B(n1294), .Y(n571) );
  OR2X1 U741 ( .A(n597), .B(n1317), .Y(n572) );
  OR2X1 U742 ( .A(n597), .B(n1338), .Y(n573) );
  OR2X1 U743 ( .A(n597), .B(n1362), .Y(n574) );
  AND3X4 U744 ( .A(n996), .B(n699), .C(n997), .Y(n575) );
  AND2X4 U745 ( .A(n1598), .B(n1531), .Y(n1597) );
  AND2X2 U746 ( .A(in_idat_r[3]), .B(n831), .Y(n592) );
  AND2X2 U747 ( .A(in_idat_r[6]), .B(n814), .Y(n593) );
  AND2X2 U748 ( .A(in_idat_r[5]), .B(n814), .Y(n594) );
  AND2X2 U749 ( .A(in_idat_r[2]), .B(n831), .Y(n595) );
  NAND2X4 U750 ( .A(n1459), .B(n1460), .Y(addr_a[3]) );
  NAND3X1 U751 ( .A(n1374), .B(n360), .C(n1361), .Y(n596) );
  NAND3X1 U752 ( .A(n360), .B(n1374), .C(sel_pc[2]), .Y(n597) );
  NAND3X1 U753 ( .A(sel_pc[0]), .B(n360), .C(n1361), .Y(n598) );
  OR2X1 U754 ( .A(n597), .B(n1157), .Y(n599) );
  OR2X1 U755 ( .A(n597), .B(n1169), .Y(n600) );
  OR2X1 U756 ( .A(n597), .B(n1180), .Y(n601) );
  CLKINVX8 U757 ( .A(n70), .Y(n726) );
  INVX20 U758 ( .A(n725), .Y(\out_idat0[4] ) );
  NOR2X8 U759 ( .A(n726), .B(n727), .Y(n725) );
  INVX3 U760 ( .A(n1036), .Y(n70) );
  INVX4 U761 ( .A(n54), .Y(n715) );
  CLKINVX6 U762 ( .A(n43), .Y(n723) );
  INVX3 U763 ( .A(n1060), .Y(n43) );
  NOR2BX4 U764 ( .AN(n1450), .B(sel_addr0), .Y(n1456) );
  INVX1 U765 ( .A(n645), .Y(n602) );
  INVX3 U766 ( .A(n1591), .Y(n645) );
  NAND4X2 U767 ( .A(n711), .B(n1485), .C(n650), .D(n1484), .Y(n603) );
  NAND4X2 U768 ( .A(n711), .B(n1485), .C(n650), .D(n1484), .Y(n611) );
  INVX3 U769 ( .A(n1068), .Y(msb_a) );
  MXI2X2 U770 ( .S0(n649), .B(n1563), .A(n1564), .Y(n1560) );
  INVX3 U771 ( .A(n1450), .Y(n1458) );
  NAND4X2 U772 ( .A(n604), .B(n1465), .C(n1464), .D(n1463), .Y(n1462) );
  OA22X4 U773 ( .A0(n659), .A1(n566), .B0(n1477), .B1(n1478), .Y(n604) );
  INVX8 U774 ( .A(n661), .Y(addr_a[2]) );
  BUFX16 U775 ( .A(sel_addr1[1]), .Y(n657) );
  INVX4 U776 ( .A(n675), .Y(n676) );
  NOR2X1 U777 ( .A(n484), .B(n621), .Y(n1573) );
  DFFRHQX1 addr2_r_reg_5_ ( .D(n762), .CK(clk), .RN(n483), .Q(n606) );
  NAND4X2 U778 ( .A(n654), .B(n1495), .C(n1496), .D(n618), .Y(n609) );
  NAND4X2 U779 ( .A(n654), .B(n1495), .C(n1496), .D(n564), .Y(n608) );
  NAND4X2 U780 ( .A(n654), .B(n1496), .C(n618), .D(n1495), .Y(n1449) );
  CLKINVX1 U781 ( .A(n619), .Y(n617) );
  NOR2BX4 U782 ( .AN(out_sp_r[7]), .B(n1477), .Y(n623) );
  NAND4X2 U783 ( .A(n1485), .B(n711), .C(n650), .D(n1484), .Y(n1483) );
  NAND2X4 U784 ( .A(n657), .B(n605), .Y(n621) );
  NAND2X2 U785 ( .A(n603), .B(n1457), .Y(n610) );
  CLKAND2X2 U786 ( .A(n1462), .B(n1457), .Y(n616) );
  NAND2X2 U787 ( .A(n1560), .B(n1561), .Y(n1559) );
  NOR3X4 U788 ( .A(n1453), .B(n1483), .C(sel_addr0), .Y(n1452) );
  NAND2X4 U789 ( .A(n1456), .B(n758), .Y(n1454) );
  MXI2X1 U790 ( .S0(n1602), .B(n1493), .A(n1088), .Y(addr_a[0]) );
  NAND4BX2 U791 ( .AN(n1570), .B(n712), .C(n1572), .D(n1571), .Y(n1569) );
  NOR3X2 U792 ( .A(n1573), .B(n1574), .C(n1575), .Y(n1572) );
  DFFRHQX4 code_reg_6_ ( .D(n558), .CK(clk), .RN(n483), .Q(code[6]) );
  DFFRHQX8 code_reg_7_ ( .D(n559), .CK(clk), .RN(n483), .Q(code[7]) );
  XNOR2X2 U793 ( .A(n646), .B(n1490), .Y(n1151) );
  NAND2BX4 U794 ( .AN(n1474), .B(n1151), .Y(n1484) );
  NOR2X6 U795 ( .A(n1597), .B(n1596), .Y(n614) );
  NOR2X1 U796 ( .A(n1597), .B(n1596), .Y(n1595) );
  NAND2X1 U797 ( .A(n1599), .B(n620), .Y(n615) );
  NAND3X2 U798 ( .A(sel_op1[2]), .B(n1005), .C(n1007), .Y(n947) );
  NAND3X2 U799 ( .A(sel_op1[2]), .B(n1005), .C(sel_op1[0]), .Y(n948) );
  INVX1 U800 ( .A(n667), .Y(n1503) );
  BUFX3 U801 ( .A(sel_addr1[0]), .Y(n619) );
  MXI2X4 U802 ( .S0(n1457), .B(n1517), .A(out_psw_3_), .Y(n1481) );
  NOR2X1 U803 ( .A(n578), .B(n1473), .Y(n1541) );
  NAND2X2 U804 ( .A(n1462), .B(n1457), .Y(n1053) );
  BUFX3 U805 ( .A(sel_addr1[0]), .Y(n672) );
  NAND2X2 U806 ( .A(n615), .B(n1534), .Y(n1594) );
  NOR2X2 U807 ( .A(n620), .B(n1599), .Y(n1596) );
  CLKBUFX2 U808 ( .A(n1616), .Y(addr_a[1]) );
  CLKINVX1 U809 ( .A(n1088), .Y(addr2_a_0_) );
  NAND2X4 U810 ( .A(out_dptr_r[2]), .B(out_acc_r[2]), .Y(n1532) );
  INVX2 U811 ( .A(n1532), .Y(n1531) );
  NAND2X4 U812 ( .A(n616), .B(n1461), .Y(n1460) );
  CLKINVX4 U813 ( .A(n1479), .Y(n1461) );
  INVX3 U814 ( .A(out_sfr_a[1]), .Y(n998) );
  INVX1 U815 ( .A(n1489), .Y(n625) );
  INVX1 U816 ( .A(out_dptr_r[1]), .Y(n626) );
  INVX1 U817 ( .A(n626), .Y(n627) );
  NOR3X6 U818 ( .A(n1486), .B(n1487), .C(n1488), .Y(n1485) );
  INVX1 U819 ( .A(n632), .Y(n628) );
  INVX1 U820 ( .A(out_dptr_r[0]), .Y(n629) );
  INVX1 U821 ( .A(n629), .Y(n630) );
  CLKBUFX2 U822 ( .A(n627), .Y(n631) );
  INVX1 U823 ( .A(n1622), .Y(n632) );
  INVX4 U824 ( .A(sel_addr1[2]), .Y(n1607) );
  CLKBUFX2 U825 ( .A(n1551), .Y(n633) );
  CLKBUFX2 U826 ( .A(n1613), .Y(addr_a[4]) );
  INVX4 U827 ( .A(n1069), .Y(addr2_a_2_) );
  CLKBUFX2 U828 ( .A(n620), .Y(n634) );
  XNOR2X1 U829 ( .A(n1565), .B(n1566), .Y(n1194) );
  NAND2X1 U830 ( .A(out_dptr_r[1]), .B(n1621), .Y(n1550) );
  NAND2X4 U831 ( .A(n620), .B(n1599), .Y(n1598) );
  NOR2X6 U832 ( .A(n1470), .B(n763), .Y(n764) );
  NAND2BX4 U833 ( .AN(n1600), .B(n635), .Y(n1551) );
  AND2X8 U834 ( .A(out_dptr_r[0]), .B(n1622), .Y(n635) );
  CLKBUFX2 U835 ( .A(code[5]), .Y(n636) );
  CLKBUFX2 U836 ( .A(n713), .Y(n637) );
  NAND2X2 U837 ( .A(n1068), .B(n1602), .Y(n1479) );
  NOR2X1 U838 ( .A(n621), .B(n487), .Y(n1522) );
  CLKBUFX2 U839 ( .A(code[6]), .Y(n641) );
  NOR2X4 U840 ( .A(n767), .B(n1469), .Y(n1488) );
  NOR2X6 U841 ( .A(n1469), .B(n765), .Y(n1497) );
  NAND2BX4 U842 ( .AN(out_dptr_r[2]), .B(n995), .Y(n1534) );
  CLKBUFX2 U843 ( .A(n628), .Y(out_acc_r[0]) );
  CLKBUFX2 U844 ( .A(n1621), .Y(out_acc_r[1]) );
  INVX1 U845 ( .A(n634), .Y(out_acc_r[3]) );
  INVX1 U846 ( .A(n602), .Y(n1475) );
  INVX1 U847 ( .A(n625), .Y(n646) );
  DFFRHQX8 code_reg_5_ ( .D(n557), .CK(clk), .RN(n483), .Q(code[5]) );
  INVX1 U848 ( .A(n1562), .Y(n648) );
  INVX1 U849 ( .A(n1606), .Y(n649) );
  OR2X4 U850 ( .A(n1473), .B(n581), .Y(n650) );
  DFFRHQX4 code_reg_3_ ( .D(n555), .CK(clk), .RN(n483), .Q(code[3]) );
  OAI21X4 U851 ( .A0(n1594), .A1(n713), .B0(n614), .Y(n1593) );
  AND2X8 U852 ( .A(n1551), .B(n1550), .Y(n713) );
  CLKBUFX2 U853 ( .A(n1129), .Y(n652) );
  DFFRHQX4 code_reg_2_ ( .D(n554), .CK(clk), .RN(n483), .Q(code[2]) );
  NAND3X2 U854 ( .A(n1005), .B(n1006), .C(n1007), .Y(n952) );
  NAND2X2 U855 ( .A(n853), .B(out_sfr_a[5]), .Y(n880) );
  AO22X1 U856 ( .A0(out_sfr_a[0]), .A1(ld_sfr), .B0(out_sfr_r[0]), .B1(n26), 
        .Y(n504) );
  NAND3X2 U857 ( .A(sel_op1[1]), .B(n1006), .C(n1007), .Y(n953) );
  NOR2X4 U858 ( .A(n1129), .B(n1497), .Y(n654) );
  CLKBUFX2 U859 ( .A(n1611), .Y(addr_a[5]) );
  NOR2X8 U860 ( .A(n709), .B(n662), .Y(n708) );
  MXI2X4 U861 ( .S0(sel_addr0), .B(addr_bank_a[1]), .A(n1552), .Y(n1093) );
  INVX1 U862 ( .A(n669), .Y(n656) );
  INVX12 U863 ( .A(n708), .Y(\out_idat0[7] ) );
  NOR2X1 U864 ( .A(n491), .B(n1469), .Y(n1542) );
  CLKINVX4 U865 ( .A(n1593), .Y(n674) );
  OAI21X1 U866 ( .A0(n637), .A1(n1594), .B0(n1595), .Y(n658) );
  MXI2X1 U867 ( .S0(n755), .B(N110), .A(N109), .Y(n400) );
  NOR2X1 U868 ( .A(n492), .B(n1469), .Y(n1524) );
  NOR2X1 U869 ( .A(n621), .B(n486), .Y(n1540) );
  NOR2X2 U870 ( .A(n1458), .B(sel_addr0), .Y(n1494) );
  INVX8 U871 ( .A(sel_addr1[2]), .Y(n1562) );
  INVX3 U872 ( .A(sel_op1[1]), .Y(n1005) );
  NOR2X1 U873 ( .A(n924), .B(n947), .Y(n681) );
  NAND2X2 U874 ( .A(n853), .B(out_sfr_a[2]), .Y(n909) );
  NAND4X4 U875 ( .A(n710), .B(n907), .C(n908), .D(n909), .Y(op2_2_) );
  NOR2X2 U876 ( .A(n1512), .B(n1513), .Y(n1507) );
  NOR2X1 U877 ( .A(n621), .B(n791), .Y(n1466) );
  NAND3X1 U878 ( .A(n617), .B(n1601), .C(n1562), .Y(n659) );
  NAND4X1 U879 ( .A(n654), .B(n1496), .C(n1495), .D(n618), .Y(n757) );
  DFFRHQX8 code_reg_1_ ( .D(n553), .CK(clk), .RN(n483), .Q(code[1]) );
  NOR2X1 U880 ( .A(n1473), .B(n577), .Y(n1523) );
  MXI2X4 U881 ( .S0(n1602), .B(n1482), .A(addr2_a_2_), .Y(n661) );
  OR2X4 U882 ( .A(n804), .B(n805), .Y(n662) );
  NAND2X8 U883 ( .A(n575), .B(n689), .Y(op1[1]) );
  OR2X4 U884 ( .A(n998), .B(n944), .Y(n689) );
  CLKBUFX2 U885 ( .A(n1498), .Y(n663) );
  NOR3X2 U886 ( .A(n1540), .B(n1541), .C(n1542), .Y(n1539) );
  AOI21X2 U887 ( .A0(n757), .A1(n668), .B0(n610), .Y(n1482) );
  INVX4 U888 ( .A(n1592), .Y(n1489) );
  INVX4 U889 ( .A(n1590), .Y(n1498) );
  AO22X1 U890 ( .A0(ld_instr), .A1(in_xrom_a[2]), .B0(code[2]), .B1(n408), .Y(
        n554) );
  ACHCINX4 U891 ( .A(out_dptr_r[6]), .B(out_acc_r[6]), .CIN(n645), .CO(n1590)
         );
  INVX8 U892 ( .A(n1607), .Y(n1606) );
  NAND2X4 U893 ( .A(n1604), .B(n1562), .Y(n675) );
  NAND4X4 U894 ( .A(n1227), .B(n1228), .C(n1229), .D(n3120), .Y(n39) );
  OAI2BB1X4 U895 ( .A0N(n1016), .A1N(n39), .B0(n579), .Y(n709) );
  NAND3X2 U896 ( .A(n1568), .B(n1606), .C(n657), .Y(n761) );
  NAND3X2 U897 ( .A(n1568), .B(n648), .C(n657), .Y(n1474) );
  CLKBUFX2 U898 ( .A(n1609), .Y(addr_a[6]) );
  NAND2X1 U899 ( .A(in_xrom_r[4]), .B(n1503), .Y(n1506) );
  NAND2BX2 U900 ( .AN(n761), .B(n1165), .Y(n1518) );
  NAND4X8 U901 ( .A(n721), .B(n897), .C(n898), .D(n899), .Y(n679) );
  NAND2X4 U902 ( .A(n853), .B(out_sfr_a[3]), .Y(n899) );
  NAND3X2 U903 ( .A(n1502), .B(n1500), .C(n1501), .Y(n668) );
  NAND3X2 U904 ( .A(n668), .B(n609), .C(n1457), .Y(n1068) );
  CLKBUFX2 U905 ( .A(addr2_a_2_), .Y(n669) );
  NAND2X2 U906 ( .A(n1450), .B(n1449), .Y(n1453) );
  NAND3X6 U907 ( .A(n1502), .B(n1500), .C(n1501), .Y(n1450) );
  AOI21X2 U908 ( .A0(n1450), .A1(n608), .B0(n1016), .Y(n1448) );
  NOR2X4 U909 ( .A(n1448), .B(n1053), .Y(n1609) );
  NOR3X2 U910 ( .A(n1522), .B(n1524), .C(n1523), .Y(n1521) );
  NAND3X6 U911 ( .A(n1568), .B(n657), .C(n1562), .Y(n1477) );
  NOR2X2 U912 ( .A(n1543), .B(n1544), .Y(n1538) );
  INVX4 U913 ( .A(sel_addr1[0]), .Y(n1605) );
  OR2X1 U914 ( .A(n1069), .B(n1016), .Y(n731) );
  NAND4X2 U915 ( .A(n1539), .B(n1537), .C(n1538), .D(n1536), .Y(n1535) );
  DFFRHQX4 code_reg_4_ ( .D(n556), .CK(clk), .RN(n483), .Q(code[4]) );
  NOR2X1 U916 ( .A(n787), .B(n1470), .Y(n1543) );
  NAND3X2 U917 ( .A(n1568), .B(n1562), .C(n657), .Y(n756) );
  NOR2X1 U918 ( .A(n785), .B(n1470), .Y(n1512) );
  INVX12 U919 ( .A(n1604), .Y(n1568) );
  NOR2X6 U920 ( .A(n738), .B(n670), .Y(n1495) );
  NAND4X2 U921 ( .A(n1508), .B(n1506), .C(n1507), .D(n1505), .Y(n1504) );
  NAND4X2 U922 ( .A(n1495), .B(n654), .C(n1496), .D(n618), .Y(n758) );
  NOR2X1 U923 ( .A(n786), .B(n1470), .Y(n1525) );
  NOR2X6 U924 ( .A(n1451), .B(n1452), .Y(n1611) );
  NOR2X1 U925 ( .A(n1477), .B(n1527), .Y(n1526) );
  NAND2X2 U926 ( .A(n1479), .B(n1480), .Y(n1459) );
  MXI2X4 U927 ( .S0(sel_addr0), .B(addr_bank_a[2]), .A(n1535), .Y(n1069) );
  NOR2BX4 U928 ( .AN(n1474), .B(n670), .Y(n1501) );
  DFFQX1 int_vec1_reg_2_ ( .D(int_vec[2]), .CK(clk), .Q(int_vec1[2]) );
  DFFQX1 int_vec1_reg_1_ ( .D(int_vec[1]), .CK(clk), .Q(int_vec1[1]) );
  DFFQX1 int_vec1_reg_0_ ( .D(int_vec[0]), .CK(clk), .Q(int_vec1[0]) );
  DFFQX1 int_vec2_reg_2_ ( .D(int_vec1[2]), .CK(clk), .Q(int_vec2[2]) );
  DFFQX1 int_vec2_reg_1_ ( .D(int_vec1[1]), .CK(clk), .Q(int_vec2[1]) );
  DFFQX1 int_vec2_reg_0_ ( .D(int_vec1[0]), .CK(clk), .Q(int_vec2[0]) );
  OR2X1 U929 ( .A(n928), .B(n954), .Y(n699) );
  NOR2X2 U930 ( .A(n999), .B(n1000), .Y(n996) );
  NOR2X1 U931 ( .A(n680), .B(n681), .Y(n997) );
  CLKINVX1 U932 ( .A(sel_op2[2]), .Y(n939) );
  OR2X8 U933 ( .A(n822), .B(n823), .Y(n727) );
  INVX12 U934 ( .A(n722), .Y(\out_idat0[6] ) );
  INVX4 U935 ( .A(n80), .Y(n729) );
  INVX12 U936 ( .A(n728), .Y(\out_idat0[3] ) );
  DFFRX1 out_sfr_r_reg_3_ ( .D(n507), .CK(clk), .RN(n483), .Q(out_sfr_r[3]), 
        .QN(n588) );
  DFFRX1 out_sfr_r_reg_2_ ( .D(n506), .CK(clk), .RN(n483), .Q(out_sfr_r[2]), 
        .QN(n586) );
  INVX3 U937 ( .A(out_dptr_r[3]), .Y(n1599) );
  NAND4BBX1 U938 ( .AN(n741), .BN(n742), .C(n1324), .D(n344), .Y(n86) );
  CLKAND2X3 U939 ( .A(sel_combus[3]), .B(n1399), .Y(n696) );
  NAND2X2 U940 ( .A(n733), .B(n732), .Y(n819) );
  NOR2BX1 U941 ( .AN(out_acc_r[1]), .B(n952), .Y(n1000) );
  NAND2X1 U942 ( .A(n694), .B(n697), .Y(n1221) );
  NAND2X1 U943 ( .A(n688), .B(n695), .Y(n1220) );
  CLKINVX1 U944 ( .A(n1208), .Y(n1260) );
  NAND3X1 U945 ( .A(n835), .B(n821), .C(n807), .Y(n834) );
  CLKINVX2 U946 ( .A(n834), .Y(n824) );
  NAND2X1 U947 ( .A(n824), .B(n820), .Y(n831) );
  CLKAND2X3 U948 ( .A(sel_combus[0]), .B(n1400), .Y(n702) );
  NOR3X2 U949 ( .A(n1070), .B(n1071), .C(n1072), .Y(n221) );
  CLKINVX2 U950 ( .A(n921), .Y(n853) );
  INVX1 U951 ( .A(sel_combus[2]), .Y(n1399) );
  AND2X1 U952 ( .A(sel_combus[2]), .B(n1398), .Y(n694) );
  CLKAND2X3 U953 ( .A(n1400), .B(n1401), .Y(n697) );
  NOR2X2 U954 ( .A(n931), .B(n932), .Y(n930) );
  NAND4X1 U955 ( .A(n1195), .B(n1196), .C(n1197), .D(n291), .Y(n104) );
  NAND2X1 U956 ( .A(n1050), .B(n1052), .Y(n836) );
  NOR2X2 U957 ( .A(n936), .B(n937), .Y(n929) );
  CLKINVX1 U958 ( .A(out_sp_r[5]), .Y(n1491) );
  INVX1 U959 ( .A(n294), .Y(n1200) );
  INVX1 U960 ( .A(n1198), .Y(n291) );
  CLKAND2X6 U961 ( .A(n1398), .B(n1399), .Y(n688) );
  INVX1 U962 ( .A(n836), .Y(n807) );
  NOR2X2 U963 ( .A(n817), .B(n818), .Y(n806) );
  NAND3X1 U964 ( .A(n819), .B(n820), .C(n821), .Y(n818) );
  NAND2X1 U965 ( .A(n705), .B(n704), .Y(n816) );
  INVX1 U966 ( .A(n106), .Y(n1089) );
  NAND2X1 U967 ( .A(n733), .B(n735), .Y(n821) );
  INVX8 U968 ( .A(n714), .Y(\out_idat0[5] ) );
  INVX2 U969 ( .A(n1012), .Y(n89) );
  OAI21X1 U970 ( .A0(n1201), .A1(n896), .B0(n1306), .Y(n3370) );
  INVX1 U971 ( .A(out_acc_r[6]), .Y(n963) );
  NAND4X2 U972 ( .A(n1345), .B(n1346), .C(n1347), .D(n352), .Y(n93) );
  NAND3X1 U973 ( .A(sel_op2[0]), .B(n939), .C(sel_op2[1]), .Y(n865) );
  INVX3 U974 ( .A(n1270), .Y(n1206) );
  NAND2X1 U975 ( .A(n697), .B(n696), .Y(n1214) );
  NAND2X1 U976 ( .A(n806), .B(n816), .Y(n814) );
  AND2X2 U977 ( .A(sel_combus[1]), .B(n1401), .Y(n695) );
  INVX1 U978 ( .A(n1041), .Y(n848) );
  INVX1 U979 ( .A(n1038), .Y(n76) );
  INVX3 U980 ( .A(sel_combus[0]), .Y(n1401) );
  NAND2X1 U981 ( .A(n735), .B(n1058), .Y(n1026) );
  NAND2X1 U982 ( .A(n1058), .B(n704), .Y(n1011) );
  NAND2X1 U983 ( .A(n735), .B(n1057), .Y(n1028) );
  NAND2X1 U984 ( .A(n1057), .B(n704), .Y(n1025) );
  AND2X1 U985 ( .A(sel_combus[0]), .B(sel_combus[1]), .Y(n701) );
  NOR2X1 U986 ( .A(n938), .B(n947), .Y(n1072) );
  NOR2X1 U987 ( .A(n591), .B(n948), .Y(n1071) );
  CLKINVX8 U988 ( .A(in_xrom_a[7]), .Y(n864) );
  CLKINVX6 U989 ( .A(in_xrom_a[5]), .Y(n885) );
  CLKINVX6 U990 ( .A(in_xrom_a[4]), .Y(n896) );
  CLKINVX6 U991 ( .A(in_xrom_a[6]), .Y(n876) );
  CLKINVX6 U992 ( .A(in_xrom_a[3]), .Y(n906) );
  NOR2X1 U993 ( .A(n1222), .B(n872), .Y(n1261) );
  NOR2X1 U994 ( .A(n1222), .B(n892), .Y(n1307) );
  INVX1 U995 ( .A(n1051), .Y(n1046) );
  INVX1 U996 ( .A(n1065), .Y(n1061) );
  INVX1 U997 ( .A(out_b[0]), .Y(n933) );
  NOR3X1 U998 ( .A(n1357), .B(n1358), .C(n1359), .Y(n1345) );
  NOR3X1 U999 ( .A(n1352), .B(n1353), .C(n1354), .Y(n1346) );
  CLKXOR2X1 U1000 ( .A(n1581), .B(out_dptr_r[15]), .Y(n1250) );
  INVX1 U1001 ( .A(n1265), .Y(n1224) );
  INVX1 U1002 ( .A(n1221), .Y(n1390) );
  INVX1 U1003 ( .A(n1212), .Y(n1397) );
  INVX1 U1004 ( .A(n840), .Y(n844) );
  NAND3X1 U1005 ( .A(n934), .B(n939), .C(sel_op2[1]), .Y(n921) );
  INVX1 U1006 ( .A(sel_op2[1]), .Y(n935) );
  INVX4 U1007 ( .A(sel_op1[2]), .Y(n1006) );
  NAND2X1 U1008 ( .A(n688), .B(n697), .Y(n1265) );
  INVX1 U1009 ( .A(n1232), .Y(n1203) );
  NAND2X1 U1010 ( .A(n694), .B(n695), .Y(n1212) );
  INVX1 U1011 ( .A(n816), .Y(n837) );
  NAND2X1 U1012 ( .A(n845), .B(n846), .Y(n840) );
  INVX1 U1013 ( .A(n817), .Y(n825) );
  OR2X4 U1014 ( .A(n992), .B(n944), .Y(n677) );
  NAND2X2 U1015 ( .A(n694), .B(n701), .Y(n1216) );
  INVX1 U1016 ( .A(n812), .Y(n810) );
  CLKINVX1 U1017 ( .A(sel_combus[1]), .Y(n1400) );
  NAND2X1 U1018 ( .A(n688), .B(n701), .Y(n1208) );
  NOR2X1 U1019 ( .A(n829), .B(n1056), .Y(n809) );
  NAND3X1 U1020 ( .A(n1026), .B(n1041), .C(n1024), .Y(n1056) );
  NAND2X2 U1021 ( .A(n1018), .B(n1020), .Y(n817) );
  NOR2X1 U1022 ( .A(n812), .B(n1023), .Y(n826) );
  NAND2X1 U1023 ( .A(n1011), .B(n1008), .Y(n829) );
  INVX1 U1024 ( .A(sel_combus[3]), .Y(n1398) );
  INVX1 U1025 ( .A(n1025), .Y(n847) );
  INVX1 U1026 ( .A(n820), .Y(n1040) );
  CLKINVX1 U1027 ( .A(sel_pc[2]), .Y(n1361) );
  INVX1 U1028 ( .A(sel_in_cy_bit[1]), .Y(n407) );
  INVX1 U1029 ( .A(out_sfr_a[2]), .Y(n992) );
  INVX3 U1030 ( .A(out_sfr_a[0]), .Y(n108) );
  NAND2X2 U1031 ( .A(n1037), .B(n76), .Y(n1036) );
  NOR2X1 U1032 ( .A(n1039), .B(n36), .Y(n1038) );
  INVX1 U1033 ( .A(out_sfr_a[3]), .Y(n984) );
  NOR2X1 U1034 ( .A(n970), .B(n971), .Y(n965) );
  NOR2X1 U1035 ( .A(n987), .B(n988), .Y(n982) );
  NOR2X1 U1036 ( .A(n978), .B(n979), .Y(n974) );
  OR2X1 U1037 ( .A(n958), .B(n944), .Y(n678) );
  NOR2X1 U1038 ( .A(n634), .B(n952), .Y(n988) );
  NAND2X1 U1039 ( .A(n734), .B(n1057), .Y(n1027) );
  NAND2X1 U1040 ( .A(n734), .B(n1058), .Y(n1008) );
  NAND2X1 U1041 ( .A(n732), .B(n705), .Y(n820) );
  NAND2X1 U1042 ( .A(n732), .B(n1057), .Y(n1041) );
  NAND2X1 U1043 ( .A(n733), .B(n704), .Y(n1018) );
  NAND2X1 U1044 ( .A(n734), .B(n705), .Y(n1050) );
  NAND2X1 U1045 ( .A(n733), .B(n734), .Y(n1020) );
  INVX1 U1046 ( .A(n111), .Y(n356) );
  INVX1 U1047 ( .A(n77), .Y(n75) );
  INVX1 U1048 ( .A(n400), .Y(bit_dat_in) );
  NOR2X2 U1049 ( .A(n890), .B(n891), .Y(n888) );
  OR2X1 U1050 ( .A(n916), .B(n865), .Y(n710) );
  NAND2BX2 U1051 ( .AN(n761), .B(n1178), .Y(n1536) );
  NOR2X2 U1052 ( .A(n925), .B(n926), .Y(n918) );
  OR2X2 U1053 ( .A(n594), .B(n815), .Y(n716) );
  OR2X2 U1054 ( .A(n593), .B(n813), .Y(n724) );
  NOR2X1 U1055 ( .A(n588), .B(n863), .Y(n903) );
  NOR2X1 U1056 ( .A(n578), .B(n856), .Y(n911) );
  NOR2X2 U1057 ( .A(n900), .B(n901), .Y(n898) );
  NOR2X2 U1058 ( .A(n870), .B(n871), .Y(n868) );
  NOR2X1 U1059 ( .A(n586), .B(n863), .Y(n913) );
  NOR2X1 U1060 ( .A(n582), .B(n856), .Y(n1073) );
  NOR2X1 U1061 ( .A(n912), .B(n858), .Y(n910) );
  NOR2X1 U1062 ( .A(n591), .B(n863), .Y(n931) );
  NAND4X1 U1063 ( .A(n1301), .B(n1302), .C(n1303), .D(n3360), .Y(n77) );
  NOR2X1 U1064 ( .A(n582), .B(n953), .Y(n1003) );
  OR2X2 U1065 ( .A(n592), .B(n830), .Y(n730) );
  CLKAND2X3 U1066 ( .A(n719), .B(n720), .Y(n879) );
  NOR2X1 U1067 ( .A(n842), .B(n843), .Y(n841) );
  INVX2 U1068 ( .A(n1075), .Y(n11000) );
  NOR2X1 U1069 ( .A(n595), .B(n833), .Y(n832) );
  NOR2X2 U1070 ( .A(n985), .B(n986), .Y(n983) );
  NOR2X2 U1071 ( .A(n968), .B(n969), .Y(n966) );
  NOR2X2 U1072 ( .A(n854), .B(n855), .Y(n851) );
  NAND3X1 U1073 ( .A(n1380), .B(n369), .C(n371), .Y(n111) );
  NOR3X1 U1074 ( .A(n1391), .B(n1392), .C(n1393), .Y(n1380) );
  INVX1 U1075 ( .A(sel_bit_dat_out[0]), .Y(n1095) );
  NAND2X1 U1076 ( .A(sel_bit_dat_out[1]), .B(n1098), .Y(n1094) );
  NAND2X2 U1077 ( .A(n1095), .B(n1097), .Y(n1096) );
  INVX1 U1078 ( .A(n93), .Y(n1174) );
  INVX1 U1079 ( .A(n104), .Y(n284) );
  NAND4BX1 U1080 ( .AN(n1249), .B(n1225), .C(n561), .D(n1226), .Y(in_pc[15])
         );
  CLKINVX6 U1081 ( .A(in_xrom_a[2]), .Y(n916) );
  NOR2X1 U1082 ( .A(n1220), .B(n568), .Y(n1310) );
  NOR2X1 U1083 ( .A(n963), .B(n1265), .Y(n1262) );
  INVX1 U1084 ( .A(n61), .Y(n266) );
  INVX1 U1085 ( .A(n86), .Y(n278) );
  NOR3X1 U1086 ( .A(n3290), .B(n1281), .C(n1282), .Y(n328) );
  NOR2X1 U1087 ( .A(n1205), .B(n771), .Y(n1281) );
  NOR3X1 U1088 ( .A(n3130), .B(n1230), .C(n1231), .Y(n3120) );
  NOR2X1 U1089 ( .A(n1205), .B(n769), .Y(n1230) );
  NOR3X2 U1090 ( .A(n1240), .B(n1241), .C(n1242), .Y(n1227) );
  NOR3X2 U1091 ( .A(n1509), .B(n1510), .C(n1511), .Y(n1508) );
  NOR2X2 U1092 ( .A(n1525), .B(n1526), .Y(n1520) );
  NOR2BX4 U1093 ( .AN(out_sp_r[7]), .B(n1477), .Y(n738) );
  NAND4BBX2 U1094 ( .AN(n739), .BN(n740), .C(n1280), .D(n328), .Y(n61) );
  OR4X2 U1095 ( .A(n1290), .B(n1291), .C(n1292), .D(n1293), .Y(n739) );
  NAND2X1 U1096 ( .A(in_idat_r[5]), .B(n1049), .Y(n1047) );
  NAND2X1 U1097 ( .A(in_idat_r[6]), .B(n1064), .Y(n1062) );
  ACHCINX4 U1098 ( .A(out_dptr_r[4]), .B(out_acc_r[4]), .CIN(n674), .CO(n1592)
         );
  NOR3X1 U1099 ( .A(n345), .B(n1325), .C(n1326), .Y(n344) );
  NOR2X1 U1100 ( .A(n1205), .B(n772), .Y(n1304) );
  INVX1 U1101 ( .A(out_b[4]), .Y(n895) );
  NOR2X1 U1102 ( .A(n861), .B(n927), .Y(n926) );
  CLKINVX1 U1103 ( .A(out_b[1]), .Y(n927) );
  NOR2X1 U1104 ( .A(n861), .B(n915), .Y(n914) );
  INVX1 U1105 ( .A(out_b[2]), .Y(n915) );
  XNOR2X1 U1106 ( .A(out_dptr_r[3]), .B(n634), .Y(n1529) );
  NOR2X2 U1107 ( .A(n1530), .B(n1531), .Y(n1528) );
  NOR2X2 U1108 ( .A(n1548), .B(n1549), .Y(n1546) );
  NOR2X1 U1109 ( .A(n861), .B(n933), .Y(n932) );
  NOR2BX1 U1110 ( .AN(n628), .B(n952), .Y(n1004) );
  OR4X2 U1111 ( .A(n1334), .B(n1335), .C(n1336), .D(n1337), .Y(n741) );
  CLKINVX1 U1112 ( .A(n1035), .Y(n1031) );
  INVX3 U1113 ( .A(out_sp_r[0]), .Y(n1578) );
  INVX1 U1114 ( .A(out_acc_r[5]), .Y(n972) );
  CLKINVX8 U1115 ( .A(out_acc_r[7]), .Y(n951) );
  INVX1 U1116 ( .A(out_b[7]), .Y(n862) );
  NOR3X1 U1117 ( .A(n353), .B(n1348), .C(n1349), .Y(n352) );
  NOR3X2 U1118 ( .A(n1217), .B(n1218), .C(n1219), .Y(n1195) );
  AOI21X1 U1119 ( .A0(out_sfr_r[1]), .A1(n1206), .B0(n1207), .Y(n1197) );
  NAND3X1 U1120 ( .A(n1076), .B(n1077), .C(n1078), .Y(n1075) );
  INVX1 U1121 ( .A(n1080), .Y(n1076) );
  NAND3X1 U1122 ( .A(n1013), .B(n1014), .C(n1015), .Y(n1012) );
  INVX1 U1123 ( .A(n1019), .Y(n1013) );
  AND2X2 U1124 ( .A(in_idat_r[1]), .B(n1079), .Y(n743) );
  NAND2X1 U1125 ( .A(n1382), .B(n1383), .Y(n1381) );
  INVX3 U1126 ( .A(out_sp_r[6]), .Y(n1478) );
  INVX1 U1127 ( .A(in_idat_r[7]), .Y(n808) );
  NOR2X1 U1128 ( .A(n1216), .B(n793), .Y(n1235) );
  NOR2X1 U1129 ( .A(n1214), .B(n1239), .Y(n1236) );
  NAND3X1 U1130 ( .A(n1387), .B(n1388), .C(n1389), .Y(n1386) );
  NOR2X1 U1131 ( .A(n1216), .B(n794), .Y(n1268) );
  NOR2X1 U1132 ( .A(n1216), .B(n796), .Y(n1313) );
  NOR2X1 U1133 ( .A(n1214), .B(n1272), .Y(n1266) );
  NOR2X1 U1134 ( .A(n1214), .B(n1316), .Y(n1311) );
  NOR2X1 U1135 ( .A(n1216), .B(n795), .Y(n1285) );
  NOR2X1 U1136 ( .A(n1214), .B(n1289), .Y(n1286) );
  OAI21X1 U1137 ( .A0(n1214), .A1(n1395), .B0(n1396), .Y(n1392) );
  NOR2X1 U1138 ( .A(n1212), .B(n1238), .Y(n1237) );
  NOR2X1 U1139 ( .A(n1212), .B(n1288), .Y(n1287) );
  NOR2X1 U1140 ( .A(n1212), .B(n1271), .Y(n1267) );
  NOR2X1 U1141 ( .A(n1212), .B(n1315), .Y(n1312) );
  OAI2BB1X1 U1142 ( .A0N(n409), .A1N(a_plus_dptr_15_), .B0(n682), .Y(
        addr_xrom_a[15]) );
  AOI22X1 U1143 ( .A0(a_plus_pc_15_), .A1(ld_apc), .B0(n411), .B1(out_pc_r_15_), .Y(n682) );
  OAI2BB1X1 U1144 ( .A0N(n409), .A1N(n684), .B0(n683), .Y(addr_xrom_a[14]) );
  AOI22X1 U1145 ( .A0(a_plus_pc_14_), .A1(ld_apc), .B0(n411), .B1(out_pc_r_14_), .Y(n683) );
  AND2X2 U1146 ( .A(add_465_carry_14_), .B(out_pc_r_14_), .Y(add_465_carry_15_) );
  AND2X2 U1147 ( .A(add_465_carry_8_), .B(out_pc_r_8_), .Y(add_465_carry_9_)
         );
  AND2X2 U1148 ( .A(add_465_carry_9_), .B(out_pc_r_9_), .Y(add_465_carry_10_)
         );
  AND2X2 U1149 ( .A(add_465_carry_10_), .B(out_pc_r_10_), .Y(add_465_carry_11_) );
  AND2X2 U1150 ( .A(add_465_carry_11_), .B(out_pc_r_11_), .Y(add_465_carry_12_) );
  AND2X2 U1151 ( .A(add_465_carry_12_), .B(out_pc_r_12_), .Y(add_465_carry_13_) );
  AND2X2 U1152 ( .A(add_465_carry_13_), .B(out_pc_r_13_), .Y(add_465_carry_14_) );
  INVX1 U1153 ( .A(N327), .Y(n1447) );
  INVX1 U1154 ( .A(add_434_carry_2_), .Y(n1443) );
  XNOR2X1 U1155 ( .A(n1583), .B(out_dptr_r[14]), .Y(n684) );
  AO21X1 U1156 ( .A0(out_acc_r[4]), .A1(n12), .B0(n685), .Y(out_xdat[4]) );
  AO22X1 U1157 ( .A0(out_dptr_r[4]), .A1(n706), .B0(in_idat_r[4]), .B1(n15), 
        .Y(n685) );
  AO21X1 U1158 ( .A0(out_acc_r[5]), .A1(n12), .B0(n686), .Y(out_xdat[5]) );
  AO22X1 U1159 ( .A0(out_dptr_r[5]), .A1(n706), .B0(in_idat_r[5]), .B1(n15), 
        .Y(n686) );
  AO21X1 U1160 ( .A0(out_acc_r[6]), .A1(n12), .B0(n687), .Y(out_xdat[6]) );
  AO22X1 U1161 ( .A0(out_dptr_r[6]), .A1(n706), .B0(in_idat_r[6]), .B1(n15), 
        .Y(n687) );
  AO22X1 U1162 ( .A0(out_sfr_a[7]), .A1(ld_sfr), .B0(out_sfr_r[7]), .B1(n26), 
        .Y(n511) );
  AO22X1 U1163 ( .A0(in_xrom_r[0]), .A1(n250), .B0(ld_xrom), .B1(in_xrom_a[0]), 
        .Y(n528) );
  AO22X1 U1164 ( .A0(in_xrom_r[7]), .A1(n250), .B0(ld_xrom), .B1(in_xrom_a[7]), 
        .Y(n535) );
  AO22X1 U1165 ( .A0(ld_operand2), .A1(in_xrom_a[7]), .B0(in_xrom1_r[7]), .B1(
        n251), .Y(n527) );
  DFFQX1 int_vec3_reg_0_ ( .D(int_vec2[0]), .CK(clk), .Q(int_vec3[0]) );
  NAND3X1 U1166 ( .A(n934), .B(sel_op2[2]), .C(n935), .Y(n861) );
  NAND3X1 U1167 ( .A(sel_op2[0]), .B(sel_op2[2]), .C(n935), .Y(n863) );
  NAND3X1 U1168 ( .A(sel_op2[0]), .B(n939), .C(n935), .Y(n856) );
  NAND3X1 U1169 ( .A(n934), .B(n939), .C(n935), .Y(n858) );
  CLKINVX1 U1170 ( .A(n1119), .Y(n1102) );
  INVX16 U1171 ( .A(n1603), .Y(n1602) );
  CLKINVX8 U1172 ( .A(bit_addr), .Y(n1603) );
  NAND3X1 U1173 ( .A(sel_op1[1]), .B(n1006), .C(sel_op1[0]), .Y(n944) );
  NAND2X1 U1174 ( .A(n696), .B(n695), .Y(n1201) );
  NOR2X1 U1175 ( .A(n829), .B(n812), .Y(n845) );
  NOR2X1 U1176 ( .A(n847), .B(n848), .Y(n846) );
  NOR2X1 U1177 ( .A(n1040), .B(n848), .Y(n1039) );
  NAND2X1 U1178 ( .A(n1086), .B(n1087), .Y(n1079) );
  NOR2X1 U1179 ( .A(n837), .B(n1040), .Y(n1087) );
  NOR2X1 U1180 ( .A(n817), .B(n836), .Y(n1086) );
  CLKINVX1 U1181 ( .A(n427), .Y(n411) );
  NAND2BX1 U1182 ( .AN(ld_adptr), .B(n428), .Y(n427) );
  CLKINVX1 U1183 ( .A(n429), .Y(n409) );
  NAND2BX1 U1184 ( .AN(ld_apc), .B(ld_adptr), .Y(n429) );
  CLKINVX1 U1185 ( .A(ld_apc), .Y(n428) );
  CLKINVX1 U1186 ( .A(sel_xad), .Y(n12) );
  NAND3X1 U1187 ( .A(n1374), .B(sel_pc[1]), .C(n1361), .Y(n1123) );
  NAND3X1 U1188 ( .A(sel_pc[1]), .B(sel_pc[0]), .C(n1361), .Y(n1119) );
  CLKINVX1 U1189 ( .A(sel_pc[0]), .Y(n1374) );
  CLKINVX1 U1190 ( .A(n1147), .Y(n1159) );
  CLKINVX1 U1191 ( .A(ld_xrom), .Y(n250) );
  CLKINVX1 U1192 ( .A(ld_sfr), .Y(n26) );
  CLKINVX1 U1193 ( .A(ld_latch_acc), .Y(n249) );
  CLKINVX1 U1194 ( .A(ld_operand2), .Y(n251) );
  CLKINVX1 U1195 ( .A(sel_in_cy_bit[2]), .Y(n1410) );
  NOR2X1 U1196 ( .A(n108), .B(n944), .Y(n1070) );
  NOR2X1 U1197 ( .A(n108), .B(n921), .Y(n1074) );
  OR2X1 U1198 ( .A(n967), .B(n944), .Y(n691) );
  OR2X1 U1199 ( .A(n828), .B(n944), .Y(n692) );
  OR2X1 U1200 ( .A(n811), .B(n944), .Y(n693) );
  NAND3X1 U1201 ( .A(n697), .B(sel_combus[3]), .C(sel_combus[2]), .Y(n1205) );
  NAND2X1 U1202 ( .A(n701), .B(n696), .Y(n1232) );
  NAND2X2 U1203 ( .A(n688), .B(n702), .Y(n1222) );
  AOI21X1 U1204 ( .A0(n826), .A1(n827), .B0(n828), .Y(n822) );
  INVX1 U1205 ( .A(n829), .Y(n827) );
  AOI21X1 U1206 ( .A0(n809), .A1(n810), .B0(n811), .Y(n804) );
  NAND2X1 U1207 ( .A(n694), .B(n702), .Y(n1270) );
  NAND3X1 U1208 ( .A(n1024), .B(n1025), .C(n1026), .Y(n1023) );
  NOR2X1 U1209 ( .A(n1024), .B(n998), .Y(n1085) );
  AND2X1 U1210 ( .A(n702), .B(n696), .Y(n698) );
  NOR2X1 U1211 ( .A(n1208), .B(n811), .Y(n1234) );
  NOR2X1 U1212 ( .A(n1208), .B(n967), .Y(n1284) );
  NOR2X1 U1213 ( .A(n1208), .B(n984), .Y(n1328) );
  NOR2X1 U1214 ( .A(n1208), .B(n992), .Y(n1351) );
  NOR2X1 U1215 ( .A(n1208), .B(n998), .Y(n1207) );
  INVX1 U1216 ( .A(n819), .Y(n838) );
  NOR2X1 U1217 ( .A(n837), .B(n838), .Y(n835) );
  INVX1 U1218 ( .A(n1018), .Y(n1017) );
  INVX1 U1219 ( .A(n1050), .Y(n1049) );
  INVX1 U1220 ( .A(n1020), .Y(n1034) );
  INVX1 U1221 ( .A(n1052), .Y(n1064) );
  CLKINVX1 U1222 ( .A(n362), .Y(n258) );
  CLKINVX1 U1223 ( .A(sel_pc[1]), .Y(n360) );
  NAND3X1 U1224 ( .A(sel_pc[1]), .B(n1374), .C(sel_pc[2]), .Y(n1147) );
  CLKINVX1 U1225 ( .A(sel_in_cy_bit[0]), .Y(n1406) );
  CLKINVX1 U1226 ( .A(ld_idat), .Y(n399) );
  NAND2X1 U1227 ( .A(alu_a[7]), .B(n698), .Y(n1233) );
  NOR2X1 U1228 ( .A(n906), .B(n954), .Y(n981) );
  NOR2X1 U1229 ( .A(n885), .B(n954), .Y(n964) );
  NOR2X1 U1230 ( .A(n876), .B(n954), .Y(n955) );
  NOR2X1 U1231 ( .A(n916), .B(n954), .Y(n989) );
  NOR2X2 U1232 ( .A(n993), .B(n994), .Y(n990) );
  NOR2X1 U1233 ( .A(n896), .B(n954), .Y(n973) );
  NOR2X1 U1234 ( .A(n940), .B(n865), .Y(n936) );
  NAND2X2 U1235 ( .A(n853), .B(out_sfr_a[6]), .Y(n869) );
  NAND2X2 U1236 ( .A(n853), .B(out_sfr_a[4]), .Y(n889) );
  NAND2X2 U1237 ( .A(n853), .B(out_sfr_a[7]), .Y(n852) );
  NAND2BX1 U1238 ( .AN(n1602), .B(n77), .Y(n1037) );
  INVX1 U1239 ( .A(out_sfr_a[5]), .Y(n967) );
  NAND2X1 U1240 ( .A(alu_a[5]), .B(n698), .Y(n1283) );
  INVX1 U1241 ( .A(out_sfr_a[4]), .Y(n828) );
  NAND2X1 U1242 ( .A(alu_a[6]), .B(n698), .Y(n1259) );
  NAND2X1 U1243 ( .A(alu_a[4]), .B(n698), .Y(n1306) );
  INVX1 U1244 ( .A(out_sfr_a[6]), .Y(n958) );
  NOR2X1 U1245 ( .A(n864), .B(n954), .Y(n941) );
  OAI2BB2X1 U1246 ( .A0N(out_sfr_a[5]), .A1N(n1042), .B0(n36), .B1(n1028), .Y(
        n815) );
  NAND2X1 U1247 ( .A(n1043), .B(n809), .Y(n1042) );
  NOR2X1 U1248 ( .A(n847), .B(n1044), .Y(n1043) );
  INVX1 U1249 ( .A(n1027), .Y(n1044) );
  OAI2BB2X1 U1250 ( .A0N(out_sfr_a[6]), .A1N(n1054), .B0(n36), .B1(n1027), .Y(
        n813) );
  NAND2X1 U1251 ( .A(n1055), .B(n809), .Y(n1054) );
  NOR2X1 U1252 ( .A(n847), .B(n1059), .Y(n1055) );
  INVX1 U1253 ( .A(n1028), .Y(n1059) );
  NAND3BX1 U1254 ( .AN(n1139), .B(n1140), .C(n1141), .Y(in_pc[5]) );
  NOR4X1 U1255 ( .A(n1142), .B(n1143), .C(n1144), .D(n1145), .Y(n1141) );
  NAND3X1 U1256 ( .A(n1130), .B(n1131), .C(n1132), .Y(in_pc[6]) );
  NOR3X1 U1257 ( .A(n1133), .B(n1134), .C(n1135), .Y(n1131) );
  NAND3X1 U1258 ( .A(n1120), .B(n1121), .C(n1122), .Y(in_pc[7]) );
  NOR3X1 U1259 ( .A(n1124), .B(n1125), .C(n1126), .Y(n1121) );
  NAND2X1 U1260 ( .A(sel_bit_dat_out[1]), .B(n400), .Y(n1097) );
  INVX1 U1261 ( .A(out_sfr_a[7]), .Y(n811) );
  NAND2X1 U1262 ( .A(alu_a[3]), .B(n698), .Y(n1327) );
  NAND2X1 U1263 ( .A(alu_a[2]), .B(n698), .Y(n1350) );
  OAI2BB2X1 U1264 ( .A0N(n563), .A1N(n1021), .B0(n36), .B1(n1011), .Y(n830) );
  NAND2X1 U1265 ( .A(n1022), .B(n826), .Y(n1021) );
  NOR2X1 U1266 ( .A(n848), .B(n1029), .Y(n1022) );
  INVX1 U1267 ( .A(n1008), .Y(n1029) );
  OAI2BB2X1 U1268 ( .A0N(out_sfr_a[2]), .A1N(n1009), .B0(n36), .B1(n1008), .Y(
        n833) );
  NAND2X1 U1269 ( .A(n1010), .B(n826), .Y(n1009) );
  NOR2BX1 U1270 ( .AN(n1011), .B(n848), .Y(n1010) );
  NOR2X1 U1271 ( .A(n1067), .B(n36), .Y(n1066) );
  NOR2X1 U1272 ( .A(n837), .B(n847), .Y(n1067) );
  NOR2X1 U1273 ( .A(n36), .B(n1050), .Y(n1065) );
  NOR2X1 U1274 ( .A(n36), .B(n1052), .Y(n1051) );
  NOR2X1 U1275 ( .A(n36), .B(n1018), .Y(n1035) );
  NOR2X1 U1276 ( .A(n36), .B(n1020), .Y(n1019) );
  NOR2X1 U1277 ( .A(n36), .B(n1024), .Y(n1080) );
  OAI21X1 U1278 ( .A0(n1201), .A1(n928), .B0(n1202), .Y(n294) );
  NAND2X1 U1279 ( .A(alu_a[1]), .B(n698), .Y(n1202) );
  OAI21X1 U1280 ( .A0(n1201), .A1(n940), .B0(n1384), .Y(n372) );
  NAND2X1 U1281 ( .A(alu_a[0]), .B(n698), .Y(n1384) );
  NAND2X1 U1282 ( .A(n109000), .B(n1091), .Y(n106) );
  NAND2X1 U1283 ( .A(n821), .B(n1026), .Y(n1091) );
  INVX1 U1284 ( .A(n36), .Y(n109000) );
  NOR2X1 U1285 ( .A(n634), .B(n1265), .Y(n1335) );
  AND2X1 U1286 ( .A(n1602), .B(n755), .Y(n703) );
  AND2X1 U1287 ( .A(addr2_a_1_), .B(addr2_a_0_), .Y(n704) );
  AND2X1 U1288 ( .A(n703), .B(n669), .Y(n705) );
  NAND2BX1 U1289 ( .AN(n1119), .B(n77), .Y(n1300) );
  NAND2BX1 U1290 ( .AN(n1119), .B(n50), .Y(n1253) );
  NAND2BX1 U1291 ( .AN(n1123), .B(n50), .Y(n1132) );
  CLKINVX1 U1292 ( .A(n23), .Y(n15) );
  NAND2BX1 U1293 ( .AN(sel_xaddr_low), .B(sel_xad), .Y(n23) );
  AND2X2 U1294 ( .A(sel_xaddr_low), .B(sel_xad), .Y(n706) );
  NOR2X1 U1295 ( .A(n916), .B(n598), .Y(n1182) );
  NOR2X1 U1296 ( .A(n362), .B(n1117), .Y(n1110) );
  CLKINVX1 U1297 ( .A(n1118), .Y(n1117) );
  NAND2X1 U1298 ( .A(n1179), .B(n601), .Y(n1176) );
  NOR2X1 U1299 ( .A(n1181), .B(n1182), .Y(n1179) );
  NOR2X1 U1300 ( .A(n885), .B(n598), .Y(n1144) );
  NOR2X1 U1301 ( .A(n896), .B(n598), .Y(n1161) );
  NOR2X1 U1302 ( .A(n906), .B(n598), .Y(n1171) );
  NOR2X1 U1303 ( .A(n876), .B(n598), .Y(n1135) );
  NOR2X1 U1304 ( .A(n864), .B(n598), .Y(n1126) );
  CLKINVX1 U1305 ( .A(n248), .Y(n228) );
  NAND2BX1 U1306 ( .AN(inc_pc2), .B(inc_pc3), .Y(n248) );
  NOR2X1 U1307 ( .A(inc_pc3), .B(inc_pc2), .Y(n707) );
  CLKINVX1 U1308 ( .A(ld_instr), .Y(n408) );
  OA22X4 U1309 ( .A0(n667), .A1(n565), .B0(n756), .B1(n1491), .Y(n711) );
  OR2X1 U1310 ( .A(n1379), .B(n761), .Y(n712) );
  NOR2X8 U1311 ( .A(n715), .B(n716), .Y(n714) );
  NOR2X1 U1312 ( .A(n876), .B(n865), .Y(n866) );
  NOR2X2 U1313 ( .A(n873), .B(n874), .Y(n867) );
  NOR2X1 U1314 ( .A(n896), .B(n865), .Y(n886) );
  NOR2X2 U1315 ( .A(n893), .B(n894), .Y(n887) );
  NOR4X1 U1316 ( .A(n1311), .B(n1312), .C(n1313), .D(n1314), .Y(n1301) );
  NOR4X1 U1317 ( .A(n1307), .B(n1308), .C(n1309), .D(n1310), .Y(n1302) );
  NAND2X1 U1318 ( .A(out_sfr_a[4]), .B(n1260), .Y(n1303) );
  NAND4X2 U1319 ( .A(n1254), .B(n1255), .C(n1256), .D(n3200), .Y(n50) );
  NOR4X1 U1320 ( .A(n1266), .B(n1267), .C(n1268), .D(n1269), .Y(n1254) );
  NOR4X1 U1321 ( .A(n1261), .B(n1262), .C(n1263), .D(n1264), .Y(n1255) );
  NAND2X1 U1322 ( .A(out_sfr_a[6]), .B(n1260), .Y(n1256) );
  NOR2X1 U1323 ( .A(n585), .B(n863), .Y(n882) );
  NOR2X1 U1324 ( .A(n590), .B(n863), .Y(n859) );
  NOR2X1 U1325 ( .A(n589), .B(n863), .Y(n925) );
  NOR2X1 U1326 ( .A(n587), .B(n863), .Y(n893) );
  NOR2X1 U1327 ( .A(n584), .B(n863), .Y(n873) );
  NOR2X1 U1328 ( .A(n577), .B(n953), .Y(n987) );
  NOR2X1 U1329 ( .A(n578), .B(n953), .Y(n993) );
  NOR2X1 U1330 ( .A(n576), .B(n953), .Y(n978) );
  NOR2X1 U1331 ( .A(n892), .B(n858), .Y(n890) );
  NOR2X1 U1332 ( .A(n872), .B(n858), .Y(n870) );
  NOR2X1 U1333 ( .A(n576), .B(n856), .Y(n891) );
  NOR2X1 U1334 ( .A(n580), .B(n856), .Y(n871) );
  NOR2X1 U1335 ( .A(n995), .B(n952), .Y(n994) );
  NOR2X1 U1336 ( .A(n980), .B(n952), .Y(n979) );
  NOR2X1 U1337 ( .A(n938), .B(n858), .Y(n937) );
  NOR2X1 U1338 ( .A(n745), .B(n667), .Y(n1570) );
  NOR2X1 U1339 ( .A(n637), .B(n1533), .Y(n1530) );
  INVX1 U1340 ( .A(n1534), .Y(n1533) );
  NOR2X1 U1341 ( .A(n902), .B(n947), .Y(n986) );
  NOR2X1 U1342 ( .A(n588), .B(n948), .Y(n985) );
  CLKAND2X4 U1343 ( .A(n717), .B(n718), .Y(n991) );
  OR2X1 U1344 ( .A(n586), .B(n948), .Y(n717) );
  OR2X1 U1345 ( .A(n912), .B(n947), .Y(n718) );
  NOR2X1 U1346 ( .A(n892), .B(n947), .Y(n977) );
  NOR2X1 U1347 ( .A(n587), .B(n948), .Y(n976) );
  NOR2X1 U1348 ( .A(n902), .B(n858), .Y(n900) );
  NOR2X1 U1349 ( .A(n577), .B(n856), .Y(n901) );
  OR2X1 U1350 ( .A(n881), .B(n858), .Y(n719) );
  OR2X1 U1351 ( .A(n581), .B(n856), .Y(n720) );
  NOR2X1 U1352 ( .A(n857), .B(n858), .Y(n854) );
  NOR2X1 U1353 ( .A(n808), .B(n856), .Y(n855) );
  NOR2X1 U1354 ( .A(n924), .B(n858), .Y(n922) );
  NOR2X1 U1355 ( .A(n583), .B(n856), .Y(n923) );
  OR2X1 U1356 ( .A(n906), .B(n865), .Y(n721) );
  NOR2X1 U1357 ( .A(n928), .B(n865), .Y(n917) );
  NOR2X1 U1358 ( .A(n885), .B(n865), .Y(n877) );
  NOR2X1 U1359 ( .A(n864), .B(n865), .Y(n849) );
  NOR2X2 U1360 ( .A(n859), .B(n860), .Y(n850) );
  INVX1 U1361 ( .A(n633), .Y(n1548) );
  NOR2X8 U1362 ( .A(n723), .B(n724), .Y(n722) );
  OAI21X1 U1363 ( .A0(n1174), .A1(n1123), .B0(n1175), .Y(in_pc[2]) );
  NOR2X1 U1364 ( .A(n1176), .B(n1177), .Y(n1175) );
  OAI21X1 U1365 ( .A0(n284), .A1(n1123), .B0(n1184), .Y(in_pc[1]) );
  NOR3X1 U1366 ( .A(n1185), .B(n1186), .C(n1187), .Y(n1184) );
  NOR2X1 U1367 ( .A(n1246), .B(n1247), .Y(n1225) );
  NOR2X1 U1368 ( .A(n581), .B(n953), .Y(n970) );
  NOR2X1 U1369 ( .A(n580), .B(n953), .Y(n961) );
  NOR2X1 U1370 ( .A(n808), .B(n953), .Y(n949) );
  NOR2X1 U1371 ( .A(n972), .B(n952), .Y(n971) );
  NOR2X1 U1372 ( .A(n963), .B(n952), .Y(n962) );
  NOR2X1 U1373 ( .A(n951), .B(n952), .Y(n950) );
  OAI21X1 U1374 ( .A0(n75), .A1(n1123), .B0(n1152), .Y(in_pc[4]) );
  AOI21X1 U1375 ( .A0(n1153), .A1(n258), .B0(n1154), .Y(n1152) );
  OAI21X1 U1376 ( .A0(n278), .A1(n1123), .B0(n1164), .Y(in_pc[3]) );
  AOI21X1 U1377 ( .A0(n1165), .A1(n258), .B0(n1166), .Y(n1164) );
  OAI21X1 U1378 ( .A0(n356), .A1(n1123), .B0(n1366), .Y(in_pc[0]) );
  NOR3X1 U1379 ( .A(n1367), .B(n1368), .C(n1369), .Y(n1366) );
  NOR2X1 U1380 ( .A(n881), .B(n947), .Y(n969) );
  NOR2X1 U1381 ( .A(n585), .B(n948), .Y(n968) );
  NOR2X1 U1382 ( .A(n872), .B(n947), .Y(n960) );
  NOR2X1 U1383 ( .A(n584), .B(n948), .Y(n959) );
  NOR2X1 U1384 ( .A(n590), .B(n948), .Y(n945) );
  NOR2X1 U1385 ( .A(n857), .B(n947), .Y(n946) );
  CLKINVX8 U1386 ( .A(in_xrom_a[0]), .Y(n940) );
  DFFRX1 in_xrom1_r_reg_0_ ( .D(n520), .CK(clk), .RN(n483), .Q(in_xrom1_r[0]), 
        .QN(n789) );
  DFFRX1 in_xrom1_r_reg_2_ ( .D(n522), .CK(clk), .RN(n483), .Q(in_xrom1_r[2]), 
        .QN(n787) );
  OAI21X1 U1387 ( .A0(n36), .A1(n819), .B0(n1081), .Y(n843) );
  AOI21X1 U1388 ( .A0(n1082), .A1(out_sfr_a[0]), .B0(n1083), .Y(n1081) );
  NOR2X1 U1389 ( .A(n582), .B(n821), .Y(n1083) );
  INVX1 U1390 ( .A(n1026), .Y(n1082) );
  CLKINVX1 U1391 ( .A(n1386), .Y(n369) );
  CLKINVX1 U1392 ( .A(n1381), .Y(n371) );
  NOR2BX1 U1393 ( .AN(out_sfr_a[0]), .B(n844), .Y(n842) );
  NAND2X1 U1394 ( .A(n1602), .B(n656), .Y(n1092) );
  DFFRX1 out_sfr_r_reg_5_ ( .D(n509), .CK(clk), .RN(n483), .Q(out_sfr_r[5]), 
        .QN(n585) );
  DFFRX1 out_sfr_r_reg_4_ ( .D(n508), .CK(clk), .RN(n483), .Q(out_sfr_r[4]), 
        .QN(n587) );
  DFFRX1 out_sfr_r_reg_6_ ( .D(n510), .CK(clk), .RN(n483), .Q(out_sfr_r[6]), 
        .QN(n584) );
  NOR2X1 U1395 ( .A(n1220), .B(n565), .Y(n1293) );
  NOR2X1 U1396 ( .A(n1220), .B(n566), .Y(n1264) );
  NOR2X1 U1397 ( .A(n1220), .B(n569), .Y(n1337) );
  NOR2X1 U1398 ( .A(n1221), .B(n581), .Y(n1292) );
  NOR2X1 U1399 ( .A(n1221), .B(n580), .Y(n1263) );
  NOR2X1 U1400 ( .A(n1221), .B(n576), .Y(n1309) );
  NOR2X1 U1401 ( .A(n1221), .B(n577), .Y(n1336) );
  NOR2X1 U1402 ( .A(n1222), .B(n881), .Y(n1290) );
  NOR2X1 U1403 ( .A(n1222), .B(n902), .Y(n1334) );
  NOR2X1 U1404 ( .A(n980), .B(n1265), .Y(n1308) );
  NOR2X1 U1405 ( .A(n972), .B(n1265), .Y(n1291) );
  INVX1 U1406 ( .A(n1093), .Y(addr2_a_1_) );
  NOR2X1 U1407 ( .A(n1270), .B(n584), .Y(n1269) );
  NOR2X1 U1408 ( .A(n1270), .B(n587), .Y(n1314) );
  NOR2X1 U1409 ( .A(n1243), .B(n1220), .Y(n1242) );
  NOR2X1 U1410 ( .A(n570), .B(n1220), .Y(n1359) );
  NOR2X1 U1411 ( .A(n567), .B(n1220), .Y(n1219) );
  NOR2X1 U1412 ( .A(n808), .B(n1221), .Y(n1241) );
  NOR2X1 U1413 ( .A(n578), .B(n1221), .Y(n1358) );
  NOR2X1 U1414 ( .A(n583), .B(n1221), .Y(n1218) );
  OAI21X1 U1415 ( .A0(n1222), .A1(n924), .B0(n1223), .Y(n1217) );
  NAND2X1 U1416 ( .A(n1224), .B(out_acc_r[1]), .Y(n1223) );
  NAND2BX1 U1417 ( .AN(n1403), .B(n403), .Y(in_cy_bit) );
  AND2X1 U1418 ( .A(n1093), .B(n1088), .Y(n732) );
  AND2X1 U1419 ( .A(n703), .B(n1069), .Y(n733) );
  AND2X1 U1420 ( .A(addr2_a_1_), .B(n1088), .Y(n734) );
  AND2X1 U1421 ( .A(addr2_a_0_), .B(n1093), .Y(n735) );
  NAND4X1 U1422 ( .A(n1251), .B(n1252), .C(n560), .D(n1253), .Y(in_pc[14]) );
  NOR2X1 U1423 ( .A(n1274), .B(n1275), .Y(n1252) );
  NAND2X1 U1424 ( .A(n258), .B(n684), .Y(n1251) );
  NAND4X1 U1425 ( .A(n1277), .B(n1278), .C(n571), .D(n1279), .Y(in_pc[13]) );
  NOR2X1 U1426 ( .A(n1295), .B(n1296), .Y(n1278) );
  NAND2X1 U1427 ( .A(n258), .B(n747), .Y(n1277) );
  NAND4X1 U1428 ( .A(n1298), .B(n1299), .C(n572), .D(n1300), .Y(in_pc[12]) );
  NOR2X1 U1429 ( .A(n1318), .B(n1319), .Y(n1299) );
  NAND2X1 U1430 ( .A(n258), .B(n736), .Y(n1298) );
  NAND4X1 U1431 ( .A(n1321), .B(n1322), .C(n573), .D(n1323), .Y(in_pc[11]) );
  NOR2X1 U1432 ( .A(n1339), .B(n1340), .Y(n1322) );
  NAND2X1 U1433 ( .A(n258), .B(n750), .Y(n1321) );
  NAND2BX1 U1434 ( .AN(n1119), .B(n61), .Y(n1279) );
  NAND2BX1 U1435 ( .AN(n1119), .B(n86), .Y(n1323) );
  NAND2X1 U1436 ( .A(n1102), .B(n39), .Y(n1226) );
  NAND2BX1 U1437 ( .AN(n1123), .B(n39), .Y(n1122) );
  NOR2X1 U1438 ( .A(n266), .B(n1123), .Y(n1139) );
  NAND4X1 U1439 ( .A(n1342), .B(n1343), .C(n574), .D(n1344), .Y(in_pc[10]) );
  NOR2X1 U1440 ( .A(n1363), .B(n1364), .Y(n1343) );
  NAND2X1 U1441 ( .A(n258), .B(n752), .Y(n1342) );
  NAND3X1 U1442 ( .A(n1099), .B(n110000), .C(n1101), .Y(in_pc[9]) );
  NOR3X1 U1443 ( .A(n1103), .B(n1104), .C(n1105), .Y(n110000) );
  NAND2X1 U1444 ( .A(n258), .B(n753), .Y(n1099) );
  NAND2X1 U1445 ( .A(n1102), .B(n104), .Y(n1101) );
  NAND2X1 U1446 ( .A(n1102), .B(n93), .Y(n1344) );
  NAND2BX1 U1447 ( .AN(n1108), .B(n1109), .Y(in_pc[8]) );
  NOR2X1 U1448 ( .A(n1110), .B(n1111), .Y(n1109) );
  NOR2X1 U1449 ( .A(n356), .B(n1119), .Y(n1108) );
  OAI21X1 U1450 ( .A0(n596), .A1(n1112), .B0(n1113), .Y(n1111) );
  XNOR2X1 U1451 ( .A(n1414), .B(n1415), .Y(n1118) );
  OAI21X1 U1452 ( .A0(n1379), .A1(n429), .B0(n1444), .Y(addr_xrom_a[0]) );
  NOR2X1 U1453 ( .A(n1445), .B(n1446), .Y(n1444) );
  NOR2X1 U1454 ( .A(n428), .B(n754), .Y(n1446) );
  OAI21X1 U1455 ( .A0(n1194), .A1(n429), .B0(n1439), .Y(addr_xrom_a[1]) );
  NOR2X1 U1456 ( .A(n1440), .B(n1441), .Y(n1439) );
  NOR2X1 U1457 ( .A(n428), .B(n1442), .Y(n1441) );
  NAND3BX1 U1458 ( .AN(n1432), .B(n1433), .C(n1434), .Y(addr_xrom_a[3]) );
  NAND2X1 U1459 ( .A(a_plus_pc_3_), .B(ld_apc), .Y(n1434) );
  NOR2X1 U1460 ( .A(n427), .B(n1435), .Y(n1432) );
  NAND3BX1 U1461 ( .AN(n1428), .B(n1429), .C(n1430), .Y(addr_xrom_a[4]) );
  NAND2X1 U1462 ( .A(a_plus_pc_4_), .B(ld_apc), .Y(n1430) );
  NOR2X1 U1463 ( .A(n427), .B(n1431), .Y(n1428) );
  NAND3BX1 U1464 ( .AN(n1424), .B(n1425), .C(n1426), .Y(addr_xrom_a[5]) );
  NAND2X1 U1465 ( .A(a_plus_pc_5_), .B(ld_apc), .Y(n1426) );
  NOR2X1 U1466 ( .A(n427), .B(n1427), .Y(n1424) );
  NAND3BX1 U1467 ( .AN(n1420), .B(n1421), .C(n1422), .Y(addr_xrom_a[6]) );
  NOR2X1 U1468 ( .A(n427), .B(n1423), .Y(n1420) );
  NAND2BX1 U1469 ( .AN(n429), .B(n1138), .Y(n1421) );
  NAND3BX1 U1470 ( .AN(n1416), .B(n1417), .C(n1418), .Y(addr_xrom_a[7]) );
  NOR2X1 U1471 ( .A(n427), .B(n1419), .Y(n1416) );
  NAND2BX1 U1472 ( .AN(n429), .B(n652), .Y(n1417) );
  CLKINVX1 U1473 ( .A(n1414), .Y(n1580) );
  NOR2X1 U1474 ( .A(n1585), .B(n1587), .Y(n1586) );
  NAND2X1 U1475 ( .A(n409), .B(n1178), .Y(n1437) );
  NOR2X1 U1476 ( .A(n1580), .B(n1415), .Y(n1579) );
  NAND2BX1 U1477 ( .AN(n429), .B(n1151), .Y(n1425) );
  NAND2BX1 U1478 ( .AN(n429), .B(n1165), .Y(n1433) );
  NAND2BX1 U1479 ( .AN(n429), .B(n1153), .Y(n1429) );
  XOR2X1 U1480 ( .A(n1585), .B(n1587), .Y(n736) );
  NAND2X1 U1481 ( .A(a_plus_pc_6_), .B(ld_apc), .Y(n1422) );
  NAND2X1 U1482 ( .A(a_plus_pc_7_), .B(ld_apc), .Y(n1418) );
  DFFRX1 bit_dat_in_r_reg ( .D(bit_dat_in), .CK(clk), .RN(n483), .Q(
        bit_dat_in_r) );
  OAI21X1 U1483 ( .A0(n1188), .A1(n1147), .B0(n1189), .Y(n1187) );
  NOR2X1 U1484 ( .A(n1190), .B(n1191), .Y(n1189) );
  NOR2X1 U1485 ( .A(n596), .B(n1192), .Y(n1190) );
  NOR2X1 U1486 ( .A(n928), .B(n598), .Y(n1191) );
  NOR2X1 U1487 ( .A(n1194), .B(n362), .Y(n1185) );
  NOR2X1 U1488 ( .A(n596), .B(n1183), .Y(n1181) );
  CLKINVX1 U1489 ( .A(page_addr_a[2]), .Y(n1183) );
  NOR2X1 U1490 ( .A(n1114), .B(n1115), .Y(n1113) );
  NOR2X1 U1491 ( .A(n597), .B(n1116), .Y(n1115) );
  NOR2X1 U1492 ( .A(n745), .B(n598), .Y(n1114) );
  CLKINVX1 U1493 ( .A(rel_addr_a[8]), .Y(n1116) );
  NOR2X1 U1494 ( .A(n1250), .B(n362), .Y(n1249) );
  CLKINVX1 U1495 ( .A(rel_addr_a[14]), .Y(n1273) );
  CLKINVX1 U1496 ( .A(rel_addr_a[13]), .Y(n1294) );
  CLKINVX1 U1497 ( .A(rel_addr_a[12]), .Y(n1317) );
  CLKINVX1 U1498 ( .A(rel_addr_a[11]), .Y(n1338) );
  NOR2BX1 U1499 ( .AN(n1178), .B(n362), .Y(n1177) );
  CLKINVX1 U1500 ( .A(a_plus_pc_1_), .Y(n1442) );
  NOR3X1 U1501 ( .A(n1147), .B(n1148), .C(n1149), .Y(n1143) );
  OAI21X1 U1502 ( .A0(n1188), .A1(n1147), .B0(n1370), .Y(n1369) );
  NOR2X1 U1503 ( .A(n1371), .B(n1372), .Y(n1370) );
  NOR2X1 U1504 ( .A(n596), .B(n1373), .Y(n1371) );
  NOR2X1 U1505 ( .A(n940), .B(n598), .Y(n1372) );
  NOR2X1 U1506 ( .A(n596), .B(n1146), .Y(n1145) );
  CLKINVX1 U1507 ( .A(page_addr_a[5]), .Y(n1146) );
  NOR2X1 U1508 ( .A(n597), .B(n1150), .Y(n1142) );
  CLKINVX1 U1509 ( .A(rel_addr_a[5]), .Y(n1150) );
  NOR2X1 U1510 ( .A(n1379), .B(n362), .Y(n1367) );
  NAND2BX1 U1511 ( .AN(n362), .B(n652), .Y(n1120) );
  NOR2X1 U1512 ( .A(n596), .B(n1163), .Y(n1162) );
  CLKINVX1 U1513 ( .A(page_addr_a[4]), .Y(n1163) );
  NOR2X1 U1514 ( .A(n596), .B(n1173), .Y(n1172) );
  CLKINVX1 U1515 ( .A(page_addr_a[3]), .Y(n1173) );
  NAND2BX1 U1516 ( .AN(n362), .B(n1138), .Y(n1130) );
  NOR2X1 U1517 ( .A(n1243), .B(n598), .Y(n1246) );
  NOR2X1 U1518 ( .A(n566), .B(n598), .Y(n1274) );
  NOR2X1 U1519 ( .A(n565), .B(n598), .Y(n1295) );
  NOR2X1 U1520 ( .A(n568), .B(n598), .Y(n1318) );
  NOR2X1 U1521 ( .A(n569), .B(n598), .Y(n1339) );
  NOR2X1 U1522 ( .A(n570), .B(n598), .Y(n1363) );
  NOR2X1 U1523 ( .A(n597), .B(n1137), .Y(n1133) );
  CLKINVX1 U1524 ( .A(rel_addr_a[6]), .Y(n1137) );
  NOR2X1 U1525 ( .A(n597), .B(n1107), .Y(n1103) );
  CLKINVX1 U1526 ( .A(rel_addr_a[9]), .Y(n1107) );
  NOR2X1 U1527 ( .A(n597), .B(n1128), .Y(n1124) );
  CLKINVX1 U1528 ( .A(rel_addr_a[7]), .Y(n1128) );
  NOR2X1 U1529 ( .A(n597), .B(n1193), .Y(n1186) );
  CLKINVX1 U1530 ( .A(rel_addr_a[1]), .Y(n1193) );
  NOR2X1 U1531 ( .A(n596), .B(n1106), .Y(n1105) );
  CLKINVX1 U1532 ( .A(page_addr_a[9]), .Y(n1106) );
  NOR2X1 U1533 ( .A(n596), .B(n1136), .Y(n1134) );
  CLKINVX1 U1534 ( .A(page_addr_a[6]), .Y(n1136) );
  NOR2X1 U1535 ( .A(n596), .B(n1127), .Y(n1125) );
  CLKINVX1 U1536 ( .A(page_addr_a[7]), .Y(n1127) );
  CLKINVX1 U1537 ( .A(rel_addr_a[4]), .Y(n1157) );
  CLKINVX1 U1538 ( .A(rel_addr_a[3]), .Y(n1169) );
  CLKINVX1 U1539 ( .A(rel_addr_a[10]), .Y(n1362) );
  CLKINVX1 U1540 ( .A(sel_page_addr), .Y(n10) );
  NOR2X1 U1541 ( .A(n567), .B(n598), .Y(n1104) );
  NAND2BX1 U1542 ( .AN(n362), .B(n1151), .Y(n1140) );
  NAND3X1 U1543 ( .A(n1155), .B(n1156), .C(n599), .Y(n1154) );
  NAND2X1 U1544 ( .A(n1158), .B(n1159), .Y(n1156) );
  NOR2X1 U1545 ( .A(n1161), .B(n1162), .Y(n1155) );
  NAND3X1 U1546 ( .A(n1167), .B(n1168), .C(n600), .Y(n1166) );
  NAND3X1 U1547 ( .A(n1170), .B(n1148), .C(n1159), .Y(n1168) );
  NOR2X1 U1548 ( .A(n1171), .B(n1172), .Y(n1167) );
  CLKINVX1 U1549 ( .A(rel_addr_a[2]), .Y(n1180) );
  NAND4X2 U1550 ( .A(n1521), .B(n1519), .C(n1520), .D(n1518), .Y(n1517) );
  NAND2X1 U1551 ( .A(in_xrom_r[3]), .B(n1503), .Y(n1519) );
  NAND3X1 U1552 ( .A(n792), .B(n649), .C(n613), .Y(n1561) );
  NOR2X1 U1553 ( .A(n1567), .B(n613), .Y(n1563) );
  NOR2X1 U1554 ( .A(n1194), .B(n613), .Y(n1564) );
  CLKINVX1 U1555 ( .A(out_sp_r[1]), .Y(n1567) );
  XOR2X4 U1556 ( .A(n1498), .B(n737), .Y(n1129) );
  XOR2X4 U1557 ( .A(out_dptr_r[7]), .B(n951), .Y(n737) );
  NOR2X1 U1558 ( .A(n489), .B(n1469), .Y(n1575) );
  NOR2X1 U1559 ( .A(n1514), .B(n756), .Y(n1513) );
  CLKINVX2 U1560 ( .A(out_sp_r[4]), .Y(n1514) );
  CLKINVX4 U1561 ( .A(out_sp_r[3]), .Y(n1527) );
  NOR3X2 U1562 ( .A(n1235), .B(n1236), .C(n1237), .Y(n1228) );
  NOR2X1 U1563 ( .A(n789), .B(n1470), .Y(n1576) );
  NAND2X1 U1564 ( .A(in_xrom_r[2]), .B(n1503), .Y(n1537) );
  NOR2X1 U1565 ( .A(n1232), .B(n777), .Y(n1231) );
  OAI21X1 U1566 ( .A0(n1201), .A1(n864), .B0(n1233), .Y(n3130) );
  NOR2X1 U1567 ( .A(n576), .B(n1473), .Y(n1510) );
  NOR2X1 U1568 ( .A(n621), .B(n488), .Y(n1509) );
  CLKINVX3 U1569 ( .A(out_sp_r[2]), .Y(n1545) );
  NAND2X1 U1570 ( .A(n630), .B(n1622), .Y(n1566) );
  XNOR2X1 U1571 ( .A(n627), .B(n1621), .Y(n1565) );
  XNOR2X1 U1572 ( .A(n630), .B(n628), .Y(n1379) );
  XNOR2X2 U1573 ( .A(out_dptr_r[2]), .B(n995), .Y(n1547) );
  INVX1 U1574 ( .A(n1550), .Y(n1549) );
  XNOR2X1 U1575 ( .A(out_dptr_r[5]), .B(n972), .Y(n1490) );
  XNOR2X1 U1576 ( .A(n1475), .B(n1476), .Y(n1138) );
  XNOR2X1 U1577 ( .A(out_dptr_r[6]), .B(n963), .Y(n1476) );
  OR3X2 U1578 ( .A(n1285), .B(n1286), .C(n1287), .Y(n740) );
  INVX1 U1579 ( .A(out_acc_r[4]), .Y(n980) );
  NOR2X1 U1580 ( .A(n1232), .B(n779), .Y(n1282) );
  OAI21X1 U1581 ( .A0(n1201), .A1(n885), .B0(n1283), .Y(n3290) );
  NOR3X2 U1582 ( .A(n3210), .B(n1257), .C(n1258), .Y(n3200) );
  NOR2X1 U1583 ( .A(n1232), .B(n778), .Y(n1258) );
  NOR2X1 U1584 ( .A(n1205), .B(n770), .Y(n1257) );
  OAI21X1 U1585 ( .A0(n1201), .A1(n876), .B0(n1259), .Y(n3210) );
  NOR3X2 U1586 ( .A(n3370), .B(n1304), .C(n1305), .Y(n3360) );
  NOR2X1 U1587 ( .A(n1232), .B(n780), .Y(n1305) );
  NOR2X2 U1588 ( .A(n861), .B(n905), .Y(n904) );
  CLKINVX1 U1589 ( .A(out_b[3]), .Y(n905) );
  NOR2X1 U1590 ( .A(n861), .B(n884), .Y(n883) );
  CLKINVX1 U1591 ( .A(out_b[5]), .Y(n884) );
  NOR2X1 U1592 ( .A(n861), .B(n862), .Y(n860) );
  NOR2X1 U1593 ( .A(n861), .B(n895), .Y(n894) );
  NOR2X1 U1594 ( .A(n861), .B(n875), .Y(n874) );
  CLKINVX1 U1595 ( .A(out_b[6]), .Y(n875) );
  NOR2X1 U1596 ( .A(n659), .B(n567), .Y(n1557) );
  NOR2X1 U1597 ( .A(n788), .B(n1470), .Y(n1556) );
  OR3X2 U1598 ( .A(n1329), .B(n1330), .C(n1331), .Y(n742) );
  AOI21X1 U1599 ( .A0(out_sfr_r[2]), .A1(n1206), .B0(n1351), .Y(n1347) );
  NOR2X1 U1600 ( .A(n1205), .B(n774), .Y(n1348) );
  NOR2X1 U1601 ( .A(n1232), .B(n782), .Y(n1349) );
  OAI21X1 U1602 ( .A0(n1201), .A1(n916), .B0(n1350), .Y(n353) );
  NOR2X1 U1603 ( .A(n1232), .B(n781), .Y(n1326) );
  NOR2X1 U1604 ( .A(n1205), .B(n773), .Y(n1325) );
  OAI21X1 U1605 ( .A0(n1201), .A1(n906), .B0(n1327), .Y(n345) );
  NAND2X1 U1606 ( .A(n1017), .B(in_idat_r[2]), .Y(n1014) );
  NAND2X1 U1607 ( .A(n1016), .B(n93), .Y(n1015) );
  NAND2X1 U1608 ( .A(in_idat_r[3]), .B(n1034), .Y(n1032) );
  NAND2BX1 U1609 ( .AN(n1602), .B(n86), .Y(n1033) );
  NAND2X1 U1610 ( .A(out_sfr_a[1]), .B(n840), .Y(n839) );
  AOI21X1 U1611 ( .A0(n838), .A1(in_idat_r[1]), .B0(n1089), .Y(n101) );
  CLKINVX6 U1612 ( .A(n1084), .Y(n102) );
  NOR3X1 U1613 ( .A(n1209), .B(n1210), .C(n1211), .Y(n1196) );
  NAND2X1 U1614 ( .A(in_idat_r[0]), .B(n1079), .Y(n1077) );
  NAND2BX1 U1615 ( .AN(n1602), .B(n111), .Y(n1078) );
  OR3X4 U1616 ( .A(n743), .B(n1085), .C(n744), .Y(n1084) );
  AND2X1 U1617 ( .A(n1016), .B(n104), .Y(n744) );
  AOI21X1 U1618 ( .A0(latch_pc_0_), .A1(n1203), .B0(n1385), .Y(n1382) );
  INVX1 U1619 ( .A(n372), .Y(n1383) );
  NOR2X1 U1620 ( .A(n1205), .B(n776), .Y(n1385) );
  NAND2X1 U1621 ( .A(n1199), .B(n1200), .Y(n1198) );
  AOI21X1 U1622 ( .A0(latch_pc_1_), .A1(n1203), .B0(n1204), .Y(n1199) );
  NAND2X1 U1623 ( .A(n1224), .B(out_acc_r[0]), .Y(n1394) );
  CLKINVX1 U1624 ( .A(alu_r[0]), .Y(n1395) );
  NAND2X1 U1625 ( .A(in_xdat_a[0]), .B(n1397), .Y(n1396) );
  NAND2X1 U1626 ( .A(n1224), .B(out_acc_r[7]), .Y(n1244) );
  OR2X1 U1627 ( .A(n1220), .B(n745), .Y(n1402) );
  CLKINVX1 U1628 ( .A(in_xdat_a[6]), .Y(n1271) );
  CLKINVX1 U1629 ( .A(in_xdat_a[4]), .Y(n1315) );
  CLKINVX1 U1630 ( .A(alu_r[6]), .Y(n1272) );
  CLKINVX1 U1631 ( .A(alu_r[4]), .Y(n1316) );
  NOR2X1 U1632 ( .A(n1216), .B(n797), .Y(n1329) );
  NOR2X1 U1633 ( .A(n1216), .B(n798), .Y(n1352) );
  NOR2X1 U1634 ( .A(n1216), .B(n799), .Y(n1209) );
  CLKINVX1 U1635 ( .A(in_xdat_a[7]), .Y(n1238) );
  CLKINVX1 U1636 ( .A(in_xdat_a[5]), .Y(n1288) );
  NOR2X1 U1637 ( .A(n1212), .B(n1332), .Y(n1331) );
  INVX1 U1638 ( .A(in_xdat_a[3]), .Y(n1332) );
  NOR2X1 U1639 ( .A(n1212), .B(n1355), .Y(n1354) );
  INVX1 U1640 ( .A(in_xdat_a[2]), .Y(n1355) );
  NOR2X1 U1641 ( .A(n1212), .B(n1213), .Y(n1211) );
  CLKINVX1 U1642 ( .A(in_xdat_a[1]), .Y(n1213) );
  CLKINVX1 U1643 ( .A(alu_r[7]), .Y(n1239) );
  CLKINVX1 U1644 ( .A(alu_r[5]), .Y(n1289) );
  NOR2X1 U1645 ( .A(n1214), .B(n1333), .Y(n1330) );
  CLKINVX1 U1646 ( .A(alu_r[3]), .Y(n1333) );
  NOR2X1 U1647 ( .A(n1214), .B(n1356), .Y(n1353) );
  CLKINVX1 U1648 ( .A(alu_r[2]), .Y(n1356) );
  NOR2X1 U1649 ( .A(n1214), .B(n1215), .Y(n1210) );
  CLKINVX1 U1650 ( .A(alu_r[1]), .Y(n1215) );
  NOR2X1 U1651 ( .A(n1205), .B(n775), .Y(n1204) );
  NAND2X1 U1652 ( .A(out_sfr_r[0]), .B(n1206), .Y(n1388) );
  NAND2X1 U1653 ( .A(n1260), .B(out_sfr_a[0]), .Y(n1389) );
  NAND2X1 U1654 ( .A(n1390), .B(in_idat_r[0]), .Y(n1387) );
  INVX1 U1655 ( .A(cy_psw), .Y(n1098) );
  CMPR32X2 U1656 ( .A(out_acc_r[2]), .B(out_pc_r_2_), .C(add_465_carry_2_), 
        .S(a_plus_pc_2_), .CO(add_465_carry_3_) );
  AO21X1 U1657 ( .A0(n409), .A1(n747), .B0(n422), .Y(addr_xrom_a[13]) );
  AO22X1 U1658 ( .A0(a_plus_pc_13_), .A1(ld_apc), .B0(n411), .B1(out_pc_r_13_), 
        .Y(n422) );
  CLKINVX1 U1659 ( .A(n1250), .Y(a_plus_dptr_15_) );
  CMPR32X2 U1660 ( .A(out_acc_r[1]), .B(add_434_carry_2_), .C(add_465_carry_1_), .S(a_plus_pc_1_), .CO(add_465_carry_2_) );
  INVX1 U1661 ( .A(in_xrom_r[7]), .Y(n1243) );
  CMPR32X2 U1662 ( .A(out_acc_r[6]), .B(out_pc_r_6_), .C(add_465_carry_6_), 
        .S(a_plus_pc_6_), .CO(add_465_carry_7_) );
  CMPR32X2 U1663 ( .A(out_acc_r[4]), .B(out_pc_r_4_), .C(add_465_carry_4_), 
        .S(a_plus_pc_4_), .CO(add_465_carry_5_) );
  CMPR32X2 U1664 ( .A(out_acc_r[5]), .B(out_pc_r_5_), .C(add_465_carry_5_), 
        .S(a_plus_pc_5_), .CO(add_465_carry_6_) );
  CMPR32X2 U1665 ( .A(out_acc_r[7]), .B(out_pc_r_7_), .C(add_465_carry_7_), 
        .S(a_plus_pc_7_), .CO(add_465_carry_8_) );
  OAI2BB1X1 U1666 ( .A0N(out_acc_r[1]), .A1N(n12), .B0(n746), .Y(out_xdat[1])
         );
  AOI22X1 U1667 ( .A0(n631), .A1(n706), .B0(in_idat_r[1]), .B1(n15), .Y(n746)
         );
  AO22X1 U1668 ( .A0(out_dptr_r[2]), .A1(n706), .B0(in_idat_r[2]), .B1(n15), 
        .Y(n20) );
  AO21X1 U1669 ( .A0(n409), .A1(n753), .B0(n410), .Y(addr_xrom_a[9]) );
  AO22X1 U1670 ( .A0(ld_apc), .A1(a_plus_pc_9_), .B0(n411), .B1(out_pc_r_9_), 
        .Y(n410) );
  AO21X1 U1671 ( .A0(n409), .A1(n752), .B0(n425), .Y(addr_xrom_a[10]) );
  AO22X1 U1672 ( .A0(a_plus_pc_10_), .A1(ld_apc), .B0(n411), .B1(out_pc_r_10_), 
        .Y(n425) );
  AO21X1 U1673 ( .A0(n409), .A1(n750), .B0(n424), .Y(addr_xrom_a[11]) );
  AO22X1 U1674 ( .A0(a_plus_pc_11_), .A1(ld_apc), .B0(n411), .B1(out_pc_r_11_), 
        .Y(n424) );
  AO21X1 U1675 ( .A0(n409), .A1(n736), .B0(n423), .Y(addr_xrom_a[12]) );
  AO22X1 U1676 ( .A0(a_plus_pc_12_), .A1(ld_apc), .B0(n411), .B1(out_pc_r_12_), 
        .Y(n423) );
  NAND3X1 U1677 ( .A(n1411), .B(n1412), .C(n1413), .Y(addr_xrom_a[8]) );
  NAND2X1 U1678 ( .A(out_pc_r_8_), .B(n411), .Y(n1411) );
  NAND2X1 U1679 ( .A(n409), .B(n1118), .Y(n1412) );
  NAND2X1 U1680 ( .A(a_plus_pc_8_), .B(ld_apc), .Y(n1413) );
  ACHCINX2 U1681 ( .A(out_acc_r[7]), .B(out_dptr_r[7]), .CIN(n663), .CO(n1414)
         );
  XOR2X1 U1682 ( .A(n1586), .B(out_dptr_r[13]), .Y(n747) );
  OAI21X1 U1683 ( .A0(cy_psw), .A1(n404), .B0(n1404), .Y(n403) );
  NOR2X1 U1684 ( .A(sel_in_cy_bit[2]), .B(n407), .Y(n1404) );
  CLKINVX1 U1685 ( .A(n1405), .Y(n404) );
  XNOR2X1 U1686 ( .A(n400), .B(n1406), .Y(n1405) );
  NAND3X1 U1687 ( .A(out_dptr_r[10]), .B(out_dptr_r[11]), .C(n1588), .Y(n1585)
         );
  OAI2BB1X1 U1688 ( .A0N(out_acc_r[7]), .A1N(n12), .B0(n748), .Y(out_xdat[7])
         );
  AOI22X1 U1689 ( .A0(out_dptr_r[7]), .A1(n706), .B0(in_idat_r[7]), .B1(n15), 
        .Y(n748) );
  OAI2BB1X1 U1690 ( .A0N(out_acc_r[3]), .A1N(n12), .B0(n749), .Y(out_xdat[3])
         );
  AOI22X1 U1691 ( .A0(out_dptr_r[3]), .A1(n706), .B0(in_idat_r[3]), .B1(n15), 
        .Y(n749) );
  NOR2X1 U1692 ( .A(n1589), .B(n1580), .Y(n1588) );
  NAND2X1 U1693 ( .A(out_dptr_r[8]), .B(out_dptr_r[9]), .Y(n1589) );
  NAND3X1 U1694 ( .A(n1436), .B(n1437), .C(n1438), .Y(addr_xrom_a[2]) );
  NAND2X1 U1695 ( .A(a_plus_pc_2_), .B(ld_apc), .Y(n1438) );
  NAND2X1 U1696 ( .A(out_pc_r_2_), .B(n411), .Y(n1436) );
  NAND3X1 U1697 ( .A(out_dptr_r[12]), .B(out_dptr_r[13]), .C(n1584), .Y(n1583)
         );
  CLKINVX1 U1698 ( .A(n1585), .Y(n1584) );
  MXI2X1 U1699 ( .S0(bit_dat_in), .B(n1408), .A(n1407), .Y(n1403) );
  NAND3X1 U1700 ( .A(n1409), .B(n1406), .C(n407), .Y(n1408) );
  NAND3X1 U1701 ( .A(cy_psw), .B(n1410), .C(sel_in_cy_bit[0]), .Y(n1407) );
  NAND2X1 U1702 ( .A(n1410), .B(n1098), .Y(n1409) );
  NOR2X1 U1703 ( .A(n427), .B(n1447), .Y(n1445) );
  NOR2X1 U1704 ( .A(n427), .B(n1443), .Y(n1440) );
  XOR2X1 U1705 ( .A(n751), .B(out_dptr_r[11]), .Y(n750) );
  AND2X1 U1706 ( .A(out_dptr_r[10]), .B(n1588), .Y(n751) );
  XOR2X1 U1707 ( .A(out_dptr_r[10]), .B(n1588), .Y(n752) );
  XOR2X1 U1708 ( .A(n1579), .B(out_dptr_r[9]), .Y(n753) );
  NAND2X1 U1709 ( .A(out_dptr_r[14]), .B(n1582), .Y(n1581) );
  CLKINVX1 U1710 ( .A(n1583), .Y(n1582) );
  XNOR2X1 U1711 ( .A(N327), .B(out_acc_r[0]), .Y(n754) );
  CLKINVX1 U1712 ( .A(rel_addr_a[15]), .Y(n1245) );
  CLKINVX1 U1713 ( .A(out_pc_r_3_), .Y(n1435) );
  CLKINVX1 U1714 ( .A(out_pc_r_4_), .Y(n1431) );
  CLKINVX1 U1715 ( .A(out_pc_r_5_), .Y(n1427) );
  CLKINVX1 U1716 ( .A(out_pc_r_6_), .Y(n1423) );
  CLKINVX1 U1717 ( .A(out_pc_r_7_), .Y(n1419) );
  INVX1 U1718 ( .A(out_dptr_r[12]), .Y(n1587) );
  INVX1 U1719 ( .A(out_dptr_r[8]), .Y(n1415) );
  AO22X1 U1720 ( .A0(n563), .A1(ld_sfr), .B0(out_sfr_r[3]), .B1(n26), .Y(n507)
         );
  AO22X1 U1721 ( .A0(out_sfr_a[4]), .A1(ld_sfr), .B0(out_sfr_r[4]), .B1(n26), 
        .Y(n508) );
  AO22X1 U1722 ( .A0(out_sfr_a[5]), .A1(ld_sfr), .B0(out_sfr_r[5]), .B1(n26), 
        .Y(n509) );
  AO22X1 U1723 ( .A0(out_sfr_a[6]), .A1(ld_sfr), .B0(out_sfr_r[6]), .B1(n26), 
        .Y(n510) );
  AO22X1 U1724 ( .A0(in_xrom_r[4]), .A1(n10), .B0(in_xrom_a[4]), .B1(
        sel_page_addr), .Y(xrom[4]) );
  AO22X1 U1725 ( .A0(in_xrom_r[3]), .A1(n10), .B0(in_xrom_a[3]), .B1(
        sel_page_addr), .Y(xrom[3]) );
  AO22X1 U1726 ( .A0(in_xrom_r[2]), .A1(n10), .B0(in_xrom_a[2]), .B1(
        sel_page_addr), .Y(xrom[2]) );
  AO22X1 U1727 ( .A0(in_xrom_r[6]), .A1(n10), .B0(in_xrom_a[6]), .B1(
        sel_page_addr), .Y(xrom[6]) );
  AO22X1 U1728 ( .A0(in_xrom_r[5]), .A1(n10), .B0(in_xrom_a[5]), .B1(
        sel_page_addr), .Y(xrom[5]) );
  AO22X1 U1729 ( .A0(in_xrom_r[7]), .A1(n10), .B0(sel_page_addr), .B1(
        in_xrom_a[7]), .Y(xrom[7]) );
  NOR2X1 U1730 ( .A(n596), .B(n1248), .Y(n1247) );
  CLKINVX1 U1731 ( .A(page_addr_a[15]), .Y(n1248) );
  NOR2X1 U1732 ( .A(n596), .B(n1276), .Y(n1275) );
  CLKINVX1 U1733 ( .A(page_addr_a[14]), .Y(n1276) );
  NOR2X1 U1734 ( .A(n596), .B(n1297), .Y(n1296) );
  CLKINVX1 U1735 ( .A(page_addr_a[13]), .Y(n1297) );
  NOR2X1 U1736 ( .A(n596), .B(n1320), .Y(n1319) );
  CLKINVX1 U1737 ( .A(page_addr_a[12]), .Y(n1320) );
  NOR2X1 U1738 ( .A(n596), .B(n1341), .Y(n1340) );
  CLKINVX1 U1739 ( .A(page_addr_a[11]), .Y(n1341) );
  NOR2X1 U1740 ( .A(n596), .B(n1365), .Y(n1364) );
  NOR2X1 U1741 ( .A(n597), .B(n1378), .Y(n1368) );
  CLKINVX1 U1742 ( .A(rel_addr_a[0]), .Y(n1378) );
  AO22X1 U1743 ( .A0(in_xrom_r[2]), .A1(n250), .B0(ld_xrom), .B1(in_xrom_a[2]), 
        .Y(n530) );
  AO22X1 U1744 ( .A0(in_xrom_r[3]), .A1(n250), .B0(ld_xrom), .B1(in_xrom_a[3]), 
        .Y(n531) );
  AO22X1 U1745 ( .A0(in_xrom_r[4]), .A1(n250), .B0(ld_xrom), .B1(in_xrom_a[4]), 
        .Y(n532) );
  AO22X1 U1746 ( .A0(in_xrom_r[1]), .A1(n250), .B0(ld_xrom), .B1(in_xrom_a[1]), 
        .Y(n529) );
  AO22X1 U1747 ( .A0(in_xrom_r[5]), .A1(n250), .B0(ld_xrom), .B1(in_xrom_a[5]), 
        .Y(n533) );
  AO22X1 U1748 ( .A0(in_xrom_r[6]), .A1(n250), .B0(ld_xrom), .B1(in_xrom_a[6]), 
        .Y(n534) );
  AO21X1 U1749 ( .A0(N337), .A1(n228), .B0(n244), .Y(n546) );
  AO22X1 U1750 ( .A0(N319), .A1(inc_pc2), .B0(out_pc_r_10_), .B1(n707), .Y(
        n244) );
  AO21X1 U1751 ( .A0(N338), .A1(n228), .B0(n243), .Y(n547) );
  AO22X1 U1752 ( .A0(N320), .A1(inc_pc2), .B0(out_pc_r_11_), .B1(n707), .Y(
        n243) );
  AO21X1 U1753 ( .A0(N339), .A1(n228), .B0(n242), .Y(n548) );
  AO22X1 U1754 ( .A0(N321), .A1(inc_pc2), .B0(out_pc_r_12_), .B1(n707), .Y(
        n242) );
  AO21X1 U1755 ( .A0(N340), .A1(n228), .B0(n241), .Y(n549) );
  AO22X1 U1756 ( .A0(N322), .A1(inc_pc2), .B0(out_pc_r_13_), .B1(n707), .Y(
        n241) );
  AO21X1 U1757 ( .A0(N341), .A1(n228), .B0(n240), .Y(n550) );
  AO22X1 U1758 ( .A0(N323), .A1(inc_pc2), .B0(out_pc_r_14_), .B1(n707), .Y(
        n240) );
  AO21X1 U1759 ( .A0(N342), .A1(n228), .B0(n239), .Y(n551) );
  AO22X1 U1760 ( .A0(N324), .A1(inc_pc2), .B0(out_pc_r_15_), .B1(n707), .Y(
        n239) );
  CLKINVX1 U1761 ( .A(page_addr_a[1]), .Y(n1192) );
  AO22X1 U1762 ( .A0(in_xrom_r[1]), .A1(n10), .B0(in_xrom_a[1]), .B1(
        sel_page_addr), .Y(xrom[1]) );
  CLKINVX1 U1763 ( .A(page_addr_a[0]), .Y(n1373) );
  AO22X1 U1764 ( .A0(in_xrom_r[0]), .A1(n10), .B0(in_xrom_a[0]), .B1(
        sel_page_addr), .Y(xrom[0]) );
  CLKINVX1 U1765 ( .A(sel_xaddr_high), .Y(n11) );
  NOR2BX1 U1766 ( .AN(out_dptr_r[11]), .B(n11), .Y(xaddr_high[3]) );
  NOR2BX1 U1767 ( .AN(out_dptr_r[13]), .B(n11), .Y(xaddr_high[5]) );
  NOR2BX1 U1768 ( .AN(out_dptr_r[12]), .B(n11), .Y(xaddr_high[4]) );
  NOR2BX1 U1769 ( .AN(out_dptr_r[8]), .B(n11), .Y(xaddr_high[0]) );
  NOR2BX1 U1770 ( .AN(out_dptr_r[14]), .B(n11), .Y(xaddr_high[6]) );
  NOR2BX1 U1771 ( .AN(out_dptr_r[9]), .B(n11), .Y(xaddr_high[1]) );
  NOR2BX1 U1772 ( .AN(out_dptr_r[10]), .B(n11), .Y(xaddr_high[2]) );
  NOR2BX1 U1773 ( .AN(out_dptr_r[15]), .B(n11), .Y(xaddr_high[7]) );
  AO22X1 U1774 ( .A0(ld_latch_acc), .A1(out_acc_r[6]), .B0(latch_acc[6]), .B1(
        n249), .Y(n500) );
  AO22X1 U1775 ( .A0(ld_latch_acc), .A1(out_acc_r[7]), .B0(latch_acc[7]), .B1(
        n249), .Y(n501) );
  AO22X1 U1776 ( .A0(ld_latch_acc), .A1(out_acc_r[4]), .B0(latch_acc[4]), .B1(
        n249), .Y(n498) );
  AO22X1 U1777 ( .A0(ld_latch_acc), .A1(out_acc_r[5]), .B0(latch_acc[5]), .B1(
        n249), .Y(n499) );
  AO22X1 U1778 ( .A0(ld_operand2), .A1(in_xrom_a[6]), .B0(in_xrom1_r[6]), .B1(
        n251), .Y(n526) );
  AO22X1 U1779 ( .A0(ld_latch_acc), .A1(out_acc_r[3]), .B0(latch_acc[3]), .B1(
        n249), .Y(n497) );
  AO22X1 U1780 ( .A0(ld_operand2), .A1(in_xrom_a[1]), .B0(in_xrom1_r[1]), .B1(
        n251), .Y(n521) );
  AO22X1 U1781 ( .A0(ld_operand2), .A1(in_xrom_a[3]), .B0(in_xrom1_r[3]), .B1(
        n251), .Y(n523) );
  AO22X1 U1782 ( .A0(ld_operand2), .A1(in_xrom_a[2]), .B0(in_xrom1_r[2]), .B1(
        n251), .Y(n522) );
  AO22X1 U1783 ( .A0(ld_operand2), .A1(in_xrom_a[5]), .B0(in_xrom1_r[5]), .B1(
        n251), .Y(n525) );
  AO22X1 U1784 ( .A0(ld_operand2), .A1(in_xrom_a[0]), .B0(in_xrom1_r[0]), .B1(
        n251), .Y(n520) );
  AO22X1 U1785 ( .A0(ld_operand2), .A1(in_xrom_a[4]), .B0(in_xrom1_r[4]), .B1(
        n251), .Y(n524) );
  AO21X1 U1786 ( .A0(N327), .A1(n228), .B0(n245), .Y(n536) );
  AO22X1 U1787 ( .A0(N309), .A1(inc_pc2), .B0(N327), .B1(n707), .Y(n245) );
  AO21X1 U1788 ( .A0(n1443), .A1(n228), .B0(n238), .Y(n537) );
  AO22X1 U1789 ( .A0(N310), .A1(inc_pc2), .B0(add_434_carry_2_), .B1(n707), 
        .Y(n238) );
  AO21X1 U1790 ( .A0(N329), .A1(n228), .B0(n237), .Y(n538) );
  AO22X1 U1791 ( .A0(N311), .A1(inc_pc2), .B0(out_pc_r_2_), .B1(n707), .Y(n237) );
  AO21X1 U1792 ( .A0(N330), .A1(n228), .B0(n236), .Y(n539) );
  AO22X1 U1793 ( .A0(N312), .A1(inc_pc2), .B0(out_pc_r_3_), .B1(n707), .Y(n236) );
  AO21X1 U1794 ( .A0(N331), .A1(n228), .B0(n235), .Y(n540) );
  AO22X1 U1795 ( .A0(N313), .A1(inc_pc2), .B0(out_pc_r_4_), .B1(n707), .Y(n235) );
  AO21X1 U1796 ( .A0(N332), .A1(n228), .B0(n234), .Y(n541) );
  AO22X1 U1797 ( .A0(N314), .A1(inc_pc2), .B0(out_pc_r_5_), .B1(n707), .Y(n234) );
  AO21X1 U1798 ( .A0(N333), .A1(n228), .B0(n233), .Y(n542) );
  AO22X1 U1799 ( .A0(N315), .A1(inc_pc2), .B0(out_pc_r_6_), .B1(n707), .Y(n233) );
  AO21X1 U1800 ( .A0(N334), .A1(n228), .B0(n232), .Y(n543) );
  AO22X1 U1801 ( .A0(N316), .A1(inc_pc2), .B0(out_pc_r_7_), .B1(n707), .Y(n232) );
  AO21X1 U1802 ( .A0(N335), .A1(n228), .B0(n231), .Y(n544) );
  AO22X1 U1803 ( .A0(N317), .A1(inc_pc2), .B0(out_pc_r_8_), .B1(n707), .Y(n231) );
  AO21X1 U1804 ( .A0(N336), .A1(n228), .B0(n229), .Y(n545) );
  AO22X1 U1805 ( .A0(inc_pc2), .A1(N318), .B0(out_pc_r_9_), .B1(n707), .Y(n229) );
  AOI21X1 U1806 ( .A0(int_vec3[0]), .A1(n1375), .B0(n1170), .Y(n1188) );
  NAND2X1 U1807 ( .A(int_vec3[2]), .B(n1375), .Y(n1149) );
  MXI2X1 U1808 ( .S0(int_vec3[0]), .B(n1160), .A(n1149), .Y(n1158) );
  CLKINVX1 U1809 ( .A(n276), .Y(n1160) );
  NOR2BX1 U1810 ( .AN(int_vec3[1]), .B(int_vec3[2]), .Y(n276) );
  NAND2X1 U1811 ( .A(n1149), .B(n1376), .Y(n1170) );
  NAND2X1 U1812 ( .A(int_vec3[1]), .B(n1377), .Y(n1376) );
  CLKINVX1 U1813 ( .A(int_vec3[2]), .Y(n1377) );
  CLKINVX1 U1814 ( .A(int_vec3[0]), .Y(n1148) );
  CLKINVX1 U1815 ( .A(int_vec3[1]), .Y(n1375) );
  INVX6 U1816 ( .A(rst_p), .Y(n483) );
  DFFRX1 in_idat1_r_reg_7_ ( .D(in_idat_r[7]), .CK(clk), .RN(n483), .QN(n765)
         );
  DFFRX1 in_idat1_r_reg_5_ ( .D(in_idat_r[5]), .CK(clk), .RN(n483), .QN(n767)
         );
  DFFRX1 in_idat1_r_reg_6_ ( .D(in_idat_r[6]), .CK(clk), .RN(n483), .QN(n766)
         );
  DFFRX1 addr2_r_reg_6_ ( .D(n616), .CK(clk), .RN(n483), .QN(n791) );
  DFFRX1 in_idat1_r_reg_4_ ( .D(in_idat_r[4]), .CK(clk), .RN(n483), .QN(n493)
         );
  DFFRX1 addr2_r_reg_4_ ( .D(addr2_a_4_), .CK(clk), .RN(n483), .QN(n488) );
  DFFRX1 in_idat1_r_reg_3_ ( .D(in_idat_r[3]), .CK(clk), .RN(n483), .QN(n492)
         );
  DFFRX1 addr2_r_reg_3_ ( .D(n1480), .CK(clk), .RN(n483), .QN(n487) );
  DFFRX1 in_idat1_r_reg_0_ ( .D(in_idat_r[0]), .CK(clk), .RN(n483), .QN(n489)
         );
  DFFRX1 in_idat1_r_reg_2_ ( .D(in_idat_r[2]), .CK(clk), .RN(n483), .QN(n491)
         );
  DFFRX1 addr2_r_reg_1_ ( .D(addr2_a_1_), .CK(clk), .RN(n483), .Q(n792) );
  DFFRX1 in_idat1_r_reg_1_ ( .D(in_idat_r[1]), .CK(clk), .RN(n483), .Q(n768)
         );
  DFFRX1 latch_acc_reg_2_ ( .D(n496), .CK(clk), .RN(n483), .Q(latch_acc[2]), 
        .QN(n798) );
  DFFRX1 latch_acc_reg_3_ ( .D(n497), .CK(clk), .RN(n483), .Q(latch_acc[3]), 
        .QN(n797) );
  DFFRX1 latch_acc_reg_4_ ( .D(n498), .CK(clk), .RN(n483), .Q(latch_acc[4]), 
        .QN(n796) );
  DFFRX1 latch_acc_reg_5_ ( .D(n499), .CK(clk), .RN(n483), .Q(latch_acc[5]), 
        .QN(n795) );
  DFFRX1 latch_acc_reg_6_ ( .D(n500), .CK(clk), .RN(n483), .Q(latch_acc[6]), 
        .QN(n794) );
  DFFRX1 latch_acc_reg_7_ ( .D(n501), .CK(clk), .RN(n483), .Q(latch_acc[7]), 
        .QN(n793) );
  DFFRX1 latch_pc_reg_2_ ( .D(n538), .CK(clk), .RN(n483), .QN(n782) );
  DFFRX1 latch_pc_reg_3_ ( .D(n539), .CK(clk), .RN(n483), .QN(n781) );
  DFFRX1 latch_pc_reg_4_ ( .D(n540), .CK(clk), .RN(n483), .QN(n780) );
  DFFRX1 latch_pc_reg_5_ ( .D(n541), .CK(clk), .RN(n483), .QN(n779) );
  DFFRX1 latch_pc_reg_6_ ( .D(n542), .CK(clk), .RN(n483), .QN(n778) );
  DFFRX1 latch_pc_reg_7_ ( .D(n543), .CK(clk), .RN(n483), .QN(n777) );
  DFFRX1 latch_pc_reg_9_ ( .D(n545), .CK(clk), .RN(n483), .QN(n775) );
  DFFRX1 latch_pc_reg_10_ ( .D(n546), .CK(clk), .RN(n483), .QN(n774) );
  DFFRX1 latch_pc_reg_11_ ( .D(n547), .CK(clk), .RN(n483), .QN(n773) );
  DFFRX1 latch_pc_reg_12_ ( .D(n548), .CK(clk), .RN(n483), .QN(n772) );
  DFFRX1 latch_pc_reg_13_ ( .D(n549), .CK(clk), .RN(n483), .QN(n771) );
  DFFRX1 latch_pc_reg_14_ ( .D(n550), .CK(clk), .RN(n483), .QN(n770) );
  DFFRX1 latch_pc_reg_15_ ( .D(n551), .CK(clk), .RN(n483), .QN(n769) );
  DFFQX1 alu_r_reg_7_ ( .D(alu_a[7]), .CK(clk), .Q(alu_r[7]) );
  DFFQX1 alu_r_reg_6_ ( .D(alu_a[6]), .CK(clk), .Q(alu_r[6]) );
  DFFQX1 alu_r_reg_5_ ( .D(alu_a[5]), .CK(clk), .Q(alu_r[5]) );
  DFFQX1 alu_r_reg_4_ ( .D(alu_a[4]), .CK(clk), .Q(alu_r[4]) );
  DFFQX1 alu_r_reg_3_ ( .D(alu_a[3]), .CK(clk), .Q(alu_r[3]) );
  DFFQX1 alu_r_reg_2_ ( .D(alu_a[2]), .CK(clk), .Q(alu_r[2]) );
  DFFRX1 latch_pc_reg_0_ ( .D(n536), .CK(clk), .RN(n483), .Q(latch_pc_0_) );
  DFFRX1 latch_pc_reg_1_ ( .D(n537), .CK(clk), .RN(n483), .Q(latch_pc_1_) );
  DFFRX1 latch_acc_reg_1_ ( .D(n495), .CK(clk), .RN(n483), .Q(latch_acc[1]), 
        .QN(n799) );
  DFFRX1 latch_pc_reg_8_ ( .D(n544), .CK(clk), .RN(n483), .QN(n776) );
  DFFQX1 alu_r_reg_1_ ( .D(alu_a[1]), .CK(clk), .Q(alu_r[1]) );
  DFFQX1 alu_r_reg_0_ ( .D(alu_a[0]), .CK(clk), .Q(alu_r[0]) );
  DFFRX1 latch_acc_reg_0_ ( .D(n494), .CK(clk), .RN(n483), .Q(latch_acc[0]), 
        .QN(n800) );
  DFFQX1 int_vec3_reg_2_ ( .D(int_vec2[2]), .CK(clk), .Q(int_vec3[2]) );
  DFFQX1 int_vec3_reg_1_ ( .D(int_vec2[1]), .CK(clk), .Q(int_vec3[1]) );
  XOR2X1 U1817 ( .A(out_pc_r_15_), .B(add_465_carry_15_), .Y(a_plus_pc_15_) );
  XOR2X1 U1818 ( .A(out_pc_r_14_), .B(add_465_carry_14_), .Y(a_plus_pc_14_) );
  XOR2X1 U1819 ( .A(out_pc_r_13_), .B(add_465_carry_13_), .Y(a_plus_pc_13_) );
  XOR2X1 U1820 ( .A(out_pc_r_12_), .B(add_465_carry_12_), .Y(a_plus_pc_12_) );
  XOR2X1 U1821 ( .A(out_pc_r_11_), .B(add_465_carry_11_), .Y(a_plus_pc_11_) );
  XOR2X1 U1822 ( .A(out_pc_r_10_), .B(add_465_carry_10_), .Y(a_plus_pc_10_) );
  XOR2X1 U1823 ( .A(out_pc_r_9_), .B(add_465_carry_9_), .Y(a_plus_pc_9_) );
  XOR2X1 U1824 ( .A(out_pc_r_8_), .B(add_465_carry_8_), .Y(a_plus_pc_8_) );
  AND2X1 U1825 ( .A(out_acc_r[0]), .B(N327), .Y(add_465_carry_1_) );
  XOR2X1 U1826 ( .A(out_pc_r_15_), .B(add_434_carry_15_), .Y(N342) );
  AND2X1 U1827 ( .A(add_434_carry_14_), .B(out_pc_r_14_), .Y(add_434_carry_15_) );
  XOR2X1 U1828 ( .A(out_pc_r_14_), .B(add_434_carry_14_), .Y(N341) );
  AND2X1 U1829 ( .A(add_434_carry_13_), .B(out_pc_r_13_), .Y(add_434_carry_14_) );
  XOR2X1 U1830 ( .A(out_pc_r_13_), .B(add_434_carry_13_), .Y(N340) );
  AND2X1 U1831 ( .A(add_434_carry_12_), .B(out_pc_r_12_), .Y(add_434_carry_13_) );
  XOR2X1 U1832 ( .A(out_pc_r_12_), .B(add_434_carry_12_), .Y(N339) );
  AND2X1 U1833 ( .A(add_434_carry_11_), .B(out_pc_r_11_), .Y(add_434_carry_12_) );
  XOR2X1 U1834 ( .A(out_pc_r_11_), .B(add_434_carry_11_), .Y(N338) );
  AND2X1 U1835 ( .A(add_434_carry_10_), .B(out_pc_r_10_), .Y(add_434_carry_11_) );
  XOR2X1 U1836 ( .A(out_pc_r_10_), .B(add_434_carry_10_), .Y(N337) );
  AND2X1 U1837 ( .A(add_434_carry_9_), .B(out_pc_r_9_), .Y(add_434_carry_10_)
         );
  XOR2X1 U1838 ( .A(out_pc_r_9_), .B(add_434_carry_9_), .Y(N336) );
  AND2X1 U1839 ( .A(add_434_carry_8_), .B(out_pc_r_8_), .Y(add_434_carry_9_)
         );
  XOR2X1 U1840 ( .A(out_pc_r_8_), .B(add_434_carry_8_), .Y(N335) );
  AND2X1 U1841 ( .A(add_434_carry_7_), .B(out_pc_r_7_), .Y(add_434_carry_8_)
         );
  XOR2X1 U1842 ( .A(out_pc_r_7_), .B(add_434_carry_7_), .Y(N334) );
  AND2X1 U1843 ( .A(add_434_carry_6_), .B(out_pc_r_6_), .Y(add_434_carry_7_)
         );
  XOR2X1 U1844 ( .A(out_pc_r_6_), .B(add_434_carry_6_), .Y(N333) );
  AND2X1 U1845 ( .A(add_434_carry_5_), .B(out_pc_r_5_), .Y(add_434_carry_6_)
         );
  XOR2X1 U1846 ( .A(out_pc_r_5_), .B(add_434_carry_5_), .Y(N332) );
  AND2X1 U1847 ( .A(add_434_carry_4_), .B(out_pc_r_4_), .Y(add_434_carry_5_)
         );
  XOR2X1 U1848 ( .A(out_pc_r_4_), .B(add_434_carry_4_), .Y(N331) );
  AND2X1 U1849 ( .A(add_434_carry_3_), .B(out_pc_r_3_), .Y(add_434_carry_4_)
         );
  XOR2X1 U1850 ( .A(out_pc_r_3_), .B(add_434_carry_3_), .Y(N330) );
  AND2X1 U1851 ( .A(add_434_carry_2_), .B(out_pc_r_2_), .Y(add_434_carry_3_)
         );
  XOR2X1 U1852 ( .A(out_pc_r_2_), .B(add_434_carry_2_), .Y(N329) );
  NAND3X6 U1853 ( .A(n619), .B(n1601), .C(n1606), .Y(n1469) );
  AO22X1 U1854 ( .A0(ld_instr), .A1(in_xrom_a[0]), .B0(code[0]), .B1(n408), 
        .Y(n552) );
  NOR2X2 U1855 ( .A(n1576), .B(n1577), .Y(n1571) );
  AOI21X4 U1856 ( .A0(n1454), .A1(n1602), .B0(n1455), .Y(n1613) );
  NAND2BX2 U1857 ( .AN(n761), .B(n1153), .Y(n1505) );
  NAND2BX2 U1858 ( .AN(n761), .B(n1138), .Y(n1463) );
  MXI2X4 U1859 ( .S0(n1602), .B(n1493), .A(n1088), .Y(n1618) );
  NAND2X1 U1860 ( .A(n1224), .B(out_acc_r[2]), .Y(n1360) );
  INVX6 U1861 ( .A(out_acc_r[2]), .Y(n995) );
  AO22X1 U1862 ( .A0(ld_instr), .A1(in_xrom_a[7]), .B0(code[7]), .B1(n408), 
        .Y(n559) );
  INVX1 U1863 ( .A(page_addr_a[10]), .Y(n1365) );
  INVX1 U1864 ( .A(page_addr_a[8]), .Y(n1112) );
  NAND2X2 U1865 ( .A(n611), .B(n1457), .Y(n760) );
  NOR2X1 U1866 ( .A(n1545), .B(n1477), .Y(n1544) );
  NAND4X1 U1867 ( .A(n768), .B(n613), .C(n1606), .D(n1601), .Y(n1554) );
  NOR2X1 U1868 ( .A(n1477), .B(n1578), .Y(n1577) );
  NOR3X1 U1869 ( .A(n617), .B(n1606), .C(n583), .Y(n1558) );
  MXI2X4 U1870 ( .S0(n1602), .B(n1492), .A(n1093), .Y(n1616) );
  AO22X1 U1871 ( .A0(ld_instr), .A1(in_xrom_a[3]), .B0(code[3]), .B1(n408), 
        .Y(n555) );
  CLKINVX1 U1872 ( .A(n1472), .Y(n1464) );
  NOR2X1 U1873 ( .A(n582), .B(n1473), .Y(n1574) );
  NOR2X1 U1874 ( .A(n580), .B(n1473), .Y(n1472) );
  NOR2X1 U1875 ( .A(n755), .B(n731), .Y(n1057) );
  NOR2X1 U1876 ( .A(n755), .B(n1092), .Y(n1058) );
  NAND2X6 U1877 ( .A(n832), .B(n89), .Y(\out_idat0[2] ) );
  NAND3X8 U1878 ( .A(n101), .B(n839), .C(n102), .Y(\out_idat0[1] ) );
  NAND2X6 U1879 ( .A(n841), .B(n11000), .Y(\out_idat0[0] ) );
  NAND4BX4 U1880 ( .AN(n849), .B(n850), .C(n851), .D(n852), .Y(n803) );
  NAND4BX4 U1881 ( .AN(n866), .B(n867), .C(n868), .D(n869), .Y(op2_6_) );
  NAND4BX4 U1882 ( .AN(n886), .B(n887), .C(n888), .D(n889), .Y(op2_4_) );
  NOR2X8 U1883 ( .A(n903), .B(n904), .Y(n897) );
  NAND3X8 U1884 ( .A(n929), .B(n930), .C(n177), .Y(op2_0_) );
  NAND4BX4 U1885 ( .AN(n964), .B(n965), .C(n966), .D(n691), .Y(op1[5]) );
  NAND4BX4 U1886 ( .AN(n981), .B(n982), .C(n983), .D(n690), .Y(op1[3]) );
  NAND4BX4 U1887 ( .AN(n989), .B(n990), .C(n991), .D(n677), .Y(op1[2]) );
  INVX8 U1888 ( .A(n833), .Y(n90) );
  INVX8 U1889 ( .A(n830), .Y(n81) );
  INVX8 U1890 ( .A(n815), .Y(n55) );
  INVX8 U1891 ( .A(n36), .Y(n47) );
  INVX8 U1892 ( .A(n813), .Y(n44) );
  INVX8 U1893 ( .A(n39), .Y(n34) );
  NOR2X8 U1894 ( .A(n1073), .B(n1074), .Y(n177) );
  INVX8 U1895 ( .A(n843), .Y(n10900) );
  OAI21X4 U1896 ( .A0(n1094), .A1(n1095), .B0(n1096), .Y(n36) );
  INVX16 U1897 ( .A(in_idat_a[1]), .Y(n924) );
  OAI21X4 U1898 ( .A0(n1222), .A1(n857), .B0(n1244), .Y(n1240) );
  INVX16 U1899 ( .A(in_idat_a[3]), .Y(n902) );
  XNOR2X4 U1900 ( .A(n1515), .B(n1516), .Y(n1153) );
  XNOR2X4 U1901 ( .A(n1528), .B(n1529), .Y(n1165) );
  XNOR2X4 U1902 ( .A(n1546), .B(n1547), .Y(n1178) );
  ACHCINX4 U1903 ( .A(out_dptr_r[5]), .B(out_acc_r[5]), .CIN(n1489), .CO(n1591) );
  AO22X1 U1904 ( .A0(ld_latch_acc), .A1(out_acc_r[2]), .B0(latch_acc[2]), .B1(
        n249), .Y(n496) );
  AO21X1 U1905 ( .A0(out_acc_r[2]), .A1(n12), .B0(n20), .Y(out_xdat[2]) );
  AO22X1 U1906 ( .A0(ld_instr), .A1(in_xrom_a[1]), .B0(code[1]), .B1(n408), 
        .Y(n553) );
  AO22X1 U1907 ( .A0(n630), .A1(n706), .B0(in_idat_r[0]), .B1(n15), .Y(n22) );
  AO22X1 U1908 ( .A0(ld_latch_acc), .A1(out_acc_r[1]), .B0(latch_acc[1]), .B1(
        n249), .Y(n495) );
  AO22X1 U1909 ( .A0(out_sfr_a[2]), .A1(ld_sfr), .B0(out_sfr_r[2]), .B1(n26), 
        .Y(n506) );
  AO22X1 U1910 ( .A0(out_sfr_a[1]), .A1(ld_sfr), .B0(out_sfr_r[1]), .B1(n26), 
        .Y(n505) );
  DFFRX1 addr2_r_reg_2_ ( .D(n669), .CK(clk), .RN(n483), .QN(n486) );
  AO22X1 U1911 ( .A0(ld_latch_acc), .A1(out_acc_r[0]), .B0(latch_acc[0]), .B1(
        n249), .Y(n494) );
  AO21X1 U1912 ( .A0(out_acc_r[0]), .A1(n12), .B0(n22), .Y(out_xdat[0]) );
  AO22X1 U1913 ( .A0(ld_instr), .A1(in_xrom_a[4]), .B0(n408), .B1(code[4]), 
        .Y(n556) );
  AO22X1 U1914 ( .A0(ld_instr), .A1(in_xrom_a[5]), .B0(n636), .B1(n408), .Y(
        n557) );
  AO22X1 U1915 ( .A0(ld_instr), .A1(in_xrom_a[6]), .B0(n641), .B1(n408), .Y(
        n558) );
  DFFRX1 addr2_r_reg_0_ ( .D(addr2_a_0_), .CK(clk), .RN(n483), .QN(n484) );
  NAND3BX1 U1916 ( .AN(sel_pc[1]), .B(sel_pc[0]), .C(sel_pc[2]), .Y(n362) );
  u_datapath_DW01_inc_16_0 add_433 ( .A({out_pc_r_15_, out_pc_r_14_, 
        out_pc_r_13_, out_pc_r_12_, out_pc_r_11_, out_pc_r_10_, out_pc_r_9_, 
        out_pc_r_8_, out_pc_r_7_, out_pc_r_6_, out_pc_r_5_, out_pc_r_4_, 
        out_pc_r_3_, out_pc_r_2_, add_434_carry_2_, N327}), .SUM({N324, N323, 
        N322, N321, N320, N319, N318, N317, N316, N315, N314, N313, N312, N311, 
        N310, N309}) );
  u_datapath_DW01_add_16_1 add_387 ( .A(in_rel_adder), .B({out_pc_r_15_, 
        out_pc_r_14_, out_pc_r_13_, out_pc_r_12_, out_pc_r_11_, out_pc_r_10_, 
        out_pc_r_9_, out_pc_r_8_, out_pc_r_7_, out_pc_r_6_, out_pc_r_5_, 
        out_pc_r_4_, out_pc_r_3_, out_pc_r_2_, add_434_carry_2_, N327}), .CI(
        1'b0), .SUM(rel_addr_a) );
  u_datapath_MUX_OP_8_3_2 C1170 ( .D0_1(in_idat_a[0]), .D0_0(out_sfr_a[0]), 
        .D1_1(in_idat_a[1]), .D1_0(out_sfr_a[1]), .D2_1(in_idat_a[2]), .D2_0(
        out_sfr_a[2]), .D3_1(in_idat_a[3]), .D3_0(n563), .D4_1(in_idat_a[4]), 
        .D4_0(out_sfr_a[4]), .D5_1(in_idat_a[5]), .D5_0(out_sfr_a[5]), .D6_1(
        in_idat_a[6]), .D6_0(out_sfr_a[6]), .D7_1(in_idat_a[7]), .D7_0(
        out_sfr_a[7]), .S0(addr2_a_0_), .S1(addr2_a_1_), .S2(n669), .Z_1(N110), 
        .Z_0(N109) );
  DFFRX4 in_xrom_r_reg_7_ ( .D(n535), .CK(clk), .RN(n483), .Q(in_xrom_r[7]), 
        .QN(n665) );
  DFFRX4 in_xrom_r_reg_6_ ( .D(n534), .CK(clk), .RN(n483), .Q(in_xrom_r[6]), 
        .QN(n566) );
  DFFRX4 in_xrom_r_reg_5_ ( .D(n533), .CK(clk), .RN(n483), .Q(in_xrom_r[5]), 
        .QN(n565) );
  DFFRX4 in_xrom_r_reg_4_ ( .D(n532), .CK(clk), .RN(n483), .Q(in_xrom_r[4]), 
        .QN(n568) );
  DFFRX4 in_xrom_r_reg_3_ ( .D(n531), .CK(clk), .RN(n483), .Q(in_xrom_r[3]), 
        .QN(n569) );
  DFFRX4 in_xrom_r_reg_2_ ( .D(n530), .CK(clk), .RN(n483), .Q(in_xrom_r[2]), 
        .QN(n570) );
  DFFRX4 in_xrom_r_reg_1_ ( .D(n529), .CK(clk), .RN(n483), .Q(in_xrom_r[1]), 
        .QN(n567) );
  DFFRX4 in_xrom_r_reg_0_ ( .D(n528), .CK(clk), .RN(n483), .Q(in_xrom_r[0]), 
        .QN(n745) );
  DFFRX4 in_xrom1_r_reg_7_ ( .D(n527), .CK(clk), .RN(n483), .Q(in_xrom1_r[7]), 
        .QN(n763) );
  DFFRX4 in_xrom1_r_reg_6_ ( .D(n526), .CK(clk), .RN(n483), .Q(in_xrom1_r[6]), 
        .QN(n783) );
  DFFRX4 in_xrom1_r_reg_5_ ( .D(n525), .CK(clk), .RN(n483), .Q(in_xrom1_r[5]), 
        .QN(n784) );
  DFFRX4 in_xrom1_r_reg_4_ ( .D(n524), .CK(clk), .RN(n483), .Q(in_xrom1_r[4]), 
        .QN(n785) );
  DFFRX4 in_xrom1_r_reg_3_ ( .D(n523), .CK(clk), .RN(n483), .Q(in_xrom1_r[3]), 
        .QN(n786) );
  DFFRX4 in_xrom1_r_reg_1_ ( .D(n521), .CK(clk), .RN(n483), .Q(in_xrom1_r[1]), 
        .QN(n788) );
  DFFRX4 in_idat_r_reg_7_ ( .D(n519), .CK(clk), .RN(n483), .Q(in_idat_r[7]), 
        .QN(n671) );
  DFFRX4 in_idat_r_reg_6_ ( .D(n518), .CK(clk), .RN(n483), .Q(in_idat_r[6]), 
        .QN(n580) );
  DFFRX4 in_idat_r_reg_5_ ( .D(n517), .CK(clk), .RN(n483), .Q(in_idat_r[5]), 
        .QN(n581) );
  DFFRX4 in_idat_r_reg_4_ ( .D(n516), .CK(clk), .RN(n483), .Q(in_idat_r[4]), 
        .QN(n576) );
  DFFRX4 in_idat_r_reg_3_ ( .D(n515), .CK(clk), .RN(n483), .Q(in_idat_r[3]), 
        .QN(n577) );
  DFFRX4 in_idat_r_reg_2_ ( .D(n514), .CK(clk), .RN(n483), .Q(in_idat_r[2]), 
        .QN(n578) );
  DFFRX4 in_idat_r_reg_1_ ( .D(n513), .CK(clk), .RN(n483), .Q(in_idat_r[1]), 
        .QN(n583) );
  DFFRX4 in_idat_r_reg_0_ ( .D(n512), .CK(clk), .RN(n483), .Q(in_idat_r[0]), 
        .QN(n582) );
  DFFRX4 out_sfr_r_reg_7_ ( .D(n511), .CK(clk), .RN(n483), .Q(out_sfr_r[7]), 
        .QN(n590) );
  DFFRX4 out_sfr_r_reg_1_ ( .D(n505), .CK(clk), .RN(n483), .Q(out_sfr_r[1]), 
        .QN(n589) );
  DFFRX4 out_sfr_r_reg_0_ ( .D(n504), .CK(clk), .RN(n483), .Q(out_sfr_r[0]), 
        .QN(n591) );
  DFFRX4 addr2_r_reg_7_ ( .D(addr_a[7]), .CK(clk), .RN(n483), .Q(msb_r), .QN(
        n790) );
endmodule


module u_datapath_MUX_OP_8_3_2 ( D0_1, D0_0, D1_1, D1_0, D2_1, D2_0, D3_1, 
        D3_0, D4_1, D4_0, D5_1, D5_0, D6_1, D6_0, D7_1, D7_0, S0, S1, S2, Z_1, 
        Z_0 );
  input D0_1, D0_0, D1_1, D1_0, D2_1, D2_0, D3_1, D3_0, D4_1, D4_0, D5_1, D5_0,
         D6_1, D6_0, D7_1, D7_0, S0, S1, S2;
  output Z_1, Z_0;
  wire   n1, n2, n3, n4;

  MX2X1 U7 ( .S0(S2), .B(n4), .A(n3), .Y(Z_1) );
  MX2X1 U8 ( .S0(S2), .B(n2), .A(n1), .Y(Z_0) );
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
         carry_2_, carry_1_;

  XOR3X1 U1_15 ( .A(A[15]), .B(B[15]), .C(carry_15_), .Y(SUM[15]) );
  ADDFX2 U1_1 ( .A(A[1]), .B(B[1]), .CI(carry_1_), .S(SUM[1]), .CO(carry_2_)
         );
  ADDFX2 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry_2_), .S(SUM[2]), .CO(carry_3_)
         );
  ADDFX2 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry_3_), .S(SUM[3]), .CO(carry_4_)
         );
  ADDFX2 U1_9 ( .A(A[9]), .B(B[9]), .CI(carry_9_), .S(SUM[9]), .CO(carry_10_)
         );
  ADDFX2 U1_4 ( .A(A[4]), .B(B[4]), .CI(carry_4_), .S(SUM[4]), .CO(carry_5_)
         );
  ADDFX2 U1_10 ( .A(A[10]), .B(B[10]), .CI(carry_10_), .S(SUM[10]), .CO(
        carry_11_) );
  ADDFX2 U1_5 ( .A(A[5]), .B(B[5]), .CI(carry_5_), .S(SUM[5]), .CO(carry_6_)
         );
  ADDFX2 U1_11 ( .A(A[11]), .B(B[11]), .CI(carry_11_), .S(SUM[11]), .CO(
        carry_12_) );
  ADDFX2 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry_6_), .S(SUM[6]), .CO(carry_7_)
         );
  ADDFX2 U1_12 ( .A(A[12]), .B(B[12]), .CI(carry_12_), .S(SUM[12]), .CO(
        carry_13_) );
  ADDFX2 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry_7_), .S(SUM[7]), .CO(carry_8_)
         );
  ADDFX2 U1_13 ( .A(A[13]), .B(B[13]), .CI(carry_13_), .S(SUM[13]), .CO(
        carry_14_) );
  ADDFX2 U1_8 ( .A(A[8]), .B(B[8]), .CI(carry_8_), .S(SUM[8]), .CO(carry_9_)
         );
  ADDFX2 U1_14 ( .A(A[14]), .B(B[14]), .CI(carry_14_), .S(SUM[14]), .CO(
        carry_15_) );
  AND2X1 U4 ( .A(A[0]), .B(B[0]), .Y(carry_1_) );
  XOR2X1 U5 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module u_datapath_DW01_inc_16_0 ( A, SUM );
  input [15:0] A;
  output [15:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_, n1;

  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  ADDHX1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(carry_13_) );
  ADDHX1 U1_1_13 ( .A(A[13]), .B(carry_13_), .S(SUM[13]), .CO(carry_14_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  ADDHX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  ADDHX1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  ADDHX1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  ADDHX1 U1_1_14 ( .A(A[14]), .B(carry_14_), .S(SUM[14]), .CO(carry_15_) );
  XNOR2X1 U6 ( .A(carry_15_), .B(n1), .Y(SUM[15]) );
  CLKINVX1 U7 ( .A(A[15]), .Y(n1) );
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
         n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24;
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

  swap U2_swap ( .d({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .q(s_SWAP) );
  rrc U3_rrc ( .d({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .in_cy(IN_C), 
        .out_cy(s_CY_RRC), .q(s_RRC) );
  rr U4_rr ( .d({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .q(s_RR) );
  rlc U5_rlc ( .d({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .in_cy(IN_C), 
        .out_cy(s_CY_RLC), .q(s_RLC) );
  rl U6_rl ( .d({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .q(s_RL) );
  da U7_da ( .d({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .ac(IN_AC), .cy(
        IN_C), .q(s_DA) );
  div U8_div ( .clk(clk), .rst_p(rst_p), .Load(en_div), .Dividend({n24, n23, 
        n22, n21, n20, n19, OP_A[1:0]}), .Divisor({OP_B[7:5], n10, OP_B[3], 
        n11, n9, OP_B[0]}), .Quotient(s_Q), .Remainder(s_R) );
  mul U9_mul ( .op1({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .op2(OP_B), 
        .m(s_M) );
  sel_arth U10_sel_arth ( .iop2({OP_B[7:2], n9, OP_B[0]}), .icin(IN_C), .sel(
        SEL[2:0]), .oop2(oOP_B), .ocin(ocy) );
  sel_al U11_sel_al ( .isel(SEL), .osel(s_sel) );
  adc U12_adc ( .dataa({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .datab(
        oOP_B), .cin(ocy), .ac(s_AC_ADDC), .cout(s_CY_ADDC), .overflow(
        s_OV_ADDC), .result(s_ADDC) );
  xchd U_xchd ( .in_acc({n24, n23, n22, n21, n20, n19, OP_A[1:0]}), .in_ram({
        OP_B[7:3], n11, n9, OP_B[0]}), .out_acc(acc_chd), .out_ram(s_ram_chd)
         );
  mux16t1_8 U18_sel_alu ( .a0(s_ADDC), .a1(s_M[7:0]), .a2(s_Q), .a3(s_DA), 
        .a4(s_AND), .a5(s_OR), .a6(s_XOR), .a7({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0}), .a8(s_INV), .a9(s_RL), .b0(s_RLC), .b1(s_RR), .b2(
        s_RRC), .b3(s_SWAP), .b4({1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 
        1'b1}), .b5(s_ram_chd), .sel(s_sel), .qq(ALU) );
  alu_flag_d_m U19_alu_flag ( .al(SEL), .m(s_M[15:8]), .r(s_R), .dividor({
        OP_B[7:5], n10, OP_B[3], n11, n9, OP_B[0]}), .cy_addc(s_CY_ADDC), 
        .cy_rlc(s_CY_RLC), .cy_rrc(s_CY_RRC), .ac_addc(s_AC_ADDC), .ov_addc(
        s_OV_ADDC), .cy(CY), .ac(AC), .ov(OV), .IN_B(IN_B) );
  INVX1 U43 ( .A(n18), .Y(n9) );
  BUFX8 U44 ( .A(OP_A[4]), .Y(n21) );
  BUFX8 U45 ( .A(OP_A[6]), .Y(n23) );
  BUFX8 U46 ( .A(OP_A[7]), .Y(n24) );
  BUFX12 U47 ( .A(OP_A[5]), .Y(n22) );
  INVX1 U48 ( .A(n15), .Y(n10) );
  INVX1 U49 ( .A(n17), .Y(n11) );
  INVX1 U50 ( .A(n22), .Y(s_INV[5]) );
  INVX1 U51 ( .A(n24), .Y(s_INV[7]) );
  NOR2X1 U52 ( .A(s_INV[5]), .B(n14), .Y(s_AND[5]) );
  NOR2X1 U53 ( .A(s_INV[3]), .B(n16), .Y(s_AND[3]) );
  INVX1 U54 ( .A(n20), .Y(s_INV[3]) );
  INVX1 U55 ( .A(n19), .Y(s_INV[2]) );
  NAND2X1 U56 ( .A(n13), .B(s_INV[6]), .Y(s_OR[6]) );
  XNOR2X1 U57 ( .A(n23), .B(n13), .Y(s_XOR[6]) );
  XNOR2X1 U58 ( .A(n21), .B(n15), .Y(s_XOR[4]) );
  NAND2X1 U59 ( .A(n14), .B(s_INV[5]), .Y(s_OR[5]) );
  NOR2X1 U60 ( .A(s_INV[7]), .B(n12), .Y(s_AND[7]) );
  XNOR2X1 U61 ( .A(n24), .B(n12), .Y(s_XOR[7]) );
  NAND2X1 U62 ( .A(n12), .B(s_INV[7]), .Y(s_OR[7]) );
  INVX1 U63 ( .A(n23), .Y(s_INV[6]) );
  INVX1 U64 ( .A(n21), .Y(s_INV[4]) );
  NAND2X1 U65 ( .A(n15), .B(s_INV[4]), .Y(s_OR[4]) );
  NOR2X1 U66 ( .A(s_INV[4]), .B(n15), .Y(s_AND[4]) );
  XNOR2X1 U67 ( .A(n19), .B(n17), .Y(s_XOR[2]) );
  XNOR2X1 U68 ( .A(n22), .B(n14), .Y(s_XOR[5]) );
  XNOR2X1 U69 ( .A(n20), .B(n16), .Y(s_XOR[3]) );
  NAND2X1 U70 ( .A(n16), .B(s_INV[3]), .Y(s_OR[3]) );
  NOR2X1 U71 ( .A(s_INV[6]), .B(n13), .Y(s_AND[6]) );
  NOR2X1 U72 ( .A(s_INV[1]), .B(n18), .Y(s_AND[1]) );
  XNOR2X1 U73 ( .A(OP_A[1]), .B(n18), .Y(s_XOR[1]) );
  NAND2X1 U74 ( .A(n18), .B(s_INV[1]), .Y(s_OR[1]) );
  NOR2X1 U75 ( .A(s_INV[2]), .B(n17), .Y(s_AND[2]) );
  NAND2X1 U76 ( .A(n17), .B(s_INV[2]), .Y(s_OR[2]) );
  INVX1 U77 ( .A(OP_A[1]), .Y(s_INV[1]) );
  NOR2X1 U78 ( .A(s_INV[0]), .B(n8), .Y(s_AND[0]) );
  INVX1 U79 ( .A(OP_B[7]), .Y(n12) );
  INVX1 U80 ( .A(OP_B[4]), .Y(n15) );
  INVX1 U81 ( .A(OP_A[0]), .Y(s_INV[0]) );
  INVX1 U82 ( .A(OP_B[2]), .Y(n17) );
  INVX1 U83 ( .A(OP_B[0]), .Y(n8) );
  INVX1 U84 ( .A(OP_B[3]), .Y(n16) );
  INVX1 U85 ( .A(OP_B[1]), .Y(n18) );
  INVX1 U86 ( .A(OP_B[5]), .Y(n14) );
  NAND2X1 U87 ( .A(n8), .B(s_INV[0]), .Y(s_OR[0]) );
  XNOR2X1 U88 ( .A(OP_A[0]), .B(n8), .Y(s_XOR[0]) );
  INVX1 U89 ( .A(OP_B[6]), .Y(n13) );
  BUFX20 U90 ( .A(OP_A[2]), .Y(n19) );
  BUFX20 U91 ( .A(OP_A[3]), .Y(n20) );
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
  wire   n3, n4, n5, n6, n7, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18,
         n20, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n37, n38,
         n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n70;

  AOI33X4 U23 ( .A0(cy_rrc), .A1(al[4]), .A2(n29), .B0(n17), .B1(n30), .B2(
        cy_addc), .Y(n28) );
  OAI33X4 U27 ( .A0(n20), .A1(al[1]), .A2(n31), .B0(n20), .B1(n17), .B2(n32), 
        .Y(ac) );
  INVX1 U48 ( .A(m[0]), .Y(n13) );
  NAND4X1 U49 ( .A(n45), .B(n46), .C(n47), .D(n12), .Y(n40) );
  CLKINVX1 U50 ( .A(n39), .Y(ov) );
  CLKINVX1 U51 ( .A(m[3]), .Y(n16) );
  CLKINVX1 U52 ( .A(m[2]), .Y(n15) );
  INVX1 U53 ( .A(m[5]), .Y(n10) );
  INVX1 U54 ( .A(m[6]), .Y(n11) );
  INVX1 U55 ( .A(m[4]), .Y(n9) );
  INVX3 U56 ( .A(m[7]), .Y(n12) );
  INVX1 U57 ( .A(al[3]), .Y(n27) );
  INVX1 U58 ( .A(al[1]), .Y(n17) );
  NAND2X1 U59 ( .A(n55), .B(n10), .Y(n50) );
  NAND2X1 U60 ( .A(n48), .B(n4), .Y(n44) );
  AND3X1 U61 ( .A(n69), .B(al[1]), .C(n38), .Y(n37) );
  INVX1 U62 ( .A(al[2]), .Y(n25) );
  NAND4X1 U63 ( .A(n13), .B(n14), .C(n15), .D(n16), .Y(n52) );
  CLKINVX1 U64 ( .A(m[1]), .Y(n14) );
  NAND3X1 U65 ( .A(n9), .B(n10), .C(n11), .Y(n51) );
  INVX1 U66 ( .A(m[6]), .Y(n47) );
  NAND2X1 U67 ( .A(n40), .B(n41), .Y(n39) );
  NAND2X1 U68 ( .A(n42), .B(n43), .Y(n41) );
  CLKINVX1 U69 ( .A(n43), .Y(n33) );
  CLKINVX1 U70 ( .A(n20), .Y(n57) );
  INVX1 U71 ( .A(n50), .Y(n45) );
  CLKINVX1 U72 ( .A(n44), .Y(n46) );
  CLKINVX1 U73 ( .A(n44), .Y(n42) );
  NAND2X1 U74 ( .A(n25), .B(n38), .Y(n20) );
  NAND3X1 U75 ( .A(n70), .B(n17), .C(n38), .Y(n43) );
  NOR2X1 U76 ( .A(n25), .B(n18), .Y(n70) );
  NAND3X1 U77 ( .A(n11), .B(n54), .C(n12), .Y(n53) );
  CLKINVX1 U78 ( .A(n50), .Y(n54) );
  NOR2X1 U79 ( .A(n52), .B(m[4]), .Y(n55) );
  OAI33X1 U80 ( .A0(n23), .A1(al[3]), .A2(al[2]), .B0(n24), .B1(n25), .B2(n26), 
        .Y(cy) );
  NAND2BX1 U81 ( .AN(n27), .B(cy_rlc), .Y(n26) );
  OA21X2 U82 ( .A0(cy_addc), .A1(n24), .B0(n28), .Y(n23) );
  NAND2X1 U83 ( .A(n37), .B(n49), .Y(n48) );
  NAND3X1 U84 ( .A(n56), .B(n57), .C(ov_addc), .Y(n4) );
  CLKINVX1 U85 ( .A(n3), .Y(n49) );
  NAND2BX1 U86 ( .AN(al[0]), .B(n31), .Y(n32) );
  INVX1 U87 ( .A(ac_addc), .Y(n31) );
  INVX1 U88 ( .A(al[0]), .Y(n18) );
  NOR2X1 U89 ( .A(n25), .B(al[0]), .Y(n69) );
  AND2X2 U90 ( .A(n30), .B(n27), .Y(n38) );
  NAND2X1 U91 ( .A(al[1]), .B(al[0]), .Y(n56) );
  NOR2BX1 U92 ( .AN(n18), .B(al[1]), .Y(n29) );
  NAND4X1 U93 ( .A(n58), .B(n59), .C(n60), .D(n61), .Y(n3) );
  NOR2X1 U94 ( .A(dividor[1]), .B(dividor[0]), .Y(n58) );
  NOR2X1 U95 ( .A(dividor[3]), .B(dividor[2]), .Y(n59) );
  NAND3BX1 U96 ( .AN(al[4]), .B(n18), .C(al[1]), .Y(n24) );
  INVX1 U97 ( .A(al[4]), .Y(n30) );
  OAI21X1 U98 ( .A0(n10), .A1(n43), .B0(n64), .Y(IN_B[5]) );
  NAND2X1 U99 ( .A(r[5]), .B(n37), .Y(n64) );
  OAI21X1 U100 ( .A0(n11), .A1(n43), .B0(n63), .Y(IN_B[6]) );
  NAND2X1 U101 ( .A(r[6]), .B(n37), .Y(n63) );
  OAI21X1 U102 ( .A0(n12), .A1(n43), .B0(n62), .Y(IN_B[7]) );
  NAND2X1 U103 ( .A(r[7]), .B(n37), .Y(n62) );
  OAI21X1 U104 ( .A0(n15), .A1(n43), .B0(n67), .Y(IN_B[2]) );
  NAND2X1 U105 ( .A(r[2]), .B(n37), .Y(n67) );
  OAI21X1 U106 ( .A0(n9), .A1(n43), .B0(n65), .Y(IN_B[4]) );
  NAND2X1 U107 ( .A(r[4]), .B(n37), .Y(n65) );
  OAI21X1 U108 ( .A0(n16), .A1(n43), .B0(n66), .Y(IN_B[3]) );
  NAND2X1 U109 ( .A(r[3]), .B(n37), .Y(n66) );
  OAI21X1 U110 ( .A0(n14), .A1(n43), .B0(n68), .Y(IN_B[1]) );
  NAND2X1 U111 ( .A(r[1]), .B(n37), .Y(n68) );
  AO22X1 U112 ( .A0(m[0]), .A1(n33), .B0(r[0]), .B1(n37), .Y(IN_B[0]) );
  NOR2X1 U113 ( .A(dividor[5]), .B(dividor[4]), .Y(n60) );
  NOR2X1 U114 ( .A(dividor[7]), .B(dividor[6]), .Y(n61) );
  NOR2X8 U115 ( .A(n51), .B(m[7]), .Y(n7) );
  INVX8 U116 ( .A(n52), .Y(n6) );
  NAND2X6 U117 ( .A(n33), .B(n53), .Y(n5) );
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
  wire   n2, n4, n7, n15, n29, n30, n38, n45, n47, n53, n56, n57, n65, n66,
         n72, n74, n75, n77, n78, n81, n82, n83, n84, n93, n104, n105, n125,
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
         n236, n237, n238, n239, n240, n241, n242, n243, n244, n245, n246,
         n247, n248, n249, n250, n251, n252, n253, n254, n255, n256, n257,
         n258, n259, n260, n261, n262, n263, n264, n265, n266, n267, n268,
         n269, n270, n271, n272, n273, n274, n275, n276, n277, n278, n279,
         n280, n281, n282, n283, n284, n285, n286, n287, n288, n289, n290,
         n291, n292, n293, n294, n295, n296, n297, n298, n299, n300, n301,
         n302, n303, n304, n305, n306, n307, n308, n309, n310, n311, n312,
         n313, n314, n315, n316, n317, n318, n319, n320, n321, n322, n323,
         n324, n325, n326, n327, n328, n329, n330, n331, n332, n333, n334,
         n335, n336, n337, n338, n339, n340, n341, n342, n343, n344, n345,
         n346, n347, n348, n349, n350, n351, n352, n353, n354, n355, n356,
         n357, n358, n359, n360, n361, n362, n363, n364, n365, n366, n367,
         n368, n369, n370, n371, n372, n373, n374, n375, n376, n377, n378,
         n379, n380, n381, n382, n383, n384, n385, n386, n387, n388, n389,
         n390, n391, n392, n393, n394, n395, n396, n397, n398, n399, n400,
         n401, n402, n403, n404, n405, n406, n407, n408, n409, n410;

  AND2X2 U135 ( .A(n410), .B(n407), .Y(n129) );
  NAND2X1 U136 ( .A(a3[5]), .B(n128), .Y(n381) );
  NAND2X1 U137 ( .A(a3[4]), .B(n128), .Y(n354) );
  CLKINVX1 U138 ( .A(b3[5]), .Y(n212) );
  OAI21X1 U139 ( .A0(n151), .A1(n296), .B0(n297), .Y(n93) );
  NOR3X1 U140 ( .A(n358), .B(n359), .C(n360), .Y(n357) );
  NOR3X1 U141 ( .A(n304), .B(n305), .C(n306), .Y(n303) );
  OA21X4 U142 ( .A0(n286), .A1(n380), .B0(n381), .Y(n125) );
  OA21X4 U143 ( .A0(n286), .A1(n353), .B0(n354), .Y(n126) );
  AND2X2 U144 ( .A(sel[0]), .B(n410), .Y(n127) );
  AND2X2 U145 ( .A(n132), .B(n130), .Y(n128) );
  CLKINVX1 U146 ( .A(n350), .Y(n47) );
  CLKINVX1 U147 ( .A(n343), .Y(n56) );
  INVX1 U148 ( .A(sel[2]), .Y(n387) );
  AND2X2 U149 ( .A(sel[3]), .B(n387), .Y(n134) );
  AND2X1 U150 ( .A(sel[1]), .B(n407), .Y(n133) );
  INVX1 U151 ( .A(sel[3]), .Y(n300) );
  NAND2X2 U152 ( .A(n133), .B(n130), .Y(n286) );
  INVX1 U153 ( .A(n286), .Y(n376) );
  NAND2X2 U154 ( .A(n374), .B(n375), .Y(n7) );
  CLKINVX1 U155 ( .A(n312), .Y(n74) );
  CLKINVX1 U156 ( .A(n72), .Y(n272) );
  NAND2X2 U157 ( .A(n134), .B(n132), .Y(n178) );
  NAND2X1 U158 ( .A(n134), .B(n129), .Y(n186) );
  AND2X1 U159 ( .A(sel[2]), .B(sel[3]), .Y(n131) );
  INVX1 U160 ( .A(n7), .Y(n140) );
  NAND2X4 U161 ( .A(n383), .B(n384), .Y(n160) );
  INVX1 U162 ( .A(n30), .Y(n384) );
  INVX3 U163 ( .A(n291), .Y(n349) );
  INVX1 U164 ( .A(n199), .Y(n189) );
  INVX1 U165 ( .A(n178), .Y(n260) );
  NAND2X1 U166 ( .A(n129), .B(n130), .Y(n291) );
  NAND2X1 U167 ( .A(n135), .B(n129), .Y(n147) );
  INVX1 U168 ( .A(sel[1]), .Y(n410) );
  NAND4X1 U169 ( .A(n156), .B(n157), .C(n158), .D(n159), .Y(qq[6]) );
  CLKINVX3 U170 ( .A(n160), .Y(n158) );
  NAND2X1 U171 ( .A(n284), .B(n285), .Y(n283) );
  NAND2X1 U172 ( .A(b5[3]), .B(n184), .Y(n236) );
  NAND3X1 U173 ( .A(n236), .B(n237), .C(n238), .Y(n231) );
  NAND2X1 U174 ( .A(b0[5]), .B(n183), .Y(n203) );
  NAND2X1 U175 ( .A(a6[6]), .B(n172), .Y(n171) );
  NAND2X1 U176 ( .A(b0[6]), .B(n183), .Y(n182) );
  NAND2X2 U177 ( .A(n131), .B(n129), .Y(n209) );
  NAND2X1 U178 ( .A(n134), .B(n127), .Y(n199) );
  NAND2X1 U179 ( .A(n131), .B(n132), .Y(n328) );
  NAND2X1 U180 ( .A(n131), .B(n133), .Y(n330) );
  AND2X4 U181 ( .A(n300), .B(n387), .Y(n130) );
  AND2X1 U182 ( .A(sel[1]), .B(sel[0]), .Y(n132) );
  AND2X1 U183 ( .A(sel[2]), .B(n300), .Y(n135) );
  NAND2X1 U184 ( .A(a1[6]), .B(n289), .Y(n159) );
  NOR3X1 U185 ( .A(n195), .B(n196), .C(n197), .Y(n191) );
  CLKINVX3 U186 ( .A(n139), .Y(n136) );
  INVX3 U187 ( .A(a1[7]), .Y(n138) );
  NAND2X2 U188 ( .A(a0[6]), .B(n349), .Y(n383) );
  NOR3X1 U189 ( .A(n231), .B(n232), .C(n233), .Y(n227) );
  INVX1 U190 ( .A(n45), .Y(n216) );
  INVX1 U191 ( .A(n75), .Y(n314) );
  INVX3 U192 ( .A(n137), .Y(n289) );
  INVX1 U193 ( .A(n330), .Y(n185) );
  INVX1 U194 ( .A(n149), .Y(n166) );
  INVX1 U195 ( .A(n154), .Y(n173) );
  INVX1 U196 ( .A(n269), .Y(n183) );
  INVX1 U197 ( .A(n328), .Y(n184) );
  INVX1 U198 ( .A(n211), .Y(n168) );
  INVX1 U199 ( .A(n209), .Y(n167) );
  INVX1 U200 ( .A(n147), .Y(n174) );
  INVX1 U201 ( .A(a8[5]), .Y(n198) );
  INVX1 U202 ( .A(a8[3]), .Y(n234) );
  INVX1 U203 ( .A(a8[2]), .Y(n264) );
  INVX1 U204 ( .A(a8[6]), .Y(n187) );
  NAND2X1 U205 ( .A(n130), .B(n127), .Y(n137) );
  NAND2X1 U206 ( .A(n131), .B(n127), .Y(n211) );
  NAND2X1 U207 ( .A(n135), .B(n133), .Y(n151) );
  CLKINVX1 U208 ( .A(b3[3]), .Y(n245) );
  CLKINVX1 U209 ( .A(b2[5]), .Y(n210) );
  CLKINVX1 U210 ( .A(b2[3]), .Y(n244) );
  CLKINVX1 U211 ( .A(b1[3]), .Y(n246) );
  INVX1 U212 ( .A(b3[0]), .Y(n311) );
  INVX1 U213 ( .A(a4[0]), .Y(n299) );
  INVX1 U214 ( .A(a4[2]), .Y(n256) );
  INVX1 U215 ( .A(a5[2]), .Y(n255) );
  CLKINVX2 U216 ( .A(b5[1]), .Y(n329) );
  CLKINVX1 U217 ( .A(b1[5]), .Y(n213) );
  INVX3 U218 ( .A(sel[0]), .Y(n407) );
  NAND3X1 U219 ( .A(n82), .B(n282), .C(n83), .Y(qq[0]) );
  OAI21X1 U220 ( .A0(n269), .A1(n333), .B0(n334), .Y(n77) );
  NAND4X1 U221 ( .A(n140), .B(n141), .C(n142), .D(n143), .Y(n139) );
  NAND4BX1 U222 ( .AN(n190), .B(n191), .C(n192), .D(n38), .Y(qq[5]) );
  NAND2X1 U223 ( .A(n204), .B(n205), .Y(n190) );
  NOR3X2 U224 ( .A(n175), .B(n176), .C(n177), .Y(n156) );
  CLKINVX1 U225 ( .A(n377), .Y(n38) );
  NAND3X1 U226 ( .A(n378), .B(n125), .C(n379), .Y(n377) );
  NAND4BX1 U227 ( .AN(n226), .B(n227), .C(n228), .D(n56), .Y(qq[3]) );
  NAND2X1 U228 ( .A(n239), .B(n240), .Y(n226) );
  NAND3X1 U229 ( .A(n216), .B(n217), .C(n47), .Y(qq[4]) );
  NAND3X1 U230 ( .A(n351), .B(n126), .C(n352), .Y(n350) );
  NAND2X1 U231 ( .A(a1[4]), .B(n289), .Y(n352) );
  CLKINVX1 U232 ( .A(n57), .Y(n345) );
  NAND4BX1 U233 ( .AN(n249), .B(n250), .C(n251), .D(n65), .Y(qq[2]) );
  OAI21X1 U234 ( .A0(n151), .A1(n270), .B0(n271), .Y(n249) );
  NOR3X2 U235 ( .A(n261), .B(n262), .C(n263), .Y(n250) );
  NAND3X1 U236 ( .A(n272), .B(n273), .C(n74), .Y(qq[1]) );
  NAND3X1 U237 ( .A(n355), .B(n356), .C(n357), .Y(n45) );
  NOR3X2 U238 ( .A(n364), .B(n365), .C(n366), .Y(n356) );
  CLKINVX1 U239 ( .A(n53), .Y(n355) );
  NAND2X1 U240 ( .A(n313), .B(n314), .Y(n312) );
  NOR2X1 U241 ( .A(n209), .B(n332), .Y(n325) );
  NAND3X1 U242 ( .A(n301), .B(n302), .C(n303), .Y(n81) );
  CLKINVX1 U243 ( .A(n104), .Y(n302) );
  NAND2X1 U244 ( .A(n294), .B(n295), .Y(n293) );
  NAND2X1 U245 ( .A(a1[3]), .B(n289), .Y(n346) );
  OAI21X1 U246 ( .A0(n286), .A1(n339), .B0(n340), .Y(n66) );
  OAI21X1 U247 ( .A0(n286), .A1(n347), .B0(n348), .Y(n57) );
  NOR2X1 U248 ( .A(n153), .B(n2), .Y(n141) );
  NOR2X1 U249 ( .A(n154), .B(n155), .Y(n153) );
  NAND3X1 U250 ( .A(n388), .B(n389), .C(n390), .Y(n2) );
  OAI21X1 U251 ( .A0(n286), .A1(n315), .B0(n316), .Y(n75) );
  NAND3X1 U252 ( .A(n180), .B(n181), .C(n182), .Y(n176) );
  NAND3X1 U253 ( .A(n201), .B(n202), .C(n203), .Y(n195) );
  NAND2X1 U254 ( .A(n405), .B(n406), .Y(n105) );
  NAND3X1 U255 ( .A(n266), .B(n267), .C(n268), .Y(n261) );
  NAND3X1 U256 ( .A(n169), .B(n170), .C(n171), .Y(n161) );
  INVX1 U257 ( .A(a6[0]), .Y(n296) );
  NOR2X1 U258 ( .A(n154), .B(n222), .Y(n221) );
  CLKINVX1 U259 ( .A(b2[7]), .Y(n401) );
  CLKINVX1 U260 ( .A(n143), .Y(n373) );
  NAND2X1 U261 ( .A(a0[7]), .B(n349), .Y(n143) );
  INVX1 U262 ( .A(n151), .Y(n172) );
  NOR3X1 U263 ( .A(n206), .B(n207), .C(n208), .Y(n205) );
  NOR2X1 U264 ( .A(n211), .B(n212), .Y(n207) );
  NOR2X1 U265 ( .A(n178), .B(n213), .Y(n206) );
  NOR2X1 U266 ( .A(n209), .B(n210), .Y(n208) );
  NAND3X1 U267 ( .A(n163), .B(n164), .C(n165), .Y(n162) );
  NAND2X1 U268 ( .A(b3[6]), .B(n168), .Y(n163) );
  NAND2X1 U269 ( .A(b2[6]), .B(n167), .Y(n164) );
  NAND2X1 U270 ( .A(a5[6]), .B(n166), .Y(n165) );
  CLKINVX1 U271 ( .A(a8[7]), .Y(n396) );
  NAND2X1 U272 ( .A(n135), .B(n132), .Y(n154) );
  NAND2X1 U273 ( .A(n135), .B(n127), .Y(n149) );
  NAND2X1 U274 ( .A(n134), .B(n133), .Y(n269) );
  OAI21X1 U275 ( .A0(n186), .A1(n187), .B0(n188), .Y(n175) );
  NAND2X1 U276 ( .A(a9[6]), .B(n189), .Y(n188) );
  NOR3X1 U277 ( .A(n241), .B(n242), .C(n243), .Y(n240) );
  NOR2X1 U278 ( .A(n211), .B(n245), .Y(n242) );
  NOR2X1 U279 ( .A(n178), .B(n246), .Y(n241) );
  NOR2X1 U280 ( .A(n209), .B(n244), .Y(n243) );
  NOR2X1 U281 ( .A(n186), .B(n363), .Y(n358) );
  CLKINVX1 U282 ( .A(a8[4]), .Y(n363) );
  NOR2X1 U283 ( .A(n186), .B(n264), .Y(n263) );
  NAND3X1 U284 ( .A(n257), .B(n258), .C(n259), .Y(n252) );
  NAND2X1 U285 ( .A(b2[2]), .B(n167), .Y(n257) );
  NAND2X1 U286 ( .A(b1[2]), .B(n260), .Y(n258) );
  NAND2X1 U287 ( .A(b3[2]), .B(n168), .Y(n259) );
  NOR2X1 U288 ( .A(n186), .B(n234), .Y(n233) );
  NOR2X1 U289 ( .A(n186), .B(n198), .Y(n197) );
  NOR2X1 U290 ( .A(n151), .B(n223), .Y(n220) );
  CLKINVX1 U291 ( .A(a6[4]), .Y(n223) );
  AOI21X1 U292 ( .A0(a5[5]), .A1(n166), .B0(n214), .Y(n204) );
  NOR2X1 U293 ( .A(n147), .B(n215), .Y(n214) );
  CLKINVX1 U294 ( .A(a4[5]), .Y(n215) );
  NOR2X1 U295 ( .A(n147), .B(n148), .Y(n146) );
  CLKINVX1 U296 ( .A(a4[7]), .Y(n148) );
  NOR2X1 U297 ( .A(n151), .B(n152), .Y(n144) );
  CLKINVX1 U298 ( .A(a6[7]), .Y(n152) );
  NOR2X1 U299 ( .A(n149), .B(n150), .Y(n145) );
  CLKINVX1 U300 ( .A(a5[7]), .Y(n150) );
  NOR2X1 U301 ( .A(n291), .B(n342), .Y(n341) );
  CLKINVX1 U302 ( .A(a0[2]), .Y(n342) );
  NOR2X1 U303 ( .A(n149), .B(n224), .Y(n219) );
  CLKINVX1 U304 ( .A(a5[4]), .Y(n224) );
  NOR2X1 U305 ( .A(n147), .B(n225), .Y(n218) );
  CLKINVX1 U306 ( .A(a4[4]), .Y(n225) );
  NOR2X1 U307 ( .A(n178), .B(n369), .Y(n364) );
  CLKINVX1 U308 ( .A(b1[4]), .Y(n369) );
  CLKINVX1 U309 ( .A(b3[7]), .Y(n402) );
  CLKINVX1 U310 ( .A(a9[7]), .Y(n394) );
  CLKINVX1 U311 ( .A(a6[2]), .Y(n270) );
  AOI21X1 U312 ( .A0(a5[3]), .A1(n166), .B0(n247), .Y(n239) );
  NOR2X1 U313 ( .A(n147), .B(n248), .Y(n247) );
  CLKINVX1 U314 ( .A(a4[3]), .Y(n248) );
  NOR2X1 U315 ( .A(n147), .B(n281), .Y(n274) );
  CLKINVX1 U316 ( .A(a4[1]), .Y(n281) );
  NOR2X1 U317 ( .A(n151), .B(n279), .Y(n276) );
  CLKINVX1 U318 ( .A(a6[1]), .Y(n279) );
  NOR2X1 U319 ( .A(n149), .B(n280), .Y(n275) );
  CLKINVX1 U320 ( .A(a5[1]), .Y(n280) );
  NOR2X1 U321 ( .A(n209), .B(n308), .Y(n305) );
  CLKINVX1 U322 ( .A(b2[0]), .Y(n308) );
  NOR2X1 U323 ( .A(n147), .B(n256), .Y(n253) );
  NOR2X1 U324 ( .A(n178), .B(n307), .Y(n306) );
  CLKINVX1 U325 ( .A(b1[0]), .Y(n307) );
  NOR2X1 U326 ( .A(n149), .B(n255), .Y(n254) );
  NOR2X1 U327 ( .A(n211), .B(n311), .Y(n310) );
  NOR2X1 U328 ( .A(n178), .B(n179), .Y(n177) );
  CLKINVX1 U329 ( .A(b1[6]), .Y(n179) );
  NOR2X1 U330 ( .A(n199), .B(n200), .Y(n196) );
  CLKINVX1 U331 ( .A(a9[5]), .Y(n200) );
  NOR2X1 U332 ( .A(n199), .B(n265), .Y(n262) );
  CLKINVX1 U333 ( .A(a9[2]), .Y(n265) );
  NOR2X1 U334 ( .A(n199), .B(n361), .Y(n360) );
  CLKINVX1 U335 ( .A(a9[4]), .Y(n361) );
  NOR2X1 U336 ( .A(n147), .B(n299), .Y(n298) );
  NOR2X1 U337 ( .A(n199), .B(n235), .Y(n232) );
  CLKINVX1 U338 ( .A(a9[3]), .Y(n235) );
  CLKINVX1 U339 ( .A(b2[1]), .Y(n332) );
  OAI21X1 U340 ( .A0(n186), .A1(n408), .B0(n409), .Y(n104) );
  INVX1 U341 ( .A(a8[0]), .Y(n408) );
  NAND2X1 U342 ( .A(a9[0]), .B(n189), .Y(n409) );
  NOR2X1 U343 ( .A(n269), .B(n368), .Y(n365) );
  CLKINVX1 U344 ( .A(b0[4]), .Y(n368) );
  CLKINVX1 U345 ( .A(b3[1]), .Y(n335) );
  NAND2X1 U346 ( .A(a3[6]), .B(n128), .Y(n386) );
  CLKINVX1 U347 ( .A(n15), .Y(n388) );
  OAI21X1 U348 ( .A0(n269), .A1(n403), .B0(n404), .Y(n15) );
  NAND2X1 U349 ( .A(b1[7]), .B(n260), .Y(n404) );
  CLKINVX1 U350 ( .A(b0[7]), .Y(n403) );
  CLKINVX1 U351 ( .A(b5[7]), .Y(n400) );
  OAI21X1 U352 ( .A0(n209), .A1(n370), .B0(n371), .Y(n53) );
  NAND2X1 U353 ( .A(b3[4]), .B(n168), .Y(n371) );
  CLKINVX1 U354 ( .A(b2[4]), .Y(n370) );
  OAI21X1 U355 ( .A0(n186), .A1(n323), .B0(n324), .Y(n78) );
  NAND2X1 U356 ( .A(a9[1]), .B(n189), .Y(n324) );
  INVX1 U357 ( .A(a8[1]), .Y(n323) );
  NAND4BX1 U358 ( .AN(n319), .B(n320), .C(n321), .D(n322), .Y(n72) );
  CLKINVX1 U359 ( .A(n77), .Y(n320) );
  CLKINVX1 U360 ( .A(n78), .Y(n322) );
  NOR2X1 U361 ( .A(n211), .B(n335), .Y(n319) );
  NAND2X1 U362 ( .A(a3[0]), .B(n128), .Y(n288) );
  INVX1 U363 ( .A(n293), .Y(n82) );
  INVX1 U364 ( .A(n81), .Y(n282) );
  INVX1 U365 ( .A(n283), .Y(n83) );
  NOR2X1 U366 ( .A(n291), .B(n292), .Y(n290) );
  CLKINVX1 U367 ( .A(a0[0]), .Y(n292) );
  CLKINVX1 U368 ( .A(a0[1]), .Y(n318) );
  NOR2X1 U369 ( .A(n328), .B(n367), .Y(n366) );
  INVX1 U370 ( .A(b0[1]), .Y(n333) );
  NAND2X1 U371 ( .A(b1[1]), .B(n260), .Y(n334) );
  NOR2X1 U372 ( .A(n137), .B(n138), .Y(n372) );
  CLKINVX1 U373 ( .A(n159), .Y(n382) );
  NOR3X2 U374 ( .A(n144), .B(n145), .C(n146), .Y(n142) );
  AOI21X1 U375 ( .A0(a6[5]), .A1(n172), .B0(n193), .Y(n192) );
  NOR2X1 U376 ( .A(n161), .B(n162), .Y(n157) );
  NOR4X1 U377 ( .A(n218), .B(n219), .C(n220), .D(n221), .Y(n217) );
  NAND2X1 U378 ( .A(a0[4]), .B(n349), .Y(n351) );
  NAND2X1 U379 ( .A(a1[5]), .B(n289), .Y(n379) );
  NAND2X1 U380 ( .A(a0[5]), .B(n349), .Y(n378) );
  CLKINVX1 U381 ( .A(n336), .Y(n65) );
  NAND2X1 U382 ( .A(n337), .B(n338), .Y(n336) );
  CLKINVX1 U383 ( .A(n66), .Y(n338) );
  AOI21X1 U384 ( .A0(a1[2]), .A1(n289), .B0(n341), .Y(n337) );
  NOR3X2 U385 ( .A(n252), .B(n253), .C(n254), .Y(n251) );
  AOI21X1 U386 ( .A0(a6[3]), .A1(n172), .B0(n229), .Y(n228) );
  NOR3X1 U387 ( .A(n391), .B(n392), .C(n393), .Y(n390) );
  NOR2X1 U388 ( .A(n330), .B(n395), .Y(n392) );
  NOR2X1 U389 ( .A(n186), .B(n396), .Y(n391) );
  NOR2X1 U390 ( .A(n199), .B(n394), .Y(n393) );
  NOR3X1 U391 ( .A(n397), .B(n398), .C(n399), .Y(n389) );
  NOR2X1 U392 ( .A(n209), .B(n401), .Y(n398) );
  NOR2X1 U393 ( .A(n328), .B(n400), .Y(n399) );
  NOR2X1 U394 ( .A(n211), .B(n402), .Y(n397) );
  OAI21X1 U395 ( .A0(n286), .A1(n385), .B0(n386), .Y(n30) );
  NAND3X1 U396 ( .A(n344), .B(n345), .C(n346), .Y(n343) );
  NAND2X1 U397 ( .A(a0[3]), .B(n349), .Y(n344) );
  INVX1 U398 ( .A(n84), .Y(n285) );
  AOI21X1 U399 ( .A0(a1[0]), .A1(n289), .B0(n290), .Y(n284) );
  OAI21X1 U400 ( .A0(n286), .A1(n287), .B0(n288), .Y(n84) );
  NOR3X2 U401 ( .A(n325), .B(n326), .C(n327), .Y(n321) );
  NOR2X1 U402 ( .A(n330), .B(n331), .Y(n326) );
  NOR2X1 U403 ( .A(n328), .B(n329), .Y(n327) );
  NOR4X1 U404 ( .A(n274), .B(n275), .C(n276), .D(n277), .Y(n273) );
  NOR2X1 U405 ( .A(n105), .B(n310), .Y(n301) );
  AOI21X1 U406 ( .A0(a1[1]), .A1(n289), .B0(n317), .Y(n313) );
  NOR2X1 U407 ( .A(n291), .B(n318), .Y(n317) );
  AOI21X1 U408 ( .A0(a5[0]), .A1(n166), .B0(n298), .Y(n294) );
  INVX1 U409 ( .A(n93), .Y(n295) );
  NAND2X1 U410 ( .A(a2[7]), .B(n376), .Y(n374) );
  NAND2X1 U411 ( .A(a3[7]), .B(n128), .Y(n375) );
  NAND2X1 U412 ( .A(a7[6]), .B(n173), .Y(n170) );
  NAND2X1 U413 ( .A(a4[6]), .B(n174), .Y(n169) );
  CLKINVX1 U414 ( .A(a7[7]), .Y(n155) );
  INVX1 U415 ( .A(a2[5]), .Y(n380) );
  INVX1 U416 ( .A(a2[4]), .Y(n353) );
  INVX1 U417 ( .A(a2[3]), .Y(n347) );
  NAND2X1 U418 ( .A(a3[3]), .B(n128), .Y(n348) );
  CLKINVX1 U419 ( .A(a2[2]), .Y(n339) );
  NAND2X1 U420 ( .A(a3[2]), .B(n128), .Y(n340) );
  NAND2X1 U421 ( .A(a7[0]), .B(n173), .Y(n297) );
  NAND2X1 U422 ( .A(b4[2]), .B(n185), .Y(n266) );
  NAND2X1 U423 ( .A(b5[2]), .B(n184), .Y(n268) );
  NAND2X1 U424 ( .A(b4[6]), .B(n185), .Y(n180) );
  NAND2X1 U425 ( .A(b4[5]), .B(n185), .Y(n202) );
  NAND2X1 U426 ( .A(b5[5]), .B(n184), .Y(n201) );
  NAND2X1 U427 ( .A(b4[0]), .B(n185), .Y(n405) );
  NAND2X1 U428 ( .A(b5[0]), .B(n184), .Y(n406) );
  NAND2X1 U429 ( .A(b4[3]), .B(n185), .Y(n237) );
  NAND2X1 U430 ( .A(b0[3]), .B(n183), .Y(n238) );
  CLKINVX1 U431 ( .A(a2[1]), .Y(n315) );
  NAND2X1 U432 ( .A(a3[1]), .B(n128), .Y(n316) );
  CLKINVX1 U433 ( .A(a7[4]), .Y(n222) );
  NOR2X1 U434 ( .A(n154), .B(n278), .Y(n277) );
  CLKINVX1 U435 ( .A(a7[1]), .Y(n278) );
  NOR2X1 U436 ( .A(n269), .B(n309), .Y(n304) );
  INVX1 U437 ( .A(b0[0]), .Y(n309) );
  NOR2X1 U438 ( .A(n330), .B(n362), .Y(n359) );
  CLKINVX1 U439 ( .A(b4[4]), .Y(n362) );
  NOR2X1 U440 ( .A(n154), .B(n194), .Y(n193) );
  CLKINVX1 U441 ( .A(a7[5]), .Y(n194) );
  NOR2X1 U442 ( .A(n154), .B(n230), .Y(n229) );
  CLKINVX1 U443 ( .A(a7[3]), .Y(n230) );
  NAND2X1 U444 ( .A(a7[2]), .B(n173), .Y(n271) );
  INVX1 U445 ( .A(a2[6]), .Y(n385) );
  CLKINVX1 U446 ( .A(a2[0]), .Y(n287) );
  CLKINVX1 U447 ( .A(b4[7]), .Y(n395) );
  CLKINVX1 U448 ( .A(b4[1]), .Y(n331) );
  INVX1 U449 ( .A(b5[4]), .Y(n367) );
  NAND2X1 U450 ( .A(b5[6]), .B(n184), .Y(n181) );
  NAND2X1 U451 ( .A(b0[2]), .B(n183), .Y(n267) );
  AOI22X4 U452 ( .A0(n136), .A1(n137), .B0(n136), .B1(n138), .Y(qq[7]) );
  NOR3X6 U453 ( .A(n372), .B(n7), .C(n373), .Y(n4) );
  NOR2X8 U454 ( .A(n382), .B(n160), .Y(n29) );
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

  CLKINVX1 U1 ( .A(n3), .Y(out_ram[2]) );
  INVX1 U2 ( .A(n1), .Y(out_ram[1]) );
  INVX1 U3 ( .A(n5), .Y(out_ram[3]) );
  INVX1 U4 ( .A(in_acc[5]), .Y(n23) );
  INVX1 U5 ( .A(in_acc[4]), .Y(n21) );
  INVX1 U6 ( .A(in_acc[6]), .Y(n25) );
  INVX1 U7 ( .A(n13), .Y(out_ram[7]) );
  INVX1 U8 ( .A(n9), .Y(out_ram[5]) );
  INVX1 U9 ( .A(in_acc[3]), .Y(n5) );
  INVX1 U10 ( .A(in_acc[2]), .Y(n3) );
  INVX1 U11 ( .A(in_ram[7]), .Y(n13) );
  INVX1 U12 ( .A(in_ram[5]), .Y(n9) );
  CLKINVX1 U13 ( .A(n27), .Y(out_acc[7]) );
  CLKINVX1 U14 ( .A(in_acc[7]), .Y(n27) );
  CLKINVX1 U15 ( .A(n25), .Y(out_acc[6]) );
  CLKINVX1 U16 ( .A(n23), .Y(out_acc[5]) );
  CLKINVX1 U17 ( .A(n21), .Y(out_acc[4]) );
  CLKINVX1 U18 ( .A(n19), .Y(out_acc[3]) );
  CLKINVX1 U19 ( .A(in_ram[3]), .Y(n19) );
  CLKINVX1 U20 ( .A(n17), .Y(out_acc[2]) );
  CLKINVX1 U21 ( .A(in_ram[2]), .Y(n17) );
  CLKINVX1 U22 ( .A(n15), .Y(out_acc[1]) );
  CLKINVX1 U23 ( .A(in_ram[1]), .Y(n15) );
  CLKINVX1 U24 ( .A(n11), .Y(out_ram[6]) );
  INVX1 U25 ( .A(in_ram[6]), .Y(n11) );
  CLKINVX1 U26 ( .A(n7), .Y(out_ram[4]) );
  INVX1 U27 ( .A(in_ram[4]), .Y(n7) );
  INVX1 U28 ( .A(in_acc[1]), .Y(n1) );
endmodule


module adc ( dataa, datab, cin, ac, cout, overflow, result );
  input [7:0] dataa;
  input [7:0] datab;
  output [7:0] result;
  input cin;
  output ac, cout, overflow;
  wire   n55, n56, n57, n59, n60;

  INVX1 U24 ( .A(result[7]), .Y(n55) );
  INVX1 U25 ( .A(datab[7]), .Y(n59) );
  OAI33X1 U26 ( .A0(n55), .A1(n56), .A2(n57), .B0(result[7]), .B1(n59), .B2(
        n60), .Y(overflow) );
  CLKINVX1 U27 ( .A(n60), .Y(n56) );
  INVX1 U28 ( .A(dataa[7]), .Y(n60) );
  CLKINVX1 U29 ( .A(n59), .Y(n57) );
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
         n77, n78, n79, n80, n81;

  CLKAND2X3 U5 ( .A(n74), .B(n71), .Y(n50) );
  NAND2X1 U6 ( .A(n70), .B(n71), .Y(n63) );
  CLKINVX8 U7 ( .A(CI), .Y(n59) );
  OR2X1 U8 ( .A(B[2]), .B(A[2]), .Y(n62) );
  XOR2X4 U9 ( .A(n60), .B(n49), .Y(SUM[3]) );
  CLKAND2X4 U10 ( .A(n56), .B(n53), .Y(n49) );
  INVX1 U11 ( .A(n63), .Y(n69) );
  INVX1 U12 ( .A(n74), .Y(n81) );
  NAND2X1 U13 ( .A(n63), .B(n64), .Y(n61) );
  INVX1 U14 ( .A(n53), .Y(n52) );
  OR2X1 U15 ( .A(B[3]), .B(A[3]), .Y(n53) );
  NAND2X1 U16 ( .A(B[3]), .B(A[3]), .Y(n56) );
  XNOR2X1 U17 ( .A(n80), .B(n59), .Y(SUM[0]) );
  NOR2X1 U18 ( .A(n81), .B(n79), .Y(n80) );
  NAND2X2 U19 ( .A(n61), .B(n62), .Y(n57) );
  NAND2X2 U20 ( .A(n50), .B(n62), .Y(n58) );
  NAND2X1 U21 ( .A(n72), .B(n73), .Y(n70) );
  INVX1 U22 ( .A(n73), .Y(n79) );
  INVX1 U23 ( .A(n62), .Y(n67) );
  INVX1 U24 ( .A(n71), .Y(n77) );
  NOR2X1 U25 ( .A(n58), .B(n59), .Y(n54) );
  NOR2X1 U26 ( .A(n51), .B(n52), .Y(SUM[4]) );
  NOR2X1 U27 ( .A(n54), .B(n55), .Y(n51) );
  NAND2X1 U28 ( .A(n56), .B(n57), .Y(n55) );
  XNOR2X1 U29 ( .A(n75), .B(n76), .Y(SUM[1]) );
  NOR2X1 U30 ( .A(n77), .B(n78), .Y(n76) );
  AOI21X1 U31 ( .A0(CI), .A1(n74), .B0(n79), .Y(n75) );
  INVX1 U32 ( .A(n72), .Y(n78) );
  XNOR2X1 U33 ( .A(n65), .B(n66), .Y(SUM[2]) );
  NOR2X1 U34 ( .A(n67), .B(n68), .Y(n66) );
  AOI21X1 U35 ( .A0(CI), .A1(n50), .B0(n69), .Y(n65) );
  INVX1 U36 ( .A(n64), .Y(n68) );
  OR2X1 U37 ( .A(B[1]), .B(A[1]), .Y(n71) );
  OR2X1 U38 ( .A(B[0]), .B(A[0]), .Y(n74) );
  NAND2X1 U39 ( .A(B[1]), .B(A[1]), .Y(n72) );
  NAND2X1 U40 ( .A(B[2]), .B(A[2]), .Y(n64) );
  NAND2X1 U41 ( .A(B[0]), .B(A[0]), .Y(n73) );
  OAI21X4 U42 ( .A0(n58), .A1(n59), .B0(n57), .Y(n60) );
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

  NAND2BX2 U5 ( .AN(n75), .B(n76), .Y(n72) );
  OAI21X1 U6 ( .A0(n63), .A1(n77), .B0(n61), .Y(n76) );
  INVX1 U7 ( .A(n78), .Y(n63) );
  NAND2X4 U8 ( .A(n54), .B(n55), .Y(n53) );
  NOR2X1 U9 ( .A(n65), .B(n66), .Y(n64) );
  AND2X1 U10 ( .A(n50), .B(n56), .Y(n55) );
  OR2X1 U11 ( .A(n51), .B(n57), .Y(n50) );
  OR2X1 U12 ( .A(B[1]), .B(A[1]), .Y(n61) );
  AO21X4 U13 ( .A0(n72), .A1(n57), .B0(n60), .Y(n49) );
  XOR2X1 U14 ( .A(n49), .B(n70), .Y(SUM[3]) );
  INVX1 U15 ( .A(B[3]), .Y(n66) );
  NAND2X1 U16 ( .A(n66), .B(n65), .Y(n56) );
  NAND2X1 U17 ( .A(n57), .B(n68), .Y(n73) );
  INVX1 U18 ( .A(n68), .Y(n60) );
  NOR2X1 U19 ( .A(n71), .B(n51), .Y(n70) );
  INVX1 U20 ( .A(n56), .Y(n71) );
  NAND2X1 U21 ( .A(B[1]), .B(A[1]), .Y(n69) );
  NAND2X1 U22 ( .A(B[2]), .B(A[2]), .Y(n68) );
  OR2X1 U23 ( .A(B[2]), .B(A[2]), .Y(n57) );
  NAND3X1 U24 ( .A(n67), .B(n68), .C(n69), .Y(n62) );
  INVX1 U25 ( .A(A[3]), .Y(n65) );
  INVX1 U26 ( .A(n67), .Y(n77) );
  AND2X1 U27 ( .A(B[3]), .B(A[3]), .Y(n51) );
  OAI21X1 U28 ( .A0(n72), .A1(n73), .B0(n74), .Y(SUM[2]) );
  NAND2X1 U29 ( .A(n72), .B(n73), .Y(n74) );
  NAND2X1 U30 ( .A(n58), .B(n59), .Y(n54) );
  NAND2X1 U31 ( .A(B[3]), .B(A[3]), .Y(n59) );
  NOR2X1 U32 ( .A(n60), .B(n61), .Y(n58) );
  NOR3X4 U33 ( .A(n62), .B(n63), .C(n64), .Y(n52) );
  NAND2X1 U34 ( .A(B[0]), .B(A[0]), .Y(n67) );
  INVX1 U35 ( .A(n69), .Y(n75) );
  NOR2X1 U36 ( .A(A[0]), .B(B[0]), .Y(n84) );
  NOR2X1 U37 ( .A(A[0]), .B(B[0]), .Y(n81) );
  XNOR2X1 U38 ( .A(n83), .B(n82), .Y(SUM[0]) );
  NOR2X1 U39 ( .A(n77), .B(n84), .Y(n83) );
  XNOR2X1 U40 ( .A(n79), .B(n80), .Y(SUM[1]) );
  NAND2X1 U41 ( .A(n69), .B(n61), .Y(n79) );
  OAI21X1 U42 ( .A0(n81), .A1(n82), .B0(n67), .Y(n80) );
  OAI21X1 U43 ( .A0(A[0]), .A1(B[0]), .B0(CI), .Y(n78) );
  INVX1 U44 ( .A(CI), .Y(n82) );
  NOR2X8 U45 ( .A(n52), .B(n53), .Y(SUM[4]) );
endmodule


module sel_al ( isel, osel );
  input [4:0] isel;
  output [3:0] osel;
  wire   n47, n48, n49, n50, n51, n52, n53, n54, n55, n56;

  AND2X4 U53 ( .A(n51), .B(n52), .Y(n47) );
  NOR2BX2 U54 ( .AN(n52), .B(isel[4]), .Y(n48) );
  NOR2X1 U55 ( .A(n49), .B(n48), .Y(osel[3]) );
  NOR2X2 U56 ( .A(n48), .B(n50), .Y(osel[2]) );
  INVX3 U57 ( .A(isel[3]), .Y(n52) );
  NOR2X1 U58 ( .A(isel[4]), .B(n51), .Y(n50) );
  NOR2X1 U59 ( .A(isel[4]), .B(isel[2]), .Y(n49) );
  INVX1 U60 ( .A(isel[2]), .Y(n51) );
  NOR2X1 U61 ( .A(isel[4]), .B(isel[1]), .Y(n54) );
  NAND2X1 U62 ( .A(isel[1]), .B(isel[4]), .Y(n53) );
  NOR2X1 U63 ( .A(isel[4]), .B(isel[0]), .Y(n56) );
  NAND2X1 U64 ( .A(isel[0]), .B(isel[4]), .Y(n55) );
  AOI21X4 U65 ( .A0(n53), .A1(n47), .B0(n54), .Y(osel[1]) );
  AOI21X4 U66 ( .A0(n47), .A1(n55), .B0(n56), .Y(osel[0]) );
endmodule


module sel_arth ( iop2, icin, sel, oop2, ocin );
  input [7:0] iop2;
  input [2:0] sel;
  output [7:0] oop2;
  input icin;
  output ocin;
  wire   n12, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39, n40;

  INVX3 U29 ( .A(sel[2]), .Y(n39) );
  INVX3 U30 ( .A(sel[1]), .Y(n36) );
  INVX1 U31 ( .A(iop2[2]), .Y(n29) );
  NAND2X1 U32 ( .A(n32), .B(n33), .Y(oop2[0]) );
  NAND2X1 U33 ( .A(n26), .B(n40), .Y(oop2[6]) );
  CLKINVX4 U34 ( .A(sel[0]), .Y(n37) );
  BUFX8 U35 ( .A(n24), .Y(n40) );
  NAND3X2 U36 ( .A(n37), .B(sel[2]), .C(n36), .Y(n24) );
  NAND2BX4 U37 ( .AN(n23), .B(n24), .Y(oop2[7]) );
  NAND3X2 U38 ( .A(n37), .B(n39), .C(sel[1]), .Y(n31) );
  AND2X4 U39 ( .A(n39), .B(n36), .Y(n19) );
  NAND2BX2 U40 ( .AN(n20), .B(n40), .Y(oop2[3]) );
  NAND2X1 U41 ( .A(n28), .B(n40), .Y(oop2[2]) );
  OAI21X1 U42 ( .A0(n19), .A1(n29), .B0(n30), .Y(n28) );
  NAND2X1 U43 ( .A(n29), .B(n31), .Y(n30) );
  NAND2X1 U44 ( .A(n27), .B(n40), .Y(oop2[4]) );
  NAND2BX2 U45 ( .AN(n22), .B(n40), .Y(oop2[1]) );
  NOR2X1 U46 ( .A(n34), .B(n35), .Y(n32) );
  NOR3X1 U47 ( .A(n36), .B(sel[2]), .C(n37), .Y(n35) );
  NAND2BX2 U48 ( .AN(n21), .B(n40), .Y(oop2[5]) );
  MXI2X1 U49 ( .S0(icin), .B(n38), .A(n31), .Y(ocin) );
  INVX3 U50 ( .A(n31), .Y(n25) );
  CLKINVX1 U51 ( .A(n40), .Y(n34) );
  MX2X1 U52 ( .S0(iop2[3]), .B(n19), .A(n25), .Y(n20) );
  MXI2X1 U53 ( .S0(iop2[0]), .B(n19), .A(n25), .Y(n33) );
  MX2X1 U54 ( .S0(iop2[5]), .B(n19), .A(n25), .Y(n21) );
  MX2X1 U55 ( .S0(iop2[1]), .B(n19), .A(n25), .Y(n22) );
  MX2X1 U56 ( .S0(iop2[7]), .B(n19), .A(n25), .Y(n23) );
  NAND2X1 U57 ( .A(sel[0]), .B(n19), .Y(n38) );
  MXI2X1 U58 ( .S0(iop2[4]), .B(n19), .A(n25), .Y(n27) );
  MXI2X1 U59 ( .S0(iop2[6]), .B(n19), .A(n25), .Y(n26) );
  INVX16 U60 ( .A(iop2[0]), .Y(n12) );
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
         ab23, ab24, ab25, ab26, ab27, ab28, ab29, ab30, ab31, ab32, ab33,
         ab34, ab35, ab36, ab37, ab38, ab39, ab40, ab41, ab42, ab43, ab44,
         ab45, ab46, ab47, ab48, ab49, ab50, ab51, ab52, ab53, ab54, ab55,
         ab56, ab57, ab58, ab59, ab60, SUMB, SUMB0, SUMB1, SUMB2, SUMB3, SUMB4,
         SUMB5, SUMB6, SUMB7, SUMB8, SUMB9, SUMB10, SUMB11, SUMB12, SUMB13,
         SUMB14, SUMB15, SUMB16, SUMB17, SUMB18, SUMB19, SUMB20, SUMB21,
         SUMB22, SUMB23, SUMB24, SUMB25, SUMB26, SUMB27, SUMB28, SUMB29,
         SUMB30, SUMB31, SUMB32, SUMB33, SUMB34, SUMB35, SUMB36, SUMB37,
         SUMB38, SUMB39, SUMB40, SUMB41, SUMB42, CARRYB, CARRYB0, CARRYB1,
         CARRYB2, CARRYB3, CARRYB4, CARRYB5, CARRYB6, CARRYB7, CARRYB8,
         CARRYB9, CARRYB10, CARRYB11, CARRYB12, CARRYB13, CARRYB14, CARRYB15,
         CARRYB16, CARRYB17, CARRYB18, CARRYB19, CARRYB20, CARRYB21, CARRYB22,
         CARRYB23, CARRYB24, CARRYB25, CARRYB26, CARRYB27, CARRYB28, CARRYB29,
         CARRYB30, CARRYB31, CARRYB32, CARRYB33, CARRYB34, CARRYB35, CARRYB36,
         CARRYB37, CARRYB38, CARRYB39, CARRYB40, CARRYB41, CARRYB42, CARRYB43,
         CARRYB44, CARRYB45, CARRYB46, CARRYB47, PROD1_6_, PROD1_5_, PROD1_4_,
         PROD1_3_, PROD1_2_, CLA_SUM_14_, CLA_SUM_13_, CLA_SUM_12_,
         CLA_SUM_11_, CLA_SUM_10_, CLA_SUM_9_, CLA_SUM_8_, CLA_CARRY_14_,
         CLA_CARRY_13_, CLA_CARRY_12_, CLA_CARRY_11_, CLA_CARRY_10_,
         CLA_CARRY_9_, CLA_CARRY_8_, n17, n18, n19, n20, n21, n22, n23, n24,
         n25, n26, n27, n28, n29, n30, n31, n32;

  AND2X1 U5 ( .A(ab48), .B(ab55), .Y(CARRYB42) );
  XOR2X1 U6 ( .A(ab48), .B(ab55), .Y(SUMB38) );
  AND2X1 U7 ( .A(ab49), .B(ab56), .Y(CARRYB43) );
  XOR2X1 U8 ( .A(ab49), .B(ab56), .Y(SUMB39) );
  AND2X1 U9 ( .A(ab57), .B(ab50), .Y(CARRYB44) );
  XOR2X1 U10 ( .A(ab57), .B(ab50), .Y(SUMB40) );
  AND2X1 U11 ( .A(ab51), .B(ab58), .Y(CARRYB45) );
  XOR2X1 U12 ( .A(ab51), .B(ab58), .Y(SUMB41) );
  AND2X1 U13 ( .A(ab52), .B(ab59), .Y(CARRYB46) );
  XOR2X1 U14 ( .A(ab52), .B(ab59), .Y(SUMB42) );
  AND2X1 U15 ( .A(ab53), .B(ab60), .Y(CARRYB47) );
  XOR2X1 U16 ( .A(ab53), .B(ab60), .Y(PRODUCT[1]) );
  NOR2X1 U17 ( .A(n19), .B(n32), .Y(ab55) );
  NOR2X1 U18 ( .A(n24), .B(n29), .Y(ab36) );
  NOR2X1 U19 ( .A(n21), .B(n29), .Y(ab33) );
  NOR2X1 U20 ( .A(n24), .B(n30), .Y(ab44) );
  INVX4 U21 ( .A(B[1]), .Y(n24) );
  INVX8 U22 ( .A(B[5]), .Y(n20) );
  INVX6 U23 ( .A(B[0]), .Y(n25) );
  INVX4 U24 ( .A(B[3]), .Y(n22) );
  INVX6 U25 ( .A(B[4]), .Y(n21) );
  INVX4 U26 ( .A(A[5]), .Y(n27) );
  INVX3 U27 ( .A(B[7]), .Y(n18) );
  NOR2X1 U28 ( .A(n25), .B(n30), .Y(ab45) );
  INVX6 U29 ( .A(B[2]), .Y(n23) );
  INVX6 U30 ( .A(A[1]), .Y(n31) );
  CLKINVX6 U31 ( .A(B[6]), .Y(n19) );
  NOR2X4 U32 ( .A(n21), .B(n31), .Y(ab49) );
  NOR2X1 U33 ( .A(n19), .B(n31), .Y(ab47) );
  NOR2X2 U34 ( .A(n25), .B(n31), .Y(ab53) );
  NOR2X2 U35 ( .A(n23), .B(n31), .Y(ab51) );
  CLKINVX3 U36 ( .A(A[7]), .Y(n17) );
  ADDFHX1 S2_6_1 ( .A(ab12), .B(CARRYB18), .CI(SUMB17), .S(SUMB12), .CO(
        CARRYB11) );
  INVX6 U37 ( .A(A[6]), .Y(n26) );
  ADDFHX1 S2_2_3 ( .A(ab42), .B(CARRYB44), .CI(SUMB39), .S(SUMB34), .CO(
        CARRYB37) );
  NOR2X1 U38 ( .A(n24), .B(n31), .Y(ab52) );
  ADDFHX1 S2_3_4 ( .A(ab33), .B(CARRYB36), .CI(SUMB32), .S(SUMB27), .CO(
        CARRYB29) );
  NOR2X1 U39 ( .A(n21), .B(n32), .Y(ab57) );
  ADDFHX1 S1_5_0 ( .A(ab21), .B(CARRYB26), .CI(SUMB24), .S(PROD1_5_), .CO(
        CARRYB19) );
  ADDFHX1 S2_4_3 ( .A(ab26), .B(CARRYB30), .CI(SUMB27), .S(SUMB22), .CO(
        CARRYB23) );
  ADDFHX1 S1_4_0 ( .A(ab29), .B(CARRYB33), .CI(SUMB30), .S(PROD1_4_), .CO(
        CARRYB26) );
  NOR2X1 U40 ( .A(n25), .B(n28), .Y(ab29) );
  NOR2X1 U41 ( .A(n17), .B(n25), .Y(ab5) );
  ADDFHX1 S2_4_1 ( .A(ab28), .B(CARRYB32), .CI(SUMB29), .S(SUMB24), .CO(
        CARRYB25) );
  NOR2X1 U42 ( .A(n18), .B(n32), .Y(ab54) );
  INVX8 U43 ( .A(A[4]), .Y(n28) );
  NOR2X1 U44 ( .A(n21), .B(n28), .Y(ab25) );
  ADDFX1 S2_6_3 ( .A(ab10), .B(CARRYB16), .CI(SUMB15), .S(SUMB10), .CO(CARRYB9) );
  ADDFX1 S4_1 ( .A(ab4), .B(CARRYB11), .CI(SUMB11), .S(SUMB5), .CO(CARRYB4) );
  ADDFX1 S4_3 ( .A(ab2), .B(CARRYB9), .CI(SUMB9), .S(SUMB3), .CO(CARRYB2) );
  ADDFHX1 S1_3_0 ( .A(ab37), .B(CARRYB40), .CI(SUMB36), .S(PROD1_3_), .CO(
        CARRYB33) );
  NOR2X1 U45 ( .A(n25), .B(n29), .Y(ab37) );
  ADDFHX1 S2_3_1 ( .A(ab36), .B(CARRYB39), .CI(SUMB35), .S(SUMB30), .CO(
        CARRYB32) );
  INVX8 U46 ( .A(A[0]), .Y(n32) );
  ADDFHX1 S2_3_2 ( .A(ab35), .B(CARRYB38), .CI(SUMB34), .S(SUMB29), .CO(
        CARRYB31) );
  NOR2X1 U47 ( .A(n23), .B(n29), .Y(ab35) );
  ADDFHX1 S2_3_3 ( .A(ab34), .B(CARRYB37), .CI(SUMB33), .S(SUMB28), .CO(
        CARRYB30) );
  ADDFHX1 S2_3_5 ( .A(ab32), .B(CARRYB35), .CI(SUMB31), .S(SUMB26), .CO(
        CARRYB28) );
  NOR2X1 U48 ( .A(n20), .B(n29), .Y(ab32) );
  ADDFHX1 S2_2_1 ( .A(ab44), .B(CARRYB46), .CI(SUMB41), .S(SUMB36), .CO(
        CARRYB39) );
  ADDFHX1 S2_2_2 ( .A(ab43), .B(CARRYB45), .CI(SUMB40), .S(SUMB35), .CO(
        CARRYB38) );
  ADDFHX1 S1_2_0 ( .A(ab45), .B(CARRYB47), .CI(SUMB42), .S(PROD1_2_), .CO(
        CARRYB40) );
  NOR2X1 U49 ( .A(n20), .B(n30), .Y(ab40) );
  ADDFHX1 S2_2_4 ( .A(ab41), .B(CARRYB43), .CI(SUMB38), .S(SUMB33), .CO(
        CARRYB36) );
  NOR2X1 U50 ( .A(n21), .B(n30), .Y(ab41) );
  NOR2X1 U51 ( .A(n22), .B(n32), .Y(ab58) );
  NOR2X1 U52 ( .A(n24), .B(n32), .Y(ab60) );
  NOR2X2 U53 ( .A(n23), .B(n32), .Y(ab59) );
  NOR2X1 U54 ( .A(n20), .B(n31), .Y(ab48) );
  NOR2X1 U55 ( .A(n22), .B(n31), .Y(ab50) );
  ADDFHX2 S4_0 ( .A(ab5), .B(CARRYB12), .CI(SUMB12), .S(SUMB6), .CO(CARRYB5)
         );
  NOR2X1 U56 ( .A(n25), .B(n27), .Y(ab21) );
  ADDFHX2 S1_6_0 ( .A(ab13), .B(CARRYB19), .CI(SUMB18), .S(PROD1_6_), .CO(
        CARRYB12) );
  NOR2X1 U57 ( .A(n25), .B(n26), .Y(ab13) );
  ADDFHX1 S2_5_1 ( .A(ab20), .B(CARRYB25), .CI(SUMB23), .S(SUMB18), .CO(
        CARRYB18) );
  NOR2X1 U58 ( .A(n24), .B(n27), .Y(ab20) );
  NOR2X1 U59 ( .A(n24), .B(n28), .Y(ab28) );
  ADDFHX1 S2_4_2 ( .A(ab27), .B(CARRYB31), .CI(SUMB28), .S(SUMB23), .CO(
        CARRYB24) );
  NOR2X1 U60 ( .A(n23), .B(n28), .Y(ab27) );
  NOR2X1 U61 ( .A(n22), .B(n28), .Y(ab26) );
  ADDFX2 S2_5_2 ( .A(ab19), .B(CARRYB24), .CI(SUMB22), .S(SUMB17), .CO(
        CARRYB17) );
  NOR2X1 U62 ( .A(n23), .B(n27), .Y(ab19) );
  NOR2X1 U63 ( .A(n24), .B(n26), .Y(ab12) );
  INVX8 U64 ( .A(A[3]), .Y(n29) );
  INVX8 U65 ( .A(A[2]), .Y(n30) );
  NOR2X1 U66 ( .A(n25), .B(n32), .Y(PRODUCT[0]) );
  NOR2X1 U67 ( .A(n22), .B(n26), .Y(ab10) );
  ADDFX2 S2_4_5 ( .A(ab24), .B(CARRYB28), .CI(SUMB25), .S(SUMB20), .CO(
        CARRYB21) );
  NOR2X1 U68 ( .A(n20), .B(n28), .Y(ab24) );
  ADDFX2 S2_6_5 ( .A(ab8), .B(CARRYB14), .CI(SUMB13), .S(SUMB8), .CO(CARRYB7)
         );
  NOR2X1 U69 ( .A(n20), .B(n26), .Y(ab8) );
  ADDFHX1 S2_5_3 ( .A(ab18), .B(CARRYB23), .CI(SUMB21), .S(SUMB16), .CO(
        CARRYB16) );
  NOR2X1 U70 ( .A(n22), .B(n27), .Y(ab18) );
  ADDFX2 S2_5_5 ( .A(ab16), .B(CARRYB21), .CI(SUMB19), .S(SUMB14), .CO(
        CARRYB14) );
  NOR2X1 U71 ( .A(n20), .B(n27), .Y(ab16) );
  ADDFX2 S2_6_2 ( .A(ab11), .B(CARRYB17), .CI(SUMB16), .S(SUMB11), .CO(
        CARRYB10) );
  NOR2X1 U72 ( .A(n23), .B(n26), .Y(ab11) );
  ADDFX2 S3_2_6 ( .A(ab39), .B(CARRYB41), .CI(ab46), .S(SUMB31), .CO(CARRYB34)
         );
  NOR2X1 U73 ( .A(n18), .B(n31), .Y(ab46) );
  NOR2X1 U74 ( .A(n19), .B(n30), .Y(ab39) );
  ADDFHX1 S3_3_6 ( .A(ab31), .B(CARRYB34), .CI(ab38), .S(SUMB25), .CO(CARRYB27) );
  NOR2X1 U75 ( .A(n18), .B(n30), .Y(ab38) );
  NOR2X1 U76 ( .A(n19), .B(n29), .Y(ab31) );
  ADDFHX1 S3_4_6 ( .A(ab23), .B(CARRYB27), .CI(ab30), .S(SUMB19), .CO(CARRYB20) );
  NOR2X1 U77 ( .A(n18), .B(n29), .Y(ab30) );
  NOR2X1 U78 ( .A(n19), .B(n28), .Y(ab23) );
  ADDFHX1 S3_5_6 ( .A(ab15), .B(CARRYB20), .CI(ab22), .S(SUMB13), .CO(CARRYB13) );
  NOR2X1 U79 ( .A(n18), .B(n28), .Y(ab22) );
  NOR2X1 U80 ( .A(n19), .B(n27), .Y(ab15) );
  ADDFX1 S2_4_4 ( .A(ab25), .B(CARRYB29), .CI(SUMB26), .S(SUMB21), .CO(
        CARRYB22) );
  ADDFX1 S2_5_4 ( .A(ab17), .B(CARRYB22), .CI(SUMB20), .S(SUMB15), .CO(
        CARRYB15) );
  NOR2X1 U81 ( .A(n21), .B(n27), .Y(ab17) );
  ADDFX2 S2_6_4 ( .A(ab9), .B(CARRYB15), .CI(SUMB14), .S(SUMB9), .CO(CARRYB8)
         );
  NOR2X1 U82 ( .A(n21), .B(n26), .Y(ab9) );
  NOR2X1 U83 ( .A(n17), .B(n24), .Y(ab4) );
  ADDFHX1 S4_2 ( .A(ab3), .B(CARRYB10), .CI(SUMB10), .S(SUMB4), .CO(CARRYB3)
         );
  NOR2X1 U84 ( .A(n17), .B(n23), .Y(ab3) );
  ADDFX1 S4_4 ( .A(ab1), .B(CARRYB8), .CI(SUMB8), .S(SUMB2), .CO(CARRYB1) );
  NOR2X1 U85 ( .A(n17), .B(n21), .Y(ab1) );
  NOR2X1 U86 ( .A(n17), .B(n22), .Y(ab2) );
  ADDFX2 S3_6_6 ( .A(ab7), .B(CARRYB13), .CI(ab14), .S(SUMB7), .CO(CARRYB6) );
  NOR2X1 U87 ( .A(n18), .B(n27), .Y(ab14) );
  NOR2X1 U88 ( .A(n19), .B(n26), .Y(ab7) );
  ADDFHX1 S5_6 ( .A(ab), .B(CARRYB6), .CI(ab6), .S(SUMB0), .CO(CARRYB) );
  NOR2X1 U89 ( .A(n18), .B(n26), .Y(ab6) );
  NOR2X1 U90 ( .A(n17), .B(n19), .Y(ab) );
  ADDFX1 S4_5 ( .A(ab0), .B(CARRYB7), .CI(SUMB7), .S(SUMB1), .CO(CARRYB0) );
  NOR2X1 U91 ( .A(n17), .B(n20), .Y(ab0) );
  NOR2X1 U92 ( .A(n17), .B(n18), .Y(SUMB) );
  NOR2X1 U93 ( .A(n22), .B(n29), .Y(ab34) );
  NOR2X1 U94 ( .A(n22), .B(n30), .Y(ab42) );
  ADDFHX1 S2_2_5 ( .A(ab40), .B(CARRYB42), .CI(SUMB37), .S(SUMB32), .CO(
        CARRYB35) );
  NOR2X2 U95 ( .A(n23), .B(n30), .Y(ab43) );
  NOR2X4 U96 ( .A(n20), .B(n32), .Y(ab56) );
  AND2X1 U98 ( .A(CARRYB), .B(SUMB), .Y(CLA_CARRY_14_) );
  XOR2X1 U99 ( .A(CARRYB), .B(SUMB), .Y(CLA_SUM_14_) );
  AND2X1 U100 ( .A(CARRYB0), .B(SUMB0), .Y(CLA_CARRY_13_) );
  XOR2X1 U101 ( .A(CARRYB0), .B(SUMB0), .Y(CLA_SUM_13_) );
  AND2X1 U102 ( .A(CARRYB1), .B(SUMB1), .Y(CLA_CARRY_12_) );
  XOR2X1 U103 ( .A(CARRYB1), .B(SUMB1), .Y(CLA_SUM_12_) );
  AND2X1 U104 ( .A(CARRYB2), .B(SUMB2), .Y(CLA_CARRY_11_) );
  XOR2X1 U105 ( .A(CARRYB2), .B(SUMB2), .Y(CLA_SUM_11_) );
  AND2X1 U106 ( .A(CARRYB3), .B(SUMB3), .Y(CLA_CARRY_10_) );
  XOR2X1 U107 ( .A(CARRYB3), .B(SUMB3), .Y(CLA_SUM_10_) );
  AND2X1 U108 ( .A(CARRYB4), .B(SUMB4), .Y(CLA_CARRY_9_) );
  XOR2X1 U109 ( .A(CARRYB4), .B(SUMB4), .Y(CLA_SUM_9_) );
  AND2X1 U110 ( .A(CARRYB5), .B(SUMB5), .Y(CLA_CARRY_8_) );
  XOR2X1 U111 ( .A(CARRYB5), .B(SUMB5), .Y(CLA_SUM_8_) );
  AND2X1 U113 ( .A(ab47), .B(ab54), .Y(CARRYB41) );
  XOR2X1 U114 ( .A(ab47), .B(ab54), .Y(SUMB37) );
  mul_DW01_add_14_0 FS_1 ( .A({1'b0, CLA_SUM_14_, CLA_SUM_13_, CLA_SUM_12_, 
        CLA_SUM_11_, CLA_SUM_10_, CLA_SUM_9_, CLA_SUM_8_, SUMB6, PROD1_6_, 
        PROD1_5_, PROD1_4_, PROD1_3_, PROD1_2_}), .B({CLA_CARRY_14_, 
        CLA_CARRY_13_, CLA_CARRY_12_, CLA_CARRY_11_, CLA_CARRY_10_, 
        CLA_CARRY_9_, CLA_CARRY_8_, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .CI(1'b0), .SUM(PRODUCT[15:2]) );
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
         n146, n147;
  assign SUM[0] = \SUM0[0] ;
  assign \SUM0[0]  = A[0];

  INVX1 U5 ( .A(A[10]), .Y(n117) );
  NOR2X1 U6 ( .A(n91), .B(n92), .Y(SUM[1]) );
  CLKINVX1 U7 ( .A(n115), .Y(n110) );
  INVX1 U8 ( .A(n133), .Y(n76) );
  NAND2X1 U9 ( .A(B[1]), .B(A[1]), .Y(n87) );
  NAND2X1 U10 ( .A(B[3]), .B(A[3]), .Y(n85) );
  INVX1 U11 ( .A(A[3]), .Y(n140) );
  INVX1 U12 ( .A(n138), .Y(n84) );
  INVX1 U13 ( .A(n103), .Y(n105) );
  INVX1 U14 ( .A(n100), .Y(n98) );
  INVX1 U15 ( .A(n112), .Y(n114) );
  XOR2X1 U16 ( .A(n98), .B(n49), .Y(SUM[12]) );
  CLKINVX1 U17 ( .A(n106), .Y(n101) );
  CLKINVX1 U18 ( .A(B[11]), .Y(n107) );
  INVX1 U19 ( .A(n145), .Y(n63) );
  INVX1 U20 ( .A(n119), .Y(n53) );
  INVX1 U21 ( .A(n123), .Y(n58) );
  INVX1 U22 ( .A(n109), .Y(n102) );
  CLKINVX1 U23 ( .A(A[12]), .Y(n96) );
  NAND2X1 U24 ( .A(B[11]), .B(A[11]), .Y(n103) );
  INVX1 U25 ( .A(n54), .Y(n52) );
  INVX1 U26 ( .A(n118), .Y(n111) );
  INVX1 U27 ( .A(n122), .Y(n50) );
  INVX1 U28 ( .A(n126), .Y(n55) );
  OAI21X1 U29 ( .A0(n84), .A1(n81), .B0(n85), .Y(n133) );
  INVX1 U30 ( .A(n129), .Y(n70) );
  OAI21X1 U31 ( .A0(n76), .A1(n79), .B0(n80), .Y(n129) );
  INVX1 U32 ( .A(n141), .Y(n73) );
  NAND2X1 U33 ( .A(n75), .B(n74), .Y(n141) );
  INVX1 U34 ( .A(n134), .Y(n81) );
  OAI21X1 U35 ( .A0(n89), .A1(n87), .B0(n90), .Y(n134) );
  INVX1 U36 ( .A(n127), .Y(n60) );
  NAND2X1 U37 ( .A(B[4]), .B(A[4]), .Y(n80) );
  INVX2 U38 ( .A(n130), .Y(n79) );
  NAND2X1 U39 ( .A(n131), .B(n132), .Y(n130) );
  NAND2X1 U40 ( .A(n139), .B(n140), .Y(n138) );
  NAND2X1 U41 ( .A(B[2]), .B(A[2]), .Y(n90) );
  INVX1 U42 ( .A(n135), .Y(n89) );
  NAND2X1 U43 ( .A(n136), .B(n137), .Y(n135) );
  NAND2X1 U44 ( .A(B[6]), .B(A[6]), .Y(n69) );
  INVX1 U45 ( .A(n128), .Y(n65) );
  INVX1 U46 ( .A(n142), .Y(n68) );
  XNOR2X1 U47 ( .A(n102), .B(n104), .Y(SUM[11]) );
  NOR2X1 U48 ( .A(n105), .B(n101), .Y(n104) );
  OAI21X1 U49 ( .A0(n101), .A1(n102), .B0(n103), .Y(n100) );
  XOR2X1 U50 ( .A(B[12]), .B(n96), .Y(n49) );
  XNOR2X1 U51 ( .A(n111), .B(n113), .Y(SUM[10]) );
  NOR2X1 U52 ( .A(n114), .B(n110), .Y(n113) );
  NAND2X1 U53 ( .A(B[7]), .B(A[7]), .Y(n64) );
  NAND2X1 U54 ( .A(B[8]), .B(A[8]), .Y(n59) );
  NAND2X1 U55 ( .A(B[9]), .B(A[9]), .Y(n54) );
  NOR2X1 U56 ( .A(n98), .B(n99), .Y(n94) );
  NOR2X1 U57 ( .A(A[12]), .B(B[12]), .Y(n99) );
  NAND2X1 U58 ( .A(n146), .B(n147), .Y(n145) );
  INVX1 U59 ( .A(B[7]), .Y(n146) );
  INVX1 U60 ( .A(A[7]), .Y(n147) );
  OAI21X1 U61 ( .A0(n110), .A1(n111), .B0(n112), .Y(n109) );
  NAND2X1 U62 ( .A(n124), .B(n125), .Y(n123) );
  INVX1 U63 ( .A(B[8]), .Y(n124) );
  INVX1 U64 ( .A(A[8]), .Y(n125) );
  NAND2X1 U65 ( .A(n120), .B(n121), .Y(n119) );
  INVX1 U66 ( .A(B[9]), .Y(n120) );
  INVX1 U67 ( .A(A[9]), .Y(n121) );
  NAND2X1 U68 ( .A(B[10]), .B(A[10]), .Y(n112) );
  INVX1 U69 ( .A(B[12]), .Y(n97) );
  NAND2X1 U70 ( .A(n116), .B(n117), .Y(n115) );
  INVX1 U71 ( .A(B[10]), .Y(n116) );
  NAND2X1 U72 ( .A(n107), .B(n108), .Y(n106) );
  INVX1 U73 ( .A(A[11]), .Y(n108) );
  CLKINVX1 U74 ( .A(A[5]), .Y(n74) );
  NOR2X1 U75 ( .A(n94), .B(n95), .Y(n93) );
  NOR2X1 U76 ( .A(n96), .B(n97), .Y(n95) );
  XNOR2X1 U77 ( .A(n50), .B(n51), .Y(SUM[9]) );
  NOR2X1 U78 ( .A(n52), .B(n53), .Y(n51) );
  OAI21X1 U79 ( .A0(n50), .A1(n53), .B0(n54), .Y(n118) );
  OAI21X1 U80 ( .A0(n55), .A1(n58), .B0(n59), .Y(n122) );
  XNOR2X1 U81 ( .A(n55), .B(n56), .Y(SUM[8]) );
  NOR2X1 U82 ( .A(n57), .B(n58), .Y(n56) );
  INVX1 U83 ( .A(n59), .Y(n57) );
  OAI21X1 U84 ( .A0(n63), .A1(n60), .B0(n64), .Y(n126) );
  XNOR2X1 U85 ( .A(n60), .B(n61), .Y(SUM[7]) );
  NOR2X1 U86 ( .A(n62), .B(n63), .Y(n61) );
  INVX1 U87 ( .A(n64), .Y(n62) );
  XNOR2X1 U88 ( .A(n70), .B(n71), .Y(SUM[5]) );
  NOR2X1 U89 ( .A(n72), .B(n73), .Y(n71) );
  NOR2X1 U90 ( .A(n74), .B(n75), .Y(n72) );
  XNOR2X1 U91 ( .A(n86), .B(n87), .Y(SUM[2]) );
  NOR2X1 U92 ( .A(n88), .B(n89), .Y(n86) );
  CLKINVX1 U93 ( .A(n90), .Y(n88) );
  XNOR2X1 U94 ( .A(n76), .B(n77), .Y(SUM[4]) );
  NOR2X1 U95 ( .A(n78), .B(n79), .Y(n77) );
  INVX1 U96 ( .A(n80), .Y(n78) );
  XNOR2X1 U97 ( .A(n81), .B(n82), .Y(SUM[3]) );
  NOR2X1 U98 ( .A(n83), .B(n84), .Y(n82) );
  CLKINVX1 U99 ( .A(n85), .Y(n83) );
  OAI21X1 U100 ( .A0(n68), .A1(n65), .B0(n69), .Y(n127) );
  XNOR2X1 U101 ( .A(n65), .B(n66), .Y(SUM[6]) );
  NOR2X1 U102 ( .A(n67), .B(n68), .Y(n66) );
  INVX1 U103 ( .A(n69), .Y(n67) );
  CLKINVX1 U104 ( .A(B[4]), .Y(n131) );
  INVX1 U105 ( .A(A[4]), .Y(n132) );
  CLKINVX1 U106 ( .A(B[3]), .Y(n139) );
  CLKINVX1 U107 ( .A(B[2]), .Y(n136) );
  INVX1 U108 ( .A(A[2]), .Y(n137) );
  NOR2X1 U109 ( .A(A[1]), .B(B[1]), .Y(n92) );
  INVX1 U110 ( .A(n87), .Y(n91) );
  NAND2X1 U111 ( .A(n143), .B(n144), .Y(n142) );
  CLKINVX1 U112 ( .A(B[6]), .Y(n143) );
  INVX1 U113 ( .A(A[6]), .Y(n144) );
  OAI2BB2X1 U114 ( .A0N(B[5]), .A1N(A[5]), .B0(n73), .B1(n70), .Y(n128) );
  CLKINVX1 U115 ( .A(B[5]), .Y(n75) );
  XNOR2X4 U116 ( .A(n93), .B(B[13]), .Y(SUM[13]) );
endmodule


module div ( clk, rst_p, Load, Dividend, Divisor, Quotient, Remainder );
  input [7:0] Dividend;
  input [7:0] Divisor;
  output [7:0] Quotient;
  output [7:0] Remainder;
  input clk, rst_p, Load;
  wire   N37, N92, N93, N94, N95, N96, N97, N124, N125, N126, N127, N128, N129,
         N130, n6, n7, n8, n9, n10, n11, n12, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n38, n39, n40, n41, n42, n43, n45, n46, n47, n48, n49, n50,
         n51, n52, n53, n54, n55, n57, n58, n59, n60, n61, n63, n66, n72, n73,
         n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87,
         n88, n89, n90, n91, n920, n930, n940, n950, n960, n970, n98, n99,
         n100, n101, n102, n103, n104, n105, n106, n107, n108, n109, n110;
  wire   [5:0] CurrentCount;
  wire   [2:0] CurrentState;
  wire   [7:0] RegB;
  wire   [6:0] RegA_minus_RegB;

  INVX1 U105 ( .A(Load), .Y(n6) );
  CLKINVX1 U106 ( .A(n46), .Y(n12) );
  NAND2BX1 U107 ( .AN(Load), .B(n47), .Y(n46) );
  CLKINVX1 U108 ( .A(N37), .Y(n50) );
  DFFRX1 CurrentState_reg_1_ ( .D(n98), .CK(clk), .RN(n72), .Q(CurrentState[1]), .QN(n106) );
  DFFRX1 RegB_reg_1_ ( .D(n74), .CK(clk), .RN(n72), .Q(RegB[1]) );
  DFFRX1 RegB_reg_3_ ( .D(n76), .CK(clk), .RN(n72), .Q(RegB[3]) );
  DFFRX1 RegB_reg_5_ ( .D(n78), .CK(clk), .RN(n72), .Q(RegB[5]) );
  AO21X1 U109 ( .A0(n24), .A1(n109), .B0(n12), .Y(n15) );
  CLKINVX1 U110 ( .A(n39), .Y(n9) );
  CLKINVX1 U111 ( .A(n40), .Y(n7) );
  NAND3BX1 U112 ( .AN(n24), .B(n39), .C(n17), .Y(n40) );
  CLKINVX1 U113 ( .A(n48), .Y(n17) );
  NAND2BX1 U114 ( .AN(n49), .B(n6), .Y(n48) );
  CLKINVX1 U115 ( .A(n42), .Y(n53) );
  CLKINVX1 U116 ( .A(n58), .Y(n60) );
  CLKINVX1 U117 ( .A(n38), .Y(n11) );
  NAND2BX1 U118 ( .AN(n109), .B(n24), .Y(n38) );
  CLKINVX1 U119 ( .A(n55), .Y(n47) );
  AO21X1 U120 ( .A0(Quotient[6]), .A1(n15), .B0(n16), .Y(n88) );
  AO22X1 U121 ( .A0(Dividend[7]), .A1(Load), .B0(Quotient[7]), .B1(n17), .Y(
        n16) );
  AO21X1 U122 ( .A0(Quotient[3]), .A1(n15), .B0(n20), .Y(n85) );
  AO22X1 U123 ( .A0(Dividend[4]), .A1(Load), .B0(Quotient[4]), .B1(n17), .Y(
        n20) );
  AO21X1 U124 ( .A0(Quotient[4]), .A1(n15), .B0(n19), .Y(n86) );
  AO22X1 U125 ( .A0(Dividend[5]), .A1(Load), .B0(Quotient[5]), .B1(n17), .Y(
        n19) );
  AO21X1 U126 ( .A0(Quotient[5]), .A1(n15), .B0(n18), .Y(n87) );
  AO22X1 U127 ( .A0(Dividend[6]), .A1(Load), .B0(Quotient[6]), .B1(n17), .Y(
        n18) );
  AO21X1 U128 ( .A0(Quotient[0]), .A1(n15), .B0(n23), .Y(n82) );
  AO21X1 U129 ( .A0(Quotient[2]), .A1(n15), .B0(n21), .Y(n84) );
  AO22X1 U130 ( .A0(Dividend[3]), .A1(Load), .B0(Quotient[3]), .B1(n17), .Y(
        n21) );
  AO21X1 U131 ( .A0(Quotient[1]), .A1(n15), .B0(n22), .Y(n83) );
  AO22X1 U132 ( .A0(Dividend[2]), .A1(Load), .B0(Quotient[2]), .B1(n17), .Y(
        n22) );
  AO22X1 U133 ( .A0(RegB[0]), .A1(n6), .B0(Divisor[0]), .B1(Load), .Y(n73) );
  AO22X1 U134 ( .A0(RegB[7]), .A1(n6), .B0(Load), .B1(Divisor[7]), .Y(n80) );
  AO22X1 U135 ( .A0(RegB[5]), .A1(n6), .B0(Divisor[5]), .B1(Load), .Y(n78) );
  AO22X1 U136 ( .A0(RegB[1]), .A1(n6), .B0(Divisor[1]), .B1(Load), .Y(n74) );
  AO22X1 U137 ( .A0(RegB[3]), .A1(n6), .B0(Divisor[3]), .B1(Load), .Y(n76) );
  AO21X1 U138 ( .A0(Quotient[0]), .A1(n17), .B0(n45), .Y(n81) );
  AO22X1 U139 ( .A0(Dividend[0]), .A1(Load), .B0(CurrentState[1]), .B1(n12), 
        .Y(n45) );
  CLKINVX1 U140 ( .A(n43), .Y(n24) );
  NAND3BX1 U141 ( .AN(Load), .B(n106), .C(CurrentState[2]), .Y(n43) );
  AND2X2 U142 ( .A(n109), .B(n24), .Y(n108) );
  AO21X1 U143 ( .A0(Remainder[1]), .A1(n7), .B0(n8), .Y(n90) );
  OAI2BB1X1 U144 ( .A0N(RegA_minus_RegB[1]), .A1N(n9), .B0(n10), .Y(n8) );
  AOI222X1 U145 ( .A0(Remainder[2]), .A1(n11), .B0(Remainder[0]), .B1(n12), 
        .C0(N124), .C1(n108), .Y(n10) );
  AO21X1 U146 ( .A0(n7), .A1(Remainder[2]), .B0(n35), .Y(n91) );
  OAI2BB1X1 U147 ( .A0N(RegA_minus_RegB[2]), .A1N(n9), .B0(n36), .Y(n35) );
  AOI222X1 U148 ( .A0(Remainder[3]), .A1(n11), .B0(Remainder[1]), .B1(n12), 
        .C0(N125), .C1(n108), .Y(n36) );
  AO21X1 U149 ( .A0(Remainder[3]), .A1(n7), .B0(n33), .Y(n920) );
  OAI2BB1X1 U150 ( .A0N(RegA_minus_RegB[3]), .A1N(n9), .B0(n34), .Y(n33) );
  AOI222X1 U151 ( .A0(Remainder[4]), .A1(n11), .B0(Remainder[2]), .B1(n12), 
        .C0(N126), .C1(n108), .Y(n34) );
  AO21X1 U152 ( .A0(Remainder[4]), .A1(n7), .B0(n31), .Y(n930) );
  OAI2BB1X1 U153 ( .A0N(RegA_minus_RegB[4]), .A1N(n9), .B0(n32), .Y(n31) );
  AOI222X1 U154 ( .A0(Remainder[5]), .A1(n11), .B0(Remainder[3]), .B1(n12), 
        .C0(N127), .C1(n108), .Y(n32) );
  AO21X1 U155 ( .A0(Remainder[5]), .A1(n7), .B0(n29), .Y(n940) );
  OAI2BB1X1 U156 ( .A0N(RegA_minus_RegB[5]), .A1N(n9), .B0(n30), .Y(n29) );
  AOI222X1 U157 ( .A0(Remainder[6]), .A1(n11), .B0(Remainder[4]), .B1(n12), 
        .C0(N128), .C1(n108), .Y(n30) );
  AO21X1 U158 ( .A0(Remainder[6]), .A1(n7), .B0(n27), .Y(n950) );
  OAI2BB1X1 U159 ( .A0N(RegA_minus_RegB[6]), .A1N(n9), .B0(n28), .Y(n27) );
  AOI222X1 U160 ( .A0(Remainder[7]), .A1(n11), .B0(Remainder[5]), .B1(n12), 
        .C0(N129), .C1(n108), .Y(n28) );
  OAI32X1 U161 ( .A0(n106), .A1(n109), .A2(n107), .B0(n57), .B1(n41), .Y(n970)
         );
  AOI222X1 U162 ( .A0(n53), .A1(CurrentState[1]), .B0(CurrentState[1]), .B1(
        n50), .C0(Load), .C1(n106), .Y(n57) );
  OAI32X1 U163 ( .A0(n106), .A1(CurrentState[0]), .A2(n50), .B0(n51), .B1(n106), .Y(n99) );
  CLKINVX1 U164 ( .A(n52), .Y(n51) );
  OAI31X1 U165 ( .A0(n53), .A1(N37), .A2(n106), .B0(n54), .Y(n98) );
  AOI221X1 U166 ( .A0(CurrentState[2]), .A1(n109), .B0(CurrentState[1]), .B1(
        CurrentState[2]), .C0(n47), .Y(n54) );
  OR4X1 U167 ( .A(n66), .B(CurrentCount[2]), .C(CurrentCount[0]), .D(
        CurrentCount[1]), .Y(n42) );
  NAND4BX1 U168 ( .AN(n41), .B(CurrentState[1]), .C(n6), .D(n42), .Y(n39) );
  AO22X1 U169 ( .A0(CurrentState[2]), .A1(CurrentState[0]), .B0(
        CurrentState[1]), .B1(n52), .Y(n58) );
  NAND2BX1 U170 ( .AN(CurrentState[2]), .B(CurrentState[0]), .Y(n55) );
  AO21X1 U171 ( .A0(n53), .A1(n109), .B0(CurrentState[2]), .Y(n52) );
  AO21X1 U172 ( .A0(n60), .A1(CurrentState[1]), .B0(n49), .Y(n59) );
  OAI2BB1X1 U173 ( .A0N(n7), .A1N(Remainder[0]), .B0(n14), .Y(n89) );
  AOI222X1 U174 ( .A0(RegA_minus_RegB[0]), .A1(n9), .B0(Quotient[7]), .B1(n15), 
        .C0(Remainder[1]), .C1(n11), .Y(n14) );
  OAI31X1 U175 ( .A0(n107), .A1(CurrentState[1]), .A2(CurrentState[0]), .B0(
        n55), .Y(n49) );
  AO22X1 U176 ( .A0(CurrentCount[1]), .A1(n58), .B0(N93), .B1(n59), .Y(n101)
         );
  AO22X1 U177 ( .A0(CurrentCount[2]), .A1(n58), .B0(N94), .B1(n59), .Y(n102)
         );
  AO22X1 U178 ( .A0(CurrentCount[3]), .A1(n58), .B0(N95), .B1(n59), .Y(n103)
         );
  AO22X1 U179 ( .A0(CurrentCount[5]), .A1(n58), .B0(N97), .B1(n59), .Y(n105)
         );
  OAI2BB1X1 U180 ( .A0N(Remainder[7]), .A1N(n7), .B0(n26), .Y(n960) );
  AOI222X1 U181 ( .A0(N37), .A1(n9), .B0(Remainder[6]), .B1(n12), .C0(N130), 
        .C1(n108), .Y(n26) );
  AO21X1 U182 ( .A0(N92), .A1(n60), .B0(n63), .Y(n100) );
  AO21X1 U183 ( .A0(CurrentCount[0]), .A1(n58), .B0(n110), .Y(n63) );
  AO21X1 U184 ( .A0(N96), .A1(n60), .B0(n61), .Y(n104) );
  AO21X1 U185 ( .A0(CurrentCount[4]), .A1(n58), .B0(n110), .Y(n61) );
  OR3X2 U186 ( .A(CurrentCount[5]), .B(CurrentCount[4]), .C(CurrentCount[3]), 
        .Y(n66) );
  NAND2BX1 U187 ( .AN(CurrentState[2]), .B(n109), .Y(n41) );
  NOR2X1 U188 ( .A(CurrentState[1]), .B(n41), .Y(n110) );
  CLKINVX2 U189 ( .A(rst_p), .Y(n72) );
  DFFRX1 RegA_reg_5_ ( .D(n86), .CK(clk), .RN(n72), .Q(Quotient[5]) );
  DFFRX1 RegA_reg_4_ ( .D(n85), .CK(clk), .RN(n72), .Q(Quotient[4]) );
  DFFRX1 RegA_reg_6_ ( .D(n87), .CK(clk), .RN(n72), .Q(Quotient[6]) );
  DFFRX1 RegA_reg_3_ ( .D(n84), .CK(clk), .RN(n72), .Q(Quotient[3]) );
  DFFRX1 RegA_reg_2_ ( .D(n83), .CK(clk), .RN(n72), .Q(Quotient[2]) );
  DFFRX1 RegA_reg_0_ ( .D(n81), .CK(clk), .RN(n72), .Q(Quotient[0]) );
  DFFRX1 RegA_reg_1_ ( .D(n82), .CK(clk), .RN(n72), .Q(Quotient[1]) );
  DFFRX1 RegA_reg_7_ ( .D(n88), .CK(clk), .RN(n72), .Q(Quotient[7]) );
  DFFRX1 RegA_reg_9_ ( .D(n90), .CK(clk), .RN(n72), .Q(Remainder[1]) );
  DFFRX1 RegB_reg_0_ ( .D(n73), .CK(clk), .RN(n72), .Q(RegB[0]) );
  DFFRX1 RegA_reg_8_ ( .D(n89), .CK(clk), .RN(n72), .Q(Remainder[0]) );
  DFFSX1 CurrentCount_reg_0_ ( .D(n100), .CK(clk), .SN(n72), .Q(
        CurrentCount[0]) );
  DFFRX1 CurrentState_reg_2_ ( .D(n99), .CK(clk), .RN(n72), .Q(CurrentState[2]), .QN(n107) );
  DFFRX1 RegB_reg_2_ ( .D(n75), .CK(clk), .RN(n72), .Q(RegB[2]) );
  DFFRX1 RegB_reg_4_ ( .D(n77), .CK(clk), .RN(n72), .Q(RegB[4]) );
  DFFRX1 RegB_reg_6_ ( .D(n79), .CK(clk), .RN(n72), .Q(RegB[6]) );
  DFFSX1 CurrentCount_reg_4_ ( .D(n104), .CK(clk), .SN(n72), .Q(
        CurrentCount[4]) );
  DFFRX1 CurrentCount_reg_1_ ( .D(n101), .CK(clk), .RN(n72), .Q(
        CurrentCount[1]) );
  DFFRX1 CurrentCount_reg_2_ ( .D(n102), .CK(clk), .RN(n72), .Q(
        CurrentCount[2]) );
  DFFRX1 CurrentCount_reg_3_ ( .D(n103), .CK(clk), .RN(n72), .Q(
        CurrentCount[3]) );
  DFFRX1 RegA_reg_11_ ( .D(n920), .CK(clk), .RN(n72), .Q(Remainder[3]) );
  DFFRX1 RegA_reg_12_ ( .D(n930), .CK(clk), .RN(n72), .Q(Remainder[4]) );
  DFFRX1 RegA_reg_13_ ( .D(n940), .CK(clk), .RN(n72), .Q(Remainder[5]) );
  DFFRX1 RegA_reg_14_ ( .D(n950), .CK(clk), .RN(n72), .Q(Remainder[6]) );
  DFFRX1 RegA_reg_10_ ( .D(n91), .CK(clk), .RN(n72), .Q(Remainder[2]) );
  DFFRX1 CurrentCount_reg_5_ ( .D(n105), .CK(clk), .RN(n72), .Q(
        CurrentCount[5]) );
  DFFRX1 CurrentState_reg_0_ ( .D(n970), .CK(clk), .RN(n72), .Q(
        CurrentState[0]), .QN(n109) );
  DFFRX1 RegB_reg_7_ ( .D(n80), .CK(clk), .RN(n72), .Q(RegB[7]) );
  DFFRX1 RegA_reg_15_ ( .D(n960), .CK(clk), .RN(n72), .Q(Remainder[7]) );
  AO22X1 U190 ( .A0(Dividend[1]), .A1(Load), .B0(Quotient[1]), .B1(n17), .Y(
        n23) );
  AO22X1 U191 ( .A0(RegB[6]), .A1(n6), .B0(Divisor[6]), .B1(Load), .Y(n79) );
  AO22X1 U192 ( .A0(RegB[4]), .A1(n6), .B0(Divisor[4]), .B1(Load), .Y(n77) );
  AO22X1 U193 ( .A0(RegB[2]), .A1(n6), .B0(Divisor[2]), .B1(Load), .Y(n75) );
  div_DW01_add_7_0 add_124 ( .A(Remainder[6:0]), .B(RegB[6:0]), .CI(1'b0), 
        .SUM({N130, N129, N128, N127, N126, N125, N124}) );
  div_DW01_sub_8_0 sub_89 ( .A(Remainder), .B(RegB), .CI(1'b0), .DIFF({N37, 
        RegA_minus_RegB}) );
  div_DW01_dec_6_0 r74 ( .A(CurrentCount), .SUM({N97, N96, N95, N94, N93, N92}) );
endmodule


module div_DW01_dec_6_0 ( A, SUM );
  input [5:0] A;
  output [5:0] SUM;
  wire   carry_5_, carry_4_, carry_3_, carry_2_;

  XNOR2X1 U1_A_1 ( .A(A[1]), .B(A[0]), .Y(SUM[1]) );
  XNOR2X1 U1_A_2 ( .A(A[2]), .B(carry_2_), .Y(SUM[2]) );
  XNOR2X1 U1_A_3 ( .A(A[3]), .B(carry_3_), .Y(SUM[3]) );
  XNOR2X1 U1_A_5 ( .A(A[5]), .B(carry_5_), .Y(SUM[5]) );
  OR2X1 U1_B_4 ( .A(A[4]), .B(carry_4_), .Y(carry_5_) );
  XNOR2X1 U1_A_4 ( .A(A[4]), .B(carry_4_), .Y(SUM[4]) );
  OR2X1 U1_B_1 ( .A(A[1]), .B(A[0]), .Y(carry_2_) );
  OR2X1 U1_B_2 ( .A(A[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X1 U1_B_3 ( .A(A[3]), .B(carry_3_), .Y(carry_4_) );
  CLKINVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module div_DW01_sub_8_0 ( A, B, CI, DIFF, CO );
  input [7:0] A;
  input [7:0] B;
  output [7:0] DIFF;
  input CI;
  output CO;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_;
  wire   [7:0] B_not;

  XOR3X1 U2_7 ( .A(A[7]), .B(B_not[7]), .C(carry_7_), .Y(DIFF[7]) );
  CLKINVX1 U6 ( .A(B[7]), .Y(B_not[7]) );
  ADDFX2 U2_1 ( .A(A[1]), .B(B_not[1]), .CI(carry_1_), .S(DIFF[1]), .CO(
        carry_2_) );
  CLKINVX1 U7 ( .A(B[1]), .Y(B_not[1]) );
  ADDFX2 U2_2 ( .A(A[2]), .B(B_not[2]), .CI(carry_2_), .S(DIFF[2]), .CO(
        carry_3_) );
  CLKINVX1 U8 ( .A(B[2]), .Y(B_not[2]) );
  ADDFX2 U2_3 ( .A(A[3]), .B(B_not[3]), .CI(carry_3_), .S(DIFF[3]), .CO(
        carry_4_) );
  CLKINVX1 U9 ( .A(B[3]), .Y(B_not[3]) );
  ADDFX2 U2_4 ( .A(A[4]), .B(B_not[4]), .CI(carry_4_), .S(DIFF[4]), .CO(
        carry_5_) );
  CLKINVX1 U10 ( .A(B[4]), .Y(B_not[4]) );
  ADDFX2 U2_5 ( .A(A[5]), .B(B_not[5]), .CI(carry_5_), .S(DIFF[5]), .CO(
        carry_6_) );
  CLKINVX1 U11 ( .A(B[5]), .Y(B_not[5]) );
  ADDFX2 U2_6 ( .A(A[6]), .B(B_not[6]), .CI(carry_6_), .S(DIFF[6]), .CO(
        carry_7_) );
  CLKINVX1 U12 ( .A(B[6]), .Y(B_not[6]) );
  CLKINVX1 U13 ( .A(B[0]), .Y(B_not[0]) );
  OR2X1 U14 ( .A(B_not[0]), .B(A[0]), .Y(carry_1_) );
  XNOR2X1 U15 ( .A(A[0]), .B(B_not[0]), .Y(DIFF[0]) );
endmodule


module div_DW01_add_7_0 ( A, B, CI, SUM, CO );
  input [6:0] A;
  input [6:0] B;
  output [6:0] SUM;
  input CI;
  output CO;
  wire   carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, carry_1_;

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
  XOR3X1 U1_6 ( .A(A[6]), .B(B[6]), .C(carry_6_), .Y(SUM[6]) );
  AND2X1 U4 ( .A(A[0]), .B(B[0]), .Y(carry_1_) );
  XOR2X1 U5 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module da ( d, ac, cy, q );
  input [7:0] d;
  output [7:0] q;
  input ac, cy;
  wire   d_0_, N12, N13, N14, N24, N25, N26, n38, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, add_12_carry_4_, add_12_carry_3_;
  assign q[0] = d_0_;
  assign d_0_ = d[0];

  NAND2X2 U36 ( .A(n82), .B(N24), .Y(n80) );
  NAND2X4 U37 ( .A(n93), .B(n73), .Y(n57) );
  CLKINVX1 U38 ( .A(cy), .Y(n56) );
  AND2X2 U39 ( .A(n81), .B(n55), .Y(n43) );
  CLKINVX3 U40 ( .A(d[7]), .Y(n83) );
  BUFX6 U41 ( .A(n46), .Y(n93) );
  INVX1 U42 ( .A(d[6]), .Y(n82) );
  NAND2X2 U43 ( .A(n70), .B(N12), .Y(add_12_carry_3_) );
  NAND2X1 U44 ( .A(n71), .B(n72), .Y(q[1]) );
  INVX3 U45 ( .A(n93), .Y(add_12_carry_4_) );
  NAND2X1 U46 ( .A(n47), .B(d[3]), .Y(n46) );
  OR2X1 U47 ( .A(d[1]), .B(d[2]), .Y(n47) );
  INVX1 U48 ( .A(d[1]), .Y(N12) );
  NAND2X1 U49 ( .A(d[7]), .B(n80), .Y(n55) );
  AND3X1 U50 ( .A(n78), .B(n79), .C(n46), .Y(n44) );
  NAND2BX1 U51 ( .AN(n77), .B(n57), .Y(n52) );
  NAND2BX1 U52 ( .AN(n91), .B(n57), .Y(n60) );
  OAI2BB1X1 U53 ( .A0N(n57), .A1N(n48), .B0(n45), .Y(q[7]) );
  AOI21X1 U54 ( .A0(n50), .A1(n51), .B0(n43), .Y(n45) );
  NAND2X1 U55 ( .A(n55), .B(n56), .Y(n51) );
  AND2X1 U56 ( .A(n93), .B(n73), .Y(n49) );
  NOR3BX1 U57 ( .AN(N26), .B(ac), .C(add_12_carry_4_), .Y(n50) );
  INVX1 U58 ( .A(ac), .Y(n73) );
  NOR2X1 U59 ( .A(n90), .B(n76), .Y(n89) );
  NAND4X1 U60 ( .A(add_12_carry_3_), .B(d[3]), .C(d[5]), .D(n88), .Y(n87) );
  NOR2X1 U61 ( .A(n76), .B(n82), .Y(n88) );
  NAND2X1 U62 ( .A(d[3]), .B(n93), .Y(n65) );
  INVX1 U63 ( .A(d[5]), .Y(N24) );
  INVX1 U64 ( .A(d[4]), .Y(n76) );
  INVX1 U65 ( .A(d[3]), .Y(n90) );
  INVX1 U66 ( .A(d[2]), .Y(n70) );
  NAND2X1 U67 ( .A(n80), .B(n86), .Y(N25) );
  NAND2X1 U68 ( .A(d[6]), .B(d[5]), .Y(n86) );
  AOI21X1 U69 ( .A0(n62), .A1(n55), .B0(N24), .Y(n58) );
  NOR2X1 U70 ( .A(add_12_carry_4_), .B(n63), .Y(n62) );
  INVX1 U71 ( .A(n63), .Y(n79) );
  NAND2X1 U72 ( .A(d[7]), .B(n80), .Y(n78) );
  XNOR2X1 U73 ( .A(n84), .B(n82), .Y(n77) );
  NAND3X1 U74 ( .A(add_12_carry_3_), .B(d[5]), .C(n89), .Y(n84) );
  NAND2X1 U75 ( .A(N14), .B(n57), .Y(n66) );
  XNOR2X1 U76 ( .A(add_12_carry_3_), .B(n90), .Y(N14) );
  NAND2X1 U77 ( .A(N13), .B(n57), .Y(n68) );
  OAI2BB1X1 U78 ( .A0N(d[2]), .A1N(d[1]), .B0(add_12_carry_3_), .Y(N13) );
  XNOR2X1 U79 ( .A(n85), .B(N24), .Y(n91) );
  NAND3X1 U80 ( .A(d[3]), .B(d[4]), .C(add_12_carry_3_), .Y(n85) );
  NAND2BX1 U81 ( .AN(n92), .B(n57), .Y(n64) );
  XNOR2X1 U82 ( .A(n93), .B(n76), .Y(n92) );
  NAND3X1 U83 ( .A(n52), .B(n53), .C(n54), .Y(q[6]) );
  NAND2X1 U84 ( .A(n44), .B(d[6]), .Y(n54) );
  NAND3X1 U85 ( .A(N25), .B(n49), .C(n51), .Y(n53) );
  MXI2X1 U86 ( .S0(d[1]), .B(n44), .A(n57), .Y(n71) );
  NAND2X1 U87 ( .A(n49), .B(d[1]), .Y(n72) );
  NOR2X1 U88 ( .A(n44), .B(n57), .Y(n74) );
  INVX1 U89 ( .A(d_0_), .Y(n75) );
  XOR2X1 U90 ( .A(n87), .B(n83), .Y(n48) );
  NAND2X1 U91 ( .A(n73), .B(n56), .Y(n63) );
  XNOR2X1 U92 ( .A(n80), .B(n83), .Y(N26) );
  AOI21X1 U93 ( .A0(n61), .A1(n51), .B0(d[5]), .Y(n59) );
  NOR2X1 U94 ( .A(ac), .B(add_12_carry_4_), .Y(n61) );
  OAI21X1 U95 ( .A0(n58), .A1(n59), .B0(n60), .Y(q[5]) );
  OAI2BB1X1 U96 ( .A0N(d[4]), .A1N(n93), .B0(n64), .Y(q[4]) );
  NAND2X1 U97 ( .A(n65), .B(n66), .Y(q[3]) );
  NAND2X1 U98 ( .A(n67), .B(n68), .Y(q[2]) );
  NOR2X1 U99 ( .A(cy), .B(n83), .Y(n81) );
  NAND2X1 U100 ( .A(n69), .B(n93), .Y(n67) );
  NOR2X1 U101 ( .A(ac), .B(n70), .Y(n69) );
  NOR2X8 U102 ( .A(n74), .B(n75), .Y(n38) );
endmodule


module rl ( d, q );
  input [7:0] d;
  output [7:0] q;
  wire   \q[1] , n1, n3, n5, n7, n9, n11, n13;
  assign q[1] = \q[1] ;
  assign \q[1]  = d[0];

  INVX1 U1 ( .A(n7), .Y(q[4]) );
  INVX1 U2 ( .A(n11), .Y(q[6]) );
  INVX1 U3 ( .A(n13), .Y(q[7]) );
  INVX1 U4 ( .A(d[6]), .Y(n13) );
  CLKINVX1 U5 ( .A(n9), .Y(q[5]) );
  INVX1 U6 ( .A(d[4]), .Y(n9) );
  CLKINVX1 U7 ( .A(n3), .Y(q[2]) );
  INVX1 U8 ( .A(d[1]), .Y(n3) );
  INVX1 U9 ( .A(d[3]), .Y(n7) );
  INVX1 U10 ( .A(d[5]), .Y(n11) );
  CLKINVX1 U11 ( .A(n5), .Y(q[3]) );
  INVX1 U12 ( .A(d[2]), .Y(n5) );
  INVX1 U13 ( .A(d[7]), .Y(n1) );
  CLKINVX1 U14 ( .A(n1), .Y(q[0]) );
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
  INVX1 U2 ( .A(n5), .Y(q[3]) );
  INVX1 U3 ( .A(n11), .Y(q[6]) );
  INVX1 U4 ( .A(n9), .Y(q[5]) );
  INVX1 U5 ( .A(n3), .Y(q[2]) );
  INVX1 U6 ( .A(d[6]), .Y(n13) );
  INVX1 U7 ( .A(d[1]), .Y(n3) );
  CLKINVX1 U8 ( .A(n7), .Y(q[4]) );
  INVX1 U9 ( .A(d[3]), .Y(n7) );
  INVX1 U10 ( .A(d[5]), .Y(n11) );
  INVX1 U11 ( .A(d[2]), .Y(n5) );
  INVX1 U12 ( .A(d[4]), .Y(n9) );
  CLKINVX1 U13 ( .A(n15), .Y(out_cy) );
  INVX1 U14 ( .A(d[7]), .Y(n15) );
  CLKINVX1 U15 ( .A(n1), .Y(q[0]) );
  INVX1 U16 ( .A(in_cy), .Y(n1) );
endmodule


module rr ( d, q );
  input [7:0] d;
  output [7:0] q;
  wire   \q[7] , n1, n3, n5, n7, n9, n11, n13;
  assign q[7] = \q[7] ;
  assign \q[7]  = d[0];

  INVX1 U1 ( .A(n7), .Y(q[3]) );
  INVX1 U2 ( .A(n5), .Y(q[2]) );
  INVX1 U3 ( .A(n11), .Y(q[5]) );
  INVX1 U4 ( .A(n3), .Y(q[1]) );
  CLKINVX1 U5 ( .A(n9), .Y(q[4]) );
  INVX1 U6 ( .A(d[5]), .Y(n9) );
  INVX1 U7 ( .A(d[6]), .Y(n11) );
  CLKINVX1 U8 ( .A(n1), .Y(q[0]) );
  INVX1 U9 ( .A(d[1]), .Y(n1) );
  CLKINVX1 U10 ( .A(n13), .Y(q[6]) );
  INVX1 U11 ( .A(d[7]), .Y(n13) );
  INVX1 U12 ( .A(d[2]), .Y(n3) );
  INVX1 U13 ( .A(d[3]), .Y(n5) );
  INVX1 U14 ( .A(d[4]), .Y(n7) );
endmodule


module rrc ( d, in_cy, out_cy, q );
  input [7:0] d;
  output [7:0] q;
  input in_cy;
  output out_cy;
  wire   out_cy, n1, n3, n5, n7, n9, n11, n13, n15;
  assign out_cy = d[0];

  INVX1 U1 ( .A(n13), .Y(q[6]) );
  INVX1 U2 ( .A(n11), .Y(q[5]) );
  INVX1 U3 ( .A(n7), .Y(q[3]) );
  INVX1 U4 ( .A(n5), .Y(q[2]) );
  INVX1 U5 ( .A(n15), .Y(q[7]) );
  INVX1 U6 ( .A(d[5]), .Y(n9) );
  INVX1 U7 ( .A(d[6]), .Y(n11) );
  CLKINVX1 U8 ( .A(n1), .Y(q[0]) );
  INVX1 U9 ( .A(d[1]), .Y(n1) );
  CLKINVX1 U10 ( .A(n3), .Y(q[1]) );
  INVX1 U11 ( .A(d[2]), .Y(n3) );
  INVX1 U12 ( .A(d[3]), .Y(n5) );
  INVX1 U13 ( .A(d[7]), .Y(n13) );
  INVX1 U14 ( .A(d[4]), .Y(n7) );
  CLKINVX1 U15 ( .A(n9), .Y(q[4]) );
  INVX1 U16 ( .A(in_cy), .Y(n15) );
endmodule


module swap ( d, q );
  input [7:0] d;
  output [7:0] q;
  wire   \q[4] , n1, n3, n5, n7, n9, n11, n13;
  assign q[4] = \q[4] ;
  assign \q[4]  = d[0];

  INVX1 U1 ( .A(n9), .Y(q[5]) );
  INVX1 U2 ( .A(n11), .Y(q[6]) );
  INVX1 U3 ( .A(n3), .Y(q[1]) );
  INVX1 U4 ( .A(n13), .Y(q[7]) );
  INVX1 U5 ( .A(n7), .Y(q[3]) );
  INVX1 U6 ( .A(n5), .Y(q[2]) );
  INVX1 U7 ( .A(d[3]), .Y(n13) );
  CLKINVX1 U8 ( .A(n1), .Y(q[0]) );
  INVX1 U9 ( .A(d[4]), .Y(n1) );
  INVX1 U10 ( .A(d[1]), .Y(n9) );
  INVX1 U11 ( .A(d[5]), .Y(n3) );
  INVX1 U12 ( .A(d[6]), .Y(n5) );
  INVX1 U13 ( .A(d[2]), .Y(n11) );
  INVX1 U14 ( .A(d[7]), .Y(n7) );
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
         set_ie0, set_ie1, shift12, uart_int, parity, disint, n2, n101, n134,
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
         n595, n596, n597, n598, n599, n600, n601, n602, n603, n604, n605,
         n606, n607, n608, n609, n610, n611, n612, n613, n614, n615, n616,
         n617, n618, n619, n620, n621, n622, n623, n624, n625, n626, n627,
         n628, n629, n630, n631, n632, n633, n634, n635, n636, n637, n638,
         n639, n640, n641, n642, n643, n644, n645, n646, n647, n648, n649,
         n650, n651, n652, n653, n654, n655, n656, n657;
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

  gpio0 U_port0 ( .clk(clk), .rst_p(rst_p), .wr(n259), .rmw(rmw), .combus(
        in_sfr), .prt0_addr({n195, n188, n216, n656, n224, n204, n220, n207}), 
        .p0_in(p0_in), .p0(p0), .p0_out(p0_out) );
  sp U0_sp ( .clk(clk), .rst_p(rst_p), .wr(n259), .inc_sp(inc_sp), .dec_sp(
        dec_sp), .addr_sp({n196, n651, n216, n656, n223, n204, n220, n207}), 
        .in_sp(in_sfr), .out_sp(out_sp_r) );
  dptr U1_dptr ( .clk(clk), .rst_p(rst_p), .ld_dpl(ld_dpl), .ld_dph(ld_dph), 
        .wr(n259), .inc_dptr(inc_dptr), .addr_dptr({n196, n188, n216, n656, 
        n223, n204, n220, n207}), .in_dptr(in_sfr), .out_dptr(out_dptr_r) );
  dimod U1_dimod ( .clk(clk), .rst_p(rst_p), .wr(n259), .addr_dimod({n195, 
        n188, n216, n656, n223, n204, n220, n207}), .in_dimod(in_sfr), 
        .out_dimod(out_dimod_r) );
  one_shot_2 one_shot_tf0 ( .rst_p(rst_p), .clk(clk), .d(tf0), .q(tf0_sync) );
  one_shot_1 one_shot_tf1 ( .rst_p(rst_p), .clk(clk), .d(tf1), .q(tf1_sync) );
  tcon U_tcon ( .clk(clk), .rst_p(rst_p), .in_tcon(in_sfr), .addr_tcon({n195, 
        n188, n216, n656, n223, n204, n220, n207}), .wr(n259), .set_tf0(
        tf0_sync), .rst_tf0(rst_tf0), .set_tf1(tf1_sync), .rst_tf1(rst_tf1), 
        .set_ie0(set_ie0), .rst_ie0(rst_ie0), .set_ie1(set_ie1), .rst_ie1(
        rst_ie1), .out_tcon(tcon) );
  tmod U_tmod ( .clk(clk), .rst_p(rst_p), .wr(n259), .in_tmod(in_sfr), 
        .addr_tmod({n196, n651, n216, n656, n223, n204, n220, n207}), 
        .out_tmod(tmod) );
  u_tc U12_u_tc ( .clk(clk), .rst_p(rst_p), .wr(n259), .in_tc(in_sfr), 
        .addr_tc({n195, n651, n216, n656, n260, n204, n220, n206}), .t0_pin(
        t0_pin), .t1_pin(t1_pin), .int0_pin(int0_pin), .int1_pin(int1_pin), 
        .sel_tc0(tmod[2]), .sel_tc1(tmod[6]), .gate0(tmod[3]), .gate1(tmod[7]), 
        .tr0(tcon[4]), .tr1(tcon[6]), .tm0(tmod[1:0]), .tm1(tmod[5:4]), .tf0(
        tf0), .tf1(tf1), .tl0(tl0), .tl1(tl1), .th0(th0), .th1(th1), .shift12(
        shift12) );
  gpio1 U_port1 ( .clk(clk), .rst_p(rst_p), .wr(n259), .rmw(rmw), .combus(
        in_sfr), .prt1_addr({n196, n651, n216, n656, n223, n204, n220, n207}), 
        .p1_in(p1_in), .p1(p1), .p1_out(p1_out) );
  u_uart U_uart ( .clk(clk), .rst_p(rst_p), .rxdi(rxdi), .rxdo(rxdo), .in_sfr(
        in_sfr), .addr_sfr({n196, n188, n234, n656, n223, n204, n220, n207}), 
        .wr(n259), .shift12(shift12), .tf1(tf1_sync), .txdo(txdo), .uart_int(
        uart_int), .scon(scon), .pcon(pcon), .sbuf(sbuf) );
  gpio2 U_port2 ( .clk(clk), .rst_p(rst_p), .wr(n259), .rmw(rmw), .combus(
        in_sfr), .prt2_addr({n196, n188, n216, n656, n223, n204, n220, n207}), 
        .p2_in(p2_in), .p2(p2), .p2_out(p2_out) );
  ie U_ie ( .clk(clk), .rst_p(rst_p), .in_ie(in_sfr), .addr_ie({n195, n188, 
        n216, n656, n224, n204, n220, n207}), .wr(n259), .out_ie(ie) );
  gpio3 U_port3 ( .clk(clk), .rst_p(rst_p), .wr(n259), .rmw(rmw), .combus(
        in_sfr), .prt3_addr({n195, n651, n216, n656, n224, n204, n220, n207}), 
        .p3_in(p3_in), .p3(p3), .p3_out(p3_out) );
  ip U_ip ( .clk(clk), .rst_p(rst_p), .in_ip(in_sfr), .addr_ip({n196, n651, 
        n216, n656, n224, n204, n220, n207}), .wr(n259), .out_ip(ip) );
  psw U3_psw ( .rst_p(rst_p), .in_psw(in_sfr[7:1]), .clk(clk), .addr_psw({n196, 
        n651, n216, n656, n223, n204, n220, n207}), .wr(n259), .in_cy_bit(
        in_cy_bit), .set_c(set_c), .rst_c(rst_c), .cpl_c(cpl_c), .ld_c(ld_c), 
        .set_ac(set_ac), .rst_ac(rst_ac), .set_v(set_v), .rst_v(rst_v), 
        .parity(parity), .out_psw(out_psw) );
  acc U2_acc ( .clk(clk), .rst_p(rst_p), .ld_acc(ld_acc), .ld_acc_chd(
        ld_acc_chd), .wr(n259), .addr_acc({n195, n188, n216, n656, n223, n204, 
        n220, n207}), .in_acc(in_sfr), .acc_chd(acc_chd), .out_acc_r(out_acc_r) );
  parity_gen U4_parity ( .p_acc({out_acc_r[7:4], n199, out_acc_r[2], n192, 
        n201}), .parity(parity) );
  b U4_b ( .clk(clk), .rst_p(rst_p), .in_b(in_b), .in_dat(in_sfr), .addr_b({
        n196, n651, n216, n656, n223, n204, n220, n207}), .wr(n259), .ld_b(
        ld_b), .out_b(out_b) );
  u_int U27_int ( .disint(disint), .end_instr(end_instr), .ti_ri(uart_int), 
        .clk(clk), .rst_p(rst_p), .ex_int_a(int0_pin), .ex_int_b(int1_pin), 
        .it_a(tcon[0]), .it_b(tcon[2]), .tf_a(tcon[5]), .tf_b(tcon[7]), .ie_j(
        ie[7]), .ie(ie[4:0]), .ip(ip[4:0]), .ie_a(tcon[1]), .ie_b(tcon[3]), 
        .smpl_ex_a(set_ie0), .smpl_ex_b(set_ie1), .int_vec(int_vec), .reti(
        reti), .isrc_cur(isrc_cur), .en_int(en_int) );
  INVX4 U179 ( .A(addr_sfr[2]), .Y(n634) );
  CLKINVX1 U180 ( .A(n657), .Y(n197) );
  INVX3 U181 ( .A(n251), .Y(n166) );
  NOR2X1 U182 ( .A(n592), .B(addr_sfr[0]), .Y(n172) );
  INVX12 U183 ( .A(n654), .Y(n175) );
  INVX12 U184 ( .A(n652), .Y(n657) );
  INVX8 U185 ( .A(n254), .Y(n252) );
  NAND2X6 U186 ( .A(n205), .B(n206), .Y(n311) );
  NAND2X1 U187 ( .A(n205), .B(n200), .Y(n241) );
  CLKINVX8 U188 ( .A(n646), .Y(n205) );
  AND2X8 U189 ( .A(out_b[0]), .B(n248), .Y(n244) );
  NAND2X2 U190 ( .A(n366), .B(n367), .Y(out_sfr_a[5]) );
  NAND2X4 U191 ( .A(n208), .B(n217), .Y(n641) );
  NAND2X4 U192 ( .A(n274), .B(tl0[0]), .Y(n605) );
  CLKINVX1 U193 ( .A(n274), .Y(n167) );
  CLKINVX1 U194 ( .A(n167), .Y(n168) );
  NOR2X1 U195 ( .A(n178), .B(n562), .Y(n561) );
  NOR3X1 U196 ( .A(n246), .B(n656), .C(addr_sfr[2]), .Y(n177) );
  INVX1 U197 ( .A(n628), .Y(n169) );
  INVX2 U198 ( .A(n590), .Y(n184) );
  NAND2X2 U199 ( .A(n176), .B(n252), .Y(n170) );
  NAND2X1 U200 ( .A(n176), .B(n252), .Y(n221) );
  NAND2X2 U201 ( .A(n177), .B(n172), .Y(n171) );
  INVX12 U202 ( .A(n656), .Y(n282) );
  INVX20 U203 ( .A(n653), .Y(n656) );
  CLKAND2X3 U204 ( .A(n642), .B(n656), .Y(n258) );
  INVX6 U205 ( .A(addr_sfr[4]), .Y(n653) );
  NOR2X4 U206 ( .A(n190), .B(n629), .Y(n625) );
  NOR2X2 U207 ( .A(n254), .B(n599), .Y(n631) );
  AND2X6 U208 ( .A(n173), .B(n174), .Y(n589) );
  NAND2X4 U209 ( .A(n596), .B(n241), .Y(n587) );
  NOR2X4 U210 ( .A(n600), .B(n218), .Y(n585) );
  NAND2X4 U211 ( .A(n604), .B(n605), .Y(n600) );
  NAND3X2 U212 ( .A(n184), .B(n171), .C(n185), .Y(n173) );
  INVX1 U213 ( .A(n302), .Y(n174) );
  NAND2X1 U214 ( .A(n260), .B(n609), .Y(n302) );
  NOR3X4 U215 ( .A(n587), .B(n589), .C(n588), .Y(n586) );
  INVX3 U216 ( .A(n654), .Y(n183) );
  NOR2X4 U217 ( .A(n252), .B(n166), .Y(n622) );
  NOR2BX1 U218 ( .AN(n613), .B(n240), .Y(n638) );
  NAND3X4 U219 ( .A(n175), .B(n628), .C(n251), .Y(n246) );
  NOR2X4 U220 ( .A(n194), .B(n633), .Y(n632) );
  CLKINVX8 U221 ( .A(addr_sfr[6]), .Y(n652) );
  AND2X6 U222 ( .A(n595), .B(n230), .Y(n242) );
  INVX4 U223 ( .A(n307), .Y(n230) );
  NAND2X2 U224 ( .A(n219), .B(n252), .Y(n307) );
  NOR2X1 U225 ( .A(n556), .B(n557), .Y(n555) );
  NAND3X8 U226 ( .A(n175), .B(n628), .C(n251), .Y(n608) );
  INVX8 U227 ( .A(addr_sfr[5]), .Y(n655) );
  NOR3X4 U228 ( .A(n608), .B(n656), .C(addr_sfr[2]), .Y(n219) );
  AND2X4 U229 ( .A(n219), .B(n254), .Y(n212) );
  CLKMX2X2 U230 ( .S0(n654), .B(ip[0]), .A(scon[0]), .Y(n642) );
  INVX12 U231 ( .A(n655), .Y(n654) );
  INVX4 U232 ( .A(n581), .Y(n318) );
  NAND2X4 U233 ( .A(n212), .B(n595), .Y(n581) );
  NAND2X4 U234 ( .A(n541), .B(n542), .Y(out_sfr_a[1]) );
  INVX4 U235 ( .A(addr_sfr[3]), .Y(n599) );
  INVX6 U236 ( .A(addr_sfr[1]), .Y(n609) );
  NAND2X2 U237 ( .A(n205), .B(n597), .Y(n269) );
  CLKINVX2 U238 ( .A(tcon[1]), .Y(n573) );
  INVX1 U239 ( .A(n641), .Y(n315) );
  OAI2BB1X1 U240 ( .A0N(n315), .A1N(n494), .B0(n495), .Y(n465) );
  NOR2X1 U241 ( .A(n571), .B(n572), .Y(n570) );
  OAI2BB1X2 U242 ( .A0N(n315), .A1N(n579), .B0(n580), .Y(n550) );
  NOR2X1 U243 ( .A(n564), .B(n565), .Y(n558) );
  NOR2X1 U244 ( .A(n382), .B(n282), .Y(n379) );
  OAI2BB1X1 U245 ( .A0N(n315), .A1N(n406), .B0(n407), .Y(n377) );
  NAND2X1 U246 ( .A(tl1[1]), .B(n238), .Y(n548) );
  NAND3X1 U247 ( .A(n462), .B(n463), .C(n464), .Y(n456) );
  NOR2X1 U248 ( .A(n412), .B(n413), .Y(n411) );
  NOR4X1 U249 ( .A(n421), .B(n422), .C(n423), .D(n424), .Y(n410) );
  NAND3X1 U250 ( .A(n418), .B(n419), .C(n420), .Y(n412) );
  NOR2X1 U251 ( .A(n324), .B(n325), .Y(n323) );
  NAND3X1 U252 ( .A(n330), .B(n331), .C(n332), .Y(n324) );
  NAND2X2 U253 ( .A(n261), .B(n262), .Y(out_sfr_a[7]) );
  NOR2X1 U254 ( .A(n263), .B(n264), .Y(n262) );
  NOR4X1 U255 ( .A(n275), .B(n276), .C(n277), .D(n278), .Y(n261) );
  NAND3X1 U256 ( .A(n271), .B(n272), .C(n273), .Y(n263) );
  CLKINVX3 U257 ( .A(out_psw[1]), .Y(n562) );
  AND2X4 U258 ( .A(n609), .B(n634), .Y(n623) );
  NOR2X1 U259 ( .A(n387), .B(n388), .Y(n386) );
  INVX1 U260 ( .A(n233), .Y(n227) );
  NOR2X2 U261 ( .A(n311), .B(n645), .Y(n635) );
  NAND2BX2 U262 ( .AN(n302), .B(th1[0]), .Y(n645) );
  NAND2X1 U263 ( .A(n252), .B(pcon[0]), .Y(n186) );
  CLKINVX2 U264 ( .A(tmod[1]), .Y(n574) );
  OAI2BB1X1 U265 ( .A0N(n315), .A1N(n537), .B0(n538), .Y(n508) );
  NOR2X1 U266 ( .A(n529), .B(n530), .Y(n528) );
  NOR2X1 U267 ( .A(n533), .B(n534), .Y(n527) );
  INVX1 U268 ( .A(n634), .Y(n204) );
  CLKAND2X3 U269 ( .A(n599), .B(out_sp_r[0]), .Y(n215) );
  NAND3X1 U270 ( .A(n547), .B(n548), .C(n549), .Y(n203) );
  NOR3X2 U271 ( .A(n246), .B(n656), .C(addr_sfr[2]), .Y(n176) );
  NOR3X2 U272 ( .A(n246), .B(n656), .C(addr_sfr[2]), .Y(n228) );
  NAND2X2 U273 ( .A(n599), .B(addr_sfr[1]), .Y(n598) );
  NAND2X4 U274 ( .A(n233), .B(n197), .Y(n190) );
  INVX3 U275 ( .A(n209), .Y(n234) );
  NOR2X1 U276 ( .A(n598), .B(n254), .Y(n597) );
  NAND2X6 U277 ( .A(tl1[0]), .B(n238), .Y(n604) );
  CLKINVX2 U278 ( .A(n221), .Y(n229) );
  AND2X1 U279 ( .A(n228), .B(n252), .Y(n225) );
  NAND2BX2 U280 ( .AN(n628), .B(n183), .Y(n178) );
  OAI2BB1X4 U281 ( .A0N(n225), .A1N(n226), .B0(n179), .Y(n218) );
  INVX3 U282 ( .A(n601), .Y(n179) );
  NAND3X2 U283 ( .A(n622), .B(n623), .C(n182), .Y(n180) );
  NAND3X1 U284 ( .A(n182), .B(n623), .C(n622), .Y(n181) );
  NAND3X2 U285 ( .A(n622), .B(n623), .C(n182), .Y(n287) );
  INVX2 U286 ( .A(n546), .Y(n267) );
  CLKINVX4 U287 ( .A(n260), .Y(n182) );
  BUFX8 U288 ( .A(addr_sfr[3]), .Y(n260) );
  OR2X2 U289 ( .A(addr_sfr[0]), .B(n593), .Y(n231) );
  INVX8 U290 ( .A(addr_sfr[0]), .Y(n254) );
  BUFX4 U291 ( .A(n254), .Y(n253) );
  CLKINVX1 U292 ( .A(n652), .Y(n188) );
  NOR2X1 U293 ( .A(n599), .B(n609), .Y(n607) );
  CLKAND2X3 U294 ( .A(n599), .B(n609), .Y(n603) );
  NOR2X2 U295 ( .A(n313), .B(n578), .Y(n575) );
  BUFX3 U296 ( .A(n287), .Y(n187) );
  NAND2BX2 U297 ( .AN(n221), .B(n257), .Y(n596) );
  NAND2X1 U298 ( .A(out_dptr_r[9]), .B(n242), .Y(n545) );
  NAND2X2 U299 ( .A(n498), .B(n499), .Y(out_sfr_a[2]) );
  NOR4X1 U300 ( .A(n333), .B(n334), .C(n335), .D(n336), .Y(n322) );
  NAND2X2 U301 ( .A(n322), .B(n323), .Y(out_sfr_a[6]) );
  INVX3 U302 ( .A(n591), .Y(n185) );
  NOR2X1 U303 ( .A(n598), .B(n186), .Y(n200) );
  NAND2X1 U304 ( .A(n260), .B(addr_sfr[1]), .Y(n606) );
  INVX1 U305 ( .A(n225), .Y(n189) );
  CLKBUFX2 U306 ( .A(out_dptr_r[0]), .Y(n191) );
  CLKBUFX2 U307 ( .A(out_acc_r[1]), .Y(n192) );
  INVX16 U308 ( .A(n657), .Y(n628) );
  CLKINVX6 U309 ( .A(n253), .Y(n206) );
  NAND3X2 U310 ( .A(n175), .B(n628), .C(n251), .Y(n193) );
  NAND3X1 U311 ( .A(n251), .B(n209), .C(n628), .Y(n194) );
  CLKINVX1 U312 ( .A(n256), .Y(n196) );
  CLKINVX1 U313 ( .A(n256), .Y(n195) );
  CLKBUFX2 U314 ( .A(out_dptr_r[1]), .Y(n198) );
  CLKBUFX2 U315 ( .A(out_acc_r[3]), .Y(n199) );
  NAND2X1 U316 ( .A(n198), .B(n318), .Y(n580) );
  CLKBUFX2 U317 ( .A(out_acc_r[0]), .Y(n201) );
  CLKINVX2 U318 ( .A(tcon[0]), .Y(n592) );
  NAND2X4 U319 ( .A(n632), .B(n631), .Y(n298) );
  NOR2BX4 U320 ( .AN(n219), .B(n202), .Y(n591) );
  NAND2X2 U321 ( .A(n252), .B(tmod[0]), .Y(n202) );
  CLKAND2X8 U322 ( .A(n595), .B(out_dptr_r[8]), .Y(n257) );
  INVX3 U323 ( .A(n598), .Y(n595) );
  NOR4X1 U324 ( .A(n508), .B(n509), .C(n510), .D(n511), .Y(n498) );
  AOI21X1 U325 ( .A0(n527), .A1(n528), .B0(n235), .Y(n509) );
  INVX3 U326 ( .A(n291), .Y(n248) );
  NOR2X4 U327 ( .A(n546), .B(n602), .Y(n601) );
  NOR2X2 U328 ( .A(n203), .B(n543), .Y(n542) );
  NAND2X2 U329 ( .A(n228), .B(n254), .Y(n245) );
  NOR2X2 U330 ( .A(n258), .B(n643), .Y(n640) );
  NOR2X1 U331 ( .A(n599), .B(n657), .Y(n208) );
  CLKBUFX2 U332 ( .A(n206), .Y(n207) );
  NOR2X2 U333 ( .A(n640), .B(n641), .Y(n636) );
  INVX1 U334 ( .A(addr_sfr[5]), .Y(n209) );
  NOR2X2 U335 ( .A(n279), .B(n638), .Y(n637) );
  NAND2X2 U336 ( .A(n654), .B(n657), .Y(n291) );
  CLKINVX2 U337 ( .A(n655), .Y(n233) );
  INVX4 U338 ( .A(n256), .Y(n255) );
  BUFX16 U339 ( .A(n255), .Y(n251) );
  AND3X4 U340 ( .A(n599), .B(n282), .C(n233), .Y(n210) );
  AND2X8 U341 ( .A(n603), .B(n229), .Y(n232) );
  NOR2X2 U342 ( .A(n646), .B(n231), .Y(n590) );
  NOR2X1 U343 ( .A(n560), .B(n561), .Y(n559) );
  OR2X8 U344 ( .A(n193), .B(n211), .Y(n646) );
  NAND2X2 U345 ( .A(n653), .B(addr_sfr[2]), .Y(n211) );
  NAND2X1 U346 ( .A(n254), .B(n219), .Y(n305) );
  NAND2BX4 U347 ( .AN(n646), .B(n253), .Y(n313) );
  INVX1 U348 ( .A(n609), .Y(n220) );
  NAND2X2 U349 ( .A(n410), .B(n411), .Y(out_sfr_a[4]) );
  NOR2X1 U350 ( .A(n295), .B(n566), .Y(n565) );
  INVX1 U351 ( .A(n279), .Y(n213) );
  CLKINVX2 U352 ( .A(n213), .Y(n214) );
  INVX3 U353 ( .A(n248), .Y(n249) );
  CLKBUFX2 U354 ( .A(n234), .Y(n216) );
  AND4X4 U355 ( .A(n196), .B(n254), .C(n609), .D(n634), .Y(n217) );
  NAND2X1 U356 ( .A(n260), .B(n609), .Y(n235) );
  NOR2X1 U357 ( .A(n279), .B(n554), .Y(n553) );
  OAI21X2 U358 ( .A0(n618), .A1(n619), .B0(n656), .Y(n617) );
  NOR2X2 U359 ( .A(n298), .B(n630), .Y(n618) );
  AOI21X1 U360 ( .A0(n558), .A1(n559), .B0(n181), .Y(n557) );
  INVX4 U361 ( .A(addr_sfr[7]), .Y(n256) );
  NAND2X6 U362 ( .A(n243), .B(n210), .Y(n279) );
  NOR2X1 U363 ( .A(n628), .B(n654), .Y(n222) );
  CLKBUFX2 U364 ( .A(n178), .Y(n247) );
  INVX1 U365 ( .A(n182), .Y(n223) );
  CLKBUFX2 U366 ( .A(n223), .Y(n224) );
  NOR2X4 U367 ( .A(n305), .B(n606), .Y(n274) );
  AND2X2 U368 ( .A(n609), .B(n215), .Y(n226) );
  NAND2X2 U369 ( .A(n183), .B(n628), .Y(n295) );
  NOR2X1 U370 ( .A(n311), .B(n535), .Y(n534) );
  NOR2X1 U371 ( .A(n311), .B(n577), .Y(n576) );
  NAND2X2 U372 ( .A(n609), .B(n634), .Y(n633) );
  NOR2X1 U373 ( .A(n245), .B(n573), .Y(n572) );
  AND4X4 U374 ( .A(n609), .B(n254), .C(n634), .D(n195), .Y(n243) );
  NAND2X4 U375 ( .A(n603), .B(n212), .Y(n546) );
  NOR2X2 U376 ( .A(n581), .B(n594), .Y(n588) );
  NAND2X1 U377 ( .A(n544), .B(n545), .Y(n543) );
  NOR2X1 U378 ( .A(n170), .B(n574), .Y(n571) );
  NOR2X2 U379 ( .A(n295), .B(n627), .Y(n626) );
  NOR2X1 U380 ( .A(n313), .B(n536), .Y(n533) );
  NOR2X1 U381 ( .A(n279), .B(n381), .Y(n380) );
  INVX1 U382 ( .A(p3[1]), .Y(n567) );
  INVX3 U383 ( .A(p1[1]), .Y(n566) );
  AOI21X1 U384 ( .A0(p0[1]), .A1(n267), .B0(n236), .Y(n544) );
  NOR2X1 U385 ( .A(n190), .B(n567), .Y(n564) );
  INVX3 U386 ( .A(out_b[1]), .Y(n563) );
  NOR2X2 U387 ( .A(n555), .B(n282), .Y(n552) );
  NOR2X1 U388 ( .A(n269), .B(n237), .Y(n236) );
  INVX1 U389 ( .A(pcon[1]), .Y(n237) );
  INVX1 U390 ( .A(n624), .Y(n615) );
  NOR4X2 U391 ( .A(n465), .B(n466), .C(n467), .D(n468), .Y(n454) );
  NOR2X1 U392 ( .A(n639), .B(n169), .Y(n240) );
  INVX3 U393 ( .A(ie[1]), .Y(n583) );
  INVX1 U394 ( .A(p1[0]), .Y(n627) );
  AND2X8 U395 ( .A(n230), .B(n607), .Y(n238) );
  NOR2BX4 U396 ( .AN(n239), .B(n500), .Y(n499) );
  AND3X2 U397 ( .A(n505), .B(n506), .C(n507), .Y(n239) );
  INVX3 U398 ( .A(n101), .Y(n584) );
  NAND2X2 U399 ( .A(n454), .B(n455), .Y(out_sfr_a[3]) );
  NOR2X2 U400 ( .A(n456), .B(n457), .Y(n455) );
  NOR2X2 U401 ( .A(n615), .B(n244), .Y(n621) );
  NOR2X1 U402 ( .A(n479), .B(n480), .Y(n473) );
  NOR2X1 U403 ( .A(n435), .B(n436), .Y(n429) );
  NOR2X1 U404 ( .A(n391), .B(n392), .Y(n385) );
  NOR2X1 U405 ( .A(n522), .B(n523), .Y(n516) );
  CLKINVX1 U406 ( .A(p3[2]), .Y(n525) );
  NOR2X1 U407 ( .A(n347), .B(n348), .Y(n341) );
  NOR2X1 U408 ( .A(n293), .B(n294), .Y(n285) );
  CLKINVX1 U409 ( .A(p1[3]), .Y(n481) );
  CLKINVX1 U410 ( .A(p1[5]), .Y(n393) );
  INVX1 U411 ( .A(p3[0]), .Y(n629) );
  CLKINVX1 U412 ( .A(p1[2]), .Y(n524) );
  CLKINVX1 U413 ( .A(p1[4]), .Y(n437) );
  MXI2X1 U414 ( .S0(n651), .B(out_acc_r[5]), .A(p2[5]), .Y(n381) );
  NOR2X1 U415 ( .A(n475), .B(n476), .Y(n474) );
  CLKINVX1 U416 ( .A(out_b[3]), .Y(n478) );
  OAI2BB1X1 U417 ( .A0N(n315), .A1N(n450), .B0(n451), .Y(n421) );
  CLKINVX1 U418 ( .A(tmod[6]), .Y(n357) );
  CLKINVX1 U419 ( .A(tmod[7]), .Y(n308) );
  CLKINVX1 U420 ( .A(tmod[5]), .Y(n401) );
  CLKINVX1 U421 ( .A(tcon[7]), .Y(n306) );
  CLKINVX1 U422 ( .A(tcon[5]), .Y(n400) );
  CLKINVX1 U423 ( .A(tcon[6]), .Y(n356) );
  INVX1 U424 ( .A(p0[0]), .Y(n602) );
  NAND2X1 U425 ( .A(n458), .B(n459), .Y(n457) );
  NAND2X1 U426 ( .A(n370), .B(n371), .Y(n369) );
  NAND2X1 U427 ( .A(n326), .B(n327), .Y(n325) );
  NAND2X1 U428 ( .A(n501), .B(n502), .Y(n500) );
  NAND2X1 U429 ( .A(n414), .B(n415), .Y(n413) );
  NAND2X1 U430 ( .A(n265), .B(n266), .Y(n264) );
  CLKINVX1 U431 ( .A(p1[6]), .Y(n349) );
  CLKINVX1 U432 ( .A(p1[7]), .Y(n296) );
  NAND2X1 U433 ( .A(out_dptr_r[2]), .B(n318), .Y(n538) );
  NOR2X1 U434 ( .A(n518), .B(n519), .Y(n517) );
  CLKINVX1 U435 ( .A(out_b[5]), .Y(n390) );
  NOR2X1 U436 ( .A(n431), .B(n432), .Y(n430) );
  NOR2X1 U437 ( .A(n343), .B(n344), .Y(n342) );
  CLKINVX1 U438 ( .A(out_b[6]), .Y(n346) );
  NOR2X1 U439 ( .A(n288), .B(n289), .Y(n286) );
  CLKINVX1 U440 ( .A(out_b[7]), .Y(n292) );
  NAND2X1 U441 ( .A(out_psw[0]), .B(n222), .Y(n624) );
  INVX1 U442 ( .A(ie[0]), .Y(n644) );
  CLKINVX1 U443 ( .A(out_psw[6]), .Y(n345) );
  CLKINVX1 U444 ( .A(out_psw[7]), .Y(n290) );
  CLKBUFX3 U445 ( .A(wr_sfr), .Y(n259) );
  NAND2X1 U446 ( .A(n234), .B(n282), .Y(n320) );
  INVX1 U447 ( .A(n652), .Y(n651) );
  NAND2X1 U448 ( .A(n647), .B(n648), .Y(disint) );
  CLKINVX1 U449 ( .A(reti), .Y(n648) );
  NAND2X1 U450 ( .A(n649), .B(n315), .Y(n647) );
  NOR2X1 U451 ( .A(n227), .B(n650), .Y(n649) );
  NOR2X1 U452 ( .A(n513), .B(n282), .Y(n510) );
  NOR2X1 U453 ( .A(n514), .B(n515), .Y(n513) );
  AOI21X1 U454 ( .A0(n516), .A1(n517), .B0(n287), .Y(n515) );
  NAND3X6 U455 ( .A(n584), .B(n586), .C(n585), .Y(out_sfr_a[0]) );
  NOR2X1 U456 ( .A(n250), .B(n644), .Y(n643) );
  NOR3X2 U457 ( .A(n637), .B(n636), .C(n635), .Y(n616) );
  NOR2X1 U458 ( .A(n190), .B(n525), .Y(n522) );
  NOR2X1 U459 ( .A(n295), .B(n524), .Y(n523) );
  AOI21X1 U460 ( .A0(n396), .A1(n397), .B0(n235), .Y(n378) );
  NOR2X1 U461 ( .A(n402), .B(n403), .Y(n396) );
  NOR2X1 U462 ( .A(n398), .B(n399), .Y(n397) );
  NOR2X1 U463 ( .A(n313), .B(n405), .Y(n402) );
  AOI21X1 U464 ( .A0(n352), .A1(n353), .B0(n235), .Y(n334) );
  NOR2X1 U465 ( .A(n358), .B(n359), .Y(n352) );
  NOR2X1 U466 ( .A(n354), .B(n355), .Y(n353) );
  NOR2X1 U467 ( .A(n313), .B(n361), .Y(n358) );
  AOI21X1 U468 ( .A0(n440), .A1(n441), .B0(n235), .Y(n422) );
  NOR2X1 U469 ( .A(n446), .B(n447), .Y(n440) );
  NOR2X1 U470 ( .A(n442), .B(n443), .Y(n441) );
  NOR2X1 U471 ( .A(n313), .B(n449), .Y(n446) );
  AOI21X1 U472 ( .A0(n300), .A1(n301), .B0(n235), .Y(n276) );
  NOR2X1 U473 ( .A(n309), .B(n310), .Y(n300) );
  NOR2X1 U474 ( .A(n303), .B(n304), .Y(n301) );
  NOR2X1 U475 ( .A(n313), .B(n314), .Y(n309) );
  NOR2X4 U476 ( .A(n368), .B(n369), .Y(n367) );
  NOR4X2 U477 ( .A(n377), .B(n378), .C(n379), .D(n380), .Y(n366) );
  NAND3X2 U478 ( .A(n374), .B(n375), .C(n376), .Y(n368) );
  NOR2X1 U479 ( .A(n383), .B(n384), .Y(n382) );
  AOI21X1 U480 ( .A0(n385), .A1(n386), .B0(n287), .Y(n384) );
  NOR2X1 U481 ( .A(n338), .B(n282), .Y(n335) );
  NOR2X1 U482 ( .A(n339), .B(n340), .Y(n338) );
  AOI21X1 U483 ( .A0(n341), .A1(n342), .B0(n187), .Y(n340) );
  NOR2X1 U484 ( .A(n426), .B(n282), .Y(n423) );
  NOR2X1 U485 ( .A(n427), .B(n428), .Y(n426) );
  NOR2X1 U486 ( .A(n298), .B(n439), .Y(n427) );
  AOI21X1 U487 ( .A0(n430), .A1(n429), .B0(n287), .Y(n428) );
  NOR2X1 U488 ( .A(n281), .B(n282), .Y(n277) );
  NOR2X1 U489 ( .A(n283), .B(n284), .Y(n281) );
  AOI21X1 U490 ( .A0(n285), .A1(n286), .B0(n187), .Y(n284) );
  NOR2X1 U491 ( .A(n470), .B(n282), .Y(n467) );
  NOR2X1 U492 ( .A(n471), .B(n472), .Y(n470) );
  AOI21X1 U493 ( .A0(n473), .A1(n474), .B0(n287), .Y(n472) );
  NOR2X1 U494 ( .A(n190), .B(n350), .Y(n347) );
  NOR2X1 U495 ( .A(n295), .B(n349), .Y(n348) );
  CLKINVX1 U496 ( .A(p3[6]), .Y(n350) );
  NOR2X1 U497 ( .A(n190), .B(n297), .Y(n293) );
  NOR2X1 U498 ( .A(n295), .B(n296), .Y(n294) );
  CLKINVX1 U499 ( .A(p3[7]), .Y(n297) );
  NOR2X1 U500 ( .A(n190), .B(n482), .Y(n479) );
  NOR2X1 U501 ( .A(n295), .B(n481), .Y(n480) );
  CLKINVX1 U502 ( .A(p3[3]), .Y(n482) );
  NOR2X1 U503 ( .A(n190), .B(n438), .Y(n435) );
  NOR2X1 U504 ( .A(n295), .B(n437), .Y(n436) );
  CLKINVX1 U505 ( .A(p3[4]), .Y(n438) );
  NOR2X1 U506 ( .A(n190), .B(n394), .Y(n391) );
  NOR2X1 U507 ( .A(n295), .B(n393), .Y(n392) );
  CLKINVX1 U508 ( .A(p3[5]), .Y(n394) );
  CLKINVX1 U509 ( .A(n259), .Y(n650) );
  NOR3BX1 U510 ( .AN(isrc_cur[2]), .B(isrc_cur[1]), .C(isrc_cur[0]), .Y(
        rst_tf1) );
  NOR3BX1 U511 ( .AN(isrc_cur[1]), .B(isrc_cur[2]), .C(isrc_cur[0]), .Y(
        rst_tf0) );
  NOR3BX1 U512 ( .AN(isrc_cur[1]), .B(n2), .C(isrc_cur[2]), .Y(rst_ie1) );
  CLKINVX1 U513 ( .A(isrc_cur[0]), .Y(n2) );
  NOR2X1 U514 ( .A(n214), .B(n613), .Y(n612) );
  NOR2X1 U515 ( .A(n614), .B(n282), .Y(n610) );
  NOR2X1 U516 ( .A(n615), .B(n244), .Y(n614) );
  CLKINVX1 U517 ( .A(th0[2]), .Y(n536) );
  CLKINVX1 U518 ( .A(th1[2]), .Y(n535) );
  CLKINVX1 U519 ( .A(tcon[2]), .Y(n531) );
  CLKINVX1 U520 ( .A(th0[0]), .Y(n593) );
  OAI22X1 U521 ( .A0(n282), .A1(n539), .B0(n320), .B1(n540), .Y(n537) );
  CLKINVX3 U522 ( .A(ie[2]), .Y(n540) );
  INVX1 U523 ( .A(n191), .Y(n594) );
  NAND2X1 U524 ( .A(out_dptr_r[10]), .B(n242), .Y(n502) );
  AOI21X1 U525 ( .A0(p0[2]), .A1(n267), .B0(n503), .Y(n501) );
  OAI22X1 U526 ( .A0(n282), .A1(n582), .B0(n320), .B1(n583), .Y(n579) );
  CLKINVX4 U527 ( .A(th1[1]), .Y(n577) );
  NOR2X1 U528 ( .A(n178), .B(n520), .Y(n519) );
  NOR2X1 U529 ( .A(n249), .B(n521), .Y(n518) );
  CLKINVX1 U530 ( .A(out_psw[2]), .Y(n520) );
  CLKINVX1 U531 ( .A(tcon[4]), .Y(n444) );
  NOR2X1 U532 ( .A(n279), .B(n337), .Y(n336) );
  MXI2X1 U533 ( .S0(n188), .B(out_acc_r[6]), .A(p2[6]), .Y(n337) );
  NOR2X1 U534 ( .A(n279), .B(n425), .Y(n424) );
  MXI2X1 U535 ( .S0(n651), .B(out_acc_r[4]), .A(p2[4]), .Y(n425) );
  NOR2X1 U536 ( .A(n214), .B(n280), .Y(n278) );
  MXI2X1 U537 ( .S0(n188), .B(out_acc_r[7]), .A(p2[7]), .Y(n280) );
  MXI2X1 U538 ( .S0(n234), .B(ip[3]), .A(scon[3]), .Y(n496) );
  MXI2X1 U539 ( .S0(n234), .B(ip[4]), .A(scon[4]), .Y(n452) );
  MXI2X1 U540 ( .S0(n234), .B(ip[5]), .A(scon[5]), .Y(n408) );
  NOR2X1 U541 ( .A(n445), .B(n170), .Y(n442) );
  CLKINVX1 U542 ( .A(tmod[4]), .Y(n445) );
  NOR2X1 U543 ( .A(n279), .B(n512), .Y(n511) );
  NOR2X1 U544 ( .A(n311), .B(n404), .Y(n403) );
  CLKINVX1 U545 ( .A(th1[5]), .Y(n404) );
  NOR2X1 U546 ( .A(n311), .B(n448), .Y(n447) );
  CLKINVX1 U547 ( .A(th1[4]), .Y(n448) );
  NOR2X1 U548 ( .A(n311), .B(n360), .Y(n359) );
  CLKINVX1 U549 ( .A(th1[6]), .Y(n360) );
  NOR2X1 U550 ( .A(n311), .B(n312), .Y(n310) );
  CLKINVX1 U551 ( .A(th1[7]), .Y(n312) );
  NOR2X1 U552 ( .A(n279), .B(n469), .Y(n468) );
  MXI2X1 U553 ( .S0(n188), .B(n199), .A(p2[3]), .Y(n469) );
  NOR2X1 U554 ( .A(n269), .B(n504), .Y(n503) );
  CLKINVX1 U555 ( .A(pcon[2]), .Y(n504) );
  NOR2X1 U556 ( .A(n269), .B(n461), .Y(n460) );
  CLKINVX1 U557 ( .A(pcon[3]), .Y(n461) );
  NOR2X1 U558 ( .A(n269), .B(n270), .Y(n268) );
  CLKINVX1 U559 ( .A(pcon[7]), .Y(n270) );
  NOR2X1 U560 ( .A(n269), .B(n417), .Y(n416) );
  CLKINVX1 U561 ( .A(pcon[4]), .Y(n417) );
  NOR2X1 U562 ( .A(n269), .B(n373), .Y(n372) );
  CLKINVX1 U563 ( .A(pcon[5]), .Y(n373) );
  NOR2X1 U564 ( .A(n269), .B(n329), .Y(n328) );
  CLKINVX1 U565 ( .A(pcon[6]), .Y(n329) );
  NAND2X1 U566 ( .A(tl1[4]), .B(n238), .Y(n419) );
  NAND2X1 U567 ( .A(out_sp_r[3]), .B(n232), .Y(n464) );
  NAND2X1 U568 ( .A(out_sp_r[5]), .B(n232), .Y(n376) );
  NAND2X1 U569 ( .A(out_sp_r[6]), .B(n232), .Y(n332) );
  NAND2X1 U570 ( .A(out_sp_r[2]), .B(n232), .Y(n507) );
  NAND2X1 U571 ( .A(out_sp_r[4]), .B(n232), .Y(n420) );
  NAND2X1 U572 ( .A(out_sp_r[7]), .B(n232), .Y(n273) );
  NAND2X1 U573 ( .A(tl1[3]), .B(n238), .Y(n463) );
  NAND2X1 U574 ( .A(tl1[5]), .B(n238), .Y(n375) );
  NAND2X1 U575 ( .A(tl1[6]), .B(n238), .Y(n331) );
  NAND2X1 U576 ( .A(tl1[2]), .B(n238), .Y(n506) );
  NAND2X1 U577 ( .A(tl1[7]), .B(n238), .Y(n272) );
  NAND2X1 U578 ( .A(out_dptr_r[5]), .B(n318), .Y(n407) );
  OAI22X1 U579 ( .A0(n282), .A1(n408), .B0(n320), .B1(n409), .Y(n406) );
  CLKINVX1 U580 ( .A(ie[5]), .Y(n409) );
  OAI2BB1X1 U581 ( .A0N(n315), .A1N(n362), .B0(n363), .Y(n333) );
  NAND2X1 U582 ( .A(out_dptr_r[6]), .B(n318), .Y(n363) );
  OAI22X1 U583 ( .A0(n282), .A1(n364), .B0(n320), .B1(n365), .Y(n362) );
  CLKINVX1 U584 ( .A(ie[6]), .Y(n365) );
  NAND2X1 U585 ( .A(out_dptr_r[4]), .B(n318), .Y(n451) );
  OAI22X1 U586 ( .A0(n282), .A1(n452), .B0(n320), .B1(n453), .Y(n450) );
  CLKINVX1 U587 ( .A(ie[4]), .Y(n453) );
  OAI2BB1X1 U588 ( .A0N(n315), .A1N(n316), .B0(n317), .Y(n275) );
  NAND2X1 U589 ( .A(out_dptr_r[7]), .B(n318), .Y(n317) );
  OAI22X1 U590 ( .A0(n282), .A1(n319), .B0(n320), .B1(n321), .Y(n316) );
  CLKINVX3 U591 ( .A(ie[7]), .Y(n321) );
  CLKINVX1 U592 ( .A(tmod[3]), .Y(n489) );
  CLKINVX1 U593 ( .A(sbuf[0]), .Y(n630) );
  NOR2X1 U594 ( .A(n249), .B(n292), .Y(n288) );
  NOR2X1 U595 ( .A(n247), .B(n290), .Y(n289) );
  NAND2X1 U596 ( .A(out_dptr_r[11]), .B(n242), .Y(n459) );
  AOI21X1 U597 ( .A0(p0[3]), .A1(n267), .B0(n460), .Y(n458) );
  NAND2X1 U598 ( .A(out_dptr_r[13]), .B(n242), .Y(n371) );
  AOI21X1 U599 ( .A0(p0[5]), .A1(n267), .B0(n372), .Y(n370) );
  NAND2X1 U600 ( .A(out_dptr_r[12]), .B(n242), .Y(n415) );
  AOI21X1 U601 ( .A0(p0[4]), .A1(n267), .B0(n416), .Y(n414) );
  NAND2X1 U602 ( .A(out_dptr_r[14]), .B(n242), .Y(n327) );
  AOI21X1 U603 ( .A0(p0[6]), .A1(n267), .B0(n328), .Y(n326) );
  NAND2X1 U604 ( .A(out_dptr_r[15]), .B(n242), .Y(n266) );
  AOI21X1 U605 ( .A0(p0[7]), .A1(n267), .B0(n268), .Y(n265) );
  NAND2X1 U606 ( .A(out_dptr_r[3]), .B(n318), .Y(n495) );
  OAI22X1 U607 ( .A0(n282), .A1(n496), .B0(n320), .B1(n497), .Y(n494) );
  CLKINVX3 U608 ( .A(ie[3]), .Y(n497) );
  NOR2X1 U609 ( .A(n313), .B(n493), .Y(n490) );
  CLKINVX1 U610 ( .A(th0[3]), .Y(n493) );
  NOR2X1 U611 ( .A(n311), .B(n492), .Y(n491) );
  CLKINVX1 U612 ( .A(th1[3]), .Y(n492) );
  NOR2X1 U613 ( .A(n249), .B(n346), .Y(n343) );
  NOR2X1 U614 ( .A(n247), .B(n345), .Y(n344) );
  NOR2X1 U615 ( .A(n178), .B(n433), .Y(n432) );
  NOR2X1 U616 ( .A(n249), .B(n434), .Y(n431) );
  INVX1 U617 ( .A(out_psw[4]), .Y(n433) );
  NOR2X1 U618 ( .A(n249), .B(n478), .Y(n475) );
  NOR2X1 U619 ( .A(n178), .B(n477), .Y(n476) );
  NOR2X1 U620 ( .A(n249), .B(n390), .Y(n387) );
  NOR2X1 U621 ( .A(n178), .B(n389), .Y(n388) );
  INVX1 U622 ( .A(p2[0]), .Y(n639) );
  CLKINVX1 U623 ( .A(th0[4]), .Y(n449) );
  CLKINVX1 U624 ( .A(th0[5]), .Y(n405) );
  CLKINVX1 U625 ( .A(th0[6]), .Y(n361) );
  CLKINVX1 U626 ( .A(th0[7]), .Y(n314) );
  CLKINVX4 U627 ( .A(th0[1]), .Y(n578) );
  INVX1 U628 ( .A(out_psw[3]), .Y(n477) );
  CLKINVX1 U629 ( .A(out_b[2]), .Y(n521) );
  CLKINVX1 U630 ( .A(out_b[4]), .Y(n434) );
  CLKINVX1 U631 ( .A(tmod[2]), .Y(n532) );
  CLKINVX1 U632 ( .A(out_psw[5]), .Y(n389) );
  CLKINVX1 U633 ( .A(sbuf[4]), .Y(n439) );
  CLKINVX1 U634 ( .A(tcon[3]), .Y(n488) );
  CLKINVX2 U635 ( .A(sbuf[1]), .Y(n568) );
  CLKINVX1 U636 ( .A(sbuf[2]), .Y(n526) );
  CLKINVX1 U637 ( .A(sbuf[3]), .Y(n483) );
  CLKINVX1 U638 ( .A(sbuf[5]), .Y(n395) );
  CLKINVX1 U639 ( .A(sbuf[6]), .Y(n351) );
  CLKINVX1 U640 ( .A(sbuf[7]), .Y(n299) );
  NOR3BX1 U641 ( .AN(isrc_cur[0]), .B(isrc_cur[2]), .C(isrc_cur[1]), .Y(
        rst_ie0) );
  NAND2X1 U642 ( .A(n234), .B(n282), .Y(n250) );
  INVX1 U643 ( .A(n187), .Y(n611) );
  MXI2X1 U644 ( .S0(n188), .B(n192), .A(p2[1]), .Y(n554) );
  NAND2X1 U645 ( .A(n201), .B(n169), .Y(n613) );
  NOR2X1 U646 ( .A(n298), .B(n299), .Y(n283) );
  NOR2X1 U647 ( .A(n395), .B(n298), .Y(n383) );
  NOR2X1 U648 ( .A(n298), .B(n483), .Y(n471) );
  NOR2X1 U649 ( .A(n298), .B(n351), .Y(n339) );
  NOR2X1 U650 ( .A(n298), .B(n526), .Y(n514) );
  NOR2X1 U651 ( .A(n298), .B(n568), .Y(n556) );
  MXI2X1 U652 ( .S0(n234), .B(ip[7]), .A(scon[7]), .Y(n319) );
  MXI2X1 U653 ( .S0(n234), .B(ip[1]), .A(scon[1]), .Y(n582) );
  MXI2X1 U654 ( .S0(n234), .B(ip[6]), .A(scon[6]), .Y(n364) );
  MXI2X1 U655 ( .S0(n233), .B(ip[2]), .A(scon[2]), .Y(n539) );
  MXI2X1 U656 ( .S0(n651), .B(out_acc_r[2]), .A(p2[2]), .Y(n512) );
  AOI21X1 U657 ( .A0(n484), .A1(n485), .B0(n235), .Y(n466) );
  NOR2X1 U658 ( .A(n486), .B(n487), .Y(n485) );
  NOR2X1 U659 ( .A(n490), .B(n491), .Y(n484) );
  NAND2X1 U660 ( .A(tl0[7]), .B(n168), .Y(n271) );
  NAND2X1 U661 ( .A(tl0[6]), .B(n274), .Y(n330) );
  NAND2X1 U662 ( .A(tl0[5]), .B(n274), .Y(n374) );
  NAND2X1 U663 ( .A(tl0[3]), .B(n274), .Y(n462) );
  NAND2X1 U664 ( .A(tl0[4]), .B(n274), .Y(n418) );
  NAND2X1 U665 ( .A(tl0[2]), .B(n274), .Y(n505) );
  NAND2X1 U666 ( .A(tl0[1]), .B(n274), .Y(n547) );
  NOR2X2 U667 ( .A(n249), .B(n563), .Y(n560) );
  NOR2X2 U668 ( .A(n575), .B(n576), .Y(n569) );
  NOR2X1 U669 ( .A(n189), .B(n308), .Y(n303) );
  NOR2X1 U670 ( .A(n170), .B(n357), .Y(n354) );
  NOR2X1 U671 ( .A(n170), .B(n401), .Y(n398) );
  NOR2X1 U672 ( .A(n170), .B(n489), .Y(n486) );
  NOR2X1 U673 ( .A(n170), .B(n532), .Y(n529) );
  NAND2X2 U674 ( .A(n616), .B(n617), .Y(n101) );
  NOR2X1 U675 ( .A(n245), .B(n531), .Y(n530) );
  NOR2X4 U676 ( .A(n625), .B(n626), .Y(n620) );
  NOR4X4 U677 ( .A(n550), .B(n551), .C(n552), .D(n553), .Y(n541) );
  NAND2X2 U678 ( .A(out_sp_r[1]), .B(n232), .Y(n549) );
  NOR2X1 U679 ( .A(n245), .B(n306), .Y(n304) );
  NOR2X1 U680 ( .A(n245), .B(n356), .Y(n355) );
  NOR2X1 U681 ( .A(n245), .B(n400), .Y(n399) );
  NOR2X1 U682 ( .A(n245), .B(n488), .Y(n487) );
  NOR2X1 U683 ( .A(n245), .B(n444), .Y(n443) );
  AOI21X4 U684 ( .A0(n569), .A1(n570), .B0(n235), .Y(n551) );
  AOI21X4 U685 ( .A0(n610), .A1(n611), .B0(n612), .Y(n134) );
  AOI21X4 U686 ( .A0(n620), .A1(n621), .B0(n180), .Y(n619) );
endmodule


module one_shot_2 ( rst_p, clk, d, q );
  input rst_p, clk, d;
  output q;
  wire   n1, n2, n3;

  NOR2BX1 U6 ( .AN(d), .B(n2), .Y(q) );
  CLKINVX1 U7 ( .A(d), .Y(n3) );
  INVX1 U8 ( .A(rst_p), .Y(n1) );
  DFFSX1 d_del_reg ( .D(n3), .CK(clk), .SN(n1), .QN(n2) );
endmodule


module one_shot_1 ( rst_p, clk, d, q );
  input rst_p, clk, d;
  output q;
  wire   n1, n2, n3;

  CLKINVX1 U6 ( .A(d), .Y(n3) );
  NOR2BX1 U7 ( .AN(d), .B(n2), .Y(q) );
  INVX1 U8 ( .A(rst_p), .Y(n1) );
  DFFSX1 d_del_reg ( .D(n3), .CK(clk), .SN(n1), .QN(n2) );
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
  INVX1 U26 ( .A(tf_b), .Y(n6) );
  NAND3BX1 U27 ( .AN(rst_p), .B(n2), .C(n3), .Y(N25) );
  INVX1 U28 ( .A(reti), .Y(n2) );
  NAND2BX1 U29 ( .AN(rst_p), .B(n8), .Y(N18) );
  NOR2X1 U30 ( .A(n9), .B(n8), .Y(N15) );
  NOR2X1 U31 ( .A(n10), .B(n8), .Y(N14) );
  NOR2X1 U32 ( .A(n110), .B(n8), .Y(N13) );
  NOR2X1 U33 ( .A(n120), .B(n8), .Y(N12) );
  NOR2X1 U34 ( .A(n130), .B(n8), .Y(N11) );
  NOR2BX1 U35 ( .AN(tf_b), .B(n3), .Y(N23) );
  NOR2BX1 U36 ( .AN(ie_b), .B(n3), .Y(N22) );
  NOR2BX1 U37 ( .AN(tf_a), .B(n3), .Y(N21) );
  NOR2BX1 U38 ( .AN(ie_a), .B(n3), .Y(N20) );
  INVX1 U39 ( .A(tf_a), .Y(n7) );
  TLATX1 int_reg_3_ ( .D(N14), .G(N18), .Q(int[3]) );
  TLATX1 int_reg_2_ ( .D(N13), .G(N18), .Q(int[2]) );
  TLATX1 int_reg_1_ ( .D(N12), .G(N18), .Q(int[1]) );
  TLATX1 int_reg_0_ ( .D(N11), .G(N18), .Q(int[0]) );
  TLATX1 int_reg_4_ ( .D(N15), .G(N18), .Q(int[4]) );
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

  XNOR2X1 U9 ( .A(it), .B(ex_int), .Y(lint) );
  AO22X1 U10 ( .A0(tmp), .A1(n2), .B0(it), .B1(n3), .Y(n6) );
  CLKINVX1 U11 ( .A(ex_int), .Y(n3) );
  NOR2BX1 U12 ( .AN(tmp), .B(tmp1), .Y(oie) );
  INVX1 U13 ( .A(it), .Y(n2) );
  AO22X1 U14 ( .A0(tmp), .A1(it), .B0(tmp1), .B1(n2), .Y(n5) );
  INVX1 U15 ( .A(rst_p), .Y(n4) );
  DFFRX1 tmp1_reg ( .D(n5), .CK(clk), .RN(n4), .Q(tmp1) );
  DFFRX1 tmp_reg ( .D(n6), .CK(clk), .RN(n4), .Q(tmp) );
endmodule


module ex_int_smpl_0 ( clk, ex_int, it, rst_p, lint, oie );
  input clk, ex_int, it, rst_p;
  output lint, oie;
  wire   tmp, tmp1, n2, n3, n4, n5, n6;

  XNOR2X1 U9 ( .A(it), .B(ex_int), .Y(lint) );
  AO22X1 U10 ( .A0(tmp), .A1(n2), .B0(it), .B1(n3), .Y(n6) );
  CLKINVX1 U11 ( .A(ex_int), .Y(n3) );
  NOR2BX1 U12 ( .AN(tmp), .B(tmp1), .Y(oie) );
  INVX1 U13 ( .A(it), .Y(n2) );
  AO22X1 U14 ( .A0(tmp), .A1(it), .B0(tmp1), .B1(n2), .Y(n5) );
  INVX1 U15 ( .A(rst_p), .Y(n4) );
  DFFRX1 tmp1_reg ( .D(n5), .CK(clk), .RN(n4), .Q(tmp1) );
  DFFRX1 tmp_reg ( .D(n6), .CK(clk), .RN(n4), .Q(tmp) );
endmodule


module mux2t1_1_1 ( a, b, sel, c );
  input a, b, sel;
  output c;
  wire   n2;

  AO22X1 U6 ( .A0(sel), .A1(b), .B0(a), .B1(n2), .Y(c) );
  INVX1 U7 ( .A(sel), .Y(n2) );
endmodule


module mux2t1_1_0 ( a, b, sel, c );
  input a, b, sel;
  output c;
  wire   n2;

  AO22X1 U6 ( .A0(sel), .A1(b), .B0(a), .B1(n2), .Y(c) );
  INVX1 U7 ( .A(sel), .Y(n2) );
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
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n27, n28, n29, n30, n31,
         n32, n33, n35, n36, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n510, n52, n53, n55, n56, n60, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84;
  wire   [1:0] cur_lev;

  one_shot_0 one_shot_reti ( .rst_p(rst_p), .clk(clk), .d(reti), .q(reti1) );
  NOR2BX1 U86 ( .AN(N11), .B(n79), .Y(isrc_cur[0]) );
  CLKINVX1 U87 ( .A(n35), .Y(n33) );
  CLKINVX1 U88 ( .A(n3), .Y(n4) );
  CLKINVX1 U89 ( .A(n100), .Y(n24) );
  CLKINVX1 U90 ( .A(n15), .Y(n17) );
  CLKINVX1 U91 ( .A(n12), .Y(n16) );
  NAND2BX1 U92 ( .AN(n24), .B(n13), .Y(n35) );
  NAND2BX1 U93 ( .AN(n83), .B(n35), .Y(n3) );
  NAND2BX1 U94 ( .AN(n84), .B(n42), .Y(n100) );
  OAI33X1 U95 ( .A0(n100), .A1(n110), .A2(n12), .B0(n13), .B1(n14), .B2(n15), 
        .Y(n2) );
  OAI33X1 U96 ( .A0(n100), .A1(n110), .A2(n16), .B0(n13), .B1(n14), .B2(n17), 
        .Y(n5) );
  OAI221X1 U97 ( .A0(n18), .A1(n13), .B0(n100), .B1(n19), .C0(n20), .Y(n6) );
  AOI221X1 U98 ( .A0(n17), .A1(n27), .B0(n28), .B1(n29), .C0(n14), .Y(n18) );
  OAI211X1 U99 ( .A0(n21), .A1(n22), .B0(n23), .C0(n24), .Y(n20) );
  CLKINVX1 U100 ( .A(n31), .Y(n28) );
  CLKINVX1 U101 ( .A(n46), .Y(n42) );
  CLKINVX1 U102 ( .A(n13), .Y(n36) );
  AO22X1 U103 ( .A0(n83), .A1(n84), .B0(n40), .B1(n41), .Y(n73) );
  CLKINVX1 U104 ( .A(n84), .Y(n41) );
  OAI221X1 U105 ( .A0(n42), .A1(n33), .B0(n83), .B1(n35), .C0(n43), .Y(n40) );
  CLKINVX1 U106 ( .A(n7), .Y(n8) );
  OR2X1 U107 ( .A(n33), .B(N51), .Y(n43) );
  NAND2X1 U108 ( .A(n23), .B(n25), .Y(n12) );
  NAND2X1 U109 ( .A(n29), .B(n31), .Y(n15) );
  CLKINVX1 U110 ( .A(n19), .Y(n110) );
  DFFRX1 int_dept_reg_0_ ( .D(n73), .CK(clk), .RN(n62), .Q(N51), .QN(n83) );
  CLKINVX1 U111 ( .A(n30), .Y(n14) );
  CLKINVX1 U112 ( .A(n25), .Y(n22) );
  OAI21X1 U113 ( .A0(en_int), .A1(n47), .B0(n48), .Y(n46) );
  OAI31X1 U114 ( .A0(n49), .A1(cur_lev[1]), .A2(cur_lev[0]), .B0(int_proc), 
        .Y(n47) );
  INVX1 U115 ( .A(ie7), .Y(n49) );
  NAND3BX1 U116 ( .AN(n44), .B(n45), .C(n46), .Y(n13) );
  NAND3BX1 U117 ( .AN(n84), .B(n79), .C(ie7), .Y(n44) );
  NAND2BX1 U118 ( .AN(N51), .B(n35), .Y(n7) );
  NOR2BX1 U119 ( .AN(int_lev1), .B(n8), .Y(n76) );
  NOR2BX1 U120 ( .AN(int_lev), .B(n4), .Y(n78) );
  CLKINVX1 U121 ( .A(n50), .Y(en_int) );
  OAI211X1 U122 ( .A0(n48), .A1(n79), .B0(ie7), .C0(n510), .Y(n50) );
  AOI211X1 U123 ( .A0(n52), .A1(n79), .B0(rst_p), .C0(disint), .Y(n510) );
  CLKINVX1 U124 ( .A(n45), .Y(n52) );
  OAI222X1 U125 ( .A0(n36), .A1(n81), .B0(N51), .B1(n81), .C0(n83), .C1(n100), 
        .Y(n77) );
  OAI222X1 U126 ( .A0(n36), .A1(n80), .B0(n83), .B1(n80), .C0(N51), .C1(n100), 
        .Y(n75) );
  AO22X1 U127 ( .A0(n2), .A1(N51), .B0(isrc), .B1(n3), .Y(n69) );
  NAND2BX1 U128 ( .AN(n32), .B(n33), .Y(n63) );
  AOI31X1 U129 ( .A0(n84), .A1(n82), .A2(N51), .B0(n79), .Y(n32) );
  AO22X1 U130 ( .A0(isrc4), .A1(n7), .B0(n8), .B1(n6), .Y(n64) );
  AO22X1 U131 ( .A0(isrc3), .A1(n7), .B0(n8), .B1(n5), .Y(n65) );
  AO22X1 U132 ( .A0(isrc1), .A1(n3), .B0(n4), .B1(n6), .Y(n67) );
  AO22X1 U133 ( .A0(isrc0), .A1(n3), .B0(n4), .B1(n5), .Y(n68) );
  AO22X1 U134 ( .A0(n2), .A1(n83), .B0(isrc2), .B1(n7), .Y(n66) );
  AO21X1 U135 ( .A0(int_vec[0]), .A1(n84), .B0(n6), .Y(n70) );
  AO21X1 U136 ( .A0(int_vec[1]), .A1(n84), .B0(n5), .Y(n71) );
  AO21X1 U137 ( .A0(int_vec[2]), .A1(n84), .B0(n2), .Y(n72) );
  OAI31X1 U138 ( .A0(n35), .A1(n84), .A2(n82), .B0(n39), .Y(n74) );
  AOI22X1 U139 ( .A0(N99), .A1(n84), .B0(N104), .B1(n24), .Y(n39) );
  XNOR2X1 U140 ( .A(N51), .B(n82), .Y(N104) );
  XNOR2X1 U141 ( .A(int_dept_1_), .B(N51), .Y(N99) );
  CLKBUFX3 U142 ( .A(reti1), .Y(n84) );
  NAND3BX1 U143 ( .AN(ip[2]), .B(ie[2]), .C(int[2]), .Y(n31) );
  NAND3X1 U144 ( .A(ie[2]), .B(int[2]), .C(ip[2]), .Y(n25) );
  NAND3BX1 U145 ( .AN(ip[1]), .B(ie[1]), .C(int[1]), .Y(n29) );
  NAND3X1 U146 ( .A(ie[1]), .B(int[1]), .C(ip[1]), .Y(n23) );
  NAND3BX1 U147 ( .AN(ip[0]), .B(ie[0]), .C(int[0]), .Y(n30) );
  NAND2X1 U148 ( .A(int[4]), .B(ie[4]), .Y(n55) );
  NAND3BX1 U149 ( .AN(ip[3]), .B(ie[3]), .C(int[3]), .Y(n27) );
  NAND3X1 U150 ( .A(ie[0]), .B(int[0]), .C(ip[0]), .Y(n19) );
  NAND2BX1 U151 ( .AN(n53), .B(n17), .Y(n45) );
  OAI211X1 U152 ( .A0(ip[4]), .A1(n55), .B0(n27), .C0(n30), .Y(n53) );
  NAND3BX1 U153 ( .AN(n110), .B(n56), .C(n16), .Y(n48) );
  AOI32X1 U154 ( .A0(int[3]), .A1(ie[3]), .A2(ip[3]), .B0(ip[4]), .B1(n60), 
        .Y(n56) );
  CLKINVX1 U155 ( .A(n55), .Y(n60) );
  NOR2BX1 U156 ( .AN(N10), .B(n79), .Y(isrc_cur[1]) );
  NOR2BX1 U157 ( .AN(N9), .B(n79), .Y(isrc_cur[2]) );
  NAND3X1 U158 ( .A(int[3]), .B(ie[3]), .C(ip[3]), .Y(n21) );
  INVX1 U159 ( .A(rst_p), .Y(n62) );
  DFFRX1 int_lev_reg ( .D(n75), .CK(clk), .RN(n62), .Q(int_lev2), .QN(n80) );
  DFFRX1 int_lev_reg0 ( .D(n77), .CK(clk), .RN(n62), .Q(int_lev0), .QN(n81) );
  DFFRX1 int_proc_reg ( .D(n63), .CK(clk), .RN(n62), .Q(int_proc), .QN(n79) );
  DFFRX1 int_lev_reg1 ( .D(n76), .CK(clk), .RN(n62), .Q(int_lev1) );
  DFFRX1 int_lev_reg2 ( .D(n78), .CK(clk), .RN(n62), .Q(int_lev) );
  DFFRX1 int_dept_reg_1_ ( .D(n74), .CK(clk), .RN(n62), .Q(int_dept_1_), .QN(
        n82) );
  DFFRX1 isrc_reg ( .D(n64), .CK(clk), .RN(n62), .Q(isrc4) );
  DFFRX1 isrc_reg0 ( .D(n65), .CK(clk), .RN(n62), .Q(isrc3) );
  DFFRX1 isrc_reg1 ( .D(n66), .CK(clk), .RN(n62), .Q(isrc2) );
  DFFRX1 isrc_reg2 ( .D(n67), .CK(clk), .RN(n62), .Q(isrc1) );
  DFFRX1 isrc_reg3 ( .D(n68), .CK(clk), .RN(n62), .Q(isrc0) );
  DFFRX1 isrc_reg4 ( .D(n69), .CK(clk), .RN(n62), .Q(isrc) );
  DFFRX1 int_vec_reg_0_ ( .D(n70), .CK(clk), .RN(n62), .Q(int_vec[0]) );
  DFFRX1 int_vec_reg_1_ ( .D(n71), .CK(clk), .RN(n62), .Q(int_vec[1]) );
  DFFRX1 int_vec_reg_2_ ( .D(n72), .CK(clk), .RN(n62), .Q(int_vec[2]) );
  priority_MUX_OP_2_1_5 U16 ( .D0_0(int_lev1), .D0_1(int_lev2), .D0_2(isrc2), 
        .D0_3(isrc3), .D0_4(isrc4), .D1_0(int_lev), .D1_1(int_lev0), .D1_2(
        isrc), .D1_3(isrc0), .D1_4(isrc1), .S0(n83), .Z_0(cur_lev[1]), .Z_1(
        cur_lev[0]), .Z_2(N9), .Z_3(N10), .Z_4(N11) );
endmodule


module priority_MUX_OP_2_1_5 ( D0_0, D0_1, D0_2, D0_3, D0_4, D1_0, D1_1, D1_2, 
        D1_3, D1_4, S0, Z_0, Z_1, Z_2, Z_3, Z_4 );
  input D0_0, D0_1, D0_2, D0_3, D0_4, D1_0, D1_1, D1_2, D1_3, D1_4, S0;
  output Z_0, Z_1, Z_2, Z_3, Z_4;


  CLKMX2X2 U6 ( .S0(S0), .B(D1_0), .A(D0_0), .Y(Z_0) );
  CLKMX2X2 U7 ( .S0(S0), .B(D1_3), .A(D0_3), .Y(Z_3) );
  CLKMX2X2 U8 ( .S0(S0), .B(D1_4), .A(D0_4), .Y(Z_4) );
  CLKMX2X2 U9 ( .S0(S0), .B(D1_2), .A(D0_2), .Y(Z_2) );
  CLKMX2X2 U10 ( .S0(S0), .B(D1_1), .A(D0_1), .Y(Z_1) );
endmodule


module one_shot_0 ( rst_p, clk, d, q );
  input rst_p, clk, d;
  output q;
  wire   n1, n2, n3;

  CLKINVX1 U6 ( .A(d), .Y(n3) );
  NOR2BX1 U7 ( .AN(d), .B(n2), .Y(q) );
  INVX1 U8 ( .A(rst_p), .Y(n1) );
  DFFSX1 d_del_reg ( .D(n3), .CK(clk), .SN(n1), .QN(n2) );
endmodule


module b ( clk, rst_p, in_b, in_dat, addr_b, wr, ld_b, out_b );
  input [7:0] in_b;
  input [7:0] in_dat;
  input [7:0] addr_b;
  output [7:0] out_b;
  input clk, rst_p, wr, ld_b;
  wire   n3, n4, n5, n6, n7, n8, n9, n10, n17, n18, n19, n20, n21, n22, n23,
         n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37,
         n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51,
         n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n66, n67, n68;

  INVX1 U27 ( .A(n6), .Y(n55) );
  INVX1 U28 ( .A(n40), .Y(n47) );
  INVX1 U29 ( .A(n38), .Y(n53) );
  INVX1 U30 ( .A(n48), .Y(n43) );
  INVX1 U31 ( .A(n7), .Y(n57) );
  INVX1 U32 ( .A(in_b[6]), .Y(n37) );
  INVX1 U33 ( .A(n8), .Y(n59) );
  INVX1 U34 ( .A(n9), .Y(n61) );
  OAI21X1 U35 ( .A0(n27), .A1(n49), .B0(n28), .Y(n19) );
  AOI22X1 U36 ( .A0(in_dat[0]), .A1(n4), .B0(in_b[0]), .B1(ld_b), .Y(n28) );
  NOR2X1 U37 ( .A(n53), .B(ld_b), .Y(n39) );
  NOR2X2 U38 ( .A(n43), .B(ld_b), .Y(n40) );
  NAND2X1 U39 ( .A(in_dat[6]), .B(n4), .Y(n38) );
  NAND2X1 U40 ( .A(in_dat[7]), .B(n4), .Y(n48) );
  NAND2BX1 U41 ( .AN(ld_b), .B(n54), .Y(n49) );
  CLKINVX1 U42 ( .A(n54), .Y(n4) );
  DFFRX1 out_b_reg_2_ ( .D(n21), .CK(clk), .RN(n18), .Q(out_b[2]), .QN(n35) );
  DFFRX1 out_b_reg_3_ ( .D(n22), .CK(clk), .RN(n18), .Q(out_b[3]), .QN(n34) );
  DFFRX1 out_b_reg_4_ ( .D(n23), .CK(clk), .RN(n18), .Q(out_b[4]), .QN(n33) );
  DFFRX1 out_b_reg_5_ ( .D(n24), .CK(clk), .RN(n18), .Q(out_b[5]), .QN(n32) );
  DFFRX1 out_b_reg_6_ ( .D(n25), .CK(clk), .RN(n18), .Q(out_b[6]), .QN(n31) );
  DFFRX1 out_b_reg_7_ ( .D(n26), .CK(clk), .RN(n18), .Q(out_b[7]), .QN(n30) );
  DFFRX1 out_b_reg_0_ ( .D(n19), .CK(clk), .RN(n18), .Q(out_b[0]), .QN(n27) );
  NAND3X1 U43 ( .A(n65), .B(n66), .C(wr), .Y(n54) );
  NOR2X1 U44 ( .A(n67), .B(n17), .Y(n66) );
  NOR2BX1 U45 ( .AN(n42), .B(n43), .Y(n41) );
  AOI22X1 U46 ( .A0(n39), .A1(n50), .B0(n51), .B1(n37), .Y(n25) );
  CLKINVX1 U47 ( .A(n52), .Y(n50) );
  NOR2X1 U48 ( .A(n52), .B(n53), .Y(n51) );
  NOR2X1 U49 ( .A(n49), .B(n31), .Y(n52) );
  OAI21X1 U50 ( .A0(n49), .A1(n32), .B0(n55), .Y(n24) );
  OAI2BB2X1 U51 ( .A0N(in_b[5]), .A1N(ld_b), .B0(n54), .B1(n56), .Y(n6) );
  INVX1 U52 ( .A(in_dat[5]), .Y(n56) );
  AOI21X1 U53 ( .A0(n44), .A1(n42), .B0(n45), .Y(n26) );
  NOR2X1 U54 ( .A(n46), .B(n43), .Y(n44) );
  NOR2X1 U55 ( .A(n46), .B(n47), .Y(n45) );
  NOR2X1 U56 ( .A(n49), .B(n30), .Y(n46) );
  INVX1 U57 ( .A(in_b[7]), .Y(n42) );
  OAI21X1 U58 ( .A0(n49), .A1(n33), .B0(n57), .Y(n23) );
  OAI2BB2X1 U59 ( .A0N(in_b[4]), .A1N(ld_b), .B0(n54), .B1(n58), .Y(n7) );
  INVX1 U60 ( .A(in_dat[4]), .Y(n58) );
  OAI21X1 U61 ( .A0(n49), .A1(n34), .B0(n59), .Y(n22) );
  OAI2BB2X1 U62 ( .A0N(in_b[3]), .A1N(ld_b), .B0(n54), .B1(n60), .Y(n8) );
  INVX1 U63 ( .A(in_dat[3]), .Y(n60) );
  OAI21X1 U64 ( .A0(n49), .A1(n35), .B0(n61), .Y(n21) );
  OAI2BB2X1 U65 ( .A0N(ld_b), .A1N(in_b[2]), .B0(n54), .B1(n62), .Y(n9) );
  INVX1 U66 ( .A(in_dat[2]), .Y(n62) );
  OAI21X1 U67 ( .A0(n49), .A1(n36), .B0(n63), .Y(n20) );
  INVX1 U68 ( .A(n10), .Y(n63) );
  OAI2BB2X1 U69 ( .A0N(in_b[1]), .A1N(ld_b), .B0(n54), .B1(n64), .Y(n10) );
  INVX1 U70 ( .A(in_dat[1]), .Y(n64) );
  INVX1 U71 ( .A(rst_p), .Y(n18) );
  NAND2X1 U72 ( .A(addr_b[4]), .B(n29), .Y(n68) );
  NOR3X1 U73 ( .A(n68), .B(addr_b[1]), .C(ld_b), .Y(n65) );
  INVX1 U74 ( .A(addr_b[0]), .Y(n29) );
  NAND3X1 U75 ( .A(addr_b[6]), .B(addr_b[7]), .C(addr_b[5]), .Y(n67) );
  AOI21X4 U76 ( .A0(n37), .A1(n38), .B0(n39), .Y(n5) );
  NOR2X8 U77 ( .A(n40), .B(n41), .Y(n3) );
  OR2X1 U78 ( .A(addr_b[2]), .B(addr_b[3]), .Y(n17) );
  DFFRX4 out_b_reg_1_ ( .D(n20), .CK(clk), .RN(n18), .Q(out_b[1]), .QN(n36) );
endmodule


module parity_gen ( p_acc, parity );
  input [7:0] p_acc;
  output parity;
  wire   n5, n6, n7, n8, n9, n10, n11, n12;

  XOR2X1 U6 ( .A(p_acc[1]), .B(p_acc[0]), .Y(n11) );
  XNOR2X1 U7 ( .A(n5), .B(n6), .Y(parity) );
  XNOR2X1 U8 ( .A(n9), .B(n10), .Y(n5) );
  XNOR2X1 U9 ( .A(n7), .B(n8), .Y(n6) );
  INVX1 U10 ( .A(p_acc[3]), .Y(n10) );
  XNOR2X1 U11 ( .A(p_acc[7]), .B(p_acc[6]), .Y(n8) );
  XNOR2X1 U12 ( .A(p_acc[5]), .B(p_acc[4]), .Y(n7) );
  XNOR2X1 U13 ( .A(n11), .B(n12), .Y(n9) );
  INVX1 U14 ( .A(p_acc[2]), .Y(n12) );
endmodule


module acc ( clk, rst_p, ld_acc, ld_acc_chd, wr, addr_acc, in_acc, acc_chd, 
        out_acc_r );
  input [7:0] addr_acc;
  input [7:0] in_acc;
  input [7:0] acc_chd;
  output [7:0] out_acc_r;
  input clk, rst_p, ld_acc, ld_acc_chd, wr;
  wire   n2, n4, n5, n9, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61,
         n62;

  DFFRHQX4 out_acc_r_reg_3_ ( .D(n25), .CK(clk), .RN(n21), .Q(out_acc_r[3]) );
  DFFRHQX4 out_acc_r_reg_0_ ( .D(n22), .CK(clk), .RN(n21), .Q(out_acc_r[0]) );
  DFFRHQX4 out_acc_r_reg_1_ ( .D(n23), .CK(clk), .RN(n21), .Q(out_acc_r[1]) );
  DFFRHQX8 out_acc_r_reg_2_ ( .D(n24), .CK(clk), .RN(n21), .Q(out_acc_r[2]) );
  AO21X1 U30 ( .A0(in_acc[2]), .A1(n2), .B0(n34), .Y(n24) );
  AO22X1 U31 ( .A0(acc_chd[2]), .A1(n4), .B0(out_acc_r[2]), .B1(n5), .Y(n34)
         );
  AO21X1 U32 ( .A0(in_acc[0]), .A1(n2), .B0(n35), .Y(n22) );
  AO22X1 U33 ( .A0(acc_chd[0]), .A1(n4), .B0(out_acc_r[0]), .B1(n5), .Y(n35)
         );
  AO21X1 U34 ( .A0(in_acc[1]), .A1(n2), .B0(n36), .Y(n23) );
  AO22X1 U35 ( .A0(acc_chd[1]), .A1(n4), .B0(out_acc_r[1]), .B1(n5), .Y(n36)
         );
  CLKINVX1 U36 ( .A(n38), .Y(n4) );
  NAND2X1 U37 ( .A(ld_acc_chd), .B(n55), .Y(n38) );
  INVX1 U38 ( .A(addr_acc[7]), .Y(n37) );
  CLKINVX1 U39 ( .A(ld_acc), .Y(n55) );
  CLKINVX1 U40 ( .A(acc_chd[4]), .Y(n54) );
  CLKINVX1 U41 ( .A(acc_chd[5]), .Y(n50) );
  CLKINVX1 U42 ( .A(acc_chd[6]), .Y(n46) );
  CLKINVX1 U43 ( .A(n2), .Y(n42) );
  NAND2X1 U44 ( .A(n55), .B(n57), .Y(n2) );
  NAND2X1 U45 ( .A(n56), .B(n58), .Y(n57) );
  INVX1 U46 ( .A(ld_acc_chd), .Y(n58) );
  CLKINVX1 U47 ( .A(n56), .Y(n5) );
  NAND2X1 U48 ( .A(n59), .B(n60), .Y(n56) );
  NOR2X1 U49 ( .A(ld_acc_chd), .B(ld_acc), .Y(n59) );
  NAND4BX1 U50 ( .AN(n20), .B(n61), .C(n62), .D(wr), .Y(n60) );
  NAND3X1 U51 ( .A(n39), .B(n40), .C(n41), .Y(n29) );
  NAND2X1 U52 ( .A(acc_chd[7]), .B(n4), .Y(n40) );
  NAND2X1 U53 ( .A(out_acc_r[7]), .B(n5), .Y(n39) );
  NAND2X1 U54 ( .A(in_acc[7]), .B(n2), .Y(n41) );
  OAI21X1 U55 ( .A0(n42), .A1(n51), .B0(n52), .Y(n26) );
  AOI21X1 U56 ( .A0(out_acc_r[4]), .A1(n5), .B0(n53), .Y(n52) );
  INVX1 U57 ( .A(in_acc[4]), .Y(n51) );
  NOR2X1 U58 ( .A(n38), .B(n54), .Y(n53) );
  OAI21X1 U59 ( .A0(n42), .A1(n47), .B0(n48), .Y(n27) );
  AOI21X1 U60 ( .A0(out_acc_r[5]), .A1(n5), .B0(n49), .Y(n48) );
  INVX1 U61 ( .A(in_acc[5]), .Y(n47) );
  NOR2X1 U62 ( .A(n38), .B(n50), .Y(n49) );
  OAI21X1 U63 ( .A0(n42), .A1(n43), .B0(n44), .Y(n28) );
  AOI21X1 U64 ( .A0(out_acc_r[6]), .A1(n5), .B0(n45), .Y(n44) );
  INVX1 U65 ( .A(in_acc[6]), .Y(n43) );
  NOR2X1 U66 ( .A(n38), .B(n46), .Y(n45) );
  AO21X1 U67 ( .A0(in_acc[3]), .A1(n2), .B0(n9), .Y(n25) );
  AO22X1 U68 ( .A0(acc_chd[3]), .A1(n4), .B0(out_acc_r[3]), .B1(n5), .Y(n9) );
  INVX1 U69 ( .A(rst_p), .Y(n21) );
  OR2X1 U70 ( .A(addr_acc[4]), .B(addr_acc[3]), .Y(n20) );
  NOR2X1 U71 ( .A(addr_acc[0]), .B(n37), .Y(n62) );
  NOR3X1 U72 ( .A(n19), .B(addr_acc[2]), .C(addr_acc[1]), .Y(n61) );
  NAND2X1 U73 ( .A(addr_acc[6]), .B(addr_acc[5]), .Y(n19) );
  DFFRX4 out_acc_r_reg_7_ ( .D(n29), .CK(clk), .RN(n21), .Q(out_acc_r[7]) );
  DFFRX4 out_acc_r_reg_6_ ( .D(n28), .CK(clk), .RN(n21), .Q(out_acc_r[6]) );
  DFFRX4 out_acc_r_reg_5_ ( .D(n27), .CK(clk), .RN(n21), .Q(out_acc_r[5]) );
  DFFRX4 out_acc_r_reg_4_ ( .D(n26), .CK(clk), .RN(n21), .Q(out_acc_r[4]) );
endmodule


module psw ( rst_p, in_psw, clk, addr_psw, wr, in_cy_bit, set_c, rst_c, cpl_c, 
        ld_c, set_ac, rst_ac, set_v, rst_v, parity, out_psw );
  input [6:0] in_psw;
  input [7:0] addr_psw;
  output [7:0] out_psw;
  input rst_p, clk, wr, in_cy_bit, set_c, rst_c, cpl_c, ld_c, set_ac, rst_ac,
         set_v, rst_v, parity;
  wire   y, n2, n3, n4, n6, n8, n9, n10, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n4500, n46, n47,
         n48, n49, n50, n51;

  mux2t1_1_2 u0 ( .a(in_psw[6]), .b(n22), .sel(cpl_c), .c(y) );
  CLKINVX1 U25 ( .A(n3), .Y(n36) );
  INVX1 U26 ( .A(n32), .Y(n9) );
  MXI2X1 U27 ( .S0(cpl_c), .B(n38), .A(n37), .Y(n28) );
  NAND2X1 U28 ( .A(n33), .B(n34), .Y(n32) );
  CLKINVX1 U29 ( .A(parity), .Y(n51) );
  INVX1 U30 ( .A(rst_v), .Y(n27) );
  INVX1 U31 ( .A(n44), .Y(n10) );
  NAND2X1 U32 ( .A(n4500), .B(n46), .Y(n44) );
  AO22X1 U33 ( .A0(out_psw[1]), .A1(n6), .B0(in_psw[0]), .B1(n8), .Y(n21) );
  CLKINVX1 U34 ( .A(addr_psw[7]), .Y(n23) );
  CLKINVX1 U35 ( .A(ld_c), .Y(n43) );
  CLKINVX1 U36 ( .A(cpl_c), .Y(n41) );
  NOR2X1 U37 ( .A(rst_c), .B(n35), .Y(n15) );
  NOR3X1 U38 ( .A(n26), .B(n36), .C(n28), .Y(n35) );
  NAND3X1 U39 ( .A(n8), .B(n43), .C(y), .Y(n3) );
  CLKINVX1 U40 ( .A(n6), .Y(n8) );
  DFFRX1 out_psw_reg_2_ ( .D(n20), .CK(clk), .RN(n14), .Q(out_psw[2]) );
  NAND2X1 U41 ( .A(ld_c), .B(in_cy_bit), .Y(n37) );
  INVX1 U42 ( .A(y), .Y(n38) );
  NAND2X2 U43 ( .A(n39), .B(n40), .Y(n26) );
  NAND4X1 U44 ( .A(n41), .B(n42), .C(n43), .D(n6), .Y(n39) );
  INVX1 U45 ( .A(set_c), .Y(n40) );
  CLKINVX1 U46 ( .A(n22), .Y(n42) );
  NOR2BX1 U47 ( .AN(n31), .B(n9), .Y(n16) );
  CLKINVX1 U48 ( .A(rst_ac), .Y(n31) );
  NOR2BX1 U49 ( .AN(n27), .B(n10), .Y(n20) );
  NAND4X1 U50 ( .A(n47), .B(n48), .C(n49), .D(wr), .Y(n6) );
  NOR2X1 U51 ( .A(n23), .B(n50), .Y(n49) );
  NOR2X2 U52 ( .A(rst_p), .B(n51), .Y(out_psw[0]) );
  CLKINVX1 U53 ( .A(set_ac), .Y(n34) );
  MXI2X1 U54 ( .S0(n8), .B(in_psw[5]), .A(out_psw[6]), .Y(n33) );
  MXI2X1 U55 ( .S0(n8), .B(in_psw[1]), .A(out_psw[2]), .Y(n4500) );
  INVX1 U56 ( .A(set_v), .Y(n46) );
  MXI2X1 U57 ( .S0(n8), .B(n30), .A(n25), .Y(n17) );
  INVX1 U58 ( .A(in_psw[4]), .Y(n30) );
  MXI2X1 U59 ( .S0(n8), .B(n29), .A(n24), .Y(n18) );
  INVX1 U60 ( .A(in_psw[3]), .Y(n29) );
  AO22X1 U61 ( .A0(out_psw[3]), .A1(n6), .B0(in_psw[2]), .B1(n8), .Y(n19) );
  INVX1 U62 ( .A(rst_p), .Y(n14) );
  DFFRX1 out_psw_reg_5_ ( .D(n17), .CK(clk), .RN(n14), .Q(out_psw[5]), .QN(n25) );
  NAND2X1 U63 ( .A(addr_psw[6]), .B(addr_psw[4]), .Y(n50) );
  NOR2X1 U64 ( .A(addr_psw[1]), .B(addr_psw[0]), .Y(n47) );
  NOR3X1 U65 ( .A(addr_psw[3]), .B(addr_psw[5]), .C(addr_psw[2]), .Y(n48) );
  INVX8 U66 ( .A(n26), .Y(n4) );
  INVX8 U67 ( .A(n28), .Y(n2) );
  DFFRX4 out_psw_reg_1_ ( .D(n21), .CK(clk), .RN(n14), .Q(out_psw[1]) );
  DFFRX4 out_psw_reg_3_ ( .D(n19), .CK(clk), .RN(n14), .Q(out_psw[3]) );
  DFFRX4 out_psw_reg_4_ ( .D(n18), .CK(clk), .RN(n14), .Q(out_psw[4]), .QN(n24) );
  DFFRX4 out_psw_reg_6_ ( .D(n16), .CK(clk), .RN(n14), .Q(out_psw[6]) );
  DFFRX4 out_psw_reg_7_ ( .D(n15), .CK(clk), .RN(n14), .Q(out_psw[7]), .QN(n22) );
endmodule


module mux2t1_1_2 ( a, b, sel, c );
  input a, b, sel;
  output c;
  wire   n3, n4;

  MXI2X1 U6 ( .S0(sel), .B(n4), .A(n3), .Y(c) );
  CLKINVX1 U7 ( .A(b), .Y(n4) );
  INVX1 U8 ( .A(a), .Y(n3) );
endmodule


module ip ( clk, rst_p, in_ip, addr_ip, wr, out_ip );
  input [7:0] in_ip;
  input [7:0] addr_ip;
  output [7:0] out_ip;
  input clk, rst_p, wr;
  wire   n1, n2, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27;

  CLKINVX1 U15 ( .A(addr_ip[7]), .Y(n14) );
  CLKINVX1 U16 ( .A(n2), .Y(n1) );
  DFFRX1 out_ip_reg_3_ ( .D(n9), .CK(clk), .RN(n5), .Q(out_ip[3]) );
  DFFRX1 out_ip_reg_2_ ( .D(n8), .CK(clk), .RN(n5), .Q(out_ip[2]) );
  NAND4X1 U17 ( .A(n23), .B(n24), .C(n25), .D(wr), .Y(n2) );
  NOR2X1 U18 ( .A(n14), .B(n26), .Y(n25) );
  MXI2X1 U19 ( .S0(n1), .B(n19), .A(n15), .Y(n13) );
  INVX1 U20 ( .A(in_ip[7]), .Y(n19) );
  MXI2X1 U21 ( .S0(n1), .B(n20), .A(n16), .Y(n12) );
  INVX1 U22 ( .A(in_ip[6]), .Y(n20) );
  MXI2X1 U23 ( .S0(n1), .B(n21), .A(n17), .Y(n11) );
  INVX1 U24 ( .A(in_ip[5]), .Y(n21) );
  MXI2X1 U25 ( .S0(n1), .B(n22), .A(n18), .Y(n10) );
  INVX1 U26 ( .A(in_ip[4]), .Y(n22) );
  AO22X1 U27 ( .A0(in_ip[3]), .A1(n1), .B0(out_ip[3]), .B1(n2), .Y(n9) );
  AO22X1 U28 ( .A0(in_ip[2]), .A1(n1), .B0(out_ip[2]), .B1(n2), .Y(n8) );
  AO22X1 U29 ( .A0(in_ip[1]), .A1(n1), .B0(out_ip[1]), .B1(n2), .Y(n7) );
  AO22X1 U30 ( .A0(in_ip[0]), .A1(n1), .B0(out_ip[0]), .B1(n2), .Y(n6) );
  INVX1 U31 ( .A(rst_p), .Y(n5) );
  DFFRX1 out_ip_reg_4_ ( .D(n10), .CK(clk), .RN(n5), .Q(out_ip[4]), .QN(n18)
         );
  DFFRX1 out_ip_reg_5_ ( .D(n11), .CK(clk), .RN(n5), .Q(out_ip[5]), .QN(n17)
         );
  DFFRX1 out_ip_reg_6_ ( .D(n12), .CK(clk), .RN(n5), .Q(out_ip[6]), .QN(n16)
         );
  DFFRX1 out_ip_reg_7_ ( .D(n13), .CK(clk), .RN(n5), .Q(out_ip[7]), .QN(n15)
         );
  INVX1 U32 ( .A(addr_ip[3]), .Y(n27) );
  NOR2X1 U33 ( .A(addr_ip[0]), .B(n27), .Y(n23) );
  NAND2X1 U34 ( .A(addr_ip[5]), .B(addr_ip[4]), .Y(n26) );
  NOR3X1 U35 ( .A(addr_ip[1]), .B(addr_ip[6]), .C(addr_ip[2]), .Y(n24) );
  DFFRX4 out_ip_reg_1_ ( .D(n7), .CK(clk), .RN(n5), .Q(out_ip[1]) );
  DFFRX4 out_ip_reg_0_ ( .D(n6), .CK(clk), .RN(n5), .Q(out_ip[0]) );
endmodule


module gpio3 ( clk, rst_p, wr, rmw, combus, prt3_addr, p3_in, p3, p3_out );
  input [7:0] combus;
  input [7:0] prt3_addr;
  input [7:0] p3_in;
  output [7:0] p3;
  output [7:0] p3_out;
  input clk, rst_p, wr, rmw;
  wire   n2, n3, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35;

  CLKMX2X2 U25 ( .S0(rmw), .B(p3_out[1]), .A(p3_in[1]), .Y(p3[1]) );
  MXI2X1 U26 ( .S0(rmw), .B(n18), .A(n26), .Y(p3[4]) );
  MX2X1 U27 ( .S0(rmw), .B(p3_out[2]), .A(p3_in[2]), .Y(p3[2]) );
  MXI2X1 U28 ( .S0(rmw), .B(n17), .A(n25), .Y(p3[5]) );
  MXI2X1 U29 ( .S0(rmw), .B(n19), .A(n24), .Y(p3[6]) );
  MXI2X1 U30 ( .S0(rmw), .B(n20), .A(n23), .Y(p3[7]) );
  CLKINVX1 U31 ( .A(prt3_addr[7]), .Y(n21) );
  CLKINVX1 U32 ( .A(n3), .Y(n2) );
  DFFSX1 p3_out_reg_0_ ( .D(n9), .CK(clk), .SN(n8), .Q(p3_out[0]), .QN(n22) );
  DFFSX1 p3_out_reg_2_ ( .D(n11), .CK(clk), .SN(n8), .Q(p3_out[2]) );
  DFFSX1 p3_out_reg_3_ ( .D(n12), .CK(clk), .SN(n8), .Q(p3_out[3]) );
  MXI2X1 U33 ( .S0(n2), .B(n28), .A(n20), .Y(n16) );
  INVX1 U34 ( .A(combus[7]), .Y(n28) );
  MXI2X1 U35 ( .S0(n2), .B(n29), .A(n19), .Y(n15) );
  INVX1 U36 ( .A(combus[6]), .Y(n29) );
  MXI2X1 U37 ( .S0(n2), .B(n30), .A(n17), .Y(n14) );
  INVX1 U38 ( .A(combus[5]), .Y(n30) );
  MXI2X1 U39 ( .S0(n2), .B(n31), .A(n18), .Y(n13) );
  INVX1 U40 ( .A(combus[4]), .Y(n31) );
  NAND4X1 U41 ( .A(n32), .B(n33), .C(n34), .D(wr), .Y(n3) );
  NOR2X1 U42 ( .A(n21), .B(n35), .Y(n34) );
  MXI2X1 U43 ( .S0(rmw), .B(n22), .A(n27), .Y(p3[0]) );
  CLKINVX1 U44 ( .A(p3_in[0]), .Y(n27) );
  MX2X1 U45 ( .S0(rmw), .B(p3_out[3]), .A(p3_in[3]), .Y(p3[3]) );
  CLKINVX1 U46 ( .A(p3_in[4]), .Y(n26) );
  CLKINVX1 U47 ( .A(p3_in[5]), .Y(n25) );
  CLKINVX1 U48 ( .A(p3_in[6]), .Y(n24) );
  CLKINVX1 U49 ( .A(p3_in[7]), .Y(n23) );
  AO22X1 U50 ( .A0(combus[3]), .A1(n2), .B0(p3_out[3]), .B1(n3), .Y(n12) );
  AO22X1 U51 ( .A0(combus[2]), .A1(n2), .B0(p3_out[2]), .B1(n3), .Y(n11) );
  AO22X1 U52 ( .A0(combus[1]), .A1(n2), .B0(p3_out[1]), .B1(n3), .Y(n10) );
  AO22X1 U53 ( .A0(combus[0]), .A1(n2), .B0(p3_out[0]), .B1(n3), .Y(n9) );
  INVX1 U54 ( .A(rst_p), .Y(n8) );
  NOR2X1 U55 ( .A(prt3_addr[1]), .B(prt3_addr[0]), .Y(n32) );
  NAND2X1 U56 ( .A(prt3_addr[5]), .B(prt3_addr[4]), .Y(n35) );
  NOR3X1 U57 ( .A(prt3_addr[3]), .B(prt3_addr[6]), .C(prt3_addr[2]), .Y(n33)
         );
  DFFSX4 p3_out_reg_7_ ( .D(n16), .CK(clk), .SN(n8), .Q(p3_out[7]), .QN(n20)
         );
  DFFSX4 p3_out_reg_6_ ( .D(n15), .CK(clk), .SN(n8), .Q(p3_out[6]), .QN(n19)
         );
  DFFSX4 p3_out_reg_5_ ( .D(n14), .CK(clk), .SN(n8), .Q(p3_out[5]), .QN(n17)
         );
  DFFSX4 p3_out_reg_4_ ( .D(n13), .CK(clk), .SN(n8), .Q(p3_out[4]), .QN(n18)
         );
  DFFSX4 p3_out_reg_1_ ( .D(n10), .CK(clk), .SN(n8), .Q(p3_out[1]) );
endmodule


module ie ( clk, rst_p, in_ie, addr_ie, wr, out_ie );
  input [7:0] in_ie;
  input [7:0] addr_ie;
  output [7:0] out_ie;
  input clk, rst_p, wr;
  wire   n1, n2, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18,
         n19, n20, n21, n22, n23, n24, n25, n26, n27;

  CLKINVX1 U16 ( .A(addr_ie[7]), .Y(n15) );
  CLKINVX1 U17 ( .A(n2), .Y(n1) );
  DFFRX1 out_ie_reg_4_ ( .D(n11), .CK(clk), .RN(n6), .Q(out_ie[4]), .QN(n19)
         );
  NAND4X1 U18 ( .A(n24), .B(n25), .C(n26), .D(wr), .Y(n2) );
  NOR2X1 U19 ( .A(n15), .B(n27), .Y(n26) );
  MXI2X1 U20 ( .S0(n1), .B(n20), .A(n16), .Y(n14) );
  INVX1 U21 ( .A(in_ie[7]), .Y(n20) );
  MXI2X1 U22 ( .S0(n1), .B(n21), .A(n17), .Y(n13) );
  INVX1 U23 ( .A(in_ie[6]), .Y(n21) );
  MXI2X1 U24 ( .S0(n1), .B(n22), .A(n18), .Y(n12) );
  INVX1 U25 ( .A(in_ie[5]), .Y(n22) );
  MXI2X1 U26 ( .S0(n1), .B(n23), .A(n19), .Y(n11) );
  INVX1 U27 ( .A(in_ie[4]), .Y(n23) );
  AO22X1 U28 ( .A0(in_ie[3]), .A1(n1), .B0(out_ie[3]), .B1(n2), .Y(n10) );
  AO22X1 U29 ( .A0(in_ie[2]), .A1(n1), .B0(out_ie[2]), .B1(n2), .Y(n9) );
  AO22X1 U30 ( .A0(in_ie[1]), .A1(n1), .B0(out_ie[1]), .B1(n2), .Y(n8) );
  AO22X1 U31 ( .A0(in_ie[0]), .A1(n1), .B0(out_ie[0]), .B1(n2), .Y(n7) );
  INVX1 U32 ( .A(rst_p), .Y(n6) );
  DFFRX1 out_ie_reg_5_ ( .D(n12), .CK(clk), .RN(n6), .Q(out_ie[5]), .QN(n18)
         );
  DFFRX1 out_ie_reg_6_ ( .D(n13), .CK(clk), .RN(n6), .Q(out_ie[6]), .QN(n17)
         );
  NOR2X1 U33 ( .A(addr_ie[1]), .B(addr_ie[0]), .Y(n24) );
  NAND2X1 U34 ( .A(addr_ie[5]), .B(addr_ie[3]), .Y(n27) );
  NOR3X1 U35 ( .A(addr_ie[4]), .B(addr_ie[6]), .C(addr_ie[2]), .Y(n25) );
  DFFRX4 out_ie_reg_7_ ( .D(n14), .CK(clk), .RN(n6), .Q(out_ie[7]), .QN(n16)
         );
  DFFRX4 out_ie_reg_3_ ( .D(n10), .CK(clk), .RN(n6), .Q(out_ie[3]) );
  DFFRX4 out_ie_reg_2_ ( .D(n9), .CK(clk), .RN(n6), .Q(out_ie[2]) );
  DFFRX4 out_ie_reg_1_ ( .D(n8), .CK(clk), .RN(n6), .Q(out_ie[1]) );
  DFFRX4 out_ie_reg_0_ ( .D(n7), .CK(clk), .RN(n6), .Q(out_ie[0]) );
endmodule


module gpio2 ( clk, rst_p, wr, rmw, combus, prt2_addr, p2_in, p2, p2_out );
  input [7:0] combus;
  input [7:0] prt2_addr;
  input [7:0] p2_in;
  output [7:0] p2;
  output [7:0] p2_out;
  input clk, rst_p, wr, rmw;
  wire   n2, n3, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35, n36, n37, n38, n39, n40, n41, n42, n43;

  CLKINVX1 U24 ( .A(prt2_addr[7]), .Y(n20) );
  OR3X1 U25 ( .A(prt2_addr[4]), .B(prt2_addr[6]), .C(prt2_addr[3]), .Y(n39) );
  CLKINVX1 U26 ( .A(n3), .Y(n2) );
  DFFSX1 p2_out_reg_0_ ( .D(n8), .CK(clk), .SN(n7), .Q(p2_out[0]), .QN(n24) );
  DFFSX1 p2_out_reg_2_ ( .D(n10), .CK(clk), .SN(n7), .Q(p2_out[2]), .QN(n22)
         );
  DFFSX1 p2_out_reg_3_ ( .D(n11), .CK(clk), .SN(n7), .Q(p2_out[3]), .QN(n21)
         );
  MXI2X1 U27 ( .S0(n2), .B(n33), .A(n19), .Y(n15) );
  INVX1 U28 ( .A(combus[7]), .Y(n33) );
  MXI2X1 U29 ( .S0(n2), .B(n34), .A(n18), .Y(n14) );
  INVX1 U30 ( .A(combus[6]), .Y(n34) );
  MXI2X1 U31 ( .S0(n2), .B(n35), .A(n16), .Y(n13) );
  INVX1 U32 ( .A(combus[5]), .Y(n35) );
  MXI2X1 U33 ( .S0(n2), .B(n36), .A(n17), .Y(n12) );
  INVX1 U34 ( .A(combus[4]), .Y(n36) );
  NAND3X1 U35 ( .A(n37), .B(n38), .C(wr), .Y(n3) );
  NOR2X1 U36 ( .A(n39), .B(n40), .Y(n38) );
  NAND2X1 U37 ( .A(n41), .B(n42), .Y(n40) );
  MXI2X1 U38 ( .S0(rmw), .B(n16), .A(n27), .Y(p2[5]) );
  CLKINVX1 U39 ( .A(p2_in[5]), .Y(n27) );
  MXI2X1 U40 ( .S0(rmw), .B(n18), .A(n26), .Y(p2[6]) );
  CLKINVX1 U41 ( .A(p2_in[6]), .Y(n26) );
  MXI2X1 U42 ( .S0(rmw), .B(n17), .A(n28), .Y(p2[4]) );
  CLKINVX1 U43 ( .A(p2_in[4]), .Y(n28) );
  MXI2X1 U44 ( .S0(rmw), .B(n19), .A(n25), .Y(p2[7]) );
  CLKINVX1 U45 ( .A(p2_in[7]), .Y(n25) );
  MXI2X1 U46 ( .S0(rmw), .B(n22), .A(n30), .Y(p2[2]) );
  CLKINVX1 U47 ( .A(p2_in[2]), .Y(n30) );
  MXI2X1 U48 ( .S0(rmw), .B(n23), .A(n31), .Y(p2[1]) );
  CLKINVX1 U49 ( .A(p2_in[1]), .Y(n31) );
  MXI2X1 U50 ( .S0(rmw), .B(n21), .A(n29), .Y(p2[3]) );
  CLKINVX1 U51 ( .A(p2_in[3]), .Y(n29) );
  MXI2X1 U52 ( .S0(rmw), .B(n24), .A(n32), .Y(p2[0]) );
  CLKINVX1 U53 ( .A(p2_in[0]), .Y(n32) );
  AO22X1 U54 ( .A0(combus[3]), .A1(n2), .B0(p2_out[3]), .B1(n3), .Y(n11) );
  AO22X1 U55 ( .A0(combus[2]), .A1(n2), .B0(p2_out[2]), .B1(n3), .Y(n10) );
  AO22X1 U56 ( .A0(combus[1]), .A1(n2), .B0(p2_out[1]), .B1(n3), .Y(n9) );
  AO22X1 U57 ( .A0(combus[0]), .A1(n2), .B0(p2_out[0]), .B1(n3), .Y(n8) );
  INVX1 U58 ( .A(rst_p), .Y(n7) );
  INVX1 U59 ( .A(prt2_addr[1]), .Y(n41) );
  NOR3X1 U60 ( .A(n20), .B(prt2_addr[0]), .C(n43), .Y(n37) );
  INVX1 U61 ( .A(prt2_addr[5]), .Y(n43) );
  INVX1 U62 ( .A(prt2_addr[2]), .Y(n42) );
  DFFSX4 p2_out_reg_7_ ( .D(n15), .CK(clk), .SN(n7), .Q(p2_out[7]), .QN(n19)
         );
  DFFSX4 p2_out_reg_6_ ( .D(n14), .CK(clk), .SN(n7), .Q(p2_out[6]), .QN(n18)
         );
  DFFSX4 p2_out_reg_5_ ( .D(n13), .CK(clk), .SN(n7), .Q(p2_out[5]), .QN(n16)
         );
  DFFSX4 p2_out_reg_4_ ( .D(n12), .CK(clk), .SN(n7), .Q(p2_out[4]), .QN(n17)
         );
  DFFSX4 p2_out_reg_1_ ( .D(n9), .CK(clk), .SN(n7), .Q(p2_out[1]), .QN(n23) );
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
         sbuf_txd_8_, sbuf_txd_7_, sbuf_txd_6_, sbuf_txd_5_, sbuf_txd_4_,
         sbuf_txd_3_, sbuf_txd_0_, sbuf_rxd_tmp_7_, sbuf_rxd_tmp_6_,
         sbuf_rxd_tmp_5_, sbuf_rxd_tmp_4_, sbuf_rxd_tmp_3_, sbuf_rxd_tmp_1_,
         sbuf_rxd_tmp_0_, tx_done, rx_done, div12, rec_sync, receive, txd,
         trans1, trans, trans2, trans3, shift12_1, smod_clk_trans, shift_rec,
         smod_clk_rec, N239, N240, N241, N242, N243, N244, N245, N246, N247,
         N248, N249, N308, N309, N310, N312, N313, N314, n3, n4, n5, n6, n7,
         n8, n9, n11, n12, n13, n15, n20, n21, n22, n24, n25, n26, n27, n28,
         n29, n30, n31, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43,
         n44, n45, n46, n47, n51, n52, n53, n54, n55, n56, n57, n59, n60, n62,
         n67, n68, n69, n72, n76, n77, n78, n79, n80, n82, n83, n85, n86, n88,
         n89, n91, n93, n95, n98, n103, n104, n105, n110, n111, n112, n113,
         n114, n116, n122, n123, n125, n126, n127, n128, n129, n132, n133,
         n134, n135, n136, n137, n138, n141, n143, n144, n145, n146, n147,
         n148, n149, n150, n151, n152, n153, n154, n156, n157, n158, n160,
         n161, n162, n164, n169, n170, n175, n177, n180, n181, n184, n185,
         n186, n187, n188, n189, n190, n191, n192, n193, n194, n195, n196,
         n197, n198, n199, n200, n201, n202, n203, n204, n205, n206, n207,
         n208, n209, n210, n211, n212, n213, n214, n215, n216, n217, n218,
         n219, n220, n221, n222, n223, n224, n225, n226, n227, n228, n229,
         n230, n231, n232, n233, n234, n235, n236, n237, n238, n2390, n2400,
         n2410, n2420, n2430, n2440, n2450, n2460, n2470, n2480, n2490, n250,
         n251, n252, n253, n254, n255, n256, n257, n258, n259, n260, n261,
         n262, n263, n264, n265, n266, n267, n268, n269, n270, n271, n272,
         n273, n274, n275, n276, n277, n278, n279, n280, n281, n282, n283,
         n284, n285, n286, n287, n288, n289, n290, n291, n292, n293, n294,
         n295, n296, n297, n298, n299, n300, n301, n302, n303, n304, n305,
         n306, n307, n3080, n3090, n3100, n311, n3120, n3130, n3140, n315,
         n316, n317, n318, n319, n320, n321, n322, n323, n324, n325, n326,
         n327, n328, n329, n330, n331, n332, n333, n334, n335, n336, n337,
         n338, n339, n340, n341, n342, n343, n344, n345, n346, n347, n348,
         n349, n350, n351, n352, n353, n354, n355, n356, n357, n358, n359,
         n360, n361, n362, n363, n364, n365, n366, n367, n368, n369, n370,
         n371, n372, n373, n374, n375, n376, n377, n378, n379, n380, n381,
         n382, n383, n384, n385, n386, n387, n388, n389, n390;
  wire   [7:0] cnt1_8;
  wire   [3:0] cnt0_4;
  wire   [3:0] trans_cnt;
  wire   [3:0] rec_cnt;
  wire   [1:0] rx_same;

  OAI211X4 U165 ( .A0(n134), .A1(n129), .B0(n135), .C0(n114), .Y(n112) );
  DFFQX1 trans1_reg ( .D(trans), .CK(clk), .Q(trans1) );
  DFFQX1 trans2_reg ( .D(trans1), .CK(clk), .Q(trans2) );
  DFFRX1 sbuf_txd_reg_8_ ( .D(n235), .CK(clk), .RN(n184), .Q(sbuf_txd_8_), 
        .QN(n291) );
  NOR2X1 U270 ( .A(n344), .B(n345), .Y(n343) );
  INVX1 U271 ( .A(in_sfr[0]), .Y(n60) );
  NOR2BX1 U272 ( .AN(n346), .B(n348), .Y(n341) );
  INVX1 U273 ( .A(addr_sfr[6]), .Y(n377) );
  NAND3BX1 U274 ( .AN(n290), .B(shift_rec), .C(n146), .Y(n114) );
  CLKINVX1 U275 ( .A(n335), .Y(n28) );
  CLKINVX1 U276 ( .A(n51), .Y(n52) );
  CLKINVX1 U277 ( .A(n77), .Y(n331) );
  NAND2X1 U278 ( .A(addr_sfr[0]), .B(n3130), .Y(n335) );
  CLKINVX1 U279 ( .A(n68), .Y(n349) );
  CLKINVX1 U280 ( .A(n170), .Y(n169) );
  NAND2X1 U281 ( .A(n3130), .B(n321), .Y(n51) );
  NAND2X1 U282 ( .A(n28), .B(n5), .Y(n77) );
  CLKINVX1 U283 ( .A(n79), .Y(n347) );
  NAND2BX1 U284 ( .AN(txd), .B(n5), .Y(rxdo) );
  NAND2X1 U285 ( .A(in_sfr[6]), .B(n347), .Y(n342) );
  INVX1 U286 ( .A(in_sfr[7]), .Y(n76) );
  NAND2X1 U287 ( .A(n331), .B(in_sfr[6]), .Y(n328) );
  INVX1 U288 ( .A(in_sfr[4]), .Y(n85) );
  INVX1 U289 ( .A(in_sfr[5]), .Y(n82) );
  INVX1 U290 ( .A(in_sfr[6]), .Y(n78) );
  INVX1 U291 ( .A(in_sfr[2]), .Y(n55) );
  CLKINVX1 U292 ( .A(n67), .Y(n340) );
  AND2X2 U293 ( .A(n3140), .B(n372), .Y(n3130) );
  NAND2X1 U294 ( .A(n67), .B(n335), .Y(n68) );
  NAND3X1 U295 ( .A(n374), .B(n375), .C(n3140), .Y(n170) );
  NOR2X1 U296 ( .A(n378), .B(n379), .Y(n375) );
  NAND2X1 U297 ( .A(n28), .B(n7), .Y(n79) );
  CLKINVX1 U298 ( .A(n7), .Y(n5) );
  CLKINVX1 U299 ( .A(n132), .Y(n133) );
  CLKINVX1 U300 ( .A(n113), .Y(n111) );
  CLKINVX1 U301 ( .A(n129), .Y(n125) );
  DFFRX1 pcon_reg_7_ ( .D(n262), .CK(clk), .RN(n184), .Q(pcon[7]), .QN(n323)
         );
  DFFRX1 sbuf_rxd_reg_5_ ( .D(n217), .CK(clk), .RN(n184), .Q(sbuf[5]) );
  DFFRX1 sbuf_rxd_reg_6_ ( .D(n218), .CK(clk), .RN(n184), .Q(sbuf[6]) );
  DFFRX1 sbuf_rxd_reg_7_ ( .D(n219), .CK(clk), .RN(n184), .Q(sbuf[7]) );
  DFFRX1 scon_reg_6_ ( .D(n269), .CK(clk), .RN(n184), .Q(scon[6]), .QN(n285)
         );
  MXI2X1 U302 ( .S0(n52), .B(n76), .A(n273), .Y(n270) );
  AOI21X1 U303 ( .A0(n341), .A1(n342), .B0(n343), .Y(n234) );
  AOI21X1 U304 ( .A0(n334), .A1(n335), .B0(n336), .Y(n235) );
  CLKINVX1 U305 ( .A(n337), .Y(n334) );
  NOR2X1 U306 ( .A(in_sfr[7]), .B(n337), .Y(n336) );
  NAND2X1 U307 ( .A(n338), .B(n77), .Y(n337) );
  NAND2X1 U308 ( .A(n333), .B(n76), .Y(n344) );
  NAND2X1 U309 ( .A(n342), .B(n346), .Y(n345) );
  MXI2X1 U310 ( .S0(n52), .B(n78), .A(n285), .Y(n269) );
  MXI2X1 U311 ( .S0(n52), .B(n82), .A(n293), .Y(n268) );
  MXI2X1 U312 ( .S0(n52), .B(n85), .A(n290), .Y(n267) );
  INVX1 U313 ( .A(in_sfr[1]), .Y(n59) );
  OAI221X1 U314 ( .A0(n68), .A1(n278), .B0(n60), .B1(n79), .C0(n95), .Y(n228)
         );
  OA22X1 U315 ( .A0(n59), .A1(n77), .B0(n67), .B1(n277), .Y(n95) );
  OAI221X1 U316 ( .A0(n68), .A1(n289), .B0(n59), .B1(n79), .C0(n93), .Y(n229)
         );
  OA22X1 U317 ( .A0(n55), .A1(n77), .B0(n67), .B1(n278), .Y(n93) );
  NAND2X1 U318 ( .A(n367), .B(n27), .Y(n67) );
  AOI21X1 U319 ( .A0(n35), .A1(n369), .B0(n28), .Y(n367) );
  CLKINVX1 U320 ( .A(n36), .Y(n369) );
  AND4X1 U321 ( .A(n376), .B(n377), .C(addr_sfr[7]), .D(wr), .Y(n3140) );
  NAND2X1 U322 ( .A(n333), .B(n77), .Y(n348) );
  CLKINVX1 U323 ( .A(n40), .Y(n38) );
  OAI222X1 U324 ( .A0(n60), .A1(n77), .B0(n297), .B1(n67), .C0(n68), .C1(n277), 
        .Y(n227) );
  CLKINVX1 U325 ( .A(n39), .Y(n37) );
  NAND2BX1 U326 ( .AN(n28), .B(n40), .Y(n39) );
  NAND2X1 U327 ( .A(n285), .B(n273), .Y(n7) );
  DFFSX1 rx_done_reg ( .D(n193), .CK(clk), .SN(n184), .Q(rx_done), .QN(n276)
         );
  DFFRX1 rec_cnt_reg_2_ ( .D(n198), .CK(clk), .RN(n184), .Q(rec_cnt[2]), .QN(
        n302) );
  DFFRX1 trans_cnt_reg_0_ ( .D(n223), .CK(clk), .RN(n184), .Q(trans_cnt[0]), 
        .QN(n311) );
  DFFRX1 trans_cnt_reg_3_ ( .D(n226), .CK(clk), .RN(n184), .Q(trans_cnt[3]), 
        .QN(n3100) );
  DFFRX1 sbuf_txd_reg_6_ ( .D(n233), .CK(clk), .RN(n184), .Q(sbuf_txd_6_), 
        .QN(n279) );
  DFFRX1 rec_cnt_reg_0_ ( .D(n196), .CK(clk), .RN(n184), .Q(rec_cnt[0]), .QN(
        n3120) );
  NAND2BX1 U328 ( .AN(n133), .B(n112), .Y(n113) );
  NAND2BX1 U329 ( .AN(n276), .B(n316), .Y(n129) );
  NAND2BX1 U330 ( .AN(n316), .B(n127), .Y(n132) );
  NAND2BX1 U331 ( .AN(n132), .B(n112), .Y(n116) );
  CLKINVX1 U332 ( .A(n35), .Y(n30) );
  CLKINVX1 U333 ( .A(n112), .Y(n110) );
  CLKINVX1 U334 ( .A(n127), .Y(n138) );
  CLKINVX1 U335 ( .A(n29), .Y(n33) );
  OAI221X1 U336 ( .A0(n283), .A1(n112), .B0(n286), .B1(n113), .C0(n116), .Y(
        n201) );
  OAI221X1 U337 ( .A0(n286), .A1(n112), .B0(n282), .B1(n113), .C0(n116), .Y(
        n202) );
  OAI221X1 U338 ( .A0(n282), .A1(n112), .B0(n295), .B1(n113), .C0(n116), .Y(
        n203) );
  OAI221X1 U339 ( .A0(n295), .A1(n112), .B0(n272), .B1(n113), .C0(n116), .Y(
        n204) );
  OAI221X1 U340 ( .A0(n272), .A1(n112), .B0(n281), .B1(n113), .C0(n116), .Y(
        n205) );
  OAI221X1 U341 ( .A0(n281), .A1(n112), .B0(n294), .B1(n113), .C0(n116), .Y(
        n206) );
  OAI221X1 U342 ( .A0(n294), .A1(n112), .B0(n113), .B1(n275), .C0(n116), .Y(
        n207) );
  OAI221X1 U343 ( .A0(n112), .A1(n275), .B0(n113), .B1(n287), .C0(n114), .Y(
        n208) );
  OAI31X1 U344 ( .A0(n141), .A1(n296), .A2(n143), .B0(n144), .Y(n220) );
  CLKINVX1 U345 ( .A(n145), .Y(n143) );
  OA22X1 U346 ( .A0(n114), .A1(n128), .B0(n128), .B1(n145), .Y(n144) );
  CLKINVX1 U347 ( .A(n114), .Y(n141) );
  CLKINVX1 U348 ( .A(n162), .Y(n161) );
  NAND2BX1 U349 ( .AN(n125), .B(n114), .Y(n162) );
  CLKINVX1 U350 ( .A(rxdi), .Y(n128) );
  CLKINVX1 U351 ( .A(n158), .Y(n137) );
  NAND2BX1 U352 ( .AN(n276), .B(n5), .Y(n158) );
  NAND2X1 U353 ( .A(rec_cnt[1]), .B(n380), .Y(n382) );
  NAND2X1 U354 ( .A(cnt0_4[1]), .B(n387), .Y(n389) );
  NAND2X1 U355 ( .A(trans_cnt[1]), .B(trans_cnt[0]), .Y(n385) );
  NOR2BX1 U356 ( .AN(N240), .B(n319), .Y(n253) );
  XNOR2X1 U357 ( .A(n388), .B(n320), .Y(N240) );
  CLKINVX1 U358 ( .A(n389), .Y(n388) );
  NOR2BX1 U359 ( .AN(n46), .B(n47), .Y(n190) );
  NOR2BX1 U360 ( .AN(n44), .B(n47), .Y(n221) );
  NOR2BX1 U361 ( .AN(N245), .B(n317), .Y(n2450) );
  NOR2BX1 U362 ( .AN(N244), .B(n317), .Y(n2440) );
  NOR2BX1 U363 ( .AN(N243), .B(n317), .Y(n2430) );
  NOR2BX1 U364 ( .AN(N246), .B(n317), .Y(n2460) );
  NOR2BX1 U365 ( .AN(N247), .B(n317), .Y(n2470) );
  NOR2BX1 U366 ( .AN(N248), .B(n317), .Y(n2480) );
  NOR2X1 U367 ( .A(n387), .B(n319), .Y(n251) );
  CLKINVX1 U368 ( .A(n42), .Y(n47) );
  NOR2BX1 U369 ( .AN(N239), .B(n319), .Y(n252) );
  XNOR2X1 U370 ( .A(n387), .B(n306), .Y(N239) );
  CLKINVX1 U371 ( .A(n333), .Y(n332) );
  CLKINVX1 U372 ( .A(n330), .Y(n329) );
  MXI2X1 U373 ( .S0(n169), .B(n76), .A(n323), .Y(n262) );
  MXI2X1 U374 ( .S0(n52), .B(n88), .A(n322), .Y(n266) );
  INVX1 U375 ( .A(in_sfr[3]), .Y(n88) );
  NAND4X1 U376 ( .A(n350), .B(n351), .C(n330), .D(n328), .Y(n233) );
  NAND2X1 U377 ( .A(sbuf_txd_7_), .B(n349), .Y(n351) );
  NAND2X1 U378 ( .A(n347), .B(in_sfr[5]), .Y(n350) );
  MXI2X1 U379 ( .S0(n169), .B(n85), .A(n326), .Y(n259) );
  MXI2X1 U380 ( .S0(n169), .B(n82), .A(n325), .Y(n260) );
  MXI2X1 U381 ( .S0(n169), .B(n78), .A(n324), .Y(n261) );
  NAND2X1 U382 ( .A(n360), .B(n361), .Y(n359) );
  NAND2X1 U383 ( .A(sbuf_txd_4_), .B(n340), .Y(n360) );
  NAND2X1 U384 ( .A(n331), .B(in_sfr[4]), .Y(n361) );
  NAND2X1 U385 ( .A(n355), .B(n356), .Y(n354) );
  NAND2X1 U386 ( .A(n340), .B(sbuf_txd_5_), .Y(n355) );
  NAND2X1 U387 ( .A(n331), .B(in_sfr[5]), .Y(n356) );
  NAND2X1 U388 ( .A(n365), .B(n366), .Y(n364) );
  NAND2X1 U389 ( .A(n340), .B(sbuf_txd_3_), .Y(n365) );
  NAND2X1 U390 ( .A(n331), .B(in_sfr[3]), .Y(n366) );
  NAND3X1 U391 ( .A(n352), .B(n353), .C(n86), .Y(n232) );
  NAND2X1 U392 ( .A(n349), .B(sbuf_txd_6_), .Y(n353) );
  NAND2X1 U393 ( .A(n347), .B(in_sfr[4]), .Y(n352) );
  CLKINVX1 U394 ( .A(n354), .Y(n86) );
  NAND3X1 U395 ( .A(n357), .B(n358), .C(n89), .Y(n231) );
  NAND2X1 U396 ( .A(n349), .B(sbuf_txd_5_), .Y(n358) );
  NAND2X1 U397 ( .A(n347), .B(in_sfr[3]), .Y(n357) );
  CLKINVX1 U398 ( .A(n359), .Y(n89) );
  AO22X1 U399 ( .A0(n169), .A1(in_sfr[3]), .B0(pcon[3]), .B1(n170), .Y(n258)
         );
  NAND3X1 U400 ( .A(n362), .B(n363), .C(n91), .Y(n230) );
  NAND2X1 U401 ( .A(sbuf_txd_4_), .B(n349), .Y(n363) );
  NAND2X1 U402 ( .A(in_sfr[2]), .B(n347), .Y(n362) );
  CLKINVX1 U403 ( .A(n364), .Y(n91) );
  AO22X1 U404 ( .A0(n169), .A1(in_sfr[2]), .B0(pcon[2]), .B1(n170), .Y(n257)
         );
  OAI222X1 U405 ( .A0(n52), .A1(n280), .B0(n52), .B1(n301), .C0(n51), .C1(n59), 
        .Y(n264) );
  OAI221X1 U406 ( .A0(n53), .A1(n54), .B0(n51), .B1(n55), .C0(n56), .Y(n265)
         );
  NAND3BX1 U407 ( .AN(rx_done), .B(sbuf_rxd_tmp_11_), .C(n7), .Y(n54) );
  OAI31X1 U408 ( .A0(n53), .A1(rx_done), .A2(n5), .B0(n57), .Y(n56) );
  NOR2BX1 U409 ( .AN(scon[2]), .B(n52), .Y(n57) );
  MXI2X1 U410 ( .S0(n340), .B(sbuf_txd_8_), .A(n339), .Y(n338) );
  AOI21X1 U411 ( .A0(n40), .A1(n36), .B0(n274), .Y(n339) );
  NAND2X1 U412 ( .A(sbuf_txd_7_), .B(n340), .Y(n333) );
  NAND2X1 U413 ( .A(n349), .B(sbuf_txd_8_), .Y(n346) );
  NAND2X1 U414 ( .A(n368), .B(n335), .Y(n40) );
  NOR3X1 U415 ( .A(n327), .B(n288), .C(n5), .Y(n368) );
  NAND2X1 U416 ( .A(n98), .B(n38), .Y(n27) );
  AND4X1 U417 ( .A(n311), .B(n307), .C(n299), .D(n3100), .Y(n98) );
  AO22X1 U418 ( .A0(n169), .A1(in_sfr[1]), .B0(pcon[1]), .B1(n170), .Y(n256)
         );
  AO22X1 U419 ( .A0(n169), .A1(in_sfr[0]), .B0(pcon[0]), .B1(n170), .Y(n255)
         );
  OAI222X1 U420 ( .A0(n51), .A1(n60), .B0(n52), .B1(n300), .C0(n53), .C1(n62), 
        .Y(n263) );
  OAI31X1 U421 ( .A0(n5), .A1(sbuf_rxd_tmp_11_), .A2(n293), .B0(n276), .Y(n62)
         );
  OAI32X1 U422 ( .A0(n28), .A1(n29), .A2(n30), .B0(trans), .B1(n28), .Y(n26)
         );
  OAI221X1 U423 ( .A0(n67), .A1(n274), .B0(n68), .B1(n315), .C0(n69), .Y(n236)
         );
  AOI33X1 U424 ( .A0(scon[7]), .A1(scon[3]), .A2(n28), .B0(scon[6]), .B1(n273), 
        .B2(n28), .Y(n69) );
  AO21X1 U425 ( .A0(n21), .A1(txd), .B0(n22), .Y(n2390) );
  AOI31X1 U426 ( .A0(trans), .A1(n297), .A2(n24), .B0(n21), .Y(n22) );
  CLKINVX1 U427 ( .A(n25), .Y(n21) );
  NAND2BX1 U428 ( .AN(n26), .B(n27), .Y(n25) );
  NAND2BX1 U429 ( .AN(n8), .B(n9), .Y(n6) );
  AOI31X1 U430 ( .A0(n315), .A1(n274), .A2(sbuf_txd_8_), .B0(n20), .Y(n8) );
  OAI221X1 U431 ( .A0(sbuf_rxd_tmp_0_), .A1(n271), .B0(n11), .B1(n12), .C0(
        receive), .Y(n9) );
  NAND2BX1 U432 ( .AN(receive), .B(trans3), .Y(n20) );
  OAI2BB1X1 U433 ( .A0N(txd), .A1N(n3), .B0(n4), .Y(txdo) );
  CLKINVX1 U434 ( .A(n6), .Y(n3) );
  AOI32X1 U435 ( .A0(n5), .A1(div12), .A2(n6), .B0(txd), .B1(n7), .Y(n4) );
  NAND4BX1 U436 ( .AN(n15), .B(n287), .C(n271), .D(n275), .Y(n11) );
  NAND3BX1 U437 ( .AN(sbuf_rxd_tmp_10_), .B(sbuf_rxd_tmp_1_), .C(
        sbuf_rxd_tmp_0_), .Y(n15) );
  NAND4BX1 U438 ( .AN(n13), .B(sbuf_rxd_tmp_5_), .C(sbuf_rxd_tmp_7_), .D(
        sbuf_rxd_tmp_6_), .Y(n12) );
  NAND3BX1 U439 ( .AN(n286), .B(sbuf_rxd_tmp_3_), .C(sbuf_rxd_tmp_4_), .Y(n13)
         );
  NAND2X1 U440 ( .A(n340), .B(sbuf_txd_6_), .Y(n330) );
  NAND2BX1 U441 ( .AN(tx_done), .B(n51), .Y(n53) );
  NAND2BX1 U442 ( .AN(n28), .B(n34), .Y(n2400) );
  OAI221X1 U443 ( .A0(n35), .A1(n36), .B0(n24), .B1(n27), .C0(trans), .Y(n34)
         );
  AO22X1 U444 ( .A0(trans_cnt[0]), .A1(n37), .B0(n311), .B1(n38), .Y(n223) );
  AO22X1 U445 ( .A0(trans_cnt[1]), .A1(n37), .B0(N308), .B1(n38), .Y(n224) );
  XNOR2X1 U446 ( .A(trans_cnt[0]), .B(n307), .Y(N308) );
  AO22X1 U447 ( .A0(trans_cnt[2]), .A1(n37), .B0(N309), .B1(n38), .Y(n225) );
  XNOR2X1 U448 ( .A(n384), .B(n299), .Y(N309) );
  CLKINVX1 U449 ( .A(n385), .Y(n384) );
  AO22X1 U450 ( .A0(trans_cnt[3]), .A1(n37), .B0(N310), .B1(n38), .Y(n226) );
  XNOR2X1 U451 ( .A(n386), .B(n3100), .Y(N310) );
  NOR2X1 U452 ( .A(n385), .B(n299), .Y(n386) );
  OAI2BB2X1 U453 ( .A0N(scon[7]), .A1N(n28), .B0(n67), .B1(n315), .Y(n237) );
  OAI32X1 U454 ( .A0(n31), .A1(n28), .A2(n288), .B0(n24), .B1(n27), .Y(n238)
         );
  AOI32X1 U455 ( .A0(n29), .A1(tx_done), .A2(n27), .B0(n30), .B1(n33), .Y(n31)
         );
  NAND4BX1 U456 ( .AN(rec_cnt[2]), .B(n3080), .C(rec_cnt[3]), .D(rec_cnt[0]), 
        .Y(n134) );
  AOI32X1 U457 ( .A0(n136), .A1(scon[4]), .A2(n137), .B0(n138), .B1(rx_done), 
        .Y(n135) );
  NOR2BX1 U458 ( .AN(n318), .B(scon[0]), .Y(n136) );
  NAND3X1 U459 ( .A(rec_sync), .B(shift12), .C(n5), .Y(n127) );
  NAND3BX1 U460 ( .AN(n105), .B(n279), .C(n292), .Y(n104) );
  NAND3BX1 U461 ( .AN(sbuf_txd_7_), .B(n291), .C(n274), .Y(n105) );
  NOR2BX1 U462 ( .AN(N249), .B(n317), .Y(n2490) );
  NAND2BX1 U463 ( .AN(n7), .B(shift12_1), .Y(n29) );
  NAND2BX1 U464 ( .AN(scon[4]), .B(n146), .Y(n145) );
  NAND2X1 U465 ( .A(n33), .B(trans), .Y(n36) );
  NAND2BX1 U466 ( .AN(sbuf_txd_0_), .B(n30), .Y(n24) );
  CLKINVX1 U467 ( .A(n164), .Y(n146) );
  NAND3BX1 U468 ( .AN(n5), .B(rx_done), .C(n133), .Y(n164) );
  NAND4X1 U469 ( .A(n277), .B(n315), .C(n370), .D(n371), .Y(n35) );
  CLKINVX1 U470 ( .A(n103), .Y(n370) );
  CLKINVX1 U471 ( .A(n104), .Y(n371) );
  NAND3BX1 U472 ( .AN(sbuf_txd_4_), .B(n289), .C(n278), .Y(n103) );
  OAI222X1 U473 ( .A0(n110), .A1(n122), .B0(n123), .B1(n110), .C0(n271), .C1(
        n112), .Y(n211) );
  NAND3BX1 U474 ( .AN(n284), .B(rx_same[1]), .C(n125), .Y(n123) );
  AO21X1 U475 ( .A0(n126), .A1(n127), .B0(n128), .Y(n122) );
  OA22X1 U476 ( .A0(n129), .A1(n284), .B0(n129), .B1(n305), .Y(n126) );
  AO22X1 U477 ( .A0(N313), .A1(n125), .B0(n161), .B1(rec_cnt[2]), .Y(n198) );
  XNOR2X1 U478 ( .A(n381), .B(n302), .Y(N313) );
  CLKINVX1 U479 ( .A(n382), .Y(n381) );
  AO22X1 U480 ( .A0(n3120), .A1(n125), .B0(n161), .B1(rec_cnt[0]), .Y(n196) );
  AO22X1 U481 ( .A0(rx_same[0]), .A1(n150), .B0(n151), .B1(rxdi), .Y(n194) );
  CLKINVX1 U482 ( .A(n150), .Y(n151) );
  NAND4BX1 U483 ( .AN(rec_cnt[3]), .B(rec_cnt[0]), .C(n152), .D(n125), .Y(n150) );
  NOR2BX1 U484 ( .AN(rec_cnt[2]), .B(n3080), .Y(n152) );
  AO22X1 U485 ( .A0(rx_same[1]), .A1(n147), .B0(n148), .B1(rxdi), .Y(n195) );
  CLKINVX1 U486 ( .A(n147), .Y(n148) );
  NAND4BX1 U487 ( .AN(rec_cnt[2]), .B(n3080), .C(n149), .D(n125), .Y(n147) );
  NOR2BX1 U488 ( .AN(rec_cnt[3]), .B(rec_cnt[0]), .Y(n149) );
  AO22X1 U489 ( .A0(N312), .A1(n125), .B0(n161), .B1(rec_cnt[1]), .Y(n197) );
  XNOR2X1 U490 ( .A(n380), .B(n3080), .Y(N312) );
  AO22X1 U491 ( .A0(N314), .A1(n125), .B0(n161), .B1(rec_cnt[3]), .Y(n199) );
  XNOR2X1 U492 ( .A(n383), .B(n3090), .Y(N314) );
  NOR2X1 U493 ( .A(n382), .B(n302), .Y(n383) );
  AO22X1 U494 ( .A0(n110), .A1(sbuf_rxd_tmp_10_), .B0(n111), .B1(
        sbuf_rxd_tmp_11_), .Y(n210) );
  AO22X1 U495 ( .A0(sbuf_rxd_tmp_9_), .A1(n110), .B0(sbuf_rxd_tmp_10_), .B1(
        n111), .Y(n209) );
  AND3X2 U496 ( .A(shift_rec), .B(receive), .C(n7), .Y(n316) );
  OAI221X1 U497 ( .A0(n298), .A1(n112), .B0(n283), .B1(n113), .C0(n116), .Y(
        n200) );
  OAI31X1 U498 ( .A0(n114), .A1(rxdi), .A2(n296), .B0(n156), .Y(n192) );
  AOI32X1 U499 ( .A0(n137), .A1(n157), .A2(n133), .B0(rx_done), .B1(receive), 
        .Y(n156) );
  NOR2BX1 U500 ( .AN(scon[4]), .B(scon[0]), .Y(n157) );
  AO21X1 U501 ( .A0(scon[7]), .A1(n285), .B0(tf1), .Y(n42) );
  OR2X1 U502 ( .A(pcon[7]), .B(smod_clk_rec), .Y(n46) );
  OR2X1 U503 ( .A(pcon[7]), .B(smod_clk_trans), .Y(n44) );
  XNOR2X1 U504 ( .A(div12), .B(n175), .Y(n250) );
  NAND3BX1 U505 ( .AN(cnt0_4[3]), .B(n304), .C(n177), .Y(n175) );
  XNOR2X1 U506 ( .A(cnt0_4[2]), .B(cnt0_4[1]), .Y(n177) );
  AND2X2 U507 ( .A(n318), .B(n160), .Y(n317) );
  NAND4BX1 U508 ( .AN(cnt1_8[0]), .B(cnt1_8[3]), .C(n180), .D(n181), .Y(n160)
         );
  AND4X1 U509 ( .A(n186), .B(n187), .C(n188), .D(n189), .Y(n181) );
  NOR2BX1 U510 ( .AN(n185), .B(cnt1_8[2]), .Y(n180) );
  NAND2BX1 U511 ( .AN(pcon[7]), .B(n42), .Y(n43) );
  AND4X1 U512 ( .A(n320), .B(cnt0_4[1]), .C(cnt0_4[3]), .D(cnt0_4[0]), .Y(n319) );
  NOR2BX1 U513 ( .AN(N241), .B(n319), .Y(n254) );
  XNOR2X1 U514 ( .A(n390), .B(n303), .Y(N241) );
  NOR2X1 U515 ( .A(n389), .B(n320), .Y(n390) );
  NOR2BX1 U516 ( .AN(N242), .B(n317), .Y(n2420) );
  CLKBUFX3 U517 ( .A(rec_cnt[0]), .Y(n380) );
  CLKBUFX3 U518 ( .A(cnt0_4[0]), .Y(n387) );
  AO22X1 U519 ( .A0(sbuf[0]), .A1(rx_done), .B0(sbuf_rxd_tmp_3_), .B1(n276), 
        .Y(n212) );
  AO22X1 U520 ( .A0(sbuf[1]), .A1(rx_done), .B0(sbuf_rxd_tmp_4_), .B1(n276), 
        .Y(n213) );
  AO22X1 U521 ( .A0(sbuf[2]), .A1(rx_done), .B0(sbuf_rxd_tmp_5_), .B1(n276), 
        .Y(n214) );
  AO22X1 U522 ( .A0(sbuf[3]), .A1(rx_done), .B0(sbuf_rxd_tmp_6_), .B1(n276), 
        .Y(n215) );
  AO22X1 U523 ( .A0(sbuf[4]), .A1(rx_done), .B0(sbuf_rxd_tmp_7_), .B1(n276), 
        .Y(n216) );
  AO22X1 U524 ( .A0(sbuf[5]), .A1(rx_done), .B0(sbuf_rxd_tmp_8_), .B1(n276), 
        .Y(n217) );
  AO22X1 U525 ( .A0(sbuf[6]), .A1(rx_done), .B0(sbuf_rxd_tmp_9_), .B1(n276), 
        .Y(n218) );
  AO22X1 U526 ( .A0(sbuf[7]), .A1(rx_done), .B0(sbuf_rxd_tmp_10_), .B1(n276), 
        .Y(n219) );
  AO22X1 U527 ( .A0(n45), .A1(n42), .B0(smod_clk_rec), .B1(n43), .Y(n191) );
  CLKINVX1 U528 ( .A(n46), .Y(n45) );
  AO22X1 U529 ( .A0(n41), .A1(n42), .B0(smod_clk_trans), .B1(n43), .Y(n222) );
  CLKINVX1 U530 ( .A(n44), .Y(n41) );
  OAI2BB1X1 U531 ( .A0N(rec_sync), .A1N(receive), .B0(n160), .Y(n2410) );
  OAI211X1 U532 ( .A0(n153), .A1(n5), .B0(n154), .C0(n132), .Y(n193) );
  NOR2BX1 U533 ( .AN(rx_done), .B(sbuf_rxd_tmp_0_), .Y(n154) );
  AND4X1 U534 ( .A(rec_cnt[3]), .B(rec_cnt[0]), .C(n3080), .D(n302), .Y(n153)
         );
  CLKINVX6 U535 ( .A(rst_p), .Y(n184) );
  NAND2BX1 U536 ( .AN(scon[0]), .B(n280), .Y(uart_int) );
  DFFRX1 sbuf_rxd_reg_2_ ( .D(n214), .CK(clk), .RN(n184), .Q(sbuf[2]) );
  DFFRX1 sbuf_rxd_reg_3_ ( .D(n215), .CK(clk), .RN(n184), .Q(sbuf[3]) );
  DFFRX1 sbuf_rxd_reg_4_ ( .D(n216), .CK(clk), .RN(n184), .Q(sbuf[4]) );
  DFFRX1 pcon_reg_0_ ( .D(n255), .CK(clk), .RN(n184), .Q(pcon[0]) );
  DFFRX1 pcon_reg_2_ ( .D(n257), .CK(clk), .RN(n184), .Q(pcon[2]) );
  DFFRX1 pcon_reg_3_ ( .D(n258), .CK(clk), .RN(n184), .Q(pcon[3]) );
  DFFRX1 scon_reg_5_ ( .D(n268), .CK(clk), .RN(n184), .Q(scon[5]), .QN(n293)
         );
  DFFRX1 pcon_reg_4_ ( .D(n259), .CK(clk), .RN(n184), .Q(pcon[4]), .QN(n326)
         );
  DFFRX1 pcon_reg_5_ ( .D(n260), .CK(clk), .RN(n184), .Q(pcon[5]), .QN(n325)
         );
  DFFRX1 pcon_reg_6_ ( .D(n261), .CK(clk), .RN(n184), .Q(pcon[6]), .QN(n324)
         );
  DFFRX1 scon_reg_2_ ( .D(n265), .CK(clk), .RN(n184), .Q(scon[2]) );
  DFFRX1 scon_reg_3_ ( .D(n266), .CK(clk), .RN(n184), .Q(scon[3]), .QN(n322)
         );
  DFFRX1 sbuf_rxd_tmp_reg_2_ ( .D(n202), .CK(clk), .RN(n184), .QN(n286) );
  DFFRX1 sbuf_rxd_tmp_reg_10_ ( .D(n210), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_10_) );
  DFFRX1 receive_reg ( .D(n192), .CK(clk), .RN(n184), .Q(receive), .QN(n318)
         );
  DFFRX1 sbuf_rxd_tmp_reg_0_ ( .D(n200), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_0_), .QN(n298) );
  DFFRX1 sbuf_rxd_tmp_reg_6_ ( .D(n206), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_6_), .QN(n281) );
  DFFRX1 sbuf_rxd_tmp_reg_7_ ( .D(n207), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_7_), .QN(n294) );
  DFFRX1 sbuf_rxd_tmp_reg_5_ ( .D(n205), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_5_), .QN(n272) );
  DFFRX1 sbuf_rxd_tmp_reg_11_ ( .D(n211), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_11_), .QN(n271) );
  DFFRX1 sbuf_rxd_tmp_reg_4_ ( .D(n204), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_4_), .QN(n295) );
  DFFRX1 sbuf_rxd_tmp_reg_3_ ( .D(n203), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_3_), .QN(n282) );
  DFFRX1 sbuf_rxd_tmp_reg_1_ ( .D(n201), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_1_), .QN(n283) );
  DFFRX1 sbuf_rxd_tmp_reg_9_ ( .D(n209), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_9_), .QN(n287) );
  DFFRX1 sbuf_txd_reg_10_ ( .D(n237), .CK(clk), .RN(n184), .QN(n315) );
  DFFRX1 sbuf_rxd_tmp_reg_8_ ( .D(n208), .CK(clk), .RN(n184), .Q(
        sbuf_rxd_tmp_8_), .QN(n275) );
  DFFRX1 sbuf_txd_reg_9_ ( .D(n236), .CK(clk), .RN(n184), .QN(n274) );
  DFFRX1 txd_reg ( .D(n2390), .CK(clk), .RN(n184), .Q(txd) );
  DFFRX1 div12_reg ( .D(n250), .CK(clk), .RN(n184), .Q(div12) );
  DFFQX1 trans3_reg ( .D(trans2), .CK(clk), .Q(trans3) );
  DFFRX1 sbuf_txd_reg_5_ ( .D(n232), .CK(clk), .RN(n184), .Q(sbuf_txd_5_), 
        .QN(n292) );
  DFFRX1 trans_reg ( .D(n2400), .CK(clk), .RN(n184), .Q(trans), .QN(n288) );
  DFFRX1 trans_cnt_reg_2_ ( .D(n225), .CK(clk), .RN(n184), .Q(trans_cnt[2]), 
        .QN(n299) );
  DFFRX1 rec_cnt_reg_1_ ( .D(n197), .CK(clk), .RN(n184), .Q(rec_cnt[1]), .QN(
        n3080) );
  DFFRX1 cnt1_8_reg_0_ ( .D(n2420), .CK(clk), .RN(n184), .Q(cnt1_8[0]) );
  DFFRX1 rec_cnt_reg_3_ ( .D(n199), .CK(clk), .RN(n184), .Q(rec_cnt[3]), .QN(
        n3090) );
  DFFRX1 sbuf_txd_reg_3_ ( .D(n230), .CK(clk), .RN(n184), .Q(sbuf_txd_3_), 
        .QN(n289) );
  DFFRX1 shift_rec_reg ( .D(n190), .CK(clk), .RN(n184), .Q(shift_rec) );
  DFFRX1 sbuf_txd_reg_7_ ( .D(n234), .CK(clk), .RN(n184), .Q(sbuf_txd_7_) );
  DFFRX1 rec_sync_reg ( .D(n2410), .CK(clk), .RN(n184), .Q(rec_sync) );
  DFFRX1 sbuf_txd_reg_4_ ( .D(n231), .CK(clk), .RN(n184), .Q(sbuf_txd_4_) );
  DFFRX1 sbuf_txd_reg_1_ ( .D(n228), .CK(clk), .RN(n184), .QN(n277) );
  DFFRX1 sbuf_txd_reg_2_ ( .D(n229), .CK(clk), .RN(n184), .QN(n278) );
  DFFRX1 cnt1_8_reg_1_ ( .D(n2430), .CK(clk), .RN(n184), .Q(cnt1_8[1]), .QN(
        n185) );
  DFFRX1 cnt0_4_reg_0_ ( .D(n251), .CK(clk), .RN(n184), .Q(cnt0_4[0]), .QN(
        n304) );
  DFFRX1 cnt0_4_reg_1_ ( .D(n252), .CK(clk), .RN(n184), .Q(cnt0_4[1]), .QN(
        n306) );
  DFFRX1 trans_cnt_reg_1_ ( .D(n224), .CK(clk), .RN(n184), .Q(trans_cnt[1]), 
        .QN(n307) );
  DFFRX1 cnt0_4_reg_3_ ( .D(n254), .CK(clk), .RN(n184), .Q(cnt0_4[3]), .QN(
        n303) );
  DFFRX1 rx_same_reg_1_ ( .D(n195), .CK(clk), .RN(n184), .Q(rx_same[1]), .QN(
        n305) );
  DFFRX1 cnt0_4_reg_2_ ( .D(n253), .CK(clk), .RN(n184), .Q(cnt0_4[2]), .QN(
        n320) );
  DFFRX1 tx_done_reg ( .D(n238), .CK(clk), .RN(n184), .Q(tx_done), .QN(n301)
         );
  DFFRX1 rx_same_reg_0_ ( .D(n194), .CK(clk), .RN(n184), .Q(rx_same[0]), .QN(
        n284) );
  DFFRX1 smod_clk_rec_reg ( .D(n191), .CK(clk), .RN(n184), .Q(smod_clk_rec) );
  DFFRX1 smod_clk_trans_reg ( .D(n222), .CK(clk), .RN(n184), .Q(smod_clk_trans) );
  DFFRX1 sbuf_txd_reg_0_ ( .D(n227), .CK(clk), .RN(n184), .Q(sbuf_txd_0_), 
        .QN(n297) );
  DFFRX1 cnt1_8_reg_3_ ( .D(n2450), .CK(clk), .RN(n184), .Q(cnt1_8[3]) );
  DFFSX1 rxdi_r_reg ( .D(n220), .CK(clk), .SN(n184), .QN(n296) );
  DFFRX1 cnt1_8_reg_2_ ( .D(n2440), .CK(clk), .RN(n184), .Q(cnt1_8[2]) );
  DFFRX1 cnt1_8_reg_4_ ( .D(n2460), .CK(clk), .RN(n184), .Q(cnt1_8[4]), .QN(
        n186) );
  DFFRX1 cnt1_8_reg_5_ ( .D(n2470), .CK(clk), .RN(n184), .Q(cnt1_8[5]), .QN(
        n187) );
  DFFRX1 shift_trans_reg ( .D(n221), .CK(clk), .RN(n184), .QN(n327) );
  DFFRX1 cnt1_8_reg_7_ ( .D(n2490), .CK(clk), .RN(n184), .Q(cnt1_8[7]), .QN(
        n189) );
  DFFRX1 cnt1_8_reg_6_ ( .D(n2480), .CK(clk), .RN(n184), .Q(cnt1_8[6]), .QN(
        n188) );
  DFFQX1 shift12_1_reg ( .D(shift12), .CK(clk), .Q(shift12_1) );
  INVX1 U537 ( .A(addr_sfr[1]), .Y(n379) );
  NOR2X1 U538 ( .A(addr_sfr[4]), .B(addr_sfr[3]), .Y(n374) );
  NAND2X1 U539 ( .A(addr_sfr[4]), .B(addr_sfr[3]), .Y(n373) );
  INVX1 U540 ( .A(addr_sfr[0]), .Y(n321) );
  INVX1 U541 ( .A(addr_sfr[5]), .Y(n376) );
  NAND2X1 U542 ( .A(addr_sfr[2]), .B(addr_sfr[0]), .Y(n378) );
  NOR3X1 U543 ( .A(n373), .B(addr_sfr[2]), .C(addr_sfr[1]), .Y(n372) );
  NOR2BX4 U544 ( .AN(n328), .B(n329), .Y(n83) );
  AOI21X4 U545 ( .A0(in_sfr[7]), .A1(n331), .B0(n332), .Y(n80) );
  AOI21X4 U546 ( .A0(n28), .A1(in_sfr[7]), .B0(n331), .Y(n72) );
  DFFRX1 sbuf_rxd_reg_0_ ( .D(n212), .CK(clk), .RN(n184), .Q(sbuf[0]) );
  u_uart_DW01_inc_8_0 add_160 ( .A(cnt1_8), .SUM({N249, N248, N247, N246, N245, 
        N244, N243, N242}) );
  DFFRX4 scon_reg_7_ ( .D(n270), .CK(clk), .RN(n184), .Q(scon[7]), .QN(n273)
         );
  DFFRX4 scon_reg_4_ ( .D(n267), .CK(clk), .RN(n184), .Q(scon[4]), .QN(n290)
         );
  DFFRX4 scon_reg_1_ ( .D(n264), .CK(clk), .RN(n184), .Q(scon[1]), .QN(n280)
         );
  DFFRX4 scon_reg_0_ ( .D(n263), .CK(clk), .RN(n184), .Q(scon[0]), .QN(n300)
         );
  DFFRX4 pcon_reg_1_ ( .D(n256), .CK(clk), .RN(n184), .Q(pcon[1]) );
  DFFRX4 sbuf_rxd_reg_1_ ( .D(n213), .CK(clk), .RN(n184), .Q(sbuf[1]) );
endmodule


module u_uart_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1;

  XNOR2X1 U5 ( .A(carry_7_), .B(n1), .Y(SUM[7]) );
  CLKINVX1 U6 ( .A(A[7]), .Y(n1) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  CLKINVX1 U7 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module gpio1 ( clk, rst_p, wr, rmw, combus, prt1_addr, p1_in, p1, p1_out );
  input [7:0] combus;
  input [7:0] prt1_addr;
  input [7:0] p1_in;
  output [7:0] p1;
  output [7:0] p1_out;
  input clk, rst_p, wr, rmw;
  wire   n2, n3, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44;

  MXI2X1 U24 ( .S0(rmw), .B(n23), .A(n31), .Y(p1[1]) );
  CLKINVX3 U25 ( .A(p1_in[1]), .Y(n31) );
  INVX1 U26 ( .A(prt1_addr[7]), .Y(n21) );
  OR3X1 U27 ( .A(prt1_addr[5]), .B(prt1_addr[6]), .C(prt1_addr[3]), .Y(n40) );
  CLKINVX1 U28 ( .A(n3), .Y(n2) );
  DFFSX1 p1_out_reg_0_ ( .D(n8), .CK(clk), .SN(n7), .Q(p1_out[0]), .QN(n24) );
  DFFSX1 p1_out_reg_2_ ( .D(n10), .CK(clk), .SN(n7), .Q(p1_out[2]), .QN(n22)
         );
  MXI2X1 U29 ( .S0(n2), .B(n33), .A(n20), .Y(n15) );
  INVX1 U30 ( .A(combus[7]), .Y(n33) );
  MXI2X1 U31 ( .S0(n2), .B(n34), .A(n19), .Y(n14) );
  INVX1 U32 ( .A(combus[6]), .Y(n34) );
  MXI2X1 U33 ( .S0(n2), .B(n35), .A(n17), .Y(n13) );
  INVX1 U34 ( .A(combus[5]), .Y(n35) );
  MXI2X1 U35 ( .S0(n2), .B(n36), .A(n16), .Y(n12) );
  INVX1 U36 ( .A(combus[4]), .Y(n36) );
  MXI2X1 U37 ( .S0(n2), .B(n37), .A(n18), .Y(n11) );
  INVX1 U38 ( .A(combus[3]), .Y(n37) );
  NAND3X1 U39 ( .A(n38), .B(n39), .C(wr), .Y(n3) );
  NOR2X1 U40 ( .A(n40), .B(n41), .Y(n39) );
  NAND2X1 U41 ( .A(n42), .B(n43), .Y(n41) );
  MXI2X1 U42 ( .S0(rmw), .B(n16), .A(n28), .Y(p1[4]) );
  CLKINVX1 U43 ( .A(p1_in[4]), .Y(n28) );
  MXI2X1 U44 ( .S0(rmw), .B(n17), .A(n27), .Y(p1[5]) );
  CLKINVX1 U45 ( .A(p1_in[5]), .Y(n27) );
  MXI2X1 U46 ( .S0(rmw), .B(n24), .A(n32), .Y(p1[0]) );
  CLKINVX1 U47 ( .A(p1_in[0]), .Y(n32) );
  MXI2X1 U48 ( .S0(rmw), .B(n22), .A(n30), .Y(p1[2]) );
  CLKINVX1 U49 ( .A(p1_in[2]), .Y(n30) );
  MXI2X1 U50 ( .S0(rmw), .B(n18), .A(n29), .Y(p1[3]) );
  CLKINVX1 U51 ( .A(p1_in[3]), .Y(n29) );
  MXI2X1 U52 ( .S0(rmw), .B(n19), .A(n26), .Y(p1[6]) );
  CLKINVX1 U53 ( .A(p1_in[6]), .Y(n26) );
  MXI2X1 U54 ( .S0(rmw), .B(n20), .A(n25), .Y(p1[7]) );
  CLKINVX1 U55 ( .A(p1_in[7]), .Y(n25) );
  AO22X1 U56 ( .A0(combus[2]), .A1(n2), .B0(p1_out[2]), .B1(n3), .Y(n10) );
  AO22X1 U57 ( .A0(combus[1]), .A1(n2), .B0(p1_out[1]), .B1(n3), .Y(n9) );
  AO22X1 U58 ( .A0(combus[0]), .A1(n2), .B0(p1_out[0]), .B1(n3), .Y(n8) );
  INVX1 U59 ( .A(rst_p), .Y(n7) );
  INVX1 U60 ( .A(prt1_addr[4]), .Y(n44) );
  INVX1 U61 ( .A(prt1_addr[1]), .Y(n42) );
  NOR3X1 U62 ( .A(n21), .B(prt1_addr[0]), .C(n44), .Y(n38) );
  INVX1 U63 ( .A(prt1_addr[2]), .Y(n43) );
  DFFSX4 p1_out_reg_7_ ( .D(n15), .CK(clk), .SN(n7), .Q(p1_out[7]), .QN(n20)
         );
  DFFSX4 p1_out_reg_6_ ( .D(n14), .CK(clk), .SN(n7), .Q(p1_out[6]), .QN(n19)
         );
  DFFSX4 p1_out_reg_5_ ( .D(n13), .CK(clk), .SN(n7), .Q(p1_out[5]), .QN(n17)
         );
  DFFSX4 p1_out_reg_4_ ( .D(n12), .CK(clk), .SN(n7), .Q(p1_out[4]), .QN(n16)
         );
  DFFSX4 p1_out_reg_3_ ( .D(n11), .CK(clk), .SN(n7), .Q(p1_out[3]), .QN(n18)
         );
  DFFSX4 p1_out_reg_1_ ( .D(n9), .CK(clk), .SN(n7), .Q(p1_out[1]), .QN(n23) );
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
         N327, N328, N329, N330, N331, N332, N333, N334, N335, N336, N337, n15,
         n17, n19, n20, n21, n22, n23, n25, n26, n28, n29, n30, n31, n33, n34,
         n35, n37, n38, n40, n41, n42, n43, n44, n45, n46, n47, n54, n56, n58,
         n59, n61, n62, n64, n67, n69, n74, n79, n81, n82, n84, n88, n89, n90,
         n95, n96, n97, n100, n101, n102, n105, n106, n107, n110, n113, n114,
         n116, n129, n131, n133, n139, n140, n141, n143, n144, n145, n146,
         n147, n149, n151, n153, n155, n157, n158, n159, n160, n162, n163,
         n164, n166, n170, n171, n174, n179, n183, n184, n185, n188, n189,
         n190, n191, n192, n193, n194, n195, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n2230, n2240, n2250, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n239, n240, n241, n2420, n2430,
         n2440, n2450, n2470, n2480, n2490, n2500, n2510, n2520, n2530, n2540,
         n2550, n2560, n2570, n2580, n2590, n2600, n2610, n2620, n2630, n2640,
         n2650, n2660, n2670, n2680, n2690, n2700, n2710, n2720, n2730, n2740,
         n2750, n2760, n2770, n2780, n2790, n2800, n2810, n2820, n2830, n2840,
         n2850, n2860, n2870, n2880, n2890, n2900, n2910, n2920, n2930, n2940,
         n2950, n2960, n2970, n2980, n2990, n3000, n3010, n3020, n3030, n304,
         n305, n306, n307, n308, n309, n310, n311, n3120, n313, n314, n315,
         n316, n317, n318, n319, n320, n321, n3220, n3230, n3240, n3250, n3260,
         n3270, n3280, n3290, n3300, n3310, n3320, n3330, n3340, n3350, n3360,
         n3370, n338, n339, n340, n341, n342, n343, n344, n345, n346, n347,
         n348, n349, n350, n351, n352, n353, n354, n355, n356, n357, n358,
         n359, n360, n361, n362, n363, n364, n365, n366, n367, n368, n369,
         n370, n371, n372, n373, n374, n375, n376, n377, n378, n379, n380,
         n381, n382, n383, n384, n385, n386, n387, n388, n389, n390, n391,
         n392, n393, n394, n395, n396, n397, n398, n399, n400, n401, n402,
         n403, n404, n405, n406, n407, n408, n409, n410, n411, n412, n413,
         n414, n415, n416, n417, n418, n419, n420, n421, n422, n423, n424,
         n425, n426, n427, n428, n429, n430, n431, n432, n433, n434, n435,
         n436, n437, n438, n439, n440, n441, n442, n443, n444, n445, n446,
         n447, n448, n449, n450, n451, n452, n453, n454, n455, n456, n457,
         n458, n459, n460, n461, n462, n463, n464, n465, n466, n467, n468,
         n469, n470, n471, n472, n473, n474, n475, n476, n477, n478, n479,
         n480, n481, n482, n483, n484, n485, n486, n487, n488, n489, n490,
         n491, n492, n493;

  AO22X4 U37 ( .A0(n29), .A1(tl1[0]), .B0(n44), .B1(n31), .Y(n207) );
  OR2X1 U242 ( .A(n3330), .B(n345), .Y(n2560) );
  OR2X1 U243 ( .A(n3330), .B(n339), .Y(n2570) );
  AOI222X1 U244 ( .A0(th1[1]), .A1(n22), .B0(N243), .B1(n34), .C0(in_tc[1]), 
        .C1(n19), .Y(n43) );
  INVX1 U245 ( .A(n30), .Y(n414) );
  INVX1 U246 ( .A(n342), .Y(n69) );
  INVX1 U247 ( .A(n417), .Y(n33) );
  INVX1 U248 ( .A(n424), .Y(n37) );
  INVX1 U249 ( .A(in_tc[0]), .Y(n105) );
  NAND2X1 U250 ( .A(n62), .B(n371), .Y(n88) );
  AO22X1 U251 ( .A0(n29), .A1(tl1[1]), .B0(n41), .B1(n31), .Y(n208) );
  INVX1 U252 ( .A(n432), .Y(n40) );
  NAND3X1 U253 ( .A(tm1[1]), .B(n458), .C(n457), .Y(n411) );
  NAND3X1 U254 ( .A(tm1[0]), .B(n454), .C(n174), .Y(n409) );
  INVX1 U255 ( .A(tm1[0]), .Y(n484) );
  MX2X1 U256 ( .S0(sel_tc1), .B(n485), .A(n2530), .Y(n2880) );
  MX2X1 U257 ( .S0(sel_tc0), .B(n474), .A(n2530), .Y(n2920) );
  INVX1 U258 ( .A(tm1[1]), .Y(n454) );
  NAND2X1 U259 ( .A(tm0[0]), .B(n193), .Y(n3330) );
  INVX1 U260 ( .A(tm0[1]), .Y(n193) );
  INVX1 U261 ( .A(tr1), .Y(n163) );
  INVX1 U262 ( .A(tr0), .Y(n475) );
  CLKINVX1 U263 ( .A(n2970), .Y(n2960) );
  CLKINVX1 U264 ( .A(n81), .Y(n145) );
  CLKINVX1 U265 ( .A(n62), .Y(n3290) );
  CLKINVX1 U266 ( .A(n470), .Y(n146) );
  CLKINVX1 U267 ( .A(n179), .Y(n174) );
  NAND2BX1 U268 ( .AN(n164), .B(n47), .Y(n179) );
  CLKINVX1 U269 ( .A(n47), .Y(n19) );
  CLKINVX1 U270 ( .A(n114), .Y(n164) );
  CLKINVX1 U271 ( .A(n438), .Y(n162) );
  NAND2X1 U272 ( .A(n310), .B(n61), .Y(n308) );
  NAND2X1 U273 ( .A(n2770), .B(n2970), .Y(n62) );
  NAND2X1 U274 ( .A(n2750), .B(n2970), .Y(n81) );
  CLKINVX1 U275 ( .A(n469), .Y(n144) );
  NAND3X1 U276 ( .A(n62), .B(n89), .C(n81), .Y(n470) );
  NAND2X1 U277 ( .A(n2960), .B(n2750), .Y(n114) );
  CLKINVX1 U278 ( .A(n143), .Y(n307) );
  NAND2X1 U279 ( .A(n2960), .B(n2770), .Y(n47) );
  NAND2X1 U280 ( .A(n470), .B(n469), .Y(n438) );
  NAND2X1 U281 ( .A(n310), .B(n81), .Y(n309) );
  CLKINVX1 U282 ( .A(n84), .Y(n356) );
  NOR2X1 U283 ( .A(n81), .B(n61), .Y(n466) );
  NAND2X1 U284 ( .A(n19), .B(in_tc[6]), .Y(n3020) );
  NAND2X1 U285 ( .A(in_tc[7]), .B(n3290), .Y(n3000) );
  INVX1 U286 ( .A(in_tc[7]), .Y(n61) );
  NAND2X1 U287 ( .A(n164), .B(in_tc[7]), .Y(n382) );
  NAND2X1 U288 ( .A(n164), .B(in_tc[4]), .Y(n395) );
  NAND2X1 U289 ( .A(n19), .B(in_tc[4]), .Y(n420) );
  NAND2X1 U290 ( .A(n164), .B(in_tc[5]), .Y(n391) );
  NAND2X1 U291 ( .A(n164), .B(in_tc[6]), .Y(n387) );
  NAND2X1 U292 ( .A(n164), .B(in_tc[3]), .Y(n399) );
  NAND2X1 U293 ( .A(n19), .B(in_tc[5]), .Y(n413) );
  NAND2X1 U294 ( .A(n19), .B(in_tc[3]), .Y(n427) );
  NAND2X1 U295 ( .A(in_tc[2]), .B(n19), .Y(n435) );
  INVX1 U296 ( .A(in_tc[2]), .Y(n95) );
  CLKINVX1 U297 ( .A(n139), .Y(n140) );
  AND3X1 U298 ( .A(addr_tc[2]), .B(n486), .C(n2800), .Y(n2750) );
  NAND3BX1 U299 ( .AN(n110), .B(n369), .C(n62), .Y(n59) );
  CLKINVX1 U300 ( .A(n31), .Y(n29) );
  AND2X2 U301 ( .A(n21), .B(n116), .Y(n2760) );
  NAND3X1 U302 ( .A(n62), .B(n58), .C(n81), .Y(n469) );
  CLKINVX1 U303 ( .A(n116), .Y(n383) );
  CLKINVX1 U304 ( .A(n481), .Y(n34) );
  NAND2X1 U305 ( .A(n88), .B(n62), .Y(n84) );
  NAND3X1 U306 ( .A(n79), .B(n81), .C(n139), .Y(n143) );
  CLKINVX1 U307 ( .A(n408), .Y(n22) );
  AND3X1 U308 ( .A(addr_tc[1]), .B(n480), .C(n2800), .Y(n2770) );
  CLKINVX1 U309 ( .A(n403), .Y(n402) );
  CLKINVX1 U310 ( .A(n346), .Y(n3300) );
  AND2X2 U311 ( .A(n346), .B(n62), .Y(n2780) );
  CLKINVX1 U312 ( .A(n311), .Y(n310) );
  AND2X2 U313 ( .A(n34), .B(n116), .Y(n2790) );
  CLKINVX1 U314 ( .A(n88), .Y(n192) );
  CLKINVX1 U315 ( .A(n113), .Y(n369) );
  CLKINVX1 U316 ( .A(n361), .Y(n89) );
  NAND3X1 U317 ( .A(n463), .B(n464), .C(n465), .Y(n314) );
  NAND2X1 U318 ( .A(N301), .B(n144), .Y(n463) );
  NAND2X1 U319 ( .A(N284), .B(n146), .Y(n464) );
  NAND2X1 U320 ( .A(in_tc[6]), .B(n145), .Y(n465) );
  NAND3X1 U321 ( .A(n448), .B(n403), .C(n449), .Y(n400) );
  NAND2X1 U322 ( .A(n2820), .B(n450), .Y(n448) );
  NAND3X1 U323 ( .A(n437), .B(n450), .C(n61), .Y(n449) );
  CLKINVX1 U324 ( .A(n455), .Y(n450) );
  OAI21X1 U325 ( .A0(n2540), .A1(n403), .B0(n349), .Y(n213) );
  NAND3X1 U326 ( .A(n445), .B(n446), .C(n447), .Y(n320) );
  NAND2X1 U327 ( .A(N299), .B(n144), .Y(n445) );
  NAND2X1 U328 ( .A(N282), .B(n146), .Y(n446) );
  NAND2X1 U329 ( .A(n145), .B(in_tc[4]), .Y(n447) );
  NAND3X1 U330 ( .A(n460), .B(n461), .C(n462), .Y(n317) );
  NAND2X1 U331 ( .A(N300), .B(n144), .Y(n460) );
  NAND2X1 U332 ( .A(N283), .B(n146), .Y(n461) );
  NAND2X1 U333 ( .A(in_tc[5]), .B(n145), .Y(n462) );
  NAND3X1 U334 ( .A(n442), .B(n443), .C(n444), .Y(n3230) );
  NAND2X1 U335 ( .A(N298), .B(n144), .Y(n442) );
  NAND2X1 U336 ( .A(N281), .B(n146), .Y(n443) );
  NAND2X1 U337 ( .A(n145), .B(in_tc[3]), .Y(n444) );
  NAND3X1 U338 ( .A(n439), .B(n440), .C(n441), .Y(n3260) );
  NAND2X1 U339 ( .A(N297), .B(n144), .Y(n439) );
  NAND2X1 U340 ( .A(N280), .B(n146), .Y(n440) );
  NAND2X1 U341 ( .A(in_tc[2]), .B(n145), .Y(n441) );
  INVX1 U342 ( .A(in_tc[1]), .Y(n100) );
  MXI2X1 U343 ( .S0(n29), .B(n2550), .A(n414), .Y(n211) );
  NAND3X1 U344 ( .A(n415), .B(n416), .C(n33), .Y(n30) );
  NAND2X1 U345 ( .A(N260), .B(n21), .Y(n415) );
  NAND3X1 U346 ( .A(n350), .B(n351), .C(n352), .Y(n229) );
  NOR2X1 U347 ( .A(n353), .B(n354), .Y(n351) );
  NAND2X1 U348 ( .A(n355), .B(n356), .Y(n350) );
  NAND2X1 U349 ( .A(n3290), .B(in_tc[4]), .Y(n352) );
  NAND3X1 U350 ( .A(n364), .B(n365), .C(n366), .Y(n228) );
  NOR2X1 U351 ( .A(n367), .B(n368), .Y(n365) );
  NAND2X1 U352 ( .A(n370), .B(n356), .Y(n364) );
  NAND2X1 U353 ( .A(n3290), .B(in_tc[3]), .Y(n366) );
  OAI222X1 U354 ( .A0(n2580), .A1(n139), .B0(n140), .B1(n159), .C0(n160), .C1(
        n143), .Y(n233) );
  CLKINVX1 U355 ( .A(N330), .Y(n160) );
  AOI222X1 U356 ( .A0(N295), .A1(n144), .B0(n145), .B1(in_tc[0]), .C0(N278), 
        .C1(n146), .Y(n159) );
  OAI222X1 U357 ( .A0(n2500), .A1(n139), .B0(n140), .B1(n157), .C0(n158), .C1(
        n143), .Y(n234) );
  CLKINVX1 U358 ( .A(N331), .Y(n158) );
  AOI222X1 U359 ( .A0(N296), .A1(n144), .B0(n145), .B1(in_tc[1]), .C0(N279), 
        .C1(n146), .Y(n157) );
  OAI221X1 U360 ( .A0(n100), .A1(n62), .B0(n101), .B1(n84), .C0(n102), .Y(n226) );
  AOI222X1 U361 ( .A0(N331), .A1(n56), .B0(N274), .B1(n89), .C0(N288), .C1(n58), .Y(n101) );
  OA22X1 U362 ( .A0(n59), .A1(n2500), .B0(n2590), .B1(n88), .Y(n102) );
  NAND2X1 U363 ( .A(n2900), .B(n81), .Y(n371) );
  NAND2X1 U364 ( .A(n62), .B(n347), .Y(n346) );
  OAI21X1 U365 ( .A0(n348), .A1(n144), .B0(n2900), .Y(n347) );
  AOI21X1 U366 ( .A0(n188), .A1(n113), .B0(n145), .Y(n348) );
  CLKINVX1 U367 ( .A(n411), .Y(n20) );
  NAND2X1 U368 ( .A(n114), .B(n482), .Y(n116) );
  NAND2X1 U369 ( .A(n2860), .B(n483), .Y(n482) );
  NAND2X1 U370 ( .A(n481), .B(n409), .Y(n483) );
  CLKINVX1 U371 ( .A(n409), .Y(n21) );
  NAND2X1 U372 ( .A(n456), .B(n457), .Y(n408) );
  NOR2X1 U373 ( .A(n458), .B(n454), .Y(n456) );
  NOR2X1 U374 ( .A(n88), .B(n2480), .Y(n367) );
  NOR2X1 U375 ( .A(n88), .B(n2490), .Y(n353) );
  NAND2X1 U376 ( .A(n471), .B(n472), .Y(n139) );
  NAND2X1 U377 ( .A(n2900), .B(n438), .Y(n472) );
  NOR2X1 U378 ( .A(n145), .B(n476), .Y(n471) );
  NOR2X1 U379 ( .A(n3290), .B(n477), .Y(n476) );
  NAND2X1 U380 ( .A(n467), .B(n468), .Y(n311) );
  NAND2X1 U381 ( .A(N285), .B(n146), .Y(n467) );
  NAND2X1 U382 ( .A(N302), .B(n144), .Y(n468) );
  CLKINVX1 U383 ( .A(n453), .Y(n457) );
  NAND2X1 U384 ( .A(n457), .B(n454), .Y(n481) );
  NAND2X1 U385 ( .A(N328), .B(n20), .Y(n3030) );
  AND4X1 U386 ( .A(n2810), .B(addr_tc[3]), .C(wr), .D(addr_tc[7]), .Y(n2800)
         );
  NOR3X1 U387 ( .A(addr_tc[6]), .B(addr_tc[5]), .C(addr_tc[4]), .Y(n2810) );
  NAND2X1 U388 ( .A(n402), .B(n429), .Y(n31) );
  NAND2X1 U389 ( .A(n2860), .B(n34), .Y(n429) );
  NAND2X1 U390 ( .A(N324), .B(n20), .Y(n431) );
  NAND2X1 U391 ( .A(N325), .B(n20), .Y(n423) );
  NAND2X1 U392 ( .A(N326), .B(n20), .Y(n416) );
  NAND2X1 U393 ( .A(n47), .B(n451), .Y(n403) );
  NAND2X1 U394 ( .A(n2860), .B(n452), .Y(n451) );
  OAI21X1 U395 ( .A0(n453), .A1(n454), .B0(n409), .Y(n452) );
  AND2X2 U396 ( .A(n47), .B(n437), .Y(n2820) );
  OAI33X1 U397 ( .A0(n84), .A1(n195), .A2(n188), .B0(n84), .B1(n113), .B2(n110), .Y(n194) );
  CLKINVX1 U398 ( .A(N312), .Y(n195) );
  OAI32X1 U399 ( .A0(n31), .A1(n164), .A2(n2600), .B0(n29), .B1(n166), .Y(
        n2230) );
  AOI221X1 U400 ( .A0(N272), .A1(n21), .B0(N255), .B1(n34), .C0(n22), .Y(n166)
         );
  NAND2X1 U401 ( .A(n188), .B(n374), .Y(n56) );
  NAND2X1 U402 ( .A(n110), .B(n369), .Y(n374) );
  NAND4X1 U403 ( .A(n487), .B(n488), .C(n489), .D(n490), .Y(n110) );
  NOR2X1 U404 ( .A(n2520), .B(n2680), .Y(n487) );
  NOR2X1 U405 ( .A(n2490), .B(n2690), .Y(n488) );
  NOR2X1 U406 ( .A(n2590), .B(n2480), .Y(n489) );
  NAND2X1 U407 ( .A(n193), .B(n473), .Y(n361) );
  NAND2BX1 U408 ( .AN(n3330), .B(N294), .Y(n2830) );
  NAND2X1 U409 ( .A(n344), .B(n2560), .Y(n343) );
  NAND2X1 U410 ( .A(N335), .B(n56), .Y(n344) );
  NAND2X1 U411 ( .A(n338), .B(n2570), .Y(n3370) );
  NAND2X1 U412 ( .A(N336), .B(n56), .Y(n338) );
  NOR2X1 U413 ( .A(n2510), .B(n2470), .Y(n490) );
  NAND2X1 U414 ( .A(n473), .B(n479), .Y(n113) );
  CLKINVX1 U415 ( .A(n188), .Y(n79) );
  CLKINVX1 U416 ( .A(n3330), .Y(n58) );
  NAND2X1 U417 ( .A(n478), .B(n79), .Y(n477) );
  NOR2X1 U418 ( .A(n2530), .B(n163), .Y(n478) );
  NAND2X1 U419 ( .A(N337), .B(n56), .Y(n3320) );
  NAND2X1 U420 ( .A(n357), .B(n358), .Y(n355) );
  NAND2X1 U421 ( .A(N334), .B(n56), .Y(n358) );
  NOR2X1 U422 ( .A(n359), .B(n360), .Y(n357) );
  NOR2X1 U423 ( .A(n3330), .B(n363), .Y(n359) );
  CLKINVX1 U424 ( .A(N291), .Y(n363) );
  NOR2X1 U425 ( .A(n361), .B(n362), .Y(n360) );
  CLKINVX1 U426 ( .A(N277), .Y(n362) );
  CLKINVX1 U427 ( .A(N292), .Y(n345) );
  CLKINVX1 U428 ( .A(N293), .Y(n339) );
  CLKINVX1 U429 ( .A(n193), .Y(n479) );
  CLKINVX1 U430 ( .A(N327), .Y(n412) );
  CLKINVX1 U431 ( .A(N261), .Y(n410) );
  DFFRX1 div12_reg_1_ ( .D(n2430), .CK(clk), .RN(n206), .Q(div12_1_), .QN(
        n2720) );
  NOR2X1 U432 ( .A(n361), .B(n377), .Y(n376) );
  CLKINVX1 U433 ( .A(N276), .Y(n377) );
  NAND2X1 U434 ( .A(n372), .B(n373), .Y(n370) );
  NAND2X1 U435 ( .A(N333), .B(n56), .Y(n373) );
  NOR2X1 U436 ( .A(n375), .B(n376), .Y(n372) );
  NOR2X1 U437 ( .A(n3330), .B(n378), .Y(n375) );
  NOR2BX1 U438 ( .AN(N224), .B(n2940), .Y(n2440) );
  XNOR2X1 U439 ( .A(n491), .B(n2950), .Y(N224) );
  CLKINVX1 U440 ( .A(n492), .Y(n491) );
  NOR2X1 U441 ( .A(div12_0_), .B(n2940), .Y(n2420) );
  CLKINVX1 U442 ( .A(N290), .Y(n378) );
  AND2X1 U443 ( .A(n61), .B(n437), .Y(n436) );
  OAI22X1 U444 ( .A0(n59), .A1(n2650), .B0(n67), .B1(n62), .Y(n3360) );
  INVX1 U445 ( .A(in_tc[6]), .Y(n67) );
  NAND4X1 U446 ( .A(n379), .B(n380), .C(n381), .D(n382), .Y(n222) );
  NAND2X1 U447 ( .A(N271), .B(n2760), .Y(n379) );
  NAND2X1 U448 ( .A(N254), .B(n2790), .Y(n380) );
  NAND2X1 U449 ( .A(th1[7]), .B(n383), .Y(n381) );
  NAND3X1 U450 ( .A(n3270), .B(n3280), .C(n3000), .Y(n232) );
  NAND2X1 U451 ( .A(n2780), .B(n3310), .Y(n3270) );
  AOI21X1 U452 ( .A0(n3300), .A1(tl0[7]), .B0(n2840), .Y(n3280) );
  NAND2X1 U453 ( .A(n3320), .B(n2830), .Y(n3310) );
  OAI21X1 U454 ( .A0(n304), .A1(n305), .B0(n306), .Y(n240) );
  NAND2X1 U455 ( .A(N337), .B(n307), .Y(n306) );
  NOR2X1 U456 ( .A(th0[7]), .B(n139), .Y(n304) );
  AOI21X1 U457 ( .A0(n308), .A1(n309), .B0(n140), .Y(n305) );
  NAND2X2 U458 ( .A(n404), .B(n403), .Y(n349) );
  NAND3X1 U459 ( .A(n405), .B(n3030), .C(n3020), .Y(n404) );
  AOI22X1 U460 ( .A0(th1[6]), .A1(n22), .B0(N262), .B1(n21), .Y(n405) );
  NAND3X1 U461 ( .A(n3340), .B(n3350), .C(n64), .Y(n231) );
  NAND2X1 U462 ( .A(n2780), .B(n3370), .Y(n3350) );
  NAND2X1 U463 ( .A(n3300), .B(tl0[6]), .Y(n3340) );
  INVX1 U464 ( .A(n3360), .Y(n64) );
  NAND2X1 U465 ( .A(n3120), .B(n313), .Y(n239) );
  NAND2X1 U466 ( .A(N336), .B(n307), .Y(n313) );
  MXI2X1 U467 ( .S0(n140), .B(th0[6]), .A(n314), .Y(n3120) );
  NAND2X1 U468 ( .A(n400), .B(n401), .Y(n214) );
  NAND2X1 U469 ( .A(n402), .B(tl1[7]), .Y(n401) );
  OAI22X1 U470 ( .A0(n59), .A1(n2660), .B0(n74), .B1(n62), .Y(n342) );
  INVX1 U471 ( .A(in_tc[5]), .Y(n74) );
  OAI21X1 U472 ( .A0(n28), .A1(n407), .B0(n403), .Y(n3010) );
  OAI22X1 U473 ( .A0(n408), .A1(n2640), .B0(n409), .B1(n410), .Y(n407) );
  OAI21X1 U474 ( .A0(n411), .A1(n412), .B0(n413), .Y(n28) );
  NAND4X1 U475 ( .A(n392), .B(n393), .C(n394), .D(n395), .Y(n219) );
  NAND2X1 U476 ( .A(N268), .B(n2760), .Y(n392) );
  NAND2X1 U477 ( .A(N251), .B(n2790), .Y(n393) );
  NAND2X1 U478 ( .A(th1[4]), .B(n383), .Y(n394) );
  NAND4X1 U479 ( .A(n388), .B(n389), .C(n390), .D(n391), .Y(n220) );
  NAND2X1 U480 ( .A(N269), .B(n2760), .Y(n388) );
  NAND2X1 U481 ( .A(N252), .B(n2790), .Y(n389) );
  NAND2X1 U482 ( .A(th1[5]), .B(n383), .Y(n390) );
  NAND4X1 U483 ( .A(n384), .B(n385), .C(n386), .D(n387), .Y(n221) );
  NAND2X1 U484 ( .A(N270), .B(n2760), .Y(n384) );
  NAND2X1 U485 ( .A(N253), .B(n2790), .Y(n385) );
  NAND2X1 U486 ( .A(th1[6]), .B(n383), .Y(n386) );
  NAND4X1 U487 ( .A(n396), .B(n397), .C(n398), .D(n399), .Y(n218) );
  NAND2X1 U488 ( .A(N267), .B(n2760), .Y(n396) );
  NAND2X1 U489 ( .A(N250), .B(n2790), .Y(n397) );
  NAND2X1 U490 ( .A(th1[3]), .B(n383), .Y(n398) );
  MXI2X1 U491 ( .S0(n29), .B(n2980), .A(n421), .Y(n210) );
  INVX1 U492 ( .A(n35), .Y(n421) );
  NAND3X1 U493 ( .A(n422), .B(n423), .C(n37), .Y(n35) );
  NAND2X1 U494 ( .A(N259), .B(n21), .Y(n422) );
  MXI2X1 U495 ( .S0(n29), .B(n2990), .A(n428), .Y(n209) );
  INVX1 U496 ( .A(n38), .Y(n428) );
  NAND3X1 U497 ( .A(n430), .B(n431), .C(n40), .Y(n38) );
  NAND2X1 U498 ( .A(N258), .B(n21), .Y(n430) );
  NAND3X1 U499 ( .A(n340), .B(n341), .C(n69), .Y(n230) );
  NAND2X1 U500 ( .A(n2780), .B(n343), .Y(n341) );
  NAND2X1 U501 ( .A(n3300), .B(tl0[5]), .Y(n340) );
  NAND2BX1 U502 ( .AN(n45), .B(n46), .Y(n44) );
  AO22X1 U503 ( .A0(N256), .A1(n21), .B0(N322), .B1(n20), .Y(n45) );
  AOI222X1 U504 ( .A0(th1[0]), .A1(n22), .B0(N242), .B1(n34), .C0(in_tc[0]), 
        .C1(n19), .Y(n46) );
  NAND2BX1 U505 ( .AN(n42), .B(n43), .Y(n41) );
  AO22X1 U506 ( .A0(N257), .A1(n21), .B0(N323), .B1(n20), .Y(n42) );
  NAND2X1 U507 ( .A(n3010), .B(n406), .Y(n212) );
  NAND2X1 U508 ( .A(tl1[5]), .B(n402), .Y(n406) );
  NAND3X1 U509 ( .A(n418), .B(n419), .C(n420), .Y(n417) );
  NAND2X1 U510 ( .A(N246), .B(n34), .Y(n418) );
  NAND2X1 U511 ( .A(th1[4]), .B(n22), .Y(n419) );
  NAND3X1 U512 ( .A(n425), .B(n426), .C(n427), .Y(n424) );
  NAND2X1 U513 ( .A(N245), .B(n34), .Y(n425) );
  NAND2X1 U514 ( .A(th1[3]), .B(n22), .Y(n426) );
  NAND3X1 U515 ( .A(n433), .B(n434), .C(n435), .Y(n432) );
  NAND2X1 U516 ( .A(N244), .B(n34), .Y(n433) );
  NAND2X1 U517 ( .A(n22), .B(th1[2]), .Y(n434) );
  OAI221X1 U518 ( .A0(n95), .A1(n62), .B0(n96), .B1(n84), .C0(n97), .Y(n227)
         );
  AOI222X1 U519 ( .A0(N332), .A1(n56), .B0(N275), .B1(n89), .C0(N289), .C1(n58), .Y(n96) );
  OA22X1 U520 ( .A0(n59), .A1(n2740), .B0(n2510), .B1(n88), .Y(n97) );
  OAI221X1 U521 ( .A0(n100), .A1(n114), .B0(n2620), .B1(n116), .C0(n131), .Y(
        n216) );
  AOI22X1 U522 ( .A0(N265), .A1(n2760), .B0(N248), .B1(n2790), .Y(n131) );
  OAI221X1 U523 ( .A0(n95), .A1(n114), .B0(n2630), .B1(n116), .C0(n129), .Y(
        n217) );
  AOI22X1 U524 ( .A0(N266), .A1(n2760), .B0(N249), .B1(n2790), .Y(n129) );
  NAND2X1 U525 ( .A(n315), .B(n316), .Y(n238) );
  NAND2X1 U526 ( .A(N335), .B(n307), .Y(n316) );
  MXI2X1 U527 ( .S0(n140), .B(th0[5]), .A(n317), .Y(n315) );
  NAND2X1 U528 ( .A(n318), .B(n319), .Y(n237) );
  NAND2X1 U529 ( .A(N334), .B(n307), .Y(n319) );
  MXI2X1 U530 ( .S0(n140), .B(th0[4]), .A(n320), .Y(n318) );
  NAND2X1 U531 ( .A(n321), .B(n3220), .Y(n236) );
  NAND2X1 U532 ( .A(N333), .B(n307), .Y(n3220) );
  MXI2X1 U533 ( .S0(n140), .B(th0[3]), .A(n3230), .Y(n321) );
  NAND2X1 U534 ( .A(n3240), .B(n3250), .Y(n235) );
  NAND2X1 U535 ( .A(N332), .B(n307), .Y(n3250) );
  MXI2X1 U536 ( .S0(n140), .B(th0[2]), .A(n3260), .Y(n3240) );
  OAI221X1 U537 ( .A0(n105), .A1(n62), .B0(n106), .B1(n84), .C0(n107), .Y(
        n2250) );
  AOI222X1 U538 ( .A0(N330), .A1(n56), .B0(N273), .B1(n89), .C0(N287), .C1(n58), .Y(n106) );
  OA22X1 U539 ( .A0(n59), .A1(n2580), .B0(n2470), .B1(n88), .Y(n107) );
  OAI221X1 U540 ( .A0(n105), .A1(n114), .B0(n2610), .B1(n116), .C0(n133), .Y(
        n215) );
  AOI22X1 U541 ( .A0(N264), .A1(n2760), .B0(N247), .B1(n2790), .Y(n133) );
  OAI2BB2X1 U542 ( .A0N(N263), .A1N(n21), .B0(n408), .B1(n2670), .Y(n455) );
  NAND2X1 U543 ( .A(N329), .B(n20), .Y(n437) );
  NOR3BX1 U544 ( .AN(n62), .B(n183), .C(n145), .Y(n2240) );
  AOI32X1 U545 ( .A0(n79), .A1(N312), .A2(n184), .B0(tf1_0), .B1(n185), .Y(
        n183) );
  CLKINVX1 U546 ( .A(n184), .Y(n185) );
  OAI211X1 U547 ( .A0(n163), .A1(n2530), .B0(n113), .C0(n162), .Y(n184) );
  NAND2X1 U548 ( .A(n174), .B(n484), .Y(n453) );
  OAI2BB1X1 U549 ( .A0N(n189), .A1N(n81), .B0(n190), .Y(n241) );
  AOI32X1 U550 ( .A0(N286), .A1(n88), .A2(n146), .B0(n191), .B1(n144), .Y(n190) );
  AO21X1 U551 ( .A0(tf0), .A1(n192), .B0(n194), .Y(n189) );
  NOR2BX1 U552 ( .AN(N303), .B(n192), .Y(n191) );
  NOR2X1 U553 ( .A(n2850), .B(n59), .Y(n2840) );
  NOR2X1 U554 ( .A(n59), .B(n2700), .Y(n368) );
  NOR2X1 U555 ( .A(n59), .B(n2710), .Y(n354) );
  NOR2X1 U556 ( .A(n2870), .B(n2880), .Y(n2860) );
  AO21X1 U557 ( .A0(int1_pin), .A1(gate1), .B0(n163), .Y(n2870) );
  OR2X1 U558 ( .A(n2890), .B(t0_pin), .Y(n474) );
  NOR2X1 U559 ( .A(n2910), .B(n2920), .Y(n2900) );
  AO21X1 U560 ( .A0(int0_pin), .A1(gate0), .B0(n475), .Y(n2910) );
  OR2X1 U561 ( .A(n2930), .B(t1_pin), .Y(n485) );
  NAND4X1 U562 ( .A(tl1[7]), .B(n459), .C(n170), .D(n171), .Y(n458) );
  CLKINVX1 U563 ( .A(n2540), .Y(n459) );
  NOR2BX1 U564 ( .AN(tl1[5]), .B(n2550), .Y(n170) );
  AND4X1 U565 ( .A(tl1[3]), .B(tl1[2]), .C(tl1[1]), .D(tl1[0]), .Y(n171) );
  NAND2X1 U566 ( .A(tm0[0]), .B(n479), .Y(n188) );
  INVX1 U567 ( .A(tm0[0]), .Y(n473) );
  NAND2BX1 U568 ( .AN(tf1_0), .B(n2600), .Y(tf1) );
  NAND2X1 U569 ( .A(div12_1_), .B(div12_0_), .Y(n492) );
  AND4X1 U570 ( .A(n2950), .B(div12_0_), .C(div12_3_), .D(div12_1_), .Y(n2940)
         );
  NOR2BX1 U571 ( .AN(N223), .B(n2940), .Y(n2430) );
  XNOR2X1 U572 ( .A(div12_0_), .B(n2720), .Y(N223) );
  NOR2BX1 U573 ( .AN(N225), .B(n2940), .Y(n2450) );
  XNOR2X1 U574 ( .A(n493), .B(n2730), .Y(N225) );
  NOR2X1 U575 ( .A(n492), .B(n2950), .Y(n493) );
  INVX4 U576 ( .A(rst_p), .Y(n206) );
  DFFRX1 shift12_reg ( .D(n2940), .CK(clk), .RN(n206), .Q(shift12), .QN(n2530)
         );
  DFFRX1 t0_pin_r_reg ( .D(t0_pin), .CK(clk), .RN(n206), .QN(n2890) );
  DFFRX1 div12_reg_3_ ( .D(n2450), .CK(clk), .RN(n206), .Q(div12_3_), .QN(
        n2730) );
  DFFRX1 div12_reg_0_ ( .D(n2420), .CK(clk), .RN(n206), .Q(div12_0_) );
  DFFRX1 tf0_reg ( .D(n241), .CK(clk), .RN(n206), .Q(tf0) );
  DFFRX1 div12_reg_2_ ( .D(n2440), .CK(clk), .RN(n206), .QN(n2950) );
  DFFRX1 tf1_1_reg ( .D(n2230), .CK(clk), .RN(n206), .QN(n2600) );
  DFFRX1 t1_pin_r_reg ( .D(t1_pin), .CK(clk), .RN(n206), .QN(n2930) );
  DFFRX1 tf1_0_reg ( .D(n2240), .CK(clk), .RN(n206), .Q(tf1_0) );
  INVX1 U577 ( .A(addr_tc[1]), .Y(n486) );
  INVX1 U578 ( .A(addr_tc[0]), .Y(n2970) );
  INVX1 U579 ( .A(addr_tc[2]), .Y(n480) );
  INVX16 U580 ( .A(in_tc[3]), .Y(n90) );
  INVX16 U581 ( .A(in_tc[4]), .Y(n82) );
  NOR2BX4 U582 ( .AN(n3000), .B(n2840), .Y(n54) );
  INVX8 U583 ( .A(n3010), .Y(n26) );
  NAND2X6 U584 ( .A(n3020), .B(n3030), .Y(n25) );
  INVX8 U585 ( .A(n349), .Y(n23) );
  NOR2X8 U586 ( .A(n436), .B(n2820), .Y(n17) );
  INVX8 U587 ( .A(n3260), .Y(n155) );
  INVX8 U588 ( .A(n3230), .Y(n153) );
  INVX8 U589 ( .A(n320), .Y(n151) );
  INVX8 U590 ( .A(n400), .Y(n15) );
  INVX8 U591 ( .A(n317), .Y(n149) );
  INVX8 U592 ( .A(n314), .Y(n147) );
  NOR2X8 U593 ( .A(n466), .B(n311), .Y(n141) );
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
  DFFRX4 th0_reg_7_ ( .D(n240), .CK(clk), .RN(n206), .Q(th0[7]), .QN(n2850) );
  DFFRX4 th0_reg_6_ ( .D(n239), .CK(clk), .RN(n206), .Q(th0[6]), .QN(n2650) );
  DFFRX4 th0_reg_5_ ( .D(n238), .CK(clk), .RN(n206), .Q(th0[5]), .QN(n2660) );
  DFFRX4 th0_reg_4_ ( .D(n237), .CK(clk), .RN(n206), .Q(th0[4]), .QN(n2710) );
  DFFRX4 th0_reg_3_ ( .D(n236), .CK(clk), .RN(n206), .Q(th0[3]), .QN(n2700) );
  DFFRX4 th0_reg_2_ ( .D(n235), .CK(clk), .RN(n206), .Q(th0[2]), .QN(n2740) );
  DFFRX4 th0_reg_1_ ( .D(n234), .CK(clk), .RN(n206), .Q(th0[1]), .QN(n2500) );
  DFFRX4 th0_reg_0_ ( .D(n233), .CK(clk), .RN(n206), .Q(th0[0]), .QN(n2580) );
  DFFRX4 tl0_reg_7_ ( .D(n232), .CK(clk), .RN(n206), .Q(tl0[7]), .QN(n2680) );
  DFFRX4 tl0_reg_6_ ( .D(n231), .CK(clk), .RN(n206), .Q(tl0[6]), .QN(n2520) );
  DFFRX4 tl0_reg_5_ ( .D(n230), .CK(clk), .RN(n206), .Q(tl0[5]), .QN(n2690) );
  DFFRX4 tl0_reg_4_ ( .D(n229), .CK(clk), .RN(n206), .Q(tl0[4]), .QN(n2490) );
  DFFRX4 tl0_reg_3_ ( .D(n228), .CK(clk), .RN(n206), .Q(tl0[3]), .QN(n2480) );
  DFFRX4 tl0_reg_2_ ( .D(n227), .CK(clk), .RN(n206), .Q(tl0[2]), .QN(n2510) );
  DFFRX4 tl0_reg_1_ ( .D(n226), .CK(clk), .RN(n206), .Q(tl0[1]), .QN(n2590) );
  DFFRX4 tl0_reg_0_ ( .D(n2250), .CK(clk), .RN(n206), .Q(tl0[0]), .QN(n2470)
         );
  DFFRX4 th1_reg_7_ ( .D(n222), .CK(clk), .RN(n206), .Q(th1[7]), .QN(n2670) );
  DFFRX4 th1_reg_6_ ( .D(n221), .CK(clk), .RN(n206), .Q(th1[6]) );
  DFFRX4 th1_reg_5_ ( .D(n220), .CK(clk), .RN(n206), .Q(th1[5]), .QN(n2640) );
  DFFRX4 th1_reg_4_ ( .D(n219), .CK(clk), .RN(n206), .Q(th1[4]) );
  DFFRX4 th1_reg_3_ ( .D(n218), .CK(clk), .RN(n206), .Q(th1[3]) );
  DFFRX4 th1_reg_2_ ( .D(n217), .CK(clk), .RN(n206), .Q(th1[2]), .QN(n2630) );
  DFFRX4 th1_reg_1_ ( .D(n216), .CK(clk), .RN(n206), .Q(th1[1]), .QN(n2620) );
  DFFRX4 th1_reg_0_ ( .D(n215), .CK(clk), .RN(n206), .Q(th1[0]), .QN(n2610) );
  DFFRX4 tl1_reg_7_ ( .D(n214), .CK(clk), .RN(n206), .Q(tl1[7]) );
  DFFRX4 tl1_reg_6_ ( .D(n213), .CK(clk), .RN(n206), .Q(tl1[6]), .QN(n2540) );
  DFFRX4 tl1_reg_5_ ( .D(n212), .CK(clk), .RN(n206), .Q(tl1[5]) );
  DFFRX4 tl1_reg_4_ ( .D(n211), .CK(clk), .RN(n206), .Q(tl1[4]), .QN(n2550) );
  DFFRX4 tl1_reg_3_ ( .D(n210), .CK(clk), .RN(n206), .Q(tl1[3]), .QN(n2980) );
  DFFRX4 tl1_reg_2_ ( .D(n209), .CK(clk), .RN(n206), .Q(tl1[2]), .QN(n2990) );
  DFFRX4 tl1_reg_1_ ( .D(n208), .CK(clk), .RN(n206), .Q(tl1[1]) );
  DFFRX4 tl1_reg_0_ ( .D(n207), .CK(clk), .RN(n206), .Q(tl1[0]) );
endmodule


module u_tc_DW01_inc_9_0 ( A, SUM );
  input [8:0] A;
  output [8:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  ADDHX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(SUM[8]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module u_tc_DW01_inc_14_0 ( A, SUM );
  input [13:0] A;
  output [13:0] SUM;
  wire   carry_12_, carry_11_, carry_10_, carry_9_, carry_8_, carry_7_,
         carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  ADDHX1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(SUM[13]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  ADDHX1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  ADDHX1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  ADDHX1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  ADDHX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
endmodule


module u_tc_DW01_inc_17_0 ( A, SUM );
  input [16:0] A;
  output [16:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_;

  ADDHX1 U1_1_15 ( .A(A[15]), .B(carry_15_), .S(SUM[15]), .CO(SUM[16]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_14 ( .A(A[14]), .B(carry_14_), .S(SUM[14]), .CO(carry_15_) );
  ADDHX1 U1_1_13 ( .A(A[13]), .B(carry_13_), .S(SUM[13]), .CO(carry_14_) );
  ADDHX1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(carry_13_) );
  ADDHX1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  ADDHX1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  ADDHX1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  ADDHX1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  ADDHX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module u_tc_DW01_inc_14_1 ( A, SUM );
  input [13:0] A;
  output [13:0] SUM;
  wire   carry_12_, carry_11_, carry_10_, carry_9_, carry_8_, carry_7_,
         carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  ADDHX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  ADDHX1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  ADDHX1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  ADDHX1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(SUM[13]) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module u_tc_DW01_inc_17_1 ( A, SUM );
  input [16:0] A;
  output [16:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_;

  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_13 ( .A(A[13]), .B(carry_13_), .S(SUM[13]), .CO(carry_14_) );
  ADDHX1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  ADDHX1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  ADDHX1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  ADDHX1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(carry_13_) );
  ADDHX1 U1_1_14 ( .A(A[14]), .B(carry_14_), .S(SUM[14]), .CO(carry_15_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  ADDHX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_15 ( .A(A[15]), .B(carry_15_), .S(SUM[15]), .CO(SUM[16]) );
  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module u_tc_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  CLKXOR2X1 U5 ( .A(carry_7_), .B(A[7]), .Y(SUM[7]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module tmod ( clk, rst_p, wr, in_tmod, addr_tmod, out_tmod );
  input [7:0] in_tmod;
  input [7:0] addr_tmod;
  output [7:0] out_tmod;
  input clk, rst_p, wr;
  wire   n2, n3, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30;

  AO22X1 U16 ( .A0(out_tmod[1]), .A1(n2), .B0(in_tmod[1]), .B1(n3), .Y(n9) );
  CLKINVX1 U17 ( .A(addr_tmod[7]), .Y(n16) );
  CLKINVX1 U18 ( .A(n2), .Y(n3) );
  DFFRX1 out_tmod_reg_4_ ( .D(n12), .CK(clk), .RN(n7), .Q(out_tmod[4]), .QN(
        n20) );
  DFFRX1 out_tmod_reg_2_ ( .D(n10), .CK(clk), .RN(n7), .Q(out_tmod[2]) );
  DFFRX1 out_tmod_reg_6_ ( .D(n14), .CK(clk), .RN(n7), .Q(out_tmod[6]), .QN(
        n18) );
  DFFRX1 out_tmod_reg_7_ ( .D(n15), .CK(clk), .RN(n7), .Q(out_tmod[7]), .QN(
        n17) );
  NAND4X1 U19 ( .A(n27), .B(n28), .C(n29), .D(wr), .Y(n2) );
  NOR2X1 U20 ( .A(n16), .B(n30), .Y(n29) );
  MXI2X1 U21 ( .S0(n3), .B(n22), .A(n17), .Y(n15) );
  INVX1 U22 ( .A(in_tmod[7]), .Y(n22) );
  MXI2X1 U23 ( .S0(n3), .B(n23), .A(n18), .Y(n14) );
  INVX1 U24 ( .A(in_tmod[6]), .Y(n23) );
  MXI2X1 U25 ( .S0(n3), .B(n24), .A(n19), .Y(n13) );
  INVX1 U26 ( .A(in_tmod[5]), .Y(n24) );
  MXI2X1 U27 ( .S0(n3), .B(n25), .A(n20), .Y(n12) );
  INVX1 U28 ( .A(in_tmod[4]), .Y(n25) );
  MXI2X1 U29 ( .S0(n3), .B(n26), .A(n21), .Y(n11) );
  INVX1 U30 ( .A(in_tmod[3]), .Y(n26) );
  AO22X1 U31 ( .A0(out_tmod[2]), .A1(n2), .B0(in_tmod[2]), .B1(n3), .Y(n10) );
  AO22X1 U32 ( .A0(out_tmod[0]), .A1(n2), .B0(in_tmod[0]), .B1(n3), .Y(n8) );
  INVX1 U33 ( .A(rst_p), .Y(n7) );
  DFFRX1 out_tmod_reg_3_ ( .D(n11), .CK(clk), .RN(n7), .Q(out_tmod[3]), .QN(
        n21) );
  NAND2X1 U34 ( .A(addr_tmod[3]), .B(addr_tmod[0]), .Y(n30) );
  NOR3X1 U35 ( .A(addr_tmod[4]), .B(addr_tmod[6]), .C(addr_tmod[5]), .Y(n28)
         );
  NOR2X1 U36 ( .A(addr_tmod[2]), .B(addr_tmod[1]), .Y(n27) );
  DFFRX4 out_tmod_reg_5_ ( .D(n13), .CK(clk), .RN(n7), .Q(out_tmod[5]), .QN(
        n19) );
  DFFRX4 out_tmod_reg_1_ ( .D(n9), .CK(clk), .RN(n7), .Q(out_tmod[1]) );
  DFFRX4 out_tmod_reg_0_ ( .D(n8), .CK(clk), .RN(n7), .Q(out_tmod[0]) );
endmodule


module tcon ( clk, rst_p, in_tcon, addr_tcon, wr, set_tf0, rst_tf0, set_tf1, 
        rst_tf1, set_ie0, rst_ie0, set_ie1, rst_ie1, out_tcon );
  input [7:0] in_tcon;
  input [7:0] addr_tcon;
  output [7:0] out_tcon;
  input clk, rst_p, wr, set_tf0, rst_tf0, set_tf1, rst_tf1, set_ie0, rst_ie0,
         set_ie1, rst_ie1;
  wire   set_tf0_d1, set_tf1_d1, set_ie0_d2, set_ie0_d1, set_ie1_d1, n6, n11,
         n16, n18, n19, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46,
         n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
         n61, n62, n63, n64, n65, n66, n67, n68, n69;

  INVX1 U32 ( .A(addr_tcon[6]), .Y(n67) );
  INVX1 U33 ( .A(n44), .Y(n60) );
  NAND3X1 U34 ( .A(n62), .B(n63), .C(wr), .Y(n11) );
  OAI2BB1X1 U35 ( .A0N(in_tcon[1]), .A1N(n16), .B0(n35), .Y(n28) );
  AOI21X1 U36 ( .A0(n18), .A1(n19), .B0(set_ie0), .Y(n35) );
  AO22X1 U37 ( .A0(out_tcon[2]), .A1(n11), .B0(in_tcon[2]), .B1(n6), .Y(n32)
         );
  INVX1 U38 ( .A(addr_tcon[7]), .Y(n36) );
  OR2X1 U39 ( .A(addr_tcon[1]), .B(addr_tcon[2]), .Y(n65) );
  CLKINVX1 U40 ( .A(n11), .Y(n6) );
  DFFRX1 tcon_reg_2_ ( .D(n33), .CK(clk), .RN(n22), .Q(out_tcon[4]), .QN(n38)
         );
  DFFRX1 tcon_reg_3_ ( .D(n34), .CK(clk), .RN(n22), .Q(out_tcon[6]), .QN(n37)
         );
  DFFRX1 tcon_ie1_reg ( .D(n27), .CK(clk), .RN(n22), .Q(out_tcon[3]), .QN(n44)
         );
  NOR2X1 U41 ( .A(n64), .B(n65), .Y(n63) );
  NAND3X1 U42 ( .A(n66), .B(n67), .C(n68), .Y(n64) );
  CLKINVX1 U43 ( .A(rst_tf1), .Y(n56) );
  CLKINVX1 U44 ( .A(rst_tf0), .Y(n51) );
  CLKINVX1 U45 ( .A(rst_ie1), .Y(n61) );
  NAND2BX1 U46 ( .AN(set_tf1), .B(n52), .Y(n29) );
  OAI21X1 U47 ( .A0(in_tcon[7]), .A1(n53), .B0(n54), .Y(n52) );
  OAI2BB1X1 U48 ( .A0N(n55), .A1N(n56), .B0(n53), .Y(n54) );
  NAND3X1 U49 ( .A(n26), .B(n41), .C(n6), .Y(n53) );
  MXI2X1 U50 ( .S0(n6), .B(n46), .A(n38), .Y(n33) );
  INVX1 U51 ( .A(in_tcon[4]), .Y(n46) );
  MXI2X1 U52 ( .S0(n6), .B(n45), .A(n37), .Y(n34) );
  INVX1 U53 ( .A(in_tcon[6]), .Y(n45) );
  NAND2BX1 U54 ( .AN(set_tf0), .B(n47), .Y(n30) );
  OAI21X1 U55 ( .A0(in_tcon[5]), .A1(n48), .B0(n49), .Y(n47) );
  OAI2BB1X1 U56 ( .A0N(n50), .A1N(n51), .B0(n48), .Y(n49) );
  NAND3X1 U57 ( .A(n25), .B(n39), .C(n6), .Y(n48) );
  NAND2BX1 U58 ( .AN(set_ie1), .B(n57), .Y(n27) );
  OAI21X1 U59 ( .A0(in_tcon[3]), .A1(n58), .B0(n59), .Y(n57) );
  OAI2BB1X1 U60 ( .A0N(n60), .A1N(n61), .B0(n58), .Y(n59) );
  NAND3X1 U61 ( .A(n24), .B(n43), .C(n6), .Y(n58) );
  CLKINVX1 U62 ( .A(n19), .Y(n16) );
  NAND3BX1 U63 ( .AN(set_ie0_d2), .B(n23), .C(n6), .Y(n19) );
  AO22X1 U64 ( .A0(out_tcon[0]), .A1(n11), .B0(in_tcon[0]), .B1(n6), .Y(n31)
         );
  NOR2BX1 U65 ( .AN(out_tcon[1]), .B(rst_ie0), .Y(n18) );
  CLKINVX1 U66 ( .A(n42), .Y(n55) );
  CLKINVX1 U67 ( .A(n40), .Y(n50) );
  CLKINVX1 U68 ( .A(rst_p), .Y(n22) );
  DFFRX1 set_ie1_d2_reg ( .D(set_ie1_d1), .CK(clk), .RN(n22), .QN(n43) );
  DFFRX1 set_tf1_d2_reg ( .D(set_tf1_d1), .CK(clk), .RN(n22), .QN(n41) );
  DFFRX1 set_tf0_d2_reg ( .D(set_tf0_d1), .CK(clk), .RN(n22), .QN(n39) );
  DFFRX1 set_ie1_d1_reg ( .D(set_ie1), .CK(clk), .RN(n22), .Q(set_ie1_d1), 
        .QN(n24) );
  DFFRX1 set_tf1_d1_reg ( .D(set_tf1), .CK(clk), .RN(n22), .Q(set_tf1_d1), 
        .QN(n26) );
  DFFRX1 set_tf0_d1_reg ( .D(set_tf0), .CK(clk), .RN(n22), .Q(set_tf0_d1), 
        .QN(n25) );
  DFFRX1 set_ie0_d1_reg ( .D(set_ie0), .CK(clk), .RN(n22), .Q(set_ie0_d1), 
        .QN(n23) );
  DFFRX1 set_ie0_d2_reg ( .D(set_ie0_d1), .CK(clk), .RN(n22), .Q(set_ie0_d2)
         );
  INVX1 U69 ( .A(addr_tcon[4]), .Y(n68) );
  INVX1 U70 ( .A(addr_tcon[3]), .Y(n69) );
  NOR3X1 U71 ( .A(n36), .B(addr_tcon[0]), .C(n69), .Y(n62) );
  INVX1 U72 ( .A(addr_tcon[5]), .Y(n66) );
  DFFRX4 tcon_reg_1_ ( .D(n32), .CK(clk), .RN(n22), .Q(out_tcon[2]) );
  DFFRX4 tcon_reg_0_ ( .D(n31), .CK(clk), .RN(n22), .Q(out_tcon[0]) );
  DFFRX4 tcon_tf0_reg ( .D(n30), .CK(clk), .RN(n22), .Q(out_tcon[5]), .QN(n40)
         );
  DFFRX4 tcon_tf1_reg ( .D(n29), .CK(clk), .RN(n22), .Q(out_tcon[7]), .QN(n42)
         );
  DFFRX4 tcon_ie0_reg ( .D(n28), .CK(clk), .RN(n22), .Q(out_tcon[1]) );
endmodule


module dimod ( clk, rst_p, wr, addr_dimod, in_dimod, out_dimod );
  input [7:0] addr_dimod;
  input [7:0] in_dimod;
  output [7:0] out_dimod;
  input clk, rst_p, wr;
  wire   n1, n2, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32;

  INVX1 U15 ( .A(addr_dimod[6]), .Y(n30) );
  DFFRX1 out_dimod_reg_1_ ( .D(n7), .CK(clk), .RN(n5), .Q(out_dimod[1]) );
  INVX1 U16 ( .A(addr_dimod[7]), .Y(n14) );
  OR2X1 U17 ( .A(addr_dimod[1]), .B(addr_dimod[3]), .Y(n28) );
  CLKINVX1 U18 ( .A(n2), .Y(n1) );
  NAND3X1 U19 ( .A(n25), .B(n26), .C(wr), .Y(n2) );
  NOR2X1 U20 ( .A(n27), .B(n28), .Y(n26) );
  NAND3X1 U21 ( .A(n29), .B(n30), .C(n31), .Y(n27) );
  MXI2X1 U22 ( .S0(n1), .B(n21), .A(n15), .Y(n13) );
  INVX1 U23 ( .A(in_dimod[7]), .Y(n21) );
  MXI2X1 U24 ( .S0(n1), .B(n22), .A(n16), .Y(n12) );
  INVX1 U25 ( .A(in_dimod[6]), .Y(n22) );
  MXI2X1 U26 ( .S0(n1), .B(n23), .A(n17), .Y(n11) );
  INVX1 U27 ( .A(in_dimod[5]), .Y(n23) );
  MXI2X1 U28 ( .S0(n1), .B(n24), .A(n18), .Y(n10) );
  INVX1 U29 ( .A(in_dimod[4]), .Y(n24) );
  MXI2X1 U30 ( .S0(n1), .B(n20), .A(n19), .Y(n9) );
  INVX1 U31 ( .A(in_dimod[3]), .Y(n20) );
  AO22X1 U32 ( .A0(in_dimod[2]), .A1(n1), .B0(out_dimod[2]), .B1(n2), .Y(n8)
         );
  AO22X1 U33 ( .A0(in_dimod[1]), .A1(n1), .B0(out_dimod[1]), .B1(n2), .Y(n7)
         );
  AO22X1 U34 ( .A0(in_dimod[0]), .A1(n1), .B0(out_dimod[0]), .B1(n2), .Y(n6)
         );
  INVX1 U35 ( .A(rst_p), .Y(n5) );
  DFFRX1 out_dimod_reg_2_ ( .D(n8), .CK(clk), .RN(n5), .Q(out_dimod[2]) );
  DFFRX1 out_dimod_reg_0_ ( .D(n6), .CK(clk), .RN(n5), .Q(out_dimod[0]) );
  DFFRX1 out_dimod_reg_3_ ( .D(n9), .CK(clk), .RN(n5), .Q(out_dimod[3]), .QN(
        n19) );
  DFFRX1 out_dimod_reg_4_ ( .D(n10), .CK(clk), .RN(n5), .Q(out_dimod[4]), .QN(
        n18) );
  DFFRX1 out_dimod_reg_5_ ( .D(n11), .CK(clk), .RN(n5), .Q(out_dimod[5]), .QN(
        n17) );
  DFFRX1 out_dimod_reg_6_ ( .D(n12), .CK(clk), .RN(n5), .Q(out_dimod[6]), .QN(
        n16) );
  DFFRX1 out_dimod_reg_7_ ( .D(n13), .CK(clk), .RN(n5), .Q(out_dimod[7]), .QN(
        n15) );
  INVX1 U36 ( .A(addr_dimod[4]), .Y(n31) );
  NOR3X1 U37 ( .A(n14), .B(addr_dimod[0]), .C(n32), .Y(n25) );
  INVX1 U38 ( .A(addr_dimod[5]), .Y(n29) );
  INVX1 U39 ( .A(addr_dimod[2]), .Y(n32) );
endmodule


module dptr ( clk, rst_p, ld_dpl, ld_dph, wr, inc_dptr, addr_dptr, in_dptr, 
        out_dptr );
  input [7:0] addr_dptr;
  input [7:0] in_dptr;
  output [15:0] out_dptr;
  input clk, rst_p, ld_dpl, ld_dph, wr, inc_dptr;
  wire   n105, n106, n107, n108, N34, N35, N36, N37, N38, N39, N40, N41, N42,
         N43, N44, N45, N46, N47, N48, N49, n4, n5, n7, n8, n9, n10, n11, n12,
         n13, n26, n340, n350, n360, n370, n380, n390, n400, n410, n420, n430,
         n440, n450, n460, n470, n480, n490, n50, n51, n52, n53, n54, n55, n57,
         n59, n61, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74,
         n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88,
         n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
         n102, n103, n104;

  AND2X1 U53 ( .A(out_dptr[15]), .B(n4), .Y(n52) );
  AND2X2 U54 ( .A(N41), .B(n5), .Y(n53) );
  AND2X2 U55 ( .A(N49), .B(n5), .Y(n54) );
  CLKINVX4 U56 ( .A(n55), .Y(out_dptr[0]) );
  CLKINVX4 U57 ( .A(n57), .Y(out_dptr[1]) );
  INVX4 U58 ( .A(n59), .Y(out_dptr[2]) );
  INVX3 U59 ( .A(n61), .Y(out_dptr[3]) );
  INVX1 U60 ( .A(n13), .Y(n95) );
  INVX1 U61 ( .A(n12), .Y(n93) );
  INVX1 U62 ( .A(n11), .Y(n91) );
  NAND2BX1 U63 ( .AN(ld_dpl), .B(n104), .Y(n8) );
  AO21X1 U64 ( .A0(N35), .A1(n5), .B0(n63), .Y(n370) );
  AO22X1 U65 ( .A0(in_dptr[1]), .A1(n8), .B0(n107), .B1(n9), .Y(n63) );
  AO21X1 U66 ( .A0(N36), .A1(n5), .B0(n64), .Y(n380) );
  AO22X1 U67 ( .A0(in_dptr[2]), .A1(n8), .B0(n106), .B1(n9), .Y(n64) );
  AO21X1 U68 ( .A0(N34), .A1(n5), .B0(n26), .Y(n360) );
  NAND2X1 U69 ( .A(out_dptr[7]), .B(n9), .Y(n75) );
  AND2X2 U70 ( .A(n103), .B(n85), .Y(n9) );
  NAND2X1 U71 ( .A(inc_dptr), .B(n99), .Y(n103) );
  CLKINVX1 U72 ( .A(inc_dptr), .Y(n96) );
  NOR3X2 U73 ( .A(n8), .B(n96), .C(n97), .Y(n5) );
  NAND2X1 U74 ( .A(n85), .B(n98), .Y(n4) );
  NAND2X1 U75 ( .A(n99), .B(n96), .Y(n98) );
  NOR2BX1 U76 ( .AN(n97), .B(n4), .Y(n65) );
  CLKINVX1 U77 ( .A(n8), .Y(n85) );
  CLKINVX1 U78 ( .A(n97), .Y(n99) );
  INVX1 U79 ( .A(in_dptr[7]), .Y(n74) );
  NAND2X1 U80 ( .A(in_dptr[6]), .B(n8), .Y(n89) );
  NAND2X1 U81 ( .A(n66), .B(n71), .Y(n104) );
  OR2X1 U82 ( .A(n66), .B(ld_dph), .Y(n97) );
  CLKINVX1 U83 ( .A(n76), .Y(n72) );
  AOI21X1 U84 ( .A0(n74), .A1(n77), .B0(n78), .Y(n51) );
  NOR3X1 U85 ( .A(n65), .B(n54), .C(n52), .Y(n78) );
  NOR2X1 U86 ( .A(n52), .B(n54), .Y(n77) );
  AOI21X1 U87 ( .A0(n74), .A1(n83), .B0(n84), .Y(n430) );
  NOR2X1 U88 ( .A(n53), .B(n86), .Y(n83) );
  NOR2X1 U89 ( .A(n76), .B(n53), .Y(n84) );
  CLKINVX1 U90 ( .A(n75), .Y(n86) );
  NAND3X1 U91 ( .A(n87), .B(n88), .C(n89), .Y(n420) );
  NAND2X1 U92 ( .A(N40), .B(n5), .Y(n87) );
  NAND2X1 U93 ( .A(n90), .B(n91), .Y(n410) );
  NAND2X1 U94 ( .A(N39), .B(n5), .Y(n90) );
  OAI2BB1X1 U95 ( .A0N(in_dptr[5]), .A1N(n8), .B0(n102), .Y(n11) );
  NAND2X1 U96 ( .A(n92), .B(n93), .Y(n400) );
  NAND2X1 U97 ( .A(N38), .B(n5), .Y(n92) );
  OAI2BB1X1 U98 ( .A0N(in_dptr[4]), .A1N(n8), .B0(n101), .Y(n12) );
  NAND2X1 U99 ( .A(n94), .B(n95), .Y(n390) );
  NAND2X1 U100 ( .A(N37), .B(n5), .Y(n94) );
  OAI2BB1X1 U101 ( .A0N(in_dptr[3]), .A1N(n8), .B0(n100), .Y(n13) );
  AND4X1 U102 ( .A(n67), .B(addr_dptr[7]), .C(n340), .D(wr), .Y(n66) );
  NOR4X1 U103 ( .A(addr_dptr[4]), .B(addr_dptr[3]), .C(addr_dptr[6]), .D(
        addr_dptr[5]), .Y(n67) );
  NAND2X1 U104 ( .A(n75), .B(n85), .Y(n76) );
  AND2X1 U105 ( .A(n74), .B(n75), .Y(n73) );
  OAI2BB1X1 U106 ( .A0N(in_dptr[4]), .A1N(n65), .B0(n81), .Y(n480) );
  AOI22X1 U107 ( .A0(N46), .A1(n5), .B0(out_dptr[12]), .B1(n4), .Y(n81) );
  OAI2BB1X1 U108 ( .A0N(in_dptr[5]), .A1N(n65), .B0(n80), .Y(n490) );
  AOI22X1 U109 ( .A0(N47), .A1(n5), .B0(out_dptr[13]), .B1(n4), .Y(n80) );
  OAI2BB1X1 U110 ( .A0N(in_dptr[6]), .A1N(n65), .B0(n79), .Y(n50) );
  AOI22X1 U111 ( .A0(N48), .A1(n5), .B0(out_dptr[14]), .B1(n4), .Y(n79) );
  OAI2BB1X1 U112 ( .A0N(in_dptr[3]), .A1N(n65), .B0(n82), .Y(n470) );
  AOI22X1 U113 ( .A0(N45), .A1(n5), .B0(out_dptr[11]), .B1(n4), .Y(n82) );
  OAI2BB1X1 U114 ( .A0N(in_dptr[2]), .A1N(n65), .B0(n68), .Y(n460) );
  AOI22X1 U115 ( .A0(out_dptr[10]), .A1(n4), .B0(N44), .B1(n5), .Y(n68) );
  OAI2BB1X1 U116 ( .A0N(in_dptr[1]), .A1N(n65), .B0(n69), .Y(n450) );
  AOI22X1 U117 ( .A0(out_dptr[9]), .A1(n4), .B0(N43), .B1(n5), .Y(n69) );
  OAI2BB1X1 U118 ( .A0N(in_dptr[0]), .A1N(n65), .B0(n70), .Y(n440) );
  AOI22X1 U119 ( .A0(out_dptr[8]), .A1(n4), .B0(N42), .B1(n5), .Y(n70) );
  NAND2X1 U120 ( .A(out_dptr[6]), .B(n9), .Y(n88) );
  NAND2X1 U121 ( .A(n105), .B(n9), .Y(n100) );
  NAND2X1 U122 ( .A(out_dptr[4]), .B(n9), .Y(n101) );
  NAND2X1 U123 ( .A(out_dptr[5]), .B(n9), .Y(n102) );
  CLKINVX2 U124 ( .A(rst_p), .Y(n350) );
  INVX1 U125 ( .A(addr_dptr[0]), .Y(n71) );
  NOR2X8 U126 ( .A(n72), .B(n73), .Y(n7) );
  NAND2X6 U127 ( .A(n89), .B(n88), .Y(n10) );
  AO22X1 U128 ( .A0(in_dptr[0]), .A1(n8), .B0(n108), .B1(n9), .Y(n26) );
  NOR2BX1 U129 ( .AN(addr_dptr[1]), .B(addr_dptr[2]), .Y(n340) );
  dptr_DW01_inc_16_0 add_33 ( .A({out_dptr[15:4], n105, n106, n107, n108}), 
        .SUM({N49, N48, N47, N46, N45, N44, N43, N42, N41, N40, N39, N38, N37, 
        N36, N35, N34}) );
  DFFRX4 out_dptr_reg_15_ ( .D(n51), .CK(clk), .RN(n350), .Q(out_dptr[15]) );
  DFFRX4 out_dptr_reg_14_ ( .D(n50), .CK(clk), .RN(n350), .Q(out_dptr[14]) );
  DFFRX4 out_dptr_reg_13_ ( .D(n490), .CK(clk), .RN(n350), .Q(out_dptr[13]) );
  DFFRX4 out_dptr_reg_12_ ( .D(n480), .CK(clk), .RN(n350), .Q(out_dptr[12]) );
  DFFRX4 out_dptr_reg_11_ ( .D(n470), .CK(clk), .RN(n350), .Q(out_dptr[11]) );
  DFFRX4 out_dptr_reg_10_ ( .D(n460), .CK(clk), .RN(n350), .Q(out_dptr[10]) );
  DFFRX4 out_dptr_reg_9_ ( .D(n450), .CK(clk), .RN(n350), .Q(out_dptr[9]) );
  DFFRX4 out_dptr_reg_8_ ( .D(n440), .CK(clk), .RN(n350), .Q(out_dptr[8]) );
  DFFRX4 out_dptr_reg_7_ ( .D(n430), .CK(clk), .RN(n350), .Q(out_dptr[7]) );
  DFFRX4 out_dptr_reg_6_ ( .D(n420), .CK(clk), .RN(n350), .Q(out_dptr[6]) );
  DFFRX4 out_dptr_reg_5_ ( .D(n410), .CK(clk), .RN(n350), .Q(out_dptr[5]) );
  DFFRX4 out_dptr_reg_4_ ( .D(n400), .CK(clk), .RN(n350), .Q(out_dptr[4]) );
  DFFRX4 out_dptr_reg_3_ ( .D(n390), .CK(clk), .RN(n350), .Q(n105), .QN(n61)
         );
  DFFRX4 out_dptr_reg_2_ ( .D(n380), .CK(clk), .RN(n350), .Q(n106), .QN(n59)
         );
  DFFRX4 out_dptr_reg_1_ ( .D(n370), .CK(clk), .RN(n350), .Q(n107), .QN(n57)
         );
  DFFRX4 out_dptr_reg_0_ ( .D(n360), .CK(clk), .RN(n350), .Q(n108), .QN(n55)
         );
endmodule


module dptr_DW01_inc_16_0 ( A, SUM );
  input [15:0] A;
  output [15:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_, n1, n3;

  XNOR2X1 U5 ( .A(carry_15_), .B(n1), .Y(SUM[15]) );
  CLKINVX1 U6 ( .A(n3), .Y(n1) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  ADDHX1 U1_1_13 ( .A(A[13]), .B(carry_13_), .S(SUM[13]), .CO(carry_14_) );
  ADDHX1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(carry_13_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  ADDHX1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  ADDHX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_14 ( .A(A[14]), .B(carry_14_), .S(SUM[14]), .CO(carry_15_) );
  INVX1 U7 ( .A(A[0]), .Y(SUM[0]) );
  CLKBUFX2 U8 ( .A(A[15]), .Y(n3) );
endmodule


module sp ( clk, rst_p, wr, inc_sp, dec_sp, addr_sp, in_sp, out_sp );
  input [7:0] addr_sp;
  input [7:0] in_sp;
  output [7:0] out_sp;
  input clk, rst_p, wr, inc_sp, dec_sp;
  wire   N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36,
         N37, N38, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n21,
         n22, n230, n240, n250, n260, n270, n280, n290, n300, n310, n320, n330,
         n340, n350, n360, n370, n380, n39, n40, n41, n42, n43, n44, n45, n46,
         n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60,
         n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74,
         n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86;

  NAND3BX1 U31 ( .AN(n57), .B(n52), .C(n53), .Y(n280) );
  OA21X2 U32 ( .A0(n48), .A1(n320), .B0(n49), .Y(n300) );
  CLKINVX1 U33 ( .A(n43), .Y(n4) );
  CLKINVX1 U34 ( .A(n41), .Y(n6) );
  CLKINVX1 U35 ( .A(n48), .Y(n2) );
  INVX1 U36 ( .A(in_sp[7]), .Y(n47) );
  NOR2X1 U37 ( .A(n42), .B(n54), .Y(n380) );
  INVX1 U38 ( .A(in_sp[6]), .Y(n54) );
  NOR2X1 U39 ( .A(n42), .B(n63), .Y(n58) );
  INVX1 U40 ( .A(in_sp[5]), .Y(n63) );
  NOR2X1 U41 ( .A(n42), .B(n69), .Y(n64) );
  INVX1 U42 ( .A(in_sp[4]), .Y(n69) );
  NOR2X1 U43 ( .A(n42), .B(n83), .Y(n76) );
  INVX1 U44 ( .A(in_sp[3]), .Y(n83) );
  NOR2X1 U45 ( .A(n42), .B(n75), .Y(n70) );
  INVX1 U46 ( .A(in_sp[2]), .Y(n75) );
  NAND2X1 U47 ( .A(inc_sp), .B(n42), .Y(n43) );
  NAND2X1 U48 ( .A(n80), .B(n42), .Y(n41) );
  NOR2X1 U49 ( .A(inc_sp), .B(n81), .Y(n80) );
  CLKINVX1 U50 ( .A(dec_sp), .Y(n81) );
  NAND3X1 U51 ( .A(n41), .B(n42), .C(n43), .Y(n48) );
  INVX1 U52 ( .A(n42), .Y(n5) );
  NOR2X1 U53 ( .A(n42), .B(n47), .Y(n44) );
  NOR2X1 U54 ( .A(n39), .B(n40), .Y(n52) );
  INVX1 U55 ( .A(n380), .Y(n53) );
  NAND4BX1 U56 ( .AN(n310), .B(n84), .C(n85), .D(wr), .Y(n42) );
  OR2X1 U57 ( .A(addr_sp[3]), .B(addr_sp[2]), .Y(n310) );
  NOR2X1 U58 ( .A(n43), .B(n56), .Y(n39) );
  CLKINVX1 U59 ( .A(N29), .Y(n56) );
  CLKINVX1 U60 ( .A(N28), .Y(n62) );
  CLKINVX1 U61 ( .A(N25), .Y(n74) );
  CLKINVX1 U62 ( .A(N26), .Y(n82) );
  CLKINVX1 U63 ( .A(N27), .Y(n68) );
  AOI22X1 U64 ( .A0(n300), .A1(n42), .B0(n300), .B1(n47), .Y(n290) );
  NOR2X1 U65 ( .A(n46), .B(n45), .Y(n49) );
  OAI21X1 U66 ( .A0(n48), .A1(n370), .B0(n11), .Y(n240) );
  NOR3X1 U67 ( .A(n70), .B(n71), .C(n72), .Y(n11) );
  NOR2X1 U68 ( .A(n43), .B(n74), .Y(n71) );
  NOR2X1 U69 ( .A(n41), .B(n73), .Y(n72) );
  OAI21X1 U70 ( .A0(n48), .A1(n340), .B0(n8), .Y(n270) );
  NOR3X1 U71 ( .A(n58), .B(n59), .C(n60), .Y(n8) );
  NOR2X1 U72 ( .A(n43), .B(n62), .Y(n59) );
  NOR2X1 U73 ( .A(n41), .B(n61), .Y(n60) );
  OAI21X1 U74 ( .A0(n48), .A1(n350), .B0(n9), .Y(n260) );
  NOR3X1 U75 ( .A(n64), .B(n65), .C(n66), .Y(n9) );
  NOR2X1 U76 ( .A(n43), .B(n68), .Y(n65) );
  NOR2X1 U77 ( .A(n41), .B(n67), .Y(n66) );
  OAI21X1 U78 ( .A0(n48), .A1(n360), .B0(n10), .Y(n250) );
  NOR3X1 U79 ( .A(n76), .B(n77), .C(n78), .Y(n10) );
  NOR2X1 U80 ( .A(n43), .B(n82), .Y(n77) );
  NOR2X1 U81 ( .A(n41), .B(n79), .Y(n78) );
  OAI2BB1X1 U82 ( .A0N(out_sp[1]), .A1N(n2), .B0(n12), .Y(n230) );
  AOI222X1 U83 ( .A0(N24), .A1(n4), .B0(in_sp[1]), .B1(n5), .C0(N32), .C1(n6), 
        .Y(n12) );
  OAI2BB1X1 U84 ( .A0N(out_sp[0]), .A1N(n2), .B0(n13), .Y(n22) );
  AOI222X1 U85 ( .A0(N23), .A1(n4), .B0(in_sp[0]), .B1(n5), .C0(N31), .C1(n6), 
        .Y(n13) );
  NOR2X1 U86 ( .A(n41), .B(n51), .Y(n46) );
  CLKINVX1 U87 ( .A(N38), .Y(n51) );
  NOR2X1 U88 ( .A(n41), .B(n55), .Y(n40) );
  CLKINVX1 U89 ( .A(N37), .Y(n55) );
  NOR2X1 U90 ( .A(n43), .B(n50), .Y(n45) );
  CLKINVX1 U91 ( .A(N30), .Y(n50) );
  NOR2X1 U92 ( .A(n48), .B(n330), .Y(n57) );
  CLKINVX1 U93 ( .A(N35), .Y(n67) );
  CLKINVX1 U94 ( .A(N36), .Y(n61) );
  CLKINVX1 U95 ( .A(N33), .Y(n73) );
  CLKINVX1 U96 ( .A(N34), .Y(n79) );
  INVX1 U97 ( .A(rst_p), .Y(n21) );
  NOR2X1 U98 ( .A(addr_sp[1]), .B(n86), .Y(n85) );
  NAND2X1 U99 ( .A(addr_sp[0]), .B(addr_sp[7]), .Y(n86) );
  NOR3X1 U100 ( .A(addr_sp[4]), .B(addr_sp[6]), .C(addr_sp[5]), .Y(n84) );
  NOR3X6 U101 ( .A(n380), .B(n39), .C(n40), .Y(n7) );
  NOR3X6 U102 ( .A(n44), .B(n45), .C(n46), .Y(n3) );
  sp_DW01_dec_8_0 sub_29 ( .A(out_sp), .SUM({N38, N37, N36, N35, N34, N33, N32, 
        N31}) );
  sp_DW01_inc_8_0 add_28 ( .A(out_sp), .SUM({N30, N29, N28, N27, N26, N25, N24, 
        N23}) );
  DFFRX4 out_sp_reg_7_ ( .D(n290), .CK(clk), .RN(n21), .Q(out_sp[7]), .QN(n320) );
  DFFRX4 out_sp_reg_6_ ( .D(n280), .CK(clk), .RN(n21), .Q(out_sp[6]), .QN(n330) );
  DFFRX4 out_sp_reg_5_ ( .D(n270), .CK(clk), .RN(n21), .Q(out_sp[5]), .QN(n340) );
  DFFRX4 out_sp_reg_4_ ( .D(n260), .CK(clk), .RN(n21), .Q(out_sp[4]), .QN(n350) );
  DFFRX4 out_sp_reg_3_ ( .D(n250), .CK(clk), .RN(n21), .Q(out_sp[3]), .QN(n360) );
  DFFSX4 out_sp_reg_2_ ( .D(n240), .CK(clk), .SN(n21), .Q(out_sp[2]), .QN(n370) );
  DFFSX4 out_sp_reg_1_ ( .D(n230), .CK(clk), .SN(n21), .Q(out_sp[1]) );
  DFFSX4 out_sp_reg_0_ ( .D(n22), .CK(clk), .SN(n21), .Q(out_sp[0]) );
endmodule


module sp_DW01_inc_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  XOR2X1 U5 ( .A(carry_7_), .B(A[7]), .Y(SUM[7]) );
  INVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
endmodule


module sp_DW01_dec_8_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;
  wire   carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_;

  XNOR2X1 U1_A_1 ( .A(A[1]), .B(A[0]), .Y(SUM[1]) );
  XNOR2X1 U1_A_7 ( .A(A[7]), .B(carry_7_), .Y(SUM[7]) );
  OR2X1 U1_B_6 ( .A(A[6]), .B(carry_6_), .Y(carry_7_) );
  XNOR2X1 U1_A_6 ( .A(A[6]), .B(carry_6_), .Y(SUM[6]) );
  OR2X1 U1_B_1 ( .A(A[1]), .B(A[0]), .Y(carry_2_) );
  XNOR2X1 U1_A_4 ( .A(A[4]), .B(carry_4_), .Y(SUM[4]) );
  XNOR2X1 U1_A_5 ( .A(A[5]), .B(carry_5_), .Y(SUM[5]) );
  OR2X1 U1_B_2 ( .A(A[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X1 U1_B_3 ( .A(A[3]), .B(carry_3_), .Y(carry_4_) );
  OR2X1 U1_B_4 ( .A(A[4]), .B(carry_4_), .Y(carry_5_) );
  OR2X1 U1_B_5 ( .A(A[5]), .B(carry_5_), .Y(carry_6_) );
  XNOR2X1 U1_A_2 ( .A(A[2]), .B(carry_2_), .Y(SUM[2]) );
  XNOR2X1 U1_A_3 ( .A(A[3]), .B(carry_3_), .Y(SUM[3]) );
  CLKINVX1 U6 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module gpio0 ( clk, rst_p, wr, rmw, combus, prt0_addr, p0_in, p0, p0_out );
  input [7:0] combus;
  input [7:0] prt0_addr;
  input [7:0] p0_in;
  output [7:0] p0;
  output [7:0] p0_out;
  input clk, rst_p, wr, rmw;
  wire   n2, n3, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33,
         n34, n35, n36, n37, n38, n39, n40, n41, n42;

  INVX1 U24 ( .A(prt0_addr[6]), .Y(n41) );
  MX2X1 U25 ( .S0(rmw), .B(p0_out[1]), .A(p0_in[1]), .Y(p0[1]) );
  INVX1 U26 ( .A(prt0_addr[7]), .Y(n21) );
  OR2X1 U27 ( .A(prt0_addr[2]), .B(prt0_addr[3]), .Y(n39) );
  CLKINVX1 U28 ( .A(n3), .Y(n2) );
  DFFSX1 p0_out_reg_0_ ( .D(n8), .CK(clk), .SN(n7), .Q(p0_out[0]), .QN(n23) );
  DFFSX1 p0_out_reg_2_ ( .D(n10), .CK(clk), .SN(n7), .Q(p0_out[2]), .QN(n22)
         );
  MXI2X1 U29 ( .S0(n2), .B(n31), .A(n20), .Y(n15) );
  INVX1 U30 ( .A(combus[7]), .Y(n31) );
  MXI2X1 U31 ( .S0(n2), .B(n32), .A(n19), .Y(n14) );
  INVX1 U32 ( .A(combus[6]), .Y(n32) );
  MXI2X1 U33 ( .S0(n2), .B(n33), .A(n17), .Y(n13) );
  INVX1 U34 ( .A(combus[5]), .Y(n33) );
  MXI2X1 U35 ( .S0(n2), .B(n34), .A(n18), .Y(n12) );
  INVX1 U36 ( .A(combus[4]), .Y(n34) );
  MXI2X1 U37 ( .S0(n2), .B(n35), .A(n16), .Y(n11) );
  INVX1 U38 ( .A(combus[3]), .Y(n35) );
  NAND3X1 U39 ( .A(n36), .B(n37), .C(wr), .Y(n3) );
  NOR2X1 U40 ( .A(n38), .B(n39), .Y(n37) );
  NAND3X1 U41 ( .A(n40), .B(n41), .C(n42), .Y(n38) );
  MXI2X1 U42 ( .S0(rmw), .B(n23), .A(n30), .Y(p0[0]) );
  CLKINVX1 U43 ( .A(p0_in[0]), .Y(n30) );
  MXI2X1 U44 ( .S0(rmw), .B(n22), .A(n29), .Y(p0[2]) );
  MXI2X1 U45 ( .S0(rmw), .B(n16), .A(n28), .Y(p0[3]) );
  MXI2X1 U46 ( .S0(rmw), .B(n17), .A(n26), .Y(p0[5]) );
  MXI2X1 U47 ( .S0(rmw), .B(n18), .A(n27), .Y(p0[4]) );
  MXI2X1 U48 ( .S0(rmw), .B(n19), .A(n25), .Y(p0[6]) );
  MXI2X1 U49 ( .S0(rmw), .B(n20), .A(n24), .Y(p0[7]) );
  AO22X1 U50 ( .A0(combus[2]), .A1(n2), .B0(p0_out[2]), .B1(n3), .Y(n10) );
  AO22X1 U51 ( .A0(combus[1]), .A1(n2), .B0(p0_out[1]), .B1(n3), .Y(n9) );
  AO22X1 U52 ( .A0(combus[0]), .A1(n2), .B0(p0_out[0]), .B1(n3), .Y(n8) );
  INVX1 U53 ( .A(rst_p), .Y(n7) );
  CLKINVX1 U54 ( .A(p0_in[7]), .Y(n24) );
  CLKINVX1 U55 ( .A(p0_in[5]), .Y(n26) );
  CLKINVX1 U56 ( .A(p0_in[2]), .Y(n29) );
  CLKINVX1 U57 ( .A(p0_in[3]), .Y(n28) );
  CLKINVX1 U58 ( .A(p0_in[6]), .Y(n25) );
  CLKINVX1 U59 ( .A(p0_in[4]), .Y(n27) );
  INVX1 U60 ( .A(prt0_addr[4]), .Y(n42) );
  NOR3X1 U61 ( .A(n21), .B(prt0_addr[1]), .C(prt0_addr[0]), .Y(n36) );
  INVX1 U62 ( .A(prt0_addr[5]), .Y(n40) );
  DFFSX4 p0_out_reg_7_ ( .D(n15), .CK(clk), .SN(n7), .Q(p0_out[7]), .QN(n20)
         );
  DFFSX4 p0_out_reg_6_ ( .D(n14), .CK(clk), .SN(n7), .Q(p0_out[6]), .QN(n19)
         );
  DFFSX4 p0_out_reg_5_ ( .D(n13), .CK(clk), .SN(n7), .Q(p0_out[5]), .QN(n17)
         );
  DFFSX4 p0_out_reg_4_ ( .D(n12), .CK(clk), .SN(n7), .Q(p0_out[4]), .QN(n18)
         );
  DFFSX4 p0_out_reg_3_ ( .D(n11), .CK(clk), .SN(n7), .Q(p0_out[3]), .QN(n16)
         );
  DFFSX4 p0_out_reg_1_ ( .D(n9), .CK(clk), .SN(n7), .Q(p0_out[1]) );
endmodule


module page_addr ( pc, code, xrom, page_addr_a );
  input [4:0] pc;
  input [2:0] code;
  input [7:0] xrom;
  output [15:0] page_addr_a;
  wire   n1, n3, n5, n7, n9, n11, n13, n15, n17, n19, n21, n23, n25, n27, n29,
         n31;

  CLKINVX1 U1 ( .A(n5), .Y(page_addr_a[2]) );
  CLKINVX1 U2 ( .A(xrom[2]), .Y(n5) );
  CLKINVX1 U3 ( .A(n11), .Y(page_addr_a[5]) );
  CLKINVX1 U4 ( .A(xrom[5]), .Y(n11) );
  CLKINVX1 U5 ( .A(n9), .Y(page_addr_a[4]) );
  CLKINVX1 U6 ( .A(xrom[4]), .Y(n9) );
  CLKINVX1 U7 ( .A(n7), .Y(page_addr_a[3]) );
  CLKINVX1 U8 ( .A(xrom[3]), .Y(n7) );
  CLKINVX1 U9 ( .A(n19), .Y(page_addr_a[9]) );
  INVX1 U10 ( .A(code[1]), .Y(n19) );
  CLKINVX1 U11 ( .A(n13), .Y(page_addr_a[6]) );
  CLKINVX1 U12 ( .A(xrom[6]), .Y(n13) );
  CLKINVX1 U13 ( .A(n15), .Y(page_addr_a[7]) );
  CLKINVX1 U14 ( .A(xrom[7]), .Y(n15) );
  CLKINVX1 U15 ( .A(n31), .Y(page_addr_a[15]) );
  CLKINVX1 U16 ( .A(pc[4]), .Y(n31) );
  CLKINVX1 U17 ( .A(n29), .Y(page_addr_a[14]) );
  CLKINVX1 U18 ( .A(pc[3]), .Y(n29) );
  CLKINVX1 U19 ( .A(n27), .Y(page_addr_a[13]) );
  CLKINVX1 U20 ( .A(pc[2]), .Y(n27) );
  CLKINVX1 U21 ( .A(n25), .Y(page_addr_a[12]) );
  CLKINVX1 U22 ( .A(pc[1]), .Y(n25) );
  CLKINVX1 U23 ( .A(n23), .Y(page_addr_a[11]) );
  CLKINVX1 U24 ( .A(pc[0]), .Y(n23) );
  CLKINVX1 U25 ( .A(n21), .Y(page_addr_a[10]) );
  INVX1 U26 ( .A(code[2]), .Y(n21) );
  CLKINVX1 U27 ( .A(n3), .Y(page_addr_a[1]) );
  CLKINVX1 U28 ( .A(xrom[1]), .Y(n3) );
  CLKINVX1 U29 ( .A(n1), .Y(page_addr_a[0]) );
  CLKINVX1 U30 ( .A(xrom[0]), .Y(n1) );
  CLKINVX1 U31 ( .A(n17), .Y(page_addr_a[8]) );
  INVX1 U32 ( .A(code[0]), .Y(n17) );
endmodule


module pc ( clk, rst_p, ld_pc, ld_pcl, ld_pch, inc_pc, in_pc, out_pc_r );
  input [15:0] in_pc;
  output [15:0] out_pc_r;
  input clk, rst_p, ld_pc, ld_pcl, ld_pch, inc_pc;
  wire   N15, N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28,
         N29, N30, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n1500, n1600, n1700, n180, n190, n200, n210, n220, n230, n250, n260,
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
         n152, n153, n154, n155, n156, n157, n158, n159, n16000, n161, n162,
         n163, n164, n165, n166, n167, n168, n169, n17000;

  CLKINVX1 U46 ( .A(rst_p), .Y(n280) );
  DFFRX2 out_pc_r_reg_0_ ( .D(n290), .CK(clk), .RN(n280), .Q(out_pc_r[0]), 
        .QN(n58) );
  DFFRX2 out_pc_r_reg_3_ ( .D(n32), .CK(clk), .RN(n280), .Q(out_pc_r[3]), .QN(
        n57) );
  DFFRX2 out_pc_r_reg_4_ ( .D(n33), .CK(clk), .RN(n280), .Q(out_pc_r[4]), .QN(
        n56) );
  DFFRX2 out_pc_r_reg_5_ ( .D(n34), .CK(clk), .RN(n280), .Q(out_pc_r[5]), .QN(
        n55) );
  DFFRX2 out_pc_r_reg_6_ ( .D(n35), .CK(clk), .RN(n280), .Q(out_pc_r[6]), .QN(
        n54) );
  DFFRX2 out_pc_r_reg_7_ ( .D(n36), .CK(clk), .RN(n280), .Q(out_pc_r[7]), .QN(
        n53) );
  DFFRX2 out_pc_r_reg_11_ ( .D(n40), .CK(clk), .RN(n280), .Q(out_pc_r[11]), 
        .QN(n49) );
  DFFRX2 out_pc_r_reg_12_ ( .D(n41), .CK(clk), .RN(n280), .Q(out_pc_r[12]), 
        .QN(n48) );
  DFFRX2 out_pc_r_reg_13_ ( .D(n42), .CK(clk), .RN(n280), .Q(out_pc_r[13]), 
        .QN(n47) );
  DFFRX2 out_pc_r_reg_14_ ( .D(n43), .CK(clk), .RN(n280), .Q(out_pc_r[14]), 
        .QN(n46) );
  DFFRX2 out_pc_r_reg_15_ ( .D(n44), .CK(clk), .RN(n280), .Q(out_pc_r[15]), 
        .QN(n45) );
  DFFRX2 out_pc_r_reg_1_ ( .D(n300), .CK(clk), .RN(n280), .Q(out_pc_r[1]) );
  INVX1 U47 ( .A(n95), .Y(n167) );
  INVX1 U48 ( .A(n99), .Y(n162) );
  INVX1 U49 ( .A(n66), .Y(n63) );
  INVX6 U50 ( .A(ld_pc), .Y(n60) );
  INVX1 U51 ( .A(n102), .Y(n157) );
  INVX1 U52 ( .A(n105), .Y(n152) );
  INVX1 U53 ( .A(n116), .Y(n120) );
  INVX1 U54 ( .A(n149), .Y(n146) );
  INVX1 U55 ( .A(n145), .Y(n142) );
  NAND3BX1 U56 ( .AN(ld_pch), .B(n59), .C(inc_pc), .Y(n65) );
  CLKINVX1 U57 ( .A(n80), .Y(n89) );
  NAND2X1 U58 ( .A(ld_pch), .B(n59), .Y(n80) );
  CLKINVX1 U59 ( .A(ld_pcl), .Y(n59) );
  CLKINVX1 U60 ( .A(n93), .Y(n109) );
  CLKINVX1 U61 ( .A(n71), .Y(n123) );
  NAND2X1 U62 ( .A(n80), .B(n17000), .Y(n71) );
  NAND2X1 U63 ( .A(n59), .B(n17000), .Y(n93) );
  NAND3X1 U64 ( .A(n17000), .B(n59), .C(n60), .Y(n67) );
  NAND2X1 U65 ( .A(in_pc[5]), .B(n164), .Y(n99) );
  NAND2X1 U66 ( .A(n59), .B(n60), .Y(n164) );
  NAND2X1 U67 ( .A(in_pc[6]), .B(n169), .Y(n95) );
  NAND2X1 U68 ( .A(n59), .B(n60), .Y(n169) );
  NAND2X1 U69 ( .A(in_pc[7]), .B(n91), .Y(n66) );
  NAND2X1 U70 ( .A(n59), .B(n60), .Y(n91) );
  CLKBUFX3 U71 ( .A(n65), .Y(n17000) );
  NOR2X1 U72 ( .A(n167), .B(n168), .Y(n165) );
  NOR2X1 U73 ( .A(ld_pc), .B(n65), .Y(n168) );
  NOR2X1 U74 ( .A(n162), .B(n163), .Y(n16000) );
  NOR2X1 U75 ( .A(ld_pc), .B(n65), .Y(n163) );
  NOR2X1 U76 ( .A(n157), .B(n158), .Y(n155) );
  NOR2X1 U77 ( .A(ld_pc), .B(n65), .Y(n158) );
  NOR2X1 U78 ( .A(n152), .B(n153), .Y(n15000) );
  NOR2X1 U79 ( .A(ld_pc), .B(n65), .Y(n153) );
  NOR2X1 U80 ( .A(n120), .B(n121), .Y(n118) );
  NOR2X1 U81 ( .A(ld_pc), .B(n17000), .Y(n121) );
  NOR2X1 U82 ( .A(n63), .B(n64), .Y(n61) );
  NOR2X1 U83 ( .A(ld_pc), .B(n65), .Y(n64) );
  OAI21X1 U84 ( .A0(ld_pc), .A1(ld_pcl), .B0(in_pc[2]), .Y(n149) );
  OAI21X1 U85 ( .A0(ld_pc), .A1(ld_pcl), .B0(in_pc[1]), .Y(n145) );
  OAI21X1 U86 ( .A0(ld_pc), .A1(n89), .B0(in_pc[15]), .Y(n141) );
  OAI22X1 U87 ( .A0(N30), .A1(n139), .B0(n139), .B1(n140), .Y(n70) );
  NOR2X1 U88 ( .A(ld_pc), .B(n17000), .Y(n140) );
  CLKINVX1 U89 ( .A(n141), .Y(n139) );
  OAI22X1 U90 ( .A0(N29), .A1(n136), .B0(n136), .B1(n137), .Y(n73) );
  NOR2X1 U91 ( .A(ld_pc), .B(n65), .Y(n137) );
  CLKINVX1 U92 ( .A(n138), .Y(n136) );
  OAI21X1 U93 ( .A0(ld_pc), .A1(n89), .B0(in_pc[14]), .Y(n138) );
  OAI22X1 U94 ( .A0(N28), .A1(n133), .B0(n133), .B1(n134), .Y(n75) );
  NOR2X1 U95 ( .A(ld_pc), .B(n17000), .Y(n134) );
  CLKINVX1 U96 ( .A(n135), .Y(n133) );
  OAI21X1 U97 ( .A0(ld_pc), .A1(n89), .B0(in_pc[13]), .Y(n135) );
  OAI22X1 U98 ( .A0(N27), .A1(n130), .B0(n130), .B1(n131), .Y(n77) );
  NOR2X1 U99 ( .A(ld_pc), .B(n65), .Y(n131) );
  CLKINVX1 U100 ( .A(n132), .Y(n130) );
  OAI21X1 U101 ( .A0(ld_pc), .A1(n89), .B0(in_pc[12]), .Y(n132) );
  OAI22X1 U102 ( .A0(N26), .A1(n127), .B0(n127), .B1(n128), .Y(n79) );
  NOR2X1 U103 ( .A(ld_pc), .B(n17000), .Y(n128) );
  CLKINVX1 U104 ( .A(n129), .Y(n127) );
  OAI21X1 U105 ( .A0(ld_pc), .A1(n89), .B0(in_pc[11]), .Y(n129) );
  OAI22X1 U106 ( .A0(N25), .A1(n124), .B0(n124), .B1(n125), .Y(n82) );
  NOR2X1 U107 ( .A(ld_pc), .B(n17000), .Y(n125) );
  CLKINVX1 U108 ( .A(n126), .Y(n124) );
  OAI21X1 U109 ( .A0(ld_pc), .A1(n89), .B0(in_pc[10]), .Y(n126) );
  OAI22X1 U110 ( .A0(N24), .A1(n112), .B0(n112), .B1(n113), .Y(n84) );
  NOR2X1 U111 ( .A(ld_pc), .B(n65), .Y(n113) );
  CLKINVX1 U112 ( .A(n114), .Y(n112) );
  OAI21X1 U113 ( .A0(ld_pc), .A1(n89), .B0(in_pc[9]), .Y(n114) );
  OAI22X1 U114 ( .A0(N23), .A1(n86), .B0(n86), .B1(n87), .Y(n68) );
  NOR2X1 U115 ( .A(ld_pc), .B(n65), .Y(n87) );
  CLKINVX1 U116 ( .A(n88), .Y(n86) );
  OAI21X1 U117 ( .A0(ld_pc), .A1(n89), .B0(in_pc[8]), .Y(n88) );
  OAI21X1 U118 ( .A0(n146), .A1(n147), .B0(n148), .Y(n108) );
  NOR2X1 U119 ( .A(ld_pc), .B(n17000), .Y(n147) );
  NAND2BX1 U120 ( .AN(N17), .B(n149), .Y(n148) );
  OAI21X1 U121 ( .A0(n142), .A1(n143), .B0(n144), .Y(n111) );
  NOR2X1 U122 ( .A(ld_pc), .B(n17000), .Y(n143) );
  NAND2BX1 U123 ( .AN(N16), .B(n145), .Y(n144) );
  NAND2X1 U124 ( .A(in_pc[4]), .B(n159), .Y(n102) );
  NAND2X1 U125 ( .A(n59), .B(n60), .Y(n159) );
  NAND2X1 U126 ( .A(in_pc[3]), .B(n154), .Y(n105) );
  NAND2X1 U127 ( .A(n59), .B(n60), .Y(n154) );
  NAND2X1 U128 ( .A(in_pc[0]), .B(n122), .Y(n116) );
  NAND2X1 U129 ( .A(n59), .B(n60), .Y(n122) );
  DFFRX1 out_pc_r_reg_2_ ( .D(n31), .CK(clk), .RN(n280), .Q(out_pc_r[2]) );
  DFFRX1 out_pc_r_reg_8_ ( .D(n37), .CK(clk), .RN(n280), .Q(out_pc_r[8]), .QN(
        n52) );
  DFFRX1 out_pc_r_reg_9_ ( .D(n38), .CK(clk), .RN(n280), .Q(out_pc_r[9]), .QN(
        n51) );
  DFFRX1 out_pc_r_reg_10_ ( .D(n39), .CK(clk), .RN(n280), .Q(out_pc_r[10]), 
        .QN(n50) );
  NOR2X1 U130 ( .A(N21), .B(n167), .Y(n166) );
  NOR2X1 U131 ( .A(N20), .B(n162), .Y(n161) );
  NOR2X1 U132 ( .A(N19), .B(n157), .Y(n156) );
  NOR2X1 U133 ( .A(N18), .B(n152), .Y(n151) );
  NOR2X1 U134 ( .A(N22), .B(n63), .Y(n62) );
  NOR2X1 U135 ( .A(N15), .B(n120), .Y(n119) );
  OAI21X1 U136 ( .A0(ld_pc), .A1(n115), .B0(n116), .Y(n290) );
  AOI21X1 U137 ( .A0(N15), .A1(n96), .B0(n117), .Y(n115) );
  NOR2X1 U138 ( .A(n93), .B(n58), .Y(n117) );
  OAI21X1 U139 ( .A0(ld_pc), .A1(n104), .B0(n105), .Y(n32) );
  AOI21X1 U140 ( .A0(N18), .A1(n96), .B0(n106), .Y(n104) );
  NOR2X1 U141 ( .A(n93), .B(n57), .Y(n106) );
  OAI21X1 U142 ( .A0(ld_pc), .A1(n101), .B0(n102), .Y(n33) );
  AOI21X1 U143 ( .A0(N19), .A1(n96), .B0(n103), .Y(n101) );
  NOR2X1 U144 ( .A(n93), .B(n56), .Y(n103) );
  OAI21X1 U145 ( .A0(ld_pc), .A1(n98), .B0(n99), .Y(n34) );
  AOI21X1 U146 ( .A0(N20), .A1(n96), .B0(n100), .Y(n98) );
  NOR2X1 U147 ( .A(n93), .B(n55), .Y(n100) );
  OAI21X1 U148 ( .A0(ld_pc), .A1(n94), .B0(n95), .Y(n35) );
  AOI21X1 U149 ( .A0(N21), .A1(n96), .B0(n97), .Y(n94) );
  CLKINVX1 U150 ( .A(n17000), .Y(n96) );
  NOR2X1 U151 ( .A(n93), .B(n54), .Y(n97) );
  OAI21X1 U152 ( .A0(ld_pc), .A1(n90), .B0(n66), .Y(n36) );
  AOI21X1 U153 ( .A0(N22), .A1(n96), .B0(n92), .Y(n90) );
  NOR2X1 U154 ( .A(n93), .B(n53), .Y(n92) );
  OAI21X1 U155 ( .A0(ld_pc), .A1(n110), .B0(n111), .Y(n300) );
  NAND2X1 U156 ( .A(n109), .B(out_pc_r[1]), .Y(n110) );
  OAI21X1 U157 ( .A0(ld_pc), .A1(n107), .B0(n108), .Y(n31) );
  NAND2X1 U158 ( .A(n109), .B(out_pc_r[2]), .Y(n107) );
  OAI2BB1X1 U159 ( .A0N(n85), .A1N(n60), .B0(n68), .Y(n37) );
  NOR2X1 U160 ( .A(n52), .B(n71), .Y(n85) );
  OAI2BB1X1 U161 ( .A0N(n83), .A1N(n60), .B0(n84), .Y(n38) );
  NOR2X1 U162 ( .A(n51), .B(n71), .Y(n83) );
  OAI2BB1X1 U163 ( .A0N(n81), .A1N(n60), .B0(n82), .Y(n39) );
  NOR2X1 U164 ( .A(n50), .B(n71), .Y(n81) );
  OAI2BB1X1 U165 ( .A0N(n78), .A1N(n60), .B0(n79), .Y(n40) );
  NOR2X1 U166 ( .A(n49), .B(n71), .Y(n78) );
  OAI2BB1X1 U167 ( .A0N(n76), .A1N(n60), .B0(n77), .Y(n41) );
  NOR2X1 U168 ( .A(n48), .B(n71), .Y(n76) );
  OAI2BB1X1 U169 ( .A0N(n74), .A1N(n60), .B0(n75), .Y(n42) );
  NOR2X1 U170 ( .A(n47), .B(n71), .Y(n74) );
  OAI2BB1X1 U171 ( .A0N(n72), .A1N(n60), .B0(n73), .Y(n43) );
  NOR2X1 U172 ( .A(n46), .B(n71), .Y(n72) );
  OAI2BB1X1 U173 ( .A0N(n69), .A1N(n60), .B0(n70), .Y(n44) );
  NOR2X1 U174 ( .A(n45), .B(n71), .Y(n69) );
  NAND2X6 U175 ( .A(n59), .B(n60), .Y(n9) );
  NOR2X8 U176 ( .A(n61), .B(n62), .Y(n8) );
  INVX8 U177 ( .A(n67), .Y(n7) );
  INVX8 U178 ( .A(n68), .Y(n6) );
  NOR2X8 U179 ( .A(ld_pc), .B(n17000), .Y(n5) );
  NAND2X6 U180 ( .A(n80), .B(n60), .Y(n4) );
  INVX8 U181 ( .A(n84), .Y(n3) );
  NOR2X8 U182 ( .A(ld_pc), .B(ld_pcl), .Y(n270) );
  NAND2X6 U183 ( .A(n109), .B(n60), .Y(n260) );
  NOR2X8 U184 ( .A(n118), .B(n119), .Y(n250) );
  NAND2X6 U185 ( .A(n96), .B(n60), .Y(n230) );
  NAND2X6 U186 ( .A(n123), .B(n60), .Y(n220) );
  INVX8 U187 ( .A(n82), .Y(n210) );
  INVX8 U188 ( .A(n79), .Y(n200) );
  NOR2X8 U189 ( .A(ld_pc), .B(n71), .Y(n2) );
  INVX8 U190 ( .A(n77), .Y(n190) );
  INVX8 U191 ( .A(n75), .Y(n180) );
  INVX8 U192 ( .A(n73), .Y(n1700) );
  INVX8 U193 ( .A(n70), .Y(n1600) );
  INVX8 U194 ( .A(n111), .Y(n1500) );
  INVX8 U195 ( .A(n108), .Y(n14) );
  NOR2X8 U196 ( .A(n15000), .B(n151), .Y(n13) );
  NOR2X8 U197 ( .A(n155), .B(n156), .Y(n12) );
  NOR2X8 U198 ( .A(n16000), .B(n161), .Y(n11) );
  NOR2X8 U199 ( .A(n165), .B(n166), .Y(n10) );
  pc_DW01_inc_16_0 add_28 ( .A(out_pc_r), .SUM({N30, N29, N28, N27, N26, N25, 
        N24, N23, N22, N21, N20, N19, N18, N17, N16, N15}) );
endmodule


module pc_DW01_inc_16_0 ( A, SUM );
  input [15:0] A;
  output [15:0] SUM;
  wire   carry_15_, carry_14_, carry_13_, carry_12_, carry_11_, carry_10_,
         carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_,
         carry_2_, n1;

  INVX1 U5 ( .A(A[0]), .Y(SUM[0]) );
  XNOR2X1 U6 ( .A(carry_15_), .B(n1), .Y(SUM[15]) );
  ADDHX1 U1_1_1 ( .A(A[1]), .B(A[0]), .S(SUM[1]), .CO(carry_2_) );
  ADDHX1 U1_1_11 ( .A(A[11]), .B(carry_11_), .S(SUM[11]), .CO(carry_12_) );
  ADDHX1 U1_1_12 ( .A(A[12]), .B(carry_12_), .S(SUM[12]), .CO(carry_13_) );
  ADDHX1 U1_1_13 ( .A(A[13]), .B(carry_13_), .S(SUM[13]), .CO(carry_14_) );
  ADDHX1 U1_1_3 ( .A(A[3]), .B(carry_3_), .S(SUM[3]), .CO(carry_4_) );
  ADDHX1 U1_1_4 ( .A(A[4]), .B(carry_4_), .S(SUM[4]), .CO(carry_5_) );
  ADDHX1 U1_1_5 ( .A(A[5]), .B(carry_5_), .S(SUM[5]), .CO(carry_6_) );
  ADDHX1 U1_1_6 ( .A(A[6]), .B(carry_6_), .S(SUM[6]), .CO(carry_7_) );
  ADDHX1 U1_1_7 ( .A(A[7]), .B(carry_7_), .S(SUM[7]), .CO(carry_8_) );
  ADDHX1 U1_1_2 ( .A(A[2]), .B(carry_2_), .S(SUM[2]), .CO(carry_3_) );
  ADDHX1 U1_1_8 ( .A(A[8]), .B(carry_8_), .S(SUM[8]), .CO(carry_9_) );
  ADDHX1 U1_1_9 ( .A(A[9]), .B(carry_9_), .S(SUM[9]), .CO(carry_10_) );
  ADDHX1 U1_1_10 ( .A(A[10]), .B(carry_10_), .S(SUM[10]), .CO(carry_11_) );
  ADDHX1 U1_1_14 ( .A(A[14]), .B(carry_14_), .S(SUM[14]), .CO(carry_15_) );
  CLKINVX1 U7 ( .A(A[15]), .Y(n1) );
endmodule


module sign ( a, b );
  input [7:0] a;
  output [15:0] b;
  wire   n3, n5, n7, n9, n11, n13, n15, n18;

  CLKINVX1 U4 ( .A(n18), .Y(b[15]) );
  CLKINVX1 U5 ( .A(b[8]), .Y(n18) );
  CLKINVX1 U6 ( .A(n5), .Y(b[1]) );
  INVX1 U7 ( .A(a[1]), .Y(n5) );
  CLKINVX1 U8 ( .A(n7), .Y(b[2]) );
  INVX1 U9 ( .A(a[2]), .Y(n7) );
  CLKINVX1 U10 ( .A(n9), .Y(b[3]) );
  INVX1 U11 ( .A(a[3]), .Y(n9) );
  CLKINVX1 U12 ( .A(n18), .Y(b[9]) );
  CLKINVX1 U13 ( .A(n11), .Y(b[4]) );
  INVX1 U14 ( .A(a[4]), .Y(n11) );
  CLKINVX1 U15 ( .A(n18), .Y(b[10]) );
  CLKINVX1 U16 ( .A(n13), .Y(b[5]) );
  INVX1 U17 ( .A(a[5]), .Y(n13) );
  CLKINVX1 U18 ( .A(n18), .Y(b[11]) );
  CLKINVX1 U19 ( .A(n15), .Y(b[6]) );
  INVX1 U20 ( .A(a[6]), .Y(n15) );
  CLKINVX1 U21 ( .A(n18), .Y(b[12]) );
  CLKINVX1 U22 ( .A(n18), .Y(b[7]) );
  CLKINVX1 U23 ( .A(n18), .Y(b[13]) );
  CLKINVX1 U24 ( .A(n18), .Y(b[14]) );
  CLKINVX1 U25 ( .A(n3), .Y(b[0]) );
  INVX1 U26 ( .A(a[0]), .Y(n3) );
  CLKBUFX2 U27 ( .A(a[7]), .Y(b[8]) );
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
  wire   en_itcnt, extend_mux, extend_wr, extend_rd, en_int1, N211, N282, N283,
         N284, N287, N288, N289, N482, N483, N484, N490, N491, N492, N493,
         N495, N496, n50, n52, n53, n54, n55, n59, n61, n66, n235, n238, n286,
         n2870, n293, n305, n306, n307, n308, n309, n310, n311, n312, n315,
         n317, n318, n319, n320, n321, n322, n323, n324, n325, n326, n327,
         n328, n329, n330, n331, n332, n333, n334, n335, n336, n337, n341,
         n342, n343, n344, n345, n346, n347, n348, n349, n350, n398, n399,
         n420, n421, n423, n425, n426, n4830, n4840, n485, n550, n551, n552,
         n553, n554, n555, n556, n557, n558, n559, n560, n561, n562, n563,
         n564, n565, n568, n569, n570, n571, n572, n573, n575, n576, n577,
         n578, n579, n580, n581, n582, n583, n584, n585, n586, n587, n588,
         n589, n590, n591, n592, n593, n594, n595, n596, n597, n598, n599,
         n600, n601, n602, n603, n604, n605, n606, n607, n608, n609, n610,
         n611, n612, n613, n614, n615, n616, n617, n618, n619, n620, n621,
         n622, n623, n624, n625, n626, n627, n628, n629, n630, n631, n632,
         n633, n634, n635, n636, n637, n638, n639, n640, n641, n642, n643,
         n644, n645, n646, n647, n648, n649, n650, n651, n652, n653, n654,
         n655, n656, n657, n658, n659, n660, n661, n662, n663, n665, n666,
         n667, n670, n671, n672, n673, n674, n675, n677, n678, n679, n680,
         n681, n682, n683, n684, n685, n686, n687, n688, n689, n690, n691,
         n692, n693, n694, n695, n696, n697, n698, n699, n700, n701, n702,
         n704, n706, n707, n708, n709, n710, n711, n712, n713, n714, n715,
         n716, n717, n718, n719, n720, n721, n722, n723, n724, n725, n726,
         n727, n728, n729, n730, n733, n734, n735, n736, n737, n738, n739,
         n740, n741, n742, n743, n744, n745, n746, n747, n748, n749, n750,
         n751, n752, n753, n754, n755, n756, n757, n758, n759, n760, n761,
         n762, n763, n764, n765, n766, n767, n768, n769, n770, n771, n772,
         n773, n774, n775, n776, n777, n778, n779, n780, n781, n782, n783,
         n784, n785, n786, n787, n788, n789, n790, n791, n792, n793, n794,
         n795, n796, n797, n798, n799, n800, n801, n802, n803, n804, n805,
         n806, n807, n808, n809, n810, n811, n812, n813, n814, n815, n816,
         n817, n818, n819, n820, n821, n822, n823, n824, n825, n826, n827,
         n828, n829, n830, n831, n832, n833, n834, n835, n836, n837, n838,
         n839, n840, n841, n842, n843, n844, n845, n846, n847, n848, n849,
         n850, n851, n852, n853, n854, n855, n856, n857, n858, n859, n860,
         n861, n862, n863, n864, n865, n866, n867, n868, n869, n870, n871,
         n872, n873, n874, n875, n876, n877, n878, n879, n880, n881, n882,
         n883, n884, n885, n886, n887, n888, n889, n890, n891, n892, n893,
         n894, n895, n896, n897, n898, n899, n900, n901, n902, n903, n904,
         n905, n906, n907, n908, n909, n910, n911, n912, n913, n914, n915,
         n916, n917, n918, n919, n920, n921, n922, n923, n924, n925, n926,
         n927, n928, n929, n930, n931, n932, n933, n934, n935, n936, n937,
         n938, n939, n940, n941, n942, n943, n944, n945, n946, n947, n948,
         n949, n950, n951, n952, n953, n954, n955, n956, n957, n958, n959,
         n960, n961, n962, n963, n964, n965, n966, n967, n968, n969, n970,
         n971, n972, n973, n974, n975, n976, n977, n978, n979, n980, n981,
         n982, n983, n984, n985, n986, n987, n988, n989, n990, n991, n992,
         n993, n994, n995, n996, n997, n998, n999, n1000, n1001, n1002, n1003,
         n1004, n1005, n1006, n1007, n1008, n1009, n1010, n1011, n1012, n1013,
         n1014, n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022, n1023,
         n1024, n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032, n1033,
         n1034, n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042, n1043,
         n1044, n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052, n1053,
         n1054, n1055, n1056, n1057, n1058, n1059, n1060, n1061, n1062, n1063,
         n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072, n1073,
         n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082, n1083,
         n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092, n1093,
         n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102, n1103,
         n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113,
         n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123,
         n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133,
         n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142, n1143,
         n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152, n1153,
         n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162, n1163,
         n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172, n1173,
         n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182, n1183,
         n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1191, n1192, n1193,
         n1194, n1195, n1196, n1198, n1199, n1200, n1201, n1202, n1203, n1204,
         n1205, n1206, n1207, n1208, n1209, n1210, n1211, n1212, n1213, n1214,
         n1215, n1216, n1217, n1218, n1219, n1220, n1221, n1222, n1223, n1224,
         n1225, n1226, n1227, n1228, n1229, n1230, n1231, n1232, n1233, n1234,
         n1235, n1236, n1237, n1238, n1239, n1240, n1241, n1242, n1243, n1244,
         n1245, n1246, n1247, n1248, n1249, n1250, n1251, n1252, n1253, n1254,
         n1255, n1256, n1257, n1258, n1259, n1260, n1261, n1262, n1263, n1264,
         n1265, n1266, n1267, n1268, n1269, n1270, n1271, n1272, n1273, n1274,
         n1275, n1276, n1277, n1278, n1279, n1280, n1281, n1282, n1283;
  wire   [3:0] t_2;

  one_shot_3 one_shot_en_int ( .rst_p(rst_p), .clk(clk), .d(en_int), .q(
        en_int1) );
  CLKINVX1 U630 ( .A(1'b1), .Y(psen) );
  INVX2 U632 ( .A(n659), .Y(n660) );
  INVX16 U633 ( .A(n1265), .Y(sel_addr0) );
  NAND2X4 U634 ( .A(n1261), .B(code[1]), .Y(n637) );
  NAND2X4 U635 ( .A(n1230), .B(code[1]), .Y(n825) );
  AND3X6 U636 ( .A(n720), .B(n721), .C(n1249), .Y(n585) );
  CLKINVX2 U637 ( .A(n625), .Y(n605) );
  AND2X8 U638 ( .A(n700), .B(n698), .Y(n568) );
  NAND2X4 U639 ( .A(n1235), .B(n871), .Y(n944) );
  NOR2X2 U640 ( .A(code[0]), .B(n1005), .Y(n1235) );
  INVX6 U641 ( .A(n824), .Y(n979) );
  NAND2X4 U642 ( .A(n979), .B(n662), .Y(n863) );
  INVX8 U643 ( .A(code[6]), .Y(n1249) );
  NAND2X4 U644 ( .A(n585), .B(n1250), .Y(n627) );
  CLKINVX3 U645 ( .A(code[4]), .Y(n593) );
  INVX2 U646 ( .A(n955), .Y(n1220) );
  NAND2X6 U647 ( .A(n700), .B(n1200), .Y(n1221) );
  NAND2X4 U648 ( .A(n779), .B(n1189), .Y(n617) );
  NOR2BX2 U649 ( .AN(n749), .B(n678), .Y(n677) );
  AND2X8 U650 ( .A(n699), .B(n700), .Y(n569) );
  INVX4 U651 ( .A(n714), .Y(n937) );
  AND2X4 U652 ( .A(n728), .B(n1210), .Y(n570) );
  OR2X8 U653 ( .A(n674), .B(n675), .Y(rmw) );
  CLKINVX1 U654 ( .A(n801), .Y(sel_op2[2]) );
  OAI21X2 U655 ( .A0(n799), .A1(en_div), .B0(n1184), .Y(n801) );
  CLKINVX8 U656 ( .A(n730), .Y(n1265) );
  NOR2X6 U657 ( .A(n965), .B(n966), .Y(n959) );
  NAND2BX4 U658 ( .AN(n599), .B(n587), .Y(n571) );
  NAND2BX2 U659 ( .AN(n599), .B(n587), .Y(n583) );
  NOR2X8 U660 ( .A(n647), .B(n586), .Y(n587) );
  AND2X1 U661 ( .A(n723), .B(n810), .Y(n572) );
  INVX4 U662 ( .A(n898), .Y(n723) );
  INVX3 U663 ( .A(n599), .Y(n573) );
  INVX4 U664 ( .A(code[5]), .Y(n721) );
  CLKAND2X2 U665 ( .A(code[6]), .B(code[7]), .Y(n584) );
  AND2X4 U666 ( .A(n721), .B(n593), .Y(n661) );
  NOR2BX2 U667 ( .AN(n1249), .B(n1250), .Y(n1257) );
  NAND2X2 U668 ( .A(code[0]), .B(n621), .Y(n643) );
  INVX8 U669 ( .A(n719), .Y(n720) );
  CLKINVX6 U670 ( .A(code[4]), .Y(n719) );
  CLKINVX8 U671 ( .A(n655), .Y(n656) );
  INVX3 U672 ( .A(n639), .Y(n640) );
  NAND2X4 U673 ( .A(n826), .B(n957), .Y(n954) );
  NAND4X4 U674 ( .A(n915), .B(n712), .C(n716), .D(n741), .Y(n951) );
  NAND2X6 U675 ( .A(n1267), .B(n1268), .Y(n712) );
  NAND2X4 U676 ( .A(n998), .B(n1220), .Y(n1210) );
  NAND3X6 U677 ( .A(n656), .B(n1221), .C(n895), .Y(n955) );
  NAND3X4 U678 ( .A(n588), .B(n599), .C(n701), .Y(n824) );
  AND2X8 U679 ( .A(n722), .B(n593), .Y(n701) );
  NOR3X6 U680 ( .A(n937), .B(n938), .C(n608), .Y(n935) );
  NOR2X4 U681 ( .A(n727), .B(n863), .Y(n938) );
  NAND2X2 U682 ( .A(n787), .B(n788), .Y(sel_op1[2]) );
  NAND3X1 U683 ( .A(n789), .B(n1272), .C(n711), .Y(n788) );
  INVX3 U684 ( .A(n595), .Y(n596) );
  NAND2X4 U685 ( .A(n569), .B(n810), .Y(n860) );
  NAND3X6 U686 ( .A(n935), .B(n934), .C(n780), .Y(sel_addr1[1]) );
  NOR2X6 U687 ( .A(n946), .B(n748), .Y(n945) );
  NAND3X1 U688 ( .A(n846), .B(n847), .C(n848), .Y(sel_combus[0]) );
  NOR3X1 U689 ( .A(n852), .B(n853), .C(n854), .Y(n847) );
  NOR2X1 U690 ( .A(n855), .B(n856), .Y(n854) );
  NAND4BBX1 U691 ( .AN(n828), .BN(n803), .C(n829), .D(n830), .Y(sel_combus[1])
         );
  INVX4 U692 ( .A(n912), .Y(n1065) );
  NAND3X6 U693 ( .A(n926), .B(n718), .C(n927), .Y(sel_addr1[2]) );
  INVX2 U694 ( .A(n894), .Y(n870) );
  CLKINVX8 U695 ( .A(n1274), .Y(n786) );
  CLKINVX1 U696 ( .A(n1103), .Y(n329) );
  BUFX12 U697 ( .A(n794), .Y(n1270) );
  NAND2X6 U698 ( .A(n1215), .B(n1065), .Y(n1247) );
  INVX3 U699 ( .A(code[5]), .Y(n722) );
  CLKINVX3 U700 ( .A(n1247), .Y(n936) );
  BUFX8 U701 ( .A(n745), .Y(n1274) );
  NAND4X4 U702 ( .A(n596), .B(n1281), .C(n654), .D(n630), .Y(n745) );
  INVX1 U703 ( .A(n952), .Y(n903) );
  NOR3X2 U704 ( .A(n1157), .B(n1057), .C(n1248), .Y(n1013) );
  INVX1 U705 ( .A(n619), .Y(n773) );
  NOR2X4 U706 ( .A(n1048), .B(n782), .Y(n1063) );
  NOR2X1 U707 ( .A(n570), .B(n1217), .Y(n1216) );
  NAND3X1 U708 ( .A(n818), .B(n688), .C(n819), .Y(n817) );
  NOR3X1 U709 ( .A(n820), .B(n821), .C(n822), .Y(n819) );
  NOR2X1 U710 ( .A(n892), .B(n893), .Y(n885) );
  NAND2X1 U711 ( .A(n870), .B(n1266), .Y(n868) );
  NAND2X1 U712 ( .A(n1227), .B(n1228), .Y(n1016) );
  NAND2X1 U713 ( .A(n863), .B(n612), .Y(n1227) );
  INVX1 U714 ( .A(n1221), .Y(n1185) );
  INVX1 U715 ( .A(n801), .Y(n704) );
  INVX1 U716 ( .A(n835), .Y(n865) );
  NAND2X4 U717 ( .A(n881), .B(n797), .Y(n1157) );
  NAND2X4 U718 ( .A(n700), .B(n698), .Y(n716) );
  NAND2X1 U719 ( .A(n1005), .B(n765), .Y(n1260) );
  NAND2X2 U720 ( .A(n665), .B(n666), .Y(sel_alu[1]) );
  NAND4X2 U721 ( .A(n908), .B(n909), .C(n910), .D(n875), .Y(sel_alu[0]) );
  NAND2X1 U722 ( .A(n861), .B(n919), .Y(n909) );
  CLKINVX3 U723 ( .A(n928), .Y(n592) );
  INVX1 U724 ( .A(n872), .Y(n890) );
  OAI33X1 U725 ( .A0(n4830), .A1(out_dimod_r[2]), .A2(n399), .B0(n52), .B1(
        n4840), .B2(n485), .Y(n420) );
  CLKINVX1 U726 ( .A(n632), .Y(n633) );
  NAND3X2 U727 ( .A(n1066), .B(n1067), .C(n1068), .Y(n1048) );
  DFFRHQX4 timing_cnt_reg_0_ ( .D(n562), .CK(clk), .RN(n551), .Q(n595) );
  DFFRHQX4 itcnt_reg_0_ ( .D(n552), .CK(clk), .RN(n551), .Q(n632) );
  NAND4X2 U728 ( .A(n682), .B(n884), .C(n885), .D(n886), .Y(sel_alu[2]) );
  AND2X8 U729 ( .A(n1229), .B(n1230), .Y(n575) );
  AND4X1 U730 ( .A(n305), .B(n1073), .C(n306), .D(n307), .Y(n576) );
  INVX4 U731 ( .A(code[0]), .Y(n1231) );
  CLKINVX1 U732 ( .A(n889), .Y(n591) );
  INVX1 U733 ( .A(n620), .Y(n1075) );
  INVX3 U734 ( .A(n983), .Y(n655) );
  INVX4 U735 ( .A(n1244), .Y(n647) );
  OA21X2 U736 ( .A0(n610), .A1(n955), .B0(n575), .Y(n679) );
  NAND2X4 U737 ( .A(n585), .B(n1250), .Y(n900) );
  NAND2X4 U738 ( .A(n584), .B(n661), .Y(n706) );
  INVX2 U739 ( .A(n1250), .Y(n586) );
  NOR3X4 U740 ( .A(n954), .B(n955), .C(n956), .Y(n948) );
  CLKAND2X4 U741 ( .A(n720), .B(code[5]), .Y(n698) );
  NAND2X1 U742 ( .A(n728), .B(n792), .Y(n1189) );
  INVX4 U743 ( .A(n617), .Y(n793) );
  NAND3X1 U744 ( .A(n1250), .B(n1249), .C(code[5]), .Y(n659) );
  DFFRHQX4 timing_cnt_reg_3_ ( .D(n565), .CK(clk), .RN(n551), .Q(n653) );
  INVX2 U745 ( .A(n653), .Y(n654) );
  CLKBUFX3 U746 ( .A(n741), .Y(n727) );
  CLKINVX1 U747 ( .A(n726), .Y(n804) );
  NAND2X6 U748 ( .A(n723), .B(n810), .Y(n826) );
  INVX4 U749 ( .A(n860), .Y(n928) );
  INVX3 U750 ( .A(n1250), .Y(n588) );
  INVX12 U751 ( .A(code[7]), .Y(n1250) );
  CLKBUFX2 U752 ( .A(n962), .Y(n589) );
  CLKBUFX2 U753 ( .A(n842), .Y(n590) );
  BUFX6 U754 ( .A(n699), .Y(n1267) );
  NAND2X1 U755 ( .A(n628), .B(n591), .Y(n594) );
  NAND2X1 U756 ( .A(n628), .B(n571), .Y(n792) );
  BUFX8 U757 ( .A(n595), .Y(n1280) );
  NOR2X4 U758 ( .A(n597), .B(n629), .Y(n943) );
  AND3X8 U759 ( .A(n620), .B(n622), .C(n632), .Y(n597) );
  INVX1 U760 ( .A(n1266), .Y(n598) );
  NAND2X4 U761 ( .A(n943), .B(n944), .Y(n940) );
  INVX6 U762 ( .A(n1249), .Y(n599) );
  NAND4BX4 U763 ( .AN(n988), .B(n989), .C(n990), .D(n793), .Y(n965) );
  NAND3X2 U764 ( .A(n571), .B(n627), .C(n706), .Y(n600) );
  NAND3X2 U765 ( .A(n583), .B(n706), .C(n627), .Y(n1195) );
  INVX3 U766 ( .A(n979), .Y(n609) );
  CLKINVX3 U767 ( .A(n723), .Y(n601) );
  INVX4 U768 ( .A(n601), .Y(n602) );
  NAND2X1 U769 ( .A(n786), .B(n810), .Y(n604) );
  NAND2X1 U770 ( .A(n786), .B(n810), .Y(n603) );
  NAND2X2 U771 ( .A(n786), .B(n810), .Y(n791) );
  INVX3 U772 ( .A(n605), .Y(n606) );
  INVX6 U773 ( .A(n1252), .Y(n1200) );
  NAND2X2 U774 ( .A(n722), .B(n720), .Y(n1252) );
  CLKINVX1 U775 ( .A(n568), .Y(n607) );
  NOR2X6 U776 ( .A(n1247), .B(n1270), .Y(n608) );
  CLKINVX6 U777 ( .A(n794), .Y(n939) );
  NAND2X2 U778 ( .A(n644), .B(n649), .Y(n781) );
  AOI21X4 U779 ( .A0(n793), .A1(n614), .B0(n1274), .Y(n1188) );
  NAND2X1 U780 ( .A(n1229), .B(n1230), .Y(n613) );
  NAND3X1 U781 ( .A(n717), .B(n957), .C(n915), .Y(n610) );
  NAND3X1 U782 ( .A(n717), .B(n957), .C(n915), .Y(n611) );
  NAND3X2 U783 ( .A(n957), .B(n717), .C(n915), .Y(n1211) );
  NOR2X4 U784 ( .A(n570), .B(n995), .Y(n989) );
  NAND2X2 U785 ( .A(n1229), .B(n1230), .Y(n612) );
  NOR2X4 U786 ( .A(code[1]), .B(n1231), .Y(n1229) );
  INVX1 U787 ( .A(n842), .Y(n614) );
  CLKBUFX2 U788 ( .A(n944), .Y(n615) );
  CLKINVX6 U789 ( .A(code[2]), .Y(n1261) );
  NAND2X6 U790 ( .A(n638), .B(n993), .Y(n1005) );
  OAI21X2 U791 ( .A0(n1188), .A1(n1187), .B0(n728), .Y(n962) );
  INVX1 U792 ( .A(n1146), .Y(n616) );
  NAND2X6 U793 ( .A(n728), .B(n1269), .Y(n779) );
  BUFX16 U794 ( .A(n759), .Y(n1269) );
  CLKBUFX2 U795 ( .A(n662), .Y(n618) );
  NOR3BX4 U796 ( .AN(n623), .B(n620), .C(n632), .Y(n619) );
  INVX1 U797 ( .A(n593), .Y(n621) );
  AOI2BB2X4 U798 ( .A0N(n860), .A1N(n726), .B0(n929), .B1(n786), .Y(n927) );
  INVX12 U799 ( .A(n726), .Y(n735) );
  NAND2X6 U800 ( .A(n1200), .B(n1219), .Y(n1251) );
  INVX3 U801 ( .A(n999), .Y(n842) );
  DFFRHQX4 itcnt_reg_1_ ( .D(n553), .CK(clk), .RN(n551), .Q(n622) );
  INVX3 U802 ( .A(n622), .Y(n623) );
  INVX1 U803 ( .A(n937), .Y(n624) );
  NAND2X4 U804 ( .A(n940), .B(n941), .Y(n714) );
  NOR2X4 U805 ( .A(n720), .B(code[5]), .Y(n1244) );
  INVX1 U806 ( .A(n720), .Y(n625) );
  INVX1 U807 ( .A(n1231), .Y(n626) );
  INVX3 U808 ( .A(n900), .Y(n871) );
  AND2X4 U809 ( .A(n593), .B(code[5]), .Y(n699) );
  NAND2X6 U810 ( .A(n660), .B(n606), .Y(n895) );
  INVX4 U811 ( .A(n1005), .Y(n968) );
  INVX4 U812 ( .A(n637), .Y(n638) );
  NAND2X4 U813 ( .A(n930), .B(n804), .Y(n718) );
  CLKBUFX2 U814 ( .A(n1215), .Y(n658) );
  CLKAND2X4 U815 ( .A(n961), .B(n962), .Y(n960) );
  INVX3 U816 ( .A(n1211), .Y(n998) );
  NAND2X4 U817 ( .A(n968), .B(n1231), .Y(n912) );
  NAND2X6 U818 ( .A(n1266), .B(n662), .Y(n733) );
  NAND2X4 U819 ( .A(n759), .B(n662), .Y(n748) );
  NAND2X6 U820 ( .A(n656), .B(n895), .Y(n1215) );
  AND2X8 U821 ( .A(n599), .B(n1250), .Y(n725) );
  NOR2X2 U822 ( .A(n643), .B(n1242), .Y(n629) );
  OR2X1 U823 ( .A(n643), .B(n1242), .Y(n1146) );
  AND2X8 U824 ( .A(n1249), .B(code[7]), .Y(n700) );
  NAND2X1 U825 ( .A(n1250), .B(n585), .Y(n628) );
  BUFX6 U826 ( .A(n871), .Y(n1266) );
  NAND3X4 U827 ( .A(n1261), .B(n1262), .C(n993), .Y(n1242) );
  DFFRHQX8 timing_cnt_reg_1_ ( .D(n563), .CK(clk), .RN(n551), .Q(n630) );
  INVX8 U828 ( .A(n630), .Y(n631) );
  INVX4 U829 ( .A(n1242), .Y(n1236) );
  NAND2X2 U830 ( .A(n600), .B(n810), .Y(n634) );
  NAND2X2 U831 ( .A(n1195), .B(n810), .Y(n953) );
  NAND2X4 U832 ( .A(n1258), .B(n1040), .Y(n651) );
  AND2X1 U833 ( .A(n575), .B(n594), .Y(n678) );
  NAND2X6 U834 ( .A(n1269), .B(n575), .Y(n749) );
  NAND3X2 U835 ( .A(n620), .B(n622), .C(n632), .Y(n942) );
  INVX1 U836 ( .A(n1264), .Y(n635) );
  INVX6 U837 ( .A(n1264), .Y(n1230) );
  INVX12 U838 ( .A(n825), .Y(n810) );
  CLKINVX4 U839 ( .A(n634), .Y(n950) );
  CLKBUFX2 U840 ( .A(n912), .Y(n636) );
  CLKINVX1 U841 ( .A(n1280), .Y(N493) );
  NAND2X2 U842 ( .A(n720), .B(code[5]), .Y(n639) );
  NAND3X2 U843 ( .A(n640), .B(n1250), .C(n573), .Y(n983) );
  NAND3BX2 U844 ( .AN(n692), .B(n860), .C(n967), .Y(n966) );
  INVX1 U845 ( .A(n1219), .Y(n641) );
  NOR2X8 U846 ( .A(n631), .B(n596), .Y(n1258) );
  CLKBUFX2 U847 ( .A(n1242), .Y(n642) );
  CLKBUFX2 U848 ( .A(n936), .Y(n644) );
  CLKBUFX2 U849 ( .A(n1268), .Y(n645) );
  INVX3 U850 ( .A(msb_a), .Y(n711) );
  NAND2X4 U851 ( .A(code[2]), .B(n993), .Y(n1264) );
  NAND4X4 U852 ( .A(n631), .B(n1281), .C(n654), .D(n1280), .Y(n794) );
  CLKBUFX2 U853 ( .A(n656), .Y(n646) );
  INVX1 U854 ( .A(n590), .Y(n648) );
  CLKBUFX2 U855 ( .A(n939), .Y(n649) );
  INVX1 U856 ( .A(n950), .Y(n713) );
  CLKBUFX2 U857 ( .A(n600), .Y(n650) );
  BUFX20 U858 ( .A(n741), .Y(n726) );
  DFFRHQX4 timing_cnt_reg_2_ ( .D(n564), .CK(clk), .RN(n551), .Q(n652) );
  NAND2X1 U859 ( .A(n993), .B(n707), .Y(n843) );
  NAND2X1 U860 ( .A(n728), .B(n723), .Y(n814) );
  AND2X4 U861 ( .A(n1184), .B(n602), .Y(en_div) );
  NAND2X8 U862 ( .A(n701), .B(n1268), .Y(n915) );
  NAND2X2 U863 ( .A(n808), .B(n713), .Y(n992) );
  NAND2X4 U864 ( .A(n810), .B(n1269), .Y(n808) );
  BUFX20 U865 ( .A(n725), .Y(n1268) );
  NAND2X4 U866 ( .A(n575), .B(n842), .Y(n931) );
  INVX1 U867 ( .A(n631), .Y(n1029) );
  INVX4 U868 ( .A(n766), .Y(n1219) );
  INVX4 U869 ( .A(code[1]), .Y(n1262) );
  NAND2X8 U870 ( .A(n1258), .B(n1040), .Y(n741) );
  INVX1 U871 ( .A(n912), .Y(n657) );
  NAND2X4 U872 ( .A(n745), .B(n651), .Y(n933) );
  NAND3X2 U873 ( .A(n651), .B(n942), .C(n745), .Y(n941) );
  NAND2X2 U874 ( .A(n1268), .B(n1267), .Y(n717) );
  CLKINVX1 U875 ( .A(n895), .Y(n916) );
  NOR2X1 U876 ( .A(n894), .B(n895), .Y(n892) );
  CLKBUFX2 U877 ( .A(code[3]), .Y(n728) );
  CLKINVX8 U878 ( .A(code[3]), .Y(n993) );
  AND2X8 U879 ( .A(n1236), .B(n1231), .Y(n662) );
  NAND2X2 U880 ( .A(n725), .B(n698), .Y(n999) );
  OR2X8 U881 ( .A(n652), .B(n653), .Y(n1259) );
  INVX6 U882 ( .A(n652), .Y(n1281) );
  NAND2X2 U883 ( .A(code[7]), .B(code[6]), .Y(n766) );
  INVX2 U884 ( .A(n753), .Y(n964) );
  INVX2 U885 ( .A(n994), .Y(n922) );
  INVX1 U886 ( .A(n814), .Y(n969) );
  INVX1 U887 ( .A(n919), .Y(n899) );
  AND2X1 U888 ( .A(n889), .B(n913), .Y(n681) );
  INVX1 U889 ( .A(n862), .Y(n963) );
  NOR2X1 U890 ( .A(n1128), .B(sel_bit_dat_out[0]), .Y(n1127) );
  NAND2X2 U891 ( .A(n1126), .B(n1127), .Y(n816) );
  INVX3 U892 ( .A(n1130), .Y(n881) );
  CLKINVX1 U893 ( .A(N287), .Y(n1052) );
  CLKINVX1 U894 ( .A(n1124), .Y(n663) );
  OR2X4 U895 ( .A(n1225), .B(n785), .Y(n675) );
  INVX1 U896 ( .A(n795), .Y(sel_op1[1]) );
  NAND2X2 U897 ( .A(n1253), .B(n1254), .Y(n1130) );
  INVX4 U898 ( .A(n671), .Y(sel_op1[0]) );
  INVX3 U899 ( .A(n1273), .Y(n672) );
  INVX2 U900 ( .A(n677), .Y(n789) );
  AOI21X1 U901 ( .A0(n997), .A1(n998), .B0(n709), .Y(n988) );
  XOR2X1 U902 ( .A(n1282), .B(n1281), .Y(N495) );
  NOR2X1 U903 ( .A(n235), .B(n691), .Y(set_v) );
  INVX1 U904 ( .A(n733), .Y(n1225) );
  INVX1 U905 ( .A(n784), .Y(sel_op2[0]) );
  INVX1 U906 ( .A(n1057), .Y(n850) );
  INVX4 U907 ( .A(n931), .Y(n930) );
  OAI2BB1X4 U908 ( .A0N(n796), .A1N(n795), .B0(n672), .Y(n671) );
  OR2X1 U909 ( .A(n1057), .B(n789), .Y(n674) );
  NAND2X1 U910 ( .A(n1184), .B(n1210), .Y(n784) );
  NOR2X2 U911 ( .A(n904), .B(n905), .Y(n665) );
  INVX1 U912 ( .A(n977), .Y(n758) );
  NAND2X2 U913 ( .A(n661), .B(n1257), .Y(n898) );
  NAND2X1 U914 ( .A(n1102), .B(n329), .Y(n293) );
  INVX1 U915 ( .A(ov), .Y(n235) );
  INVX1 U916 ( .A(n864), .Y(ld_acc_chd) );
  INVX1 U917 ( .A(n832), .Y(n866) );
  INVX1 U918 ( .A(n851), .Y(ld_c) );
  INVX6 U919 ( .A(n711), .Y(n710) );
  INVX1 U920 ( .A(n876), .Y(n901) );
  NAND2X1 U921 ( .A(n865), .B(n866), .Y(n852) );
  NAND2X1 U922 ( .A(n735), .B(n1157), .Y(n851) );
  INVX1 U923 ( .A(n867), .Y(sel_bit_dat_out[1]) );
  INVX1 U924 ( .A(n836), .Y(n1168) );
  INVX1 U925 ( .A(n748), .Y(n1124) );
  NAND3X2 U926 ( .A(n921), .B(n869), .C(n867), .Y(n1057) );
  NAND2X1 U927 ( .A(n796), .B(n1011), .Y(n785) );
  OAI21X1 U928 ( .A0(n711), .A1(n783), .B0(n784), .Y(sel_op2[1]) );
  INVX3 U929 ( .A(sel_in_cy_bit[1]), .Y(n1254) );
  NOR2X2 U930 ( .A(n901), .B(n902), .Y(n666) );
  INVX1 U931 ( .A(n883), .Y(n886) );
  INVX1 U932 ( .A(n925), .Y(n924) );
  NAND3X1 U933 ( .A(n1134), .B(n1133), .C(n1176), .Y(n1137) );
  OA21X1 U934 ( .A0(n740), .A1(n726), .B0(n742), .Y(n667) );
  INVX1 U935 ( .A(n1133), .Y(ld_apc) );
  INVX1 U936 ( .A(n1134), .Y(ld_adptr) );
  NOR2X1 U937 ( .A(n1061), .B(n711), .Y(ld_sfr) );
  INVX1 U938 ( .A(n796), .Y(n1172) );
  NAND2BX1 U939 ( .AN(n1060), .B(n1053), .Y(ld_xrom) );
  AOI21X1 U940 ( .A0(n808), .A1(n845), .B0(n1270), .Y(ld_latch_acc) );
  INVX1 U941 ( .A(n797), .Y(sel_in_cy_bit[2]) );
  INVX1 U942 ( .A(n751), .Y(n1183) );
  AOI21X1 U943 ( .A0(n963), .A1(n735), .B0(n964), .Y(n961) );
  INVX8 U944 ( .A(n1251), .Y(n759) );
  NAND2X1 U945 ( .A(n699), .B(n1219), .Y(n994) );
  NAND2X2 U946 ( .A(n1255), .B(n1256), .Y(sel_in_cy_bit[1]) );
  OAI21X1 U947 ( .A0(n811), .A1(n726), .B0(n812), .Y(sel_combus[2]) );
  NOR3X1 U948 ( .A(n815), .B(n816), .C(n817), .Y(n811) );
  INVX1 U949 ( .A(n904), .Y(n908) );
  NOR2X1 U950 ( .A(n834), .B(n835), .Y(n829) );
  NAND3X1 U951 ( .A(n839), .B(n840), .C(n841), .Y(n828) );
  NAND2X1 U952 ( .A(n911), .B(n879), .Y(n875) );
  NAND3X1 U953 ( .A(n887), .B(n888), .C(n827), .Y(n883) );
  NAND2X1 U954 ( .A(n906), .B(n907), .Y(n905) );
  OR2X4 U955 ( .A(n923), .B(n924), .Y(n680) );
  OAI21X1 U956 ( .A0(n575), .A1(n810), .B0(n979), .Y(n845) );
  NAND4X1 U957 ( .A(n800), .B(n801), .C(n683), .D(n802), .Y(sel_combus[3]) );
  INVX1 U958 ( .A(n1142), .Y(n818) );
  NOR2X1 U959 ( .A(n684), .B(n685), .Y(n683) );
  NOR2BX1 U960 ( .AN(n921), .B(n963), .Y(n1129) );
  INVX1 U961 ( .A(n1190), .Y(n891) );
  NAND3X1 U962 ( .A(n683), .B(n1204), .C(n1205), .Y(n1136) );
  NAND2X1 U963 ( .A(n677), .B(n1017), .Y(n1014) );
  OAI21X1 U964 ( .A0(n710), .A1(n1061), .B0(n1116), .Y(ld_idat) );
  NAND2X1 U965 ( .A(n767), .B(n768), .Y(sel_pc[2]) );
  INVX1 U966 ( .A(n779), .Y(n1069) );
  INVX1 U967 ( .A(n1047), .Y(n1046) );
  NAND2X1 U968 ( .A(n1236), .B(n1231), .Y(n765) );
  AND2X1 U969 ( .A(n568), .B(n843), .Y(n692) );
  NAND2X1 U970 ( .A(n728), .B(n979), .Y(n996) );
  INVX3 U971 ( .A(n1076), .Y(n286) );
  NAND2X1 U972 ( .A(n1106), .B(n1044), .Y(n1105) );
  NOR3X1 U973 ( .A(n1043), .B(combus[1]), .C(combus[0]), .Y(n1102) );
  NAND2X1 U974 ( .A(n324), .B(n1111), .Y(n1110) );
  INVX1 U975 ( .A(n1108), .Y(n321) );
  INVX1 U976 ( .A(n656), .Y(n861) );
  NOR2X1 U977 ( .A(n896), .B(n897), .Y(n884) );
  NAND3X2 U978 ( .A(n1018), .B(n1019), .C(n1020), .Y(n763) );
  INVX1 U979 ( .A(n1114), .Y(n337) );
  INVX1 U980 ( .A(out_acc_r[1]), .Y(n1073) );
  NOR2BX1 U981 ( .AN(n654), .B(n1029), .Y(n1037) );
  XOR2X1 U982 ( .A(n1275), .B(n1075), .Y(N482) );
  INVX1 U983 ( .A(n1231), .Y(addr_bank_a[0]) );
  NOR2X1 U984 ( .A(n1045), .B(n1095), .Y(n1077) );
  NOR3X1 U985 ( .A(n1270), .B(n642), .C(n1243), .Y(sel_page_addr) );
  CLKINVX1 U986 ( .A(n801), .Y(ld_b) );
  NOR2X1 U987 ( .A(n670), .B(ld_acc_chd), .Y(n841) );
  NAND2X1 U988 ( .A(n850), .B(n851), .Y(n849) );
  AND2X1 U989 ( .A(n1168), .B(n1272), .Y(ld_dph) );
  NAND2X1 U990 ( .A(n1168), .B(n735), .Y(n1132) );
  NAND2X1 U991 ( .A(n1124), .B(n735), .Y(n1246) );
  NOR2X4 U992 ( .A(n771), .B(n1013), .Y(bit_addr) );
  NAND2X1 U993 ( .A(n923), .B(n1272), .Y(n864) );
  NAND2X1 U994 ( .A(n1062), .B(n781), .Y(n832) );
  CLKINVX1 U995 ( .A(n1137), .Y(n837) );
  AND2X1 U996 ( .A(n930), .B(n735), .Y(n670) );
  NOR2X1 U997 ( .A(n771), .B(n836), .Y(n834) );
  CLKINVX1 U998 ( .A(n1022), .Y(sel_code_xdat) );
  NAND2X1 U999 ( .A(n1009), .B(n735), .Y(n739) );
  NOR2X1 U1000 ( .A(n928), .B(n992), .Y(n1194) );
  NAND2X1 U1001 ( .A(n667), .B(n739), .Y(n738) );
  CLKINVX1 U1002 ( .A(ac), .Y(n66) );
  INVX1 U1003 ( .A(n1062), .Y(ld_pcl) );
  INVX1 U1004 ( .A(n1157), .Y(n1156) );
  CLKINVX1 U1005 ( .A(n1160), .Y(n1198) );
  OAI21X1 U1006 ( .A0(n1185), .A1(n568), .B0(n1065), .Y(n867) );
  NAND2X1 U1007 ( .A(n776), .B(n733), .Y(n1248) );
  NOR2BX2 U1008 ( .AN(n673), .B(n790), .Y(n787) );
  OR2X1 U1009 ( .A(n793), .B(n1270), .Y(n673) );
  NAND2X1 U1010 ( .A(n1065), .B(n759), .Y(n869) );
  INVX1 U1011 ( .A(n933), .Y(n771) );
  INVX2 U1012 ( .A(n982), .Y(n1184) );
  NAND2X2 U1013 ( .A(n903), .B(n879), .Y(n876) );
  NOR2BX1 U1014 ( .AN(n879), .B(n878), .Y(n877) );
  NAND4BX1 U1015 ( .AN(n873), .B(n874), .C(n875), .D(n876), .Y(sel_alu[3]) );
  NAND2X1 U1016 ( .A(n880), .B(n881), .Y(n873) );
  NOR2X1 U1017 ( .A(n877), .B(n686), .Y(n874) );
  NAND2X1 U1018 ( .A(n657), .B(n568), .Y(n827) );
  MXI2X1 U1019 ( .S0(n710), .B(n827), .A(n797), .Y(n815) );
  NOR2X1 U1020 ( .A(n882), .B(n883), .Y(n880) );
  NAND2X1 U1021 ( .A(n1208), .B(n1209), .Y(n1207) );
  NAND2X1 U1022 ( .A(n1002), .B(n1210), .Y(n1209) );
  NAND2X1 U1023 ( .A(n679), .B(n1272), .Y(n1208) );
  CLKINVX3 U1024 ( .A(n1136), .Y(n846) );
  INVX1 U1025 ( .A(n808), .Y(n923) );
  NAND2X1 U1026 ( .A(n837), .B(n838), .Y(n803) );
  NAND2X1 U1027 ( .A(n758), .B(n602), .Y(n838) );
  NAND2X1 U1028 ( .A(n1185), .B(n662), .Y(n836) );
  NAND3BX1 U1029 ( .AN(n755), .B(n756), .C(n757), .Y(set_c) );
  NAND2X1 U1030 ( .A(n758), .B(n759), .Y(n757) );
  NAND2X1 U1031 ( .A(n760), .B(cy), .Y(n756) );
  NOR2X1 U1032 ( .A(n761), .B(n762), .Y(n755) );
  OAI21X1 U1033 ( .A0(n771), .A1(n845), .B0(n864), .Y(n853) );
  OAI2BB1X1 U1034 ( .A0N(n845), .A1N(n844), .B0(n735), .Y(n839) );
  NAND2X1 U1035 ( .A(n1184), .B(n590), .Y(n1176) );
  INVX1 U1036 ( .A(n833), .Y(n1009) );
  NOR2X1 U1037 ( .A(n689), .B(n1273), .Y(n744) );
  NAND2X1 U1038 ( .A(n663), .B(n749), .Y(n747) );
  NOR2X1 U1039 ( .A(sel_code_xdat), .B(n1270), .Y(ale) );
  NAND2X1 U1040 ( .A(n1038), .B(n844), .Y(n1022) );
  NOR2X1 U1041 ( .A(n1006), .B(n1007), .Y(n984) );
  AOI21X1 U1042 ( .A0(n1012), .A1(n1013), .B0(n1273), .Y(n1006) );
  NAND3X1 U1043 ( .A(n1008), .B(n739), .C(n866), .Y(n1007) );
  NOR3X1 U1044 ( .A(n1014), .B(n679), .C(n1015), .Y(n1012) );
  NOR4X1 U1045 ( .A(n743), .B(n744), .C(n619), .D(n670), .Y(n742) );
  NOR2X1 U1046 ( .A(n746), .B(n747), .Y(n740) );
  NAND2X1 U1047 ( .A(n760), .B(n61), .Y(n971) );
  CLKINVX1 U1048 ( .A(cy), .Y(n61) );
  NOR2X1 U1049 ( .A(sel_code_xdat), .B(n1273), .Y(sel_xad) );
  OAI21X1 U1050 ( .A0(n1273), .A1(n1163), .B0(n1201), .Y(n778) );
  NAND2X1 U1051 ( .A(n758), .B(n590), .Y(n1201) );
  NAND2BX1 U1052 ( .AN(n782), .B(n781), .Y(sel_pc[0]) );
  NAND3X1 U1053 ( .A(n1062), .B(n1132), .C(n1177), .Y(n1237) );
  AOI21X1 U1054 ( .A0(n775), .A1(n776), .B0(n726), .Y(n769) );
  NAND3X1 U1055 ( .A(n592), .B(n833), .C(n663), .Y(n1054) );
  NAND2X1 U1056 ( .A(n775), .B(n931), .Y(n1115) );
  NAND2X1 U1057 ( .A(n1135), .B(n846), .Y(ld_acc) );
  NOR3X1 U1058 ( .A(n1137), .B(n1138), .C(n1139), .Y(n1135) );
  NOR2X1 U1059 ( .A(n1273), .B(n845), .Y(n1139) );
  NOR2X1 U1060 ( .A(n688), .B(n726), .Y(n1138) );
  NAND2X1 U1061 ( .A(n618), .B(n774), .Y(n772) );
  CLKINVX1 U1062 ( .A(n1177), .Y(inc_dptr) );
  NAND2X1 U1063 ( .A(n689), .B(n1199), .Y(n1160) );
  NAND2X1 U1064 ( .A(n774), .B(n618), .Y(n1199) );
  NAND2X1 U1065 ( .A(n1151), .B(n1152), .Y(n1060) );
  NAND2X1 U1066 ( .A(n649), .B(n1153), .Y(n1152) );
  NOR2X1 U1067 ( .A(ld_dph), .B(n1164), .Y(n1151) );
  NAND3X1 U1068 ( .A(n1154), .B(n1155), .C(n1156), .Y(n1153) );
  NAND3X1 U1069 ( .A(n1182), .B(n1183), .C(n837), .Y(n1181) );
  NOR3X1 U1070 ( .A(n778), .B(n1196), .C(cpl_c), .Y(n1182) );
  NOR2X1 U1071 ( .A(n1198), .B(n1273), .Y(n1196) );
  NAND2X1 U1072 ( .A(n649), .B(n1173), .Y(n1148) );
  NAND2X1 U1073 ( .A(n1174), .B(n663), .Y(n1173) );
  NOR2BX1 U1074 ( .AN(n1115), .B(n1270), .Y(ld_operand2) );
  NAND2X1 U1075 ( .A(n1021), .B(n1022), .Y(n52) );
  NAND2X1 U1076 ( .A(n735), .B(n568), .Y(n762) );
  CLKINVX1 U1077 ( .A(n1021), .Y(n399) );
  NAND2X1 U1078 ( .A(n569), .B(n662), .Y(n1255) );
  NOR2X1 U1079 ( .A(n955), .B(n956), .Y(n997) );
  INVX1 U1080 ( .A(n996), .Y(n1004) );
  NAND2X1 U1081 ( .A(n657), .B(n610), .Y(n1011) );
  NAND2X2 U1082 ( .A(n870), .B(n611), .Y(n796) );
  NOR2BX1 U1083 ( .AN(n594), .B(n604), .Y(n790) );
  NOR2X1 U1084 ( .A(n993), .B(n994), .Y(n991) );
  NAND2X1 U1085 ( .A(n569), .B(n1065), .Y(n797) );
  NAND2X1 U1086 ( .A(n1065), .B(n979), .Y(n921) );
  INVX1 U1087 ( .A(combus[7]), .Y(n332) );
  INVX1 U1088 ( .A(combus[6]), .Y(n331) );
  NAND2X1 U1089 ( .A(n890), .B(n939), .Y(n982) );
  CLKBUFX2 U1090 ( .A(n745), .Y(n1273) );
  NAND2X1 U1091 ( .A(n575), .B(n1107), .Y(n1044) );
  NAND3X1 U1092 ( .A(n323), .B(n322), .C(n321), .Y(n1107) );
  CLKINVX1 U1093 ( .A(n1110), .Y(n323) );
  CLKINVX1 U1094 ( .A(n1109), .Y(n322) );
  INVX2 U1095 ( .A(n918), .Y(n799) );
  NAND2BX1 U1096 ( .AN(n749), .B(n293), .Y(n1101) );
  NAND2BX1 U1097 ( .AN(n913), .B(n636), .Y(n879) );
  NOR2X1 U1098 ( .A(sel_in_cy_bit[1]), .B(n917), .Y(n910) );
  NAND3X1 U1099 ( .A(n733), .B(n920), .C(n921), .Y(n882) );
  NAND2X1 U1100 ( .A(n890), .B(n922), .Y(n920) );
  INVX1 U1101 ( .A(combus[4]), .Y(n326) );
  INVX1 U1102 ( .A(combus[5]), .Y(n330) );
  OAI21X1 U1103 ( .A0(n899), .A1(n1221), .B0(n869), .Y(n902) );
  NAND2X1 U1104 ( .A(n914), .B(n915), .Y(n911) );
  NAND2X1 U1105 ( .A(n916), .B(n870), .Y(n914) );
  NAND2X1 U1106 ( .A(n890), .B(n891), .Y(n887) );
  OAI21X1 U1107 ( .A0(n889), .A1(n861), .B0(n870), .Y(n888) );
  OR3X6 U1108 ( .A(n680), .B(n681), .C(n882), .Y(n904) );
  NAND2X1 U1109 ( .A(n333), .B(n1104), .Y(n1043) );
  INVX1 U1110 ( .A(combus[2]), .Y(n333) );
  INVX1 U1111 ( .A(combus[3]), .Y(n1104) );
  AND2X1 U1112 ( .A(n779), .B(n749), .Y(n682) );
  NAND2X1 U1113 ( .A(n939), .B(n870), .Y(n977) );
  NOR3X1 U1114 ( .A(ld_acc_chd), .B(n619), .C(n813), .Y(n812) );
  NOR2X1 U1115 ( .A(n1273), .B(n814), .Y(n813) );
  NAND3X1 U1116 ( .A(n870), .B(n602), .C(n1272), .Y(n1133) );
  NAND3X1 U1117 ( .A(n1185), .B(n870), .C(n1272), .Y(n1134) );
  OAI21X1 U1118 ( .A0(n831), .A1(n832), .B0(n710), .Y(n830) );
  AOI21X1 U1119 ( .A0(n735), .A1(n805), .B0(n806), .Y(n800) );
  NOR2X1 U1120 ( .A(n1214), .B(n977), .Y(n1213) );
  NAND2X1 U1121 ( .A(n1009), .B(n1272), .Y(n1204) );
  AOI21X1 U1122 ( .A0(n922), .A1(n980), .B0(n704), .Y(n1205) );
  NAND2X1 U1123 ( .A(n890), .B(n759), .Y(n925) );
  OR2X4 U1124 ( .A(n1212), .B(n1213), .Y(n684) );
  OR2X1 U1125 ( .A(sel_op2[0]), .B(n1207), .Y(n685) );
  NAND2X1 U1126 ( .A(n925), .B(n978), .Y(n893) );
  NAND2X1 U1127 ( .A(n890), .B(n569), .Y(n978) );
  AND2X1 U1128 ( .A(n870), .B(n759), .Y(n686) );
  NAND2X1 U1129 ( .A(n890), .B(n602), .Y(n907) );
  NAND2X1 U1130 ( .A(n861), .B(n870), .Y(n906) );
  NOR2X1 U1131 ( .A(n823), .B(n716), .Y(n822) );
  NOR2X1 U1132 ( .A(n857), .B(n858), .Y(n855) );
  NAND3X1 U1133 ( .A(n862), .B(n863), .C(n748), .Y(n857) );
  NAND3X1 U1134 ( .A(n859), .B(n592), .C(n1017), .Y(n858) );
  NAND2X1 U1135 ( .A(n922), .B(n1260), .Y(n844) );
  NAND2X1 U1136 ( .A(n922), .B(n575), .Y(n833) );
  NAND2X1 U1137 ( .A(n687), .B(n973), .Y(n972) );
  AND2X1 U1138 ( .A(n735), .B(n568), .Y(n687) );
  NAND2X1 U1139 ( .A(n942), .B(n1141), .Y(n835) );
  NAND2X1 U1140 ( .A(n1272), .B(n1142), .Y(n1141) );
  NAND2X1 U1141 ( .A(n1016), .B(n1129), .Y(n1128) );
  AND2X1 U1142 ( .A(n844), .B(n996), .Y(n688) );
  INVX1 U1143 ( .A(n763), .Y(n761) );
  NAND3X1 U1144 ( .A(n970), .B(n971), .C(n972), .Y(rst_c) );
  NAND2X1 U1145 ( .A(n758), .B(n979), .Y(n970) );
  NAND4X1 U1146 ( .A(n807), .B(n808), .C(n677), .D(n809), .Y(n805) );
  NAND2X1 U1147 ( .A(n810), .B(n594), .Y(n807) );
  INVX1 U1148 ( .A(n785), .Y(n809) );
  NAND4X1 U1149 ( .A(n833), .B(n1011), .C(n663), .D(n814), .Y(n1010) );
  NAND2X1 U1150 ( .A(n1186), .B(n589), .Y(n751) );
  NOR2X1 U1151 ( .A(n1191), .B(n1192), .Y(n1186) );
  NOR2X1 U1152 ( .A(n1194), .B(n726), .Y(n1191) );
  NOR2X1 U1153 ( .A(n1193), .B(n603), .Y(n1192) );
  NOR2BX1 U1154 ( .AN(n965), .B(n1270), .Y(n987) );
  NAND2X1 U1155 ( .A(n891), .B(n1260), .Y(n1038) );
  NAND3X1 U1156 ( .A(n1055), .B(n1056), .C(n850), .Y(n746) );
  NOR2X1 U1157 ( .A(n1058), .B(n1059), .Y(n1055) );
  AOI21X1 U1158 ( .A0(n575), .A1(n594), .B0(n785), .Y(n1056) );
  NAND2X1 U1159 ( .A(n796), .B(n1016), .Y(n1015) );
  NAND2X1 U1160 ( .A(n568), .B(n575), .Y(n1017) );
  INVX1 U1161 ( .A(n1016), .Y(n1058) );
  NOR2BX1 U1162 ( .AN(n814), .B(n690), .Y(n689) );
  AND2X1 U1163 ( .A(n891), .B(n575), .Y(n690) );
  OAI21X1 U1164 ( .A0(n984), .A1(n710), .B0(n985), .Y(rd_idat) );
  NOR2X1 U1165 ( .A(n986), .B(n987), .Y(n985) );
  NAND2X1 U1166 ( .A(n866), .B(n1246), .Y(dec_sp) );
  OAI21X1 U1167 ( .A0(n648), .A1(n977), .B0(n1064), .Y(n782) );
  NAND2X1 U1168 ( .A(n974), .B(n764), .Y(n760) );
  NOR2X1 U1169 ( .A(n976), .B(n977), .Y(n975) );
  NOR2X1 U1170 ( .A(n1266), .B(n861), .Y(n976) );
  CLKINVX1 U1171 ( .A(n1132), .Y(ld_dpl) );
  AND2X1 U1172 ( .A(n801), .B(n764), .Y(n691) );
  NOR2X1 U1173 ( .A(n769), .B(n770), .Y(n768) );
  NOR2X1 U1174 ( .A(n777), .B(n778), .Y(n767) );
  OAI21X1 U1175 ( .A0(n771), .A1(n772), .B0(n773), .Y(n770) );
  NOR2X1 U1176 ( .A(n799), .B(n568), .Y(n798) );
  NOR3X1 U1177 ( .A(n1117), .B(n1118), .C(n1119), .Y(n1116) );
  NOR2X1 U1178 ( .A(n1120), .B(n1270), .Y(n1118) );
  NOR2X1 U1179 ( .A(n607), .B(n977), .Y(cpl_c) );
  NOR2X1 U1180 ( .A(n1273), .B(n779), .Y(n777) );
  NOR2X1 U1181 ( .A(n1165), .B(n1273), .Y(n1164) );
  NOR2X1 U1182 ( .A(n1115), .B(n1166), .Y(n1165) );
  NOR2BX1 U1183 ( .AN(n980), .B(n607), .Y(n1117) );
  NAND3X1 U1184 ( .A(n1234), .B(n776), .C(n818), .Y(n1158) );
  NAND2X1 U1185 ( .A(n889), .B(n657), .Y(n1234) );
  NOR3X1 U1186 ( .A(n1158), .B(n1159), .C(n1160), .Y(n1155) );
  NOR2X1 U1187 ( .A(n823), .B(n648), .Y(n1159) );
  NOR2X1 U1188 ( .A(n1224), .B(rmw), .Y(n1174) );
  NAND3X1 U1189 ( .A(n1226), .B(n931), .C(n1016), .Y(n1224) );
  NAND2X1 U1190 ( .A(n1167), .B(n568), .Y(n1226) );
  NOR3X1 U1191 ( .A(n679), .B(n1161), .C(n1162), .Y(n1154) );
  NAND2X1 U1192 ( .A(n836), .B(n779), .Y(n1161) );
  CLKINVX1 U1193 ( .A(n1163), .Y(n1162) );
  NAND3X1 U1194 ( .A(n781), .B(n773), .C(n780), .Y(sel_pc[1]) );
  NOR2BX1 U1195 ( .AN(n863), .B(n1142), .Y(n1145) );
  NAND2X1 U1196 ( .A(n1140), .B(n865), .Y(inc_sp) );
  NOR2X1 U1197 ( .A(n1143), .B(n1144), .Y(n1140) );
  NOR2X1 U1198 ( .A(n633), .B(n1075), .Y(n1144) );
  NOR2X1 U1199 ( .A(n1145), .B(n1270), .Y(n1143) );
  CLKINVX1 U1200 ( .A(n1122), .Y(n1061) );
  NOR2X1 U1201 ( .A(n816), .B(n1125), .Y(n1123) );
  NAND3X1 U1202 ( .A(n733), .B(n827), .C(n797), .Y(n1125) );
  NAND2X1 U1203 ( .A(n758), .B(n569), .Y(n1177) );
  NAND4X1 U1204 ( .A(n1178), .B(n1179), .C(n1180), .D(n55), .Y(end_instr) );
  NOR3X1 U1205 ( .A(ld_c), .B(n1237), .C(n1238), .Y(n1178) );
  NAND2X1 U1206 ( .A(n735), .B(n1222), .Y(n1179) );
  NOR2X1 U1207 ( .A(n1136), .B(n1181), .Y(n1180) );
  NOR2X1 U1208 ( .A(n1150), .B(n1060), .Y(n1149) );
  OAI22X1 U1209 ( .A0(n1169), .A1(n1273), .B0(n1170), .B1(n726), .Y(n1150) );
  NOR2X1 U1210 ( .A(n1171), .B(n1172), .Y(n1169) );
  NAND2X1 U1211 ( .A(n1223), .B(n1174), .Y(n1222) );
  NOR2X1 U1212 ( .A(n1158), .B(n1232), .Y(n1223) );
  NAND3X1 U1213 ( .A(n1233), .B(n663), .C(n996), .Y(n1232) );
  NOR2X1 U1214 ( .A(n572), .B(n963), .Y(n1233) );
  CLKINVX1 U1215 ( .A(n54), .Y(n53) );
  NAND2BX1 U1216 ( .AN(n52), .B(n55), .Y(n54) );
  NAND2X1 U1217 ( .A(n1039), .B(n1040), .Y(n1021) );
  NOR2X1 U1218 ( .A(n1029), .B(n1280), .Y(n1039) );
  NOR2X1 U1219 ( .A(n1190), .B(n794), .Y(n1187) );
  NAND2X1 U1220 ( .A(n728), .B(n569), .Y(n862) );
  NAND2X1 U1221 ( .A(n1219), .B(n698), .Y(n1190) );
  XNOR2X1 U1222 ( .A(n309), .B(combus[5]), .Y(n1112) );
  XNOR2X1 U1223 ( .A(n310), .B(combus[6]), .Y(n1109) );
  NAND2BX1 U1224 ( .AN(n872), .B(n1081), .Y(n1080) );
  NAND4BX1 U1225 ( .AN(n1082), .B(n1083), .C(n1084), .D(n1085), .Y(n1081) );
  OAI21X1 U1226 ( .A0(n1042), .A1(n1041), .B0(n843), .Y(n1047) );
  NAND2X1 U1227 ( .A(n1098), .B(n1099), .Y(n1045) );
  CLKINVX1 U1228 ( .A(n319), .Y(n1099) );
  NAND2X1 U1229 ( .A(n568), .B(n1105), .Y(n1098) );
  XNOR2X1 U1230 ( .A(n311), .B(combus[7]), .Y(n1108) );
  NAND2X1 U1231 ( .A(n699), .B(n700), .Y(n918) );
  NAND4X1 U1232 ( .A(n1113), .B(n335), .C(n337), .D(n336), .Y(n318) );
  INVX1 U1233 ( .A(n334), .Y(n1113) );
  NAND4X2 U1234 ( .A(n326), .B(n330), .C(n331), .D(n332), .Y(n1103) );
  INVX1 U1235 ( .A(n325), .Y(n1111) );
  INVX1 U1236 ( .A(n1112), .Y(n324) );
  XNOR2X1 U1237 ( .A(n308), .B(combus[4]), .Y(n325) );
  NAND2X2 U1238 ( .A(n1077), .B(n1078), .Y(n1076) );
  XNOR2X1 U1239 ( .A(out_acc_r[3]), .B(combus[3]), .Y(n336) );
  NAND3X1 U1240 ( .A(n872), .B(n613), .C(n823), .Y(n919) );
  NAND2X1 U1241 ( .A(n899), .B(n894), .Y(n913) );
  NOR2BX1 U1242 ( .AN(n773), .B(sel_page_addr), .Y(n1066) );
  NAND3X1 U1243 ( .A(n1272), .B(n1069), .C(n293), .Y(n1068) );
  INVX1 U1244 ( .A(n843), .Y(n823) );
  NAND4X1 U1245 ( .A(n693), .B(n868), .C(n808), .D(n869), .Y(sel_alu[4]) );
  OR2X1 U1246 ( .A(n824), .B(n872), .Y(n693) );
  XNOR2X1 U1247 ( .A(out_acc_r[1]), .B(combus[1]), .Y(n335) );
  NAND2X1 U1248 ( .A(n604), .B(n1206), .Y(n980) );
  NAND2X1 U1249 ( .A(n939), .B(n728), .Y(n1206) );
  NAND3X1 U1250 ( .A(n735), .B(n849), .C(n710), .Y(n848) );
  NOR2X1 U1251 ( .A(n1130), .B(n1131), .Y(n1126) );
  XNOR2X1 U1252 ( .A(n312), .B(combus[2]), .Y(n1114) );
  INVX1 U1253 ( .A(n571), .Y(n889) );
  NOR3X1 U1254 ( .A(n694), .B(n1273), .C(n612), .Y(n831) );
  AND2X1 U1255 ( .A(n833), .B(n609), .Y(n694) );
  XNOR2X1 U1256 ( .A(n305), .B(combus[0]), .Y(n334) );
  NOR2X1 U1257 ( .A(n612), .B(n1052), .Y(n1051) );
  NAND2X1 U1258 ( .A(n724), .B(n609), .Y(n1228) );
  OAI21X1 U1259 ( .A0(n823), .A1(n1049), .B0(n1050), .Y(n973) );
  CLKINVX1 U1260 ( .A(N289), .Y(n1049) );
  AOI21X1 U1261 ( .A0(N288), .A1(n890), .B0(n1051), .Y(n1050) );
  NAND2X1 U1262 ( .A(N283), .B(n890), .Y(n1018) );
  NAND2X1 U1263 ( .A(N284), .B(n843), .Y(n1019) );
  NAND2X1 U1264 ( .A(N282), .B(n575), .Y(n1020) );
  NOR2X1 U1265 ( .A(n1216), .B(n1270), .Y(n1212) );
  NOR2X1 U1266 ( .A(n1218), .B(n872), .Y(n1217) );
  NOR2X1 U1267 ( .A(ac), .B(n764), .Y(rst_ac) );
  NOR2X1 U1268 ( .A(ov), .B(n691), .Y(rst_v) );
  NAND3X1 U1269 ( .A(n864), .B(n1000), .C(n1001), .Y(n986) );
  AOI21X1 U1270 ( .A0(n1003), .A1(n735), .B0(n964), .Y(n1000) );
  NAND2X1 U1271 ( .A(n736), .B(n737), .Y(wr_idat) );
  NOR2X1 U1272 ( .A(n750), .B(n751), .Y(n736) );
  NAND2X1 U1273 ( .A(n738), .B(n711), .Y(n737) );
  OR2X1 U1274 ( .A(n721), .B(n766), .Y(n695) );
  NOR2BX1 U1275 ( .AN(n312), .B(out_acc_r[3]), .Y(n306) );
  AND4X1 U1276 ( .A(n308), .B(n309), .C(n310), .D(n311), .Y(n307) );
  NAND2X1 U1277 ( .A(n1071), .B(n1072), .Y(n1070) );
  OAI21X1 U1278 ( .A0(n1239), .A1(n977), .B0(n1240), .Y(n1238) );
  NOR2X1 U1279 ( .A(n759), .B(n979), .Y(n1239) );
  NAND3X1 U1280 ( .A(n872), .B(n613), .C(n823), .Y(n1167) );
  NAND3X1 U1281 ( .A(n1147), .B(n1148), .C(n1149), .Y(inc_pc) );
  NOR3X1 U1282 ( .A(n1175), .B(sel_page_addr), .C(sel_op2[0]), .Y(n1147) );
  NAND2BX1 U1283 ( .AN(end_instr), .B(n582), .Y(n50) );
  NOR2X1 U1284 ( .A(n696), .B(n50), .Y(n563) );
  XOR2X1 U1285 ( .A(n1280), .B(n631), .Y(n696) );
  NOR2BX1 U1286 ( .AN(N495), .B(n50), .Y(n564) );
  NOR2BX1 U1287 ( .AN(N496), .B(n50), .Y(n565) );
  XNOR2X1 U1288 ( .A(n1283), .B(n654), .Y(N496) );
  NOR2X1 U1289 ( .A(n1282), .B(n1281), .Y(n1283) );
  NOR3X1 U1290 ( .A(n1121), .B(n969), .C(n1004), .Y(n1120) );
  NOR2X1 U1291 ( .A(sel_code_xdat), .B(n1036), .Y(n1033) );
  NAND2X1 U1292 ( .A(n1176), .B(n398), .Y(n1175) );
  CLKINVX1 U1293 ( .A(n420), .Y(n55) );
  CLKINVX1 U1294 ( .A(n426), .Y(n425) );
  NAND3BX1 U1295 ( .AN(sel_code_xdat), .B(n423), .C(n55), .Y(n426) );
  NAND2X1 U1296 ( .A(n1029), .B(n1280), .Y(n1282) );
  DFFRX1 t_2_reg_0_ ( .D(n558), .CK(clk), .RN(n551), .Q(t_2[0]), .QN(n581) );
  DFFRX1 t_2_reg_1_ ( .D(n559), .CK(clk), .RN(n551), .Q(t_2[1]), .QN(n580) );
  NAND2X1 U1297 ( .A(t_2[1]), .B(t_2[0]), .Y(n1278) );
  CLKINVX1 U1298 ( .A(n398), .Y(ld_instr) );
  NOR2X1 U1299 ( .A(n697), .B(n582), .Y(n553) );
  XOR2X1 U1300 ( .A(n632), .B(n623), .Y(n697) );
  NOR2BX1 U1301 ( .AN(N482), .B(n582), .Y(n554) );
  NOR2X1 U1302 ( .A(n633), .B(n623), .Y(n1275) );
  NOR2BX1 U1303 ( .AN(n633), .B(n582), .Y(n552) );
  NOR2X1 U1304 ( .A(n1262), .B(n1121), .Y(addr_bank_a[1]) );
  NOR2X1 U1305 ( .A(n1261), .B(n1121), .Y(addr_bank_a[2]) );
  NAND2BX1 U1306 ( .AN(n702), .B(n968), .Y(n1263) );
  OR2X1 U1307 ( .A(n766), .B(n722), .Y(n702) );
  XNOR2X1 U1308 ( .A(in_xrom1_r[7]), .B(combus[7]), .Y(n347) );
  NAND4X2 U1309 ( .A(n349), .B(n350), .C(n348), .D(n347), .Y(n1042) );
  XNOR2X1 U1310 ( .A(in_xrom1_r[4]), .B(combus[4]), .Y(n350) );
  XNOR2X1 U1311 ( .A(in_xrom1_r[5]), .B(combus[5]), .Y(n349) );
  XNOR2X1 U1312 ( .A(in_xrom1_r[6]), .B(combus[6]), .Y(n348) );
  NAND2X1 U1313 ( .A(n1245), .B(n1230), .Y(n872) );
  MXI2X1 U1314 ( .S0(bit_dat_in_r), .B(n1097), .A(n1096), .Y(n1095) );
  NAND2X1 U1315 ( .A(n916), .B(n618), .Y(n1097) );
  NAND2X1 U1316 ( .A(n861), .B(n618), .Y(n1096) );
  XNOR2X1 U1317 ( .A(in_xrom1_r[3]), .B(combus[3]), .Y(n343) );
  NAND4X2 U1318 ( .A(n345), .B(n346), .C(n344), .D(n343), .Y(n1041) );
  XNOR2X1 U1319 ( .A(in_xrom1_r[0]), .B(combus[0]), .Y(n346) );
  XNOR2X1 U1320 ( .A(in_xrom1_r[1]), .B(combus[1]), .Y(n345) );
  XNOR2X1 U1321 ( .A(in_xrom1_r[2]), .B(combus[2]), .Y(n344) );
  NOR2X1 U1322 ( .A(n66), .B(n764), .Y(set_ac) );
  NAND2X1 U1323 ( .A(n735), .B(msb_r), .Y(n856) );
  NAND2X1 U1324 ( .A(n735), .B(n754), .Y(n752) );
  INVX1 U1325 ( .A(msb_r), .Y(n754) );
  NOR2BX1 U1326 ( .AN(extend_wr), .B(n1038), .Y(wr_xdat) );
  NAND2X1 U1327 ( .A(msb_r), .B(n804), .Y(n734) );
  XNOR2X1 U1328 ( .A(n311), .B(in_xrom1_r[7]), .Y(n1082) );
  INVX1 U1329 ( .A(out_acc_r[6]), .Y(n310) );
  NOR3X1 U1330 ( .A(n1090), .B(n1091), .C(n1092), .Y(n1083) );
  XNOR2X1 U1331 ( .A(out_acc_r[3]), .B(n1093), .Y(n1092) );
  XNOR2X1 U1332 ( .A(out_acc_r[1]), .B(n1094), .Y(n1091) );
  XNOR2X1 U1333 ( .A(n305), .B(in_xrom1_r[0]), .Y(n1090) );
  INVX1 U1334 ( .A(out_acc_r[7]), .Y(n311) );
  INVX1 U1335 ( .A(out_acc_r[4]), .Y(n308) );
  INVX1 U1336 ( .A(out_acc_r[5]), .Y(n309) );
  NOR2X1 U1337 ( .A(n1086), .B(n1087), .Y(n1085) );
  XNOR2X1 U1338 ( .A(n309), .B(in_xrom1_r[5]), .Y(n1087) );
  XNOR2X1 U1339 ( .A(n310), .B(in_xrom1_r[6]), .Y(n1086) );
  NOR2X1 U1340 ( .A(n1088), .B(n1089), .Y(n1084) );
  XNOR2X1 U1341 ( .A(n312), .B(in_xrom1_r[2]), .Y(n1089) );
  XNOR2X1 U1342 ( .A(n308), .B(in_xrom1_r[4]), .Y(n1088) );
  CLKINVX1 U1343 ( .A(in_xrom1_r[1]), .Y(n1094) );
  CLKINVX1 U1344 ( .A(in_xrom1_r[3]), .Y(n1093) );
  NOR2X1 U1345 ( .A(n844), .B(n729), .Y(rd_xdat) );
  CLKINVX1 U1346 ( .A(bit_dat_in_r), .Y(n1100) );
  NOR2X1 U1347 ( .A(n1031), .B(n1032), .Y(n1023) );
  NAND2X1 U1348 ( .A(out_dimod_r[2]), .B(n1025), .Y(n1032) );
  MXI2X1 U1349 ( .S0(out_dimod_r[0]), .B(n1273), .A(n1035), .Y(n1034) );
  NOR2BX1 U1350 ( .AN(n1030), .B(n735), .Y(n1035) );
  NAND2BX1 U1351 ( .AN(en_itcnt), .B(n399), .Y(n398) );
  NAND2BX1 U1352 ( .AN(n652), .B(n653), .Y(n485) );
  MXI2X1 U1353 ( .S0(N493), .B(n1024), .A(n1023), .Y(n4840) );
  NAND2X1 U1354 ( .A(n1033), .B(n1034), .Y(n4830) );
  NOR2BX1 U1355 ( .AN(extend_mux), .B(sel_code_xdat), .Y(sel_xaddr_high) );
  NOR2X1 U1356 ( .A(n1025), .B(n1026), .Y(n1024) );
  MXI2X1 U1357 ( .S0(out_dimod_r[2]), .B(n1028), .A(n1027), .Y(n1026) );
  NOR2X1 U1358 ( .A(n1029), .B(n1030), .Y(n1027) );
  NOR2X1 U1359 ( .A(out_dimod_r[1]), .B(n631), .Y(n1028) );
  CLKINVX1 U1360 ( .A(out_dimod_r[0]), .Y(n1025) );
  CLKINVX1 U1361 ( .A(out_dimod_r[1]), .Y(n1030) );
  AO22X1 U1362 ( .A0(t_2[0]), .A1(n52), .B0(n581), .B1(n53), .Y(n558) );
  AO22X1 U1363 ( .A0(t_2[1]), .A1(n52), .B0(N490), .B1(n53), .Y(n559) );
  XNOR2X1 U1364 ( .A(t_2[0]), .B(n580), .Y(N490) );
  AO22X1 U1365 ( .A0(t_2[2]), .A1(n52), .B0(N491), .B1(n53), .Y(n560) );
  XNOR2X1 U1366 ( .A(n1277), .B(n577), .Y(N491) );
  CLKINVX1 U1367 ( .A(n1278), .Y(n1277) );
  AO22X1 U1368 ( .A0(t_2[3]), .A1(n52), .B0(N492), .B1(n53), .Y(n561) );
  XNOR2X1 U1369 ( .A(n1279), .B(n578), .Y(N492) );
  NOR2X1 U1370 ( .A(n1278), .B(n577), .Y(n1279) );
  OAI32X1 U1371 ( .A0(n420), .A1(n1038), .A2(n421), .B0(n579), .B1(n420), .Y(
        n556) );
  CLKINVX1 U1372 ( .A(n423), .Y(n421) );
  AO21X1 U1373 ( .A0(extend_rd), .A1(n55), .B0(n425), .Y(n555) );
  AO21X1 U1374 ( .A0(extend_mux), .A1(n55), .B0(n425), .Y(n557) );
  OR4X1 U1375 ( .A(t_2[3]), .B(t_2[2]), .C(t_2[0]), .D(t_2[1]), .Y(n423) );
  CLKINVX1 U1376 ( .A(rst_p), .Y(n551) );
  NOR2BX1 U1377 ( .AN(en_int1), .B(rst_p), .Y(N483) );
  NAND3BX1 U1378 ( .AN(N211), .B(n550), .C(n551), .Y(N484) );
  CLKINVX1 U1379 ( .A(en_int1), .Y(n550) );
  NOR2X1 U1380 ( .A(n1276), .B(n620), .Y(N211) );
  NOR2X1 U1381 ( .A(n632), .B(n622), .Y(n1276) );
  DFFRX1 extend_wr_reg ( .D(n556), .CK(clk), .RN(n551), .Q(extend_wr), .QN(
        n579) );
  DFFRX1 extend_rd_reg ( .D(n555), .CK(clk), .RN(n551), .Q(extend_rd), .QN(
        n729) );
  DFFRX1 t_2_reg_2_ ( .D(n560), .CK(clk), .RN(n551), .Q(t_2[2]), .QN(n577) );
  DFFRX1 t_2_reg_3_ ( .D(n561), .CK(clk), .RN(n551), .Q(t_2[3]), .QN(n578) );
  DFFRX1 extend_mux_reg ( .D(n557), .CK(clk), .RN(n551), .Q(extend_mux) );
  TLATX1 en_itcnt_reg ( .D(N483), .G(N484), .Q(en_itcnt), .QN(n582) );
  NOR2X1 U1382 ( .A(n1270), .B(n1146), .Y(inc_pc2) );
  NAND2X1 U1383 ( .A(n1146), .B(n944), .Y(n1142) );
  CLKINVX1 U1384 ( .A(n781), .Y(ld_pch) );
  NAND2X1 U1385 ( .A(n1065), .B(n842), .Y(n1256) );
  NAND3X1 U1386 ( .A(n590), .B(n843), .C(n1272), .Y(n840) );
  NOR2X1 U1387 ( .A(n891), .B(n590), .Y(n1193) );
  MXI2X1 U1388 ( .S0(n576), .B(n903), .A(n590), .Y(n1072) );
  NAND2X1 U1389 ( .A(n1230), .B(code[1]), .Y(n707) );
  NAND2X1 U1390 ( .A(n635), .B(code[1]), .Y(n708) );
  NAND2X1 U1391 ( .A(n1230), .B(code[1]), .Y(n709) );
  NAND2X1 U1392 ( .A(addr_bank_a[0]), .B(n606), .Y(n1243) );
  NAND2X1 U1393 ( .A(n626), .B(n968), .Y(n894) );
  NOR2X4 U1394 ( .A(n991), .B(n992), .Y(n990) );
  CLKBUFX2 U1395 ( .A(n786), .Y(n1271) );
  CLKBUFX2 U1396 ( .A(n786), .Y(n1272) );
  INVX1 U1397 ( .A(n603), .Y(n1002) );
  INVX1 U1398 ( .A(out_acc_r[2]), .Y(n312) );
  NOR2X1 U1399 ( .A(n899), .B(n598), .Y(n896) );
  NAND2X1 U1400 ( .A(n826), .B(n862), .Y(n1059) );
  NAND2X1 U1401 ( .A(n748), .B(n826), .Y(n820) );
  NOR2X1 U1402 ( .A(n898), .B(n872), .Y(n897) );
  NAND2X1 U1403 ( .A(n996), .B(n826), .Y(n995) );
  NOR2X2 U1404 ( .A(n612), .B(n716), .Y(n929) );
  NOR2X1 U1405 ( .A(n765), .B(n591), .Y(n1241) );
  NAND3X1 U1406 ( .A(n618), .B(n1070), .C(n1272), .Y(n1067) );
  NOR2X1 U1407 ( .A(n798), .B(n765), .Y(sel_in_cy_bit[0]) );
  OAI21X1 U1408 ( .A0(n1202), .A1(n1203), .B0(n618), .Y(n1163) );
  NOR3X1 U1409 ( .A(n1273), .B(n765), .C(n695), .Y(sel_xaddr_low) );
  AOI21X1 U1410 ( .A0(n1080), .A1(n1047), .B0(n716), .Y(n1079) );
  NAND2X1 U1411 ( .A(n699), .B(n1268), .Y(n952) );
  NAND3X1 U1412 ( .A(n657), .B(n594), .C(n1272), .Y(n1064) );
  NAND3X2 U1413 ( .A(n1272), .B(n789), .C(n710), .Y(n795) );
  NOR2X6 U1414 ( .A(n786), .B(n939), .Y(n946) );
  NOR2X1 U1415 ( .A(n658), .B(n594), .Y(n1214) );
  NAND2X1 U1416 ( .A(n662), .B(n658), .Y(n776) );
  CLKBUFX2 U1417 ( .A(n932), .Y(n715) );
  NAND2X4 U1418 ( .A(n1200), .B(n1268), .Y(n957) );
  INVX1 U1419 ( .A(n878), .Y(n774) );
  NOR2X1 U1420 ( .A(n994), .B(n1005), .Y(n1003) );
  NOR2X1 U1421 ( .A(code[1]), .B(addr_bank_a[0]), .Y(n1245) );
  AOI21X1 U1422 ( .A0(n922), .A1(n968), .B0(n969), .Y(n967) );
  NOR2X1 U1423 ( .A(n1270), .B(n615), .Y(inc_pc3) );
  AOI21X1 U1424 ( .A0(n568), .A1(n1167), .B0(n715), .Y(n775) );
  NAND2X6 U1425 ( .A(n733), .B(n749), .Y(n932) );
  OAI21X1 U1426 ( .A0(n861), .A1(n602), .B0(n575), .Y(n859) );
  NOR2X1 U1427 ( .A(n1074), .B(n602), .Y(n1071) );
  OAI2BB1X1 U1428 ( .A0N(n602), .A1N(n575), .B0(n776), .Y(n1166) );
  NAND2X6 U1429 ( .A(n932), .B(n933), .Y(n926) );
  OAI21X1 U1430 ( .A0(n746), .A1(n1054), .B0(n649), .Y(n1053) );
  AOI21X1 U1431 ( .A0(n1241), .A1(n649), .B0(sel_page_addr), .Y(n1240) );
  OAI2BB2X1 U1432 ( .A0N(n1124), .A1N(n649), .B0(n1123), .B1(n1273), .Y(n1122)
         );
  AOI21X1 U1433 ( .A0(n649), .A1(n893), .B0(n975), .Y(n974) );
  INVX1 U1434 ( .A(n723), .Y(n724) );
  NOR2X1 U1435 ( .A(n609), .B(n707), .Y(n821) );
  NAND2X2 U1436 ( .A(n1263), .B(n708), .Y(n1121) );
  CLKINVX8 U1437 ( .A(n1259), .Y(n1040) );
  INVX1 U1438 ( .A(n624), .Y(n743) );
  NAND2X1 U1439 ( .A(n624), .B(n773), .Y(n806) );
  MXI2X1 U1440 ( .S0(cy_psw), .B(n915), .A(n878), .Y(n1074) );
  NAND2X1 U1441 ( .A(n915), .B(n952), .Y(n1203) );
  NAND2X1 U1442 ( .A(n648), .B(n724), .Y(n1202) );
  NAND2X1 U1443 ( .A(n1200), .B(n645), .Y(n878) );
  NAND2X1 U1444 ( .A(n644), .B(n1272), .Y(n1062) );
  NOR2X1 U1445 ( .A(n1219), .B(n650), .Y(n1218) );
  NOR2X1 U1446 ( .A(n616), .B(n963), .Y(n1170) );
  NOR2X1 U1447 ( .A(n616), .B(n1079), .Y(n1078) );
  XNOR2X1 U1448 ( .A(out_dimod_r[1]), .B(n631), .Y(n1031) );
  AOI22X1 U1449 ( .A0(n1002), .A1(n979), .B0(n572), .B1(n1272), .Y(n1001) );
  AOI21X1 U1450 ( .A0(n1272), .A1(n617), .B0(n803), .Y(n802) );
  OAI21X1 U1451 ( .A0(n679), .A1(n785), .B0(n1272), .Y(n783) );
  NAND2X2 U1452 ( .A(n1004), .B(n1271), .Y(n753) );
  NAND2X2 U1453 ( .A(n936), .B(n786), .Y(n780) );
  NOR2BX1 U1454 ( .AN(N493), .B(n50), .Y(n562) );
  AOI21X1 U1455 ( .A0(n1037), .A1(N493), .B0(n1030), .Y(n1036) );
  NAND2BX1 U1456 ( .AN(n1270), .B(n1010), .Y(n1008) );
  OAI21X1 U1457 ( .A0(n733), .A1(n1100), .B0(n1101), .Y(n319) );
  OAI22X1 U1458 ( .A0(n667), .A1(n711), .B0(n733), .B1(n734), .Y(wr_sfr) );
  OAI21X1 U1459 ( .A0(n733), .A1(n752), .B0(n753), .Y(n750) );
  NOR2X1 U1460 ( .A(n1273), .B(n826), .Y(n1119) );
  NAND2X2 U1461 ( .A(n999), .B(n641), .Y(n956) );
  NAND2BX1 U1462 ( .AN(n612), .B(n318), .Y(n1106) );
  OAI21X1 U1463 ( .A0(n613), .A1(n1273), .B0(n982), .Y(n981) );
  OAI21X1 U1464 ( .A0(n613), .A1(n716), .B0(n860), .Y(n1131) );
  NOR2X4 U1465 ( .A(n950), .B(n951), .Y(n949) );
  NOR2X6 U1466 ( .A(n945), .B(n619), .Y(n934) );
  NOR2X1 U1467 ( .A(n636), .B(n646), .Y(reti) );
  AOI21X1 U1468 ( .A0(n869), .A1(n1221), .B0(n636), .Y(sel_bit_dat_out[0]) );
  AOI22X1 U1469 ( .A0(n568), .A1(n662), .B0(n1065), .B1(n723), .Y(n1253) );
  OAI21X1 U1470 ( .A0(n980), .A1(n981), .B0(n955), .Y(n764) );
  NAND4X1 U1471 ( .A(n826), .B(n615), .C(n833), .D(n592), .Y(n1171) );
  AOI21X1 U1472 ( .A0(n918), .A1(n609), .B0(n872), .Y(n917) );
  AOI22X4 U1473 ( .A0(n947), .A1(n791), .B0(n948), .B1(n949), .Y(sel_addr1[0])
         );
  AOI21X4 U1474 ( .A0(n958), .A1(n933), .B0(n928), .Y(n947) );
  OAI2BB1X4 U1475 ( .A0N(n810), .A1N(n759), .B0(n953), .Y(n958) );
  OAI21X4 U1476 ( .A0(n959), .A1(n1270), .B0(n960), .Y(n730) );
  NAND2X6 U1477 ( .A(n568), .B(n763), .Y(n59) );
  INVX8 U1478 ( .A(n1041), .Y(n342) );
  INVX8 U1479 ( .A(n1042), .Y(n341) );
  INVX8 U1480 ( .A(n1043), .Y(n328) );
  INVX16 U1481 ( .A(combus[0]), .Y(n327) );
  NOR2X8 U1482 ( .A(n607), .B(n1044), .Y(n320) );
  INVX8 U1483 ( .A(n1045), .Y(n317) );
  NAND2X6 U1484 ( .A(n1046), .B(n568), .Y(n315) );
  INVX8 U1485 ( .A(n1048), .Y(n2870) );
  NAND2BX4 U1486 ( .AN(n607), .B(n973), .Y(n238) );
  OAI21X4 U1487 ( .A0(n286), .A1(n726), .B0(n1063), .Y(ld_pc) );
  INVX1 U1488 ( .A(out_acc_r[0]), .Y(n305) );
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
  DFFRX4 itcnt_reg_2_ ( .D(n554), .CK(clk), .RN(n551), .QN(n620) );
endmodule


module u_con_DW01_cmp2_8_0 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51;

  INVX1 U6 ( .A(n48), .Y(n47) );
  INVX1 U7 ( .A(B[4]), .Y(n48) );
  INVX1 U8 ( .A(n51), .Y(n50) );
  INVX1 U9 ( .A(A[5]), .Y(n26) );
  INVX1 U10 ( .A(A[4]), .Y(n27) );
  INVX1 U11 ( .A(A[7]), .Y(n18) );
  INVX1 U12 ( .A(A[3]), .Y(n34) );
  INVX1 U13 ( .A(A[2]), .Y(n35) );
  NAND2X1 U14 ( .A(A[4]), .B(n48), .Y(n30) );
  NOR2X1 U15 ( .A(A[7]), .B(n51), .Y(n45) );
  NOR2X1 U16 ( .A(A[6]), .B(n22), .Y(n46) );
  NAND2X1 U17 ( .A(A[6]), .B(n22), .Y(n21) );
  AOI21X1 U18 ( .A0(n15), .A1(n16), .B0(n17), .Y(LT_LE) );
  NAND3BX1 U19 ( .AN(n19), .B(n20), .C(n21), .Y(n16) );
  NOR2X1 U20 ( .A(n50), .B(n18), .Y(n17) );
  NOR2X1 U21 ( .A(n45), .B(n46), .Y(n15) );
  NAND2X1 U22 ( .A(A[3]), .B(n44), .Y(n28) );
  CLKINVX1 U23 ( .A(n49), .Y(n44) );
  INVX1 U24 ( .A(A[1]), .Y(n41) );
  NOR2X1 U25 ( .A(B[5]), .B(n26), .Y(n19) );
  NAND3X1 U26 ( .A(n23), .B(n24), .C(n25), .Y(n20) );
  NAND2X1 U27 ( .A(n47), .B(n27), .Y(n24) );
  NAND3X1 U28 ( .A(n28), .B(n29), .C(n30), .Y(n23) );
  NAND2X1 U29 ( .A(B[5]), .B(n26), .Y(n25) );
  NOR2X1 U30 ( .A(n42), .B(n43), .Y(n36) );
  NOR2X1 U31 ( .A(B[1]), .B(n41), .Y(n43) );
  NOR2X1 U32 ( .A(B[2]), .B(n35), .Y(n42) );
  NAND2X1 U33 ( .A(n38), .B(n39), .Y(n37) );
  NAND2X1 U34 ( .A(B[0]), .B(n40), .Y(n39) );
  NAND2X1 U35 ( .A(B[1]), .B(n41), .Y(n38) );
  INVX1 U36 ( .A(A[0]), .Y(n40) );
  NAND3X1 U37 ( .A(n31), .B(n32), .C(n33), .Y(n29) );
  NAND2X1 U38 ( .A(B[2]), .B(n35), .Y(n32) );
  NAND2X1 U39 ( .A(n36), .B(n37), .Y(n31) );
  NAND2X1 U40 ( .A(n49), .B(n34), .Y(n33) );
  CLKINVX1 U41 ( .A(B[6]), .Y(n22) );
  CLKBUFX3 U42 ( .A(B[3]), .Y(n49) );
  INVX1 U43 ( .A(B[7]), .Y(n51) );
endmodule


module u_con_DW01_cmp2_8_1 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58;

  NOR2X1 U6 ( .A(n48), .B(n49), .Y(n15) );
  INVX1 U7 ( .A(B[6]), .Y(n22) );
  INVX1 U8 ( .A(B[4]), .Y(n31) );
  INVX1 U9 ( .A(B[5]), .Y(n47) );
  INVX1 U10 ( .A(B[3]), .Y(n46) );
  CLKINVX1 U11 ( .A(B[0]), .Y(n43) );
  NAND2X1 U12 ( .A(B[4]), .B(n27), .Y(n24) );
  CLKINVX1 U13 ( .A(n51), .Y(n27) );
  NAND2X1 U14 ( .A(B[5]), .B(n26), .Y(n25) );
  CLKINVX1 U15 ( .A(n57), .Y(n26) );
  NOR2X1 U16 ( .A(B[7]), .B(n18), .Y(n17) );
  CLKINVX1 U17 ( .A(n55), .Y(n18) );
  AOI21X1 U18 ( .A0(n15), .A1(n16), .B0(n17), .Y(LT_LE) );
  NAND3X1 U19 ( .A(n28), .B(n29), .C(n30), .Y(n23) );
  NAND2X1 U20 ( .A(n52), .B(n46), .Y(n28) );
  NAND3BX1 U21 ( .AN(n32), .B(n33), .C(n34), .Y(n29) );
  NAND2X1 U22 ( .A(n51), .B(n31), .Y(n30) );
  NAND3X1 U23 ( .A(n19), .B(n20), .C(n21), .Y(n16) );
  NAND2X1 U24 ( .A(n57), .B(n47), .Y(n19) );
  NAND3X1 U25 ( .A(n23), .B(n24), .C(n25), .Y(n20) );
  NAND2X1 U26 ( .A(n53), .B(n22), .Y(n21) );
  NOR2X1 U27 ( .A(n53), .B(n22), .Y(n49) );
  NOR2X1 U28 ( .A(n55), .B(n50), .Y(n48) );
  INVX1 U29 ( .A(B[7]), .Y(n50) );
  NOR2X1 U30 ( .A(B[2]), .B(n42), .Y(n39) );
  CLKINVX1 U31 ( .A(n58), .Y(n42) );
  NAND2X1 U32 ( .A(B[3]), .B(n35), .Y(n34) );
  CLKINVX1 U33 ( .A(n52), .Y(n35) );
  NOR2X1 U34 ( .A(B[1]), .B(n41), .Y(n40) );
  CLKINVX1 U35 ( .A(n56), .Y(n41) );
  INVX1 U36 ( .A(B[1]), .Y(n44) );
  NOR2X1 U37 ( .A(n58), .B(n45), .Y(n32) );
  INVX1 U38 ( .A(B[2]), .Y(n45) );
  OAI21X1 U39 ( .A0(n36), .A1(n37), .B0(n38), .Y(n33) );
  NAND2X1 U40 ( .A(A[0]), .B(n43), .Y(n37) );
  NOR2X1 U41 ( .A(n56), .B(n44), .Y(n36) );
  NOR2X1 U42 ( .A(n39), .B(n40), .Y(n38) );
  CLKBUFX3 U43 ( .A(A[1]), .Y(n56) );
  CLKBUFX3 U44 ( .A(A[2]), .Y(n58) );
  CLKBUFX3 U45 ( .A(A[3]), .Y(n52) );
  CLKBUFX2 U46 ( .A(A[7]), .Y(n55) );
  CLKBUFX3 U47 ( .A(A[5]), .Y(n57) );
  CLKBUFX3 U48 ( .A(A[4]), .Y(n51) );
  CLKINVX1 U49 ( .A(n54), .Y(n53) );
  CLKINVX1 U50 ( .A(A[6]), .Y(n54) );
endmodule


module u_con_DW01_cmp2_8_2 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52;

  NAND3X1 U6 ( .A(n23), .B(n24), .C(n25), .Y(n20) );
  NOR2X1 U7 ( .A(n52), .B(n47), .Y(n45) );
  NAND3X1 U8 ( .A(n31), .B(n32), .C(n33), .Y(n28) );
  NAND2X1 U9 ( .A(n49), .B(n30), .Y(n29) );
  INVX1 U10 ( .A(A[1]), .Y(n41) );
  NAND2X1 U11 ( .A(n38), .B(n39), .Y(n37) );
  INVX1 U12 ( .A(B[6]), .Y(n22) );
  AOI21X1 U13 ( .A0(n15), .A1(n16), .B0(n17), .Y(LT_LE) );
  NAND3BX1 U14 ( .AN(n19), .B(n20), .C(n21), .Y(n16) );
  NOR2X1 U15 ( .A(B[7]), .B(n18), .Y(n17) );
  NOR2X1 U16 ( .A(n45), .B(n46), .Y(n15) );
  NAND2X1 U17 ( .A(n48), .B(n44), .Y(n27) );
  INVX1 U18 ( .A(B[3]), .Y(n44) );
  CLKINVX1 U19 ( .A(n48), .Y(n34) );
  NOR2X1 U20 ( .A(B[5]), .B(n26), .Y(n19) );
  NOR2X1 U21 ( .A(n51), .B(n22), .Y(n46) );
  INVX1 U22 ( .A(B[7]), .Y(n47) );
  NAND2X1 U23 ( .A(B[4]), .B(n50), .Y(n24) );
  NAND3X1 U24 ( .A(n27), .B(n28), .C(n29), .Y(n23) );
  NAND2X1 U25 ( .A(B[5]), .B(n26), .Y(n25) );
  INVX1 U26 ( .A(B[4]), .Y(n30) );
  NAND2X1 U27 ( .A(n51), .B(n22), .Y(n21) );
  NOR2X1 U28 ( .A(n42), .B(n43), .Y(n36) );
  NOR2X1 U29 ( .A(B[1]), .B(n41), .Y(n43) );
  NOR2X1 U30 ( .A(B[2]), .B(n35), .Y(n42) );
  NAND2X1 U31 ( .A(B[2]), .B(n35), .Y(n32) );
  NAND2X1 U32 ( .A(n36), .B(n37), .Y(n31) );
  NAND2X1 U33 ( .A(B[3]), .B(n34), .Y(n33) );
  CLKBUFX2 U34 ( .A(A[3]), .Y(n48) );
  CLKINVX1 U35 ( .A(n52), .Y(n18) );
  NAND2X1 U36 ( .A(B[0]), .B(n40), .Y(n39) );
  NAND2X1 U37 ( .A(B[1]), .B(n41), .Y(n38) );
  INVX1 U38 ( .A(A[5]), .Y(n26) );
  CLKBUFX2 U39 ( .A(A[7]), .Y(n52) );
  CLKBUFX2 U40 ( .A(A[6]), .Y(n51) );
  CLKINVX1 U41 ( .A(n50), .Y(n49) );
  INVX1 U42 ( .A(A[4]), .Y(n50) );
  INVX1 U43 ( .A(A[2]), .Y(n35) );
  INVX1 U44 ( .A(A[0]), .Y(n40) );
endmodule


module u_con_DW01_cmp2_8_3 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55;

  INVX1 U6 ( .A(B[6]), .Y(n46) );
  CLKBUFX2 U7 ( .A(A[1]), .Y(n52) );
  CLKINVX1 U8 ( .A(n52), .Y(n39) );
  OAI21X1 U9 ( .A0(A[3]), .A1(n33), .B0(n34), .Y(n32) );
  CLKINVX1 U10 ( .A(n45), .Y(n33) );
  NAND2X1 U11 ( .A(n49), .B(n35), .Y(n34) );
  OAI21X1 U12 ( .A0(n54), .A1(n24), .B0(n25), .Y(n23) );
  CLKINVX1 U13 ( .A(n48), .Y(n24) );
  NAND2X1 U14 ( .A(n44), .B(n26), .Y(n25) );
  CLKINVX1 U15 ( .A(n53), .Y(n26) );
  NOR3X1 U16 ( .A(n36), .B(n37), .C(n38), .Y(n31) );
  NOR2X1 U17 ( .A(n51), .B(n39), .Y(n38) );
  NOR2X1 U18 ( .A(n49), .B(n35), .Y(n37) );
  NOR2X1 U19 ( .A(n40), .B(n41), .Y(n36) );
  NOR2X1 U20 ( .A(n27), .B(n28), .Y(n22) );
  OAI21X1 U21 ( .A0(n45), .A1(n50), .B0(n29), .Y(n28) );
  NOR2X1 U22 ( .A(n31), .B(n32), .Y(n27) );
  NOR2X1 U23 ( .A(n52), .B(n42), .Y(n41) );
  CLKINVX1 U24 ( .A(n51), .Y(n42) );
  NAND2X1 U25 ( .A(n53), .B(n30), .Y(n29) );
  CLKINVX1 U26 ( .A(n44), .Y(n30) );
  INVX1 U27 ( .A(A[3]), .Y(n50) );
  CLKINVX1 U28 ( .A(n47), .Y(n43) );
  CLKBUFX3 U29 ( .A(B[0]), .Y(n47) );
  NOR2X1 U30 ( .A(n19), .B(n20), .Y(n18) );
  OAI21X1 U31 ( .A0(n48), .A1(n55), .B0(n21), .Y(n20) );
  NOR2X1 U32 ( .A(n22), .B(n23), .Y(n19) );
  NAND2X1 U33 ( .A(A[6]), .B(n46), .Y(n21) );
  OAI2BB1X1 U34 ( .A0N(B[7]), .A1N(n15), .B0(n16), .Y(LT_LE) );
  OAI22X1 U35 ( .A0(n17), .A1(n18), .B0(B[7]), .B1(n15), .Y(n16) );
  INVX1 U36 ( .A(A[7]), .Y(n15) );
  NOR2X1 U37 ( .A(A[6]), .B(n46), .Y(n17) );
  CLKBUFX2 U38 ( .A(A[4]), .Y(n53) );
  CLKBUFX3 U39 ( .A(B[1]), .Y(n51) );
  CLKINVX1 U40 ( .A(n55), .Y(n54) );
  INVX1 U41 ( .A(A[5]), .Y(n55) );
  CLKBUFX3 U42 ( .A(B[4]), .Y(n44) );
  CLKBUFX3 U43 ( .A(B[3]), .Y(n45) );
  CLKBUFX3 U44 ( .A(B[5]), .Y(n48) );
  CLKBUFX3 U45 ( .A(B[2]), .Y(n49) );
  INVX1 U46 ( .A(A[2]), .Y(n35) );
  NOR2X1 U47 ( .A(A[0]), .B(n43), .Y(n40) );
endmodule


module u_con_DW01_cmp2_8_4 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56;

  NOR2X1 U6 ( .A(n47), .B(n48), .Y(n15) );
  NAND3BX1 U7 ( .AN(n32), .B(n33), .C(n34), .Y(n29) );
  CLKBUFX2 U8 ( .A(B[1]), .Y(n50) );
  INVX1 U9 ( .A(A[4]), .Y(n27) );
  INVX1 U10 ( .A(A[5]), .Y(n26) );
  NAND2X1 U11 ( .A(A[3]), .B(n45), .Y(n28) );
  CLKINVX1 U12 ( .A(n51), .Y(n45) );
  INVX1 U13 ( .A(A[3]), .Y(n35) );
  INVX1 U14 ( .A(A[2]), .Y(n42) );
  NAND2X1 U15 ( .A(A[4]), .B(n31), .Y(n30) );
  CLKINVX1 U16 ( .A(n52), .Y(n31) );
  NAND2X1 U17 ( .A(A[5]), .B(n46), .Y(n19) );
  CLKINVX1 U18 ( .A(n53), .Y(n46) );
  NAND2X1 U19 ( .A(A[6]), .B(n22), .Y(n21) );
  AOI21X1 U20 ( .A0(n15), .A1(n16), .B0(n17), .Y(LT_LE) );
  NAND3X1 U21 ( .A(n19), .B(n20), .C(n21), .Y(n16) );
  NAND3X1 U22 ( .A(n23), .B(n24), .C(n25), .Y(n20) );
  NAND2X1 U23 ( .A(n52), .B(n27), .Y(n24) );
  NAND3X1 U24 ( .A(n28), .B(n29), .C(n30), .Y(n23) );
  NAND2X1 U25 ( .A(n53), .B(n26), .Y(n25) );
  NOR2X1 U26 ( .A(A[6]), .B(n22), .Y(n48) );
  NOR2X1 U27 ( .A(A[7]), .B(n49), .Y(n47) );
  CLKINVX1 U28 ( .A(n56), .Y(n49) );
  NOR2X1 U29 ( .A(n56), .B(n18), .Y(n17) );
  INVX1 U30 ( .A(A[7]), .Y(n18) );
  NOR2X1 U31 ( .A(A[1]), .B(n44), .Y(n36) );
  CLKINVX1 U32 ( .A(n50), .Y(n44) );
  NOR2X1 U33 ( .A(A[2]), .B(n55), .Y(n32) );
  OAI21X1 U34 ( .A0(n36), .A1(n37), .B0(n38), .Y(n33) );
  NAND2X1 U35 ( .A(n51), .B(n35), .Y(n34) );
  NOR2X1 U36 ( .A(n39), .B(n40), .Y(n38) );
  NOR2X1 U37 ( .A(n50), .B(n41), .Y(n40) );
  NOR2X1 U38 ( .A(n54), .B(n42), .Y(n39) );
  INVX1 U39 ( .A(A[1]), .Y(n41) );
  CLKBUFX2 U40 ( .A(B[3]), .Y(n51) );
  NAND2X1 U41 ( .A(A[0]), .B(n43), .Y(n37) );
  INVX1 U42 ( .A(B[6]), .Y(n22) );
  CLKINVX1 U43 ( .A(n55), .Y(n54) );
  CLKBUFX2 U44 ( .A(B[7]), .Y(n56) );
  CLKBUFX2 U45 ( .A(B[4]), .Y(n52) );
  CLKBUFX2 U46 ( .A(B[5]), .Y(n53) );
  INVX1 U47 ( .A(B[2]), .Y(n55) );
  INVX1 U48 ( .A(B[0]), .Y(n43) );
endmodule


module u_con_DW01_cmp2_8_5 ( A, B, LEQ, TC, LT_LE, GE_GT );
  input [7:0] A;
  input [7:0] B;
  input LEQ, TC;
  output LT_LE, GE_GT;
  wire   n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57;

  INVX1 U6 ( .A(A[0]), .Y(n47) );
  CLKBUFX2 U7 ( .A(B[1]), .Y(n56) );
  OAI21X1 U8 ( .A0(n52), .A1(n27), .B0(n28), .Y(n26) );
  NAND2X1 U9 ( .A(n54), .B(n29), .Y(n28) );
  CLKINVX1 U10 ( .A(n57), .Y(n27) );
  CLKINVX1 U11 ( .A(n48), .Y(n29) );
  NOR2X1 U12 ( .A(n49), .B(n24), .Y(n18) );
  NOR2X1 U13 ( .A(n30), .B(n31), .Y(n25) );
  OAI21X1 U14 ( .A0(n53), .A1(n32), .B0(n33), .Y(n31) );
  NOR2X1 U15 ( .A(n34), .B(n35), .Y(n30) );
  CLKINVX1 U16 ( .A(n45), .Y(n32) );
  NOR2X1 U17 ( .A(n20), .B(n21), .Y(n19) );
  OAI21X1 U18 ( .A0(n57), .A1(n22), .B0(n23), .Y(n21) );
  NOR2X1 U19 ( .A(n25), .B(n26), .Y(n20) );
  CLKINVX1 U20 ( .A(n52), .Y(n22) );
  NAND2X1 U21 ( .A(n49), .B(n24), .Y(n23) );
  NAND2X1 U22 ( .A(n48), .B(n55), .Y(n33) );
  CLKBUFX2 U23 ( .A(B[3]), .Y(n53) );
  NOR2X1 U24 ( .A(n51), .B(n44), .Y(n43) );
  CLKINVX1 U25 ( .A(n56), .Y(n44) );
  CLKINVX1 U26 ( .A(n51), .Y(n42) );
  OAI21X1 U27 ( .A0(n45), .A1(n36), .B0(n37), .Y(n35) );
  CLKINVX1 U28 ( .A(n53), .Y(n36) );
  NOR3X1 U29 ( .A(n39), .B(n40), .C(n41), .Y(n34) );
  NOR2X1 U30 ( .A(n56), .B(n42), .Y(n41) );
  INVX1 U31 ( .A(B[6]), .Y(n24) );
  OAI2BB2X1 U32 ( .A0N(B[7]), .A1N(n17), .B0(n15), .B1(n16), .Y(LT_LE) );
  NOR2X1 U33 ( .A(B[7]), .B(n17), .Y(n15) );
  NOR2X1 U34 ( .A(n18), .B(n19), .Y(n16) );
  CLKINVX1 U35 ( .A(n46), .Y(n17) );
  CLKBUFX2 U36 ( .A(B[5]), .Y(n57) );
  CLKINVX1 U37 ( .A(n55), .Y(n54) );
  INVX1 U38 ( .A(B[4]), .Y(n55) );
  CLKBUFX3 U39 ( .A(A[1]), .Y(n51) );
  CLKBUFX3 U40 ( .A(A[4]), .Y(n48) );
  CLKBUFX3 U41 ( .A(A[3]), .Y(n45) );
  CLKBUFX3 U42 ( .A(A[6]), .Y(n49) );
  CLKINVX1 U43 ( .A(n50), .Y(n38) );
  CLKBUFX3 U44 ( .A(A[2]), .Y(n50) );
  CLKBUFX3 U45 ( .A(A[5]), .Y(n52) );
  CLKBUFX2 U46 ( .A(A[7]), .Y(n46) );
  NAND2X1 U47 ( .A(B[2]), .B(n38), .Y(n37) );
  NOR2X1 U48 ( .A(B[2]), .B(n38), .Y(n40) );
  NOR3X1 U49 ( .A(n43), .B(B[0]), .C(n47), .Y(n39) );
endmodule


module one_shot_3 ( rst_p, clk, d, q );
  input rst_p, clk, d;
  output q;
  wire   n1, n2, n3;

  CLKINVX1 U6 ( .A(d), .Y(n3) );
  NOR2BX1 U7 ( .AN(d), .B(n2), .Y(q) );
  INVX1 U8 ( .A(rst_p), .Y(n1) );
  DFFSX1 d_del_reg ( .D(n3), .CK(clk), .SN(n1), .QN(n2) );
endmodule

