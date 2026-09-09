// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name              : Reg.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-GLOBAL-r8p0-00rel0
// 
// ---------------------------------------------------------------------
// Purpose :
//           Single Virtual Register module
//
// --=================================================================--

`timescale 1ns/1ps
`include "../common/defs.v"

// ---------------------------------------------------------------------

module Reg (VRegEn, 
            VIOSel,
            Data,
            Mask,
            VIO
           );

parameter
   VIODel = 0;

input        VRegEn;
// when high, indicates that the Virtual Register can be written into
input [1:0]  VIOSel;
// indicates the current vr cycle e.g `T_V_DRV_SEL_V_READ
input [31:0] Mask;
// 32 bit mask used for reading and comparing data from virtual register
inout [31:0] Data;
// internal i/o between linedriver and vregbank module
inout [31:0] VIO;
// virtual register i/o between the vrblock and outside world

// ---------------------------------------------------------------------
//
// Overview
// ========
//   This is a single virtual register, with generic mode
// (m_in or m_out) and identification. Remember VIO = Non-Amba I/O
// 
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
 
reg [31:0] iData;
 
reg [31:0] iVIO;
 
reg [31:0] TempData;

// This variable is used to store the output value
// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// --------------------------------------------------------------------

assign Data = iData;
assign VIO = iVIO;

always @(VIOSel or VRegEn or Data or Mask or VIO)
begin : p_reg
  case (VIOSel)
    `T_V_DRV_SEL_V_READ :
      begin
        // If configured as input, don't drive the input. Instead pass
        // the input to linedriver module for comparison.
        iVIO <= {32{1'bz}};  
        iData <= VIO;  //  pass input to output
      end
    `T_V_DRV_SEL_V_WRITE :
      begin
        // if configured as output
        iData <= {32{1'bz}};  //  don't drive the output
        if (VRegEn == 1'b1)   //  if selected then
          begin
            TempData = (Data & Mask) | (TempData & Data) |
                       (TempData & ~ Mask);
            //  update internal data
            iVIO <= #VIODel TempData;
          end
      end
  endcase
end  //p_reg
 
initial
begin
  TempData = {4{1'b0}};
end
 
endmodule

// --============================= End ===============================--
