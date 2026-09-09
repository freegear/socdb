// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MmciDummyPad.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//          Dummy pad between MMCI and Integration Trickbox
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module MmciDummyPad (
// Inputs
                     MMCICMDOUT,     
                     MMCIDATOUT,     
                     nMMCIDATEN,    
                     nMMCICMDEN,   
// Inouts
                     MMCICMD,     
                     MMCIDAT,    
// Outputs
                     MMCICMDIN,
                     MMCIDATIN
                    );

// Inputs
input      MMCICMDOUT; // Command line input
input      MMCIDATOUT; // Data line input
input      nMMCIDATEN; // Data enable
input      nMMCICMDEN; // Command enable

// Inouts
inout      MMCICMD;    // Command line
inout      MMCIDAT;    // Data line

// Outputs
output     MMCICMDIN;  // Command line output
output     MMCIDATIN;  // Data line output




// Inputs
  wire     MMCICMDOUT; // Command line input
  wire     MMCIDATOUT; // Data line input
  wire     nMMCIDATEN; // Data enable
  wire     nMMCICMDEN; // Command enable

// Inouts
  wire     MMCICMD;    // Command line
  wire     MMCIDAT;    // Data line

// Outputs
  wire     MMCICMDIN;  // Command line output
  wire     MMCIDATIN;  // Data line output


// -----------------------------------------------------------------------------
//
//                             MmciDummyPad
//                             ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//       It buffers MMCIDATOUT and MMCICMDOUT with enable pins nMMCIDATEN and
//  nMMCICMDEN.It also feedbacks MMCIDAT and MMCICMD as MMCIDATIN and MMCICMDIN
//   to MMCI.

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


assign MMCICMD          = (nMMCICMDEN == 1'b0) ? MMCICMDOUT : 1'bz;

assign MMCICMDIN        = MMCICMD;

assign MMCIDAT          = (nMMCIDATEN == 1'b0) ? MMCIDATOUT : 1'bz;

assign MMCIDATIN        = MMCIDAT;

endmodule
// --================================== End ==================================--
