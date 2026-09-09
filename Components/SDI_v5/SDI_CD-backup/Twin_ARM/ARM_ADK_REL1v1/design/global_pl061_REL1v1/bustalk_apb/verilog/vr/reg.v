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
// File Name              : reg.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v1
//
// ---------------------------------------------------------------------
// Purpose : Single Virtual Register module
//
// --=================================================================--

`timescale 1ns/1ps

module VREG (VREG_ENA, VIO_SEL, DATA, MASK, VRG);
  parameter VDELAY = 0;

  `include "../common/defs.v"
 
  input VREG_ENA;
  input [1:0] VIO_SEL;
  inout [31:0] DATA;
  input [31:0] MASK;
  inout [31:0] VRG;
 
  reg [31:0] I_DATA;
  assign DATA = I_DATA;
 
  reg [31:0] I_VRG;
  assign VRG = I_VRG;
 
  //  This variable is used to store the output value
  reg [31:0] I_DATA_0;
  always @(VIO_SEL or VREG_ENA or DATA or MASK or VRG)
  begin
    case (VIO_SEL)
      `T_V_DRV_SEL_V_READ :
      begin
        //  If configured as input
        I_VRG <= {32{ 1'bz }};  //  Don't drive the input!
        I_DATA <= VRG;  //  pass input to output
      end
      `T_V_DRV_SEL_V_WRITE :
      begin
        //  if configured as output
        I_DATA <= {32{ 1'bz }};  //  don't drive the output
        if ((VREG_ENA))  //  if selected then
        begin
          I_DATA_0 = (DATA & MASK) | (I_DATA_0 & DATA) | 
                     (I_DATA_0 & ~ MASK);
          //  update internal data
          I_VRG <= #VDELAY  I_DATA_0;
        end
 
      end
    endcase
 
  end
 
  initial
  begin
 
    I_DATA_0 = {4{ 1'b0 }};
  end
 
endmodule

// --============================= End ===============================--
