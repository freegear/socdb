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
// File Name              : DmacChReqProc.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block maps the DMAC-request-lines to the channel, routes the
//           Channel-information to one of the two AHB Master ports and resolves
//           the internal-arbiter grant to start source/destination/LLI
//           transfers.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacChReqProc (
// Inputs
                      // AHB signals
                      HCLK,
                      HRESETn,
                      // From AHB Slave interface (DmacAhbslaveIf)
                      DMACBREQCh,
                      DMACLBREQCh,
                      DMACSREQCh,
                      DMACLSREQCh,
                      ClrIntErr,
                      ClrIntTC,
                      // From DMACChRegBlock
                      SrcPeriph,
                      DstPeriph,
                      FlowCntl,
                      SetIntErr,
                      ErrIntMask,
                      TCIntMask,
                      SrcSelect,
                      DstSelect,
                      LLISelForPkt,
                      DMACChSrcAddr,
                      DMACChDstAddr,
                      ProtStat,
                      SWidth,
                      DWidth,
                      SBSize,
                      LLIAddressUB,
                      SrcIncr,
                      DestIncr,
                      ChannelEn,
                      TrfSizeSrc,
                      // From DmacChSrcXfer block
                      AbortReqSrcM1,
                      AbortReqSrcM2,
                      DMACClrSrc,
                      DMACTCSrc,
                      SrcNumOfXfers,
                      // From DmacChDstXfer block
                      AbortReqDstM1,
                      AbortReqDstM2,
                      DMACClrDst,
                      DMACTCDst,
                      SetIntTC,
                      SetLLIReq,
                      DstNumOfXfers,
                      DstDmacState,
                      // From DmacChLLILoad block
                      UnsetLLIReq,
                      FinishedLLI,
                      // From DmacChReqMask block
                      SourceMask,
                      DestMask,
                      // From DmacArbiter block
                      ChGntM1,
                      ChGntM2,
                      DstBurstOn,
                      FifoNonEmpty,

// Outputs
                      // To DmacChSrcXfer block
                      ChSrcBReq,
                      ChSrcLBReq,
                      ChSrcSReq,
                      ChSrcLSReq,
                      SrcStart,
                      // To DmacChDstXfer block
                      ChDstBReq,
                      ChDstLBReq,
                      ChDstSReq,
                      ChDstLSReq,
                      DstStart,
                      // To DmacChLLILoad block
                      LLIStart,
                      // To DmacArbiter block
                      ChXferAbortM1,
                      ChXferAbortM2,
                      ChReqM1,
                      ChReqM2,
                      ChNumOfXfersM1,
                      ChNumOfXfersM2,
                      ChIncrM1,
                      ChIncrM2,
                      ChAddrM1,
                      ChAddrM2,
                      ChProtM1,
                      ChProtM2,
                      ChWidthM1,
                      ChWidthM2,
                      ChDirxnM1,
                      ChDirxnM2,
                      // To DmacChRegBlock
                      LdSrcInDstFlow,
                      // To AHB Slave interface (DmacAhbSlaveIf)
                      ClearReq,
                      RawIntErrCh,
                      RawIntTCCh,
                      ErrClrReq,
                      // To DmacRspRoute block
                      IntErrCh,
                      IntTCCh,
                      SigTC
                      );

// Inputs
// AHB signals
input         HCLK;           // AHB Clock
input         HRESETn;        // AHB Reset
// From AHB Slave interface (DmacAhbslaveIf)
input  [15:0] DMACBREQCh;     // DMA burst transfer request for channels
input  [15:0] DMACLBREQCh;    // DMAC last burst transfer request for channels
input  [15:0] DMACSREQCh;     // DMAC single transfer request for channels
input  [15:0] DMACLSREQCh;    // DMAC last single transfer request for
                              // channels
input         ClrIntErr;      // Clear error interrupt
input         ClrIntTC;       // Clear TC interrupt
// From DMACChRegBlock
input   [3:0] SrcPeriph;      // Indicates the source-peripheral mapped to the
                              // channel
input   [3:0] DstPeriph;      // Indicates the destination- peripheral mapped
                              // to the channel
input   [2:0] FlowCntl;       // Flow control information
input         SetIntErr;      // Set error interrupt
input         ErrIntMask;     // Mask for error-interrupt
input         TCIntMask;      // Mask for TC-interrupt
input         SrcSelect;      // Source AHB Master select
input         DstSelect;      // Destination AHB Master select
input         LLISelForPkt;   // AHB master select for LLI loading
input  [31:0] DMACChSrcAddr;  // Source address register
input  [31:0] DMACChDstAddr;  // Destination address register
input   [2:0] ProtStat;       // Higher 3 bits of HPROT signal
input   [2:0] SWidth;         // Source transfer width
input   [2:0] DWidth;         // Destination transfer width
input   [2:0] SBSize;         // Source burst size
input  [31:2] LLIAddressUB;   // Address of the next LLI
input         SrcIncr;        // incrementing addressing for source
input         DestIncr;       // incrementing addressing for destination
input         ChannelEn;      // Channel Enable bit
input  [11:0] TrfSizeSrc;     // Indicates the number of source transfers to
                              // perform
// From DmacChSrcXfer block
input         AbortReqSrcM1;  // Source Abort request for port1
input         AbortReqSrcM2;  // Source Abort request for port2
input         DMACClrSrc;     // Clear signal for source request
input         DMACTCSrc;      // TC signal for source request
input   [4:0] SrcNumOfXfers;  // Number of source transfers to be done in one
                              // AHB access
// From DmacChDstXfer block
input         AbortReqDstM1;  // Destination Abort request for port1
input         AbortReqDstM2;  // Destination Abort request for port2
input         DMACClrDst;     // Clear signal for destination request
input         DMACTCDst;      // TC signal for destination request
input         SetIntTC;       // Sets TC interrupt signal
input         SetLLIReq;      // Sets the LLI request
input   [4:0] DstNumOfXfers;  // Number of destination transfers to be done in
                              // one AHB access
input   [4:0] DstDmacState;   // Destination state information
// From DmacChLLILoad block
input         UnsetLLIReq;    // De-asserts the LLI request
input         FinishedLLI;    // LLI loading has finished
// From DmacChReqMask block
input         SourceMask;     // Final source mask
input         DestMask;       // Final destination mask
// From DmacArbiter block
input         ChGntM1;        // Grant for channel from master1
input         ChGntM2;        // Grant for channel from master2
input         DstBurstOn;     // Indicates that the destination burst needs
                              // more AHB access to finish
input         FifoNonEmpty;   // Indicates data being present in channel FIFO

// Outputs
// To DmacChSrcXfer block
output        ChSrcBReq;      // Source Burst Request for the channel
output        ChSrcLBReq;     // Source Last Burst Request for the channel
output        ChSrcSReq;      // Source Single Request for the channel
output        ChSrcLSReq;     // Source Last Single Request for the channel
output        SrcStart;       // Source transfers can start
// To DmacChDstXfer block
output        ChDstBReq;      // Destination Burst Request for the channel
output        ChDstLBReq;     // Destination Last Burst Request for the
                              // channel
output        ChDstSReq;      // Destination Single Request for the channel
output        ChDstLSReq;     // Destination Last Single Request for the
                              // channel
output        DstStart;       // Destination transfers can start
// To DmacChLLILoad block
output        LLIStart;       // LLI loading can start
// To DmacArbiter block
output        ChXferAbortM1;  // Request to abort the ongoing AHB1 transfer
output        ChXferAbortM2;  // Request to abort the ongoing AHB2 transfer
output        ChReqM1;        // Channel request for AHB1
output        ChReqM2;        // Channel request for AHB2
output  [4:0] ChNumOfXfersM1; // Number of requested transfers on AHB1
output  [4:0] ChNumOfXfersM2; // Number of requested transfers on AHB2
output        ChIncrM1;       // Incrementing transfers on AHB1
output        ChIncrM2;       // Incrementing transfers on AHB2
output [31:0] ChAddrM1;       // First address for the AHB Access requested by
                              // channel
output [31:0] ChAddrM2;       // First address for the AHB Access requested by
                              // channel
output  [2:0] ChProtM1;       // HPROT information for AHB1
output  [2:0] ChProtM2;       // HPROT information for AHB2
output  [2:0] ChWidthM1;      // HSIZE information for AHB1
output  [2:0] ChWidthM2;      // HSIZE information for AHB2
output        ChDirxnM1;      // HWRITE information for AHB1
output        ChDirxnM2;      // HWRITE information for AHB2
// To DmacChRegBlock
output        LdSrcInDstFlow; // Indicates that the TrfSizeSrc register can be
                              // loaded with destination required number
// To AHB Slave interface (DmacAhbSlaveIf)
output [15:0] ClearReq;       // Request clear vector
output        RawIntErrCh;    // Raw error interrupt
output        RawIntTCCh;     // Raw Terminal Count interrupt
output [15:0] ErrClrReq;      // Pulse for clearing the SoftRequest registers
// To DmacRspRoute block
output        IntErrCh;       // Masked error interrupt
output        IntTCCh;        // Masked Terminal Count interrupt
output [15:0] SigTC;          // Terminal count vector

// Inputs
// AHB signals
wire          HCLK;           // AHB Clock
wire          HRESETn;        // AHB Reset
// From AHB Slave interface (DmacAhbslaveIf)
wire   [15:0] DMACBREQCh;     // DMA burst transfer request for channels
wire   [15:0] DMACLBREQCh;    // DMAC last burst transfer request for channels
wire   [15:0] DMACSREQCh;     // DMAC single transfer request for channels
wire   [15:0] DMACLSREQCh;    // DMAC last single transfer request for
                              // channels
wire          ClrIntErr;      // Clear error interrupt
wire          ClrIntTC;       // Clear TC interrupt
// From DMACChRegBlock
wire    [3:0] SrcPeriph;      // Indicates the source-peripheral mapped to the
                              // channel
wire    [3:0] DstPeriph;      // Indicates the destination- peripheral mapped
                              // to the channel
wire    [2:0] FlowCntl;       // Flow control information
wire          SetIntErr;      // Set error interrupt
wire          ErrIntMask;     // Mask for error-interrupt
wire          TCIntMask;      // Mask for TC-interrupt
wire          SrcSelect;      // Source AHB Master select
wire          DstSelect;      // Destination AHB Master select
wire          LLISelForPkt;   // AHB master select for LLI loading
wire   [31:0] DMACChSrcAddr;  // Source address register
wire   [31:0] DMACChDstAddr;  // Destination address register
wire    [2:0] ProtStat;       // Higher 3 bits of HPROT signal
wire    [2:0] SWidth;         // Source transfer width
wire    [2:0] DWidth;         // Destination transfer width
wire    [2:0] SBSize;         // Source burst size
wire   [31:2] LLIAddressUB;   // Address of the next LLI
wire          SrcIncr;        // incrementing addressing for source
wire          DestIncr;       // incrementing addressing for destination
wire          ChannelEn;      // Channel Enable bit
wire   [11:0] TrfSizeSrc;     // Indicates the number of source transfers to
                              // perform
// From DmacChSrcXfer block
wire          AbortReqSrcM1;  // Source Abort request for port1
wire          AbortReqSrcM2;  // Source Abort request for port2
wire          DMACClrSrc;     // Clear signal for source request
wire          DMACTCSrc;      // TC signal for source request
wire    [4:0] SrcNumOfXfers;  // Number of source transfers to be done in one
                              // AHB access
// From DmacChDstXfer block
wire          AbortReqDstM1;  // Destination Abort request for port1
wire          AbortReqDstM2;  // Destination Abort request for port2
wire          DMACClrDst;     // Clear signal for dest request
wire          DMACTCDst;      // TC signal for dest request
wire          SetIntTC;       // Sets TC interrupt signal
wire          SetLLIReq;      // Sets the LLI request
wire    [4:0] DstNumOfXfers;  // Number of destination transfers to be done in
                              // one AHB access
wire    [4:0] DstDmacState;   // Destination state information
// From DmacChLLILoad block
wire          UnsetLLIReq;    // De-asserts the LLI request
wire          FinishedLLI;    // LLI loading has finished
// From DmacChReqMask block
wire          SourceMask;     // Final source mask
wire          DestMask;       // Final destination mask
// From DmacArbiter block
wire          ChGntM1;        // Grant for channel from master1
wire          ChGntM2;        // Grant for channel from master2
wire          DstBurstOn;     // Indicates that the destination burst needs
                              // more AHB access to finish
wire          FifoNonEmpty;   // Indicates data being present in channel FIFO

// Outputs
// To DmacChSrcXfer block
wire          ChSrcBReq;      // Source Burst Request for the channel
wire          ChSrcLBReq;     // Source Last Burst Request for the channel
wire          ChSrcSReq;      // Source Single Request for the channel
wire          ChSrcLSReq;     // Source Last Single Request for the channel
wire          SrcStart;       // Source transfers can start
// To DmacChDstXfer block
wire          ChDstBReq;      // Destination Burst Request for the channel
wire          ChDstLBReq;     // Destination Last Burst Request for the
                              // channel
wire          ChDstSReq;      // Destination Single Request for the channel
wire          ChDstLSReq;     // Destination Last Single Request for the
                              // channel
wire          DstStart;       // Destination transfers can start
// To DmacChLLILoad block
wire          LLIStart;       // LLI loading can start
// To DmacArbiter block
wire          ChXferAbortM1;  // Request to abort the ongoing AHB1 transfer
wire          ChXferAbortM2;  // Request to abort the ongoing AHB2 transfer
wire          ChReqM1;        // Channel request for AHB1
wire          ChReqM2;        // Channel request for AHB2
reg     [4:0] ChNumOfXfersM1; // Number of requested transfers on AHB1
reg     [4:0] ChNumOfXfersM2; // Number of requested transfers on AHB2
reg           ChIncrM1;       // Incrementing transfers on AHB1
reg           ChIncrM2;       // Incrementing transfers on AHB2
reg    [31:0] ChAddrM1;       // First address for the AHB Access requested by
                              // channel
reg    [31:0] ChAddrM2;       // First address for the AHB Access requested by
                              // channel
reg     [2:0] ChProtM1;       // HPROT information for AHB1
reg     [2:0] ChProtM2;       // HPROT information for AHB2
reg     [2:0] ChWidthM1;      // HSIZE information for AHB1
reg     [2:0] ChWidthM2;      // HSIZE information for AHB2
reg           ChDirxnM1;      // HWRITE information for AHB1
reg           ChDirxnM2;      // HWRITE information for AHB2
// To DmacChRegBlock
wire          LdSrcInDstFlow; // Indicates that the TrfSizeSrc register can be
                              // loaded with destination required number
// To AHB Slave interface (DmacAhbSlaveIf)
wire   [15:0] ClearReq;       // Request clear vector
reg           RawIntErrCh;    // Raw error interrupt
reg           RawIntTCCh;     // Raw Terminal Count interrupt
wire   [15:0] ErrClrReq;      // Pulse for clearing the SoftRequest registers
// To DmacRspRoute block
wire          IntErrCh;       // Masked error interrupt
wire          IntTCCh;        // Masked Terminal Count interrupt
wire   [15:0] SigTC;          // Terminal count vector

// -----------------------------------------------------------------------------
//
//                                DmacChReqProc
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// o The transfer-abort-request (asserted at the time of channel-disable by
//   software from AHB slave side) from the source and destination block are
//   ORed and sent to the Master Interface as a single AbortReq.
// o Resolution of the request mapped to the channel is done. This is done on
//   the basis of SrcPeriph and DstPeriph bit-fields in DMACChConfig register.
// o The DMA transfer requests from the peripherals are qualified. For example
//   if an SREQ for destination is raised in DMAC flow control mode, it should
//   be ignored.
// o Source Request is formed by masking the 'qualified-request' with the
//   consolidated source-mask from DmacChReqMask.vhd.
// o Destination Request is formed by masking the request with the consolidated
//   destination-mask from DmacChReqMask.vhd
// o LdSrcInDstFlow signal is generated, which loads the TrfSizeSrc in
//   destination-flow-control mode. In destination-flow-control mode, the
//   TrfSizeSrc (source-transfer-size counter) is reused for performing source
//   transfers. (It is to be noted that the TrfSize has no functional
//   implication in Destination Flow Control mode). The TrfSizeSrc counter value
//   is loaded whenever the destination request goes high and when channel is
//   enabled.
// o LLIReq bit is described, which raises a request for AHB transfers
//   corresponding to LLI loading.
// o The clear and TC de-multiplexor for source is described. The
//   source-transfer-block raises asserts the clear and TC. These signals are to
//   be de-muxed to one out of 16 requestors.
// o The clear and TC de-multiplexor for destination is described. The
//   destination-transfer-block raises the clear and TC. These signals are to be
//   de-muxed to one out of 16 requestors.
// o The Internal Grant decipher block is described. When the channel is granted
//   by the internal arbiter, it needs to be resolved to source/destination/LLI
//   block grant.
// o The control signals, depending on which block has been given the internal
//   grant (i.e. source, destination or LLI block), are routed to the master
//   interface.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire        AllQualSrcReq;
// Logical OR of all the Qualified source requests

wire        AllQualDstReq;
// Logical OR of all the Qualified destination requests

wire        SourceRequest;
// AllQualSrcReq is ORed with SourceMask to obtain SourceRequest

wire        DestRequest;
// AllQualDstReq is ORed with DestMask to obtain DestRequest

wire        SrcReqM1;
// Source Request on AHB1

wire        SrcReqM2;
// Source Request on AHB2

wire        DstReqM1;
// Destination Request on AHB1

wire        DstReqM2;
// Destination Request on AHB2

wire        LLIReqM1;
// LLI request for AHB1

wire        LLIReqM2;
// LLI request for AHB2

wire        NxtDelQualDstReq;
// D-input of AllQualDstReq

wire        LdSrcDstReqHigh;
// Loads the TrfSizeSrc counter when the destination request goes high

wire        LdRemSrcTrf;
// Loads the remaining source transfers in destination flow control mode

wire [15:0] InChSrcBReq;
// Any single bit high in this sixteen bit signal indicates that the
// Source-Burst-request corresponding to the channel has been raised

wire [15:0] InChSrcLBReq;
// Any single bit high in this sixteen bit signal indicates that the
// Source-Last-Burst-request corresponding to the channel has been raised

wire [15:0] InChSrcSReq;
// Any single bit high in this sixteen bit signal indicates that the
// Source-Single-request corresponding to the channel has been raised

wire [15:0] InChSrcLSReq;
// Any single bit high in this sixteen bit signal indicates that the
// Source-Last-single request corresponding to the channel has been raised

wire [15:0] InChDstBReq;
// Any single bit high in this sixteen bit signal indicates that the
// Destination-Burst-request corresponding to the channel has been raised

wire [15:0] InChDstLBReq;
// Any single bit high in this sixteen bit signal indicates that the
// Destination-Last-Burst-request corresponding to the channel has been raised

wire [15:0] InChDstSReq;
// Any single bit high in this sixteen bit signal indicates that the
// Destination-Single-request corresponding to the channel has been raised

wire [15:0] InChDstLSReq;
// Any single bit high in this sixteen bit signal indicates that the
// Destination-Last-Single-request corresponding to the channel has been raised

wire        ValidErrSrc;
// This signal is asserted for a pulse, if a source peripheral returns an error
// response

wire        ValidErrDst;
// This signal is asserted for a pulse, if a destination peripheral returns an
// error response

wire [15:0] OnAllValidErrSrc;
// This vector signal has the value of ValidErrSrc replicated on all of its bits

wire [15:0] OnAllValidErrDst;
// This vector signal has the value of ValidErrDst replicated on all of its bits

wire [15:0] ErrClrSrc;
// This signal is the de-muxed version of ValidErrSrc on 16 lines

wire [15:0] ErrClrDst;
// This signal is the de-muxed version of ValidErrDst on 16 lines

wire        LdAfterLLI;
// After LLI loading, if destination request is found to be raised, the
// LdAfterLLI pulse is generated

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         QualSrcBReq;
// Qualified source burst request for the channel

reg         QualSrcLBReq;
// Qualified source last burst Request for the channel

reg         QualSrcSReq;
// Qualified source single request for the channel

reg         QualSrcLSReq;
// Qualified source last single Request for the channel

reg         QualDstBReq;
// Qualified destination burst request for the channel

reg         QualDstLBReq;
// Qualified destination last Burst Request for the channel

reg         QualDstSReq;
// Qualified destination single Request for the channel

reg         QualDstLSReq;
// Qualified destination last Single Request for the channel

reg         NextRawIntErrCh;
// D-input of RawIntErrCh

reg         NextRawIntTCCh;
// D-input of RawIntTCCh

reg         LLIReq;
// LLI request

reg         NextLLIReq;
// D-input for LLIReq

reg         SrcStartM1;
// Source start signal from AHB1

reg         DstStartM1;
// Destination start signal from AHB1

reg         LLIStartM1;
// LLI start signal from AHB1

reg         SrcStartM2;
// Source start signal from AHB2

reg         DstStartM2;
// Destination start signal from AHB2

reg         LLIStartM2;
// LLI start signal from AHB2

reg         DelQualDstReq;
// Delayed version of AllQualDstReq and ChannelEn

reg  [15:0] SrcDecode;
// The 16 bit decode of binary encoded SrcPeriph bit-field

reg  [15:0] DstDecode;
// The 16 bit decode of binary encoded DstPeriph bit-field

reg         RegSetIntErr;
// Clocked version of SetIntErr

reg         SrcReqM1Q2;
// Source Request on AHB1

reg         SrcReqM2Q2;
// Source Request on AHB2

reg         DstReqM1Q2;
// Destination Request on AHB1

reg         DstReqM2Q2;
// Destination Request on AHB2

reg         LLIReqM1Q2;
// LLI request for AHB1

reg         LLIReqM2Q2;
// LLI request for AHB2

reg  [15:0] SigTCSrc;
// TC vector for the source state machine

reg  [15:0] ClearReqSrc;
// Clear vector for the source state machine

reg  [15:0] SigTCDst;
// TC vector for the destination state machine

reg  [15:0] ClearReqDst;
// Clear vector for the destination state machine

reg         AllowSrcSnglRq;
// Mask to block source single request

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
// Mask for source single request:
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// When DMAC is the flow controller source single request is considered only
// when amount of data to be transferred is lesser than the burst size of the
// source peripheral.
// -----------------------------------------------------------------------------
always @(FlowCntl or SBSize or TrfSizeSrc)
begin : p_AllowSrcSnglRqComb
  AllowSrcSnglRq = 1'b1;
  if (FlowCntl[2] == 1'b0)
    begin
      case (SBSize)
        3'b001 :
          begin 
            if ((|TrfSizeSrc[11:2]) == 1'b1)
              begin
                AllowSrcSnglRq = 1'b0;
              end
          end

        3'b010 :
          begin 
            if ((|TrfSizeSrc[11:3]) == 1'b1)
              begin
                AllowSrcSnglRq = 1'b0;
              end
          end

        3'b011 :
          begin
            if ((|TrfSizeSrc[11:4]) == 1'b1)
              begin
                AllowSrcSnglRq = 1'b0;
              end
          end

        3'b100 :
          begin
            if ((|TrfSizeSrc[11:5]) == 1'b1)
              begin
                AllowSrcSnglRq = 1'b0;
              end
          end

        3'b101 :
          begin
            if ((|TrfSizeSrc[11:6]) == 1'b1)
              begin
                AllowSrcSnglRq = 1'b0;
              end
          end

        3'b110 :
          begin
            if ((|TrfSizeSrc[11:7]) == 1'b1)
              begin
                AllowSrcSnglRq = 1'b0;
              end
          end

        3'b111 :
          begin
            if ((|TrfSizeSrc[11:8]) == 1'b1)
              begin
                AllowSrcSnglRq = 1'b0;
              end
          end

        default :
          ;
      endcase
    end
end // p_AllowSrcSnglRqComb

// -----------------------------------------------------------------------------
// Generating the Channel abort requests.
// -----------------------------------------------------------------------------
assign ChXferAbortM1    = AbortReqSrcM1 | AbortReqDstM1;
assign ChXferAbortM2    = AbortReqSrcM2 | AbortReqDstM2;

// -----------------------------------------------------------------------------
// The following block decodes the binary-encoded SrcPeriph bit-field. This
// 'decode' is reused for
// o Multiplexing the relevant request line into the channel.
// o De-muxing the TC signal of the channel onto one of the 16 DMACTC lines.
// o De-muxing the Clear signal of the channel onto one of the 16 DMACCLR lines.
// o In case of an error response, one pulse is generated to clear the
//   SoftRequest registers. This pulse is also de-muxed using SrcDecode
// -----------------------------------------------------------------------------
always @(SrcPeriph)
begin : p_SrcDecodeComb
  case (SrcPeriph)
    4'b0000 : SrcDecode        = 16'b0000000000000001;
    4'b0001 : SrcDecode        = 16'b0000000000000010;
    4'b0010 : SrcDecode        = 16'b0000000000000100;
    4'b0011 : SrcDecode        = 16'b0000000000001000;
    4'b0100 : SrcDecode        = 16'b0000000000010000;
    4'b0101 : SrcDecode        = 16'b0000000000100000;
    4'b0110 : SrcDecode        = 16'b0000000001000000;
    4'b0111 : SrcDecode        = 16'b0000000010000000;
    4'b1000 : SrcDecode        = 16'b0000000100000000;
    4'b1001 : SrcDecode        = 16'b0000001000000000;
    4'b1010 : SrcDecode        = 16'b0000010000000000;
    4'b1011 : SrcDecode        = 16'b0000100000000000;
    4'b1100 : SrcDecode        = 16'b0001000000000000;
    4'b1101 : SrcDecode        = 16'b0010000000000000;
    4'b1110 : SrcDecode        = 16'b0100000000000000;
    4'b1111 : SrcDecode        = 16'b1000000000000000;
    default : SrcDecode        = 16'b0000000000000000;
  endcase
end // p_SrcDecodeComb

// -----------------------------------------------------------------------------
// The following two statements, uses the SrcDecode to multiplex one of the
// 16 BREQ lines onto the ChSrcBReq.
// -----------------------------------------------------------------------------
assign InChSrcBReq      = DMACBREQCh & SrcDecode;
assign ChSrcBReq        = |(InChSrcBReq);

// -----------------------------------------------------------------------------
// The following two statements, uses the SrcDecode to multiplex one of the
// 16 LBREQ lines onto the ChSrcLBReq.
// -----------------------------------------------------------------------------
assign InChSrcLBReq     = DMACLBREQCh & SrcDecode;
assign ChSrcLBReq       = |(InChSrcLBReq);

// -----------------------------------------------------------------------------
// The following two statements, uses the SrcDecode to multiplex one of the
// 16 SREQ lines onto the ChSrcSReq.
// -----------------------------------------------------------------------------
assign InChSrcSReq      = DMACSREQCh & SrcDecode;
assign ChSrcSReq        = |(InChSrcSReq);

// -----------------------------------------------------------------------------
// The following two statements, uses the SrcDecode to multiplex one of the
// 16 LSREQ lines onto the ChSrcLSReq.
// -----------------------------------------------------------------------------
assign InChSrcLSReq     = DMACLSREQCh & SrcDecode;
assign ChSrcLSReq       = |(InChSrcLSReq);

// -----------------------------------------------------------------------------
// The following block decodes the binary-encoded DstPeriph bit-field. This
// 'decode' is reused for
// o Multiplexing the relevant request line into the channel.
// o De-muxing the TC signal of the channel onto one of the 16 DMACTC lines.
// o De-muxing the Clear signal of the channel onto one of the 16 DMACCLR lines.
// o In case of an error response, one pulse is generated to clear the
//   SoftRequest registers. This pulse is also de-muxed using DstDecode.
// -----------------------------------------------------------------------------
always @(DstPeriph)
begin : p_DstDecodeComb
  case (DstPeriph)
    4'b0000 : DstDecode        = 16'b0000000000000001;
    4'b0001 : DstDecode        = 16'b0000000000000010;
    4'b0010 : DstDecode        = 16'b0000000000000100;
    4'b0011 : DstDecode        = 16'b0000000000001000;
    4'b0100 : DstDecode        = 16'b0000000000010000;
    4'b0101 : DstDecode        = 16'b0000000000100000;
    4'b0110 : DstDecode        = 16'b0000000001000000;
    4'b0111 : DstDecode        = 16'b0000000010000000;
    4'b1000 : DstDecode        = 16'b0000000100000000;
    4'b1001 : DstDecode        = 16'b0000001000000000;
    4'b1010 : DstDecode        = 16'b0000010000000000;
    4'b1011 : DstDecode        = 16'b0000100000000000;
    4'b1100 : DstDecode        = 16'b0001000000000000;
    4'b1101 : DstDecode        = 16'b0010000000000000;
    4'b1110 : DstDecode        = 16'b0100000000000000;
    4'b1111 : DstDecode        = 16'b1000000000000000;
    default : DstDecode        = 16'b0000000000000000;
  endcase
end // p_DstDecodeComb

// -----------------------------------------------------------------------------
// The following two statements, uses the DstDecode to multiplex one of the
// 16 BREQ lines onto the ChDstBReq.
// -----------------------------------------------------------------------------
assign InChDstBReq      = DMACBREQCh & DstDecode;
assign ChDstBReq        = |(InChDstBReq);

// -----------------------------------------------------------------------------
// The following two statements, uses the DstDecode to multiplex one of the
// 16 LBREQ lines onto the ChDstLBReq.
// -----------------------------------------------------------------------------
assign InChDstLBReq     = DMACLBREQCh & DstDecode;
assign ChDstLBReq       = |(InChDstLBReq);

// -----------------------------------------------------------------------------
// The following two statements, uses the DstDecode to multiplex one of the
// 16 SREQ lines onto the ChDstSReq.
// -----------------------------------------------------------------------------
assign InChDstSReq      = DMACSREQCh & DstDecode;
assign ChDstSReq        = |(InChDstSReq);

// -----------------------------------------------------------------------------
// The following two statements, uses the DstDecode to multiplex one of the
// 16 LSREQ lines onto the ChDstLSReq.
// -----------------------------------------------------------------------------
assign InChDstLSReq     = DMACLSREQCh & DstDecode;
assign ChDstLSReq       = |(InChDstLSReq);

// -----------------------------------------------------------------------------
// In some flow-control configurations, certain source requests are to be
// ignored. For example, in P2P DMAC flow control mode, the source LBREQ and
// LSREQ are to be ignored. This block masks the requests-to-be-ignored and only
// passes the 'qualified' requests.
// -----------------------------------------------------------------------------
always @(ChSrcBReq or ChSrcSReq or ChSrcLBReq or ChSrcLSReq or FlowCntl)
begin : p_QualSrcReqComb
   QualSrcBReq      = ChSrcBReq;
   QualSrcSReq      = ChSrcSReq;
   QualSrcLBReq     = ChSrcLBReq;
   QualSrcLSReq     = ChSrcLSReq;

  // When the source is a memory, all its requests are to be ignored.
  // Only the burst-request is to be tied to '1' as memory is not controlled by
  // requests. Memory is "active" till channel enable is 1.
  if (IsSrcMemory(FlowCntl))
    begin
      QualSrcBReq      = 1'b1;
      QualSrcSReq      = 1'b0;
      QualSrcLBReq     = 1'b0;
      QualSrcLSReq     = 1'b0;
    end
  // When DMAC or destination is the flow-controller, the source LBREQ and LSREQ
  // are ignored.
  else if (IsDMAFlowCntl(FlowCntl[2:1]) || IsDstFlowCntl(FlowCntl[2:1]))
    begin
      QualSrcLBReq     = 1'b0;
      QualSrcLSReq     = 1'b0;
    end
end // p_QualSrcReqComb

// -----------------------------------------------------------------------------
// All the 'qualified' requests are logically ORed, masked with the SourceMask
// (from DmacChReqMask block) and de-multiplexed to AHB1 or AHB2, depending on
// SrcSelect bit.
// -----------------------------------------------------------------------------
assign AllQualSrcReq    = QualSrcBReq |
                          (QualSrcSReq & AllowSrcSnglRq) |
                          QualSrcLBReq |
                          QualSrcLSReq;

assign SourceRequest    = AllQualSrcReq & SourceMask;

assign SrcReqM1  = (SrcSelect == 1'b0) ? SourceRequest : 1'b0;

assign SrcReqM2  = (SrcSelect == 1'b1) ? SourceRequest : 1'b0;

// -----------------------------------------------------------------------------
// In some flow-control configurations, certain destination requests are to be
// ignored. For example, in P2P DMAC flow control mode, only the destination
// BREQ is considered, rest all are ignored. This block masks the requests-to-be
// ignored and only passes the 'qualified' requests.
// -----------------------------------------------------------------------------
always @(ChDstBReq or ChDstSReq or ChDstLBReq or ChDstLSReq or FlowCntl)
begin : p_QualDstReqComb
   QualDstBReq      = ChDstBReq;
   QualDstSReq      = 1'b0;
   QualDstLBReq     = 1'b0;
   QualDstLSReq     = 1'b0;

  // When the destination is a memory, all its requests are ignored.
  // Only the burst-request is to be tied to '1' as memory is not controlled by
  // requests. Memory is "active" till channel enable is 1.
  if (IsDstMemory(FlowCntl))
    QualDstBReq      = 1'b1;
  // Only in case of destination flow controlled mode, all the types of request
  // lines are considered.
  else if (IsDstFlowCntl(FlowCntl[2:1]))
    begin
      QualDstBReq      = ChDstBReq;
      QualDstSReq      = ChDstSReq;
      QualDstLBReq     = ChDstLBReq;
      QualDstLSReq     = ChDstLSReq;
    end
end // p_QualDstReqComb

// -----------------------------------------------------------------------------
// All the 'qualified' requests are logically ORed, masked with the DestMask
// (from DmacChReqMask block) and de-multiplexed to AHB1 or AHB2, depending on
// DstSelect bit.
// -----------------------------------------------------------------------------
assign AllQualDstReq    = QualDstBReq | QualDstSReq | QualDstLBReq |
                           QualDstLSReq;

assign DestRequest      = AllQualDstReq & DestMask;

assign DstReqM1    = (DstSelect == 1'b0) ? DestRequest : 1'b0;

assign DstReqM2    = (DstSelect == 1'b1) ? DestRequest : 1'b0;

// -----------------------------------------------------------------------------
// The following block generates a delayed version of AllQualDstReq ANDed with
// ChannelEn. The positive transition of any destination request is used to load
// the TrfSizeSrc value in destination flow control mode.
// -----------------------------------------------------------------------------
assign NxtDelQualDstReq = ChannelEn & AllQualDstReq;

// -----------------------------------------------------------------------------
// Sequential block for DelQualDstReq
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_DelQualDstSeq
  if (HRESETn == 1'b0)
    DelQualDstReq    <= 1'b0;
  else
    DelQualDstReq    <= NxtDelQualDstReq;
end // p_DelQualDstSeq

// -----------------------------------------------------------------------------
// In destination-flow-control-mode, when the destination request goes high,
// the TrfSizeSrc counter should be loaded with that many source transfers as
// required by the destination.
// -----------------------------------------------------------------------------
assign LdSrcDstReqHigh  = ( ~(DelQualDstReq) & NxtDelQualDstReq &
                           ~(FifoNonEmpty));

// -----------------------------------------------------------------------------
// In destination flow control mode, if the destination is narrower than source,
// then even for a single request of destination, more data is fetched from the
// source (by virtue of the source being 'wide'). After this, if the destination
// requests for more transfers, then source-fetch should not be done till
// o Fifo is empty and
// o Destination burst is still continuing (implying that destination requires
//   more transfers
// The source-fetch mentioned above is started by a pulse (LdRemSrcTrf) which
// loads the TrfSizeSrc counter. The moment TrfSizeSrc counter is loaded,
// LdRemSrcTrf should go low. Hence the 'TrfSizeSrc being zero' is a factor in
// the generation of LdRemSrcTrf pulse.
// The 'DstDmacState being IDLE' is a factor in LdRemSrcTrf generation, because
// the TrfSizeSrc counter loading should happen only when the DstBurstOn is high
// and the current destination-access has finished. Now,
// Total-destination-access-time = Time for AHB Transfers + Req-clear handshake.
// Thus the DstBurstOn will stay high till the request-clear handshake finishes.
// If the 'DstDmacState being IDLE' is not put as a factor, then an additional
// TrfSizeSrc-counter-loading will happen when the source AHB-Transfers has
// finished but the state-machine is waiting for the req-clear handshake to
// complete.
// -----------------------------------------------------------------------------
assign LdRemSrcTrf      = ((TrfSizeSrc == {12{1'b0}}) && (DstDmacState ==
                           `ST_DST_IDLE)) ? (DstBurstOn & ~(FifoNonEmpty)) :
                           1'b0;

// -----------------------------------------------------------------------------
// In destination flow control mode, during LLI loading, the destination request
// might be raised. The request is ignored when the LLI loading is proceeding.
// However, after LLI loading has finished, the LdAfterLLI pulse is used to load
// TrfSizeSrc (Source transfersize counter).
// -----------------------------------------------------------------------------
assign LdAfterLLI       = FinishedLLI & AllQualDstReq & ~(DMACClrDst);

// -----------------------------------------------------------------------------
// In destination flow control mode, the TrfSizeSrc counter should be loaded
// whenever LdSrcDstReqHigh or LdRemSrcTrf goes high.
// -----------------------------------------------------------------------------
assign LdSrcInDstFlow   = IsDstFlowCntl(FlowCntl[2:1]) ? (LdSrcDstReqHigh |
                           LdRemSrcTrf | LdAfterLLI) : 1'b0;

// -----------------------------------------------------------------------------
// Generating the LLI request.
// o SetLLIReq is asserted by destination state machine. When SetLLIReq is high,
//   the LLI request to the internal arbiter is set.
// o UnsetLLIReq is asserted by LLI load state machine. This signal de-asserts
//   the LLI request. Moreover if the channel is disabled then also the LLI
//   request is de-asserted.
// -----------------------------------------------------------------------------
always @(SetLLIReq or UnsetLLIReq or LLIReq or ChannelEn)
begin : p_LLIReqGenComb
  if (SetLLIReq == 1'b1)
    NextLLIReq       = 1'b1;
  else if ((UnsetLLIReq == 1'b1) || (ChannelEn == 1'b0))
    NextLLIReq       = 1'b0;
  else
    NextLLIReq       = LLIReq;
end // p_LLIReqGenComb

// -----------------------------------------------------------------------------
// Sequential block for p_LLIReqGenComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LLIReqGenSeq
  if (HRESETn == 1'b0)
    LLIReq           <= 1'b0;
  else
    LLIReq           <= NextLLIReq;
end // p_LLIReqGenSeq

// -----------------------------------------------------------------------------
// The linked list load request is de-multiplexed to AHB1 or AHB2 depending of
// value of LLISelForPkt.
// -----------------------------------------------------------------------------
assign LLIReqM1     = (LLISelForPkt == 1'b0) ? LLIReq : 1'b0;

assign LLIReqM2     = (LLISelForPkt == 1'b1) ? LLIReq : 1'b0;

// -----------------------------------------------------------------------------
// Final channel request to AHB1 is the logical OR of source, destination and
// LLI block requests.
// -----------------------------------------------------------------------------
assign ChReqM1          = SrcReqM1 | DstReqM1 | LLIReqM1;

// -----------------------------------------------------------------------------
// Final channel request to AHB2 is the logical OR of source, destination and
// LLI block requests.
// -----------------------------------------------------------------------------
assign ChReqM2          = SrcReqM2 | DstReqM2 | LLIReqM2;

// -----------------------------------------------------------------------------
// The one-bit signals from the channel logic DMACTCSrc and DMACClrSrc are
// passed to corresponding peripheral Source peripheral TC and CLR port
// -----------------------------------------------------------------------------
always @(SrcPeriph or DMACTCSrc or DMACClrSrc)
begin : p_TCClrSrcComb
  SigTCSrc         = 16'b0000000000000000;
  ClearReqSrc      = 16'b0000000000000000;
  case (SrcPeriph)
    4'b0000 :
      begin
        SigTCSrc[0]     = DMACTCSrc;
        ClearReqSrc[0]  = DMACClrSrc;
      end

    4'b0001 : 
      begin
        SigTCSrc[1]     = DMACTCSrc;
        ClearReqSrc[1]  = DMACClrSrc;
      end

    4'b0010 : 
      begin
        SigTCSrc[2]     = DMACTCSrc;
        ClearReqSrc[2]  = DMACClrSrc;
      end

    4'b0011 : 
      begin
        SigTCSrc[3]     = DMACTCSrc;
        ClearReqSrc[3]  = DMACClrSrc;
      end

    4'b0100 : 
      begin
        SigTCSrc[4]     = DMACTCSrc;
        ClearReqSrc[4]  = DMACClrSrc;
      end

    4'b0101 : 
      begin
        SigTCSrc[5]     = DMACTCSrc;
        ClearReqSrc[5]  = DMACClrSrc;
      end

    4'b0110 : 
      begin
        SigTCSrc[6]     = DMACTCSrc;
        ClearReqSrc[6]  = DMACClrSrc;
      end

    4'b0111 : 
      begin
        SigTCSrc[7]     = DMACTCSrc;
        ClearReqSrc[7]  = DMACClrSrc;
      end

    4'b1000 : 
      begin
        SigTCSrc[8]     = DMACTCSrc;
        ClearReqSrc[8]  = DMACClrSrc;
      end

    4'b1001 : 
      begin
        SigTCSrc[9]     = DMACTCSrc;
        ClearReqSrc[9]  = DMACClrSrc;
      end

    4'b1010 : 
      begin
        SigTCSrc[10]    = DMACTCSrc;
        ClearReqSrc[10] = DMACClrSrc;
      end

    4'b1011 : 
      begin
        SigTCSrc[11]    = DMACTCSrc;
        ClearReqSrc[11] = DMACClrSrc;
      end

    4'b1100 : 
      begin
        SigTCSrc[12]    = DMACTCSrc;
        ClearReqSrc[12] = DMACClrSrc;
      end

    4'b1101 : 
      begin
        SigTCSrc[13]    = DMACTCSrc;
        ClearReqSrc[13] = DMACClrSrc;
      end

    4'b1110 : 
      begin
        SigTCSrc[14]    = DMACTCSrc;
        ClearReqSrc[14] = DMACClrSrc;
      end

    4'b1111 : 
      begin
        SigTCSrc[15]    = DMACTCSrc;
        ClearReqSrc[15] = DMACClrSrc;
      end

    default : ;
  endcase
end // p_TCClrSrcComb

// -----------------------------------------------------------------------------
// The one-bit signals from the channel logic DMACTCDst and DMACClrDst are
// passed to corresponding peripheral Source peripheral TC and CLR port
// -----------------------------------------------------------------------------
always @(DstPeriph or DMACTCDst or DMACClrDst)
begin : p_TCClrDstComb
  SigTCDst         = 16'b0000000000000000;
  ClearReqDst      = 16'b0000000000000000;
  case (DstPeriph)
    4'b0000 :
      begin
        SigTCDst[0]     = DMACTCDst;
        ClearReqDst[0]  = DMACClrDst;
      end

    4'b0001 : 
      begin
        SigTCDst[1]     = DMACTCDst;
        ClearReqDst[1]  = DMACClrDst;
      end

    4'b0010 : 
      begin
        SigTCDst[2]     = DMACTCDst;
        ClearReqDst[2]  = DMACClrDst;
      end

    4'b0011 : 
      begin
        SigTCDst[3]     = DMACTCDst;
        ClearReqDst[3]  = DMACClrDst;
      end

    4'b0100 : 
      begin
        SigTCDst[4]     = DMACTCDst;
        ClearReqDst[4]  = DMACClrDst;
      end

    4'b0101 : 
      begin
        SigTCDst[5]     = DMACTCDst;
        ClearReqDst[5]  = DMACClrDst;
      end

    4'b0110 : 
      begin
        SigTCDst[6]     = DMACTCDst;
        ClearReqDst[6]  = DMACClrDst;
      end

    4'b0111 : 
      begin
        SigTCDst[7]     = DMACTCDst;
        ClearReqDst[7]  = DMACClrDst;
      end

    4'b1000 : 
      begin
        SigTCDst[8]     = DMACTCDst;
        ClearReqDst[8]  = DMACClrDst;
      end

    4'b1001 : 
      begin
        SigTCDst[9]     = DMACTCDst;
        ClearReqDst[9]  = DMACClrDst;
      end

    4'b1010 : 
      begin
        SigTCDst[10]    = DMACTCDst;
        ClearReqDst[10] = DMACClrDst;
      end

    4'b1011 : 
      begin
        SigTCDst[11]    = DMACTCDst;
        ClearReqDst[11] = DMACClrDst;
      end

    4'b1100 : 
      begin
        SigTCDst[12]    = DMACTCDst;
        ClearReqDst[12] = DMACClrDst;
      end

    4'b1101 : 
      begin
        SigTCDst[13]    = DMACTCDst;
        ClearReqDst[13] = DMACClrDst;
      end

    4'b1110 : 
      begin
        SigTCDst[14]    = DMACTCDst;
        ClearReqDst[14] = DMACClrDst;
      end

    4'b1111 : 
      begin
        SigTCDst[15]    = DMACTCDst;
        ClearReqDst[15] = DMACClrDst;
      end

    default : ;
  endcase
end // p_TCClrDstComb

// -----------------------------------------------------------------------------
// The SigTC and ClearReq are obtained by ORing the Sig(TC/Clr)Src and
// Sig(TC/Clr)Dst.
// -----------------------------------------------------------------------------
assign SigTC            = SigTCSrc | SigTCDst;
assign ClearReq         = ClearReqSrc | ClearReqDst;

// -----------------------------------------------------------------------------
// The SetIntErr is clocked into RegSetIntErr and RegSetIntErr is used to
// generate ErrClrReq. This is done for better synthesis timings.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RegErrClrSeq
  if (HRESETn == 1'b0)
    RegSetIntErr     <= 1'b0;
  else
    RegSetIntErr     <= SetIntErr;
end // p_RegErrClrSeq

// -----------------------------------------------------------------------------
// The ErrClrSrc pulse should not be given if the target is a memory. In the
// case of memory, an arbitrary value might be written into the SrcPeriph field.
// Giving an ErrClr in this case might reset some valid peripheral's soft
// request. So the RegSetIntErr is 'validated' with the 'target being a memory'.
// -----------------------------------------------------------------------------
assign ValidErrSrc      = ~(IsSrcMemory(FlowCntl)) ? RegSetIntErr    : 1'b0;

// -----------------------------------------------------------------------------
// The one-bit signal from the channel logic (ValidErrSrc) is replicated 16
// times (as many times as number of requestors), so that the 16-bit signal can
// be bitwise ANDed with SrcDecode. This type of implementation effectively
// infers a 1 to 16 "demux", but leaves SrcDecode free for reusing in other
// "muxes" and "demuxes", where the select lines are the same (i.e. SrcPeriph).
// -----------------------------------------------------------------------------
assign OnAllValidErrSrc = {16{ValidErrSrc}};

// -----------------------------------------------------------------------------
// The error-clear-pulse (corresponding to the source) is demuxed to one of the
// 16 ErrClrReq lines. On receiving error-response, the Clear and TC lines are
// not toggled. The peripheral which gave an error response will be reprogrammed
// by software and hence non-assertion of clear does not 'hurt' the peripheral.
// But if the requests are being raised through soft-request-registers, then it
// is the responsibility of the DMAC to reset the set SoftRequest bits. To clear
// the soft-request bits, the ErrClrSrc pulse is generated.
// -----------------------------------------------------------------------------
assign ErrClrSrc        = OnAllValidErrSrc & SrcDecode;

// -----------------------------------------------------------------------------
// The ErrClrDst pulse should not be given if the target is a memory. In the
// case of memory, an arbitrary value might be written into the DstPeriph field.
// Giving an ErrClr in this case might reset some valid peripheral's soft
// request. So the RegSetIntErr is 'validated' with the 'target being a memory'.
// -----------------------------------------------------------------------------
assign ValidErrDst      = ~(IsDstMemory(FlowCntl)) ? RegSetIntErr    : 1'b0;

// -----------------------------------------------------------------------------
// The one-bit signal from channel logic (ValidErrDst) is replicated 16 times
// (as many times as number of requestors), so that the 16-bit signal can be
// bitwise ANDed with DstDecode. This type of implementation effectively infers
// a 1 to 16 "demux", but leaves DstDecode free for reusing in other "muxes"
// and "demuxes", where the select lines are the same (i.e. DstPeriph).
// -----------------------------------------------------------------------------
assign OnAllValidErrDst = {16{ValidErrDst}};

// -----------------------------------------------------------------------------
// The error-clear-pulse (corresponding to the destination) is demuxed to one of
// the 16 ErrClrReq lines.
// -----------------------------------------------------------------------------
assign ErrClrDst        = OnAllValidErrDst & DstDecode;

// -----------------------------------------------------------------------------
// The final ErrClrReq is obtained by ORing ErrClrSrc and ErrClrDst. By ORing
// both source and destination "ErrClr"s are preserved.
// -----------------------------------------------------------------------------
assign ErrClrReq        = ErrClrSrc | ErrClrDst;

// -----------------------------------------------------------------------------
// The following process is the combinational portion for raw-error-interrupt
// generation.
// -----------------------------------------------------------------------------
always @(RegSetIntErr or ClrIntErr or RawIntErrCh)
begin : p_ErrIntRawComb
  // Raw interrupt is set, when the channel logic asserts the RegSetIntErr.
  // If clear and setting of interrupt are simultaneously high, preference is
  // given to the setting of the interrupt.
  if (RegSetIntErr == 1'b1)
    NextRawIntErrCh  = 1'b1;
  // Raw interrupt is cleared with a ClrIntErr from AHB Slave interface.
  else if (ClrIntErr == 1'b1)
    NextRawIntErrCh  = 1'b0;
  else
    NextRawIntErrCh  = RawIntErrCh;
end // p_ErrIntRawComb

// -----------------------------------------------------------------------------
// Sequential block for p_ErrIntRawComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ErrIntRawSeq
  if (HRESETn == 1'b0)
    RawIntErrCh      <= 1'b0;
  else
    RawIntErrCh      <= NextRawIntErrCh;
end // p_ErrIntRawSeq

// -----------------------------------------------------------------------------
// Raw interrupt is masked with Error-interrupt-mask bit in Channel-Config
// register and given as IntErrCh.
// -----------------------------------------------------------------------------
assign IntErrCh         = RawIntErrCh & ErrIntMask;

// -----------------------------------------------------------------------------
// The following process is the combinational portion for raw-TC-interrupt
// generation.
// -----------------------------------------------------------------------------
always @(SetIntTC or ClrIntTC or RawIntTCCh)
begin : p_TCIntRawComb
  // Raw interrupt is set, when the channel logic asserts the SetIntTC.
  // If clear and setting of interrupt are simultaneously high, preference is
  // given to the setting of the interrupt.
  if (SetIntTC == 1'b1)
    NextRawIntTCCh   = 1'b1;
  // Raw interrupt is cleared with a ClrIntTC from AHB Slave interface.
  else if (ClrIntTC == 1'b1)
    NextRawIntTCCh   = 1'b0;
  else
    NextRawIntTCCh   = RawIntTCCh;
end // p_TCIntRawComb

// -----------------------------------------------------------------------------
// Sequential block for p_TCIntRawComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TCIntRawSeq
  if (HRESETn == 1'b0)
    RawIntTCCh       <= 1'b0;
  else
    RawIntTCCh       <= NextRawIntTCCh;
end // p_TCIntRawSeq

// -----------------------------------------------------------------------------
// Raw interrupt is masked with TC-interrupt-mask bit in Channel-Control
// register and given as IntTCCh.
// -----------------------------------------------------------------------------
assign IntTCCh          = RawIntTCCh & TCIntMask;

// -----------------------------------------------------------------------------
// The following block generates one clock delayed version of DstReqM1,
// SrcReqM1 and LLIReqM1. The DmacArbiter block resolves the priority
// between channels and grants a single channel. The grant is issued one clock
// after the request is raised. The finer resolution of the grant to indicate a
// source/destination/LLI start is done on the basis of one-clock-delayed
// version of DstReqM1, SrcReqM1 and LLIReqM1 since the request
// was raised one clock earlier.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_Rq1CkDlyM1Comb
  if (HRESETn == 1'b0)
    begin
      DstReqM1Q2       <= 1'b0;
      SrcReqM1Q2       <= 1'b0;
      LLIReqM1Q2       <= 1'b0;
    end
  else
    begin
      DstReqM1Q2       <= DstReqM1;
      SrcReqM1Q2       <= SrcReqM1;
      LLIReqM1Q2       <= LLIReqM1;
    end
end // p_Rq1CkDlyM1Comb;

// -----------------------------------------------------------------------------
// On getting the grant from Internal arbiter, either source-DMAC, DMAC-
// destination or the LLI-load logic is granted access on AHB, depending on
// which request is raised.
// In case both source and destination requests are raised, grant is given to
// the destination.
// LLI request should not be asserted along with the source or destination
// requests.
// The following block deciphers the grant for AHB Master 1.
// -----------------------------------------------------------------------------
always @(ChGntM1 or DstReqM1Q2 or SrcReqM1Q2 or LLIReqM1Q2)
begin : p_GntDcpher1Comb
  SrcStartM1       = 1'b0;
  DstStartM1       = 1'b0;
  LLIStartM1       = 1'b0;
  if (ChGntM1 == 1'b1)
    begin
      // If both destination and source requests are active, the destination is
      // given preference.
      if (DstReqM1Q2 == 1'b1)
        DstStartM1       = 1'b1;
      else if (SrcReqM1Q2 == 1'b1)
        SrcStartM1       = 1'b1;
      else if (LLIReqM1Q2 == 1'b1)
        LLIStartM1       = 1'b1;
    end
end // p_GntDcpher1Comb

// -----------------------------------------------------------------------------
// The following block generates one clock delayed version of DstReqM2,
// SrcReqM2 and LLIReqM2. The DmacArbiter block resolves the priority
// between channels and grants a single channel which comes one clock after
// the request is raised. The finer resolution of the grant to indicate a
// source/destination/LLI start is done on the basis of one clock delayed
// version of DstReqM2, SrcReqM2 and LLIReqM2 since the request
// was raised one clock earlier.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_Rq1CkDlyM2Comb
  if (HRESETn == 1'b0)
    begin
      DstReqM2Q2       <= 1'b0;
      SrcReqM2Q2       <= 1'b0;
      LLIReqM2Q2       <= 1'b0;
    end
  else
    begin
      DstReqM2Q2       <= DstReqM2;
      SrcReqM2Q2       <= SrcReqM2;
      LLIReqM2Q2       <= LLIReqM2;
    end
end // p_Rq1CkDlyM2Comb

// -----------------------------------------------------------------------------
// On getting the grant from Internal arbiter, either source-DMAC, DMAC-
// destination or the LLI-load logic is granted access on AHB, depending on
// which request is raised.
// In case both source and destination requests are raised, grant is given to
// the destination.
// LLI request should not be asserted along with the source or destination
// requests.
// The following block deciphers the grant for AHB Master 2.
// -----------------------------------------------------------------------------
always @(ChGntM2 or DstReqM2Q2 or SrcReqM2Q2 or LLIReqM2Q2)
begin : p_GntDcpher2Comb
   SrcStartM2       = 1'b0;
   DstStartM2       = 1'b0;
   LLIStartM2       = 1'b0;
  if (ChGntM2 == 1'b1)
    begin
      // If both destination and source requests are active, the destination is
      // given preference.
      if (DstReqM2Q2 == 1'b1)
        DstStartM2       = 1'b1;
      else if (SrcReqM2Q2 == 1'b1)
        SrcStartM2       = 1'b1;
      else if (LLIReqM2Q2 == 1'b1)
        LLIStartM2       = 1'b1;
    end
end // p_GntDcpher2Comb

// -----------------------------------------------------------------------------
// The start trigger for the state machines (Source transfer, destination
// transfer, LLI load) may come from any of the AHB buses. Thus a logical OR
// of the 'Start' signals is done.
// -----------------------------------------------------------------------------
assign SrcStart         = SrcStartM1 | SrcStartM2;
assign DstStart         = DstStartM1 | DstStartM2;
assign LLIStart         = LLIStartM1 | LLIStartM2;

// -----------------------------------------------------------------------------
// The following process routes the internal arbiter related signals.
// -----------------------------------------------------------------------------
always @(DstNumOfXfers or DMACChDstAddr or ProtStat or DWidth or SrcNumOfXfers
         or DMACChSrcAddr or SWidth or LLIAddressUB or DstReqM1 or
         SrcReqM1 or SrcIncr or DestIncr)
begin : p_SignalRtM1Comb
  // If both destination and source requests are active, the destination is
  // given preference.
  if (DstReqM1 == 1'b1)
    begin
      ChNumOfXfersM1   = DstNumOfXfers;
      ChIncrM1         = DestIncr;
      ChAddrM1         = DMACChDstAddr;
      ChProtM1         = ProtStat;
      ChWidthM1        = DWidth;
      ChDirxnM1        = 1'b1;
    end
  else if (SrcReqM1 == 1'b1)
    begin
      ChNumOfXfersM1   = SrcNumOfXfers;
      ChIncrM1         = SrcIncr;
      ChAddrM1         = DMACChSrcAddr;
      ChProtM1         = ProtStat;
      ChWidthM1        = SWidth;
      ChDirxnM1        = 1'b0;
    end
  // when LLIReqM1 is '1' or default-condition, the LLI related values are
  // driven on the Channel lines.
  else
    begin
      ChNumOfXfersM1   = 5'b00100;
      ChIncrM1         = 1'b1;
      ChAddrM1         = {LLIAddressUB, 2'b00};
      // In case of LLI loading, the LSB of the HPROT lines should be '1', to
      // indicate privileged access. The next bit should be '0' indicating
      // non-bufferable and the MSB should be '1' indicating cacheable.
      ChProtM1         = 3'b101;
      ChWidthM1        = 3'b010;
      ChDirxnM1        = 1'b0;
    end
end // p_SignalRtM1Comb

// -----------------------------------------------------------------------------
// The following process routes the internal arbiter related signals.
// -----------------------------------------------------------------------------
always @(DstNumOfXfers or DMACChDstAddr or ProtStat or DWidth or SrcNumOfXfers
         or DMACChSrcAddr or SWidth or LLIAddressUB or DstReqM2 or
         SrcReqM2 or SrcIncr or DestIncr)
begin : p_SignalRtM2Comb
  // If both destination and source requests are active, the destination is
  // given preference.
  if (DstReqM2 == 1'b1)
    begin
      ChNumOfXfersM2   = DstNumOfXfers;
      ChIncrM2         = DestIncr;
      ChAddrM2         = DMACChDstAddr;
      ChProtM2         = ProtStat;
      ChWidthM2        = DWidth;
      ChDirxnM2        = 1'b1;
    end
  else if (SrcReqM2 == 1'b1)
    begin
      ChNumOfXfersM2   = SrcNumOfXfers;
      ChIncrM2         = SrcIncr;
      ChAddrM2         = DMACChSrcAddr;
      ChProtM2         = ProtStat;
      ChWidthM2        = SWidth;
      ChDirxnM2        = 1'b0;
    end
  // when LLIReqM2 is '1' or default-condition, the LLI related values are
  // driven on the Channel lines.
  else
    begin
      ChNumOfXfersM2   = 5'b00100;
      ChIncrM2         = 1'b1;
      ChAddrM2         = {LLIAddressUB, 2'b00};
      // In case of LLI loading, the LSB should be '1', to indicate privileged
      // access. The next should be '0' indicating non-bufferable and the MSB
      // should be '1' indicating cacheable.
      ChProtM2         = 3'b101;
      ChWidthM2        = 3'b010;
      ChDirxnM2        = 1'b0;
    end
end // p_SignalRtM2Comb

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// In case of a P2P transfer, the same request line should not be used for a
// channel's source and destination ports. In case of one side being a memory,
// the check is not done as the Src/DstPeriph field are immaterial when one
// the device is a memory.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_SrcDstSameProt
  if (ChannelEn == 1'b1)
    if ((FlowCntl == `P2P_DMA) || (FlowCntl == `P2P_SRC) ||
        (FlowCntl == `P2P_DST))
      if (SrcPeriph == DstPeriph)
        $display($time, "DmacChReqProc1 : Src and Dest map to the same",
                 " requestor");
end // p_SrcDstSameProt

// -----------------------------------------------------------------------------
// This is an internal signal monitoring block. There are two signals,
// AbortReqSrcM1 and AbortReqDstM1, which should not be high at the same time.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_SimulAbortProt
  if ((AbortReqSrcM1 == 1'b1) && (AbortReqDstM1 == 1'b1))
    $display($time, "DmacChReqProc2 : Src and Dst abort asserted at the same",
             " time");
end // p_SimulAbortProt

// -----------------------------------------------------------------------------
// LLI request should not be asserted along with source-request or destination
// request.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_SrcDstLLIProt
    if (((SourceRequest & LLIReq) == 1'b1) || ((DestRequest & LLIReq) == 1'b1))
      $display($time, "DmacChReqProc3: LLIreq asserted with source/destination",
               " request");
end // p_SrcDstLLIProt

// -----------------------------------------------------------------------------
// This block flags off a warning, if a request that is not pertinent to the
// channel in a particular flow-control mode, is raised. For example if a
// destination SREQ is raised in DMAC flow control mode, then it does not have
// any effect. The list of FlowControl information, and the source and
// destination requests, that are impertinent to that flow-control mode is given
// as follows.
// FlowCntl        Source Requests        Destination Requests
//                 impertinent            impertinent
// --------        ---------------        --------------------
// M2M-DMA         S, LS, B, LB           S, LS, B, LB
// M2P-DMA         S, LS, B, LB           S, LS, LB
// P2M-DMA         LS, LB                 S, LS, B, LB
// P2P-DMA         LS, LB                 S, LS, LB
// P2P-DST         LS, LB                 -
// M2P-DST         S, LS, B, LB           -
// P2M-SRC         -                      S, LS, B, LB
// P2P-SRC         -                      S, LS, LB
// Whenever the request becomes impertinent due to the source/target device
// being a memory, then no warning messages are flashed.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_ImproperRqProt
    if ((FlowCntl == `M2P_DMA) && (ChannelEn == 1'b1))
      if ((ChDstSReq | ChDstLSReq | ChDstLBReq) == 1'b1)
        $display($time, "Warning: DmacChReqProc4 : S/LS/LB Dst request",
                 " asserted in M2P_DMA");

    if ((FlowCntl == `P2M_DMA) && (ChannelEn == 1'b1))
      if ((ChSrcLSReq | ChSrcLBReq) == 1'b1)
        $display($time, "Warning: DmacChReqProc5: LS/LB Source request",
                 " asserted in P2M_DMA");

    if ((FlowCntl == `P2P_DMA) && (ChannelEn == 1'b1))
    begin
      if ((ChSrcLSReq | ChSrcLBReq) == 1'b1)
        $display($time, "Warning: DmacChReqProc6: LS/LB Source request",
                 " asserted in P2P_DMA");
      if ((ChDstSReq | ChDstLSReq | ChDstLBReq) == 1'b1)
        $display($time, "Warning: DmacChReqProc7: S/LS/LB Dest request",
                 " asserted in P2P_DMA");
    end

    if ((FlowCntl == `P2P_DST) && (ChannelEn == 1'b1))
      if ((ChSrcLSReq | ChSrcLBReq) == 1'b1)
        $display($time, "Warning: DmacChReqProc8: LS/LB Source request",
                 " asserted in P2P_DST");

    if ((FlowCntl == `P2P_SRC) && (ChannelEn == 1'b1))
      if ((ChDstSReq | ChDstLSReq | ChDstLBReq) == 1'b1)
        $display($time, "Warning: DmacChReqProc9: S/LS/LB Dest request",
                 " asserted in P2P_SRC");
end // p_ImproperRqProt

// -----------------------------------------------------------------------------
// The following block flashes a note when in a narrow-destination-flow-control
// configuration, the LdRemSrcTrf pulse causes the loading of TrfSizeSrc
// counter. This MAY lead to data getting stuck and lost in DMAC FIFO if the
// destination request is an LB/LSReq.
// -----------------------------------------------------------------------------
always @(posedge HCLK)
begin : p_LdRmSrcTrfProt
  if (LdRemSrcTrf == 1'b1)
    $display($time, "DmacChReqProc10: Data may be stuck and lost in DMAC FIFO");
end // p_LdRmSrcTrfProt

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule

// --================================== End ==================================--
