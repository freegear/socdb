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
// File Name              : ResCntl.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
//
// ---------------------------------------------------------------------
// Purpose :
//           Reset state machine
//
// --=================================================================--

`timescale 1ns/1ps

module ResCntl (HCLK, POReset, HRESETn);

  input  HCLK;
  input  POReset; // Power on reset input
  output HRESETn;

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
// State definitions - avoids any chance of glitches on HRESETn
// The two INI states are used to insert a delay of three cycles
// between the de-assertion of POReset and the de-assertion of HRESETn.
// If additional cycles are required then extra INI states may be
// added, ensuring that the encoding is such that HRESETn is dependant
// on only one bit of the state machine.
  `define ST_POR  3'b000
  `define ST_INI1 3'b010
  `define ST_INI2 3'b100
  `define ST_RUN  3'b001

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
  reg       SyncPOR;      // Synchronised POReset signal
  reg [2:0] NextState;    // State machine
  reg [2:0] CurrentState;

// ---------------------------------------------------------------------
// Beginning of main code
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Asynchronous reset input synchronisation
// ---------------------------------------------------------------------
// Synchronises POReset input to system clock

  always @( posedge (HCLK) )
  begin
    SyncPOR <= POReset;
  end

// ---------------------------------------------------------------------
// Next state logic for reset controller state machine
// ---------------------------------------------------------------------
// If a clock OK signal is used at start-up to indicate when the clock
// is stable, then this signal should be used as a qualifier to
// determine when the POR state is exited, for example,
// "if (ClockOK = '1') then state = INI else state = POR;"

  always @(SyncPOR or CurrentState)
  begin
    if (!SyncPOR)
      NextState = `ST_POR;
    else
      case (CurrentState)

        `ST_POR  :              // POReset input set
          NextState = `ST_INI1;

        `ST_INI1 :              // First wait state
          NextState = `ST_INI2;

        `ST_INI2 :              // Second wait state
          NextState = `ST_RUN;

        `ST_RUN  :              // HRESETn output set
          NextState = `ST_RUN;

        default  :
          NextState = `ST_POR;

      endcase
  end

// ---------------------------------------------------------------------
// State machine
// ---------------------------------------------------------------------
// No reset term as NextState is reset to ST_POR
// Changes state on rising edge of HCLK

  always @( posedge (HCLK) )
  begin
    CurrentState <= NextState;
  end

// ---------------------------------------------------------------------
// Output driver
// ---------------------------------------------------------------------
// HRESETn is driven with bit 0 of CurrentState (only set high during
// ST_RUN), and the inverse of the active HIGH POReset input, allowing
// HRESETn to be set as soon as POReset is set HIGH.

// Delay added to prevent netlist simulation errors
  assign #2 HRESETn = CurrentState[0] & POReset;

endmodule

// --============================== End ==============================--
