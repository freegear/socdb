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
// File Name           : countdown.v.rca
// File Revision       : 1.2
// 
// Release Information : PrimeCell(TM)-PL093-r0p3-00rel0
// 
// ---------------------------------------------------------------------
// Purpose :
//           Down counter module for num_cyc
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------
module countdown (HCLK, VAL, Rscyc, LAST);

input        HCLK;
input [7:0]  VAL;
input        Rscyc;
output [7:0] LAST;

// ---------------------------------------------------------------------
//
//                             countdown
//                             =========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This block counts from value down to 0, sending its last signal
// high when the value is 1. Decided against flagging zero, so that we
// have two edges to work with (can see 0 by falling edge of last).
// Because of the flag on 1, there has to be two physical counters in
// this unit for the case when a stream of 1's are loaded. It seems a
// bit complex, but has the functionality needed.
// 
// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------
reg [7:0] VALUE;

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// This is a positive edge-triggered down counter that loads non-zero
// values from the input, VAL and counts down to zero on successive
// falling edges of HCLK, until zero is reached.
// ---------------------------------------------------------------------

assign LAST = VALUE;

initial 
begin
  VALUE = 8'h01;
end

always @(posedge HCLK) 
begin
  if (HCLK === 1'b1)
    begin
      if (VAL != 8'h00)
        VALUE <= VAL;
      else if (VALUE != 8'h00)
        VALUE <= VALUE - 1'b1;
      else
        VALUE <= 8'h00;
    end
end

endmodule

// --============================= End ===============================--
