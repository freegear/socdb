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
// File Name              : SsmcMemTSM.v.rca
// File Revision          : 1.35
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is responsible for issuing Read and Write Control
//           Signals to Memory devices.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SsmcParams.v"

// -----------------------------------------------------------------------------

module SsmcMemTSM (
// Inputs
                   SMMEMCLK,
                   HRESETn,
                   MemRdReq,
                   MemWrReq,
                   AddrBuf1,
                   AddrBuf,
                   HburstMemBuf,
                   HselMemBuf1,
                   HselMemBuf,
                   HtranRegCont,
                   HtransMemBuf1,
                   UseSecBuf,
                   HsizeEqMWidth,
                   AhbWider,
                   AhbNarrow,
                   AddrNotAligned,
                   HsizeMemBuf1,
                   HsizeMemBuf,
                   SyncWtSingle,
                   SmBurstWtFbClk,
                   SMWaitSync,
                   SmCancelWaitSync,
                   MW1,
                   MW,
                   SMBLSPol,
                   RBLE,
                   BMRead1,
                   BMWrite,
                   WrapRead,
                   SyncEnRead1,
                   SyncEnWrite,
                   BurstLenRead1,
                   BurstLenWrite,
                   AddrValidReadEn1,
                   AddrValidWriteEn,
                   BIWriteEn,
                   BIReadEn1,
                   WaitEn,
                   WSTRD1,
                   WSTBRD1,
                   WSTWR,
                   WSTOEN1,
                   WSTWEN,
                   IDCYC,
                   TurnAround,
                   NewBurst,
                   SMClockEn,
                   ClockRatio,
                   SMBUSGNT,
                   BUSYCYC,
                   IDLECYC,
                   WRITECYC,
                   AhbWideWrCnt,
                   AhbWideRdCnt,
                   AhbCount,
                   NextValByteLane0,
                   NextValByteLane1,
                   NextValByteLane2,
                   NextValByteLane3,
// Outputs
                   MWWr,
                   RBLEWr,
                   HsizeEqMWidthWr,
                   AhbWiderWr,
                   AhbNarrowWr,
                   HsizeMemBufWr,
                   nSMWENMC,
                   SmCSTSM,
                   DelSmCSTSM,
                   SmAddrTSM,
                   SMADDRMC,
                   nSMBLSMC,
                   InitSt,
                   BurstWriteSt,
                   TurnAroundSt,
                   WaitTxrOnBusSt,
                   WaitDeAssrtSt,
                   CancelWaitSt,
                   MemoryRdSt,
                   MemoryWrSt,

                   NextAsynAxs,
                   NextSmOEn,
                   NxtSMADDRVALIDMC,
                   NextSMBAAMC,
                   NextSMCSMC,
                   NextSMCSMCn,
                   NextSMDATAENMCn,
                   WBstIntrptd,
                   TxrB4BsyAccptd,
                   Toggle,
                   WaitWrCycVer,
                   WaitWrCycDup,
                   WaitWrCycAhb,
                   WaitRdCyc,
                   WaitRdCycVer,
                   SyncEnWriteReg,
                   WaitEnReg,
                   BMWriteReg,
                   WriteBeatCnt,
                   WaitStatus,
                   nSmBurstWaitReg,
                   ClkStpd,
                   SMBUSREQ
                   );

// Inputs
input         SMMEMCLK;         // Memory Clock
input         HRESETn;          // AHB system level Reset
input         MemRdReq;         // Signal indicating the read transfer
                                // being initiated
input         MemWrReq;         // Signal indicating the write
                                // transfer has been initiated
input  [25:0] AddrBuf1;         // Level1 Buffer to hold HADDRSMC
input  [25:0] AddrBuf;          // Buffered AHB Address
input   [2:0] HburstMemBuf;     // Buffered HBURSTSMC
input   [7:0] HselMemBuf1;      // 1st level registered HSELSMC
input         UseSecBuf;        // Indication to use second level buffered
                                // resources during Write
input   [7:0] HselMemBuf;       // Buffered HSELSMC
input   [1:0] HtranRegCont;     // HTRANS registered on every clock
input   [1:0] HtransMemBuf1;    // Level1 Buffer to hold HTRANSSMC
input         HsizeEqMWidth;    // Indication that AHB and Memory are
                                // of same width
input         AhbWider;         // Indication that AHB Width is
                                // greater than Memory Width
input         AhbNarrow;        // Indication that AHB Width is
                                // Narrower than Memory Width
input         AddrNotAligned;   // Indication that starting address is
                                // not aligned to Memory Width
input   [1:0] HsizeMemBuf1;     // Level1 buffer to hold HSIZESMC
input   [1:0] HsizeMemBuf;      // Buffered AHB HSIZESMC
input         SyncWtSingle;     // Single bit Synchronous Wait
input         SmBurstWtFbClk;   // nSMBURSTWAIT registered on SMFBCLK
input         SMWaitSync;       // Double Synchronised External wait
input         SmCancelWaitSync; // Double synchronised External wait
                                // termination
input   [1:0] MW1;              // 1st level registered memory width bits
                                // selection from one of the bank registers
input   [1:0] MW;               // The memory width bits selection
                                // from one of the bank registers
input         SMBLSPol;         // Byte lane polarity bit selection from one of
                                // the bank registers
input         RBLE;             // Byte lane enabled device
input         BMRead1;          // 1st level Burst Mode read
input         BMWrite;          // Burst Mode Write indication
input         WrapRead;         // Enables the wrapping burst feature from
                                // memory
input         SyncEnRead1;      // 1st level Sync burst Mode read
input         SyncEnWrite;      // Synchronous burst Mode Write
input   [1:0] BurstLenRead1;    // 1st level Burst transfer length, by Burst
                                // devices for Read
input   [1:0] BurstLenWrite;    // Burst transfer length, supported by
                                // burst devices for Write
input         AddrValidReadEn1; // 1st level SMADDRVALID enable during Read
input         AddrValidWriteEn; // SMADDRVALID enable during Write
input         BIWriteEn;        // Indication that SMBAA active during
                                // Synchronous Burst Write access.
input         BIReadEn1;        // Indication that SMBAA and nSMIND
                                // active during Synchronous Burst Read
                                // access, 1st level buffered
input         WaitEn;           // Enable signal for using SMWAIT
                                // input
input   [4:0] WSTRD1;           // 1st level Single Read access count
input   [4:0] WSTBRD1;          // 1st level Burst Read access count
input   [4:0] WSTWR;            // Single Write access count for the
                                // bank targeted currently
input   [3:0] WSTOEN1;          // 1st level Delay value for assertion of OEN
input   [3:0] WSTWEN;           // Delay value for the assertion of
                                // the WEN and nSMCS signals
input   [3:0] IDCYC;            // Count value for the turnaround
                                // cycles
input         TurnAround;       // TurnAround indication for R->W
input         NewBurst;         // Indication that Burst Broken
input         SMClockEn;        // Zero on this bit indicates that
                                // Clock should be active during Memory
                                // accesses. One on this bit indicates
                                // that clock is always running
input   [1:0] ClockRatio;       // Indicates ratio of Memory Clock
                                // with respect to HCLK
input         SMBUSGNT;         // Bus Grant input to SSMCCore from
                                // DBI module
input         BUSYCYC;          // Indication that SM is in
                                // ST_MEM_BUSY state
input         IDLECYC;          // Indication that SM is in
                                // ST_MEM_NOT_SEL state
input         WRITECYC;         // Indication that SM is in
                                // ST_MEM_WRITE state
input   [2:0] AhbWideWrCnt;     // Write counter when AHB > MW
input   [2:0] AhbWideRdCnt;     // Counter which indicates number of
                                // Memory accesses required for one AHB
                                // Read transfer
input   [4:0] AhbCount;         // Count which indicates the number of
                                // Memory transfer requested by AHB
input         NextValByteLane0; // Indication that Byte Lane0 is valid during
                                // write operation
input         NextValByteLane1; // Indication that Byte Lane1 is valid during
                                // write operation
input         NextValByteLane2; // Indication that Byte Lane2 is valid during
                                // write operation
input         NextValByteLane3; // Indication that Byte Lane3 is valid during
                                // write operation

// Outputs
output  [1:0] MWWr;             // Buffered MW while writing
output        RBLEWr;           // RBLE registered during write operation
output        HsizeEqMWidthWr;  // Indication that AHB and Memory are
                                // of same width
output        AhbWiderWr;       // Indication that AHB Width is
                                // greater than Memory Width
output        AhbNarrowWr;      // Indication that AHB Width is
                                // Narrower than Memory Width
output  [1:0] HsizeMemBufWr;    // Buffered HsizeMemBuf while writing
output        nSMWENMC;         // Memory Write Enable, Active LOW
output        SmCSTSM;          // Chip Select Assertion
output        DelSmCSTSM;       // Delayed version of SmCSTSM

output         NextAsynAxs;      // Indication of Asynchronous memory access
output         NextSmOEn;        // Memory Output Enable, Active Low
output         NxtSMADDRVALIDMC; // External address valid output, used to indicate
output         NextSMBAAMC;      // External burst Address advance signal. Used to
output [7:0]   NextSMCSMC;       // Active high chip select when Asynchronous
output [7:0]   NextSMCSMCn;      // Active low chip select when Asynchronous
output [3:0]   NextSMDATAENMCn;  // Data enable when Asynchronous memory access
                                // transfers
                                // count in the external Memory device
output  [1:0] SmAddrTSM;        // Memory address from TSM Module
output [25:0] SMADDRMC;         // Memory address output when Asynchronous
                                // memory access is progressing
output  [3:0] nSMBLSMC;         // Byte Lane select when Asynchronous memory
                                // access is progressing
output        InitSt;           // Indication that Memory SM is in
                                // ST_NO_REQ State
output        BurstWriteSt;     // Indication that Memory SM is in
                                // ST_BURST_WRITE State
output        TurnAroundSt;     // Indication that Memory SM is in
                                // ST_TURNAROUND State
output        WaitTxrOnBusSt;   // Indication that Memory SM is in
                                // ST_WAITTXRONBUS State
output        WaitDeAssrtSt;    // Indication that Memory SM is in
                                // ST_WAIT_DEASSERTED State
output        CancelWaitSt;     // Indication that Memory SM is in
                                // ST_CANCELWAIT State
output        MemoryRdSt;       // Indication that Memory TSM is in
                                // Read State
output        MemoryWrSt;       // Indication that Memory TSM is in
                                // Write State
output        Toggle;           // Indication of State switching when
                                // SM is waiting for transfer on AHB
                                // Bus
output        WBstIntrptd;

output        TxrB4BsyAccptd;
  
output        WaitWrCycVer;     // Memory device write completion
                                // signal
output        WaitWrCycDup;     // Memory device write completion
                                // signal when Wait Transfer is
                                // pipelined
output        WaitWrCycAhb;     // Memory device write completion
                                // signal when Synchronous Transfer is
                                // pipelined
output        WaitRdCyc;        // Memory device read completion
                                // signal
output        WaitRdCycVer;     // Version of WaitRdCyc
output        SyncEnWriteReg;   // Synchronous Write Enable signal
                                // registered when write begins
output        WaitEnReg;        // Wait Enable signal registered when
                                // write begins
output        BMWriteReg;       // Burst Mode Write indication
                                // registered when write begins
output  [2:0] WriteBeatCnt;     // Counter used for carrying out Burst
                                // Write
output        WaitStatus;       // Wait status for enabled transfers
output        nSmBurstWaitReg;  // Registered nSMBURSTWAIT
output        ClkStpd;          // Signal to indicate that clock
                                // output should be stopped
output        SMBUSREQ;         // Bus Request signal to DBI

// Inputs
wire        SMMEMCLK;           // Memory Clock
wire        HRESETn;            // AHB system level Reset
wire        MemRdReq;           // Signal indicating the read transfer
                                // being initiated
wire        MemWrReq;           // Signal indicating the write
                                // transfer has been initiated
wire [25:0] AddrBuf1;           // Level1 Buffer to hold HADDRSMC
wire [25:0] AddrBuf;            // Buffered AHB Address
wire  [2:0] HburstMemBuf;       // Buffered HBURSTSMC
wire  [7:0] HselMemBuf1;        // 1st level registered HSELSMC
wire          UseSecBuf;        // Indication to use second level buffered
                                // resources during Write
wire  [7:0] HselMemBuf;         // Buffered HSELSMC
wire  [1:0] HtranRegCont;       // HTRANS registered on every clock
wire  [1:0] HtransMemBuf1;      // Level1 Buffer to hold HTRANSSMC
wire        HsizeEqMWidth;      // Indication that AHB and Memory are
                                // of same width
wire        AhbWider;           // Indication that AHB Width is
                                // greater than Memory Width
wire        AhbNarrow;          // Indication that AHB Width is
                                // Narrower than Memory Width
wire        AddrNotAligned;     // Indication that starting address is
                                // not aligned to Memory Width
wire  [1:0] HsizeMemBuf1;       // Level1 buffer to hold HSIZESMC
wire  [1:0] HsizeMemBuf;        // Buffered AHB HSIZESMC
wire        SyncWtSingle;       // Single bit Synchronous Wait
wire        SmBurstWtFbClk;     // nSMBURSTWAIT registered on SMFBCLK
wire        SMWaitSync;         // Double Synchronised External wait
wire        SmCancelWaitSync;   // Double synchronised External wait
                                // termination
wire  [1:0] MW1;                // 1st level registered memory width bits
                                // selection from one of the bank registers
wire  [1:0] MW;                 // The memory width bits selection
                                // from one of the bank registers
wire        SMBLSPol;           // Byte lane polarity bit selection from one of
                                // the bank registers
wire        RBLE;               // Byte lane enabled device
wire        BMRead1;            // 1st level Burst Mode read
wire        BMWrite;            // Burst Mode Write indication
wire        WrapRead;           // Enables the wrapping burst feature from
                                // memory
wire        SyncEnRead1;        // 1st level Sync burst Mode read
wire        SyncEnWrite;        // Synchronous burst Mode Write
wire  [1:0] BurstLenRead1;      // 1st level Burst transfer length, by Burst
                                // devices for Read
wire  [1:0] BurstLenWrite;      // Burst transfer length, supported by
                                // burst devices for Write
wire        AddrValidReadEn1;   // 1st level SMADDRVALID enable during Read
wire        AddrValidWriteEn;   // SMADDRVALID enable during Write
wire        BIWriteEn;          // Indication that SMBAA active during
                                // Synchronous Burst Write access.
wire        BIReadEn1;          // Indication that SMBAA active during
                                // active during Synchronous Burst Read
                                // access, 1st level buffered
wire        WaitEn;             // Enable signal for using SMWAIT
                                // input
wire  [4:0] WSTRD1;             // 1st level Single Read access count
wire  [4:0] WSTBRD1;            // 1st level Burst Read access count
wire  [4:0] WSTWR;              // Single Write access count for the
                                // bank targeted currently
wire  [3:0] WSTOEN1;            // 1st level Delay value for assertion of OEN
wire  [3:0] WSTWEN;             // Delay value for the assertion of
                                // the WEN and nSMCS signals
wire  [3:0] IDCYC;              // Count value for the turnaround
                                // cycles


wire        TurnAround;         // TurnAround indication for R->W
wire        NewBurst;           // Indication that Burst Broken
wire        SMClockEn;          // Zero on this bit indicates that
                                // Clock should be active during Memory
                                // accesses. One on this bit indicates
                                // that clock is always running
wire  [1:0] ClockRatio;         // Indicates ratio of Memory Clock
                                // with respect to HCLK
wire        SMBUSGNT;           // Bus Grant input to SSMCCore from
                                // DBI module
wire        BUSYCYC;            // Indication that SM is in
                                // ST_MEM_BUSY state
wire        IDLECYC;            // Indication that SM is in
                                // ST_MEM_NOT_SEL state
wire        WRITECYC;           // Indication that SM is in
                                // ST_MEM_WRITE state
wire  [2:0] AhbWideWrCnt;       // Write counter when AHB > MW
wire  [2:0] AhbWideRdCnt;       // Counter which indicates number of
                                // Memory accesses required for one AHB
                                // Read transfer
wire  [4:0] AhbCount;           // Count which indicates the number of
                                // Memory transfer requested by AHB
wire        NextValByteLane0;   // Indication that Byte Lane0 is valid during
                                // write operation
wire        NextValByteLane1;   // Indication that Byte Lane1 is valid during
                                // write operation
wire        NextValByteLane2;   // Indication that Byte Lane2 is valid during
                                // write operation
wire        NextValByteLane3;   // Indication that Byte Lane3 is valid during
                                // write operation

// Outputs
wire  [1:0] MWWr;               // Buffered MW while writing
wire        RBLEWr;             // RBLE registered during write operation
wire        HsizeEqMWidthWr;    // Indication that AHB and Memory are
                                // of same width
wire        AhbWiderWr;         // Indication that AHB Width is
                                // greater than Memory Width
wire        AhbNarrowWr;        // Indication that AHB Width is
                                // Narrower than Memory Width
wire  [1:0] HsizeMemBufWr;      // Buffered HsizeMemBuf while writing
wire        nSMWENMC;           // Memory Write Enable, Active LOW
wire        SmCSTSM;            // Chip Select Assertion
reg         DelSmCSTSM;         // Delayed version of SmCSTSM
wire  [1:0] SmAddrTSM;          // Memory address from TSM Module
wire [25:0] SMADDRMC;           // Memory address output when Asynchronous
                                // memory access is progressing
wire  [3:0] nSMBLSMC;           // Byte Lane select when Asynchronous memory
                                // access is progressing
wire        InitSt;             // Indication that Memory SM is in
                                // ST_NO_REQ State
wire        BurstWriteSt;       // Indication that Memory SM is in
                                // ST_BURST_WRITE State
wire        TurnAroundSt;       // Indication that Memory SM is in
                                // ST_TURNAROUND State
wire        WaitTxrOnBusSt;     // Indication that Memory SM is in
                                // ST_WAITTXRONBUS State
wire        WaitDeAssrtSt;      // Indication that Memory SM is in
                                // ST_WAIT_DEASSERTED State
wire        CancelWaitSt;       // Indication that Memory SM is in
                                // ST_CANCELWAIT State
wire        MemoryRdSt;         // Indication that Memory TSM is in
                                // Read State
wire        MemoryWrSt;         // Indication that Memory TSM is in
                                // Write State
wire        Toggle;             // Indication of State switching when
                                // SM is waiting for transfer on AHB
                                // Bus
wire        WaitWrCycVer;       // Memory device write completion
                                // signal
wire        WaitWrCycDup;       // Memory device write completion
                                // signal when Wait Transfer is
                                // pipelined
wire        WaitWrCycAhb;       // Memory device write completion
                                // signal when Synchronous Transfer is
                                // pipelined
wire        WaitRdCyc;          // Memory device read completion
                                // signal
wire        WaitRdCycVer;       // Version of WaitRdCyc
wire        SyncEnWriteReg;     // Synchronous Write Enable signal
                                // registered when write begins
wire        WaitEnReg;          // Wait Enable signal registered when
                                // write begins
wire        BMWriteReg;         // Burst Mode Write indication
                                // registered when write begins
wire  [2:0] WriteBeatCnt;       // Counter used for carrying out Burst
                                // Write
wire        WaitStatus;         // Wait status for enabled transfers
wire        nSmBurstWaitReg;    // Registered nSMBURSTWAIT
wire        ClkStpd;            // Signal to indicate that clock
                                // output should be stopped
wire        SMBUSREQ;           // Bus Request signal to DBI

// -----------------------------------------------------------------------------
//
//                                 SsmcMemTSM
//                                 ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//           The Transfer State Machine (TSM) block controls all the
//           transactions of the SsmcCore block to the external memory device.
//           The control signals for the read and write access are generated
//           depending on the type of transfer and the device characteristics.
//           External bus turnaround cycles are initiated appropriately after a
//           read transfer completion.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        SleepMode;
// Indication that Busy is driven on AHB

wire [25:0] IncrAddr;
// Incremented Memory Address

wire [25:0] IncrAddrWr;
// Incremented Memory Address during Write

wire        ReadSt;
// Indication that Memory SM is in Read state

wire        BurstReadSt;
// Indication that Memory SM is in Burst Read state

wire        WriteSt;
// Indication that Memory SM is in Write state

wire        WaitAssrtSt;
// Indication that Memory SM is in Wait Asserted state

wire        iBurstWriteSt;
// Internal signal of BurstWriteSt

wire        iTurnAroundSt;
// Internal signal of TurnAroundSt

wire        iWaitTxrOnBusSt;
// Internal signal of WaitTxrOnBusSt

wire        iWaitDeAssrtSt;
// Internal signal of WaitDeAssrtSt

wire        iCancelWaitSt;
// Internal signal of CancelWaitSt

wire        IndAssrtd;
// Indication that nSMIND will be asserted

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg  [10:0] SmTSMState;
// State Vector for Memory SM

reg  [10:0] NextSmTSMState;
// D-Input of SmTSMState

reg         iSmCSTSM;
// Internal signal of SmCSTSM

reg         NextSmCSTSM;
// D-Input of iSmCSTSM

reg         iSmOEnMC;
// Internal signal of nSMOENMC

reg         NextSmOEn;
// D-Input of iSmOEnMC

reg         DelSmOEnMC;
// 1 SMMEMCLK Delayed SmOEn

reg         iWaitRdCyc;
// Internal signal of WaitRdCyc

reg         iWaitRdCycVer;
// Internal signal of WaitRdCycVer

reg         NextWaitRdCycVer;
// D-Input of WaitRdCycVer

reg         iWaitWrCycVer;
// Internal signal of WaitWrCycVer

reg         NextWaitWrCycVer;
// D-Input of iWaitWrCycVer

reg         WaitWrCycVerAnd;
// AND'ed version of WaitWrCycVer

reg         iWaitWrCycDup;
// Another version of WaitWrCycVer, which has the same timing as that of
// WaitWrCycVer. It is de-asserted when there is a Wait Enabled transfer
// pending. In this case WaitWrCycVer cannot be asserted.

reg         NextWaitWrCycDup;
// D-Input of iWaitWrCycDup

reg         iWaitWrCycAhb;
// Another version of WaitWrCycVer, which has the same timing as that of
// WaitWrCycVer. It is de-asserted when there is a Synchronous Write Transfer.

reg         NextWaitWrCycAhb;
// D-Input of iWaitWrCycAhb

reg  [25:0] iSmAddrTSM;
// Internal signal of SmAddrTSM

reg  [25:0] NextSmAddrTSM;
// D-Input of iSmAddrTSM

reg  [25:0] iSMADDRMC;
// Internal signal of SMADDRMC

reg  [25:0] NextSMADDRMC;
// D-Input of iSMADDRMC

reg         iSMWENMC;
// Internal signal of nSMWENMC

reg         NextSmWrEn;
// D-Input of iSMWENMC

reg         iSMADDRVALIDMC;
// Internal signal of SMADDRVALIDMC

reg         NxtSMADDRVALIDMC;
// D-Input of iSMADDRVALIDMC

reg         iSMBAAMC;
// Internal signal of SMBAAMC

reg         NextSMBAAMC;
// D-Input of iSMBAAMC

reg         iSMBUSREQ;
// Internal signal of SMBUSREQ

reg         NextSMBUSREQ;
// D-Input of iSMBUSREQ

reg   [4:0] WstLongRdCnt;
// Counter to count wait states for Long Read

reg   [4:0] NextWstLongRdCnt;
// D-Input of WstLongRdCnt

reg   [4:0] WstBrstRdCnt;
// Counter to count wait states for Burst Read

reg   [4:0] NextWstBrstRdCnt;
// D-Input of WstBrstRdCnt

reg   [4:0] WstWrCnt;
// Counter to count wait states for Write

reg   [4:0] NextWstWrCnt;
// D-Input of WstWrCnt

reg   [3:0] WstWrEnCnt;
// Counter to count wait states for Write Enable assertion

reg   [3:0] NextWstWrEnCnt;
// D-Input of WstWrEnCnt

reg   [3:0] WstOEnCnt;
// Counter to count wait states for Output Enable assertion

reg   [3:0] NextWstOEnCnt;
// D-Input of WstOEnCnt

reg   [4:0] BeatCount;
// Counter to count number of possible Memory accesses

reg   [4:0] NextBeatCount;
// D-Input of BeatCount

reg         SleepModeReg;
// Mode where BUSY was driven on AHB, so control signals are freezed

reg         NextSleepModeReg;
// D-Input of SleepModeReg

reg   [3:0] IDCYRead;
// Registered IDCYC values in Read states

reg   [3:0] NextIDCYRead;
// D-Input of IDCYRead

reg   [3:0] IdcyCount;
// Counter used for carrying out Turnaround

reg   [3:0] NextIdcyCount;
// D-Input of IdcyCount

reg   [2:0] iWriteBeatCnt;
// Counter used for carrying out Burst Write

reg   [2:0] NextWriteBeatCnt;
// D-Input of iWriteBeatCnt

wire  [2:0] WrBtCntCpy;
// Copy of WriteBeatCnt before making a state transition to ST_BURST_WRITE state

reg         DelSMWENMC;
// 1 SMMEMCLK Delayed iSMWENMC

reg         iToggle;
// Internal signal of Toggle

reg         NextToggle;
// D-Input of iToggle

reg   [7:0] HselMemBufWr;
// HselMemBuf registered during write operation

reg   [7:0] NextHselMemBufWr;
// D-Input of HselMemBufWr

reg   [2:0] HburstMemBufWr;
// HburstMemBuf registered during write operation

reg   [2:0] NextHburstMemBufWr;
// D-Input of HburstMemBufWr

reg   [1:0] iMWWr;
// MW registered during write operation

reg   [1:0] NextMWWr;
// D-Input of iMWWr

reg         SMBLSPolWr;
// SMBLSPol registered during write operation

reg         NextSMBLSPolWr;
// D-Input of SMBLSPolWr

reg   [1:0] iHsizeMemBufWr;
// Internal signal of HsizeMemBufWr

reg   [1:0] NxtHsizeMemBufWr;
// D-Input of iHsizeMemBufWr

reg         iHsizeEqMWidthWr;
// Internal signal of HsizeEqMWidthWr

reg         NextHsizeEqMW;
// D-Input of HsizeEqMWidthWr

reg         iAhbWiderWr;
// Internal signal of AhbWiderWr

reg         NextAhbWiderWr;
// D-Input of iAhbWiderWr

reg         iAhbNarrowWr;
// Internal signal of iAhbNarrowWr

reg         NextAhbNarrowWr;
// D-Input of iAhbNarrowWr

reg         iRBLEWr;
// Internal signal of RBLEWr

reg         NextRBLEWr;
// D-Input of iRBLEWr

reg         WriteProg;
// Indication of Write in progress for wait enabled transfers

reg         NextWriteProg;
// D-Input of WriteProg

reg         iWaitEnReg;
// Internal signal of WaitEnReg

reg         NextWaitEnReg;
// D-Input of iWaitEnReg

reg         iSyncEnWriteReg;
// Internal signal of SyncEnWriteReg

reg         NextSyncEnWr;
// D-Input of iSyncEnWriteReg

reg         iBMWriteReg;
// Internal signal of BMWriteReg

reg         NextBMWriteReg;
// D-Input of iBMWriteReg

reg         BIWriteEnReg;
// Internal signal of BMWriteReg

reg         NextBIWriteEnReg;
// D-Input of iBMWriteReg

reg   [1:0] BurstLenWrReg;
// Burst Length indication registered when write begins.

reg   [1:0] NextBurstLenWr;
// D-Input of BurstLenWrReg

reg         AddrValWrEnReg;
// Address Valid indication registered when write begins.

reg         NextAddrValWrReg;
// D-Input of AddrValWrEnReg

reg   [3:0] WSTWENReg;
// Write Enable Delay value registered when write begins.

reg   [3:0] NextWSTWENReg;
// D-Input of WSTWENReg

reg   [4:0] WSTWRReg;
// Write Delay value registered when write begins.

reg   [4:0] NextWSTWRReg;
// D-Input of WSTWENReg

reg         SmBurstWaitReg;
// Registered SmBurstWtFbClk

reg         SyncWtOnMCLK;
// Registered nSMBURSTWAIT on SMMEMCLK

reg        DelSmBurstWait;
// 1 SMMemClk Delayed SmBurstWaitReg

reg   [2:0] AhbWideRdReg;
// Registered AhbWideRdCnt during Read transfers

reg   [2:0] NextAhbWideRdReg;
// D-Input of AhbWideRdReg

reg         StopBurst;
// // Indication to stop burst Transfer

reg         NextStopBurst;
// D-Input of StopBurst

reg         ContWithBrst;
// Indication as to continue with Burst Write for Synchronous Memories

reg         NextContWithBrst;
// D-Input of ContWithBrst

reg         iClkStpd;
// Internal signal of ClkStpd

reg         NextClkStpd;
// D-Input of iClkStpd

reg   [2:0] DelAhbWideWrCnt;
// Delayed DelAhbWideWrCnt

reg         NewBrstOccrd;
// Indication that NewBurst was sampled in ST_BURST_READ state

reg         NextNewBrstOccrd;
// D-Input of NewBrstOccrd

reg   [7:0] iSMCSMC;
// Internal signal of SMCSMC

reg   [7:0] NextSMCSMC;
// D-Input of iSMCSMC

reg   [7:0] iSMCSMCn;
// Internal signal of nSMCSMC

reg   [7:0] NextSMCSMCn;
// D-Input of iSMCSMCn

reg   [3:0] iSMDATAENMCn;
// Internal signal of nSMDATAENMC

reg   [3:0] NextSMDATAENMCn;
// D-Input of iSMDATAENMCn

reg   [3:0] iSMBLSMCn;
// Internal signal of nSMBLSMC

reg   [3:0] NextSMBLSMCn;
// D-Input of iSMBLSMCn

reg         iAsynAxs;
// Internal signal of AsynAxs

reg         NextAsynAxs;
// D-Input of iAsynAxs

reg         Stop2WtWrCyc;
// Signal to stop extra WaitWrCycVer assertion when Burst write is in progress

reg         NextStop2WtWrCyc;
// D-Input of Stop2WtWrCyc

reg   [4:0] Temp_Concat;
// Temporary variable

reg iWBstIntrptd;
// Indication that synchronous write burst was interrupted

reg NextWBstIntrptd;
// D-Input of WBstIntrptd

reg FirstSyncWt;
// Indication that synchronous wait was asserted for first time

reg NextFirstSyncWt;
// D-Input of FirstSyncWt

reg XtraTxr;
// Extra write transfer accepted

reg NextXtraTxr;
// D-Input of XtraTxr

reg DelWaitWrCycVer;
// Delayed version of WaitWrCycVerAnd

wire TxrB4BsyAccptd;
// Extra write transfer accepted

reg iTxrB4BsyAccptd;
// Extra write transfer accepted

reg NextTxrB4BsyAccptd;
// D-Input of XtraTxr

reg DelUseSecBuf;  
// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// AddrIncr:
// This Function increments the Address based on Memory Width, AHB Width and
// HBURST information.
// This function is provided to increment the 26 bit Memory Address, in terms of
// nibble counter. This function is provided so that the synthesis tool does not
// blow up the counter logic. This function can be easily changed to suit any
// particular tool.
// -----------------------------------------------------------------------------
function [25:0] AddrIncr;
input [25:0] Addr;
input [1:0]  MemWidth;
input [1:0]  AhbWidth;
input [2:0]  Hburst;

reg   [3:0]  Concat;
// Temporary variable to hold the Memory Width and AHB Width

reg   [25:0] Result;
// return from function

begin
  Concat         = ({MemWidth, AhbWidth});
  Result         = Addr;
  case (Hburst)
    `HBURST_INCR, `HBURST_INCR4, `HBURST_INCR8, `HBURST_INCR16, `HBURST_SINGLE :
      begin
        case (MemWidth)
          `MEM_BYTE :
            begin
              Result[25:4]     = Addr[25:4];
              Result[3:0]      = Addr[3:0] + 4'b0001;
              if (&(Addr[3:0]) == 1'b1)
                begin
                  Result[7:4]      = (Addr[7:4]) + 4'b0001;
                  if (&(Addr[7:4]) == 1'b1)
                    begin
                      Result[11:8]     = (Addr[11:8]) + 4'b0001;
                      if (&(Addr[11:8]) == 1'b1)
                        begin
                          Result[15:12]    = (Addr[15:12]) + 4'b0001;
                          if (&(Addr[15:12]) == 1'b1)
                            begin
                              Result[19:16]    = (Addr[19:16]) + 4'b0001;
                              if (&(Addr[19:16]) == 1'b1)
                                begin
                                  Result[23:20]    = (Addr[23:20]) + 4'b0001;
                                  if (&(Addr[23:20]) == 1'b1)
                                    Result[25:24]    = (Addr[25:24]) + 2'b01;
                                end
                            end
                        end
                    end
                end
            end
  
          `MEM_HWORD :
            begin
              Result[25:5]     = Addr[25:5];
              Result[4:1]      = (Addr[4:1]) + 4'b0001;
              if (&(Addr[4:1]) == 1'b1)
                begin
                  Result[8:5]      = (Addr[8:5]) + 4'b0001;
                  if (&(Addr[8:5]) == 1'b1)
                    begin
                      Result[12:9]     = (Addr[12:9]) + 4'b0001;
                      if (&(Addr[12:9]) == 1'b1)
                        begin
                          Result[16:13]    = (Addr[16:13]) + 4'b0001;
                          if (&(Addr[16:13]) == 1'b1)
                            begin
                              Result[20:17]    = (Addr[20:17]) + 4'b0001;
                              if (&(Addr[20:17]) == 1'b1)
                                begin
                                  Result[24:21]    = (Addr[24:21]) + 4'b0001;
                                  if (&(Addr[24:21]) == 1'b1)
                                    Result[25]       =  ~(Addr[25]);
                                end
                            end
                        end
                    end
                end
            end
  
          `MEM_WORD :
            begin
              Result[25:6]     = Addr[25:6];
              Result[5:2]      = (Addr[5:2]) + 4'b0001;
              if (&(Addr[5:2]) == 1'b1)
                begin
                  Result[9:6]      = (Addr[9:6]) + 4'b0001;
                  if (&(Addr[9:6]) == 1'b1)
                    begin
                      Result[13:10]    = (Addr[13:10]) + 4'b0001;
                      if (&(Addr[13:10]) == 1'b1)
                        begin
                          Result[17:14]    = (Addr[17:14]) + 4'b0001;
                          if (&(Addr[17:14]) == 1'b1)
                            begin
                              Result[21:18]    = (Addr[21:18]) + 4'b0001;
                              if (&(Addr[21:18]) == 1'b1)
                                Result[25:22]    = (Addr[25:22]) + 4'b0001;
                            end
                        end
                    end
                end
            end

          default :
            ;
        endcase
      end

    `HBURST_WRAP4 :
      case (Concat)
        4'b0000 :
          begin
            Result[25:2]     = Addr[25:2];
            Result[1:0]      = (Addr[1:0]) + 2'b01;
          end

        4'b0001 :
          begin
            Result[25:3]     = Addr[25:3];
            Result[2:0]      = (Addr[2:0]) + 3'b001;
          end

        4'b0010 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:0]      = (Addr[3:0]) + 4'b0001;
          end

        4'b0100 :
          begin
            Result[25:2]     = Addr[25:2];
            Result[1]        =  ~(Addr[1]);
            Result[0]        = 1'b0;
          end

        4'b0101 :
          begin
            Result[25:3]     = Addr[25:3];
            Result[2:1]      = (Addr[2:1]) + 2'b01;
            Result[0]        = 1'b0;
          end

        4'b0110 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:1]      = (Addr[3:1]) + 3'b001;
            Result[0]        = 1'b0;
          end

        4'b1000 :
          begin
            Result[25:2]     = Addr[25:2];
            Result[1:0]      = 2'b00;
          end

        4'b1001 :
          begin
            Result[25:3]     = Addr[25:3];
            Result[2]        =  ~(Addr[2]);
            Result[1:0]      = 2'b00;
          end

        4'b1010 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:2]      = (Addr[3:2]) + 2'b01;
            Result[1:0]      = 2'b00;
          end

        default :
          ;
      endcase

    `HBURST_WRAP8 :
      case (Concat)
        4'b0000 :
          begin
            Result[25:3]     = Addr[25:3];
            Result[2:0]      = (Addr[2:0]) + 3'b001;
          end

        4'b0001 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:0]      = (Addr[3:0]) + 4'b0001;
          end

        4'b0010 :
          begin
            Result[25:5]     = Addr[25:5];
            Result[4:0]      = (Addr[4:0]) + 5'b00001;
          end

        4'b0100 :
          begin
            Result[25:3]     = Addr[25:3];
            Result[2:1]      = (Addr[2:1]) + 2'b01;
            Result[0]        = 1'b0;
          end

        4'b0101 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:1]      = (Addr[3:1]) + 3'b001;
            Result[0]        = 1'b0;
          end

        4'b0110 :
          begin
            Result[25:5]     = Addr[25:5];
            Result[4:1]      = (Addr[4:1]) + 4'b0001;
            Result[0]        = 1'b0;
          end

        4'b1000 :
          begin
            Result[25:3]     = Addr[25:3];
            Result[2]        =  ~(Addr[2]);
            Result[1:0]      = 2'b00;
          end

        4'b1001 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:2]      = (Addr[3:2]) + 2'b01;
            Result[1:0]      = 2'b00;
          end

        4'b1010 :
          begin
            Result[25:5]     = Addr[25:5];
            Result[4:2]      = (Addr[4:2]) + 3'b001;
            Result[1:0]      = 2'b00;
          end

        default :
          ;
      endcase

    `HBURST_WRAP16 :
      case (Concat)
        4'b0000 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:0]      = (Addr[3:0]) + 4'b0001;
          end

        4'b0001 :
          begin
            Result[25:5]     = Addr[25:5];
            Result[4:0]      = (Addr[4:0]) + 5'b00001;
          end

        4'b0010 :
          begin
            Result[25:6]     = Addr[25:6];
            Result[5:0]      = (Addr[5:0]) + 6'b000001;
          end

        4'b0100 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:1]      = (Addr[3:1]) + 3'b001;
            Result[0]        = 1'b0;
          end

        4'b0101 :
          begin
            Result[25:5]     = Addr[25:5];
            Result[4:1]      = (Addr[4:1]) + 4'b0001;
            Result[0]        = 1'b0;
          end

        4'b0110 :
          begin
            Result[25:6]     = Addr[25:6];
            Result[5:1]      = (Addr[5:1]) + 5'b00001;
            Result[0]        = 1'b0;
          end

        4'b1000 :
          begin
            Result[25:4]     = Addr[25:4];
            Result[3:2]      = (Addr[3:2]) + 2'b01;
            Result[1:0]      = 2'b00;
          end

        4'b1001 :
          begin
            Result[25:5]     = Addr[25:5];
            Result[4:2]      = (Addr[4:2]) + 3'b001;
            Result[1:0]      = 2'b00;
          end

        4'b1010 :
          begin
            Result[25:6]     = Addr[25:6];
            Result[5:2]      = (Addr[5:2]) + 4'b0001;
            Result[1:0]      = 2'b00;
          end

        default :
          ;
      endcase

    default :
      ;
  endcase
  AddrIncr = Result;
end
endfunction

// -----------------------------------------------------------------------------
// Function to Check for memory Boundary Cross-over
// -----------------------------------------------------------------------------
function [4:0] BoundaryChk;
input [25:0] Addr;
input [4:0]  Count;
input [1:0]  BurstLen;
input [1:0]  MemWidth;
input [2:0]  Hburst;
input        SyncWrapRd;
input        SyncDev;
input [1:0]  AhbWidth;
input        BurstMode;

reg [4:0]    Temp;
reg [4:0]    Result;

begin
  Temp   = Count;
  Result = 5'b00001;
  if (BurstMode == 1'b1)
    begin
      case (BurstLen)
        `FOUR_TXR :
          begin
            Temp = 5'b00100;

            case (MemWidth)
              `MEM_BYTE :
                if (|(Addr[1:0]) == 1'b1)
                  Temp[2:0]        = 4 - {1'b0, Addr[1:0]};
  
              `MEM_HWORD :
                if (|(Addr[2:1]) == 1'b1)
                  Temp[2:0]        = 4 - {1'b0, Addr[2:1]};
  
              `MEM_WORD :
                if (|(Addr[3:2]) == 1'b1)
                  Temp[2:0]        = 4 - {1'b0, Addr[3:2]};
 
              default :
                ;
            endcase
            if ((SyncDev == 1'b1) && (Hburst != `HBURST_WRAP4) &&
                (Hburst != `HBURST_WRAP8) && (Hburst != `HBURST_WRAP16))
              Temp = 5'b00100;
          end
  
        `EIGHT_TXR :
          begin
            Temp = 5'b01000;

            case (MemWidth)
              `MEM_BYTE :
                if (|(Addr[2:0]) == 1'b1)
                  Temp[3:0]        = 8 - {1'b0, Addr[2:0]};
  
              `MEM_HWORD :
                if (|(Addr[3:1]) == 1'b1)
                  Temp[3:0]        = 8 - {1'b0, Addr[3:1]};
  
              `MEM_WORD :
                if (|(Addr[4:2]) == 1'b1)
                  Temp[3:0]        = 8 - {1'b0, Addr[4:2]};
 
              default :
                ;
            endcase

            if (SyncDev == 1'b1)
              begin
                if (SyncWrapRd == 1'b0)
                  begin
                    if ((Hburst != `HBURST_WRAP4) &&
                        (Hburst != `HBURST_WRAP8) && (Hburst != `HBURST_WRAP16))
                      Temp = 5'b01000;
                  end
                else
                  begin
                    if ((AhbWidth == 2'b10) && (Hburst == `HBURST_WRAP8))
                      Temp = 5'b01000;
                  end
              end

          end
  
        `SIXTEEN_TXR, `CONTINUOUS :
          begin
            Temp = 5'b10000;

            case (MemWidth)
              `MEM_BYTE :
                if (|(Addr[3:0]) == 1'b1)
                  Temp[4:0]        = 16 - {1'b0, Addr[3:0]};
  
              `MEM_HWORD :
                if (|(Addr[4:1]) == 1'b1)
                  Temp[4:0]        = 16 - {1'b0, Addr[4:1]};
  
              `MEM_WORD :
                if (|(Addr[5:2]) == 1'b1)
                  Temp[4:0]        = 16 - {1'b0, Addr[5:2]};
 
              default :
                ;
            endcase

            if (SyncDev == 1'b1)
              begin
                if (SyncWrapRd == 1'b0)
                  begin
                    if ((Hburst != `HBURST_WRAP4) &&
                        (Hburst != `HBURST_WRAP8) && (Hburst != `HBURST_WRAP16))
                      Temp = 5'b10000;
                  end
                else
                  begin
                    if (((AhbWidth == 2'b10) && (Hburst == `HBURST_WRAP8)) ||
                        ((AhbWidth == 2'b01) && (Hburst == `HBURST_WRAP16)))
                      Temp = 5'b10000;
                  end
              end

          end
 
        default :
          ;
      endcase
  
      if (Temp > Count)
        Result = Count;
      else
        Result = Temp;
    end
  BoundaryChk = Result;
end
endfunction

// -----------------------------------------------------------------------------
// Function to Check for memory Boundary during Synchronous Write Transfers
// -----------------------------------------------------------------------------
function [2:0] BoundChkWr;
input [1:0]  BurstLen;
input [1:0]  MemWidth;
input [3:0]  Addr;
input [2:0]  Hburst;
input        AhbWide;
input [2:0]  AhbWideCnt;

reg [2:0] Result;
begin
  Result       = 3'b011;
  if ((Hburst == `HBURST_WRAP4) || (Hburst == `HBURST_WRAP8) ||
      (Hburst == `HBURST_WRAP16))
    begin
      case (BurstLen)
        `FOUR_TXR :
          begin
            Result       = 3'b011;
            case (MemWidth)
              `MEM_BYTE :
                begin
                  if (AhbWide == 1'b1)
                    Result       = AhbWideCnt;
                  else if (|(Addr[1:0]) == 1'b1)
                    Result[1:0]  = 3 - Addr[1:0];
                end
    
              `MEM_HWORD :
                begin
                  if (AhbWide == 1'b1)
                    Result       = AhbWideCnt;
                  else if (|(Addr[2:1]) == 1'b1)
                    Result[1:0]  = 3 - Addr[2:1];
                end
    
              `MEM_WORD :
                begin
                  if (AhbWide == 1'b1)
                    Result       = AhbWideCnt;
                  else if (|(Addr[3:2]) == 1'b1)
                    Result[1:0]  = 3 - Addr[3:2];
                end
    
              default :
                ;
            endcase
          end

        `EIGHT_TXR , `CONTINUOUS :
          begin
            Result       = 3'b111;
            case (MemWidth)
              `MEM_BYTE :
                begin
                  if (AhbWide == 1'b1)
                    Result       = AhbWideCnt;
                  else
                    begin
                      if (Hburst == `HBURST_WRAP4)
                        begin
                          Result[1:0]  = 3 - Addr[1:0];
                          Result[2]    = 1'b0;
                        end
                      else
                        Result[2:0]  = 7 - Addr[2:0];
                    end
                end
    
              `MEM_HWORD :
                begin
                  if (AhbWide == 1'b1)
                    Result       = AhbWideCnt;
                  else
                    begin
                      if (Hburst == `HBURST_WRAP4)
                        begin
                          Result[1:0]  = 3 - Addr[2:1];
                          Result[2]    = 1'b0;
                        end
                      else
                        Result[2:0]  = 7 - Addr[3:1];
                    end
                end
    
              default :
                ;
            endcase
          end
  
        default :
          ;
      endcase
    end
  else
    begin
      Result       = 3'b111;
      if (AhbWide == 1'b1)
        Result     = AhbWideCnt;
      else if (BurstLen == `FOUR_TXR)
        Result     = 3'b011;
    end
  BoundChkWr = Result; 
end
endfunction

// -----------------------------------------------------------------------------
// Function to generate the condition for nSMIND assertion.
// -----------------------------------------------------------------------------
function IndAssrt;
input [6:0] Addr;
input       BMDevice;
input       IndEnbled;
input [1:0] MemWidth;

reg   [4:0] Temp;

begin
  Temp = 5'b00000;
  case (MemWidth)
    `MEM_BYTE:
      Temp = Addr[4:0];

    `MEM_HWORD:
      Temp = Addr[5:1];

    `MEM_WORD:
      Temp = Addr[6:2];

    default :
      ;
  endcase

  if ((Temp == 5'b11111) && (BMDevice == 1'b1) && (IndEnbled == 1'b1))
    IndAssrt = 1'b0;
  else
    IndAssrt = 1'b1;
end
endfunction

// -----------------------------------------------------------------------------
// Function to appropriately shift the SmAddrTSM lines before driving on
// SMADDRMC lanes.
// -----------------------------------------------------------------------------
function [25:0] ShiftAddr;
input [25:0] Addr;
input [1:0]  MemWidth;

begin
  ShiftAddr = Addr;
  case (MemWidth)
    `MEM_BYTE :
      ShiftAddr = Addr;

    `MEM_HWORD :
      ShiftAddr = {1'b0, Addr[25:1]};

    `MEM_WORD :
      ShiftAddr = {2'b00, Addr[25:2]};

    default :
      ;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// Function to appropriately assert nSMDATAENMC byte lanes
// -----------------------------------------------------------------------------
function [3:0] DataEnFunc;
input [1:0]  MemWidth;

begin
  DataEnFunc = 4'b1111;
  case (MemWidth)
    `MEM_BYTE :
      DataEnFunc = 4'b1110;

    `MEM_HWORD :
      DataEnFunc = 4'b1100;

    `MEM_WORD :
      DataEnFunc = 4'b0000;

    default :
      ;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// Function to appropriately assert SMCS lines depending on Bank number.
// -----------------------------------------------------------------------------
function [7:0] ChipSelRouteH;
input [7:0]  Hsel;

begin
  ChipSelRouteH = 8'b00000000;
  case (Hsel)
    `BANK0 :
      ChipSelRouteH = 8'b00000001;

    `BANK1 :
      ChipSelRouteH = 8'b00000010;

    `BANK2 :
      ChipSelRouteH = 8'b00000100;

    `BANK3 :
      ChipSelRouteH = 8'b00001000;

    `BANK4 :
      ChipSelRouteH = 8'b00010000;

    `BANK5 :
      ChipSelRouteH = 8'b00100000;

    `BANK6 :
      ChipSelRouteH = 8'b01000000;

    `BANK7 :
      ChipSelRouteH = 8'b10000000;

    default :
      ;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// Function to appropriately assert nSMCS lines depending on Bank number.
// -----------------------------------------------------------------------------
function [7:0] ChipSelRouteL;
input [7:0]  Hsel;

begin
  ChipSelRouteL = 8'b11111111;
  case (Hsel)
    `BANK0 :
      ChipSelRouteL = 8'b11111110;

    `BANK1 :
      ChipSelRouteL = 8'b11111101;

    `BANK2 :
      ChipSelRouteL = 8'b11111011;

    `BANK3 :
      ChipSelRouteL = 8'b11110111;

    `BANK4 :
      ChipSelRouteL = 8'b11101111;

    `BANK5 :
      ChipSelRouteL = 8'b11011111;

    `BANK6 :
      ChipSelRouteL = 8'b10111111;

    `BANK7 :
      ChipSelRouteL = 8'b01111111;

    default :
      ;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// Function to generate the condition for nSMBLS assertion.
// -----------------------------------------------------------------------------
function [3:0] ByteLaneFunc;
input [1:0]  MemWidth;
input [1:0]  Hsize;
input        SMBLSPol;
input        ValByteLane0;
input        ValByteLane1;
input        ValByteLane2;
input        ValByteLane3;

reg   [3:0] Lane_Temp;
begin
  Lane_Temp    = {MemWidth, Hsize};
  ByteLaneFunc = {4{~ SMBLSPol}};
  case (Lane_Temp)
    // Memory size is Byte, AHB Width can be Byte, HWord, or Word
    4'b0000, 4'b0001, 4'b0010 :
      ByteLaneFunc = {{3{~ SMBLSPol}}, SMBLSPol};

    // Memory size is HWord, AHB Width is Byte
    4'b0100 :
      begin
        ByteLaneFunc[3:2] = {2{~ SMBLSPol}};
        if ((ValByteLane1 == 1'b1) || (ValByteLane3 == 1'b1))
          ByteLaneFunc[1] = SMBLSPol;
        else
          ByteLaneFunc[1] = ~SMBLSPol;

        if ((ValByteLane0 == 1'b1) || (ValByteLane2 == 1'b1))
          ByteLaneFunc[0] = SMBLSPol;
        else
          ByteLaneFunc[0] = ~SMBLSPol;
      end

    // Memory size is HWord, AHB Width can be HWord, or Word
    4'b0101, 4'b0110 :
      ByteLaneFunc = {{2{~ SMBLSPol}}, SMBLSPol, SMBLSPol};

    // Memory size is Word, AHB Width is Byte and HWord
    4'b1000, 4'b1001 :
      begin
        if (ValByteLane3 == 1'b1)
          ByteLaneFunc[3] = SMBLSPol;
        else
          ByteLaneFunc[3] = ~SMBLSPol;

        if (ValByteLane2 == 1'b1)
          ByteLaneFunc[2] = SMBLSPol;
        else
          ByteLaneFunc[2] = ~SMBLSPol;

        if (ValByteLane1 == 1'b1)
          ByteLaneFunc[1] = SMBLSPol;
        else
          ByteLaneFunc[1] = ~SMBLSPol;

        if (ValByteLane0 == 1'b1)
          ByteLaneFunc[0] = SMBLSPol;
        else
          ByteLaneFunc[0] = ~SMBLSPol;
      end

    // Memory size is Word, AHB Width is Word
    4'b1010 :
      ByteLaneFunc = {4{SMBLSPol}};

    default :
      ;
  endcase
end
endfunction


// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Internal Signal Assignments
// -----------------------------------------------------------------------------
assign SmCSTSM          = iSmCSTSM;
assign SmAddrTSM        = iSmAddrTSM[1:0];
assign SMADDRMC         = iSMADDRMC;
assign nSMWENMC         = iSMWENMC;
assign WaitRdCyc        = iWaitRdCyc;
assign WaitRdCycVer     = iWaitRdCycVer;
assign WaitWrCycVer     = WaitWrCycVerAnd;
assign WaitWrCycDup     = iWaitWrCycDup;
assign WaitWrCycAhb     = iWaitWrCycAhb;
assign MWWr             = iMWWr;
assign RBLEWr           = iRBLEWr;
assign HsizeMemBufWr    = iHsizeMemBufWr;
assign HsizeEqMWidthWr  = iHsizeEqMWidthWr;
assign AhbWiderWr       = iAhbWiderWr;
assign AhbNarrowWr      = iAhbNarrowWr;
assign SMBUSREQ         = iSMBUSREQ;
assign SyncEnWriteReg   = iSyncEnWriteReg;
assign WaitEnReg        = iWaitEnReg;
assign BMWriteReg       = iBMWriteReg;
assign WriteBeatCnt     = iWriteBeatCnt;
assign WaitStatus       = ~SMWaitSync;
assign nSmBurstWaitReg  = SyncWtOnMCLK;
assign Toggle           = iToggle;
assign BurstWriteSt     = iBurstWriteSt;
assign TurnAroundSt     = iTurnAroundSt;
assign WaitTxrOnBusSt   = iWaitTxrOnBusSt;
assign WaitDeAssrtSt    = iWaitDeAssrtSt;
assign CancelWaitSt     = iCancelWaitSt;
assign ClkStpd          = iClkStpd;
assign nSMBLSMC         = iSMBLSMCn;
assign WBstIntrptd      = iWBstIntrptd;
assign TxrB4BsyAccptd   = iTxrB4BsyAccptd;
assign IndAssrtd        = IndAssrt(iSmAddrTSM[6:0], BMRead1, BIReadEn1, MW1);
assign IncrAddr         = AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1, HburstMemBuf);
assign IncrAddrWr       = AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                   HburstMemBufWr);
assign WrBtCntCpy       = BoundChkWr(BurstLenWrReg, iMWWr, iSmAddrTSM[3:0],
                                     HburstMemBufWr, iAhbWiderWr, AhbWideWrCnt);


// -----------------------------------------------------------------------------
// Signal Assignments
// -----------------------------------------------------------------------------
assign InitSt           = SmTSMState[0];
assign ReadSt           = SmTSMState[1];
assign BurstReadSt      = SmTSMState[2];
assign WriteSt          = SmTSMState[3];
assign WaitAssrtSt      = SmTSMState[8];

assign iBurstWriteSt    = SmTSMState[4];
assign iTurnAroundSt    = SmTSMState[5];
assign iWaitTxrOnBusSt  = SmTSMState[6];
assign iWaitDeAssrtSt   = SmTSMState[9];
assign iCancelWaitSt    = SmTSMState[10];

// -----------------------------------------------------------------------------
// This block generates iWaitRdCyc.
// This signal is sampled in the AHB SM to decide as to whether HREADYOUTSMC
// will be asserted next clock.
// WaitRdCycVer which is generated in the Memory SM is suitable AND'ed with
// External Wait(Both Asynchronous and Synchronous) so that HREADYOUTSMC is
// not mistakenly driven out.
// -----------------------------------------------------------------------------
always @(iWaitRdCycVer or SyncEnRead1 or SmBurstWaitReg or WaitEn or
         SMWaitSync or iWaitDeAssrtSt or SleepMode)
begin : p_MskWtRdCycComb
  iWaitRdCyc       = 1'b1;
  if ((iWaitRdCycVer == 1'b0) && (SleepMode == 1'b0))
    begin
      if (SyncEnRead1 == 1'b1)
        iWaitRdCyc       =  ~SmBurstWaitReg;
      else
        begin
          if ((WaitEn == 1'b1) && (SMWaitSync == 1'b0) &&
              (iWaitDeAssrtSt == 1'b0))
            iWaitRdCyc       = 1'b1;
          else
            iWaitRdCyc       = iWaitRdCycVer;
        end
    end
end // p_MskWtRdCycComb

// -----------------------------------------------------------------------------
// This block generates WaitWrCycVerAnd.
// This signal is sampled in the AHB SM to decide as to whether HREADYOUTSMC
// will be asserted next clock.
// WaitWrCycVer which is generated in the Memory SM is suitable anded with
// External Wait(Synchronous) so that HREADYOUTSMC is not mistakenly driven out.
// -----------------------------------------------------------------------------
always @(iBurstWriteSt or SyncWtOnMCLK or iWaitWrCycVer)
begin : p_AndedDupComb
  WaitWrCycVerAnd  = 1'b1;
  if ((iBurstWriteSt == 1'b0) || (SyncWtOnMCLK == 1'b1))
    WaitWrCycVerAnd  = iWaitWrCycVer;
end // p_AndedDupComb

// -----------------------------------------------------------------------------
// When synchronous burst write is in progress, the AHB burst is pipelined.
// Because of this pipelined nature, if memory asserts nSMBURSTWAIT while the
// AHB burst has changed to new burst then we need to slow down the write
// pipelining.
// -----------------------------------------------------------------------------
always @(iBurstWriteSt or SyncWtOnMCLK or Stop2WtWrCyc or
         NewBurst or iHsizeEqMWidthWr or UseSecBuf or iSmCSTSM
         or HsizeMemBuf1 or MW1)
begin : p_Stop2WtWrCycComb
  NextStop2WtWrCyc = Stop2WtWrCyc;
  if ((iBurstWriteSt == 1'b1) && (iSmCSTSM == 1'b0) &&
      (NewBurst == 1'b1) && (Stop2WtWrCyc == 1'b0) &&
      // added extra condition
      (HsizeMemBuf1 == MW1) &&
      (iHsizeEqMWidthWr == 1'b1) && (UseSecBuf == 1'b1))
    begin
      NextStop2WtWrCyc = 1'b1;
    end
  else if ((UseSecBuf == 1'b1) && (SyncWtOnMCLK == 1'b1))
    begin
      NextStop2WtWrCyc = 1'b0;
    end
end // p_Stop2WtWrCycComb;
  
// -----------------------------------------------------------------------------
//    M E M O R Y    I N T E R F A C E    S T A T E    M A C H I N E
// -----------------------------------------------------------------------------
//
// Summary: State Machine to control the Memory interface for Memory accesses.
//
// Overview: This state machine will control and generate all Memory related
//           signals. This SM is also responsible for driving out HREADYOUTSMC.
//
// Summary State Description:
// ==========================
//
// ST_NO_REQ       : No Memory Access State.
// Description     : Default state when Memory accesses are not requested.
// Entry           : Memory read or write request is sampled de-asserted.
// Exit            : When Memory read or write request is sampled asserted and
//                   Memory SMBUSGNT is sampled asserted.
// No change       : When SMBUSGNT is sampled de-asserted.
//
// ST_READ         : Memory Long Read State.
// Description     : Long read access in progress.
// Entry           : When Memory read(Initial read) is requested from AHB.
// Exit            : When Long Read is completed, or When Wait is asserted for
//                   Wait enabled transfers before the counter expires.
// No change       : When Long Read is in progress.
//
// ST_BURST_READ   : Memory Burst Read State.
// Description     : Burst read access in progress.
// Entry           : When Memory read(Burst Mode read) is requested from AHB.
// Exit            : When Burst Read is completed.
// No change       : When Burst Read is in progress.
//
// ST_WRITE        : Memory Write State.
// Description     : Initial write access in progress.
// Entry           : When Memory write(Initial write) is requested from AHB.
// Exit            : When Initial Write is completed and there are no further
//                   Memory Write request from AHB, or When Wait is asserted for
//                   Wait enabled transfers before the counter expires.
// No change       : When Initial Write is in progress.
//
// ST_BURST_WRITE  : Memory Burst Write State.
// Description     : Burst write access in progress.
// Entry           : When Memory write(Burst write) is requested from AHB.
// Exit            : When Burst Write is completed and there are no further
//                   Memory Write request from AHB, or When Burst boundary is
//                   reached.
// No change       : When Burst Write is in progress.
//
// ST_WAIT_TXRONBUS: Wait for the Transfer on AHB State.
// Description     : Waiting for an accesses on AHB to be completed.
// Entry           : The SM enters enter this state on following conditions,
//                   a) After finishing single memory read access from ST_READ
//                      state.
//                   b) After finishing burst memory read access from
//                      ST_BURST_READ state.
//                   c) When boundary has reached
// Exit            : When New Transfer on AHB is sampled.
// No change       : When New Transfer on AHB is in progress.
//
// ST_TURNAROUND   : Turnaround State.
// Description     : Turnaround in progress.
// Entry           : When TurnAround condition is satisfied in ST_WAIT_TXRONBUS
//                   or ST_WAIT_DEASSERTED or ST_CANCEL_WAIT State.
// Exit            : When Turnaround is completed.
// No change       : When Turnaround is in progress.
//
// ST_WAIT_ASSERTED: Wait Asserted State.
// Description     : Waiting for SMWAIT De-assertion.
// Entry           : Before the expiry of Long Burst Read count or Initial Write
//                   count, if SMWAIT is asserted for Wait enabled transfer.
// Exit            : When SMWAIT is sampled de-asserted.
// No change       : Until SMWAIT is sampled de-asserted.
//
// ST_WAIT_DEASSERTED : Wait De-asserted State.
// Description        : SMWAIT is sampled de-asserted for a Wait enabled
//                      transfer and the current transfer is completed. Waiting
//                      for a new transfer on AHB.
// Exit               : Unconditional on next active edge.
// No change          : When New Transfer on AHB is in progress.
//
// ST_CANCEL_WAIT  : Cancel Wait Asserted State.
// Description     : Waiting for SMWAIT De-assertion.
// Entry           : When SMCANCELWAIT is sampled asserted in ST_WAIT_ASSERTED
//                   state.
// Exit            : When SMWAIT is sampled de-asserted.
// No change       : Until SMWAIT is sampled de-asserted.
//
// ST_MEM_DEGRANTED: SsmcCore is Degranted State.
// Entry           : When Memory Bus is Degranted when further Memory accesses
//                   is pending.
// Exit            : When SMBUSGNT is sampled asserted.
//
// Detailed Description:
// =====================
// The SM States are described below.
// ST_NO_REQ State:
//   The SM enters this state on Reset. The SM makes a transition from this
//   state to either ST_READ or ST_WRITE depending on the Memory Read access
//   from AHB or Memory Write Access from AHB, provided SMBUSGNT is sampled
//   asserted. While making a transition to either of two states the
//   Counters (WstBrstRd, WstLongRd, WstWrCnt, WstWrEnCnt, WstOenCnt,
//   and BeatCount) are loaded. While making a transition from this state
//   SmCSTSM is asserted and SmAddrTSM are driven with the Registered value in
//   AHB Memory SM. If the WSTOEN1 is programmed as zero, then SmOEn is
//   asserted while making a state transition to ST_READ state along with
//   SmCSTSM. If the WSTWEN is programmed as zero, then nSMWENMC is asserted
//   while making a state transition to ST_WRITE state along with SmCSTSM. In
//   this state SMBUSREQ is raised.
//
// ST_READ State:
//   From this state the SM can make a transition to ST_WAIT_TXRONBUS or
//   ST_BURST_READ state. SM will make a transition to ST_BURST_READ state if
//   BM bit is set, and BeatCount is indicating more than 1 transfer.
//   The SM will make a transition to ST_WAIT_TXRONBUS if SmCSTSM is sampled
//   de-asserted. Transitions to these states are done after ensuring that the
//   WstLongRd counter had expired.
//   While making a state transition to ST_BURST_READ state the SmCSTSM is
//   continued to be asserted. After the first long read the AhbCount(indicates
//   the number of access from AHB side) and BeatCount (counter
//   indicates the number of access possible, this restriction might be for
//   memory boundary) counters are decremented when WaitRdCyc is sampled low.
//   If it is a wait enabled transfer and if the Wait is asserted before the
//   WstLongRd counter expires then state transition will happen to
//   ST_WAIT_ASSERTED state.
//
// ST_BURST_READ State:
//   In this state following conditions can happen while burst is progressing
//   Busy Insertion from Master:
//     In this case the SmAddrTSM would have been incremented, so by the time
//     the SM sees the registered BUSY signal, the SmAddrTSM would have
//     progressed ahead of HADDRSMC, the BeatCount counter would have
//     decremented.
//     Hence if HREADYOUTSMC is asserted immediately for the SEQ transfer
//     following BUSY access, there will be wrong data on the HRDATASMC lines.
//     To prevent this, in the AHB Memory SM care is taken such that immediately
//     after BUSY access if a SEQ access happens then HREADYOUTSMC is
//     de-asserted. Also, the Counters are not updated when the registered BUSY
//     is seen and SMDATAIN is not clocked into the Register.
//   Break in Burst initiated by Master:
//     When the NewBurst indication is sampled asserted in this state then
//     Turnaround is done, before honouring the new burst.
//
// ST_WRITE State:
//   The SM enters this state after asserting SmCSTSM, and drives out SmAddrTSM.
//   nSMWENMC is asserted depending on the delay value programmed in the WSTWEN
//   register. When the write is happening to Asynchronous devices the nSMWENMC
//   signal is de-asserted after every write. This signal is asserted again
//   based on further MemWrReq and delay value programmed in WSTWEN register.
//   The state transitions happen after the de-assertion of nSMWENMC signal.
//   State transition can happen to ST_BURST_WRITE state if there is further
//   MemWrReq from AHB side and BMWrite bit and SyncEnWrite is set.
//   In this state the signal WaitWrCycVer will decide as to when the
//   HREADYOUTSMC has to be driven high for the current Write access.
//   In this state if MemRdReq is sampled asserted after the current write
//   access then the SM will make a state transition to ST_READ state.
//   In this state if there are no further Memory access requests then the
//   state transition happens to ST_NO_REQ state.
//   If it is a wait enabled transfer and if the Wait is asserted before the
//   WstWrCnt counter expires then state transition will happen to
//   ST_WAIT_ASSERTED state.
//   If there are further Memory accesses and Memory Bus is degranted then SM
//   will make a transition to ST_MEM_DEGRANTED State.
//
// ST_BURST_WRITE State:
//   The SM enters this state if a burst write has to be performed for
//   Synchronous Burst devices. In this state the HREADYOUTSMC is driven high
//   on every clock when WaitWrCycVer is de-asserted. This is possible until
//   there SmBurstWaitReg signal is not sampled high. When SmBurstWaitReg
//   is asserted then WaitWrCycVer is asserted and HREADYOUTSMC is driven low.
//   When a NewBurst signal is encountered then state transition can happen to
//   ST_WRITE state or ST_READ state depending on whether it is a MemRdReq or
//   MemWrReq. If no Memory access is requested then state transition will
//   happen to ST_NO_REQ state.
//
// ST_WAIT_TXRONBUS State:
//   The SM enters enter this state on following conditions,
//   a) After finishing single memory read access from ST_READ state.
//   b) After finishing burst memory read access from ST_BURST_READ state.
//   d) When boundary has reached (BeatCount expiring) then
//      remaining read access if any has to be performed.
//   This state was added so that after the current read access the pipelined
//   access is registered by the AHB Memory SM, is sampled in this state, and
//   based on the turnaround information SM can make a state transition to
//   either ST_READ, ST_WRITE or ST_TURNAROUND states.
//   If there are further Memory accesses and Memory Bus is degranted then SM
//   will make a transition to ST_MEM_DEGRANTED State.
//   If no Memory access is requested then state transition will happen to
//   ST_NO_REQ state.
//
// ST_TURNAROUND State:
//   Turnaround is done on following conditions,
//   a) Read followed by Write to same Bank.
//   b) Read followed by Write to different Bank.
//   c) Read followed by Read to different Bank.
//   d) After Single Read and if IDCYC values are programmed (before
//      de-asserting SMBUSREQ, as there is no further memory accesses).
//   e) After Single Burst Read and if IDCYC values are programmed (before
//      de-asserting SMBUSREQ, as there is no further memory accesses).
//   f) When TimeOutErr has occurred for Read access and if IDCYC values are
//      programmed.
//   g) When WaitEnabled transfer has completed successfully for Read access
//      and if IDCYC values are programmed (before de-asserting SMBUSREQ, as
//      there is no further memory accesses).
//   From this State, transition will happen to ST_READ state if MemRdReq is
//   sampled asserted. State transition will happen to ST_WRITE state if
//   MemWrReq is sampled asserted, else state transition will happen to
//   ST_NO_REQ state.
//   If there are further Memory accesses and Memory Bus is degranted then SM
//   will make a transition to ST_MEM_DEGRANTED State.
//
// ST_WAIT_ASSERTED State:
//   SM enters this state in case of wait enabled transfers and if the SMWAIT
//   is sampled asserted before WSTRD1 counter expires in case of Read transfer
//   and WSTWR counter in case of Write transfer. Once the SMWAIT is asserted
//   then SM will wait in this state till SMWAIT is de-asserted. When SMWAIT is
//   sampled de-asserted, SM makes a transition to ST_WAIT_DEASSERTED state. In
//   this state if CANCELSMWAIT is sampled asserted, state transition will
//   happen to ST_CANCEL_WAIT state.
//
// ST_WAIT_DEASSERTED State:
//   From this state transition will happen to ST_TURNAROUND state if there was
//   no further read request pending, the current waited transfer was read and
//   IDCYC value was programmed for non-zero value. SM will make a state
//   transition to ST_READ state if there is pending read request. SM will make
//   a state transition to ST_WRITE state if there is pending write request.
//
// ST_CANCEL_WAIT State:
//   From this state SM transition will happen to ST_TURNAROUND state if there
//   was TimeOutErr for Read access and IDCYC register was programmed with a
//   non-zero value, else SM will make a state transition to ST_NO_REQ state.
//
// ST_MEM_DEGRANTED State:
//   From this state State transition will happen to either ST_READ or ST_WRITE
//   depending on MemRdReq or MemWrReq.

// The DBI uses the SMBUSGNT line to indicate when there is a successful grant
// of the Bus to the SSMC.
// -----------------------------------------------------------------------------
always @(/*AUTOSENSE*/AddrBuf or AddrBuf1 or AddrNotAligned
         or AddrValWrEnReg or AddrValidReadEn1 or AddrValidWriteEn
         or AhbCount or AhbNarrow or AhbWideRdCnt or AhbWideRdReg
         or AhbWideWrCnt or AhbWider or BIReadEn1 or BIWriteEn
         or BIWriteEnReg or BMRead1 or BMWrite or BUSYCYC or BeatCount
         or BurstLenRead1 or BurstLenWrReg or BurstLenWrite
         or ClockRatio or ContWithBrst or DelAhbWideWrCnt
         or DelSMWENMC or DelSmBurstWait or DelUseSecBuf
         or DelWaitWrCycVer or FirstSyncWt or HburstMemBuf
         or HburstMemBufWr or HselMemBuf or HselMemBuf1
         or HselMemBufWr or HsizeEqMWidth or HsizeMemBuf
         or HsizeMemBuf1 or HtranRegCont or HtransMemBuf1 or IDCYC
         or IDCYRead or IDLECYC or IdcyCount or IncrAddr or IncrAddrWr
         or IndAssrtd or MW or MW1 or MemRdReq or MemWrReq
         or NewBrstOccrd or NewBurst or NextValByteLane0
         or NextValByteLane1 or NextValByteLane2 or NextValByteLane3
         or RBLE or SMBLSPol or SMBLSPolWr or SMBUSGNT or SMClockEn
         or SMWaitSync or SleepMode or SmBurstWaitReg
         or SmCancelWaitSync or SmTSMState or StopBurst or SyncEnRead1
         or SyncEnWrite or SyncWtOnMCLK or TurnAround
         or iTxrB4BsyAccptd or UseSecBuf or WRITECYC or WSTBRD1
         or WSTOEN1 or WSTRD1 or WSTWEN or WSTWENReg or WSTWR
         or WSTWRReg or WaitEn or WaitWrCycVerAnd or WrBtCntCpy
         or WrapRead or WriteProg or WstBrstRdCnt or WstLongRdCnt
         or WstOEnCnt or WstWrCnt or WstWrEnCnt or XtraTxr
         or iAhbNarrowWr
         or iAhbWiderWr or iAsynAxs or iBMWriteReg or iClkStpd
         or iHsizeEqMWidthWr or iHsizeMemBufWr or iMWWr or iRBLEWr
         or iSMADDRMC or iSMADDRVALIDMC or iSMBAAMC or iSMBLSMCn
         or iSMBUSREQ or iSMCSMC or iSMCSMCn or iSMDATAENMCn
         or iSMWENMC or iSmAddrTSM or iSmCSTSM or iSmOEnMC
         or iSyncEnWriteReg or iToggle or iWBstIntrptd or iWaitEnReg
         or iWaitRdCyc or iWaitRdCycVer or iWaitWrCycAhb
         or iWaitWrCycDup or iWaitWrCycVer or iWriteBeatCnt)
begin : p_MemTSMComb
  Temp_Concat      = {2'b00, AhbWideRdCnt};
  // Default Assignments
  NextSmTSMState     = SmTSMState;
  NextSmCSTSM        = iSmCSTSM;
  NextSmOEn          = iSmOEnMC;
  NextSmWrEn         = iSMWENMC;
  NextWaitRdCycVer   = iWaitRdCycVer;
  NextWaitWrCycVer   = iWaitWrCycVer;
  NextSMBUSREQ       = iSMBUSREQ;
  NextWaitWrCycDup   = iWaitWrCycDup;
  NextWaitWrCycAhb   = iWaitWrCycAhb;
  NextSmAddrTSM      = iSmAddrTSM;
  NextSMADDRMC       = iSMADDRMC;
  NextWstOEnCnt      = WstOEnCnt;
  NextWstLongRdCnt   = WstLongRdCnt;
  NextWstBrstRdCnt   = WstBrstRdCnt;
  NextWstWrCnt       = WstWrCnt;
  NextWstWrEnCnt     = WstWrEnCnt;
  NxtSMADDRVALIDMC   = iSMADDRVALIDMC;
  NextSMBAAMC        = iSMBAAMC;
  NextBeatCount      = BeatCount;
  NextIDCYRead       = IDCYRead;
  NextIdcyCount      = IdcyCount;
  NextWriteBeatCnt   = iWriteBeatCnt;
  NextToggle         = iToggle;
  NextHselMemBufWr   = HselMemBufWr;
  NextHburstMemBufWr = HburstMemBufWr;
  NextMWWr           = iMWWr;
  NextSMBLSPolWr     = SMBLSPolWr;
  NxtHsizeMemBufWr   = iHsizeMemBufWr;
  NextHsizeEqMW      = iHsizeEqMWidthWr;
  NextAhbWiderWr     = iAhbWiderWr;
  NextAhbNarrowWr    = iAhbNarrowWr;
  NextRBLEWr         = iRBLEWr;
  NextWaitEnReg      = iWaitEnReg;
  NextSyncEnWr       = iSyncEnWriteReg;
  NextBMWriteReg     = iBMWriteReg;
  NextBIWriteEnReg   = BIWriteEnReg;
  NextBurstLenWr     = BurstLenWrReg;
  NextAddrValWrReg   = AddrValWrEnReg;
  NextWSTWRReg       = WSTWRReg;
  NextWSTWENReg      = WSTWENReg;
  NextWriteProg      = WriteProg;
  NextAhbWideRdReg   = AhbWideRdReg;
  NextStopBurst      = StopBurst;
  NextClkStpd        = iClkStpd;
  NextNewBrstOccrd   = NewBrstOccrd;
  NextSMCSMC         = iSMCSMC;
  NextSMCSMCn        = iSMCSMCn;
  NextSMDATAENMCn    = iSMDATAENMCn;
  NextSMBLSMCn       = iSMBLSMCn;
  NextAsynAxs        = iAsynAxs;
  NextWBstIntrptd    = iWBstIntrptd;
  NextFirstSyncWt    = FirstSyncWt;
  NextXtraTxr        = XtraTxr;
  NextTxrB4BsyAccptd = iTxrB4BsyAccptd;

  case (SmTSMState)
    `ST_NO_REQ :
      begin
        if (SMBUSGNT == 1'b1)
          begin
            // Make a state transition only when SMBUSGNT and MemWrReq is
            //  sampled high. Higher priority is given to Write.
            if (MemWrReq == 1'b1)
              begin
                NextHselMemBufWr   = HselMemBuf;
                NextHburstMemBufWr = HburstMemBuf;
                NextSMBLSPolWr     = SMBLSPol;
                NextMWWr           = MW;
                NxtHsizeMemBufWr   = HsizeMemBuf;
                NextHsizeEqMW      = HsizeEqMWidth;
                NextAhbWiderWr     = AhbWider;
                NextAhbNarrowWr    = AhbNarrow;
                NextRBLEWr         = RBLE;
                NextWaitEnReg      = WaitEn;
                NextSyncEnWr       = SyncEnWrite;
                NextBMWriteReg     = BMWrite;
                NextBIWriteEnReg   = BIWriteEn;
                NextBurstLenWr     = BurstLenWrite;
                NextAddrValWrReg   = AddrValidWriteEn;
                NextWSTWRReg       = WSTWR;
                NextWSTWENReg      = WSTWEN;
                NextSmCSTSM        = 1'b0;
                NextSMCSMC         = ChipSelRouteH(HselMemBuf);
                NextSMCSMCn        = ChipSelRouteL(HselMemBuf);
                NextSMDATAENMCn    = DataEnFunc(MW);
                NextSmTSMState     = `ST_WRITE;
                NextWstWrCnt       = WSTWR;

                // Assertion of WaitWrCycAhb signal for Synchronous Write 
                // transfers.
                if ((WSTWR == 5'b00000) && (SyncEnWrite == 1'b1) &&
                    (AddrNotAligned == 1'b0) && (BMWrite == 1'b1) &&
                    (HsizeEqMWidth == 1'b1))
                  NextWaitWrCycAhb = 1'b0;
                else
                  NextWaitWrCycAhb = 1'b1;

                // logic to assert nSMBLSMC
                if ((RBLE == 1'b1) || (SyncEnWrite == 1'b1) ||
                    ((WSTWEN == 4'b0000) || (WaitEn == 1'b1)))
                  NextSMBLSMCn = ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                              NextValByteLane0,
                                              NextValByteLane1,
                                              NextValByteLane2,
                                              NextValByteLane3);

                // Start asserting SmWrEn if it is wait enabled transfer or
                // if the WSTWEN counter is programmed as zero.
                if ((WSTWEN == 4'b0000) || (WaitEn == 1'b1))
                  begin
                    NextSmWrEn       = 1'b0;
                    NextWstWrEnCnt   = 4'b0000;
                  end
                else
                  // The count is decremented and loaded so that in ST_WRITE
                  // state the implementation becomes uniform where it waits for
                  // this count to decrement to 0, when re-assertion of SMWENMC
                  // is required.
                  NextWstWrEnCnt   = (WSTWEN) - 4'b0001;

                NextSmAddrTSM = AddrBuf;
                NextSMADDRMC  = ShiftAddr(AddrBuf, MW);

                // If Synchronous memories are attempting to do an Asynchronous
                // transfers then assert SMADDRVALIDMC along with SmCS.
                if (AddrValidWriteEn == 1'b1)
                  NxtSMADDRVALIDMC  = 1'b0;
                else
                  NxtSMADDRVALIDMC  = 1'b1;

                // Prevent clock stopping if Synchronous memory access is
                // required
                if ((SMClockEn == 1'b0) && (SyncEnWrite == 1'b0))
                  NextClkStpd = 1'b1;
                else
                  NextClkStpd = 1'b0;  

                // Control signal used in Pad Interface to distinguish Async and
                // Sync Access.
                NextAsynAxs = ~SyncEnWrite;

              end

            // Make a state transition only when SMBUSGNT and MemRdReq is
            // sampled high.
            else if (MemRdReq == 1'b1)
              begin
                NextSmCSTSM      = 1'b0;
                NextSMCSMC       = ChipSelRouteH(HselMemBuf1);
                NextSMCSMCn      = ChipSelRouteL(HselMemBuf1);
                NextSMDATAENMCn  = 4'b1111;
                NextSmTSMState   = `ST_READ;
                NextWstBrstRdCnt = WSTBRD1;
                NextSmAddrTSM    = AddrBuf1;
                NextSMADDRMC     = ShiftAddr(AddrBuf1, MW1);
                NextIDCYRead     = IDCYC;
                NextBeatCount    = BoundaryChk(AddrBuf1[5:0], AhbCount,
                                               BurstLenRead1, MW1, HburstMemBuf,
                                               WrapRead, SyncEnRead1,
                                               HsizeMemBuf1, BMRead1);
  
                // Start asserting SmOEn if it is wait enabled transfer or if
                // the WSTOEN1 counter is programmed as zero.
                if ((WSTOEN1 == 4'b0000) || (WaitEn == 1'b1))
                  NextSmOEn     = 1'b0;
                else
                  NextWstOEnCnt = WSTOEN1;

                // logic to assert nSMBLSMC
                if ((RBLE == 1'b1) && (MW1 != `MEM_BYTE))
                  NextSMBLSMCn = {4{SMBLSPol}};
                else
                  NextSMBLSMCn = 4'b1111;

                // Start asserting WaitRdCyc if WSTRD1 counter is programmed as
                // zero, in case of Asynchronous memories. Otherwise load the
                // Long Read counter. This distinction is done because 
                // Asynchronous Memory accesses has to be By-passed.
                if ((WSTRD1 == 5'b00000) && (SyncEnRead1 == 1'b0))
                  begin
                    NextWaitRdCycVer = 1'b0;
                    NextWstLongRdCnt = 5'b00000;
                  end
                else
                  NextWstLongRdCnt = WSTRD1;

                // If Synchronous memories are attempting to do an Asynchronous
                // transfers then assert SMADDRVALIDMC along with SmCS.
                if (AddrValidReadEn1 == 1'b1)
                  NxtSMADDRVALIDMC  = 1'b0;
                else
                  NxtSMADDRVALIDMC  = 1'b1;

                // Control signal used in Pad Interface to distinguish Async and
                // Sync Access.
                NextAsynAxs = ~SyncEnRead1;

                // Prevent clock stopping if Synchronous memory access is
                // required
                if ((SMClockEn == 1'b0) && (SyncEnRead1 == 1'b0))
                  NextClkStpd = 1'b1;
                else
                  NextClkStpd = 1'b0;  
              end
          end

         // Assert SMBUSREQ the moment request is sampled high for Memory access
         NextSMBUSREQ = MemWrReq | MemRdReq;

      end

    `ST_READ :
      begin
        // Decrement the BeatCount counter only when WaitRdCyc = 0
        // condition is satisfied.
        if (iWaitRdCyc == 1'b0)
          begin
            if (((HtranRegCont == `HTRANS_NSEQ) ||
                 (HtranRegCont == `HTRANS_IDLE)) && (HsizeEqMWidth == 1'b1))
              begin
                NextBeatCount = 5'b00000;
              end
            else if (BeatCount != 5'b00000)
              begin
                NextBeatCount = BeatCount - 5'b00001;
              end
          end

        if (NewBurst == 1'b1)
          NextNewBrstOccrd = 1'b1;

        // Make the State Transition after CS is de-asserted in normal case.
        if (iSmCSTSM == 1'b1)
          begin
            NextSmTSMState   = `ST_WAIT_TXRONBUS;
            NextWaitRdCycVer = 1'b1;
            NextAhbWideRdReg = AhbWideRdCnt;
            NextToggle       = 1'b1;
          end

        // If Synchronous memories are attempting to do Read transfers then
        // de-assert SMADDRVALIDMC so that it appears as pulse.
        if ((AddrValidReadEn1 == 1'b1) && (iSMADDRVALIDMC == 1'b0) &&
            (SyncEnRead1 == 1'b1))
          NxtSMADDRVALIDMC  = 1'b1;

        // If SmOEn is not asserted, and if the WstOEnCnt counter has not
        // down-counted to 1 then continue to de-assert SmOEn. When this counter
        // decrements to 1, flush the counter.
        if ((iSmOEnMC == 1'b1) && (WstOEnCnt == 4'b0001) && (iSmCSTSM == 1'b0))
          begin
            NextSmOEn     = 1'b0;
            NextWstOEnCnt = 4'b0000;
          end
        else if (iSmOEnMC == 1'b1)
          NextWstOEnCnt   = WstOEnCnt - 4'b0001;

        // (iSmCSTSM = '0') condition is included so that when there is a single
        // read, we will be in this state till iSmCSTSM is de-asserted, so the
        // SM should execute this block only when iSmCSTSM is asserted.
        // (iSMADDRVALIDMC = '1') or (SyncEnRead1 = '0') condition ensures for
        // Synchronous memories it has to wait till SMADDRVALIDMC is de-asserted
        if ((WstLongRdCnt == 5'b00000) && (iSmCSTSM == 1'b0) && 
            ((iSMADDRVALIDMC == 1'b1) || (SyncEnRead1 == 1'b0)))
          begin

            // Even if the Long read counter expired and if wait is asserted we
            // should not assume that the read is over. we have to wait till the
            // wait is de-asserted or cancelwait is asserted. Waited transfer
            // has highest priority then normal transfer.
            if ((WaitEn == 1'b1) && (SMWaitSync == 1'b0))
              begin
                NextSmTSMState   = `ST_WAIT_ASSERTED;
                NextAhbWideRdReg = AhbWideRdCnt;
                NextSmOEn        = 1'b0;
                NextWaitRdCycVer = 1'b1;
                NextSMBAAMC      = 1'b1;
              end

            // Since it is a wait enabled transfer do not do any burst transfers
            else if (WaitEn == 1'b1)
              begin
                NextSmCSTSM      = 1'b1;
                NextSMCSMC       = 8'b00000000;
                NextSMCSMCn      = 8'b11111111;
                NextSMDATAENMCn  = 4'b1111;
                NextSMBLSMCn     = 4'b1111;
                NextSMBAAMC      = 1'b1;
                NextSmOEn        = 1'b1;
                NxtSMADDRVALIDMC = 1'b1;
                NextWaitRdCycVer = 1'b1;
              end

            // Burst got broken, or it was a single transfer or degranted            
            else if (((((HtranRegCont == `HTRANS_NSEQ) || 
                     (HtranRegCont == `HTRANS_IDLE)) &&
                     (HsizeEqMWidth == 1'b1)) || (BMRead1 == 1'b0) ||
                     (IndAssrtd == 1'b0) || (BeatCount == 5'b00001)) &&
                     (iWaitRdCyc == 1'b0) &&
                     (  // prevent TSM hanging when SmBurstWait low during 
                        // an async read
                      (SmBurstWaitReg == 1'b1) ||
                      (BMRead1 == 1'b0)        || 
                      (SyncEnRead1 == 1'b0)
                      ))
              begin
                NextSmCSTSM      = 1'b1;
                NextSMCSMC       = 8'b00000000;
                NextSMCSMCn      = 8'b11111111;
                NextSMDATAENMCn  = 4'b1111;
                NextSMBLSMCn     = 4'b1111;
                NextSMBAAMC      = 1'b1;
                NextSmOEn        = 1'b1;
                NxtSMADDRVALIDMC = 1'b1;
                NextWaitRdCycVer = 1'b1;
              end

            // Burst Request, Grant is sampled asserted, continue with
            // Burst transfers when more than one Memory accesses needs
            // to be performed.
            else if ((BMRead1 == 1'b1) && (IndAssrtd == 1'b1) &&
                     (BeatCount != 5'b00001))
              begin
                NextSmTSMState   = `ST_BURST_READ;
                if (SyncEnRead1 == 1'b0)
                  begin
                    NextSmAddrTSM = AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                             HburstMemBuf);
                    NextSMADDRMC  = ShiftAddr(IncrAddr, MW1);
                  end
                // For Asynchronous Memories De-Assert WaitRdCycVer when 
                // WstBrstRdCnt is 0. Otherwise Assert WaitRdCycVer for
                // Asynchronous Memories.
                // For Synchronous memories De-Assert WaitRdCycVer while
                // making a State transition.
                if (SyncEnRead1 == 1'b0)
                  begin
                    if (WstBrstRdCnt == 5'b00000)
                      NextWaitRdCycVer = 1'b0;
                    else
                      NextWaitRdCycVer = 1'b1;
                  end
                else
                  begin
                    NextWaitRdCycVer = 1'b0;
                    NextWstBrstRdCnt = 5'b00000;
                  end
              end
            else
              NextWaitRdCycVer = 1'b0;
          end
        else
          begin
            // Then decrement the WstLongRdCnt value and De-Assert WaitRdCyc
            // when Count is 1. If it is Synchronous burst read then wait for
            // SMADDRVALIDMC to be de-asserted.
            if (((SyncEnRead1 == 1'b0) || (iSMADDRVALIDMC == 1'b1)) &&
                (WstLongRdCnt != 5'b00000))
              NextWstLongRdCnt = WstLongRdCnt - 5'b00001;

            // Start asserting SMBAAMC when there is a Synchronous access and
            // BMRead1 is enabled. This will be de-asserted along with nSMCS.
            if ((SyncEnRead1 == 1'b1) && (BMRead1 == 1'b1) &&
                (WstLongRdCnt[4:1] == 4'b0000) && (iSmCSTSM == 1'b0) &&
                (BeatCount[4:1] != 4'b0000) && (BIReadEn1 == 1'b1))
              NextSMBAAMC = 1'b0;

            // De-Assert WaitRdCyc when WstLongRdCnt Count is 1 for
            // Asynchronous Memory.
            if ((WstLongRdCnt == 5'b00001) && (SyncEnRead1 == 1'b0))
              NextWaitRdCycVer = 1'b0;
            else
              NextWaitRdCycVer = 1'b1;

            // If Wait Enabled Transfer is there then make a state transition
            // to ST_WAIT_ASSERTED state.
            if ((WaitEn == 1'b1) && (SMWaitSync == 1'b0) && (iSmCSTSM == 1'b0))
              begin
                NextSmTSMState   = `ST_WAIT_ASSERTED;
                NextAhbWideRdReg = AhbWideRdCnt;
                NextSmOEn        = 1'b0;
                NextWaitRdCycVer = 1'b1;
              end
          end
      end

    `ST_BURST_READ :
      begin

        // Decrement BeatCount counter when there is no Busy
        // sampled. If a Busy transfer is driven and Memory accesses is finished
        // for this read accesses then enter into a sleep mode where all control
        // signals are freezed till the AHB comes up with SEQ transfer for the
        // Busy transfer driven. If NSEQ is driven from BUSY transfer then the
        // Counters needs to be flushed. This is done in state transition logic.
        if ((SleepMode == 1'b0) && (iWaitRdCyc == 1'b0))
          begin
            if (((((HtranRegCont == `HTRANS_NSEQ) ||
                   (HtranRegCont == `HTRANS_IDLE)) ||
                  ((SyncEnRead1 == 1'b1) && (HtranRegCont == `HTRANS_BUSY))) &&
                 (HsizeEqMWidth == 1'b1)) ||
                 (NewBurst == 1'b1) || (HtransMemBuf1 == `HTRANS_IDLE) ||
                 ((SleepMode == 1'b1) && (SyncEnRead1 == 1'b1)))
              begin
                NextBeatCount = 5'b00000;
              end
            else if (BeatCount != 5'b00000)
              begin
                NextBeatCount = BeatCount - 5'b00001;
              end
          end // if ((SleepMode == 1'b0) && (iWaitRdCyc == 1'b0))
  
        if ((NewBurst == 1'b1) || ((SleepMode == 1'b1) &&
            (SyncEnRead1 == 1'b1)))
          NextNewBrstOccrd = 1'b1;

        // Make the State Transition after CS is de-asserted in normal case
        if (iSmCSTSM == 1'b1)
          begin
            NextSmTSMState   = `ST_WAIT_TXRONBUS;
            NextWaitRdCycVer = 1'b1;
            NextAhbWideRdReg = AhbWideRdCnt;
            NextToggle       = 1'b1;
          end
  
        // (iSmCSTSM = '0') condition is included so that when there is a 
        // single read, we will be in this state till iSmCSTSM is
        // de-asserted, so the SM should execute this block only when
        // iSmCSTSM is asserted.
        if (((WstBrstRdCnt == 5'b00000) ||
             ((NewBurst | NewBrstOccrd) == 1'b1)) &&
            (iSmCSTSM == 1'b0))
          begin

            // Burst got broken, or the transfer got completed
            if (((((((HtranRegCont == `HTRANS_NSEQ) ||
                     (HtranRegCont == `HTRANS_IDLE)) ||
                    ((SyncEnRead1 == 1'b1) &&
                                            (HtranRegCont == `HTRANS_BUSY))) && 
                   (HsizeEqMWidth == 1'b1)) ||
                  (IndAssrtd == 1'b0) || (NewBurst == 1'b1) ||
                  (NewBrstOccrd == 1'b1) ||
                  (HtransMemBuf1 == `HTRANS_IDLE) || (IDLECYC == 1'b1) ||
                  ((BeatCount == 5'b00001) && (SleepMode == 1'b0))) &&
                 (SmBurstWaitReg == 1'b1)) ||
                ((SleepMode == 1'b1) && (SyncEnRead1 == 1'b1)))
              begin
                NextSmCSTSM      = 1'b1;
                NextSMCSMC       = 8'b00000000;
                NextSMCSMCn      = 8'b11111111;
                NextSMDATAENMCn  = 4'b1111;
                NextSMBLSMCn     = 4'b1111;
                NextSMBAAMC      = 1'b1;
                NextSmOEn        = 1'b1;
                NxtSMADDRVALIDMC = 1'b1;
                NextWaitRdCycVer = 1'b1;
              end

            // Grant is sampled asserted, continue with Burst transfers
            else if (SleepMode == 1'b0)
              begin
                // (SmBurstWaitReg = '1') condition ensures that for
                // Synchronous memories until nSMBURSTWAIT is high it will
                // not increment the address, for Asynchronous memory
                // condition (SyncEnRead1 = '0') is sufficient to carry out
                // the increment
                if ((SmBurstWaitReg == 1'b1) || (SyncEnRead1 == 1'b0))
                  begin
                    NextSmAddrTSM = AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                             HburstMemBuf);
                    if (SyncEnRead1 == 1'b0)
                      NextSMADDRMC = ShiftAddr(IncrAddr, MW1);
                  end
  
                // Assert WaitRdCyc if WSTBRD1 = "00000" and it is an 
                // Asynchronous Memories. For Synchronous Memories it can
                // be asserted without comparison with WSTBRD1 because,
                // WSTBRD1 has no meaning for Synchronous Memories.
                if ((SyncEnRead1 == 1'b0) && (WSTBRD1 != 5'b00000))
                  NextWaitRdCycVer = 1'b1;
                else
                  //NextWaitRdCycVer = 1'b0;
                  NextWaitRdCycVer = (NewBurst | NewBrstOccrd);
  
                if (SyncEnRead1 == 1'b0)
                  NextWstBrstRdCnt = WSTBRD1; // Reload the Counter;
              end
            else if ((BUSYCYC == 1'b0) && (HsizeEqMWidth == 1'b1))
              NextWaitRdCycVer = 1'b1;
          end
        else
          begin
            // Decrement the WstBrstRdCnt value if WstBrstRdCnt /= "00000"
            // condition and BUSY insertion conditions are taken into
            // consideration.
            if (WstBrstRdCnt != 5'b00000)
              begin
                if ((WstBrstRdCnt > 5'b00001) ||
                    ((WstBrstRdCnt == 5'b00001) && (SleepMode == 1'b0)))
                  NextWstBrstRdCnt = WstBrstRdCnt - 5'b00001;
              end
 
            // De-Assert WaitRdCyc when WstBrstRdCnt Count is 1 for Asynch
            // Memory. SleepMode = '0' condition ensures that WaitRdCycVer
            // is not De-asserted when BUSY is progressing.
            if ((WstBrstRdCnt == 5'b00001) && (SyncEnRead1 == 1'b0) &&
                (SleepMode == 1'b0) && ((NewBurst | NewBrstOccrd) == 1'b0) &&
                (iSmCSTSM == 1'b0))
              NextWaitRdCycVer = 1'b0;
            else
              NextWaitRdCycVer = 1'b1;
          end
      end

    `ST_WAIT_TXRONBUS :
      begin

        // The SM enters this state on following conditions.
        // a) After single request is serviced from ST_READ state, so that 
        // decision can be taken as to move to TurnAround(IDYC value /=0) or
        // Idle State.
        // b) After Burst Request has been completed from ST_BURST_READ state,
        // so that decision can be taken as to move to TurnAround
        // (IDYC value /=0) or Idle State.
        // c) When Burst was broken in the middle of the Burst, from
        // ST_BURST_READ state, or ST_READ state so that decision can be taken
        // as to move to TurnAround(IDYC value /=0) or Idle state.
        // d) When Degranted happened in the middle of the Burst mode devices
        // burst from ST_BURST_READ state, so that decision can be taken as to
        // move to TurnAround(IDYC value /=0) or Degranted state.
        //
        // The IDCYC values to be used that of previous completed read transfer.
    

        // TurnAround is required if Previous State was Read and Current
        // Transfer is Write(With IDCYread value programmed), or Read to a
        // different Memory
        // Bank(With IDCYRead value programmed) or Grant is not there and IDCY
        // value programmed or there was a break in burst or single read and we
        // have to do TurnAround if IDCYRead is programmed before giving up the
        // Memory Bus.
          NextNewBrstOccrd = 1'b0;
          if (NewBurst == 1'b1)
            NextAhbWideRdReg = 3'b000;
          if (((TurnAround == 1'b1) && (IDCYRead != 4'b0000)) || 
              ((IDCYRead != 4'b0000) && (MemRdReq == 1'b0)))
            begin
              NextSmTSMState   = `ST_TURNAROUND;
              NextIdcyCount    = IDCYRead;
              NextWaitRdCycVer = 1'b1;
            end

          // If Grant is not there and Turnaround is not required,
          // then move to Degranted state if any further Memory Accesses
          // is requested.
          else if ((SMBUSGNT == 1'b0) && ((MemRdReq == 1'b1) ||
                   (MemWrReq == 1'b1)))
            begin
              NextSmTSMState   = `ST_MEM_DEGRANTED;
              NextSMBUSREQ     = 1'b0;
              NextWaitRdCycVer = 1'b1;
            end
  
          // If SMBUSGNT is sampled asserted and there are pending Read
          // transfers to be performed(bcoz of break in burst) or NewBurst
          // has been sampled then SM makes a transition to ST_READ state by
          // loading the counters.
          else if ((MemRdReq == 1'b1) && (MemWrReq == 1'b0))
            begin
              NextSmCSTSM      = 1'b0;
              NextSMCSMC       = ChipSelRouteH(HselMemBuf1);
              NextSMCSMCn      = ChipSelRouteL(HselMemBuf1);
              NextSMDATAENMCn  = 4'b1111;
              NextSmTSMState   = `ST_READ;
              NextWstBrstRdCnt = WSTBRD1;
              // It is added here because there is a possibility of this being
              // corrupted, while running freq runs.
              NextIDCYRead     = IDCYC;
              if ((AhbWideRdCnt != 3'b000) && (AhbWider == 1'b1) &&
                  (NewBurst == 1'b0) && (NewBrstOccrd == 1'b0))
                begin
                  NextSmAddrTSM = AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                              HburstMemBuf);
                  NextSMADDRMC  = ShiftAddr(IncrAddr, MW1);
                  NextBeatCount = BoundaryChk(IncrAddr[5:0], AhbCount,
                                                 BurstLenRead1, MW1,
                                                 HburstMemBuf, WrapRead,
                                                 SyncEnRead1, HsizeMemBuf1,
                                                 BMRead1);
                end
              else
                begin
                  NextSmAddrTSM = AddrBuf1;
                  NextSMADDRMC  = ShiftAddr(AddrBuf1, MW1);
                  NextBeatCount = BoundaryChk(AddrBuf1[5:0], AhbCount,
                                                 BurstLenRead1, MW1,
                                                 HburstMemBuf, WrapRead,
                                                 SyncEnRead1, HsizeMemBuf1,
                                                 BMRead1);
                end
  
              // Start asserting SmOEn if it is wait enabled transfer or if
              // the WSTOEN1 counter is programmed as zero.
              if ((WSTOEN1 == 4'b0000) || (WaitEn == 1'b1))
                NextSmOEn     = 1'b0;
              else
                NextWstOEnCnt = WSTOEN1;
 
              // logic to assert nSMBLSMC
              if ((RBLE == 1'b1) && (MW1 != `MEM_BYTE))
                NextSMBLSMCn = {4{SMBLSPol}};
              else
                NextSMBLSMCn = 4'b1111; 

              // Start asserting WaitRdCyc if WSTRD1 counter is programmed as
              // zero, in case of Asynchronous memories. Otherwise load the
              // Long Read counter. This distinction is done because
              // Asynchronous Memory accesses has to be By-passed.
              if ((WSTRD1 == 5'b00000) && (SyncEnRead1 == 1'b0))
                begin
                  NextWaitRdCycVer = 1'b0;
                  NextWstLongRdCnt = 5'b00000;
                end
              else
                NextWstLongRdCnt = WSTRD1;
  
              // If Synchronous memories are attempting to do an Asynchronous
              // transfers then assert SMADDRVALIDMC along with SmCS.
              if (AddrValidReadEn1 == 1'b1)
                NxtSMADDRVALIDMC  = 1'b0;
              else
                NxtSMADDRVALIDMC  = 1'b1;

              // Control signal used in Pad Interface to distinguish Async and
              // Sync Access.
              NextAsynAxs = ~SyncEnRead1;

              // Prevent clock stopping if Synchronous memory access is
              // required
              if ((SMClockEn == 1'b0) && (SyncEnRead1 == 1'b0))
                NextClkStpd = 1'b1;
              else
                NextClkStpd = 1'b0;
            end
          // If there is no Request then move to ST_NO_REQ state.
          else
            begin
              NextSmTSMState   = `ST_NO_REQ;
              NextSMBUSREQ     = 1'b0;
              NextBeatCount    = 5'b00000;
              NextIDCYRead     = 4'b0000;
              NextAhbWideRdReg = 3'b000;
              if (SMClockEn == 1'b0)
                NextClkStpd   = 1'b1;
              else
                NextClkStpd   = 1'b0;
            end
      end

    `ST_WRITE :
      begin
        // SmCSTSM is de-asserted on following conditions.
        // a) When there is an Wait Enabled transfer honoured.
        // b) When AhbWideWrCnt = 000 and no further MemWrReq, in case of Normal
        //    transfers.
        // c) When Memory Bus is degranted.
        // d) When a Normal transfer is followed by an Wait - Enabled transfer.
        if (((((iWaitEnReg == 1'b1) || (WaitEn == 1'b1) || (SMBUSGNT == 1'b0) ||
               (HselMemBuf1 != HselMemBufWr) ||
               (HsizeMemBuf1 < iMWWr) ||
               ((iHsizeMemBufWr < iMWWr) && (HsizeMemBuf1 > iHsizeMemBufWr))) &&
              (AhbWideWrCnt <= 3'b001)) ||
              ((AhbWideWrCnt <= 3'b001) && (MemWrReq == 1'b0))) &&
             ((WaitWrCycVerAnd == 1'b0) || (iWaitWrCycDup == 1'b0)))
          begin
            NextSmCSTSM      = 1'b1;
            NextSMCSMC       = 8'b00000000;
            NextSMCSMCn      = 8'b11111111;
            NextSMDATAENMCn  = 4'b1111;
            NextSMBLSMCn     = 4'b1111;
            NextSMBAAMC      = 1'b1;
            NxtSMADDRVALIDMC = 1'b1;
          end
        else
          begin
            // Logic to drive NextAddress. We have to drive the next address
            // when the current write is over i.e when nSMWEN goes from 0 to 1.
            // Also for Memory Width < AHB Width increment the Address.
            if ((DelSMWENMC == 1'b0) && (iSMWENMC == 1'b1) &&
                (iSyncEnWriteReg == 1'b0))
              begin
                if (AhbWideWrCnt > 3'b001)
                  begin
                    NextSmAddrTSM = AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                             HburstMemBufWr);
                    NextSMADDRMC  = ShiftAddr(IncrAddrWr, iMWWr);
                  end
                else
                  begin
                    NextSmAddrTSM = AddrBuf;
                    NextSMADDRMC  = ShiftAddr(AddrBuf, MW);
                  end
              end
          end

        if(iSyncEnWriteReg && UseSecBuf && DelUseSecBuf) begin
          NextXtraTxr = 1'b1;
        end
          
        // Logic for WaitWrCycVer assertion and De-Assertion:
        // When Wait Enabled transfers are pipelined we have to stop the
        // assertion of WaitWrCycVer so that WaitWrCycVerMux is asserted and at
        // the same time a signal WaitWrCycDup should be generated which will
        // ensure that internal logic is not affected. This treatment is
        // required as pipelined Wait Enabled transfers might get completed
        // because of this WaitWrCycVer de-assertion.
        // WaitWrCycVer is deasserted on following conditions.
        // When WstWrCnt = "00000" condition is satisfied. Also before
        // de-assertion WaitWrCycVerAnd = '1' condition should be true.
  
        if (iSyncEnWriteReg == 1'b0)
          begin
            if ((WstWrCnt == 5'b00000) && (WaitWrCycVerAnd == 1'b1) && 
                (iSmCSTSM == 1'b0) && (iWaitWrCycDup == 1'b1))
              begin
                if ((WaitEn == 1'b1) && (iWaitEnReg == 1'b0) &&
                    (AhbWideWrCnt <= 3'b001) && (WRITECYC == 1'b1))
                  begin
                    NextWaitWrCycDup = 1'b0;
                    NextWaitWrCycVer = 1'b1;
                  end
                else
                  begin
                    NextWaitWrCycDup = 1'b1;
                    NextWaitWrCycVer = 1'b0;
                  end
              end
            else
              begin
                NextWaitWrCycDup = 1'b1;
                NextWaitWrCycVer = 1'b1;
              end
          end
        else
          begin
            NextWaitWrCycDup = 1'b1;
            NextWaitWrCycVer = 1'b1;
            // There might be cases where we may not be able to support
            // Synchronous bursts in those cases StopBurst signal is asserted.
            if ((WstWrCnt == 5'b00001) && (iHsizeEqMWidthWr == 1'b1) &&
                (iBMWriteReg == 1'b1))
              begin
                if (((ContWithBrst == 1'b0) &&
                     (HtransMemBuf1 != `HTRANS_SEQ)) ||
                    (WaitEn == 1'b1))
                  NextStopBurst = 1'b1;
                else
                  NextStopBurst = 1'b0;
              end
  
            // For Synchronous Memories WaitWrCycAhb is asserted, so that burst
            // write feature is possible. This signal is asserted when
            // Synchronous burst mode is enabled and AHB Width = Memory Width.
            if ((WstWrCnt == 5'b00001) && (WaitEn == 1'b0) &&
                (iBMWriteReg == 1'b1) && (iHsizeEqMWidthWr == 1'b1) &&
                (AddrNotAligned == 1'b0) && (WrBtCntCpy != 3'b000) &&
                (iSmCSTSM == 1'b0) &&
                (((HtransMemBuf1 == `HTRANS_SEQ) &&
                  (HtranRegCont == `HTRANS_SEQ))||
                 ((HtransMemBuf1 == `HTRANS_NSEQ) && (ContWithBrst == 1'b1))))
              NextWaitWrCycAhb = 1'b0;
            else
              NextWaitWrCycAhb = 1'b1;
          end
  
        // If Synchronous memories are attempting to do Write transfers then
        // de-assert SMADDRVALIDMC so that it appears as pulse.
        if ((AddrValWrEnReg == 1'b1) && (iSMADDRVALIDMC == 1'b0) &&
            (iSyncEnWriteReg == 1'b1))
          NxtSMADDRVALIDMC  = 1'b1;
  
        // Make the State Transition after CS is de-asserted in normal case
        if (iSmCSTSM == 1'b1)
          begin
  
            // If Grant is not there then move to Degranted state if any further
            // Memory Accesses is requested.
            if ((SMBUSGNT == 1'b0) &&
                ((MemRdReq == 1'b1) || (MemWrReq == 1'b1)))
              begin
                NextSmTSMState   = `ST_MEM_DEGRANTED;
                NextSMBUSREQ     = 1'b0;
              end

            // If there is no Request then move to ST_NO_REQ state.
            else
              begin
                NextSmTSMState   = `ST_NO_REQ;
                NextSMBUSREQ     = 1'b0;
                NextBeatCount    = 5'b00000;
                NextIDCYRead     = 4'b0000;
                NextAhbWideRdReg = 3'b000;
                NextWaitEnReg    = 1'b0;
                if (SMClockEn == 1'b0)
                  NextClkStpd   = 1'b1;
                else
                  NextClkStpd   = 1'b0;
              end
  
          end

        // Even if the write counter expired and if wait is asserted we
        // should not assume that the write is over. We have to wait till
        // the wait is de-asserted or cancelwait is asserted. Waited
        // transfer has highest priority then normal transfer.
        else if ((iWaitEnReg == 1'b1) && (SMWaitSync == 1'b0) &&
                 (iSMWENMC == 1'b0) && (iSyncEnWriteReg == 1'b0))
          begin
            NextSmTSMState   = `ST_WAIT_ASSERTED;
            NextWaitWrCycVer = 1'b1;
            NextWriteProg    = 1'b1;
          end

        // Do the Burst transfer if it is enabled.
        else if ((iSyncEnWriteReg == 1'b1) && (WstWrCnt == 5'b00000))
          begin
            NextWaitWrCycAhb = 1'b1;
            NextWaitWrCycVer = 1'b0;
            // Added (iHtranRegCont = HTRANS_SEQ) condition to ensure that
            // what is happening on AHB side is reflected here.
            if ((iWaitWrCycAhb == 1'b0) && (HtranRegCont == `HTRANS_SEQ))
              NextWriteBeatCnt = BoundChkWr(BurstLenWrReg, iMWWr, iSmAddrTSM,
                                            HburstMemBuf, iAhbWiderWr,
                                            AhbWideWrCnt);
            else if (iAhbWiderWr == 1'b1)
              NextWriteBeatCnt = AhbWideWrCnt;
            else
              NextWriteBeatCnt = 3'b000;

            NextSmTSMState   = `ST_BURST_WRITE;
          end
  
        // nSMWENMC assertion and De-assertion logic.
        if ((iSMWENMC == 1'b1) && (iSmCSTSM == 1'b0))
          begin
            // If the nSMWENMC is de-asserted after current write and width
            // mismatches is taken into considerations then register the Memory
            // information.
            if ((AhbWideWrCnt <= 3'b001) && (iSyncEnWriteReg == 1'b0) &&
                (DelSMWENMC == 1'b0) && (MemWrReq == 1'b1))
              begin
                NextHselMemBufWr   = HselMemBuf;
                NextHburstMemBufWr = HburstMemBuf;
                NextSMBLSPolWr     = SMBLSPol;
                NextMWWr           = MW;
                NxtHsizeMemBufWr   = HsizeMemBuf;
                NextHsizeEqMW      = HsizeEqMWidth;
                NextAhbWiderWr     = AhbWider;
                NextAhbNarrowWr    = AhbNarrow;
                NextRBLEWr         = RBLE;
                NextWaitEnReg      = WaitEn;
                NextSyncEnWr       = SyncEnWrite;
                NextBMWriteReg     = BMWrite;
                NextBIWriteEnReg   = BIWriteEn;
                NextBurstLenWr     = BurstLenWrite;
                NextAddrValWrReg   = AddrValidWriteEn;
                NextWSTWRReg       = WSTWR;
                NextWSTWENReg      = WSTWEN;
              end

            // To take care of waited transfers include (WaitEn = '1') condition
            if (((WaitEn == 1'b1) || (MemWrReq == 1'b0) ||
                 (SMBUSGNT == 1'b0) || (HselMemBuf1 != HselMemBufWr) ||
                 (HsizeMemBuf1 < iMWWr) ||
                 ((iHsizeMemBufWr < iMWWr) &&
                  (HsizeMemBuf1 > iHsizeMemBufWr))) &&
                 ((WaitWrCycVerAnd == 1'b0) || (iWaitWrCycDup == 1'b0)) &&
                 (AhbWideWrCnt <= 3'b001))
              begin
                NextSmWrEn       = 1'b1;
                NextWstWrEnCnt   = 4'b0000;
                if (iRBLEWr == 1'b0)
                  NextSMBLSMCn = 4'b1111;
              end
            else if ((WstWrEnCnt == 4'b0000) && (MemWrReq == 1'b1))
              begin
                NextSmWrEn   = 1'b0;
                NextSMBLSMCn = ByteLaneFunc(iMWWr, iHsizeMemBufWr, SMBLSPolWr,
                                            NextValByteLane0, NextValByteLane1,
                                            NextValByteLane2, NextValByteLane3);
              end
            else if (WstWrEnCnt != 4'b0000)
              NextWstWrEnCnt   = WstWrEnCnt - 4'b0001;
          end
        else
          begin
            if (WstWrCnt == 5'b00000)
              begin
                if (((iWaitEnReg == 1'b0) || (SMWaitSync == 1'b1)) &&
                    (iSyncEnWriteReg == 1'b0))
                  begin
                    NextSmWrEn       = 1'b1;
                    if ((iRBLEWr == 1'b0) && (iSmCSTSM == 1'b0))
                      NextSMBLSMCn = 4'b1111;
                    if ((WSTWEN != 4'b0000) && (AhbWideWrCnt <= 3'b001))
                      NextWstWrEnCnt = WSTWEN - 4'b0001;
                    else if ((WSTWENReg != 4'b0000) && (AhbWideWrCnt > 3'b001))
                      NextWstWrEnCnt   = WSTWENReg - 4'b0001;
                    else
                      NextWstWrEnCnt   = 4'b0000;
                  end
              end
          end
  
        // Logic for WstWrCnt loading and Decrementing. For Synchronous memories
        // reloading of counters is avoided.
        
        // WE will always be asserted for at least one cycle, so subtract that
        // from the write wait states.
        if ((WstWrCnt == 5'b00000) && (iSyncEnWriteReg == 1'b0) && iSMWENMC)
          begin
            if (AhbWideWrCnt <= 3'b001)
              NextWstWrCnt = (WSTWEN != 4'd0) ? (WSTWR - 5'd1) : WSTWR;
            else
              NextWstWrCnt = (WSTWENReg != 4'd0) ? (WSTWRReg - 5'd1) : WSTWRReg;
          end
        else if (WstWrCnt != 5'b00000)
          NextWstWrCnt    = WstWrCnt - 5'b00001;
    
      end // case: `ST_WRITE

    `ST_BURST_WRITE :
      begin
      // SM enters this state while performing Synchronous transfers.

      // Start asserting SMBAAMC when there is a Synchronous access and
      // BMWrite is enabled. This will be de-asserted with nSMCS.
        if ((iSyncEnWriteReg == 1'b1) && (iBMWriteReg == 1'b1) && (BIWriteEnReg == 1'b1) &&
            (iSmCSTSM == 1'b0))
          NextSMBAAMC = 1'b0;
        
        // Added for SMBURSTWAIT assertion during write burst
        if (((SyncWtOnMCLK == 1'b0)  ||
             ((SyncWtOnMCLK == 1'b1) && (DelSmBurstWait == 1'b0))) &&
            (iWBstIntrptd == 1'b0) && (iSmCSTSM == 1'b0) &&
            (iHsizeEqMWidthWr == 1'b1) &&
            ((HtransMemBuf1  == `HTRANS_BUSY) || (NewBurst == 1'b1) ||
             (IDLECYC == 1'b1))) begin
          NextWBstIntrptd = 1'b1;
        end else if(iSmCSTSM == 1'b1) begin
          NextWBstIntrptd = 1'b0;
        end
        
        if ((SyncWtOnMCLK == 1'b1) && (DelSmBurstWait == 1'b0) &&
            (iSmCSTSM == 1'b0)) begin
          NextFirstSyncWt = 1'b1;
        end else if (iSmCSTSM == 1'b1) begin
          NextFirstSyncWt = 1'b0;
        end
        
        if ((FirstSyncWt == 1'b1) && (SyncWtOnMCLK == 1'b0) &&
            (DelSmBurstWait == 1'b1) && (iSmCSTSM == 1'b0) && 
            (IDLECYC == 1'b0) &&
        (HtransMemBuf1  == `HTRANS_SEQ)) begin
          NextTxrB4BsyAccptd = 1'b1;
        end else if(iSmCSTSM == 1'b1) begin
          NextTxrB4BsyAccptd = 1'b0;
        end
        
        // De-assert the SmCSTSM when Write request is sampled zero, When the
        // Burst end is reached, When SMBUSGNT is de-asserted, or when New burst
        // was sampled asserted. If above conditions do not occur then decrement
        // the WriteBeatCnt counter.
        if ((((((MemWrReq == 1'b0) ||
              (((((HtransMemBuf1 == `HTRANS_NSEQ) ||
                  (HtransMemBuf1  == `HTRANS_BUSY)) && (SyncWtOnMCLK == 1'b1) &&
                  (UseSecBuf == 1'b0)) ||
                 (StopBurst == 1'b1) ||
                 (((iWBstIntrptd && SyncWtOnMCLK && FirstSyncWt) == 1'b1) &&
                    (iTxrB4BsyAccptd == 1'b0)) ||
                 (((NewBurst || iWBstIntrptd) == 1'b1) && (UseSecBuf == 1'b0))) &&
                 (iHsizeEqMWidthWr == 1'b1))) &&
                 ((AhbWideWrCnt <= 3'b001) || (iHsizeEqMWidthWr == 1'b1))) ||
              (iBMWriteReg == 1'b0) || (iAhbNarrowWr == 1'b1)) &&
             (WaitWrCycVerAnd == 1'b0)) ||
            ((((iAhbWiderWr == 1'b0) && (iWriteBeatCnt == 3'b000)) ||
              ((iAhbWiderWr == 1'b1) && (iWriteBeatCnt == 3'b001))) &&
              (SyncWtOnMCLK == 1'b1))) begin
        NextSmCSTSM      = 1'b1;
        NextSMCSMC       = 8'h00;
        NextSMCSMCn      = 8'hFF;
        NextSMDATAENMCn  = 8'hFF;
        NextSMBLSMCn     = 4'hF;
        NextSmWrEn       = 1'b1;
        NextXtraTxr      = 1'b0;
        if ((iWBstIntrptd == 1'b1) && (DelWaitWrCycVer == 1'b1) &&
            (WaitWrCycVerAnd == 1'b1) && 
            ((iWriteBeatCnt != 3'b000) || (iTxrB4BsyAccptd == 1'b0)))
          NextWaitWrCycVer = 1'b0;
        else
          NextWaitWrCycVer = 1'b1;
      
        NextStopBurst    = 1'b0;
        NextWriteBeatCnt = 3'b000;
        NextSMBAAMC      = 1'b1;
        if ((WaitEn == 1'b1) && (WRITECYC == 1'b1))
          NextWaitWrCycDup = 1'b0;
        else
          NextWaitWrCycDup = 1'b1;
        
      end

        else if ((((iWriteBeatCnt > 3'b001) && (ClockRatio == 2'b00)) ||
                  ((iWriteBeatCnt != 3'b000) && (ClockRatio != 2'b00))) &&
                 (WaitWrCycVerAnd == 1'b0))
          begin
            NextWriteBeatCnt = iWriteBeatCnt - 3'b001;
            NextWaitWrCycVer = 1'b0;
            if ((AhbWideWrCnt != 3'b000) && (iBMWriteReg == 1'b1))
              NextSmAddrTSM = AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                       HburstMemBufWr);
            else
              NextSmAddrTSM = AddrBuf;
          end

        else
          begin
            if(SyncWtOnMCLK == 1'b1)
                begin
                  NextWaitWrCycDup = 1'b1;
                  NextWaitWrCycVer = 1'b1;
                end
            if ((WaitWrCycVerAnd == 1'b0) && (iWriteBeatCnt != 3'b000))
              begin
                NextWriteBeatCnt = iWriteBeatCnt - 3'b001;
                if ((AhbWideWrCnt != 3'b000) && (iBMWriteReg == 1'b1))
                  NextSmAddrTSM = AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                           HburstMemBufWr);
                else
                  NextSmAddrTSM = AddrBuf;
              end
          end
  
        // Make the State Transition after CS is de-asserted.
        if (iSmCSTSM == 1'b1)
          begin
            NextWriteBeatCnt = 3'b000;
            NextWaitWrCycDup = 1'b1;
            NextWaitWrCycVer = 1'b1;
  
            if ((MemWrReq == 1'b1) && (SyncEnWrite == 1'b1))
              begin
                NextSmCSTSM      = 1'b0;
                if ((AhbWideWrCnt == 3'b000) || (DelAhbWideWrCnt <= 3'b001) ||
                    (iHsizeEqMWidthWr == 1'b1))
                  begin
                    NextSMCSMC       = ChipSelRouteH(HselMemBuf);
                    NextSMCSMCn      = ChipSelRouteL(HselMemBuf);
                    NextSMDATAENMCn  = DataEnFunc(MW);
                  end
                else
                  begin
                    NextSMCSMC       = ChipSelRouteH(HselMemBufWr);
                    NextSMCSMCn      = ChipSelRouteL(HselMemBufWr);
                    NextSMDATAENMCn  = DataEnFunc(iMWWr);
                  end
                NextSmTSMState   = `ST_WRITE;
                if ((AhbWideWrCnt == 3'b000) || (DelAhbWideWrCnt <= 3'b001) ||
                    (iHsizeEqMWidthWr == 1'b1))
                  begin
                    NextHselMemBufWr   = HselMemBuf;
                    NextHburstMemBufWr = HburstMemBuf;
                    NextSMBLSPolWr     = SMBLSPol;
                    NextMWWr           = MW;
                    NxtHsizeMemBufWr   = HsizeMemBuf;
                    NextHsizeEqMW      = HsizeEqMWidth;
                    NextAhbWiderWr     = AhbWider;
                    NextAhbNarrowWr    = AhbNarrow;
                    NextRBLEWr         = RBLE;
                    NextWaitEnReg      = WaitEn;
                    NextSyncEnWr       = SyncEnWrite;
                    NextBMWriteReg     = BMWrite;
                    NextBIWriteEnReg   = BIWriteEn;
                    NextBurstLenWr     = BurstLenWrite;
                    NextAddrValWrReg   = AddrValidWriteEn;
                    NextWSTWRReg       = WSTWR;
                    NextWSTWENReg      = WSTWEN;
                    NextWstWrCnt       = WSTWR;
          
                    if ((WSTWR == 5'b00000) && (SyncEnWrite == 1'b1) &&
                        (AddrNotAligned == 1'b0) &&
                        (BMWrite == 1'b1) && (HsizeEqMWidth == 1'b1))
                      NextWaitWrCycAhb = 1'b0;
                    else
                      NextWaitWrCycAhb = 1'b1;
         
                    // logic to assert nSMBLSMC
                    if ((RBLE == 1'b1) || (SyncEnWrite == 1'b1) ||
                        ((WSTWEN == 4'b0000) || (WaitEn == 1'b1)))
                      NextSMBLSMCn = ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                                  NextValByteLane0,
                                                  NextValByteLane1,
                                                  NextValByteLane2,
                                                  NextValByteLane3);
 
                    // Start asserting SmWrEn if it is wait enabled transfer or
                    // if the WSTWEN counter is programmed as zero.
                    if ((WSTWEN == 4'b0000) || (WaitEn == 1'b1))
                      begin
                        NextSmWrEn       = 1'b0;
                        NextWstWrEnCnt   = 4'b0000;
                      end
                    else
                      // The count is decremented and loaded so that in ST_WRITE
                      // the implementation becomes uniform where it waits for
                      // count to decrement to 0, when re-assertion of nSMWENMC
                      // is required.
                      NextWstWrEnCnt   = WSTWEN - 4'b0001;
    
                    // If Synchronous memories are attempting to do an Async
                    // transfers then assert SMADDRVALIDMC along with SmCS.
                    if (AddrValidWriteEn == 1'b1)
                      NxtSMADDRVALIDMC  = 1'b0;
                    else
                      NxtSMADDRVALIDMC  = 1'b1;

                    // Prevent clock stopping if Synchronous memory access is
                    // required
                    if ((SMClockEn == 1'b0) && (SyncEnWrite == 1'b0))
                      NextClkStpd = 1'b1;
                    else
                      NextClkStpd = 1'b0;
                  end
                else
                  begin
                    NextWstWrCnt = WSTWRReg;

                    if ((WSTWRReg == 5'b00000) && (AddrNotAligned == 1'b0) &&
                        (iBMWriteReg == 1'b1) && (iHsizeEqMWidthWr == 1'b1))
                      NextWaitWrCycAhb = 1'b0;
                    else
                      NextWaitWrCycAhb = 1'b1;

                    // logic to assert nSMBLSMC
                    if ((iRBLEWr == 1'b1) || (iSyncEnWriteReg == 1'b1) ||
                        (WSTWENReg == 4'b0000))
                      NextSMBLSMCn = ByteLaneFunc(iMWWr, iHsizeMemBufWr,
                                                  SMBLSPolWr, NextValByteLane0,
                                                  NextValByteLane1,
                                                  NextValByteLane2,
                                                  NextValByteLane3);
 
                    // Start asserting SmWrEn if WSTWENReg counter is
                    // programmed as 0.
                    if (WSTWENReg == 4'b0000)
                      begin
                        NextSmWrEn     = 1'b0;
                        NextWstWrEnCnt = 4'b0000;
                      end
                    else
                      // The count is decremented and loaded so that in ST_WRITE
                      // state the implementation becomes uniform where it waits
                      // for count to decrement to 0, when re-assertion of
                      // nSMWENMC is required.
                      NextWstWrEnCnt = WSTWENReg - 4'b0001;
        
                    NxtSMADDRVALIDMC = 1'b0;
                  end

                if ((AhbWideWrCnt != 3'b000) && (iBMWriteReg == 1'b0) &&
                    (DelAhbWideWrCnt[2:1] != 2'b00))
                  begin
                    NextSmAddrTSM = AddrIncr(iSmAddrTSM, iMWWr, iHsizeMemBufWr,
                                             HburstMemBufWr);
                    NextSMADDRMC  = ShiftAddr(IncrAddrWr, iMWWr);
                  end
                else
                  begin
                    NextSmAddrTSM = AddrBuf;      
                    NextSMADDRMC  = ShiftAddr(AddrBuf, MW);
                  end
      
              end

            // If SMBUSGNT is sampled asserted and if there is a Read Transfer
            // sampled then we to move to ST_READ state by appropriately loading
            // the counters.
            else if ((MemRdReq == 1'b1) && (SyncEnRead1 == 1'b1) &&
                     (MemWrReq == 1'b0))
              begin
                NextWaitEnReg    = 1'b0;
                NextSmCSTSM      = 1'b0;
                NextSMCSMC       = ChipSelRouteH(HselMemBuf1);
                NextSMCSMCn      = ChipSelRouteL(HselMemBuf1);
                NextSMDATAENMCn  = 4'b1111;
                NextSmTSMState   = `ST_READ;
                NextWstBrstRdCnt = WSTBRD1;
                NextSmAddrTSM    = AddrBuf1;
                NextSMADDRMC     = ShiftAddr(AddrBuf1, MW1);
                NextIDCYRead     = IDCYC;
                NextSyncEnWr     = 1'b0;
                NextBeatCount    = BoundaryChk(AddrBuf1[5:0], AhbCount,
                                               BurstLenRead1, MW1, HburstMemBuf,
                                               WrapRead, SyncEnRead1,
                                               HsizeMemBuf1, BMRead1);
      
                // Start asserting SmOEn if it is wait enabled transfer or if
                // the WSTOEN1 counter is programmed as zero.
                if ((WSTOEN1 == 4'b0000) || (WaitEn == 1'b1))
                  NextSmOEn     = 1'b0;
                else
                  NextWstOEnCnt = WSTOEN1;
     
                // logic to assert nSMBLSMC
                if ((RBLE == 1'b1) && (MW1 != `MEM_BYTE))
                  NextSMBLSMCn = {4{SMBLSPol}};
                else
                  NextSMBLSMCn = 4'b1111;
 
                // Start asserting WaitRdCyc if WSTRD1 counter is programmed as
                // 0, in case of Asynchronous memories. Otherwise load the Long
                // Read counter. This distinction is done because Asynchronous
                // Memory accesses has to be By-passed.
                //NextWstLongRdCnt = WSTRD1;
                if ((WSTRD1 == 5'b00000) && (SyncEnRead1 == 1'b0))
                  begin
                    NextWaitRdCycVer = 1'b0;
                    NextWstLongRdCnt = 5'b00000;
                  end
                else
                  NextWstLongRdCnt = WSTRD1;
      
                // If Synchronous memories are attempting to do an Asynchronous
                // transfers then assert SMADDRVALIDMC along with SmCS.
                if (AddrValidReadEn1 == 1'b1)
                  NxtSMADDRVALIDMC  = 1'b0;
                else
                  NxtSMADDRVALIDMC  = 1'b1;

                // Prevent clock stopping if Synchronous memory access is
                // required
                if ((SMClockEn == 1'b0) && (SyncEnRead1 == 1'b0))
                  NextClkStpd = 1'b1;
                else
                  NextClkStpd = 1'b0;
      
              end
            // If there is no Request then move to ST_NO_REQ state.
            else
              begin
                NextWaitEnReg    = 1'b0;
                NextSmTSMState   = `ST_NO_REQ;
                NextSMBUSREQ     = 1'b0;
                NextBeatCount    = 5'b00000;
                NextIDCYRead     = 4'b0000;
                NextAhbWideRdReg = 3'b000;
                NextSyncEnWr     = 1'b0;
                if (SMClockEn == 1'b0)
                  NextClkStpd   = 1'b1;
                else
                  NextClkStpd   = 1'b0;
              end
          end
      end

    `ST_TURNAROUND :
      begin
      // The SM enters this state from ST_WAIT_TXRONBUS state.
      // When the SM entered this state there may be pending Read Transfers for
      // Different Bank or a Pending Write Transfers, Or the Bus might be
      // Degranted so before handing over the bus we have to do TurnAround, so
      // that subsequent Write from other controllers does not lead to Bus
      // Contention. In This state do Idling till the IdcyCnt expires.

        if (NewBurst == 1'b1)
          NextAhbWideRdReg = 3'b000;
  
        // Decrement the count till it has reached the value = "0001".
        if (IdcyCount == 4'b0001)
          begin
            NextIDCYRead     = 4'b0000;
            if ((SMBUSGNT == 1'b0) &&
                ((MemWrReq == 1'b1) || (MemRdReq == 1'b1)))
              begin
                // Grant not there but some transfers have to be done, so make a
                // State transition to Degrant state.
                NextSmTSMState   = `ST_MEM_DEGRANTED;
                NextSMBUSREQ     = 1'b0;
              end

            // If SMBUSGNT is sampled asserted and if there is a pending Write
            // transfers to be performed(bcoz of break in burst) or a NewBurst
            // is sampled then we to move to ST_WRITE state by appropriately
            // loading the counters.
            else if (MemWrReq == 1'b1)
              begin
                NextHselMemBufWr   = HselMemBuf;
                NextHburstMemBufWr = HburstMemBuf;
                NextSMBLSPolWr     = SMBLSPol;
                NextMWWr           = MW;
                NxtHsizeMemBufWr   = HsizeMemBuf;
                NextHsizeEqMW      = HsizeEqMWidth;
                NextAhbWiderWr     = AhbWider;
                NextAhbNarrowWr    = AhbNarrow;
                NextRBLEWr         = RBLE;
                NextWaitEnReg      = WaitEn;
                NextSyncEnWr       = SyncEnWrite;
                NextBMWriteReg     = BMWrite;
                NextBIWriteEnReg   = BIWriteEn;
                NextBurstLenWr     = BurstLenWrite;
                NextAddrValWrReg   = AddrValidWriteEn;
                NextWSTWRReg       = WSTWR;
                NextWSTWENReg      = WSTWEN;
                NextSmCSTSM        = 1'b0;
                NextSMCSMC         = ChipSelRouteH(HselMemBuf);
                NextSMCSMCn        = ChipSelRouteL(HselMemBuf);
                NextSMDATAENMCn    = DataEnFunc(MW);
                NextSmTSMState     = `ST_WRITE;
                NextWstWrCnt       = WSTWR;
    
                // Assertion of WaitWrCycAhb signal for Synchronous Write
                // transfer
                if ((WSTWR == 5'b00000) && (SyncEnWrite == 1'b1) &&
                    (AddrNotAligned == 1'b0) && (BMWrite == 1'b1) &&
                    (HsizeEqMWidth == 1'b1))
                  NextWaitWrCycAhb = 1'b0;
                else
                  NextWaitWrCycAhb = 1'b1;
   
                // logic to assert nSMBLSMC
                if ((RBLE == 1'b1) || (SyncEnWrite == 1'b1) ||
                    ((WSTWEN == 4'b0000) || (WaitEn == 1'b1)))
                  NextSMBLSMCn = ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                              NextValByteLane0,
                                              NextValByteLane1,
                                              NextValByteLane2,
                                              NextValByteLane3);
 
                // Start asserting SmWrEn if it is wait enabled transfer or if
                // the WSTWEN counter is programmed as zero.
                if ((WSTWEN == 4'b0000) || (WaitEn == 1'b1))
                  begin
                    NextSmWrEn       = 1'b0;
                    NextWstWrEnCnt   = 4'b0000;
                  end
                else
                  // The count is decremented and loaded so that in ST_WRITE
                  // the implementation becomes uniform where it waits for count
                  // to decrement to 0, when re-assertion of nSMWENMC is
                  // required.
                  NextWstWrEnCnt   = WSTWEN - 4'b0001;
    
                NextSmAddrTSM = AddrBuf;
                NextSMADDRMC  = ShiftAddr(AddrBuf, MW);
    
                // If Synchronous memories are attempting to do an Asynchronous
                // transfers then assert SMADDRVALIDMC along with SmCS.
                if (AddrValidWriteEn == 1'b1)
                  NxtSMADDRVALIDMC  = 1'b0;
                else
                  NxtSMADDRVALIDMC  = 1'b1;

                // Control signal used in Pad Interface to distinguish Async and
                // Sync Access.
                NextAsynAxs = ~SyncEnWrite;

                // Prevent clock stopping if Synchronous memory access is
                // required
                if ((SMClockEn == 1'b0) && (SyncEnWrite == 1'b0))
                  NextClkStpd = 1'b1;
                else
                  NextClkStpd = 1'b0;
              end
    
            // If SMBUSGNT is sampled asserted and if there are pending Read
            // transfers to be performed(bcoz of break in burst) or a NewBurst
            // is sampled then we to move to ST_READ state by appropriately
            // loading the counters.
            else if (MemRdReq == 1'b1)
              begin
                NextSmCSTSM      = 1'b0;
                NextSMCSMC       = ChipSelRouteH(HselMemBuf1);
                NextSMCSMCn      = ChipSelRouteL(HselMemBuf1);
                NextSMDATAENMCn  = 4'b1111;
                NextSmTSMState   = `ST_READ;
                NextWstBrstRdCnt = WSTBRD1;
                NextSmAddrTSM    = AddrBuf1;
                NextSMADDRMC     = ShiftAddr(AddrBuf1, MW1);
                NextIDCYRead     = IDCYC;
                NextBeatCount    = BoundaryChk(AddrBuf1[5:0], AhbCount,
                                               BurstLenRead1, MW1, HburstMemBuf,
                                               WrapRead, SyncEnRead1,
                                               HsizeMemBuf1, BMRead1);
      
                // Start asserting SmOEn if it is wait enabled transfer or if
                // the WSTOEN1 counter is programmed as zero.
                if ((WSTOEN1 == 4'b0000) || (WaitEn == 1'b1))
                  NextSmOEn     = 1'b0;
                else
                  NextWstOEnCnt = WSTOEN1;

                // logic to assert nSMBLSMC
                if ((RBLE == 1'b1) && (MW1 != `MEM_BYTE))
                  NextSMBLSMCn = {4{SMBLSPol}};
                else
                  NextSMBLSMCn = 4'b1111;
      
                // Start asserting WaitRdCyc if WSTRD1 counter is programmed as
                // 0, in case of Asynchronous memories. Otherwise load the Long
                // Read counter. This distinction is done because Asynchronous
                // Memory accesses has to be By-passed.
                if ((WSTRD1 == 5'b00000) && (SyncEnRead1 == 1'b0))
                  begin
                    NextWaitRdCycVer = 1'b0;
                    NextWstLongRdCnt = 5'b00000;
                  end
                else
                  NextWstLongRdCnt = WSTRD1;
      
                // If Synchronous memories are attempting to do an Asynchronous
                // transfers then assert SMADDRVALIDMC along with SmCS.
                if (AddrValidReadEn1 == 1'b1)
                  NxtSMADDRVALIDMC  = 1'b0;
                else
                  NxtSMADDRVALIDMC  = 1'b1;

                // Control signal used in Pad Interface to distinguish Async and
                // Sync Access.
                NextAsynAxs = ~SyncEnRead1;

                // Prevent clock stopping if Synchronous memory access is
                // required
                if ((SMClockEn == 1'b0) && (SyncEnRead1 == 1'b0))
                  NextClkStpd = 1'b1;
                else
                  NextClkStpd = 1'b0;
              end
            // If there is no Request then move to ST_NO_REQ state.
            else
              begin
                NextSmTSMState   = `ST_NO_REQ;
                NextSMBUSREQ     = 1'b0;
                NextBeatCount    = 5'b00000;
                NextIDCYRead     = 4'b0000;
                NextAhbWideRdReg = 3'b000;
                if (SMClockEn == 1'b0)
                  NextClkStpd   = 1'b1;
                else
                  NextClkStpd   = 1'b0;
              end
          end
        else
          NextIdcyCount    = IdcyCount - 4'b0001;
      end

    `ST_MEM_DEGRANTED :
      begin
        NextSMBUSREQ     = 1'b1;
        if (SMBUSGNT == 1'b1)
          begin
    
            // Priority is given for Write as there are chances of having a
            // posted Write and we may have to service it, because AHB bus would
            // be free to come up with Read transfers, and this posted Write
            // gets lost. If SMBUSGNT is sampled asserted and if there are
            // pending Write transfers to be performed(bcoz of break in burst)
            // or a NewBurst has been sampled then we to move to ST_WRITE state
            // by appropriately loading the counters.
            if (MemWrReq == 1'b1)
              begin
                NextHselMemBufWr   = HselMemBuf;
                NextHburstMemBufWr = HburstMemBuf;
                NextSMBLSPolWr     = SMBLSPol;
                NextMWWr           = MW;
                NxtHsizeMemBufWr   = HsizeMemBuf;
                NextHsizeEqMW      = HsizeEqMWidth;
                NextAhbWiderWr     = AhbWider;
                NextAhbNarrowWr    = AhbNarrow;
                NextRBLEWr         = RBLE;
                NextWaitEnReg      = WaitEn;
                NextSyncEnWr       = SyncEnWrite;
                NextBMWriteReg     = BMWrite;
                NextBIWriteEnReg   = BIWriteEn;
                NextBurstLenWr     = BurstLenWrite;
                NextAddrValWrReg   = AddrValidWriteEn;
                NextWSTWRReg       = WSTWR;
                NextWSTWENReg      = WSTWEN;
                NextSmCSTSM        = 1'b0;
                NextSMCSMC         = ChipSelRouteH(HselMemBuf);
                NextSMCSMCn        = ChipSelRouteL(HselMemBuf);
                NextSMDATAENMCn    = DataEnFunc(MW);
                NextSmTSMState     = `ST_WRITE;
                NextWstWrCnt       = WSTWR;
      
                // Assertion of WaitWrCycAhb signal for Synchronous Write
                // transfers.
                if ((WSTWR == 5'b00000) && (SyncEnWrite == 1'b1) &&
                    (AddrNotAligned == 1'b0) && (BMWrite == 1'b1) &&
                    (HsizeEqMWidth == 1'b1))
                  NextWaitWrCycAhb = 1'b0;
                else
                  NextWaitWrCycAhb = 1'b1;
     
                // logic to assert nSMBLSMC
                if ((RBLE == 1'b1) || (SyncEnWrite == 1'b1) ||
                    ((WSTWEN == 4'b0000) || (WaitEn == 1'b1)))
                  NextSMBLSMCn = ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                              NextValByteLane0,
                                              NextValByteLane1,
                                              NextValByteLane2,
                                              NextValByteLane3);
 
                // Start asserting SmWrEn if it is wait enabled transfer or if
                // the WSTWEN counter is programmed as zero.
                if ((WSTWEN == 4'b0000) || (WaitEn == 1'b1))
                  begin
                    NextSmWrEn       = 1'b0;
                    NextWstWrEnCnt   = 4'b0000;
                  end
                else
                  // The count is decremented and loaded so that in ST_WRITE
                  // the implementation becomes uniform where it waits for count
                  // to decrement to 0, when re-assertion of nSMWENMC is
                  // required.
                  NextWstWrEnCnt   = WSTWEN - 4'b0001;
      
                NextSmAddrTSM = AddrBuf;
                NextSMADDRMC  = ShiftAddr(AddrBuf, MW);
      
                // If Synchronous memories are attempting to do an Asynchronous
                // transfers then assert SMADDRVALIDMC along with SmCS.
                if (AddrValidWriteEn == 1'b1)
                  NxtSMADDRVALIDMC  = 1'b0;
                else
                  NxtSMADDRVALIDMC  = 1'b1;

                // Control signal used in Pad Interface to distinguish Async and
                // Sync Access.
                NextAsynAxs = ~SyncEnWrite;

                // Prevent clock stopping if Synchronous memory access is
                // required
                if ((SMClockEn == 1'b0) && (SyncEnWrite == 1'b0))
                  NextClkStpd = 1'b1;
                else
                  NextClkStpd = 1'b0;
              end

            else
            // If SMBUSGNT is sampled asserted and if there are pending Read
            // transfers to be performed(bcoz of break in burst) or a NewBurst
            // is sampled then we to move to ST_READ state by appropriately
            // loading the counters.
              begin
                NextSmCSTSM      = 1'b0;
                NextSMCSMC       = ChipSelRouteH(HselMemBuf1);
                NextSMCSMCn      = ChipSelRouteL(HselMemBuf1);
                NextSMDATAENMCn  = 4'b1111;
                NextSmTSMState   = `ST_READ;
                NextWstBrstRdCnt = WSTBRD1;
                NextIDCYRead     = IDCYC;
      
                if ((AhbWideRdReg != 3'b000) && (AhbWideRdCnt != 3'b000) &&
                    (AhbWider == 1'b1))
                  begin
                    NextSmAddrTSM = AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                             HburstMemBuf);
                    NextSMADDRMC  = ShiftAddr(IncrAddr, MW1);
                    NextBeatCount = BoundaryChk(IncrAddr[5:0], Temp_Concat,
                                                BurstLenRead1, MW1,
                                                HburstMemBuf, WrapRead,
                                                SyncEnRead1, HsizeMemBuf1,
                                                BMRead1);
                  end
                else
                  begin
                    NextSmAddrTSM = AddrBuf1;
                    NextSMADDRMC  = ShiftAddr(AddrBuf1, MW1);
                    NextBeatCount = BoundaryChk(AddrBuf1[5:0], AhbCount,
                                                BurstLenRead1, MW1,
                                                HburstMemBuf, WrapRead,
                                                SyncEnRead1, HsizeMemBuf1,
                                                BMRead1);
                  end
      
                // Start asserting SmOEn if it is wait enabled transfer or if
                // the WSTOEN1 counter is programmed as zero.
                if ((WSTOEN1 == 4'b0000) || (WaitEn == 1'b1))
                  NextSmOEn     = 1'b0;
                else
                  NextWstOEnCnt = WSTOEN1;

                // logic to assert nSMBLSMC
                if ((RBLE == 1'b1) && (MW1 != `MEM_BYTE))
                  NextSMBLSMCn = {4{SMBLSPol}};
                else
                  NextSMBLSMCn = 4'b1111;
      
                // Start asserting WaitRdCyc if WSTRD1 counter is programmed as
                // 0, in case of Asynchronous memories. Otherwise load the Long
                // Read counter. This distinction is done because Asynchronous
                // Memory accesses has to be By-passed.
                if ((WSTRD1 == 5'b00000) && (SyncEnRead1 == 1'b0))
                  begin
                    NextWaitRdCycVer = 1'b0;
                    NextWstLongRdCnt = 5'b00000;
                  end
                else
                  NextWstLongRdCnt = WSTRD1;
      
                // If Synchronous memories are attempting to do an Asynchronous
                // transfers then assert SMADDRVALIDMC along with SmCS.
                if (AddrValidReadEn1 == 1'b1)
                  NxtSMADDRVALIDMC  = 1'b0;
                else
                  NxtSMADDRVALIDMC  = 1'b1;

                // Control signal used in Pad Interface to distinguish Async and
                // Sync Access.
                NextAsynAxs = ~SyncEnRead1;

                // Prevent clock stopping if Synchronous memory access is
                // required
                if ((SMClockEn == 1'b0) && (SyncEnRead1 == 1'b0))
                  NextClkStpd = 1'b1;
                else
                  NextClkStpd = 1'b0;
              end
          end
      end

    `ST_WAIT_ASSERTED :
      begin
        if (SmCancelWaitSync == 1'b1)
          begin
            NextSmTSMState   = `ST_CANCEL_WAIT;
            NextSmOEn        = 1'b1;
            NextWaitRdCycVer = 1'b1;
            NextWaitWrCycVer = 1'b1;
            NextSmWrEn       = 1'b1;
            if (iRBLEWr == 1'b0)
              NextSMBLSMCn = 4'b1111;
            if (MemWrReq == 1'b1)
              begin
                NextSmCSTSM      = 1'b0;
                NextSMCSMC       = ChipSelRouteH(HselMemBuf);
                NextSMCSMCn      = ChipSelRouteL(HselMemBuf);
                NextSMDATAENMCn  = DataEnFunc(MW);
              end
            else
              begin
                NxtSMADDRVALIDMC = 1'b1;
                NextSmCSTSM      = 1'b1;
                NextSMCSMC       = 8'b00000000;
                NextSMCSMCn      = 8'b11111111;
                NextSMDATAENMCn  = 4'b1111;
                NextSMBLSMCn     = 4'b1111;
              end
          end
        else if (SMWaitSync == 1'b1)
          begin
            NextToggle       = 1'b0;
            NextSmTSMState   = `ST_WAIT_DEASSERTED;
            NextSmWrEn       = 1'b1;
            if ((iRBLEWr == 1'b0) && (iSMWENMC == 1'b0))
              NextSMBLSMCn = 4'b1111;
            if (MemRdReq == 1'b1)
              NextWaitRdCycVer = 1'b0;
            else
              NextWaitWrCycVer = 1'b0;
          end
      end

    `ST_WAIT_DEASSERTED :
      begin
        if (iSmCSTSM == 1'b1)
          NextToggle =  ~iToggle;
  
        if ((iWaitRdCyc == 1'b0) && (BeatCount != 5'b00000))
          begin
            NextBeatCount = BeatCount - 5'b00001;
          end
  
        NextWaitWrCycVer = 1'b1;
        NextWaitRdCycVer = 1'b1;
        NextSmCSTSM      = 1'b1;
        NextSMCSMC       = 8'b00000000;
        NextSMCSMCn      = 8'b11111111;
        NextSMDATAENMCn  = 4'b1111;
        NextSMBLSMCn     = 4'b1111;
        NxtSMADDRVALIDMC = 1'b1;
        NextSmOEn        = 1'b1;

        if ((iToggle == 1'b1) || (NewBurst == 1'b1))
          begin
            NextWriteProg    = 1'b0;
            NextWaitEnReg    = 1'b0;
            NextIDCYRead     = 4'b0000;
            if (NewBurst == 1'b1)
              NextAhbWideRdReg = 3'b000;

            if (iSmCSTSM == 1'b1)
              begin
                if (((TurnAround == 1'b1) && (IDCYRead != 4'b0000)) ||
                    ((IDCYRead != 4'b0000) && (MemRdReq == 1'b0)))
                  begin
                    NextSmTSMState   = `ST_TURNAROUND;
                    NextIdcyCount    = IDCYRead;
                    NextWaitRdCycVer = 1'b1;
                  end
      
                // If Grant is not there and Turnaround is not required, then
                // move to Degranted state, if any further Memory Accesses is
                // requested.
                else if ((SMBUSGNT == 1'b0) && (AhbWideWrCnt == 3'b000) &&
                         ((MemRdReq == 1'b1) || (MemWrReq == 1'b1)))
                  begin
                    NextSmTSMState   = `ST_MEM_DEGRANTED;
                    NextSMBUSREQ     = 1'b0;
                    NextWaitRdCycVer = 1'b1;
                  end
      
                // If SMBUSGNT is sampled asserted and if a New Write Transfer
                // is sampled then SM moves to ST_WRITE state by appropriately
                // loading the counters.
                else if ((MemWrReq == 1'b1) && (AhbWideWrCnt != 3'b000))
                  begin
                    NextHselMemBufWr   = HselMemBuf;
                    NextHburstMemBufWr = HburstMemBuf;
                    NextSMBLSPolWr     = SMBLSPol;
                    NextMWWr           = MW;
                    NxtHsizeMemBufWr   = HsizeMemBuf;
                    NextHsizeEqMW      = HsizeEqMWidth;
                    NextAhbWiderWr     = AhbWider;
                    NextAhbNarrowWr    = AhbNarrow;
                    NextRBLEWr         = RBLE;
                    NextWaitEnReg      = WaitEn;
                    NextSyncEnWr       = SyncEnWrite;
                    NextBMWriteReg     = BMWrite;
                    NextBIWriteEnReg   = BIWriteEn;
                    NextBurstLenWr     = BurstLenWrite;
                    NextAddrValWrReg   = AddrValidWriteEn;
                    NextWSTWRReg       = WSTWR;
                    NextWSTWENReg      = WSTWEN;
                    NextSmCSTSM        = 1'b0;
                    NextSMCSMC         = ChipSelRouteH(HselMemBuf);
                    NextSMCSMCn        = ChipSelRouteL(HselMemBuf);
                    NextSMDATAENMCn    = DataEnFunc(MW);
                    NextSmTSMState     = `ST_WRITE;
                    NextWstWrCnt       = WSTWR;
        
                    // Assertion of WaitWrCycAhb signal for Synchronous Write
                    // transfers.
                    if ((WSTWR == 5'b00000) && (SyncEnWrite == 1'b1) &&
                        (AddrNotAligned == 1'b0) && (BMWrite == 1'b1) &&
                        (HsizeEqMWidth == 1'b1))
                      NextWaitWrCycAhb = 1'b0;
                    else
                      NextWaitWrCycAhb = 1'b1;
       
                    // logic to assert nSMBLSMC
                    if ((RBLE == 1'b1) || (SyncEnWrite == 1'b1) ||
                        ((WSTWEN == 4'b0000) || (WaitEn == 1'b1)))
                      NextSMBLSMCn = ByteLaneFunc(MW, HsizeMemBuf, SMBLSPol,
                                                  NextValByteLane0,
                                                  NextValByteLane1,
                                                  NextValByteLane2,
                                                  NextValByteLane3);
 
                    // Start asserting SmWrEn if it is wait enabled transfer or
                    // if the WSTWEN counter is programmed as zero.
                    if ((WSTWEN == 4'b0000) || (WaitEn == 1'b1))
                      begin
                        NextSmWrEn       = 1'b0;
                        NextWstWrEnCnt   = 4'b0000;
                      end
                    else
                      // The count is decremented and loaded so that in ST_WRITE
                      // the implementation becomes uniform where it wait for
                      // this count to decrement to 0, when re-assertion of
                      // nSMWENMC is required.
                      NextWstWrEnCnt   = WSTWEN - 4'b0001;
        
                    if (AhbWideWrCnt != 3'b000)
                      begin
                        NextSmAddrTSM = AddrIncr(iSmAddrTSM, iMWWr, HsizeMemBuf,
                                                  HburstMemBuf);
                        NextSMADDRMC  = ShiftAddr(IncrAddrWr, iMWWr);
                      end
                    else
                      begin
                        NextSmAddrTSM = AddrBuf;
                        NextSMADDRMC  = ShiftAddr(AddrBuf, MW);
                      end
        
                    // If Synchronous memories are attempting to do an Async
                    // transfers then assert SMADDRVALIDMC along with SmCS.
                    if (AddrValidWriteEn == 1'b1)
                      NxtSMADDRVALIDMC  = 1'b0;
                    else
                      NxtSMADDRVALIDMC  = 1'b1;

                    // Control signal used in Pad Interface to distinguish Async
                    // and Sync Access.
                    NextAsynAxs = ~SyncEnWrite;

                    // Prevent clock stopping if Synchronous memory access is
                    // required
                    if ((SMClockEn == 1'b0) && (SyncEnWrite == 1'b0))
                      NextClkStpd = 1'b1;
                    else
                      NextClkStpd = 1'b0;
                  end
      
                // If SMBUSGNT is sampled asserted and there are pending Read
                // transfer to be performed(bcoz of break in burst) or NewBurst
                // is been sampled, then move to ST_READ state by appropriately
                // loading the counters.
                else if ((MemRdReq == 1'b1) && (MemWrReq == 1'b0))
                  begin
                    NextSmCSTSM      = 1'b0;
                    NextSMCSMC       = ChipSelRouteH(HselMemBuf1);
                    NextSMCSMCn      = ChipSelRouteL(HselMemBuf1);
                    NextSMDATAENMCn  = 4'b1111;
                    NextSmTSMState   = `ST_READ;
                    NextWstBrstRdCnt = WSTBRD1;
                    NextIDCYRead     = IDCYC;
        
                    if ((Temp_Concat != 5'b00000) && (NewBurst == 1'b0) &&
                        (AhbWider == 1'b1))
                      begin
                        NextSmAddrTSM = AddrIncr(iSmAddrTSM, MW1, HsizeMemBuf1,
                                                 HburstMemBuf);
                        NextSMADDRMC  = ShiftAddr(IncrAddr, MW1);
                        NextBeatCount = BoundaryChk(IncrAddr[5:0], Temp_Concat,
                                                    BurstLenRead1, MW1,
                                                    HburstMemBuf, WrapRead,
                                                    SyncEnRead1, HsizeMemBuf1,
                                                    BMRead1);
                      end
                    else
                      begin
                        NextSmAddrTSM = AddrBuf1;
                        NextSMADDRMC  = ShiftAddr(AddrBuf1, MW1);
                        NextBeatCount = BoundaryChk(AddrBuf1[5:0], AhbCount,
                                                    BurstLenRead1, MW1,
                                                    HburstMemBuf, WrapRead,
                                                    SyncEnRead1, HsizeMemBuf1,
                                                    BMRead1);
                      end
        
                    // Start asserting SmOEn if it is wait enabled transfer or
                    // if the WSTOEN1 counter is programmed as zero.
                    if ((WSTOEN1 == 4'b0000) || (WaitEn == 1'b1))
                      NextSmOEn        = 1'b0;
                    else
                      NextWstOEnCnt    = WSTOEN1;
       
                    // logic to assert nSMBLSMC
                    if ((RBLE == 1'b1) && (MW1 != `MEM_BYTE))
                      NextSMBLSMCn = {4{SMBLSPol}};
                    else
                      NextSMBLSMCn = 4'b1111;
     
                    // Start asserting WaitRdCyc if WSTRD1 counter is programmed
                    // as 0, in case of Asynchronous memories. Otherwise load
                    // the Long Read counter. This distinction is done because
                    // Asynchronous Memory accesses has to be By-passed.
                    if ((WSTRD1 == 5'b00000) && (SyncEnRead1 == 1'b0))
                      begin
                        NextWaitRdCycVer = 1'b0;
                        NextWstLongRdCnt = 5'b00000;
                      end
                    else
                      NextWstLongRdCnt = WSTRD1;
        
                    // If Synchronous memories are attempting to do an Async
                    // transfers then assert SMADDRVALIDMC along with SmCS.
                    if (AddrValidReadEn1 == 1'b1)
                      NxtSMADDRVALIDMC  = 1'b0;
                    else
                      NxtSMADDRVALIDMC  = 1'b1;

                    // Control signal used in Pad Interface to distinguish Async
                    // and Sync Access.
                    NextAsynAxs = ~SyncEnRead1;

                    // Prevent clock stopping if Synchronous memory access is
                    // required
                    if ((SMClockEn == 1'b0) && (SyncEnRead1 == 1'b0))
                      NextClkStpd = 1'b1;
                    else
                      NextClkStpd = 1'b0;
                  end
                // If there is no Request then move to ST_NO_REQ state.
                else
                  begin
                    NextSmTSMState   = `ST_NO_REQ;
                    NextSMBUSREQ     = 1'b0;
                    NextBeatCount    = 5'b00000;
                    NextIDCYRead     = 4'b0000;
                    NextAhbWideRdReg = 3'b000;
                    NextWaitEnReg    = 1'b0;
                    if (SMClockEn == 1'b0)
                      NextClkStpd   = 1'b1;
                    else
                      NextClkStpd   = 1'b0;
                  end
              end
          end
      end

    `ST_CANCEL_WAIT :
      begin
        NextSmCSTSM      = 1'b1;
        NextSMCSMC       = 8'b00000000;
        NextSMCSMCn      = 8'b11111111;
        NextSMDATAENMCn  = 4'b1111;
        NextSMBLSMCn     = 4'b1111;
        NxtSMADDRVALIDMC = 1'b1;
        NextWriteProg    = 1'b0;
        if ((iSmCSTSM == 1'b1) && (SMWaitSync == 1'b1))
          begin
            NextIDCYRead     = 4'b0000;
            if (((TurnAround == 1'b1) && (IDCYRead != 4'b0000)) ||
                ((IDCYRead != 4'b0000) && (IDLECYC == 1'b1)))
              begin
                NextSmTSMState   = `ST_TURNAROUND;
                NextIdcyCount    = IDCYRead;
                NextWaitRdCycVer = 1'b1;
              end

            // Move to ST_NO_REQ state.
            else
              begin
                NextSmTSMState   = `ST_NO_REQ;
                NextSMBUSREQ     = 1'b0;
                NextBeatCount    = 5'b00000;
                NextIDCYRead     = 4'b0000;
                NextAhbWideRdReg = 3'b000;
                if (SMClockEn == 1'b0)
                  NextClkStpd   = 1'b1;
                else
                  NextClkStpd   = 1'b0;
              end
          end
      end

    default :
      ;
  endcase
end // p_MemTSMComb

// -----------------------------------------------------------------------------
// Logic to generate SleepModeReg signal.
// This signal is set when BUSY is registered. This signal is very useful in
// freezing the Memory signals if the BurstRead counter had expired.
// OR comeback with the WaitRdCyc again when this signal dies down, because
// reloading of the BurstRead counter will happen only when SleepMode signal
// dies down.
// -----------------------------------------------------------------------------
always @(BUSYCYC or SleepModeReg)
begin : p_SleepModeComb
   NextSleepModeReg = SleepModeReg;
  if ((BUSYCYC == 1'b1) && (SleepModeReg == 1'b0))
    NextSleepModeReg = 1'b1;
  else if (BUSYCYC == 1'b0)
    NextSleepModeReg = 1'b0;
end // p_SleepModeComb

// -----------------------------------------------------------------------------
// Logic to generate SleepMode signal.
// This is nothing but the BUSYCYC extended by 1 SMMEMCLK after it dies down.
// -----------------------------------------------------------------------------
assign SleepMode       = BUSYCYC;
  
// -----------------------------------------------------------------------------
// Logic to generate ContWithBrst signal.
// This signal is useful in continuing with Burst write transfers for
// Synchronous Memories.
// -----------------------------------------------------------------------------
always @(ContWithBrst or iHsizeEqMWidthWr or WRITECYC or HtranRegCont or
         NewBurst or HtransMemBuf1 or UseSecBuf or WriteSt)
begin : p_ContBrstComb
  NextContWithBrst = ContWithBrst;
  if ((iHsizeEqMWidthWr == 1'b1) && (WRITECYC == 1'b1) &&
      (ContWithBrst == 1'b0) && (HtranRegCont == `HTRANS_SEQ) &&
      (NewBurst == 1'b1) && (WriteSt == 1'b0) && (UseSecBuf == 1'b0))
    NextContWithBrst = 1'b1;
  else if (HtransMemBuf1 == `HTRANS_SEQ)
    NextContWithBrst = 1'b0;
end // p_ContBrstComb

// -----------------------------------------------------------------------------
// Logic to generate MemoryRdSt signal.
// -----------------------------------------------------------------------------
assign MemoryRdSt       = ((ReadSt == 1'b1) || (BurstReadSt == 1'b1) ||
                           (((WaitAssrtSt == 1'b1) ||
                             (iWaitDeAssrtSt == 1'b1)) &&
                            (DelSmOEnMC == 1'b0))) ? 1'b1 : 1'b0;


// -----------------------------------------------------------------------------
// Logic to generate MemoryWrSt signal.
// -----------------------------------------------------------------------------
assign MemoryWrSt       = ((WriteSt == 1'b1) || (iBurstWriteSt == 1'b1) ||
                           (WriteProg == 1'b1)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Registering all Next state signals
// -----------------------------------------------------------------------------
always @(posedge SMMEMCLK or negedge HRESETn)
begin : p_MemRegSeq
  if (HRESETn == 1'b0)
    begin
      SmTSMState       <= `ST_NO_REQ;
      iSmCSTSM         <= 1'b1;
      iSmOEnMC         <= 1'b1;
      iWaitRdCycVer    <= 1'b1;
      iWaitWrCycVer    <= 1'b1;
      iWaitWrCycDup    <= 1'b1;
      iWaitWrCycAhb    <= 1'b1;
      iSmAddrTSM       <= 26'b00000000000000000000000000;
      iSMADDRMC        <= 26'b00000000000000000000000000;
      iSMWENMC         <= 1'b1;
      iSMADDRVALIDMC   <= 1'b1;
      iSMBAAMC         <= 1'b1;
      WstLongRdCnt     <= 5'b00000;
      WstBrstRdCnt     <= 5'b00000;
      WstWrCnt         <= 5'b00000;
      WstWrEnCnt       <= 4'b0000;
      WstOEnCnt        <= 4'b0000;
      BeatCount        <= 5'b00000;
      SleepModeReg     <= 1'b0;
      IDCYRead         <= 4'b0000;
      IdcyCount        <= 4'b0000;
      AhbWideRdReg     <= 3'b000;
      iWriteBeatCnt    <= 3'b000;
      DelSMWENMC       <= 1'b0;
      iToggle          <= 1'b0;
      HselMemBufWr     <= 8'b00000000;
      HburstMemBufWr   <= 3'b000;
      iMWWr            <= 2'b00;
      SMBLSPolWr       <= 1'b0;
      iHsizeMemBufWr   <= 2'b00;
      iHsizeEqMWidthWr <= 1'b0;
      iAhbWiderWr      <= 1'b0;
      iAhbNarrowWr     <= 1'b0;
      iRBLEWr          <= 1'b0;
      WriteProg        <= 1'b0;
      DelSmOEnMC       <= 1'b0;
      iWaitEnReg       <= 1'b0;
      iSyncEnWriteReg  <= 1'b0;
      iBMWriteReg      <= 1'b0;
      BIWriteEnReg     <= 1'b0;
      BurstLenWrReg    <= 2'b00;
      AddrValWrEnReg   <= 1'b0;
      WSTWRReg         <= 5'b00000;
      WSTWENReg        <= 4'b0000;
      SmBurstWaitReg   <= 1'b1;
      DelSmBurstWait   <= 1'b1;
      iSMBUSREQ        <= 1'b0;
      StopBurst        <= 1'b0;
      ContWithBrst     <= 1'b0;
      DelSmCSTSM       <= 1'b1;
      iClkStpd         <= 1'b1;
      DelAhbWideWrCnt  <= 3'b000;
      SyncWtOnMCLK     <= 1'b1;
      NewBrstOccrd     <= 1'b0;
      iSMCSMC          <= 8'b00000000;
      iSMCSMCn         <= 8'b11111111;
      iSMDATAENMCn     <= 4'b1111;
      iSMBLSMCn        <= 4'b1111;
      iAsynAxs         <= 1'b1;
      Stop2WtWrCyc     <= 1'b0;
      iWBstIntrptd     <= 1'b0;
      FirstSyncWt      <= 1'b0;
      XtraTxr          <= 1'b0;
      DelWaitWrCycVer  <= 1'b1;
      iTxrB4BsyAccptd   <= 1'b0;
      DelUseSecBuf     <= 1'b0;
    end
  else
    begin
      SmTSMState       <= NextSmTSMState;
      iSmCSTSM         <= NextSmCSTSM;
      iSmOEnMC         <= NextSmOEn;
      iWaitRdCycVer    <= NextWaitRdCycVer;
      iWaitWrCycVer    <= NextWaitWrCycVer;
      iWaitWrCycDup    <= NextWaitWrCycDup;
      iWaitWrCycAhb    <= NextWaitWrCycAhb;
      iSmAddrTSM       <= NextSmAddrTSM;
      iSMADDRMC        <= NextSMADDRMC;
      iSMWENMC         <= NextSmWrEn;
      iSMADDRVALIDMC   <= NxtSMADDRVALIDMC;
      iSMBAAMC         <= NextSMBAAMC;
      WstLongRdCnt     <= NextWstLongRdCnt;
      WstBrstRdCnt     <= NextWstBrstRdCnt;
      WstWrCnt         <= NextWstWrCnt;
      WstWrEnCnt       <= NextWstWrEnCnt;
      WstOEnCnt        <= NextWstOEnCnt;
      BeatCount        <= NextBeatCount;
      SleepModeReg     <= NextSleepModeReg;
      IDCYRead         <= NextIDCYRead;
      AhbWideRdReg     <= NextAhbWideRdReg;
      IdcyCount        <= NextIdcyCount;
      iWriteBeatCnt    <= NextWriteBeatCnt;
      DelSMWENMC       <= iSMWENMC;
      iToggle          <= NextToggle;
      HselMemBufWr     <= NextHselMemBufWr;
      HburstMemBufWr   <= NextHburstMemBufWr;
      iMWWr            <= NextMWWr;
      iHsizeMemBufWr   <= NxtHsizeMemBufWr;
      iHsizeEqMWidthWr <= NextHsizeEqMW;
      iAhbWiderWr      <= NextAhbWiderWr;
      iAhbNarrowWr     <= NextAhbNarrowWr;
      iRBLEWr          <= NextRBLEWr;
      SMBLSPolWr       <= NextSMBLSPolWr;
      WriteProg        <= NextWriteProg;
      DelSmOEnMC       <= iSmOEnMC;
      iWaitEnReg       <= NextWaitEnReg;
      iSyncEnWriteReg  <= NextSyncEnWr;
      iBMWriteReg      <= NextBMWriteReg;
      BIWriteEnReg     <= NextBIWriteEnReg;
      BurstLenWrReg    <= NextBurstLenWr;
      AddrValWrEnReg   <= NextAddrValWrReg;
      WSTWRReg         <= NextWSTWRReg;
      WSTWENReg        <= NextWSTWENReg;
      SmBurstWaitReg   <= SmBurstWtFbClk;
      DelSmBurstWait   <= SyncWtOnMCLK;
      iSMBUSREQ        <= NextSMBUSREQ;
      StopBurst        <= NextStopBurst;
      ContWithBrst     <= NextContWithBrst;
      DelSmCSTSM       <= iSmCSTSM;
      iClkStpd         <= NextClkStpd;
      DelAhbWideWrCnt  <= AhbWideWrCnt;
      SyncWtOnMCLK     <= SyncWtSingle;
      NewBrstOccrd     <= NextNewBrstOccrd;
      iSMCSMC          <= NextSMCSMC;
      iSMCSMCn         <= NextSMCSMCn;
      iSMDATAENMCn     <= NextSMDATAENMCn;
      iSMBLSMCn        <= NextSMBLSMCn;
      iAsynAxs         <= NextAsynAxs;
      Stop2WtWrCyc     <= NextStop2WtWrCyc;
      iWBstIntrptd     <= NextWBstIntrptd;
      FirstSyncWt      <= NextFirstSyncWt;
      XtraTxr          <= NextXtraTxr;
      DelWaitWrCycVer  <= WaitWrCycVerAnd;
      iTxrB4BsyAccptd   <= NextTxrB4BsyAccptd;
      DelUseSecBuf     <= UseSecBuf;
    end
end // p_MemRegSeq

  
// synopsys translate_off
// ----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// ----------------------------------------------------------------------------

reg [4:0] Concat;

// Protocol checkers can be used for debugging purposes.
always @(SmTSMState)
begin : p_IllegalProgComb
  Concat = {1'b0, WSTWEN};
  if (SmTSMState == `ST_WRITE)
    begin
      if (WSTWR < Concat)
        $display($time," Warning: WSTWEN is greater than WSTWR \n %m");

      if ((SyncEnWrite == 1'b1) && (WaitEn == 1'b1))
        $display($time," Warning: Synchronous devices is programmed for Wait",
                       " Enabled Transfer \n %m");
    end

  Concat = {1'b0, WSTOEN1};
  if (SmTSMState == `ST_READ)
    begin
      if (WSTRD1 < Concat)
        $display($time," Warning: WSTOEN1 is greater than WSTRD1 \n %m");

      if ((SyncEnRead1 == 1'b1) && (WaitEn == 1'b1))
        $display($time," Warning: Synchronous devices is programmed for Wait",
                       " Enabled Transfer \n %m");
    end
end // p_IllegalProgComb

// ----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// ----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
