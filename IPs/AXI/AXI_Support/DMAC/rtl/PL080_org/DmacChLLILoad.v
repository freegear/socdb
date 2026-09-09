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
// File Name              : DmacChLLILoad.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block describes the LLI loading logic.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacChLLILoad (
// Inputs
                      // AHB system
                      HCLK,
                      HRESETn,
                      // From AHB Master Interface (DmacAhbMaster)
                      BusAvlblM1,
                      BusAvlblM2,
                      DataErrorM1,
                      DataErrorM2,
                      // From AHB Slave interface (DmacAhbSlaveIf)
                      DMACEn,
                      // From DmacChRegBlock
                      ChannelEn,
                      ChannelEnLow,
                      LLISelForPkt,
                      // From DmacChReqProc block
                      LLIStart,

// Outputs
                      // To DmacChReqMask block
                      UnsetLLILoadMsk,
                      UnsetSrcE2LMsk,
                      // To DmacChRegBlock block
                      LLIErr,
                      DisabledLLI,
                      LLILLIRegWr,
                      LLICntlWr,
                      LLIDstWr,
                      LLISrcWr,
                      FinishedLLI,
                      UnsetLLIReq
                     );

// Inputs
// AHB system
input      HCLK;            // AHB Clock
input      HRESETn;         // AHB Reset
// From AHB Master Interface (DmacAhbMaster)
input      BusAvlblM1;      // Bus available on AHB1
input      BusAvlblM2;      // Bus available on AHB2
input      DataErrorM1;     // Data Error on AHB1
input      DataErrorM2;     // Data Error on AHB2
// From AHB Slave interface (DmacAhbSlaveIf)
input      DMACEn;          // DMAC Enable
// From DmacChRegBlock
input      ChannelEn;       // Channel Enable
input      ChannelEnLow;    // Indicates a 0 being written to ChannelEnable
input      LLISelForPkt;    // AHB master select for LLI loading
// From DmacChReqProc block
input      LLIStart;        // LLI loading can start

// Outputs
// To DmacChReqMask block
output     UnsetLLILoadMsk; // Unsets LLI load mask
output     UnsetSrcE2LMsk;  // Unsets source-end to "actual-disable/LLI-load"
                            // mask
// To DmacChRegBlock block
output     LLIErr;          // Indicates error during LLI load
output     DisabledLLI;     // Indicates DMAC is disabled at the start of LLI
                            // loading operation
output     LLILLIRegWr;     // LLI update for ChLLI register
output     LLICntlWr;       // LLI update for ChControl register
output     LLIDstWr;        // LLI update for ChDest register
output     LLISrcWr;        // LLI update for ChSrc register
output     FinishedLLI;     // LLI loading has finished
output     UnsetLLIReq;     // De-asserts the LLI request

// Inputs
// AHB system
wire       HCLK;            // AHB Clock
wire       HRESETn;         // AHB Reset
// From AHB Master Interface (DmacAhbMaster)
wire       BusAvlblM1;      // Bus available on AHB1
wire       BusAvlblM2;      // Bus available on AHB2
wire       DataErrorM1;     // Data Error on AHB1
wire       DataErrorM2;     // Data Error on AHB2
// From AHB Slave interface (DmacAhbSlaveIf)
wire       DMACEn;          // DMAC Enable
// From DmacChRegBlock
wire       ChannelEn;       // Channel Enable
wire       ChannelEnLow;    // Indicates a 0 being written to ChannelEnable
wire       LLISelForPkt;    // AHB master select for LLI loading
// From DmacChReqProc block
wire       LLIStart;        // LLI loading can start

// Outputs
// To DmacChReqMask block
reg        UnsetLLILoadMsk; // Unsets LLI load mask
reg        UnsetSrcE2LMsk;  // Unsets source-end to "actual-disable/LLI-load"
                            // mask
// To DmacChRegBlock block
reg        LLIErr;          // Indicates error during LLI load
reg        DisabledLLI;     // Indicates DMAC is disabled at the start of LLI
                            // loading operation
reg        LLILLIRegWr;     // LLI update for ChLLI register
reg        LLICntlWr;       // LLI update for ChControl register
reg        LLIDstWr;        // LLI update for ChDest register
reg        LLISrcWr;        // LLI update for ChSrc register
reg        FinishedLLI;     // LLI loading has finished
reg        UnsetLLIReq;     // De-asserts the LLI request

// -----------------------------------------------------------------------------
//
//                                DmacChLLILoad
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   The main functionality of this file is to handle the AHB transfers during
// LLI loading operation. The other functions that the file performs are:
// o The two master interfaces return one BusAvlblM(1/2) and one DataErrorM(1/2)
//   each. Depending on LLISelForPkt, one of the two is muxed to the LLI-load
//   state machine.
// o LLIFinish is clocked out. LLIFinish indicates the end of LLI loading. This
//   signal is used to reset the pointers in FIFO. After the LLI is loaded, the
//   new packet can have different data-widths, which might be incompatible with
//   the pointer-positions remaining after the end of previous packet. Thus all
//   the read/write pointer/subpointers are reset with clocked version of
//   LLIFinish (FinishedLLI). The signal has been clocked to meet synthesis
//   timings.
// o LLIDisable is clocked out. The LLIDisable signal indicates the cancellation
//   of LLI load operation due to an error response on the bus. The signal is
//   clocked out as DisabledLLI, to meet synthesis timings.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire       BusAvlblLLI;
// Bus-available signal for LLI load state machine

wire       DataErrorLLI;
// Data error signal for LLI load state machine

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [3:0] LLIDmacState;
// Current state signal for LLI loading state machine

reg  [3:0] NextLLIDmacState;
// D-input for LLIDmacState

reg  [4:0] AxsCntLLI;
// Denotes the number of accesses remaining to be done on AHB

reg  [4:0] NextAxsCntLLI;
// D-input for AxsCntLLI

reg        LLIDisable;
// Indicates that LLI loading has been stopped because of a channel disable from
// AHB slave interface of DMAC

reg        LLIFinish;
// Indicates that the process of LLI loading has finished.
                 
reg        ChannelEnLowQ2;
// One clock delayed version of ChannelEnLow.

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
// This block identifies the relevant BusAvlblLLI for the LLI-load-state
// machine from the two BusAvlbl signals (BusAvlblM1 and BusAvlblM2)
// -----------------------------------------------------------------------------
assign BusAvlblLLI      = (LLISelForPkt == 1'b0) ? BusAvlblM1        :
                           BusAvlblM2;

// -----------------------------------------------------------------------------
// This block identifies the relevant DataErrorLLI for the LLI-load-state
// machine from the two DataError signals (DataErrorM1 and DataErrorM2).
// -----------------------------------------------------------------------------
assign DataErrorLLI     = (LLISelForPkt == 1'b0) ? DataErrorM1       :
                           DataErrorM2;

// -----------------------------------------------------------------------------
// The grant from the DmacArbiter comes one clock after request is raised.
// If a request is raised at the same clock when the channel is getting
// disabled, then
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn) 
begin : p_ChEnLowSeq
  if (HRESETn == 1'b0)
    ChannelEnLowQ2   <= 1'b0;
  else
    ChannelEnLowQ2   <= ChannelEnLow;
end // process p_ChEnLowSeq
 
// -----------------------------------------------------------------------------
// The following block describes the LLI load state machine. There are 5 states
// in the state machine. Namely,
// ST_LLI_IDLE
// ST_LLI_SELECTED
// ST_LLI_ONBUS

// ST_LLI_DATAXFER
// In the following portion, the trigger for transition from each state is
// described.
// ST_LLI_IDLE:
//   Transition to ST_LLI_SELECTED
//   o the internal arbiter has granted the channel-LLILoad machine (indicated
//     by LLIStart. The internal arbiter grants the channel, and the
//     DmacChReqProc block resolves the Channel-grant to LLIStart)
//   o The channel is enabled
//   o The AHB transfer has not returned an error response.
//
//   Transition to same state
//   o When the channel is disabled by software by writing '0' into
//     channel-enable bit.
//
// ST_LLI_SELECTED:
//   Transition to ST_LLI_ONBUS
//   o When the LLI machine gets a BusAvlbl
//   Transition to ST_LLI_IDLE
//   o When the LLI machine gets an error response in an AHB transfer.
//
// ST_LLI_ONBUS:
//   Transition to ST_LLI_DATAXFER
//   o When the LLI machine gets a BusAvlbl
//   Transition to ST_LLI_IDLE
//   o When the LLI machine gets an error response in an AHB transfer.
//
// ST_LLI_DATAXFER:
//   Transition to ST_LLI_DATAXFER
//   o When the LLI machine gets a valid BusAvlbl
//   o When the AxsCntLLI is greater than 0, indicating that the 4 registers are
//     yet not completely loaded by the LLI operation.
//   Transition to ST_LLI_IDLE
//   o When the LLI machine receives an error response during an AHB transfer.
//   OR
//   o When the AxsCntLLI has reached zero, indicating that all the registers
//     have been loaded in the course of LLI loading.
// -----------------------------------------------------------------------------
always @(LLIDmacState or DMACEn or ChannelEn or ChannelEnLowQ2 or LLIStart or
         AxsCntLLI or BusAvlblLLI or DataErrorLLI)
begin : p_LLILoadComb
  // Default assignments
  // The mask-control signals
  UnsetSrcE2LMsk   = 1'b0;
  UnsetLLILoadMsk  = 1'b0;
  // Raising LLI request
  UnsetLLIReq      = 1'b0;
  // To register block.
  LLIDisable       = 1'b0;
  LLIErr           = 1'b0;
  LLILLIRegWr      = 1'b0;
  LLICntlWr        = 1'b0;
  LLIDstWr         = 1'b0;
  LLISrcWr         = 1'b0;
  LLIFinish        = 1'b0;
  // signals to be internally used within LLI state machine
  NextAxsCntLLI    = AxsCntLLI;

  case (LLIDmacState)
    // ST_LLI_IDLE:
    // Transition to ST_LLI_SELECTED
    // o the internal arbiter has granted the channel-LLILoad machine (indicated
    //   by LLIStart. The internal arbiter grants the channel, and the
    //   DmacChReqProc block resolves the Channel-grant to LLIStart)
    // o The channel is enabled
    // o The AHB transfer has not returned an error response.
    //
    // Transition to same state
    // o When the channel is disabled by software by writing '0' into
    //   channel-enable bit.
    `ST_LLI_IDLE :
      begin
        // Current state assignment
        NextLLIDmacState = `ST_LLI_IDLE;
  
        // When the channel is disabled before the start of LLI loading.
        if ((DMACEn == 1'b1) && (ChannelEn == 1'b1) && ( ~((BusAvlblLLI == 1'b1)
            && (LLIStart == 1'b1))) && (ChannelEnLowQ2 == 1'b1))
          LLIDisable       = 1'b1;
        // When BusAvlbl is there along with LLIStart
        else if ((DMACEn == 1'b1) && (ChannelEn == 1'b1) && (LLIStart == 1'b1)
                 && (DataErrorLLI != 1'b1))
        begin
          NextLLIDmacState = `ST_LLI_SELECTED;
          // The mask on source from "source-end-point" to "start-LLI-load" is
          // unset.
          UnsetSrcE2LMsk   = 1'b1;
          // Load access-count with 4.
          NextAxsCntLLI    = 5'b00100;
        end
      end

    // ST_LLI_SELECTED:
    // Transition to ST_LLI_ONBUS
    // o When the LLI machine gets a BusAvlbl
    // Transition to ST_LLI_IDLE
    // o When the LLI machine gets an error response in an AHB transfer.
    `ST_LLI_SELECTED :
      begin
        // Current state assignment
        NextLLIDmacState = `ST_LLI_SELECTED;
        if (DataErrorLLI == 1'b1)
        begin
           NextLLIDmacState = `ST_LLI_IDLE;
           NextAxsCntLLI    = 5'b00000;
        end
        else if (BusAvlblLLI == 1'b1)
          NextLLIDmacState = `ST_LLI_ONBUS;
      end

    // ST_LLI_ONBUS:
    // Transition to ST_LLI_DATAXFER
    // o When the LLI machine gets a BusAvlbl
    // Transition to ST_LLI_IDLE
    // o When the LLI machine gets an error response in an AHB transfer.
    `ST_LLI_ONBUS :
      begin
        NextLLIDmacState = `ST_LLI_ONBUS;
        if (DataErrorLLI == 1'b1)
          begin
            NextLLIDmacState = `ST_LLI_IDLE;
            NextAxsCntLLI    = 5'b00000;
          end
        else if (BusAvlblLLI == 1'b1)
          begin
            NextLLIDmacState = `ST_LLI_DATAXFER;
            // The LLI request is de-asserted.
            UnsetLLIReq      = 1'b1;
            // Decrement the AxsCntLLI
            NextAxsCntLLI    = (AxsCntLLI) - 1'b1;
          end
      end

    // ST_LLI_DATAXFER:
    // Transition to ST_LLI_DATAXFER
    // o When the LLI machine gets a valid BusAvlbl
    // o When the AxsCntLLI is greater than 0, indicating that the 4 registers
    //   are yet not completely loaded by the LLI operation.
    // Transition to ST_LLI_IDLE
    // o When the LLI machine receives an error response during an AHB transfer.
    // OR
    // o When the AxsCntLLI has reached zero, indicating that all the registers
    //   have been loaded in the course of LLI loading.
    `ST_LLI_DATAXFER :
      begin
        NextLLIDmacState = `ST_LLI_DATAXFER;
        // Generate the register updates based on access-count
        case (AxsCntLLI)
          5'b00000 : LLICntlWr        = 1'b1;
          5'b00001 : LLILLIRegWr      = 1'b1;
          5'b00010 : LLIDstWr         = 1'b1;
          5'b00011 : LLISrcWr         = 1'b1;
          default :
            begin
              LLILLIRegWr      = 1'b0;
              LLICntlWr        = 1'b0;
              LLIDstWr         = 1'b0;
              LLISrcWr         = 1'b0;
            end
        endcase
        if (DataErrorLLI == 1'b1)
          begin
            NextLLIDmacState = `ST_LLI_IDLE;
            // The LLI loading is aborted. The mask on source/destination
            // (LLILoadMsk) is unset.
            UnsetLLILoadMsk  = 1'b1;
            LLIErr           = 1'b1;
          end
        else
          begin
            if (BusAvlblLLI == 1'b1)
              begin
                // When AxsCntLLI is greater than zero. The 'not-equal-to'
                // operator is sufficient to detect a greater-than comparison
                if (AxsCntLLI != 5'b00000)
                  begin
                    NextLLIDmacState = `ST_LLI_DATAXFER;
                    NextAxsCntLLI    = (AxsCntLLI) - 1'b1;
                  end
                // When AxsCntLLI is zero.
                else
                begin
                  NextLLIDmacState = `ST_LLI_IDLE;
                  // The LLI loading is completed. The mask on
                  // source/destination (LLILoadMsk) is unset.
                  LLIFinish        = 1'b1;
                  UnsetLLILoadMsk  = 1'b1;
                end
              end
          end
      end
    default : NextLLIDmacState = `ST_LLI_IDLE;
  endcase
end // p_LLILoadComb

// -----------------------------------------------------------------------------
// Sequential process for p_LLILoadComb.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LLILoadSeq
  if (HRESETn == 1'b0)
    begin
       LLIDmacState     <= `ST_LLI_IDLE;
       AxsCntLLI        <= 5'b00000;
    end
  else
    begin
      LLIDmacState     <= NextLLIDmacState;
      AxsCntLLI        <= NextAxsCntLLI;
    end
end // p_LLILoadSeq

// -----------------------------------------------------------------------------
// The following process is for clocking out LLIDisable (which is a
// combinational function of AHB slave HWDATA bus) as DisabledLLI.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LLIDisableSeq
  if (HRESETn == 1'b0)
    DisabledLLI      <= 1'b0;
  else
    DisabledLLI      <= LLIDisable;
end // p_LLIDisableSeq

// -----------------------------------------------------------------------------
// The following process is for delaying the LLIFinish signal by one clock.
// LLIFinish is generated on the same clock in which the DmacChControl register
// value is loaded. Thus the source-width and destination-width values are not
// available (during LLIFinish) and hence the delayed version of LLIFinish is
// used for loading TrfSizeDst counter in the register block.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_LLIFinishSeq
  if (HRESETn == 1'b0)
    FinishedLLI      <= 1'b0;
  else
    FinishedLLI      <= LLIFinish;
end // p_LLIFinishSeq

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
