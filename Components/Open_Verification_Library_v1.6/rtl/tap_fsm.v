// Accellera Copyright (c) 2006. All rights reserved.

// Test Access Port (TAP) Controller State Machine
// ===============================================
// State machine, as specified in IEEE 1149.1

// States
`define Test_Logic_Reset 4'b0000
`define Run_Test_Idle    4'b0001
`define Select_DR_Scan   4'b0010
`define Capture_DR       4'b0011
`define Shift_DR         4'b0100
`define Exit1_DR         4'b0101
`define Pause_DR         4'b0110
`define Exit2_DR         4'b0111
`define Update_DR        4'b1000
`define Select_IR_Scan   4'b1001
`define Capture_IR       4'b1010
`define Shift_IR         4'b1011
`define Exit1_IR         4'b1100
`define Pause_IR         4'b1101
`define Exit2_IR         4'b1110
`define Update_IR        4'b1111

// TAP Controller
module tap_fsm (tck, trst_n, tms, state);
   input        tck, tms, trst_n;
   output [3:0] state;
   reg    [3:0] state, nxt_state;
   
   always @ (posedge tck or negedge trst_n)
     if (~trst_n)
       state <= `Test_Logic_Reset;
     else
       state <= nxt_state;

   always @ (tms or state)
     case (state)
       `Test_Logic_Reset : nxt_state = tms ? `Test_Logic_Reset : `Run_Test_Idle;
       `Run_Test_Idle    : nxt_state = tms ? `Select_DR_Scan   : `Run_Test_Idle;
       `Select_DR_Scan   : nxt_state = tms ? `Select_IR_Scan   : `Capture_DR;
       `Capture_DR       : nxt_state = tms ? `Exit1_DR         : `Shift_DR;
       `Shift_DR         : nxt_state = tms ? `Exit1_DR         : `Shift_DR;
       `Exit1_DR         : nxt_state = tms ? `Update_DR        : `Pause_DR;
       `Pause_DR         : nxt_state = tms ? `Exit2_DR         : `Pause_DR;
       `Exit2_DR         : nxt_state = tms ? `Update_DR        : `Shift_DR;
       `Update_DR        : nxt_state = tms ? `Select_DR_Scan   : `Run_Test_Idle;
       `Select_IR_Scan   : nxt_state = tms ? `Test_Logic_Reset : `Capture_IR;
       `Capture_IR       : nxt_state = tms ? `Exit1_IR         : `Shift_IR;
       `Shift_IR         : nxt_state = tms ? `Exit1_IR         : `Shift_IR;
       `Exit1_IR         : nxt_state = tms ? `Update_IR        : `Pause_IR;
       `Pause_IR         : nxt_state = tms ? `Exit2_IR         : `Pause_IR;
       `Exit2_IR         : nxt_state = tms ? `Update_IR        : `Shift_IR;
       `Update_IR        : nxt_state = tms ? `Select_DR_Scan   : `Run_Test_Idle;
       default           : nxt_state = 4'bXXXX; // X propagation
     endcase // case(state)

`ifdef OVL_ASSERT_ON
   `include "std_ovl_defines.h"
   
   // 1) Specification property (high value OVL: not obvious from RTL)
   assert_cycle_sequence #(`OVL_ERROR,6,`OVL_TRIGGER_ON_MOST_PIPE,`OVL_ASSERT,"TAP fsm will be synchronously reset Test_Logic_Reset if tms is high for 5 cycles")
     u_tms_sync_rst (tck, trst_n, {tms,tms,tms,tms,tms,state==`Test_Logic_Reset});
   //
   // Sanity check: change first tms in sequence to ~tms, to see failing path that needs 5 cycles

   // 2) X Checker (could go X if tms is X, or if states were incorrectly encoded
   assert_never_unknown #(`OVL_ERROR,4,`OVL_ASSERT,"TAP fsm should never go X or Z")
     u_state_x (tck, trst_n, 1'b1, state);

   // 3) FSM Check (low value OVL: simply repeats RTL)
   assert_transition #(`OVL_ERROR,4,`OVL_ASSERT,"Can only change from Test_Logic_Reset to Run_Test_Idle")
     u_fsm_1 (tck, trst_n, state, `Test_Logic_Reset, `Run_Test_Idle);
   
`endif

endmodule // tap_fsm
