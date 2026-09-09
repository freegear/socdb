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
// File Name              : AaciTrickInteg.v.rca
// File Revision          : 1.4
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------// Purpose :
//           Trickbox to check the integration of AACI in a larger chip.
//
// --=================================================================--
 
`timescale 1ns/1ps
 
// --------------------------------------------------------------------

module AaciTrickInteg (
// Inputs
                       AACISDATAOUT,
                       AACIRESET,
                       AACISYNC,
// Outputs
                       AACIBITCLK,
                       AACISDATAIN          
                      );

// I/O ports
// Inputs
input         AACISDATAOUT;     // AACI Serial data o/p port
input         AACIRESET;        // AACI RESET o/p port
input         AACISYNC;         // AACI Serial data input

// Outputs
output        AACIBITCLK;       // AACI Serial clock input
output        AACISDATAIN;      // AACI Serial data input
 
// Inputs
wire          AACISDATAOUT;     // AACI Serial data o/p port
wire          AACIRESET;        // AACI RESET o/p port
wire          AACISYNC;         // AACI Serial data input
// Outputs
wire          AACIBITCLK;       // AACI Serial clock input
wire          AACISDATAIN;      // AACI Serial data input

// ---------------------------------------------------------------------
//
//                           AaciTrickInteg
//                           ==============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
//    This module is a simple trickbox used for integrating the AACI on
//  a larger chip. This trickbox gives a loopback facility for primary
//  input/output signals.
//
// ---------------------------------------------------------------------
 
// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg         iBITCLK;
// Internal BITCLK
 
// ---------------------------------------------------------------------
// Parameter declarations
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
 
// ---------------------------------------------------------------------
// Initialises of the signals and variables
// ---------------------------------------------------------------------
initial
begin
  iBITCLK     = 1'b0;
end

// ---------------------------------------------------------------------
// Assigning the register bit of the clock to the output port
// ---------------------------------------------------------------------
assign   AACIBITCLK     = iBITCLK;
assign   AACISDATAIN    = AACISDATAOUT | AACIRESET | AACISYNC;

// ---------------------------------------------------------------------
// BITCLK generation
// ---------------------------------------------------------------------
initial
begin : p_BITCLKGenSeq
  iBITCLK = 1'b0;
  forever
    # 40 iBITCLK <= ~iBITCLK;
end // process p_BITCLKGenSeq;

endmodule
 
// --============================== End ==============================--
