// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrChLogic.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Dmac Channel logic block
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrChLogic (
// Inputs
                      HCLK,
                      HRESETn,
                      ChComb1,
                      ChComb2,
                      ChSrcAddrWrEn,
                      ChDstAddrWrEn,
                      ChControlWrEn,
                      ChLLIWrEn,
                      ChConfigWrEn,
                      HWDATA,
                      HRDATAM1,
                      HRDATAM2,
                      DataValid1,
                      DataValid2,
                      MREADY1,
                      MREADY2,
                      ErrorMas1,
                      ErrorMas2,
                      DisAckMas1,
                      DisAckMas2,
                      MasterEndian1,
                      MasterEndian2,
                      DMACBREQ,
                      DMACSREQ,
                      DMACLBREQ,
                      DMACLSREQ,
                      SOFTBREQ,
                      SOFTLBREQ,
                      SOFTSREQ,
                      SOFTLSREQ,
                      DMACEn,
                      DmacTrEn,
                      ClrIntTC,
                      ClrIntErr,
// Outputs
                      ChReqArb1,
                      ChReqArb2,
                      ChDisableBus1,
                      ChDisableBus2,
                      HWDATA1,
                      HWDATA2,
                      ChAddrBus1,
                      ChAddrBus2,
                      ChHLockBus1,
                      ChHLockBus2,
                      ChHProtBus1,
                      ChHProtBus2,
                      ChBeatCntBus1,
                      ChBeatCntBus2,
                      ChAddrIncr1,
                      ChAddrIncr2,
                      ChWRITEBus1,
                      ChWRITEBus2,
                      ChHSIZEBus1,
                      ChHSIZEBus2,
                      ChIntTC,
                      ChIntErr,
                      SOFTCLR,
                      DMACTC,
                      DMACCLR
                      );

// Inputs
input         HCLK;          // AHB clock
input         HRESETn;       // AHB reset
input         ChComb1;       // Channel grant signal from Arb1
input         ChComb2;       // Channel grant signal from Arb2
input         ChSrcAddrWrEn; // Source RegWrEn from Slave
input         ChDstAddrWrEn; // Dstn RegWrEn from Slave
input         ChControlWrEn; // Control RegWrEn from Slave
input         ChLLIWrEn;     // LLI RegWrEn from Slave
input         ChConfigWrEn;  // Config RegWrEn from Slave
input  [31:0] HWDATA;        // AHB Write Data bus from Slave
input  [31:0] HRDATAM1;      // AHB read Data Bus1
input  [31:0] HRDATAM2;      // AHB read Data Bus2
input         DataValid1;    // DataValid from Master1
input         DataValid2;    // DataValid from Master2
input         MREADY1;       // MREADY routed from AHBLite1
input         MREADY2;       // MREADY routed from AHBLite2
input         ErrorMas1;     // Error indication from Master1
input         ErrorMas2;     // Error indication from Master2
input         DisAckMas1;    // Disable Ack from Master1
input         DisAckMas2;    // Disable Ack from Master2
input         MasterEndian1; // Endianness for Master1
input         MasterEndian2; // Endianness for Master2
input  [15:0] DMACBREQ;      // DMAC Burst request
input  [15:0] DMACSREQ;      // DMAC Single request
input  [15:0] DMACLBREQ;     // DMAC Last Burst request
input  [15:0] DMACLSREQ;     // DMAC Last Single request
input  [15:0] SOFTBREQ;      // DMAC Soft Burst request
input  [15:0] SOFTLBREQ;     // DMAC Soft Last Burst request
input  [15:0] SOFTSREQ;      // DMAC Soft Single request
input  [15:0] SOFTLSREQ;     // DMAC Soft Last Single request
input         DMACEn;        // DMAC Controller Enable
input         DmacTrEn;      // Trickbox Enable
input         ClrIntTC;      // TC Interrupt clear for channel
input         ClrIntErr;     // Error Interrupt clear for channel

// Outputs
output        ChReqArb1;     // Channel Req to Arb1
output        ChReqArb2;     // Channel Req to Arb2
output        ChDisableBus1; // Channel disable signal for Mas1
output        ChDisableBus2; // Channel disable signal for Mas2
output [31:0] HWDATA1;       // AHB Write Data Bus1
output [31:0] HWDATA2;       // AHB Write Data Bus2
output [31:0] ChAddrBus1;    // Channel Address on Bus1
output [31:0] ChAddrBus2;    // Channel Address on Bus2
output        ChHLockBus1;   // HLOCK signal on Bus1
output        ChHLockBus2;   // HLOCK signal on Bus2
output  [3:0] ChHProtBus1;   // HPROT signal on Bus1
output  [3:0] ChHProtBus2;   // HPROT signal on Bus2
output  [4:0] ChBeatCntBus1; // BeatCount for Master1
output  [4:0] ChBeatCntBus2; // BeatCount for Master2
output        ChAddrIncr1;   // Channel Increment for Master1
output        ChAddrIncr2;   // Channel Increment for Master2
output        ChWRITEBus1;   // HWRITE information for Bus1
output        ChWRITEBus2;   // HWRITE information for Bus2
output  [2:0] ChHSIZEBus1;   // HSIZE information for Bus1
output  [2:0] ChHSIZEBus2;   // HSIZE information for Bus2
output        ChIntTC;       // Channel Interrupt for TC
output        ChIntErr;      // Channel Interrupt for Error
output [15:0] SOFTCLR;       // Soft Request Clear signal
output [15:0] DMACTC;        // DMACTC signal
output [15:0] DMACCLR;       // DMACCLR signal




// Inputs
  wire        HCLK;          // AHB clock
  wire        HRESETn;       // AHB reset
  wire        ChComb1;       // Channel grant signal from Arb1
  wire        ChComb2;       // Channel grant signal from Arb2
  wire        ChSrcAddrWrEn; // Source RegWrEn from Slave
  wire        ChDstAddrWrEn; // Dstn RegWrEn from Slave
  wire        ChControlWrEn; // Control RegWrEn from Slave
  wire        ChLLIWrEn;     // LLI RegWrEn from Slave
  wire        ChConfigWrEn;  // Config RegWrEn from Slave
  wire [31:0] HWDATA;        // AHB Write Data bus from Slave
  wire [31:0] HRDATAM1;      // AHB read Data Bus1
  wire [31:0] HRDATAM2;      // AHB read Data Bus2
  wire        DataValid1;    // DataValid from Master1
  wire        DataValid2;    // DataValid from Master2
  wire        MREADY1;       // MREADY routed from AHBLite1
  wire        MREADY2;       // MREADY routed from AHBLite2
  wire        ErrorMas1;     // Error indication from Master1
  wire        ErrorMas2;     // Error indication from Master2
  wire        DisAckMas1;    // Disable Ack from Master1
  wire        DisAckMas2;    // Disable Ack from Master2
  wire        MasterEndian1; // Endianness for Master1
  wire        MasterEndian2; // Endianness for Master2
  wire [15:0] DMACBREQ;      // DMAC Burst request
  wire [15:0] DMACSREQ;      // DMAC Single request
  wire [15:0] DMACLBREQ;     // DMAC Last Burst request
  wire [15:0] DMACLSREQ;     // DMAC Last Single request
  wire [15:0] SOFTBREQ;      // DMAC Soft Burst request
  wire [15:0] SOFTLBREQ;     // DMAC Soft Last Burst request
  wire [15:0] SOFTSREQ;      // DMAC Soft Single request
  wire [15:0] SOFTLSREQ;     // DMAC Soft Last Single request
  wire        DMACEn;        // DMAC Controller Enable
  wire        DmacTrEn;      // Trickbox Enable
  wire        ClrIntTC;      // TC Interrupt clear for channel
  wire        ClrIntErr;     // Error Interrupt clear for channel

// Outputs
  reg         ChReqArb1;     // Channel Req to Arb1
  reg         ChReqArb2;     // Channel Req to Arb2
  wire        ChDisableBus1; // Channel disable signal for Mas1
  wire        ChDisableBus2; // Channel disable signal for Mas2
  wire [31:0] HWDATA1;       // AHB Write Data Bus1
  wire [31:0] HWDATA2;       // AHB Write Data Bus2
  reg  [31:0] ChAddrBus1;    // Channel Address on Bus1
  reg  [31:0] ChAddrBus2;    // Channel Address on Bus2
  reg         ChHLockBus1;   // HLOCK signal on Bus1
  reg         ChHLockBus2;   // HLOCK signal on Bus2
  reg   [3:0] ChHProtBus1;   // HPROT signal on Bus1
  reg   [3:0] ChHProtBus2;   // HPROT signal on Bus2
  reg   [4:0] ChBeatCntBus1; // BeatCount for Master1
  reg   [4:0] ChBeatCntBus2; // BeatCount for Master2
  reg         ChAddrIncr1;   // Channel Increment for Master1
  reg         ChAddrIncr2;   // Channel Increment for Master2
  reg         ChWRITEBus1;   // HWRITE information for Bus1
  reg         ChWRITEBus2;   // HWRITE information for Bus2
  reg   [2:0] ChHSIZEBus1;   // HSIZE information for Bus1
  reg   [2:0] ChHSIZEBus2;   // HSIZE information for Bus2
  wire        ChIntTC;       // Channel Interrupt for TC
  reg         ChIntErr;      // Channel Interrupt for Error
  reg  [15:0] SOFTCLR;       // Soft Request Clear signal
  reg  [15:0] DMACTC;        // DMACTC signal
  reg  [15:0] DMACCLR;       // DMACCLR signal

integer i;
// -----------------------------------------------------------------------------
//
//                                DmacTrChLogic
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module is responsible for carrying out all channel related activities
// like, updating channel registers, generating interrupts, generating DMACCLR
// and DMACTC, loading the Burst and TC counters, moving the data from FIFO to
// peripheral and vice - versa. This module consists of a Channel SM whose
// state bit is used to control most of the activities.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        SrcReqCh;
// Source request signal

wire        DstReqCh;
// Destination request signal

wire  [3:0] SrcReg;
// Encoded value for source peripheral

wire  [3:0] DstReg;
// Encoded value for destination peripheral

wire  [2:0] SrcBusWidth;
// Increment value based on source peripheral bus width

wire  [2:0] SrcWidth;
// Encoded value for source bus width

wire  [2:0] DstBusWidth;
// Increment value based on destination peripheral bus width

wire  [2:0] DstWidth;
// Encoded value for destination bus width

wire  [2:0] SrcBurstSize;
// Encoded value for source burst size

wire  [2:0] DstBurstSize;
// Encoded value for destination burst size

wire  [2:0] FlowCntl;
// Encoded value for Flow Controller

wire        SameBus;
// Indication that peripheral on same bus

wire        DiffBus;
// Indication that peripheral on different bus

wire        SrcAhbMasSel;
// Source AHB select

wire        NextDelDstRq;
// D-Input of DelDstRqBefMask

wire        DstAhbMasSel;
// Destination AHB select

wire        NextLLIAhbMasSel;
// D-Input of LLIAhbMasSel

wire [29:0] LLILoad;
// Indication of LLI Load

wire        SrcIncrBit;
// Source increment signal

wire        SrcLstOccrd;
// Indication of source last occurred when source is flow controller

wire        DstLstOccrd;
// Indication of Destination last occurred when destination is flow controller

wire        DstIncrBit;
// Destination increment signal

wire        ChEnable;
// Channel enable signal

wire  [4:0] DMAFIFOLevel;
// DMAFifoLevel in bytes. This Fifo Level is in Sync with UUT during Source Txrs

wire  [4:0] ActFifoLevel;
// DMAFifoLevel in bytes. This Fifo Level is based on DataValid's Received.

wire [13:0] SrcBurstCh;
// vector to decide the loading of source counters

wire [13:0] SrcBurstChNxt;
// vector to decide the loading of source counters

wire        DstLstSrc;
// Indication as to Destination last has occurred

wire [13:0] DstBurstCh;
// vector to decide the loading of Destination counters

wire [13:0] DstBurstChNxt;
// vector to decide the loading of Destination counters

wire        BstRqSrc;
// Burst request for Source Peripheral

wire        SglRqSrc;
// Single request for Source Peripheral

wire        BstRqDst;
// Burst request for Destination Peripheral

wire        SglRqDst;
// Single request for Destination Peripheral

wire        BstRqSrcAll;
// Burst request for Source Peripheral including Last DMAC request

wire        SglRqSrcAll;
// Single request for Source Peripheral including Last DMAC request

wire        BstRqDstAll;
// Burst request for Destination Peripheral including Last DMAC request

wire        SglRqDstAll;
// Single request for Destination Peripheral including Last DMAC request

wire  [2:0] ReqConcat;
// Concatenation of all request

wire        ZERO_1 = 1'b0;
// 1 bit LOW signal

wire        ONE_1 = 1'b1;
// 1 bit HIGH signal

wire  [1:0] AddrOffSetSrc;
// Address offset for endianization

wire        SrcErrMask;
// Mask for source error

wire        DstErrMask;
// Mask for destination error

wire        ChHalt;
// Channel halt indication

wire        DstDisAckOccrd;
// Ack occurred for destination Transfer

wire        SrcDisAckOccrd;
// Ack occurred for source Transfer

wire        LLIDisAckOccrd;
// Ack occurred for LLI Transfer

wire        IntMask;
// Mask for channel Interrupt

wire        ErrMask;
// Mask for Error Interrupt

wire        ChDisable;
// Channel disable indication

wire        SrcMskDstFlow;
// Source mask when Destination is the Flow Controller

wire        SrcDisAckTemp;
// Temp Signal for Disable

wire        DstDisAckTemp;
// Temp Signal for Disable

wire        SrcState;
// Signal to indicate SM is in Source Transfer State

wire        DstState;
// Signal to indicate SM is in Destination Transfer State

wire [31:0] NextHwdataBuff1;
// D-Input of HwdataBuff1

wire [31:0] NextHwdataBuff2;
// D-Input of HwdataBuff2

wire        SingleBusErr;
// Error on Single Bus Indication

wire        DualBusErr;
// Error on Dual Bus Indication

wire [31:0] iHWDATA1;
// Internal copy of HWDATA1;

wire [31:0] iHWDATA2;
// Internal copy of HWDATA2;

wire        LLIErrMask;
// Or of LLIErrOccrd and NextLLIErrOccrd

wire        NotValidDataSrc;
// Not Valid signal for Source Transfers

wire        NotValidDataDst;
// Not Valid signal for Destination Transfers

wire        NotValidDataLLI;
// Not Valid signal for LLI Transfers

wire        ValidDataSrc;
// Valid Data for Source Transfer

wire        ValidDataDst;
// Valid Data for Destination Transfer

wire        ValidDataLLI;
// Valid Data for LLI Transfer

wire        Pulse1;
// Disable Ack indication

wire        Pulse2;
// Disable Ack indication

wire        Pulse3;
// Disable Ack indication

wire        Pulse4;
// Disable Ack indication

wire        Pulse5;
// Disable Ack indication

// [vhdl2vlog] The following line is NOT modified.
reg  [7:0] FifoReg [15:0];
// Two dimensional array

// [vhdl2vlog] The following line is NOT modified.
reg  [7:0] NextFifoReg [15:0];
// D-Input of FifoReg

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg  [31:0] ChSrcAddrReg;
// Source Address register

reg  [31:0] NextChSrcAddrReg;
// D-Input of Source Address register

reg  [31:0] ChDstAddrReg;
// Destination Address register

reg  [31:0] NextChDstAddrReg;
// D-Input of Destination Address register

reg  [31:0] ChControlReg;
// Channel Control register

reg  [31:0] NextChControlReg;
// D-Input of Channel Control register

reg  [31:0] ChLLIReg;
// LLI register

reg  [31:0] NextChLLIReg;
// D-Input of LLI register

reg  [31:0] ChConfigReg;
// Channel Config register

reg  [31:0] NextChConfigReg;
// D-Input of Channel Config register

reg         DstSelComb;
// Destination select signal

reg         SrcSelComb;
// Source select signal

reg         LLISelComb;
// LLI select signal

reg         LLISelReg;
// Register to indicate that LLI is selected

reg         NextLLISelReg;
// D-Input of LLISelReg

reg         SrcTxrOn;
// Indication of source transfer when peripheral are on different bus

reg         NextSrcTxrOn;
// D-Input of SrcTxrOn reg

reg         DstTxrOn;
// Indication of destination transfer when peripheral are on different bus

reg         NextDstTxrOn;
// D-Input of SrcTxrOn reg

reg   [4:0] ChannelState;
// Channel State register

reg   [4:0] NextChState;
// D-Input of Channel State register

reg  [13:0] SourceTC;
// SourceTC counter

reg  [13:0] NextSourceTC;
// D-Input of SourceTC register

reg  [13:0] SrcTCDstFlow;
// SourceTC counter

reg  [13:0] NxtSrcTCDstFlow;
// D-Input of SrcTCDstFlow counter

reg  [13:0] DstTC;
// Destination TC counter

reg  [13:0] NextDstTC;
// D-Input of DstTC register

reg  [13:0] DstTCSrcFlow;
// Destination TC counter

reg  [13:0] NxtDstTCSrcFlow;
// Destination TC counter

reg  [13:0] SrcBurst;
// SrcBurst counter

reg  [13:0] NextSrcBurst;
// D-Input of SrcBurst register

reg  [13:0] DstBurst;
// DstBurst counter

reg  [13:0] NextDstBurst;
// D-Input of DstBurst register

reg   [2:0] FactorOnDstNum;
// Factor calculation based on Destination width

reg   [2:0] FactorOnDstDen;
// Factor calculation based on Destination width

reg   [2:0] FactorOnSrcNum;
// Factor calculation based on Source width

reg   [2:0] FactorOnSrcDen;
// Factor calculation based on Source width

reg   [1:0] TwoBitCnt;
// Two bit counter to help LLI Load

reg   [1:0] NextTwoBitCnt;
// D-Input of TwoBitCnt reg

reg         SrcReqBefMask;
// Source request before mask

reg         DstReqBefMask;
// Destination request before mask

reg         DstFlowReq;
// Destination request before Delaying

reg         DelDstFlowReq;
// Destination request after Delaying during destination flow control

reg         DelChEnable;
// Delayed Channel Enable

reg         DelDstRqBefMask;
// Destination request before mask

reg         LLIReq;
// LLI request

reg         LLIAhbMasSel;
// LLI AHB select

reg         SrcMask;
// Mask for source request

reg         SrcLstOccrdReg;
// Registered signal of SrcLstOccrd

reg         NextSrcLstOccrd;
// D-Input of SrcLstOccrdReg register

reg         DstMask;
// Mask for destination request

reg         DstLstOccrdReg;
// Registered signal of DstLstOccrd

reg         NextDstLstOccrd;
// D-Input of DstLstOccrdReg register

reg         ChSrcMas1WrEn;
// Src write enable during LLI load from Master1

reg         ChSrcMas2WrEn;
// Src write enable during LLI load from Master2

reg         ChDstMas1WrEn;
// Destination write enable during LLI load from Master1

reg         ChDstMas2WrEn;
// Destination write enable during LLI load from Master2

reg         ChCtrlMas1WrEn;
// Control write enable during LLI load from Master1

reg         ChCtrlMas2WrEn;
// Control write enable during LLI load from Master2

reg         ChLLIMas1WrEn;
// LLI reg write enable during LLI load from Master1

reg         ChLLIMas2WrEn;
// LLI reg write enable during LLI load from Master2

reg   [4:0] ActFifoLevDel;
// DMAFifoLevel in bytes. This is 1HCLK delayed version of ActFifoLevel

reg         SrcMaskReg;
// Register to hold that Source is selected when SM is in active state

reg         NextSrcMaskReg;
// D-Input of SrcMaskReg

reg         SrcLoadComb;
// Indication to load the counters combinationally for source

reg         DstLoadComb;
// Indication to load the counters combinationally for destination

reg  [13:0] SrcBstDstFlow;
// Source burst counter when destination is flow controller

reg  [13:0] NxtSrcBstDstFlow;
// D-Input of SrcBstDstFlow counter

reg         DstLstSrcReg;
// Register signal of DstLstSrc

reg         NextDstLstSrc;
// D-input of DstLstSrcReg register

reg   [4:0] SrcBeat;
// Source beat counter for channel

reg   [4:0] NextSrcBeat;
// D-Input of SrcBeat counter

reg  [13:0] DstBstSrcFlow;
// Destination burst counter when source is flow controller

reg  [13:0] NxtDstBstSrcFlow;
// D-Input of DstBstSrcFlow counter

reg   [4:0] DstBeat;
// Destination beat counter for channel

reg   [4:0] NextDstBeat;
// D-Input of DstBeat Reg

reg   [4:0] DstBeatCopy;
// Destination beat counter copy for Synchronizing with UUT.

reg   [4:0] NextDstBeatCopy;
// D-Input of DstBeatCopy

reg   [2:0] LLIBeat;
// LLI beat counter for channel

reg   [2:0] NextLLIBeat;
// D-Input of LLIBeat Reg

reg         SrcSelReg;
// Information as to source is selected when SM is in active state

reg         NextSrcSelReg;
// D-Input of SrcSelReg

reg         DstSelReg;
// Information as to destination is selected when SM is in active state

reg         NextDstSelReg;
// D-Input of DstSelReg

reg  [15:0] iDMACTC;
// Internal copy of DMACTC

reg  [15:0] NextDMACTC;
// D-Input of iDMACTC register

reg  [15:0] iDMACCLR;
// Internal copy of DMACCLR

reg  [15:0] NextDMACCLR;
// D-Input of iDMACCLR register

reg         SoftClrPulse;
// D-Input of SoftClrPulse register

reg         NextSoftClrPulse;
// D-Input of SoftClrPulse register

reg  [15:0] DMACTCDel;
// Delayed DMACTC

reg  [15:0] DMACCLRDel;
// Delayed DMACCLR by 1HCLK

reg  [15:0] DMACCLR2Del;
// Delayed DMACCLR by 2HCLK

reg   [3:0] WrPtr;
// Fifo write pointer

reg   [3:0] NextWrPtr;
// D-Input of write pointer

reg         Wrap;
// Wrap indication for FIFO

reg         NextWrap;
// D-Input of Wrap Register

reg         SrcErrOccrd;
// Registered version of SrcErrMask

reg         NextSrcErrOccrd;
// D-Input of SrcErrOccrd Reg

reg         DstErrOccrd;
// Registered version of DstErrMask

reg         NextDstErrOccrd;
// D-Input of DstErrOccrd Reg

reg         ChHaltReg;
// Registered ChHalt signal

reg         NextChHalt;
// D-Input of ChHaltReg

reg         ChIntReg;
// Registered version of channel TC Interrupt

reg         NextChIntReg;
// D-input of ChIntReg

reg         iChIntErr;
// internal copy of ChIntErr

reg         NextChIntErr;
// D-input of iChIntErr

reg         ChIntErrDel1;
// Delayed version of iChIntErr

reg         ChDisableReg;
// Registered version of ChDisable

reg         NextChDisable;
// D-Input of ChDisableReg

reg         DelChDisable;
// Delayed Channel disable indication

reg         SrcStart;
// Source start signal when Destination is the Flow Controller

reg         NextSrcStart;
// D-Input of SrcStart Reg

reg         OneBitTog;
// Counter to indicate the decrement factor for Control register

reg         NextOneBitTog;
// D-Input of OnebitTog

reg   [1:0] TwoBitTog;
// Counter to indicate the decrement factor for Control register

reg   [1:0] NextTwoBitTog;
// D-Input of TwoBitTog

reg         DelSrcState;
// 1HCLK Delayed SrcState

reg         NextDelSrcState;
// D-Input of DelSrcState

reg         DelDstState;
// 1HCLK Delayed DstState

reg         NextDelDstState;
// D-Input of DelDstState

reg         Del2DstState;
// 1HCLK Delayed version of DelDstState

reg   [3:0] RdPtrAhead;
// Fifo Read Pointer which is getting incremented Ahead of DataValid Reception.

reg   [3:0] NextRdPtrAhead;
// D-Input of RdPtrAhead

reg  [31:0] HwdataBuff1;
// Buffered HWDATA Data

reg  [31:0] HwdataBuff2;
// Buffered HWDATA Data

reg         AddrPhase;
// Address phase for Destination Transactions on Dual Bus

reg   [4:0] ErrorState;
// Error State SM

reg   [4:0] NextErrorState;
// D-Input of ErrorState

reg  [31:0] ChHwdata1;
// Data Brought out from FIFO after endianization which is put on Bus1

reg  [31:0] NextChHwdata1;
// D-Input of ChHwdata1

reg  [31:0] ChHwdata2;
// Data Brought out from FIFO after endianization which is put on Bus2

reg  [31:0] NextChHwdata2;
// D-Input of ChHwdata2

reg   [2:0] DstHwdataState;
// State Machine to drive out HWDATA and for Read Pointer Increment

reg   [2:0] NextDstState;
// D-Input of DstHwdataState

reg         DelMready1;
// Delayed Mready1

reg         DelMready2;
// Delayed Mready2

reg         DelLLIState;
// Delayed LLILOAD State

reg         NextDelLLIState;
// D-input of DelLLIState

reg         Del2LLIState;
// Delayed LLILOAD State by 2 HCLK for synchronizing with UUT during DP Flow

reg         LLIErrOccrd;
// Error occurred during LLILoad

reg         NextLLIErrOccrd;
// D-input of LLIErrOccrd

reg         StopSrc;
// Stop Source Txr when Data is there in FIFO in case of Destination Flow Cntl

reg   [4:0] SrcBeatCopy;
// Copy of SrcBeat Counter

reg   [4:0] NextSrcBeatCopy;
// D-input of SrcBeatCopy

reg   [4:0] SrcCopy1;
// Delayed version of SrcBeatCopy

reg   [4:0] NextSrcCopy1;
// D-input of SrcCopy1

reg   [4:0] SrcCopy2;
// Delayed version of SrcCopy1

reg   [4:0] NextSrcCopy2;
// D-input of SrcCopy2

reg   [2:0] SrcCopyState;
// Source Copy State SM

reg   [2:0] NextSrcCopyST;
// D-input of SrcCopyState

reg   [1:0] PredictFactor;
// Prediction factor for Destination Transfers

reg   [2:0] NotValidSrcST;
// NotValid State for Source Transfers

reg   [2:0] NextSrcNotState;
// D-input of NotValidSrcST

reg   [2:0] NotValidDstST;
// NotValid State for Destination Transfers

reg   [2:0] NextDstNotState;
// D-input of NotValidDstST

reg   [2:0] NotValidLLIST;
// NotValid State for LLI Transfers

reg   [2:0] NextLLINotState;
// D-input of NotValidLLIST

reg         DelNotValidSrc;
// Delayed Not Valid signal for Source Transfers

reg         DelNotValidDst;
// Delayed Not Valid signal for Destination Transfers

reg         DelNotValidLLI;
// Delayed Not Valid signal for LLI Transfers

reg         DMACTCP2M;
// DmacTC indication for P2M Transfers

reg         NextDMACTCP2M;
// D-input of DMACTCP2M

reg         DelDMACTCP2M;
// Delayed DMACTCP2M

reg         WaitedForClr;
// Signal used to synchronize the Interrupts with UUT.
// This signal indicates that Clear is generated.

reg         NextWaitedForClr;
// D-input of WaitedForClr

reg         DelErrMas1;
// Delayed Error from Master1

reg         DelErrMas2;
// Delayed Error from Master2

reg         ErrPulse1;
// Error Pulse from Bus1

reg         ErrPulse2;
// Error Pulse from Bus2

reg         DelIntr;
// Indication to Delay the Interrupts. This signal generated to Sync with UUT

reg         NextDelIntr;
// D-input of DelIntr

reg   [3:0] DisableST;
// Disable SM's Flip Flops

reg   [3:0] NextDisableST;
// D-input of DisableST

reg         SrcDisable;
// Source Disable indication

reg         NextSrcDisable;
// D-input of SrcDisable

reg         DstDisable;
// Destination Disable indication

reg         NextDstDisable;
// D-input of DstDisable

reg         LLIDisable;
// Destination Disable indication

reg         NextLLIDisable;
// D-input of DstDisable

reg  [14:0] Temp1;
reg  [14:0] Temp2;
reg  [16:0] Temp3;
reg   [5:0] Temp4;
reg  [13:0] Temp5;

// -----------------------------------------------------------------------------
// Package insertion
// -----------------------------------------------------------------------------
`include "DmacTrParams.v"

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Function to select the appropriate Channel Select Combinational signal from
// Internal Arbiter.
// -----------------------------------------------------------------------------
function SelComb;
input         AhbMasSel;
input         ChComb1;
input         ChComb2;
begin
  if (AhbMasSel == 1)
    SelComb = ChComb2;
  else
    SelComb = ChComb1;
end
endfunction

// -----------------------------------------------------------------------------
// Function to select the appropriate MREADY
// -----------------------------------------------------------------------------
function MREADY;
input         AhbMasSel;
input         MREADY1;
input         MREADY2;
begin
  if (AhbMasSel == 1)
    MREADY = MREADY2;
  else
    MREADY = MREADY1;
end
endfunction

// -----------------------------------------------------------------------------
// Function to select the appropriate Endianness
// -----------------------------------------------------------------------------
function MasterEndian;
input         AhbMasSel;
input         MasterEndian1;
input         MasterEndian2;
begin
  if (AhbMasSel == 1)
    MasterEndian = MasterEndian2;
  else
    MasterEndian = MasterEndian1;
end
endfunction

// -----------------------------------------------------------------------------
// Function to select the appropriate DataValid's from Master Interface
// -----------------------------------------------------------------------------
function DataValid;
input         AhbMasSel;
input         DataValid1;
input         DataValid2;
begin
  if (AhbMasSel == 1)
    DataValid = DataValid2;
  else
    DataValid = DataValid1;
end
endfunction

// -----------------------------------------------------------------------------
// Function to select the appropriate Disable Acknowledge from Master Interface
// -----------------------------------------------------------------------------
function DisableAck;
input         AhbMasSel;
input         DisAckMas1;
input         DisAckMas2;
begin
  if (AhbMasSel == 1)
    DisableAck = DisAckMas2;
  else
    DisableAck = DisAckMas1;
end
endfunction

// -----------------------------------------------------------------------------
// Function to select the appropriate Error from Master Interface
// -----------------------------------------------------------------------------
function ErrorMas;
input         AhbMasSel;
input         ErrorMas1;
input         ErrorMas2;
begin
  if (AhbMasSel == 1)
    ErrorMas = ErrorMas2;
  else
    ErrorMas = ErrorMas1;
end
endfunction

// -----------------------------------------------------------------------------
// Function to Decide the Increment Factor for incrementing Source and
// Destination register.
// -----------------------------------------------------------------------------
function [2:0] SrcDstSize;
input  [2:0] Size;
begin
  case (Size)
    3'b000 :
      SrcDstSize = 3'b001;
    3'b001 :
      SrcDstSize = 3'b010;
    3'b010 :
      SrcDstSize = 3'b100;
    default :
      SrcDstSize = 3'b001;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// Function to Decide the Burst Size
// -----------------------------------------------------------------------------
function [13:0] BurstSize;
input  [2:0] Burst;
input        SingleReq;
input        BurstReq;
input        TypeMem;
begin
  if ((BurstReq == 1) || (TypeMem == 1))
    begin
      case (Burst)
        3'b000 :
          BurstSize = `ONE_14;
        3'b001 :
          BurstSize = `FOUR_14;
        3'b010 :
          BurstSize = `EIGHT_14;
        3'b011 :
          BurstSize = `SIXTEEN_14;
        3'b100 :
          BurstSize = `THIRTYTWO_14;
        3'b101 :
          BurstSize = `SIXTYFOUR_14;
        3'b110 :
          BurstSize = `ONETWOEIGHT_14;
        3'b111 :
          BurstSize = `TWOFIVESIX_14;
        default :
          BurstSize = `ONE_14;
      endcase
    end
  else
    BurstSize = `ONE_14;
end
endfunction

// -----------------------------------------------------------------------------
// Function to Calculate the Beat Count for AHB Master logic When Receiving
// data from Source peripheral.
// -----------------------------------------------------------------------------
function [4:0] SrcBeatCount;
input  [2:0] SrcWidth;
input  [2:0] DstWidth;
input  [4:0] DstBeat;
input [13:0] Burst;
input  [4:0] FifoLevelDel;
input  [4:0] FifoLevelAct;
input  [4:0] ChannelState;
input        AddrPhase;
input        SameBus;
begin
  if (ChannelState == `ST_IDLE)
    begin
      if ((SrcWidth * Burst) >= (16 - FifoLevelDel))
        SrcBeatCount = (16 - FifoLevelDel) / SrcWidth;
      else
        SrcBeatCount = Burst[4:0];
    end
  else if ((SameBus == 1) && (ChannelState == `ST_DMA_DST_XFER))
    begin
      if (AddrPhase == 0)
        begin
          if ((SrcWidth * Burst) >= (16 - FifoLevelAct + (DstBeat * DstWidth)))
            SrcBeatCount = (16 - FifoLevelAct + (DstBeat * DstWidth)) /
                                                                      SrcWidth;
          else
            SrcBeatCount = Burst[4:0];
        end
      else
        begin
          if ((SrcWidth * Burst) >= (16 - FifoLevelAct))
            SrcBeatCount = (16 - FifoLevelAct) / SrcWidth;
          else
            SrcBeatCount = Burst[4:0];
        end
    end
  else if (ChannelState == `ST_PER_DUAL_BUS)
    begin
      if ((SrcWidth * Burst) >= (16 - FifoLevelDel))
        SrcBeatCount = (16 - FifoLevelDel) / SrcWidth;
      else
        SrcBeatCount = Burst[4:0];
    end
end
endfunction

// -----------------------------------------------------------------------------
// Function to Calculate the Beat Count for AHB Master logic When Transferring
// data from DMA to Destination peripheral.
// -----------------------------------------------------------------------------
function [4:0] DstBeatCount;
input  [2:0] DstWidth;
input  [2:0] SrcWidth;
input  [2:0] Predict;
input [13:0] DstBurst;
input  [4:0] FifoLevelDel;
begin
  if ((DstWidth * DstBurst) >= (FifoLevelDel + Predict * SrcWidth))
    DstBeatCount =(FifoLevelDel + Predict * SrcWidth) / DstWidth;
  else
    DstBeatCount = DstBurst[4:0];
end
endfunction

// -----------------------------------------------------------------------------
// Function to Calculate the minimum of Two Burst Counters
// -----------------------------------------------------------------------------
function [13:0] MinCnt;
input [13:0] Burst1;
input [13:0] Burst2;
begin
  if (Burst1 <= Burst2)
    MinCnt = Burst1;
  else
    MinCnt = Burst2;
end
endfunction

// -----------------------------------------------------------------------------
// Function to Calculate the maximum of Two FiFolevels
// -----------------------------------------------------------------------------
function [13:0] MaxCnt;
input  [4:0] Level1;
input  [4:0] Level2;
begin
  if (Level1 >= Level2)
    MaxCnt = Level1;
  else
    MaxCnt = Level2;
end
endfunction

// -----------------------------------------------------------------------------
// Function to Select the Source Burst Count for SM based on Flow controller
// and counter value i.e Minimum of TC and Burst values
// -----------------------------------------------------------------------------
function [13:0] SrcBurstCal;
input  [2:0] FlowCntl;
input [13:0] SrcBurst;
input [13:0] SrcBstDstFlow;
input [13:0] SourceTC;
begin
  case (FlowCntl)
    3'b000, 3'b001, 3'b010, 3'b011 :
      if (SourceTC >= SrcBurst)
        SrcBurstCal = SrcBurst;
      else
        SrcBurstCal = SourceTC;

    3'b100, 3'b101 :
      if (SrcBstDstFlow >= SrcBurst)
        SrcBurstCal = SrcBurst;
      else
        SrcBurstCal = SrcBstDstFlow;

    3'b110, 3'b111 :
      SrcBurstCal = SrcBurst;

    default :
      SrcBurstCal = SrcBurst;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// Function to Select the Destination Burst Count for SM based on Flow
// controller and counter value, i.e Minimum of TC and Burst values
// -----------------------------------------------------------------------------
function [13:0] DstBurstCal;
input  [2:0] FlowCntl;
input [13:0] DstBurst;
input [13:0] DstBstSrcFlow;
input [13:0] DstTC;
begin
  case (FlowCntl)
    3'b000, 3'b001, 3'b010, 3'b011 :
      if (DstTC >= DstBurst)
        DstBurstCal = DstBurst;
      else
        DstBurstCal = DstTC;

    3'b100, 3'b101 :
      DstBurstCal = DstBurst;

    3'b110, 3'b111 :
      if (DstBstSrcFlow >= DstBurst)
        DstBurstCal = DstBurst;
      else
        DstBurstCal = DstBstSrcFlow;

    default :
      DstBurstCal = 'b0;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// Function to Select the TC Counter This function is not effective for Source
// Flow Controller.
// -----------------------------------------------------------------------------
function [13:0] SelTC;
input  [2:0] FlowCntl;
input [13:0] TCCount;
input [13:0] TCXflow;
input        XLstOccrd;
input        LstOccrd;
begin
  if (FlowCntl[2] == 0)
    SelTC = TCCount;
  else if (LstOccrd == 1)
    SelTC = TCCount;
  else
    SelTC = `ALLONE_14;
end
endfunction

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Assigning internal signals to the outputs and few signals for Aliasing
// -----------------------------------------------------------------------------
assign SrcReg           = ChConfigReg[4:1];
assign DstReg           = ChConfigReg[9:6];
assign SrcAhbMasSel     = 0;
assign DstAhbMasSel     = 0;
// FOLLOWING LINES ARE COMMENTED OUT FOR VARIANT
//assign SrcAhbMasSel     = ChControlReg[24];
//assign DstAhbMasSel     = ChControlReg[25];
assign SrcWidth         = ChControlReg[20:18];
assign DstWidth         = ChControlReg[23:21];
assign SrcBusWidth      = SrcDstSize(SrcWidth);
assign DstBusWidth      = SrcDstSize(DstWidth);
assign SrcBurstSize     = ChControlReg[14:12];
assign DstBurstSize     = ChControlReg[17:15];
assign SrcIncrBit       = ChControlReg[26];
assign DstIncrBit       = ChControlReg[27];
assign FlowCntl         = ChConfigReg[13:11];
assign ChEnable         = ChConfigReg[0];
assign IntMask          = ChControlReg[31] & ChConfigReg[15];
assign ErrMask          = ChConfigReg[14];
assign SameBus          = (DstAhbMasSel == SrcAhbMasSel) ? 1'b1 : 1'b0;
assign DiffBus          = (DstAhbMasSel != SrcAhbMasSel) ? 1'b1 : 1'b0;
assign LLILoad          = ChLLIReg[31:2];
assign NextLLIAhbMasSel = 0;
// FOLLOWING LINES ARE COMMENTED OUT FOR VARIANT
//assign NextLLIAhbMasSel = (ChannelState != `ST_LLI_LOAD) ? ChLLIReg[0] :
//                         LLIAhbMasSel;
assign AddrOffSetSrc    = ChSrcAddrReg[1:0];
assign ValidDataSrc     = DataValid(SrcAhbMasSel, DataValid1, DataValid2);
assign ValidDataDst     = DataValid(DstAhbMasSel, DataValid1, DataValid2);
assign ValidDataLLI     = DataValid(LLIAhbMasSel, DataValid1, DataValid2);

// -----------------------------------------------------------------------------
// This process is responsible for Synchronizing DMACCLR and DMACTC signals
// With UUT.
// -----------------------------------------------------------------------------
always @(DstReqBefMask or iDMACTC or iDMACCLR or DstReg or DMACTCDel or
         DMACCLRDel or SrcReqBefMask or SrcReg or FlowCntl or SoftClrPulse)
begin : p_DmacClrComb
  DMACTC           = ('b0);
  DMACCLR          = ('b0);
  SOFTCLR          = ('b0);
  if ((FlowCntl == 3'b001) || (FlowCntl == 3'b011) || (FlowCntl == 3'b100) ||
      (FlowCntl == 3'b101) || (FlowCntl == 3'b111))
    begin
      if (DstReqBefMask == 1'b0)
        begin
          DMACTC[DstReg] = iDMACTC[DstReg];
          DMACCLR[DstReg] = iDMACCLR[DstReg];
        end
      else
        begin
          DMACTC[DstReg] = DMACTCDel[DstReg];
          DMACCLR[DstReg] = DMACCLRDel[DstReg];
        end
      SOFTCLR[DstReg] = SoftClrPulse;
    end

  if ((FlowCntl == 3'b010) || (FlowCntl == 3'b011) || (FlowCntl == 3'b100) ||
      (FlowCntl == 3'b110) || (FlowCntl == 3'b111))
    begin
      if (SrcReqBefMask == 1'b0)
        begin
          DMACTC[SrcReg] = iDMACTC[SrcReg];
          DMACCLR[SrcReg] = iDMACCLR[SrcReg];
        end
      else
        begin
          DMACTC[SrcReg] = DMACTCDel[SrcReg];
          DMACCLR[SrcReg] = DMACCLRDel[SrcReg];
        end
      SOFTCLR[SrcReg] = SoftClrPulse;
    end
end // p_DmacClrComb

// -----------------------------------------------------------------------------
// This process is responsible for Synchronizing Channel Error Interrupt signal
// With UUT.
// -----------------------------------------------------------------------------
always @(FlowCntl or iChIntErr or iDMACCLR or DstReg or ChIntErrDel1 or
         DMACCLR2Del or SrcReg or WaitedForClr or DelIntr)
begin : p_ErrIntComb
  ChIntErr         = 1'b0;
  NextWaitedForClr = WaitedForClr;
  case (FlowCntl)
    3'b000 :
      if (iChIntErr != 1'b0)
        ChIntErr         = ChIntErrDel1;
      else
        ChIntErr         = iChIntErr;

    3'b001, 3'b101 :
      begin
        if ((iDMACCLR[DstReg] == 1'b1) || (DMACCLR2Del[DstReg] == 1'b1))
          begin
            ChIntErr         = iChIntErr;
            NextWaitedForClr = 1'b1;
          end
        else if ((iChIntErr != 1'b0) && (WaitedForClr == 1'b0))
          ChIntErr         = ChIntErrDel1;
        else if ((iChIntErr != 1'b0) && (WaitedForClr == 1'b1) &&
                 (DelIntr == 1'b1))
          ChIntErr         = ChIntErrDel1;
        else
          ChIntErr         = iChIntErr;
  
        if ((iDMACCLR[DstReg] == 1'b0) && (iChIntErr == 1'b0) &&
            (DMACCLR2Del[DstReg] == 1'b0))
          NextWaitedForClr = 1'b0;
      end

    3'b010, 3'b110 :
      begin
        if ((iDMACCLR[SrcReg] == 1'b1) || (DMACCLR2Del[SrcReg] == 1'b1))
          begin
            ChIntErr         = iChIntErr;
            NextWaitedForClr = 1'b1;
          end
        else if ((iChIntErr != 1'b0) && (WaitedForClr == 1'b0))
          ChIntErr         = ChIntErrDel1;
        else if ((iChIntErr != 1'b0) && (WaitedForClr == 1'b1) &&
                 (DelIntr == 1'b1))
          ChIntErr         = ChIntErrDel1;
        else
          ChIntErr         = iChIntErr;
  
        if ((iDMACCLR[SrcReg] == 1'b0) && (iChIntErr == 1'b0) &&
            (DMACCLR2Del[SrcReg] == 1'b0))
          NextWaitedForClr = 1'b0;
      end

    3'b011, 3'b100, 3'b111 :
      begin
        if ((iDMACCLR[DstReg] == 1'b1) || (DMACCLR2Del[DstReg] == 1'b1) ||
            (iDMACCLR[SrcReg] == 1'b1) || (DMACCLR2Del[SrcReg] == 1'b1))
          begin
            ChIntErr         = iChIntErr;
            NextWaitedForClr = 1'b1;
          end
        else if ((iChIntErr != 1'b0) && (WaitedForClr == 1'b0))
          ChIntErr         = ChIntErrDel1;
        else if ((iChIntErr != 1'b0) && (WaitedForClr == 1'b1) &&
                 (DelIntr == 1'b1))
          ChIntErr         = ChIntErrDel1;
        else
          ChIntErr         = iChIntErr;
  
        if ((iDMACCLR[DstReg] == 1'b0) && (DMACCLR2Del[DstReg] == 1'b0) &&
            (iDMACCLR[SrcReg] == 1'b0) && (iChIntErr == 1'b0) &&
            (DMACCLR2Del[SrcReg] == 1'b0))
          NextWaitedForClr = 1'b0;
      end

    default :
      begin
        ChIntErr         = 1'b0;
        NextWaitedForClr = WaitedForClr;
      end
  endcase
end // p_ErrIntComb

// -----------------------------------------------------------------------------
// This process is responsible for generating one signal which gives an
// indication to Delay the Interrupt so that Synchronizing Channel Error
// Interrupt signal With UUT happens.
// -----------------------------------------------------------------------------
always @(DelIntr or SrcState or SrcAhbMasSel or ErrPulse1 or ErrPulse2 or
         iDMACCLR or DstReg or SrcReg or iChIntErr or DMACCLR2Del or DstState or
         DstAhbMasSel or DelSrcState or DelDstState)
begin : p_ErrClrDetComb
  NextDelIntr      = DelIntr;
  if ((SrcState == 1'b1) || (DelSrcState == 1'b1))
    begin
      if ((SelComb(SrcAhbMasSel, ErrPulse1, ErrPulse2) == 1'b1) &&
          (iDMACCLR[DstReg] == 1'b0))
        NextDelIntr      = 1'b1;
      else if ((iDMACCLR[DstReg] == 1'b0) && (DMACCLR2Del[DstReg] == 1'b0) &&
               (iChIntErr == 1'b0))
        NextDelIntr      = 1'b0;
    end
  else if ((DstState == 1'b1) || (DelDstState == 1'b1))
    begin
      if ((SelComb(DstAhbMasSel, ErrPulse1, ErrPulse2) == 1'b1) &&
          (iDMACCLR[SrcReg] == 1'b0))
        NextDelIntr      = 1'b1;
      else if ((iDMACCLR[SrcReg] == 1'b0) && (DMACCLR2Del[SrcReg] == 1'b0) &&
               (iChIntErr == 1'b0))
        NextDelIntr      = 1'b0;
    end
end // p_ErrClrDetComb

// -----------------------------------------------------------------------------
// Factor Calculation based on Destination. i.e FactorOnDstNum/FactorOnDstDen
// -----------------------------------------------------------------------------
always @(DstBusWidth or SrcBusWidth)
begin : p_FactorDstComb
  FactorOnDstNum   = 3'b001;
  FactorOnDstDen   = 3'b001;
  if (DstBusWidth == 3'b100)
    begin
      FactorOnDstNum   = DstBusWidth / SrcBusWidth;
      FactorOnDstDen   = 3'b001;
    end
  if (DstBusWidth == 3'b010)
    begin
      if (SrcBusWidth == 3'b100)
        begin
          FactorOnDstNum   = 3'b001;
          FactorOnDstDen   = 3'b010;
        end
      else
        begin
          FactorOnDstNum   = DstBusWidth / SrcBusWidth;
          FactorOnDstDen   = 3'b001;
        end
    end
  if (DstBusWidth == 3'b001)
    begin
      FactorOnDstDen   = SrcBusWidth / DstBusWidth;
      FactorOnDstNum   = 3'b001;
    end
end // p_FactorDstComb

// -----------------------------------------------------------------------------
// Factor Calculation based on Source. i.e FactorOnSrcNum/FactorOnSrcDen
// -----------------------------------------------------------------------------
always @(DstBusWidth or SrcBusWidth)
begin : p_FactorSrcComb
  FactorOnSrcNum   = 3'b001;
  FactorOnSrcDen   = 3'b001;
  if (SrcBusWidth == 3'b100)
    begin
      FactorOnSrcNum   = SrcBusWidth / DstBusWidth;
      FactorOnSrcDen   = 3'b001;
    end
  if (SrcBusWidth == 3'b010)
    begin
      if (DstBusWidth == 3'b100)
        begin
          FactorOnSrcNum   = 3'b001;
          FactorOnSrcDen   = 3'b010;
        end
      else
        begin
          FactorOnSrcNum   = SrcBusWidth / DstBusWidth;
          FactorOnSrcDen   = 3'b001;
        end
    end
  if (SrcBusWidth == 3'b001)
    begin
      FactorOnSrcDen   = DstBusWidth / SrcBusWidth;
      FactorOnSrcNum   = 3'b001;
    end
end // p_FactorSrcComb

// -----------------------------------------------------------------------------
// Writing into DMA Channel registers from different sources. The different
// sources include from slave, during LLI Load from Bus1 or Bus2 and updating
// of registers when transactions proceed.
// -----------------------------------------------------------------------------
always @(ChSrcAddrReg or ChDstAddrReg or ChControlReg or ChLLIReg or
         ChConfigReg or ChSrcAddrWrEn or ChSrcMas1WrEn or ChSrcMas2WrEn or
         ChDstAddrWrEn or ChDstMas1WrEn or ChDstMas2WrEn or ChControlWrEn or
         ChCtrlMas1WrEn or ChCtrlMas2WrEn or ChLLIWrEn or ChLLIMas1WrEn or
         ChLLIMas2WrEn or ChConfigWrEn or HWDATA or HRDATAM1 or HRDATAM2 or
         ChannelState or SrcBusWidth or SrcIncrBit or DstIncrBit or DstBusWidth
         or FlowCntl or LLILoad or DstTC or DstTCSrcFlow or SrcLstOccrd or
         DstLstOccrd or SrcDisAckOccrd or DstDisAckOccrd or DiffBus or
         OneBitTog or TwoBitTog or ChHaltReg or LLIErrOccrd or ChDisableReg or
         SrcWidth or DstWidth or SingleBusErr or DualBusErr or ChEnable or
         SrcMaskReg or DMAFIFOLevel or ActFifoLevel or DelSrcState or
         NotValidDataSrc or NotValidDataDst or ValidDataSrc or ValidDataDst or
         DstBeat or SrcState or DstState or LLIDisAckOccrd)
begin : p_WriteComb
  NextChSrcAddrReg = ChSrcAddrReg;
  NextChDstAddrReg = ChDstAddrReg;
  NextChControlReg = ChControlReg;
  NextChLLIReg     = ChLLIReg;
  NextChConfigReg  = ChConfigReg;
  NextOneBitTog    = OneBitTog;
  NextTwoBitTog    = TwoBitTog;
  NextChHalt       = ChHaltReg;
  NextChDisable    = ChDisableReg;

  if (ChSrcAddrWrEn == 1'b1)
    NextChSrcAddrReg = HWDATA;
  else if (ChSrcMas1WrEn == 1'b1)
    NextChSrcAddrReg = HRDATAM1;
  else if (ChSrcMas2WrEn == 1'b1)
    NextChSrcAddrReg = HRDATAM2;
  else if (SrcState == 1'b1)
    if ((ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0) &&
        (SrcIncrBit == 1'b1))
      NextChSrcAddrReg = ChSrcAddrReg + SrcBusWidth;

  if (ChDstAddrWrEn == 1'b1)
    NextChDstAddrReg = HWDATA;
  else if (ChDstMas1WrEn == 1'b1)
    NextChDstAddrReg = HRDATAM1;
  else if (ChDstMas2WrEn == 1'b1)
    NextChDstAddrReg = HRDATAM2;
  else if (DstState == 1'b1)
    if ((ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0) &&
        (DstIncrBit == 1'b1))
      NextChDstAddrReg = ChDstAddrReg + DstBusWidth;

  if (ChControlWrEn == 1'b1)
    NextChControlReg = HWDATA;
  else if (ChCtrlMas1WrEn == 1'b1)
    NextChControlReg = HRDATAM1;
  else if (ChCtrlMas2WrEn == 1'b1)
    NextChControlReg = HRDATAM2;
  else if (DstState == 1'b1)
    begin
      if ((ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0) &&
          (FlowCntl[2] == 1'b0))
        begin
          case (SrcWidth)
            3'b000 :
              case (DstWidth)
                3'b000 :
                   NextChControlReg[11:0] = ChControlReg[11:0] - 1'b1;
                3'b001 :
                   NextChControlReg[11:0] = ChControlReg[11:0] - 2'b10;
                3'b010 :
                   NextChControlReg[11:0] = ChControlReg[11:0] - 3'b100;
                default :
                  NextChControlReg[11:0] = ChControlReg;
              endcase
            3'b001 :
              case (DstWidth)
                3'b000 :
                  if (OneBitTog == 1'b1)
                    NextChControlReg[11:0] = ChControlReg[11:0] - 2'b10;
                  else
                    NextOneBitTog    =  ~OneBitTog;
                3'b001 :
                  NextChControlReg[11:0] = ChControlReg[11:0] - 1'b1;
                3'b010 :
                  NextChControlReg[11:0] = ChControlReg[11:0] - 2'b10;
                default :
                  begin
                    NextChControlReg[11:0] = ChControlReg;
                    NextOneBitTog    = OneBitTog; 
                  end
              endcase
            3'b010 :
              case (DstWidth)
                3'b000 :
                  if (TwoBitTog == 2'b11)
                    NextChControlReg[11:0] = ChControlReg[11:0] - 3'b100;
                  else
                    NextTwoBitTog    = TwoBitTog + 2'b01;
                3'b001 :
                  if (OneBitTog == 1'b1)
                    NextChControlReg[11:0] = ChControlReg[11:0] - 2'b10;
                  else
                    NextOneBitTog    =  ~OneBitTog;
                3'b010 :
                  NextChControlReg[11:0] = ChControlReg[11:0] - 1'b1;
                default :
                  begin
                    NextChControlReg[11:0] = ChControlReg;
                    NextOneBitTog    = OneBitTog;
                    NextTwoBitTog    = TwoBitTog;
                  end
              endcase
            default :
              begin
                NextChControlReg[11:0] = ChControlReg;
                NextOneBitTog    = OneBitTog;
                NextTwoBitTog    = TwoBitTog;
              end
          endcase
        end
    end

  if (ChLLIWrEn == 1'b1)
    NextChLLIReg     = HWDATA;
  else if (ChLLIMas1WrEn == 1'b1)
    NextChLLIReg     = HRDATAM1;
  else if (ChLLIMas2WrEn == 1'b1)
    NextChLLIReg     = HRDATAM2;

  if (ChConfigWrEn == 1'b1)
    begin
      NextChConfigReg  = HWDATA;
      NextChHalt       = HWDATA[18];
      if (ChEnable == 1'b1)
        NextChDisable    =  ~HWDATA[0];
      else
        NextChDisable    = 1'b0;
      if ((ChannelState == `ST_IDLE) && (HWDATA[0] == 1'b0))
        NextChConfigReg[0] = 1'b0;
    end
  else if (((LLILoad == `ZERO_30) && ((SelTC(FlowCntl, DstTC, DstTCSrcFlow,
             SrcLstOccrd, DstLstOccrd) == `ONE_14) || ((SrcMaskReg == 1'b1) &&
            (DMAFIFOLevel == 5'b00000) && (ActFifoLevel == 5'b00000) &&
            (DelSrcState == 1'b0) && (FlowCntl[2:1] == 2'b11) &&
            (DstBeat == 5'b00001))) && (DstState == 1'b1) &&
            (ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0)) ||
           (((SrcDisAckOccrd == 1'b1) && (DstDisAckOccrd == 1'b1) &&
             (DiffBus == 1'b1)) || (((SrcDisAckOccrd == 1'b1) ||
             (DstDisAckOccrd == 1'b1) || (LLIDisAckOccrd == 1'b1)) &&
             (DiffBus == 1'b0))) || ((SingleBusErr == 1'b1) ||
             (DualBusErr == 1'b1) || (LLIErrOccrd == 1'b1)))
    NextChConfigReg[0] = 1'b0;
end // p_WriteComb

// -----------------------------------------------------------------------------
// This process is responsible for generating the Disable condition. That is it
// generates the Channel Disable indication to Respective Source or Destination
// Master, and it waits for the Acknowledge to be received from Masters to
// Completely Disable the Channel. The timing of generation of these signals is
// controlled by the SM.
// -----------------------------------------------------------------------------
always @(SingleBusErr or DualBusErr or DisableST or SrcDisable or DstDisable or
         DelChDisable or SrcState or DstState or SameBus or SrcAhbMasSel or
         DisAckMas1 or DisAckMas2 or NotValidDataSrc or NotValidDataDst or
         SrcBeat or DstBeat or DstAhbMasSel or DelNotValidSrc or DelNotValidDst
         or DelNotValidLLI or ChannelState or LLIBeat or LLIDisable or
         LLIAhbMasSel or NotValidDataLLI)
begin : p_DisSMComb
  NextDisableST    = DisableST;
  NextSrcDisable   = SrcDisable;
  NextDstDisable   = DstDisable;
  NextLLIDisable   = LLIDisable;
  if ((SingleBusErr == 1'b0) || (DualBusErr == 1'b0))
    begin
      case (DisableST)
        `ST_DISABLE_IDLE :
          begin
            if ((DelChDisable == 1'b1) && (SrcState == 1'b1) &&
                (DelNotValidSrc == 1'b0) && (SrcBeat > 5'b00011))
              begin
                NextDisableST    = `ST_DISABLE_OCCRD;
                NextSrcDisable   = 1'b1;
                NextDstDisable   = 1'b1;
              end
            else if ((DelChDisable == 1'b1) && (DstState == 1'b1) &&
                     (DelNotValidDst == 1'b0) && (DstBeat > 5'b00011))
              begin
                NextDisableST    = `ST_DISABLE_OCCRD;
                NextSrcDisable   = 1'b1;
                NextDstDisable   = 1'b1;
              end
            else if ((DelChDisable == 1'b1) && (ChannelState == `ST_LLI_LOAD) &&
                     (DelNotValidLLI == 1'b0) && (LLIBeat > 5'b00011))
              begin
                NextDisableST    = `ST_DISABLE_OCCRD;
                NextLLIDisable   = 1'b1;
              end
          end
  
        `ST_DISABLE_OCCRD :
          begin
            if ((SameBus == 1'b1) && (DisableAck(SrcAhbMasSel, DisAckMas1,
                 DisAckMas2) == 1'b1) && (((SrcState == 1'b1) &&
                (NotValidDataSrc == 1'b0)) || ((DstState == 1'b1) &&
                (NotValidDataDst == 1'b0))))
              begin
                NextDisableST    = `ST_DISABLE_IDLE;
                NextSrcDisable   = 1'b0;
                NextDstDisable   = 1'b0;
                NextLLIDisable   = 1'b0;
              end
            else if ((SameBus == 1'b1) && (((SrcState == 1'b1) &&
                     (SrcBeat <= 5'b00011)) || ((DstState == 1'b1) &&
                     (DstBeat <= 5'b00011))))
              begin
                NextDisableST    = `ST_DISABLE_IDLE;
                NextSrcDisable   = 1'b0;
                NextDstDisable   = 1'b0;
                NextLLIDisable   = 1'b0;
              end
            else if ((SameBus == 1'b0) && (DisableAck(SrcAhbMasSel, DisAckMas1,
                      DisAckMas2) == 1'b1) && (SrcState == 1'b1) &&
                     (NotValidDataSrc == 1'b0) && (DstState == 1'b1) &&
                     (NotValidDataDst == 1'b0) && (DisableAck(DstAhbMasSel,
                      DisAckMas1, DisAckMas2) == 1'b1))
              begin
                NextDisableST    = `ST_DISABLE_IDLE;
                NextSrcDisable   = 1'b0;
                NextDstDisable   = 1'b0;
                NextLLIDisable   = 1'b0;
              end
            else if ((SameBus == 1'b0) && (SrcState == 1'b1) &&
                     (NotValidDataSrc == 1'b0) && ((DisableAck(SrcAhbMasSel,
                      DisAckMas1, DisAckMas2) == 1'b1) ||
                      (SrcBeat <= 5'b00011)))
              begin
                NextSrcDisable   = 1'b0;
                NextDisableST    = `ST_DISABLE_SRCACK_RXD;
              end
            else if ((SameBus == 1'b0) && (DstState == 1'b1) &&
                     (NotValidDataDst == 1'b0) && ((DisableAck(DstAhbMasSel,
                      DisAckMas1, DisAckMas2) == 1'b1) ||
                      (DstBeat <= 5'b00011)))
              begin
                NextDstDisable   = 1'b0;
                NextDisableST    = `ST_DISABLE_DSTACK_RXD;
              end
            else if (((DisableAck(LLIAhbMasSel, DisAckMas1, DisAckMas2)
                       == 1'b1) || (LLIBeat <= 5'b00011)) &&
                      (ChannelState == `ST_LLI_LOAD) &&
                      (NotValidDataLLI == 1'b0))
              begin
                NextDisableST    = `ST_DISABLE_IDLE;
                NextSrcDisable   = 1'b0;
                NextDstDisable   = 1'b0;
                NextLLIDisable   = 1'b0;
              end
          end
  
        `ST_DISABLE_SRCACK_RXD :
          begin
            if ((DstState == 1'b1) && (NotValidDataDst == 1'b0) &&
                ((DisableAck(DstAhbMasSel, DisAckMas1, DisAckMas2) == 1'b1) ||
                (DstBeat <= 5'b00011)))
              begin
                NextDisableST    = `ST_DISABLE_IDLE;
                NextDstDisable   = 1'b0;
              end
          end
  
        `ST_DISABLE_DSTACK_RXD :
          begin
            if ((SrcState == 1'b1) && (NotValidDataSrc == 1'b0) &&
                ((DisableAck(SrcAhbMasSel, DisAckMas1, DisAckMas2) == 1'b1) ||
                 (SrcBeat <= 5'b00011)))
              begin
                NextDisableST    = `ST_DISABLE_IDLE;
                NextSrcDisable   = 1'b0;
              end
          end
  
        default :
          begin
            NextDisableST    = DisableST;
            NextSrcDisable   = SrcDisable;
            NextDstDisable   = DstDisable;
            NextLLIDisable   = LLIDisable;
          end
      endcase
    end
  else
    begin
      NextDisableST    = DisableST;
      NextSrcDisable   = SrcDisable;
      NextDstDisable   = DstDisable;
      NextLLIDisable   = LLIDisable;
    end
end // p_DisSMComb


// -----------------------------------------------------------------------------
// Pulse generations for recognizing the Disable Acknowledge
// -----------------------------------------------------------------------------
assign Pulse1           = ((NextDisableST == `ST_DISABLE_IDLE) &&
                           (DisableST == `ST_DISABLE_OCCRD)) ? 1'b1 : 1'b0;

assign Pulse2           = ((NextDisableST == `ST_DISABLE_SRCACK_RXD) &&
                           (DisableST == `ST_DISABLE_OCCRD)) ? 1'b1 : 1'b0;

assign Pulse3           = ((NextDisableST == `ST_DISABLE_DSTACK_RXD) &&
                           (DisableST == `ST_DISABLE_OCCRD)) ? 1'b1 : 1'b0;

assign Pulse4           = ((NextDisableST == `ST_DISABLE_IDLE) &&
                           (DisableST == `ST_DISABLE_SRCACK_RXD)) ? 1'b1 : 1'b0;

assign Pulse5           = ((NextDisableST == `ST_DISABLE_IDLE) &&
                           (DisableST == `ST_DISABLE_DSTACK_RXD)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Indication of Source Disable Acknowledge
// -----------------------------------------------------------------------------
assign SrcDisAckOccrd   = ((Pulse1 == 1'b1) || (Pulse2 == 1'b1) ||
                           (Pulse5 == 1'b1)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Indication of Destination Disable Acknowledge
// -----------------------------------------------------------------------------
assign DstDisAckOccrd   = ((Pulse1 == 1'b1) || (Pulse3 == 1'b1) ||
                           (Pulse4 == 1'b1)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Indication of LLI Disable Acknowledge
// -----------------------------------------------------------------------------
assign LLIDisAckOccrd   = (Pulse1 == 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// This process is responsible for generating the Error condition. That is it
// generates SingleBusErr and DualBusErr signal. The timing of this signal
// generation is controlled by the SM.
// -----------------------------------------------------------------------------
always @(ErrorState or SrcErrOccrd or DstErrOccrd or SameBus or ChEnable or
         DstBeat or SrcBeat or LLIErrOccrd or NotValidDataDst or DstState or
         SrcState or NotValidDataSrc or SrcSelComb or DstSelComb or FlowCntl or
         iDMACCLR or SrcReg or DstReg or DelSrcState or DelDstState)
begin : p_ErrSMComb
  NextErrorState   = ErrorState;
  case (ErrorState)
    `ST_ERROR_INIT :
      begin
        if ((SrcErrOccrd == 1'b1) && (SameBus == 1'b1))
          if ((FlowCntl == 3'b001) || (FlowCntl == 3'b011) ||
              (FlowCntl == 3'b100) || (FlowCntl == 3'b101) ||
              (FlowCntl == 3'b111))
            begin
              if (iDMACCLR[DstReg] == 1'b0)
                NextErrorState   = `ST_ERROR_SINGLE;
            end
          else
            NextErrorState   = `ST_ERROR_SINGLE;
        else if ((DstErrOccrd == 1'b1) && (SameBus == 1'b1))
          if ((FlowCntl == 3'b010) || (FlowCntl == 3'b011) ||
              (FlowCntl == 3'b100) || (FlowCntl == 3'b110) ||
              (FlowCntl == 3'b111))
            begin
              if (iDMACCLR[SrcReg] == 1'b0)
                NextErrorState   = `ST_ERROR_SINGLE;
            end
          else
             NextErrorState   = `ST_ERROR_SINGLE;
        else if (LLIErrOccrd == 1'b1)
          begin
            if ((FlowCntl == 3'b001) || (FlowCntl == 3'b011) ||
                (FlowCntl == 3'b100) || (FlowCntl == 3'b101) ||
                (FlowCntl == 3'b111))
              begin
                if (iDMACCLR[DstReg] == 1'b0)
                  NextErrorState   = `ST_ERROR_SINGLE;
              end
            else
              NextErrorState   = `ST_ERROR_SINGLE;
          end
        else if ((SrcErrOccrd == 1'b1) && (DstErrOccrd == 1'b1) &&
                 (SameBus == 1'b0))
          NextErrorState   = `ST_ERROR_DUAL;
        else if ((SrcErrOccrd == 1'b1) && (DstErrOccrd == 1'b0) &&
                 (SameBus == 1'b0) && (DstBeat >= 5'b00001))
          NextErrorState   = `ST_ERROR_SOURCE;
        else if ((SrcErrOccrd == 1'b1) && (DstErrOccrd == 1'b0) &&
                 (SameBus == 1'b0) && (DstBeat == 5'b00000) &&
                 (DstSelComb == 1'b0))
          begin
            if (((FlowCntl == 3'b001) || (FlowCntl == 3'b011) ||
                 (FlowCntl == 3'b100) || (FlowCntl == 3'b101) ||
                 (FlowCntl == 3'b111)) && (DstState == 1'b0))
              begin
                if (iDMACCLR[DstReg] == 1'b0)
                  NextErrorState   = `ST_ERROR_DUAL;
              end
            else if ((DstBeat == 5'b00000) && (DstState == 1'b0) &&
                     (NotValidDataDst == 1'b0) && ((FlowCntl == 3'b000) ||
                     (FlowCntl == 3'b010) || (FlowCntl == 3'b110)))
              NextErrorState   = `ST_ERROR_DUAL;
          end
        else if ((SrcErrOccrd == 1'b0) && (DstErrOccrd == 1'b1) &&
                 (SameBus == 1'b0) && (SrcBeat >= 5'b00001))
          NextErrorState   = `ST_ERROR_DEST;
        else if ((SrcErrOccrd == 1'b0) && (DstErrOccrd == 1'b1) &&
                 (SameBus == 1'b0) && (SrcBeat == 5'b00000) &&
                 (SrcSelComb == 1'b0))
          begin
            if (((FlowCntl == 3'b010) || (FlowCntl == 3'b011) ||
                 (FlowCntl == 3'b100) || (FlowCntl == 3'b110) ||
                 (FlowCntl == 3'b111)) && (SrcState == 1'b0))
              begin
                if (iDMACCLR[SrcReg] == 1'b0)
                  NextErrorState   = `ST_ERROR_DUAL;
              end
            else if ((SrcBeat == 5'b00000) && (SrcState == 1'b0) &&
                     (NotValidDataSrc == 1'b0) && ((FlowCntl == 3'b000) ||
                     (FlowCntl == 3'b001) || (FlowCntl == 3'b101)))
              NextErrorState   = `ST_ERROR_DUAL;
          end
      end

    `ST_ERROR_SINGLE :
      if (ChEnable == 1'b0)
        NextErrorState   = `ST_ERROR_INIT;

    `ST_ERROR_DUAL :
      if (ChEnable == 1'b0)
        NextErrorState   = `ST_ERROR_INIT;

    `ST_ERROR_SOURCE :
      begin
        if (DstErrOccrd == 1'b1)
          NextErrorState   = `ST_ERROR_DUAL;
        else if ((DstBeat == 5'b00000) && (DelDstState == 1'b1) &&
                 (NotValidDataDst == 1'b0) && ((FlowCntl == 3'b000) ||
                 (FlowCntl == 3'b010) || (FlowCntl == 3'b110)))
          NextErrorState   = `ST_ERROR_DUAL;
        else if ((DstBeat == 5'b00000) && (DelDstState == 1'b1) &&
                 (NotValidDataDst == 1'b0) && (iDMACCLR[DstReg] == 1'b0))
          NextErrorState   = `ST_ERROR_DUAL;
        else if (((FlowCntl == 3'b001) || (FlowCntl == 3'b011) ||
                  (FlowCntl == 3'b100) || (FlowCntl == 3'b101) ||
                  (FlowCntl == 3'b111)) && (DstState == 1'b0))
          begin
            if (iDMACCLR[DstReg] == 1'b0)
               NextErrorState   = `ST_ERROR_DUAL;
          end
      end

    `ST_ERROR_DEST :
      if (SrcErrOccrd == 1'b1)
        NextErrorState   = `ST_ERROR_DUAL;
      else if ((SrcBeat == 5'b00000) && (DelSrcState == 1'b1) &&
               (NotValidDataSrc == 1'b0) && ((FlowCntl == 3'b000) ||
               (FlowCntl == 3'b001) || (FlowCntl == 3'b101)))
        NextErrorState   = `ST_ERROR_DUAL;
      else if ((SrcBeat == 5'b00000) && (DelSrcState == 1'b1) &&
               (NotValidDataSrc == 1'b0) && (iDMACCLR[SrcReg] == 1'b0))
        NextErrorState   = `ST_ERROR_DUAL;
      else if (((FlowCntl == 3'b010) || (FlowCntl == 3'b011) ||
                (FlowCntl == 3'b100) || (FlowCntl == 3'b110) ||
                (FlowCntl == 3'b111)) && (SrcState == 1'b0))
        begin
          if (iDMACCLR[SrcReg] == 1'b0)
            NextErrorState   = `ST_ERROR_DUAL;
        end

    default :
      NextErrorState   = ErrorState;
  endcase
end // p_ErrSMComb

// -----------------------------------------------------------------------------
// Single Bus Error indication
// -----------------------------------------------------------------------------
assign SingleBusErr     = (ErrorState == `ST_ERROR_SINGLE) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Dual Bus Error indication
// -----------------------------------------------------------------------------
assign DualBusErr       = (ErrorState == `ST_ERROR_DUAL) ? 1'b1 : 1'b0;

assign ChDisable        = ChDisableReg | NextChDisable;
assign ChHalt           = ChHaltReg;

// -----------------------------------------------------------------------------
// Generation of Write enables when LLI Loading is taking place
// -----------------------------------------------------------------------------
always @(ChannelState or LLIAhbMasSel or DataValid1 or TwoBitCnt or
         DataValid2 or NotValidDataLLI)
begin : p_LLILoadWrComb
   ChSrcMas1WrEn    = 1'b0;
   ChDstMas1WrEn    = 1'b0;
   ChCtrlMas1WrEn   = 1'b0;
   ChLLIMas1WrEn    = 1'b0;
   ChSrcMas2WrEn    = 1'b0;
   ChDstMas2WrEn    = 1'b0;
   ChCtrlMas2WrEn   = 1'b0;
   ChLLIMas2WrEn    = 1'b0;
  if (ChannelState == `ST_LLI_LOAD)
    begin
      if (LLIAhbMasSel == 1'b0)
        begin
          if ((DataValid1 == 1'b1) && (NotValidDataLLI == 1'b0) &&
              (TwoBitCnt == 2'b00))
            ChSrcMas1WrEn    = 1'b1;
          else if ((DataValid1 == 1'b1) && (NotValidDataLLI == 1'b0) &&
                   (TwoBitCnt == 2'b01))
            ChDstMas1WrEn    = 1'b1;
          else if ((DataValid1 == 1'b1) && (NotValidDataLLI == 1'b0) &&
                   (TwoBitCnt == 2'b10))
            ChLLIMas1WrEn    = 1'b1;
          else if ((DataValid1 == 1'b1) && (NotValidDataLLI == 1'b0) &&
                   (TwoBitCnt == 2'b11))
            ChCtrlMas1WrEn   = 1'b1;
        end
      else
        begin
          if ((DataValid2 == 1'b1) && (NotValidDataLLI == 1'b0) &&
              (TwoBitCnt == 2'b00))
            ChSrcMas2WrEn    = 1'b1;
          else if ((DataValid2 == 1'b1) && (NotValidDataLLI == 1'b0) &&
                   (TwoBitCnt == 2'b01))
            ChDstMas2WrEn    = 1'b1;
          else if ((DataValid2 == 1'b1) && (NotValidDataLLI == 1'b0) &&
                   (TwoBitCnt == 2'b10))
            ChLLIMas2WrEn    = 1'b1;
          else if ((DataValid2 == 1'b1) && (NotValidDataLLI == 1'b0) &&
                   (TwoBitCnt == 2'b11))
            ChCtrlMas2WrEn   = 1'b1;
        end
    end
end // p_LLILoadWrComb

// -----------------------------------------------------------------------------
// Logic to generate SrcReqCh and DstReqCh
// Here only the selected DMA request lines are sampled based on the flow
// controller. For Memory type transactions the Request is asserted till the
// end of Transfer. For LLI load the request is asserted when the SM enters the
// `ST_LLI_LOAD.
// -----------------------------------------------------------------------------
always @(FlowCntl or SrcReg or DstReg or DMACBREQ or SOFTBREQ or DMACSREQ or
         SOFTSREQ or DMACLBREQ or DMACLSREQ or SOFTLSREQ or SOFTLBREQ or
         DelLLIState or LLIBeat or DelDstFlowReq or DMAFIFOLevel or
         DstBusWidth or DelChEnable or ChEnable or NotValidDataLLI or
         LLIAhbMasSel or ErrorMas1 or ErrorMas2 or LLISelReg)
begin : p_SrcDstReqComb
  SrcReqBefMask    = 1'b0;
  DstReqBefMask    = 1'b0;
  DstFlowReq       = 1'b0;
  for (i=0; i<16; i=i+1)
    begin
      case (FlowCntl)
        3'b000 :
          begin
            SrcReqBefMask    = 1'b1;
            DstReqBefMask    = 1'b1;
          end
        3'b001 :
          begin
            SrcReqBefMask    = 1'b1;
            if (DstReg == i)
              DstReqBefMask    = DMACBREQ[i] | SOFTBREQ[i];
          end
  
        3'b010 :
          begin
            if (SrcReg == i)
              SrcReqBefMask    = DMACBREQ[i] | SOFTBREQ[i] | DMACSREQ[i] |
                                 SOFTSREQ[i];
            DstReqBefMask    = 1'b1;
          end
  
        3'b011 :
          begin
            if (SrcReg == i)
              SrcReqBefMask    = DMACBREQ[i] | DMACSREQ[i] | SOFTBREQ[i] |
                                 SOFTSREQ[i];
  
            if (DstReg == i)
              DstReqBefMask    = DMACBREQ[i] | SOFTBREQ[i];
          end
  
        3'b100 :
          begin
            if (SrcReg == i)
              SrcReqBefMask    = DMACBREQ[i] | DMACSREQ[i] | SOFTBREQ[i] |
                                 SOFTSREQ[i];
    
            if (DstReg == i)
              begin
                DstFlowReq       = DMACBREQ[i] | DMACSREQ[i] | DMACLBREQ[i] |
                                   DMACLSREQ[i] | SOFTBREQ[i] | SOFTSREQ[i] |
                                   SOFTLSREQ[i] | SOFTLBREQ[i];
                if (DelChEnable == 1'b0)
                  DstReqBefMask    = DelDstFlowReq;
                else if (((DMAFIFOLevel / DstBusWidth) > 0) &&
                          (ChEnable == 1'b1))
                  DstReqBefMask    = DstFlowReq;
                else
                  DstReqBefMask    = DelDstFlowReq;
              end
          end
  
        3'b101 :
          begin
            SrcReqBefMask    = 1'b1;
            if (DstReg == i)
              begin
                DstFlowReq       = DMACBREQ[i] | DMACSREQ[i] | DMACLBREQ[i] |
                                   DMACLSREQ[i] | SOFTBREQ[i] | SOFTSREQ[i] |
                                   SOFTLSREQ[i] | SOFTLBREQ[i];
                if (DelChEnable == 1'b0)
                  DstReqBefMask    = DelDstFlowReq;
                else if (((DMAFIFOLevel / DstBusWidth) > 0) &&
                          (ChEnable == 1'b1))
                  DstReqBefMask    = DstFlowReq;
                else
                  DstReqBefMask    = DelDstFlowReq;
              end
          end
  
        3'b110 :
          begin
            if (SrcReg == i)
              SrcReqBefMask    = DMACBREQ[i] | DMACSREQ[i] | DMACLBREQ[i] |
                                 DMACLSREQ[i] | SOFTBREQ[i] | SOFTSREQ[i] |
                                 SOFTLSREQ[i] | SOFTLBREQ[i];
            DstReqBefMask    = 1'b1;
          end
  
        3'b111 :
          begin
            if (SrcReg == i)
               SrcReqBefMask    = DMACBREQ[i] | DMACSREQ[i] | DMACLBREQ[i] |
                                  DMACLSREQ[i] | SOFTBREQ[i] | SOFTSREQ[i] |
                                  SOFTLSREQ[i] | SOFTLBREQ[i];
  
            if (DstReg == i)
              DstReqBefMask    = DMACBREQ[i] | SOFTBREQ[i];
          end
  
        default :
          begin
            SrcReqBefMask    = 1'b0;
            DstReqBefMask    = 1'b0;
            DstFlowReq       = 1'b0;
          end
      endcase
    end

  if ((DelLLIState == 1'b1) && (LLIBeat >= 3'b011) && (ChEnable == 1) &&
      (~ ((NotValidDataLLI == 0) && (ErrorMas(LLIAhbMasSel, ErrorMas1,
           ErrorMas2) == 1) && (LLISelReg == 1'b1))))
    LLIReq           = 1'b1;
  else
    LLIReq           = 1'b0;
end // p_SrcDstReqComb

// -----------------------------------------------------------------------------
// Request masking for Destination:
// The request are masked out the moment they enter ST_DMA_DST_XFER or
// ST_PER_DUAL_BUS with DstTxrOn bit set, in the state machine. Since moving
// into one of valid state indicates the recognition of grant for that
// particular peripheral we can safely drop down the request. The correction
// factor is required for the back to back case where source burst is followed
// by destination burst provided both are on same bus. we cannot have this
// expression factor for different bus because we cannot predict as to when the
// transaction will finish on other bus. When LLI loading is happening both
// source and destination request are masked out.
// -----------------------------------------------------------------------------
always @(DstErrMask or DMAFIFOLevel or DstBusWidth or ChDisable or
         ChannelState or iDMACCLR or DstReg or DMACEn or ChEnable or
         DstSelReg or FlowCntl or DstState or DelDstState or NotValidDataDst or 
         DstAhbMasSel or ErrorMas1 or ErrorMas2 or SingleBusErr or DualBusErr or
         SrcErrOccrd)
begin : p_DstMaskComb
  DstMask          = 1'b0;
  if (((DMACEn == 1'b1) && (ChEnable == 1'b1)) && (DstErrMask == 1'b0) &&
       ( ~((iDMACCLR[DstReg] == 1'b1) && ( ~((FlowCntl == 3'b000) ||
         (FlowCntl == 3'b010) || (FlowCntl == 3'b110))))) && (ChDisable == 1'b0)
         && (DelDstState == 1'b0) && (DstSelReg == 1'b0))
    begin
      if ((DstState == 1'b1) || (SingleBusErr == 1'b1) ||
          (DualBusErr == 1'b1) || (SrcErrOccrd == 1'b1) ||
          (ChannelState == `ST_LLI_LOAD))
        DstMask          = 1'b1;
      else if ((DMAFIFOLevel / DstBusWidth) > 0)
        DstMask          = 1'b0;
      else
        DstMask          = 1'b1;
    end
  else if ((DelDstState == 1'b1) && (NotValidDataDst == 1'b1) &&
           (ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) == 1'b1))
    DstMask          = 1'b0;
  else
    DstMask          = 1'b1;
end // p_DstMaskComb

// -----------------------------------------------------------------------------
// Request masking for Source:
// The request are masked out the moment they enter ST_SRC_DMA_XFER or
// ST_PER_DUAL_BUS with SrcTxrOn bit set, in the state machine. Since moving
// into one of valid state indicates the recognition of grant for that
// particular peripheral we can safely drop down the request. The correction
// factor is required for the back to back case where source burst is followed
// by destination burst provided both are on same bus. we cannot have this
// expression factor for different bus because we cannot predict as to when the
// transaction will finish on other bus. When LLI loading is happening both
// source and destination request are masked out.
// -----------------------------------------------------------------------------
always @(SrcErrMask or ActFifoLevel or SrcBusWidth or ChDisable or ChHalt or
         DstReqBefMask or FlowCntl or SrcMaskReg or iDMACCLR or SrcReg or
         ChannelState or SrcMskDstFlow or DMACEn or ChEnable or DstBusWidth or
         ChControlReg or SrcSelReg or DMAFIFOLevel or DelSrcState or
         DelChEnable or DelLLIState or SrcState or StopSrc or NotValidDataSrc or
         SrcAhbMasSel or ErrorMas1 or ErrorMas2 or SingleBusErr or DualBusErr or
         DstErrOccrd or Del2LLIState)
begin : p_SrcMaskComb
  SrcMask          = 1'b0;
  if (((DMACEn == 1'b1) && (ChEnable == 1'b1)) && (SrcErrMask == 1'b0) &&
       ( ~((iDMACCLR[SrcReg] == 1'b1) && ( ~((FlowCntl == 3'b000) ||
       (FlowCntl == 3'b001) || (FlowCntl == 3'b101))))) &&
       (ChDisable == 1'b0) && (SrcMaskReg == 1'b0) && (SrcMskDstFlow == 1'b0) &&
       (SrcSelReg == 1'b0) && ( ~((FlowCntl[2] == 1'b0) &&
       (ChControlReg == 12'b000000000000))) && (DelSrcState == 1'b0) &&
       (ChHalt == 1'b0))
    begin
      if ((SrcState == 1'b1) || (ChannelState == `ST_LLI_LOAD) ||
          (DelLLIState == 1'b1) || (SingleBusErr == 1'b1) ||
          (DualBusErr == 1'b1) || (DstErrOccrd == 1'b1))
        SrcMask          = 1'b1;
      else if (((FlowCntl == 3'b100) || (FlowCntl == 3'b101)) &&
               ((DelChEnable == 1'b0) || (DstReqBefMask == 1'b0) ||
                (Del2LLIState == 1'b1) || (StopSrc == 1'b1)))
        SrcMask          = 1'b1;
      else if (((16 - DMAFIFOLevel) / SrcBusWidth) > 0)
        SrcMask          = 1'b0;
      else
        SrcMask          = 1'b1;
    end
  else if ((DelSrcState == 1'b1) && (NotValidDataSrc == 1'b1) &&
           (ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) == 1'b1))
    SrcMask          = 1'b0;
  else
    SrcMask          = 1'b1;
end // p_SrcMaskComb

// -----------------------------------------------------------------------------
// Source Mask generation block when Destination Flow Controller Transfers are
// happening.
// -----------------------------------------------------------------------------
always @(DMAFIFOLevel or Del2DstState or ChEnable or DstBurst or
         SrcBstDstFlow or DelDstState)
begin : p_AllowSrcComb
  StopSrc          = 1'b0;
  if (ChEnable == 1'b1)
    begin
      if ((DMAFIFOLevel != 5'b00000) && (SrcBstDstFlow == `ZERO_14))
        StopSrc          = 1'b1;
      else if ((DelDstState == 1'b0) && (Del2DstState == 1'b0) &&
                (DstBurst != `ZERO_14))
        StopSrc          = 1'b0;
      else if (((DelDstState == 1'b1) || (Del2DstState == 1'b1)) &&
                (SrcBstDstFlow == `ZERO_14))
        StopSrc          = 1'b1;
    end
  else
    StopSrc          = 1'b1;
end // p_AllowSrcComb

// -----------------------------------------------------------------------------
// Source Mask generation block when TC happens on source side
// -----------------------------------------------------------------------------
always @(SrcMaskReg or SrcReg or iDMACTC or FlowCntl or SourceTC or
         ChannelState or LLILoad or ChDisable or DstTC or DstTCSrcFlow or
         SrcLstOccrd or DstLstOccrd or DelDstState or ChEnable or SrcState)
begin : p_SrcMaskRegComb
  NextSrcMaskReg   = SrcMaskReg;
  if (ChEnable == 1'b0)
    NextSrcMaskReg   = 1'b0;
  else if (iDMACTC[SrcReg] == 1'b1)
    NextSrcMaskReg   = 1'b1;
  else if (( ~((FlowCntl == 3'b100) || (FlowCntl == 3'b101))) &&
           (SourceTC == `ONE_14) && (SrcState == 1'b1))
    NextSrcMaskReg   = 1'b1;
  else if ((ChannelState == `ST_LLI_LOAD) || ((LLILoad == `ZERO_30) &&
           ((ChDisable == 1'b1) || ((SelTC(FlowCntl, DstTC, DstTCSrcFlow,
            SrcLstOccrd, DstLstOccrd) == `ZERO_14) && (DelDstState == 1'b1)))))
    NextSrcMaskReg   = 1'b0;
end // p_SrcMaskRegComb

// -----------------------------------------------------------------------------
// Source Mask generation block when Destination is flow controller
// -----------------------------------------------------------------------------
always @(SrcStart or FlowCntl or DstReqBefMask or DelDstRqBefMask or
         SrcBstDstFlow or DelSrcState or ChEnable or DstReg or iDMACCLR)
begin : p_MskDstFlowComb
  NextSrcStart     = SrcStart;
  if (ChEnable == 1'b0)
    NextSrcStart     = 1'b1;
  else if ((FlowCntl == 3'b100) || (FlowCntl == 3'b101))
    begin
      if ((DstReqBefMask == 1'b1) && (DelDstRqBefMask == 1'b0))
        NextSrcStart     = 1'b1;
      else if (((SrcBstDstFlow == `ZERO_14) && (DelSrcState == 1'b1)) ||
                (iDMACCLR[DstReg] == 1'b1))
        NextSrcStart     = 1'b0;
    end
  else
    NextSrcStart     = 1'b1;
end // p_MskDstFlowComb

assign SrcMskDstFlow    = ( ~(NextSrcStart | SrcStart));

// -----------------------------------------------------------------------------
// Source Mask generation when we move out of Source Transfer State
// -----------------------------------------------------------------------------
always @(DelSrcState or SrcState)
begin : p_SrcTxrSTComb
  NextDelSrcState  = DelSrcState;
  if (SrcState == 1'b1)
    NextDelSrcState  = 1'b1;
  else
    NextDelSrcState  = 1'b0;
end // p_SrcTxrSTComb

assign SrcState  = ((ChannelState == `ST_SRC_DMA_XFER) || ((ChannelState ==
                     `ST_PER_DUAL_BUS) && (SrcTxrOn == 1'b1))) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Delayed Destination Transfer state for putting mask on SrcReg
// -----------------------------------------------------------------------------
always @(DelDstState or DstState)
begin : p_DstTxrSTComb
  NextDelDstState  = DelDstState;
  if (DstState == 1'b1)
    NextDelDstState  = 1'b1;
  else
    NextDelDstState  = 1'b0;
end // p_DstTxrSTComb

assign DstState = ((ChannelState == `ST_DMA_DST_XFER) || ((ChannelState ==
                    `ST_PER_DUAL_BUS) && (DstTxrOn == 1'b1))) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Delayed LLILoad Transfer state for putting mask on SrcReg and LLISelect
// -----------------------------------------------------------------------------
always @(DelLLIState or ChannelState)
begin : p_LLITxrSTComb
  NextDelLLIState  = DelLLIState;
  if (ChannelState == `ST_LLI_LOAD)
    NextDelLLIState  = 1'b1;
  else
    NextDelLLIState  = 1'b0;
end // p_LLITxrSTComb

// -----------------------------------------------------------------------------
// Source Error Mask generation block
// -----------------------------------------------------------------------------
always @(SrcErrOccrd or SrcAhbMasSel or ErrorMas1 or ErrorMas2 or ChEnable or
         NotValidDataSrc or SrcState)
begin : p_SrcErrComb
  NextSrcErrOccrd  = SrcErrOccrd;
  if ((ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) == 1'b1) &&
      (SrcState == 1'b1) && (SrcErrOccrd == 1'b0) && (NotValidDataSrc == 1'b0))
    NextSrcErrOccrd  = 1'b1;
  else if (ChEnable == 1'b0)
    NextSrcErrOccrd  = 1'b0;
end // p_SrcErrComb

assign SrcErrMask       = SrcErrOccrd | NextSrcErrOccrd;

// -----------------------------------------------------------------------------
// Destination Error Mask generation block
// -----------------------------------------------------------------------------
always @(DstErrOccrd or DstAhbMasSel or ErrorMas1 or ErrorMas2 or ChEnable or
         NotValidDataDst or DstState)
begin : p_DstErrComb
  NextDstErrOccrd  = DstErrOccrd;
  if ((ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) == 1'b1) &&
      (DstState == 1'b1) && (DstErrOccrd == 1'b0) && (NotValidDataDst == 1'b0))
    NextDstErrOccrd  = 1'b1;
  else if (ChEnable == 1'b0)
    NextDstErrOccrd  = 1'b0;
end // p_DstErrComb

assign DstErrMask       = DstErrOccrd | NextDstErrOccrd;

// -----------------------------------------------------------------------------
// LLI Error Mask generation block
// -----------------------------------------------------------------------------
always @(LLIErrOccrd or ChannelState or LLIAhbMasSel or ErrorMas1 or
         ErrorMas2 or ChEnable or NotValidDataLLI or LLIReq)
begin : p_LLIErrComb
  NextLLIErrOccrd  = LLIErrOccrd;
  if ((ErrorMas(LLIAhbMasSel, ErrorMas1, ErrorMas2) == 1'b1) &&
      (ChannelState == `ST_LLI_LOAD) && (LLIErrOccrd == 1'b0) &&
      (LLIReq == 1'b0) && (NotValidDataLLI == 1'b0))
    NextLLIErrOccrd  = 1'b1;
  else if (ChEnable == 1'b0)
    NextLLIErrOccrd  = 1'b0;
end // p_LLIErrComb

assign LLIErrMask       = LLIErrOccrd | NextLLIErrOccrd;

// -----------------------------------------------------------------------------
// Logic to handle Error Interrupt
// -----------------------------------------------------------------------------
always @(ClrIntErr or iChIntErr or ErrMask or SingleBusErr or DualBusErr or
         SoftClrPulse)
begin : p_IntErrComb
  NextChIntErr     = iChIntErr;
  NextSoftClrPulse = SoftClrPulse;
  if (ClrIntErr == 1'b1)
    NextChIntErr     = 1'b0;
  else if (((SingleBusErr == 1'b1) || (DualBusErr == 1'b1)) &&
            (iChIntErr == 1'b0))
    NextChIntErr     = ErrMask;

  if (ClrIntErr == 1'b1)
    NextSoftClrPulse = 1'b0;
  else if (((SingleBusErr == 1'b1) || (DualBusErr == 1'b1)) &&
            (SoftClrPulse == 1'b0) && (iChIntErr == 1'b0))
    NextSoftClrPulse = 1'b1;
  else
    NextSoftClrPulse = 1'b0;
end // p_IntErrComb

// -----------------------------------------------------------------------------
// Logic to handle TC Interrupt
// -----------------------------------------------------------------------------
always @(ClrIntTC or ChIntReg or IntMask or iDMACTC or DstReg or FlowCntl or
         DelDstState or DstTC or SrcErrOccrd or DstErrOccrd or DMACTCP2M)
begin : p_IntTCComb
  NextChIntReg     = ChIntReg;
  if ((ClrIntTC == 1'b1) || (SrcErrOccrd == 1'b1) || (DstErrOccrd == 1'b1))
    NextChIntReg     = 1'b0;
  else if (ChIntReg == 1'b0)
    begin
      if (IntMask == 1'b1)
        begin
          case (FlowCntl)
            3'b000, 3'b010 :
              if ((DelDstState == 1'b1) && (DstTC == `ZERO_14))
                NextChIntReg     = 1'b1;
              else
                NextChIntReg     = 1'b0;
    
            3'b110 :
              if ((DMACTCP2M == 1'b1) && (ChIntReg == 1'b0))
                NextChIntReg     = 1'b1;
              else
                NextChIntReg     = 1'b0;
    
            3'b001, 3'b011, 3'b100, 3'b101, 3'b111 :
               NextChIntReg     = iDMACTC[DstReg];
    
            default :
              NextChIntReg     = ChIntReg;
          endcase
        end
      else
        NextChIntReg     = ChIntReg;
    end
end // p_IntTCComb

assign ChIntTC          = ChIntReg;

assign DstReqCh         = DstReqBefMask & ( ~DstMask);
assign SrcReqCh         = SrcReqBefMask & ( ~SrcMask);
assign ReqConcat        = ({SrcReqCh, DstReqCh, LLIReq});

// -----------------------------------------------------------------------------
// Logic to generate channel request line combinationally
// Depending on the peripheral request ie source, destination or LLI loading
// the request lines are routed to the corresponding Arbiter. The Combinational
// grant lines are generated based on the internal arbiter grant. These grant
// signals are active for only one clock period.
// -----------------------------------------------------------------------------
always @(ChEnable or ReqConcat or DstAhbMasSel or SrcAhbMasSel or SameBus or
         DstReqCh or SrcReqCh or LLIAhbMasSel or ChComb1 or ChComb2 or DiffBus
         or DMACEn)
begin : p_ChReqComb
  ChReqArb1        = 1'b0;
  ChReqArb2        = 1'b0;
  DstSelComb       = 1'b0;
  SrcSelComb       = 1'b0;
  LLISelComb       = 1'b0;
  if ((ChEnable == 1'b1) && (DMACEn == 1'b1))
  begin
    case (ReqConcat)
      3'b000 :
        begin
          ChReqArb1        = 1'b0;
          ChReqArb2        = 1'b0;
          DstSelComb       = 1'b0;
          SrcSelComb       = 1'b0;
          LLISelComb       = 1'b0;
        end

      3'b010 :
        begin
          ChReqArb1        =  ~DstAhbMasSel;
          ChReqArb2        = DstAhbMasSel;
          DstSelComb       = SelComb(DstAhbMasSel, ChComb1, ChComb2);
        end

      3'b100 :
        begin
          ChReqArb1        =  ~SrcAhbMasSel;
          ChReqArb2        = SrcAhbMasSel;
          SrcSelComb       = SelComb(SrcAhbMasSel, ChComb1, ChComb2);
        end

      3'b110 :
        begin
          if (SameBus == 1'b1)
          begin
            if (DstReqCh == 1'b1)
            begin
               ChReqArb1        =  ~DstAhbMasSel;
               ChReqArb2        = DstAhbMasSel;
               DstSelComb       = SelComb(DstAhbMasSel, ChComb1, ChComb2);
            end
            else if (SrcReqCh == 1'b1)
            begin
               ChReqArb1        =  ~SrcAhbMasSel;
               ChReqArb2        = SrcAhbMasSel;
               SrcSelComb       = SelComb(SrcAhbMasSel, ChComb1, ChComb2);
            end
          end
          if (DiffBus == 1'b1)
            begin
              if (DstReqCh == 1'b1)
                begin
                  if (DstAhbMasSel == 1'b0)
                    ChReqArb1        = 1'b1;
                  else
                    ChReqArb2        = 1'b1;
                  DstSelComb       = SelComb(DstAhbMasSel, ChComb1, ChComb2);
                end
              if (SrcReqCh == 1'b1)
                begin
                  if (SrcAhbMasSel == 1'b0)
                    ChReqArb1        = 1'b1;
                  else
                    ChReqArb2        = 1'b1;
                  SrcSelComb       = SelComb(SrcAhbMasSel, ChComb1, ChComb2);
                end
            end
        end

      3'b001 :
        begin
          ChReqArb1        =  ~LLIAhbMasSel;
          ChReqArb2        = LLIAhbMasSel;
          LLISelComb       = SelComb(LLIAhbMasSel, ChComb1, ChComb2);
        end

      default :
        begin
          ChReqArb1        = 'b0;
          ChReqArb2        = 'b0;
          DstSelComb       = 1'b0;
          SrcSelComb       = 1'b0;
          LLISelComb       = 'b0;
        end
    endcase
  end
end // p_ChReqComb

// -----------------------------------------------------------------------------
// Generation of NotValid Signals for Source
// -----------------------------------------------------------------------------
always @(NotValidSrcST or SrcSelComb or SrcAhbMasSel or MREADY1 or MREADY2 or
         ChannelState or SrcTxrOn or ChEnable or SrcErrOccrd)
begin : p_NotValidSrcComb
  NextSrcNotState  = NotValidSrcST;
  if ((ChEnable == 1'b1) && (ChannelState != `ST_LLI_LOAD) &&
      (SrcErrOccrd == 1'b0))
    begin
      case (NotValidSrcST)
        `ST_NOTVALIDSRC_IDLE :
          if ((SrcSelComb == 1'b1) && (MREADY(SrcAhbMasSel, MREADY1, MREADY2)
               == 1'b1))
            NextSrcNotState  = `ST_NOTVALIDSRC_2MREADY;
          else if ((SrcSelComb == 1'b1) && (MREADY(SrcAhbMasSel, MREADY1,
                    MREADY2) == 1'b0))
            NextSrcNotState  = `ST_NOTVALIDSRC_1MREADY;
  
        `ST_NOTVALIDSRC_1MREADY :
          if ((ChannelState == `ST_IDLE) || ((ChannelState == `ST_PER_DUAL_BUS)
              && (SrcTxrOn == 1'b0)))
            NextSrcNotState  = `ST_NOTVALIDSRC_IDLE;
          else if (MREADY(SrcAhbMasSel, MREADY1, MREADY2) == 1'b1)
            NextSrcNotState  = `ST_NOTVALIDSRC_2MREADY;
  
        `ST_NOTVALIDSRC_2MREADY :
          if ((ChannelState == `ST_IDLE) || ((ChannelState == `ST_PER_DUAL_BUS)
              && (SrcTxrOn == 1'b0)))
            NextSrcNotState  = `ST_NOTVALIDSRC_IDLE;
          else if (MREADY(SrcAhbMasSel, MREADY1, MREADY2) == 1'b1)
            NextSrcNotState  = `ST_NOTVALIDSRC_IDLE;
  
        default :
          NextSrcNotState  = NotValidSrcST;
      endcase
    end
  else
    NextSrcNotState  = `ST_NOTVALIDSRC_IDLE;
end // p_NotValidSrcComb

assign NotValidDataSrc  = (NotValidSrcST != `ST_NOTVALIDSRC_IDLE) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of NotValid Signals for Destination
// -----------------------------------------------------------------------------
always @(NotValidDstST or DstSelComb or DstAhbMasSel or MREADY1 or MREADY2 or
         ChannelState or DstTxrOn or DstErrOccrd or ChEnable)
begin : p_NotValidDstComb
  NextDstNotState  = NotValidDstST;
  if ((ChEnable == 1'b1) && (ChannelState != `ST_LLI_LOAD) &&
      (DstErrOccrd == 1'b0))
    begin
      case (NotValidDstST)
        `ST_NOTVALIDDST_IDLE :
          if ((DstSelComb == 1'b1) && (MREADY(DstAhbMasSel, MREADY1,
               MREADY2) == 1'b1))
            NextDstNotState  = `ST_NOTVALIDDST_2MREADY;
          else if ((DstSelComb == 1'b1) && (MREADY(DstAhbMasSel, MREADY1,
                    MREADY2) == 1'b0))
            NextDstNotState  = `ST_NOTVALIDDST_1MREADY;
  
        `ST_NOTVALIDDST_1MREADY :
          if ((ChannelState == `ST_IDLE) || ((ChannelState == `ST_PER_DUAL_BUS)
              && (DstTxrOn == 1'b0)))
            NextDstNotState  = `ST_NOTVALIDDST_IDLE;
          else if (MREADY(DstAhbMasSel, MREADY1, MREADY2) == 1'b1)
            NextDstNotState  = `ST_NOTVALIDDST_2MREADY;
  
        `ST_NOTVALIDDST_2MREADY :
          if ((ChannelState == `ST_IDLE) || ((ChannelState == `ST_PER_DUAL_BUS)
              && (DstTxrOn == 1'b0)))
            NextDstNotState  = `ST_NOTVALIDDST_IDLE;
          else if (MREADY(DstAhbMasSel, MREADY1, MREADY2) == 1'b1)
            NextDstNotState  = `ST_NOTVALIDDST_IDLE;
  
        default :
          NextDstNotState  = NotValidDstST;
      endcase
    end
  else
    NextDstNotState  = `ST_NOTVALIDDST_IDLE;
end // p_NotValidDstComb

assign NotValidDataDst  = (NotValidDstST != `ST_NOTVALIDDST_IDLE) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of NotValid Signals for LLI
// -----------------------------------------------------------------------------
always @(NotValidLLIST or LLISelComb or LLIAhbMasSel or MREADY1 or MREADY2 or
         ChannelState or ChEnable)
begin : p_NotValidLLIComb
  NextLLINotState  = NotValidLLIST;
  if (ChEnable == 1'b1)
    begin
      case (NotValidLLIST)
        `ST_NOTVALIDLLI_IDLE :
          if ((LLISelComb == 1'b1) && (MREADY(LLIAhbMasSel, MREADY1,
               MREADY2) == 1'b1))
            NextLLINotState  = `ST_NOTVALIDLLI_2MREADY;
          else if ((LLISelComb == 1'b1) && (MREADY(LLIAhbMasSel, MREADY1,
                    MREADY2) == 1'b0))
            NextLLINotState  = `ST_NOTVALIDLLI_1MREADY;
        `ST_NOTVALIDLLI_1MREADY :
          if (ChannelState == `ST_IDLE)
            NextLLINotState  = `ST_NOTVALIDLLI_IDLE;
          else if (MREADY(LLIAhbMasSel, MREADY1, MREADY2) == 1'b1)
            NextLLINotState  = `ST_NOTVALIDLLI_2MREADY;
        `ST_NOTVALIDLLI_2MREADY :
          if (ChannelState == `ST_IDLE)
            NextLLINotState  = `ST_NOTVALIDLLI_IDLE;
          else if (MREADY(LLIAhbMasSel, MREADY1, MREADY2) == 1'b1)
            NextLLINotState  = `ST_NOTVALIDLLI_IDLE;
        default :
          NextLLINotState  = NotValidLLIST;
      endcase
    end
  else
    NextLLINotState  = `ST_NOTVALIDLLI_IDLE;
end // p_NotValidLLIComb

assign NotValidDataLLI  = (NotValidLLIST != `ST_NOTVALIDLLI_IDLE) ? 1'b1 : 1'b0;

assign SrcBurstChNxt    = SrcBurstCal(FlowCntl, NextSrcBurst, NxtSrcBstDstFlow,
                                      NextSourceTC);
assign SrcBurstCh       = SrcBurstCal(FlowCntl, SrcBurst, SrcBstDstFlow,
                                      SourceTC);
assign DstBurstChNxt    = DstBurstCal(FlowCntl, NextDstBurst, NxtDstBstSrcFlow,
                                      NextDstTC);
assign DstBurstCh       = DstBurstCal(FlowCntl, DstBurst, DstBstSrcFlow, DstTC);

// -----------------------------------------------------------------------------
// The Channel State machine has following states
// `ST_IDLE:
//   In this state the SM waits for the source request to be granted or the
//   destination request to be granted from the arbiter. For the arbiter it is
//   the channel request which comes as an input. The grant the SM receives is
//   for 1HCLK. From this state the SM makes a transition to `ST_SRC_DMA_XFER
//   state if the peripherals are on same bus or else it will make a transition
//   to `ST_PER_DUAL_BUS. SM makes a transition to `ST_DMA_DST_XFER state if
//   destination request is sampled asserted and the peripherals are on same
//   bus or else it will move to `ST_PER_DUAL_BUS. when making the transition
//   either the SourceBeat or the DstBeat counters are loaded. It is this count
//   that the AHB is supposed to carry out.
//
// `ST_SRC_DMA_XFER:
//   In this state SM does source fetching. The Data from source peripheral is
//   put into FIFO. There cannot be a source transactions followed by another
//   source transactions hence the SrcMask becomes active when in this state.
//   The SM makes a transition to `ST_DMA_DST_XFER state if the destination
//   request is active. The DataValid's are interpreted properly by generating
//   NotValidData signal. If the destination request is not sampled asserted
//   then SM will move to `ST_IDLE.
//
// `ST_DMA_DST_XFER:
//   In this state data is drained out of the FIFO, to the destinational
//   peripheral. There cannot be a destination transactions followed by another
//   destination transactions hence the DstMask becomes active when in this
//   state. The SM can switch to `ST_LLI_LOAD state if the LLILoad is not null
//   and DstTC counter has expired. SM makes a transition to `ST_SRC_DMA_XFER
//   state if the source grant is sampled asserted. transition takes place at
//   the end of the dataphase for the last destination beat committed. If there
//   is no LLILoad and no Source Grant then the SM will move to `ST_IDLE state.
//
// `ST_PER_DUAL_BUS:
//   In this state both source fetching and draining of data happens. A
//   separate signal SrcTxrOn indicates that source transfer is going on and
//   DstTxrOn indicates that destination transfer is going on. In this dual bus
//   operation is happening so there is no forecasting of fifo levels to fetch
//   the data or for draining the data. The SM makes a transition from this
//   state only after DstTC counter expires. transition can happen to
//   `ST_LLI_LOAD or `ST_IDLE state depending upon LLILoad value being not null.
//
// `ST_LLI_LOAD:
//   In this state LLILoading takes place. Here a transfer of 4 words is
//   intimated to the AhbMaster module depending on the location where LLI is
//   located. From this state SM makes a transition to `ST_IDLE state.
// -----------------------------------------------------------------------------
always @(ChannelState or SrcBeat or DstBeat or SrcSelComb or SameBus or
         SrcLoadComb or DstSelComb or DstLoadComb or DiffBus or FlowCntl or
         SrcAhbMasSel or SrcDisAckOccrd or SrcErrMask or DstSelReg or
         DstAhbMasSel or DstDisAckOccrd or DstErrMask or SrcSelReg or
         SrcTxrOn or DstTxrOn or LLIAhbMasSel or LLIBeat or TwoBitCnt or
         SrcBusWidth or SrcBurstChNxt or DMAFIFOLevel or SrcBurstCh or
         DstBusWidth or DstBurstChNxt or DstBurstCh or DstTC or DstTCSrcFlow or 
         SrcLstOccrd or DstLstOccrd or ErrorMas1 or ErrorMas2 or LLILoad or
         ActFifoLevel or AddrPhase or DstBeatCopy or SrcMaskReg or
         PredictFactor or NotValidDataDst or NotValidDataSrc or
         NotValidDataLLI or LLISelReg or LLISelComb or DstErrOccrd or
         ValidDataSrc or LLIReq or ValidDataDst or ValidDataLLI or
         LLIDisAckOccrd or LLISelReg)
begin : p_ChSMComb
  NextSrcBeat      = SrcBeat;
  NextChState      = ChannelState;
  NextDstBeat      = DstBeat;
  NextDstSelReg    = DstSelReg;
  NextSrcSelReg    = SrcSelReg;
  NextLLISelReg    = LLISelReg;
  NextLLIBeat      = LLIBeat;
  NextDstTxrOn     = DstTxrOn;
  NextSrcTxrOn     = SrcTxrOn;
  NextTwoBitCnt    = TwoBitCnt;
  case (ChannelState)
    `ST_IDLE :
      begin
        if ((SrcSelComb == 1'b1) && (SameBus == 1'b1) && (ErrorMas(SrcAhbMasSel,
             ErrorMas1, ErrorMas2) == 1'b0))
          begin
            NextChState      = `ST_SRC_DMA_XFER;
            if (SrcLoadComb == 1'b1)
              NextSrcBeat      = SrcBeatCount(SrcBusWidth, DstBusWidth,
                                              DstBeatCopy, SrcBurstChNxt,
                                              DMAFIFOLevel, ActFifoLevel,
                                              ChannelState, AddrPhase, SameBus);
            else
              NextSrcBeat      = SrcBeatCount(SrcBusWidth, DstBusWidth,
                                              DstBeatCopy, SrcBurstCh,
                                              DMAFIFOLevel, ActFifoLevel,
                                              ChannelState, AddrPhase, SameBus);
          end
  
        if ((DstSelComb == 1'b1) && (SameBus == 1'b1) && (ErrorMas(DstAhbMasSel,
             ErrorMas1, ErrorMas2) == 1'b0))
          begin
            NextChState      = `ST_DMA_DST_XFER;
            if (DstLoadComb == 1'b1)
              NextDstBeat      = DstBeatCount(DstBusWidth, SrcBusWidth,
                                              PredictFactor, DstBurstChNxt,
                                              DMAFIFOLevel);
            else
              NextDstBeat      = DstBeatCount(DstBusWidth, SrcBusWidth,
                                              PredictFactor, DstBurstCh,
                                              DMAFIFOLevel);
          end
  
        if (((SrcSelComb == 1'b1) || (DstSelComb == 1'b1)) && (DiffBus == 1'b1))
          begin
            NextChState      = `ST_PER_DUAL_BUS;
            if (ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) == 1'b0)
              begin
                NextSrcTxrOn     = SrcSelComb;
                if (SrcLoadComb == 1'b1)
                  NextSrcBeat      = SrcBeatCount(SrcBusWidth, DstBusWidth,
                                                  DstBeatCopy, SrcBurstChNxt,
                                                  DMAFIFOLevel, ActFifoLevel,
                                                  ChannelState, AddrPhase,
                                                  SameBus);
                else
                  NextSrcBeat      = SrcBeatCount(SrcBusWidth, DstBusWidth,
                                                  DstBeatCopy, SrcBurstCh,
                                                  DMAFIFOLevel, ActFifoLevel,
                                                  ChannelState, AddrPhase,
                                                  SameBus);
              end
            if (ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) == 1'b0)
              begin
                NextDstTxrOn     = DstSelComb;
                if (DstLoadComb == 1'b1)
                  NextDstBeat      = DstBeatCount(DstBusWidth, SrcBusWidth,
                                                  PredictFactor, DstBurstChNxt,
                                                  DMAFIFOLevel);
                else
                  NextDstBeat      = DstBeatCount(DstBusWidth, SrcBusWidth,
                                                  PredictFactor, DstBurstCh,
                                                  DMAFIFOLevel);
              end
          end
      end

    `ST_SRC_DMA_XFER :
      begin
        if (DstSelComb == 1'b1)
          begin
            NextDstSelReg    = DstSelComb;
            if (DstLoadComb == 1'b1)
              NextDstBeat      = DstBeatCount(DstBusWidth, SrcBusWidth,
                                              PredictFactor, DstBurstChNxt,
                                              DMAFIFOLevel);
            else
              NextDstBeat      = DstBeatCount(DstBusWidth, SrcBusWidth,
                                              PredictFactor, DstBurstCh,
                                              DMAFIFOLevel);
          end
  
        if ((SrcDisAckOccrd == 1'b0) && (SrcErrMask == 1'b0) &&
            ( ~((NotValidDataSrc == 1'b1) && (ErrorMas(SrcAhbMasSel, ErrorMas1,
                 ErrorMas2) == 1'b1))))
          begin
            if ((SrcBeat == 5'b00001) && (ValidDataSrc == 1'b1) &&
                (NotValidDataSrc == 1'b0))
              begin
                NextSrcBeat      = ('b0);
                if ((DstSelReg == 1'b1) || (DstSelComb == 1'b1))
                  begin
                    NextDstSelReg    = 1'b0;
                    NextChState      = `ST_DMA_DST_XFER;
                  end
                else
                  begin
                    NextChState      = `ST_IDLE;
                    NextDstBeat      = ('b0);
                  end
              end
            else if ((ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
              NextSrcBeat      = SrcBeat - 1'b1;
          end
        else
          begin
            NextChState      = `ST_IDLE;
            NextSrcBeat      = ('b0);
            NextDstSelReg    = 1'b0;
            NextDstBeat      = ('b0);
          end
      end

    `ST_DMA_DST_XFER :
      begin
        if (SrcSelComb == 1'b1)
          begin
            NextSrcSelReg    = SrcSelComb;
            if (SrcLoadComb == 1'b1)
              NextSrcBeat      = SrcBeatCount(SrcBusWidth, DstBusWidth,
                                              DstBeatCopy, SrcBurstChNxt,
                                              DMAFIFOLevel, ActFifoLevel,
                                              ChannelState, AddrPhase, SameBus);
            else
              NextSrcBeat      = SrcBeatCount(SrcBusWidth, DstBusWidth,
                                              DstBeatCopy, SrcBurstCh,
                                              DMAFIFOLevel, ActFifoLevel,
                                              ChannelState, AddrPhase, SameBus);
          end
  
        if ((DstDisAckOccrd == 1'b0) && (DstErrMask == 1'b0) &&
            ((NotValidDataDst & ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2))
              == 1'b0))
      //    ( ~((NotValidDataDst == 1'b1) && (ErrorMas(DstAhbMasSel, ErrorMas1,
      //    ErrorMas2) == 1'b1))))
          begin
            if (DstBeat != 5'b00001)
              begin
                if ((ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0))
                  NextDstBeat      = DstBeat - 1'b1;
              end
            else if ((ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0))
              begin
                NextDstBeat      = ('b0);
                if (((SelTC(FlowCntl, DstTC, DstTCSrcFlow, SrcLstOccrd,
                            DstLstOccrd) == `ONE_14) || ((SrcMaskReg == 1'b1) &&
                            (ActFifoLevel == 5'b00000) &&
                            (DMAFIFOLevel == 5'b00000) &&
                            (FlowCntl[2:1] == 2'b11))) && (LLILoad != `ZERO_30))
                  begin
                    NextChState      = `ST_LLI_LOAD;
                    NextLLIBeat      = 3'b100;
                    NextSrcBeat      = ('b0);
                  end
                else if (((SelTC(FlowCntl, DstTC, DstTCSrcFlow, SrcLstOccrd,
                           DstLstOccrd) == `ONE_14) || ((SrcMaskReg == 1'b1) &&
                          (DMAFIFOLevel == 5'b00000) &&
                          (ActFifoLevel == 5'b00000) &&
                          (FlowCntl[2:1] == 2'b11))) && (LLILoad == `ZERO_30))
                  begin
                    NextSrcBeat      = ('b0);
                    NextChState      = `ST_IDLE;
                    NextSrcSelReg    = 1'b0;
                  end
                else if ((DstBeat == 5'b00001) && ((SrcSelReg == 1'b1) ||
                         (SrcSelComb == 1'b1)))
                  begin
                    NextSrcSelReg    = 1'b0;
                    NextChState      = `ST_SRC_DMA_XFER;
                  end
                else
                  begin
                    NextChState      = `ST_IDLE;
                    NextSrcBeat      = ('b0);
                    NextSrcSelReg    = 1'b0;
                  end
              end
          end
        else
          begin
            NextChState      = `ST_IDLE;
            NextDstBeat      = ('b0);
            NextSrcSelReg    = 1'b0;
            NextSrcBeat      = ('b0);
          end
      end

    `ST_PER_DUAL_BUS :
      begin
        if ((DstSelComb == 1'b1) || (DstTxrOn == 1'b1))
          begin
            NextDstTxrOn     = 1'b1;
            if (DstSelComb == 1'b1)
              begin
                if (DstLoadComb == 1'b1)
                  NextDstBeat      = DstBeatCount(DstBusWidth, SrcBusWidth,
                                                  PredictFactor, DstBurstChNxt,
                                                  DMAFIFOLevel);
                else
                  NextDstBeat      = DstBeatCount(DstBusWidth, SrcBusWidth,
                                                  PredictFactor, DstBurstCh,
                                                  DMAFIFOLevel);
              end
            else if ((DstDisAckOccrd == 1'b0) && (DstErrMask == 1'b0) &&
                     ( ~((NotValidDataDst == 1'b1) && (ErrorMas(DstAhbMasSel,
                          ErrorMas1, ErrorMas2) == 1'b1))))
              begin
                if (DstBeat != 5'b00001)
                  begin
                    if ((ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0))
                      NextDstBeat      = DstBeat - 1'b1;
                  end
                else if ((ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0))
                  begin
                    NextDstBeat      = ('b0);
                    if (((SelTC(FlowCntl, DstTC, DstTCSrcFlow, SrcLstOccrd,
                          DstLstOccrd) == `ONE_14) || ((SrcMaskReg == 1'b1) &&
                         (DMAFIFOLevel == 5'b00000) &&
                         (ActFifoLevel == 5'b00000) &&
                         (FlowCntl[2:1] == 2'b11))) && (LLILoad != `ZERO_30) &&
                         (SrcTxrOn == 1'b0))
                      begin
                        NextChState      = `ST_LLI_LOAD;
                        NextLLIBeat      = 3'b100;
                        NextDstTxrOn     = 1'b0;
                        NextDstBeat      = ('b0);
                      end
                    else if (((SelTC(FlowCntl, DstTC, DstTCSrcFlow, SrcLstOccrd,
                                     DstLstOccrd) == `ONE_14) ||
                             ((SrcMaskReg == 1'b1) && (DMAFIFOLevel == 5'b00000)
                             && (ActFifoLevel == 5'b00000) &&
                             (FlowCntl[2:1] == 2'b11))) && (LLILoad == `ZERO_30)
                               && (SrcTxrOn == 1'b0))
                      begin
                        NextChState      = `ST_IDLE;
                        NextDstTxrOn     = 1'b0;
                        NextDstBeat      = ('b0);
                      end
                    else if (DstBeat == 5'b00001)
                      begin
                        NextDstTxrOn     = 1'b0;
                        NextDstBeat      = ('b0);
                      end
                  end
              end
            else if ((SrcTxrOn == 1'b0) && (SrcSelComb == 1'b0))
              begin
                NextChState      = `ST_IDLE;
                NextDstBeat      = ('b0);
                NextDstTxrOn     = 1'b0;
              end
            else
              begin
                NextDstBeat      = ('b0);
                NextDstTxrOn     = 1'b0;
              end
          end
        else if ((SrcTxrOn == 1'b0) && (SrcSelComb == 1'b0) &&
                 (DstErrOccrd == 1'b1))
          begin
            NextChState      = `ST_IDLE;
            NextDstBeat      = ('b0);
            NextDstTxrOn     = 1'b0;
          end
  
        if ((SrcSelComb == 1'b1) || (SrcTxrOn == 1'b1))
          begin
            NextSrcTxrOn     = 1'b1;
            if (SrcSelComb == 1'b1)
              begin
                if (SrcLoadComb == 1'b1)
                  NextSrcBeat      = SrcBeatCount(SrcBusWidth, DstBusWidth,
                                                  DstBeatCopy, SrcBurstChNxt,
                                                  DMAFIFOLevel, ActFifoLevel,
                                                  ChannelState, AddrPhase,
                                                  SameBus);
                else
                  NextSrcBeat      = SrcBeatCount(SrcBusWidth, DstBusWidth,
                                                  DstBeatCopy, SrcBurstCh,
                                                  DMAFIFOLevel, ActFifoLevel,
                                                  ChannelState, AddrPhase,
                                                  SameBus);
              end
            else if ((SrcDisAckOccrd == 1'b0) && (SrcErrMask == 1'b0) &&
                     ( ~((NotValidDataSrc == 1'b1) && (ErrorMas(SrcAhbMasSel,
                          ErrorMas1, ErrorMas2) == 1'b1))))
              begin
                if ((SrcBeat == 5'b00001) && (ValidDataSrc == 1'b1) &&
                    (NotValidDataSrc == 1'b0))
                  begin
                    NextSrcBeat      = ('b0);
                    NextSrcTxrOn     = 1'b0;
                  end
                else if ((ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
                  NextSrcBeat      = SrcBeat - 1'b1;
              end
            else
              begin
                NextSrcBeat      = ('b0);
                NextSrcTxrOn     = 1'b0;
              end
          end
      end

    `ST_LLI_LOAD :
      begin
        if (LLISelComb == 1'b1)
          NextLLISelReg    = 1'b1;
  
        if ((LLIDisAckOccrd == 1'b0) && ( ~((NotValidDataLLI == 1'b0) &&
            (LLIReq == 1'b0) && (ErrorMas(LLIAhbMasSel, ErrorMas1,
             ErrorMas2) == 1'b1) && (LLISelReg == 1'b1))))
          begin
            if ((LLIBeat == 5'b00001) && (ValidDataLLI == 1'b1) &&
                (NotValidDataLLI == 1'b0))
              begin
                NextLLIBeat      = ('b0);
                NextChState      = `ST_IDLE;
                NextLLISelReg    = 1'b0;
              end
            else if ((ValidDataLLI == 1'b1) && (NotValidDataLLI == 1'b0) &&
                     (LLISelReg == 1'b1))
              NextLLIBeat      = LLIBeat - 1'b1;
    
            if ((ValidDataLLI == 1'b1) && (NotValidDataLLI == 1'b0) &&
                (LLISelReg == 1'b1))
              NextTwoBitCnt    = TwoBitCnt + 1'b1;
          end
        else
          begin
            NextChState      = `ST_IDLE;
            NextLLIBeat      = ('b0);
            NextTwoBitCnt    = ('b0);
            NextLLISelReg    = 1'b0;
          end
      end

    default :
      begin
        NextSrcBeat      = SrcBeat;
        NextChState      = ChannelState;
        NextDstBeat      = DstBeat;
        NextDstSelReg    = DstSelReg;
        NextSrcSelReg    = SrcSelReg;
        NextLLISelReg    = LLISelReg;
        NextLLIBeat      = LLIBeat;
        NextDstTxrOn     = DstTxrOn;
        NextSrcTxrOn     = SrcTxrOn;
        NextTwoBitCnt    = TwoBitCnt;
      end
  endcase
end // p_ChSMComb

// -----------------------------------------------------------------------------
// DMACCLR and DMACTC are generated here because it is set in One state of the
// State machine and gets cleared in another state. so it is better to control
// it from a separate always block. Here care has been taken care to select the
// right Burst or TC counters depending on the Flow Controller.
// -----------------------------------------------------------------------------
always @(FlowCntl or SrcReg or DstReg or DstReqBefMask or DstTC or iDMACTC or
         iDMACCLR or DstBurst or SrcReqBefMask or SourceTC or SrcBurst or
         DstLstSrc or SrcTCDstFlow or SrcBstDstFlow or DstLstOccrd or
         SrcLstOccrd or DstBstSrcFlow or DstFlowReq or SrcMaskReg or
         DMAFIFOLevel or ActFifoLevel or DelSrcState or NotValidDataDst or
         NotValidDataSrc or DMACTCP2M or DstBeat or SrcErrOccrd or DstErrOccrd
         or ClrIntTC or IntMask or SrcState or DstState or ValidDataDst or
         ValidDataSrc)
begin : p_ClrTCComb
  NextDMACCLR      = iDMACCLR;
  NextDMACTC       = iDMACTC;
  NextDMACTCP2M    = DMACTCP2M;
  case (FlowCntl)
    3'b000 :
      begin
        NextDMACCLR[SrcReg] = 1'b0;
        NextDMACTC[SrcReg] = 1'b0;
        NextDMACTC[DstReg] = 1'b0;
        NextDMACCLR[DstReg] = 1'b0;
      end

    3'b001 :
      begin
        if (DstReqBefMask == 1'b0)
          begin
            NextDMACTC[DstReg] = 1'b0;
            NextDMACCLR[DstReg] = 1'b0;
          end
        else if ((DstTC == `ONE_14) && (ValidDataDst == 1'b1) &&
                 (NotValidDataDst == 1'b0))
          begin
            if ((iDMACTC[DstReg] == 1'b0) && (iDMACCLR[DstReg] == 1'b0) &&
                (DstState == 1'b1))
              begin
                NextDMACTC[DstReg] = 1'b1;
                NextDMACCLR[DstReg] = 1'b1;
              end
          end
        else if ((DstBurst == `ONE_14) && (ValidDataDst == 1'b1) &&
                 (NotValidDataDst == 1'b0))
          if ((iDMACCLR[DstReg] == 1'b0) && (DstState == 1'b1))
            NextDMACCLR[DstReg] = 1'b1;
      end

    3'b010 :
      begin
        if (SrcReqBefMask == 1'b0)
          begin
            NextDMACTC[SrcReg] = 1'b0;
            NextDMACCLR[SrcReg] = 1'b0;
          end
        else if ((SourceTC == `ONE_14) && (ValidDataSrc == 1'b1) &&
                 (NotValidDataSrc == 1'b0))
          begin
            if ((iDMACTC[SrcReg] == 1'b0) && (iDMACCLR[SrcReg] == 1'b0) &&
                (SrcState == 1'b1))
              begin
                NextDMACTC[SrcReg] = 1'b1;
                NextDMACCLR[SrcReg] = 1'b1;
              end
          end
        else if ((SrcBurst == `ONE_14) && (ValidDataSrc == 1'b1) &&
                 (NotValidDataSrc == 1'b0))
          if ((iDMACCLR[SrcReg] == 1'b0) && (SrcState == 1'b1))
            NextDMACCLR[SrcReg] = 1'b1;
      end

    3'b011 :
      begin
        if (SrcReqBefMask == 1'b0)
          begin
            NextDMACTC[SrcReg] = 1'b0;
            NextDMACCLR[SrcReg] = 1'b0;
          end
        else if ((SourceTC == `ONE_14) && (ValidDataSrc == 1'b1) &&
                 (NotValidDataSrc == 1'b0))
          begin
            if ((iDMACTC[SrcReg] == 1'b0) && (iDMACCLR[SrcReg] == 1'b0) &&
                (SrcState == 1'b1))
              begin
                NextDMACTC[SrcReg] = 1'b1;
                NextDMACCLR[SrcReg] = 1'b1;
              end
          end
        else if ((SrcBurst == `ONE_14) && (ValidDataSrc == 1'b1) &&
                 (NotValidDataSrc == 1'b0))
          if ((iDMACCLR[SrcReg] == 1'b0) && (SrcState == 1'b1))
            NextDMACCLR[SrcReg] = 1'b1;
  
        if (DstReqBefMask == 1'b0)
          begin
            NextDMACTC[DstReg] = 1'b0;
            NextDMACCLR[DstReg] = 1'b0;
          end
        else if ((DstTC == `ONE_14) && (ValidDataDst == 1'b1) &&
                 (NotValidDataDst == 1'b0))
          begin
            if ((iDMACTC[DstReg] == 1'b0) && (iDMACCLR[DstReg] == 1'b0) &&
                (DstState == 1'b1))
            begin
              NextDMACTC[DstReg] = 1'b1;
              NextDMACCLR[DstReg] = 1'b1;
            end
          end
        else if ((DstBurst == `ONE_14) && (ValidDataDst == 1'b1) &&
                 (NotValidDataDst == 1'b0))
          if ((iDMACCLR[DstReg] == 1'b0) && (DstState == 1'b1))
            NextDMACCLR[DstReg] = 1'b1;
      end

    3'b100 :
      begin
        if (SrcReqBefMask == 1'b0)
          begin
            NextDMACTC[SrcReg] = 1'b0;
            NextDMACCLR[SrcReg] = 1'b0;
          end
        else if ((DstLstSrc == 1'b1) && (SrcTCDstFlow == `ONE_14) &&
                 (ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
          begin
            if ((iDMACTC[SrcReg] == 1'b0) && (iDMACCLR[SrcReg] == 1'b0) &&
                (SrcState == 1'b1))
              begin
                NextDMACTC[SrcReg] = 1'b1;
                NextDMACCLR[SrcReg] = 1'b1;
              end
          end
        else if (((SrcBurst == `ONE_14) || (SrcBstDstFlow == `ONE_14)) &&
                  (ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
          if ((iDMACCLR[SrcReg] == 1'b0) && (SrcState == 1'b1))
            NextDMACCLR[SrcReg] = 1'b1;
  
        if (DstFlowReq == 1'b0)
          begin
            NextDMACTC[DstReg] = 1'b0;
            NextDMACCLR[DstReg] = 1'b0;
          end
        else if (((DstLstOccrd == 1'b1) && (DstTC == `ONE_14)) &&
                  (ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0))
          begin
            if ((iDMACTC[DstReg] == 1'b0) && (iDMACCLR[DstReg] == 1'b0) &&
                (DstState == 1'b1))
              begin
                NextDMACTC[DstReg] = 1'b1;
                NextDMACCLR[DstReg] = 1'b1;
              end
          end
        else if ((DstBurst == `ONE_14) && (ValidDataDst == 1'b1) &&
                 (NotValidDataDst == 1'b0))
          if ((iDMACCLR[DstReg] == 1'b0) && (DstState == 1'b1))
             NextDMACCLR[DstReg] = 1'b1;
      end

    3'b101 :
      begin
        if (DstFlowReq == 1'b0)
          begin
            NextDMACTC[DstReg] = 1'b0;
            NextDMACCLR[DstReg] = 1'b0;
          end
        else if ((DstLstOccrd == 1'b1) && (DstTC == `ONE_14) &&
                 (ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0))
          begin
            if ((iDMACTC[DstReg] == 1'b0) && (iDMACCLR[DstReg] == 1'b0) &&
                (DstState == 1'b1))
            begin
              NextDMACTC[DstReg] = 1'b1;
              NextDMACCLR[DstReg] = 1'b1;
            end
          end
        else if ((DstBurst == `ONE_14) && (ValidDataDst == 1'b1) &&
                 (NotValidDataDst == 1'b0))
          if ((iDMACCLR[DstReg] == 1'b0) && (DstState == 1'b1))
            NextDMACCLR[DstReg] = 1'b1;
      end

    3'b110 :
      begin
        if (SrcReqBefMask == 1'b0)
          begin
            NextDMACTC[SrcReg] = 1'b0;
            NextDMACCLR[SrcReg] = 1'b0;
          end
        else if ((SrcLstOccrd == 1'b1) && (SourceTC == `ONE_14) &&
                 (ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
          begin
            if ((iDMACTC[SrcReg] == 1'b0) && (iDMACCLR[SrcReg] == 1'b0) &&
                (SrcState == 1'b1))
              begin
                NextDMACTC[SrcReg] = 1'b1;
                NextDMACCLR[SrcReg] = 1'b1;
              end
          end
        else if ((SrcBurst == `ONE_14) && (ValidDataSrc == 1'b1) &&
                 (NotValidDataSrc == 1'b0))
          if ((iDMACCLR[SrcReg] == 1'b0) && (SrcState == 1'b1))
             NextDMACCLR[SrcReg] = 1'b1;
  
        if (((ClrIntTC == 1'b1) || (SrcErrOccrd == 1'b1) ||
            (DstErrOccrd == 1'b1)) && (IntMask == 1'b1))
          NextDMACTCP2M    = 1'b0;
        else if ((SrcLstOccrd == 1'b1) && (DMAFIFOLevel == 5'b00000) &&
                 (ActFifoLevel == 5'b00000) && (SrcMaskReg == 1'b1) &&
                 (DelSrcState == 1'b0) && (ValidDataDst == 1'b1) &&
                 (NotValidDataDst == 1'b0))
          if ((DMACTCP2M == 1'b0) && (DstBeat == 5'b00001) &&
              (DstState == 1'b1))
            NextDMACTCP2M    = 1'b1;
      end

    3'b111 :
      begin
        if (SrcReqBefMask == 1'b0)
          begin
            NextDMACTC[SrcReg] = 1'b0;
            NextDMACCLR[SrcReg] = 1'b0;
          end
        else if ((SrcLstOccrd == 1'b1) && (SourceTC == `ONE_14) &&
                 (ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
          begin
            if (((iDMACTC[SrcReg] == 1'b0) && (iDMACCLR[SrcReg] == 1'b0)) &&
                 (SrcState == 1'b1))
            begin
              NextDMACTC[SrcReg] = 1'b1;
              NextDMACCLR[SrcReg] = 1'b1;
            end
          end
        else if ((SrcBurst == `ONE_14) && (ValidDataSrc == 1'b1) &&
                 (NotValidDataSrc == 1'b0))
          if ((iDMACCLR[SrcReg] == 1'b0) && (SrcState == 1'b1))
            NextDMACCLR[SrcReg] = 1'b1;
  
        if (DstReqBefMask == 1'b0)
          begin
            NextDMACTC[DstReg] = 1'b0;
            NextDMACCLR[DstReg] = 1'b0;
          end
        else if ((SrcLstOccrd == 1'b1) && (DMAFIFOLevel == 5'b00000) &&
                 (ActFifoLevel == 5'b00000) && (SrcMaskReg == 1'b1) &&
                 (DelSrcState == 1'b0) && (ValidDataDst == 1'b1) &&
                 (DstBeat == 5'b00001) && (NotValidDataDst == 1'b0))
          begin
            if ((iDMACTC[DstReg] == 1'b0) && (iDMACCLR[DstReg] == 1'b0) &&
                (DstState == 1'b1))
            begin
              NextDMACTC[DstReg] = 1'b1;
              NextDMACCLR[DstReg] = 1'b1;
            end
          end
        else if (((DstBstSrcFlow == `ONE_14) || (DstBurst == `ONE_14)) &&
                  (ValidDataDst == 1'b1) && (NotValidDataDst == 1'b0))
          if ((iDMACCLR[DstReg] == 1'b0) && (DstState == 1'b1))
            NextDMACCLR[DstReg] = 1'b1;
      end

    default :
      begin
        NextDMACCLR      = iDMACCLR;
        NextDMACTC       = iDMACTC;
        NextDMACTCP2M    = DMACTCP2M;
      end
  endcase
end // p_ClrTCComb

// -----------------------------------------------------------------------------
// ORed version of Source Burst Request including SoftReq
// -----------------------------------------------------------------------------
assign BstRqSrc         = DMACBREQ[SrcReg] | SOFTBREQ[SrcReg];

// -----------------------------------------------------------------------------
// ORed version of Source Single Request including SoftReq
// -----------------------------------------------------------------------------
assign SglRqSrc         = DMACSREQ[SrcReg] | SOFTSREQ[SrcReg];

// -----------------------------------------------------------------------------
// ORed version of Destination Burst Request including SoftReq
// -----------------------------------------------------------------------------
assign BstRqDst         = DMACBREQ[DstReg] | SOFTBREQ[DstReg];

// -----------------------------------------------------------------------------
// ORed version of Destination Single Request including SoftReq
// -----------------------------------------------------------------------------
assign SglRqDst         = DMACSREQ[DstReg] | SOFTSREQ[DstReg];

// -----------------------------------------------------------------------------
// ORed version of Destination Burst/Last Burst Request including SoftReq
// -----------------------------------------------------------------------------
assign BstRqDstAll      = DMACBREQ[DstReg] | DMACLBREQ[DstReg] |
                          SOFTBREQ[DstReg] | SOFTLBREQ[DstReg];

// -----------------------------------------------------------------------------
// ORed version of Destination Single/Last Single Request including SoftReq
// -----------------------------------------------------------------------------
assign SglRqDstAll      = SOFTSREQ[DstReg] | SOFTLSREQ[DstReg] |
                          DMACSREQ[DstReg] | DMACLSREQ[DstReg];

// -----------------------------------------------------------------------------
// ORed version of Source Burst/Last Burst Request including SoftReq
// -----------------------------------------------------------------------------
assign BstRqSrcAll      = DMACBREQ[SrcReg] | DMACLBREQ[SrcReg] |
                          SOFTBREQ[SrcReg] | SOFTLBREQ[SrcReg];

// -----------------------------------------------------------------------------
// ORed version of Source Single/Last Single Request including SoftReq
// -----------------------------------------------------------------------------
assign SglRqSrcAll      = SOFTSREQ[SrcReg] | SOFTLSREQ[SrcReg] |
                          DMACSREQ[SrcReg] | DMACLSREQ[SrcReg];

// -----------------------------------------------------------------------------
// Logic to Load Burst Count and Transfer Count for Source and Destination
// peripheral. Also this block decrements the Count based on Datavalid's rxd.
// The counters are loaded based on the flow controller and also corresponding
// SrcSelComb or DstSelComb is required. Both the source and destination
// counters can be loaded simultaneously. Hence it is written in the same
// process as there is dependency on other counters.
// -----------------------------------------------------------------------------
always @(SrcSelComb or FlowCntl or SrcBurst or SourceTC or DstLstSrc or
         SrcBstDstFlow or FactorOnDstNum or FactorOnDstDen or DMACLBREQ or
         DMACLSREQ or SOFTLBREQ or SOFTLSREQ or DstReg or SrcReg or
         ChannelState or SrcTCDstFlow or DstSelComb or DstBurst or DstTC or
         ChControlReg or FactorOnSrcNum or FactorOnSrcDen or SrcLstOccrd or
         DstBstSrcFlow or ChEnable or DstTCSrcFlow or SrcBurstSize or ZERO_1 or
         ONE_1 or SglRqSrc or BstRqSrc or BstRqDst or BstRqDstAll or
         SglRqDstAll or BstRqSrcAll or SglRqSrcAll or NotValidDataDst or
         DstState or NotValidDataSrc or DstBurstSize or DstLstSrcReg or
         SrcLstOccrdReg or DstLstOccrdReg or ActFifoLevel or DMAFIFOLevel or
         DstBusWidth or SrcBusWidth or SrcMaskReg or DelSrcState or
         PredictFactor or DstBeat or SrcState or ValidDataSrc or ValidDataDst)
begin : p_DmaClrCntComb
   NextSrcBurst     = SrcBurst;
   NextDstBurst     = DstBurst;
   NextSourceTC     = SourceTC;
   NextDstTC        = DstTC;
   NxtSrcBstDstFlow = SrcBstDstFlow;
   NxtSrcTCDstFlow  = SrcTCDstFlow;
   NextDstLstSrc    = DstLstSrcReg;
   NextSrcLstOccrd  = SrcLstOccrdReg;
   NextDstLstOccrd  = DstLstOccrdReg;
   NxtDstBstSrcFlow = DstBstSrcFlow;
   NxtDstTCSrcFlow  = DstTCSrcFlow;
   SrcLoadComb      = 1'b0;
   DstLoadComb      = 1'b0;
  if ((SrcSelComb == 1'b1) && (ChEnable == 1'b1))
  begin
    case (FlowCntl)
      3'b000 :
        begin
          if (SrcBurst == `ZERO_14)
            begin
              NextSrcBurst     = BurstSize(SrcBurstSize, ZERO_1, ZERO_1, ONE_1);
              SrcLoadComb      = 1'b1;
            end
          if (SourceTC == `ZERO_14)
            NextSourceTC     = ({2'b00, ChControlReg[11:0]});
        end

      3'b001 :
        begin
          if (SrcBurst == `ZERO_14)
            begin
              NextSrcBurst     = BurstSize(SrcBurstSize, ZERO_1, ZERO_1, ONE_1);
              SrcLoadComb      = 1'b1;
            end
          if (SourceTC == `ZERO_14)
             NextSourceTC     = ({2'b00, ChControlReg[11:0]});
        end

      3'b010 :
        begin
          if (SrcBurst == `ZERO_14)
          begin
            NextSrcBurst = BurstSize(SrcBurstSize, SglRqSrc, BstRqSrc, ZERO_1);
            SrcLoadComb  = 1'b1;
          end
          if (SourceTC == `ZERO_14)
            NextSourceTC     = ({2'b00, ChControlReg[11:0]});
        end

      3'b011 :
        begin
          if (SrcBurst == `ZERO_14)
          begin
            NextSrcBurst = BurstSize(SrcBurstSize, SglRqSrc, BstRqSrc, ZERO_1);
            SrcLoadComb  = 1'b1;
          end
          if (SourceTC == `ZERO_14)
            NextSourceTC     = ({2'b00, ChControlReg[11:0]});
        end

      3'b100 :
        begin
          if (SrcBstDstFlow == `ZERO_14)
            begin
              Temp3 = BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll, ZERO_1)
                                                              * FactorOnDstNum;
              Temp1 = Temp3 / FactorOnDstDen;
              if (Temp1 == 15'b000000000000000)
                Temp1 = Temp1 + 1;
              NxtSrcBstDstFlow = Temp1[13:0];
              SrcLoadComb      = 1'b1;
            end
  
          if (SrcBurst == `ZERO_14)
            begin
              SrcLoadComb      = 1'b1;
              if (Temp1[13:0] > BurstSize(SrcBurstSize, SglRqSrc, BstRqSrc,
                  ZERO_1))
                NextSrcBurst = BurstSize(SrcBurstSize, SglRqSrc, BstRqSrc,
                                         ZERO_1);
              else
                NextSrcBurst     = Temp1[13:0];
            end
  
          if (SrcTCDstFlow == `ZERO_14)
            begin
              if ((DMACLBREQ[DstReg] | DMACLSREQ[DstReg] | SOFTLBREQ[DstReg] |
                   SOFTLSREQ[DstReg]) == 1'b1)
              begin
                Temp3 = BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                  ZERO_1) * FactorOnDstNum;
                Temp1 = Temp3 / FactorOnDstDen;
                if (Temp1 == 15'b000000000000000)
                  Temp1 = Temp1 + 1;
                NxtSrcTCDstFlow  = Temp1[13:0];
                NextDstLstSrc    = 1'b1;
              end
            end
        end

      3'b101 :
        begin
          if (SrcBstDstFlow == `ZERO_14)
            begin
              Temp3 = BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                ZERO_1) * FactorOnDstNum;
              Temp1 = Temp3 / FactorOnDstDen;
              if (Temp1 == 15'b000000000000000)
                Temp1 = Temp1 + 1;
              NxtSrcBstDstFlow = Temp1[13:0];
              SrcLoadComb      = 1'b1;
            end
  
          if (SrcBurst == `ZERO_14)
            begin
              SrcLoadComb      = 1'b1;
              if (Temp1[13:0] > BurstSize(SrcBurstSize, ZERO_1, ZERO_1, ONE_1))
                 NextSrcBurst = BurstSize(SrcBurstSize, ZERO_1, ZERO_1, ONE_1);
              else
                NextSrcBurst  = Temp1[13:0];
            end
  
          if (SrcTCDstFlow == `ZERO_14)
            begin
              if ((DMACLBREQ[DstReg] | DMACLSREQ[DstReg] | SOFTLBREQ[DstReg] |
                   SOFTLSREQ[DstReg]) == 1'b1)
              begin
                Temp3 = BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                  ZERO_1) * FactorOnDstNum;
                Temp1 = Temp3 / FactorOnDstDen;
                if (Temp1 == 15'b000000000000000)
                  Temp1 = Temp1 + 1;
                NxtSrcTCDstFlow  = Temp1[13:0];
                NextDstLstSrc    = 1'b1;
              end
            end
        end

      3'b110 :
        begin
          if (SrcBurst == `ZERO_14)
            begin
              NextSrcBurst = BurstSize(SrcBurstSize, SglRqSrcAll, BstRqSrcAll,
                                       ZERO_1);
              SrcLoadComb  = 1'b1;
            end
  
          if (SourceTC == `ZERO_14)
            begin
              if ((DMACLBREQ[SrcReg] | DMACLSREQ[SrcReg] | SOFTLBREQ[SrcReg] |
                   SOFTLSREQ[SrcReg]) == 1'b1)
                begin
                  NextSourceTC     = BurstSize(SrcBurstSize, SglRqSrcAll,
                                               BstRqSrcAll, ZERO_1);
                  NextSrcLstOccrd  = 1'b1;
                end
            end
        end

      3'b111 :
        begin
          if (SrcBurst == `ZERO_14)
            begin
              NextSrcBurst     = BurstSize(SrcBurstSize, SglRqSrcAll,
                                           BstRqSrcAll, ZERO_1);
              SrcLoadComb      = 1'b1;
            end
  
          if (SourceTC == `ZERO_14)
            begin
              if ((DMACLBREQ[SrcReg] | DMACLSREQ[SrcReg] | SOFTLBREQ[SrcReg] |
                   SOFTLSREQ[SrcReg]) == 1'b1)
                begin
                  NextSourceTC     = BurstSize(SrcBurstSize, SglRqSrcAll,
                                               BstRqSrcAll, ZERO_1);
                  NextSrcLstOccrd  = 1'b1;
                end
            end
        end

      default :
        begin
          NextSrcBurst     = SrcBurst;
          NextSourceTC     = SourceTC;
          NxtSrcBstDstFlow = SrcBstDstFlow;
          NxtSrcTCDstFlow  = SrcTCDstFlow;
          NextSrcLstOccrd  = SrcLstOccrdReg;
          NextDstLstSrc    = DstLstSrcReg;
          SrcLoadComb      = 1'b0;
        end
    endcase
  end
  else if ((ChEnable == 1'b1) && (ChannelState != `ST_LLI_LOAD))
    begin
      if ((SrcState == 1'b1) && (ValidDataSrc == 1'b1) &&
          (NotValidDataSrc == 1'b0))
        begin
          if (SrcBurst > `ZERO_14)
            NextSrcBurst     = SrcBurst - 1'b1;
          if (SourceTC > `ZERO_14)
            NextSourceTC     = SourceTC - 1'b1;
          if ((FlowCntl == 3'b100) || (FlowCntl == 3'b101))
            begin
              NxtSrcBstDstFlow = SrcBstDstFlow - 1'b1;
              if ((DstLstSrc == 1'b1) && (SrcTCDstFlow > `ZERO_14))
                NxtSrcTCDstFlow  = SrcTCDstFlow - 1'b1;
              if (SrcTCDstFlow <= `ONE_14)
                NextDstLstSrc = 1'b0;
            end
        end
    end
  else
    begin
      NextSrcBurst     = ('b0);
      NextSourceTC     = ('b0);
      NxtSrcBstDstFlow = ('b0);
      NxtSrcTCDstFlow  = ('b0);
      NextDstLstSrc    = 1'b0;
    end

// -----------------------------------------------------------------------------
// Destination clear loading
// -----------------------------------------------------------------------------
  if ((DstSelComb == 1'b1) && (ChEnable == 1'b1))
    begin
      DstLoadComb      = 1'b0;
      case (FlowCntl)
        3'b000 :
          begin
            if (DstBurst == `ZERO_14)
              begin
                NextDstBurst = BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
                DstLoadComb  = 1'b1;
              end
            if (DstTC == `ZERO_14)
              begin
                Temp2 = (ChControlReg[11:0] * FactorOnSrcNum);
                Temp1 = Temp2 / FactorOnSrcDen;
                NextDstTC = Temp1[13:0];
              end
          end
  
        3'b001 :
          begin
            if (DstBurst == `ZERO_14)
              begin
                NextDstBurst = BurstSize(DstBurstSize, ZERO_1, BstRqDst,
                                         ZERO_1);
                DstLoadComb  = 1'b1;
              end
            if (DstTC == `ZERO_14)
              begin
                Temp2 = ChControlReg[11:0] * FactorOnSrcNum;
                Temp1 = Temp2 / FactorOnSrcDen;
                NextDstTC  = Temp1[13:0];
              end
          end
  
        3'b010 :
          begin
            if (DstBurst == `ZERO_14)
              begin
                NextDstBurst = BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
                DstLoadComb  = 1'b1;
              end
            if (DstTC == `ZERO_14)
              begin
                Temp2 = ChControlReg[11:0] * FactorOnSrcNum;
                Temp1 = Temp2 / FactorOnSrcDen;
                NextDstTC = Temp1[13:0];
              end
          end
  
        3'b011 :
          begin
            if (DstBurst == `ZERO_14)
              begin
                NextDstBurst = BurstSize(DstBurstSize, ZERO_1, BstRqDst,
                                         ZERO_1);
                DstLoadComb  = 1'b1;
              end
            if (DstTC == `ZERO_14)
              begin
                Temp2 = (ChControlReg[11:0] * FactorOnSrcNum);
                Temp1 = Temp2 / FactorOnSrcDen;
                NextDstTC = Temp1[13:0];
              end
          end
  
        3'b100 :
          begin
            if (DstBurst == `ZERO_14)
              begin
                NextDstBurst = BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                         ZERO_1);
                DstLoadComb  = 1'b1;
              end
    
            if (DstTC == `ZERO_14)
              begin
                if ((DMACLBREQ[DstReg] | DMACLSREQ[DstReg] | SOFTLBREQ[DstReg] |
                     SOFTLSREQ[DstReg]) == 1'b1)
                  begin
                    NextDstTC        = BurstSize(DstBurstSize, SglRqDstAll,
                                                 BstRqDstAll, ZERO_1);
                    NextDstLstOccrd  = 1'b1;
                  end
              end
          end
  
        3'b101 :
          begin
            if (DstBurst == `ZERO_14)
              begin
                NextDstBurst = BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                         ZERO_1);
                DstLoadComb  = 1'b1;
              end
    
            if (DstTC == `ZERO_14)
              begin
              if ((DMACLBREQ[DstReg] | DMACLSREQ[DstReg] | SOFTLBREQ[DstReg] |
                   SOFTLSREQ[DstReg]) == 1'b1)
                begin
                  NextDstTC = BurstSize(DstBurstSize, SglRqDstAll, BstRqDstAll,
                                        ZERO_1);
                  NextDstLstOccrd  = 1'b1;
                end
              end
          end
  
        3'b110 :
          begin
            DstLoadComb      = 1'b1;
            NextDstBurst     = BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
            Temp5 = BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
  
            if (DstBstSrcFlow == `ZERO_14)
              begin
                Temp4 = DMAFIFOLevel + (PredictFactor * SrcBusWidth);
                Temp2 = Temp4 / DstBusWidth;
                if (Temp5[13:0] >= Temp2[13:0])
                  begin
                    NxtDstBstSrcFlow = Temp2[13:0];
                    DstLoadComb      = 1'b1;
                  end
                else
                  begin
                    NxtDstBstSrcFlow = Temp5[13:0];
                    DstLoadComb      = 1'b1;
                  end
              end
          end
  
        3'b111 :
          begin
            DstLoadComb      = 1'b1;
            NextDstBurst     = BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
            Temp5 = BurstSize(DstBurstSize, ZERO_1, ZERO_1, ONE_1);
  
            if (DstBstSrcFlow == `ZERO_14)
              begin
                Temp4 = DMAFIFOLevel + (PredictFactor * SrcBusWidth);
                Temp2 = Temp4 / DstBusWidth;
                if (Temp5[13:0] >= Temp2[13:0])
                  begin
                    NxtDstBstSrcFlow = Temp2[13:0];
                    DstLoadComb      = 1'b1;
                  end
                else
                  begin
                    NxtDstBstSrcFlow = Temp5[13:0];
                    DstLoadComb      = 1'b1;
                  end
              end
          end
  
        default :
          begin
            NextDstBurst     = DstBurst;
            NextDstTC        = DstTC;
            NextSrcLstOccrd  = SrcLstOccrdReg;
            NextDstLstOccrd  = DstLstOccrdReg;
            NxtDstBstSrcFlow = DstBstSrcFlow;
            NxtDstTCSrcFlow  = DstTCSrcFlow;
            DstLoadComb      = 1'b0;
          end
      endcase
    end
  else if ((ChEnable == 1'b1) && (ChannelState != `ST_LLI_LOAD))
    begin
      if ((DstState == 1'b1) && (ValidDataDst == 1'b1) &&
          (NotValidDataDst == 1'b0))
        begin
          if (DstBurst > `ZERO_14)
            NextDstBurst     = DstBurst - 1'b1;
          if (DstTC > `ZERO_14)
            NextDstTC        = DstTC - 1'b1;
          else
            NextDstLstOccrd  = 1'b0;
          if ((FlowCntl == 3'b110) || (FlowCntl == 3'b111))
            begin
              NxtDstBstSrcFlow = DstBstSrcFlow - 1'b1;
              if ((SrcMaskReg == 1'b1) && (SrcLstOccrd == 1'b1) &&
                  (DMAFIFOLevel == 5'b00000) && (ActFifoLevel == 5'b00000) &&
                  (DelSrcState == 1'b0) && (DstBeat == 5'b00001))
                NextSrcLstOccrd  = 1'b0;
            end
        end
    end
  else
    begin
      NextDstBurst     = ('b0);
      NextDstTC        = ('b0);
      NextDstLstOccrd  = 1'b0;
      NextSrcLstOccrd  = 1'b0;
      NxtDstBstSrcFlow = ('b0);
      NxtDstTCSrcFlow  = ('b0);
    end
end // p_DmaClrCntComb


assign DstLstSrc        = NextDstLstSrc | DstLstSrcReg;
assign SrcLstOccrd      = NextSrcLstOccrd | SrcLstOccrdReg;
assign DstLstOccrd      = NextDstLstOccrd | DstLstOccrdReg;

// -----------------------------------------------------------------------------
// Channel Disable Info on Bus1
// -----------------------------------------------------------------------------
assign ChDisableBus1    = (SrcAhbMasSel == 1'b0) ? SrcDisable :
                           ((DstAhbMasSel == 1'b0) ? DstDisable :
                             ((LLIAhbMasSel == 1'b0) ? LLIDisable : 1'b0));

// -----------------------------------------------------------------------------
// Channel Disable Info on Bus2
// -----------------------------------------------------------------------------
assign ChDisableBus2    = (SrcAhbMasSel == 1'b1) ? SrcDisable :
                           ((DstAhbMasSel == 1'b1) ? DstDisable :
                             ((LLIAhbMasSel == 1'b1) ? LLIDisable : 1'b0));

// -----------------------------------------------------------------------------
// Logic to load the AHB Count and channel resources to the AHB Master interface
// -----------------------------------------------------------------------------
always @(SrcAhbMasSel or SrcSelComb or ChSrcAddrReg or ChControlReg or
         ChConfigReg or SrcIncrBit or DstAhbMasSel or DstSelComb or
         ChDstAddrReg or DstWidth or DstIncrBit or LLIAhbMasSel or LLISelComb or
         LLILoad or NextDstBeat or NextSrcBeat or SrcWidth)
begin : p_AhbLoadComb
   ChAddrBus1       = ('b0);
   ChHProtBus1      = ('b0);
   ChBeatCntBus1    = ('b0);
   ChHLockBus1      = 1'b0;
   ChAddrIncr1      = 1'b0;
   ChHSIZEBus1      = ('b0);
   ChWRITEBus1      = 1'b0;
   ChAddrBus2       = ('b0);
   ChHProtBus2      = ('b0);
   ChBeatCntBus2    = ('b0);
   ChHLockBus2      = 1'b0;
   ChAddrIncr2      = 1'b0;
   ChHSIZEBus2      = ('b0);
   ChWRITEBus2      = 1'b0;
  if ((SrcAhbMasSel == 1'b0) && (SrcSelComb == 1'b1))
  begin
     ChBeatCntBus1    = NextSrcBeat;
     ChAddrBus1       = ChSrcAddrReg;
     ChHProtBus1      = {ChControlReg[30:28], 1'b1};
     ChHLockBus1      = ChConfigReg[16];
     ChAddrIncr1      = SrcIncrBit;
     ChHSIZEBus1      = SrcWidth;
     ChWRITEBus1      = 1'b0;
  end
  if ((SrcAhbMasSel == 1'b1) && (SrcSelComb == 1'b1))
  begin
     ChBeatCntBus2    = NextSrcBeat;
     ChAddrBus2       = ChSrcAddrReg;
     ChHProtBus2      = {ChControlReg[30:28], 1'b1};
     ChHLockBus2      = ChConfigReg[16];
     ChAddrIncr2      = SrcIncrBit;
     ChHSIZEBus2      = SrcWidth;
     ChWRITEBus2      = 1'b0;
  end
  if ((DstAhbMasSel == 1'b0) && (DstSelComb == 1'b1))
  begin
     ChBeatCntBus1    = NextDstBeat;
     ChAddrBus1       = ChDstAddrReg;
     ChHProtBus1      = {ChControlReg[30:28], 1'b1};
     ChHLockBus1      = ChConfigReg[16];
     ChAddrIncr1      = DstIncrBit;
     ChHSIZEBus1      = DstWidth;
     ChWRITEBus1      = 1'b1;
  end
  if ((DstAhbMasSel == 1'b1) && (DstSelComb == 1'b1))
  begin
     ChBeatCntBus2    = NextDstBeat;
     ChAddrBus2       = ChDstAddrReg;
     ChHProtBus2      = {ChControlReg[30:28], 1'b1};
     ChHLockBus2      = ChConfigReg[16];
     ChAddrIncr2      = DstIncrBit;
     ChHSIZEBus2      = DstWidth;
     ChWRITEBus2      = 1'b1;
  end
  if ((LLIAhbMasSel == 1'b0) && (LLISelComb == 1'b1))
  begin
     ChBeatCntBus1    = 5'b00100;
     ChAddrBus1       = ({LLILoad, 2'b00});
     ChHProtBus1      = 4'b1011;
     ChHLockBus1      = 1'b0;
     ChAddrIncr1      = 1'b1;
     ChHSIZEBus1      = 3'b010;
     ChWRITEBus1      = 1'b0;
  end
  if ((LLIAhbMasSel == 1'b1) && (LLISelComb == 1'b1))
  begin
     ChBeatCntBus2    = 5'b00100;
     ChAddrBus2       = ({LLILoad, 2'b00});
     ChHProtBus2      = 4'b1011;
     ChHLockBus2      = 1'b0;
     ChAddrIncr2      = 1'b1;
     ChHSIZEBus2      = 3'b010;
     ChWRITEBus2      = 1'b0;
  end
end // p_AhbLoadComb

// -----------------------------------------------------------------------------
// Fifo Packing Logic i.e. when we are taking data from source peripheral. Here
// SM needs to be in a state where source transfer is happening. Appropriate
// byte lanes are selected based on endianness and also on the Address Offset.
// -----------------------------------------------------------------------------
always @(ChannelState or SrcWidth or AddrOffSetSrc or SrcAhbMasSel or HRDATAM1
         or HRDATAM2 or WrPtr or SrcDisAckOccrd or SrcErrMask or
         NotValidDataSrc or MasterEndian1 or ChEnable or MasterEndian2 or
         SrcState or ValidDataSrc)
begin : p_PackComb
  for (i=0; i<16; i=i+1)
    NextFifoReg[i]   = FifoReg[i];
  NextWrPtr        = WrPtr;
  if ((SrcState == 1'b1) && (ChEnable == 1'b1))
    begin
      case (SrcWidth)
        3'b000 :
          begin
            if ((MasterEndian(SrcAhbMasSel, MasterEndian1, MasterEndian2)
                == 1'b0) && (ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
              begin
                if (AddrOffSetSrc == 2'b00)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      NextFifoReg[WrPtr] = HRDATAM1[7:0];
                    else
                      NextFifoReg[WrPtr] = HRDATAM2[7:0];
                  end
                else if (AddrOffSetSrc == 2'b01)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      NextFifoReg[WrPtr] = HRDATAM1[15:8];
                    else
                      NextFifoReg[WrPtr] = HRDATAM2[15:8];
                  end
                else if (AddrOffSetSrc == 2'b10)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      NextFifoReg[WrPtr] = HRDATAM1[23:16];
                    else
                      NextFifoReg[WrPtr] = HRDATAM2[23:16];
                  end
                else if (AddrOffSetSrc == 2'b11)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      NextFifoReg[WrPtr] = HRDATAM1[31:24];
                    else
                      NextFifoReg[WrPtr] = HRDATAM2[31:24];
                  end
                if ((SrcDisAckOccrd == 1'b0) && (SrcErrMask == 1'b0))
                  NextWrPtr        = WrPtr + 1'b1;
                else
                  NextWrPtr        = 4'b0000;
              end
            else if ((MasterEndian(SrcAhbMasSel, MasterEndian1, MasterEndian2)
                      == 1'b1) && (ValidDataSrc == 1'b1) && (NotValidDataSrc ==
                      1'b0))
              begin
                if (AddrOffSetSrc == 2'b00)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      NextFifoReg[WrPtr] = HRDATAM1[31:24];
                    else
                      NextFifoReg[WrPtr] = HRDATAM2[31:24];
                  end
                else if (AddrOffSetSrc == 2'b01)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                       NextFifoReg[WrPtr] = HRDATAM1[23:16];
                    else
                       NextFifoReg[WrPtr] = HRDATAM1[23:16];
                  end
                else if (AddrOffSetSrc == 2'b10)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      NextFifoReg[WrPtr] = HRDATAM1[15:8];
                    else
                      NextFifoReg[WrPtr] = HRDATAM2[15:8];
                  end
                else if (AddrOffSetSrc == 2'b11)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      NextFifoReg[WrPtr] = HRDATAM1[7:0];
                    else
                      NextFifoReg[WrPtr] = HRDATAM2[7:0];
                  end
                if ((SrcDisAckOccrd == 1'b0) && (SrcErrMask == 1'b0))
                  NextWrPtr        = WrPtr + 1'b1;
                else
                  NextWrPtr        = 4'b0000;
              end
          end
  
        3'b001 :
          begin
            if ((MasterEndian(SrcAhbMasSel, MasterEndian1, MasterEndian2) ==
                 1'b0) && (ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
              begin
                if (AddrOffSetSrc == 2'b00)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      begin
                        NextFifoReg[WrPtr] = HRDATAM1[7:0];
                        NextFifoReg[WrPtr + 1] = HRDATAM1[15:8];
                      end
                    else
                      begin
                        NextFifoReg[WrPtr] = HRDATAM2[7:0];
                        NextFifoReg[WrPtr + 1] = HRDATAM2[15:8];
                      end
                  end
                else if (AddrOffSetSrc == 2'b10)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      begin
                        NextFifoReg[WrPtr] = HRDATAM1[23:16];
                        NextFifoReg[WrPtr + 1] = HRDATAM1[31:24];
                      end
                    else
                      begin
                        NextFifoReg[WrPtr] = HRDATAM2[23:16];
                        NextFifoReg[WrPtr + 1] = HRDATAM2[31:24];
                      end
                  end
                if ((SrcDisAckOccrd == 1'b0) || (SrcErrMask == 1'b0))
                  NextWrPtr        = WrPtr + 2'b10;
                else
                  NextWrPtr        = 4'b0000;
              end
            else if ((MasterEndian(SrcAhbMasSel, MasterEndian1, MasterEndian2)
                     == 1'b1) && (ValidDataSrc == 1'b1) &&
                     (NotValidDataSrc == 1'b0))
              begin
                if (AddrOffSetSrc == 2'b00)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      begin
                        NextFifoReg[WrPtr] = HRDATAM1[23:16];
                        NextFifoReg[WrPtr + 1] = HRDATAM1[31:24];
                      end
                    else
                      begin
                        NextFifoReg[WrPtr] = HRDATAM2[23:16];
                        NextFifoReg[WrPtr + 1] = HRDATAM2[31:24];
                      end
                  end
                else if (AddrOffSetSrc == 2'b10)
                  begin
                    if (SrcAhbMasSel == 1'b0)
                      begin
                        NextFifoReg[WrPtr] = HRDATAM1[7:0];
                        NextFifoReg[WrPtr + 1] = HRDATAM1[15:8];
                      end
                    else
                      begin
                        NextFifoReg[WrPtr] = HRDATAM2[7:0];
                        NextFifoReg[WrPtr + 1] = HRDATAM2[15:8];
                      end
                  end
                if ((SrcDisAckOccrd == 1'b0) && (SrcErrMask == 1'b0))
                  NextWrPtr        = WrPtr + 2'b10;
                else
                  NextWrPtr        = 4'b0000;
              end
          end
  
        3'b010 :
          begin
            if ((ValidDataSrc == 1'b1) && (NotValidDataSrc == 1'b0))
            begin
              if (SrcAhbMasSel == 1'b0)
                NextFifoReg[WrPtr] = HRDATAM1[7:0];
              else
                NextFifoReg[WrPtr] = HRDATAM2[7:0];
              if (SrcAhbMasSel == 1'b0)
                NextFifoReg[WrPtr + 1] = HRDATAM1[15:8];
              else
                NextFifoReg[WrPtr + 1] = HRDATAM2[15:8];
              if (SrcAhbMasSel == 1'b0)
                NextFifoReg[WrPtr + 2] = HRDATAM1[23:16];
              else
                NextFifoReg[WrPtr + 2] = HRDATAM2[23:16];
              if (SrcAhbMasSel == 1'b0)
                NextFifoReg[WrPtr + 3] = HRDATAM1[31:24];
              else
                NextFifoReg[WrPtr + 3] = HRDATAM2[31:24];
              if ((SrcDisAckOccrd == 1'b0) && (SrcErrMask == 1'b0))
                NextWrPtr        = WrPtr + 3'b100;
              else
                NextWrPtr        = 4'b0000;
            end
          end
        default :
          begin
            for (i=0; i<16; i=i+1)
              NextFifoReg[i]   = FifoReg[i];
            NextWrPtr        = WrPtr;
          end
      endcase
    end
  else if ((ChEnable == 1'b0) || (ChannelState == `ST_LLI_LOAD))
    NextWrPtr        = 4'b0000;
end // p_PackComb

// -----------------------------------------------------------------------------
// This block is responsible for generating counts which help in doing
// prediction factor Destination Transfers.
// -----------------------------------------------------------------------------
always @(ChEnable or ChannelState or SrcErrOccrd or SameBus or SrcBusWidth or
         DstBusWidth or SrcCopyState or SrcSelComb or NextSrcBeat or
         SrcBeatCopy or SrcCopy1 or SrcAhbMasSel or DelMready1 or DelMready2 or
         SrcCopy2 or ErrorMas1 or ErrorMas2)
begin : p_SrcCountComb
  NextSrcBeatCopy  = SrcBeatCopy;
  NextSrcCopy1     = SrcCopy1;
  NextSrcCopy2     = SrcCopy2;
  NextSrcCopyST    = SrcCopyState;
  if ((ChEnable == 1'b1) && (ChannelState != `ST_LLI_LOAD) &&
      (SrcErrOccrd == 1'b0) && (SameBus == 1'b1) &&
      (SrcBusWidth >= DstBusWidth))
    begin
      case (SrcCopyState)
        `ST_SRC_PREDICT_IDLE :
          begin
            if ((SrcSelComb == 1'b1) && (ErrorMas(SrcAhbMasSel, ErrorMas1,
                 ErrorMas2) == 1'b0))
              begin
                NextSrcCopyST    = `ST_SRC_ADDR_PHASE;
                NextSrcBeatCopy  = NextSrcBeat;
                NextSrcCopy1     = SrcBeatCopy;
                NextSrcCopy2     = SrcCopy1;
              end
          end
  
        `ST_SRC_ADDR_PHASE :
          if ((MREADY(SrcAhbMasSel, DelMready1, DelMready2) == 1'b1) &&
              (ErrorMas(SrcAhbMasSel, ErrorMas1, ErrorMas2) == 1'b0))
             NextSrcCopyST    = `ST_SRC_DATA_PHASE;
  
        `ST_SRC_DATA_PHASE :
          begin
            if ((MREADY(SrcAhbMasSel, DelMready1, DelMready2) == 1'b1))
              begin
                if (SrcBeatCopy == 5'b00000)
                  begin
                    NextSrcCopyST    = `ST_SRC_PREDICT_IDLE;
                    NextSrcBeatCopy  = ('b0);
                    NextSrcCopy1     = ('b0);
                    NextSrcCopy2     = ('b0);
                  end
                else
                  begin
                    NextSrcBeatCopy  = SrcBeatCopy - 1'b1;
                    NextSrcCopy1     = SrcBeatCopy;
                    NextSrcCopy2     = SrcCopy1;
                  end
              end
          end
        default :
          begin
            NextSrcBeatCopy  = SrcBeatCopy;
            NextSrcCopy1     = SrcCopy1;
            NextSrcCopy2     = SrcCopy2;
            NextSrcCopyST    = SrcCopyState;
          end
      endcase
    end
  else
    begin
      NextSrcCopyST    = `ST_SRC_PREDICT_IDLE;
      NextSrcBeatCopy  = ('b0);
      NextSrcCopy1     = ('b0);
      NextSrcCopy2     = ('b0);
    end
end // p_SrcCountComb

// -----------------------------------------------------------------------------
// This block is responsible gives actual prediction factor for Destination
// Transfers.
// -----------------------------------------------------------------------------
always @(SrcBeatCopy or SrcCopy1 or SrcCopy2)
begin : p_PredictComb
  PredictFactor    = 2'b00;
  if ((SrcBeatCopy == 4'b0010) && (SrcCopy1 == 4'b0011) &&
      (SrcCopy2 == 4'b0100))
    PredictFactor    = 2'b11;
  else if ((SrcBeatCopy == 4'b0001) && (SrcCopy1 == 4'b0010) &&
           (SrcCopy2 == 4'b0011))
    PredictFactor    = 2'b10;
  else if ((SrcBeatCopy == 4'b0000) && (SrcCopy1 == 4'b0001) &&
           (SrcCopy2 == 4'b0010))
    PredictFactor    = 2'b01;
end // p_PredictComb

// -----------------------------------------------------------------------------
// Fifo UnPacking. Here the data's are duplicated on other byte lanes if the
// width is less than 32 bit. The Read Pointer for this is moved 1MREADY early.
// -----------------------------------------------------------------------------
always @(ChHwdata1 or ChHwdata2 or RdPtrAhead or ChEnable or ChannelState or
         DstHwdataState or DstSelComb or DstAhbMasSel or DelMready1 or
         DelMready2 or DstWidth or DstDisAckOccrd or DstErrMask or
         DstBeatCopy or NextDstBeat or DstErrOccrd or ErrorMas1 or ErrorMas2 or
         SingleBusErr or DualBusErr or SrcErrOccrd)
begin : p_RemDataBefComb
  NextChHwdata1    = ChHwdata1;
  NextChHwdata2    = ChHwdata2;
  NextRdPtrAhead   = RdPtrAhead;
  NextDstState     = DstHwdataState;
  NextDstBeatCopy  = DstBeatCopy;
  if ((ChEnable == 1'b1) && (ChannelState != `ST_LLI_LOAD) &&
      (DstErrOccrd == 1'b0))
    begin
      case (DstHwdataState)
        `ST_DST_HWDATA_IDLE :
          begin
            if ((DstSelComb == 1'b1) && (ErrorMas(DstAhbMasSel, ErrorMas1,
                 ErrorMas2) == 1'b0))
              begin
                NextDstState     = `ST_DST_ADDR_PHASE;
                NextChHwdata1    = ('b0);
                NextChHwdata2    = ('b0);
                NextDstBeatCopy  = NextDstBeat;
                if (NextDstBeat == 5'b00001)
                  AddrPhase        = 1'b1;
                else
                  AddrPhase        = 1'b0;
              end
          end
  
        `ST_DST_ADDR_PHASE :
          begin
            if ((MREADY(DstAhbMasSel, DelMready1, DelMready2) == 1'b1) &&
                (ErrorMas(DstAhbMasSel, ErrorMas1, ErrorMas2) == 1'b0) &&
                (SingleBusErr == 1'b0) && (DualBusErr == 1'b0) &&
                (ChannelState != `ST_IDLE))
              begin
                NextDstState     = `ST_DST_DATA_PHASE;
                NextDstBeatCopy  = DstBeatCopy - 5'b00001;
                case (DstWidth)
                  3'b000 :
                    begin
                      if ((DstDisAckOccrd == 1'b0) && (DstErrMask == 1'b0))
                        NextRdPtrAhead   = RdPtrAhead + 1'b1;
                      else
                        NextRdPtrAhead   = ('b0);
                      if (DstAhbMasSel == 1'b0)
                        NextChHwdata1    = {4{FifoReg[RdPtrAhead]}};
                      else
                        NextChHwdata2    = {4{FifoReg[RdPtrAhead]}};
                    end

                  3'b001 :
                    begin
                      if ((DstDisAckOccrd == 1'b0) && (DstErrMask == 1'b0))
                        NextRdPtrAhead   = RdPtrAhead + 2'b10;
                      else
                        NextRdPtrAhead   = ('b0);
                      if (DstAhbMasSel == 1'b0)
                        NextChHwdata1    = {2{FifoReg[RdPtrAhead + 1],
                                              FifoReg[RdPtrAhead]}};
                      else
                        NextChHwdata2    = {2{FifoReg[RdPtrAhead + 1],
                                              FifoReg[RdPtrAhead]}};
                    end

                  3'b010 :
                    begin
                      if ((DstDisAckOccrd == 1'b0) && (DstErrMask == 1'b0))
                        NextRdPtrAhead   = RdPtrAhead + 3'b100;
                      else
                        NextRdPtrAhead   = ('b0);
                      if (DstAhbMasSel == 1'b0)
                        NextChHwdata1    = {FifoReg[RdPtrAhead + 3],
                                            FifoReg[RdPtrAhead + 2],
                                            FifoReg[RdPtrAhead + 1],
                                            FifoReg[RdPtrAhead]};
                      else
                        NextChHwdata2    = {FifoReg[RdPtrAhead + 3],
                                            FifoReg[RdPtrAhead + 2],
                                            FifoReg[RdPtrAhead + 1],
                                            FifoReg[RdPtrAhead]};
                    end
                  default :
                    begin
                      NextChHwdata1    = ChHwdata1;
                      NextChHwdata2    = ChHwdata2;
                      NextRdPtrAhead   = RdPtrAhead;
                      NextDstState     = DstHwdataState;
                      NextDstBeatCopy  = DstBeatCopy;
                    end
                endcase
              end
            else
              begin
                NextChHwdata1    = ('b0);
                NextChHwdata2    = ('b0);
              end
          end
  
        `ST_DST_DATA_PHASE :
          begin
            if ((MREADY(DstAhbMasSel, DelMready1, DelMready2) == 1'b1) &&
                ( ~((ChannelState == `ST_IDLE) && (SrcErrOccrd == 1'b1))))
              begin
                if (DstBeatCopy == 5'b00000)
                  begin
                    NextDstState     = `ST_DST_HWDATA_IDLE;
                    NextChHwdata1    = ('b0);
                    NextChHwdata2    = ('b0);
                    NextDstBeatCopy  = ('b0);
                    AddrPhase        = 1'b0;
                  end
                else
                  begin
                    NextDstBeatCopy  = DstBeatCopy - 5'b00001;
                    case (DstWidth)
                      3'b000 :
                        begin
                          if ((DstDisAckOccrd == 1'b0) && (DstErrMask == 1'b0))
                            NextRdPtrAhead   = RdPtrAhead + 1'b1;
                          else
                            NextRdPtrAhead   = ('b0);
                          if (DstAhbMasSel == 1'b0)
                            NextChHwdata1    = {4{FifoReg[RdPtrAhead]}};
                          else
                            NextChHwdata2    = {4{FifoReg[RdPtrAhead]}};
                        end
        
                      3'b001 :
                        begin
                          if ((DstDisAckOccrd == 1'b0) && (DstErrMask == 1'b0))
                            NextRdPtrAhead   = RdPtrAhead + 2'b10;
                          else
                            NextRdPtrAhead   = ('b0);
                          if (DstAhbMasSel == 1'b0)
                            NextChHwdata1    = {2{FifoReg[RdPtrAhead + 1],
                                                FifoReg[RdPtrAhead]}};
                          else
                            NextChHwdata2    = {2{FifoReg[RdPtrAhead + 1],
                                                FifoReg[RdPtrAhead]}};
                        end
        
                      3'b010 :
                        begin
                          if ((DstDisAckOccrd == 1'b0) && (DstErrMask == 1'b0))
                            NextRdPtrAhead   = RdPtrAhead + 3'b100;
                          else
                            NextRdPtrAhead   = ('b0);
                          if (DstAhbMasSel == 1'b0)
                            NextChHwdata1    = {FifoReg[RdPtrAhead + 3],
                                                FifoReg[RdPtrAhead + 2],
                                                FifoReg[RdPtrAhead + 1],
                                                FifoReg[RdPtrAhead]};
                          else
                            NextChHwdata2    = {FifoReg[RdPtrAhead + 3],
                                                FifoReg[RdPtrAhead + 2],
                                                FifoReg[RdPtrAhead + 1],
                                                FifoReg[RdPtrAhead]};
                        end
        
                      default :
                        begin
                          NextChHwdata1    = ChHwdata1;
                          NextChHwdata2    = ChHwdata2;
                          NextRdPtrAhead   = RdPtrAhead;
                          NextDstState     = DstHwdataState;
                          NextDstBeatCopy  = DstBeatCopy;
                        end
                    endcase
                  end
              end
            else if ((ChannelState == `ST_IDLE) && (SrcErrOccrd == 1'b1))
              begin
                NextChHwdata1    = ('b0);
                NextChHwdata2    = ('b0);
                NextRdPtrAhead   = ('b0);
                AddrPhase        = 1'b0;
              end
          end

        default :
          begin
            NextChHwdata1    = ChHwdata1;
            NextChHwdata2    = ChHwdata2;
            NextRdPtrAhead   = RdPtrAhead;
            NextDstState     = DstHwdataState;
            NextDstBeatCopy  = DstBeatCopy;
          end
      endcase
    end
  else
    begin
      NextChHwdata1    = ('b0);
      NextChHwdata2    = ('b0);
      NextRdPtrAhead   = ('b0);
      NextDstState     = `ST_DST_HWDATA_IDLE;
      AddrPhase        = 1'b0;
    end
end // p_RemDataBefComb:

// -----------------------------------------------------------------------------
// HWDATA for Bus1
// -----------------------------------------------------------------------------
assign iHWDATA1         = (DelMready1 == 1'b1) ? ChHwdata1 : HwdataBuff1;

// -----------------------------------------------------------------------------
// HWDATA for Bus2
// -----------------------------------------------------------------------------
assign iHWDATA2         = (DelMready2 == 1'b1) ? ChHwdata2 : HwdataBuff2;

assign HWDATA1          = iHWDATA1;
assign HWDATA2          = iHWDATA2;

// -----------------------------------------------------------------------------
// Wrap signal generation block
// variable concat : std_logic_vector(1 downto 0);
// -----------------------------------------------------------------------------
always @(Wrap or ChEnable or WrPtr or NextWrPtr or RdPtrAhead or
         NextRdPtrAhead or SrcWidth or DstWidth)
begin : p_WrapLevelComb
   NextWrap         = Wrap;
  if (ChEnable == 1'b1)
    begin
      case (SrcWidth)
        3'b000 :
          case (DstWidth)
            3'b000 :
              if ((WrPtr == 4'b1111) && (NextWrPtr == 4'b0000))
                 NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1111) && (NextRdPtrAhead == 4'b0000))
                 NextWrap         = 1'b0;
              else
                 NextWrap         = Wrap;
  
            3'b001 :
              if ((WrPtr == 4'b1111) && (NextWrPtr == 4'b0000))
                 NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1110) && (NextRdPtrAhead == 4'b0000))
                 NextWrap         = 1'b0;
              else
                 NextWrap         = Wrap;
  
            3'b010 :
              if ((WrPtr == 4'b1111) && (NextWrPtr == 4'b0000))
                 NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1100) && (NextRdPtrAhead == 4'b0000))
                 NextWrap         = 1'b0;
              else
                 NextWrap         = Wrap;
  
            default :
              NextWrap         = Wrap;
          endcase
        3'b001 :
          case (DstWidth)
            3'b000 :
              if ((WrPtr == 4'b1110) && (NextWrPtr == 4'b0000))
                NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1111) && (NextRdPtrAhead == 4'b0000))
                NextWrap         = 1'b0;
              else
                NextWrap         = Wrap;
  
            3'b001 :
              if ((WrPtr == 4'b1110) && (NextWrPtr == 4'b0000))
                NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1110) && (NextRdPtrAhead == 4'b0000))
                NextWrap         = 1'b0;
              else
                NextWrap         = Wrap;
  
            3'b010 :
              if ((WrPtr == 4'b1110) && (NextWrPtr == 4'b0000))
                NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1100) && (NextRdPtrAhead == 4'b0000))
                NextWrap         = 1'b0;
              else
                NextWrap         = Wrap;
  
            default :
              NextWrap         = Wrap;
          endcase
  
        3'b010 :
          case (DstWidth)
            3'b000 :
              if ((WrPtr == 4'b1100) && (NextWrPtr == 4'b0000))
                NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1111) && (NextRdPtrAhead == 4'b0000))
                NextWrap         = 1'b0;
              else
                NextWrap         = Wrap;
  
            3'b001 :
              if ((WrPtr == 4'b1100) && (NextWrPtr == 4'b0000))
                NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1110) && (NextRdPtrAhead == 4'b0000))
                NextWrap         = 1'b0;
              else
                NextWrap         = Wrap;
  
            3'b010 :
              if ((WrPtr == 4'b1100) && (NextWrPtr == 4'b0000))
                NextWrap         = 1'b1;
              else if ((RdPtrAhead == 4'b1100) && (NextRdPtrAhead == 4'b0000))
                NextWrap         = 1'b0;
              else
                NextWrap         = Wrap;
  
            default :
              NextWrap         = Wrap;
          endcase
        default :
          NextWrap         = Wrap;
      endcase
    end
  else
     NextWrap         = 1'b0;
end // p_WrapLevelComb

// -----------------------------------------------------------------------------
// Actual FifoLevel generation based on Wrap, RdPtrAhead and WrPtr
// -----------------------------------------------------------------------------
assign ActFifoLevel     = ({Wrap, WrPtr} - {1'b0, RdPtrAhead});

// -----------------------------------------------------------------------------
// DMAFIFOLevel which is delayed ActFifoLevel in SrcState
// -----------------------------------------------------------------------------
assign DMAFIFOLevel     = (DstState == 1'b1) ? ActFifoLevel : ActFifoLevDel;

// -----------------------------------------------------------------------------
// Registering all the next state signals
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_WriteSeq
  if (HRESETn == 1'b0)
    begin
      ChSrcAddrReg     <= ('b0);
      ChDstAddrReg     <= ('b0);
      ChControlReg     <= ('b0);
      ChLLIReg         <= ('b0);
      ChConfigReg      <= ('b0);
      SrcErrOccrd      <= 1'b0;
      DstErrOccrd      <= 1'b0;
      LLIErrOccrd      <= 1'b0;
      ChIntReg         <= 1'b0;
      iChIntErr        <= 1'b0;
      ChIntErrDel1     <= 1'b0;
      SrcMaskReg       <= 1'b0;
      SrcBeat          <= ('b0);
      DstBeat          <= ('b0);
      DstBeatCopy      <= ('b0);
      ChannelState     <= `ST_IDLE;
      DstSelReg        <= 1'b0;
      SrcSelReg        <= 1'b0;
      LLIBeat          <= ('b0);
      DstTxrOn         <= 1'b0;
      SrcTxrOn         <= 1'b0;
      TwoBitCnt        <= ('b0);
      iDMACCLR         <= ('b0);
      iDMACTC          <= ('b0);
      SrcBurst         <= ('b0);
      DstBurst         <= ('b0);
      SourceTC         <= ('b0);
      DstTC            <= ('b0);
      SrcBstDstFlow    <= ('b0);
      SrcTCDstFlow     <= ('b0);
      DstLstSrcReg     <= 1'b0;
      SrcLstOccrdReg   <= 1'b0;
      DstLstOccrdReg   <= 1'b0;
      DstBstSrcFlow    <= ('b0);
      DstTCSrcFlow     <= ('b0);
      WrPtr            <= ('b0);
      ActFifoLevDel    <= ('b0);
      Wrap             <= 1'b0;
      DelDstRqBefMask  <= 1'b0;
      SrcStart         <= 1'b0;
      OneBitTog        <= 1'b0;
      TwoBitTog        <= ('b0);
      ChHaltReg        <= 1'b0;
      ChDisableReg     <= 1'b0;
      DelSrcState      <= 1'b0;
      DelDstState      <= 1'b0;
      RdPtrAhead       <= ('b0);
      HwdataBuff1      <= ('b0);
      HwdataBuff2      <= ('b0);
      ErrorState       <= `ST_ERROR_INIT;
      DMACTCDel        <= ('b0);
      DMACCLRDel       <= ('b0);
      DMACCLR2Del      <= ('b0);
      DelDstFlowReq    <= 1'b0;
      DelChEnable      <= 1'b0;
      DelMready1       <= 1'b0;
      DelMready2       <= 1'b0;
      DstHwdataState   <= `ST_DST_HWDATA_IDLE;
      DelLLIState      <= 1'b0;
      Del2LLIState     <= 1'b0;
      ChHwdata1        <= ('b0);
      ChHwdata2        <= ('b0);
      LLIAhbMasSel     <= 1'b0;
      SrcBeatCopy      <= ('b0);
      SrcCopy1         <= ('b0);
      SrcCopy2         <= ('b0);
      SrcCopyState     <= `ST_SRC_PREDICT_IDLE;
      NotValidSrcST    <= `ST_NOTVALIDSRC_IDLE;
      NotValidDstST    <= `ST_NOTVALIDDST_IDLE;
      NotValidLLIST    <= `ST_NOTVALIDLLI_IDLE;
      LLISelReg        <= 1'b0;
      DMACTCP2M        <= 1'b0;
      DelDMACTCP2M     <= 1'b0;
      WaitedForClr     <= 1'b0;
      DelErrMas1       <= 1'b0;
      DelErrMas2       <= 1'b0;
      ErrPulse1        <= 1'b0;
      ErrPulse2        <= 1'b0;
      DelIntr          <= 1'b0;
      SoftClrPulse     <= 1'b0;
      SrcDisable       <= 1'b0;
      DstDisable       <= 1'b0;
      LLIDisable       <= 1'b0;
      DisableST        <= `ST_DISABLE_IDLE;
      DelChDisable     <= 1'b0;
      DelNotValidSrc   <= 1'b0;
      DelNotValidDst   <= 1'b0;
      DelNotValidLLI   <= 1'b0;
      for (i=0; i<16; i=i+1)
        FifoReg[i] <= ('b0);
    end
  else
    begin
      ChSrcAddrReg     <= NextChSrcAddrReg;
      ChDstAddrReg     <= NextChDstAddrReg;
      ChControlReg     <= NextChControlReg;
      ChLLIReg         <= NextChLLIReg;
      ChConfigReg      <= NextChConfigReg;
      SrcErrOccrd      <= NextSrcErrOccrd;
      DstErrOccrd      <= NextDstErrOccrd;
      LLIErrOccrd      <= NextLLIErrOccrd;
      ChIntReg         <= NextChIntReg;
      iChIntErr        <= NextChIntErr;
      ChIntErrDel1     <= iChIntErr;
      SrcMaskReg       <= NextSrcMaskReg;
      SrcBeat          <= NextSrcBeat;
      DstBeat          <= NextDstBeat;
      DstBeatCopy      <= NextDstBeatCopy;
      ChannelState     <= NextChState;
      DstSelReg        <= NextDstSelReg;
      SrcSelReg        <= NextSrcSelReg;
      LLIBeat          <= NextLLIBeat;
      DstTxrOn         <= NextDstTxrOn;
      SrcTxrOn         <= NextSrcTxrOn;
      TwoBitCnt        <= NextTwoBitCnt;
      iDMACCLR         <= NextDMACCLR;
      iDMACTC          <= NextDMACTC;
      SrcBurst         <= NextSrcBurst;
      DstBurst         <= NextDstBurst;
      SourceTC         <= NextSourceTC;
      DstTC            <= NextDstTC;
      SrcBstDstFlow    <= NxtSrcBstDstFlow;
      SrcTCDstFlow     <= NxtSrcTCDstFlow;
      DstLstSrcReg     <= NextDstLstSrc;
      SrcLstOccrdReg   <= NextSrcLstOccrd;
      DstLstOccrdReg   <= NextDstLstOccrd;
      DstBstSrcFlow    <= NxtDstBstSrcFlow;
      DstTCSrcFlow     <= NxtDstTCSrcFlow;
      for (i=0; i<16; i=i+1)
        FifoReg[i]     <= NextFifoReg[i];
      WrPtr            <= NextWrPtr;
      Wrap             <= NextWrap;
      DelDstRqBefMask  <= DstReqBefMask;
      SrcStart         <= NextSrcStart;
      ActFifoLevDel    <= ActFifoLevel;
      OneBitTog        <= NextOneBitTog;
      TwoBitTog        <= NextTwoBitTog;
      ChHaltReg        <= NextChHalt;
      ChDisableReg     <= NextChDisable;
      DelSrcState      <= NextDelSrcState;
      DelDstState      <= NextDelDstState;
      Del2DstState     <= DelDstState;
      RdPtrAhead       <= NextRdPtrAhead;
      ChHwdata1        <= NextChHwdata1;
      ChHwdata2        <= NextChHwdata2;
      if (MREADY1 == 1'b0)
        HwdataBuff1      <= iHWDATA1;
      else
        HwdataBuff1      <= ('b0);
      if (MREADY2 == 1'b0)
        HwdataBuff2      <= iHWDATA2;
      else
        HwdataBuff2      <= ('b0);
      ErrorState       <= NextErrorState;
      DMACTCDel        <= iDMACTC;
      DMACCLRDel       <= iDMACCLR;
      DMACCLR2Del      <= DMACCLRDel;
      DelDstFlowReq    <= DstFlowReq;
      DelChEnable      <= ChEnable;
      DelMready1       <= MREADY1;
      DelMready2       <= MREADY2;
      DstHwdataState   <= NextDstState;
      DelLLIState      <= NextDelLLIState;
      Del2LLIState     <= DelLLIState;
      LLIAhbMasSel     <= NextLLIAhbMasSel;
      SrcBeatCopy      <= NextSrcBeatCopy;
      SrcCopy1         <= NextSrcCopy1;
      SrcCopy2         <= NextSrcCopy2;
      SrcCopyState     <= NextSrcCopyST;
      NotValidSrcST    <= NextSrcNotState;
      NotValidDstST    <= NextDstNotState;
      NotValidLLIST    <= NextLLINotState;
      LLISelReg        <= NextLLISelReg;
      DMACTCP2M        <= NextDMACTCP2M;
      DelDMACTCP2M     <= DMACTCP2M;
      WaitedForClr     <= NextWaitedForClr;
      DelErrMas1       <= ErrorMas1;
      DelErrMas2       <= ErrorMas2;
      if ((MREADY1 == 1'b0) && (ErrorMas1 == 1'b1))
        ErrPulse1        <= 1'b1;
      else
        ErrPulse1        <= 1'b0;
      if ((MREADY2 == 1'b0) && (ErrorMas2 == 1'b1))
        ErrPulse2        <= 1'b1;
      else
        ErrPulse2        <= 1'b0;
      DelIntr          <= NextDelIntr;
      SoftClrPulse     <= NextSoftClrPulse;
      SrcDisable       <= NextSrcDisable;
      DstDisable       <= NextDstDisable;
      LLIDisable       <= NextLLIDisable;
      DisableST        <= NextDisableST;
      DelChDisable     <= ChDisableReg;
      DelNotValidSrc   <= NotValidDataSrc;
      DelNotValidDst   <= NotValidDataDst;
      DelNotValidLLI   <= NotValidDataLLI;
    end
end // p_WriteSeq

// -----------------------------------------------------------------------------
// Protocol Checker Messages Block
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_ProChkMsg
  if (LLISelComb == 1'b1)
    $display($time," NOTE: DmacTrChLogic1: LLI Loading happening from Address",
                   "%h \n %m", {LLILoad, 2'b00});
    
  if (ChSrcAddrWrEn == 1'b1)
    begin
      if (ChHaltReg == 1'b1)
        $display($time," ERROR: DmacTrChLogic2: Channel is programmed when",
                       " Halt bit is set", "\n %m");

      if ((DMACEn == 1'b0) && (DmacTrEn == 1'b1))
        $display($time," ERROR: DmacTrChLogic3: DMAC Not enabled but channel",
                       " registers are getting written", "\n %m");
    end

  if ((ChConfigWrEn == 1'b1) && (HWDATA[0] == 1'b1))
    begin
      if ((FlowCntl[2] == 1'b0) && (HWDATA[11:0] == 'b0))
        $display($time," ERROR: DmacTrChLogic4: Programmed with 0 Transfer",
                 " size when DMAC is Flow Controller", "\n %m");

      if ((DMACEn == 1'b0) && (DmacTrEn == 1'b1))
        $display($time," ERROR: DmacTrChLogic5: DMAC Not enabled but channel",
                       " registers are getting written", "\n %m");
    end

  if (ChConfigWrEn == 1'b1)
    begin
      if ((HWDATA[18] == 1'b1) && (SrcReqBefMask == 1'b1))
        $display($time," NOTE: DmacTrChLogic6: Channel is Halted and Further",
                " requests are ignored till this bit is cleared \n %m");

      if ((DMACEn == 1'b0) && (DmacTrEn == 1'b1))
        $display($time," ERROR: DmacTrChLogic7: DMAC Not enabled but channel",
                       " registers are getting written", "\n %m");
    end

  if (((ErrPulse1 == 1'b1) || (ErrPulse2 == 1'b1)) && (SrcErrOccrd == 1'b1))
    $display($time," NOTE: DmacTrChLogic8: Error Response received during",
                   " Source Transfer \n %m");

  if (((ErrPulse1 == 1'b1) || (ErrPulse2 == 1'b1)) && (DstErrOccrd == 1'b1))
    $display($time," NOTE: DmacTrChLogic9: Error Response received during",
                   " Destination Transfer \n %m");

  if (((ErrPulse1 == 1'b1) || (ErrPulse2 == 1'b1)) && (LLIErrOccrd == 1'b1))
    $display($time," NOTE: DmacTrChLogic10: Error Response received during",
                   " LLI Transfer \n %m");

  if ((ChConfigWrEn == 1'b1) && (ChEnable == 1'b1))
    if (HWDATA[0] == 1'b0)
      $display($time," NOTE: DmacTrChLogic11: Channel Disable Occurred \n %m");
end // p_ProChkMsg

endmodule
// --================================== End ==================================--
