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
// File Name              : SsmcCore.v.rca
// File Revision          : 1.22
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This is the top level structural block of SsmcCore
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcCore (
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
                 SMBUSGNTEBI,
                 SMBUSBACKOFFEBI,
                 SMTICBUSGNTEBI,
                 SMBIGENDIAN,
                 SMEXTBUSMUX,
                 SMBUSREQExt,
                 SMTICBUSREQExt,
                 SMMWCS7,
                 SMBLS7POL,
                 SMMEMCLKRATIO,
                 SMWAIT,
                 SMCANCELWAIT,
                 nSMBURSTWAIT,
                 SMDATAIN,
                 SMBUSGNT,
                 Revision,
// Outputs
                 HRDATASMC,
                 HREADYOUTSMC,
                 HRESPSMC,
                 HRDATAREG,
                 HREADYOUTREG,
                 HRESPREG,
                 SMBUSREQ,
                 SMBUSREQEBI,
                 SMTICBUSREQEBI,
                 SMTICBUSGNTExt,
                 SMBUSGNTExt,
                 SmBusBackOffExt,
                 ClkStpd,
                 BUSMUXEXT,
                 SmDataEnCore,
                 SmDataOutCore,
                 SMBAA,
                 SMADDRVALID,
                 SMADDR,
                 SMCS,
                 nSMCS,
                 nSMWEN,
                 nSMBLS,
                 nSMOEN
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
input         SMBUSGNTEBI;     // External bus granted for Memory Transfer
input         SMBUSBACKOFFEBI; // EBI backoff for Memory accesses. Indication
                               // that the current transfer should be completed
                               // as soon as possible
input         SMTICBUSGNTEBI;  // External bus granted for TIC Transfer
input         SMBIGENDIAN;     // Type of endianness of the system
input         SMEXTBUSMUX;     // Static pin indicating if internal DBI or
                               // external EBI is used
input         SMBUSREQExt;     // Request EBI for Memory Transfer. This is
                               // routed from DBI module.
input         SMTICBUSREQExt;  // Request EBI for TIC Transfer. This is routed
                               // from DBI module.
input   [1:0] SMMWCS7;         // Static Input pins used to program the memory
                               // width bit field of Bank7 register
input         SMBLS7POL;       // Static Input pin used to program the polarity
                               // of Bank7 register
input   [1:0] SMMEMCLKRATIO;   // Defines Ratio of SMMEMCLK to HCLK
input         SMWAIT;          // Asynchronous Wait signal from External
                               // Memory Controller to delay the transfer
input         SMCANCELWAIT;    // Asynchronous external input, to signal that
                               // SMWAIT has timed out
input   [7:0] nSMBURSTWAIT;    // Synchronous burst Wait signal from External
                               // Memory Controller to delay the transfer
input  [31:0] SMDATAIN;        // Data from Memory to SSMC
input         SMBUSGNT;        // Bus Grant to SsmcCore from DBI
input   [3:0] Revision;        // TieOff1 and TieOff2 ANDed

// Outputs
output [31:0] HRDATASMC;       // AHB Read Data output for Memory accesses
output        HREADYOUTSMC;    // Indicates completion of Memory accesses
output  [1:0] HRESPSMC;        // SSMCCore response output, for Memory
                               // accesses
output [31:0] HRDATAREG;       // AHB Read Data output for Register accesses
output        HREADYOUTREG;    // Indicates completion of Register accesses
output  [1:0] HRESPREG;        // SSMCCore response output, for Register
                               // accesses
output        SMBUSREQ;        // Bus Request signal to DBI
output        SMBUSREQEBI;     // Request EBI for Memory Transfer
output        SMTICBUSREQEBI;  // Request EBI for TIC Transfer
output        SMTICBUSGNTExt;  // External bus granted for TIC Transfer
output        SMBUSGNTExt;     // External bus granted for Memory Transfer
output        SmBusBackOffExt; // BackOff indication by EBI
output        ClkStpd;         // Signal to indicate that clock output should
                               // be stopped
output        BUSMUXEXT;       // Indication to either use Internal DBI or
                               // External EBI
output  [3:0] SmDataEnCore;    // Data Enables when Write is progressing
output [31:0] SmDataOutCore;   // Data Bus output from SSMC
output        SMBAA;           // External burst Address advance signal. Used
                               // to advance the address count in the external
                               // Memory device.
output        SMADDRVALID;     // External address valid output, used to
                               // indicate when the address output is stable
                               // during synchronous burst transfers
output [25:0] SMADDR;          // External Memory address bus
output  [7:0] SMCS;            // Chip Selects for external Memory, active
                               // HIGH
output  [7:0] nSMCS;           // Chip Selects for external Memory, active LOW
output        nSMWEN;          // Memory Write Enable, Active LOW
output  [3:0] nSMBLS;          // Memory device Byte lane enables
output        nSMOEN;          // Memory Output Enable, Active Low


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
  wire        SMBUSGNTEBI;     // External bus granted for Memory Transfer
  wire        SMBUSBACKOFFEBI; // EBI backoff for Memory accesses. Indication
                               // that the current transfer should be completed
                               // as soon as possible
  wire        SMTICBUSGNTEBI;  // External bus granted for TIC Transfer
  wire        SMBIGENDIAN;     // Type of endianness of the system
  wire        SMEXTBUSMUX;     // Static pin indicating if internal DBI or
                               // external EBI is used
  wire        SMBUSREQExt;     // Request EBI for Memory Transfer. This is
                               // routed from DBI module.
  wire        SMTICBUSREQExt;  // Request EBI for TIC Transfer. This is routed
                               // from DBI module.
  wire  [1:0] SMMWCS7;         // Static Input pins used to program the memory
                               // width bit field of Bank7 register
  wire        SMBLS7POL;       // Static Input pin used to program the polarity
                               // of Bank7 register
  wire  [1:0] SMMEMCLKRATIO;   // Defines Ratio of SMMEMCLK to HCLK
  wire        SMWAIT;          // Asynchronous Wait signal from External
                               // Memory Controller to delay the transfer
  wire        SMCANCELWAIT;    // Asynchronous external input, to signal that
                               // SMWAIT has timed out
  wire  [7:0] nSMBURSTWAIT;    // Synchronous burst Wait signal from External
                               // Memory Controller to delay the transfer
  wire [31:0] SMDATAIN;        // Data from Memory to SSMC
  wire        SMBUSGNT;        // Bus Grant to SsmcCore from DBI
  wire  [3:0] Revision;        // TieOff1 and TieOff2 ANDed

// Outputs
  wire [31:0] HRDATASMC;       // AHB Read Data output for Memory accesses
  wire        HREADYOUTSMC;    // Indicates completion of Memory accesses
  wire  [1:0] HRESPSMC;        // SSMCCore response output, for Memory
                               // accesses
  wire [31:0] HRDATAREG;       // AHB Read Data output for Register accesses
  wire        HREADYOUTREG;    // Indicates completion of Register accesses
  wire  [1:0] HRESPREG;        // SSMCCore response output, for Register
                               // accesses
  wire        SMBUSREQ;        // Bus Request signal to DBI
  wire        SMBUSREQEBI;     // Request EBI for Memory Transfer
  wire        SMTICBUSREQEBI;  // Request EBI for TIC Transfer
  wire        SMTICBUSGNTExt;  // External bus granted for TIC Transfer
  wire        SMBUSGNTExt;     // External bus granted for Memory Transfer
  wire        SmBusBackOffExt; // BackOff indication by EBI
  wire        ClkStpd;         // Signal to indicate that clock output should
                               // be stopped
  wire        BUSMUXEXT;       // Indication to either use Internal DBI or
                               // External EBI
  wire  [3:0] SmDataEnCore;    // Data Enables when Write is progressing
  wire [31:0] SmDataOutCore;   // Data Bus output from SSMC
  wire        SMBAA;           // External burst Address advance signal. Used
                               // to advance the address count in the external
                               // Memory device.
  wire        SMADDRVALID;     // External address valid output, used to
                               // indicate when the address output is stable
                               // during synchronous burst transfers
  wire [25:0] SMADDR;          // External Memory address bus
  wire  [7:0] SMCS;            // Chip Selects for external Memory, active
                               // HIGH
  wire  [7:0] nSMCS;           // Chip Selects for external Memory, active LOW
  wire        nSMWEN;          // Memory Write Enable, Active LOW
  wire  [3:0] nSMBLS;          // Memory device Byte lane enables
  wire        nSMOEN;          // Memory Output Enable, Active Low




// -----------------------------------------------------------------------------
//
//                                  SsmcCore
//                                  ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This is the top level structural block of SsmcCore. This block
//   instantiates the following functional sub-blocks in the SsmcCore.
//      - SsmcAhbSlvMemIf
//      - SsmcAhbSlvRegIf
//      - SsmcPadIf
//      - SsmcSynchroniser
//      - SsmcMemTSM
//      - SsmcDerivedClk
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        UseSecBuf;
// Indication to use second level buffered resources during Write

wire  [1:0] HtranRegCont;
// HTRANS registered on every clock

wire  [1:0] HtransMemBuf1;
// Level1 Buffer to hold HTRANSSMC

wire        HsizeEqMWidth;
// Indication that AHB and Memory are of same width

wire        AhbWider;
// Indication that AHB Width is greater than Memory Width

wire        AhbNarrow;
// Indication that AHB Width is narrower than Memory Width

wire        MemWrReq;
// Signal indicating the write transfer has been initiated

wire        MemRdReq;
// Signal indicating the read transfer being initiated

wire        TurnAround;
// TurnAround indication for R->W and R->R for diff memory bank

wire        NewBurst;
// Indication that Burst Broken

wire  [4:0] AhbCount;
// Indication of number of Memory transfer requested by AHB

wire        WaitToutErr;
// Waited Access Error indication

wire        NextValByteLane0;
// Indication that Byte Lane0 is valid during write operation

wire        NextValByteLane1;
// Indication that Byte Lane1 is valid during write operation

wire        NextValByteLane2;
// Indication that Byte Lane2 is valid during write operation

wire        NextValByteLane3;
// Indication that Byte Lane3 is valid during write operation

wire        BUSYCYC;
// Indication that SM is in ST_MEM_BUSY state

wire        IDLECYC;
// Indication that SM is in ST_MEM_NOT_SEL state

wire        WRITECYC;
// Indication that SM is in ST_MEM_WRITE state

wire [25:0] AddrBuf;
// Buffered AHB Address

wire [25:0] AddrBuf1;
// Level1 Buffer to hold HADDRSMC

wire [31:0] HwdataBuf;
// Buffered AHB Data

wire  [1:0] HsizeMemBuf;
// Buffered AHB HSIZESMC

wire  [1:0] HsizeMemBuf1;
// Level1 buffer to hold HSIZESMC

wire  [2:0] HburstMemBuf;
// Buffered HBURSTSMC

wire  [7:0] HselMemBuf1;
// 1st level registered HSELSMC

wire  [7:0] HselMemBuf;
// Buffered HSELSMC

wire  [2:0] AhbWideRdCnt;
// Counter which indicates number of Memory accesses required for one AHB Read
// transfer

wire  [2:0] AhbWideWrCnt;
// Counter for number of Memory Write accesses required for 1 AHB Write transfer

wire        AddrNotAligned;
// Indication that starting address is not aligned to Memory Width

wire  [1:0] MW;
// The memory width bits selection from one of the bank registers

wire        SMBLSPol;
// Byte lane polarity bit selection from one of the bank registers

wire        BMWrite;
// Burst Mode Write indication

wire        SyncEnWrite;
// Synchronous burst Mode Write

wire  [1:0] BurstLenWrite;
// Burst transfer length, supported by Burst devices for Write

wire        AddrValidWriteEn;
// SMADDRVALID enable during Write

wire        BIWriteEn;
// Indication that SMBAA active during Synchronous Burst Write access

wire        RBLE;
// Byte lane enabled device of SMWAIT

wire        WaitEn;
// Wait Enable indication

wire        WaitPol;
// Indication of the Wait polarity

wire  [4:0] WSTWR;
// Single Write access count for the bank targeted currently

wire  [3:0] WSTWEN;
// Delay value for the assertion of the WEN and nSMBLS signals

wire  [3:0] IDCYC;
// Count value for the turnaround cycles


// SsmcAhbSlvRegIf Block signals for Register Accesses
wire        BIGENDIAN;
// Indicates Endianness of the System

wire  [1:0] ClockRatio;
// Indicates ratio of Memory Clock with respect to HCLK

wire        MemClkRegTogl;
// Toggle signal indicating that write happened to Clock Register

wire  [1:0] MW1;
// 1st level registered memory width bits selection from one of the bank
// registers

wire        SMBLSPol1;
// 1st level registered memory Byte lane polarity bit from one
// of the bank registers

wire        BMRead1;
// 1st level Burst Mode read

wire        WrapRead;
// Enables the wrapping burst feature from memory

wire        BIWriteEn1;
// Indication that SMBAA active during Synchronous Burst Write access, 1st level
// buffered

wire        BIReadEn1;
// Indication that SMBAA and nSMIND active during Synchronous Burst Read access,
// 1st level buffered

wire        BMWrite1;
// 1st level Burst Mode Write

wire        SyncEnRead1;
// 1st level Sync burst Mode read

wire        SyncEnWrite1;
// 1st level Sync burst Mode Write

wire  [1:0] BurstLenRead1;
// 1st level Burst transfer length, by Burst devices for Read

wire  [1:0] BurstLenWrite1;
// 1st level Burst transfer length, by Burst devices for Write

wire        AddrValidReadEn1;
// 1st level SMADDRVALID enable during Read

wire        AddrValWriteEn1;
// 1st level SMADDRVALID enable during Write

wire        SMClockEn;
// Zero on this bit indicates that Clock should be active during Memory
// accesses. One on this bit indicates that clock is always running

wire        WP1;
// 1st level Write protection

wire        RBLE1;
// 1st level Byte lane enable

wire        WaitEn1;
// 1st level Wait Enable indication

wire        WaitPol1;
// 1st level Indication of the polarity of SMWAIT

wire  [4:0] WSTRD1;
// 1st level Single Read access count

wire  [4:0] WSTBRD1;
// 1st level Burst Read access count

wire  [4:0] WSTWR1;
// 1st level Write access count

wire  [3:0] WSTOEN1;
// 1st level Delay value for the assertion of the OEN

wire  [3:0] WSTWEN1;
// 1st level Delay value for the assertion of the WEN and nSMCS

wire  [3:0] IDCYC1;
// 1st level Count value for the turnaround cycles

// SsmcPadIf Block signals
wire        SmBurstWtFbClk;
// nSMBURSTWAIT registered on FBCLK

wire        SyncWtSingle;
// Single bit Synchronous Wait

wire [31:0] SmDataInFbClk;
// Data from Memory Banks

// SsmcSynchroniser Block signals
wire        SMWaitSync;
// Double synchronised SMWAIT

wire        SmCancelWaitSync;
// Double synchronised SMCANCELWAIT

// SsmcMemTSM Block signals
wire  [1:0] MWWr;
// Buffered MW while writing

wire        RBLEWr;
// RBLE registered during write operation

wire  [1:0] HsizeMemBufWr;
// Buffered HsizeMemBuf while writing

wire        HsizeEqMWidthWr;
// Indication that AHB and Memory are of same width

wire        AhbWiderWr;
// Indication that AHB Width is greater than Memory Width

wire        AhbNarrowWr;
// Indication that AHB Width is Narrower than Memory Width

wire        nSMWENMC;
// nSMWEN when Asynchronous memory access is in progress

wire        SmCSTSM;
// Chip Select Assertion

wire        DelSmCSTSM;
// Delayed version of SmCSTSM

wire  [1:0] SmAddrTSM;
// Memory Address from TSM module

wire [25:0] SMADDRMC;
// Memory address output when Asynchronous memory access is progressing

wire  [3:0] nSMBLSMC;
// Byte Lane Select when Asynchronous memory access is progressing

wire        InitSt;
// Indication that Memory SM is in ST_NO_REQ State

wire        BurstWriteSt;
// Indication that Memory SM is in ST_BURST_WRITE State

wire        TurnAroundSt;
// Indication that Memory SM is in ST_TURNAROUND State

wire        WaitTxrOnBusSt;
// Indication that Memory SM is in ST_WAITTXRONBUS State

wire        WaitDeAssrtSt;
// Indication that Memory SM is in ST_WAIT_DEASSERTED State

wire        CancelWaitSt;
// Indication that Memory SM is in ST_CANCELWAIT State

wire        MemoryRdSt;
// Indication that Memory TSM is in Read State

wire        MemoryWrSt;
// Indication that Memory TSM is in Write State

//wire        AsynAxs;
// Indication that Asynchronous memory access in progress

wire        Toggle;
// Indication of State switching when SM is waiting for transfer on AHB Bus

wire        WBstIntrptd;

wire        TxrB4BsyAccptd;
  
wire        WaitWrCycVer;
// Memory device write completion signal

wire        WaitWrCycDup;
// Memory device write completion signal when Wait Transfer is pipelined

wire        WaitWrCycAhb;
// Memory device write completion signal when Synchronous Transfer is pipelined

wire        WaitRdCyc;
// Memory device read completion signal

wire        WaitRdCycVer;
// Version of WaitRdCyc signal

wire        SyncEnWriteReg;
// Synchronous Write Enable signal registered when write begins

wire        WaitStatus;
// Wait Enable signal registered when write begins

wire        WaitEnReg;
// Wait Enable signal registered when write begins

wire        BMWriteReg;
// Burst Mode Write indication registered when write begins

wire  [2:0] WriteBeatCnt;
// Counter used for carrying out Burst Write

wire        nSmBurstWaitReg;
// Wait status for enabled transfers

// SsmcDerivedClk Block signals
wire        SlowClkM;
// Slow clock indicator to HCLK side

wire         NextAsynAxs;      
// Indication of Asynchronous memory access

wire         NextSmOEn;        
// Memory Output Enable, Active Low

wire         NxtSMADDRVALIDMC; 
// External address valid output

wire         NextSMBAAMC;      
// External burst Address advance signal

wire [7:0]   NextSMCSMC;       
// Active high chip select

wire [7:0]   NextSMCSMCn;      
// Active low chip select

wire [3:0]   NextSMDATAENMCn;  
// Data enable

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
// Internal Signal Assignments
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Instantiation of SsmcAhbSlvMemIf
// -----------------------------------------------------------------------------
SsmcAhbSlvMemIf uSsmcAhbSlvMemIf (
        .HCLK             (HCLK),
        .HRESETn          (HRESETn),
        .HADDRSMC         (HADDRSMC),
        .HTRANSSMC        (HTRANSSMC),
        .HWRITESMC        (HWRITESMC),
        .HSIZESMC         (HSIZESMC),
        .HBURSTSMC        (HBURSTSMC),
        .HWDATASMC        (HWDATASMC),
        .HSELSMC          (HSELSMC),
        .HREADYINSMC      (HREADYINSMC),
        .WaitWrCycVer     (WaitWrCycVer),
        .WaitWrCycDup     (WaitWrCycDup),
        .WaitWrCycAhb     (WaitWrCycAhb),
        .WaitRdCycVer     (WaitRdCycVer),
        .WaitRdCyc        (WaitRdCyc),
        .ClockRatio       (ClockRatio),
        .SmCSTSM          (SmCSTSM),
        .DelSmCSTSM       (DelSmCSTSM),
        .SmDataInFbClk    (SmDataInFbClk),
        .HsizeEqMWidthWr  (HsizeEqMWidthWr),
        .AhbWiderWr       (AhbWiderWr),
        .AhbNarrowWr      (AhbNarrowWr),
        .nSmBurstWaitReg  (nSmBurstWaitReg),
        .MW1              (MW1),
        .SMBLSPol1        (SMBLSPol1),
        .BIWriteEn1       (BIWriteEn1),
        .BMWrite1         (BMWrite1),
        .SyncEnRead1      (SyncEnRead1),
        .SyncEnWrite1     (SyncEnWrite1),
        .BurstLenRead1    (BurstLenRead1),
        .BurstLenWrite1   (BurstLenWrite1),
        .AddrValWriteEn1  (AddrValWriteEn1),
        .WP1              (WP1),
        .RBLE1            (RBLE1),
        .WaitEn1          (WaitEn1),
        .WaitPol1         (WaitPol1),
        .WSTWR1           (WSTWR1),
        .WSTWEN1          (WSTWEN1),
        .IDCYC1           (IDCYC1),
        .InitSt           (InitSt),
        .BurstWriteSt     (BurstWriteSt),
        .TurnAroundSt     (TurnAroundSt),
        .WaitTxrOnBusSt   (WaitTxrOnBusSt),
        .WaitDeAssrtSt    (WaitDeAssrtSt),
        .CancelWaitSt     (CancelWaitSt),
        .MemoryWrSt       (MemoryWrSt),
        .MemoryRdSt       (MemoryRdSt),
        .Toggle           (Toggle),
        .SmAddrTSM        (SmAddrTSM),
        .BIGENDIAN        (BIGENDIAN),
        .WaitEnReg        (WaitEnReg),
        .BMWriteReg       (BMWriteReg),
        .SyncEnWriteReg   (SyncEnWriteReg),
        .WriteBeatCnt     (WriteBeatCnt),
        .WBstIntrptd      (WBstIntrptd),
        .TxrB4BsyAccptd   (TxrB4BsyAccptd),
        .SlowClkM         (SlowClkM),
 
        .HREADYOUTSMC     (HREADYOUTSMC),
        .HRESPSMC         (HRESPSMC),
        .HRDATASMC        (HRDATASMC),
        .UseSecBuf        (UseSecBuf),
        .HtranRegCont     (HtranRegCont),
        .HtransMemBuf1    (HtransMemBuf1),
        .HsizeEqMWidth    (HsizeEqMWidth),
        .AhbWider         (AhbWider),
        .AhbNarrow        (AhbNarrow),
        .MemWrReq         (MemWrReq),
        .MemRdReq         (MemRdReq),
        .TurnAround       (TurnAround),
        .NewBurst         (NewBurst),
        .AhbCount         (AhbCount),
        .WaitToutErr      (WaitToutErr),
        .NextValByteLane0 (NextValByteLane0),
        .NextValByteLane1 (NextValByteLane1),
        .NextValByteLane2 (NextValByteLane2),
        .NextValByteLane3 (NextValByteLane3),
        .BUSYCYC          (BUSYCYC),
        .IDLECYC          (IDLECYC),
        .WRITECYC         (WRITECYC),
        .AddrBuf1         (AddrBuf1),
        .AddrBuf          (AddrBuf),
        .HwdataBuf        (HwdataBuf),
        .HsizeMemBuf1     (HsizeMemBuf1),
        .HsizeMemBuf      (HsizeMemBuf),
        .HburstMemBuf     (HburstMemBuf),
        .HselMemBuf1      (HselMemBuf1),
        .HselMemBuf       (HselMemBuf),
        .AhbWideRdCnt     (AhbWideRdCnt),
        .AhbWideWrCnt     (AhbWideWrCnt),
        .AddrNotAligned   (AddrNotAligned),
        .MW               (MW),
        .SMBLSPol         (SMBLSPol),
        .BMWrite          (BMWrite),
        .SyncEnWrite      (SyncEnWrite),
        .BurstLenWrite    (BurstLenWrite),
        .AddrValidWriteEn (AddrValidWriteEn),
        .BIWriteEn        (BIWriteEn),
        .RBLE             (RBLE),
        .WaitEn           (WaitEn),
        .WaitPol          (WaitPol),
        .WSTWR            (WSTWR),
        .WSTWEN           (WSTWEN),
        .IDCYC            (IDCYC)
          ) ;

// -----------------------------------------------------------------------------
// Instantiation of SsmcAhbSlvRegIf
// -----------------------------------------------------------------------------
SsmcAhbSlvRegIf uSsmcAhbSlvRegIf (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .HADDRREG        (HADDRREG),
        .HTRANSREG       (HTRANSREG),
        .HWRITEREG       (HWRITEREG),
        .HSIZEREG        (HSIZEREG),
        .HWDATAREG       (HWDATAREG),
        .HSELREG         (HSELREG),
        .HREADYINREG     (HREADYINREG),
        .SMMWCS7         (SMMWCS7),
        .SMBLS7POL       (SMBLS7POL),
        .Revision        (Revision),
        .WaitStatus      (WaitStatus),
        .WaitToutErr     (WaitToutErr),
        .HTRANSSMC       (HTRANSSMC[1]),
        .HSELSMC         (HSELSMC),
        .HREADYINSMC     (HREADYINSMC),
        .HselMemBuf1     (HselMemBuf1),
        .SMBUSREQExt     (SMBUSREQExt),
        .SMTICBUSREQExt  (SMTICBUSREQExt),
        .SMMEMCLKRATIO   (SMMEMCLKRATIO),
        .SMBIGENDIAN     (SMBIGENDIAN),
        .SMEXTBUSMUX     (SMEXTBUSMUX),
        .SMTICBUSGNTEBI  (SMTICBUSGNTEBI),
        .SMBUSGNTEBI     (SMBUSGNTEBI),
        .SMBUSBACKOFFEBI (SMBUSBACKOFFEBI),

        .HRDATAREG       (HRDATAREG),
        .HREADYOUTREG    (HREADYOUTREG),
        .HRESPREG        (HRESPREG),
        .SMTICBUSGNTExt  (SMTICBUSGNTExt),
        .SMBUSGNTExt     (SMBUSGNTExt),
        .SmBusBackOffExt (SmBusBackOffExt),
        .BUSMUXEXT       (BUSMUXEXT),
        .BIGENDIAN       (BIGENDIAN),
        .SMBUSREQEBI     (SMBUSREQEBI),
        .SMTICBUSREQEBI  (SMTICBUSREQEBI),
        .ClockRatio      (ClockRatio),
        .MemClkRegTogl   (MemClkRegTogl),
        .MW1             (MW1),
        .SMBLSPol1       (SMBLSPol1),
        .BMRead1         (BMRead1),
        .BIWriteEn1      (BIWriteEn1),
        .BIReadEn1       (BIReadEn1),
        .WrapRead        (WrapRead),
        .BMWrite1        (BMWrite1),
        .SyncEnRead1     (SyncEnRead1),
        .SyncEnWrite1    (SyncEnWrite1),
        .BurstLenRead1   (BurstLenRead1),
        .BurstLenWrite1  (BurstLenWrite1),
        .AddrValidReadEn1(AddrValidReadEn1),
        .AddrValWriteEn1 (AddrValWriteEn1),
        .SMClockEn       (SMClockEn),
        .WP1             (WP1),
        .RBLE1           (RBLE1),
        .WaitEn1         (WaitEn1),
        .WaitPol1        (WaitPol1),
        .WSTRD1          (WSTRD1),
        .WSTBRD1         (WSTBRD1),
        .WSTWR1          (WSTWR1),
        .WSTOEN1         (WSTOEN1),
        .WSTWEN1         (WSTWEN1),
        .IDCYC1          (IDCYC1)
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcPadIf
// -----------------------------------------------------------------------------
SsmcPadIf uSsmcPadIf (
        .SMFBCLK0         (SMFBCLK0),
        .SMFBCLK1         (SMFBCLK1),
        .SMFBCLK2         (SMFBCLK2),
        .SMFBCLK3         (SMFBCLK3),
        .SMMEMCLK         (SMMEMCLK),
        .nSMMEMCLK        (nSMMEMCLK),
        .SMMEMCLKDELAY    (SMMEMCLKDELAY),
        .HRESETn          (HRESETn),
        .nSMBURSTWAIT     (nSMBURSTWAIT),
        .BIGENDIAN        (BIGENDIAN),
        .HsizeMemBufWr    (HsizeMemBufWr),
        .MWWr             (MWWr),
        .RBLEWr           (RBLEWr),
        .HwdataBuf        (HwdataBuf),
        .MemoryWrSt       (MemoryWrSt),
        .nSMWENMC         (nSMWENMC),
        .SmAddrTSM        (SmAddrTSM),
        .SMADDRMC         (SMADDRMC),
        .nSMBLSMC         (nSMBLSMC),
        .SMDATAIN         (SMDATAIN),
        .NextAsynAxs      (NextAsynAxs),
        .NextSmOEn        (NextSmOEn),
        .NxtSMADDRVALIDMC (NxtSMADDRVALIDMC),
        .NextSMBAAMC      (NextSMBAAMC),
        .NextSMCSMC       (NextSMCSMC),
        .NextSMCSMCn      (NextSMCSMCn),
        .NextSMDATAENMCn  (NextSMDATAENMCn),

        .SMADDR           (SMADDR[25:0]),
        .SmBurstWtFbClk   (SmBurstWtFbClk),
        .SyncWtSingle     (SyncWtSingle),
        .SmDataInFbClk    (SmDataInFbClk),
        .SmDataEnCore     (SmDataEnCore),
        .SmDataOutCore    (SmDataOutCore),
        .SMCS             (SMCS),
        .nSMCS            (nSMCS),
        .SMBAA            (SMBAA),
        .SMADDRVALID      (SMADDRVALID),
        .nSMWEN           (nSMWEN),
        .nSMOEN           (nSMOEN),
        .nSMBLS           (nSMBLS)
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcSynchroniser
// -----------------------------------------------------------------------------
SsmcSynchroniser uSsmcSynchroniser (
        .SMMEMCLK         (SMMEMCLK),
        .HRESETn          (HRESETn),
        .SMWAIT           (SMWAIT),
        .SMCANCELWAIT     (SMCANCELWAIT),
        .WaitPol          (WaitPol),

        .SMWaitSync       (SMWaitSync),
        .SmCancelWaitSync (SmCancelWaitSync)
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcMemTSM
// -----------------------------------------------------------------------------
SsmcMemTSM uSsmcMemTSM (
        .SMMEMCLK         (SMMEMCLK),
        .HRESETn          (HRESETn),
        .MemRdReq         (MemRdReq),
        .MemWrReq         (MemWrReq),
        .AddrBuf1         (AddrBuf1),
        .AddrBuf          (AddrBuf),
        .HburstMemBuf     (HburstMemBuf),
        .HselMemBuf1      (HselMemBuf1),
        .HselMemBuf       (HselMemBuf),
        .HtranRegCont     (HtranRegCont),
        .HtransMemBuf1    (HtransMemBuf1),
        .UseSecBuf        (UseSecBuf),
        .HsizeEqMWidth    (HsizeEqMWidth),
        .AhbWider         (AhbWider),
        .AhbNarrow        (AhbNarrow),
        .AddrNotAligned   (AddrNotAligned),
        .HsizeMemBuf1     (HsizeMemBuf1),
        .HsizeMemBuf      (HsizeMemBuf),
        .SyncWtSingle     (SyncWtSingle),
        .SmBurstWtFbClk   (SmBurstWtFbClk),
        .SMWaitSync       (SMWaitSync),
        .SmCancelWaitSync (SmCancelWaitSync),
        .MW1              (MW1),
        .MW               (MW),
        .SMBLSPol         (SMBLSPol),
        .RBLE             (RBLE),
        .BMRead1          (BMRead1),
        .BMWrite          (BMWrite),
        .WrapRead         (WrapRead),
        .SyncEnRead1      (SyncEnRead1),
        .SyncEnWrite      (SyncEnWrite),
        .BurstLenRead1    (BurstLenRead1),
        .BurstLenWrite    (BurstLenWrite),
        .AddrValidReadEn1 (AddrValidReadEn1),
        .AddrValidWriteEn (AddrValidWriteEn),
        .BIWriteEn        (BIWriteEn),
        .BIReadEn1        (BIReadEn1),
        .WaitEn           (WaitEn),
        .WSTRD1           (WSTRD1),
        .WSTBRD1          (WSTBRD1),
        .WSTWR            (WSTWR),
        .WSTOEN1          (WSTOEN1),
        .WSTWEN           (WSTWEN),
        .IDCYC            (IDCYC),
        .TurnAround       (TurnAround),
        .NewBurst         (NewBurst),
        .SMClockEn        (SMClockEn),
        .ClockRatio       (ClockRatio),
        .SMBUSGNT         (SMBUSGNT),
        .BUSYCYC          (BUSYCYC),
        .IDLECYC          (IDLECYC),
        .WRITECYC         (WRITECYC),
        .AhbWideWrCnt     (AhbWideWrCnt),
        .AhbWideRdCnt     (AhbWideRdCnt),
        .AhbCount         (AhbCount),
        .NextValByteLane0 (NextValByteLane0),
        .NextValByteLane1 (NextValByteLane1),
        .NextValByteLane2 (NextValByteLane2),
        .NextValByteLane3 (NextValByteLane3),
        .NextAsynAxs      (NextAsynAxs),
        .NextSmOEn        (NextSmOEn),
        .NxtSMADDRVALIDMC (NxtSMADDRVALIDMC),
        .NextSMBAAMC      (NextSMBAAMC),
        .NextSMCSMC       (NextSMCSMC),
        .NextSMCSMCn      (NextSMCSMCn),
        .NextSMDATAENMCn  (NextSMDATAENMCn),

        .MWWr             (MWWr),
        .RBLEWr           (RBLEWr),
        .HsizeMemBufWr    (HsizeMemBufWr),
        .HsizeEqMWidthWr  (HsizeEqMWidthWr),
        .AhbWiderWr       (AhbWiderWr),
        .AhbNarrowWr      (AhbNarrowWr),
        .nSMWENMC         (nSMWENMC),
        .SmCSTSM          (SmCSTSM),
        .DelSmCSTSM       (DelSmCSTSM),
        .SmAddrTSM        (SmAddrTSM),
        .SMADDRMC         (SMADDRMC),
        .nSMBLSMC         (nSMBLSMC),
        .InitSt           (InitSt),
        .BurstWriteSt     (BurstWriteSt),
        .TurnAroundSt     (TurnAroundSt),
        .WaitTxrOnBusSt   (WaitTxrOnBusSt),
        .WaitDeAssrtSt    (WaitDeAssrtSt),
        .CancelWaitSt     (CancelWaitSt),
        .MemoryRdSt       (MemoryRdSt),
        .MemoryWrSt       (MemoryWrSt),
        .WBstIntrptd      (WBstIntrptd),
        .TxrB4BsyAccptd   (TxrB4BsyAccptd),
        .Toggle           (Toggle),
        .WaitWrCycVer     (WaitWrCycVer),
        .WaitWrCycDup     (WaitWrCycDup),
        .WaitWrCycAhb     (WaitWrCycAhb),
        .WaitRdCyc        (WaitRdCyc),
        .WaitRdCycVer     (WaitRdCycVer),
        .SyncEnWriteReg   (SyncEnWriteReg),
        .WaitEnReg        (WaitEnReg),
        .BMWriteReg       (BMWriteReg),
        .WriteBeatCnt     (WriteBeatCnt),
        .WaitStatus       (WaitStatus),
        .nSmBurstWaitReg  (nSmBurstWaitReg),
        .ClkStpd          (ClkStpd),
        .SMBUSREQ         (SMBUSREQ)
           );

// -----------------------------------------------------------------------------
// Instantiation of SsmcDerivedClk
// -----------------------------------------------------------------------------
SsmcDerivedClk uSsmcDerivedClk (
        .HCLK            (HCLK),
        .HRESETn         (HRESETn),
        .SMMEMCLK        (SMMEMCLK),
        .ClockRatio      (ClockRatio),
        .MemClkRegTogl   (MemClkRegTogl),

        .SlowClkM        (SlowClkM)
           );

endmodule
// --================================== End ==================================--
