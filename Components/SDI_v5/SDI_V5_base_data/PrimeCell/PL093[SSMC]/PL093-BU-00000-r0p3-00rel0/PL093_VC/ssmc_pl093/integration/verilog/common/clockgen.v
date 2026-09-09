// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : clockgen.v.rca
// File Revision       : 1.2
// 
// Release Information : PrimeCell(TM)-PL093-r0p3-00rel0
// 
// ---------------------------------------------------------------------
// Purpose :
//           Clock generator module
//
// --=================================================================--

`timescale 1ns/1ps
`include "../tbench/timing.v"

// ---------------------------------------------------------------------
module Clockgen (HCLK);
 
   
output HCLK;

// ---------------------------------------------------------------------
//
//                             clockgen
//                             ========
//
//---------------------------------------------------------------------
//
// Overview
// ========
//   This module generates the main busclock HCLK, by toggling the
// HCLK line after half of Tclk (i,e Tclk/2). 
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
reg Start_HCLK;
// Indicates that HCLK can start toggling  

reg I_HCLK;
// internal copy of the HCLK signal

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------
assign HCLK = I_HCLK;
 
initial
  begin
    I_HCLK     <= 1'b0;
    Start_HCLK <= 1'b0;
    # `Tclks Start_HCLK <= 1'b1;
  end
 
  always @(Start_HCLK)
  begin
    if (Start_HCLK  == 1'b1)
    forever
    begin
      # `Tclkl I_HCLK =  1'b1;
      # `Tclkh I_HCLK =  1'b0;
    end
  end
 
endmodule

// --============================= End ===============================--
