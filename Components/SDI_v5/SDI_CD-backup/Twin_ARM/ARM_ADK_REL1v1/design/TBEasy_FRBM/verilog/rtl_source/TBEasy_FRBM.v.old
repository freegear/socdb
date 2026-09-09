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
//  File Name          : TBEasy_FRBM.v,v
//  File Revision      : 1.12
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose            : Test-bench for the EASY_FRBM system
//  --========================================================================--

`timescale 1ns/1ps

// Top level - no I/O
module TBEasy_FRBM ();

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------

// The following default frequency settings are specified. The required clock
//  period should be uncommented for use, or a new frequency specified. This
//  setting will depend on the operating frequency of the core used in the
//  system.

//  `define PERIOD 7.5 // 133.3 MHz
  `define PERIOD 7.518 // 133.0 MHz
//  `define PERIOD 10 // 100.0 MHz
//  `define PERIOD 15 //  66.6 MHz
//  `define PERIOD 15.152 // 66.0 MHz
//  `define PERIOD 20 //  50.0 MHz
//  `define PERIOD 25 //  40.0 MHz
//  `define PERIOD 30 //  33.3 MHz
//  `define PERIOD 40 //  25.0 MHz

  `define PHASETIME (`PERIOD / 2)


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

//  External signals
  reg         XCLKIN;           // External clock in
  reg         nReset;           // Power on reset input

// GPIO signals
  wire [7:0]  GPIN;             // Inputs                   
  wire [7:0]  GPOUT;            // Outputs                  
  wire [7:0]  nGPEN;            // Output enable            
  wire [7:0]  nGPAFEN;          // H/w ctrl enable          
  wire [7:0]  GPAFOUT;          // H/w ctrl input           
  wire [7:0]  GPAFIN;           // H/w ctrl output

// Tube signals
  wire [31:0] TubeData;         // Tube model for system messages
  wire [3:0]  TubeWriteEnable;
  wire [3:0]  TubeChipSelect;

// Scan signals
  wire        SCANENABLE;       // Scan Test Mode Enable         
  wire        SCANINHCLK;       // Scan Chain Input (HCLK)
  wire        SCANOUTHCLK;      // Scan Chain Output (HCLK)
  wire        SCANINPCLK;       // Scan Chain Input (PCLK)
  wire        SCANOUTPCLK;      // Scan Chain Output (PCLK)


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The File Reader Bus Master Example Amba SYstem (EASY_FRBM)
  EASY_FRBM uEASY_FRBM 
    (
     .XCLKIN      (XCLKIN),
     .nReset      (nReset),

     .GPIN        (GPIN),
     .GPOUT       (GPOUT),
     .nGPEN       (nGPEN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .GPAFIN      (GPAFIN),

     .SCANENABLE  (SCANENABLE),
     .SCANINHCLK  (SCANINHCLK),
     .SCANOUTHCLK (SCANOUTHCLK),
     .SCANINPCLK  (SCANINPCLK),
     .SCANOUTPCLK (SCANOUTPCLK)
    );
  
// Tube is connected to the GPIO output pins
  Tube uTube 
    (
     .XD   (TubeData),
     .XCSN (TubeChipSelect),
     .XWEN (TubeWriteEnable)
    );
  
// Write to GPIO data register with bit 7 high to write to Tube.
// TubeData(7) is tied low, which implies that not all ASCII codes can be 
// written to the Tube. However 00-7F does cover all alpha-numeric characters
// and control codes
  assign TubeData[31:7] = {25{1'b0}};
  assign TubeData[6:0] = GPOUT[6:0];
  assign TubeChipSelect = 4'b0000;             // Tube always selected
  assign TubeWriteEnable = {3'b000,GPOUT[7]};  // Tube uses XWEN(0)
  
// GPIO inputs unused
  assign GPIN    = {8{1'b0}};
  assign nGPAFEN = {8{1'b1}};
  assign GPAFOUT = {8{1'b0}};

// Scan signals unused
  assign SCANENABLE = 1'b0;
  assign SCANINHCLK = 1'b0;
  assign SCANINPCLK = 1'b0;  

// This controls the clock generation for the system
  always 
    begin : p_ClockGenComb
      XCLKIN <= 1'b0;
      #`PHASETIME;
      XCLKIN <= 1'b1;
      #`PHASETIME;
    end
  
// This controls the timing of the Reset signal.
// The loop values should be changed for different reset timing
  initial
    begin : p_RstComb
      nReset <= 1'b0;
      begin : reset_loop
        integer i;
        for (i = 1; i <= 20; i = i + 1)
          @ (XCLKIN);
      end
      nReset <= #1 1'b1; // Hold time for ResetCntl SyncPOR register
    end

  
endmodule

//  --================================= End ==================================--


