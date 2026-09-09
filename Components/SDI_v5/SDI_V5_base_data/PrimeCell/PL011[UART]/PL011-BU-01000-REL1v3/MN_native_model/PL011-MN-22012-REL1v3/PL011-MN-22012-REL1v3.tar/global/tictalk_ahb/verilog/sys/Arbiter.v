// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : Arbiter.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           AHB System Arbiter.
//           The arbiter processes requests for ownership of the
//           bus and grants one bus master according to the
//           arbitration scheme.
//           The arbitration scheme of this implementation is a
//           simple priority encoded scheme where the highest
//           priority master requesting the bus is granted.
//           The priority order is as follows:
//           1) Async. Reset = ARM
//           2) Pause mode = Default
//           3) TIC
//           4) 003
//           5) 004
//           6) ARM, when no others granted and ARM not split
//           7) Default, when no others granted and ARM split
//
// --=================================================================--

`timescale 1ns/1ps

module Arbiter (HCLK, HRESETn, HTRANS, HBURST, HREADY, HRESP,
                HBUSREQarm, HBUSREQtic, HBUSREQ003, HBUSREQ004,
                HLOCKarm, HLOCKtic, HLOCK003, HLOCK004, HSPLIT, Pause,
                HGRANTarm, HGRANTtic, HGRANT003, HGRANT004,
                HMASTER, HMASTLOCK);

  input         HCLK;
  input         HRESETn;
  input   [1:0] HTRANS;
  input   [2:0] HBURST;
  input         HREADY;
  input   [1:0] HRESP;

  input         HBUSREQarm; // Master bus request inputs
  input         HBUSREQtic;
  input         HBUSREQ003;
  input         HBUSREQ004;

  input         HLOCKarm; // Master bus lock request inputs
  input         HLOCKtic;
  input         HLOCK003;
  input         HLOCK004;

  input  [15:0] HSPLIT; // Slave split inputs

  input         Pause; // Pause mode entered

  output        HGRANTarm; // Master bus grant outputs
  output        HGRANTtic;
  output        HGRANT003;
  output        HGRANT004;

  output  [3:0] HMASTER;   // Current bus master
  output        HMASTLOCK; // Indicates locked sequence of transfers

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11

// HBURST transfer type signal encoding
  `define BUR_SINGLE 3'b000
  `define BUR_INCR   3'b001
  `define BUR_WRAP4  3'b010
  `define BUR_INCR4  3'b011
  `define BUR_WRAP8  3'b100
  `define BUR_INCR8  3'b101
  `define BUR_WRAP16 3'b110
  `define BUR_INCR16 3'b111

// HRESP transfer response signal encoding
  `define RSP_OKAY  2'b00
  `define RSP_ERROR 2'b01
  `define RSP_RETRY 2'b10
  `define RSP_SPLIT 2'b11

// HMASTER output encoding
  `define MST_DEF 4'b0000
  `define MST_ARM 4'b0001
  `define MST_TIC 4'b0010
  `define MST_003 4'b0011
  `define MST_004 4'b0100

// State encoding of the locked state machine
  `define ST_NORMAL    2'b00
  `define ST_LOCKED    2'b01
  `define ST_LAST_LOCK 2'b10
  `define ST_SPLIT     2'b11

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
  wire [15:0] HmasterDec;     // Decoded HMASTER
  wire [15:0] HmasterPrevDec; // Decoded HmasterPrev

  wire [15:0] MaskClear;      // Clears bits of mask
  wire [15:0] HreqMask;       // Request mask value
  reg  [15:0] HreqMaskReg;    // Registered mask

  wire        Hmaskarm;       // Masked bus request lines
  wire        Hmasktic;
  wire        Hmask003;
  wire        Hmask004;

  wire        HlockComb;      // Internal multiplexed version of inputs
  wire        HlockRegEn;     // HlockReg enable
  reg         HlockReg;       // Registered version of HlockComb

  reg   [1:0] NextLock;       // Locked state machine
  reg   [1:0] CurrentLock;
  wire        SplitLastNext;  // Input to SplitLast register
  reg         SplitLast;      // Last transfer was a locked split
  wire        GrantLock;      // Grant outputs are locked

  wire [15:0] HsplitMask;     // Masked HSPLIT input
  wire        SplitEnd;       // OR'd HsplitMask value

  reg         HgrantarmNew;   // New HGRANT values from HBUSREQ inputs
  reg         HgrantticNew;
  reg         Hgrant003New;
  reg         Hgrant004New;

  wire        iHMASTLOCK;     // Internal version of HMASTLOCK

  wire  [3:0] NextBurst;      // Burst transfer value
  wire        BurstEn;        // Enable for CurrentBurst register
  reg   [3:0] CurrentBurst;   // Burst transfer reg

  wire        HgrantEn;       // Select value to drive HGRANTx output

  reg         iHGRANTarm;     // Internal copies of output grant signals
  reg         iHGRANTtic;
  reg         iHGRANT003;
  reg         iHGRANT004;

  wire  [3:0] HmasterGen;     // Generated master number from iHGRANTx
  wire        HmasterPrevEn;  // Enable for HmasterPrev register
  reg   [3:0] HmasterPrev;    // Previous value of HMASTER
  reg   [3:0] iHMASTER;       // Internal version of HMASTER

// ---------------------------------------------------------------------
//  Dec function to decode a master number into a 15 bit mask value
// ---------------------------------------------------------------------

  function [15:0] Dec;
  input [3:0] MasterNum;
    case (MasterNum)
      4'b0000: Dec = 16'b0000000000000001;
      4'b0001: Dec = 16'b0000000000000010;
      4'b0010: Dec = 16'b0000000000000100;
      4'b0011: Dec = 16'b0000000000001000;
      4'b0100: Dec = 16'b0000000000010000;
      4'b0101: Dec = 16'b0000000000100000;
      4'b0110: Dec = 16'b0000000001000000;
      4'b0111: Dec = 16'b0000000010000000;
      4'b1000: Dec = 16'b0000000100000000;
      4'b1001: Dec = 16'b0000001000000000;
      4'b1010: Dec = 16'b0000010000000000;
      4'b1011: Dec = 16'b0000100000000000;
      4'b1100: Dec = 16'b0001000000000000;
      4'b1101: Dec = 16'b0010000000000000;
      4'b1110: Dec = 16'b0100000000000000;
      4'b1111: Dec = 16'b1000000000000000;
      default: Dec = 16'b0000000000000000;
    endcase
  endfunction

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Decoded bus master number
// ---------------------------------------------------------------------
// The 4-bit hex bus master number is decoded into 16 single bit values.
// The current HMASTER output is used in the HLOCK masking logic.
// The previous HMASTER output is used in the split grant masking logic.

  assign HmasterDec     = Dec(iHMASTER);
  assign HmasterPrevDec = Dec(HmasterPrev);

// ---------------------------------------------------------------------
// Split grant masking
// ---------------------------------------------------------------------
// When a split transfer occurs, the currently granted master must have
// its input request signal masked out so that it is not granted until
// the slave responds that the split transfer can continue.
// When a split transfer completes, the master that was performing the
// transfer must have its HBUSREQ input unmasked to allow it to be
// granted again.

// Mask bits are cleared during a split transfer, using MaskClear.
// Mask bits are set on completion of a split transfer, using HSPLIT.

  assign MaskClear = ((HRESP == `RSP_SPLIT && HREADY == 1'b0) ?
                     HmasterPrevDec : 16'h0000);

  assign HreqMask = (HreqMaskReg &  (~ (MaskClear)) ) | HSPLIT;

// Registers are used to hold the number of mask bits needed for all of
// the masters in the system.
// Unused mask register bits are optimised out during synthesis.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      HreqMaskReg <= 16'hFFFF;
    else
      HreqMaskReg <= HreqMask;
  end

// ---------------------------------------------------------------------
// Masked bus request input generation
// ---------------------------------------------------------------------
// The HBUSREQx inputs must be masked according to the split transfers
// that are taking place before the grant outputs are generated.
// When a bit of the mask is set LOW, the master will not be granted
// the bus until the slave ends the split, allowing the bus request
// signal to be passed to the grant generation logic.
// The combinational HreqMask values are used to avoid a one cycle
// delay on the HGRANTx signals due to the delay through the
// HreqMaskReg registers.

  assign Hmaskarm = HreqMask[1] & HBUSREQarm;
  assign Hmasktic = HreqMask[2] & HBUSREQtic;
  assign Hmask003 = HreqMask[3] & HBUSREQ003;
  assign Hmask004 = HreqMask[4] & HBUSREQ004;

// ---------------------------------------------------------------------
// HlockInt generation
// ---------------------------------------------------------------------
// The HLOCK inputs from the system masters must only be used when that
// master is driving the address and control signals, so are gated to
// produce an internal HlockInt signal.

  assign HlockComb = (((HLOCKarm == 1'b1 && HmasterDec[1] == 1'b1) ||
                       (HLOCKtic == 1'b1 && HmasterDec[2] == 1'b1) ||
                       (HLOCK003 == 1'b1 && HmasterDec[3] == 1'b1) ||
                       (HLOCK004 == 1'b1 && HmasterDec[4] == 1'b1)) ?
                     1'b1 : 1'b0);


// Register is disabled during a wait state or a locked split transfer.

  assign HlockRegEn = ((HREADY == 1'b0 || CurrentLock == `ST_SPLIT) ?
                      1'b0 : 1'b1);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      HlockReg <= 1'b0;
    else
    begin
      if (HlockRegEn)
        HlockReg <= HlockComb;
    end
  end

// ---------------------------------------------------------------------
// Locked state machine
// ---------------------------------------------------------------------
// This state machine is used to control the operation of the Arbiter
// during a locked transfer, ensuring that the grant outputs do not
// change until the last locked transfer has successfully completed.

  always @(CurrentLock or HREADY or HlockComb or HlockReg or
           SplitLast or HRESP or HmasterGen or HmasterPrev)
  begin
    case (CurrentLock)

      `ST_NORMAL :
        if ((HREADY && HlockComb && HRESP == `RSP_OKAY))
          NextLock = `ST_LOCKED;
        else
          NextLock = `ST_NORMAL;

      `ST_LOCKED :
        if (HREADY)
          if ((HlockComb || (HlockReg && SplitLast)))
            NextLock = `ST_LOCKED;
          else
            NextLock = `ST_LAST_LOCK;
        else
          if (HRESP == `RSP_SPLIT)
            NextLock = `ST_SPLIT;
          else
            NextLock = `ST_LOCKED;

      `ST_LAST_LOCK :
        if (HREADY)
          if ((HlockComb || HRESP == `RSP_RETRY))
            NextLock = `ST_LOCKED;
          else
            NextLock = `ST_NORMAL;
        else
          if (HRESP == `RSP_SPLIT)
            NextLock = `ST_SPLIT;
          else
            NextLock = `ST_LAST_LOCK;

      `ST_SPLIT :
        if ((HREADY && HmasterGen == HmasterPrev))
          NextLock = `ST_LOCKED;
        else
          NextLock = `ST_SPLIT;

      default :
        NextLock = `ST_NORMAL;

    endcase
  end

// Loads the value of NextLock in on each HCLK

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      CurrentLock <= `ST_NORMAL;
    else
      CurrentLock <= NextLock;
  end

// Used to detect when the last transfer was a locked split.

  assign SplitLastNext = (CurrentLock == `ST_SPLIT ? 1'b1 : 1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      SplitLast <= 1'b0;
    else
      SplitLast <= SplitLastNext;
  end

// Set HIGH when the next state is a locked transfer.

  assign GrantLock = ((NextLock == `ST_LOCKED ||
                       NextLock == `ST_SPLIT) ? 1'b1 : 1'b0);

// ---------------------------------------------------------------------
// End of Split transfer detection
// ---------------------------------------------------------------------
// The end of the current locked split transfer must be detected before
// the transfer may continue.
// This is done by using the bus master number of the locked master as
// a mask on the slave split input. The output of this is then OR'd
// together, and the result is used to determine if the split transfer
// can continue.

  assign HsplitMask = HmasterPrevDec & HSPLIT;

  assign SplitEnd = ((HsplitMask[15] | HsplitMask[14] | HsplitMask[13] |
                      HsplitMask[12] | HsplitMask[11] | HsplitMask[10] |
                      HsplitMask[9]  | HsplitMask[8]  | HsplitMask[7]  |
                      HsplitMask[6]  | HsplitMask[5]  | HsplitMask[4]  |
                      HsplitMask[3]  | HsplitMask[2]  | HsplitMask[1]  |
                      HsplitMask[0]) & GrantLock);

// ---------------------------------------------------------------------
// Arbitration Scheme
// ---------------------------------------------------------------------
// This section contains the arbitration priority algorithm, and should
// be changed if a different arbitration scheme is required.

// The default scheme is:
//  Default master granted during locked split transfers, when no masked
//   HBUSREQ inputs are set, and during pause mode.
//  Previous grant outputs used at the end of a locked split transfer,
//   or if the last locked transfer receives a retry response.
//  Core granted by default if it is not masked by an uncompleted split
//   and no other masters are requesting the bus.
//  All others granted when masked HBUSREQ set, in order of priority.

  always @(GrantLock or HRESP or SplitEnd or CurrentLock or
           HmasterPrevDec or Hmasktic or Pause or Hmask003 or
           Hmask004 or Hmaskarm or HreqMask)
  begin
    if (GrantLock && HRESP == `RSP_SPLIT)
    begin                  // Default selected during locked split
      HgrantarmNew = 1'b0;
      HgrantticNew = 1'b0;
      Hgrant003New = 1'b0;
      Hgrant004New = 1'b0;
    end
    else if (SplitEnd || (CurrentLock == `ST_LAST_LOCK &&
             HRESP == `RSP_RETRY))
    begin                  // Regrant previous
      HgrantarmNew = HmasterPrevDec[1];
      HgrantticNew = HmasterPrevDec[2];
      Hgrant003New = HmasterPrevDec[3];
      Hgrant004New = HmasterPrevDec[4];
    end
    else if (Pause)
    begin                  // Pause mode
      HgrantarmNew = 1'b0;
      HgrantticNew = 1'b0;
      Hgrant003New = 1'b0;
      Hgrant004New = 1'b0;
    end
    else if (Hmasktic)
    begin                  // TIC (highest priority)
      HgrantarmNew = 1'b0;
      HgrantticNew = 1'b1;
      Hgrant003New = 1'b0;
      Hgrant004New = 1'b0;
    end
    else if (Hmask003)
    begin                  // Bus master #003
      HgrantarmNew = 1'b0;
      HgrantticNew = 1'b0;
      Hgrant003New = 1'b1;
      Hgrant004New = 1'b0;
    end
    else if (Hmask004)
    begin                  // Bus master #004
      HgrantarmNew = 1'b0;
      HgrantticNew = 1'b0;
      Hgrant003New = 1'b0;
      Hgrant004New = 1'b1;
    end
    else if (Hmaskarm)
    begin                  // ARM Core Wrapper (lowest priority)
      HgrantarmNew = 1'b1;
      HgrantticNew = 1'b0;
      Hgrant003New = 1'b0;
      Hgrant004New = 1'b0;
    end
    else if (HreqMask[1])
    begin                  // Core granted by default if it
                           // is not masked
      HgrantarmNew = 1'b1; //  by a split.
      HgrantticNew = 1'b0;
      Hgrant003New = 1'b0;
      Hgrant004New = 1'b0;
    end
    else                   // Default bus master
    begin
      HgrantarmNew = 1'b0;
      HgrantticNew = 1'b0;
      Hgrant003New = 1'b0;
      Hgrant004New = 1'b0;
    end
  end

// ---------------------------------------------------------------------
// Burst transfer detection and grant holding
// ---------------------------------------------------------------------
// During a fixed length burst transfer a master may de-assert its
// grant request output, but the arbiter will not change the currently
// selected master until the penultimate transfer of the burst.
// If the burst is terminated early due to a split/retry transfer or
// the master ending the burst, then the grant outputs will change as
// normal.
//
// Set to 0000 when a split/retry response is received, or if the
// master ends the current burst transfer.
// Set to the burst size minus one when a new burst is started.
// Held at 0000 when no burst transfers are being performed.
// The counter value is decremented during the burst transfer.

  assign NextBurst = ((HRESP == `RSP_SPLIT || HRESP == `RSP_RETRY ||
                       HTRANS == `TRN_IDLE ||
                       (HBURST == `BUR_SINGLE ||
                        HBURST == `BUR_INCR)) ? 4'b0000 :
                     (((HBURST == `BUR_INCR16 ||
                        HBURST == `BUR_WRAP16) &&
                       HTRANS == `TRN_NONSEQ) ? 4'b1111 :
                     (((HBURST == `BUR_INCR8 || HBURST == `BUR_WRAP8) &&
                       HTRANS == `TRN_NONSEQ) ? 4'b0111 :
                     (((HBURST == `BUR_INCR4 || HBURST == `BUR_WRAP4) &&
                       HTRANS == `TRN_NONSEQ) ? 4'b0011 :
                     (CurrentBurst == 4'b0000 ? 4'b0000 :
                     CurrentBurst - 1'b1)))));

// Counter register is only enabled during a valid unwaited burst
// transfer.

  assign BurstEn = ((HREADY == 1'b1 &&
                     (HTRANS == `TRN_SEQ || HTRANS == `TRN_NONSEQ)) ?
                   1'b1 : 1'b0);

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if ((!HRESETn))
      CurrentBurst <= 4'h0;
    else
    begin
      if (BurstEn)
        CurrentBurst <= NextBurst;
    end
  end

// --------------------------------------------------------------------
// HGRANT output selection control
// --------------------------------------------------------------------
// The HgrantEn signal is used to select between loading the output
// registers with the new HGRANTx values, or to hold the current value.
// Set HIGH when not performing a locked transfer, and during the last
// two transfers of a fixed length burst, allowing the grant outputs to
// change during the very last transfer of a fixed length burst.
// Also set HIGH during a locked split transfer, to select the default
// master.
// Set LOW at all other times, during a locked transfer and during the
// first N-1 transfers of a fixed length burst of N transfers.

  assign HgrantEn = (((NextBurst == 4'b0001 || NextBurst == 4'b0000) &&
                      ((GrantLock == 1'b1 && HRESP == `RSP_SPLIT) ||
                       GrantLock == 1'b0 || SplitEnd == 1'b1)) ?
                    1'b1 : 1'b0);

// ---------------------------------------------------------------------
// HGRANT output registers
// ---------------------------------------------------------------------
// Stores the currently selected bus master HGRANTx output. The output
// is held during a locked or fixed length burst transfer.
// The ARM Core Wrapper is granted control of the bus during reset,
// ensuring that it has immediate access to the bus if required.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
    begin
      iHGRANTarm <= 1'b1; // Core granted during reset
      iHGRANTtic <= 1'b0;
      iHGRANT003 <= 1'b0;
      iHGRANT004 <= 1'b0;
    end
    else
    begin
      if (HgrantEn)
      begin
        iHGRANTarm <= HgrantarmNew;
        iHGRANTtic <= HgrantticNew;
        iHGRANT003 <= Hgrant003New;
        iHGRANT004 <= Hgrant004New;
      end
    end
  end

// ---------------------------------------------------------------------
// HMASTER output generation and registers
// ---------------------------------------------------------------------
// HMASTER is used to control the address and control multiplexers, and
// HMASTERD is used to control the data multiplexer.

// Generates the HMASTER number from the current grant output signals,
// and then stores it in a register to generate the correct HMASTER
// output timing, so that it is valid when the master is driving the
// address and control lines.

  assign HmasterGen = (iHGRANTarm == 1'b1 ? `MST_ARM : // Master 1 = ARM
                      (iHGRANTtic == 1'b1 ? `MST_TIC : // Master 2 = TIC
                      (iHGRANT003 == 1'b1 ? `MST_003 : // Master 3 = 003
                      (iHGRANT004 == 1'b1 ? `MST_004 : // Master 4 = 004
                      `MST_DEF))));                // Master 0 = Default

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      iHMASTER <= `MST_DEF;
    else
    begin
      if (HREADY)
        iHMASTER <= HmasterGen;
    end
  end

// The enable is used to ensure that the currently stored bus master
// number does not change when the previous transfer is waited or was a
// locked transfer.

  assign HmasterPrevEn = ((HREADY == 1'b1 &&
                           (CurrentLock == `ST_NORMAL ||
                            CurrentLock == `ST_LAST_LOCK)) ? 1'b1 :
                         1'b0);

// Used to clear bits in the grant mask when a split response is
// detected, and contains the number of the master that is currently
// driving/reading the data buses. Also used in the locked state
// machine to check for ended split transfers.

  always @( negedge (HRESETn) or posedge (HCLK) )
  begin
    if (!HRESETn)
      HmasterPrev <= 4'b0000;
    else
    begin
      if (HmasterPrevEn)
        HmasterPrev <= iHMASTER;
    end
  end

// ---------------------------------------------------------------------
// HMASTLOCK output
// ---------------------------------------------------------------------
// The HMASTLOCK output is valid during the address phase of the locked
//  transfers, and is based on the locked state machine.

  assign iHMASTLOCK = (CurrentLock == `ST_LOCKED ? 1'b1 : 1'b0);

// ---------------------------------------------------------------------
// Output drivers
// ---------------------------------------------------------------------
// Drive the grant outputs with the internal versions.
  assign HGRANTarm = iHGRANTarm;
  assign HGRANTtic = iHGRANTtic;
  assign HGRANT003 = iHGRANT003;
  assign HGRANT004 = iHGRANT004;

// Drive the output ports with the internal versions of the signals.
  assign HMASTER   = iHMASTER;
  assign HMASTLOCK = iHMASTLOCK;


endmodule

// --============================== End ==============================--
