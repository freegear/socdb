// ============================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name              : SciTrDMA.v.rca
//  File Revision          : 1.1
//  
//  Release Information    : PrimeCell(TM)-PL131-REL1v0
//  
// -----------------------------------------------------------------------------
// Purpose     : This block generates the SCIDMACLR signals
//  
// ========================================================================== --
//  

`timescale 1ns/1ps

//  ----------------------------------------------------------------------------

module SciTrDMA(
                PCLK,
                PRESETn,
                SCITXDMACLRStag1,
                SCIRXDMACLRStag1,
                SCITXDMACLR,
                SCIRXDMACLR,
                SCITXDMACLRStag2,
                SCIRXDMACLRStag2
               );

input         PCLK;             // APB Clock
input         PRESETn;          // Muxed Reset (from PRESETn)
input         SCITXDMACLRStag1; // 1st stage for SCITXDMACLR
input         SCIRXDMACLRStag1; // 1st stage for SCIRXDMACLR
output        SCITXDMACLR;      // Transmit DMA request clear
output        SCIRXDMACLR;      // Receive DMA request clear
output        SCITXDMACLRStag2; // For SCITXDMACLR
output        SCIRXDMACLRStag2; // For SCIRXDMACLR


// -----------------------------------------------------------------------------
//
//                   SciTrDMA
//                   =========
//
// -----------------------------------------------------------------------------
// Overview
// ========
// This module generates the SCITXDMACLR and SCIRXDMACLR signals.
// These are used to test the Sci DMA interface.

 
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

reg SCITXDMACLRStag2;
// Internal version of 1st delayed version of SCITXDMACLRStag1

reg TXDMACLRStag3;
// 2nd delayed version of SCITXDMACLRStag1

reg SCIRXDMACLRStag2;
// Internal version of 1st delayed version of SCIRXDMACLRStag1

reg RXDMACLRStag3;
// 2nd delayed version of SCIRXDMACLRStag1


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
    SCITXDMACLRStag2 <= 1'b0;
    TXDMACLRStag3    <= 1'b0;
    SCIRXDMACLRStag2 <= 1'b0;
    RXDMACLRStag3    <= 1'b0;
  end
  else
  begin
    SCITXDMACLRStag2 <= SCITXDMACLRStag1;
    TXDMACLRStag3    <= SCITXDMACLRStag2;
    SCIRXDMACLRStag2 <= SCIRXDMACLRStag1;
    RXDMACLRStag3    <= SCIRXDMACLRStag2;
  end
end // p_Seq;
  

// ------------------------------------------------------------------
// SCITXDMACLR is a two PCLK-wide pulse used to clear the
// SCITXDMA requests.
// ------------------------------------------------------------------

assign SCITXDMACLR = ((SCITXDMACLRStag1 &  ~(SCITXDMACLRStag2) &
                   ~(TXDMACLRStag3)) | (SCITXDMACLRStag1 &
                                           SCITXDMACLRStag2 &
                                           ~(TXDMACLRStag3)));   
 

// ------------------------------------------------------------------
// SCIRXDMACLR is a two PCLK-wide pulse used to clear the
// SCIRXDMA requests.
// ------------------------------------------------------------------

assign SCIRXDMACLR = ((SCIRXDMACLRStag1 & ~(SCIRXDMACLRStag2) &
                   ~(RXDMACLRStag3)) | (SCIRXDMACLRStag1 &
                                           SCIRXDMACLRStag2 &
                                           ~(RXDMACLRStag3)));
endmodule


// ========================= End of SciTrDMA ==============================--
