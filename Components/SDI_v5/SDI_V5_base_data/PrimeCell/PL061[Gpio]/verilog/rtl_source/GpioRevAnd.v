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
// File Name              : GpioRevAnd.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL061-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           Revision Designator Module
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module GpioRevAnd (
// Inputs
                   TieOff1,
                   TieOff2,
// Outputs
                   Revision
                   );

// Inputs
input      TieOff1;  // AND gate input 1
input      TieOff2;  // AND gate input 2

// Outputs
output     Revision; // AND gate output

// Inputs
  wire     TieOff1;  // AND gate input 1
  wire     TieOff2;  // AND gate input 2

// Outputs
  wire     Revision; // AND gate output

// ---------------------------------------------------------------------
//
//                              GpioRevAnd
//                              =========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module contains a single AND gate to be used as a
// place-holder cell to mark the Revision of the controller.
// The 2 input pins will be tied-off at the top level of the
// hierarchy. These "TieOffs" can be identified during layout
// and re-wired to "VDD" or "VSS" if needed.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

assign Revision         = TieOff1 & TieOff2;

endmodule
// --========================== End of GpioRevAnd ====================--
