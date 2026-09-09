// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : tbench.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose : Top level of the AACI Compliance TestBench
//           This file instantiates the AACI module, the AACI trickbox
//           and the Read Data Mux.
//
// --=================================================================--

`timescale 1ns/1ps
`include "../tbench/timing.v"
`uselib lib=uut lib=trickbox

module tbench ();

// ---------------------------------------------------------------------
//
//                               tbench
//                               ======
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//  Top level testbench.This file integrates the AACI, AACI trickbox and
// the APB interface modules to enable system level testing.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// If the XonPSEL constant is set to '0' (default), an 1'bX appearing
// on the PSEL line will be converted to '0'. If this constant is set
// to '1', the PSEL generated internally by the testbench is passed on
// unmodified.
// ---------------------------------------------------------------------
`define XonPSEL                  1'b0

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
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

// interrupt signals
wire        AACIINTR;
wire        AACITXINTR1;
wire        AACITXINTR2;
wire        AACITXINTR3;
wire        AACITXINTR4;
wire        AACIRXINTR1;
wire        AACIRXINTR2;
wire        AACIRXINTR3;
wire        AACIRXINTR4;
wire        AACIORINTR1;
wire        AACIORINTR2;
wire        AACIORINTR3;
wire        AACIORINTR4;
wire        AACITXCINTR1;
wire        AACITXCINTR2;
wire        AACITXCINTR3;
wire        AACITXCINTR4;
wire        AACIURINTR1;
wire        AACIURINTR2;
wire        AACIURINTR3;
wire        AACIURINTR4;
wire        AACIRXTOINTR1;
wire        AACIRXTOINTR2;
wire        AACIRXTOINTR3;
wire        AACIRXTOINTR4;
wire        AACIWINTR;
wire        AACIGPIOINTR;
wire        AACIS1RXINTR;
wire        AACIS2RXINTR;
wire        AACIS12RXINTR;
wire        AACIS1TXINTR;
wire        AACIS2TXINTR;
wire        AACIS12TXINTR;
wire        AACIRXTOFEINTR1;
wire        AACIRXTOFEINTR2;
wire        AACIRXTOFEINTR3;
wire        AACIRXTOFEINTR4;

// AC link ports
wire        AACISYNC;
wire        AACIRESET;
wire        AACISDATAOUT;
wire        AACISDATAIN;
wire        AACIBITCLK;
wire        nAACIBITCLK;

// DMA signals
wire        AACIDMASREQRX;
wire        AACIDMALSREQRX;
wire        AACIDMABREQRX;
wire        AACIDMALBREQRX;
wire        AACIDMABREQTX;
wire        AACIDMACLRRX;
wire        AACIDMACLRTX;

// Scan related signals
wire        SCANENABLE;
wire        SCANINPCLK;
wire        SCANINBITCLK;
wire        SCANINnBITCLK;

// nFAACIBITCLKRST signal
wire        nAACIBITCLKRST;
wire        nFAACIBITCLKRST;

integer     i;

reg  [31:0] PADDR;
// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// Connect all the scan inputs to '0' to prevent interference with
// functional mode tests.
assign SCANENABLE       = 1'b0;
assign SCANINPCLK       = 1'b0;
assign SCANINBITCLK     = 1'b0;
assign SCANINnBITCLK    = 1'b0;

assign nAACIBITCLK      = ~AACIBITCLK;

assign PSEL             = (`XonPSEL == 1'b0 && I_PSEL === 1'bX) ? 1'b0 :
                           I_PSEL;
assign PSELT            = (`XonPSEL == 1'b0 && I_PSELT === 1'bX) ? 1'b0 :
                           I_PSELT;
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
defparam u_apbslv_tb.INFILE = "infile.bif";
defparam u_apbslv_tb.Verbosity = 0;
defparam u_apbslv_tb.HaltOnMismatch = 0;
defparam u_apbslv_tb.tclks = `Tclks;
defparam u_apbslv_tb.tclkl = `Tclkl;
defparam u_apbslv_tb.tclkh = `Tclkh;

APBSLAVE_TB u_apbslv_tb               (
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

AaciTrick uAaciTrick                  (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSELT),
                    .PSELCOM          (PSEL),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA),

                    .AACIDMASREQRX    (AACIDMASREQRX),
                    .AACIDMALSREQRX   (AACIDMALSREQRX),
                    .AACIDMABREQRX    (AACIDMABREQRX),
                    .AACIDMALBREQRX   (AACIDMALBREQRX),
                    .AACIDMABREQTX    (AACIDMABREQTX),

                    .AACIINTR         (AACIINTR),
                    .AACITXINTR1      (AACITXINTR1),
                    .AACITXINTR2      (AACITXINTR2),
                    .AACITXINTR3      (AACITXINTR3),
                    .AACITXINTR4      (AACITXINTR4),
                    .AACIRXINTR1      (AACIRXINTR1),
                    .AACIRXINTR2      (AACIRXINTR2),
                    .AACIRXINTR3      (AACIRXINTR3),
                    .AACIRXINTR4      (AACIRXINTR4),
                    .AACIORINTR1      (AACIORINTR1),
                    .AACIORINTR2      (AACIORINTR2),
                    .AACIORINTR3      (AACIORINTR3),
                    .AACIORINTR4      (AACIORINTR4),
                    .AACITXCINTR1     (AACITXCINTR1),
                    .AACITXCINTR2     (AACITXCINTR2),
                    .AACITXCINTR3     (AACITXCINTR3),
                    .AACITXCINTR4     (AACITXCINTR4),
                    .AACIURINTR1      (AACIURINTR1),
                    .AACIURINTR2      (AACIURINTR2),
                    .AACIURINTR3      (AACIURINTR3),
                    .AACIURINTR4      (AACIURINTR4),
                    .AACIRXTOINTR1    (AACIRXTOINTR1),
                    .AACIRXTOINTR2    (AACIRXTOINTR2),
                    .AACIRXTOINTR3    (AACIRXTOINTR3),
                    .AACIRXTOINTR4    (AACIRXTOINTR4),
                    .AACIWINTR        (AACIWINTR),
                    .AACIGPIOINTR     (AACIGPIOINTR),
                    .AACIS1RXINTR     (AACIS1RXINTR),
                    .AACIS2RXINTR     (AACIS2RXINTR),
                    .AACIS12RXINTR    (AACIS12RXINTR),
                    .AACIS1TXINTR     (AACIS1TXINTR),
                    .AACIS2TXINTR     (AACIS2TXINTR),
                    .AACIS12TXINTR    (AACIS12TXINTR),
                    .AACIRXTOFEINTR1  (AACIRXTOFEINTR1),
                    .AACIRXTOFEINTR2  (AACIRXTOFEINTR2),
                    .AACIRXTOFEINTR3  (AACIRXTOFEINTR3),
                    .AACIRXTOFEINTR4  (AACIRXTOFEINTR4),

                    .AACIRESET        (AACIRESET),
                    .AACISYNC         (AACISYNC),
                    .AACISDATAIN      (AACISDATAOUT),
                    .AACISDATAOUT     (AACISDATAIN),
                    .AACIBITCLK       (AACIBITCLK),

                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .nFAACIBITCLKRST  (nFAACIBITCLKRST),
                    .AACIDMACLRRX     (AACIDMACLRRX),
                    .AACIDMACLRTX     (AACIDMACLRTX),
                    .PRDATA           (PRDATA1)
                    );

Aaci uut                              (
                    .PCLK             (PCLK),
                    .AACIBITCLK       (AACIBITCLK),
                    .nAACIBITCLK      (nAACIBITCLK),
                    .PRESETn          (PRESETn),
                    .nAACIBITCLKRST   (nAACIBITCLKRST),
                    .nFAACIBITCLKRST  (nFAACIBITCLKRST),
                    .PSEL             (PSEL),
                    .PENABLE          (PENABLE),
                    .PWRITE           (PWRITE),
                    .AACIDMACLRRX     (AACIDMACLRRX),
                    .AACIDMACLRTX     (AACIDMACLRTX),
                    .SCANENABLE       (SCANENABLE),
                    .SCANINPCLK       (SCANINPCLK),
                    .SCANINBITCLK     (SCANINBITCLK),
                    .SCANINnBITCLK    (SCANINnBITCLK),
                    .AACISDATAIN      (AACISDATAIN),
                    .PADDR            (PADDR[11:2]),
                    .PWDATA           (PWDATA),
                    .AACIRESET        (AACIRESET),
                    .AACISYNC         (AACISYNC),
                    .AACITXINTR1      (AACITXINTR1),
                    .AACITXINTR2      (AACITXINTR2),
                    .AACITXINTR3      (AACITXINTR3),
                    .AACITXINTR4      (AACITXINTR4),
                    .AACIRXINTR1      (AACIRXINTR1),
                    .AACIRXINTR2      (AACIRXINTR2),
                    .AACIRXINTR3      (AACIRXINTR3),
                    .AACIRXINTR4      (AACIRXINTR4),
                    .AACIORINTR1      (AACIORINTR1),
                    .AACIORINTR2      (AACIORINTR2),
                    .AACIORINTR3      (AACIORINTR3),
                    .AACIORINTR4      (AACIORINTR4),
                    .AACIURINTR1      (AACIURINTR1),
                    .AACIURINTR2      (AACIURINTR2),
                    .AACIURINTR3      (AACIURINTR3),
                    .AACIURINTR4      (AACIURINTR4),
                    .AACITXCINTR1     (AACITXCINTR1),
                    .AACITXCINTR2     (AACITXCINTR2),
                    .AACITXCINTR3     (AACITXCINTR3),
                    .AACITXCINTR4     (AACITXCINTR4),
                    .AACIRXTOINTR1    (AACIRXTOINTR1),
                    .AACIRXTOINTR2    (AACIRXTOINTR2),
                    .AACIRXTOINTR3    (AACIRXTOINTR3),
                    .AACIRXTOINTR4    (AACIRXTOINTR4),
                    .AACIWINTR        (AACIWINTR),
                    .AACIGPIOINTR     (AACIGPIOINTR),
                    .AACIS12RXINTR    (AACIS12RXINTR),
                    .AACIS12TXINTR    (AACIS12TXINTR),
                    .AACIS2RXINTR     (AACIS2RXINTR),
                    .AACIS2TXINTR     (AACIS2TXINTR),
                    .AACIS1RXINTR     (AACIS1RXINTR),
                    .AACIS1TXINTR     (AACIS1TXINTR),
                    .AACIRXTOFEINTR1  (AACIRXTOFEINTR1),
                    .AACIRXTOFEINTR2  (AACIRXTOFEINTR2),
                    .AACIRXTOFEINTR3  (AACIRXTOFEINTR3),
                    .AACIRXTOFEINTR4  (AACIRXTOFEINTR4),

                    .AACIINTR         (AACIINTR),
                    .AACIDMASREQRX    (AACIDMASREQRX),
                    .AACIDMALSREQRX   (AACIDMALSREQRX),
                    .AACIDMABREQRX    (AACIDMABREQRX),
                    .AACIDMALBREQRX   (AACIDMALBREQRX),
                    .AACIDMABREQTX    (AACIDMABREQTX),
                    .SCANOUTPCLK      (SCANOUTPCLK),
                    .SCANOUTBITCLK    (SCANOUTBITCLK),
                    .SCANOUTnBITCLK   (SCANOUTnBITCLK),
                    .AACISDATAOUT     (AACISDATAOUT),
                    .PRDATA           (PRDATA0)
                    );

apbmux u_apbmux                       (
                    .PCLK             (PCLK),
                    .PRESETn          (PRESETn),
                    .PSEL             (PSEL),
                    .PSELT            (PSELT),
                    .PRData0          (PRDATA0),
                    .PRData1          (PRDATA1),
                    .PRData           (PRDATA)
                    );

// ---------------------------------------------------------------------
// SDF annotation for the netlist simulation
// ---------------------------------------------------------------------
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

// ---------------------------------------------------------------------
// Dumping the vcd file for wave form viewing
// ---------------------------------------------------------------------
//initial
//begin
//  $dumpvars();
//  $dumpfile("/dump/arm/satishb/aaci.vcd");
//end

endmodule
// --============================== End ==============================--
