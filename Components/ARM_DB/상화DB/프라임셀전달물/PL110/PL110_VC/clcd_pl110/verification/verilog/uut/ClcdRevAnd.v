// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : ClcdRevAnd.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
// ---------------------------------------------------------------------
// Purpose                : Revision Designator Module
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module ClcdRevAnd (
// Inputs
                   TieOff1,
                   TieOff2,
// Outputs
                   Revision
                 );

// Inputs
input        TieOff1;  // AND gate input 1
input        TieOff2;  // AND gate input 2

// Outputs
output       Revision; // AND gate output

// ---------------------------------------------------------------------
//
//                              ClcdRevAnd
//                              ==========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This module contains a single AND gate to be used as a
// place-holder cell to mark the Revision of the Clcd.
// The 2 input pins will be tied-off at the top level of the
// hierarchy. These "TieOffs" can be identified during layout
// and re-wired to "VDD" or "VSS" if needed.
//
// ---------------------------------------------------------------------


// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------


// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

assign Revision = TieOff1 & TieOff2;

endmodule

// --============================== End ==============================--
