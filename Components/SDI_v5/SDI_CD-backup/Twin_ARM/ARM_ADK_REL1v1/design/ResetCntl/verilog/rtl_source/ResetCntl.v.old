// --===============================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1998-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : ResetCntl.v,v
// File Revision       : 1.5
// 
// Release Information : ADK_REL1v1
// 
// -------------------------------------------------------------------
// Purpose             : Reset state machine
// --===============================================================--

`timescale 1ns/1ps

module ResetCntl (HCLK, nPOReset, WDOGRES, HRESETn, WDOGRESn);
 
  input  HCLK;     // Common AHB clock
  input  nPOReset; // Power on reset input
  input  WDOGRES;  // Watchdog reset input
  output HRESETn;  // AHB system reset
  output WDOGRESn; // Watchdog reset

//----------------------------------------------------------------------
//
//                       Reset Controller
//                       ================
//
//----------------------------------------------------------------------
//
// Overview
// ========
//
// The Reset Controller provides the AHB system with a reset signal 
//  when initiated by the external Power-On Reset or Watchdog reset 
//  request signals. The module also provides a dedicated reset output
//  for the Watchdog, initiated only when Power-On Reset signal is 
//  active.
//
// Assertion (the falling edge) of HRESETn and WDOGRESn is asynchronous
//  to HCLK. De-assertion (the rising edge) of HRESETn and WDOGRESn is
//  synchronous to the rising edge of HCLK. The outputs of the Reset
//  Controller are asserted for a minimum duration of 3 clock cycles.

 
//--------------------------------------------------------------------
// Constant declarations
//--------------------------------------------------------------------
// State definitions - avoids any chance of glitches on HRESETn
// The two INI states are used to insert a delay of three cycles between
//  the de-assertion of nPOReset and the de-assertion of HRESETn. If 
//  additional cycles are required then extra INI states may be added, 
//  ensuring that the encoding is such that HRESETn is dependant on only
//  one bit of the state machine.
  `define STRC_POR  3'b000
  `define STRC_INI1 3'b010
  `define STRC_INI2 3'b100
  `define STRC_RUN  3'b001
 
//--------------------------------------------------------------------
// Signal declarations
//--------------------------------------------------------------------

// Input/Output Signals
  wire  HCLK;     
  wire  nPOReset; 
  wire  WDOGRES;  
  wire  HRESETn;  
  wire  WDOGRESn; 

// Internal Signals
  reg       nSyncPOR;     // Synchronised nPOReset signal
  reg       SyncWDR;      // Synchronised WDOGRES signal
  reg [2:0] NextHrState;  // FSM for HRESETn
  reg [2:0] HresState;
  reg [2:0] NextWdState;  // FSM for WDOGRESn
  reg [2:0] WresState;

//--------------------------------------------------------------------
// Beginning of main code
//--------------------------------------------------------------------

//--------------------------------------------------------------------
// Asynchronous reset input synchronisation
//--------------------------------------------------------------------
// Synchronises nPOReset input to system clock

  always @( posedge (HCLK) )
  begin : p_SynchPORSeq
    nSyncPOR <= nPOReset;
  end
 
// Synchronises WDOGRES input to system clock

  always @( posedge (HCLK) )
  begin : p_SynchWDRSeq
    SyncWDR <= WDOGRES;
  end
 
//--------------------------------------------------------------------
// Next state logic for reset controller state machines
//--------------------------------------------------------------------
// If a clock OK signal is used at start-up to indicate when the 
//  clock is stable, then this signal should be used as a qualifier 
//  to determine when the POR state is exited, for example:
//  "if (ClockOK = '1') then state = INI else state = POR;"

  // State machine to hold HRESETn for the required number of clock
  // cycles
  always @(nSyncPOR or SyncWDR or HresState)
  begin : p_NextHrStateComb
    if ((!nSyncPOR) | SyncWDR)
      NextHrState = `STRC_POR;
    else
      case (HresState)

        `STRC_POR  :                // nPOReset input asserted
          NextHrState = `STRC_INI1;

        `STRC_INI1 :                // First wait state
          NextHrState = `STRC_INI2;

        `STRC_INI2 :                // Second wait state
          NextHrState = `STRC_RUN;

        `STRC_RUN  :                // HRESETn output de-asserted
          NextHrState = `STRC_RUN;

        default  :
          NextHrState = `STRC_POR;

      endcase
  end
 
  // State machine to hold WDOGRESn for the required number of clock
  // cycles
  always @(nSyncPOR or WresState)
  begin : p_NextWdStateComb
    if (!nSyncPOR)
      NextWdState = `STRC_POR;
    else
      case (WresState)

        `STRC_POR  :                // nPOReset input asserted
          NextWdState = `STRC_INI1;

        `STRC_INI1 :                // First wait state
          NextWdState = `STRC_INI2;

        `STRC_INI2 :                // Second wait state
          NextWdState = `STRC_RUN;

        `STRC_RUN  :                // WDOGRESn output de-asserted
          NextWdState = `STRC_RUN;

        default  :
          NextWdState = `STRC_POR;

      endcase
  end
 
//--------------------------------------------------------------------
// State machines for HRESETn and WDOGRESn
//--------------------------------------------------------------------
// No reset term as NextHrState is reset to STRC_POR
// Changes state on rising edge of HCLK

  always @( posedge (HCLK) )
  begin : p_HresStateSeq
    HresState <= NextHrState;
  end
 
  always @( posedge (HCLK) )
  begin : p_WresStateSeq
    WresState <= NextWdState;
  end
 
//--------------------------------------------------------------------
// Output drivers
//--------------------------------------------------------------------
// HRESETn is driven with bit 0 of HresState (only set high during 
//  STRC_RUN), and the active-low nPOReset input, allowing HRESETn to
//  be set as soon as nPOReset becomes active. 

  assign HRESETn = HresState[0] & nPOReset;

// WDOGRESn is fed only from the power-on reset signal, allowing
// state information within the Watchdog to persist across a
// soft-reset event

  assign WDOGRESn = WresState[0] & nPOReset;


endmodule

// --============================ End ==============================--
