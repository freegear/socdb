// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : tbench_denali.v.rca
// File Revision          : 1.15
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
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

module tbench_denali();
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
wire        HREADYOut10;
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
wire [63:0] iHRDATAOut10;
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
wire [1:0]  HRESPOut10;
wire [1:0]  HRESPOR;
wire [1:0]  HRESPMUX;

// SSMC related signals
wire  [3:0] SMCLK;
wire [25:0] SMADDR;
tri1 [31:0] SMDATA;
wire [7:0]  SMCS;
wire [7:0]  nSMCS;
wire        nSMWEN;
wire [3:0]  nSMBLS;
wire        nSMOEN;
wire        SMBAA;
wire        SMADDRVALID;
wire [31:0] SMDATAOUT;
wire [31:0] SMDATAIN;
wire [3:0]  nSMDATAEN;
wire [1:0]  SMMWCS7;
wire        SMBLS7POL;
wire        SMBUSREQ;
wire        SMBUSGNT;
wire        SMWAIT;
wire        SMBUSGNTEBI;
wire        SMTICBUSGNTEBI;
wire        SMBIGENDIAN;
wire        SMEXTBUSMUX;
wire        SMBUSBACKOFFEBI;
wire [7:0]  nSMBURSTWAIT;
wire        nSMMEMCLK;

// External Wait Control related signals
wire [7:0]  SMCActLowCS;
wire        SMCANCELWAIT;

// TIC signals
wire        HGRANTTIC;
wire        SMTESTREQA;
wire        SMTESTREQB;
wire        SMTESTACK;

// Scan test related signals
wire        SCANENABLE;
wire        SCANINHCLK;
wire        SCANINFBCLK0;
wire        SCANINFBCLK1;
wire        SCANINFBCLK2;
wire        SCANINFBCLK3;
wire        SCANINSMMemCLK;
wire        SCANINnSMMemCLK;
wire        SCANINCLKDELAY;

wire        SCANOUTHCLK;
wire        SCANOUTSMMEMCLK;
wire        SCANOUTnSMMEMCLK;
wire        SCANOUTCLKDELAY;
wire        SCANOUTFBCLK0;
wire        SCANOUTFBCLK1;
wire        SCANOUTFBCLK2;
wire        SCANOUTFBCLK3;

// Trickbox related signals
wire        SMBUSREQEBI;
wire        SMTICBUSREQEBI;

wire [1:0]  SMMemClkRatio;
wire        SMFBCLK; 
wire        SMMemCLK;

// Denali model related signal
wire        nWRD;
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

assign HSPLIT           = 15'b0;

assign HRDATA           = (`ORBUS == 1'b1) ? HRDATAOR : HRDATAMUX;

assign HBUSREQ          = 1'b1;

assign HGRANT           = 1'b1;

assign HLOCK            = 1'b0;

assign HGRANTTIC        = 1'b0;

assign SMTESTREQA       = 1'b0;

assign SMTESTREQB       = 1'b0;

// assign SMTICBUSGNTEBI   = 1'b0;

//assign SMBUSGNTEBI      = 1'b0;

//assign SMEXTBUSMUX      = 1'b0;

assign nWRD             = 1'b1;

assign nSMBURSTWAIT     = 8'b11111111;

assign nSMMEMCLK        = ~SMMemCLK;

// -----------------------------------------------------------------------------
// Connect all the scan inputs to '0' to prevent interference with functional
// mode tests.
// -----------------------------------------------------------------------------
assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;
assign SCANINFBCLK0     = 1'b0;
assign SCANINFBCLK1     = 1'b0;
assign SCANINFBCLK2     = 1'b0;
assign SCANINFBCLK3     = 1'b0;
assign SCANINSMMemCLK   = 1'b0;
assign SCANINnSMMemCLK  = 1'b0;
assign SCANINCLKDELAY   = 1'b0;
// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested
// -----------------------------------------------------------------------------
assign iHRDATAOut0      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut1      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut2      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut3      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut4      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut5      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut6      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut7      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut8      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut1[31:0]} : HRDATAOut1;

assign iHRDATAOut9      = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut2[31:0]} : HRDATAOut2;

assign iHRDATAOut10     = (Databuswidth == 32) ?
                          {32'h00000000, HRDATAOut3[31:0]} : HRDATAOut3;

// -----------------------------------------------------------------------------
// For MUX bus Implementations
// -----------------------------------------------------------------------------
assign HREADYMUX        = (DelHSEL[0] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[1] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[2] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[3] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[4] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[5] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[6] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[7] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[8] == 1'b1) ?
                           HREADYOut1   :
                          (DelHSEL[9] == 1'b1) ?
                           HREADYOut2   :
                          (DelHSEL[10] == 1'b1) ?
                           HREADYOut3   :
                          (DelDefSel == 1'b1) ?
                           HREADYOutDef : 1'b0;

assign HRESPMUX         = (DelHSEL[0] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[1] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[2] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[3] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[4] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[5] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[6] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[7] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[8] == 1'b1) ?
                           HRESPOut1   :
                          (DelHSEL[9] == 1'b1) ?
                           HRESPOut2   :
                          (DelHSEL[10] == 1'b1) ?
                           HRESPOut3   :
                          (DelDefSel == 1'b1) ?
                           HRESPOutDef : 2'b00;

assign HRDATAMUX        = (DelHSEL[0] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[1] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[2] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[3] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[4] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[5] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[6] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[7] == 1'b1) ?
                           iHRDATAOut0  :
                          (DelHSEL[8] == 1'b1) ?
                           iHRDATAOut8  :
                          (DelHSEL[9] == 1'b1) ?
                           iHRDATAOut9  :
                          (DelHSEL[10] == 1'b1) ?
                           iHRDATAOut10  :
                          (DelDefSel == 1'b1) ?
                           HRDATAOutDef : 64'h0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus Implementations
// -----------------------------------------------------------------------------
assign HRESPOR          = HRESPOut0 | HRESPOut1 | HRESPOut2 |
                          HRESPOut3 | HRESPOut4 | HRESPOut5 |
                          HRESPOut6 | HRESPOut7 | HRESPOut8 |
                          HRESPOut9 | HRESPOut10 | HRESPOutDef;

assign HREADYOR         = HREADYOut0 | HREADYOut1 | HREADYOut2 |
                          HREADYOut3 | HREADYOut4 | HREADYOut5 |
                          HREADYOut6 | HREADYOut7 | HREADYOut8 |
                          HREADYOut9 | HREADYOut10 | HREADYOutDef;

assign HRDATAOR         = iHRDATAOut0 | iHRDATAOut1 | iHRDATAOut2 |
                          iHRDATAOut3 | iHRDATAOut4 | iHRDATAOut5 |
                          iHRDATAOut6 | iHRDATAOut7 | iHRDATAOut8 |
                          iHRDATAOut9 | iHRDATAOut10 | HRDATAOutDef;

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

// -----------------------------------------------------------------------------
// Memory Data Bus multiplexing
// -----------------------------------------------------------------------------
assign SMDATA[7:0]      = (nSMDATAEN[0] == 1'b0) ? SMDATAOUT[7:0]   :
                           8'bzzzzzzzz;

assign SMDATA[15:8]     = (nSMDATAEN[1] == 1'b0) ? SMDATAOUT[15:8]  :
                           8'bzzzzzzzz;

assign SMDATA[23:16]    = (nSMDATAEN[2] == 1'b0) ? SMDATAOUT[23:16] :
                           8'bzzzzzzzz;

assign SMDATA[31:24]    = (nSMDATAEN[3] == 1'b0) ? SMDATAOUT[31:24] :
                           8'bzzzzzzzz;

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
decoder udecoder   (
                    .HADDR            (HADDR),
                    .HSEL             (HSEL),
                    .DefSlaveSel      (DefSlaveSel)
                   );

// -----------------------------------------------------------------------------
// SSMC Trickbox Instantiation
// -----------------------------------------------------------------------------
defparam uSsmcTrick.Tclk  = `Tclk;
defparam uSsmcTrick.Tclks = `Tclks;
defparam uSsmcTrick.Tclkl = `Tclkl;
defparam uSsmcTrick.Tclkh = `Tclkh;

SsmcTrick uSsmcTrick
                   (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[5:2]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HREADYINTr       (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELSSMCTr       (HSEL[9]),

                    .SMDATAOUT        (SMDATAOUT),
                    .SMADDR           (SMADDR),
                    .SSMTrCS          (SMCS),
                    .nSSMTrCS         (nSMCS),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMBUSREQEBI      (SMBUSREQEBI),
                    .SMTICBUSREQEBI   (SMTICBUSREQEBI),
                    .HRDATATr         (HRDATAOut2[31:0]),
                    .HREADYOUTTr      (HREADYOut2),
                    .HRESPTr          (HRESPOut2),
                    .SMEXTBUSMUX      (SMEXTBUSMUX),
                    .BIGENDIAN       (SMBIGENDIAN),

                    .SMMWCS7          (SMMWCS7),
                    .SMWAIT           (SMWAIT),
                    .SMCANCELWAIT     (SMCANCELWAIT),
                    .SMBUSGNTEBI      (SMBUSGNTEBI),
                    .SMBUSBACKOFFEBI  (SMBUSBACKOFFEBI),
                    .SMTICBUSGNTEBI   (SMTICBUSGNTEBI),
                    .SMFBCLK          (SMFBCLK),
                    .SMMemCLK         (SMMemCLK),
                    .SMMemClkRatio    (SMMemClkRatio),
                    .SMBLS7POL        (SMBLS7POL)
                   );

// -----------------------------------------------------------------------------
// Denali Memory model (SRAM 1) Instantiation for Memory Bank 0
// -----------------------------------------------------------------------------
defparam usram1.memory_spec = "../../denali/sram1.spc";
defparam usram1.init_file   = "../../denali/sram1.dat";

sram1 usram1        (
                    .address          (SMADDR[16:0]),
                    .nCS              (nSMCS[0]),
                    .nWE              (nSMBLS[0]),
                    .nOE              (nSMOEN),
                    .Data             (SMDATA[7:0])
                    );

// -----------------------------------------------------------------------------
// Denali Memory model (SRAM 2) Instantiation for Memory Bank 1
// -----------------------------------------------------------------------------
defparam usram2.memory_spec = "../../denali/sram2.spc";
defparam usram2.init_file   = "../../denali/sram2.dat";

sram2 usram2        (
                    .address          (SMADDR[15:0]),
                    .nCS              (nSMCS[1]),
                    .nWE              (nSMWEN),
                    .nOE              (nSMOEN),
                    .nBLS             (nSMBLS[1:0]),
                    .Data             (SMDATA[15:0])
                    );

// -----------------------------------------------------------------------------
// Denali Memory model (FLASH 1) Instantiation for Memory Bank 2
// -----------------------------------------------------------------------------
defparam uflash1.memory_spec = "../../denali/flash1.spc";
defparam uflash1.init_file   = "../../denali/flash1.dat";

flash1 uflash1      (
                    .address          (SMADDR[21:0]),
                    .Data             (SMDATA[15:0]),
                    .nCS              (nSMCS[2]),
                    .nOE              (nSMOEN),
                    .nWE              (nSMWEN)
                    );

// -----------------------------------------------------------------------------
// Denali Memory model (FLASH 2) Instantiation for Memory Bank 3
// -----------------------------------------------------------------------------
defparam uflash2.memory_spec = "../../denali/flash2.spc";
defparam uflash2.init_file   = "../../denali/flash2.dat";

flash2 uflash2                        (
                    .address          (SMADDR[18:0]),
                    .Data             (SMDATA[15:0]),
                    .nCS              (nSMCS[3]),
                    .nOE              (nSMOEN),
                    .nWE              (nSMWEN)
                    );

// -----------------------------------------------------------------------------
// Denali Memory model (MROM 1) Instantiation for Memory Bank 4
// -----------------------------------------------------------------------------
defparam umrom1.memory_spec = "../../denali/mrom1.spc";
defparam umrom1.init_file   = "../../denali/mrom1.dat";

mrom1 umrom1                          (
                    .address          (SMADDR[18:0]),
                    .nCS              (nSMCS[4]),
                    .nOE              (nSMOEN),
                    .Data             (SMDATA),
                    .nWRD             (nWRD)
                    );

// -----------------------------------------------------------------------------
// Denali Memory model (MROM 2) Instantiation for Memory Bank 5
// -----------------------------------------------------------------------------
defparam umrom2.memory_spec = "../../denali/mrom2.spc";
defparam umrom2.init_file   = "../../denali/mrom2.dat";

mrom2 umrom2                          (
                    .address          (SMADDR[19:0]),
                    .nCS              (nSMCS[5]),
                    .nOE              (nSMOEN),
                    .Data             (SMDATA),
                    .nWRD             (nWRD)
                    );

// -----------------------------------------------------------------------------
// Denali Memory model (SRAM 3) Instantiation for Memory Bank 6
// -----------------------------------------------------------------------------
defparam usram3.memory_spec = "../../denali/sram3.spc";
defparam usram3.init_file   = "../../denali/sram3.dat";

sram3 usram3        (
                    .address          (SMADDR[15:0]),
                    .nCS              (nSMCS[6]),
                    .nWE              (nSMWEN),
                    .nOE              (nSMOEN),
                    .nBLS             (nSMBLS[1:0]),
                    .Data             (SMDATA[15:0])
                    );

// -----------------------------------------------------------------------------
// Denali Memory model (SRAM 4) Instantiation for Memory Bank 7
// -----------------------------------------------------------------------------
defparam usram4.memory_spec = "../../denali/sram4.spc";
defparam usram4.init_file   = "../../denali/sram4.dat";

sram4 usram4        (
                    .address          (SMADDR[16:0]),
                    .nCS              (nSMCS[7]),
                    .nWE              (nSMWEN),
                    .nOE              (nSMOEN),
                    .Data             (SMDATA[7:0])
                    );

// -----------------------------------------------------------------------------
// UUT Instantiation (SSMC)
// -----------------------------------------------------------------------------
Ssmc uut           (
                    .HCLK             (HCLK),
                    .SMMEMCLK         (SMMemCLK),
                    .nSMMEMCLK        (nSMMEMCLK),
                    .SMMEMCLKDELAY    (nSMMEMCLK),
                    .SMFBCLK0         (SMFBCLK),
                    .SMFBCLK1         (SMFBCLK),
                    .SMFBCLK2         (SMFBCLK),
                    .SMFBCLK3         (SMFBCLK),
                    .HRESETn          (HRESETn),
                    .HADDRSMC         (HADDR[25:0]),
                    .HTRANSSMC        (HTRANS),
                    .HWRITESMC        (HWRITE),
                    .HSIZESMC         (HSIZE),
                    .HBURSTSMC        (HBURST),
                    .HWDATASMC        (HWDATA[31:0]),
                    .HSELSMC          (HSEL[7:0]),
                    .HREADYINSMC      (HREADY),
                    .HADDRREG         (HADDR[11:2]),
                    .HTRANSREG        (HTRANS),
                    .HWRITEREG        (HWRITE),
                    .HSIZEREG         (HSIZE),
                    .HWDATAREG        (HWDATA[31:0]),
                    .HSELREG          (HSEL[8]),
                    .HREADYINREG      (HREADY),
                    .HREADYINTIC      (HREADY),
                    .HRESPTIC         (HRESP),
                    .HRDATATIC        (HRDATA[31:0]),
                    .HGRANTTIC        (HGRANTTIC),
                    .SMBUSGNTEBI      (SMBUSGNTEBI),
                    .SMBUSBACKOFFEBI  (SMBUSBACKOFFEBI),
                    .SMTICBUSGNTEBI   (SMTICBUSGNTEBI),
                    .SMBIGENDIAN      (SMBIGENDIAN),
                    .SMEXTBUSMUX      (SMEXTBUSMUX),
 
                    .SCANENABLE       (SCANENABLE),
                    .SCANINHCLK       (SCANINHCLK),
                    .SCANINSMMEMCLK   (SCANINSMMemCLK),
                    .SCANINnSMMEMCLK  (SCANINnSMMemCLK),
                    .SCANINCLKDELAY   (SCANINCLKDELAY),
                    .SCANINFBCLK0     (SCANINFBCLK0),
                    .SCANINFBCLK1     (SCANINFBCLK1),
                    .SCANINFBCLK2     (SCANINFBCLK2),
                    .SCANINFBCLK3     (SCANINFBCLK3),
                    .SMMWCS7          (SMMWCS7),
                    .SMBLS7POL        (SMBLS7POL),
                    .SMMEMCLKRATIO    (SMMemClkRatio),
                    .SMWAIT           (SMWAIT),
                    .SMCANCELWAIT     (SMCANCELWAIT),
                    .nSMBURSTWAIT     (nSMBURSTWAIT),
                    .SMDATAIN         (SMDATAIN),

                    .SMTESTREQA       (SMTESTREQA),
                    .SMTESTREQB       (SMTESTREQB),

                    .HRDATASMC        (HRDATAOut0[31:0]),
                    .HREADYOUTSMC     (HREADYOut0),
                    .HRESPSMC         (HRESPOut0),
                    .HRDATAREG        (HRDATAOut1[31:0]),
                    .HREADYOUTREG     (HREADYOut1),
                    .HRESPREG         (HRESPOut1),
                    .HADDRTIC         (),
                    .HTRANSTIC        (),
                    .HWRITETIC        (),
                    .HSIZETIC         (),
                    .HBURSTTIC        (),
                    .HPROTTIC         (),
                    .HWDATATIC        (),
                    .HBUSREQTIC       (),
                    .HLOCKTIC         (),

                    .SMBUSREQEBI      (SMBUSREQEBI),
                    .SMTICBUSREQEBI   (SMTICBUSREQEBI),

                    .SCANOUTHCLK      (SCANOUTHCLK),
                    .SCANOUTSMMEMCLK  (SCANOUTSMMEMCLK),
                    .SCANOUTnSMMEMCLK (SCANOUTnSMMEMCLK),
                    .SCANOUTFBCLK0    (SCANOUTFBCLK0),
                    .SCANOUTFBCLK1    (SCANOUTFBCLK1),
                    .SCANOUTFBCLK2    (SCANOUTFBCLK2),
                    .SCANOUTFBCLK3    (SCANOUTFBCLK3),
                    .SCANOUTCLKDELAY  (SCANOUTCLKDELAY),

                    .SMCLK            (SMCLK),
                    .SMDATAOUT        (SMDATAOUT),
                    .SMBAA            (SMBAA),
                    .SMADDRVALID      (SMADDRVALID),
                    .SMADDR           (SMADDR),
                    .SMCS0            (SMCS[0]),
                    .SMCS1            (SMCS[1]),
                    .SMCS2            (SMCS[2]),
                    .SMCS3            (SMCS[3]),
                    .SMCS4            (SMCS[4]),
                    .SMCS5            (SMCS[5]),
                    .SMCS6            (SMCS[6]),
                    .SMCS7            (SMCS[7]),
                    .nSMCS0           (nSMCS[0]),
                    .nSMCS1           (nSMCS[1]),
                    .nSMCS2           (nSMCS[2]),
                    .nSMCS3           (nSMCS[3]),
                    .nSMCS4           (nSMCS[4]),
                    .nSMCS5           (nSMCS[5]),
                    .nSMCS6           (nSMCS[6]),
                    .nSMCS7           (nSMCS[7]),
                    .nSMDATAEN        (nSMDATAEN),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),

                    .SMTESTACK        (SMTESTACK)
                   );

// -----------------------------------------------------------------------------
// Default Slave Instantiation
// -----------------------------------------------------------------------------
defslave udefslave  (
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
buswatchmaster ubuswatchmaster
                    (
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

//initial
//  begin
//    $dumpvars();
//    $dumpfile("/home/tbhatt/vcd/check.vcd");
//  end
endmodule

// --================================ End ====================================--
