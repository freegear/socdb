// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrIntArb.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is responsible for generating Grant signal for Channels
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrIntArb (
// Inputs
                     HCLK,
                     HRESETn,
                     Ch0Req,
                     Ch1Req,
                     Ch2Req,
                     Ch3Req,
                     Ch4Req,
                     Ch5Req,
                     Ch6Req,
                     Ch7Req,
                     StopArb,
                     Ch0HWDATA,
                     Ch1HWDATA,
                     Ch2HWDATA,
                     Ch3HWDATA,
                     Ch4HWDATA,
                     Ch5HWDATA,
                     Ch6HWDATA,
                     Ch7HWDATA,
// Outputs
                     ReqForAhbBus,
                     HWDATA,
                     Ch0Comb,
                     Ch1Comb,
                     Ch2Comb,
                     Ch3Comb,
                     Ch4Comb,
                     Ch5Comb,
                     Ch6Comb,
                     Ch7Comb
                     );

// Inputs
input         HCLK;         // AHB clock
input         HRESETn;      // AHB reset
input         Ch0Req;       // Channel0 req to Arbiter
input         Ch1Req;       // Channel1 req to Arbiter
input         Ch2Req;       // Channel2 req to Arbiter
input         Ch3Req;       // Channel3 req to Arbiter
input         Ch4Req;       // Channel4 req to Arbiter
input         Ch5Req;       // Channel5 req to Arbiter
input         Ch6Req;       // Channel6 req to Arbiter
input         Ch7Req;       // Channel7 req to Arbiter
input         StopArb;      // Stop Arb indication from Master
input  [31:0] Ch0HWDATA;    // AHB Write Data from Ch0
input  [31:0] Ch1HWDATA;    // AHB Write Data from Ch1
input  [31:0] Ch2HWDATA;    // AHB Write Data from Ch2
input  [31:0] Ch3HWDATA;    // AHB Write Data from Ch3
input  [31:0] Ch4HWDATA;    // AHB Write Data from Ch4
input  [31:0] Ch5HWDATA;    // AHB Write Data from Ch5
input  [31:0] Ch6HWDATA;    // AHB Write Data from Ch6
input  [31:0] Ch7HWDATA;    // AHB Write Data from Ch7

// Outputs
output        ReqForAhbBus; // Indication for Master Interface to put request
                            // on Bus
output [31:0] HWDATA;       // AHB Write Data bus
output        Ch0Comb;      // Channel0 selected
output        Ch1Comb;      // Channel1 selected
output        Ch2Comb;      // Channel2 selected
output        Ch3Comb;      // Channel3 selected
output        Ch4Comb;      // Channel4 selected
output        Ch5Comb;      // Channel5 selected
output        Ch6Comb;      // Channel6 selected
output        Ch7Comb;      // Channel7 selected




// Inputs
  wire        HCLK;         // AHB clock
  wire        HRESETn;      // AHB reset
  wire        Ch0Req;       // Channel0 req to Arbiter
  wire        Ch1Req;       // Channel1 req to Arbiter
  wire        Ch2Req;       // Channel2 req to Arbiter
  wire        Ch3Req;       // Channel3 req to Arbiter
  wire        Ch4Req;       // Channel4 req to Arbiter
  wire        Ch5Req;       // Channel5 req to Arbiter
  wire        Ch6Req;       // Channel6 req to Arbiter
  wire        Ch7Req;       // Channel7 req to Arbiter
  wire        StopArb;      // Stop Arb indication from Master
  wire [31:0] Ch0HWDATA;    // AHB Write Data from Ch0
  wire [31:0] Ch1HWDATA;    // AHB Write Data from Ch1
  wire [31:0] Ch2HWDATA;    // AHB Write Data from Ch2
  wire [31:0] Ch3HWDATA;    // AHB Write Data from Ch3
  wire [31:0] Ch4HWDATA;    // AHB Write Data from Ch4
  wire [31:0] Ch5HWDATA;    // AHB Write Data from Ch5
  wire [31:0] Ch6HWDATA;    // AHB Write Data from Ch6
  wire [31:0] Ch7HWDATA;    // AHB Write Data from Ch7

// Outputs
  wire        ReqForAhbBus; // Indication for Master Interface to put request
                            // on Bus
  reg  [31:0] HWDATA;       // AHB Write Data bus
  wire        Ch0Comb;      // Channel0 selected
  wire        Ch1Comb;      // Channel1 selected
  wire        Ch2Comb;      // Channel2 selected
  wire        Ch3Comb;      // Channel3 selected
  wire        Ch4Comb;      // Channel4 selected
  wire        Ch5Comb;      // Channel5 selected
  wire        Ch6Comb;      // Channel6 selected
  wire        Ch7Comb;      // Channel7 selected


// -----------------------------------------------------------------------------
//
//                           DmacTrIntArb
//                           ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module is responsible for giving the Grants to the different channels
// based on the Fixed Priority Scheme(Channel0 Highest Priority and Channel7
// Lowest Priority). This scheme is applicable only in the window when StopArb
// signal is sampled low.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire     iReqForAhbBus;
// Request for AHB Bus

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg      iCh0Comb;
// 1 HCLK window indicating Ch0 selected

reg      Ch0Sel;
// Channel0 selected

reg      iCh1Comb;
// 1 HCLK window indicating Ch1 selected

reg      Ch1Sel;
// Channel1 selected

reg      iCh2Comb;
// 1 HCLK window indicating Ch2 selected

reg      Ch2Sel;
// Channel2 selected

reg      iCh3Comb;
// 1 HCLK window indicating Ch3 selected

reg      Ch3Sel;
// Channel3 selected

reg      iCh4Comb;
// 1 HCLK window indicating Ch4 selected

reg      Ch4Sel;
// Channel4 selected

reg      iCh5Comb;
// 1 HCLK window indicating Ch5 selected

reg      Ch5Sel;
// Channel5 selected

reg      iCh6Comb;
// 1 HCLK window indicating Ch6 selected

reg      Ch6Sel;
// Channel6 selected

reg      iCh7Comb;
// 1 HCLK window indicating Ch7 selected

reg      Ch7Sel;
// Channel7 selected

reg      ChArbMaskOn;
// Combinational signal to indicate that Further arbitration is masked off

reg      ChMaskReg;
// Register to hold the combination grant select signal

reg      NextChMaskReg;
// D-Input of ChMaskReg

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Assigning internal signals to the outputs
// -----------------------------------------------------------------------------
assign ReqForAhbBus     = iReqForAhbBus;
assign Ch0Comb          = iCh0Comb;
assign Ch1Comb          = iCh1Comb;
assign Ch2Comb          = iCh2Comb;
assign Ch3Comb          = iCh3Comb;
assign Ch4Comb          = iCh4Comb;
assign Ch5Comb          = iCh5Comb;
assign Ch6Comb          = iCh6Comb;
assign Ch7Comb          = iCh7Comb;


assign iReqForAhbBus    = Ch0Sel | Ch1Sel | Ch2Sel | Ch3Sel | Ch4Sel | Ch5Sel |
                          Ch6Sel | Ch7Sel;

// -----------------------------------------------------------------------------
// This combinational process is responsible for generating the grant signal
// for the DMAC Channels. The request lines are sampled based on the priority.
// Once the channel is selected, it remains selected till the address of the
// last beat is put on the bus. This signal is indicated by the StopArb signal.
// Till this interval the mask is on.
// The request to the Master is generated by ORing the select lines of each
// channel.
// -----------------------------------------------------------------------------
always @(StopArb or ChArbMaskOn or Ch0Req or Ch1Req or Ch2Req or Ch3Req or
         Ch4Req or Ch5Req or Ch6Req or Ch7Req)
begin : p_ArbTestComb
   iCh0Comb         = 1'b0;
   iCh1Comb         = 1'b0;
   iCh2Comb         = 1'b0;
   iCh3Comb         = 1'b0;
   iCh4Comb         = 1'b0;
   iCh5Comb         = 1'b0;
   iCh6Comb         = 1'b0;
   iCh7Comb         = 1'b0;
  if ((StopArb == 1'b0) && (ChArbMaskOn == 1'b0))
    begin
      if (Ch0Req == 1'b1)
        iCh0Comb         = 1'b1;
      else if (Ch1Req == 1'b1)
        iCh1Comb         = 1'b1;
      else if (Ch2Req == 1'b1)
        iCh2Comb         = 1'b1;
      else if (Ch3Req == 1'b1)
        iCh3Comb         = 1'b1;
      else if (Ch4Req == 1'b1)
        iCh4Comb         = 1'b1;
      else if (Ch5Req == 1'b1)
        iCh5Comb         = 1'b1;
      else if (Ch6Req == 1'b1)
        iCh6Comb         = 1'b1;
      else if (Ch7Req == 1'b1)
        iCh7Comb         = 1'b1;
    end
end // p_ArbTestComb

always @(StopArb or ChArbMaskOn or Ch0Req or Ch1Req or Ch2Req or Ch3Req or
         Ch4Req or Ch5Req or Ch6Req or Ch7Req or iCh0Comb or iCh1Comb or
         iCh2Comb or iCh3Comb or iCh4Comb or iCh5Comb or iCh6Comb or iCh7Comb or
         ChMaskReg)
begin : p_ArbComb
  if ((iCh0Comb | iCh1Comb | iCh2Comb | iCh3Comb | iCh4Comb | iCh5Comb |
       iCh6Comb | iCh7Comb) == 1'b1)
    NextChMaskReg    = 1'b1;
  else if ((ChMaskReg == 1'b1) && (StopArb == 1'b0))
    NextChMaskReg    = 1'b0;

  if (StopArb == 1'b0)
    ChArbMaskOn      = StopArb;
  else
    ChArbMaskOn      = ChMaskReg;

  if (iCh0Comb == 1'b1)
    Ch0Sel           = 1'b1;
  else if (((iCh1Comb | iCh2Comb | iCh3Comb | iCh4Comb | iCh5Comb | iCh6Comb |
             iCh7Comb) == 1'b0) && (ChArbMaskOn == 1'b1))
    Ch0Sel           = ChArbMaskOn;
  else
    Ch0Sel           = 1'b0;

  if (iCh1Comb == 1'b1)
    Ch1Sel           = 1'b1;
  else if (((iCh0Comb | iCh2Comb | iCh3Comb | iCh4Comb | iCh5Comb | iCh6Comb |
             iCh7Comb) == 1'b0) && (ChArbMaskOn == 1'b1))
    Ch1Sel           = ChArbMaskOn;
  else
    Ch1Sel           = 1'b0;

  if (iCh2Comb == 1'b1)
    Ch2Sel           = 1'b1;
  else if (((iCh0Comb | iCh1Comb | iCh3Comb | iCh4Comb | iCh5Comb | iCh6Comb |
             iCh7Comb) == 1'b0) && (ChArbMaskOn == 1'b1))
    Ch2Sel           = ChArbMaskOn;
  else
    Ch2Sel           = 1'b0;

  if (iCh3Comb == 1'b1)
    Ch3Sel           = 1'b1;
  else if (((iCh0Comb | iCh1Comb | iCh2Comb | iCh4Comb | iCh5Comb | iCh6Comb |
             iCh7Comb) == 1'b0) && (ChArbMaskOn == 1'b1))
    Ch3Sel           = ChArbMaskOn;
  else
    Ch3Sel           = 1'b0;

  if (iCh4Comb == 1'b1)
    Ch4Sel           = 1'b1;
  else if (((iCh0Comb | iCh1Comb | iCh2Comb | iCh3Comb | iCh5Comb | iCh6Comb |
             iCh7Comb) == 1'b0) && (ChArbMaskOn == 1'b1))
    Ch4Sel           = ChArbMaskOn;
  else
    Ch4Sel           = 1'b0;

  if (iCh5Comb == 1'b1)
    Ch5Sel           = 1'b1;
  else if (((iCh0Comb | iCh1Comb | iCh2Comb | iCh3Comb | iCh4Comb | iCh6Comb |
             iCh7Comb) == 1'b0) && (ChArbMaskOn == 1'b1))
    Ch5Sel           = ChArbMaskOn;
  else
    Ch5Sel           = 1'b0;

  if (iCh6Comb == 1'b1)
    Ch6Sel           = 1'b1;
  else if (((iCh0Comb | iCh1Comb | iCh2Comb | iCh3Comb | iCh4Comb | iCh5Comb |
             iCh7Comb) == 1'b0) && (ChArbMaskOn == 1'b1))
    Ch6Sel           = ChArbMaskOn;
  else
    Ch6Sel           = 1'b0;

  if (iCh7Comb == 1'b1)
    Ch7Sel           = 1'b1;
  else if (((iCh0Comb | iCh1Comb | iCh2Comb | iCh3Comb | iCh4Comb | iCh5Comb |
             iCh7Comb) == 1'b0) && (ChArbMaskOn == 1'b1))
    Ch7Sel           = ChArbMaskOn;
  else
    Ch7Sel           = 1'b0;

end // p_ArbComb

// -----------------------------------------------------------------------------
// Sequential process for ChMaskReg register
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_ArbSeq
  if (HRESETn == 1'b0)
    ChMaskReg        <= 1'b0;
  else
    ChMaskReg        <= NextChMaskReg;
end // p_ArbSeq

// -----------------------------------------------------------------------------
// Logic to Route HWDATA Lines on the Bus 
// -----------------------------------------------------------------------------
always @(Ch0HWDATA or Ch1HWDATA or Ch2HWDATA or Ch3HWDATA or Ch4HWDATA or
         Ch5HWDATA or Ch6HWDATA or Ch7HWDATA)
begin : p_HWDATAComb
   HWDATA = Ch0HWDATA | Ch1HWDATA | Ch2HWDATA | Ch3HWDATA | Ch4HWDATA |
            Ch5HWDATA | Ch6HWDATA | Ch7HWDATA;
end // p_HWDATAComb

endmodule
// --================================= End ===================================--
