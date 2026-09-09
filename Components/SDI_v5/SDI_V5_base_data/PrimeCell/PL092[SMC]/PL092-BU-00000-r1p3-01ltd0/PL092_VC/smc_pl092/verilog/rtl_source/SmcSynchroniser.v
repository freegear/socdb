// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcSynchroniser.v.rca
// File Revision          : 1.20
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//         The external asynchronous SMWAIT input and CANCELSMWAIT input are
//         double synchronised in this module and routed to the Timer module.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcSynchroniser (
// Inputs
                        HCLK,
                        HRESETn,
                        SMWAIT,
                        CANCELSMWAIT,

// Outputs
                        SmWaitS2,
                        CnclSmWaitS2
                       );

// Inputs
input         HCLK;            // AHB Bus Clock
input         HRESETn;         // AHB Bus Reset Signal
input         SMWAIT;          // Asynchronous Wait signal from external
                               // memory controller
input         CANCELSMWAIT;    // Asynchronous external input pin to signal
                               // that the SMWAIT has timed out



// Outputs
output        SmWaitS2;        // Double syncronized SMWAIT
output        CnclSmWaitS2;    // Double syncronised CanSMWAIT




// Inputs
wire          HCLK;            // AHB Bus Clock
wire          HRESETn;         // AHB Bus Reset Signal
wire          SMWAIT;          // Asynchronous Wait signal from external
                               // memory controller
wire          CANCELSMWAIT;    // Asynchronous external input pin to signal
                               // that the SMWAIT has timed out



// Outputs
reg           SmWaitS2;        // Double syncronized SMWAIT
reg           CnclSmWaitS2;    // Double syncronised CanSMWAIT


// -----------------------------------------------------------------------------
//
//                               SmcSynchroniser
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// The external asynchronous SMWAIT input and CANCELSMWAIT input are double
// synchronised in this module and routed to the Timer module.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg      SmWaitS1;
// First level syncronization of the async SMWAIT

reg      CnclSmWaitS1;
// First level synchronisation of the async CanSMWAIT

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


// -----------------------------------------------------------------------------
// In this process the external async SMWAIT signal from the external memory
// controller is double synchronized .
// The polarity of this input is programmable. So by default the SMWAIT is
// assumed to be active low
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SMWaitSyncSeq
  if (HRESETn == 1'b0)
    begin
      SmWaitS1         <= 1'b1;
      SmWaitS2         <= 1'b1;
      CnclSmWaitS1     <= 1'b0;
      CnclSmWaitS2     <= 1'b0;
    end
  else
    begin
      SmWaitS1         <= SMWAIT;
      SmWaitS2         <= SmWaitS1;
      CnclSmWaitS1     <= CANCELSMWAIT;
      CnclSmWaitS2     <= CnclSmWaitS1;
    end
end // p_SMWaitSyncSeq

endmodule
// --================================== End ==================================--
