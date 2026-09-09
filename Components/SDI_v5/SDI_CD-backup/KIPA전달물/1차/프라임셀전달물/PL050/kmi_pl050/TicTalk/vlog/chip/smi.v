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
//  File Name           : smi.v,v
//  File Revision       : 1.1
//  
//  Release Information : PL050-REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Synthesizable demonstration of an AMBA static memory
//                        interface with configurable wait states (at least 1
//                        write wait and up to four read or write waits).
//  --========================================================================--

`timescale 1ns/1ps

module smi (BCLK, BnRES, BA, BWRITE, BSIZE, DSELExtMem, Remap, BD, BWAIT,
            BERROR, BLAST, TestMode, Ticinen, Ticouten, TicoutLen, XWAIT,
            XnGBE, XD, XA, XCLK, XCSN, XOEN, XWEN);

 
  input         BCLK;
  input         BnRES;
  input  [30:0] BA;
  input         BWRITE;
  input   [1:0] BSIZE;
  input         DSELExtMem;
  input         Remap;       // Reset memory map in use
  inout  [31:0] BD;
  output        BWAIT;
  output        BERROR;
  output        BLAST;

  input         TestMode;    // Overide normal operation
  input         Ticinen;     // Drive in write data
  input         Ticouten;    // Latch read data
  input         TicoutLen;   // Drive out read data

  input         XWAIT;       // External wait request
  input         XnGBE;       // External global bus enable
  inout  [31:0] XD;          // External data bus
  output [30:0] XA;          // External address bus
  output        XCLK;        // External clock out
  output  [7:0] XCSN;        // External chip select
  output        XOEN;        // External output enable
  output  [3:0] XWEN;        // External write enable

// -----------------------------------------------------------------------------
//  Constant declarations
// -----------------------------------------------------------------------------
//  Used to set the number of wait states that are inserted for reads and writes

  `define READWAIT  2'b00    // Range 0-3
  `define WRITEWAIT 2'b01    // Range 1-3
  `define ZERO      2'b00

  `define NONE      4'b1111
  `define WORD      4'b0000
  `define HALF1     4'b0011
  `define HALF0     4'b1100
  `define BYTE3     4'b0111
  `define BYTE2     4'b1011
  `define BYTE1     4'b1101
  `define BYTE0     4'b1110
  `define XWENX     4'bxxxx
 
  `define size_word 2'b10
  `define size_half 2'b01
  `define size_byte 2'b00

// -----------------------------------------------------------------------------
//  Signal declarations
// -----------------------------------------------------------------------------
  wire [1:0] NextWait;    // Wait counter
  wire       iBWAIT;      // Internal wait signal
  wire       StartNext;   // Latch input
  wire       XDIntEn;     // Data latch enable
  wire       iXOEN;       // Output enable
  wire       XWENEn;      // Enable XWEN gen
  wire       XDEn;        // Data out enable
  wire       BDEn;        // BD drive enable
  wire       BWELEn;      // Slave response enable
  wire [3:0] XWENNext;    // XWEN next value
 
  reg        BWRITEReg;   // Registered BWRITE
  reg        DSELReg;     // Clock enable
  reg  [1:0] BSIZELat;    // Latched BSIZE
  reg  [1:0] CurrentWait; // Wait counter
  reg        Start;       // Phase delayed
  reg [30:0] iXA;         // Registered BA
  reg [31:0] XDInt;       // Data out latch
  reg  [7:0] XCSN;
  reg  [3:0] XWEN;
  reg        BLAST;
  reg        BERROR;
  reg        BWAIT;
 
// -----------------------------------------------------------------------------
//  Beginning of main code
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Registered input signals
// -----------------------------------------------------------------------------
//  Registered versions of input signals used in the system

  always @( negedge (BCLK) or negedge (BnRES) )
  begin
    if (!BnRES)
      BWRITEReg <= 1'b0;
    else
      BWRITEReg <= BWRITE;
  end
 
  always @( negedge (BCLK) or negedge (BnRES) )
  begin
    if (!BnRES)
      DSELReg <= 1'b0;
    else
      DSELReg <= DSELExtMem;
  end
 
  always @(BCLK or BnRES or BSIZE)
  begin
    if (!BnRES)
      BSIZELat = {2{ 1'b0 }};
    else if (!BCLK)
      BSIZELat = BSIZE;
  end
 
// -----------------------------------------------------------------------------
//  Wait state counter
// -----------------------------------------------------------------------------
//  Generates count signal depending on the values set in the constants
//  READWAIT and WRITEWAIT, which are decremented
//  Wait states are inserted until CurrentWait = 0

  assign NextWait = (Start == 1'b0 && DSELExtMem == 1'b1 && BWRITE == 1'b0 ?
        `READWAIT : (Start == 1'b0 && DSELExtMem == 1'b1 && BWRITE == 1'b1 ?
        `WRITEWAIT : (CurrentWait == `ZERO ? `ZERO : CurrentWait - 1'b1)));

  always @( negedge (BnRES) or negedge (BCLK) )
  begin
    if (!BnRES)
      CurrentWait <= `ZERO;
    else
      CurrentWait <= NextWait;
  end
 
// -----------------------------------------------------------------------------
//  Start generation
// -----------------------------------------------------------------------------
//  Start is high during start of transfer while waiting
//  Used in the generation of NextWait, XWENEn, and BDEn
//  iBWAIT is used to generate BWAIT output as well as StartNext

  assign iBWAIT = (CurrentWait == `ZERO ? XWAIT : 1'b1);

  assign StartNext = DSELExtMem & iBWAIT;

  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      Start <= 1'b0;
    else
      Start <= StartNext;
  end
 
// -----------------------------------------------------------------------------
//  iXA generation
// -----------------------------------------------------------------------------
//  A latched version of BA is needed to generate the correct timing for XA
//  A latch is used to allow BA to arrive after the falling edge of the clock
//  If it can be GUARANTEED that BA will ALWAYS arrive before this edge, then
//  an array of falling edge triggered DFFs can be used instead

  always @(BCLK or BnRES or BA)
  begin
    if (!BnRES)
      iXA = {31{ 1'b0 }};
    else if (!BCLK)
      iXA = BA;
  end
 
// -----------------------------------------------------------------------------
//  XWENNext generation
// -----------------------------------------------------------------------------
//  Memory write enable generated from latched BSIZE and address

  assign XWENEn = DSELReg & BWRITEReg & StartNext;

  assign XWENNext = (XWENEn == 1'b1 && BSIZELat == `size_word ?
       `WORD : (XWENEn == 1'b1 && BSIZELat == `size_half && iXA[1] == 1'b1 ?
       `HALF1 : (XWENEn == 1'b1 && BSIZELat == `size_half && iXA[1] == 1'b0 ?
       `HALF0 : (XWENEn == 1'b1 && BSIZELat == `size_byte && iXA[1:0] == 2'b11 ?
       `BYTE3 : (XWENEn == 1'b1 && BSIZELat == `size_byte && iXA[1:0] == 2'b10 ?
       `BYTE2 : (XWENEn == 1'b1 && BSIZELat == `size_byte && iXA[1:0] == 2'b01 ?
       `BYTE1 : (XWENEn == 1'b1 && BSIZELat == `size_byte && iXA[1:0] == 2'b00 ?
       `BYTE0 : (XWENEn == 1'b1 ? `XWENX : `NONE))))))));

// -----------------------------------------------------------------------------
//  XDInt generation
// -----------------------------------------------------------------------------
//  Latched BD for memory writes and waits (XDInt)

  assign XDIntEn =
                 BCLK & ((DSELReg & (iBWAIT | (~ BWRITEReg))) | (~ TicoutLen));

  always @(XDIntEn or BD or BnRES)
  begin
    if (!BnRES)
      XDInt = {32{ 1'b0 }};
    else if (XDIntEn)
      XDInt = BD;
  end
 
// -----------------------------------------------------------------------------
//  iXOEN generation
// -----------------------------------------------------------------------------
//  Output enable generated during reads from memory

  assign iXOEN = ~ (DSELReg & (~ BWRITEReg));

// -----------------------------------------------------------------------------
//  Output enables
// -----------------------------------------------------------------------------
//  Output enable signals used to enable the output ports to be driven

  assign XDEn = (((iXOEN & ~ TestMode) | (~ Ticouten)) & (~ XnGBE));

  assign BDEn = ((BCLK & DSELReg) & (~ Start) & (~ StartNext) & (~ BWRITEReg)) |
                (~ Ticinen);

  assign BWELEn = DSELExtMem & (~ BCLK) & BnRES;

// -----------------------------------------------------------------------------
//  External bus output port drivers
// -----------------------------------------------------------------------------
//  Drive the output ports with the internally generated values

  assign XCLK = BCLK;

  assign XOEN = iXOEN;

//  Decodes the chip enable signals from the current address when external
//  memory is selected

  always @(BnRES or DSELReg or Remap or iXA)
  begin
    if (!BnRES)
      XCSN = 8'b11111111;
    else if ((DSELReg && !Remap))
      XCSN = 8'b01111111;
    else if ((DSELReg))
      case (iXA[30:28])
        3'b000 :
          XCSN = 8'b11111110; // 0x00000000
        3'b001 :
          XCSN = 8'b11111101; // 0x10000000
        3'b010 :
          XCSN = 8'b11111011; // 0x20000000
        3'b011 :
          XCSN = 8'b11110111; // 0x30000000
        3'b100 :
          XCSN = 8'b11101111; // 0x40000000
        3'b101 :
          XCSN = 8'b11011111; // 0x50000000
        3'b110 :
          XCSN = 8'b10111111; // 0x60000000
        3'b111 :
          XCSN = 8'b01111111; // 0x70000000
        default  :
          XCSN = 8'b11111111;
      endcase
    else
      XCSN = 8'b11111111;
  end
 
  always @( negedge (BnRES) or posedge (BCLK) )
  begin
    if (!BnRES)
      XWEN <= `NONE;
    else
      XWEN <= XWENNext;
  end
 
// -----------------------------------------------------------------------------
//  Tristate output drivers
// -----------------------------------------------------------------------------
//  Tristate outputs for BD, slave response signals, XA and XD

  assign BD = (BDEn == 1'b1 ? XD : 32'hzzzz_zzzz);

  always @(BWELEn or iBWAIT)
  begin
    if (BWELEn)
    begin
      BWAIT = iBWAIT;
      BERROR = 1'b0;
      BLAST = 1'b0;
    end
    else
    begin
      BWAIT = 1'bz;
      BERROR = 1'bz;
      BLAST = 1'bz;
    end
  end
 
  assign XA = ((~ XnGBE) == 1'b1 ? iXA : 31'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz);

  assign XD = (XDEn == 1'b1 ? XDInt : 32'hzzzz_zzzz);

endmodule

//  --================================ End ===================================--
