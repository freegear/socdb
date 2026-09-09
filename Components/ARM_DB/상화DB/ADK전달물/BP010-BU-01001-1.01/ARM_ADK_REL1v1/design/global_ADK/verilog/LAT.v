// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : LAT.v,v
// File Revision       : 1.1
// 
// Release Information : ADK_REL1v1
// 
// -----------------------------------------------------------------------------
// Purpose             : Transparent latch
// --=========================================================================--

`timescale 1ns/1ps 

module LAT (CLOCK, DATAIN, DATAOUT);

   input  CLOCK;
   input  DATAIN;

   output DATAOUT;

   reg 	  iDATAOUT;

   always @(CLOCK or DATAIN)
     begin
       if (CLOCK)
	 iDATAOUT = DATAIN; 
     end // always @ (CLOCK or DATAIN)

   assign DATAOUT = iDATAOUT;

endmodule // LAT

   
