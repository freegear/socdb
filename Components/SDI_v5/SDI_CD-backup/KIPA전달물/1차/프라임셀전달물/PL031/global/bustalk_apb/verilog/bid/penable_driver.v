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
// File Name              : penable_driver.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v2
//
// ---------------------------------------------------------------------
// Purpose : PENABLE driver module
//
// --=================================================================--

`timescale 1ns/1ps

module PENABLE_DRIVER (PENABLE_SEL, OUT_SIG);
 
  // Dynamic paramters
  parameter 
     Tclkl = 50,
     TIS   = 1,
     TIH   = 1;

  `include "../common/defs.v"

  input [1:0] PENABLE_SEL;
  output OUT_SIG;
  wire I_OUT_SIG;
 
  reg reg_OUT_SIG;
  assign OUT_SIG = reg_OUT_SIG;
 
  reg reg_I_OUT_SIG;
  assign I_OUT_SIG = reg_I_OUT_SIG;
 
  always @(PENABLE_SEL or I_OUT_SIG)
  begin
    case (PENABLE_SEL)
      `T_E_DRV_SEL_EN_PH1 :
        reg_I_OUT_SIG <= # TIH 1'b0; // sets it low on reset and end of
                                     // transfer
      `T_E_DRV_SEL_EN_PH3 :
        reg_I_OUT_SIG <= # (Tclkl  - TIS) 1'b1; // sets it high round 
                                                // PCLK low
      default  : ;
    endcase
 
    reg_OUT_SIG <= I_OUT_SIG;
  end
 
endmodule

// --============================= End ===============================--
