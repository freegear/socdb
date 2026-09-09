// --========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrAhbLite.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// ----------------------------------------------------------------------------
// Purpose :
//           DMAC AhbLite Master Interface
//
// --========================================================================--

`timescale 1ns/1ps
// ----------------------------------------------------------------------------

module DmacTrAhbLite (
// Inputs
                      HCLK,
                      HRESETn,
                      MREADY,
                      MERROR,
                      ChHLOCK,
                      ChWRITE,
                      ReqForAhbBus,
                      ChHPROT,
                      ChHSIZE,
                      ChAddr,
                      ChAddrIncr,
                      ChDisable,
                      ChPriority,
                      ChBeatCount,
// Outputs
                      MLOCK,
                      MPROT,
                      MBURST,
                      MTRANS,
                      MADDR,
                      MSIZE,
                      MWRITE,
                      DataValid,
                      DisAckMas,
                      StopArb,
                      ErrorMas
                      );

// Inputs
input         HCLK;         // AHB clock
input         HRESETn;      // AHB Reset
input         MREADY;       // Indicates waited transfers
input         MERROR;       // Indicates Error response
input         ChHLOCK;      // HLOCK information
input         ChWRITE;      // HWRITE information
input         ReqForAhbBus; // AHB Transfer Request from Arbiter
input   [3:0] ChHPROT;      // HPROT information
input   [2:0] ChHSIZE;      // HSIZE information
input  [31:0] ChAddr;       // HADDR information
input         ChAddrIncr;   // Incrementing transfer indication
input         ChDisable;    // Signal to abort the transfer
input         ChPriority;   // Priority of a channel
input   [4:0] ChBeatCount;  // Number of transfers requested

// Outputs
output        MLOCK;        // Lock transfer Information
output  [3:0] MPROT;        // Protection Information on AHB
output  [2:0] MBURST;       // Burst Information
output  [1:0] MTRANS;       // Type of transfer on AHB
output [31:0] MADDR;        // AHB Slave Address to be accessed for transfer
output  [2:0] MSIZE;        // Width of the AHB data transfer
output        MWRITE;       // Signal to specify the read or write transfer
                            // to/from slave
output        DataValid;    // Signal used for data transfer
output        DisAckMas;    // Acknowledge for Disable action
output        StopArb;      // Stop Arbitration
output        ErrorMas;     // Error on AHB Slave




// Inputs
  wire        HCLK;         // AHB clock
  wire        HRESETn;      // AHB Reset
  wire        MREADY;       // Indicates waited transfers
  wire        MERROR;       // Indicates Error response
  wire        ChHLOCK;      // HLOCK information
  wire        ChWRITE;      // HWRITE information
  wire        ReqForAhbBus; // AHB Transfer Request from Arbiter
  wire  [3:0] ChHPROT;      // HPROT information
  wire  [2:0] ChHSIZE;      // HSIZE information
  wire [31:0] ChAddr;       // HADDR information
  wire        ChAddrIncr;   // Incrementing transfer indication
  wire        ChDisable;    // Signal to abort the transfer
  wire        ChPriority;   // Priority of a channel
  wire  [4:0] ChBeatCount;  // Number of transfers requested

// Outputs
  wire        MLOCK;        // Lock transfer Information
  wire  [3:0] MPROT;        // Protection Information on AHB
  wire  [2:0] MBURST;       // Burst Information
  wire  [1:0] MTRANS;       // Type of transfer on AHB
  wire [31:0] MADDR;        // AHB Slave Address to be accessed for transfer
  wire  [2:0] MSIZE;        // Width of the AHB data transfer
  wire        MWRITE;       // Signal to specify the read or write transfer
                            // to/from slave
  reg         DataValid;    // Signal used for data transfer
  reg         DisAckMas;    // Acknowledge for Disable action
  wire        StopArb;      // Stop Arbitration
  wire        ErrorMas;     // Error on AHB Slave


// -----------------------------------------------------------------------------
//
//                                DmacTrAhbLite
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//   This module implements the AHB Lite Master Interface for the DMAC. This
//   module with Wrapper behaves as a full master. This module has a single
//   state machine which takes care of putting all valid transactions on the
//   bus.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire  [7:0] StrtBurstInfo;
// Signal to Hold Burst and BeatCount information at the beginning of burst

wire  [7:0] MidBurstInfo;
// Signal to Hold Burst and BeatCount information at the middle of burst

wire  [2:0] WidthFactor;
// Width of the burst in terms of Bytes

wire  [2:0] WidthFactorR;
// Width of the burst registered when MREADY is not asserted but StopArb is low

wire  [7:0] StrtBurstInfoR;
// Signal to Hold Burst and BeatCount information at the beginning of burst
// when MREADY is not asserted but StopArb is low

// -----------------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg   [3:0] MasterState;
// State Flip flops for Master SM

reg   [3:0] NextMasterState;
// D-Input of MasterState flip flops

reg   [4:0] BeatCount;
// Beat counter to track the multiple burst

reg   [4:0] NextBeatCount;
// D-Input of BeatCount register

reg   [4:0] ReqCount;
// Counter to track the requested beat from channel

reg   [4:0] NextReqCount;
// D-Input of ReqCount register

reg  [31:0] AhbAddr;
// Source/Destination/LLI Address from Channel

reg  [31:0] NextAhbAddr;
// D-Input of AhbAddr register

reg   [1:0] iMTRANS;
// Internal copy of MTRANS

reg   [1:0] NextMTRANS;
// D-Input of iMTRANS register

reg   [1:0] DelMTRANS;
// Delayed version of MTRANS

reg   [2:0] iMBURST;
// Internal copy of MBURST

reg   [2:0] NextMBURST;
// D-Input of iMBURST register

reg         iMWRITE;
// Internal copy of MWRITE register

reg         NextMWRITE;
// D-Input of iMWRITE register

reg         iMLOCK;
// Internal copy of MLOCK register

reg         NextMLOCK;
// D-Input of iMLOCK register

reg   [3:0] iMPROT;
// Internal copy of MPROT register

reg   [3:0] NextMPROT;
// D-Input of iMPROT register

reg   [2:0] iMSIZE;
// Internal copy of MSIZE register

reg   [2:0] NextMSIZE;
// D-Input of iMSIZE register

reg         PrevPriority;
// Reg To store the current priority of the transfer for use in HTRANS decision
// for the next transfer

reg         NextPrevPriority;
// D-Input of PrevPriority register

reg         iStopArb;
// Internal copy of StopArb register

reg         NextStopArb;
// D-Input of iStopArb register

reg         UseBuffVal;
// Indication to use registered values

reg         NextUseBuffVal;
// D-Input of UseBuffVal register

reg   [4:0] ReqCountR;
// Registered Reqcount when StopArb was low but MREADY is not sampled

reg   [4:0] NextReqCountR;
// D-Input of NextReqCountR

reg  [31:0] AhbAddrR;
// Registered AhbAddr when StopArb was low but MREADY is not sampled

reg  [31:0] NextAhbAddrR;
// D-Input of AhbAddrR

reg   [2:0] MSIZER;
// Registered MSIZE when StopArb was low but MREADY is not sampled

reg   [2:0] NextMSIZER;
// D-Input of MSIZER

reg   [3:0] MPROTR;
// Registered MPROT when StopArb was low but MREADY is not sampled

reg   [3:0] NextMPROTR;
// D-Input of MPROTR

reg         MLOCKR;
// Registered MLOCK when StopArb was low but MREADY is not sampled

reg         NextMLOCKR;
// D-Input of MLOCKR

reg         MWRITER;
// Registered MWRITE when StopArb was low but MREADY is not sampled

reg         NextMWRITER;
// D-Input of MWRITER

reg         ChPriorityR;
// Registered ChPriority when StopArb was low but MREADY is not sampled

reg         NextChPriorityR;
// D-Input of ChPriorityR

reg         ChDisableR;
// Registered ChDisable when StopArb was low but MREADY is not sampled

reg         NextChDisableR;
// D-Input of ChDisableR

reg         ChAddrIncrR;
// Registered ChAddrIncrR when StopArb was low but MREADY is not sampled

reg         NextChAddrIncrR;
// D-Input of ChAddrIncrR

// -----------------------------------------------------------------------------
// Package insertion
// -----------------------------------------------------------------------------
`include "DmacTrParams.v"

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Incr32:
// The function to increment the AHB address for incrementing burst transfers on
// the AHB for pipe-lining.
// The address is incremented by either 1, 2 or 4 depending on the
// size of the transfer (i.e. MSIZE)
// The function takes 2 arguments Current Address and the size of the transfer
// and returns the incremented address.
// -----------------------------------------------------------------------------
function [31:0] Incr32;
input [31:0] Addr;
input  [2:0] HSize;
begin
  case (HSize)
    `BYTE :
      Incr32 = Addr + 32'b1;

    `HWORD :
      Incr32 = Addr + 32'b10;

    `WORD :
      Incr32 = Addr + 32'b100;

    default :
      Incr32 = 32'b0;
  endcase
end
endfunction

// ----------------------------------------------------------------------------
// The function OneKbChk is used to find out whether the address is in
// the 1KB Range at the start of data phase and it is used to find out whether
// the burst is about to cross the 1KB boundhary. Based on this information
// MBURST value and Beat Counter are loaded appropriately.
//
// This function is executed at the time of sampling the Bus request. This
// function basically decides (depending on the actual AHB Bus output address
// bits (9:0)) what kind of Increment burst can be performed so that the 1KB
// boundary is not crossed in a burst sequence.
// ----------------------------------------------------------------------------
function [7:0] OneKbChk;
input  [9:0] Addr;
input  [2:0] WidthFactor;
input  [4:0] BeatCount;
input        AddrInc;

reg    [2:0] HburstVal;
// Possible Burst Value
reg    [2:0] Hburst;
// Calculated Burst Value
reg    [4:0] BeatVal;
// Number of Transfers
reg    [4:0] BeatValPos;
// Possible Transfers
reg    [4:0] Temp;
// Temporay variable
begin
  if (AddrInc == 1)
    begin
      case (WidthFactor)
        3'b001 :
          begin
            if ((& Addr[9:4]) == 1)
              begin
                if (Addr[3] == 1)
                  begin
                    if (Addr[2] == 1)
                      begin
                        if ((| Addr[1:0]) == 1)
                          begin
                            HburstVal = `UINCR;
                            Temp = {3'b000, Addr[1:0]};
                            BeatValPos = 4 - Temp;
                          end
                        else
                          begin
                            HburstVal = `INCR4;
                            BeatValPos = 5'b00100;
                          end
                      end
                    else if ((| Addr[1:0]) == 1)
                      begin
                        HburstVal = `INCR4;
                        BeatValPos = 5'b00100;
                      end
                    else
                      begin
                        HburstVal = `INCR8;
                        BeatValPos = 5'b01000;
                      end
                  end
                else if ((| Addr[2:0]) == 1)
                  begin
                    HburstVal = `INCR8;
                    BeatValPos = 5'b01000;
                  end
                else
                  begin
                    HburstVal = `INCR16;
                    BeatValPos = 5'b10000;
                  end
              end
            else
              begin
                HburstVal = `INCR16;
                BeatValPos = 5'b10000;
              end
          end
  
        3'b010 :
          begin
            if ((& Addr[9:5]) == 1)
              begin
                if (Addr[4] == 1)
                  begin
                    if (Addr[3] == 1)
                      begin
                        if ((|Addr[2:1]) == 1)
                          begin
                            HburstVal = `UINCR;
                            Temp = {"000", Addr[2:1]};
                            BeatValPos = 4 - Temp;
                          end
                        else
                          begin
                            HburstVal = `INCR4;
                            BeatValPos = 5'b00100;
                          end
                      end
                    else if ((| Addr[2:1]) == 1)
                      begin
                        HburstVal = `INCR4;
                        BeatValPos = 5'b00100;
                      end
                    else
                      begin
                        HburstVal = `INCR8;
                        BeatValPos = 5'b01000;
                      end
                  end
                else if ((| Addr[3:1]) == 1)
                  begin
                    HburstVal = `INCR8;
                    BeatValPos = 5'b01000;
                  end
                else
                  begin
                    HburstVal = `INCR16;
                    BeatValPos = 5'b10000;
                  end
              end
            else
              begin
                HburstVal = `INCR16;
                BeatValPos = 5'b10000;
              end
          end
  
        3'b100 :
          begin
            if ((& Addr[9:6]) == 1)
              begin
                if (Addr[5] == 1)
                  begin
                    if (Addr[4] == 1)
                      begin
                        if ((| Addr[3:2]) == 1)
                          begin
                            HburstVal = `UINCR;
                            Temp = {"000", Addr[3:2]};
                            BeatValPos = 4 - Temp;
                          end
                        else
                          begin
                            HburstVal = `INCR4;
                            BeatValPos = 5'b00100;
                          end
                      end
                    else if ((|Addr[3:2]) == 1)
                      begin
                        HburstVal = `INCR4;
                        BeatValPos = 5'b00100;
                      end
                    else
                      begin
                        HburstVal = `INCR8;
                        BeatValPos = 5'b01000;
                      end
                  end
                else if ((|Addr[4:2]) == 1)
                  begin
                    HburstVal = `INCR8;
                    BeatValPos = 5'b01000;
                  end
                else
                  begin
                    HburstVal = `INCR16;
                    BeatValPos = 5'b10000;
                  end
              end
            else
              begin
                HburstVal = `INCR16;
                BeatValPos = 5'b10000;
              end
          end
  
        default :
          begin
            HburstVal = 'b0;
            BeatValPos = 'b0;
          end
      endcase
  
      case (HburstVal)
        `UINCR :
          begin
            Hburst = `UINCR;
            if (BeatCount > BeatValPos)
              BeatVal = BeatValPos;
            else
              BeatVal = BeatCount;
          end
  
        `INCR4 :
          begin
            if (BeatCount < 5'b00100)
              begin
                Hburst  = `UINCR;
                if (BeatCount > BeatValPos)
                  BeatVal = BeatValPos;
                else
                  BeatVal = BeatCount;
              end
            else
              begin
                Hburst  = `INCR4;
                BeatVal = 5'b00100;
              end
          end
  
        `INCR8 :
          begin
            if (BeatCount < 5'b00100)
              begin
                Hburst  = `UINCR;
                if (BeatCount > BeatValPos)
                  BeatVal = BeatValPos;
                else
                  BeatVal = BeatCount;
              end
            else if (BeatCount < 5'b01000)
              begin
                Hburst  = `INCR4;
                BeatVal = 5'b00100;
              end
            else
              begin
                Hburst  = `INCR8;
                BeatVal = 5'b01000;
              end
          end
  
        `INCR16 :
          begin
            if (BeatCount < 5'b00100)
              begin
                Hburst  = `UINCR;
                if (BeatCount > BeatValPos)
                  BeatVal = BeatValPos;
                else
                  BeatVal = BeatCount;
              end
            else if (BeatCount < 5'b01000)
              begin
                Hburst  = `INCR4;
                BeatVal = 5'b00100;
              end 
            else if (BeatCount < 5'b10000)
              begin
                Hburst  = `INCR8;
                BeatVal = 5'b01000;
              end 
            else
              begin
                Hburst  = `INCR16;
                BeatVal = 5'b10000;
              end 
          end
  
        default :
          begin
            Hburst  = 'b0;
            BeatVal = 'b0;
          end
      endcase
    end
  else
    begin
      Hburst  = `UINCR;
      BeatVal = BeatCount;
    end

  OneKbChk = {BeatVal, Hburst};
end
endfunction

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Connecting local copies
// -----------------------------------------------------------------------------
assign MTRANS           = iMTRANS;
assign MBURST           = iMBURST;
assign MLOCK            = iMLOCK;
assign MPROT            = iMPROT;
assign MSIZE            = iMSIZE;
assign MWRITE           = iMWRITE;
assign StopArb          = iStopArb;
assign MADDR            = AhbAddr;
assign ErrorMas         = MERROR;

// -----------------------------------------------------------------------------
// Main State Machine
// This state machine has the following states.
// `ST_AHBM_INIT:
//   In this state if MREADY and ReqForAhbBus are sampled asserted, then the
//   State Machine(SM) will make a transition to the `ST_AHBM_ADDRXFR state.
//   Transition to the `ST_AHBM_ADDRXFR state happens with MTRANS as NSEQ.
//   While transitioning out of this state all the Channel information are
//   registered.
//
// `ST_AHBM_ADDRXFR:
//   This state is mainly for pipelining the Address so that 1 level of
//   pipeline is maintained. Most of the logic in this state and `ST_AHBM_ACTIVE
//   is similar hence while coding both of these states are merged. Whenever
//   the SM enters this state it always enters by putting NSEQ on MTRANS. The
//   SM enters `ST_AHBM_ACTIVE immediately next clock when MREADY is sampled
//   asserted. A crossOver of 1KByte range is also checked in this state. The
//   next access is pipelined so that either a new burst is pipelined or the
//   next transfer of same burst is pipelined.
//
// `ST_AHBM_ACTIVE:
//   In this state valid data transfer takes place. After every MREADY received.
//   The Datavalid for that particular Channel is asserted. The SM always comes
//   to the ACTIVE state after ADDRXFR state only.
//               In this state the HTRANS are changed for new burst only if
//               -- AHB 32 bit Address Output bits 9:0 indicate that the Address
//                  is about to cross 1KB boundary.
//               -- Beat Count for current burst becomes = 1 indicating that
//                  current transfer is last being pipelined for the current
//                  ongoing burst, but given that the Number of Words committed
//                  for transfer are greater than 1.
//               -- The MTRANS put for the previous cycle was IDLE, this may
//                  occur because of low priority channel transfer followed by
//                  another low priority transfer.
//
//               When in this state the Number of Words committed for previous
//               Channel Request become equal to 1 and the MTRANS are put for
//               a valid data transfer value (NSEQ or SEQ), indicating that the
//               last of committed Number of Words is being piped onto the AHB
//               bus, the SM again samples the ReqForAhbBus and it may
//               reinitiate the new committed transfer if Channel continues to
//               request for more data at this instant of sampling. If the
//               sampled ReqForAhbBus does not indicate any request for data
//               transfer the SM goes to `ST_AHBM_INIT state where it waits for
//               the ReqForAhbBus to go active
//
// -----------------------------------------------------------------------------
always @(MasterState or BeatCount or ReqCount or AhbAddr or iMTRANS or
         iMBURST or iMWRITE or iMLOCK or iMPROT or iMSIZE or ChAddrIncr or
         ChDisable or PrevPriority or MREADY or iStopArb or ReqForAhbBus or
         StrtBurstInfo or ChBeatCount or ChAddr or ChHSIZE or ChHPROT or
         ChHLOCK or ChWRITE or ChPriority or MERROR or MidBurstInfo or
         StrtBurstInfoR or ReqCountR or AhbAddrR or MSIZER or MPROTR or
         MLOCKR or MWRITER or ChPriorityR or ChDisableR or UseBuffVal)
begin : p_LiteSMComb
   NextMasterState  = MasterState;
   NextBeatCount    = BeatCount;
   NextReqCount     = ReqCount;
   NextAhbAddr      = AhbAddr;
   NextMTRANS       = iMTRANS;
   NextMSIZE        = iMSIZE;
   NextMPROT        = iMPROT;
   NextMLOCK        = iMLOCK;
   NextMBURST       = iMBURST;
   NextMWRITE       = iMWRITE;
   NextPrevPriority = PrevPriority;
   DisAckMas        = 1'b0;
  case (MasterState)
    `ST_AHBM_INIT :
      begin
        if (ChDisable == 1'b0)
          begin
            if ((MREADY == 1'b1) && (iStopArb == 1'b0) &&
                (ReqForAhbBus == 1'b1))
              begin
                 NextBeatCount    = StrtBurstInfo[7:3];
                 NextReqCount     = ChBeatCount;
                 NextAhbAddr      = ChAddr;
                 NextMSIZE        = ChHSIZE;
                 NextMPROT        = ChHPROT;
                 NextMLOCK        = ChHLOCK;
                 NextMBURST       = StrtBurstInfo[2:0];
                 NextMWRITE       = ChWRITE;
                 NextPrevPriority = ChPriority;
                 NextMasterState  = `ST_AHBM_ADDRXFR;
                 NextMTRANS       = `NSEQ;
              end
            else
              begin
                 NextBeatCount    = ('d0);
                 NextReqCount     = ('d0);
                 NextAhbAddr      = ('d0);
                 NextMTRANS       = ('d0);
                 NextMSIZE        = ('d0);
                 NextMPROT        = ('d0);
                 NextMLOCK        = 1'b0;
                 NextMBURST       = ('d0);
                 NextMWRITE       = 1'b0;
                 DisAckMas        = 1'b0;
                 NextPrevPriority = 1'b0;
              end
          end
        else
          begin
            NextBeatCount    = ('d0);
            NextReqCount     = ('d0);
            NextAhbAddr      = ('d0);
            NextMTRANS       = ('d0);
            NextMSIZE        = ('d0);
            NextMPROT        = ('d0);
            NextMLOCK        = 1'b0;
            NextMBURST       = ('d0);
            NextMWRITE       = 1'b0;
            DisAckMas        = 1'b1;
            NextPrevPriority = 1'b0;
          end
      end

    `ST_AHBM_ADDRXFR, `ST_AHBM_ACTIVE :
      begin
        if ((MasterState == `ST_AHBM_ACTIVE) && (MERROR == 1'b1))
          begin
            NextMasterState  = `ST_AHBM_INIT;
            NextBeatCount    = ('d0);
            NextReqCount     = ('d0);
            NextAhbAddr      = ('d0);
            NextMTRANS       = `IDLE;
            NextMSIZE        = ('d0);
            NextMPROT        = ('d0);
            NextMLOCK        = 1'b0;
            NextMBURST       = ('d0);
            NextMWRITE       = 1'b0;
            DisAckMas        = 1'b0;
            NextPrevPriority = 1'b0;
          end
        else if (MREADY == 1'b1)
          begin
            if ((ChDisable == 1'b1) && ((iMBURST == `UINCR) ||
                                                       (BeatCount == 5'b00001)))
              begin
                if (iMBURST == `UINCR)
                   NextMTRANS       = `IDLE;
                else if (ReqForAhbBus == 1'b1)
                  begin
                    if ((ChPriority == 1'b0) && (PrevPriority == 1'b0))
                       NextMTRANS       = `IDLE;
                    else
                       NextMTRANS       = `NSEQ;
                  end
                else
                  NextMTRANS       = `IDLE;
              end
            else if (ReqCount > 5'b00001)
              begin
                if ((iMTRANS == `IDLE) || (ChAddrIncr == 1'b0) ||
                                                        (BeatCount == 5'b00001))
                   NextMTRANS       = `NSEQ;
                else
                   NextMTRANS       = `SEQ;
              end
// The Following 2 lines are added for lock transfers and Priority transfers
            else if ((ReqCount == 5'b00001) && (iMTRANS == `IDLE) &&
                                                        (ReqForAhbBus == 1'b1))
              NextMTRANS       = `NSEQ;
            else if (ReqCount == 5'b00001)
              begin
                if (PrevPriority == 1'b0)
                   NextMTRANS       = `IDLE;
                else if (ReqForAhbBus == 1'b1)
                   NextMTRANS       = `NSEQ;
                else
                   NextMTRANS       = `IDLE;
              end
            else if ((ReqCount == 5'b00000) && (iMTRANS == `IDLE) &&
                                                        (ReqForAhbBus == 1'b1))
              NextMTRANS       = `NSEQ;
            else
              NextMTRANS       = `IDLE;
    
            if ((ChDisable == 1'b1) && ((iMBURST == `UINCR) ||
                                                      (BeatCount == 5'b00001)))
              begin
                if (iMBURST == `UINCR)
                  begin
                    NextBeatCount    = ('d0);
                    NextReqCount     = ('d0);
                    NextAhbAddr      = ('d0);
                    NextMSIZE        = ('d0);
                    NextMPROT        = ('d0);
                    NextMLOCK        = 1'b0;
                    NextMBURST       = ('d0);
                    NextMWRITE       = 1'b0;
                    NextPrevPriority = 1'b0;
                    DisAckMas        = 1'b1;
                  end
                else if (ReqForAhbBus == 1'b1)
                  begin
                    if (UseBuffVal == 1'b0)
                      begin
                        NextBeatCount    = StrtBurstInfo[7:3];
                        NextReqCount     = ChBeatCount;
                        NextAhbAddr      = ChAddr;
                        NextMSIZE        = ChHSIZE;
                        NextMPROT        = ChHPROT;
                        NextMLOCK        = ChHLOCK;
                        NextMBURST       = StrtBurstInfo[2:0];
                        NextMWRITE       = ChWRITE;
                        NextPrevPriority = ChPriority;
                        if (ChDisable == 1'b1)
                          DisAckMas        = 1'b1;
                        else
                          DisAckMas        = 1'b0;
                      end
                    else
                      begin
                        NextBeatCount    = StrtBurstInfoR[7:3];
                        NextReqCount     = ReqCountR;
                        NextAhbAddr      = AhbAddrR;
                        NextMSIZE        = MSIZER;
                        NextMPROT        = MPROTR;
                        NextMLOCK        = MLOCKR;
                        NextMBURST       = StrtBurstInfoR[2:0];
                        NextMWRITE       = MWRITER;
                        NextPrevPriority = ChPriorityR;
                        if (ChDisableR == 1'b1)
                          DisAckMas        = 1'b1;
                        else
                          DisAckMas        = 1'b0;
                      end
                  end
                else
                  begin
                    NextBeatCount    = ('d0);
                    NextReqCount     = ('d0);
                    NextAhbAddr      = ('d0);
                    NextMSIZE        = ('d0);
                    NextMPROT        = ('d0);
                    NextMLOCK        = 1'b0;
                    NextMBURST       = ('d0);
                    NextMWRITE       = 1'b0;
                    NextPrevPriority = 1'b0;
                    if (ChDisable == 1'b1)
                      DisAckMas        = 1'b1;
                    else
                      DisAckMas        = 1'b0;
                  end
              end
            else if (ReqCount > 5'b00001)
              begin
                if ((iMTRANS == `SEQ) || (iMTRANS == `NSEQ))
                  begin
                    if (ChAddrIncr == 1'b1)
                      NextAhbAddr      = Incr32(AhbAddr, iMSIZE);
                    NextReqCount     = (ReqCount) - 1'b1;
                    if (BeatCount == 5'b00001)
                      begin
                        NextBeatCount    = MidBurstInfo[7:3];
                        NextMBURST       = MidBurstInfo[2:0];
                      end
                    else
                      NextBeatCount    = (BeatCount) - 1'b1;
                  end
                else if (iMTRANS == `IDLE)
                  begin
                     NextBeatCount    = MidBurstInfo[7:3];
                     NextMBURST       = MidBurstInfo[2:0];
                  end
              end
            else if (ReqForAhbBus == 1'b1)
              begin
                if ((UseBuffVal == 1'b0) && (iStopArb == 1'b0))
                  begin
                    NextBeatCount    = StrtBurstInfo[7:3];
                    NextReqCount     = ChBeatCount;
                    NextAhbAddr      = ChAddr;
                    NextMSIZE        = ChHSIZE;
                    NextMPROT        = ChHPROT;
                    NextMLOCK        = ChHLOCK;
                    NextMBURST       = StrtBurstInfo[2:0];
                    NextMWRITE       = ChWRITE;
                    NextPrevPriority = ChPriority;
                    if (ChDisable == 1'b1)
                      DisAckMas        = 1'b1;
                    else
                      DisAckMas        = 1'b0;
                  end
                else if (UseBuffVal == 1'b1)
                  begin
                    NextBeatCount    = StrtBurstInfoR[7:3];
                    NextReqCount     = ReqCountR;
                    NextAhbAddr      = AhbAddrR;
                    NextMSIZE        = MSIZER;
                    NextMPROT        = MPROTR;
                    NextMLOCK        = MLOCKR;
                    NextMBURST       = StrtBurstInfoR[2:0];
                    NextMWRITE       = MWRITER;
                    NextPrevPriority = ChPriorityR;
                    if (ChDisableR == 1'b1)
                      DisAckMas        = 1'b1;
                    else
                      DisAckMas        = 1'b0;
                  end
                else
                  begin
                    NextBeatCount    = ('d0);
                    NextReqCount     = ('d0);
                    NextAhbAddr      = ('d0);
                    NextMSIZE        = ('d0);
                    NextMPROT        = ('d0);
                    NextMLOCK        = 1'b0;
                    NextMBURST       = ('d0);
                    NextMWRITE       = 1'b0;
                    NextPrevPriority = 1'b0;
                    if (ChDisable == 1'b1)
                      DisAckMas        = 1'b1;
                    else
                      DisAckMas        = 1'b0;
                  end
              end
            else
              begin
                NextBeatCount    = ('d0);
                NextReqCount     = ('d0);
                NextAhbAddr      = ('d0);
                NextMSIZE        = ('d0);
                NextMPROT        = ('d0);
                NextMLOCK        = 1'b0;
                NextMBURST       = ('d0);
                NextMWRITE       = 1'b0;
                NextPrevPriority = 1'b0;
                if (ChDisable == 1'b1)
                  DisAckMas        = 1'b1;
                else
                  DisAckMas        = 1'b0;
              end
            case (iMTRANS)
              `NSEQ, `SEQ :
                NextMasterState  = `ST_AHBM_ACTIVE;
    
              `IDLE :
                if (ReqForAhbBus ==1'b1)
                  NextMasterState  = `ST_AHBM_ADDRXFR;
                else
                  NextMasterState  = `ST_AHBM_INIT;
    
              default :
                NextMasterState = MasterState;
            endcase
          end
      end

    default :
      NextMasterState  = MasterState;
  endcase
end // p_LiteSMComb

// -----------------------------------------------------------------------------
// Width Factor generation, which uses channel HSIZE information
// -----------------------------------------------------------------------------
assign WidthFactor      = (ChHSIZE == `BYTE) ? 3'b001 :
                          ((ChHSIZE == `HWORD) ? 3'b010 : 3'b100);

// -----------------------------------------------------------------------------
// Width Factor generation, which uses Buffered HSIZE information
// -----------------------------------------------------------------------------
assign WidthFactorR     = (MSIZER == `BYTE) ? 3'b001 :
                          ((MSIZER == `HWORD) ? 3'b010 : 3'b100);

// -----------------------------------------------------------------------------
// Output of OneKbChk function is assigned here, which will be used at the
// starting of the access.
// -----------------------------------------------------------------------------
assign StrtBurstInfo    = OneKbChk(ChAddr[9:0], WidthFactor, ChBeatCount,
                                   ChAddrIncr);

// -----------------------------------------------------------------------------
// Output of OneKbChk function is assigned here, which will be used at the
// starting of the access, if Mready was not sampled asserted when StopArb
// went low.
// -----------------------------------------------------------------------------
assign StrtBurstInfoR   = OneKbChk(AhbAddrR[9:0], WidthFactorR, ReqCountR,
                                   ChAddrIncrR);

// -----------------------------------------------------------------------------
// Output of OneKbChk function is assigned here, which will be used at the
// middle of the access. when the BeatCount expires but Reqcount has some count.
// -----------------------------------------------------------------------------
assign MidBurstInfo     = OneKbChk(NextAhbAddr[9:0], WidthFactor, NextReqCount,
                                   ChAddrIncr);

// -----------------------------------------------------------------------------
// Logic to generate DataValid signal. This signal is generated combinationally.
// -----------------------------------------------------------------------------
always @(MasterState or DelMTRANS or MREADY or iMTRANS)
begin : p_DataValidComb
  if ((MasterState == `ST_AHBM_ADDRXFR) || (MasterState == `ST_AHBM_ACTIVE))
    begin
      if (DelMTRANS == `IDLE)
        begin
          if (iMTRANS == `IDLE)
             DataValid        = MREADY;
          else
             DataValid        = 1'b0;
        end
      else if (MREADY == 1'b0)
        DataValid        = 1'b0;
      else
        DataValid        = 1'b1;
    end
  else
    DataValid        = 1'b0;
end // p_DataValidComb


// -----------------------------------------------------------------------------
// Logic to generate StopArb signal. This signal is registered
// -----------------------------------------------------------------------------
always @(MREADY or MERROR or iStopArb or ChBeatCount or ChPriority or
         MasterState or ChDisable or iMBURST or BeatCount or ReqCount or
         ReqCountR or PrevPriority or iMTRANS or UseBuffVal or ChPriorityR)
begin : p_StopArbComb
  NextStopArb      = iStopArb;
  if ((MERROR == 1'b1) && (MREADY == 1'b0))
    NextStopArb      = 1'b1;
  else if ((MERROR == 1'b1) && (MREADY == 1'b1))
    NextStopArb      = 1'b0;
  else if (iStopArb == 1'b0)
    begin
      if (ChBeatCount != 5'b00000)
        begin
          if ((ChPriority == 1'b0) && (MasterState == `ST_AHBM_INIT))
            NextStopArb      = 1'b1;
          else if ((ChBeatCount == 5'b00001) && (MREADY == 1'b1))
            NextStopArb      = 1'b0;
          else
            NextStopArb      = 1'b1;
        end
      else
        NextStopArb      = 1'b0;
    end
  else
    begin
      if ((ChDisable == 1'b1) && ((iMBURST == `UINCR) ||
                                (BeatCount == 5'b00010)) && (MREADY == 1'b1))
        NextStopArb      = 1'b0;
      else if (((ReqCount == 5'b00001) && (ReqCountR <= 5'b00001)) &&
               ((PrevPriority == 1'b0) || ((ChPriorityR == 1'b0) &&
                (UseBuffVal == 1'b1))) && (MREADY == 1'b1) &&
                ((iMTRANS == `SEQ) || (iMTRANS == `NSEQ)))
        NextStopArb      = 1'b0;
      else if (((ReqCount <= 5'b00010) && (ReqCountR <= 5'b00001)) &&
                (MREADY == 1'b1) && ((PrevPriority == 1'b1) ||
                               ((ChPriorityR == 1'b1) && (UseBuffVal == 1'b1))))
        NextStopArb      = 1'b0;
    end
end // p_StopArbComb

reg  [1:0] Concat;
// -----------------------------------------------------------------------------
// Buffer the Channel resources in case of MREADY not asserted but StopArb is
// low
// -----------------------------------------------------------------------------
always @(iStopArb or MREADY or UseBuffVal or ReqCountR or AhbAddrR or MSIZER or
         MPROTR or MLOCKR or MWRITER or ChPriorityR or ChDisableR or
         ChAddrIncr or ChAddrIncrR or ChBeatCount or ChAddr or ChHSIZE or
         ChHPROT or ChHLOCK or ChWRITE or ChPriority or ChDisable)
begin : p_BuffChannelComb
  Concat = {iStopArb, MREADY};
  NextUseBuffVal   = UseBuffVal;
  NextReqCountR    = ReqCountR;
  NextAhbAddrR     = AhbAddrR;
  NextMSIZER       = MSIZER;
  NextMPROTR       = MPROTR;
  NextMLOCKR       = MLOCKR;
  NextMWRITER      = MWRITER;
  NextChPriorityR  = ChPriorityR;
  NextChDisableR   = ChDisableR;
  NextChAddrIncrR  = ChAddrIncrR;
  case (Concat)
    2'b00 :
      begin
        if (ChBeatCount != 5'b00000)
          begin
            NextUseBuffVal   = 1'b1;
            NextReqCountR    = ChBeatCount;
            NextAhbAddrR     = ChAddr;
            NextMSIZER       = ChHSIZE;
            NextMPROTR       = ChHPROT;
            NextMLOCKR       = ChHLOCK;
            NextMWRITER      = ChWRITE;
            NextChPriorityR  = ChPriority;
            NextChDisableR   = ChDisable;
            NextChAddrIncrR  = ChAddrIncr;
          end
      end

    2'b01, 2'b11 :
      begin
        NextUseBuffVal   = 1'b0;
        NextReqCountR    = ('d0);
        NextAhbAddrR     = ('d0);
        NextMSIZER       = ('d0);
        NextMPROTR       = ('d0);
        NextMLOCKR       = 1'b0;
        NextMWRITER      = 1'b0;
        NextChPriorityR  = 1'b0;
        NextChDisableR   = 1'b0;
        NextChAddrIncrR  = 1'b0;
      end
    default :
      begin
        NextUseBuffVal   = UseBuffVal;
        NextReqCountR    = ReqCountR;
        NextAhbAddrR     = AhbAddrR;
        NextMSIZER       = MSIZER;
        NextMPROTR       = MPROTR;
        NextMLOCKR       = MLOCKR;
        NextMWRITER      = MWRITER;
        NextChPriorityR  = ChPriorityR;
        NextChDisableR   = ChDisableR;
        NextChAddrIncrR  = ChAddrIncrR;
      end
  endcase
end // p_BuffChannelComb

// -----------------------------------------------------------------------------
// All D-Input logic are registered here
// -----------------------------------------------------------------------------
always @(negedge HRESETn or posedge HCLK)
begin : p_LiteSMSeq
  if (HRESETn == 1'b0)
    begin
      BeatCount        <= ('d0);
      ReqCount         <= ('d0);
      AhbAddr          <= ('d0);
      iMTRANS          <= ('d0);
      iMSIZE           <= ('d0);
      iMPROT           <= ('d0);
      iMLOCK           <= 1'b0;
      iMBURST          <= ('d0);
      iMWRITE          <= 1'b0;
      PrevPriority     <= 1'b0;
      MasterState      <= `ST_AHBM_INIT;
      UseBuffVal       <= 1'b0;
      ReqCountR        <= ('d0);
      AhbAddrR         <= ('d0);
      MSIZER           <= ('d0);
      MPROTR           <= ('d0);
      MLOCKR           <= 1'b0;
      MWRITER          <= 1'b0;
      ChPriorityR      <= 1'b0;
      ChDisableR       <= 1'b0;
      iStopArb         <= 1'b0;
      ChAddrIncrR      <= 1'b0;
    end
  else
    begin
      BeatCount        <= NextBeatCount;
      ReqCount         <= NextReqCount;
      AhbAddr          <= NextAhbAddr;
      iMTRANS          <= NextMTRANS;
      iMSIZE           <= NextMSIZE;
      iMPROT           <= NextMPROT;
      iMLOCK           <= NextMLOCK;
      iMBURST          <= NextMBURST;
      iMWRITE          <= NextMWRITE;
      PrevPriority     <= NextPrevPriority;
      MasterState      <= NextMasterState;
      DelMTRANS        <= iMTRANS;
      UseBuffVal       <= NextUseBuffVal;
      ReqCountR        <= NextReqCountR;
      AhbAddrR         <= NextAhbAddrR;
      MSIZER           <= NextMSIZER;
      MPROTR           <= NextMPROTR;
      MLOCKR           <= NextMLOCKR;
      MWRITER          <= NextMWRITER;
      ChPriorityR      <= NextChPriorityR;
      ChDisableR       <= NextChDisableR;
      iStopArb         <= NextStopArb;
      ChAddrIncrR      <= NextChAddrIncrR;
    end
end // p_LiteSMSeq

endmodule
// --================================== End ==================================--
