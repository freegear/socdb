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
// File Name              : SsmcAhbSlvMemIf.v.rca
// File Revision          : 1.27
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Provides CPU memory access to the SSMC Controller
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SsmcParams.v"

// -----------------------------------------------------------------------------

module SsmcAhbSlvMemIf (
// Inputs
                        HCLK,
                        HRESETn,
                        HADDRSMC,
                        HTRANSSMC,
                        HWRITESMC,
                        HSIZESMC,
                        HBURSTSMC,
                        HWDATASMC,
                        HSELSMC,
                        HREADYINSMC,
                        WaitWrCycVer,
                        WaitWrCycDup,
                        WaitWrCycAhb,
                        ClockRatio,
                        WaitRdCyc,
                        WaitRdCycVer,
                        SmCSTSM,
                        DelSmCSTSM,
                        SmDataInFbClk,
                        HsizeEqMWidthWr,
                        AhbWiderWr,
                        AhbNarrowWr,
                        nSmBurstWaitReg,
                        MW1,
                        SMBLSPol1,
                        BIWriteEn1,
                        BMWrite1,
                        SyncEnRead1,
                        SyncEnWrite1,
                        BurstLenRead1,
                        BurstLenWrite1,
                        AddrValWriteEn1,
                        WP1,
                        RBLE1,
                        WaitEn1,
                        WaitPol1,
                        WSTWR1,
                        WSTWEN1,
                        IDCYC1,
                        InitSt,
                        BurstWriteSt,
                        TurnAroundSt,
                        WaitTxrOnBusSt,
                        WaitDeAssrtSt,
                        CancelWaitSt,
                        MemoryWrSt,
                        MemoryRdSt,
                        Toggle,
                        SmAddrTSM,
                        BIGENDIAN,
                        WaitEnReg,
                        BMWriteReg,
                        SyncEnWriteReg,
                        WriteBeatCnt,
                        WBstIntrptd,
                        TxrB4BsyAccptd,
                        SlowClkM,
// Outputs
                        HREADYOUTSMC,
                        HRESPSMC,
                        HRDATASMC,
                        UseSecBuf,
                        HtranRegCont,
                        HtransMemBuf1,
                        HsizeEqMWidth,
                        AhbWider,
                        AhbNarrow,
                        MemWrReq,
                        MemRdReq,
                        TurnAround,
                        NewBurst,
                        AhbCount,
                        WaitToutErr,
                        NextValByteLane0,
                        NextValByteLane1,
                        NextValByteLane2,
                        NextValByteLane3,
                        BUSYCYC,
                        IDLECYC,
                        WRITECYC,
                        AddrBuf1,
                        AddrBuf,
                        HwdataBuf,
                        HsizeMemBuf1,
                        HsizeMemBuf,
                        HburstMemBuf,
                        HselMemBuf1,
                        HselMemBuf,
                        AhbWideRdCnt,
                        AhbWideWrCnt,
                        AddrNotAligned,
                        MW,
                        SMBLSPol,
                        BMWrite,
                        SyncEnWrite,
                        BurstLenWrite,
                        AddrValidWriteEn,
                        BIWriteEn,
                        RBLE,
                        WaitEn,
                        WaitPol,
                        WSTWR,
                        WSTWEN,
                        IDCYC
                        );

// Inputs
input         HCLK;             // AHB Bus Clock
input         HRESETn;          // AHB system level Reset
input  [25:0] HADDRSMC;         // The address bus input from AHB for Memory
                                // accesses
input   [1:0] HTRANSSMC;        // Indicates current transfer type for Memory
                                // accesses
input         HWRITESMC;        // Indicates direction of transfer (R/W) for
                                // Memory accesses
input   [2:0] HSIZESMC;         // Transfer size indication for Memory
                                // accesses
input   [2:0] HBURSTSMC;        // The burst transfer information from AHB for
                                // Memory accesses
input  [31:0] HWDATASMC;        // Write data bus input from AHB for Memory
                                // accesses
input   [7:0] HSELSMC;          // Select signal for Memory transfer to
                                // SSMCCore. One select line for each Memory
                                // Bank
input         HREADYINSMC;      // Transfer completion input signal
input         WaitWrCycVer;     // Memory device write completion signal
input         WaitWrCycDup;     // Memory device write completion signal when
                                // Wait Transfer is pipelined
input         WaitWrCycAhb;     // Memory device write completion signal when
                                // Synchronous Transfer is pipelined
input   [1:0] ClockRatio;       // Indicates ratio of Memory Clock with
                                // respect to HCLK
input         WaitRdCyc;        // Memory device read completion signal
input         WaitRdCycVer;     // Version of WaitRdCyc
input         SmCSTSM;          // Chip Select Assertion
input         DelSmCSTSM;       // Delayed version of SmCSTSM
input  [31:0] SmDataInFbClk;    // Data for Memory Banks from Pad interface
input         HsizeEqMWidthWr;  // Indication that AHB and Memory are of same
                                // width
input         AhbWiderWr;       // Indication that AHB Width is greater than
                                // Memory Width
input         AhbNarrowWr;      // Indication that AHB Width is narrower than
                                // Memory Width
input         nSmBurstWaitReg;  // Registered nSMBURSTWAIT
input   [1:0] MW1;              // 1st level registered memory width bits
                                // selection from one of the bank registers
input         SMBLSPol1;        // 1st level registered memory Byte lane
                                // polarity bit from one of the bank registers
input         BIWriteEn1;       // Indication that SMBAA active during
                                // Synchronous Burst Write access, 1st level
                                // buffered
input         BMWrite1;         // 1st level Burst Mode Write
input         SyncEnRead1;      // 1st level Sync burst Mode read
input         SyncEnWrite1;     // 1st level Sync burst Mode Write
input   [1:0] BurstLenRead1;    // 1st level Burst transfer length, by Burst
                                // devices for Read
input   [1:0] BurstLenWrite1;   // 1st level Burst transfer length, by Burst
                                // devices for Write
input         AddrValWriteEn1;  // 1st level SMADDRVALID enable during Write
input         WP1;              // 1st level Write protection
input         RBLE1;            // 1st level Byte lane enable
input         WaitEn1;          // 1st level Wait Enable indication
input         WaitPol1;         // 1st level Indication of the polarity of
                                // SMWAIT
input   [4:0] WSTWR1;           // 1st level Write access count
input   [3:0] WSTWEN1;          // 1st level Delay value for the assertion of
                                // the WEN and nSMCS
input   [3:0] IDCYC1;           // 1st level Count value for the turnaround
                                // cycles
input         InitSt;           // Indication that Memory SM is in ST_NO_REQ
                                // State
input         BurstWriteSt;     // Indication that Memory SM is in BURSTWRITE
                                // State
input         TurnAroundSt;     // Indication that Memory SM is in TURNAROUND
                                // State
input         WaitTxrOnBusSt;   // Indication that Memory SM is in
                                // WAITTXRONBUS State
input         WaitDeAssrtSt;    // Indication that Memory SM is in
                                // WAITDEASSERTED State
input         CancelWaitSt;     // Indication that Memory SM is in CANCELWAIT
                                // State
input         MemoryWrSt;       // Indication that Memory TSM is in Write
                                // state
input         MemoryRdSt;       // Indication that Memory TSM is in Read state
input         Toggle;           // Indication of State switching when SM is
                                // waiting for new AHB Bus access
input   [1:0] SmAddrTSM;        // External Memory Address Bus
input         BIGENDIAN;        // Type of endianness of the system
input         WaitEnReg;        // Wait Enable signal registered when write
                                // begins.
input         BMWriteReg;       // Burst Mode Write indication registered when
                                // write begins
input         SyncEnWriteReg;   // Synchronous Write Enable signal registered
                                // when write begins
input   [2:0] WriteBeatCnt;     // Counter used for carrying out Burst Write
input         WBstIntrptd;
input         TxrB4BsyAccptd;
input         SlowClkM;         // Slow clock indicator to HCLK side

// Outputs
output        HREADYOUTSMC;     // Indicates completion of Memory accesses
output  [1:0] HRESPSMC;         // SSMCCore response output, for Memory
                                // accesses
output [31:0] HRDATASMC;        // Data for AHB from Memory Banks
output        UseSecBuf;        // Indication to use second level buffered
                                // resources during Write
output  [1:0] HtranRegCont;     // HTRANS registered on every clock
output  [1:0] HtransMemBuf1;    // Level1 Buffer to hold HTRANSSMC
output        HsizeEqMWidth;    // Indication that AHB and Memory are of same
                                // width
output        AhbWider;         // Indication that AHB Width is greater than
                                // Memory Width
output        AhbNarrow;        // Indication that AHB Width is narrower than
                                // Memory Width
output        MemWrReq;         // Signal indicating the write transfer has
                                // been initiated
output        MemRdReq;         // Signal indicating the read transfer being
                                // initiated
output        TurnAround;       // TurnAround indication for R->W and R->R for
                                // diff memory bank
output        NewBurst;         // Indication that Burst Broken
output  [4:0] AhbCount;         // Indication of number of Memory transfer
                                // requested by AHB
output        WaitToutErr;      // Waited Access Error indication
output        NextValByteLane0; // Indication that Byte Lane0 is valid during
                                // write operation
output        NextValByteLane1; // Indication that Byte Lane1 is valid during
                                // write operation
output        NextValByteLane2; // Indication that Byte Lane2 is valid during
                                // write operation
output        NextValByteLane3; // Indication that Byte Lane3 is valid during
                                // write operation
output        BUSYCYC;          // Indication that SM is in ST_MEM_BUSY state
output        IDLECYC;          // Indication that SM is in ST_MEM_NOT_SEL
                                // state
output        WRITECYC;         // Indication that SM is in ST_MEM_WRITE state
output [25:0] AddrBuf1;         // Level1 Buffer to hold HADDRSMC
output [25:0] AddrBuf;          // Buffered AHB Address
output [31:0] HwdataBuf;        // Buffered AHB Data
output  [1:0] HsizeMemBuf1;     // Level1 buffer to hold HSIZESMC
output  [1:0] HsizeMemBuf;      // Buffered AHB HSIZESMC
output  [2:0] HburstMemBuf;     // Buffered HBURSTSMC
output  [7:0] HselMemBuf1;      // 1st level registered HSELSMC
output  [7:0] HselMemBuf;       // Buffered HSELSMC
output  [2:0] AhbWideRdCnt;     // Counter which indicates number of Memory
                                // accesses required for one AHB Read transfer
output  [2:0] AhbWideWrCnt;     // Counter for number of Memory Write accesses
                                // required for 1 AHB Write transfer
output        AddrNotAligned;   // Indication that starting address is not
                                // aligned to Memory Width
output  [1:0] MW;               // The memory width bits selection from one of
                                // the bank registers
output        SMBLSPol;         // Byte lane polarity bit selection from one of
                                // the bank registers
output        BMWrite;          // Burst Mode Write indication
output        SyncEnWrite;      // Synchronous burst Mode Write
output  [1:0] BurstLenWrite;    // Burst transfer length, supported by Burst
                                // devices for Write
output        AddrValidWriteEn; // SMADDRVALID enable during Write
output        BIWriteEn;        // Indication that SMBAA active during
                                // Synchronous Burst Write access
output        RBLE;             // Byte lane enabled device of SMWAIT
output        WaitEn;           // Wait Enable indication
output        WaitPol;          // Indication of the Wait polarity
output  [4:0] WSTWR;            // Single Write access count for the bank
                                // targeted currently
output  [3:0] WSTWEN;           // Delay value for the assertion of the WEN
                                // and nSMCS signals
output  [3:0] IDCYC;            // Count value for the turnaround cycles




// Inputs
  wire        HCLK;             // AHB Bus Clock
  wire        HRESETn;          // AHB system level Reset
  wire [25:0] HADDRSMC;         // The address bus input from AHB for Memory
                                // accesses
  wire  [1:0] HTRANSSMC;        // Indicates current transfer type for Memory
                                // accesses
  wire        HWRITESMC;        // Indicates direction of transfer (R/W) for
                                // Memory accesses
  wire  [2:0] HSIZESMC;         // Transfer size indication for Memory
                                // accesses
  wire  [2:0] HBURSTSMC;        // The burst transfer information from AHB for
                                // Memory accesses
  wire [31:0] HWDATASMC;        // Write data bus input from AHB for Memory
                                // accesses
  wire  [7:0] HSELSMC;          // Select signal for Memory transfer to
                                // SSMCCore. One select line for each Memory
                                // Bank
  wire        HREADYINSMC;      // Transfer completion input signal
  wire        WaitWrCycVer;     // Memory device write completion signal
  wire        WaitWrCycDup;     // Memory device write completion signal when
                                // Wait Transfer is pipelined
  wire        WaitWrCycAhb;     // Memory device write completion signal when
                                // Synchronous Transfer is pipelined
  wire  [1:0] ClockRatio;       // Indicates ratio of Memory Clock with
                                // respect to HCLK
  wire        WaitRdCyc;        // Memory device read completion signal
  wire        SmCSTSM;          // Chip Select Assertion
  wire        DelSmCSTSM;       // Delayed version of SmCSTSM
  wire [31:0] SmDataInFbClk;    // Data for Memory Banks from Pad interface
  wire        HsizeEqMWidthWr;  // Indication that AHB and Memory are of same
                                // width
  wire        AhbWiderWr;       // Indication that AHB Width is greater than
                                // Memory Width
  wire        AhbNarrowWr;      // Indication that AHB Width is narrower than
                                // Memory Width
  wire        nSmBurstWaitReg;  // Registered nSMBURSTWAIT
  wire  [1:0] MW1;              // 1st level registered memory width bits
                                // selection from one of the bank registers
  wire        SMBLSPol1;        // 1st level registered memory Byte lane
                                // polarity bit from one of the bank registers
  wire        BIWriteEn1;       // Indication that SMBAA active during
                                // Synchronous Burst Write access, 1st level
                                // buffered
  wire        BMWrite1;         // 1st level Burst Mode Write
  wire        SyncEnRead1;      // 1st level Sync burst Mode read
  wire        SyncEnWrite1;     // 1st level Sync burst Mode Write
  wire  [1:0] BurstLenRead1;    // 1st level Burst transfer length, by Burst
                                // devices for Read
  wire  [1:0] BurstLenWrite1;   // 1st level Burst transfer length, by Burst
                                // devices for Write
  wire        AddrValWriteEn1;  // 1st level SMADDRVALID enable during Write
  wire        WP1;              // 1st level Write protection
  wire        RBLE1;            // 1st level Byte lane enable
  wire        WaitEn1;          // 1st level Wait Enable indication
  wire        WaitPol1;         // 1st level Indication of the polarity of
                                // SMWAIT
  wire  [4:0] WSTWR1;           // 1st level Write access count
  wire  [3:0] WSTWEN1;          // 1st level Delay value for the assertion of
                                // the WEN and nSMCS
  wire  [3:0] IDCYC1;           // 1st level Count value for the turnaround
                                // cycles
  wire        InitSt;           // Indication that Memory SM is in ST_NO_REQ
                                // State
  wire        BurstWriteSt;     // Indication that Memory SM is in BURSTWRITE
                                // State
  wire        TurnAroundSt;     // Indication that Memory SM is in TURNAROUND
                                // State
  wire        WaitTxrOnBusSt;   // Indication that Memory SM is in
                                // WAITTXRONBUS State
  wire        WaitDeAssrtSt;    // Indication that Memory SM is in
                                // WAITDEASSERTED State
  wire        CancelWaitSt;     // Indication that Memory SM is in CANCELWAIT
                                // State
  wire        MemoryWrSt;       // Indication that Memory TSM is in Write
                                // state
  wire        MemoryRdSt;       // Indication that Memory TSM is in Read state
  wire        Toggle;           // Indication of State switching when SM is 
                                // waiting for new AHB Bus access
  wire  [1:0] SmAddrTSM;        // External Memory Address Bus
  wire        BIGENDIAN;        // Type of endianness of the system
  wire        WaitEnReg;        // Wait Enable signal registered when write
                                // begins.
  wire        BMWriteReg;       // Burst Mode Write indication registered when
                                // write begins
  wire        SyncEnWriteReg;   // Synchronous Write Enable signal registered
                                // when write begins
  wire  [2:0] WriteBeatCnt;     // Counter used for carrying out Burst Write
  wire        TxrB4BsyAccptd;
  wire        SlowClkM;         // Slow clock indicator to HCLK side

// Outputs
  wire        HREADYOUTSMC;     // Indicates completion of Memory accesses
  wire  [1:0] HRESPSMC;         // SSMCCore response output, for Memory
                                // accesses
  wire [31:0] HRDATASMC;        // Data for AHB from Memory Banks
  wire        UseSecBuf;        // Indication to use second level buffered
                                // resources during Write
  wire  [1:0] HtranRegCont;     // HTRANS registered on every clock
  wire  [1:0] HtransMemBuf1;    // Level1 Buffer to hold HTRANSSMC
  wire        HsizeEqMWidth;    // Indication that AHB and Memory are of same
                                // width
  wire        AhbWider;         // Indication that AHB Width is greater than
                                // Memory Width
  wire        AhbNarrow;        // Indication that AHB Width is narrower than
                                // Memory Width
  reg         MemWrReq;         // Signal indicating the write transfer has
                                // been initiated
  wire        MemRdReq;         // Signal indicating the read transfer being
                                // initiated
  wire        TurnAround;       // TurnAround indication for R->W and R->R for
                                // diff memory bank
  wire        NewBurst;         // Indication that Burst Broken
  reg   [4:0] AhbCount;         // Indication of number of Memory transfer
                                // requested by AHB
  wire        WaitToutErr;      // Waited Access Error indication
  wire        NextValByteLane0; // Indication that Byte Lane0 is valid during
                                // write operation
  wire        NextValByteLane1; // Indication that Byte Lane1 is valid during
                                // write operation
  wire        NextValByteLane2; // Indication that Byte Lane2 is valid during
                                // write operation
  wire        NextValByteLane3; // Indication that Byte Lane3 is valid during
                                // write operation
  wire        BUSYCYC;          // Indication that SM is in ST_MEM_BUSY state
  wire        IDLECYC;          // Indication that SM is in ST_MEM_NOT_SEL
                                // state
  wire        WRITECYC;         // Indication that SM is in ST_MEM_WRITE state
  wire [25:0] AddrBuf1;         // Level1 Buffer to hold HADDRSMC
  reg  [25:0] AddrBuf;          // Buffered AHB Address
  wire [31:0] HwdataBuf;        // Buffered AHB Data
  wire  [1:0] HsizeMemBuf1;     // Level1 buffer to hold HSIZESMC
  wire  [1:0] HsizeMemBuf;      // Buffered AHB HSIZESMC
  wire  [2:0] HburstMemBuf;     // Buffered HBURSTSMC
  wire  [7:0] HselMemBuf1;      // 1st level registered HSELSMC
  wire  [7:0] HselMemBuf;       // Buffered HSELSMC
  wire  [2:0] AhbWideRdCnt;     // Counter which indicates number of Memory
                                // accesses required for one AHB Read transfer
  wire  [2:0] AhbWideWrCnt;     // Counter for number of Memory Write accesses
                                // required for 1 AHB Write transfer
  wire        AddrNotAligned;   // Indication that starting address is not
                                // aligned to Memory Width
  wire  [1:0] MW;               // The memory width bits selection from one of
                                // the bank registers
  reg         SMBLSPol;         // Byte lane polarity bit selection from one of
                                // the bank registers
  reg         BMWrite;          // Burst Mode Write indication
  reg         SyncEnWrite;      // Synchronous burst Mode Write
  reg   [1:0] BurstLenWrite;    // Burst transfer length, supported by Burst
                                // devices for Write
  reg         AddrValidWriteEn; // SMADDRVALID enable during Write
  reg         BIWriteEn;        // Indication that SMBAA active during
                                // Synchronous Burst Write access
  reg         RBLE;             // Byte lane enabled device of SMWAIT
  wire        WaitEn;           // Wait Enable indication
  reg         WaitPol;          // Indication of the Wait polarity
  reg   [4:0] WSTWR;            // Single Write access count for the bank
                                // targeted currently
  reg   [3:0] WSTWEN;           // Delay value for the assertion of the WEN
                                // and nSMCS signals
  reg   [3:0] IDCYC;            // Count value for the turnaround cycles


// -----------------------------------------------------------------------------
//
//                               SsmcAhbSlvMemIf
//                               ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//           It consists of the AHB response generation logic, AHB Slave State
//           Machine for Memory accesses, Read and Write request generation.
//           Counters when AHB Width does not match Memory Width. Read Data Path
//           logic.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        iBUSYCYC;
// Internal signal of BUSYCYC

wire        iIDLECYC;
// Internal signal of IDLECYC

wire        iWRITECYC;
// Internal signal of WRITECYC

wire        READCYC;
// Indication that SM is in ST_MEM_READ state

wire        iNewBurst;
// Internal signal of NewBurst

wire        ErrCond;
// Indication of Error condition

wire        HselSmcOr;
// OR'ed signal of HSELSMC[7:0]

wire        iAhbWider;
// Internal signal of AhbWider

wire        iAhbNarrow;
// Internal signal of AhbNarrow

wire        iHsizeEqMWidth;
// Internal signal of HsizeEqMWidth

wire        iAddrNotAligned;
// Indication that starting address is not aligned to Memory Width

wire        NseqRdCyc;
// NewBurst indication by registering HTRANSSMC when WaitRdCyc is de-asserted

wire        WriteMask;
// Mask for Write request

wire        MemRdMask;
// Mask for Read request

wire        MemRdMaskPulse;
// Pulse which indiactes that BUSY was inserted for last beat, for the case when
// AHB is narrower than Memory width

wire        WaitEnWrFirstCyc;
// Indication to load Write related counters, when WaitEn is asserted for Write

wire        NewBurstComb;
// Combinational signal indicating New Burst.

wire        TurnAroundComb;
// Turnaround indication generated combinationally

wire        iMemRdReq;
// Internal signal of MemRdReq

wire        WaitWrCycAhbAnd;
// WaitWrCycAhb anded with SlowClkM

reg  [31:0] HwdataBufInt;
// Internal HwdataBuf before the Final Mux

wire [31:0] HwdataBufMux;
// Write data when 2nd buffer not used

reg  [31:0] HwdataBufReg;
// Write data from second buffer

wire        UseSecBufExtd;

wire        extracond;

wire        extracond1;
  
// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         DelBUSYCYC;
// 1 HCLK Delayed BUSYCYC

reg         DelIDLECYC;
// 1 HCLK Delayed IDLECYC

reg         DelWRITECYC;
// 1 HCLK delayed iWRITECYC

reg         DelREADCYC;
// 1 HCLK delayed READCYC

reg   [1:0] iHRESPSMC;
// Internal signal of HRESPSSMC

reg   [1:0] NextHRESPSMC;
// D-input of iHRESPSMC register

reg         iHREADYOUTSMC;
// Internal signal of HREADYOUTSMC

reg         NextHREADYOUTSMC;
// D-input of iHREADYOUTSMC register

reg  [25:0] iAddrBuf1;
// Internal signal of AddrBuf1

reg  [25:0] NextAddrBuf1;
// D-input of iAddrBuf1 register

reg  [25:0] AddrBuf2;
// Level2 Buffer to hold AddrBuf1

reg  [25:0] NextAddrBuf2;
// D-input of the AddrBuf2 register

reg   [4:0] SmMemSlaveState;
// State vector of Slave State Machine

reg   [4:0] NextSmMemSlaveSt;
// D-input of SmMemSlaveState register

reg   [1:0] iHtransMemBuf1;
// Internal signal of HtransMemBuf1

reg   [1:0] NxtHtransMemBuf1;
// D-input of the iHtransMemBuf1 register

reg   [2:0] iHburstMemBuf;
// Internal signal of HburstMemBuf

reg   [2:0] NxtHburstMemBuf;
// D-input of the iHburstMemBuf register

reg   [1:0] iHsizeMemBuf;
// Internal signal of HsizeMemBuf

reg   [2:0] iHsizeMemBuf1;
// Internal signal of HsizeMemBuf1

reg   [2:0] NextHsizeMemBuf1;
// D-input of the iHsizeMemBuf1 register

reg   [1:0] HsizeMemBuf2;
// Level2 buffer to hold HsizeMemBuf1

reg   [1:0] NextHsizeMemBuf2;
// D-input of the HsizeMemBuf2 register

reg         HSizeErrMem;
// HSIZE Error indication during Memory transfers

reg         iWaitToutErr;
// Internal signal of WaitToutErr

reg         WriteProtErr;
// Write protect Error indication

reg         WaitWrCycMux;
// Indication to AHB SM to wait the Write transfer

reg         DelWaitWrCycMux;
// 1 HCLK Delayed WaitWrCycMux

reg         WaitRdCycMux;
// Indication to AHB SM to wait the Read transfer

reg   [7:0] iHselMemBuf;
// Internal signal of HselMemBuf

reg   [7:0] iHselMemBuf1;
// 1st level registered HSELSMC

reg   [7:0] NextHselMemBuf1;
// D-Input of iHselMemBuf1 register

reg   [7:0] DelHselMemBuf1;
// 1 HCLK Delayed HselMemBuf1

reg   [7:0] HselMemBuf2;
// 2nd level buffer to hold HselMemBuf1

reg   [7:0] NextHselMemBuf2;
// D-Input of HselMemBuf2 register

reg         MemRdMaskReg;
// Mask for Read request - Intermediate form

reg         NextMemRdMaskReg;
// D-input of MemRdMask register

reg         DelMemRdMaskReg;
// 1HCLK delayed version of MemRdMaskReg

reg         MemRdBusy;
// Mask for Read request when BUSY is inserted for last beat, for the case when
// AHB is narrower than Memory width

reg         NextMemRdBusy;
// D-input of MemRdBusy register

reg         AddrNotAlignComb;
// Pulse wide signal indicating Address is not aligned

reg         AddrNotAlignReg;
// Register to hold AddrNotAlignComb till it is seen by other logic in Memory
// clock domain

reg         NextAddrNotAlign;
// D-Input of AddrNotAlignReg

reg   [1:0] iHtranRegCont;
// Internal signal of HtranRegCont

reg   [2:0] iAhbWideRdCnt;
// Internal signal of AhbWideRdCnt

reg   [2:0] NextAhbWideRdCnt;
// D-input of iAhbWideRdCnt register

reg   [2:0] AhbLessRdCnt;
// Counter which indicates no of AHB Read required for 1 Memory Accesses

reg   [2:0] NextAhbLessRdCnt;
// D-input of AhbLessRdCnt register

reg   [2:0] DelAhbLessRdCnt;
// 1 HCLK Delayed Counter

reg         WriteRqBuf;
// Write request buffered

reg         NextWriteRqBuf;
// D-input of WriteRqBuf register

reg         DelWriteMask;
// 1 HCLK delayed WriteMask

reg         WriteMaskComb;
// Combinational Mask signal, which is active till WriteMaskBuf is set

reg         WriteMaskBuf;
// Buffered Mask for Write

reg         NextWriteMaskBuf;
// D-input of WriteMaskBuf register

reg   [2:0] AhbLessWrCnt;
// Counter for number of AHB Write accesses required for 1 Memory Write transfer

reg   [2:0] NextAhbLessWrCnt;
// D-input of AhbLessWrCnt register

reg   [2:0] iAhbWideWrCnt;
// Internal signal of AhbWideWrCnt

reg   [2:0] NextAhbWideWrCnt;
// D-input of iAhbWideWrCnt register

reg         iUseSecBuf;
// Internal signal of UseSecBuf

reg         NextUseSecBuf;
// D-input of iUseSecBuf register

wire        WaitWrFirstCyc;
// Indication to de-assert WaitWrCycMux, when WaitEn is de-asserted for Write

reg         WtWrFrstCycComb;
// Same as WaitWrFirstCyc signal when clock ratio is 1:1

reg         WtWrFrstReg;
// Registering of WtWrFrstCycComb signal when clock ratios are different

reg         NextWtWrFrstReg;
// D-Input of WtWrFrstReg

reg         SMBLSPol2;
// 2nd level registered signal of SMBLSPol

reg         NextSMBLSPol2;
// D-Input of SMBLSPol2 register

reg   [1:0] iMW;
// Internal signal of MW

reg   [1:0] MW2;
// 2nd level registered signal of MW

reg   [1:0] NextMW2;
// D-Input of MW2 register

reg         BMWrite2;
// 2nd level registered signal of BMWrite

reg         NextBMWrite2;
// D-Input of BMWrite2 register

reg         SyncEnWr2;
// 2nd level registered signal of SyncEnWr

reg         NextSyncEnWr2;
// D-Input of SyncEnWr2 register

reg   [1:0] BurstLenWr2;
// 2nd level registered signal of BurstLenWr

reg   [1:0] NextBurstLenWr2;
// D-Input of BurstLenWr2 register

reg         AddrValWrEn2;
// 2nd level registered signal of AddrValWrEn

reg         NextAddrValWrEn2;
// D-Input of AddrValWrEn2 register

reg         BIWriteEn2;
// 2nd level registered signal of BIWriteEn

reg         NextBIWriteEn2;
// D-Input of BIWriteEn2 register

reg         WP;
// Write Protect Indication

reg         WP2;
// 2nd level registered signal of WP

reg         NextWP2;
// D-Input of WP2 register

reg         RBLE2;
// 2nd level registered signal of RBLE

reg         NextRBLE2;
// D-Input of RBLE2 register

reg         WaitEn2;
// 2nd level registered signal of WaitEn

reg         NextWaitEn2;
// D-Input of WaitEn2 register

reg         iWaitEn;
// Internal signal of WaitEn

reg         WaitPol2;
// 2nd level registered signal of WaitPol

reg         NextWaitPol2;
// D-Input of WaitPol2 register

reg   [4:0] WSTWR2;
// 2nd level registered signal of WSTWR

reg   [4:0] NextWSTWR2;
// D-Input of WSTWR2 register

reg   [3:0] WSTWEN2;
// 2nd level registered signal of WSTWEN

reg   [3:0] NextWSTWEN2;
// D-Input of WSTWEN2 register

reg   [3:0] IDCYC2;
// 2nd level registered signal of IDCYC

reg   [3:0] NextIDCYC2;
// D-Input of IDCYC2 register

reg  [31:0] HwdataBuf1;
// 1st level buffered signal of HWDATASMC

reg  [31:0] NextHwdataBuf1;
// D-Input of HwdataBuf1 register

reg  [31:0] HwdataBuf2;
// 2nd level registered signal of HwdataBuf1

reg  [31:0] NextHwdataBuf2;
// D-Input of HwdataBuf2 register

reg         DelHreadyOut;
// Delayed iHREADYOUTSMC

reg         ValByteLane0;
// Byte Lane0 is valid during write operation

reg         iNxtValByteLane0;
// D-Input of iValByteLane0 register

reg         ValByteLane1;
// Byte Lane1 is valid during write operation

reg         iNxtValByteLane1;
// D-Input of ValByteLane1 register

reg         ValByteLane2;
// Byte Lane2 is valid during write operation

reg         iNxtValByteLane2;
// D-Input of ValByteLane2 register

reg         ValByteLane3;
// Byte Lane3 is valid during write operation

reg         iNxtValByteLane3;
// D-Input of ValByteLane3 register

reg         TurnArndReg;
// TurnAround indication is registered so that it is sustained till SlowClkM is
// high

reg         NextTurnArndReg;
// D-Input of TurnArndReg register

reg         NewBrstReg;
// New Burst indication is registered so that it is sustained till SlowClkM is
// high

reg         NextNewBrstReg;
// D-Input of NewBrstReg register

reg  [31:0] iHRDATASMC;
// Internal signal of HRDATASMC

reg  [31:0] NextHrdataSmc;
// D-Input of iHRDATASMC register

reg         AddrNotAlgnRd;
// Address not aligned for read accesses

reg         NextAddrAlgnRd;
// D-Input of AddrNotAlgnRd register

reg         DelSmBurstWait;
// Delayed nSmBurstWaitReg

reg         BurstPulse;
// Pulse when nSmBurstWaitReg is asserted

reg         DelWaitWrCycAhb;
// 1 HCLK Delayed WaitWrCycAhb

wire        WaitWrCycAhbMux;
// Mux to select between different sources of WaitWrCycAhb's

reg         WaitAssrtd;
// Indication that nSmBurstWaitReg is asserted and we have to use Pipelined data

reg         NextWaitAssrtd;
// D-Input of WaitAssrtd register

reg  [31:0] HwdataBuf3;
// 2nd level registered signal of HwdataBuf1

reg  [31:0] NextHwdataBuf3;
// D-Input of HwdataBuf3 register

reg         UseSecBufVer;
// Indication to use second level buffered information

reg         NextUseSecBufVer;
// D-Input of UseSecBufVer register

reg         BsyLstBt;
// Indication that Busy was inserted for the last beat of AhbLessRdCnt counter

reg         NextBsyLstBt;
// D-Input of BsyLstBt register

reg         ValWrBrstSt;
// 

reg         NextValWrBrstSt;
// 

reg   [3:0] Concat;
// Reg to hold the concatenation result of AHB Width and Memory Width

reg   [2:0] Temp;
// Temporray Variable

reg   [3:0] Temp8;
// Temporray Variable

reg   [4:0] Temp16;
// Temporray Variable

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
// Internal Signal Assignments
// -----------------------------------------------------------------------------
assign HREADYOUTSMC     = iHREADYOUTSMC;
assign HRESPSMC         = iHRESPSMC;
assign BUSYCYC          = iBUSYCYC;
assign NewBurst         = iNewBurst;
assign WaitToutErr      = iWaitToutErr;
assign HtranRegCont     = iHtranRegCont;
assign HburstMemBuf     = iHburstMemBuf;
assign MW               = iMW;
assign AhbWideWrCnt     = iAhbWideWrCnt;
assign AhbWideRdCnt     = iAhbWideRdCnt;
assign HselMemBuf       = iHselMemBuf;
assign HsizeMemBuf      = iHsizeMemBuf;
assign HsizeEqMWidth    = iHsizeEqMWidth;
assign AhbWider         = iAhbWider;
assign AhbNarrow        = iAhbNarrow;
assign IDLECYC          = iIDLECYC;
assign WRITECYC         = iWRITECYC;
assign NextValByteLane0 = iNxtValByteLane0;
assign NextValByteLane1 = iNxtValByteLane1;
assign NextValByteLane2 = iNxtValByteLane2;
assign NextValByteLane3 = iNxtValByteLane3;
assign HRDATASMC        = iHRDATASMC;
assign WaitEn           = iWaitEn;
assign MemRdReq         = iMemRdReq;
assign AddrNotAligned   = iAddrNotAligned;
assign HselMemBuf1      = iHselMemBuf1;
assign HtransMemBuf1    = iHtransMemBuf1;
assign AddrBuf1         = iAddrBuf1;
assign HsizeMemBuf1     = iHsizeMemBuf1[1:0];
assign UseSecBuf        = iUseSecBuf;

// -----------------------------------------------------------------------------
//                              Assignments
// -----------------------------------------------------------------------------
assign iIDLECYC         = SmMemSlaveState[0];
assign iBUSYCYC         = SmMemSlaveState[1];
assign iWRITECYC        = SmMemSlaveState[2];
assign READCYC          = SmMemSlaveState[3];
assign HselSmcOr        = HSELSMC[7] | HSELSMC[6] | HSELSMC[5] | HSELSMC[4] |
                          HSELSMC[3] | HSELSMC[2] | HSELSMC[1] | HSELSMC[0];

assign WaitWrCycAhbAnd  = ((WaitWrCycAhb == 1'b0) && (SlowClkM == 1'b1) &&
                           // Adding (HtranRegCont = HTRANS_SEQ) condition so
                           // that Memory need not burst if AHB does not
                           // continue with burst
                           (iHtranRegCont == `HTRANS_SEQ)) ? 1'b0 : 1'b1;

assign WaitWrCycAhbMux  = ((ClockRatio == 2'b01) || (ClockRatio == 2'b10)) ?
                                                         1'b1 : WaitWrCycAhbAnd;

// -----------------------------------------------------------------------------
//    A H B    S L A V E    S E L E C T    S T A T E    M A C H I N E
// -----------------------------------------------------------------------------
//
// Summary: State Machine to control the AHB Slave interface for Memory
//          accesses.
//
// Overview: This state machine will control the AHB slave interface for
//           Memory accesses.
//
// Summary State Description:
// ==========================
//
// ST_MEM_NOT_SEL: Memory Not Selected State.
// Description   : Default state when memory is not selected.
// Entry         : HselSmcOr is sampled de-asserted or if HTRANSSMC is sampled
//                 IDLE and the end of any given bus cycle.
// Exit          : When there is a read or write access.
// No change     : Until the HselSmcOr and HREADYINSMC is sampled asserted.
//
// ST_MEM_READ   : Memory Read State.
// Description   : Read access in progress.
// Entry         : When Memory read is initiated.
// Exit          : When read is completed and HTRANSSMC is sampled BUSY or IDLE
//                 at the end of given bus cycle OR when Write transfer is
//                 sampled asserted at the end of given bus cycle.
// No Change     : During read access(Until HREADYINSMC is sampled asserted).
//
// ST_MEM_WRITE  : Memory Write State.
// Description   : Write access in progress.
// Entry         : When Memory write is initiated.
// Exit          : When write is complete and HTRANSSMC is sampled BUSY or IDLE
//                 at the end of given bus cycle OR when Read transfer is
//                 sampled asserted at the end of given bus cycle.
// No Change     : During write access(Until HREADYINSMC is sampled asserted).
//
// ST_MEM_IDLE_RESP: BUSY Response State.
// Description     : Busy on AHB in progress.
// Entry           : When BUSY transfer is sampled asserted at the end of given
//                   bus cycle.
// Exit            : When there is a read or write access, Or IDLE is driven on
//                   AHB.
// No Change       : Until HTRANSSMC is changed to other than BUSY.
//
// ST_MEM_ERROR  : Memory Error State.
// Description   : Two Cycle Error response in progress.
// Entry         : Whenever Error condition is encountered.
// Exit          : When Two cycle Error response is completed.
// No Change     : Until Two cycle Error response is completed.
//
// Detailed Description:
// =====================
// The logic has a separate address buffer that latches in the address on the
// HADDRSMC lines at the end of every bus cycle. This latched address is used
// for further decoding. The data transfers from memory to the AHB bus occur
// only in the ST_MEM_READ state.
// The buffered address is decoded and if the access is a Write to memory a
// combinatorial decode of ST_MEM_WRITE state bit forms the MemWrReq (Write
// Request for Memory access) for the memory. The Writes to memory terminate
// with minimum of two-clock cycle response. If the Memory write is taking
// longer than two cycles to complete on the Memory side then a signal
// WaitWrCycMux will hold the HREADYOUTSMC signal de-asserted till the write is
// over.
// Whenever a read access is initiated with a NSEQ transfer on the SSMC, the SM
// always inserts a Wait state for the cycle. This Wait period is generally of
// only one clock but can be controlled with a signal "WaitRdCycMux" depending
// on the time it take for the source data to reach to HRDATASMC output
// flip-flops through a multiplexer that is controlled by the endianization
// logic. At the end of the Wait period the SM drives HREADYOUTSMC high with
// OKAY response. Whenever a read cycle is SEQ type the SM assumes that a valid
// data is present on HRDATASMC flip-flops and thus can ideally terminate the
// bus cycle with one clock response provided the source of data has not
// asserted the "WaitRdCycMux" signal. WaitRdCycMux signal is an indication to
// the AHB Memory SM, to assert HREADYOUTSMC. When the Read access on the
// Memory side is waited then this signal is asserted. SM asserts HREADYOUTSMC
// when it samples WaitRdCycMux de-asserted, with an HRESP_OKAY response.
// The SM enters the ST_MEM_ERROR state when there is an HRESP_ERROR access. The
// HRESP_ERROR access can happen on following conditions.
// a) During a transfer of size greater than 32-bits to external memory.
// b) If a write transfer is attempted to a Write-Protected Memory device.
// c) After an externally waited transfer has timed out.
// d) When an AHB master tries to initiate a new transfer in the WaitToutErr
//    case and the SMWAIT input is still in the asserted state due to the
//    previous transfer.
// In the above cases HRESPSMC is driven with ERROR response and two cycle
// ERROR response is driven on HREADYOUTSMC (i.e. First cycle HREADYOUTSMC is
// de-asserted and in second cycle it is asserted) line.
//
// -----------------------------------------------------------------------------
always @(SmMemSlaveState or iAddrBuf1 or HREADYINSMC or HselSmcOr or
         HTRANSSMC or HADDRSMC or WaitWrCycMux or WaitRdCycMux or HWRITESMC or
         iHREADYOUTSMC or iHRESPSMC or iWRITECYC or READCYC or ErrCond or
         iHtransMemBuf1 or iHburstMemBuf or iHsizeMemBuf1 or HSIZESMC or
         HBURSTSMC or iHselMemBuf1 or HSELSMC or WaitWrCycAhbMux or
         WaitRdCycVer or SlowClkM or SyncEnRead1 or iHsizeEqMWidth or
         iAhbNarrow)
begin : p_MemSMComb
  NextSmMemSlaveSt  = SmMemSlaveState;
  NextHREADYOUTSMC  = iHREADYOUTSMC;
  NextHRESPSMC      = iHRESPSMC;
  NxtHtransMemBuf1  = iHtransMemBuf1;
  NxtHburstMemBuf   = iHburstMemBuf;
  NextHsizeMemBuf1  = iHsizeMemBuf1;
  NextAddrBuf1      = iAddrBuf1;
  NextHselMemBuf1   = iHselMemBuf1;
  case (SmMemSlaveState)
    `ST_MEM_NOT_SEL, `ST_MEM_WRITE, `ST_MEM_READ :
      begin
        if (HREADYINSMC == 1'b1)
          begin
            if (HselSmcOr == 1'b1)
              begin
                NextHRESPSMC      = `HRESP_OKAY;
                NextAddrBuf1      = HADDRSMC;
                NxtHtransMemBuf1  = HTRANSSMC;
                NxtHburstMemBuf   = HBURSTSMC;
                NextHsizeMemBuf1  = HSIZESMC;
      
                case (HTRANSSMC)
                  `HTRANS_IDLE :
                    begin
                      NextSmMemSlaveSt = `ST_MEM_NOT_SEL;
                      NextHREADYOUTSMC = 1'b1;
                    end
      
                  `HTRANS_BUSY :
                    begin
                      NextSmMemSlaveSt = `ST_MEM_IDLE_RESP;
                      NextHREADYOUTSMC = 1'b1;
                    end
      
                  `HTRANS_NSEQ, `HTRANS_SEQ :
                    begin
                      NextHselMemBuf1   = HSELSMC;
                      if (HWRITESMC == 1'b1)
                        begin
                          NextSmMemSlaveSt = `ST_MEM_WRITE;
                          if (HTRANSSMC == `HTRANS_NSEQ)
                            NextHREADYOUTSMC = 1'b0;
                          else
                            NextHREADYOUTSMC = ( ~WaitWrCycMux) |
                                               ( ~WaitWrCycAhbMux);
                        end
                      else
                        begin
                          NextSmMemSlaveSt = `ST_MEM_READ;
                          if (HTRANSSMC == `HTRANS_NSEQ)
                            NextHREADYOUTSMC = 1'b0;
                          else
                            NextHREADYOUTSMC =  ~WaitRdCycMux;
                        end
                    end

                  default :
                    ;
                endcase
              end
            else
            begin
              NextSmMemSlaveSt = `ST_MEM_NOT_SEL;
              NextHREADYOUTSMC = 1'b1;
              NextHRESPSMC     = `HRESP_OKAY;
            end
          end
        else
          begin
            if (iWRITECYC == 1'b1)
              begin
                if (ErrCond == 1'b1)
                  begin
                    NextSmMemSlaveSt = `ST_MEM_ERROR;
                    NextHREADYOUTSMC = 1'b0;
                    NextHRESPSMC     = `HRESP_ERROR;
                  end
                else
                   NextHREADYOUTSMC = ( ~WaitWrCycMux) | ( ~WaitWrCycAhbMux);
              end
    
            if (READCYC == 1'b1)
              begin
                if (ErrCond == 1'b1)
                  begin
                    NextSmMemSlaveSt = `ST_MEM_ERROR;
                    NextHREADYOUTSMC = 1'b0;
                    NextHRESPSMC     = `HRESP_ERROR;
                  end
                else
                  NextHREADYOUTSMC =  ~WaitRdCycMux;
              end
          end
      end

    `ST_MEM_ERROR :
      begin
        NextHRESPSMC     = `HRESP_ERROR;
        NextHREADYOUTSMC = 1'b1;
        NextSmMemSlaveSt = `ST_MEM_NOT_SEL;
      end

    `ST_MEM_IDLE_RESP :
      begin
        NextHRESPSMC      = `HRESP_OKAY;
        NextAddrBuf1      = HADDRSMC;
        NxtHtransMemBuf1  = HTRANSSMC;
        NxtHburstMemBuf   = HBURSTSMC;
        NextHsizeMemBuf1  = HSIZESMC;
  
        case (HTRANSSMC)
          `HTRANS_IDLE :
            begin
              NextSmMemSlaveSt = `ST_MEM_NOT_SEL;
              NextHREADYOUTSMC = 1'b1;
            end
  
          `HTRANS_NSEQ, `HTRANS_SEQ :
            begin
              NextHselMemBuf1   = HSELSMC;
              if (HWRITESMC == 1'b1)
                begin
                  NextSmMemSlaveSt = `ST_MEM_WRITE;
                  NextHREADYOUTSMC = 1'b0;
                end
              else
                begin
                  NextSmMemSlaveSt = `ST_MEM_READ;
                  NextHREADYOUTSMC = (~WaitRdCycVer) & SlowClkM &
                                     (~SyncEnRead1) &
                                     (iHsizeEqMWidth | iAhbNarrow);
                end
            end

          default :
            ;
        endcase
      end

    default :
      ;
  endcase
end // p_MemSMComb

// -----------------------------------------------------------------------------
// Generation of Error condition when HSIZE is greater than WORD.
// -----------------------------------------------------------------------------
always @(iHsizeMemBuf1)
begin : p_SizeErrComb
  if ((iHsizeMemBuf1[2] == 1'b1) || (iHsizeMemBuf1[1:0] == 2'b11))
    HSizeErrMem = 1'b1;
  else
    HSizeErrMem = 1'b0;
end // p_SizeErrComb

// -----------------------------------------------------------------------------
// Generation of Error condition when Write protection error occurs.
// -----------------------------------------------------------------------------
always @(iWRITECYC or WP)
begin : p_WpErrComb
  WriteProtErr    = 1'b0;
  if ((iWRITECYC == 1'b1) && (WP == 1'b1))
    WriteProtErr    = 1'b1;
end // p_WpErrComb

// -----------------------------------------------------------------------------
// Generation of Error condition when Timeout error occurs.
// -----------------------------------------------------------------------------
always @(iWRITECYC or READCYC or CancelWaitSt or SlowClkM)
begin : p_ToutErrComb
  iWaitToutErr     = 1'b0;
  if (((iWRITECYC == 1'b1) || (READCYC == 1'b1)) && (CancelWaitSt == 1'b1) &&
      (SlowClkM == 1'b1))
    iWaitToutErr     = 1'b1;
end // p_ToutErrComb

// -----------------------------------------------------------------------------
// All possible Error conditions are OR'ed
// -----------------------------------------------------------------------------
assign ErrCond          = ((iWaitToutErr == 1'b1) || (WriteProtErr == 1'b1) ||
                           (HSizeErrMem == 1'b1)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of AhbWider signal.
// -----------------------------------------------------------------------------
assign iAhbWider        = (iHsizeMemBuf[1:0] > iMW) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of AhbNarrow signal.
// -----------------------------------------------------------------------------
assign iAhbNarrow       = (iHsizeMemBuf[1:0] < iMW) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of HsizeEqMWidth signal.
// -----------------------------------------------------------------------------
assign iHsizeEqMWidth   = (iHsizeMemBuf[1:0] == iMW) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of NseqRdCyc signal.
// -----------------------------------------------------------------------------
assign NseqRdCyc        = (iHtranRegCont == `HTRANS_NSEQ) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// To generate AhbCount:
// This count is used by the Memory TSM while performing Read, so that required
// no of Memory accesses are performed.
// This count is determined based on the HBURST, HSIZE and Memory Width values.
// -----------------------------------------------------------------------------
always @(READCYC or iHburstMemBuf or MW1 or iHsizeMemBuf1 or BurstLenRead1 or
         iAddrBuf1)
begin : p_AhbCountComb
  Concat   = ({MW1, iHsizeMemBuf1[1:0]});
  Temp     = 3'b000;
  Temp8    = 4'b0000;
  Temp16   = 5'b00000;
  AhbCount = 5'b00001;
  if (READCYC == 1'b1)
    begin
      case (iHburstMemBuf)
        `HBURST_SINGLE, `HBURST_INCR :
          begin
            case (Concat)
              4'b0000, 4'b0100, 4'b0101, 4'b1000, 4'b1001, 4'b1010 :
                AhbCount = 5'b00001;
    
              4'b0001, 4'b0110 :
                AhbCount = 5'b00010;
    
              4'b0010 :
                AhbCount = 5'b00100;
    
              default :
                ;
            endcase
          end
  
        `HBURST_WRAP4 :
          begin
            case (Concat)
              4'b0000 :
                begin
                  Temp     = 4 - iAddrBuf1[1:0];
                  AhbCount = {2'b00, Temp};
                end

              4'b0101 :
                begin
                  Temp     = 4 - iAddrBuf1[2:1];
                  AhbCount = {2'b00, Temp};
                end

              4'b1010 :
                begin
                  Temp     = 4 - iAddrBuf1[3:2];
                  AhbCount = {2'b00, Temp};
                end

              4'b0010 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      AhbCount = 5'b00100;

                    `EIGHT_TXR :
                      begin
                        if (iAddrBuf1[3:2] == 2'b11)
                          AhbCount = 5'b00100;
                        else
                          AhbCount = 5'b01000;
                      end

                    `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        Temp16   = 16 - iAddrBuf1[3:0];
                        AhbCount = Temp16;
                      end

                    default :
                      ;
                  endcase
                end

              4'b0001 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      begin
                        if (iAddrBuf1[2:1] == 2'b11)
                          AhbCount = 5'b00010;
                        else
                          AhbCount = 5'b00100;
                      end

                    `EIGHT_TXR, `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        Temp8    = 8 - iAddrBuf1[2:0];
                        AhbCount = {1'b0, Temp8};
                      end

                    default :
                      ;
                  endcase
                end

              4'b0110 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                        if (iAddrBuf1[3:2] == 2'b11)
                          AhbCount = 5'b00010;
                        else
                          AhbCount = 5'b00100;

                    `EIGHT_TXR, `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        Temp8    = 8 - iAddrBuf1[3:1];
                        AhbCount = {1'b0, Temp8};
                      end

                    default :
                      ;
                  endcase
                end

    
              4'b0100, 4'b1000, 4'b1001 :
                AhbCount = 5'b00001;
    
              default :
                ;
            endcase
          end
  
        `HBURST_INCR4 :
          begin
            case (Concat)
              4'b0000, 4'b0101, 4'b1010 :
                AhbCount = 5'b00100;

              4'b0010 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      AhbCount = 5'b00100;

                    `EIGHT_TXR :
                      AhbCount = 5'b01000;

                    `SIXTEEN_TXR, `CONTINUOUS :
                      AhbCount = 5'b10000;

                    default :
                      ;
                  endcase
                end

              4'b0001, 4'b0110 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      AhbCount = 5'b00100;

                    `EIGHT_TXR, `SIXTEEN_TXR, `CONTINUOUS :
                      AhbCount = 5'b01000;

                    default :
                      ;
                  endcase
                end

              4'b0100, 4'b1000, 4'b1001 :
                AhbCount = 5'b00001;

              default :
                ;
            endcase
          end

        `HBURST_WRAP8 :
          begin
            case (Concat)
              4'b0000 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      begin
                        if (iAddrBuf1[2] == 1'b1)
                          begin
                            Temp8 = 8 - iAddrBuf1[2:0];
                            AhbCount = {1'b0, Temp8};
                          end
                        else
                          begin
                            AhbCount = 5'b00100;
                          end
                      end

                    `EIGHT_TXR, `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        Temp8 = 8 - iAddrBuf1[2:0];
                        AhbCount = {1'b0, Temp8};
                      end

                    default :
                      ;
                  endcase
                end
    
              4'b0101 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      begin
                        if (iAddrBuf1[3] == 1'b1)
                          begin
                            Temp8 = 8 - iAddrBuf1[3:1];
                            AhbCount = {1'b0, Temp8};
                          end
                        else
                          begin
                            AhbCount = 5'b00100;
                          end
                      end

                    `EIGHT_TXR, `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        Temp8 = 8 - iAddrBuf1[3:1];
                        AhbCount = {1'b0, Temp8};
                      end

                    default :
                      ;
                  endcase
                end
    
              4'b1010 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      begin
                        if (iAddrBuf1[4] == 1'b1)
                          begin
                            Temp8 = 8 - iAddrBuf1[4:2];
                            AhbCount = {1'b0, Temp8};
                          end
                        else
                          begin
                            AhbCount = 5'b00100;
                          end
                      end

                    `EIGHT_TXR, `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        Temp8 = 8 - iAddrBuf1[4:2];
                        AhbCount = {1'b0, Temp8};
                      end

                    default :
                      ;
                  endcase
                end
    
              4'b0001 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      begin
                        if (iAddrBuf1[3:1] == 3'b111)
                          AhbCount = 5'b00010;
                        else
                          AhbCount = 5'b00100;
                      end

                    `EIGHT_TXR :
                      begin
                        if (iAddrBuf1[3] == 1'b1)
                          begin
                            Temp8 = 8 - iAddrBuf1[3:1];
                            AhbCount = {1'b0, Temp8};
                          end
                        else
                          begin
                            AhbCount = 5'b01000;
                          end
                      end

                    `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        Temp16 = 16 - iAddrBuf1[3:0];
                        AhbCount = Temp16;
                      end

                    default :
                      ;
                  endcase
                end

              4'b0110 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      begin
                        if (iAddrBuf1[4:2] == 3'b111)
                          AhbCount = 5'b00010;
                        else
                          AhbCount = 5'b00100;
                      end

                    `EIGHT_TXR :
                      begin
                        if (iAddrBuf1[4] == 1'b1)
                          begin
                            Temp8 = 8 - iAddrBuf1[3:1];
                            AhbCount = {1'b0, Temp8};
                          end
                        else
                          begin
                            AhbCount = 5'b01000;
                          end
                      end

                    `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        Temp16 = 16 - iAddrBuf1[4:1];
                        AhbCount = Temp16;
                      end

                    default :
                      ;
                  endcase
                end

              4'b0010 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      AhbCount = 5'b00100;

                    `EIGHT_TXR :
                      begin
                        if (iAddrBuf1[4:2] == 3'b111)
                          AhbCount = 5'b00100;
                        else
                          AhbCount = 5'b01000;
                      end

                    `SIXTEEN_TXR, `CONTINUOUS :
                      begin
                        if (iAddrBuf1[4] == 1'b1)
                          begin
                            Temp16 = 16 - iAddrBuf1[3:0];
                            AhbCount = Temp16;
                          end
                        else
                          begin
                            AhbCount = 5'b10000;
                          end
                      end

                    default :
                      ;
                  endcase
                end

              4'b0100, 4'b1000, 4'b1001 :
                AhbCount = 5'b00001;

              default :
                ;
            endcase
          end
  
        `HBURST_INCR8 :
          begin
            case (Concat)
              4'b0000, 4'b0101, 4'b1010 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      AhbCount = 5'b00100;

                    `EIGHT_TXR, `SIXTEEN_TXR, `CONTINUOUS :
                      AhbCount = 5'b01000;

                    default :
                      ;
                  endcase
                end

              4'b0001, 4'b0110, 4'b0010 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      AhbCount = 5'b00100;

                    `EIGHT_TXR :
                      AhbCount = 5'b01000;

                    `SIXTEEN_TXR, `CONTINUOUS :
                      AhbCount = 5'b10000;

                    default :
                      ;
                  endcase
                end

              4'b0100, 4'b1000, 4'b1001 :
                AhbCount = 5'b00001;

              default :
                ;
            endcase
          end

        `HBURST_WRAP16, `HBURST_INCR16 :
          begin
            case (Concat)
              4'b0000, 4'b0101, 4'b1010, 4'b0001, 4'b0110, 4'b0010 :
                begin
                  case (BurstLenRead1)
                    `FOUR_TXR :
                      AhbCount = 5'b00100;

                    `EIGHT_TXR :
                      AhbCount = 5'b01000;

                    `SIXTEEN_TXR, `CONTINUOUS :
                      AhbCount = 5'b10000;

                    default :
                      ;
                  endcase
                end
    
              4'b0100, 4'b1000, 4'b1001 :
                 AhbCount = 5'b00001;
    
              default :
                ;
            endcase
          end

        default :
          ;
      endcase
    end
end // p_AhbCountComb

// -----------------------------------------------------------------------------
// TurnAround is required on following conditions:
// a) When there is a Single Read, and IDCYC values are programmed.
// b) When there is a R->W to any Bank, and IDCYC values are programmed.
// c) When there is a R->R to different bank, and IDCYC values are programmed.
// The signal TurnAround indicates as to whether there was R->R or R->W access.
// The final decision as to whether to do the Turnaround is decided in Memory SM
// -----------------------------------------------------------------------------
assign TurnAroundComb   = (((DelREADCYC == 1'b1) && (iWRITECYC == 1'b1)) ||
                           ((DelREADCYC == 1'b1) && (READCYC == 1'b1) &&
                           (iHselMemBuf1 != DelHselMemBuf1))) ? 1'b1   : 1'b0;

// -----------------------------------------------------------------------------
// When there is clock frequency mismatch, the TurnAroundComb signal should be
// sustained till (SlowClkM = '1') condition is satisfied.
// -----------------------------------------------------------------------------
always @(TurnArndReg or TurnAroundComb or SlowClkM or CancelWaitSt or
         WaitDeAssrtSt or TurnAroundSt or WaitTxrOnBusSt or Toggle or
         iNewBurst or InitSt)
begin : p_TurnAroundComb
  NextTurnArndReg  = TurnArndReg;
  if ((TurnAroundComb == 1'b1) && (TurnArndReg == 1'b0) && (InitSt == 1'b0) &&
      (((WaitTxrOnBusSt == 1'b0) && (WaitDeAssrtSt == 1'b0) &&
        (TurnAroundSt == 1'b0) && (CancelWaitSt == 1'b0)) ||
       ((SlowClkM == 1'b0) && (TurnAroundSt == 1'b0))))
    NextTurnArndReg  = 1'b1;
  else if ((SlowClkM == 1'b1) &&
           ((((Toggle == 1'b1) || (iNewBurst == 1'b1)) &&
             ((WaitTxrOnBusSt == 1'b1) || (WaitDeAssrtSt == 1'b1))) ||
            (CancelWaitSt == 1'b1)))
    NextTurnArndReg  = 1'b0;
end // p_TurnAroundComb

// -----------------------------------------------------------------------------
// Generation of TurnAround signal.
// -----------------------------------------------------------------------------
assign TurnAround       = TurnAroundComb | TurnArndReg;

// -----------------------------------------------------------------------------
// NewBurst signal is generated whenever there is an NSEQ on the First level
// registered HTRANS signal. This signal is very useful in breaking of the
// burst in middle, reloading the counter, initiating the transfers etc.
// -----------------------------------------------------------------------------
assign NewBurstComb     = ((iHtransMemBuf1 == `HTRANS_NSEQ) &&
                           (iHREADYOUTSMC == 1'b0) &&
                                          (DelHreadyOut == 1'b1)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// When there is clock frequency mismatch, the NewBurstComb signal should be
// sustained till (SlowClkM = '0') condition is satisfied.
// -----------------------------------------------------------------------------
always @(NewBrstReg or NewBurstComb or SlowClkM)
begin : p_NewBurstComb
  NextNewBrstReg   = NewBrstReg;
  if ((NewBurstComb == 1'b1) && (SlowClkM == 1'b0) && (NewBrstReg == 1'b0))
    NextNewBrstReg   = 1'b1;
  else if (SlowClkM == 1'b1)
    NextNewBrstReg   = 1'b0;
end // p_NewBurstComb

// -----------------------------------------------------------------------------
// Generation of NewBurst signal.
// -----------------------------------------------------------------------------
assign iNewBurst        = NewBurstComb | NewBrstReg;

// -----------------------------------------------------------------------------
// MemRdReq is asserted on following conditions:
// a) When AHB Width is greater or equal to Memory Width, then Read state decode
//    of AHB SM indicates a Read request.
// b) When AHB Width is smaller than Memory Width, MemRdReq is asserted for the
//    first read transfer, for subsequent transfers MemRdReq is de-asserted.
// -----------------------------------------------------------------------------
assign iMemRdReq        = READCYC & ( ~MemRdMask) & ( ~iHREADYOUTSMC) &
                           (~(WriteMask | DelWriteMask)) & ( ~ErrCond);

// -----------------------------------------------------------------------------
// To generate MemRdMask:
// * The mask should be set when AHB Width is Lesser than Memory Width.
// * The mask should be set after the first access, provided address is aligned.
// * The mask should be set till the buffer becomes empty or if the burst gets
//   broken or Error condition is sampled.
// -----------------------------------------------------------------------------
always @(iAhbNarrow or WaitRdCyc or MemRdMaskReg or iNewBurst or AhbLessRdCnt or
         AddrNotAlgnRd or iBUSYCYC or NseqRdCyc or ErrCond or SlowClkM or
         iHREADYOUTSMC or BsyLstBt)
begin : p_MemRdMaskComb
  NextMemRdMaskReg    = MemRdMaskReg;
  if ((iAhbNarrow == 1'b1) && (WaitRdCyc == 1'b0) && (MemRdMaskReg == 1'b0) &&
      (AddrNotAlgnRd == 1'b0) && (SlowClkM == 1'b1) && (iNewBurst == 1'b0))
    NextMemRdMaskReg  = 1'b1;
  else if (((AhbLessRdCnt <= 3'b001) && (iBUSYCYC == 1'b0) &&
            (iHREADYOUTSMC == 1'b1)) ||
           (NseqRdCyc == 1'b1) || (iNewBurst == 1'b1) || (ErrCond == 1'b1) ||
           ((iHREADYOUTSMC == 1'b1) && (BsyLstBt == 1'b1) &&
            (iBUSYCYC == 1'b0)))
    NextMemRdMaskReg  = 1'b0;
end // p_MemRdMaskComb

// -----------------------------------------------------------------------------
// MemRdMaskPulse is generated when there is a BUSY transaction driven on the
// bus for the last beat of the AhbLessRdCnt counter. In this case before the
// logic can sample the BUSY(registered) on the bus counter would have
// decremented, so to prevent any error corruption of data, this logic is put
// in place.
// -----------------------------------------------------------------------------
assign MemRdMaskPulse = ((MemRdMaskReg == 1'b0) && (DelMemRdMaskReg == 1'b1) &&
                         (iHtranRegCont == `HTRANS_BUSY) &&
                                              (BsyLstBt == 1'b0)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// The pulse generated in the above logic is sustained untill BUSY is changed
// to some other transaction.
// -----------------------------------------------------------------------------
always @(MemRdBusy or MemRdMaskPulse or iHtranRegCont)
begin : p_MemRdBusyComb
  NextMemRdBusy = MemRdBusy;
  if ((MemRdMaskPulse == 1'b1) && (MemRdBusy == 1'b0))
    NextMemRdBusy = 1'b1;
  else if (iHtranRegCont != `HTRANS_BUSY)
    NextMemRdBusy = 1'b0;
end // p_MemRdBusyComb

assign MemRdMask = ((MemRdMaskReg == 1'b1) || (MemRdBusy == 1'b1)) ?
                                                                   1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Logic to identify whether Busy was inserted for last beat.
// -----------------------------------------------------------------------------
always @(BsyLstBt or AhbLessRdCnt or DelAhbLessRdCnt or iBUSYCYC or DelBUSYCYC)
begin : p_BusyLstBtComb
  NextBsyLstBt = BsyLstBt;
  if ((AhbLessRdCnt == 3'b001) && (DelAhbLessRdCnt == 3'b001) &&
      (iBUSYCYC == 1'b1) && (DelBUSYCYC == 1'b0) && (BsyLstBt == 1'b0))
    NextBsyLstBt = 1'b1;
  else if (AhbLessRdCnt == 3'b000)
    NextBsyLstBt = 1'b0;
end // p_BusyLstBtComb

// -----------------------------------------------------------------------------
// To generate WaitRdCycMux:
// a) When AHB Width is equal to Memory Width. WaitRdCycMux is same as
//    WaitRdCyc until NewBurst is seen.
// b) When AHB is wider WaitRdCycMux is same as WaitRdCyc when we have collected
//    all the data from Memory.
// c) When AHB is narrower than Memory Width. WaitRdCycMux is same as
//    WaitRdCyc for the First data, but for subsequent access we have to give
//    the data from buffer until MemRdMask is set.
// -----------------------------------------------------------------------------
always @(iAhbWider or iAhbWideRdCnt or WaitRdCyc or MemRdMask or
         iHsizeEqMWidth or iNewBurst or SlowClkM or BsyLstBt or iHREADYOUTSMC)
begin : p_WaitRdCycMux
  WaitRdCycMux     = 1'b1;
  if (iHsizeEqMWidth == 1'b0)
    begin
      if (iAhbWider == 1'b1)
        begin
  
          // New Burst information is added to prevent HREADYOUT being driven on
          // the bus when there is a new read burst.
          if ((iAhbWideRdCnt == 3'b001) && (iNewBurst == 1'b0))
            WaitRdCycMux = WaitRdCyc | ( ~SlowClkM);
          else
            WaitRdCycMux = 1'b1;
        end
      else
        begin
  
          // New Burst information is added to prevent HREADY being driven on
          // the bus when there is a new read burst.
          if ((MemRdMask == 1'b1) && (iNewBurst == 1'b0))
            begin
              if ((BsyLstBt == 1'b1) && (iHREADYOUTSMC == 1'b1))
                WaitRdCycMux     = 1'b1;
              else
                WaitRdCycMux     = 1'b0;
            end
          else
            WaitRdCycMux     = WaitRdCyc | ( ~SlowClkM) | iNewBurst;
        end
    end
  else
    begin
      if (iNewBurst == 1'b0)
        WaitRdCycMux     = WaitRdCyc | ( ~SlowClkM);
      else
        WaitRdCycMux     = 1'b1;
    end
end // p_WaitRdCycMux

// -----------------------------------------------------------------------------
// Loading and decrementing of AhbWideRdCnt counter:
// Loading of this counter happens on following condition
// a) When there is a beginning of new burst i.e. NSEQ registered, AHB Greater
//    than Memory Width, Read transfer and when the counter has expired in case
//    of Asynchronous Memories and counter = 1 in case of Synchronous Memories.
// b) Decrement this counter when WaitRdCyc is seen and SmCSTSM is asserted.
// c) Flush the counter when Error condition is sampled.
// -----------------------------------------------------------------------------
always @(iAhbWideRdCnt or iNewBurst or iAhbWider or iHsizeMemBuf1 or
         MW1 or READCYC or WaitRdCyc or SlowClkM or SmCSTSM or ErrCond or
         MemoryRdSt or iBUSYCYC or SyncEnRead1)
begin : p_AhbWdRdCntComb
  NextAhbWideRdCnt = iAhbWideRdCnt;
  if (((iNewBurst == 1'b1) || (iAhbWideRdCnt == 3'b000)) &&
      (SlowClkM == 1'b1) && (iAhbWider == 1'b1) &&
      ((READCYC == 1'b1) || ((iBUSYCYC & MemoryRdSt & (~SyncEnRead1)) == 1'b1)))
    begin
      case (iHsizeMemBuf1)
        `HSIZE_HWORD :
          begin
            // In this case the Counter has to be loaded with the value
            // depending on MW1 value.
            if (MW1 == `MEM_BYTE)
              begin
                if ((WaitRdCyc == 1'b1) || (iNewBurst == 1'b1))
                  NextAhbWideRdCnt = 3'b010;
                else
                  NextAhbWideRdCnt = 3'b001;
              end
          end
  
        `HSIZE_WORD :
          begin
            // In this case the Counter has to be loaded with the value
            // depending on MW1 value.
            case (MW1)
              `MEM_BYTE :
                begin
                  if ((WaitRdCyc == 1'b1) || (iNewBurst == 1'b1))
                    NextAhbWideRdCnt = 3'b100;
                  else
                    NextAhbWideRdCnt = 3'b011;
                end
  
              `MEM_HWORD :
                begin
                  if ((WaitRdCyc == 1'b1) || (iNewBurst == 1'b1))
                    NextAhbWideRdCnt = 3'b010;
                  else
                    NextAhbWideRdCnt = 3'b001;
                end
    
              default :
                ;
            endcase
          end
    
        default :
          ;
      endcase
  
    end
  else if ((iAhbWideRdCnt != 3'b000) && (WaitRdCyc == 1'b0) &&
           (SlowClkM == 1'b1) && (SmCSTSM == 1'b0))
    NextAhbWideRdCnt = iAhbWideRdCnt - 3'b001;

  else if ((ErrCond == 1'b1) ||
           ((READCYC == 1'b0) &&
            (((iBUSYCYC & MemoryRdSt) == 1'b0) ||
             (SyncEnRead1 == 1'b1))))
    NextAhbWideRdCnt = 3'b000;
end // p_AhbWdRdCntComb

// -----------------------------------------------------------------------------
// Loading and decrementing of AhbLessRdCnt counter:
// a) Load this counter after seeing the first WaitRdcyc, address is aligned
//    and AHB SM is in read state.
// b) Decrement this counter on every clock till there is no BUSY insertion or
//    break in burst.
// -----------------------------------------------------------------------------
always @(AhbLessRdCnt or iNewBurst or iAhbNarrow or NseqRdCyc or READCYC or
         iHsizeMemBuf1 or MW1 or MemRdMask or SlowClkM or AddrNotAlgnRd or
         WaitRdCyc or iHREADYOUTSMC or BsyLstBt or iBUSYCYC)
begin : p_AhbLsRdCntComb
  NextAhbLessRdCnt = AhbLessRdCnt;
  if ((iAhbNarrow == 1'b1) && (READCYC == 1'b1) && (SlowClkM == 1'b1) &&
      (WaitRdCyc == 1'b0) && (MemRdMask == 1'b0) && (AddrNotAlgnRd == 1'b0))
    begin
  
      // The Counter has to be loaded with the value depending on MW value.
      // The value loaded is 1 less as already one beat from memory is routed
      // on to AHB.
      case (iHsizeMemBuf1)
        `HSIZE_BYTE :
          begin
            case (MW1)
              `MEM_HWORD :
                 NextAhbLessRdCnt = 3'b001;
    
              `MEM_WORD :
                 NextAhbLessRdCnt = 3'b011;
    
              default :
                ;
            endcase
          end
  
        `HSIZE_HWORD :
          if (MW1 == `MEM_WORD)
            NextAhbLessRdCnt = 3'b001;
    
        default :
          ;
      endcase
    end

  // Decrement the counter if there is no new burst and there is no Busy
  // transfers driven on the bus.
  else if ((AhbLessRdCnt > 3'b000) && (iNewBurst == 1'b0) &&
           (iBUSYCYC == 1'b0) && (iHREADYOUTSMC == 1'b1))
    NextAhbLessRdCnt = AhbLessRdCnt - 3'b001;

  // When NewBurst is driven on the bus reset the counter.
  else if ((iNewBurst == 1'b1) || (NseqRdCyc == 1'b1) ||
           ((iHREADYOUTSMC == 1'b1) && (BsyLstBt == 1'b1) &&
            (iBUSYCYC == 1'b0)))
     NextAhbLessRdCnt = 3'b000;
end // p_AhbLsRdCntComb

// -----------------------------------------------------------------------------
// Generation of WriteRqBuf:
// This signal is generated when the AHB SM enters the Write State, this signal
// is registered(because the first write should happen with 1 wait state, so
// there is every possibility that before this write request is sampled by the
// Memory SM the AHB might have made a state transition to different state) and
// this registered signal is deasserted when WaitWrCycVer signal is sampled low
// and the AHB SM is not in Write State).
// -----------------------------------------------------------------------------
always @(WriteRqBuf or iWRITECYC or WaitWrCycVer or SlowClkM or iAhbWideWrCnt or
         ErrCond or WaitEnReg or WaitWrCycDup or BurstWriteSt or WriteBeatCnt or
         iUseSecBuf or UseSecBufVer or iWaitToutErr or BMWriteReg)
begin : p_WrReqBuffComb
  NextWriteRqBuf   = WriteRqBuf;
  if ((iWRITECYC == 1'b1) &&
      ((WriteRqBuf == 1'b0) || (iUseSecBuf == 1'b1) ||
       (UseSecBufVer == 1'b1)) &&
      (ErrCond == 1'b0) && (WaitEnReg == 1'b0))
    NextWriteRqBuf   = 1'b1;
  else if ((((iWRITECYC == 1'b0) || (WaitEnReg == 1'b1)) &&
            ((WaitWrCycVer == 1'b0) || (WaitWrCycDup == 1'b0)) &&
            (SlowClkM == 1'b1) && (iAhbWideWrCnt <= 3'b001)) ||
           ((BurstWriteSt == 1'b1) && (iWRITECYC == 1'b0) &&
            (SlowClkM == 1'b1)  && (BMWriteReg == 1'b1) &&
            (WriteBeatCnt == 3'b000) && (iUseSecBuf == 1'b0)) ||
           ((ErrCond == 1'b1) &&
            ((WaitWrCycVer == 1'b0) || (iWaitToutErr == 1'b1))))
    NextWriteRqBuf   = 1'b0;
end // p_WrReqBuffComb

always @(ValWrBrstSt or iWRITECYC or WBstIntrptd or iHtransMemBuf1 or
         ValWrBrstSt or MemoryWrSt or BurstWriteSt or TxrB4BsyAccptd or
         WaitWrCycVer or iHREADYOUTSMC or SlowClkM)
begin : p_ValWrBrstStComb
  NextValWrBrstSt = ValWrBrstSt;
  if ((iWRITECYC == 1'b1) && (WBstIntrptd == 1'b1) &&
      (iHtransMemBuf1  == `HTRANS_NSEQ) && (ValWrBrstSt == 1'b0) &&
      (TxrB4BsyAccptd == 1'b0) && (SlowClkM == 1'b1) &&
      ((WaitWrCycVer == 1'b0) || (iHREADYOUTSMC == 1'b1)))
    NextValWrBrstSt = 1'b1;
  else if ((MemoryWrSt == 1'b1) && (BurstWriteSt == 1'b0))
    NextValWrBrstSt = 1'b0;
end // p_ValWrBrstStComb

assign UseSecBufExtd = ValWrBrstSt & (~iIDLECYC) & MemoryWrSt & BurstWriteSt;

// -----------------------------------------------------------------------------
// Generation of MemWrReq
// This signal is an OR'ed version of Write state and the registered Write
// signal. After ORing it is ANDED with the WriteMask signal(which is generated
// combinationally) to take care of the case when AHBWidth is smaller than the
// Memory Width.
// Condition ((WaitEnReg = '1') && (iWRITECYC = '1')) is added for freq runs.
// -----------------------------------------------------------------------------
always @(WriteMask or ErrCond or MemoryWrSt or iWRITECYC or WaitEnReg or
         NextWriteRqBuf or iUseSecBuf or UseSecBufVer)
begin : p_MemWrReqComb
  if ((WriteMask == 1'b0) && (ErrCond == 1'b0))
    begin
      if (((MemoryWrSt == 1'b0) && (iWRITECYC == 1'b1)) ||
          (iUseSecBuf == 1'b1) ||
          (NextWriteRqBuf == 1'b1) || (UseSecBufVer == 1'b1) ||
          ((WaitEnReg == 1'b1) && (iWRITECYC == 1'b1)))
        MemWrReq         = 1'b1;
      else
        MemWrReq         = 1'b0;
    end
  else
    MemWrReq         = 1'b0;
end // p_MemWrReqComb

// -----------------------------------------------------------------------------
// Generation of WriteMaskComb:
// This signal should be active for 1 HCLK.
// This signal is asserted when AHB is narrower than Memory, Address is aligned,
// and there are no Wait enabled transfers.
// -----------------------------------------------------------------------------
always @(WriteMaskBuf or iAhbNarrow or WaitWrCycMux or iAddrNotAligned or
         iWRITECYC or iWaitEn or ErrCond or extracond or AhbLessWrCnt)
begin : p_WrMaskComb
  WriteMaskComb    = 1'b0;
  if ((WriteMaskBuf == 1'b0) && (iAhbNarrow == 1'b1) &&
      ((WaitWrCycMux == 1'b0) ||
       ((extracond == 1'b1) && (AhbLessWrCnt == 3'b000))) && 
      (ErrCond == 1'b0) && (iWRITECYC == 1'b1) &&
      (iAddrNotAligned == 1'b0) && (iWaitEn == 1'b0))
    WriteMaskComb    = 1'b1;
  else
    WriteMaskComb    = 1'b0;
end // p_WrMaskComb

// -----------------------------------------------------------------------------
// Generation of WriteMaskBuf:
// The WriteMask should be sustained till there are sufficient data to write
// into Memory.
// Mask should be de-asserted after the AhbLessWrCnt has decremented to 1 in
// normal case.
// When NewBurst signal is sampled, Mask should be de-asserted.
// -----------------------------------------------------------------------------
always @(WriteMaskBuf or iWRITECYC or WriteMaskComb or iNewBurst or
         AhbLessWrCnt or WaitWrCycMux or iIDLECYC)
begin : p_WrMaskBuffComb
  NextWriteMaskBuf = WriteMaskBuf;
  if ((iWRITECYC == 1'b1) && (WriteMaskBuf == 1'b0) && (WriteMaskComb == 1'b1))
    NextWriteMaskBuf = 1'b1;
  else if ((iNewBurst == 1'b1) || (iIDLECYC == 1'b1) ||
           ((AhbLessWrCnt == 3'b001) && (WaitWrCycMux == 1'b0)))
    NextWriteMaskBuf = 1'b0;
end // p_WrMaskBuffComb

// -----------------------------------------------------------------------------
// Generation of WriteMask:
// a) This signal should be set only when AHB Width is < Memory Width and
//    transfer is not wait enabled.
// b) Mask should be de-asserted after the AhbLessWrCnt has decremented
//    to 1 in normal case.
// c) When NewBurst signal is sampled, Mask should be de-asserted.
// d) In case of Non-aligned address, Mask should not be set.
// -----------------------------------------------------------------------------
assign WriteMask        = WriteMaskBuf | WriteMaskComb;

// -----------------------------------------------------------------------------
// Generation of AddrNotAligned signal:
// a) This signal should be asserted for 1HCLK.
// b) This signal should be set when AHBWIDTH < MEMWIDTH and there was a single
//    transfer from AHB.
// c) This signal should be set when AHBWIDTH < MEMWIDTH and first AHB Address
//    was not aligned with the HBURST information.
// -----------------------------------------------------------------------------
always @(iHsizeMemBuf1 or MW1 or iNewBurst or iHburstMemBuf or iAddrBuf1 or
         SyncEnWrite1)
begin : p_AddrAlignComb
  AddrNotAlignComb = 1'b0;
  case (iHsizeMemBuf1)
    `HSIZE_BYTE :
      begin
        case (MW1)
          `MEM_BYTE :
            if ((iNewBurst == 1'b1) && (iAddrBuf1[0] == 1'b1) &&
                (SyncEnWrite1 == 1'b1) &&
                ((iHburstMemBuf == `HBURST_WRAP4) ||
                 (iHburstMemBuf == `HBURST_WRAP8) ||
                 (iHburstMemBuf == `HBURST_WRAP16)))
              AddrNotAlignComb = 1'b1;
            else
              AddrNotAlignComb = 1'b0;

          `MEM_HWORD :
            if ((iNewBurst == 1'b1) && (iAddrBuf1[0] == 1'b1))
              AddrNotAlignComb = 1'b1;
            else
              AddrNotAlignComb = 1'b0;
  
          `MEM_WORD :
            if ((iNewBurst == 1'b1) &&
                ((iAddrBuf1[0] == 1'b1) || (iAddrBuf1[1] == 1'b1)))
              AddrNotAlignComb = 1'b1;
            else
              AddrNotAlignComb = 1'b0;
    
          default :
            ;
        endcase
      end

    `HSIZE_HWORD :
      if ((iNewBurst == 1'b1) && (iAddrBuf1[1] == 1'b1))
        AddrNotAlignComb = 1'b1;
      else
        AddrNotAlignComb = 1'b0;
    
    default :
      ;
  endcase
end // p_AddrAlignComb

// -----------------------------------------------------------------------------
// Registering the AddrNotAlignComb signal generated in above process, while
// performing Write operations.
// -----------------------------------------------------------------------------
always @(AddrNotAlignReg or AddrNotAlignComb or iNewBurst or iWRITECYC or
         iIDLECYC)
begin : p_AddrAlgnRgComb
  NextAddrNotAlign = AddrNotAlignReg;
  if ((AddrNotAlignComb == 1'b1) && (iWRITECYC == 1'b1))
    NextAddrNotAlign = 1'b1;

  // Signal set should be sustained till a New transfer is sampled, or the
  // ongoing burst is broken from AHB.
  else if ((iNewBurst == 1'b1) || (iIDLECYC == 1'b1))
    NextAddrNotAlign = 1'b0;
end // p_AddrAlgnRgComb

assign iAddrNotAligned  = AddrNotAlignComb | AddrNotAlignReg;

// -----------------------------------------------------------------------------
// Registering the AddrNotAlignComb signal generated in above process while
// performing Read operations.
// -----------------------------------------------------------------------------
always @(AddrNotAlgnRd or AddrNotAlignComb or iIDLECYC or READCYC or iNewBurst)
begin : p_AddrAlgnRdComb
  NextAddrAlgnRd   = AddrNotAlgnRd;
  if ((AddrNotAlignComb == 1'b1) && (READCYC == 1'b1))
    NextAddrAlgnRd   = 1'b1;
  else if ((iNewBurst == 1'b1) || (iIDLECYC == 1'b1))
    NextAddrAlgnRd   = 1'b0;
end // p_AddrAlgnRdComb

// -----------------------------------------------------------------------------
// Loading and decrementing of AhbLessWrCnt counter:
// This counter has to be loaded when WriteMaskComb is sampled high.
// While loading, loaded with a value 1 less because the first write access is
// of one wait state hence by the time this counter is loaded, one write
// would have finished.
// This counter should be decremented on every WaitWrCycMux = '0' condition
// provided there is no BUSY transfers or break in burst.
// -----------------------------------------------------------------------------
always @(AhbLessWrCnt or WriteMaskComb or iHsizeMemBuf1 or iMW or iNewBurst or
         iHtransMemBuf1 or WaitWrCycMux or iIDLECYC)
begin : p_AhbLsWrCntComb
  NextAhbLessWrCnt = AhbLessWrCnt;
  if (WriteMaskComb == 1'b1)
    begin
      case (iHsizeMemBuf1)
        `HSIZE_BYTE :
  
          // In this case the Counter has to be loaded with the value depending
          // on MW value. The value loaded is 1 less as already one write from
          // AHB is passed on to the buffer.
          case (iMW)
            `MEM_HWORD :
              NextAhbLessWrCnt = 3'b001;
  
            `MEM_WORD :
              NextAhbLessWrCnt = 3'b011;
    
            default :
              ;
          endcase
  
        `HSIZE_HWORD :
  
          // In this case the Counter has to be loaded with the value depending
          // on MW value. The value loaded is 1 less as already one write from
          // AHB is passed on to the buffer.
          if (iMW == `MEM_WORD)
            NextAhbLessWrCnt = 3'b001;
    
        default :
          ;
      endcase
    end
  else if ((AhbLessWrCnt != 3'b000) && (iNewBurst == 1'b0) &&
           (iHtransMemBuf1 != `HTRANS_BUSY) && (WaitWrCycMux == 1'b0))
    NextAhbLessWrCnt = AhbLessWrCnt - 3'b001;

  // When NewBurst is driven on the bus reset the counter
  else if ((iNewBurst == 1'b1) || (iIDLECYC == 1'b1))
    NextAhbLessWrCnt = 3'b000;
end // p_AhbLsWrCntComb

// -----------------------------------------------------------------------------
// Logic to Write to Appropriate Byte Lanes when AHB Width < Memory Width.
// There is every possibility that AHB might write to portion of the Memory
// Byte Lanes.
// -----------------------------------------------------------------------------
always @(iWRITECYC or BIGENDIAN or iHsizeMemBuf1 or iAddrBuf1 or ValByteLane0
         or ValByteLane1 or ValByteLane2 or ValByteLane3 or WaitWrCycVer or
         ErrCond or SlowClkM or WaitWrCycMux or WaitEnWrFirstCyc or WaitEnReg or
         iNewBurst or MemoryWrSt or MW1 or extracond or ValWrBrstSt)
begin : p_ValidLaneComb
  iNxtValByteLane0 = ValByteLane0;
  iNxtValByteLane1 = ValByteLane1;
  iNxtValByteLane2 = ValByteLane2;
  iNxtValByteLane3 = ValByteLane3;

  if ((iWRITECYC == 1'b1) && (iHsizeMemBuf1[1:0] < MW1) && (ErrCond == 1'b0) &&
      ((WaitWrCycMux == 1'b0) || (WaitEnWrFirstCyc == 1'b0)))
    begin
      if (((WaitWrCycVer == 1'b0) && (extracond == 1'b0)) ||
          ((iNewBurst == 1'b1) && (MemoryWrSt == 1'b1)))
        begin
          if (ValByteLane0 == 1'b1)
            iNxtValByteLane0 = 1'b0;
          if (ValByteLane1 == 1'b1)
           iNxtValByteLane1 = 1'b0;
          if (ValByteLane2 == 1'b1)
            iNxtValByteLane2 = 1'b0;
          if (ValByteLane3 == 1'b1)
            iNxtValByteLane3 = 1'b0;
        end
  
      if (BIGENDIAN == 1'b0)
        begin
          case (iHsizeMemBuf1)
            `HSIZE_BYTE :
              case (iAddrBuf1[1:0])
                2'b00 :
                  iNxtValByteLane0 = 1'b1;
    
                2'b01 :
                  iNxtValByteLane1 = 1'b1;
    
                2'b10 :
                  iNxtValByteLane2 = 1'b1;
    
                2'b11 :
                  iNxtValByteLane3 = 1'b1;
    
                default :
                  ;
              endcase
    
            `HSIZE_HWORD :
              case (iAddrBuf1[1])
                1'b0 :
                  begin
                    iNxtValByteLane0 = 1'b1;
                    iNxtValByteLane1 = 1'b1;
                  end
    
                1'b1 :
                  begin
                    iNxtValByteLane2 = 1'b1;
                    iNxtValByteLane3 = 1'b1;
                  end
    
                default :
                  ;
              endcase
    
            default :
              ;
          endcase
        end
      else
        begin
          case (iHsizeMemBuf1)
            `HSIZE_BYTE :
              case (iAddrBuf1[1:0])
                2'b11 :
                   iNxtValByteLane0 = 1'b1;
    
                2'b10 :
                   iNxtValByteLane1 = 1'b1;
    
                2'b01 :
                   iNxtValByteLane2 = 1'b1;
    
                2'b00 :
                   iNxtValByteLane3 = 1'b1;
    
                default :
                  ;
              endcase
    
            `HSIZE_HWORD :
              case (iAddrBuf1[1])
                1'b1 :
                  begin
                    iNxtValByteLane0 = 1'b1;
                    iNxtValByteLane1 = 1'b1;
                  end
    
                1'b0 :
                  begin
                    iNxtValByteLane2 = 1'b1;
                    iNxtValByteLane3 = 1'b1;
                  end
    
                default :
                  ;
              endcase
    
            default :
              ;
          endcase
        end // else: !if(BIGENDIAN == 1'b0)
      
  
      if ((WaitWrCycVer == 1'b0) && (WaitEnReg == 1'b1))
        begin
          if (ValByteLane0 == 1'b1)
            iNxtValByteLane0 = 1'b0;
          if (ValByteLane1 == 1'b1)
            iNxtValByteLane1 = 1'b0;
          if (ValByteLane2 == 1'b1)
            iNxtValByteLane2 = 1'b0;
          if (ValByteLane3 == 1'b1)
            iNxtValByteLane3 = 1'b0;
        end
    end // if ((iWRITECYC == 1'b1) && (iHsizeMemBuf1[1:0] < MW1) && (ErrCond == 1'b0) &&...
  else if (((WaitWrCycVer == 1'b0) && (SlowClkM == 1'b1) &&
            (extracond == 1'b0) && (ValWrBrstSt == 1'b0)) ||
           (ErrCond == 1'b1))
    begin
      iNxtValByteLane0 = 1'b0;
      iNxtValByteLane1 = 1'b0;
      iNxtValByteLane2 = 1'b0;
      iNxtValByteLane3 = 1'b0;
    end
end // p_ValidLaneComb

// -----------------------------------------------------------------------------
// Loading and Decrementing of AhbWideWrCnt counter:
// This counter has to be loaded when (WaitWrCycMux = 0) and (AhbMemSM = write
// state) and (AHBWIDTH > MW).
// The counter has to be decremented till it expires on every WaitWrCycVer = 0
// condition.
// The counter has to be flushed when WaitToutErr condition happens for wait
// enabled transfers.
// -----------------------------------------------------------------------------
always @(iAhbWideWrCnt or WaitWrCycMux or iAhbWider or ErrCond or
         iHsizeMemBuf or iMW or WaitWrCycVer or DelWaitWrCycMux or
         WaitEnWrFirstCyc or iWRITECYC or iWaitEn or SlowClkM or
         WaitWrCycDup or AhbWiderWr)
begin : p_AhbWdWrCntComb
  NextAhbWideWrCnt = iAhbWideWrCnt;
  if ((((((DelWaitWrCycMux == 1'b0) && (iAhbWideWrCnt == 3'b000)) ||
         ((((WaitWrCycMux == 1'b0) && (iAhbWideWrCnt == 3'b000)) ||
           ((WaitWrCycDup == 1'b0) && (iAhbWideWrCnt <= 3'b001))) &&
           (SlowClkM == 1'b1))) && (iWaitEn == 1'b0)) ||
       (WaitEnWrFirstCyc == 1'b0)) &&
      (iAhbWider == 1'b1) && (ErrCond == 1'b0) && (iWRITECYC == 1'b1))
    begin
      case (iHsizeMemBuf)
        2'b01 :
          // In this case the Counter has to be loaded with the value depending
          // on MW value.
          if (iMW == `MEM_BYTE)
            NextAhbWideWrCnt = 3'b010;
  
        2'b10 :
          // In this case the Counter has to be loaded with the value depending
          // on MW value.
          case (iMW)
            `MEM_BYTE :
               NextAhbWideWrCnt = 3'b100;
  
            `MEM_HWORD :
               NextAhbWideWrCnt = 3'b010;
    
            default :
              ;
          endcase
    
        default :
          ;
      endcase
    end
  else if ((ErrCond == 1'b0) && (iAhbWideWrCnt > 3'b000) &&
           (SlowClkM == 1'b1) && (AhbWiderWr == 1'b1) &&
           ((WaitWrCycVer == 1'b0) || (WaitWrCycDup == 1'b0)))
    NextAhbWideWrCnt = iAhbWideWrCnt - 3'b001;

  else if (ErrCond == 1'b1)
    NextAhbWideWrCnt = 3'b000;
end // p_AhbWdWrCntComb


// -----------------------------------------------------------------------------
// Generation of UseSecBuf:
// This signal should be set when the write was over on AHB side, but before
// this transfer is initiated on the Memory side HREADYOUTSMC is asserted.
// In this case there is every possibility that one more transfer which was
// pipelined, will overwrite the previous access information.
// To avoid this we need to buffer the previous access information, before a
// new transfer is honoured by AHB Slave.
// -----------------------------------------------------------------------------
always @(iUseSecBuf or DelWaitWrCycMux or WriteMask or SlowClkM or MemoryWrSt or
         iWRITECYC or DelWRITECYC or iIDLECYC or iNewBurst or
         DelBUSYCYC or SmCSTSM or AhbLessWrCnt or BurstWriteSt or BMWriteReg or
         iHtranRegCont or WriteBeatCnt or nSmBurstWaitReg or iHtransMemBuf1 or
         WaitEnReg or HsizeEqMWidthWr or DelIDLECYC or 
         SyncEnWriteReg or BurstPulse or iHREADYOUTSMC or
         WBstIntrptd or iAhbNarrow or UseSecBufExtd)
begin : p_UseSecBufComb
  NextUseSecBuf    = iUseSecBuf;
  if ((iUseSecBuf == 1'b0) && (iWRITECYC == 1'b1) && (WriteMask == 1'b0) &&
      ((DelWaitWrCycMux == 1'b0) ||
       ((nSmBurstWaitReg == 1'b0) && (SyncEnWriteReg == 1'b1) &&
        (HsizeEqMWidthWr == 1'b1) && (MemoryWrSt == 1'b1))))
    begin
      if (((MemoryWrSt == 1'b0) && (WriteMask == 1'b0)) ||
          ((MemoryWrSt == 1'b1) && (WriteMask == 1'b0) && (SmCSTSM == 1'b1) &&
           (DelBUSYCYC == 1'b0) && (DelIDLECYC == 1'b0) &&
           ((DelWRITECYC == 1'b0) ||
            (((iHtransMemBuf1 == `HTRANS_SEQ) ||
              (iHtransMemBuf1 == `HTRANS_NSEQ)) && (WaitEnReg == 1'b0)))) ||
          ((nSmBurstWaitReg == 1'b0) && (HsizeEqMWidthWr == 1'b1) &&
           (SyncEnWriteReg == 1'b1) && (DelIDLECYC == 1'b0) &&
           (DelBUSYCYC == 1'b0) && (iNewBurst == 1'b0)) ||
          ((BurstPulse == 1'b1) && (iUseSecBuf == 1'b0)) ||       
          ((BurstWriteSt == 1'b1) && (SlowClkM == 1'b1) &&
           (BMWriteReg == 1'b1) && (iNewBurst == 1'b0) &&
           (((WriteBeatCnt == 3'b000) && (iHtransMemBuf1[1] == 1'b1)) ||
            ((iHtransMemBuf1 == `HTRANS_NSEQ) && (HsizeEqMWidthWr == 1'b1)) ||
          ((WBstIntrptd == 1'b1) && (iHtransMemBuf1 == `HTRANS_SEQ) &&
           (iHREADYOUTSMC == 1'b1) && (iWRITECYC == 1'b1)))))
        NextUseSecBuf    = 1'b1;
      else if (UseSecBufExtd == 1'b0)
        NextUseSecBuf    = 1'b0;
    end
   else if (((AhbLessWrCnt != 3'b000) && (WriteMask == 1'b1) &&
          (iUseSecBuf == 1'b0) &&
          ((iIDLECYC == 1'b1) || (iNewBurst == 1'b1) || (AhbLessWrCnt == 3'b001) ||
           (iHtranRegCont == `HTRANS_IDLE) || (iHtranRegCont == `HTRANS_NSEQ))) ||
         ((WriteMask == 1'b1) && (iAhbNarrow == 1'b1) && (BurstWriteSt == 1'b1) &&
          (SlowClkM == 1'b1) && (iNewBurst == 1'b0) &&
          (iHtransMemBuf1 == `HTRANS_NSEQ) && (iHREADYOUTSMC == 1'b1)))
    NextUseSecBuf    = 1'b1;

  else if ((MemoryWrSt == 1'b1) && (nSmBurstWaitReg == 1'b1) &&
           (SmCSTSM == 1'b0) && (UseSecBufExtd == 1'b0))
    NextUseSecBuf    = 1'b0;
end // p_UseSecBufComb

// -----------------------------------------------------------------------------
// Second level registering of Bank Resources.
// -----------------------------------------------------------------------------
always @(AddrBuf2 or AddrValWrEn2 or AddrValWriteEn1
         or BIWriteEn1 or BIWriteEn2 or BMWrite1 or BMWrite2
         or BurstLenWr2 or BurstLenWrite1 or DelWriteMask
         or HselMemBuf2 or HsizeMemBuf2 or HwdataBuf1 or HwdataBuf2
         or IDCYC1 or IDCYC2 or MW1 or MW2 or NextUseSecBuf or RBLE1
         or RBLE2 or SMBLSPol1 or SMBLSPol2 or SyncEnWr2
         or SyncEnWrite1 or WP1 or WP2 or WSTWEN1 or WSTWEN2 or WSTWR1
         or WSTWR2 or WaitEn1 or WaitEn2 or WaitPol1 or WaitPol2
         or WriteMask or iAddrBuf1 or iHREADYOUTSMC
         or iHselMemBuf1 or iHsizeMemBuf1 or iHtranRegCont
         or iNewBurst or iUseSecBuf)
begin : p_SecLevRegComb
  NextSMBLSPol2    = SMBLSPol2;
  NextMW2          = MW2;
  NextBMWrite2     = BMWrite2;
  NextSyncEnWr2    = SyncEnWr2;
  NextBurstLenWr2  = BurstLenWr2;
  NextAddrValWrEn2 = AddrValWrEn2;
  NextBIWriteEn2   = BIWriteEn2;
  NextWP2          = WP2;
  NextRBLE2        = RBLE2;
  NextWaitEn2      = WaitEn2;
  NextWaitPol2     = WaitPol2;
  NextWSTWR2       = WSTWR2;
  NextWSTWEN2      = WSTWEN2;
  NextIDCYC2       = IDCYC2;
  NextAddrBuf2     = AddrBuf2;
  NextHwdataBuf2   = HwdataBuf2;
  NextHselMemBuf2  = HselMemBuf2;
  NextHsizeMemBuf2 = HsizeMemBuf2;
  if (((NextUseSecBuf == 1'b1) && (iUseSecBuf == 1'b0)) ||
       (((WriteMask == 1'b1) ||
         ((DelWriteMask == 1'b1) && (iUseSecBuf == 1'b1))) &&
        (iNewBurst == 1'b0) && (iHtranRegCont != `HTRANS_IDLE) &&
        (iHREADYOUTSMC == 1'b1)))
    begin
      NextSMBLSPol2    = SMBLSPol1;
      NextMW2          = MW1;
      NextBMWrite2     = BMWrite1;
      NextSyncEnWr2    = SyncEnWrite1;
      NextBurstLenWr2  = BurstLenWrite1;
      NextAddrValWrEn2 = AddrValWriteEn1;
      NextBIWriteEn2   = BIWriteEn1;
      NextWP2          = WP1;
      NextRBLE2        = RBLE1;
      NextWaitEn2      = WaitEn1;
      NextWaitPol2     = WaitPol1;
      NextWSTWR2       = WSTWR1;
      NextWSTWEN2      = WSTWEN1;
      NextIDCYC2       = IDCYC1;
      NextAddrBuf2     = iAddrBuf1;
      NextHwdataBuf2   = HwdataBuf1;
      NextHselMemBuf2  = iHselMemBuf1;
      NextHsizeMemBuf2 = iHsizeMemBuf1[1:0];
    end
end // p_SecLevRegComb

// -----------------------------------------------------------------------------
// Mux to select between First level and Second level registered bank resources.
// -----------------------------------------------------------------------------
always @(iUseSecBuf or MW2 or BMWrite2 or SyncEnWr2 or BurstLenWr2 or
         AddrValWrEn2 or WP2 or RBLE2 or WSTWR2 or WSTWEN2 or IDCYC2 or MW1 or
         BMWrite1 or SyncEnWrite1 or iAddrBuf1 or BurstLenWrite1 or 
         AddrValWriteEn1 or WP1 or RBLE1 or WSTWR1 or WSTWEN1 or IDCYC1 or
         HwdataBuf1 or iHsizeMemBuf1 or AddrBuf2 or HwdataBuf2 or HselMemBuf2 or
         HsizeMemBuf2 or iHselMemBuf1 or WaitEn1 or WaitEn2 or WaitPol1 or
         WaitPol2 or UseSecBufVer or BIWriteEn1 or BIWriteEn2 or SMBLSPol1 or
         SMBLSPol2)
begin : p_BankSelMux
  if ((iUseSecBuf == 1'b0) && (UseSecBufVer == 1'b0))
    begin
      SMBLSPol         = SMBLSPol1;
      iMW              = MW1;
      BMWrite          = BMWrite1;
      SyncEnWrite      = SyncEnWrite1;
      BurstLenWrite    = BurstLenWrite1;
      AddrValidWriteEn = AddrValWriteEn1;
      BIWriteEn        = BIWriteEn1;
      WP               = WP1;
      RBLE             = RBLE1;
      iWaitEn          = WaitEn1;
      WaitPol          = WaitPol1;
      WSTWR            = WSTWR1;
      WSTWEN           = WSTWEN1;
      IDCYC            = IDCYC1;
      AddrBuf          = iAddrBuf1;
      HwdataBufInt     = HwdataBuf1;
      iHselMemBuf      = iHselMemBuf1;
      iHsizeMemBuf     = iHsizeMemBuf1[1:0];
    end
  else
    begin
      SMBLSPol         = SMBLSPol2;
      iMW              = MW2;
      BMWrite          = BMWrite2;
      SyncEnWrite      = SyncEnWr2;
      BurstLenWrite    = BurstLenWr2;
      AddrValidWriteEn = AddrValWrEn2;
      BIWriteEn        = BIWriteEn2;
      WP               = WP2;
      RBLE             = RBLE2;
      iWaitEn          = WaitEn2;
      WaitPol          = WaitPol2;
      WSTWR            = WSTWR2;
      WSTWEN           = WSTWEN2;
      IDCYC            = IDCYC2;
      AddrBuf          = AddrBuf2;
      HwdataBufInt     = HwdataBuf2;
      iHselMemBuf      = HselMemBuf2;
      iHsizeMemBuf     = HsizeMemBuf2;
    end
end // p_BankSelMux

// -----------------------------------------------------------------------------
// Generation of WtWrFrstCycComb
// -----------------------------------------------------------------------------
always @(iWRITECYC or DelWRITECYC or iWaitEn or iBUSYCYC or MemoryWrSt or
         DelWaitWrCycMux or SmCSTSM or iNewBurst or WaitEnReg or iUseSecBuf or
         BurstWriteSt or DelWriteMask or SlowClkM or nSmBurstWaitReg or
         iAhbWideWrCnt or ErrCond)
begin : p_WtWrFrstCycMux
  WtWrFrstCycComb   = 1'b1;
  if ((iWRITECYC == 1'b1) && (DelWRITECYC == 1'b0) && (iWaitEn == 1'b0) &&
      (iUseSecBuf == 1'b0) && (ErrCond == 1'b0) &&
      ((iBUSYCYC == 1'b0) || (iNewBurst == 1'b1)))
    begin
      if ((MemoryWrSt == 1'b0) || (DelWaitWrCycMux == 1'b0) ||
          (SmCSTSM == 1'b1))
        WtWrFrstCycComb   = 1'b0;
      else
        WtWrFrstCycComb   = 1'b1;
    end

  // This condition was added for the case when Wait Enabled Write followed by
  // Normal Write. so that Posted write feature is maintained.
  // There can be a case where Wait enabled transfer was not waited, and there
  // is a normal write following it. In this case also we have to assert
  // WaitWrFirstCyc so that posted write feature is maintained.
  else if ((iWRITECYC == 1'b1) && (iWaitEn == 1'b0) && (ErrCond == 1'b0) &&
           (iNewBurst == 1'b1) && (iUseSecBuf == 1'b0) &&
           (((DelWriteMask == 1'b0) && (SmCSTSM == 1'b1) &&
             ((WaitEnReg == 1'b1) || (MemoryWrSt == 1'b0))) ||
            ((BurstWriteSt == 1'b1) && (DelWriteMask == 1'b0) &&
             (nSmBurstWaitReg == 1'b1) && (iAhbWideWrCnt <= 3'b001) &&
             (SlowClkM == 1'b1))))
    WtWrFrstCycComb   = 1'b0;
  else
    WtWrFrstCycComb   = 1'b1;
end // p_WtWrFrstCycMux

// -----------------------------------------------------------------------------
// When there is clock frequency mismatch, the WaitWrFirstCyc signal should be
// sustained till (SlowClkM = '0') condition is satisfied.
// -----------------------------------------------------------------------------
always @(WtWrFrstReg or WtWrFrstCycComb or SlowClkM)
begin : p_WtWrFrstCycComb
  NextWtWrFrstReg = WtWrFrstReg;
  if ((WtWrFrstCycComb == 1'b0) && (SlowClkM == 1'b0) && (WtWrFrstReg == 1'b1))
    NextWtWrFrstReg = 1'b0;
  else if (SlowClkM == 1'b1)
    NextWtWrFrstReg = 1'b1;
end // p_WtWrFrstCycComb

// -----------------------------------------------------------------------------
// Generation of WaitWrFirstCyc
// -----------------------------------------------------------------------------
assign WaitWrFirstCyc = WtWrFrstCycComb & WtWrFrstReg;

// -----------------------------------------------------------------------------
// Generation of WaitEnWrFirstCyc
// -----------------------------------------------------------------------------
assign WaitEnWrFirstCyc = ((iWRITECYC == 1'b1) && (iWaitEn == 1'b1) &&
                           (MemoryWrSt == 1'b0)) ? 1'b0 : 1'b1;

// -----------------------------------------------------------------------------
// Generation of WaitWrCycMux:
// When the AHB Slave SM enters the Write State for the first time from Read
// State or ST_MEM_NOT_SEL state then we have to finish the write transfers
// by inserting 1 wait state, provided if it is not a wait - enabled transfers.
// When the AHBWIDTH = MW then we have to route WaitWrCycVer on WaitWrCycMux.
// When AHBWIDTH < MW then until the (AhbLessWrCnt = "000") condition is sampled
// we have to toggle the WaitWrCycMux signal, but on (AhbLessWrCnt = "000")
// condition we have to route WaitWrCycVer.
// When AHBWIDTH > MW and until the condition (iAhbWideWrCnt <= "001") happens
// we have to hold WaitWrCycMux to logical 1 value. When the above condition
// is sampled we have to route WaitWrCycVer.
// To handle frequency mismatches SlowClkM signal is used suitably.
// -----------------------------------------------------------------------------
always @(WaitWrFirstCyc or HsizeEqMWidthWr or AhbWiderWr or AhbNarrowWr or
         iAhbWideWrCnt or WaitWrCycVer or SlowClkM or AhbLessWrCnt or
         iHREADYOUTSMC or iHsizeEqMWidth or iWaitEn or iAhbWider or
         iAhbNarrow or WaitEnReg or MemoryWrSt or iHtransMemBuf1 or 
         extracond or extracond1 or ValWrBrstSt)
begin : p_WaitWrCycMux
  WaitWrCycMux   = 1'b1;
  if (WaitWrFirstCyc == 1'b0)
    WaitWrCycMux = 1'b0 | ( ~SlowClkM);
  else
    begin
      if (MemoryWrSt == 1'b1)
        begin
          if (((HsizeEqMWidthWr == 1'b1) && (extracond == 1'b0) &&
               (extracond1 == 1'b0) &&
               ((iWaitEn == 1'b0) || (WaitEnReg == 1'b1))) ||
              ((AhbWiderWr == 1'b1) && (iAhbWideWrCnt <= 3'b001)))
            WaitWrCycMux     = WaitWrCycVer | ( ~SlowClkM) | ValWrBrstSt;
          else if ((AhbNarrowWr == 1'b1) && (AhbLessWrCnt == 3'b000))
            WaitWrCycMux     = WaitWrCycVer | ( ~SlowClkM);
          else if ((AhbNarrowWr == 1'b1) && (iHtransMemBuf1 == `HTRANS_SEQ))
            WaitWrCycMux     = iHREADYOUTSMC;
        end
      else
        begin
          if ((iHsizeEqMWidth == 1'b1) ||
              ((iAhbWider == 1'b1) && (iAhbWideWrCnt <= 3'b001)))
            WaitWrCycMux     = WaitWrCycVer | ( ~SlowClkM);
          else if ((iAhbNarrow == 1'b1) && (AhbLessWrCnt == 3'b000))
             WaitWrCycMux     = WaitWrCycVer | ( ~SlowClkM);
          else if ((iAhbNarrow == 1'b1) && (iHtransMemBuf1 == `HTRANS_SEQ))
             WaitWrCycMux     = iHREADYOUTSMC;
        end
    end
end // p_WaitWrCycMux

assign extracond =  (((iAhbNarrow && iHREADYOUTSMC &&
                       BurstWriteSt) == 1'b1) &&
                    (iHtransMemBuf1 == `HTRANS_NSEQ)) ? 1'b1 : 1'b0;

assign extracond1 = (((iHREADYOUTSMC && BurstWriteSt &&
                       iWRITECYC && DelWRITECYC) == 1'b1) &&
                      (ClockRatio == 2'b00) &&
                      ((WBstIntrptd == 1'b1) ||
                       (iHtransMemBuf1 == `HTRANS_NSEQ))) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of BurstPulse:
// This signal is generated for Synchronous Memories when nSmBurstWaitReg is
// asserted during write. Since to support Synchronous Burst write we assert
// HREADYOUTSMC 1 Clock early before we finish the actual write on Memory side,
// because of this condition there is every possibility that we will miss the
// data because of nSmBurstWaitReg assertion. To overcome this BurstPule is
// generated.
// -----------------------------------------------------------------------------
always @(DelWaitWrCycAhb or nSmBurstWaitReg or HsizeEqMWidthWr or MemoryWrSt or
         DelSmBurstWait or BurstWriteSt or SmCSTSM or iWRITECYC)
begin : p_BurstPulseComb
  BurstPulse       = 1'b0;
  if ((DelWaitWrCycAhb == 1'b0) ||
      ((BurstWriteSt == 1'b1) && (DelSmBurstWait == 1'b1)))
    if ((nSmBurstWaitReg == 1'b0) && (HsizeEqMWidthWr == 1'b1) &&
        (SmCSTSM == 1'b0) && (MemoryWrSt == 1'b1) && (iWRITECYC == 1'b1))
      BurstPulse       = 1'b1;
end // p_BurstPulseComb

// -----------------------------------------------------------------------------
// Generation of WaitAssrtd:
// This signal is useful in registering the HWDATASMC which might have got
// missed because of nSmBurstWaitReg assertion. This logic is valid only for 1:1
// frequency ratios.
// -----------------------------------------------------------------------------
always @(WaitAssrtd or BurstPulse or iHREADYOUTSMC or HwdataBuf3 or
         HwdataBuf1 or ClockRatio or iWRITECYC)
begin : p_WaitAssrtdComb
  NextWaitAssrtd   = WaitAssrtd;
  NextHwdataBuf3   = HwdataBuf3;
  if ((BurstPulse == 1'b1) && (ClockRatio == 2'b00))
    NextWaitAssrtd   = 1'b1;
  else if ((iHREADYOUTSMC == 1'b1) && (iWRITECYC == 1'b1))
    NextWaitAssrtd   = 1'b0;

  if (WaitAssrtd == 1'b1)
    NextHwdataBuf3   = HwdataBuf1;
end // p_WaitAssrtdComb

// -----------------------------------------------------------------------------
// Routing of appropriate HwdataBuf's.
// -----------------------------------------------------------------------------
assign HwdataBufMux     = ((WaitAssrtd == 1'b1) && (iUseSecBuf == 1'b0)) ?
                           HwdataBuf3 : HwdataBufInt;

always @(posedge HCLK or negedge HRESETn)
begin : p_DataOutSeq
  if (HRESETn == 1'b0)
    begin
      HwdataBufReg     <= {32{1'b0}};
    end
  else
    begin
      if (iUseSecBuf == 1'b0)
        begin
          HwdataBufReg   <= HwdataBufMux;
        end
    end
end // p_DataOutSeq

assign HwdataBuf = (iUseSecBuf == 1'b0) ? HwdataBufMux : HwdataBufReg;

// -----------------------------------------------------------------------------
// Generation of UseSecBufVer:
// This signal is used while performing Synchronous transfers. This is useful
// when we have to continue with normal bursts after nSmBurstWaitReg is
// de-asserted. As long as this signal is high we will be using the second
// level buffered resources, for memory accesses.
// -----------------------------------------------------------------------------
always @(UseSecBufVer or BurstPulse or BMWriteReg or
         HsizeEqMWidthWr or SmCSTSM or nSmBurstWaitReg or
         iWRITECYC or DelSmCSTSM or WriteBeatCnt)
begin : p_UseSecVerComb
  NextUseSecBufVer = UseSecBufVer;
  if ((BurstPulse == 1'b1) && (iWRITECYC == 1'b1) && (BMWriteReg == 1'b1) &&
      (HsizeEqMWidthWr == 1'b1))
    NextUseSecBufVer = 1'b1;
  else if ((((WriteBeatCnt == 3'b000) && (DelSmCSTSM == 1'b1)) ||
            ((WriteBeatCnt != 3'b000) && (nSmBurstWaitReg == 1'b1))) &&
           (SmCSTSM == 1'b0))
    NextUseSecBufVer = 1'b0;
end // p_UseSecVerComb

// -----------------------------------------------------------------------------
// Write Data Path Logic
// In this block the Data is Endianized before driving on HwdataBuf1 line.
// HwdataBuf1 is driven out based on iAddrBuf1, iHsizeMemBuf1 and BIGENDIAN
// signals.
// -----------------------------------------------------------------------------
always @(iHsizeMemBuf1 or BIGENDIAN or iAddrBuf1 or HWDATASMC or HwdataBuf1 or
         WaitWrCycMux or WaitWrCycDup or iWRITECYC or SlowClkM or
         WaitEnWrFirstCyc or HsizeEqMWidthWr or BMWriteReg or SmCSTSM or
         WriteBeatCnt or iHtranRegCont or SyncEnWriteReg or BurstWriteSt or
         iAhbWideWrCnt or BurstPulse or nSmBurstWaitReg or UseSecBufVer or
         iHREADYOUTSMC)
begin : p_AhbWrDataComb
  NextHwdataBuf1   = HwdataBuf1;
  if (((WaitWrCycMux == 1'b0) ||
       ((WaitWrCycDup == 1'b0) && (iAhbWideWrCnt <= 3'b001) &&
        (SlowClkM == 1'b1)) ||
       ((HsizeEqMWidthWr == 1'b1) && (BMWriteReg == 1'b1) &&
        (((SmCSTSM == 1'b0) && (SlowClkM == 1'b1)) ||
         (iHREADYOUTSMC == 1'b1)) &&
        (WriteBeatCnt == 3'b000) && (iHtranRegCont == `HTRANS_SEQ) &&
        (SyncEnWriteReg == 1'b1) && (BurstWriteSt == 1'b1) &&
        (nSmBurstWaitReg == 1'b1) && (UseSecBufVer == 1'b0)) ||
       (WaitEnWrFirstCyc == 1'b0) ||
       (BurstPulse == 1'b1)) &&
      (iWRITECYC == 1'b1))
  begin
    case (iHsizeMemBuf1[1:0])
      2'b00 :
        if (BIGENDIAN == 1'b0)
          begin
            case (iAddrBuf1[1:0])
              2'b00 : begin
                NextHwdataBuf1[7:0]   = HWDATASMC[7:0];
              end
              2'b01 : begin
                NextHwdataBuf1[15:8]  = HWDATASMC[15:8];
              end
              2'b10 : begin
                NextHwdataBuf1[23:16] = HWDATASMC[23:16];
              end
              2'b11 : begin
                NextHwdataBuf1[31:24] = HWDATASMC[31:24];
              end
              default :
                ;
            endcase
          end

        else
          begin
            case (iAddrBuf1[1:0])
              2'b11 : begin
                NextHwdataBuf1[7:0]   = HWDATASMC[7:0];
              end
              2'b10 : begin
                NextHwdataBuf1[15:8]  = HWDATASMC[15:8];
              end
              2'b01 : begin
                NextHwdataBuf1[23:16] = HWDATASMC[23:16];
              end
              2'b00 : begin
                NextHwdataBuf1[31:24] = HWDATASMC[31:24];
              end
              default :
                ;
            endcase
          end

      2'b01 :
        if (BIGENDIAN == 1'b0)
          case (iAddrBuf1[1])
            1'b0 : begin
              NextHwdataBuf1[15:0]  = HWDATASMC[15:0];
            end
            1'b1 : begin
              NextHwdataBuf1[31:16] = HWDATASMC[31:16];
            end
            default :
              ;
          endcase

        else
          case (iAddrBuf1[1])
            1'b1 : begin
              NextHwdataBuf1[15:0]  = HWDATASMC[15:0];
            end
            1'b0 : begin
              NextHwdataBuf1[31:16] = HWDATASMC[31:16];
            end
            default :
              ;
          endcase

      2'b10 : begin
        NextHwdataBuf1[31:0] = HWDATASMC[31:0];
      end
      default :
        ;
    endcase
  end
end // p_AhbWrDataComb

// -----------------------------------------------------------------------------
// Read Data Path Logic
// In this block the Data is Endianized before driving on HRDATASMC line.
// Endianization is done based on BIGENDIAN, Memory Width and SmAddrTSM signals.
// -----------------------------------------------------------------------------
always @(iHRDATASMC or iMW or MemoryRdSt or BIGENDIAN or SlowClkM or
         SmDataInFbClk or WaitRdCyc or SmAddrTSM)
begin : p_ReadDataComb
  NextHrdataSmc    = iHRDATASMC;
  if ((MemoryRdSt == 1'b1) && (WaitRdCyc == 1'b0) && (SlowClkM == 1'b1))
    begin
      if (BIGENDIAN == 1'b0)
        begin
          case (iMW)
            2'b00 :
              case (SmAddrTSM)
                2'b00 :
                  NextHrdataSmc[7:0] = SmDataInFbClk[7:0];
  
                2'b01 :
                  NextHrdataSmc[15:8] = SmDataInFbClk[7:0];
  
                2'b10 :
                  NextHrdataSmc[23:16] = SmDataInFbClk[7:0];
  
                2'b11 :
                  NextHrdataSmc[31:24] = SmDataInFbClk[7:0];
    
                default :
                  ;
              endcase
  
            2'b01 :
              case (SmAddrTSM[1])
                1'b0 :
                  NextHrdataSmc[15:0] = SmDataInFbClk[15:0];
  
                1'b1 :
                  NextHrdataSmc[31:16] = SmDataInFbClk[15:0];
    
                default :
                  ;
              endcase
  
            2'b10 :
              NextHrdataSmc[31:0] = SmDataInFbClk[31:0];
    
            default :
              ;
          endcase
        end

      // For BIGENDIAN Transfers
      else
        begin
          case (iMW)
            2'b00 :
              case (SmAddrTSM)
                2'b11 :
                  NextHrdataSmc[7:0] = SmDataInFbClk[7:0];
  
                2'b10 :
                  NextHrdataSmc[15:8] = SmDataInFbClk[7:0];
  
                2'b01 :
                  NextHrdataSmc[23:16] = SmDataInFbClk[7:0];
  
                2'b00 :
                  NextHrdataSmc[31:24] = SmDataInFbClk[7:0];
    
                default :
                  ;
              endcase
  
            2'b01 :
              case (SmAddrTSM[1])
                1'b1 :
                  NextHrdataSmc[15:0] = SmDataInFbClk[15:0];

                1'b0 :
                  NextHrdataSmc[31:16] = SmDataInFbClk[15:0];
    
                default :
                  ;
              endcase
  
            2'b10 :
              NextHrdataSmc[31:0] = SmDataInFbClk[31:0];
    
            default :
              ;
          endcase
        end
    end
end // p_ReadDataComb

// -----------------------------------------------------------------------------
// Registering all Next state signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_AhbRegSeq
  if (HRESETn == 1'b0)
    begin
      SmMemSlaveState  <= `ST_MEM_NOT_SEL;
      iHREADYOUTSMC    <= 1'b1;
      DelHreadyOut     <= 1'b0;
      iHRESPSMC        <= `HRESP_OKAY;
      iAddrBuf1        <= 26'b00000000000000000000000000;
      AddrBuf2         <= 26'b00000000000000000000000000;
      iHtransMemBuf1   <= 2'b00;
      iHburstMemBuf    <= 3'b000;
      iHsizeMemBuf1    <= 2'b00;
      HsizeMemBuf2     <= 2'b00;
      DelWRITECYC      <= 1'b0;
      DelREADCYC       <= 1'b0;
      DelBUSYCYC       <= 1'b0;
      iHtranRegCont    <= 2'b00;
      MemRdMaskReg     <= 1'b0;
      DelMemRdMaskReg  <= 1'b0;
      MemRdBusy        <= 1'b0;
      iAhbWideRdCnt    <= 3'b000;
      AhbLessRdCnt     <= 3'b000;
      WriteRqBuf       <= 1'b0;
      WriteMaskBuf     <= 1'b0;
      iAhbWideWrCnt    <= 3'b000;
      AhbLessWrCnt     <= 3'b000;
      iUseSecBuf       <= 1'b0;
      SMBLSPol2        <= 1'b0;
      MW2              <= 2'b00;
      BMWrite2         <= 1'b0;
      SyncEnWr2        <= 1'b0;
      BurstLenWr2      <= 2'b00;
      AddrValWrEn2     <= 1'b0;
      BIWriteEn2       <= 1'b0;
      WP2              <= 1'b0;
      RBLE2            <= 1'b0;
      WaitEn2          <= 1'b0;
      WaitPol2         <= 1'b0;
      WSTWR2           <= 5'b00000;
      WSTWEN2          <= 4'b0000;
      IDCYC2           <= 4'b0000;
      HwdataBuf1       <= 32'b00000000000000000000000000000000;
      HwdataBuf2       <= 32'b00000000000000000000000000000000;
      iHselMemBuf1     <= 8'b00000000;
      HselMemBuf2      <= 8'b00000000;
      DelWaitWrCycMux  <= 1'b0;
      DelHselMemBuf1   <= 8'b00000000;
      DelWriteMask     <= 1'b0;
      AddrNotAlignReg  <= 1'b0;
      ValByteLane0     <= 1'b0;
      ValByteLane1     <= 1'b0;
      ValByteLane2     <= 1'b0;
      ValByteLane3     <= 1'b0;
      iHRDATASMC       <= 32'b00000000000000000000000000000000;
      NewBrstReg       <= 1'b0;
      TurnArndReg      <= 1'b0;
      AddrNotAlgnRd    <= 1'b0;
      DelSmBurstWait   <= 1'b1;
      HwdataBuf3       <= 32'b00000000000000000000000000000000;
      DelWaitWrCycAhb  <= 1'b1;
      UseSecBufVer     <= 1'b0;
      WaitAssrtd       <= 1'b0;
      DelIDLECYC       <= 1'b0;
      DelAhbLessRdCnt  <= 3'b000;
      BsyLstBt         <= 1'b0;
      WtWrFrstReg      <= 1'b1;
      ValWrBrstSt      <= 1'b0;
    end
  else
    begin
      SmMemSlaveState  <= NextSmMemSlaveSt;
      iHREADYOUTSMC    <= NextHREADYOUTSMC;
      DelHreadyOut     <= iHREADYOUTSMC;
      iHRESPSMC        <= NextHRESPSMC;
      iAddrBuf1        <= NextAddrBuf1;
      AddrBuf2         <= NextAddrBuf2;
      iHtransMemBuf1   <= NxtHtransMemBuf1;
      iHburstMemBuf    <= NxtHburstMemBuf;
      iHsizeMemBuf1    <= NextHsizeMemBuf1;
      HsizeMemBuf2     <= NextHsizeMemBuf2;
      DelWRITECYC      <= iWRITECYC;
      DelREADCYC       <= READCYC;
      DelBUSYCYC       <= iBUSYCYC;
      iHtranRegCont    <= HTRANSSMC;
      MemRdMaskReg     <= NextMemRdMaskReg;
      DelMemRdMaskReg  <= MemRdMaskReg;
      MemRdBusy        <= NextMemRdBusy;
      iAhbWideRdCnt    <= NextAhbWideRdCnt;
      AhbLessRdCnt     <= NextAhbLessRdCnt;
      WriteRqBuf       <= NextWriteRqBuf;
      WriteMaskBuf     <= NextWriteMaskBuf;
      iAhbWideWrCnt    <= NextAhbWideWrCnt;
      AhbLessWrCnt     <= NextAhbLessWrCnt;
      iUseSecBuf       <= NextUseSecBuf;
      SMBLSPol2        <= NextSMBLSPol2;
      MW2              <= NextMW2;
      BMWrite2         <= NextBMWrite2;
      SyncEnWr2        <= NextSyncEnWr2;
      BurstLenWr2      <= NextBurstLenWr2;
      AddrValWrEn2     <= NextAddrValWrEn2;
      BIWriteEn2       <= NextBIWriteEn2;
      WP2              <= NextWP2;
      RBLE2            <= NextRBLE2;
      WaitEn2          <= NextWaitEn2;
      WaitPol2         <= NextWaitPol2;
      WSTWR2           <= NextWSTWR2;
      WSTWEN2          <= NextWSTWEN2;
      IDCYC2           <= NextIDCYC2;
      HwdataBuf1       <= NextHwdataBuf1;
      HwdataBuf2       <= NextHwdataBuf2;
      iHselMemBuf1     <= NextHselMemBuf1;
      HselMemBuf2      <= NextHselMemBuf2;
      DelWaitWrCycMux  <= WaitWrCycMux;
      DelHselMemBuf1   <= iHselMemBuf1;
      DelWriteMask     <= WriteMask;
      AddrNotAlignReg  <= NextAddrNotAlign;
      ValByteLane0     <= iNxtValByteLane0;
      ValByteLane1     <= iNxtValByteLane1;
      ValByteLane2     <= iNxtValByteLane2;
      ValByteLane3     <= iNxtValByteLane3;
      iHRDATASMC       <= NextHrdataSmc;
      NewBrstReg       <= NextNewBrstReg;
      TurnArndReg      <= NextTurnArndReg;
      AddrNotAlgnRd    <= NextAddrAlgnRd;
      DelSmBurstWait   <= nSmBurstWaitReg;
      HwdataBuf3       <= NextHwdataBuf3;
      DelWaitWrCycAhb  <= WaitWrCycAhbMux;
      UseSecBufVer     <= NextUseSecBufVer;
      WaitAssrtd       <= NextWaitAssrtd;
      DelIDLECYC       <= iIDLECYC;
      DelAhbLessRdCnt  <= AhbLessRdCnt;
      BsyLstBt         <= NextBsyLstBt;
      WtWrFrstReg      <= NextWtWrFrstReg;
      ValWrBrstSt      <= NextValWrBrstSt;
    end
end // p_AhbRegSeq

endmodule
// --================================== End ==================================--
