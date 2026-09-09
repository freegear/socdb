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
// File Name              : SciDummyPad.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL131-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//          Dummy pad between SCI and Integration Trickbox
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SciDummyPad (
// Inputs
        nSCICLKENpaden,
        nSCICLKOUTENpaden,
        SCICLKOUTpadin,

        nSCIDATAENpaden,
        nSCIDATAOUTENpadin,

// Outputs 
        SCICLKOUTpadout,

        nSCIDATAOUTENpadout
                    );

// Inputs
input   nSCICLKENpaden;       // Off-chip clock buffer pad enable
input   nSCICLKOUTENpaden;    // On-chip clock buffer pad enable
input   SCICLKOUTpadin;       // On-chip clock out.
input   nSCIDATAENpaden;      // Off-chip data buffer pad enable
input   nSCIDATAOUTENpadin;   // Off-chip data buffer pad data

// Outputs 
output  SCICLKOUTpadout;      // Off-chip clock buffer output
output  nSCIDATAOUTENpadout;  // Off-chip data buffer output.
 

// -----------------------------------------------------------------------------
//
//                             SciDummyPad
//                             ===========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   
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


assign SCICLKOUTpadout     = (~nSCICLKENpaden && ~nSCICLKOUTENpaden) ? 
                                                      SCICLKOUTpadin : 1'bz;

assign nSCIDATAOUTENpadout = (~nSCIDATAENpaden) ? 
                             nSCIDATAOUTENpadin : 1'bz;


endmodule
// --================================== End ==================================--
