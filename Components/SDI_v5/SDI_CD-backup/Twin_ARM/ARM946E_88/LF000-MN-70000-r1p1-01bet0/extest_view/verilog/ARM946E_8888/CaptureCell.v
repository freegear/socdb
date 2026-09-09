// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (c) COPYRIGHT 2000-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : $RCSfile: CaptureCell.v,v $
// File Revision       : $Revision: 1.1 $
//
// Release Information : $State: Rel $
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ns

module CaptureCell ( ScanEn, CLK, SI, DataIn,  SO);

  input ScanEn, CLK, SI, DataIn;
  output SO;
  reg DataBit;

  always @ (posedge CLK)
    if (ScanEn) 
      DataBit = SI;
    else 
      DataBit = DataIn;

  assign  SO = DataBit;

endmodule

