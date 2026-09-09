// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcClockOr.v.rca
// File Revision          : 1.9
//
// Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block performs clock gating.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcClockOr (
// Inputs
                    CLKIN,
                    ClkStpd,
// Outputs
                    CLKOUT
                   );

// Inputs
input      CLKIN;   // Clock input
input      ClkStpd; // Signal to indicate that clock output should be stopped

// Outputs
output     CLKOUT;  // Clock output




// Inputs
  wire     CLKIN;   // Clock input
  wire     ClkStpd; // Signal to indicate that clock output should be stopped

// Outputs
  wire     CLKOUT;  // Clock output


// -----------------------------------------------------------------------------
//
//                                 SsmcClockOr
//                                 ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module drives CLKOUT from CLKIN, if ClkStpd bit is low. Otherwise it
// drives high on CLKOUT. The ClkStpd bit is Clocked in SMMemCLK Domain.
//
// -----------------------------------------------------------------------------

// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


assign CLKOUT           = ClkStpd | CLKIN;

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
