//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//------------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : Ahb2Lite.v,v
//  File Revision       : 1.4
//
//  Release Information : ADK_REL1v1
//
//------------------------------------------------------------------------------
//  Purpose             : This is the AHB to AHB-Lite Unidirectional Bridge Core
//                      : It provides fully registered connectivity between AHB
//                      : domains.
//============================================================================--

`timescale 1ns/1ps

module Ahb2Lite
  (
   HCLK,
   HRESETn,

   HSEL,
   HADDR,
   HTRANS,
   HWRITE,
   HSIZE,
   HBURST,
   HPROT,
   HMASTLOCK,
   HWDATA,
   HREADY,
   HRDATA,
   HREADYOUT,
   HRESP,

   MRDATA,
   MREADY,
   MERROR,
   MADDR,
   MTRANS,
   MWRITE,
   MSIZE,
   MBURST,
   MPROT,
   MMASTLOCK,
   MWDATA
   );

//----------------------------------------------------------------------------
// AHB ports
//----------------------------------------------------------------------------

  // Global signals
  input         HCLK;
  input         HRESETn;

  // Slave Interface signals
  input         HSEL;
  input [31:0]  HADDR;
  input [1:0]   HTRANS;
  input         HWRITE;
  input [2:0]   HSIZE;
  input [2:0]   HBURST;
  input [3:0]   HPROT;
  input         HMASTLOCK;
  input [31:0]  HWDATA;
  input         HREADY;

  output [31:0] HRDATA;
  output        HREADYOUT;
  output [1:0]  HRESP;

//----------------------------------------------------------------------------
// AHB-Lite ports
//----------------------------------------------------------------------------

  // AHB-Lite Master Interface signals
  input [31:0]  MRDATA;
  input         MREADY;
  input         MERROR;

  output [31:0] MADDR;
  output [1:0]  MTRANS;
  output        MWRITE;
  output [2:0]  MSIZE;
  output [2:0]  MBURST;
  output [3:0]  MPROT;
  output        MMASTLOCK;
  output [31:0] MWDATA;

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

  // HRESP transfer response signal encoding.
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

  // Bridge control states for READ transfer
  `define ST_READ_IDLE        3'b000
  `define ST_READ_HOLD        3'b001
  `define ST_READ_INSERT_BUSY 3'b100
  `define ST_READ_TRANSFER    3'b010
  `define ST_READ_MASTER_BUSY 3'b011
  `define ST_READ_ERROR1      3'b110
  `define ST_READ_ERROR2      3'b111

  // Bridge control states for WRITE transfer
  `define ST_WRITE_IDLE         3'b000
  `define ST_WRITE_HOLD         3'b001
  `define ST_WRITE_INSERT_BUSY1 3'b010
  `define ST_WRITE_INSERT_BUSY2 3'b011
  `define ST_WRITE_ERROR1       3'b100
  `define ST_WRITE_ERROR2       3'b101

  // Bridge control states for BUFFERED WRITE transfer
  `define ST_BWRITE_IDLE     2'b00
  `define ST_BWRITE_TRANSFER 2'b01
  `define ST_BWRITE_HOLD     2'b10
  `define ST_BWRITE_FLUSH    2'b11

  // Transfer types
  `define TT_IDLE   2'b00
  `define TT_READ   2'b01
  `define TT_WRITE  2'b10
  `define TT_BWRITE 2'b11

//----------------------------------------------------------------------------
// Signal declarations
//----------------------------------------------------------------------------

// Input/Output Signals
  wire          HCLK;
  wire          HRESETn;

  wire          HSEL;
  wire [31:0]   HADDR;
  wire [1:0]    HTRANS;
  wire          HWRITE;
  wire [2:0]    HSIZE;
  wire [2:0]    HBURST;
  wire [3:0]    HPROT;
  wire          HMASTLOCK;
  wire [31:0]   HWDATA;
  wire          HREADY;
  reg  [31:0]   HRDATA;
  wire          HREADYOUT;
  reg  [1:0]    HRESP;

  wire [31:0]   MRDATA;
  wire          MREADY;
  wire          MERROR;
  wire [31:0]   MADDR;
  wire [1:0]    MTRANS;
  wire          MWRITE;
  wire [2:0]    MSIZE;
  wire [2:0]    MBURST;
  wire [3:0]    MPROT;
  wire          MMASTLOCK;
  wire [31:0]   MWDATA;

//----------------------------------------------------------------------------
// Combinatorial Versions of Output Signals
//----------------------------------------------------------------------------

  wire [31:0]   NextMaddr;
  wire [1:0]    NextMtrans;
  reg           NextMwrite;
  reg  [2:0]    NextMsize;
  reg  [2:0]    NextMburst;
  reg  [3:0]    NextMprot;
  wire [31:0]   NextMwdata;
  reg           NextMmastlock;
  wire [31:0]   NextHrdata;
  wire [1:0]    NextHresp;
  wire          NextHreadyout;

//----------------------------------------------------------------------------
// Internal versions of outputs
//----------------------------------------------------------------------------

  reg  [31:0]   iMADDR;
  reg  [1:0]    iMTRANS;
  reg           iMWRITE;
  reg  [2:0]    iMSIZE;
  reg  [2:0]    iMBURST;
  reg  [3:0]    iMPROT;
  reg           iMMASTLOCK;
  reg  [31:0]   iMWDATA;
  reg           iHREADYOUT;

//----------------------------------------------------------------------------
// Holding registers for buffered writes
//----------------------------------------------------------------------------

  reg  [31:0]   HoldHaddr;
  reg  [1:0]    HoldHtrans;
  reg           HoldHwrite;
  reg  [2:0]    HoldHsize;
  reg  [2:0]    HoldHburst;
  reg  [3:0]    HoldHprot;
  reg  [31:0]   HoldHwdata;
  reg           HoldHmastlock;

//----------------------------------------------------------------------------
// Holding register signals for buffered writes
//----------------------------------------------------------------------------

  reg           HoldSel;
  wire          NextHoldSel;
  reg           WdataHoldSel;
  wire          NextWdataHoldSel;

//----------------------------------------------------------------------------
// Control Flags
//----------------------------------------------------------------------------

  reg  [1:0]    TransferType;
  wire          ChangeEnable;
  wire          Valid;
  reg           ValidReg;
  wire          NewAC;
  wire          NewData;

//----------------------------------------------------------------------------
// HTRANS override flags
//----------------------------------------------------------------------------

  wire          BusyOverride;
  wire          IdleOverride;

//----------------------------------------------------------------------------
// Address Generation Signals
//----------------------------------------------------------------------------

  reg  [5:0]    WrapMask;
  reg  [2:0]    AddValue;
  reg  [31:0]   CalcAddr;
  wire          Wrapped;
  reg  [3:0]    OffsetAddr;
  reg  [3:0]    CheckAddr;
  reg  [3:0]    NextBurstBeats;
  reg  [3:0]    BurstBeats;
  wire          AddrGen;

//----------------------------------------------------------------------------
// State Machine Signals
//----------------------------------------------------------------------------

  reg  [2:0]    NextReadState;
  reg  [2:0]    ReadState;
  reg  [2:0]    NextWriteState;
  reg  [2:0]    WriteState;
  reg  [1:0]    NextBWriteState;
  reg  [1:0]    BWriteState;

//----------------------------------------------------------------------------
// Beginning of main code
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// Bridge Slave Interface Logic
//----------------------------------------------------------------------------

  // The TransferType signal indicates what type of transfer is on the slave
  // interface. Note that this is IDLE for transfers not directed to the bridge.
  // TransferType is used to drive the main burst state machines.

  always @ (HPROT or HSEL or HTRANS or HWRITE or iHREADYOUT or HREADY)
    begin : p_TransferTypeComb
      if (HTRANS == `TRN_IDLE ||                                 // Idle on AHB1
          !HSEL ||                                        // Bridge not selected
          (iHREADYOUT && !HREADY))                // HREADY low by another slave
        TransferType = `TT_IDLE;
      else
        if (!HWRITE)
          TransferType = `TT_READ;
        else
          if (HPROT[2])                                   // Bufferable transfer
            TransferType = `TT_BWRITE;
          else
            TransferType = `TT_WRITE;
    end // block: p_TransferTypeComb

  // Valid bridge transfers only take place when a non-sequential or sequential
  // transfer is shown on the slave interface and HSEL is high.

  assign Valid = ((HTRANS == `TRN_NONSEQ || HTRANS == `TRN_SEQ)
                  && HSEL) ? 1'b1

                 : 1'b0;

  // ValidReg indicates the data phase of a valid transfer.

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_ValidRegSeq
      if (!HRESETn)
        ValidReg <= 1'b0;
      else
        if (HREADY)
          ValidReg <= Valid;
    end // block: p_ValidRegSeq

  // NewAC indicates when a new transfer address and control is presented to the
  // bridge slave interface

  assign NewAC = (HREADY && Valid) ? 1'b1

                 : 1'b0;

  // NewData is high when new data is presented to the bridge slave interface

  assign NewData = (HREADY && ValidReg) ? 1'b1

                   : 1'b0;

//----------------------------------------------------------------------------
// Bridge State Machines
//----------------------------------------------------------------------------
// Read Burst Control FSM
//----------------------------------------------------------------------------

  always @ (BWriteState or HTRANS or MREADY or ReadState or TransferType or
            WriteState or MERROR)
  begin : p_ReadFSMComb

    case (ReadState)

      `ST_READ_IDLE :
      // no read transfer on AHB1 or waiting for write transfer to complete
      begin
        if (TransferType == `TT_READ &&                 // a bridge read on AHB1
            BWriteState != `ST_BWRITE_HOLD &&     // not in bwrite holding state
            (WriteState == `ST_WRITE_IDLE ||                // write fsm is idle
             WriteState == `ST_WRITE_INSERT_BUSY2 || // data phase of write xfer
             WriteState == `ST_WRITE_ERROR2))  // second cycle of ERROR response
          NextReadState = `ST_READ_HOLD;
        else
          NextReadState = `ST_READ_IDLE;
      end // case: `ST_READ_IDLE

      `ST_READ_HOLD :
      // valid read transfer on AHB1, master held with HREADY low
      begin
        if (MREADY &&                             // previous transfer completed
            BWriteState != `ST_BWRITE_FLUSH)    // holding registers are flushed
          NextReadState = `ST_READ_INSERT_BUSY;
        else
          NextReadState = `ST_READ_HOLD;
      end

      `ST_READ_INSERT_BUSY :
      // BUSY transfer inserted whilst data is registered back across the bridge
      begin
        if (MERROR)
          NextReadState = `ST_READ_ERROR1;
        else
          begin
            if (!MREADY)                              // read data not yet ready
              NextReadState = `ST_READ_INSERT_BUSY;
            else
              begin
                if (TransferType != `TT_READ)          // no more read transfers
                  NextReadState = `ST_READ_IDLE;
                else
                  begin
                    if (HTRANS == `TRN_BUSY) // master drives BUSY read transfer
                      NextReadState = `ST_READ_MASTER_BUSY;
                    else                          // another valid read transfer
                      NextReadState = `ST_READ_TRANSFER;
                  end // else: if(TransferType = `TT_READ)
              end // else: if(MREADY)
          end // else: !if(MERROR)
      end

      `ST_READ_ERROR1 :
      // 1st cycle of ERROR response
        NextReadState = `ST_READ_ERROR2;

      `ST_READ_ERROR2 :
      // 2nd cycle of ERROR response
      begin
        if (TransferType != `TT_READ)                           // burst aborted
          NextReadState = `ST_READ_IDLE;
        else
          begin
            if (HTRANS == `TRN_BUSY)                  // next transfer is a BUSY
              NextReadState = `ST_READ_MASTER_BUSY;
            else                                  // another valid read transfer
              NextReadState = `ST_READ_HOLD;
          end
      end

      `ST_READ_TRANSFER :
      // the next read transfer is registered across the bridge
      // as the previous transfer on AHB2 was BUSY, MREADY must be high so the
      // next state is always INSERT_BUSY
      begin
        NextReadState = `ST_READ_INSERT_BUSY;
      end

      `ST_READ_MASTER_BUSY :
      // master driving BUSY read transfer
      begin
        if (HTRANS == `TRN_BUSY)               // stay in this state whilst BUSY
          NextReadState = `ST_READ_MASTER_BUSY;
        else
          if (TransferType != `TT_READ)                // no more read transfers
            NextReadState = `ST_READ_IDLE;
          else                                    // another valid read transfer
            NextReadState = `ST_READ_HOLD;
      end

      default : NextReadState = `ST_READ_IDLE;       // illegal state transition

    endcase // case(ReadState)

  end // block: p_ReadFSMComb


//----------------------------------------------------------------------------
// Write Burst Control FSM
//----------------------------------------------------------------------------
  always @ (BWriteState or HTRANS or MREADY or ReadState or TransferType or
            WriteState or MERROR)
  begin : p_UnbufferedWriteFSMComb

    case (WriteState)

      `ST_WRITE_IDLE :
      // no write transfer on AHB1 or waiting for other transfer to complete
      begin
        if (TransferType == `TT_WRITE &&              // a bridge write on AHB1
            BWriteState != `ST_BWRITE_HOLD &&        // no held bwrite transfer
            (ReadState == `ST_READ_IDLE ||          // no read xfer to complete
             ReadState == `ST_READ_MASTER_BUSY ||    // last xfer was BUSY read
             ReadState == `ST_READ_ERROR2))   // second cycle of ERROR response
          NextWriteState = `ST_WRITE_HOLD;
        else
          NextWriteState = `ST_WRITE_IDLE;
      end

      `ST_WRITE_HOLD :
      // valid write transfer on AHB1, master held with HREADY low
      begin
        if (MREADY &&                         // previous transfer completed and
            BWriteState != `ST_BWRITE_FLUSH)    // holding registers are flushed
          NextWriteState = `ST_WRITE_INSERT_BUSY1;
        else
          NextWriteState = `ST_WRITE_HOLD;
      end

      `ST_WRITE_INSERT_BUSY1 :
      // first inserted BUSY whilst the address and control is registered
      // across the bridge, HREADY is still low in this state
      begin
        if (MERROR)                  // in the second cycle of an ERROR response
          NextWriteState = `ST_WRITE_ERROR1;
        else
          begin
            if (!MREADY)                // previous transfer waiting to complete
              NextWriteState = `ST_WRITE_INSERT_BUSY1;
            else                                   // previous transfer complete
              NextWriteState = `ST_WRITE_INSERT_BUSY2;
          end
      end

      `ST_WRITE_INSERT_BUSY2 :
      // second inserted BUSY whilst the slave response is registered back
      // across the bridge, HREADY goes high
      begin
        if (HTRANS == `TRN_BUSY)           // master BUSY, so stay in this state
          NextWriteState = `ST_WRITE_INSERT_BUSY2;
        else
          if (TransferType != `TT_WRITE)              // no more write transfers
            NextWriteState = `ST_WRITE_IDLE;
          else                                         // another write transfer
            NextWriteState = `ST_WRITE_HOLD;
      end

      `ST_WRITE_ERROR1 :
      // 1st cycle of ERROR response on AHB1
        NextWriteState = `ST_WRITE_ERROR2;

      `ST_WRITE_ERROR2 :
      // 2nd cycle of ERROR response on AHB1
      begin
        if (TransferType != `TT_WRITE)                          // burst aborted
          NextWriteState = `ST_WRITE_IDLE;
        else
          begin
            if (HTRANS == `TRN_BUSY)                       // master drives BUSY
              NextWriteState = `ST_WRITE_INSERT_BUSY2;
            else                                          // next write transfer
              NextWriteState = `ST_WRITE_HOLD;
          end
      end

      default: NextWriteState = `ST_WRITE_IDLE;      // illegal state transition

    endcase // case(WriteState)

  end // block: p_UnbufferedWriteFSMComb


//---------------------------------------------------------------------------
// Buffered Write Burst Control FSM
//---------------------------------------------------------------------------
  always @ (BWriteState or ChangeEnable or MREADY or ReadState or
            TransferType or HTRANS or WriteState or iMTRANS)
  begin : p_BufferedWriteFSMComb

    case (BWriteState)

      `ST_BWRITE_IDLE :
      // no buffered write transfer on AHB1
      // or waiting for other transfer to complete
      begin
        if (TransferType == `TT_BWRITE &&     // a bridge buffered write on AHB1
            (WriteState == `ST_WRITE_IDLE ||    // no write transfer to complete
             WriteState == `ST_WRITE_INSERT_BUSY2 ||  //data phase of write xfer
             WriteState == `ST_WRITE_ERROR2) && // second cycle of an error resp
            (ReadState == `ST_READ_IDLE ||       // no read transfer to complete
             ReadState == `ST_READ_MASTER_BUSY ||     // last xfer was BUSY read
             ReadState == `ST_READ_ERROR2))     // second cycle of an error resp
          NextBWriteState = `ST_BWRITE_TRANSFER;
        else
          NextBWriteState = `ST_BWRITE_IDLE;
      end

      `ST_BWRITE_TRANSFER :
      // transfer registered across bridge, not waiting for response, so master
      // is not held
      begin
        if (TransferType == `TT_BWRITE &&     // another buffered write transfer
            HTRANS[1] &&                          // not a BUSY transfer on AHB1
            iMTRANS[1] &&                              // valid transfer on AHB2
            !MREADY)                           // AHB2 transfer not yet complete
          NextBWriteState = `ST_BWRITE_HOLD;
        else
          if (TransferType != `TT_BWRITE)             // no more buffered writes
            begin
              if (ChangeEnable)             // address on AHB2 allowed to change
                NextBWriteState = `ST_BWRITE_IDLE;
              else                          // read or write transfer waiting in
                NextBWriteState = `ST_BWRITE_FLUSH;          // holding register
            end
          else                      // next buffered write transfer can complete
            NextBWriteState = `ST_BWRITE_TRANSFER;
      end

      `ST_BWRITE_HOLD :
      // in this state, AHB2 cannot keep up with AHB1, so the master is held and
      // holding registers used to drive transfer on AHB2
      begin
        if (!MREADY)                         // holding transfer waiting be used
          NextBWriteState = `ST_BWRITE_HOLD;
        else
          if (TransferType == `TT_BWRITE)        // holding transfer can be used
            NextBWriteState = `ST_BWRITE_TRANSFER;
          else
            NextBWriteState = `ST_BWRITE_FLUSH;
      end

      `ST_BWRITE_FLUSH :
      // in the flush state, the holding registers have been used and the
      // transfer is waiting to complete
      begin
        if (TransferType == `TT_BWRITE &&                 // new bwrite transfer
            ReadState == `ST_READ_IDLE &&            // no pending read transfer
            WriteState == `ST_WRITE_IDLE)           // no pending write transfer
          begin
            if (!MREADY && HTRANS[1])                  // waited bwrite transfer
              NextBWriteState = `ST_BWRITE_HOLD;
            else                            // next bwrite transfer can complete
              NextBWriteState = `ST_BWRITE_TRANSFER;
          end
        else
          if (ChangeEnable)                    // next transfer can go onto AHB2
            NextBWriteState = `ST_BWRITE_IDLE;
          else                       // waiting for holding transfer to complete
            NextBWriteState = `ST_BWRITE_FLUSH;
      end

      default: NextBWriteState = `ST_BWRITE_IDLE;    // illegal state transition

    endcase // case(BWriteState)

  end // block: p_BufferedWriteFSMComb

  // State machine registers
  always @ (posedge HCLK or negedge HRESETn)
    begin : p_MasterControlSeq
      if (!HRESETn)
        begin
          ReadState   <= `ST_READ_IDLE;
          WriteState  <= `ST_WRITE_IDLE;
          BWriteState <= `ST_BWRITE_IDLE;
        end
      else
        begin
          ReadState   <= NextReadState;
          WriteState  <= NextWriteState;
          BWriteState <= NextBWriteState;
        end

    end // block: p_MasterControlSeq


//----------------------------------------------------------------------------
// State decodes
//----------------------------------------------------------------------------
// Signals which rely on the current or next state.

  // HTRANS is over-ridden with IDLE when:
  // (a) the burst state machines are all idle.
  // (b) in a busy insert state of a read or write burst and there are no
  //     more transfers in the burst.
  // (c) in the first inserted busy state of a write transfer and a new transfer
  //     appears on AHB1 - i.e. address and control will change in the next
  //     cycle.
  // (d) during the inserted busy state of a new burst and a new transfer
  //     appears on AHB1.

  assign IdleOverride = ((NextReadState == `ST_READ_IDLE &&               // (a)
                          NextWriteState == `ST_WRITE_IDLE &&
                          NextBWriteState == `ST_BWRITE_IDLE) ||

                         ((NextReadState == `ST_READ_INSERT_BUSY ||       // (b)
                           NextReadState == `ST_READ_ERROR1 ||
                           NextReadState == `ST_READ_ERROR2 ||
                           NextWriteState == `ST_WRITE_INSERT_BUSY1 ||
                           NextWriteState == `ST_WRITE_INSERT_BUSY2 ||
                           NextWriteState == `ST_WRITE_ERROR1 ||
                           NextWriteState == `ST_WRITE_ERROR2) &&
                          (NextBurstBeats == 4'b0 ||
                           TransferType == `TT_IDLE)) ||

                         (NextWriteState == `ST_WRITE_INSERT_BUSY1 &&     // (c)
                          HTRANS == `TRN_NONSEQ) ||

                         (ReadState == `ST_READ_HOLD &&                   // (d)
                          NextReadState == `ST_READ_INSERT_BUSY &&
                          HTRANS == `TRN_NONSEQ)) ? 1'b1

                        : 1'b0;

  // HTRANS is over-ridden with BUSY when in the busy insert states of the read
  // or unbuffered write state machines

  assign BusyOverride = (NextReadState == `ST_READ_INSERT_BUSY ||
                         NextReadState == `ST_READ_ERROR1 ||
                         NextReadState == `ST_READ_ERROR2 ||

                         NextWriteState == `ST_WRITE_INSERT_BUSY1 ||
                         NextWriteState == `ST_WRITE_INSERT_BUSY2 ||
                         NextWriteState == `ST_WRITE_ERROR2) ? 1'b1

                        : 1'b0;

  // The address is generated only during a read transfer.

  assign AddrGen = (ReadState == `ST_READ_TRANSFER) ? 1'b1

                   : 1'b0;

  // The holding registers are selected when in a holding state of a buffered
  // write or in the flush state (waiting for the last transfer to complete) and
  // a read or unbuffered write occurs on the slave interface which cannot be
  // put onto AHB2.
  // Once the holding transfer has completed, the register is de-activated.

  assign NextHoldSel = (NextBWriteState == `ST_BWRITE_HOLD ||

                        (NextBWriteState == `ST_BWRITE_FLUSH &&
                         !ChangeEnable &&
                         (TransferType == `TT_READ ||
                          TransferType == `TT_WRITE))) ? 1'b1

                       : MREADY ? 1'b0

                       : HoldSel;


  // Write Data hold select is high when:
  // (a) in the buffered write holding state.
  // (b) in the buffered write flush state and the data is not permitted to
  //     change.
  // (c) when the master drives BUSY, as the data is not guaranteed to be stable
  //     during multiple BUSY transfers.

  assign NextWdataHoldSel = (NextBWriteState == `ST_BWRITE_HOLD ||        // (a)

                             (NextBWriteState == `ST_BWRITE_FLUSH &&      // (b)
                              !ChangeEnable) ||

                             (TransferType == `TT_BWRITE &&               // (c)
                              HTRANS == `TRN_BUSY &&
                              iHREADYOUT)) ? 1'b1

                            : 1'b0;

  // Registers for the state decoded signals
  always @ (posedge HCLK or negedge HRESETn)
    begin : p_HoldSelReg
      if (!HRESETn)
        begin
          HoldSel      <= 1'b0;
          WdataHoldSel <= 1'b0;
        end
      else
        begin
          HoldSel      <= NextHoldSel;
          WdataHoldSel <= NextWdataHoldSel;
        end
    end // block: p_HoldSelReg


//----------------------------------------------------------------------------
// Holding Registers
//----------------------------------------------------------------------------

  // The holding registers store valid bridge transfers
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HoldRegSeq
      if (!HRESETn)
        begin
          HoldHaddr     <= {32{1'b0}};
          HoldHtrans    <= `TRN_IDLE;
          HoldHwrite    <= 1'b0;
          HoldHsize     <= `SZ_BYTE;
          HoldHburst    <= `BUR_SINGLE;
          HoldHprot     <= 4'b0000;
          HoldHmastlock <= 1'b0;
        end
      else
        begin
          if (NewAC)
            begin
              HoldHaddr     <= HADDR;
              HoldHtrans    <= HTRANS;
              HoldHwrite    <= HWRITE;
              HoldHsize     <= HSIZE;
              HoldHburst    <= HBURST;
              HoldHprot     <= HPROT;
              HoldHmastlock <= HMASTLOCK;
            end
        end
    end // block: p_HoldRegSeq

  // Write data holding register stores valid bridge write data
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HoldHwdataSeq
      if (!HRESETn)
        HoldHwdata <= {32{1'b0}};
      else
        if (NewData)
          HoldHwdata <= HWDATA;
    end // block: p_HoldHwdataSeq

//----------------------------------------------------------------------------
// Track Fixed Length Bursts
//----------------------------------------------------------------------------
// Bursts are tracked with the BurstBeats counter. This is used to determine
// when to insert idle transfers instead of busys during a read or unbuffered
// write burst.
// NextBurstBeats is set at the beginning of a burst and is decremented for
// each SEQ transfer in the burst. For INCR bursts, BurstBeats stays at 1.
// For SINGLEs or IDLE transfers, BurstBeats is 0.

  always @ (BurstBeats or MREADY or iMBURST or iMTRANS)
    begin : p_BurstTrackComb
      case (iMTRANS)

        `TRN_IDLE : NextBurstBeats = 4'b0000;

        `TRN_BUSY : NextBurstBeats = BurstBeats;

        `TRN_NONSEQ :
          case (iMBURST)

            `BUR_SINGLE : NextBurstBeats = 4'b0000;
            `BUR_INCR   : NextBurstBeats = 4'b0001;
            `BUR_INCR4,
            `BUR_WRAP4  : NextBurstBeats = 4'b0011;
            `BUR_INCR8,
            `BUR_WRAP8  : NextBurstBeats = 4'b0111;
            `BUR_INCR16,
            `BUR_WRAP16 : NextBurstBeats = 4'b1111;
            default     : NextBurstBeats = 4'b0000;
          endcase // case(iMBURST)

        `TRN_SEQ :
          if ((iMBURST != `BUR_INCR) && MREADY)
            NextBurstBeats = (BurstBeats - 4'b0001);
          else
            NextBurstBeats = BurstBeats;

        default: NextBurstBeats = BurstBeats;

      endcase // case(iMTRANS)

    end

  always @ (posedge HCLK or negedge HRESETn)
    begin : p_BurstTrackSeq
      if (!HRESETn)
        BurstBeats <= 4'b0000;
      else
        BurstBeats <= NextBurstBeats;
    end // block: p_BurstTrackSeq

//----------------------------------------------------------------------------
// Control Flags
//----------------------------------------------------------------------------
// Indicates when the address and control signals are permitted to change,
// i.e. when MREADY is high or when the current transfer is IDLE or BUSY.
// Change is prohibited during back-to-back inserted BUSY transfers.

  assign ChangeEnable = (WriteState == `ST_WRITE_INSERT_BUSY1 ||
                         WriteState == `ST_WRITE_ERROR1 ||

                         ReadState == `ST_READ_ERROR1 ||
                         (ReadState == `ST_READ_INSERT_BUSY &&
                          NextReadState == `ST_READ_INSERT_BUSY)) ? 1'b0

                        : (MREADY ||
                           iMTRANS == `TRN_IDLE ||
                           iMTRANS == `TRN_BUSY) ? 1'b1

                        : 1'b0;

//----------------------------------------------------------------------------
// Address Generation
//----------------------------------------------------------------------------
// The next transfer address is generated for read bursts, saving one clock
// cycle per transaction.
// OffsetAddr indicates the address bits to be monitored when detecting a
// wrapping address. Depends upon the size of the transfer.

  always @ (iMADDR or iMSIZE)
    begin : p_OffsetAddrComb
      case (iMSIZE)
        `SZ_BYTE : OffsetAddr = iMADDR [3:0];
        `SZ_HALF : OffsetAddr = iMADDR [4:1];
        `SZ_WORD : OffsetAddr = iMADDR [5:2];
        default  : OffsetAddr = 4'b0000;
      endcase
    end // block: p_OffsetAddrComb

  // CheckAddr indicates when the address will wrap, depending on burst type
  always @ (OffsetAddr or iMBURST)
    begin : p_CheckAddrComb
      case (iMBURST)

        `BUR_WRAP4 : begin
          CheckAddr [1:0] = OffsetAddr [1:0];
          CheckAddr [3:2] = 2'b11;
        end

        `BUR_WRAP8 : begin
          CheckAddr [2:0] = OffsetAddr [2:0];
          CheckAddr [3] = 1'b1;
        end

        `BUR_WRAP16 :
          CheckAddr [3:0] = OffsetAddr [3:0];

        `BUR_SINGLE, `BUR_INCR, `BUR_INCR4, `BUR_INCR8, `BUR_INCR16 :
          CheckAddr [3:0] = 4'b0000;

        default:
          CheckAddr [3:0] = 4'b0000;

      endcase // case(iMBURST)

    end // block: p_CheckAddrComb



  // The address of the next transfer should wrap on the next transfer if the
  // boundary is reached.

  assign Wrapped = (CheckAddr == 4'b1111) ? 1'b1

                   : 1'b0;


  // AddValue is the value which should be added to the address for each
  // transfer, depending on the data size.
  always @ (iMSIZE)
    begin : p_AddValueComb
      case (iMSIZE)
        `SZ_BYTE : AddValue = 3'b001;
        `SZ_HALF : AddValue = 3'b010;
        `SZ_WORD : AddValue = 3'b100;
        default  : AddValue = 3'b000;
      endcase
    end // block: p_AddValueComb

  // WrapMask is applied to the address to make it wrap, when the Wrapped signal
  // is high.
  always @ (iMBURST or iMSIZE)
    begin : p_WrapMaskComb
      case (iMBURST)
        `BUR_WRAP4 :
          case (iMSIZE)
            `SZ_BYTE : WrapMask = 6'b111100;
            `SZ_HALF : WrapMask = 6'b111000;
            `SZ_WORD : WrapMask = 6'b110000;
            default  : WrapMask = 6'b000000;
          endcase

        `BUR_WRAP8 :
          case (iMSIZE)
            `SZ_BYTE : WrapMask = 6'b111000;
            `SZ_HALF : WrapMask = 6'b110000;
            `SZ_WORD : WrapMask = 6'b100000;
            default  : WrapMask = 6'b000000;
          endcase

        `BUR_WRAP16 :
          case (iMSIZE)
            `SZ_BYTE : WrapMask = 6'b110000;
            `SZ_HALF : WrapMask = 6'b100000;
            `SZ_WORD : WrapMask = 6'b000000;
            default  : WrapMask = 6'b000000;
          endcase

        `BUR_SINGLE ,`BUR_INCR ,`BUR_INCR4 ,`BUR_INCR8 ,`BUR_INCR16 :
          WrapMask = 6'b000000;

        default :
          WrapMask = 6'b000000;

      endcase // case(iMBURST)

    end // block: p_WrapMaskComb

  // Calculate new address value
  always @ (AddValue or MREADY or WrapMask or Wrapped or iMADDR or iMTRANS)
    begin : p_CalcAddrComb
      if (iMTRANS [1] && MREADY)                     // valid transfer completed
        begin
          if (Wrapped)                                // new address should wrap
            begin
              CalcAddr [31:6] = iMADDR [31:6];
              CalcAddr [5:0] = (iMADDR [5:0] & WrapMask);
            end
          else
            CalcAddr = (iMADDR + AddValue);
        end // if (iMTRANS [1] && MREADY)
      else                                          // address should not change
          CalcAddr = iMADDR;

    end // block: p_CalcAddrComb


//----------------------------------------------------------------------------
// Next Master Output Signals
//----------------------------------------------------------------------------
// MADDR is generated from either the holding registers, generated address or
// passed from HADDR.

  assign NextMaddr = !ChangeEnable ? iMADDR

                     : HoldSel ? HoldHaddr

                     : AddrGen ? CalcAddr

                     : HSEL ? HADDR

                     : iMADDR;

  // MTRANS is over-ridden with IDLE or BUSY in the appropriate read or
  // unbuffered write states or driven from the holding registers or passed from
  // HTRANS.

  assign NextMtrans = !ChangeEnable ? iMTRANS

                      : IdleOverride ? `TRN_IDLE

                      : BusyOverride ? `TRN_BUSY

                      : HoldSel ? HoldHtrans

                      : HSEL ? HTRANS

                      : `TRN_IDLE;


  // MWDATA is driven from the holding registers or passed from HWDATA.

  assign NextMwdata = !MREADY ? iMWDATA

                      : WdataHoldSel ? HoldHwdata

                      : ValidReg ? HWDATA

                      : iMWDATA;


  // Multiplexor for other control signals.
  always @ (ChangeEnable or HBURST or HMASTLOCK or HPROT or HSEL or HSIZE or
            HWRITE or HoldHburst or HoldHmastlock or HoldHprot or HoldHsize or
            HoldHwrite or HoldSel or iMBURST or iMMASTLOCK or iMPROT or
            iMSIZE or iMWRITE)
    begin : p_nextMComb
      if (!ChangeEnable)            // address & control not permitted to change
        begin
          NextMwrite    = iMWRITE;
          NextMsize     = iMSIZE;
          NextMburst    = iMBURST;
          NextMprot     = iMPROT;
          NextMmastlock = iMMASTLOCK;
        end
      else
        if (HoldSel)                                    // use holding registers
          begin
            NextMwrite    = HoldHwrite;
            NextMsize     = HoldHsize;
            NextMburst    = HoldHburst;
            NextMprot     = HoldHprot;
            NextMmastlock = HoldHmastlock;
          end
        else
          if (HSEL)                      // bridge selected, so use AHB1 signals
            begin
              NextMwrite    = HWRITE;
              NextMsize     = HSIZE;
              NextMburst    = HBURST;
              NextMprot     = HPROT;
              NextMmastlock = HMASTLOCK;
            end
          else                                                 // drive defaults
            begin
              NextMwrite    = 1'b0;
              NextMsize     = `SZ_BYTE;
              NextMburst    = `BUR_INCR;
              NextMprot     = 4'b0000;
              NextMmastlock = 1'b0;
            end

    end // block: p_nextMComb


//----------------------------------------------------------------------------
// Next Slave Output Signals
//----------------------------------------------------------------------------

  // HREADYOUT must be driven from the nextstate signals, as there can only
  // be one register in the path.

  assign NextHreadyout = (NextReadState == `ST_READ_HOLD ||
                          NextReadState == `ST_READ_INSERT_BUSY ||
                          NextReadState == `ST_READ_ERROR1 ||

                          NextWriteState == `ST_WRITE_HOLD ||
                          NextWriteState == `ST_WRITE_INSERT_BUSY1 ||
                          NextWriteState == `ST_WRITE_ERROR1 ||

                          NextBWriteState == `ST_BWRITE_HOLD) ? 1'b0

                         : 1'b1;

  // Only ERROR responses are passed through the bridge, but not during a
  // buffered write burst.

  assign NextHresp = (NextReadState == `ST_READ_ERROR1 ||
                      NextReadState == `ST_READ_ERROR2 ||

                      NextWriteState == `ST_WRITE_ERROR1 ||
                      NextWriteState == `ST_WRITE_ERROR2) ? `RSP_ERROR

                     : `RSP_OKAY;


  // Read data is simply registered through the bridge

  assign NextHrdata = MRDATA;


//----------------------------------------------------------------------------
// Bridge Output Registers
//----------------------------------------------------------------------------
// The register block is intended to provide timing isolation between the
// Slave interface and the AHB-Lite Master interface. All bridge outputs
// are registered.

  always @ (posedge HCLK or negedge HRESETn)
    begin : p_OutputRegistersSeq
      if (!HRESETn)
        begin
          iMADDR     <= {32{1'b0}};
          iMTRANS    <= `TRN_IDLE;
          iMWRITE    <= 1'b0;
          iMSIZE     <= `SZ_BYTE;
          iMBURST    <= `BUR_INCR;
          iMPROT     <= 4'b0000;
          iMMASTLOCK <= 1'b0;
          iHREADYOUT <= 1'b1;
          HRESP      <= `RSP_OKAY;
          iMWDATA    <= {32{1'b0}};
          HRDATA     <= {32{1'b0}};
        end
      else
        begin
          iMADDR     <= NextMaddr;
          iMTRANS    <= NextMtrans;
          iMWRITE    <= NextMwrite;
          iMSIZE     <= NextMsize;
          iMBURST    <= NextMburst;
          iMPROT     <= NextMprot;
          iMMASTLOCK <= NextMmastlock;
          iHREADYOUT <= NextHreadyout;
          HRESP      <= NextHresp;
          iMWDATA    <= NextMwdata;
          HRDATA     <= NextHrdata;
        end
    end // block: p_OutputRegistersSeq

  // Outputs that are fed back into the bridge
  assign MADDR     = iMADDR;
  assign MTRANS    = iMTRANS;
  assign MWRITE    = iMWRITE;
  assign MSIZE     = iMSIZE;
  assign MBURST    = iMBURST;
  assign MPROT     = iMPROT;
  assign MMASTLOCK = iMMASTLOCK;
  assign MWDATA    = iMWDATA;
  assign HREADYOUT = iHREADYOUT;

endmodule
