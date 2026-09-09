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
// File Name              : SspTrIntLB.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-PL022-REL1v2
//
// ---------------------------------------------------------------------
// Purpose :
//           Trickbox to check the integration of SSP in a larger chip.
//
// --=================================================================--
 
`timescale 1ns/1ps
 
// --------------------------------------------------------------------
module SspTrIntLB (
// Inputs
        SSPTXDpadout,
        SSPCLKOUTpadout,
        SSPFSSOUTpadout,

// Outputs
        SSPRXD,
        SSPCLKIN,
        SSPFSSIN
                  );


// Inputs
input        SSPTXDpadout   ; // SSP Transmit Data
input        SSPCLKOUTpadout; // SSP Serial ClockOut
input        SSPFSSOUTpadout; // SSP Frame/SlaveSelect Out

// Outputs
output       SSPRXD;          // SSP Receive Data
output       SSPCLKIN;        // SSP Serial ClockIn
output       SSPFSSIN;        // SSP Frame/SlaveSelectIn

// ---------------------------------------------------------------------
//
//                             SspTrIntLB
//                             ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
//    This module is a simple trickbox used for integrating the SSP on
//  a larger chip. This trickbox gives a loopback facility for few
//  input/output signals.
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
  
  assign SSPRXD    = SSPTXDpadout;
  assign SSPCLKIN  = SSPCLKOUTpadout;
  assign SSPFSSIN  = SSPFSSOUTpadout;
        	
endmodule
 
// --============================== End ==============================--
