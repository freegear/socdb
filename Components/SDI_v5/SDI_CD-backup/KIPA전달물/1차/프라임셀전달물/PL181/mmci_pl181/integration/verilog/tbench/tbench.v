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
// Purpose :
//           Test bench to test the EASY microcontroller through
//           the TIC interface.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module tbench;

`uselib lib=uut lib=chip lib=tbench lib=trickbox

// -----------------------------------------------------------------------------
// Constant and Signal Declarations
// -----------------------------------------------------------------------------
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

// MMCI connections
wire        MMCIFBCLK;
tri1        MMCICMDIN;
tri1        MMCIDATIN;
wire        MMCICLKOUT;
wire        MMCICMDOUT;
wire        MMCIDATOUT;
wire        MMCIPWR;
wire        nMMCIDATEN;
wire        nMMCICMDEN;
wire        MMCIROD;
wire  [3:0] MMCIVDD;

integer i; // Used in generation of nReset

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

EASY u_easy                           (
                    .XCLKIN           (XCLKIN), // External clock in
                    .nReset           (nReset), // Power on reset input
                    .XD               (XD),     // External data bus
                    .XA               (XA),     // External address bus
                    .XCSN             (XCSN),   // External chip select
                    .XOEN             (XOEN),   // External output
                                                // enable
                    .XWEN             (XWEN),   // External write enable

                    .TESTREQA         (TESTREQA), // Test bus request A
                    .TESTREQB         (TESTREQB), // Test bus request B
                    .TESTACK          (TESTACK),  // Test acknowledge

                    .nTRST            (nTRST), // JTAG connections
                    .TCK              (TCK),
                    .TDI              (TDI),
                    .TMS              (TMS),
                    .TDO              (TDO),

                    .MMCIFBCLK        (MMCIFBCLK),
                    .MMCICMDIN        (MMCICMDIN),
                    .MMCIDATIN        (MMCIDATIN),
                    .MMCICLKOUT       (MMCICLKOUT),
                    .MMCICMDOUT       (MMCICMDOUT),
                    .MMCIDATOUT       (MMCIDATOUT),
                    .nMMCIDATEN       (nMMCIDATEN),
                    .nMMCICMDEN       (nMMCICMDEN), 
                    .MMCIPWR          (MMCIPWR),
                    .MMCIROD          (MMCIROD),
                    .MMCIVDD          (MMCIVDD)
                    );

MmciTrickInteg  u_MmciTrickInteg       (
                    .MMCICLKOUT        (MMCICLKOUT),
                    .MMCIPWR           (MMCIPWR),
                    .MMCIROD           (MMCIROD),
                    .MMCIVDD           (MMCIVDD),
                    .MMCIORMUX         (MMCIDAT),
                    .MMCIFBCLK         (MMCIFBCLK)
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
MmciDummyPad uMmciDummyPad            (
                    .MMCICMDOUT       (MMCICMDOUT),
                    .MMCIDATOUT       (MMCIDATOUT),
                    .nMMCIDATEN       (nMMCIDATEN),
                    .nMMCICMDEN       (nMMCICMDEN),
                    .MMCICMD          (MMCIDAT),
                    .MMCIDAT          (MMCIDAT),
                    .MMCICMDIN        (MMCICMDIN),
                    .MMCIDATIN        (MMCIDATIN)
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

endmodule

// --============================== End ======================================--
