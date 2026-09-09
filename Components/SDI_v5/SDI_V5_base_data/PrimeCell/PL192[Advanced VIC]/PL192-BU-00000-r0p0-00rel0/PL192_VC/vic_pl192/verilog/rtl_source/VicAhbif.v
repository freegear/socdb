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
// File Name              : VicAhbif.v.rca
// File Revision          : 1.19
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module provides the AHB system bus interface to the VIC.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicAhbif (
// Inputs
                 HCLK,
                 HRESETn,
                 HSELVIC,
                 HADDR,
                 HTRANS1,
                 HWRITE,
                 HREADYIN,
                 HPROT1,
                 HSIZE,
                 HWDATA,
                 Revision,
                 VICFIQStatus,
                 VICIRQStatus,
                 VICRawIntr,
                 VICINTSOURCE,
                 VICVectAddrVal,
                 IRQACKTestVal,
                 nIRQINTestVal,
                 nFIQINTestVal,
                 VADDRINTestVal,
                 VADDRVTestVal,
                 IRQTestVal,
                 FIQTestVal,
                 ACKOUTTestVal,
                 VADDRTestVal,
                 VICFIQINREG,
                 VICIRQINREG,

// Outputs
                 HRESP,
                 HREADYOUT,
                 HRDATA,
                 VICSoftInt,
                 VICIntEnable,
                 VICIntSelect,
                 SWPriorityMask,
                 VectAddr0,
                 VectAddr1,
                 VectAddr2,
                 VectAddr3,
                 VectAddr4,
                 VectAddr5,
                 VectAddr6,
                 VectAddr7,
                 VectAddr8,
                 VectAddr9,
                 VectAddr10,
                 VectAddr11,
                 VectAddr12,
                 VectAddr13,
                 VectAddr14,
                 VectAddr15,
                 VectAddr16,
                 VectAddr17,
                 VectAddr18,
                 VectAddr19,
                 VectAddr20,
                 VectAddr21,
                 VectAddr22,
                 VectAddr23,
                 VectAddr24,
                 VectAddr25,
                 VectAddr26,
                 VectAddr27,
                 VectAddr28,
                 VectAddr29,
                 VectAddr30,
                 VectAddr31,
                 VectPriority0,
                 VectPriority1,
                 VectPriority2,
                 VectPriority3,
                 VectPriority4,
                 VectPriority5,
                 VectPriority6,
                 VectPriority7,
                 VectPriority8,
                 VectPriority9,
                 VectPriority10,
                 VectPriority11,
                 VectPriority12,
                 VectPriority13,
                 VectPriority14,
                 VectPriority15,
                 VectPriority16,
                 VectPriority17,
                 VectPriority18,
                 VectPriority19,
                 VectPriority20,
                 VectPriority21,
                 VectPriority22,
                 VectPriority23,
                 VectPriority24,
                 VectPriority25,
                 VectPriority26,
                 VectPriority27,
                 VectPriority28,
                 VectPriority29,
                 VectPriority30,
                 VectPriority31,
                 VectPriority32,
                 IRQSWAck,
                 IRQSWClear,
                 ITEN,
                 IRQACKForceVal,
                 nIRQINForceVal,
                 nFIQINForceVal,
                 VECTADDRINFrcVal,
                 VECTADDRVFrcVal,
                 IRQForceVal,
                 FIQForceVal,
                 IRQACKOUTFrcVal,
                 VECTADDRFrcVal
                );

// Inputs

// AHB signals
input         HCLK;            // AHB Clock
input         HRESETn;         // AHB Reset
input         HSELVIC;         // VIC select
input  [11:2] HADDR;           // AHB address bus
input         HTRANS1;         // 1st bit of AHB transfer type
input         HWRITE;          // AHB Write
input         HREADYIN;        // Shared HREADY line
input         HPROT1;          // 1st bit of AHB protection mode
input   [2:0] HSIZE;           // AHB transfer size
input  [31:0] HWDATA;          // AHB write data bus
input   [3:0] Revision;        // Revision number of VIC

// Interrupt related signals
input  [31:0] VICFIQStatus;    // Status of the FIQ after disabling
                               // the interrupt
input  [31:0] VICIRQStatus;    // Status of the IRQ after disabling
                               // the interrupt
input  [31:0] VICRawIntr;      // Status of the interrupts before masking
input  [31:0] VICINTSOURCE;    // Peripheral interrupt source input
input  [31:0] VICVectAddrVal;  // Vector address from VicCpuif for read by
                               // software
// Test interface inputs
input         IRQACKTestVal;   // Integration test value of VICIRQACK
input         nIRQINTestVal;   // Integration test value of nVICIRQIN
input         nFIQINTestVal;   // Integration test value of nVICFIQIN
input  [31:0] VADDRINTestVal;  // Integration test value of VICVECTADDRIN
input         VADDRVTestVal;   // Integration test value of VICVECTADDRV
input         IRQTestVal;      // Integration test value of VICIRQ
input         FIQTestVal;      // Integration test value of VICFIQ
input         ACKOUTTestVal;   // Integration test value of VICIRQACKOUT
input  [31:0] VADDRTestVal;    // Integration test value of VICVECTADDR

// Daisy chain input register configuration for read back in test register
input         VICFIQINREG;     // Register enable signal for VICFIQIN
input         VICIRQINREG;     // Register enable signal for VICIRQIN

// Outputs
// AHB signals
output  [1:0] HRESP;           // Slave response
output        HREADYOUT;       // Slave ready output
output [31:0] HRDATA;          // Read Data

// Interrupt controls
output [31:0] VICSoftInt;      // Software interrupt
output [31:0] VICIntEnable;    // Interrupt enable
output [31:0] VICIntSelect;    // Interrupt type
output [15:0] SWPriorityMask;  // Software mask
output [31:0] VectAddr0;       // Vector address for 0th interrupt source
output [31:0] VectAddr1;       // Vector address for 1st interrupt source
output [31:0] VectAddr2;       // Vector address for 2nd interrupt source
output [31:0] VectAddr3;       // Vector address for 3rd interrupt source
output [31:0] VectAddr4;       // Vector address for 4th interrupt source
output [31:0] VectAddr5;       // Vector address for 5th interrupt source
output [31:0] VectAddr6;       // Vector address for 6th interrupt source
output [31:0] VectAddr7;       // Vector address for 7th interrupt source
output [31:0] VectAddr8;       // Vector address for 8th interrupt source
output [31:0] VectAddr9;       // Vector address for 9th interrupt source
output [31:0] VectAddr10;      // Vector address for 10th interrupt source
output [31:0] VectAddr11;      // Vector address for 11th interrupt source
output [31:0] VectAddr12;      // Vector address for 12th interrupt source
output [31:0] VectAddr13;      // Vector address for 13th interrupt source
output [31:0] VectAddr14;      // Vector address for 14th interrupt source
output [31:0] VectAddr15;      // Vector address for 15th interrupt source
output [31:0] VectAddr16;      // Vector address for 16th interrupt source
output [31:0] VectAddr17;      // Vector address for 17th interrupt source
output [31:0] VectAddr18;      // Vector address for 18th interrupt source
output [31:0] VectAddr19;      // Vector address for 19th interrupt source
output [31:0] VectAddr20;      // Vector address for 20th interrupt source
output [31:0] VectAddr21;      // Vector address for 21st interrupt source
output [31:0] VectAddr22;      // Vector address for 22nd interrupt source
output [31:0] VectAddr23;      // Vector address for 23rd interrupt source
output [31:0] VectAddr24;      // Vector address for 24th interrupt source
output [31:0] VectAddr25;      // Vector address for 25th interrupt source
output [31:0] VectAddr26;      // Vector address for 26th interrupt source
output [31:0] VectAddr27;      // Vector address for 27th interrupt source
output [31:0] VectAddr28;      // Vector address for 28th interrupt source
output [31:0] VectAddr29;      // Vector address for 29th interrupt source
output [31:0] VectAddr30;      // Vector address for 30th interrupt source
output [31:0] VectAddr31;      // Vector address for 31st interrupt source
output  [3:0] VectPriority0;   // Vector priority for 0th interrupt source
output  [3:0] VectPriority1;   // Vector priority for 1st interrupt source
output  [3:0] VectPriority2;   // Vector priority for 2nd interrupt source
output  [3:0] VectPriority3;   // Vector priority for 3rd interrupt source
output  [3:0] VectPriority4;   // Vector priority for 4th interrupt source
output  [3:0] VectPriority5;   // Vector priority for 5th interrupt source
output  [3:0] VectPriority6;   // Vector priority for 6th interrupt source
output  [3:0] VectPriority7;   // Vector priority for 7th interrupt source
output  [3:0] VectPriority8;   // Vector priority for 8th interrupt source
output  [3:0] VectPriority9;   // Vector priority for 9th interrupt source
output  [3:0] VectPriority10;  // Vector priority for 10th interrupt source
output  [3:0] VectPriority11;  // Vector priority for 11th interrupt source
output  [3:0] VectPriority12;  // Vector priority for 12th interrupt source
output  [3:0] VectPriority13;  // Vector priority for 13th interrupt source
output  [3:0] VectPriority14;  // Vector priority for 14th interrupt source
output  [3:0] VectPriority15;  // Vector priority for 15th interrupt source
output  [3:0] VectPriority16;  // Vector priority for 16th interrupt source
output  [3:0] VectPriority17;  // Vector priority for 17th interrupt source
output  [3:0] VectPriority18;  // Vector priority for 18th interrupt source
output  [3:0] VectPriority19;  // Vector priority for 19th interrupt source
output  [3:0] VectPriority20;  // Vector priority for 20th interrupt source
output  [3:0] VectPriority21;  // Vector priority for 21st interrupt source
output  [3:0] VectPriority22;  // Vector priority for 22nd interrupt source
output  [3:0] VectPriority23;  // Vector priority for 23rd interrupt source
output  [3:0] VectPriority24;  // Vector priority for 24th interrupt source
output  [3:0] VectPriority25;  // Vector priority for 25th interrupt source
output  [3:0] VectPriority26;  // Vector priority for 26th interrupt source
output  [3:0] VectPriority27;  // Vector priority for 27th interrupt source
output  [3:0] VectPriority28;  // Vector priority for 28th interrupt source
output  [3:0] VectPriority29;  // Vector priority for 29th interrupt source
output  [3:0] VectPriority30;  // Vector priority for 30th interrupt source
output  [3:0] VectPriority31;  // Vector priority for 31st interrupt source
output  [3:0] VectPriority32;  // Vector priority for daisy chain interrupt

// VIC priority stack controls
output        IRQSWAck;        // Software IRQ acknowledge
output        IRQSWClear;      // Software IRQ clear

// Integration Test interface
output        ITEN;            // Integration test enable
output        IRQACKForceVal;  // Force value for VICIRQACK
output        nIRQINForceVal;  // Force value for nVICIRQIN
output        nFIQINForceVal;  // Force value for nVICFIQIN
output [31:0] VECTADDRINFrcVal;// Force value for VICVECTADDRIN
output        VECTADDRVFrcVal; // Force value for VICVECTADDRV
output        IRQForceVal;     // Force value for VICIRQ (non-invert)
output        FIQForceVal;     // Force value for VICFIQ (non-invert)
output        IRQACKOUTFrcVal; // Force value for IRQACKOUT
output [31:0] VECTADDRFrcVal;  // Force value for VICVECTADDR

// Inputs
wire          HCLK;            // AHB Clock
wire          HRESETn;         // AHB Reset
wire          HSELVIC;         // VIC select
wire   [11:2] HADDR;           // AHB address bus
wire          HTRANS1;         // 1st bit of AHB transfer type
wire          HWRITE;          // AHB Write
wire          HREADYIN;        // Shared HREADY line
wire          HPROT1;          // 1st bit of AHB protection mode
wire    [2:0] HSIZE;           // AHB transfer size
wire   [31:0] HWDATA;          // AHB write data bus
wire    [1:0] HRESP;           // AHB Response
wire          HREADYOUT;       // Slave ready output
wire   [31:0] HRDATA;          // Read data output
wire    [3:0] Revision;        // Revision number of VIC
wire   [31:0] VICFIQStatus;    // Status of the FIQ after disabling
                               // the interrupt
wire   [31:0] VICIRQStatus;    // Status of the IRQ after disabling
                               // the interrupt
wire   [31:0] VICRawIntr;      // Status of the interrupts before masking
wire   [31:0] VICINTSOURCE;    // Peripheral interrupt source input
wire   [31:0] VICVectAddrVal;  // Vector address from VicCpuif for read by
                               // software
wire          IRQACKTestVal;   // Integration test value of VICIRQACK
wire          nIRQINTestVal;   // Integration test value of nVICIRQIN
wire          nFIQINTestVal;   // Integration test value of nVICFIQIN
wire   [31:0] VADDRINTestVal;  // Integration test value of VICVECTADDRIN
wire          VADDRVTestVal;   // Integration test value of VICVECTADDRV
wire          IRQTestVal;      // Integration test value of VICIRQ
wire          FIQTestVal;      // Integration test value of VICFIQ
wire          ACKOUTTestVal;   // Integration test value of VICIRQACKOUT
wire   [31:0] VADDRTestVal;    // Integration test value of VICVECTADDR
wire          VICFIQINREG;     // Register enable signal for VICFIQIN
wire          VICIRQINREG;     // Register enable signal for VICIRQIN
wire   [31:0] VICSoftInt;      // Software interrupt
wire   [31:0] VICIntEnable;    // Interrupt enable
wire   [31:0] VICIntSelect;    // Interrupt type
wire   [15:0] SWPriorityMask;  // Software mask

wire   [31:0] VectAddr0;       // Vector address for 0th interrupt source
wire   [31:0] VectAddr1;       // Vector address for 1st interrupt source
wire   [31:0] VectAddr2;       // Vector address for 2nd interrupt source
wire   [31:0] VectAddr3;       // Vector address for 3rd interrupt source
wire   [31:0] VectAddr4;       // Vector address for 4th interrupt source
wire   [31:0] VectAddr5;       // Vector address for 5th interrupt source
wire   [31:0] VectAddr6;       // Vector address for 6th interrupt source
wire   [31:0] VectAddr7;       // Vector address for 7th interrupt source
wire   [31:0] VectAddr8;       // Vector address for 8th interrupt source
wire   [31:0] VectAddr9;       // Vector address for 9th interrupt source
wire   [31:0] VectAddr10;      // Vector address for 10th interrupt source
wire   [31:0] VectAddr11;      // Vector address for 11th interrupt source
wire   [31:0] VectAddr12;      // Vector address for 12th interrupt source
wire   [31:0] VectAddr13;      // Vector address for 13th interrupt source
wire   [31:0] VectAddr14;      // Vector address for 14th interrupt source
wire   [31:0] VectAddr15;      // Vector address for 15th interrupt source
wire   [31:0] VectAddr16;      // Vector address for 16th interrupt source
wire   [31:0] VectAddr17;      // Vector address for 17th interrupt source
wire   [31:0] VectAddr18;      // Vector address for 18th interrupt source
wire   [31:0] VectAddr19;      // Vector address for 19th interrupt source
wire   [31:0] VectAddr20;      // Vector address for 20th interrupt source
wire   [31:0] VectAddr21;      // Vector address for 21st interrupt source
wire   [31:0] VectAddr22;      // Vector address for 22nd interrupt source
wire   [31:0] VectAddr23;      // Vector address for 23rd interrupt source
wire   [31:0] VectAddr24;      // Vector address for 24th interrupt source
wire   [31:0] VectAddr25;      // Vector address for 25th interrupt source
wire   [31:0] VectAddr26;      // Vector address for 26th interrupt source
wire   [31:0] VectAddr27;      // Vector address for 27th interrupt source
wire   [31:0] VectAddr28;      // Vector address for 28th interrupt source
wire   [31:0] VectAddr29;      // Vector address for 29th interrupt source
wire   [31:0] VectAddr30;      // Vector address for 30th interrupt source
wire   [31:0] VectAddr31;      // Vector address for 31st interrupt source
wire    [3:0] VectPriority0;   // Vector priority for 0th interrupt source
wire    [3:0] VectPriority1;   // Vector priority for 1st interrupt source
wire    [3:0] VectPriority2;   // Vector priority for 2nd interrupt source
wire    [3:0] VectPriority3;   // Vector priority for 3rd interrupt source
wire    [3:0] VectPriority4;   // Vector priority for 4th interrupt source
wire    [3:0] VectPriority5;   // Vector priority for 5th interrupt source
wire    [3:0] VectPriority6;   // Vector priority for 6th interrupt source
wire    [3:0] VectPriority7;   // Vector priority for 7th interrupt source
wire    [3:0] VectPriority8;   // Vector priority for 8th interrupt source
wire    [3:0] VectPriority9;   // Vector priority for 9th interrupt source
wire    [3:0] VectPriority10;  // Vector priority for 10th interrupt source
wire    [3:0] VectPriority11;  // Vector priority for 11th interrupt source
wire    [3:0] VectPriority12;  // Vector priority for 12th interrupt source
wire    [3:0] VectPriority13;  // Vector priority for 13th interrupt source
wire    [3:0] VectPriority14;  // Vector priority for 14th interrupt source
wire    [3:0] VectPriority15;  // Vector priority for 15th interrupt source
wire    [3:0] VectPriority16;  // Vector priority for 16th interrupt source
wire    [3:0] VectPriority17;  // Vector priority for 17th interrupt source
wire    [3:0] VectPriority18;  // Vector priority for 18th interrupt source
wire    [3:0] VectPriority19;  // Vector priority for 19th interrupt source
wire    [3:0] VectPriority20;  // Vector priority for 20th interrupt source
wire    [3:0] VectPriority21;  // Vector priority for 21st interrupt source
wire    [3:0] VectPriority22;  // Vector priority for 22nd interrupt source
wire    [3:0] VectPriority23;  // Vector priority for 23rd interrupt source
wire    [3:0] VectPriority24;  // Vector priority for 24th interrupt source
wire    [3:0] VectPriority25;  // Vector priority for 25th interrupt source
wire    [3:0] VectPriority26;  // Vector priority for 26th interrupt source
wire    [3:0] VectPriority27;  // Vector priority for 27th interrupt source
wire    [3:0] VectPriority28;  // Vector priority for 28th interrupt source
wire    [3:0] VectPriority29;  // Vector priority for 29th interrupt source
wire    [3:0] VectPriority30;  // Vector priority for 30th interrupt source
wire    [3:0] VectPriority31;  // Vector priority for 31st interrupt source
wire    [3:0] VectPriority32;  // Vector priority for daisy chain interrupt
wire          IRQSWAck;        // Software IRQ acknowledge.
wire          IRQSWClear;      // Software IRQ clear
wire          ITEN;            // Integration test enable
wire          IRQACKForceVal;  // Force value for VICIRQACK
wire          nIRQINForceVal;  // Force value for nVICIRQIN
wire          nFIQINForceVal;  // Force value for nVICFIQIN
wire   [31:0] VECTADDRINFrcVal;// Force value VECTADDRIN
wire          VECTADDRVFrcVal; // Force value for VICVECTADDRV
wire          IRQForceVal;     // Force value for VICIRQ (non-invert)
wire          FIQForceVal;     // Force value for VICFIQ (non-invert)
wire          IRQACKOUTFrcVal; // Force value for IRQACKOUT
wire   [31:0] VECTADDRFrcVal;  // Force value for VECATADDR

// -----------------------------------------------------------------------------
//
//                              VicAhbif
//                              ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module has the following functionality,
//
// - AHB Slave response generation : HRESP and HREADYOUT.
// The module returns the error response when the registers of the VIC are
// accessed with HSIZE other than WORD.
//
// - Writing to and reading from the registers.
// When the registers are accessed, depending on the operation, the module
// generates either the ReadEnable or the WriteEnable. When the registered
// HADDR matches the address of the register, data is either stored
// in the register or returned, depending on the operation. Note that the
// registers will be updated only when the HTRANS is either NSEQ or SEQ.
//
// - Generates the IRQSWAck, IRQSWClear depending on the VICADDRESS register
// read or written by the CPU.
//
// - Returns the integration test register values to the VicInterrupt block.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire          TransferValid;    // Transfer on AHB bus is valid
wire          TransferSizeErr;  // Transfer on AHB is invalid due to HSIZE
wire          OneWaitSt;        // Onewait state register indicator
wire   [29:0] TieLow;           // Tie values to zeros

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg           TransferValidQ;   // Transfer on AHB bus is valid
                                // (dataphase)
reg     [1:0] TransSizeErrQ;    // Transfer on AHB is invalid due to HSIZE
                                // (data phase). 2-bit shift register is
                                // used for error response generation
reg           ReadEnable;       // Read access enable signal
reg           WriteEnable;      // Write access enable signal
reg    [11:2] HADDRQ;           // Registered version of HADDR
reg           HWRITEQ;          // Registered version of HWRITE
reg           HPROT1Q;          // Registered version of HPROT(1)
reg           ProtEnQ;          // Protection feature enable
reg    [31:0] VICSoftIntQ;      // Software interrupt
reg    [31:0] VICADDRESSQ;      // Registered version of the VICADDRESS
reg    [31:0] VICIntEnQ;        // Interrupt enable
reg    [31:0] VICIntSelQ;       // Interrupt type
reg    [15:0] SWPrioMaskQ;      // Software priority level mask

reg    [31:0] VectAddr0Q;       // Register for vector address of 0th interrupt
reg    [31:0] VectAddr1Q;       // Register for vector address of 1st interrupt
reg    [31:0] VectAddr2Q;       // Register for vector address of 2nd interrupt
reg    [31:0] VectAddr3Q;       // Register for vector address of 3rd interrupt
reg    [31:0] VectAddr4Q;       // Register for vector address of 4th interrupt
reg    [31:0] VectAddr5Q;       // Register for vector address of 5th interrupt
reg    [31:0] VectAddr6Q;       // Register for vector address of 6th interrupt
reg    [31:0] VectAddr7Q;       // Register for vector address of 7th interrupt
reg    [31:0] VectAddr8Q;       // Register for vector address of 8th interrupt
reg    [31:0] VectAddr9Q;       // Register for vector address of 9th interrupt
reg    [31:0] VectAddr10Q;      // Register for vector address of 10th interrupt
reg    [31:0] VectAddr11Q;      // Register for vector address of 11th interrupt
reg    [31:0] VectAddr12Q;      // Register for vector address of 12th interrupt
reg    [31:0] VectAddr13Q;      // Register for vector address of 13th interrupt
reg    [31:0] VectAddr14Q;      // Register for vector address of 14th interrupt
reg    [31:0] VectAddr15Q;      // Register for vector address of 15th interrupt
reg    [31:0] VectAddr16Q;      // Register for vector address of 16th interrupt
reg    [31:0] VectAddr17Q;      // Register for vector address of 17th interrupt
reg    [31:0] VectAddr18Q;      // Register for vector address of 18th interrupt
reg    [31:0] VectAddr19Q;      // Register for vector address of 19th interrupt
reg    [31:0] VectAddr20Q;      // Register for vector address of 20th interrupt
reg    [31:0] VectAddr21Q;      // Register for vector address of 21st interrupt
reg    [31:0] VectAddr22Q;      // Register for vector address of 22nd interrupt
reg    [31:0] VectAddr23Q;      // Register for vector address of 23rd interrupt
reg    [31:0] VectAddr24Q;      // Register for vector address of 24th interrupt
reg    [31:0] VectAddr25Q;      // Register for vector address of 25th interrupt
reg    [31:0] VectAddr26Q;      // Register for vector address of 26th interrupt
reg    [31:0] VectAddr27Q;      // Register for vector address of 27th interrupt
reg    [31:0] VectAddr28Q;      // Register for vector address of 28th interrupt
reg    [31:0] VectAddr29Q;      // Register for vector address of 29th interrupt
reg    [31:0] VectAddr30Q;      // Register for vector address of 30th interrupt
reg    [31:0] VectAddr31Q;      // Register for vector address of 31st interrupt
reg     [3:0] VectPrio0Q;       // Register of interrupt priority level for 0th
                                // interrupt
reg     [3:0] VectPrio1Q;       // Register of interrupt priority level for 1st
                                // interrupt
reg     [3:0] VectPrio2Q;       // Register of interrupt priority level for 2nd
                                // interrupt
reg     [3:0] VectPrio3Q;       // Register of interrupt priority level for 3rd
                                // interrupt
reg     [3:0] VectPrio4Q;       // Register of interrupt priority level for 4th
                                // interrupt
reg     [3:0] VectPrio5Q;       // Register of interrupt priority level for 5th
                                // interrupt
reg     [3:0] VectPrio6Q;       // Register of interrupt priority level for 6th
                                // interrupt
reg     [3:0] VectPrio7Q;       // Register of interrupt priority level for 7th
                                // interrupt
reg     [3:0] VectPrio8Q;       // Register of interrupt priority level for 8th
                                // interrupt
reg     [3:0] VectPrio9Q;       // Register of interrupt priority level for 9th
                                // interrupt
reg     [3:0] VectPrio10Q;      // Register of interrupt priority level for 10th
                                // interrupt
reg     [3:0] VectPrio11Q;      // Register of interrupt priority level for 11th
                                // interrupt
reg     [3:0] VectPrio12Q;      // Register of interrupt priority level for 12th
                                // interrupt
reg     [3:0] VectPrio13Q;      // Register of interrupt priority level for 13th
                                // interrupt
reg     [3:0] VectPrio14Q;      // Register of interrupt priority level for 14th
                                // interrupt
reg     [3:0] VectPrio15Q;      // Register of interrupt priority level for 15th
                                // interrupt
reg     [3:0] VectPrio16Q;      // Register of interrupt priority level for 16th
                                // interrupt
reg     [3:0] VectPrio17Q;      // Register of interrupt priority level for 17th
                                // interrupt
reg     [3:0] VectPrio18Q;      // Register of interrupt priority level for 18th
                                // interrupt
reg     [3:0] VectPrio19Q;      // Register of interrupt priority level for 19th
                                // interrupt
reg     [3:0] VectPrio20Q;      // Register of interrupt priority level for 20th
                                // interrupt
reg     [3:0] VectPrio21Q;      // Register of interrupt priority level for 21st
                                // interrupt
reg     [3:0] VectPrio22Q;      // Register of interrupt priority level for 22nd
                                // interrupt
reg     [3:0] VectPrio23Q;      // Register of interrupt priority level for 23rd
                                // interrupt
reg     [3:0] VectPrio24Q;      // Register of interrupt priority level for 24th
                                // interrupt
reg     [3:0] VectPrio25Q;      // Register of interrupt priority level for 25th
                                // interrupt
reg     [3:0] VectPrio26Q;      // Register of interrupt priority level for 26th
                                // interrupt
reg     [3:0] VectPrio27Q;      // Register of interrupt priority level for 27th
                                // interrupt
reg     [3:0] VectPrio28Q;      // Register of interrupt priority level for 28th
                                // interrupt
reg     [3:0] VectPrio29Q;      // Register of interrupt priority level for 29th
                                // interrupt
reg     [3:0] VectPrio30Q;      // Register of interrupt priority level for 30th
                                // interrupt
reg     [3:0] VectPrio31Q;      // Register of interrupt priority level for 31st
                                // interrupt
reg     [3:0] VectPrio32Q;      // Register of interrupt priority of Daisy chain

// Test registers
reg     [1:0] VICITCRQ;         // Integration test mode
reg     [8:6] VICITIP1Q;        // I/P test register 1
reg    [31:0] VICITIP2Q;        // I/P test register 2
reg     [9:6] VICITOP1Q;        // O/P test register 1
reg    [31:0] VICITOP2Q;        // O/P test register 2
reg    [31:0] IntSStatusQ;      // Sampled interrupt source status

// Registered version of read value for Integration test register
reg           IRQACKTestValQ1;  // Registered version of VICIRQACK
reg           nIRQINTestValQ1;  // Registered version of nVICIRQIN
reg           nFIQINTestValQ1;  // Registered version of nVICFIQIN
reg           IRQTestValQ1;     // Registered version of VICIRQ
reg           FIQTestValQ1;     // Registered version of VICFIQ
reg           ACKOUTTestValQ1;  // Registered version of VICIRQACKOUT
reg           IRQACKTestValQ2;  // Two times clocked version of VICIRQACK
reg           nIRQINTestValQ2;  // Two times clocked version of nVICIRQIN
reg           nFIQINTestValQ2;  // Two times clocked version of nVICFIQIN
reg           IRQTestValQ2;     // Two times clocked version of VICIRQ
reg           FIQTestValQ2;     // Two times clocked version of VICFIQ
reg           ACKOUTTestValQ2;  // Two times clocked version of VICIRQACKOUT

// Synchronization registers for interrupt status
reg    [31:0] VICFIQStatusQ1;   // FIQ status (1st synchronised register)
reg    [31:0] VICIRQStatusQ1;   // IRQ status (1st synchronised register)
reg    [31:0] VICRawIntrQ1;     // Raw interrupt (1st synchronised register)
reg    [31:0] VICIntSourceQ1;   // Interrupt source (1st synchronised register)
reg    [31:0] VICFIQStatusQ2;   // FIQ status (2nd synchronised register)
reg    [31:0] VICIRQStatusQ2;   // IRQ status (2nd synchronised register)
reg    [31:0] VICRawIntrQ2;     // Raw interrupt (2nd synchronised register)
reg    [31:0] VICIntSourceQ2;   // Interrupt source (2nd synchronised register)
reg     [7:0] IDReadMux;        // Read Mux for Cell ID and Peripheral ID

reg    [31:0] NxtVectAddr0;     // D-input of VectAddr0Q
reg    [31:0] NxtVectAddr1;     // D-input of VectAddr1Q
reg    [31:0] NxtVectAddr2;     // D-input of VectAddr2Q
reg    [31:0] NxtVectAddr3;     // D-input of VectAddr3Q
reg    [31:0] NxtVectAddr4;     // D-input of VectAddr4Q
reg    [31:0] NxtVectAddr5;     // D-input of VectAddr5Q
reg    [31:0] NxtVectAddr6;     // D-input of VectAddr6Q
reg    [31:0] NxtVectAddr7;     // D-input of VectAddr7Q
reg    [31:0] NxtVectAddr8;     // D-input of VectAddr8Q
reg    [31:0] NxtVectAddr9;     // D-input of VectAddr9Q
reg    [31:0] NxtVectAddr10;    // D-input of VectAddr10Q
reg    [31:0] NxtVectAddr11;    // D-input of VectAddr11Q
reg    [31:0] NxtVectAddr12;    // D-input of VectAddr12Q
reg    [31:0] NxtVectAddr13;    // D-input of VectAddr13Q
reg    [31:0] NxtVectAddr14;    // D-input of VectAddr14Q
reg    [31:0] NxtVectAddr15;    // D-input of VectAddr15Q
reg    [31:0] NxtVectAddr16;    // D-input of VectAddr16Q
reg    [31:0] NxtVectAddr17;    // D-input of VectAddr17Q
reg    [31:0] NxtVectAddr18;    // D-input of VectAddr18Q
reg    [31:0] NxtVectAddr19;    // D-input of VectAddr19Q
reg    [31:0] NxtVectAddr20;    // D-input of VectAddr20Q
reg    [31:0] NxtVectAddr21;    // D-input of VectAddr21Q
reg    [31:0] NxtVectAddr22;    // D-input of VectAddr22Q
reg    [31:0] NxtVectAddr23;    // D-input of VectAddr23Q
reg    [31:0] NxtVectAddr24;    // D-input of VectAddr24Q
reg    [31:0] NxtVectAddr25;    // D-input of VectAddr25Q
reg    [31:0] NxtVectAddr26;    // D-input of VectAddr26Q
reg    [31:0] NxtVectAddr27;    // D-input of VectAddr27Q
reg    [31:0] NxtVectAddr28;    // D-input of VectAddr28Q
reg    [31:0] NxtVectAddr29;    // D-input of VectAddr29Q
reg    [31:0] NxtVectAddr30;    // D-input of VectAddr30Q
reg    [31:0] NxtVectAddr31;    // D-input of VectAddr31Q
reg     [3:0] NxtVectPrio0;     // D-input of VectPrio0Q
reg     [3:0] NxtVectPrio1;     // D-input of VectPrio1Q
reg     [3:0] NxtVectPrio2;     // D-input of VectPrio2Q
reg     [3:0] NxtVectPrio3;     // D-input of VectPrio3Q
reg     [3:0] NxtVectPrio4;     // D-input of VectPrio4Q
reg     [3:0] NxtVectPrio5;     // D-input of VectPrio5Q
reg     [3:0] NxtVectPrio6;     // D-input of VectPrio6Q
reg     [3:0] NxtVectPrio7;     // D-input of VectPrio7Q
reg     [3:0] NxtVectPrio8;     // D-input of VectPrio8Q
reg     [3:0] NxtVectPrio9;     // D-input of VectPrio9Q
reg     [3:0] NxtVectPrio10;    // D-input of VectPrio10Q
reg     [3:0] NxtVectPrio11;    // D-input of VectPrio11Q
reg     [3:0] NxtVectPrio12;    // D-input of VectPrio12Q
reg     [3:0] NxtVectPrio13;    // D-input of VectPrio13Q
reg     [3:0] NxtVectPrio14;    // D-input of VectPrio14Q
reg     [3:0] NxtVectPrio15;    // D-input of VectPrio15Q
reg     [3:0] NxtVectPrio16;    // D-input of VectPrio16Q
reg     [3:0] NxtVectPrio17;    // D-input of VectPrio17Q
reg     [3:0] NxtVectPrio18;    // D-input of VectPrio18Q
reg     [3:0] NxtVectPrio19;    // D-input of VectPrio19Q
reg     [3:0] NxtVectPrio20;    // D-input of VectPrio20Q
reg     [3:0] NxtVectPrio21;    // D-input of VectPrio21Q
reg     [3:0] NxtVectPrio22;    // D-input of VectPrio22Q
reg     [3:0] NxtVectPrio23;    // D-input of VectPrio23Q
reg     [3:0] NxtVectPrio24;    // D-input of VectPrio24Q
reg     [3:0] NxtVectPrio25;    // D-input of VectPrio25Q
reg     [3:0] NxtVectPrio26;    // D-input of VectPrio26Q
reg     [3:0] NxtVectPrio27;    // D-input of VectPrio27Q
reg     [3:0] NxtVectPrio28;    // D-input of VectPrio28Q
reg     [3:0] NxtVectPrio29;    // D-input of VectPrio29Q
reg     [3:0] NxtVectPrio30;    // D-input of VectPrio30Q
reg     [3:0] NxtVectPrio31;    // D-input of VectPrio31Q
reg     [3:0] NxtVectPrio32;    // D-input of VectPrio32Q
reg    [31:0] NxtVICIntSel;     // D-input of VICIntSelQ

reg    [31:0] NxtVICIntEn;      // D-input of VICIntEnQ
reg    [31:0] NxtVICSoftInt;    // D-input of VICSoftIntQ
reg    [15:0] NxtSWPrioMask;    // D-input of SWPrioMaskQ
reg     [1:0] NxtVICITCR;       // Integration test mode
reg     [8:6] NxtVICITIP1;      // I/P test register 1
reg    [31:0] NxtVICITIP2;      // I/P test register 2
reg     [9:6] NxtVICITOP1;      // O/P test register 1
reg    [31:0] NxtVICITOP2;      // O/P test register 2
reg    [31:0] NxtIntSStatus;    // Sampled interrupt source status
reg     [7:0] NxtIDReadMux;     // D-input of IDReadMux
reg           NxtProtEn;        // D-input of ProtEnQ
reg    [11:2] NxtHADDR;         // D-input of HADDR
reg           NxtHWRITE;        // D-input of HWRITEQ
reg           NxtHPROT1;        // D-input of HPROT1Q

reg           NxtReadEnable;    // D-input of ReadEnable
reg           NxtWriteEnable;   // D-input of WriteEnable

reg           OneWaitSt1Q;      // Registered OneWaitSt
reg           OneWaitSt2Q;      // Registered OneWaitSt1Q

reg    [31:0] HRDATA1;          // Internal version of HRDATA for 1st set of
                                // read data
reg    [31:0] HRDATA2;          // Internal version of HRDATA for 2nd set of
                                // read data
reg    [31:0] HRDATA3;          // Internal version of HRDATA for 3rd set of
                                // read data
reg    [31:0] HRDATA4;          // Internal version of HRDATA for 4th set of
                                // read data
reg    [31:0] HRDATA5;          // Internal version of HRDATA for 5th set of
                                // read data
reg    [31:0] NxtHRDATA1;       // D-input of HRDATA1
reg    [31:0] NxtHRDATA2;       // D-input of HRDATA2

reg           VICFIQINREGQ;     // Clocked version of VICFIQINREG
reg           VICIRQINREGQ;     // Clocked version of VICIRQINREG
// Include Parameters File
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
// Detect legal transfers
// When the registers are accessed with HSIZE as WORD and HTRANS is either NSEQ
// or SEQ then the transfer is a valid.
// -----------------------------------------------------------------------------
assign TransferValid  = (((HSELVIC && HTRANS1 && HREADYIN) &&
                          (HSIZE == 3'b010)) ? 1'b1 : 1'b0);

// -----------------------------------------------------------------------------
// Detect illegal transfers
// When the registers are accessed with HSIZE other than WORD then the transfer
// is an invalid transfer.
// -----------------------------------------------------------------------------
assign TransferSizeErr  = (((HSELVIC && HTRANS1 && (HREADYIN)) &&
                            (HSIZE !=3'b010)) ? 1'b1 : 1'b0);

// -----------------------------------------------------------------------------
// Detect one wait state register access
// When the access to vector address registers[0-31] or to the priority
// registers, assert the OneWaitSt signal
// -----------------------------------------------------------------------------
assign OneWaitSt  = ((TransferValid &&
                     ((HADDR[11:7] == 5'b00010) || (HADDR[11:7] == 5'b00100))) ?
                             1'b1 : 1'b0);

// -----------------------------------------------------------------------------
// Sequential logic to clock the OneWaitSt
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_OneWtSeq
  if (HRESETn == 1'b0)
    begin
      OneWaitSt1Q    <= 1'b0;
      OneWaitSt2Q    <= 1'b0;
    end
  else
    begin
      OneWaitSt1Q   <= OneWaitSt;
      OneWaitSt2Q   <= OneWaitSt1Q;
    end
end // p_OneWtSeq

// -----------------------------------------------------------------------------
// Combinational logic to generate the protect enable
// -----------------------------------------------------------------------------
always @(TransferValidQ or HWRITEQ or HPROT1Q or HADDRQ or HWDATA or
         ProtEnQ)
begin : p_ProtRegComb
  if ((((TransferValidQ & HWRITEQ) & HPROT1Q) &
       HADDRQ[11:2] == `HADDR_VICPROTECTION))
    begin
      NxtProtEn  = HWDATA[0];
    end
  else
    begin
      NxtProtEn  = ProtEnQ;
    end
end // p_ProtRegComb

// -----------------------------------------------------------------------------
// Protection register clocking
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ProtReg_WrSeq
  if (HRESETn == 1'b0)
    begin
      ProtEnQ <= 1'b0;
    end
  else
    begin
      ProtEnQ <= NxtProtEn;
    end
end // p_ProtReg_WrSeq

// -----------------------------------------------------------------------------
// Combinational logic to store the AHB parameters
// -----------------------------------------------------------------------------
always @(TransferValid or HADDR or HWRITE or HPROT1 or HADDRQ or HWRITEQ or
         HPROT1Q)
begin : p_AHBSigStoreComb
  if (TransferValid)
    begin
      NxtHADDR  = HADDR;
      NxtHWRITE = HWRITE;
      NxtHPROT1 = HPROT1;
    end
  else
    begin
      NxtHADDR  = HADDRQ;
      NxtHWRITE = HWRITEQ;
      NxtHPROT1 = HPROT1Q;
    end
end // p_AHBSigStoreComb

// -----------------------------------------------------------------------------
// Register HADDR and AHB control signals for read write operation
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegHADDRSeq
  if (HRESETn == 1'b0)
    begin
      HADDRQ           <= {10{1'b0}};
      HWRITEQ          <= 1'b0;
      HPROT1Q          <= 1'b0;
      TransferValidQ   <= 1'b0;
      TransSizeErrQ    <= 2'b00;
    end
  else
    begin
      HADDRQ           <= NxtHADDR;
      HWRITEQ          <= NxtHWRITE;
      HPROT1Q          <= NxtHPROT1;
      TransferValidQ   <= TransferValid;
      TransSizeErrQ[0] <= TransferSizeErr;
      TransSizeErrQ[1] <= TransSizeErrQ[0];
    end
end // p_RegHADDRSeq

// -----------------------------------------------------------------------------
// Generate error response if invalid transfer size is detected
// -----------------------------------------------------------------------------
assign HRESP      = ((TransSizeErrQ != 2'b00) ? 2'b01 : 2'b00);

// -----------------------------------------------------------------------------
// Generate HREADYOUT
// When the access is to the vector address registers or to the priority
// registers or if the access to the registers with HSIZE other than WORD then
// deassert the HREADYOUT for one clock
// -----------------------------------------------------------------------------
assign HREADYOUT  = ((~(OneWaitSt1Q && ~(OneWaitSt2Q))) && ~(TransSizeErrQ[0]));

// -----------------------------------------------------------------------------
// Generate read and write enable controls for registers
// If the ProtectionEnable is high then only the privileged access are allowed.
// If the normal access is performed with the ProtectionEnable high then read
// and write enables are not asserted.
// If the ProtectionEnable is low, then both the normal and privileged accesses
// are valid.
// -----------------------------------------------------------------------------
always @(TransferValid or ProtEnQ or HWRITE or HPROT1)
begin : p_EnableComb
  if ((TransferValid == 1'b1) && (((ProtEnQ == 1'b1) && (HPROT1 == 1'b1)) ||
      (ProtEnQ == 1'b0)))
    begin
      NxtReadEnable  = ~(HWRITE);
      NxtWriteEnable = HWRITE;
    end
  else
    begin
      NxtReadEnable   = 1'b0;
      NxtWriteEnable  = 1'b0;
    end
end // p_EnableComb

// -----------------------------------------------------------------------------
// Sequential circuit to register the Read and write enable
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_EnableSeq
  if (HRESETn == 1'b0)
    begin
      ReadEnable  <= 1'b0;
      WriteEnable <= 1'b0;
    end
  else
    begin
      ReadEnable  <= NxtReadEnable;
      WriteEnable <= NxtWriteEnable;
    end
end // p_EnableSeq

// -----------------------------------------------------------------------------
// Combinational circuit for register write
// -----------------------------------------------------------------------------
always @(WriteEnable or HADDRQ or HWDATA or
         VectAddr0Q or VectAddr1Q or VectAddr2Q or VectAddr3Q or
         VectAddr4Q or VectAddr5Q or VectAddr6Q or VectAddr7Q or
         VectAddr8Q or VectAddr9Q or VectAddr10Q or VectAddr11Q or
         VectAddr12Q or VectAddr13Q or VectAddr14Q or VectAddr15Q or
         VectAddr16Q or VectAddr17Q or VectAddr18Q or VectAddr19Q or
         VectAddr20Q or VectAddr21Q or VectAddr22Q or VectAddr23Q or
         VectAddr24Q or VectAddr25Q or VectAddr26Q or VectAddr27Q or
         VectAddr28Q or VectAddr29Q or VectAddr30Q or VectAddr31Q or
         VectPrio0Q or VectPrio1Q or VectPrio2Q or VectPrio3Q or
         VectPrio4Q or VectPrio5Q or VectPrio6Q or VectPrio7Q or
         VectPrio8Q or VectPrio9Q or VectPrio10Q or VectPrio11Q or
         VectPrio12Q or VectPrio13Q or VectPrio14Q or VectPrio15Q or
         VectPrio16Q or VectPrio17Q or VectPrio18Q or VectPrio19Q or
         VectPrio20Q or VectPrio21Q or VectPrio22Q or VectPrio23Q or
         VectPrio24Q or VectPrio25Q or VectPrio26Q or VectPrio27Q or
         VectPrio28Q or VectPrio29Q or VectPrio30Q or VectPrio31Q or
         VICIntSelQ or VICIntEnQ or VICSoftIntQ or SWPrioMaskQ or
         VectPrio32Q or VICITCRQ or VICITIP1Q or VICITIP2Q or
         VICITOP1Q or VICITOP2Q)
begin : p_RegWriteComb
  NxtVectAddr0  = VectAddr0Q;
  NxtVectAddr1  = VectAddr1Q;
  NxtVectAddr2  = VectAddr2Q;
  NxtVectAddr3  = VectAddr3Q;
  NxtVectAddr4  = VectAddr4Q;
  NxtVectAddr5  = VectAddr5Q;
  NxtVectAddr6  = VectAddr6Q;
  NxtVectAddr7  = VectAddr7Q;
  NxtVectAddr8  = VectAddr8Q;
  NxtVectAddr9  = VectAddr9Q;
  NxtVectAddr10 = VectAddr10Q;
  NxtVectAddr11 = VectAddr11Q;
  NxtVectAddr12 = VectAddr12Q;
  NxtVectAddr13 = VectAddr13Q;
  NxtVectAddr14 = VectAddr14Q;
  NxtVectAddr15 = VectAddr15Q;
  NxtVectAddr16 = VectAddr16Q;
  NxtVectAddr17 = VectAddr17Q;
  NxtVectAddr18 = VectAddr18Q;
  NxtVectAddr19 = VectAddr19Q;
  NxtVectAddr20 = VectAddr20Q;
  NxtVectAddr21 = VectAddr21Q;
  NxtVectAddr22 = VectAddr22Q;
  NxtVectAddr23 = VectAddr23Q;
  NxtVectAddr24 = VectAddr24Q;
  NxtVectAddr25 = VectAddr25Q;
  NxtVectAddr26 = VectAddr26Q;
  NxtVectAddr27 = VectAddr27Q;
  NxtVectAddr28 = VectAddr28Q;
  NxtVectAddr29 = VectAddr29Q;
  NxtVectAddr30 = VectAddr30Q;
  NxtVectAddr31 = VectAddr31Q;
  NxtVectPrio0  = VectPrio0Q;
  NxtVectPrio1  = VectPrio1Q;
  NxtVectPrio2  = VectPrio2Q;
  NxtVectPrio3  = VectPrio3Q;
  NxtVectPrio4  = VectPrio4Q;
  NxtVectPrio5  = VectPrio5Q;
  NxtVectPrio6  = VectPrio6Q;
  NxtVectPrio7  = VectPrio7Q;
  NxtVectPrio8  = VectPrio8Q;
  NxtVectPrio9  = VectPrio9Q;
  NxtVectPrio10 = VectPrio10Q;
  NxtVectPrio11 = VectPrio11Q;
  NxtVectPrio12 = VectPrio12Q;
  NxtVectPrio13 = VectPrio13Q;
  NxtVectPrio14 = VectPrio14Q;
  NxtVectPrio15 = VectPrio15Q;
  NxtVectPrio16 = VectPrio16Q;
  NxtVectPrio17 = VectPrio17Q;
  NxtVectPrio18 = VectPrio18Q;
  NxtVectPrio19 = VectPrio19Q;
  NxtVectPrio20 = VectPrio20Q;
  NxtVectPrio21 = VectPrio21Q;
  NxtVectPrio22 = VectPrio22Q;
  NxtVectPrio23 = VectPrio23Q;
  NxtVectPrio24 = VectPrio24Q;
  NxtVectPrio25 = VectPrio25Q;
  NxtVectPrio26 = VectPrio26Q;
  NxtVectPrio27 = VectPrio27Q;
  NxtVectPrio28 = VectPrio28Q;
  NxtVectPrio29 = VectPrio29Q;
  NxtVectPrio30 = VectPrio30Q;
  NxtVectPrio31 = VectPrio31Q;
  NxtVICIntSel  = VICIntSelQ;
  NxtVICIntEn   = VICIntEnQ;
  NxtVICSoftInt = VICSoftIntQ;
  NxtSWPrioMask = SWPrioMaskQ;
  NxtVectPrio32 = VectPrio32Q;
  NxtVICITCR    = VICITCRQ;
  NxtVICITIP1   = VICITIP1Q;
  NxtVICITIP2   = VICITIP2Q;
  NxtVICITOP1   = VICITOP1Q;
  NxtVICITOP2   = VICITOP2Q;
  if (WriteEnable)
    begin
      case (HADDRQ[11:2])
        `HADDR_VICVECTADDR0:
           NxtVectAddr0 = HWDATA;
        `HADDR_VICVECTADDR1:
           NxtVectAddr1 = HWDATA;
        `HADDR_VICVECTADDR2:
           NxtVectAddr2 = HWDATA;
        `HADDR_VICVECTADDR3:
           NxtVectAddr3 = HWDATA;
        `HADDR_VICVECTADDR4:
           NxtVectAddr4 = HWDATA;
        `HADDR_VICVECTADDR5:
           NxtVectAddr5 = HWDATA;
        `HADDR_VICVECTADDR6:
           NxtVectAddr6 = HWDATA;
        `HADDR_VICVECTADDR7:
           NxtVectAddr7 = HWDATA;
        `HADDR_VICVECTADDR8:
           NxtVectAddr8 = HWDATA;
        `HADDR_VICVECTADDR9:
           NxtVectAddr9 = HWDATA;
        `HADDR_VICVECTADDR10:
           NxtVectAddr10 = HWDATA;
        `HADDR_VICVECTADDR11:
           NxtVectAddr11 = HWDATA;
        `HADDR_VICVECTADDR12:
           NxtVectAddr12 = HWDATA;
        `HADDR_VICVECTADDR13:
           NxtVectAddr13 = HWDATA;
        `HADDR_VICVECTADDR14:
           NxtVectAddr14 = HWDATA;
        `HADDR_VICVECTADDR15:
           NxtVectAddr15 = HWDATA;
        `HADDR_VICVECTADDR16:
           NxtVectAddr16 = HWDATA;
        `HADDR_VICVECTADDR17:
           NxtVectAddr17 = HWDATA;
        `HADDR_VICVECTADDR18:
           NxtVectAddr18 = HWDATA;
        `HADDR_VICVECTADDR19:
           NxtVectAddr19 = HWDATA;
        `HADDR_VICVECTADDR20:
           NxtVectAddr20 = HWDATA;
        `HADDR_VICVECTADDR21:
           NxtVectAddr21 = HWDATA;
        `HADDR_VICVECTADDR22:
           NxtVectAddr22 = HWDATA;
        `HADDR_VICVECTADDR23:
           NxtVectAddr23 = HWDATA;
        `HADDR_VICVECTADDR24:
           NxtVectAddr24 = HWDATA;
        `HADDR_VICVECTADDR25:
           NxtVectAddr25 = HWDATA;
        `HADDR_VICVECTADDR26:
           NxtVectAddr26 = HWDATA;
        `HADDR_VICVECTADDR27:
           NxtVectAddr27 = HWDATA;
        `HADDR_VICVECTADDR28:
           NxtVectAddr28 = HWDATA;
        `HADDR_VICVECTADDR29:
           NxtVectAddr29 = HWDATA;
        `HADDR_VICVECTADDR30:
           NxtVectAddr30 = HWDATA;
        `HADDR_VICVECTADDR31:
           NxtVectAddr31 = HWDATA;
        `HADDR_VICPRIORITY0:
           NxtVectPrio0 = HWDATA[3:0];
        `HADDR_VICPRIORITY1:
           NxtVectPrio1 = HWDATA[3:0];
        `HADDR_VICPRIORITY2:
           NxtVectPrio2 = HWDATA[3:0];
        `HADDR_VICPRIORITY3:
           NxtVectPrio3 = HWDATA[3:0];
        `HADDR_VICPRIORITY4:
           NxtVectPrio4 = HWDATA[3:0];
        `HADDR_VICPRIORITY5:
           NxtVectPrio5 = HWDATA[3:0];
        `HADDR_VICPRIORITY6:
           NxtVectPrio6 = HWDATA[3:0];
        `HADDR_VICPRIORITY7:
           NxtVectPrio7 = HWDATA[3:0];
        `HADDR_VICPRIORITY8:
           NxtVectPrio8 = HWDATA[3:0];
        `HADDR_VICPRIORITY9:
           NxtVectPrio9 = HWDATA[3:0];
        `HADDR_VICPRIORITY10:
           NxtVectPrio10 = HWDATA[3:0];
        `HADDR_VICPRIORITY11:
           NxtVectPrio11 = HWDATA[3:0];
        `HADDR_VICPRIORITY12:
           NxtVectPrio12 = HWDATA[3:0];
        `HADDR_VICPRIORITY13:
           NxtVectPrio13 = HWDATA[3:0];
        `HADDR_VICPRIORITY14:
           NxtVectPrio14 = HWDATA[3:0];
        `HADDR_VICPRIORITY15:
           NxtVectPrio15 = HWDATA[3:0];
        `HADDR_VICPRIORITY16:
           NxtVectPrio16 = HWDATA[3:0];
        `HADDR_VICPRIORITY17:
           NxtVectPrio17 = HWDATA[3:0];
        `HADDR_VICPRIORITY18:
           NxtVectPrio18 = HWDATA[3:0];
        `HADDR_VICPRIORITY19:
           NxtVectPrio19 = HWDATA[3:0];
        `HADDR_VICPRIORITY20:
           NxtVectPrio20 = HWDATA[3:0];
        `HADDR_VICPRIORITY21:
           NxtVectPrio21 = HWDATA[3:0];
        `HADDR_VICPRIORITY22:
           NxtVectPrio22 = HWDATA[3:0];
        `HADDR_VICPRIORITY23:
           NxtVectPrio23 = HWDATA[3:0];
        `HADDR_VICPRIORITY24:
           NxtVectPrio24 = HWDATA[3:0];
        `HADDR_VICPRIORITY25:
           NxtVectPrio25 = HWDATA[3:0];
        `HADDR_VICPRIORITY26:
           NxtVectPrio26 = HWDATA[3:0];
        `HADDR_VICPRIORITY27:
           NxtVectPrio27 = HWDATA[3:0];
        `HADDR_VICPRIORITY28:
           NxtVectPrio28 = HWDATA[3:0];
        `HADDR_VICPRIORITY29:
           NxtVectPrio29 = HWDATA[3:0];
        `HADDR_VICPRIORITY30:
           NxtVectPrio30 = HWDATA[3:0];
        `HADDR_VICPRIORITY31:
           NxtVectPrio31 = HWDATA[3:0];
        `HADDR_VICINTSELECT:
           NxtVICIntSel = HWDATA;
        `HADDR_VICINTENABLE:
           NxtVICIntEn  = (HWDATA | VICIntEnQ);
        `HADDR_VICINTENCLEAR:
           NxtVICIntEn = (~(HWDATA) & VICIntEnQ);
        `HADDR_VICSOFTINT:
           NxtVICSoftInt = (HWDATA | VICSoftIntQ);
        `HADDR_VICSOFTINTCLEAR:
           NxtVICSoftInt = (~(HWDATA) & VICSoftIntQ);
        `HADDR_VICSWPRIORITYMASK:
           NxtSWPrioMask = HWDATA[15:0];
        `HADDR_VICSWPRIORITYDAISY:
           NxtVectPrio32 = HWDATA[3:0];
        `HADDR_VICITCR:
           NxtVICITCR = HWDATA[1:0];
        `HADDR_VICITIP1:
           NxtVICITIP1 = HWDATA[8:6];
        `HADDR_VICITIP2:
           NxtVICITIP2 = HWDATA;
        `HADDR_VICITOP1:
           NxtVICITOP1 = HWDATA[9:6];
        `HADDR_VICITOP2:
           NxtVICITOP2 = HWDATA;
         default :
           begin
             NxtVectAddr0  = VectAddr0Q;
             NxtVectAddr1  = VectAddr1Q;
             NxtVectAddr2  = VectAddr2Q;
             NxtVectAddr3  = VectAddr3Q;
             NxtVectAddr4  = VectAddr4Q;
             NxtVectAddr5  = VectAddr5Q;
             NxtVectAddr6  = VectAddr6Q;
             NxtVectAddr7  = VectAddr7Q;
             NxtVectAddr8  = VectAddr8Q;
             NxtVectAddr9  = VectAddr9Q;
             NxtVectAddr10 = VectAddr10Q;
             NxtVectAddr11 = VectAddr11Q;
             NxtVectAddr12 = VectAddr12Q;
             NxtVectAddr13 = VectAddr13Q;
             NxtVectAddr14 = VectAddr14Q;
             NxtVectAddr15 = VectAddr15Q;
             NxtVectAddr16 = VectAddr16Q;
             NxtVectAddr17 = VectAddr17Q;
             NxtVectAddr18 = VectAddr18Q;
             NxtVectAddr19 = VectAddr19Q;
             NxtVectAddr20 = VectAddr20Q;
             NxtVectAddr21 = VectAddr21Q;
             NxtVectAddr22 = VectAddr22Q;
             NxtVectAddr23 = VectAddr23Q;
             NxtVectAddr24 = VectAddr24Q;
             NxtVectAddr25 = VectAddr25Q;
             NxtVectAddr26 = VectAddr26Q;
             NxtVectAddr27 = VectAddr27Q;
             NxtVectAddr28 = VectAddr28Q;
             NxtVectAddr29 = VectAddr29Q;
             NxtVectAddr30 = VectAddr30Q;
             NxtVectAddr31 = VectAddr31Q;
             NxtVectPrio0  = VectPrio0Q;
             NxtVectPrio1  = VectPrio1Q;
             NxtVectPrio2  = VectPrio2Q;
             NxtVectPrio3  = VectPrio3Q;
             NxtVectPrio4  = VectPrio4Q;
             NxtVectPrio5  = VectPrio5Q;
             NxtVectPrio6  = VectPrio6Q;
             NxtVectPrio7  = VectPrio7Q;
             NxtVectPrio8  = VectPrio8Q;
             NxtVectPrio9  = VectPrio9Q;
             NxtVectPrio10 = VectPrio10Q;
             NxtVectPrio11 = VectPrio11Q;
             NxtVectPrio12 = VectPrio12Q;
             NxtVectPrio13 = VectPrio13Q;
             NxtVectPrio14 = VectPrio14Q;
             NxtVectPrio15 = VectPrio15Q;
             NxtVectPrio16 = VectPrio16Q;
             NxtVectPrio17 = VectPrio17Q;
             NxtVectPrio18 = VectPrio18Q;
             NxtVectPrio19 = VectPrio19Q;
             NxtVectPrio20 = VectPrio20Q;
             NxtVectPrio21 = VectPrio21Q;
             NxtVectPrio22 = VectPrio22Q;
             NxtVectPrio23 = VectPrio23Q;
             NxtVectPrio24 = VectPrio24Q;
             NxtVectPrio25 = VectPrio25Q;
             NxtVectPrio26 = VectPrio26Q;
             NxtVectPrio27 = VectPrio27Q;
             NxtVectPrio28 = VectPrio28Q;
             NxtVectPrio29 = VectPrio29Q;
             NxtVectPrio30 = VectPrio30Q;
             NxtVectPrio31 = VectPrio31Q;
             NxtVICIntSel  = VICIntSelQ;
             NxtVICIntEn   = VICIntEnQ;
             NxtVICSoftInt = VICSoftIntQ;
             NxtSWPrioMask = SWPrioMaskQ;
             NxtVectPrio32 = VectPrio32Q;
             NxtVICITCR    = VICITCRQ;
             NxtVICITIP1   = VICITIP1Q;
             NxtVICITIP2   = VICITIP2Q;
             NxtVICITOP1   = VICITOP1Q;
             NxtVICITOP2   = VICITOP2Q;
           end
      endcase
    end
end // p_RegWriteComb

// -----------------------------------------------------------------------------
// Clock the register write
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_RegWriteSeq
  if (HRESETn == 1'b0)
    begin
      VectAddr0Q  <= {32{1'b0}};
      VectAddr1Q  <= {32{1'b0}};
      VectAddr2Q  <= {32{1'b0}};
      VectAddr3Q  <= {32{1'b0}};
      VectAddr4Q  <= {32{1'b0}};
      VectAddr5Q  <= {32{1'b0}};
      VectAddr6Q  <= {32{1'b0}};
      VectAddr7Q  <= {32{1'b0}};
      VectAddr8Q  <= {32{1'b0}};
      VectAddr9Q  <= {32{1'b0}};
      VectAddr10Q <= {32{1'b0}};
      VectAddr11Q <= {32{1'b0}};
      VectAddr12Q <= {32{1'b0}};
      VectAddr13Q <= {32{1'b0}};
      VectAddr14Q <= {32{1'b0}};
      VectAddr15Q <= {32{1'b0}};
      VectAddr16Q <= {32{1'b0}};
      VectAddr17Q <= {32{1'b0}};
      VectAddr18Q <= {32{1'b0}};
      VectAddr19Q <= {32{1'b0}};
      VectAddr20Q <= {32{1'b0}};
      VectAddr21Q <= {32{1'b0}};
      VectAddr22Q <= {32{1'b0}};
      VectAddr23Q <= {32{1'b0}};
      VectAddr24Q <= {32{1'b0}};
      VectAddr25Q <= {32{1'b0}};
      VectAddr26Q <= {32{1'b0}};
      VectAddr27Q <= {32{1'b0}};
      VectAddr28Q <= {32{1'b0}};
      VectAddr29Q <= {32{1'b0}};
      VectAddr30Q <= {32{1'b0}};
      VectAddr31Q <= {32{1'b0}};
      VectPrio0Q  <= {4{1'b1}};
      VectPrio1Q  <= {4{1'b1}};
      VectPrio2Q  <= {4{1'b1}};
      VectPrio3Q  <= {4{1'b1}};
      VectPrio4Q  <= {4{1'b1}};
      VectPrio5Q  <= {4{1'b1}};
      VectPrio6Q  <= {4{1'b1}};
      VectPrio7Q  <= {4{1'b1}};
      VectPrio8Q  <= {4{1'b1}};
      VectPrio9Q  <= {4{1'b1}};
      VectPrio10Q <= {4{1'b1}};
      VectPrio11Q <= {4{1'b1}};
      VectPrio12Q <= {4{1'b1}};
      VectPrio13Q <= {4{1'b1}};
      VectPrio14Q <= {4{1'b1}};
      VectPrio15Q <= {4{1'b1}};
      VectPrio16Q <= {4{1'b1}};
      VectPrio17Q <= {4{1'b1}};
      VectPrio18Q <= {4{1'b1}};
      VectPrio19Q <= {4{1'b1}};
      VectPrio20Q <= {4{1'b1}};
      VectPrio21Q <= {4{1'b1}};
      VectPrio22Q <= {4{1'b1}};
      VectPrio23Q <= {4{1'b1}};
      VectPrio24Q <= {4{1'b1}};
      VectPrio25Q <= {4{1'b1}};
      VectPrio26Q <= {4{1'b1}};
      VectPrio27Q <= {4{1'b1}};
      VectPrio28Q <= {4{1'b1}};
      VectPrio29Q <= {4{1'b1}};
      VectPrio30Q <= {4{1'b1}};
      VectPrio31Q <= {4{1'b1}};
      VectPrio32Q <= {4{1'b1}};
      VICADDRESSQ <= {32{1'b0}};
      VICSoftIntQ <= {32{1'b0}};
      VICIntEnQ   <= {32{1'b0}};
      VICIntSelQ  <= {32{1'b0}};
      SWPrioMaskQ <= {16{1'b1}};
      VICITCRQ    <= {2{1'b0}};
      VICITIP1Q   <= {3{1'b0}};
      VICITIP2Q   <= {32{1'b0}};
      VICITOP1Q   <= {4{1'b0}};
      VICITOP2Q   <= {32{1'b0}};
    end
  else
    begin
      VectAddr0Q  <= NxtVectAddr0;
      VectAddr1Q  <= NxtVectAddr1;
      VectAddr2Q  <= NxtVectAddr2;
      VectAddr3Q  <= NxtVectAddr3;
      VectAddr4Q  <= NxtVectAddr4;
      VectAddr5Q  <= NxtVectAddr5;
      VectAddr6Q  <= NxtVectAddr6;
      VectAddr7Q  <= NxtVectAddr7;
      VectAddr8Q  <= NxtVectAddr8;
      VectAddr9Q  <= NxtVectAddr9;
      VectAddr10Q <= NxtVectAddr10;
      VectAddr11Q <= NxtVectAddr11;
      VectAddr12Q <= NxtVectAddr12;
      VectAddr13Q <= NxtVectAddr13;
      VectAddr14Q <= NxtVectAddr14;
      VectAddr15Q <= NxtVectAddr15;
      VectAddr16Q <= NxtVectAddr16;
      VectAddr17Q <= NxtVectAddr17;
      VectAddr18Q <= NxtVectAddr18;
      VectAddr19Q <= NxtVectAddr19;
      VectAddr20Q <= NxtVectAddr20;
      VectAddr21Q <= NxtVectAddr21;
      VectAddr22Q <= NxtVectAddr22;
      VectAddr23Q <= NxtVectAddr23;
      VectAddr24Q <= NxtVectAddr24;
      VectAddr25Q <= NxtVectAddr25;
      VectAddr26Q <= NxtVectAddr26;
      VectAddr27Q <= NxtVectAddr27;
      VectAddr28Q <= NxtVectAddr28;
      VectAddr29Q <= NxtVectAddr29;
      VectAddr30Q <= NxtVectAddr30;
      VectAddr31Q <= NxtVectAddr31;
      VectPrio0Q  <= NxtVectPrio0;
      VectPrio1Q  <= NxtVectPrio1;
      VectPrio2Q  <= NxtVectPrio2;
      VectPrio3Q  <= NxtVectPrio3;
      VectPrio4Q  <= NxtVectPrio4;
      VectPrio5Q  <= NxtVectPrio5;
      VectPrio6Q  <= NxtVectPrio6;
      VectPrio7Q  <= NxtVectPrio7;
      VectPrio8Q  <= NxtVectPrio8;
      VectPrio9Q  <= NxtVectPrio9;
      VectPrio10Q <= NxtVectPrio10;
      VectPrio11Q <= NxtVectPrio11;
      VectPrio12Q <= NxtVectPrio12;
      VectPrio13Q <= NxtVectPrio13;
      VectPrio14Q <= NxtVectPrio14;
      VectPrio15Q <= NxtVectPrio15;
      VectPrio16Q <= NxtVectPrio16;
      VectPrio17Q <= NxtVectPrio17;
      VectPrio18Q <= NxtVectPrio18;
      VectPrio19Q <= NxtVectPrio19;
      VectPrio20Q <= NxtVectPrio20;
      VectPrio21Q <= NxtVectPrio21;
      VectPrio22Q <= NxtVectPrio22;
      VectPrio23Q <= NxtVectPrio23;
      VectPrio24Q <= NxtVectPrio24;
      VectPrio25Q <= NxtVectPrio25;
      VectPrio26Q <= NxtVectPrio26;
      VectPrio27Q <= NxtVectPrio27;
      VectPrio28Q <= NxtVectPrio28;
      VectPrio29Q <= NxtVectPrio29;
      VectPrio30Q <= NxtVectPrio30;
      VectPrio31Q <= NxtVectPrio31;
      VICADDRESSQ <= VICVectAddrVal;
      VICIntSelQ  <= NxtVICIntSel;
      VICIntEnQ   <= NxtVICIntEn;
      VICSoftIntQ <= NxtVICSoftInt;
      SWPrioMaskQ <= NxtSWPrioMask;
      VectPrio32Q <= NxtVectPrio32;
      VICITCRQ    <= NxtVICITCR;
      VICITIP1Q   <= NxtVICITIP1;
      VICITIP2Q   <= NxtVICITIP2;
      VICITOP1Q   <= NxtVICITOP1;
      VICITOP2Q   <= NxtVICITOP2;
    end
end // p_RegWriteSeq

// -----------------------------------------------------------------------------
// Registering the integration test read back value
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_ITestSampleSeq
  if (HRESETn == 1'b0)
    begin
      IRQACKTestValQ1  <= 1'b0;
      nIRQINTestValQ1  <= 1'b0;
      nFIQINTestValQ1  <= 1'b0;
      IRQTestValQ1     <= 1'b0;
      FIQTestValQ1     <= 1'b0;
      ACKOUTTestValQ1  <= 1'b0;
      IRQACKTestValQ2  <= 1'b0;
      nIRQINTestValQ2  <= 1'b0;
      nFIQINTestValQ2  <= 1'b0;
      IRQTestValQ2     <= 1'b0;
      FIQTestValQ2     <= 1'b0;
      ACKOUTTestValQ2  <= 1'b0;
    end
  else
    begin
      IRQACKTestValQ1  <= IRQACKTestVal;
      nIRQINTestValQ1  <= nIRQINTestVal;
      nFIQINTestValQ1  <= nFIQINTestVal;
      IRQTestValQ1     <= IRQTestVal;
      FIQTestValQ1     <= FIQTestVal;
      ACKOUTTestValQ1  <= ACKOUTTestVal;
      IRQACKTestValQ2  <= IRQACKTestValQ1;
      nIRQINTestValQ2  <= nIRQINTestValQ1;
      nFIQINTestValQ2  <= nFIQINTestValQ1;
      IRQTestValQ2     <= IRQTestValQ1;
      FIQTestValQ2     <= FIQTestValQ1;
      ACKOUTTestValQ2  <= ACKOUTTestValQ1;
    end
end // p_ITestSampleSeq

// -----------------------------------------------------------------------------
// Synchronize the status of the interrupts before starting read by software
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_IntStatSeq
  if (HRESETn == 1'b0)
    begin
      VICFIQStatusQ1  <= {32{1'b0}};
      VICFIQStatusQ2  <= {32{1'b0}};
      VICIRQStatusQ1  <= {32{1'b0}};
      VICIRQStatusQ2  <= {32{1'b0}};
      VICRawIntrQ1    <= {32{1'b0}};
      VICRawIntrQ2    <= {32{1'b0}};
      VICIntSourceQ1  <= {32{1'b0}};
      VICIntSourceQ2  <= {32{1'b0}};
    end
  else
    begin
      VICFIQStatusQ1  <= VICFIQStatus;
      VICFIQStatusQ2  <= VICFIQStatusQ1;
      VICIRQStatusQ1  <= VICIRQStatus;
      VICIRQStatusQ2  <= VICIRQStatusQ1;
      VICRawIntrQ1    <= VICRawIntr;
      VICRawIntrQ2    <= VICRawIntrQ1;
      VICIntSourceQ1  <= VICINTSOURCE;
      VICIntSourceQ2  <= VICIntSourceQ1;
    end
end // p_IntStatSeq

// -----------------------------------------------------------------------------
// Combinational logic to generate the IntSStatus. Status bit can be cleared
// by writing into the IntSStatusClear register
// -----------------------------------------------------------------------------
always @(WriteEnable or HADDRQ or VICIntSourceQ2 or HWDATA or IntSStatusQ  or
         VICITCRQ)
begin : p_IntSStatusComb
  if ((WriteEnable == 1'b1) && (HADDRQ[11:2] == `HADDR_VICINTSSTATUSCLEAR) &&
      (VICITCRQ[1] == 1'b1))
    begin
      NxtIntSStatus = ((IntSStatusQ | VICIntSourceQ2) & ~(HWDATA));
    end
  else if (VICITCRQ[1])
    begin
      NxtIntSStatus = (IntSStatusQ | VICIntSourceQ2);
    end
  else
    begin
      NxtIntSStatus = IntSStatusQ;
    end
end // p_IntSStatusComb

// -----------------------------------------------------------------------------
// Sequential circuit to generate the IntSStatus.
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_IntSStatusSeq
  if (HRESETn == 1'b0)
    begin
      IntSStatusQ  <= {32{1'b0}};
    end
  else
    begin
      IntSStatusQ  <= NxtIntSStatus;
    end
end // p_IntSStatusSeq

// -----------------------------------------------------------------------------
// Clock the VICIRQINREG and VICFIQINREG
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_IntInRegisterSeq
  if (HRESETn == 1'b0)
    begin
      VICIRQINREGQ  <= 1'b0;
      VICFIQINREGQ  <= 1'b0;
    end
  else
    begin
      VICIRQINREGQ <= VICIRQINREG;
      VICFIQINREGQ <= VICFIQINREG;
    end
end // p_IntInRegisterSeq
// -----------------------------------------------------------------------------
// Register read operation. When the AHB initiates the read operation to the
// vector address registers, combinatorially generate the input of the flip
// flop of the HRDATA for the access of address registers.
// -----------------------------------------------------------------------------
always @(HADDRQ or ReadEnable or VectAddr0Q or VectAddr1Q or
         VectAddr2Q or VectAddr3Q or VectAddr4Q or VectAddr5Q or
         VectAddr6Q or VectAddr7Q or VectAddr8Q or VectAddr9Q or
         VectAddr10Q or VectAddr11Q or VectAddr12Q or VectAddr13Q or
         VectAddr14Q or VectAddr15Q or VectAddr16Q or VectAddr17Q or
         VectAddr18Q or VectAddr19Q or VectAddr20Q or VectAddr21Q or
         VectAddr22Q or VectAddr23Q or VectAddr24Q or VectAddr25Q or
         VectAddr26Q or VectAddr27Q or VectAddr28Q or VectAddr29Q or
         VectAddr30Q or VectAddr31Q)
begin : p_RegRead1Comb
  if (ReadEnable)
    begin
      case (HADDRQ)
        `HADDR_VICVECTADDR0:
          NxtHRDATA1 = VectAddr0Q;
        `HADDR_VICVECTADDR1:
          NxtHRDATA1 = VectAddr1Q;
        `HADDR_VICVECTADDR2:
          NxtHRDATA1 = VectAddr2Q;
        `HADDR_VICVECTADDR3:
          NxtHRDATA1 = VectAddr3Q;
        `HADDR_VICVECTADDR4:
          NxtHRDATA1 = VectAddr4Q;
        `HADDR_VICVECTADDR5:
          NxtHRDATA1 = VectAddr5Q;
        `HADDR_VICVECTADDR6:
          NxtHRDATA1 = VectAddr6Q;
        `HADDR_VICVECTADDR7:
          NxtHRDATA1 = VectAddr7Q;
        `HADDR_VICVECTADDR8:
          NxtHRDATA1 = VectAddr8Q;
        `HADDR_VICVECTADDR9:
          NxtHRDATA1 = VectAddr9Q;
        `HADDR_VICVECTADDR10:
          NxtHRDATA1 = VectAddr10Q;
        `HADDR_VICVECTADDR11:
          NxtHRDATA1 = VectAddr11Q;
        `HADDR_VICVECTADDR12:
          NxtHRDATA1 = VectAddr12Q;
        `HADDR_VICVECTADDR13:
          NxtHRDATA1 = VectAddr13Q;
        `HADDR_VICVECTADDR14:
          NxtHRDATA1 = VectAddr14Q;
        `HADDR_VICVECTADDR15:
          NxtHRDATA1 = VectAddr15Q;
        `HADDR_VICVECTADDR16:
          NxtHRDATA1 = VectAddr16Q;
        `HADDR_VICVECTADDR17:
          NxtHRDATA1 = VectAddr17Q;
        `HADDR_VICVECTADDR18:
          NxtHRDATA1 = VectAddr18Q;
        `HADDR_VICVECTADDR19:
          NxtHRDATA1 = VectAddr19Q;
        `HADDR_VICVECTADDR20:
          NxtHRDATA1 = VectAddr20Q;
        `HADDR_VICVECTADDR21:
          NxtHRDATA1 = VectAddr21Q;
        `HADDR_VICVECTADDR22:
          NxtHRDATA1 = VectAddr22Q;
        `HADDR_VICVECTADDR23:
          NxtHRDATA1 = VectAddr23Q;
        `HADDR_VICVECTADDR24:
          NxtHRDATA1 = VectAddr24Q;
        `HADDR_VICVECTADDR25:
          NxtHRDATA1 = VectAddr25Q;
        `HADDR_VICVECTADDR26:
          NxtHRDATA1 = VectAddr26Q;
        `HADDR_VICVECTADDR27:
          NxtHRDATA1 = VectAddr27Q;
        `HADDR_VICVECTADDR28:
          NxtHRDATA1 = VectAddr28Q;
        `HADDR_VICVECTADDR29:
          NxtHRDATA1 = VectAddr29Q;
        `HADDR_VICVECTADDR30:
          NxtHRDATA1 = VectAddr30Q;
        `HADDR_VICVECTADDR31:
          NxtHRDATA1 = VectAddr31Q;
         default :
          NxtHRDATA1 = {32{1'b0}};
       endcase
    end
  else
    begin
      NxtHRDATA1 = {32{1'b0}};
    end
end // p_RegRead1Comb

// -----------------------------------------------------------------------------
// Register read operation. When the AHB initiates the read operation to the
// vector priority registers, combinatorially generate the input of the flip
// flop of the HRDATA for the access of priority registers.
// -----------------------------------------------------------------------------
always @(HADDRQ or ReadEnable or VectPrio0Q or VectPrio1Q or
         VectPrio2Q or VectPrio3Q or VectPrio4Q or VectPrio5Q or
         VectPrio6Q or VectPrio7Q or VectPrio8Q or VectPrio9Q or
         VectPrio10Q or VectPrio11Q or VectPrio12Q or VectPrio13Q or
         VectPrio14Q or VectPrio15Q or VectPrio16Q or VectPrio17Q or
         VectPrio18Q or VectPrio19Q or VectPrio20Q or VectPrio21Q or
         VectPrio22Q or VectPrio23Q or VectPrio24Q or VectPrio25Q or
         VectPrio26Q or VectPrio27Q or VectPrio28Q or VectPrio29Q or
         VectPrio30Q or VectPrio31Q)
begin : p_RegRead2Comb
  if (ReadEnable)
    begin
      case (HADDRQ)
        `HADDR_VICPRIORITY0:
          NxtHRDATA2 = {`TIELOW28, VectPrio0Q};
        `HADDR_VICPRIORITY1:
          NxtHRDATA2 = {`TIELOW28, VectPrio1Q};
        `HADDR_VICPRIORITY2:
          NxtHRDATA2 = {`TIELOW28, VectPrio2Q};
        `HADDR_VICPRIORITY3:
          NxtHRDATA2 = {`TIELOW28, VectPrio3Q};
        `HADDR_VICPRIORITY4:
          NxtHRDATA2 = {`TIELOW28, VectPrio4Q};
        `HADDR_VICPRIORITY5:
          NxtHRDATA2 = {`TIELOW28, VectPrio5Q};
        `HADDR_VICPRIORITY6:
          NxtHRDATA2 = {`TIELOW28, VectPrio6Q};
        `HADDR_VICPRIORITY7:
          NxtHRDATA2 = {`TIELOW28, VectPrio7Q};
        `HADDR_VICPRIORITY8:
          NxtHRDATA2 = {`TIELOW28, VectPrio8Q};
        `HADDR_VICPRIORITY9:
          NxtHRDATA2 = {`TIELOW28, VectPrio9Q};
        `HADDR_VICPRIORITY10:
          NxtHRDATA2 = {`TIELOW28, VectPrio10Q};
        `HADDR_VICPRIORITY11:
          NxtHRDATA2 = {`TIELOW28, VectPrio11Q};
        `HADDR_VICPRIORITY12:
          NxtHRDATA2 = {`TIELOW28, VectPrio12Q};
        `HADDR_VICPRIORITY13:
          NxtHRDATA2 = {`TIELOW28, VectPrio13Q};
        `HADDR_VICPRIORITY14:
          NxtHRDATA2 = {`TIELOW28, VectPrio14Q};
        `HADDR_VICPRIORITY15:
          NxtHRDATA2 = {`TIELOW28, VectPrio15Q};
        `HADDR_VICPRIORITY16:
          NxtHRDATA2 = {`TIELOW28, VectPrio16Q};
        `HADDR_VICPRIORITY17:
          NxtHRDATA2 = {`TIELOW28, VectPrio17Q};
        `HADDR_VICPRIORITY18:
          NxtHRDATA2 = {`TIELOW28, VectPrio18Q};
        `HADDR_VICPRIORITY19:
          NxtHRDATA2 = {`TIELOW28, VectPrio19Q};
        `HADDR_VICPRIORITY20:
          NxtHRDATA2 = {`TIELOW28, VectPrio20Q};
        `HADDR_VICPRIORITY21:
          NxtHRDATA2 = {`TIELOW28, VectPrio21Q};
        `HADDR_VICPRIORITY22:
          NxtHRDATA2 = {`TIELOW28, VectPrio22Q};
        `HADDR_VICPRIORITY23:
          NxtHRDATA2 = {`TIELOW28, VectPrio23Q};
        `HADDR_VICPRIORITY24:
          NxtHRDATA2 = {`TIELOW28, VectPrio24Q};
        `HADDR_VICPRIORITY25:
          NxtHRDATA2 = {`TIELOW28, VectPrio25Q};
        `HADDR_VICPRIORITY26:
          NxtHRDATA2 = {`TIELOW28, VectPrio26Q};
        `HADDR_VICPRIORITY27:
          NxtHRDATA2 = {`TIELOW28, VectPrio27Q};
        `HADDR_VICPRIORITY28:
          NxtHRDATA2 = {`TIELOW28, VectPrio28Q};
        `HADDR_VICPRIORITY29:
          NxtHRDATA2 = {`TIELOW28, VectPrio29Q};
        `HADDR_VICPRIORITY30:
          NxtHRDATA2 = {`TIELOW28, VectPrio30Q};
        `HADDR_VICPRIORITY31:
          NxtHRDATA2 = {`TIELOW28, VectPrio31Q};
         default :
          NxtHRDATA2 = {32{1'b0}};
      endcase
    end
 else
    begin
      NxtHRDATA2  = {32{1'b0}};
    end
end // p_RegRead2Comb

// -----------------------------------------------------------------------------
// Register read operation. When the AHB initiates the read to the control
// registers, use the registered version of the HADDR to select the register.
// -----------------------------------------------------------------------------
always @(HADDRQ or ReadEnable or SWPrioMaskQ or VICIRQStatusQ2 or
         VICFIQStatusQ2 or VICRawIntrQ2 or VICIntSelQ or VICADDRESSQ or
         VICIntEnQ or VICSoftIntQ or ProtEnQ or VectPrio32Q)
begin : p_RegRead3Comb
  if (ReadEnable)
    begin
      case (HADDRQ)
        `HADDR_VICIRQSTATUS:
          HRDATA3 = VICIRQStatusQ2;
        `HADDR_VICFIQSTATUS:
          HRDATA3 = VICFIQStatusQ2;
        `HADDR_VICADDRESS:
          HRDATA3 = VICADDRESSQ;
        `HADDR_VICRAWINTR:
          HRDATA3 = VICRawIntrQ2;
        `HADDR_VICINTSELECT:
          HRDATA3 = VICIntSelQ;
        `HADDR_VICINTENABLE:
          HRDATA3 = VICIntEnQ;
        `HADDR_VICINTENCLEAR:
          HRDATA3 = {32{1'b0}};
        `HADDR_VICSOFTINT:
          HRDATA3 = VICSoftIntQ;
        `HADDR_VICSOFTINTCLEAR:
          HRDATA3 = {32{1'b0}};
        `HADDR_VICPROTECTION:
          HRDATA3 = {31'b0000000000000000000000000000000, ProtEnQ};
        `HADDR_VICSWPRIORITYMASK:
          HRDATA3 = {`TIELOW16, SWPrioMaskQ};
        `HADDR_VICSWPRIORITYDAISY:
          HRDATA3 = {`TIELOW28, VectPrio32Q};
        default:
          HRDATA3 = {32{1'b0}};
      endcase
    end
  else
    begin
      HRDATA3  = {32{1'b0}};
    end
end // p_RegRead3Comb

// -----------------------------------------------------------------------------
// Register read operation. When the AHB initiates the read to the peripheral
// ID registers, use the registered version of the HADDR to select the register.
// -----------------------------------------------------------------------------
always @(HADDRQ or ReadEnable or IDReadMux)
begin : p_RegRead4Comb
  if (ReadEnable)
    begin
      case (HADDRQ)
        `HADDR_VICPERIPHID0:
          HRDATA4 = {`TIELOW24, IDReadMux};
        `HADDR_VICPERIPHID1:
          HRDATA4 = {`TIELOW24, IDReadMux};
        `HADDR_VICPERIPHID2:
          HRDATA4 = {`TIELOW24, IDReadMux};
        `HADDR_VICPERIPHID3:
          HRDATA4 = {`TIELOW24, IDReadMux};
        `HADDR_VICPCELLID0:
          HRDATA4 = {`TIELOW24, IDReadMux};
        `HADDR_VICPCELLID1:
          HRDATA4 = {`TIELOW24, IDReadMux};
        `HADDR_VICPCELLID2:
          HRDATA4 = {`TIELOW24, IDReadMux};
        `HADDR_VICPCELLID3:
          HRDATA4 = {`TIELOW24, IDReadMux};
        default:
          HRDATA4 = {32{1'b0}};
      endcase
    end
  else
    begin
      HRDATA4  = {32{1'b0}};
    end
end // p_RegRead4Comb

// -----------------------------------------------------------------------------
// Register read operation. When the AHB initiates the read to the integration
// registers, use the registered version of the HADDR to select the register.
// -----------------------------------------------------------------------------
always @(HADDRQ or ReadEnable or VICITCRQ or VICFIQINREGQ or VICIRQINREGQ or
         IRQACKTestValQ2 or nIRQINTestValQ2 or nFIQINTestValQ2 or
         VADDRINTestVal or ACKOUTTestValQ2 or VADDRVTestVal or IRQTestValQ2 or
         FIQTestValQ2 or VADDRTestVal or IntSStatusQ or TieLow)
begin : p_RegRead5Comb
  if (ReadEnable)
    begin
      case (HADDRQ)
        `HADDR_VICITCR:
          HRDATA5 = {TieLow[29:0], VICITCRQ};
        `HADDR_VICITIP1:
          HRDATA5 = {TieLow[21:1], VICFIQINREGQ, VICIRQINREGQ,
                     IRQACKTestValQ2, nIRQINTestValQ2, nFIQINTestValQ2,
                     6'b000000};
        `HADDR_VICITIP2:
          HRDATA5 = VADDRINTestVal;
        `HADDR_VICITOP1:
          HRDATA5 = {TieLow[22:1], ACKOUTTestValQ2, VADDRVTestVal,
                     IRQTestValQ2, FIQTestValQ2, 6'b000000};
        `HADDR_VICITOP2:
          HRDATA5 = VADDRTestVal;
        `HADDR_VICINTSSTATUS:
          HRDATA5 = IntSStatusQ;
        default:
          HRDATA5 = {32{1'b0}};
      endcase
    end
  else
    begin
      HRDATA5  = {32{1'b0}};
    end
end // p_RegRead5Comb

// -----------------------------------------------------------------------------
// Register the AHB read data
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_HRDATA1Seq
  if (HRESETn == 1'b0)
    begin
      HRDATA1  <= {32{1'b0}};
      HRDATA2  <= {32{1'b0}};
    end
  else
    begin
      HRDATA1 <= NxtHRDATA1;
      HRDATA2 <= NxtHRDATA2;
    end
end // p_HRDATA1Seq

// -----------------------------------------------------------------------------
// Select the different AHB read bus according to the registered AHB address.
// -----------------------------------------------------------------------------
assign HRDATA = (HRDATA1 | HRDATA2 | HRDATA3 | HRDATA4 | HRDATA5);

// -----------------------------------------------------------------------------
// Clocking the ID read
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_IDRdMuxSeq
  if (HRESETn == 1'b0)
    begin
     IDReadMux  <= {8{1'b0}};
    end
  else
    begin
      IDReadMux <= NxtIDReadMux;
    end
end // p_IDRdMuxSeq

// -----------------------------------------------------------------------------
// Generate control signals for Priority logic
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Reading VICVectAddr (0x008) acknowledges the interrupt
// -----------------------------------------------------------------------------
assign IRQSWAck = ((NxtReadEnable && (HADDR == `HADDR_VICADDRESS)) ?
                   1'b1 : 1'b0);

// -----------------------------------------------------------------------------
// Writing VICVectAddr (0x008) clears the interrupt
// -----------------------------------------------------------------------------
assign IRQSWClear  = ((WriteEnable && (HADDRQ == `HADDR_VICADDRESS)) ?
                         1'b1 : 1'b0);

// -----------------------------------------------------------------------------
// Combinational logic for the ID read
// -----------------------------------------------------------------------------
always @(HREADYIN or HADDR or Revision or IDReadMux)
begin : p_IDReadComb
  if (HREADYIN)
    begin
      case (HADDR[4:2])
        3'b000:
          begin
            NxtIDReadMux  = `PERIPHID0;
          end
        3'b001:
          begin
            NxtIDReadMux  = `PERIPHID1;
          end
        3'b010:
          begin
            NxtIDReadMux  = {Revision ,`PERIPHID2};
          end
        3'b011:
          begin
            NxtIDReadMux  = `PERIPHID3;
          end
        3'b100:
          begin
            NxtIDReadMux  = `PCELLID0;
          end
        3'b101:
          begin
            NxtIDReadMux  = `PCELLID1;
          end
        3'b110:
          begin
            NxtIDReadMux  = `PCELLID2;
          end
        default:
          begin
            NxtIDReadMux  = `PCELLID3;
          end
      endcase
    end
  else
    begin
      NxtIDReadMux = IDReadMux;
    end
end // p_IDReadComb

// -----------------------------------------------------------------------------
// Connect signals to top level
// -----------------------------------------------------------------------------
assign  VICSoftInt       = VICSoftIntQ;
assign  VICIntEnable     = VICIntEnQ;
assign  VICIntSelect     = VICIntSelQ;
assign  SWPriorityMask   = SWPrioMaskQ;
assign  VectAddr0        = VectAddr0Q;
assign  VectAddr1        = VectAddr1Q;
assign  VectAddr2        = VectAddr2Q;
assign  VectAddr3        = VectAddr3Q;
assign  VectAddr4        = VectAddr4Q;
assign  VectAddr5        = VectAddr5Q;
assign  VectAddr6        = VectAddr6Q;
assign  VectAddr7        = VectAddr7Q;
assign  VectAddr8        = VectAddr8Q;
assign  VectAddr9        = VectAddr9Q;
assign  VectAddr10       = VectAddr10Q;
assign  VectAddr11       = VectAddr11Q;
assign  VectAddr12       = VectAddr12Q;
assign  VectAddr13       = VectAddr13Q;
assign  VectAddr14       = VectAddr14Q;
assign  VectAddr15       = VectAddr15Q;
assign  VectAddr16       = VectAddr16Q;
assign  VectAddr17       = VectAddr17Q;
assign  VectAddr18       = VectAddr18Q;
assign  VectAddr19       = VectAddr19Q;
assign  VectAddr20       = VectAddr20Q;
assign  VectAddr21       = VectAddr21Q;
assign  VectAddr22       = VectAddr22Q;
assign  VectAddr23       = VectAddr23Q;
assign  VectAddr24       = VectAddr24Q;
assign  VectAddr25       = VectAddr25Q;
assign  VectAddr26       = VectAddr26Q;
assign  VectAddr27       = VectAddr27Q;
assign  VectAddr28       = VectAddr28Q;
assign  VectAddr29       = VectAddr29Q;
assign  VectAddr30       = VectAddr30Q;
assign  VectAddr31       = VectAddr31Q;
assign  VectPriority0    = VectPrio0Q;
assign  VectPriority1    = VectPrio1Q;
assign  VectPriority2    = VectPrio2Q;
assign  VectPriority3    = VectPrio3Q;
assign  VectPriority4    = VectPrio4Q;
assign  VectPriority5    = VectPrio5Q;
assign  VectPriority6    = VectPrio6Q;
assign  VectPriority7    = VectPrio7Q;
assign  VectPriority8    = VectPrio8Q;
assign  VectPriority9    = VectPrio9Q;
assign  VectPriority10   = VectPrio10Q;
assign  VectPriority11   = VectPrio11Q;
assign  VectPriority12   = VectPrio12Q;
assign  VectPriority13   = VectPrio13Q;
assign  VectPriority14   = VectPrio14Q;
assign  VectPriority15   = VectPrio15Q;
assign  VectPriority16   = VectPrio16Q;
assign  VectPriority17   = VectPrio17Q;
assign  VectPriority18   = VectPrio18Q;
assign  VectPriority19   = VectPrio19Q;
assign  VectPriority20   = VectPrio20Q;
assign  VectPriority21   = VectPrio21Q;
assign  VectPriority22   = VectPrio22Q;
assign  VectPriority23   = VectPrio23Q;
assign  VectPriority24   = VectPrio24Q;
assign  VectPriority25   = VectPrio25Q;
assign  VectPriority26   = VectPrio26Q;
assign  VectPriority27   = VectPrio27Q;
assign  VectPriority28   = VectPrio28Q;
assign  VectPriority29   = VectPrio29Q;
assign  VectPriority30   = VectPrio30Q;
assign  VectPriority31   = VectPrio31Q;
assign  VectPriority32   = VectPrio32Q;
assign  ITEN             = VICITCRQ[0];
assign  IRQACKForceVal   = VICITIP1Q[8];
assign  nIRQINForceVal   = VICITIP1Q[7];
assign  nFIQINForceVal   = VICITIP1Q[6];
assign  VECTADDRINFrcVal = VICITIP2Q;
assign  IRQACKOUTFrcVal  = VICITOP1Q[9];
assign  VECTADDRVFrcVal  = VICITOP1Q[8];
assign  IRQForceVal      = VICITOP1Q[7];
assign  FIQForceVal      = VICITOP1Q[6];
assign  VECTADDRFrcVal   = VICITOP2Q;

// -----------------------------------------------------------------------------
// Assign zeros to the TieLow
// -----------------------------------------------------------------------------
assign TieLow = 30'b000000000000000000000000000000;

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
