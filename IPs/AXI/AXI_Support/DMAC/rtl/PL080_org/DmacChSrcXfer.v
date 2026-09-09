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
// File Name              : DmacChSrcXfer.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block handles the Source to DMAC data transfer.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacChSrcXfer (
// Inputs
                      // AHB signals
                      HCLK,
                      HRESETn,
                      // From AHB Slave interface (DmacAhbSlaveIf)
                      DMACEn,
                      // From Master Interface (DmacAhbMaster)
                      BusAvlblM1,
                      BusAvlblM2,
                      DataErrorM1,
                      DataErrorM2,
                      XferAbortedM1,
                      XferAbortedM2,
                      // From DmacChReqProc block
                      SrcStart,
                      // From DmacChRegBlock
                      FlowCntl,
                      TrfSizeSrc,
                      SBSize,
                      SWidth,
                      DWidth,
                      SrcSelect,
                      DstSelect,
                      SourceEn,
                      LLIAddressUB,
                      ChannelEn,
                      DstErred,
                      // From DmacChReqProc block
                      ChSrcBReq,
                      ChSrcSReq,
                      ChSrcLBReq,
                      ChSrcLSReq,
                      ChDstLBReq,
                      ChDstLSReq,
                      // From DmacChPckUnpck block
                      FifoEmptyLevel,

// Outputs
                      // To DmacChReqMask block
                      SetSrcAxsOnMsk,
                      UnsetSrcAxsOnMsk,
                      SetSrcE2LMsk,
                      SetErrMskSrc,
                      ErrCycMaskSrc,
                      // To DmacChReqProc block
                      AbortReqSrcM1,
                      AbortReqSrcM2,
                      DMACTCSrc,
                      DMACClrSrc,
                      SrcNumOfXfers,
                      // To DmacChRegBlock
                      DecTrfSizeSrc,
                      SrcAddrUpdate,
                      SrcDisable,
                      SrcErr,
                      SrcDmacState,
                      // To DmacChDstXfer block
                      SetSrcTCDone,
                      // To DmacChPckUnpck block
                      SrcFactor,
                      FifoWrEn
                     );

// Inputs
// AHB signals
input         HCLK;             // Bus Clock
input         HRESETn;          // Module Reset
// From AHB Slave interface (DmacAhbSlaveIf)
input         DMACEn;           // DMAC Enable
// From Master Interface (DmacAhbMaster)
input         BusAvlblM1;       // Bus available on AHB1
input         BusAvlblM2;       // Bus available on AHB2
input         DataErrorM1;      // Data error on AHB1
input         DataErrorM2;      // Data error on AHB2
input         XferAbortedM1;    // Transfer aborted signal from AHB1
input         XferAbortedM2;    // Transfer aborted signal from AHB2
// From DmacChReqProc block
input         SrcStart;         // Source transfers can start
// From DmacChRegBlock
input   [2:0] FlowCntl;         // Flow control information
input  [11:0] TrfSizeSrc;       // Indicates number of source transfers to
                                // perform
input   [2:0] SBSize;           // Source Burst Size
input   [2:0] SWidth;           // Source width
input   [2:0] DWidth;           // Destination width
input         SrcSelect;        // Source AHB Master select
input         DstSelect;        // Destination AHB Master select
input         SourceEn;         // Source enabled
input  [31:2] LLIAddressUB;     // Address of next LLI
input         ChannelEn;        // Indicates whether channel is enabled
input         DstErred;         // Bit indicating an error during destination
                                // transfer
// From DmacChReqProc block
input         ChSrcBReq;        // Source Burst Request for the channel
input         ChSrcSReq;        // Source Single Request for the channel
input         ChSrcLBReq;       // Source Last Burst Request for the channel
input         ChSrcLSReq;       // Source Last Single Request for the channel
input         ChDstLBReq;       // Destination Last Burst Request for the
                                // channel
input         ChDstLSReq;       // Destination Last Single Request for the
                                // channel
// From DmacChPckUnpck block
input   [4:0] FifoEmptyLevel;   // Number of space empty in FIFO in terms of
                                // Source Width

// Outputs
// To DmacChReqMask block
output        SetSrcAxsOnMsk;   // Sets the access-on mask
output        UnsetSrcAxsOnMsk; // Resets the access-on mask
output        SetSrcE2LMsk;     // Sets a mask on source request from
                                // source-end to actual disable
output        SetErrMskSrc;     // Sets a mask on source and dest when there
                                // is an error during source transfers
output        ErrCycMaskSrc;    // Masks the channel requests during second
                                // cycle of the AHB error response
// To DmacChReqProc block
output        AbortReqSrcM1;    // Source Abort request for Master1
output        AbortReqSrcM2;    // Source Abort request for Master2
output        DMACTCSrc;        // TC signal for the source request
output        DMACClrSrc;       // Clear signal for source request
output  [4:0] SrcNumOfXfers;    // Number of source transfers to be done in an
                                // AHB access on AHB1
// To DmacChRegBlock
output        DecTrfSizeSrc;    // Decrease the source-transfer count by 1
output        SrcAddrUpdate;    // When high, the MasterAddress is clocked in
                                // source-address register
output        SrcDisable;       // Source disable
output        SrcErr;           // Source error
output  [4:0] SrcDmacState;     // Source Transfer Logic state
// To DmacChDstXfer block
output        SetSrcTCDone;     // Indicates that source-TC has been asserted
                                // in source-flow-control
// To DmacChPckUnpck block
output  [3:0] SrcFactor;        // The additional factor to FifoFill level for
                                // dest-burst-optimization
output        FifoWrEn;         // Write enable to data buffer

// Inputs
// AHB signals
wire          HCLK;             // Bus Clock
wire          HRESETn;          // Module Reset
// From AHB Slave interface (DmacAhbSlaveIf)
wire          DMACEn;           // DMAC Enable
// From Master Interface (DmacAhbMaster)
wire          BusAvlblM1;       // Bus available on AHB1
wire          BusAvlblM2;       // Bus available on AHB2
wire          DataErrorM1;      // Data error on AHB1
wire          DataErrorM2;      // Data error on AHB2
wire          XferAbortedM1;    // Transfer aborted signal from AHB1
wire          XferAbortedM2;    // Transfer aborted signal from AHB2
// From DmacChReqProc block
wire          SrcStart;         // Source transfers can start
// From DmacChRegBlock
wire  [2:0]   FlowCntl;         // Flow control information
wire [11:0]   TrfSizeSrc;       // Indicates number of source transfers to
                                // perform
wire    [2:0] SBSize;           // Source Burst Size
wire    [2:0] SWidth;           // Source width
wire    [2:0] DWidth;           // Destination width
wire          SrcSelect;        // Source AHB Master select
wire          DstSelect;        // Destination AHB Master select
wire          SourceEn;         // Source enabled
wire   [31:2] LLIAddressUB;     // Address of next LLI
wire          ChannelEn;        // Indicates whether channel is enabled
wire          DstErred;         // Bit indicating an error during destination
                                // transfer
// From DmacChReqProc block
wire          ChSrcBReq;        // Source Burst Request for the channel
wire          ChSrcSReq;        // Source Single Request for the channel
wire          ChSrcLBReq;       // Source Last Burst Request for the channel
wire          ChSrcLSReq;       // Source Last Single Request for the channel
wire          ChDstLBReq;       // Destination Last Burst Request for the
                                // channel
wire          ChDstLSReq;       // Destination Last Single Request for the
                                // channel
// From DmacChPckUnpck block
wire    [4:0] FifoEmptyLevel;   // Number of space empty in FIFO in terms of
                                // Source Width

// Outputs
// To DmacChReqMask block
reg           SetSrcAxsOnMsk;   // Sets the access-on mask
reg           UnsetSrcAxsOnMsk; // Resets the access-on mask
reg           SetSrcE2LMsk;     // Sets a mask on source request from
                                // source-end to actual disable
reg           SetErrMskSrc;     // Sets a mask on source and dest when there
                                // is an error during source transfers
wire          ErrCycMaskSrc;    // Masks the channel requests during second
                                // cycle of the AHB error response
// To DmacChReqProc block
wire          AbortReqSrcM1;    // Source Abort request for Master1
wire          AbortReqSrcM2;    // Source Abort request for Master2
reg           DMACTCSrc;        // TC signal for the source request
reg           DMACClrSrc;       // Clear signal for source request
wire    [4:0] SrcNumOfXfers;    // Number of source transfers to be done in an
                                // AHB access on AHB1
// To DmacChRegBlock
reg           DecTrfSizeSrc;    // Decrease the source-transfer count by 1
reg           SrcAddrUpdate;    // When high, the MasterAddress is clocked in
                                // source-address register
reg           SrcDisable;       // Source disable
reg           SrcErr;           // Source error
reg     [4:0] SrcDmacState;     // Source Transfer Logic state
// To DmacChDstXfer block
reg           SetSrcTCDone;     // Indicates that source-TC has been asserted
                                // in source-flow-control
// To DmacChPckUnpck block
reg     [3:0] SrcFactor;        // The additional factor to FifoFill level for
                                // dest-burst-optimization
reg           FifoWrEn;         // Write enable to data buffer

// -----------------------------------------------------------------------------
//
//                                DmacChSrcXfer
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// The main functionality described in this file is the Source-DMAC-Flow state
// machine. The other functions that the file performs are:
// o The two master interfaces return one BusAvlblM(1/2), DataErrorM(1/2) and
//   one XferAbortedM(1/2) each. Depending on SrcSelect, one of the two is
//   muxed to the Source-DMAC-Flow state machine.
// o If Source-DMAC-Flow state machine raises a transfer-abort-request
//   (AbortReqSrc), then it is de-multiplexed to one of the two Master
//   Interfaces depending on SrcSelect.
// o In case of both source and destination being on the same bus, a factor
//   called SrcFactor is generated. This factor is added to the actual FIFO fill
//   level to show a higher fill-level to destination-transfer-block. This
//   enables the destination-transfer-block to initiate a transfer of
//   greater-burst-length. This does not lead to data corruption, as the
//   pipeline nature of the bus ensures that by the time the destination data
//   needs to be driven out on the bus, the FIFO would have been filled to the
//   requisite level by source.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        BusAvlblSrc;
// Bus-available signal for source state machine

wire        DataErrorSrc;
// Data-error signal for source state machine

wire        XferAbortedSrc;
// One of the XferAbortedM1 and XferAbortedM2 signal; selected according to
// SrcSelect field

wire  [2:0] AxsCntSrc3LSB;
// Three lower significant bits of AxsCntSrc

wire [11:0] BstNoL;
// The minimum of the transfer size and source burst size

wire [10:0] SrcDMACK;
// Indicating that the source 

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [10:0] BrstCntSrcCo;
// Used for loading burst-counter and AxsCount in Source-DMAC state machine

reg   [4:0] AxsCntSrc;
// Denotes the number of accesses remaining to be done on AHB

reg   [4:0] NextAxsCntSrc;
// D-input for AxsCntSrc

reg   [4:0] NextSrcDmacState;
// Next-state-signal for source-DMAC state machine

reg         NextDMACClrSrc;
// D-input of DMACClrSrc

reg         NextDMACTCSrc;
// D-input of DMACTCSrc

reg         SrcBurstOn;
// Indicates destination that the source DMA burst is continuing

reg         NextSrcBurstOn;
// D-input for SrcBurstOn, indicating that a DMA burst is still going on

reg  [10:0] BrstCntSrc;
// Counter indicating the number of beats left in DMA source burst

reg  [10:0] NextBrstCntSrc;
// D-input of BrstCntSrc

reg   [2:0] Pr1AxsCntSrc;
// The previous value of AxsCntSrc counter; required for generating SrcFactor

reg   [2:0] Pr2AxsCntSrc;
// The previous to previous value of AxsCntSrc counter; required for generating
// SrcFactor

reg   [2:0] NextPr1AxsCntSrc;
// D-input of Pr1AxsCntSrc

reg   [2:0] NextPr2AxsCntSrc;
// D-input of Pr2AxsCntSrc

reg         AbortReqSrc;
// Requesting transfer-abort to master

reg         NextAbortReqSrc;
// D-input for requesting transfer-abort to master

reg   [1:0] MultipSrcFactor;
// The 2-bit value, which is multiplied with Source-Width to get SrcFactor

reg         SrcStartQ;
// One clock delayed version of SrcStart

reg         SourceEnQ2;
// One clock delayed version of SourceEn

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
// This block identifies the relevant BusAvlblSrc for the source-state machine
// from the two BusAvlbl signals (BusAvlblM1 and BusAvlblM2)
// -----------------------------------------------------------------------------
assign BusAvlblSrc      = (SrcSelect == 1'b0) ? BusAvlblM1           :
                           BusAvlblM2;

// -----------------------------------------------------------------------------
// This block identifies the relevant DataErrorSrc for the source-state machine
// from the two DataError signals (DataErrorM1 and DataErrorM2).
// -----------------------------------------------------------------------------
assign DataErrorSrc     = (SrcSelect == 1'b0) ? DataErrorM1          :
                           DataErrorM2;

// -----------------------------------------------------------------------------
// This block identifies the relevant XferAbortedSrc for the source-state
// machine from the two XferAborted signals (XferAbortedM1 and XferAbortedM2).
// -----------------------------------------------------------------------------
assign XferAbortedSrc   = (SrcSelect == 1'b0) ? XferAbortedM1        :
                           XferAbortedM2;

// -----------------------------------------------------------------------------
// The following block, routes the AHB-transfer-abort-request to the targeted
// AHB port via DMACChReqProc, where the Source-abort-request and destination-
// abort requests are ORed.
// -----------------------------------------------------------------------------
assign AbortReqSrcM1    = ~(SrcSelect) & AbortReqSrc;
assign AbortReqSrcM2    = SrcSelect & AbortReqSrc;

// -----------------------------------------------------------------------------
// The minimum of the transfer size and source burst size is required for
// generating BrstCntSrcCo value
// -----------------------------------------------------------------------------
assign BstNoL           = Minimum12(TrfSizeSrc, {3'b000, DecodeBSize(SBSize)});

// -----------------------------------------------------------------------------
// The following block generates the BrstCntSrcCo value, which is used by the
// source-DMAC state machine to load the burst counter and AxsCnt, when moving
// from ST_SRC_IDLE to ST_SRC_SELECTED.
// -----------------------------------------------------------------------------
always @(FlowCntl or SBSize or ChSrcBReq or ChSrcSReq or ChSrcLBReq or
         ChSrcLSReq or BstNoL)
begin : p_BstNoGenSrComb
  // Default assignments
  BrstCntSrcCo     = {11{1'b0}};

  // When DMAC or Destination-peripheral is the flow-controller
  if (IsDMAFlowCntl(FlowCntl[2:1]) | IsDstFlowCntl(FlowCntl[2:1]))
    begin
      // when source is memory
      if (IsSrcMemory(FlowCntl))
        begin
          BrstCntSrcCo   = BstNoL[10:0];
        end
      // when source is a peripheral
      else
        begin
          // When BREQ is high, the burst counter is loaded with DBSize number
          // of transfers. If both Burst and Single requests are high, then
          // Burst request should be given preference over Single request.
          if (ChSrcBReq == 1'b1)
            begin
              BrstCntSrcCo = BstNoL[10:0];
            end
          else if (ChSrcSReq == 1'b1)
            BrstCntSrcCo     = 11'b00000000001;
          // Default condition
          else
            begin
              BrstCntSrcCo     = BstNoL[10:0];
            end
        end
    end
  // when source is the flow-controller
  else if (IsSrcFlowCntl(FlowCntl[2:1]))
    begin
      // When BREQ/LBREQ is high, the burst counter is loaded with DBSize number
      // of transfers. If both Burst and Single requests are high, then Burst
      // request should be given preference over Single request.
      if ((ChSrcBReq | ChSrcLBReq) == 1'b1)
         BrstCntSrcCo     = {2'b00, DecodeBSize(SBSize)};
      // when there is Single-Request
      else if ((ChSrcSReq | ChSrcLSReq) == 1'b1)
         BrstCntSrcCo     = 11'b00000000001;
      // Default condition
      else
      begin
         BrstCntSrcCo     = {2'b00, DecodeBSize(SBSize)};
      end
    end
end // p_BstNoGenSrComb : 

// -----------------------------------------------------------------------------
// SourceEnQ2 is used by the statemachine to control its abort related
// functions. Since the grant comes one clock after the request, SourceEnQ2
// is used in place of SourceEn. If the channel raises a request to the
// arbiter and on the very next clock the SourceEn goes low, then the source
// statemachine still should proceed as at the time of raising the request,
// SourceEn was high.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SrcEnDlySeq
  if (HRESETn == 1'b0)
    begin
      SourceEnQ2       <= 1'b0;
    end
  else
    begin
      SourceEnQ2       <= SourceEn;
    end
end // p_SrcEnDlySeq

// -----------------------------------------------------------------------------
// The number of actual transfers to be done for the current request is minimum
// of the fifo empty level and the total number of transfers which can be done
// as seen from the source burst size and the total number of transfers to be
// done in a DMA cycle.
// o When SrcBurstOn is high, the internal counter value of BurstCount
//   should be used.
// -----------------------------------------------------------------------------
assign SrcDMACK         = (SrcBurstOn == 1'b0) ?
                          Minimum11({{6{1'b0}}, FifoEmptyLevel}, BrstCntSrcCo) :
                          Minimum11({{6{1'b0}}, FifoEmptyLevel}, BrstCntSrc);

// -----------------------------------------------------------------------------
// The following block describes the Source-DMAC data flow state machine. There
// are 5 states in the state machine.
// ST_SRC_IDLE
// ST_SRC_SELECTED
// ST_SRC_ONBUS
// ST_SRC_DATAXFER
// ST_SRC_WT4REQLOW
// In the following portion, the trigger for transition from each state is
// described.
//
// ST_SRC_IDLE:
//   Transition to ST_SRC_SELECTED: When
//   o the internal arbiter has granted the channel-source machine (indicated by
//     SrcStart). The internal arbiter grants the channel, and the DmacChReqProc
//     block resolves the Channel-grant to SrcStart, DstStart or LLIStart.
//   o the DMAC and the channel is enabled and
//   o the AHB is not returning an error response
//
//   Transition to same state: When
//   o software disables the channel from AHB slave side (indicated by SourceEn
//     (Q2) being 0)
//   o destination of the same channel has received an error response.
//
// ST_SRC_SELECTED:
//   Transition to ST_SRC_ONBUS: When
//   o BusAvlbl is received.
//
//   Transition to ST_SRC_IDLE: When
//   o the AHB returns an error to a data transfer.
//
// ST_SRC_ONBUS:
//   Transition to ST_SRC_DATAXFER: When
//   o BusAvlbl is received.
//
//   Transition to ST_SRC_IDLE: When
//   o the AHB returns an error to a data transfer.
//
// ST_SRC_DATAXFER:
//   Transition to ST_SRC_IDLE: When
//   o the AHB returns an error to a data transfer.
//   OR
//   o the master interface acknowledges an Abort-request(signalled by
//     XferAborted). If the software disables the channel, when AHB transfers
//     are continuing on master side, the channel is not disabled immediately.
//     Instead, the channel sends an abort-request to the master interface. The
//     master-interface acknowledges the request, once it reaches the nearest
//     address boundary.
//   OR
//   o the current source access on the bus has terminated, although the
//     source-burst is still ON.
//     Note: One packet of source transfers may constitute of many
//           Source bursts (marked by giving clear after servicing each), which
//           in turn may constitute of many Source accesses (limited by FIFO
//           availability).
//   o the current source access as well as source-burst has completed, but the
//     source being a memory, the state-machine returns to IDLE instead of doing
//     the request-clear handshake.
//
//   Transition to ST_SRC_DATAXFER: When
//   o source burst is continuing and BusAvlbl for source is high.
//
//   Transition to ST_SRC_WT4REQLOW: When
//   o current source-access as well as the source-burst has finished, and the
//     source is a peripheral (not a memory, which does not require any
//     clear-request handshake).
//
// ST_SRC_WT4REQLOW
//   Transition to ST_SRC_IDLE: When
//   o the transfer request is pulled low by the peripheral.
// -----------------------------------------------------------------------------
always @(DMACEn or SourceEnQ2 or SourceEn or SrcStart or BusAvlblSrc or
         SrcDmacState or SrcBurstOn or BrstCntSrcCo or BrstCntSrc or
         FlowCntl or ChSrcLBReq or ChSrcLSReq or ChSrcBReq or ChSrcSReq or
         ChDstLBReq or ChDstLSReq or AbortReqSrc or DMACClrSrc or DMACTCSrc or
         Pr1AxsCntSrc or Pr2AxsCntSrc or AxsCntSrc or DataErrorSrc or
         XferAbortedSrc or TrfSizeSrc or LLIAddressUB or DstErred or 
         ChannelEn or SrcDMACK or SrcStartQ)
begin : p_SrcDMACComb
  // Default assignments.
  // Clear and TC signals
  NextDMACClrSrc   = DMACClrSrc;
  NextDMACTCSrc    = DMACTCSrc;
  // Signals to register block.
  DecTrfSizeSrc    = 1'b0;
  SrcErr           = 1'b0;
  SrcDisable       = 1'b0;
  SrcAddrUpdate    = 1'b0;
  // Mask signals to DmacChReqProc block.
  SetSrcAxsOnMsk   = 1'b0;
  UnsetSrcAxsOnMsk = 1'b0;
  SetErrMskSrc     = 1'b0;
  SetSrcE2LMsk     = 1'b0;
  // Signals to be internally used within source state-machine.
  NextSrcBurstOn   = SrcBurstOn;
  NextBrstCntSrc   = BrstCntSrc;
  NextAxsCntSrc    = AxsCntSrc;
  NextPr1AxsCntSrc = Pr1AxsCntSrc;
  NextPr2AxsCntSrc = Pr2AxsCntSrc;
  // Writing into the channel FIFO.
  FifoWrEn         = 1'b0;
  // To the destination state-machine.
  SetSrcTCDone     = 1'b0;
  // To the Master-interface, via DmacChReqProc
  NextAbortReqSrc  = AbortReqSrc;

  case (SrcDmacState)
    // ST_SRC_IDLE:
    // Transition to ST_SRC_SELECTED: When
    // o the internal arbiter has granted the channel-source machine
    //   (indicated by SrcStart). The internal arbiter grants the channel, and
    //   the DmacChReqProc block resolves the Channel-grant to SrcStart,
    //   DstStart or LLIStart.
    // o the DMAC and the channel is enabled and
    // o the AHB is not returning an error response
    //
    // Transition to same state: When
    // o software disables the channel from AHB slave side (indicated by
    //   SourceEnQ2 being 0)
    // o destination of the same channel has received an error response.
    `ST_SRC_IDLE :
      begin
        // Current state assignment
        NextSrcDmacState = `ST_SRC_IDLE;
  
        // This is start of access. So the 'history' of AxsCntSrc is cleared
        // with the following assignment.
        NextPr1AxsCntSrc = 3'b000;
        NextPr2AxsCntSrc = 3'b000;
  
        // Load AccessCount with min(FifoEmptylevel, SBSize) if SrcBurstOn =
        // '0'. Else it indicates that, more AHB accesses are required to finish
        // the ongoing DMABurst and AccessCount is loaded w.r.t BurstCount.
        // When SrcBurstOn is high, the internal counter value of BurstCount
        // should be used.

        // REVIEW this
        if ((SrcStart == 1'b1) && (SrcStartQ == 1'b0))
        // For the start of the transfer, as the Grant is delayed by one clock
        // to the channel, the SrcStart will be delayed by one clock, so
        // nullify the effect of this on the number of transfers as treated by
        // channel we are preserving the previous value of the access count.
          NextAxsCntSrc    = AxsCntSrc;
        else
          NextAxsCntSrc    = SrcDMACK[4:0];
  
        // When the source-machine is still in IDLE state, if '0' is written
        // into the ChannelEnable bit, the source is disabled without raising
        // any AbortRequest to AHB Master.
        if ((DMACEn == 1'b1) && (((ChannelEn == 1'b1) && (SourceEnQ2 == 1'b0) &&
            (SourceEn == 1'b0)) ||
            (DstErred == 1'b1)) && 
           (~((SrcStart == 1'b1 ) && (BusAvlblSrc == 1'b1))))   
          begin
             SrcDisable       = 1'b1;
             NextSrcBurstOn   = 1'b0;
             NextBrstCntSrc   = {11{1'b0}};
          end

        // When the source-machine gets the grant along with BusAvlbl, it moves
        // to SELECTED state.
        else if ((SrcStart == 1'b1) && (DMACEn == 1'b1) && (SourceEnQ2 == 1'b1)
                 && (DataErrorSrc != 1'b1))
          begin

            NextSrcDmacState = `ST_SRC_SELECTED;
    
            // Mask off all the source requests.
            SetSrcAxsOnMsk   = 1'b1;
            UnsetSrcAxsOnMsk = 1'b0;
    
            // Load AccessCount with min(FifoEmptylevel, SBSize) if
            // SrcBurstOn = '0' and set NextSrcBurstOn = '1'. Else it indicates
            // that, more AHB accesses are required to finish the ongoing
            // DMABurst and AccessCount is loaded w.r.t BurstCount.
            if (SrcBurstOn == 1'b0)
               NextSrcBurstOn   = 1'b1;
    
            // Load BrstCntSrc from BrstCntSrcCo only if the counter has
            // expired. Else do not alter the burst-counter as the burst is yet
            // to be finished.
            if (BrstCntSrc == {11{1'b0}})
              NextBrstCntSrc   = BrstCntSrcCo;
            else
              NextBrstCntSrc   = BrstCntSrc;
          end
      end
  
    // ST_SRC_SELECTED:
    // Transition to ST_SRC_ONBUS: When
    //   o BusAvlbl is received.
    //
    // Transition to ST_SRC_IDLE: When
    // o the AHB returns an error to a data transfer.
    `ST_SRC_SELECTED :
      begin
        // Current state assignment
        NextSrcDmacState = `ST_SRC_SELECTED;

        if (DataErrorSrc == 1'b1)
          begin
            NextSrcDmacState = `ST_SRC_IDLE;
            // The source access is being aborted. The mask is 'unset' so that
            // the source can come-up again for re-arbitration.
            UnsetSrcAxsOnMsk = 1'b1;
            // Since the access is being aborted, the counters are taken to
            // zero.
            NextAxsCntSrc    = 5'b00000;
            NextPr1AxsCntSrc = 3'b000;
            NextPr2AxsCntSrc = 3'b000;
          end
        else if (BusAvlblSrc == 1'b1)
          NextSrcDmacState = `ST_SRC_ONBUS;
      end

    // ST_SRC_ONBUS:
    // Transition to ST_SRC_DATAXFER: When
    // o BusAvlbl is received.
    //
    // Transition to ST_SRC_IDLE: When
    // o the AHB returns an error to a data transfer.
    `ST_SRC_ONBUS :
      begin
        // Current state assignment
        NextSrcDmacState = `ST_SRC_ONBUS;

        if (DataErrorSrc == 1'b1)
          begin
            NextSrcDmacState = `ST_SRC_IDLE;
            // The source access is being aborted. The mask is 'unset' so that
            // the source can come-up again for re-arbitration.
            UnsetSrcAxsOnMsk = 1'b1;
            // Since the access is being aborted, the counters are taken to
            // zero.
            NextAxsCntSrc    = 5'b00000;
            NextPr1AxsCntSrc = 3'b000;
            NextPr2AxsCntSrc = 3'b000;
          end
        else if (BusAvlblSrc == 1'b1)
          begin
            NextSrcDmacState = `ST_SRC_DATAXFER;
            // Decrease AxsCntSrc by 1 and store the previous values of
            // AxsCntSrc in Pr1AxsCntSrc and Pr2AxsCntSrc.
            NextAxsCntSrc    = AxsCntSrc - 1'b1;
            NextPr1AxsCntSrc = AxsCntSrc[2:0];
            NextPr2AxsCntSrc = Pr1AxsCntSrc;
            NextAbortReqSrc  = 1'b0;
          end
      end

    // ST_SRC_DATAXFER:
    // Transition to ST_SRC_IDLE: When
    // o the AHB returns an error to a data transfer.
    // OR
    // o the master interface acknowledges an Abort-request(signalled by
    //   XferAborted). If the software disables the channel, when AHB
    //   transfers are continuing on master side, the channel is not disabled
    //   immediately. Instead, the channel sends an abort-request to the
    //   master interface. The master-interface acknowledges the request, once
    //   it reaches the nearest address boundary.
    // OR
    // o the current source access on the bus has terminated, although the
    //   source-burst is still ON.
    //   Note: One packet of source transfers may constitute of many
    //         Source bursts (marked by giving clear after servicing each),
    //         which in turn may constitute of many Source accesses (limited
    //         by FIFO availability).
    // o the current source access as well as source-burst has completed, but
    //   the source being a memory, the state-machine returns to IDLE instead
    //   of doing the request-clear handshake.
    //
    // Transition to ST_SRC_DATAXFER: When
    // o source burst is continuing and BusAvlbl for source is high.
    //
    // Transition to ST_SRC_WT4REQLOW: When
    // o current source-access as well as the source-burst has finished, and
    //   the source is a peripheral (not a memory, which does not require any
    //   clear-request handshake).
    `ST_SRC_DATAXFER :
      begin
        // Current state assignment
        NextSrcDmacState = `ST_SRC_DATAXFER;

        if (DataErrorSrc == 1'b1)
          begin
            NextSrcDmacState = `ST_SRC_IDLE;
            // The source access is being aborted. So "burston" mask is unset.
            // source can come-up again for re-arbitration.
            UnsetSrcAxsOnMsk = 1'b1;
            NextSrcBurstOn   = 1'b0;
            // Mask both source and destination requests with error-mask,
            // to prevent source and destination from requesting again, till the
            // channel is disabled. During channel-disable, the error-mask will
            // be unset.
            SetErrMskSrc     = 1'b1;
            // Set the SrcErred bit
            SrcErr           = 1'b1;
            // Since the access is being aborted, the counters are taken to
            // zero.
            NextAxsCntSrc    = 5'b00000;
            NextPr1AxsCntSrc = 3'b000;
            NextPr2AxsCntSrc = 3'b000;
            // The access is aborted due to error. So the NextAbortReqSrc can
            // also be pulled low.
            NextAbortReqSrc  = 1'b0;
            // The TrfSizeSrc should NOT be decremented as due to the error, the
            // data transfer has not completed.
            DecTrfSizeSrc    = 1'b0;
            NextBrstCntSrc   = 11'b00000000000;
          end
        else if ((BusAvlblSrc & XferAbortedSrc) == 1'b1)
          begin
            NextSrcDmacState = `ST_SRC_IDLE;
            // The source access is being aborted. So "burston" mask is unset.
            // The SourceEnQ2 bit being low, the mask is anyway set on the 
            // source requests.
            UnsetSrcAxsOnMsk = 1'b1;
            NextSrcBurstOn   = 1'b0;
            // The DisabledSrc bit is set
            SrcDisable       = 1'b1;
            // Transfer the data in the channel FIFO
            FifoWrEn         = 1'b1;
            // Since the access is being aborted, the counters are taken to
            // zero.
            NextAxsCntSrc    = 5'b00000;
            NextPr1AxsCntSrc = 3'b000;
            NextPr2AxsCntSrc = 3'b000;
            // The Master Interface terminates the access early (satisfying the
            // AHB protocols) and acknowledges the AbortReq. So the AbortReq is
            // pulled low.
            NextAbortReqSrc  = 1'b0;
            // Decrease TransferSize of source by 1. Though there is an abort
            // acknowledge, data transfer is completed.
            DecTrfSizeSrc    = 1'b1;
            // The burst is aborted. Thus resetting BrstCntSrc to zero.
            NextBrstCntSrc   = {11{1'b0}};
          end
        else if ((BusAvlblSrc == 1'b1) &&
                 (((AxsCntSrc == {5{1'b0}}) &&
                   (BrstCntSrc > {{10{1'b0}}, 1'b1})) ||
                  ((AxsCntSrc == {5{1'b0}}) &&
                   (BrstCntSrc == {{10{1'b0}}, 1'b1}) &&
                    IsSrcMemory(FlowCntl))))
          begin
            NextSrcDmacState = `ST_SRC_IDLE;
            // Since the access has been completed, the counters are taken to
            // zero.
            NextPr1AxsCntSrc = {3{1'b0}};
            NextPr2AxsCntSrc = {3{1'b0}};
            // Unset the BurstOn-mask.
            UnsetSrcAxsOnMsk = 1'b1;
            // Transfer the data in the Channel FIFO.
            FifoWrEn         = 1'b1;
            // Decrease TransferSize of source by 1. Though, in
            // source-flow-control mode, TransferSize bit-field is redundant.
            DecTrfSizeSrc    = 1'b1;
            // Decrease burstcount of source by 1
            NextBrstCntSrc   = BrstCntSrc - 1'b1;
            // The DMA burst has finished, but the source being a memory, the
            // machine does not go to WT4REQLOW state. The machine directly goes
            // to the IDLE state.
            if ((BrstCntSrc == ({{10{1'b0}}, 1'b1})) && (IsSrcMemory(FlowCntl)))
              begin
                NextSrcBurstOn   = 1'b0;
                if (IsDMAFlowCntl(FlowCntl[2:1]))
                begin
                  if (TrfSizeSrc == ({{11{1'b0}}, 1'b1}))
                    begin
                      // When the next LLI is to be loaded.
                      if (LLIAddressUB != {30{1'b0}})
                        // Set the mask on source requests till the LLI load
                        // starts.
                        SetSrcE2LMsk     = 1'b1;
                      // When no more LLI to be loaded
                      else
                        // Disable source. In this case, there is no need to
                        // mask the Source requests separately, as the
                        // DisabledSrc bit masks the requests.
                        SrcDisable       = 1'b1;
                    end
                  // When the TrfSizeSrc counter has yet not counted down to 1.
                  else
                    // Update source-address-regsiter with the next address
                    // value.
                    SrcAddrUpdate    = 1'b1;
                end

                // When Destination is the flow controller peripheral the
                // following statements are executed.
                // The source-flow-control mode is not possible since source is
                // a memory in this case.
                else
                  begin
                    if ((TrfSizeSrc == ({{11{1'b0}}, 1'b1})) &&
                        ((ChDstLBReq | ChDstLSReq) == 1'b1))
                      begin
                        if (LLIAddressUB != {30{1'b0}})
                          // Set the mask on source requests till the LLI load
                          // starts.
                          SetSrcE2LMsk     = 1'b1;
                        else
                          // Disable source. In this case, there is no need to
                          // mask the source requests separately, as the
                          // DisabledSrc bit masks the requests.
                          SrcDisable       = 1'b1;
                      end
                    else
                      // Register MasterAddress in DMACChSrcAddr
                      SrcAddrUpdate    = 1'b1;
                  end
              end
            // The source can be memory/peripheral. However the BrstCntSrc has
            // yet not counted down to 1.
            else
              // Update source-address-regsiter with the next address value.
              SrcAddrUpdate    = 1'b1;
          end
        else if ((BusAvlblSrc == 1'b1) && (AxsCntSrc == {5{1'b0}}) &&
                 (BrstCntSrc == {{10{1'b0}}, 1'b1}) &&
                 ~(IsSrcMemory(FlowCntl)))
          begin
            NextSrcDmacState = `ST_SRC_WT4REQLOW;
            // Decrease burstcount of source by 1
            NextBrstCntSrc   = (BrstCntSrc) - 1'b1;
            // Transfer the data in the channel FIFO
            FifoWrEn         = 1'b1;
            // Since the access is being aborted, the counters are taken to
            // zero.
            NextAxsCntSrc    = {5{1'b0}};
            NextPr1AxsCntSrc = {3{1'b0}};
            NextPr2AxsCntSrc = {3{1'b0}};
            // The DMACClrSrc for the channel is asserted high.
            NextDMACClrSrc   = 1'b1;
            // Decrease TransferSize of source by 1. Though, in
            // source-flow-control mode, TransferSize bit-field is redundant.
            DecTrfSizeSrc    = 1'b1;
            // If TC is to be given, then the MasterAddress should not be
            // registered into the DMACChSrcAddr register.
            if (IsDMAFlowCntl(FlowCntl[2:1]))
              begin
                if (TrfSizeSrc == {{11{1'b0}}, 1'b1})
                  begin
                    // Give Src TC
                    NextDMACTCSrc    = 1'b1;
                    // When the next LLI is to be loaded
                    if (LLIAddressUB != {30{1'b0}})
                      // Set the mask on source requests till the LLI load
                      // starts.
                      SetSrcE2LMsk     = 1'b1;
                    // When LLIAddressUB field is null indicating that no more
                    // packets need to be loaded by LLI.
                    else
                      // disable source
                      SrcDisable       = 1'b1;
                  end
                else
                  begin
                    // Do not give Src TC
                    NextDMACTCSrc    = 1'b0;
                    // Register MasterAddress in DMACChSrcAddr
                    SrcAddrUpdate    = 1'b1;
                  end
              end
            else if (IsSrcFlowCntl(FlowCntl[2:1]))
              begin
                if ((ChSrcLBReq | ChSrcLSReq) == 1'b1)
                  begin
                    // Give Src TC
                    NextDMACTCSrc    = 1'b1;
                    // The SrcTCDone is assigned 1, after reaching TC condition.
                    // In source flow-control-mode, if (SrcTCDone = '1') and
                    // FIFO is empty, the destination TC is given. The SrcTCDone
                    // flag is reset after the destination TC is given.
                    SetSrcTCDone     = 1'b1;
                    if (LLIAddressUB != {30{1'b0}})
                      SetSrcE2LMsk     = 1'b1;
                    // if the next LLI address is 'null'
                    else
                      SrcDisable       = 1'b1;
                  end
                else
                  // Register MasterAddress in DMACChSrcAddr
                  SrcAddrUpdate    = 1'b1;
              end
            // when destination is the flow controller.
            else
              begin
                if ((TrfSizeSrc == ({{11{1'b0}}, 1'b1})) &&
                    ((ChDstLBReq | ChDstLSReq) == 1'b1))
                  begin
                    // Give Source Terminal count.
                    NextDMACTCSrc    = 1'b1;
                    if (LLIAddressUB != {30{1'b0}})
                      // Set the mask on source requests till the LLI load
                      // starts.
                      SetSrcE2LMsk     = 1'b1;
                    // When the next LLI address is 'null'
                    else
                      // disable source. This will take care of the 'masking
                      // till actual-disable'
                      SrcDisable       = 1'b1;
                  end
                else
                  // Register MasterAddress in DMACChSrcAddr
                  SrcAddrUpdate    = 1'b1;
              end
          end
        else if ((BusAvlblSrc == 1'b1) & (AxsCntSrc != 5'b00000))
          begin
            NextSrcDmacState = `ST_SRC_DATAXFER;
            // Decrease TransferSize of source by 1.
            DecTrfSizeSrc    = 1'b1;
            // Decrease burstcount of source by 1
            NextBrstCntSrc   = (BrstCntSrc) - 1'b1;
            // Register the MasterAddress
            SrcAddrUpdate    = 1'b1;
            // Take the AHB data into the channel FIFO.
            FifoWrEn         = 1'b1;
            // Decrease AxsCntSrc by 1 and store the previous values of
            // AxsCntSrc in Pr1AxsCntSrc and Pr2AxsCntSrc.
            NextAxsCntSrc    = (AxsCntSrc) - 1'b1;
            NextPr1AxsCntSrc = AxsCntSrc[2:0];
            NextPr2AxsCntSrc = Pr1AxsCntSrc;
            // If SourceEnQ2 goes to zero, indicating that AHB Slave has
            // attempted to disable the channel, AbortReq signal is sent to 
            // the Master Interface. It is redundant to raise AbortReq when 
            // AxsCntSrc is less than or equal to 3. By the time Master 
            // Interface gives abort-acknowledge, the transfers would have 
            // been finished in normal course. Once AbortReq is set, it is 
            // reset if the acknowledge comes from the Master or the AxsCntSrc 
            // falls below 3.
            if ((SourceEnQ2 == 1'b0) & (AxsCntSrc > 5'b00011))
              NextAbortReqSrc  = 1'b1;
            else
              NextAbortReqSrc  = 1'b0;
          end
      end

    // ST_SRC_WT4REQLOW
    //   Transition to ST_SRC_IDLE: When
    //   o the transfer request is pulled low by the peripheral.
    `ST_SRC_WT4REQLOW :
      begin
        // Current state assignment
        NextSrcDmacState = `ST_SRC_WT4REQLOW;
        if ((ChSrcBReq | ChSrcLBReq | ChSrcSReq | ChSrcLSReq) == 1'b0)
          begin
            NextSrcDmacState = `ST_SRC_IDLE;
            // The TC and clear lines are de-asserted
            NextDMACTCSrc    = 1'b0;
            NextDMACClrSrc   = 1'b0;
            // Since the access is being aborted, the counters are taken to
            // zero.
            NextAxsCntSrc    = {5{1'b0}};
            NextPr1AxsCntSrc = {3{1'b0}};
            NextPr2AxsCntSrc = {3{1'b0}};
            // Resetting the burst-counter. It should have been gone to zero
            // during DATAXFER to WT4REQLOW transition.
            NextBrstCntSrc   = 11'b00000000000;
            // The AxsOnMsk is reset.
            UnsetSrcAxsOnMsk = 1'b1;
            NextSrcBurstOn   = 1'b0;
          end
      end
    default :
      NextSrcDmacState = `ST_SRC_IDLE;
  endcase
end // p_SrcDMACComb : 

// -----------------------------------------------------------------------------
// Sequential block for SrcDMACComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SrcDMACSeq
  if (HRESETn == 1'b0)
    begin
      AxsCntSrc        <= {5{1'b0}};
      Pr1AxsCntSrc     <= {3{1'b0}};
      Pr2AxsCntSrc     <= {3{1'b0}};
      BrstCntSrc       <= {11{1'b0}};
      SrcDmacState     <= `ST_SRC_IDLE;
      DMACClrSrc       <= 1'b0;
      DMACTCSrc        <= 1'b0;
      SrcBurstOn       <= 1'b0;
      AbortReqSrc      <= 1'b0;
      SrcStartQ        <= 1'b0;
    end
  else
    begin
      AxsCntSrc        <= NextAxsCntSrc;
      SrcDmacState     <= NextSrcDmacState;
      DMACClrSrc       <= NextDMACClrSrc;
      DMACTCSrc        <= NextDMACTCSrc;
      SrcBurstOn       <= NextSrcBurstOn;
      BrstCntSrc       <= NextBrstCntSrc;
      Pr1AxsCntSrc     <= NextPr1AxsCntSrc;
      Pr2AxsCntSrc     <= NextPr2AxsCntSrc;
      AbortReqSrc      <= NextAbortReqSrc;
      SrcStartQ        <= SrcStart;
    end
end // p_SrcDMACSeq

// -----------------------------------------------------------------------------
// The number of transfers to be done on AHB in one access.
// -----------------------------------------------------------------------------
assign SrcNumOfXfers    = NextAxsCntSrc;

// -----------------------------------------------------------------------------
// Taking the lower two bits of AxsCntSrc and its delayed versions, so that the
// combinational timing of p_SrcFactor block is better.
// -----------------------------------------------------------------------------
assign AxsCntSrc3LSB    = AxsCntSrc[2:0];

// -----------------------------------------------------------------------------
// The following block calculates an addition factor, in case the destination
// starts back to back with source.
// This factor is added only if the destination and source are targeted on the
// same AHB port and source-width is greater than or equal to destination width.
// -----------------------------------------------------------------------------
always @(SrcSelect or DstSelect or SWidth or DWidth or AxsCntSrc3LSB or
         Pr1AxsCntSrc or Pr2AxsCntSrc)
begin : p_MulSrcFctrComb
  MultipSrcFactor  = 2'b00;
  if ((SrcSelect == DstSelect) && ( ~(SWidth < DWidth)))
    begin
      // The following condition, when true, determines that three more source
      // transfers will finish, before the data appears on destination bus. So
      // an addition-factor of 3 (3 * Source-Width) is generated.
      if ((AxsCntSrc3LSB == 3'b010) && (Pr1AxsCntSrc == 3'b011) &&
          (Pr2AxsCntSrc == 3'b100))
        MultipSrcFactor  = 2'b11;
      // The following condition, when true, determines that two more source
      // transfers will finish, before the data appears on destination bus. So
      // an addition-factor of 2 (2 * Source-Width) is generated.
      else if (((AxsCntSrc3LSB == 3'b001) && (Pr1AxsCntSrc == 3'b010) &&
               (Pr2AxsCntSrc == 3'b011)))
        MultipSrcFactor  = 2'b10;
      // The following condition, when true, determines that one more source
      // transfer data will move into the FIFO, before that data appears on
      // destination bus. So an addition-factor of 1 (1 * Source-Width) is
      // generated.
      else if (((AxsCntSrc3LSB == 3'b000) && (Pr1AxsCntSrc == 3'b001) &&
               (Pr2AxsCntSrc == 3'b010)))
        MultipSrcFactor  = 2'b01;
    end
end // p_MulSrcFctrComb

// -----------------------------------------------------------------------------
// MultipSrcFactor is multiplied with Source Width to produce the final
// Source-Factor.
// -----------------------------------------------------------------------------
always @(SWidth or MultipSrcFactor)
begin : p_SrcFactorComb
  case (SWidth[1:0])
    2'b00 : SrcFactor        = {2'b00, MultipSrcFactor};
    2'b01 : SrcFactor        = {1'b0, MultipSrcFactor, 1'b0};
    // When Source width is word-wide or default condition
    default : SrcFactor        = {MultipSrcFactor, 2'b00};
  endcase
end // p_SrcFactorComb

// -----------------------------------------------------------------------------
// When the second cycle of error response is going on, the DataErrorSrc signal
// can be combinationally resolved to mask the destination transfer, which
// might be starting on other bus.
// -----------------------------------------------------------------------------
assign ErrCycMaskSrc    = (SrcDmacState == `ST_SRC_DATAXFER) ? DataErrorSrc :
                           1'b0;

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_LLIAddressProt
  if (ChannelEn == 1'b1)
  begin
    if (LLIAddressUB > {{28{1'b1}}, 2'b00})
      $display($time, "DmacChSrcXfer1: LLI address too large");
  end
end // p_LLIAddressProt

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule

// --================================== End ==================================--
