//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : apbif.v.rca
//  File Revision       : 1.1
//  
//  Release Information : PrimeCell(TM)-GLOBAL-REL1v7
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Converts ASB peripheral transfers to APB transfers
//  --========================================================================--

`timescale 1ns/1ps

module apbif (BCLK, BnRES, BA, BWRITE, DSELPeri, BD, BWAIT, BERROR, BLAST,
              PRDATA, PWDATA, PENABLE, PSELIC, PSELUUT, PSELRPC, PADDR, PWRITE);
 
  input         BCLK;
  input         BnRES;
  input  [31:0] BA;
  input         BWRITE;
  input         DSELPeri;
  inout  [31:0] BD;
  output        BWAIT;
  output        BERROR;
  output        BLAST;

  input  [31:0] PRDATA;
  output [31:0] PWDATA;
  output        PENABLE;
  output        PSELIC;  // Interrupt Controller
  output        PSELRPC; // Remap and Pause
  output [31:0] PADDR;
  output        PWRITE;
  output        PSELUUT;

  // ---------------------------------------------------------------------------
  //  Constant declarations
  // ---------------------------------------------------------------------------
  //  This constant defines the size of the peripheral address bus
  `define PADDRWIDTH 32'd16

  //  APBIF states:
  //   ST_IDLE   is APB bus idle state entered on reset
  //   ST_WWAIT  is write wait state
  //   ST_WRITE  is write setup
  //   ST_READ   is read setup
  //   ST_ENABLE only uses the msb of the state machine, so a direct decode
  //             of the msb can be used to generate iPENABLE. Changes in the 
  //             state encoding might affect this signal assignment.
  `define ST_IDLE   3'b000
  `define ST_WWAIT  3'b001
  `define ST_WRITE  3'b010
  `define ST_READ   3'b011
  `define ST_ENABLE 3'b100
 
  // EASY Peripherals address decoding values:
  // Reset & Pause            0x88000000 to 0x8BFFFFFF
  // Interrupt Controller     0x80000000 to 0x83FFFFFF
  `define RPCBASE  4'b0010
  `define ICBASE   4'b0000

  // New peripherals should use the next available UUT*BASE address.
  // After a UUT*BASE address has been selected assign the selected
  // PSELUUT* to the PSELUUT signal

  //   Uart    0x8C000000
  `define UUT0BASE 4'b0011
 
  //   Ssp    0x90000000
  `define UUT1BASE 4'b0100
 
  //   Rtc    0x94000000
  `define UUT2BASE 4'b0101
 
  //   Gpio    0x98000000
  `define UUT3BASE 4'b0110
 
  //   Kmi    0x9C000000
  `define UUT4BASE 4'b0111
 
  //   Sci    0xA0000000
  `define UUT5BASE 4'b1000

  `define UUT6BASE  4'b1001
  `define UUT7BASE  4'b1010
  `define UUT8BASE  4'b1011
  `define UUT9BASE  4'b1100
  `define UUT10BASE 4'b1101
 
// -----------------------------------------------------------------------------
//  Signal declarations
// -----------------------------------------------------------------------------
  wire       APBEn;                 // High if in either READ or WRITE state
  wire       BWAITInt;              // Internal BWAIT
  wire       PWDATAEn;              // PWDATA Register enable
  wire       BDEn;                  // BD tristate enable
  wire       PSELRes;               // PSEL reset
  wire       iPENABLE;              // Internal PENABLE
 
  reg        PSELICInt;             // Internal PSELIC
  reg        PSELRPCInt;            // Internal PSELRPC

  reg        PSELUUT0Int;           // Internal PSELUUT0
  reg        PSELUUT1Int;           // Internal PSELUUT1
  reg        PSELUUT2Int;           // Internal PSELUUT2
  reg        PSELUUT3Int;           // Internal PSELUUT3
  reg        PSELUUT4Int;           // Internal PSELUUT4
  reg        PSELUUT5Int;           // Internal PSELUUT5
  reg        PSELUUT6Int;           // Internal PSELUUT6
  reg        PSELUUT7Int;           // Internal PSELUUT7
  reg        PSELUUT8Int;           // Internal PSELUUT8
  reg        PSELUUT9Int;           // Internal PSELUUT9
  reg        PSELUUT10Int;          // Internal PSELUUT10

  reg [2:0]  NextState;             // State machine
  reg [2:0]  CurrentState;

  reg        iPWRITE;               // Registered internal PWRITE
  reg [`PADDRWIDTH - 1:0] PADDRInt; // Registered internal PADDR
  reg        BWELEn;                // BWAIT, BERROR and BLAST enable
  reg        PrevDSEL;              // Registered DSELPeri for BWAITInt
  reg [31:0] PWDATA;
  reg        PSELRPC;
  reg        PSELIC;

  reg PSELUUT0;
  reg PSELUUT1;
  reg PSELUUT2;
  reg PSELUUT3;
  reg PSELUUT4;
  reg PSELUUT5;
  reg PSELUUT6;
  reg PSELUUT7;
  reg PSELUUT8;
  reg PSELUUT9;
  reg PSELUUT10;

  reg BLAST;
  reg BERROR;
  reg BWAIT;
  reg [31:0] TRIbd;
  assign BD = TRIbd;
 
// -----------------------------------------------------------------------------
//  Beginning of main code
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  APB address decoding for slave devices
// -----------------------------------------------------------------------------
//  Only decodes the address when APB is selected (DSELPeri high), not in reset
//  and NextState is ST_WRITE or ST_READ.
//  When address is used that is not in any of the ranges specified, operation
//  of the system continues, but no PSEL lines are set, so no peripherals are
//  selected during read/write operation.
//  Operation of PWDATA, PWRITE, PENABLE and PADDR continues as normal

  always @(BnRES or BA or DSELPeri or NextState)
  begin
    PSELICInt = 1'b0;
    PSELRPCInt = 1'b0;
    PSELUUT0Int = 1'b0;
    PSELUUT1Int = 1'b0;
    PSELUUT2Int = 1'b0;
    PSELUUT3Int = 1'b0;
    PSELUUT4Int = 1'b0;
    PSELUUT5Int = 1'b0;
    PSELUUT6Int = 1'b0;
    PSELUUT7Int = 1'b0;
    PSELUUT8Int = 1'b0;
    PSELUUT9Int = 1'b0;
    PSELUUT10Int = 1'b0;
    if ((BnRES &&
        (NextState == `ST_WRITE || NextState == `ST_READ) && DSELPeri))
      case (BA[29:26])
        `ICBASE :
          PSELICInt = 1'b1;
        `RPCBASE :
          PSELRPCInt = 1'b1;
        `UUT0BASE :
          PSELUUT0Int = 1'b1;
        `UUT1BASE :
          PSELUUT1Int = 1'b1;
        `UUT2BASE :
          PSELUUT2Int = 1'b1;
        `UUT3BASE :
          PSELUUT3Int = 1'b1;
        `UUT4BASE :
          PSELUUT4Int = 1'b1;
        `UUT5BASE :
          PSELUUT5Int = 1'b1;
        `UUT6BASE :
          PSELUUT6Int = 1'b1;
        `UUT7BASE :
          PSELUUT7Int = 1'b1;
        `UUT8BASE :
          PSELUUT8Int = 1'b1;
        `UUT9BASE :
          PSELUUT9Int = 1'b1;
        `UUT10BASE :
          PSELUUT10Int = 1'b1;
        default  : ;
      endcase
  end
 
// -----------------------------------------------------------------------------
//  Registered DSELPeri
// -----------------------------------------------------------------------------
//  Delayed DSELPeri line reading used to generate NextState and BWAITInt when
//  single address cycles are used

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if ((!BnRES))
      PrevDSEL <= 1'b0;
    else
      PrevDSEL <= DSELPeri;
  end
 
// -----------------------------------------------------------------------------
//  Next state logic for APB state machine
// -----------------------------------------------------------------------------
//  Generates next state from CurrentState and ASB inputs, with reset

  always @(BnRES or CurrentState or DSELPeri or BWRITE or PrevDSEL)
  begin
    if ((!BnRES))
      NextState = `ST_IDLE;
    else
      case (CurrentState)
        `ST_IDLE :                     //  Idle state
          if ((DSELPeri))
            if (BWRITE)                //  Enter Write Wait state
              NextState = `ST_WWAIT;
            else                       //  Go straigh to Read state
              NextState = `ST_READ;
           else
            NextState = `ST_IDLE;
        `ST_READ :                     //  Start of APB Read cycle
          NextState = `ST_ENABLE;
        `ST_WWAIT :                    //  Hold for one cycle before write
          NextState = `ST_WRITE;
        `ST_WRITE :                    //  Start of APB Write cycle
          NextState = `ST_ENABLE;
        `ST_ENABLE :                   //  Enable cycle to complete transaction
          if ((DSELPeri))
            if (BWRITE)
              if (!PrevDSEL)
                NextState = `ST_WWAIT; //  Non-seq, so insert write wait state
              else
                NextState = `ST_WRITE; //  Seq, so straight to write
            else
              NextState = `ST_READ;    //  Seq, so straight to read
          else
            NextState = `ST_IDLE;      //  End of transfer, so back to idle
        default  :
          NextState = `ST_IDLE;        //  Return to idle on FSM error
      endcase
  end
 
// -----------------------------------------------------------------------------
//  State machine
// -----------------------------------------------------------------------------
//  No reset term as NextState is reset to ST_IDLE
//  Changes state on rising edge of BCLK

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if ((!BnRES))
      CurrentState <= `ST_IDLE;
    else
      CurrentState <= NextState;
  end
 
// -----------------------------------------------------------------------------
//  Current State decoding
// -----------------------------------------------------------------------------
//  BWAIT is set according to the values of DSELPeri, CurrentState, NextState
//  and PrevDSEL.
//  Wait cycles are inserted:
//   - on exit from ST_IDLE when DSELPeri is HIGH
//   - during ST_WRITE when DSELPeri is still HIGH, indicating another transfer
//   - during ST_ENABLE when followed by a sequential read transfer
//   - during ST_ENABLE when DSELPeri is set HIGH following one address
//      transfer, indicated by PrevDSEL being LOW.

  assign BWAITInt = ((DSELPeri == 1'b1 && CurrentState == `ST_IDLE) ||
                     (DSELPeri == 1'b1 && CurrentState == `ST_WRITE) ||
                     (CurrentState == `ST_ENABLE && NextState == `ST_READ) ||
                     (CurrentState == `ST_ENABLE && DSELPeri == 1'b1 &&
                      PrevDSEL == 1'b0) ? 1'b1 : 1'b0);

//  APBEn set when preforming an access on the APB, ie when the current state
//  is ST_READ or ST_WRITE

  assign APBEn = (((NextState == `ST_READ || NextState == `ST_WRITE) &&
                   DSELPeri == 1'b1) ? 1'b1 : 1'b0);

// -----------------------------------------------------------------------------
//  iPWRITE generation
// -----------------------------------------------------------------------------
//  BWRITE is captured by an APBEn enabled register to generate iPWRITE
//  output port
//  Only changes when APB is accessed

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if ((!BnRES))
      iPWRITE <= 1'b0;
    else
      if ((APBEn))
        iPWRITE <= BWRITE;
  end
 
// -----------------------------------------------------------------------------
//  Registered BA for reads and writes (PADDRInt)
// -----------------------------------------------------------------------------
//  BA is captured by an APBEn enabled register to generate PADDRInt
//  BA is always valid before rising BCLK
//  Signal PADDRInt is used so that only (PADDRWIDTH - 1) of PADDR is driven
//  PADDRInt driven on State Machine change to ST_READ or ST_WRITE, with reset
//   to zero

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if ((!BnRES))
      PADDRInt <= {16{ 1'b0 }};
    else
      if ((APBEn))
        PADDRInt <= BA[`PADDRWIDTH - 1:0];
  end
 
// -----------------------------------------------------------------------------
//  Internal PENABLE generation
// -----------------------------------------------------------------------------
//  This is set to be a direct copy of one of the FSM bits. This should be
//  changed if the state encoding of the FSM is altered from the default

  assign iPENABLE = CurrentState[2];

// -----------------------------------------------------------------------------
//  BD tristate enable generation
// -----------------------------------------------------------------------------
//  Sets output enable to drive BD during read cycle

  assign BDEn =
          ((BCLK == 1'b1 && iPWRITE == 1'b0 && iPENABLE == 1'b1) ? 1'b1 : 1'b0);

// -----------------------------------------------------------------------------
//  Slave response tristate enable generation
// -----------------------------------------------------------------------------
//  Sets output enable to drive slave response signals when APBif selected

  always @(BnRES or BCLK or DSELPeri)
  begin
    if ((!BnRES))
      BWELEn = 1'b0;
    else if ((DSELPeri && !BCLK))
      BWELEn = 1'b1;
    else
      BWELEn = 1'b0;
  end
 
// -----------------------------------------------------------------------------
//  Registered BD for writes (PWDATA)
// -----------------------------------------------------------------------------
//  Write wait state allows a register to be used to hold PWDATA
//  Register enabled when in ST_WRITE
//  Tristate not needed as bridge is only module that drives PWDATA

  assign PWDATAEn = (NextState == `ST_WRITE ? 1'b1 : 1'b0);

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if ((!BnRES))
      PWDATA <= {32{ 1'b0 }};
    else
      if (PWDATAEn)
        PWDATA <= BD;
  end
 
// -----------------------------------------------------------------------------
//  APB output signals
// -----------------------------------------------------------------------------
//  Drive PADDR and PWRITE with internal signals

  assign PADDR[`PADDRWIDTH - 1:0] = PADDRInt;

  assign PWRITE = iPWRITE;

  assign PENABLE = iPENABLE;

//  Synchronous reset used to clear the PSEL outputs at the end of a transfer
  assign PSELRes = (((CurrentState == `ST_ENABLE && DSELPeri == 1'b0) ||
         (CurrentState == `ST_ENABLE && NextState == `ST_WWAIT)) ? 1'b1 : 1'b0);

//  Drives PSEL outputs with internal signals or set LOW on reset:
//  Set   outputs with internal values when in ST_READ or ST_WRITE states
//  Hold  outputs when in ST_ENABLE state (APBEn LOW)
//  Reset outputs on system reset or at end of transfer

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if ((!BnRES))
    begin
      PSELIC <= 1'b0;
      PSELRPC <= 1'b0;
      PSELUUT0 <= 1'b0;
      PSELUUT1 <= 1'b0;
      PSELUUT2 <= 1'b0;
      PSELUUT3 <= 1'b0;
      PSELUUT4 <= 1'b0;
      PSELUUT5 <= 1'b0;
      PSELUUT6 <= 1'b0;
      PSELUUT7 <= 1'b0;
      PSELUUT8 <= 1'b0;
      PSELUUT9 <= 1'b0;
      PSELUUT10 <= 1'b0;
    end
    else
      if ((APBEn))
      begin
        PSELIC    <= PSELICInt;
        PSELRPC   <= PSELRPCInt;
        PSELUUT0  <= PSELUUT0Int;
        PSELUUT1  <= PSELUUT1Int;
        PSELUUT2  <= PSELUUT2Int;
        PSELUUT3  <= PSELUUT3Int;
        PSELUUT4  <= PSELUUT4Int;
        PSELUUT5  <= PSELUUT5Int;
        PSELUUT6  <= PSELUUT6Int;
        PSELUUT7  <= PSELUUT7Int;
        PSELUUT8  <= PSELUUT8Int;
        PSELUUT9  <= PSELUUT9Int;
        PSELUUT10 <= PSELUUT10Int;
      end
      else if ((PSELRes))
      begin
        PSELIC    <= 1'b0;
        PSELRPC   <= 1'b0;
        PSELUUT0  <= 1'b0;
        PSELUUT1  <= 1'b0;
        PSELUUT2  <= 1'b0;
        PSELUUT3  <= 1'b0;
        PSELUUT4  <= 1'b0;
        PSELUUT5  <= 1'b0;
        PSELUUT6  <= 1'b0;
        PSELUUT7  <= 1'b0;
        PSELUUT8  <= 1'b0;
        PSELUUT9  <= 1'b0;
        PSELUUT10 <= 1'b0;
      end
  end
 
assign PSELUUT = PSELUUT3;

//  No change on PSEL outputs
// -----------------------------------------------------------------------------
//  Tristate output drivers
// -----------------------------------------------------------------------------
//  Tristate outputs for BD and slave response signals

  always @(PRDATA or BDEn)
  begin
    if ((BDEn))
      TRIbd = PRDATA;
    else
      TRIbd = 32'hzzzz_zzzz;
  end
 
  always @(BWAITInt or BWELEn)
  begin
    if ((BWELEn))
    begin
      BWAIT  = BWAITInt;
      BERROR = 1'b0;
      BLAST  = 1'b0;
    end
    else
    begin
      BWAIT  = 1'bz;
      BERROR = 1'bz;
      BLAST  = 1'bz;
    end
  end
 
endmodule

//  --================================ End ===================================--
