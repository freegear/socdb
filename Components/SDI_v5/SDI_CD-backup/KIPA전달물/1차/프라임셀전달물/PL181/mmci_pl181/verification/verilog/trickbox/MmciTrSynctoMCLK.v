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
// File Name              : MmciTrSynctoMCLK.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Describe block function here.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrSynctoMCLK (
// Inputs
                         MCLK,
                         nMMCIRST,
                         MPUpdate,
                         MCUpdate,
                         MCMUpdate,
                         MDLUpdate,
                         MDCUpdate,
                         MTBCUpdate,
// Outputs
                         MPUpdateSync,
                         MCUpdateSync,
                         MCMUpdateSync,
                         MDLUpdateSync,
                         MDCUpdateSync,
                         MTBCUpdateSync
                        );

// Inputs
input      MCLK;           // Main MMCI Clock
input      nMMCIRST;       // MMCI Reset
input      MPUpdate;       // Updt sigl for MMCIPower
input      MCUpdate;       // Updt sigl for MMCIClock
input      MCMUpdate;      // Updt sigl for MMCICmd
input      MDLUpdate;      // Updt sigl for MMCIDataLength
input      MDCUpdate;      // Update signal for MMCIDataCntl
input      MTBCUpdate;     // Update signal for MMCITBCntl

// Outputs
output     MPUpdateSync;   // Sync Updt signal for MMCIPower
output     MCUpdateSync;   // Sync Updt signal for MMCIClock
output     MCMUpdateSync;  // Sync Updt signal for MMCICommand
output     MDLUpdateSync;  // Sync Updt signal for MMCIDataLen
output     MDCUpdateSync;  // Sync Updt signal for MMCIDataCtl
output     MTBCUpdateSync; // Sync Updt signal for MMCITBCtrl

// Inputs
wire     MCLK;             // Main MMCI Clock
wire     nMMCIRST;         // MMCI Reset
wire     MPUpdate;         // Updt sigl for MMCIPower
wire     MCUpdate;         // Updt sigl for MMCIClock
wire     MCMUpdate;        // Updt sigl for MMCICmd
wire     MDLUpdate;        // Updt sigl for MMCIDataLength
wire     MDCUpdate;        // Update signal for MMCIDataCntl
wire     MTBCUpdate;       // Update signal for MMCITBCntl

// Outputs
reg      MPUpdateSync;     // Sync Updt signal for MMCIPower
reg      MCUpdateSync;     // Sync Updt signal for MMCIClock
reg      MCMUpdateSync;    // Sync Updt signal for MMCICommand
reg      MDLUpdateSync;    // Sync Updt signal for MMCIDataLen
reg      MDCUpdateSync;    // Sync Updt signal for MMCIDataCtl
reg      MTBCUpdateSync;   // Sync Updt signal for MMCITBCtrl

// -----------------------------------------------------------------------------
//
//                              MmciTrSynctoMCLK
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//  In this block the PCLK generated signals are double synchronized
// using MCLK flops.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg      MPUpdateSync1;
// 1st stage synchronised version of MPUpdate input

reg      MCUpdateSync1;
// 1st stage synchronised version of MCUpdate input

reg      MCMUpdateSync1;
// 1st stage synchronised version of MCMUpdate input

reg      MDLUpdateSync1;
// 1st stage synchronised version of MDLUpdate input

reg      MDCUpdateSync1;
// 1st stage synchronised version of MDCUpdate input

reg      MTBCUpdateSync1;
// 1st stage synchronised version of MTBCUpdate input

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
// Double-synchronisation
// -----------------------------------------------------------------------------
always @(posedge MCLK or negedge nMMCIRST)
begin : p_syncMCLK
  if (nMMCIRST ==  1'b0)
    begin
      MPUpdateSync1    <= 1'b0;
      MCUpdateSync1    <= 1'b0;
      MCMUpdateSync1   <= 1'b0;
      MDLUpdateSync1   <= 1'b0;
      MDCUpdateSync1   <= 1'b0;
      MTBCUpdateSync1  <= 1'b0;
      MPUpdateSync     <= 1'b0;
      MCUpdateSync     <= 1'b0;
      MCMUpdateSync    <= 1'b0;
      MDLUpdateSync    <= 1'b0;
      MDCUpdateSync    <= 1'b0;
      MTBCUpdateSync   <= 1'b0;
   end
  else
    begin
      MPUpdateSync1    <= MPUpdate;
      MPUpdateSync     <= MPUpdateSync1;

      MCUpdateSync1    <= MCUpdate;
      MCUpdateSync     <= MCUpdateSync1;

      MCMUpdateSync1   <= MCMUpdate;
      MCMUpdateSync    <= MCMUpdateSync1;

      MDLUpdateSync1   <= MDLUpdate;
      MDLUpdateSync    <= MDLUpdateSync1;

      MDCUpdateSync1   <= MDCUpdate;
      MDCUpdateSync    <= MDCUpdateSync1;

      MTBCUpdateSync1  <= MTBCUpdate;
      MTBCUpdateSync   <= MTBCUpdateSync1;
    end
end // p_syncMCLK
endmodule
// --================================== End ==================================--
