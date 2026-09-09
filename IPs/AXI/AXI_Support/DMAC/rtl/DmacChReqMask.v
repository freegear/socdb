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
// File Name              : DmacChReqMask.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This file describes the masks to be put on channel transfer
//           requests.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacChReqMask (
// Inputs
                      // AHB Signals
                      HCLK,
                      HRESETn,
                      // From DmacChSrcXfer block
                      SetErrMskSrc,
                      SetSrcE2LMsk,
                      SetSrcAxsOnMsk,
                      UnsetSrcAxsOnMsk,
                      ErrCycMaskSrc,
                      // From DmacChDstXfer block
                      SetErrMskDst,
                      SetLLILoadMsk,
                      SetDstAxsOnMsk,
                      UnsetDstAxsOnMsk,
                      ErrCycMaskDst,
                      // From DmacChRegBlock
                      UnsetErrMsk,
                      ChannelEn,
                      TrfSizeSrc,
                      FlowCntl2MSB,
                      SourceEn,
                      DestEn,
                      DisabledSrc,
                      TrfSizeDst,
                      DisabledDst,
                      // From DmacChLLILoad block
                      UnsetSrcE2LMsk,
                      UnsetLLILoadMsk,
                      Halt,
                      // From DmacChPckUnpck block
                      ActEmptyLevel,
                      ActFillLevel,
                      // From DmacChReqProc block
                      ChDstBReq,
                      ChDstLBReq,
                      ChDstSReq,
                      ChDstLSReq,
                      LdSrcInDstFlow,

// Outputs
                      // To DmacChReqProc block
                      SourceMask,
                      DestMask
                     );

// Inputs
// AHB Signals
input         HCLK;             // AHB Clock
input         HRESETn;          // AHB Reset
// From DmacChSrcXfer block
input         SetErrMskSrc;     // Sets a mask on source and dest when there
                                // is an error during source transfers
input         SetSrcE2LMsk;     // Sets a mask on source request from
                                // source-end to actual disable
input         SetSrcAxsOnMsk;   // Sets the access-on mask
input         UnsetSrcAxsOnMsk; // Resets the access-on mask
input         ErrCycMaskSrc;    // Masks the channel requests during second
                                // cycle of the AHB error response
// From DmacChDstXfer block
input         SetErrMskDst;     // Masks both source and destination requests
                                // in case of error
input         SetLLILoadMsk;    // Sets the mask on source/dest request during
                                // LLI load
input         SetDstAxsOnMsk;   // Sets destination-access-on mask
input         UnsetDstAxsOnMsk; // Unsets destination-access-on mask
input         ErrCycMaskDst;    // Masks the channel requests during second
                                // cycle of the AHB error response
// From DmacChRegBlock
input         UnsetErrMsk;      // Unsets the ErrMsk
input         ChannelEn;        // Channel Enable
input  [11:0] TrfSizeSrc;       // Indicates the number of source transfers to
                                // perform
input   [2:1] FlowCntl2MSB;     // Two MSBs of flow control information
input         SourceEn;         // Source Enabled
input         DestEn;           // Destination Enabled
input         DisabledSrc;      // Source disabled
input  [13:0] TrfSizeDst;       // Transfer size value for the
                                // destination-transfer-logic
input         DisabledDst;      // Destination disabled
// From DmacChLLILoad block
input         UnsetSrcE2LMsk;   // Unsets source-end to
                                // "actual-disable/LLI-load" mask
input         UnsetLLILoadMsk;  // Unsets LLI load mask
input         Halt;             // User mask for source requests
// From DmacChPckUnpck block
input   [4:0] ActEmptyLevel;    // Number of space empty in FIFO in terms of
                                // Source Width
input   [4:0] ActFillLevel;     // Number of spaces filled in FIFO in terms of
                                // destination Width
// From DmacChReqProc block
input         ChDstBReq;        // Destination Burst Request for the channel
input         ChDstLBReq;       // Destination Last Burst Request for the
                                // channel
input         ChDstSReq;        // Destination Single Request for the channel
input         ChDstLSReq;       // Destination Last Single Request
input         LdSrcInDstFlow;   // Indicates that the TrfSizeSrc register can
                                // be loaded with destination required number

// Outputs
// To DmacChReqProc block
output        SourceMask;       // Final source mask
output        DestMask;         // Final destination mask

// Inputs
// AHB Signals
wire          HCLK;             // AHB Clock
wire          HRESETn;          // AHB Reset
// From DmacChSrcXfer block
wire          SetErrMskSrc;     // Sets a mask on source and dest when there
                                // is an error during source transfers
wire          SetSrcE2LMsk;     // Sets a mask on source request from
                                // source-end to actual disable
wire          SetSrcAxsOnMsk;   // Sets the access-on mask
wire          UnsetSrcAxsOnMsk; // Resets the access-on mask
wire          ErrCycMaskSrc;    // Masks the channel requests during second
                                // cycle of the AHB error response
// From DmacChDstXfer block
wire          SetErrMskDst;     // Masks both source and destination requests
                                // in case of error
wire          SetLLILoadMsk;    // Sets the mask on source/dest request during
                                // LLI load
wire          SetDstAxsOnMsk;   // Sets destination-access-on mask
wire          UnsetDstAxsOnMsk; // Unsets destination-access-on mask
wire          ErrCycMaskDst;    // Masks the channel requests during second
                                // cycle of the AHB error response
// From DmacChRegBlock
wire          UnsetErrMsk;      // Unsets the ErrMsk
wire          ChannelEn;        // Channel Enable
wire   [11:0] TrfSizeSrc;       // Indicates the number of source transfers to
                                // perform
wire    [2:1] FlowCntl2MSB;     // Two MSBs of flow control information
wire          SourceEn;         // Source Enabled
wire          DestEn;           // Destination Enabled
wire          DisabledSrc;      // Source disabled
wire   [13:0] TrfSizeDst;       // Transfer size value for the
                                // destination-transfer-logic
wire          DisabledDst;      // Destination disabled
// From DmacChLLILoad block
wire          UnsetSrcE2LMsk;   // Unsets source-end to
                                // "actual-disable/LLI-load" mask
wire          UnsetLLILoadMsk;  // Unsets LLI load mask
wire          Halt;             // User mask for source requests
// From DmacChPckUnpck block
wire    [4:0] ActEmptyLevel;    // Number of space empty in FIFO in terms of
                                // Source Width
wire    [4:0] ActFillLevel;     // Number of spaces filled in FIFO in terms of
                                // destination Width
// From DmacChReqProc block
wire          ChDstBReq;        // Destination Burst Request for the channel
wire          ChDstLBReq;       // Destination Last Burst Request for the
                                // channel
wire          ChDstSReq;        // Destination Single Request for the channel
wire          ChDstLSReq;       // Destination Last Single Request
wire          LdSrcInDstFlow;   // Indicates that the TrfSizeSrc register can
                                // be loaded with destination required number

// Outputs
// To DmacChReqProc block
wire          SourceMask;       // Final source mask
wire          DestMask;         // Final destination mask

// -----------------------------------------------------------------------------
//
//                                DmacChReqMask
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This file describes several masks and then uses a combination of all these
// masks to gate the channel transfer requests. The masks that are described
// in this file are as follows:
// o CompositeErrMask : Set by both source and destination machines if the data
//   transfer is returned an error response.
// o SrcE2LMask : Source-Transfer-End to LLI load mask. This is used in
//   source-flow control mode. After the Source transfers for a packet have
//   finished, no more source requests should be serviced unless the destination
//   transfer for the packet finishes.
// o SrcAxsOnMask: When the AHB transfers corresponding to a source-request have
//   started, no more source requests should be serviced until the transfer
//   finishes. This is taken care of by SrcAxsOnMask.
// o LLILoadMask: When the LLI loading is proceeding, no source or destination
//   transfers should be started off with. This is taken care of by the
//   LLILoadMask.
// o DstAxsOnMask: When the AHB transfers corresponding to a destination-request
//   have started, no more destination requests should be serviced until the
//   transfer finishes. This is taken care of by DstAxsOnMask, which prevents
//   the same destination request from triggering off one more access.
// o SrcTrfSizeMask: Ensures that in DMAC flow control mode, no transfer starts
//   off when TrfSize programmed is zero.
// o FifoSrcMask: When there are no empty spaces in the FIFO to accommodate
//   source data, then in spite of requests, AHB transfers should not start off.
//   This is taken care of by FifoSrcMask.
// o DestNonReqMask: In destination flow control case, unless a destination
//   request is raised, no source transfers should start off. This is taken care
//   of by the DestNonReqMask.
// o FifoDstMask: When there are no data in the FIFO to start destination
//   transfers, then in spite of requests, AHB transfers should not start off.
//   This is taken care of by FifoDstMask.
// o DstTrfSizeMask: This is for masking destination accesses on AHB when
//   destination transfer size counter is zero (in Dmac Flow control mode).
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire     CompositeErrMask;
// Combination of ErrorMask, ErrCycMaskDst and ErrCycMaskSrc (the mask is set
// during the second cycle of error response on other AHB bus)

wire     SrcTrfSizeMask;
// Mask when source transfer-size is zero in DMAC flow control mode

wire     FifoSrcMask;
// Mask when FIFO is full and can not accept source transfers

wire     DestNonReqMask;
// When none of the destination requests are high in destination-flow-control
// mode, the source requests should be masked

wire     FifoDstMask;
// Mask when FIFO is empty and destination transfers can not take place

wire     DstTrfSizeMask;
// Mask when destination transfer-size is zero in DMAC flow control mode

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg      ErrorMask;
// Error mask on source and destination requests set after the completion of
// second cycle of error response

reg      NextErrorMask;
// D-input of ErrorMask

reg      SrcE2LMask;
// Source-End to LLI-Load mask on source requests

reg      NextSrcE2LMask;
// D-input of SrcE2LMask

reg      SrcAxsOnMask;
// Source access on mask

reg      NextSrcAxsOnMask;
// D-input of SrcAxsOnMask

reg      NextLLILoadMask;
// D-input for LLILoadMask

reg      DstAxsOnMask;
// Destination access on mask

reg      NextDstAxsOnMask;
// D-input of DstAxsOnMask

reg      LLILoadMask;
// LLI Load mask on both source and destination

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
// The following process describes ErrorMask.
// The mask is set when
// o SetErrMskSrc is high OR
// o SetErrMskDst is high.
// The mask is unset when
// o UnsetErrMsk is high.
// -----------------------------------------------------------------------------
always @(ErrorMask or SetErrMskSrc or SetErrMskDst or UnsetErrMsk)
begin : p_ErrMaskComb
   NextErrorMask    = ErrorMask;
  if ((SetErrMskSrc | SetErrMskDst) == 1'b1)
    NextErrorMask    = 1'b1;
  else if (UnsetErrMsk == 1'b1)
    NextErrorMask    = 1'b0;
end // p_ErrMaskComb

// -----------------------------------------------------------------------------
// The following process describes the SrcE2LMask.
// The mask is set when
// o SetSrcE2LMsk is high
// The mask is unset when
// o UnsetSrcE2LMsk is high or Channel-Enable goes low.
// -----------------------------------------------------------------------------
always @(SetSrcE2LMsk or UnsetSrcE2LMsk or SrcE2LMask or ChannelEn)
begin : p_SrcE2LMaskComb
   NextSrcE2LMask   = SrcE2LMask;
  if (SetSrcE2LMsk == 1'b1)
    NextSrcE2LMask   = 1'b1;
  else if ((UnsetSrcE2LMsk == 1'b1) || (ChannelEn == 1'b0))
    NextSrcE2LMask   = 1'b0;
end // p_SrcE2LMaskComb

// -----------------------------------------------------------------------------
// The following process describes the SrcAxsOnMask.
// The mask is set when
// o SetSrcAxsOnMsk is high
// The mask is unset when
// o UnsetSrcAxsOnMsk is high.
// -----------------------------------------------------------------------------
always @(SetSrcAxsOnMsk or UnsetSrcAxsOnMsk or SrcAxsOnMask)
begin : p_SrAxsOnMskComb
  NextSrcAxsOnMask = SrcAxsOnMask;
  if (SetSrcAxsOnMsk == 1'b1)
    NextSrcAxsOnMask = 1'b1;
  else if (UnsetSrcAxsOnMsk == 1'b1)
    NextSrcAxsOnMask = 1'b0;
end // p_SrAxsOnMskComb

// -----------------------------------------------------------------------------
// The following process describes the LLILoadMask.
// The mask is set when
// o SetLLILoadMsk is high
// The mask is unset when
// o UnsetLLILoadMsk is high or Channel-Enable goes low.
// -----------------------------------------------------------------------------
always @(SetLLILoadMsk or UnsetLLILoadMsk or LLILoadMask or ChannelEn)
begin : p_LLILoadMskComb
   NextLLILoadMask  = LLILoadMask;
  if (SetLLILoadMsk == 1'b1)
    NextLLILoadMask  = 1'b1;
  else if ((UnsetLLILoadMsk == 1'b1) || (ChannelEn == 1'b0))
    NextLLILoadMask  = 1'b0;
end // p_LLILoadMskComb

// -----------------------------------------------------------------------------
// The following process describes the DstAxsOnMask.
// The mask is set when
// o SetDstAxsOnMsk is high
// The mask is unset when
// o UnsetDstAxsOnMsk is high.
// -----------------------------------------------------------------------------
always @(SetDstAxsOnMsk or UnsetDstAxsOnMsk or DstAxsOnMask)
begin : p_DtAxsOnMskComb
   NextDstAxsOnMask = DstAxsOnMask;
  if (SetDstAxsOnMsk == 1'b1)
    NextDstAxsOnMask = 1'b1;
  else if (UnsetDstAxsOnMsk == 1'b1)
    NextDstAxsOnMask = 1'b0;
end // p_DtAxsOnMskComb

// -----------------------------------------------------------------------------
// The following process is the sequential block for all the request-masks
// described in this file.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_AllMaskSeq
  if (HRESETn == 1'b0)
    begin
       ErrorMask        <= 1'b0;
       SrcE2LMask       <= 1'b0;
       SrcAxsOnMask     <= 1'b0;
       LLILoadMask      <= 1'b0;
       DstAxsOnMask     <= 1'b0;
    end
  else
    begin
      ErrorMask        <= NextErrorMask;
      SrcE2LMask       <= NextSrcE2LMask;
      SrcAxsOnMask     <= NextSrcAxsOnMask;
      LLILoadMask      <= NextLLILoadMask;
      DstAxsOnMask     <= NextDstAxsOnMask;
    end
end // p_AllMaskSeq

// -----------------------------------------------------------------------------
// ErrCycMaskDst and ErrCycMaskSrc masks the channel requests during the second
// cycle of error response on AHB. The ErrorMask takes over after the end of
// second cycle of error.
// -----------------------------------------------------------------------------
assign CompositeErrMask = ErrorMask | ErrCycMaskDst | ErrCycMaskSrc;

// -----------------------------------------------------------------------------
// In DMA Flow controller case, the source requests should be masked if
// TransferSize is zero.
// -----------------------------------------------------------------------------
assign SrcTrfSizeMask   = ((IsDMAFlowCntl(FlowCntl2MSB) ||
                           IsDstFlowCntl(FlowCntl2MSB)) && (TrfSizeSrc ==
                           {12{1'b0}})) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// If FIFO is filled, i.e. (ActEmptyLevel is zero), then source requests should
// be masked.
// -----------------------------------------------------------------------------
assign FifoSrcMask      = (ActEmptyLevel == 5'b00000) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// In destination flow control mode, if the destination requests are not
// asserted, the source requests should be ignored.
// -----------------------------------------------------------------------------
assign DestNonReqMask   = (((ChDstBReq | ChDstSReq | ChDstLBReq | ChDstLSReq) ==
                           1'b0) && IsDstFlowCntl(FlowCntl2MSB)) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// The final source mask is generated by logical AND of all masks.
// If SourceMask = 1, then the request CAN be raised to internal arbiter.
// If SourceMask = 0, then the request is suppressed.
// -----------------------------------------------------------------------------
assign SourceMask       = ~(CompositeErrMask | SrcE2LMask | SrcAxsOnMask |
                           LLILoadMask | Halt | DisabledSrc | SrcTrfSizeMask |
                           DestNonReqMask | FifoSrcMask | LdSrcInDstFlow) &
                           (SourceEn) & (ChannelEn);

// -----------------------------------------------------------------------------
// If FIFO is empty, i.e. (ActFillLevel is zero), then destination requests
// should be masked.
// -----------------------------------------------------------------------------
assign FifoDstMask      = (ActFillLevel == 5'b00000) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// In DMA Flow controller case, the destination requests should be masked if
// TransferSize (for destination) is zero.
// -----------------------------------------------------------------------------
assign DstTrfSizeMask   = (IsDMAFlowCntl(FlowCntl2MSB) && (TrfSizeDst ==
                           {14{1'b0}})) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// The final destination mask is generated by logical AND of all masks.
// If DestMask = 1, then the request CAN be raised to internal arbiter.
// If DestMask = 0, then the request is suppressed.
// -----------------------------------------------------------------------------
assign DestMask         = ~(CompositeErrMask | DstAxsOnMask | LLILoadMask |
                           DisabledDst | FifoDstMask | DstTrfSizeMask) &
                           (DestEn) & (ChannelEn);

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
