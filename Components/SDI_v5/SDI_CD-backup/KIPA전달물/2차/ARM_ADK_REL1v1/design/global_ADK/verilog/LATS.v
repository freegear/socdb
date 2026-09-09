// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// -----------------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : LATS.v,v
// File Revision       : 1.1
// 
// Release Information : ADK_REL1v1
// 
// -----------------------------------------------------------------------------
// Purpose             : Transparent latch with active-low asynchronous set
// --=========================================================================--

`timescale 1ns/1ps 

module LATS (CLOCK, DATAIN, ASETn, DATAOUT);

   input  CLOCK;
   input  DATAIN;
   input  ASETn;

   output DATAOUT;

   reg 	  iDATAOUT;

   always @(ASETn or CLOCK or DATAIN)
     begin
	if (!ASETn)
	  iDATAOUT = 1'b1;
	else if (CLOCK)
	  iDATAOUT = DATAIN; 
     end // always @ (ASETn or CLOCK or DATAIN)

   assign DATAOUT = iDATAOUT;

endmodule // LATS

   
