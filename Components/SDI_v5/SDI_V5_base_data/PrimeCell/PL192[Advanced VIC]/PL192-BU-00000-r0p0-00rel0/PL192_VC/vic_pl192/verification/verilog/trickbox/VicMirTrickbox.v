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
// File Name              : VicMirTrickbox.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Top level of the VIC Mirror Trick Box.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicMirTrickbox (
// Inputs
                       HCLK,
                       HRESETn,
                       VicTrIntSource,
                       nVicTrFiqIn,
                       nVicTrIrqIn, 
                       VicTrVectAddrIn,
                       VicTrIrqInReg, 
                       VicTrFiqInReg, 
                       VicTrIrqAck,
                       nVicTrSyncEn,
                       VicTrSoftInt,
                       VicTrIntEn,
                       VicTrIntSelect,
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
                       VicTrVectAddr0,
                       VicTrVectAddr1,
                       VicTrVectAddr2,
                       VicTrVectAddr3,
                       VicTrVectAddr4,
                       VicTrVectAddr5,
                       VicTrVectAddr6,
                       VicTrVectAddr7,
                       VicTrVectAddr8,
                       VicTrVectAddr9,
                       VicTrVectAddr10,
                       VicTrVectAddr11,
                       VicTrVectAddr12,
                       VicTrVectAddr13,
                       VicTrVectAddr14,
                       VicTrVectAddr15,
                       VicTrVectAddr16,
                       VicTrVectAddr17,
                       VicTrVectAddr18,
                       VicTrVectAddr19,
                       VicTrVectAddr20,
                       VicTrVectAddr21,
                       VicTrVectAddr22,
                       VicTrVectAddr23,
                       VicTrVectAddr24,
                       VicTrVectAddr25,
                       VicTrVectAddr26,
                       VicTrVectAddr27,
                       VicTrVectAddr28,
                       VicTrVectAddr29,
                       VicTrVectAddr30,
                       VicTrVectAddr31,
                       VectAddrWrTrig,
                       VectAddrRdTrig,
                       AsyncRdEn,

// Outputs
                       VicTrRawIntr, 
                       VicTrIrqStatus, 
                       VicTrFiqStatus, 
                       nVicTrFiq,
                       nVicTrIrq,
                       VicTrIrqAckOut,
                       VicTrVectAddrv,
                       VicTrVectAddr
                      );

// Inputs
input         HCLK;               // AHB Clock
input         HRESETn;            // AHB reset
input  [31:0] VicTrIntSource;     // Peripheral interrupt source input
input         nVicTrFiqIn;        // FIQ interrupt from the daisy chain VIC
input         nVicTrIrqIn;        // IRQ interrupt from the daisy chain VIC
input  [31:0] VicTrVectAddrIn;    // Vector address from the daisy chain VIC
input         VicTrIrqInReg;      // Register enable signal for VICIRQIN
input         VicTrFiqInReg;      // Register enable signal for VICFIQIN
input         VicTrIrqAck;        // Acknowledge signal from the CPU
input         nVicTrSyncEn;       // Synchronous enable signal for the vic port
input  [31:0] VicTrSoftInt;       // Software interrupt
input  [31:0] VicTrIntEn;         // Interrupt enable
input  [31:0] VicTrIntSelect;     // Interrupt type select
input  [15:0] VicTrSwPriMask;     // Software Priority Mask
input   [3:0] VicTrVectPriDsy;    // Vector priority daisy chain interrupt
input   [3:0] VicTrVectPrity0;    // Vector priority for 0th interrupt source
input   [3:0] VicTrVectPrity1;    // Vector priority for 1st interrupt source
input   [3:0] VicTrVectPrity2;    // Vector priority for 2nd interrupt source
input   [3:0] VicTrVectPrity3;    // Vector priority for 3rd interrupt source
input   [3:0] VicTrVectPrity4;    // Vector priority for 4th interrupt source
input   [3:0] VicTrVectPrity5;    // Vector priority for 5th interrupt source
input   [3:0] VicTrVectPrity6;    // Vector priority for 6th interrupt source
input   [3:0] VicTrVectPrity7;    // Vector priority for 7th interrupt source
input   [3:0] VicTrVectPrity8;    // Vector priority for 8th interrupt source
input   [3:0] VicTrVectPrity9;    // Vector priority for 9th interrupt source
input   [3:0] VicTrVectPrity10;   // Vector priority for 10th interrupt source
input   [3:0] VicTrVectPrity11;   // Vector priority for 11th interrupt source
input   [3:0] VicTrVectPrity12;   // Vector priority for 12th interrupt source
input   [3:0] VicTrVectPrity13;   // Vector priority for 13th interrupt source
input   [3:0] VicTrVectPrity14;   // Vector priority for 14th interrupt source
input   [3:0] VicTrVectPrity15;   // Vector priority for 15th interrupt source
input   [3:0] VicTrVectPrity16;   // Vector priority for 16th interrupt source
input   [3:0] VicTrVectPrity17;   // Vector priority for 17th interrupt source
input   [3:0] VicTrVectPrity18;   // Vector priority for 18th interrupt source
input   [3:0] VicTrVectPrity19;   // Vector priority for 19th interrupt source
input   [3:0] VicTrVectPrity20;   // Vector priority for 20th interrupt source
input   [3:0] VicTrVectPrity21;   // Vector priority for 21st interrupt source
input   [3:0] VicTrVectPrity22;   // Vector priority for 22nd interrupt source
input   [3:0] VicTrVectPrity23;   // Vector priority for 23rd interrupt source
input   [3:0] VicTrVectPrity24;   // Vector priority for 24th interrupt source
input   [3:0] VicTrVectPrity25;   // Vector priority for 25th interrupt source
input   [3:0] VicTrVectPrity26;   // Vector priority for 26th interrupt source
input   [3:0] VicTrVectPrity27;   // Vector priority for 27th interrupt source
input   [3:0] VicTrVectPrity28;   // Vector priority for 28th interrupt source
input   [3:0] VicTrVectPrity29;   // Vector priority for 29th interrupt source
input   [3:0] VicTrVectPrity30;   // Vector priority for 30th interrupt source
input   [3:0] VicTrVectPrity31;   // Vector priority for 31st interrupt source
input  [31:0] VicTrVectAddr0;     // Vector address for 0th interrupt source
input  [31:0] VicTrVectAddr1;     // Vector address for 1st interrupt source
input  [31:0] VicTrVectAddr2;     // Vector address for 2nd interrupt source
input  [31:0] VicTrVectAddr3;     // Vector address for 3rd interrupt source
input  [31:0] VicTrVectAddr4;     // Vector address for 4th interrupt source
input  [31:0] VicTrVectAddr5;     // Vector address for 5th interrupt source
input  [31:0] VicTrVectAddr6;     // Vector address for 6th interrupt source
input  [31:0] VicTrVectAddr7;     // Vector address for 7th interrupt source
input  [31:0] VicTrVectAddr8;     // Vector address for 8th interrupt source
input  [31:0] VicTrVectAddr9;     // Vector address for 9th interrupt source
input  [31:0] VicTrVectAddr10;    // Vector address for 10th interrupt source
input  [31:0] VicTrVectAddr11;    // Vector address for 11th interrupt source
input  [31:0] VicTrVectAddr12;    // Vector address for 12th interrupt source
input  [31:0] VicTrVectAddr13;    // Vector address for 13th interrupt source
input  [31:0] VicTrVectAddr14;    // Vector address for 14th interrupt source
input  [31:0] VicTrVectAddr15;    // Vector address for 15th interrupt source
input  [31:0] VicTrVectAddr16;    // Vector address for 16th interrupt source
input  [31:0] VicTrVectAddr17;    // Vector address for 17th interrupt source
input  [31:0] VicTrVectAddr18;    // Vector address for 18th interrupt source
input  [31:0] VicTrVectAddr19;    // Vector address for 19th interrupt source
input  [31:0] VicTrVectAddr20;    // Vector address for 20th interrupt source
input  [31:0] VicTrVectAddr21;    // Vector address for 21st interrupt source
input  [31:0] VicTrVectAddr22;    // Vector address for 22nd interrupt source
input  [31:0] VicTrVectAddr23;    // Vector address for 23rd interrupt source
input  [31:0] VicTrVectAddr24;    // Vector address for 24th interrupt source
input  [31:0] VicTrVectAddr25;    // Vector address for 25th interrupt source
input  [31:0] VicTrVectAddr26;    // Vector address for 26th interrupt source
input  [31:0] VicTrVectAddr27;    // Vector address for 27th interrupt source
input  [31:0] VicTrVectAddr28;    // Vector address for 28th interrupt source
input  [31:0] VicTrVectAddr29;    // Vector address for 29th interrupt source
input  [31:0] VicTrVectAddr30;    // Vector address for 30th interrupt source
input  [31:0] VicTrVectAddr31;    // Vector address for 31st interrupt source
input         VectAddrWrTrig;     // Indicates a write on VICADDRESS register
input         VectAddrRdTrig;     // Indicates a read on VICADDRESS register
input         AsyncRdEn;          // Asynchronous read enable signal

// Outputs
output [31:0] VicTrRawIntr;       // Raw Interrupt source
output [31:0] VicTrIrqStatus;     // IRQ Interrupt status
output [31:0] VicTrFiqStatus;     // FIQ Interrupt status
output        nVicTrFiq;          // FIQ Interrupt to CPU
output        nVicTrIrq;          // IRQ Interrupt to CPU
output        VicTrIrqAckOut;     // ACKOUT signal to Daisy Chain VIC
output        VicTrVectAddrv;     // Address valid signal
output        VicTrVectAddr;      // Vector Address out line
 
// Inputs
wire          HCLK;               // AHB Clock
wire          HRESETn;            // AHB reset
wire   [31:0] VicTrIntSource;     // Peripheral interrupt source input
wire          nVicTrFiqIn;        // FIQ interrupt from the daisy chain VIC
wire          nVicTrIrqIn;        // IRQ interrupt from the daisy chain VIC
wire   [31:0] VicTrVectAddrIn;    // Vector address from the daisy chain VIC
wire          VicTrIrqInReg;      // Register enable signal for VICIRQIN
wire          VicTrFiqInReg;      // Register enable signal for VICFIQIN
wire          VicTrIrqAck;        // Acknowledge signal from the CPU
wire          nVicTrSyncEn;       // Synchronous enable signal for the VIC port
wire   [31:0] VicTrSoftInt;       // Software interrupt
wire   [31:0] VicTrIntEn;         // Interrupt enable
wire   [31:0] VicTrIntSelect;     // Interrupt type select
wire   [15:0] VicTrSwPriMask;     // Software Priority Mask
wire    [3:0] VicTrVectPriDsy;    // Vector priority daisy chain interrupt
wire    [3:0] VicTrVectPrity0;    // Vector priority for 0th interrupt source
wire    [3:0] VicTrVectPrity1;    // Vector priority for 1st interrupt source
wire    [3:0] VicTrVectPrity2;    // Vector priority for 2nd interrupt source
wire    [3:0] VicTrVectPrity3;    // Vector priority for 3rd interrupt source
wire    [3:0] VicTrVectPrity4;    // Vector priority for 4th interrupt source
wire    [3:0] VicTrVectPrity5;    // Vector priority for 5th interrupt source
wire    [3:0] VicTrVectPrity6;    // Vector priority for 6th interrupt source
wire    [3:0] VicTrVectPrity7;    // Vector priority for 7th interrupt source
wire    [3:0] VicTrVectPrity8;    // Vector priority for 8th interrupt source
wire    [3:0] VicTrVectPrity9;    // Vector priority for 9th interrupt source
wire    [3:0] VicTrVectPrity10;   // Vector priority for 10th interrupt source
wire    [3:0] VicTrVectPrity11;   // Vector priority for 11th interrupt source
wire    [3:0] VicTrVectPrity12;   // Vector priority for 12th interrupt source
wire    [3:0] VicTrVectPrity13;   // Vector priority for 13th interrupt source
wire    [3:0] VicTrVectPrity14;   // Vector priority for 14th interrupt source
wire    [3:0] VicTrVectPrity15;   // Vector priority for 15th interrupt source
wire    [3:0] VicTrVectPrity16;   // Vector priority for 16th interrupt source
wire    [3:0] VicTrVectPrity17;   // Vector priority for 17th interrupt source
wire    [3:0] VicTrVectPrity18;   // Vector priority for 18th interrupt source
wire    [3:0] VicTrVectPrity19;   // Vector priority for 19th interrupt source
wire    [3:0] VicTrVectPrity20;   // Vector priority for 20th interrupt source
wire    [3:0] VicTrVectPrity21;   // Vector priority for 21st interrupt source
wire    [3:0] VicTrVectPrity22;   // Vector priority for 22nd interrupt source
wire    [3:0] VicTrVectPrity23;   // Vector priority for 23rd interrupt source
wire    [3:0] VicTrVectPrity24;   // Vector priority for 24th interrupt source
wire    [3:0] VicTrVectPrity25;   // Vector priority for 25th interrupt source
wire    [3:0] VicTrVectPrity26;   // Vector priority for 26th interrupt source
wire    [3:0] VicTrVectPrity27;   // Vector priority for 27th interrupt source
wire    [3:0] VicTrVectPrity28;   // Vector priority for 28th interrupt source
wire    [3:0] VicTrVectPrity29;   // Vector priority for 29th interrupt source
wire    [3:0] VicTrVectPrity30;   // Vector priority for 30th interrupt source
wire    [3:0] VicTrVectPrity31;   // Vector priority for 31st interrupt source
wire   [31:0] VicTrVectAddr0;     // Vector address for 0th interrupt source
wire   [31:0] VicTrVectAddr1;     // Vector address for 1st interrupt source
wire   [31:0] VicTrVectAddr2;     // Vector address for 2nd interrupt source
wire   [31:0] VicTrVectAddr3;     // Vector address for 3rd interrupt source
wire   [31:0] VicTrVectAddr4;     // Vector address for 4th interrupt source
wire   [31:0] VicTrVectAddr5;     // Vector address for 5th interrupt source
wire   [31:0] VicTrVectAddr6;     // Vector address for 6th interrupt source
wire   [31:0] VicTrVectAddr7;     // Vector address for 7th interrupt source
wire   [31:0] VicTrVectAddr8;     // Vector address for 8th interrupt source
wire   [31:0] VicTrVectAddr9;     // Vector address for 9th interrupt source
wire   [31:0] VicTrVectAddr10;    // Vector address for 10th interrupt source
wire   [31:0] VicTrVectAddr11;    // Vector address for 11th interrupt source
wire   [31:0] VicTrVectAddr12;    // Vector address for 12th interrupt source
wire   [31:0] VicTrVectAddr13;    // Vector address for 13th interrupt source
wire   [31:0] VicTrVectAddr14;    // Vector address for 14th interrupt source
wire   [31:0] VicTrVectAddr15;    // Vector address for 15th interrupt source
wire   [31:0] VicTrVectAddr16;    // Vector address for 16th interrupt source
wire   [31:0] VicTrVectAddr17;    // Vector address for 17th interrupt source
wire   [31:0] VicTrVectAddr18;    // Vector address for 18th interrupt source
wire   [31:0] VicTrVectAddr19;    // Vector address for 19th interrupt source
wire   [31:0] VicTrVectAddr20;    // Vector address for 20th interrupt source
wire   [31:0] VicTrVectAddr21;    // Vector address for 21st interrupt source
wire   [31:0] VicTrVectAddr22;    // Vector address for 22nd interrupt source
wire   [31:0] VicTrVectAddr23;    // Vector address for 23rd interrupt source
wire   [31:0] VicTrVectAddr24;    // Vector address for 24th interrupt source
wire   [31:0] VicTrVectAddr25;    // Vector address for 25th interrupt source
wire   [31:0] VicTrVectAddr26;    // Vector address for 26th interrupt source
wire   [31:0] VicTrVectAddr27;    // Vector address for 27th interrupt source
wire   [31:0] VicTrVectAddr28;    // Vector address for 28th interrupt source
wire   [31:0] VicTrVectAddr29;    // Vector address for 29th interrupt source
wire   [31:0] VicTrVectAddr30;    // Vector address for 30th interrupt source
wire   [31:0] VicTrVectAddr31;    // Vector address for 31st interrupt source
wire          VectAddrWrTrig;     // Indicates a write on VICADDRESS register
wire          VectAddrRdTrig;     // Indicates a read on VICADDRESS register
wire          AsyncRdEn;          // Asynchronous read enable signal

// Outputs
wire   [31:0] VicTrRawIntr;       // Raw Interrupt source
wire   [31:0] VicTrIrqStatus;     // IRQ Interrupt status
wire   [31:0] VicTrFiqStatus;     // FIQ Interrupt status
wire          nVicTrFiq;          // FIQ Interrupt to CPU
wire          nVicTrIrq;          // IRQ Interrupt to CPU
wire          VicTrIrqAckOut;     // ACKOUT signal to Daisy Chain Vic
wire          VicTrVectAddrv;     // Address valid signal 
wire   [31:0] VicTrVectAddr;      // Vector Address out line

// -----------------------------------------------------------------------------
//
//                             VicMirTrickbox
//                             ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This is the top level of Mirror Trickbox. It Instantiates the following
// modules
// a) VicTrIntReqLog  -- Interrupt Request Logic 
// b) VicTrFiqIntrLog -- Fiq Interrupt Logic
// c) VicTrIrqIntrLog -- IRQ Interrupt Logic
// d) VicTrIrqPriLog  -- IRQ Priority Logic
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          TrnIrq;        // IRQ Interrupts from VicTrIntReqLog Block 
wire   [31:0] TrIrqStatus;   // IRQStatus output
wire   [31:0] TrFiqStatus;   // IRQStatus output
wire          VectAddrVld;   // Address Valid Indicator
wire   [32:0] TrVectIrq;     // VectIRQ from IRQ Interrupt Logic
wire   [32:0] PPTable0;      // Priority Level 0
wire   [32:0] PPTable1;      // Priority Level 1
wire   [32:0] PPTable2;      // Priority Level 2
wire   [32:0] PPTable3;      // Priority Level 3
wire   [32:0] PPTable4;      // Priority Level 4
wire   [32:0] PPTable5;      // Priority Level 5
wire   [32:0] PPTable6;      // Priority Level 6
wire   [32:0] PPTable7;      // Priority Level 7
wire   [32:0] PPTable8;      // Priority Level 8
wire   [32:0] PPTable9;      // Priority Level 9
wire   [32:0] PPTable10;     // Priority Level 10
wire   [32:0] PPTable11;     // Priority Level 11
wire   [32:0] PPTable12;     // Priority Level 12
wire   [32:0] PPTable13;     // Priority Level 13
wire   [32:0] PPTable14;     // Priority Level 14
wire   [32:0] PPTable15;     // Priority Level 15
wire          nTrIrq;        // Irq Interrupt
wire   [15:0] MaskPrityReg;  // Mask updated value
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
// Interrupt Request Logic Block instantiation
// -----------------------------------------------------------------------------
VicTrIntReqLog uVicTrIntReqLog            (
                       .HCLK              (HCLK),            
                       .HRESETn           (HRESETn),
                       .VicTrIntSource    (VicTrIntSource),
                       .VicTrSoftInt      (VicTrSoftInt),
                       .VicTrIntEn        (VicTrIntEn),
                       .VicTrIntSelect    (VicTrIntSelect),
                       .nVicTrIrqIn       (nVicTrIrqIn),
                       .VicTrFiqStatus    (VicTrFiqStatus),
                       .VicTrIrqStatus    (VicTrIrqStatus),
                       .TrIrqStatus       (TrIrqStatus),
                       .TrnIrq            (TrnIrq),
                       .TrFiqStatus       (TrFiqStatus),
                       .VicTrRawIntr      (VicTrRawIntr)
                       );

// -----------------------------------------------------------------------------
// FIQ Interrupt Logic Block instantiation
// -----------------------------------------------------------------------------
VicTrFiqIntrLog uVicTrFiqIntrLog          (
                       .HCLK              (HCLK),
                       .HRESETn           (HRESETn),
                       .TrFiqStatus       (TrFiqStatus),
                       .nVicTrFiqIn       (nVicTrFiqIn),
                       .VicTrFiqInReg     (VicTrFiqInReg),
                       .nVicTrFiq         (nVicTrFiq)
                       );

// -----------------------------------------------------------------------------
//  VIC IRQ Interrupt Logic Block instantiation
// -----------------------------------------------------------------------------
VicTrIrqIntrLog uVicTrIrqIntrLog          (
                       .HCLK              (HCLK), 
                       .HRESETn           (HRESETn),
                       .nVicTrIrqIn       (nVicTrIrqIn),
                       .VicTrIrqInReg     (VicTrIrqInReg),
                       .IrqStatus         (TrIrqStatus),
                       .VectAddrVld       (VectAddrVld),
                       .nVicTrSyncEn      (nVicTrSyncEn),    
                       .VicTrSwPriMask    (VicTrSwPriMask),
                       .VicTrVectPriDsy   (VicTrVectPriDsy),
                       .VicTrVectPrity0   (VicTrVectPrity0),
                       .VicTrVectPrity1   (VicTrVectPrity1),
                       .VicTrVectPrity2   (VicTrVectPrity2),
                       .VicTrVectPrity3   (VicTrVectPrity3),
                       .VicTrVectPrity4   (VicTrVectPrity4),
                       .VicTrVectPrity5   (VicTrVectPrity5),
                       .VicTrVectPrity6   (VicTrVectPrity6),
                       .VicTrVectPrity7   (VicTrVectPrity7),
                       .VicTrVectPrity8   (VicTrVectPrity8),
                       .VicTrVectPrity9   (VicTrVectPrity9),
                       .VicTrVectPrity10  (VicTrVectPrity10),
                       .VicTrVectPrity11  (VicTrVectPrity11),
                       .VicTrVectPrity12  (VicTrVectPrity12),
                       .VicTrVectPrity13  (VicTrVectPrity13),
                       .VicTrVectPrity14  (VicTrVectPrity14),
                       .VicTrVectPrity15  (VicTrVectPrity15),
                       .VicTrVectPrity16  (VicTrVectPrity16),
                       .VicTrVectPrity17  (VicTrVectPrity17),
                       .VicTrVectPrity18  (VicTrVectPrity18),
                       .VicTrVectPrity19  (VicTrVectPrity19),
                       .VicTrVectPrity20  (VicTrVectPrity20),
                       .VicTrVectPrity21  (VicTrVectPrity21),
                       .VicTrVectPrity22  (VicTrVectPrity22),
                       .VicTrVectPrity23  (VicTrVectPrity23),
                       .VicTrVectPrity24  (VicTrVectPrity24),
                       .VicTrVectPrity25  (VicTrVectPrity25),
                       .VicTrVectPrity26  (VicTrVectPrity26),
                       .VicTrVectPrity27  (VicTrVectPrity27),
                       .VicTrVectPrity28  (VicTrVectPrity28),
                       .VicTrVectPrity29  (VicTrVectPrity29),
                       .VicTrVectPrity30  (VicTrVectPrity30),
                       .VicTrVectPrity31  (VicTrVectPrity31),
                       .MaskPrityReg      (MaskPrityReg),
                       .nTrIrq            (nTrIrq),
                       .TrVectIrq         (TrVectIrq),
                       .DaisyIrqOut       (DaisyIrqOut),
                       .PPTable0          (PPTable0),
                       .PPTable1          (PPTable1),
                       .PPTable2          (PPTable2),
                       .PPTable3          (PPTable3),
                       .PPTable4          (PPTable4),
                       .PPTable5          (PPTable5),
                       .PPTable6          (PPTable6),
                       .PPTable7          (PPTable7),
                       .PPTable8          (PPTable8),
                       .PPTable9          (PPTable9),
                       .PPTable10         (PPTable10),
                       .PPTable11         (PPTable11),
                       .PPTable12         (PPTable12),
                       .PPTable13         (PPTable13),
                       .PPTable14         (PPTable14),
                       .PPTable15         (PPTable15)
                      );

// -----------------------------------------------------------------------------
// VIC IRQ Priority Logic Block instantiation
// -----------------------------------------------------------------------------
VicTrIrqPriLog uVicTrIrqPriLog            (
                       .HCLK              (HCLK),
                       .HRESETn           (HRESETn),
                       .TrnIrq            (TrnIrq), 
                       .IrqStatus         (TrIrqStatus),
                       .DaisyIrqOut       (DaisyIrqOut),
                       .TrVectIrq         (TrVectIrq),
                       .nVicTrSyncEn      (nVicTrSyncEn),    
                       .PPTable0          (PPTable0),
                       .PPTable1          (PPTable1),
                       .PPTable2          (PPTable2),
                       .PPTable3          (PPTable3),
                       .PPTable4          (PPTable4),
                       .PPTable5          (PPTable5),
                       .PPTable6          (PPTable6),
                       .PPTable7          (PPTable7),
                       .PPTable8          (PPTable8),
                       .PPTable9          (PPTable9),
                       .PPTable10         (PPTable10),
                       .PPTable11         (PPTable11),
                       .PPTable12         (PPTable12),
                       .PPTable13         (PPTable13),
                       .PPTable14         (PPTable14),
                       .PPTable15         (PPTable15),
                       .VicTrVectAddr0    (VicTrVectAddr0),
                       .VicTrVectAddr1    (VicTrVectAddr1),
                       .VicTrVectAddr2    (VicTrVectAddr2),
                       .VicTrVectAddr3    (VicTrVectAddr3),
                       .VicTrVectAddr4    (VicTrVectAddr4),
                       .VicTrVectAddr5    (VicTrVectAddr5),
                       .VicTrVectAddr6    (VicTrVectAddr6),
                       .VicTrVectAddr7    (VicTrVectAddr7),
                       .VicTrVectAddr8    (VicTrVectAddr8),
                       .VicTrVectAddr9    (VicTrVectAddr9),
                       .VicTrVectAddr10   (VicTrVectAddr10),
                       .VicTrVectAddr11   (VicTrVectAddr11),
                       .VicTrVectAddr12   (VicTrVectAddr12),
                       .VicTrVectAddr13   (VicTrVectAddr13),
                       .VicTrVectAddr14   (VicTrVectAddr14),
                       .VicTrVectAddr15   (VicTrVectAddr15),
                       .VicTrVectAddr16   (VicTrVectAddr16),
                       .VicTrVectAddr17   (VicTrVectAddr17),
                       .VicTrVectAddr18   (VicTrVectAddr18),
                       .VicTrVectAddr19   (VicTrVectAddr19),
                       .VicTrVectAddr20   (VicTrVectAddr20),
                       .VicTrVectAddr21   (VicTrVectAddr21),
                       .VicTrVectAddr22   (VicTrVectAddr22),
                       .VicTrVectAddr23   (VicTrVectAddr23),
                       .VicTrVectAddr24   (VicTrVectAddr24),
                       .VicTrVectAddr25   (VicTrVectAddr25),
                       .VicTrVectAddr26   (VicTrVectAddr26),
                       .VicTrVectAddr27   (VicTrVectAddr27),
                       .VicTrVectAddr28   (VicTrVectAddr28),
                       .VicTrVectAddr29   (VicTrVectAddr29),
                       .VicTrVectAddr30   (VicTrVectAddr30),
                       .VicTrVectAddr31   (VicTrVectAddr31),
                       .VicTrVectAddrIn   (VicTrVectAddrIn),
                       .VicTrIrqAck       (VicTrIrqAck),
                       .VectAddrWrTrigIn  (VectAddrWrTrig),
                       .VectAddrRdTrigIn  (VectAddrRdTrig),
                       .AsyncRdEn         (AsyncRdEn),
                       .VicTrIrqOut       (VicTrIrqAckOut),
                       .nTrIrq            (nTrIrq),
                       .VectAddrVld       (VectAddrVld),
                       .MaskPrityReg      (MaskPrityReg),
                       .VicTrVectAddrv    (VicTrVectAddrv),
                       .VicTrVectAddr     (VicTrVectAddr)
                       );

// -----------------------------------------------------------------------------
// Inverted version of Irq Interrupt
// -----------------------------------------------------------------------------
assign nVicTrIrq = ~nTrIrq;

endmodule

// --=============================== End =====================================--
