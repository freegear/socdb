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
// File Name           : LATR.v,v
// File Revision       : 1.1
// 
// Release Information : ADK_REL1v1
// 
// -----------------------------------------------------------------------------
// Purpose             : Transparent latch with active-low asynchronous reset
// --=========================================================================--

`timescale 1ns/1ps 

module LATR (CLOCK, DATAIN, ARESETn, DATAOUT);

   input  CLOCK;
   input  DATAIN;
   input  ARESETn;

   output DATAOUT;

   reg 	  iDATAOUT;

   always @(ARESETn or CLOCK or DATAIN)
     begin
	if (!ARESETn)
	  iDATAOUT = 1'b0;
	else if (CLOCK)
	  iDATAOUT = DATAIN; 
     end // always @ (ARESETn or CLOCK or DATAIN)

   assign DATAOUT = iDATAOUT;

endmodule // LATR

   
