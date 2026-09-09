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
// File Name              : SsmcTrickMem.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is the top level SSMC Trickbox Memory model.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcTrickMem (
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
                    HREADYINREG,
                    HWDATA,
                    HWDATAREG,
                    HSELSSMCTrMEM,
                    HSELSSMCTrREG,
                    SMCLK,
                    SMADDRVALID,
                    SMADDR,
                    nSMDATAEN,
                    nSMWEN,
                    nSMOEN,
                    nSMBLS,
                    nSSMTrCS,
                    SSMTrCS,
                    SMMemClkRatio, 

// Inouts
                    SMDATA,

// Outputs
                    HRDATATr,
                    HREADYOUTTr,
                    HRESPTr,
                    nSMBURSTWAIT,
                    nSMIND
                   );

parameter Tclk = 10.56;        // HCLK Period

// Inputs
input         HCLK;         // AHB Clock
input         HRESETn;      // Bus Reset
input  [17:0] HADDR;        // AHB Address Bus
input   [1:0] HTRANS;       // Transfer type
input         HWRITETr;     // AHB Peripheral Write
input         HWRITEREG;    // AHB Mirror register Write
input   [2:0] HSIZE;        // Transfer size
input   [2:0] HBURST;       // Burst Type
input         HREADYINTr;   // Multiplexed version of HREADY outputs
input         HREADYINREG;  // Multiplexed version of HREADY (mirror registers)
input  [31:0] HWDATA;       // AHB Write Data bus
input  [31:0] HWDATAREG;    // Mirrored Register Write Data bus
input         HSELSSMCTrMEM;// AHB Peripheral (TrickMem) Select
input         HSELSSMCTrREG;// AHB Peripheral (Mirror Register) Select
input         SMCLK;        // Clock from SSMS  for synchronous memory accesses
input         SMADDRVALID;  // Address valid signal
input  [25:0] SMADDR;       // Memory Address Bus
input   [3:0] nSMDATAEN;    // Memory Bus Enable
input         nSMWEN;       // Write Enable for the external Memory
                            // bank
input         nSMOEN;       // Output Enable for the external Memory
                            // bank
input   [3:0] nSMBLS;       // Byte Enables for the external Memory
                            // bank
input   [7:0] nSSMTrCS;     // The CS status of all the eight banks
                            // connected with the SSMC
input   [7:0] SSMTrCS;      // The CS status of all the eight banks
                            // connected with the SSMC
input   [1:0] SMMemClkRatio;// Clock Ratio    

// Inouts
inout  [31:0] SMDATA;       // Memory Data Bus

// Outputs
output [31:0] HRDATATr;     // AHB Read Data bus
output        HREADYOUTTr;  // Slave HREADY output
output  [1:0] HRESPTr;      // Slave response
output  [7:0] nSMBURSTWAIT; // External Burstwait
output        nSMIND;       // Address limit indicator

// Inputs
  wire        HCLK;         // AHB Clock
  wire        HRESETn;      // Bus Reset
  wire [17:0] HADDR;        // AHB Address Bus
  wire  [1:0] HTRANS;       // Transfer type
  wire        HWRITETr;     // AHB Peripheral Write
  wire        HWRITEREG;    // AHB Mirror register Write
  wire  [2:0] HSIZE;        // Transfer size
  wire  [2:0] HBURST;       // Burst Type
  wire        HREADYINTr;   // Multiplexed version of HREADY outputs
  wire        HREADYINREG;  // Multiplexed version of HREADY (mirror registers)
  wire [31:0] HWDATA;       // AHB Write Data bus
  wire [31:0] HWDATAREG;    // Mirrored Register Write Data bus    
  wire        HSELSSMCTrMEM;// AHB Peripheral (TrickMem) Select
  wire        HSELSSMCTrREG;// AHB Peripheral (Mirror Register) Select
  wire        SMCLK;        // Clock from SSMS  for synchronous memory accesses
  wire        SMADDRVALID;  // Address valid signal
  wire [25:0] SMADDR;       // Memory Address Bus
  wire  [3:0] nSMDATAEN;    // Memory Bus Enable
  wire        nSMWEN;       // Write Enable for the external Memory
                            // bank
  wire        nSMOEN;       // Output Enable for the external Memory
                            // bank
  wire  [3:0] nSMBLS;       // Byte Enables for the external Memory
                            // bank
  wire  [7:0] nSSMTrCS;     // The CS status of all the eight banks
                            // connected with the SSMC
  wire  [7:0] SSMTrCS;      // The CS status of all the eight banks
  wire  [1:0] SMMemClkRatio;// Clock Ratio


// Inouts
  wire [31:0] SMDATA;       // Memory Data Bus



// Outputs
  wire [31:0] HRDATATr;     // AHB Read Data bus
  wire        HREADYOUTTr;  // Slave HREADY output
  wire  [1:0] HRESPTr;      // Slave response
  wire  [7:0] nSMBURSTWAIT; // External Burstwait
  wire        nSMIND;       // Address limit indicator

// -----------------------------------------------------------------------------
//
//                                 SmcTrickMem
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the SMC Trickbox Memory Model. This block
// instantiates the following sub-blocks:
//
// 1. SsmcTrMemAhbifReg - AHB Interface and Register Block
// 2. SsmcTrMemory      - Memory Read/Write Control and Timing checks
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        SMFBCLK;
// Feedback clock

wire        iSMMemCLK;
// Memory Clock

wire  [7:0] inSSMTrCS;
// Internal version of nSSCMTrCS lines

wire  [7:0] iSSMTrCS;
// Internal version of SSMCTrCS lines
 
wire [17:0] LatchHADDR;
// Latched AHB Address. This is used when the memory is accessed via AHB

wire        SSMCTrMEMARRAY0Wr;
// Memory Write Enable

wire        SSMCTrMEMARRAY1Wr;
// Memory Write Enable

wire        SSMCTrMEMARRAY2Wr;
// Memory Write Enable

wire        SSMCTrMEMARRAY3Wr;
// Memory Write Enable

wire        SSMCTrMEMARRAY4Wr;
// Memory Write Enable

wire        SSMCTrMEMARRAY5Wr;
// Memory Write Enable

wire        SSMCTrMEMARRAY6Wr;
// Memory Write Enable

wire        SSMCTrMEMARRAY7Wr;
// Memory Write Enable

wire  [8:0] SSMCTrBurstWt;
// External Burst wait time

wire  [3:0] SMTrBIDCYR0;
// Memory data bus turn around time count for bank 0

wire  [3:0] SMTrBIDCYR1;
// Memory data bus turn around time count for bank 1

wire  [3:0] SMTrBIDCYR2;
// Memory data bus turn around time count for bank 2

wire  [3:0] SMTrBIDCYR3;
// Memory data bus turn around time count for bank 3

wire  [3:0] SMTrBIDCYR4;
// Memory data bus turn around time count for bank 4

wire  [3:0] SMTrBIDCYR5;
// Memory data bus turn around time count for bank 5

wire  [3:0] SMTrBIDCYR6;
// Memory data bus turn around time count for bank 6

wire  [3:0] SMTrBIDCYR7;
// Memory data bus turn around time count for bank 7

wire  [4:0] SMTrBWSTRDR0;
// Read initial access time for bank 0

wire  [4:0] SMTrBWSTRDR1;
// Read initial access time for bank 1

wire  [4:0] SMTrBWSTRDR2;
// Read initial access time for bank 2

wire  [4:0] SMTrBWSTRDR3;
// Read initial access time for bank 3

wire  [4:0] SMTrBWSTRDR4;
// Read initial access time for bank 4

wire  [4:0] SMTrBWSTRDR5;
// Read initial access time for bank 5

wire  [4:0] SMTrBWSTRDR6;
// Read initial access time for bank 6

wire  [4:0] SMTrBWSTRDR7;
// Read initial access time for bank 7

wire  [4:0] SMTrBWSTWRR0;
// Write eccess time for bank 0

wire  [4:0] SMTrBWSTWRR1;
// Write eccess time for bank 1

wire  [4:0] SMTrBWSTWRR2;
// Write eccess time for bank 2

wire  [4:0] SMTrBWSTWRR3;
// Write eccess time for bank 3

wire  [4:0] SMTrBWSTWRR4;
// Write eccess time for bank 4

wire  [4:0] SMTrBWSTWRR5;
// Write eccess time for bank 5

wire  [4:0] SMTrBWSTWRR6;
// Write eccess time for bank 6

wire  [4:0] SMTrBWSTWRR7;
// Write eccess time for bank 7

wire  [3:0] SMTrBWSTOENR0;
// Chip Select to Output Enable delay count for bank 0

wire  [3:0] SMTrBWSTOENR1;
// Chip Select to Output Enable delay count for bank 1

wire  [3:0] SMTrBWSTOENR2;
// Chip Select to Output Enable delay count for bank 2

wire  [3:0] SMTrBWSTOENR3;
// Chip Select to Output Enable delay count for bank 3

wire  [3:0] SMTrBWSTOENR4;
// Chip Select to Output Enable delay count for bank 4

wire  [3:0] SMTrBWSTOENR5;
// Chip Select to Output Enable delay count for bank 5

wire  [3:0] SMTrBWSTOENR6;
// Chip Select to Output Enable delay count for bank 6

wire  [3:0] SMTrBWSTOENR7;
// Chip Select to Output Enable delay count for bank 7

wire  [3:0] SMTrBWSTWENR0;
// Chip Select to Write Enable delay count for bank 0

wire  [3:0] SMTrBWSTWENR1;
// Chip Select to Write Enable delay count for bank 1

wire  [3:0] SMTrBWSTWENR2;
// Chip Select to Write Enable delay count for bank 2

wire  [3:0] SMTrBWSTWENR3;
// Chip Select to Write Enable delay count for bank 3

wire  [3:0] SMTrBWSTWENR4;
// Chip Select to Write Enable delay count for bank 4

wire  [3:0] SMTrBWSTWENR5;
// Chip Select to Write Enable delay count for bank 5

wire  [3:0] SMTrBWSTWENR6;
// Chip Select to Write Enable delay count for bank 6

wire  [3:0] SMTrBWSTWENR7;
// Chip Select to Write Enable delay count for bank 7

wire  [4:0] SMTrBWSTBRDR0;
// Burst Access time after first access for bank 0

wire  [4:0] SMTrBWSTBRDR1;
// Burst Access time after first access for bank 1

wire  [4:0] SMTrBWSTBRDR2;
// Burst Access time after first access for bank 2

wire  [4:0] SMTrBWSTBRDR3;
// Burst Access time after first access for bank 3

wire  [4:0] SMTrBWSTBRDR4;
// Burst Access time after first access for bank 4

wire  [4:0] SMTrBWSTBRDR5;
// Burst Access time after first access for bank 5

wire  [4:0] SMTrBWSTBRDR6;
// Burst Access time after first access for bank 6

wire  [4:0] SMTrBWSTBRDR7;
// Burst Access time after first access for bank 7

wire [21:0] SMTrBCR0;
// Memory type specifier for bank 0

wire [21:0] SMTrBCR1;
// Memory type specifier for bank 1

wire [21:0] SMTrBCR2;
// Memory type specifier for bank 2

wire [21:0] SMTrBCR3;
// Memory type specifier for bank 3

wire [21:0] SMTrBCR4;
// Memory type specifier for bank 5

wire [21:0] SMTrBCR5;
// Memory type specifier for bank 5

wire [21:0] SMTrBCR6;
// Memory type specifier for bank 6

wire [21:0] SMTrBCR7;
// Memory type specifier for bank 7

wire [14:0] SSMCTrMEMBASE0;
// Memory Base Address for bank 0;

wire [14:0] SSMCTrMEMBASE1;
// Memory Base Address for bank 1

wire [14:0] SSMCTrMEMBASE2;
// Memory Base Address for bank 2

wire [14:0] SSMCTrMEMBASE3;
// Memory Base Address for bank 3

wire [14:0] SSMCTrMEMBASE4;
// Memory Base Address for bank 4

wire [14:0] SSMCTrMEMBASE5;
// Memory Base Address for bank 5

wire [14:0] SSMCTrMEMBASE6;
// Memory Base Address for bank 5

wire [14:0] SSMCTrMEMBASE7;
// Memory Base Address for bank 7

wire [10:0] LatchSMADDR;
// Latched Memory Address Bus

wire  [7:0] AhbRdDatab0;
// BYTE0 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab1;
// BYTE0 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab2;
// BYTE0 of 32 bits AHB Read Data

wire  [7:0] AhbRdDatab3;
// BYTE0 of 32 bits AHB Read Data

wire  [7:0] MemRdDatab0;
// BYTE0 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab1;
// BYTE0 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab2;
// BYTE0 of 32 bits Memory Read Data

wire  [7:0] MemRdDatab3;
// BYTE0 of 32 bits Memory Read Data

wire  [7:0] MemWrDatab0;
// BYTE0 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab1;
// BYTE0 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab2;
// BYTE0 of 32 bits Memory Write Data

wire  [7:0] MemWrDatab3;
// BYTE0 of 32 bits Memory Write Data

wire [31:0] MemRdDataDW;
// 32 Bits Memory Read Data (Concatenation of MemRdDatab0-3)

wire [31:0] AhbRdDataDW0;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire [31:0] AhbRdDataDW1;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire [31:0] AhbRdDataDW2;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire [31:0] AhbRdDataDW3;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire [31:0] AhbRdDataDW4;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire [31:0] AhbRdDataDW5;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire [31:0] AhbRdDataDW6;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire [31:0] AhbRdDataDW7;
// 32 Bits AHB Read Data (Concatenation of AhbRdDatab0-3)

wire        RBLE;
// Read Byte Lane Enable signal

//wire        nSMBURSTWAIT0;
// burst wait signal from memory 0

//wire        nSMBURSTWAIT1;
// burst wait signal from memory 1

//wire        nSMBURSTWAIT2;
// burst wait signal from memory 2

//wire        nSMBURSTWAIT3;
// burst wait signal from memory 3

//wire        nSMBURSTWAIT4;
// burst wait signal from memory 4

//wire        nSMBURSTWAIT5;
// burst wait signal from memory 5

//wire        nSMBURSTWAIT6;
// burst wait signal from memory 6

//wire        nSMBURSTWAIT7;
// burst wait signal from memory 7

wire        SMTrIND0;
// Address limit indicator for bank 0
 
wire        SMTrIND1;
// Address limit indicator for bank 1
 
wire        SMTrIND2;
// Address limit indicator for bank 2
 
wire        SMTrIND3;
// Address limit indicator for bank 3
 
wire        SMTrIND4;
// Address limit indicator for bank 4
 
wire        SMTrIND5;
// Address limit indicator for bank 5
 
wire        SMTrIND6;
// Address limit indicator for bank 6
 
wire        SMTrIND7;
// Address limit indicator for bank 7

 
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
//reg   [3:0] TrnSMBLS;
// Byte Lane Select signal whose value depend on RBLE

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

//assign  nSMBURSTWAIT = nSMBURSTWAIT0 && nSMBURSTWAIT1 && nSMBURSTWAIT2 &&
//                       nSMBURSTWAIT3 && nSMBURSTWAIT4 && nSMBURSTWAIT5 &&
//                       nSMBURSTWAIT6 && nSMBURSTWAIT7; 

assign  nSMIND       = SMTrIND0 && SMTrIND1 && SMTrIND2 && SMTrIND3 &&
                       SMTrIND4 && SMTrIND5 && SMTrIND6 && SMTrIND7;

assign  #0.001 inSSMTrCS = nSSMTrCS;
assign  #0.001 iSSMTrCS  = SSMTrCS;

// -----------------------------------------------------------------------------
// Instantiation of the SMC TrickMem AHB interface
// -----------------------------------------------------------------------------
SsmcTrMemAhbIfReg uSsmcTrMemAhbIfReg  (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HADDR            (HADDR),
                    .HTRANS           (HTRANS),
                    .HWRITETr         (HWRITETr),
                    .HWRITEREG        (HWRITEREG),
                    .HSIZE            (HSIZE),
                    .HBURST           (HBURST),
                    .HREADYINTr       (HREADYINTr),
                    .HWDATA           (HWDATA),
                    .HREADYINREG      (HREADYINREG),
                    .HWDATAREG        (HWDATAREG),
                    .HSELSSMCTrMEM    (HSELSSMCTrMEM),
                    .HSELSSMCTrREG    (HSELSSMCTrREG),

                    .AhbRdDataDW0     (AhbRdDataDW0),
                    .AhbRdDataDW1     (AhbRdDataDW1),
                    .AhbRdDataDW2     (AhbRdDataDW2),
                    .AhbRdDataDW3     (AhbRdDataDW3),
                    .AhbRdDataDW4     (AhbRdDataDW4),
                    .AhbRdDataDW5     (AhbRdDataDW5),
                    .AhbRdDataDW6     (AhbRdDataDW6),
                    .AhbRdDataDW7     (AhbRdDataDW7),

                    .HRDATATr         (HRDATATr),
                    .HREADYOUTTr      (HREADYOUTTr),
                    .HRESPTr          (HRESPTr),

                    .SSMCTrMEMARRAY0Wr     (SSMCTrMEMARRAY0Wr),
                    .SSMCTrMEMARRAY1Wr     (SSMCTrMEMARRAY1Wr),
                    .SSMCTrMEMARRAY2Wr     (SSMCTrMEMARRAY2Wr),
                    .SSMCTrMEMARRAY3Wr     (SSMCTrMEMARRAY3Wr),
                    .SSMCTrMEMARRAY4Wr     (SSMCTrMEMARRAY4Wr),
                    .SSMCTrMEMARRAY5Wr     (SSMCTrMEMARRAY5Wr),
                    .SSMCTrMEMARRAY6Wr     (SSMCTrMEMARRAY6Wr),
                    .SSMCTrMEMARRAY7Wr     (SSMCTrMEMARRAY7Wr),

                    .LatchHADDR       (LatchHADDR),
                    .SSMCTrBurstWT    (SSMCTrBurstWt),

                    .SSMCTrMEMBASE0   (SSMCTrMEMBASE0),
                    .SSMCTrMEMBASE1   (SSMCTrMEMBASE1),
                    .SSMCTrMEMBASE2   (SSMCTrMEMBASE2),
                    .SSMCTrMEMBASE3   (SSMCTrMEMBASE3),
                    .SSMCTrMEMBASE4   (SSMCTrMEMBASE4),
                    .SSMCTrMEMBASE5   (SSMCTrMEMBASE5),
                    .SSMCTrMEMBASE6   (SSMCTrMEMBASE6),
                    .SSMCTrMEMBASE7   (SSMCTrMEMBASE7),

                    .SMTrBIDCYR0      (SMTrBIDCYR0),
                    .SMTrBIDCYR1      (SMTrBIDCYR1),
                    .SMTrBIDCYR2      (SMTrBIDCYR2),
                    .SMTrBIDCYR3      (SMTrBIDCYR3),
                    .SMTrBIDCYR4      (SMTrBIDCYR4),
                    .SMTrBIDCYR5      (SMTrBIDCYR5),
                    .SMTrBIDCYR6      (SMTrBIDCYR6),
                    .SMTrBIDCYR7      (SMTrBIDCYR7),

                    .SMTrBWSTRDR0     (SMTrBWSTRDR0),
                    .SMTrBWSTRDR1     (SMTrBWSTRDR1),
                    .SMTrBWSTRDR2     (SMTrBWSTRDR2),
                    .SMTrBWSTRDR3     (SMTrBWSTRDR3),
                    .SMTrBWSTRDR4     (SMTrBWSTRDR4),
                    .SMTrBWSTRDR5     (SMTrBWSTRDR5),
                    .SMTrBWSTRDR6     (SMTrBWSTRDR6),
                    .SMTrBWSTRDR7     (SMTrBWSTRDR7),

                    .SMTrBWSTWRR0     (SMTrBWSTWRR0),
                    .SMTrBWSTWRR1     (SMTrBWSTWRR1),
                    .SMTrBWSTWRR2     (SMTrBWSTWRR2),
                    .SMTrBWSTWRR3     (SMTrBWSTWRR3),
                    .SMTrBWSTWRR4     (SMTrBWSTWRR4),
                    .SMTrBWSTWRR5     (SMTrBWSTWRR5),
                    .SMTrBWSTWRR6     (SMTrBWSTWRR6),
                    .SMTrBWSTWRR7     (SMTrBWSTWRR7),

                    .SMTrBWSTOENR0    (SMTrBWSTOENR0),
                    .SMTrBWSTOENR1    (SMTrBWSTOENR1),
                    .SMTrBWSTOENR2    (SMTrBWSTOENR2),
                    .SMTrBWSTOENR3    (SMTrBWSTOENR3),
                    .SMTrBWSTOENR4    (SMTrBWSTOENR4),
                    .SMTrBWSTOENR5    (SMTrBWSTOENR5),
                    .SMTrBWSTOENR6    (SMTrBWSTOENR6),
                    .SMTrBWSTOENR7    (SMTrBWSTOENR7),

                    .SMTrBWSTWENR0    (SMTrBWSTWENR0),
                    .SMTrBWSTWENR1    (SMTrBWSTWENR1),
                    .SMTrBWSTWENR2    (SMTrBWSTWENR2),
                    .SMTrBWSTWENR3    (SMTrBWSTWENR3),
                    .SMTrBWSTWENR4    (SMTrBWSTWENR4),
                    .SMTrBWSTWENR5    (SMTrBWSTWENR5),
                    .SMTrBWSTWENR6    (SMTrBWSTWENR6),
                    .SMTrBWSTWENR7    (SMTrBWSTWENR7),

                    .SMTrBWSTBRDR0    (SMTrBWSTBRDR0),
                    .SMTrBWSTBRDR1    (SMTrBWSTBRDR1),
                    .SMTrBWSTBRDR2    (SMTrBWSTBRDR2),
                    .SMTrBWSTBRDR3    (SMTrBWSTBRDR3),
                    .SMTrBWSTBRDR4    (SMTrBWSTBRDR4),
                    .SMTrBWSTBRDR5    (SMTrBWSTBRDR5),
                    .SMTrBWSTBRDR6    (SMTrBWSTBRDR6),
                    .SMTrBWSTBRDR7    (SMTrBWSTBRDR7),

                    .SMTrBCR0         (SMTrBCR0),
                    .SMTrBCR1         (SMTrBCR1),
                    .SMTrBCR2         (SMTrBCR2),
                    .SMTrBCR3         (SMTrBCR3),
                    .SMTrBCR4         (SMTrBCR4),
                    .SMTrBCR5         (SMTrBCR5),
                    .SMTrBCR6         (SMTrBCR6),
                    .SMTrBCR7         (SMTrBCR7)

          //          .SMMemCLKRatio    (SMMemClkRatio) 

                    );

// -----------------------------------------------------------------------------
// 8 Instantiation of the SMC TrickMem Read/Write Control Block for each bank
// -----------------------------------------------------------------------------
defparam u0SsmcTrMemory.Tclk = Tclk;
SsmcTrMemory u0SsmcTrMemory           (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .LatchHADDR       (LatchHADDR),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SSMTrBankCS      (iSSMTrCS[0]),
                    .nSSMTrBankCS     (inSSMTrCS[0]),
                    .SSMTrCS          (iSSMTrCS),
                    .nSSMTrCS         (inSSMTrCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCLK            (SMCLK),
                    .SMADDRVALID      (SMADDRVALID),
                    .SSMCTrMEMARRAYWr (SSMCTrMEMARRAY0Wr),
                    .SSMCTrBurstWt    (SSMCTrBurstWt),
                    .SSMCTrMEMBASE    (SSMCTrMEMBASE0),
                    .SMTrBIDCYR       (SMTrBIDCYR0),
                    .SMTrBWSTRDR      (SMTrBWSTRDR0),
                    .SMTrBWSTWRR      (SMTrBWSTWRR0),
                    .SMTrBWSTOENR     (SMTrBWSTOENR0),
                    .SMTrBWSTWENR     (SMTrBWSTWENR0),
                    .SMTrBWSTBRDR     (SMTrBWSTBRDR0),
                    .SMTrBCR          (SMTrBCR0),
                    .SMMemClkRatio    (SMMemClkRatio), 

                    .SMDATA           (SMDATA),

                    .AhbRdDataDW      (AhbRdDataDW0),
                    .nSMBURSTWAIT     (nSMBURSTWAIT[0]),
                    .SMTrIND          (SMTrIND0),   
                    .SMFBCLK          (SMFBCLK)
                    );

defparam u1SsmcTrMemory.Tclk = Tclk;
SsmcTrMemory u1SsmcTrMemory           (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .LatchHADDR       (LatchHADDR),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SSMTrBankCS      (iSSMTrCS[1]),
                    .nSSMTrBankCS     (inSSMTrCS[1]),
                    .SSMTrCS          (iSSMTrCS),
                    .nSSMTrCS         (inSSMTrCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCLK            (SMCLK),
                    .SMADDRVALID      (SMADDRVALID),
                    .SSMCTrMEMARRAYWr (SSMCTrMEMARRAY1Wr),
                    .SSMCTrBurstWt    (SSMCTrBurstWt),
                    .SSMCTrMEMBASE    (SSMCTrMEMBASE1),
                    .SMTrBIDCYR       (SMTrBIDCYR1),
                    .SMTrBWSTRDR      (SMTrBWSTRDR1),
                    .SMTrBWSTWRR      (SMTrBWSTWRR1),
                    .SMTrBWSTOENR     (SMTrBWSTOENR1),
                    .SMTrBWSTWENR     (SMTrBWSTWENR1),
                    .SMTrBWSTBRDR     (SMTrBWSTBRDR1),
                    .SMTrBCR          (SMTrBCR1),
                    .SMMemClkRatio    (SMMemClkRatio), 

                    .SMDATA           (SMDATA),

                    .AhbRdDataDW      (AhbRdDataDW1),
                    .nSMBURSTWAIT     (nSMBURSTWAIT[1]),
                    .SMTrIND          (SMTrIND1),   
                    .SMFBCLK          (SMFBCLK)
                    );

defparam u2SsmcTrMemory.Tclk = Tclk;
SsmcTrMemory u2SsmcTrMemory           (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .LatchHADDR       (LatchHADDR),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SSMTrBankCS      (iSSMTrCS[2]),
                    .nSSMTrBankCS     (inSSMTrCS[2]),
                    .SSMTrCS          (iSSMTrCS),
                    .nSSMTrCS         (inSSMTrCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCLK            (SMCLK),
                    .SMADDRVALID      (SMADDRVALID),
                    .SSMCTrMEMARRAYWr (SSMCTrMEMARRAY2Wr),
                    .SSMCTrBurstWt    (SSMCTrBurstWt),
                    .SSMCTrMEMBASE    (SSMCTrMEMBASE2),
                    .SMTrBIDCYR       (SMTrBIDCYR2),
                    .SMTrBWSTRDR      (SMTrBWSTRDR2),
                    .SMTrBWSTWRR      (SMTrBWSTWRR2),
                    .SMTrBWSTOENR     (SMTrBWSTOENR2),
                    .SMTrBWSTWENR     (SMTrBWSTWENR2),
                    .SMTrBWSTBRDR     (SMTrBWSTBRDR2),
                    .SMTrBCR          (SMTrBCR2),
                    .SMMemClkRatio    (SMMemClkRatio),

                    .SMDATA           (SMDATA),

                    .AhbRdDataDW      (AhbRdDataDW2),
                    .nSMBURSTWAIT     (nSMBURSTWAIT[2]),
                    .SMTrIND          (SMTrIND2),
                    .SMFBCLK          (SMFBCLK)
                    );

defparam u3SsmcTrMemory.Tclk = Tclk;
SsmcTrMemory u3SsmcTrMemory           (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .LatchHADDR       (LatchHADDR),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SSMTrBankCS      (iSSMTrCS[3]),
                    .nSSMTrBankCS     (inSSMTrCS[3]),
                    .SSMTrCS          (iSSMTrCS),
                    .nSSMTrCS         (inSSMTrCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCLK            (SMCLK),
                    .SMADDRVALID      (SMADDRVALID),
                    .SSMCTrMEMARRAYWr (SSMCTrMEMARRAY3Wr),
                    .SSMCTrBurstWt    (SSMCTrBurstWt),
                    .SSMCTrMEMBASE    (SSMCTrMEMBASE3),
                    .SMTrBIDCYR       (SMTrBIDCYR3),
                    .SMTrBWSTRDR      (SMTrBWSTRDR3),
                    .SMTrBWSTWRR      (SMTrBWSTWRR3),
                    .SMTrBWSTOENR     (SMTrBWSTOENR3),
                    .SMTrBWSTWENR     (SMTrBWSTWENR3),
                    .SMTrBWSTBRDR     (SMTrBWSTBRDR3),
                    .SMTrBCR          (SMTrBCR3),
                    .SMMemClkRatio    (SMMemClkRatio),

                    .SMDATA           (SMDATA),

                    .AhbRdDataDW      (AhbRdDataDW3),
                    .nSMBURSTWAIT     (nSMBURSTWAIT[3]),
                    .SMTrIND          (SMTrIND3),
                    .SMFBCLK          (SMFBCLK)
                    );

defparam u4SsmcTrMemory.Tclk = Tclk;
SsmcTrMemory u4SsmcTrMemory           (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .LatchHADDR       (LatchHADDR),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SSMTrBankCS      (iSSMTrCS[4]),
                    .nSSMTrBankCS     (inSSMTrCS[4]),
                    .SSMTrCS          (iSSMTrCS),
                    .nSSMTrCS         (inSSMTrCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCLK            (SMCLK),
                    .SMADDRVALID      (SMADDRVALID),
                    .SSMCTrMEMARRAYWr (SSMCTrMEMARRAY4Wr),
                    .SSMCTrBurstWt    (SSMCTrBurstWt),
                    .SSMCTrMEMBASE    (SSMCTrMEMBASE4),
                    .SMTrBIDCYR       (SMTrBIDCYR4),
                    .SMTrBWSTRDR      (SMTrBWSTRDR4),
                    .SMTrBWSTWRR      (SMTrBWSTWRR4),
                    .SMTrBWSTOENR     (SMTrBWSTOENR4),
                    .SMTrBWSTWENR     (SMTrBWSTWENR4),
                    .SMTrBWSTBRDR     (SMTrBWSTBRDR4),
                    .SMTrBCR          (SMTrBCR4),
                    .SMMemClkRatio    (SMMemClkRatio),   

                    .SMDATA           (SMDATA),

                    .AhbRdDataDW      (AhbRdDataDW4),
                    .nSMBURSTWAIT     (nSMBURSTWAIT[4]),
                    .SMTrIND          (SMTrIND4), 
                    .SMFBCLK          (SMFBCLK)
                    );

defparam u5SsmcTrMemory.Tclk = Tclk;
SsmcTrMemory u5SsmcTrMemory           (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .LatchHADDR       (LatchHADDR),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SSMTrBankCS      (iSSMTrCS[5]),
                    .nSSMTrBankCS     (inSSMTrCS[5]),
                    .SSMTrCS          (iSSMTrCS),
                    .nSSMTrCS         (inSSMTrCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCLK            (SMCLK),
                    .SMADDRVALID      (SMADDRVALID),
                    .SSMCTrMEMARRAYWr (SSMCTrMEMARRAY5Wr),
                    .SSMCTrBurstWt    (SSMCTrBurstWt),
                    .SSMCTrMEMBASE    (SSMCTrMEMBASE5),
                    .SMTrBIDCYR       (SMTrBIDCYR5),
                    .SMTrBWSTRDR      (SMTrBWSTRDR5),
                    .SMTrBWSTWRR      (SMTrBWSTWRR5),
                    .SMTrBWSTOENR     (SMTrBWSTOENR5),
                    .SMTrBWSTWENR     (SMTrBWSTWENR5),
                    .SMTrBWSTBRDR     (SMTrBWSTBRDR5),
                    .SMTrBCR          (SMTrBCR5),
                    .SMMemClkRatio    (SMMemClkRatio),

                    .SMDATA           (SMDATA),

                    .AhbRdDataDW      (AhbRdDataDW5),
                    .nSMBURSTWAIT     (nSMBURSTWAIT[5]),
                    .SMTrIND          (SMTrIND5), 
                    .SMFBCLK          (SMFBCLK)
                    );

defparam u6SsmcTrMemory.Tclk = Tclk;
SsmcTrMemory u6SsmcTrMemory           (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .LatchHADDR       (LatchHADDR),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SSMTrBankCS      (iSSMTrCS[6]),
                    .nSSMTrBankCS     (inSSMTrCS[6]),
                    .SSMTrCS          (iSSMTrCS),
                    .nSSMTrCS         (inSSMTrCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCLK            (SMCLK),
                    .SMADDRVALID      (SMADDRVALID),
                    .SSMCTrMEMARRAYWr (SSMCTrMEMARRAY6Wr),
                    .SSMCTrBurstWt    (SSMCTrBurstWt),
                    .SSMCTrMEMBASE    (SSMCTrMEMBASE6),
                    .SMTrBIDCYR       (SMTrBIDCYR6),
                    .SMTrBWSTRDR      (SMTrBWSTRDR6),
                    .SMTrBWSTWRR      (SMTrBWSTWRR6),
                    .SMTrBWSTOENR     (SMTrBWSTOENR6),
                    .SMTrBWSTWENR     (SMTrBWSTWENR6),
                    .SMTrBWSTBRDR     (SMTrBWSTBRDR6),
                    .SMTrBCR          (SMTrBCR6),
                    .SMMemClkRatio    (SMMemClkRatio),   

                    .SMDATA           (SMDATA),

                    .AhbRdDataDW      (AhbRdDataDW6),
                    .nSMBURSTWAIT     (nSMBURSTWAIT[6]),
                    .SMTrIND          (SMTrIND6),
                    .SMFBCLK          (SMFBCLK)
                    );

defparam u7SsmcTrMemory.Tclk = Tclk;
SsmcTrMemory u7SsmcTrMemory           (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .LatchHADDR       (LatchHADDR),
                    .SMADDR           (SMADDR),
                    .nSMDATAEN        (nSMDATAEN),
                    .SSMTrBankCS      (iSSMTrCS[7]),
                    .nSSMTrBankCS     (inSSMTrCS[7]),
                    .SSMTrCS          (iSSMTrCS),
                    .nSSMTrCS         (inSSMTrCS),
                    .nSMWEN           (nSMWEN),
                    .nSMBLS           (nSMBLS),
                    .nSMOEN           (nSMOEN),
                    .SMCLK            (SMCLK),
                    .SMADDRVALID      (SMADDRVALID),
                    .SSMCTrMEMARRAYWr (SSMCTrMEMARRAY7Wr),
                    .SSMCTrBurstWt    (SSMCTrBurstWt),
                    .SSMCTrMEMBASE    (SSMCTrMEMBASE7),
                    .SMTrBIDCYR       (SMTrBIDCYR7),
                    .SMTrBWSTRDR      (SMTrBWSTRDR7),
                    .SMTrBWSTWRR      (SMTrBWSTWRR7),
                    .SMTrBWSTOENR     (SMTrBWSTOENR7),
                    .SMTrBWSTWENR     (SMTrBWSTWENR7),
                    .SMTrBWSTBRDR     (SMTrBWSTBRDR7),
                    .SMTrBCR          (SMTrBCR7),
                    .SMMemClkRatio    (SMMemClkRatio),

                    .SMDATA           (SMDATA),

                    .AhbRdDataDW      (AhbRdDataDW7),
                    .nSMBURSTWAIT     (nSMBURSTWAIT[7]),
                    .SMTrIND          (SMTrIND7),      
                    .SMFBCLK          (SMFBCLK)
                    );
endmodule
// --================================== End ==================================--
