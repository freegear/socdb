// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SciTrick.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL131-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           Trickbox to check the integration of SCI in a larger chip.
//
// --=================================================================--
 
`timescale 1ns/1ps
 
// --------------------------------------------------------------------
module SciTrick (
// Inputs
        SCICLKOUTpadout,
        nSCIDATAOUTENpadout,
        SCIDEACACK,
        SCIVCCEN,
        nSCICARDRST,
        SCIFCB,

// Outputs
        SCICLKIN,
        SCIDATAIN,
        SCIDEACREQ,
        SCIDETECT
                 );


// Inputs
input        SCICLKOUTpadout;     // SCICLKOUT to SCICLKIN
input        nSCIDATAOUTENpadout; // nSCIDATAOUTEN to SCIDATAIN
input        SCIDEACACK;          // SCIDEACACK to SCIDEACREQ
input        SCIVCCEN;            // SCIVCCEN 
input        nSCICARDRST;         // nSCICARDRST
input        SCIFCB;              // SCIFCB

// Outputs
output       SCICLKIN;            // SCICLKIN
output       SCIDATAIN;           // SCIDATAIN
output       SCIDEACREQ;          // SCIDEACREQ
output       SCIDETECT;           // SCIDETECT

// ---------------------------------------------------------------------
//
//                             SciTrIntLB
//                             ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
//    This module is a simple trickbox used for integrating the SCI on
//    a larger chip. 
//    This trickbox has the following functionality:
//    o SCICLKOUTpadout is fed back to the SCICLKIN input.
//    o nSCIDATAOUTENpadout is fed back to the SCIDATAIN input
//    o SCIDEACACK output is fed back to the SCIDEACREQ input
//    o SCIVCCEN, nSCICARDRST and SCIFCB outputs are XOR'd and the 
//      single result fed back to the SCIDETECT input.
//    
//
// ---------------------------------------------------------------------
 
// ---------------------------------------------------------------------
// Component declarations
// ---------------------------------------------------------------------
 
// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------
 
// ---------------------------------------------------------------------
// Wire declarations
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
  
  assign SCICLKIN   = SCICLKOUTpadout;
  assign SCIDATAIN  = nSCIDATAOUTENpadout;
  assign SCIDEACREQ = SCIDEACACK;
  assign SCIDETECT  = SCIVCCEN ^ nSCICARDRST ^ SCIFCB;
        	
endmodule
 
// --============================== End ==============================--
