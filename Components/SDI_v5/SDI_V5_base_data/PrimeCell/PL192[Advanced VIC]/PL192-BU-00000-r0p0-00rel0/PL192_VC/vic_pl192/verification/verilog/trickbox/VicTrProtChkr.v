// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : VicTrProtChkr.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module compares the actual interrupt outputs from
//           the VIC with the expected outputs.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicTrProtChkr (
// Inputs
                      HCLK,
                      HRESETn,
                      VICTrTCR,
                      nVICFIQ,
                      nFIQ,
                      nVICIRQ,
                      nIRQ,
                      VICVECTADDRV,
                      VICTrVectAddrv,
                      VICIRQACKOUT,
                      VicTrIrqAckOut,
                      VICVECTADDROUT,
                      VICTrVectAddrOut
                      );

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input   [8:0] VICTrTCR;         // Compare-Enable signals
input         nVICFIQ;          // nVICFIQ output from the VIC
input         nFIQ;             // Expected nFIQ from the VICTrMirTrickbox
input         nVICIRQ;          // nVICIRQ output from the VIC
input         nIRQ;             // Expected nIRQ from the VICTrMirTrickbox
input         VICVECTADDRV;     // VIC Address valid Signal which indicates
                                // Address valid from VIC
input         VICTrVectAddrv;   // VIC Address valid Signal which indicates
                                // Address valid from VICTrMirTrickbox
input         VICIRQACKOUT;     // VIC Acknowledge signal
input         VicTrIrqAckOut;   // VICTrMirTrickbox Acknowledge signal
input  [31:0] VICVECTADDROUT;   // VICVECTADDROUT output from the VIC
input  [31:0] VICTrVectAddrOut; // Expected TrVectAddrOut output from
                                // the VICTrMirTrickbox

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire    [8:0] VICTrTCR;         // Compare-Enable signals
wire          nVICFIQ;          // nVICFIQ output from the VIC
wire          nFIQ;             // Expected nFIQ from the VicTrVectBank
wire          nVICIRQ;          // nVICIRQ output from the VIC
wire          nIRQ;             // Expected nIRQ from the VicTrVectBank
wire          VICVECTADDRV;     // VIC Address valid Signal which indicates
                                // Address valid from VIC
wire          VICTrVectAddrv;   // VIC Address valid Signal which indicates
                                // Address valid from VICTrMirTrickbox
wire          VICIRQACKOUT;     // VIC Acknowledge signal
wire          VicTrIrqAckOut;   // VICTrMirTrickbox Acknowledge signal
wire   [31:0] VICVECTADDROUT;   // VICVECTADDROUT output from the VIC
wire   [31:0] VICTrVectAddrOut; // Expected TrVectAddrOut output from
                                // the VICTrMirTrickbox

// -----------------------------------------------------------------------------
//
//                            VicTrProtChkr
//                            =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module compares the interrupt and interrupt vector outputs
// from the VIC with the corresponding internally generated signals.
// Error messages are flagged when there is a mismatch.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        FIQCompEn;
// FIQ compare Enable signal

wire        IRQCompEn;
// IRQ compare Enable signal

wire        VectAdCompEn;
// VectAddrOut compare Enable signal

wire        VectAdvCompEn;
// VectAddr Valid compare Enable signal

wire        VectAckCompEn;
// VectAck compare Enable signal

wire        FIQError;
// FIQ Error Message generator Enable signal

wire        IRQError;
// IRQ Error Message generator Enable signal

wire        VectAddrError;
// VectAddrOut Error Message generator Enable signal

wire        VectAdVldError;
// VectAddrOut Error Message generator Enable signal

wire        VectAckError;
// VectAddrOut Error Message generator Enable signal

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

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
// Enable-signals Assignment
// -----------------------------------------------------------------------------
assign FIQCompEn        = VICTrTCR[0];
assign IRQCompEn        = VICTrTCR[1];
assign VectAdCompEn     = VICTrTCR[2];
assign VectAdvCompEn    = VICTrTCR[3];
assign VectAckCompEn    = VICTrTCR[4];

assign FIQError         = (nFIQ != nVICFIQ) ? FIQCompEn : 1'b0;

assign IRQError         = (nIRQ != nVICIRQ) ? IRQCompEn : 1'b0;

assign VectAddrError    = (VICTrVectAddrOut != VICVECTADDROUT) ?
                           VectAdCompEn : 1'b0;

assign VectAdVldError   = (VICTrVectAddrv != VICVECTADDRV) ?
                           VectAdvCompEn : 1'b0;
 
assign VectAckError     = (VicTrIrqAckOut != VICIRQACKOUT) ?
                           VectAckCompEn : 1'b0;
 
// -----------------------------------------------------------------------------
// FIQ Error Message generator
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_FIQErrorProt
  if (FIQError == 1'b1)
    $display("VICTB1:Time %t :Error in received nVICFIQ", $time);
end // p_FIQErrorProt

// -----------------------------------------------------------------------------
// IRQ Error Message generator
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_IRQErrorProt
  if (IRQError == 1'b1)
    $display("VICTB2:Time %t :Error in received nVICIRQ", $time);
end // p_IRQErrorProt

// -----------------------------------------------------------------------------
// VectAddrOut Error Message generator
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_VectAdErrorProt
  if (VectAddrError == 1'b1)
    $display("VICTB3:Time %t :Error in received VICVECTADDROUT", $time);
end // p_VectAdErrorProt

// -----------------------------------------------------------------------------
// VectAddrValid Error Message generator
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_VectAVldErrorProt
  if (VectAdVldError == 1'b1)
    $display("VICTB4:Time %t :Error in received VICVECTADDRV", $time);
end // p_VectAVldErrorProt

// -----------------------------------------------------------------------------
// VectAddrOut Error Message generator
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_VectAckErrorProt
 if (VectAckError == 1'b1)
   $display("VICTB5:Time %t :Error in received VICIRQACKOUT", $time);
end // p_VectAckErrorProt

endmodule

// --=============================== End =====================================--
