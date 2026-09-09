//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : TBEasy_ARM7.v,v
//  File Revision       : 1.1
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Test-bench for the EASY_ARM7 system 
//  --========================================================================--


`timescale 1ns/1ps

// Top level - no I/O
module TBEasy_ARM7 ();

//------------------------------------------------------------------------------
// Constant declarations
//-----------------------------------------------------------------------------

// Bus Clock

// The following default frequency settings are specified. The required clock
//  period should be uncommented for use, or a new frequency specified. This
//  setting will depend on the operating frequency of the core used in the
//  system.

//  `define PERIOD 7.5 // 133.3 MHz
//  `define PERIOD 7.518 // 133.0 MHz
//  `define PERIOD 10 // 100.0 MHz
//  `define PERIOD 15 //  66.6 MHz
  `define PERIOD 15.152 // 66.0 MHz
//  `define PERIOD 20 //  50.0 MHz
//  `define PERIOD 25 //  40.0 MHz
//  `define PERIOD 30 //  33.3 MHz
//  `define PERIOD 40 //  25.0 MHz

  `define PHASETIME (`PERIOD / 2)

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// External signals
  reg         XCLKIN;        // External clock in
  reg         nReset;        // Power on reset input

// SMI interface signals
  wire [31:0] XD;
  wire [31:0] XDout;
  wire [30:0] XA;
  wire [7:0]  XCSN;
  wire        XOEN;
  wire [3:0]  XBLS;
  wire [3:0]  XDATAEN;

// TIC interface
  wire        TESTREQA;
  wire        TESTREQB;
  wire        TESTACK;

// JTAG connections
  wire        nTRST;
  wire        TCK;
  wire        TDI;
  wire        TMS;
  wire        TDO;
  wire        nTDOEN;

// ARM7TDMI comms debug signals
  wire        COMMTX;
  wire        COMMRX;

// GPIO signals
  wire [7:0]  GPIN;          // Inputs         
  wire [7:0]  GPOUT;         // Outputs        
  wire [7:0]  nGPEN;         // Output enable  
  wire [7:0]  nGPAFEN;       // H/w ctrl enable
  wire [7:0]  GPAFOUT;       // H/w ctrl input 
  wire [7:0]  GPAFIN;        // H/w ctrl output

// Scan signals
  wire        SCANENABLE;    // Scan Test Mode Enable   
  wire        SCANINHCLK;    // Scan Chain Input (HCLK)
  wire        SCANOUTHCLK;   // Scan Chain Output (HCLK)
  wire        SCANINPCLK;    // Scan Chain Input (PCLK)
  wire        SCANOUTPCLK;   // Scan Chain Output (PCLK)

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The ARM7TDMI-based Example Amba SYstem (EASY_ARM7)
  EASY_ARM7 uEASY_ARM7 
    (
     .XCLKIN      (XCLKIN),
     .nReset      (nReset),

     .SMDATAIN    (XD),
     .SMDATAOUT   (XDout),
     .nSMDATAEN   (XDATAEN),
     .SMADDR      (XA[25:0]),
     .SMCS        (XCSN),
     .nSMBLS      (XBLS),
     .nSMOEN      (XOEN),

     .TESTREQA    (TESTREQA),
     .TESTREQB    (TESTREQB),
     .TESTACK     (TESTACK),

     .nTRST       (nTRST),
     .TCK         (TCK),
     .TDI         (TDI),
     .TMS         (TMS),
     .TDO         (TDO),
     .nTDOEN      (nTDOEN),

     .COMMRX      (COMMRX),
     .COMMTX      (COMMTX),

     .GPIN        (GPIN),
     .GPOUT       (GPOUT),
     .nGPEN       (nGPEN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .GPAFIN      (GPAFIN),

     // Scan test dummy signals; not connected until scan insertion
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLK),  // Scan Chain Input (HCLK)
     .SCANOUTHCLK (SCANOUTHCLK), // Scan Chain Output (HCLK)
     .SCANINPCLK  (SCANINPCLK),  // Scan Chain Input (PCLK)
     .SCANOUTPCLK (SCANOUTPCLK)  // Scan Chain Output (PCLK)
    );

  assign XA[30:26] = {5{1'b0}};


// Tube is connected to the SMI
  Tube uTube 
    (
     .XD   (XD),
     .XCSN (XCSN[7:4]),
     .XWEN (XBLS)
    );

// External RAM and ROM
  Memory uMemory 
    (
     .XA   (XA),
     .XD   (XD),
     .XCSN (XCSN[7:4]),
     .XWEN (XBLS),
     .XOEN (XOEN)
    );


// TIC inputs unused
  assign TESTREQA = 1'b0;
  assign TESTREQB = 1'b0;
  
// JTAG inputs unused
  assign nTRST = 1'b0;
  assign TCK = 1'b0;
  assign TDI = 1'b0;
  assign TMS = 1'b0;

// Scan signals unused
  assign SCANENABLE = 1'b0;
  assign SCANINHCLK = 1'b0;
  assign SCANINPCLK = 1'b0;  
  
// Merge the external data bus signals 
  assign XD = ((XDATAEN[0] == 1'b0) ? XDout : (32'bz));

// GPIO alternate function lines tied inactive for integration tests
  assign nGPAFEN = {8{1'b1}};
  assign GPAFOUT = {8{1'b0}};


//------------------------------------------------------------------------
//-- The inputs to the GPIO Alt. Funct. Output are controlled via writes
//-- to the GTAOUTR register
//--                 ________
//-- nGPEN[7:0] >---\\       \
//--                || XOR    -----  
//-- GPOUT[7:0] >---//_______/     |
//--                               |
//-- GPIN[7:0]  <------------------
//--
//--
//-- XOR
//-- --------------------------------
//-- nGPEN[i]   GPOUT[i]   |  GPIN[i]
//-- --------------------------------
//--     0         0       |    0
//--     0         1       |    1
//--     1         0       |    1
//--     1         1       |    0
//-- --------------------------------
//------------------------------------------------------------------------

// Simple loop-back circuit for the integration tests (see above note)
  assign GPIN = (nGPEN ^ GPOUT);


// This controls the clock generation for the system
  always 
    begin : p_ClockGenComb
      XCLKIN = 1'b0;
      #`PHASETIME;
      XCLKIN = 1'b1;
      #`PHASETIME;
    end

// This controls the timing of the Reset signal.
// The loop values should be changed for different reset timing
  initial
    begin : p_RstComb
      nReset = 1'b0;
      begin : reset_loop
        integer i;
        for (i = 1; i <= 20; i = i + 1)
          @ (XCLKIN);
      end
      nReset = #1 1'b1; // Hold time for ResCntl SyncPOR register
    end

endmodule

//  --========================================================================--

