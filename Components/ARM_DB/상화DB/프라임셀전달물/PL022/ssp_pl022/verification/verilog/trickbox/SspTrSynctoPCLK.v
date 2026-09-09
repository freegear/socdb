// --========================================================================---
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name              : SspTrSynctoPCLK.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose      : Synchronisers for signals crossing from SSPCLK domain to
//                PCLK domain
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrSynctoPCLK( 
                       PCLK, 
                       PRESETn,
                       TxRxBSY, 
                       TxFRdPtrInc, 
                       STxFRdPtrInc,
                       RxFWr,
                       SRxFWr,
                       TxRxBSYSync,
                       TxFRdPtrIncSync,
                       STxFRdPtrIncSync,
                       RxFWrSync,
                       SRxFWrSync
                      );
                       
input     PCLK ;                  // APB bus clock
input     PRESETn;                  // APB bus Reset 
input     TxRxBSY;                // SSPTRickbox Tx/Rx controller busy
input     TxFRdPtrInc;            // TX FIFO read pointer incr.for Masrer
input     STxFRdPtrInc;           // TX FIFO read pointer incr. for Slave
input     RxFWr;                  // RX FIFO write enable
input     SRxFWr;                 // RX FIFO write enable
output    TxRxBSYSync;            // To TX FIFO
output    TxFRdPtrIncSync;        // To TX FIFO
output    STxFRdPtrIncSync;       // To TX FIFO
output    RxFWrSync;              // To RX FIFO
output    SRxFWrSync;             // To RX FIFO

// -----------------------------------------------------------------------------
//
//                               SspTrSynctoPCLK
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This block implements the synchronisers for signals crossing over from the
// SSPCLK domain to the PCLK domain. The signals are 'double-synchronise'd 
// using inferred d-type flip-flops.
// 
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

wire  PCLK ;
// APB bus clock

wire  PRESETn;
// APB bus Reset 

wire  TxRxBSY;
// SSPTRickbox Tx/Rx controller busy

wire  TxFRdPtrInc;
// TX FIFO read pointer incr.for Masrer

wire  STxFRdPtrInc;
// TX FIFO read pointer incr. for Slave

wire  RxFWr;
// RX FIFO write enable

wire  SRxFWr;
// RX FIFO write enable

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

reg TxFRdPtrIncSync1 ;
// 1st stage synchronised version of TxFRdPtrInc input 

reg STxFRdPtrIncSync1 ;
// 1st stage synchronised version of STxFRdPtrInc input 

reg RxFWrSync1       ;
// 1st stage synchronised version of RxFWr input

reg SRxFWrSync1       ;
// 1st stage synchronised version of RxFWr input

reg TxRxBSYSync1     ;
// 1st stage synchronised version of TxRxBSY input

reg TxRxBSYSync;  
// To TX FIFO

reg TxFRdPtrIncSync;  
// To TX FIFO

reg STxFRdPtrIncSync;  
// To TX FIFO

reg RxFWrSync;
// To RX FIFO

reg SRxFWrSync;
// To RX FIFO

// ---------------------------------------------------------------------------
// 
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Double-synchronise with inferred D-types 
// -----------------------------------------------------------------------------
always @(PCLK or PRESETn)
begin : p_Sync
  if (PRESETn == 1'b0) 
    begin
      TxFRdPtrIncSync1  <= 1'b0;
      TxFRdPtrIncSync   <= 1'b0;
      STxFRdPtrIncSync1 <= 1'b0;
      STxFRdPtrIncSync  <= 1'b0;
      RxFWrSync1        <= 1'b0;
      SRxFWrSync1       <= 1'b0;
      RxFWrSync         <= 1'b0;
      SRxFWrSync        <= 1'b0;
      TxRxBSYSync1      <= 1'b0;
      TxRxBSYSync       <= 1'b0;
    end 
  else 
    begin
      TxFRdPtrIncSync1  <= TxFRdPtrInc;
      TxFRdPtrIncSync   <= TxFRdPtrIncSync1;
      STxFRdPtrIncSync1 <= STxFRdPtrInc;
      STxFRdPtrIncSync  <= STxFRdPtrIncSync1;
      RxFWrSync1        <= RxFWr;
      SRxFWrSync1       <= SRxFWr;
      RxFWrSync         <= RxFWrSync1;
      SRxFWrSync        <= SRxFWrSync1;
      TxRxBSYSync1      <= TxRxBSY;
      TxRxBSYSync       <= TxRxBSYSync1;
    end
end   // p_Sync;

endmodule

// --================================= End ===================================--

