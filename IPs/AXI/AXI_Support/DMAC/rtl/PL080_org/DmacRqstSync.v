// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacRqstSync.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           DMA controller DMA requests synchroniser module
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacRqstSync (
// Inputs
                     // AHB signals
                     HCLK,
                     HRESETn,
                     // DMA requests from the peripherals
                     // All the requests are gated with DMACEn
                     MskdDMACBREQ,
                     MskdDMACLBREQ,
                     MskdDMACSREQ,
                     MskdDMACLSREQ,

// Outputs
                     // Synchronised version of the requests as outputs
                     DMACBREQSync,
                     DMACLBREQSync,
                     DMACSREQSync,
                     DMACLSREQSync
                     );

// Inputs

// AHB signals
input         HCLK;             // AHB clock
input         HRESETn;          // AHB Reset
// DMA requests from the peripherals
// All the requests are gated with DMACEn
input  [15:0] MskdDMACBREQ;     // DMA burst transfer request
input  [15:0] MskdDMACLBREQ;    // DMA last burst transfer request
input  [15:0] MskdDMACSREQ;     // DMA single transfer request
input  [15:0] MskdDMACLSREQ;    // DMA last single transfer request

// Outputs
// Synchronised version of the requests as outputs
output [15:0] DMACBREQSync;     // DMA burst transfer request
output [15:0] DMACLBREQSync;    // DMA last burst transfer request
output [15:0] DMACSREQSync;     // DMA single transfer request
output [15:0] DMACLSREQSync;    // DMA last single transfer request

// Inputs
// AHB signals
wire          HCLK;             // AHB clock
wire          HRESETn;          // AHB Reset
// DMA requests from the peripherals
// All the requests are gated with DMACEn
wire   [15:0] MskdDMACBREQ;     // DMA burst transfer request
wire   [15:0] MskdDMACLBREQ;    // DMA last burst transfer request
wire   [15:0] MskdDMACSREQ;     // DMA single transfer request
wire   [15:0] MskdDMACLSREQ;    // DMA last single transfer request

// Outputs
// Synchronised version of the requests as outputs
reg    [15:0] DMACBREQSync;     // DMA burst transfer request
reg    [15:0] DMACLBREQSync;    // DMA last burst transfer request
reg    [15:0] DMACSREQSync;     // DMA single transfer request
reg    [15:0] DMACLSREQSync;    // DMA last single transfer request

// -----------------------------------------------------------------------------
//
//                                DmacRqstSync
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   This module is used for synchronising the external peripheral requests to
// the HCLK domain. This uses double synhronisation for all the requests for
// synchronisation.
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
reg  [15:0] DMACSREQSync1;
// First level of synchronised signal for DMACSREQ

reg  [15:0] DMACBREQSync1;
// First level of synchronised signal for DMACBREQ

reg  [15:0] DMACLSREQSync1;
// First level of synchronised signal for DMACLSREQ

reg  [15:0] DMACLBREQSync1;
// First level of synchronised signal for DMACLBREQ

//Include Parameters File
`include "DmacParams.v"

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
// Combinational assignments
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Synchronising the requests from the peripherals to the HCLK domain
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_ReqSyncToHClkSeq
  if (HRESETn == 1'b0)
    begin
      DMACSREQSync     <= 16'b0;
      DMACBREQSync     <= 16'b0;
      DMACLSREQSync    <= 16'b0;
      DMACLBREQSync    <= 16'b0;
      DMACSREQSync1    <= 16'b0;
      DMACBREQSync1    <= 16'b0;
      DMACLSREQSync1   <= 16'b0;
      DMACLBREQSync1   <= 16'b0;
    end
  else
    begin
      DMACSREQSync     <= DMACSREQSync1;
      DMACBREQSync     <= DMACBREQSync1;
      DMACLSREQSync    <= DMACLSREQSync1;
      DMACLBREQSync    <= DMACLBREQSync1;
      DMACSREQSync1    <= MskdDMACSREQ;
      DMACBREQSync1    <= MskdDMACBREQ;
      DMACLSREQSync1   <= MskdDMACLSREQ;
      DMACLBREQSync1   <= MskdDMACLBREQ;
    end
end // p_ReqSyncToHClkSeq

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// synopsys translate_on

endmodule
// --================================== End ==================================--
