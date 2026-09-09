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
// File Name           : clockgen.v,v
// File Revision       : 1.2
// 
// Release Information : PrimeCell(TM)-PL170-REL2v2
// 
// -----------------------------------------------------------------------------
// Purpose             : Clock generator module
// --=========================================================================--

`timescale 1ns/1ps
`include "../tbench/timing.v"

// -----------------------------------------------------------------------------
module Clockgen (HCLK);
 
   
output HCLK;

// -----------------------------------------------------------------------------
//
//                             clockgen
//                             ========
//
//-----------------------------------------------------------------------------
//
// Overview
// ========
//
// This module generates the main busclock HCLK, by toggling the HCLK line after
// half of Tclk (i,e Tclk/2). The value of Tclk is passed as generic parameter.
//
// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
//Signal iHCLK : std_logic;
reg I_HCLK;
// internal copy of the HCLK signal

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------
assign HCLK = I_HCLK;
 
initial
begin
  I_HCLK <= 1'b0;
  forever
  begin
    # `Tclkh I_HCLK =  1'b1;
    # `Tclkl I_HCLK =  1'b0;
  end
end
 
endmodule

// --================================= End ===================================--
