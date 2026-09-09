// --=================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999, 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  --------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : tb_Sdram.v,v
//  File Revision          : 1.10
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
//  --------------------------------------------------------------------
//  Purpose : This module implements the top level testbench for the
//            Sdram Controller.
//
//            This testbench is to be used for functional tests
//            targetting SDRAM devices.
//
// --=================================================================--

`timescale 1ns / 1ps

`include "timing.v"

`uselib lib=tbench lib=uut lib=trickbox lib=N256M_x16 lib=N256M_x8                lib=N64M_x16 lib=N64M_x8 lib=M16M_x16 lib=M16M_x8

// ---------------------------------------------------------------------
// Set this define to 1'b1 during gate level simulations
// Set this define to 1'b0 during RTL simulations
// ---------------------------------------------------------------------
`define GATE_LEVEL 1'b0

// ---------------------------------------------------------------------
// The following SLOT* defines determine the type and configuration of
// SDRAMs that are present in each of the 4 Slots.
// ---------------------------------------------------------------------

 `define SLOT0_64_x16
// `define SLOT1_64_x16
// `define SLOT2_64_x16
// `define SLOT3_64_x16

// `define SLOT0_64_x8
 `define SLOT1_64_x8
// `define SLOT2_64_x8
// `define SLOT3_64_x8

// `define SLOT0_16_x16
// `define SLOT1_16_x16
 `define SLOT2_16_x16
// `define SLOT3_16_x16

// `define SLOT0_16_x8
// `define SLOT1_16_x8
// `define SLOT2_16_x8
 `define SLOT3_16_x8

// `define SLOT0_256_x16
// `define SLOT1_256_x16
// `define SLOT2_256_x16
// `define SLOT3_256_x16

// `define SLOT0_256_x8
// `define SLOT1_256_x8
// `define SLOT2_256_x8
// `define SLOT3_256_x8

module tb_Sdram();

parameter
  Verbosity       = 0,
  HaltOnMismatch  = 0,
  XonSig          = 0,
  SuppressOnReset = 0,
  TestMode        = 0,
  Databuswidth    = 32;

  parameter WIDTH         = 32;
  parameter ADDWIDTH      = 9 + WIDTH/64;
  parameter DQMWIDTH      = WIDTH/8;
  parameter HCLKPeriod    = `Tclk;
  parameter HCLKPhaseTime = HCLKPeriod / 2;
  parameter HCLKSkew      = 3;
  parameter HOLDDELAY     = 2;

// ---------------------------------------------------------------------
// Note on PARAMETERS :
// * Verbosity :       To suppress messages other than error messages,
//                     Verbosity has to be cleared.
// * HaltOnMismatch :  If HaltOnMismatch is set, then it halts the
//                     simulation when it detects any error.
// * XonSig :          XonSig if set enables signals to be unknown
//                     values, else signals will take its default
//                     values.
// * SuppressOnReset : SuppressOnReset suppresses all protocol
//                     checkings on slave's output signals.
// * TestMode :        TestMode if set, denotes test is being written
//                     in a Big endianness mode.
//                     Else if cleared, it is in little
//                     endianness mode.
// * Databuswidth :    Databuswidth can be set to 64 or 32, depending
//                     upon the device to be tested.
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

`define ORBUS  1'b1
// If this bit is set, then testbench will have a OR bus configuration
// Else, by default, it will be a MUX implementation

// ---------------------------------------------------------------------

wire        HCLK3;
wire        HRESETn3;
wire [31:0] HADDR3;
wire [31:0] HRDATA3;
wire [31:0] HWDATA3;
wire [15:0] HSEL3;
wire        HMASTLOCK3;
wire        HWRITE3;
wire [2:0]  HSIZE3;
wire [2:0]  HBURST3;
wire [3:0]  HPROT3;
wire [1:0]  HTRANS3;
reg  [1:0]  HRESP3;
reg         HREADY3;
wire [15:0] HSPLITIn3 = 16'h0000;
wire [3:0]  HMASTER3;
wire [31:0] VRG30;
wire [31:0] VRG31;
wire [31:0] VRG32;
wire [31:0] VRG33;
wire [31:0] VRG34;
wire [31:0] VRG35;
wire [31:0] VRG36;
wire [31:0] VRG37;
wire        HCLK2;
wire        HRESETn2;
wire [31:0] HADDR2;
wire [31:0] HRDATA2;
wire [31:0] HWDATA2;
wire [15:0] HSEL2;
wire        HMASTLOCK2;
wire        HWRITE2;
wire [2:0]  HSIZE2;
wire [2:0]  HBURST2;
wire [3:0]  HPROT2;
wire [1:0]  HTRANS2;
reg  [1:0]  HRESP2;
reg         HREADY2;
wire [15:0] HSPLITIn2 = 16'h0000;
wire [3:0]  HMASTER2;
wire [31:0] VRG20;
wire [31:0] VRG21;
wire [31:0] VRG22;
wire [31:0] VRG23;
wire [31:0] VRG24;
wire [31:0] VRG25;
wire [31:0] VRG26;
wire [31:0] VRG27;
wire        HCLK1;
wire        HRESETn1;
wire [31:0] HADDR1;
wire [31:0] HRDATA1;
wire [31:0] HWDATA1;
wire [15:0] HSEL1;
wire        HMASTLOCK1;
wire        HWRITE1;
wire [2:0]  HSIZE1;
wire [2:0]  HBURST1;
wire [3:0]  HPROT1;
wire [1:0]  HTRANS1;
reg  [1:0]  HRESP1;
reg         HREADY1;
wire [15:0] HSPLITIn1 = 16'h0000;
wire [3:0]  HMASTER1;
wire [31:0] VRG10;
wire [31:0] VRG11;
wire [31:0] VRG12;
wire [31:0] VRG13;
wire [31:0] VRG14;
wire [31:0] VRG15;
wire [31:0] VRG16;
wire [31:0] VRG17;
wire        HCLK0;
wire        HRESETn0;
wire [31:0] HADDR0;
wire [31:0] HRDATA0;
wire [31:0] HWDATA0;
wire [15:0] HSEL0;
wire        HMASTLOCK0;
wire        HWRITE0;
wire [2:0]  HSIZE0;
wire [2:0]  HBURST0;
wire [3:0]  HPROT0;
wire [1:0]  HTRANS0;
reg  [1:0]  HRESP0;
reg         HREADY0;
wire [15:0] HSPLITIn0 = 16'h0000;
wire [3:0]  HMASTER0;
wire [31:0] VRG00;
wire [31:0] VRG01;
wire [31:0] VRG02;
wire [31:0] VRG03;
wire [31:0] VRG04;
wire [31:0] VRG05;
wire [31:0] VRG06;
wire [31:0] VRG07;
wire        HREADYOut32;
wire        HREADYOut31;
wire        HREADYOut21;
wire        HREADYOut11;
wire        HREADYOut01;
wire [31:0] HRDATAOut32;
wire [31:0] HRDATAOut31;
wire [31:0] HRDATAOut21;
wire [31:0] HRDATAOut11;
wire [31:0] HRDATAOut01;
wire [1:0]  HRESPOut32;
wire [1:0]  HRESPOut31;
wire [1:0]  HRESPOut21;
wire [1:0]  HRESPOut11;
wire [1:0]  HRESPOut01;
wire        HREADYOut3;
wire        HREADYOut2;
wire        HREADYOut1;
wire        HREADYOut0;
wire [63:0] HRDATAOut3;
wire [63:0] HRDATAOut2;
wire [63:0] HRDATAOut1;
wire [63:0] HRDATAOut0;
wire [1:0]  HRESPOut3;
wire [1:0]  HRESPOut2;
wire [1:0]  HRESPOut1;
wire [1:0]  HRESPOut0;
reg  [15:0] DelHSEL3;
reg  [15:0] DelHSEL2;
reg  [15:0] DelHSEL1;
reg  [15:0] DelHSEL0;
wire        DefSlaveSel3;
wire        DefSlaveSel2;
wire        DefSlaveSel1;
wire        DefSlaveSel0;
reg         DelDefSel3;
reg         DelDefSel2;
reg         DelDefSel1;
reg         DelDefSel0;
wire        HREADYMUX3;
wire        HREADYMUX2;
wire        HREADYMUX1;
wire        HREADYMUX0;
wire        HREADYOR3;
wire        HREADYOR2;
wire        HREADYOR1;
wire        HREADYOR0;
wire [1:0]  HRESPOR3;
wire [1:0]  HRESPOR2;
wire [1:0]  HRESPOR1;
wire [1:0]  HRESPOR0;
wire [1:0]  HRESPMUX3;
wire [1:0]  HRESPMUX2;
wire [1:0]  HRESPMUX1;
wire [1:0]  HRESPMUX0;
wire [31:0] HRDATAMUX3;
wire [31:0] HRDATAMUX2;
wire [31:0] HRDATAMUX1;
wire [31:0] HRDATAMUX0;
wire [31:0] HRDATAOR3;
wire [31:0] HRDATAOR2;
wire [31:0] HRDATAOR1;
wire [31:0] HRDATAOR0;
wire [31:0] iVRG30;
wire [31:0] iVRG31;
wire [31:0] iVRG32;
wire [31:0] iVRG33;
wire [31:0] iVRG20;
wire [31:0] iVRG21;
wire [31:0] iVRG22;
wire [31:0] iVRG23;
wire [31:0] iVRG10;
wire [31:0] iVRG11;
wire [31:0] iVRG12;
wire [31:0] iVRG13;
wire [31:0] iVRG00;
wire [31:0] iVRG01;
wire [31:0] iVRG02;
wire [31:0] iVRG03;

  wire        nPORTrick;
  reg         nPORStart;
  wire        nPOR;

  wire        CLKOut;
  wire        SREFReq;
  wire [31:0] DataIn;
  wire        SREFAck;
  wire [31:0] DataOut;
  wire  [3:0] DQMOut;
  wire  [3:0] nCSOut;
  wire [14:0] AddrOut;
  wire  [3:0] CKEOut;
  wire        nRASOut;
  wire        nCASOut;
  wire        nWEOut;
  wire        DataEn;

  wire        ExtClk;
  wire [31:0] D;

  wire  VCC;
  wire  VSS;

  wire  [3:0] IntCKEOut;
  wire  [3:0] IntnCSOut;
  wire        IntnRASOut;
  wire        IntnCASOut;
  wire        IntnWEOut;
  wire  [3:0] IntDQMOut;
  wire [14:0] IntAddrOut;
  tri1 [31:0] IntD;

  wire  [3:0] DelCKEOut;
  wire  [3:0] DelnCSOut;
  wire        DelnRASOut;
  wire        DelnCASOut;
  wire        DelnWEOut;
  wire  [3:0] DelDQMOut;
  wire [14:0] DelAddrOut;
  wire [31:0] DelD;

  wire        HLOCKM;
  wire        HBUSREQM;
  wire        HGRANTM;
  wire        ExtBusReq;
  wire        ExtCtlReq;
  wire [31:0] RdData;
  wire        ExtBusGnt;
  wire [31:0] ZEROFILL;
  wire [31:0] dummyHWDATA;

  wire        SCANIN;
  wire        SCANENABLE;
  wire        SCANOUT;
  wire        BIGENDIAN;

  assign HLOCKM   = 1'b0;
  assign HBUSREQM = 1'b1;
  assign HGRANTM  = 1'b1;
  assign dummyHWDATA = 32'b0;

  assign ZEROFILL = 32'b0;
  assign SCANIN     = 1'b0;
  assign SCANENABLE = 1'b0;

  assign VRG33 = 32'b0;
  assign VRG34 = 32'b0;
  assign VRG35 = 32'b0;
  assign VRG36 = 32'b0;
  assign VRG37 = 32'b0;

  assign VRG23 = 32'b0;
  assign VRG24 = 32'b0;
  assign VRG25 = 32'b0;
  assign VRG26 = 32'b0;
  assign VRG27 = 32'b0;

  assign VRG13 = 32'b0;
  assign VRG14 = 32'b0;
  assign VRG15 = 32'b0;
  assign VRG16 = 32'b0;
  assign VRG17 = 32'b0;

  assign VRG03 = 32'b0;
  assign VRG04 = 32'b0;
  assign VRG05 = 32'b0;
  assign VRG06 = 32'b0;
  assign VRG07 = 32'b0;

  assign VCC = 1'b1;
  assign VSS = 1'b0;

  assign #HOLDDELAY DelCKEOut  = CKEOut;
  assign #HOLDDELAY DelnCSOut  = nCSOut;
  assign #HOLDDELAY DelnRASOut = nRASOut;
  assign #HOLDDELAY DelnCASOut = nCASOut;
  assign #HOLDDELAY DelnWEOut  = nWEOut;
  assign #HOLDDELAY DelDQMOut  = DQMOut;
  assign #HOLDDELAY DelAddrOut = AddrOut;
  assign #HOLDDELAY DelCKEOut  = CKEOut;
  assign #HOLDDELAY DelD       = D;

  assign IntCKEOut  = (`GATE_LEVEL == 1'b0) ? DelCKEOut  : CKEOut;
  assign IntnCSOut  = (`GATE_LEVEL == 1'b0) ? DelnCSOut  : nCSOut;
  assign IntnRASOut = (`GATE_LEVEL == 1'b0) ? DelnRASOut : nRASOut;
  assign IntnCASOut = (`GATE_LEVEL == 1'b0) ? DelnCASOut : nCASOut;
  assign IntnWEOut  = (`GATE_LEVEL == 1'b0) ? DelnWEOut  : nWEOut;
  assign IntDQMOut  = (`GATE_LEVEL == 1'b0) ? DelDQMOut  : DQMOut;
  assign IntAddrOut = (`GATE_LEVEL == 1'b0) ? DelAddrOut : AddrOut;
  assign IntD       = (`GATE_LEVEL == 1'b0) ? DelD       : D;

  assign #1 DataIn  = IntD;
// ---------------------------------------------------------------------
// Component declarations
// ---------------------------------------------------------------------
defparam U_ahbslave3_tb.Verbosity = Verbosity;
defparam U_ahbslave3_tb.HaltOnMismatch = HaltOnMismatch;
defparam U_ahbslave3_tb.XonSig = XonSig;
defparam U_ahbslave3_tb.TestMode = TestMode;
defparam U_ahbslave3_tb.Databuswidth = Databuswidth;
defparam U_ahbslave3_tb.SuppressOnReset = SuppressOnReset;

defparam U_ahbslave2_tb.Verbosity = Verbosity;
defparam U_ahbslave2_tb.HaltOnMismatch = HaltOnMismatch;
defparam U_ahbslave2_tb.XonSig = XonSig;
defparam U_ahbslave2_tb.TestMode = TestMode;
defparam U_ahbslave2_tb.Databuswidth = Databuswidth;
defparam U_ahbslave2_tb.SuppressOnReset = SuppressOnReset;

defparam U_ahbslave1_tb.Verbosity = Verbosity;
defparam U_ahbslave1_tb.HaltOnMismatch = HaltOnMismatch;
defparam U_ahbslave1_tb.XonSig = XonSig;
defparam U_ahbslave1_tb.TestMode = TestMode;
defparam U_ahbslave1_tb.Databuswidth = Databuswidth;
defparam U_ahbslave1_tb.SuppressOnReset = SuppressOnReset;

defparam U_ahbslave0_tb.Verbosity = Verbosity;
defparam U_ahbslave0_tb.HaltOnMismatch = HaltOnMismatch;
defparam U_ahbslave0_tb.XonSig = XonSig;
defparam U_ahbslave0_tb.TestMode = TestMode;
defparam U_ahbslave0_tb.Databuswidth = Databuswidth;
defparam U_ahbslave0_tb.SuppressOnReset = SuppressOnReset;

assign #(3) nPOR = nPORTrick & nPORStart;

// ---------------------------------------------------------------------
// Main body of code
// =================
// ---------------------------------------------------------------------

ahbslave3_tb  U_ahbslave3_tb (
                          .HCLK(HCLK3),
                          .HRESETn(HRESETn3),
                          .HADDR(HADDR3),
                          .HTRANS(HTRANS3),
                          .HWRITE(HWRITE3),
                          .HSIZE(HSIZE3),
                          .HBURST(HBURST3),
                          .HPROT(HPROT3),
                          .HMASTER(HMASTER3),
                          .HMASTLOCK(HMASTLOCK3),
                          .HWDATA({dummyHWDATA,HWDATA3}),
                          .HSPLIT(HSPLITIn3),
                          .HRDATA({32'h00000000,HRDATA3}),
                          .HREADY(HREADY3),
                          .HRESP(HRESP3),
                          .VRG0(VRG30),
                          .VRG1(VRG31),
                          .VRG2(VRG32),
                          .VRG3(VRG33),
                          .VRG4(VRG34),
                          .VRG5(VRG35),
                          .VRG6(VRG36),
                          .VRG7(VRG37)
                         );
 decoder1 U_decoder3 (
                    .HADDR(HADDR3),
                    .HSEL(HSEL3),
                    .DefSlaveSel(DefSlaveSel3)
                   );

ahbslave2_tb  U_ahbslave2_tb (
                          .HCLK(HCLK2),
                          .HRESETn(HRESETn2),
                          .HADDR(HADDR2),
                          .HTRANS(HTRANS2),
                          .HWRITE(HWRITE2),
                          .HSIZE(HSIZE2),
                          .HBURST(HBURST2),
                          .HPROT(HPROT2),
                          .HMASTER(HMASTER2),
                          .HMASTLOCK(HMASTLOCK2),
                          .HWDATA({dummyHWDATA,HWDATA2}),
                          .HSPLIT(HSPLITIn2),
                          .HRDATA({32'h00000000,HRDATA2}),
                          .HREADY(HREADY2),
                          .HRESP(HRESP2),
                          .VRG0(VRG20),
                          .VRG1(VRG21),
                          .VRG2(VRG22),
                          .VRG3(VRG23),
                          .VRG4(VRG24),
                          .VRG5(VRG25),
                          .VRG6(VRG26),
                          .VRG7(VRG27)
                         );
 decoder0 U_decoder2 (
                    .HADDR(HADDR2),
                    .HSEL(HSEL2),
                    .DefSlaveSel(DefSlaveSel2)
                   );

ahbslave1_tb  U_ahbslave1_tb (
                          .HCLK(HCLK1),
                          .HRESETn(HRESETn1),
                          .HADDR(HADDR1),
                          .HTRANS(HTRANS1),
                          .HWRITE(HWRITE1),
                          .HSIZE(HSIZE1),
                          .HBURST(HBURST1),
                          .HPROT(HPROT1),
                          .HMASTER(HMASTER1),
                          .HMASTLOCK(HMASTLOCK1),
                          .HWDATA({dummyHWDATA,HWDATA1}),
                          .HSPLIT(HSPLITIn1),
                          .HRDATA({32'h00000000,HRDATA1}),
                          .HREADY(HREADY1),
                          .HRESP(HRESP1),
                          .VRG0(VRG10),
                          .VRG1(VRG11),
                          .VRG2(VRG12),
                          .VRG3(VRG13),
                          .VRG4(VRG14),
                          .VRG5(VRG15),
                          .VRG6(VRG16),
                          .VRG7(VRG17)
                         );
 decoder0 U_decoder1 (
                    .HADDR(HADDR1),
                    .HSEL(HSEL1),
                    .DefSlaveSel(DefSlaveSel1)
                   );

ahbslave0_tb  U_ahbslave0_tb (
                          .HCLK(HCLK0),
                          .HRESETn(HRESETn0),
                          .HADDR(HADDR0),
                          .HTRANS(HTRANS0),
                          .HWRITE(HWRITE0),
                          .HSIZE(HSIZE0),
                          .HBURST(HBURST0),
                          .HPROT(HPROT0),
                          .HMASTER(HMASTER0),
                          .HMASTLOCK(HMASTLOCK0),
                          .HWDATA({dummyHWDATA,HWDATA0}),
                          .HSPLIT(HSPLITIn0),
                          .HRDATA({32'h00000000,HRDATA0}),
                          .HREADY(HREADY0),
                          .HRESP(HRESP0),
                          .VRG0(VRG00),
                          .VRG1(VRG01),
                          .VRG2(VRG02),
                          .VRG3(VRG03),
                          .VRG4(VRG04),
                          .VRG5(VRG05),
                          .VRG6(VRG06),
                          .VRG7(VRG07)
                         );
 decoder0 U_decoder0 (
                    .HADDR(HADDR0),
                    .HSEL(HSEL0),
                    .DefSlaveSel(DefSlaveSel0)
                   );
// ---------------------------------------------------------------------
// Trickbox instantiation
// ---------------------------------------------------------------------

 SdramTrick  uSdramTrick (
             .HCLK(HCLK3),
             .HRESETn(HRESETn3),
             .HSIZE(HSIZE3),
             .HBURST(HBURST3),
             .HTRANS(HTRANS3),
             .HWRITE(HWRITE3),
             .HSEL(HSEL3[2]),
             .HREADYIn(HREADY3),
             .BIGENDIAN(BIGENDIAN),

             .SREFAck(SREFAck),
             .CKE(CKEOut),
             .nRAS(nRASOut),
             .nCAS(nCASOut),
             .nCS(nCSOut),
             .nWE(nWEOut),
             .ExtBusReq(ExtBusReq | ExtCtlReq),
             .AddrOut(AddrOut[13:0]),
             .HADDR(HADDR3[10:0]),
             .HWDATA(HWDATA3),

             .nPOR(nPORTrick),
             .ExtBusGnt(ExtBusGnt),
             .SREFReq(SREFReq),
             .HREADYOut(HREADYOut32),
             .HRESP(HRESPOut32),
             .HRDATA(HRDATAOut32)
            );

Sdram uSdram (
               .HCLK(HCLK3),
               .CLKIn(ExtClk),
               .HRESETn(HRESETn3),
               .nPOR(nPOR),
               .SREFReq(SREFReq),
               .ExtBusGnt(ExtBusGnt),
               .ExtCtlGnt(ExtBusGnt),
               .DataIn(DataIn),

               .HSIZE3(HSIZE3[1:0]),
               .HWRITE3(HWRITE3),
               .HTRANS3(HTRANS3),
               .HBURST3(HBURST3),
               .HREADYin3(HREADY3),
               .HSELram3(HSEL3[1]),
               .HSELreg3(HSEL3[0]),
               .HADDR3(HADDR3[28:0]),
               .HWDATA3(HWDATA3),

               .HSIZE2(HSIZE2[1:0]),
               .HWRITE2(HWRITE2),
               .HTRANS2(HTRANS2),
               .HBURST2(HBURST2),
               .HREADYin2(HREADY2),
               .HSELram2(HSEL2[0]),
               .HADDR2(HADDR2[28:0]),
               .HWDATA2(HWDATA2),

               .HSIZE1(HSIZE1[1:0]),
               .HWRITE1(HWRITE1),
               .HTRANS1(HTRANS1),
               .HBURST1(HBURST1),
               .HREADYin1(HREADY1),
               .HSELram1(HSEL1[0]),
               .HADDR1(HADDR1[28:0]),
               .HWDATA1(HWDATA1),

               .HSIZE0(HSIZE0[1:0]),
               .HWRITE0(HWRITE0),
               .HTRANS0(HTRANS0),
               .HBURST0(HBURST0),
               .HREADYin0(HREADY0),
               .HSELram0(HSEL0[0]),
               .HADDR0(HADDR0[28:0]),
               .HWDATA0(HWDATA0),

               .SCANIN(SCANIN),
               .SCANENABLE(SCANENABLE),
               .BIGENDIAN(BIGENDIAN),

               .HRDATA3(HRDATAOut31),
               .HRESP3(HRESPOut31),
               .HREADYout3(HREADYOut31),

               .HRDATA2(HRDATAOut21),
               .HRESP2(HRESPOut21),
               .HREADYout2(HREADYOut21),

               .HRDATA1(HRDATAOut11),
               .HRESP1(HRESPOut11),
               .HREADYout1(HREADYOut11),

               .HRDATA0(HRDATAOut01),
               .HRESP0(HRESPOut01),
               .HREADYout0(HREADYOut01),

               .SREFAck(SREFAck),
               .DataOut(DataOut),
               .DQMOut(DQMOut),
               .nCSOut(nCSOut),
               .AddrOut(AddrOut),
               .CKEOut(CKEOut),
               .nRASOut(nRASOut),
               .nCASOut(nCASOut),
               .nWEOut(nWEOut),
               .DataEn(DataEn),
               .CLKOut(CLKOut),
               .ExtBusReq(ExtBusReq),
               .ExtCtlReq(ExtCtlReq),

               .SCANOUT(SCANOUT)

              );

 defslave  U_Defslave3 (
                       .HCLK(HCLK3),
                       .HSEL(DelDefSel3),
                       .HRESETn(HRESETn3),
                       .HTRANS(HTRANS3[1]),
                       .HRESP(HRESPOut3),
                       .HREADYIn(HREADY3),
                       .HREADYOut(HREADYOut3),
                       .HRDATAOut(HRDATAOut3)
                      );

 defslave  U_Defslave2 (
                       .HCLK(HCLK2),
                       .HSEL(DelDefSel2),
                       .HRESETn(HRESETn2),
                       .HTRANS(HTRANS2[1]),
                       .HRESP(HRESPOut2),
                       .HREADYIn(HREADY2),
                       .HREADYOut(HREADYOut2),
                       .HRDATAOut(HRDATAOut2)
                      );

 defslave  U_Defslave1 (
                       .HCLK(HCLK1),
                       .HSEL(DelDefSel1),
                       .HRESETn(HRESETn1),
                       .HTRANS(HTRANS1[1]),
                       .HRESP(HRESPOut1),
                       .HREADYIn(HREADY1),
                       .HREADYOut(HREADYOut1),
                       .HRDATAOut(HRDATAOut1)
                      );

 defslave  U_Defslave0 (
                       .HCLK(HCLK0),
                       .HSEL(DelDefSel0),
                       .HRESETn(HRESETn0),
                       .HTRANS(HTRANS0[1]),
                       .HRESP(HRESPOut0),
                       .HREADYIn(HREADY0),
                       .HREADYOut(HREADYOut0),
                       .HRDATAOut(HRDATAOut0)
                      );

defparam uBusWatch3.Verbosity = Verbosity;
defparam uBusWatch3.HaltOnMismatch = HaltOnMismatch;
 BusWatch uBusWatch3 (
                     .HCLK     (HCLK3),
                     .HRESETn  (HRESETn3),
                     .HTRANS   (HTRANS3),
                     .HADDR    (HADDR3),
                     .HSIZE    (HSIZE3),
                     .HBURST   (HBURST3),
                     .HBUSREQx (HBUSREQM),
                     .HGRANTx  (HGRANTM),
                     .HREADY   (HREADYMUX3),
                     .HLOCKx   (HLOCKM),
                     .HWDATA   ({dummyHWDATA, HWDATA3}),
                     .HPROT    (HPROT3),
                     .HWRITE   (HWRITE3),
                     .HRESP    (HRESPMUX3)
                    );

defparam uBusWatch2.Verbosity = Verbosity;
defparam uBusWatch2.HaltOnMismatch = HaltOnMismatch;
 BusWatch uBusWatch2 (
                     .HCLK     (HCLK2),
                     .HRESETn  (HRESETn2),
                     .HTRANS   (HTRANS2),
                     .HADDR    (HADDR2),
                     .HSIZE    (HSIZE2),
                     .HBURST   (HBURST2),
                     .HBUSREQx (HBUSREQM),
                     .HGRANTx  (HGRANTM),
                     .HREADY   (HREADYMUX2),
                     .HLOCKx   (HLOCKM),
                     .HWDATA   ({dummyHWDATA, HWDATA2}),
                     .HPROT    (HPROT2),
                     .HWRITE   (HWRITE2),
                     .HRESP    (HRESPMUX2)
                    );

defparam uBusWatch1.Verbosity = Verbosity;
defparam uBusWatch1.HaltOnMismatch = HaltOnMismatch;
 BusWatch uBusWatch1 (
                     .HCLK     (HCLK1),
                     .HRESETn  (HRESETn1),
                     .HTRANS   (HTRANS1),
                     .HADDR    (HADDR1),
                     .HSIZE    (HSIZE1),
                     .HBURST   (HBURST1),
                     .HBUSREQx (HBUSREQM),
                     .HGRANTx  (HGRANTM),
                     .HREADY   (HREADYMUX1),
                     .HLOCKx   (HLOCKM),
                     .HWDATA   ({dummyHWDATA, HWDATA1}),
                     .HPROT    (HPROT1),
                     .HWRITE   (HWRITE1),
                     .HRESP    (HRESPMUX1)
                    );

defparam uBusWatch0.Verbosity = Verbosity;
defparam uBusWatch0.HaltOnMismatch = HaltOnMismatch;
 BusWatch uBusWatch0 (
                     .HCLK     (HCLK0),
                     .HRESETn  (HRESETn0),
                     .HTRANS   (HTRANS0),
                     .HADDR    (HADDR0),
                     .HSIZE    (HSIZE0),
                     .HBURST   (HBURST0),
                     .HBUSREQx (HBUSREQM),
                     .HGRANTx  (HGRANTM),
                     .HREADY   (HREADYMUX0),
                     .HLOCKx   (HLOCKM),
                     .HWDATA   ({dummyHWDATA, HWDATA0}),
                     .HPROT    (HPROT0),
                     .HWRITE   (HWRITE0),
                     .HRESP    (HRESPMUX0)
                    );

//----------------------------------------------------------------------
// Model the trace delay in the clock fed to the memory devices
//----------------------------------------------------------------------
  assign #HCLKSkew ExtClk = CLKOut;

//----------------------------------------------------------------------
// Drive write data from the SDRAM controller onto the main memory
// databus when the DataEn wire is asserted.
//----------------------------------------------------------------------
  assign D = (DataEn == 1'b1) ? DataOut : 32'bz;

//----------------------------------------------------------------------
// Memory organisation is set by defines at the beginning of this file.
// * 4 Chip Selects from the SDRAM controller each select 32 bit wide
//   memory constructed using either two x16 devices or four x8 devices.
// * The 4 CKEs from the SDRAM controller individually connect to a
//   single set of devices making a 32 bit wide memory.
// * Each of 4 DQMs from the SDRAM controller connect to all devices
//   driving a byte lane. DQM[0] enables data bits [7:0], DQM[1] enables
//   data bits [15:8] etc.
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// 256M x16 configuration starts here
//----------------------------------------------------------------------
`ifdef SLOT0_256_x16
 SdramNec256Mx16 u0_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[15:0])
            );

 SdramNec256Mx16 u0_1_sdram
             (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[31:16])
          );
`endif

`ifdef SLOT1_256_x16
 SdramNec256Mx16 u1_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[15:0])
            );

 SdramNec256Mx16 u1_1_sdram
             (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[31:16])
          );
`endif

`ifdef SLOT2_256_x16
 SdramNec256Mx16 u2_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[15:0])
            );

 SdramNec256Mx16 u2_1_sdram
             (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[31:16])
          );
`endif

`ifdef SLOT3_256_x16
 SdramNec256Mx16 u3_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[15:0])
            );

 SdramNec256Mx16 u3_1_sdram
             (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[31:16])
          );
`endif

//----------------------------------------------------------------------
// 256M x8 configuration starts here
//----------------------------------------------------------------------
`ifdef SLOT0_256_x8
 SdramNec256Mx8 u0_0_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[7:0])
            );

 SdramNec256Mx8 u0_1_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[15:8])
          );

 SdramNec256Mx8 u0_2_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[23:16])
          );

 SdramNec256Mx8 u0_3_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT1_256_x8
 SdramNec256Mx8 u1_0_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[7:0])
            );

 SdramNec256Mx8 u1_1_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[15:8])
          );

 SdramNec256Mx8 u1_2_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[23:16])
          );
 SdramNec256Mx8 u1_3_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT2_256_x8
 SdramNec256Mx8 u2_0_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[7:0])
            );

 SdramNec256Mx8 u2_1_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[15:8])
          );

 SdramNec256Mx8 u2_2_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[23:16])
          );

 SdramNec256Mx8 u2_3_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT3_256_x8
 SdramNec256Mx8 u3_0_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[7:0])
            );

 SdramNec256Mx8 u3_1_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[15:8])
          );

 SdramNec256Mx8 u3_2_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[23:16])
          );

 SdramNec256Mx8 u3_3_sdram_x8
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[12:0]),
             .ba(IntAddrOut[14:13]),

             .dq(IntD[31:24])
          );
`endif

//----------------------------------------------------------------------
// 64M x16 configuration starts here
//----------------------------------------------------------------------
`ifdef SLOT0_64_x16
  SdramNec64Mx16 u0_0_sdram
            (.clk( ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[15:0])
            );

  SdramNec64Mx16 u0_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[31:16])
          );
`endif

`ifdef SLOT1_64_x16
  SdramNec64Mx16 u1_0_sdram
            (.clk( ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[15:0])
            );

  SdramNec64Mx16 u1_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[31:16])
          );
`endif

`ifdef SLOT2_64_x16
  SdramNec64Mx16 u2_0_sdram
            (.clk( ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[15:0])
            );

  SdramNec64Mx16 u2_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[31:16])
          );
`endif

`ifdef SLOT3_64_x16
  SdramNec64Mx16 u3_0_sdram
            (.clk( ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[15:0])
            );

  SdramNec64Mx16 u3_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[31:16])
          );
`endif

//----------------------------------------------------------------------
// 64M x8 configuration starts here
//----------------------------------------------------------------------
`ifdef SLOT0_64_x8
  SdramNec64Mx8 u0_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[7:0])
            );

   SdramNec64Mx8 u0_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[15:8])
          );

   SdramNec64Mx8 u0_2_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[13:0])

             .dq(IntD[23:16])
          );

   SdramNec64Mx8 u0_3_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT1_64_x8
   SdramNec64Mx8 u1_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[7:0])
            );

   SdramNec64Mx8 u1_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[15:8])
          );

   SdramNec64Mx8 u1_2_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[23:16])
          );
   SdramNec64Mx8 u1_3_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT2_64_x8
   SdramNec64Mx8 u2_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[7:0])
            );

   SdramNec64Mx8 u2_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[15:8])
          );

   SdramNec64Mx8 u2_2_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[23:16])

          );

   SdramNec64Mx8 u2_3_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT3_64_x8
   SdramNec64Mx8 u3_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[7:0])
            );

   SdramNec64Mx8 u3_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[15:8])
          );

   SdramNec64Mx8 u3_2_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[23:16])
          );

   SdramNec64Mx8 u3_3_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[13:0]),

             .dq(IntD[31:24])
          );
`endif

//----------------------------------------------------------------------
// 16M x16 configuration starts here
//----------------------------------------------------------------------
`ifdef SLOT0_16_x16
  SdramMicron16Mx16 u0_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[15:0])
            );

  SdramMicron16Mx16 u0_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[31:16])
          );

`endif

`ifdef SLOT1_16_x16
  SdramMicron16Mx16 u1_0_sdram
            (.clk( ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[15:0])
            );

  SdramMicron16Mx16 u1_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[31:16])
          );
`endif

`ifdef SLOT2_16_x16
  SdramMicron16Mx16 u2_0_sdram
            (.clk( ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[15:0])
            );

  SdramMicron16Mx16 u2_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[31:16])
          );
`endif

`ifdef SLOT3_16_x16
  SdramMicron16Mx16 u3_0_sdram
            (.clk( ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1:0]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[15:0])
            );

  SdramMicron16Mx16 u3_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3:2]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[31:16])
          );
`endif

//----------------------------------------------------------------------
// 16M x8 configuration starts here
//----------------------------------------------------------------------
`ifdef SLOT0_16_x8
  SdramMicron16Mx8 u0_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[7:0])
            );

  SdramMicron16Mx8 u0_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[15:8])
          );

  SdramMicron16Mx8 u0_2_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[23:16])
          );

  SdramMicron16Mx8 u0_3_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[0]),
             .csbar(IntnCSOut[0]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT1_16_x8
  SdramMicron16Mx8 u1_0_sdram
            (.clk( ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[7:0])
            );

  SdramMicron16Mx8 u1_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[15:8])
          );

  SdramMicron16Mx8 u1_2_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[23:16])
          );

  SdramMicron16Mx8 u1_3_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[1]),
             .csbar(IntnCSOut[1]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT2_16_x8
  SdramMicron16Mx8 u2_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[7:0])
            );

  SdramMicron16Mx8 u2_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),

             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[15:8])
          );

  SdramMicron16Mx8 u2_2_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[23:16])
          );

  SdramMicron16Mx8 u2_3_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[2]),
             .csbar(IntnCSOut[2]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[31:24])
          );
`endif

`ifdef SLOT3_16_x8
  SdramMicron16Mx8 u3_0_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[0]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[7:0])
            );

  SdramMicron16Mx8 u3_1_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[1]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[15:8])
          );

  SdramMicron16Mx8 u3_2_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[2]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[23:16])
          );

  SdramMicron16Mx8 u3_3_sdram
            (.clk(ExtClk),
             .cke(IntCKEOut[3]),
             .csbar(IntnCSOut[3]),
             .rasbar(IntnRASOut),
             .casbar(IntnCASOut),
             .webar(IntnWEOut),
             .dqm(IntDQMOut[3]),
             .a(IntAddrOut[10:0]),
             .ba(IntAddrOut[11]),

             .dq(IntD[31:24])
          );
`endif

// ---------------------------------------------------------------------
// Main body of code
// =================
// ---------------------------------------------------------------------

  assign iVRG00  = VRG00;
  assign iVRG01  = VRG01;
  assign iVRG02  = VRG02;
  assign iVRG03  = VRG03;

  assign iVRG10  = VRG10;
  assign iVRG11  = VRG11;
  assign iVRG12  = VRG12;
  assign iVRG13  = VRG13;

  assign iVRG20  = VRG20;
  assign iVRG21  = VRG21;
  assign iVRG22  = VRG22;
  assign iVRG23  = VRG23;

  assign iVRG30  = VRG30;
  assign iVRG31  = VRG31;
  assign iVRG32  = VRG32;
  assign iVRG33  = VRG33;

  assign VRG04   = iVRG00;
  assign VRG05   = iVRG01;
  assign VRG07   = iVRG03;
  assign VRG06   = iVRG02;

  assign VRG14   = iVRG10;
  assign VRG15   = iVRG11;
  assign VRG17   = iVRG13;
  assign VRG16   = iVRG12;

  assign VRG24   = iVRG20;
  assign VRG25   = iVRG21;
  assign VRG27   = iVRG23;
  assign VRG26   = iVRG22;

  assign VRG34   = iVRG30;
  assign VRG35   = iVRG31;
  assign VRG37   = iVRG33;
  assign VRG36   = iVRG32;

  assign HRDATA3 = (`ORBUS == 1'b1) ? HRDATAOR3 : HRDATAMUX3;
  assign HRDATA2 = (`ORBUS == 1'b1) ? HRDATAOR2 : HRDATAMUX2;
  assign HRDATA1 = (`ORBUS == 1'b1) ? HRDATAOR1 : HRDATAMUX1;
  assign HRDATA0 = (`ORBUS == 1'b1) ? HRDATAOR0 : HRDATAMUX0;
// --------------------------------------------------------------------
// For MUX-bus implementations
// --------------------------------------------------------------------

  assign HREADYMUX3 = (DelHSEL3[2] == 1'b1) ? HREADYOut32 :
                      (DelHSEL3[1] == 1'b1) ? HREADYOut31 :
                      (DelHSEL3[0] == 1'b1) ? HREADYOut31 :
                      (DelDefSel3  == 1'b1) ? HREADYOut3  : 1'b0;

  assign HRESPMUX3  = (DelHSEL3[2] == 1'b1) ? HRESPOut32 :
                     (DelHSEL3[1] == 1'b1) ? HRESPOut31 :
                     (DelHSEL3[0] == 1'b1) ? HRESPOut31 :
                     (DelDefSel3  == 1'b1) ? HRESPOut3  : 2'b00;

  assign HRDATAMUX3 = (DelHSEL3[2] == 1'b1) ? HRDATAOut32 :
                     (DelHSEL3[1] == 1'b1) ? HRDATAOut31 :
                     (DelHSEL3[0] == 1'b1) ? HRDATAOut31 :
                     (DelDefSel3  == 1'b1) ? HRDATAOut3  :
                     64'b0000000000000000;

  assign HREADYMUX2 = (DelHSEL2[0] == 1'b1) ? HREADYOut21 :
                      (DelDefSel2  == 1'b1) ? HREADYOut2  : 1'b0;

  assign HRESPMUX2  = (DelHSEL2[0] == 1'b1) ? HRESPOut21 :
                     (DelDefSel2  == 1'b1) ? HRESPOut2  : 2'b00;

  assign HRDATAMUX2 = (DelHSEL2[0] == 1'b1) ? HRDATAOut21 :
                     (DelDefSel2  == 1'b1) ? HRDATAOut2  :
                     64'b0000000000000000;

  assign HREADYMUX1 = (DelHSEL1[0] == 1'b1) ? HREADYOut11 :
                      (DelDefSel1  == 1'b1) ? HREADYOut1  : 1'b0;

  assign HRESPMUX1  = (DelHSEL1[0] == 1'b1) ? HRESPOut11 :
                     (DelDefSel1  == 1'b1) ? HRESPOut1  : 2'b00;

  assign HRDATAMUX1 = (DelHSEL1[0] == 1'b1) ? HRDATAOut11 :
                     (DelDefSel1  == 1'b1) ? HRDATAOut1  :
                     64'b0000000000000000;

  assign HREADYMUX0 = (DelHSEL0[0] == 1'b1) ? HREADYOut01 :
                      (DelDefSel0  == 1'b1) ? HREADYOut0  : 1'b0;

  assign HRESPMUX0  = (DelHSEL0[0] == 1'b1) ? HRESPOut01 :
                     (DelDefSel0  == 1'b1) ? HRESPOut3  : 2'b00;

  assign HRDATAMUX0 = (DelHSEL0[0] == 1'b1) ? HRDATAOut01 :
                     (DelDefSel0  == 1'b1) ? HRDATAOut0  :
                     64'b0000000000000000;

// --------------------------------------------------------------------
// For OR bus implementations
// --------------------------------------------------------------------
  assign HRESPOR3  = HRESPOut31  | HRESPOut32 | HRESPOut3;

  assign HREADYOR3 = HREADYOut31 | HREADYOut32 | HREADYOut3;

  assign HRDATAOR3 = HRDATAOut31 | HRDATAOut32 | HRDATAOut3;

  assign HRESPOR2  = HRESPOut21  | HRESPOut2;

  assign HREADYOR2 = HREADYOut21 | HREADYOut2;

  assign HRDATAOR2 = HRDATAOut21 | HRDATAOut2;

  assign HRESPOR1  = HRESPOut11  | HRESPOut1;

  assign HREADYOR1 = HREADYOut11 | HREADYOut1;

  assign HRDATAOR1 = HRDATAOut11 | HRDATAOut1;

  assign HRESPOR0  = HRESPOut01  | HRESPOut0;

  assign HREADYOR0 = HREADYOut01 | HREADYOut0;

  assign HRDATAOR0 = HRDATAOut01 | HRDATAOut0;

// --------------------------------------------------------------------
// Generating HREADY Output
// --------------------------------------------------------------------
always @(HREADYOR3 or HREADYMUX3 or HRESETn3)
begin : p_Output3Seq
  if (`ORBUS == 1'b1)
    HREADY3 = HREADYOR3;
  else
    HREADY3 = HREADYMUX3;
end

always @(HREADYOR2 or HREADYMUX2 or HRESETn2)
begin : p_Output2Seq
  if (`ORBUS == 1'b1)
    HREADY2 = HREADYOR2;
  else
    HREADY2 = HREADYMUX2;
end

always @(HREADYOR1 or HREADYMUX1 or HRESETn1)
begin : p_Output1Seq
  if (`ORBUS == 1'b1)
    HREADY1 = HREADYOR1;
  else
    HREADY1 = HREADYMUX1;
end

always @(HREADYOR0 or HREADYMUX0 or HRESETn0)
begin : p_Output0Seq
  if (`ORBUS == 1'b1)
    HREADY0 = HREADYOR0;
  else
    HREADY0 = HREADYMUX0;
end

// --------------------------------------------------------------------
// Generating HRESP Output
// --------------------------------------------------------------------
always @(HRESPOR3 or HRESPMUX3 or HRESETn3)
begin : p_Resp3Seq
  if (`ORBUS == 1'b1)
    HRESP3 = HRESPOR3;
  else
    HRESP3 = HRESPMUX3;
end

always @(HRESPOR2 or HRESPMUX2 or HRESETn2)
begin : p_Resp2Seq
  if (`ORBUS == 1'b1)
    HRESP2 = HRESPOR2;
  else
    HRESP2 = HRESPMUX2;
end

always @(HRESPOR1 or HRESPMUX1 or HRESETn1)
begin : p_Resp1Seq
  if (`ORBUS == 1'b1)
    HRESP1 = HRESPOR1;
  else
    HRESP1 = HRESPMUX1;
end

always @(HRESPOR0 or HRESPMUX0 or HRESETn0)
begin : p_Resp0Seq
  if (`ORBUS == 1'b1)
    HRESP0 = HRESPOR0;
  else
    HRESP0 = HRESPMUX0;
end

// --------------------------------------------------------------------
// Latching HSEL
// --------------------------------------------------------------------
always @(posedge HCLK3 or negedge HRESETn3)
begin : p_HSEL3Seq
  if (HRESETn3 == 1'b0)
  begin
    DelHSEL3   <= 16'h0000;
    DelDefSel3 <= 1'b1;
  end
  else
    if (HREADY3 == 1'b1)
    begin
      DelHSEL3   <= HSEL3;
      DelDefSel3 <= DefSlaveSel3;
    end
end // p_HSEL3Seq;

always @(posedge HCLK2 or negedge HRESETn2)
begin : p_HSEL2Seq
  if (HRESETn2 == 1'b0)
  begin
    DelHSEL2   <= 16'h0000;
    DelDefSel2 <= 1'b1;
  end
  else
    if (HREADY2 == 1'b1)
    begin
      DelHSEL2   <= HSEL2;
      DelDefSel2 <= DefSlaveSel2;
    end
end // p_HSEL2Seq;

always @(posedge HCLK1 or negedge HRESETn1)
begin : p_HSEL1Seq
  if (HRESETn1 == 1'b0)
  begin
    DelHSEL1   <= 16'h0000;
    DelDefSel1 <= 1'b1;
  end
  else
    if (HREADY1 == 1'b1)
    begin
      DelHSEL1   <= HSEL1;
      DelDefSel1 <= DefSlaveSel1;
    end
end // p_HSEL1Seq;

always @(posedge HCLK0 or negedge HRESETn0)
begin : p_HSEL0Seq
  if (HRESETn0 == 1'b0)
  begin
    DelHSEL0   <= 16'h0000;
    DelDefSel0 <= 1'b1;
  end
  else
    if (HREADY0 == 1'b1)
    begin
      DelHSEL0   <= HSEL0;
      DelDefSel0 <= DefSlaveSel0;
    end
end // p_HSEL0Seq;

initial
begin
  HREADY3 = 1'b1;
  HREADY2 = 1'b1;
  HREADY1 = 1'b1;
  HREADY0 = 1'b1;
end

initial
  begin
    $timeformat(-9, 0, " ns", 9);
  end

// include system task for best/worst case SDF delay annotation.
  `ifdef NET_MAX
  initial
  begin
    $sdf_annotate("../../../verilog/uutNetlist/Sdram_Verilog.sdf21",uSdram,,,"MAXIMUM");
  end
  `endif

  `ifdef NET_MIN
   initial
   begin
     $sdf_annotate("../../../verilog/uutNetlist/Sdram_Verilog.sdf21",uSdram,,,"MINIMUM");
   end
  `endif

/*
initial
begin
  $dumpvars();
  $dumpfile("/dump/arm/sd.vcd");
end
*/

// This initial block was added to prevent 'X' propagation related
// problems during gate levels simulations.
initial
  begin
    #1  nPORStart = @(posedge HCLK3) 1'b0;
    #1  nPORStart = @(posedge HCLK3) 1'b1;
  end

endmodule

// --============================= End ===============================--
