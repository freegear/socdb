// --=================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : tbench.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           Top level of the VIC Compliance TestBench
//
//           This file instantiates the VIC module, the VIC trickbox
//           the AHB decoder and the Default Slave.
//
// --=================================================================--

`timescale 1ns/1ps

`include "../tbench/timing.v"
`include "../tbench/timingmaster.v"
`include "../common/defs.v"

// ---------------------------------------------------------------------

module tbench();
parameter Verbosity       = 0;
parameter HaltOnMismatch  = 0;
parameter XonSig          = 0;
parameter SuppressOnReset = 0;
parameter Databuswidth    = 32;

// ---------------------------------------------------------------------
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
// ---------------------------------------------------------------------

`uselib lib=uut lib=trickbox

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

`define ORBUS  1'b0
// If this bit is set, then testbench will have a OR bus configuration
// Else, by default, it will be a MUX implementation

// ---------------------------------------------------------------------
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
reg  [1:0]  HRESP;
reg         HREADY;
wire [15:0] HSPLITIn;
wire [3:0]  HMASTER;
wire [31:0] VRG0;
wire [31:0] VRG1;
wire [31:0] VRG2;
wire [31:0] VRG3;
wire [31:0] VRG4;
wire [31:0] VRG5;
wire [31:0] VRG6;
wire [31:0] VRG7;
wire [15:0] HSPLITOut;
wire        HREADYOut0;
wire        HREADYOut1;
wire [63:0] HRDATAOut0;
wire [63:0] HRDATAOut1;
wire [63:0] iHRDATAOut0;
wire [63:0] iHRDATAOut1;
wire [1:0]  HRESPOutDef;
wire        HREADYOutDef;
wire [63:0] HRDATAOutDef;
wire [1:0]  HRESPOut0;
wire [1:0]  HRESPOut1;
reg  [15:0] DelHSEL;
wire        DefSlaveSel;
reg         DelDefSel;
wire        iHREADYMUX;
wire        HREADYMUX;
wire        HREADYOR;
wire [1:0]  HRESPOR;
wire [1:0]  HRESPMUX;
wire [63:0] HRDATAMUX;
wire [63:0] HRDATAOR;
wire [31:0] iVRG0;
wire [31:0] iVRG1;
wire [31:0] iVRG2;
wire [31:0] iVRG3;
wire        nVICFIQ;
wire        nVICIRQ;
wire [31:0] VICVectAddrOut;
wire [31:0] VICIntSource;
wire [31:0] VICVectAddrIn;
wire        nVICFIQIn;
wire        nVICIRQIn;
wire        SCANENABLE;
wire        SCANINHCLK;
wire        SCANOUTHCLK;
wire        HLOCK;
wire        HBUSREQ;
wire        HGRANT;

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

defparam uahbslave_tb.Verbosity       = Verbosity;
defparam uahbslave_tb.HaltOnMismatch  = HaltOnMismatch;
defparam uahbslave_tb.XonSig          = XonSig;
defparam uahbslave_tb.Databuswidth    = Databuswidth;
defparam uahbslave_tb.SuppressOnReset = SuppressOnReset;

// ---------------------------------------------------------------------
// AHB Slave Testbench instantiation
// ---------------------------------------------------------------------
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
// ---------------------------------------------------------------------
// Address Decoder instantiation
// ---------------------------------------------------------------------
decoder udecoder                      (
                    .HADDR            (HADDR),
                    .HSEL             (HSEL),
                    .DefSlaveSel      (DefSlaveSel)
                    );

// ---------------------------------------------------------------------
// UUT instantiation (VIC)
// ---------------------------------------------------------------------

Vic uut                               (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HSELVIC          (HSEL[0]),
                    .HWRITE           (HWRITE),
                    .HREADYIN         (HREADY),
                    .HPROT            (HPROT[1]),
                    .HTRANS           (HTRANS[1]),
                    .HSIZE            (HSIZE),
                    .HADDR            (HADDR[11:2]),
                    .HWDATA           (HWDATA[31:0]),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINHCLK       (SCANINHCLK),
                    .VICINTSOURCE     (VICIntSource),
                    .nVICFIQIN        (nVICFIQIn),
                    .nVICIRQIN        (nVICIRQIn),
                    .VICVECTADDRIN    (VICVectAddrIn),
                    .HRDATA           (HRDATAOut0[31:0]),
                    .HREADYOUT        (HREADYOut0),
                    .HRESP            (HRESPOut0),
                    .SCANOUTHCLK      (SCANOUTHCLK),
                    .nVICFIQ          (nVICFIQ),
                    .nVICIRQ          (nVICIRQ),
                    .VICVECTADDROUT   (VICVectAddrOut)
                    );

defparam uVicTrick.Tclk = `Tclk;

// ---------------------------------------------------------------------
// Trickbox instantiation (VicTrick)
// ---------------------------------------------------------------------
VicTrick uVicTrick                    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HREADYIN         (HREADY),
                    .HADDR            (HADDR[11:2]),
                    .HTRANS           (HTRANS[1]),
                    .HSIZE            (HSIZE),
                    .HWRITE           (HWRITE),
                    .HPROT            (HPROT[1]),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELVICTR        (HSEL[1]),
                    .HSELVIC          (HSEL[0]),
                    .nVICFIQ          (nVICFIQ),
                    .nVICIRQ          (nVICIRQ),
                    .VICVECTADDROUT   (VICVectAddrOut),
                    .HRDATA           (HRDATAOut1[31:0]),
                    .HREADYOUT        (HREADYOut1),
                    .HRESP            (HRESPOut1),
                    .VICINTSOURCE     (VICIntSource),
                    .VICVECTADDRIN    (VICVectAddrIn),
                    .nVICFIQIN        (nVICFIQIn),
                    .nVICIRQIN        (nVICIRQIn)
                    );

// ---------------------------------------------------------------------
// Default Slave instantiation
// ---------------------------------------------------------------------
defslave uDefslave                    (
                    .HCLK             (HCLK),
                    .HSEL             (DelDefSel),
                    .HRESETn          (HRESETn),
                    .HTRANS           (HTRANS[1]),
                    .HRESP            (HRESPOutDef),
                    .HREADYIn         (HREADY),
                    .HREADYOut        (HREADYOutDef),
                    .HRDATAOut        (HRDATAOutDef)
                    );

defparam ubuswatchmaster.HaltOnMismatch = HaltOnMismatch;
defparam ubuswatchmaster.Verbosity      = Verbosity;
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

// ---------------------------------------------------------------------
// Master BusWatch instantiation
// ---------------------------------------------------------------------
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

assign iVRG0            = VRG0;
assign iVRG1            = VRG1;
assign iVRG2            = VRG2;
assign iVRG3            = VRG3;

assign VRG4             = iVRG0;
assign VRG5             = iVRG1;
assign VRG7             = iVRG3;
assign VRG6             = iVRG2;
assign HSPLITIn         = 15'b0;
assign SCANENABLE       = 1'b0;
assign SCANINHCLK       = 1'b0;
assign HLOCK            = 1'b0;
assign HBUSREQ          = 1'b1;
assign HGRANT           = 1'b1;

// ---------------------------------------------------------------------
assign HRDATA           = (`ORBUS == 1'b1) ? HRDATAOR : HRDATAMUX;

// ---------------------------------------------------------------------
// For MUX-bus implementations
// ---------------------------------------------------------------------
assign HREADYMUX        = (DelHSEL[0] == 1'b1) ?
                           HREADYOut0   :
                          (DelHSEL[1] == 1'b1) ?
                           HREADYOut1   :
                          (DelDefSel == 1'b1)  ?
                           HREADYOutDef : 1'b0;

assign HRESPMUX         = (DelHSEL[0] == 1'b1) ?
                           HRESPOut0   :
                          (DelHSEL[1] == 1'b1) ?
                           HRESPOut1   :
                          (DelDefSel == 1'b1)  ?
                           HRESPOutDef : 2'b00;

assign HRDATAMUX        = (DelHSEL[0] == 1'b1) ?
                           iHRDATAOut0   :
                          (DelHSEL[1] == 1'b1) ?
                           iHRDATAOut1   :
                          (DelDefSel == 1'b1)  ?
                           HRDATAOutDef : 64'b0000000000000000;

// ---------------------------------------------------------------------
// For OR bus implementations
// ---------------------------------------------------------------------
assign HRESPOR          = HRESPOut0 | HRESPOut1 | HRESPOutDef;

assign HREADYOR         = HREADYOut0 | HREADYOut1 | HREADYOutDef;

assign HRDATAOR         = iHRDATAOut0 | iHRDATAOut1 | HRDATAOutDef;

// ---------------------------------------------------------------------
// Initialise iHRDATAOutx for every slave being used
// ---------------------------------------------------------------------
assign iHRDATAOut0      = (Databuswidth == 32) ?
                          {32'd0, HRDATAOut0[31:0]} : HRDATAOut0;

assign iHRDATAOut1      = (Databuswidth == 32) ?
                          {32'd0, HRDATAOut1[31:0]} : HRDATAOut1;
// ---------------------------------------------------------------------
// Generating HREADY Output
// ---------------------------------------------------------------------
always @(HREADYOR or HREADYMUX or HRESETn)
begin : p_OutputSeq
  if (`ORBUS == 1'b1)
    HREADY = HREADYOR;
  else
    HREADY = HREADYMUX;
end

// ---------------------------------------------------------------------
// Generating HRESP Output
// ---------------------------------------------------------------------
always @(HRESPOR or HRESPMUX or HRESETn)
begin : p_RespSeq
  if (`ORBUS == 1'b1)
    HRESP = HRESPOR;
  else
    HRESP = HRESPMUX;
end

// ---------------------------------------------------------------------
// Latching HSEL
// ---------------------------------------------------------------------
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

// ---------------------------------------------------------------------
// Initialising HREADY signal
// ---------------------------------------------------------------------
initial
begin
  HREADY = 1'b1;
end

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

// initial
// begin
//   $dumpvars();
//   $dumpfile("/dump/arm/Vic.vcd");
// end

endmodule

// --============================== End ==============================--
