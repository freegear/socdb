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
// File Name              : clockgen.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v7
//
// ---------------------------------------------------------------------
// Purpose : Clock generator module
//
// --=================================================================--

`timescale 1ns/1ps

module CLOCKGEN (PCLK);
 
   parameter
      Tclks = 5,
      Tclkh = 5,
      Tclkl = 5;
   
  output PCLK;
 
  reg Start_PCLK;
  reg I_PCLK;

  assign PCLK = I_PCLK;
 
  initial
  begin
    I_PCLK     <= 1'b0;
    Start_PCLK <= 1'b0;
    #Tclks Start_PCLK <= 1'b1;
  end
 
  always @(Start_PCLK)
  begin
    if (Start_PCLK  == 1'b1)
    forever
    begin
      #Tclkl I_PCLK =  1'b1;
      #Tclkh I_PCLK =  1'b0;
    end
  end
 
endmodule

// --============================== End ==============================--
