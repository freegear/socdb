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
// File Name              : VicTrAhbif.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module implements the AHB Interface and Register
//           block.
//
// --=========================================================================--

`timescale 1ns/1ps

// Include Parameter File
`include "VicTrParams.v"

// -----------------------------------------------------------------------------

module VicTrAhbif (
// Inputs
                   HCLK,
                   HRESETn,
                   HREADYIN,
                   HADDR,
                   HTRANS,
                   HSIZE,
                   HWRITE,
                   HPROT,
                   HWDATA,
                   HSELVICTR,
                   HSELVIC,
                   VICTrVectAddr,
                   nVICFIQ,
                   nVICIRQ,
                   VICVECTADDROUT,
                   VICVECTADDRV,

// Outputs
                   HRDATA,
                   HREADYOUT,
                   HRESP,
                   VICTrTCR,
                   VICINTSOURCE,
                   VICVECTADDRIN,
                   nVICFIQIN,
                   nVICIRQIN,
                   VICIRQINREG,
                   VICFIQINREG,
                   nVICSYNCEN,
                   VICTrSoftInt,
                   VICTrIntEnable,
                   VICTrIntSelect,
                   VICTrSwPriMask,
                   VICTrVectPriDsy,
                   VICTrVectPrity0,
                   VICTrVectPrity1,
                   VICTrVectPrity2,
                   VICTrVectPrity3,
                   VICTrVectPrity4,
                   VICTrVectPrity5,
                   VICTrVectPrity6,
                   VICTrVectPrity7,
                   VICTrVectPrity8,
                   VICTrVectPrity9,
                   VICTrVectPrity10,
                   VICTrVectPrity11,
                   VICTrVectPrity12,
                   VICTrVectPrity13,
                   VICTrVectPrity14,
                   VICTrVectPrity15,
                   VICTrVectPrity16,
                   VICTrVectPrity17,
                   VICTrVectPrity18,
                   VICTrVectPrity19,
                   VICTrVectPrity20,
                   VICTrVectPrity21,
                   VICTrVectPrity22,
                   VICTrVectPrity23,
                   VICTrVectPrity24,
                   VICTrVectPrity25,
                   VICTrVectPrity26,
                   VICTrVectPrity27,
                   VICTrVectPrity28,
                   VICTrVectPrity29,
                   VICTrVectPrity30,
                   VICTrVectPrity31,
                   VICTrVectAddr0,
                   VICTrVectAddr1,
                   VICTrVectAddr2,
                   VICTrVectAddr3,
                   VICTrVectAddr4,
                   VICTrVectAddr5,
                   VICTrVectAddr6,
                   VICTrVectAddr7,
                   VICTrVectAddr8,
                   VICTrVectAddr9,
                   VICTrVectAddr10,
                   VICTrVectAddr11,
                   VICTrVectAddr12,
                   VICTrVectAddr13,
                   VICTrVectAddr14,
                   VICTrVectAddr15,
                   VICTrVectAddr16,
                   VICTrVectAddr17,
                   VICTrVectAddr18,
                   VICTrVectAddr19,
                   VICTrVectAddr20,
                   VICTrVectAddr21,
                   VICTrVectAddr22,
                   VICTrVectAddr23,
                   VICTrVectAddr24,
                   VICTrVectAddr25,
                   VICTrVectAddr26,
                   VICTrVectAddr27,
                   VICTrVectAddr28,
                   VICTrVectAddr29,
                   VICTrVectAddr30,
                   VICTrVectAddr31,
                   VICACKOUT,
                   HCLKTRICK,
                   VectAddrWrTrig,
                   VectAddrRdTrig,
                   AsyncRdEn
                   );

parameter tovmaxintsrc     = 1;
parameter tovmaxackcnt     = 1;
parameter tovmaxnvicfiqin  = 1;
parameter tovmaxnvicirqin  = 1;
parameter tovmaxvectadin   = 1;
parameter tovmaxnvicsynin  = 1;

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input         HREADYIN;         // Transfer Ready Signal
input  [11:2] HADDR;            // Address Bus for AHB Slave
input         HTRANS;           // Transfer signal for AHB Slave
input   [2:0] HSIZE;            // AHB Transfer size
input         HWRITE;           // Write Signal for AHB Slave
input         HPROT;            // Protection Control signal
input  [31:0] HWDATA;           // Write Data input for AHB Slave
input         HSELVICTR;        // Slave Select Signal for the VIC
                                // Trickbox
input         HSELVIC;          // Slave Select Signal for the VIC
input  [31:0] VICTrVectAddr;    // Vector address from the Mirrored VIC
                                // Model
input         nVICFIQ;          // nVICFIQ output from the VIC
input         nVICIRQ;          // nVICIRQ output from the VIC
input  [31:0] VICVECTADDROUT;   // Input lines for reading
                                // VICVECTADDROUT
input         VICVECTADDRV;     // Vector Address Valid signal from VIC

// Outputs
output [31:0] HRDATA;           // Read Data output from AHB Slave
output        HREADYOUT;        // Ready Signal from AHB Slave
output  [1:0] HRESP;            // Transfer Response from AHB Slave
output  [8:0] VICTrTCR;         // Compare Enable signals for VicTrProtChkr
output [31:0] VICINTSOURCE;     // Output lines for raising Interrupt
                                // requests to the VIC
output [31:0] VICVECTADDRIN;    // VICVECTADDRIN RegisterDaisy chain Vector
                                // address signal to the VIC
output        nVICFIQIN;        // nVICFIQIN Daisy chain signal to the
                                // VIC
output        nVICIRQIN;        // nVICIRQIN Daisy chain signal to the
                                // VIC
output        VICIRQINREG;      // VICIRQINREG Daisy chain signal 
output        VICFIQINREG;      // VICFIQINREG Daisy chain signal 
output        nVICSYNCEN;       // nVICSYNCEN Sync Enable signal

output [31:0] VICTrSoftInt;     // SoftInt output signal 
output [31:0] VICTrIntEnable;   // IntEnable output signal 
output [31:0] VICTrIntSelect;   // IntSelect output signal 
output [15:0] VICTrSwPriMask;   // VIC software priority mask signal 
output  [3:0] VICTrVectPriDsy;  // Programmed Priority for Daisy Chain 
                                // Interrupt 
output [31:0] VICTrVectAddr0;   // VectorAddr0 output signal 
output [31:0] VICTrVectAddr1;   // VectorAddr1 output signal
output [31:0] VICTrVectAddr2;   // VectorAddr2 output signal 
output [31:0] VICTrVectAddr3;   // VectorAddr3 output signal 
output [31:0] VICTrVectAddr4;   // VectorAddr4 output signal 
output [31:0] VICTrVectAddr5;   // VectorAddr5 output signal 
output [31:0] VICTrVectAddr6;   // VectorAddr6 output signal 
output [31:0] VICTrVectAddr7;   // VectorAddr7 output signal 
output [31:0] VICTrVectAddr8;   // VectorAddr8 output signal 
output [31:0] VICTrVectAddr9;   // VectorAddr9 output signal 
output [31:0] VICTrVectAddr10;  // VectorAddr10 output signal 
output [31:0] VICTrVectAddr11;  // VectorAddr11 output signal 
output [31:0] VICTrVectAddr12;  // VectorAddr12 output signal 
output [31:0] VICTrVectAddr13;  // VectorAddr13 output signal 
output [31:0] VICTrVectAddr14;  // VectorAddr14 output signal 
output [31:0] VICTrVectAddr15;  // VectorAddr15 output signal 
output [31:0] VICTrVectAddr16;  // VectorAddr16 output signal 
output [31:0] VICTrVectAddr17;  // VectorAddr17 output signal 
output [31:0] VICTrVectAddr18;  // VectorAddr18 output signal 
output [31:0] VICTrVectAddr19;  // VectorAddr19 output signal 
output [31:0] VICTrVectAddr20;  // VectorAddr20 output signal 
output [31:0] VICTrVectAddr21;  // VectorAddr21 output signal 
output [31:0] VICTrVectAddr22;  // VectorAddr22 output signal 
output [31:0] VICTrVectAddr23;  // VectorAddr23 output signal 
output [31:0] VICTrVectAddr24;  // VectorAddr24 output signal 
output [31:0] VICTrVectAddr25;  // VectorAddr25 output signal 
output [31:0] VICTrVectAddr26;  // VectorAddr26 output signal 
output [31:0] VICTrVectAddr27;  // VectorAddr27 output signal 
output [31:0] VICTrVectAddr28;  // VectorAddr28 output signal 
output [31:0] VICTrVectAddr29;  // VectorAddr29 output signal 
output [31:0] VICTrVectAddr30;  // VectorAddr30 output signal 
output [31:0] VICTrVectAddr31;  // VectorAddr31 output signal 
output  [3:0] VICTrVectPrity0;  // VectorPriority reg0 output signal 
output  [3:0] VICTrVectPrity1;  // VectorPriority reg1 output signal
output  [3:0] VICTrVectPrity2;  // VectorPriority reg2 output signal 
output  [3:0] VICTrVectPrity3;  // VectorPriority reg3 output signal 
output  [3:0] VICTrVectPrity4;  // VectorPriority reg4 output signal 
output  [3:0] VICTrVectPrity5;  // VectorPriority reg5 output signal 
output  [3:0] VICTrVectPrity6;  // VectorPriority reg6 output signal 
output  [3:0] VICTrVectPrity7;  // VectorPriority reg7 output signal 
output  [3:0] VICTrVectPrity8;  // VectorPriority reg8 output signal 
output  [3:0] VICTrVectPrity9;  // VectorPriority reg9 output signal 
output  [3:0] VICTrVectPrity10; // VectorPriority reg10 output signal 
output  [3:0] VICTrVectPrity11; // VectorPriority reg11 output signal 
output  [3:0] VICTrVectPrity12; // VectorPriority reg12 output signal 
output  [3:0] VICTrVectPrity13; // VectorPriority reg13 output signal 
output  [3:0] VICTrVectPrity14; // VectorPriority reg14 output signal 
output  [3:0] VICTrVectPrity15; // VectorPriority reg15 output signal 
output  [3:0] VICTrVectPrity16; // VectorPriority reg16 output signal 
output  [3:0] VICTrVectPrity17; // VectorPriority reg17 output signal 
output  [3:0] VICTrVectPrity18; // VectorPriority reg18 output signal 
output  [3:0] VICTrVectPrity19; // VectorPriority reg19 output signal 
output  [3:0] VICTrVectPrity20; // VectorPriority reg20 output signal 
output  [3:0] VICTrVectPrity21; // VectorPriority reg21 output signal 
output  [3:0] VICTrVectPrity22; // VectorPriority reg22 output signal 
output  [3:0] VICTrVectPrity23; // VectorPriority reg23 output signal 
output  [3:0] VICTrVectPrity24; // VectorPriority reg24 output signal 
output  [3:0] VICTrVectPrity25; // VectorPriority reg25 output signal 
output  [3:0] VICTrVectPrity26; // VectorPriority reg26 output signal 
output  [3:0] VICTrVectPrity27; // VectorPriority reg27 output signal 
output  [3:0] VICTrVectPrity28; // VectorPriority reg28 output signal 
output  [3:0] VICTrVectPrity29; // VectorPriority reg29 output signal 
output  [3:0] VICTrVectPrity30; // VectorPriority reg30 output signal 
output  [3:0] VICTrVectPrity31; // VectorPriority reg31 output signal 
output        VICACKOUT;        // Acknowledge signal to uut and Mirror 
                                // Trickbox
output        HCLKTRICK;        // Clock to UUT and mirrored trickbox.
                                // If bit 5 in VICTrTCR is set the is 
                                // turned off 
output        VectAddrWrTrig;   // Write Enable signal on VICTrVectAddr 
                                // register 
output        VectAddrRdTrig;   // Read enable signal on VICTrVectAddr 
                                // register 
output        AsyncRdEn;        // Asynchronous read enable to
                                // Mirrored Trickbox

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire          HREADYIN;         // Transfer Ready Signal
wire   [11:2] HADDR;            // Address Bus for AHB Slave
wire          HTRANS;           // Transfer signal for AHB Slave
wire    [2:0] HSIZE;            // AHB Transfer size
wire          HWRITE;           // Write Signal for AHB Slave
wire          HPROT;            // Protection Control signal
wire   [31:0] HWDATA;           // Write Data input for AHB Slave
wire          HSELVICTR;        // Slave Select Signal for the VIC
                                // Trickbox
wire          HSELVIC;          // Slave Select Signal for the VIC
wire   [31:0] VICTrVectAddr;    // Vector address from the Mirrored VIC
                                // Model
wire          nVICFIQ;          // nVICFIQ output from the VIC
wire          nVICIRQ;          // nVICIRQ output from the VIC
wire   [31:0] VICVECTADDROUT;   // Input lines for reading
                                // VICVECTADDROUT
wire          VICVECTADDRV;     // Vector Address Valid signal from VIC

// Outputs
wire   [31:0] HRDATA;           // Read Data output from AHB Slave
reg           HREADYOUT;        // Ready Signal from AHB Slave
wire    [1:0] HRESP;            // Transfer Response from AHB Slave

reg     [8:0] VICTrTCR;         // Compare Enable signals for
                                // VicTrProtChkr
reg    [31:0] VICINTSOURCE;     // Output lines for raising Interrupt
                                // requests to the VIC
reg    [31:0] VICVECTADDRIN;    // VICVECTADDRIN Daisy chain Vector
                                // address signal to the VIC
reg           nVICFIQIN;        // nVICFIQIN Daisy chain signal to the
                                // VIC
reg           nVICIRQIN;        // nVICIRQIN Daisy chain signal to the
                                // VIC
reg           VICIRQINREG;      // VICIRQINREG Daisy chain signal 
reg           VICFIQINREG;      // VICFIQINREG Daisy chain signal 
reg           nVICSYNCEN;       // nVICSYNCEN Sync Enable signal

reg    [31:0] VICTrSoftInt;     // SoftInt output signal 
reg    [31:0] VICTrIntEnable;   // IntEnable output signal 
reg    [31:0] VICTrIntSelect;   // IntSelect output signal 
reg    [15:0] VICTrSwPriMask;   // VIC software priority mask signal 
reg     [3:0] VICTrVectPriDsy;  // Programmed Priority for Daisy Chain 
reg    [31:0] VICTrVectAddr0;   // Mirrored VICVectorAddr0 register
reg    [31:0] VICTrVectAddr1;   // Mirrored VICVectorAddr1 register
reg    [31:0] VICTrVectAddr2;   // Mirrored VICVectorAddr2 register
reg    [31:0] VICTrVectAddr3;   // Mirrored VICVectorAddr3 register
reg    [31:0] VICTrVectAddr4;   // Mirrored VICVectorAddr4 register
reg    [31:0] VICTrVectAddr5;   // Mirrored VICVectorAddr5 register
reg    [31:0] VICTrVectAddr6;   // Mirrored VICVectorAddr6 register
reg    [31:0] VICTrVectAddr7;   // Mirrored VICVectorAddr7 register
reg    [31:0] VICTrVectAddr8;   // Mirrored VICVectorAddr8 register
reg    [31:0] VICTrVectAddr9;   // Mirrored VICVectorAddr9 register
reg    [31:0] VICTrVectAddr10;  // Mirrored VICVectorAddr10 register
reg    [31:0] VICTrVectAddr11;  // Mirrored VICVectorAddr11 register
reg    [31:0] VICTrVectAddr12;  // Mirrored VICVectorAddr12 register
reg    [31:0] VICTrVectAddr13;  // Mirrored VICVectorAddr13 register
reg    [31:0] VICTrVectAddr14;  // Mirrored VICVectorAddr14 register
reg    [31:0] VICTrVectAddr15;  // Mirrored VICVectorAddr15 register
reg    [31:0] VICTrVectAddr16;  // Mirrored VICVectorAddr16 register 
reg    [31:0] VICTrVectAddr17;  // Mirrored VICVectorAddr17 register 
reg    [31:0] VICTrVectAddr18;  // Mirrored VICVectorAddr18 register 
reg    [31:0] VICTrVectAddr19;  // Mirrored VICVectorAddr19 register 
reg    [31:0] VICTrVectAddr20;  // Mirrored VICVectorAddr20 register 
reg    [31:0] VICTrVectAddr21;  // Mirrored VICVectorAddr21 register 
reg    [31:0] VICTrVectAddr22;  // Mirrored VICVectorAddr22 register 
reg    [31:0] VICTrVectAddr23;  // Mirrored VICVectorAddr23 register 
reg    [31:0] VICTrVectAddr24;  // Mirrored VICVectorAddr24 register 
reg    [31:0] VICTrVectAddr25;  // Mirrored VICVectorAddr25 register 
reg    [31:0] VICTrVectAddr26;  // Mirrored VICVectorAddr26 register 
reg    [31:0] VICTrVectAddr27;  // Mirrored VICVectorAddr27 register 
reg    [31:0] VICTrVectAddr28;  // Mirrored VICVectorAddr28 register 
reg    [31:0] VICTrVectAddr29;  // Mirrored VICVectorAddr29 register 
reg    [31:0] VICTrVectAddr30;  // Mirrored VICVectorAddr30 register 
reg    [31:0] VICTrVectAddr31;  // Mirrored VICVectorAddr31 register 
reg     [3:0] VICTrVectPrity0;  // Mirrored VectorPriority0 register 
reg     [3:0] VICTrVectPrity1;  // Mirrored VectorPriority1 register
reg     [3:0] VICTrVectPrity2;  // Mirrored VectorPriority2 register
reg     [3:0] VICTrVectPrity3;  // Mirrored VectorPriority3 register
reg     [3:0] VICTrVectPrity4;  // Mirrored VectorPriority4 register
reg     [3:0] VICTrVectPrity5;  // Mirrored VectorPriority5 register
reg     [3:0] VICTrVectPrity6;  // Mirrored VectorPriority6 register
reg     [3:0] VICTrVectPrity7;  // Mirrored VectorPriority7 register
reg     [3:0] VICTrVectPrity8;  // Mirrored VectorPriority8 register
reg     [3:0] VICTrVectPrity9;  // Mirrored VectorPriority9 register
reg     [3:0] VICTrVectPrity10; // Mirrored VectorPriority10 register
reg     [3:0] VICTrVectPrity11; // Mirrored VectorPriority11 register
reg     [3:0] VICTrVectPrity12; // Mirrored VectorPriority12 register
reg     [3:0] VICTrVectPrity13; // Mirrored VectorPriority13 register
reg     [3:0] VICTrVectPrity14; // Mirrored VectorPriority14 register
reg     [3:0] VICTrVectPrity15; // Mirrored VectorPriority15 register
reg     [3:0] VICTrVectPrity16; // Mirrored VectorPriority16 register
reg     [3:0] VICTrVectPrity17; // Mirrored VectorPriority17 register
reg     [3:0] VICTrVectPrity18; // Mirrored VectorPriority18 register
reg     [3:0] VICTrVectPrity19; // Mirrored VectorPriority19 register
reg     [3:0] VICTrVectPrity20; // Mirrored VectorPriority20 register
reg     [3:0] VICTrVectPrity21; // Mirrored VectorPriority21 register
reg     [3:0] VICTrVectPrity22; // Mirrored VectorPriority22 register
reg     [3:0] VICTrVectPrity23; // Mirrored VectorPriority23 register
reg     [3:0] VICTrVectPrity24; // Mirrored VectorPriority24 register
reg     [3:0] VICTrVectPrity25; // Mirrored VectorPriority25 register
reg     [3:0] VICTrVectPrity26; // Mirrored VectorPriority26 register
reg     [3:0] VICTrVectPrity27; // Mirrored VectorPriority27 register
reg     [3:0] VICTrVectPrity28; // Mirrored VectorPriority28 register
reg     [3:0] VICTrVectPrity29; // Mirrored VectorPriority29 register
reg     [3:0] VICTrVectPrity30; // Mirrored VectorPriority30 register
reg     [3:0] VICTrVectPrity31; // Mirrored VectorPriority31 register
wire          VICACKOUT;        // Ack signal to uut and Mirror 
                                // Trickbox
wire          HCLKTRICK;        // Clock to UUT and mirrored trickbox.
                                // If bit 5 in VICTrTCR is set the is 
                                // turned off 
wire          VectAddrWrTrig;   // Write Enable signal on VICTrVectAddr 
                                // register 
wire          VectAddrRdTrig;   // Read enable signal on VICTrVectAddr 
                                // register 
wire          AsyncRdEn;        // Asynchronous read enable to 
                                // Mirrored Trickbox

// -----------------------------------------------------------------------------
//
//                             VicTrAhbif
//                             ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block interfaces the Trickbox with the AHB. It decodes AHB
// accesses and generates the write strobes to appropriate registers.
// This module also contains the output data multiplexer that forms the
// read interface. Slave response signals are generated from this
// module. This block implements both the VIC Mirrored and the
// Trickbox specific registers.
// -----------------------------------------------------------------------------
// VIC Registers                                                          
// =============                                                          
// VICTrVectAddr     0xF00  32   R/W  Interrupt Vector Address            
// VICTrIntSelect    0x00C  32   R/W  Select IRQ or FIQ interrupts 
// VICTrIntEnable    0x010  32   R/W  Interrupt Enable                    
// VICTrIntEnClear   0x014  32   W    Interrupt Enable Clear              
// VICTrSoftInt      0x018  32   R/W  To generate Software interrupts
// VICTrSoftIntClear 0x01C  32   W    Software Interrupt Clear            
// VICTrProtection   0x020  1    R/W  Protection Enable Register          
// VICTrSwPriMask    0x024  16   R/W  Software priority mask
// VICTrVectPriDsy   0x028  4    R/W  Daisy Interrupt Priority
// VICTrVectAddr0-31 0x100- 32   R/W  Interrupt Vector Addresses from 0 to 31 
//                   0x17C                                    
// VICTrVectPrity0   0x200- 4    R/W  Interrupt Vector Control from 0 to 31 
// -31               0x27C            from 0 to 15                        
// -----------------------------------------------------------------------------
// Note :
//   A write to a VIC register will automatically update its mirrored
// register as well. If these mirrored VIC registers are accessed using
// the VIC Base address, the Trickbox returns zeroes on the HRDATA bus.
// However, if these registers are accessed using the Trickbox Base
// address (instead of the VIC Base address), their current contents are
// reflected onto the HRDATA bus.
// -----------------------------------------------------------------------------
// Vic Trickbox-specific Registers [offsets are from Trickbox        
//                                  Base address]                    
// -----------------------------------------------------------------------------
// VICTrTCR          0x050  9    R/W  Error Message Enable & Clock Off
// VICTrIntSource    0x054  32   R/W  Interrupt Source               
// VICTrStatus       0x058  2    R    FIQ and IRQ Status             
// VICTrVectAddrOut  0x05C  32   R    VICVECTADDROUT Status          
// VICTrIntIn        0x060  2    R/W  nVICFIQIN and nVICIRQIN        
// VICTrIntInReg     0x064  2    R/W  Register enable nVICFIQIN and nVICIRQIN     
// VICTrVectAddrIn   0x068  32   R/W  VICVECTADDRIN Source      
// VicTrSync         0x06C  1    R/W  Sync Enable register
// VicTrAckCnt       0x074  4    R/W  Cnt to control Acknowledge generation     
// VICTrWaitStReg    0x078  32   R/W  A location accessible with     
//                                    Non-zero wait states.          
//                                    Returns 0x55555555             
//                                    when read              
//
// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
integer     WaitCount;
// Wait State Counter

wire        NewAccess;
// New Access to Trickbox or the VIC

wire        NxtBusEn;
// D-input of BusEn

wire        NxtRdAccess;
// D-input of RdAccess

wire        NxtWrAccess;
// D-input of WrAccess

wire        MrAccessEn;
// Mirrored registers access enable signal

wire        NxtMrWrAccess;
// D-input of MrWrAccess

wire        NxtMrRdAccess;
// D-input of MrRdAccess

wire        NxtDeviceSel;
// D-input of DeviceSel

wire [11:2] NxtAddr;
// D-input of Addr

wire [31:0] RdData1;
// Internal Read Data bus1

wire [31:0] RdData2;
// Internal Read Data bus2

wire [31:0] RdData3;
// Internal Read Data bus3

wire [31:0] RdData;
// Internal Read Data bus

wire        IntSelectEn;
// VICTrIntSelect Access Enable signal

wire        SwPrityMaskEn;
// VICTrSwPriMask Access Enable signal

wire        IntEnableEn;
// VICTrIntEnable Access Enable signal

wire        IntEnClearEn;
// VICTrIntEnableClear Access Enable signal

wire        SoftIntEn;
// VICTrSoftInt Access Enable signal

wire        SoftIntClearEn;
// VICTrSoftIntClear Access Enable signal

wire        ProtectionEn;
// VICTrProtection Access Enable signal

wire        VectAddrEn;
// VICTrVectAddr Access Enable signal

wire        VectAddrEnA;
// Asynchronous VICTrVectAddr Access Enable signal

wire        VectAddr0En;
// VICTrVectAddr0 Access Enable signal

wire        VectAddr1En;
// VICTrVectAddr1 Access Enable signal

wire        VectAddr2En;
// VICTrVectAddr2 Access Enable signal

wire        VectAddr3En;
// VICTrVectAddr3 Access Enable signal

wire        VectAddr4En;
// VICTrVectAddr4 Access Enable signal

wire        VectAddr5En;
// VICTrVectAddr5 Access Enable signal

wire        VectAddr6En;
// VICTrVectAddr6 Access Enable signal

wire        VectAddr7En;
// VICTrVectAddr7 Access Enable signal

wire        VectAddr8En;
// VICTrVectAddr8 Access Enable signal

wire        VectAddr9En;
// VICTrVectAddr9 Access Enable signal

wire        VectAddr10En;
// VICTrVectAddr10 Access Enable signal

wire        VectAddr11En;
// VICTrVectAddr11 Access Enable signal

wire        VectAddr12En;
// VICTrVectAddr12 Access Enable signal

wire        VectAddr13En;
// VICTrVectAddr13 Access Enable signal

wire        VectAddr14En;
// VICTrVectAddr14 Access Enable signal

wire        VectAddr15En;
// VICTrVectAddr15 Access Enable signal

wire        VectAddr16En;
// VICTrVectAddr16 Access Enable signal

wire        VectAddr17En;
// VICTrVectAddr17 Access Enable signal

wire        VectAddr18En;
// VICTrVectAddr18 Access Enable signal

wire        VectAddr19En;
// VICTrVectAddr19 Access Enable signal

wire        VectAddr20En;
// VICTrVectAddr20 Access Enable signal

wire        VectAddr21En;
// VICTrVectAddr21 Access Enable signal

wire        VectAddr22En;
// VICTrVectAddr22 Access Enable signal

wire        VectAddr23En;
// VICTrVectAddr23 Access Enable signal

wire        VectAddr24En;
// VICTrVectAddr24 Access Enable signal

wire        VectAddr25En;
// VICTrVectAddr25 Access Enable signal

wire        VectAddr26En;
// VICTrVectAddr26 Access Enable signal

wire        VectAddr27En;
// VICTrVectAddr27 Access Enable signal

wire        VectAddr28En;
// VICTrVectAddr28 Access Enable signal

wire        VectAddr29En;
// VICTrVectAddr29 Access Enable signal

wire        VectAddr30En;
// VICTrVectAddr30 Access Enable signal

wire        VectAddr31En;
// VICTrVectAddr31 Access Enable signal

wire        VectPrity0En;
// VICTrVectPrity0 Access Enable signal
 
wire        VectPrity1En;
// VICTrVectPrity1 Access Enable signal
 
wire        VectPrity2En;
// VICTrVectPrity2 Access Enable signal
 
wire        VectPrity3En;
// VICTrVectPrity3 Access Enable signal
 
wire        VectPrity4En;
// VICTrVectPrity4 Access Enable signal
 
wire        VectPrity5En;
// VICTrVectPrity5 Access Enable signal
 
wire        VectPrity6En;
// VICTrVectPrity6 Access Enable signal
 
wire        VectPrity7En;
// VICTrVectPrity7 Access Enable signal
 
wire        VectPrity8En;
// VICTrVectPrity8 Access Enable signal
 
wire        VectPrity9En;
// VICTrVectPrity9 Access Enable signal
 
wire        VectPrity10En;
// VICTrVectPrity10 Access Enable signal
 
wire        VectPrity11En;
// VICTrVectPrity11 Access Enable signal
 
wire        VectPrity12En;
// VICTrVectPrity12 Access Enable signal
 
wire        VectPrity13En;
// VICTrVectPrity13 Access Enable signal
 
wire        VectPrity14En;
// VICTrVectPrity14 Access Enable signal
 
wire        VectPrity15En;
// VICTrVectPrity15 Access Enable signal
 
wire        VectPrity16En;
// VICTrVectPrity16 Access Enable signal
 
wire        VectPrity17En;
// VICTrVectPrity17 Access Enable signal
 
wire        VectPrity18En;
// VICTrVectPrity18 Access Enable signal
 
wire        VectPrity19En;
// VICTrVectPrity19 Access Enable signal
 
wire        VectPrity20En;
// VICTrVectPrity20 Access Enable signal
 
wire        VectPrity21En;
// VICTrVectPrity21 Access Enable signal
 
wire        VectPrity22En;
// VICTrVectPrity22 Access Enable signal
 
wire        VectPrity23En;
// VICTrVectPrity23 Access Enable signal
 
wire        VectPrity24En;
// VICTrVectPrity24 Access Enable signal
 
wire        VectPrity25En;
// VICTrVectPrity25 Access Enable signal
 
wire        VectPrity26En;
// VICTrVectPrity26 Access Enable signal
 
wire        VectPrity27En;
// VICTrVectPrity27 Access Enable signal
 
wire        VectPrity28En;
// VICTrVectPrity28 Access Enable signal
 
wire        VectPrity29En;
// VICTrVectPrity29 Access Enable signal
 
wire        VectPrity30En;
// VICTrVectPrity30 Access Enable signal
 
wire        VectPrity31En;
// VICTrVectPrity31 Access Enable signal

wire        VectPrityDsyEn;
// VICTrVectPriDsy Access Enable signal

wire        VICTrTCREn;
// VICTrTCR Access Enable signal

wire        TrIntSourceEn;
// VICTrIntSource Access Enable signal

wire        TrStatusEn;
// VICTrStatus Access Enable signal

wire        TrIntInEn;
// VICTrIntIn Access Enable signal

wire        TrIntInRegEn;
// VICTrIntInReg Access Enable signal

wire        TrSyncEn;
// VICTrSync Access Enable signal

wire        TrAckCntEn;
// VICTrAckCnt Access Enable signal

wire        TrVectAdInEn;
// VICTrVectAddrIn Access Enable signal

wire        TrVectAdOutEn;
// VICVECTADDROUT Access Enable signal

wire        WaitStRegEn;
// VICTrWaitStReg Access Enable signal

wire        IntSelectRdEn;
// VICTrIntSelect Read Access Enable signal

wire        SwPrityMaskRdEn;
// VICTrSwPriMask Read Access Enable signal

wire        IntEnableRdEn;
// VICTrIntEnable Read Access Enable signal

wire        SoftIntRdEn;
// VICTrSoftInt Read Access Enable signal

wire        ProtectionRdEn;
// VICTrProtection Read Access Enable signal

wire        VectAddrRdEn;
// VICTrVectAddr Read Access Enable signal

wire        VectAddr0RdEn;
// VICTrVectAddr0 Read Access Enable signal

wire        VectAddr1RdEn;
// VICTrVectAddr1 Read Access Enable signal

wire        VectAddr2RdEn;
// VICTrVectAddr2 Read Access Enable signal

wire        VectAddr3RdEn;
// VICTrVectAddr3 Read Access Enable signal

wire        VectAddr4RdEn;
// VICTrVectAddr4 Read Access Enable signal

wire        VectAddr5RdEn;
// VICTrVectAddr5 Read Access Enable signal

wire        VectAddr6RdEn;
// VICTrVectAddr6 Read Access Enable signal

wire        VectAddr7RdEn;
// VICTrVectAddr7 Read Access Enable signal

wire        VectAddr8RdEn;
// VICTrVectAddr8 Read Access Enable signal

wire        VectAddr9RdEn;
// VICTrVectAddr9 Read Access Enable signal

wire        VectAddr10RdEn;
// VICTrVectAddr10 Read Access Enable signal

wire        VectAddr11RdEn;
// VICTrVectAddr11 Read Access Enable signal

wire        VectAddr12RdEn;
// VICTrVectAddr12 Read Access Enable signal

wire        VectAddr13RdEn;
// VICTrVectAddr13 Read Access Enable signal

wire        VectAddr14RdEn;
// VICTrVectAddr14 Read Access Enable signal

wire        VectAddr15RdEn;
// VICTrVectAddr15 Read Access Enable signal

wire        VectAddr16RdEn;
// VICTrVectAddr16 Read Access Enable signal

wire        VectAddr17RdEn;
// VICTrVectAddr17 Read Access Enable signal

wire        VectAddr18RdEn;
// VICTrVectAddr18 Read Access Enable signal

wire        VectAddr19RdEn;
// VICTrVectAddr19 Read Access Enable signal

wire        VectAddr20RdEn;
// VICTrVectAddr20 Read Access Enable signal

wire        VectAddr21RdEn;
// VICTrVectAddr21 Read Access Enable signal

wire        VectAddr22RdEn;
// VICTrVectAddr22 Read Access Enable signal

wire        VectAddr23RdEn;
// VICTrVectAddr23 Read Access Enable signal

wire        VectAddr24RdEn;
// VICTrVectAddr24 Read Access Enable signal

wire        VectAddr25RdEn;
// VICTrVectAddr25 Read Access Enable signal

wire        VectAddr26RdEn;
// VICTrVectAddr26 Read Access Enable signal

wire        VectAddr27RdEn;
// VICTrVectAddr27 Read Access Enable signal

wire        VectAddr28RdEn;
// VICTrVectAddr28 Read Access Enable signal

wire        VectAddr29RdEn;
// VICTrVectAddr29 Read Access Enable signal

wire        VectAddr30RdEn;
// VICTrVectAddr30 Read Access Enable signal

wire        VectAddr31RdEn;
// VICTrVectAddr31 Read Access Enable signal

wire        VectPrity0RdEn;
// VICTrVectPrity0 Read Access Enable signal

wire        VectPrity1RdEn;
// VICTrVectPrity1 Read Access Enable signal

wire        VectPrity2RdEn;
// VICTrVectPrity2 Read Access Enable signal

wire        VectPrity3RdEn;
// VICTrVectPrity3 Read Access Enable signal

wire        VectPrity4RdEn;
// VICTrVectPrity4 Read Access Enable signal

wire        VectPrity5RdEn;
// VICTrVectPrity5 Read Access Enable signal

wire        VectPrity6RdEn;
// VICTrVectPrity6 Read Access Enable signal

wire        VectPrity7RdEn;
// VICTrVectPrity7 Read Access Enable signal

wire        VectPrity8RdEn;
// VICTrVectPrity8 Read Access Enable signal

wire        VectPrity9RdEn;
// VICTrVectPrity9 Read Access Enable signal

wire        VectPrity10RdEn;
// VICTrVectPrity10 Read Access Enable signal

wire        VectPrity11RdEn;
// VICTrVectPrity11 Read Access Enable signal

wire        VectPrity12RdEn;
// VICTrVectPrity12 Read Access Enable signal

wire        VectPrity13RdEn;
// VICTrVectPrity13 Read Access Enable signal

wire        VectPrity14RdEn;
// VICTrVectPrity14 Read Access Enable signal

wire        VectPrity15RdEn;
// VICTrVectPrity15 Read Access Enable signal

wire        VectPrity16RdEn;
// VICTrVectPrity16 Read Access Enable signal

wire        VectPrity17RdEn;
// VICTrVectPrity17 Read Access Enable signal

wire        VectPrity18RdEn;
// VICTrVectPrity18 Read Access Enable signal

wire        VectPrity19RdEn;
// VICTrVectPrity19 Read Access Enable signal

wire        VectPrity20RdEn;
// VICTrVectPrity20 Read Access Enable signal

wire        VectPrity21RdEn;
// VICTrVectPrity21 Read Access Enable signal

wire        VectPrity22RdEn;
// VICTrVectPrity22 Read Access Enable signal

wire        VectPrity23RdEn;
// VICTrVectPrity23 Read Access Enable signal

wire        VectPrity24RdEn;
// VICTrVectPrity24 Read Access Enable signal

wire        VectPrity25RdEn;
// VICTrVectPrity25 Read Access Enable signal

wire        VectPrity26RdEn;
// VICTrVectPrity26 Read Access Enable signal

wire        VectPrity27RdEn;
// VICTrVectPrity27 Read Access Enable signal

wire        VectPrity28RdEn;
// VICTrVectPrity28 Read Access Enable signal

wire        VectPrity29RdEn;
// VICTrVectPrity29 Read Access Enable signal

wire        VectPrity30RdEn;
// VICTrVectPrity30 Read Access Enable signal

wire        VectPrity31RdEn;
// VICTrVectPrity31 Read Access Enable signal

wire        VectPrityDsyRdEn;
// VICTrVectPriDsy Read Access Enable signal

wire        VICTrTCRRdEn;
// VICTrTCR Read Access Enable signal

wire        TrIntSrcRdEn;
// VICTrIntSource Read Access Enable signal

wire        IntStatRdEn;
// VICTrStatus Read Access Enable signal

wire        TrIntInRdEn;
// VICTrIntIn Read Access Enable signal

wire        TrIntInRegRdEn;
// VICTrIntInReg Read Access Enable signal

wire        TrSyncRdEn;
// VICTrSync Read Access Enable signal

wire        TrAckCntRdEn;
// VICTrAckCnt Read Access Enable signal

wire        TrVectAdInRdEn;
// VICTrVectAddrIn Read Access Enable signal

wire        TrVectAdOutRdEn;
// VICVECTADDROUT Read Access Enable signal

wire        IntSelectWrEn;
// VICTrIntSelect Write Access Enable signal

wire        SwPrityMaskWrEn;
// VICTrSwPriMask Write Access Enable signal

wire        IntEnableWrEn;
// VICTrIntEnable Write Access Enable signal

wire        IntEnClearWrEn;
// VICTrIntEnableClear Write Access Enable signal

wire        SoftIntWrEn;
// VICTrSoftInt Write Access Enable signal

wire        SoftIntClearWrEn;
// VICTrSoftIntClear Write Access Enable signal

wire        ProtectionWrEn;
// VICTrProtection Write Access Enable signal

wire        VectAddrWrEn;
// VICTrVectAddr Write Access Enable signal

wire        VectAddr0WrEn;
// VICTrVectAddr0 Write Access Enable signal

wire        VectAddr1WrEn;
// VICTrVectAddr1 Write Access Enable signal

wire        VectAddr2WrEn;
// VICTrVectAddr2 Write Access Enable signal

wire        VectAddr3WrEn;
// VICTrVectAddr3 Write Access Enable signal

wire        VectAddr4WrEn;
// VICTrVectAddr4 Write Access Enable signal

wire        VectAddr5WrEn;
// VICTrVectAddr5 Write Access Enable signal

wire        VectAddr6WrEn;
// VICTrVectAddr6 Write Access Enable signal

wire        VectAddr7WrEn;
// VICTrVectAddr7 Write Access Enable signal

wire        VectAddr8WrEn;
// VICTrVectAddr8 Write Access Enable signal

wire        VectAddr9WrEn;
// VICTrVectAddr9 Write Access Enable signal

wire        VectAddr10WrEn;
// VICTrVectAddr10 Write Access Enable signal

wire        VectAddr11WrEn;
// VICTrVectAddr11 Write Access Enable signal

wire        VectAddr12WrEn;
// VICTrVectAddr12 Write Access Enable signal

wire        VectAddr13WrEn;
// VICTrVectAddr13 Write Access Enable signal

wire        VectAddr14WrEn;
// VICTrVectAddr14 Write Access Enable signal

wire        VectAddr15WrEn;
// VICTrVectAddr15 Write Access Enable signal

wire        VectAddr16WrEn;
// VICTrVectAddr16 Write Access Enable signal

wire        VectAddr17WrEn;
// VICTrVectAddr17 Write Access Enable signal

wire        VectAddr18WrEn;
// VICTrVectAddr18 Write Access Enable signal

wire        VectAddr19WrEn;
// VICTrVectAddr19 Write Access Enable signal

wire        VectAddr20WrEn;
// VICTrVectAddr20 Write Access Enable signal

wire        VectAddr21WrEn;
// VICTrVectAddr21 Write Access Enable signal

wire        VectAddr22WrEn;
// VICTrVectAddr22 Write Access Enable signal

wire        VectAddr23WrEn;
// VICTrVectAddr23 Write Access Enable signal

wire        VectAddr24WrEn;
// VICTrVectAddr24 Write Access Enable signal

wire        VectAddr25WrEn;
// VICTrVectAddr25 Write Access Enable signal

wire        VectAddr26WrEn;
// VICTrVectAddr26 Write Access Enable signal

wire        VectAddr27WrEn;
// VICTrVectAddr27 Write Access Enable signal

wire        VectAddr28WrEn;
// VICTrVectAddr28 Write Access Enable signal

wire        VectAddr29WrEn;
// VICTrVectAddr29 Write Access Enable signal

wire        VectAddr30WrEn;
// VICTrVectAddr30 Write Access Enable signal

wire        VectAddr31WrEn;
// VICTrVectAddr31 Write Access Enable signal

wire        VectPrity0WrEn;
// VICTrVectPrity0 Write Access Enable signal

wire        VectPrity1WrEn;
// VICTrVectPrity1 Write Access Enable signal

wire        VectPrity2WrEn;
// VICTrVectPrity2 Write Access Enable signal

wire        VectPrity3WrEn;
// VICTrVectPrity3 Write Access Enable signal

wire        VectPrity4WrEn;
// VICTrVectPrity4 Write Access Enable signal

wire        VectPrity5WrEn;
// VICTrVectPrity5 Write Access Enable signal

wire        VectPrity6WrEn;
// VICTrVectPrity6 Write Access Enable signal

wire        VectPrity7WrEn;
// VICTrVectPrity7 Write Access Enable signal

wire        VectPrity8WrEn;
// VICTrVectPrity8 Write Access Enable signal

wire        VectPrity9WrEn;
// VICTrVectPrity9 Write Access Enable signal

wire        VectPrity10WrEn;
// VICTrVectPrity10 Write Access Enable signal

wire        VectPrity11WrEn;
// VICTrVectPrity11 Write Access Enable signal

wire        VectPrity12WrEn;
// VICTrVectPrity12 Write Access Enable signal

wire        VectPrity13WrEn;
// VICTrVectPrity13 Write Access Enable signal

wire        VectPrity14WrEn;
// VICTrVectPrity14 Write Access Enable signal

wire        VectPrity15WrEn;
// VICTrVectPrity15 Write Access Enable signal

wire        VectPrity16WrEn;
// VICTrVectPrity16 Write Access Enable signal

wire        VectPrity17WrEn;
// VICTrVectPrity17 Write Access Enable signal

wire        VectPrity18WrEn;
// VICTrVectPrity18 Write Access Enable signal

wire        VectPrity19WrEn;
// VICTrVectPrity19 Write Access Enable signal

wire        VectPrity20WrEn;
// VICTrVectPrity20 Write Access Enable signal

wire        VectPrity21WrEn;
// VICTrVectPrity21 Write Access Enable signal

wire        VectPrity22WrEn;
// VICTrVectPrity22 Write Access Enable signal

wire        VectPrity23WrEn;
// VICTrVectPrity23 Write Access Enable signal

wire        VectPrity24WrEn;
// VICTrVectPrity24 Write Access Enable signal

wire        VectPrity25WrEn;
// VICTrVectPrity25 Write Access Enable signal

wire        VectPrity26WrEn;
// VICTrVectPrity26 Write Access Enable signal

wire        VectPrity27WrEn;
// VICTrVectPrity27 Write Access Enable signal

wire        VectPrity28WrEn;
// VICTrVectPrity28 Write Access Enable signal

wire        VectPrity29WrEn;
// VICTrVectPrity29 Write Access Enable signal

wire        VectPrity30WrEn;
// VICTrVectPrity30 Write Access Enable signal

wire        VectPrity31WrEn;
// VICTrVectPrity31 Write Access Enable signal

wire        VectPrityDsyWrEn;
// VICTrVectPriDsy Write Access Enable signal

wire        VICTrTCRWrEn;
// VICTrTCR Write Access Enable signal

wire        TrIntSrcWrEn;
// VICTrIntSource Write Access Enable signal

wire        TrIntInWrEn;
// VICTrIntIn Write Access Enable signal

wire        TrIntInRegWrEn;
// VICTrIntInReg Write Access Enable signal

wire        TrSyncWrEn;
// VICTrSync Write Access Enable signal

wire        TrAckCntWrEn;
// VICTrAckCnt Write Access Enable signal

wire        TrVectAdInWrEn;
// VICTrVectAddrIn Write Access Enable signal

wire [31:0] NxtTrIntSelect;
// D-input of Mirrored VICTrIntSelect Register

wire [15:0] NxtTrSwPrityMask;
// D-input of Mirrored VICTrSwPriMask Register

wire [31:0] NxtTrIntEnable;
// D-input of Mirrored VICTrIntEnable Register

wire [31:0] NxtTrSoftInt;
// D-input of Mirrored VICTrSoftInt Register

wire        NxtTrProtection;
// D-input of Mirrored VICTrProtection Register

wire [31:0] NxtTrVectAddr0;
// D-input of Mirrored VICTrVectAddr0 Register

wire [31:0] NxtTrVectAddr1;
// D-input of Mirrored VICTrVectAddr1 Register

wire [31:0] NxtTrVectAddr2;
// D-input of Mirrored VICTrVectAddr2 Register

wire [31:0] NxtTrVectAddr3;
// D-input of Mirrored VICTrVectAddr3 Register

wire [31:0] NxtTrVectAddr4;
// D-input of Mirrored VICTrVectAddr1 Register

wire [31:0] NxtTrVectAddr5;
// D-input of Mirrored VICTrVectAddr5 Register

wire [31:0] NxtTrVectAddr6;
// D-input of Mirrored VICTrVectAddr6 Register

wire [31:0] NxtTrVectAddr7;
// D-input of Mirrored VICTrVectAddr7 Register

wire [31:0] NxtTrVectAddr8;
// D-input of Mirrored VICTrVectAddr8 Register

wire [31:0] NxtTrVectAddr9;
// D-input of Mirrored VICTrVectAddr9 Register

wire [31:0] NxtTrVectAddr10;
// D-input of Mirrored VICTrVectAddr10 Register

wire [31:0] NxtTrVectAddr11;
// D-input of Mirrored VICTrVectAddr11 Register

wire [31:0] NxtTrVectAddr12;
// D-input of Mirrored VICTrVectAddr12 Register

wire [31:0] NxtTrVectAddr13;
// D-input of Mirrored VICTrVectAddr13 Register

wire [31:0] NxtTrVectAddr14;
// D-input of Mirrored VICTrVectAddr14 Register

wire [31:0] NxtTrVectAddr15;
// D-input of Mirrored VICTrVectAddr15 Register

wire [31:0] NxtTrVectAddr16;
// D-input of Mirrored VICTrVectAddr16 Register

wire [31:0] NxtTrVectAddr17;
// D-input of Mirrored VICTrVectAddr17 Register

wire [31:0] NxtTrVectAddr18;
// D-input of Mirrored VICTrVectAddr18 Register

wire [31:0] NxtTrVectAddr19;
// D-input of Mirrored VICTrVectAddr19 Register

wire [31:0] NxtTrVectAddr20;
// D-input of Mirrored VICTrVectAddr20 Register

wire [31:0] NxtTrVectAddr21;
// D-input of Mirrored VICTrVectAddr21 Register

wire [31:0] NxtTrVectAddr22;
// D-input of Mirrored VICTrVectAddr22 Register

wire [31:0] NxtTrVectAddr23;
// D-input of Mirrored VICTrVectAddr23 Register

wire [31:0] NxtTrVectAddr24;
// D-input of Mirrored VICTrVectAddr24 Register

wire [31:0] NxtTrVectAddr25;
// D-input of Mirrored VICTrVectAddr25 Register

wire [31:0] NxtTrVectAddr26;
// D-input of Mirrored VICTrVectAddr26 Register

wire [31:0] NxtTrVectAddr27;
// D-input of Mirrored VICTrVectAddr27 Register

wire [31:0] NxtTrVectAddr28;
// D-input of Mirrored VICTrVectAddr28 Register

wire [31:0] NxtTrVectAddr29;
// D-input of Mirrored VICTrVectAddr29 Register

wire [31:0] NxtTrVectAddr30;
// D-input of Mirrored VICTrVectAddr30 Register

wire [31:0] NxtTrVectAddr31;
// D-input of Mirrored VICTrVectAddr31 Register

wire  [3:0] NxtTrVectPrity0;
// D-input of Mirrored VICTrVectPrity0 Register

wire  [3:0] NxtTrVectPrity1;
// D-input of Mirrored VICTrVectPrity1 Register

wire  [3:0] NxtTrVectPrity2;
// D-input of Mirrored VICTrVectPrity2 Register

wire  [3:0] NxtTrVectPrity3;
// D-input of Mirrored VICTrVectPrity3 Register

wire  [3:0] NxtTrVectPrity4;
// D-input of Mirrored VICTrVectPrity1 Register

wire  [3:0] NxtTrVectPrity5;
// D-input of Mirrored VICTrVectPrity5 Register

wire  [3:0] NxtTrVectPrity6;
// D-input of Mirrored VICTrVectPrity6 Register

wire  [3:0] NxtTrVectPrity7;
// D-input of Mirrored VICTrVectPrity7 Register

wire  [3:0] NxtTrVectPrity8;
// D-input of Mirrored VICTrVectPrity8 Register

wire  [3:0] NxtTrVectPrity9;
// D-input of Mirrored VICTrVectPrity9 Register

wire  [3:0] NxtTrVectPrity10;
// D-input of Mirrored VICTrVectPrity10 Register

wire  [3:0] NxtTrVectPrity11;
// D-input of Mirrored VICTrVectPrity11 Register

wire  [3:0] NxtTrVectPrity12;
// D-input of Mirrored VICTrVectPrity12 Register

wire  [3:0] NxtTrVectPrity13;
// D-input of Mirrored VICTrVectPrity13 Register

wire  [3:0] NxtTrVectPrity14;
// D-input of Mirrored VICTrVectPrity14 Register

wire  [3:0] NxtTrVectPrity15;
// D-input of Mirrored VICTrVectPrity15 Register

wire  [3:0] NxtTrVectPrity16;
// D-input of Mirrored VICTrVectPrity16 Register

wire  [3:0] NxtTrVectPrity17;
// D-input of Mirrored VICTrVectPrity17 Register

wire  [3:0] NxtTrVectPrity18;
// D-input of Mirrored VICTrVectPrity18 Register

wire  [3:0] NxtTrVectPrity19;
// D-input of Mirrored VICTrVectPrity19 Register

wire  [3:0] NxtTrVectPrity20;
// D-input of Mirrored VICTrVectPrity20 Register

wire  [3:0] NxtTrVectPrity21;
// D-input of Mirrored VICTrVectPrity21 Register

wire  [3:0] NxtTrVectPrity22;
// D-input of Mirrored VICTrVectPrity22 Register

wire  [3:0] NxtTrVectPrity23;
// D-input of Mirrored VICTrVectPrity23 Register

wire  [3:0] NxtTrVectPrity24;
// D-input of Mirrored VICTrVectPrity24 Register

wire  [3:0] NxtTrVectPrity25;
// D-input of Mirrored VICTrVectPrity25 Register

wire  [3:0] NxtTrVectPrity26;
// D-input of Mirrored VICTrVectPrity26 Register

wire  [3:0] NxtTrVectPrity27;
// D-input of Mirrored VICTrVectPrity27 Register

wire  [3:0] NxtTrVectPrity28;
// D-input of Mirrored VICTrVectPrity28 Register

wire  [3:0] NxtTrVectPrity29;
// D-input of Mirrored VICTrVectPrity29 Register

wire  [3:0] NxtTrVectPrity30;
// D-input of Mirrored VICTrVectPrity30 Register

wire  [3:0] NxtTrVectPrity31;
// D-input of Mirrored VICTrVectPrity31 Register

wire  [3:0] NxtTrVectPrityDsy;
// D-input of Mirrored VICTrVectPriDsy Register

wire  [8:0] NxtVICTrTCR;
// D-input of VICTrTCR Register

wire [31:0] NxtTrIntSource;
// D-input of VICTrIntSource Register

wire  [1:0] NxtTrIntIn;
// D-input of VICTrIntIn Register

wire  [1:0] NxtTrIntInReg;
// D-input of VICTrIntInReg Register

wire        NxtTrSync;
// D-input of VICTrSync Register

wire  [2:0] NxtTrAckCnt;
// D-input of VICTrAckCnt Register

wire [31:0] NxtTrVectAddrIn;
// D-input of VICTrVectAddrIn Register

wire        iVectAddrWrTrig; 
// Write trigger signal delayed by a delta delay

wire        iVectAddrRdTrig; 
// Read trigger signal delayed by a delta delay

// -----------------------------------------------------------------------------
// Zero fill for register reads to return zeros in unused bit positions
// -----------------------------------------------------------------------------
wire [31:0] ZEROFILL;

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         BusEn;
// Bus latch Enable signal

reg         RdAccess;
// Read Access to Trickbox

reg         WrAccess;
// Write Access to Trickbox

reg         MrWrAccess;
// Write Access to Mirrored registers

wire        MrWrAccesstmp;
// Write Access to Mirrored registers

reg         MrRdAccess;
// Read Access to Mirrored registers

wire        MrRdAccesstmp;
// Read Access to Mirrored registers

reg         DeviceSel;
// Latched Device Select signal

reg  [11:2] Addr;
// Latched Address bus within Trickbox

reg         VICTrProtection;
// Mirrored Protection Register

reg  [31:0] VICTrIntSource;
// VICTrIntSource Register

reg   [1:0] VICTrIntIn;
// VICTrIntIn Register

reg   [1:0] VICTrIntInReg;
// VICTrIntInReg Register 

reg         VICTrSync;
// VICTrSync Register 

reg   [2:0] VICTrAckCnt;
// VICTrAckCnt Register 

reg        VICTrAckCnt1;
// VICTrAckCnt1 signal 

reg    VICTrAckCnt2;
// VICTrAckCnt2 signal 

reg    VICTrAckCnt3;
// VICTrAckCnt3 signal 

reg    VICTrAckCnt4;
// VICTrAckCnt4 signal 

reg    VICTrAckCnt5;
// VICTrAckCnt5 signal 

reg    VICTrAckCnt6;
// VICTrAckCnt6 signal 

reg    VICTrAckCnt7;
// VICTrAckCnt7 signal 

reg  [31:0] VICTrVectAddrIn;
// VICTrVectAddrIn Register

reg         VICACKOUTp;
// VICACKOUT asserted at posedge of HCLK

reg         VICACKOUTn;
// VICACKOUT asserted at posedge of HCLK

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
// Assign ZEROFILL
// -----------------------------------------------------------------------------
assign ZEROFILL         = 32'h00000000;
// -----------------------------------------------------------------------------
// Assign 'min' and 'max' delays to the VICACKOUTp signal
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICACKOUTComb1
  case (VICVECTADDRV)
    1'b1 : 
      begin 
        # tovmaxackcnt VICACKOUTp <= 1'b0;
      end
    1'b0 :
      begin
        case ({nVICIRQ,VICTrAckCnt})
          4'b0001 :
            begin 
              # tovmaxackcnt VICACKOUTp <= VICTrAckCnt1;
            end
          4'b0010 :
            begin 
              # tovmaxackcnt VICACKOUTp <= VICTrAckCnt2;
            end
          4'b0011 :
            begin 
              # tovmaxackcnt VICACKOUTp <= VICTrAckCnt3;
            end
          4'b0100 :
            begin 
              # tovmaxackcnt VICACKOUTp <= VICTrAckCnt4;
            end
          4'b0101 :
            begin 
              # tovmaxackcnt VICACKOUTp <= VICTrAckCnt5;
            end
          4'b0110 :
            begin 
              # tovmaxackcnt VICACKOUTp <= VICTrAckCnt6;
            end
          4'b0111 :
            begin 
              # tovmaxackcnt VICACKOUTp <= VICTrAckCnt7;
            end
          default :
            begin 
              # tovmaxackcnt VICACKOUTp <= 1'b0;
            end
        endcase    
      end
  endcase
end // p_TrVICACKOUTComb1
// -----------------------------------------------------------------------------
// Assign 'min' and 'max' delays to the VICACKOUTn signal
// -----------------------------------------------------------------------------
always @(negedge HCLK)
begin : p_TrVICACKOUTComb
  case (VICVECTADDRV)
    1'b1 :
      begin 
        # tovmaxackcnt VICACKOUTn <= 1'b0;
      end
    1'b0 :
      begin
        case ({nVICIRQ,VICTrAckCnt})
          4'b0001 :
            begin
              # tovmaxackcnt VICACKOUTn <= VICTrAckCnt1;
            end
          4'b0010 :
            begin
              # tovmaxackcnt VICACKOUTn <= VICTrAckCnt2;
            end
          4'b0011 :
            begin
              # tovmaxackcnt VICACKOUTn <= VICTrAckCnt3;
            end
          4'b0100 :
            begin
              # tovmaxackcnt VICACKOUTn <= VICTrAckCnt4;
            end
          4'b0101 :
            begin
              # tovmaxackcnt VICACKOUTn <= VICTrAckCnt5;
            end
          4'b0110 :
            begin
              # tovmaxackcnt VICACKOUTn <= VICTrAckCnt6;
            end
          4'b0111 :
            begin
              # tovmaxackcnt VICACKOUTn <= VICTrAckCnt7;
            end
          default :
            begin 
              # tovmaxackcnt VICACKOUTn <= 1'b0;
            end
        endcase
      end
  endcase
end // p_TrVICACKOUTComb
// -----------------------------------------------------------------------------
// Acknowledge signal generation
// -----------------------------------------------------------------------------
assign VICACKOUT = (VICTrTCR[8:6] == 3'b010) ? VICACKOUTn : VICACKOUTp;

// -----------------------------------------------------------------------------
// Clock Mux
// -----------------------------------------------------------------------------
assign HCLKTRICK = (VICTrTCR[5] == 1'b1) ? 1'b1 : HCLK;

// -----------------------------------------------------------------------------
// Assign 'min' and 'max' delays to the VICINTSOURCE signal
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICINTSRCComb
  # tovmaxintsrc VICINTSOURCE <= VICTrIntSource;
end // p_TrVICINTSRCComb

// -----------------------------------------------------------------------------
// Assign 'min' and 'max' delays to the nVICFIQIN signal
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICFIQINComb
  # tovmaxnvicfiqin nVICFIQIN <= VICTrIntIn[0];
end // p_TrVICFIQINComb

// -----------------------------------------------------------------------------
// Assign 'min' and 'max' delays to the nVICIRQIN signal
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICIRQINComb
  # tovmaxnvicirqin nVICIRQIN <= VICTrIntIn[1];
end // p_TrVICIRQINComb

// -----------------------------------------------------------------------------
// nVICFIQINREG signal
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICFIQINREGComb
  VICFIQINREG <= VICTrIntInReg[0];
end // p_TrVICFIQINREGComb

// -----------------------------------------------------------------------------
// nVICIRQINREG signal
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICIRQINREGComb
  VICIRQINREG <= VICTrIntInReg[1];
end // p_TrVICIRQINREGComb

// -----------------------------------------------------------------------------
// Assign 'min' and 'max' delays to the VICVECTADDRIN signal
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICVECTADComb
  # tovmaxvectadin VICVECTADDRIN <= VICTrVectAddrIn;
end // p_TrVICVECTADComb

// -----------------------------------------------------------------------------
// Assign 'min' and 'max' delays to the nVICSYNCEN signal
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_TrVICSyncComb
  # tovmaxnvicsynin nVICSYNCEN <= VICTrSync;
end // p_TrVICSyncComb

// -----------------------------------------------------------------------------
// Detecting new accesses to either the VIC or the Trickbox
// -----------------------------------------------------------------------------
assign NewAccess        = (HSELVICTR | HSELVIC) & HREADYIN & HTRANS;

assign NxtWrAccess      = (HREADYIN == 1'b1) ? 
                          (HSELVICTR & HWRITE & HTRANS) : WrAccess;

assign MrAccessEn       = (VICTrProtection == 1'b0) ? 1'b1 : HPROT;

assign NxtMrWrAccess    = (HREADYIN == 1'b1) ?
                          (HSELVIC & HWRITE & HTRANS & MrAccessEn &
                           ~(HSIZE[2]) & HSIZE[1] & ~(HSIZE[0])) :
                          MrWrAccess;

assign NxtMrRdAccess    = (HREADYIN == 1'b1) ?
                          (HSELVIC & ~(HWRITE) & HTRANS &
                           MrAccessEn & ~(HSIZE[2]) & HSIZE[1] &
                           ~(HSIZE[0])) : MrRdAccess;

assign NxtRdAccess      = (HREADYIN == 1'b1) ? 
                          (HSELVICTR & ~(HWRITE) & HTRANS) : RdAccess;

assign NxtDeviceSel     = (HREADYIN == 1'b1) ? HSELVICTR : DeviceSel;

// -----------------------------------------------------------------------------
// Sequential logic for the Access Enable signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_AccesstypeSeq
  if (HRESETn ==  1'b0)
    begin
      WrAccess   <= 1'b0;
      MrWrAccess <= 1'b0;
      MrRdAccess <= 1'b0;
      RdAccess   <= 1'b0;
      DeviceSel  <= 1'b0;
    end
  else
    begin
      WrAccess   <= NxtWrAccess;
      MrWrAccess <= NxtMrWrAccess;
      MrRdAccess <= NxtMrRdAccess;
      RdAccess   <= NxtRdAccess;
      DeviceSel  <= NxtDeviceSel;
    end
end // p_AccesstypeSeq

// -----------------------------------------------------------------------------
// Samples the address if the slave is selected
// -----------------------------------------------------------------------------
assign NxtAddr          = (NewAccess == 1'b1) ? HADDR[11:2] : Addr;

// -----------------------------------------------------------------------------
// Sequential logic for the internal Address bus
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_AddrSeq
  if (HRESETn ==  1'b0)
    Addr <= 10'b0000000000;
  else
    Addr <= NxtAddr;
end // p_AddrSeq

// -----------------------------------------------------------------------------
// Bus Latch Enable signal generation
// -----------------------------------------------------------------------------
assign NxtBusEn         = (NewAccess == 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Sequential logic for the Bus Latch Enable
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BusEnSeq
  if (HRESETn ==  1'b0)
    BusEn <= 1'b0;
  else
    BusEn <= NxtBusEn;
end // p_BusEnSeq

// -----------------------------------------------------------------------------
// Decode the latched Address
// -----------------------------------------------------------------------------
assign IntSelectEn      = (Addr == `VICTRINTSELECTADDR) ? 1'b1 : 1'b0;

assign SwPrityMaskEn    = (Addr == `VICTRSWPRITYMASKADDR) ? 1'b1 : 1'b0;

assign IntEnableEn      = (Addr == `VICTRINTENABLEADDR) ? 1'b1 : 1'b0;

assign IntEnClearEn     = (Addr == `VICTRINTENCLEARADDR) ? 1'b1 : 1'b0;

assign SoftIntEn        = (Addr == `VICTRSOFTINTADDR) ? 1'b1 : 1'b0;

assign SoftIntClearEn   = (Addr == `VICTRSOFTINTCLEARADDR) ?
                          1'b1 : 1'b0;

assign ProtectionEn     = (Addr == `VICTRPROTECTIONADDR) ? 1'b1 : 1'b0;

assign VectAddrEn       = (Addr == `VICTRVECTADADDR) ? 1'b1 : 1'b0;

assign VectAddrEnA      = (NxtAddr == `VICTRVECTADADDR) ? 1'b1 : 1'b0;

assign VectAddr0En      = (Addr == `VICTRVECTAD0ADDR) ? 1'b1 : 1'b0;

assign VectAddr1En      = (Addr == `VICTRVECTAD1ADDR) ? 1'b1 : 1'b0;

assign VectAddr2En      = (Addr == `VICTRVECTAD2ADDR) ? 1'b1 : 1'b0;

assign VectAddr3En      = (Addr == `VICTRVECTAD3ADDR) ? 1'b1 : 1'b0;

assign VectAddr4En      = (Addr == `VICTRVECTAD4ADDR) ? 1'b1 : 1'b0;

assign VectAddr5En      = (Addr == `VICTRVECTAD5ADDR) ? 1'b1 : 1'b0;

assign VectAddr6En      = (Addr == `VICTRVECTAD6ADDR) ? 1'b1 : 1'b0;

assign VectAddr7En      = (Addr == `VICTRVECTAD7ADDR) ? 1'b1 : 1'b0;

assign VectAddr8En      = (Addr == `VICTRVECTAD8ADDR) ? 1'b1 : 1'b0;

assign VectAddr9En      = (Addr == `VICTRVECTAD9ADDR) ? 1'b1 : 1'b0;

assign VectAddr10En     = (Addr == `VICTRVECTAD10ADDR) ? 1'b1 : 1'b0;

assign VectAddr11En     = (Addr == `VICTRVECTAD11ADDR) ? 1'b1 : 1'b0;

assign VectAddr12En     = (Addr == `VICTRVECTAD12ADDR) ? 1'b1 : 1'b0;

assign VectAddr13En     = (Addr == `VICTRVECTAD13ADDR) ? 1'b1 : 1'b0;

assign VectAddr14En     = (Addr == `VICTRVECTAD14ADDR) ? 1'b1 : 1'b0;

assign VectAddr15En     = (Addr == `VICTRVECTAD15ADDR) ? 1'b1 : 1'b0;

assign VectAddr16En     = (Addr == `VICTRVECTAD16ADDR) ? 1'b1 : 1'b0;

assign VectAddr17En     = (Addr == `VICTRVECTAD17ADDR) ? 1'b1 : 1'b0;

assign VectAddr18En     = (Addr == `VICTRVECTAD18ADDR) ? 1'b1 : 1'b0;

assign VectAddr19En     = (Addr == `VICTRVECTAD19ADDR) ? 1'b1 : 1'b0;

assign VectAddr20En     = (Addr == `VICTRVECTAD20ADDR) ? 1'b1 : 1'b0;

assign VectAddr21En     = (Addr == `VICTRVECTAD21ADDR) ? 1'b1 : 1'b0;

assign VectAddr22En     = (Addr == `VICTRVECTAD22ADDR) ? 1'b1 : 1'b0;

assign VectAddr23En     = (Addr == `VICTRVECTAD23ADDR) ? 1'b1 : 1'b0;

assign VectAddr24En     = (Addr == `VICTRVECTAD24ADDR) ? 1'b1 : 1'b0;

assign VectAddr25En     = (Addr == `VICTRVECTAD25ADDR) ? 1'b1 : 1'b0;

assign VectAddr26En     = (Addr == `VICTRVECTAD26ADDR) ? 1'b1 : 1'b0;

assign VectAddr27En     = (Addr == `VICTRVECTAD27ADDR) ? 1'b1 : 1'b0;

assign VectAddr28En     = (Addr == `VICTRVECTAD28ADDR) ? 1'b1 : 1'b0;

assign VectAddr29En     = (Addr == `VICTRVECTAD29ADDR) ? 1'b1 : 1'b0;

assign VectAddr30En     = (Addr == `VICTRVECTAD30ADDR) ? 1'b1 : 1'b0;

assign VectAddr31En     = (Addr == `VICTRVECTAD31ADDR) ? 1'b1 : 1'b0;

assign VectPrity0En     = (Addr == `VICTRVECTPL0PLVL) ? 1'b1 : 1'b0;

assign VectPrity1En     = (Addr == `VICTRVECTPL1PLVL) ? 1'b1 : 1'b0;

assign VectPrity2En     = (Addr == `VICTRVECTPL2PLVL) ? 1'b1 : 1'b0;

assign VectPrity3En     = (Addr == `VICTRVECTPL3PLVL) ? 1'b1 : 1'b0;

assign VectPrity4En     = (Addr == `VICTRVECTPL4PLVL) ? 1'b1 : 1'b0;

assign VectPrity5En     = (Addr == `VICTRVECTPL5PLVL) ? 1'b1 : 1'b0;

assign VectPrity6En     = (Addr == `VICTRVECTPL6PLVL) ? 1'b1 : 1'b0;

assign VectPrity7En     = (Addr == `VICTRVECTPL7PLVL) ? 1'b1 : 1'b0;

assign VectPrity8En     = (Addr == `VICTRVECTPL8PLVL) ? 1'b1 : 1'b0;

assign VectPrity9En     = (Addr == `VICTRVECTPL9PLVL) ? 1'b1 : 1'b0;

assign VectPrity10En    = (Addr == `VICTRVECTPL10PLVL) ? 1'b1 : 1'b0;

assign VectPrity11En    = (Addr == `VICTRVECTPL11PLVL) ? 1'b1 : 1'b0;

assign VectPrity12En    = (Addr == `VICTRVECTPL12PLVL) ? 1'b1 : 1'b0;

assign VectPrity13En    = (Addr == `VICTRVECTPL13PLVL) ? 1'b1 : 1'b0;

assign VectPrity14En    = (Addr == `VICTRVECTPL14PLVL) ? 1'b1 : 1'b0;

assign VectPrity15En    = (Addr == `VICTRVECTPL15PLVL) ? 1'b1 : 1'b0;

assign VectPrity16En    = (Addr == `VICTRVECTPL16PLVL) ? 1'b1 : 1'b0;

assign VectPrity17En    = (Addr == `VICTRVECTPL17PLVL) ? 1'b1 : 1'b0;

assign VectPrity18En    = (Addr == `VICTRVECTPL18PLVL) ? 1'b1 : 1'b0;

assign VectPrity19En    = (Addr == `VICTRVECTPL19PLVL) ? 1'b1 : 1'b0;

assign VectPrity20En    = (Addr == `VICTRVECTPL20PLVL) ? 1'b1 : 1'b0;

assign VectPrity21En    = (Addr == `VICTRVECTPL21PLVL) ? 1'b1 : 1'b0;

assign VectPrity22En    = (Addr == `VICTRVECTPL22PLVL) ? 1'b1 : 1'b0;

assign VectPrity23En    = (Addr == `VICTRVECTPL23PLVL) ? 1'b1 : 1'b0;

assign VectPrity24En    = (Addr == `VICTRVECTPL24PLVL) ? 1'b1 : 1'b0;

assign VectPrity25En    = (Addr == `VICTRVECTPL25PLVL) ? 1'b1 : 1'b0;

assign VectPrity26En    = (Addr == `VICTRVECTPL26PLVL) ? 1'b1 : 1'b0;

assign VectPrity27En    = (Addr == `VICTRVECTPL27PLVL) ? 1'b1 : 1'b0;

assign VectPrity28En    = (Addr == `VICTRVECTPL28PLVL) ? 1'b1 : 1'b0;

assign VectPrity29En    = (Addr == `VICTRVECTPL29PLVL) ? 1'b1 : 1'b0;

assign VectPrity30En    = (Addr == `VICTRVECTPL30PLVL) ? 1'b1 : 1'b0;

assign VectPrity31En    = (Addr == `VICTRVECTPL31PLVL) ? 1'b1 : 1'b0;

assign VectPrityDsyEn   = (Addr == `VICTRVECTPLDSYPLVL) ? 1'b1 : 1'b0;

assign VICTrTCREn       = (Addr == `VICTRTCRADDR) ? 1'b1 : 1'b0;

assign TrIntSourceEn    = (Addr == `VICTRINTSOURCEADDR) ? 1'b1 : 1'b0;

assign TrStatusEn       = (Addr == `VICTRINTSTATUSADDR) ? 1'b1 : 1'b0;

assign TrIntInEn        = (Addr == `VICTRINTINADDR) ? 1'b1 : 1'b0;

assign TrIntInRegEn     = (Addr == `VICTRINTINREGADDR) ? 1'b1 : 1'b0;

assign TrSyncEn         = (Addr == `VICTRSYNCADDR) ? 1'b1 : 1'b0;

assign TrAckCntEn       = (Addr == `VICTRACKCNTADDR) ? 1'b1 : 1'b0;

assign TrVectAdInEn     = (Addr == `VICTRVECTADINADDR) ? 1'b1 : 1'b0;

assign TrVectAdOutEn    = (Addr == `VICTRVECTADOUTADDR) ? 1'b1 : 1'b0;

assign WaitStRegEn      = (Addr == `VICTRWAITACCESSADDR) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generates Read Access Enable Signals
// -----------------------------------------------------------------------------
assign IntSelectRdEn    = IntSelectEn & RdAccess;

assign SwPrityMaskRdEn  = SwPrityMaskEn & RdAccess;

assign IntEnableRdEn    = IntEnableEn & RdAccess;

assign SoftIntRdEn      = SoftIntEn & RdAccess;

assign ProtectionRdEn   = ProtectionEn & RdAccess;

assign VectAddrRdEn     = VectAddrEn & RdAccess;

assign VectAddr0RdEn    = VectAddr0En & RdAccess;

assign VectAddr1RdEn    = VectAddr1En & RdAccess;

assign VectAddr2RdEn    = VectAddr2En & RdAccess;

assign VectAddr3RdEn    = VectAddr3En & RdAccess;

assign VectAddr4RdEn    = VectAddr4En & RdAccess;

assign VectAddr5RdEn    = VectAddr5En & RdAccess;

assign VectAddr6RdEn    = VectAddr6En & RdAccess;

assign VectAddr7RdEn    = VectAddr7En & RdAccess;

assign VectAddr8RdEn    = VectAddr8En & RdAccess;

assign VectAddr9RdEn    = VectAddr9En & RdAccess;

assign VectAddr10RdEn   = VectAddr10En & RdAccess;

assign VectAddr11RdEn   = VectAddr11En & RdAccess;

assign VectAddr12RdEn   = VectAddr12En & RdAccess;

assign VectAddr13RdEn   = VectAddr13En & RdAccess;

assign VectAddr14RdEn   = VectAddr14En & RdAccess;

assign VectAddr15RdEn   = VectAddr15En & RdAccess;

assign VectAddr16RdEn   = VectAddr16En & RdAccess;

assign VectAddr17RdEn   = VectAddr17En & RdAccess;

assign VectAddr18RdEn   = VectAddr18En & RdAccess;

assign VectAddr19RdEn   = VectAddr19En & RdAccess;

assign VectAddr20RdEn   = VectAddr20En & RdAccess;

assign VectAddr21RdEn   = VectAddr21En & RdAccess;

assign VectAddr22RdEn   = VectAddr22En & RdAccess;

assign VectAddr23RdEn   = VectAddr23En & RdAccess;

assign VectAddr24RdEn   = VectAddr24En & RdAccess;

assign VectAddr25RdEn   = VectAddr25En & RdAccess;

assign VectAddr26RdEn   = VectAddr26En & RdAccess;

assign VectAddr27RdEn   = VectAddr27En & RdAccess;

assign VectAddr28RdEn   = VectAddr28En & RdAccess;

assign VectAddr29RdEn   = VectAddr29En & RdAccess;

assign VectAddr30RdEn   = VectAddr30En & RdAccess;

assign VectAddr31RdEn   = VectAddr31En & RdAccess;

assign VectPrity0RdEn   = VectPrity0En & RdAccess;

assign VectPrity1RdEn   = VectPrity1En & RdAccess;

assign VectPrity2RdEn   = VectPrity2En & RdAccess;

assign VectPrity3RdEn   = VectPrity3En & RdAccess;

assign VectPrity4RdEn   = VectPrity4En & RdAccess;

assign VectPrity5RdEn   = VectPrity5En & RdAccess;

assign VectPrity6RdEn   = VectPrity6En & RdAccess;

assign VectPrity7RdEn   = VectPrity7En & RdAccess;

assign VectPrity8RdEn   = VectPrity8En & RdAccess;

assign VectPrity9RdEn   = VectPrity9En & RdAccess;

assign VectPrity10RdEn  = VectPrity10En & RdAccess;

assign VectPrity11RdEn  = VectPrity11En & RdAccess;

assign VectPrity12RdEn  = VectPrity12En & RdAccess;

assign VectPrity13RdEn  = VectPrity13En & RdAccess;

assign VectPrity14RdEn  = VectPrity14En & RdAccess;

assign VectPrity15RdEn  = VectPrity15En & RdAccess;

assign VectPrity16RdEn  = VectPrity16En & RdAccess;

assign VectPrity17RdEn  = VectPrity17En & RdAccess;

assign VectPrity18RdEn  = VectPrity18En & RdAccess;

assign VectPrity19RdEn  = VectPrity19En & RdAccess;

assign VectPrity20RdEn  = VectPrity20En & RdAccess;

assign VectPrity21RdEn  = VectPrity21En & RdAccess;

assign VectPrity22RdEn  = VectPrity22En & RdAccess;

assign VectPrity23RdEn  = VectPrity23En & RdAccess;

assign VectPrity24RdEn  = VectPrity24En & RdAccess;

assign VectPrity25RdEn  = VectPrity25En & RdAccess;

assign VectPrity26RdEn  = VectPrity26En & RdAccess;

assign VectPrity27RdEn  = VectPrity27En & RdAccess;

assign VectPrity28RdEn  = VectPrity28En & RdAccess;

assign VectPrity29RdEn  = VectPrity29En & RdAccess;

assign VectPrity30RdEn  = VectPrity30En & RdAccess;

assign VectPrity31RdEn  = VectPrity31En & RdAccess;

assign VectPrityDsyRdEn = VectPrityDsyEn & RdAccess;

assign VICTrTCRRdEn     = VICTrTCREn & RdAccess;

assign TrIntSrcRdEn     = TrIntSourceEn & RdAccess;

assign IntStatRdEn      = TrStatusEn & RdAccess;

assign TrIntInRdEn      = TrIntInEn & RdAccess;

assign TrIntInRegRdEn   = TrIntInRegEn & RdAccess;

assign TrSyncRdEn       = TrSyncEn & RdAccess;

assign TrAckCntRdEn     = TrAckCntEn & RdAccess;

assign TrVectAdInRdEn   = TrVectAdInEn & RdAccess;

assign TrVectAdOutRdEn  = TrVectAdOutEn & RdAccess;

// -----------------------------------------------------------------------------
// Generates Write Access Enable Signals
// -----------------------------------------------------------------------------
assign IntSelectWrEn    = IntSelectEn & MrWrAccess;

assign SwPrityMaskWrEn  = SwPrityMaskEn & MrWrAccess;

assign IntEnableWrEn    = IntEnableEn & MrWrAccess;

assign IntEnClearWrEn   = IntEnClearEn & MrWrAccess;

assign SoftIntWrEn      = SoftIntEn & MrWrAccess;

assign SoftIntClearWrEn = SoftIntClearEn & MrWrAccess;

assign ProtectionWrEn   = ProtectionEn & MrWrAccess;

assign VectAddrWrEn     = VectAddrEn & MrWrAccesstmp;

assign VectAddr0WrEn    = VectAddr0En & MrWrAccess;

assign VectAddr1WrEn    = VectAddr1En & MrWrAccess;

assign VectAddr2WrEn    = VectAddr2En & MrWrAccess;

assign VectAddr3WrEn    = VectAddr3En & MrWrAccess;

assign VectAddr4WrEn    = VectAddr4En & MrWrAccess;

assign VectAddr5WrEn    = VectAddr5En & MrWrAccess;

assign VectAddr6WrEn    = VectAddr6En & MrWrAccess;

assign VectAddr7WrEn    = VectAddr7En & MrWrAccess;

assign VectAddr8WrEn    = VectAddr8En & MrWrAccess;

assign VectAddr9WrEn    = VectAddr9En & MrWrAccess;

assign VectAddr10WrEn   = VectAddr10En & MrWrAccess;

assign VectAddr11WrEn   = VectAddr11En & MrWrAccess;

assign VectAddr12WrEn   = VectAddr12En & MrWrAccess;

assign VectAddr13WrEn   = VectAddr13En & MrWrAccess;

assign VectAddr14WrEn   = VectAddr14En & MrWrAccess;

assign VectAddr15WrEn   = VectAddr15En & MrWrAccess;

assign VectAddr16WrEn   = VectAddr16En & MrWrAccess;

assign VectAddr17WrEn   = VectAddr17En & MrWrAccess;

assign VectAddr18WrEn   = VectAddr18En & MrWrAccess;

assign VectAddr19WrEn   = VectAddr19En & MrWrAccess;

assign VectAddr20WrEn   = VectAddr20En & MrWrAccess;

assign VectAddr21WrEn   = VectAddr21En & MrWrAccess;

assign VectAddr22WrEn   = VectAddr22En & MrWrAccess;

assign VectAddr23WrEn   = VectAddr23En & MrWrAccess;

assign VectAddr24WrEn   = VectAddr24En & MrWrAccess;

assign VectAddr25WrEn   = VectAddr25En & MrWrAccess;

assign VectAddr26WrEn   = VectAddr26En & MrWrAccess;

assign VectAddr27WrEn   = VectAddr27En & MrWrAccess;

assign VectAddr28WrEn   = VectAddr28En & MrWrAccess;

assign VectAddr29WrEn   = VectAddr29En & MrWrAccess;

assign VectAddr30WrEn   = VectAddr30En & MrWrAccess;

assign VectAddr31WrEn   = VectAddr31En & MrWrAccess;

assign VectPrity0WrEn   = VectPrity0En & MrWrAccess;

assign VectPrity1WrEn   = VectPrity1En & MrWrAccess;

assign VectPrity2WrEn   = VectPrity2En & MrWrAccess;

assign VectPrity3WrEn   = VectPrity3En & MrWrAccess;

assign VectPrity4WrEn   = VectPrity4En & MrWrAccess;

assign VectPrity5WrEn   = VectPrity5En & MrWrAccess;

assign VectPrity6WrEn   = VectPrity6En & MrWrAccess;

assign VectPrity7WrEn   = VectPrity7En & MrWrAccess;

assign VectPrity8WrEn   = VectPrity8En & MrWrAccess;

assign VectPrity9WrEn   = VectPrity9En & MrWrAccess;

assign VectPrity10WrEn  = VectPrity10En & MrWrAccess;

assign VectPrity11WrEn  = VectPrity11En & MrWrAccess;

assign VectPrity12WrEn  = VectPrity12En & MrWrAccess;

assign VectPrity13WrEn  = VectPrity13En & MrWrAccess;

assign VectPrity14WrEn  = VectPrity14En & MrWrAccess;

assign VectPrity15WrEn  = VectPrity15En & MrWrAccess;

assign VectPrity16WrEn  = VectPrity16En & MrWrAccess;

assign VectPrity17WrEn  = VectPrity17En & MrWrAccess;

assign VectPrity18WrEn  = VectPrity18En & MrWrAccess;

assign VectPrity19WrEn  = VectPrity19En & MrWrAccess;

assign VectPrity20WrEn  = VectPrity20En & MrWrAccess;

assign VectPrity21WrEn  = VectPrity21En & MrWrAccess;

assign VectPrity22WrEn  = VectPrity22En & MrWrAccess;

assign VectPrity23WrEn  = VectPrity23En & MrWrAccess;

assign VectPrity24WrEn  = VectPrity24En & MrWrAccess;

assign VectPrity25WrEn  = VectPrity25En & MrWrAccess;

assign VectPrity26WrEn  = VectPrity26En & MrWrAccess;

assign VectPrity27WrEn  = VectPrity27En & MrWrAccess;

assign VectPrity28WrEn  = VectPrity28En & MrWrAccess;

assign VectPrity29WrEn  = VectPrity29En & MrWrAccess;

assign VectPrity30WrEn  = VectPrity30En & MrWrAccess;

assign VectPrity31WrEn  = VectPrity31En & MrWrAccess;

assign VectPrityDsyWrEn = VectPrityDsyEn & MrWrAccess;

assign VICTrTCRWrEn     = VICTrTCREn & WrAccess;

assign TrIntSrcWrEn     = TrIntSourceEn & WrAccess;

assign TrIntInWrEn      = TrIntInEn & WrAccess;

assign TrIntInRegWrEn   = TrIntInRegEn & WrAccess;

assign TrVectAdInWrEn   = TrVectAdInEn & WrAccess;

assign TrSyncWrEn       = TrSyncEn & WrAccess;

assign TrAckCntWrEn     = TrAckCntEn & WrAccess;

// -----------------------------------------------------------------------------
// Combinational logic for all writeable registers.
//
// When the respective write enable input is asserted, copy the contents
// of the HWDATA bus into the corresponding registers.
// -----------------------------------------------------------------------------
assign NxtTrIntSelect   = (IntSelectWrEn == 1'b1) ?
                           HWDATA : VICTrIntSelect;

assign NxtTrSwPrityMask = (SwPrityMaskWrEn == 1'b1) ?
                           HWDATA : VICTrSwPriMask;

assign NxtTrIntEnable   = (IntEnableWrEn == 1'b1)    ?
                          (HWDATA | VICTrIntEnable)    :
                          ((IntEnClearWrEn == 1'b1)  ?
                          (~(HWDATA) & VICTrIntEnable) :
                           VICTrIntEnable);

assign NxtTrSoftInt     = (SoftIntWrEn == 1'b1)        ?
                          (HWDATA | VICTrSoftInt)    :
                          ((SoftIntClearWrEn == 1'b1)  ?
                          (~(HWDATA) & VICTrSoftInt) :
                           VICTrSoftInt);

assign NxtTrProtection  = (ProtectionWrEn == 1'b1) ?
                           HWDATA[0] : VICTrProtection;

assign NxtTrVectAddr0   = (VectAddr0WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr0;

assign NxtTrVectAddr1   = (VectAddr1WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr1;

assign NxtTrVectAddr2   = (VectAddr2WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr2;

assign NxtTrVectAddr3   = (VectAddr3WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr3;

assign NxtTrVectAddr4   = (VectAddr4WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr4;

assign NxtTrVectAddr5   = (VectAddr5WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr5;

assign NxtTrVectAddr6   = (VectAddr6WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr6;

assign NxtTrVectAddr7   = (VectAddr7WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr7;

assign NxtTrVectAddr8   = (VectAddr8WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr8;

assign NxtTrVectAddr9   = (VectAddr9WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr9;

assign NxtTrVectAddr10  = (VectAddr10WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr10;

assign NxtTrVectAddr11  = (VectAddr11WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr11;

assign NxtTrVectAddr12  = (VectAddr12WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr12;

assign NxtTrVectAddr13  = (VectAddr13WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr13;

assign NxtTrVectAddr14  = (VectAddr14WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr14;

assign NxtTrVectAddr15  = (VectAddr15WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr15;

assign NxtTrVectAddr16  = (VectAddr16WrEn == 1'b1) ?
                          HWDATA : VICTrVectAddr16;

assign NxtTrVectAddr17  = (VectAddr17WrEn == 1'b1) ?
                          HWDATA : VICTrVectAddr17;

assign NxtTrVectAddr18  = (VectAddr18WrEn == 1'b1) ?
                          HWDATA : VICTrVectAddr18;

assign NxtTrVectAddr19  = (VectAddr19WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr19;

assign NxtTrVectAddr20  = (VectAddr20WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr20;

assign NxtTrVectAddr21  = (VectAddr21WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr21;

assign NxtTrVectAddr22  = (VectAddr22WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr22;

assign NxtTrVectAddr23  = (VectAddr23WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr23;

assign NxtTrVectAddr24  = (VectAddr24WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr24;

assign NxtTrVectAddr25  = (VectAddr25WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr25;

assign NxtTrVectAddr26  = (VectAddr26WrEn == 1'b1) ?
                          HWDATA : VICTrVectAddr26;

assign NxtTrVectAddr27  = (VectAddr27WrEn == 1'b1) ?
                          HWDATA : VICTrVectAddr27;

assign NxtTrVectAddr28  = (VectAddr28WrEn == 1'b1) ?
                          HWDATA : VICTrVectAddr28;

assign NxtTrVectAddr29  = (VectAddr29WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr29;

assign NxtTrVectAddr30  = (VectAddr30WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr30;

assign NxtTrVectAddr31  = (VectAddr31WrEn == 1'b1) ?
                           HWDATA : VICTrVectAddr31;

assign NxtTrVectPrity0   = (VectPrity0WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity0;

assign NxtTrVectPrity1   = (VectPrity1WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity1;

assign NxtTrVectPrity2   = (VectPrity2WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity2;

assign NxtTrVectPrity3   = (VectPrity3WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity3;

assign NxtTrVectPrity4   = (VectPrity4WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity4;

assign NxtTrVectPrity5   = (VectPrity5WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity5;

assign NxtTrVectPrity6   = (VectPrity6WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity6;

assign NxtTrVectPrity7   = (VectPrity7WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity7;

assign NxtTrVectPrity8   = (VectPrity8WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity8;

assign NxtTrVectPrity9   = (VectPrity9WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity9;

assign NxtTrVectPrity10  = (VectPrity10WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity10;

assign NxtTrVectPrity11  = (VectPrity11WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity11;

assign NxtTrVectPrity12  = (VectPrity12WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity12;

assign NxtTrVectPrity13  = (VectPrity13WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity13;

assign NxtTrVectPrity14  = (VectPrity14WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity14;

assign NxtTrVectPrity15  = (VectPrity15WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity15;

assign NxtTrVectPrity16  = (VectPrity16WrEn == 1'b1) ?
                          HWDATA : VICTrVectPrity16;

assign NxtTrVectPrity17  = (VectPrity17WrEn == 1'b1) ?
                          HWDATA : VICTrVectPrity17;

assign NxtTrVectPrity18  = (VectPrity18WrEn == 1'b1) ?
                          HWDATA : VICTrVectPrity18;

assign NxtTrVectPrity19  = (VectPrity19WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity19;

assign NxtTrVectPrity20  = (VectPrity20WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity20;

assign NxtTrVectPrity21  = (VectPrity21WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity21;

assign NxtTrVectPrity22  = (VectPrity22WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity22;

assign NxtTrVectPrity23  = (VectPrity23WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity23;

assign NxtTrVectPrity24  = (VectPrity24WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity24;

assign NxtTrVectPrity25  = (VectPrity25WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity25;

assign NxtTrVectPrity26  = (VectPrity26WrEn == 1'b1) ?
                          HWDATA : VICTrVectPrity26;

assign NxtTrVectPrity27  = (VectPrity27WrEn == 1'b1) ?
                          HWDATA : VICTrVectPrity27;

assign NxtTrVectPrity28  = (VectPrity28WrEn == 1'b1) ?
                          HWDATA : VICTrVectPrity28;

assign NxtTrVectPrity29  = (VectPrity29WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity29;

assign NxtTrVectPrity30  = (VectPrity30WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity30;

assign NxtTrVectPrity31  = (VectPrity31WrEn == 1'b1) ?
                           HWDATA : VICTrVectPrity31;

assign NxtTrVectPrityDsy = (VectPrityDsyWrEn == 1'b1) ?
                           HWDATA : VICTrVectPriDsy;

assign NxtVICTrTCR      = (VICTrTCRWrEn == 1'b1) ?
                           HWDATA[8:0] : VICTrTCR;

assign NxtTrIntSource   = (TrIntSrcWrEn == 1'b1) ?
                           HWDATA : VICTrIntSource;

assign NxtTrIntIn       = (TrIntInWrEn == 1'b1) ?
                           HWDATA[1:0] : VICTrIntIn;

assign NxtTrIntInReg    = (TrIntInRegWrEn == 1'b1) ?
                           HWDATA[1:0] : VICTrIntInReg;

assign NxtTrVectAddrIn  = (TrVectAdInWrEn == 1'b1) ?
                           HWDATA : VICTrVectAddrIn;

assign NxtTrSync        = (TrSyncWrEn == 1'b1) ?
                           HWDATA : VICTrSync;

assign NxtTrAckCnt      = (TrAckCntWrEn == 1'b1) ?
                           HWDATA : VICTrAckCnt;

// -----------------------------------------------------------------------------
// Sequential logic for VICTrIntSelect, VICTrSwPriMask,VICTrIntEnable, 
// VICTrSoftInt, VICTrProtection 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrIntRegSeq
  if (HRESETn ==  1'b0)
    begin
      VICTrIntSelect   <= 32'h00000000;
      VICTrSwPriMask   <= 16'hFFFF;
      VICTrIntEnable   <= 32'h00000000;
      VICTrSoftInt     <= 32'h00000000;
      VICTrProtection  <= 1'b0;
    end
  else
    begin
      VICTrIntSelect   <= NxtTrIntSelect;
      VICTrSwPriMask   <= NxtTrSwPrityMask;
      VICTrIntEnable   <= NxtTrIntEnable;
      VICTrSoftInt     <= NxtTrSoftInt;
      VICTrProtection  <= NxtTrProtection;
    end
end // p_TrIntRegSeq

// -----------------------------------------------------------------------------
// Sequential logic for the VICTrVectAddr registers
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrVectAddrSeq
  if (HRESETn ==  1'b0)
    begin
      VICTrVectAddr0  <= 32'h00000000;
      VICTrVectAddr1  <= 32'h00000000;
      VICTrVectAddr2  <= 32'h00000000;
      VICTrVectAddr3  <= 32'h00000000;
      VICTrVectAddr4  <= 32'h00000000;
      VICTrVectAddr5  <= 32'h00000000;
      VICTrVectAddr6  <= 32'h00000000;
      VICTrVectAddr7  <= 32'h00000000;
      VICTrVectAddr8  <= 32'h00000000;
      VICTrVectAddr9  <= 32'h00000000;
      VICTrVectAddr10 <= 32'h00000000;
      VICTrVectAddr11 <= 32'h00000000;
      VICTrVectAddr12 <= 32'h00000000;
      VICTrVectAddr13 <= 32'h00000000;
      VICTrVectAddr14 <= 32'h00000000;
      VICTrVectAddr15 <= 32'h00000000;
      VICTrVectAddr16 <= 32'h00000000;
      VICTrVectAddr17 <= 32'h00000000;
      VICTrVectAddr18 <= 32'h00000000;
      VICTrVectAddr19 <= 32'h00000000;
      VICTrVectAddr20 <= 32'h00000000;
      VICTrVectAddr21 <= 32'h00000000;
      VICTrVectAddr22 <= 32'h00000000;
      VICTrVectAddr23 <= 32'h00000000;
      VICTrVectAddr24 <= 32'h00000000;
      VICTrVectAddr25 <= 32'h00000000;
      VICTrVectAddr26 <= 32'h00000000;
      VICTrVectAddr27 <= 32'h00000000;
      VICTrVectAddr28 <= 32'h00000000;
      VICTrVectAddr29 <= 32'h00000000;
      VICTrVectAddr30 <= 32'h00000000;
      VICTrVectAddr31 <= 32'h00000000;
    end
  else
    begin
      VICTrVectAddr0  <= NxtTrVectAddr0;
      VICTrVectAddr1  <= NxtTrVectAddr1;
      VICTrVectAddr2  <= NxtTrVectAddr2;
      VICTrVectAddr3  <= NxtTrVectAddr3;
      VICTrVectAddr4  <= NxtTrVectAddr4;
      VICTrVectAddr5  <= NxtTrVectAddr5;
      VICTrVectAddr6  <= NxtTrVectAddr6;
      VICTrVectAddr7  <= NxtTrVectAddr7;
      VICTrVectAddr8  <= NxtTrVectAddr8;
      VICTrVectAddr9  <= NxtTrVectAddr9;
      VICTrVectAddr10 <= NxtTrVectAddr10;
      VICTrVectAddr11 <= NxtTrVectAddr11;
      VICTrVectAddr12 <= NxtTrVectAddr12;
      VICTrVectAddr13 <= NxtTrVectAddr13;
      VICTrVectAddr14 <= NxtTrVectAddr14;
      VICTrVectAddr15 <= NxtTrVectAddr15;
      VICTrVectAddr16 <= NxtTrVectAddr16;
      VICTrVectAddr17 <= NxtTrVectAddr17;
      VICTrVectAddr18 <= NxtTrVectAddr18;
      VICTrVectAddr19 <= NxtTrVectAddr19;
      VICTrVectAddr20 <= NxtTrVectAddr20;
      VICTrVectAddr21 <= NxtTrVectAddr21;
      VICTrVectAddr22 <= NxtTrVectAddr22;
      VICTrVectAddr23 <= NxtTrVectAddr23;
      VICTrVectAddr24 <= NxtTrVectAddr24;
      VICTrVectAddr25 <= NxtTrVectAddr25;
      VICTrVectAddr26 <= NxtTrVectAddr26;
      VICTrVectAddr27 <= NxtTrVectAddr27;
      VICTrVectAddr28 <= NxtTrVectAddr28;
      VICTrVectAddr29 <= NxtTrVectAddr29;
      VICTrVectAddr30 <= NxtTrVectAddr30;
      VICTrVectAddr31 <= NxtTrVectAddr31;
    end
end // p_TrVectAddrSeq

// -----------------------------------------------------------------------------
// Sequential logic for the VICTrVectPrity registers
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrVectPritySeq
  if (HRESETn ==  1'b0)
    begin
      VICTrVectPrity0  <= 4'b1111;
      VICTrVectPrity1  <= 4'b1111;
      VICTrVectPrity2  <= 4'b1111;
      VICTrVectPrity3  <= 4'b1111;
      VICTrVectPrity4  <= 4'b1111;
      VICTrVectPrity5  <= 4'b1111;
      VICTrVectPrity6  <= 4'b1111;
      VICTrVectPrity7  <= 4'b1111;
      VICTrVectPrity8  <= 4'b1111;
      VICTrVectPrity9  <= 4'b1111;
      VICTrVectPrity10 <= 4'b1111;
      VICTrVectPrity11 <= 4'b1111;
      VICTrVectPrity12 <= 4'b1111;
      VICTrVectPrity13 <= 4'b1111;
      VICTrVectPrity14 <= 4'b1111;
      VICTrVectPrity15 <= 4'b1111;
      VICTrVectPrity16 <= 4'b1111;
      VICTrVectPrity17 <= 4'b1111;
      VICTrVectPrity18 <= 4'b1111;
      VICTrVectPrity19 <= 4'b1111;
      VICTrVectPrity20 <= 4'b1111;
      VICTrVectPrity21 <= 4'b1111;
      VICTrVectPrity22 <= 4'b1111;
      VICTrVectPrity23 <= 4'b1111;
      VICTrVectPrity24 <= 4'b1111;
      VICTrVectPrity25 <= 4'b1111;
      VICTrVectPrity26 <= 4'b1111;
      VICTrVectPrity27 <= 4'b1111;
      VICTrVectPrity28 <= 4'b1111;
      VICTrVectPrity29 <= 4'b1111;
      VICTrVectPrity30 <= 4'b1111;
      VICTrVectPrity31 <= 4'b1111;
      VICTrVectPriDsy  <= 4'b1111;
    end
  else
    begin
      VICTrVectPrity0  <= NxtTrVectPrity0;
      VICTrVectPrity1  <= NxtTrVectPrity1;
      VICTrVectPrity2  <= NxtTrVectPrity2;
      VICTrVectPrity3  <= NxtTrVectPrity3;
      VICTrVectPrity4  <= NxtTrVectPrity4;
      VICTrVectPrity5  <= NxtTrVectPrity5;
      VICTrVectPrity6  <= NxtTrVectPrity6;
      VICTrVectPrity7  <= NxtTrVectPrity7;
      VICTrVectPrity8  <= NxtTrVectPrity8;
      VICTrVectPrity9  <= NxtTrVectPrity9;
      VICTrVectPrity10 <= NxtTrVectPrity10;
      VICTrVectPrity11 <= NxtTrVectPrity11;
      VICTrVectPrity12 <= NxtTrVectPrity12;
      VICTrVectPrity13 <= NxtTrVectPrity13;
      VICTrVectPrity14 <= NxtTrVectPrity14;
      VICTrVectPrity15 <= NxtTrVectPrity15;
      VICTrVectPrity16 <= NxtTrVectPrity16;
      VICTrVectPrity17 <= NxtTrVectPrity17;
      VICTrVectPrity18 <= NxtTrVectPrity18;
      VICTrVectPrity19 <= NxtTrVectPrity19;
      VICTrVectPrity20 <= NxtTrVectPrity20;
      VICTrVectPrity21 <= NxtTrVectPrity21;
      VICTrVectPrity22 <= NxtTrVectPrity22;
      VICTrVectPrity23 <= NxtTrVectPrity23;
      VICTrVectPrity24 <= NxtTrVectPrity24;
      VICTrVectPrity25 <= NxtTrVectPrity25;
      VICTrVectPrity26 <= NxtTrVectPrity26;
      VICTrVectPrity27 <= NxtTrVectPrity27;
      VICTrVectPrity28 <= NxtTrVectPrity28;
      VICTrVectPrity29 <= NxtTrVectPrity29;
      VICTrVectPrity30 <= NxtTrVectPrity30;
      VICTrVectPrity31 <= NxtTrVectPrity31;
      VICTrVectPriDsy  <= NxtTrVectPrityDsy;
    end
end // p_TrVectPritySeq

// -----------------------------------------------------------------------------
// Sequential logic for VICTrTCR, VICTrIntSource, VICTrIntIn and
// VICTrVectAddrIn
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrRegSeq
  if (HRESETn ==  1'b0)
    begin
      VICTrTCR        <= 9'b000000000;
      VICTrIntSource  <= 32'h00000000;
      VICTrIntIn      <= 2'b11;
      VICTrIntInReg   <= 2'b00;
      VICTrVectAddrIn <= 32'h00000000;
      VICTrSync       <= 1'b1;
      VICTrAckCnt     <= 3'b000;
    end
  else
    begin
      VICTrTCR        <= NxtVICTrTCR;
      VICTrIntSource  <= NxtTrIntSource;
      VICTrIntIn      <= NxtTrIntIn;
      VICTrIntInReg   <= NxtTrIntInReg;
      VICTrVectAddrIn <= NxtTrVectAddrIn;
      VICTrSync       <= NxtTrSync;
      VICTrAckCnt     <= NxtTrAckCnt;
    end
end // p_TrRegSeq

// -----------------------------------------------------------------------------
// Acknowledge generation. VICTrAckCnt register can be programmed to delay the 
// acknowledge signal generation for vic port handshake. The signal is delayed 
// based on the count loaded in the register 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TrAckSeq
  if (HRESETn ==  1'b0)
    begin
      VICTrAckCnt1    <= 1'b0;
      VICTrAckCnt2    <= 1'b0;
      VICTrAckCnt3    <= 1'b0;
      VICTrAckCnt4    <= 1'b0;
      VICTrAckCnt5    <= 1'b0;
      VICTrAckCnt6    <= 1'b0;
      VICTrAckCnt7    <= 1'b0;
    end
  else
    begin
      if(nVICIRQ == 1'b0)
        begin
          VICTrAckCnt1 <= |VICTrAckCnt;
          VICTrAckCnt2 <= VICTrAckCnt1;
          VICTrAckCnt3 <= VICTrAckCnt2;
          VICTrAckCnt4 <= VICTrAckCnt3;
          VICTrAckCnt5 <= VICTrAckCnt4;
          VICTrAckCnt6 <= VICTrAckCnt5;
          VICTrAckCnt7 <= VICTrAckCnt6;
        end
      else
        begin
          VICTrAckCnt1    <= 1'b0;
          VICTrAckCnt2    <= 1'b0;
          VICTrAckCnt3    <= 1'b0;
          VICTrAckCnt4    <= 1'b0;
          VICTrAckCnt5    <= 1'b0;
          VICTrAckCnt6    <= 1'b0;
          VICTrAckCnt7    <= 1'b0;
        end
    end
end // p_TrAckSeq

// -----------------------------------------------------------------------------
// Multiplexing RdData1 bus
// -----------------------------------------------------------------------------
assign RdData1          = (IntSelectRdEn == 1'b1)    ?
                           VICTrIntSelect                :
                          ((SwPrityMaskRdEn == 1'b1) ?
                           VICTrSwPriMask                :
                          ((IntEnableRdEn == 1'b1)   ?
                           VICTrIntEnable                :
                          ((SoftIntRdEn == 1'b1)     ?
                           VICTrSoftInt                  :
                          ((VectAddrRdEn == 1'b1)    ?
                           VICTrVectAddr                 :
                          ((VICTrTCRRdEn == 1'b1)    ?
                           {ZEROFILL[31:3], VICTrTCR}    :
                          ((TrIntSrcRdEn == 1'b1)    ?
                           VICTrIntSource                :
                          ((IntStatRdEn == 1'b1)     ?
                           {ZEROFILL[31:2], nVICFIQ, nVICIRQ} :
                          ((TrIntInRdEn == 1'b1)     ?
                           {ZEROFILL[31:2], VICTrIntIn}  :
                          ((TrIntInRegRdEn == 1'b1)     ?
                           {ZEROFILL[31:2], VICTrIntInReg}  :
                          ((TrSyncRdEn == 1'b1)     ?
                           {ZEROFILL[31:1], VICTrSync}  :
                          ((TrAckCntRdEn == 1'b1)     ?
                           {ZEROFILL[31:8], VICTrAckCnt}  :
                          ((TrVectAdInRdEn == 1'b1)  ?
                           VICTrVectAddrIn               :
                          ((TrVectAdOutRdEn == 1'b1) ?
                           VICVECTADDROUT                :
                          ((WaitCount == `WAITSTATES) ?
                           (32'h55555555)                :
                           (ZEROFILL)))))))))))))));

// -----------------------------------------------------------------------------
// Multiplexing RdData2 bus
// -----------------------------------------------------------------------------
assign RdData2          = (VectAddr0RdEn == 1'b1)   ?
                           VICTrVectAddr0  :
                          ((VectAddr1RdEn == 1'b1)  ?
                           VICTrVectAddr1  :
                          ((VectAddr2RdEn == 1'b1)  ?
                           VICTrVectAddr2  :
                          ((VectAddr3RdEn == 1'b1)  ?
                           VICTrVectAddr3  :
                          ((VectAddr4RdEn == 1'b1)  ?
                           VICTrVectAddr4  :
                          ((VectAddr5RdEn == 1'b1)  ?
                           VICTrVectAddr5  :
                          ((VectAddr6RdEn == 1'b1)  ?
                           VICTrVectAddr6  :
                          ((VectAddr7RdEn == 1'b1)  ?
                           VICTrVectAddr7  :
                          ((VectAddr8RdEn == 1'b1)  ?
                           VICTrVectAddr8  :
                          ((VectAddr9RdEn == 1'b1)  ?
                           VICTrVectAddr9  :
                          ((VectAddr10RdEn == 1'b1) ?
                           VICTrVectAddr10 :
                          ((VectAddr11RdEn == 1'b1) ?
                           VICTrVectAddr11 :
                          ((VectAddr12RdEn == 1'b1) ?
                           VICTrVectAddr12 :
                          ((VectAddr13RdEn == 1'b1) ?
                           VICTrVectAddr13 :
                          ((VectAddr14RdEn == 1'b1) ?
                           VICTrVectAddr14 :
                          ((VectAddr15RdEn == 1'b1) ?
                           VICTrVectAddr15 :
                          ((VectAddr16RdEn == 1'b1)  ?
                           VICTrVectAddr16  :
                          ((VectAddr17RdEn == 1'b1)  ?
                           VICTrVectAddr17  :
                          ((VectAddr18RdEn == 1'b1)  ?
                           VICTrVectAddr18  :
                          ((VectAddr19RdEn == 1'b1)  ?
                           VICTrVectAddr19  :
                          ((VectAddr20RdEn == 1'b1) ?
                           VICTrVectAddr20 :
                          ((VectAddr21RdEn == 1'b1) ?
                           VICTrVectAddr21 :
                          ((VectAddr22RdEn == 1'b1) ?
                           VICTrVectAddr22 :
                          ((VectAddr23RdEn == 1'b1) ?
                           VICTrVectAddr23 :
                          ((VectAddr24RdEn == 1'b1) ?
                           VICTrVectAddr24 :
                          ((VectAddr25RdEn == 1'b1) ?
                           VICTrVectAddr25 :
                          ((VectAddr26RdEn == 1'b1)  ?
                           VICTrVectAddr26  :
                          ((VectAddr27RdEn == 1'b1)  ?
                           VICTrVectAddr27  :
                          ((VectAddr28RdEn == 1'b1)  ?
                           VICTrVectAddr28  :
                          ((VectAddr29RdEn == 1'b1)  ?
                           VICTrVectAddr29  :
                          ((VectAddr30RdEn == 1'b1) ?
                           VICTrVectAddr30 :
                          ((VectAddr31RdEn == 1'b1) ?
                           VICTrVectAddr31 :
                           (ZEROFILL))))))))))))))))))))))))))))))));

// -----------------------------------------------------------------------------
// Multiplexing RdData3 bus
// -----------------------------------------------------------------------------
assign RdData3          = (VectPrity0RdEn == 1'b1)    ?
                           {ZEROFILL[31:4], VICTrVectPrity0}  :
                           ((VectPrity1RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity1}  :
                           ((VectPrity2RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity2}  :
                           ((VectPrity3RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity3}  :
                           ((VectPrity4RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity4}  :
                           ((VectPrity5RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity5}  :
                           ((VectPrity6RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity6}  :
                           ((VectPrity7RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity7}  :
                           ((VectPrity8RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity8}  :
                           ((VectPrity9RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity9}  :
                           ((VectPrity10RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity10} :
                           ((VectPrity11RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity11} :
                           ((VectPrity12RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity12} :
                           ((VectPrity13RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity13} :
                           ((VectPrity14RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity14} :
                           ((VectPrity15RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity15} :
                           ((VectPrity16RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity16} :
                           ((VectPrity17RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity17} :
                           ((VectPrity18RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity18} :
                           ((VectPrity19RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity19} :
                           ((VectPrity20RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity20} :
                           ((VectPrity21RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity21} :
                           ((VectPrity22RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity22} :
                           ((VectPrity23RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity23} :
                           ((VectPrity24RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity24} :
                           ((VectPrity25RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity25} :
                           ((VectPrity26RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity26} :
                           ((VectPrity27RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity27} :
                           ((VectPrity28RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity28} :
                           ((VectPrity29RdEn == 1'b1)  ?
                           {ZEROFILL[31:4], VICTrVectPrity29} :
                           ((VectPrity30RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity30} :
                           ((VectPrity31RdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPrity31} :
                           ((VectPrityDsyRdEn == 1'b1) ?
                           {ZEROFILL[31:4], VICTrVectPriDsy} :
                           (ZEROFILL)))))))))))))))))))))))))))))))));

// -----------------------------------------------------------------------------
// Assigning Internal Read Data bus
// -----------------------------------------------------------------------------
assign RdData           = (RdData1 | RdData2 | RdData3);

// -----------------------------------------------------------------------------
// Inserting Wait States
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_WaitStatesSeq 
  if (HRESETn == 1'b0)
    WaitCount <= 0;
  else
    if (DeviceSel == 1'b1)
      if (WaitStRegEn == 1'b1 || WaitCount != 0)
        if (WaitCount < `WAITSTATES)
          WaitCount <= WaitCount + 1;
        else
          WaitCount <= 0;
      else
        WaitCount <= 0;
    else
      WaitCount <= 0;
end // p_WaitStatesSeq

// -----------------------------------------------------------------------------
// HREADYOUT Generation
// -----------------------------------------------------------------------------
always @(HRESETn or DeviceSel or WaitStRegEn or WaitCount)
begin : p_HREADYComb
  if (HRESETn ==  1'b0)
    HREADYOUT = `TR_H_READY;
  else if (DeviceSel ==  1'b1)
    if (WaitStRegEn == 1'b1)
      if (WaitCount == `WAITSTATES)
        HREADYOUT = `TR_H_READY;
      else
        HREADYOUT = `TR_H_WAIT;
    else
      HREADYOUT = `TR_H_READY;
  else
    HREADYOUT = `TR_H_READY;
end // p_HREADYComb

// -----------------------------------------------------------------------------
// AHB Output Assignments
// -----------------------------------------------------------------------------
assign HRDATA           = (RdAccess == 1'b1) ? RdData : (ZEROFILL);

assign HRESP            = `TR_H_OKAY;

// -----------------------------------------------------------------------------
// Read and Write Trigger to Mirrored trickbox to indicate the read and write
// on VICADDRESS register(uut).
// -----------------------------------------------------------------------------
assign iVectAddrRdTrig = VectAddrEn & MrRdAccesstmp;
assign iVectAddrWrTrig = VectAddrWrEn;

assign VectAddrRdTrig = iVectAddrRdTrig;
assign VectAddrWrTrig = iVectAddrWrTrig;

assign MrRdAccesstmp = MrRdAccess;
assign MrWrAccesstmp = MrWrAccess;

assign AsyncRdEn = VectAddrEnA & NxtMrRdAccess;

endmodule

// --=============================== End =====================================--
