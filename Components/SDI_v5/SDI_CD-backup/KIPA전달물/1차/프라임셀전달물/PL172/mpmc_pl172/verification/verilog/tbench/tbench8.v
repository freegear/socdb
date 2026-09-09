// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : tbench8.v.rca
// File Revision          : 1.8
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose : 
//           Top level of the MPMC Compliance TestBench
//
//           This file instantiates the MPMC module, the MPMC trickbox
//           the AHB decoder and the Default Slave. 
//    CS        Part               Vendor  Size    SOMA
//    DYCS[0] : HM5212165F-75a     Hitachi 8Mx32   (hm5212165f_75a.soma x 2)
//    DYCS[1] : MT48LC1M16A1_6s    Micron  1Mx16   (mt48lc1m16a1_6s.soma)
//    DYCS[2] : HM5225805B-75      Hitachi 32Mx16  (hm5225805b_75.soma x 2)
//    DYCS[3] : MT48LC2M32B2-6     Micron  2Mx32   (mt48lc2m32b2_6.soma)
//
//    STCS[0] : 28F320W18B_70      Intel   2Mx16   (I28f320w18b_70.soma) 
//    STCS[1] : 28F800F3B95-EXT    Intel   512Kx32 (Int28f800f3b95.soma X 2)
//    STCS[2] : 28F800F3B115-AUTO  Intel   512Kx16 (Int28f800f3b115.soma) 
//    STCS[3] : 28F800F3B115-AUTO  Intel   512Kx32 (Int28f800f3b115.soma X 2)
//
// --=========================================================================--

`timescale 1ns/1ps

`include "../tbench/timing.v"
`include "../tbench/timingmaster.v"
`include "../common/defs.v"

`include "../trickbox/MpmcTrParams.v"

// -----------------------------------------------------------------------------

module tbench8();

parameter Verbosity       = 0;
parameter HaltOnMismatch  = 0;
parameter XonSig          = 0;
parameter SuppressOnReset = 0;
parameter Databuswidth    = 32;

// -----------------------------------------------------------------------------
// Note on PARAMETERS :
// * Verbosity       : To suppress messages other than error messages,
//                     Verbosity is to be cleared.
// * HaltOnMismatch  : If HaltOnMismatch is set, it halts the
//                     simulation when it detects any error.
// * XonSig          : XonSig if set, enables signals to be unknown
//                     values; else signals will take their default
//                     values.
// * SuppressOnReset : SuppressOnReset suppresses all protocol checks
//                     on slave's output signals.
// * Databuswidth    : Databuswidth can be set to 64 or 32, depending
//                     upon the device to be tested.
// -----------------------------------------------------------------------------

`uselib lib=uut lib=trickbox

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define ORBUS        1'b0
// If this bit is set, the testbench will have an OR bus configuration
// Else, by default, it will be a MUX implementation.

// -----------------------------------------------------------------------------
// FBCLK generation
// Feedback clk is used to sample the data. Each memory has its own trc value
// after which data becomes stable. During command delay mode, to sample the   
// data at the proper time, FBCLK clocks are made tbench dependent.
// -----------------------------------------------------------------------------
`define MPMCCLKOUT_TO_MPMCFBCLKIN0_DELAY 3
`define MPMCCLKOUT_TO_MPMCFBCLKIN1_DELAY 3
`define MPMCCLKOUT_TO_MPMCFBCLKIN2_DELAY 3
`define MPMCCLKOUT_TO_MPMCFBCLKIN3_DELAY 3
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        HCLK;
wire        HRESETn;
wire        HRESET0n;
wire        HRESET1n;
wire        HRESET2n;
wire        MemReset;

// Virtual registers (AHB 0).
wire [31:0] VRG00;
wire [31:0] VRG01;
wire [31:0] VRG02;
wire [31:0] VRG03;
wire [31:0] VRG04;
wire [31:0] VRG05;
wire [31:0] VRG06;
wire [31:0] VRG07;

// Internal version of virtual registers (AHB 0).
wire [31:0] iVRG00;
wire [31:0] iVRG01;
wire [31:0] iVRG02;
wire        iVRG03;

// Virtual registers (AHB 1).
wire [31:0] VRG10;
wire [31:0] VRG11;
wire [31:0] VRG12;
wire [31:0] VRG13;
wire [31:0] VRG14;
wire [31:0] VRG15;
wire [31:0] VRG16;
wire [31:0] VRG17;

// Internal version of virtual registers (AHB 1).
wire [31:0] iVRG10;
wire [31:0] iVRG11;
wire [31:0] iVRG12;
wire [31:0] iVRG13;

// Virtual registers (AHB 2).
wire [31:0] VRG20;
wire [31:0] VRG21;
wire [31:0] VRG22;
wire [31:0] VRG23;
wire [31:0] VRG24;
wire [31:0] VRG25;
wire [31:0] VRG26;
wire [31:0] VRG27;

// Internal version of virtual registers (AHB 2).
wire [31:0] iVRG20;
wire [31:0] iVRG21;
wire [31:0] iVRG22;
wire [31:0] iVRG23;

// Virtual registers (AHB 3).
wire [31:0] VRG30;
wire [31:0] VRG31;
wire [31:0] VRG32;
wire [31:0] VRG33;
wire [31:0] VRG34;
wire [31:0] VRG35;
wire [31:0] VRG36;
wire [31:0] VRG37;

// Internal version of virtual registers (AHB 3).
wire [31:0] iVRG30;
wire [31:0] iVRG31;
wire [31:0] iVRG32;
wire [31:0] iVRG33;

// MPMC Register Interface Response signals.
wire        HREADYOutMCReg;
wire  [1:0] HRESPOutMCReg;
wire [63:0] HRDATAOutMCReg;
wire [63:0] iHRDATAOutMCReg;

// MPMC Response signals for AHB 0. 
wire        HREADYOutMpmc0;
wire  [1:0] HRESPOutMpmc0;
wire [63:0] HRDATAOutMpmc0;
wire [63:0] iHRDATAOutMpmc0;

// MPMC Trickbox Response signals for AHB 0.
wire        HREADYOutMCTr0;
wire  [1:0] HRESPOutMCTr0;
wire [63:0] HRDATAOutMCTr0;
wire [63:0] iHRDATAOutMCTr0;

// MPMC Response signals for AHB 1. 
wire        HREADYOutMpmc1;
wire  [1:0] HRESPOutMpmc1;
wire [63:0] HRDATAOutMpmc1;
wire [63:0] iHRDATAOutMpmc1;

// MPMC Trickbox Response signals for AHB 1.
wire        HREADYOutMCTr1;
wire  [1:0] HRESPOutMCTr1;
wire [63:0] HRDATAOutMCTr1;
wire [63:0] iHRDATAOutMCTr1;

// MPMC Response signals for AHB 2. 
wire        HREADYOutMpmc2;
wire  [1:0] HRESPOutMpmc2;
wire [63:0] HRDATAOutMpmc2;
wire [63:0] iHRDATAOutMpmc2;

// MPMC Trickbox Response signals for AHB 2.
wire        HREADYOutMCTr2;
wire  [1:0] HRESPOutMCTr2;
wire [63:0] HRDATAOutMCTr2;
wire [63:0] iHRDATAOutMCTr2;

// MPMC Response signals for AHB 3. 
wire        HREADYOutMpmc3;
wire  [1:0] HRESPOutMpmc3;
wire [63:0] HRDATAOutMpmc3;
wire [63:0] iHRDATAOutMpmc3;

// MPMC Trickbox Response signals for AHB 3.
wire        HREADYOutMCTr3;
wire  [1:0] HRESPOutMCTr3;
wire [63:0] HRDATAOutMCTr3;
wire [63:0] iHRDATAOutMCTr3;

// MPMC TrickMem0 Response signals.
wire        HREADYOutTrMem0;
wire  [1:0] HRESPOutTrMem0;
wire [63:0] HRDATAOutTrMem0;
wire [63:0] iHRDATAOutTrMem0;

// MPMC TrickMem1 Response signals.
wire        HREADYOutTrMem1;
wire  [1:0] HRESPOutTrMem1;
wire [63:0] HRDATAOutTrMem1;
wire [63:0] iHRDATAOutTrMem1;

// MPMC TrickMem2 Response signals.
wire        HREADYOutTrMem2;
wire  [1:0] HRESPOutTrMem2;
wire [63:0] HRDATAOutTrMem2;
wire [63:0] iHRDATAOutTrMem2;

// MPMC TrickMem3 Response signals.
wire        HREADYOutTrMem3;
wire  [1:0] HRESPOutTrMem3;
wire [63:0] HRDATAOutTrMem3;
wire [63:0] iHRDATAOutTrMem3;

// Scan Ports of MPMC.
wire        SCANENABLE;
wire        SCANINHCLK;
wire        SCANINMPMCCLK;
wire        SCANINCLKDELAY;
wire        SCANINFBCLKIN0;
wire        SCANINFBCLKIN1;
wire        SCANINFBCLKIN2;
wire        SCANINFBCLKIN3;
wire        SCANOUTHCLK;
wire        SCANOUTMPMCCLK;
wire        SCANOUTCLKDELAY;
wire        SCANOUTFBCLKIN0;
wire        SCANOUTFBCLKIN1;
wire        SCANOUTFBCLKIN2;
wire        SCANOUTFBCLKIN3;

// -----------------------------------------------------------------------------
// Mpmc Signal declarations
// -----------------------------------------------------------------------------

// AHB Bus0 signals.
wire        HWRITE0;
wire [2:0]  HSIZE0;
wire [2:0]  HBURST0;
wire [3:0]  HPROT0;
wire [1:0]  HTRANS0;
wire [1:0]  HRESP0;
wire        HREADY0;
wire [31:0] HADDR0;
wire [63:0] HRDATA0;
wire [63:0] HWDATA0;
wire [15:0] HSPLIT0;
wire [3:0]  HMASTER0;
wire        HMASTLOCK0;

// AHB Bus1 signals.
wire        HWRITE1;
wire [2:0]  HSIZE1;
wire [2:0]  HBURST1;
wire [3:0]  HPROT1;
wire [1:0]  HTRANS1;
wire [1:0]  HRESP1;
wire        HREADY1;
wire [31:0] HADDR1;
wire [63:0] HRDATA1;
wire [63:0] HWDATA1;
wire [15:0] HSPLIT1;
wire [3:0]  HMASTER1;
wire        HMASTLOCK1;

// AHB Bus2 signals.
wire        HWRITE2;
wire [2:0]  HSIZE2;
wire [2:0]  HBURST2;
wire [3:0]  HPROT2;
wire [1:0]  HTRANS2;
wire [1:0]  HRESP2;
wire        HREADY2;
wire [31:0] HADDR2;
wire [63:0] HRDATA2;
wire [63:0] HWDATA2;
wire [15:0] HSPLIT2;
wire [3:0]  HMASTER2;
wire        HMASTLOCK2;

// AHB Bus3 signals.
wire        HWRITE3;
wire [2:0]  HSIZE3;
wire [2:0]  HBURST3;
wire [3:0]  HPROT3;
wire [1:0]  HTRANS3;
wire [1:0]  HRESP3;
wire        HREADY3;
wire [31:0] HADDR3;
wire [63:0] HRDATA3;
wire [63:0] HWDATA3;
wire [15:0] HSPLIT3;
wire [3:0]  HMASTER3;
wire        HMASTLOCK3;

// Default Slave signals for AHB Bus0.
wire        HREADYOutDef0;
wire [63:0] HRDATAOutDef0;
wire  [1:0] HRESPOutDef0;

wire        DefSlaveSel0;
reg         DelDefSel0;

// Default Slave signals for AHB Bus1.
wire        HREADYOutDef1;
wire [63:0] HRDATAOutDef1;
wire  [1:0] HRESPOutDef1;

wire        DefSlaveSel1;
reg         DelDefSel1;

// Default Slave signals for AHB Bus2.
wire        HREADYOutDef2;
wire [63:0] HRDATAOutDef2;
wire  [1:0] HRESPOutDef2;

wire        DefSlaveSel2;
reg         DelDefSel2;

// Default Slave signals for AHB Bus3.
wire        HREADYOutDef3;
wire [63:0] HRDATAOutDef3;
wire  [1:0] HRESPOutDef3;

wire        DefSlaveSel3;
reg         DelDefSel3;

// Decoder Signals
wire [8:0]  HSEL0;
reg  [8:0]  DelHSEL0;
wire [8:0]  HSEL1;
reg  [8:0]  DelHSEL1;
wire [8:0]  HSEL2;
reg  [8:0]  DelHSEL2;
wire [15:0] HSEL3;
reg  [15:0] DelHSEL3;

// MUX Bus signals for AHB Bus0.
wire        HREADY0MUX;
wire  [1:0] HRESP0MUX;
wire [63:0] HRDATA0MUX;

// OR Bus signals for AHB Bus0.
wire        HREADY0OR;
wire  [1:0] HRESP0OR;
wire [63:0] HRDATA0OR;

// MUX Bus signals for AHB Bus1.
wire        HREADY1MUX;
wire  [1:0] HRESP1MUX;
wire [63:0] HRDATA1MUX;

// OR Bus signals for AHB Bus1.
wire        HREADY1OR;
wire  [1:0] HRESP1OR;
wire [63:0] HRDATA1OR;

// MUX Bus signals for AHB Bus2.
wire        HREADY2MUX;
wire  [1:0] HRESP2MUX;
wire [63:0] HRDATA2MUX;

// OR Bus signals for AHB Bus2.
wire        HREADY2OR;
wire  [1:0] HRESP2OR;
wire [63:0] HRDATA2OR;

// MUX Bus signals for AHB Bus3.
wire        HREADY3MUX;
wire  [1:0] HRESP3MUX;
wire [63:0] HRDATA3MUX;

// OR Bus signals for AHB Bus3.
wire        HREADY3OR;
wire  [1:0] HRESP3OR;
wire [63:0] HRDATA3OR;

// AHB Bus0 Arbitration signals.
wire        HLOCK0;
wire        HBUSREQ0;
wire        HGRANT0;

// AHB Bus1 Arbitration signals.
wire        HLOCK1;
wire        HBUSREQ1;
wire        HGRANT1;

// AHB Bus2 Arbitration signals.
wire        HLOCK2;
wire        HBUSREQ2;
wire        HGRANT2;

// AHB Bus3 Arbitration signals.
wire        HLOCK3;
wire        HBUSREQ3;
wire        HGRANT3;

// MPMC Signals
wire        MPMCCLK;
wire        MPMCCLKDELAY;
wire        MPMCFBCLKIN0;
wire        MPMCFBCLKIN1;
wire        MPMCFBCLKIN2;
wire        MPMCFBCLKIN3;
wire        nPOR;
wire        MPMCWAITIN;
wire [31:0] MPMCDATAIN;
wire        MPMCSREFACK;
wire        MPMCBIGENDIAN;
wire [1:0]  MPMCSTCS1MW;
wire        MPMCSTCS0POL;
wire        MPMCSTCS1POL;
wire        MPMCSTCS2POL;
wire        MPMCSTCS3POL;
wire        MPMCSTCS1PB;
wire        MPMCREL1CONFIG;
wire [3:0]  MPMCCLKOUT;
wire [3:0]  DelMPMCCLKOUT;
wire [3:0]  MPMCCKEOUT;
wire [3:0]  MPMCDQMOUT;
wire [3:0]  nMPMCBLSOUT;
wire        nMPMCRASOUT;
wire        nMPMCCASOUT;
wire        nMPMCOEOUT;
wire        nMPMCWEOUT;
wire [3:0]  nMPMCSTCSOUT;
wire [3:0]  nMPMCDYCSOUT;
wire [27:0] MPMCADDROUT;
wire [31:0] MPMCDATAOUT;
wire [31:0] MPMCDATA;
wire        nMPMCRPOUT;
wire        MPMCRPVHHOUT;
wire        MPMCSREFREQ;
wire [3:0]  nMPMCDATAEN;
wire [7:0]  MPMCACTLOWCS;
wire [7:0]  MPMCTrAllCS;
wire        HSELMPMC0G;
wire        HSELMPMC1G;
wire        HSELMPMC2G;
wire        HSELMPMC3G;

// EBI Related signals
wire        MPMCEBIREQ;
wire        MPMCEBIGNT;
wire        MPMCEBIBACKOFF;

// TIC Signals
wire [31:0] HRDATATIC;
wire        HREADYINTIC;
wire        HGRANTTIC;
wire [1:0]  HRESPTIC;
wire        HWRITETIC;
wire [1:0]  HTRANSTIC;
wire [2:0]  HSIZETIC;
wire [2:0]  HBURSTTIC;
wire        HLOCKTIC;
wire [3:0]  HPROTTIC;
wire        HBUSREQTIC;
wire [31:0] HADDRTIC;
wire [31:0] HWDATATIC;
wire        MPMCTESTIN;
wire        MPMCTESTREQA;
wire        MPMCTESTREQB;

// Trickbox signals
wire [9:0]  MPMCTrStExtWt;
wire [3:0]  MPMCDQMBLS;

wire        nWP;
wire        nRP;
wire        BHE;
wire        nRST;
wire        nWAIT;
wire        CLK;
wire        nADV; 
wire        VPP;
wire [13:0] MemAddrConcat;
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Disable Rel1 type of address shifting
// -----------------------------------------------------------------------------
assign MPMCREL1CONFIG   = 1'b0;
// -----------------------------------------------------------------------------
// VRGs (AHB0)
// -----------------------------------------------------------------------------
assign iVRG00           = VRG00;
assign iVRG01           = VRG01;
assign iVRG02           = VRG02;
assign iVRG03           = VRG03;

assign VRG04            = iVRG00;
assign VRG05            = iVRG01;
assign VRG07            = iVRG03;
assign VRG06            = iVRG02;

// -----------------------------------------------------------------------------
// VRGs (AHB1)
// -----------------------------------------------------------------------------
assign iVRG10           = VRG10;
assign iVRG11           = VRG11;
assign iVRG12           = VRG12;
assign iVRG13           = VRG13;

assign VRG14            = iVRG10;
assign VRG15            = iVRG11;
assign VRG17            = iVRG13;
assign VRG16            = iVRG12;

// -----------------------------------------------------------------------------
// VRGs (AHB2)
// -----------------------------------------------------------------------------
assign iVRG20           = VRG20;
assign iVRG21           = VRG21;
assign iVRG22           = VRG22;
assign iVRG23           = VRG23;

assign VRG24            = iVRG20;
assign VRG25            = iVRG21;
assign VRG27            = iVRG23;
assign VRG26            = iVRG22;

// -----------------------------------------------------------------------------
// VRGs (AHB3)
// -----------------------------------------------------------------------------
assign iVRG30           = VRG30;
assign iVRG31           = VRG31;
assign iVRG32           = VRG32;
assign iVRG33           = VRG33;

assign VRG34            = iVRG30;
assign VRG35            = iVRG31;
assign VRG37            = iVRG33;
assign VRG36            = iVRG32;

// -----------------------------------------------------------------------------
//  Assigning HLOCKx to '0'
// -----------------------------------------------------------------------------
assign HLOCK0           = 1'b0;
assign HLOCK1           = 1'b0;
assign HLOCK2           = 1'b0;
assign HLOCK3           = 1'b0;

// -----------------------------------------------------------------------------
//  Assigning HGRANTx to '1'
// -----------------------------------------------------------------------------
assign HGRANT0          = 1'b1;
assign HGRANT1          = 1'b1;
assign HGRANT2          = 1'b1;
assign HGRANT3          = 1'b1;

assign MPMCTESTIN       = 1'b0;
assign MPMCTESTREQA     = 1'b0;
assign MPMCTESTREQB     = 1'b0;

// -----------------------------------------------------------------------------
//  AHB BUS0 CONFIGURATION
// -----------------------------------------------------------------------------
assign HREADY0          = (`ORBUS == 1'b1) ? HREADY0OR : HREADY0MUX;

assign HRESP0           = (`ORBUS == 1'b1) ? HRESP0OR : HRESP0MUX;

assign HSPLIT0          = 16'h0000;

assign HRDATA0          = (`ORBUS == 1'b1) ? HRDATA0OR : HRDATA0MUX;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested 
// -----------------------------------------------------------------------------
assign iHRDATAOutMpmc0  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMpmc0[31:0]} :
                            HRDATAOutMpmc0;

assign iHRDATAOutMCTr0  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMCTr0[31:0]} :
                            HRDATAOutMCTr0;

// -----------------------------------------------------------------------------
// For MUX-bus implementations
// When the HGRANT of the corresponding bus stays with the Mpmc,
// the HSEL1 for the trickbox is generated. Otherwise it points to the
// default slave on AHB Bus1.
// -----------------------------------------------------------------------------
assign HREADY0MUX       = (DelHSEL0[0] == 1'b1) ? HREADYOutMpmc0 :
                          (DelHSEL0[1] == 1'b1) ? HREADYOutMpmc0 :
                          (DelHSEL0[2] == 1'b1) ? HREADYOutMpmc0 :
                          (DelHSEL0[3] == 1'b1) ? HREADYOutMpmc0 :
                          (DelHSEL0[4] == 1'b1) ? HREADYOutMpmc0 :
                          (DelHSEL0[5] == 1'b1) ? HREADYOutMpmc0 :
                          (DelHSEL0[6] == 1'b1) ? HREADYOutMpmc0 :
                          (DelHSEL0[7] == 1'b1) ? HREADYOutMpmc0 :
                          (DelHSEL0[8] == 1'b1) ? HREADYOutMCTr0 :
                          (DelDefSel0 == 1'b1)  ? HREADYOutDef0  : 1'b0;

assign HRESP0MUX        = (DelHSEL0[0] == 1'b1) ? HRESPOutMpmc0 :
                          (DelHSEL0[1] == 1'b1) ? HRESPOutMpmc0 :
                          (DelHSEL0[2] == 1'b1) ? HRESPOutMpmc0 :
                          (DelHSEL0[3] == 1'b1) ? HRESPOutMpmc0 :
                          (DelHSEL0[4] == 1'b1) ? HRESPOutMpmc0 :
                          (DelHSEL0[5] == 1'b1) ? HRESPOutMpmc0 :
                          (DelHSEL0[6] == 1'b1) ? HRESPOutMpmc0 :
                          (DelHSEL0[7] == 1'b1) ? HRESPOutMpmc0 :
                          (DelHSEL0[8] == 1'b1) ? HRESPOutMCTr0 :
                          (DelDefSel0 == 1'b1)  ? HRESPOutDef0  : 2'b00;

assign HRDATA0MUX       = (DelHSEL0[0] == 1'b1) ? iHRDATAOutMpmc0 :
                          (DelHSEL0[1] == 1'b1) ? iHRDATAOutMpmc0 :
                          (DelHSEL0[2] == 1'b1) ? iHRDATAOutMpmc0 :
                          (DelHSEL0[3] == 1'b1) ? iHRDATAOutMpmc0 :
                          (DelHSEL0[4] == 1'b1) ? iHRDATAOutMpmc0 :
                          (DelHSEL0[5] == 1'b1) ? iHRDATAOutMpmc0 :
                          (DelHSEL0[6] == 1'b1) ? iHRDATAOutMpmc0 :
                          (DelHSEL0[7] == 1'b1) ? iHRDATAOutMpmc0 :
                          (DelHSEL0[8] == 1'b1) ? iHRDATAOutMCTr0 :
                          (DelDefSel0 == 1'b1) ? HRDATAOutDef0 :
                           64'h0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus implementations
// -----------------------------------------------------------------------------
assign HRESP0OR         = HRESPOutMpmc0 | HRESPOutMCTr0 | HRESPOutDef0;

assign HREADY0OR        = HREADYOutMpmc0 | HREADYOutMCTr0 | HREADYOutDef0;

assign HRDATA0OR        = iHRDATAOutMpmc0 | iHRDATAOutMCTr0 | HRDATAOutDef0;

// -----------------------------------------------------------------------------
// Generating HSEL0
// -----------------------------------------------------------------------------
assign HSEL0[0]         = ((`MPMC00LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MPMC00HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL0[1]         = ((`MPMC01LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MPMC01HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL0[2]         = ((`MPMC02LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MPMC02HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL0[3]         = ((`MPMC03LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MPMC03HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL0[4]         = ((`MPMC04LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MPMC04HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL0[5]         = ((`MPMC05LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MPMC05HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL0[6]         = ((`MPMC06LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MPMC06HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL0[7]         = ((`MPMC07LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MPMC07HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL0[8]         = ((`MCTR0LOWADDRRANGE <= HADDR0) &
                           (HADDR0 <= `MCTR0HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign DefSlaveSel0     = ((HSEL0[0] | HSEL0[1] | HSEL0[2] | HSEL0[3] |
                            HSEL0[4] | HSEL0[5] | HSEL0[6] | HSEL0[7] |
                            HSEL0[8]) != 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Latching HSEL0
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelHSEL0Seq
  if (HRESETn == 1'b0)
    begin
      DelHSEL0   <= 9'b000000000;
      DelDefSel0 <= 1'b1;
    end
  else if (HREADY0 == 1'b1)
    begin
      DelHSEL0   <= HSEL0;
      DelDefSel0 <= DefSlaveSel0;
    end
end // p_DelHSEL0Seq
 
// -----------------------------------------------------------------------------
//  AHB BUS1 CONFIGURATION
// -----------------------------------------------------------------------------
assign HREADY1          = (`ORBUS == 1'b1) ? HREADY1OR : HREADY1MUX;

assign HRESP1           = (`ORBUS == 1'b1) ? HRESP1OR : HRESP1MUX;

assign HSPLIT1          = 16'h0000;

assign HRDATA1          = (`ORBUS == 1'b1) ? HRDATA1OR : HRDATA1MUX;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested 
// -----------------------------------------------------------------------------
assign iHRDATAOutMpmc1  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMpmc1[31:0]} :
                            HRDATAOutMpmc1;

assign iHRDATAOutMCTr1  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMCTr1[31:0]} :
                            HRDATAOutMCTr1;

// -----------------------------------------------------------------------------
// For MUX-bus implementations
// When the HGRANT of the corresponding bus stays with the Mpmc,
// the HSEL1 for the trickbox is generated. Otherwise it points to the
// default slave on AHB Bus1.
// -----------------------------------------------------------------------------
assign HREADY1MUX       = (DelHSEL1[0] == 1'b1) ? HREADYOutMpmc1 :
                          (DelHSEL1[1] == 1'b1) ? HREADYOutMpmc1 :
                          (DelHSEL1[2] == 1'b1) ? HREADYOutMpmc1 :
                          (DelHSEL1[3] == 1'b1) ? HREADYOutMpmc1 :
                          (DelHSEL1[4] == 1'b1) ? HREADYOutMpmc1 :
                          (DelHSEL1[5] == 1'b1) ? HREADYOutMpmc1 :
                          (DelHSEL1[6] == 1'b1) ? HREADYOutMpmc1 :
                          (DelHSEL1[7] == 1'b1) ? HREADYOutMpmc1 :
                          (DelHSEL1[8] == 1'b1) ? HREADYOutMCTr1 :
                          (DelDefSel1 == 1'b1)  ? HREADYOutDef1  : 1'b0;

assign HRESP1MUX        = (DelHSEL1[0] == 1'b1) ? HRESPOutMpmc1 :
                          (DelHSEL1[1] == 1'b1) ? HRESPOutMpmc1 :
                          (DelHSEL1[2] == 1'b1) ? HRESPOutMpmc1 :
                          (DelHSEL1[3] == 1'b1) ? HRESPOutMpmc1 :
                          (DelHSEL1[4] == 1'b1) ? HRESPOutMpmc1 :
                          (DelHSEL1[5] == 1'b1) ? HRESPOutMpmc1 :
                          (DelHSEL1[6] == 1'b1) ? HRESPOutMpmc1 :
                          (DelHSEL1[7] == 1'b1) ? HRESPOutMpmc1 :
                          (DelHSEL1[8] == 1'b1) ? HRESPOutMCTr1 :
                          (DelDefSel1 == 1'b1)  ? HRESPOutDef1  : 2'b00;

assign HRDATA1MUX       = (DelHSEL1[0] == 1'b1) ? iHRDATAOutMpmc1 :
                          (DelHSEL1[1] == 1'b1) ? iHRDATAOutMpmc1 :
                          (DelHSEL1[2] == 1'b1) ? iHRDATAOutMpmc1 :
                          (DelHSEL1[3] == 1'b1) ? iHRDATAOutMpmc1 :
                          (DelHSEL1[4] == 1'b1) ? iHRDATAOutMpmc1 :
                          (DelHSEL1[5] == 1'b1) ? iHRDATAOutMpmc1 :
                          (DelHSEL1[6] == 1'b1) ? iHRDATAOutMpmc1 :
                          (DelHSEL1[7] == 1'b1) ? iHRDATAOutMpmc1 :
                          (DelHSEL1[8] == 1'b1) ? iHRDATAOutMCTr1 :
                          (DelDefSel1 == 1'b1) ? HRDATAOutDef1 :
                           64'h0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus implementations
// -----------------------------------------------------------------------------
assign HRESP1OR         = HRESPOutMpmc1 | HRESPOutMCTr1 | HRESPOutDef1;

assign HREADY1OR        = HREADYOutMpmc1 | HREADYOutMCTr1 | HREADYOutDef1;

assign HRDATA1OR        = iHRDATAOutMpmc1 | iHRDATAOutMCTr1 | HRDATAOutDef1;

// -----------------------------------------------------------------------------
// Generating HSEL1
// -----------------------------------------------------------------------------
assign HSEL1[0]         = ((`MPMC10LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MPMC10HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL1[1]         = ((`MPMC11LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MPMC11HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL1[2]         = ((`MPMC12LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MPMC12HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL1[3]         = ((`MPMC13LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MPMC13HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL1[4]         = ((`MPMC14LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MPMC14HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL1[5]         = ((`MPMC15LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MPMC15HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL1[6]         = ((`MPMC16LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MPMC16HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL1[7]         = ((`MPMC17LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MPMC17HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL1[8]         = ((`MCTR1LOWADDRRANGE <= HADDR1) &
                           (HADDR1 <= `MCTR1HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign DefSlaveSel1     = ((HSEL1[0] | HSEL1[1] | HSEL1[2] | HSEL1[3] |
                            HSEL1[4] | HSEL1[5] | HSEL1[6] | HSEL1[7] |
                            HSEL1[8]) != 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Latching HSEL1
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelHSEL1Seq
  if (HRESETn == 1'b0)
    begin
      DelHSEL1   <= 9'b000000000;
      DelDefSel1 <= 1'b1;
    end
  else if (HREADY1 == 1'b1)
    begin
      DelHSEL1   <= HSEL1;
      DelDefSel1 <= DefSlaveSel1;
    end
end // p_DelHSEL1Seq
 
// -----------------------------------------------------------------------------
//  AHB BUS2 CONFIGURATION
// -----------------------------------------------------------------------------
assign HREADY2          = (`ORBUS == 1'b1) ? HREADY2OR : HREADY2MUX;

assign HRESP2           = (`ORBUS == 1'b1) ? HRESP2OR : HRESP2MUX;

assign HSPLIT2          = 16'h0000;

assign HRDATA2          = (`ORBUS == 1'b1) ? HRDATA2OR : HRDATA2MUX;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested 
// -----------------------------------------------------------------------------
assign iHRDATAOutMpmc2  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMpmc2[31:0]} :
                            HRDATAOutMpmc2;

assign iHRDATAOutMCTr2  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMCTr2[31:0]} :
                            HRDATAOutMCTr2;

// -----------------------------------------------------------------------------
// For MUX-bus implementations
// When the HGRANT of the corresponding bus stays with the Mpmc,
// the HSEL2 for the trickbox is generated. Otherwise it points to the
// default slave on AHB Bus2.
// -----------------------------------------------------------------------------
assign HREADY2MUX       = (DelHSEL2[0] == 1'b1) ? HREADYOutMpmc2 :
                          (DelHSEL2[1] == 1'b1) ? HREADYOutMpmc2 :
                          (DelHSEL2[2] == 1'b1) ? HREADYOutMpmc2 :
                          (DelHSEL2[3] == 1'b1) ? HREADYOutMpmc2 :
                          (DelHSEL2[4] == 1'b1) ? HREADYOutMpmc2 :
                          (DelHSEL2[5] == 1'b1) ? HREADYOutMpmc2 :
                          (DelHSEL2[6] == 1'b1) ? HREADYOutMpmc2 :
                          (DelHSEL2[7] == 1'b1) ? HREADYOutMpmc2 :
                          (DelHSEL2[8] == 1'b1) ? HREADYOutMCTr2 :
                          (DelDefSel2 == 1'b1)  ? HREADYOutDef2  : 1'b0;

assign HRESP2MUX        = (DelHSEL2[0] == 1'b1) ? HRESPOutMpmc2 :
                          (DelHSEL2[1] == 1'b1) ? HRESPOutMpmc2 :
                          (DelHSEL2[2] == 1'b1) ? HRESPOutMpmc2 :
                          (DelHSEL2[3] == 1'b1) ? HRESPOutMpmc2 :
                          (DelHSEL2[4] == 1'b1) ? HRESPOutMpmc2 :
                          (DelHSEL2[5] == 1'b1) ? HRESPOutMpmc2 :
                          (DelHSEL2[6] == 1'b1) ? HRESPOutMpmc2 :
                          (DelHSEL2[7] == 1'b1) ? HRESPOutMpmc2 :
                          (DelHSEL2[8] == 1'b1) ? HRESPOutMCTr2 :
                          (DelDefSel2 == 1'b1)  ? HRESPOutDef2  : 2'b00;

assign HRDATA2MUX       = (DelHSEL2[0] == 1'b1) ? iHRDATAOutMpmc2 :
                          (DelHSEL2[1] == 1'b1) ? iHRDATAOutMpmc2 :
                          (DelHSEL2[2] == 1'b1) ? iHRDATAOutMpmc2 :
                          (DelHSEL2[3] == 1'b1) ? iHRDATAOutMpmc2 :
                          (DelHSEL2[4] == 1'b1) ? iHRDATAOutMpmc2 :
                          (DelHSEL2[5] == 1'b1) ? iHRDATAOutMpmc2 :
                          (DelHSEL2[6] == 1'b1) ? iHRDATAOutMpmc2 :
                          (DelHSEL2[7] == 1'b1) ? iHRDATAOutMpmc2 :
                          (DelHSEL2[8] == 1'b1) ? iHRDATAOutMCTr2 :
                          (DelDefSel2 == 1'b1) ? HRDATAOutDef2 :
                           64'h0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus implementations
// -----------------------------------------------------------------------------
assign HRESP2OR         = HRESPOutMpmc2 | HRESPOutMCTr2 | HRESPOutDef2;

assign HREADY2OR        = HREADYOutMpmc2 | HREADYOutMCTr2 | HREADYOutDef2;

assign HRDATA2OR        = iHRDATAOutMpmc2 | iHRDATAOutMCTr2 | HRDATAOutDef2;

// -----------------------------------------------------------------------------
// Generating HSEL2
// -----------------------------------------------------------------------------
assign HSEL2[0]         = ((`MPMC20LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MPMC20HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL2[1]         = ((`MPMC21LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MPMC21HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL2[2]         = ((`MPMC22LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MPMC22HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL2[3]         = ((`MPMC23LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MPMC23HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL2[4]         = ((`MPMC24LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MPMC24HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL2[5]         = ((`MPMC25LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MPMC25HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL2[6]         = ((`MPMC26LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MPMC26HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL2[7]         = ((`MPMC27LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MPMC27HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign HSEL2[8]         = ((`MCTR2LOWADDRRANGE <= HADDR2) &
                           (HADDR2 <= `MCTR2HIGHADDRRANGE)) ? 1'b1 : 1'b0;

assign DefSlaveSel2     = ((HSEL2[0] | HSEL2[1] | HSEL2[2] | HSEL2[3] |
                            HSEL2[4] | HSEL2[5] | HSEL2[6] | HSEL2[7] |
                            HSEL2[8]) != 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Latching HSEL2
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelHSEL2Seq
  if (HRESETn == 1'b0)
    begin
      DelHSEL2   <= 9'b000000000;
      DelDefSel2 <= 1'b1;
    end
  else if (HREADY2 == 1'b1)
    begin
      DelHSEL2   <= HSEL2;
      DelDefSel2 <= DefSlaveSel2;
    end
end // p_DelHSEL2Seq
 
// -----------------------------------------------------------------------------
//  AHB BUS3 CONFIGURATION
// The slave interfaces of the Mpmc, Trickbox and TrickMem (4 instances) are
// connected to this bus.
// -----------------------------------------------------------------------------
assign HREADY3          = (`ORBUS == 1'b1) ? HREADY3OR : HREADY3MUX;

assign HRESP3           = (`ORBUS == 1'b1) ? HRESP3OR : HRESP3MUX;

assign HSPLIT3          = 16'h0000;

assign HRDATA3          = (`ORBUS == 1'b1) ? HRDATA3OR : HRDATA3MUX;

// -----------------------------------------------------------------------------
// Connect all the scan inputs to '0' to prevent interference with
// functional mode tests.
// -----------------------------------------------------------------------------
assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested 
// -----------------------------------------------------------------------------
assign iHRDATAOutMpmc3  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMpmc3[31:0]} :
                           HRDATAOutMpmc3;

assign HRDATAOutMCReg[31:21] = 11'b00000000000;

assign iHRDATAOutMCReg  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMCReg[31:0]} :
                           HRDATAOutMCReg;

assign iHRDATAOutMCTr3  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutMCTr3[31:0]} :
                           HRDATAOutMCTr3;

assign iHRDATAOutTrMem0 = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutTrMem0[31:0]} :
                           HRDATAOutTrMem0;

assign iHRDATAOutTrMem1 = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutTrMem1[31:0]} :
                           HRDATAOutTrMem1;

assign iHRDATAOutTrMem2 = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutTrMem2[31:0]} :
                           HRDATAOutTrMem2;

assign iHRDATAOutTrMem3 = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutTrMem3[31:0]} :
                           HRDATAOutTrMem3;

// -----------------------------------------------------------------------------
// For MUX-bus implementations
// -----------------------------------------------------------------------------
assign HREADY3MUX       = (DelHSEL3[0] == 1'b1)  ? HREADYOutMpmc3  :
                          (DelHSEL3[1] == 1'b1)  ? HREADYOutMpmc3  :
                          (DelHSEL3[2] == 1'b1)  ? HREADYOutMpmc3  :
                          (DelHSEL3[3] == 1'b1)  ? HREADYOutMpmc3  :
                          (DelHSEL3[4] == 1'b1)  ? HREADYOutMpmc3  :
                          (DelHSEL3[5] == 1'b1)  ? HREADYOutMpmc3  :
                          (DelHSEL3[6] == 1'b1)  ? HREADYOutMpmc3  :
                          (DelHSEL3[7] == 1'b1)  ? HREADYOutMpmc3  :
                          (DelHSEL3[8] == 1'b1)  ? HREADYOutMCReg  :
                          (DelHSEL3[9] == 1'b1)  ? HREADYOutMCTr3  :
                          (DelHSEL3[10] == 1'b1) ? HREADYOutTrMem0 :
                          (DelHSEL3[11] == 1'b1) ? HREADYOutTrMem1 :
                          (DelHSEL3[12] == 1'b1) ? HREADYOutTrMem2 :
                          (DelHSEL3[13] == 1'b1) ? HREADYOutTrMem3 :
                          (DelDefSel3 == 1'b1)   ? HREADYOutDef3   : 1'b0;

assign HRESP3MUX        = (DelHSEL3[0] == 1'b1)  ? HRESPOutMpmc3  :
                          (DelHSEL3[1] == 1'b1)  ? HRESPOutMpmc3  :
                          (DelHSEL3[2] == 1'b1)  ? HRESPOutMpmc3  :
                          (DelHSEL3[3] == 1'b1)  ? HRESPOutMpmc3  :
                          (DelHSEL3[4] == 1'b1)  ? HRESPOutMpmc3  :
                          (DelHSEL3[5] == 1'b1)  ? HRESPOutMpmc3  :
                          (DelHSEL3[6] == 1'b1)  ? HRESPOutMpmc3  :
                          (DelHSEL3[7] == 1'b1)  ? HRESPOutMpmc3  :
                          (DelHSEL3[8] == 1'b1)  ? HRESPOutMCReg  :
                          (DelHSEL3[9] == 1'b1)  ? HRESPOutMCTr3  :
                          (DelHSEL3[10] == 1'b1) ? HRESPOutTrMem0 :
                          (DelHSEL3[11] == 1'b1) ? HRESPOutTrMem1 :
                          (DelHSEL3[12] == 1'b1) ? HRESPOutTrMem2 :
                          (DelHSEL3[13] == 1'b1) ? HRESPOutTrMem3 :
                          (DelDefSel3 == 1'b1)   ? HRESPOutDef3   : 2'b00;

assign HRDATA3MUX       = (DelHSEL3[0] == 1'b1)  ? iHRDATAOutMpmc3  :
                          (DelHSEL3[1] == 1'b1)  ? iHRDATAOutMpmc3  :
                          (DelHSEL3[2] == 1'b1)  ? iHRDATAOutMpmc3  :
                          (DelHSEL3[3] == 1'b1)  ? iHRDATAOutMpmc3  :
                          (DelHSEL3[4] == 1'b1)  ? iHRDATAOutMpmc3  :
                          (DelHSEL3[5] == 1'b1)  ? iHRDATAOutMpmc3  :
                          (DelHSEL3[6] == 1'b1)  ? iHRDATAOutMpmc3  :
                          (DelHSEL3[7] == 1'b1)  ? iHRDATAOutMpmc3  :
                          (DelHSEL3[8] == 1'b1)  ? iHRDATAOutMCReg  :
                          (DelHSEL3[9] == 1'b1)  ? iHRDATAOutMCTr3  :
                          (DelHSEL3[10] == 1'b1) ? iHRDATAOutTrMem0 :
                          (DelHSEL3[11] == 1'b1) ? iHRDATAOutTrMem1 :
                          (DelHSEL3[12] == 1'b1) ? iHRDATAOutTrMem2 :
                          (DelHSEL3[13] == 1'b1) ? iHRDATAOutTrMem3 :
                          (DelDefSel3 == 1'b1)   ? HRDATAOutDef3    :
                          64'h0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus implementations
// -----------------------------------------------------------------------------
assign HRESP3OR         = HRESPOutMpmc3 | HRESPOutMCReg | HRESPOutMCTr3 |
                          HRESPOutTrMem0 | HRESPOutTrMem1 | HRESPOutTrMem2 |
                          HRESPOutTrMem3 | HRESPOutDef3;

assign HREADY3OR        = HREADYOutMpmc3 | HREADYOutMCReg | HREADYOutMCTr3 |
                          HREADYOutTrMem0 | HREADYOutTrMem1 | HREADYOutTrMem2 |
                          HREADYOutTrMem3 | HREADYOutDef3;

assign HRDATA3OR        = iHRDATAOutMpmc3 | iHRDATAOutMCReg | iHRDATAOutMCTr3 |
                          iHRDATAOutTrMem0 | iHRDATAOutTrMem1 |
                          iHRDATAOutTrMem2 | iHRDATAOutTrMem3 | HRDATAOutDef3;

// -----------------------------------------------------------------------------
// Latching HSEL3
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelHSEL3Seq
  if (HRESETn == 1'b0)
    begin
      DelHSEL3   <= 16'h0000;
      DelDefSel3 <= 1'b1;
    end
  else if (HREADY3 == 1'b1)
    begin
      DelHSEL3   <= HSEL3;
      DelDefSel3 <= DefSlaveSel3;
    end
end // p_DelHSEL3Seq
 
// -----------------------------------------------------------------------------
// Memory Data Bus multiplexing
// -----------------------------------------------------------------------------
assign MPMCDATA[7:0]    = (nMPMCDATAEN[0] == 1'b0) ? MPMCDATAOUT[7:0]   :
                           8'bzzzzzzzz;

assign MPMCDATA[15:8]   = (nMPMCDATAEN[1] == 1'b0) ? MPMCDATAOUT[15:8]  :
                           8'bzzzzzzzz;

assign MPMCDATA[23:16]  = (nMPMCDATAEN[2] == 1'b0) ? MPMCDATAOUT[23:16] :
                           8'bzzzzzzzz;

assign MPMCDATA[31:24]  = (nMPMCDATAEN[3] == 1'b0) ? MPMCDATAOUT[31:24] :
                           8'bzzzzzzzz;

assign MPMCDATAIN       = MPMCDATA;

assign MemReset         = HRESETn & nPOR;

assign HSELMPMC0G       = HSEL0[7] | HSEL0[6] | HSEL0[5] | HSEL0[4] |
                          HSEL0[3] | HSEL0[2] | HSEL0[1] | HSEL0[0];

assign HSELMPMC1G       = HSEL1[7] | HSEL1[6] | HSEL1[5] | HSEL1[4] |
                          HSEL1[3] | HSEL1[2] | HSEL1[1] | HSEL1[0];

assign HSELMPMC2G       = HSEL2[7] | HSEL2[6] | HSEL2[5] | HSEL2[4] |
                          HSEL2[3] | HSEL2[2] | HSEL2[1] | HSEL2[0];

assign HSELMPMC3G       = HSEL3[7] | HSEL3[6] | HSEL3[5] | HSEL3[4] |
                          HSEL3[3] | HSEL3[2] | HSEL3[1] | HSEL3[0];

assign # 2 DelMPMCCLKOUT    = MPMCCLKOUT;

// -----------------------------------------------------------------------------
//  MPMCFBCLKIN Generation
// -----------------------------------------------------------------------------
assign # `MPMCCLKOUT_TO_MPMCFBCLKIN0_DELAY MPMCFBCLKIN0 = MPMCCLKOUT[0];
assign # `MPMCCLKOUT_TO_MPMCFBCLKIN1_DELAY MPMCFBCLKIN1 = MPMCCLKOUT[1];
assign # `MPMCCLKOUT_TO_MPMCFBCLKIN2_DELAY MPMCFBCLKIN2 = MPMCCLKOUT[2];
assign # `MPMCCLKOUT_TO_MPMCFBCLKIN3_DELAY MPMCFBCLKIN3 = MPMCCLKOUT[3];

assign MPMCDQMBLS       = MPMCDQMOUT & nMPMCBLSOUT;
assign nWP              = 1'b0;
assign nRP              = 1'b1;
assign BHE              = 1'b1;
assign nRST             = 1'b1;
assign nWAIT            = 1'b1;
assign nADV             = 1'b0;
assign VPP              = 1'b1;
assign CLK              = 1'b0;
// -----------------------------------------------------------------------------
// AHB Slave Testbench_0 instantiation
// -----------------------------------------------------------------------------
defparam u0ahbslv_tb.INFILE          = "../../bustest/invec/bif0.sim";
defparam u0ahbslv_tb.Verbosity       = Verbosity;
defparam u0ahbslv_tb.HaltOnMismatch  = HaltOnMismatch;
defparam u0ahbslv_tb.XonSig          = XonSig;
defparam u0ahbslv_tb.Databuswidth    = Databuswidth;
defparam u0ahbslv_tb.SuppressOnReset = SuppressOnReset;

ahbslave_tb0 u0ahbslv_tb              (
                    .HCLK             (),
                    .HRESETn          (HRESET0n),
                    .HADDR            (HADDR0),
                    .HTRANS           (HTRANS0),
                    .HWRITE           (HWRITE0),
                    .HSIZE            (HSIZE0),
                    .HBURST           (HBURST0),
                    .HPROT            (HPROT0),
                    .HMASTER          (HMASTER0),
                    .HMASTLOCK        (HMASTLOCK0),
                    .HWDATA           (HWDATA0),
                    .HSPLIT           (HSPLIT0),
                    .HRDATA           (HRDATA0),
                    .HREADY           (HREADY0),
                    .HRESP            (HRESP0),
                    .VRG0             (VRG00),
                    .VRG1             (VRG01),
                    .VRG2             (VRG02),
                    .VRG3             (VRG03),
                    .VRG4             (VRG04),
                    .VRG5             (VRG05),
                    .VRG6             (VRG06),
                    .VRG7             (VRG07)
                    );

// -----------------------------------------------------------------------------
// AHB Slave Testbench_1 instantiation
// -----------------------------------------------------------------------------
defparam u1ahbslv_tb.INFILE          = "../../bustest/invec/bif1.sim";
defparam u1ahbslv_tb.Verbosity       = Verbosity;
defparam u1ahbslv_tb.HaltOnMismatch  = HaltOnMismatch;
defparam u1ahbslv_tb.XonSig          = XonSig;
defparam u1ahbslv_tb.Databuswidth    = Databuswidth;
defparam u1ahbslv_tb.SuppressOnReset = SuppressOnReset;

ahbslave_tb1 u1ahbslv_tb               (
                    .HCLK             (),
                    .HRESETn          (HRESET1n),
                    .HADDR            (HADDR1),
                    .HTRANS           (HTRANS1),
                    .HWRITE           (HWRITE1),
                    .HSIZE            (HSIZE1),
                    .HBURST           (HBURST1),
                    .HPROT            (HPROT1),
                    .HMASTER          (HMASTER1),
                    .HMASTLOCK        (HMASTLOCK1),
                    .HWDATA           (HWDATA1),
                    .HSPLIT           (HSPLIT1),
                    .HRDATA           (HRDATA1),
                    .HREADY           (HREADY1),
                    .HRESP            (HRESP1),
                    .VRG0             (VRG10),
                    .VRG1             (VRG11),
                    .VRG2             (VRG12),
                    .VRG3             (VRG13),
                    .VRG4             (VRG14),
                    .VRG5             (VRG15),
                    .VRG6             (VRG16),
                    .VRG7             (VRG17)
                    );

// -----------------------------------------------------------------------------
// AHB Slave Testbench_2 instantiation
// -----------------------------------------------------------------------------
defparam u2ahbslv_tb.INFILE          = "../../bustest/invec/bif2.sim";
defparam u2ahbslv_tb.Verbosity       = Verbosity;
defparam u2ahbslv_tb.HaltOnMismatch  = HaltOnMismatch;
defparam u2ahbslv_tb.XonSig          = XonSig;
defparam u2ahbslv_tb.Databuswidth    = Databuswidth;
defparam u2ahbslv_tb.SuppressOnReset = SuppressOnReset;

ahbslave_tb2 u2ahbslv_tb               (
                    .HCLK             (),
                    .HRESETn          (HRESET2n),
                    .HADDR            (HADDR2),
                    .HTRANS           (HTRANS2),
                    .HWRITE           (HWRITE2),
                    .HSIZE            (HSIZE2),
                    .HBURST           (HBURST2),
                    .HPROT            (HPROT2),
                    .HMASTER          (HMASTER2),
                    .HMASTLOCK        (HMASTLOCK2),
                    .HWDATA           (HWDATA2),
                    .HSPLIT           (HSPLIT2),
                    .HRDATA           (HRDATA2),
                    .HREADY           (HREADY2),
                    .HRESP            (HRESP2),
                    .VRG0             (VRG20),
                    .VRG1             (VRG21),
                    .VRG2             (VRG22),
                    .VRG3             (VRG23),
                    .VRG4             (VRG24),
                    .VRG5             (VRG25),
                    .VRG6             (VRG26),
                    .VRG7             (VRG27)
                    );

// -----------------------------------------------------------------------------
// AHB Slave Testbench_3 instantiation
// -----------------------------------------------------------------------------
defparam u3ahbslv_tb.INFILE          = "../../bustest/invec/bif3.sim";
defparam u3ahbslv_tb.Verbosity       = Verbosity;
defparam u3ahbslv_tb.HaltOnMismatch  = HaltOnMismatch;
defparam u3ahbslv_tb.XonSig          = XonSig;
defparam u3ahbslv_tb.Databuswidth    = Databuswidth;
defparam u3ahbslv_tb.SuppressOnReset = SuppressOnReset;

ahbslave_tb3 u3ahbslv_tb               (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR3),
                    .HTRANS           (HTRANS3),
                    .HWRITE           (HWRITE3),
                    .HSIZE            (HSIZE3),
                    .HBURST           (HBURST3),
                    .HPROT            (HPROT3),
                    .HMASTER          (HMASTER3),
                    .HMASTLOCK        (HMASTLOCK3),
                    .HWDATA           (HWDATA3),
                    .HSPLIT           (HSPLIT3),
                    .HRDATA           (HRDATA3),
                    .HREADY           (HREADY3),
                    .HRESP            (HRESP3),
                    .VRG0             (VRG30),
                    .VRG1             (VRG31),
                    .VRG2             (VRG32),
                    .VRG3             (VRG33),
                    .VRG4             (VRG34),
                    .VRG5             (VRG35),
                    .VRG6             (VRG36),
                    .VRG7             (VRG37)
                    );

// -----------------------------------------------------------------------------
// Address Decoder instantiation
// -----------------------------------------------------------------------------
decoder udecoder                      (
                    .HADDR            (HADDR3),
                    .HSEL             (HSEL3),
                    .DefSlaveSel      (DefSlaveSel3)
                    );

// -----------------------------------------------------------------------------
// Default Slave Instantiation for AHB Bus0
// -----------------------------------------------------------------------------
Defslave u0Defslave                   (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HSEL             (DefSlaveSel0),
                    .HTRANS           (HTRANS0[1]),
                    .HRESP            (HRESPOutDef0),
                    .HREADYIn         (HREADY0),
                    .HREADYOut        (HREADYOutDef0),
                    .HRDATAOut        (HRDATAOutDef0)
                    );

// -----------------------------------------------------------------------------
// Default Slave Instantiation for AHB Bus1
// -----------------------------------------------------------------------------
Defslave u1Defslave                   (
                    .HCLK             (HCLK),
                    .HSEL             (DefSlaveSel1),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS1[1]),
                    .HRESP            (HRESPOutDef1),
                    .HREADYIn         (HREADY1),
                    .HREADYOut        (HREADYOutDef1),
                    .HRDATAOut        (HRDATAOutDef1)
                    );

// -----------------------------------------------------------------------------
// Default Slave Instantiation for AHB Bus2
// -----------------------------------------------------------------------------
Defslave u2Defslave                   (
                    .HCLK             (HCLK),
                    .HSEL             (DefSlaveSel2),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS2[1]),
                    .HRESP            (HRESPOutDef2),
                    .HREADYIn         (HREADY2),
                    .HREADYOut        (HREADYOutDef2),
                    .HRDATAOut        (HRDATAOutDef2)
                    );

// -----------------------------------------------------------------------------
// Default Slave Instantiation for AHB Bus3
// -----------------------------------------------------------------------------
Defslave u3Defslave                   (
                    .HCLK             (HCLK),
                    .HSEL             (DefSlaveSel3),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS3[1]),
                    .HRESP            (HRESPOutDef3),
                    .HREADYIn         (HREADY3),
                    .HREADYOut        (HREADYOutDef3),
                    .HRDATAOut        (HRDATAOutDef3)
                    );

// -----------------------------------------------------------------------------
// Master Buswatch Instantiation (AHB0)
// -----------------------------------------------------------------------------
buswatchmaster u0buswatchmaster       (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESET0n),
                    .HTRANS           (HTRANS0),
                    .HADDR            (HADDR0),
                    .HSIZE            (HSIZE0),
                    .HBURST           (HBURST0),
                    .HBUSREQx         (HBUSREQ0),
                    .HGRANTx          (HGRANT0),
                    .HREADY           (HREADY0),
                    .HLOCKx           (HLOCK0),
                    .HWDATA           (HWDATA0),
                    .HPROT            (HPROT0),
                    .HWRITE           (HWRITE0),
                    .HRESP            (HRESP0),
                    .ResetOver        ()
                    );

// -----------------------------------------------------------------------------
// Master Buswatch Instantiation (AHB1)
// -----------------------------------------------------------------------------
buswatchmaster u1buswatchmaster       (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESET1n),
                    .HTRANS           (HTRANS1),
                    .HADDR            (HADDR1),
                    .HSIZE            (HSIZE1),
                    .HBURST           (HBURST1),
                    .HBUSREQx         (HBUSREQ1),
                    .HGRANTx          (HGRANT1),
                    .HREADY           (HREADY1),
                    .HLOCKx           (HLOCK1),
                    .HWDATA           (HWDATA1),
                    .HPROT            (HPROT1),
                    .HWRITE           (HWRITE1),
                    .HRESP            (HRESP1),
                    .ResetOver        ()
                    );

// -----------------------------------------------------------------------------
// Master Buswatch Instantiation (AHB2)
// -----------------------------------------------------------------------------
buswatchmaster u2buswatchmaster       (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESET2n),
                    .HTRANS           (HTRANS2),
                    .HADDR            (HADDR2),
                    .HSIZE            (HSIZE2),
                    .HBURST           (HBURST2),
                    .HBUSREQx         (HBUSREQ2),
                    .HGRANTx          (HGRANT2),
                    .HREADY           (HREADY2),
                    .HLOCKx           (HLOCK2),
                    .HWDATA           (HWDATA2),
                    .HPROT            (HPROT2),
                    .HWRITE           (HWRITE2),
                    .HRESP            (HRESP2),
                    .ResetOver        ()
                    );

// -----------------------------------------------------------------------------
// Master Buswatch Instantiation (AHB3)
// -----------------------------------------------------------------------------
buswatchmaster u3buswatchmaster       (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS3),
                    .HADDR            (HADDR3),
                    .HSIZE            (HSIZE3),
                    .HBURST           (HBURST3),
                    .HBUSREQx         (HBUSREQ3),
                    .HGRANTx          (HGRANT3),
                    .HREADY           (HREADY3),
                    .HLOCKx           (HLOCK3),
                    .HWDATA           (HWDATA3),
                    .HPROT            (HPROT3),
                    .HWRITE           (HWRITE3),
                    .HRESP            (HRESP3),
                    .ResetOver        ()
                    );

// -----------------------------------------------------------------------------
// Unit Under Test (MPMC)
// -----------------------------------------------------------------------------
Mpmc uut                              (
                    .HCLK             (HCLK),
                    .MPMCCLK          (MPMCCLK),
                    .MPMCCLKDELAY     (MPMCCLKDELAY),
                    .HRESETn          (HRESETn),
                    .nPOR             (nPOR),
                    .HWRITE0          (HWRITE0),
                    .MPMCFBCLKIN0     (MPMCFBCLKIN0),
                    .MPMCFBCLKIN1     (MPMCFBCLKIN1),
                    .MPMCFBCLKIN2     (MPMCFBCLKIN2),
                    .MPMCFBCLKIN3     (MPMCFBCLKIN3),
                    .HTRANS0          (HTRANS0),
                    .HSIZE0           (HSIZE0),
                    .HBURST0          (HBURST0),
                    .HREADYIN0        (HREADY0),
                    .HSELMPMC0G       (HSELMPMC0G),
                    .HSELMPMC0CS      (HSEL0[7:0]),
                    .HMASTLOCK0       (HMASTLOCK0),
                    .HADDR0           (HADDR0[27:0]),
                    .HWDATA0          (HWDATA0[31:0]),
                    .HWRITE1          (HWRITE1),
                    .HTRANS1          (HTRANS1),
                    .HSIZE1           (HSIZE1),
                    .HBURST1          (HBURST1),
                    .HREADYIN1        (HREADY1),
                    .HSELMPMC1G       (HSELMPMC1G),
                    .HSELMPMC1CS      (HSEL1[7:0]),
                    .HMASTLOCK1       (HMASTLOCK1),
                    .HADDR1           (HADDR1[27:0]),
                    .HWDATA1          (HWDATA1[31:0]),
                    .HWRITE2          (HWRITE2),
                    .HTRANS2          (HTRANS2),
                    .HSIZE2           (HSIZE2),
                    .HBURST2          (HBURST2),
                    .HREADYIN2        (HREADY2),
                    .HSELMPMC2G       (HSELMPMC2G),
                    .HSELMPMC2CS      (HSEL2[7:0]),
                    .HMASTLOCK2       (HMASTLOCK2),
                    .HADDR2           (HADDR2[27:0]),
                    .HWDATA2          (HWDATA2[31:0]),
                    .HWRITE3          (HWRITE3),
                    .HTRANS3          (HTRANS3),
                    .HSIZE3           (HSIZE3),
                    .HBURST3          (HBURST3),
                    .HREADYIN3        (HREADY3),
                    .HSELMPMC3G       (HSELMPMC3G),
                    .HSELMPMC3CS      (HSEL3[7:0]),
                    .HMASTLOCK3       (HMASTLOCK3),
                    .HADDR3           (HADDR3[27:0]),
                    .HWDATA3          (HWDATA3[31:0]),
                    .HWRITEREG        (HWRITE3),
                    .HTRANSREG        (HTRANS3[1]),
                    .HSIZEREG         (HSIZE3),
                    .HREADYINREG      (HREADY3),
                    .HSELMPMCREG      (HSEL3[8]),
                    .HADDRREG         (HADDR3[11:2]),
                    .HWDATAREG15TO0   (HWDATA3[15:0]),
                    .HWDATAREG20TO19  (HWDATA3[20:19]),
                    .HRDATATIC        (HRDATATIC),
                    .HREADYINTIC      (HREADYINTIC),
                    .HGRANTTIC        (HGRANTTIC),
                    .HRESPTIC         (HRESPTIC),
                    .MPMCTESTIN       (MPMCTESTIN),
                    .MPMCDATAIN       (MPMCDATAIN),
                    .MPMCSREFREQ      (MPMCSREFREQ),
                    .MPMCBIGENDIAN    (MPMCBIGENDIAN),
                    .MPMCSTCS1MW      (MPMCSTCS1MW),
                    .MPMCSTCS0POL     (MPMCSTCS0POL),
                    .MPMCSTCS1POL     (MPMCSTCS1POL),
                    .MPMCSTCS2POL     (MPMCSTCS2POL),
                    .MPMCSTCS3POL     (MPMCSTCS3POL),
                    .MPMCSTCS1PB      (MPMCSTCS1PB),
                    .MPMCREL1CONFIG   (MPMCREL1CONFIG),
                    .MPMCTESTREQA     (MPMCTESTREQA),
                    .MPMCTESTREQB     (MPMCTESTREQB),
                    .SCANINHCLK       (SCANINHCLK),
                    .SCANINMPMCCLK    (SCANINMPMCCLK),
                    .SCANINCLKDELAY    (SCANINCLKDELAY),
                    .SCANINFBCLKIN0   (SCANINFBCLKIN0),
                    .SCANINFBCLKIN1   (SCANINFBCLKIN1),
                    .SCANINFBCLKIN2   (SCANINFBCLKIN2),
                    .SCANINFBCLKIN3   (SCANINFBCLKIN3),
                    .SCANENABLE       (SCANENABLE),
                    .HREADYOUT0       (HREADYOutMpmc0),
                    .HRESP0           (HRESPOutMpmc0),
                    .HRDATA0          (HRDATAOutMpmc0[31:0]),
                    .HREADYOUT1       (HREADYOutMpmc1),
                    .HRESP1           (HRESPOutMpmc1),
                    .HRDATA1          (HRDATAOutMpmc1[31:0]),
                    .HREADYOUT2       (HREADYOutMpmc2),
                    .HRESP2           (HRESPOutMpmc2),
                    .HRDATA2          (HRDATAOutMpmc2[31:0]),
                    .HREADYOUT3       (HREADYOutMpmc3),
                    .HRESP3           (HRESPOutMpmc3),
                    .HRDATA3          (HRDATAOutMpmc3[31:0]),
                    .HREADYOUTREG     (HREADYOutMCReg),
                    .HRESPREG         (HRESPOutMCReg),
                    .HRDATAREG        (HRDATAOutMCReg[20:0]),
                    .HWRITETIC        (HWRITETIC),
                    .HTRANSTIC        (HTRANSTIC),
                    .HSIZETIC         (HSIZETIC),
                    .HBURSTTIC        (HBURSTTIC),
                    .HLOCKTIC         (HLOCKTIC),
                    .HPROTTIC         (HPROTTIC),
                    .HBUSREQTIC       (HBUSREQTIC),
                    .HADDRTIC         (HADDRTIC),
                    .HWDATATIC        (HWDATATIC),
                    .MPMCCLKOUT       (MPMCCLKOUT),
                    .MPMCCKEOUT       (MPMCCKEOUT),
                    .MPMCDQMOUT       (MPMCDQMOUT),
                    .nMPMCBLSOUT      (nMPMCBLSOUT),
                    .nMPMCRASOUT      (nMPMCRASOUT),
                    .nMPMCCASOUT      (nMPMCCASOUT),
                    .nMPMCOEOUT       (nMPMCOEOUT),
                    .nMPMCWEOUT       (nMPMCWEOUT),
                    .nMPMCSTCSOUT     (nMPMCSTCSOUT),
                    .nMPMCDYCSOUT     (nMPMCDYCSOUT),
                    .MPMCADDROUT      (MPMCADDROUT),
                    .MPMCDATAOUT      (MPMCDATAOUT),
                    .nMPMCRPOUT       (nMPMCRPOUT),
                    .MPMCRPVHHOUT     (MPMCRPVHHOUT),
                    .nMPMCDATAEN      (nMPMCDATAEN),
                    .MPMCSREFACK      (MPMCSREFACK),
                    .MPMCEBIREQ       (MPMCEBIREQ),
                    .MPMCEBIGNT       (MPMCEBIGNT),
                    .MPMCEBIBACKOFF   (MPMCEBIBACKOFF),
                    .SCANOUTHCLK      (SCANOUTHCLK),
                    .SCANOUTMPMCCLK   (SCANOUTMPMCCLK),
                    .SCANOUTCLKDELAY   (SCANOUTCLKDELAY),
                    .SCANOUTFBCLKIN0  (SCANOUTFBCLKIN0),
                    .SCANOUTFBCLKIN1  (SCANOUTFBCLKIN1),
                    .SCANOUTFBCLKIN2  (SCANOUTFBCLKIN2),
                    .SCANOUTFBCLKIN3  (SCANOUTFBCLKIN3)
                    );

// -----------------------------------------------------------------------------
// MPMC Trickbox
// -----------------------------------------------------------------------------
defparam uMpmcTrick.Tclkl = `Tclkl;
defparam uMpmcTrick.Tclkh = `Tclkh;
defparam uMpmcTrick.Tclks = `Tclks;

MpmcTrick uMpmcTrick                  (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR0           (HADDR0[11:2]),
                    .HADDR1           (HADDR1[11:2]),
                    .HADDR2           (HADDR2[11:2]),
                    .HADDR3           (HADDR3[11:2]),
                    .HTRANS0          (HTRANS0),
                    .HTRANS1          (HTRANS1),
                    .HTRANS2          (HTRANS2),
                    .HTRANS3          (HTRANS3),
                    .HWRITE0          (HWRITE0),
                    .HWRITE1          (HWRITE1),
                    .HWRITE2          (HWRITE2),
                    .HWRITE3          (HWRITE3),
                    .HSIZE0           (HSIZE0),
                    .HSIZE1           (HSIZE1),
                    .HSIZE2           (HSIZE2),
                    .HSIZE3           (HSIZE3),
                    .HBURST0          (HBURST0),
                    .HBURST1          (HBURST1),
                    .HBURST2          (HBURST2),
                    .HBURST3          (HBURST3),
                    .HREADYIN0        (HREADY0),
                    .HREADYIN1        (HREADY1),
                    .HREADYIN2        (HREADY2),
                    .HREADYIN3        (HREADY3),
                    .HWDATA0          (HWDATA0[31:0]),
                    .HWDATA1          (HWDATA1[31:0]),
                    .HWDATA2          (HWDATA2[31:0]),
                    .HWDATA3          (HWDATA3[31:0]),
                    .HSELMPMCTR0      (HSEL0[8]),
                    .HSELMPMCTR1      (HSEL1[8]),
                    .HSELMPMCTR2      (HSEL2[8]),
                    .HSELMPMCTR3      (HSEL3[9]),
                    .HSELMPMCREG      (HSEL3[8]),
                    .MPMCCLKOUT       (MPMCCLKOUT),
                    .MPMCCKEOUT       (MPMCCKEOUT),
                    .nMPMCRASOUT      (nMPMCRASOUT),
                    .nMPMCCASOUT      (nMPMCCASOUT),
                    .nMPMCDYCSOUT     (nMPMCDYCSOUT),
                    .nMPMCSTCSOUT     (nMPMCSTCSOUT),
                    .MPMCACTLOWCS     (nMPMCSTCSOUT),
                    .nMPMCWEOUT       (nMPMCWEOUT),
                    .nMPMCDATAEN      (nMPMCDATAEN),
                    .nMPMCOEOUT       (nMPMCOEOUT),
                    .MPMCDQMOUT       (MPMCDQMBLS),
                    .nMPMCRPOUT       (nMPMCRPOUT),
                    .MPMCRPVHHOUT     (MPMCRPVHHOUT),
                    .MPMCSREFACK      (MPMCSREFACK),
                    .MPMCADDROUT      (MPMCADDROUT),
                    .MPMCDATAIN       (MPMCDATAIN),
                    .MPMCDATAOUT      (MPMCDATAOUT),
                    .MPMCTrStExtWt    (MPMCTrStExtWt),
                    .HREADYOUT0       (HREADYOutMCTr0),
                    .HREADYOUT1       (HREADYOutMCTr1),
                    .HREADYOUT2       (HREADYOutMCTr2),
                    .HREADYOUT3       (HREADYOutMCTr3),
                    .HRESP0           (HRESPOutMCTr0),
                    .HRESP1           (HRESPOutMCTr1),
                    .HRESP2           (HRESPOutMCTr2),
                    .HRESP3           (HRESPOutMCTr3),
                    .MPMCCLK          (MPMCCLK),
                    .MPMCCLKDELAY     (MPMCCLKDELAY),
                    .nPOR             (nPOR),
                    .MPMCSREFREQ      (MPMCSREFREQ),
                    .MPMCBIGENDIAN    (MPMCBIGENDIAN),
                    .MPMCSTCS0POL     (MPMCSTCS0POL),
                    .MPMCSTCS1POL     (MPMCSTCS1POL),
                    .MPMCSTCS2POL     (MPMCSTCS2POL),
                    .MPMCSTCS3POL     (MPMCSTCS3POL),
                    .MPMCSTCS1PB      (MPMCSTCS1PB),
                    .MPMCSTCS1MW      (MPMCSTCS1MW),
                    .MPMCEBIREQ       (MPMCEBIREQ),
                    .MPMCEBIGNT       (MPMCEBIGNT),
                    .MPMCEBIBACKOFF   (MPMCEBIBACKOFF),
                    .HREADYOutMpmc0   (HREADYOutMpmc0), 
                    .HREADYOutMpmc1   (HREADYOutMpmc1), 
                    .HRDATA0          (HRDATAOutMCTr0[31:0]),
                    .HRDATA1          (HRDATAOutMCTr1[31:0]),
                    .HRDATA2          (HRDATAOutMCTr2[31:0]),
                    .HRDATA3          (HRDATAOutMCTr3[31:0])
                    );

// -----------------------------------------------------------------------------
// Denali Models Instantiations
// -----------------------------------------------------------------------------
assign MemAddrConcat  = {MPMCADDROUT[14:13], MPMCADDROUT[11:0]};

defparam uI28f320w18b_70.memory_spec = "../../denali/I28f320w18b_70.soma";
defparam uI28f320w18b_70.init_file   = "";

I28f320w18b_70 uI28f320w18b_70        (
                    .a                (MPMCADDROUT[20:0]),
                    .dq               (MPMCDATA[15:0]),
                    .cebar            (nMPMCSTCSOUT[0]),
                    .oebar            (nMPMCOEOUT),
                    .webar            (nMPMCWEOUT),
                    .wpbar            (nWP),
                    .resetbar         (nRST),
                    .clk              (CLK),
                    .advbar           (nADV),
                    .waitbar          (nWAIT),
                    .vpp              (VPP)
                    );

defparam u0Int28f800f3b95.memory_spec = "../../denali/Int28f800f3b95.soma";
defparam u0Int28f800f3b95.init_file   = "../../denali/Int28f800f3b95.dat";

Int28f800f3b95 u0Int28f800f3b95       (
                    .a                (MPMCADDROUT[18:0]),
                    .dq               (MPMCDATA[15:0]),
                    .cebar            (nMPMCSTCSOUT[1]),
                    .oebar            (nMPMCOEOUT),
                    .webar            (nMPMCWEOUT),
                    .wpbar            (nWP),
                    .rstbar           (nRST),
                    .clk              (CLK),
                    .advbar           (nADV),
                    .waitbar          (nWAIT)
                    );

defparam u1Int28f800f3b95.memory_spec = "../../denali/Int28f800f3b95.soma";
defparam u1Int28f800f3b95.init_file   = "../../denali/Int28f800f3b95.dat";

Int28f800f3b95 u1Int28f800f3b95       (
                    .a                (MPMCADDROUT[18:0]),
                    .dq               (MPMCDATA[31:16]),
                    .cebar            (nMPMCSTCSOUT[1]),
                    .oebar            (nMPMCOEOUT),
                    .webar            (nMPMCWEOUT),
                    .wpbar            (nWP),
                    .rstbar           (nRST),
                    .clk              (CLK),
                    .advbar           (nADV),
                    .waitbar          (nWAIT)
                    );

defparam uInt28f800f3b115.memory_spec = "../../denali/Int28f800f3b115.soma";
defparam uInt28f800f3b115.init_file   = "../../denali/Int28f800f3b115.dat";

Int28f800f3b115 uInt28f800f3b115       (
                    .a                (MPMCADDROUT[18:0]),
                    .dq               (MPMCDATA[15:0]),
                    .cebar            (nMPMCSTCSOUT[2]),
                    .oebar            (nMPMCOEOUT),
                    .webar            (nMPMCWEOUT),
                    .wpbar            (nWP),
                    .rstbar           (nRST),
                    .clk              (CLK),
                    .advbar           (nADV),
                    .waitbar          (nWAIT)
                    );

defparam u0Int28f800f3b115.memory_spec = "../../denali/Int28f800f3b115.soma";
defparam u0Int28f800f3b115.init_file   = "../../denali/Int28f800f3b115.dat";

Int28f800f3b115 u0Int28f800f3b115       (
                    .a                (MPMCADDROUT[18:0]),
                    .dq               (MPMCDATA[15:0]),
                    .cebar            (nMPMCSTCSOUT[3]),
                    .oebar            (nMPMCOEOUT),
                    .webar            (nMPMCWEOUT),
                    .wpbar            (nWP),
                    .rstbar           (nRST),
                    .clk              (CLK),
                    .advbar           (nADV),
                    .waitbar          (nWAIT)
                    );

defparam u1Int28f800f3b115.memory_spec = "../../denali/Int28f800f3b115.soma";
defparam u1Int28f800f3b115.init_file   = "../../denali/Int28f800f3b115.dat";

Int28f800f3b115 u1Int28f800f3b115       (
                    .a                (MPMCADDROUT[18:0]),
                    .dq               (MPMCDATA[31:16]),
                    .cebar            (nMPMCSTCSOUT[3]),
                    .oebar            (nMPMCOEOUT),
                    .webar            (nMPMCWEOUT),
                    .wpbar            (nWP),
                    .rstbar           (nRST),
                    .clk              (CLK),
                    .advbar           (nADV),
                    .waitbar          (nWAIT)
                    );

defparam u0hm5212165f_75a.memory_spec = "../../denali/hm5212165f_75a.soma";
defparam u0hm5212165f_75a.init_file   = "../../denali/hm5212165f_75a1.dat";

hm5212165f_75a u0hm5212165f_75a       (
                    .a                (MemAddrConcat),
                    .rasbar           (nMPMCRASOUT),
                    .casbar           (nMPMCCASOUT),
                    .webar            (nMPMCWEOUT),
                    .csbar            (nMPMCDYCSOUT[0]),
                    .dqm              (MPMCDQMOUT[1:0]),
                    .clk              (DelMPMCCLKOUT[0]),
                    .cke              (MPMCCKEOUT[0]),
                    .dq               (MPMCDATA[15:0])
                    );

defparam u1hm5212165f_75a.memory_spec = "../../denali/hm5212165f_75a.soma";
defparam u1hm5212165f_75a.init_file   = "../../denali/hm5212165f_75a2.dat";

hm5212165f_75a u1hm5212165f_75a       (
                    .a                (MemAddrConcat),
                    .rasbar           (nMPMCRASOUT),
                    .casbar           (nMPMCCASOUT),
                    .webar            (nMPMCWEOUT),
                    .csbar            (nMPMCDYCSOUT[0]),
                    .dqm              (MPMCDQMOUT[3:2]),
                    .clk              (DelMPMCCLKOUT[1]),
                    .cke              (MPMCCKEOUT[0]),
                    .dq               (MPMCDATA[31:16])
                    );

defparam umt48lc1m16a1_6s.memory_spec = "../../denali/mt48lc1m16a1_6s.soma";
defparam umt48lc1m16a1_6s.init_file   = "../../denali/mt48lc1m16a1_6s.dat";

mt48lc1m16a1_6s umt48lc1m16a1_6s      (
                    .a                (MPMCADDROUT[10:0]),
                    .rasbar           (nMPMCRASOUT),
                    .casbar           (nMPMCCASOUT),
                    .webar            (nMPMCWEOUT),
                    .csbar            (nMPMCDYCSOUT[1]),
                    .dqm              (MPMCDQMOUT[1:0]),
                    .clk              (DelMPMCCLKOUT[0]),
                    .cke              (MPMCCKEOUT[1]),
                    .ba               (MPMCADDROUT[14]),
                    .dq               (MPMCDATA[15:0])
                    );

defparam u0hm5225805b_75.memory_spec = "../../denali/hm5225805b_75.soma";
defparam u0hm5225805b_75.init_file   = "../../denali/hm5225805b_75.dat";

hm5225805b_75 u0hm5225805b_75         (
                    .a                (MPMCADDROUT[12:0]),
                    .rasbar           (nMPMCRASOUT),
                    .casbar           (nMPMCCASOUT),
                    .webar            (nMPMCWEOUT),
                    .csbar            (nMPMCDYCSOUT[2]),
                    .dqm              (MPMCDQMOUT[0]),
                    .clk              (DelMPMCCLKOUT[0]),
                    .cke              (MPMCCKEOUT[2]),
                    .ba               (MPMCADDROUT[14:13]),
                    .dq               (MPMCDATA[7:0])
                    );

defparam u1hm5225805b_75.memory_spec = "../../denali/hm5225805b_75.soma";
defparam u1hm5225805b_75.init_file   = "../../denali/hm5225805b_75.dat";

hm5225805b_75 u1hm5225805b_75         (
                    .a                (MPMCADDROUT[12:0]),
                    .rasbar           (nMPMCRASOUT),
                    .casbar           (nMPMCCASOUT),
                    .webar            (nMPMCWEOUT),
                    .csbar            (nMPMCDYCSOUT[2]),
                    .dqm              (MPMCDQMOUT[1]),
                    .clk              (DelMPMCCLKOUT[1]),
                    .cke              (MPMCCKEOUT[2]),
                    .ba               (MPMCADDROUT[14:13]),
                    .dq               (MPMCDATA[15:8])
                    );

defparam umt48lc2m32b2_6.memory_spec = "../../denali/mt48lc2m32b2_6.soma";
defparam umt48lc2m32b2_6.init_file   = "../../denali/mt48lc2m32b2_6.dat";

mt48lc2m32b2_6 umt48lc2m32b2_6        (
                    .a                (MPMCADDROUT[10:0]),
                    .rasbar           (nMPMCRASOUT),
                    .casbar           (nMPMCCASOUT),
                    .webar            (nMPMCWEOUT),
                    .csbar            (nMPMCDYCSOUT[3]),
                    .dqm              (MPMCDQMOUT),
                    .clk              (DelMPMCCLKOUT[0]),
                    .cke              (MPMCCKEOUT[3]),
                    .ba               (MPMCADDROUT[14:13]),
                    .dq               (MPMCDATA)
                    );

// -----------------------------------------------------------------------------
// Include system task for SDF delay annotation.
// -----------------------------------------------------------------------------
`ifdef NET_MAX
  initial
  begin
    $sdf_annotate("",uut,,,"MAXIMUM");
  end
  `endif

`ifdef NET_MIN
  initial
  begin
    $sdf_annotate("",uut,,,"MINIMUM");
  end
`endif

`ifdef NET_TYP
  initial
  begin
    $sdf_annotate("",uut,,,"TYPICAL");
  end
`endif

// initial
//  begin
//   $dumpvars();
//   $dumpfile("/dump/arm/Mpmc.vcd");
// $finish;
//  end

endmodule

// --================================ End ====================================--
