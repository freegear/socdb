// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcTrWaitCntl.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL092-REL1v1
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module routes the SMWAIT signal and asserts the CancelSMWAIT
//           signal when the SMWAIT signal gets timed-out.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcTrWaitCntl (
// Inputs
                      // AHB bus signals
                      HCLK,
                      HRESETn,
                      SMCActLowCS,
                      SMADDR,
                      SMCTrCS2WTR0,
                      SMCTrCEWTR0,
                      SMCTrCS2WTR1,
                      SMCTrCEWTR1,
                      SMCTrCS2WTR2,
                      SMCTrCEWTR2,
                      SMCTrCS2WTR3,
                      SMCTrCEWTR3,
                      SMCTrCS2WTR4,
                      SMCTrCEWTR4,
                      SMCTrCS2WTR5,
                      SMCTrCEWTR5,
                      SMCTrCS2WTR6,
                      SMCTrCEWTR6,
                      SMCTrCS2WTR7,
                      SMCTrCEWTR7,

// Outputs
                      SMWAIT,
                      CANCELSMWAIT
                     );

parameter Tclk = 10.56;        // HCLK Period
// Inputs

// AHB bus signals
input         HCLK;         // AHB Bus Clock
input         HRESETn;      // Bus Reset
input   [7:0] SMCActLowCS;  // Active low Memory Bank Select
input  [25:0] SMADDR;       // External Address Bus
input  [25:0] SMCTrCS2WTR0; // nCS-SMCTrnWAIT assertion delay for Bank 0
input  [23:0] SMCTrCEWTR0;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 0
input  [25:0] SMCTrCS2WTR1; // nCS-SMCTrnWAIT assertion delay for Bank 1
input  [23:0] SMCTrCEWTR1;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 1
input  [25:0] SMCTrCS2WTR2; // nCS-SMCTrnWAIT assertion delay for Bank 2
input  [23:0] SMCTrCEWTR2;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 2
input  [25:0] SMCTrCS2WTR3; // nCS-SMCTrnWAIT assertion delay for Bank 3
input  [23:0] SMCTrCEWTR3;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 3
input  [25:0] SMCTrCS2WTR4; // nCS-SMCTrnWAIT assertion delay for Bank 4
input  [23:0] SMCTrCEWTR4;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 4
input  [25:0] SMCTrCS2WTR5; // nCS-SMCTrnWAIT assertion delay for Bank 5
input  [23:0] SMCTrCEWTR5;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 5
input  [25:0] SMCTrCS2WTR6; // nCS-SMCTrnWAIT assertion delay for Bank 6
input  [23:0] SMCTrCEWTR6;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 6
input  [25:0] SMCTrCS2WTR7; // nCS-SMCTrnWAIT assertion delay for Bank 7
input  [23:0] SMCTrCEWTR7;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 7
// Outputs
output        SMWAIT;       // External Wait signal routed to the SMC
output        CANCELSMWAIT; // External Wait time out signal

// Inputs

// AHB bus signals
  wire        HCLK;         // AHB Bus Clock
  wire        HRESETn;      // Bus Reset
  wire  [7:0] SMCActLowCS;  // Active low Memory Bank Select
  wire [25:0] SMADDR;       // External Address Bus
  wire [25:0] SMCTrCS2WTR0; // nCS-SMCTrnWAIT assertion delay for Bank 0
  wire [23:0] SMCTrCEWTR0;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 0
  wire [25:0] SMCTrCS2WTR1; // nCS-SMCTrnWAIT assertion delay for Bank 1
  wire [23:0] SMCTrCEWTR1;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 1
  wire [25:0] SMCTrCS2WTR2; // nCS-SMCTrnWAIT assertion delay for Bank 2
  wire [23:0] SMCTrCEWTR2;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 2
  wire [25:0] SMCTrCS2WTR3; // nCS-SMCTrnWAIT assertion delay for Bank 3
  wire [23:0] SMCTrCEWTR3;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 3
  wire [25:0] SMCTrCS2WTR4; // nCS-SMCTrnWAIT assertion delay for Bank 4
  wire [23:0] SMCTrCEWTR4;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 4
  wire [25:0] SMCTrCS2WTR5; // nCS-SMCTrnWAIT assertion delay for Bank 5
  wire [23:0] SMCTrCEWTR5;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 5
  wire [25:0] SMCTrCS2WTR6; // nCS-SMCTrnWAIT assertion delay for Bank 6
  wire [23:0] SMCTrCEWTR6;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 6
  wire [25:0] SMCTrCS2WTR7; // nCS-SMCTrnWAIT assertion delay for Bank 7
  wire [23:0] SMCTrCEWTR7;  // Counter expiry-SMWAIT de-assertion
                            // delay for Bank 7

// Outputs
  wire        SMWAIT;       // External Wait signal routed to the SMC
  reg         CANCELSMWAIT; // External Wait time out signal


// -----------------------------------------------------------------------------
//
//                                SmcTrWaitCntl
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SMC Tricbox is an AHB slave. This block performs the following operations:
//   - Routes the SMWAIT signal according to the selected Memory Bank.
//   - Asserts the CancelSMWAIT signal when the SMWAIT signal gets timed out.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define IntTOUT  (32 * Tclk)
// External Wait time-out count

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [25:0] DelSMADDR;
// Delayed SMADDR

wire  [7:0] WaitEn;
// The Wait Enable of the Memory Banks

wire  [7:0] WaitPol;
// The Wait Polarity of the Memory Banks

wire [31:0] IntCS2WTR0;
// Memory Chip Select to SMCTrWAIT assertion delay time for Bank 0

wire [31:0] IntCEWTR0;
// SMCTrWAIT assertion to de-assertion delay time for Bank 0

wire [31:0] IntCS2WTR1;
// Memory Chip Select to SMCTrWAIT assertion delay time for Bank 1

wire [31:0] IntCEWTR1;
// SMCTrWAIT assertion to de-assertion delay time for Bank 1

wire [31:0] IntCS2WTR2;
// Memory Chip Select to SMCTrWAIT assertion delay time for Bank 2

wire [31:0] IntCEWTR2;
// SMCTrWAIT assertion to de-assertion delay time for Bank 2

wire [31:0] IntCS2WTR3;
// Memory Chip Select to SMCTrWAIT assertion delay time for Bank 3

wire [31:0] IntCEWTR3;
// SMCTrWAIT assertion to de-assertion delay time for Bank 3

wire [31:0] IntCS2WTR4;
// Memory Chip Select to SMCTrWAIT assertion delay time for Bank 4

wire [31:0] IntCEWTR4;
// SMCTrWAIT assertion to de-assertion delay time for Bank 4

wire [31:0] IntCS2WTR5;
// Memory Chip Select to SMCTrWAIT assertion delay time for Bank 5

wire [31:0] IntCEWTR5;
// SMCTrWAIT assertion to de-assertion delay time for Bank 5

wire [31:0] IntCS2WTR6;
// Memory Chip Select to SMCTrWAIT assertion delay time for Bank 6

wire [31:0] IntCEWTR6;
// SMCTrWAIT assertion to de-assertion delay time for Bank 6

wire [31:0] IntCS2WTR7;
// Memory Chip Select to SMCTrWAIT assertion delay time for Bank 7

wire [31:0] IntCEWTR7;
// SMCTrWAIT assertion to de-assertion delay time for Bank 7

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         nSMWAIT;
// Internal version of the SMWAIT (Active LOW)

reg         SelWaitPol;
// The Wait Polarity of the Selected Memory

reg         CancelAssrt;
// Indicates that the SMADDR is changed and it is stable

reg   [4:0] WaitCount;
// External Wait State Counter

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial
begin
  nSMWAIT    = 1'b1;
end

// -----------------------------------------------------------------------------
// SMCTrCS2WT Register field rename
// -----------------------------------------------------------------------------
assign WaitEn           = {SMCTrCS2WTR7[25], SMCTrCS2WTR6[25],
                           SMCTrCS2WTR5[25], SMCTrCS2WTR4[25],
                           SMCTrCS2WTR3[25], SMCTrCS2WTR2[25],
                           SMCTrCS2WTR1[25], SMCTrCS2WTR0[25]};

assign WaitPol          = {SMCTrCS2WTR7[24], SMCTrCS2WTR6[24],
                           SMCTrCS2WTR5[24], SMCTrCS2WTR4[24],
                           SMCTrCS2WTR3[24], SMCTrCS2WTR2[24],
                           SMCTrCS2WTR1[24], SMCTrCS2WTR0[24]};

// -----------------------------------------------------------------------------
// Converting std_logic_vector to time.
// -----------------------------------------------------------------------------
assign IntCEWTR0        = SMCTrCEWTR0 * Tclk;
assign IntCEWTR1        = SMCTrCEWTR1 * Tclk;
assign IntCEWTR2        = SMCTrCEWTR2 * Tclk;
assign IntCEWTR3        = SMCTrCEWTR3 * Tclk;
assign IntCEWTR4        = SMCTrCEWTR4 * Tclk;
assign IntCEWTR5        = SMCTrCEWTR5 * Tclk;
assign IntCEWTR6        = SMCTrCEWTR6 * Tclk;
assign IntCEWTR7        = SMCTrCEWTR7 * Tclk;
assign IntCS2WTR0       = SMCTrCS2WTR0[23:0] * Tclk;
assign IntCS2WTR1       = SMCTrCS2WTR1[23:0] * Tclk;
assign IntCS2WTR2       = SMCTrCS2WTR2[23:0] * Tclk;
assign IntCS2WTR3       = SMCTrCS2WTR3[23:0] * Tclk;
assign IntCS2WTR4       = SMCTrCS2WTR4[23:0] * Tclk;
assign IntCS2WTR5       = SMCTrCS2WTR5[23:0] * Tclk;
assign IntCS2WTR6       = SMCTrCS2WTR6[23:0] * Tclk;
assign IntCS2WTR7       = SMCTrCS2WTR7[23:0] * Tclk;

// -----------------------------------------------------------------------------
// Generation of Delayed SMADDR
// -----------------------------------------------------------------------------
assign # 3 DelSMADDR        = SMADDR;

// -----------------------------------------------------------------------------
// Choose the Wait Polarity of the selected Memory
// -----------------------------------------------------------------------------
always @(nSMWAIT or SMCActLowCS or WaitPol)
begin : p_WaitPolSelComb
  if (nSMWAIT == 1'b1)
    begin
      if (SMCActLowCS[0] == 1'b0)
        SelWaitPol = WaitPol[0];
      else if (SMCActLowCS[1] == 1'b0)
        SelWaitPol = WaitPol[1];
      else if (SMCActLowCS[2] == 1'b0)
        SelWaitPol = WaitPol[2];
      else if (SMCActLowCS[3] == 1'b0)
        SelWaitPol = WaitPol[3];
      else if (SMCActLowCS[4] == 1'b0)
        SelWaitPol = WaitPol[4];
      else if (SMCActLowCS[5] == 1'b0)
        SelWaitPol = WaitPol[5];
      else if (SMCActLowCS[6] == 1'b0)
        SelWaitPol = WaitPol[6];
      else if (SMCActLowCS[7] == 1'b0)
        SelWaitPol = WaitPol[7];
      else
        SelWaitPol = WaitPol[0];
    end
end // p_WaitPolSelComb

// -----------------------------------------------------------------------------
// Combinational logic for the Assertion and de-Assertion of the SMWAIT
// signal
// -----------------------------------------------------------------------------
always @(SMCActLowCS or DelSMADDR or negedge nSMWAIT or WaitEn)
begin : p_SMWAITComb
    if (nSMWAIT == 1'b1)
      begin
        if ((SMCActLowCS[0] == 1'b0) && (WaitEn[0] == 1'b1))
          begin
            if (IntCS2WTR0 < `IntTOUT)
              # (IntCS2WTR0 - 3) nSMWAIT <= 1'b0;
          end
        else if ((SMCActLowCS[1] == 1'b0) && (WaitEn[1] == 1'b1))
          begin
            if (IntCS2WTR1 < `IntTOUT)
              # (IntCS2WTR1 - 3) nSMWAIT <= 1'b0;
          end
        else if ((SMCActLowCS[2] == 1'b0) && (WaitEn[2] == 1'b1))
          begin
            if (IntCS2WTR2 < `IntTOUT)
              # (IntCS2WTR2 - 3) nSMWAIT <= 1'b0;
          end
        else if ((SMCActLowCS[3] == 1'b0) && (WaitEn[3] == 1'b1))
          begin
            if (IntCS2WTR3 < `IntTOUT)
              # (IntCS2WTR3 - 3) nSMWAIT <= 1'b0;
          end
        else if ((SMCActLowCS[4] == 1'b0) && (WaitEn[4] == 1'b1))
          begin
            if (IntCS2WTR4 < `IntTOUT)
              # (IntCS2WTR4 - 3) nSMWAIT <= 1'b0;
          end
        else if ((SMCActLowCS[5] == 1'b0) && (WaitEn[5] == 1'b1))
          begin
            if (IntCS2WTR5 < `IntTOUT)
              # (IntCS2WTR5 - 3) nSMWAIT <= 1'b0;
          end
        else if ((SMCActLowCS[6] == 1'b0) && (WaitEn[6] == 1'b1))
          begin
            if (IntCS2WTR6 < `IntTOUT)
              # (IntCS2WTR6 - 3) nSMWAIT <= 1'b0;
          end
        else if ((SMCActLowCS[7] == 1'b0) && (WaitEn[7] == 1'b1))
          begin
            if (IntCS2WTR7 < `IntTOUT)
              # (IntCS2WTR7 - 3) nSMWAIT <= 1'b0;
          end
        else
          nSMWAIT <= 1'b1;
      end
    else if (nSMWAIT == 1'b0)
      begin
        if ((SMCActLowCS[0] == 1'b0) && (WaitEn[0] == 1'b1))
          # (IntCEWTR0 - 3) nSMWAIT = 1'b1;
        else if ((SMCActLowCS[1] == 1'b0) && (WaitEn[1] == 1'b1))
          # (IntCEWTR1 - 3) nSMWAIT = 1'b1;
        else if ((SMCActLowCS[2] == 1'b0) && (WaitEn[2] == 1'b1))
          # (IntCEWTR2 - 3) nSMWAIT = 1'b1;
        else if ((SMCActLowCS[3] == 1'b0) && (WaitEn[3] == 1'b1))
          # (IntCEWTR3 - 3) nSMWAIT = 1'b1;
        else if ((SMCActLowCS[4] == 1'b0) && (WaitEn[4] == 1'b1))
          # (IntCEWTR4 - 3) nSMWAIT = 1'b1;
        else if ((SMCActLowCS[5] == 1'b0) && (WaitEn[5] == 1'b1))
          # (IntCEWTR5 - 3) nSMWAIT = 1'b1;
        else if ((SMCActLowCS[6] == 1'b0) && (WaitEn[6] == 1'b1))
          # (IntCEWTR6 - 3) nSMWAIT = 1'b1;
        else if ((SMCActLowCS[7] == 1'b0) && (WaitEn[7] == 1'b1))
          # (IntCEWTR7 - 3) nSMWAIT = 1'b1;
        else if (CancelAssrt == 1'b0)
          nSMWAIT = 1'b1;
      end
end // p_SMWAITComb

// -----------------------------------------------------------------------------
// Process to count for the External WAIT time-out
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ExtWAITCntComb
  if (HRESETn == 1'b0)
    WaitCount <= 5'b00000;
  else
    begin
      if (nSMWAIT == 1'b0)
        begin
          if (WaitCount <= `IntTOUT)
              WaitCount <= WaitCount + 1;
        end
      else
        WaitCount <= 5'b00000;
    end
end // p_ExtWAITCntComb

// -----------------------------------------------------------------------------
// Process to signal CANCELSMWAIT assertion and nSMWAIT de assertion
// -----------------------------------------------------------------------------
always @(posedge CANCELSMWAIT or posedge nSMWAIT)
begin
  if (CANCELSMWAIT == 1'b1)
    CancelAssrt <= 1'b1;
  else
    CancelAssrt <= 1'b0;
end

// -----------------------------------------------------------------------------
// Process to generate CancelSMWAIT
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_CanSMWAITComb
  if (HRESETn == 1'b0)
    CANCELSMWAIT <= 1'b0;
  else
    begin
      if (WaitCount == 5'b11111)
        CANCELSMWAIT <= 1'b1;
      else
        CANCELSMWAIT <= 1'b0;
    end
end // p_CanSMWAITComb

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
assign SMWAIT           = nSMWAIT ^ SelWaitPol;

endmodule
// --================================= End ===================================--
