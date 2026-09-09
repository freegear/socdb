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
// File Name              : VicTrIrqIntrLog.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           VIC IRQ Interrupt Logic Block
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicTrIrqIntrLog (
// Inputs
                 HCLK,
                 HRESETn,
                 nVicTrIrqIn,
                 VicTrIrqInReg,
                 IrqStatus,
                 VectAddrVld,
                 nVicTrSyncEn,
                 VicTrSwPriMask,
                 VicTrVectPriDsy,  
                 VicTrVectPrity0,
                 VicTrVectPrity1,
                 VicTrVectPrity2,
                 VicTrVectPrity3,
                 VicTrVectPrity4,
                 VicTrVectPrity5,
                 VicTrVectPrity6,
                 VicTrVectPrity7,
                 VicTrVectPrity8,
                 VicTrVectPrity9,
                 VicTrVectPrity10,
                 VicTrVectPrity11,
                 VicTrVectPrity12,
                 VicTrVectPrity13,
                 VicTrVectPrity14,
                 VicTrVectPrity15,
                 VicTrVectPrity16,
                 VicTrVectPrity17,
                 VicTrVectPrity18,
                 VicTrVectPrity19,
                 VicTrVectPrity20,
                 VicTrVectPrity21,
                 VicTrVectPrity22,
                 VicTrVectPrity23,
                 VicTrVectPrity24,
                 VicTrVectPrity25,
                 VicTrVectPrity26,
                 VicTrVectPrity27,
                 VicTrVectPrity28,
                 VicTrVectPrity29,
                 VicTrVectPrity30,
                 VicTrVectPrity31,
                 MaskPrityReg,
                 nTrIrq,

// Outputs
                 TrVectIrq,
                 DaisyIrqOut, 
                 PPTable0,
                 PPTable1,
                 PPTable2,
                 PPTable3,
                 PPTable4,
                 PPTable5,
                 PPTable6,
                 PPTable7,
                 PPTable8,
                 PPTable9,
                 PPTable10,
                 PPTable11,
                 PPTable12,
                 PPTable13,
                 PPTable14,
                 PPTable15
                );

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input         nVicTrIrqIn;      // Irq Interrupt from daisy chain
input         VicTrIrqInReg;    // Enable bit to latch Irq Interrupt
                                // from Daisy chain
input         VectAddrVld;      // Address Valid Indicator 
input         nVicTrSyncEn;     // Sync Enable Input 
input  [31:0] IrqStatus;        // IRQ Status from Interrupt request Logic Block
input  [15:0] VicTrSwPriMask;   // Software priority mask register
input   [3:0] VicTrVectPriDsy;  // Vector priority register 
                                // for Daisy chain port
input   [3:0] VicTrVectPrity0;  // Vector priority register 0
input   [3:0] VicTrVectPrity1;  // Vector priority register 1
input   [3:0] VicTrVectPrity2;  // Vector priority register 2
input   [3:0] VicTrVectPrity3;  // Vector priority register 3
input   [3:0] VicTrVectPrity4;  // Vector priority register 4
input   [3:0] VicTrVectPrity5;  // Vector priority register 5
input   [3:0] VicTrVectPrity6;  // Vector priority register 6
input   [3:0] VicTrVectPrity7;  // Vector priority register 7
input   [3:0] VicTrVectPrity8;  // Vector priority register 8
input   [3:0] VicTrVectPrity9;  // Vector priority register 9
input   [3:0] VicTrVectPrity10; // Vector priority register 10
input   [3:0] VicTrVectPrity11; // Vector priority register 11
input   [3:0] VicTrVectPrity12; // Vector priority register 12
input   [3:0] VicTrVectPrity13; // Vector priority register 13
input   [3:0] VicTrVectPrity14; // Vector priority register 14
input   [3:0] VicTrVectPrity15; // Vector priority register 15
input   [3:0] VicTrVectPrity16; // Vector priority register 16
input   [3:0] VicTrVectPrity17; // Vector priority register 17
input   [3:0] VicTrVectPrity18; // Vector priority register 18
input   [3:0] VicTrVectPrity19; // Vector priority register 19
input   [3:0] VicTrVectPrity20; // Vector priority register 20
input   [3:0] VicTrVectPrity21; // Vector priority register 21
input   [3:0] VicTrVectPrity22; // Vector priority register 22
input   [3:0] VicTrVectPrity23; // Vector priority register 23
input   [3:0] VicTrVectPrity24; // Vector priority register 24
input   [3:0] VicTrVectPrity25; // Vector priority register 25
input   [3:0] VicTrVectPrity26; // Vector priority register 26
input   [3:0] VicTrVectPrity27; // Vector priority register 27
input   [3:0] VicTrVectPrity28; // Vector priority register 28
input   [3:0] VicTrVectPrity29; // Vector priority register 29
input   [3:0] VicTrVectPrity30; // Vector priority register 30
input   [3:0] VicTrVectPrity31; // Vector priority register 31
input  [15:0] MaskPrityReg;     // Mask Level from the IRQ Priority Block
input         nTrIrq;           // Inverted signal of IRQ Interrupt signal

// Outputs
output [32:0] TrVectIrq;        // IRQ signals 
output        DaisyIrqOut;      // Daisy Chain Interrupt to IRQ Priority Block
output [32:0] PPTable0;         // Priority Table 0 for PLevel 0
output [32:0] PPTable1;         // Priority Table 1 for PLevel 1
output [32:0] PPTable2;         // Priority Table 2 for PLevel 2
output [32:0] PPTable3;         // Priority Table 3 for PLevel 3
output [32:0] PPTable4;         // Priority Table 4 for PLevel 4
output [32:0] PPTable5;         // Priority Table 5 for PLevel 5
output [32:0] PPTable6;         // Priority Table 6 for PLevel 6
output [32:0] PPTable7;         // Priority Table 7 for PLevel 7
output [32:0] PPTable8;         // Priority Table 8 for PLevel 8
output [32:0] PPTable9;         // Priority Table 9 for PLevel 9
output [32:0] PPTable10;        // Priority Table 10 for PLevel 10
output [32:0] PPTable11;        // Priority Table 11 for PLevel 11
output [32:0] PPTable12;        // Priority Table 12 for PLevel 12
output [32:0] PPTable13;        // Priority Table 13 for PLevel 13
output [32:0] PPTable14;        // Priority Table 14 for PLevel 14
output [32:0] PPTable15;        // Priority Table 15 for PLevel 15

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire          nVicTrIrqIn;      // Irq Interrupt from daisy chain
wire          VicTrIrqInReg;    // Enable bit to latch Irq Interrupt
                                // from Daisy chain
wire          VectAddrVld;      // Address Valid Indicator 
wire          nVicTrSyncEn;     // Sync Enable Input 
wire   [31:0] IrqStatus;        // IRQ Status from Interrupt request Logic Block
wire   [15:0] VicTrSwPriMask;   // Software priority mask register
wire    [3:0] VicTrVectPriDsy;  // Vector priority register 
                                // for Daisy chain port
wire    [3:0] VicTrVectPrity0;  // Vector priority register 0
wire    [3:0] VicTrVectPrity1;  // Vector priority register 1
wire    [3:0] VicTrVectPrity2;  // Vector priority register 2
wire    [3:0] VicTrVectPrity3;  // Vector priority register 3
wire    [3:0] VicTrVectPrity4;  // Vector priority register 4
wire    [3:0] VicTrVectPrity5;  // Vector priority register 5
wire    [3:0] VicTrVectPrity6;  // Vector priority register 6
wire    [3:0] VicTrVectPrity7;  // Vector priority register 7
wire    [3:0] VicTrVectPrity8;  // Vector priority register 8
wire    [3:0] VicTrVectPrity9;  // Vector priority register 9
wire    [3:0] VicTrVectPrity10; // Vector priority register 10
wire    [3:0] VicTrVectPrity11; // Vector priority register 11
wire    [3:0] VicTrVectPrity12; // Vector priority register 12
wire    [3:0] VicTrVectPrity13; // Vector priority register 13
wire    [3:0] VicTrVectPrity14; // Vector priority register 14
wire    [3:0] VicTrVectPrity15; // Vector priority register 15
wire    [3:0] VicTrVectPrity16; // Vector priority register 16
wire    [3:0] VicTrVectPrity17; // Vector priority register 17
wire    [3:0] VicTrVectPrity18; // Vector priority register 18
wire    [3:0] VicTrVectPrity19; // Vector priority register 19
wire    [3:0] VicTrVectPrity20; // Vector priority register 20
wire    [3:0] VicTrVectPrity21; // Vector priority register 21
wire    [3:0] VicTrVectPrity22; // Vector priority register 22
wire    [3:0] VicTrVectPrity23; // Vector priority register 23
wire    [3:0] VicTrVectPrity24; // Vector priority register 24
wire    [3:0] VicTrVectPrity25; // Vector priority register 25
wire    [3:0] VicTrVectPrity26; // Vector priority register 26
wire    [3:0] VicTrVectPrity27; // Vector priority register 27
wire    [3:0] VicTrVectPrity28; // Vector priority register 28
wire    [3:0] VicTrVectPrity29; // Vector priority register 29
wire    [3:0] VicTrVectPrity30; // Vector priority register 30
wire    [3:0] VicTrVectPrity31; // Vector priority register 31
wire   [15:0] MaskPrityReg;     // Mask Level from the IRQ Priority Block
wire         nTrIrq;            // Inverted signal of IRQ Interrupt signal   

// Outputs
wire   [32:0] TrVectIrq;        // IRQ signals latched 
wire          DaisyIrqOut;      // Daisy Chain Interrupt IRQ
wire   [32:0] PPTable0;         // Priority Table 0 for PLevel 0
wire   [32:0] PPTable1;         // Priority Table 1 for PLevel 1
wire   [32:0] PPTable2;         // Priority Table 2 for PLevel 2
wire   [32:0] PPTable3;         // Priority Table 3 for PLevel 3
wire   [32:0] PPTable4;         // Priority Table 4 for PLevel 4
wire   [32:0] PPTable5;         // Priority Table 5 for PLevel 5
wire   [32:0] PPTable6;         // Priority Table 6 for PLevel 6
wire   [32:0] PPTable7;         // Priority Table 7 for PLevel 7
wire   [32:0] PPTable8;         // Priority Table 8 for PLevel 8
wire   [32:0] PPTable9;         // Priority Table 9 for PLevel 9
wire   [32:0] PPTable10;        // Priority Table 10 for PLevel 10
wire   [32:0] PPTable11;        // Priority Table 11 for PLevel 11
wire   [32:0] PPTable12;        // Priority Table 12 for PLevel 12
wire   [32:0] PPTable13;        // Priority Table 13 for PLevel 13
wire   [32:0] PPTable14;        // Priority Table 14 for PLevel 14
wire   [32:0] PPTable15;        // Priority Table 15 for PLevel 15

// -----------------------------------------------------------------------------
//
//                             VicTrIrqIntrLog
//                             ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This block generates the active interrupts after masking the interrupts 
// by Software priority and the current priority level. The current priority 
// level is an input which is generated by IRQ Priority block.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          InvnVicTrIrqIn;  // Inverted version of Daisy Chain Interrupt
wire          DaisyIrqIn;      // Daisy Chain Interrupt Internal signal

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg    [15:0] MCheck0;         // Priority Level for Interrupt Source 0
reg    [15:0] MCheck1;         // Priority Level for Interrupt Source 1
reg    [15:0] MCheck2;         // Priority Level for Interrupt Source 2
reg    [15:0] MCheck3;         // Priority Level for Interrupt Source 3
reg    [15:0] MCheck4;         // Priority Level for Interrupt Source 4
reg    [15:0] MCheck5;         // Priority Level for Interrupt Source 5
reg    [15:0] MCheck6;         // Priority Level for Interrupt Source 6
reg    [15:0] MCheck7;         // Priority Level for Interrupt Source 7
reg    [15:0] MCheck8;         // Priority Level for Interrupt Source 8
reg    [15:0] MCheck9;         // Priority Level for Interrupt Source 9
reg    [15:0] MCheck10;        // Priority Level for Interrupt Source 10
reg    [15:0] MCheck11;        // Priority Level for Interrupt Source 11
reg    [15:0] MCheck12;        // Priority Level for Interrupt Source 12
reg    [15:0] MCheck13;        // Priority Level for Interrupt Source 13
reg    [15:0] MCheck14;        // Priority Level for Interrupt Source 14
reg    [15:0] MCheck15;        // Priority Level for Interrupt Source 15
reg    [15:0] MCheck16;        // Priority Level for Interrupt Source 16
reg    [15:0] MCheck17;        // Priority Level for Interrupt Source 17
reg    [15:0] MCheck18;        // Priority Level for Interrupt Source 18
reg    [15:0] MCheck19;        // Priority Level for Interrupt Source 19
reg    [15:0] MCheck20;        // Priority Level for Interrupt Source 20
reg    [15:0] MCheck21;        // Priority Level for Interrupt Source 21
reg    [15:0] MCheck22;        // Priority Level for Interrupt Source 22
reg    [15:0] MCheck23;        // Priority Level for Interrupt Source 23
reg    [15:0] MCheck24;        // Priority Level for Interrupt Source 24
reg    [15:0] MCheck25;        // Priority Level for Interrupt Source 25
reg    [15:0] MCheck26;        // Priority Level for Interrupt Source 26
reg    [15:0] MCheck27;        // Priority Level for Interrupt Source 27
reg    [15:0] MCheck28;        // Priority Level for Interrupt Source 28
reg    [15:0] MCheck29;        // Priority Level for Interrupt Source 29
reg    [15:0] MCheck30;        // Priority Level for Interrupt Source 30
reg    [15:0] MCheck31;        // Priority Level for Interrupt Source 31
reg    [15:0] MCheck32;        // Priority Level for Daisy IRQ Interrupt 
reg    [32:0] IrqStatusReg1;   // First latched version of IRQStatus
reg    [32:0] IrqStatusReg2;   // Second latched version of IRQStatus
reg           RegnVicTrIrq;    // Registered IRQ Daisy Interrupt

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
function [15:0] Decode4;
input  [3:0] PLevel; // Software priority Level for each interrupt source
begin
  case (PLevel)
    4'b0000 : Decode4 = 16'b0000000000000001;
    4'b0001 : Decode4 = 16'b0000000000000010;
    4'b0010 : Decode4 = 16'b0000000000000100;
    4'b0011 : Decode4 = 16'b0000000000001000;
    4'b0100 : Decode4 = 16'b0000000000010000;
    4'b0101 : Decode4 = 16'b0000000000100000;
    4'b0110 : Decode4 = 16'b0000000001000000;
    4'b0111 : Decode4 = 16'b0000000010000000;
    4'b1000 : Decode4 = 16'b0000000100000000;
    4'b1001 : Decode4 = 16'b0000001000000000;
    4'b1010 : Decode4 = 16'b0000010000000000;
    4'b1011 : Decode4 = 16'b0000100000000000;
    4'b1100 : Decode4 = 16'b0001000000000000;
    4'b1101 : Decode4 = 16'b0010000000000000;
    4'b1110 : Decode4 = 16'b0100000000000000;
    4'b1111 : Decode4 = 16'b1000000000000000;
    default : Decode4 = 16'b0000000000000000;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Processing Daisy Chain Interrupt 
// -----------------------------------------------------------------------------
assign InvnVicTrIrqIn  = (HRESETn == 1'b0) ? 1'b0 : ~nVicTrIrqIn;

// -----------------------------------------------------------------------------
// Registering the FIQ Interrupt from Daisy chain if VicTrIrqInReg is
// enabled.
// -----------------------------------------------------------------------------
always@(posedge HCLK or negedge HRESETn)
begin : p_IrqDaisy
  if(HRESETn == 1'b0)
    RegnVicTrIrq <= 1'b0;
  else
    RegnVicTrIrq <= InvnVicTrIrqIn;
end //p_IrqDaisy

assign DaisyIrqIn = (VicTrIrqInReg == 1'b1) ? 
                     RegnVicTrIrq : InvnVicTrIrqIn;

assign DaisyIrqOut = (VicTrIrqInReg == 1'b1) ? 
                     RegnVicTrIrq : InvnVicTrIrqIn;

// -----------------------------------------------------------------------------
// Registering the IRQ Status Signals
// -----------------------------------------------------------------------------
always@(posedge HCLK or negedge HRESETn)
begin : p_Irqlatch
  if (HRESETn == 1'b0)
    begin
      IrqStatusReg1 <= 33'h00000000;
      IrqStatusReg2 <= 33'h00000000;
    end
  else
    begin
      IrqStatusReg1 <= {DaisyIrqIn,IrqStatus};
      IrqStatusReg2 <= IrqStatusReg1;
    end
end //p_Irqlatch

// -----------------------------------------------------------------------------
// Programmable priority Table Update
// MCheck 0 - 15 are the outputs of the priotity level, Software priority mask
// current masking value. At the reset all interrupts are not masked.
// -----------------------------------------------------------------------------
always @(negedge HRESETn or
         VicTrSwPriMask or
         MaskPrityReg or
         VicTrVectPrity0 or
         VicTrVectPrity1 or
         VicTrVectPrity2 or
         VicTrVectPrity3 or
         VicTrVectPrity4 or
         VicTrVectPrity5 or
         VicTrVectPrity6 or
         VicTrVectPrity7 or
         VicTrVectPrity8 or
         VicTrVectPrity9 or
         VicTrVectPrity10 or
         VicTrVectPrity11 or
         VicTrVectPrity12 or
         VicTrVectPrity13 or
         VicTrVectPrity14 or
         VicTrVectPrity15 or
         VicTrVectPrity16 or
         VicTrVectPrity17 or
         VicTrVectPrity18 or
         VicTrVectPrity19 or
         VicTrVectPrity20 or
         VicTrVectPrity21 or
         VicTrVectPrity22 or
         VicTrVectPrity23 or
         VicTrVectPrity24 or
         VicTrVectPrity25 or
         VicTrVectPrity26 or
         VicTrVectPrity27 or
         VicTrVectPrity28 or
         VicTrVectPrity29 or
         VicTrVectPrity30 or
         VicTrVectPrity31 or
         VicTrVectPriDsy         
         )
begin : p_pptgencomb
  if (HRESETn == 1'b0)
    begin
      MCheck0 <= 16'h8000;
      MCheck1 <= 16'h8000;
      MCheck2 <= 16'h8000;
      MCheck3 <= 16'h8000;
      MCheck4 <= 16'h8000;
      MCheck5 <= 16'h8000;
      MCheck6 <= 16'h8000;
      MCheck7 <= 16'h8000;
      MCheck8 <= 16'h8000;
      MCheck9 <= 16'h8000;
      MCheck10 <= 16'h8000;
      MCheck11 <= 16'h8000;
      MCheck12 <= 16'h8000;
      MCheck13 <= 16'h8000;
      MCheck14 <= 16'h8000;
      MCheck15 <= 16'h8000;
      MCheck16 <= 16'h8000;
      MCheck17 <= 16'h8000;
      MCheck18 <= 16'h8000;
      MCheck19 <= 16'h8000;
      MCheck20 <= 16'h8000;
      MCheck21 <= 16'h8000;
      MCheck22 <= 16'h8000;
      MCheck23 <= 16'h8000;
      MCheck24 <= 16'h8000;
      MCheck25 <= 16'h8000;
      MCheck26 <= 16'h8000;
      MCheck27 <= 16'h8000;
      MCheck28 <= 16'h8000;
      MCheck29 <= 16'h8000;
      MCheck30 <= 16'h8000;
      MCheck31 <= 16'h8000;
      MCheck32 <= 16'h8000;
    end
  else
    begin
      MCheck0 <= Decode4(VicTrVectPrity0) & VicTrSwPriMask & MaskPrityReg;
      MCheck1 <= Decode4(VicTrVectPrity1) & VicTrSwPriMask & MaskPrityReg;
      MCheck2 <= Decode4(VicTrVectPrity2) & VicTrSwPriMask & MaskPrityReg;
      MCheck3 <= Decode4(VicTrVectPrity3) & VicTrSwPriMask & MaskPrityReg;
      MCheck4 <= Decode4(VicTrVectPrity4) & VicTrSwPriMask & MaskPrityReg;
      MCheck5 <= Decode4(VicTrVectPrity5) & VicTrSwPriMask & MaskPrityReg;
      MCheck6 <= Decode4(VicTrVectPrity6) & VicTrSwPriMask & MaskPrityReg;
      MCheck7 <= Decode4(VicTrVectPrity7) & VicTrSwPriMask & MaskPrityReg;
      MCheck8 <= Decode4(VicTrVectPrity8) & VicTrSwPriMask & MaskPrityReg;
      MCheck9 <= Decode4(VicTrVectPrity9) & VicTrSwPriMask & MaskPrityReg;
      MCheck10 <= Decode4(VicTrVectPrity10) & VicTrSwPriMask & MaskPrityReg;
      MCheck11 <= Decode4(VicTrVectPrity11) & VicTrSwPriMask & MaskPrityReg;
      MCheck12 <= Decode4(VicTrVectPrity12) & VicTrSwPriMask & MaskPrityReg;
      MCheck13 <= Decode4(VicTrVectPrity13) & VicTrSwPriMask & MaskPrityReg;
      MCheck14 <= Decode4(VicTrVectPrity14) & VicTrSwPriMask & MaskPrityReg;
      MCheck15 <= Decode4(VicTrVectPrity15) & VicTrSwPriMask & MaskPrityReg;
      MCheck16 <= Decode4(VicTrVectPrity16) & VicTrSwPriMask & MaskPrityReg;
      MCheck17 <= Decode4(VicTrVectPrity17) & VicTrSwPriMask & MaskPrityReg;
      MCheck18 <= Decode4(VicTrVectPrity18) & VicTrSwPriMask & MaskPrityReg;
      MCheck19 <= Decode4(VicTrVectPrity19) & VicTrSwPriMask & MaskPrityReg;
      MCheck20 <= Decode4(VicTrVectPrity20) & VicTrSwPriMask & MaskPrityReg;
      MCheck21 <= Decode4(VicTrVectPrity21) & VicTrSwPriMask & MaskPrityReg;
      MCheck22 <= Decode4(VicTrVectPrity22) & VicTrSwPriMask & MaskPrityReg;
      MCheck23 <= Decode4(VicTrVectPrity23) & VicTrSwPriMask & MaskPrityReg;
      MCheck24 <= Decode4(VicTrVectPrity24) & VicTrSwPriMask & MaskPrityReg;
      MCheck25 <= Decode4(VicTrVectPrity25) & VicTrSwPriMask & MaskPrityReg;
      MCheck26 <= Decode4(VicTrVectPrity26) & VicTrSwPriMask & MaskPrityReg;
      MCheck27 <= Decode4(VicTrVectPrity27) & VicTrSwPriMask & MaskPrityReg;
      MCheck28 <= Decode4(VicTrVectPrity28) & VicTrSwPriMask & MaskPrityReg;
      MCheck29 <= Decode4(VicTrVectPrity29) & VicTrSwPriMask & MaskPrityReg;
      MCheck29 <= Decode4(VicTrVectPrity29) & VicTrSwPriMask & MaskPrityReg;
      MCheck30 <= Decode4(VicTrVectPrity30) & VicTrSwPriMask & MaskPrityReg;
      MCheck31 <= Decode4(VicTrVectPrity31) & VicTrSwPriMask & MaskPrityReg;
      MCheck32 <= Decode4(VicTrVectPriDsy) & VicTrSwPriMask  & MaskPrityReg;
    end 
end // p_pptgencomb

// -----------------------------------------------------------------------------
// Assigning MCheck signals to PPTable output registers
// Each PPTable represents priority level for example PPTable0 represents
// priority level 0 of all interrupts sources(31+Daisy Interrupts).
// -----------------------------------------------------------------------------
assign PPTable0 = { MCheck32[0],MCheck31[0],MCheck30[0], 
              MCheck29[0],MCheck28[0],MCheck27[0],
              MCheck26[0],MCheck25[0],MCheck24[0],
              MCheck23[0],MCheck22[0],MCheck21[0],
              MCheck20[0],MCheck19[0],MCheck18[0],
              MCheck17[0],MCheck16[0],MCheck15[0],
              MCheck14[0],MCheck13[0],MCheck12[0],
              MCheck11[0],MCheck10[0],MCheck9[0],
              MCheck8[0],MCheck7[0],MCheck6[0],
              MCheck5[0],MCheck4[0],MCheck3[0],
              MCheck2[0],MCheck1[0],MCheck0[0]};

assign PPTable1 = { MCheck32[1],MCheck31[1],MCheck30[1], 
              MCheck29[1],MCheck28[1],MCheck27[1],
              MCheck26[1],MCheck25[1],MCheck24[1],
              MCheck23[1],MCheck22[1],MCheck21[1],
              MCheck20[1],MCheck19[1],MCheck18[1],
              MCheck17[1],MCheck16[1],MCheck15[1],
              MCheck14[1],MCheck13[1],MCheck12[1],
              MCheck11[1],MCheck10[1],MCheck9[1],
              MCheck8[1],MCheck7[1] ,MCheck6[1],
              MCheck5[1],MCheck4[1] ,MCheck3[1],
              MCheck2[1],MCheck1[1] ,MCheck0[1]};

assign PPTable2 = { MCheck32[2],MCheck31[2],MCheck30[2], 
              MCheck29[2],MCheck28[2],MCheck27[2],
              MCheck26[2],MCheck25[2],MCheck24[2],
              MCheck23[2],MCheck22[2],MCheck21[2],
              MCheck20[2],MCheck19[2],MCheck18[2],
              MCheck17[2],MCheck16[2],MCheck15[2],
              MCheck14[2],MCheck13[2],MCheck12[2],
              MCheck11[2],MCheck10[2],MCheck9[2],
              MCheck8[2],MCheck7[2] ,MCheck6[2],
              MCheck5[2],MCheck4[2] ,MCheck3[2],
              MCheck2[2],MCheck1[2] ,MCheck0[2]};

assign PPTable3 = { MCheck32[3],MCheck31[3],MCheck30[3], 
              MCheck29[3],MCheck28[3],MCheck27[3],
              MCheck26[3],MCheck25[3],MCheck24[3],
              MCheck23[3],MCheck22[3],MCheck21[3],
              MCheck20[3],MCheck19[3],MCheck18[3],
              MCheck17[3],MCheck16[3],MCheck15[3],
              MCheck14[3],MCheck13[3],MCheck12[3],
              MCheck11[3],MCheck10[3],MCheck9[3],
              MCheck8[3],MCheck7[3] ,MCheck6[3],
              MCheck5[3],MCheck4[3] ,MCheck3[3],
              MCheck2[3],MCheck1[3] ,MCheck0[3]};

assign PPTable4 = { MCheck32[4],MCheck31[4],MCheck30[4], 
              MCheck29[4],MCheck28[4],MCheck27[4],
              MCheck26[4],MCheck25[4],MCheck24[4],
              MCheck23[4],MCheck22[4],MCheck21[4],
              MCheck20[4],MCheck19[4],MCheck18[4],
              MCheck17[4],MCheck16[4],MCheck15[4],
              MCheck14[4],MCheck13[4],MCheck12[4],
              MCheck11[4],MCheck10[4],MCheck9[4],
              MCheck8[4],MCheck7[4] ,MCheck6[4],
              MCheck5[4],MCheck4[4] ,MCheck3[4],
              MCheck2[4],MCheck1[4] ,MCheck0[4]};

assign PPTable5 = { MCheck32[5],MCheck31[5],MCheck30[5], 
              MCheck29[5],MCheck28[5],MCheck27[5],
              MCheck26[5],MCheck25[5],MCheck24[5],
              MCheck23[5],MCheck22[5],MCheck21[5],
              MCheck20[5],MCheck19[5],MCheck18[5],
              MCheck17[5],MCheck16[5],MCheck15[5],
              MCheck14[5],MCheck13[5],MCheck12[5],
              MCheck11[5],MCheck10[5],MCheck9[5],
              MCheck8[5],MCheck7[5] ,MCheck6[5],
              MCheck5[5],MCheck4[5] ,MCheck3[5],
              MCheck2[5],MCheck1[5] ,MCheck0[5]};

assign PPTable6 = { MCheck32[6],MCheck31[6],MCheck30[6], 
              MCheck29[6],MCheck28[6],MCheck27[6],
              MCheck26[6],MCheck25[6],MCheck24[6],
              MCheck23[6],MCheck22[6],MCheck21[6],
              MCheck20[6],MCheck19[6],MCheck18[6],
              MCheck17[6],MCheck16[6],MCheck15[6],
              MCheck14[6],MCheck13[6],MCheck12[6],
              MCheck11[6],MCheck10[6],MCheck9[6],
              MCheck8[6],MCheck7[6] ,MCheck6[6],
              MCheck5[6],MCheck4[6] ,MCheck3[6],
              MCheck2[6],MCheck1[6] ,MCheck0[6]};

assign PPTable7 = { MCheck32[7],MCheck31[7],MCheck30[7], 
              MCheck29[7],MCheck28[7],MCheck27[7],
              MCheck26[7],MCheck25[7],MCheck24[7],
              MCheck23[7],MCheck22[7],MCheck21[7],
              MCheck20[7],MCheck19[7],MCheck18[7],
              MCheck17[7],MCheck16[7],MCheck15[7],
              MCheck14[7],MCheck13[7],MCheck12[7],
              MCheck11[7],MCheck10[7],MCheck9[7],
              MCheck8[7],MCheck7[7] ,MCheck6[7],
              MCheck5[7],MCheck4[7] ,MCheck3[7],
              MCheck2[7],MCheck1[7] ,MCheck0[7]};

assign PPTable8 = { MCheck32[8],MCheck31[8],MCheck30[8], 
              MCheck29[8],MCheck28[8],MCheck27[8],
              MCheck26[8],MCheck25[8],MCheck24[8],
              MCheck23[8],MCheck22[8],MCheck21[8],
              MCheck20[8],MCheck19[8],MCheck18[8],
              MCheck17[8],MCheck16[8],MCheck15[8],
              MCheck14[8],MCheck13[8],MCheck12[8],
              MCheck11[8],MCheck10[8],MCheck9[8],
              MCheck8[8],MCheck7[8] ,MCheck6[8],
              MCheck5[8],MCheck4[8] ,MCheck3[8],
              MCheck2[8],MCheck1[8] ,MCheck0[8]};

assign PPTable9 = { MCheck32[9],MCheck31[9],MCheck30[9], 
              MCheck29[9],MCheck28[9],MCheck27[9],
              MCheck26[9],MCheck25[9],MCheck24[9],
              MCheck23[9],MCheck22[9],MCheck21[9],
              MCheck20[9],MCheck19[9],MCheck18[9],
              MCheck17[9],MCheck16[9],MCheck15[9],
              MCheck14[9],MCheck13[9],MCheck12[9],
              MCheck11[9],MCheck10[9],MCheck9[9],
              MCheck8[9],MCheck7[9] ,MCheck6[9],
              MCheck5[9],MCheck4[9] ,MCheck3[9],
              MCheck2[9],MCheck1[9] ,MCheck0[9]};

assign PPTable10 = { MCheck32[10],MCheck31[10],MCheck30[10], 
              MCheck29[10],MCheck28[10],MCheck27[10],
              MCheck26[10],MCheck25[10],MCheck24[10],
              MCheck23[10],MCheck22[10],MCheck21[10],
              MCheck20[10],MCheck19[10],MCheck18[10],
              MCheck17[10],MCheck16[10],MCheck15[10],
              MCheck14[10],MCheck13[10],MCheck12[10],
              MCheck11[10],MCheck10[10],MCheck9[10],
              MCheck8[10],MCheck7[10] ,MCheck6[10],
              MCheck5[10],MCheck4[10] ,MCheck3[10],
              MCheck2[10],MCheck1[10] ,MCheck0[10]};

assign PPTable11 = { MCheck32[11],MCheck31[11],MCheck30[11], 
              MCheck29[11],MCheck28[11],MCheck27[11],
              MCheck26[11],MCheck25[11],MCheck24[11],
              MCheck23[11],MCheck22[11],MCheck21[11],
              MCheck20[11],MCheck19[11],MCheck18[11],
              MCheck17[11],MCheck16[11],MCheck15[11],
              MCheck14[11],MCheck13[11],MCheck12[11],
              MCheck11[11],MCheck10[11],MCheck9[11],
              MCheck8[11],MCheck7[11] ,MCheck6[11],
              MCheck5[11],MCheck4[11] ,MCheck3[11],
              MCheck2[11],MCheck1[11] ,MCheck0[11]};

assign PPTable12 = { MCheck32[12],MCheck31[12],MCheck30[12], 
              MCheck29[12],MCheck28[12],MCheck27[12],
              MCheck26[12],MCheck25[12],MCheck24[12],
              MCheck23[12],MCheck22[12],MCheck21[12],
              MCheck20[12],MCheck19[12],MCheck18[12],
              MCheck17[12],MCheck16[12],MCheck15[12],
              MCheck14[12],MCheck13[12],MCheck12[12],
              MCheck11[12],MCheck10[12],MCheck9[12],
              MCheck8[12],MCheck7[12] ,MCheck6[12],
              MCheck5[12],MCheck4[12] ,MCheck3[12],
              MCheck2[12],MCheck1[12] ,MCheck0[12]};

assign PPTable13 = { MCheck32[13],MCheck31[13],MCheck30[13], 
              MCheck29[13],MCheck28[13],MCheck27[13],
              MCheck26[13],MCheck25[13],MCheck24[13],
              MCheck23[13],MCheck22[13],MCheck21[13],
              MCheck20[13],MCheck19[13],MCheck18[13],
              MCheck17[13],MCheck16[13],MCheck15[13],
              MCheck14[13],MCheck13[13],MCheck12[13],
              MCheck11[13],MCheck10[13],MCheck9[13],
              MCheck8[13],MCheck7[13] ,MCheck6[13],
              MCheck5[13],MCheck4[13] ,MCheck3[13],
              MCheck2[13],MCheck1[13] ,MCheck0[13]};

assign PPTable14 = { MCheck32[14],MCheck31[14],MCheck30[14], 
              MCheck29[14],MCheck28[14],MCheck27[14],
              MCheck26[14],MCheck25[14],MCheck24[14],
              MCheck23[14],MCheck22[14],MCheck21[14],
              MCheck20[14],MCheck19[14],MCheck18[14],
              MCheck17[14],MCheck16[14],MCheck15[14],
              MCheck14[14],MCheck13[14],MCheck12[14],
              MCheck11[14],MCheck10[14],MCheck9[14],
              MCheck8[14],MCheck7[14] ,MCheck6[14],
              MCheck5[14],MCheck4[14] ,MCheck3[14],
              MCheck2[14],MCheck1[14] ,MCheck0[14]};

assign PPTable15 = { MCheck32[15],MCheck31[15],MCheck30[15], 
              MCheck29[15],MCheck28[15],MCheck27[15],
              MCheck26[15],MCheck25[15],MCheck24[15],
              MCheck23[15],MCheck22[15],MCheck21[15],
              MCheck20[15],MCheck19[15],MCheck18[15],
              MCheck17[15],MCheck16[15],MCheck15[15],
              MCheck14[15],MCheck13[15],MCheck12[15],
              MCheck11[15],MCheck10[15],MCheck9[15],
              MCheck8[15],MCheck7[15] ,MCheck6[15],
              MCheck5[15],MCheck4[15] ,MCheck3[15],
              MCheck2[15],MCheck1[15] ,MCheck0[15]};

// -----------------------------------------------------------------------------
// VectIRQx signals
// Active interrupts Generation 
// -----------------------------------------------------------------------------
assign TrVectIrq[0] = |MCheck0 & IrqStatusReg2[0] ;
assign TrVectIrq[1] = |MCheck1 & IrqStatusReg2[1] ;
assign TrVectIrq[2] = |MCheck2 & IrqStatusReg2[2] ;
assign TrVectIrq[3] = |MCheck3 & IrqStatusReg2[3] ;
assign TrVectIrq[4] = |MCheck4 & IrqStatusReg2[4] ;
assign TrVectIrq[5] = |MCheck5 & IrqStatusReg2[5] ;
assign TrVectIrq[6] = |MCheck6 & IrqStatusReg2[6] ;
assign TrVectIrq[7] = |MCheck7 & IrqStatusReg2[7] ;
assign TrVectIrq[8] = |MCheck8 & IrqStatusReg2[8] ;
assign TrVectIrq[9] = |MCheck9 & IrqStatusReg2[9] ;
assign TrVectIrq[10] = |MCheck10 & IrqStatusReg2[10] ;
assign TrVectIrq[11] = |MCheck11 & IrqStatusReg2[11] ;
assign TrVectIrq[12] = |MCheck12 & IrqStatusReg2[12] ;
assign TrVectIrq[13] = |MCheck13 & IrqStatusReg2[13] ;
assign TrVectIrq[14] = |MCheck14 & IrqStatusReg2[14] ;
assign TrVectIrq[15] = |MCheck15 & IrqStatusReg2[15] ;
assign TrVectIrq[16] = |MCheck16 & IrqStatusReg2[16] ;
assign TrVectIrq[17] = |MCheck17 & IrqStatusReg2[17] ;
assign TrVectIrq[18] = |MCheck18 & IrqStatusReg2[18] ;
assign TrVectIrq[19] = |MCheck19 & IrqStatusReg2[19] ;
assign TrVectIrq[20] = |MCheck20 & IrqStatusReg2[20] ;
assign TrVectIrq[21] = |MCheck21 & IrqStatusReg2[21] ;
assign TrVectIrq[22] = |MCheck22 & IrqStatusReg2[22] ;
assign TrVectIrq[23] = |MCheck23 & IrqStatusReg2[23] ;
assign TrVectIrq[24] = |MCheck24 & IrqStatusReg2[24] ;
assign TrVectIrq[25] = |MCheck25 & IrqStatusReg2[25] ;
assign TrVectIrq[26] = |MCheck26 & IrqStatusReg2[26] ;
assign TrVectIrq[27] = |MCheck27 & IrqStatusReg2[27] ;
assign TrVectIrq[28] = |MCheck28 & IrqStatusReg2[28] ;
assign TrVectIrq[29] = |MCheck29 & IrqStatusReg2[29] ;
assign TrVectIrq[30] = |MCheck30 & IrqStatusReg2[30] ;
assign TrVectIrq[31] = |MCheck31 & IrqStatusReg2[31] ;
assign TrVectIrq[32] = |MCheck32 & IrqStatusReg2[32] ;

endmodule

// --=============================== End =====================================--
