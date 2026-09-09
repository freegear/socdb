// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcAhbSlvRegIf.v.rca
// File Revision          : 1.16
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Provides CPU access to the SSMC Controller control and timing
//           registers.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SsmcParams.v"

// -----------------------------------------------------------------------------

module SsmcAhbSlvRegIf (
// Inputs
                        HCLK,
                        HRESETn,
                        HADDRREG,
                        HTRANSREG,
                        HWRITEREG,
                        HSIZEREG,
                        HWDATAREG,
                        HSELREG,
                        HREADYINREG,
                        SMMWCS7,
                        SMBLS7POL,
                        Revision,
                        WaitStatus,
                        WaitToutErr,
                        HSELSMC,
                        HTRANSSMC,
                        HREADYINSMC,
                        HselMemBuf1,
                        SMBUSREQExt,
                        SMTICBUSREQExt,
                        SMMEMCLKRATIO,
                        SMBIGENDIAN,
                        SMEXTBUSMUX,
                        SMTICBUSGNTEBI,
                        SMBUSGNTEBI,
                        SMBUSBACKOFFEBI,
// Outputs
                        HRDATAREG,
                        HREADYOUTREG,
                        HRESPREG,
                        SMTICBUSGNTExt,
                        SMBUSGNTExt,
                        SmBusBackOffExt,
                        BUSMUXEXT,
                        BIGENDIAN,
                        SMBUSREQEBI,
                        SMTICBUSREQEBI,
                        ClockRatio,
                        MemClkRegTogl,
                        MW1,
                        SMBLSPol1,
                        BMRead1,
                        BIWriteEn1,
                        BIReadEn1,
                        WrapRead,
                        BMWrite1,
                        SyncEnRead1,
                        SyncEnWrite1,
                        BurstLenRead1,
                        BurstLenWrite1,
                        AddrValidReadEn1,
                        AddrValWriteEn1,
                        SMClockEn,
                        WP1,
                        RBLE1,
                        WaitEn1,
                        WaitPol1,
                        WSTRD1,
                        WSTBRD1,
                        WSTWR1,
                        WSTOEN1,
                        WSTWEN1,
                        IDCYC1
                       );

// Inputs
input         HCLK;             // AHB Bus Clock
input         HRESETn;          // AHB system level Reset
input  [11:2] HADDRREG;         // The address bus input from AHB for Register
                                // accesses
input   [1:0] HTRANSREG;        // Indicates current transfer type for
                                // Register accesses.
input         HWRITEREG;        // Indicates direction of transfer (R/W) for
                                // Register accesses
input   [2:0] HSIZEREG;         // Transfer size indication for Register
                                // accesses
input  [31:0] HWDATAREG;        // Write data bus input from AHB for Register
                                // accesses
input         HSELREG;          // Select signal for Register transfer
input         HREADYINREG;      // Transfer completion input signal
input   [1:0] SMMWCS7;          // Static Input pins used to program the
                                // memory width bit field of Bank7 register
input         SMBLS7POL;        // Static Input pin used to program
                                // the polarity of SMBLS bit field
                                // of Bank7 register
input   [3:0] Revision;         // Revision number from SmcRevAnd
input         WaitStatus;       // Wait status for enabled transfer
input         WaitToutErr;      // Waited access Error indication
input         HTRANSSMC;        // Indicates current transfer type for Memory
                                // accesses
input   [7:0] HSELSMC;          // Select signal for Memory transfer to
                                // SSMCCore. One select line for each Memory
                                // Bank
input         HREADYINSMC;      // Transfer completion input signal
input   [7:0] HselMemBuf1;      // 1st level registered HSELSMC
input         SMBUSREQExt;      // Request EBI for Memory Transfer.
input         SMTICBUSREQExt;   // Request EBI for TIC Transfer.
input   [1:0] SMMEMCLKRATIO;    // Indicates ratio of Memory Clock with
                                // respect to. HCLK
input         SMBIGENDIAN;      // Indicates Endian mode of the System
input         SMEXTBUSMUX;      // Indication to either use Internal DBI or
                                // External EBI
input         SMTICBUSGNTEBI;   // External bus granted for TIC Transfer
input         SMBUSGNTEBI;      // External bus granted for Memory Transfer
input         SMBUSBACKOFFEBI;  // EBI backoff for Memory accesses. Indication
                                // that the current transfer should be
                                // completed as soon as possible

// Outputs
output [31:0] HRDATAREG;        // AHB Read Data output for Register accesses
output        HREADYOUTREG;     // Indicates completion of Register accesses
output  [1:0] HRESPREG;         // SSMCCore response output, for Register
                                // accesses
output        SMTICBUSGNTExt;   // External bus granted for TIC Transfer
output        SMBUSGNTExt;      // External bus granted for Memory Transfer
output        SmBusBackOffExt;  // BackOff indication from EBI
output        BUSMUXEXT;        // Indication to either use Internal DBI or
                                // External EBI
output        BIGENDIAN;        // Indicates Endianness of the System
output        SMBUSREQEBI;      // Request EBI for Memory Transfer
output        SMTICBUSREQEBI;   // Request EBI for TIC Transfer
output  [1:0] ClockRatio;       // Indicates ratio of Memory Clock with
                                // respect to HCLK
output        MemClkRegTogl;    // Toggle signal indicating that write
                                // happened to Clock Register
output  [1:0] MW1;              // 1st level registered memory width bits
                                // selection from one of the bank registers
output        SMBLSPol1;        // 1st level registered memory Byte lane
                                // polarity bit from one
output        BMRead1;          // 1st level Burst Mode read
output        BIWriteEn1;       // Indication that SMBAA active during
                                // Synchronous Burst Write access, 1st level
                                // buffered
output        BIReadEn1;        // Indication that SMBAA and nSMIND active
                                // during Synchronous Burst Read access, 1st
                                // level buffered
output        WrapRead;         // Enables the wrapping burst feature from
                                // memory
output        BMWrite1;         // 1st level Burst Mode Write
output        SyncEnRead1;      // 1st level Sync burst Mode read
output        SyncEnWrite1;     // 1st level Sync burst Mode Write
output  [1:0] BurstLenRead1;    // 1st level Burst transfer length, by Burst
                                // devices for Read
output  [1:0] BurstLenWrite1;   // 1st level Burst transfer length, by Burst
                                // devices for Write
output        AddrValidReadEn1; // 1st level SMADDRVALID enable during Read
output        AddrValWriteEn1;  // 1st level SMADDRVALID enable during Write
output        SMClockEn;        // Zero on this bit indicates that Clock
                                // should be active during Memory accesses. One
                                // on this bit indicates that clock is always
                                // running
output        WP1;              // 1st level Write protection
output        RBLE1;            // 1st level Byte lane enable
output        WaitEn1;          // 1st level Wait Enable indication
output        WaitPol1;         // 1st level Indication of the polarity of
                                // SMWAIT
output  [4:0] WSTRD1;           // 1st level Single Read access count
output  [4:0] WSTBRD1;          // 1st level Burst Read access count
output  [4:0] WSTWR1;           // 1st level Write access count
output  [3:0] WSTOEN1;          // 1st level Delay value for the assertion of
                                // the OEN
output  [3:0] WSTWEN1;          // 1st level Delay value for the assertion of
                                // the WEN and nSMCS
output  [3:0] IDCYC1;           // 1st level Count value for the turnaround
                                // cycles




// Inputs
  wire        HCLK;             // AHB Bus Clock
  wire        HRESETn;          // AHB system level Reset
  wire [11:2] HADDRREG;         // The address bus input from AHB for Register
                                // accesses
  wire  [1:0] HTRANSREG;        // Indicates current transfer type for
                                // Register accesses.
  wire        HWRITEREG;        // Indicates direction of transfer (R/W) for
                                // Register accesses
  wire  [2:0] HSIZEREG;         // Transfer size indication for Register
                                // accesses
  wire [31:0] HWDATAREG;        // Write data bus input from AHB for Register
                                // accesses
  wire        HSELREG;          // Select signal for Register transfer
  wire        HREADYINREG;      // Transfer completion input signal
  wire  [1:0] SMMWCS7;          // Static Input pins used to program the
                                // memory width bit field of Bank7 register
  wire        SMBLS7POL;        // Static Input pin used to program
                                // the polarity of SMBLS bit field
                                // of Bank7 register
  wire  [3:0] Revision;         // Revision number from SmcRevAnd
  wire        WaitStatus;       // Wait status for enabled transfer
  wire        WaitToutErr;      // Waited access Error indication
  wire        HTRANSSMC;        // Indicates current transfer type for Memory
                                // accesses
  wire  [7:0] HSELSMC;          // Select signal for Memory transfer to
                                // SSMCCore. One select line for each Memory
                                // Bank
  wire        HREADYINSMC;      // Transfer completion input signal
  wire  [7:0] HselMemBuf1;      // 1st level registered HSELSMC
  wire        SMBUSREQExt;      // Request EBI for Memory Transfer.
  wire        SMTICBUSREQExt;   // Request EBI for TIC Transfer.
  wire  [1:0] SMMEMCLKRATIO;    // Indicates ratio of Memory Clock with
                                // respect to. HCLK
  wire        SMBIGENDIAN;      // Indicates Endian mode of the System
  wire        SMEXTBUSMUX;      // Indication to either use Internal DBI or
                                // External EBI
  wire        SMTICBUSGNTEBI;   // External bus granted for TIC Transfer
  wire        SMBUSGNTEBI;      // External bus granted for Memory Transfer
  wire        SMBUSBACKOFFEBI;  // EBI backoff for Memory accesses. Indication
                                // that the current transfer should be
                                // completed as soon as possible

// Outputs
  wire [31:0] HRDATAREG;        // AHB Read Data output for Register accesses
  wire        HREADYOUTREG;     // Indicates completion of Register accesses
  wire  [1:0] HRESPREG;         // SSMCCore response output, for Register
                                // accesses
  wire        SMTICBUSGNTExt;   // External bus granted for TIC Transfer
  wire        SMBUSGNTExt;      // External bus granted for Memory Transfer
  wire        SmBusBackOffExt;  // BackOff indication from EBI
  wire        BUSMUXEXT;        // Indication to either use Internal DBI or
                                // External EBI
  wire        BIGENDIAN;        // Indicates Endianness of the System
  wire        SMBUSREQEBI;      // Request EBI for Memory Transfer
  wire        SMTICBUSREQEBI;   // Request EBI for TIC Transfer
  wire  [1:0] ClockRatio;       // Indicates ratio of Memory Clock with
                                // respect to HCLK
  wire        MemClkRegTogl;    // Toggle signal indicating that write
                                // happened to Clock Register
  wire  [1:0] MW1;              // 1st level registered memory width bits
                                // selection from one of the bank registers
  reg         SMBLSPol1;        // 1st level registered memory Byte lane
                                // polarity bit from one
  reg         BMRead1;          // 1st level Burst Mode read
  reg         BIWriteEn1;       // Indication that SMBAA active during
                                // Synchronous Burst Write access, 1st level
                                // buffered
  reg         BIReadEn1;        // Indication that SMBAA and nSMIND active
                                // during Synchronous Burst Read access, 1st
                                // level buffered
  reg         BMWrite1;         // 1st level Burst Mode Write
  wire        WrapRead;         // Enables the wrapping burst feature from
                                // memory
  wire        SyncEnRead1;      // 1st level Sync burst Mode read
  wire        SyncEnWrite1;     // 1st level Sync burst Mode Write
  reg   [1:0] BurstLenRead1;    // 1st level Burst transfer length, by Burst
                                // devices for Read
  reg   [1:0] BurstLenWrite1;   // 1st level Burst transfer length, by Burst
                                // devices for Write
  reg         AddrValidReadEn1; // 1st level SMADDRVALID enable during Read
  reg         AddrValWriteEn1;  // 1st level SMADDRVALID enable during Write
  wire        SMClockEn;        // Zero on this bit indicates that Clock
                                // should be active during Memory accesses. One
                                // on this bit indicates that clock is always
                                // running
  wire        WP1;              // 1st level Write protection
  reg         RBLE1;            // 1st level Byte lane enable
  wire        WaitEn1;          // 1st level Wait Enable indication
  reg         WaitPol1;         // 1st level Indication of the polarity of
                                // SMWAIT
  reg   [4:0] WSTRD1;           // 1st level Single Read access count
  reg   [4:0] WSTBRD1;          // 1st level Burst Read access count
  reg   [4:0] WSTWR1;           // 1st level Write access count
  reg   [3:0] WSTOEN1;          // 1st level Delay value for the assertion of
                                // the OEN
  reg   [3:0] WSTWEN1;          // 1st level Delay value for the assertion of
                                // the WEN and nSMCS
  reg   [3:0] IDCYC1;           // 1st level Count value for the turnaround
                                // cycles


// -----------------------------------------------------------------------------
//
//                               SsmcAhbSlvRegIf
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//           It consists of the AHB response generation logic, the memory
//           device parameter registers, control registers and status registers.
//
// -----------------------------------------------------------------------------
//                         SSMC Control Register Map
// -----------------------------------------------------------------------------
// Offset  Read (Width)         Write (Width)       Description
// -----------------------------------------------------------------------------
//                              Memory Bank 0

// 0x000 SMBIDCYR0(4-bit)     SMIDCYR0(4-bit)      Idle Cycle
// 0x004 SMBWSTRDR0(5-bit)    SMBWSTRDR0(5-bit)    Wait State for Long Read
// 0x008 SMBWSTWRR0(5-bit)    SMBWSTWRR0(5-bit)    Wait State for Write
// 0x00C SMBWSTOENR0(4-bit)   SMBWSTOENR0(4-bit)   OE Assertion Delay
// 0x010 SMBWSTWENR0(4-bit)   SMBWSTWENR0(4-bit)   WE Assertion Delay
// 0x014 SMBCR0(22-bit)       SMBCR0(22-bit)       Control Register
// 0x018 SMBSR0(1-bit)        SMBSR0(1-bit)        Status Register
// 0x01C SMBWSTBRDR0(5-bit)   SMBWSTBRDR0(5-bit)   Wait State for Burst Read

//                              Memory Bank 1

// 0x020 SMBIDCYR1(4-bit)     SMIDCYR1(4-bit)      Idle Cycle
// 0x024 SMBWSTRDR1(5-bit)    SMBWSTRDR1(5-bit)    Wait State for Long Read
// 0x028 SMBWSTWRR1(5-bit)    SMBWSTWRR1(5-bit)    Wait State for Write
// 0x02C SMBWSTOENR1(4-bit)   SMBWSTOENR1(4-bit)   OE Assertion Delay
// 0x030 SMBWSTWENR1(4-bit)   SMBWSTWENR1(4-bit)   WE Assertion Delay
// 0x034 SMBCR1(22-bit)       SMBCR1(22-bit)       Control Register
// 0x038 SMBSR1(1-bit)        SMBSR1(1-bit)        Status Register
// 0x03C SMBWSTBRDR1(5-bit)   SMBWSTBRDR1(5-bit)   Wait State for Burst Read

//                              Memory Bank 2

// 0x040 SMBIDCYR2(4-bit)     SMIDCYR2(4-bit)      Idle Cycle
// 0x044 SMBWSTRDR2(5-bit)    SMBWSTRDR2(5-bit)    Wait State for Long Read
// 0x048 SMBWSTWRR2(5-bit)    SMBWSTWRR2(5-bit)    Wait State for Write
// 0x04C SMBWSTOENR2(4-bit)   SMBWSTOENR2(4-bit)   OE Assertion Delay
// 0x050 SMBWSTWENR2(4-bit)   SMBWSTWENR2(4-bit)   WE Assertion Delay
// 0x054 SMBCR2(22-bit)       SMBCR2(22-bit)       Control Register
// 0x058 SMBSR2(1-bit)        SMBSR2(1-bit)        Status Register
// 0x05C SMBWSTBRDR2(5-bit)   SMBWSTBRDR2(5-bit)   Wait State for Burst Read

//                              Memory Bank 3

// 0x060 SMBIDCYR3(4-bit)     SMIDCYR3(4-bit)      Idle Cycle
// 0x064 SMBWSTRDR3(5-bit)    SMBWSTRDR3(5-bit)    Wait State for Long Read
// 0x068 SMBWSTWRR3(5-bit)    SMBWSTWRR3(5-bit)    Wait State for Write
// 0x06C SMBWSTOENR3(4-bit)   SMBWSTOENR3(4-bit)   OE Assertion Delay
// 0x070 SMBWSTWENR3(4-bit)   SMBWSTWENR3(4-bit)   WE Assertion Delay
// 0x074 SMBCR3(22-bit)       SMBCR3(22-bit)       Control Register
// 0x078 SMBSR3(1-bit)        SMBSR3(1-bit)        Status Register
// 0x07C SMBWSTBRDR3(5-bit)   SMBWSTBRDR3(5-bit)   Wait State for Burst Read

//                              Memory Bank 4

// 0x080 SMBIDCYR4(4-bit)     SMIDCYR4(4-bit)      Idle Cycle
// 0x084 SMBWSTRDR4(5-bit)    SMBWSTRDR4(5-bit)    Wait State for Long Read
// 0x088 SMBWSTWRR4(5-bit)    SMBWSTWRR4(5-bit)    Wait State for Write
// 0x08C SMBWSTOENR4(4-bit)   SMBWSTOENR4(4-bit)   OE Assertion Delay
// 0x090 SMBWSTWENR4(4-bit)   SMBWSTWENR4(4-bit)   WE Assertion Delay
// 0x094 SMBCR4(22-bit)       SMBCR4(22-bit)       Control Register
// 0x098 SMBSR4(1-bit)        SMBSR4(1-bit)        Status Register
// 0x09C SMBWSTBRDR4(5-bit)   SMBWSTBRDR4(5-bit)   Wait State for Burst Read

//                              Memory Bank 5

// 0x0A0 SMBIDCYR5(4-bit)     SMIDCYR5(4-bit)      Idle Cycle
// 0x0A4 SMBWSTRDR5(5-bit)    SMBWSTRDR5(5-bit)    Wait State for Long Read
// 0x0A8 SMBWSTWRR5(5-bit)    SMBWSTWRR5(5-bit)    Wait State for Write
// 0x0AC SMBWSTOENR5(4-bit)   SMBWSTOENR5(4-bit)   OE Assertion Delay
// 0x0B0 SMBWSTWENR5(4-bit)   SMBWSTWENR5(4-bit)   WE Assertion Delay
// 0x0B4 SMBCR5(22-bit)       SMBCR5(22-bit)       Control Register
// 0x0B8 SMBSR5(1-bit)        SMBSR5(1-bit)        Status Register
// 0x0BC SMBWSTBRDR5(5-bit)   SMBWSTBRDR5(5-bit)    Wait State for Burst Read

//                              Memory Bank 6

// 0x0C0 SMBIDCYR6(4-bit)     SMIDCYR6(4-bit)      Idle Cycle
// 0x0C4 SMBWSTRDR6(5-bit)    SMBWSTRDR6(5-bit)    Wait State for Long Read
// 0x0C8 SMBWSTWRR6(5-bit)    SMBWSTWRR6(5-bit)    Wait State for Write
// 0x0CC SMBWSTOENR6(4-bit)   SMBWSTOENR6(4-bit)   OE Assertion Delay
// 0x0D0 SMBWSTWENR6(4-bit)   SMBWSTWENR6(4-bit)   WE Assertion Delay
// 0x0D4 SMBCR6(22-bit)       SMBCR6(22-bit)       Control Register
// 0x0D8 SMBSR6(1-bit)        SMBSR6(1-bit)        Status Register
// 0x0DC SMBWSTBRDR6(5-bit)   SMBWSTBRDR6(5-bit)   Wait State for Burst Read

//                              Memory Bank 7

// 0x0E0 SMBIDCYR7(4-bit)     SMIDCYR7(4-bit)      Idle Cycle
// 0x0E4 SMBWSTRDR7(5-bit)    SMBWSTRDR7(5-bit)    Wait State for Long Read
// 0x0E8 SMBWSTWRR7(5-bit)    SMBWSTWRR7(5-bit)    Wait State for Write
// 0x0EC SMBWSTOENR7(4-bit)   SMBWSTOENR7(4-bit)   OE Assertion Delay
// 0x0F0 SMBWSTWENR7(4-bit)   SMBWSTWENR7(4-bit)   WE Assertion Delay
// 0x0F4 SMBCR7(22-bit)       SMBCR7(22-bit)       Control Register
// 0x0F8 SMBSR7(1-bit)        SMBSR7(1-bit)        Status Register
// 0x0FC SMBWSTBRDR7(5-bit)   SMBWSTBRDR7(5-bit)   Wait State for Burst Read

//                 External Wait Status bit after a timeout error
// 0x200 SSMCCSR(1-bit)       SMBEWS(RO)           External Wait Status bit

//                 SSMC Control Register
// 0x204 SSMCCR(3-bit)        SSMCCR(3-bit)        Clock Control register

//                 SSMC Test Control Register
// 0x208 SSMCITCR(1-bit)      SSMCITCR(1-bit)      Test Control register

//                 SSMC Test Input Register
// 0x20C SSMCITIP(7-bit)      SSMCITIP(7-bit)      Test Input

//                 SSMC Test Output Register
// 0x210 SSMCITOP(2-bit)      SSMCITOP(2-bit)      Test Output

//                        SSMC Identification Registers

// 0xFE0 SSMCPERIPHID0(8-bit)          -            Peripheral Id register0
// 0xFE4 SSMCPERIPHID1(8-bit)          -            Peripheral Id register1
// 0xFE8 SSMCPERIPHID2(8-bit)          -            Peripheral Id register2
// 0xFEC SSMCPERIPHID3(8-bit)          -            Peripheral Id register3
// 0xFF0 SSMCPCELLID0(8-bit)           -            Prime Cell Id register0
// 0xFF4 SSMCPCELLID1(8-bit)           -            Prime Cell Id register1
// 0xFF8 SSMCPCELLID2(8-bit)           -            Prime Cell Id register2
// 0xFFC SSMCPCELLID3(8-bit)           -            Prime Cell Id register3
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        WRITECYCREG;
// Decode of Write state in SM

wire  [3:0] NextSMBIDCYCR0;
// D-input of SMBIDCYCR0 register

wire  [4:0] NextSMBWSTRDR0;
// D-input of SMBWSTRDR0 register

wire  [4:0] NextSMBWSTWRR0;
// D-input of SMBWSTWRR0 register

wire  [3:0] NextSMBWSTOENR0;
// D-input of SMBWSTOENR0 register

wire  [3:0] NextSMBWSTWENR0;
// D-input of SMBWSTWENR0 register

wire [21:0] NextSMBCR0;
// D-input of SMBCR0 register

wire  [4:0] NextSMBWSTBRDR0;
// D-input of SMBWSTBRDR0 register


wire  [3:0] NextSMBIDCYCR1;
// D-input of SMBIDCYCR1 register

wire  [4:0] NextSMBWSTRDR1;
// D-input of SMBWSTRDR1 register

wire  [4:0] NextSMBWSTWRR1;
// D-input of SMBWSTWRR1 register

wire  [3:0] NextSMBWSTOENR1;
// D-input of SMBWSTOENR1 register

wire  [3:0] NextSMBWSTWENR1;
// D-input of SMBWSTWENR1 register

wire [21:0] NextSMBCR1;
// D-input of SMBCR1 register

wire  [4:0] NextSMBWSTBRDR1;
// D-input of SMBWSTBRDR1 register


wire  [3:0] NextSMBIDCYCR2;
// D-input of SMBIDCYCR2 register

wire  [4:0] NextSMBWSTRDR2;
// D-input of SMBWSTRDR2 register

wire  [4:0] NextSMBWSTWRR2;
// D-input of SMBWSTWRR2 register

wire  [3:0] NextSMBWSTOENR2;
// D-input of SMBWSTOENR2 register

wire  [3:0] NextSMBWSTWENR2;
// D-input of SMBWSTWENR2 register

wire [21:0] NextSMBCR2;
// D-input of SMBCR2 register

wire  [4:0] NextSMBWSTBRDR2;
// D-input of SMBWSTBRDR2 register


wire  [3:0] NextSMBIDCYCR3;
// D-input of SMBIDCYCR3 register

wire  [4:0] NextSMBWSTRDR3;
// D-input of SMBWSTRDR3 register

wire  [4:0] NextSMBWSTWRR3;
// D-input of SMBWSTWRR3 register

wire  [3:0] NextSMBWSTOENR3;
// D-input of SMBWSTOENR3 register

wire  [3:0] NextSMBWSTWENR3;
// D-input of SMBWSTWENR3 register

wire [21:0] NextSMBCR3;
// D-input of SMBCR3 register

wire  [4:0] NextSMBWSTBRDR3;
// D-input of SMBWSTBRDR3 register


wire  [3:0] NextSMBIDCYCR4;
// D-input of SMBIDCYCR4 register

wire  [4:0] NextSMBWSTRDR4;
// D-input of SMBWSTRDR4 register

wire  [4:0] NextSMBWSTWRR4;
// D-input of SMBWSTWRR4 register

wire  [3:0] NextSMBWSTOENR4;
// D-input of SMBWSTOENR4 register

wire  [3:0] NextSMBWSTWENR4;
// D-input of SMBWSTWENR4 register

wire [21:0] NextSMBCR4;
// D-input of SMBCR4 register

wire  [4:0] NextSMBWSTBRDR4;
// D-input of SMBWSTBRDR4 register


wire  [3:0] NextSMBIDCYCR5;
// D-input of SMBIDCYCR5 register

wire  [4:0] NextSMBWSTRDR5;
// D-input of SMBWSTRDR5 register

wire  [4:0] NextSMBWSTWRR5;
// D-input of SMBWSTWRR5 register

wire  [3:0] NextSMBWSTOENR5;
// D-input of SMBWSTOENR5 register

wire  [3:0] NextSMBWSTWENR5;
// D-input of SMBWSTWENR5 register

wire [21:0] NextSMBCR5;
// D-input of SMBCR5 register

wire  [4:0] NextSMBWSTBRDR5;
// D-input of SMBWSTBRDR5 register


wire  [3:0] NextSMBIDCYCR6;
// D-input of SMBIDCYCR6 register

wire  [4:0] NextSMBWSTRDR6;
// D-input of SMBWSTRDR6 register

wire  [4:0] NextSMBWSTWRR6;
// D-input of SMBWSTWRR6 register

wire  [3:0] NextSMBWSTOENR6;
// D-input of SMBWSTOENR6 register

wire  [3:0] NextSMBWSTWENR6;
// D-input of SMBWSTWENR6 register

wire [21:0] NextSMBCR6;
// D-input of SMBCR6 register

wire  [4:0] NextSMBWSTBRDR6;
// D-input of SMBWSTBRDR6 register


wire  [3:0] NextSMBIDCYCR7;
// D-input of SMBIDCYCR7 register

wire  [4:0] NextSMBWSTRDR7;
// D-input of SMBWSTRDR7 register

wire  [4:0] NextSMBWSTWRR7;
// D-input of SMBWSTWRR7 register

wire  [3:0] NextSMBWSTOENR7;
// D-input of SMBWSTOENR7 register

wire  [3:0] NextSMBWSTWENR7;
// D-input of SMBWSTWENR7 register

wire  [4:0] NextSMBWSTBRDR7;
// D-input of SMBWSTBRDR7 register


wire        NextTestCtrlReg;
// D-input of TestCtrlReg register

wire  [6:0] NextTestCtrlIn;
// D-input of TestCtrlInReg register

wire  [1:0] NextTestCtrlOut;
// D-input of TestCtrlOutReg register


wire  [7:0] SSMCPERIPHID0;
// Peripheral ID Register0 Bits

wire  [7:0] SSMCPERIPHID1;
// Peripheral ID Register1 Bits

wire  [3:0] SSMCPERIPHID2;
// Peripheral ID Register2 Bits

wire  [7:0] SSMCPERIPHID3;
// Peripheral ID Register3 Bits

wire  [7:0] SSMCPCELLID0;
// Prime Cell ID Register0 Bits

wire  [7:0] SSMCPCELLID1;
// Prime Cell ID Register1 Bits

wire  [7:0] SSMCPCELLID2;
// Prime Cell ID Register2 Bits

wire  [7:0] SSMCPCELLID3;
// Prime Cell ID Register3 Bits

wire        NextSMBTOUTR0;
// D-input of SMBTOUTR0 register

wire        NextSMBTOUTR1;
// D-input of SMBTOUTR1 register

wire        NextSMBTOUTR2;
// D-input of SMBTOUTR2 register

wire        NextSMBTOUTR3;
// D-input of SMBTOUTR3 register

wire        NextSMBTOUTR4;
// D-input of SMBTOUTR4 register

wire        NextSMBTOUTR5;
// D-input of SMBTOUTR5 register

wire        NextSMBTOUTR6;
// D-input of SMBTOUTR6 register

wire        NextSMBTOUTR7;
// D-input of SMBTOUTR7 register

wire        Bank0ToutClr;
// Clear signal for Bank0 WaitToutErr status bit

wire        Bank1ToutClr;
// Clear signal for Bank1 WaitToutErr status bit

wire        Bank2ToutClr;
// Clear signal for Bank2 WaitToutErr status bit

wire        Bank3ToutClr;
// Clear signal for Bank3 WaitToutErr status bit

wire        Bank4ToutClr;
// Clear signal for Bank4 WaitToutErr status bit

wire        Bank5ToutClr;
// Clear signal for Bank5 WaitToutErr status bit

wire        Bank6ToutClr;
// Clear signal for Bank6 WaitToutErr status bit

wire        Bank7ToutClr;
// Clear signal for Bank7 WaitToutErr status bit

wire        NextMemClkTogl;
// D-input of iMemClkRegTogl register

wire        iSMTICBUSGNTExt;
// Internal version of SMTICBUSGNTExt

wire        NextSMBUSGNTExt;
// D-Input of iSMBUSGNTExt

wire        iBUSMUXEXT;
// Internal version of BUSMUXEXT

wire  [1:0] IntClockRatio;
// Mux output between Clock Ratio pins and ITIP register

wire        iBIGENDIAN;
// Internal version of BIGENDIAN

wire        iSMTICBUSREQEBI;
// Internal version of SMTICBUSREQEBI

wire        iSMBUSREQEBI;
// Internal version of SMBUSREQEBI

wire        iSmBusBackOffExt;
// Internal version of SmBusBackOffExt

wire        SMBUSGNTTest;
// Multiplexed SMBUSGNTEBI for test input register read path

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg         Bank0IDCYCWen;
// Bank0 IDCYC register write enable

reg         Bank0WSTRDWen;
// Bank0 WSTRD register write enable

reg         Bank0WSTWRWen;
// Bank0 WSTWR register write enable

reg         Bank0WSTOENWen;
// Bank0 WSTOEN register write enable

reg         Bank0WSTWENWen;
// Bank0 WSTWEN register write enable

reg         Bank0CtrlWen;
// Bank0 Control register write enable

reg         Bank0StatWen;
// Bank0 Status register write enable

reg         Bank0WSTBRDWen;
// Bank0 BURST Read register write enable

reg         Bank1IDCYCWen;
// Bank1 IDCYC register write enable

reg         Bank1WSTRDWen;
// Bank1 WSTRD register write enable

reg         Bank1WSTWRWen;
// Bank1 WSTWR register write enable

reg         Bank1WSTOENWen;
// Bank1 WSTOEN register write enable

reg         Bank1WSTWENWen;
// Bank1 WSTWEN register write enable

reg         Bank1CtrlWen;
// Bank1 Control register write enable

reg         Bank1StatWen;
// Bank1 Status register write enable

reg         Bank1WSTBRDWen;
// Bank1 BURST Read register write enable

reg         Bank2IDCYCWen;
// Bank2 IDCYC register write enable

reg         Bank2WSTRDWen;
// Bank2 WSTRD register write enable

reg         Bank2WSTWRWen;
// Bank2 WSTWR register write enable

reg         Bank2WSTOENWen;
// Bank2 WSTOEN register write enable

reg         Bank2WSTWENWen;
// Bank2 WSTWEN register write enable

reg         Bank2CtrlWen;
// Bank2 Control register write enable

reg         Bank2StatWen;
// Bank2 Status register write enable

reg         Bank2WSTBRDWen;
// Bank2 BURST Read register write enable

reg         Bank3IDCYCWen;
// Bank3 IDCYC register write enable

reg         Bank3WSTRDWen;
// Bank3 WSTRD register write enable

reg         Bank3WSTWRWen;
// Bank3 WSTWR register write enable

reg         Bank3WSTOENWen;
// Bank3 WSTOEN register write enable

reg         Bank3WSTWENWen;
// Bank3 WSTWEN register write enable

reg         Bank3CtrlWen;
// Bank3 Control register write enable

reg         Bank3StatWen;
// Bank3 Status register write enable

reg         Bank3WSTBRDWen;
// Bank3 BURST Read register write enable

reg         Bank4IDCYCWen;
// Bank4 IDCYC register write enable

reg         Bank4WSTRDWen;
// Bank4 WSTRD register write enable

reg         Bank4WSTWRWen;
// Bank4 WSTWR register write enable

reg         Bank4WSTOENWen;
// Bank4 WSTOEN register write enable

reg         Bank4WSTWENWen;
// Bank4 WSTWEN register write enable

reg         Bank4CtrlWen;
// Bank4 Control register write enable

reg         Bank4StatWen;
// Bank4 Status register write enable

reg         Bank4WSTBRDWen;
// Bank4 BURST Read register write enable

reg         Bank5IDCYCWen;
// Bank5 IDCYC register write enable

reg         Bank5WSTRDWen;
// Bank5 WSTRD register write enable

reg         Bank5WSTWRWen;
// Bank5 WSTWR register write enable

reg         Bank5WSTOENWen;
// Bank5 WSTOEN register write enable

reg         Bank5WSTWENWen;
// Bank5 WSTWEN register write enable

reg         Bank5CtrlWen;
// Bank5 Control register write enable

reg         Bank5StatWen;
// Bank5 Status register write enable

reg         Bank5WSTBRDWen;
// Bank5 BURST Read register write enable

reg         Bank6IDCYCWen;
// Bank6 IDCYC register write enable

reg         Bank6WSTRDWen;
// Bank6 WSTRD register write enable

reg         Bank6WSTWRWen;
// Bank6 WSTWR register write enable

reg         Bank6WSTOENWen;
// Bank6 WSTOEN register write enable

reg         Bank6WSTWENWen;
// Bank6 WSTWEN register write enable

reg         Bank6CtrlWen;
// Bank6 Control register write enable

reg         Bank6StatWen;
// Bank6 Status register write enable

reg         Bank6WSTBRDWen;
// Bank6 BURST Read register write enable

reg         Bank7IDCYCWen;
// Bank7 IDCYC register write enable

reg         Bank7WSTRDWen;
// Bank7 WSTRD register write enable

reg         Bank7WSTWRWen;
// Bank7 WSTWR register write enable

reg         Bank7WSTOENWen;
// Bank7 WSTOEN register write enable

reg         Bank7WSTWENWen;
// Bank7 WSTWEN register write enable

reg         Bank7CtrlWen;
// Bank7 Control register write enable

reg         Bank7StatWen;
// Bank7 Status register write enable

reg         Bank7WSTBRDWen;
// Bank7 BURST Read register write enable


reg         SMClockWen;
// SMCLK register write enable

reg         TestCtrlWen;
// Test control register write enable

reg         TestCtrlInWen;
// Test control input register write enable

reg         TestCtrlOutWen;
// Test control output register write enable


reg   [3:0] SMBIDCYCR0;
// Bank0 IDCYC register

reg   [4:0] SMBWSTRDR0;
// Bank0 WSTRD register

reg   [4:0] SMBWSTWRR0;
// Bank0 WSTWR register

reg   [3:0] SMBWSTOENR0;
// Bank0 WSTOEN register

reg   [3:0] SMBWSTWENR0;
// Bank0 WSTWEN register

reg  [21:0] SMBCR0;
// Bank0 Control register

reg   [4:0] SMBWSTBRDR0;
// Bank0 WSTBRD register


reg   [3:0] SMBIDCYCR1;
// Bank1 IDCYC register

reg   [4:0] SMBWSTRDR1;
// Bank1 WSTRD register

reg   [4:0] SMBWSTWRR1;
// Bank1 WSTWR register

reg   [3:0] SMBWSTOENR1;
// Bank1 WSTOEN register

reg   [3:0] SMBWSTWENR1;
// Bank1 WSTWEN register

reg  [21:0] SMBCR1;
// Bank1 Control register

reg   [4:0] SMBWSTBRDR1;
// Bank1 WSTBRD register


reg   [3:0] SMBIDCYCR2;
// Bank2 IDCYC register

reg   [4:0] SMBWSTRDR2;
// Bank2 WSTRD register

reg   [4:0] SMBWSTWRR2;
// Bank2 WSTWR register

reg   [3:0] SMBWSTOENR2;
// Bank2 WSTOEN register

reg   [3:0] SMBWSTWENR2;
// Bank2 WSTWEN register

reg  [21:0] SMBCR2;
// Bank2 Control register

reg   [4:0] SMBWSTBRDR2;
// Bank2 WSTBRD register


reg   [3:0] SMBIDCYCR3;
// Bank3 IDCYC register

reg   [4:0] SMBWSTRDR3;
// Bank3 WSTRD register

reg   [4:0] SMBWSTWRR3;
// Bank3 WSTWR register

reg   [3:0] SMBWSTOENR3;
// Bank3 WSTOEN register

reg   [3:0] SMBWSTWENR3;
// Bank3 WSTWEN register

reg  [21:0] SMBCR3;
// Bank3 Control register

reg   [4:0] SMBWSTBRDR3;
// Bank3 WSTBRD register


reg   [3:0] SMBIDCYCR4;
// Bank4 IDCYC register

reg   [4:0] SMBWSTRDR4;
// Bank4 WSTRD register

reg   [4:0] SMBWSTWRR4;
// Bank4 WSTWR register

reg   [3:0] SMBWSTOENR4;
// Bank4 WSTOEN register

reg   [3:0] SMBWSTWENR4;
// Bank4 WSTWEN register

reg  [21:0] SMBCR4;
// Bank4 Control register

reg   [4:0] SMBWSTBRDR4;
// Bank4 WSTBRD register


reg   [3:0] SMBIDCYCR5;
// Bank5 IDCYC register

reg   [4:0] SMBWSTRDR5;
// Bank5 WSTRD register

reg   [4:0] SMBWSTWRR5;
// Bank5 WSTWR register

reg   [3:0] SMBWSTOENR5;
// Bank5 WSTOEN register

reg   [3:0] SMBWSTWENR5;
// Bank5 WSTWEN register

reg  [21:0] SMBCR5;
// Bank5 Control register

reg   [4:0] SMBWSTBRDR5;
// Bank5 WSTBRD register


reg   [3:0] SMBIDCYCR6;
// Bank6 IDCYC register

reg   [4:0] SMBWSTRDR6;
// Bank6 WSTRD register

reg   [4:0] SMBWSTWRR6;
// Bank6 WSTWR register

reg   [3:0] SMBWSTOENR6;
// Bank6 WSTOEN register

reg   [3:0] SMBWSTWENR6;
// Bank6 WSTWEN register

reg  [21:0] SMBCR6;
// Bank6 Control register

reg   [4:0] SMBWSTBRDR6;
// Bank6 WSTBRD register


reg   [3:0] SMBIDCYCR7;
// Bank7 IDCYC register

reg   [4:0] SMBWSTRDR7;
// Bank7 WSTRD register

reg   [4:0] SMBWSTWRR7;
// Bank7 WSTWR register

reg   [3:0] SMBWSTOENR7;
// Bank7 WSTOEN register

reg   [3:0] SMBWSTWENR7;
// Bank7 WSTWEN register

reg  [21:0] SMBCR7;
// Bank7 Control register

reg   [4:0] SMBWSTBRDR7;
// Bank7 WSTBRD register


reg  [21:0] NextSMBCR7;
// D-input of SMBCR7 register

reg   [2:0] SMClockEnReg;
// SMCLK enable register

reg   [2:0] NextSMClockEnReg;
// D-input of SMClockEnReg register

reg         SMBTOUTR0;
// Status for Bank0 Time out Error indication during Memory accesses

reg         SMBTOUTR1;
// Status for Bank1 Time out Error indication during Memory accesses

reg         SMBTOUTR2;
// Status for Bank2 Time out Error indication during Memory accesses

reg         SMBTOUTR3;
// Status for Bank3 Time out Error indication during Memory accesses

reg         SMBTOUTR4;
// Status for Bank4 Time out Error indication during Memory accesses

reg         SMBTOUTR5;
// Status for Bank5 Time out Error indication during Memory accesses

reg         SMBTOUTR6;
// Status for Bank6 Time out Error indication during Memory accesses

reg         SMBTOUTR7;
// Status for Bank7 Time out Error indication during Memory accesses

reg         TestCtrlReg;
// Test Control register

reg   [6:0] TestCtrlInReg;
// Test Control input register

reg   [1:0] TestCtrlOutReg;
// Test Control output register

reg   [1:0] iHRESPREG;
// Internal version of HRESPS

reg   [1:0] NextHRESPREG;
// D-input of iHRESPS register

reg         iHREADYOUTREG;
// Internal version of HREADYOUT

reg         NextHREADYOUTREG;
// D-input of iHREADYOUT register

reg   [9:0] AddressBuf;
// Reg to hold the offset address(for Latching)

reg   [9:0] NextAddressBuf;
// input of the offset address(for Latching)

reg   [3:0] SmSlaveState;
// input vector to control the state machine

reg   [3:0] NextSmSlaveState;
// D-input of SmSlaveState signal

reg         Bank0ToutErr;
// Error indication for Bank0 TimeOut condition

reg         Bank1ToutErr;
// Error indication for Bank1 TimeOut condition

reg         Bank2ToutErr;
// Error indication for Bank2 TimeOut condition

reg         Bank3ToutErr;
// Error indication for Bank3 TimeOut condition

reg         Bank4ToutErr;
// Error indication for Bank4 TimeOut condition

reg         Bank5ToutErr;
// Error indication for Bank5 TimeOut condition

reg         Bank6ToutErr;
// Error indication for Bank6 TimeOut condition

reg         Bank7ToutErr;
// Error indication for Bank7 TimeOut condition

reg         SoftWrClkReg;
// Indication that Clock frequency in  Control register was programmed
// by software

reg         NextSoftWrClkReg;
// D-input of SoftWrClkReg register

reg         SoftWrMW7Reg;
// Indication that Width in  Control register was programmed by software

reg         NextSoftWrMW7Reg;
// D-input of SoftWrMW7Reg register

reg         SoftWrBLS7Reg;
// Indication that SMBLS polarity in  Control register was programmed by
// software

reg         NxtSoftWrBLS7Reg;
// D-input of SoftWrBLS7Reg register

reg  [31:0] iHRDATAREG;
// Internal Version of HRDATAREG

reg  [31:0] NextHrdataReg;
// D-input of iHRDATAREG register

reg         iMemClkRegTogl;
// Internal signal of MemClkRegTogl

reg         DelMemClkRegTogl;
// Delayed version of iMemClkRegTogl

reg         SmBusGntEbiReg;
// Registered version of SMBUSGNTEBI

reg         SmTicGntEbiReg;
// Registered version of SMBUSGNTEBI

reg         SmBusBackOffReg;
// Registered version of SMBUSBACKOFFEBI

reg         iSMBUSGNTExt;
// Internal version of SMBUSGNTExt

reg   [1:0] iMW1;
// Internal version of MW1

reg   [1:0] NextMW1;
// D-Input of iMW1

reg         iWrapRead;
// D-Input of WrapRead

reg         NextWrapRead;
// D-Input of iWrapRead

reg         iSyncEnRead1;
// Internal version of SyncEnRead1

reg         NextSyncEnRead1;
// D-Input of iSyncEnRead1

reg         iWaitEn1;
// Internal version of WaitEn1

reg         NextWaitEn1;
// D-Input of iWaitEn1

reg         iWP1;
// Internal version of WP1

reg         NextWP1;
// D-Input of iWP1

reg         iSyncEnWrite1;
// Internal version of SyncEnWrite1

reg         NextSyncEnWrite1;
// D-Input of iSyncEnWrite1


// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Assign the SSMC Peripheral ID
//
// The SSMC Peripheral ID is a 32-bit value composed of the
// following 4 fields:
// Bits [11:0] -> Part Number used to identify the peripheral
//                For the SSMC this is 0x093
// Bits[19:12] -> Designer ID (ARM)
//                ARM is designated 0x41
// Bits[23:20] -> Peripheral Revision Number
//                For the SSMC this is 0x00
// Bits[31:24] -> Peripheral Configuration Options
//                For the SSMC this is 0x00
//
// The 32-bits are readable via 4 separate address locations with
// each location returning 8 valid bits at positions [7:0]. The
// values returned by the 4 Peripheral ID registers are given below:
//
// SSMCPERIPHID0 = 0x93
// SSMCPERIPHID1 = 0x10
// SSMCPERIPHID2 = 0x04
// SSMCPERIPHID3 = 0x00
// -----------------------------------------------------------------------------
assign SSMCPERIPHID0    = 8'b10010011;
assign SSMCPERIPHID1    = 8'b00010000;
assign SSMCPERIPHID2    = 4'b0100;
assign SSMCPERIPHID3    = 8'b00000000;

// -----------------------------------------------------------------------------
// Assign the SSMC PrimeCell ID
//
// SSMCPCELLID0 = 0x0D
// SSMCPCELLID1 = 0xF0
// SSMCPCELLID2 = 0x05
// SSMCPCELLID3 = 0xB1
// These PrimeCell ID values should not be changed.
// -----------------------------------------------------------------------------
assign SSMCPCELLID0     = 8'b00001101;
assign SSMCPCELLID1     = 8'b11110000;
assign SSMCPCELLID2     = 8'b00000101;
assign SSMCPCELLID3     = 8'b10110001;

// -----------------------------------------------------------------------------
// Generation of State Decode's
// -----------------------------------------------------------------------------
assign WRITECYCREG      = SmSlaveState[1];

// -----------------------------------------------------------------------------
// Internal Signal Assignments
// -----------------------------------------------------------------------------
assign HREADYOUTREG     = iHREADYOUTREG;
assign HRESPREG         = iHRESPREG;
assign HRDATAREG        = iHRDATAREG;
assign SMClockEn        = SMClockEnReg[0];
assign ClockRatio       = SMClockEnReg[2:1];
assign BIGENDIAN        = iBIGENDIAN;
assign BUSMUXEXT        = iBUSMUXEXT;
assign SMBUSGNTExt      = iSMBUSGNTExt;
assign SmBusBackOffExt  = iSmBusBackOffExt;
assign SMTICBUSGNTExt   = iSMTICBUSGNTExt;
assign MemClkRegTogl    = iMemClkRegTogl;
assign SMBUSREQEBI      = iSMBUSREQEBI;
assign SMTICBUSREQEBI   = iSMTICBUSREQEBI;
assign MW1              = iMW1;
assign WP1              = iWP1;
assign WrapRead         = iWrapRead;
assign SyncEnRead1      = iSyncEnRead1;
assign SyncEnWrite1     = iSyncEnWrite1;
assign WaitEn1          = iWaitEn1;

// -----------------------------------------------------------------------------
//                              Assignments
// -----------------------------------------------------------------------------
assign NextSMBUSGNTExt = SMBUSGNTEBI & SMBUSREQExt;

// -----------------------------------------------------------------------------
//    S L A V E    S E L E C T    S T A T E    M A C H I N E
// -----------------------------------------------------------------------------
//
// Summary: State Machine to control the AHB Slave interface for Register
//          accesses.
//
// Overview: This state machine will control the AHB slave interface for
//           register accesses.
//
// Summary State Description:
// ==========================
//
// ST_REG_NOT_SEL: Register Not Selected State.
// Description   : Default state when interface is not selected.
// Entry         : HSELREG is sampled de-asserted or if HTRANSREG is sampled
//                 BUSY or IDLE and the end of any given bus cycle.
// Exit          : When there is a read or write access.
// No change     : Until the HSELREG and HREADYINREG is sampled asserted.
//
// ST_REG_READ   : Register Read State.
// Description   : Read access in progress.
// Entry         : When 32 bit read is initiated.
// Exit          : When read is completed and HTRANSREG is sampled BUSY or IDLE
//                 at the end of given bus cycle OR when Write transfer is
//                 sampled asserted at the end of given bus cycle.
// No Change     : During read access(Until HREADYINREG is sampled asserted).
//
// ST_REG_WRITE  : Register Write State.
// Description   : Write access in progress.
// Entry         : When 32 bit write is initiated.
// Exit          : When write is complete and HTRANSREG is sampled BUSY or IDLE
//                 at the end of given bus cycle OR when Read transfer is
//                 sampled asserted at the end of given bus cycle.
// No Change     : During write access(Until HREADYINREG is sampled asserted).
//
// ST_REG_ERROR  : Register Error State.
// Description   : Error condition state.
// Entry         : Invalid access attempted where HSIZEREG is not equal to WORD.
// Exit          : After ERROR has been flagged on AHB.
// No change     : While ERROR response is driven on HRESP.
//
// Detailed Description:
// =====================
// The logic has a separate address buffer that latches in the address on the
// HADDRREG lines at the end of every bus cycle. This latched address is used
// for further decoding. The data transfers from registers to the AHB bus occur
// only in the ST_REG_READ state. The data transfers to registers from the AHB
// bus occur only in the ST_REG_WRITE state.
// 
// The buffered address is decoded and if the access is a Write to registers a
// combinatorial decode of ST_REG_WRITE state bit and the buffered address
// directly forms the Write Enable for the registers. The Writes to registers
// terminate with one wait cycle response.
//
// Whenever a read/write access is initiated with NSEQ or SEQ on the SSMC, the
// SM always inserts a Wait state for the cycle. This Wait period is of only one
// clock. At the end of the Wait period the SM drives HREADYOUTREG high with
// OKAY response.
// 
// When an error occurs HRESPREG will be driven to ERROR and HREADYOUT will be
// low for 1 cycle followed by 1 cycle high. An ERROR is caused by any access
// that is not 32 bits wide.
// 
// -----------------------------------------------------------------------------
always @(SmSlaveState or AddressBuf or HREADYINREG or HTRANSREG or HADDRREG or
         HWRITEREG or iHREADYOUTREG or iHRESPREG or HSELREG or HSIZEREG)
begin : p_RegSMComb
  NextSmSlaveState = SmSlaveState;
  NextHREADYOUTREG = iHREADYOUTREG;
  NextHRESPREG     = iHRESPREG;
  NextAddressBuf   = AddressBuf;
  case (SmSlaveState)
    `ST_REG_NOT_SEL, `ST_REG_WRITE, `ST_REG_READ :
      begin
        if (HREADYINREG == 1'b1)
          begin
            if (HSELREG == 1'b1)
              begin
                case (HTRANSREG)
                  `HTRANS_IDLE, `HTRANS_BUSY :
                    begin
                      NextSmSlaveState = `ST_REG_NOT_SEL;
                      NextHREADYOUTREG = 1'b1;
                      NextHRESPREG     = `HRESP_OKAY;
                      NextAddressBuf   = HADDRREG;
                    end
      
                  `HTRANS_NSEQ, `HTRANS_SEQ :
                    begin
                      NextHRESPREG     = `HRESP_OKAY;
                      NextAddressBuf   = HADDRREG;
                      NextHREADYOUTREG = 1'b0;
                      if (HSIZEREG != 3'b010)
                        begin
                          NextSmSlaveState = `ST_REG_ERROR;
                          NextHRESPREG     = `HRESP_ERROR;
                        end
                      else if (HWRITEREG == 1'b1)
                        begin
                          NextSmSlaveState = `ST_REG_WRITE;
                        end
                      else
                        begin
                          NextSmSlaveState = `ST_REG_READ;
                        end
                    end
      
                  default :
                    ;
                endcase
              end
            else
              begin
                NextSmSlaveState = `ST_REG_NOT_SEL;
                NextHREADYOUTREG = 1'b1;
                NextHRESPREG     = `HRESP_OKAY;
              end
          end
        else
          begin
            NextHREADYOUTREG = 1'b1;
          end
      end

    `ST_REG_ERROR :
      begin
       NextHRESPREG     = `HRESP_ERROR;
       NextHREADYOUTREG = 1'b1;
       NextSmSlaveState = `ST_REG_NOT_SEL;
      end

    default :
      ;
  endcase
end // p_RegSMComb

// -----------------------------------------------------------------------------
// Registering all Next state signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegSMSeq
  if (HRESETn == 1'b0)
    begin
      SmSlaveState     <= `ST_REG_NOT_SEL;
      iHREADYOUTREG    <= 1'b1;
      iHRESPREG        <= `HRESP_OKAY;
      AddressBuf       <= 10'b0000000000;
      SoftWrClkReg     <= 1'b0;
      SoftWrMW7Reg     <= 1'b0;
      SoftWrBLS7Reg    <= 1'b0;
      iMemClkRegTogl   <= 1'b0;
      DelMemClkRegTogl <= 1'b0;
      iSMBUSGNTExt     <= 1'b0;
      SmBusGntEbiReg   <= 1'b0;
      SmTicGntEbiReg   <= 1'b1;
      SmBusBackOffReg  <= 1'b0;
    end
  else
    begin
      SmSlaveState     <= NextSmSlaveState;
      iHREADYOUTREG    <= NextHREADYOUTREG;
      iHRESPREG        <= NextHRESPREG;
      AddressBuf       <= NextAddressBuf;
      SoftWrClkReg     <= NextSoftWrClkReg;
      SoftWrMW7Reg     <= NextSoftWrMW7Reg;
      SoftWrBLS7Reg    <= NxtSoftWrBLS7Reg;
      iMemClkRegTogl   <= NextMemClkTogl;
      DelMemClkRegTogl <= iMemClkRegTogl;
      iSMBUSGNTExt     <= NextSMBUSGNTExt;
      SmBusGntEbiReg   <= SMBUSGNTEBI;
      SmTicGntEbiReg   <= SMTICBUSGNTEBI;
      SmBusBackOffReg  <= SMBUSBACKOFFEBI;
    end
end // p_RegSMSeq

// -----------------------------------------------------------------------------
// Register Write Logic
// This always block controls the enable signal for the registers depending on
// which address the CPU is trying to access.
// -----------------------------------------------------------------------------
always @(AddressBuf or WRITECYCREG or SoftWrClkReg or SoftWrMW7Reg or
         SoftWrBLS7Reg)
begin : p_RegWriteComb
   Bank0IDCYCWen    = 1'b0;
   Bank0WSTRDWen    = 1'b0;
   Bank0WSTBRDWen   = 1'b0;
   Bank0WSTWRWen    = 1'b0;
   Bank0WSTOENWen   = 1'b0;
   Bank0WSTWENWen   = 1'b0;
   Bank0CtrlWen     = 1'b0;
   Bank0StatWen     = 1'b0;
   Bank1IDCYCWen    = 1'b0;
   Bank1WSTRDWen    = 1'b0;
   Bank1WSTBRDWen   = 1'b0;
   Bank1WSTWRWen    = 1'b0;
   Bank1WSTOENWen   = 1'b0;
   Bank1WSTWENWen   = 1'b0;
   Bank1CtrlWen     = 1'b0;
   Bank1StatWen     = 1'b0;
   Bank2IDCYCWen    = 1'b0;
   Bank2WSTRDWen    = 1'b0;
   Bank2WSTBRDWen   = 1'b0;
   Bank2WSTWRWen    = 1'b0;
   Bank2WSTOENWen   = 1'b0;
   Bank2WSTWENWen   = 1'b0;
   Bank2CtrlWen     = 1'b0;
   Bank2StatWen     = 1'b0;
   Bank3IDCYCWen    = 1'b0;
   Bank3WSTRDWen    = 1'b0;
   Bank3WSTBRDWen   = 1'b0;
   Bank3WSTWRWen    = 1'b0;
   Bank3WSTOENWen   = 1'b0;
   Bank3WSTWENWen   = 1'b0;
   Bank3CtrlWen     = 1'b0;
   Bank3StatWen     = 1'b0;
   Bank4IDCYCWen    = 1'b0;
   Bank4WSTRDWen    = 1'b0;
   Bank4WSTBRDWen   = 1'b0;
   Bank4WSTWRWen    = 1'b0;
   Bank4WSTOENWen   = 1'b0;
   Bank4WSTWENWen   = 1'b0;
   Bank4CtrlWen     = 1'b0;
   Bank4StatWen     = 1'b0;
   Bank5IDCYCWen    = 1'b0;
   Bank5WSTRDWen    = 1'b0;
   Bank5WSTBRDWen   = 1'b0;
   Bank5WSTWRWen    = 1'b0;
   Bank5WSTOENWen   = 1'b0;
   Bank5WSTWENWen   = 1'b0;
   Bank5CtrlWen     = 1'b0;
   Bank5StatWen     = 1'b0;
   Bank6IDCYCWen    = 1'b0;
   Bank6WSTRDWen    = 1'b0;
   Bank6WSTBRDWen   = 1'b0;
   Bank6WSTWRWen    = 1'b0;
   Bank6WSTOENWen   = 1'b0;
   Bank6WSTWENWen   = 1'b0;
   Bank6CtrlWen     = 1'b0;
   Bank6StatWen     = 1'b0;
   Bank7IDCYCWen    = 1'b0;
   Bank7WSTRDWen    = 1'b0;
   Bank7WSTBRDWen   = 1'b0;
   Bank7WSTWRWen    = 1'b0;
   Bank7WSTOENWen   = 1'b0;
   Bank7WSTWENWen   = 1'b0;
   Bank7CtrlWen     = 1'b0;
   Bank7StatWen     = 1'b0;
   SMClockWen       = 1'b0;
   TestCtrlWen      = 1'b0;
   TestCtrlInWen    = 1'b0;
   TestCtrlOutWen   = 1'b0;
   NextSoftWrClkReg = SoftWrClkReg;
   NextSoftWrMW7Reg = SoftWrMW7Reg;
   NxtSoftWrBLS7Reg = SoftWrBLS7Reg;
  if (WRITECYCREG == 1'b1)
  begin
    case (AddressBuf)
      `HADDR_SMBIDCYR0 :           Bank0IDCYCWen = 1'b1;
      `HADDR_SMBWSTRDR0 :          Bank0WSTRDWen = 1'b1;
      `HADDR_SMBWSTBRDR0 :         Bank0WSTBRDWen = 1'b1;
      `HADDR_SMBWSTOENR0 :         Bank0WSTOENWen = 1'b1;
      `HADDR_SMBWSTWRR0 :          Bank0WSTWRWen = 1'b1;
      `HADDR_SMBWSTWENR0 :         Bank0WSTWENWen = 1'b1;
      `HADDR_SMBCR0 :              Bank0CtrlWen = 1'b1;
      `HADDR_SMBSR0 :              Bank0StatWen = 1'b1;
      `HADDR_SMBIDCYR1 :           Bank1IDCYCWen = 1'b1;
      `HADDR_SMBWSTRDR1 :          Bank1WSTRDWen = 1'b1;
      `HADDR_SMBWSTBRDR1 :         Bank1WSTBRDWen = 1'b1;
      `HADDR_SMBWSTOENR1 :         Bank1WSTOENWen = 1'b1;
      `HADDR_SMBWSTWRR1 :          Bank1WSTWRWen = 1'b1;
      `HADDR_SMBWSTWENR1 :         Bank1WSTWENWen = 1'b1;
      `HADDR_SMBCR1 :              Bank1CtrlWen = 1'b1;
      `HADDR_SMBSR1 :              Bank1StatWen = 1'b1;
      `HADDR_SMBIDCYR2  :          Bank2IDCYCWen = 1'b1;
      `HADDR_SMBWSTRDR2  :         Bank2WSTRDWen = 1'b1;
      `HADDR_SMBWSTBRDR2  :        Bank2WSTBRDWen = 1'b1;
      `HADDR_SMBWSTOENR2  :        Bank2WSTOENWen = 1'b1;
      `HADDR_SMBWSTWRR2  :         Bank2WSTWRWen = 1'b1;
      `HADDR_SMBWSTWENR2  :        Bank2WSTWENWen = 1'b1;
      `HADDR_SMBCR2  :             Bank2CtrlWen = 1'b1;
      `HADDR_SMBSR2  :             Bank2StatWen = 1'b1;
      `HADDR_SMBIDCYR3  :          Bank3IDCYCWen = 1'b1;
      `HADDR_SMBWSTRDR3  :         Bank3WSTRDWen = 1'b1;
      `HADDR_SMBWSTBRDR3  :        Bank3WSTBRDWen = 1'b1;
      `HADDR_SMBWSTOENR3  :        Bank3WSTOENWen = 1'b1;
      `HADDR_SMBWSTWRR3  :         Bank3WSTWRWen = 1'b1;
      `HADDR_SMBWSTWENR3  :        Bank3WSTWENWen = 1'b1;
      `HADDR_SMBCR3  :             Bank3CtrlWen = 1'b1;
      `HADDR_SMBSR3  :             Bank3StatWen = 1'b1;
      `HADDR_SMBIDCYR4  :          Bank4IDCYCWen = 1'b1;
      `HADDR_SMBWSTRDR4  :         Bank4WSTRDWen = 1'b1;
      `HADDR_SMBWSTBRDR4  :        Bank4WSTBRDWen = 1'b1;
      `HADDR_SMBWSTOENR4  :        Bank4WSTOENWen = 1'b1;
      `HADDR_SMBWSTWRR4  :         Bank4WSTWRWen = 1'b1;
      `HADDR_SMBWSTWENR4  :        Bank4WSTWENWen = 1'b1;
      `HADDR_SMBCR4  :             Bank4CtrlWen = 1'b1;
      `HADDR_SMBSR4  :             Bank4StatWen = 1'b1;
      `HADDR_SMBIDCYR5  :          Bank5IDCYCWen = 1'b1;
      `HADDR_SMBWSTRDR5  :         Bank5WSTRDWen = 1'b1;
      `HADDR_SMBWSTBRDR5  :        Bank5WSTBRDWen = 1'b1;
      `HADDR_SMBWSTOENR5  :        Bank5WSTOENWen = 1'b1;
      `HADDR_SMBWSTWRR5  :         Bank5WSTWRWen = 1'b1;
      `HADDR_SMBWSTWENR5  :        Bank5WSTWENWen = 1'b1;
      `HADDR_SMBCR5  :             Bank5CtrlWen = 1'b1;
      `HADDR_SMBSR5  :             Bank5StatWen = 1'b1;
      `HADDR_SMBIDCYR6  :          Bank6IDCYCWen = 1'b1;
      `HADDR_SMBWSTRDR6  :         Bank6WSTRDWen = 1'b1;
      `HADDR_SMBWSTBRDR6  :        Bank6WSTBRDWen = 1'b1;
      `HADDR_SMBWSTOENR6  :        Bank6WSTOENWen = 1'b1;
      `HADDR_SMBWSTWRR6  :         Bank6WSTWRWen = 1'b1;
      `HADDR_SMBWSTWENR6  :        Bank6WSTWENWen = 1'b1;
      `HADDR_SMBCR6  :             Bank6CtrlWen = 1'b1;
      `HADDR_SMBSR6  :             Bank6StatWen = 1'b1;
      `HADDR_SMBIDCYR7  :          Bank7IDCYCWen = 1'b1;
      `HADDR_SMBWSTRDR7  :         Bank7WSTRDWen = 1'b1;
      `HADDR_SMBWSTBRDR7  :        Bank7WSTBRDWen = 1'b1;
      `HADDR_SMBWSTOENR7  :        Bank7WSTOENWen = 1'b1;
      `HADDR_SMBWSTWRR7  :         Bank7WSTWRWen = 1'b1;
      `HADDR_SMBWSTWENR7  :        Bank7WSTWENWen = 1'b1;
      `HADDR_SMBCR7 :
        begin
          Bank7CtrlWen     = 1'b1;
          NextSoftWrMW7Reg = 1'b1;
          NxtSoftWrBLS7Reg = 1'b1;
        end
      `HADDR_SMBSR7 :              Bank7StatWen = 1'b1;
      `HADDR_SMCR :
        begin
          SMClockWen       = 1'b1;
          NextSoftWrClkReg = 1'b1;
        end
      `HADDR_SMITCR :              TestCtrlWen = 1'b1;
      `HADDR_SMITIP :              TestCtrlInWen = 1'b1;
      `HADDR_SMITOP :              TestCtrlOutWen = 1'b1;

      default :
        ;
    endcase
  end
end // p_RegWriteComb

// -----------------------------------------------------------------------------
// The Concurrent assignments controls the actual write in HCLK domain. Here
// depending on the register enable signals the data from the data bus is
// registered on to the corresponding registers.
// -----------------------------------------------------------------------------
assign NextSMBIDCYCR0[3:0] = (Bank0IDCYCWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBIDCYCR0;

assign NextSMBWSTRDR0[4:0] = (Bank0WSTRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTRDR0;

assign NextSMBWSTBRDR0[4:0] = (Bank0WSTBRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTBRDR0;

assign NextSMBWSTWRR0[4:0] = (Bank0WSTWRWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTWRR0;

assign NextSMBWSTOENR0[3:0] = (Bank0WSTOENWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBWSTOENR0;

assign NextSMBWSTWENR0[3:0] = (Bank0WSTWENWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBWSTWENR0;

assign NextSMBCR0[21:0] = (Bank0CtrlWen == 1'b1) ? HWDATAREG[21:0]   : SMBCR0;

assign Bank0ToutClr     = (Bank0StatWen == 1'b1) ? HWDATAREG[0]      : 1'b0;

assign NextSMBIDCYCR1[3:0] = (Bank1IDCYCWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBIDCYCR1;

assign NextSMBWSTRDR1[4:0] = (Bank1WSTRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTRDR1;

assign NextSMBWSTBRDR1[4:0] = (Bank1WSTBRDWen == 1'b1) ? HWDATAREG[4:0] :
                              SMBWSTBRDR1;

assign NextSMBWSTWRR1[4:0] = (Bank1WSTWRWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTWRR1;

assign NextSMBWSTOENR1[3:0] = (Bank1WSTOENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTOENR1;

assign NextSMBWSTWENR1[3:0] = (Bank1WSTWENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTWENR1;

assign NextSMBCR1[21:0] = (Bank1CtrlWen == 1'b1) ? HWDATAREG[21:0]   : SMBCR1;

assign Bank1ToutClr     = (Bank1StatWen == 1'b1) ? HWDATAREG[0]      : 1'b0;

assign NextSMBIDCYCR2[3:0] = (Bank2IDCYCWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBIDCYCR2;

assign NextSMBWSTRDR2[4:0] = (Bank2WSTRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTRDR2;

assign NextSMBWSTBRDR2[4:0] = (Bank2WSTBRDWen == 1'b1) ? HWDATAREG[4:0] :
                              SMBWSTBRDR2;

assign NextSMBWSTWRR2[4:0] = (Bank2WSTWRWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTWRR2;

assign NextSMBWSTOENR2[3:0] = (Bank2WSTOENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTOENR2;

assign NextSMBWSTWENR2[3:0] = (Bank2WSTWENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTWENR2;

assign NextSMBCR2[21:0] = (Bank2CtrlWen == 1'b1) ? HWDATAREG[21:0]   : SMBCR2;

assign Bank2ToutClr     = (Bank2StatWen == 1'b1) ? HWDATAREG[0]      : 1'b0;

assign NextSMBIDCYCR3[3:0] = (Bank3IDCYCWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBIDCYCR3;

assign NextSMBWSTRDR3[4:0] = (Bank3WSTRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTRDR3;

assign NextSMBWSTBRDR3[4:0] = (Bank3WSTBRDWen == 1'b1) ? HWDATAREG[4:0] :
                              SMBWSTBRDR3;

assign NextSMBWSTWRR3[4:0] = (Bank3WSTWRWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTWRR3;

assign NextSMBWSTOENR3[3:0] = (Bank3WSTOENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTOENR3;

assign NextSMBWSTWENR3[3:0] = (Bank3WSTWENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTWENR3;

assign NextSMBCR3[21:0] = (Bank3CtrlWen == 1'b1) ? HWDATAREG[21:0]   : SMBCR3;

assign Bank3ToutClr     = (Bank3StatWen == 1'b1) ? HWDATAREG[0]      : 1'b0;

assign NextSMBIDCYCR4[3:0] = (Bank4IDCYCWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBIDCYCR4;

assign NextSMBWSTRDR4[4:0] = (Bank4WSTRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTRDR4;

assign NextSMBWSTBRDR4[4:0] = (Bank4WSTBRDWen == 1'b1) ? HWDATAREG[4:0] :
                              SMBWSTBRDR4;

assign NextSMBWSTWRR4[4:0] = (Bank4WSTWRWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTWRR4;

assign NextSMBWSTOENR4[3:0] = (Bank4WSTOENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTOENR4;

assign NextSMBWSTWENR4[3:0] = (Bank4WSTWENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTWENR4;

assign NextSMBCR4[21:0] = (Bank4CtrlWen == 1'b1) ? HWDATAREG[21:0]   : SMBCR4;

assign Bank4ToutClr     = (Bank4StatWen == 1'b1) ? HWDATAREG[0]      : 1'b0;

assign NextSMBIDCYCR5[3:0] = (Bank5IDCYCWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBIDCYCR5;

assign NextSMBWSTRDR5[4:0] = (Bank5WSTRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTRDR5;

assign NextSMBWSTBRDR5[4:0] = (Bank5WSTBRDWen == 1'b1) ? HWDATAREG[4:0] :
                              SMBWSTBRDR5;

assign NextSMBWSTWRR5[4:0] = (Bank5WSTWRWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTWRR5;

assign NextSMBWSTOENR5[3:0] = (Bank5WSTOENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTOENR5;

assign NextSMBWSTWENR5[3:0] = (Bank5WSTWENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTWENR5;

assign NextSMBCR5[21:0] = (Bank5CtrlWen == 1'b1) ? HWDATAREG[21:0]   : SMBCR5;

assign Bank5ToutClr     = (Bank5StatWen == 1'b1) ? HWDATAREG[0]      : 1'b0;

assign NextSMBIDCYCR6[3:0] = (Bank6IDCYCWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBIDCYCR6;

assign NextSMBWSTRDR6[4:0] = (Bank6WSTRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTRDR6;

assign NextSMBWSTBRDR6[4:0] = (Bank6WSTBRDWen == 1'b1) ? HWDATAREG[4:0] :
                              SMBWSTBRDR6;

assign NextSMBWSTWRR6[4:0] = (Bank6WSTWRWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTWRR6;

assign NextSMBWSTOENR6[3:0] = (Bank6WSTOENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTOENR6;

assign NextSMBWSTWENR6[3:0] = (Bank6WSTWENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTWENR6;

assign NextSMBCR6[21:0] = (Bank6CtrlWen == 1'b1) ? HWDATAREG[21:0]   : SMBCR6;

assign Bank6ToutClr     = (Bank6StatWen == 1'b1) ? HWDATAREG[0]      : 1'b0;

assign NextSMBIDCYCR7[3:0] = (Bank7IDCYCWen == 1'b1) ? HWDATAREG[3:0] :
                             SMBIDCYCR7;

assign NextSMBWSTRDR7[4:0] = (Bank7WSTRDWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTRDR7;

assign NextSMBWSTBRDR7[4:0] = (Bank7WSTBRDWen == 1'b1) ? HWDATAREG[4:0] :
                              SMBWSTBRDR7;

assign NextSMBWSTWRR7[4:0] = (Bank7WSTWRWen == 1'b1) ? HWDATAREG[4:0] :
                             SMBWSTWRR7;

assign NextSMBWSTOENR7[3:0] = (Bank7WSTOENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTOENR7;

assign NextSMBWSTWENR7[3:0] = (Bank7WSTWENWen == 1'b1) ? HWDATAREG[3:0] :
                              SMBWSTWENR7;

assign Bank7ToutClr     = (Bank7StatWen == 1'b1) ? HWDATAREG[0]      : 1'b0;

assign NextMemClkTogl   = ((SMClockWen == 1'b1) &&
                           (SMClockEnReg[2:1] != HWDATAREG[2:1]) &&
                           (iMemClkRegTogl == DelMemClkRegTogl)) ?
                                           ~iMemClkRegTogl : iMemClkRegTogl;

assign NextTestCtrlReg  = (TestCtrlWen == 1'b1) ? HWDATAREG[0] : TestCtrlReg;

assign NextTestCtrlIn[6:0] = (TestCtrlInWen == 1'b1) ? HWDATAREG[6:0] :
                             TestCtrlInReg;

assign NextTestCtrlOut[1:0] = (TestCtrlOutWen == 1'b1) ? HWDATAREG[1:0] :
                              TestCtrlOutReg;

// -----------------------------------------------------------------------------
// This block controls the actual write in HCLK domain. Here depending
// on the register enable signals the data from the data bus is registered
// on to the corresponding registers(SMBCR7).
// -----------------------------------------------------------------------------
always @(Bank7CtrlWen or HWDATAREG or SMMWCS7 or SMBCR7 or SoftWrMW7Reg or
         SMBLS7POL or SoftWrBLS7Reg)
begin : p_WriteComb1
  NextSMBCR7       = SMBCR7;
  if (Bank7CtrlWen == 1'b1)
     NextSMBCR7[21:0] = HWDATAREG[21:0];
  else
    begin
      if (SoftWrMW7Reg == 1'b0)
        NextSMBCR7[5:4]  = SMMWCS7;

      if (SoftWrBLS7Reg == 1'b0)
        NextSMBCR7[6]  = SMBLS7POL;
    end
end // p_WriteComb1

// -----------------------------------------------------------------------------
// This block controls the actual write in HCLK domain. Here depending
// on the register enable signals the data from the data bus is registered
// on to the corresponding registers(SMClockEnReg).
// -----------------------------------------------------------------------------
always @(SMClockWen or HWDATAREG or SMClockEnReg or SoftWrClkReg or
         IntClockRatio)
begin : p_WriteComb2
  NextSMClockEnReg = SMClockEnReg;
  if (SMClockWen == 1'b1)
     NextSMClockEnReg      = HWDATAREG[2:0];
  else if (SoftWrClkReg == 1'b0)
     NextSMClockEnReg[2:1] = IntClockRatio;
end // p_WriteComb2

// -----------------------------------------------------------------------------
// Registering the next state inputs
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_WriteSeq
  if (HRESETn == 1'b0)
    begin
      SMBIDCYCR0       <= 4'b1111;
      SMBWSTRDR0       <= 5'b11111;
      SMBWSTBRDR0      <= 5'b11111;
      SMBWSTWRR0       <= 5'b11111;
      SMBWSTOENR0      <= 4'b0000;
      SMBWSTWENR0      <= 4'b0001;
      SMBCR0           <= 22'b1100000011000000100000;
 
      SMBIDCYCR1       <= 4'b1111;
      SMBWSTRDR1       <= 5'b11111;
      SMBWSTBRDR1      <= 5'b11111;
      SMBWSTWRR1       <= 5'b11111;
      SMBWSTOENR1      <= 4'b0000;
      SMBWSTWENR1      <= 4'b0001;
      SMBCR1           <= 22'b1100000011000000000000;
 
      SMBIDCYCR2       <= 4'b1111;
      SMBWSTRDR2       <= 5'b11111;
      SMBWSTBRDR2      <= 5'b11111;
      SMBWSTWRR2       <= 5'b11111;
      SMBWSTOENR2      <= 4'b0000;
      SMBWSTWENR2      <= 4'b0001;
      SMBCR2           <= 22'b1100000011000000010000;
 
      SMBIDCYCR3       <= 4'b1111;
      SMBWSTRDR3       <= 5'b11111;
      SMBWSTBRDR3      <= 5'b11111;
      SMBWSTWRR3       <= 5'b11111;
      SMBWSTOENR3      <= 4'b0000;
      SMBWSTWENR3      <= 4'b0001;
      SMBCR3           <= 22'b1100000011000000000000;
 
      SMBIDCYCR4       <= 4'b1111;
      SMBWSTRDR4       <= 5'b11111;
      SMBWSTBRDR4      <= 5'b11111;
      SMBWSTWRR4       <= 5'b11111;
      SMBWSTOENR4      <= 4'b0000;
      SMBWSTWENR4      <= 4'b0001;
      SMBCR4           <= 22'b1100000011000000100000;
 
      SMBIDCYCR5       <= 4'b1111;
      SMBWSTRDR5       <= 5'b11111;
      SMBWSTBRDR5      <= 5'b11111;
      SMBWSTWRR5       <= 5'b11111;
      SMBWSTOENR5      <= 4'b0000;
      SMBWSTWENR5      <= 4'b0001;
      SMBCR5           <= 22'b1100000011000000100000;
 
      SMBIDCYCR6       <= 4'b1111;
      SMBWSTRDR6       <= 5'b11111;
      SMBWSTBRDR6      <= 5'b11111;
      SMBWSTWRR6       <= 5'b11111;
      SMBWSTOENR6      <= 4'b0000;
      SMBWSTWENR6      <= 4'b0001;
      SMBCR6           <= 22'b1100000011000000010000;
 
      SMBIDCYCR7       <= 4'b1111;
      SMBWSTRDR7       <= 5'b11111;
      SMBWSTBRDR7      <= 5'b11111;
      SMBWSTWRR7       <= 5'b11111;
      SMBWSTOENR7      <= 4'b0000;
      SMBWSTWENR7      <= 4'b0001;
      SMBCR7           <= 22'b1100000011000000000000;
 
      SMClockEnReg     <= 3'b001;
 
      TestCtrlReg      <= 1'b0;
      TestCtrlInReg    <= 7'b0000000;
      TestCtrlOutReg   <= 2'b00;
 
      SMBTOUTR0        <= 1'b0;
      SMBTOUTR1        <= 1'b0;
      SMBTOUTR2        <= 1'b0;
      SMBTOUTR3        <= 1'b0;
      SMBTOUTR4        <= 1'b0;
      SMBTOUTR5        <= 1'b0;
      SMBTOUTR6        <= 1'b0;
      SMBTOUTR7        <= 1'b0;
 
      iHRDATAREG       <= 32'b00000000000000000000000000000000;
      iMW1             <= 2'b00;
      iWaitEn1         <= 1'b0;
      iWrapRead        <= 1'b0;
      iSyncEnRead1     <= 1'b0;
      iWP1             <= 1'b0;
      iSyncEnWrite1    <= 1'b0;
    end
  else
    begin
      SMBIDCYCR0       <= NextSMBIDCYCR0;
      SMBWSTRDR0       <= NextSMBWSTRDR0;
      SMBWSTBRDR0      <= NextSMBWSTBRDR0;
      SMBWSTWRR0       <= NextSMBWSTWRR0;
      SMBWSTOENR0      <= NextSMBWSTOENR0;
      SMBWSTWENR0      <= NextSMBWSTWENR0;
      SMBCR0           <= NextSMBCR0;
 
      SMBIDCYCR1       <= NextSMBIDCYCR1;
      SMBWSTRDR1       <= NextSMBWSTRDR1;
      SMBWSTBRDR1      <= NextSMBWSTBRDR1;
      SMBWSTWRR1       <= NextSMBWSTWRR1;
      SMBWSTOENR1      <= NextSMBWSTOENR1;
      SMBWSTWENR1      <= NextSMBWSTWENR1;
      SMBCR1           <= NextSMBCR1;
 
      SMBIDCYCR2       <= NextSMBIDCYCR2;
      SMBWSTRDR2       <= NextSMBWSTRDR2;
      SMBWSTBRDR2      <= NextSMBWSTBRDR2;
      SMBWSTWRR2       <= NextSMBWSTWRR2;
      SMBWSTOENR2      <= NextSMBWSTOENR2;
      SMBWSTWENR2      <= NextSMBWSTWENR2;
      SMBCR2           <= NextSMBCR2;
 
      SMBIDCYCR3       <= NextSMBIDCYCR3;
      SMBWSTRDR3       <= NextSMBWSTRDR3;
      SMBWSTBRDR3      <= NextSMBWSTBRDR3;
      SMBWSTWRR3       <= NextSMBWSTWRR3;
      SMBWSTOENR3      <= NextSMBWSTOENR3;
      SMBWSTWENR3      <= NextSMBWSTWENR3;
      SMBCR3           <= NextSMBCR3;
 
      SMBIDCYCR4       <= NextSMBIDCYCR4;
      SMBWSTRDR4       <= NextSMBWSTRDR4;
      SMBWSTBRDR4      <= NextSMBWSTBRDR4;
      SMBWSTWRR4       <= NextSMBWSTWRR4;
      SMBWSTOENR4      <= NextSMBWSTOENR4;
      SMBWSTWENR4      <= NextSMBWSTWENR4;
      SMBCR4           <= NextSMBCR4;
 
      SMBIDCYCR5       <= NextSMBIDCYCR5;
      SMBWSTRDR5       <= NextSMBWSTRDR5;
      SMBWSTBRDR5      <= NextSMBWSTBRDR5;
      SMBWSTWRR5       <= NextSMBWSTWRR5;
      SMBWSTOENR5      <= NextSMBWSTOENR5;
      SMBWSTWENR5      <= NextSMBWSTWENR5;
      SMBCR5           <= NextSMBCR5;
 
      SMBIDCYCR6       <= NextSMBIDCYCR6;
      SMBWSTRDR6       <= NextSMBWSTRDR6;
      SMBWSTBRDR6      <= NextSMBWSTBRDR6;
      SMBWSTWRR6       <= NextSMBWSTWRR6;
      SMBWSTOENR6      <= NextSMBWSTOENR6;
      SMBWSTWENR6      <= NextSMBWSTWENR6;
      SMBCR6           <= NextSMBCR6;
 
      SMBIDCYCR7       <= NextSMBIDCYCR7;
      SMBWSTRDR7       <= NextSMBWSTRDR7;
      SMBWSTBRDR7      <= NextSMBWSTBRDR7;
      SMBWSTWRR7       <= NextSMBWSTWRR7;
      SMBWSTOENR7      <= NextSMBWSTOENR7;
      SMBWSTWENR7      <= NextSMBWSTWENR7;
      SMBCR7           <= NextSMBCR7;
 
      SMClockEnReg     <= NextSMClockEnReg;
      TestCtrlReg      <= NextTestCtrlReg;
      TestCtrlInReg    <= NextTestCtrlIn;
      TestCtrlOutReg   <= NextTestCtrlOut;
 
      SMBTOUTR0        <= NextSMBTOUTR0;
      SMBTOUTR1        <= NextSMBTOUTR1;
      SMBTOUTR2        <= NextSMBTOUTR2;
      SMBTOUTR3        <= NextSMBTOUTR3;
      SMBTOUTR4        <= NextSMBTOUTR4;
      SMBTOUTR5        <= NextSMBTOUTR5;
      SMBTOUTR6        <= NextSMBTOUTR6;
      SMBTOUTR7        <= NextSMBTOUTR7;
 
      iHRDATAREG       <= NextHrdataReg;
      iMW1             <= NextMW1;
      iWaitEn1         <= NextWaitEn1;
      iWrapRead        <= NextWrapRead;
      iSyncEnRead1     <= NextSyncEnRead1;
      iWP1             <= NextWP1;
      iSyncEnWrite1    <= NextSyncEnWrite1;
    end
end // p_WriteSeq

// -----------------------------------------------------------------------------
// Read data path logic
// This  block controls the actual read operation.
// Depending on the address location for which the Master wants to read,
// corresponding data from that register is put on the data bus.
// -----------------------------------------------------------------------------
always @(SMBIDCYCR0 or SMBWSTRDR0 or SMBWSTBRDR0 or SMBWSTWRR0 or SMBWSTOENR0 or
         SMBWSTWENR0 or SMBCR0 or SMBIDCYCR1 or SMBWSTRDR1 or SMBWSTBRDR1 or
         SMBWSTWRR1 or SMBWSTOENR1 or SMBWSTWENR1 or SMBCR1 or SMBIDCYCR2 or
         SMBWSTRDR2 or SMBWSTBRDR2 or SMBWSTWRR2 or SMBWSTOENR2 or
         SMBWSTWENR2 or SMBCR2 or SMBIDCYCR3 or SMBWSTRDR3 or SMBWSTBRDR3 or
         SMBWSTWRR3 or SMBWSTOENR3 or SMBWSTWENR3 or SMBCR3 or SMBIDCYCR4 or
         SMBWSTRDR4 or SMBWSTBRDR4 or SMBWSTWRR4 or SMBWSTOENR4 or
         SMBWSTWENR4 or SMBCR4 or SMBIDCYCR5 or SMBWSTRDR5 or SMBWSTBRDR5 or
         SMBWSTWRR5 or SMBWSTOENR5 or SMBWSTWENR5 or SMBCR5 or SMBIDCYCR6 or
         SMBWSTRDR6 or SMBWSTBRDR6 or SMBWSTWRR6 or SMBWSTOENR6 or
         SMBWSTWENR6 or SMBCR6 or SMBIDCYCR7 or SMBWSTRDR7 or SMBWSTBRDR7 or
         SMBWSTWRR7 or SMBWSTOENR7 or SMBWSTWENR7 or SMBCR7 or AddressBuf or
         SSMCPERIPHID0 or SSMCPERIPHID1 or SSMCPERIPHID2 or SSMCPERIPHID3 or
         SSMCPCELLID0 or SSMCPCELLID1 or SSMCPCELLID2 or SSMCPCELLID3 or
         WaitStatus or SMClockEnReg or TestCtrlReg or iSMTICBUSREQEBI or
         iSMBUSREQEBI or iSMTICBUSGNTExt or SMBUSGNTTest or iBUSMUXEXT or
         iHRDATAREG or IntClockRatio or iBIGENDIAN or Revision or SMBTOUTR0 or
         SMBTOUTR1 or SMBTOUTR2 or SMBTOUTR3 or SMBTOUTR4 or SMBTOUTR5 or
         SMBTOUTR6 or SMBTOUTR7 or iSmBusBackOffExt)
begin : p_ReadComb
  NextHrdataReg    = iHRDATAREG;
  case (AddressBuf)
    `HADDR_SMBIDCYR0 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBIDCYCR0});

    `HADDR_SMBWSTRDR0 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTRDR0});

    `HADDR_SMBWSTWRR0 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTWRR0});

    `HADDR_SMBWSTOENR0 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTOENR0});

    `HADDR_SMBWSTWENR0 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTWENR0});

    `HADDR_SMBCR0 :
      NextHrdataReg    = ({10'b0000000000, SMBCR0});

    `HADDR_SMBSR0 :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, SMBTOUTR0});

    `HADDR_SMBWSTBRDR0 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTBRDR0});

    `HADDR_SMBIDCYR1 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBIDCYCR1});

    `HADDR_SMBWSTRDR1 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTRDR1});

    `HADDR_SMBWSTWRR1 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTWRR1});

    `HADDR_SMBWSTOENR1 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTOENR1});

    `HADDR_SMBWSTWENR1 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTWENR1});

    `HADDR_SMBCR1 :
      NextHrdataReg    = ({10'b0000000000, SMBCR1});

    `HADDR_SMBSR1 :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, SMBTOUTR1});

    `HADDR_SMBWSTBRDR1 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTBRDR1});

    `HADDR_SMBIDCYR2 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBIDCYCR2});

    `HADDR_SMBWSTRDR2 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTRDR2});

    `HADDR_SMBWSTOENR2 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTOENR2});

    `HADDR_SMBWSTWRR2 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTWRR2});

    `HADDR_SMBWSTWENR2 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTWENR2});

    `HADDR_SMBCR2 :
      NextHrdataReg    = ({10'b0000000000, SMBCR2});

    `HADDR_SMBSR2 :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, SMBTOUTR2});

    `HADDR_SMBWSTBRDR2 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTBRDR2});

    `HADDR_SMBIDCYR3 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBIDCYCR3});

    `HADDR_SMBWSTRDR3 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTRDR3});

    `HADDR_SMBWSTOENR3 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTOENR3});

    `HADDR_SMBWSTWRR3 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTWRR3});

    `HADDR_SMBWSTWENR3 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTWENR3});

    `HADDR_SMBCR3 :
      NextHrdataReg    = ({10'b0000000000, SMBCR3});

    `HADDR_SMBSR3 :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, SMBTOUTR3});

    `HADDR_SMBWSTBRDR3 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTBRDR3});

    `HADDR_SMBIDCYR4 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBIDCYCR4});

    `HADDR_SMBWSTRDR4 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTRDR4});

    `HADDR_SMBWSTOENR4 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTOENR4});

    `HADDR_SMBWSTWRR4 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTWRR4});

    `HADDR_SMBWSTWENR4 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTWENR4});

    `HADDR_SMBCR4 :
      NextHrdataReg    = ({10'b0000000000, SMBCR4});

    `HADDR_SMBSR4 :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, SMBTOUTR4});

    `HADDR_SMBWSTBRDR4 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTBRDR4});

    `HADDR_SMBIDCYR5 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBIDCYCR5});

    `HADDR_SMBWSTRDR5 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTRDR5});

    `HADDR_SMBWSTOENR5 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTOENR5});

    `HADDR_SMBWSTWRR5 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTWRR5});

    `HADDR_SMBWSTWENR5 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTWENR5});

    `HADDR_SMBCR5 :
      NextHrdataReg    = ({10'b0000000000, SMBCR5});

    `HADDR_SMBSR5 :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, SMBTOUTR5});

    `HADDR_SMBWSTBRDR5 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTBRDR5});

    `HADDR_SMBIDCYR6 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBIDCYCR6});

    `HADDR_SMBWSTRDR6 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTRDR6});

    `HADDR_SMBWSTOENR6 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTOENR6});

    `HADDR_SMBWSTWRR6 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTWRR6});

    `HADDR_SMBWSTWENR6 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTWENR6});

    `HADDR_SMBCR6 :
      NextHrdataReg    = ({10'b0000000000, SMBCR6});

    `HADDR_SMBSR6 :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, SMBTOUTR6});

    `HADDR_SMBWSTBRDR6 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTBRDR6});

    `HADDR_SMBIDCYR7 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBIDCYCR7});

    `HADDR_SMBWSTRDR7 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTRDR7});

    `HADDR_SMBWSTOENR7 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTOENR7});

    `HADDR_SMBWSTWRR7 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTWRR7});

    `HADDR_SMBWSTWENR7 :
      NextHrdataReg    = ({28'b0000000000000000000000000000, SMBWSTWENR7});

    `HADDR_SMBCR7 :
      NextHrdataReg    = ({10'b0000000000, SMBCR7});

    `HADDR_SMBSR7 :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, SMBTOUTR7});

    `HADDR_SMBWSTBRDR7 :
      NextHrdataReg    = ({27'b000000000000000000000000000, SMBWSTBRDR7});

    `HADDR_SMCR :
      NextHrdataReg    = ({29'b00000000000000000000000000000,
                           SMClockEnReg[2:0]});
    `HADDR_SMSR :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, WaitStatus});

    `HADDR_SMITCR :
      NextHrdataReg    = ({31'b0000000000000000000000000000000, TestCtrlReg});

    `HADDR_SMITIP :
      NextHrdataReg    = ({25'b0000000000000000000000000, iSmBusBackOffExt,
                           iSMTICBUSGNTExt, SMBUSGNTTest, iBUSMUXEXT,
                           IntClockRatio, iBIGENDIAN});

    `HADDR_SMITOP :
      NextHrdataReg    = ({30'b000000000000000000000000000000, iSMTICBUSREQEBI,
                           iSMBUSREQEBI});

    `HADDR_SSMCPERIPHID0 :
      NextHrdataReg    = ({24'b000000000000000000000000, SSMCPERIPHID0});

    `HADDR_SSMCPERIPHID1 :
      NextHrdataReg    = ({24'b000000000000000000000000, SSMCPERIPHID1});

    `HADDR_SSMCPERIPHID2 :
      NextHrdataReg    = ({24'b000000000000000000000000, Revision,
                           SSMCPERIPHID2});

    `HADDR_SSMCPERIPHID3 :
      NextHrdataReg    = ({24'b000000000000000000000000, SSMCPERIPHID3});

    `HADDR_SSMCPCELLID0 :
      NextHrdataReg    = ({24'b000000000000000000000000, SSMCPCELLID0});

    `HADDR_SSMCPCELLID1 :
      NextHrdataReg    = ({24'b000000000000000000000000, SSMCPCELLID1});

    `HADDR_SSMCPCELLID2 :
      NextHrdataReg    = ({24'b000000000000000000000000, SSMCPCELLID2});

    `HADDR_SSMCPCELLID3 :
      NextHrdataReg    = ({24'b000000000000000000000000, SSMCPCELLID3});

    default :
      ;
  endcase
end // p_ReadComb

// -----------------------------------------------------------------------------
// Few bank informations are registered separately to meet timing
// -----------------------------------------------------------------------------
always @(SMBCR0 or SMBCR1 or SMBCR2 or SMBCR3 or SMBCR4 or SMBCR5 or
         SMBCR6 or SMBCR7 or iMW1 or HSELSMC or HTRANSSMC or iWaitEn1 or
         iWrapRead or iSyncEnRead1 or iWP1 or iSyncEnWrite1 or HREADYINSMC)
begin : p_FewBnkInfoComb
  NextMW1          = iMW1;
  NextWaitEn1      = iWaitEn1;
  NextWrapRead     = iWrapRead;
  NextSyncEnRead1  = iSyncEnRead1;
  NextWP1          = iWP1;
  NextSyncEnWrite1 = iSyncEnWrite1;
  if ((HTRANSSMC & HREADYINSMC) == 1'b1)
    begin
      case (HSELSMC)
        `BANK0 :
          begin
            NextMW1          = SMBCR0[5:4];
            NextWaitEn1      = SMBCR0[2];
            NextWrapRead     = SMBCR0[14];
            NextSyncEnRead1  = SMBCR0[9];
            NextWP1          = SMBCR0[3];
            NextSyncEnWrite1 = SMBCR0[17];
          end
    
        `BANK1 :
          begin
            NextMW1          = SMBCR1[5:4];
            NextWaitEn1      = SMBCR1[2];
            NextWrapRead     = SMBCR1[14];
            NextSyncEnRead1  = SMBCR1[9];
            NextWP1          = SMBCR1[3];
            NextSyncEnWrite1 = SMBCR1[17];
          end
    
        `BANK2 :
          begin
            NextMW1          = SMBCR2[5:4];
            NextWaitEn1      = SMBCR2[2];
            NextWrapRead     = SMBCR2[14];
            NextSyncEnRead1  = SMBCR2[9];
            NextWP1          = SMBCR2[3];
            NextSyncEnWrite1 = SMBCR2[17];
          end
    
        `BANK3 :
          begin
            NextMW1          = SMBCR3[5:4];
            NextWaitEn1      = SMBCR3[2];
            NextWrapRead     = SMBCR3[14];
            NextSyncEnRead1  = SMBCR3[9];
            NextWP1          = SMBCR3[3];
            NextSyncEnWrite1 = SMBCR3[17];
          end
    
        `BANK4 :
          begin
            NextMW1          = SMBCR4[5:4];
            NextWaitEn1      = SMBCR4[2];
            NextWrapRead     = SMBCR4[14];
            NextSyncEnRead1  = SMBCR4[9];
            NextWP1          = SMBCR4[3];
            NextSyncEnWrite1 = SMBCR4[17];
          end
    
        `BANK5 :
          begin
            NextMW1          = SMBCR5[5:4];
            NextWaitEn1      = SMBCR5[2];
            NextWrapRead     = SMBCR5[14];
            NextSyncEnRead1  = SMBCR5[9];
            NextWP1          = SMBCR5[3];
            NextSyncEnWrite1 = SMBCR5[17];
          end
    
        `BANK6 :
          begin
            NextMW1          = SMBCR6[5:4];
            NextWaitEn1      = SMBCR6[2];
            NextWrapRead     = SMBCR6[14];
            NextSyncEnRead1  = SMBCR6[9];
            NextWP1          = SMBCR6[3];
            NextSyncEnWrite1 = SMBCR6[17];
          end
    
        `BANK7 :
          begin
            NextMW1          = SMBCR7[5:4];
            NextWaitEn1      = SMBCR7[2];
            NextWrapRead     = SMBCR7[14];
            NextSyncEnRead1  = SMBCR7[9];
            NextWP1          = SMBCR7[3];
            NextSyncEnWrite1 = SMBCR7[17];
          end
    
         default :
           ;
      endcase
    end
end // p_FewBnkInfoComb

// -----------------------------------------------------------------------------
// Routing the Memory Bank Resources for other modules.
// These resources are required while making state transitions, Turnaround
// decision, when degranted...
// HselMemBuf1 is used as multiplexer select input to decide the bank number.
// -----------------------------------------------------------------------------
always @(SMBCR0 or SMBWSTRDR0 or SMBWSTBRDR0 or SMBWSTWRR0 or SMBWSTOENR0 or
         SMBWSTWENR0 or SMBIDCYCR0 or SMBCR1 or SMBWSTRDR1 or SMBWSTBRDR1 or
         SMBWSTWRR1 or SMBWSTOENR1 or SMBWSTWENR1 or SMBIDCYCR1 or SMBCR2 or
         SMBWSTRDR2 or SMBWSTBRDR2 or SMBWSTWRR2 or SMBWSTOENR2 or
         SMBWSTWENR2 or SMBIDCYCR2 or SMBCR3 or SMBWSTRDR3 or SMBWSTBRDR3 or
         SMBWSTWRR3 or SMBWSTOENR3 or SMBWSTWENR3 or SMBIDCYCR3 or SMBCR4 or
         SMBWSTRDR4 or SMBWSTBRDR4 or SMBWSTWRR4 or SMBWSTOENR4 or
         SMBWSTWENR4 or SMBIDCYCR4 or SMBCR5 or SMBWSTRDR5 or SMBWSTBRDR5 or
         SMBWSTWRR5 or SMBWSTOENR5 or SMBWSTWENR5 or SMBIDCYCR5 or SMBCR6 or
         SMBWSTRDR6 or SMBWSTBRDR6 or SMBWSTWRR6 or SMBWSTOENR6 or
         SMBWSTWENR6 or SMBIDCYCR6 or SMBCR7 or SMBWSTRDR7 or SMBWSTBRDR7 or
         SMBWSTWRR7 or SMBWSTOENR7 or SMBWSTWENR7 or SMBIDCYCR7 or HselMemBuf1)
begin : p_BankInfoMux
  BIWriteEn1       = 1'b0;
  AddrValWriteEn1  = 1'b0;
  BurstLenWrite1   = 2'b00;
  BMWrite1         = 1'b0;
  BIReadEn1        = 1'b0;
  AddrValidReadEn1 = 1'b0;
  BurstLenRead1    = 2'b00;
  BMRead1          = 1'b0;
  SMBLSPol1        = 1'b0;
  WaitPol1         = 1'b0;
  RBLE1            = 1'b0;
  WSTRD1           = 5'b11111;
  WSTBRD1          = 5'b11111;
  WSTWR1           = 5'b11111;
  WSTOEN1          = 4'b0000;
  WSTWEN1          = 4'b0001;
  IDCYC1           = 4'b1111;
  case (HselMemBuf1)
    `BANK0 :
      begin
        BIWriteEn1       = SMBCR0[21];
        AddrValWriteEn1  = SMBCR0[20];
        BurstLenWrite1   = SMBCR0[19:18];
        BMWrite1         = SMBCR0[16];
        BIReadEn1        = SMBCR0[13];
        AddrValidReadEn1 = SMBCR0[12];
        BurstLenRead1    = SMBCR0[11:10];
        BMRead1          = SMBCR0[8];
        SMBLSPol1        = SMBCR0[6];
        WaitPol1         = SMBCR0[1];
        RBLE1            = SMBCR0[0];
        WSTRD1           = SMBWSTRDR0;
        WSTBRD1          = SMBWSTBRDR0;
        WSTWR1           = SMBWSTWRR0;
        WSTOEN1          = SMBWSTOENR0;
        WSTWEN1          = SMBWSTWENR0;
        IDCYC1           = SMBIDCYCR0;
      end

    `BANK1 :
      begin
        BIWriteEn1       = SMBCR1[21];
        AddrValWriteEn1  = SMBCR1[20];
        BurstLenWrite1   = SMBCR1[19:18];
        BMWrite1         = SMBCR1[16];
        BIReadEn1        = SMBCR1[13];
        AddrValidReadEn1 = SMBCR1[12];
        BurstLenRead1    = SMBCR1[11:10];
        BMRead1          = SMBCR1[8];
        SMBLSPol1        = SMBCR1[6];
        WaitPol1         = SMBCR1[1];
        RBLE1            = SMBCR1[0];
        WSTRD1           = SMBWSTRDR1;
        WSTBRD1          = SMBWSTBRDR1;
        WSTWR1           = SMBWSTWRR1;
        WSTOEN1          = SMBWSTOENR1;
        WSTWEN1          = SMBWSTWENR1;
        IDCYC1           = SMBIDCYCR1;
      end

    `BANK2 :
      begin
        BIWriteEn1       = SMBCR2[21];
        AddrValWriteEn1  = SMBCR2[20];
        BurstLenWrite1   = SMBCR2[19:18];
        BMWrite1         = SMBCR2[16];
        BIReadEn1        = SMBCR2[13];
        AddrValidReadEn1 = SMBCR2[12];
        BurstLenRead1    = SMBCR2[11:10];
        BMRead1          = SMBCR2[8];
        SMBLSPol1        = SMBCR2[6];
        WaitPol1         = SMBCR2[1];
        RBLE1            = SMBCR2[0];
        WSTRD1           = SMBWSTRDR2;
        WSTBRD1          = SMBWSTBRDR2;
        WSTWR1           = SMBWSTWRR2;
        WSTOEN1          = SMBWSTOENR2;
        WSTWEN1          = SMBWSTWENR2;
        IDCYC1           = SMBIDCYCR2;
      end

    `BANK3 :
      begin
        BIWriteEn1       = SMBCR3[21];
        AddrValWriteEn1  = SMBCR3[20];
        BurstLenWrite1   = SMBCR3[19:18];
        BMWrite1         = SMBCR3[16];
        BIReadEn1        = SMBCR3[13];
        AddrValidReadEn1 = SMBCR3[12];
        BurstLenRead1    = SMBCR3[11:10];
        BMRead1          = SMBCR3[8];
        SMBLSPol1        = SMBCR3[6];
        WaitPol1         = SMBCR3[1];
        RBLE1            = SMBCR3[0];
        WSTRD1           = SMBWSTRDR3;
        WSTBRD1          = SMBWSTBRDR3;
        WSTWR1           = SMBWSTWRR3;
        WSTOEN1          = SMBWSTOENR3;
        WSTWEN1          = SMBWSTWENR3;
        IDCYC1           = SMBIDCYCR3;
      end

    `BANK4 :
      begin
        BIWriteEn1       = SMBCR4[21];
        AddrValWriteEn1  = SMBCR4[20];
        BurstLenWrite1   = SMBCR4[19:18];
        BMWrite1         = SMBCR4[16];
        BIReadEn1        = SMBCR4[13];
        AddrValidReadEn1 = SMBCR4[12];
        BurstLenRead1    = SMBCR4[11:10];
        BMRead1          = SMBCR4[8];
        SMBLSPol1        = SMBCR4[6];
        WaitPol1         = SMBCR4[1];
        RBLE1            = SMBCR4[0];
        WSTRD1           = SMBWSTRDR4;
        WSTBRD1          = SMBWSTBRDR4;
        WSTWR1           = SMBWSTWRR4;
        WSTOEN1          = SMBWSTOENR4;
        WSTWEN1          = SMBWSTWENR4;
        IDCYC1           = SMBIDCYCR4;
      end

    `BANK5 :
      begin
        BIWriteEn1       = SMBCR5[21];
        AddrValWriteEn1  = SMBCR5[20];
        BurstLenWrite1   = SMBCR5[19:18];
        BMWrite1         = SMBCR5[16];
        BIReadEn1        = SMBCR5[13];
        AddrValidReadEn1 = SMBCR5[12];
        BurstLenRead1    = SMBCR5[11:10];
        BMRead1          = SMBCR5[8];
        SMBLSPol1        = SMBCR5[6];
        WaitPol1         = SMBCR5[1];
        RBLE1            = SMBCR5[0];
        WSTRD1           = SMBWSTRDR5;
        WSTBRD1          = SMBWSTBRDR5;
        WSTWR1           = SMBWSTWRR5;
        WSTOEN1          = SMBWSTOENR5;
        WSTWEN1          = SMBWSTWENR5;
        IDCYC1           = SMBIDCYCR5;
      end

    `BANK6 :
      begin
        BIWriteEn1       = SMBCR6[21];
        AddrValWriteEn1  = SMBCR6[20];
        BurstLenWrite1   = SMBCR6[19:18];
        BMWrite1         = SMBCR6[16];
        BIReadEn1        = SMBCR6[13];
        AddrValidReadEn1 = SMBCR6[12];
        BurstLenRead1    = SMBCR6[11:10];
        BMRead1          = SMBCR6[8];
        SMBLSPol1        = SMBCR6[6];
        WaitPol1         = SMBCR6[1];
        RBLE1            = SMBCR6[0];
        WSTRD1           = SMBWSTRDR6;
        WSTBRD1          = SMBWSTBRDR6;
        WSTWR1           = SMBWSTWRR6;
        WSTOEN1          = SMBWSTOENR6;
        WSTWEN1          = SMBWSTWENR6;
        IDCYC1           = SMBIDCYCR6;
      end

    `BANK7 :
      begin
        BIWriteEn1       = SMBCR7[21];
        AddrValWriteEn1  = SMBCR7[20];
        BurstLenWrite1   = SMBCR7[19:18];
        BMWrite1         = SMBCR7[16];
        BIReadEn1        = SMBCR7[13];
        AddrValidReadEn1 = SMBCR7[12];
        BurstLenRead1    = SMBCR7[11:10];
        BMRead1          = SMBCR7[8];
        SMBLSPol1        = SMBCR7[6];
        WaitPol1         = SMBCR7[1];
        RBLE1            = SMBCR7[0];
        WSTRD1           = SMBWSTRDR7;
        WSTBRD1          = SMBWSTBRDR7;
        WSTWR1           = SMBWSTWRR7;
        WSTOEN1          = SMBWSTOENR7;
        WSTWEN1          = SMBWSTWENR7;
        IDCYC1           = SMBIDCYCR7;
      end
    default :
      ;
  endcase
end // p_BankInfoMux

// ----------------------------------------------------------------------------
// Routing the WaitToutErr to appropriate banks.
// ----------------------------------------------------------------------------
always @(HselMemBuf1 or WaitToutErr)
begin : p_ErrCondGenComb
  Bank0ToutErr     = 1'b0;
  Bank1ToutErr     = 1'b0;
  Bank2ToutErr     = 1'b0;
  Bank3ToutErr     = 1'b0;
  Bank4ToutErr     = 1'b0;
  Bank5ToutErr     = 1'b0;
  Bank6ToutErr     = 1'b0;
  Bank7ToutErr     = 1'b0;

  case (HselMemBuf1)
    `BANK0 :
      Bank0ToutErr     = WaitToutErr;

    `BANK1 :
      Bank1ToutErr     = WaitToutErr;

    `BANK2 :
      Bank2ToutErr     = WaitToutErr;

    `BANK3 :
      Bank3ToutErr     = WaitToutErr;

    `BANK4 :
      Bank4ToutErr     = WaitToutErr;

    `BANK5 :
      Bank5ToutErr     = WaitToutErr;

    `BANK6 :
      Bank6ToutErr     = WaitToutErr;

    `BANK7 :
      Bank7ToutErr     = WaitToutErr;

    default :
      ;
  endcase
end // p_ErrCondGenComb

// ----------------------------------------------------------------------------
// Registering and clearing the WaitToutErr for appropriate banks.
// ----------------------------------------------------------------------------
assign NextSMBTOUTR0    = (Bank0ToutErr == 1'b1) ? 1'b1 :
                           ((Bank0ToutClr == 1'b1) ? 1'b0 : SMBTOUTR0);

assign NextSMBTOUTR1    = (Bank1ToutErr == 1'b1) ? 1'b1 :
                           ((Bank1ToutClr == 1'b1) ? 1'b0 : SMBTOUTR1);

assign NextSMBTOUTR2    = (Bank2ToutErr == 1'b1) ? 1'b1 :
                           ((Bank2ToutClr == 1'b1) ? 1'b0 : SMBTOUTR2);

assign NextSMBTOUTR3    = (Bank3ToutErr == 1'b1) ? 1'b1 :
                           ((Bank3ToutClr == 1'b1) ? 1'b0 : SMBTOUTR3);

assign NextSMBTOUTR4    = (Bank4ToutErr == 1'b1) ? 1'b1 :
                           ((Bank4ToutClr == 1'b1) ? 1'b0 : SMBTOUTR4);

assign NextSMBTOUTR5    = (Bank5ToutErr == 1'b1) ? 1'b1 :
                           ((Bank5ToutClr == 1'b1) ? 1'b0 : SMBTOUTR5);

assign NextSMBTOUTR6    = (Bank6ToutErr == 1'b1) ? 1'b1 :
                           ((Bank6ToutClr == 1'b1) ? 1'b0 : SMBTOUTR6);

assign NextSMBTOUTR7    = (Bank7ToutErr == 1'b1) ? 1'b1 :
                           ((Bank7ToutClr == 1'b1) ? 1'b0 : SMBTOUTR7);

// ----------------------------------------------------------------------------
// Integration Output Mux Implementation.
// ----------------------------------------------------------------------------
assign iSMTICBUSREQEBI  = (TestCtrlReg == 1'b1) ? TestCtrlOutReg[1]  :
                           SMTICBUSREQExt;


assign iSMBUSREQEBI     = (TestCtrlReg == 1'b1) ? TestCtrlOutReg[0]  :
                           SMBUSREQExt;

// ----------------------------------------------------------------------------
// Integration Input Mux Implementation
// ----------------------------------------------------------------------------
assign iSmBusBackOffExt = (TestCtrlReg == 1'b1) ? TestCtrlInReg[6]   :
                           SmBusBackOffReg;

assign iSMTICBUSGNTExt  = (TestCtrlReg == 1'b1) ? TestCtrlInReg[5]   :
                           SmTicGntEbiReg;

assign SMBUSGNTTest     = (TestCtrlReg == 1'b1) ? TestCtrlInReg[4]   :
                           SmBusGntEbiReg;

assign iBUSMUXEXT       = (TestCtrlReg == 1'b1) ? TestCtrlInReg[3]   :
                           SMEXTBUSMUX;

assign IntClockRatio    = (TestCtrlReg == 1'b1) ? TestCtrlInReg[2:1] :
                           SMMEMCLKRATIO;

assign iBIGENDIAN       = (TestCtrlReg == 1'b1) ? TestCtrlInReg[0]   :
                           SMBIGENDIAN;

endmodule
// --================================== End ==================================--
