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
// File Name              : MmciTrSynctoPCLK.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           All MMCICLK domain signals are synchronised to PCLK.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciTrSynctoPCLK (
// Inputs
                         PCLK,
                         PRESETn,
                         MTBCIUpdate,
                         MTBCAUpdate,
                         RxFWr,
                         TxFRd,
                         FifoClear,
// Outputs
                         MTBCIUpdateSync,
                         MTBCAUpdateSync,
                         FifoClearSync,
                         RxFWrSync,
                         TxFRdSync
                        );

// Inputs
input      PCLK;            // APB Bus Clock
input      PRESETn;         // APB Bus reset
input      MTBCIUpdate;     // Update sig for MMCITBRxdCInd
input      MTBCAUpdate;     // Update sig for MMCITBRxdCArg
input      RxFWr;           // Rx FIFO Wr enable
input      TxFRd;           // Tx FIFO Rd enable
input      FifoClear;       // Fifo clear signal

// Outputs
output     MTBCIUpdateSync; // Syncd Updt sig for MMCITBRxdCInd
output     MTBCAUpdateSync; // Syncd Updt sig for MMCITBRxdCArg
output     FifoClearSync;   // Syncd clear signal
output     RxFWrSync;       // Syncd Rx FIFO Wr enable
output     TxFRdSync;       // Syncd Tx FIFO Rd enable

// Inputs
wire     PCLK;              // APB Bus Clock
wire     PRESETn;           // APB Bus reset
wire     MTBCIUpdate;       // Update sig for MMCITBRxdCInd
wire     MTBCAUpdate;       // Update sig for MMCITBRxdCArg
wire     RxFWr;             // Rx FIFO Wr enable
wire     TxFRd;             // Tx FIFO Rd enable
wire     FifoClear;         // Fifo clear signal

// Outputs
reg      MTBCIUpdateSync;   // Syncd Updt sig for MMCITBRxdCInd
reg      MTBCAUpdateSync;   // Syncd Updt sig for MMCITBRxdCArg
reg      FifoClearSync;     // Syncd clear signal
reg      RxFWrSync;         // Syncd Rx FIFO Wr enable
reg      TxFRdSync;         // Syncd Tx FIFO Rd enable

// -----------------------------------------------------------------------------
//
//                              MmciTrSynctoPCLK
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//  In this block the MMCICLK generated signals are double synchronised
// using PCLK.
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
reg      MTBCIUpdateSync1;
// 1st stage synchronised version of MTBCIUpdate input

reg      MTBCAUpdateSync1;
// 1st stage synchronised version of MTBCAUpdate input

reg      RxFWrSync1;
// 1st stage synchronised version of RxFWr

reg      TxFRdSync1;
// 1st stage synchronised version of TxFRd

reg      FifoClearSync1;
// 1st stage synchronised version of FifoClear

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
always @(posedge PCLK or negedge PRESETn)
begin : p_syncPCLK
  if (PRESETn ==  1'b0)
    begin
      MTBCIUpdateSync1 <= 1'b0;
      MTBCAUpdateSync1 <= 1'b0;
      RxFWrSync1       <= 1'b0;
      TxFRdSync1       <= 1'b0;
      FifoClearSync1   <= 1'b0;
      MTBCIUpdateSync  <= 1'b0;
      MTBCAUpdateSync  <= 1'b0;
      RxFWrSync        <= 1'b0;
      TxFRdSync        <= 1'b0;
      FifoClearSync    <= 1'b0;
    end
  else
    begin
      MTBCIUpdateSync1 <= MTBCIUpdate;
      MTBCIUpdateSync  <= MTBCIUpdateSync1;

      MTBCAUpdateSync1 <= MTBCAUpdate;
      MTBCAUpdateSync  <= MTBCAUpdateSync1;

      RxFWrSync1       <= RxFWr;
      RxFWrSync        <= RxFWrSync1;

      TxFRdSync1       <= TxFRd;
      TxFRdSync        <= TxFRdSync1;

      FifoClearSync1   <= FifoClear;
      FifoClearSync    <= FifoClearSync1;
    end
end // p_syncPCLK
endmodule
// --================================== End ==================================--
