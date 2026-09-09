// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : command_reader.v,v 
// File Revision       : 1.2 
// 
// Release Information : PL160-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : Handwritten Verilog for BIF command file Interface.
//                       For insertion within translated code reader.v
//                       Events for flow control between main thread and input
//                       task list. Event GET_NEXT_COMMAND is driven by the main
//                       READER thread to request another packet from the input
//                       command sequence.  All input tasks wait for this event.
//                       Event FINISH_NEXT_COMMAND is driven by the input
//                       command tasks to return control to the READER thread.
// --=========================================================================--

  event GET_NEXT_COMMAND, FINISH_NEXT_COMMAND;

// Task for updating main thread test packets (V_..._PACKETs) from values
// assigned by the next task in the input command list.

task READLINE;

begin
  -> GET_NEXT_COMMAND;
  @(FINISH_NEXT_COMMAND);
end
endtask

// APB Cycle Command Task Definitions

task NW;
input [31:0] DATA;
input [31:0] ADDRESS;
input [159:0] TAG;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1            = `T_CYCLE_C_PNW;
  V_APB_PACKET_SEL_1     = 0;
  V_APB_PACKET_WRITE_1   = 1;
  V_APB_PACKET_ADDR_1    = ADDRESS;
  V_APB_PACKET_DATA_1    = DATA;
  V_APB_PACKET_NUM_CYC_1 = 2;
  V_APB_PACKET_TAG_1     = TAG;
  -> FINISH_NEXT_COMMAND;
end
endtask

task LW;
input [31:0] DATA;
input [31:0] ADDRESS;
input [159:0] TAG;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1            = `T_CYCLE_C_PSW;
  V_APB_PACKET_SEL_1     = 1;
  V_APB_PACKET_WRITE_1   = 1;
  V_APB_PACKET_ADDR_1    = ADDRESS;
  V_APB_PACKET_DATA_1    = DATA;
  V_APB_PACKET_NUM_CYC_1 = 2;
  V_APB_PACKET_TAG_1     = TAG;
  -> FINISH_NEXT_COMMAND;
end
endtask

task NR;
input [31:0] ADDRESS;
input [159:0] TAG;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1            = `T_CYCLE_C_PNR;
  V_APB_PACKET_SEL_1     = 0;
  V_APB_PACKET_WRITE_1   = 0;
  V_APB_PACKET_ADDR_1    = ADDRESS;
  V_APB_PACKET_NUM_CYC_1 = 2;
  V_APB_PACKET_TAG_1     = TAG;
  -> FINISH_NEXT_COMMAND;
end
endtask

task LR;
input [31:0] EXPECTED;
input [31:0] MASK;
input [31:0] ADDRESS;
input [159:0] TAG;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1            = `T_CYCLE_C_PSR;
  V_APB_PACKET_SEL_1     = 1;
  V_APB_PACKET_WRITE_1   = 0;
  V_APB_PACKET_EXP_1     = EXPECTED;
  V_APB_PACKET_MASK_1    = MASK;
  V_APB_PACKET_ADDR_1    = ADDRESS;
  V_APB_PACKET_NUM_CYC_1 = 2;
  V_APB_PACKET_TAG_1     = TAG;
  -> FINISH_NEXT_COMMAND;
end
endtask

task PI;
input [7:0] CYCLES;
input [159:0] TAG;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1            = `T_CYCLE_C_PI;
  V_APB_PACKET_SEL_1     = 0;
  V_APB_PACKET_NUM_CYC_1 = CYCLES;
  V_APB_PACKET_TAG_1     = TAG;
  -> FINISH_NEXT_COMMAND;
end
endtask

// Poll command

task PO;
input [31:0]  EXPECTED;
input [31:0]  MASK;
input [31:0]  ADDRESS;
input [7:0]   LIMIT;
input [159:0] TAG;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1            = `T_CYCLE_C_PO;
  V_APB_PACKET_SEL_1     = 1;
  V_APB_PACKET_WRITE_1   = 0;
  V_APB_PACKET_NUM_CYC_1 = 2;
  V_APB_PACKET_TAG_1     = TAG;
  V_APB_PACKET_EXP_1     = EXPECTED;
  V_APB_PACKET_MASK_1    = MASK;
  V_APB_PACKET_ADDR_1    = ADDRESS;
  V_APB_PACKET_LIMIT_1   = LIMIT;
end
endtask


// Virtual Register Command Definitions

task VR;
input [16:0] REGISTER;
input [31:0] EXPECTED;
input [31:0] MASK;
input [7:0]  EDGE;
input [7:0]  DELAY;
input [159:0] TAG;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1           = `T_CYCLE_C_VR;
  V_VR_PACKET_WRITE_1   = 0;
  V_VR_PACKET_EXP_1     = EXPECTED;
  V_VR_PACKET_MASK_1    = MASK;
  V_VR_PACKET_EDGE_1    = (EDGE == "/");      // EDGE is 1 for character / only
  V_VR_PACKET_VREGNO_1  = REGISTER[7:0] - "0";// character to integer conversion
  V_VR_PACKET_DELAY_1   = DELAY;
  V_VR_PACKET_TAG_1     = TAG;
  -> FINISH_NEXT_COMMAND;
end
endtask

task VW;
input [16:0] REGISTER;
input [31:0] DATA;
input [31:0] MASK;
input [7:0]  PHASE;
input [7:0]  DELAY;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1           = `T_CYCLE_C_VW;
  V_VR_PACKET_WRITE_1   = 1;
  V_VR_PACKET_DATA_1    = DATA;
  V_VR_PACKET_MASK_1    = MASK;
  V_VR_PACKET_PHASE_1   = (PHASE == "H");     // PHASE is 1 for character H only
  V_VR_PACKET_VREGNO_1  = REGISTER[7:0] - "0";// character to integer conversion
  V_VR_PACKET_DELAY_1   = DELAY;
  -> FINISH_NEXT_COMMAND;
end
endtask

// Bus Reset Command Task Definition

task RE;
input [7:0]  PHASE;
input [7:0]  DELAY;
input [7:0]  COUNT;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1           = `T_CYCLE_C_RES;
  V_RES_PACKET_PHASE_1  = (PHASE == "H");    // _PHASE is 1 for character H only
  V_RES_PACKET_DELAY_1  = DELAY;
  V_RES_PACKET_NUM_CYC_1= COUNT;
  -> FINISH_NEXT_COMMAND;
end
endtask

// Test End Command Task Definition

task TE;

begin
  @(GET_NEXT_COMMAND);
  V_CYC_SEL_1           = `T_CYCLE_C_END;
  -> FINISH_NEXT_COMMAND;
end
endtask


// This procedure executes the list of test commands from the input sim file

initial

begin
   
  // Read in simulation command file

    `include "../reader/infile.sim"

end

// End of included code for reading the modified BIF command file

// --================================= End ===================================--
