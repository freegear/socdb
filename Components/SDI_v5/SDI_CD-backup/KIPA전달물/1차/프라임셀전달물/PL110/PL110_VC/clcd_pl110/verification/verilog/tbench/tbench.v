// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : tbench.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Top level of the CLCD Compliance TestBench
//
//           This file instantiates the CLCD module, the CLCD trickbox
//           the AHB decoder and the Default Slave.
//
// --=========================================================================--

`timescale 1ns/1ps

`include "../tbench/timing.v"
`include "../tbench/timingmaster.v"
`include "../common/defs.v"

// -----------------------------------------------------------------------------

module tbench();
parameter
  Verbosity       = 0,
  HaltOnMismatch  = 0,
  XonSig          = 0,
  SuppressOnReset = 0,
  TestMode        = 0,
  Databuswidth    = 32;

// -----------------------------------------------------------------------------
// Note on PARAMETERS :
// * Verbosity :       To suppress messages other than error messages, 
//                     Verbosity has to be cleared.
// * HaltOnMismatch :  If HaltOnMismatch is set, then it halts the simulation 
//                     when it detects any error. 
// * XonSig :          XonSig if set enables signals to be unknown values, else 
//                     signals will take its default values.
// * SuppressOnReset : SuppressOnReset suppresses all protocol checkings on 
//                     slave's output signals.
// * TestMode :        TestMode if set, denotes test is being written in a Big 
//                     endianness mode. Else if cleared, it is in little 
//                     endianness mode.
// * Databuswidth :    Databuswidth can be set to 64 or 32, depending upon the 
//                     device to be tested. 
// -----------------------------------------------------------------------------

`uselib lib=uut lib=trickbox lib=tbench

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

`define ORBUS  1'b0
// If this bit is set, then testbench will have a OR bus configuration
// Else, by default, it will be a MUX implementation

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// AHB signals.
// -----------------------------------------------------------------------------
wire        HCLK;
wire        HRESETn;
wire [31:0] HADDR;
wire [63:0] HRDATA;
wire [63:0] HWDATA;
wire [15:0] HSEL;
wire        HMASTLOCK;
wire        HWRITE;
wire [2:0]  HSIZE;
wire [2:0]  HBURST;
wire [3:0]  HPROT;
wire [1:0]  HTRANS;
wire [1:0]  HRESP;
wire        HREADY;
wire [15:0] HSPLITIn;
wire [3:0]  HMASTER;

// -----------------------------------------------------------------------------
// Virtual registers
// -----------------------------------------------------------------------------
wire [31:0] VRG0;
wire [31:0] VRG1;
wire [31:0] VRG2;
wire [31:0] VRG3;
wire [31:0] VRG4;
wire [31:0] VRG5;
wire [31:0] VRG6;
wire [31:0] VRG7;
wire [15:0] HSPLITOut;

// -----------------------------------------------------------------------------
// Internal version of virtual registers
// -----------------------------------------------------------------------------
wire [31:0] iVRG0;
wire [31:0] iVRG1;
wire [31:0] iVRG2;
wire [31:0] iVRG3;

// -----------------------------------------------------------------------------
// Clcd response signals
// -----------------------------------------------------------------------------
wire        HREADYOutClcd;
wire [31:0] HRDATAOutClcd;
wire [31:0] iHRDATAOutClcd;
wire [1:0]  HRESPOutClcd;

// -----------------------------------------------------------------------------
// Clcd trickbox response signals
// -----------------------------------------------------------------------------
wire        HREADYOutClcdTr;
wire [31:0] HRDATAOutClcdTr;
wire [31:0] iHRDATAOutClcdTr;
wire [1:0]  HRESPOutClcdTr;

// -----------------------------------------------------------------------------
// Default slave signals
// -----------------------------------------------------------------------------
wire        HREADYOutDef;
wire [63:0] HRDATAOutDef;
wire [1:0]  HRESPOutDef;
wire        DefSlaveSel;
reg  [15:0] DelHSEL;
reg         DelDefSel;

// -----------------------------------------------------------------------------
// MUX bus signals
// -----------------------------------------------------------------------------
wire        HREADYMUX;
wire [63:0] HRDATAMUX;
wire [1:0]  HRESPMUX;

// -----------------------------------------------------------------------------
// OR bus signals
// -----------------------------------------------------------------------------
wire        HREADYOR;
wire [63:0] HRDATAOR;
wire [1:0]  HRESPOR;

// -----------------------------------------------------------------------------
// Scan ports of Clcd
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Clcd Master Port
// -----------------------------------------------------------------------------
wire [31:0] HADDRM;
wire [1:0]  HTRANSM;
wire [1:0]  HRESPM;
wire        HWRITEM;
wire [2:0]  HSIZEM;
wire [2:0]  HBURSTM;
wire [31:0] HRDATAM;
wire [3:0]  HPROTM;
wire        HLOCKM;
wire        HBUSREQM;
wire        HREADYINM;
wire        HGRANTM;
wire [63:0] HWDATATrCl;

// -----------------------------------------------------------------------------
// Clcd Non-Amba Ports
//-----------------------------------------------------------------------------
wire        CLPOWER;
wire        CLFP;
wire        CLLP;
wire        CLAC;
wire        CLCP;
wire        CLLE;
wire [23:0] CLD;
wire        CLCDCLKSEL;
wire        CLCDMBEINTR;
wire        CLCDFUFINTR;
wire        CLCDLNBUINTR;
wire        CLCDVCOMPINTR;
wire        CLCDINTR;
wire        nCLCDCLK;
wire        CLCDCLK;
wire        nCLCLKRESET;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

  defparam U_ahbslave_tb.Verbosity = Verbosity;
  defparam U_ahbslave_tb.HaltOnMismatch = HaltOnMismatch;
  defparam U_ahbslave_tb.XonSig = XonSig;
  defparam U_ahbslave_tb.TestMode = TestMode;
  defparam U_ahbslave_tb.Databuswidth = Databuswidth;
  defparam U_ahbslave_tb.SuppressOnReset = SuppressOnReset;

  assign iVRG0  = VRG0;
  assign iVRG1  = VRG1;
  assign iVRG2  = VRG2;
  assign iVRG3  = VRG3;

  assign VRG4   = iVRG0;
  assign VRG5   = iVRG1;
  assign VRG7   = iVRG3;
  assign VRG6   = iVRG2;

  assign HREADY   = (`ORBUS == 1'b1) ? HREADYOR : HREADYMUX;

  assign HRESP    = (`ORBUS == 1'b1) ? HRESPOR : HRESPMUX;

  assign HSPLITIn = 16'h0000;

  assign HRDATA   = (`ORBUS == 1'b1) ? HRDATAOR : HRDATAMUX;

  assign nCLCDCLK = ~CLCDCLK;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested
// -----------------------------------------------------------------------------
assign iHRDATAOutClcd   = (Databuswidth == 32) ?
                          {32'd0, HRDATAOutClcd[31:0]} : HRDATAOutClcd;

assign iHRDATAOutClcdTr = (Databuswidth == 32) ?
                          {32'd0, HRDATAOutClcdTr[31:0]} : HRDATAOutClcdTr;

// ----------------------------------------------------------------------------
// For MUX-bus implementations
// ----------------------------------------------------------------------------

  assign HREADYMUX = (DelHSEL[0] == 1'b1) ? HREADYOutClcd :
                     (DelHSEL[1] == 1'b1) ? HREADYOutClcdTr :
                     (DelDefSel  == 1'b1) ? HREADYOutDef  : 1'b0;

  assign HRESPMUX  = (DelHSEL[0] == 1'b1) ? HRESPOutClcd  :
                     (DelHSEL[1] == 1'b1) ? HRESPOutClcdTr  :
                     (DelDefSel  == 1'b1) ? HRESPOutDef   : 2'b00;

  assign HRDATAMUX = (DelHSEL[0] == 1'b1) ? iHRDATAOutClcd :
                     (DelHSEL[1] == 1'b1) ? iHRDATAOutClcdTr :
                     (DelDefSel  == 1'b1) ? HRDATAOutDef     :
                                            64'h0000000000000000;

// ----------------------------------------------------------------------------
// For OR bus implementations
// ----------------------------------------------------------------------------
  assign HRESPOR  = HRESPOutClcd | HRESPOutClcdTr | HRESPOutDef;

  assign HREADYOR = HREADYOutClcd | HREADYOutClcdTr | HREADYOutDef;

  assign HRDATAOR = {32'b0,iHRDATAOutClcd} | {32'b0,iHRDATAOutClcdTr}
                                           | HRDATAOutDef;

// ----------------------------------------------------------------------------
// Latching HSEL
// ----------------------------------------------------------------------------
always @(posedge HCLK or  negedge HRESETn)
begin : p_HSELSeq
  if (HRESETn == 1'b0)
  begin 
    DelHSEL <= 16'h0000;
    DelDefSel <= 1'b1;
  end
  else 
    if (HREADY == 1'b1)
    begin
      DelHSEL <= HSEL;
      DelDefSel <= DefSlaveSel;
    end
end // p_HSELSeq;

// -----------------------------------------------------------------------------
// AHB slave test bench entity
// -----------------------------------------------------------------------------

ahbslave_tb  U_ahbslave_tb (
                          .HCLK     (HCLK),
                          .HRESETn  (HRESETn),
                          .HADDR    (HADDR),
                          .HTRANS   (HTRANS),
                          .HWRITE   (HWRITE),
                          .HSIZE    (HSIZE),
                          .HBURST   (HBURST),
                          .HPROT    (HPROT),
                          .HMASTER  (HMASTER),
                          .HMASTLOCK (HMASTLOCK),
                          .HWDATA   (HWDATA),
                          .HSPLIT   (HSPLITIn),
                          .HRDATA   (HRDATA),
                          .HREADY   (HREADY),
                          .HRESP    (HRESP),
                          .VRG0     (VRG0),
                          .VRG1     (VRG1),
                          .VRG2     (VRG2),
                          .VRG3     (VRG3),
                          .VRG4     (VRG4),
                          .VRG5     (VRG5),
                          .VRG6     (VRG6),
                          .VRG7     (VRG7)
                         );

// -----------------------------------------------------------------------------
// Ahb slave decoder instantiation
// -----------------------------------------------------------------------------
 decoder U_decoder (
                    .HADDR       (HADDR),
                    .HSEL        (HSEL),    
                    .DefSlaveSel (DefSlaveSel) 
                   );

// -----------------------------------------------------------------------------
// UUT instantiation (CLCD Controller)
// -----------------------------------------------------------------------------
Clcd uut (
         // AHB Slave interface
                    .HCLK            (HCLK),
                    .HRESETn         (HRESETn),
                    .HSELCLCD        (HSEL[0]),
                    .HADDRS          (HADDR[11:2]),
                    .HTRANSS         (HTRANS),
                    .HWRITES         (HWRITE),
                    .HREADYINS       (HREADY),
                    .HREADYOUTS      (HREADYOutClcd),
                    .HRESPS          (HRESPOutClcd),
                    .HWDATAS         (HWDATA[31:0]),
                    .HRDATAS         (HRDATAOutClcd),

          // AHB BUS  (Master Interface)
                    .HADDRM          (HADDRM),
                    .HTRANSM         (HTRANSM),
                    .HWRITEM         (HWRITEM),
                    .HSIZEM          (HSIZEM),
                    .HBURSTM         (HBURSTM),
                    .HREADYINM       (HREADYINM),
                    .HRESPM          (HRESPM),
                    .HPROT           (HPROTM),
                    .HLOCK           (HLOCKM),
                    .HBUSREQM        (HBUSREQM),
                    .HGRANTM         (HGRANTM),
                    .HRDATAM         (HRDATAM[31:0]),
 
                        // LCD Panel
                    .CLPOWER         (CLPOWER),
                    .CLLP            (CLLP),
                    .CLCP            (CLCP),
                    .CLFP            (CLFP),
                    .CLAC            (CLAC),
                    .CLD             (CLD),
                    .CLLE            (CLLE),
 
                        // Clock source
                    .CLCDCLK         (CLCDCLK),
                    .nCLCDCLK        (nCLCDCLK),
                    .CLCDCLKSEL      (CLCDCLKSEL),
                    .nCLCLKRESET     (nCLCLKRESET),

                        // Interrupts
                    .CLCDMBEINTR     (CLCDMBEINTR),
                    .CLCDFUFINTR     (CLCDFUFINTR),
                    .CLCDLNBUINTR    (CLCDLNBUINTR),
                    .CLCDVCOMPINTR   (CLCDVCOMPINTR),
                    .CLCDINTR        (CLCDINTR),

                       // Scan interface
                    .SCANENABLE      (1'b0),
                    .SCANINHCLK      (1'b0),
                    .SCANINCLCDCLK   (1'b0),
                    .SCANINnCLCDCLK  (1'b0),
                    .SCANOUTHCLK     (),
                    .SCANOUTCLCDCLK  (),
                    .SCANOUTnCLCDCLK ()
                 );

// -----------------------------------------------------------------------------
// Clcd controller trick-box instantiation
// -----------------------------------------------------------------------------
CLTrick uCLTrick(
                 .HCLK       (HCLK),
                 .HRESETN    (HRESETn),
 
                // Main Bus Slave AHB Signals connected to Slave Testbench
                 .HADDRB     (HADDR[9:2]),
                 .HTRANSB    (HTRANS),
                 .HWRITEB    (HWRITE),
                 .HSELB      (HSEL[1]),
                 .HSELCom    (HSEL[0]),
                 .HSIZEB     (HSIZE),
                 .HBURSTB    (HBURST),
                 .HWDATAB    (HWDATA[31:0]),
                 .HRDATAB    (HRDATAOutClcdTr),
                 .HREADYBIn  (HREADY),
                 .HREADYBOut (HREADYOutClcdTr),
                 .HRESPB     (HRESPOutClcdTr),
 
                // CLCD AHB Signals
                 .HADDRC   (HADDRM),
                 .HTRANSC  (HTRANSM),
                 .HWRITEC  (HWRITEM),
                 .HSIZEC   (HSIZEM),
                 .HBURSTC  (HBURSTM),
                 .HRDATAC  (HRDATAM),
                 .HREADYC  (HREADYINM),
                 .HPROTC   (HPROTM),
                 .HLOCKC   (HLOCKM),
                 .HRESPC   (HRESPM),
                 .HBUSREQC (HBUSREQM),
                 .HGRANTC  (HGRANTM),
 
                // CLCD Panel Signals
                 .LCDCLK   (CLCDCLK),
                 .nCLCLKRESET (nCLCLKRESET),
                 .CLPOWER  (CLPOWER),
                 .CLFP     (CLFP),
                 .CLLP     (CLLP),
                 .CLCP     (CLCP),
                 .CLAC     (CLAC),
                 .CLD      (CLD),
                 .CLLE     (CLLE),
 
                 .CLCLKSEL (CLCDCLKSEL),
 
                // Interrupt Signals
                 .BEINTTR   (CLCDMBEINTR),
                 .FUFINTR   (CLCDFUFINTR),
                 .LNBUINTR  (CLCDLNBUINTR),
                 .VCOMPINTR (CLCDVCOMPINTR),
                 .INTR      (CLCDINTR)
               );


 defslave  U_Defslave (
                       .HCLK      (HCLK),
                       .HSEL      (DelDefSel),
                       .HRESETn   (HRESETn),
                       .HTRANS    (HTRANS[1]),
                       .HRESP     (HRESPOutDef),
                       .HREADYIn  (HREADY),
                       .HREADYOut (HREADYOutDef),
                       .HRDATAOut (HRDATAOutDef)
                      );

 defparam ubuswatchmaster.Verbosity = Verbosity;
 defparam ubuswatchmaster.HaltOnMismatch = HaltOnMismatch;

 buswatchmaster ubuswatchmaster (
                     .HCLK      (HCLK),
                     .HRESETn   (HRESETn),
                     .HTRANS    (HTRANSM),
                     .HADDR     (HADDRM),
                     .HSIZE     (HSIZEM),
                     .HBURST    (HBURSTM),
                     .HBUSREQx  (HBUSREQM),
                     .HGRANTx   (HGRANTM),
                     .HREADY    (HREADYINM),
                     .HLOCKx    (HLOCKM),
                     .HWDATA    (HWDATATrCl),
                     .HPROT     (HPROTM),
                     .HWRITE    (HWRITEM),
                     .HRESP     (HRESPM),
                     .ResetOver ()
                    );

// assigning non X values to HWDATATrCl so that BusWatcher does not flash error

  assign HWDATATrCl = 64'd0;

// ----------------------------------------------------------------------------
// include system task SDF delay annotation.
// ----------------------------------------------------------------------------
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
endmodule

// ================================== End =================================== --
