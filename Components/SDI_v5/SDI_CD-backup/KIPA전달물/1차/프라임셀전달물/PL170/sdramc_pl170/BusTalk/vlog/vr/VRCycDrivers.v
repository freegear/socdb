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
// File Name           : viregcyc_drivers.v,v
// File Revision       : 1.3
// 
// Release Information : Rev1-3
// 
// -----------------------------------------------------------------------------
// Purpose             : Virtual registers state control drivers
// --=========================================================================--

`timescale 1ns/1ps
`include "../common/defs.v"

// -----------------------------------------------------------------------------
module VRCycDrivers (HCLK,
                     CycSel,
                     VRPacketWrite,
                     VRPacketDelay,
                     CycCount,
                     VRGetLine,
                     VIOSel
                    );

 
input                  HCLK;
input [(8 * 4 - 1):0]  CycSel;
input [(8 - 1):0]      VRPacketWrite;
input [(8 * 8 - 1):0]  VRPacketDelay;
input [7:0]            CycCount;
output                 VRGetLine;
output [(8 * 2 - 1):0] VIOSel;

// -----------------------------------------------------------------------------
//
//                             VRCycDrivers
//                             ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module request packets by generating Gget and selects the appropriate
// VR registers for a read or write operation. It always checks for a VR or
// VW command and becomes active till it gets a new bid command from reader
// module
//
// -----------------------------------------------------------------------------
// Signal Declarations 
// -----------------------------------------------------------------------------
wire [7:0]       MaxVal;
reg [(8 - 1):0]  VRActive;
reg [7:0]        iMaxVal;
reg [1:0]        iVIOSel [(8 - 1):0] ;
reg              iVRGetLine;
reg [7:0]        TempVal;
reg [7:0]        index, index2;
reg [3:0]        TempCycSel;
reg [7:0]        TempDelay, TempDelay2;

// -----------------------------------------------------------------------------
// Main body of code
// =================
// -----------------------------------------------------------------------------
 
assign VIOSel = {iVIOSel[7],
                 iVIOSel[6],
                 iVIOSel[5],
                 iVIOSel[4],
                 iVIOSel[3],
                 iVIOSel[2],
                 iVIOSel[1],
                 iVIOSel[0]};
assign VRGetLine = iVRGetLine;
assign MaxVal = iMaxVal;
initial
begin
  iVRGetLine = `T_GET_G_GET;
end

always @(CycSel or HCLK)
begin
  if (HCLK == 1'b0)
    for (index = 0; index < 8; index = index + 1)
    begin
      
      TempCycSel[3:0] = CycSel >> (index * 4);
      TempDelay[7:0] = VRPacketDelay >> (index * 8);
      if ((TempCycSel === `T_CYCLE_C_VR)| (TempCycSel === `T_CYCLE_C_VW))
      begin
        VRActive[index] <= 1'b1;
        if (TempVal < TempDelay)
          TempVal = TempDelay;

        iMaxVal <= TempVal;
      end
      else if (TempCycSel === `T_CYCLE_C_IDLE)
        VRActive[index] <= 1'b0;
    end
  TempVal = 0;
end

always @(CycCount or HCLK or VRActive)
// Schedule VRG enables (VIOSEL[i]) as either read or write after delay HCLKs
begin
  if (HCLK)
    for (index2 = 0; index2 < 8; index2 = index2 + 1)
      begin
        TempDelay2[7:0] = VRPacketDelay >> (index2 * 8);
        if (VRActive[index2])
        begin
          if (CycCount === TempDelay2)
            if (VRPacketWrite[index2])
              iVIOSel[index2] <= `T_V_DRV_SEL_V_WRITE;
            else
              iVIOSel[index2] <= `T_V_DRV_SEL_V_READ;
          else if (CycCount < TempDelay2)
            iVIOSel[index2] <= `T_V_DRV_SEL_V_COUNT;
        end

        else if (iVIOSel[index2] === `T_V_DRV_SEL_V_COUNT)
        begin
          if (CycCount === TempDelay2)
            if (VRPacketWrite[index2])
              iVIOSel[index2] <= `T_V_DRV_SEL_V_WRITE;
            else
              iVIOSel[index2] <= `T_V_DRV_SEL_V_READ;
        end
        else if (iVIOSel[index2] === `T_V_DRV_SEL_V_WRITE|
                 iVIOSel[index2] === `T_V_DRV_SEL_V_READ)
          iVIOSel[index2] <= `T_V_DRV_SEL_V_IDLE;
        else
          iVIOSel[index2] <= `T_V_DRV_SEL_V_IDLE;
      end
end

always @(CycCount)
begin
  if ((MaxVal === CycCount)| (CycCount === 0))
    iVRGetLine <= `T_GET_G_GET;
  else
    iVRGetLine <= `T_GET_G_IDLE;
end

initial
begin

  iVIOSel[7] = `T_V_DRV_SEL_V_READ; 
  iVIOSel[6] = `T_V_DRV_SEL_V_READ; 
  iVIOSel[5] = `T_V_DRV_SEL_V_READ; 
  iVIOSel[4] = `T_V_DRV_SEL_V_READ; 
  iVIOSel[3] = `T_V_DRV_SEL_V_READ; 
  iVIOSel[2] = `T_V_DRV_SEL_V_READ;
  iVIOSel[1] = `T_V_DRV_SEL_V_READ;
  iVIOSel[0] = `T_V_DRV_SEL_V_READ;     
  TempVal    = 0;
  iMaxVal    = 8'b00000000;
end
 
endmodule

// --================================= End ===================================--
