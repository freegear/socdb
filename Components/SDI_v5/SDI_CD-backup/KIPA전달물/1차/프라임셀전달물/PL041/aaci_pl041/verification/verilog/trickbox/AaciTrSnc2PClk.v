// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name              : AaciTrSnc2PClk.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           Synchronisers for signals crossing from BITCLK domain to
//           PCLK domain
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module AaciTrSnc2PClk (
// Inputs
                       // APB signals
                       PCLK,
                       PRESETn,
                       TxFRdPtrInc,
                       RxFWr,
// Outputs
                       TxFRdPtrIncSync,
                       RxFWrSync
                      );
// Inputs
input         PCLK;             // APB clock
input         PRESETn;          // APB Reset
input         TxFRdPtrInc;      // TX FIFO read pointer increament
input         RxFWr;            // RX FIFO write enable
// Outputs
output        TxFRdPtrIncSync;  // To TX FIFO read pointer increment
output        RxFWrSync;        // To RX FIFO write

// Inputs
wire          PCLK;             // APB clock
wire          PRESETn;          // APB Reset
wire          TxFRdPtrInc;      // TX FIFO read pointer increament
wire          RxFWr;            // RX FIFO write enable
// Outputs
reg           TxFRdPtrIncSync;  // To TX FIFO read pointer increment
reg           RxFWrSync;        // To RX FIFO write

// ---------------------------------------------------------------------
//
//                           AaciTrSnc2PClk
//                           ==============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
// This block implements the synchronisers for signals crossing over 
// from the BITCLK domain to the PCLK domain. The signals are 'double-
// synchronise'd using inferred d-type flip-flops.
// 
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg         TxFRdPtrIncSync1;
// 1st stage synchronised version of TxFRdPtrInc input 

reg         RxFWrSync1;
// 1st stage synchronised version of RxFWr input

// -------------------------------------------------------------------
// 
// Main body of Code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Double-synchronise with inferred D-types 
// ---------------------------------------------------------------------
always @( posedge PCLK or negedge PRESETn)
begin : p_Sync
  if (PRESETn == 1'b0)
    begin
      TxFRdPtrIncSync1  <= 1'b0;
      TxFRdPtrIncSync   <= 1'b0;
      RxFWrSync1        <= 1'b0;
      RxFWrSync         <= 1'b0;
    end
  else
    begin
      TxFRdPtrIncSync1  <= TxFRdPtrInc;
      TxFRdPtrIncSync   <= TxFRdPtrIncSync1;
      RxFWrSync1        <= RxFWr;
      RxFWrSync         <= RxFWrSync1;
    end
end // process p_Sync;

endmodule

// --========================= End ===================================--
