// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacRevAnd.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Revision Designator Module
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacRevAnd (
// Inputs
                   TieOff1,
                   TieOff2,
// Outputs
                   Revision
                   );

// Inputs
input      TieOff1;          // Tieoff input 1
input      TieOff2;          // Tieoff input 2

// Outputs
output     Revision;         // TieOff1 and TieOff2 ANDed

// Inputs
wire       TieOff1;          // Tieoff input 1
wire       TieOff2;          // Tieoff input 2

// Outputs
wire       Revision;         // TieOff1 and TieOff2 ANDed

// -----------------------------------------------------------------------------
//
//                                 DmacRevAnd
//                                 ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module contains a single AND gate to be used as a place-holder cell
// to mark the Revision Number of the controller.
// The 2 input pins will be tied-off at the top level of the hierarchy. These
// "TieOffs" can be identified during layout and re-wired to "VDD" or "VSS" if
// needed.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// The inputs TieOff1 and TieOff2 are ANDed to generate the Revision number bit.
// -----------------------------------------------------------------------------
assign Revision         = TieOff1 & TieOff2;

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// synopsys translate_on

endmodule
// --================================== End ==================================--
