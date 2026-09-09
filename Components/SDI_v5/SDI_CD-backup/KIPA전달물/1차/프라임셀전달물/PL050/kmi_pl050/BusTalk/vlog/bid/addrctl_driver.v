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
// File Name           : addrctl_driver.v,v 
// File Revision       : 1.1 
// 
// Release Information : PL050-REL1v1 
// 
// -----------------------------------------------------------------------------
// Purpose             : Common driver for PADDR, PWRITE and PSEL
// --=========================================================================--

`timescale 1ns/1ps

module ADDRCTL_DRIVER (BNRES, ADDRCTL_SEL, IN_SIG, OUT_SIG);
// These are the dynamic parameters
  parameter WIDTH  = 32,
            Tclkh  = 50,
            TIS    = 4 ,
            TIH    = 1 ;
  
  `include "../common/defs.v"

  input BNRES;
  input ADDRCTL_SEL;
  input [(WIDTH - 1):0] IN_SIG;
  output [(WIDTH - 1):0] OUT_SIG;
  wire [(WIDTH - 1):0] I_OUT_SIG;
 
  reg [(WIDTH - 1):0] reg_I_OUT_SIG;
  assign OUT_SIG = reg_I_OUT_SIG;
  reg [7:0] index0, index1, index2;
 
  always @( negedge (BNRES) or posedge (ADDRCTL_SEL) )
  begin
    if (!BNRES)
    begin
      for (index0 = 0; index0 < WIDTH; index0 = index0 +1) 
        reg_I_OUT_SIG[index0] <= 1'b0;
    end
    else

    #TIH;
    for (index1 = 0; index1 < WIDTH; index1 = index1 +1) 
      reg_I_OUT_SIG[index1] <= 1'bx;
    
    #(Tclkh - TIS - TIH);
    for (index2 = 0; index2 < WIDTH; index2 = index2 +1) 
      reg_I_OUT_SIG[index2] <= IN_SIG[index2];
  end
 
endmodule

// --================================= End ===================================--
