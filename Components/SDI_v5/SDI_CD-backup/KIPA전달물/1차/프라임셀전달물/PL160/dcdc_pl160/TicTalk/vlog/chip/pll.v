// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//  
// File Name           : pll.v,v
// File Revision       : 1.2
// 
// Release Information : PL160-REL1v1
//  
// -----------------------------------------------------------------------------
// Purpose : On-chip clock driver
// --=========================================================================--

`timescale 1ns/1ps

module pll (XCLKIN, BCLK);
 
  input XCLKIN; // External clock in
  output BCLK;  // System clock
 
// -----------------------------------------------------------------------------
//  Beginning of main code
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Output generation
// -----------------------------------------------------------------------------
//  Drive the output port with the internal clock

  assign BCLK = XCLKIN;

endmodule

// --================================ End ====================================--
