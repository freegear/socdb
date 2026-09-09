//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2004 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//------------------------------------------------------------------------------
//  Version and Release Control Information:
//
// File Name              : DmacMasterWrap.v.rca
// File Revision          : 1.7
//
//  Release Information : ADK_r1p1v1
//
//------------------------------------------------------------------------------
//  Purpose             : This wrapper enables an AHB-Lite master to interface
//                        to an AHB system. The wrapper handles bus requests
//                        and slave responses, using MREADY as a means to hold
//                        the AHB-Lite master.
//============================================================================--

`timescale 1ns/1ps

module DmacMasterWrap
  (
   HCLK,
   HRESETn,
   HRDATA,
   HREADY,
   HRESP,
   HGRANT,
   HADDR,
   HTRANS,
   HWRITE,
   HSIZE,
   HBURST,
   HPROT,
   HWDATA,
   HBUSREQ,
   HLOCK,
   MADDR,
   MTRANS,
   MWRITE,
   MSIZE,
   MBURST,
   MPROT,
   MMASTLOCK,
   MWDATA,
   MRDATA,
   MREADY,
   MERROR
  );

  //----------------------------------------------------------------------------
  // AHB ports
  //----------------------------------------------------------------------------
  // Global signals
  input         HCLK;
  input         HRESETn;

  // Signals from AHB
  input [31:0]  HRDATA;
  input         HREADY;
  input [1:0]   HRESP;
  input         HGRANT;

  // Signals to AHB
  output [31:0] HADDR;
  output [1:0]  HTRANS;
  output        HWRITE;
  output [2:0]  HSIZE;
  output [2:0]  HBURST;
  output [3:0]  HPROT;
  output [31:0] HWDATA;
  output        HBUSREQ;
  output        HLOCK;

  //----------------------------------------------------------------------------
  // AHB-Lite ports
  //----------------------------------------------------------------------------
  // Signals from AHB-Lite
  input [31:0]  MADDR;
  input [1:0]   MTRANS;
  input         MWRITE;
  input [2:0]   MSIZE;
  input [2:0]   MBURST;
  input [3:0]   MPROT;
  input         MMASTLOCK;
  input [31:0]  MWDATA;

  // Signals to AHB-Lite
  output [31:0] MRDATA;
  output        MREADY;
  output        MERROR;

  //----------------------------------------------------------------------------
  // Constant declarations
  //----------------------------------------------------------------------------

  // HTRANS transfer
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11

  // HSIZE transfer type signal encoding
  `define SZ_BYTE  3'b000
  `define SZ_HALF  3'b001
  `define SZ_WORD  3'b010
  `define SZ_DWORD 3'b011

  // HBURST transfer type signal encoding
  `define BUR_SINGLE 3'b000
  `define BUR_INCR   3'b001
  `define BUR_WRAP4  3'b010
  `define BUR_INCR4  3'b011
  `define BUR_WRAP8  3'b100
  `define BUR_INCR8  3'b101
  `define BUR_WRAP16 3'b110
  `define BUR_INCR16 3'b111

  // Wrap boundary limits
  `define NOBOUND 3'b000
  `define BOUND4  3'b001
  `define BOUND8  3'b010
  `define BOUND16 3'b011
  `define BOUND32 3'b100
  `define BOUND64 3'b101

  // HRESP transfer response signal encoding
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

  // FSM States
  `define ST_NOGRANT_CLK   4'b0000
  `define ST_NOGRANT_HLD   4'b0100
  `define ST_REGRANT_CLK   4'b0010
  `define ST_REGRANT_HLD   4'b0110
  `define ST_GRANT_CLK     4'b0011
  `define ST_GRANT_SPLIT   4'b1111
  `define ST_GRANT_HLD     4'b0111
  `define ST_DEGRANT_CLK   4'b0001
  `define ST_DEGRANT_SPLIT 4'b1101
  `define ST_DEGRANT_HLD   4'b0101

  // Locked Idle FSM States
  `define ST_NO_LOCK          3'b110
  `define ST_IDLE_FIRST       3'b011
  `define ST_LOCKED_TRANSFERS 3'b111
  `define ST_UNLOCKED_IDLE    3'b010
  `define ST_LOCKED_IDLE      3'b101

  //----------------------------------------------------------------------------
  // Signal declarations
  //----------------------------------------------------------------------------

  // Port signals
  wire          HCLK;
  wire          HRESETn;
  wire [31:0]   HRDATA;
  wire          HREADY;
  wire [1:0]    HRESP;
  wire          HGRANT;
  wire [31:0]   HADDR;
  wire [1:0]    HTRANS;
  reg           HWRITE;
  wire [2:0]    HSIZE;
  wire [2:0]    HBURST;
  reg  [3:0]    HPROT;
  wire [31:0]   HWDATA;
  wire          HBUSREQ;
  wire          HLOCK;
  wire [31:0]   MADDR;
  wire [1:0]    MTRANS;
  wire          MWRITE;
  wire [2:0]    MSIZE;
  wire [2:0]    MBURST;
  wire [3:0]    MPROT;
  wire          MMASTLOCK;
  wire [31:0]   MWDATA;
  wire [31:0]   MRDATA;
  wire          MREADY;
  wire          MERROR;

  // Grant State Machine
  wire          Valid;
  reg [3:0]     NextState;
  reg [3:0]     State;

  // State machine decode flags
  wire          NextHoldReg;       // Transfer using holding regs
  wire          NextSplitRetry;    // High during 2nd cycle of S/R resp
  wire          NextReBuild;       // High when possible burst needs re-building
  wire          NextReGrant;       // High for first address transfer

  // Registered state decode flags
  reg           HoldReg;
  reg           SplitRetry;
  reg           ReBuild;
  reg           ReGrant;

  // Bus control flags
  reg           DataDrive;         // High when in conrol of data bus
  reg           AddrDrive;         // High when in conrol of address bus

  // Internal copies of output signals
  wire          iHBUSREQ;
  reg [31:0]    iHADDR;
  reg [2:0]     iHSIZE;
  wire          iMREADY;

  // Registered HBUSREQ signal
  reg           iHREQReg;

  // Signals to override MBURST when reconstructing a burst
  reg           IncrOverride;
  wire          NextIncrOverride;
  reg [2:0]     HburstMux;
  wire          FirstTransfer;

  // Signals to override HTRANS when reconstructing a wrapping burst
  reg [3:0]     OffsetAddr;
  reg [3:0]     CheckAddr;
  wire          WrappedNext;
  wire          WrappedEn;
  reg           Wrapped;

  // Signals to override HTRANS when MTRANS restarting any burst
  reg           BusyOverride;
  wire          NextBusyOverride;

  // Holding Register Select flag
  wire          HoldSel;

  // Holding Registers
  reg [31:0]    HaddrHold;
  reg           HwriteHold;
  reg [2:0]     HsizeHold;
  reg [3:0]     HprotHold;
  reg           HlockHold;
  reg [2:0]     HburstHold;
  reg [1:0]     HtransHold;

  // Signals to detect when a locked transfer requires an idle cycle to be
  // inserted at the beginning and end of the transfer
  wire          NextLockIdle;
  reg           LockIdle;
  reg  [2:0]    LockState;
  reg  [2:0]    NextLockState;
  wire          LockedTransfer;

  //----------------------------------------------------------------------------
  // Beginning of main code
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Grant FSM
  //----------------------------------------------------------------------------
  // The grant state machine tracks the combined arbiter and slave response on
  // AHB interface so appropriate control signals can be generated for the
  // wrapper functions.

  // Valid transfer flag generation, when the AHB-Lite master is attempting a
  // valid transfer the flag is set.

  assign Valid = (MTRANS == `TRN_NONSEQ || MTRANS == `TRN_SEQ) ? 1'b1 : 1'b0;

  // State Names
  //   ST_XXXX_CLK     - AHB-lite master is not stalled by MREADY
  //   ST_XXXX_HLD     - AHB-lite master is stalled by MREADY and holding
  //                     registers in use
  //   ST_XXXX_SPLIT   - Wrapper in 2nd cycle of split or retry
  //   ST_NOGRANT_XXX  - Wrapper not granted AHB interface
  //   ST_REGRANT_XXX  - Wrapper in 1st address phase after grant signal
  //                     asserted
  //   ST_GRANT_XXX    - Wrapper granted the bus for more than one cycle
  //   ST_DEGRANT_XXX  - Wrapper lost grant and in last data phase

  always @ (State or HREADY or HRESP or HGRANT or
            Valid or LockIdle or HtransHold)
    begin : p_NextStateComb
      case (State)

        `ST_NOGRANT_CLK : begin
          if  (!HREADY || !HGRANT)                   // Not Ready OR Not Granted
            begin
              if  (!Valid)                           //   Not Valid Transfer
                NextState = `ST_NOGRANT_CLK;
              else                                   //   Valid Transfer
                NextState = `ST_NOGRANT_HLD;
            end
          else                                       // Ready AND Granted
            if  (!Valid)                             //   Not Valid Transfer
              NextState = `ST_REGRANT_CLK;
            else                                     //   Valid Tranfer
              NextState = `ST_REGRANT_HLD;
        end // case: `ST_NOGRANT_CLK

        `ST_NOGRANT_HLD : begin
          if  (!HREADY || !HGRANT)                   // Not Ready OR Not Granted
            NextState = `ST_NOGRANT_HLD;
          else                                       // Ready AND Granted
            NextState = `ST_REGRANT_HLD;
        end // case: `ST_NOGRANT_HLD

        `ST_REGRANT_CLK : begin
          if  (!HREADY)                              // Not Ready
            begin
              if  (!Valid)                           //   Not Valid Transfer
                NextState = `ST_REGRANT_CLK;
              else                                   //   Valid Transfer
                NextState = `ST_REGRANT_HLD;
            end
          else                                       // Ready
            if (HGRANT)                              //   Granted
              NextState = `ST_GRANT_CLK;
            else                                     //   Not Granted
              NextState = `ST_DEGRANT_CLK;
        end // case: `ST_REGRANT_CLK

        `ST_REGRANT_HLD : begin
          if  (!HREADY)                              // Not Ready
            NextState = `ST_REGRANT_HLD;
          else                                       // Ready
            if  (HGRANT)                             //   Granted
              NextState = `ST_GRANT_CLK;
            else                                     //   Not Granted
              NextState = `ST_DEGRANT_CLK;
        end // case: `ST_REGRANT_HLD

        `ST_GRANT_CLK : begin
          if  (!HREADY)                              // Not Ready
            begin
              if  (HRESP == `RSP_SPLIT ||
                   HRESP == `RSP_RETRY)              //   Split/Retry
                NextState = `ST_GRANT_SPLIT;
              else                                   //   Not Split/Retry
                NextState = `ST_GRANT_CLK;
            end
          else                                       // Ready
            if  (HGRANT)                             //   Granted
              NextState = `ST_GRANT_CLK;
            else                                     //   Not Granted
              NextState = `ST_DEGRANT_CLK;
        end // case: `ST_GRANT_CLK

        `ST_GRANT_SPLIT : begin
          if  (!HGRANT)                              //   Not granted
            NextState = `ST_DEGRANT_HLD;
          else                                       //   Granted
            NextState = `ST_GRANT_HLD;
        end // case: `ST_GRANT_SPLIT

        `ST_GRANT_HLD : begin
          if  (!HGRANT)                              //   Not Granted
            NextState = `ST_DEGRANT_CLK;
          else                                       //   Granted
            NextState = `ST_GRANT_CLK;
        end // case: `ST_GRANT_HLD

        `ST_DEGRANT_CLK : begin
          if  (!HREADY)                              // Not Ready
            begin
              if  (HRESP == `RSP_SPLIT ||
                   HRESP == `RSP_RETRY)              //  Split/Retry
                NextState = `ST_DEGRANT_SPLIT;
              else                                   //  Not Split/Retry
                NextState = `ST_DEGRANT_CLK;
            end
          else                                       // Ready
            if  (!HGRANT)                            //   Not Granted
              begin
                if  (LockIdle)                       //  Need to use holding reg
                  begin
                    if (HtransHold == `TRN_NONSEQ || // Transfer waiting in
                        Valid)                       // registers or on AHB-Lite
                      NextState = `ST_NOGRANT_HLD;
                    else
                      NextState = `ST_NOGRANT_CLK;
                  end
                else
                  begin
                    if  (!Valid)                     //     Not Valid Transfer
                      NextState = `ST_NOGRANT_CLK;
                    else                             //     Valid Transfer
                      NextState = `ST_NOGRANT_HLD;
                  end
              end // if (!HGRANT)
            else                                     //   Granted
              if  (LockIdle)                         // Need to use holding reg
                begin
                    if (HtransHold == `TRN_NONSEQ || // Transfer waiting in
                        Valid)                       // registers or on AHB-Lite
                    NextState = `ST_REGRANT_HLD;
                  else
                    NextState = `ST_REGRANT_CLK;
                end
              else
                if  (!Valid)                         //     Not Valid Transfer
                  NextState = `ST_REGRANT_CLK;
                else                                 //     Valid Transfer
                  NextState = `ST_REGRANT_HLD;
        end // case: `ST_DEGRANT_CLK

        `ST_DEGRANT_SPLIT : begin
          if  (!HGRANT)                              // Not granted
            NextState = `ST_NOGRANT_HLD;
          else                                       // Granted
            NextState = `ST_REGRANT_HLD;
        end // case: `ST_DEGRANT_SPLIT

        `ST_DEGRANT_HLD : begin
          if  (!HGRANT)                               //   Not Granted
            NextState = `ST_NOGRANT_HLD;
          else                                        //   Granted
            NextState = `ST_REGRANT_HLD;
        end // case: `ST_DEGRANT_HLD

        default : NextState = `ST_NOGRANT_CLK;        //   default assignment

      endcase // case(State)

    end // block: p_NextStateComb

  // Loads the value of NextState in on each HCLK
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_StateSeq
      if  (!HRESETn)
        // Initial State
        State <= `ST_NOGRANT_CLK;
      else
        State <= NextState;
    end // block: p_StateSeq

  //----------------------------------------------------------------------------
  // State output decodes
  //----------------------------------------------------------------------------

  // States in which the holding resisters should be used
  assign NextHoldReg = (NextState == `ST_NOGRANT_HLD  ||
                        NextState == `ST_REGRANT_HLD  ||
                        NextState == `ST_GRANT_HLD    ||
                        NextState == `ST_GRANT_SPLIT  ||
                        NextState == `ST_DEGRANT_HLD  ||
                        NextState == `ST_DEGRANT_SPLIT) ? 1'b1

                       : 1'b0;

// States indicating the second cycle of a SPLIT/RETRY response
  assign NextSplitRetry = (NextState == `ST_GRANT_SPLIT  ||
                           NextState == `ST_DEGRANT_SPLIT) ? 1'b1

                          : 1'b0;

  // States in which a fixed length burst has to be re-built by wrapper
  assign NextReBuild = (NextState == `ST_GRANT_SPLIT  ||
                        NextState == `ST_DEGRANT_HLD  ||
                        NextState == `ST_NOGRANT_HLD  ||
                        NextState == `ST_REGRANT_HLD  ||
                        NextState == `ST_DEGRANT_CLK  ||
                        NextState == `ST_DEGRANT_SPLIT) ? 1'b1

                       : 1'b0;

  // States that indicate the wrapper has just gained control of the bus
  // i.e. the first address phase
  assign NextReGrant = (NextState == `ST_REGRANT_HLD  ||
                        NextState == `ST_REGRANT_CLK) ? 1'b1

                       : 1'b0;

  // Register state decodes
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_StateDecodeRegSeq
      if  (!HRESETn)
        begin
          HoldReg    <= 1'b0;
          SplitRetry <= 1'b0;
          ReBuild    <= 1'b0;
          ReGrant    <= 1'b0;
        end
      else
        begin
          HoldReg    <= NextHoldReg;
          SplitRetry <= NextSplitRetry;
          ReBuild    <= NextReBuild;
          ReGrant    <= NextReGrant;
        end
    end // block: p_StateDecodeRegSeq

  //----------------------------------------------------------------------------
  // Signals indicating control of address and data buses
  //----------------------------------------------------------------------------

  // Address bus control (AddrDrive) when HGRANT and HREADY sampled high
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_AddrDriveSeq
      if  (!HRESETn)
        AddrDrive <= 1'b0;
      else
        if (HREADY)
          AddrDrive <= HGRANT;
    end // block: p_AddrDriveSeq

  // Data bus control (DataDrive) when AddrDrive and HREADY sampled high
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_DataDriveSeq
      if  (!HRESETn)
        DataDrive <= 1'b0;
      else
        if (HREADY)
          DataDrive <= AddrDrive;
    end // block: p_DataDriveSeq

  //----------------------------------------------------------------------------
  // Address and control holding registers
  //----------------------------------------------------------------------------
  // These registers are used to hold the previous cycle's address and control
  // signals.
  // Registers are updated on every completed AHB-Lite transfer

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_ACHoldSeq
      if  (!HRESETn)
        begin
          HaddrHold  <= {32{1'b0}};
          HwriteHold <= 1'b0;
          HsizeHold  <= {3{1'b0}};
          HprotHold  <= {4{1'b0}};
          HlockHold  <= 1'b0;
          HburstHold <= {3{1'b0}};
          HtransHold <= {2{1'b0}};
        end
      else
        begin
          if  (iMREADY)
            begin
              HaddrHold  <= MADDR;
              HtransHold <= MTRANS;
              HwriteHold <= MWRITE;
              HsizeHold  <= MSIZE;
              HprotHold  <= MPROT;
              HlockHold  <= MMASTLOCK;
              HburstHold <= HburstMux;
            end
        end
    end // block: p_ACHoldSeq

  //----------------------------------------------------------------------------
  // Locked Transfer
  //----------------------------------------------------------------------------
  // Indicates when the master is attempting a locked transfer or when a locked
  // transfer is waiting in the holding registers.

  assign LockedTransfer = ((MMASTLOCK && !HoldSel) ||
                           (HlockHold && HoldSel)) ? 1'b1

                          : 1'b0;

  //----------------------------------------------------------------------------
  // Lock IDLE insert
  //----------------------------------------------------------------------------
  // When granted the bus and the AHB-Lite master starts a locked transfer an
  // idle cycle must be inserted, to ensure arbiter has a chance to change
  // HGRANT before the locked transfer begins. At the end of the locked
  // transfers the arbiter inserts 2 idle transfers, one which is a locked idle
  // due to HLOCK being asserted up to the last transfer, and another to allow
  // the arbiter to change the HGRANT signal.

  // Locked Idle State Machine
  always @ (AddrDrive or LockState or LockedTransfer)
  begin : p_LockedIdleFSMComb
    case (LockState)

      `ST_NO_LOCK : begin   
        if  (LockedTransfer)                                  // Locked transfer
          begin
            if  (AddrDrive)                          // already granted addr bus
              NextLockState = `ST_IDLE_FIRST;            // insert idle at start
            else
              NextLockState = `ST_LOCKED_TRANSFERS;    // start locked transfers
          end
        else
          NextLockState = `ST_NO_LOCK;
      end

     `ST_IDLE_FIRST :
       NextLockState = `ST_LOCKED_TRANSFERS;           // start locked transfers

     `ST_LOCKED_TRANSFERS : begin
     if  (!LockedTransfer)                        // current transfer not locked
       NextLockState = `ST_LOCKED_IDLE;           // insert locked idle transfer
     else
       NextLockState = `ST_LOCKED_TRANSFERS;        // continue locked transfers
     end

     `ST_LOCKED_IDLE :
       NextLockState = `ST_UNLOCKED_IDLE;         // always insert unlocked idle

     `ST_UNLOCKED_IDLE : begin
     if  (LockedTransfer)                    // start of another locked transfer
       begin
         if  (AddrDrive)                             // already granted addr bus
           NextLockState = `ST_IDLE_FIRST;               // insert idle at start
         else
           NextLockState = `ST_LOCKED_TRANSFERS;       // start locked transfers
       end
     else
       NextLockState = `ST_NO_LOCK;                   // end of locked transfers
     end

     default:                                        // illegal state transition
       NextLockState = `ST_NO_LOCK;

    endcase
  end // block: p_LockedIdleFSMComb

  // Locked FSM Registers
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_LockStateSeq
    if  (!HRESETn)
      LockState  <= `ST_NO_LOCK;
    else
     if (HREADY)                    // LockState is updated when HREADY asserted
       LockState <= NextLockState;
  end

  //----------------------------------------------------------------------------
  // Lock Idle
  //----------------------------------------------------------------------------
  // Indicates when HTRANS needs to be forced to IDLE due to the LockState
  // NextLockIdle is asserted:
  //   a) at the beginning of a burst/transfer if the master is already granted
  //      the bus.
  //   b) at the end of burst/transfer, this transfer is automatically locked
  //      since HLOCK remains asserted until the last locked address phase of
  //      the transfer has completed.
  //   c) after the previous locked idle to give the AHB arbiter a chance to
  //      re-arbitrate the AHB masters in the system.

  assign NextLockIdle = (((LockState == `ST_NO_LOCK ||
                           LockState == `ST_UNLOCKED_IDLE) &&
                          LockedTransfer &&
                          AddrDrive) ||                                   // (a)

                         (LockState == `ST_LOCKED_TRANSFERS &&
                          !LockedTransfer) ||                             // (b)

                         LockState == `ST_LOCKED_IDLE) ? 1'b1             // (c)

                        : 1'b0;

  // LockIdle loaded on each AHB transfer
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_LockIdleSeq
    if  (!HRESETn)
      LockIdle <= 1'b0;
    else
      if (HREADY)
        LockIdle <= NextLockIdle;
  end

  //----------------------------------------------------------------------------
  // Re-building bursts
  //----------------------------------------------------------------------------
  // When a fixed burst is interrupted due to a split, retry or loss of bus, it
  // is completed using the INCR burst of undefined length. HBURST is forced to
  // INCR when a burst has been interrupted.
  // Set Burst override when ReBuild flag set during a burst.
  // If the burst is interrupted on the first transfer, HBURST is not overridden

  // Indicates the first transfer in a burst
  assign FirstTransfer = ((HtransHold == `TRN_NONSEQ && HoldSel) ||
                          (MTRANS == `TRN_NONSEQ && !HoldSel)) ? 1'b1

                         : 1'b0;

  assign NextIncrOverride =  ((SplitRetry && HtransHold == `TRN_NONSEQ) ||

                             ((MTRANS == `TRN_NONSEQ || MTRANS == `TRN_IDLE) &&
                             !HoldSel)) ? 1'b0

                            : (ReBuild &&
                               !FirstTransfer) ? 1'b1

                            : IncrOverride;

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_IncrSeq
      if  (!HRESETn)
        IncrOverride <= 1'b0;
      else
        IncrOverride <= NextIncrOverride;
    end // block: p_IncrSeq

  //----------------------------------------------------------------------------
  // Wrapping address detection
  //----------------------------------------------------------------------------
  // When reconstructing a wrapping burst, the burst type is overridden by INCR.
  // The wrapping point needs to be detected as HTRANS should be NONSEQ to
  // effectively start another burst.

  always @ (iHADDR or iHSIZE)
    begin : p_OffsetAddrComb
      case (iHSIZE)
        `SZ_BYTE  : OffsetAddr = iHADDR[3:0];
        `SZ_HALF  : OffsetAddr = iHADDR[4:1];
        `SZ_WORD  : OffsetAddr = iHADDR[5:2];
        default   : OffsetAddr = 4'b0000;                        // illegal case
      endcase
    end // block: p_OffsetAddrComb

  always @ (OffsetAddr or MBURST)
    begin : p_CheckAddrComb
      case (MBURST)
        `BUR_WRAP4 :
          begin
            CheckAddr[1:0] = OffsetAddr[1:0];
            CheckAddr[3:2] = 2'b11;
          end

        `BUR_WRAP8 :
          begin
            CheckAddr[2:0] = OffsetAddr[2:0];
            CheckAddr[3]   = 1'b1;
          end

        `BUR_WRAP16 : CheckAddr[3:0] = OffsetAddr[3:0];

        `BUR_SINGLE, `BUR_INCR, `BUR_INCR4, `BUR_INCR8, `BUR_INCR16 :
          CheckAddr[3:0] = 4'b0000;

        default :
          CheckAddr[3:0] = 4'b0000;                     // illegal case

      endcase // case(HBURST)
    end // block: p_CheckAddrComb

  assign WrappedNext = (CheckAddr == 4'b1111) ? 1'b1 : 1'b0;

  // Wrapped is updated as each valid transfer is sampled onto the bus
  assign WrappedEn = iMREADY && Valid ? 1'b1 : 1'b0;
  
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_WrappedSeq
      if  (!HRESETn)
        Wrapped <= 1'b0;
      else
        if (WrappedEn)
          Wrapped <= WrappedNext;
    end // block: p_WrappedSeq

  //----------------------------------------------------------------------------
  // Re-gaining bus when MTRANS = BUSY
  //----------------------------------------------------------------------------
  // If the grant signal has been deasserted during a burst then it is possible
  //  that the wrapper will be granted the bus again when MTRANS is either SEQ
  //  or BUSY. When it is BUSY Valid = "0" hence the AHB-Lite master is not
  //  stalled by MREADY.
  // The wrapper cannot allow BUSY transfers on the regranted bus because it
  //  needs to start a burst before a BUSY transfer can be used. Therefore the
  //  BUSY transfers on MTRANS are forced to IDLE on HTRANS. When MTRANS becomes
  //  SEQ HTRANS is forced to NONSEQ to start a new burst.

  // Busy override set when wrapper granted the bus and MTRANS is BUSY
  // Busy override cleared when non-busy transfer is received from the master

  assign NextBusyOverride = (State == `ST_REGRANT_CLK && 
                             MTRANS == `TRN_BUSY) ? 1'b1

                            : MTRANS != `TRN_BUSY ? 1'b0

                            : BusyOverride;

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_BusySeq
      if  (!HRESETn)
        BusyOverride <= 1'b0;
      else
        BusyOverride <= NextBusyOverride;
    end

  //----------------------------------------------------------------------------
  // HTRANS output modification
  //----------------------------------------------------------------------------
  // HTRANS follows MTRANS except in the following conditions:
  //  * driven IDLE
  //     a) during the second cycle of a split/retry transfer
  //     b) when idle needs inserting before a locked transfer
  //     c) when not granted the bus
  //     d) when granted the bus whilst the master is driving BUSY
  //     e) when an address wrap occurs during a fixed length burst rebuild
  //        and master attempts a BUSY transfer

  //  * driven NONSEQ
  //     a) when a transfer is waiting in holding register
  //     b) when an address wrap occurs during a fixed length burst rebuild
  //     c) over-riding the first SEQ after the bus has been regranted

  assign HTRANS = (SplitRetry ||                                          // (a)
                   NextLockIdle ||                                        // (b)
                   !AddrDrive ||                                          // (c)
                   NextBusyOverride ||                                    // (d)
                   (Wrapped && IncrOverride &&
                    MTRANS == `TRN_BUSY && !HoldSel)) ? `TRN_IDLE         // (e)

                  : (HoldSel ||                                           // (a)
                     (Wrapped && IncrOverride && MTRANS == `TRN_SEQ) ||   // (b)
                     ((BusyOverride || ReGrant) && MTRANS == `TRN_SEQ))   // (c)
                      ? `TRN_NONSEQ

                  : MTRANS;

  //----------------------------------------------------------------------------
  // HBURST output
  //----------------------------------------------------------------------------
  // HBURST only forced to INCR when rebuilding a burst otherwise it is set to
  // the same state as HburstMux

  assign HBURST = NextIncrOverride ? `BUR_INCR

                  : HburstMux;

  //----------------------------------------------------------------------------
  // HLOCK output
  //----------------------------------------------------------------------------
  // HLOCK is primarily defined by the state of MMASTLOCK or HlockHold when
  // HoldSel is asserted. Except when the Lock transfer state machine is in the
  // Locked idle state. HLOCK is forced low to ensure an unlocked idle occurs
  // allowing the AHB arbiter to de-grant the master.

  assign HLOCK = LockState ==`ST_LOCKED_IDLE ? 1'b0

                 : HoldSel ? HlockHold

                 : MMASTLOCK;

  //----------------------------------------------------------------------------
  // Holding register multiplexer
  //----------------------------------------------------------------------------
  // Selects between the AHB-Lite signals or the holding registers for
  // generation of the AHB outputs.

  // Indicates when the holding registers are in use, either the holding
  // states of the FSM or the Idle transfer insertion.

  assign HoldSel = (HoldReg ||
                    (LockIdle && HtransHold == `TRN_NONSEQ)) ? 1'b1

                   : 1'b0;

  always @ (HoldSel or HaddrHold or HwriteHold or HsizeHold or HprotHold or
            HburstHold or MADDR or MWRITE or MSIZE or MPROT or MBURST)
    begin : p_ACMux
      if  (HoldSel)
        begin
          iHADDR    = HaddrHold;
          HWRITE    = HwriteHold;
          iHSIZE    = HsizeHold;
          HPROT     = HprotHold;
          HburstMux = HburstHold;
        end
      else
        begin
          iHADDR    = MADDR;
          HWRITE    = MWRITE;
          iHSIZE    = MSIZE;
          HPROT     = MPROT;
          HburstMux = MBURST;
        end
    end // block: p_ACMux

  assign HADDR = iHADDR;

  assign HSIZE = iHSIZE;

  //----------------------------------------------------------------------------
  // Bus request generation
  //----------------------------------------------------------------------------
  // HBUSREQ is asserted when:
  //  a) HBUSREQ is already asserted and the address bus not yet granted
  //  b) the master is attempting a transfer
  //  c) using the holding register

  assign iHBUSREQ = (iHREQReg && !AddrDrive && !DataDrive) ||  // (a)
                    MTRANS != `TRN_IDLE ||                     // (b)
                    HoldSel ? 1'b1                             // (c)

                   : 1'b0;

  assign  HBUSREQ = iHBUSREQ;

  // register previous value of HBUSREQ
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HreqStoreSeq
      if  (!HRESETn)
        iHREQReg <= 1'b0;
      else
        iHREQReg <= iHBUSREQ;
    end // block: p_HreqStoreSeq

  //----------------------------------------------------------------------------
  // Wait state detection
  //----------------------------------------------------------------------------
  // The MREADY input to the bus master is driven LOW when:
  //  - when HREADY is LOW and the wrapper controls the data bus
  //  - when a transfer is in the holding register waiting to complete

  assign iMREADY = (HoldSel || (DataDrive && !HREADY)) ? 1'b0

                   : 1'b1;

  assign  MREADY = iMREADY;

  //----------------------------------------------------------------------------
  // Error detection
  //----------------------------------------------------------------------------
  // MERROR is asserted when the wrapper controls the data bus and HRESP
  // indicates an error response.

  assign MERROR = (DataDrive && HRESP == `RSP_ERROR) ? 1'b1

                  : 1'b0;

  //----------------------------------------------------------------------------
  // Data drives
  //----------------------------------------------------------------------------

  // MWDATA is passed through unmodified, to HWDATA
  assign  HWDATA = MWDATA;

  // HRDATA is passed through unmodified, to MRDATA
  assign  MRDATA = HRDATA;

endmodule

// --================================== End ==================================--
