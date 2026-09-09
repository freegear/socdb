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
// File Name           : countdown.v.rca 
// File Revision       : 1.1 
// 
// Release Information : PrimeCell(TM)-GLOBAL-r8p0-00rel0 
// 
// -----------------------------------------------------------------------------
// Purpose             : Down counter module for num_cyc
// --=========================================================================--

`timescale 1ns/1ps

module COUNTDOWN (BCLK, VAL, LAST);
 
  input BCLK;
  input [7:0] VAL;
  output [7:0] LAST;
 
  reg [7:0] VALUE;
 
  //  This is a negative edge-triggered down counter that loads
  //  non-zero values from the input, VAL and counts down to  zero
  //  on successive falling edges of BCLK, until zero is reached.

  always @( negedge (BCLK) )
  begin
    if (VAL !== 8'h00)
      VALUE <= VAL;
    else if (VALUE !== 8'h00)
      VALUE <= VALUE - 1;
    else
      VALUE <= 8'h00;
  end
 
  assign LAST = VALUE;

endmodule

// --================================= End ===================================--
