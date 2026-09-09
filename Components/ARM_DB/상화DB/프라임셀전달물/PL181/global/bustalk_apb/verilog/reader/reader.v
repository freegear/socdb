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
// File Name              : reader.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
//
// ---------------------------------------------------------------------
// Purpose : BusTalk reader module
//
// --=================================================================--

`timescale 1ns/1ps

module READER (PCLK, APB_GET_LINE, VR_GET_LINE, APB_PACKET_SEL, 
               APB_PACKET_WRITE, APB_PACKET_ADDR, APB_PACKET_DATA, 
               APB_PACKET_MASK, APB_PACKET_EXP, APB_PACKET_NUM_CYC, 
               APB_PACKET_TAG, APB_PACKET_LIMIT, VR_PACKET_VREGNO, 
               VR_PACKET_DATA, VR_PACKET_MASK, VR_PACKET_EXP, 
               VR_PACKET_WRITE, VR_PACKET_PHASE, VR_PACKET_EDGE, 
               VR_PACKET_DELAY, VR_PACKET_TAG, RES_PACKET_PHASE, 
               RES_PACKET_DELAY, RES_PACKET_NUM_CYC, PCYC_SEL,
               VCYC_SEL, RCYC_SEL, POSTATI);
   
      parameter
            Tclkl = 50,
            Tclkh = 50;
  
  `include "../common/defs.v"

  //  buffer variables
 
 
  input PCLK;
  input APB_GET_LINE;
  input VR_GET_LINE;
  output APB_PACKET_SEL;
  output APB_PACKET_WRITE;
  output [31:0] APB_PACKET_ADDR;
  output [31:0] APB_PACKET_DATA;
  output [31:0] APB_PACKET_MASK;
  output [31:0] APB_PACKET_EXP;
  output [7:0] APB_PACKET_NUM_CYC;
  output [31:0] APB_PACKET_LIMIT;
  output [159:0] APB_PACKET_TAG;
  output [(8 * 3 - 1):0] VR_PACKET_VREGNO;
  output [(8 * 32 - 1):0] VR_PACKET_DATA;
  output [(8 * 32 - 1):0] VR_PACKET_MASK;
  output [(8 * 32 - 1):0] VR_PACKET_EXP;
  output [(8 - 1):0] VR_PACKET_WRITE;
  output [(8 - 1):0] VR_PACKET_PHASE;
  output [(8 - 1):0] VR_PACKET_EDGE;
  output [(8 * 8 - 1):0] VR_PACKET_DELAY;
  output [(8 * 160 - 1):0] VR_PACKET_TAG;
  output RES_PACKET_PHASE;
  output [7:0] RES_PACKET_DELAY;
  output [7:0] RES_PACKET_NUM_CYC;
  output [3:0] PCYC_SEL;
  output [(8 * 4 - 1):0] VCYC_SEL;
  output [3:0] RCYC_SEL;
  output POSTATI;

  wire I_CLK;
  //  These flags are set in the low phase and read in the high phase
  //  to indicate which lines have to be driven
  //  These w_ signals are for IPC as write storage
  wire TEST_END;
 
  reg I_TEST_END;
  assign TEST_END = I_TEST_END;
 
  reg [7:0] W_RES_PACKET_NUM_CYC;
  reg [7:0] W_RES_PACKET_DELAY;
  reg W_RES_PACKET_PHASE;
  reg [3:0] W_RCYC_SEL;
  reg [3:0] W_PCYC_SEL;
  reg [7:0] W_APB_PACKET_NUM_CYC;
  reg [31:0] W_APB_PACKET_LIMIT;
  reg [31:0] W_APB_PACKET_EXP;
  reg [31:0] W_APB_PACKET_MASK;
  reg [31:0] W_APB_PACKET_DATA;
  reg [31:0] W_APB_PACKET_ADDR;
  reg W_APB_PACKET_WRITE;
  reg W_APB_PACKET_SEL;
  reg [3:0] W_VCYC_SEL [(8 - 1):0];
  reg [7:0] W_VR_PACKET_DELAY [(8 - 1):0];
  reg W_VR_PACKET_EDGE [(8 - 1):0];
  reg W_VR_PACKET_PHASE [(8 - 1):0];
  reg W_VR_PACKET_WRITE [(8 - 1):0];
  reg [(32 - 1):0] W_VR_PACKET_EXP [(8 - 1):0];
  reg [(32 - 1):0] W_VR_PACKET_MASK [(8 - 1):0];
  reg [(32 - 1):0] W_VR_PACKET_DATA [(8 - 1):0];
  reg [3:0] W_VR_PACKET_VREGNO [(8 - 1):0];

  reg [159:0] W_VR_PACKET_TAG [(8 - 1):0], W_APB_PACKET_TAG;
  
  reg APB_STORED;
  reg VR_STORED [(8 - 1):0];
  reg RES_STORED;
  reg POSTATI;
 
// Most VR data is stored in eight-word memory arrays

  reg [3:0] LATCHED_VCYC_SEL [7:0], LATCHED_PCYC_SEL, LATCHED_RCYC_SEL;
 
  reg [3:0] I_VR_PACKET_VREGNO [(8 - 1):0];
  assign VR_PACKET_VREGNO = {I_VR_PACKET_VREGNO[7],
                             I_VR_PACKET_VREGNO[6],
                             I_VR_PACKET_VREGNO[5],
                             I_VR_PACKET_VREGNO[4],
                             I_VR_PACKET_VREGNO[3],
                             I_VR_PACKET_VREGNO[2],
                             I_VR_PACKET_VREGNO[1],
                             I_VR_PACKET_VREGNO[0]};
 
  reg [(32 - 1):0] I_VR_PACKET_DATA [(8 - 1):0];
  assign VR_PACKET_DATA = {I_VR_PACKET_DATA[7],
                           I_VR_PACKET_DATA[6],
                           I_VR_PACKET_DATA[5],
                           I_VR_PACKET_DATA[4],
                           I_VR_PACKET_DATA[3],
                           I_VR_PACKET_DATA[2],
                           I_VR_PACKET_DATA[1],
                           I_VR_PACKET_DATA[0]};

  reg [(32 - 1):0] I_VR_PACKET_MASK [(8 - 1):0];
  assign VR_PACKET_MASK = {I_VR_PACKET_MASK[7],
                           I_VR_PACKET_MASK[6],
                           I_VR_PACKET_MASK[5],
                           I_VR_PACKET_MASK[4],
                           I_VR_PACKET_MASK[3],
                           I_VR_PACKET_MASK[2],
                           I_VR_PACKET_MASK[1],
                           I_VR_PACKET_MASK[0]};
 
  reg [(32 - 1):0] I_VR_PACKET_EXP [(8 - 1):0];
  assign VR_PACKET_EXP = {I_VR_PACKET_EXP[7],
                          I_VR_PACKET_EXP[6],
                          I_VR_PACKET_EXP[5],
                          I_VR_PACKET_EXP[4],
                          I_VR_PACKET_EXP[3],
                          I_VR_PACKET_EXP[2],
                          I_VR_PACKET_EXP[1],
                          I_VR_PACKET_EXP[0]};
 
// Edge, phase, and write mode data stored in simple register arrays

  reg [(8 - 1):0] I_VR_PACKET_WRITE;
  assign VR_PACKET_WRITE = I_VR_PACKET_WRITE;
 
  reg [(8 - 1):0] I_VR_PACKET_PHASE;
  assign VR_PACKET_PHASE = I_VR_PACKET_PHASE;
 
  reg [(8 - 1):0] I_VR_PACKET_EDGE;
  assign VR_PACKET_EDGE = I_VR_PACKET_EDGE;
 
  reg [7:0] I_VR_PACKET_DELAY [(8 - 1):0];
  assign VR_PACKET_DELAY = {I_VR_PACKET_DELAY[7],
                            I_VR_PACKET_DELAY[6],
                            I_VR_PACKET_DELAY[5],
                            I_VR_PACKET_DELAY[4],
                            I_VR_PACKET_DELAY[3],
                            I_VR_PACKET_DELAY[2],
                            I_VR_PACKET_DELAY[1],
                            I_VR_PACKET_DELAY[0]};
 
  reg [159:0] I_VR_PACKET_TAG [(8 - 1):0];
  assign VR_PACKET_TAG = {I_VR_PACKET_TAG[7],
                          I_VR_PACKET_TAG[6],
                          I_VR_PACKET_TAG[5],
                          I_VR_PACKET_TAG[4],
                          I_VR_PACKET_TAG[3],
                          I_VR_PACKET_TAG[2],
                          I_VR_PACKET_TAG[1],
                          I_VR_PACKET_TAG[0]};
 
  reg [7:0] I_RES_PACKET_NUM_CYC;
  assign RES_PACKET_NUM_CYC = I_RES_PACKET_NUM_CYC;
 
  reg [7:0] I_RES_PACKET_DELAY;
  assign RES_PACKET_DELAY = I_RES_PACKET_DELAY;
 
  reg I_RES_PACKET_PHASE;
  assign RES_PACKET_PHASE = I_RES_PACKET_PHASE;
 
  reg [7:0] I_APB_PACKET_NUM_CYC;
  assign APB_PACKET_NUM_CYC = I_APB_PACKET_NUM_CYC;
 
  reg [31:0] I_APB_PACKET_LIMIT;
  assign APB_PACKET_LIMIT = I_APB_PACKET_LIMIT;
 
  reg [31:0] I_APB_PACKET_EXP;
  assign APB_PACKET_EXP = I_APB_PACKET_EXP;
 
  reg [31:0] I_APB_PACKET_MASK;
  assign APB_PACKET_MASK = I_APB_PACKET_MASK;
 
  reg [31:0] I_APB_PACKET_DATA;
  assign APB_PACKET_DATA = I_APB_PACKET_DATA;
 
  reg [31:0] I_APB_PACKET_ADDR;
  assign APB_PACKET_ADDR = I_APB_PACKET_ADDR;
 
  reg I_APB_PACKET_WRITE;
  assign APB_PACKET_WRITE = I_APB_PACKET_WRITE;
 
  reg I_APB_PACKET_SEL;
  assign APB_PACKET_SEL = I_APB_PACKET_SEL;
 
  reg [3:0] I_RCYC_SEL;
  assign RCYC_SEL = I_RCYC_SEL;
 
  reg [3:0] I_PCYC_SEL;
  assign PCYC_SEL = I_PCYC_SEL;
 
  assign #1  I_CLK = PCLK;

  //  temporary registers for holding packet values returned from 
  //  READLINE task
  reg [3:0] V_CYC_SEL_1;
  reg V_APB_PACKET_SEL_1;
  reg V_APB_PACKET_WRITE_1;
  reg [31:0] V_APB_PACKET_ADDR_1;
  reg [31:0] V_APB_PACKET_DATA_1;
  reg [31:0] V_APB_PACKET_MASK_1;
  reg [31:0] V_APB_PACKET_EXP_1;
  reg [7:0] V_APB_PACKET_NUM_CYC_1;
  reg [31:0] V_APB_PACKET_LIMIT_1;
  reg [159:0] V_APB_PACKET_TAG_1;
  reg [3:0] V_VR_PACKET_VREGNO_1;
  reg [(32 - 1):0] V_VR_PACKET_DATA_1;
  reg [(32 - 1):0] V_VR_PACKET_MASK_1;
  reg [(32 - 1):0] V_VR_PACKET_EXP_1;
  reg V_VR_PACKET_WRITE_1;
  reg V_VR_PACKET_PHASE_1;
  reg V_VR_PACKET_EDGE_1;
  reg [7:0] V_VR_PACKET_DELAY_1;
  reg [159:0] V_VR_PACKET_TAG_1;
  reg V_RES_PACKET_PHASE_1;
  reg [7:0] V_RES_PACKET_DELAY_1;
  reg [7:0] V_RES_PACKET_NUM_CYC_1;

  //  buffer variables
  reg [3:0] B_CYC_SEL_1;
  reg [3:0] B_VCYC_SEL_1;
  reg B_APB_PACKET_SEL_1;
  reg B_APB_PACKET_WRITE_1;
  reg [31:0] B_APB_PACKET_ADDR_1;
  reg [31:0] B_APB_PACKET_DATA_1;
  reg [31:0] B_APB_PACKET_MASK_1;
  reg [31:0] B_APB_PACKET_EXP_1;
  reg [7:0] B_APB_PACKET_NUM_CYC_1;
  reg [31:0] B_APB_PACKET_LIMIT_1;
  reg [159:0] B_APB_PACKET_TAG_1;
  reg [3:0] B_VR_PACKET_VREGNO_1;
  reg [(32 - 1):0] B_VR_PACKET_DATA_1;
  reg [(32 - 1):0] B_VR_PACKET_MASK_1;
  reg [(32 - 1):0] B_VR_PACKET_EXP_1;
  reg B_VR_PACKET_WRITE_1;
  reg B_VR_PACKET_PHASE_1;
  reg B_VR_PACKET_EDGE_1;
  reg [7:0] B_VR_PACKET_DELAY_1;
  reg [159:0] B_VR_PACKET_TAG_1;
  reg APB_BUFFERED_1;
  reg END_BUFFERED_1;
  reg VR_BUFFERED_1;
  reg VR_STORED_VAR_1 [(8 - 1):0];
  reg READ_ANOTHER_1;
  reg [7:0] STORED_DELAY_1;
  reg [159:0] APB_PACKET_TAG;
  reg [3:0] vr_index, vr_index2;
  
  // Insert hand written Verilog for reading modified BIF file here.

`include "../reader/command_reader.v"
  
  //  The read process does the clever scheduling.  It shouldn't be 
  //  neccessary to change any of this when porting to other test 
  //  benches. 
  always @(I_CLK)
  begin

    if ((!I_CLK))
    begin
      //   clear all stored flags at start of
      if (APB_STORED)
        APB_STORED <= 1'b0;

      if (RES_STORED)
        RES_STORED <= 1'b0;
      for (vr_index = 0; vr_index < 8; vr_index = vr_index +1) 
        if (VR_STORED[vr_index])
          VR_STORED[vr_index] <= 1'b0;
 
      if ((APB_GET_LINE))
      begin
        if (END_BUFFERED_1)
          V_CYC_SEL_1 = `T_CYCLE_C_END;
        else if (!(APB_BUFFERED_1))
          READLINE;
        else
        begin
          V_APB_PACKET_SEL_1 = B_APB_PACKET_SEL_1;
          V_APB_PACKET_WRITE_1 = B_APB_PACKET_WRITE_1;
          V_APB_PACKET_ADDR_1 = B_APB_PACKET_ADDR_1;
          V_APB_PACKET_DATA_1 = B_APB_PACKET_DATA_1;
          V_APB_PACKET_MASK_1 = B_APB_PACKET_MASK_1;
          V_APB_PACKET_EXP_1 = B_APB_PACKET_EXP_1;
          V_APB_PACKET_NUM_CYC_1 = B_APB_PACKET_NUM_CYC_1;
          V_APB_PACKET_LIMIT_1  = B_APB_PACKET_LIMIT_1;
          V_APB_PACKET_TAG_1  = B_APB_PACKET_TAG_1;
          V_CYC_SEL_1 = B_CYC_SEL_1;
          APB_BUFFERED_1 = 1'b0;
        end
 
        if (VR_BUFFERED_1)
        begin
          W_VR_PACKET_VREGNO[B_VR_PACKET_VREGNO_1] <= 
                                                   B_VR_PACKET_VREGNO_1;
          W_VR_PACKET_DATA[B_VR_PACKET_VREGNO_1]   <= 
                                                   B_VR_PACKET_DATA_1;
          W_VR_PACKET_MASK[B_VR_PACKET_VREGNO_1]   <= 
                                                   B_VR_PACKET_MASK_1;
          W_VR_PACKET_EXP[B_VR_PACKET_VREGNO_1]    <= 
                                                   B_VR_PACKET_EXP_1;
          W_VR_PACKET_WRITE[B_VR_PACKET_VREGNO_1]  <= 
                                                   B_VR_PACKET_WRITE_1;
          W_VR_PACKET_PHASE[B_VR_PACKET_VREGNO_1]  <= 
                                                   B_VR_PACKET_PHASE_1;
          W_VR_PACKET_EDGE[B_VR_PACKET_VREGNO_1]   <= 
                                                   B_VR_PACKET_EDGE_1;
          W_VR_PACKET_DELAY[B_VR_PACKET_VREGNO_1]  <= 
                                                   B_VR_PACKET_DELAY_1;
          W_VR_PACKET_TAG[B_VR_PACKET_VREGNO_1]    <= 
                                                   B_VR_PACKET_TAG_1;
          VR_STORED[B_VR_PACKET_VREGNO_1] <= 1'b1;
          VR_STORED_VAR_1[B_VR_PACKET_VREGNO_1] = 1'b1;
          W_VCYC_SEL[B_VR_PACKET_VREGNO_1] <= B_VCYC_SEL_1;
          VR_BUFFERED_1 = 1'b0;
        end
        else
          for (vr_index = 0; vr_index < 8; vr_index = vr_index +1) 
            VR_STORED_VAR_1[vr_index] = 1'b0;
 
        case (V_CYC_SEL_1)
          `T_CYCLE_C_PNW,`T_CYCLE_C_PSW,`T_CYCLE_C_PNR,`T_CYCLE_C_PSR,
            `T_CYCLE_C_PI,`T_CYCLE_C_PO :
          begin
            W_APB_PACKET_SEL <= V_APB_PACKET_SEL_1;
            W_APB_PACKET_WRITE <= V_APB_PACKET_WRITE_1;
            W_APB_PACKET_ADDR <= V_APB_PACKET_ADDR_1;
            W_APB_PACKET_DATA <= V_APB_PACKET_DATA_1;
            W_APB_PACKET_MASK <= V_APB_PACKET_MASK_1;
            W_APB_PACKET_EXP <= V_APB_PACKET_EXP_1;
            W_APB_PACKET_NUM_CYC <= V_APB_PACKET_NUM_CYC_1;
            W_APB_PACKET_TAG  <= V_APB_PACKET_TAG_1;
            W_APB_PACKET_LIMIT  <= V_APB_PACKET_LIMIT_1;
            W_PCYC_SEL <= V_CYC_SEL_1;
            APB_STORED <= 1'b1;
            READ_ANOTHER_1 = 1'b1;
            while ((READ_ANOTHER_1))
              begin
              READLINE;
              case (V_CYC_SEL_1)
                `T_CYCLE_C_PNW,`T_CYCLE_C_PSW,`T_CYCLE_C_PNR,
                `T_CYCLE_C_PSR,`T_CYCLE_C_PI, `T_CYCLE_C_PO :
                begin
                  B_APB_PACKET_SEL_1 = V_APB_PACKET_SEL_1;
                  B_APB_PACKET_WRITE_1 = V_APB_PACKET_WRITE_1;
                  B_APB_PACKET_ADDR_1 = V_APB_PACKET_ADDR_1;
                  B_APB_PACKET_DATA_1 = V_APB_PACKET_DATA_1;
                  B_APB_PACKET_MASK_1 = V_APB_PACKET_MASK_1;
                  B_APB_PACKET_EXP_1 = V_APB_PACKET_EXP_1;
                  B_APB_PACKET_NUM_CYC_1 = V_APB_PACKET_NUM_CYC_1;
                  B_APB_PACKET_TAG_1 = V_APB_PACKET_TAG_1;
                  B_APB_PACKET_LIMIT_1 = V_APB_PACKET_LIMIT_1;
                  B_CYC_SEL_1 = V_CYC_SEL_1;
                  APB_BUFFERED_1 = 1'b1;
                  STORED_DELAY_1 = 1;
                  READ_ANOTHER_1 = 1'b0;
                end
                `T_CYCLE_C_VR,`T_CYCLE_C_VW :
                  if ((!(VR_STORED_VAR_1[V_VR_PACKET_VREGNO_1]))
                       && (V_VR_PACKET_DELAY_1 === STORED_DELAY_1))
                  begin
                    W_VR_PACKET_VREGNO[V_VR_PACKET_VREGNO_1] <=
                                             V_VR_PACKET_VREGNO_1;
                    W_VR_PACKET_DATA[V_VR_PACKET_VREGNO_1] <= 
                                             V_VR_PACKET_DATA_1;
                    W_VR_PACKET_MASK[V_VR_PACKET_VREGNO_1] <= 
                                             V_VR_PACKET_MASK_1;
                    W_VR_PACKET_EXP[V_VR_PACKET_VREGNO_1] <=
                                             V_VR_PACKET_EXP_1;
                    W_VR_PACKET_WRITE[V_VR_PACKET_VREGNO_1] <= 
                                             V_VR_PACKET_WRITE_1;
                    W_VR_PACKET_PHASE[V_VR_PACKET_VREGNO_1] <=
                                             V_VR_PACKET_PHASE_1;
                    W_VR_PACKET_EDGE[V_VR_PACKET_VREGNO_1] <= 
                                             V_VR_PACKET_EDGE_1;
                    W_VR_PACKET_DELAY[V_VR_PACKET_VREGNO_1] <= 
                                             V_VR_PACKET_DELAY_1;
                    W_VR_PACKET_TAG[V_VR_PACKET_VREGNO_1] <= 
                                             V_VR_PACKET_TAG_1;
                    VR_STORED[V_VR_PACKET_VREGNO_1] <= 1'b1;
                    VR_STORED_VAR_1[V_VR_PACKET_VREGNO_1] = 1'b1;
                    STORED_DELAY_1 = V_VR_PACKET_DELAY_1;
                    W_VCYC_SEL[V_VR_PACKET_VREGNO_1] <= V_CYC_SEL_1;
                  end
                  else
                  begin
                    B_VR_PACKET_VREGNO_1 = V_VR_PACKET_VREGNO_1;
                    B_VR_PACKET_DATA_1 = V_VR_PACKET_DATA_1;
                    B_VR_PACKET_MASK_1 = V_VR_PACKET_MASK_1;
                    B_VR_PACKET_EXP_1 = V_VR_PACKET_EXP_1;
                    B_VR_PACKET_WRITE_1 = V_VR_PACKET_WRITE_1;
                    B_VR_PACKET_PHASE_1 = V_VR_PACKET_PHASE_1;
                    B_VR_PACKET_EDGE_1 = V_VR_PACKET_EDGE_1;
                    B_VR_PACKET_DELAY_1 = V_VR_PACKET_DELAY_1;
                    B_VR_PACKET_TAG_1 = V_VR_PACKET_TAG_1;
                    B_VCYC_SEL_1 = V_CYC_SEL_1;
                    VR_BUFFERED_1 = 1'b1;
                    STORED_DELAY_1 = V_VR_PACKET_DELAY_1;
                    for (vr_index = 0; vr_index < 8; vr_index = 
                                                           vr_index +1) 
                      VR_STORED_VAR_1[vr_index] = 1'b0;
                    READ_ANOTHER_1 = 1'b0;
                  end
 
                `T_CYCLE_C_RES :
                begin
                  W_RCYC_SEL <= V_CYC_SEL_1;
                  W_RES_PACKET_PHASE <= V_RES_PACKET_PHASE_1;
                  W_RES_PACKET_DELAY <= V_RES_PACKET_DELAY_1;
                  W_RES_PACKET_NUM_CYC <= V_RES_PACKET_NUM_CYC_1;
                  RES_STORED <= 1'b1;
                end
                `T_CYCLE_C_END :
                begin
                  END_BUFFERED_1 = 1'b1;
                  READ_ANOTHER_1 = 1'b0;
                end
                default  :
                  READ_ANOTHER_1 = 1'b0;
              endcase
            end // while READ_ANOTHER
 
          end
          `T_CYCLE_C_END :
            I_TEST_END <= 1'b1;
          default  : ;
        endcase
 
      end
      else if (VR_GET_LINE)
      begin
        if (VR_BUFFERED_1)
        begin
          W_VR_PACKET_VREGNO[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_VREGNO_1;
          W_VR_PACKET_DATA[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_DATA_1;
          W_VR_PACKET_MASK[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_MASK_1;
          W_VR_PACKET_EXP[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_EXP_1;
          W_VR_PACKET_WRITE[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_WRITE_1;
          W_VR_PACKET_PHASE[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_PHASE_1;
          W_VR_PACKET_EDGE[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_EDGE_1;
          W_VR_PACKET_DELAY[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_DELAY_1;
          W_VR_PACKET_TAG[B_VR_PACKET_VREGNO_1] <= 
                                                  B_VR_PACKET_TAG_1;
          VR_STORED[B_VR_PACKET_VREGNO_1] <= 1'b1;
          VR_STORED_VAR_1[B_VR_PACKET_VREGNO_1] = 1'b1;
          W_VCYC_SEL[B_VR_PACKET_VREGNO_1] <= B_VCYC_SEL_1;
          VR_BUFFERED_1 = 1'b0;
        end
 
        if (!(APB_BUFFERED_1))
        begin
          READ_ANOTHER_1 = 1'b1;
          while ((READ_ANOTHER_1))
            begin
            READLINE;
            case (V_CYC_SEL_1)
              `T_CYCLE_C_PNW,`T_CYCLE_C_PSW,`T_CYCLE_C_PNR,
              `T_CYCLE_C_PSR, `T_CYCLE_C_PI,`T_CYCLE_C_PO :
              begin
                B_APB_PACKET_SEL_1 = V_APB_PACKET_SEL_1;
                B_APB_PACKET_WRITE_1 = V_APB_PACKET_WRITE_1;
                B_APB_PACKET_ADDR_1 = V_APB_PACKET_ADDR_1;
                B_APB_PACKET_DATA_1 = V_APB_PACKET_DATA_1;
                B_APB_PACKET_MASK_1 = V_APB_PACKET_MASK_1;
                B_APB_PACKET_EXP_1 = V_APB_PACKET_EXP_1;
                B_APB_PACKET_NUM_CYC_1 = V_APB_PACKET_NUM_CYC_1;
                B_APB_PACKET_LIMIT_1 = V_APB_PACKET_LIMIT_1;
                B_APB_PACKET_TAG_1 = V_APB_PACKET_TAG_1;
                B_CYC_SEL_1 = V_CYC_SEL_1;
                APB_BUFFERED_1 = 1'b1;
                STORED_DELAY_1 = 1;
                READ_ANOTHER_1 = 1'b0;
              end
              `T_CYCLE_C_VR,`T_CYCLE_C_VW :
                if ((!(VR_STORED_VAR_1[V_VR_PACKET_VREGNO_1])) && 
                      (V_VR_PACKET_DELAY_1 === STORED_DELAY_1))
                begin
                  W_VR_PACKET_VREGNO[V_VR_PACKET_VREGNO_1] <=
                                            
                                                  V_VR_PACKET_VREGNO_1;
                  W_VR_PACKET_DATA[V_VR_PACKET_VREGNO_1] <= 
                                                  V_VR_PACKET_DATA_1;
                  W_VR_PACKET_MASK[V_VR_PACKET_VREGNO_1] <= 
                                                  V_VR_PACKET_MASK_1;
                  W_VR_PACKET_EXP[V_VR_PACKET_VREGNO_1] <= 
                                                  V_VR_PACKET_EXP_1;
                  W_VR_PACKET_WRITE[V_VR_PACKET_VREGNO_1] <=
                                                  V_VR_PACKET_WRITE_1;
                  W_VR_PACKET_PHASE[V_VR_PACKET_VREGNO_1] <=
                                                  V_VR_PACKET_PHASE_1;
                  W_VR_PACKET_EDGE[V_VR_PACKET_VREGNO_1] <= 
                                                  V_VR_PACKET_EDGE_1;
                  W_VR_PACKET_DELAY[V_VR_PACKET_VREGNO_1] <=
                                                  V_VR_PACKET_DELAY_1;
                  W_VR_PACKET_TAG[V_VR_PACKET_VREGNO_1] <= 
                                                  V_VR_PACKET_TAG_1;
                  VR_STORED[V_VR_PACKET_VREGNO_1] <= 1'b1;
                  VR_STORED_VAR_1[V_VR_PACKET_VREGNO_1] = 1'b1;
                  STORED_DELAY_1 = V_VR_PACKET_DELAY_1;
                  W_VCYC_SEL[V_VR_PACKET_VREGNO_1] <= V_CYC_SEL_1;
                end
                else
                begin
                  B_VR_PACKET_VREGNO_1 = V_VR_PACKET_VREGNO_1;
                  B_VR_PACKET_DATA_1 = V_VR_PACKET_DATA_1;
                  B_VR_PACKET_MASK_1 = V_VR_PACKET_MASK_1;
                  B_VR_PACKET_EXP_1 = V_VR_PACKET_EXP_1;
                  B_VR_PACKET_WRITE_1 = V_VR_PACKET_WRITE_1;
                  B_VR_PACKET_PHASE_1 = V_VR_PACKET_PHASE_1;
                  B_VR_PACKET_EDGE_1 = V_VR_PACKET_EDGE_1;
                  B_VR_PACKET_DELAY_1 = V_VR_PACKET_DELAY_1;
                  B_VR_PACKET_TAG_1 = V_VR_PACKET_TAG_1;
                  B_VCYC_SEL_1 = V_CYC_SEL_1;
                  VR_BUFFERED_1 = 1'b1;
                  STORED_DELAY_1 = V_VR_PACKET_DELAY_1;
                  for (vr_index = 0; vr_index < 8; vr_index = 
                                                           vr_index +1) 
                    VR_STORED_VAR_1[vr_index] = 1'b0;
                  READ_ANOTHER_1 = 1'b0;
                end
 
              `T_CYCLE_C_RES :
              begin
                W_RCYC_SEL <= V_CYC_SEL_1;
                W_RES_PACKET_PHASE <= V_RES_PACKET_PHASE_1;
                W_RES_PACKET_DELAY <= V_RES_PACKET_DELAY_1;
                W_RES_PACKET_NUM_CYC <= V_RES_PACKET_NUM_CYC_1;
                RES_STORED <= 1'b1;
              end
              `T_CYCLE_C_END :
              begin
                I_TEST_END <= 1'b1;
                READ_ANOTHER_1 = 1'b0;
              end
              default  :
                READ_ANOTHER_1 = 1'b0;
            endcase
            end  // while READ_ANOTHER
 
        end
 
      end
 
    end
 
  end
 
  //  This drive process looks at the stored flags and then drives 
  //  the w_ signals onto the output in the high phase of PCLK.
  //  Note that info is only reliably sampled in the first high phase
  //  since the cycle select signals will go to idle in the low phase.
  always @( posedge (PCLK) )
  begin
 
    begin
      if (APB_STORED)
      begin
        I_APB_PACKET_SEL <= W_APB_PACKET_SEL;
        I_APB_PACKET_WRITE <= W_APB_PACKET_WRITE;
        I_APB_PACKET_ADDR <= W_APB_PACKET_ADDR;
        I_APB_PACKET_DATA <= W_APB_PACKET_DATA;
        I_APB_PACKET_MASK <= W_APB_PACKET_MASK;
        I_APB_PACKET_EXP <= W_APB_PACKET_EXP;
        I_APB_PACKET_NUM_CYC <= W_APB_PACKET_NUM_CYC;
        I_APB_PACKET_LIMIT <= W_APB_PACKET_LIMIT;
        APB_PACKET_TAG <= W_APB_PACKET_TAG;
        LATCHED_PCYC_SEL <= W_PCYC_SEL;
        if (W_PCYC_SEL !== `T_CYCLE_C_PO)
          POSTATI = 0; // indicates that the command is not a 
                       // poll command.
        else
          POSTATI = 1; // indicates that the command is a poll command.
      end
      else
        LATCHED_PCYC_SEL <= `T_CYCLE_C_IDLE;
 
      if (RES_STORED)
      begin
        I_RES_PACKET_PHASE <= W_RES_PACKET_PHASE;
        I_RES_PACKET_DELAY <= W_RES_PACKET_DELAY;
        I_RES_PACKET_NUM_CYC <= W_RES_PACKET_NUM_CYC;
        LATCHED_RCYC_SEL <= W_RCYC_SEL;
      end
      else
        LATCHED_RCYC_SEL <= `T_CYCLE_C_IDLE;
 
      for (vr_index2 = 0; vr_index2 < 8; vr_index2 = vr_index2 +1) 
        if (VR_STORED[vr_index2])
        begin
          I_VR_PACKET_VREGNO[vr_index2] <= 
                                         W_VR_PACKET_VREGNO[vr_index2];
          I_VR_PACKET_DATA[vr_index2] <= W_VR_PACKET_DATA[vr_index2];
          I_VR_PACKET_MASK[vr_index2] <= W_VR_PACKET_MASK[vr_index2];
          I_VR_PACKET_EXP[vr_index2] <= W_VR_PACKET_EXP[vr_index2];
          I_VR_PACKET_WRITE[vr_index2] <= W_VR_PACKET_WRITE[vr_index2];
          I_VR_PACKET_PHASE[vr_index2] <= W_VR_PACKET_PHASE[vr_index2];
          I_VR_PACKET_EDGE[vr_index2] <= W_VR_PACKET_EDGE[vr_index2];
          I_VR_PACKET_DELAY[vr_index2] <= W_VR_PACKET_DELAY[vr_index2];
          I_VR_PACKET_TAG[vr_index2] <= W_VR_PACKET_TAG[vr_index2];
          LATCHED_VCYC_SEL[vr_index2] <= W_VCYC_SEL[vr_index2];
        end
        else
          LATCHED_VCYC_SEL[vr_index2] <= `T_CYCLE_C_IDLE;
 
    end
 
  end
 
  assign VCYC_SEL = PCLK ? {LATCHED_VCYC_SEL[7], LATCHED_VCYC_SEL[6],
                            LATCHED_VCYC_SEL[5], LATCHED_VCYC_SEL[4],
                            LATCHED_VCYC_SEL[3], LATCHED_VCYC_SEL[2],
                            LATCHED_VCYC_SEL[1], LATCHED_VCYC_SEL[0]}
                         : {`T_CYCLE_C_IDLE,     `T_CYCLE_C_IDLE,
                            `T_CYCLE_C_IDLE,     `T_CYCLE_C_IDLE,
                            `T_CYCLE_C_IDLE,     `T_CYCLE_C_IDLE,
                            `T_CYCLE_C_IDLE,     `T_CYCLE_C_IDLE};

  always @(PCLK or LATCHED_PCYC_SEL or LATCHED_RCYC_SEL)
  begin
    I_PCYC_SEL <= PCLK ? LATCHED_PCYC_SEL :  `T_CYCLE_C_IDLE;
    I_RCYC_SEL <= PCLK ? LATCHED_RCYC_SEL :  `T_CYCLE_C_IDLE;
  end
 
  always
  begin
    wait ( TEST_END );
     #(Tclkl + Tclkh) ;  //  Wait for one clock period
     $finish;
  end
 
  initial
  begin
 
    V_CYC_SEL_1 = 1'd0;
    V_APB_PACKET_SEL_1 = 1'd0;
    V_APB_PACKET_WRITE_1 = 1'd0;
    V_APB_PACKET_ADDR_1 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0};
    V_APB_PACKET_DATA_1 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0};
    V_APB_PACKET_MASK_1 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0};
    V_APB_PACKET_EXP_1 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                          1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                          1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
                          1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                          1'd0, 1'd0, 1'd0, 1'd0};
    V_APB_PACKET_NUM_CYC_1 = 1'd0;
    V_APB_PACKET_LIMIT_1 = 1'd0;
    V_VR_PACKET_VREGNO_1 = 1'd0;
    V_VR_PACKET_DATA_1 = {1'd0, 1'd0, 1'd0, 1'd0};
    V_VR_PACKET_MASK_1 = {1'd0, 1'd0, 1'd0, 1'd0};
    V_VR_PACKET_EXP_1 = {1'd0, 1'd0, 1'd0, 1'd0};
    V_VR_PACKET_WRITE_1 = 1'd0;
    V_VR_PACKET_PHASE_1 = 1'd0;
    V_VR_PACKET_EDGE_1 = 1'd0;
    V_VR_PACKET_DELAY_1 = 1'd0;
    V_RES_PACKET_PHASE_1 = 1'd0;
    V_RES_PACKET_DELAY_1 = 1'd0;
    V_RES_PACKET_NUM_CYC_1 = 1'd0;
    B_CYC_SEL_1 = 1'd0;
    B_VCYC_SEL_1 = 1'd0;
    B_APB_PACKET_SEL_1 = 1'd0;
    B_APB_PACKET_WRITE_1 = 1'd0;
    B_APB_PACKET_ADDR_1 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0};
    B_APB_PACKET_DATA_1 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0};
    B_APB_PACKET_MASK_1 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
                           1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                           1'd0, 1'd0, 1'd0, 1'd0};
    B_APB_PACKET_EXP_1 = {1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                          1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                          1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0,
                          1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 1'd0, 
                          1'd0, 1'd0, 1'd0, 1'd0};
    B_APB_PACKET_NUM_CYC_1 = 1'd0;
    B_APB_PACKET_LIMIT_1 = 1'd0;
    B_VR_PACKET_VREGNO_1 = 1'd0;
    B_VR_PACKET_DATA_1 = {1'd0, 1'd0, 1'd0, 1'd0};
    B_VR_PACKET_MASK_1 = {1'd0, 1'd0, 1'd0, 1'd0};
    B_VR_PACKET_EXP_1 = {1'd0, 1'd0, 1'd0, 1'd0};
    B_VR_PACKET_WRITE_1 = 1'd0;
    B_VR_PACKET_PHASE_1 = 1'd0;
    B_VR_PACKET_EDGE_1 = 1'd0;
    B_VR_PACKET_DELAY_1 = 1'd0;
    APB_BUFFERED_1 = 1'b0;
    END_BUFFERED_1 = 1'b0;
    VR_BUFFERED_1 = 1'b0;
    READ_ANOTHER_1 = 1'b0;
    STORED_DELAY_1 = 1;

// Hand coding of VHDL initialisation values

    APB_STORED <= 1'b0;
    RES_STORED <= 1'b0;
    I_TEST_END <= 1'b0;
  end
 
endmodule

// --============================= End ===============================--
