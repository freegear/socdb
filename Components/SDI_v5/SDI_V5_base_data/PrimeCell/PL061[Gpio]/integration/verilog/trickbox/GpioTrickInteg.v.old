// --=================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//----------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : GpioTrickInteg.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL061-REL1v0
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// Purpose : This module is the Integration test VHDL trickbox.
//
//           Its purpose is to check the integration of the GPIO PL061
//           in a larger chip in order to verify that all of its pins
//           are correctly connected. Integration Vectors allow the
//           user to verify that the GPIO has been wired into the
//           system correctly
//
//           The Gpio trickbox module performs the following functions:
//           - Generates the input signals for the GPIN[7:0] pins
//             of the GPIO as a XOR logical operation of the GPIO
//             output lines nGPEN[7:0] and GPOUT[7:0].
//
// --=================================================================--

`timescale 1ns/1ps

// ---------------------------------------------------------------------

module GpioTrickInteg (
// Inputs
                       nGPEN,
                       GPOUT,
// Output
                       GPIN
                      );

// Inputs
input  [7:0] nGPEN;   // GPIO o/p enables
input  [7:0] GPOUT;   // GPIO outputs
// Output
output [7:0] GPIN;    // GPIO inputs

// Inputs
wire  [7:0] nGPEN;    // GPIO o/p enables
wire  [7:0] GPOUT;    // GPIO outputs
// Output
wire [7:0] GPIN;      // GPIO inputs

// ---------------------------------------------------------------------
//
//                             GpioTrickInteg
//                             ==============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
// The external input to the GPIO is generated in this module.
// Inputs to the GPIO are controlled via the GPIO outputs
// nGPEN[7:0] and GPOUT[7:0].
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//
// Main body of code
// =================
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// The inputs to the GPIO Alt. Funct. Output are controlled via writes
// to the GTAOUTR register
//                 ________
// nGPEN[7:0] >---\\       \
//                || XOR    -----
// GPOUT[7:0] >---//_______/     |
//                               |
// GPIN[7:0]  <------------------
//
//
// XOR
// --------------------------------
// nGPEN[i]   GPOUT[i]   |  GPIN[i]
// --------------------------------
//     0         0       |    0
//     0         1       |    1
//     1         0       |    1
//     1         1       |    0
// --------------------------------
//----------------------------------------------------------------------

assign GPIN  = (nGPEN ^ GPOUT);

endmodule

// ============================== End ================================--
