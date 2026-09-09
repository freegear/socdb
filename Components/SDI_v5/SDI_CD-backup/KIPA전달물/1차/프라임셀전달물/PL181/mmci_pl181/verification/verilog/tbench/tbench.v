// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
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
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose : Top level of the MMCI Compliance TestBench
//           This file instantiates the MMCI module, the MMCI trickbox
//           and the Read Data Mux.
//
// --=========================================================================--

`timescale 1ns/1ps
`include "../tbench/timing.v"
`uselib lib=uut lib=trickbox

module tbench ();

// -----------------------------------------------------------------------------
//
//                               tbench
//                               ======
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//  Top level testbench.This file integrates the MMCI, MMCI trickbox and
// the APB interface modules to enable system level testing.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// If the XonPSEL constant is set to '0' (default), an 1'bX appearing
// on the PSEL line will be converted to '0'. If this constant is set
// to '1', the PSEL generated internally by the testbench is passed on
// unmodified.
// -----------------------------------------------------------------------------
`define XonPSEL                  1'b0
`define MMCIFBCLK_TO_MMCICLK_DELAY 3

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        PCLK;
wire        PENABLE;
wire        PRESETn;
wire [31:0] I_PADDR;

wire        PWRITE;
wire        PSEL;
wire        I_PSEL;
wire        I_PWRITE;
wire        PSELT;
wire        I_PSELT;
wire [31:0] PRDATA0;
wire [31:0] PRDATA1;
wire [31:0] PRDATA;
wire [31:0] PWDATA;

wire [31:0] VRG0;
wire [31:0] VRG1;
wire [31:0] VRG2;
wire [31:0] VRG3;
wire [31:0] VRG4;
wire [31:0] VRG5;
wire [31:0] VRG6;
wire [31:0] VRG7;

wire        MMCICLKOUT;
wire        MMCIPWR;
wire  [3:0] MMCIVDD;
wire        MMCIROD;
wire        MMCIINTR0;
wire        MMCIINTR1;
wire        MMCIDMASREQ;
wire        MMCIDMABREQ;
wire        MMCIDMALSREQ;
wire        MMCIDMALBREQ;
wire        MMCICMD;
wire        MMCIDAT;
wire        MCLK;
wire        nMMCIRST;
wire        MMCIDMACLR;

wire        SCANENABLE;
wire        SCANINPCLK;
wire        SCANINMCLK;
wire        SCANINnMCLK;
wire        SCANINMMCIFBCLK;
wire        nMCLK;
wire        MMCIFBCLK;
wire        SCANOUTPCLK;
wire        SCANOUTMCLK;
wire        SCANOUTnMCLK;
wire        SCANOUTMMCIFBCLK;
wire        MMCICMDOUT;
wire        MMCICMDIN;
wire        nMMCICMDEN;
wire        MMCIDATOUT;
wire        MMCIDATIN;
wire        nMMCIDATEN;
integer     i;

reg  [31:0] PADDR;
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// Connect all the scan inputs to '0' to prevent interference with
// functional mode tests.
assign SCANENABLE       = 1'b0;
assign SCANINPCLK       = 1'b0;
assign SCANINMCLK       = 1'b0;
assign SCANINnMCLK      = 1'b0;
assign SCANINMMCIFBCLK  = 1'b0;
assign nMCLK            = ~MCLK;

assign #(`MMCIFBCLK_TO_MMCICLK_DELAY) MMCIFBCLK = MMCICLKOUT;

assign PSEL             = (`XonPSEL == 1'b0 && I_PSEL === 1'bX) ? 1'b0 :
                           I_PSEL;
assign PSELT            = (`XonPSEL == 1'b0 && I_PSELT === 1'bX) ?
                                                     1'b0 : I_PSELT;
assign PWRITE           = (`XonPSEL == 1'b0 && I_PWRITE === 1'bX) ?
                            1'b0 : I_PWRITE;

always @(I_PADDR)
begin : p_PADDR
  for(i=0;i<=31;i=i+1)
  begin
   if ((`XonPSEL == 1'b0) && (I_PADDR[i] === 1'bX))
     PADDR[i] = 1'b0;
   else
     PADDR[i] = I_PADDR[i];
  end
end // p_PADDR

// All the unconnected Virtual Register inputs should be set to zero:
assign VRG0 [31:0]      = 32'h00000000;
assign VRG1 [31:0]      = 32'h00000000;
assign VRG2 [31:0]      = 32'h00000000;
assign VRG3 [31:0]      = 32'h00000000;
assign VRG4 [31:0]      = 32'h00000000;
assign VRG5 [31:0]      = 32'h00000000;
assign VRG6 [31:0]      = 32'h00000000;
assign VRG7 [31:0]      = 32'h00000000;

defparam u_apbslv_tb.PRDATA_mask = 32'hFFFFFFFF;
defparam u_apbslv_tb.INFILE = "";
defparam u_apbslv_tb.Verbosity = 0;
defparam u_apbslv_tb.HaltOnMismatch = 0;
defparam u_apbslv_tb.tclks = `Tclks;
defparam u_apbslv_tb.tclkl = `Tclkl;
defparam u_apbslv_tb.tclkh = `Tclkh;

APBSLAVE_TB   u_apbslv_tb             (
                    .PRESETn          (PRESETn),
                    .PCLK             (PCLK),
                    .PADDR            (I_PADDR),
                    .PWRITE           (I_PWRITE),
                    .PENABLE          (PENABLE),
                    .PSEL             (I_PSEL),
                    .PSELT            (I_PSELT),
                    .PRDATA           (PRDATA),
                    .PWDATA           (PWDATA),
                    .VRG0             (VRG0),
                    .VRG1             (VRG1),
                    .VRG2             (VRG2),
                    .VRG3             (VRG3),
                    .VRG4             (VRG4),
                    .VRG5             (VRG5),
                    .VRG6             (VRG6),
                    .VRG7             (VRG7)
           );

MmciTrick   u_MmciTrick               (
                    .PRESETn          (PRESETn),
                    .PCLK             (PCLK),
                    .PSEL             (PSEL),
                    .PSELT            (PSELT),
                    .PWRITE           (PWRITE),
                    .PENABLE          (PENABLE),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA),
                    .MMCICLKOUT       (MMCICLKOUT),
                    .MMCIPWR          (MMCIPWR),
                    .MMCIVDD          (MMCIVDD),
                    .MMCIROD          (MMCIROD),
                    .MMCIINTR0        (MMCIINTR0),
                    .MMCIINTR1        (MMCIINTR1),
                    .MMCIDMASREQ      (MMCIDMASREQ),
                    .MMCIDMABREQ      (MMCIDMABREQ),
                    .MMCIDMALSREQ     (MMCIDMALSREQ),
                    .MMCIDMALBREQ     (MMCIDMALBREQ),
                    .MMCICMD          (MMCICMD),
                    .MMCIDAT          (MMCIDAT),
                    .MCLK             (MCLK),
                    .nMMCIRST         (nMMCIRST),
                    .MMCIDMACLR       (MMCIDMACLR),
                    .PRDATA           (PRDATA1)
           );

Mmci uut                              (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANINMCLK       (SCANINMCLK),
                    .SCANINnMCLK      (SCANINnMCLK),
                    .SCANINMMCIFBCLK   (SCANINMMCIFBCLK),
                    .MMCIDMACLR       (MMCIDMACLR),
                    .MCLK             (MCLK),
                    .nMCLK            (nMCLK),
                    .MMCIFBCLK        (MMCIFBCLK),
                    .nMMCIRST         (nMMCIRST),
                    .MMCICMDIN        (MMCICMDIN),
                    .MMCIDATIN        (MMCIDATIN),
                    .PRDATA           (PRDATA0),
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .SCANOUTMCLK      (SCANOUTMCLK),
                    .SCANOUTnMCLK     (SCANOUTnMCLK),
                    .SCANOUTMMCIFBCLK (SCANOUTMMCIFBCLK),
                    .MMCIINTR0        (MMCIINTR0),
                    .MMCIINTR1        (MMCIINTR1),
                    .MMCIDMASREQ      (MMCIDMASREQ),
                    .MMCIDMABREQ      (MMCIDMABREQ),
                    .MMCIDMALSREQ     (MMCIDMALSREQ),
                    .MMCIDMALBREQ     (MMCIDMALBREQ),
                    .MMCICLKOUT       (MMCICLKOUT),
                    .MMCICMDOUT       (MMCICMDOUT),
                    .nMMCICMDEN       (nMMCICMDEN),
                    .MMCIDATOUT       (MMCIDATOUT),
                    .nMMCIDATEN       (nMMCIDATEN),
                    .MMCIPWR          (MMCIPWR),
                    .MMCIROD          (MMCIROD),
                    .MMCIVDD          (MMCIVDD)
           );

apbmux   u_apbmux                     (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PSELT            (PSELT),
                    .PRData0          (PRDATA0),
                    .PRData1          (PRDATA1),
                    .PRData           (PRDATA)
           );

// -----------------------------------------------------------------------------
// Tri-state the MMCICMD line if the nMMCICMDEN is high
// -----------------------------------------------------------------------------
// The MMCICMD signal feeds the trickbox. Note that the 1'bZ assigment
// is required since the trickbox protocol checks depend on this
// in OpenDrain mode.

assign MMCICMD           = nMMCICMDEN == 1'b0 ? MMCICMDOUT : 1'bZ;

// The MMCICMDIN signal feeds the MMCI. Note that the 'H' assigment
// is required (as against a 1'bZ assignment) to prevent 1'bX
// propagation during netlist simulations.

assign MMCICMDIN         = MMCICMD !== 1'bZ ? MMCICMD : 1'b1;

// -----------------------------------------------------------------------------
// Tri-state the MMCIDAT line if the nMMCIDATEN is high
// -----------------------------------------------------------------------------
// The MMCIDAT[0] signal feeds the trickbox. Note that the 1'bZ assigment
// is required since the trickbox protocol checks depend on this.

assign MMCIDAT           = nMMCIDATEN == 1'b0 ? MMCIDATOUT : 1'bZ;

// The MMCIDATIN[0] signal feeds the MMCI. Note that the 'H' assigment
// is required (as against a 1'bZ assignment) to prevent 1'bX
// propagation during netlist simulations.

assign MMCIDATIN         = MMCIDAT !== 1'bZ ? MMCIDAT : 1'b1;

// include system task for best/worst case SDF delay annotation.
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

/*
initial
begin
  $dumpvars();
  $dumpfile("/NIS/backup/ARMOURY1/sathyar/mcinet.vcd");
end
*/

endmodule

// --================================== End ==================================--
