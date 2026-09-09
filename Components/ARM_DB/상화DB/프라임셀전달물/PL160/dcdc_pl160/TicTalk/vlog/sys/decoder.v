// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : decoder.v,v
// File Revision       : 1.2
//  
// Release Information : PL160-REL1v1
// 
// -----------------------------------------------------------------------------
// Purpose : To provide the DSELx module select outputs from the 
//           address bus. This block is specific to a particular
//           implementation.
//
//           When the DSelEn signal is asserted, this block
//           decodes the address and assert the appropriate DSELx
//           signal.
// --=========================================================================--

`timescale 1ns/1ps

module decoder (BCLK, BnRES, BSIZE, BTRAN, BA, Remap, BWAIT, BERROR, BLAST,
                DSELIntMem, DSELExtMem, DSELPeri, DSELARMTest);

  input        BCLK;
  input        BnRES;
  input  [1:0] BSIZE;
  input  [1:0] BTRAN;
  input [31:0] BA;
  input        Remap;
  inout        BWAIT;
  inout        BERROR;
  inout        BLAST;
  output       DSELIntMem;  // DSELx outputs from address decoder
  output       DSELExtMem;  // Address decode error
  output       DSELPeri;    // DecLast mux value
  output       DSELARMTest; // Address is on 1K boundary

// -----------------------------------------------------------------------------
//  Constant declarations
// -----------------------------------------------------------------------------
//  Set to 1 to use decode cycle version, 0 to use without decode cycles
  `define DECEN      1'd1

//  For simulation, the DECEN constant in the Buswatcher should also be changed,
//  and the simulation clock frequency of each testbench should also be changed
//  State encoding minimises pin changes between ST_SLAVE and ST_ADDRESS,
//  and ST_SLAVE and ST_DECODE
  `define ST_SLAVE   2'b00
  `define ST_ADDRESS 2'b01
  `define ST_DECODE  2'b10
  `define ST_ERROR   2'b11
 
  `define tran_stran 2'b11
  `define tran_ntran 2'b10
  `define tran_atran 2'b00

// -----------------------------------------------------------------------------
//  Signal declarations
// -----------------------------------------------------------------------------
  wire      SeqEn;             // Sequential transfer enable
  wire      DSELRegEn;         // DSEL register enable

  wire      DSELIntMemInt;     // Registered/decoded mux values
  wire      DSELExtMemInt;
  wire      DSELARMTestInt;
  wire      DSELPeriInt;
  wire      DecError;

  wire      BEL;               // !BERROR.BLAST
  wire      DecBlast;          // Signals end of burst transfer
  wire      BWELEn;            // BWAIT, BERROR and BLAST enable
 
  reg       DSELIntMemDec;     // DSELx outputs from address decoder
  reg       DSELExtMemDec;
  reg       DSELARMTestDec;
  reg       DSELPeriDec;
  reg       DecErrorDec;       // Address decode error

  reg       DSELIntMemReg;     // DSELx registers of decoded values
  reg       DSELExtMemReg;
  reg       DSELARMTestReg;
  reg       DSELPeriReg;
  reg       DecErrorReg;       // Registered decoded error value

  reg       DecLastMux;

  reg       DecLast;           // Address is on 1K boundary
  reg       BWAITReg;          // Registered slave response signal inputs
  reg       BELReg;            // BEL Register
  reg [1:0] BTRANLat;          // BTRAN latch

  reg [1:0] NextState;         // State machine
  reg [1:0] CurrentState;

  reg       BWAITInt;          // Internal slave response signals
  reg       BERRORInt;

  reg       DSelEn;            // DSELx output enable signal

  reg       TRIberror;
  assign BERROR = TRIberror;
  reg       TRIblast;
  assign BLAST = TRIblast;
  reg       TRIbwait;
  assign BWAIT = TRIbwait;
 
// -----------------------------------------------------------------------------
//  Beginning of main code
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  ASB address decoding for slave devices
// -----------------------------------------------------------------------------
//  Address decoding of BA performed continuously
//  Address map is
//  0x00000000 - 0x000003FF Intmem (Only when Remap is HIGH)
//  0x00000000 - 0x7FFFFFFF External Memory (Remap LOW)
//  0x00000400 - 0x7FFFFFFF External Memory (Remap HIGH)
//  0x80000000 - 0xBFFFFFFF Peripherals
//  0xC0000000 - 0xDFFFFFFF ARM Test
//  0xE0000000 - 0xFFFFFFFF undefined

  always @(BA or Remap)
  begin
    DSELIntMemDec = 1'b0;
    DSELExtMemDec = 1'b0;
    DSELARMTestDec = 1'b0;
    DSELPeriDec = 1'b0;
    DecErrorDec = 1'b0;

    // Glitches to 'X' on BA will cause glitches on DecError and all DSEL lines

    if ((BA[31:10] == 22'b0000000000000000000000 && Remap))
      DSELIntMemDec = 1'b1;         // Internal Memory
    else if ((!BA[31]))
      DSELExtMemDec = 1'b1;         // External Memory
    else if ((BA[31:30] == 2'b10))
      DSELPeriDec = 1'b1;           // Peripherals
    else if ((BA[31:29] == 3'b110))
      DSELARMTestDec = 1'b1;        // ARM Test
    else
      DecErrorDec = 1'b1;           // Undefined (BERROR assertion)
  end
 
// -----------------------------------------------------------------------------
//  Address decoding of 1K boundaries
// -----------------------------------------------------------------------------
//  Inserts decode cycle when 1K boundary is reached

  always @(BA or BSIZE)
  begin
    if ((BA[9:2] == 8'b11111111) &&
        ((BSIZE[1]) ||                               // Last word
         (BA[1] && BSIZE[0]) ||                      // Last half word
         (BA[1:0] == 2'b11 && BSIZE[1:0] == 2'b00))) // Last byte
      DecLastMux = 1'b1;
    else
      DecLastMux = 1'b0;
  end
 
// -----------------------------------------------------------------------------
//  Internal DSEL generation
// -----------------------------------------------------------------------------
//  Decoded DSEL lines are stored in registers during sequential transfers to
//  remove glitches caused by late arrival of address line
//  Registers hold their current value during a sequential transfer or decode
//  cycle, and are loaded with the decoded values at all other times

  assign SeqEn =
         ((BTRANLat == `tran_stran && CurrentState == `ST_SLAVE) ? 1'b1 : 1'b0);

// NextState checking is disabled when the decoder without wait state is used

  assign DSELRegEn = ((SeqEn == 1'b0 && !(`DECEN == 1'b1 &&
                                      NextState == `ST_DECODE)) ? 1'b1 : 1'b0);

  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if (!BnRES)
    begin
      DSELIntMemReg <= 1'b0;
      DSELExtMemReg <= 1'b0;
      DSELARMTestReg <= 1'b0;
      DSELPeriReg <= 1'b0;
      DecErrorReg <= 1'b0;
    end
    else
      if ((DSELRegEn))
      begin
        DSELIntMemReg <= DSELIntMemDec;
        DSELExtMemReg <= DSELExtMemDec;
        DSELARMTestReg <= DSELARMTestDec;
        DSELPeriReg <= DSELPeriDec;
        DecErrorReg <= DecErrorDec;
      end
  end
 
//  DSELInt signals are set to registered values while performing a sequential
//  transfer, or directly decoded values at all other times

  assign DSELIntMemInt  = (SeqEn == 1'b1 ? DSELIntMemReg : DSELIntMemDec);
  assign DSELExtMemInt  = (SeqEn == 1'b1 ? DSELExtMemReg : DSELExtMemDec);
  assign DSELARMTestInt = (SeqEn == 1'b1 ? DSELARMTestReg : DSELARMTestDec);
  assign DSELPeriInt    = (SeqEn == 1'b1 ? DSELPeriReg : DSELPeriDec);
  assign DecError       = (SeqEn == 1'b1 ? DecErrorReg : DecErrorDec);

// -----------------------------------------------------------------------------
// DecLast generation register
// -----------------------------------------------------------------------------
// Register to delay 1K boundary decoding so that the state machine does not go
// to the decode state before the transfer has completed

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      DecLast <= 1'b0;
    else
      DecLast <= DecLastMux;
  end
 
// -----------------------------------------------------------------------------
//  Input slave response registers
// -----------------------------------------------------------------------------
//  Registered versions of slave response input signals used in generation of
//  NextState and DecBlast

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      BWAITReg <= 1'b0;
    else
      BWAITReg <= BWAIT;
  end
 
//  Combinational input to dff as both BERROR and BLAST are used together, so
//  can use one dff to store value for use in generation of DecBlast

  assign BEL = (BERROR == 1'b0 && BLAST == 1'b1 ? 1'b1 : 1'b0);

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      BELReg <= 1'b0;
    else
      BELReg <= BEL;
  end
 
//  High when at end of burst cycle (BWAIT and BERROR low, BLAST high)
//  Held low when not using decode cycles

  assign DecBlast = `DECEN & (~ BWAITReg) & BELReg;

// BTRAN input latch
  always @(BnRES or BCLK or BTRAN)
  begin
    if (!BnRES)
      BTRANLat = 2'b00;
    else if (BCLK)
      BTRANLat = BTRAN;
  end
 
// -----------------------------------------------------------------------------
//  Next state logic for decoder state machine
// -----------------------------------------------------------------------------
//  The following constants are used (defined in Defs)
//      TRAN_ATRAN - "00"
//      TRAN_NTRAN - "10"
//      TRAN_STRAN - "11"

//  NextState generated from CurrentState, BTRAN, DecError and last signals
//  Glitches on DecError will cause glitches on NextState from ST_SLAVE to
//  ST_ERROR which propagate to the DSELx outputs, when DECEN = '0'

  always @(BnRES or BTRAN or BWAITReg or DecBlast or CurrentState or DecLast or
           DecError)
  begin
    if ((!BnRES))  //  sync reset, deselect all slaves
      NextState = `ST_ADDRESS;
    else
      case (CurrentState)
        `ST_ADDRESS : //  Address only transfer
          if (`DECEN && BTRAN == `tran_ntran)
            NextState = `ST_DECODE;
          else if (`DECEN && BTRAN == `tran_stran && DecError)
            NextState = `ST_ERROR;
          else if (`DECEN && BTRAN == `tran_stran && !DecError)
            NextState = `ST_SLAVE;
          else if (!`DECEN && ((BTRAN == `tran_ntran) ||
                               (BTRAN == `tran_stran)) && (!DecError))
            NextState = `ST_SLAVE;
          else if (!`DECEN && ((BTRAN == `tran_ntran) ||
                               (BTRAN == `tran_stran)) && (DecError))
            NextState = `ST_ERROR;
          else
            NextState = `ST_ADDRESS;
        `ST_DECODE : //  Waits for address to be decoded, sets BWAIT high
          if (DecError)
            NextState = `ST_ERROR;
          else
            NextState = `ST_SLAVE;
        `ST_SLAVE :  //  Select slave and perform transfer
          if (BWAITReg)
            NextState = `ST_SLAVE;
          else if (BTRAN == `tran_atran)
            NextState = `ST_ADDRESS;
          else if (`DECEN && (BTRAN == `tran_ntran ||
                             (BTRAN == `tran_stran && (DecLast || DecBlast))))
            NextState = `ST_DECODE;
          else if (!`DECEN && ((BTRAN == `tran_ntran) ||
                               (BTRAN == `tran_stran)) && (DecError))
            NextState = `ST_ERROR;
          else
            NextState = `ST_SLAVE;
        `ST_ERROR : //  Set BERROR high
          if (BTRAN == `tran_atran)
            NextState = `ST_ADDRESS;
          else if (`DECEN && ((BTRAN == `tran_stran && DecLast) ||
                              (BTRAN == `tran_ntran)))
            NextState = `ST_DECODE;
          else if (!`DECEN && ((BTRAN == `tran_ntran) ||
                               (BTRAN == `tran_stran)) && (!DecError))
            NextState = `ST_SLAVE;
          else
            NextState = `ST_ERROR;
        default  :
          NextState = `ST_ADDRESS;
      endcase
  end
 
// -----------------------------------------------------------------------------
//  State machine
// -----------------------------------------------------------------------------
//  Changes state on falling edge of BCLK

  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if (!BnRES)
      CurrentState <= `ST_ADDRESS;
    else
      CurrentState <= NextState;
  end
 
// -----------------------------------------------------------------------------
//  Current State decoding
// -----------------------------------------------------------------------------
//  Slave response signals generated from current state

  always @(CurrentState)
  begin
    if ((CurrentState == `ST_DECODE))
    begin
      BWAITInt = 1'b1;
      BERRORInt = 1'b0;
    end
    else if ((CurrentState == `ST_ERROR))
    begin
      BWAITInt = 1'b0;
      BERRORInt = 1'b1;
    end
    else
    begin
      BWAITInt = 1'b0;
      BERRORInt = 1'b0;
    end
  end
 
// -----------------------------------------------------------------------------
//  DSelEn generation
// -----------------------------------------------------------------------------
//  Latch to hold value of DSELx enable, to generate DSELx output port signals
//  from internal address decoder DSELxInt signals

  always @(BnRES or BCLK or NextState)
  begin
    if ((!BnRES))
      DSelEn = 1'b0;
    else if ((BCLK))
      if (NextState == `ST_SLAVE)
        DSelEn = 1'b1;
      else
        DSelEn = 1'b0;
  end
 
// -----------------------------------------------------------------------------
//  Slave response tristate enable generation
// -----------------------------------------------------------------------------
//  Sets output enable to drive slave response signals when no slaves selected

  assign BWELEn = (~ DSelEn) & (~ BCLK);

// -----------------------------------------------------------------------------
//  DSELx output port drivers
// -----------------------------------------------------------------------------
//  Output DSELx ports only driven when DSELx enable (DSelEn) is set high

  assign DSELIntMem = (DSELIntMemInt & DSelEn);
  assign DSELExtMem = (DSELExtMemInt & DSelEn);
  assign DSELARMTest = (DSELARMTestInt & DSelEn);
  assign DSELPeri = (DSELPeriInt & DSelEn);

// -----------------------------------------------------------------------------
//  Tristate slave response output drivers
// -----------------------------------------------------------------------------
//  Tristate outputs for slave response signals

  always @(BWELEn or BWAITInt or BERRORInt)
  begin
    if ((BWELEn))
    begin
      TRIbwait = BWAITInt;
      TRIblast = 1'b0;
      TRIberror = BERRORInt;
    end
    else
    begin
      TRIbwait = 1'bz;
      TRIblast = 1'bz;
      TRIberror = 1'bz;
    end
  end
 
endmodule

// --================================ End ====================================--
