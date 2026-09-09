// --========================================================================--
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
//  File Name              : SspTrSynctoSSPCLK.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose      : Synchronisers for signals crossing from PCLK domain to
//                SSPCLK domain
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SspTrSynctoSSPCLK 
                        (
                         SSPCLK,
                         nSSPRES,    
                         TxDataAvlbl,
                         CR0Update, 
                         CR1Update,
                         SSE,     
                         TxDataAvlblSync,
                         CR0UpdateSync, 
                         CR1UpdateSync,
                         SSESync     
                        );

input      SSPCLK;	        // Main SSP clock
input      nSSPRES;	        // SSPClk Reset 
input      TxDataAvlbl;	        // TX data available
input      CR0Update;	        // Ctrl signal for SSPCR0 sync
input      CR1Update;	        // Ctrl signal for SSPCR1 sync
input      SSE;	                // SSPTB enable
output     TxDataAvlblSync;	// To TxRx block
output     CR0UpdateSync;	// To Prescaler
output     CR1UpdateSync;	// To Prescaler
output     SSESync;      	// SSPTrickbox enable

// -----------------------------------------------------------------------------
//
//                           SspTrSynctoSSPCLK
//                           =================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This block implements the synchronisers for signals crossing over from the
// PCLK domain to the SSPCLK domain. The signals are 'double-synchronise'd using
// inferred d-type flip-flops.
// 
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Wire declarations
// -----------------------------------------------------------------------------

wire   SSPCLK;
// Main SSP clock

wire   nSSPRES;
// SSPClk Reset 

wire   TxDataAvlbl;
// TX data available

wire   CR0Update;
// Ctrl signal for SSPCR0 sync

wire   CR1Update;
// Ctrl signal for SSPCR1 sync

wire   SSE;
// SSPTB enable

// -----------------------------------------------------------------------------
//  Register declarations
// -----------------------------------------------------------------------------

reg CR0UpdateSync1;
// 1st stage synchronised version of SSCRUpdate input

reg CR1UpdateSync1;
// 1st stage synchronised version of SSCRUpdate input
  
reg TxDataAvlblSync1;
// 1st stage synchronised version of TxDataAvlbl input

reg SSESync1;
// 1st stage synchronised version of SSE input

reg TxDataAvlblSync;	
// To TxRx block

reg CR0UpdateSync;
// To Prescaler

reg CR1UpdateSync;
// To Prescaler

reg SSESync; 
// SSPTrickbox enable

// -----------------------------------------------------------------------------
// 
// Main body of code
// ==================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Double-synchronise with inferred D-types 
// -----------------------------------------------------------------------------
always @(SSPCLK or nSSPRES)
begin : p_SyncSeq
  if (nSSPRES == 1'b0) 
    begin
      CR0UpdateSync1   <= 1'b0;
      CR1UpdateSync1   <= 1'b0;
      CR1UpdateSync    <= 1'b0;
      CR0UpdateSync    <= 1'b0;
      TxDataAvlblSync1 <= 1'b0;
      TxDataAvlblSync  <= 1'b0;
      SSESync1         <= 1'b0;
      SSESync          <= 1'b0;
    end
  else 
    begin
      CR0UpdateSync1   <= CR0Update;
      CR0UpdateSync    <= CR0UpdateSync1;
      CR1UpdateSync1   <= CR1Update;
      CR1UpdateSync    <= CR1UpdateSync1;
      TxDataAvlblSync1 <= TxDataAvlbl;
      TxDataAvlblSync  <= TxDataAvlblSync1;
      SSESync1         <= SSE;
      SSESync          <= SSESync1;
    end
end   // p_SyncSeq;

endmodule

// --================================== End ==================================--



