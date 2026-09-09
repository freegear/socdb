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
// File Name              : VicTrIrqPriLog.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           VIC IRQ Priority Logic.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicTrIrqPriLog (
// Inputs
                       HCLK,
                       HRESETn,
                       TrnIrq,
                       IrqStatus,
                       DaisyIrqOut,
                       TrVectIrq,
                       nVicTrSyncEn,
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
                       PPTable15,
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
                       VicTrVectAddrIn,
                       VicTrIrqAck,
                       VectAddrWrTrigIn,
                       VectAddrRdTrigIn,
                       AsyncRdEn,

// Outputs
                       VicTrIrqOut,
                       nTrIrq,
                       VectAddrVld, 
                       VicTrVectAddrv,
                       MaskPrityReg, 
                       VicTrVectAddr
                      );

// Inputs
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
input  [32:0] TrVectIrq;        // VectIRQ from IRQ Interrupt Logic 
                                // & Daisy Chain
input         TrnIrq;           // Irq Signal
input         DaisyIrqOut;      // Daisy Irq Interrupt
input  [31:0] IrqStatus;        // IRQ Status from Interrupt request Logic Block
input         nVicTrSyncEn;     // Sync Enable Input 
input  [32:0] PPTable0;         // Priority Level 0    
input  [32:0] PPTable1;         // Priority Level 1 
input  [32:0] PPTable2;         // Priority Level 2 
input  [32:0] PPTable3;         // Priority Level 3 
input  [32:0] PPTable4;         // Priority Level 4 
input  [32:0] PPTable5;         // Priority Level 5 
input  [32:0] PPTable6;         // Priority Level 6 
input  [32:0] PPTable7;         // Priority Level 7 
input  [32:0] PPTable8;         // Priority Level 8 
input  [32:0] PPTable9;         // Priority Level 9 
input  [32:0] PPTable10;        // Priority Level 10 
input  [32:0] PPTable11;        // Priority Level 11 
input  [32:0] PPTable12;        // Priority Level 12 
input  [32:0] PPTable13;        // Priority Level 13 
input  [32:0] PPTable14;        // Priority Level 14 
input  [32:0] PPTable15;        // Priority Level 15 
input  [31:0] VicTrVectAddr0;   // IRQ Vector Address register 0
input  [31:0] VicTrVectAddr1;   // IRQ Vector Address register 1
input  [31:0] VicTrVectAddr2;   // IRQ Vector Address register 2
input  [31:0] VicTrVectAddr3;   // IRQ Vector Address register 3
input  [31:0] VicTrVectAddr4;   // IRQ Vector Address register 4
input  [31:0] VicTrVectAddr5;   // IRQ Vector Address register 5
input  [31:0] VicTrVectAddr6;   // IRQ Vector Address register 6
input  [31:0] VicTrVectAddr7;   // IRQ Vector Address register 7
input  [31:0] VicTrVectAddr8;   // IRQ Vector Address register 8
input  [31:0] VicTrVectAddr9;   // IRQ Vector Address register 9
input  [31:0] VicTrVectAddr10;  // IRQ Vector Address register 10
input  [31:0] VicTrVectAddr11;  // IRQ Vector Address register 11
input  [31:0] VicTrVectAddr12;  // IRQ Vector Address register 12
input  [31:0] VicTrVectAddr13;  // IRQ Vector Address register 13
input  [31:0] VicTrVectAddr14;  // IRQ Vector Address register 14
input  [31:0] VicTrVectAddr15;  // IRQ Vector Address register 15
input  [31:0] VicTrVectAddr16;  // IRQ Vector Address register 16
input  [31:0] VicTrVectAddr17;  // IRQ Vector Address register 17
input  [31:0] VicTrVectAddr18;  // IRQ Vector Address register 18
input  [31:0] VicTrVectAddr19;  // IRQ Vector Address register 19
input  [31:0] VicTrVectAddr20;  // IRQ Vector Address register 20
input  [31:0] VicTrVectAddr21;  // IRQ Vector Address register 21
input  [31:0] VicTrVectAddr22;  // IRQ Vector Address register 22
input  [31:0] VicTrVectAddr23;  // IRQ Vector Address register 23
input  [31:0] VicTrVectAddr24;  // IRQ Vector Address register 24
input  [31:0] VicTrVectAddr25;  // IRQ Vector Address register 25
input  [31:0] VicTrVectAddr26;  // IRQ Vector Address register 26
input  [31:0] VicTrVectAddr27;  // IRQ Vector Address register 27
input  [31:0] VicTrVectAddr28;  // IRQ Vector Address register 28
input  [31:0] VicTrVectAddr29;  // IRQ Vector Address register 29
input  [31:0] VicTrVectAddr30;  // IRQ Vector Address register 30
input  [31:0] VicTrVectAddr31;  // IRQ Vector Address register 31
input  [31:0] VicTrVectAddrIn;  // IRQ Daisy Chain Address 
input          VicTrIrqAck;     // Acknowledge from the CPU
input          VectAddrWrTrigIn;// Write Trigger to indicate write on 
                                // VICADDRESS register of uut
input          VectAddrRdTrigIn;// Read Trigger to indicate write on
                                // VICADDRESS register of uut  
input          AsyncRdEn;       // Async Read enable

// Outputs
output        nTrIrq;           // IRQ Interrupt Output
output        VicTrIrqOut;      // IRQ Pulse to VIC in daisy chain
output        VectAddrVld;      // Address Valid Indicator
output        VicTrVectAddrv;   // Address Valid Indicator
output [31:0] VicTrVectAddr;    // Local copy VicTrVectAddr register 
output [15:0] MaskPrityReg;

// Inputs
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
wire   [32:0] TrVectIrq;        // VectIRQ from IRQ Interrupt Logic & 
                                // Daisy Chain
wire          DaisyIrqOut;
wire          TrnIrq;           // Irq Signal
wire  [31:0] IrqStatus;         // IRQ Status from Interrupt request Logic Block
wire          nVicTrSyncEn;     // Sync Enable Input 
wire   [32:0] PPTable0;         // Priority Level 0    
wire   [32:0] PPTable1;         // Priority Level 1 
wire   [32:0] PPTable2;         // Priority Level 2 
wire   [32:0] PPTable3;         // Priority Level 3 
wire   [32:0] PPTable4;         // Priority Level 4 
wire   [32:0] PPTable5;         // Priority Level 5 
wire   [32:0] PPTable6;         // Priority Level 6 
wire   [32:0] PPTable7;         // Priority Level 7 
wire   [32:0] PPTable8;         // Priority Level 8 
wire   [32:0] PPTable9;         // Priority Level 9 
wire   [32:0] PPTable10;        // Priority Level 10 
wire   [32:0] PPTable11;        // Priority Level 11 
wire   [32:0] PPTable12;        // Priority Level 12 
wire   [32:0] PPTable13;        // Priority Level 13 
wire   [32:0] PPTable14;        // Priority Level 14 
wire   [32:0] PPTable15;        // Priority Level 15 
wire   [31:0] VicTrVectAddr0;   // IRQ Vector Address register 0
wire   [31:0] VicTrVectAddr1;   // IRQ Vector Address register 1
wire   [31:0] VicTrVectAddr2;   // IRQ Vector Address register 2
wire   [31:0] VicTrVectAddr3;   // IRQ Vector Address register 3
wire   [31:0] VicTrVectAddr4;   // IRQ Vector Address register 4
wire   [31:0] VicTrVectAddr5;   // IRQ Vector Address register 5
wire   [31:0] VicTrVectAddr6;   // IRQ Vector Address register 6
wire   [31:0] VicTrVectAddr7;   // IRQ Vector Address register 7
wire   [31:0] VicTrVectAddr8;   // IRQ Vector Address register 8
wire   [31:0] VicTrVectAddr9;   // IRQ Vector Address register 9
wire   [31:0] VicTrVectAddr10;  // IRQ Vector Address register 10
wire   [31:0] VicTrVectAddr11;  // IRQ Vector Address register 11
wire   [31:0] VicTrVectAddr12;  // IRQ Vector Address register 12
wire   [31:0] VicTrVectAddr13;  // IRQ Vector Address register 13
wire   [31:0] VicTrVectAddr14;  // IRQ Vector Address register 14
wire   [31:0] VicTrVectAddr15;  // IRQ Vector Address register 15
wire   [31:0] VicTrVectAddr16;  // IRQ Vector Address register 16
wire   [31:0] VicTrVectAddr17;  // IRQ Vector Address register 17
wire   [31:0] VicTrVectAddr18;  // IRQ Vector Address register 18
wire   [31:0] VicTrVectAddr19;  // IRQ Vector Address register 19
wire   [31:0] VicTrVectAddr20;  // IRQ Vector Address register 20
wire   [31:0] VicTrVectAddr21;  // IRQ Vector Address register 21
wire   [31:0] VicTrVectAddr22;  // IRQ Vector Address register 22
wire   [31:0] VicTrVectAddr23;  // IRQ Vector Address register 23
wire   [31:0] VicTrVectAddr24;  // IRQ Vector Address register 24
wire   [31:0] VicTrVectAddr25;  // IRQ Vector Address register 25
wire   [31:0] VicTrVectAddr26;  // IRQ Vector Address register 26
wire   [31:0] VicTrVectAddr27;  // IRQ Vector Address register 27
wire   [31:0] VicTrVectAddr28;  // IRQ Vector Address register 28
wire   [31:0] VicTrVectAddr29;  // IRQ Vector Address register 29
wire   [31:0] VicTrVectAddr30;  // IRQ Vector Address register 30
wire   [31:0] VicTrVectAddr31;  // IRQ Vector Address register 31
wire   [31:0] VicTrVectAddrIn;  // IRQ Daisy Chain Address 
wire          VicTrIrqAck;      // Acknowledge from the CPU   
wire          VectAddrWrTrigIn; // Write Trigger to indicate write on 
                                // VICADDRESS register of uut
wire          VectAddrRdTrigIn; // Read Trigger to indicate write on
                                // VICADDRESS register of uut  
wire          AsyncRdEn;        // Async Read enable

// Outputs
wire          nTrIrq;           // IRQ Interrupt Output
wire          VicTrIrqOut;      // IRQ Pulse to VIC in daisy chain
wire          VectAddrVld;      // Address Valid Indicator
wire          VicTrVectAddrv;   // Address Valid Indicator
reg   [31:0]  VicTrVectAddr;    // Local copy VicTrVectAddr register 
wire  [15:0]  MaskPrityReg;     // Mask Value when a read on vicaddress or 
                                // acknowledge
// -----------------------------------------------------------------------------
//
//                             VicTrIrqPriLog
//                             ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module resolves the priority of interrupts and decodes the address
// of the highest interrupt selected. Masking of the lower and equal priority 
// interrupts when a Read on vicaddress register or Acknowledge from the cpu.
// Unmasking the equal and lower priority interrupts when a write on vicaddress 
// register. It also generates the VicTrVectAddrv signal for the VIC port.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define SRC0  33'b000000000000000000000000000000001
`define SRC1  33'b000000000000000000000000000000010
`define SRC2  33'b000000000000000000000000000000100
`define SRC3  33'b000000000000000000000000000001000
`define SRC4  33'b000000000000000000000000000010000
`define SRC5  33'b000000000000000000000000000100000
`define SRC6  33'b000000000000000000000000001000000
`define SRC7  33'b000000000000000000000000010000000
`define SRC8  33'b000000000000000000000000100000000
`define SRC9  33'b000000000000000000000001000000000
`define SRC10 33'b000000000000000000000010000000000
`define SRC11 33'b000000000000000000000100000000000
`define SRC12 33'b000000000000000000001000000000000
`define SRC13 33'b000000000000000000010000000000000
`define SRC14 33'b000000000000000000100000000000000
`define SRC15 33'b000000000000000001000000000000000
`define SRC16 33'b000000000000000010000000000000000
`define SRC17 33'b000000000000000100000000000000000
`define SRC18 33'b000000000000001000000000000000000
`define SRC19 33'b000000000000010000000000000000000
`define SRC20 33'b000000000000100000000000000000000
`define SRC21 33'b000000000001000000000000000000000
`define SRC22 33'b000000000010000000000000000000000
`define SRC23 33'b000000000100000000000000000000000
`define SRC24 33'b000000001000000000000000000000000
`define SRC25 33'b000000010000000000000000000000000
`define SRC26 33'b000000100000000000000000000000000
`define SRC27 33'b000001000000000000000000000000000
`define SRC28 33'b000010000000000000000000000000000
`define SRC29 33'b000100000000000000000000000000000
`define SRC30 33'b001000000000000000000000000000000
`define SRC31 33'b010000000000000000000000000000000
`define SRC32 33'b100000000000000000000000000000000
`define NOSRC 33'b000000000000000000000000000000000

`define MASK0  16'b0000000000000000
`define MASK1  16'b0000000000000001
`define MASK2  16'b0000000000000011
`define MASK3  16'b0000000000000111
`define MASK4  16'b0000000000001111
`define MASK5  16'b0000000000011111
`define MASK6  16'b0000000000111111
`define MASK7  16'b0000000001111111
`define MASK8  16'b0000000011111111
`define MASK9  16'b0000000111111111
`define MASK10 16'b0000001111111111
`define MASK11 16'b0000011111111111
`define MASK12 16'b0000111111111111
`define MASK13 16'b0001111111111111
`define MASK14 16'b0011111111111111
`define MASK15 16'b0111111111111111
`define NOMASK 16'b1111111111111111

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
integer count;
wire        EnTrIrq;            // Indicates active interrupts 
wire        EnTrIrqs;           // For synchronous input ie nVICTrSyncEn high
wire        IrqAckTrig;         // Acknowledge Trigger
wire        IrqOut;             // For Irq out generation
wire [15:0] PriCheck;           // Priority check gets updated on new 
                                // selected level
wire        IrqMask;            // Mask Irq Out    
wire [32:0] ResTable0;          // Result Table 0
wire [32:0] ResTable1;          // Result Table 1
wire [32:0] ResTable2;          // Result Table 2
wire [32:0] ResTable3;          // Result Table 3
wire [32:0] ResTable4;          // Result Table 4
wire [32:0] ResTable5;          // Result Table 5
wire [32:0] ResTable6;          // Result Table 6
wire [32:0] ResTable7;          // Result Table 7
wire [32:0] ResTable8;          // Result Table 8
wire [32:0] ResTable9;          // Result Table 9
wire [32:0] ResTable10;         // Result Table 10
wire [32:0] ResTable11;         // Result Table 11
wire [32:0] ResTable12;         // Result Table 12
wire [32:0] ResTable13;         // Result Table 13
wire [32:0] ResTable14;         // Result Table 14
wire [32:0] ResTable15;         // Result Table 15
wire [32:0] EnIrqReg0;          // Active interrupts at Priority Level 0
wire [32:0] EnIrqReg1;          // Active interrupts at Priority Level 1
wire [32:0] EnIrqReg2;          // Active interrupts at Priority Level 2
wire [32:0] EnIrqReg3;          // Active interrupts at Priority Level 3
wire [32:0] EnIrqReg4;          // Active interrupts at Priority Level 4
wire [32:0] EnIrqReg5;          // Active interrupts at Priority Level 5
wire [32:0] EnIrqReg6;          // Active interrupts at Priority Level 6
wire [32:0] EnIrqReg7;          // Active interrupts at Priority Level 7
wire [32:0] EnIrqReg8;          // Active interrupts at Priority Level 8
wire [32:0] EnIrqReg9;          // Active interrupts at Priority Level 9
wire [32:0] EnIrqReg10;         // Active interrupts at Priority Level 10
wire [32:0] EnIrqReg11;         // Active interrupts at Priority Level 11
wire [32:0] EnIrqReg12;         // Active interrupts at Priority Level 12
wire [32:0] EnIrqReg13;         // Active interrupts at Priority Level 13
wire [32:0] EnIrqReg14;         // Active interrupts at Priority Level 14
wire [32:0] EnIrqReg15;         // Active interrupts at Priority Level 15

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg        VicTrIrqAck1;        // Acknowledge first latched version
reg        VicTrIrqAck2;        // Acknowledge second latched version
reg        VicTrIrqAck3;        // Acknowledge third latched version
reg        VicTrIrqAckc;        // Acknowledge first latched version
reg        AckHap;              // Trigger to disable nTrIrq line
reg        EnTrIrqa;            // Async Acknowledge delayed version of Sync one
reg        EnTrIrqa1;           // Registered EnTrIrqs
reg        AckTrig;             // Trigger for Acknowledge
reg        AckTrigReg;          // Registered Trigger for Acknowledge
reg        GenAck;              // Indicates new interrupts 
reg        GenAckReg;           // Registered GenAck
reg        PriCheckReg;         // Registered PriCheck
reg        DaisySel;            // Daisy Interrupt Select 
reg [31:0] NxtVectAddrInt;      // Registered Decoded address
reg [31:0] VicTrVectAddrInt;    // Decoded Priority Address
reg [31:0] PrevVectAddr;        // Decoded Priority Address
reg [31:0] VectAddrOutReg;      // Decoded Priority Address
reg [32:0] DecodedAddr;         // Selection for Decoding Address
reg [32:0] NxtDecodedAddr;      // Registered DecodedAddr
reg [15:0] SelectdLevel;        // Current Priority Level Selected
reg [15:0] MaskReg;             // Mask Value 15 levels to mask equal,
                                // lower priority interrupts
reg [15:0] MaskRegArray0;       // Register to mask equal and lower 
                                // priority interrupts
reg        VectAddrWrTrig;      // Write Trigger to indicate write on 
                                // VICADDRESS register of uut
reg        VectAddrRdTrig;      // Read Trigger to indicate write on
                                // VICADDRESS register of uut  
reg [15:0] MaskRegArray1;       // Stack Array 1
reg [15:0] MaskRegArray2;       // Stack Array 2
reg [15:0] MaskRegArray3;       // Stack Array 3
reg [15:0] MaskRegArray4;       // Stack Array 4
reg [15:0] MaskRegArray5;       // Stack Array 5
reg [15:0] MaskRegArray6;       // Stack Array 6
reg [15:0] MaskRegArray7;       // Stack Array 7
reg [15:0] MaskRegArray8;       // Stack Array 8
reg [15:0] MaskRegArray9;       // Stack Array 9
reg [15:0] MaskRegArray10;      // Stack Array 10
reg [15:0] MaskRegArray11;      // Stack Array 11
reg [15:0] MaskRegArray12;      // Stack Array 12
reg [15:0] MaskRegArray13;      // Stack Array 13
reg [15:0] MaskRegArray14;      // Stack Array 14
reg [15:0] MaskRegArray15;      // Stack Array 15
reg [32:0] nTrIrqReg0;          // Updated Priority Table Level 0 
reg [32:0] nTrIrqReg1;          // Updated Priority Table Level 1
reg [32:0] nTrIrqReg2;          // Updated Priority Table Level 2
reg [32:0] nTrIrqReg3;          // Updated Priority Table Level 3
reg [32:0] nTrIrqReg4;          // Updated Priority Table Level 4
reg [32:0] nTrIrqReg5;          // Updated Priority Table Level 5
reg [32:0] nTrIrqReg6;          // Updated Priority Table Level 6
reg [32:0] nTrIrqReg7;          // Updated Priority Table Level 7
reg [32:0] nTrIrqReg8;          // Updated Priority Table Level 8
reg [32:0] nTrIrqReg9;          // Updated Priority Table Level 9
reg [32:0] nTrIrqReg10;         // Updated Priority Table Level 10
reg [32:0] nTrIrqReg11;         // Updated Priority Table Level 11
reg [32:0] nTrIrqReg12;         // Updated Priority Table Level 12
reg [32:0] nTrIrqReg13;         // Updated Priority Table Level 13
reg [32:0] nTrIrqReg14;         // Updated Priority Table Level 14
reg [32:0] nTrIrqReg15;         // Updated Priority Table Level 15

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// This function decodes the Hardware priority and returns a value.
// Then the resloved priority interrupts source address can be decoded
// from the returned value.
// -----------------------------------------------------------------------------
function [32:0] PriAddrDecode;
input  [32:0] Dcode; // priority Level for each interrupt source
begin
  if(|Dcode[3:0] == 1'b1)
    begin
      case (Dcode[3:0])
        4'b0001 : PriAddrDecode = `SRC0;
        4'b0010 : PriAddrDecode = `SRC1;
        4'b0100 : PriAddrDecode = `SRC2;
        4'b1000 : PriAddrDecode = `SRC3;
        4'b0011 : PriAddrDecode = `SRC0;
        4'b0101 : PriAddrDecode = `SRC0;
        4'b0111 : PriAddrDecode = `SRC0;
        4'b1001 : PriAddrDecode = `SRC0;
        4'b1011 : PriAddrDecode = `SRC0;
        4'b1101 : PriAddrDecode = `SRC0;
        4'b1110 : PriAddrDecode = `SRC0;
        4'b1111 : PriAddrDecode = `SRC0;
        4'b0110 : PriAddrDecode = `SRC1;
        4'b1010 : PriAddrDecode = `SRC1;
        4'b1100 : PriAddrDecode = `SRC2;
        default : PriAddrDecode = `NOSRC;
      endcase
    end
  else if(|Dcode[7:4] == 1'b1)
    begin
      case (Dcode[7:4])
        4'b0001 : PriAddrDecode = `SRC4;
        4'b0010 : PriAddrDecode = `SRC5;
        4'b0100 : PriAddrDecode = `SRC6;
        4'b1000 : PriAddrDecode = `SRC7;
        4'b0011 : PriAddrDecode = `SRC4;
        4'b0101 : PriAddrDecode = `SRC4;
        4'b0111 : PriAddrDecode = `SRC4;
        4'b1001 : PriAddrDecode = `SRC4;
        4'b1011 : PriAddrDecode = `SRC4;
        4'b1101 : PriAddrDecode = `SRC4;
        4'b1110 : PriAddrDecode = `SRC4;
        4'b1111 : PriAddrDecode = `SRC4;
        4'b0110 : PriAddrDecode = `SRC5;
        4'b1010 : PriAddrDecode = `SRC5;
        4'b1100 : PriAddrDecode = `SRC6;
        default : PriAddrDecode = `NOSRC;
      endcase
    end
  else if(|Dcode[11:8] == 1'b1)
    begin
      case (Dcode[11:8])
        4'b0001 : PriAddrDecode = `SRC8;
        4'b0010 : PriAddrDecode = `SRC9;
        4'b0100 : PriAddrDecode = `SRC10;
        4'b1000 : PriAddrDecode = `SRC11;
        4'b0011 : PriAddrDecode = `SRC8;
        4'b0101 : PriAddrDecode = `SRC8;
        4'b0111 : PriAddrDecode = `SRC8;
        4'b1001 : PriAddrDecode = `SRC8;
        4'b1011 : PriAddrDecode = `SRC8;
        4'b1101 : PriAddrDecode = `SRC8;
        4'b1110 : PriAddrDecode = `SRC8;
        4'b1111 : PriAddrDecode = `SRC8;
        4'b0110 : PriAddrDecode = `SRC9;
        4'b1010 : PriAddrDecode = `SRC9;
        4'b1100 : PriAddrDecode = `SRC10;
        default : PriAddrDecode = `NOSRC;
      endcase
    end
  else if(|Dcode[15:12] == 1'b1)
    begin
      case (Dcode[15:12])
        4'b0001 : PriAddrDecode = `SRC12;
        4'b0010 : PriAddrDecode = `SRC13;
        4'b0100 : PriAddrDecode = `SRC14;
        4'b1000 : PriAddrDecode = `SRC15;
        4'b0011 : PriAddrDecode = `SRC12;
        4'b0101 : PriAddrDecode = `SRC12;
        4'b0111 : PriAddrDecode = `SRC12;
        4'b1001 : PriAddrDecode = `SRC12;
        4'b1011 : PriAddrDecode = `SRC12;
        4'b1101 : PriAddrDecode = `SRC12;
        4'b1110 : PriAddrDecode = `SRC12;
        4'b1111 : PriAddrDecode = `SRC12;
        4'b0110 : PriAddrDecode = `SRC13;
        4'b1010 : PriAddrDecode = `SRC13;
        4'b1100 : PriAddrDecode = `SRC14;
        default : PriAddrDecode = `NOSRC;
      endcase
    end
  else if(|Dcode[19:16] == 1'b1)
    begin
      case (Dcode[19:16])
        4'b0001 : PriAddrDecode = `SRC16;
        4'b0010 : PriAddrDecode = `SRC17;
        4'b0100 : PriAddrDecode = `SRC18;
        4'b1000 : PriAddrDecode = `SRC19;
        4'b0011 : PriAddrDecode = `SRC16;
        4'b0101 : PriAddrDecode = `SRC16;
        4'b0111 : PriAddrDecode = `SRC16;
        4'b1001 : PriAddrDecode = `SRC16;
        4'b1011 : PriAddrDecode = `SRC16;
        4'b1101 : PriAddrDecode = `SRC16;
        4'b1110 : PriAddrDecode = `SRC16;
        4'b1111 : PriAddrDecode = `SRC16;
        4'b0110 : PriAddrDecode = `SRC17;
        4'b1010 : PriAddrDecode = `SRC17;
        4'b1100 : PriAddrDecode = `SRC18;
        default : PriAddrDecode = `NOSRC;
      endcase
    end
  else if(|Dcode[23:20] == 1'b1)
    begin
      case (Dcode[23:20])
        4'b0001 : PriAddrDecode = `SRC20;
        4'b0010 : PriAddrDecode = `SRC21;
        4'b0100 : PriAddrDecode = `SRC22;
        4'b1000 : PriAddrDecode = `SRC23;
        4'b0011 : PriAddrDecode = `SRC20;
        4'b0101 : PriAddrDecode = `SRC20;
        4'b0111 : PriAddrDecode = `SRC20;
        4'b1001 : PriAddrDecode = `SRC20;
        4'b1011 : PriAddrDecode = `SRC20;
        4'b1101 : PriAddrDecode = `SRC20;
        4'b1110 : PriAddrDecode = `SRC20;
        4'b1111 : PriAddrDecode = `SRC20;
        4'b0110 : PriAddrDecode = `SRC21;
        4'b1010 : PriAddrDecode = `SRC21;
        4'b1100 : PriAddrDecode = `SRC22;
        default : PriAddrDecode = `NOSRC;
      endcase
    end
  else if(|Dcode[27:24] == 1'b1)
    begin
      case (Dcode[27:24])
        4'b0001 : PriAddrDecode = `SRC24;
        4'b0010 : PriAddrDecode = `SRC25;
        4'b0100 : PriAddrDecode = `SRC26;
        4'b1000 : PriAddrDecode = `SRC27;
        4'b0011 : PriAddrDecode = `SRC24;
        4'b0101 : PriAddrDecode = `SRC24;
        4'b0111 : PriAddrDecode = `SRC24;
        4'b1001 : PriAddrDecode = `SRC24;
        4'b1011 : PriAddrDecode = `SRC24;
        4'b1101 : PriAddrDecode = `SRC24;
        4'b1110 : PriAddrDecode = `SRC24;
        4'b1111 : PriAddrDecode = `SRC24;
        4'b0110 : PriAddrDecode = `SRC25;
        4'b1010 : PriAddrDecode = `SRC25;
        4'b1100 : PriAddrDecode = `SRC26;
        default : PriAddrDecode = `NOSRC;
      endcase
    end
  else if(|Dcode[31:28] == 1'b1)
    begin
      case (Dcode[31:28])
        4'b0001 : PriAddrDecode = `SRC28;
        4'b0010 : PriAddrDecode = `SRC29;
        4'b0100 : PriAddrDecode = `SRC30;
        4'b1000 : PriAddrDecode = `SRC31;
        4'b0011 : PriAddrDecode = `SRC28;
        4'b0101 : PriAddrDecode = `SRC28;
        4'b0111 : PriAddrDecode = `SRC28;
        4'b1001 : PriAddrDecode = `SRC28;
        4'b1011 : PriAddrDecode = `SRC28;
        4'b1101 : PriAddrDecode = `SRC28;
        4'b1110 : PriAddrDecode = `SRC28;
        4'b1111 : PriAddrDecode = `SRC28;
        4'b0110 : PriAddrDecode = `SRC29;
        4'b1010 : PriAddrDecode = `SRC29;
        4'b1100 : PriAddrDecode = `SRC30;
        default : PriAddrDecode = `NOSRC;
      endcase
    end
  else if(Dcode[32] == 1'b1)
    PriAddrDecode = `SRC32;
end
endfunction

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Generation of nVICIrq siganl. AckTrig signal is triggered when the interrupt
// is acknowledge by the processor by either a read on vicaddress register or
// by vicirqack signal. TrnIrq is the ored version of all interrupt sources. 
// -----------------------------------------------------------------------------
assign nTrIrq = (AckTrig == 1'b0) ? TrnIrq : EnTrIrq;

// -----------------------------------------------------------------------------
// Resultant table which indicates the active interrupts. TrvectIrq is the 
// double synchronised version of the vicintsource. Resultant table is used to
// resolve the software priority from 0 to 15.
// -----------------------------------------------------------------------------
assign ResTable0   = PPTable0 & TrVectIrq;
assign ResTable1   = PPTable1 & TrVectIrq;
assign ResTable2   = PPTable2 & TrVectIrq;
assign ResTable3   = PPTable3 & TrVectIrq;
assign ResTable4   = PPTable4 & TrVectIrq;
assign ResTable5   = PPTable5 & TrVectIrq;
assign ResTable6   = PPTable6 & TrVectIrq;
assign ResTable7   = PPTable7 & TrVectIrq;
assign ResTable8   = PPTable8 & TrVectIrq;
assign ResTable9   = PPTable9 & TrVectIrq;
assign ResTable10  = PPTable10 & TrVectIrq;
assign ResTable11  = PPTable11 & TrVectIrq;
assign ResTable12  = PPTable12 & TrVectIrq;
assign ResTable13  = PPTable13 & TrVectIrq;
assign ResTable14  = PPTable14 & TrVectIrq;
assign ResTable15  = PPTable15 & TrVectIrq;

// -----------------------------------------------------------------------------
// This EnIrqReg tables from 0 to 15 is used to generate the EnTrIrqs signal.
// nTrIrqReg is the local version of PPTable 0 to 15.If EnTrIrqs is one 
// indicates an active interrupt even after the equal and lower interrupts
// masked.
// -----------------------------------------------------------------------------
assign EnIrqReg0   = nTrIrqReg0 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg1   = nTrIrqReg1 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg2   = nTrIrqReg2 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg3   = nTrIrqReg3 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg4   = nTrIrqReg4 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg5   = nTrIrqReg5 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg6   = nTrIrqReg6 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg7   = nTrIrqReg7 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg8   = nTrIrqReg8 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg9   = nTrIrqReg9 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg10  = nTrIrqReg10 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg11  = nTrIrqReg11 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg12  = nTrIrqReg12 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg13  = nTrIrqReg13 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg14  = nTrIrqReg14 & {DaisyIrqOut,IrqStatus};
assign EnIrqReg15  = nTrIrqReg15 & {DaisyIrqOut,IrqStatus};

// -----------------------------------------------------------------------------
// Mux to generate the EnTrIrq signal based on nVicTrSyncEn signal.
// If nVicTrSyncEn is zero the de assertion of EnTrIrq is delayed by 2 clocks 
// for synchronization. This is because the address valid signal is generated
// after 2 clocks of synchronization
// -----------------------------------------------------------------------------
assign EnTrIrq  = (nVicTrSyncEn == 1'b1) ?
                    EnTrIrqs : (EnTrIrqa | EnTrIrqa1 | EnTrIrqs);

// -----------------------------------------------------------------------------
// Determines the active interrupts for EnTrIrq signal generation
// -----------------------------------------------------------------------------
assign EnTrIrqs = (|EnIrqReg15) | (|EnIrqReg14) | (|EnIrqReg13) |
                  (|EnIrqReg12) | (|EnIrqReg11) | (|EnIrqReg10) |
                  (|EnIrqReg9)  | (|EnIrqReg8)  | (|EnIrqReg7)  |
                  (|EnIrqReg6)  | (|EnIrqReg5)  | (|EnIrqReg4)  |
                  (|EnIrqReg3)  | (|EnIrqReg2)  | (|EnIrqReg1)  |
                  (|EnIrqReg0);

// -----------------------------------------------------------------------------
// PriCheck signal is used for resolving the software priority. A high in any of
// 15 bits of PriCheck indicates that an active interrupt present at that level.
// Example: PriCheck[0] -> For Priority Level 0
// -----------------------------------------------------------------------------
assign PriCheck[0] = (|(PPTable0 & TrVectIrq)) & MaskRegArray0[0];
assign PriCheck[1] = (|(PPTable1 & TrVectIrq)) & MaskRegArray0[1];
assign PriCheck[2] = (|(PPTable2 & TrVectIrq)) & MaskRegArray0[2];
assign PriCheck[3] = (|(PPTable3 & TrVectIrq)) & MaskRegArray0[3];
assign PriCheck[4] = (|(PPTable4 & TrVectIrq)) & MaskRegArray0[4];
assign PriCheck[5] = (|(PPTable5 & TrVectIrq)) & MaskRegArray0[5];
assign PriCheck[6] = (|(PPTable6 & TrVectIrq)) & MaskRegArray0[6];
assign PriCheck[7] = (|(PPTable7 & TrVectIrq)) & MaskRegArray0[7];
assign PriCheck[8] = (|(PPTable8 & TrVectIrq)) & MaskRegArray0[8];
assign PriCheck[9] = (|(PPTable9 & TrVectIrq)) & MaskRegArray0[9];
assign PriCheck[10] = (|(PPTable10 & TrVectIrq)) & MaskRegArray0[10];
assign PriCheck[11] = (|(PPTable11 & TrVectIrq)) & MaskRegArray0[11];
assign PriCheck[12] = (|(PPTable12 & TrVectIrq)) & MaskRegArray0[12];
assign PriCheck[13] = (|(PPTable13 & TrVectIrq)) & MaskRegArray0[13];
assign PriCheck[14] = (|(PPTable14 & TrVectIrq)) & MaskRegArray0[14];
assign PriCheck[15] = (|(PPTable15 & TrVectIrq)) & MaskRegArray0[15];

// -----------------------------------------------------------------------------
// Registering AckTrig signal
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_AckTrigGenReg
  if(HRESETn == 1'b0)
    AckTrigReg <= 1'b0;
  else
    AckTrigReg <= AckTrig; 
end // p_AckTrigGenReg

// -----------------------------------------------------------------------------
// Registering Read and Write signal 
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegRdWr
  if(HRESETn == 1'b0)
    begin
      VectAddrRdTrig <= 1'b0;
      VectAddrWrTrig <= 1'b0;
    end
  else
    begin
      VectAddrRdTrig <= VectAddrRdTrigIn; 
      VectAddrWrTrig <= VectAddrWrTrigIn; 
    end
end // p_RegRdWr

// -----------------------------------------------------------------------------
// Generation of AckTrig signal. Counter is incremented if a read on vicaddress 
// register or upon acknowledge (vic port) from cpu.Counter is decremented when
// a write on vicaddress register. If counter is not zero indicates that a 
// interrupts is acknowledge and lower and equal priority interrupts are masked
// -----------------------------------------------------------------------------
always @(negedge HRESETn or count)
begin : p_AckTrigGen
  if(HRESETn == 1'b0)
    AckTrig <= 1'b0;
  else
    if(count !== 0)
      AckTrig <= 1'b1; 
    else
      AckTrig <= 1'b0;
end // p_AckTrigGen

// -----------------------------------------------------------------------------
// Counter incrementing and decrementing
// -----------------------------------------------------------------------------
always @(negedge HRESETn or VectAddrRdTrig or VectAddrWrTrig or VicTrIrqAck)
begin : p_CountGen
  if(HRESETn == 1'b0)
    count <= 0;
  else
    if(VectAddrRdTrig == 1'b1 || VicTrIrqAck == 1'b1)
      count <= count + 1;
    else if(VectAddrWrTrig == 1'b1)
      begin
        if(count !== 0)
          count <= count - 1;
      end
end // p_CountGen    

// -----------------------------------------------------------------------------
// Resolving the software priority based on pricheck signal.
// Priority level 0 has the highest priority. 
// -----------------------------------------------------------------------------
always @(PriCheck or negedge HRESETn or ResTable0 or ResTable1 or
         ResTable2 or ResTable3 or ResTable4 or ResTable5 or 
         ResTable6 or ResTable7 or ResTable8 or ResTable9 or
         ResTable10 or ResTable11 or ResTable12 or ResTable13 or
         ResTable14 or ResTable15)
begin : p_PriDecode
  if(HRESETn == 1'b0)
    begin 
      DecodedAddr  <= `NOSRC;
      SelectdLevel <= 16'h0000;
    end
  else
  begin 
    if(PriCheck[0] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable0);
        SelectdLevel <= {{15{1'b0}},1'b1};
      end
    else if(PriCheck[1] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable1);
        SelectdLevel <= {{14{1'b0}},1'b1,1'b0};
      end
    else if(PriCheck[2] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable2);
        SelectdLevel <= {{13{1'b0}},1'b1,{2{1'b0}}};
      end
    else if(PriCheck[3] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable3);
        SelectdLevel <= {{12{1'b0}},1'b1,{3{1'b0}}};
      end
    else if(PriCheck[4] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable4);
        SelectdLevel <= {{11{1'b0}},1'b1,{4{1'b0}}};
      end
    else if(PriCheck[5] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable5);
        SelectdLevel <= {{10{1'b0}},1'b1,{5{1'b0}}};
      end
    else if(PriCheck[6] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable6);
        SelectdLevel <= {{9{1'b0}},1'b1,{6{1'b0}}};
      end
    else if(PriCheck[7] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable7);
        SelectdLevel <= {{8{1'b0}},1'b1,{7{1'b0}}};
      end
    else if(PriCheck[8] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable8);
        SelectdLevel <= {{7{1'b0}},1'b1,{8{1'b0}}};
      end
    else if(PriCheck[9] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable9);
        SelectdLevel <= {{6{1'b0}},1'b1,{9{1'b0}}};
      end
    else if(PriCheck[10] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable10);
        SelectdLevel <= {{5{1'b0}},1'b1,{10{1'b0}}};
      end
    else if(PriCheck[11] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable11);
        SelectdLevel <= {{4{1'b0}},1'b1,{11{1'b0}}};
      end
    else if(PriCheck[12] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable12);
        SelectdLevel <= {{3{1'b0}},1'b1,{12{1'b0}}};
      end
    else if(PriCheck[13] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable13);
        SelectdLevel <= {{2{1'b0}},1'b1,{13{1'b0}}};
      end
    else if(PriCheck[14] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable14);
        SelectdLevel <= {1'b0,1'b1,{14{1'b0}}};
      end
    else if(PriCheck[15] == 1'b1)
      begin
        DecodedAddr  <= PriAddrDecode(ResTable15);
        SelectdLevel <= {1'b1,{15{1'b0}}};
      end
  end
end // p_PriDecode    

// -----------------------------------------------------------------------------
// Address decoding mux
// -----------------------------------------------------------------------------
always @(DecodedAddr or VicTrVectAddr0 or VicTrVectAddr1 or 
         VicTrVectAddr2 or VicTrVectAddr3 or VicTrVectAddr4 or 
         VicTrVectAddr5 or VicTrVectAddr6 or VicTrVectAddr7 or
         VicTrVectAddr8 or VicTrVectAddr9 or VicTrVectAddr10 or
         VicTrVectAddr11 or VicTrVectAddr12 or VicTrVectAddr13 or
         VicTrVectAddr14 or VicTrVectAddr15 or VicTrVectAddr16 or
         VicTrVectAddr17 or VicTrVectAddr18 or VicTrVectAddr19 or
         VicTrVectAddr20 or VicTrVectAddr21 or VicTrVectAddr22 or
         VicTrVectAddr23 or VicTrVectAddr24 or VicTrVectAddr25 or
         VicTrVectAddr26 or VicTrVectAddr27 or VicTrVectAddr28 or
         VicTrVectAddr29 or VicTrVectAddr30 or VicTrVectAddr31)
 begin : p_AddrSelect
  if(HRESETn == 1'b0)
    VicTrVectAddrInt = `NOSRC;
  else
    begin
      case (DecodedAddr)
        `SRC0  : VicTrVectAddrInt = VicTrVectAddr0;
        `SRC1  : VicTrVectAddrInt = VicTrVectAddr1;
        `SRC2  : VicTrVectAddrInt = VicTrVectAddr2;
        `SRC3  : VicTrVectAddrInt = VicTrVectAddr3;
        `SRC4  : VicTrVectAddrInt = VicTrVectAddr4;
        `SRC5  : VicTrVectAddrInt = VicTrVectAddr5;
        `SRC6  : VicTrVectAddrInt = VicTrVectAddr6;
        `SRC7  : VicTrVectAddrInt = VicTrVectAddr7;
        `SRC8  : VicTrVectAddrInt = VicTrVectAddr8;
        `SRC9  : VicTrVectAddrInt = VicTrVectAddr9;
        `SRC10 : VicTrVectAddrInt = VicTrVectAddr10;
        `SRC11 : VicTrVectAddrInt = VicTrVectAddr11;
        `SRC12 : VicTrVectAddrInt = VicTrVectAddr12;
        `SRC13 : VicTrVectAddrInt = VicTrVectAddr13;
        `SRC14 : VicTrVectAddrInt = VicTrVectAddr14;
        `SRC15 : VicTrVectAddrInt = VicTrVectAddr15;
        `SRC16 : VicTrVectAddrInt = VicTrVectAddr16;
        `SRC17 : VicTrVectAddrInt = VicTrVectAddr17;
        `SRC18 : VicTrVectAddrInt = VicTrVectAddr18;
        `SRC19 : VicTrVectAddrInt = VicTrVectAddr19;
        `SRC20 : VicTrVectAddrInt = VicTrVectAddr20;
        `SRC21 : VicTrVectAddrInt = VicTrVectAddr21;
        `SRC22 : VicTrVectAddrInt = VicTrVectAddr22;
        `SRC23 : VicTrVectAddrInt = VicTrVectAddr23;
        `SRC24 : VicTrVectAddrInt = VicTrVectAddr24;
        `SRC25 : VicTrVectAddrInt = VicTrVectAddr25;
        `SRC26 : VicTrVectAddrInt = VicTrVectAddr26;
        `SRC27 : VicTrVectAddrInt = VicTrVectAddr27;
        `SRC28 : VicTrVectAddrInt = VicTrVectAddr28;
        `SRC29 : VicTrVectAddrInt = VicTrVectAddr29;
        `SRC30 : VicTrVectAddrInt = VicTrVectAddr30;
        `SRC31 : VicTrVectAddrInt = VicTrVectAddr31;
    //    `NOSRC : VicTrVectAddrInt = VicTrVectAddr;
      endcase 
    end
end // p_AddrSelect

// -----------------------------------------------------------------------------
// Store the previous address 
// -----------------------------------------------------------------------------
always @(VicTrVectAddr or GenAckReg or VectAddrOutReg)
begin : p_PrevAddrReg
  if (GenAckReg == 1'b0)
    PrevVectAddr = VicTrVectAddr;
  else
    PrevVectAddr = VectAddrOutReg;
end // p_PrevAddrReg

// -----------------------------------------------------------------------------
// Muxing the Vector address
// -----------------------------------------------------------------------------
always @(PriCheckReg or NxtVectAddrInt or VectAddrOutReg or 
         VicTrVectAddrIn or DaisySel)
begin : p_VicAddrGen
  if(PriCheckReg == 1'b0)
    VicTrVectAddr = VectAddrOutReg;
  else if (DaisySel == 1'b1)
    VicTrVectAddr = VicTrVectAddrIn;
  else
    VicTrVectAddr = NxtVectAddrInt;
end // p_VicAddrGen

// -----------------------------------------------------------------------------
// Registering of DecodedAddr signal and Previous Vector Address
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ClockDecodeAddr
  if(HRESETn == 1'b0)
    begin
    NxtDecodedAddr <= `NOSRC;
    VectAddrOutReg <= `NOSRC;
    NxtVectAddrInt <= `NOSRC;
    end
  else
    begin
    NxtDecodedAddr <= DecodedAddr;
    VectAddrOutReg <= PrevVectAddr;
    NxtVectAddrInt <= VicTrVectAddrInt;
    end
end // p_ClockDecodeAddr

// -----------------------------------------------------------------------------
// Registering of VicTrIrqAck signals used for synchronization purpose 
// when nVicTrSyncEn is zero.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SampleAck
  if(HRESETn == 1'b0)
    begin
      VicTrIrqAckc <= 1'b0;
      VicTrIrqAck1 <= 1'b0;
      VicTrIrqAck2 <= 1'b0;
      VicTrIrqAck3 <= 1'b0;
      GenAckReg    <= 1'b0;
      PriCheckReg  <= 1'b0;
      AckHap       <= 1'b0;
      EnTrIrqa1    <= 1'b0;
      EnTrIrqa     <= 1'b0;
      DaisySel     <= 1'b0;
    end
  else
    begin
      VicTrIrqAckc <= VicTrIrqAck;
      VicTrIrqAck1 <= VicTrIrqAck;
      VicTrIrqAck2 <= VicTrIrqAck1;
      VicTrIrqAck3 <= VicTrIrqAck2;
      EnTrIrqa1    <= EnTrIrqs;
      EnTrIrqa     <= EnTrIrqa1;
      GenAckReg    <= GenAck;
      PriCheckReg  <= (|PriCheck);
      if(VicTrIrqAck1 == 1'b1 && VicTrIrqAck == 1'b0)
        AckHap <= 1'b1;
      else
        AckHap <= 1'b0;
      if(DecodedAddr == `SRC32)
        DaisySel <= 1'b1;
      else
        DaisySel <= 1'b0;
    end
end // p_SampleAck 

// -----------------------------------------------------------------------------
// Trigger for generating the GenAck. GenAck signal is used for generating
// the address valid signal
// -----------------------------------------------------------------------------
assign IrqAckTrig = (PriCheckReg | GenAckReg | VicTrIrqAck3);

// -----------------------------------------------------------------------------
// GenAck signal generation
// -----------------------------------------------------------------------------
always @(IrqAckTrig or VicTrIrqAck or VicTrIrqAck2 or nVicTrSyncEn)
begin : p_AckGen
  if(IrqAckTrig == 1'b1)
    begin
      if(nVicTrSyncEn == 1'b0)
        GenAck = VicTrIrqAck2;
      else
        GenAck = VicTrIrqAck;
    end 
  else 
    GenAck = 1'b0;
end // p_AckGen 

// -----------------------------------------------------------------------------
// Vic Vector Address valid signal
// -----------------------------------------------------------------------------
assign VicTrVectAddrv = GenAckReg; 

// -----------------------------------------------------------------------------
// Internal copy Vic Vector Address valid signal
// -----------------------------------------------------------------------------
assign VectAddrVld = (GenAckReg | PriCheckReg) & VicTrIrqAckc;

// -----------------------------------------------------------------------------
// Determining the Mask Level based on the selected priority level
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_MaskDecode
  if(HRESETn == 1'b0)
    MaskReg <= 16'hFFFF;
  else
    begin
      case (SelectdLevel)
        16'h0001 : MaskReg = `MASK0;            
        16'h0002 : MaskReg = `MASK1;            
        16'h0004 : MaskReg = `MASK2;            
        16'h0008 : MaskReg = `MASK3;            
        16'h0010 : MaskReg = `MASK4;            
        16'h0020 : MaskReg = `MASK5;            
        16'h0040 : MaskReg = `MASK6;            
        16'h0080 : MaskReg = `MASK7;            
        16'h0100 : MaskReg = `MASK8;            
        16'h0200 : MaskReg = `MASK9;            
        16'h0400 : MaskReg = `MASK10;            
        16'h0800 : MaskReg = `MASK11;            
        16'h1000 : MaskReg = `MASK12;            
        16'h2000 : MaskReg = `MASK13;            
        16'h4000 : MaskReg = `MASK14;            
        16'h8000 : MaskReg = `MASK15;            
         default : MaskReg = `NOMASK;
      endcase
    end
end // p_MaskDecode

// -----------------------------------------------------------------------------
// Mask used for masking the equal and lower priority interrupts
// -----------------------------------------------------------------------------
assign MaskPrityReg = MaskRegArray0;

// -----------------------------------------------------------------------------
// Internal VicTrIrqOut signal generation
// -----------------------------------------------------------------------------
assign IrqOut = ((AsyncRdEn & IrqMask) | (GenAck & ~(GenAckReg)));

// -----------------------------------------------------------------------------
// Trigger to generate VicTrIrqOut Signal for software acknowledge
// -----------------------------------------------------------------------------
assign IrqMask = NxtDecodedAddr[32] & DecodedAddr[32];

// -----------------------------------------------------------------------------
// VicTrIrqOut signal generation when Daisy Chain interrupt is decoded as 
// highest priority
// -----------------------------------------------------------------------------
assign VicTrIrqOut = (NxtDecodedAddr == `SRC32) ? IrqOut : 1'b0;

// -----------------------------------------------------------------------------
// Making local copy of PPTable 0 to 15 based on counter value. 
// -----------------------------------------------------------------------------
always @(negedge HRESETn or PPTable0 or PPTable1 or PPTable2 or
         PPTable3 or PPTable4 or PPTable5 or PPTable6 or PPTable7 or
         PPTable8 or PPTable9 or PPTable10 or PPTable11 or PPTable12 or
         PPTable13 or PPTable14 or PPTable15 or count)
begin : p_IrqAsycGen
  if(HRESETn == 1'b0)
    begin
      nTrIrqReg0      <= `NOSRC;
      nTrIrqReg1      <= `NOSRC;
      nTrIrqReg2      <= `NOSRC;
      nTrIrqReg3      <= `NOSRC;
      nTrIrqReg4      <= `NOSRC;
      nTrIrqReg5      <= `NOSRC;
      nTrIrqReg6      <= `NOSRC;
      nTrIrqReg7      <= `NOSRC;
      nTrIrqReg8      <= `NOSRC;
      nTrIrqReg9      <= `NOSRC;
      nTrIrqReg10     <= `NOSRC;
      nTrIrqReg11     <= `NOSRC;
      nTrIrqReg12     <= `NOSRC;
      nTrIrqReg13     <= `NOSRC;
      nTrIrqReg14     <= `NOSRC;
      nTrIrqReg15     <= `NOSRC;
    end
  else
    begin
      if(count !== 0)
        begin
          nTrIrqReg0     <= PPTable0;
          nTrIrqReg1     <= PPTable1;
          nTrIrqReg2     <= PPTable2;
          nTrIrqReg3     <= PPTable3;
          nTrIrqReg4     <= PPTable4;
          nTrIrqReg5     <= PPTable5;
          nTrIrqReg6     <= PPTable6;
          nTrIrqReg7     <= PPTable7;
          nTrIrqReg8     <= PPTable8;
          nTrIrqReg9     <= PPTable9;
          nTrIrqReg10    <= PPTable10;
          nTrIrqReg11    <= PPTable11;
          nTrIrqReg12    <= PPTable12;
          nTrIrqReg13    <= PPTable13;
          nTrIrqReg14    <= PPTable14;
          nTrIrqReg15    <= PPTable15;
       end
    end
end // p_IrqAsycGen

// -----------------------------------------------------------------------------
// Stack used for pushing and popping the priority level selected.
// A push is done when there is a read on vicaddress register or vicirqack 
// signal is asserted by the cpu.A pop is done when there is a write on the
// vicaddress register. MaskRegArray0-15 is used as stack.
// -----------------------------------------------------------------------------
always @(negedge HRESETn or VectAddrRdTrig or VectAddrWrTrig or AckHap)
begin : p_Stack
  if(HRESETn == 1'b0)
    begin
      MaskRegArray0   <= 16'hFFFF;
      MaskRegArray1   <= 16'hFFFF;
      MaskRegArray2   <= 16'hFFFF;
      MaskRegArray3   <= 16'hFFFF;
      MaskRegArray4   <= 16'hFFFF;
      MaskRegArray5   <= 16'hFFFF;
      MaskRegArray6   <= 16'hFFFF;
      MaskRegArray7   <= 16'hFFFF;
      MaskRegArray8   <= 16'hFFFF;
      MaskRegArray9   <= 16'hFFFF;
      MaskRegArray10  <= 16'hFFFF;
      MaskRegArray11  <= 16'hFFFF;
      MaskRegArray12  <= 16'hFFFF;
      MaskRegArray13  <= 16'hFFFF;
      MaskRegArray14  <= 16'hFFFF;
      MaskRegArray15  <= 16'hFFFF;
    end
  else
    begin
      if((VicTrIrqAck2 == 1'b1) || 
         (VectAddrRdTrig == 1'b1 && nTrIrq == 1'b1))
        begin
          MaskRegArray0  <= MaskReg;
          MaskRegArray1  <= MaskRegArray0;
          MaskRegArray2  <= MaskRegArray1;
          MaskRegArray3  <= MaskRegArray2;
          MaskRegArray4  <= MaskRegArray3;
          MaskRegArray5  <= MaskRegArray4;
          MaskRegArray6  <= MaskRegArray5;
          MaskRegArray7  <= MaskRegArray6;
          MaskRegArray8  <= MaskRegArray7;
          MaskRegArray9  <= MaskRegArray8;
          MaskRegArray10 <= MaskRegArray9;
          MaskRegArray11 <= MaskRegArray10;
          MaskRegArray12 <= MaskRegArray11;
          MaskRegArray13 <= MaskRegArray12;
          MaskRegArray14 <= MaskRegArray13;
          MaskRegArray15 <= MaskRegArray14;
        end
      else
        if(VectAddrWrTrig == 1'b1)
          begin
            MaskRegArray0  <= MaskRegArray1;
            MaskRegArray1  <= MaskRegArray2;
            MaskRegArray2  <= MaskRegArray3;
            MaskRegArray3  <= MaskRegArray4;
            MaskRegArray4  <= MaskRegArray5;
            MaskRegArray5  <= MaskRegArray6;
            MaskRegArray6  <= MaskRegArray7;
            MaskRegArray7  <= MaskRegArray8;
            MaskRegArray8  <= MaskRegArray9;
            MaskRegArray9  <= MaskRegArray10;
            MaskRegArray10 <= MaskRegArray11;
            MaskRegArray11 <= MaskRegArray12;
            MaskRegArray12 <= MaskRegArray13;
            MaskRegArray13 <= MaskRegArray14;
            MaskRegArray14 <= MaskRegArray15;
            MaskRegArray15 <= 16'hFFFF;
          end
    end
  end // p_Stack

endmodule

// --=============================== End =====================================--
