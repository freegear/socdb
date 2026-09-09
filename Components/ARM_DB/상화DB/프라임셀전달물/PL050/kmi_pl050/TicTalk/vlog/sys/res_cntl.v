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
//  File Name           : res_cntl.v,v
//  File Revision       : 1.1
//  
//  Release Information : PL050-REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Reset state machine
//  --========================================================================--

`timescale 1ns/1ps

module res_cntl (BCLK, POReset, BnRES);
 
  input  BCLK;
  input  POReset; // Power on reset input
  output BnRES;

// -----------------------------------------------------------------------------
//  Constant declarations
// -----------------------------------------------------------------------------
//  State definitions - avoids any chance of glitches on BnRES
  `define ST_POR 2'b00
  `define ST_INI 2'b10
  `define ST_RUN 2'b11
 
// -----------------------------------------------------------------------------
//  Signal declarations
// -----------------------------------------------------------------------------
  wire      ResCountNext; // ResCount mux value
 
  reg       SyncPOR;      // Synchronised POReset signal

  reg [1:0] NextState;    // State machine
  reg [1:0] CurrentState;

  reg       ResCount;     // Used to create delay of 2 cycles
 
  reg       BnRES;
// -----------------------------------------------------------------------------
//  Beginning of main code
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Asynchronous input reset synchronisation
// -----------------------------------------------------------------------------
//  Synchronises POReset input to system clock

  always @( negedge (BCLK) )
  begin
      SyncPOR <= POReset;
  end
 
// -----------------------------------------------------------------------------
//  Next state logic for reset controller state machine
// -----------------------------------------------------------------------------
//  If a clock OK signal is used at start-up to indicate when the clock
//  is stable, then this signal should be used as a qualifier to determine
//  when the POR state is exited, for example,
//  "if (ClockOK = '1') then state = INI else state = POR;"

  always @(SyncPOR or CurrentState or ResCount)
  begin
    if (SyncPOR)
      NextState = `ST_POR;
    else
      case (CurrentState)
        `ST_POR :               // POReset input set
          NextState = `ST_INI;
        `ST_INI :               // Pause between POReset and BnRES
          if ((ResCount))
            NextState = `ST_RUN;
          else
            NextState = `ST_INI;
        `ST_RUN :               // BnRES output set
          NextState = `ST_RUN;
        default  :
          NextState = `ST_POR;
      endcase
  end
 
// -----------------------------------------------------------------------------
//  State machine
// -----------------------------------------------------------------------------
//  No reset term as NextState is reset to ST_POR
//  Changes state on falling edge of BCLK

  always @( negedge (BCLK) )
  begin
      CurrentState <= NextState;
  end
 
// -----------------------------------------------------------------------------
//  ResCount register
// -----------------------------------------------------------------------------
//  Used to hold the state machine in the ST_INI state for two cycles
//  Can be altered to increase the number of cycles

  assign ResCountNext =
                  (CurrentState == `ST_INI && ResCount == 1'b0 ? 1'b1 : 1'b0);

  always @( posedge (SyncPOR) or negedge (BCLK) )
  begin
    if (SyncPOR)
      ResCount <= 1'b0;
    else
      ResCount <= ResCountNext;
  end
 
// -----------------------------------------------------------------------------
//  Output driver
// -----------------------------------------------------------------------------
// BnRES is driven with bit 0 of CurrentState (only set high during ST_RUN),
// and the inverse of the active HIGH POReset input, allowing BnRES to be set
// as soon as POReset is set HIGH.

// assign BnRES = CurrentState[0] & (~ POReset);
  
  always @ (CurrentState[0] or POReset)
  begin
   if ((CurrentState[0] == 1'b1) && (POReset == 1'b0))
     BnRES <= 1'b1;
   else
     #2 BnRES <= 1'b0; // delay added to create a falling edge at the 
                       // start of simulation.
  end 

  initial
    BnRES <= 1'b1; // added to prevent the BnRES line from going to 'x' at
                   // the start of simulation.

endmodule

//  --================================ End ===================================--
