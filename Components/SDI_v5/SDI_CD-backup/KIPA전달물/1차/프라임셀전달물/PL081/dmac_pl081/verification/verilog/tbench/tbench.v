// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
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
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Top level of the DMAC Compliance TestBench
//
//           This file instantiates the DMAC module, the DMAC trickbox
//           the AHB decoder and the Default Slave.
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
// * HaltOnMismatch  : If HaltOnMismatch is set, it halts the
//                     simulation when it detects any error.
// * XonSig          : XonSig if set, enables signals to be unknown
//                     values; else signals will take their default
//                     values.
// * SuppressOnReset : SuppressOnReset suppresses all protocol checks
//                     on slave's output signals.
// * Databuswidth    : Databuswidth can be set to 64 or 32, depending
//                     upon the device to be tested.
//
// -----------------------------------------------------------------------------

`uselib lib=uut lib=trickbox

`include "../trickbox/DmacTrParams.v"
// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

`define ORBUS  1'b0
// If this bit is set, then testbench will have a OR bus configuration
// Else, by default, it will be a MUX implementation

// -----------------------------------------------------------------------------
// AHB Bus3 signals.
// Slave interface of the DMAC and the trickbox are connected here.
// -----------------------------------------------------------------------------
wire        HCLK;
wire        HRESETn;
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
wire [31:0] HADDR;
wire [63:0] HRDATA;
wire [63:0] HWDATA;

wire [15:0] HSPLITOut;
// -----------------------------------------------------------------------------
// AHB Bus3 arbitration signals
// -----------------------------------------------------------------------------
wire        HLOCK;
wire        HBUSREQ;
wire        HGRANT;

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

// -----------------------------------------------------------------------------
// Internal version of virtual registers
// -----------------------------------------------------------------------------
wire [31:0] iVRG0;
wire [31:0] iVRG1;
wire [31:0] iVRG2;
wire [31:0] iVRG3;

// -----------------------------------------------------------------------------
// DMAC response signals
// -----------------------------------------------------------------------------
wire        HREADYOutDmac;
wire [1:0]  HRESPOutDmac;
wire [63:0] HRDATAOutDmac;
wire [63:0] iHRDATAOutDmac;

// -----------------------------------------------------------------------------
// DMAC trickbox response signals
// -----------------------------------------------------------------------------
wire        HREADYOutDmacTr;
wire [1:0]  HRESPOutDmacTr;
wire [63:0] HRDATAOutDmacTr;
wire [63:0] iHRDATAOutDmacTr;

// -----------------------------------------------------------------------------
// Default slave signals
// -----------------------------------------------------------------------------
wire        HREADYOutDef;
wire [63:0] HRDATAOutDef;
wire [1:0]  HRESPOutDef;

reg  [15:0] DelHSEL;
wire        DefSlaveSel;
reg         DelDefSel;

// -----------------------------------------------------------------------------
// MUX bus signals
// -----------------------------------------------------------------------------
wire        iHREADYMUX;
wire        HREADYMUX;
wire [1:0]  HRESPMUX;
wire [63:0] HRDATAMUX;

// -----------------------------------------------------------------------------
// OR bus signals
// -----------------------------------------------------------------------------
wire        HREADYOR;
wire [1:0]  HRESPOR;
wire [63:0] HRDATAOR;

// -----------------------------------------------------------------------------
// Scan ports of DMAC
// -----------------------------------------------------------------------------
wire        SCANENABLE;
wire        SCANINHCLK;
wire        SCANOUTHCLK;

// -----------------------------------------------------------------------------
// AHB Bus1 signals.
// Master 1 of the DMAC and the trickbox are connected here.
// -----------------------------------------------------------------------------
wire        HWRITEM;
wire [2:0]  HSIZEM;
wire [2:0]  HBURSTM;
wire [3:0]  HPROTM;
wire [1:0]  HTRANSM;
wire [1:0]  HRESP1;
wire        HREADY1;
wire [31:0] HADDRM;
wire [63:0] HRDATA1;
wire [63:0] HWDATA1;
wire [63:0] StuffedHWDATA;

// -----------------------------------------------------------------------------
// AHB Bus1 arbitration signals
// -----------------------------------------------------------------------------
wire        HLOCKDMACM;
wire        HBUSREQDMACM;
wire        HGRANTDMACM;

// -----------------------------------------------------------------------------
// DMA Peripheral signals.
// -----------------------------------------------------------------------------
wire [15:0] DMACSREQ;
wire [15:0] DMACLSREQ;
wire [15:0] DMACBREQ;
wire [15:0] DMACLBREQ;

wire [15:0] DMACCLR;
wire [15:0] DMACTC;

// -----------------------------------------------------------------------------
// DMA Interrupt signals.
// -----------------------------------------------------------------------------
wire        DMACINTERR;
wire        DMACINTTC;
wire        DMACINTR;

// -----------------------------------------------------------------------------
// DMAC trickbox response signals for AHB Bus 1
// -----------------------------------------------------------------------------
wire        HREADYOutTr1;
wire [1:0]  HRESPOutTr1;
wire [63:0] HRDATAOutTr1;
wire [63:0] iHRDATAOutTr1;

// -----------------------------------------------------------------------------
// Default slave signals for AHB Bus 1
// -----------------------------------------------------------------------------
wire        HREADYOutDef1;
wire [63:0] HRDATAOutDef1;
wire [1:0]  HRESPOutDef1;

wire        HSELMEM1;
reg         DelHSELMEM1;
wire        DefSlaveSel1;
reg         DelDefSel1;

// -----------------------------------------------------------------------------
// MUX bus signals for AHB Bus 1
// -----------------------------------------------------------------------------
wire        iHREADY1MUX;
wire        HREADY1MUX;
wire [1:0]  HRESP1MUX;
wire [63:0] HRDATA1MUX;

// -----------------------------------------------------------------------------
// OR bus signals for AHB Bus 1
// -----------------------------------------------------------------------------
wire        HREADY1OR;
wire [1:0]  HRESP1OR;
wire [63:0] HRDATA1OR;

// -----------------------------------------------------------------------------
// MUX bus signals for AHB Bus 1 master
// -----------------------------------------------------------------------------
reg         DelHGRANTDMACM;
wire [1:0]  HTRANSMMux;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

defparam uahbslave_tb.Verbosity       = Verbosity;
defparam uahbslave_tb.HaltOnMismatch  = HaltOnMismatch;
defparam uahbslave_tb.XonSig          = XonSig;
defparam uahbslave_tb.Databuswidth    = Databuswidth;
defparam uahbslave_tb.SuppressOnReset = SuppressOnReset;

assign iVRG0            = VRG0;
assign iVRG1            = VRG1;
assign iVRG2            = VRG2;
assign iVRG3            = VRG3;

assign VRG4             = iVRG0;
assign VRG5             = iVRG1;
assign VRG7             = iVRG3;
assign VRG6             = iVRG2;
assign HLOCK            = 1'b0;
assign HBUSREQ          = 1'b1;
assign HGRANT           = 1'b1;

// -----------------------------------------------------------------------------
// AHB BUS3 CONFIGURATION
// The slave interfaces of the Dmac and the Trickbox are connected to
// this bus.
// -----------------------------------------------------------------------------

assign HREADY = (`ORBUS == 1'b1) ? HREADYOR : HREADYMUX;

assign HRESP  = (`ORBUS == 1'b1) ? HRESPOR : HRESPMUX;

assign HSPLITIn         = 16'b0;

assign HRDATA           = (`ORBUS == 1'b1) ? HRDATAOR : HRDATAMUX;

// -----------------------------------------------------------------------------
// Connect all the scan inputs to '0' to prevent interference with
// functional mode tests.
// -----------------------------------------------------------------------------
assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested
// -----------------------------------------------------------------------------
assign iHRDATAOutDmac   = (Databuswidth == 32) ?
                          {32'd0, HRDATAOutDmac[31:0]} : HRDATAOutDmac;

assign iHRDATAOutDmacTr = (Databuswidth == 32) ?
                          {32'd0, HRDATAOutDmacTr[31:0]} : HRDATAOutDmacTr;

// -----------------------------------------------------------------------------
// For MUX-bus implementations
// -----------------------------------------------------------------------------
assign HREADYMUX        = (DelHSEL[0] == 1'b1) ?
                           HREADYOutDmac   :
                          (DelHSEL[1] == 1'b1) ?
                           HREADYOutDmacTr   :
                          (DelDefSel == 1'b1)  ?
                           HREADYOutDef : 1'b0;

assign HRESPMUX         = (DelHSEL[0] == 1'b1) ?
                           HRESPOutDmac   :
                          (DelHSEL[1] == 1'b1) ?
                           HRESPOutDmacTr   :
                          (DelDefSel == 1'b1)  ?
                           HRESPOutDef : 2'b00;

assign HRDATAMUX        = (DelHSEL[0] == 1'b1) ?
                           iHRDATAOutDmac   :
                          (DelHSEL[1] == 1'b1) ?
                           iHRDATAOutDmacTr   :
                          (DelDefSel == 1'b1)  ?
                           HRDATAOutDef : 64'b0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus implementations
// -----------------------------------------------------------------------------
assign HRESPOR          = HRESPOutDmac | HRESPOutDmacTr | HRESPOutDef;

assign HREADYOR         = HREADYOutDmac | HREADYOutDmacTr | HREADYOutDef;

assign HRDATAOR         = iHRDATAOutDmac | iHRDATAOutDmacTr | HRDATAOutDef;

// -----------------------------------------------------------------------------
// Latching HSEL
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_HSELSeq
  if (HRESETn == 1'b0)
  begin
    DelHSEL   <= 16'h0000;
    DelDefSel <= 1'b1;
  end
  else
    if (HREADY == 1'b1)
    begin
      DelHSEL   <= HSEL;
      DelDefSel <= DefSlaveSel;
    end
end // p_HSELSeq;

// -----------------------------------------------------------------------------
// AHB BUS1 CONFIGURATION
// -----------------------------------------------------------------------------

assign HREADY1 = (`ORBUS == 1'b1) ? HREADY1OR : HREADY1MUX;

assign HRESP1  = (`ORBUS == 1'b1) ? HRESP1OR : HRESP1MUX;

assign HRDATA1 = (`ORBUS == 1'b1) ? HRDATA1OR : HRDATA1MUX;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave to be tested
// -----------------------------------------------------------------------------
assign iHRDATAOutTr1   = (Databuswidth == 32) ?
                          {32'd0, HRDATAOutTr1[31:0]} : HRDATAOutTr1;

// -----------------------------------------------------------------------------
// For MUX-bus implementations
// -----------------------------------------------------------------------------
assign HREADY1MUX        = (DelHSELMEM1 == 1'b1) ?
                           HREADYOutTr1 :
                          (DelDefSel1 == 1'b1)  ?
                           HREADYOutDef1 : 1'b0;

assign HRESP1MUX         = (DelHSELMEM1 == 1'b1) ?
                           HRESPOutTr1   :
                          (DelDefSel1 == 1'b1)  ?
                           HRESPOutDef1 : 2'b00;

assign HRDATA1MUX        = (DelHSELMEM1 == 1'b1) ?
                           iHRDATAOutTr1   :
                          (DelDefSel1 == 1'b1)  ?
                           HRDATAOutDef1 : 64'b0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus implementations
// -----------------------------------------------------------------------------
assign HRESP1OR          = HRESPOutTr1 | HRESPOutDef1;

assign HREADY1OR         = HREADYOutTr1 | HREADYOutDef1;

assign HRDATA1OR         = iHRDATAOutTr1 | HRDATAOutDef1;

// -----------------------------------------------------------------------------
// Generating HSEL
// -----------------------------------------------------------------------------
assign HSELMEM1   = (((HADDRM[31:0] >= `M0LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `M0HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `M1LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `M1HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P0LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P0HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P1LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P1HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P2LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P2HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P3LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P3HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P4LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P4HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P5LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P5HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P6LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P6HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P7LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P7HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P8LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P8HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P9LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P9HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P10LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P10HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P11LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P11HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P12LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P12HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P13LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P13HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P14LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P14HIGHADDRRANGE)) ||
                   ((HADDRM[31:0] >= `P15LOWADDRRANGE) &&
                     (HADDRM[31:0] <= `P15HIGHADDRRANGE))) ?
                   1'b1 : 1'b0;

assign DefSlaveSel1    = ~HSELMEM1;

// -----------------------------------------------------------------------------
// Latching HSEL
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_HSEL1Seq
  if (HRESETn == 1'b0)
  begin
    DelHSELMEM1 <= 1'b0;
    DelDefSel1  <= 1'b1;
  end
  else
    if (HREADY1 == 1'b1)
    begin
      DelHSELMEM1 <= HSELMEM1;
      DelDefSel1  <= DefSlaveSel1;
    end
end // p_HSEL1Seq;

// -----------------------------------------------------------------------------
// Latching HGRANTDMACM
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelHGRANT1Seq
  if (HRESETn == 1'b0)
    DelHGRANTDMACM <= 1'b0;
  else
    if (HREADY1 == 1'b1)
      DelHGRANTDMACM <= HGRANTDMACM;
end // p_DelHGRANT1Seq;

assign HTRANSMMux = (DelHGRANTDMACM == 1'b1) ? HTRANSM : 2'b00;

// -----------------------------------------------------------------------------
// AHB Slave Testbench instantiation
// -----------------------------------------------------------------------------
ahbslave_tb uahbslave_tb              (
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
                    .HSPLIT           (HSPLITIn),
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
// Address Decoder instantiation
// -----------------------------------------------------------------------------
decoder udecoder                      (
                    .HADDR            (HADDR),
                    .HSEL             (HSEL),
                    .DefSlaveSel      (DefSlaveSel)
                    );

// -----------------------------------------------------------------------------
// UUT instantiation (DMAC)
// -----------------------------------------------------------------------------
Dmac uut                              (
                    .HCLK              (HCLK),
                    .HRESETn           (HRESETn),
                    .HSELDMAC          (HSEL[0]),
                    .HWRITE            (HWRITE),
                    .HTRANS            (HTRANS[1]),
                    .HADDR             (HADDR[11:2]),
                    .HSIZE             (HSIZE),
                    .HREADYIN          (HREADY),
                    .HWDATA            (HWDATA[31:0]),
                    .HGRANTDMACM       (HGRANTDMACM),
                    .HREADYINM         (HREADY1),
                    .HRESPM            (HRESP1),
                    .HRDATAM           (HRDATA1[31:0]),
                    .DMACBREQ          (DMACBREQ),
                    .DMACLBREQ         (DMACLBREQ),
                    .DMACSREQ          (DMACSREQ),
                    .DMACLSREQ         (DMACLSREQ),
                    .SCANINHCLK        (SCANINHCLK),
                    .SCANENABLE        (SCANENABLE),
                    .HREADYOUT         (HREADYOutDmac),
                    .HRESP             (HRESPOutDmac),
                    .HRDATA            (HRDATAOutDmac[31:0]),
                    .HBUSREQDMACM      (HBUSREQDMACM),
                    .HLOCKDMACM        (HLOCKDMACM),
                    .HTRANSM           (HTRANSM),
                    .HADDRM            (HADDRM),
                    .HSIZEM            (HSIZEM),
                    .HBURSTM           (HBURSTM),
                    .HPROTM            (HPROTM),
                    .HWRITEM           (HWRITEM),
                    .HWDATAM           (HWDATA1[31:0]),
                    .DMACCLR           (DMACCLR),
                    .DMACTC            (DMACTC),
                    .DMACINTERR        (DMACINTERR),
                    .DMACINTTC         (DMACINTTC),
                    .DMACINTR          (DMACINTR),
                    .SCANOUTHCLK       (SCANOUTHCLK)
                    );

// -----------------------------------------------------------------------------
// DMAC Trickbox instantiation
// -----------------------------------------------------------------------------
DmacTrick uDmacTrick                   (
                    .HCLK              (HCLK),
                    .HRESETn           (HRESETn),
                    .HSELDMAC          (HSEL[0]),
                    .HSELDMACTr        (HSEL[1]),
                    .HWRITE            (HWRITE),
                    .HTRANS            (HTRANS[1]),
                    .HADDR             (HADDR[20:2]),
                    .HSIZE             (HSIZE),
                    .HREADYIN          (HREADY),
                    .HWDATA            (HWDATA[31:0]),
                    .HREADYINM         (HREADY1),
                    .HRESPMBeh         (HRESP1),
                    .HRDATAMBeh        (HRDATA1[31:0]),
                    .HBUSREQDMACM      (HBUSREQDMACM),
                    .HLOCKDMACM        (HLOCKDMACM),
                    .HTRANSM           (HTRANSMMux),
                    .HADDRM            (HADDRM),
                    .HSIZEM            (HSIZEM),
                    .HBURSTM           (HBURSTM),
                    .HPROTM            (HPROTM),
                    .HWRITEM           (HWRITEM),
                    .HWDATAM           (HWDATA1[31:0]),
                    .DMACCLR           (DMACCLR),
                    .DMACTC            (DMACTC),
                    .DMACINTERR        (DMACINTERR),
                    .DMACINTTC         (DMACINTTC),
                    .DMACINTR          (DMACINTR),
                    .HREADYOUT         (HREADYOutDmacTr),
                    .HRESP             (HRESPOutDmacTr),
                    .HRDATA            (HRDATAOutDmacTr[31:0]),
                    .HGRANTDMACM       (HGRANTDMACM),
                    .HREADYOUTM        (HREADYOutTr1),
                    .HRESPM            (HRESPOutTr1),
                    .HRDATAM           (HRDATAOutTr1[31:0]),
                    .DMACBREQ          (DMACBREQ),
                    .DMACLBREQ         (DMACLBREQ),
                    .DMACSREQ          (DMACSREQ),
                    .DMACLSREQ         (DMACLSREQ)
                    );

// -----------------------------------------------------------------------------
// Default Slave instantiation for AHB Bus3
// -----------------------------------------------------------------------------
defslave u0Defslave                    (
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
// Default Slave instantiation for AHB Bus1
// -----------------------------------------------------------------------------
defslave u1Defslave                    (
                    .HCLK             (HCLK),
                    .HSEL             (DelDefSel1),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANSM[1]),
                    .HRESP            (HRESPOutDef1),
                    .HREADYIn         (HREADY1),
                    .HREADYOut        (HREADYOutDef1),
                    .HRDATAOut        (HRDATAOutDef1)
                    );

defparam u0buswatchmaster.HaltOnMismatch = HaltOnMismatch;
defparam u0buswatchmaster.Verbosity      = Verbosity;
// defparam ubuswatchmaster.Tclk           = `Tclk;
// defparam ubuswatchmaster.Tovtr          = `Tovtr;
// defparam ubuswatchmaster.Tohtr          = `Tohtr;
// defparam ubuswatchmaster.Tova           = `Tova;
// defparam ubuswatchmaster.Toha           = `Toha;
// defparam ubuswatchmaster.Tovctl         = `Tovctl;
// defparam ubuswatchmaster.Tohctl         = `Tohctl;
// defparam ubuswatchmaster.Tovwd          = `Tovwd;
// defparam ubuswatchmaster.Tohwd          = `Tohwd;
// defparam ubuswatchmaster.Tovreq         = `Tovreq;
// defparam ubuswatchmaster.Tohreq         = `Tohreq;
// defparam ubuswatchmaster.Tovlck         = `Tovlck;
// defparam ubuswatchmaster.Tohlck         = `Tohlck;

// -----------------------------------------------------------------------------
// Master BusWatch instantiation
// -----------------------------------------------------------------------------
buswatchmaster u0buswatchmaster        (
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

defparam u1buswatchmaster.HaltOnMismatch = HaltOnMismatch;
defparam u1buswatchmaster.Verbosity      = Verbosity;
assign StuffedHWDATA  = {32'b0, HWDATA1[31:0]};

buswatchmaster u1buswatchmaster        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANSM),
                    .HADDR            (HADDRM),
                    .HSIZE            (HSIZEM),
                    .HBURST           (HBURSTM),
                    .HBUSREQx         (HBUSREQDMACM),
                    .HGRANTx          (HGRANTDMACM),
                    .HREADY           (HREADY1),
                    .HLOCKx           (HLOCKDMACM),
                    .HWDATA           (StuffedHWDATA),
                    .HPROT            (HPROTM),
                    .HWRITE           (HWRITEM),
                    .HRESP            (HRESP1),
                    .ResetOver        ()
                    );

// include system task for SDF delay annotation.
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

// --================================== End ==================================--
