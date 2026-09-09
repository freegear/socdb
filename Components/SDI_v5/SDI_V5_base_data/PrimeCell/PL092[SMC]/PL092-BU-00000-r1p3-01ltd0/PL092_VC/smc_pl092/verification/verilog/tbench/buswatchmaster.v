// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version  and  Release Control Information:
//
// File Name              : buswatchmaster.v.rca
// File Revision          : 1.13
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// ---------------------------------------------------------------------
// Purpose :
//           Protocol checker for AHB Master testbench
//
// --=================================================================--

`timescale 1ns/1ps

`uselib lib=common
`uselib lib=buswatcher
`include "../common/defs.v"
`include "../common/configmaster.v"
`include "../tbench/timing.v"
`include "../tbench/timingmaster.v"

// ---------------------------------------------------------------------

module buswatchmaster (
                 HCLK,
                 HRESETn,
                 HTRANS,
                 HADDR,
                 HSIZE,
                 HBURST,
                 HBUSREQx,
                 HGRANTx,
                 HREADY,
                 HLOCKx,
                 HWDATA,
                 HPROT,
                 HWRITE,
                 HRESP,
                 ResetOver
                );
           
parameter
  HaltOnMismatch = `FALSE,
  Verbosity      = `FALSE;

input         HCLK;
// The main bus clock

input         HRESETn;
// Active low system reset

input  [1:0]  HTRANS;
// Signal driven out by master, denoting SEQ,NSEQ, BUSY or IDLE transfer

input  [31:0] HADDR;
// 32 bit address lines driven by the master

input  [2:0]  HSIZE;
// signal driven by master, denoting the size of transfer ex. byte, word

input  [2:0]  HBURST;
// signal driven by master, denoting type of burst ex. incr, wrap4

input         HBUSREQx;
// driven by master; when high, indicates that master requests the bus

input         HGRANTx;
// signal indicating the grant-status of the master under test

input         HREADY;
// signal indicating the completion of current transfer

input         HLOCKx;
// when high, this indicates that master requires locked access

input  [63:0] HWDATA;
// write data, driven by the master 

input [3:0]   HPROT;
// signal driven by master, giving additional info about the bus-access
// ex. supervisor mode, opcode mode etc

input         HWRITE;
// signal driven by master, denoting whether it is write or read

input  [1:0]  HRESP;
// 2 bit wide response signal, indicating ok, retry, split or busy

output        ResetOver;

// ---------------------------------------------------------------------
//
//                               buswatchmaster
//                               ==============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module implements the protocol checks for AHB master's output
// signals and will provide warnings and error messages if it finds
// some mismatch.
//
// ---------------------------------------------------------------------
 
// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
`define ST_CHECK      1'b1
`define ST_NOTCHECK   1'b0
`define ST_DEGRANTED  1'b0
`define ST_GRANTED    1'b1

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire        HCLK;
// The main bus clock

wire        HRESETn;
// Active low system reset

wire [1:0]  HTRANS;
// Signal driven out by master, denoting SEQ,NSEQ, BUSY or IDLE transfer

wire [31:0] HADDR;
// 32 bit address lines driven by the master

wire [2:0]  HSIZE;
// signal driven by master, denoting the size of transfer ex. byte, word

wire [2:0]  HBURST;
// signal driven by master, denoting type of burst ex. incr, wrap4
// (module i/p)

wire        HBUSREQx;
// driven by master; when high, indicating master requests the bus
// (module i/p)

wire        HGRANTx;
// signal indicating the grant-status of the master under test
// (module i/p)

wire        HREADY;
// signal indicating the completion of current transfer (module i/p)

wire        HLOCKx;
// when high, this indicates that master requires locked access
// (module i/p)

wire [63:0] HWDATA;
// write data, driven by the master  (module i/p)

wire [3:0]  HPROT;
// signal driven by master, giving additional info about the bus-access
// ex. supervisor mode, opcode mode etc (module i/p)

wire        HWRITE;
// signal driven by master, denoting whether it is write or read
// (module i/p)

wire [1:0]  HRESP;
// 2 bit wide response signal, indicating ok, retry, split or busy
// (module i/p)

wire        ResetOver;
// indicates that initial reset has been applied     ( module o/p)

wire [1:0]  ReqGnt;
// concatenation of HBUSREQx  and  HGRANTx signal

wire [1:0]  LokGnt;
// concatenation of HLOCKx  and  HGRANTx signal

wire [1:0]  GntRdy;
// concatenation of HGRANTx  and  HREADY signal

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg         CurrentStReq;
// current state signal for the state m/c checking
// Request-Assertion-Protocol

reg         NextStReq;
// next state signal for the state m/c checking
// Request-Assertion-Protocol

reg         CurrentStLok;
// current state signal for the state m/c checking
// Lock-Assertion-Protocol

reg         NextStLok;
// next state signal for the state m/c checking Lock-Assertion-Protocol

reg         CurrentStGnt;
// current state signals for the actual-grant checking state machine

reg         NextStGnt;
// next state signals for the actual-grant checking state machine

reg [31:0]  PrevAddr;
// stores the value of HADDR of the previous transfer

reg [31:0]  PrevAddrWait;
// stores the value of HADDR of the previous transfer in wait state

reg [1:0]   PrevTrans;
// stores the value of HTRANS of the previous transfer

reg [1:0]   PrevTransWait;
// stores the value of HTRANS of the previous transfer in wait state

reg         PrevWrite;
// stores the value of HWRITE of the previous transfer

reg         PrevWriteWait;
// stores the value of HWRITE of the previous transfer in wait state

reg [2:0]   PrevSize;
// stores the value of HSIZE of the previous transfer

reg [2:0]   PrevSizeWait;
// stores the value of HSIZE of the previous transfer in wait state

reg [2:0]   PrevBurst;
// stores the value of HBURST of the previous transfer

reg [2:0]   PrevBurstWait;
// stores the value of HBURST of the previous transfer in wait state

reg [3:0]   PrevProt;
// stores the value of HPROT of the previous transfer

reg [3:0]   PrevProtWait;
// stores the value of HPROT of the previous transfer in wait state

reg         PrevWrtData;
// stores the value of HWDATA of the previous transfer

reg [1:0]   PrevResp;
// stores the value of HRESP at previous HCLK posedge

reg         PrevReadyWait;
// stores the value of HREADY at previous HCLK posedge in wait state

reg         iResetOver;
// internal copy of ResetOver

reg         ResetStrd;
// indicates that reset has been asserted for at least one clock cycle

reg         RetSpltChk;
// flag indicating that the previous response was a retry/split or not

reg         NSEQOver;
// flag indicating that after getting grant, one NSEQ transfer is over

reg         PendBurst;
// indicates whether the master is degranted during a burst or not

reg         OneIdle;
// indicates if there is one idle cycle before the reference cycle

reg         TrfRetSp;
// indicates if previous transfer has been RETRIED/SPLITTED

reg         ClockedResetOver;
// Clocked version of the combinational ResetOver signal

reg         msg_Toha;
// notifier variable

reg         msg_Tohtr;
// notifier variable

reg         msg_Tohwrite;
// notifier variable

reg         msg_Tohsize;
// notifier variable

reg         msg_Tohburst;
// notifier variable

reg         msg_Tohprot;
// notifier variable

reg         msg_Tohwd;
// notifier variable

reg         msg_Tohreq;
// notifier variable

reg         msg_Tohlck;
// notifier variable

reg         msg_Tovtr;
// notifier variable

reg         msg_Tova;
// notifier variable

reg         msg_Tovwrite;
// notifier variable

reg         msg_Tovsize;
// notifier variable

reg         msg_Tovburst;
// notifier variable

reg         msg_Tovprot;
// notifier variable

reg         msg_Tovreq;
// notifier variable

reg         msg_Tovwd;
// notifier variable

reg         msg_Tovlck;
// notifier variable

// ---------------------------------------------------------------------
// Integer declarations
// ---------------------------------------------------------------------
integer CurrentTrans;
// indicates the transfer-number in the present burst

integer BurstLength;
// indicates the total no. of transfers in the burst

integer Size;
// no. of bytes indicated by the current HSIZE
`include "../common/funcsmaster.v"
`include "../tbench/buswmaster_pck.v"
// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

initial
  begin
    $timeformat(-9, 0, " ns", 13);
    CurrentStReq = `ST_NOTCHECK;
    NextStReq    = `ST_NOTCHECK;
    CurrentStLok = `ST_NOTCHECK;
    NextStLok    = `ST_NOTCHECK;
    CurrentStGnt = `ST_DEGRANTED;
    NextStGnt    = `ST_DEGRANTED;
    RetSpltChk   = `FALSE;
    NSEQOver     = `FALSE;
    PendBurst    = `FALSE;
    OneIdle      = `FALSE;
    CurrentTrans = 1;
    BurstLength  = 1;
    TrfRetSp     = 1'b0;
  end

// ---------------------------------------------------------------------
// Assigning the local copy to output
// ---------------------------------------------------------------------
assign ResetOver = iResetOver;
assign ReqGnt    = {HBUSREQx, HGRANTx};
assign LokGnt    = {HLOCKx, HGRANTx};
assign GntRdy    = {HGRANTx, HREADY};

// ---------------------------------------------------------------------
// No checking should start unless atleast one reset has been
// encountered. The following blocks set a flag on initial
// assertion/deassertion of reset. All the checks are performed only if
// this flag is set.
// ---------------------------------------------------------------------
always @(posedge HCLK)
begin : p_ResetStore
  if (HRESETn == 1'b0)
    ResetStrd <= `TRUE;
end

always @(HRESETn or ResetStrd)
begin : p_ResetOver
  if ((ResetStrd) && (HRESETn == 1'b1))
    iResetOver <= `TRUE;
end

// ---------------------------------------------------------------------
// The following block is the MAIN protocol checker block.
// ---------------------------------------------------------------------
always @ (posedge HCLK)
// ---------------------------------------------------------------------
// Variable declarations
// ---------------------------------------------------------------------
begin : p_ProtChkA
  if (HCLK == 1'b1)
  begin
    // The clocked version of ResetOver signal is being generated
    ClockedResetOver <= iResetOver;

    if (iResetOver) 
    begin
      // moving the state machines
      CurrentStReq  <= NextStReq;
      CurrentStLok  <= NextStLok;
      CurrentStGnt  <= NextStGnt;
      PrevReadyWait <= HREADY;

// ---------------------------------------------------------------------
// All the signals are checked at positive edges of the clock for
// unknowns. However the check should not start at the first clock after
// reset de-assertion. The rest of BusWatch operation should start from
// the very first clock after reset.
// ---------------------------------------------------------------------
      if (ClockedResetOver)
      begin
        CheckForX("HADDR", HADDR);
        CheckForX("HTRANS", HTRANS);
        CheckForX("HWRITE", HWRITE);
        CheckForX("HSIZE", HSIZE);
        CheckForX("HBURST", HBURST);
        CheckForX("HPROT", HPROT);
        CheckForX("HLOCKx", HLOCKx);
        CheckForX("HWDATA", HWDATA);
      end

// ---------------------------------------------------------------------
// This block checks, when master is not granted, HTRANS should only be
// either idle or nseq
// ---------------------------------------------------------------------
      if (CurrentStGnt == `ST_DEGRANTED)
      begin
        if (!((HTRANS == 2'b00) || (HTRANS == 2'b10)))
          $display("BWERRHTNI: Master is not driving HTRANS to NSEQ/IDLE ",
                   "when degranted.TIME : %t", $time);
      end

// ---------------------------------------------------------------------
// During wait states also, the following signals need to be latched as
// the checks on the basis of these are done during a wait state only.
// ---------------------------------------------------------------------
      if (HREADY == 1'b0)
      begin
        PrevTransWait <= HTRANS;
        PrevAddrWait  <= HADDR;
        PrevBurstWait <= HBURST;
        PrevSizeWait  <= HSIZE;
        PrevWriteWait <= HWRITE;
        PrevProtWait  <= HPROT;
      end

// ---------------------------------------------------------------------
// Normal burst going on without any split or degrant in between.
// ---------------------------------------------------------------------
      if (!(PendBurst) && (CurrentStGnt == `ST_GRANTED) &&
         (HREADY == 1'b1))
      begin
        // starting of a new burst
        if ((HTRANS == 2'b10 || HTRANS == 2'b00)  &&  (HREADY == 1'b1))
        begin
          if (HTRANS == 2'b00)
            OneIdle = `TRUE;
          else if (HTRANS == 2'b10)
          begin
            // previous burst has terminated completely
            if (CurrentTrans == BurstLength)
            begin
              CurrentTrans = 1;
              BurstLength  = NoOfBeatsIn(HBURST);
              PendBurst    = `FALSE;
              Size         = NoOfBytesIn(HSIZE);
              // At start of every burst, check for HBURST and HSIZE
              // combination
              // If it exceeds 1KB BOUNDARY, scream at once.
              if ((HADDR[9:0] + (BurstLength * Size)) > 'd1024)
                // a single-burst can never cross address boundary.In
                // case of INCR burst, address-boundary violation can't
                // be checked at beginning. Wrap bursts are incapable
                // of crossing address boundaries.
                if (!((HBURST == 3'b000) || (HBURST == 3'b001) ||
                    (HBURST == 3'b010) || (HBURST == 3'b100) ||
                    (HBURST == 3'b110)))
                  $display("BWERRHAB: Burst will cross 1KB BOUNDARY.HADDR ",
                           ": %h  TIME : %t", HADDR, $time);
            end
            // previous burst has been terminated early
            else if (CurrentTrans < BurstLength)
            begin
              if (PrevResp != 2'b01)
                $display("BWWAREBT: Master may have cancelled the burst before",
                         " finishing all the transfers. HADDR : %h. TIME : %t",
                         HADDR, $time);
              if (TrfRetSp == 1'b1)
              begin
                if (HADDR != PrevAddr)
                  $display ("BWERRHA: HADDR not incremented properly",
                            "according to HSIZE at HADDR : %h", HADDR,
                            "TIME : %t", $time);
              end
              CurrentTrans = 1;
              BurstLength  = NoOfBeatsIn(HBURST);
              PendBurst    = `FALSE;
              Size         = NoOfBytesIn(HSIZE);
              // At start of every burst, check for HBURST and HSIZE
              // combination. If it exceeds 1KB BOUNDARY, scream at
              // once.
              if ((HADDR[9:0] + (BurstLength * Size)) > 'd1024)
              // a single-burst can never cross address boundary.In
              // case of INCR burst, address-boundary violation can't
              // be checked at beginning. Wrap bursts are incapable of
              // crossing address boundaries.
                if (!((HBURST == 3'b000) || (HBURST == 3'b001) ||
                    (HBURST == 3'b010) || (HBURST == 3'b100) ||
                    (HBURST == 3'b110)))
                  $display("BWERRHAB : Burst will cross 1KB BOUNDARY.HADDR ",
                           ": %h  TIME : %t", HADDR, $time);
            end
          end
          // if RETRY or SPLIT responses are given, master has to come
          // up with same address and control signals
          if ((HRESP != 2'b10) && (HRESP != 2'b11))
          begin
            if (HTRANS != 2'b00)
            begin
                PrevAddr     <= HADDR;
                PrevWrite    <= HWRITE;
                PrevSize     <= HSIZE;
                PrevBurst    <= HBURST;
                PrevProt     <= HPROT;
                TrfRetSp     <= `FALSE;
            end
          end
          else if ((HRESP == 2'b10) || (HRESP == 2'b11))
          begin
            TrfRetSp <= `TRUE;
          end
          PrevTrans   <= HTRANS;
          PrevWrtData <= HWDATA;
          PrevResp    <= HRESP;
        end

        // previous burst continues with end of current transfer
        else if (((HTRANS == 2'b01) || (HTRANS == 2'b11))  &&  
                 (CurrentStGnt == `ST_GRANTED)  &&  (HREADY == 1'b1))
        begin
          // Check that control signals apart from HTRANS are unchanged
          Compare(HaltOnMismatch, "HWRITE", HWRITE, PrevWrite, HADDR,
                  "Bus Watch", "BWERRHW", "");
          Compare(HaltOnMismatch, "HPROT", HPROT, PrevProt, HADDR,
                  "Bus Watch", "BWERRHP", "");
          Compare(HaltOnMismatch, "HSIZE", HSIZE, PrevSize, HADDR,
                  "Bus Watch", "BWERRHS", "");
          Compare(HaltOnMismatch, "HBURST", HBURST, PrevBurst, HADDR,
                  "Bus Watch", "BWERRHB", "");

// ---------------------------------------------------------------------
// This portion checks that a busy transfer can only follow an NSEQ,
// SEQ or another BUSY transfer. Also, if the present transfer is SEQ,
// then the previous transfer should not be an IDLE one.
// ---------------------------------------------------------------------
          if (HTRANS == 2'b01)
          begin
            if (!((PrevTrans == 2'b01) || (PrevTrans == 2'b10) ||
                (PrevTrans == 2'b11)))
              $display("BWERRHTB : Current BUSY transfer is not preceded by",
                       " BUSY, NSEQ or SEQ transfer. HADDR : %h, TIME : %t",
                       HADDR, $time);
          end
          else if (HTRANS == 2'b11)
          begin
            if (!((PrevTrans == 2'b01) || (PrevTrans == 2'b10) || 
                (PrevTrans == 2'b11)))
              $display("BWERRHTS : Current SEQ transfer is not preceded by",
                       " BUSY, NSEQ or SEQ transfer. HADDR : %h, TIME : %t",
                       HADDR, $time);
          end

          // checking if the present HADDR value is proper in
          // accordance to previous HADDR  &&  HBURST, HSIZE values
          if (TrfRetSp == 1'b1)
          begin
            if (HADDR != PrevAddr)
              $display ("BWERRHA : HADDR not incremented properly",
                        "according to HSIZE at HADDR : %h", HADDR,
                        "TIME : %t", $time);
          end
          else if (TrfRetSp == 1'b0)
          begin
            CheckAddress(HBURST, HSIZE, HADDR, PrevAddr);
          end

          // If HTRANS indicates a busy transfer, the address should
          // remain unchanged in the next transfer.
          if (HTRANS != 2'b01)
          begin
            CurrentTrans = CurrentTrans + 1;
            // if an INCR burst, no value is given to BurstLength. But
            // to ensure that it tracks the CurrentTrans (for benefit
            // of latter checks) the following conditional assignment
            // is made.
            if (HBURST == 3'b001)
              BurstLength = CurrentTrans;
            // if RETRY or SPLIT responses are given, master has to
            // come up with same address and control signals
            if ((HRESP != 2'b10) && (HRESP != 2'b11))
            begin
              PrevAddr     <= HADDR;
              PrevWrite    <= HWRITE;
              PrevSize     <= HSIZE;
              PrevBurst    <= HBURST;
              PrevProt     <= HPROT;
              TrfRetSp     <= `FALSE;
            end
            else if ((HRESP == 2'b10) || (HRESP == 2'b11))
            begin
              TrfRetSp    <= `TRUE;
            end
          end
          PrevTrans   <= HTRANS;
          PrevWrtData <= HWDATA;
          PrevResp    <= HRESP;
        end

        // checking for crossing of 1KB BOUNDARY in case of incr burst.
        // HTRANS is checked to be SEQ, because if an address is > 1KB
        // but HTRANS = NSEQ, then protocolwise it is correct.
        if ((HBURST == 3'b001)  &&  (HADDR[10:0] > 10'b1111111111) &&
            (PrevAddr[10:0] <= 10'b1111111111) && (HTRANS == 2'b11))
          $display("BWERRHAB : 1KB BOUNDARY crossed. HADDR : %h", HADDR,
                   " TIME : %t", $time);
      end
// ---------------------------------------------------------------------
// The master had been degranted in middle of burst, but is now being
// regranted.
// ---------------------------------------------------------------------
      else if (PendBurst && (CurrentStGnt == `ST_GRANTED) &&
              (HREADY == 1'b1))
      begin
        // if HTRANS is NSEQ
        if (HTRANS == 2'b10)
        begin
          if (TrfRetSp == 1'b1)
          begin
            if (HADDR != PrevAddr)
              $display ("BWERRHA : HADDR not incremented properly",
                        "according to HSIZE at HADDR : %h", HADDR,
                        "TIME : %t", $time);
          end
          else if (TrfRetSp == 1'b0)
          begin
            CheckAddress(HBURST, HSIZE, HADDR, PrevAddr);
          end
          // Check HSIZE, HWRITE, HPROT are the same.
          Compare(HaltOnMismatch, "HWRITE", HWRITE, PrevWrite, HADDR,
                  "Bus Watch", "BWERRHW", "");
          Compare(HaltOnMismatch, "HPROT", HPROT, PrevProt, HADDR,
                  "Bus Watch", "BWERRHP", "");
          Compare(HaltOnMismatch, "HSIZE", HSIZE, PrevSize, HADDR,
                  "Bus Watch", "BWERRHS", "");
          PendBurst    = `FALSE;
          CurrentTrans = CurrentTrans + 1;
          // if an INCR burst, no value is given to BurstLength. But to
          // ensure that it tracks the CurrentTrans (for the benefit of
          // latter checks) the following conditional assignment is
          // made.
          if (HBURST == 3'b001)
            BurstLength = CurrentTrans;

          // if RETRY or SPLIT responses are given, master has to come
          // up with same address and control signals
          if ((HRESP != 2'b10) && (HRESP != 2'b11))
          begin
            PrevAddr     <= HADDR;
            PrevWrite    <= HWRITE;
            PrevSize     <= HSIZE;
            PrevBurst    <= HBURST;
            PrevProt     <= HPROT;
            TrfRetSp     <= `FALSE;
          end
          else if ((HRESP == 2'b10) || (HRESP == 2'b11))
          begin
            TrfRetSp <= `TRUE;
          end
          PrevTrans    <= HTRANS;
          PrevWrtData  <= HWDATA;
          PrevResp     <= HRESP;
        end
      end
// ---------------------------------------------------------------------
// Master has been degranted in middle of a burst,  and  thus it is
// checked that it is keeping its HBUSREQx high or not.
// ---------------------------------------------------------------------
      else if ((PendBurst)  &&  (CurrentStGnt == `ST_DEGRANTED))
      begin
        if (!(HBUSREQx == 1'b1))
          $display("BWERRHRQ: Master is degranted during a burst, but it is",
                   " not reasserting HBUSREQx. TIME : %t", $time);
        if (((HRESP == 2'b10) || (HRESP == 2'b11)) && HREADY == 1'b1)
        begin
          TrfRetSp <= `TRUE;
        end
      end

// ---------------------------------------------------------------------
// If HGRANTx is removed in middle of a continuing burst, then the
// master should keep its HBUSREQx high.
// ---------------------------------------------------------------------
      else if ( !(PendBurst)  &&  (CurrentStGnt == `ST_DEGRANTED))
      begin
        if (CurrentTrans < BurstLength)
        begin
          // An INCR burst can never terminate early. Every termination
          // of INCR burst is a proper one. This portion checks that
          // the master is keeping HBUSREQx high, even after being
          // degranted.
          if ((HBURST != 3'b001) && (HRESP != 2'b01))
          begin
            if (!(HBUSREQx == 1'b1))
              $display("BWERRHRQ : Master is degranted during a burst, but it",
                       " is not reasserting HBUSREQx. TIME : %t", $time);
            PendBurst = `TRUE;
            $display("Note : Master is being degranted in middle of a burst",
                     "TIME : %t", $time);
          end
          if (((HRESP == 2'b10) || (HRESP == 2'b11)) && HREADY == 1'b1)
          begin
            TrfRetSp <= `TRUE;
          end
        end
      end

// ---------------------------------------------------------------------
// When HREADY is held low, address  &&  control signal should not
// change. But when HREADY is pulled low for the first time, the
// control signals will change and hence PrevReadyWait is checked.
// ---------------------------------------------------------------------
      if (!(PendBurst) && (CurrentStGnt == `ST_GRANTED) &&
          (PrevReadyWait == 1'b0))
      begin
        if ((HREADY == 1'b0)  &&  (PrevReadyWait != 1'b1))
        begin
          Compare(HaltOnMismatch, "HADDR", HADDR, PrevAddrWait, HADDR,
                  "Bus Watch", "BWERRHA", "");
          if (PrevTransWait == 2'b00)
          begin
            if (!((HTRANS == 2'b10) || (HTRANS == 2'b00)))
              $display("BWERRHTIN : During a waited transfer at HADDR : %h,",
                       HADDR,
                       " IDLE transfer is changed to a transfer other than",
                       " NSEQ. TIME : %t", $time);
          end
          else if (PrevTransWait == 2'b01)
          begin
            if (!((HTRANS == 2'b01) || (HTRANS == 2'b11)))
              $display("BWERRHTBS : During a waited transfer at HADDR : %h,",
                       HADDR,
                       " BUSY transfer is changed to a transfer other than",
                       " SEQ. TIME : %t", $time);
          end
          else
            Compare(HaltOnMismatch, "HTRANS", HTRANS, PrevTransWait,
                    HADDR, "Bus Watch", "BWERRHT", "");
          // Check that control signals apart from HTRANS are unchanged
          Compare(HaltOnMismatch, "HWRITE", HWRITE, PrevWriteWait,
                  HADDR, "Bus Watch", "BWERRHW", "");
          Compare(HaltOnMismatch, "HPROT", HPROT, PrevProtWait, HADDR,
                  "Bus Watch", "BWERRHP", "");
          Compare(HaltOnMismatch, "HSIZE", HSIZE, PrevSizeWait, HADDR,
                  "Bus Watch", "BWERRHS", "");
          Compare(HaltOnMismatch, "HBURST", HBURST, PrevBurstWait,
                  HADDR, "Bus Watch", "BWERRHB", "");
        end
      end
// ---------------------------------------------------------------------
// HADDR Alignment-protocol-check
// ---------------------------------------------------------------------
      case (HSIZE)
        3'b001 :
          if (HADDR[0] != 1'b0)  
            FlashAlignErr(HADDR, HSIZE);
        3'b010 :
          if (HADDR[1:0] != 2'b00) 
            FlashAlignErr(HADDR, HSIZE);
        3'b011 :
          if (HADDR[2:0] != 3'b000) 
            FlashAlignErr(HADDR, HSIZE);
        3'b100 :
          if (HADDR[3:0] != 4'b0000) 
            FlashAlignErr(HADDR, HSIZE);
        3'b101 :
          if (HADDR[4:0] != 5'b00000) 
            FlashAlignErr(HADDR, HSIZE);
        3'b110 :
          if (HADDR[5:0] != 6'b000000) 
            FlashAlignErr(HADDR, HSIZE);
        3'b111 :
          if (HADDR[6:0] != 7'b0000000) 
            FlashAlignErr(HADDR, HSIZE);
        default :;
      endcase

// ---------------------------------------------------------------------
// When SPLIT/RETRY response is issued, the master should drive the
// next cycle as idle cycle.
// ---------------------------------------------------------------------
      if ((HREADY == 1'b0)  &&  ((HRESP == 2'b10) || (HRESP == 2'b11)))
        RetSpltChk <= `TRUE;
      else
        RetSpltChk <= `FALSE;
   
      if (RetSpltChk)
      begin
        if (!(HTRANS == 2'b00))
          $display("BWERRHTI : Master has not driven idle after receiving ",
                   "SPLIT/RETRY response. HADDR : %h.", HADDR,
                   " TIME : %t", $time);
        RetSpltChk <= `FALSE;
      end

// ---------------------------------------------------------------------
// If HSIZE indicates a data transfer wider than the width of bus, then
// the following portion flashes error.
// ---------------------------------------------------------------------
      case (`DATABUSWIDTH)
        'd32 :
          if (HSIZE > 3'b010)
            $display("BWERRHSDW : The size of attempted transfer is greater",
                     " than databuswidth. HADDR : %h. TIME : %t", HADDR, $time);
        'd64 :
          if (HSIZE > 3'b011)
            $display("BWERRHSDW : The size of attempted transfer is greater",
                     " than databuswidth. HADDR : %h. TIME : %t", HADDR, $time);
        default : ;
      endcase

// ---------------------------------------------------------------------
// If error response is provided, then Master can cancel an incomplete
// burst. It should not "scream" (unlike split or retry response). Thus
// this portion is included.
// ---------------------------------------------------------------------
      if ((HREADY == 1'b1)  &&  (HRESP == 2'b01))
      begin
// Commented out to eliminate excessive warning messages in the 
// simulation log file.
// Note that this commenting out is specific to the SMC PL092.
//        $display("Note : A burst is left incomplete due to cancellation by an",
//                 " error response. HADDR : %h. TIME : %t",
//                 HADDR, $time);
        CurrentTrans = 1;
        BurstLength  = 1;
      end
    end
  end
end  // p_ProtChkA;
 
// ---------------------------------------------------------------------
// This block checks that once a master asserts HBUSREQx, it should be
// kept asserted untill it gets the grant.
// ---------------------------------------------------------------------
always @ (CurrentStReq or ReqGnt or iResetOver)
begin : p_ProtChkB 
  if (iResetOver)
  begin
    if (CurrentStReq == `ST_CHECK)
    begin
      // when HBUSREQx is still high  and  bus is yet not granted
      if (ReqGnt == 2'b10)
        NextStReq <= `ST_CHECK;
      // HBUSREQx goes low before getting the grant
      else if (ReqGnt[1] == 1'b0)
      begin
        $display("BWERRHRQG : HBUSREQx deasserted before the Master is granted",
                 " the burst. TIME : %t", $time);
        NextStReq <= `ST_NOTCHECK;
      end
      // HBUSREQx is high  and  it has got the grant, so no violation
      else if ((ReqGnt) == 2'b11)
        NextStReq <= `ST_NOTCHECK;
    end
    else if (CurrentStReq == `ST_NOTCHECK)
    begin
      // when it has yet not asserted HBUSREQx or it requested and got
      // the grant at the same clock edge
      if ((ReqGnt[1] == 1'b0) || (ReqGnt == 2'b11))
        NextStReq <= `ST_NOTCHECK;
      else if (ReqGnt == 2'b10)
        NextStReq <= `ST_CHECK;
    end
  end
end  // p_ProtChkB;

// ---------------------------------------------------------------------
// This block checks that once a master asserts HLOCKx, it should be
// kept asserted until it gets the grant.
// ---------------------------------------------------------------------
always @ (CurrentStLok or LokGnt or iResetOver)
begin : p_ProtChkC
  if (iResetOver)
  begin
    if (CurrentStLok == `ST_CHECK)
    begin
      // when HLOCKx is still high  and  bus is yet not granted
      if (LokGnt == 2'b10)
        NextStLok <= `ST_CHECK;
      // HLOCKx goes low before getting the grant
      else if (LokGnt[1] == 1'b0)
      begin
        $display("BWERRHLG : HLOCKx deasserted before the Master is granted ",
                 "the burst. TIME : %t", $time);
        NextStLok <= `ST_NOTCHECK;
      end
      // HLOCKx is high  and  it has got the grant, so no violation
      else if ((LokGnt) == 2'b11)
        NextStLok <= `ST_NOTCHECK;
    end
    else if (CurrentStLok == `ST_NOTCHECK)
    begin
      // when it has yet not asserted HLOCKx or it requested  and  got
      // the grant at the same clock edge
      if ((LokGnt[1] == 1'b0) || (LokGnt == 2'b11))
        NextStLok <= `ST_NOTCHECK;
      else if (LokGnt == 2'b10)
        NextStLok <= `ST_CHECK;
    end
  end
end  // p_ProtChkC;

// ---------------------------------------------------------------------
// The following block checks that on being granted, the first transfer 
// indicated on HTRANS line is NSEQ or IDLE(it'll be IDLE only in case
// of tristate system implementation).
// ---------------------------------------------------------------------
always @ (posedge HCLK)
begin : p_ProtchkD
  if ((HCLK == 1'b1))
    if (CurrentStGnt == `ST_GRANTED)
    begin
      if (HTRANS == 2'b10)
        NSEQOver <= `TRUE;
      else if (((HTRANS == 2'b01) || (HTRANS == 2'b11)) && !(NSEQOver))
        $display("BWERRHTG : after getting the grant, master has not performed",
                 " NSEQ. HADDR : %h. TIME : %t", HADDR, $time);
    end
    else if (CurrentStGnt == `ST_DEGRANTED)
      NSEQOver <= `FALSE;
end  // p_ProtchkD;

// ---------------------------------------------------------------------
// The following block does the hold checks on the
// master-output-signals.
// ---------------------------------------------------------------------
specify
  specparam
    Toha   = `Toha,
    Tohtr  = `Tohtr,
    Tohctl = `Tohctl,
    Tohwd  = `Tohwd,
    Tohreq = `Tohreq,
    Tohlck = `Tohlck;
    $hold(posedge HCLK &&& HRESETn, HADDR, Toha, msg_Toha);
    $hold(posedge HCLK &&& HRESETn, HTRANS, Tohtr, msg_Tohtr);
    $hold(posedge HCLK &&& HRESETn, HWRITE, Tohctl, msg_Tohwrite);
    $hold(posedge HCLK &&& HRESETn, HSIZE, Tohctl, msg_Tohsize);
    $hold(posedge HCLK &&& HRESETn, HBURST, Tohctl, msg_Tohburst);
    $hold(posedge HCLK &&& HRESETn, HPROT, Tohctl, msg_Tohprot);
    $hold(posedge HCLK &&& HRESETn, HWDATA, Tohwd, msg_Tohwd);
    $hold(posedge HCLK &&& HRESETn, HBUSREQx, Tohreq, msg_Tohreq);
    $hold(posedge HCLK &&& HRESETn, HLOCKx, Tohlck, msg_Tohlck);
endspecify

always @(msg_Toha)
  $display("(Toha): Hold time violation on HADDR signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tohtr)
  $display("(Tohtr): Hold time violation on HTRANS signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tohwrite)
  $display("(Tohctl): Hold time violation on HWRITE signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tohsize)
  $display("(Tohctl): Hold time violation on HSIZE signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tohburst)
  $display("(Tohctl): Hold time violation on HBURST signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tohprot)
  $display("(Tohctl): Hold time violation on HPROT signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tohwd)
  $display("(Tohwd): Hold time violation on HWDATA signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tohreq)
  $display("(Tohreq): Hold time violation on HBUSREQx signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tohlck)
  $display("(Tohlck): Hold time violation on HLOCKx signal. HADDR: %h",
           HADDR, " TIME : %t", $time);

// ---------------------------------------------------------------------
// The following block does the valid checks on the
// master-output-signals.
// ---------------------------------------------------------------------
specify
  specparam
    Tostr  = (`Tclk - `Tovtr),
    Tosa   = (`Tclk - `Tova),
    Tosctl = (`Tclk - `Tovctl),
    Toswd  = (`Tclk - `Tovwd),
    Tosreq = (`Tclk - `Tovreq),
    Toslck = (`Tclk - `Tovlck);
    $setup(HTRANS, posedge HCLK &&& HRESETn, Tostr, msg_Tovtr);
    $setup(HADDR, posedge HCLK &&& HRESETn, Tosa, msg_Tova);
    $setup(HWRITE, posedge HCLK &&& HRESETn, Tosctl, msg_Tovwrite);
    $setup(HSIZE, posedge HCLK &&& HRESETn, Tosctl, msg_Tovsize);
    $setup(HBURST, posedge HCLK &&& HRESETn, Tosctl, msg_Tovburst);
    $setup(HPROT, posedge HCLK &&& HRESETn, Tosctl, msg_Tovprot);
    $setup(HBUSREQx, posedge HCLK &&& HRESETn, Tosreq, msg_Tovreq);
    $setup(HWDATA, posedge HCLK &&& HRESETn, Toswd, msg_Tovwd);
    $setup(HLOCKx, posedge HCLK &&& HRESETn, Toslck, msg_Tovlck);
endspecify

always @(msg_Tova)
  $display("(Tova): Valid time violation on HADDR signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tovtr)
  $display("(Tovtr): Valid time violation on HTRANS signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tovwrite)
  $display("(Tovctl): Valid time violation on HWRITE signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tovsize)
  $display("(Tovctl): Valid time violation on HSIZE signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tovburst)
  $display("(Tovctl): Valid time violation on HBURST signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tovprot)
  $display("(Tovctl): Valid time violation on HPROT signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tovwd)
  $display("(Tovwd): Valid time violation on HWDATA signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tovreq)
  $display("(Tovreq): Valid time violation on HBUSREQx signal. HADDR: %h",
           HADDR, " TIME : %t", $time);
always @(msg_Tovlck)
  $display("(Tovlck): Valid time violation on HLOCKx signal. HADDR: %h",
           HADDR, " TIME : %t", $time);

// ---------------------------------------------------------------------
// Grant Checking state machine.
// ---------------------------------------------------------------------
always @ (CurrentStGnt or GntRdy)
begin : p_GntStMachine
  case (CurrentStGnt)
    `ST_DEGRANTED :
      if (GntRdy == 2'b11)
        NextStGnt <= `ST_GRANTED;
      else
        NextStGnt <= CurrentStGnt;
    `ST_GRANTED :
      if (GntRdy == 2'b01)
        NextStGnt <= `ST_DEGRANTED;
      else
        NextStGnt <= CurrentStGnt;
    default :;
  endcase
end  // p_GntStMachine;

// ---------------------------------------------------------------------
// The following portion checks that during reset the master is driving
// only idle transfers. It has been separated from main protocol
// checker block as this is to be executed during reset, during which
// the main-protocol-checker block is disabled by ResetOver flag.
// ---------------------------------------------------------------------
always @ (posedge HCLK)
begin : p_ResetCheck
  if (HRESETn == 1'b0)
    if (HTRANS != 2'b00)
      $display("BWERRHTRES : At reset Master is not driving HTRANS to IDLE.",
               " TIME : %t", $time);
end  // p_ResetCheck;

endmodule

// --============================= End ===============================--
