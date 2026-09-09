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
// File Name              : VicTrIntReqLog.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module generates the FIQStatus and IRQStatus.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicTrIntReqLog (
// Inputs
                    HCLK,
                    HRESETn,
                    VicTrIntSource,
                    VicTrSoftInt,
                    VicTrIntEn,
                    VicTrIntSelect,
                    nVicTrIrqIn, 

// Outputs
                    VicTrFiqStatus,
                    VicTrIrqStatus,
                    TrIrqStatus,
                    TrnIrq,
                    TrFiqStatus,
                    VicTrRawIntr
                    );

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input  [31:0] VicTrIntSource;   // IntSource 
input  [31:0] VicTrSoftInt;     // SoftInt 
input  [31:0] VicTrIntEn;       // IntEnable 
input  [31:0] VicTrIntSelect;   // IntSelect 
input         nVicTrIrqIn;      // Daisy Chain Input

// Outputs
output [31:0] VicTrFiqStatus;   // FIQStatus output signal 
output [31:0] VicTrIrqStatus;   // IRQStatus output signal 
output [31:0] VicTrRawIntr;     // Raw Interrupts
output [31:0] TrIrqStatus;      // IRQStatus output 
output [31:0] TrFiqStatus;      // IRQStatus output 
output        TrnIrq;           // Irq Interrupt
      
// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire   [31:0] VicTrIntSource;   // IntSource 
wire   [31:0] VicTrSoftInt;     // SoftInt 
wire   [31:0] VicTrIntEn;       // IntEnable 
wire          nVicTrIrqIn;      // Daisy Chain Input

// Outputs
wire   [31:0] VicTrFiqStatus;   // FIQStatus output 
wire   [31:0] VicTrIrqStatus;   // IRQStatus output 
wire   [31:0] VicTrRawIntr;     // Raw Interrupts
wire   [31:0] TrIrqStatus;      // IRQStatus output 
wire   [31:0] TrFiqStatus;      // FIQStatus output 
wire          TrnIrq;           // Irq Interrupt

// -----------------------------------------------------------------------------
//
//                             VicTrIntReqLog
//                             ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//    This block receives Interrupt requests and Software Interrupts
// from the AHB Interface/Register sub-block (VicTrAhbif) and combines
// them to generate the Raw Status. The Raw Status is then qualified
// with the IntEnable and IntSelect vectors to create the FIQ and
// IRQ Status signals.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [31:0] EnInterrupt;
// Status of Interrupt requests after masking

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
// FIQ and IRQ status generation
// -----------------------------------------------------------------------------
assign VicTrRawIntr    = HRESETn == 1'b0 ? 32'h00000000 : 
                           VicTrIntSource | VicTrSoftInt;
assign EnInterrupt     = HRESETn == 1'b0 ? 32'h00000000 :
                           VicTrRawIntr & VicTrIntEn;
assign VicTrFiqStatus  = HRESETn == 1'b0 ? 32'h00000000 : 
                           EnInterrupt & VicTrIntSelect;
assign TrFiqStatus     = HRESETn == 1'b0 ? 32'h00000000 : 
                           EnInterrupt & VicTrIntSelect;
assign VicTrIrqStatus  = HRESETn == 1'b0 ? 32'h00000000 : 
                           EnInterrupt & ~(VicTrIntSelect);
assign TrIrqStatus     = HRESETn == 1'b0 ? 32'h00000000 : 
                           EnInterrupt & ~(VicTrIntSelect);

assign TrnIrq          = (|(HRESETn == 1'b0 ? 32'h00000000 : 
                           EnInterrupt & ~(VicTrIntSelect))) | 
                                                        ~nVicTrIrqIn;
endmodule

// --=============================== End =====================================--
