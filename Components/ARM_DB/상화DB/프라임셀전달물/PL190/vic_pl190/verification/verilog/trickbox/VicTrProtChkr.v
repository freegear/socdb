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
// File Name              : VicTrProtChkr.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           This module compares the actual interrupt outputs from
//           the VIC with the expected outputs.
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module VicTrProtChkr (
// Inputs
                      HCLK,
                      HRESETn,
                      VICTrTCR,
                      nVICFIQ,
                      nFIQ,
                      nVICIRQ,
                      nIRQ,
                      VICVECTADDROUT,
                      VICTrVectAddrOut
                      );

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input   [2:0] VICTrTCR;         // Compare-Enable signals
input         nVICFIQ;          // nVICFIQ output from the VIC
input         nFIQ;             // Expected nFIQ from the VicTrVectBank
input         nVICIRQ;          // nVICIRQ output from the VIC
input         nIRQ;             // Expected nIRQ from the VicTrVectBank
input  [31:0] VICVECTADDROUT;   // VICVECTADDROUT output from the VIC
input  [31:0] VICTrVectAddrOut; // Expected TrVectAddrOut output from
                                // the VicTrVectBank

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire    [2:0] VICTrTCR;         // Compare-Enable signals
wire          nVICFIQ;          // nVICFIQ output from the VIC
wire          nFIQ;             // Expected nFIQ from the VicTrVectBank
wire          nVICIRQ;          // nVICIRQ output from the VIC
wire          nIRQ;             // Expected nIRQ from the VicTrVectBank
wire   [31:0] VICVECTADDROUT;   // VICVECTADDROUT output from the VIC
wire   [31:0] VICTrVectAddrOut; // Expected TrVectAddrOut output from
                                // the VicTrVectBank

// ---------------------------------------------------------------------
//
//                            VicTrProtChkr
//                            =============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module compares the interrupt and interrupt vector outputs
// from the VIC with the corresponding internally generated signals.
// Error messages are flagged when there is a mismatch.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        FIQCompEn;
// FIQ compare Enable signal

wire        IRQCompEn;
// IRQ compare Enable signal

wire        VectAdCompEn;
// VectAddrOut compare Enable signal

wire        FIQError;
// FIQ Error Message generator Enable signal

wire        IRQError;
// IRQ Error Message generator Enable signal

wire        VectAddrError;
// VectAddrOut Error Message generator Enable signal

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Enable-signals Assignment
// ---------------------------------------------------------------------
assign FIQCompEn        = VICTrTCR[0];
assign IRQCompEn        = VICTrTCR[1];
assign VectAdCompEn     = VICTrTCR[2];

assign FIQError         = (nFIQ != nVICFIQ) ? FIQCompEn : 1'b0;

assign IRQError         = (nIRQ != nVICIRQ) ? IRQCompEn : 1'b0;

assign VectAddrError    = (VICTrVectAddrOut != VICVECTADDROUT) ?
                           VectAdCompEn : 1'b0;

// ---------------------------------------------------------------------
// FIQ Error Message generator
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_FIQErrorProt
  if (FIQError == 1'b1)
    $display("VICTB1: Error in received nVICFIQ");
end // p_FIQErrorProt

// ---------------------------------------------------------------------
// IRQ Error Message generator
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_IRQErrorProt
  if (IRQError == 1'b1)
    $display("VICTB2: Error in received nVICIRQ");
end // p_IRQErrorProt

// ---------------------------------------------------------------------
// VectAddrOut Error Message generator
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_VectAdErrorProt
  if (VectAddrError == 1'b1)
    $display("VICTB3: Error in received VICVECTADDROUT");
end // p_VectAdErrorProt

endmodule

// --============================== End ==============================--
