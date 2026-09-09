//  --==============================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : RevAnd.v,v
//  File Revision       : 1.2
//  
//  Release Information : ADK_REL1v1
//  
//  ------------------------------------------------------------------
//  Purpose             : Revision Designator Module
//  --==============================================================--

`timescale 1ns/1ps

module RevAnd
  (TieOff1,
   TieOff2,
   Revision);

  input  TieOff1;  //  Tieoff input 1            
  input  TieOff2;  //  Tieoff input 2            
  output Revision; //  TieOff1 and TieOff2 ANDed 

// -------------------------------------------------------------------
//
//                                  RevAnd
//                                 =========
//
// -------------------------------------------------------------------
//
// Overview
// ========
//   This module contains a single AND gate to be used as a
// place-holder cell to mark the Revision Number of the controller.
// The 2 input pins will be tied-off at the top level of the
// hierarchy. These "TieOffs" can be identified during layout
// and re-wired to "VDD" or "VSS" if needed.
//
// -------------------------------------------------------------------

// -------------------------------------------------------------------
//
// Main body of code
// =================
//
// -------------------------------------------------------------------

// -------------------------------------------------------------------
// The inputs TieOff1 and TieOff2 are ANDed to generate the Revision
// number bit.
// -------------------------------------------------------------------

     assign Revision = TieOff1 & TieOff2;

endmodule
