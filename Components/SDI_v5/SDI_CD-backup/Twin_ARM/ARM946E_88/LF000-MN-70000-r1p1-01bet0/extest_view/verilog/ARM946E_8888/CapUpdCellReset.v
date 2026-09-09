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
// File Name           : $RCSfile: CapUpdCellReset.v,v $
// File Revision       : $Revision: 1.1 $
//
// Release Information : $State: Rel $
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ns

module CapUpdCellReset ( ScanEn, TestEn, SerialEn, INnotEXTEST, CLK, SI, DataIn,  DataOut, SO);

  input ScanEn, TestEn, SerialEn, INnotEXTEST, CLK, SI, DataIn;
  output DataOut, SO;
  reg DataBit;
  reg HeldDataBit;
  wire maskedDataBit;
  wire DataBit1;

  assign DataBit1 = ScanEn ? HeldDataBit : DataBit;

  assign maskedDataBit = SerialEn ? DataBit1 : DataIn; 

  assign DataOut = TestEn ? maskedDataBit : DataIn; 

   always @ (posedge CLK)
     if (ScanEn) 
       DataBit = SI;
     else 
       if (INnotEXTEST)
	 DataBit = DataIn;
       else
	 DataBit = DataBit;

  always @ (posedge CLK)
    HeldDataBit = DataBit1;

  assign  SO = DataBit;

endmodule

