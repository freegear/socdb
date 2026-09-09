// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacChannel.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the DmacChannel.
//
// --=========================================================================--

`timescale 1ns/1ps

module DmacChannel (
// Inputs
                    // Clock and reset
                    HCLK,
                    HRESETn,
                    // From Master interface (DmacAhbMaster)
                    MasterAddressM1,
                    MasterAddressM2,
                    ChWrDataM1,
                    ChWrDataM2,
                    BusAvlblM1,
                    BusAvlblM2,
                    DataErrorM1,
                    DataErrorM2,
                    XferAbortedM1,
                    XferAbortedM2,
                    // From AHB Slave interface (DmacAhbSlaveIf)
                    RegHWrite,
                    RegAddress,
                    DmacChannelSel,
                    HWDATA,
                    ClrIntTC,
                    ClrIntErr,
                    DMACBREQCh,
                    DMACLBREQCh,
                    DMACSREQCh,
                    DMACLSREQCh,
                    DMACEn,
                    // From DmacArbiter
                    ChGntM1,
                    ChGntM2,

// Outputs
                    // To AHB Slave block (DmacAhbSlaveIf)
                    ChHRDATA,
                    ChannelEn,
                    IntErrCh,
                    IntTCCh,
                    RawIntErrCh,
                    RawIntTCCh,
                    ClearReq,
                    SigTC,
                    ErrClrReq,
                    // To AHB Master interfaces (DmacAhbMaster)
                    ChLock,
                    // Master 1 signals
                    ChNumOfXfersM1,
                    ChReqM1,
                    ChIncrM1,
                    ChAddrM1,
                    ChProtM1,
                    ChWidthM1,
                    ChDirxnM1,
                    ChXferAbortM1,
                    ChHWDATAM1,
                    // Master 2 signals
                    ChNumOfXfersM2,
                    ChReqM2,
                    ChIncrM2,
                    ChAddrM2,
                    ChProtM2,
                    ChWidthM2,
                    ChDirxnM2,
                    ChXferAbortM2,
                    ChHWDATAM2
                   );

// Inputs

// Clock and reset
input         HCLK;            // AHB clock
input         HRESETn;         // AHB reset

// From Master interface (DmacAhbMaster)
input  [31:0] MasterAddressM1; // HADDR information of AHB1
input  [31:0] MasterAddressM2; // HADDR information of AHB2
input  [31:0] ChWrDataM1;      // Endianized Read Data of AHB 1 to be
                               // written into channel FIFO
input  [31:0] ChWrDataM2;      // Endianized Read Data of AHB 2 to be
                               // written into channel FIFO
input         BusAvlblM1;      // Bus available on AHB1
input         BusAvlblM2;      // Bus available on AHB2
input         DataErrorM1;     // Data error on AHB1
input         DataErrorM2;     // Data error on AHB2
input         XferAbortedM1;   // Acknowledgement to abort request
input         XferAbortedM2;   // Acknowledgement to abort request

// From AHB Slave interface (DmacAhbSlaveIf)
input         RegHWrite;       // Write enable signal to DMAC channel
                               // registers
input   [4:2] RegAddress;      // Lower order bits of the buffered
                               // address from DMAC AHB Slave
input         DmacChannelSel;  // Read-Write Select for channel
input  [31:0] HWDATA;          // Write data for the registers
input         ClrIntTC;        // TC Interrupt clear for channel
input         ClrIntErr;       // Error Interrupt clear for channel
input  [15:0] DMACBREQCh;      // DMA burst transfer request
input  [15:0] DMACLBREQCh;     // DMAC last burst transfer request
input  [15:0] DMACSREQCh;      // DMAC single transfer request
input  [15:0] DMACLSREQCh;     // DMAC last single transfer request
input         DMACEn;          // DMAC Controller Enable

// From DmacArbiter
input         ChGntM1;         // Grant for channel from master1
input         ChGntM2;         // Grant for channel from master2

// Outputs

// To AHB Slave block (DmacAhbSlaveIf)
output [31:0] ChHRDATA;        // Read data bus from channel
output        ChannelEn;       // Channel enabled status
output        IntErrCh;        // Error Interrupt for channel
output        IntTCCh;         // TC Interrupt for channel
output        RawIntErrCh;     // Raw Error Interrupt for Channel
output        RawIntTCCh;      // Raw TC Interrupt for Channel
output [15:0] ClearReq;        // Clear DMAREQ from Channel
output [15:0] SigTC;           // DMACTC signal from channel
output [15:0] ErrClrReq;       // Pulse for clearing the SoftRequest
                               // registers

// To AHB Master interfaces (DmacAhbMaster)
output        ChLock;          // HLOCK information for channel

// Master 1 signals
output  [4:0] ChNumOfXfersM1;  // Number of requested transfers
output        ChReqM1;         // Channel request for AHB
output        ChIncrM1;        // Indicates incrementing transfers are
                               // required for channel
output [31:0] ChAddrM1;        // First address for the AHB Access
                               // requested by channel
output  [2:0] ChProtM1;        // HPROT information for channel
output  [2:0] ChWidthM1;       // HSIZE information for channel
output        ChDirxnM1;       // HWRITE information for channel
output        ChXferAbortM1;   // Request to abort the AHB transfer
                               // from channel
output [31:0] ChHWDATAM1;      // The HWDATA information from the
                               // channel

// Master 2 signals
output  [4:0] ChNumOfXfersM2;  // Number of requested transfers
output        ChReqM2;         // Channel request for AHB
output        ChIncrM2;        // Indicates incrementing transfers are
                               // required for channel
output [31:0] ChAddrM2;        // First address for the AHB Access
                               // requested by channel
output  [2:0] ChProtM2;        // HPROT information for channel
output  [2:0] ChWidthM2;       // HSIZE information for channel
output        ChDirxnM2;       // HWRITE information for channel
output        ChXferAbortM2;   // Request to abort the AHB transfer
                               // from channel
output [31:0] ChHWDATAM2;      // The HWDATA information from the
                               // channel

// Inputs

// Clock and reset
wire          HCLK;            // AHB clock
wire          HRESETn;         // AHB reset

// From Master interface (DmacAhbMaster)
wire   [31:0] MasterAddressM1; // HADDR information of AHB1
wire   [31:0] MasterAddressM2; // HADDR information of AHB2
wire   [31:0] ChWrDataM1;      // Endianized Read Data of AHB 1 to be
                               // written into channel FIFO
wire   [31:0] ChWrDataM2;      // Endianized Read Data of AHB 2 to be
                               // written into channel FIFO
wire          BusAvlblM1;      // Bus available on AHB1
wire          BusAvlblM2;      // Bus available on AHB2
wire          DataErrorM1;     // Data error on AHB1
wire          DataErrorM2;     // Data error on AHB2
wire          XferAbortedM1;   // Acknowledgement to abort request
wire          XferAbortedM2;   // Acknowledgement to abort request

// From AHB Slave interface (DmacAhbSlaveIf)
wire          RegHWrite;       // Write enable signal to DMAC channel
                               // registers
wire    [4:2] RegAddress;      // Lower order bits of the buffered
                               // address from DMAC AHB Slave
wire          DmacChannelSel;  // Read-Write Select for channel
wire   [31:0] HWDATA;          // Write data for the registers
wire          ClrIntTC;        // TC Interrupt clear for channel
wire          ClrIntErr;       // Error Interrupt clear for channel
wire   [15:0] DMACBREQCh;      // DMA burst transfer request
wire   [15:0] DMACLBREQCh;     // DMAC last burst transfer request
wire   [15:0] DMACSREQCh;      // DMAC single transfer request
wire   [15:0] DMACLSREQCh;     // DMAC last single transfer request
wire          DMACEn;          // DMAC Controller Enable

// From DmacArbiter
wire          ChGntM1;         // Grant for channel from master1
wire          ChGntM2;         // Grant for channel from master2



// Outputs

// To AHB Slave block (DmacAhbSlaveIf)
wire   [31:0] ChHRDATA;        // Read data bus from channel
wire          ChannelEn;       // Channel enabled status
wire          IntErrCh;        // Error Interrupt for channel
wire          IntTCCh;         // TC Interrupt for channel
wire          RawIntErrCh;     // Raw Error Interrupt for Channel
wire          RawIntTCCh;      // Raw TC Interrupt for Channel
wire   [15:0] ClearReq;        // Clear DMAREQ from Channel
wire   [15:0] SigTC;           // DMACTC signal from channel
wire   [15:0] ErrClrReq;       // Pulse for clearing the SoftRequest
                               // registers

// To AHB Master interfaces (DmacAhbMaster)
wire          ChLock;          // HLOCK information for channel

// Master 1 signals
wire    [4:0] ChNumOfXfersM1;  // Number of requested transfers
wire          ChReqM1;         // Channel request for AHB
wire          ChIncrM1;        // Indicates incrementing transfers are
                               // required for channel
wire   [31:0] ChAddrM1;        // First address for the AHB Access
                               // requested by channel
wire    [2:0] ChProtM1;        // HPROT information for channel
wire    [2:0] ChWidthM1;       // HSIZE information for channel
wire          ChDirxnM1;       // HWRITE information for channel
wire          ChXferAbortM1;   // Request to abort the AHB transfer
                               // from channel
wire   [31:0] ChHWDATAM1;      // The HWDATA information from the
                               // channel

// Master 2 signals
wire    [4:0] ChNumOfXfersM2;  // Number of requested transfers
wire          ChReqM2;         // Channel request for AHB
wire          ChIncrM2;        // Indicates incrementing transfers are
                               // required for channel
wire   [31:0] ChAddrM2;        // First address for the AHB Access
                               // requested by channel
wire    [2:0] ChProtM2;        // HPROT information for channel
wire    [2:0] ChWidthM2;       // HSIZE information for channel
wire          ChDirxnM2;       // HWRITE information for channel
wire          ChXferAbortM2;   // Request to abort the AHB transfer
                               // from channel
wire   [31:0] ChHWDATAM2;      // The HWDATA information from the
                               // channel


// -----------------------------------------------------------------------------
//
//                                 DmacChannel
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is the top level of the DMAC Channel. This block instantiates
// the following functional sub-blocks in the DMAC Channel.
// o DmacChRegBlock (mainly contains the logic for inferring of channel
//   registers and bits)
// o DmacChSrcXfer (handles the AHB transfers during source-to-DMA transfer
//   operation)
// o DmacChDstXfer (handles the AHB transfers during DMA-to-destination transfer
//   operation)
// o DmacChLLILoad (handles the AHB transfers during LLI loading operation)
// o DmacChPckUnpck (contains FIFO packing-unpacking logic)
// o DmacChReqProc (Dmac Channel request processor)
// o DmacChReqMask (Dmac Channel request mask)
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [4:0] SrcDmacState;
// Source-transfer-logic state

wire        DecTrfSizeSrc;
// Decreases the source-transfer-size count by 1

wire        SrcAddrUpdate;
// When this signal is high, MasterAddress is clocked into Src-address-register

wire        SrcDisable;
// Source disable

wire  [4:0] DstDmacState;
// Destination-transfer-logic state

wire        SrcErr;
// Indicates error during source transfer

wire        DstErr;
// Indicates error during destination transfer

wire        DecTrfSizeDst;
// Decreases the destination-transfer-size count by 1

wire        DstAddrUpdate;
// When this signal is high, MasterAddress is clocked into Dst-address-register

wire        DstDisable;
// Destination disable

wire        FinishedLLI;
// LLI loading has finished

wire        LLIErr;
// Indicates error during LLI loading

wire        DisabledLLI;
// Indicates that the DMAC is disabled by software even before the start of
// actual LLI loading operation

wire        LLISrcWr;
// LLI update for channel source register

wire        LLIDstWr;
// LLI update for channel destination register

wire        LLILLIRegWr;
// LLI update for channel LLI register

wire        LLICntlWr;
// LLI update for channel control register

wire        FifoNonEmpty;
// Indicates data being present in the channel FIFO

wire        FifoPtrReset;
// Resets the FIFO pointers

wire        SetIntErr;
// Signals error interrupt

wire [31:0] DMACChSrcAddr;
// Channel source address

wire [31:0] DMACChDstAddr;
// Channel destination address

wire        UnsetErrMsk;
// Unsets the error mask

wire [13:0] TrfSizeDst;
// Transfer size value for the destination-transfer-logic

wire        SrcErred;
// Indicates error during source transfer

wire        DisabledSrc;
// Source disabled

wire        DisabledDst;
// Destination disabled

wire  [2:0] SWidth;
// Source transfer width

wire  [2:0] DWidth;
// Destination transfer width

wire        SrcSelect;
// Source AHB Master select

wire        DstSelect;
// Destination AHB Master select

wire [11:0] TrfSizeSrc;
// Indicates the number of source transfers to perform

wire  [2:0] SBSize;
// Source burst size

wire  [2:0] DBSize;
// Destination burst size

wire        SrcIncr;
// Indicates incrementing addressing for source

wire        DestIncr;
// Indicates incrementing addressing for destination

wire  [2:0] ProtStat;
// Higher three bits of HPROT signal

wire        TCIntMask;
// Terminal-count-interrupt mask

wire  [3:0] SrcPeriph;
// Indicates the source-peripheral mapped to the channel

wire  [3:0] DstPeriph;
// Indicates the destination-peripheral mapped to the channel

wire  [2:0] FlowCntl;
// Flow control information

wire  [2:1] FlowCntl2MSB;
// Higher 2 bits of FlowCntl bit-field

wire        ErrIntMask;
// Mask for error-interrupt

wire        Halt;
// User generated masks for source requests

wire        ChannelEnLow;
// Indicates a 0 being written to Channel-Enable

wire        SourceEn;
// Source enabled

wire        DestEn;
// Destination enabled

wire        LLISelForPkt;
// AHB Master select for LLI loading

wire [31:2] LLIAddressUB;
// Address of the next LLI

wire        SrcStart;
// Indicates that source transfers can start

wire        ChSrcBReq;
// Source burst request for the channel

wire        ChSrcSReq;
// Source single request for the channel

wire        ChSrcLBReq;
// Source last burst request for the channel

wire        ChSrcLSReq;
// Source last single request for the channel

wire        ChDstBReq;
// Destination burst request for the channel

wire        ChDstSReq;
// Destination single request for the channel

wire        ChDstLBReq;
// Destination last burst request for the channel

wire        ChDstLSReq;
// Destination last single request for the channel

wire  [2:0] DstFactor;
// The addition factor to FifoEmpty level for burst optimization

wire  [4:0] FifoEmptyLevel;
// Number of spaces empty in FIFO in terms of Source Width

wire        SetSrcAxsOnMsk;
// Sets the access-on mask

wire        UnsetSrcAxsOnMsk;
// Resets the access-on mask

wire        SetSrcE2LMsk;
// Sets a mask on source request from source-end to actual disable

wire        SetErrMskSrc;
// Sets a mask on source and destination when there is an error during source
// transfers

wire        AbortReqSrcM1;
// Source Abort request for Master1

wire        AbortReqSrcM2;
// Source Abort request for Master2

wire        AbortReqDstM1;
// Destination abort request for Master1

wire        AbortReqDstM2;
// Destination abort request for Master2

wire        DMACTCSrc;
// TC signal for the source request

wire        DMACClrSrc;
// Clear signal for source request

wire  [4:0] SrcNumOfXfers;
// Number of source transfers to be done in an AHB access on AHB1

wire  [4:0] DstNumOfXfers;
// Number of destination transfers to be done in one AHB access

wire        SetSrcTCDone;
// Indicates that source-TC has been asserted in source-flow-control

wire  [3:0] SrcFactor;
// The additional factor to FifoFill level for destination-burst-optimization

wire        RdPtrInc;
// Read one data from channel FIFO

wire  [4:0] FifoFillLevel;
// Number of data, filled in the FIFO, in terms of source width

wire  [4:0] ActFillLevel;
// Number of spaces filled in FIFO in terms of Destination Width

wire  [4:0] ActEmptyLevel;
// Number of space empty in FIFO in terms of Source Width

wire        DstStart;
// Destination transfers can start

wire        SetDstAxsOnMsk;
// Sets a mask on destination requests because of continuing access

wire        UnsetDstAxsOnMsk;
// Unsets destination-access-on mask

wire        SetLLILoadMsk;
// Sets the mask on source/destination request during LLI load

wire        SetErrMskDst;
// Masks both source and destination requests in case of error

wire        UnsetLLILoadMsk;
// LLI load mask

wire        UnsetSrcE2LMsk;
// Unsets source-end to "actual-disable/LLI-load" mask

wire        DMACClrDst;
// Clear signal for destination request

wire        DMACTCDst;
// TC signal for the destination request

wire        SetLLIReq;
// Sets the LLI request

wire        SetIntTC;
// Sets TC interrupt signal

wire        LLIStart;
// LLI loading can start

wire        UnsetLLIReq;
// De-asserts the LLI request

wire [31:0] FifoRdData;
// Read Data from Channel FIFO

wire        FifoWrEn;
// Write enable to data buffer

wire  [1:0] FifoWrPtr;
// FIFO write pointer

wire [31:0] FifoWrData;
// Data to be written into the FIFO

wire [31:0] FifoWrMask;
// Mask for writing into a specific data-lane in FIFO

wire  [1:0] FifoRdPtr;
// FIFO read pointer

wire        SourceMask;
// Final source mask

wire        DestMask;
// Final destination mask

wire  [1:0] DWidth2LSB;
// Destination transfer width

wire        IntTCEnable;
// Enable for raising the TC interrupt

wire  [4:0] AxsCntDst;
// Access count value for destination transfer

wire        LdSrcInDstFlow;
// Indicates that the TrfSizeSrc register can be loaded with destination
// required number

wire        DstErred;
// Bit indicating an error during destination transfer

wire        ErrCycMaskDst;
// Masks the channel requests during second cycle of the AHB error response on
// destination transfers

wire        ErrCycMaskSrc;
// Masks the channel requests during second cycle of the AHB error response on
// source transfers

wire        DstBurstOn;
// Indicates that the destination burst needs more AHB access to finish

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

assign FlowCntl2MSB     = FlowCntl[2:1];
assign DWidth2LSB       = DWidth[1:0];

// -----------------------------------------------------------------------------
// This block describes the channel-registers, counters and other flag-bits.
// -----------------------------------------------------------------------------
DmacChRegBlock uDmacChRegBlock        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .HWDATA           (HWDATA),
                    .MasterAddressM1  (MasterAddressM1),
                    .MasterAddressM2  (MasterAddressM2),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .DmacChannelSel   (DmacChannelSel),
                    .RegHWrite        (RegHWrite),
                    .RegAddress       (RegAddress),
                    .SrcDmacState     (SrcDmacState),
                    .SrcErr           (SrcErr),
                    .SrcDisable       (SrcDisable),
                    .SrcAddrUpdate    (SrcAddrUpdate),
                    .DecTrfSizeSrc    (DecTrfSizeSrc),
                    .DecTrfSizeDst    (DecTrfSizeDst),
                    .DstDmacState     (DstDmacState),
                    .DstErr           (DstErr),
                    .DstDisable       (DstDisable),
                    .DstAddrUpdate    (DstAddrUpdate),
                    .FinishedLLI      (FinishedLLI),
                    .LLIErr           (LLIErr),
                    .DisabledLLI      (DisabledLLI),
                    .LLISrcWr         (LLISrcWr),
                    .LLIDstWr         (LLIDstWr),
                    .LLILLIRegWr      (LLILLIRegWr),
                    .LLICntlWr        (LLICntlWr),
                    .FifoNonEmpty     (FifoNonEmpty),
                    .ChDstBReq        (ChDstBReq),
                    .ChDstLBReq       (ChDstLBReq),
                    .LdSrcInDstFlow   (LdSrcInDstFlow),
                    .ChHRDATA         (ChHRDATA),
                    .FifoPtrReset     (FifoPtrReset),
                    .SetIntErr        (SetIntErr),
                    .DMACChSrcAddr    (DMACChSrcAddr),
                    .DMACChDstAddr    (DMACChDstAddr),
                    .UnsetErrMsk      (UnsetErrMsk),
                    .TrfSizeDst       (TrfSizeDst),
                    .DisabledDst      (DisabledDst),
                    .SrcErred         (SrcErred),
                    .DisabledSrc      (DisabledSrc),
                    .IntTCEnable      (IntTCEnable),
                    .DstErred         (DstErred),
                    .SWidth           (SWidth),
                    .DWidth           (DWidth),
                    .SrcSelect        (SrcSelect),
                    .DstSelect        (DstSelect),
                    .TrfSizeSrc       (TrfSizeSrc),
                    .SBSize           (SBSize),
                    .DBSize           (DBSize),
                    .SrcIncr          (SrcIncr),
                    .DestIncr         (DestIncr),
                    .ProtStat         (ProtStat),
                    .TCIntMask        (TCIntMask),
                    .ChannelEn        (ChannelEn),
                    .SrcPeriph        (SrcPeriph),
                    .DstPeriph        (DstPeriph),
                    .FlowCntl         (FlowCntl),
                    .ErrIntMask       (ErrIntMask),
                    .ChLock           (ChLock),
                    .Halt             (Halt),
                    .ChannelEnLow     (ChannelEnLow),
                    .SourceEn         (SourceEn),
                    .DestEn           (DestEn),
                    .LLISelForPkt     (LLISelForPkt),
                    .LLIAddressUB     (LLIAddressUB)
                    );

// -----------------------------------------------------------------------------
// This block handles the Source-peripheral to DMAC data transfer.
// -----------------------------------------------------------------------------
DmacChSrcXfer uDmacChSrcXfer          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .DMACEn           (DMACEn),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .SrcStart         (SrcStart),
                    .FlowCntl         (FlowCntl),
                    .TrfSizeSrc       (TrfSizeSrc),
                    .SBSize           (SBSize),
                    .SWidth           (SWidth),
                    .DWidth           (DWidth),
                    .SrcSelect        (SrcSelect),
                    .DstSelect        (DstSelect),
                    .SourceEn         (SourceEn),
                    .LLIAddressUB     (LLIAddressUB),
                    .ChannelEn        (ChannelEn),
                    .DstErred         (DstErred),
                    .ChSrcBReq        (ChSrcBReq),
                    .ChSrcSReq        (ChSrcSReq),
                    .ChSrcLBReq       (ChSrcLBReq),
                    .ChSrcLSReq       (ChSrcLSReq),
                    .ChDstLBReq       (ChDstLBReq),
                    .ChDstLSReq       (ChDstLSReq),
                    .FifoEmptyLevel   (FifoEmptyLevel),
                    .SetSrcAxsOnMsk   (SetSrcAxsOnMsk),
                    .UnsetSrcAxsOnMsk (UnsetSrcAxsOnMsk),
                    .SetSrcE2LMsk     (SetSrcE2LMsk),
                    .SetErrMskSrc     (SetErrMskSrc),
                    .ErrCycMaskSrc    (ErrCycMaskSrc),
                    .AbortReqSrcM1    (AbortReqSrcM1),
                    .AbortReqSrcM2    (AbortReqSrcM2),
                    .DMACTCSrc        (DMACTCSrc),
                    .DMACClrSrc       (DMACClrSrc),
                    .SrcNumOfXfers    (SrcNumOfXfers),
                    .DecTrfSizeSrc    (DecTrfSizeSrc),
                    .SrcAddrUpdate    (SrcAddrUpdate),
                    .SrcDisable       (SrcDisable),
                    .SrcErr           (SrcErr),
                    .SrcDmacState     (SrcDmacState),
                    .SetSrcTCDone     (SetSrcTCDone),
                    .SrcFactor        (SrcFactor),
                    .FifoWrEn         (FifoWrEn)
                    );

// -----------------------------------------------------------------------------
// This block handles the DMAC to Destination-peripheral data transfer.
// -----------------------------------------------------------------------------
DmacChDstXfer uDmacChDstXfer          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .DMACEn           (DMACEn),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .XferAbortedM1    (XferAbortedM1),
                    .XferAbortedM2    (XferAbortedM2),
                    .SetSrcTCDone     (SetSrcTCDone),
                    .FlowCntl         (FlowCntl),
                    .TrfSizeDst       (TrfSizeDst),
                    .DBSize           (DBSize),
                    .DWidth2LSB       (DWidth2LSB),
                    .SrcSelect        (SrcSelect),
                    .DstSelect        (DstSelect),
                    .DestEn           (DestEn),
                    .LLIAddressUB     (LLIAddressUB),
                    .ChannelEn        (ChannelEn),
                    .SrcErred         (SrcErred),
                    .DisabledSrc      (DisabledSrc),
                    .IntTCEnable      (IntTCEnable),
                    .FifoFillLevel    (FifoFillLevel),
                    .ChDstBReq        (ChDstBReq),
                    .ChDstLBReq       (ChDstLBReq),
                    .ChDstSReq        (ChDstSReq),
                    .ChDstLSReq       (ChDstLSReq),
                    .DstStart         (DstStart),
                    .DstDisable       (DstDisable),
                    .DstErr           (DstErr),
                    .DecTrfSizeDst    (DecTrfSizeDst),
                    .DstAddrUpdate    (DstAddrUpdate),
                    .SetDstAxsOnMsk   (SetDstAxsOnMsk),
                    .UnsetDstAxsOnMsk (UnsetDstAxsOnMsk),
                    .SetLLILoadMsk    (SetLLILoadMsk),
                    .SetErrMskDst     (SetErrMskDst),
                    .ErrCycMaskDst    (ErrCycMaskDst),
                    .DMACClrDst       (DMACClrDst),
                    .DMACTCDst        (DMACTCDst),
                    .SetLLIReq        (SetLLIReq),
                    .AbortReqDstM1    (AbortReqDstM1),
                    .AbortReqDstM2    (AbortReqDstM2),
                    .SetIntTC         (SetIntTC),
                    .DstNumOfXfers    (DstNumOfXfers),
                    .DstBurstOn       (DstBurstOn),
                    .DstFactor        (DstFactor),
                    .DstDmacState     (DstDmacState),
                    .AxsCntDst        (AxsCntDst),
                    .RdPtrInc         (RdPtrInc)
                    );

// -----------------------------------------------------------------------------
// This block handles the data transfer for DMAC during LLI loading.
// -----------------------------------------------------------------------------
DmacChLLILoad uDmacChLLILoad          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .DataErrorM1      (DataErrorM1),
                    .DataErrorM2      (DataErrorM2),
                    .DMACEn           (DMACEn),
                    .ChannelEn        (ChannelEn),
                    .ChannelEnLow     (ChannelEnLow),
                    .LLISelForPkt     (LLISelForPkt),
                    .LLIStart         (LLIStart),
                    .UnsetLLILoadMsk  (UnsetLLILoadMsk),
                    .UnsetSrcE2LMsk   (UnsetSrcE2LMsk),
                    .LLIErr           (LLIErr),
                    .DisabledLLI      (DisabledLLI),
                    .LLILLIRegWr      (LLILLIRegWr),
                    .LLICntlWr        (LLICntlWr),
                    .LLIDstWr         (LLIDstWr),
                    .LLISrcWr         (LLISrcWr),
                    .FinishedLLI      (FinishedLLI),
                    .UnsetLLIReq      (UnsetLLIReq)
                    );

// -----------------------------------------------------------------------------
// The following block packs the data into the FIFO during FIFO writes and
// unpacks it out from the FIFO during FIFO reads.
// -----------------------------------------------------------------------------
DmacChPckUnpck uDmacChPckUnpck        (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .ChWrDataM1       (ChWrDataM1),
                    .ChWrDataM2       (ChWrDataM2),
                    .BusAvlblM1       (BusAvlblM1),
                    .BusAvlblM2       (BusAvlblM2),
                    .SWidth           (SWidth),
                    .DWidth           (DWidth),
                    .SrcSelect        (SrcSelect),
                    .DstSelect        (DstSelect),
                    .FifoPtrReset     (FifoPtrReset),
                    .FifoRdData       (FifoRdData),
                    .SrcDmacState     (SrcDmacState),
                    .FifoWrEn         (FifoWrEn),
                    .SrcFactor        (SrcFactor),
                    .DstFactor        (DstFactor),
                    .DstDmacState     (DstDmacState),
                    .AxsCntDst        (AxsCntDst),
                    .RdPtrInc         (RdPtrInc),
                    .ChHWDATAM1       (ChHWDATAM1),
                    .ChHWDATAM2       (ChHWDATAM2),
                    .FifoWrPtr        (FifoWrPtr),
                    .FifoWrData       (FifoWrData),
                    .FifoWrMask       (FifoWrMask),
                    .FifoRdPtr        (FifoRdPtr),
                    .ActEmptyLevel    (ActEmptyLevel),
                    .ActFillLevel     (ActFillLevel),
                    .FifoEmptyLevel   (FifoEmptyLevel),
                    .FifoFillLevel    (FifoFillLevel),
                    .FifoNonEmpty     (FifoNonEmpty)
                    );

// -----------------------------------------------------------------------------
// The following block contains the block-of-4-registers used in Channel FIFO.
// -----------------------------------------------------------------------------
DmacChRegFile uDmacChRegFile          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .FifoWrEn         (FifoWrEn),
                    .FifoWrPtr        (FifoWrPtr),
                    .FifoWrData       (FifoWrData),
                    .FifoWrMask       (FifoWrMask),
                    .FifoRdPtr        (FifoRdPtr),
                    .FifoRdData       (FifoRdData)
                    );

// -----------------------------------------------------------------------------
// This block maps the DMAC-request-lines to the channel, routes the
// Channel-information to one of the two AHB Master ports and resolves the
// internal-arbiter-grant to start source/destination/LLI transfers.
// -----------------------------------------------------------------------------
DmacChReqProc uDmacChReqProc          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .DMACBREQCh       (DMACBREQCh),
                    .DMACLBREQCh      (DMACLBREQCh),
                    .DMACSREQCh       (DMACSREQCh),
                    .DMACLSREQCh      (DMACLSREQCh),
                    .ClrIntErr        (ClrIntErr),
                    .ClrIntTC         (ClrIntTC),
                    .SrcPeriph        (SrcPeriph),
                    .DstPeriph        (DstPeriph),
                    .FlowCntl         (FlowCntl),
                    .SetIntErr        (SetIntErr),
                    .ErrIntMask       (ErrIntMask),
                    .TCIntMask        (TCIntMask),
                    .SrcSelect        (SrcSelect),
                    .DstSelect        (DstSelect),
                    .LLISelForPkt     (LLISelForPkt),
                    .DMACChSrcAddr    (DMACChSrcAddr),
                    .DMACChDstAddr    (DMACChDstAddr),
                    .ProtStat         (ProtStat),
                    .SWidth           (SWidth),
                    .DWidth           (DWidth),
                    .SBSize           (SBSize),
                    .LLIAddressUB     (LLIAddressUB),
                    .SrcIncr          (SrcIncr),
                    .DestIncr         (DestIncr),
                    .ChannelEn        (ChannelEn),
                    .TrfSizeSrc       (TrfSizeSrc),
                    .AbortReqSrcM1    (AbortReqSrcM1),
                    .AbortReqSrcM2    (AbortReqSrcM2),
                    .DMACClrSrc       (DMACClrSrc),
                    .DMACTCSrc        (DMACTCSrc),
                    .SrcNumOfXfers    (SrcNumOfXfers),
                    .AbortReqDstM1    (AbortReqDstM1),
                    .AbortReqDstM2    (AbortReqDstM2),
                    .DMACClrDst       (DMACClrDst),
                    .DMACTCDst        (DMACTCDst),
                    .SetIntTC         (SetIntTC),
                    .SetLLIReq        (SetLLIReq),
                    .DstNumOfXfers    (DstNumOfXfers),
                    .DstDmacState     (DstDmacState),
                    .UnsetLLIReq      (UnsetLLIReq),
                    .FinishedLLI      (FinishedLLI),
                    .SourceMask       (SourceMask),
                    .DestMask         (DestMask),
                    .ChGntM1          (ChGntM1),
                    .ChGntM2          (ChGntM2),
                    .DstBurstOn       (DstBurstOn),
                    .FifoNonEmpty     (FifoNonEmpty),
                    .ChSrcBReq        (ChSrcBReq),
                    .ChSrcLBReq       (ChSrcLBReq),
                    .ChSrcSReq        (ChSrcSReq),
                    .ChSrcLSReq       (ChSrcLSReq),
                    .SrcStart         (SrcStart),
                    .ChDstBReq        (ChDstBReq),
                    .ChDstLBReq       (ChDstLBReq),
                    .ChDstSReq        (ChDstSReq),
                    .ChDstLSReq       (ChDstLSReq),
                    .DstStart         (DstStart),
                    .LLIStart         (LLIStart),
                    .ChXferAbortM1    (ChXferAbortM1),
                    .ChXferAbortM2    (ChXferAbortM2),
                    .ChReqM1          (ChReqM1),
                    .ChReqM2          (ChReqM2),
                    .ChNumOfXfersM1   (ChNumOfXfersM1),
                    .ChNumOfXfersM2   (ChNumOfXfersM2),
                    .ChIncrM1         (ChIncrM1),
                    .ChIncrM2         (ChIncrM2),
                    .ChAddrM1         (ChAddrM1),
                    .ChAddrM2         (ChAddrM2),
                    .ChProtM1         (ChProtM1),
                    .ChProtM2         (ChProtM2),
                    .ChWidthM1        (ChWidthM1),
                    .ChWidthM2        (ChWidthM2),
                    .ChDirxnM1        (ChDirxnM1),
                    .ChDirxnM2        (ChDirxnM2),
                    .LdSrcInDstFlow   (LdSrcInDstFlow),
                    .ClearReq         (ClearReq),
                    .RawIntErrCh      (RawIntErrCh),
                    .RawIntTCCh       (RawIntTCCh),
                    .ErrClrReq        (ErrClrReq),
                    .IntErrCh         (IntErrCh),
                    .IntTCCh          (IntTCCh),
                    .SigTC            (SigTC)
                    );

// -----------------------------------------------------------------------------
// This block describes the masks to be put on channel transfer requests.
// -----------------------------------------------------------------------------
DmacChReqMask uDmacChReqMask          (
                    .HCLK             (HCLK),
                    .HRESETn          (HRESETn),
                    .SetErrMskSrc     (SetErrMskSrc),
                    .SetSrcE2LMsk     (SetSrcE2LMsk),
                    .SetSrcAxsOnMsk   (SetSrcAxsOnMsk),
                    .UnsetSrcAxsOnMsk (UnsetSrcAxsOnMsk),
                    .ErrCycMaskSrc    (ErrCycMaskSrc),
                    .SetErrMskDst     (SetErrMskDst),
                    .SetLLILoadMsk    (SetLLILoadMsk),
                    .SetDstAxsOnMsk   (SetDstAxsOnMsk),
                    .UnsetDstAxsOnMsk (UnsetDstAxsOnMsk),
                    .ErrCycMaskDst    (ErrCycMaskDst),
                    .UnsetErrMsk      (UnsetErrMsk),
                    .ChannelEn        (ChannelEn),
                    .TrfSizeSrc       (TrfSizeSrc),
                    .FlowCntl2MSB     (FlowCntl2MSB),
                    .SourceEn         (SourceEn),
                    .DestEn           (DestEn),
                    .DisabledSrc      (DisabledSrc),
                    .TrfSizeDst       (TrfSizeDst),
                    .DisabledDst      (DisabledDst),
                    .UnsetSrcE2LMsk   (UnsetSrcE2LMsk),
                    .UnsetLLILoadMsk  (UnsetLLILoadMsk),
                    .Halt             (Halt),
                    .ActEmptyLevel    (ActEmptyLevel),
                    .ActFillLevel     (ActFillLevel),
                    .ChDstBReq        (ChDstBReq),
                    .ChDstLBReq       (ChDstLBReq),
                    .ChDstSReq        (ChDstSReq),
                    .ChDstLSReq       (ChDstLSReq),
                    .LdSrcInDstFlow   (LdSrcInDstFlow),
                    .SourceMask       (SourceMask),
                    .DestMask         (DestMask)
                    );

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
