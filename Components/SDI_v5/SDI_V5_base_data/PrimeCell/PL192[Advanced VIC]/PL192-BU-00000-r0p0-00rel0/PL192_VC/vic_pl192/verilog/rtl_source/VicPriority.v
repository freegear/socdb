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
// File Name              : VicPriority.v.rca
// File Revision          : 1.15
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block resolves the priority of the interrupt
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicPriority (
// Inputs
                    IRQStatusIn,
                    DaisyChainIn,
                    SyncIRQStatusIn,
                    SyncDaisyChainIn,
                    SWPriorityMask,
                    CurrentLevelMask,
                    PLevel0,
                    PLevel1,
                    PLevel2,
                    PLevel3,
                    PLevel4,
                    PLevel5,
                    PLevel6,
                    PLevel7,
                    PLevel8,
                    PLevel9,
                    PLevel10,
                    PLevel11,
                    PLevel12,
                    PLevel13,
                    PLevel14,
                    PLevel15,
                    PLevel16,
                    PLevel17,
                    PLevel18,
                    PLevel19,
                    PLevel20,
                    PLevel21,
                    PLevel22,
                    PLevel23,
                    PLevel24,
                    PLevel25,
                    PLevel26,
                    PLevel27,
                    PLevel28,
                    PLevel29,
                    PLevel30,
                    PLevel31,
                    PLevel32,
                    PriorityLevelCfg,

// Outputs
                    IrqOutput,
                    SyncIrqOutput,
                    IRQPort
                   );

// Inputs

input [31:0] IRQStatusIn;         // IRQ status input
input        DaisyChainIn;        // Daisy chain input
input [31:0] SyncIRQStatusIn;     // Synchronized IRQ status input
input        SyncDaisyChainIn;    // Synchronized daisy chain input
input        SWPriorityMask;      // Mask for this level
input        CurrentLevelMask;    // Mask generated from current IRQ PLevel
input  [3:0] PLevel0;             // Priority Level for 0th interrupt source
input  [3:0] PLevel1;             // Priority Level for 1st interrupt source
input  [3:0] PLevel2;             // Priority Level for 2nd interrupt source
input  [3:0] PLevel3;             // Priority Level for 3rd interrupt source
input  [3:0] PLevel4;             // Priority Level for 4th interrupt source
input  [3:0] PLevel5;             // Priority Level for 5th interrupt source
input  [3:0] PLevel6;             // Priority Level for 6th interrupt source
input  [3:0] PLevel7;             // Priority Level for 7th interrupt source
input  [3:0] PLevel8;             // Priority Level for 8th interrupt source
input  [3:0] PLevel9;             // Priority Level for 9th interrupt source
input  [3:0] PLevel10;            // Priority Level for 10th interrupt source
input  [3:0] PLevel11;            // Priority Level for 11th interrupt source
input  [3:0] PLevel12;            // Priority Level for 12th interrupt source
input  [3:0] PLevel13;            // Priority Level for 13th interrupt source
input  [3:0] PLevel14;            // Priority Level for 14th interrupt source
input  [3:0] PLevel15;            // Priority Level for 15th interrupt source
input  [3:0] PLevel16;            // Priority Level for 16th interrupt source
input  [3:0] PLevel17;            // Priority Level for 17th interrupt source
input  [3:0] PLevel18;            // Priority Level for 18th interrupt source
input  [3:0] PLevel19;            // Priority Level for 19th interrupt source
input  [3:0] PLevel20;            // Priority Level for 20th interrupt source
input  [3:0] PLevel21;            // Priority Level for 21st interrupt source
input  [3:0] PLevel22;            // Priority Level for 22nd interrupt source
input  [3:0] PLevel23;            // Priority Level for 23rd interrupt source
input  [3:0] PLevel24;            // Priority Level for 24th interrupt source
input  [3:0] PLevel25;            // Priority Level for 25th interrupt source
input  [3:0] PLevel26;            // Priority Level for 26th interrupt source
input  [3:0] PLevel27;            // Priority Level for 27th interrupt source
input  [3:0] PLevel28;            // Priority Level for 28th interrupt source
input  [3:0] PLevel29;            // Priority Level for 29th interrupt source
input  [3:0] PLevel30;            // Priority Level for 30th interrupt source
input  [3:0] PLevel31;            // Priority Level for 31st interrupt source
input  [3:0] PLevel32;            // Priority Level for 32nd interrupt source
input  [3:0] PriorityLevelCfg;    // Priority Level of this decoder

// Outputs
output       IrqOutput;           // asynchronous IRQ output
output       SyncIrqOutput;       // synchronous IRQ output
output [5:0] IRQPort;             // Binary code indicating which interrupt
                                  // source is used. 0-31=IRQ status in,
                                  // 32=Daisy Chain

// Inputs
wire  [31:0] IRQStatusIn;         // IRQ status input
wire         DaisyChainIn;        // Daisy chain input
wire  [31:0] SyncIRQStatusIn;     // Synchronized IRQ status input
wire         SyncDaisyChainIn;    // Synchronized daisy chain input
wire         SWPriorityMask;      // Mask for this level
wire         CurrentLevelMask;    // Mask generated from current IRQ level
wire   [3:0] PLevel0;             // Priority Level for 0th interrupt source
wire   [3:0] PLevel1;             // Priority Level for 1st interrupt source
wire   [3:0] PLevel2;             // Priority Level for 2nd interrupt source
wire   [3:0] PLevel3;             // Priority Level for 3rd interrupt source
wire   [3:0] PLevel4;             // Priority Level for 4th interrupt source
wire   [3:0] PLevel5;             // Priority Level for 5th interrupt source
wire   [3:0] PLevel6;             // Priority Level for 6th interrupt source
wire   [3:0] PLevel7;             // Priority Level for 7th interrupt source
wire   [3:0] PLevel8;             // Priority Level for 8th interrupt source
wire   [3:0] PLevel9;             // Priority Level for 9th interrupt source
wire   [3:0] PLevel10;            // Priority Level for 10th interrupt source
wire   [3:0] PLevel11;            // Priority Level for 11th interrupt source
wire   [3:0] PLevel12;            // Priority Level for 12th interrupt source
wire   [3:0] PLevel13;            // Priority Level for 13th interrupt source
wire   [3:0] PLevel14;            // Priority Level for 14th interrupt source
wire   [3:0] PLevel15;            // Priority Level for 15th interrupt source
wire   [3:0] PLevel16;            // Priority Level for 16th interrupt source
wire   [3:0] PLevel17;            // Priority Level for 17th interrupt source
wire   [3:0] PLevel18;            // Priority Level for 18th interrupt source
wire   [3:0] PLevel19;            // Priority Level for 19th interrupt source
wire   [3:0] PLevel20;            // Priority Level for 20th interrupt source
wire   [3:0] PLevel21;            // Priority Level for 21st interrupt source
wire   [3:0] PLevel22;            // Priority Level for 22nd interrupt source
wire   [3:0] PLevel23;            // Priority Level for 23rd interrupt source
wire   [3:0] PLevel24;            // Priority Level for 24th interrupt source
wire   [3:0] PLevel25;            // Priority Level for 25th interrupt source
wire   [3:0] PLevel26;            // Priority Level for 26th interrupt source
wire   [3:0] PLevel27;            // Priority Level for 27th interrupt source
wire   [3:0] PLevel28;            // Priority Level for 28th interrupt source
wire   [3:0] PLevel29;            // Priority Level for 29th interrupt source
wire   [3:0] PLevel30;            // Priority Level for 30th interrupt source
wire   [3:0] PLevel31;            // Priority Level for 31st interrupt source
wire   [3:0] PLevel32;            // Priority Level for 32nd interrupt source
wire   [3:0] PriorityLevelCfg;    // Priority Level of this decoder
// Outputs
reg          IrqOutput;           // Asynchronous IRQ output
reg          SyncIrqOutput;       // Synchronous IRQ output
reg    [5:0] IRQPort;             // Binary code indicating which interrupt
                                  // Source is used. 0-31=IRQ status in,
                                  // 32=Daisy Chain

// -----------------------------------------------------------------------------
//
//                              VicPriority
//                              ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// - This block resolves the interrupts which are of the same priority level.
// When there are more than one interrupt of the same priority asserted then,
// hardware priority is used to resolve the interrupt. Source0 has the highest
// priority and source32 has the lowest priority. Daisy chain has the lowest
// priority.
//
// - This block also returns the asynchronised, synchronised interrupts and
// port information which are used to generate the nVICIRQ and VICADDRESS.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [32:0] LevelMatchedIrq;     // Each bit corresponding to the enabled
                                  // asynchronous IRQ of this priority
wire  [32:0] SyncLvMatchedIrq;    // Each bit corresponding to the enabled
                                  // synchronous IRQ of this priority

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

//Include Parameters File
`include "VicParams.v"

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// synopsys translate_off
// -----------------------------------------------------------------------------
// Type declarations
// -----------------------------------------------------------------------------

// synopsys translate_on
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// Check if asynchronous IRQ input match the PLevel level of this decoder.
// If yes, set the corresponding bit in the LevelMatchedIrq
// -----------------------------------------------------------------------------
assign LevelMatchedIrq[0] = ((PLevel0 == PriorityLevelCfg) ?
                              IRQStatusIn[0] : 1'b0);
assign LevelMatchedIrq[1] = ((PLevel1 == PriorityLevelCfg) ?
                              IRQStatusIn[1] : 1'b0);
assign LevelMatchedIrq[2] = ((PLevel2 == PriorityLevelCfg) ?
                              IRQStatusIn[2] : 1'b0);
assign LevelMatchedIrq[3] = ((PLevel3 == PriorityLevelCfg) ?
                              IRQStatusIn[3] : 1'b0);
assign LevelMatchedIrq[4] = ((PLevel4 == PriorityLevelCfg) ?
                              IRQStatusIn[4] : 1'b0);
assign LevelMatchedIrq[5] = ((PLevel5 == PriorityLevelCfg) ?
                              IRQStatusIn[5] : 1'b0);
assign LevelMatchedIrq[6] = ((PLevel6 == PriorityLevelCfg) ?
                              IRQStatusIn[6] : 1'b0);
assign LevelMatchedIrq[7] = ((PLevel7 == PriorityLevelCfg) ?
                              IRQStatusIn[7] : 1'b0);
assign LevelMatchedIrq[8] = ((PLevel8 == PriorityLevelCfg) ?
                              IRQStatusIn[8] : 1'b0);
assign LevelMatchedIrq[9] = ((PLevel9 == PriorityLevelCfg) ?
                              IRQStatusIn[9] : 1'b0);
assign LevelMatchedIrq[10] = ((PLevel10 == PriorityLevelCfg) ?
                               IRQStatusIn[10] : 1'b0);
assign LevelMatchedIrq[11] = ((PLevel11 == PriorityLevelCfg) ?
                               IRQStatusIn[11] : 1'b0);
assign LevelMatchedIrq[12] = ((PLevel12 == PriorityLevelCfg) ?
                               IRQStatusIn[12] : 1'b0);
assign LevelMatchedIrq[13] = ((PLevel13 == PriorityLevelCfg) ?
                               IRQStatusIn[13] : 1'b0);
assign LevelMatchedIrq[14] = ((PLevel14 == PriorityLevelCfg) ?
                               IRQStatusIn[14] : 1'b0);
assign LevelMatchedIrq[15] = ((PLevel15 == PriorityLevelCfg) ?
                               IRQStatusIn[15] : 1'b0);
assign LevelMatchedIrq[16] = ((PLevel16 == PriorityLevelCfg) ?
                               IRQStatusIn[16] : 1'b0);
assign LevelMatchedIrq[17] = ((PLevel17 == PriorityLevelCfg) ?
                               IRQStatusIn[17] : 1'b0);
assign LevelMatchedIrq[18] = ((PLevel18 == PriorityLevelCfg) ?
                               IRQStatusIn[18] : 1'b0);
assign LevelMatchedIrq[19] = ((PLevel19 == PriorityLevelCfg) ?
                               IRQStatusIn[19] : 1'b0);
assign LevelMatchedIrq[20] = ((PLevel20 == PriorityLevelCfg) ?
                               IRQStatusIn[20] : 1'b0);
assign LevelMatchedIrq[21] = ((PLevel21 == PriorityLevelCfg) ?
                               IRQStatusIn[21] : 1'b0);
assign LevelMatchedIrq[22] = ((PLevel22 == PriorityLevelCfg) ?
                               IRQStatusIn[22] : 1'b0);
assign LevelMatchedIrq[23] = ((PLevel23 == PriorityLevelCfg) ?
                               IRQStatusIn[23] : 1'b0);
assign LevelMatchedIrq[24] = ((PLevel24 == PriorityLevelCfg) ?
                               IRQStatusIn[24] : 1'b0);
assign LevelMatchedIrq[25] = ((PLevel25 == PriorityLevelCfg) ?
                               IRQStatusIn[25] : 1'b0);
assign LevelMatchedIrq[26] = ((PLevel26 == PriorityLevelCfg) ?
                               IRQStatusIn[26] : 1'b0);
assign LevelMatchedIrq[27] = ((PLevel27 == PriorityLevelCfg) ?
                               IRQStatusIn[27] : 1'b0);
assign LevelMatchedIrq[28] = ((PLevel28 == PriorityLevelCfg) ?
                               IRQStatusIn[28] : 1'b0);
assign LevelMatchedIrq[29] = ((PLevel29 == PriorityLevelCfg) ?
                               IRQStatusIn[29] : 1'b0);
assign LevelMatchedIrq[30] = ((PLevel30 == PriorityLevelCfg) ?
                               IRQStatusIn[30] : 1'b0);
assign LevelMatchedIrq[31] = ((PLevel31 == PriorityLevelCfg) ?
                               IRQStatusIn[31] : 1'b0);
assign LevelMatchedIrq[32] = ((PLevel32 == PriorityLevelCfg) ?
                               DaisyChainIn  : 1'b0);

// -----------------------------------------------------------------------------
// Check if synchronous IRQ input match the PLevel level of this decoder.
// If yes, set the corresponding bit in the SyncLvMatchedIrq
// -----------------------------------------------------------------------------
assign SyncLvMatchedIrq[0] = ((PLevel0 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[0] : 1'b0);
assign SyncLvMatchedIrq[1] = ((PLevel1 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[1] : 1'b0);
assign SyncLvMatchedIrq[2] = ((PLevel2 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[2] : 1'b0);
assign SyncLvMatchedIrq[3] = ((PLevel3 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[3] : 1'b0);
assign SyncLvMatchedIrq[4] = ((PLevel4 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[4] : 1'b0);
assign SyncLvMatchedIrq[5] = ((PLevel5 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[5] : 1'b0);
assign SyncLvMatchedIrq[6] = ((PLevel6 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[6] : 1'b0);
assign SyncLvMatchedIrq[7] = ((PLevel7 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[7] : 1'b0);
assign SyncLvMatchedIrq[8] = ((PLevel8 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[8] : 1'b0);
assign SyncLvMatchedIrq[9] = ((PLevel9 == PriorityLevelCfg) ?
                               SyncIRQStatusIn[9] : 1'b0);
assign SyncLvMatchedIrq[10] = ((PLevel10 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[10] : 1'b0);
assign SyncLvMatchedIrq[11] = ((PLevel11 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[11] : 1'b0);
assign SyncLvMatchedIrq[12] = ((PLevel12 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[12] : 1'b0);
assign SyncLvMatchedIrq[13] = ((PLevel13 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[13] : 1'b0);
assign SyncLvMatchedIrq[14] = ((PLevel14 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[14] : 1'b0);
assign SyncLvMatchedIrq[15] = ((PLevel15 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[15] : 1'b0);
assign SyncLvMatchedIrq[16] = ((PLevel16 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[16] : 1'b0);
assign SyncLvMatchedIrq[17] = ((PLevel17 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[17] : 1'b0);
assign SyncLvMatchedIrq[18] = ((PLevel18 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[18] : 1'b0);
assign SyncLvMatchedIrq[19] = ((PLevel19 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[19] : 1'b0);
assign SyncLvMatchedIrq[20] = ((PLevel20 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[20] : 1'b0);
assign SyncLvMatchedIrq[21] = ((PLevel21 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[21] : 1'b0);
assign SyncLvMatchedIrq[22] = ((PLevel22 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[22] : 1'b0);
assign SyncLvMatchedIrq[23] = ((PLevel23 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[23] : 1'b0);
assign SyncLvMatchedIrq[24] = ((PLevel24 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[24] : 1'b0);
assign SyncLvMatchedIrq[25] = ((PLevel25 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[25] : 1'b0);
assign SyncLvMatchedIrq[26] = ((PLevel26 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[26] : 1'b0);
assign SyncLvMatchedIrq[27] = ((PLevel27 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[27] : 1'b0);
assign SyncLvMatchedIrq[28] = ((PLevel28 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[28] : 1'b0);
assign SyncLvMatchedIrq[29] = ((PLevel29 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[29] : 1'b0);
assign SyncLvMatchedIrq[30] = ((PLevel30 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[30] : 1'b0);
assign SyncLvMatchedIrq[31] = ((PLevel31 == PriorityLevelCfg) ?
                                SyncIRQStatusIn[31] : 1'b0);
assign SyncLvMatchedIrq[32] = ((PLevel32 == PriorityLevelCfg) ?
                                SyncDaisyChainIn  : 1'b0);

// -----------------------------------------------------------------------------
// nIRQ output.
// If any enabled interrupt is asserted then assert the IrqOutput.
// -----------------------------------------------------------------------------
always @(LevelMatchedIrq or SWPriorityMask or CurrentLevelMask)
begin : p_IrqOutComb
  if (((LevelMatchedIrq != `ZERO33) && SWPriorityMask) && CurrentLevelMask)
    begin
      IrqOutput = 1'b1;
    end
  else
    begin
      IrqOutput = 1'b0;
    end
end // p_IrqOutComb

// -----------------------------------------------------------------------------
// nIRQ synchronised output.
// If any enabled interrupt is asserted then assert the SyncIrqOutput.
// -----------------------------------------------------------------------------
always @(SyncLvMatchedIrq or SWPriorityMask or CurrentLevelMask)
begin : p_SyncIrqOutComb
  if (((SyncLvMatchedIrq != `ZERO33)  && SWPriorityMask) && CurrentLevelMask)
    begin
      SyncIrqOutput  = 1'b1;
    end
  else
    begin
      SyncIrqOutput  = 1'b0;
    end
end // p_SyncIrqOutComb

// -----------------------------------------------------------------------------
// PLevel tree
// If more than one enabled interrupt is asserted then the highest interrupt
// will be selected and source of the interrupt is stored in the IRQPort.
// -----------------------------------------------------------------------------
always @(SyncLvMatchedIrq or SWPriorityMask or CurrentLevelMask)
begin : p_DecodeTreeComb
  if ((SWPriorityMask == 1'b0) || (CurrentLevelMask == 1'b0))
    begin
      IRQPort = {6{1'b0}};
    end
  else if (SyncLvMatchedIrq[0])
    begin
      IRQPort = 6'b000000;
    end
  else if (SyncLvMatchedIrq[1])
    begin
      IRQPort = 6'b000001;
    end
  else if (SyncLvMatchedIrq[2])
    begin
      IRQPort = 6'b000010;
    end
  else if (SyncLvMatchedIrq[3])
    begin
      IRQPort = 6'b000011;
    end
  else if (SyncLvMatchedIrq[4])
    begin
      IRQPort = 6'b000100;
    end
  else if (SyncLvMatchedIrq[5])
    begin
      IRQPort = 6'b000101;
    end
  else if (SyncLvMatchedIrq[6])
    begin
      IRQPort = 6'b000110;
    end
  else if (SyncLvMatchedIrq[7])
    begin
      IRQPort = 6'b000111;
    end
  else if (SyncLvMatchedIrq[8])
    begin
      IRQPort = 6'b001000;
    end
  else if (SyncLvMatchedIrq[9])
    begin
      IRQPort = 6'b001001;
    end
  else if (SyncLvMatchedIrq[10])
    begin
      IRQPort = 6'b001010;
    end
  else if (SyncLvMatchedIrq[11])
    begin
      IRQPort = 6'b001011;
    end
  else if (SyncLvMatchedIrq[12])
    begin
      IRQPort = 6'b001100;
    end
  else if (SyncLvMatchedIrq[13])
    begin
      IRQPort = 6'b001101;
    end
  else if (SyncLvMatchedIrq[14])
    begin
      IRQPort = 6'b001110;
    end
  else if (SyncLvMatchedIrq[15])
    begin
      IRQPort = 6'b001111;
    end
  else if (SyncLvMatchedIrq[16])
    begin
      IRQPort = 6'b010000;
    end
  else if (SyncLvMatchedIrq[17])
    begin
      IRQPort = 6'b010001;
    end
  else if (SyncLvMatchedIrq[18])
    begin
      IRQPort = 6'b010010;
    end
  else if (SyncLvMatchedIrq[19])
    begin
      IRQPort = 6'b010011;
    end
  else if (SyncLvMatchedIrq[20])
    begin
      IRQPort = 6'b010100;
    end
  else if (SyncLvMatchedIrq[21])
    begin
      IRQPort = 6'b010101;
    end
  else if (SyncLvMatchedIrq[22])
    begin
      IRQPort = 6'b010110;
    end
  else if (SyncLvMatchedIrq[23])
    begin
      IRQPort = 6'b010111;
    end
  else if (SyncLvMatchedIrq[24])
    begin
      IRQPort = 6'b011000;
    end
  else if (SyncLvMatchedIrq[25])
    begin
      IRQPort = 6'b011001;
    end
  else if (SyncLvMatchedIrq[26])
    begin
      IRQPort = 6'b011010;
    end
  else if (SyncLvMatchedIrq[27])
    begin
      IRQPort = 6'b011011;
    end
  else if (SyncLvMatchedIrq[28])
    begin
      IRQPort = 6'b011100;
    end
  else if (SyncLvMatchedIrq[29])
    begin
      IRQPort = 6'b011101;
    end
  else if (SyncLvMatchedIrq[30])
    begin
      IRQPort = 6'b011110;
    end
  else if (SyncLvMatchedIrq[31])
    begin
      IRQPort = 6'b011111;
    end
  else if (SyncLvMatchedIrq[32])
    begin
      IRQPort = 6'b100000;
    end
  else
    begin
      IRQPort = 6'b000000;
    end
end // p_DecodeTreeComb

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================= End ===================================--
