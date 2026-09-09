// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdCPGen.v.rca
//  File Revision          : 1.3
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : This module generates the clock(LcdCP) for the LCD
//                           panel The clock generated is exactly the divisor 
//                           given, according to the formula:
//
//                           LcdCP = CLCDCLK / (PCD + 2)
//
// --=========================================================================--

`timescale 1ns/1ps
// -----------------------------------------------------------------------------

module ClcdCPGen( 
                 CLCDCLK,
                 nCLCDCLK,
                 nCLCLKRESET,
                 PCD,
                 NullPC,
                 PCEn,
                  
                 LcdCP,               
                 NextRising
                );

input             CLCDCLK;     // clock input
input             nCLCDCLK;    // Inverted clock input
input             nCLCLKRESET; //system reset
input [9:0]       PCD;         // clock divide ratio (0= /2, 1= /3 etc) from CPU
input             NullPC;      // Enable for panel clock
input             PCEn;        // clock divider stop & start

output            LcdCP;       // Clock to LCD (exact divide)
output            NextRising;  // rising edge on next clock to timing module

// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module consists of a 4-state state machine and a counter.
//
// -  Odd divisors are created by delaying the clock internally by half a clock
//    and then ORing the two together to produce LcdCP.
//
// -  There is a negative edge flip-flop in the design and LcdCP is the
//       output of a positive and negative edge flip-flop ORed together.
//
// -  The NextRising signal is produced in the last CLCDCLK cycle of LcdCP
//    to indicate that LcdCP will be high on the next cycle.
//
// -  If the PCPCEn signal turns off the clock, the full current output LcdCP 
//    cycle is completed first.
//
//-----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Statemachine states
// -----------------------------------------------------------------------------
 
`define ST_IDLE  2'b00
`define ST_LOW   2'b01
`define ST_HIGH  2'b10
`define ST_EXTRA 2'b11

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire              CLCDCLK;       
// clock input                                                  (Module input)

wire              nCLCDCLK;       
// clock input                                                  (Module input)

wire              nCLCLKRESET;    
//system reset                                                  (Module input)

wire              NullPC;     
// count CLCDCLKs, produce NextRising but not LcdCP             (Module input)

wire              PCEn;       
// clock divider stop & start                                   (Module input)

wire  [9:0]       PCD;        
// clock divide ratio (0= /2, 1= /3 etc) from CPU               (Module input)

wire              LcdCP;
// Panel clock output                                           (Module output)


// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         NextRising;
// Indicates LcdCP is going HIGH on the next rising edge 
// of CLCDCLK                                                   (Module output)

reg         LoadCount;
// Load Panel clock divider value(PCD) in to the counter

reg         DecCount;
// counter decrement enable. counter is decremented on each CLCDCLK.

reg  [8:0]  CDCount;
// register for counter

reg  [8:0]  NextCDCount;
// D-input of counter register

reg  [1:0]  NextState;
// D-input of state register

reg  [1:0]  State;
// Register for state machine 

reg         NextLcdCP;
// Lcd panel clock : State machine output

reg         LcdCPInt1;
// Lcd panel clock internal version

reg         LcdCPInt;
// Lcd panel clock internal version

reg         LcdCPInt2;
// Lcd panel clock internal version

reg         NextLcdCPInt2;
// D-input of LcdCPInt2

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Combinational process for Clock divider counter
// When Load Count is issued, the counter is loaded with the PCD value.
// the counter is decremented when DecCount signal is issued
// ----------------------------------------------------------------------------
always @(PCD or LoadCount or DecCount or CDCount )
begin : p_PCDComb
  if (LoadCount == 1'b1)
    NextCDCount[8:0] = PCD[9:1];
  else
    if (DecCount == 1'b1)
      NextCDCount[8:0] = CDCount - 9'b000000001;
    else
      NextCDCount[8:0] = CDCount[8:0];
end // p_PCDComb

// -----------------------------------------------------------------------------
// Sequential process for Clock divider counter
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_PCDSeq
  if (nCLCLKRESET == 1'b0)
   CDCount <= 9'b000000000;
  else
   CDCount <= NextCDCount;
end // p_PCDSeq

// -----------------------------------------------------------------------------
//#
//# State machine to control counting.
//# goes between low and high as the counter reaches zero
//# and inserts one extra low CLCDCLK cycle for odd divisors.
//#
// -----------------------------------------------------------------------------
always @(CDCount or PCEn or State or PCD or NullPC )
begin : p_PCStateComb
  LoadCount  = 1'b0;
  DecCount   = 1'b0;
  NextState  = `ST_IDLE;
  NextRising = 1'b0;
  NextLcdCP  = 1'b0;
    
  case(State[1:0])
    `ST_IDLE:
      begin
// -----------------------------------------------------------------------------
// if PCEn signal is HIGH: assert LoadCount and if NullPC is zero assert HIGH 
// phase of LcdCP and go to ST_HIGH state.
// -----------------------------------------------------------------------------
          if (PCEn == 1'b1)
            begin
              NextState = `ST_HIGH;
              LoadCount = 1'b1;
              if (NullPC == 1'b0)
                NextLcdCP = 1'b1;
            end // if (PCEn == 1'b1)
      end // case: `ST_IDLE

    `ST_LOW :
      begin
        NextState = `ST_LOW;
        DecCount = 1'b1;
// -----------------------------------------------------------------------------
// when counter expires check if PCD value is odd. if it is odd go to state
// ST_EXTRA to insert one extra clock period. Else assert NextRising signal and
// if PCEn is HIGH: load PCD value in to the counter,enable HIGH phase of LcdCP 
// and go to the ST_HIGH state
// -----------------------------------------------------------------------------
          if (CDCount == 9'b000000000)
            begin
              if (PCD[0] == 1'b1)
                NextState = `ST_EXTRA;
              else
                begin
                  NextRising = 1'b1;
                  if (PCEn == 1'b1)
                    begin
                      NextState = `ST_HIGH;
                      LoadCount = 1'b1;
                      if (NullPC == 1'b0)
                        begin
                          NextLcdCP = 1'b1;
                        end // if (NullPC == 1'b0)
                    end // if (PCEn == 1'b1)
                  else
                    begin
// -----------------------------------------------------------------------------
// if PCEn is LOW go to ST_IDLE state
// -----------------------------------------------------------------------------
                      NextState = `ST_IDLE;
                      NextLcdCP = 1'b0;
                    end
                end // else: !if(PCD[0] == 1'b1)
            end // if (CDCount == 9'b000000000)
      end // case: `ST_LOW
        
    `ST_HIGH :
      begin
        NextState = `ST_HIGH;
        DecCount = 1'b1;
// -----------------------------------------------------------------------------
// if NullPC is LOW indicating that the panel clock has to be passed on to the 
// LCD panel, assert HIGH phase of LcdCP
// -----------------------------------------------------------------------------
        if (NullPC == 1'b0)
          NextLcdCP = 1'b1;
// -----------------------------------------------------------------------------
// if the counter expires, assert the low phase of the LcdCP, assert LoadCount
// to load the PCD value and go to the ST_LOW state
// -----------------------------------------------------------------------------
        if (CDCount == 9'b000000000)
          begin
            NextState = `ST_LOW;
            NextLcdCP = 1'b0;
            LoadCount = 1'b1;
          end // if (CDCount == 9'b000000000)
      end // case: `ST_HIGH

    `ST_EXTRA :
      begin
// -----------------------------------------------------------------------------
// if NullPC is LOW indicating that the panel clock has to be passed on to the
// LCD panel, assert HIGH phase of LcdCP
// -----------------------------------------------------------------------------
        if (NullPC == 1'b0)
          NextLcdCP  = 1'b1;
          NextRising = 1'b1;
// -----------------------------------------------------------------------------
// if PCEn signal is HIGH: assert LoadCount and if NullPC is zero assert HIGH
// phase of LcdCP and go to ST_HIGH state.
// -----------------------------------------------------------------------------
          if (PCEn == 1'b1)
            begin
              LoadCount = 1'b1;
              NextState = `ST_HIGH;
            end
          else
            begin
// -----------------------------------------------------------------------------
// if PCEn is LOW go to ST_IDLE state
// -----------------------------------------------------------------------------
              NextState = `ST_IDLE;
              NextLcdCP = 1'b0;
            end
      end // case: `ST_EXTRA
    

     default :
       begin
          NextState = `ST_IDLE;
        end

  endcase // case(State[1:0])
end // p_PCStateComb

// -----------------------------------------------------------------------------
// Sequential process for state transition and LcdCP signal
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_PCStateSeq 
  if (nCLCLKRESET == 1'b0)
    begin
      State     <= 2'b00;
      LcdCPInt  <= 1'b0;
      LcdCPInt1 <= 1'b0;
    end
  else
    begin
      State     <= NextState;
      LcdCPInt  <= NextLcdCP;
      LcdCPInt1 <= LcdCPInt;
    end
end // p_PCStateSeq

// -----------------------------------------------------------------------------
// Half clock delayed Lcd CP. this is required for 50% duty cycle 
// adjustment of LcdCP when the PCD value is odd.
// -----------------------------------------------------------------------------
always @ (PCD or LcdCPInt2 or LcdCPInt1)
begin : p_LcdCPComb
  NextLcdCPInt2 = LcdCPInt2;
  if (PCD[0] == 1'b1)
    NextLcdCPInt2 = LcdCPInt1;
end // p_LcdCPComb

// -----------------------------------------------------------------------------
// Sequential process for LcdCPInt2
// -----------------------------------------------------------------------------
always @(posedge nCLCDCLK or negedge nCLCLKRESET)
begin : p_LcdCPSeq
  if (nCLCLKRESET == 1'b0)
    LcdCPInt2 <= 1'b0;
  else
    LcdCPInt2 <= NextLcdCPInt2;
end // p_LcdCPSeq

// -----------------------------------------------------------------------------
// the final LcdCP goes out to the panel is the logical OR of LcdCPInt1  and 
// LcdCPInt2.
// -----------------------------------------------------------------------------
assign LcdCP = LcdCPInt1 | LcdCPInt2;

endmodule

// --================================== End ==================================
