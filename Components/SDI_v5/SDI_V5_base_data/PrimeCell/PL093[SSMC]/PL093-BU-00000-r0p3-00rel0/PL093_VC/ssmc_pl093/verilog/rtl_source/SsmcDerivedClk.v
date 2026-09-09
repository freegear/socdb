// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcDerivedClk.v.rca
// File Revision          : 1.11
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           In this Block SlowClkM is derived from HCLK and SMMEMCLK
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcDerivedClk (
// Inputs
                       HCLK,
                       HRESETn,
                       SMMEMCLK,
                       ClockRatio,
                       MemClkRegTogl,
// Outputs
                       SlowClkM
                      );

// Inputs
input        HCLK;          // AHB Bus Clock
input        HRESETn;       // AHB system level Reset
input        SMMEMCLK;      // Memory Clock
input  [1:0] ClockRatio;    // Clock Ratio indication
input        MemClkRegTogl; // Toggle signal indicating that write happened to
                            // Clock Register

// Outputs
output       SlowClkM;      // Slow clock indicator to HCLK side




// Inputs
  wire       HCLK;          // AHB Bus Clock
  wire       HRESETn;       // AHB system level Reset
  wire       SMMEMCLK;      // Memory Clock
  wire [1:0] ClockRatio;    // Clock Ratio indication
  wire       MemClkRegTogl; // Toggle signal indicating that write happened to
                            // Clock Register

// Outputs
  reg        SlowClkM;      // Slow clock indicator to HCLK side


// -----------------------------------------------------------------------------
//
//                               SsmcDerivedClk
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//           Generation of SlowClkM is the main function of this Block.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg        FrstEdgeAfterRes;
// Signal used for synchronizing with the Memory Clock

reg        SMMEMCLKDiv2;
// Divide by 2 clock signal

reg        NextSMMEMCLKDiv2;
// D_Input of SMMEMCLKDiv2

reg        SMMEMCLKDiv3;
// Divide by 3 clock signal

reg        NextSMMEMCLKDiv3;
// D_Input of SMMEMCLKDiv3

reg  [1:0] Count3;
// Counter to control the Duty Cycle for Divide by 3 clock

reg  [1:0] NextCount3;
// D_Input of Count3

reg        NextFirstEdge;
// Signal used for synchronizing with the Memory Clock

reg        ToggleReg;
// Signal used for synchronizing with the Memory Clock


// -----------------------------------------------------------------------------
// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// synopsys translate_off
// -----------------------------------------------------------------------------
// Type declarations
// -----------------------------------------------------------------------------



// synopsys translate_on
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Internal Signal Assignments
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                              Assignments
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// The signal FrstEdgeAfterRes goes high on the fist SMMEMCLK edge after
// application of HRESETn, or after the Register is getting Programmed.
// -----------------------------------------------------------------------------
always @(FrstEdgeAfterRes or ToggleReg or MemClkRegTogl)
begin : p_FstEdgeGenComb
  NextFirstEdge    = FrstEdgeAfterRes;
  if ((ToggleReg ^ MemClkRegTogl) == 1'b1)
    NextFirstEdge    = 1'b0;
  else
    NextFirstEdge    = 1'b1;
end // p_FstEdgeGenComb

// -----------------------------------------------------------------------------
// Registering all Next state signals
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge SMMEMCLK)
begin : p_FstEdgeGenSeq
  if (HRESETn == 1'b0)
    begin
      FrstEdgeAfterRes <= 1'b0;
      ToggleReg        <= 1'b0;
    end
  else
    begin
      FrstEdgeAfterRes <= NextFirstEdge;
      ToggleReg        <= MemClkRegTogl;
    end
end // p_FstEdgeGenSeq

// -----------------------------------------------------------------------------
// Combinational logic for generating SMMEMCLKDiv2.
// -----------------------------------------------------------------------------
always @(FrstEdgeAfterRes or SMMEMCLKDiv2 or Count3 or SMMEMCLKDiv3)
begin : p_MemClkDv3Comb
  if (FrstEdgeAfterRes == 1'b1)
    begin
      NextSMMEMCLKDiv2 =  ~(SMMEMCLKDiv2);
      if (Count3 < 2'b10)
         NextCount3       = (Count3) + 2'b01;
      else
         NextCount3       = 2'b00;
  
      if ((Count3 == 2'b01) & (SMMEMCLKDiv3 ==1'b0))
         NextSMMEMCLKDiv3 = 1'b1;
      else
         NextSMMEMCLKDiv3 = 1'b0;
    end
  else
    begin
      NextSMMEMCLKDiv3 = 1'b0;
      NextSMMEMCLKDiv2 = 1'b0;
      NextCount3       = 2'b00;
    end

end // p_MemClkDv3Comb

// -----------------------------------------------------------------------------
// Sequential logic for generating SMMEMCLKDiv2
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_MemClkDv2Seq
  if (HRESETn == 1'b0)
    begin
      SMMEMCLKDiv2     <= 1'b0;
      SMMEMCLKDiv3     <= 1'b0;
      Count3           <= 2'b00;
    end
  else
    begin
      SMMEMCLKDiv2     <= NextSMMEMCLKDiv2;
      SMMEMCLKDiv3     <= NextSMMEMCLKDiv3;
      Count3           <= NextCount3;
    end
end // p_MemClkDv2Seq

// -----------------------------------------------------------------------------
// Generate Slow Clocks to SMMem and SMMEMCLKDiv2.
// -----------------------------------------------------------------------------
always @(ClockRatio or SMMEMCLKDiv2 or SMMEMCLKDiv3)
begin : p_GenSlowClkComb
  case (ClockRatio)
    2'b01 :
      SlowClkM         = SMMEMCLKDiv2;
    2'b10 :
      SlowClkM         = SMMEMCLKDiv3;
    default :
      SlowClkM         = 1'b1;
  endcase
end // p_GenSlowClkComb


// synopsys translate_off
// ----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// ----------------------------------------------------------------------------


// Protocol checkers can be used for debugging purposes.


// ----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// ----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
