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
// File Name           : viregcyc_drivers.v.rca 
// File Revision       : 1.1 
// 
// Release Information : PrimeCell(TM)-GLOBAL-r8p0-00rel0 
// 
// -----------------------------------------------------------------------------
// Purpose             : Virtual registers state control drivers
// --=========================================================================--

`timescale 1ns/1ps

module VIREGCYC_DRIVERS (BCLK, CYC_SEL, VR_PACKET_WRITE, VR_PACKET_DELAY,
                         CYC_COUNT, VREG_GET_LINE, VIO_SEL);

  `include "../common/defs.v"
 
  input BCLK;
  input [(8 * 4 - 1):0] CYC_SEL;
  input [(8 - 1):0] VR_PACKET_WRITE;
  input [(8 * 8 - 1):0] VR_PACKET_DELAY;
  input [7:0] CYC_COUNT;
  output VREG_GET_LINE;
//  inout [(8 * 2 - 1):0] VIO_SEL;
  output [(8 * 2 - 1):0] VIO_SEL;
  wire [7:0] MAX_VAL;
  reg [(8 - 1):0] VR_ACTIVE;
 
  reg [7:0] I_MAX_VAL;
  assign MAX_VAL = I_MAX_VAL;
 
  reg [1:0] I_VIO_SEL [(8 - 1):0] ;
  assign VIO_SEL = {I_VIO_SEL[7],
                    I_VIO_SEL[6],
                    I_VIO_SEL[5],
                    I_VIO_SEL[4],
                    I_VIO_SEL[3],
                    I_VIO_SEL[2],
                    I_VIO_SEL[1],
                    I_VIO_SEL[0]};
 
  reg I_VREG_GET_LINE;
  assign VREG_GET_LINE = I_VREG_GET_LINE;
 
  reg [7:0] TEMP_VAL_0;
  reg [7:0] index, index2;
  reg [3:0] TMP_CYC_SEL;
  reg [7:0] TMP_DELAY, TMP_DELAY2;

  always @(CYC_SEL or BCLK)
  begin
    if (BCLK)
      for (index = 0; index < 8; index = index + 1)
      begin
        TMP_CYC_SEL[3:0] = CYC_SEL >> (index * 4);
        TMP_DELAY[7:0] = VR_PACKET_DELAY >> (index * 8);
        if ((TMP_CYC_SEL === `T_CYCLE_C_VR) || (TMP_CYC_SEL === `T_CYCLE_C_VW))
        begin
          VR_ACTIVE[index] <= 1'b1;
          if (TEMP_VAL_0 < TMP_DELAY)
            TEMP_VAL_0 = TMP_DELAY;
 
          I_MAX_VAL <= TEMP_VAL_0;
        end
        else if (TMP_CYC_SEL === `T_CYCLE_C_IDLE)
          VR_ACTIVE[index] <= 1'b0;
      end
    TEMP_VAL_0 = 0;
  end
 
  always @(CYC_COUNT or BCLK or VR_ACTIVE)
  // Schedule VRG enables (VIOSEL[i]) as either read or write after delay BCLKs
  begin
    if (!BCLK)
      for (index2 = 0; index2 < 8; index2 = index2 + 1)
        begin
          TMP_DELAY2[7:0] = VR_PACKET_DELAY >> (index2 * 8);
          if (VR_ACTIVE[index2])
          begin
            if (CYC_COUNT === TMP_DELAY2)
              if (VR_PACKET_WRITE[index2])
                I_VIO_SEL[index2] <= `T_V_DRV_SEL_V_WRITE;
              else
                I_VIO_SEL[index2] <= `T_V_DRV_SEL_V_READ;
            else if (CYC_COUNT < TMP_DELAY2)
              I_VIO_SEL[index2] <= `T_V_DRV_SEL_V_COUNT;
          end

          else if (I_VIO_SEL[index2] === `T_V_DRV_SEL_V_COUNT)
          begin
            if (CYC_COUNT === TMP_DELAY2)
              if (VR_PACKET_WRITE[index2])
                I_VIO_SEL[index2] <= `T_V_DRV_SEL_V_WRITE;
              else
                I_VIO_SEL[index2] <= `T_V_DRV_SEL_V_READ;
          end
          else if (I_VIO_SEL[index2] === `T_V_DRV_SEL_V_WRITE ||
                   I_VIO_SEL[index2] === `T_V_DRV_SEL_V_READ)
            I_VIO_SEL[index2] <= `T_V_DRV_SEL_V_IDLE;
          else
            I_VIO_SEL[index2] <= `T_V_DRV_SEL_V_IDLE;
        end
  end
 
  always @(CYC_COUNT)
  begin
    if ((MAX_VAL === CYC_COUNT) || (CYC_COUNT === 1))
      I_VREG_GET_LINE <= `T_GET_G_GET;
    else
      I_VREG_GET_LINE <= `T_GET_G_IDLE;
  end
 
  initial
  begin

    I_VIO_SEL[7] = `T_V_DRV_SEL_V_READ; 
    I_VIO_SEL[6] = `T_V_DRV_SEL_V_READ; 
    I_VIO_SEL[5] = `T_V_DRV_SEL_V_READ; 
    I_VIO_SEL[4] = `T_V_DRV_SEL_V_READ; 
    I_VIO_SEL[3] = `T_V_DRV_SEL_V_READ; 
    I_VIO_SEL[2] = `T_V_DRV_SEL_V_READ; 
    I_VIO_SEL[1] = `T_V_DRV_SEL_V_READ;
    I_VIO_SEL[0] = `T_V_DRV_SEL_V_READ;     
    TEMP_VAL_0 = 0;
  end
 
endmodule

// --================================= End ===================================--
