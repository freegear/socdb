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
// File Name              : DmacChDstXfer.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block describes the DMAC-Destination transfer logic.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacChDstXfer (
// Inputs
                      // AHB System
                      HCLK,
                      HRESETn,
                      // From AHB Slave (DmacAhbSlaveIf)
                      DMACEn,
                      // From AHB Master Interface (DmacAhbMaster)
                      BusAvlblM1,
                      BusAvlblM2,
                      DataErrorM1,
                      DataErrorM2,
                      XferAbortedM1,
                      XferAbortedM2,
                      // From DmacChSrcXfer block
                      SetSrcTCDone,
                      // From DmacChRegBlock block
                      FlowCntl,
                      TrfSizeDst,
                      DBSize,
                      DWidth2LSB,
                      SrcSelect,
                      DstSelect,
                      DestEn,
                      LLIAddressUB,
                      ChannelEn,
                      SrcErred,
                      DisabledSrc,
                      IntTCEnable,
                      // From DmacChPckUnpck block
                      FifoFillLevel,
                      // From DmacChReqProc block
                      ChDstBReq,
                      ChDstLBReq,
                      ChDstSReq,
                      ChDstLSReq,
                      DstStart,


// Outputs
                      // To DmacChRegBlock block
                      DstDisable,
                      DstErr,
                      DecTrfSizeDst,
                      DstAddrUpdate,
                      // To DmacChReqMask block
                      SetDstAxsOnMsk,
                      UnsetDstAxsOnMsk,
                      SetLLILoadMsk,
                      SetErrMskDst,
                      ErrCycMaskDst,
                      // To DmacChReqProc block
                      DMACClrDst,
                      DMACTCDst,
                      SetLLIReq,
                      AbortReqDstM1,
                      AbortReqDstM2,
                      SetIntTC,
                      DstNumOfXfers,
                      DstBurstOn,
                      // To DmacChPckUnpck and DmacChRegBlock block
                      DstFactor,
                      DstDmacState,
                      AxsCntDst,
                      RdPtrInc
                     );

// Inputs
// AHB System
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
// From AHB Slave (DmacAhbSlaveIf)
input         DMACEn;           // DMAC Enable
// From AHB Master Interface (DmacAhbMaster)
input         BusAvlblM1;       // Bus available on AHB1
input         BusAvlblM2;       // Bus available on AHB2
input         DataErrorM1;      // Data Error on AHB1
input         DataErrorM2;      // Data Error on AHB2
input         XferAbortedM1;    // Transfer aborted signal from AHB1
input         XferAbortedM2;    // Transfer aborted signal from AHB2
// From DmacChSrcXfer block
input         SetSrcTCDone;     // Indicates that source-TC has been asserted
                                // in source-flow-control
// From DmacChRegBlock block
input   [2:0] FlowCntl;         // Flow control information
input  [13:0] TrfSizeDst;       // Indicates number of destination tranfers to
                                // perform
input   [2:0] DBSize;           // Destination burst size
input   [1:0] DWidth2LSB;       // Lower two bits of destination transfer
                                // width
input         SrcSelect;        // Source AHB Master select
input         DstSelect;        // Destination AHB Master select
input         DestEn;           // Destination enabled
input  [31:2] LLIAddressUB;     // Address of next LLI
input         ChannelEn;        // Indicates whether channel is enabled
input         SrcErred;         // Indicates error during source transfer.
input         DisabledSrc;      // Source disabled
input         IntTCEnable;      // Enable for raising the TC interrupt
// From DmacChPckUnpck block
input   [4:0] FifoFillLevel;    // Number of data, filled in the FIFO, in
                                // terms of source width
// From DmacChReqProc block
input         ChDstBReq;        // Destination Burst Request for the channel
input         ChDstLBReq;       // Destination Last Burst Request for the
                                // channel
input         ChDstSReq;        // Destination Single Request for the channel
input         ChDstLSReq;       // Destination Last Single Request for the
                                // channel
input         DstStart;         // Destination transfer can start

// Outputs
// To DmacChRegBlock block
output        DstDisable;       // Disable destination
output        DstErr;           // Destination error
output        DecTrfSizeDst;    // Decrease destination transfersize by 1
output        DstAddrUpdate;    // Update the destination address register
// To DmacChReqMask block
output        SetDstAxsOnMsk;   // Sets destination-access-on mask
output        UnsetDstAxsOnMsk; // Unsets destination-access-on mask
output        SetLLILoadMsk;    // Sets the mask on source/dest request during
                                // LLI load
output        SetErrMskDst;     // Masks both source and destination requests
                                // in case of error
output        ErrCycMaskDst;    // Masks the channel requests during second
                                // cycle of the AHB error response
// To DmacChReqProc block
output        DMACClrDst;       // Clear signal for destination request
output        DMACTCDst;        // TC signal for the destination request
output        SetLLIReq;        // Sets the LLI request
output        AbortReqDstM1;    // Dest Abort request for Master1
output        AbortReqDstM2;    // Dest Abort request for Master2
output        SetIntTC;         // Sets TC interrupt signal
output  [4:0] DstNumOfXfers;    // Number of destination transfers to be done
                                // in one AHB access
output        DstBurstOn;       // Indicates that the destination burst needs
                                // more AHB access to finish
// To DmacChPckUnpck and DmacChRegBlock block
output  [2:0] DstFactor;        // The addition factor to FifoEmpty level for
                                // burst optimization.
output  [4:0] DstDmacState;     // Destination state information
output  [4:0] AxsCntDst;        // Access count value for destination
                                // transfer.
output        RdPtrInc;         // Read one data from channel FIFO

// Inputs
// AHB System
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
// From AHB Slave (DmacAhbSlaveIf)
wire          DMACEn;           // DMAC Enable
// From AHB Master Interface (DmacAhbMaster)
wire          BusAvlblM1;       // Bus available on AHB1
wire          BusAvlblM2;       // Bus available on AHB2
wire          DataErrorM1;      // Data Error on AHB1
wire          DataErrorM2;      // Data Error on AHB2
wire          XferAbortedM1;    // Transfer aborted signal from AHB1
wire          XferAbortedM2;    // Transfer aborted signal from AHB2
// From DmacChSrcXfer block
wire          SetSrcTCDone;     // Indicates that source-TC has been asserted
                                // in source-flow-control
// From DmacChRegBlock block
wire    [2:0] FlowCntl;         // Flow control information
wire   [13:0] TrfSizeDst;       // Indicates number of destination transfers to
                                // perform
wire    [2:0] DBSize;           // Destination burst size
wire    [1:0] DWidth2LSB;       // Lower two bits of destination transfer
                                // width
wire          SrcSelect;        // Source AHB Master select
wire          DstSelect;        // Destination AHB Master select
wire          DestEn;           // Destination enabled
wire   [31:2] LLIAddressUB;     // Address of next LLI
wire          ChannelEn;        // Indicates whether channel is enabled
wire          SrcErred;         // Indicates error during source transfer.
wire          DisabledSrc;      // Source disabled
wire          IntTCEnable;      // Enable for raising the TC interrupt
// From DmacChPckUnpck block
wire    [4:0] FifoFillLevel;    // Number of data, filled in the FIFO, in
                                // terms of source width
// From DmacChReqProc block
wire          ChDstBReq;        // Destination Burst Request for the channel
wire          ChDstLBReq;       // Destination Last Burst Request for the
                                // channel
wire          ChDstSReq;        // Destination Single Request for the channel
wire          ChDstLSReq;       // Destination Last Single Request for the
                                // channel
wire          DstStart;         // Destination transfer can start

// Outputs
// To DmacChRegBlock block
reg           DstDisable;       // Disable destination
reg           DstErr;           // Destination error
reg           DecTrfSizeDst;    // Decrease destination transfersize by 1
reg           DstAddrUpdate;    // Update the destination address register
// To DmacChReqMask block
reg           SetDstAxsOnMsk;   // Sets destination-access-on mask
reg           UnsetDstAxsOnMsk; // Unsets destination-access-on mask
reg           SetLLILoadMsk;    // Sets the mask on source/dest request during
                                // LLI load
reg           SetErrMskDst;     // Masks both source and destination requests
                                // in case of error
wire          ErrCycMaskDst;    // Masks the channel requests during second
                                // cycle of the AHB error response
// To DmacChReqProc block
reg           DMACClrDst;       // Clear signal for destination request
reg           DMACTCDst;        // TC signal for the destination request
reg           SetLLIReq;        // Sets the LLI request
wire          AbortReqDstM1;    // Dest Abort request for Master1
wire          AbortReqDstM2;    // Dest Abort request for Master2
reg           SetIntTC;         // Sets TC interrupt signal
wire    [4:0] DstNumOfXfers;    // Number of destination transfers to be done
                                // in one AHB access
reg           DstBurstOn;       // Indicates that the destination burst needs
                                // more AHB access to finish
// To DmacChPckUnpck and DmacChRegBlock block
reg     [2:0] DstFactor;        // The addition factor to FifoEmpty level for
                                // burst optimization.
reg     [4:0] DstDmacState;     // Destination state information
reg     [4:0] AxsCntDst;        // Access count value for destination
                                // transfer.
reg           RdPtrInc;         // Read one data from channel FIFO

// -----------------------------------------------------------------------------
//
//                                DmacChDstXfer
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// The main functionality described in this file is the DMAC-Destination-Flow
// state machine. The other functions that the file performs are
// o Generation of a combinational value of Destination-Burst-Count which is
//   clocked by the main state machine while moving from IDLE state.
// o The two master interfaces return one BusAvlblM(1/2), DataErrorM(1/2) and
//   one XferAbortedM(1/2) each. Depending on DstSelect, one of the two is
//   muxed to the DMAC-Destination-Flow state machine.
// o If DMAC-Destination-Flow state machine raises a transfer-abort-request
//   (AbortReqDst), then it is de-multiplexed to one of the two Master
//   Interfaces depending on DstSelect.
// o SrcTCDone flag is set and reset. In source-flow-control mode, the
//   destination can be given a TC only when the source has indicated so.
//   SrcTCDone flag indicates that the TC(Terminal Count) condition for source
//   peripheral/memory has been reached.
// o In case of both source and destination being on the same bus, a factor
//   called DstFactor is generated. This factor is added to the actual FIFO
//   level to show a higher empty-level to source-transfer-block. This enables
//   the source-transfer-block to initiate a transfer of greater-burst-length.
//   This does not lead to data corruption, as the pipelined nature of the bus
//   ensures that by the time the source data arrives, the FIFO will be drained
//   out.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        BusAvlblDst;
// Bus-available signal for destination state machine

wire        DataErrorDst;
// Data-error signal for destination state machine

wire        XferAbortedDst;
// One of the XferAbortedM1 and XferAbortedM2 signal; selected according to
// DstSelect field

wire [13:0] BstNoJ;
// The minimum number from the transfer size and destination burst size

wire  [8:0] BstNoK;
// The minimum number from the transfer size and destination burst size
// and the FIFO fill level

wire [10:0] DstDMACL1;
// Temporary signal used for loading the access counter register in
// destination transfer state machine.

wire [10:0] DstDMACL2;
// Temporary signal used for loading the access counter register in
// destination transfer state machine.

wire  [8:0] DecodedBurst;
// Decoded version of the burst size.

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [10:0] BrstCntDstCo;
// Used for loading burst-counter and AxsCount in Destination-DMAC state machine

reg   [4:0] NextAxsCntDst;
// D-input for AxsCntDst

reg   [4:0] NextDstDmacState;
// D-input for DstDmacState

reg         NextDMACClrDst;
// D-input of DMACClrDst

reg         NextDMACTCDst;
// D-input of DMACTCDst

reg         NextDstBurstOn;
// D-input for DstBurstOn

reg         SrcTCDone;
// In source-flow control mode, it indicates that the TC for source has been
// given

reg         UnsetSrcTCDone;
// Unsets the SrcTCDone flag

reg         NextSrcTCDone;
// D-input of SrcTCDone flag

reg         AbortReqDst;
// Requesting transfer-abort to master

reg         NextAbortReqDst;
// D-input for AbortReqDst

reg  [10:0] BrstCntDst;
// Value of destination burst counter

reg  [10:0] NextBrstCntDst;
// D-input of BrstCntDst

reg         DstStartQ;
// Registered version of DstStart

reg         DestEnQ2;
// One clock delayed version of DestEn

//Include Parameters File
`include "DmacParams.v"

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
// Decoded the destination burst size for the register bit fields
// -----------------------------------------------------------------------------
assign DecodedBurst = DecodeBSize(DBSize);

// -----------------------------------------------------------------------------
// Precalculation of the number of transfer which destination has to do :
// BstNoJ : The minimum of the transfer size (calculated in terms of destination
// transfers) and the destination burst size gives the number of transfers which
// are required to be done in the current request.
// BstNoK : The actual request for the number of transfers is finally decided on
// the number filled location in the Fifo from the source side.
// -----------------------------------------------------------------------------
assign BstNoJ   = Minimum14(TrfSizeDst, {{5{1'b0}}, DecodedBurst});
assign BstNoK   = Minimum9(DecodedBurst, {4'b0000, FifoFillLevel});

// -----------------------------------------------------------------------------
// The DstDMACL statement describes the loading of AxsCntDst
// counter. If the destination-DMA-burst is continuing(indicated by
// DstBurstOn being high, then the AxsCntDst is to be loaded on the
// basis of BrstCntDst-counter-value(BrstCntDst). Else, AxsCntDst is
// loaded from combinational value of Burst-Count (BrstCntDstCo).
// -----------------------------------------------------------------------------
assign DstDMACL1 = Minimum11({{6{1'b0}}, FifoFillLevel}, BrstCntDst);
assign DstDMACL2 = Minimum11({{6{1'b0}}, FifoFillLevel}, BrstCntDstCo);

// -----------------------------------------------------------------------------
// The following block generates BrstCntDstCo, which is used by p_DstDMACComb to
// load AxsCntDst and BrstCntDst counters.
// ----------------------------------------------------------------------------
always @(FlowCntl or DBSize or ChDstBReq or ChDstLBReq or ChDstSReq or
         ChDstLSReq or BstNoJ or BstNoK)
begin : p_BstNoGenSrComb
  // Default assignment
  BrstCntDstCo     = {11{1'b0}};
  // When DMA is the flow controller.
  if (IsDMAFlowCntl(FlowCntl[2:1]))
    begin
      BrstCntDstCo     = BstNoJ[10:0];
    end
  // When Source is the flow controller
  else if (IsSrcFlowCntl(FlowCntl[2:1]))
    begin
      BrstCntDstCo     = {2'b00, BstNoK[8:0]};
    end
  // When destination is the flow controller.
  else if (IsDstFlowCntl(FlowCntl[2:1]))
    begin
      // When BREQ/LBREQ is high, the burst counter is loaded with DBSize number
      // of transfers. If both Burst and Single requests are high, then Burst
      // request should be given preference over Single request.
      if ((ChDstBReq == 1'b1) || (ChDstLBReq == 1'b1))
        BrstCntDstCo     = {2'b00, DecodeBSize(DBSize)};
      // When SREQ/LSREQ is high
      else if ((ChDstSReq == 1'b1) || (ChDstLSReq == 1'b1))
        BrstCntDstCo     = {10'b0000000000, 1'b1};
      // When no requests are high
      else
        BrstCntDstCo     = {2'b00, DecodeBSize(DBSize)};
    end
end // p_BstNoGenSrComb

// -----------------------------------------------------------------------------
// This block identifies the relevant BusAvlblDst for the destination-state
// machine from the two BusAvlbl signals (BusAvlblM1 and BusAvlblM2)
// -----------------------------------------------------------------------------
assign BusAvlblDst      = (DstSelect == 1'b0) ? BusAvlblM1           :
                           BusAvlblM2;

// -----------------------------------------------------------------------------
// This block identifies the relevant DataErrorDst for the destination-state
// machine from the two DataError signals (DataErrorM1 and DataErrorM2).
// -----------------------------------------------------------------------------
assign DataErrorDst     = (DstSelect == 1'b0) ? DataErrorM1          :
                           DataErrorM2;

// -----------------------------------------------------------------------------
// This block identifies the relevant XferAbortedDst for the destination-state
// machine from the two XferAborted signals (XferAbortedM1 and XferAbortedM2).
// -----------------------------------------------------------------------------
assign XferAbortedDst   = (DstSelect == 1'b0) ? XferAbortedM1        :
                           XferAbortedM2;

// -----------------------------------------------------------------------------
// The following block, routes the AHB-transfer-abort-request to the targeted
// AHB port via DMACChReqProc, where the Source-abort-request and destination-
// abort requests are ORed.
// -----------------------------------------------------------------------------
assign AbortReqDstM1    = ~(DstSelect) & AbortReqDst;
assign AbortReqDstM2    = DstSelect & AbortReqDst;

// -----------------------------------------------------------------------------
// The following block describes the Source-TC-done flag. In source-flow control
// mode, the destination gives the TC when at the end of an access
// o The channel FIFO is empty.
// o The SrcTCDone flag is set.
// After the destination-TC is given, the SrcTCDone flag is unset.
// The SetSrcTCDone is asserted by Src-DMAC-transfer-logic. UnsetSrcTCDone is
// asserted by destination-DMAC-transfer logic, after it has sampled SrcTCDone
// high at the end of DATAXFER state.
// The SrcTCDone flag is also reset when the channel-enable goes low.
// -----------------------------------------------------------------------------
always @(SetSrcTCDone or UnsetSrcTCDone or SrcTCDone or ChannelEn)
begin : p_SrcTCDnComb
  if (SetSrcTCDone == 1'b1)
    NextSrcTCDone    = 1'b1;
  else if ((UnsetSrcTCDone == 1'b1) || (ChannelEn == 1'b0))
    NextSrcTCDone    = 1'b0;
  else
    NextSrcTCDone    = SrcTCDone;
end // p_SrcTCDnComb

// -----------------------------------------------------------------------------
// Sequential block for p_SrcTCDnComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SrcTCDnSeq
  if (HRESETn == 1'b0)
    SrcTCDone        <= 1'b0;
  else
    SrcTCDone        <= NextSrcTCDone;
end // p_SrcTCDnSeq

// -----------------------------------------------------------------------------
// DestEnQ2 is used by the statemachine to control its abort related
// functions. Since the grant comes one clock after the request, DestEnQ2
// is used in place of DestEn. If the channel raises a request to the
// arbiter and on the very next clock the DestEn goes low, then the destination
// statemachine still should proceed, as at the time of raising the request
// DestEn was high.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DstEnDlySeq
  if (HRESETn == 1'b0)
    DestEnQ2         <= 1'b0;
  else
    DestEnQ2         <= DestEn;
end // p_DstEnDlySeq

// -----------------------------------------------------------------------------
// The following block describes the DMAC-Destination data flow state machine.
// There are 5 states in the state machine.
// ST_DST_IDLE
// ST_DST_SELECTED
// ST_DST_ONBUS
// ST_DST_DATAXFER
// ST_DST_WT4REQLOW
// In the following portion, the trigger for transition from each state is
// described.
//
// ST_DST_IDLE:
//   Transition to ST_DST_SELECTED: When
//   o the internal arbiter has granted the channel-destination machine
//     (indicated by DstStart). The internal arbiter grants the channel, and
//     the DmacChReqProc block resolves the Channel-grant to DstStart, SrcStart
//     or LLIStart.
//   o the DMAC and the channel is enabled and
//   o the AHB is not returning an error response
//
//   Transition to same state: When
//   o software disables the channel from AHB slave side (indicated by DestEnQ2
//     being 0)
//   o source of the same channel has received an error response.
//
// ST_DST_SELECTED:
//   Transition to ST_DST_ONBUS: When
//   o BusAvlbl is received.
//
//   Transition to ST_DST_IDLE: When
//   o the AHB returns an error to a data transfer.
//
// ST_DST_ONBUS:
//   Transition to ST_DST_DATAXFER: When
//   o BusAvlbl is received.
//
//   Transition to ST_DST_IDLE: When
//   o the AHB returns an error to a data transfer.
//
// ST_DST_DATAXFER:
//   Transition to ST_DST_IDLE: When
//   o the AHB returns an error to a data transfer.
//   OR
//   o the master interface acknowledges an Abort-request(signalled by
//     XferAborted). If the software disables the channel, when AHB transfers
//     are continuing on master side, the channel is not disabled immediately.
//     Instead, the channel sends an abort-request to the master interface. The
//     master-interface acknowledges the request, once it reaches the nearest
//     address boundary.
//   OR
//   o the current destination access on the bus has terminated, although the
//     destination-burst is still ON.
//     Note: One packet of destination transfers may constitute of many
//           Destination bursts (marked by giving clear after servicing each),
//           which in turn may constitute of many Destination accesses (limited
//           by FIFO availability).
//   o the current destination access as well as destination-burst has
//     completed, but the destination being a memory, the state-machine returns
//     to IDLE instead of doing the request-clear handshake.
//
//   Transition to ST_DST_DATAXFER: When
//   o destination burst is continuing and BusAvlbl for source is high.
//
//   Transition to ST_DST_WT4REQLOW: When
//   o current destination-access as well as the destination-burst has finished,
//     and the destination is a peripheral (not a memory, which does not
//     require any clear-request handshake).
//
// ST_DST_WT4REQLOW
//   Transition to ST_DST_IDLE: When
//   o the transfer request is pulled low by the peripheral.
// -----------------------------------------------------------------------------
always @(DstDmacState or DMACClrDst or DMACTCDst or AxsCntDst or
         DstBurstOn or BrstCntDst or AbortReqDst or DMACEn or DestEnQ2 or
         DstStart or DstStartQ or BusAvlblDst or FifoFillLevel or 
         BrstCntDstCo or DataErrorDst or XferAbortedDst or FlowCntl or 
         TrfSizeDst or LLIAddressUB or SrcTCDone or ChDstBReq or ChDstSReq or 
         ChDstLBReq or ChDstLSReq or SrcErred or DisabledSrc or IntTCEnable or 
         ChannelEn or DstDMACL1 or DstDMACL2 or DestEn)
begin : p_DstDMACComb
  // Default assignments
  // TC and clear lines
  NextDMACClrDst   = DMACClrDst;
  NextDMACTCDst    = DMACTCDst;
  // The mask logic
  SetDstAxsOnMsk   = 1'b0;
  UnsetDstAxsOnMsk = 1'b0;
  SetLLILoadMsk    = 1'b0;
  SetErrMskDst     = 1'b0;
  // To channel register block
  DstDisable       = 1'b0;
  DstErr           = 1'b0;
  DecTrfSizeDst    = 1'b0;
  DstAddrUpdate    = 1'b0;
  // Read from the channel FIFO
  RdPtrInc         = 1'b0;
  // Signals to be internally used within destination state-machine
  NextAxsCntDst    = AxsCntDst;
  NextDstBurstOn   = DstBurstOn;
  NextBrstCntDst   = BrstCntDst;
  UnsetSrcTCDone   = 1'b0;
  // Raising LLI request
  SetLLIReq        = 1'b0;
  // to master interface through internal arbiter.
  NextAbortReqDst  = AbortReqDst;
  // Interrupt Request
  SetIntTC         = 1'b0;

  case (DstDmacState)
    // ST_DST_IDLE:
    //   Transition to ST_DST_SELECTED: When
    //   o the internal arbiter has granted the channel-destination machine
    //     (indicated by DstStart). The internal arbiter grants the channel, and
    //     the DmacChReqProc block resolves the Channel-grant to DstStart,
    //     SrcStart or LLIStart.
    //   o the DMAC and the channel is enabled and
    //   o the AHB is not returning an error response
    //
    //   Transition to same state: When
    //   o software disables the channel from AHB slave side (indicated by
    //     DestEnQ2 being 0)
    //   o source of the same channel has received an error response.
    `ST_DST_IDLE :
      begin
        // Current state assignment
        NextDstDmacState = `ST_DST_IDLE;

        // REVIEW this 
        if ((DstStart == 1'b1) && (DstStartQ == 1'b0)) 
        // For the start of the transfer, as the Grant is delayed by one clock
        // to the channel, the DstStart will be delayed by one clock, so
        // nullify the effect of this on the number of transfers as treated by
        // channel we are preserving the previous value of the access count.
          NextAxsCntDst    = AxsCntDst;
        else  
          begin
            if (DstBurstOn == 1'b1)
              NextAxsCntDst    = DstDMACL1[4:0];
            else
              NextAxsCntDst    = DstDMACL2[4:0];
          end
        // When the destination-machine is still in IDLE state, if '0' is
        // written into the ChannelEnable bit, the destination is disabled
        // immediately without raising any AbortRequest to AHB Master.
        if ((DMACEn == 1'b1) &&
            (((ChannelEn == 1'b1) && (DestEnQ2 == 1'b0) && (DestEn == 1'b0)) ||
             (SrcErred == 1'b1)) &&
            ( ~((DstStart == 1'b1) && (BusAvlblDst == 1'b1))))
          begin
            DstDisable       = 1'b1;
            NextDstBurstOn   = 1'b0;
            NextBrstCntDst   = {11{1'b0}};
          end

        // When the destination-machine gets the grant along with BusAvlbl, it
        // moves to SELECTED state.
        else if ((DMACEn == 1'b1) && (DestEnQ2 == 1'b1) && (DstStart == 1'b1) &&
                 (DataErrorDst != 1'b1))
          begin
            NextDstDmacState = `ST_DST_SELECTED;
            if (DstBurstOn == 1'b0)
               NextDstBurstOn   = 1'b1;
            // Load the BrstCntDst counter.
            if (BrstCntDst == {11{1'b0}})
              NextBrstCntDst   = BrstCntDstCo;
            else
              NextBrstCntDst   = BrstCntDst;
    
            // Mask off the destination requests.
            SetDstAxsOnMsk   = 1'b1;
          end
      end

    // ST_DST_SELECTED:
    // Transition to ST_DST_ONBUS: When
    // o BusAvlbl is received.
    //
    // Transition to ST_DST_IDLE: When
    // o the AHB returns an error to a data transfer.
    `ST_DST_SELECTED :
      begin
        // Current state assignment
        NextDstDmacState = `ST_DST_SELECTED;
        if (DataErrorDst == 1'b1)
          begin
            // Go to the idle state.
            NextDstDmacState = `ST_DST_IDLE;
            // The destination access is being aborted. The mask is 'unset' so
            // that the destination can come-up again for re-arbitration.
            UnsetDstAxsOnMsk = 1'b1;
            // Since the access is being aborted, the AxsCntDst counter is taken
            // to zero.
            NextAxsCntDst    = 5'b00000;
          end
        else if (BusAvlblDst == 1'b1)
          begin
            NextDstDmacState = `ST_DST_ONBUS;
            // The read pointer has to be incremented
            RdPtrInc         = 1'b1;
          end
      end

    // ST_DST_ONBUS:
    // Transition to ST_DST_DATAXFER: When
    // o BusAvlbl is received.
    //
    // Transition to ST_DST_IDLE: When
    // o the AHB returns an error to a data transfer.
    `ST_DST_ONBUS :
      begin
        // Current state assignment
        NextDstDmacState = `ST_DST_ONBUS;

        if (DataErrorDst == 1'b1)
          begin
            // Go to the idle state.
            NextDstDmacState = `ST_DST_IDLE;
            // The destination access is being aborted. The mask is 'unset' so
            // that the destination can come-up again for re-arbitration.
            UnsetDstAxsOnMsk = 1'b1;
            // Since the access is being aborted, the AxsCntDst counter is taken
            // to zero.
            NextAxsCntDst    = 5'b00000;
          end
        else if (BusAvlblDst == 1'b1)
          begin
            NextDstDmacState = `ST_DST_DATAXFER;
            // The read pointer has to be incremented
            if (AxsCntDst > 5'b00001)
               RdPtrInc         = 1'b1;
            // Decrease the AxsCntDst by 1
            NextAxsCntDst    = (AxsCntDst) - 1'b1;
          end
      end

    // ST_DST_DATAXFER:
    // Transition to ST_DST_IDLE: When
    // o the AHB returns an error to a data transfer.
    // OR
    // o the master interface acknowledges an Abort-request(signalled by
    //   XferAborted). If the software disables the channel, when AHB transfers
    //   are continuing on master side, the channel is not disabled immediately.
    //   Instead, the channel sends an abort-request to the master interface.
    //   The master-interface acknowledges the request, once it reaches the
    //   nearest address boundary.
    // OR
    // o the current destination access on the bus has terminated, although the
    //   destination-burst is still ON.
    //   Note: One packet of destination transfers may constitute of many
    //         Destination bursts (marked by giving clear after servicing each),
    //         which in turn may constitute of many Destination accesses
    //         (limited by FIFO availability).
    // o the current destination access as well as destination-burst has
    //   completed, but the destination being a memory, the state-machine
    //   returns to IDLE instead of doing the request-clear handshake.
    //
    // Transition to ST_DST_DATAXFER: When
    // o destination burst is continuing and BusAvlbl for source is high.
    //
    // Transition to ST_DST_WT4REQLOW: When
    // o current destination-access as well as the destination-burst has
    //   finished, and the destination is a peripheral (not a memory, which does
    //   not require any clear-request handshake).
    `ST_DST_DATAXFER :
      begin
        // Current state assignment
        NextDstDmacState = `ST_DST_DATAXFER;
        if (DataErrorDst == 1'b1)
          begin
            NextDstDmacState = `ST_DST_IDLE;
            // Set the DstErred bit
            DstErr           = 1'b1;
            // Mask both source and destination requests with error-mask,
            // to prevent source and destination from requesting again, till the
            // channel is disabled. During channel-disable, the error-mask will
            // be unset.
            SetErrMskDst     = 1'b1;
            NextDstBurstOn   = 1'b0;
            UnsetDstAxsOnMsk = 1'b1;
            // De-assert the AbortReqDst signal in case the machine was also
            // waiting for an abort-acknowledge(AbortedXfer).
            NextAbortReqDst  = 1'b0;
            // Reset the AxsCntDst
            NextAxsCntDst    = 5'b00000;
            NextBrstCntDst   = {11{1'b0}};
          end
        else if ((BusAvlblDst & XferAbortedDst) == 1'b1)
          begin
            NextDstDmacState = `ST_DST_IDLE;
            // Set the DisabledDst bit
            DstDisable       = 1'b1;
            // De-assert the abort request
            NextAbortReqDst  = 1'b0;
            // The burst is getting aborted and hence the DstAxsOn mask is
            // unset.
            NextDstBurstOn   = 1'b0;
            UnsetDstAxsOnMsk = 1'b1;
            // Decrease the transfer size by 1
            DecTrfSizeDst    = 1'b1;
            // Reset the counters to zero.
            NextBrstCntDst   = {11{1'b0}};
            NextAxsCntDst    = 5'b00000;
          end
        else if ((BusAvlblDst == 1'b1) &&
                 (((AxsCntDst == 5'b00000) &&
                   (BrstCntDst > {{10{1'b0}}, 1'b1})) ||
                  ((AxsCntDst == 5'b00000) &&
                   (BrstCntDst == {{10{1'b0}}, 1'b1}) &&
                    IsDstMemory(FlowCntl))))
          begin
            NextDstDmacState = `ST_DST_IDLE;
            // Unset the access on mask.
            UnsetDstAxsOnMsk = 1'b1;
            // Decrease burstcount of source by 1
            NextBrstCntDst   = BrstCntDst - 1'b1;
            // Decrease transfersize by 1. In case of non-DMAC controlled flow
            // also Transfersize is decremented, though except DMAC-flowcontrol
            // case, Transfersize is redundant.
            DecTrfSizeDst    = 1'b1;
            // When the DMA-burst has finished the machine does not go to
            // WT4REQLOW state, as the destination is a memory. The state
            // machine directly goes to IDLE state.
            if ((BrstCntDst == {{10{1'b0}}, 1'b1}) && IsDstMemory(FlowCntl))
              begin
                // The ongoing DMA burst finishes.
                NextDstBurstOn   = 1'b0;
                // When DMAC is the flow controller.
                if (IsDMAFlowCntl(FlowCntl[2:1]))
                  begin
                    // When end-of-packet has been reached
                    if (TrfSizeDst == {{13{1'b0}}, 1'b1})
                    begin
                      // The destination-address register should not be updated
                      // with the next address value.
                      DstAddrUpdate    = 1'b0;
                      // assert TC interrupt if Int TC Enable in DmacChControl
                      // register is high.
                      if (IntTCEnable == 1'b1)
                        SetIntTC         = 1'b1;
                      // A non-zero LLI address value indicates that LLI is to
                      // be loaded. If there has been an error, or disable of
                      // source, then the LLI loading should not be proceeded
                      // with.
                      if (LLIAddressUB != {30{1'b0}})
                        begin
                          if ((SrcErred != 1'b1) && (DisabledSrc != 1'b1))
                          begin
                            // Assert the request for LLI loading.
                            SetLLIReq        = 1'b1;
                            // This mask is reset by LLI-Load-state machine.
                            SetLLILoadMsk    = 1'b1;
                          end
                        end
                      // when the LLIAddress is 'null'
                      else
                        DstDisable       = 1'b1;
                    end
                    // When end-of-packet has NOT been reached.
                    else
                      DstAddrUpdate    = 1'b1;
                  end
                // When Source is the flow controller.
                // The destination-flow-control mode is not separately
                // considered as a destination memory can not be in destination
                // controlled flow.
                else
                  begin
                    // When source has signalled end-of-packet.
                    if ((SrcTCDone == 1'b1) && (FifoFillLevel == {5{1'b0}}))
                      begin
                        // assert TC interrupt if Int TC Enable in DmacChControl
                        // register is high.
                        if (IntTCEnable == 1'b1)
                          SetIntTC         = 1'b1;
                        // The TC is being given with the help of SrcTCDone
                        // flag. The SrcTCDone flag should be de-asserted now.
                        UnsetSrcTCDone   = 1'b1;
                        // The advanced address given by Master Interface should
                        // not be registered.
                        DstAddrUpdate    = 1'b0;
                        // A non-zero LLI address value indicates that LLI is to
                        // be loaded. If there has been an error, or disable of
                        // source, then the LLI loading should not be proceeded
                        // with.
                        if (LLIAddressUB != {30{1'b0}})
                          begin
                            if ((SrcErred != 1'b1) && (DisabledSrc != 1'b1))
                            begin
                              // Assert the request for LLI loading.
                              SetLLIReq        = 1'b1;
                              // This mask is reset by LLI-Load-state machine.
                              SetLLILoadMsk    = 1'b1;
                            end
                          // when the next LLI address is null.
                          end
                        else
                          DstDisable       = 1'b1;
                      end
                    // Source has not signalled end-of-packet yet.
                    else
                      // The advanced address given by Master Interface should 
                      // be registered. As the Channel is supposed to provide 
                      // the next address to master.
                      DstAddrUpdate    = 1'b1;
                  end
              end
            // When the BrstCntDst has not downcounted to 1, then the DMA-burst
            // is not finished. Only the 'access' has finished.
            else
              // Update the destination address register
              DstAddrUpdate    = 1'b1;
          end
        else if ((BusAvlblDst == 1'b1) && (AxsCntDst == 5'b00000) &&
                 (BrstCntDst == {{10{1'b0}}, 1'b1}) && ~(IsDstMemory(FlowCntl)))
          begin
            NextDstDmacState = `ST_DST_WT4REQLOW;
    
            // Assert the DMA clear signal
            NextDMACClrDst   = 1'b1;
            // Decrement the BurstCntDst by 1.
            NextBrstCntDst   = BrstCntDst - 1'b1;
            // Decrease transfersize by 1. In case of non-DMAC controlled flow
            // also Transfersize is decremented, though except DMAC-flowcontrol
            // case, Transfersize is redundant.
            DecTrfSizeDst    = 1'b1;
            if (IsDMAFlowCntl(FlowCntl[2:1]))
              begin
                if (TrfSizeDst == ({{13{1'b0}}, 1'b1}))
                begin
                  // Since end of packet, the advanced-address given by master
                  // should not be sampled.
                  DstAddrUpdate    = 1'b0;
                  // assert TC interrupt if Int TC Enable in DmacChControl
                  // register is high.
                  if (IntTCEnable == 1'b1)
                    SetIntTC         = 1'b1;
                  // Assert the DMAC TC.
                  NextDMACTCDst    = 1'b1;
                  // A non-zero LLI address value indicates that LLI is to be
                  // loaded. If there has been an error, or disable of source,
                  // then the LLI loading should not be proceeded with.
                  if (LLIAddressUB != {30{1'b0}})
                    begin
                      if ((SrcErred != 1'b1) && (DisabledSrc != 1'b1))
                        begin
                          // Assert the request for LLI loading.
                          SetLLIReq        = 1'b1;
                          // This mask is reset by LLI-Load-state machine.
                          SetLLILoadMsk    = 1'b1;
                        end
                    end
                  // When the next LLI address is 'null'
                  else
                    DstDisable       = 1'b1;
                end

                // packet continues
                else
                  // The advanced address given by Master Interface should be
                  // registered. As the Channel is supposed to provide the next
                  // address to master.
                  DstAddrUpdate    = 1'b1;
              end
            else if (IsSrcFlowCntl(FlowCntl[2:1]))
              begin
                if ((SrcTCDone == 1'b1) && (FifoFillLevel == 5'b00000))
                  begin
                    // assert TC interrupt if Int TC Enable in DmacChControl
                    // register is high.
                    if (IntTCEnable == 1'b1)
                      SetIntTC         = 1'b1;
                    // The TC line is asserted with the end of last data
                    // transfer.
                    NextDMACTCDst    = 1'b1;
                    // The TC is being given with the help of SrcTCDone flag.
                    // The SrcTCDone flag should be de-asserted now.
                    UnsetSrcTCDone   = 1'b1;
                    // Since end of packet, the advanced-address given by master
                    // should not be sampled.
                    DstAddrUpdate    = 1'b0;
                    // A non-zero LLI address value indicates that LLI is to be
                    // loaded. If there has been an error, or disable of source,
                    // then the LLI loading should not be proceeded with.
                    if (LLIAddressUB != {30{1'b0}})
                      begin
                        if ((SrcErred != 1'b1) && (DisabledSrc != 1'b1))
                        begin
                          // Assert the request for LLI loading.
                           SetLLIReq        = 1'b1;
                          // This mask is reset by LLI-Load-state machine.
                           SetLLILoadMsk    = 1'b1;
                        end
                      end
                    // When next LLI address is 'null'
                    else
                      DstDisable       = 1'b1;
                  end
                // packet continues
                else
                  // The advanced address given by Master Interface should be
                  // registered. As the Channel is supposed to provide the next
                  // address to master.
                  DstAddrUpdate    = 1'b1;
              end
            // When in destination-flow-control mode.
            else
              begin
                // End of packet
                if ((ChDstLBReq | ChDstLSReq) == 1'b1)
                  begin
                    // assert TC interrupt if Int TC Enable in DmacChControl
                    // register is high.
                    if (IntTCEnable == 1'b1)
                      SetIntTC         = 1'b1;
                    // Assert the TC line
                    NextDMACTCDst    = 1'b1;
                    // Since end of packet, the advanced-address given by
                    // master should not be sampled.
                    DstAddrUpdate    = 1'b0;
                    // A non-zero LLI address value indicates that LLI is to be
                    // loaded. If there has been an error, or disable of
                    // source, then the LLI loading should not be proceeded
                    // with.
                    if (LLIAddressUB != {30{1'b0}})
                      begin
                        if ((SrcErred != 1'b1) && (DisabledSrc != 1'b1))
                          begin
                            // Assert the request for LLI loading.
                            SetLLIReq        = 1'b1;
                            // This mask is reset by LLI-Load-state machine.
                            SetLLILoadMsk    = 1'b1;
                          end
                      end
                    // When next LLI address is 'null'
                    else
                      DstDisable       = 1'b1;
                  end
                // packet continues
                else
                  // The advanced address given by Master Interface should be
                  // registered as the Channel is supposed to provide the next
                  // address to master.
                  DstAddrUpdate    = 1'b1;
              end
          end
        else if ((BusAvlblDst == 1'b1) && (AxsCntDst != 5'b00000))
          begin
            NextDstDmacState = `ST_DST_DATAXFER;
            // The read pointer has to be incremented if AxsCntDst is greater
            // than 1. This is because one extra datum has already been
            // prefetched when moving from SELECTED to ONBUS state.
            if (AxsCntDst > 5'b00001)
              RdPtrInc         = 1'b1;
            // Decrease the AxsCntDst by 1
            NextAxsCntDst    = (AxsCntDst) - 1'b1;
            // Decrease BrstCntDst by 1
            NextBrstCntDst   = (BrstCntDst) - 1'b1;
            // Update the destination-address-register with MasterAddress
            DstAddrUpdate    = 1'b1;
            // Decrease the transfer size by 1
            DecTrfSizeDst    = 1'b1;
            // If DestEnQ2 goes to zero, indicating that AHB Slave has attempted
            // to disable the channel, AbortReq signal is sent to the Master
            // Interface. It is redundant to raise AbortReq when AxsCntDst is
            // less than or equal to 3. By the time Master Interface gives
            // abort-acknowledge, the transfers would have been finished in
            // normal course. Once AbortReq is set, it is reset if the
            // acknowledge comes from the Master or the AxsCntSrc falls below 3.
            if ((DestEnQ2 == 1'b0) && (AxsCntDst > 5'b00011))
              NextAbortReqDst  = 1'b1;
            else
              NextAbortReqDst  = 1'b0;
          end
      end

    // ST_DST_WT4REQLOW
    // Transition to ST_DST_IDLE: When
    // o the transfer request is pulled low by the peripheral.
    `ST_DST_WT4REQLOW :
      begin

        // Current state assignment
        NextDstDmacState = `ST_DST_WT4REQLOW;
  
        if ((ChDstBReq | ChDstLBReq | ChDstSReq | ChDstLSReq) == 1'b0)
        begin
          NextDstDmacState = `ST_DST_IDLE;
          // The access count for destination is reset.
          NextAxsCntDst    = 5'b00000;
          // De-assert the DMA clear signal
          NextDMACClrDst   = 1'b0;
          // De-assert the DMA TC signal
          NextDMACTCDst    = 1'b0;
          // The destination access is over. The request can come again for
          // re-arbitration
          UnsetDstAxsOnMsk = 1'b1;
          // The destination burst ends.
          NextDstBurstOn   = 1'b0;
          NextBrstCntDst   = {11{1'b0}};
        end
      end

    default : NextDstDmacState = `ST_DST_IDLE;
  endcase
end // p_DstDMACComb

// -----------------------------------------------------------------------------
// Sequential process for p_DstDMACComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DstDMACSeq
  if (HRESETn == 1'b0)
    begin
      AxsCntDst        <= {5{1'b0}};
      DstDmacState     <= `ST_DST_IDLE;
      DMACClrDst       <= 1'b0;
      DMACTCDst        <= 1'b0;
      DstBurstOn       <= 1'b0;
      AbortReqDst      <= 1'b0;
      BrstCntDst       <= {11{1'b0}};
      DstStartQ        <= 1'b0;
    end
  else
    begin
      AxsCntDst        <= NextAxsCntDst;
      DstDmacState     <= NextDstDmacState;
      DMACClrDst       <= NextDMACClrDst;
      DMACTCDst        <= NextDMACTCDst;
      DstBurstOn       <= NextDstBurstOn;
      AbortReqDst      <= NextAbortReqDst;
      BrstCntDst       <= NextBrstCntDst;
      DstStartQ        <= DstStart;
    end
end // p_DstDMACSeq

// -----------------------------------------------------------------------------
// The number of transfers to be done on AHB in one access.
// -----------------------------------------------------------------------------
assign DstNumOfXfers    = NextAxsCntDst;

// -----------------------------------------------------------------------------
// When the destination-access-count is 2, it indicates that one more data from
// the channel FIFO is to be read out and hence the addition factor of 1.
// -----------------------------------------------------------------------------
always @(SrcSelect or DstSelect or DWidth2LSB or AxsCntDst or DstDmacState)
begin : p_DstFactorComb
  DstFactor        = 3'b000;
// holelee  if ((SrcSelect == DstSelect) && (AxsCntDst == 5'b00010) && 
  if ((AxsCntDst == 5'b00010) && 
      (DstDmacState[0] != 1'b1))
  begin
    case (DWidth2LSB)
      2'b00 : DstFactor        = 3'b001;
      2'b01 : DstFactor        = 3'b010;
      2'b10 : DstFactor        = 3'b100;
      default : DstFactor        = 3'b000;
    endcase
  end
end // p_DstFactorComb

// -----------------------------------------------------------------------------
// When the second cycle of error response is going on, the DataErrorDst signal
// can be combinationally resolved to mask the source transfer, which might be
// starting on other bus.
// -----------------------------------------------------------------------------
assign ErrCycMaskDst    = (DstDmacState == `ST_DST_DATAXFER) ? DataErrorDst :
                           1'b0;

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
