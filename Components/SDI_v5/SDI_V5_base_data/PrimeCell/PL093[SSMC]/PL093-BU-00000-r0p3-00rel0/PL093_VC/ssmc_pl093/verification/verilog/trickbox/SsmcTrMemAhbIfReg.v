// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcTrMemAhbIfReg.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block interfaces the SSMC Memory model with the AHB bus.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcTrMemAhbIfReg (
// Inputs
                         HCLK,
                         HRESETn,
                         HADDR,
                         HTRANS,
                         HWRITETr,
                         HWRITEREG,
                         HSIZE,
                         HBURST,
                         HREADYINTr,
                         HWDATA,
                         HREADYINREG,
                         HWDATAREG,
                         HSELSSMCTrMEM,
                         HSELSSMCTrREG,
                         AhbRdDataDW0,
                         AhbRdDataDW1,
                         AhbRdDataDW2,
                         AhbRdDataDW3,
                         AhbRdDataDW4,
                         AhbRdDataDW5,
                         AhbRdDataDW6,
                         AhbRdDataDW7,
  
// Outputs
                         HRDATATr,
                         HREADYOUTTr,
                         HRESPTr,

                         SSMCTrMEMARRAY0Wr,
                         SSMCTrMEMARRAY1Wr,
                         SSMCTrMEMARRAY2Wr,
                         SSMCTrMEMARRAY3Wr,
                         SSMCTrMEMARRAY4Wr,
                         SSMCTrMEMARRAY5Wr,
                         SSMCTrMEMARRAY6Wr,
                         SSMCTrMEMARRAY7Wr,
       
                         LatchHADDR,
                         SSMCTrBurstWT,
 
                         SSMCTrMEMBASE0,
                         SSMCTrMEMBASE1,
                         SSMCTrMEMBASE2,
                         SSMCTrMEMBASE3,
                         SSMCTrMEMBASE4,
                         SSMCTrMEMBASE5,
                         SSMCTrMEMBASE6,
                         SSMCTrMEMBASE7,
 
                         SMTrBIDCYR0,
                         SMTrBIDCYR1,
                         SMTrBIDCYR2,
                         SMTrBIDCYR3,
                         SMTrBIDCYR4,
                         SMTrBIDCYR5,
                         SMTrBIDCYR6,
                         SMTrBIDCYR7,

                         SMTrBWSTRDR0,
                         SMTrBWSTRDR1,
                         SMTrBWSTRDR2,
                         SMTrBWSTRDR3,
                         SMTrBWSTRDR4,
                         SMTrBWSTRDR5,
                         SMTrBWSTRDR6,
                         SMTrBWSTRDR7,

                         SMTrBWSTWRR0,        
                         SMTrBWSTWRR1,        
                         SMTrBWSTWRR2,        
                         SMTrBWSTWRR3,        
                         SMTrBWSTWRR4,        
                         SMTrBWSTWRR5,        
                         SMTrBWSTWRR6,        
                         SMTrBWSTWRR7,        

                         SMTrBWSTOENR0,
                         SMTrBWSTOENR1,
                         SMTrBWSTOENR2,
                         SMTrBWSTOENR3,
                         SMTrBWSTOENR4,
                         SMTrBWSTOENR5,
                         SMTrBWSTOENR6,
                         SMTrBWSTOENR7,

                         SMTrBWSTWENR0,
                         SMTrBWSTWENR1,
                         SMTrBWSTWENR2,
                         SMTrBWSTWENR3,
                         SMTrBWSTWENR4,
                         SMTrBWSTWENR5,
                         SMTrBWSTWENR6,
                         SMTrBWSTWENR7,

                         SMTrBWSTBRDR0,
                         SMTrBWSTBRDR1,
                         SMTrBWSTBRDR2,
                         SMTrBWSTBRDR3,
                         SMTrBWSTBRDR4,
                         SMTrBWSTBRDR5,
                         SMTrBWSTBRDR6,
                         SMTrBWSTBRDR7,

                         SMTrBCR0,
                         SMTrBCR1,
                         SMTrBCR2,
                         SMTrBCR3,
                         SMTrBCR4,
                         SMTrBCR5,
                         SMTrBCR6,
                         SMTrBCR7

                        );

// Inputs
input         HCLK;         // AHB Clock
input         HRESETn;      // Bus Reset
input  [17:0] HADDR;        // AHB Address Bus
input   [1:0] HTRANS;       // Transfer type
input         HWRITETr;     // AHB Peripheral Write
input         HWRITEREG;    // Mirror REG write
input   [2:0] HSIZE;        // Transfer size
input   [2:0] HBURST;       // Burst Type
input         HREADYINTr;   // Multiplexed version of HREADY outputs
input  [31:0] HWDATA;       // AHB Write Data bus
input         HREADYINREG;  // Multiplexd version of mirror registers
input  [31:0] HWDATAREG;    // Mirrored Register Write Data bus        
input         HSELSSMCTrMEM;// AHB Peripheral (TrickMem) Select
input         HSELSSMCTrREG;// TrickMem mirror register select
input  [31:0] AhbRdDataDW0;  // Mem0 Rd data
input  [31:0] AhbRdDataDW1;  // Mem1 Rd data
input  [31:0] AhbRdDataDW2;  // Mem2 Rd data
input  [31:0] AhbRdDataDW3;  // Mem3 Rd data
input  [31:0] AhbRdDataDW4;  // Mem4 Rd data
input  [31:0] AhbRdDataDW5;  // Mem5 Rd data
input  [31:0] AhbRdDataDW6;  // Mem6 Rd data
input  [31:0] AhbRdDataDW7;  // Mem7 Rd data



// Outputs
output [31:0] HRDATATr;           // AHB Read Data bus
output        HREADYOUTTr;        // Slave HREADY output
output  [1:0] HRESPTr;            // Slave response

output        SSMCTrMEMARRAY0Wr;  // SSMCTrMEMARRAY0 Write enable
output        SSMCTrMEMARRAY1Wr;  // SSMCTrMEMARRAY1 Write enable
output        SSMCTrMEMARRAY2Wr;  // SSMCTrMEMARRAY2 Write enable
output        SSMCTrMEMARRAY3Wr;  // SSMCTrMEMARRAY3 Write enable
output        SSMCTrMEMARRAY4Wr;  // SSMCTrMEMARRAY4 Write enable
output        SSMCTrMEMARRAY5Wr;  // SSMCTrMEMARRAY5 Write enable
output        SSMCTrMEMARRAY6Wr;  // SSMCTrMEMARRAY6 Write enable
output        SSMCTrMEMARRAY7Wr;  // SSMCTrMEMARRAY7 Write enable

output [17:0] LatchHADDR;         // Latched AHB Address
output  [8:0] SSMCTrBurstWT;      //SSMCTrBurstWT Register

output [14:0] SSMCTrMEMBASE0;     // SMCTrMEMBASE0 Register
output [14:0] SSMCTrMEMBASE1;     // SMCTrMEMBASE1 Register
output [14:0] SSMCTrMEMBASE2;     // SMCTrMEMBASE2 Register
output [14:0] SSMCTrMEMBASE3;     // SMCTrMEMBASE3 Register
output [14:0] SSMCTrMEMBASE4;     // SMCTrMEMBASE4 Register
output [14:0] SSMCTrMEMBASE5;     // SMCTrMEMBASE5 Register
output [14:0] SSMCTrMEMBASE6;     // SMCTrMEMBASE6 Register
output [14:0] SSMCTrMEMBASE7;     // SMCTrMEMBASE7 Register

output  [3:0] SMTrBIDCYR0;        // SMTrBIDCY0 mirror register
output  [3:0] SMTrBIDCYR1;        // SMTrBIDCY1 mirror register
output  [3:0] SMTrBIDCYR2;        // SMTrBIDCY2 mirror register
output  [3:0] SMTrBIDCYR3;        // SMTrBIDCY3 mirror register
output  [3:0] SMTrBIDCYR4;        // SMTrBIDCY4 mirror register
output  [3:0] SMTrBIDCYR5;        // SMTrBIDCY5 mirror register
output  [3:0] SMTrBIDCYR6;        // SMTrBIDCY6 mirror register
output  [3:0] SMTrBIDCYR7;        // SMTrBIDCY7 mirror register

output  [4:0] SMTrBWSTRDR0;       // SMTrBWSTRDR0 mirror register
output  [4:0] SMTrBWSTRDR1;       // SMTrBWSTRDR1 mirror register
output  [4:0] SMTrBWSTRDR2;       // SMTrBWSTRDR2 mirror register
output  [4:0] SMTrBWSTRDR3;       // SMTrBWSTRDR3 mirror register
output  [4:0] SMTrBWSTRDR4;       // SMTrBWSTRDR4 mirror register
output  [4:0] SMTrBWSTRDR5;       // SMTrBWSTRDR5 mirror register
output  [4:0] SMTrBWSTRDR6;       // SMTrBWSTRDR6 mirror register
output  [4:0] SMTrBWSTRDR7;       // SMTrBWSTRDR7 mirror register

output  [4:0] SMTrBWSTWRR0;       // SMTrBWSTWRR0 mirror register
output  [4:0] SMTrBWSTWRR1;       // SMTrBWSTWRR1 mirror register
output  [4:0] SMTrBWSTWRR2;       // SMTrBWSTWRR2 mirror register
output  [4:0] SMTrBWSTWRR3;       // SMTrBWSTWRR3 mirror register
output  [4:0] SMTrBWSTWRR4;       // SMTrBWSTWRR4 mirror register
output  [4:0] SMTrBWSTWRR5;       // SMTrBWSTWRR5 mirror register
output  [4:0] SMTrBWSTWRR6;       // SMTrBWSTWRR6 mirror register
output  [4:0] SMTrBWSTWRR7;       // SMTrBWSTWRR7 mirror register

output  [3:0] SMTrBWSTOENR0;      // SMTrBWSTOENR0 mirror register
output  [3:0] SMTrBWSTOENR1;      // SMTrBWSTOENR1 mirror register
output  [3:0] SMTrBWSTOENR2;      // SMTrBWSTOENR2 mirror register
output  [3:0] SMTrBWSTOENR3;      // SMTrBWSTOENR3 mirror register
output  [3:0] SMTrBWSTOENR4;      // SMTrBWSTOENR4 mirror register
output  [3:0] SMTrBWSTOENR5;      // SMTrBWSTOENR5 mirror register
output  [3:0] SMTrBWSTOENR6;      // SMTrBWSTOENR6 mirror register
output  [3:0] SMTrBWSTOENR7;      // SMTrBWSTOENR7 mirror register

output  [3:0] SMTrBWSTWENR0;      // SMTrBWSTWENR0 mirror register
output  [3:0] SMTrBWSTWENR1;      // SMTrBWSTWENR1 mirror register
output  [3:0] SMTrBWSTWENR2;      // SMTrBWSTWENR2 mirror register
output  [3:0] SMTrBWSTWENR3;      // SMTrBWSTWENR3 mirror register
output  [3:0] SMTrBWSTWENR4;      // SMTrBWSTWENR4 mirror register
output  [3:0] SMTrBWSTWENR5;      // SMTrBWSTWENR5 mirror register
output  [3:0] SMTrBWSTWENR6;      // SMTrBWSTWENR6 mirror register
output  [3:0] SMTrBWSTWENR7;      // SMTrBWSTWENR7 mirror register

output  [4:0] SMTrBWSTBRDR0;      // SMTrBWSTBRDR0 mirror register 
output  [4:0] SMTrBWSTBRDR1;      // SMTrBWSTBRDR1 mirror register 
output  [4:0] SMTrBWSTBRDR2;      // SMTrBWSTBRDR2 mirror register 
output  [4:0] SMTrBWSTBRDR3;      // SMTrBWSTBRDR3 mirror register 
output  [4:0] SMTrBWSTBRDR4;      // SMTrBWSTBRDR4 mirror register 
output  [4:0] SMTrBWSTBRDR5;      // SMTrBWSTBRDR5 mirror register 
output  [4:0] SMTrBWSTBRDR6;      // SMTrBWSTBRDR6 mirror register 
output  [4:0] SMTrBWSTBRDR7;      // SMTrBWSTBRDR7 mirror register 

output [21:0] SMTrBCR0;           // SMTrBCR0 mirror register
output [21:0] SMTrBCR1;           // SMTrBCR1 mirror register
output [21:0] SMTrBCR2;           // SMTrBCR2 mirror register
output [21:0] SMTrBCR3;           // SMTrBCR3 mirror register
output [21:0] SMTrBCR4;           // SMTrBCR4 mirror register
output [21:0] SMTrBCR5;           // SMTrBCR5 mirror register
output [21:0] SMTrBCR6;           // SMTrBCR6 mirror register
output [21:0] SMTrBCR7;           // SMTrBCR7 mirror register


// Inputs
  wire         HCLK;              // AHB Clock
  wire         HRESETn;           // Bus Reset
  wire  [17:0] HADDR;             // AHB Address Bus
  wire   [1:0] HTRANS;            // Transfer type
  wire         HWRITETr;          // AHB Peripheral Write
  wire         HWRITEREG;         // Mirror REG write
  wire   [2:0] HSIZE;             // Transfer size
  wire   [2:0] HBURST;            // Burst Type
  wire         HREADYINTr;        // Multiplexed version of HREADY outputs
  wire  [31:0] HWDATA;            // AHB Write Data bus
  wire         HREADYINREG;       // Multiplexd version of mirror registers
  wire  [31:0] HWDATAREG;         // Mirrored Register Write Data bus
  wire         HSELSSMCTrMEM;     // AHB Peripheral (TrickMem) Select
  wire         HSELSSMCTrREG;     // TrickMem mirror register select

  wire  [31:0] AhbRdDataDW0;       // Mem0 Rd data
  wire  [31:0] AhbRdDataDW1;       // Mem1 Rd data
  wire  [31:0] AhbRdDataDW2;       // Mem2 Rd data
  wire  [31:0] AhbRdDataDW3;       // Mem3 Rd data
  wire  [31:0] AhbRdDataDW4;       // Mem4 Rd data
  wire  [31:0] AhbRdDataDW5;       // Mem5 Rd data
  wire  [31:0] AhbRdDataDW6;       // Mem6 Rd data
  wire  [31:0] AhbRdDataDW7;       // Mem7 Rd data

// Outputs
  wire [31:0] HRDATATr;           // AHB Read Data bus
  reg         HREADYOUTTr;        // Slave HREADY   wire
  wire  [1:0] HRESPTr;            // Slave response

  wire        SSMCTrMEMARRAY0Wr;  // SSMCTrMEMARRAY0 Write enable
  wire        SSMCTrMEMARRAY1Wr;  // SSMCTrMEMARRAY1 Write enable
  wire        SSMCTrMEMARRAY2Wr;  // SSMCTrMEMARRAY2 Write enable
  wire        SSMCTrMEMARRAY3Wr;  // SSMCTrMEMARRAY3 Write enable
  wire        SSMCTrMEMARRAY4Wr;  // SSMCTrMEMARRAY4 Write enable
  wire        SSMCTrMEMARRAY5Wr;  // SSMCTrMEMARRAY5 Write enable
  wire        SSMCTrMEMARRAY6Wr;  // SSMCTrMEMARRAY6 Write enable
  wire        SSMCTrMEMARRAY7Wr;  // SSMCTrMEMARRAY7 Write enable

  wire [17:0] LatchHADDR;         // Latched AHB Address
  wire  [8:0] SSMCTrBurstWT;      //SSMCTrBurstWT Register

  wire [14:0] SSMCTrMEMBASE0;     // SMCTrMEMBASE0 Register
  wire [14:0] SSMCTrMEMBASE1;     // SMCTrMEMBASE1 Register
  wire [14:0] SSMCTrMEMBASE2;     // SMCTrMEMBASE2 Register
  wire [14:0] SSMCTrMEMBASE3;     // SMCTrMEMBASE3 Register
  wire [14:0] SSMCTrMEMBASE4;     // SMCTrMEMBASE4 Register
  wire [14:0] SSMCTrMEMBASE5;     // SMCTrMEMBASE5 Register
  wire [14:0] SSMCTrMEMBASE6;     // SMCTrMEMBASE6 Register
  wire [14:0] SSMCTrMEMBASE7;     // SMCTrMEMBASE7 Register

  wire  [3:0] SMTrBIDCYR0;        // SMTrBIDCY0 mirror register
  wire  [3:0] SMTrBIDCYR1;        // SMTrBIDCY1 mirror register
  wire  [3:0] SMTrBIDCYR2;        // SMTrBIDCY2 mirror register
  wire  [3:0] SMTrBIDCYR3;        // SMTrBIDCY3 mirror register
  wire  [3:0] SMTrBIDCYR4;        // SMTrBIDCY4 mirror register
  wire  [3:0] SMTrBIDCYR5;        // SMTrBIDCY5 mirror register
  wire  [3:0] SMTrBIDCYR6;        // SMTrBIDCY6 mirror register
  wire  [3:0] SMTrBIDCYR7;        // SMTrBIDCY7 mirror register

  wire  [4:0] SMTrBWSTRDR0;       // SMTrBWSTRDR0 mirror register
  wire  [4:0] SMTrBWSTRDR1;       // SMTrBWSTRDR1 mirror register
  wire  [4:0] SMTrBWSTRDR2;       // SMTrBWSTRDR2 mirror register
  wire  [4:0] SMTrBWSTRDR3;       // SMTrBWSTRDR3 mirror register
  wire  [4:0] SMTrBWSTRDR4;       // SMTrBWSTRDR4 mirror register
  wire  [4:0] SMTrBWSTRDR5;       // SMTrBWSTRDR5 mirror register
  wire  [4:0] SMTrBWSTRDR6;       // SMTrBWSTRDR6 mirror register
  wire  [4:0] SMTrBWSTRDR7;       // SMTrBWSTRDR7 mirror register

  wire  [4:0] SMTrBWSTWRR0;       // SMTrBWSTWRR0 mirror register
  wire  [4:0] SMTrBWSTWRR1;       // SMTrBWSTWRR1 mirror register
  wire  [4:0] SMTrBWSTWRR2;       // SMTrBWSTWRR2 mirror register
  wire  [4:0] SMTrBWSTWRR3;       // SMTrBWSTWRR3 mirror register
  wire  [4:0] SMTrBWSTWRR4;       // SMTrBWSTWRR4 mirror register
  wire  [4:0] SMTrBWSTWRR5;       // SMTrBWSTWRR5 mirror register
  wire  [4:0] SMTrBWSTWRR6;       // SMTrBWSTWRR6 mirror register
  wire  [4:0] SMTrBWSTWRR7;       // SMTrBWSTWRR7 mirror register

  wire  [3:0] SMTrBWSTOENR0;      // SMTrBWSTOENR0 mirror register
  wire  [3:0] SMTrBWSTOENR1;      // SMTrBWSTOENR1 mirror register
  wire  [3:0] SMTrBWSTOENR2;      // SMTrBWSTOENR2 mirror register
  wire  [3:0] SMTrBWSTOENR3;      // SMTrBWSTOENR3 mirror register
  wire  [3:0] SMTrBWSTOENR4;      // SMTrBWSTOENR4 mirror register
  wire  [3:0] SMTrBWSTOENR5;      // SMTrBWSTOENR5 mirror register
  wire  [3:0] SMTrBWSTOENR6;      // SMTrBWSTOENR6 mirror register
  wire  [3:0] SMTrBWSTOENR7;      // SMTrBWSTOENR7 mirror register

  wire  [3:0] SMTrBWSTWENR0;      // SMTrBWSTWENR0 mirror register
  wire  [3:0] SMTrBWSTWENR1;      // SMTrBWSTWENR1 mirror register
  wire  [3:0] SMTrBWSTWENR2;      // SMTrBWSTWENR2 mirror register
  wire  [3:0] SMTrBWSTWENR3;      // SMTrBWSTWENR3 mirror register
  wire  [3:0] SMTrBWSTWENR4;      // SMTrBWSTWENR4 mirror register
  wire  [3:0] SMTrBWSTWENR5;      // SMTrBWSTWENR5 mirror register
  wire  [3:0] SMTrBWSTWENR6;      // SMTrBWSTWENR6 mirror register
  wire  [3:0] SMTrBWSTWENR7;      // SMTrBWSTWENR7 mirror register

  wire  [4:0] SMTrBWSTBRDR0;      // SMTrBWSTBRDR0 mirror register
  wire  [4:0] SMTrBWSTBRDR1;      // SMTrBWSTBRDR1 mirror register
  wire  [4:0] SMTrBWSTBRDR2;      // SMTrBWSTBRDR2 mirror register
  wire  [4:0] SMTrBWSTBRDR3;      // SMTrBWSTBRDR3 mirror register
  wire  [4:0] SMTrBWSTBRDR4;      // SMTrBWSTBRDR4 mirror register
  wire  [4:0] SMTrBWSTBRDR5;      // SMTrBWSTBRDR5 mirror register
  wire  [4:0] SMTrBWSTBRDR6;      // SMTrBWSTBRDR6 mirror register
  wire  [4:0] SMTrBWSTBRDR7;      // SMTrBWSTBRDR7 mirror register

  wire [21:0] SMTrBCR0;           // SMTrBCR0 mirror register
  wire [21:0] SMTrBCR1;           // SMTrBCR1 mirror register
  wire [21:0] SMTrBCR2;           // SMTrBCR2 mirror register
  wire [21:0] SMTrBCR3;           // SMTrBCR3 mirror register
  wire [21:0] SMTrBCR4;           // SMTrBCR4 mirror register
  wire [21:0] SMTrBCR5;           // SMTrBCR5 mirror register
  wire [21:0] SMTrBCR6;           // SMTrBCR6 mirror register
  wire [21:0] SMTrBCR7;           // SMTrBCR7 mirror register

// -----------------------------------------------------------------------------
//
//                              SmcTrMemAhbifReg
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SSMC Tricbox is an AHB slave. This block interfaces the trickbox with the AHB
// bus. All slave response signals are generated from this module.
// This module decodes AHB accesses and generates the read/write
// strobe to the appropriate registers. HCLK period calculation logic also
// contained in this module.
//
// -----------------------------------------------------------------------------
//                         SMC Trickbox Register Map
// -----------------------------------------------------------------------------
// Offset    Register    Type   Width    Describtion
// -----------------------------------------------------------------------------
// SSMC TrickMEM Base + Offset
//
//          SSMCTrMEMARRAYx  R/W   32-bit   32-bit wide and 2K deep Memory. By
// 0x00000                0                 changing the MemDeep value in
// 0x02000                1                 SmcTrConst file it is possible to
// 0x04000                2                 change the size of the memory array.
// 0x06000                3
// 0x08000                4
// 0x0A000                5
// 0x0C000                6
// 0x0E000                7
//
//           SSMCTrMEMBASEx  R/W    15-bit   Memory base address register.
// 0x10000                0
// 0x12000                1
// 0x14000                2
// 0x16000                3
// 0x18000                4
// 0x1A000                5
// 0x1C000                6
// 0x1E000                7
//
// 0x20000   SSMCTrBurstWT   R/W     9-bit  Busrt wait delay register.
//
//
// UUT Base + Offset
//
//           SMTrBIDCYRx    R/W    4-bit    memory data bus arround time.
// 0x00                0
// 0x20                1
// 0x40                2
// 0x60                3
// 0x80                4
// 0xA0                5
// 0xC0                6
// 0xE0                7
//
//
//           SMTrBWSTRDRx   R/W    4-bit   In case of SRAM and ROM, this field
// 0x04                 0                  indicates read access time. I case
// 0x24                 1                  of burst ROM this indicates initial
// 0x44                 2                  access time.
// 0x64                 3
// 0x84                 4
// 0xA4                 5
// 0xC4                 6
// 0xE4                 7
//
//
//          SMTrBWSTWRRx    R/W    5-bit   In case of SRAM and ROM, this field
// 0x08                0                   indicates Write access time. I case
// 0x28                1                   of RAM this indicates the number of
// 0x48                2                   wait states for write access,and
// 0x68                3                   external wait assertion timing for
// 0x88                4                   writes.
// 0xA8                5
// 0xC8                6
// 0xE8                7
//
//
//         SMTrBWSTOENRx    R/W    4-bit  Output enable assertion delay from
// 0x0C                0                  chip select assertion.
// 0x2C                1
// 0x4C                2
// 0x6C                3
// 0x8C                4
// 0xAC                5
// 0xCC                6
// 0xEC                7
//
//         SMTrBWSTWENRx    R/W    4-bit  Write enable assertion delay from
// 0x10                0                  chip select assertion.
// 0x30                1
// 0x50                2
// 0x70                3
// 0x90                4
// 0xB0                5
// 0xD0                6
// 0xF0                7
//
//         SMTrBWSTBRDRx    R/W    5-bit  Burst read state after the first read.
// 0x14                0
// 0x34                1
// 0x54                2
// 0x74                3
// 0x94                4
// 0xB4                5
// 0xD4                6
// 0xF4                7
//
//              SMTrBCRx    R/W    4-bit  Bank control register
// 0x1C                0
// 0x3C                1
// 0x5C                2
// 0x7C                3
// 0x9C                4
// 0xBC                5
// 0xDC                6
// 0xFC                7
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define IDLE             2'b00
// Master IDLE respone

`define BUSY             2'b01
// Master BUSY respone

`define OKAY             2'b00
// Slave OKAY respone

`define ERROR            2'b01
// Slave ERROR respone

`define WORD             3'b010
// 32-bit operation

`define INCR             3'b001
// Undefined length burst

// -----------------------------------------------------------------------------
// Trickbox registers address constants. Address decode is for
// bits 13 to 17 (4 bits)
// -----------------------------------------------------------------------------
`define HADDR_SSMCTrMEMARRAY0         5'b00000
// SSMCTrMEMARRAY at offset 0x0000 to 1FFF

`define HADDR_SSMCTrMEMARRAY1         5'b00001
// SSMCTrMEMARRAY at offset 0x0000 to 1FFF

`define HADDR_SSMCTrMEMARRAY2         5'b00010
// SSMCTrMEMARRAY at offset 0x0000 to 1FFF

`define HADDR_SSMCTrMEMARRAY3         5'b00011
// SSMCTrMEMARRAY at offset 0x0000 to 1FFF

`define HADDR_SSMCTrMEMARRAY4         5'b00100
// SSMCTrMEMARRAY at offset 0x0000 to 1FFF

`define HADDR_SSMCTrMEMARRAY5         5'b00101
// SSMCTrMEMARRAY at offset 0x0000 to 1FFF

`define HADDR_SSMCTrMEMARRAY6         5'b00110
// SSMCTrMEMARRAY at offset 0x0000 to 1FFF

`define HADDR_SSMCTrMEMARRAY7         5'b00111
// SSMCTrMEMARRAY at offset 0x0000 to 1FFF

`define HADDR_SSMCTrBurstWT           5'b10000
// SSMCTrBurstWT at offset 0x20000

`define HADDR_SSMCTrMEMBASE0          5'b01000
// SSMCTrMEMB0 at offset 0x2000

`define HADDR_SSMCTrMEMBASE1          5'b01001
// SSMCTrMEMB1 at offset 0x4000

`define HADDR_SSMCTrMEMBASE2          5'b01010
// SSMCTrMEMB2 at offset 0x6000
 
`define HADDR_SSMCTrMEMBASE3          5'b01011
// SSMCTrMEMB3 at offset 0x8000

`define HADDR_SSMCTrMEMBASE4          5'b01100
// SSMCTrMEMB4 at offset 0xA000

`define HADDR_SSMCTrMEMBASE5          5'b01101
//  SSMCTrMEMB5 at offset 0xB000

`define HADDR_SSMCTrMEMBASE6          5'b01110
// SSMCTrMEMB6 at offset 0xC000

`define HADDR_SSMCTrMEMBASE7          5'b01111
// SSMCTrMEMB7 at offset 0xD000
  
// -----------------------------------------------------------------------------
//  Mirror register constants. Address decode is for bits 10 to 15 (6 bits)
// -----------------------------------------------------------------------------
`define HADDR_SMTrBIDCYR0             8'b00000000
//  SMTrBIDCYR0 at offset 0x00

`define HADDR_SMTrBWSTRDR0            8'b00000001
// SMTrBWSTRDR0 at offset 0x04

`define HADDR_SMTrBWSTWRR0            8'b00000010
// SMTrBWSTWRR0 at offset 0x08

`define HADDR_SMTrBWSTOENR0           8'b00000011
// SMTrBWSTOENR0 at offset 0x0C

`define HADDR_SMTrBWSTWENR0           8'b00000100
// SMTrBWSTWENR0 at offset 0x10

`define HADDR_SMTrBCR0                8'b00000101
// SMTrBCR0 at offset 0x14

`define HADDR_SMTrBWSTBRDR0           8'b00000111
// SMTrBWSTBRDR0  at offset 0x1C

`define HADDR_SMTrBIDCYR1             8'b00001000
// SMTrBIDCYR1 at offset 0x20

`define HADDR_SMTrBWSTRDR1            8'b00001001
// SMTrBWSTRDR1 at offset 0x24

`define HADDR_SMTrBWSTWRR1            8'b00001010
// SMTrBWSTWRR1 at offset 0x28

`define HADDR_SMTrBWSTOENR1           8'b00001011
// SMTrBWSTOENR1 at offset 0x2C

`define HADDR_SMTrBWSTWENR1           8'b00001100
// SMTrBWSTWENR1 at offset 0x30

`define HADDR_SMTrBCR1                8'b00001101
// SMTrBCR1 at offset 0x34

`define HADDR_SMTrBWSTBRDR1           8'b00001111
// SMTrBWSTBRDR1  at offset 0x3C
        
`define HADDR_SMTrBIDCYR2             8'b00010000
// SMTrBIDCYR2 at offset 0x40

`define HADDR_SMTrBWSTRDR2            8'b00010001
// SMTrBWSTRDR2 at offset 0x44 

`define HADDR_SMTrBWSTWRR2            8'b00010010
// SMTrBWSTWRR2 at offset 0x48

`define HADDR_SMTrBWSTOENR2           8'b00010011
// SMTrBWSTOENR2 at offset 0x4C

`define HADDR_SMTrBWSTWENR2           8'b00010100
// SMTrBWSTWENR2 at offset 0x50

`define HADDR_SMTrBCR2                8'b00010101
// SMTrBCR2 at offset 0x54

`define HADDR_SMTrBWSTBRDR2           8'b00010111
// SMTrBWSTBRDR2  at offset 0x5C
        
`define HADDR_SMTrBIDCYR3             8'b00011000
// SMTrBIDCYR3 at offset 0x60

`define HADDR_SMTrBWSTRDR3            8'b00011001
// SMTrBWSTRDR3 at offset 0x64

`define HADDR_SMTrBWSTWRR3            8'b00011010
// SMTrBWSTWRR3 at offset 0x68

`define HADDR_SMTrBWSTOENR3           8'b00011011
// SMTrBWSTOENR3 at offset 0x6C

`define HADDR_SMTrBWSTWENR3           8'b00011100
// SMTrBWSTWENR3 at offset 0x70

`define HADDR_SMTrBCR3                8'b00011101
// SMTrBCR3 at offset 0x74

`define HADDR_SMTrBWSTBRDR3           8'b00011111
// SMTrBWSTBRDR3  at offset 0x7C
        
`define HADDR_SMTrBIDCYR4             8'b00100000
// SMTrBIDCYR4 at offset 0x80

`define HADDR_SMTrBWSTRDR4            8'b00100001
// SMTrBWSTRDR4 at offset 0x84

`define HADDR_SMTrBWSTWRR4            8'b00100010
// SMTrBWSTWRR4 at offset 0x88

`define HADDR_SMTrBWSTOENR4           8'b00100011
// SMTrBWSTOENR4 at offset 0x8C

`define HADDR_SMTrBWSTWENR4           8'b00100100
// SMTrBWSTWENR4 at offset 0x90

`define HADDR_SMTrBCR4                8'b00100101
// SMTrBCR4 at offset 0x94

`define HADDR_SMTrBWSTBRDR4           8'b00100111
// SMTrBWSTBRDR4  at offset 0x9C
        
`define HADDR_SMTrBIDCYR5             8'b00101000
// SMTrBIDCYR5 at offset 0xA0

`define HADDR_SMTrBWSTRDR5            8'b00101001
// SMTrBWSTRDR5 at offset 0xA4

`define HADDR_SMTrBWSTWRR5            8'b00101010
// SMTrBWSTWRR5 at offset 0xA8

`define HADDR_SMTrBWSTOENR5           8'b00101011
// SMTrBWSTOENR5 at offset 0xAC

`define HADDR_SMTrBWSTWENR5           8'b00101100
// SMTrBWSTWENR5 at offset 0xB0

`define HADDR_SMTrBCR5                8'b00101101
// SMTrBCR5 at offset 0xB4

`define HADDR_SMTrBWSTBRDR5           8'b00101111
// SMTrBWSTBRDR5  at offset 0xBC
 
`define HADDR_SMTrBIDCYR6             8'b00110000
// SMTrBIDCYR6 at offset 0xC0

`define HADDR_SMTrBWSTRDR6            8'b00110001
// SMTrBWSTRDR6 at offset 0xC4

`define HADDR_SMTrBWSTWRR6            8'b00110010
// SMTrBWSTWRR6 at offset 0xC8

`define HADDR_SMTrBWSTOENR6           8'b00110011
// SMTrBWSTOENR6 at offset 0xCC

`define HADDR_SMTrBWSTWENR6           8'b00110100
// SMTrBWSTWENR6 at offset 0xD0

`define HADDR_SMTrBCR6                8'b00110101
// SMTrBCR6 at offset 0xD4

`define HADDR_SMTrBWSTBRDR6           8'b00110111
// SMTrBWSTBRDR6  at offset 0xDC
 
`define HADDR_SMTrBIDCYR7             8'b00111000
// SMTrBIDCYR7 at offset 0xE0

`define HADDR_SMTrBWSTRDR7            8'b00111001
// SMTrBWSTRDR7 at offset 0xE4

`define HADDR_SMTrBWSTWRR7            8'b00111010
// SMTrBWSTWRR7 at offset 0xE8

`define HADDR_SMTrBWSTOENR7           8'b00111011
// SMTrBWSTOENR7 at offset 0xEC

`define HADDR_SMTrBWSTWENR7           8'b00111100
// SMTrBWSTWENR7 at offset 0xF0

`define HADDR_SMTrBCR7                8'b00111101
// SMTrBCR7 at offset 0xF4

`define HADDR_SMTrBWSTBRDR7           8'b00111111
// SMTrBWSTBRDR7  at offset 0xFC
 

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [17:0] SelLatchHADDR;
// Used for Adress decoding

wire  [3:0] NxtSMTrBIDCYR0;
// D-input of SMCTrIDCYR0 Register

wire  [3:0] NxtSMTrBIDCYR1;
// D-input of SMCTrIDCYR1 Register

wire  [3:0] NxtSMTrBIDCYR2;
// D-input of SMCTrIDCYR2 Register

wire  [3:0] NxtSMTrBIDCYR3;
// D-input of SMCTrIDCYR3 Register

wire  [3:0] NxtSMTrBIDCYR4;
// D-input of SMCTrIDCYR4 Register

wire  [3:0] NxtSMTrBIDCYR5;
// D-input of SMCTrIDCYR5 Register

wire  [3:0] NxtSMTrBIDCYR6;
// D-input of SMCTrIDCYR6 Register

wire  [3:0] NxtSMTrBIDCYR7;
// D-input of SMCTrIDCYR7 Register

wire  [4:0] NxtSMTrBWSTRDR0;
// D-input of SMTrBWSTRDR0

wire  [4:0] NxtSMTrBWSTRDR1;
// D-input of SMTrBWSTRDR1

wire  [4:0] NxtSMTrBWSTRDR2;
// D-input of SMTrBWSTRDR2

wire  [4:0] NxtSMTrBWSTRDR3;
// D-input of SMTrBWSTRDR3

wire  [4:0] NxtSMTrBWSTRDR4;
// D-input of SMTrBWSTRDR4

wire  [4:0] NxtSMTrBWSTRDR5;
// D-input of SMTrBWSTRDR5

wire  [4:0] NxtSMTrBWSTRDR6;
// D-input of SMTrBWSTRDR6

wire  [4:0] NxtSMTrBWSTRDR7;
// D-input of SMTrBWSTRDR7

wire  [4:0] NxtSMTrBWSTWRR0;
// D-input of SMTrBWSTWRR0

wire  [4:0] NxtSMTrBWSTWRR1;
// D-input of SMTrBWSTWRR1

wire  [4:0] NxtSMTrBWSTWRR2;
// D-input of SMTrBWSTWRR2

wire  [4:0] NxtSMTrBWSTWRR3;
// D-input of SMTrBWSTWRR3

wire  [4:0] NxtSMTrBWSTWRR4;
// D-input of SMTrBWSTWRR4

wire  [4:0] NxtSMTrBWSTWRR5;
// D-input of SMTrBWSTWRR5

wire  [4:0] NxtSMTrBWSTWRR6;
// D-input of SMTrBWSTWRR6

wire  [4:0] NxtSMTrBWSTWRR7;
// D-input of SMTrBWSTWRR7

wire  [3:0] NxtSMTrBWSTOENR0;
// D-input of SMTrBWSTOENR0
 
wire  [3:0] NxtSMTrBWSTOENR1;
// D-input of SMTrBWSTOENR1
 
wire  [3:0] NxtSMTrBWSTOENR2;
// D-input of SMTrBWSTOENR2
 
wire  [3:0] NxtSMTrBWSTOENR3;
// D-input of SMTrBWSTOENR3
 
wire  [3:0] NxtSMTrBWSTOENR4;
// D-input of SMTrBWSTOENR4
 
wire  [3:0] NxtSMTrBWSTOENR5;
// D-input of SMTrBWSTOENR5
 
wire  [3:0] NxtSMTrBWSTOENR6;
// D-input of SMTrBWSTOENR6
 
wire  [3:0] NxtSMTrBWSTOENR7;
// D-input of SMTrBWSTOENR7

wire  [3:0] NxtSMTrBWSTWENR0;
// D-input of SMTrBWSTWENR0
 
wire  [3:0] NxtSMTrBWSTWENR1;
// D-input of SMTrBWSTWENR1
 
wire  [3:0] NxtSMTrBWSTWENR2;
// D-input of SMTrBWSTWENR2
 
wire  [3:0] NxtSMTrBWSTWENR3;
// D-input of SMTrBWSTWENR3
 
wire  [3:0] NxtSMTrBWSTWENR4;
// D-input of SMTrBWSTWENR4
 
wire  [3:0] NxtSMTrBWSTWENR5;
// D-input of SMTrBWSTWENR5
 
wire  [3:0] NxtSMTrBWSTWENR6;
// D-input of SMTrBWSTWENR6
 
wire  [3:0] NxtSMTrBWSTWENR7;
// D-input of SMTrBWSTWENR7

wire  [4:0] NxtSMTrBWSTBRDR0;
// D-input of SMTrBWSTBRDR0
 
wire  [4:0] NxtSMTrBWSTBRDR1;
// D-input of SMTrBWSTBRDR1
 
wire  [4:0] NxtSMTrBWSTBRDR2;
// D-input of SMTrBWSTBRDR2
 
wire  [4:0] NxtSMTrBWSTBRDR3;
// D-input of SMTrBWSTBRDR3
 
wire  [4:0] NxtSMTrBWSTBRDR4;
// D-input of SMTrBWSTBRDR4
 
wire  [4:0] NxtSMTrBWSTBRDR5;
// D-input of SMTrBWSTBRDR5
 
wire  [4:0] NxtSMTrBWSTBRDR6;
// D-input of SMTrBWSTBRDR6
 
wire  [4:0] NxtSMTrBWSTBRDR7;
// D-input of SMTrBWSTBRDR7

wire [21:0] NxtSMTrBCR0;
// D-input of SMTrBCR0
 
wire [21:0] NxtSMTrBCR1;
// D-input of SMTrBCR1
 
wire [21:0] NxtSMTrBCR2;
// D-input of SMTrBCR2
 
wire [21:0] NxtSMTrBCR3;
// D-input of SMTrBCR3
 
wire [21:0] NxtSMTrBCR4;
// D-input of SMTrBCR4
 
wire [21:0] NxtSMTrBCR5;
// D-input of SMTrBCR5
 
wire [21:0] NxtSMTrBCR6;
// D-input of SMTrBCR6
 
wire [21:0] NxtSMTrBCR7;
// D-input of SMTrBCR7

wire [14:0] NxtSSMCTrMEMBASE0;
// D-input of SSMCTrMEMBASE0  Register
 
wire [14:0] NxtSSMCTrMEMBASE1;
// D-input of SSMCTrMEMBASE1  Register
 
wire [14:0] NxtSSMCTrMEMBASE2;
// D-input of SSMCTrMEMBASE2  Register
 
wire [14:0] NxtSSMCTrMEMBASE3;
// D-input of SSMCTrMEMBASE3  Register
 
wire [14:0] NxtSSMCTrMEMBASE4;
// D-input of SSMCTrMEMBASE4  Register
 
wire [14:0] NxtSSMCTrMEMBASE5;
// D-input of SSMCTrMEMBASE5  Register
 
wire [14:0] NxtSSMCTrMEMBASE6;
// D-input of SSMCTrMEMBASE6  Register
 
wire [14:0] NxtSSMCTrMEMBASE7;
// D-input of SSMCTrMEMBASE7  Register

wire  [8:0] NxtSSMCTrBurstWT;
// D-input of SSMCTrBurstWT Register

wire        SSMCTrMEMARRAY0Rd;
// SSMCTrMEMARRAY Read

wire        SSMCTrMEMARRAY1Rd;
// SSMCTrMEMARRAY Read

wire        SSMCTrMEMARRAY2Rd;
// SSMCTrMEMARRAY Read

wire        SSMCTrMEMARRAY3Rd;
// SSMCTrMEMARRAY Read

wire        SSMCTrMEMARRAY4Rd;
// SSMCTrMEMARRAY Read

wire        SSMCTrMEMARRAY5Rd;
// SSMCTrMEMARRAY Read

wire        SSMCTrMEMARRAY6Rd;
// SSMCTrMEMARRAY Read

wire        SSMCTrMEMARRAY7Rd;
// SSMCTrMEMARRAY Read

wire        SMTrBIDCYR0Rd;
// SMCTrIDCYR0 Read

wire        SMTrBIDCYR1Rd;
// SMCTrIDCYR1 Read

wire        SMTrBIDCYR2Rd;
// SMCTrIDCYR2 Read

wire        SMTrBIDCYR3Rd;
// SMCTrIDCYR3 Read

wire        SMTrBIDCYR4Rd;
// SMCTrIDCYR4 Read

wire        SMTrBIDCYR5Rd;
// SMCTrIDCYR5 Read

wire        SMTrBIDCYR6Rd;
// SMCTrIDCYR6 Read

wire        SMTrBIDCYR7Rd;
// SMCTrIDCYR7 Read

wire        SMTrBWSTRDR0Rd;
// SMTrBWSTRDR0 Read

wire        SMTrBWSTRDR1Rd;
// SMTrBWSTRDR1 Read

wire        SMTrBWSTRDR2Rd;
// SMTrBWSTRDR2 Read

wire        SMTrBWSTRDR3Rd;
// SMTrBWSTRDR3 Read

wire        SMTrBWSTRDR4Rd;
// SMTrBWSTRDR4 Read

wire        SMTrBWSTRDR5Rd;
// SMTrBWSTRDR5 Read

wire        SMTrBWSTRDR6Rd;
// SMTrBWSTRDR6 Read

wire        SMTrBWSTRDR7Rd;
// SMTrBWSTRDR7 Read

wire        SMTrBWSTWRR0Rd;
// SMTrBWSTWRR0 Read
  
wire        SMTrBWSTWRR1Rd;
// SMTrBWSTWRR1 Read
  
wire        SMTrBWSTWRR2Rd;
// SMTrBWSTWRR2 Read
  
wire        SMTrBWSTWRR3Rd;
// SMTrBWSTWRR3 Read
  
wire        SMTrBWSTWRR4Rd;
// SMTrBWSTWRR4 Read
  
wire        SMTrBWSTWRR5Rd;
// SMTrBWSTWRR5 Read
  
wire        SMTrBWSTWRR6Rd;
// SMTrBWSTWRR6 Read
  
wire        SMTrBWSTWRR7Rd;
// SMTrBWSTWRR7 Read
  
wire        SMTrBWSTOENR0Rd;
// SMTrBWSTOENR0 Read

wire        SMTrBWSTOENR1Rd;
// SMTrBWSTOENR1 Read

wire        SMTrBWSTOENR2Rd;
// SMTrBWSTOENR2 Read

wire        SMTrBWSTOENR3Rd;
// SMTrBWSTOENR3 Read

wire        SMTrBWSTOENR4Rd;
// SMTrBWSTOENR4 Read

wire        SMTrBWSTOENR5Rd;
// SMTrBWSTOENR5 Read

wire        SMTrBWSTOENR6Rd;
// SMTrBWSTOENR6 Read

wire        SMTrBWSTOENR7Rd;
// SMTrBWSTOENR7 Read

wire        SMTrBWSTWENR0Rd;
// SMTrBWSTWENR0 Read
 
wire        SMTrBWSTWENR1Rd;
// SMTrBWSTWENR1 Read
 
wire        SMTrBWSTWENR2Rd;
// SMTrBWSTWENR2 Read
 
wire        SMTrBWSTWENR3Rd;
// SMTrBWSTWENR3 Read
 
wire        SMTrBWSTWENR4Rd;
// SMTrBWSTWENR4 Read
 
wire        SMTrBWSTWENR5Rd;
// SMTrBWSTWENR5 Read
 
wire        SMTrBWSTWENR6Rd;
// SMTrBWSTWENR6 Read
 
wire        SMTrBWSTWENR7Rd;
// SMTrBWSTWENR7 Read

wire        SMTrBWSTBRDR0Rd;
// SMTrBWSTBRDR0 Read
  
wire        SMTrBWSTBRDR1Rd;
// SMTrBWSTBRDR1 Read
  
wire        SMTrBWSTBRDR2Rd;
// SMTrBWSTBRDR2 Read
  
wire        SMTrBWSTBRDR3Rd;
// SMTrBWSTBRDR3 Read
  
wire        SMTrBWSTBRDR4Rd;
// SMTrBWSTBRDR4 Read
  
wire        SMTrBWSTBRDR5Rd;
// SMTrBWSTBRDR5 Read
  
wire        SMTrBWSTBRDR6Rd;
// SMTrBWSTBRDR6 Read
  
wire        SMTrBWSTBRDR7Rd;
// SMTrBWSTBRDR7 Read

wire        SMTrBCR0Rd;
// SMTrBCR0 Read

wire        SMTrBCR1Rd;
// SMTrBCR2 Read

wire        SMTrBCR2Rd;
// SMTrBCR2 Read

wire        SMTrBCR3Rd;
// SMTrBCR3 Read

wire        SMTrBCR4Rd;
// SMTrBCR4 Read

wire        SMTrBCR5Rd;
// SMTrBCR5 Read

wire        SMTrBCR6Rd;
// SMTrBCR6 Read

wire        SMTrBCR7Rd;
// SMTrBCR7 Read

wire        SSMCTrMEMBASE0Rd;
// SSMCTrMEMBASE0  Read

wire        SSMCTrMEMBASE1Rd;
// SSMCTrMEMBASE1 Read

wire        SSMCTrMEMBASE2Rd;
// SSMCTrMEMBASE2 Read

wire        SSMCTrMEMBASE3Rd;
// SSMCTrMEMBASE3 Read

wire        SSMCTrMEMBASE4Rd;
// SSMCTrMEMBASE4 Read

wire        SSMCTrMEMBASE5Rd;
// SSMCTrMEMBASE5 Read

wire        SSMCTrMEMBASE6Rd;
// SSMCTrMEMBASE6 Read

wire        SSMCTrMEMBASE7Rd;
// SSMCTrMEMBASE7 Read

wire        SSMCTrBurstWTRd;
// SSMCTrBurstWT Read

wire        SMTrBIDCYR0Wr;
// SMCTrIDCYR0 Write

wire        SMTrBIDCYR1Wr;
// SMCTrIDCYR1 Write

wire        SMTrBIDCYR2Wr;
// SMCTrIDCYR2 Write

wire        SMTrBIDCYR3Wr;
// SMCTrIDCYR3 Write

wire        SMTrBIDCYR4Wr;
// SMCTrIDCYR4 Write

wire        SMTrBIDCYR5Wr;
// SMCTrIDCYR5 Write

wire        SMTrBIDCYR6Wr;
// SMCTrIDCYR6 Write

wire        SMTrBIDCYR7Wr;
// SMCTrIDCYR7 Write

wire        SMTrBWSTRDR0Wr;
// SMTrBWSTRDR0 Write

wire        SMTrBWSTRDR1Wr;
// SMTrBWSTRDR1 Write

wire        SMTrBWSTRDR2Wr;
// SMTrBWSTRDR2 Write

wire        SMTrBWSTRDR3Wr;
// SMTrBWSTRDR3 Write

wire        SMTrBWSTRDR4Wr;
// SMTrBWSTRDR4 Write

wire        SMTrBWSTRDR5Wr;
// SMTrBWSTRDR5 Write

wire        SMTrBWSTRDR6Wr;
// SMTrBWSTRDR6 Write

wire        SMTrBWSTRDR7Wr;
// SMTrBWSTRDR7 Write

wire        SMTrBWSTWRR0Wr;
// SMTrBWSTWRR0 Write

wire        SMTrBWSTWRR1Wr;
// SMTrBWSTWRR1 Write

wire        SMTrBWSTWRR2Wr;
// SMTrBWSTWRR2 Write

wire        SMTrBWSTWRR3Wr;
// SMTrBWSTWRR3 Write

wire        SMTrBWSTWRR4Wr;
// SMTrBWSTWRR4 Write

wire        SMTrBWSTWRR5Wr;
// SMTrBWSTWRR5 Write

wire        SMTrBWSTWRR6Wr;
// SMTrBWSTWRR6 Write

wire        SMTrBWSTWRR7Wr;
// SMTrBWSTWRR7 Write

wire        SMTrBWSTOENR0Wr;
// SMTrBWSTOENR0 Write

wire        SMTrBWSTOENR1Wr;
// SMTrBWSTOENR1 Write

wire        SMTrBWSTOENR2Wr;
// SMTrBWSTOENR2 Write

wire        SMTrBWSTOENR3Wr;
// SMTrBWSTOENR3 Write

wire        SMTrBWSTOENR4Wr;
// SMTrBWSTOENR4 Write

wire        SMTrBWSTOENR5Wr;
// SMTrBWSTOENR5 Write

wire        SMTrBWSTOENR6Wr;
// SMTrBWSTOENR6 Write

wire        SMTrBWSTOENR7Wr;
// SMTrBWSTOENR7 Write

wire        SMTrBWSTWENR0Wr;
// SMTrBWSTWENR0 Write

wire        SMTrBWSTWENR1Wr;
// SMTrBWSTWENR1 Write

wire        SMTrBWSTWENR2Wr;
// SMTrBWSTWENR2 Write

wire        SMTrBWSTWENR3Wr;
// SMTrBWSTWENR3 Write

wire        SMTrBWSTWENR4Wr;
// SMTrBWSTWENR4 Write

wire        SMTrBWSTWENR5Wr;
// SMTrBWSTWENR5 Write

wire        SMTrBWSTWENR6Wr;
// SMTrBWSTWENR6 Write

wire        SMTrBWSTWENR7Wr;
// SMTrBWSTWENR7 Write

wire        SMTrBWSTBRDR0Wr;
// SMTrBWSTBRDR0 Write

wire        SMTrBWSTBRDR1Wr;
// SMTrBWSTBRDR1 Write

wire        SMTrBWSTBRDR2Wr;
// SMTrBWSTBRDR2 Write

wire        SMTrBWSTBRDR3Wr;
// SMTrBWSTBRDR3 Write

wire        SMTrBWSTBRDR4Wr;
// SMTrBWSTBRDR4 Write

wire        SMTrBWSTBRDR5Wr;
// SMTrBWSTBRDR5 Write

wire        SMTrBWSTBRDR6Wr;
// SMTrBWSTBRDR6 Write

wire        SMTrBWSTBRDR7Wr;
// SMTrBWSTBRDR7 Write

wire        SMTrBCR0Wr;
// SMTrBCR0 Write

wire        SMTrBCR1Wr;
// SMTrBCR2 Write

wire        SMTrBCR2Wr;
// SMTrBCR2 Write

wire        SMTrBCR3Wr;
// SMTrBCR3 Write

wire        SMTrBCR4Wr;
// SMTrBCR4 Write

wire        SMTrBCR5Wr;
// SMTrBCR5 Write

wire        SMTrBCR6Wr;
// SMTrBCR6 Write

wire        SMTrBCR7Wr;
// SMTrBCR7 Write

wire        SSMCTrMEMBASE0Wr;
// SSMCTrMEMBASE0  Write

wire        SSMCTrMEMBASE1Wr;
// SSMCTrMEMBASE1 Write

wire        SSMCTrMEMBASE2Wr;
// SSMCTrMEMBASE2 Write

wire        SSMCTrMEMBASE3Wr;
// SSMCTrMEMBASE3 Write

wire        SSMCTrMEMBASE4Wr;
// SSMCTrMEMBASE4 Write

wire        SSMCTrMEMBASE5Wr;
// SSMCTrMEMBASE5 Write

wire        SSMCTrMEMBASE6Wr;
// SSMCTrMEMBASE6 Write

wire        SSMCTrMEMBASE7Wr;
// SSMCTrMEMBASE7 Write

wire        SSMCTrBurstWTWr;
// SSMCTrBurstWT Write


// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [17:0] iLatchHADDR;
// Latched version of HADDR

reg   [1:0] iHRESPTr;
// Indicates the type of response for a transfer

reg  [3:0] iSMTrBIDCYR0;
// Internal version of SMCTrIDCYR0 Register

reg  [3:0] iSMTrBIDCYR1;
// Internal version of SMCTrIDCYR1 Register

reg  [3:0] iSMTrBIDCYR2;
// Internal version of SMCTrIDCYR2 Register

reg  [3:0] iSMTrBIDCYR3;
// Internal version of SMCTrIDCYR3 Register

reg  [3:0] iSMTrBIDCYR4;
// Internal version of SMCTrIDCYR4 Register

reg  [3:0] iSMTrBIDCYR5;
// Internal version of SMCTrIDCYR5 Register

reg  [3:0] iSMTrBIDCYR6;
// Internal version of SMCTrIDCYR6 Register

reg  [3:0] iSMTrBIDCYR7;
// Internal version of SMCTrIDCYR7 Register

reg  [4:0] iSMTrBWSTRDR0;
// Internal version of SMTrBWSTRDR0

reg  [4:0] iSMTrBWSTRDR1;
// Internal version of SMTrBWSTRDR1

reg  [4:0] iSMTrBWSTRDR2;
// Internal version of SMTrBWSTRDR2

reg  [4:0] iSMTrBWSTRDR3;
// Internal version of SMTrBWSTRDR3

reg  [4:0] iSMTrBWSTRDR4;
// Internal version of SMTrBWSTRDR4

reg  [4:0] iSMTrBWSTRDR5;
// Internal version of SMTrBWSTRDR5

reg  [4:0] iSMTrBWSTRDR6;
// Internal version of SMTrBWSTRDR6

reg  [4:0] iSMTrBWSTRDR7;
// Internal version of SMTrBWSTRDR7

reg  [4:0] iSMTrBWSTWRR0;
// Internal version of SMTrBWSTWRR0

reg  [4:0] iSMTrBWSTWRR1;
// Internal version of SMTrBWSTWRR1

reg  [4:0] iSMTrBWSTWRR2;
// Internal version of SMTrBWSTWRR2

reg  [4:0] iSMTrBWSTWRR3;
// Internal version of SMTrBWSTWRR3

reg  [4:0] iSMTrBWSTWRR4;
// Internal version of SMTrBWSTWRR4

reg  [4:0] iSMTrBWSTWRR5;
// Internal version of SMTrBWSTWRR5

reg  [4:0] iSMTrBWSTWRR6;
// Internal version of SMTrBWSTWRR6

reg  [4:0] iSMTrBWSTWRR7;
// Internal version of SMTrBWSTWRR7

reg  [3:0] iSMTrBWSTOENR0;
// Internal version of SMTrBWSTOENR0

reg  [3:0] iSMTrBWSTOENR1;
// Internal version of SMTrBWSTOENR1

reg  [3:0] iSMTrBWSTOENR2;
// Internal version of SMTrBWSTOENR2

reg  [3:0] iSMTrBWSTOENR3;
// Internal version of SMTrBWSTOENR3

reg  [3:0] iSMTrBWSTOENR4;
// Internal version of SMTrBWSTOENR4

reg  [3:0] iSMTrBWSTOENR5;
// Internal version of SMTrBWSTOENR5

reg  [3:0] iSMTrBWSTOENR6;
// Internal version of SMTrBWSTOENR6

reg  [3:0] iSMTrBWSTOENR7;
// Internal version of SMTrBWSTOENR7

reg  [3:0] iSMTrBWSTWENR0;
// Internal version of SMTrBWSTWENR0

reg  [3:0] iSMTrBWSTWENR1;
// Internal version of SMTrBWSTWENR1

reg  [3:0] iSMTrBWSTWENR2;
// Internal version of SMTrBWSTWENR2

reg  [3:0] iSMTrBWSTWENR3;
// Internal version of SMTrBWSTWENR3

reg  [3:0] iSMTrBWSTWENR4;
// Internal version of SMTrBWSTWENR4

reg  [3:0] iSMTrBWSTWENR5;
// Internal version of SMTrBWSTWENR5

reg  [3:0] iSMTrBWSTWENR6;
// Internal version of SMTrBWSTWENR6

reg  [3:0] iSMTrBWSTWENR7;
// Internal version of SMTrBWSTWENR7

reg  [4:0] iSMTrBWSTBRDR0;
// Internal version of SMTrBWSTBRDR0

reg  [4:0] iSMTrBWSTBRDR1;
// Internal version of SMTrBWSTBRDR1

reg  [4:0] iSMTrBWSTBRDR2;
// Internal version of SMTrBWSTBRDR2

reg  [4:0] iSMTrBWSTBRDR3;
// Internal version of SMTrBWSTBRDR3

reg  [4:0] iSMTrBWSTBRDR4;
// Internal version of SMTrBWSTBRDR4

reg  [4:0] iSMTrBWSTBRDR5;
// Internal version of SMTrBWSTBRDR5

reg  [4:0] iSMTrBWSTBRDR6;
// Internal version of SMTrBWSTBRDR6

reg  [4:0] iSMTrBWSTBRDR7;
// Internal version of SMTrBWSTBRDR7

reg [21:0] iSMTrBCR0;
// Internal version of SMTrBCR0

reg [21:0] iSMTrBCR1;
// Internal version of SMTrBCR1

reg [21:0] iSMTrBCR2;
// Internal version of SMTrBCR2

reg [21:0] iSMTrBCR3;
// Internal version of SMTrBCR3

reg [21:0] iSMTrBCR4;
// Internal version of SMTrBCR4

reg [21:0] iSMTrBCR5;
// Internal version of SMTrBCR5

reg [21:0] iSMTrBCR6;
// Internal version of SMTrBCR6

reg [21:0] iSMTrBCR7;
// Internal version of SMTrBCR7

reg [14:0] iSSMCTrMEMBASE0;
// Internal version of SSMCTrMEMBASE0  Register

reg [14:0] iSSMCTrMEMBASE1;
// Internal version of SSMCTrMEMBASE1  Register

reg [14:0] iSSMCTrMEMBASE2;
// Internal version of SSMCTrMEMBASE2  Register

reg [14:0] iSSMCTrMEMBASE3;
// Internal version of SSMCTrMEMBASE3  Register

reg [14:0] iSSMCTrMEMBASE4;
// Internal version of SSMCTrMEMBASE4  Register

reg [14:0] iSSMCTrMEMBASE5;
// Internal version of SSMCTrMEMBASE5  Register

reg [14:0] iSSMCTrMEMBASE6;
// Internal version of SSMCTrMEMBASE6  Register

reg [14:0] iSSMCTrMEMBASE7;
// Internal version of SSMCTrMEMBASE7  Register

reg  [8:0] iSSMCTrBurstWT;
// Internal version of SSMCTrBurstWT Register

reg         RdEn;
// Read enable signal

reg         RdRegEn;
// Read enable signal for mirror registers

reg         WrEn;
// Write enable signal

reg         WrRegEn;
// Write enable signal for mirror registers

reg         ErrorLat;
// Latch error condition

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
// It is used for address decoding
// -----------------------------------------------------------------------------
assign SelLatchHADDR    = iLatchHADDR;

// -----------------------------------------------------------------------------
// Write enable for registers
// -----------------------------------------------------------------------------
assign SSMCTrMEMARRAY0Wr = ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY0)) ?
                                                      1'b1 : 1'b0;
    
assign SSMCTrMEMARRAY1Wr = ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY1)) ?
                                                      1'b1 : 1'b0;
    
assign SSMCTrMEMARRAY2Wr = ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY2)) ?
                                                      1'b1 : 1'b0;
    
assign SSMCTrMEMARRAY3Wr = ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY3)) ?
                                                      1'b1 : 1'b0;
    
assign SSMCTrMEMARRAY4Wr = ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY4)) ?
                                                      1'b1 : 1'b0;
    
assign SSMCTrMEMARRAY5Wr = ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY5)) ?
                                                      1'b1 : 1'b0;
    
assign SSMCTrMEMARRAY6Wr = ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY6)) ?
                                                      1'b1 : 1'b0;
    
assign SSMCTrMEMARRAY7Wr = ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY7)) ?
                                                      1'b1 : 1'b0;

assign SMTrBIDCYR0Wr     = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBIDCYR0)) ?
                                                      1'b1 : 1'b0;

assign SMTrBIDCYR1Wr     = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBIDCYR1)) ?
                                                      1'b1 : 1'b0;

assign SMTrBIDCYR2Wr     = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBIDCYR2)) ?
                                                      1'b1 : 1'b0;

assign SMTrBIDCYR3Wr     = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBIDCYR3)) ?
                                                      1'b1 : 1'b0;

assign SMTrBIDCYR4Wr     = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBIDCYR4)) ?
                                                      1'b1 : 1'b0;

assign SMTrBIDCYR5Wr     = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBIDCYR5)) ?
                                                      1'b1 : 1'b0;

assign SMTrBIDCYR6Wr     = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBIDCYR6)) ?
                                                      1'b1 : 1'b0;

assign SMTrBIDCYR7Wr     = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBIDCYR7)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTRDR0Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTRDR0)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTRDR1Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTRDR1)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTRDR2Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTRDR2)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTRDR3Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTRDR3)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTRDR4Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTRDR4)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTRDR5Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTRDR5)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTRDR6Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTRDR6)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTRDR7Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTRDR7)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTWRR0Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWRR0)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTWRR1Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWRR1)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTWRR2Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWRR2)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTWRR3Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWRR3)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTWRR4Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWRR4)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTWRR5Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWRR5)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTWRR6Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWRR6)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTWRR7Wr    = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWRR7)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTOENR0Wr   = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTOENR0)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTOENR1Wr   = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTOENR1)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTOENR2Wr   = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTOENR2)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTOENR3Wr   = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTOENR3)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTOENR4Wr   = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTOENR4)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTOENR5Wr   = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTOENR5)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTOENR6Wr   = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTOENR6)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTOENR7Wr   = ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTOENR7)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTWENR0Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWENR0)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTWENR1Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWENR1)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTWENR2Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWENR2)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTWENR3Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWENR3)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTWENR4Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWENR4)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTWENR5Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWENR5)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTWENR6Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWENR6)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTWENR7Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTWENR7)) ?
                                                      1'b1 : 1'b0;

assign SMTrBWSTBRDR0Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTBRDR0)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTBRDR1Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTBRDR1)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTBRDR2Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTBRDR2)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTBRDR3Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTBRDR3)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTBRDR4Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTBRDR4)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTBRDR5Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTBRDR5)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTBRDR6Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTBRDR6)) ?
                                                      1'b1 : 1'b0;
 
assign SMTrBWSTBRDR7Wr  =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBWSTBRDR7)) ?
                                                      1'b1 : 1'b0;
assign SMTrBCR0Wr       =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBCR0)) ?
                                                      1'b1 : 1'b0;

assign SMTrBCR1Wr       =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBCR1)) ?
                                                      1'b1 : 1'b0;

assign SMTrBCR2Wr       =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBCR2)) ?
                                                      1'b1 : 1'b0;

assign SMTrBCR3Wr       =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBCR3)) ?
                                                      1'b1 : 1'b0;

assign SMTrBCR4Wr       =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBCR4)) ?
                                                      1'b1 : 1'b0;

assign SMTrBCR5Wr       =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBCR5)) ?
                                                      1'b1 : 1'b0;

assign SMTrBCR6Wr       =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBCR6)) ?
                                                      1'b1 : 1'b0;

assign SMTrBCR7Wr       =  ((WrRegEn == 1'b1) &
                            (SelLatchHADDR[9:2] == `HADDR_SMTrBCR7)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE0Wr =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE0)) ?
                                                      1'b1 : 1'b0; 
 
assign SSMCTrMEMBASE1Wr =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE1)) ?
                                                      1'b1 : 1'b0; 
 
assign SSMCTrMEMBASE2Wr =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE2)) ?
                                                      1'b1 : 1'b0; 
 
assign SSMCTrMEMBASE3Wr =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE3)) ?
                                                      1'b1 : 1'b0; 
 
assign SSMCTrMEMBASE4Wr =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE4)) ?
                                                      1'b1 : 1'b0; 
 
assign SSMCTrMEMBASE5Wr =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE5)) ?
                                                      1'b1 : 1'b0; 
 
assign SSMCTrMEMBASE6Wr =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE6)) ?
                                                      1'b1 : 1'b0; 
 
assign SSMCTrMEMBASE7Wr =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE7)) ?
                                                      1'b1 : 1'b0; 
 
assign SSMCTrBurstWTWr  =  ((WrEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrBurstWT)) ?
                                                      1'b1 : 1'b0;
// -----------------------------------------------------------------------------
// Read enable for registers
// -----------------------------------------------------------------------------
assign SSMCTrMEMARRAY0Rd = ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY0)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMARRAY1Rd = ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY1)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMARRAY2Rd = ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY2)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMARRAY3Rd = ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY3)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMARRAY4Rd = ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY4)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMARRAY5Rd = ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY5)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMARRAY6Rd = ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY6)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMARRAY7Rd = ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMARRAY7)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE0Rd =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE0)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE1Rd =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE1)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE2Rd =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE2)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE3Rd =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE3)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE4Rd =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE4)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE5Rd =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE5)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE6Rd =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE6)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrMEMBASE7Rd =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrMEMBASE7)) ?
                                                      1'b1 : 1'b0;

assign SSMCTrBurstWTRd  =  ((RdEn == 1'b1) &
                            (SelLatchHADDR[17:13] == `HADDR_SSMCTrBurstWT)) ?
                                                      1'b1 : 1'b0;
// -----------------------------------------------------------------------------
// Output Mux
// When the peripheral is not being accessed, '0's are driven
// on the Read Databus (HRDATA)
// -----------------------------------------------------------------------------
assign HRDATATr         = (SSMCTrMEMARRAY0Rd == 1'b1) ?
                           AhbRdDataDW0 :
                          ((SSMCTrMEMARRAY1Rd == 1'b1) ?
                           AhbRdDataDW1 :                  
                          ((SSMCTrMEMARRAY2Rd == 1'b1) ?
                           AhbRdDataDW2 :                  
                          ((SSMCTrMEMARRAY3Rd == 1'b1) ?
                           AhbRdDataDW3 :                  
                          ((SSMCTrMEMARRAY4Rd == 1'b1) ?
                           AhbRdDataDW4 :                  
                          ((SSMCTrMEMARRAY5Rd == 1'b1) ?
                           AhbRdDataDW5 :                  
                          ((SSMCTrMEMARRAY6Rd == 1'b1) ?
                           AhbRdDataDW6 :                  
                          ((SSMCTrMEMARRAY7Rd == 1'b1) ?
                           AhbRdDataDW7 :
                          ((SSMCTrMEMBASE0Rd == 1'b1) ?
                           {17'b00000000000000000, iSSMCTrMEMBASE0} :
                          ((SSMCTrMEMBASE1Rd == 1'b1) ?
                           {17'b00000000000000000, iSSMCTrMEMBASE1} :
                          ((SSMCTrMEMBASE2Rd == 1'b1) ?
                           {17'b00000000000000000, iSSMCTrMEMBASE2} :
                          ((SSMCTrMEMBASE3Rd == 1'b1) ?
                           {17'b00000000000000000, iSSMCTrMEMBASE3} :
                          ((SSMCTrMEMBASE4Rd == 1'b1) ?
                           {17'b00000000000000000, iSSMCTrMEMBASE4} :
                          ((SSMCTrMEMBASE5Rd == 1'b1) ?
                           {17'b00000000000000000, iSSMCTrMEMBASE5} :
                          ((SSMCTrMEMBASE6Rd == 1'b1) ?
                           {17'b00000000000000000, iSSMCTrMEMBASE6} :
                          ((SSMCTrMEMBASE7Rd == 1'b1) ?
                           {17'b00000000000000000, iSSMCTrMEMBASE7} :
                          ((SSMCTrBurstWTRd == 1'b1) ?
                           {24'b000000000000000000000000, iSSMCTrBurstWT} :
                           32'h00000000))))))))))))))));
// -----------------------------------------------------------------------------
// This process generate the bus response required for an AHB slave.
// SSMC trickbox is designed for an HBURST of INCR type and an HSIZE of 32-bit.
// So this process will generate an ERROR response when the master try to access
// it in some other mode. Also it display an error message to the output.
// Trickbox always provides a ZERO wait state OKAY response for IDLE and BUSY
// HTRANS of the master.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BusRespSeq
  if (HRESETn == 1'b0)
    begin
      iHRESPTr         <= 2'b00;
      HREADYOUTTr      <= 1'b1;
      WrEn             <= 1'b0;
      WrRegEn          <= 1'b0;
      RdEn             <= 1'b0;
      RdRegEn          <= 1'b0;
      ErrorLat         <= 1'b0;
      iLatchHADDR      <= 16'h0000;
    end
  else
    begin
      if ((iHRESPTr == `ERROR) && (HREADYINTr == 1'b0) && (ErrorLat == 1'b1))
        begin
          iHRESPTr         <= `ERROR;
          HREADYOUTTr      <= 1'b1;
          WrEn             <= 1'b0;
          RdEn             <= 1'b0;
          ErrorLat         <= 1'b0;
        end
      else if (((HTRANS == `IDLE) || (HTRANS == `BUSY)) &&
              (HSELSSMCTrMEM == 1'b1) && (HREADYINTr == 1'b1))
        begin
          iHRESPTr         <= `OKAY;
          HREADYOUTTr      <= 1'b1;
        end
      else if ((HREADYINTr == 1'b1) && (HSELSSMCTrMEM == 1'b1))
        begin 
          if ((HBURST == `INCR) && (HSIZE == `WORD))
            begin
              HREADYOUTTr      <= 1'b1;
              iLatchHADDR      <= HADDR;
              iHRESPTr         <= `OKAY;
              if (HWRITETr == 1'b1)
                begin
                  WrEn             <= 1'b1;
                  RdEn             <= 1'b0;
                end
              else
                begin
                  WrEn             <= 1'b0;
                  RdEn             <= 1'b1;
                end
            end
          else
            begin
              iHRESPTr         <= `ERROR;
              HREADYOUTTr      <= 1'b0;
              WrEn             <= 1'b0;
              RdEn             <= 1'b0;
              ErrorLat         <= 1'b1;
              $display("Error Response from SSMC TrickMem slave");
            end
        end
      else if ((HREADYINREG == 1'b1) && (HSELSSMCTrREG == 1'b1))
        begin
        //  WrEn             <= 1'b0;
        //  RdEn             <= 1'b0;
          if ((HBURST == `INCR) && (HSIZE == `WORD))
            begin
              HREADYOUTTr      <= 1'b1;
              iLatchHADDR      <= HADDR;
              iHRESPTr         <= `OKAY;
              if (HWRITEREG == 1'b1)
                begin
                  WrRegEn        <= 1'b1;
                  RdRegEn        <= 1'b0;
                end
              else
                begin
                  WrRegEn        <= 1'b0;
                  RdRegEn        <= 1'b1;
                end
            end 
          else
            begin
              WrRegEn        <= 1'b0;
              RdRegEn        <= 1'b0;
            end
        end
      else
        begin
          WrEn             <= 1'b0;
          WrRegEn          <= 1'b0;
          RdEn             <= 1'b0;
          RdRegEn          <= 1'b0; 
          iHRESPTr         <= 2'b00;
          HREADYOUTTr      <= 1'b1;
          ErrorLat         <= 1'b0;
        end
    end
end // p_BusRespSeq

// -----------------------------------------------------------------------------
// Combinational logic for all functional registers. When the respective
// write enable input is asserted, copy the contents of the HWDATA Bus into
// the corresponding registers.
// -----------------------------------------------------------------------------
assign NxtSMTrBIDCYR0   = (SMTrBIDCYR0Wr == 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBIDCYR0; 

assign NxtSMTrBIDCYR1   = (SMTrBIDCYR1Wr == 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBIDCYR1; 

assign NxtSMTrBIDCYR2   = (SMTrBIDCYR2Wr == 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBIDCYR2; 

assign NxtSMTrBIDCYR3   = (SMTrBIDCYR3Wr == 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBIDCYR3; 

assign NxtSMTrBIDCYR4   = (SMTrBIDCYR4Wr == 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBIDCYR4; 

assign NxtSMTrBIDCYR5   = (SMTrBIDCYR5Wr == 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBIDCYR5; 

assign NxtSMTrBIDCYR6   = (SMTrBIDCYR6Wr == 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBIDCYR6; 

assign NxtSMTrBIDCYR7   = (SMTrBIDCYR7Wr == 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBIDCYR7; 


assign NxtSMTrBWSTRDR0  = (SMTrBWSTRDR0Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTRDR0; 

assign NxtSMTrBWSTRDR1  = (SMTrBWSTRDR1Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTRDR1; 

assign NxtSMTrBWSTRDR2  = (SMTrBWSTRDR2Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTRDR2; 

assign NxtSMTrBWSTRDR3  = (SMTrBWSTRDR3Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTRDR3; 

assign NxtSMTrBWSTRDR4  = (SMTrBWSTRDR4Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTRDR4; 

assign NxtSMTrBWSTRDR5  = (SMTrBWSTRDR5Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTRDR5; 

assign NxtSMTrBWSTRDR6  = (SMTrBWSTRDR6Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTRDR6; 

assign NxtSMTrBWSTRDR7  = (SMTrBWSTRDR7Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTRDR7; 


assign NxtSMTrBWSTWRR0  = (SMTrBWSTWRR0Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTWRR0;
 
assign NxtSMTrBWSTWRR1  = (SMTrBWSTWRR1Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTWRR1;
 
assign NxtSMTrBWSTWRR2  = (SMTrBWSTWRR2Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTWRR2;
 
assign NxtSMTrBWSTWRR3  = (SMTrBWSTWRR3Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTWRR3;
 
assign NxtSMTrBWSTWRR4  = (SMTrBWSTWRR4Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTWRR4;
 
assign NxtSMTrBWSTWRR5  = (SMTrBWSTWRR5Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTWRR5;
 
assign NxtSMTrBWSTWRR6  = (SMTrBWSTWRR6Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTWRR6;
 
assign NxtSMTrBWSTWRR7  = (SMTrBWSTWRR7Wr == 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTWRR7;
 

assign NxtSMTrBWSTOENR0 = (SMTrBWSTOENR0Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTOENR0;

assign NxtSMTrBWSTOENR1 = (SMTrBWSTOENR1Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTOENR1;

assign NxtSMTrBWSTOENR2 = (SMTrBWSTOENR2Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTOENR2;

assign NxtSMTrBWSTOENR3 = (SMTrBWSTOENR3Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTOENR3;

assign NxtSMTrBWSTOENR4 = (SMTrBWSTOENR4Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTOENR4;

assign NxtSMTrBWSTOENR5 = (SMTrBWSTOENR5Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTOENR5;

assign NxtSMTrBWSTOENR6 = (SMTrBWSTOENR6Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTOENR6;

assign NxtSMTrBWSTOENR7 = (SMTrBWSTOENR7Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTOENR7;


assign NxtSMTrBWSTWENR0 = (SMTrBWSTWENR0Wr== 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBWSTWENR0;

assign NxtSMTrBWSTWENR1 = (SMTrBWSTWENR1Wr== 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBWSTWENR1;

assign NxtSMTrBWSTWENR2 = (SMTrBWSTWENR2Wr== 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBWSTWENR2;

assign NxtSMTrBWSTWENR3 = (SMTrBWSTWENR3Wr== 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBWSTWENR3;

assign NxtSMTrBWSTWENR4 = (SMTrBWSTWENR4Wr== 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBWSTWENR4;

assign NxtSMTrBWSTWENR5 = (SMTrBWSTWENR5Wr== 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBWSTWENR5;

assign NxtSMTrBWSTWENR6 = (SMTrBWSTWENR6Wr== 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBWSTWENR6;

assign NxtSMTrBWSTWENR7 = (SMTrBWSTWENR7Wr== 1'b1) ?
                           HWDATAREG[3:0] : iSMTrBWSTWENR7;


assign NxtSMTrBWSTBRDR0 = (SMTrBWSTBRDR0Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTBRDR0;

assign NxtSMTrBWSTBRDR1 = (SMTrBWSTBRDR1Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTBRDR1;

assign NxtSMTrBWSTBRDR2 = (SMTrBWSTBRDR2Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTBRDR2;

assign NxtSMTrBWSTBRDR3 = (SMTrBWSTBRDR3Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTBRDR3;

assign NxtSMTrBWSTBRDR4 = (SMTrBWSTBRDR4Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTBRDR4;

assign NxtSMTrBWSTBRDR5 = (SMTrBWSTBRDR5Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTBRDR5;

assign NxtSMTrBWSTBRDR6 = (SMTrBWSTBRDR6Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTBRDR6;

assign NxtSMTrBWSTBRDR7 = (SMTrBWSTBRDR7Wr== 1'b1) ?
                           HWDATAREG[4:0] : iSMTrBWSTBRDR7;


assign NxtSMTrBCR0      = (SMTrBCR0Wr     == 1'b1) ?
                           HWDATAREG[21:0] : iSMTrBCR0;

assign NxtSMTrBCR1      = (SMTrBCR1Wr     == 1'b1) ?
                           HWDATAREG[21:0] : iSMTrBCR1;

assign NxtSMTrBCR2      = (SMTrBCR2Wr     == 1'b1) ?
                           HWDATAREG[21:0] : iSMTrBCR2;

assign NxtSMTrBCR3      = (SMTrBCR3Wr     == 1'b1) ?
                           HWDATAREG[21:0] : iSMTrBCR3;

assign NxtSMTrBCR4      = (SMTrBCR4Wr     == 1'b1) ?
                           HWDATAREG[21:0] : iSMTrBCR4;

assign NxtSMTrBCR5      = (SMTrBCR5Wr     == 1'b1) ?
                           HWDATAREG[21:0] : iSMTrBCR5;

assign NxtSMTrBCR6      = (SMTrBCR6Wr     == 1'b1) ?
                           HWDATAREG[21:0] : iSMTrBCR6;

assign NxtSMTrBCR7      = (SMTrBCR7Wr     == 1'b1) ?
                           HWDATAREG[21:0] : iSMTrBCR7;


assign NxtSSMCTrMEMBASE0 = (SSMCTrMEMBASE0Wr == 1'b1) ?
                           HWDATA[14:0] : iSSMCTrMEMBASE0;

assign NxtSSMCTrMEMBASE1 = (SSMCTrMEMBASE1Wr == 1'b1) ?
                           HWDATA[14:0] : iSSMCTrMEMBASE1;

assign NxtSSMCTrMEMBASE2 = (SSMCTrMEMBASE2Wr == 1'b1) ?
                           HWDATA[14:0] : iSSMCTrMEMBASE2;

assign NxtSSMCTrMEMBASE3 = (SSMCTrMEMBASE3Wr == 1'b1) ?
                           HWDATA[14:0] : iSSMCTrMEMBASE3;

assign NxtSSMCTrMEMBASE4 = (SSMCTrMEMBASE4Wr == 1'b1) ?
                           HWDATA[14:0] : iSSMCTrMEMBASE4;

assign NxtSSMCTrMEMBASE5 = (SSMCTrMEMBASE5Wr == 1'b1) ?
                           HWDATA[14:0] : iSSMCTrMEMBASE5;

assign NxtSSMCTrMEMBASE6 = (SSMCTrMEMBASE6Wr == 1'b1) ?
                           HWDATA[14:0] : iSSMCTrMEMBASE6;

assign NxtSSMCTrMEMBASE7 = (SSMCTrMEMBASE7Wr == 1'b1) ?
                           HWDATA[14:0] : iSSMCTrMEMBASE7;


assign NxtSSMCTrBurstWT  = (SSMCTrBurstWTWr  == 1'b1) ?
                           HWDATA[8:0] : iSSMCTrBurstWT;

// -----------------------------------------------------------------------------
// Sequential process for all functional registers writes.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegUpdateSeq
  if (HRESETn == 1'b0)
  begin
     iSMTrBIDCYR0    <=   4'b0000;
     iSMTrBIDCYR1    <=   4'b0000;
     iSMTrBIDCYR2    <=   4'b0000;
     iSMTrBIDCYR3    <=   4'b0000;
     iSMTrBIDCYR4    <=   4'b0000;
     iSMTrBIDCYR5    <=   4'b0000;
     iSMTrBIDCYR6    <=   4'b0000;
     iSMTrBIDCYR7    <=   4'b0000;
 
     iSMTrBWSTRDR0   <=   5'b11111;
     iSMTrBWSTRDR1   <=   5'b11111;
     iSMTrBWSTRDR2   <=   5'b11111;
     iSMTrBWSTRDR3   <=   5'b11111;
     iSMTrBWSTRDR4   <=   5'b11111;
     iSMTrBWSTRDR5   <=   5'b11111;
     iSMTrBWSTRDR6   <=   5'b11111;
     iSMTrBWSTRDR7   <=   5'b11111;
 
     iSMTrBWSTWRR0   <=   5'b11111; 
     iSMTrBWSTWRR1   <=   5'b11111; 
     iSMTrBWSTWRR2   <=   5'b11111; 
     iSMTrBWSTWRR3   <=   5'b11111; 
     iSMTrBWSTWRR4   <=   5'b11111; 
     iSMTrBWSTWRR5   <=   5'b11111; 
     iSMTrBWSTWRR6   <=   5'b11111; 
     iSMTrBWSTWRR7   <=   5'b11111;

     iSMTrBWSTOENR0  <=   4'b0000;  
     iSMTrBWSTOENR1  <=   4'b0000;  
     iSMTrBWSTOENR2  <=   4'b0000;  
     iSMTrBWSTOENR3  <=   4'b0000;  
     iSMTrBWSTOENR4  <=   4'b0000;  
     iSMTrBWSTOENR5  <=   4'b0000;  
     iSMTrBWSTOENR6  <=   4'b0000;  
     iSMTrBWSTOENR7  <=   4'b0000;
 
     iSMTrBWSTWENR0  <=   4'b0001;
     iSMTrBWSTWENR1  <=   4'b0001;
     iSMTrBWSTWENR2  <=   4'b0001;
     iSMTrBWSTWENR3  <=   4'b0001;
     iSMTrBWSTWENR4  <=   4'b0001;
     iSMTrBWSTWENR5  <=   4'b0001;
     iSMTrBWSTWENR6  <=   4'b0001;
     iSMTrBWSTWENR7  <=   4'b0001;
 
     iSMTrBWSTBRDR0  <=   5'b11111;
     iSMTrBWSTBRDR1  <=   5'b11111;
     iSMTrBWSTBRDR2  <=   5'b11111;
     iSMTrBWSTBRDR3  <=   5'b11111;
     iSMTrBWSTBRDR4  <=   5'b11111;
     iSMTrBWSTBRDR5  <=   5'b11111;
     iSMTrBWSTBRDR6  <=   5'b11111;
     iSMTrBWSTBRDR7  <=   5'b11111;

     iSMTrBCR0       <=  22'b1100000011000000100000;
     iSMTrBCR1       <=  22'b1100000011000000000000;
     iSMTrBCR2       <=  22'b1100000011000000010000;
     iSMTrBCR3       <=  22'b1100000011000000000000;
     iSMTrBCR4       <=  22'b1100000011000000100000;
     iSMTrBCR5       <=  22'b1100000011000000100000;
     iSMTrBCR6       <=  22'b1100000011000000010000;
     iSMTrBCR7       <=  22'b1100000011000000000000;

     iSSMCTrBurstWT  <=   9'b111111111;

     iSSMCTrMEMBASE0 <= 15'b000000000000000;
     iSSMCTrMEMBASE1 <= 15'b000000000000000;
     iSSMCTrMEMBASE2 <= 15'b000000000000000;
     iSSMCTrMEMBASE3 <= 15'b000000000000000;
     iSSMCTrMEMBASE4 <= 15'b000000000000000;
     iSSMCTrMEMBASE5 <= 15'b000000000000000;
     iSSMCTrMEMBASE6 <= 15'b000000000000000;
     iSSMCTrMEMBASE7 <= 15'b000000000000000;
 
    end
    else
    begin
    iSMTrBIDCYR0   <= NxtSMTrBIDCYR0;
    iSMTrBIDCYR1   <= NxtSMTrBIDCYR1;
    iSMTrBIDCYR2   <= NxtSMTrBIDCYR2;
    iSMTrBIDCYR3   <= NxtSMTrBIDCYR3;
    iSMTrBIDCYR4   <= NxtSMTrBIDCYR4;
    iSMTrBIDCYR5   <= NxtSMTrBIDCYR5;
    iSMTrBIDCYR6   <= NxtSMTrBIDCYR6;
    iSMTrBIDCYR7   <= NxtSMTrBIDCYR7;

    iSMTrBWSTRDR0  <= NxtSMTrBWSTRDR0;
    iSMTrBWSTRDR1  <= NxtSMTrBWSTRDR1;
    iSMTrBWSTRDR2  <= NxtSMTrBWSTRDR2;
    iSMTrBWSTRDR3  <= NxtSMTrBWSTRDR3;
    iSMTrBWSTRDR4  <= NxtSMTrBWSTRDR4;
    iSMTrBWSTRDR5  <= NxtSMTrBWSTRDR5;
    iSMTrBWSTRDR6  <= NxtSMTrBWSTRDR6;
    iSMTrBWSTRDR7  <= NxtSMTrBWSTRDR7;

    iSMTrBWSTWRR0  <= NxtSMTrBWSTWRR0;
    iSMTrBWSTWRR1  <= NxtSMTrBWSTWRR1;
    iSMTrBWSTWRR2  <= NxtSMTrBWSTWRR2;
    iSMTrBWSTWRR3  <= NxtSMTrBWSTWRR3;
    iSMTrBWSTWRR4  <= NxtSMTrBWSTWRR4;
    iSMTrBWSTWRR5  <= NxtSMTrBWSTWRR5;
    iSMTrBWSTWRR6  <= NxtSMTrBWSTWRR6;
    iSMTrBWSTWRR7  <= NxtSMTrBWSTWRR7;

    iSMTrBWSTOENR0 <= NxtSMTrBWSTOENR0;
    iSMTrBWSTOENR1 <= NxtSMTrBWSTOENR1;
    iSMTrBWSTOENR2 <= NxtSMTrBWSTOENR2;
    iSMTrBWSTOENR3 <= NxtSMTrBWSTOENR3;
    iSMTrBWSTOENR4 <= NxtSMTrBWSTOENR4;
    iSMTrBWSTOENR5 <= NxtSMTrBWSTOENR5;
    iSMTrBWSTOENR6 <= NxtSMTrBWSTOENR6;
    iSMTrBWSTOENR7 <= NxtSMTrBWSTOENR7;
    iSMTrBWSTWENR0 <= NxtSMTrBWSTWENR0;

    iSMTrBWSTWENR1 <= NxtSMTrBWSTWENR1;
    iSMTrBWSTWENR2 <= NxtSMTrBWSTWENR2;
    iSMTrBWSTWENR3 <= NxtSMTrBWSTWENR3;
    iSMTrBWSTWENR4 <= NxtSMTrBWSTWENR4;
    iSMTrBWSTWENR5 <= NxtSMTrBWSTWENR5;
    iSMTrBWSTWENR6 <= NxtSMTrBWSTWENR6;
    iSMTrBWSTWENR7 <= NxtSMTrBWSTWENR7;
    iSMTrBWSTBRDR0 <= NxtSMTrBWSTBRDR0;

    iSMTrBWSTBRDR1 <= NxtSMTrBWSTBRDR1;
    iSMTrBWSTBRDR2 <= NxtSMTrBWSTBRDR2;
    iSMTrBWSTBRDR3 <= NxtSMTrBWSTBRDR3;
    iSMTrBWSTBRDR4 <= NxtSMTrBWSTBRDR4;
    iSMTrBWSTBRDR5 <= NxtSMTrBWSTBRDR5;
    iSMTrBWSTBRDR6 <= NxtSMTrBWSTBRDR6;
    iSMTrBWSTBRDR7 <= NxtSMTrBWSTBRDR7;

    iSMTrBCR0      <= NxtSMTrBCR0;
    iSMTrBCR1      <= NxtSMTrBCR1;
    iSMTrBCR2      <= NxtSMTrBCR2;
    iSMTrBCR3      <= NxtSMTrBCR3;
    iSMTrBCR4      <= NxtSMTrBCR4;
    iSMTrBCR5      <= NxtSMTrBCR5;
    iSMTrBCR6      <= NxtSMTrBCR6;
    iSMTrBCR7      <= NxtSMTrBCR7;

    iSSMCTrBurstWT  <= NxtSSMCTrBurstWT;

    iSSMCTrMEMBASE0 <= NxtSSMCTrMEMBASE0;
    iSSMCTrMEMBASE1 <= NxtSSMCTrMEMBASE1;
    iSSMCTrMEMBASE2 <= NxtSSMCTrMEMBASE2;
    iSSMCTrMEMBASE3 <= NxtSSMCTrMEMBASE3;
    iSSMCTrMEMBASE4 <= NxtSSMCTrMEMBASE4;
    iSSMCTrMEMBASE5 <= NxtSSMCTrMEMBASE5;
    iSSMCTrMEMBASE6 <= NxtSSMCTrMEMBASE6;
    iSSMCTrMEMBASE7 <= NxtSSMCTrMEMBASE7;

     
  end
end // p_RegUpdateSeq

// -----------------------------------------------------------------------------
// Assign local copies of signals to the outputs
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
assign  HRESPTr       = iHRESPTr;
assign  LatchHADDR    = iLatchHADDR;
assign  SMTrBIDCYR0   = iSMTrBIDCYR0;
assign  SMTrBIDCYR1   = iSMTrBIDCYR1;
assign  SMTrBIDCYR2   = iSMTrBIDCYR2;
assign  SMTrBIDCYR3   = iSMTrBIDCYR3;
assign  SMTrBIDCYR4   = iSMTrBIDCYR4;
assign  SMTrBIDCYR5   = iSMTrBIDCYR5;
assign  SMTrBIDCYR6   = iSMTrBIDCYR6;
assign  SMTrBIDCYR7   = iSMTrBIDCYR7;

assign  SMTrBWSTRDR0  = iSMTrBWSTRDR0;
assign  SMTrBWSTRDR1  = iSMTrBWSTRDR1;
assign  SMTrBWSTRDR2  = iSMTrBWSTRDR2;
assign  SMTrBWSTRDR3  = iSMTrBWSTRDR3;
assign  SMTrBWSTRDR4  = iSMTrBWSTRDR4;
assign  SMTrBWSTRDR5  = iSMTrBWSTRDR5;
assign  SMTrBWSTRDR6  = iSMTrBWSTRDR6;
assign  SMTrBWSTRDR7  = iSMTrBWSTRDR7;

assign  SMTrBWSTWRR0  = iSMTrBWSTWRR0;
assign  SMTrBWSTWRR1  = iSMTrBWSTWRR1;
assign  SMTrBWSTWRR2  = iSMTrBWSTWRR2;
assign  SMTrBWSTWRR3  = iSMTrBWSTWRR3;
assign  SMTrBWSTWRR4  = iSMTrBWSTWRR4;
assign  SMTrBWSTWRR5  = iSMTrBWSTWRR5;
assign  SMTrBWSTWRR6  = iSMTrBWSTWRR6;
assign  SMTrBWSTWRR7  = iSMTrBWSTWRR7;

assign  SMTrBWSTOENR0 = iSMTrBWSTOENR0;
assign  SMTrBWSTOENR1 = iSMTrBWSTOENR1;
assign  SMTrBWSTOENR2 = iSMTrBWSTOENR2;
assign  SMTrBWSTOENR3 = iSMTrBWSTOENR3;
assign  SMTrBWSTOENR4 = iSMTrBWSTOENR4;
assign  SMTrBWSTOENR5 = iSMTrBWSTOENR5;
assign  SMTrBWSTOENR6 = iSMTrBWSTOENR6;
assign  SMTrBWSTOENR7 = iSMTrBWSTOENR7;

assign  SMTrBWSTWENR0 = iSMTrBWSTWENR0;
assign  SMTrBWSTWENR1 = iSMTrBWSTWENR1;
assign  SMTrBWSTWENR2 = iSMTrBWSTWENR2;
assign  SMTrBWSTWENR3 = iSMTrBWSTWENR3;
assign  SMTrBWSTWENR4 = iSMTrBWSTWENR4;
assign  SMTrBWSTWENR5 = iSMTrBWSTWENR5;
assign  SMTrBWSTWENR6 = iSMTrBWSTWENR6;
assign  SMTrBWSTWENR7 = iSMTrBWSTWENR7;

assign  SMTrBWSTBRDR0 = iSMTrBWSTBRDR0;
assign  SMTrBWSTBRDR1 = iSMTrBWSTBRDR1;
assign  SMTrBWSTBRDR2 = iSMTrBWSTBRDR2;
assign  SMTrBWSTBRDR3 = iSMTrBWSTBRDR3;
assign  SMTrBWSTBRDR4 = iSMTrBWSTBRDR4;
assign  SMTrBWSTBRDR5 = iSMTrBWSTBRDR5;
assign  SMTrBWSTBRDR6 = iSMTrBWSTBRDR6;
assign  SMTrBWSTBRDR7 = iSMTrBWSTBRDR7;

assign  SMTrBCR0      = iSMTrBCR0;
assign  SMTrBCR1      = iSMTrBCR1;
assign  SMTrBCR2      = iSMTrBCR2;
assign  SMTrBCR3      = iSMTrBCR3;
assign  SMTrBCR4      = iSMTrBCR4;
assign  SMTrBCR5      = iSMTrBCR5;
assign  SMTrBCR6      = iSMTrBCR6;
assign  SMTrBCR7      = iSMTrBCR7;

assign  SSMCTrBurstWT = iSSMCTrBurstWT;

assign  SSMCTrMEMBASE0 = iSSMCTrMEMBASE0;
assign  SSMCTrMEMBASE1 = iSSMCTrMEMBASE1;
assign  SSMCTrMEMBASE2 = iSSMCTrMEMBASE2;
assign  SSMCTrMEMBASE3 = iSSMCTrMEMBASE3;
assign  SSMCTrMEMBASE4 = iSSMCTrMEMBASE4;
assign  SSMCTrMEMBASE5 = iSSMCTrMEMBASE5;
assign  SSMCTrMEMBASE6 = iSSMCTrMEMBASE6;
assign  SSMCTrMEMBASE7 = iSSMCTrMEMBASE7;

endmodule
// --================================== End ==================================--
