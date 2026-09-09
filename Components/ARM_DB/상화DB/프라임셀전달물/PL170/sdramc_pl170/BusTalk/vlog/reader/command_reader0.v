// -----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : command_reader0.v,v
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
// -----------------------------------------------------------------------------
//
// Purpose   : Reads a line from infile.sim and forms the corresponding packets.
//
// -----------------------------------------------------------------------------
event GETNEXTCOMMAND, FINISHNEXTCOMMAND;
 
// Task for updating main thread test packets (V_..._PACKETs) from values
// assigned by the next task in the input command list.
 
`uselib dir=../common
 
// -----------------------------------------------------------------------------
task READCOMMAND;
begin
  -> GETNEXTCOMMAND;
  @(FINISHNEXTCOMMAND);
end
endtask 

// -----------------------------------------------------------------------------
// BID Cycle Command Task Definitions

// -----------------------------------------------------------------------------
// Write Command 
// -----------------------------------------------------------------------------
task SW;
input [63:0] DATA;
input [31:0] ADDRESS;
input [(8 * 1 - 1):0] TRANS;
input [(8 * 3 - 1):0] BURST;
input [(8 * 2 - 1):0] RESP;
input [(8 * 1 - 1):0] SIZE;
input [31:0] LIMIT;
input [3:0] MASTER;
input MASTLOCK;
input [7:0]NUMCYC;
input [31:0]IDLE_CYC;
input [31:0]RSLIMIT;
input [(8 * 1 - 1):0] SUPP_MSG;
input PROT;
input [(8 * 20 - 1):0] TAG;
begin
  @(GETNEXTCOMMAND);
  VCycSel      = `T_CYCLE_C_SW;
  VBidData     = DATA;
  VBidAddr     = ADDRESS;
  VBidWrite    = 1;
  VBidLimit    = LIMIT;
  VBidMasnum   = MASTER;
  VBidMaslock  = MASTLOCK;
  VBidNumcyc   = NUMCYC;
  VBidIdlcyc   = IDLE_CYC;
  VBidRslimit  = RSLIMIT;
  VBidSuppmsg  = (SUPP_MSG == `T_SUPPMSG)   ? 1'b1 :
                 (SUPP_MSG == `T_NOSUPPMSG) ? 1'b0 : 1'b0;
  VBidProt     =  {PROT,PROT,PROT,PROT};
  VBidResp     = (RESP == `T_RESP_OK)    ? 2'b00 :
                 (RESP == `T_RESP_ERROR) ? 2'b01 :
                 (RESP == `T_RESP_RETRY) ? 2'b10 :
                 (RESP == `T_RESP_SPLIT) ? 2'b11 :
                                           2'b11 ;

   VBidSize    =  (SIZE == `T_SIZE_BYTE)  ? 3'b000 :
                  (SIZE == `T_SIZE_HWRD)  ? 3'b001 :
                  (SIZE == `T_SIZE_WRD)   ? 3'b010 :
                  (SIZE == `T_SIZE_DWRD)  ? 3'b011 :
                                            3'b111 ;

   VBidTrans   = (TRANS == `T_TRANS_IDLE) ? 2'b00 :
                 (TRANS == `T_TRANS_BUSY) ? 2'b01 :
                 (TRANS == `T_TRANS_NSEQ) ? 2'b10 :
                 (TRANS == `T_TRANS_SEQ)  ? 2'b11 :
                                            2'b11 ;

   VBidBurst   = (BURST == `T_BURST_SINGLE) ? 3'b000:
                 (BURST == `T_BURST_INCR)   ? 3'b001:
                 (BURST == `T_BURST_INCR4)  ? 3'b011:
                 (BURST == `T_BURST_INCR8)  ? 3'b101:
                 (BURST == `T_BURST_INCR16) ? 3'b111:
                 (BURST == `T_BURST_WRAP4)  ? 3'b010:
                 (BURST == `T_BURST_WRAP8)  ? 3'b100:
                 (BURST == `T_BURST_WRAP16) ? 3'b110:
                                              3'b111;    
   VBidTag     = TAG;
  -> FINISHNEXTCOMMAND;
end
endtask

// -----------------------------------------------------------------------------
// Read Command
// -----------------------------------------------------------------------------
task SR;
input [63:0]           EXPVAL;
input [63:0]           MASK;
input [31:0]           ADDRESS;
input [(8 * 1 - 1):0]  TRANS;
input [(8 * 3 - 1):0]  BURST;
input [(8 * 2 - 1):0]  RESP;
input [(8 * 1 - 1):0]  SIZE;
input [31:0]           LIMIT;
input [3:0]            MASTER;
input                  MASTLOCK;
input [7:0]            NUMCYC;
input [31:0]           IDLE_CYC;
input [31:0]           RSLIMIT;
input [(8 * 1 - 1):0]  SUPP_MSG;
input PROT;
input [(8 * 20 - 1):0] TAG;
begin
  @(GETNEXTCOMMAND);
  VCycSel      = `T_CYCLE_C_SR;
  VBidExp      = EXPVAL;
  VBidMask     = MASK;
  VBidAddr     = ADDRESS;
  VBidWrite    = 0;
  VBidLimit    = LIMIT;
  VBidMasnum   = MASTER;
  VBidMaslock  = MASTLOCK;
  VBidNumcyc   = NUMCYC;
  VBidIdlcyc   = IDLE_CYC;
  VBidRslimit  = RSLIMIT;
  VBidSuppmsg  = (SUPP_MSG == `T_SUPPMSG)   ? 1'b1 :
                 (SUPP_MSG == `T_NOSUPPMSG) ? 1'b0 : 1'b0;
  VBidProt     =  {PROT,PROT,PROT,PROT};
  VBidResp     = (RESP == `T_RESP_OK)    ? 2'b00 :
                 (RESP == `T_RESP_ERROR) ? 2'b01 :
                 (RESP == `T_RESP_RETRY) ? 2'b10 :
                 (RESP == `T_RESP_SPLIT) ? 2'b11 : 2'b11 ;

   VBidSize    = (SIZE == `T_SIZE_BYTE)  ? 3'b000 :
                 (SIZE == `T_SIZE_HWRD)  ? 3'b001 :
                 (SIZE == `T_SIZE_WRD)   ? 3'b010 :
                 (SIZE == `T_SIZE_DWRD)  ? 3'b011 : 3'b111 ;

   VBidTrans   = (TRANS == `T_TRANS_IDLE) ? 2'b00 :
                 (TRANS == `T_TRANS_BUSY) ? 2'b01 :
                 (TRANS == `T_TRANS_NSEQ) ? 2'b10 :
                 (TRANS == `T_TRANS_SEQ)  ? 2'b11 : 2'b11 ;

   VBidBurst   = (BURST == `T_BURST_SINGLE) ? 3'b000:
                 (BURST == `T_BURST_INCR)   ? 3'b001:
                 (BURST == `T_BURST_INCR4)  ? 3'b011:
                 (BURST == `T_BURST_INCR8)  ? 3'b101:
                 (BURST == `T_BURST_INCR16) ? 3'b111:
                 (BURST == `T_BURST_WRAP4)  ? 3'b010:
                 (BURST == `T_BURST_WRAP8)  ? 3'b100:
                 (BURST == `T_BURST_WRAP16) ? 3'b110:
                                              3'b111;

   VBidTag     = TAG;

  -> FINISHNEXTCOMMAND;
end
endtask

// -----------------------------------------------------------------------------
// HSPLIT Command
// -----------------------------------------------------------------------------
task SP;
input [15:0] MASTERNUM;
input [7:0] NUMCYC0;
input [7:0] NUMCYC1;
input [7:0] NUMCYC2;
input [7:0] NUMCYC3;
input [7:0] NUMCYC4;
input [7:0] NUMCYC5;
input [7:0] NUMCYC6;
input [7:0] NUMCYC7;
input [7:0] NUMCYC8;
input [7:0] NUMCYC9;
input [7:0] NUMCYC10;
input [7:0] NUMCYC11;
input [7:0] NUMCYC12;
input [7:0] NUMCYC13;
input [7:0] NUMCYC14;
input [7:0] NUMCYC15;
input [7:0] Limit;
begin
  @(GETNEXTCOMMAND);
  VCycSel      = `T_CYCLE_C_SPLIT;
  VSpExpmas    = MASTERNUM;
  VSpNumcyc0   = NUMCYC0;
  VSpNumcyc1   = NUMCYC1;
  VSpNumcyc2   = NUMCYC2;
  VSpNumcyc3   = NUMCYC3;
  VSpNumcyc4   = NUMCYC4;
  VSpNumcyc5   = NUMCYC5;
  VSpNumcyc6   = NUMCYC6;
  VSpNumcyc7   = NUMCYC7;
  VSpNumcyc8   = NUMCYC8;
  VSpNumcyc9   = NUMCYC9;
  VSpNumcyc10  = NUMCYC10;
  VSpNumcyc11  = NUMCYC11;
  VSpNumcyc10  = NUMCYC12;
  VSpNumcyc10  = NUMCYC13;
  VSpNumcyc10  = NUMCYC14;
  VSpNumcyc10  = NUMCYC15;
  VSpLimit     = Limit;
  -> FINISHNEXTCOMMAND;
end
endtask

// -----------------------------------------------------------------------------
// Endianness command
// -----------------------------------------------------------------------------
task EN;
input [7:0] ENDIAN;
begin
  @(GETNEXTCOMMAND);
  VCycSel   = `T_CYCLE_C_ENDIAN;
  VEnEndian = (ENDIAN == `T_ENDIAN_LITTLE) ? 2'b00 :
              (ENDIAN == `T_ENDIAN_BIG)    ? 2'b01 : 
              (ENDIAN == `T_ENDIAN_DISABLE)? 2'b10 : 2'b00;
  -> FINISHNEXTCOMMAND;
end
endtask

// -----------------------------------------------------------------------------
// Virtual Register Command Definitions
// -----------------------------------------------------------------------------
task VR;
input [16:0]  REGISTER;
input [31:0]  EXPECTED;
input [31:0]  MASK;
input [7:0]   EDGE;
input [7:0]   DELAY;
input [159:0] TAG;
begin
  @(GETNEXTCOMMAND);
  VCycSel   = `T_CYCLE_C_VR;
  VVRWrite  = 0;
  VVRExp    = EXPECTED;
  VVRMask   = MASK;
  VVREdge   = (EDGE == "/");      // EDGE is 1 for character / only
  VVRVregno = REGISTER[7:0] - "0";// character to integer conversion
  VVRDelay  = DELAY;
  VVRTag    = TAG;
  -> FINISHNEXTCOMMAND;
end
endtask

task VW;
input [16:0] REGISTER;
input [31:0] DATA;
input [31:0] MASK;
input [7:0]  PHASE;
input [7:0]  DELAY;
 
begin
  @(GETNEXTCOMMAND);
  VCycSel   = `T_CYCLE_C_VW;
  VVRWrite  = 1;
  VVRData   = DATA;
  VVRMask   = MASK;
  VVRPhase  = (PHASE == "H");     // PHASE is 1 for character H only
  VVRVregno = REGISTER[7:0] - "0";// character to integer conversion
  VVRDelay  = DELAY;
  -> FINISHNEXTCOMMAND;
end
endtask

// -----------------------------------------------------------------------------
// Bus Reset Command Task Definition
// -----------------------------------------------------------------------------
 
task RE;
input [7:0] PHASE;
input [7:0] DELAY;
input [7:0] COUNT;
begin
  @(GETNEXTCOMMAND);
  VCycSel     = `T_CYCLE_C_RES;
  VResPhase   = (PHASE == "H");  // _PHASE is 1 for character H only
  VResDelay   = DELAY;
  VResNumcyc  = COUNT;
  -> FINISHNEXTCOMMAND;
end
endtask

// -----------------------------------------------------------------------------
// Test End Command Task Definition
// -----------------------------------------------------------------------------
 
task TE;
begin
  @(GETNEXTCOMMAND);
  VCycSel = `T_CYCLE_C_END;
  -> FINISHNEXTCOMMAND;
end
endtask

// -----------------------------------------------------------------------------
// This procedure executes the list of test commands from the input sim file
// -----------------------------------------------------------------------------
initial
begin
  // Read in simulation command file
  `include "../reader/infile0.sim"
end

// End of included code for reading the modified BIF command file

// ================================== End =================================== --
