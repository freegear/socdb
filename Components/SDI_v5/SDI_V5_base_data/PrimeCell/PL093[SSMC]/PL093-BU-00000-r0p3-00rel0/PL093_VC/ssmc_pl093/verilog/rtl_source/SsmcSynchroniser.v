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
// File Name              : SsmcSynchroniser.v.rca
// File Revision          : 1.10
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Asynchronous external inputs are double synchronised in
//           this module.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcSynchroniser (
// Inputs
                         SMMEMCLK,
                         HRESETn,
                         SMWAIT,
                         SMCANCELWAIT,
                         WaitPol,
// Outputs
                         SMWaitSync,
                         SmCancelWaitSync
                         );

// Inputs
input      SMMEMCLK;         // AHB Bus Clock
input      HRESETn;          // AHB Bus Reset Signal
input      SMWAIT;           // Asynchronous Wait signal from external memory
                             // controller
input      SMCANCELWAIT;     // Asynchronous external input pin to signal that
                             // the SMWAIT has timed out
input      WaitPol;          // Indication of the Wait polarity

// Outputs
output     SMWaitSync;       // Double synchronised SMWAIT
output     SmCancelWaitSync; // Double synchronised CanSMWAIT




// Inputs
  wire     SMMEMCLK;         // AHB Bus Clock
  wire     HRESETn;          // AHB Bus Reset Signal
  wire     SMWAIT;           // Asynchronous Wait signal from external memory
                             // controller
  wire     SMCANCELWAIT;     // Asynchronous external input pin to signal that
                             // the SMWAIT has timed out
  wire     WaitPol;          // Indication of the Wait polarity

// Outputs
  wire     SMWaitSync;       // Double synchronised SMWAIT
  reg      SmCancelWaitSync; // Double synchronised CanSMWAIT


// -----------------------------------------------------------------------------
//
//                              SsmcSynchroniser
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//         The external asynchronous SMWAIT input and SMCANCELWAIT input are
//         double synchronised in this module and routed to SsmcTSM module
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
reg      SMWaitSync1;
// First level Synchronisation of the Async SMWAIT

reg      SMWaitSync2;
// Second level Synchronisation of the Async SMWAIT

reg      SmCnclWaitSync1;
// First level Synchronisation of the Async SMCANCELWAIT

// -----------------------------------------------------------------------------
// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// In this process the external asynchronous SMWAIT and SMCANCELWAIT signals
// from the external controller are double synchronised before use.
// The polarity of SMWAIT input is programmable. So by default the SMWAIT is
// assumed to be active low.
// The SMCANCELWAIT input is an active high signal which indicates that
// after assertion of the SMWAIT input, the time out for the de-assertion has
// occured. The SsmcCore will then abort this transfer with an error response.
// -----------------------------------------------------------------------------
always @(posedge SMMEMCLK or negedge HRESETn)
begin : p_SMWaitSyncSeq
  if (HRESETn == 1'b0)
    begin
      SMWaitSync1      <= 1'b1;
      SMWaitSync2      <= 1'b1;
      SmCnclWaitSync1  <= 1'b0;
      SmCancelWaitSync <= 1'b0;
    end
  else
    begin
      SMWaitSync1      <= SMWAIT;
      SMWaitSync2      <= SMWaitSync1;
      SmCnclWaitSync1  <= SMCANCELWAIT;
      SmCancelWaitSync <= SmCnclWaitSync1;
    end
end // p_SMWaitSyncSeq

assign SMWaitSync       = (WaitPol == 1'b0) ? SMWaitSync2 : ~SMWaitSync2;
endmodule
// --================================== End ==================================--
