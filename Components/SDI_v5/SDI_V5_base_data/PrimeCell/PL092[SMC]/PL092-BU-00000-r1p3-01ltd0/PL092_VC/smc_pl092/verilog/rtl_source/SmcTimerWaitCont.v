// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcTimerWaitCont.v.rca
// File Revision          : 1.20
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module is used for the purpose of generating the read access
//           time completion, write access time completion, access timings by
//           using external wait control. The WEN and OEN delay generation
//           logic is also implemented in this module.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SmcParams.v"

// -----------------------------------------------------------------------------

module SmcTimerWaitCont (
// Inputs
                         HCLK,
                         HRESETn,
                         WST1,
                         WST2,
                         IDCY,
                         WSTWEN,
                         WSTOEN,
                         RdCntLdCo,
                         WrCntLdCo,
                         TrArCntLdCo,
                         ZeroIdleCo,
                         RdBMcntLdCo,
                         OEnCntLdCo,
                         WEnCntLdCo,
                         SmWaitS2,
                         CnclSmWaitS2,
                         BM,
                         WaitEn,
                         WaitPol,
                         SmcState,

// Outputs
                         CntEnd,
                         DelayEnd,
                         WaitToutErr,
                         OEnCntEZ,
                         WEnCntEZ,
                         CntEZEnd
                        );

// Inputs
input         HCLK;            // AHB Bus Clock
input         HRESETn;         // AHB Bus Reset
input   [4:0] WST1;            // Wait State count for single memory read
                               // or start of a burst read cycle
input   [4:0] WST2;            // Wait State count for memory write or
                               // burst read cycle
input   [3:0] IDCY;            // Turn around count value
input   [3:0] WSTWEN;          // Chip select to Write enable assertion
                               // delay
input   [3:0] WSTOEN;          // Chip select to Output enable assertion
                               // delay
input         RdCntLdCo;       // Load normal read access delay
input         WrCntLdCo;       // Load write delay
input         TrArCntLdCo;     // Load Turn around delay
input         ZeroIdleCo;      // 1 cycle Turn around delay
input         RdBMcntLdCo;     // Load Burst read delay
input         OEnCntLdCo;      // Load Output enable delay
input         WEnCntLdCo;      // Load Write enable delay
input         SmWaitS2;        // Double Synchronised External wait
input         CnclSmWaitS2;    // Double synchronised External wait
                               // termination
input         BM;              // Burst ROM device indication
input         WaitEn;          // External wait mode enable
input         WaitPol;         // External wait polarity
input   [3:0] SmcState;        // The state machine's current state value

// Outputs
output        CntEnd;          // End of access timer count
output        DelayEnd;        // End of delay timer count
output        WaitToutErr;     // External Wait timeout error
output        OEnCntEZ;        // This signal is generated to determine
                               // whether the OEnCount delay value is
                               // equal to zero
output        WEnCntEZ;        // This signal is generated to determine
                               // whether the WrEnCount delay value is
                               // equal to zero
output        CntEZEnd;        // Timer counter expiry signal when
                               // count values are zero

// Inputs
wire          HCLK;            // AHB Bus Clock
wire          HRESETn;         // AHB Bus Reset
wire    [4:0] WST1;            // Wait State count for single memory read
                               // or start of a burst read cycle
wire    [4:0] WST2;            // Wait State count for memory write or
                               // burst read cycle
wire    [3:0] IDCY;            // Turn around count value
wire    [3:0] WSTWEN;          // Chip select to Write enable assertion
                               // delay
wire    [3:0] WSTOEN;          // Chip select to Output enable assertion
                               // delay
wire          RdCntLdCo;       // Load normal read access delay
wire          WrCntLdCo;       // Load write delay
wire          TrArCntLdCo;     // Load Turn around delay
wire          ZeroIdleCo;      // 1 cycle Turn around delay
wire          RdBMcntLdCo;     // Load Burst read delay
wire          OEnCntLdCo;      // Load Output enable delay
wire          WEnCntLdCo;      // Load Write enable delay
wire          SmWaitS2;        // Double Synchronised External wait
wire          CnclSmWaitS2;    // Double synchronised External wait
                               // termination
wire          BM;              // Burst ROM device indication
wire          WaitEn;          // External wait mode enable
wire          WaitPol;         // External wait polarity
wire    [3:0] SmcState;        // The state machine's current state value

// Outputs
wire          CntEnd;          // End of access timer count
wire          DelayEnd;        // End of delay timer count
wire          WaitToutErr;     // External Wait timeout error
wire          OEnCntEZ;        // This signal is generated to determine
                               // whether the OEnCount delay value is
                               // equal to zero
wire          WEnCntEZ;        // This signal is generated to determine
                               // whether the WrEnCount delay value is
                               // equal to zero
wire          CntEZEnd;        // Timer counter expiry signal when
                               // count values are zero

// -----------------------------------------------------------------------------
//
//                              SmcTimerWaitCont
//                              ================
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//         This block gets the Load enable signals for various delay values from
//         the Main state machine and accordingly loads the corresponding delay
//         values into a counter and checks till it expires. For the access time
//         completion the count end [CntEnd] signal is generated. The delay
//         count expiry is indicated by the signal [DelayEnd]. It also
//         generates error status signals like external wait error and wait
//         time out error.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
// The timer state machine's state value encoding is done in the SmcPackage
// module

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire       NextWaitPolPrev;
// D-input of WaitPolPrev

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [3:0] DelayCnt;
// 4-bit delay Counter for the WEN and OEN

reg  [3:0] NextDelayCnt;
// D-input of DelayCnt

reg  [4:0] TimerCnt;
// 5-bit Counter in the timer module

reg  [4:0] NextTimerCnt;
// D-input of TimerCnt

reg  [1:0] TimerState;
// Indicates Timer state machine's current state

reg  [1:0] NextTimerState;
// D-input of TimeState

reg        DelayState;
// Indicates current state of the Delay state logic

reg        NextDelayState;
// D-input of DelayState

reg        iCntEnd;
// Local copy of CntEnd

reg        NextCntEnd;
// D-input of iCntEnd

reg        iDelayEnd;
// Local copy of DelayEnd

reg        NextDelayEnd;
// D-input of iDelayEnd

reg        iWaitToutErr;
// Local copy of WaitToutErr

reg        iWaitToutErrQ;
// D-input of WaitToutErr

reg        WaitPolPrev;
// Stored value of the WaitPol for which WaitToutErr occured

reg        iCntEZEnd;
// Local copy of CntEZEnd

wire       NextCntEZEnd;
// D-input of iCntEZEnd

wire       WST1EZ;
// This signal is generated to determine whether the
// WST1 access count value is equal to zero

wire       WST2EZ;
// This signal is generated to determine whether the
// WST2 access count value is equal to zero

wire       IdcyEZ;
// This signal is generated to determine whether the
// IDCY count value is equal to zero

wire [3:0] OEnCount;
// Output enable count

wire [3:0] WrEnCount;
// Write enable count

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
// Generate signals which check if the access count or turnaround count value
// are equal to zero.
// -----------------------------------------------------------------------------
assign WST1EZ           = (WST1 == 5'b00000) ? 1'b1 : 1'b0;

assign WST2EZ           = (WST2 == 5'b00000) ? 1'b1 : 1'b0;

assign IdcyEZ           = (IDCY == 4'b0000) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Generation of Access end signal CntEZEnd, when the count values are zero
// without waiting for the state machine transitions
// -----------------------------------------------------------------------------
assign NextCntEZEnd     = ((WST1EZ == 1'b1 && RdCntLdCo == 1'b1) ||
                           (WST2EZ == 1'b1 &&
                            (WrCntLdCo == 1'b1 || RdBMcntLdCo == 1'b1)) ||
                           (IdcyEZ == 1'b1 && TrArCntLdCo == 1'b1) ||
                           ZeroIdleCo == 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Combinational logic for the access Timing State machine
// -----------------------------------------------------------------------------
always @(TimerState or RdCntLdCo or WrCntLdCo or TrArCntLdCo or RdBMcntLdCo or
         TimerCnt or SmWaitS2 or CnclSmWaitS2 or WaitEn or SmcState or
         WaitPol or WaitPolPrev or IDCY or WST1 or WST2 or iWaitToutErrQ or
         IdcyEZ or WST1EZ or WST2EZ)
begin : p_TimerComb

  NextTimerState   = TimerState;
  NextTimerCnt     = TimerCnt;
  iWaitToutErr     = iWaitToutErrQ & ((~WaitPolPrev & ~SmWaitS2) |
                                     (WaitPolPrev & SmWaitS2));
  NextCntEnd       = 1'b0;

  case (TimerState)

// After reset, the state machine reaches this state and TimerCnt is zero so
// the count end signal CntEnd will be asserted. Once if any of the
// turnaround, Output enable, write enable delay's load signals are
// asserted then the corresponding count values are loaded into the counter
// and the state machine enters into the count state ST_TW_COUNT, with the
// deassertion of count end. If external wait (SmWaitS2) is deasserted and any
// of the write access, read access, burst read access count load values
// are asserted then the state machine moves into count state ST_TW_COUNT and
// loads the corresponding count value into the counter. It also deasserts
// the count end, external wait error and wait timeout error signals. else if
// external wait is deasserted then the statemachine stays back in the idle
// state ST_TW_IDLE asserting the error signal . While loading the
// counter wherever the count value has to be added with 1 as in the case of
// turn around count, a signal wait one clock is set to take care
// of the additonal one clock delay.
// Check is performed to see whether the SMWAIT i/p is already asserted
// irrespective of whether the targeted bank is SMWAIT controlled or not
// This because the SMWAIT could be de-asserted any time and there is then
// a chance of bus contention. No need to check for the WaitEn=1 because
// this is generic for both non-SMWAIT controlled and SMWAIT controlled.
    `ST_TW_IDLE :
      begin
        if (TrArCntLdCo == 1'b1 && IdcyEZ == 1'b0)
          begin
            NextTimerState   = `ST_TW_COUNT;
            NextTimerCnt     = {1'b0, IDCY};
          end
        else if ((iWaitToutErrQ == 1'b1) &&
                 ((WaitPolPrev == 1'b0 && SmWaitS2 == 1'b0) ||
                  (WaitPolPrev == 1'b1 && SmWaitS2 == 1'b1)))
          begin
            NextTimerState   = `ST_TW_IDLE;
          end
        else
          begin
            iWaitToutErr = 1'b0;
            if (WrCntLdCo == 1'b1 && WST2EZ == 1'b0)
              begin
                NextTimerState   = `ST_TW_COUNT;
                NextTimerCnt     = WST2;
              end
            else if (RdBMcntLdCo == 1'b1 && WST2EZ == 1'b0)
              begin
                NextTimerState   = `ST_TW_COUNT;
                NextTimerCnt     = WST2;
              end
            else if (RdCntLdCo == 1'b1 && WST1EZ == 1'b0)
              begin
                NextTimerState   = `ST_TW_COUNT;
                NextTimerCnt     = WST1;
              end
           end
       end

// The common counter which is loaded by any of the load enable signals is
// used for the following purposes :
// 1. To count down either the read access count or write access count or the
//    turnaround cycle count. At the counter expiry, a common count completion
//    signal 'CntEnd' signal is generated. This signal corresponds to the
//    respective load enable signal.
// 2. In the external wait control mode, the counter is loaded with the count
//    value which corresponds to the amount of time the SmcCore is expected to
//    wait for the assertion of the SMWAIT input. If the SMWAIT is asserted
//    within this stipulated time, then the state machine moves the EXT_WAIT
//    state and the SmcCore is controlled by the SMWAIT input. On the other hand
//    if the SMWAIT assertion is not detected within the counter expiry, then
//    the transfer is completed successfully with no extra wait cycles.
// During the Burst Read mode, when the subsequent reads are started in
// advance speculatively, then it is possible that the burst read is aborted.
// The access counting activity which is in already in progress will be aborted
// and depending on the next transfer {as indicated by the count load signals},
// the counter is reloaded appropriately.
    `ST_TW_COUNT :
      begin 
        if (WaitEn == 1'b1 &&
            ((WaitPol == 1'b0 && SmWaitS2 == 1'b0) ||
             (WaitPol == 1'b1 && SmWaitS2 == 1'b1)) &&
             (SmcState != `ST_TSM_TURNARND) &&
             (TrArCntLdCo != 1'b1)) 
          begin
            NextTimerState   = `ST_TW_EXTWAIT;
            NextTimerCnt     = 5'b00000;
          end
        else if (TrArCntLdCo == 1'b1 && IdcyEZ == 1'b0)
          begin
            NextTimerCnt     = {1'b0, IDCY};
          end
        else if (RdBMcntLdCo == 1'b1 && WST2EZ == 1'b0)
          begin
            NextTimerCnt     = WST2;
          end
        else if (RdCntLdCo == 1'b1 && WST1EZ == 1'b0)
          begin
            NextTimerCnt     = WST1;
          end
        else if (WrCntLdCo == 1'b1 && WST2EZ == 1'b0)
          begin
            NextTimerCnt     = WST2;
          end
        else if (TimerCnt == 5'b00001)
          begin
            if (WaitEn == 1'b1 &&
                ((WaitPol == 1'b0 && SmWaitS2 == 1'b0) ||
                 (WaitPol == 1'b1 && SmWaitS2 == 1'b1)) &&
                 (SmcState != `ST_TSM_TURNARND) &&
                 (TrArCntLdCo != 1'b1))
              begin
                NextTimerState   = `ST_TW_EXTWAIT;
                NextTimerCnt     = 5'b00000;
              end
            else
              begin
                NextTimerState   = `ST_TW_IDLE;
                NextCntEnd       = 1'b1;
                NextTimerCnt     = 5'b00000;
              end
          end
        else
          begin
            NextTimerCnt     = TimerCnt - 1;
          end
      end 

// This is the state in which the SmcCore is controlled by the SMWAIT input
// for the read or write access timings. De-assertion of the SMWAIT, signals
// the completion of the access time.
// It is also possible for some reason that the SMWAIT is not de-asserted by
// external controller which means a potential hang situation. In such scenarios
// the CANCELSMWAIT input is asserted high, which indicates that a time-out has
// occured on the de-assertion of the SMWAIT. When a time-out condition is
// encountered, the transfer is aborted, WaitToutErr flag is set and ERROR
// response is returned
    `ST_TW_EXTWAIT :
      begin 
        if (TrArCntLdCo == 1'b1)
          begin
            NextTimerState   = `ST_TW_COUNT;
            NextTimerCnt     = {1'b0, IDCY};
          end
        else if ((WaitPol == 1'b0 && SmWaitS2 == 1'b1) ||
                 (WaitPol == 1'b1 && SmWaitS2 == 1'b0))
          begin
            NextTimerState   = `ST_TW_IDLE;
            NextCntEnd       = 1'b1;
          end
        else if (CnclSmWaitS2 == 1'b1)
          begin
            NextTimerState   = `ST_TW_IDLE;
            iWaitToutErr  = 1'b1;
          end
      end

    default : 
      NextTimerState   = `ST_TW_IDLE;
      
  endcase
end // p_TimerComb

// -----------------------------------------------------------------------------
// Select the enable times from the normal value and the access time values
// depending on which one is smaller.
// If WSTOEN is greater than WST1, OEnCount follows the WST1 value.
// During burst mode reads, if WSTOEN is less than WST2, OenCount follows
// the WST2 value. Else OEnCount follows WSTOEN value.
// If WSTWEN is greater than WST2, WrEnCount follows the WST2 value.
// Else WrEnCount follows WSTWEN value.
// This logic prevents the transfer state machine from hanging if the user
// erroneously programs the write enable time greater than the write access time
// or the output enable time greater than read access time.
// -----------------------------------------------------------------------------
assign WrEnCount        = (WST2 < ({1'b0, WSTWEN})) ?
                           WST2[3:0] : WSTWEN;

assign OEnCount         = ((WST1 < ({1'b0, WSTOEN})) ?  WST1[3:0] :
                           (BM == 1'b1 & (WST2 < ({1'b0, WSTOEN}))) ?
                           WST2[3:0] : WSTOEN);

// -----------------------------------------------------------------------------
// Generate signals which checks if the delay count value for the output enable
// and write enable is equal to zero.
// -----------------------------------------------------------------------------
assign OEnCntEZ         = (OEnCount == 4'b0000) ? 1'b1 : 1'b0;

assign WEnCntEZ         = (WrEnCount == 4'b0000) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Combination logic for the WEN and OEN delay count
// -----------------------------------------------------------------------------
always @(DelayState or WEnCntLdCo or OEnCntLdCo or OEnCount or DelayCnt or
         WrEnCount)
begin : p_OeWeDlyComb
  NextDelayState   = DelayState;
  NextDelayCnt     = DelayCnt;

  case (DelayState)
    1'b0 :
      begin
        if (WEnCntLdCo == 1'b1)
          begin
            NextDelayState   = 1'b1;
            NextDelayCnt     = WrEnCount;
          end
        else if (OEnCntLdCo == 1'b1)
          begin
            NextDelayState   = 1'b1;
            NextDelayCnt     = OEnCount;
          end
      end

    1'b1 :
      begin
        if (DelayCnt == 4'b0001)
          begin
            NextDelayState   = 1'b0;
          end
        else
          begin
            NextDelayCnt     = DelayCnt - 1;
          end
      end

    default : 
      NextDelayState   = 1'b0;
      
  endcase
end // p_OeWeDlyComb

// -----------------------------------------------------------------------------
// Delay count end generation, the DelayEnd is generated a CLOCK earlier so
// that it can be used to get correct timings in the TSM, EIB blocks
// -----------------------------------------------------------------------------
always @(DelayState or NextDelayCnt or WEnCntLdCo or OEnCntLdCo or WrEnCount or
         OEnCount)
begin : p_DelayEndComb
  NextDelayEnd     = 1'b0;

  if ((DelayState == 1'b1 && NextDelayCnt == 4'b0001)
     ||
      ((WEnCntLdCo == 1'b1 && WrEnCount == 4'b0001) ||
       (OEnCntLdCo == 1'b1 && OEnCount == 4'b0001))
     )
    begin
      NextDelayEnd     = 1'b1;
    end
end // p_DelayEndComb

// -----------------------------------------------------------------------------
// Sequential Logic for Timercounter and Timer state machine states
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_TimerDlySeq
  if (HRESETn == 1'b0)
    begin
      TimerState       <= `ST_TW_IDLE;
      DelayState       <= 1'b0;
      TimerCnt         <= 5'b00000;
      DelayCnt         <= 4'b0000;
      iCntEnd          <= 1'b0;
      iDelayEnd        <= 1'b0;
      iWaitToutErrQ    <= 1'b0;
      WaitPolPrev      <= 1'b0;
      iCntEZEnd        <= 1'b0;
    end
  else
    begin
      TimerState       <= NextTimerState;
      DelayState       <= NextDelayState;
      TimerCnt         <= NextTimerCnt;
      DelayCnt         <= NextDelayCnt;
      iCntEnd          <= NextCntEnd;
      iDelayEnd        <= NextDelayEnd;
      iWaitToutErrQ    <= iWaitToutErr;
      WaitPolPrev      <= NextWaitPolPrev;
      iCntEZEnd        <= NextCntEZEnd;
    end
end // p_TimerDlySeq

// -----------------------------------------------------------------------------
// The WaitPol of the bank which resulted in the is WaitToutErr stored, as the
// SMWAIT is still found to be asserted. This means that the previous transfer
// has not yet ended. The next transfer is not started till the SMWAIT for the
// previous transfer is de-asserted.
// -----------------------------------------------------------------------------
assign NextWaitPolPrev  = (TimerState == `ST_TW_EXTWAIT &
                           iWaitToutErrQ == 1'b1) ?
                           WaitPol : WaitPolPrev;

// -----------------------------------------------------------------------------
// Connect Local Copies to output
// -----------------------------------------------------------------------------

assign CntEnd           = iCntEnd;
assign DelayEnd         = iDelayEnd;
assign WaitToutErr      = iWaitToutErrQ;
assign CntEZEnd         = iCntEZEnd;

endmodule
// --================================== End ==================================--
