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
// File Name              : VicInterrupt.v.rca
// File Revision          : 1.15
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of interrupt processing
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicInterrupt (
// Inputs
                     HCLK,
                     HRESETn,
                     VICINTSOURCE,
                     VICSoftInt,
                     nVICIRQIN,
                     nVICFIQIN,
                     VICFIQINREG,
                     VICIRQINREG,
                     VICIntEnable,
                     VICIntSelect,
                     SWPriorityMask,
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
                     CurrentPriority,
                     ITEN,
                     nIRQINForceVal,
                     nFIQINForceVal,
                     IRQForceVal,
                     FIQForceVal,

// Outputs
                     nIRQINTestVal,
                     nFIQINTestVal,
                     IRQTestVal,
                     FIQTestVal,
                     nVICFIQ,
                     nVICIRQ,
                     IRQRequestRes,
                     IRQPortRes,
                     IRQReqLevelRes,
                     VICRawIntr,
                     VICFIQStatus,
                     VICIRQStatus
                    );

// Inputs

input         HCLK;             // AHB Clock
input         HRESETn;          // AHB reset
input  [31:0] VICINTSOURCE;     // Interrupt source
input  [31:0] VICSoftInt;       // Software interrupt source
input         nVICIRQIN;        // Daisy chain IRQ input
input         nVICFIQIN;        // Daisy chain FIQ input
input         VICFIQINREG;      // Register enable signal for VICFIQIN
input         VICIRQINREG;      // Register enable signal for VICIRQIN
input  [31:0] VICIntEnable;     // Interrupt Enable
input  [31:0] VICIntSelect;     // Interrupt Type
input  [15:0] SWPriorityMask;   // Software priority level mask
input   [3:0] PLevel0;          // Priority settings for 0th interrupt source
input   [3:0] PLevel1;          // Priority settings for 1st interrupt source
input   [3:0] PLevel2;          // Priority settings for 2nd interrupt source
input   [3:0] PLevel3;          // Priority settings for 3rd interrupt source
input   [3:0] PLevel4;          // Priority settings for 4th interrupt source
input   [3:0] PLevel5;          // Priority settings for 5th interrupt source
input   [3:0] PLevel6;          // Priority settings for 6th interrupt source
input   [3:0] PLevel7;          // Priority settings for 7th interrupt source
input   [3:0] PLevel8;          // Priority settings for 8th interrupt source
input   [3:0] PLevel9;          // Priority settings for 9th interrupt source
input   [3:0] PLevel10;         // Priority settings for 10th interrupt source
input   [3:0] PLevel11;         // Priority settings for 11th interrupt source
input   [3:0] PLevel12;         // Priority settings for 12th interrupt source
input   [3:0] PLevel13;         // Priority settings for 13th interrupt source
input   [3:0] PLevel14;         // Priority settings for 14th interrupt source
input   [3:0] PLevel15;         // Priority settings for 15th interrupt source
input   [3:0] PLevel16;         // Priority settings for 16th interrupt source
input   [3:0] PLevel17;         // Priority settings for 17th interrupt source
input   [3:0] PLevel18;         // Priority settings for 18th interrupt source
input   [3:0] PLevel19;         // Priority settings for 19th interrupt source
input   [3:0] PLevel20;         // Priority settings for 20th interrupt source
input   [3:0] PLevel21;         // Priority settings for 21st interrupt source
input   [3:0] PLevel22;         // Priority settings for 22nd interrupt source
input   [3:0] PLevel23;         // Priority settings for 23rd interrupt source
input   [3:0] PLevel24;         // Priority settings for 24th interrupt source
input   [3:0] PLevel25;         // Priority settings for 25th interrupt source
input   [3:0] PLevel26;         // Priority settings for 26th interrupt source
input   [3:0] PLevel27;         // Priority settings for 27th interrupt source
input   [3:0] PLevel28;         // Priority settings for 28th interrupt source
input   [3:0] PLevel29;         // Priority settings for 29th interrupt source
input   [3:0] PLevel30;         // Priority settings for 30th interrupt source
input   [3:0] PLevel31;         // Priority settings for 31st interrupt source
input   [3:0] PLevel32;         // Priority settings for 32nd interrupt source
input  [15:0] CurrentPriority;  // Current Interrupt
// Test signal
input         ITEN;             // Integration test enable
input         nIRQINForceVal;   // nVICIRQIN i/p force value
input         nFIQINForceVal;   // nVICFIQIN i/p force value
input         IRQForceVal;      // VICIRQ o/p force value (non-invert)
input         FIQForceVal;      // VICFIQ o/p force value (non-invert)

// Outputs
// Test output
output        nIRQINTestVal;    // nVICIRQIN i/p read back value
output        nFIQINTestVal;    // nVICFIQIN i/p read back value
output        IRQTestVal;       // VICIRQ o/p read back value (non-invert)
output        FIQTestVal;       // VICFIQ o/p read back value (non-invert)
// Interrupt outputs
output        nVICFIQ;          // asynchronous FIQ output
output        nVICIRQ;          // asynchronous IRQ output
// To VicCpuif
output        IRQRequestRes;    // Resolved synchronised IRQ request
output  [5:0] IRQPortRes;       // Resolved IRQ source
                                // 0 to 31, VICINTSOURCE(0 to 31)
                                // 32, Daisy chain input

output [3:0]  IRQReqLevelRes;   // Resolved priority level of current
                                // IRQ request

// Status (asynchronous) to AHBif
output [31:0] VICRawIntr;       // Status of the interrupts before masking
output [31:0] VICFIQStatus;     // Status of the FIQ after disabling
                                // the interrupt
output [31:0] VICIRQStatus;     // Status of the FIQ after disabling
                                // the interrupt

// Inputs
wire          HCLK;             // AHB clock
wire          HRESETn;          // System reset
wire   [31:0] VICINTSOURCE;     // Interrupt source
wire   [31:0] VICSoftInt;       // Software interrupt source
wire          nVICIRQIN;        // Daisy IRQ chain input
wire          nVICFIQIN;        // Daisy FIQ chain input
wire          VICFIQINREG;      // Register enable signal for VICFIQIN
wire          VICIRQINREG;      // Register enable signal for VICIRQIN
wire   [31:0] VICIntEnable;     // Interrupt Enable
wire   [31:0] VICIntSelect;     // Interrupt Type
wire   [15:0] SWPriorityMask;   // Software priority level mask
wire    [3:0] PLevel0;          // Priority settings for 0th interrupt source
wire    [3:0] PLevel1;          // Priority settings for 1st interrupt source
wire    [3:0] PLevel2;          // Priority settings for 2nd interrupt source
wire    [3:0] PLevel3;          // Priority settings for 3rd interrupt source
wire    [3:0] PLevel4;          // Priority settings for 4th interrupt source
wire    [3:0] PLevel5;          // Priority settings for 5th interrupt source
wire    [3:0] PLevel6;          // Priority settings for 6th interrupt source
wire    [3:0] PLevel7;          // Priority settings for 7th interrupt source
wire    [3:0] PLevel8;          // Priority settings for 8th interrupt source
wire    [3:0] PLevel9;          // Priority settings for 9th interrupt source
wire    [3:0] PLevel10;         // Priority settings for 10th interrupt source
wire    [3:0] PLevel11;         // Priority settings for 11th interrupt source
wire    [3:0] PLevel12;         // Priority settings for 12th interrupt source
wire    [3:0] PLevel13;         // Priority settings for 13th interrupt source
wire    [3:0] PLevel14;         // Priority settings for 14th interrupt source
wire    [3:0] PLevel15;         // Priority settings for 15th interrupt source
wire    [3:0] PLevel16;         // Priority settings for 16th interrupt source
wire    [3:0] PLevel17;         // Priority settings for 17th interrupt source
wire    [3:0] PLevel18;         // Priority settings for 18th interrupt source
wire    [3:0] PLevel19;         // Priority settings for 19th interrupt source
wire    [3:0] PLevel20;         // Priority settings for 20th interrupt source
wire    [3:0] PLevel21;         // Priority settings for 21st interrupt source
wire    [3:0] PLevel22;         // Priority settings for 22nd interrupt source
wire    [3:0] PLevel23;         // Priority settings for 23rd interrupt source
wire    [3:0] PLevel24;         // Priority settings for 24th interrupt source
wire    [3:0] PLevel25;         // Priority settings for 25th interrupt source
wire    [3:0] PLevel26;         // Priority settings for 26th interrupt source
wire    [3:0] PLevel27;         // Priority settings for 27th interrupt source
wire    [3:0] PLevel28;         // Priority settings for 28th interrupt source
wire    [3:0] PLevel29;         // Priority settings for 29th interrupt source
wire    [3:0] PLevel30;         // Priority settings for 30th interrupt source
wire    [3:0] PLevel31;         // Priority settings for 31st interrupt source
wire    [3:0] PLevel32;         // Priority settings for the daisy chain input
wire   [15:0] CurrentPriority;  // Current Interrupt priority
wire          ITEN;             // Integration test enable
wire          nIRQINForceVal;   // nVICIRQIN i/p force value
wire          nFIQINForceVal;   // nVICFIQIN i/p force value
wire          IRQForceVal;      // VICIRQ o/p force value (non-invert)
wire          FIQForceVal;      // VICFIQ o/p force value (non-invert)

// Outputs
wire          nIRQINTestVal;    // nVICIRQIN i/p read back value
wire          nFIQINTestVal;    // nVICFIQIN i/p read back value
wire          IRQTestVal;       // VICIRQ o/p read back (non-invert)
wire          FIQTestVal;       // VICFIQ o/p read back (non-invert)
wire          nVICFIQ;          // asynchronous FIQ output
wire          nVICIRQ;          // asynchronous IRQ output
wire   [31:0] VICRawIntr;       // Status of the interrupts before masking
wire   [31:0] VICFIQStatus;     // Status of the FIQ after disabling
                                // the interrupt
wire   [31:0] VICIRQStatus;     // Status of the IRQ after disabling
                                // the interrupt

wire           IRQRequestRes;   // Resolved synchronised IRQ request
wire     [5:0] IRQPortRes;      // Resolved IRQ source number
wire     [3:0] IRQReqLevelRes;  // Resolved priority level of the interrupt

// -----------------------------------------------------------------------------
//
//                             VicInterrupt
//                             ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// In this block, VicPriority module and VicIntResolver module are instantiated.
// There are sixteen instantiations of VicPriority module. Each instantiation
// corresponds to one priority level. If there is more than one interrupt with
// same priority level then interrupts are resolved according to the hardware
// priority. VicIntResolver resolves the interrupts according to the priority of
// the interrupt programmed.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          DaisyChainIn;     // DaisyChain input after mux with test signal
wire   [15:0] IrqAsync;         // asynchronous IRQ
wire   [15:0] IrqSync;          // synchronous IRQ
wire    [5:0] Port0;            // Priority level of port0
wire    [5:0] Port1;            // Priority level of port1
wire    [5:0] Port2;            // Priority level of port2
wire    [5:0] Port3;            // Priority level of port3
wire    [5:0] Port4;            // Priority level of port4
wire    [5:0] Port5;            // Priority level of port5
wire    [5:0] Port6;            // Priority level of port6
wire    [5:0] Port7;            // Priority level of port7
wire    [5:0] Port8;            // Priority level of port8
wire    [5:0] Port9;            // Priority level of port9
wire    [5:0] Port10;           // Priority level of port10
wire    [5:0] Port11;           // Priority level of port11
wire    [5:0] Port12;           // Priority level of port12
wire    [5:0] Port13;           // Priority level of port13
wire    [5:0] Port14;           // Priority level of port14
wire    [5:0] Port15;           // Priority level of port15
wire          Sync2DaisyIn;     // 2nd flip-flop for synchronisation of
                                // DaisyChainIn
wire   [15:0] CurrentLevelMask; // Mask due to current interrupt priority
                                // level
wire   [31:0] Sync2IrqStatus;   // Second flip-flop stage
wire   [31:0] iVICIRQStatus;    // Internal version of VICIRQStatus

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
// Priority Encoding for level 0
// -----------------------------------------------------------------------------
VicPriority u0VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[0]),
        .CurrentLevelMask (CurrentLevelMask[0]),
// Priority levels
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG0),

// Outputs
        .IrqOutput        (IrqAsync[0]),
        .SyncIrqOutput    (IrqSync[0]),
        .IRQPort          (Port0)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 1
// -----------------------------------------------------------------------------
VicPriority u1VicPriority (
//Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[1]),
        .CurrentLevelMask (CurrentLevelMask[1]),
// Priority levels
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG1),

// Outputs
        .IrqOutput        (IrqAsync[1]),
        .SyncIrqOutput    (IrqSync[1]),
        .IRQPort          (Port1)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 2
// -----------------------------------------------------------------------------
VicPriority u2VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[2]),
        .CurrentLevelMask (CurrentLevelMask[2]),
// Priority levels
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG2),

// Outputs
        .IrqOutput        (IrqAsync[2]),
        .SyncIrqOutput    (IrqSync[2]),
        .IRQPort          (Port2)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 3
// -----------------------------------------------------------------------------
VicPriority u3VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[3]),
        .CurrentLevelMask (CurrentLevelMask[3]),
// Priority levels
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG3),

// Outputs
        .IrqOutput        (IrqAsync[3]),
        .SyncIrqOutput    (IrqSync[3]),
        .IRQPort          (Port3)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 4
// -----------------------------------------------------------------------------
VicPriority u4VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[4]),
        .CurrentLevelMask (CurrentLevelMask[4]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG4),

// Outputs
        .IrqOutput        (IrqAsync[4]),
        .SyncIrqOutput    (IrqSync[4]),
        .IRQPort          (Port4)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 5
// -----------------------------------------------------------------------------
VicPriority u5VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[5]),
        .CurrentLevelMask (CurrentLevelMask[5]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG5),

// Outputs
        .IrqOutput        (IrqAsync[5]),
        .SyncIrqOutput    (IrqSync[5]),
        .IRQPort          (Port5)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 6
// -----------------------------------------------------------------------------
VicPriority u6VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[6]),
        .CurrentLevelMask (CurrentLevelMask[6]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG6),

// Outputs
        .IrqOutput        (IrqAsync[6]),
        .SyncIrqOutput    (IrqSync[6]),
        .IRQPort          (Port6)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 7
// -----------------------------------------------------------------------------
VicPriority u7VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[7]),
        .CurrentLevelMask (CurrentLevelMask[7]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG7),

// Outputs
        .IrqOutput        (IrqAsync[7]),
        .SyncIrqOutput    (IrqSync[7]),
        .IRQPort          (Port7)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 8
// -----------------------------------------------------------------------------
VicPriority u8VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[8]),
        .CurrentLevelMask (CurrentLevelMask[8]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG8),

// Outputs
        .IrqOutput        (IrqAsync[8]),
        .SyncIrqOutput    (IrqSync[8]),
        .IRQPort          (Port8)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 9
// -----------------------------------------------------------------------------
VicPriority u9VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[9]),
        .CurrentLevelMask (CurrentLevelMask[9]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG9),

// Outputs
        .IrqOutput        (IrqAsync[9]),
        .SyncIrqOutput    (IrqSync[9]),
        .IRQPort          (Port9)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 10
// -----------------------------------------------------------------------------
VicPriority u10VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[10]),
        .CurrentLevelMask (CurrentLevelMask[10]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG10),

// Outputs
        .IrqOutput        (IrqAsync[10]),
        .SyncIrqOutput    (IrqSync[10]),
        .IRQPort          (Port10)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 11
// -----------------------------------------------------------------------------
VicPriority u11VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[11]),
        .CurrentLevelMask (CurrentLevelMask[11]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG11),

// Outputs
        .IrqOutput        (IrqAsync[11]),
        .SyncIrqOutput    (IrqSync[11]),
        .IRQPort          (Port11)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 12
// -----------------------------------------------------------------------------
VicPriority u12VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[12]),
        .CurrentLevelMask (CurrentLevelMask[12]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG12),

// Outputs
        .IrqOutput        (IrqAsync[12]),
        .SyncIrqOutput    (IrqSync[12]),
        .IRQPort          (Port12)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 13
// -----------------------------------------------------------------------------
VicPriority u13VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[13]),
        .CurrentLevelMask (CurrentLevelMask[13]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG13),

// Outputs
        .IrqOutput        (IrqAsync[13]),
        .SyncIrqOutput    (IrqSync[13]),
        .IRQPort          (Port13)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 14
// -----------------------------------------------------------------------------
VicPriority u14VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[14]),
        .CurrentLevelMask (CurrentLevelMask[14]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG14),

// Outputs
        .IrqOutput        (IrqAsync[14]),
        .SyncIrqOutput    (IrqSync[14]),
        .IRQPort          (Port14)
       );

// -----------------------------------------------------------------------------
// Priority Encoding for level 15
// -----------------------------------------------------------------------------
VicPriority u15VicPriority (
// Inputs

// Interrupt signals
        .IRQStatusIn      (iVICIRQStatus),
        .DaisyChainIn     (DaisyChainIn),
        .SyncIRQStatusIn  (Sync2IrqStatus),
        .SyncDaisyChainIn (Sync2DaisyIn),
        .SWPriorityMask   (SWPriorityMask[15]),
        .CurrentLevelMask (CurrentLevelMask[15]),
        .PLevel0          (PLevel0),
        .PLevel1          (PLevel1),
        .PLevel2          (PLevel2),
        .PLevel3          (PLevel3),
        .PLevel4          (PLevel4),
        .PLevel5          (PLevel5),
        .PLevel6          (PLevel6),
        .PLevel7          (PLevel7),
        .PLevel8          (PLevel8),
        .PLevel9          (PLevel9),
        .PLevel10         (PLevel10),
        .PLevel11         (PLevel11),
        .PLevel12         (PLevel12),
        .PLevel13         (PLevel13),
        .PLevel14         (PLevel14),
        .PLevel15         (PLevel15),
        .PLevel16         (PLevel16),
        .PLevel17         (PLevel17),
        .PLevel18         (PLevel18),
        .PLevel19         (PLevel19),
        .PLevel20         (PLevel20),
        .PLevel21         (PLevel21),
        .PLevel22         (PLevel22),
        .PLevel23         (PLevel23),
        .PLevel24         (PLevel24),
        .PLevel25         (PLevel25),
        .PLevel26         (PLevel26),
        .PLevel27         (PLevel27),
        .PLevel28         (PLevel28),
        .PLevel29         (PLevel29),
        .PLevel30         (PLevel30),
        .PLevel31         (PLevel31),
        .PLevel32         (PLevel32),
        .PriorityLevelCfg (`CFG15),

// Outputs
        .IrqOutput        (IrqAsync[15]),
        .SyncIrqOutput    (IrqSync[15]),
        .IRQPort          (Port15)
       );

// -----------------------------------------------------------------------------
// Instantiation of VicIntResolver
// -----------------------------------------------------------------------------
VicIntResolver uVicIntResolver (
// Inputs

// AHB signals
        .HCLK             (HCLK),
        .HRESETn          (HRESETn),
// Interrupt signals
        .IrqSync          (IrqSync),
        .Port0            (Port0),
        .Port1            (Port1),
        .Port2            (Port2),
        .Port3            (Port3),
        .Port4            (Port4),
        .Port5            (Port5),
        .Port6            (Port6),
        .Port7            (Port7),
        .Port8            (Port8),
        .Port9            (Port9),
        .Port10           (Port10),
        .Port11           (Port11),
        .Port12           (Port12),
        .Port13           (Port13),
        .Port14           (Port14),
        .Port15           (Port15),
        .ITEN             (ITEN),
        .IrqAsync         (IrqAsync),
        .IRQForceVal      (IRQForceVal),
        .CurrentPriority  (CurrentPriority),
        .nIRQINForceVal   (nIRQINForceVal),
        .nFIQINForceVal   (nFIQINForceVal),
        .FIQForceVal      (FIQForceVal),
        .nVICIRQIN        (nVICIRQIN),
        .VICIRQINREG      (VICIRQINREG),
        .nVICFIQIN        (nVICFIQIN),
        .VICFIQINREG      (VICFIQINREG),
        .VICINTSOURCE     (VICINTSOURCE),
        .VICSoftInt       (VICSoftInt),
        .VICIntEnable     (VICIntEnable),
        .VICIntSelect     (VICIntSelect),

// Outputs
        .FIQTestVal       (FIQTestVal),
        .nFIQINTestVal    (nFIQINTestVal),
        .nIRQINTestVal    (nIRQINTestVal),
        .nVICIRQ          (nVICIRQ),
        .nVICFIQ          (nVICFIQ),
        .IRQPortRes       (IRQPortRes),
        .IRQRequestRes    (IRQRequestRes),
        .IRQReqLevelRes   (IRQReqLevelRes),
        .IRQTestVal       (IRQTestVal),
        .DaisyChainIn     (DaisyChainIn),
        .CurrentLevelMask (CurrentLevelMask),
        .Sync2DaisyIn     (Sync2DaisyIn),
        .Sync2IrqStatus   (Sync2IrqStatus),
        .VICRawIntr       (VICRawIntr),
        .VICIRQStatus     (iVICIRQStatus),
        .VICFIQStatus     (VICFIQStatus)
       );

// -----------------------------------------------------------------------------
// Connect to the top level
// -----------------------------------------------------------------------------
assign VICIRQStatus = iVICIRQStatus;

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
