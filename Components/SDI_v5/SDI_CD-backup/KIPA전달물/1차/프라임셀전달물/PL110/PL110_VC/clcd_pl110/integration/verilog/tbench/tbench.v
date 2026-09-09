// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2003 ARM Limited
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
// Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
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

`uselib lib=uut lib=chip lib=tbench

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


integer i; // Used in generation of nReset

// --------------------------------------------------------------------
//
// Main body of code
// =================
//
// --------------------------------------------------------------------

EASY u_easy                        (
                    .XCLKIN        (XCLKIN), // External clock in
                    .nReset        (nReset), // Power on reset input
                    .XD            (XD),     // External data bus
                    .XA            (XA),     // External address bus
                    .XCSN          (XCSN),   // External chip select
                    .XOEN          (XOEN),   // External output
                                                // enable
                    .XWEN          (XWEN),  // External write enable

                    .TESTREQA      (TESTREQA), // Test bus request A
                    .TESTREQB      (TESTREQB), // Test bus request B
                    .TESTACK       (TESTACK)   // Test acknowledge
                    );

// Default HaltOnMismatch and Verbosity settings, the same as the
// initial values in the Ticbox module.
defparam uTicbox.HaltOnMismatch = 0;
defparam uTicbox.Verbosity      = 0;

Ticbox uTicbox                        (
                    .nReset           (nReset),   // System reset
                    .TESTCLK          (TESTCLK),  // Test mode clock
                                                  // input
                    .TESTACK          (TESTACK),  // Test acknowledge
                    .TESTBUS          (XD),       // Bidirectional test
                                                  // port
                    .TESTREQA         (TESTREQA), // Test bus request A
                    .TESTREQB         (TESTREQB)  // Test bus request B
                    );

assign TESTCLK          = XCLKIN;

// This controls the clock generation for the system
initial
  XCLKIN = 0; // Start clock from LOW

always
  #PHASETIME XCLKIN = ~XCLKIN;

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
