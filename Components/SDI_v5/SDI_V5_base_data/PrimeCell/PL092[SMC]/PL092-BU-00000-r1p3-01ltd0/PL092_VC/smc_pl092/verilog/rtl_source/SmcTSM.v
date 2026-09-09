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
// File Name              : SmcTSM.v.rca
// File Revision          : 1.20
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           TSM is used to control the read and write transactions from the
//           SmcCore to the external memory device.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SmcParams.v"

// -----------------------------------------------------------------------------

module SmcTSM (
// Inputs
               HCLK,
               HRESETn,
               HTransRegCo,
               BM,
               MemWrReq,
               MemRdReq,
               WtdWrReq,
               WtdRdReq,
               SMBUSGNT,
               CntEnd,
               DelayEnd,
               WaitEn,
               BankCmpCo,
               WaitToutErr,
               BMlenEnd,
               BufWrOver,
               MemWrOver,
               MemRdOver,
               MemRdOverCo,
               BufByPassCo,
               HBurstRegCo,
               AhbRdEn,
               AhbRdOver,
               HSizeRegCo,
               MW,
               MWCfgDone,
               OEnCntEZ,
               WEnCntEZ,
               CntEZEnd,
               RBLE,
               BnkAddStrCo,

// Outputs
               SmcState,
               SMBUSREQ,
               RdCntLdCo,
               RdBMcntLdCo,
               WrCntLdCo,
               TrArCntLdCo,
               ZeroIdleCo,
               OEnCntLdCo,
               WEnCntLdCo,
               ExtWrEnCo,
               ExtWrDisCo,
               XoutEnCo,
               XoutDisCo,
               XdatDisCo,
               RdXdatEnCo,
               WrXdatEnCo,
               AddrIncCo,
               BrstAddIncCo,
               BMRdTrans,
               SMCsEnCo,
               FastRdOp
              );

// Inputs
input         HCLK;            // Bus Clock
input         HRESETn;         // Module Reset
input   [1:0] HTransRegCo;     // Registered HTRANS signal from
                               // AHB interface block
input         BM;              // Burst ROM device indication
input         MemWrReq;        // New write initiation signal
input         MemRdReq;        // New read initiation signal
input         WtdWrReq;        // Write request which comes while current
                               // write request is being processed
input         WtdRdReq;        // Read request which comes while current
                               // read request is being processed
input         SMBUSGNT;        // Bus Grant signal from DBI
input         CntEnd;          // Indicates completion of the access time
                               // or turnaround time
input         DelayEnd;        // Indicates completion of the enable delay
                               // {for WEN & OEN}
input         WaitEn;          // Enable for external wait mode
input         BankCmpCo;       // Signal which checks if the successive
                               // transfers are to the same bank
input         WaitToutErr;     // SMWAIT Timeout Error
input         BMlenEnd;        // Burst length termination signal during
                               // burst reads
input         BufWrOver;       // Buffer storage completion signal during
                               // write transfers
input         MemWrOver;       // Write completion signal to indicate that
                               // all data packets have been flushed to the
                               // device
input         MemRdOver;       // This signal indicates that the all data
                               // packets are read from the memory device at
                               // the end of read access time
input         MemRdOverCo;     // Combinational version of the
                               // MemRdOver
input         BufByPassCo;     // This signal is used to indicate that the
                               // HSIZE = MSIZE and the RdWrBuf can be
                               // bypassed during transfers
input   [2:0] HBurstRegCo;     // Registered HBURST signal from
                               // AHB interface block
input         AhbRdEn;         // Enabling signal to route data to
                               // HRDATA bus on read completion
input         AhbRdOver;       // Signal to indicate the completion
                               // of read by AHB
input   [1:0] HSizeRegCo;      // Registered AHB Transfer Size
input   [1:0] MW;              // The memory width bits selection
                               // from one of the bank registers
input         MWCfgDone;       // Register bit indicating the
                               // completion of the MW bits
                               // programming after reset
input         OEnCntEZ;        // Signal to indicate that the OEnCount
                               // delay value is equal to zero
input         WEnCntEZ;        // Signal to indicate that the WrEnCount
                               // delay value is equal to zero
input         CntEZEnd;        // Timer counter expiry signal
                               // when count values are zero
input         RBLE;            // Byte lane enabled device
input   [2:0] BnkAddStrCo;     // Stored value of the current Bank Address

// Outputs
output  [3:0] SmcState;        // The state machine's current state value
output        SMBUSREQ;        // Bus Request signal to EBI
output        RdCntLdCo;       // Load Count value in Timer counter for
                               // normal Read Access
output        RdBMcntLdCo;     // Load Count value in Timer counter for
                               // burst Read access
output        WrCntLdCo;       // Load Count value in Timer counter for
                               // Write Access
output        TrArCntLdCo;     // Load Count value in Timer counter for
                               // Turn around cycle
output        ZeroIdleCo;      // Used to get a 1 cycle turn- around when a
                               // RD transfer is initiated after a WR
output        OEnCntLdCo;      // Load output enable delay
output        WEnCntLdCo;      // Load Write enable delay
output        ExtWrEnCo;       // enable signal for generation of write
                               // enable and bytelane select
output        ExtWrDisCo;      // Disabling signal for the write enable and
                               // bytelane selects
output        XoutEnCo;        // Enable signal for the SMOEN
output        XoutDisCo;       // Disable signal for the SMOEN
output        XdatDisCo;       // Signal to de-assert the SMDATAEN output
                               // lines
output        RdXdatEnCo;      // Signal to assert the proper byte lanes of
                               // external data bus depending on memory
                               // width during reads
output        WrXdatEnCo;      // Signal to assert all the byte lanes of
                               // external data bus during a write transfer
                               // and during Idle cycles
output        AddrIncCo;       // Signal for incrementing the memory
                               // address SMADDR
output        BrstAddIncCo;    // Signal for incrementing the
                               // SMADDR in advance during burst
                               // reads
output        BMRdTrans;       // This signal indicates that
                               // current transfer status is burst
                               // mode reads
output        SMCsEnCo;        // chip select enable
output        FastRdOp;        // In case of Burst reads when the buffer has
                               // more data than required by current
                               // AHB transfer, it is possible to provide
                               // the subsequent data from the internal buffer
                               // if the next sequential addresses are
                               // in the same field in zero cycles.
                               // So speculative advance reads are not done


// Inputs
wire          HCLK;            // Bus Clock
wire          HRESETn;         // Module Reset
wire    [1:0] HTransRegCo;     // Registered HTRANS signal from
                               // AHB interface block
wire          BM;              // Burst ROM device indication
wire          MemWrReq;        // New write initiation signal
wire          MemRdReq;        // New read initiation signal
wire          WtdWrReq;        // Write request which comes while current
                               // write request is being processed
wire          WtdRdReq;        // Read request which comes while current
                               // read request is being processed
wire          SMBUSGNT;        // Bus Grant signal from DBI
wire          CntEnd;          // Indicates completion of the access time
                               // or turnaround time
wire          DelayEnd;        // Indicates completion of the enable delay
                               // {for WEN & OEN}
wire          WaitEn;          // Enable for external wait mode
wire          BankCmpCo;       // Signal which checks if the successive
                               // transfers are to the same bank
wire          WaitToutErr;     // SMWAIT Timeout Error
wire          BMlenEnd;        // Burst length termination signal during
                               // burst reads
wire          BufWrOver;       // Buffer storage completion signal during
                               // write transfers
wire          MemWrOver;       // Write completion signal to indicate that
                               // all data packets have been flushed to the
                               // device
wire          MemRdOver;       // This signal indicates that the all data
                               // packets are read from the memory device at
                               // the end of read access time
wire          MemRdOverCo;     // Combinational version of the
                               // MemRdOver
wire          BufByPassCo;     // This signal is used to indicate that the
                               // HSIZE = MSIZE and the RdWrBuf can be
                               // bypassed during transfers
wire    [2:0] HBurstRegCo;     // Registered HBURST signal from
                               // AHB interface block
wire          AhbRdEn;         // Enabling signal to route data to
                               // HRDATA bus on read completion
wire          AhbRdOver;       // Signal to indicate the completion
                               // of read by AHB
wire    [1:0] HSizeRegCo;      // Registered AHB Transfer Size
wire    [1:0] MW;              // The memory width bits selection
                               // from one of the bank registers
wire          MWCfgDone;       // Register bit indicating the
                               // completion of the MW bits
                               // programming after reset
wire          OEnCntEZ;        // Signal to indicate that the OEnCount
                               // delay value is equal to zero
wire          WEnCntEZ;        // Signal to indicate that the WrEnCount
                               // delay value is equal to zero
wire          CntEZEnd;        // Timer counter expiry signal
                               // when count values are zero
wire          RBLE;            // Byte lane enabled device
wire    [2:0] BnkAddStrCo;     // Stored value of the current Bank Address

// Outputs
wire    [3:0] SmcState;        // The state machine's current state value
wire          SMBUSREQ;        // Bus Request signal to EBI
reg           RdCntLdCo;       // Load Count value in Timer counter for
                               // normal Read Access
reg           RdBMcntLdCo;     // Load Count value in Timer counter for
                               // burst Read access
reg           WrCntLdCo;       // Load Count value in Timer counter for
                               // Write Access
reg           TrArCntLdCo;     // Load Count value in Timer counter for
                               // Turn around cycle
reg           ZeroIdleCo;      // Used to get a 1 cycle turn- around when a
                               // RD transfer is initiated after a WR
reg           OEnCntLdCo;      // Load output enable delay
reg           WEnCntLdCo;      // Load Write enable delay
reg           ExtWrEnCo;       // enable signal for generation of write
                               // enable and bytelane select
reg           ExtWrDisCo;      // Disabling signal for the write enable and
                               // bytelane selects
reg           XoutEnCo;        // Enable signal for the SMOEN
reg           XoutDisCo;       // Disable signal for the SMOEN
reg           XdatDisCo;       // Signal to de-assert the SMDATAEN output
                               // lines
reg           RdXdatEnCo;      // Signal to assert the proper byte lanes of
                               // external data bus depending on memory
                               // width during reads
reg           WrXdatEnCo;      // Signal to assert all the byte lanes of
                               // external data bus during a write transfer
                               // and during Idle cycles
reg           AddrIncCo;       // Signal for incrementing the memory
                               // address SMADDR
reg           BrstAddIncCo;    // Signal for incrementing the
                               // SMADDR in advance during burst
                               // reads
wire          BMRdTrans;       // This signal indicates that
                               // current transfer status is burst
                               // mode reads
wire          SMCsEnCo;        // chip select enable
wire          FastRdOp;        // In case of Burst reads when the buffer has
                               // more data than required by current
                               // AHB transfer, it is possible to provide
                               // the subsequent data from the internal buffer
                               // if the next sequential addresses are
                               // in the same field in zero cycles.
                               // So speculative advance reads are not done


// -----------------------------------------------------------------------------
//
//                                   SmcTSM
//                                   ======
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//           The Transfer State Machine (TSM) block controls all the
//           transactions of the SmcCore block to the external memory device.
//           It generates the bus request signal for the control of the external
//           data bus lines. The load signals for the read and write access are
//           generated depending on the type of transfer and the device
//           characteristics. Load signals for the WEN and OEN delay counters
//           are also generated in this block. External bus turnaround cycles
//           are initiated appropriately after a read transfer completion.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
// The state machine's state value have been declared as constants in the
// SmcPackage module

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire       NextFastRdOp;
// D-input of the FastRdOp

wire       NextBMRdTrans;
// D-input of the iBMRdTrans signal

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [3:0] iSmcState;
// Local copy of SmcState

reg  [3:0] NextSmcState;
// D-input of the SmcState signal

reg        iSMBUSREQ;
// Local copy of Bus request

reg        NextSMBUSREQ;
// d-input of iSMBUSREQ

reg        NextSMCsEn;
// D-input of SMCsEn

reg        SMCsEn;
// Local copy of SMCsEn

reg        RdReqStr;
// The read request is stored till the SMBUSGNT is asserted

reg        NextRdReqStr;
// D-input of RdReqStr

reg        WrReqStr;
// The write request is stored till the SMBUSGNT is asserted

reg        NextWrReqStr;
// D-input of WrReqStr

reg        RdRemain;
// signal to indicate that the read transaction is remaining

reg        NextRdRemain;
// D-input of RdRemain

reg        BusDeGnt;
// Signal to indicate that the Bus has been de-granted before the completion
// of all transfers

reg        NextBusDeGnt;
// D-input of BusDeGnt

reg        Wait1cyc;
// A signal used for wait in the same state for 1 cycle

reg        NextWait1cyc;
// D-input of Wait1cyc

reg        BufWrOvStrT;
// The buffer WR completion signal is stored till the SMBUSGNT is asserted

reg        NextBufWrOvStrT;
// D-input of BufWrOvStrT

reg        iBMRdTrans;
// Local copy of BMRdTrans

reg        WaitToutErrD1;
// One clock delayed version of WaitToutErr

reg        iFastRdOp;
// In case of Burst reads when the buffer has more data than required by current
// AHB transfer, it is possible to provide the subsequent data from the
// internal buffer if the next sequential addresses are in the same field in
// zero cycles. So speculative advance reads are not done

reg        MemRdInd;
// Indicates a MemRdReq for same bank is detected after a burst is terminated 
// during MEM_RD state in BM cases when the read is NONSEQ so that it can be 
// used for generating BMRdTrans

reg        NextMemRdInd;
// D-input of the MemRdInd

reg        RbleD1;
// One clock delayed version of RBLE

reg        MemRdReqQ;
// One clock delayed version of MemRdReq

reg  [1:0] HTransRegQ;
// One clock delayed version of HTransRegCo

reg  [2:0] BnkAddStrQ;
// One clock delayed version of BnkAddStrCo

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
// This signal is used to indicate that currently a burst read transfer is in
// progress and when this signal is high, the next read data transfer is
// started in advance so as to save a clock cycle
// -----------------------------------------------------------------------------
assign NextBMRdTrans    = (((MemRdReq == 1'b1 || RdReqStr == 1'b1 ||
                            MemRdInd == 1'b1 ||
                            (MemWrOver == 1'b1 && WtdRdReq == 1'b1)) &&
                            BM == 1'b1 && iSmcState != `ST_TSM_MEMRD &&
                            HBurstRegCo != `SINGLE) || (MemRdReqQ == 1'b1 && 
                            BM == 1'b1 && HBurstRegCo != `SINGLE && 
                            HTransRegQ == `T_NONSEQ && 
                            iSmcState == `ST_TSM_MEMRD)) ? 1'b1 : (
                           ((((MemRdReq == 1'b1 && HTransRegCo == `T_NONSEQ) ||
                              MemWrReq == 1'b1) &&
                             iSmcState == `ST_TSM_MEMRD) ||
                            HTransRegCo == `T_IDLE ||
                            (AhbRdEn == 1'b1 && iBMRdTrans == 1'b1 &&
                             (MemRdReq == 1'b0  || (MemRdReq == 1'b1
                              && BankCmpCo == 1'b0))))
                            ? 1'b0 : iBMRdTrans);

// -----------------------------------------------------------------------------
// During the Burst reads if the HSIZE < MSize then more data than required
// is read from the memory. This signal is used to refrain SMC from
// speculatively starting the next read in advance as the data for the next
// sequential address could be returned from the buffer
// -----------------------------------------------------------------------------
assign NextFastRdOp     = (BM == 1'b1 && (HSizeRegCo < MW) &&
                           (MemRdReq == 1'b1 ||
                            (MemWrOver == 1'b1 && WtdRdReq == 1'b1))) ? 1'b1 :
                          ((AhbRdOver == 1'b1) ? 1'b0 : iFastRdOp);

// -----------------------------------------------------------------------------
// Sequential process for the various control signals and generation of 1
// clock delayed version of the appropriate signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_BmSigSeq 
  if (HRESETn == 1'b0)
    begin
      iBMRdTrans       <= 1'b0;
      WaitToutErrD1    <= 1'b0;
      iFastRdOp        <= 1'b0;
      RbleD1           <= 1'b0;
      MemRdReqQ        <= 1'b0;
      HTransRegQ       <= 1'b0;
      BnkAddStrQ       <= 3'b000;
    end
  else
    begin
      iBMRdTrans       <= NextBMRdTrans;
      WaitToutErrD1    <= WaitToutErr;
      iFastRdOp        <= NextFastRdOp;
      RbleD1           <= RBLE;
      MemRdReqQ        <= MemRdReq;
      HTransRegQ       <= HTransRegCo;
      BnkAddStrQ       <= BnkAddStrCo;
    end
end // p_BmSigSeq;

// -----------------------------------------------------------------------------
// Combinational logic for main transfer state machine
// -----------------------------------------------------------------------------
always @(MemRdReq or MemWrReq or MemWrOver or BufWrOver or MWCfgDone or
         BankCmpCo or SMBUSGNT or WaitEn or BM or CntEnd or
         DelayEnd or WaitToutErr or WtdRdReq or WtdWrReq or iSMBUSREQ or
         iSmcState or WEnCntEZ or OEnCntEZ or BMlenEnd or SMCsEn or RdReqStr or
         WrReqStr or RdRemain or BusDeGnt or MemRdOver or Wait1cyc or
         BufWrOvStrT or BufByPassCo or iBMRdTrans or HTransRegCo or
         WaitToutErrD1 or AhbRdEn or iFastRdOp or AhbRdOver or
         CntEZEnd or MemRdOverCo or RBLE or RbleD1 or BnkAddStrCo or
         BnkAddStrQ)
begin : p_TsmComb

  NextSmcState     = iSmcState;
  NextSMCsEn       = SMCsEn;
  RdXdatEnCo       = 1'b0;
  WrXdatEnCo       = 1'b0;
  XdatDisCo        = 1'b0;
  XoutEnCo         = 1'b0;
  XoutDisCo        = 1'b0;
  NextSMBUSREQ     = iSMBUSREQ;
  RdCntLdCo        = 1'b0;
  RdBMcntLdCo      = 1'b0;
  WrCntLdCo        = 1'b0;
  TrArCntLdCo      = 1'b0;
  OEnCntLdCo       = 1'b0;
  WEnCntLdCo       = 1'b0;
  ExtWrEnCo        = 1'b0;
  ExtWrDisCo       = 1'b0;
  AddrIncCo        = 1'b0;
  ZeroIdleCo       = 1'b0;
  NextRdReqStr     = RdReqStr;
  NextWrReqStr     = WrReqStr;
  NextRdRemain     = RdRemain;
  NextBusDeGnt     = BusDeGnt;
  NextWait1cyc     = Wait1cyc;
  NextBufWrOvStrT  = BufWrOvStrT;
  BrstAddIncCo     = 1'b0;
  NextMemRdInd     = 1'b0;

  case (iSmcState)

    // After reset, the state machine resides in this state. The different
    // triggering points for the memory transfer are :
    // 1. When a write transfer is detected, depending on the BufBypass status
    //    the state machine moves to the either the ST_TSM_BUFWR or the
    //    ST_TSM_MEMWR state. If the HSIZE = MSize then the buffer is bypassed
    //    and external write transfer is started immediately, by routing the
    //    HWDATA directly to the external data bus. The transfer is initiated
    //    only if the external bus is granted.
    //    If the sizes are different then the data is first collected into the
    //    buffer and the state machine positions itself in the ST_TSM_BUFWR.
    //    The bus-request is asserted before moving out.
    // 2. When a fresh memory read request is initiated, a request for the bus
    //    is issued and when the bus is granted, the CS is asserted with the
    //    start of the read access count. The OEN is asserted depending on the
    //    amount of delay required after the CS assertion. If delay is greater
    //    than 0, then the TSM goes to the ST_TSM_OENCNT state before proceeding
    //    to the ST_TSM_MEMRD state. But in the external wait controlled mode
    //    the OEN is asserted with the CS as the delay value is not
    //    deterministic. In this case and in the case if the delay value is 0
    //    the next state is ST_TSM_MEMRD and ST_TSM_OENCNT state is bypassed.
    // 3. During read from the memory when the SmcCore is de-granted in between
    //    and few more packets of data are remaining to be fetched, then the TSM
    //    will come in from the ST_TSM_MEMRD state and remain in this state
    //    till the bus is granted to the SmcCore by the DBI. The AHB master will
    //    be waited till bus is granted and all the data packets are read in.
    // 4. Whenever WaitToutErr occurs during any of the transfers (write or
    //    read) the SmcCore aborts the transactions, de-asserts all the control
    //    signals and stays in the ST_TSM_IDLE state till a new valid tranaction
    //    is initiated on the bus
    `ST_TSM_IDLE :
      begin
        NextBufWrOvStrT   = 1'b0;
        if (WaitToutErr == 1'b1)
          begin
            NextSmcState     = `ST_TSM_IDLE;
          end
        else if (MemWrReq == 1'b1 || WrReqStr == 1'b1 || WtdWrReq == 1'b1)
          begin
            NextSMBUSREQ     = 1'b1;
            NextWait1cyc     = 1'b1;
            if (BufByPassCo == 1'b1 && SMBUSGNT == 1'b1 && Wait1cyc == 1'b1 
                                                        && iSMBUSREQ == 1'b1)
              begin
                NextSMCsEn       = 1'b1;
                WrXdatEnCo       = 1'b1;
                WrCntLdCo        = 1'b1;
                NextWrReqStr     = 1'b0;
                NextWait1cyc     = 1'b0;
                if (WEnCntEZ == 1'b1 || WaitEn == 1'b1)
                  begin
                    NextSmcState     = `ST_TSM_MEMWR;
                    ExtWrEnCo        = 1'b1;
                  end
                else
                  begin
                    NextSmcState     = `ST_TSM_WENCNT;
                    WEnCntLdCo       = 1'b1;
                  end
              end
            else if (BufByPassCo == 1'b1 && SMBUSGNT == 1'b0 &&
                     Wait1cyc == 1'b1)
              begin
                NextWrReqStr     = 1'b1;
                NextWait1cyc     = 1'b0;
              end
            else if (BufByPassCo == 1'b1 && Wait1cyc == 1'b0)
              begin
                NextWrReqStr     = 1'b1;
                NextWait1cyc     = 1'b1;
              end
            else
              begin
                NextBufWrOvStrT  = BufWrOver;
                NextSmcState     = `ST_TSM_BUFWR;
                NextWait1cyc     = 1'b0;
                NextWrReqStr     = 1'b0;
              end
          end
        else if ((MemRdReq == 1'b1 || RdRemain == 1'b1 || WtdRdReq == 1'b1 ||
                  RdReqStr == 1'b1) && SMBUSGNT == 1'b0 && Wait1cyc == 1'b1)
          begin
            NextRdReqStr     = 1'b1;
            NextSMBUSREQ     = 1'b1;
            NextWait1cyc     = 1'b0;
            NextSmcState     = `ST_TSM_IDLE;
          end
        else if ((MemRdReq == 1'b1 || RdRemain == 1'b1 || RdReqStr == 1'b1 ||
                  (MWCfgDone == 1'b1 && WtdRdReq == 1'b1)) &&
                 SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1 && Wait1cyc == 1'b1)
          begin
            NextSMBUSREQ     = 1'b1;
            NextRdReqStr     = 1'b0;
            RdXdatEnCo       = 1'b1;
            NextSMCsEn       = 1'b1;
            NextRdRemain     = 1'b0;
            RdCntLdCo        = 1'b1;
            NextWait1cyc     = 1'b0;
            if (OEnCntEZ == 1'b1 || WaitEn == 1'b1)
              begin
                NextSmcState     = `ST_TSM_MEMRD;
                XoutEnCo         = 1'b1;
              end
            else
              begin
                NextSmcState     = `ST_TSM_OENCNT;
                OEnCntLdCo       = 1'b1;
              end
          end
        else if ((MemRdReq == 1'b1 || RdRemain == 1'b1 || WtdRdReq == 1'b1 ||
                  RdReqStr == 1'b1) && Wait1cyc == 1'b0)
          begin
            NextWait1cyc     = 1'b1;
            NextRdReqStr     = 1'b1;
            NextSMBUSREQ     = 1'b1;
          end
      end

    // This is the state where the data from AHB is collected into an internal
    // buffer due to mismatch in AHB transfer size and memory width. For
    // example in the case of HSIZE=8-bit and MSize=32-bit, upto a maximum of
    // 4 bytes can be collected into the buffer before writing into memory.
    // Once the buffer is full, the SmcCore can start flushing data into the
    // device. The subsequent state transition depends on when the write enable
    // can be asserted, either immediately or after some delay.
    // Due to dynamic priority arbitration of the external data bus, checks
    // are performed to ensure that the SmcCore has got the Bus Grant, otherwise
    // the SmcCore will remain in the same state till the bus is granted again
    `ST_TSM_BUFWR :
      begin
        if (SMBUSGNT == 1'b0)
          begin
            if (BusDeGnt == 1'b0)
              begin
                NextSMBUSREQ     = 1'b0;
                NextBusDeGnt     = 1'b1;
                NextSMCsEn       = 1'b0;
              end
            else if (BusDeGnt == 1'b1)
              begin
                NextSMBUSREQ     = 1'b1;
              end
            if (BufWrOver == 1'b1)
              begin
                NextBufWrOvStrT  = 1'b1;
              end
          end
        else if ((BufWrOver == 1'b1 || BufWrOvStrT == 1'b1) &&
                 SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1)
          begin
            NextBufWrOvStrT  = 1'b0;
            NextSMCsEn       = 1'b1;
            WrXdatEnCo       = 1'b1;
            WrCntLdCo        = 1'b1;
            NextBusDeGnt     = 1'b0;
            if (WEnCntEZ == 1'b1 || WaitEn == 1'b1)
              begin
                NextSmcState     = `ST_TSM_MEMWR;
                ExtWrEnCo        = 1'b1;
              end
            else
              begin
                NextSmcState     = `ST_TSM_WENCNT;
                WEnCntLdCo       = 1'b1;
              end
          end
      end

    // In this state the TSM waits for the delay completion indication
    // so as to assert the WEN
    `ST_TSM_WENCNT :
      begin
        if (DelayEnd == 1'b1)
          begin
            NextSmcState     = `ST_TSM_MEMWR;
            ExtWrEnCo        = 1'b1;
          end
      end

    // The Write to the memory is in progress in this state. If WaitToutErr
    // signal is detected, then the SmcCore aborts the transfer and
    // moves to IDLE state. When the HSIZE > MSIZE, then multiple accesses to
    // the memory devices are required which is indicated MemWrOver being
    // de-asserted. The TSM then moves to the ST_TSM_SEQWR so as to de-assert
    // the WEN output. The CntEnd signal in this state indicates the end of
    // the WR access time. If the WR is complete & there is a new WR request
    // or a waited WR request, then the next state is the ST_TSM_BUFWR. If its
    // the same bank then, CS is kept asserted otherwise it is de-asserted.
    // On the other hand if a new RD transaction or waited RD is pending, then
    // the TSM goes to turnaround for 1 HCLK by using the ZeroIdle signal. If
    // there are no active requests on the AHB then the TSM can move to the
    // IDLE state. whenever the next state is an IDLE or a WR to a different
    // bank, then the CS should be disabled one cycle later than the positive 
    // WEN, so the hold from negative WEN to the CS is satisfied
    `ST_TSM_MEMWR :
      begin
        if (Wait1cyc == 1'b0 && WaitToutErr == 1'b1)
          begin
            ExtWrDisCo       = 1'b1;
            NextWait1cyc     = 1'b1;
          end
        else if (Wait1cyc == 1'b1 && (WaitToutErr == 1'b1 ||
                                      WaitToutErrD1 == 1'b1))
          begin
            NextSmcState     = `ST_TSM_IDLE;
            NextSMBUSREQ     = 1'b0;
            XdatDisCo        = 1'b1;
            NextSMCsEn       = 1'b0;
            NextWait1cyc     = 1'b0;
          end
        else if (CntEnd == 1'b1 || CntEZEnd == 1'b1)
          begin
            NextSmcState     = `ST_TSM_SEQWR;
            ExtWrDisCo       = 1'b1;
          end
      end

    // The MemWrOver=0 indicates that the HSIZE > MSIZE and multiple
    // transfers are required to complete the WR transfer. The SMADDR
    // incremented and depending on the value of WEnCnt the next state is
    // determined. If the WR transfer is successful as indicated by
    // MemWrOver=1, then depending on whether any new WR or RD or any
    // waited WR or RD transfer is initiated, transition to appropriate
    // state is made. If the next transfer is a WR to different bank, then
    // the CS is disabled. On the other hand, if the next transfer is a RD
    // then the next state is ST_TSM_TURNARND for 1 cycle. This is achieved by
    // the ZeroIdle signal. If on the end of the current WR transfer, no
    // valid transfers are initiated, then the TSM moves to IDLE state.
    // Due to dynamic priority arbitration of the external data bus, checks
    // are performed to ensure that the SmcCore has got the Bus Grant, otherwise
    // the SmcCore will remain in the same state till the bus is granted again.
    // The Bus could be de-granted before all the write data packets have been
    // flushed out to the memory from the internal Buffer in the HSIZE > MSIZE
    // case. In the event of this, the SMBUSREQ is de-asserted for one HCLK
    // cycle and again asserted. This is required to satisfy the DBI protocol.
    `ST_TSM_SEQWR :
      begin
        if ( Wait1cyc == 1'b1) 
          begin
            NextWait1cyc     = 1'b0;
            NextSMCsEn       = 1'b1;
            WrXdatEnCo       = 1'b1;
            WrCntLdCo        = 1'b1;
            NextWrReqStr     = 1'b0;
            if (WEnCntEZ == 1'b1 || WaitEn == 1'b1) 
              begin
                NextSmcState     = `ST_TSM_MEMWR;
                ExtWrEnCo        = 1'b1;
                NextWait1cyc     = 1'b0;
              end
            else
              begin
                NextSmcState     = `ST_TSM_WENCNT;
                WEnCntLdCo       = 1'b1;
              end
          end 
        else 
          begin
            if (MemWrOver == 1'b0 && SMBUSGNT == 1'b0 && BusDeGnt  == 1'b0)
              begin
                NextSMBUSREQ     = 1'b0;
                NextBusDeGnt     = 1'b1;
                NextSMCsEn       = 1'b0;
                XdatDisCo        = 1'b1;
              end
            else if (MemWrOver == 1'b0 && SMBUSGNT == 1'b0 &&
                     iSMBUSREQ == 1'b0 && BusDeGnt == 1'b1)
              begin
                NextSMBUSREQ     = 1'b1;
              end
            else if (MemWrOver == 1'b0 && SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1)
              begin
                AddrIncCo        = 1'b1;
                NextBusDeGnt     = 1'b0;
                WrCntLdCo        = 1'b1;
                NextSMCsEn       = 1'b1;
                WrXdatEnCo       = 1'b1;
                if (WEnCntEZ == 1'b1 || WaitEn == 1'b1)
                  begin
                    NextSmcState     = `ST_TSM_MEMWR;
                    ExtWrEnCo        = 1'b1;
                  end
                else
                  begin
                    NextSmcState     = `ST_TSM_WENCNT;
                    WEnCntLdCo       = 1'b1;
                  end
              end
            else if ((MemWrOver == 1'b1 && WtdWrReq == 1'b1) 
                      && SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1)
              begin
                if (BufByPassCo == 1'b1 && (~(RBLE == 1'b0 && RbleD1 == 1'b1)))
                  begin
                    if (BnkAddStrQ != BnkAddStrCo)
                      begin
                        NextWait1cyc = 1'b1;
                      end
                    else 
                      begin 
                        NextSMCsEn       = 1'b1;
                        WrXdatEnCo       = 1'b1;
                        WrCntLdCo        = 1'b1;
                        NextWrReqStr     = 1'b0;
                        if (WEnCntEZ == 1'b1 || WaitEn == 1'b1)
                          begin
                            NextSmcState     = `ST_TSM_MEMWR;
                            ExtWrEnCo        = 1'b1;
                          end
                        else
                          begin
                            NextSmcState     = `ST_TSM_WENCNT;
                            WEnCntLdCo       = 1'b1;
                          end
                      end
                  end
                else if (BufByPassCo == 1'b1 && (RBLE == 1'b0 
                           && RbleD1 == 1'b1))
                  begin
                    NextSmcState         = `ST_TSM_IDLE;
                    NextSMCsEn           = 1'b0;
                    WrXdatEnCo           = 1'b1;
                    NextWrReqStr         = 1'b1;
                    ExtWrDisCo           = 1'b1;
                  end
                else
                  begin
                    NextSmcState     = `ST_TSM_BUFWR;
                    if (BankCmpCo == 1'b0)
                      begin
                        NextSMCsEn       = 1'b0;
                      end
                  end
              end
            else if ((MemWrOver == 1'b1 && WtdWrReq == 1'b1) 
                           && SMBUSGNT == 1'b0)
              begin
                NextSmcState     = `ST_TSM_IDLE;
                NextSMBUSREQ     = 1'b0;
                NextSMCsEn       = 1'b0;
                ExtWrDisCo       = 1'b0;
                XdatDisCo        = 1'b1;
                NextWrReqStr     = 1'b1;
              end
            else if (MemWrOver == 1'b1 && WtdRdReq == 1'b1)
              begin
                NextSmcState     = `ST_TSM_TURNARND;
                ZeroIdleCo       = 1'b1;
                NextSMCsEn       = 1'b0;
                XdatDisCo        = 1'b1;
              end
            else if (BusDeGnt == 1'b0)
              begin
                NextSmcState     = `ST_TSM_IDLE;
                NextSMBUSREQ     = 1'b0;
                NextSMCsEn       = 1'b0;
                ExtWrDisCo       = 1'b0;
                XdatDisCo        = 1'b1;
              end
          end
      end

    // Turn-Around cycles are required to ensure that there is no conflict
    // of data on the data Bus. The bus turnaround cycles are carried out when
    // the SmcCore is in this state. The  number of Turn Around cycles are
    // determined by the IDCY value programmed corresponding to the particular
    // memory device. 
    // Bus turnarounds are inserted for the following cases :
    // 1. after completion of a read transaction and the next transaction
    //    is a WR or a RD to a different bank.
    // 2. when there is a Wait-Timeout-Error in the external wait controlled
    //    memory RD transfer.
    // 3. On successfull completion of a RD transfer if there are no more 
    //    transfers on the AHB.
    // 4. One HCLK cycle turn-around is inserted when a RD follows a WR transfer
    // When the Turn-Around cycles are in progress, if there is any new RD or
    // or a WR transfer request to the memory, then these requests are stored
    // These requests will be serviced after the completion of the Turn-Around
    // Transition to the subsequent state of the TSM from this state depends
    // on the next transfer to be serviced. If there are no other transfers on
    // the AHB bus, then the TSM goes to the IDLE state.
    // Before going into any other state, the SmcCore waits for
    // the completion of the turn around cycles indicated by CntEnd.
    `ST_TSM_TURNARND :
      begin
        if (MemRdReq == 1'b1)
          begin
            NextRdReqStr     = 1'b1;
          end
        else if (MemWrReq == 1'b1)
          begin
            NextWrReqStr     = 1'b1;
          end
        else if (BufWrOver == 1'b1)
          begin
            NextBufWrOvStrT  = 1'b1;
          end
        if ((MemWrReq == 1'b1 || WrReqStr == 1'b1 || WtdWrReq == 1'b1) &&
            (CntEnd == 1'b1 || CntEZEnd == 1'b1))
          begin
            if (BufByPassCo == 1'b1 && SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1)
              begin
                NextSMCsEn       = 1'b1;
                WrXdatEnCo       = 1'b1;
                WrCntLdCo        = 1'b1;
                NextWrReqStr     = 1'b0;
                NextBufWrOvStrT  = 1'b0;
                if (WEnCntEZ == 1'b1 || WaitEn == 1'b1)
                  begin
                    NextSmcState     = `ST_TSM_MEMWR;
                    ExtWrEnCo        = 1'b1;
                  end
                else
                  begin
                    NextSmcState     = `ST_TSM_WENCNT;
                    WEnCntLdCo       = 1'b1;
                  end
              end
            else
              begin
                NextSmcState     = `ST_TSM_BUFWR;
                NextWrReqStr     = 1'b0;
              end
          end
        else if ((MemRdReq == 1'b1 || RdReqStr == 1'b1 || WtdRdReq == 1'b1) &&
                 (CntEnd == 1'b1 || CntEZEnd == 1'b1) && SMBUSGNT == 1'b1 
                                                      && iSMBUSREQ == 1'b1)
          begin
            NextRdReqStr     = 1'b0;
            RdCntLdCo        = 1'b1;
            NextSMCsEn       = 1'b1;
            RdXdatEnCo       = 1'b1;
            if (WaitEn == 1'b1 || OEnCntEZ == 1'b1)
              begin
                NextSmcState     = `ST_TSM_MEMRD;
                XoutEnCo         = 1'b1;
              end
            else
              begin
                NextSmcState     = `ST_TSM_OENCNT;
                OEnCntLdCo       = 1'b1;
              end
          end
        else if (CntEnd == 1'b1 || CntEZEnd == 1'b1)
          begin
            NextSmcState     = `ST_TSM_IDLE;
            NextSMCsEn       = 1'b0;
            XdatDisCo        = 1'b1;
            XoutDisCo        = 1'b1;
            NextSMBUSREQ     = 1'b0;
          end
      end

    // TSM waits in this state for the completion of the delay after which
    // the SMOEN can be asserted.
    `ST_TSM_OENCNT :
      begin
        if (DelayEnd == 1'b1)
          begin
            NextSmcState     = `ST_TSM_MEMRD;
            XoutEnCo         = 1'b1;
          end
      end

    // During the read transfer the SmcCore is in this state and waits for the
    // access time completion. On CntEnd assertion, if all the data pkts have
    // been read (as indicated by MemRdOver=1), then the next state is
    // enabling the AHB read. If there are still some data pkts left to be read
    // from the memory device because of the HSIZE to MSIZE differences, then
    // access counters are enabled again by asserting the address incrementer
    // signal, AddrIncCo, and the remaining data pkts are read in and stored
    // till the memory read is complete. In the SMWAIT
    // control mode if WaitToutErr is encountered then the SmcCore inserts
    // turnaround cycles and goes to the ST_TSM_TURNARND state.
    // If the device is a Burst ROM (BM=1), then the HBURST information is used
    // to perform fast speculative burst reads with the memory address value,
    // SMADDR, the memory device generated in advance. During the fast burst 
    // read mode the SmcCore's TSM continues to remain in this state.  
    // The various trigger for the state transitions are :
    // 1. In the External Wait controlled mode, when there is a Wait-Timeout-
    //    Error situation SmcCore will abort the current read transaction,
    //    de-assert all the control signals and insert bus turnaround cycles.
    //    On the other hand if the next transfer is a WR then too the TSM will
    //    move to the ST_TSM_TURNARND state
    // 2. During burst read operation from the Burst Read capable device (device
    //    which has a normal intial read access time, but fast subsequent access
    //    time, effectively increasing the bandwidth), the SmcCore does
    //    speculative reads which are ahead of real AHB request. When performing
    //    speculative fast burst reads, the SmcCore in parallel also checks for
    //    termination of the Burst read transfer. The burst could have been
    //    aborted due to next transfer which could either be a Write or a Read
    //    to a different bank or a new NONSEQ Read transfer. The next state
    //    transition will depend on all these conditions. If the burst Read
    //    request continues from the AHB, the TSM will continue in this state.
    //    The SMCS & the SMOEN will be kept continuously asserted when doing
    //    burst reads. The initial longer access time is indicated by the 
    //    assertion of the RdCntLdCo signals. Whereas the shorter burst access
    //    time is indicated by the assertion of the RdBMcntLdCo signal. Even
    //    the AHB is continuously doing burst reads, the SmcCore aborts the
    //    burst on reaching the Quad-Boundary address of the device. So if the
    //    1st address is aligned, then the SmcCore does 1 initial longer access
    //    and subsequent 3 shorted accesses. The hitting of the Quad-Boundary
    //    address is indicated by the BMlenEnd signal.
    // 3. There is one exception to the speculative Burst read from the Burst
    //    memory device when the SmcCore does not perform advance speculative
    //    reads. This happens for the case when the HSIZE < MSize and the
    //    RdWrBuf already has cached in more data than required by the current
    //    AHB read address. If the subsequent reads from the AHB are sequential
    //    in the same address range, then the data is already available in the
    //    RdWrBuf and the data is returned with zero wait cycles. This is
    //    indicated by the FastRdOp signal. In this scenario the next
    //    transition is to the ST_TSM_AHBRD state so as to route the data to
    //    the AHB.
    // 4. In the normal read mode, once the data is read in from the memory
    //    device & the RdWrBuf is full as indicated by MemRdOver=1 the TSM will
    //    move to the ST_TSM_AHBRD state so as to route the data to the AHB.
    // 5. The value of the OEN delay count of a new read access determines
    //    whether the SMOEN can be asserted immediately or after the delay. 
    // 6. During reads if the External Bus is de-granted with some more reads
    //    yet to be performed from the device, then after the current read is
    //    complete, the RdRemain is asserted, SMBUSREQ is de-asserted and the
    //    subsequent state is ST_TSM_IDLE. 
    // The address increment signal for the Burst address, BrstAddIncCo, is
    // generated during continuous Burst reads as the read data from the memory
    // fills the RdWrBuf and the data is routed to the AHB.
    // In case of the normal non-burst memory, the SMOEN & SMCS are de-asserted
    // after each transaction, since the status of the next transfer whether
    // SEQ or NONSEQ can only be known after the AHB gets the data on the
    // HRDATA bus
    `ST_TSM_MEMRD :
      begin
        NextBufWrOvStrT      = 1'b0;
        if (WaitToutErr == 1'b1)
          begin
            NextSmcState     = `ST_TSM_TURNARND;
            TrArCntLdCo      = 1'b1;
            NextSMBUSREQ     = 1'b0;
            NextSMCsEn       = 1'b0;
            XoutDisCo        = 1'b1;
            XdatDisCo        = 1'b1;
          end
        else if (AhbRdEn == 1'b1 && iBMRdTrans == 1'b1 &&
                 (HTransRegCo == `T_NONSEQ && MemRdReq == 1'b1 &&
                  BankCmpCo == 1'b1) && SMBUSGNT == 1'b1
                                     && iSMBUSREQ == 1'b1)
          begin
            RdCntLdCo        = 1'b1;
            if (OEnCntEZ == 1'b1 || WaitEn == 1'b1)
              begin
                XoutEnCo         = 1'b1;
              end
            else
              begin
                NextSmcState     = `ST_TSM_OENCNT;
                NextMemRdInd     = 1'b1;
                OEnCntLdCo       = 1'b1;
                XoutDisCo        = 1'b1;
              end
          end
        else if (AhbRdEn == 1'b1 && iBMRdTrans == 1'b1 &&
                 ((((MemRdReq == 1'b1 && BankCmpCo == 1'b0) ||
                   MemWrReq == 1'b1) && SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1)
                   || (HTransRegCo == `T_IDLE ||
                   (MemRdReq == 1'b0 && MemWrReq == 1'b0))))


          begin
            NextSmcState     = `ST_TSM_TURNARND;
            TrArCntLdCo      = 1'b1;
            XdatDisCo        = 1'b1;
            XoutDisCo        = 1'b1;
            NextSMCsEn       = 1'b0;
            if (MemRdReq == 1'b1)
              begin
                NextRdReqStr     = 1'b1;
              end
            else if (MemWrReq == 1'b1)
              begin
                NextWrReqStr     = 1'b1;
              end
          end
        else if (iBMRdTrans == 1'b1 && SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1)
          begin
            if ((CntEnd == 1'b1 && MemRdOverCo == 1'b0) ||
                (CntEZEnd == 1'b1 && MemRdOverCo == 1'b0))
              begin
                AddrIncCo        = 1'b1;
                RdBMcntLdCo      = 1'b1;
              end
            else if (MemRdOverCo == 1'b1 && iFastRdOp == 1'b0)
              begin
                BrstAddIncCo     = 1'b1;
                if (BMlenEnd == 1'b0)
                  begin
                    RdBMcntLdCo      = 1'b1;
                  end
                else
                  begin
                    RdCntLdCo        = 1'b1;
                  end
              end
            else if (MemRdOverCo == 1'b1 && iFastRdOp == 1'b1)
              begin
                NextSmcState     = `ST_TSM_AHBRD;
                XoutDisCo        = 1'b1;
              end
          end
        else if (((CntEnd == 1'b1 && MemRdOverCo == 1'b0) ||
                  (CntEZEnd == 1'b1 && MemRdOverCo == 1'b0)) &&
                 SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1)
          begin
            AddrIncCo        = 1'b1;
            if (WaitEn == 1'b1 || OEnCntEZ == 1'b1)
              begin
                if (BM == 1'b1)
                  begin
                    RdBMcntLdCo      = 1'b1;
                  end
                else
                  begin
                    RdCntLdCo        = 1'b1;
                  end
              end
            else
              begin
                NextSmcState     = `ST_TSM_OENCNT;
                RdCntLdCo        = 1'b1;
                OEnCntLdCo       = 1'b1;
                XoutDisCo        = 1'b1;
              end
          end
        else if (((CntEnd == 1'b1 && MemRdOverCo == 1'b0) ||
                  (CntEZEnd == 1'b1 && MemRdOverCo == 1'b0)) &&
                 SMBUSGNT == 1'b0)
          begin
            NextSmcState     = `ST_TSM_TURNARND;
            TrArCntLdCo      = 1'b1;
            NextRdRemain     = 1'b1;
            XoutDisCo        = 1'b1;
            NextSMCsEn       = 1'b0;
            XdatDisCo        = 1'b1;
          end
        else if (MemRdOverCo == 1'b1 & SMBUSGNT == 1'b0 & iBMRdTrans == 1'b1 &
               iFastRdOp == 1'b0)
          begin
            BrstAddIncCo     = 1'b1;
            NextSmcState     = `ST_TSM_TURNARND;
            TrArCntLdCo      = 1'b1;
            XoutDisCo        = 1'b1;
            NextSMCsEn       = 1'b0;
            XdatDisCo        = 1'b1;
          end
        else if (MemRdOverCo == 1'b1)
          begin
            NextSmcState     = `ST_TSM_AHBRD;
            XoutDisCo        = 1'b1;
            NextSMCsEn       = 1'b0;
          end
      end

    // This state controls the routing of read data to the HRDATA bus in the
    // AHB interface block to enable AHB Reads. The various state transition
    // triggers are :
    // 1. At the completion of the RD operation, indicated by the MemRdOver,
    //    if the Bus is de-granted, then the TSM transitions to the IDLE state 
    //    after de-asserting all the control signals.
    // 2. When the AHB completes its read operation from the RdWrBuf, indicated
    //    by the AhbRdOver, then depending in whether the next transfer is
    //    continuation of SEQ RDs to the same device or RD to a different Bank
    //    or a WR operation, the state change decisions are taken. 
    //    [a] If the next read is to the same bank and if it is External Wait
    //        controlled mode or the OEN delay value is zero then, the SMOEN
    //        is asserted immediately with the SMCS
    //    [b] If during Burst Read operation for the exception case when the
    //        HSIZE < MSize, the RdWrBuf will have cached in more data than
    //        required. The subsequent SEQ read datas are returned from the
    //        internal RdWrBuf. If the subsequent Reads requests from AHB are
    //        still SEQ and if the Quad-Boundary Address location is not yet 
    //        reached, then faster read access is initiated. The SMCS & SMOEN
    //        are asserted together.
    //    [c] In the case of a normal non-burst reads, the SMOEN will be
    //        asserted after the OEN count delay is accounted for.
    // 3. If the next transfer after the completion of the AHB Read is a Write
    //    or a Read to a different bank, then the SmcCore will perform bus
    //    turn-around cycles before starting the memory access. These requests
    //    are stored appropriately.
    // 4. In the event of not further transfer requests from the AHB, then 
    //    Turn-Around cycles are performed.
    `ST_TSM_AHBRD :
      begin
        if (MemRdOver == 1'b1 && SMBUSGNT == 1'b0)
          begin
            NextSmcState     = `ST_TSM_TURNARND;
            TrArCntLdCo      = 1'b1;
            NextSMCsEn       = 1'b0;
            XdatDisCo        = 1'b1;
          end
        else if (MemRdReq == 1'b1 && BankCmpCo == 1'b1 &&
                 SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1 &&
                  (AhbRdOver == 1'b1 || AhbRdEn == 1'b1))
          begin
            NextWait1cyc     = 1'b0;
            if(OEnCntEZ == 1'b1 || WaitEn == 1'b1) 
              begin
                NextSmcState     = `ST_TSM_MEMRD;
                XoutEnCo         = 1'b1;
                RdCntLdCo        = 1'b1;
                NextSMCsEn       = 1'b1;
              end
            else if (BMlenEnd == 1'b0 && HTransRegCo == `T_SEQ && BM == 1'b1)
              begin
                XoutEnCo         = 1'b1;
                RdBMcntLdCo      = 1'b1;
                NextSMCsEn       = 1'b1;
                NextSmcState     = `ST_TSM_MEMRD;
              end
            else
              begin
                NextSmcState     = `ST_TSM_OENCNT;
                RdCntLdCo        = 1'b1;
                OEnCntLdCo       = 1'b1;
                XoutDisCo        = 1'b1;
                NextSMCsEn       = 1'b1;
              end
          end
        else if ((((MemRdReq == 1'b1 && BankCmpCo == 1'b0) ||
                    MemWrReq == 1'b1) && SMBUSGNT == 1'b1 && iSMBUSREQ == 1'b1 
                    && (AhbRdOver == 1'b1 || AhbRdEn == 1'b1)) ||
                 ((MemRdReq == 1'b1 || MemWrReq == 1'b1) &&
                  SMBUSGNT == 1'b0))
          begin
            NextSmcState     = `ST_TSM_TURNARND;
            TrArCntLdCo      = 1'b1;
            XdatDisCo        = 1'b1;
            XoutDisCo        = 1'b1;
            NextSMCsEn       = 1'b0;
            if (MemRdReq == 1'b1)
              begin
                NextRdReqStr     = 1'b1;
              end
            else if (MemWrReq == 1'b1)
              begin
                NextWrReqStr     = 1'b1;
              end
            NextWait1cyc     = 1'b0;
          end
        else if (Wait1cyc == 1'b0)
          begin
            NextWait1cyc     = 1'b1;
          end
        else if (Wait1cyc == 1'b1 && (MemRdReq == 1'b0 && MemWrReq == 1'b0))
          begin
            NextWait1cyc     = 1'b0;
            NextSmcState     = `ST_TSM_TURNARND;
            TrArCntLdCo      = 1'b1;
            XdatDisCo        = 1'b1;
            XoutDisCo        = 1'b1;
            NextSMCsEn       = 1'b0;
          end
      end

    default :
      NextSmcState     = `ST_TSM_IDLE;
      
  endcase
end // p_TsmComb

// -----------------------------------------------------------------------------
// Sequential process for the
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_CtrlSeq
  if (HRESETn == 1'b0)
    begin
      iSmcState        <= `ST_TSM_IDLE;
      SMCsEn           <= 1'b0;
      iSMBUSREQ        <= 1'b0;
      RdReqStr         <= 1'b0;
      WrReqStr         <= 1'b0;
      RdRemain         <= 1'b0;
      BusDeGnt         <= 1'b0;
      Wait1cyc         <= 1'b0;
      BufWrOvStrT      <= 1'b0;
      MemRdInd         <= 1'b0;
    end
  else
    begin
      iSmcState        <= NextSmcState;
      iSMBUSREQ        <= NextSMBUSREQ;
      SMCsEn           <= NextSMCsEn;
      RdReqStr         <= NextRdReqStr;
      WrReqStr         <= NextWrReqStr;
      RdRemain         <= NextRdRemain;
      BusDeGnt         <= NextBusDeGnt;
      Wait1cyc         <= NextWait1cyc;
      BufWrOvStrT      <= NextBufWrOvStrT;
      MemRdInd         <= NextMemRdInd;
    end
end // p_CtrlSeq

// -----------------------------------------------------------------------------
// connect local copies to output
// -----------------------------------------------------------------------------
assign SMBUSREQ         = iSMBUSREQ;
assign SmcState         = iSmcState;
assign SMCsEnCo         = NextSMCsEn;
assign BMRdTrans        = iBMRdTrans;
assign FastRdOp         = iFastRdOp;

endmodule
// --================================== End ==================================--
