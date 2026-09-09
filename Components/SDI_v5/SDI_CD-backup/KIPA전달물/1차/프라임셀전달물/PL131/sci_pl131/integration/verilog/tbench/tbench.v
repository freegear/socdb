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
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL131-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           Test bench to test the EASY microcontroller through
//           the TIC interface.
//
// --=================================================================--

`timescale 1ns/1ps

// --------------------------------------------------------------------

module tbench;

`uselib lib=uut lib=chip lib=tbench lib=trickbox lib=ticbox

// --------------------------------------------------------------------
// Constant and Signal Declarations
// --------------------------------------------------------------------
parameter PERIOD    = 100; // 10.0 MHz

parameter PHASETIME = (PERIOD)/2;

// External Signals
reg         XCLKIN;
reg         nReset;
wire [31:0] XD;
wire [30:0] XA;
wire  [3:0] XCSN;
wire        XOEN;
wire  [3:0] XWEN;

// TIC interface
wire        TESTREQA;
wire        TESTREQB;
wire        TESTACK;
wire        TESTCLK;

// JTAG connections
wire        nTRST;
reg         TCK;
wire        TDI;
wire        TMS;
wire        TDO;

// SCI signals

wire        SCICLKIN;
wire        SCIDATAIN;
wire        SCIDETECT;
wire        SCIDEACREQ;
wire        nSCICLKEN;
wire        nSCICLKOUTEN;
wire        SCICLKOUT;
wire        nSCIDATAEN;
wire        nSCIDATAOUTEN;
wire        SCIDEACACK;
wire        SCIVCCEN;
wire        nSCICARDRST;
wire        SCIFCB;
wire        SCICLKOUTpadout;
wire        nSCIDATAOUTENpadout;

integer i; // Used in generation of nReset

// --------------------------------------------------------------------
//
// Main body of code
// =================
//
// --------------------------------------------------------------------

EASY u_easy (
            .XCLKIN               (XCLKIN),
            .nReset               (nReset),
            .XD                   (XD),
            .XA                   (XA),
            .XCSN                 (XCSN),
            .XOEN                 (XOEN),
            .XWEN                 (XWEN),
            .TESTREQA             (TESTREQA),
            .TESTREQB             (TESTREQB),
            .TESTACK              (TESTACK),
            .nTRST                (nTRST),
            .TCK                  (TCK),
            .TDI                  (TDI),
            .TMS                  (TMS),
            .TDO                  (TDO),

//SCI - Primary I/O Test Trickbox connections
// Inputs
            .SCICLKIN             (SCICLKIN),
            .SCIDATAIN            (SCIDATAIN),
            .SCIDETECT            (SCIDETECT),
            .SCIDEACREQ           (SCIDEACREQ),
// Outputs
            .nSCICLKEN            (nSCICLKEN),
            .nSCICLKOUTEN         (nSCICLKOUTEN),
            .SCICLKOUT            (SCICLKOUT),
            .nSCIDATAEN           (nSCIDATAEN),
            .nSCIDATAOUTEN        (nSCIDATAOUTEN),

            .SCIDEACACK           (SCIDEACACK),
            .SCIVCCEN             (SCIVCCEN),
            .nSCICARDRST          (nSCICARDRST),
            .SCIFCB               (SCIFCB)
            );                      

// Default HaltOnMismatch and Verbosity settings, the same as the
// initial values in the Ticbox module.
defparam uTicbox.HaltOnMismatch = 0;
defparam uTicbox.Verbosity      = 0;

Ticbox uTicbox  (
            .nReset               (nReset),   // System reset
            .TESTCLK              (TESTCLK),  // Test mode clock
                                              // input
            .TESTACK              (TESTACK),  // Test acknowledge
            .TESTBUS              (XD),       // Bidirectional test
                                              // port
            .TESTREQA             (TESTREQA), // Test bus request A
            .TESTREQB             (TESTREQB)  // Test bus request B
           );

// ---------------------------------------------------------------------
// SSP Dummy Pad connections
// ---------------------------------------------------------------------

  SciDummyPad uSciDummyPad  (
// Inputs
            .nSCICLKENpaden       (nSCICLKEN),
            .nSCICLKOUTENpaden    (nSCICLKOUTEN),
            .SCICLKOUTpadin       (SCICLKOUT),

            .nSCIDATAENpaden      (nSCIDATAEN),
            .nSCIDATAOUTENpadin   (nSCIDATAOUTEN),

// Outputs 
            .SCICLKOUTpadout      (SCICLKOUTpadout),
            .nSCIDATAOUTENpadout  (nSCIDATAOUTENpadout)
                    );
 

// ---------------------------------------------------------------------
// SSP Integration Trickbox 
// ---------------------------------------------------------------------

  SciTrick  uSciTrick      (
// Inputs
            .SCICLKOUTpadout      (SCICLKOUTpadout),
            .nSCIDATAOUTENpadout  (nSCIDATAOUTENpadout),
            .SCIDEACACK           (SCIDEACACK),
            .SCIVCCEN             (SCIVCCEN),
            .nSCICARDRST          (nSCICARDRST),
            .SCIFCB               (SCIFCB),

// Outputs
            .SCICLKIN             (SCICLKIN),
            .SCIDATAIN            (SCIDATAIN),
            .SCIDEACREQ           (SCIDEACREQ),
            .SCIDETECT            (SCIDETECT)
                 );
 
assign TESTCLK          = XCLKIN;

assign nTRST            = nReset; // JTAG connections
assign TDI              = 0;
assign TMS              = 0;

// This controls the clock generation for the system
initial
  XCLKIN = 0; // Start clock from LOW

always
  #PHASETIME XCLKIN = ~XCLKIN;

// This controls the JTAG test clock generation for the system.
// A 5 MHz test clock is generated.
initial
  TCK = 0; // Start clock from LOW

always
  #1000 TCK = ~TCK;

// This controls the timing of the nReset signal.
// The loop values should be changed for different reset timing.
initial
begin
  nReset = 0;
  for (i = 0; i < 20; i = i + 1)
    @(XCLKIN);
  nReset = 1;

// Wait until the TIC signals that test mode has been entered.
  wait (TESTACK)
    @(posedge XCLKIN)

// End simulation when the Ticbox and TIC indicate that testing has
// finished.
  wait (~TESTREQA & ~TESTREQB & ~TESTACK)
    @(posedge XCLKIN)
  $display("Test sequence completed");
  $finish;
end

// include system task for SDF delay annotation.
`ifdef NET_MAX
  initial
  begin
    $sdf_annotate("",u_easy.u_rps.uut,,,"MAXIMUM");
  end
`endif

`ifdef NET_MIN
  initial
  begin
    $sdf_annotate("",u_easy.u_rps.uut,,,"MINIMUM");
  end
`endif

`ifdef NET_TYP
  initial
  begin
    $sdf_annotate("",u_easy.u_rps.uut,,,"TYPICAL");
  end
`endif

/*
initial
begin
 $dumpvars();
 $dumpfile("/dump/arm/integ.vcd");
end
*/

endmodule

// --============================== End ==============================--
