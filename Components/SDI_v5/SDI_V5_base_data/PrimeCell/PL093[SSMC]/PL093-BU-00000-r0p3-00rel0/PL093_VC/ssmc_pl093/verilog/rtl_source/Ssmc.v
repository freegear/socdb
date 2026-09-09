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
// File Name              : Ssmc.v.rca
// File Revision          : 1.13
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This is the top level structural block of the ARM PrimeCell
//           Synchronous Static Memory Controller Peripheral SSMC_PL093.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module Ssmc (
// Inputs
             HCLK,
             SMMEMCLK,
             nSMMEMCLK,
             SMMEMCLKDELAY,
             SMFBCLK0,
             SMFBCLK1,
             SMFBCLK2,
             SMFBCLK3,
             HRESETn,
             HADDRSMC,
             HTRANSSMC,
             HWRITESMC,
             HSIZESMC,
             HBURSTSMC,
             HWDATASMC,
             HSELSMC,
             HREADYINSMC,
             HADDRREG,
             HTRANSREG,
             HWRITEREG,
             HSIZEREG,
             HWDATAREG,
             HSELREG,
             HREADYINREG,
             HREADYINTIC,
             HRESPTIC,
             HRDATATIC,
             HGRANTTIC,
             SMBUSGNTEBI,
             SMBUSBACKOFFEBI,
             SMTICBUSGNTEBI,
             SMBIGENDIAN,
             SMEXTBUSMUX,
             SCANENABLE,
             SCANINHCLK,
             SCANINSMMEMCLK,
             SCANINnSMMEMCLK,
             SCANINCLKDELAY,
             SCANINFBCLK0,
             SCANINFBCLK1,
             SCANINFBCLK2,
             SCANINFBCLK3,
             SMMWCS7,
             SMBLS7POL,
             SMMEMCLKRATIO,
             SMWAIT,
             SMCANCELWAIT,
             nSMBURSTWAIT,
             SMDATAIN,
             SMTESTREQA,
             SMTESTREQB,
// Outputs
             HRDATASMC,
             HREADYOUTSMC,
             HRESPSMC,
             HRDATAREG,
             HREADYOUTREG,
             HRESPREG,
             HADDRTIC,
             HTRANSTIC,
             HWRITETIC,
             HSIZETIC,
             HBURSTTIC,
             HPROTTIC,
             HWDATATIC,
             HBUSREQTIC,
             HLOCKTIC,
             SMBUSREQEBI,
             SMTICBUSREQEBI,
             SCANOUTHCLK,
             SCANOUTFBCLK0,
             SCANOUTFBCLK1,
             SCANOUTFBCLK2,
             SCANOUTFBCLK3,
             SCANOUTSMMEMCLK,
             SCANOUTnSMMEMCLK,
             SCANOUTCLKDELAY,
             SMCLK,
             SMDATAOUT,
             SMBAA,
             SMADDRVALID,
             SMADDR,
             SMCS0,
             SMCS1,
             SMCS2,
             SMCS3,
             SMCS4,
             SMCS5,
             SMCS6,
             SMCS7,
             nSMCS0,
             nSMCS1,
             nSMCS2,
             nSMCS3,
             nSMCS4,
             nSMCS5,
             nSMCS6,
             nSMCS7,
             nSMDATAEN,
             nSMWEN,
             nSMBLS,
             nSMOEN,
             SMTESTACK
             );

// Inputs
input         HCLK;            // AHB Bus Clock
input         SMMEMCLK;        // Memory Clock
input         nSMMEMCLK;       // Inverted Memory Clock
input         SMMEMCLKDELAY;   // Delayed Memory Clock
input         SMFBCLK0;        // Fedback clock0 from output pad
input         SMFBCLK1;        // Fedback clock1 from output pad
input         SMFBCLK2;        // Fedback clock2 from output pad
input         SMFBCLK3;        // Fedback clock3 from output pad
input         HRESETn;         // AHB system level Reset
input  [25:0] HADDRSMC;        // The address bus input from AHB for Memory
                               // accesses
input   [1:0] HTRANSSMC;       // Indicates current transfer type for Memory
                               // accesses
input         HWRITESMC;       // Indicates direction of transfer (R/W) for
                               // Memory accesses
input   [2:0] HSIZESMC;        // Transfer size indication for Memory accesses
input   [2:0] HBURSTSMC;       // The burst transfer information from AHB for
                               // Memory accesses
input  [31:0] HWDATASMC;       // Write data bus input from AHB for Memory
                               // accesses
input   [7:0] HSELSMC;         // Select signal for Memory transfer to
                               // SSMCCore. One select line for each Memory
                               // Bank
input         HREADYINSMC;     // Transfer completion input signal
input  [11:2] HADDRREG;        // The address bus input from AHB for Register
                               // accesses
input   [1:0] HTRANSREG;       // Indicates current transfer type for Register
                               // accesses. Bit1 of HTRANS on AHB
input         HWRITEREG;       // Indicates direction of transfer (R/W) for
                               // Register accesses
input   [2:0] HSIZEREG;        // Transfer size indication for Register
                               // accesses
input  [31:0] HWDATAREG;       // Write data bus input from AHB for Register
                               // accesses
input         HSELREG;         // Select signal for Register transfer
input         HREADYINREG;     // Transfer completion input signal
input         HREADYINTIC;     // Transfer completion input signal
input   [1:0] HRESPTIC;        // AHB Bus Transfer Response for TIC
input  [31:0] HRDATATIC;       // AHB Read Data Input for TIC
input         HGRANTTIC;       // AHB Bus Grant for TIC
input         SMBUSGNTEBI;     // External bus granted for Memory Transfer
input         SMBUSBACKOFFEBI; // EBI backoff for Memory accesses. Indication
                               // that the current transfer should be completed
                               // as soon as possible
input         SMTICBUSGNTEBI;  // External bus granted for TIC Transfer
input         SMBIGENDIAN;     // Type of endianness of the system
input         SMEXTBUSMUX;     // Static pin indicating if internal DBI or
                               // external EBI is used
input         SCANENABLE;      // Enable for Scan Mode
input         SCANINHCLK;      // Scan chain input with respect to HCLK
input         SCANINSMMEMCLK;  // Scan chain input with respect to SMMEMCLK
input         SCANINnSMMEMCLK; // Scan chain input with respect to nSMMEMCLK
input         SCANINCLKDELAY;  // Scan chain input with respect to SMMEMCLKDELAY
input         SCANINFBCLK0;    // Scan chain input with respect to FBCLK0
input         SCANINFBCLK1;    // Scan chain input with respect to FBCLK1
input         SCANINFBCLK2;    // Scan chain input with respect to FBCLK2
input         SCANINFBCLK3;    // Scan chain input with respect to FBCLK3
input   [1:0] SMMWCS7;         // Static Input pins used to program the memory
                               // width bit field of Bank7 register
input         SMBLS7POL;       // Static Input pin used to program the polarity
                               // of SMBLS bit field of Bank7 register
input   [1:0] SMMEMCLKRATIO;   // Defines Ratio of SMMEMCLK to HCLK
input         SMWAIT;          // Asynchronous Wait signal from External
                               // Memory Controller to delay the transfer
input         SMCANCELWAIT;    // Asynchronous external input, to signal that
                               // SMWAIT has timed out
input   [7:0] nSMBURSTWAIT;    // Synchronous burst Wait signal from External
                               // Memory Controller to delay the transfer
input  [31:0] SMDATAIN;        // Data from Memory to SSMC
input         SMTESTREQA;      // Test bus request A
input         SMTESTREQB;      // Test bus request B, during test this signal
                               // is used in combination with SMTESTREQA

// Outputs
output [31:0] HRDATASMC;       // AHB Read Data output for Memory accesses
output        HREADYOUTSMC;    // Indicates completion of Memory accesses
output  [1:0] HRESPSMC;        // SSMCCore response output, for Memory
                               // accesses
output [31:0] HRDATAREG;       // AHB Read Data output for Register accesses
output        HREADYOUTREG;    // Indicates completion of Register accesses
output  [1:0] HRESPREG;        // SSMCCore response output, for Register
                               // accesses
output [31:0] HADDRTIC;        // AHB Address output from TIC
output  [1:0] HTRANSTIC;       // AHB Transfer type output from TIC
output        HWRITETIC;       // AHB Transfer direction output from TIC
output  [2:0] HSIZETIC;        // AHB Transfer Size output from TIC
output  [2:0] HBURSTTIC;       // AHB Burst Type output from TIC
output  [3:0] HPROTTIC;        // AHB Protection control signal from TIC
output [31:0] HWDATATIC;       // AHB Write Data output from TIC
output        HBUSREQTIC;      // AHB Bus Request from TIC
output        HLOCKTIC;        // AHB signal indicating Locked access to the
                               // Bus from TIC
output        SMBUSREQEBI;     // Request EBI for Memory Transfer
output        SMTICBUSREQEBI;  // Request EBI for TIC Transfer
output        SCANOUTHCLK;     // Scan chain output with respect to HCLK
output        SCANOUTFBCLK0;   // Scan chain output with respect to FBCLK0
output        SCANOUTFBCLK1;   // Scan chain output with respect to FBCLK1
output        SCANOUTFBCLK2;   // Scan chain output with respect to FBCLK2
output        SCANOUTFBCLK3;   // Scan chain output with respect to FBCLK3
output        SCANOUTSMMEMCLK; // Scan chain output with respect to SMMEMCLK
output        SCANOUTnSMMEMCLK;// Scan chain output with respect to nSMMEMCLK
output        SCANOUTCLKDELAY; // Scan chain output with respect to
                               // SMMEMCLKDELAY
output  [3:0] SMCLK;           // Clock for Synchronous memories
output [31:0] SMDATAOUT;       // Data Bus output from SSMC to Memory
output        SMBAA;           // External burst Address advance signal. Used
                               // to advance the address count in the external
                               // Memory device
output        SMADDRVALID;     // External address valid output, used to
                               // indicate when the address output is stable
                               // during synchronous burst transfers
output [25:0] SMADDR;          // External Memory address bus
output        SMCS0;           // Chip Select for Bank0 of external Memory,
                               // active HIGH
output        SMCS1;           // Chip Select for Bank1 of external Memory,
                               // active HIGH
output        SMCS2;           // Chip Select for Bank2 of external Memory,
                               // active HIGH
output        SMCS3;           // Chip Select for Bank3 of external Memory,
                               // active HIGH
output        SMCS4;           // Chip Select for Bank4 of external Memory,
                               // active HIGH
output        SMCS5;           // Chip Select for Bank5 of external Memory,
                               // active HIGH
output        SMCS6;           // Chip Select for Bank6 of external Memory,
                               // active HIGH
output        SMCS7;           // Chip Select for Bank7 of external Memory,
                               // active HIGH
output        nSMCS0;          // Chip Select for Bank0 of external Memory,
                               // active LOW
output        nSMCS1;          // Chip Select for Bank1 of external Memory,
                               // active LOW
output        nSMCS2;          // Chip Select for Bank2 of external Memory,
                               // active LOW
output        nSMCS3;          // Chip Select for Bank3 of external Memory,
                               // active LOW
output        nSMCS4;          // Chip Select for Bank4 of external Memory,
                               // active LOW
output        nSMCS5;          // Chip Select for Bank5 of external Memory,
                               // active LOW
output        nSMCS6;          // Chip Select for Bank6 of external Memory,
                               // active LOW
output        nSMCS7;          // Chip Select for Bank7 of external Memory,
                               // active LOW
output  [3:0] nSMDATAEN;       // Tri-state I/O pad enable for the byte lanes
                               // of external memory data bus
output        nSMWEN;          // Memory Write Enable, Active LOW
output  [3:0] nSMBLS;          // Memory device Byte lane enables
output        nSMOEN;          // Memory Output Enable, Active Low
output        SMTESTACK;       // Test Bus acknowledge




// Inputs
  wire        HCLK;            // AHB Bus Clock
  wire        SMMEMCLK;        // Memory Clock
  wire        nSMMEMCLK;       // Inverted Memory Clock
  wire        SMMEMCLKDELAY;   // Delayed Memory Clock
  wire        SMFBCLK0;        // Fedback clock0 from output pad
  wire        SMFBCLK1;        // Fedback clock1 from output pad
  wire        SMFBCLK2;        // Fedback clock2 from output pad
  wire        SMFBCLK3;        // Fedback clock3 from output pad
  wire        HRESETn;         // AHB system level Reset
  wire [25:0] HADDRSMC;        // The address bus input from AHB for Memory
                               // accesses
  wire  [1:0] HTRANSSMC;       // Indicates current transfer type for Memory
                               // accesses
  wire        HWRITESMC;       // Indicates direction of transfer (R/W) for
                               // Memory accesses
  wire  [2:0] HSIZESMC;        // Transfer size indication for Memory accesses
  wire  [2:0] HBURSTSMC;       // The burst transfer information from AHB for
                               // Memory accesses
  wire [31:0] HWDATASMC;       // Write data bus input from AHB for Memory
                               // accesses
  wire  [7:0] HSELSMC;         // Select signal for Memory transfer to
                               // SSMCCore. One select line for each Memory
                               // Bank
  wire        HREADYINSMC;     // Transfer completion input signal
  wire [11:2] HADDRREG;        // The address bus input from AHB for Register
                               // accesses
  wire  [1:0] HTRANSREG;       // Indicates current transfer type for Register
                               // accesses. Bit1 of HTRANS on AHB
  wire        HWRITEREG;       // Indicates direction of transfer (R/W) for
                               // Register accesses
  wire  [2:0] HSIZEREG;        // Transfer size indication for Register
                               // accesses
  wire [31:0] HWDATAREG;       // Write data bus input from AHB for Register
                               // accesses
  wire        HSELREG;         // Select signal for Register transfer
  wire        HREADYINREG;     // Transfer completion input signal
  wire        HREADYINTIC;     // Transfer completion input signal
  wire  [1:0] HRESPTIC;        // AHB Bus Transfer Response for TIC
  wire [31:0] HRDATATIC;       // AHB Read Data Input for TIC
  wire        HGRANTTIC;       // AHB Bus Grant for TIC
  wire        SMBUSGNTEBI;     // External bus granted for Memory Transfer
  wire        SMBUSBACKOFFEBI; // EBI backoff for Memory accesses. Indication
                               // that the current transfer should be completed
                               // as soon as possible
  wire        SMTICBUSGNTEBI;  // External bus granted for TIC Transfer
  wire        SMBIGENDIAN;     // Type of endianness of the system
  wire        SMEXTBUSMUX;     // Static pin indicating if internal DBI or
                               // external EBI is used
  wire        SCANENABLE;      // Enable for Scan Mode
  wire        SCANINHCLK;      // Scan chain input with respect to HCLK
  wire        SCANINSMMEMCLK;  // Scan chain input with respect to SMMEMCLK
  wire        SCANINnSMMEMCLK; // Scan chain input with respect to nSMMEMCLK
  wire        SCANINCLKDELAY;  // Scan chain input with respect to SMMEMCLKDELAY
  wire        SCANINFBCLK0;    // Scan chain input with respect to FBCLK0
  wire        SCANINFBCLK1;    // Scan chain input with respect to FBCLK1
  wire        SCANINFBCLK2;    // Scan chain input with respect to FBCLK2
  wire        SCANINFBCLK3;    // Scan chain input with respect to FBCLK3
  wire  [1:0] SMMWCS7;         // Static Input pins used to program the memory
                               // width bit field of Bank7 register
  wire        SMBLS7POL;       // Static Input pin used to program the polarity
                               // of SMBLS bit field of Bank7 register
  wire  [1:0] SMMEMCLKRATIO;   // Defines Ratio of SMMEMCLK to HCLK
  wire        SMWAIT;          // Asynchronous Wait signal from External
                               // Memory Controller to delay the transfer
  wire        SMCANCELWAIT;    // Asynchronous external input, to signal that
                               // SMWAIT has timed out
  wire  [7:0] nSMBURSTWAIT;    // Synchronous burst Wait signal from External
                               // Memory Controller to delay the transfer
  wire [31:0] SMDATAIN;        // Data from Memory to SSMC
  wire        SMTESTREQA;      // Test bus request A
  wire        SMTESTREQB;      // Test bus request B, during test this signal
                               // is used in combination with SMTESTREQA

// Outputs
  wire [31:0] HRDATASMC;       // AHB Read Data output for Memory accesses
  wire        HREADYOUTSMC;    // Indicates completion of Memory accesses
  wire  [1:0] HRESPSMC;        // SSMCCore response output, for Memory
                               // accesses
  wire [31:0] HRDATAREG;       // AHB Read Data output for Register accesses
  wire        HREADYOUTREG;    // Indicates completion of Register accesses
  wire  [1:0] HRESPREG;        // SSMCCore response output, for Register
                               // accesses
  wire [31:0] HADDRTIC;        // AHB Address output from TIC
  wire  [1:0] HTRANSTIC;       // AHB Transfer type output from TIC
  wire        HWRITETIC;       // AHB Transfer direction output from TIC
  wire  [2:0] HSIZETIC;        // AHB Transfer Size output from TIC
  wire  [2:0] HBURSTTIC;       // AHB Burst Type output from TIC
  wire  [3:0] HPROTTIC;        // AHB Protection control signal from TIC
  wire [31:0] HWDATATIC;       // AHB Write Data output from TIC
  wire        HBUSREQTIC;      // AHB Bus Request from TIC
  wire        HLOCKTIC;        // AHB signal indicating Locked access to the
                               // Bus from TIC
  wire        SMBUSREQEBI;     // Request EBI for Memory Transfer
  wire        SMTICBUSREQEBI;  // Request EBI for TIC Transfer
  wire        SCANOUTHCLK;     // Scan chain output with respect to HCLK
  wire        SCANOUTFBCLK0;   // Scan chain output with respect to FBCLK0
  wire        SCANOUTFBCLK1;   // Scan chain output with respect to FBCLK1
  wire        SCANOUTFBCLK2;   // Scan chain output with respect to FBCLK2
  wire        SCANOUTFBCLK3;   // Scan chain output with respect to FBCLK3
  wire        SCANOUTSMMEMCLK; // Scan chain output with respect to SMMEMCLK
  wire        SCANOUTnSMMEMCLK;// Scan chain output with respect to nSMMEMCLK
  wire        SCANOUTCLKDELAY; // Scan chain output with respect to
                               // SMMEMCLKDELAY
  wire  [3:0] SMCLK;           // Clock for Synchronous memories
  wire [31:0] SMDATAOUT;       // Data Bus output from SSMC to Memory
  wire        SMBAA;           // External burst Address advance signal. Used
                               // to advance the address count in the external
                               // Memory device
  wire        SMADDRVALID;     // External address valid output, used to
                               // indicate when the address output is stable
                               // during synchronous burst transfers
  wire [25:0] SMADDR;          // External Memory address bus
  wire        SMCS0;           // Chip Select for Bank0 of external Memory,
                               // active HIGH
  wire        SMCS1;           // Chip Select for Bank1 of external Memory,
                               // active HIGH
  wire        SMCS2;           // Chip Select for Bank2 of external Memory,
                               // active HIGH
  wire        SMCS3;           // Chip Select for Bank3 of external Memory,
                               // active HIGH
  wire        SMCS4;           // Chip Select for Bank4 of external Memory,
                               // active HIGH
  wire        SMCS5;           // Chip Select for Bank5 of external Memory,
                               // active HIGH
  wire        SMCS6;           // Chip Select for Bank6 of external Memory,
                               // active HIGH
  wire        SMCS7;           // Chip Select for Bank7 of external Memory,
                               // active HIGH
  wire        nSMCS0;          // Chip Select for Bank0 of external Memory,
                               // active LOW
  wire        nSMCS1;          // Chip Select for Bank1 of external Memory,
                               // active LOW
  wire        nSMCS2;          // Chip Select for Bank2 of external Memory,
                               // active LOW
  wire        nSMCS3;          // Chip Select for Bank3 of external Memory,
                               // active LOW
  wire        nSMCS4;          // Chip Select for Bank4 of external Memory,
                               // active LOW
  wire        nSMCS5;          // Chip Select for Bank5 of external Memory,
                               // active LOW
  wire        nSMCS6;          // Chip Select for Bank6 of external Memory,
                               // active LOW
  wire        nSMCS7;          // Chip Select for Bank7 of external Memory,
                               // active LOW
  wire  [3:0] nSMDATAEN;       // Tri-state I/O pad enable for the byte lanes
                               // of external memory data bus
  wire        nSMWEN;          // Memory Write Enable, Active LOW
  wire  [3:0] nSMBLS;          // Memory device Byte lane enables
  wire        nSMOEN;          // Memory Output Enable, Active Low
  wire        SMTESTACK;       // Test Bus acknowledge

  
// -----------------------------------------------------------------------------
//
//                                    Ssmc
//                                    ====
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This is the top level structural block of Ssmc. This block
//   instantiates the following functional sub-blocks in the Ssmc.
//      - SsmcCore
//      - SsmcDBI
//      - SsmcClockOr
//      - SsmcRevAnd
//      - SsmcTIC
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        SMTICBUSGNTExt;
// External bus granted for TIC Transfer

wire        SMBUSGNTExt;
// External bus granted for Memory Transfer

wire        SmBusBackOffExt;
// Registered version of SMBUSBACKOFFEBI

wire        BUSMUXEXT;
// Indication to either use Internal DBI or External EBI

wire        ClkStpd;
// Signal to indicate that clock output should be stopped

wire  [7:0] SMCS;
// Chip Selects for external Memory, active HIGH

wire  [7:0] nSMCS;
// Chip Selects for external Memory, active LOW

wire        SMBUSREQ;
// Bus Request signal to DBI

wire  [3:0] SmDataEnCore;
// Data Enables when Write is progressing

wire [31:0] SmDataOutCore;
// Data Bus output from SSMC


// SsmcDBI signals
wire        SMBUSREQExt;
// Request EBI for Memory Transfer

wire        SMTICBUSREQExt;
// Request EBI for TIC Transfer

wire        TICBUSGNT;
// Bus Grant to TIC from DBI

wire        SMBUSGNT;
// Bus Grant to SsmcCore from DBI

// SsmcTIC signals
wire [31:0] TBUSOUT;
// External test vector output data bus

wire        TICBUSREQ;
// TIC bus request to DBI

wire        TICREAD;
// Drive AHB read data onto TBUSOUT

// SsmcRevAnd signals
wire  [3:0] TieOff1;
// Input 1 for SsmcRevAnd

wire  [3:0] TieOff2;
// Input 2 for SsmcRevAnd

wire  [3:0] Revision;
// Output of SsmcRevAnd


// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Instantiation of SsmcCore
// -----------------------------------------------------------------------------

SsmcCore uSsmcCore (
        .HCLK            (HCLK),
        .SMMEMCLK        (SMMEMCLK),
        .nSMMEMCLK       (nSMMEMCLK),
        .SMMEMCLKDELAY   (SMMEMCLKDELAY),
        .SMFBCLK0        (SMFBCLK0),
        .SMFBCLK1        (SMFBCLK1),
        .SMFBCLK2        (SMFBCLK2),
        .SMFBCLK3        (SMFBCLK3),
        .HRESETn         (HRESETn),
        .HADDRSMC        (HADDRSMC),
        .HTRANSSMC       (HTRANSSMC),
        .HWRITESMC       (HWRITESMC),
        .HSIZESMC        (HSIZESMC),
        .HBURSTSMC       (HBURSTSMC),
        .HWDATASMC       (HWDATASMC),
        .HSELSMC         (HSELSMC),
        .HREADYINSMC     (HREADYINSMC),
        .HADDRREG        (HADDRREG),
        .HTRANSREG       (HTRANSREG),
        .HWRITEREG       (HWRITEREG),
        .HSIZEREG        (HSIZEREG),
        .HWDATAREG       (HWDATAREG),
        .HSELREG         (HSELREG),
        .HREADYINREG     (HREADYINREG),
        .SMBUSGNTEBI     (SMBUSGNTEBI),
        .SMBUSBACKOFFEBI (SMBUSBACKOFFEBI),
        .SMTICBUSGNTEBI  (SMTICBUSGNTEBI),
        .SMBIGENDIAN     (SMBIGENDIAN),
        .SMEXTBUSMUX     (SMEXTBUSMUX),
        .SMBUSREQExt     (SMBUSREQExt),
        .SMTICBUSREQExt  (SMTICBUSREQExt),
        .SMMWCS7         (SMMWCS7),
        .SMBLS7POL       (SMBLS7POL),
        .SMMEMCLKRATIO   (SMMEMCLKRATIO),
        .SMWAIT          (SMWAIT),
        .SMCANCELWAIT    (SMCANCELWAIT),
        .nSMBURSTWAIT    (nSMBURSTWAIT),
        .SMDATAIN        (SMDATAIN),
        .SMBUSGNT        (SMBUSGNT),
        .Revision        (Revision),

        .HRDATASMC       (HRDATASMC),
        .HREADYOUTSMC    (HREADYOUTSMC),
        .HRESPSMC        (HRESPSMC),
        .HRDATAREG       (HRDATAREG),
        .HREADYOUTREG    (HREADYOUTREG),
        .HRESPREG        (HRESPREG),
        .SMBUSREQ        (SMBUSREQ),
        .SMBUSREQEBI     (SMBUSREQEBI),
        .SMTICBUSREQEBI  (SMTICBUSREQEBI),
        .SMTICBUSGNTExt  (SMTICBUSGNTExt),
        .SMBUSGNTExt     (SMBUSGNTExt),
        .SmBusBackOffExt (SmBusBackOffExt),
        .ClkStpd         (ClkStpd),
        .BUSMUXEXT       (BUSMUXEXT),
        .SmDataEnCore    (SmDataEnCore),
        .SmDataOutCore   (SmDataOutCore),
        .SMBAA           (SMBAA),
        .SMADDRVALID     (SMADDRVALID),
        .SMADDR          (SMADDR),
        .SMCS            (SMCS),
        .nSMCS           (nSMCS),
        .nSMWEN          (nSMWEN),
        .nSMBLS          (nSMBLS),
        .nSMOEN          (nSMOEN)
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcDBI
// -----------------------------------------------------------------------------
SsmcDBI uSsmcDBI (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .SMTICBUSGNTExt  (SMTICBUSGNTExt),
        .SMBUSGNTExt     (SMBUSGNTExt),
        .SmBusBackOffExt (SmBusBackOffExt),
        .BUSMUXEXT       (BUSMUXEXT),
        .SMBUSREQ        (SMBUSREQ),
        .TICBUSREQ       (TICBUSREQ),
        .TBUSOUT         (TBUSOUT),
        .TICREAD         (TICREAD),
        .SmDataEnCore    (SmDataEnCore),
        .SmDataOutCore   (SmDataOutCore),

        .SMBUSREQExt     (SMBUSREQExt),
        .SMTICBUSREQExt  (SMTICBUSREQExt),
        .SMDATAOUT       (SMDATAOUT),
        .nSMDATAEN       (nSMDATAEN),
        .TICBUSGNT       (TICBUSGNT),
        .SMBUSGNT        (SMBUSGNT)
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcTIC
// -----------------------------------------------------------------------------
SsmcTIC uSsmcTIC (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HREADYINTIC     (HREADYINTIC),
        .HRESPTIC        (HRESPTIC),
        .HGRANTTIC       (HGRANTTIC),
        .HRDATATIC       (HRDATATIC),
        .TBUSIN          (SMDATAIN),
        .SMTESTREQA      (SMTESTREQA),
        .SMTESTREQB      (SMTESTREQB),
        .TICBUSGNT       (TICBUSGNT),

        .HADDRTIC        (HADDRTIC),
        .HTRANSTIC       (HTRANSTIC),
        .HWRITETIC       (HWRITETIC),
        .HSIZETIC        (HSIZETIC),
        .HBURSTTIC       (HBURSTTIC),
        .HPROTTIC        (HPROTTIC),
        .HWDATATIC       (HWDATATIC),
        .HBUSREQTIC      (HBUSREQTIC),
        .HLOCKTIC        (HLOCKTIC),
        .TBUSOUT         (TBUSOUT),
        .SMTESTACK       (SMTESTACK),
        .TICBUSREQ       (TICBUSREQ),
        .TICREAD         (TICREAD)
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcClockOr for bit 0 of SMCLK[3:0]
// -----------------------------------------------------------------------------
SsmcClockOr u0SsmcClockOr (
        .CLKIN           (SMMEMCLK),
        .ClkStpd         (ClkStpd),

        .CLKOUT          (SMCLK[0])
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcClockOr for bit 1 of SMCLK[3:0]
// -----------------------------------------------------------------------------
SsmcClockOr u1SsmcClockOr (
        .CLKIN           (SMMEMCLK),
        .ClkStpd         (ClkStpd),

        .CLKOUT          (SMCLK[1])
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcClockOr for bit 2 of SMCLK[3:0]
// -----------------------------------------------------------------------------
SsmcClockOr u2SsmcClockOr (
        .CLKIN           (SMMEMCLK),
        .ClkStpd         (ClkStpd),

        .CLKOUT          (SMCLK[2])
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcClockOr for bit 3 of SMCLK[3:0]
// -----------------------------------------------------------------------------
SsmcClockOr u3SsmcClockOr (
        .CLKIN           (SMMEMCLK),
        .ClkStpd         (ClkStpd),

        .CLKOUT          (SMCLK[3])
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcRevAnd for bit0 of Revision
// -----------------------------------------------------------------------------
SsmcRevAnd u0SsmcRevAnd (
        .TieOff1         (TieOff1[0]),
        .TieOff2         (TieOff2[0]),

        .Revision        (Revision[0])
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcRevAnd for bit1 of Revision
// -----------------------------------------------------------------------------
SsmcRevAnd u1SsmcRevAnd (
        .TieOff1         (TieOff1[1]),
        .TieOff2         (TieOff2[1]),

        .Revision        (Revision[1])
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcRevAnd for bit2 of Revision
// -----------------------------------------------------------------------------
SsmcRevAnd u2SsmcRevAnd (
        .TieOff1         (TieOff1[2]),
        .TieOff2         (TieOff2[2]),

        .Revision        (Revision[2])
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcRevAnd for bit3 of Revision
// -----------------------------------------------------------------------------
SsmcRevAnd u3SsmcRevAnd (
        .TieOff1         (TieOff1[3]),
        .TieOff2         (TieOff2[3]),

        .Revision        (Revision[3])
           );

// -----------------------------------------------------------------------------
// Assign values to inputs of RevAnd
// -----------------------------------------------------------------------------
assign TieOff1          = 4'b0001;
assign TieOff2          = 4'b0001;

// -----------------------------------------------------------------------------
// Route appropriate Chip select line
// -----------------------------------------------------------------------------
assign SMCS0            = SMCS[0];
assign SMCS1            = SMCS[1];
assign SMCS2            = SMCS[2];
assign SMCS3            = SMCS[3];
assign SMCS4            = SMCS[4];
assign SMCS5            = SMCS[5];
assign SMCS6            = SMCS[6];
assign SMCS7            = SMCS[7];

assign nSMCS0           = nSMCS[0];
assign nSMCS1           = nSMCS[1];
assign nSMCS2           = nSMCS[2];
assign nSMCS3           = nSMCS[3];
assign nSMCS4           = nSMCS[4];
assign nSMCS5           = nSMCS[5];
assign nSMCS6           = nSMCS[6];
assign nSMCS7           = nSMCS[7];

endmodule
// --================================== End ==================================--
