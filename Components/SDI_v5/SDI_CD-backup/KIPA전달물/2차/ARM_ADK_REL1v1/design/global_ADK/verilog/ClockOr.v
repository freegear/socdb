// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : ClockOr.v,v
// File Revision       : 1.1
// 
// Release Information : ADK_REL1v1
// 
// ---------------------------------------------------------------------
// Purpose             : Clock gating OR gate.
//                       
// --=================================================================--
 
`timescale 1ns/1ps

module ClockOr (InClock, Enable, OutClock);
 
  input InClock;
  input Enable;
  output OutClock;
 
  assign OutClock = InClock | Enable;
 
endmodule

// --============================== End ==============================--
