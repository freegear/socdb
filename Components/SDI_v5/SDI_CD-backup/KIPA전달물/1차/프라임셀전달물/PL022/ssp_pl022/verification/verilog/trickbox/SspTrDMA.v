// ============================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name              : SspTrDMA.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
// Purpose     : This block generates the SSPDMACLR signals
//  
// ========================================================================== --
//  

`timescale 1ns/1ps

//  ----------------------------------------------------------------------------

module SspTrDMA(
                PCLK,
                PRESETn,
                SSPTXDMACLRStag1,
                SSPRXDMACLRStag1,
                SSPTXDMACLR,
                SSPRXDMACLR,
                SSPTXDMACLRStag2,
                SSPRXDMACLRStag2
               );

input         PCLK;             // APB Clock
input         PRESETn;          // Muxed Reset (from PRESETn)
input         SSPTXDMACLRStag1; // 1st stage for SSPTXDMACLR
input         SSPRXDMACLRStag1; // 1st stage for SSPRXDMACLR
output        SSPTXDMACLR;      // Transmit DMA request clear
output        SSPRXDMACLR;      // Receive DMA request clear
output        SSPTXDMACLRStag2; // For SSPTXDMACLR
output        SSPRXDMACLRStag2; // For SSPRXDMACLR


// -----------------------------------------------------------------------------
//
//                   SspTrDMA
//                   =========
//
// -----------------------------------------------------------------------------
// Overview
// ========
// This module generates the SSPTXDMACLR and SSPRXDMACLR signals.
// These are used to test the Ssp DMA interface.

 
// -----------------------------------------------------------------------------
// Component declarations
//
// --------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

reg SSPTXDMACLRStag2;
// Internal version of 1st delayed version of SSPTXDMACLRStag1

reg TXDMACLRStag3;
// 2nd delayed version of SSPTXDMACLRStag1

reg SSPRXDMACLRStag2;
// Internal version of 1st delayed version of SSPRXDMACLRStag1

reg RXDMACLRStag3;
// 2nd delayed version of SSPRXDMACLRStag1


// -----------------------------------------------------------------------------
// 
// Main Verilog code
// ==============
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Sequential process for registers/flip-flops in this block
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_Seq
  if (~PRESETn)
  begin
    SSPTXDMACLRStag2 <= 1'b0;
    TXDMACLRStag3    <= 1'b0;
    SSPRXDMACLRStag2 <= 1'b0;
    RXDMACLRStag3    <= 1'b0;
  end
  else
  begin
    SSPTXDMACLRStag2   <= SSPTXDMACLRStag1;
    TXDMACLRStag3       <= SSPTXDMACLRStag2;
    SSPRXDMACLRStag2   <= SSPRXDMACLRStag1;
    RXDMACLRStag3       <= SSPRXDMACLRStag2;
  end
end // p_Seq;
  

// ------------------------------------------------------------------
// SSPTXDMACLR is a two PCLK-wide pulse used to clear the
// SSPTXDMA requests.
// ------------------------------------------------------------------

assign SSPTXDMACLR = ((SSPTXDMACLRStag1 &  ~(SSPTXDMACLRStag2) &
                   ~(TXDMACLRStag3)) | (SSPTXDMACLRStag1 &
                                           SSPTXDMACLRStag2 &
                                           ~(TXDMACLRStag3)));   
 

// ------------------------------------------------------------------
// SSPRXDMACLR is a two PCLK-wide pulse used to clear the
// SSPRXDMA requests.
// ------------------------------------------------------------------

assign SSPRXDMACLR = ((SSPRXDMACLRStag1 & ~(SSPRXDMACLRStag2) &
                   ~(RXDMACLRStag3)) | (SSPRXDMACLRStag1 &
                                           SSPRXDMACLRStag2 &
                                           ~(RXDMACLRStag3)));
endmodule


// ========================= End of SspTrDMA ==============================--
