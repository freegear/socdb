// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : tbench.v.rca
// File Revision          : 1.15
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Top level testbench for the Static Memory Controller.
//           This testbench instantiates the SMC, the Memory Models, the
//           Trickboxes and the AHB Bus Master model.
//
// --=========================================================================--

`timescale 1ns/1ps

`include "../tbench/timing.v"
`include "../tbench/timingmaster.v"
`include "../common/defs.v"

// -----------------------------------------------------------------------------

module tbench();
parameter Verbosity       = 0;
parameter HaltOnMismatch  = 0;
parameter XonSig          = 0;
parameter SuppressOnReset = 0;
parameter Databuswidth    = 32;

// -----------------------------------------------------------------------------
// Note on PARAMETERS :
// * Verbosity       : To suppress messages other than error messages,
//                     Verbosity is to be cleared.
// * HaltOnMismatch  : If HaltOnMismatch is set, it halts the simulation when
//                     it detects any error.
// * XonSig          : XonSig if set, enables signals to be unknown values;
//                     else signals will take their default values.
// * SuppressOnReset : SuppressOnReset suppresses all protocol checks on
//                     slave's output signals.
// * Databuswidth    : Databuswidth can be set to 64 or 32, depending upon the
//                     device to be tested.
// -----------------------------------------------------------------------------

`uselib lib=uut lib=trickbox

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define ORBUS  1'b0
// If this bit is set, then testbench will have a OR bus configuration
// Else, by default, it will be a MUX implementation

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
// AMBA related signals
wire        nHCLK;
wire        HCLK;
wire        HRESETn;
wire [31:0] HADDR;
wire [63:0] HRDATA;
wire [63:0] HWDATA;
wire        HMASTLOCK;
wire        HWRITE;
wire [2:0]  HSIZE;
wire [2:0]  HBURST;
wire [3:0]  HPROT;
wire [1:0]  HTRANS;
reg  [1:0]  HRESP;
wire        DefSlaveSel;
reg         HREADY;
wire [15:0] HSPLIT;
wire [3:0]  HMASTER;
wire        HBUSREQ;
wire        HGRANT;
wire        HLOCK;

wire [15:0] HSEL;
reg  [15:0] DelHSEL;
reg         DelDefSel;
reg         CancelSmWaitCame;
reg         EnableBus;

wire        HREADYOutDef;
wire        HREADYOut0;
wire        HREADYOut1;
wire        HREADYOut2;
wire        HREADYOut3;
wire        HREADYOut4;
wire        HREADYOut5;
wire        HREADYOut6;
wire        HREADYOut7;
wire        HREADYOut8;
wire        HREADYOut9;
wire        HREADYOR;
wire        HREADYMUX;

wire [31:0] VRG0;
wire [31:0] VRG1;
wire [31:0] VRG2;
wire [31:0] VRG3;
wire [31:0] VRG4;
wire [31:0] VRG5;
wire [31:0] VRG6;
wire [31:0] VRG7;

wire [31:0] iVRG0;
wire [31:0] iVRG1;
wire [31:0] iVRG2;
wire [31:0] iVRG3;

wire [63:0] HRDATAOutDef;
wire [63:0] HRDATAOut0;
wire [63:0] HRDATAOut1;
wire [63:0] HRDATAOut2;
wire [63:0] HRDATAOut3;
wire [63:0] HRDATAOut4;
wire [63:0] HRDATAOut5;
wire [63:0] HRDATAOut6;
wire [63:0] HRDATAOut7;
wire [63:0] HRDATAOut8;
wire [63:0] HRDATAOut9;
wire [63:0] iHRDATAOut0;
wire [63:0] iHRDATAOut1;
wire [63:0] iHRDATAOut2;
wire [63:0] iHRDATAOut3;
wire [63:0] iHRDATAOut4;
wire [63:0] iHRDATAOut5;
wire [63:0] iHRDATAOut6;
wire [63:0] iHRDATAOut7;
wire [63:0] iHRDATAOut8;
wire [63:0] iHRDATAOut9;
wire [63:0] HRDATAOR;
wire [63:0] HRDATAMUX;

wire [1:0]  HRESPOutDef;
wire [1:0]  HRESPOut0;
wire [1:0]  HRESPOut1;
wire [1:0]  HRESPOut2;
wire [1:0]  HRESPOut3;
wire [1:0]  HRESPOut4;
wire [1:0]  HRESPOut5;
wire [1:0]  HRESPOut6;
wire [1:0]  HRESPOut7;
wire [1:0]  HRESPOut8;
wire [1:0]  HRESPOut9;
wire [1:0]  HRESPOR;
wire [1:0]  HRESPMUX;

// SMC related signals
wire [25:0] SMADDR;
tri1 [31:0] SMDATA;
wire [7:0]  SMCS;
wire        nSMWEN;
wire [3:0]  nSMBLS;
wire        nSMOEN;
wire [31:0] SMDATAOUT;
wire [31:0] SMDATAIN;
wire [3:0]  nSMDATAEN;
wire [1:0]  SMMWCS7;
wire        SMRBLECS7;
wire        SMBUSREQ;
wire        SMBUSGNT;
wire        SMWAIT;
wire        nSMWAIT;
wire        MCBUSREQ;
wire [25:0] MCADDR;
wire [31:0] MCDATAOUT;
wire [3:0]  MCDATAEN;
wire        MCBUSGNT;

// External Wait Control related signals
wire [7:0]  SMCActLowCS;
wire        CANCELSMWAIT;

// TIC signals
wire        HGRANTTIC;
wire        TESTREQA;
wire        TESTREQB;

// Static inputs
wire        BIGENDIAN;
wire        REMAP;

// Scan test related signals
wire        SCANENABLE;
wire        SCANINHCLK;
wire        SCANINnHCLK;
wire        SCANOUTHCLK;
wire        SCANOUTnHCLK;

// External signals related to the EbiSdram
wire        TICBUSGNTEBI;
wire        SMBUSGNTEBI;

wire        EXTBUSMUX;

wire        TICBUSREQEBI;
wire        SMBUSREQEBI;

wire        TICREADEBI;
wire [31:0] TBUSOUTEBI;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Initialising signals
// -----------------------------------------------------------------------------
initial
begin
  HREADY    = 1'b1;
end

assign iVRG0            = VRG0;
assign iVRG1            = VRG1;
assign iVRG2            = VRG2;
assign iVRG3            = VRG3;

assign VRG4             = iVRG0;
assign VRG5             = iVRG1;
assign VRG7             = iVRG3;
assign VRG6             = iVRG2;

assign nHCLK            = ~(HCLK);

assign HSPLIT           = 15'b0;

assign HRDATA           = (`ORBUS == 1'b1) ? HRDATAOR : HRDATAMUX;

assign HBUSREQ          = 1'b1;

assign HGRANT           = 1'b1;

assign HLOCK            = 1'b0;

assign HGRANTTIC        = 1'b0;

assign TESTREQA         = 1'b0;

assign TESTREQB         = 1'b0;

assign TICBUSGNTEBI     = 1'b0;

//assign SMBUSGNTEBI      = 1'b0;

//assign EXTBUSMUX        = 1'b0;
assign SMRBLECS7        = 1'b0;

// -----------------------------------------------------------------------------
// Connect all the scan inputs to '0' to prevent interference with functional
// mode tests.
// -----------------------------------------------------------------------------
assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;
assign SCANINnHCLK      = 1'b0;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested
// -----------------------------------------------------------------------------
assign iHRDATAOut0      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut1      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut1[31:0]} : HRDATAOut1;

assign iHRDATAOut2      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut2[31:0]} : HRDATAOut2;

assign iHRDATAOut3      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut3[31:0]} : HRDATAOut3;

assign iHRDATAOut4      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut4[31:0]} : HRDATAOut4;

assign iHRDATAOut5      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut5[31:0]} : HRDATAOut5;

assign iHRDATAOut6      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut6[31:0]} : HRDATAOut6;

assign iHRDATAOut7      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut7[31:0]} : HRDATAOut7;

assign iHRDATAOut8      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut8[31:0]} : HRDATAOut8;

assign iHRDATAOut9      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut9[31:0]} : HRDATAOut9;

// -----------------------------------------------------------------------------
// For MUX bus Implementations
// -----------------------------------------------------------------------------
assign HREADYMUX        = (DelHSEL[0] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[1] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[2] == 1'b1) ?
                           HREADYOut1   :
                          (DelHSEL[3] == 1'b1) ?
                           HREADYOut2   :
                          (DelHSEL[4] == 1'b1) ?
                           HREADYOut3   :
                          (DelHSEL[5] == 1'b1) ?
                           HREADYOut4   :
                          (DelHSEL[6] == 1'b1) ?
                           HREADYOut5   :
                          (DelHSEL[7] == 1'b1) ?
                           HREADYOut6   :
                          (DelHSEL[8] == 1'b1) ?
                           HREADYOut7   :
                          (DelHSEL[9] == 1'b1) ?
                           HREADYOut8   :
                          (DelHSEL[10] == 1'b1) ?
                           HREADYOut9   :
                          (DelDefSel == 1'b1) ?
                           HREADYOutDef : 1'b0;

assign HRESPMUX         = (DelHSEL[0] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[1] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[2] == 1'b1) ?
                           HRESPOut1   :
                          (DelHSEL[3] == 1'b1) ?
                           HRESPOut2   :
                          (DelHSEL[4] == 1'b1) ?
                           HRESPOut3   :
                          (DelHSEL[5] == 1'b1) ?
                           HRESPOut4   :
                          (DelHSEL[6] == 1'b1) ?
                           HRESPOut5   :
                          (DelHSEL[7] == 1'b1) ?
                           HRESPOut6   :
                          (DelHSEL[8] == 1'b1) ?
                           HRESPOut7   :
                          (DelHSEL[9] == 1'b1) ?
                           HRESPOut8   :
                          (DelHSEL[10] == 1'b1) ?
                           HRESPOut9   :
                          (DelDefSel == 1'b1) ?
                           HRESPOutDef : 2'b00;

assign HRDATAMUX        = (DelHSEL[0] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[1] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[2] == 1'b1) ?
                           iHRDATAOut1  :
                          (DelHSEL[3] == 1'b1) ?
                           iHRDATAOut2  :
                          (DelHSEL[4] == 1'b1) ?
                           iHRDATAOut3  :
                          (DelHSEL[5] == 1'b1) ?
                           iHRDATAOut4  :
                          (DelHSEL[6] == 1'b1) ?
                           iHRDATAOut5  :
                          (DelHSEL[7] == 1'b1) ?
                           iHRDATAOut6  :
                          (DelHSEL[8] == 1'b1) ?
                           iHRDATAOut7  :
                          (DelHSEL[9] == 1'b1) ?
                           iHRDATAOut8  :
                          (DelHSEL[10] == 1'b1) ?
                           iHRDATAOut9  :
                          (DelDefSel == 1'b1) ?
                           HRDATAOutDef : 64'h0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus Implementations
// -----------------------------------------------------------------------------
assign HRESPOR          = HRESPOut0 | HRESPOut1 | HRESPOut2 |
                          HRESPOut3 | HRESPOut4 | HRESPOut5 |
                          HRESPOut6 | HRESPOut7 | HRESPOut8 |
                          HRESPOut9 | HRESPOutDef;

assign HREADYOR         = HREADYOut0 | HREADYOut1 | HREADYOut2 |
                          HREADYOut3 | HREADYOut4 | HREADYOut5 |
                          HREADYOut6 | HREADYOut7 | HREADYOut8 |
                          HREADYOut9 | HREADYOutDef;

assign HRDATAOR         = iHRDATAOut0 | iHRDATAOut1 | iHRDATAOut2 |
                          iHRDATAOut3 | iHRDATAOut4 | iHRDATAOut5 |
                          iHRDATAOut6 | iHRDATAOut7 | iHRDATAOut8 |
                          iHRDATAOut9 | HRDATAOutDef;

// -----------------------------------------------------------------------------
// Generating HREADY Output
// -----------------------------------------------------------------------------
always @(HREADYOR or HREADYMUX or HRESETn)
begin : p_OutputSeq
  if (`ORBUS == 1'b1)
    HREADY = HREADYOR;
  else
    HREADY = HREADYMUX;
end // p_OutputSeq

// -----------------------------------------------------------------------------
// Generating HRESP Output
// -----------------------------------------------------------------------------
always @(HRESPOR or HRESPMUX or HRESETn)
begin : p_RespSeq
  if (`ORBUS == 1'b1)
    HRESP = HRESPOR;
  else
    HRESP = HRESPMUX;
end // p_RespSeq

// -----------------------------------------------------------------------------
// Latching HSEL
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_HSELSeq
  if (HRESETn == 1'b0)
  begin
    DelHSEL   = 16'h0000;
    DelDefSel = 1'b1;
  end
  else
    if (HREADY == 1'b1)
    begin
      DelHSEL   = HSEL;
      DelDefSel = DefSlaveSel;
    end
end // p_HSELSeq;
always @(SMBUSGNTEBI or EXTBUSMUX)
begin : p_EnableBus
 if (EXTBUSMUX == 1'b1 && SMBUSGNTEBI == 1'b1)
  EnableBus = 1'b1;
 else
   if(EXTBUSMUX == 1'b0)
  EnableBus = 1'b1;
 else
  EnableBus = 1'b0;
end // p_EnableBus
// -----------------------------------------------------------------------------
// Memory Data Bus multiplexing
// -----------------------------------------------------------------------------
assign SMDATA[7:0]      = (nSMDATAEN[0] == 1'b0 && EnableBus == 1'b1) ? 
                           SMDATAOUT[7:0] : 8'bzzzzzzzz;

assign SMDATA[15:8]     = (nSMDATAEN[1] == 1'b0 && EnableBus == 1'b1 ) ? 
                           SMDATAOUT[15:8]: 8'bzzzzzzzz;

assign SMDATA[23:16]    = (nSMDATAEN[2] == 1'b0 && EnableBus == 1'b1) ? 
                           SMDATAOUT[23:16] : 8'bzzzzzzzz;

assign SMDATA[31:24]    = (nSMDATAEN[3] == 1'b0 && EnableBus == 1'b1) ? 
                           SMDATAOUT[31:24] : 8'bzzzzzzzz;

assign SMDATAIN         = SMDATA;

// -----------------------------------------------------------------------------
// Component Instantiations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// AHB Slave Testbench Instantiation
// -----------------------------------------------------------------------------
defparam uahbslave_tb.Verbosity       = Verbosity;
defparam uahbslave_tb.HaltOnMismatch  = HaltOnMismatch;
defparam uahbslave_tb.XonSig          = XonSig;
defparam uahbslave_tb.Databuswidth    = Databuswidth;
defparam uahbslave_tb.SuppressOnReset = SuppressOnReset;

ahbslave_tb uahbslave_tb
                    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HPROT            (HPROT),
                    .HMASTER          (HMASTER),
                    .HMASTLOCK        (HMASTLOCK),
                    .HWDATA           (HWDATA),
                    .HSPLIT           (HSPLIT),
                    .HRDATA           (HRDATA),
                    .HREADY           (HREADY),
                    .HRESP            (HRESP),
                    .VRG0             (VRG0),
                    .VRG1             (VRG1),
                    .VRG2             (VRG2),
                    .VRG3             (VRG3),
                    .VRG4             (VRG4),
                    .VRG5             (VRG5),
                    .VRG6             (VRG6),
                    .VRG7             (VRG7)
                    );

// -----------------------------------------------------------------------------
// Address Decoder Instantiation
// -----------------------------------------------------------------------------
decoder udecoder                      (
                    .HADDR            (HADDR),
                    .HSEL             (HSEL),
                    .DefSlaveSel      (DefSlaveSel)
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Instantiation
// -----------------------------------------------------------------------------
defparam uSmcTrick.Tclk = `Tclk;

SmcTrick uSmcTrick                    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[6:2]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTR        (HSEL[2]),

                    .SMDATAOUT        (SMDATAOUT),
                    .SMADDR           (SMADDR),
                    .SMCS             (SMCS),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCActLowCS      (SMCActLowCS),
                    .MCBUSGNT         (MCBUSGNT),
                    .SMBUSREQ         (SMBUSREQEBI),
                    .SMBUSGNT         (SMBUSGNTEBI),
                    .EXTBUSMUX        (EXTBUSMUX),

                    .HRDATA           (HRDATAOut1[31:0]),
                    .HREADYOUT        (HREADYOut1),
                    .HRESP            (HRESPOut1),
                    .ENDIANCNT        (BIGENDIAN),
                    .REMAP            (REMAP),

                    .SMMWCS7          (SMMWCS7),
                    .SMWAIT           (SMWAIT),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),
                    .MCBUSREQ         (MCBUSREQ),
                    .MCADDR           (MCADDR),
                    .MCDATAOUT        (MCDATAOUT),
                    .MCDATAEN         (MCDATAEN)
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Memory model Instantiation for Memory Bank 0
// -----------------------------------------------------------------------------
defparam u0SmcTrickMem.Tclk = `Tclk;

SmcTrickMem u0SmcTrickMem             (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[15:0]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTRMEM     (HSEL[3]),

                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .nSMBLS           (nSMBLS),
                    .SMCTrAllCS       (SMCS),
                    .SMCTrCS          (SMCS[0]),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),

                    .SMDATA           (SMDATA),

                    .HRDATA           (HRDATAOut2[31:0]),
                    .HREADYOUT        (HREADYOut2),
                    .HRESP            (HRESPOut2),

                    .SMCActLowCS      (SMCActLowCS[0])
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Memory model Instantiation for Memory Bank 1
// -----------------------------------------------------------------------------
defparam u1SmcTrickMem.Tclk = `Tclk;

SmcTrickMem u1SmcTrickMem             (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[15:0]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTRMEM     (HSEL[4]),

                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .nSMBLS           (nSMBLS),
                    .SMCTrAllCS       (SMCS),
                    .SMCTrCS          (SMCS[1]),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),

                    .SMDATA           (SMDATA),

                    .HRDATA           (HRDATAOut3[31:0]),
                    .HREADYOUT        (HREADYOut3),
                    .HRESP            (HRESPOut3),

                    .SMCActLowCS      (SMCActLowCS[1])
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Memory model Instantiation for Memory Bank 2
// -----------------------------------------------------------------------------
defparam u2SmcTrickMem.Tclk = `Tclk;

SmcTrickMem u2SmcTrickMem             (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[15:0]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTRMEM     (HSEL[5]),

                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .nSMBLS           (nSMBLS),
                    .SMCTrAllCS       (SMCS),
                    .SMCTrCS          (SMCS[2]),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),

                    .SMDATA           (SMDATA),

                    .HRDATA           (HRDATAOut4[31:0]),
                    .HREADYOUT        (HREADYOut4),
                    .HRESP            (HRESPOut4),

                    .SMCActLowCS      (SMCActLowCS[2])
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Memory model Instantiation for Memory Bank 3
// -----------------------------------------------------------------------------
defparam u3SmcTrickMem.Tclk = `Tclk;

SmcTrickMem u3SmcTrickMem             (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[15:0]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTRMEM     (HSEL[6]),

                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .nSMBLS           (nSMBLS),
                    .SMCTrAllCS       (SMCS),
                    .SMCTrCS          (SMCS[3]),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),

                    .SMDATA           (SMDATA),

                    .HRDATA           (HRDATAOut5[31:0]),
                    .HREADYOUT        (HREADYOut5),
                    .HRESP            (HRESPOut5),

                    .SMCActLowCS      (SMCActLowCS[3])
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Memory model Instantiation for Memory Bank 4
// -----------------------------------------------------------------------------
defparam u4SmcTrickMem.Tclk = `Tclk;

SmcTrickMem u4SmcTrickMem             (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[15:0]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTRMEM     (HSEL[7]),

                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .nSMBLS           (nSMBLS),
                    .SMCTrAllCS       (SMCS),
                    .SMCTrCS          (SMCS[4]),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),

                    .SMDATA           (SMDATA),

                    .HRDATA           (HRDATAOut6[31:0]),
                    .HREADYOUT        (HREADYOut6),
                    .HRESP            (HRESPOut6),

                    .SMCActLowCS      (SMCActLowCS[4])
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Memory model Instantiation for Memory Bank 5
// -----------------------------------------------------------------------------
defparam u5SmcTrickMem.Tclk = `Tclk;

SmcTrickMem u5SmcTrickMem             (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[15:0]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTRMEM     (HSEL[8]),

                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .nSMBLS           (nSMBLS),
                    .SMCTrAllCS       (SMCS),
                    .SMCTrCS          (SMCS[5]),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),

                    .SMDATA           (SMDATA),

                    .HRDATA           (HRDATAOut7[31:0]),
                    .HREADYOUT        (HREADYOut7),
                    .HRESP            (HRESPOut7),

                    .SMCActLowCS      (SMCActLowCS[5])
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Memory model Instantiation for Memory Bank 6
// -----------------------------------------------------------------------------
defparam u6SmcTrickMem.Tclk = `Tclk;

SmcTrickMem u6SmcTrickMem             (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[15:0]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTRMEM     (HSEL[9]),

                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .nSMBLS           (nSMBLS),
                    .SMCTrAllCS       (SMCS),
                    .SMCTrCS          (SMCS[6]),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),

                    .SMDATA           (SMDATA),

                    .HRDATA           (HRDATAOut8[31:0]),
                    .HREADYOUT        (HREADYOut8),
                    .HRESP            (HRESPOut8),

                    .SMCActLowCS      (SMCActLowCS[6])
                    );

// -----------------------------------------------------------------------------
// SMC Trickbox Memory model Instantiation for Memory Bank 7
// -----------------------------------------------------------------------------
defparam u7SmcTrickMem.Tclk = `Tclk;

SmcTrickMem u7SmcTrickMem             (
                    .HCLK             (HCLK),
                    .nHCLK            (nHCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[15:0]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMCTRMEM     (HSEL[10]),

                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),
                    .nSMBLS           (nSMBLS),
                    .SMCTrAllCS       (SMCS),
                    .SMCTrCS          (SMCS[7]),
                    .nSMWAIT          (nSMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),

                    .SMDATA           (SMDATA),

                    .HRDATA           (HRDATAOut9[31:0]),
                    .HREADYOUT        (HREADYOut9),
                    .HRESP            (HRESPOut9),

                    .SMCActLowCS      (SMCActLowCS[7])
                    );

// -----------------------------------------------------------------------------
// UUT Instantiation (SMC)
// -----------------------------------------------------------------------------
Smc uut             (
// Inputs
                    .nHCLK            (nHCLK),
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HREADYIN         (HREADY),
                    .HADDR            (HADDR[28:0]),
                    .HBURST           (HBURST),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSMC          (HSEL[0]),
                    .HSELREG          (HSEL[1]),
                    .HRESPTIC         (HRESP),
                    .HRDATATIC        (HRDATA[31:0]),
                    .HGRANTTIC        (HGRANTTIC),
                    .BIGENDIAN        (BIGENDIAN),
                    .REMAP            (REMAP),

                    .TICBUSGNTEBI     (TICBUSGNTEBI),
                    .SMBUSGNTEBI      (SMBUSGNTEBI),

                    .SCANENABLE       (SCANENABLE),
                    .SCANINHCLK       (SCANINHCLK),
                    .SCANINnHCLK      (SCANINnHCLK),

                    .SMWAIT           (SMWAIT),
                    .CANCELSMWAIT     (CANCELSMWAIT),
                    .SMMWCS7          (SMMWCS7),
                    .SMRBLECS7        (SMRBLECS7),
                    .SMDATAIN         (SMDATAIN),

                    .TESTREQA         (TESTREQA),
                    .TESTREQB         (TESTREQB),

                    .MCBUSREQ         (MCBUSREQ),
                    .MCADDR           (MCADDR),
                    .MCDATAOUT        (MCDATAOUT),
                    .MCDATAEN         (MCDATAEN),

                    .EXTBUSMUX        (EXTBUSMUX),

// Outputs
                    .HRDATA           (HRDATAOut0[31:0]),
                    .HREADYOUT        (HREADYOut0),
                    .HRESP            (HRESPOut0),
                    .HADDRTIC         (),
                    .HTRANSTIC        (),
                    .HWRITETIC        (),
                    .HSIZETIC         (),
                    .HBURSTTIC        (),
                    .HPROTTIC         (),
                    .HWDATATIC        (),
                    .HBUSREQTIC       (),
                    .HLOCKTIC         (),

                    .TICBUSREQEBI     (),
                    .SMBUSREQEBI      (SMBUSREQEBI),

                    .SCANOUTnHCLK     (SCANOUTnHCLK),
                    .SCANOUTHCLK      (SCANOUTHCLK),

                    .SMDATAOUT        (SMDATAOUT),
                    .nSMDATAEN        (nSMDATAEN),
                    .SMADDR           (SMADDR),
                    .SMCS             (SMCS),
                    .nSMBLS           (nSMBLS),
                    .nSMWEN           (nSMWEN),
                    .nSMOEN           (nSMOEN),

                    .TICREADEBI       (),
                    .TBUSOUTEBI       (),
                    .TESTACK          (),

                    .MCBUSGNT         (MCBUSGNT)
                    );

// -----------------------------------------------------------------------------
// Default Slave Instantiation
// -----------------------------------------------------------------------------
defslave udefslave                    (
                    .HCLK             (HCLK),
                    .HSEL             (DelDefSel),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS[1]),
                    .HRESP            (HRESPOutDef),
                    .HREADYIn         (HREADY),
                    .HREADYOut        (HREADYOutDef),
                    .HRDATAOut        (HRDATAOutDef)
                    );

// -----------------------------------------------------------------------------
// Master Buswatch Instantiation
// -----------------------------------------------------------------------------
buswatchmaster ubuswatchmaster        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS),
                    .HADDR            (HADDR),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HBUSREQx         (HBUSREQ),
                    .HGRANTx          (HGRANT),
                    .HREADY           (HREADY),
                    .HLOCKx           (HLOCK),
                    .HWDATA           (HWDATA),
                    .HPROT            (HPROT),
                    .HWRITE           (HWRITE),
                    .HRESP            (HRESP),
                    .ResetOver        ()
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

 initial
 begin
//$dumpvars();
//$dumpfile("/h/dump/arm/Smc.vcd");
//$dumpoff;
 end

always @(HREADYOut0 or CANCELSMWAIT)
begin
  #1;
  if ((CANCELSMWAIT == 1'b1) && (HREADYOut0 == 1'b0))
    CancelSmWaitCame = 1'b1;
  else if (HREADYOut0 == 1'b1)
    CancelSmWaitCame = 1'b0;
end

always @(posedge HREADYOut0)
begin
  if (CancelSmWaitCame == 1'b1)
    $display("Value of CancelSmWaitCame was %d at %t", CancelSmWaitCame, $time);
end

endmodule

// --================================ End ====================================--
