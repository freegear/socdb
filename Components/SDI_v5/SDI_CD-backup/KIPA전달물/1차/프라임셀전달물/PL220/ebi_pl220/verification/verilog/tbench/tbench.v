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
// File Name              : tbench.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose : 
//           Top level of the EBI Compliance TestBench
//
//           This file instantiates the EBI module, the EBI trickbox
//           the AHB decoder and the Default Slave. 
//
// --=========================================================================--

`timescale 1ns/1ps

`include "../tbench/timing.v"
`include "../tbench/timingmaster.v"
`include "../common/defs.v"

`include "../trickbox/EbiTrParams.v"

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
// -----------------------------------------------------------------------------

`uselib lib=uut lib=trickbox

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define ORBUS        1'b0
// If this bit is set, the testbench will have an OR bus configuration
// Else, by default, it will be a MUX implementation.

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        HCLK;
wire        HRESETn;

// Virtual registers (AHB 0).
wire [31:0] VRG0;
wire [31:0] VRG1;
wire [31:0] VRG2;
wire [31:0] VRG3;
wire [31:0] VRG4;
wire [31:0] VRG5;
wire [31:0] VRG6;
wire [31:0] VRG7;

// Internal version of virtual registers (AHB 0).
wire [31:0] iVRG0;
wire [31:0] iVRG1;
wire [31:0] iVRG2;
wire        iVRG3;

// EBI Trickbox Response signals for AHB 0.
wire        HREADYOutEBITr;
wire  [1:0] HRESPOutEBITr;
wire [63:0] HRDATAOutEBITr;
wire [63:0] iHRDATAOutEBITr;

// -----------------------------------------------------------------------------
// EBI Signal declarations
// -----------------------------------------------------------------------------
wire        EBICLK;
// External Bus Interface Clock

wire        nPOR;
// Power On Reset

wire        EBIREQ1;
// EBI request for Port 1, Active high

wire [31:0] EBIADDR1;
// EBI Address for Port 1

wire [31:0] EBIDATA1;
// EBI Data for Port 1

wire  [3:0] nEBIDATAEN1;
// EBI Data Enable for port 1

wire  [9:0] EBITIMEOUTVALUE1;
// Gives the value to be loaded into timeout counter for port 1.

wire        EBIREQ2;
// EBI request for Port 2, Active high

wire [31:0] EBIADDR2;
// EBI Address for Port 2

wire [31:0] EBIDATA2;
// EBI Data for Port 2

wire  [3:0] nEBIDATAEN2;
// EBI Data Enable for port 2

wire  [9:0] EBITIMEOUTVALUE2;
// Gives the value to be loaded into timeout counter for port 2.

wire        EBIREQ3;
// EBI request for Port 3, Active high

wire [31:0] EBIADDR3;
// EBI Address for Port 2

wire [31:0] EBIDATA3;
// EBI Data for Port 2

wire  [3:0] nEBIDATAEN3;
// EBI Data Enable for port 3

wire  [9:0] EBITIMEOUTVALUE3;
// Gives the value to be loaded into timeout counter for port 3.

wire [31:0] EBIEXTDATAIN;
// External Data input for the Pads

wire        SCANENABLE;
// Scan enable signal

wire        SCANINEBICLK;
// Scan input signal

wire        EBIGNT1;
// EBI Grant for port 1

wire        EBIBACKOFF1;
// EBIBACKOFF signal for port 1 Indicates to Controller-1 that the current
// transfer should be completed as soon as possible.

wire        EBIGNT2;
// EBI Grant for port 2

wire        EBIBACKOFF2;
// EBIBACKOFF signal for port 2 Indicates to Controller-2 that the current
// transfer should be completed as soon as possible.

wire        EBIGNT3;
// EBI Grant for port 3

wire        EBIBACKOFF3;
// EBIBACKOFF signal for port 3 Indicates to Controller-3 that the current
// transfer should be completed as soon as possible.

wire [31:0] EBIEXTDATAOUT;
// Data output to the pads

wire [31:0] EBIEXTADDROUT;
// Address output to the pads

wire  [3:0] nEBIEXTDATAEN;
// Data Enable to the Pads

wire [31:0] EBIDATAIN;
// Data input connected to all the Controllers

wire        SCANOUTEBICLK;
// Scan output signal


// AHB Bus signals.
wire        HWRITE;
wire [2:0]  HSIZE;
wire [2:0]  HBURST;
wire [3:0]  HPROT;
wire [1:0]  HTRANS;
wire [1:0]  HRESP;
wire        HREADY;
wire [31:0] HADDR;
wire [63:0] HRDATA;
wire [63:0] HWDATA;
wire [15:0] HSPLIT;
wire [3:0]  HMASTER;
wire        HMASTLOCK;

// Default Slave signals for AHB Bus
wire        HREADYOutDef;
wire [63:0] HRDATAOutDef;
wire  [1:0] HRESPOutDef;

wire        DefSlaveSel;
reg         DelDefSel;

// Decoder Signals
wire [15:0] HSEL;
reg  [15:0] DelHSEL;

// MUX Bus signals for AHB Bus0.
wire        HREADYMUX;
wire  [1:0] HRESPMUX;
wire [63:0] HRDATAMUX;

// OR Bus signals for AHB Bus0.
wire        HREADYOR;
wire  [1:0] HRESPOR;
wire [63:0] HRDATAOR;

// AHB Bus Arbitration signals.
wire        HLOCK;
wire        HBUSREQ;
wire        HGRANT;

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// VRGs (AHB0)
// -----------------------------------------------------------------------------
assign iVRG0           = VRG0;
assign iVRG1           = VRG1;
assign iVRG2           = VRG2;
assign iVRG3           = VRG3;

assign VRG4            = iVRG0;
assign VRG5            = iVRG1;
assign VRG7            = iVRG3;
assign VRG6            = iVRG2;

// -----------------------------------------------------------------------------
//  Assigning HLOCKx to '0'
// -----------------------------------------------------------------------------
assign HLOCK            = 1'b0;

// -----------------------------------------------------------------------------
//  AHB BUS CONFIGURATION
// -----------------------------------------------------------------------------
assign HREADY          = (`ORBUS == 1'b1) ? HREADYOR : HREADYMUX;

assign HRESP           = (`ORBUS == 1'b1) ? HRESPOR : HRESPMUX;

assign HSPLIT          = 16'h0000;

assign HRDATA          = (`ORBUS == 1'b1) ? HRDATAOR : HRDATAMUX;

// -----------------------------------------------------------------------------
// Initialise iHRDATAOut for every slave to be tested 
// -----------------------------------------------------------------------------
assign iHRDATAOutEBITr  = (Databuswidth == 32) ?
                           {32'h00000000, HRDATAOutEBITr[31:0]} :
                            HRDATAOutEBITr;

// -----------------------------------------------------------------------------
// For MUX-bus implementations
// When trickbox is selected, the bus will remain with trickbox. Else it default
// will be selected.
// -----------------------------------------------------------------------------
assign HREADYMUX        = (DelHSEL[8] == 1'b1) ? HREADYOutEBITr :
                          (DelDefSel == 1'b1)  ? HREADYOutDef   :
                          1'b0;

assign HRESPMUX         = (DelHSEL[8] == 1'b1) ? HRESPOutEBITr :
                          (DelDefSel == 1'b1)  ? HRESPOutDef   :
                          2'b00;

assign HRDATAMUX        = (DelHSEL[8] == 1'b1) ? iHRDATAOutEBITr :
                          (DelDefSel == 1'b1)  ? HRDATAOutDef    :
                           64'h0000000000000000;

// -----------------------------------------------------------------------------
// For OR bus implementations
// -----------------------------------------------------------------------------
assign HRESPOR          = HRESPOutEBITr | HRESPOutDef;

assign HREADYOR         = HREADYOutEBITr | HREADYOutDef;

assign HRDATAOR         = iHRDATAOutEBITr | HRDATAOutDef;

// -----------------------------------------------------------------------------
// Latching HSEL0
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelHSELSeq
  if (HRESETn == 1'b0)
    begin
      DelHSEL   <= 9'b000000000;
      DelDefSel <= 1'b1;
    end
  else if (HREADY == 1'b1)
    begin
      DelHSEL   <= HSEL;
      DelDefSel <= DefSlaveSel;
    end
end // p_DelHSELSeq
 
// -----------------------------------------------------------------------------
// Connect all the scan inputs to '0' to prevent interference with
// functional mode tests.
// -----------------------------------------------------------------------------
assign SCANENABLE       = 1'b0;
assign SCANINEBICLK     = 1'b0;

// -----------------------------------------------------------------------------
// AHB Slave Testbench_0 instantiation
// -----------------------------------------------------------------------------
defparam uahbslv_tb.INFILE          = "../../bustest/invec/bif0.sim";
defparam uahbslv_tb.Verbosity       = Verbosity;
defparam uahbslv_tb.HaltOnMismatch  = HaltOnMismatch;
defparam uahbslv_tb.XonSig          = XonSig;
defparam uahbslv_tb.Databuswidth    = Databuswidth;
defparam uahbslv_tb.SuppressOnReset = SuppressOnReset;

ahbslave_tb uahbslv_tb                (
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
// Address Decoder instantiation
// -----------------------------------------------------------------------------
decoder udecoder                      (
                    .HADDR            (HADDR),
                    .HSEL             (HSEL),
                    .DefSlaveSel      (DefSlaveSel)
                    );

// -----------------------------------------------------------------------------
// Default Slave Instantiation for AHB Bus0
// -----------------------------------------------------------------------------
Defslave uDefslave                    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HSEL             (DefSlaveSel),
                    .HTRANS           (HTRANS[1]),
                    .HRESP            (HRESPOutDef),
                    .HREADYIn         (HREADY),
                    .HREADYOut        (HREADYOutDef),
                    .HRDATAOut        (HRDATAOutDef)
                    );

// -----------------------------------------------------------------------------
// Master Buswatch Instantiation (AHB0)
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
// Unit Under Test (EBI)
// -----------------------------------------------------------------------------
Ebi uut                               (
                    .EBICLK           (EBICLK),
                    .nPOR             (nPOR),
                    .EBIREQ1          (EBIREQ1),
                    .EBIADDR1         (EBIADDR1),
                    .EBIDATA1         (EBIDATA1),
                    .nEBIDATAEN1      (nEBIDATAEN1),
                    .EBITIMEOUTVALUE1 (EBITIMEOUTVALUE1),
                    .EBIREQ2          (EBIREQ2),
                    .EBIADDR2         (EBIADDR2),
                    .EBIDATA2         (EBIDATA2),
                    .nEBIDATAEN2      (nEBIDATAEN2),
                    .EBITIMEOUTVALUE2 (EBITIMEOUTVALUE2),
                    .EBIREQ3          (EBIREQ3),
                    .EBIADDR3         (EBIADDR3),
                    .EBIDATA3         (EBIDATA3),
                    .nEBIDATAEN3      (nEBIDATAEN3),
                    .EBITIMEOUTVALUE3 (EBITIMEOUTVALUE3),
                    .EBIEXTDATAIN     (EBIEXTDATAIN),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINEBICLK     (SCANINEBICLK),
                    .EBIGNT1          (EBIGNT1),
                    .EBIBACKOFF1      (EBIBACKOFF1),
                    .EBIGNT2          (EBIGNT2),
                    .EBIBACKOFF2      (EBIBACKOFF2),
                    .EBIGNT3          (EBIGNT3),
                    .EBIBACKOFF3      (EBIBACKOFF3),
                    .EBIEXTDATAOUT    (EBIEXTDATAOUT),
                    .EBIEXTADDROUT    (EBIEXTADDROUT),
                    .nEBIEXTDATAEN    (nEBIEXTDATAEN),
                    .EBIDATAIN        (EBIDATAIN),
                    .SCANOUTEBICLK    (SCANOUTEBICLK)
                   );

// -----------------------------------------------------------------------------
// EBI Trickbox
// -----------------------------------------------------------------------------
defparam uEbiTrick.Tclkl = `Tclkl;
defparam uEbiTrick.Tclkh = `Tclkh;
defparam uEbiTrick.Tclks = `Tclks;

EbiTrick uEbiTrick                    (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR[11:2]),
                    .HTRANS           (HTRANS),
                    .HWRITE           (HWRITE),
                    .HSIZE            (HSIZE),
                    .HREADYIN         (HREADY),
                    .HWDATA           (HWDATA[31:0]),
                    .HSELEBITRICKBOX  (HSEL[8]),
                    .EBIGNT1          (EBIGNT1),
                    .EBIGNT2          (EBIGNT2),
                    .EBIGNT3          (EBIGNT3),
                    .EBIBACKOFF1      (EBIBACKOFF1),
                    .EBIBACKOFF2      (EBIBACKOFF2),
                    .EBIBACKOFF3      (EBIBACKOFF3),
                    .nEBIEXTDATAEN    (nEBIEXTDATAEN),
                    .EBIEXTADDROUT    (EBIEXTADDROUT),
                    .EBIEXTDATAOUT    (EBIEXTDATAOUT),
                    .EBIDATAIN        (EBIDATAIN),
                    .EBICLK           (EBICLK),
                    .EBIREQ1          (EBIREQ1),
                    .EBIREQ2          (EBIREQ2),
                    .EBIREQ3          (EBIREQ3),
                    .nPOR             (nPOR),
                    .HREADYOUT        (HREADYOutEBITr),
                    .HRESP            (HRESPOutEBITr),
                    .HRDATA           (HRDATAOutEBITr[31:0]),
                    .EBIADDR1         (EBIADDR1),
                    .EBIADDR2         (EBIADDR2),
                    .EBIADDR3         (EBIADDR3),
                    .EBIDATA1         (EBIDATA1),
                    .EBIDATA2         (EBIDATA2),
                    .EBIDATA3         (EBIDATA3),
                    .nEBIDATAEN1      (nEBIDATAEN1),
                    .nEBIDATAEN2      (nEBIDATAEN2),
                    .nEBIDATAEN3      (nEBIDATAEN3),
                    .EBIEXTDATAIN     (EBIEXTDATAIN),
                    .EBITIMEOUTVALUE1 (EBITIMEOUTVALUE1),
                    .EBITIMEOUTVALUE2 (EBITIMEOUTVALUE2),
                    .EBITIMEOUTVALUE3 (EBITIMEOUTVALUE3)
                   );

endmodule

// --================================ End ====================================--
