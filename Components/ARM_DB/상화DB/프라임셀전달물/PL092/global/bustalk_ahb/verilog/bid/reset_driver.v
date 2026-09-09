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
// Version  and  Release Control Information:
//
// File Name              : reset_driver.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
//
// ---------------------------------------------------------------------
//
// Purpose :
//           Drives AHB Reset signal 
//
// --=================================================================--

`timescale 1ns/1ps
`include "../common/defs.v"
`include "../tbench/timing.v"

// ---------------------------------------------------------------------
 
module reset_driver ( 
                     RCycSel,
                     HCLK,
                     ResPhase,
                     ResDelay,
                     ResNumcyc,
                     HRESETn
                    );
parameter
   reset_del = 2,
   Verbosity = 0;

input   [3:0]     RCycSel;  
// Denotes Reset cycle
input             HCLK;      
// AHB Clock
input             ResPhase;  
// RES command Phase field 
input   [7:0]     ResDelay;  
// RES command Delay field 
input   [7:0]     ResNumcyc; 
// RES command Numcyc field
output            HRESETn;   
// AHB Reset

// ---------------------------------------------------------------------
//
//                             reset_driver
//                             ============
//
// ---------------------------------------------------------------------
//
// Overview : 
// ==========
//   To drive HRESETn line low on the correct phase  and  hold it low
// for defined time. It gets the phase info in the first delay high
// phase and uses it in the last delay cycle to start timing the reset
// length
// To drive the HRESETn line driver with rdrv timing (idle,delay,reset)
// This is a vr type cycle but onto an AHB line, so I owns its own
// block as a compromise.  The timing of the rdrv signal is shown below
// for one delay, high phase drive, one reset cycle
//     _   _   _   _
//  __/ \_/ \_/ \_/ \__  CLK
//  __<S>______________  RESSEL
//  __<DDDDDXRRR>______  STATE
//
// There are two counters instanced herein, one for delay  and  the
// other for numcyc
//
// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
reg        IPhase;  
//  holds which phase of BCLK reset is driven low
 
reg  [7:0] VAL_DELAY;          
// Value loaded for inserting delay

reg  [7:0] VAL_RESET;          
// Value loaded for asserting reset 

reg  [1:0] R_STATE;            
// Reset State machine

reg        Rscyc;                   
// Retry/Split cycle

reg        Inres;                   
// Internal Reset signal

reg  [7:0] I_NUMCYC;
// Internal Numcycle value  

wire [7:0] LAST_DELAY;         
// Denotes last cycle of delay

wire [7:0] Lastreset;         
// Denotes last cycle of reset

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Assigning local copy to output 
// ---------------------------------------------------------------------
assign   HRESETn = Inres; 

// ---------------------------------------------------------------------
// This process loads the counters with the timing values.  Note that
// the delay counter is loaded with an incremented value because
// a delay of 0 is equivalent to a cycle of 1 etc.
// ---------------------------------------------------------------------
always @ (RCycSel) 
begin : loader 
  //variable Inumcyc : T_int;
  if ((RCycSel === `T_CYCLE_C_RES) & R_STATE === `T_RESET_R_IDLE) 
    begin
      VAL_DELAY <= ResDelay;
      IPhase    <= ResPhase;
    end
  else 
      VAL_DELAY <= 8'b00000000;
end 

// ---------------------------------------------------------------------
// Reset State machine
// ---------------------------------------------------------------------
always @( posedge (HCLK) )
begin
   case (R_STATE)
        `T_RESET_R_IDLE :
           if ((RCycSel === `T_CYCLE_C_RES))
             if ((ResDelay === 8'b00000000))
               begin
                 R_STATE <= `T_RESET_R_RES;
                 VAL_RESET <= ResNumcyc;
                 if (ResPhase === 0)
                   Inres = #(`Tclkh + reset_del) 1'b0; // assert HRESETn
                 else
                   Inres = #(reset_del) 1'b0; // assert HRESETn 
               end
             else
              R_STATE <= `T_RESET_R_DEL;
          else
           Inres =  1'b1;    
 
        `T_RESET_R_DEL :
           if (LAST_DELAY === 8'b00000001)
             begin
               R_STATE   <= `T_RESET_R_RES;
               VAL_RESET <= ResNumcyc;
               if (IPhase ===  0)
                 Inres = #(`Tclkh + reset_del) 1'b0; 
               else
                 Inres = #(reset_del) 1'b0; 
             end
 
        `T_RESET_R_RES :
           begin
             VAL_RESET <= 0;
             if (Lastreset === 8'b00000010 || VAL_RESET === 8'b00000001)
               begin
                R_STATE <= `T_RESET_R_IDLE;
                // Inres = # `Tihrst 1'bX;
                Inres = # `Tihrst 1'b0;
                Inres = #(`Tclk - `Tisrst) 1'b1;
               end
            end
        default  :
          R_STATE <= `T_RESET_R_IDLE;
      endcase
end

// ---------------------------------------------------------------------
//  The following process prints out status change information of the
//  reset signal at the time it occurs the low HCLK phase of the
//  previous cycle.
// ---------------------------------------------------------------------
always @ (Inres)
begin : reportres 
    if (Verbosity) 
      ReportReset(Inres);
end //reportres 

initial
begin
  $timeformat(-9, 0, " ns", 13);
  R_STATE = `T_RESET_R_IDLE;
  Rscyc = 1'b0;
  Inres = 1'b1;
end     
   
// ---------------------------------------------------------------------
// Countdown module Instantiation
// ---------------------------------------------------------------------
countdown U_countdowndelay 
          (
           .HCLK       (HCLK),
           .VAL        (VAL_DELAY),
           .LAST       (LAST_DELAY),
           .Rscyc      (Rscyc)
           );

// ---------------------------------------------------------------------
// Countdown module Instantiation
// ---------------------------------------------------------------------
countdown  U_countdownreset 
          (
           .HCLK       (HCLK),
           .VAL        (VAL_RESET),
           .LAST       (Lastreset),
           .Rscyc      (Rscyc)
           );

// ---------------------------------------------------------------------
// ReportReset task
// Checks for reset getting asserted and deasserted 
// ---------------------------------------------------------------------
task ReportReset;
 
input Inres;
  begin
    if (!Inres)
      $display("Note : %t: RESL: HRESETn asserted (LOW)", $time) ;
    else if (Inres)
      $display("Note : %t: RESH: HRESETn deasserted (HIGH)", $time);
  end
endtask

// ---------------------------------------------------------------------
endmodule

// --============================= End ===============================--
