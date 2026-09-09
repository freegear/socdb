// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1998 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : reset_driver.v.rca 
// File Revision       : 1.1 
// 
// Release Information : PrimeCell(TM)-GLOBAL-r8p0-00rel0 
// 
// -----------------------------------------------------------------------------
// Purpose             : BnRES signal driver
// --=========================================================================--

`timescale 1ns/1ps

module RESET_DRIVER (RES_SEL, BCLK, RES_PACKET_PHASE, RES_PACKET_DELAY,
                     RES_PACKET_NUM_CYC, BNRES);
   parameter
      Tclkl = 50,
      Tisnres = 50,
      Tihnres = 0,
      reset_del = 5,
      Verbosity = 0;

  `include "../common/defs.v"
 
  input [3:0] RES_SEL;
  input BCLK;
  input RES_PACKET_PHASE;
  input [7:0] RES_PACKET_DELAY;
  input [7:0] RES_PACKET_NUM_CYC;
  output BNRES;
  wire [7:0] VAL_DELAY;
  wire [7:0] VAL_RESET;
  wire [7:0] LAST_DELAY;
  wire [7:0] LAST_RESET;
  wire [1:0] R_STATE;
  wire I_NRES;

  reg  I_PHASE;  //  holds which phase of BCLK reset is driven low
 
  reg [7:0] reg_VAL_DELAY;
  assign VAL_DELAY = reg_VAL_DELAY;
 
  reg [7:0] reg_VAL_RESET;
  assign VAL_RESET = reg_VAL_RESET;
 
  reg [1:0] reg_R_STATE;
  assign R_STATE = reg_R_STATE;
 
  reg reg_I_NRES;
  assign I_NRES = reg_I_NRES;
  assign BNRES = I_NRES;

  initial 
  begin
    reg_I_NRES = 1'b1;
  end
 
  always @(RES_SEL)
  begin
    //     variable i_num_cyc : T_int;
    if ((RES_SEL === `T_CYCLE_C_RES))
      begin
        reg_VAL_DELAY <= RES_PACKET_DELAY;
        I_PHASE <= RES_PACKET_PHASE;
      end
    else
      reg_VAL_DELAY <= 0;
  end
 
  //  Reset state machine is now synchronous with falling edge of BCLK
  //  Sequence of states is idle -> optionally delay -> reset -> idle.
  //  Asynchronous trigger res_sel starts a reset cycle, synchronous down
  //  counters determine number of cyles in delay and reset states.

  always @( negedge (BCLK) )
  begin
 
      case (R_STATE)
        `T_RESET_R_IDLE :
          if ((RES_SEL === `T_CYCLE_C_RES))
            if ((RES_PACKET_DELAY === 0))
            begin
              reg_R_STATE <= `T_RESET_R_RES;
              reg_VAL_RESET <= RES_PACKET_NUM_CYC;
              if (I_PHASE === 1 )
                reg_I_NRES = #(Tclkl + reset_del) 1'b0; // assert BnRES
              else 
                reg_I_NRES = #(reset_del) 1'b0; // assert BnRES on low BCLK
            end
            else
              reg_R_STATE <= `T_RESET_R_DEL;
          else
            reg_I_NRES =  1'b1;    // simulator reset sets BnRES
 
        `T_RESET_R_DEL :
          if (LAST_DELAY === 1)
          begin
            reg_R_STATE <= `T_RESET_R_RES;
            reg_VAL_RESET <= RES_PACKET_NUM_CYC;
            if (I_PHASE)
              reg_I_NRES = #(Tclkl + reset_del) 1'b0; // assert BnRES
            else 
              reg_I_NRES = #(reset_del) 1'b0; // assert BnRES on low BCLK
          end
 
        `T_RESET_R_RES :
        begin
          reg_VAL_RESET <= 0;
          if (LAST_RESET === 2 || VAL_RESET === 1)
            begin
              reg_R_STATE <= `T_RESET_R_IDLE;
              reg_I_NRES = #reset_del 1'b1;
              reg_I_NRES = #(Tclkl  - Tisnres  - Tihnres ) 1'b1; 
                                             //  then drive it high
           end 
        end
        default  :
          reg_R_STATE <= `T_RESET_R_IDLE;
      endcase
 
 
  end
 
  always @(I_NRES)
  begin
    if (Verbosity)
      REPORTRESET (I_NRES);
 
  end
 
  COUNTDOWN  U_COUNTDOWN_DELAY
    (.BCLK(BCLK),
     .VAL(VAL_DELAY),
     .LAST(LAST_DELAY));
 
  COUNTDOWN  U_COUNTDOWN_RESET
    (.BCLK(BCLK),
     .VAL(VAL_RESET),
     .LAST(LAST_RESET));

 
  task REPORTRESET;
 
    input NRES;
  begin
    if (!NRES)
      $display("%t: RESL: BnRES asserted (LOW)", $time) ;
    else if (NRES)
      $display("%t: RESH: BnRES deasserted (HIGH)", $time);
  end
  endtask

endmodule

// --================================= End ===================================--
