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
// File Name              : MmciTrickInteg.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL181-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Trickbox to check the integration of MMCI in a larger chip.
//
// --=========================================================================--

`timescale 1ns/1ps 
 
// -----------------------------------------------------------------------------

module MmciTrickInteg (
// Inputs
                       MMCICLKOUT,
                       MMCIPWR, 
                       MMCIROD,
                       MMCIVDD,
// Outputs
                       MMCIFBCLK,
                       MMCIORMUX
                      );
 
// Inputs
input        MMCICLKOUT;   // MMCI Clock output
input        MMCIPWR;      // Power supply enable
input        MMCIROD;      // Open-drain resistor enable
input  [3:0] MMCIVDD;      // Power supply o/p voltage

// Outputs
output       MMCIFBCLK;    // MMCI fed back clock
output       MMCIORMUX;    // MUXed output of MMCIOROUTPUT 

// Inputs
wire         MMCICLKOUT;   // MMCI Clock output
wire         MMCIPWR;      // Power supply enable
wire         MMCIROD;      // Open-drain resistor enable
wire   [3:0] MMCIVDD;      // Power supply o/p voltage

// Outputs
wire         MMCIFBCLK;    // MMCI fed back clock

wire         MMCIOROUTPUT; // ORed output
wire         MMCIORMUX;    // MUXed output of MMCIOROUTPUT

// -----------------------------------------------------------------------------
//
//                             MmciTrickInteg
//                             ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//    This module is a simple trickbox used for integrating the MMCI on
//  a larger chip. This trickbox gives a loopback facility for few
//  input/output signals.
//    MMCICLKOUT is looped back onto MMCIFBCLK after a delay of a ns.
//  This models the skew between MMCIFBCLK and MMCICLKOUT.
//    MMCIDAT is MMCIORMUX or  MMCICMD and MMCICMD is MMCIORMUX or MMCIDAT
//
// -----------------------------------------------------------------------------
 
 
// -----------------------------------------------------------------------------
// Constant declarations
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
// Model the skew between MMCICLKOUT and MMCIFBCLK
// -----------------------------------------------------------------------------
assign #3 MMCIFBCLK              = MMCICLKOUT; 

// -----------------------------------------------------------------------------
// Generation of the MMCIOROUTPUT output
// -----------------------------------------------------------------------------
 assign MMCIOROUTPUT            = (MMCIVDD[0] ||MMCIVDD[1] ||MMCIVDD[2]||
                                  MMCIVDD[3] || MMCIPWR);  
// -----------------------------------------------------------------------------
// Generation of the MMCIORMUX output
// -----------------------------------------------------------------------------
assign MMCIORMUX               =  (MMCIROD ==1'b1) ? MMCIOROUTPUT : 1'bz ; 
                                
endmodule
 
// --============================== End ======================================--
