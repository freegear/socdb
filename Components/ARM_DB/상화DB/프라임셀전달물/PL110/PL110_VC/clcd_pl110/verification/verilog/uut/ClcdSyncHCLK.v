// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdSyncHCLK.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : This module double synchronises the signals
//                           entering the HCLK clock domain from CLCDCLK clock
//                           domains.
//
// --=========================================================================--
 
`timescale 1ns/1ps
 
//  ----------------------------------------------------------------------------
 
module ClcdSyncHCLK (
// Inputs
                     HCLK,
                     HRESETn,
                     FrameStart,
                     FrameRst,
                     VCompStat,
                     FRPInc,
// Outputs
                     FrStSyncHclk,
                     FrRstSyncHclk,
                     VCStatSyncHclk,
                     FRPIncSyncHclk
                    );

// Inputs
input         HCLK;              // AHB clock input 
input         HRESETn;           // AHB Bus Reset signal - HCLK domain
input         FrameRst;          // End of frame signal
input         FrameStart;        // Start of frame signal to start DMA transfer
input         VCompStat;         // Vertical compare status
input         FRPInc;            // DMA fifo read pointer increment enable

// Outputs
output         FrStSyncHclk;     // Frame start signal synchronised to HCLK
output         FrRstSyncHclk;    // Frame reset signal synchronised to HCLK
output         VCStatSyncHclk;   // VCompstat signal synchronised to HCLK
output         FRPIncSyncHclk;   // FRPInc signal synchronised to HCLK 

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module contains D-type registers for the synchronisation of signals
// coming to the HCLK clock domain.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// wire declaration
// -----------------------------------------------------------------------------
wire          HCLK;           
// AHB clock input                                          (Module Input)

wire          HRESETn;        
// AHB Bus Reset signal - HCLK domain                       (Module Input)

wire          FrameRst;       
// End of frame signal to reset DMAFifo/Unpacker            (Module Input)

wire          FrameStart;     
// Start of frame signal to start DMA transfer              (Module Input)

wire          VCompStat;      
// Vertical compare status                                  (Module Input)

wire           FRPInc;       
// DMA fifo read pointer increment enable                   (Module Input)



// -----------------------------------------------------------------------------
// Register declaration
// -----------------------------------------------------------------------------
reg            FrStSyncHclk;     
// Frame start signal synchronised to HCLK                  (Module Output)

reg            FrRstSyncHclk;    
// Frame reset signal synchronised to HCLK                  (Module Output)

reg            VCStatSyncHclk;   
// VCompstat signal synchronised to HCLK                    (Module Output)

reg            FRPIncSyncHclk;  
// FRPInc signal synchronised to HCLK                       (Module Output)

reg            FrStSyncInt;
// First level register for frame start signal

reg            FrRstSyncInt;
// First level register for frame reset signal

reg            FReadSyncInt;
// First level register for FReadInc signal

reg            VCStatSyncInt;
// First level register for VCompStat signal

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Synchronisation of signals coming to HCLK - first level
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SyncHclk1Seq
  if (HRESETn == 1'b0)
    begin
      FrStSyncInt    <=  1'b0;
      FrRstSyncInt   <=  1'b0;
      VCStatSyncInt  <=  1'b0;
      FReadSyncInt   <=  1'b0;
    end
  else
    begin
      FrStSyncInt    <=  FrameStart;
      FrRstSyncInt   <=  FrameRst;
      VCStatSyncInt  <=  VCompStat;
      FReadSyncInt   <=  FRPInc;
    end
end // p_SyncHclk1Seq

// -----------------------------------------------------------------------------
// Synchronisation of signals coming to HCLK - second level
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SyncHclk2Seq
  if (HRESETn == 1'b0)
    begin
      FrStSyncHclk    <=  1'b0;
      FrRstSyncHclk   <=  1'b0;
      VCStatSyncHclk  <=  1'b0;
      FRPIncSyncHclk  <=  1'b0;
    end
  else
    begin
      FrStSyncHclk    <=  FrStSyncInt;
      FrRstSyncHclk   <=  FrRstSyncInt;
      VCStatSyncHclk  <=  VCStatSyncInt;
      FRPIncSyncHclk  <=  FReadSyncInt;
    end
end // p_SyncHclk2Seq

endmodule

// --================================== End ==================================--
