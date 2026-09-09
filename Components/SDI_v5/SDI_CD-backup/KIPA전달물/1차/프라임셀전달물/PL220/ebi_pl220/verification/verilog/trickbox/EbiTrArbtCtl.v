// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : EbiTrArbtCtl.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block implements the arbitration and control logic for
//           the Ebi Mirror Trick Box. 
// --=========================================================================--

`timescale 1ns/1ps

module EbiTrArbtCtl (
// Inputs 
                     EBICLK, 
                     nPOR,
                     EBIREQ1,
                     EBIREQ2,
                     EBIREQ3,
                     EBITIMEOUTVALUE1,
                     EBITIMEOUTVALUE2,
                     EBITIMEOUTVALUE3,
// Outputs
                     EbiTrBackoff,
                     EbiTrGnt 
                    );

// Inputs
input         EBICLK;            // External Bus Interface Clock
input         nPOR;              // Power On Rese
input         EBIREQ1;           // EBI request for Port 1,Active high
input         EBIREQ2;           // EBI request for Port 2,Active high
input         EBIREQ3;           // EBI request for Port 3,Active high
input   [9:0] EBITIMEOUTVALUE1;  // Gives the value to be loaded
                                 // into timeout counter for port 1. 
input   [9:0] EBITIMEOUTVALUE2;  // Gives the value to be loaded
                                 // into timeout counter for port 2. 
input   [9:0] EBITIMEOUTVALUE3;  // Gives the value to be loaded
                                 // into timeout counter for port 3. 


// Outputs
output   [2:0] EbiTrBackoff;     // EBIBACKOFF signals
                                 // EbiTrBackoff(0) -- Port 1
                                 // EbiTrBackoff(1) -- Port 2
                                 // EbiTrBackoff(2) -- Port 3
output   [2:0] EbiTrGnt;         // EBI Grant signals
                                 // EbiTrGnt(0) -- Port 1
                                 // EbiTrGnt(1) -- Port 2
                                 // EbiTrGnt(2) -- Port 3




// Inputs
  wire       EBICLK;             // External Bus Interface Clock
  wire       nPOR;               // Power On Reset
  wire       EBIREQ1;            // EBI request for Port 1,Active high
  wire       EBIREQ2;            // EBI request for Port 2,Active high
  wire       EBIREQ3;            // EBI request for Port 3,Active high
  wire [9:0] EBITIMEOUTVALUE1;   // Gives the value to be loaded
                                 // into timeout counter for port 1. 
  wire [9:0] EBITIMEOUTVALUE2;   // Gives the value to be loaded
                                 // into timeout counter for port 2. 
  wire [9:0] EBITIMEOUTVALUE3;   // Gives the value to be loaded
                                 // into timeout counter for port 3. 


// -----------------------------------------------------------------------------
//
//                                EbiTrArbtCtl
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// o Control and Arbitration Block 
//    This is Arbitration Block in Ebi Mirror Trick Box that arbitrates
//    between the requested ports.Each port has a 10 bits counter which 
//    will be loaded with a value from EBITimeOut[9:0] input ever a
//    request is made for the bus.If the signal EBITimeOut[9:0] is zero
//    the counter will not be started for the port.When the 
//    counter reaches zero the port currently granted the bus,will
//    be requested to release the bus by asserting the EBIBackOff signal.
//    The first port counter to reach zero will be given the highest 
//    priority for the bus,followed by the second device.If more than
//    one port issues a request for the bus at the same time a 
//    round robin arbitration scheme will be used to decide which port 
//    should be granted the bus.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define SONE   3'b001  // State 1
`define STWO   3'b010  // State 2
`define STHREE 3'b011  // State 3
`define SFOUR  3'b100  // State 4
`define SFIVE  3'b101  // State 5
`define SSIX   3'b110  // State 6
`define SSEVEN 3'b111  // State 7
`define SEIGHT 3'b000  // State 8

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire [2:0] CState;
// Current state signal

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg [9:0] CounterOne;
// Port 1 Time Out Counter Internal.

reg [9:0] CounterTwo;
// Port 2 Time Out Counter Internal.

reg [9:0] CounterThr;
// Port 3 Time Out Counter Internal.

reg [2:0] EbiTrGnt;
// Grant Signal Output

reg [2:0] EbiTrBackoff;
// Backoff signal Output

//reg [2:0] EbiTrBackoffv;
// Internal copy of Backoff signal

reg       DcrCnt1;
// Signal Indicating the Port 1 Time Out Value has reached zero.

reg       DcrCnt2;
// Signal Indicating the Port 2 Time Out Value has reached zero.

reg       DcrCnt3;
// Signal Indicating the Port 3 Time Out Value has reached zero.

reg [2:0] PTable [1:0];
// Priority Table which is used as reference for selecting a port to be
// granted.Priority Table is has 2 locations each of 3 bits wide.
// The port that is curently granted is written to location 0.
// The port at location 0 is copied to location 1.The priority issue
// is resolved by referencing to this table.

reg       TriSim31;
// Tigger signal indicating simultaneous request form port 1 and port 3

reg       TriSim21;
// Tigger signal indicating simultaneous request form port 2 and port 1

reg       TriSim32;
// Tigger signal indicating simultaneous request form port 3 and port 2

reg [2:0] NState;
// Next State Signal

reg [1:0] BackOffReg;
// This Backoff register contains a port id whose time out counter
// has reached zero first.This helps in generating the grant signal
// when more than one counter reaches time out zero.

reg [1:0] BackOffRegv;
// Internal copy of BackOffReg register

reg       Flag3To1;
// A intenal flag which is used to control the updating of Priority
// table in State 3

reg       Flag3To2;
// A intenal flag which is used to control the updating of Priority
// table in State 3

reg       Flag5To1;
// A intenal flag which is used to control the updating of Priority
// table in State 5

reg       Flag5To4;
// A intenal flag which is used to control the updating of Priority
// table in State 5

reg       Flag6To4;
// A intenal flag which is used to control the updating of Priority
// table in State 6

reg       Flag6To2;
// A intenal flag which is used to control the updating of Priority
// table in State 6

reg       TrigCnt1;
// Trigger for decrementing Internal Time Out Counter for Port 1

reg       TrigCnt2;
// Trigger for decrementing Internal Time Out Counter for Port 1

reg       TrigCnt3;
// Trigger for decrementing Internal Time Out Counter for Port 1

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Main Process 
// Request State Machine 
// -----------------------------------------------------------------------------
//
// This state machine makes states transitions based on the requests from
// Port 1,Port 2 and Port 3.At every positive clock edge the requests
// from all the three ports are sampled and depending upon the requests
// state transitions is made.
//
// -----------------------------------
// Table Showing the State Transitions.
// -----------------------------------
// |--------------|------------|----------|------------|------------------|
// |    State     |  Port3Req  | Port2Req |  Port1Req  |     Comment      |
// |--------------|------------|----------|------------|------------------|
// |      1       |      0     |    0     |     1      | Port 1 Only      |
// |--------------|------------|----------|------------|------------------|
// |      2       |      0     |    1     |     0      | Port 2 Only      |
// |--------------|------------|----------|------------|------------------|
// |      3       |      0     |    1     |     1      | Port 1 & Port 2  |
// |--------------|------------|----------|------------|------------------|
// |      4       |      1     |    0     |     0      | Port 3 Only      |
// |--------------|------------|----------|------------|------------------|
// |      5       |      1     |    0     |     1      | Port 3 & Port 1  |
// |--------------|------------|----------|------------|------------------|
// |      6       |      1     |    1     |     0      | Port 3 & Port 2  |
// |--------------|------------|----------|------------|------------------|
// |      7       |      1     |    1     |     1      | All Port Request |
// |--------------|------------|----------|------------|------------------|
// |      8       |      0     |    0     |     0      | No Request       |
// |--------------|------------|----------|------------|------------------|
// The transitions to state 3, state 5,state 7 and state 6 could be due to
// simultaneous requests from respective ports or one after the other in
// any sequence.
// State 8 is an idle state when there is no request.
// In each state eight transitions are possible.
// Priotity Table is used to resolve priority among two ports.The priority
// table is illustarted below.Three bits are used for Port Id.
//
// ------
// PTable
// ------
// |----------|------|------|------|
// | Location | Bit2 | Bit1 | Bit0 |    001 -> Port 1
// |----------|------|------|------|    010 -> Port 2
// |     0    |      |      |      |    100 -> Port 3
// |----------|------|------|------|
// |     1    |      |      |      |
// |----------|------|------|------|
// When a port is granted its id is written at location 0 and the contents
// of location 0 is pushed to location 1.In this manner the priority table
// is updated and when a priority needs to be resolved the contents of
// these locations are checked to know the least granted port.
//
// ----------
// BackoffReg
// ----------
// This Backoff register contains a port id whose time out counter
// has reached zero first.This helps in generating the grant signal
// when more than one counter reaches time out value zero.
// The 2 bits port id is shown below:
//   01 -> Port 1
//   10 -> Port 2
//   11 -> Port 3
//
// -----------------------------------------------------------------------------
always @(posedge EBICLK or negedge nPOR)
begin : p_mainSeq
  if(nPOR == 1'b0)
    begin
      // Intialise all the signals to the default values
      NState       <=`SEIGHT; // Initial State value is 8(Init State)
      EbiTrGnt     <= 3'b000; // After Reset No Ports are granted
      EbiTrBackoff <= 3'b000;
      PTable[1]    <= 3'b010; // PTable Location 1 is loaded with Port 3
      PTable[0]    <= 3'b100; // PTable Location 0 is loaded with Port 1
      TriSim31     <= 1'b0;
      TriSim21     <= 1'b0;
      TriSim32     <= 1'b0;
      BackOffReg   <= 2'b00; 
      BackOffRegv  <= 2'b00; 
      Flag3To1     <= 1'b0;
      Flag3To2     <= 1'b0;
      Flag5To1     <= 1'b0;
      Flag5To4     <= 1'b0;
      Flag6To4     <= 1'b0;
      Flag6To2     <= 1'b0;
      CounterOne   <= 10'b0000000000;
      CounterTwo   <= 10'b0000000000;
      CounterThr   <= 10'b0000000000;
      DcrCnt1      <= 1'b0;
      DcrCnt2      <= 1'b0;
      DcrCnt3      <= 1'b0;
      TrigCnt1     <= 1'b0;
      TrigCnt2     <= 1'b0;
      TrigCnt3     <= 1'b0;
    end 
  else 
    begin
      // ------------------------------------------------------------------
      // Condition to Clear the Trigger to Internal Time Out Counter Port 2
      // ------------------------------------------------------------------
      if(EbiTrGnt[1] == TrigCnt2)
        TrigCnt2 <= 1'b0;
      // ------------------------------------------------------------------
      // Condition to Clear the Trigger to Internal Time Out Counter Port 1
      // ------------------------------------------------------------------
      if(EbiTrGnt[0] == TrigCnt1)
        TrigCnt1 <= 1'b0;
      // ------------------------------------------------------------------
      // Condition to Clear the Trigger to Internal Time Out Counter Port 3
      // ------------------------------------------------------------------
      if(EbiTrGnt[2] == TrigCnt3)
        TrigCnt3 <= 1'b0;
      // -----------------------------------------------------------------
      // Enabling Logic for Decrementing Internal Time Out Counter Port 1
      // and raising the DcrCnt1 signal when the counter reaches 0 for
      // generating the Backoff signal.The Counter gets reloaded under the
      // following conditions:
      // 1. When the previously granted port releases the request before
      //    the Time Out Counter has reached zero
      // 2. When the Port that has generated the Backoff signal is granted.
      // -----------------------------------------------------------------
      if(TrigCnt1 == 1'b1)
        begin
          if(CounterOne == 10'b0000000001)
            begin
              DcrCnt1 <= 1'b1;
              CounterOne <= CounterOne;
            end
          else if(CounterOne == 10'b0000000000)
            begin
              DcrCnt1 <= 1'b1;
              CounterOne <= CounterOne;
            end
          else
            CounterOne <= CounterOne -1 ;
          end
      else
        begin
          CounterOne <= EBITIMEOUTVALUE1 - 1;
          DcrCnt1 <= 1'b0;
        end
      // -----------------------------------------------------------------
      // Enabling Logic for Decrementing Internal Time Out Counter Port 2
      // and raising the DcrCnt1 signal when the counter reaches 0 for
      // generating the Backoff signal.The Counter gets reloaded under the
      // following conditions:
      // 1. When the previously granted port releases the request before
      //    the Time Out Counter has reached zero
      // 2. When the Port that has generated the Backoff signal is granted.
      // -----------------------------------------------------------------
      if(TrigCnt2 == 1'b1)
        begin
          if(CounterTwo == 10'b0000000001)
            begin
              DcrCnt2 <= 1'b1;
              CounterTwo <= CounterTwo;
            end
          else if(CounterTwo == 10'b0000000000)
            begin
              DcrCnt1 <= 1'b1;
              CounterTwo <= CounterTwo;
            end
          else
            CounterTwo <= CounterTwo -1;
        end
      else
        begin
          CounterTwo <= EBITIMEOUTVALUE2 - 1;
          DcrCnt2 <= 1'b0;
        end
      // -----------------------------------------------------------------
      // Enabling Logic for Decrementing Internal Time Out Counter Port 3
      // and raising the DcrCnt1 signal when the counter reaches 0 for
      // generating the Backoff signal.The Counter gets reloaded under the
      // following conditions:
      // 1. When the previously granted port releases the request before
      //    the Time Out Counter has reached zero
      // 2. When the Port that has generated the Backoff signal is granted.
      // -----------------------------------------------------------------
      if(TrigCnt3 == 1'b1)
        begin
          if(CounterThr == 10'b0000000001)
            begin
              DcrCnt3 <= 1'b1;
              CounterThr <= CounterThr;
            end
          else if(CounterThr == 10'b0000000000)
            begin
              DcrCnt1 <= 1'b1;
              CounterThr <= CounterThr;
            end
          else
            CounterThr <= CounterThr - 1 ;
        end
      else
        begin
          CounterThr <= EBITIMEOUTVALUE3 - 1;
          DcrCnt3 <= 1'b0;
        end
      // ------------------------------------------------------------------
      case(CState) 
      // ------------------------------------------------------------------
      // Current State Decoding
      // ------------------------------------------------------------------
        `SONE :
           // -------------------------------------------------------------
           // STATE 1
           // In this state there is only one request from Port 1.
           // -------------------------------------------------------------
           // |------------|-----------------------------------------------
           // | Next State |            Comments
           // |------------|-----------------------------------------------
           // |    000     | When fsm is in state one and goes back to init
           // |            | state(state 8) indicates that Port 1 has
           // |            | released its request.
           // |------------|-----------------------------------------------
           // |    001     | Port 1 maintains the Request.
           // |------------|-----------------------------------------------
           // |    010     | Port 1 has released the request and Port 2
           // |            | has requested.Grant has to given to Port 2
           // |            | updating the PTable(priority table).
           // |------------|-----------------------------------------------
           // |    011     | Port 1 continues to maitain the request and
           // |            | Port 2 has requested.If Port 2 Time Out
           // |            | Counter value is zero then Backoff for Port 1
           // |            | is raised on the next clock else TrigCnt2
           // |            | signal is raised for decrementing the Port 2
           // |            | Time Out Counter.
           // |------------|-----------------------------------------------
           // |    100     | Port 1 has released the request and Port 3
           // |            | has requested.Grant has to given to Port 3
           // |            | updating the PTable(priority table).
           // |------------|-----------------------------------------------
           // |    101     | Port 1 continues to maitain the request and
           // |            | Port 3 has requested.If Port 3 Time Out
           // |            | Counter value is zero then Backoff for Port 1
           // |            | is raised on the next clock else TrigCnt3
           // |            | signal is raised for decrementing the Port 3
           // |            | Time Out Counter.
           // |------------|-----------------------------------------------
           // |    110     | Port 1 has released the request and Port 2
           // |            | and Port 3 has requested simultaneously.
           // |            | Based on PTbale either Port 2 or Port 3 is
           // |            | granted.
           // |            | If Port 2 is Granted, Port 3 Time Out
           // |            | Counter is Triggered after checking for non
           // |            | zero value.If the Port 3 Time Out Counter
           // |            | value is zero then back off for Port 2
           // |            | is given on next clock in state 6.This is
           // |            | because Grant and Backoff should not be given
           // |            | on the same clock.
           // |            | If Port 3 is Granted, Port 2 Time Out
           // |            | Counter is Triggered after checking for non
           // |            | zero value.If the Port 2 Time Out Counter
           // |            | value is zero then back off for Port 3
           // |            | is given on next clock in state 6.This is
           // |            | because Grant and Backoff should not be given
           // |            | on the same clock.
           // |            | TrigSim32 signal is raised.
           // |------------|-----------------------------------------------
           // |    111     | Here Port 1 continues to hold the request and
           // |            | port 2 and 3 simultaneously request.
           // |            | TriSim32 signal is raised.
           // |            | Backoff signal for Port 1 is generated
           // |            | on the next clock by checking for zero value
           // |            | of Time Out Counter of Port 2 or Port 3.
           // |            | If Time Out Counter values of Port 2 or
           // |            | Port 3 are non zeros then Trigger signals
           // |            | for appropriate Time Out Counter is raised
           // |            | to decrement.
           // |------------|-----------------------------------------------
           // -------------------------------------------------------------
           case({EBIREQ3,EBIREQ2,EBIREQ1})
             3'b000 : 
               begin
                 NState <=`SEIGHT;
                 EbiTrGnt     <= 3'b000; 
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 TriSim21     <= 1'b0;
                 TriSim31     <= 1'b0;
                 TriSim32     <= 1'b0;
               end
             3'b001 : 
               NState <=`SONE;
             3'b010 : 
               begin
                 NState <=`STWO;
                 EbiTrGnt   <= 3'b010;
                 PTable[1]  <= PTable[0];
                 PTable[0]  <= 3'b010;   
               end
             3'b011 : 
               begin
                 NState <=`STHREE;
                 EbiTrGnt <= 3'b001; 
                 if(EBITIMEOUTVALUE2 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= 3'b001;
                     BackOffRegv  <= 2'b10; 
                   end 
                 else 
                   TrigCnt2 <= 1'b1; 
               end
             3'b100 : 
               begin
                 NState <=`SFOUR;
                 EbiTrGnt  <= 3'b100;
                 PTable[1] <= PTable[0];
                 PTable[0] <= 3'b100;   
               end
             3'b101 : 
               begin
                 NState <=`SFIVE;
                 EbiTrGnt <= 3'b001; 
                 if(EBITIMEOUTVALUE3 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= 3'b001;
                     BackOffRegv  <= 2'b11; 
                   end 
                 else 
                   TrigCnt3 <= 1'b1; 
               end
             3'b110 : 
               begin
                 NState <=`SSIX;
                 TriSim32 <= 1'b1; 
                 if(PTable[0] == 3'b010 || PTable[1] == 3'b010) 
                   begin
                     if(TrigCnt3 == 1'b0)
                       begin
                         EbiTrGnt  <= 3'b100;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b100;   
                         if(EBITIMEOUTVALUE2 != 10'b0000000000) 
                           TrigCnt2 <= 1'b1;
                       end 
                   end 
                 else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)   
                   begin
                     if(TrigCnt2 == 1'b0)
                       begin
                         EbiTrGnt  <= 3'b010;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b010;  
                         if(EBITIMEOUTVALUE3 != 10'b0000000000) 
                           TrigCnt3  <= 1'b1; 
                       end 
                   end 
               end
             3'b111 : 
                begin
                  NState <=`SSEVEN;
                  TriSim32 <= 1'b1;
                  if(EBITIMEOUTVALUE2 == 10'b0000000000)
                    begin
                      EbiTrBackoff <= 3'b001;
                      BackOffRegv  <= 2'b00; 
                    end 
                  else
                    TrigCnt2 <= 1'b1; 
                  if(EBITIMEOUTVALUE3 == 10'b0000000000)
                    begin
                      EbiTrBackoff <= 3'b001;
                      BackOffRegv  <= 2'b00; 
                    end 
                  else
                    TrigCnt3 <= 1'b1; 
                end
           endcase  
        `STHREE : 
           // -------------------------------------------------------------
           // STATE 3
           // In this State there is Request from Port 2 and Port 1.
           // -------------------------------------------------------------
           // |------------|-----------------------------------------------
           // | Next State |            Comments
           // |------------|-----------------------------------------------
           // |    000     | From state three if Port 2 and Port 1 requests
           // |            | are deasserted then next state is init state
           // |            | (state eight).
           // |------------|-----------------------------------------------
           // |    001     | In this case Port 2 has deasserted the
           // |            | requested clear backoffreg and Grant is given
           // |            | to Port 1.The Priority Table is update only
           // |            | if the previous granted Port is not 1 ie
           // |            | Port 2.
           // |------------|-----------------------------------------------
           // |    010     | In this case Port 1 has deasserted the
           // |            | requested clear backoffreg and Grant is given
           // |            | to Port 1.The Priority Table is update only
           // |            | if the previous granted Port is not 2 ie
           // |            | Port 1.
           // |------------|-----------------------------------------------
           // |    011     | In this case if TrigSim21 flag is raised
           // |            | then is is clear that Port 2 and Port 1 has
           // |            | requested simultaneously.Time Out Counter
           // |            | values are check for zero value and a backoff
           // |            | is raised to the port that was granted and
           // |            | backoffreg is update with port id.
           // |            | Four condition are checked in this case:
           // |            | 1. DcrCnt2 = '1' and DcrCnt1 = '0'
           // |            |    which indicates that Time out value of
           // |            |    counter 2 has reached zero.Backoff signal
           // |            |    is raised to Port 1 and Backoffreg register
           // |            |    is updated with Port 2 id.
           // |            | 2. DcrCnt2 = '0' and DcrCnt1 = '1'
           // |            |    which indicates that Time out value of
           // |            |    counter 1 has reached zero.Backoff signal
           // |            |    is raised for Port 2 and Backoffreg
           // |            |    register is updated with Port 1 id.
           // |            | 3. DcrCnt2 = '1' and DcrCnt1 = '1'
           // |            |    which indicates that Time out value of
           // |            |    counter 1 has reached zero and also
           // |            |    Time out value of counter 2 has reached
           // |            |    reached zero.This case can happen only
           // |            |    when Port 3 has released the request and
           // |            |    both the ports Time Out Counter value has
           // |            |    reached zero.Now the Grant is given to
           // |            |    the Port whose id is in Backoffreg register.
           // |            |    The Backoffreg register contains the port
           // |            |    id whose Time Out Counter has reached zero
           // |            |    first.
           // |------------|-----------------------------------------------
           // |    100     | In this case both Port 2 and Port 1 requests
           // |            | are deasserted and Port 3 has made a request.
           // |            | The grant is given to Port 3.Backoffreg is
           // |            | cleared.PTable is updated.
           // |------------|-----------------------------------------------
           // |    101     | In this case clear the Trigger for Time Out
           // |            | Counter for Port 2.Port 3 has raised the
           // |            | raised the request.If previously granted
           // |            | port was 2 then Port 1 has to be granted and
           // |            | Trigger has to raised for decrementing the
           // |            | Time Out Counter of Port 3.If none of the
           // |            | above condition is true then a priority
           // |            | table decides which Port needs to be granted.
           // |            | Ptbale is updated in either case.
           // |    110     | In this case clear the Trigger for Time Out
           // |            | Counter for Port 1.Port 3 has raised the
           // |            | raised the request.If previously granted
           // |            | port was 1 then Port 2 has to be granted and
           // |            | Trigger has to raised for decrementing the
           // |            | Time Out Counter of Port 3.If none of the
           // |            | above condition is true then a priority
           // |            | table decides which Port needs to be granted.
           // |            | Ptbale is updated in either case.
           // |------------|-----------------------------------------------
           // |    111     | In this case Port 3 has raised the request
           // |            | while Port 2 and Port 1 already have their
           // |            | requests raised.If Port 3 Time Out Counter
           // |            | value is zero and no backoff signal is
           // |            | generated then backoff signal is raised to
           // |            | the Port that has been granted.Else Port 3
           // |            | Time Out Counter is Triggered for
           // |            | decrementing.Also If Time Out Counter for
           // |            | port 2 or Port 1 has reached zero backoff
           // |            | is generated for the Port currently granted.
           // |            | Backoffreg register is update with the port
           // |            | id which determines Port to be grantied next.
           // |------------|-----------------------------------------------
           // -------------------------------------------------------------
           case ({EBIREQ3,EBIREQ2,EBIREQ1})
             3'b000 :
               begin
                 NState <=`SEIGHT;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 EbiTrGnt     <= 3'b000;  
                 TrigCnt1     <= 1'b0;
                 TrigCnt2     <= 1'b0;
                 TrigCnt3     <= 1'b0;
                 Flag3To1     <= 1'b0;
                 Flag3To2     <= 1'b0;
                 TriSim21     <= 1'b0;
                 TriSim32     <= 1'b0;
                 TriSim31     <= 1'b0;
               end 
             3'b001 : 
               begin
                 NState <=`SONE;
                 EbiTrGnt     <= 3'b001;   
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 if(EbiTrGnt != 3'b001)
                   begin
                     PTable[1] <= PTable[0];
                     PTable[0] <= 3'b001;
                   end 
                 Flag3To1  <= 1'b0;
                 Flag3To2  <= 1'b0;
               end 
             3'b010 :
               begin
                 NState <=`STWO; 
                 EbiTrGnt     <= 3'b010;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 if(EbiTrGnt != 3'b010)
                 begin
                   PTable[1] <= PTable[0];
                   PTable[0] <= 3'b010;
                 end 
                 Flag3To1 <= 1'b0;
                 Flag3To2 <= 1'b0;
                 TrigCnt1 <= 1'b0;
               end 
             3'b011 :
               begin
                 NState <=`STHREE;
                 if(TriSim21 == 1'b1)
                    begin
                      if(EBITIMEOUTVALUE1 == 10'b0000000000 && 
                                                           EbiTrGnt == 3'b010)
                        begin
                          EbiTrBackoff <= 3'b010;
                          BackOffRegv  <= 2'b01;
                        end
                      if(EBITIMEOUTVALUE2 == 10'b0000000000 && 
                                                           EbiTrGnt == 3'b001)
                        begin
                          EbiTrBackoff <= 3'b001;
                          BackOffRegv  <= 2'b10;
                      end
                    end
                 if(DcrCnt2 == 1'b1 && DcrCnt1 == 1'b0)
                    begin
                      if(BackOffRegv == 2'b10 && Flag3To2 == 1'b0 && 
                                                            Flag3To1 == 1'b0) 
                        begin
                          // EbiTrBackoff <= 3'b010;
                          // BackOffRegv  <= 2'b01;
                          // Flag3To2     <= 1'b1; 
                          EbiTrBackoff <= 3'b001;
                          BackOffRegv  <= 2'b10;
                          Flag3To1     <= 1'b1; 
                        end
                      else if(BackOffRegv == 2'b01 && Flag3To2 == 1'b0 && 
                                                            Flag3To1 == 1'b0)
                        begin
                          // EbiTrBackoff <= 3'b001;
                          // BackOffRegv  <= 2'b10;
                          // Flag3To1     <= 1'b1; 
                          EbiTrBackoff <= 3'b010;
                          BackOffRegv  <= 2'b01;
                          Flag3To2     <= 1'b1; 
                        end
                      else 
                        begin
                          if(Flag3To2 == 1'b0 && Flag3To1 == 1'b0)
                            begin
                              EbiTrBackoff <= 3'b001;
                              BackOffRegv  <= 2'b10; 
                              Flag3To2  <= 1'b1; 
                              Flag3To1  <= 1'b1; 
                              TriSim21  <= 1'b0;
                            end
                        end
                    end
                 else if(DcrCnt2 == 1'b0 && DcrCnt1 == 1'b1)
                   begin
                     if(BackOffRegv == 2'b10 && Flag3To2 == 1'b0 && 
                                                            Flag3To1 == 1'b0) 
                       begin
                         // EbiTrBackoff <= 3'b010;
                         // BackOffRegv  <= 2'b01;
                         // Flag3To2     <= 1'b1; 
                         EbiTrBackoff <= 3'b001;
                         BackOffRegv  <= 2'b10;
                         Flag3To1     <= 1'b1; 
                       end
                     else if(BackOffRegv == 2'b01 && Flag3To2 == 1'b0 && 
                                                            Flag3To1 == 1'b0)
                       begin
                         // EbiTrBackoff <= 3'b001;
                         // BackOffRegv  <= 2'b10;
                         // Flag3To1     <= 1'b1; 
                         EbiTrBackoff <= 3'b010;
                         BackOffRegv  <= 2'b01;
                         Flag3To2     <= 1'b1; 
                       end
                     else 
                       begin
                         if(Flag3To2 == 1'b0 && Flag3To1 == 1'b0)
                           begin
                             EbiTrBackoff <= 3'b010;
                             BackOffRegv   <= 2'b01; 
                             Flag3To2  <= 1'b1; 
                             Flag3To1  <= 1'b1; 
                             TriSim21  <= 1'b0;
                           end
                         end
                   end
                 else if(DcrCnt2 == 1'b1 && DcrCnt1 == 1'b1)
                   begin
                     if(BackOffRegv == 2'b10 && Flag3To2 == 1'b0 &&
                                                           Flag3To1 == 1'b0) 
                       begin
                         EbiTrGnt     <= 3'b010;
                         EbiTrBackoff <= 3'b010;
                         BackOffRegv  <= 2'b01;
                         Flag3To2     <= 1'b1; 
                         Flag3To1     <= 1'b1; 
                       end
                     else if(BackOffRegv == 2'b01 && Flag3To2 == 1'b0 &&
                                                            Flag3To1 == 1'b0)   
                       begin
                         EbiTrGnt     <= 3'b001;
                         EbiTrBackoff <= 3'b001;
                         BackOffRegv  <= 2'b10;
                         Flag3To2     <= 1'b1; 
                         Flag3To1     <= 1'b1; 
                       end
                   end
               end 
             3'b100 : 
               begin
                 NState <=`SFOUR;
                 EbiTrGnt     <= 3'b100;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00;
                 PTable[1]    <= PTable[0];
                 PTable[0]    <= 3'b100;
                 TrigCnt2     <= 1'b0;
                 TrigCnt1     <= 1'b0;
               end 
             3'b101 :
               begin
                 NState <=`SFIVE;
                 TrigCnt2     <= 1'b0;
                 TrigCnt3     <= 1'b1;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00;  
                 if(EbiTrGnt == 3'b010)
                   begin
                     if(DcrCnt1 == 1'b1)
                       begin
                         EbiTrGnt  <= 3'b001;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b001; 
                         TrigCnt3  <= 1'b1;
                       end
                     else
                       begin
                         if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                           begin
                             EbiTrGnt  <= 3'b100;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b100;
                             TrigCnt1  <= 1'b1;
                           end
                         else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                           begin
                             EbiTrGnt  <= 3'b001;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b001;
                             TrigCnt3  <= 1'b1;
                           end
                       end
                   end 
               end 
             3'b110 :
               begin
                 NState <=`SSIX;
                 TrigCnt1     <= 1'b0;
                 TrigCnt3     <= 1'b1;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00;  
                 if(EbiTrGnt == 3'b001)
                   begin
                     if(DcrCnt2 == 1'b1)
                       begin
                         EbiTrGnt  <= 3'b010;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b010; 
                         TrigCnt3  <= 1'b1;
                       end
                     else
                       begin
                         if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                         begin
                           EbiTrGnt  <= 3'b010;
                           PTable[1] <= PTable[0];
                           PTable[0] <= 3'b010;
                           TrigCnt3  <= 1'b1;
                         end
                         else if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                         begin
                           EbiTrGnt  <= 3'b100;
                           PTable[1] <= PTable[0];
                           PTable[0] <= 3'b100;
                           TrigCnt2  <= 1'b1;
                         end
                       end
                   end 
               end 
             3'b111 : 
               begin
                 NState  <=`SSEVEN;
                 if(EBITIMEOUTVALUE3 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv  <= 2'b11; 
                     DcrCnt3      <= 1'b1;
                   end 
                 else
                   TrigCnt3 <= 1'b1; 
                 if(DcrCnt2 == 1'b1)
                   begin
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv  <= 2'b10;
                   end     
                 else if(DcrCnt1 == 1'b1)
                   begin
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv  <= 2'b01;
                   end     
                 Flag3To1 <= 1'b0;
                 Flag3To2 <= 1'b0;
               end 
           endcase
        `SFIVE : 
           // -------------------------------------------------------------
           // STATE 5
           // In this State there is Request from Port 3 and Port 1.
           // -------------------------------------------------------------
           // |------------|-----------------------------------------------
           // | Next State |            Comments
           // |------------|-----------------------------------------------
           // |    000     | From state five if Port 3 and Port 1 requests
           // |            | are deasserted then next state is init state
           // |            | (state eight).
           // |------------|-----------------------------------------------
           // |    001     | In this case Port 3 has deasserted the
           // |            | requested clear backoffreg and Grant is given
           // |            | to Port 1.The Priority Table is update only
           // |            | if the previous granted Port is not 1 ie
           // |            | Port 3.
           // |------------|-----------------------------------------------
           // |    100     | In this case Port 1 has deasserted the
           // |            | requested clear backoffreg and Grant is given
           // |            | to Port 1.The Priority Table is update only
           // |            | if the previous granted Port is not 3 ie
           // |            | Port 1.
           // |------------|-----------------------------------------------
           // |    101     | In this case if TrigSim31 flag is raised
           // |            | then it is clear that Port 3 and Port 1 has
           // |            | requested simultaneously.Time Out Counter
           // |            | values are check for zero value and a backoff
           // |            | is raised to the port that was granted and
           // |            | backoffreg is update with port id.
           // |            | Four condition are checked in this case:
           // |            | 1. DcrCnt3 = '1' and DcrCnt1 = '0'
           // |            |    which indicates that Time out value of
           // |            |    counter 3 has reached zero.Backoff signal
           // |            |    is raised to Port 1 and Backoffreg register
           // |            |    is updated with Port 3 id.
           // |            | 2. DcrCnt3 = '0' and DcrCnt1 = '1'
           // |            |    which indicates that Time out value of
           // |            |    counter 1 has reached zero.Backoff signal
           // |            |    is raised for Port 3 and Backoffreg
           // |            |    register is updated with Port 3 id.
           // |            | 3. DcrCnt3 = '1' and DcrCnt1 = '1'
           // |            |    which indicates that Time out value of
           // |            |    counter 1 has reached zero and also
           // |            |    Time out value of counter 3 has reached
           // |            |    reached zero.This case can happen only
           // |            |    when Port 2 has released the request and
           // |            |    both the ports Time Out Counter value has
           // |            |    reached zero.Now the Grant is given to
           // |            |    the Port whose id is in Backoffreg register.
           // |            |    The Backoffreg register contains the port
           // |            |    id whose Time Out Counter has reached zero
           // |            |    first.
           // |    010     | In this case both Port 3 and Port 1 requests
           // |            | are deasserted and Port 2 has made a request.
           // |            | The grant is given to Port 2.Backoffreg is
           // |            | cleared.PTable is updated.
           // |------------|-----------------------------------------------
           // |    110     | In this case clear the Trigger for Time Out
           // |            | Counter for Port 1.Port 2 has raised the
           // |            | raised the request.If previously granted
           // |            | port was 1 then Port 3 has to be granted and
           // |            | Trigger has to raised for decrementing the
           // |            | Time Out Counter of Port 2.If none of the
           // |            | above condition is true then a priority
           // |            | table decides which Port needs to be granted.
           // |            | Ptbale is updated in either case.
           // |------------|-----------------------------------------------
           // |    011     | In this case clear the Trigger for Time Out
           // |            | Counter for Port 3.Port 2 has raised the
           // |            | raised the request.If previously granted
           // |            | port was 3 then Port 1 has to be granted and
           // |            | Trigger has to raised for decrementing the
           // |            | Time Out Counter of Port 2.If none of the
           // |            | above condition is true then a priority
           // |            | table decides which Port needs to be granted.
           // |            | Ptbale is updated in either case.
           // |------------|-----------------------------------------------
           // |    111     | In this case Port 2 has raised the request
           // |            | while Port 3 and Port 1 already have their
           // |            | requests raised.If Port 2 Time Out Counter
           // |            | value is zero and no backoff signal is
           // |            | generated then backoff signal is raised to
           // |            | the Port that has been granted.Else Port 2
           // |            | Time Out Counter is Triggered for
           // |            | decrementing.Also If Time Out Counter for
           // |            | port 3 or Port 1 has reached zero backoff
           // |            | is generated for the Port currently granted.
           // |            | Backoffreg register is update with the port
           // |            | id which determines Port to be grantied next.
           // |------------|-----------------------------------------------
           // -------------------------------------------------------------
           case({EBIREQ3,EBIREQ2,EBIREQ1})
             3'b000 :
               begin
                 NState  <=`SEIGHT;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 EbiTrGnt     <= 3'b000;  
                 TrigCnt3     <= 1'b0;
                 TrigCnt2     <= 1'b0;
                 TrigCnt1     <= 1'b0;
                 Flag5To1     <= 1'b0;
                 Flag5To4     <= 1'b0;
                 TriSim21     <= 1'b0;
                 TriSim32     <= 1'b0;
                 TriSim31     <= 1'b0;
               end
             3'b001 :
               begin
                NState <=`SONE;
                EbiTrGnt     <= 3'b001;   
                EbiTrBackoff <= 3'b000;
                BackOffRegv  <= 2'b00; 
                if(EbiTrGnt != 3'b001) 
                  begin  
                    PTable[1] <= PTable[0];
                    PTable[0] <= 3'b001;
                  end 
                Flag5To1 <= 1'b0;
                Flag5To4 <= 1'b0;
                TrigCnt3 <= 1'b0;
               end
             3'b010 :
               begin
                 NState <=`STWO;
                 EbiTrGnt     <= 3'b010;   
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 TrigCnt3     <= 1'b0;
                 TrigCnt2     <= 1'b0;
                 PTable[1]    <= PTable[0];
                 PTable[0]    <= 3'b010;
               end
             3'b011 : 
               begin
                 NState <=`STHREE;
                 TrigCnt3     <= 1'b0;
                 TrigCnt2     <= 1'b1;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 if(EbiTrGnt == 3'b100)
                   begin
                     if(DcrCnt1 == 1'b1)
                       begin
                         EbiTrGnt  <= 3'b001;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b001; 
                         TrigCnt2  <= 1'b1;
                       end
                     else
                      begin
                        if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                          begin
                            EbiTrGnt  <= 3'b010;
                            PTable[1] <= PTable[0];
                            PTable[0] <= 3'b010;
                            TrigCnt1  <= 1'b1;
                          end
                        else if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                          begin
                            EbiTrGnt  <= 3'b001;
                            PTable[1] <= PTable[0];
                            PTable[0] <= 3'b001;
                            TrigCnt2  <= 1'b1;
                          end
                      end
                   end 
               end
             3'b100 : 
               begin
                 NState  <=`SFOUR;
                 EbiTrGnt     <= 3'b100;   
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 if(EbiTrGnt != 3'b100)  
                   begin
                     PTable[1] <= PTable[0];
                     PTable[0] <= 3'b100;
                   end 
                 Flag5To1 <= 1'b0;
                 Flag5To4 <= 1'b0;
                 TrigCnt1 <= 1'b0;
               end
             3'b101 : 
               begin
                 NState <=`SFIVE;
                 if(TriSim31 == 1'b1)
                   begin
                     if(EBITIMEOUTVALUE1 == 10'b0000000000 && 
                                                       EbiTrGnt == 3'b100)
                       begin
                         EbiTrBackoff <= 3'b100;
                         BackOffRegv  <= 2'b01;
                       end
                     if(EBITIMEOUTVALUE3 == 10'b0000000000 && 
                                                       EbiTrGnt == 3'b001)
                       begin
                         EbiTrBackoff <= 3'b001;
                         BackOffRegv  <= 2'b11;
                       end
                   end
                 if(DcrCnt3 == 1'b1 && DcrCnt1 == 1'b0)
                   begin
                     if(BackOffRegv == 2'b11 && Flag5To4 == 1'b0 && 
                                                       Flag5To1 == 1'b0) 
                       begin
                         // EbiTrBackoff <= 3'b100;
                         // BackOffRegv  <= 2'b01;
                         // Flag5To4     <= 1'b1; 
                         EbiTrBackoff <= 3'b001;
                         BackOffRegv  <= 2'b11;
                         Flag5To1     <= 1'b1; 
                       end
                     else if(BackOffRegv == 2'b01 && Flag5To4 == 1'b0 && 
                                                       Flag5To1 == 1'b0)
                       begin
                         // EbiTrBackoff <= 3'b001;
                         // BackOffRegv  <= 2'b11;
                         // Flag5To1     <= 1'b1; 
                         EbiTrBackoff <= 3'b100;
                         BackOffRegv  <= 2'b01;
                         Flag5To4     <= 1'b1; 
                       end
                     else
                       begin
                         if(Flag5To4 == 1'b0 && Flag5To1 == 1'b0)
                           begin
                             EbiTrBackoff <= 3'b001;
                             BackOffRegv  <= 2'b11; 
                             Flag5To4  <= 1'b1;
                             Flag5To1  <= 1'b1;
                             TriSim31  <= 1'b0;
                           end
                       end
                   end 
                 else if(DcrCnt3 == 1'b0 && DcrCnt1 == 1'b1)
                   begin
                     if(BackOffRegv == 2'b11 && Flag5To4 == 1'b0 && 
                                                       Flag5To1 == 1'b0) 
                       begin
                         // EbiTrBackoff <= 3'b100;
                         // BackOffRegv  <= 2'b01;
                         // Flag5To4     <= 1'b1;
                         EbiTrBackoff <= 3'b001;
                         BackOffRegv  <= 2'b11;
                         Flag5To1     <= 1'b1;
                       end
                     else if(BackOffRegv == 2'b01 && Flag5To1 == 1'b0 && 
                                                       Flag5To1 == 1'b0)
                       begin
                         // EbiTrBackoff <= 3'b001;
                         // BackOffRegv  <= 2'b11;
                         // Flag5To1     <= 1'b1;
                         EbiTrBackoff <= 3'b100;
                         BackOffRegv  <= 2'b01;
                         Flag5To4     <= 1'b1;
                       end
                     else
                       begin
                         if(Flag5To4 == 1'b0 && Flag5To1 == 1'b0)
                         begin
                           EbiTrBackoff <= 3'b100;
                           BackOffRegv  <= 2'b01; 
                           Flag5To4     <= 1'b1;
                           Flag5To1     <= 1'b1;
                           TriSim31     <= 1'b0;
                         end
                       end
                   end 
                 else if(DcrCnt3 == 1'b1 && DcrCnt1 == 1'b1)
                   begin
                     if(BackOffRegv == 2'b11 && Flag5To1 == 1'b0 &&
                                                       Flag5To1 == 1'b0) 
                       begin
                          EbiTrGnt     <= 3'b100;
                          EbiTrBackoff <= 3'b100;
                          BackOffRegv  <= 2'b01;
                          Flag5To4     <= 1'b1;
                          Flag5To1     <= 1'b1;
                       end
                     else if(BackOffRegv == 2'b01 && Flag5To1 == 1'b0 &&
                                                       Flag5To1 == 1'b0)   
                       begin
                          EbiTrGnt     <= 3'b001;
                          EbiTrBackoff <= 3'b001;
                          BackOffRegv  <= 2'b11;
                          Flag5To4     <= 1'b1;
                          Flag5To1     <= 1'b1;
                       end
                   end  
               end
             3'b110 : 
               begin
                 NState <=`SSIX;
                 TrigCnt1     <= 1'b0;
                 TrigCnt2     <= 1'b1;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 if(EbiTrGnt == 3'b001)
                   begin
                     if(DcrCnt3 == 1'b1)
                       begin
                         EbiTrGnt  <= 3'b100;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b100; 
                         TrigCnt2  <= 1'b1;
                       end
                     else
                       begin
                         if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                           begin
                             EbiTrGnt  <= 3'b010;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b010;
                             TrigCnt3  <= 1'b1;
                           end
                         else if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                           begin
                             EbiTrGnt  <= 3'b100;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b100;
                             TrigCnt2  <= 1'b1;
                           end
                       end
                   end 
               end
             3'b111 :
               begin
                 NState <=`SSEVEN;
                 if(EBITIMEOUTVALUE2 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= 3'b010;
                     BackOffRegv  <= 2'b01; 
                     DcrCnt2      <= 1'b1;
                   end 
                 else
                   TrigCnt2 <= 1'b1; 
                 if(DcrCnt3 == 1'b1)
                   begin
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv  <= 2'b11;
                   end     
                 else if(DcrCnt1 == 1'b1)
                   begin
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv  <= 2'b01;
                   end     
                 Flag5To1 <= 1'b0;
                 Flag5To4 <= 1'b0;
               end
           endcase
        `SSEVEN : 
           // -------------------------------------------------------------
           // STATE 7
           // In this state Port 1,Port 2 and Port 3 has requested.These
           // requests could be simultaneous requests or raised in
           // any order.
           // -------------------------------------------------------------
           // |------------|-----------------------------------------------
           // | Next State |            Comments
           // |------------|-----------------------------------------------
           // |    000     | When in State seven if all requests are
           // |            | deasserted next state will be state eight
           // |            | (init state).
           // |------------|-----------------------------------------------
           // |    001     | In this case Port 3 and Port 2 has deasserted
           // |            | the request.Port 1 is granted.Ptable is
           // |            | updated is the previous port granted was not
           // |            | Port 1.
           // |------------|-----------------------------------------------
           // |    010     | In this case Port 3 and Port 1 has deasserted
           // |            | the request.Port 2 is granted.Ptable is
           // |            | updated is the previous port granted was not
           // |            | Port 2.
           // |------------|-----------------------------------------------
           // |    011     | Port 3 has released the request.The following
           // |            | checks are made in order to grant either
           // |            | Port 2 or Port 1.
           // |            | 1. Check if Previous granted port was 3.
           // |            | 2. If true then check for Time Out counter
           // |            |    values of Port 1 and Port 2.If simultaneous
           // |            |    request is raised from Port 1 and Port 2
           // |            |    then select the port to be granted by
           // |            |    PTable.If not simultaneous triggred
           // |            |    check which Port Time Out Counter has
           // |            |    reached zero and generate the grant.
           // |            |    If none of the counter has reached
           // |            |    zero then PTable is used to decide
           // |            |    which port needs to be granted.
           // |            |    If Time Out Counter values of Port 1 and
           // |            |    Port 2 are not equal then check which
           // |            |    Ports time out counter has reached zero
           // |            |    and generate the grant.If both Port 1 and
           // |            |    Port 2 Counter has reached zero then PTbale
           // |            |    is again used to generate the grant.
           // |            | 3. If previously granted port is not Port 3
           // |            |    based on Backoffreg register value
           // |            |    generate backoff signal.
           // |------------|-----------------------------------------------
           // |    100     | In this case Port 2 and Port 1 has deasserted
           // |            | the request.Port 3 is granted.Ptable is
           // |            | updated is the previous port granted was not
           // |            | Port 3.
           // |------------|-----------------------------------------------
           // |    101     | Port 2 has released the request.The following
           // |            | checks are made in order to grant either
           // |            | Port 3 or Port 1.
           // |            | 1. Check if Previous granted port was 2.
           // |            | 2. If true then check for Time Out counter
           // |            |    values of Port 3 and Port 1.If simultaneous
           // |            |    request is raised from Port 3 and Port 1
           // |            |    then select the port to be granted by
           // |            |    PTable.If not simultaneous triggred
           // |            |    check which Port Time Out Counter has
           // |            |    reached zero and generate the grant.
           // |            |    If none of the counter has reached
           // |            |    zero then PTable is used to decide
           // |            |    which port needs to be granted.
           // |            |    If Time Out Counter values of Port 3 and
           // |            |    Port 1 are not equal then check which
           // |            |    Ports time out counter has reached zero
           // |            |    and generate the grant.If both Port 3 and
           // |            |    Port 1 Counter has reached zero then PTbale
           // |            |    is again used to generate the grant.
           // |            | 3. If previously granted port is not Port 2
           // |            |    based on Backoffreg register value
           // |            |    generate backoff signal.
           // |------------|-----------------------------------------------
           // |    110     | Port 1 has released the request.The following
           // |            | checks are made in order to grant either
           // |            | Port 3 or Port 2.
           // |            | 1. Check if Previous granted port was 1.
           // |            | 2. If true then check for Time Out counter
           // |            |    values of Port 3 and Port 2.If simultaneous
           // |            |    request is raised from Port 3 and Port 2
           // |            |    then select the port to be granted by
           // |            |    PTable.If not simultaneous triggred
           // |            |    check which Port Time Out Counter has
           // |            |    reached zero and generate the grant.
           // |            |    If none of the counter has reached
           // |            |    zero then PTable is used to decide
           // |            |    which port needs to be granted.
           // |            |    If Time Out Counter values of Port 3 and
           // |            |    Port 2 are not equal then check which
           // |            |    Ports time out counter has reached zero
           // |            |    and generate the grant.If both Port 3 and
           // |            |    Port 2 Counter has reached zero then PTbale
           // |            |    is again used to generate the grant.
           // |            | 3. If previously granted port is not Port 1
           // |            |    based on Backoffreg register value
           // |            |    generate backoff signal.
           // |------------|-----------------------------------------------
           // |    111     | In this case following signals DcrCnt2,DcrCnt3
           // |            | and DcrCnt1 are polled which when raised
           // |            | indicates that the Time Out Counter value
           // |            | has reached zero.If any of these signals
           // |            | are high the backoff signal is raised to
           // |            | the Port granted and the port id which has
           // |            | raised backoff is stored in Backoffreg.
           // |------------|-----------------------------------------------
           // -------------------------------------------------------------
           case({EBIREQ3,EBIREQ2,EBIREQ1})
             3'b000 :
               begin
                 NState <=`SEIGHT;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 EbiTrGnt     <= 3'b000;  
                 TrigCnt1     <= 1'b0; 
                 TrigCnt2     <= 1'b0; 
                 TrigCnt3     <= 1'b0; 
                 TriSim21     <= 1'b0;
                 TriSim32     <= 1'b0;
                 TriSim31     <= 1'b0;
               end    
             3'b001 :
               begin
                 NState <=`SONE;
                 TrigCnt3     <= 1'b0; 
                 TrigCnt2     <= 1'b0; 
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 EbiTrGnt     <= 3'b001;
                 if(EbiTrGnt != 3'b001)
                   begin
                     PTable[1] <= PTable[0];
                     PTable[0] <= 3'b001;
                   end
               end    
             3'b010 :
               begin
                 NState <=`STWO;
                 TrigCnt3     <= 1'b0; 
                 TrigCnt1     <= 1'b0; 
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 EbiTrGnt     <= 3'b010;  
                 if(EbiTrGnt != 3'b010)
                   begin
                     PTable[1] <= PTable[0];
                     PTable[0] <= 3'b010;
                   end 
               end    
             3'b100 :
               begin
                 NState <=`SFOUR;
                 TrigCnt2     <= 1'b0; 
                 TrigCnt1     <= 1'b0; 
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv  <= 2'b00; 
                 EbiTrGnt     <= 3'b100;  
                 if(EbiTrGnt != 3'b100)
                   begin
                     PTable[1] <= PTable[0];
                     PTable[0] <= 3'b100;
                   end 
               end    
             3'b101 :
               begin
                 NState <=`SFIVE;
                 if(EbiTrGnt == 3'b010)
                   begin
                     if(EBITIMEOUTVALUE3 == EBITIMEOUTVALUE1)
                       begin
                         if(TriSim31 == 1'b1)
                           begin
                             TriSim31 <= 1'b0;
                             if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                             begin
                                EbiTrGnt     <= 3'b100;
                                EbiTrBackoff <= 3'b000;
                                BackOffRegv  <= 2'b00; 
                                PTable[1]    <= PTable[0];
                                PTable[0]    <= 3'b100;
                                TrigCnt1     <= 1'b1;
                             end
                             else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                             begin
                                EbiTrGnt     <= 3'b001;
                                EbiTrBackoff <= 3'b000;
                                BackOffRegv  <= 2'b00; 
                                PTable[1]    <= PTable[0];
                                PTable[0]    <= 3'b001;
                                TrigCnt3     <= 1'b1;
                             end
                           end
                         else
                           begin
                             if(DcrCnt3 == 1'b1 && DcrCnt1 == 1'b0)
                               begin
                                 EbiTrGnt     <= 3'b100;
                                 EbiTrBackoff <= 3'b000;
                                 BackOffRegv  <= 2'b00; 
                                 PTable[1]    <= PTable[0];
                                 PTable[0]    <= 3'b100;
                               end
                             else if(DcrCnt3 == 1'b0 && DcrCnt1 == 1'b1)
                               begin
                                 EbiTrGnt     <= 3'b001;
                                 EbiTrBackoff <= 3'b000;
                                 BackOffRegv  <= 2'b00; 
                                 PTable[1]    <= PTable[0];
                                 PTable[0]    <= 3'b001;
                               end
                             else if(DcrCnt3 == 1'b0 && DcrCnt1 == 1'b0)
                               begin
                                 if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                                 begin
                                    EbiTrGnt  <= 3'b100;
                                    PTable[1] <= PTable[0];
                                    PTable[0] <= 3'b100;
                                 end
                                 else if(PTable[0] == 3'b100 || 
                                                       PTable[1] == 3'b100)
                                 begin
                                    EbiTrGnt  <= 3'b001;
                                    PTable[1] <= PTable[0];
                                    PTable[0] <= 3'b001;
                                 end
                               end
                             else if(DcrCnt3 == 1'b1 && DcrCnt1 == 1'b1)
                               begin
                                 if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                                 begin
                                    EbiTrGnt     <= 3'b100;
                                    EbiTrBackoff <= 3'b000;
                                    BackOffRegv  <= 2'b00; 
                                    PTable[1]    <= PTable[0];
                                    PTable[0]    <= 3'b100;
                                 end
                                 else if(PTable[0] == 3'b100 || 
                                                        PTable[1] == 3'b100)
                                 begin
                                    EbiTrGnt     <= 3'b001;
                                    EbiTrBackoff <= 3'b000;
                                    BackOffRegv  <= 2'b00; 
                                    PTable[1]    <= PTable[0];
                                    PTable[0]    <= 3'b001;
                                 end
                               end  
                           end
                       end 
                     else
                       begin
                         if(DcrCnt3 == 1'b1 && DcrCnt1 == 1'b0)
                           begin
                             EbiTrGnt     <= 3'b100;
                             EbiTrBackoff <= 3'b000;
                             BackOffRegv  <= 2'b00; 
                             PTable[1]    <= PTable[0];
                             PTable[0]    <= 3'b100;
                           end
                         else if(DcrCnt3 == 1'b0 && DcrCnt1 == 1'b1)
                           begin
                             EbiTrGnt     <= 3'b001;
                             EbiTrBackoff <= 3'b000;
                             BackOffRegv  <= 2'b00; 
                             PTable[1]    <= PTable[0];
                             PTable[0]    <= 3'b001;
                           end
                         else if(DcrCnt3 == 1'b0 && DcrCnt1 == 1'b0)
                           begin
                             if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                               begin
                                  EbiTrGnt  <= 3'b100;
                                  PTable[1] <= PTable[0];
                                  PTable[0] <= 3'b100;
                               end
                             else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                               begin
                                  EbiTrGnt  <= 3'b001;
                                  PTable[1] <= PTable[0];
                                  PTable[0] <= 3'b001;
                               end
                           end
                         else if(DcrCnt3 == 1'b1 && DcrCnt1 == 1'b1)
                           begin
                             if(BackOffRegv == 2'b11) 
                               begin
                                  EbiTrGnt     <= 3'b100;
                                  EbiTrBackoff <= 3'b000;
                                  // BackOffRegv  <= 2'b01; 
                                  PTable[1]    <= PTable[0];
                                  PTable[0]    <= 3'b100;   
                               end
                             else if(BackOffRegv == 2'b01)   
                               begin
                                  EbiTrGnt     <= 3'b001;
                                  EbiTrBackoff <= 3'b000;
                                  // BackOffRegv  <= 2'b11; 
                                  PTable[1]    <= PTable[0];
                                  PTable[0]    <= 3'b001;  
                               end
                           end
                       end  
                   end 
                 else
                   begin
                     TrigCnt2 <= 1'b0;
                     if(BackOffRegv == 2'b11)
                       begin
                         EbiTrBackoff <= 3'b001;
                         BackOffRegv  <= 2'b00;
                       end  
                     else if(BackOffRegv == 2'b01)
                       begin
                         EbiTrBackoff <= 3'b100;
                         BackOffRegv  <= 2'b00;
                       end  
                     else if(BackOffRegv == 2'b10)
                       begin
                         if(DcrCnt3 == 1'b1)
                           begin
                             EbiTrBackoff <= 3'b001;
                             BackOffRegv  <= 2'b11 ;
                           end
                         else if(DcrCnt1 == 1'b1)
                           begin
                             EbiTrBackoff <= 3'b100;
                             BackOffRegv  <= 2'b01 ;
                           end
                         else
                           begin
                             EbiTrBackoff <= 3'b000;
                             BackOffRegv  <= 2'b00 ;
                           end
                       end  
                   end 
               end    
             3'b011 :
               begin
                 NState <=`STHREE;
                 if(EbiTrGnt == 3'b100)
                   begin
                     if(EBITIMEOUTVALUE2 == EBITIMEOUTVALUE1)
                       begin
                         if(TriSim21 == 1'b1)
                           begin
                             TriSim21 <= 1'b0;
                             if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                             begin
                                EbiTrGnt     <= 3'b010;
                                EbiTrBackoff <= 3'b000;
                                BackOffRegv  <= 2'b00; 
                                PTable[1]    <= PTable[0];
                                PTable[0]    <= 3'b010;
                                TrigCnt1     <= 1'b1;
                             end
                             else if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                             begin
                                EbiTrGnt     <= 3'b001;
                                EbiTrBackoff <= 3'b000;
                                BackOffRegv  <= 2'b00; 
                                PTable[1]    <= PTable[0];
                                PTable[0]    <= 3'b001;
                                TrigCnt2     <= 1'b1;
                             end
                           end
                         else
                           begin
                             if(DcrCnt2 == 1'b1 && DcrCnt1 == 1'b0)
                               begin
                                 EbiTrGnt     <= 3'b010;
                                 EbiTrBackoff <= 3'b000;
                                 BackOffRegv  <= 2'b00; 
                                 PTable[1]    <= PTable[0];
                                 PTable[0]    <= 3'b010;
                               end  
                             else if(DcrCnt2 == 1'b0 && DcrCnt1 == 1'b1)
                               begin
                                 EbiTrGnt     <= 3'b001;
                                 EbiTrBackoff <= 3'b000;
                                 BackOffRegv  <= 2'b00; 
                                 PTable[1]    <= PTable[0];
                                 PTable[0]    <= 3'b001;
                               end  
                             else if(DcrCnt2 == 1'b0 && DcrCnt1 == 1'b0)
                               begin
                                 if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                                   begin
                                      EbiTrGnt  <= 3'b010;
                                      PTable[1] <= PTable[0];
                                      PTable[0] <= 3'b010;
                                   end
                                 else if(PTable[0] == 3'b010 || 
                                                        PTable[1] == 3'b010)
                                   begin
                                      EbiTrGnt  <= 3'b001;
                                      PTable[1] <= PTable[0];
                                      PTable[0] <= 3'b001;
                                   end
                               end  
                             else if(DcrCnt2 == 1'b1 && DcrCnt1 == 1'b1)
                               begin
                                 if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                                   begin
                                      EbiTrGnt     <= 3'b010;
                                      EbiTrBackoff <= 3'b000;
                                      BackOffRegv  <= 2'b00; 
                                      PTable[1]    <= PTable[0];
                                      PTable[0]    <= 3'b010;
                                   end
                                 else if(PTable[0] == 3'b010 || 
                                                        PTable[1] == 3'b010)
                                   begin
                                      EbiTrGnt     <= 3'b001;
                                      EbiTrBackoff <= 3'b000;
                                      BackOffRegv  <= 2'b00; 
                                      PTable[1]    <= PTable[0];
                                      PTable[0]    <= 3'b001;
                                   end
                               end  
                           end
                       end
                     else
                       begin
                         if(DcrCnt2 == 1'b1 && DcrCnt1 == 1'b0)
                           begin
                             EbiTrGnt <= 3'b010;
                             if(DcrCnt3 == 1'b1)
                               EbiTrBackoff <= 3'b010;
                             else
                               EbiTrBackoff <= 3'b000;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b010;
                           end 
                         else if(DcrCnt2 == 1'b0 && DcrCnt1 == 1'b1)
                           begin
                             EbiTrGnt     <= 3'b001;
                             EbiTrBackoff <= 3'b000;
                             PTable[1]     <= PTable[0];
                             PTable[0]     <= 3'b001;
                           end 
                         else if(DcrCnt2 == 1'b0 && DcrCnt1 == 1'b0)
                           begin
                             if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                               begin
                                  EbiTrGnt   <= 3'b010;
                                  PTable[1]   <= PTable[0];
                                  PTable[0]   <= 3'b010;
                               end
                             else if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                               begin
                                  EbiTrGnt   <= 3'b001;
                                  PTable[1]   <= PTable[0];
                                  PTable[0]   <= 3'b001;
                               end
                           end 
                         else if(DcrCnt2 == 1'b1 && DcrCnt1 == 1'b1)
                           begin
                             if(BackOffRegv == 2'b10) 
                               begin
                                  EbiTrGnt     <= 3'b010;
                                  EbiTrBackoff <= 3'b000;
                                  // BackOffRegv  <= 2'b01; 
                                  PTable[1]     <= PTable[0];
                                  PTable[0]     <= 3'b010;   
                               end
                             else if(BackOffRegv == 2'b01)   
                               begin
                                  EbiTrGnt     <= 3'b001;
                                  EbiTrBackoff <= 3'b000;
                                  // BackOffRegv  <= 2'b10; 
                                  PTable[1]     <= PTable[0];
                                  PTable[0]     <= 3'b001;  
                               end
                           end
                       end  
                   end  
                 else
                   begin
                     TrigCnt3     <= 1'b0;
                     if(BackOffRegv == 2'b10)
                       begin
                         EbiTrBackoff <= 3'b001;
                         BackOffRegv   <= 2'b00;
                       end  
                     else if(BackOffRegv == 2'b01)
                       begin
                         EbiTrBackoff <= 3'b010;
                         BackOffRegv   <= 2'b00;
                       end  
                     else if(BackOffRegv == 2'b11)
                       begin
                         if(DcrCnt2 == 1'b1)
                           begin
                             EbiTrBackoff <= 3'b001;
                             BackOffRegv   <= 2'b10 ;
                           end
                         else if(DcrCnt1 == 1'b1)
                           begin
                             EbiTrBackoff <= 3'b010;
                             BackOffRegv   <= 2'b01 ;
                           end
                         else
                           begin
                             EbiTrBackoff <= 3'b000;
                             BackOffRegv   <= 2'b00 ;
                           end
                       end  
                   end 
               end    
             3'b110 : 
               begin
                 NState <=`SSIX;
                 if(EbiTrGnt == 3'b001)
                   begin
                     if(EBITIMEOUTVALUE2 == EBITIMEOUTVALUE3) 
                       begin
                         if(TriSim32 == 1'b1)
                           begin
                             TriSim32 <= 1'b0;
                             if(PTable[0] == 3'b010 || PTable[1] == 3'b010) 
                               begin
                                  EbiTrGnt     <= 3'b100;
                                  EbiTrBackoff <= 3'b000;
                                  BackOffRegv   <= 2'b00; 
                                  PTable[1]     <= PTable[0];
                                  PTable[0]     <= 3'b100;   
                                  TrigCnt2     <= 1'b1;
                               end 
                             else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)   
                               begin
                                  EbiTrGnt     <= 3'b010;
                                  EbiTrBackoff <= 3'b000;
                                  BackOffRegv   <= 2'b00; 
                                  PTable[1]     <= PTable[0];
                                  PTable[0]     <= 3'b010;  
                                  TrigCnt3     <= 1'b1;
                               end 
                           end
                         else
                           begin
                             if(DcrCnt2 == 1'b1 && DcrCnt3 == 1'b0)
                               begin
                                 EbiTrGnt     <= 3'b010;
                                 EbiTrBackoff <= 3'b000;
                                 BackOffRegv   <= 2'b00; 
                                 PTable[1] <= PTable[0];
                                 PTable[0] <= 3'b010;  
                               end   
                             else if(DcrCnt2 == 1'b0 && DcrCnt3 == 1'b1)
                               begin
                                 EbiTrGnt     <= 3'b100;
                                 EbiTrBackoff <= 3'b000;
                                 BackOffRegv   <= 2'b00; 
                                 PTable[1]     <= PTable[0];
                                 PTable[0]     <= 3'b100;   
                               end   
                             else if(DcrCnt2 == 1'b0 && DcrCnt3 == 1'b0)
                               begin
                                 if(PTable[0] == 3'b010 || PTable[1] == 3'b010) 
                                   begin
                                      EbiTrGnt     <= 3'b100;
                                      PTable[1]     <= PTable[0];
                                      PTable[0]     <= 3'b100;   
                                   end 
                                 else if(PTable[0] == 3'b100 || 
                                                        PTable[1] == 3'b100)   
                                   begin
                                      EbiTrGnt     <= 3'b010;
                                      PTable[1]     <= PTable[0];
                                      PTable[0]     <= 3'b010;  
                                   end 
                               end   
                             else if(DcrCnt2 == 1'b1 && DcrCnt3 == 1'b1)
                               begin
                                 if(PTable[0] == 3'b010 || PTable[1] == 3'b010) 
                                   begin
                                      EbiTrGnt     <= 3'b100;
                                      EbiTrBackoff <= 3'b000;
                                      BackOffRegv   <= 2'b00; 
                                      PTable[1]     <= PTable[0];
                                      PTable[0]     <= 3'b100;   
                                   end 
                                 else if(PTable[0] == 3'b100 || 
                                                        PTable[1] == 3'b100)   
                                   begin
                                      EbiTrGnt     <= 3'b010;
                                      EbiTrBackoff <= 3'b000;
                                      BackOffRegv   <= 2'b00; 
                                      PTable[1]     <= PTable[0];
                                      PTable[0]     <= 3'b010;  
                                   end 
                               end   
                           end
                       end  
                     else
                       begin
                         if(DcrCnt2 == 1'b1 && DcrCnt3 == 1'b0)
                           begin
                             EbiTrGnt     <= 3'b010;
                             EbiTrBackoff <= 3'b000;
                             PTable[1]     <= PTable[0];
                             PTable[0]     <= 3'b010;  
                           end
                         else if(DcrCnt2 == 1'b0 && DcrCnt3 == 1'b1)
                           begin
                             EbiTrGnt     <= 3'b100;
                             EbiTrBackoff <= 3'b000;
                             PTable[1]     <= PTable[0];
                             PTable[0]     <= 3'b100;   
                           end
                         else if(DcrCnt2 == 1'b0 && DcrCnt3 == 1'b0)
                           begin
                             if(PTable[0] == 3'b010 || PTable[1] == 3'b010) 
                               begin
                                 EbiTrGnt <= 3'b100;
                                 PTable[1] <= PTable[0];
                                 PTable[0] <= 3'b100;   
                               end 
                             else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)   
                               begin
                                 EbiTrGnt <= 3'b010;
                                 PTable[1] <= PTable[0];
                                 PTable[0] <= 3'b010;  
                               end 
                           end
                         else if(DcrCnt2 == 1'b1 && DcrCnt3 == 1'b1)
                           begin
                             if(BackOffRegv == 2'b10) 
                               begin
                                 EbiTrGnt     <= 3'b010;
                                 EbiTrBackoff <= 3'b000;
                                 // BackOffRegv  <= 2'b11; 
                                 PTable[1]     <= PTable[0];
                                 PTable[0]     <= 3'b010; 
                               end
                             else if(BackOffRegv == 2'b11)   
                               begin
                                 EbiTrGnt     <= 3'b100;
                                 EbiTrBackoff <= 3'b000;
                                 // BackOffRegv  <= 2'b10; 
                                 PTable[1]     <= PTable[0];
                                 PTable[0]     <= 3'b100;  
                               end
                           end
                       end  
                   end 
                 else
                   begin
                     TrigCnt1     <= 1'b0;
                     if(BackOffRegv == 2'b10)
                       begin
                         EbiTrBackoff <= 3'b100;
                         BackOffRegv   <= 2'b00;
                       end  
                     else if(BackOffRegv == 2'b11)
                       begin
                         EbiTrBackoff <= 3'b010;
                         BackOffRegv   <= 2'b00;
                       end  
                     else if(BackOffRegv == 2'b01)
                       begin
                         if(DcrCnt2 == 1'b1)
                           begin
                             EbiTrBackoff <= 3'b100;
                             BackOffRegv   <= 2'b10 ;
                           end
                         else if(DcrCnt3 == 1'b1)
                           begin
                             EbiTrBackoff <= 3'b010;
                             BackOffRegv   <= 2'b11 ;
                           end
                         else
                           begin
                             EbiTrBackoff <= 3'b000;
                             BackOffRegv   <= 2'b00 ;
                           end
                       end  
                   end 
               end    
             3'b111 : 
               begin
                 NState  <=`SSEVEN;
                 if(DcrCnt2 == 1'b1 && EbiTrBackoff != PTable[0])
                   begin 
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv   <= 2'b10;
                     TriSim32      <= 1'b0;
                     TriSim21      <= 1'b0;
                   end     
                 else if(DcrCnt3 == 1'b1 && EbiTrBackoff != PTable[0])
                   begin 
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv   <= 2'b11;
                     TriSim31      <= 1'b0;
                     TriSim32      <= 1'b0;
                   end     
                 else if(DcrCnt1 == 1'b1 && EbiTrBackoff != PTable[0])
                   begin 
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv   <= 2'b01;
                     TriSim21      <= 1'b0;
                     TriSim31      <= 1'b0;
                   end 
               end    
           endcase
        `STWO : 
           // -------------------------------------------------------------
           // STATE 2
           // In this state there is only one request from Port 2.
           // -------------------------------------------------------------
           // |------------|-----------------------------------------------
           // | Next State |            Comments
           // |------------|-----------------------------------------------
           // |    000     | When fsm is in state two and goes back to init
           // |            | state(state 8) indicates that Port 2 has
           // |            | released its request.
           // |------------|-----------------------------------------------
           // |    001     | Port 2 has released the request and Port 1
           // |            | has requested.Grant has to given to Port 1
           // |            | updating the PTable(priority table).
           // |------------|-----------------------------------------------
           // |    010     | Port 2 maintains the Request.
           // |------------|-----------------------------------------------
           // |    011     | Port 2 continues to maitain the request and
           // |            | Port 1 has requested.If Port 1 Time Out
           // |            | Counter value is zero then Backoff for Port 2
           // |            | is raised on the next clock else TrigCnt1
           // |            | signal is raised for decrementing the Port 1
           // |            | Time Out Counter.
           // |------------|-----------------------------------------------
           // |    100     | Port 2 has released the request and Port 3
           // |            | has requested.Grant has to given to Port 3
           // |            | updating the PTable(priority table).
           // |------------|-----------------------------------------------
           // |    110     | Port 2 continues to maitain the request and
           // |            | Port 3 has requested.If Port 3 Time Out
           // |            | Counter value is zero then Backoff for Port 2
           // |            | is raised on the next clock else TrigCnt3
           // |            | signal is raised for decrementing the Port 3
           // |            | Time Out Counter.
           // |------------|-----------------------------------------------
           // |    101     | Port 2 has released the request and Port 1
           // |            | and Port 3 has requested simultaneously.
           // |            | Based on PTbale either Port 1 or Port 3 is
           // |            | granted.
           // |            | If Port 1 is Granted, Port 3 Time Out
           // |            | Counter is Triggered after checking for non
           // |            | zero value.If the Port 3 Time Out Counter
           // |            | value is zero then back off for Port 2
           // |            | is given on next clock in state 5.This is
           // |            | because Grant and Backoff should not be given
           // |            | on the same clock.
           // |            | If Port 3 is Granted, Port 1 Time Out
           // |            | Counter is Triggered after checking for non
           // |            | zero value.If the Port 1 Time Out Counter
           // |            | value is zero then back off for Port 3
           // |            | is given on next clock in state 5.This is
           // |            | because Grant and Backoff should not be given
           // |            | on the same clock.
           // |            | TrigSim31 signal is raised.
           // |------------|-----------------------------------------------
           // |    111     | Here Port 2 continues to hold the request and
           // |            | port 1 and 3 simultaneously request.
           // |            | TriSim31 signal is raised.
           // |            | Backoff signal for Port 2 is generated
           // |            | on the next clock by checking for zero value
           // |            | of Time Out Counter of Port 1 or Port 3.
           // |            | If Time Out Counter values of Port 1 or
           // |            | Port 3 are non zeros then Trigger signals
           // |            | for appropriate Time Out Counter is raised
           // |            | to decrement.
           // |------------|-----------------------------------------------
           // -------------------------------------------------------------
           case ({EBIREQ3,EBIREQ2,EBIREQ1})
             3'b000 : 
               begin
                 NState <=`SEIGHT;
                 EbiTrGnt     <= 3'b000;  
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv   <= 2'b00; 
                 TriSim21      <= 1'b0;
                 TriSim31      <= 1'b0;
                 TriSim32      <= 1'b0;
               end
             3'b001 : 
               begin
                NState  <=`SONE;
                EbiTrGnt <= 3'b001;
                PTable[1] <= PTable[0];
                PTable[0] <= 3'b001;   
               end
             3'b010 :
               begin
                NState  <=`STWO;
               end
             3'b011 : 
               begin
                NState  <=`STHREE;
                EbiTrGnt <= 3'b010;  
                if(EBITIMEOUTVALUE1 == 10'b0000000000)
                begin
                  EbiTrBackoff <= 3'b010;
                  BackOffRegv  <= 2'b01; 
                end 
                else
                  TrigCnt1 <= 1'b1; 
               end 
             3'b100 : 
               begin
                NState  <=`SFOUR;
                EbiTrGnt <= 3'b100;
                PTable[1] <= PTable[0];
                PTable[0] <= 3'b100;   
               end
             3'b101 :
               begin
                 NState  <=`SFIVE;
                 TriSim31 <= 1'b1;
                 if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                   begin
                     if(TrigCnt3 == 1'b0)
                       begin
                         EbiTrGnt <= 3'b100;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b100;
                         if(EBITIMEOUTVALUE1 != 10'b0000000000) 
                           TrigCnt1  <= 1'b1; 
                       end 
                   end
                 else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                   begin
                     if(TrigCnt1 == 1'b0)
                       begin
                         EbiTrGnt <= 3'b001;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b001;
                         if(EBITIMEOUTVALUE3 != 10'b0000000000) 
                           TrigCnt3 <= 1'b1; 
                       end 
                   end
               end
             3'b110 : 
               begin
                 NState  <=`SSIX;
                 EbiTrGnt <= 3'b010;  
                 if(EBITIMEOUTVALUE3 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= 3'b010;
                     BackOffRegv   <= 2'b11; 
                   end 
                 else
                   TrigCnt3 <= 1'b1; 
               end
             3'b111 : 
               begin
                 NState  <=`SSEVEN;   
                 TriSim31  <= 1'b1;
                 if(EBITIMEOUTVALUE3 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= 3'b010;
                     BackOffRegv   <= 2'b00; 
                   end 
                 else
                   TrigCnt3 <= 1'b1; 
                 if(EBITIMEOUTVALUE1 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= 3'b010;
                     BackOffRegv   <= 2'b00; 
                   end 
                 else
                   TrigCnt1 <= 1'b1; 
               end
           endcase
        `SFOUR :
           // -------------------------------------------------------------
           // STATE 4
           // In this state there is only one request from Port 4.
           // -------------------------------------------------------------
           // |------------|-----------------------------------------------
           // | Next State |            Comments
           // |------------|-----------------------------------------------
           // |    000     | When fsm is in state four and goes back to
           // |            | init state(state 8) indicates that Port 3 has
           // |            | released its request.
           // |------------|-----------------------------------------------
           // |    100     | Port 3 maintains the Request.
           // |------------|-----------------------------------------------
           // |    010     | Port 3 has released the request and Port 2
           // |            | has requested.Grant has to given to Port 2
           // |            | updating the PTable(priority table).
           // |------------|-----------------------------------------------
           // |    110     | Port 3 continues to maitain the request and
           // |            | Port 2 has requested.If Port 2 Time Out
           // |            | Counter value is zero then Backoff for Port 3
           // |            | is raised on the next clock else TrigCnt2
           // |            | signal is raised for decrementing the Port 2
           // |            | Time Out Counter.
           // |------------|-----------------------------------------------
           // |    001     | Port 3 has released the request and Port 1
           // |            | has requested.Grant has to given to Port 1
           // |            | updating the PTable(priority table).
           // |------------|-----------------------------------------------
           // |    101     | Port 3 continues to maitain the request and
           // |            | Port 1 has requested.If Port 1 Time Out
           // |            | Counter value is zero then Backoff for Port 3
           // |            | is raised on the next clock else TrigCnt1
           // |            | signal is raised for decrementing the Port 1
           // |            | Time Out Counter.
           // |------------|-----------------------------------------------
           // |    011     | Port 3 has released the request and Port 2
           // |            | and Port 1 has requested simultaneously.
           // |            | Based on PTbale either Port 2 or Port 1 is
           // |            | granted.
           // |            | If Port 2 is Granted, Port 1 Time Out
           // |            | Counter is Triggered after checking for non
           // |            | zero value.If the Port 1 Time Out Counter
           // |            | value is zero then back off for Port 2
           // |            | is given on next clock in state 3.This is
           // |            | because Grant and Backoff should not be given
           // |            | on the same clock.
           // |            | If Port 1 is Granted, Port 2 Time Out
           // |            | Counter is Triggered after checking for non
           // |            | zero value.If the Port 2 Time Out Counter
           // |            | value is zero then back off for Port 1
           // |            | is given on next clock in state 3.This is
           // |            | because Grant and Backoff should not be given
           // |            | on the same clock.
           // |            | TrigSim21 signal is raised.
           // |------------|-----------------------------------------------
           // |    111     | Here Port 3 continues to hold the request and
           // |            | port 2 and 1 simultaneously request.
           // |            | TriSim21 signal is raised.
           // |            | Backoff signal for Port 3 is generated
           // |            | on the next clock by checking for zero value
           // |            | of Time Out Counter of Port 2 or Port 1.
           // |            | If Time Out Counter values of Port 2 or
           // |            | Port 1 are non zeros then Trigger signals
           // |            | for appropriate Time Out Counter is raised
           // |            | to decrement.
           // |------------|-----------------------------------------------
           // -------------------------------------------------------------
           case({EBIREQ3,EBIREQ2,EBIREQ1})
             3'b000 : 
               begin
                 NState <=`SEIGHT;
                 EbiTrGnt     <= 3'b000;  
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv   <= 2'b00; 
                 TriSim21      <= 1'b0;
                 TriSim32      <= 1'b0;
                 TriSim31      <= 1'b0;
               end
             3'b001 : 
               begin
                 NState <=`SONE;
                 EbiTrGnt <= 3'b001;
                 PTable[1] <= PTable[0];
                 PTable[0] <= 3'b001;   
               end
             3'b010 : 
               begin
                 NState <=`STWO;
                 EbiTrGnt <= 3'b010;
                 PTable[1] <= PTable[0];
                 PTable[0] <= 3'b010;   
               end
             3'b011 : 
               begin
                 NState <=`STHREE; 
                 TriSim21  <= 1'b1; 
                 if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                   begin
                     if(TrigCnt2 == 1'b0)
                       begin
                         EbiTrGnt <= 3'b010;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b010;
                         if(EBITIMEOUTVALUE1 != 10'b0000000000) 
                           TrigCnt1 <= 1'b1;
                       end
                   end
                 else if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                   begin
                     if(TrigCnt1 == 1'b0)
                       begin
                         EbiTrGnt <= 3'b001;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b001;
                         if(EBITIMEOUTVALUE2 != 10'b0000000000) 
                           TrigCnt2 <= 1'b1;
                       end
                   end
               end
             3'b100 : 
               begin
                 NState <=`SFOUR;
               end
             3'b101 :
             begin
              NState <=`SFIVE;
              EbiTrGnt <= 3'b100;  
              if(EBITIMEOUTVALUE1 == 10'b0000000000)
              begin
                EbiTrBackoff <= 3'b100;
                BackOffRegv   <= 2'b01; 
              end 
              else
                TrigCnt1 <= 1'b1; 
             end
             3'b110 : 
               begin
                 NState <=`SSIX;
                 EbiTrGnt <= 3'b100;  
                 if(EBITIMEOUTVALUE2 == 10'b0000000000)
                 begin
                   EbiTrBackoff <= 3'b100;
                   BackOffRegv  <= 2'b10; 
                 end 
                 else
                   TrigCnt2 <= 1'b1; 
               end
             3'b111 : 
               begin
                 NState <=`SSEVEN;   
                 TriSim21  <= 1'b1;
                 if(EBITIMEOUTVALUE2 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= 3'b100;
                     BackOffRegv   <= 2'b00; 
                   end 
                 else
                   TrigCnt2 <= 1'b1; 
                 if(EBITIMEOUTVALUE1 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= 3'b100;
                     BackOffRegv   <= 2'b00; 
                   end 
                 else
                   TrigCnt1 <= 1'b1; 
               end
           endcase
        `SSIX :
           // -------------------------------------------------------------
           // STATE 6
           // In this State there is Request from Port 3 and Port 2.
           // -------------------------------------------------------------
           // |------------|-----------------------------------------------
           // | Next State |            Comments
           // |------------|-----------------------------------------------
           // |    000     | From state six if Port 3 and Port 2 requests
           // |            | are deasserted then next state is init state
           // |            | (state eight).Clear BackoffReg and all Trigger
           // |            | counter signals.
           // |------------|-----------------------------------------------
           // |    010     | In this case Port 3 has deasserted the
           // |            | requested clear backoffreg and Grant is given
           // |            | to Port 2.The Priority Table is update only
           // |            | if the previous granted Port is not 2 ie
           // |            | Port 3.
           // |------------|-----------------------------------------------
           // |    100     | In this case Port 2 has deasserted the
           // |            | requested clear backoffreg and Grant is given
           // |            | to Port 3.The Priority Table is update only
           // |            | if the previous granted Port is not 3 ie
           // |            | Port 2.
           // |------------|-----------------------------------------------
           // |    110     | In this case if TrigSim32 flag is raised
           // |            | then it is clear that Port 3 and Port 2 has
           // |            | requested simultaneously.Time Out Counter
           // |            | values are check for zero value and a backoff
           // |            | is raised to the port that was granted and
           // |            | backoffreg is update with port id.
           // |            | Four condition are checked in this case:
           // |            | 1. DcrCnt2 = '1' and DcrCnt3 = '0'
           // |            |    which indicates that Time out value of
           // |            |    counter 2 has reached zero.Backoff signal
           // |            |    is raised to Port 3 and Backoffreg register
           // |            |    is updated with Port 3 id.
           // |            | 2. DcrCnt2 = '0' and DcrCnt3 = '1'
           // |            |    which indicates that Time out value of
           // |            |    counter 3 has reached zero.Backoff signal
           // |            |    is raised for Port 2 and Backoffreg
           // |            |    register is updated with Port 3 id.
           // |            | 3. DcrCnt2 = '1' and DcrCnt3 = '1'
           // |            |    which indicates that Time out value of
           // |            |    counter 3 has reached zero and also
           // |            |    Time out value of counter 2 has reached
           // |            |    reached zero.This case can happen only
           // |            |    when Port 1 has released the request and
           // |            |    both the ports Time Out Counter value has
           // |            |    reached zero.Now the Grant is given to
           // |            |    the Port whose id is in Backoffreg register.
           // |            |    The Backoffreg register contains the port
           // |            |    id whose Time Out Counter has reached zero
           // |            |    first.
           // |------------|-----------------------------------------------
           // |    001     | In this case both Port 3 and Port 2 requests
           // |            | are deasserted and Port 1 has made a request.
           // |            | The grant is given to Port 1.Backoffreg is
           // |            | cleared.PTable is updated.
           // |------------|-----------------------------------------------
           // |    101     | In this case clear the Trigger for Time Out
           // |            | Counter for Port 2.Port 1 has raised the
           // |            | raised the request.If previously granted
           // |            | port was 2 then Port 3 has to be granted and
           // |            | Trigger has to raised for decrementing the
           // |            | Time Out Counter of Port 3.If none of the
           // |            | above condition is true then a priority
           // |            | table decides which Port needs to be granted.
           // |            | Ptbale is updated in either case.
           // |------------|-----------------------------------------------
           // |    011     | In this case clear the Trigger for Time Out
           // |            | Counter for Port 3.Port 1 has raised the
           // |            | raised the request.If previously granted
           // |            | port was 3 then Port 2 has to be granted and
           // |            | Trigger has to raised for decrementing the
           // |            | Time Out Counter of Port 2.If none of the
           // |            | above condition is true then a priority
           // |            | table decides which Port needs to be granted.
           // |            | Ptbale is updated in either case.
           // |------------|-----------------------------------------------
           // |    111     | In this case Port 1 has raised the request
           // |            | while Port 3 and Port 2 already have their
           // |            | requests raised.If Port 1 Time Out Counter
           // |            | value is zero and no backoff signal is
           // |            | generated then backoff signal is raised to
           // |            | the Port that has been granted.Else Port 1
           // |            | Time Out Counter is Triggered for
           // |            | decrementing.Also If Time Out Counter for
           // |            | port 3 or Port 2 has reached zero backoff
           // |            | is generated for the Port currently granted.
           // |            | Backoffreg register is update with the port
           // |            | id which determines Port to be grantied next.
           // |------------|-----------------------------------------------
           // -------------------------------------------------------------
           case({EBIREQ3,EBIREQ2,EBIREQ1})
             3'b000 :
               begin
                 NState <=`SEIGHT;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv   <= 2'b00; 
                 EbiTrGnt     <= 3'b000;  
                 TrigCnt2     <= 1'b0;
                 TrigCnt3     <= 1'b0;
                 TrigCnt1     <= 1'b0;
                 Flag6To4      <= 1'b0;
                 Flag6To2      <= 1'b0;
                 TriSim21      <= 1'b0;
                 TriSim31      <= 1'b0;
                 TriSim32      <= 1'b0;
               end
             3'b001 :
               begin
                 NState <=`SONE;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv   <= 2'b00; 
                 EbiTrGnt     <= 3'b001;  
                 PTable[1]     <= PTable[0];
                 PTable[0]     <= 3'b001;
                 TrigCnt3     <= 1'b0;
                 TrigCnt2     <= 1'b0;
               end
             3'b010 :
               begin
                 NState <=`STWO;
                 EbiTrGnt     <= 3'b010;   
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv   <= 2'b00;
                 if(EbiTrGnt != 3'b010)  
                   begin 
                     PTable[1]     <= PTable[0];
                     PTable[0]     <= 3'b010;
                   end
                 Flag6To4      <= 1'b0;
                 Flag6To2      <= 1'b0;
                 TrigCnt3     <= 1'b0;
               end
             3'b011 :
               begin
                 NState <=`STHREE;
                 TrigCnt1     <= 1'b1;
                 TrigCnt3     <= 1'b0;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv   <= 2'b00; 
                 if(EbiTrGnt == 3'b100)
                   begin
                     if(DcrCnt2 == 1'b1)
                       begin
                         EbiTrGnt <= 3'b010;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b010; 
                         TrigCnt1 <= 1'b1;
                       end
                     else
                       begin
                         if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                           begin
                             EbiTrGnt  <= 3'b010;
                             PTable[1]  <= PTable[0];
                             PTable[0]  <= 3'b010;
                             TrigCnt1  <= 1'b1;
                           end
                         else if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                           begin
                             EbiTrGnt  <= 3'b001;
                             PTable[1]  <= PTable[0];
                             PTable[0]  <= 3'b001;
                             TrigCnt2  <= 1'b1;
                           end
                       end
                   end 
               end
             3'b100 : 
               begin
                 NState <=`SFOUR;
                 EbiTrGnt     <= 3'b100;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv   <= 2'b00; 
                 if(EbiTrGnt != 3'b100)  
                   begin
                     PTable[1] <= PTable[0];
                     PTable[0] <= 3'b100;
                   end
                 Flag6To4 <= 1'b0;
                 Flag6To2 <= 1'b0;
                 TrigCnt2 <= 1'b0;
               end
             3'b101 :
               begin
                 NState <=`SFIVE;
                 TrigCnt1 <= 1'b1;
                 TrigCnt2 <= 1'b0;
                 EbiTrBackoff <= 3'b000;
                 BackOffRegv   <= 2'b00; 
                 if(EbiTrGnt == 3'b010)
                   begin
                     if(DcrCnt3 == 1'b1)
                       begin
                         EbiTrGnt <= 3'b100;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b100; 
                         TrigCnt1 <= 1'b1;
                       end
                     else
                       begin
                         if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                         begin
                           EbiTrGnt  <= 3'b100;
                           PTable[1]  <= PTable[0];
                           PTable[0]  <= 3'b100;
                           TrigCnt1  = 1'b1;
                         end
                         else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                         begin
                           EbiTrGnt  <= 3'b001;
                           PTable[1]  <= PTable[0];
                           PTable[0]  <= 3'b001;
                           TrigCnt3  = 1'b1;
                         end
                       end
                   end 
               end
             3'b110 : 
               begin
                 NState <=`SSIX;
                 if(TriSim32 == 1'b1)
                   begin
                     if(EBITIMEOUTVALUE2 == 10'b0000000000 && 
                                                          EbiTrGnt == 3'b100)
                     begin
                       EbiTrBackoff <= 3'b100;
                       BackOffRegv  <= 2'b10;
                     end
                     if(EBITIMEOUTVALUE3 == 10'b0000000000 && 
                                                          EbiTrGnt == 3'b010)
                     begin
                       EbiTrBackoff <= 3'b010;
                       BackOffRegv   <= 2'b11;
                     end
                   end
                 if(DcrCnt2 == 1'b1 && DcrCnt3 == 1'b0)
                   begin
                     if(BackOffRegv == 2'b10 && Flag6To4 == 1'b0 && 
                                                            Flag6To2 == 1'b0) 
                       begin
                         // EbiTrBackoff <= 3'b010;
                         // BackOffRegv  <= 2'b11;
                         // Flag6To2     <= 1'b1;
                         EbiTrBackoff <= 3'b100;
                         BackOffRegv  <= 2'b10;
                         Flag6To2     <= 1'b1;
                       end
                     else if(BackOffRegv == 2'b11 && Flag6To4 == 1'b0 && 
                                                            Flag6To2 == 1'b0)
                       begin
                         // EbiTrBackoff <= 3'b100;
                         // BackOffRegv  <= 2'b10;
                         // Flag6To4     <= 1'b1;
                         EbiTrBackoff <= 3'b010;
                         BackOffRegv  <= 2'b11;
                         Flag6To4     <= 1'b1;
                       end
                     else 
                       begin
                         if(Flag6To4 == 1'b0 && Flag6To2 == 1'b0) 
                         begin
                           EbiTrBackoff <= 3'b100;
                           BackOffRegv   <= 2'b10; 
                           Flag6To2      <= 1'b1;
                           Flag6To4      <= 1'b1;
                           TriSim32      <= 1'b0;
                         end
                       end
                   end   
                 else if(DcrCnt2 == 1'b0 && DcrCnt3 == 1'b1)
                   begin
                     if(BackOffRegv == 2'b10 && Flag6To4 == 1'b0 && 
                                                            Flag6To2 == 1'b0) 
                       begin
                         // EbiTrBackoff <= 3'b010;
                         // BackOffRegv  <= 2'b11;
                         // Flag6To2     <= 1'b1;
                         EbiTrBackoff <= 3'b100;
                         BackOffRegv  <= 2'b10;
                         Flag6To4     <= 1'b1;
                       end
                     else if(BackOffRegv == 2'b11 && Flag6To4 == 1'b0 && 
                                                            Flag6To2 == 1'b0)
                       begin
                         // EbiTrBackoff <= 3'b100;
                         // BackOffRegv  <= 2'b10;
                         // Flag6To4     <= 1'b1;
                         EbiTrBackoff <= 3'b010;
                         BackOffRegv  <= 2'b11;
                         Flag6To2     <= 1'b1;
                       end
                     else
                       begin
                         if(Flag6To4 == 1'b0 && Flag6To2 == 1'b0) 
                           begin
                             EbiTrBackoff <= 3'b010;
                             BackOffRegv  <= 2'b11; 
                             Flag6To2     <= 1'b1;
                             Flag6To4     <= 1'b1;
                             TriSim32     <= 1'b0;
                           end
                       end
                   end   
                 else if(DcrCnt2 == 1'b1 && DcrCnt3 == 1'b1)
                   begin
                     if(BackOffRegv == 2'b10 && Flag6To4 == 1'b0 &&
                                                       Flag6To2 == 1'b0) 
                       begin
                          EbiTrGnt     <= 3'b010;
                          EbiTrBackoff <= 3'b010;
                          BackOffRegv  <= 2'b11;
                          Flag6To2     <= 1'b1;
                          Flag6To4     <= 1'b1;
                       end
                     else if(BackOffRegv == 2'b11 && Flag6To4 == 1'b0 &&
                                                            Flag6To2 == 1'b0)   
                       begin
                          EbiTrGnt     <= 3'b100;
                          EbiTrBackoff <= 3'b100;
                          BackOffRegv  <= 2'b10;
                          Flag6To2     <= 1'b1;
                          Flag6To4     <= 1'b1;
                       end
                   end   
               end
             3'b111 : 
               begin
                 NState  <=`SSEVEN;   
                 if(EBITIMEOUTVALUE1 == 10'b0000000000)
                   begin
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv  <= 2'b01; 
                     DcrCnt1      <= 1'b1;
                   end 
                 else
                   TrigCnt1 <= 1'b1; 
                 if(DcrCnt2 == 1'b1)
                   begin
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv <= 2'b10;
                   end     
                 else if(DcrCnt3 == 1'b1)
                   begin
                     EbiTrBackoff <= PTable[0];
                     BackOffRegv <= 2'b11;
                   end     
                 Flag6To4 <= 1'b0;
                 Flag6To2 <= 1'b0;
               end
           endcase
        `SEIGHT : 
           // -------------------------------------------------------------
           // STATE 8
           // In this state all the requests are deasserted.
           // -------------------------------------------------------------
           // In this state there is no requsets and the state machine
           // continues to be in this state until any one of the ports
           // request.The table below illustrates the logic implemented
           // depending on the requests from Port 1,Port 2 and Port 3.
           // |------------|-----------------------------------------------
           // | Next State |            Comments
           // |------------|-----------------------------------------------
           // |    000     | When there are no request no port are granted
           // |------------|-----------------------------------------------
           // |    001     | When there is a request from Port 1 if the
           // |            | if the previous port granted is not Port 1
           // |            | the priority table is update.Grant is given
           // |            | to Port 1.
           // |------------|-----------------------------------------------
           // |    010     | When there is a request from Port 2 if the
           // |            | if the previous port granted is not Port 2
           // |            | the priority table is update.Grant is given
           // |            | to Port 2.
           // |------------|-----------------------------------------------
           // |    011     | In this case there is a simulatneous request
           // |            | from Port 1 and Port 2.Based on the Priority
           // |            | table either Port 1 or Port 2 is granted.
           // |            | If Port 1 is granted,Port 2 Internal Time Out
           // |            | Counter is Triggered for decrementing if its
           // |            | value is not zero.
           // |            | If Port 2 is granted,Port 1 Internal Time Out
           // |            | Counter is Triggered for decrementing if its
           // |            | value is not zero.
           // |            | TrigSim21 Flag is raised to indicate it is
           // |            | simultaneous request from Port 1 and Port 2
           // |            | This signal is used in other state.
           // |------------|-----------------------------------------------
           // |    100     | When there is a request from Port 3 if the
           // |            | if the previous port granted is not Port 3
           // |            | the priority table is update.Grant is given
           // |            | to Port 3.
           // |------------|-----------------------------------------------
           // |    101     | In this case there is a simulatneous request
           // |            | from Port 3 and Port 1.Based on the Priority
           // |            | table either Port 3 or Port 1 is granted.
           // |            | If Port 3 is granted,Port 1 Internal Time Out
           // |            | Counter is Triggered for decrementing if its
           // |            | value is not zero.
           // |            | If Port 1 is granted,Port 3 Internal Time Out
           // |            | Counter is Triggered for decrementing if its
           // |            | value is not zero.
           // |            | TrigSim31 Flag is raised to indicate it is
           // |            | simultaneous request from Port 3 and Port 1
           // |            | This signal is used in other state.
           // |------------|-----------------------------------------------
           // |    110     | In this case there is a simulatneous request
           // |            | from Port 3 and Port 2.Based on the Priority
           // |            | table either Port 3 or Port 2 is granted.
           // |            | If Port 3 is granted,Port 2 Internal Time Out
           // |            | Counter is Triggered for decrementing if its
           // |            | value is not zero.
           // |            | If Port 2 is granted,Port 3 Internal Time Out
           // |            | Counter is Triggered for decrementing if its
           // |            | value is not zero.
           // |            | TrigSim32 Flag is raised to indicate it is
           // |            | simultaneous request from Port 3 and Port 2
           // |            | This signal is used in other state.
           // |------------|-----------------------------------------------
           // |    111     | In this case there is simultaneous request
           // |            | from Port 1,Port 2 and Port 3.Based on the
           // |            | priority table one of the ports is granted
           // |            | (least used) is granted.
           // |            | If Port 1 Granted:
           // |            | Port 2 and Port 3 Time Out Counter is checked
           // |            | for non zero value and Triggred for
           // |            | decrementing.
           // |            | If Port 2 Granted:
           // |            | Port 1 and Port 3 Time Out Counter is checked
           // |            | for non zero value and Triggred for
           // |            | decrementing.
           // |            | If Port 3 Granted:
           // |            | Port 2 and Port 1 Time Out Counter is checked
           // |            | for non zero value and Triggred for
           // |            | decrementing.
           // -------------------------------------------------------------
           case({EBIREQ3,EBIREQ2,EBIREQ1})
             3'b000 : 
               NState <=`SEIGHT;
             3'b001 :
               begin
                 NState <=`SONE;
                 EbiTrGnt  <= 3'b001;
                 if(PTable[0] != 3'b001)
                   begin
                     PTable[1] <= PTable[0];
                     PTable[0] <= 3'b001;
                   end
               end
             3'b010 : 
               begin
                NState <=`STWO;
                EbiTrGnt <= 3'b010;
                if(PTable[0] != 3'b010)
                  begin
                    PTable[1] <= PTable[0];
                    PTable[0] <= 3'b010;
                  end
               end
             3'b100 :
               begin
                 NState <=`SFOUR;
                 EbiTrGnt <= 3'b100;
                 if(PTable[0] != 3'b100)
                   begin
                     PTable[1] <= PTable[0];
                     PTable[0] <= 3'b100;
                   end
               end
             3'b011 : 
               begin
                 NState <=`STHREE;
                 TriSim21 <= 1'b1;
                 if(PTable[0] == 3'b100)
                   begin
                     if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                       begin
                         if(TrigCnt2 == 1'b0)
                           begin
                             EbiTrGnt <= 3'b010;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b010;
                             if(EBITIMEOUTVALUE1 != 10'b0000000000)
                               TrigCnt1 <= 1'b1;
                           end
                       end
                     else if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                       begin
                         if(TrigCnt1 == 1'b0)
                           begin
                             EbiTrGnt <= 3'b001;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b001;
                             if(EBITIMEOUTVALUE2 != 10'b0000000000)
                               TrigCnt2 <= 1'b1;
                           end
                       end
                   end
                 else
                   begin
                     if(PTable[0] == 3'b001)
                       begin
                         EbiTrGnt  <= 3'b010;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b010;
                         if(EBITIMEOUTVALUE1 != 10'b0000000000)
                           TrigCnt1 <= 1'b1;
                       end
                     else if(PTable[0] == 3'b010)
                       begin
                         EbiTrGnt <= 3'b001;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b001;
                         if(EBITIMEOUTVALUE2 != 10'b0000000000)
                           TrigCnt2 <= 1'b1;
                       end
                   end
               end
             3'b101 : 
               begin
                 NState <=`SFIVE;
                 TriSim31 <= 1'b1;
                 if(PTable[0] == 3'b010)
                   begin
                     if(PTable[0] == 3'b001 || PTable[1] == 3'b001)
                       begin
                         if(TrigCnt3 == 1'b0)
                           begin
                             EbiTrGnt <= 3'b100;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b100;
                             if(EBITIMEOUTVALUE1 != 10'b0000000000)
                               TrigCnt1 <= 1'b1;
                           end
                       end
                     else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                       begin
                         if(TrigCnt1 == 1'b0)
                           begin
                             EbiTrGnt <= 3'b001;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b001;
                             if(EBITIMEOUTVALUE3 != 10'b0000000000)
                               TrigCnt3 <= 1'b1;
                           end
                       end
                   end
                 else
                   begin
                     if(PTable[0] == 3'b001)
                       begin
                         EbiTrGnt  <= 3'b100;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b100;
                         if(EBITIMEOUTVALUE1 != 10'b0000000000)
                           TrigCnt1 <= 1'b1;
                       end
                     else if(PTable[0] == 3'b100)
                       begin
                         EbiTrGnt <= 3'b001;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b001;
                         if(EBITIMEOUTVALUE3 != 10'b0000000000)
                           TrigCnt3 <= 1'b1;
                       end
                   end
               end
             3'b110 : 
               begin
                 NState  <=`SSIX;
                 TriSim32 <= 1'b1;
                 if(PTable[0] == 3'b001)
                   begin
                     if(PTable[0] == 3'b010 || PTable[1] == 3'b010)
                       begin
                         if(TrigCnt3 == 1'b0)
                           begin
                             EbiTrGnt <= 3'b100;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b100;
                             if(EBITIMEOUTVALUE2 != 10'b0000000000)
                               TrigCnt2 <= 1'b1;
                           end
                       end
                     else if(PTable[0] == 3'b100 || PTable[1] == 3'b100)
                       begin
                         if(TrigCnt2 == 1'b0)
                           begin
                             EbiTrGnt <= 3'b010;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b010;
                             if(EBITIMEOUTVALUE3 != 10'b0000000000)
                               TrigCnt3 <= 1'b1;
                           end
                       end
                   end
                 else
                   begin
                     if(PTable[0] == 3'b100)
                       begin
                         EbiTrGnt <= 3'b010;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b010;
                         if(EBITIMEOUTVALUE3 != 10'b0000000000)
                           TrigCnt3 <= 1'b1;
                       end
                     else if(PTable[0] == 3'b010)
                       begin
                         EbiTrGnt <= 3'b100;
                         PTable[1] <= PTable[0];
                         PTable[0] <= 3'b100;
                         if(EBITIMEOUTVALUE2 != 10'b0000000000)
                           TrigCnt2 <= 1'b1;
                       end
                   end
               end
             3'b111 :
               begin
                 NState   <=`SSEVEN;
                 TriSim32  <= 1'b1;
                 TriSim31  <= 1'b1;
                 TriSim21  <= 1'b1;
                 case (PTable[0]) 
                   3'b001 :
                     begin
                       case (PTable[1])
                         3'b001 :
                           begin
                           end
                         3'b010 :
                           begin
                             TrigCnt1 <= 1'b1;
                             TrigCnt2 <= 1'b1;
                             EbiTrGnt <= 3'b100;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b100;
                             if(EBITIMEOUTVALUE2 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b100;
                                 BackOffRegv  <= 2'b10;
                               end
                             if(EBITIMEOUTVALUE1 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b100;
                                 BackOffRegv  <= 2'b01;
                               end
                           end
                         3'b100 :
                           begin
                             TrigCnt1 <= 1'b1;
                             TrigCnt3 <= 1'b1;
                             EbiTrGnt <= 3'b010;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b010;
                             if(EBITIMEOUTVALUE1 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b010;
                                 BackOffRegv  <= 2'b01;
                               end
                             if(EBITIMEOUTVALUE3 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b010;
                                 BackOffRegv  <= 2'b11;
                               end
                           end
                       endcase
                     end
                   3'b010 :
                     begin
                       case (PTable[1])
                         3'b001 :
                           begin
                             TrigCnt1 <= 1'b1;
                             TrigCnt2 <= 1'b1;
                             EbiTrGnt <= 3'b100;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b100;
                             if(EBITIMEOUTVALUE2 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b100;
                                 BackOffRegv  <= 2'b10;
                               end
                             if(EBITIMEOUTVALUE1 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b100;
                                 BackOffRegv  <= 2'b01;
                               end
                           end
                         3'b010 :
                           begin
                           end
                         3'b100 :
                           begin
                             TrigCnt2 <= 1'b1;
                             TrigCnt3 <= 1'b1;
                             EbiTrGnt <= 3'b001;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b001;
                             if(EBITIMEOUTVALUE2 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b001;
                                 BackOffRegv  <= 2'b10;
                               end
                             if(EBITIMEOUTVALUE3 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b001;
                                 BackOffRegv  <= 2'b11;
                               end
                           end
                       endcase
                     end
                   3'b100 :
                     begin
                       case (PTable[1])
                         3'b001 :
                           begin
                             TrigCnt1 <= 1'b1;
                             TrigCnt3 <= 1'b1;
                             EbiTrGnt <= 3'b010;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b010;
                             if(EBITIMEOUTVALUE1 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b010;
                                 BackOffRegv  <= 2'b01;
                               end
                             if(EBITIMEOUTVALUE3 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b010;
                                 BackOffRegv  <= 2'b11;
                               end
                           end
                         3'b010 :
                           begin
                             TrigCnt2 <= 1'b1;
                             TrigCnt3 <= 1'b1;
                             EbiTrGnt <= 3'b001;
                             PTable[1] <= PTable[0];
                             PTable[0] <= 3'b001;
                             if(EBITIMEOUTVALUE2 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b001;
                                 BackOffRegv  <= 2'b10;
                               end
                             if(EBITIMEOUTVALUE3 == 10'b0000000000)
                               begin
                                 EbiTrBackoff <= 3'b001;
                                 BackOffRegv  <= 2'b11;
                               end
                           end
                         3'b100 :
                           begin
                           end
                       endcase
                     end
                 endcase
               end
           endcase
      endcase
      BackOffReg <= BackOffRegv ;
  end
end  // p_main;
// -----------------------------------------------------------------------------
// Next State Assignment 
// -----------------------------------------------------------------------------
assign CState = NState;    

endmodule 

// -================================== End ==================================-
