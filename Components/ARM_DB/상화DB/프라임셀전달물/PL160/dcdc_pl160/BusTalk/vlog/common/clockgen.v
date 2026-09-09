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
// File Name           : clockgen.v,v 
// File Revision       : 1.2 
// 
// Release Information : PL160-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : Clock generator module
// --=========================================================================--

`timescale 1ns/1ns

module CLOCKGEN (BCLK);
 
   parameter
      Tclkh = 50,
      Tclkl = 50;
   
  output BCLK;
 
  reg I_BCLK;
  assign BCLK = I_BCLK;
 
  initial
  begin
    I_BCLK <= 1'b0;
    forever
    begin
      #Tclkl I_BCLK =  1'b1;
      #Tclkh I_BCLK =  1'b0;
    end
  end
 
endmodule

// --================================= End ===================================--
