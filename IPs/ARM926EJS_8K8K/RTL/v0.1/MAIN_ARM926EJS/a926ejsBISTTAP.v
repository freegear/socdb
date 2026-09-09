// -------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorised
// by a licensing agreement from ARM Limited
//                (c) COPYRIGHT 2003 ARM Limited
//                ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised copies and
// copies may only be made to the extent permitted by a licensing agreement
// from ARM Limited.
// -------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : a926ejsBISTTAP.v,v
// File Revision       : 1.1
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------


module a926ejsBISTTAP (/*AUTOARG*/
   // Outputs
   BISTEnable, BISTStart, TDO, TDOEN, 
   // Inputs
   CLK, HRESETn, BISTStatus, TCK, TDI, TMS, nTRST
   );

   input         CLK;
   input         HRESETn;
   output [13:0] BISTEnable;
   input [27:0]  BISTStatus;
   output        BISTStart;

   input         TCK;
   input         TDI;
   input         TMS;
   output        TDO;
   output        TDOEN;
   input         nTRST;
   
   reg [31:0]    EnableReg;
   wire [31:0]   StatusReg;
   reg [31:0]    WriteMiscReg;
   wire [31:0]   ReadMiscReg;
   reg [31:0]    ShiftIn;
   reg [31:0]    ShiftOut;
   reg           BISTStart;
   wire          PreStart;

   reg           WriteEnables;
   reg           ReadStatus;
   reg           ReadMisc;
   reg           WriteMisc;

   wire          clock_dr;
   wire          shift_dr;
   wire          update_dr;
   wire          extest;
   wire          samp_load;
   wire [2:0]    instructions;
   wire          sync_capture_en;
   wire          sync_update_dr;
   wire          so;
   wire          inst_bypass_sel;

`define BTap_Extest    3'b000 // Mandatory instruction
`define BTap_IDCode    3'b001 // Mandatory instruction
`define BTap_Sample    3'b010 // Mandatory instruction
`define BTap_WriteMisc 3'b011 // User instruction
`define BTap_Enable    3'b100 // User instruction
`define BTap_Status    3'b101 // User instruction
`define BTap_ReadMisc  3'b110 // User instruction
`define BTap_Bypass    3'b111 // Mandatory instruction

   assign StatusReg[27:0] = BISTStatus;
   assign StatusReg[31:28] = 4'b0;
   assign PreStart = ShiftIn[31] & sync_update_dr & WriteEnables;
   assign BISTEnable = EnableReg[13:0];
   always @(posedge CLK or negedge HRESETn)
     begin
        if (!HRESETn)
          BISTStart <= 1'b0;
        else
          BISTStart <= PreStart;
     end

  // Instantiate the IEEE 1149.1 TAP
  //
  // TAP must be replaced with partners' own TAP prior to synthesis / place & 
  // route, unless a DesignWare Foundation License is available.
  //

  // instruction register width
  parameter width = 3;
  // build the id register
  parameter id = 1;
  // manufacturers' version number
  parameter version = 4'b1001;
  // manufacturers' part number. the top 8 bits should be 1001,1110
  parameter part = 16'b1001111011100001;
  // manufacturers' JDEC number
  parameter man_num = 11'b00000110110;
  // access to bypass, device id and instruction registers is synchronius to tck
  parameter sync_mode = 1;

  // device identification register structure:
  //
  // 31------28|27------12|11----------1|0
  // | version |   part   |   man_num   |1

DW_tap #(width, id, version, part, man_num, sync_mode)
  uDW_tap
  (
  //outputs
  .clock_dr          (clock_dr),
  .shift_dr          (shift_dr),
  .update_dr         (update_dr),
  .tdo               (TDO),
  .tdo_en            (TDOEN), 
  .tap_state         (),
  .extest            (extest),
  .samp_load         (samp_load),
  .instructions      (instructions[width-1:0]),
  .sync_capture_en   (sync_capture_en),
  .sync_update_dr    (sync_update_dr),
  //inputs
  .tck               (TCK),
  .trst_n            (nTRST),
  .tms               (TMS),
  .tdi               (TDI),
  .so                (so),
  .bypass_sel        (inst_bypass_sel),
  .sentinel_val      (2'd0)
  );

   // Perform "user" decoding of the instruction from instructions[2:0]:
   always @(instructions)
     begin
        WriteEnables = 1'b0;
        ReadStatus = 1'b0;
        ReadMisc = 1'b0;
        WriteMisc = 1'b0;
        case (instructions[2:0])
          `BTap_Enable: WriteEnables = 1'b1;
          `BTap_Status: ReadStatus = 1'b1;
          `BTap_ReadMisc: ReadMisc = 1'b1;
          `BTap_WriteMisc: WriteMisc = 1'b1;
        endcase
     end
   assign inst_bypass_sel = 1'b0;//WriteEnables | ReadStatus | ReadMisc | WriteMisc;

   always @(posedge CLK)
     begin
        if (sync_update_dr & WriteEnables)
          EnableReg <= ShiftIn;
     end
   always @(posedge CLK)
     begin
        if (sync_update_dr & WriteMisc)
          WriteMiscReg <= ShiftIn;
     end
   always @(posedge CLK)
     begin
        if (shift_dr)
          ShiftIn <= {ShiftIn[30:0], TDI};
     end
   always @(posedge CLK)
     begin
        if (shift_dr)
          ShiftOut <= {ShiftOut[30:0], TDI};
        else if (sync_capture_en)
          begin
             if (ReadStatus)
               ShiftOut <= StatusReg;
             else if (WriteEnables)
               ShiftOut <= EnableReg;
             else if (ReadMisc)
               ShiftOut <= ReadMiscReg;
             else if (WriteMisc)
               ShiftOut <= WriteMiscReg;
          end
     end
   assign so = ShiftOut[31];

endmodule
