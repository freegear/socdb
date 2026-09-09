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
// File Name              : VicTrIntReq.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL190-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           This module generates the FIQStatus and IRQStatus.
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module VicTrIntReq (
// Inputs
                    HCLK,
                    HRESETn,
                    VICTrIntSource,
                    VICTrSoftInt,
                    VICTrIntEnable,
                    VICTrIntSelect,
// Outputs
                    VICTrFIQStatus,
                    VICTrIRQStatus,
                    VICTrIRQStatSync
                    );

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input  [31:0] VICTrIntSource;   // IntSource for the Mirrored VIC model
input  [31:0] VICTrSoftInt;     // SoftInt for the Mirrored VIC model
input  [31:0] VICTrIntEnable;   // IntEnable for the Mirrored VIC
input  [31:0] VICTrIntSelect;   // IntSelect for the Mirrored VIC model

// Outputs
output [31:0] VICTrFIQStatus;   // FIQStatus output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrIRQStatus;   // IRQStatus output signal to the
                                // VicTrVectBank sub-block
output [31:0] VICTrIRQStatSync; // Double synchronised IRQ Status

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire   [31:0] VICTrIntSource;   // IntSource for the Mirrored VIC model
wire   [31:0] VICTrSoftInt;     // SoftInt for the Mirrored VIC model
wire   [31:0] VICTrIntEnable;   // IntEnable for the Mirrored VIC
wire   [31:0] TrIntSelect;      // IntSelect for the Mirrored VIC model

// Outputs
wire   [31:0] VICTrFIQStatus;   // FIQStatus output signal to the
                                // VicTrVectBank sub-block
wire   [31:0] VICTrIRQStatus;   // IRQStatus output signal to the
                                // VicTrVectBank sub-block
reg    [31:0] VICTrIRQStatSync; // Double synchronised IRQ Status

// ---------------------------------------------------------------------
//
//                             VicTrIntReq
//                             ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//    This block recieves Interrupt requests and Software Interrupts
// from the AHB Interface/Register sub-block (VicTrAhbif) and combines
// them to generate the Raw Status. The Raw Status is then qualified
// with the IntEnable and IntSelect vectors to create the FIQ and
// IRQ Status signals.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire [31:0] TrRawInterrupt;
// Status of Interrupt requests before masking

wire [31:0] EnInterrupt;
// Status of Interrupt requests after masking

reg  [31:0] VICIRQStatSync1;
// Synchronised version of IRQStatus

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
// FIQ and IRQ status generation
// ---------------------------------------------------------------------
assign TrRawInterrupt   = VICTrIntSource | VICTrSoftInt;
assign EnInterrupt      = TrRawInterrupt & VICTrIntEnable;
assign VICTrFIQStatus   = EnInterrupt & VICTrIntSelect;
assign VICTrIRQStatus   = EnInterrupt & ~(VICTrIntSelect);

always@(posedge HCLK or negedge HRESETn)
begin : p_SyncSeq
  if (HRESETn == 1'b0)
    begin
      VICIRQStatSync1  <= 32'h00000000;
      VICTrIRQStatSync <= 32'h00000000;
    end
  else
    begin
      VICIRQStatSync1  <= VICTrIRQStatus;
      VICTrIRQStatSync <= VICIRQStatSync1;
    end
end //p_SyncSeq

endmodule

// --============================== End ==============================--
