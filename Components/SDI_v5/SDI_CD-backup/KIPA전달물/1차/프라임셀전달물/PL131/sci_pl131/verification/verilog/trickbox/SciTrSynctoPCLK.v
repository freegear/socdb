// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SciTrSynctoPCLK.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
//  
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Purpose     : This block synchronises signals crossing over from
//               the SCIREFCLK domain into the PCLK domain.
//------------------------------------------------------------------------------
`timescale 1ns/1ps  

//------------------------------------------------------------------------------

module SciTrSynctoPCLK (
                        TxFRdPtrInc,     
                        RxFWr,           
                        PCLK,           
                        PRESETn,           
                        TxFRdPtrIncSync, 
                        RxFWrSync       
                       );
input  TxFRdPtrInc;      // Sync Tx FIFO Rd point Inc
input  RxFWr;            // RX FIFO write
input  PCLK;             // APB bus clock
input  PRESETn;          // reset input
output TxFRdPtrIncSync;  // Tx FIFO Rd point Inc
output RxFWrSync;        // Sync for RX FIFO write
//------------------------------------------------------------------------------
//
//                   SciTrSynctoPCLK
//                   ===============
//
//------------------------------------------------------------------------------
// Overview
// ========
//
// This module synchronises signals crossing over from the PCLK
// domain into the SCIREFCLK domain.
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

reg DTxFRdPtrInc;
// Delayed version of TxFRdPtrInc

reg DRxFWr;
// Delayed  version of RxFWr

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
// Synchronisers for FIFO-related signals
//------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_FIFOSeq
  if (PRESETn == 1'b0)
  begin  
    DRxFWr       <= 1'b0;
    DTxFRdPtrInc <= 1'b0;
  end
  else
  begin
    DTxFRdPtrInc <= TxFRdPtrInc;
    DRxFWr       <= RxFWr;
  end
end // p_FIFOSeq;

//------------------------------------------------------------------------------
// Genrate a pule of width PCLK if any change in the signal level
//------------------------------------------------------------------------------
assign TxFRdPtrIncSync  = TxFRdPtrInc ^ DTxFRdPtrInc;
assign RxFWrSync        = RxFWr ^ DRxFWr; 
 
endmodule 

//=============================== End =======================================--














