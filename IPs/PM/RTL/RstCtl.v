
// -------------------------------------------------------------------
// Purpose             : Reset state machine
// --===============================================================--

`timescale 1ns/1ps

module RstCtl (
  				ACLK,
  				TestMode,
  				PocResetb,
  				nPOReset, 
  				WDOGRES , 
  				ARESETn , 
  				WDOGRESn
);
 
  input  ACLK;     // Common AHB clock
  input  TestMode;
  input	 PocResetb;
  input  nPOReset; // Power on reset input
  input  WDOGRES;  // Watchdog reset input
  output ARESETn;  // AHB system reset
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
// Assertion (the falling edge) of ARESETn and WDOGRESn is asynchronous
//  to ACLK. De-assertion (the rising edge) of ARESETn and WDOGRESn is
//  synchronous to the rising edge of ACLK. The outputs of the Reset
//  Controller are asserted for a minimum duration of 3 clock cycles.

 
//--------------------------------------------------------------------
// Constant declarations
//--------------------------------------------------------------------
// State definitions - avoids any chance of glitches on ARESETn
// The two INI states are used to insert a delay of three cycles between
//  the de-assertion of nPOReset and the de-assertion of ARESETn. If 
//  additional cycles are required then extra INI states may be added, 
//  ensuring that the encoding is such that ARESETn is dependant on only
//  one bit of the state machine.
  `define STRC_POR  3'b000
  `define STRC_INI1 3'b010 
  `define STRC_INI2 3'b100
  `define STRC_RUN  3'b001
 
//--------------------------------------------------------------------
// Signal declarations
//--------------------------------------------------------------------

// Input/Output Signals
  wire  ACLK;     
  wire  nPOReset; 
  wire  WDOGRES;  
  wire  ARESETn;  
  wire  WDOGRESn; 

// Internal Signals
  reg       nSyncPOR;     // Synchronised nPOReset signal
  reg       SyncWDR;      // Synchronised WDOGRES signal
  reg [2:0] NextHrState;  // FSM for ARESETn
  reg [2:0] AresState;
  reg [2:0] NextWdState;  // FSM for WDOGRESn
  reg [2:0] WresState;

//--------------------------------------------------------------------
// Beginning of main code
//--------------------------------------------------------------------

//--------------------------------------------------------------------
// Asynchronous reset input synchronisation
//--------------------------------------------------------------------
// Synchronises nPOReset input to system clock
// DFT :Reset High Tie
//====================================================================
//        ______
//       |      |
//       |      |
// CLK---|>     |
//       |______|
//          O
//    VDD___| 
//====================================================================
wire    TieHig  ;
assign  TieHig  = 1'b1 ;

//always @( posedge (ACLK))
always @( posedge (ACLK) or negedge TieHig)
begin : p_SynchPORSeq
    if ((!TieHig)) nSyncPOR <= 1'b0 ;
    else           nSyncPOR <= nPOReset & PocResetb;
end
 
// Synchronises WDOGRES input to system clock

 // always @( posedge (ACLK) )
always @( posedge (ACLK) or negedge TieHig)
begin : p_SynchWDRSeq
    if ((!TieHig)) SyncWDR <= 1'b0 ;
    else           SyncWDR <= WDOGRES;
end
//--------------------------------------------------------------------
// Next state logic for reset controller state machines
//--------------------------------------------------------------------
// If a clock OK signal is used at start-up to indicate when the 
//  clock is stable, then this signal should be used as a qualifier 
//  to determine when the POR state is exited, for example:
//  "if (ClockOK = '1') then state = INI else state = POR;"

  // State machine to hold ARESETn for the required number of clock
  // cycles
  always @(nSyncPOR or SyncWDR or AresState)
  begin : p_NextHrStateComb
    if ((!nSyncPOR) | SyncWDR)
      NextHrState = `STRC_POR;       //3'b000
    else
      case (AresState)

        `STRC_POR  :                // nPOReset input asserted:3'b000
          NextHrState = `STRC_INI1; //3'b010 

        `STRC_INI1 :                // First wait state:3'b010
          NextHrState = `STRC_INI2; //3'b100

        `STRC_INI2 :                // Second wait state:3'b100
          NextHrState = `STRC_RUN;  //3'b001

        `STRC_RUN  :                // ARESETn output de-asserted:3'b001
          NextHrState = `STRC_RUN;  //3'b001

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
          NextWdState = `STRC_INI1;  //2

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
// State machines for ARESETn and WDOGRESn
//--------------------------------------------------------------------
// No reset term as NextHrState is reset to STRC_POR
// Changes state on rising edge of ACLK

//  always @( posedge (ACLK) )
always @( posedge (ACLK) or negedge TieHig)
  begin : p_AresStateSeq
   if ((!TieHig))
    AresState <= `STRC_POR;
    else
    AresState <= NextHrState;
  end
 
//  always @( posedge (ACLK) )
always @( posedge (ACLK) or negedge TieHig)
  begin : p_WresStateSeq
    if ((!TieHig))
    WresState <= `STRC_POR;
    else
    WresState <= NextWdState;
  end
 
//--------------------------------------------------------------------
// Output drivers
//--------------------------------------------------------------------
// ARESETn is driven with bit 0 of AresState (only set high during 
//  STRC_RUN), and the active-low nPOReset input, allowing ARESETn to
//  be set as soon as nPOReset becomes active. 

  wire ARESETnBuf = TestMode ? nPOReset : AresState[0] & nPOReset;
  BUFX2 SRSTBUF(.A(ARESETnBuf), .Y(ARESETn));
//  assign ARESETn = ARESETnBuf;

// WDOGRESn is fed only from the power-on reset signal, allowing
// state information within the Watchdog to persist across a
// soft-reset event

  wire WDOGRESnBuf = TestMode ? nPOReset : WresState[0] & nPOReset;
  BUFX2 WRSTBUF(.A(WDOGRESnBuf), .Y(WDOGRESn));
//  assign WDOGRESn = WDOGRESnBuf;

//synopsys dc_script_begin
//set_dont_touch {SRSTBUF, WRSTBUF}
//synopsys dc_script_end

endmodule

// --============================ End ==============================--
