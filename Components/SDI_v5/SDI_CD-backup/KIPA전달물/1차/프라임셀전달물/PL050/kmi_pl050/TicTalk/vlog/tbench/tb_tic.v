//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : tb_tic.v,v
//  File Revision       : 1.1
//  
//  Release Information : PL050-REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Test bench to test the EASY microcontroller through
//                        the TIC interface.
//  --========================================================================--

`timescale 1ns/1ps

module tb_tic;

`uselib lib=chip lib=tbench

//-----------------------------------------------------------------------------
// Constant and Signal Declarations
//-----------------------------------------------------------------------------

parameter PERIOD        = 100; 
parameter PHASETIME     = (PERIOD)/2;
parameter APPLYTIME     = 1.3 * PHASETIME;
parameter REFXTALPERIOD = 100; 
parameter REFXTALPHASE  = (REFXTALPERIOD)/2;

// External Signals
reg         XCLKIN;
reg         REFXTAL;
wire        XnGBE;
reg         Reset;
wire        XWAIT;
wire [31:0] XD;
wire [30:0] XA;
wire        XCLK;
wire  [7:0] XCSN;
wire        XOEN;
wire  [3:0] XWEN;

// TIC interface
wire        TREQA;
wire        TREQB;
wire        TACK;

// JTAG connections
wire        nTRST;
wire        TCK;
wire        TDI;
wire        TMS;
wire        TDO;
  
reg         START; // Enables the TICBOX to start TIC testing

//-----------------------------------------------------------------------------
// Beginning of main code
//-----------------------------------------------------------------------------

easy u_easy (
  .XCLKIN  (XCLKIN),     // External clock in
  .XnGBE   (XnGBE),      // External global bus enable
  .Reset   (Reset),      // Power on reset input
  .XWAIT   (XWAIT),      // External wait request
  .XD      (XD),         // External data bus
  .XA      (XA),         // External address bus
  .XCLK    (XCLK),       // External clock out
  .XCSN    (XCSN),       // External chip select
  .XOEN    (XOEN),       // External output enable
  .XWEN    (XWEN),       // External write enable

  .TREQA   (TREQA),      // Test bus request A
  .TREQB   (TREQB),      // Test bus request B
  .TACK    (TACK),       // Test acknowledge

  .REFXTAL (REFXTAL),    // Test acknowledge

  .nTRST   (nTRST),      // JTAG connections
  .TCK     (TCK),
  .TDI     (TDI),
  .TMS     (TMS),
  .TDO     (TDO)
  );


ticbox u_ticbox (
  .START  (START), // Test access request
  .TCLK   (XCLK),  // Test mode clock input
  .TACK   (TACK),  // Test acknowledge
  .TBUS   (XD),    // Bidirectional test port
  .TREQA  (TREQA), // Test bus request A
  .TREQB  (TREQB)  // Test bus request B
  );

assign XnGBE = 0; // External bus is always enabled
assign XWAIT = 0; // No external waits

assign nTRST = ~Reset; // JTAG connections
assign TCK   = XCLK;
assign TDI   = 0;
assign TMS   = 0;

// This controls the clock generation for the system
always
  #PHASETIME XCLKIN = ~XCLKIN;

// This controls the reference clock generation
always
  #REFXTALPHASE REFXTAL = ~REFXTAL;

initial
begin: Stimulus

// Control of system reset signal and TICBOX test enable signal
// The loop values should be changed for different reset timing
  XCLKIN = 0;
  Reset = 0;
  START = 0;
  repeat (4) @(XCLK);
  Reset = 1;
  repeat (20) @(XCLK);
  Reset = 0;
  #((10 * PERIOD) + APPLYTIME); // To apply signals on the low phase of BCLK;
  START = 1;
  #(10 * PERIOD);
  @(posedge XCLK);
// Disable TIC testing when end of test is signalled by TICBOX and TIC
  while (TREQA | TREQB | TACK) // Wait until all signals are LOW on rising clock
    @(posedge XCLK);
  START = 0;
  $display("Test sequence completed");
  $finish;
end

// include system task for best/worst case SDF delay annotation.
  `ifdef NET_MAX
   initial
   begin
     $sdf_annotate("../../../verilog/uutNetlist/Kmi_Verilog.sdf21",u_easy.u_rps.uKmi,,,"MAXIMUM");
   end
  `endif
 
  `ifdef NET_MIN
   initial
   begin
     $sdf_annotate("../../../verilog/uutNetlist/Kmi_Verilog.sdf21",u_easy.u_rps.uKmi,,,"MINIMUM");
   end
  `endif

endmodule

// --================================ End ====================================--
