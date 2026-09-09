// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : VicTrick.v.rca
// File Revision          : 1.5
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Top level of the VIC Trickbox.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicTrick (
// Inputs
                VICVECTADDROUT,
                VICIRQ,
                VICFIQ,
                VICIRQACK,

// Outputs
                VICINTSOURCE,
                VICFIQINREG,
                VICIRQINREG
                );


// Inputs
input  [31:0] VICVECTADDROUT; // AddressOut In
input         VICIRQ;         // Non inverted IRQ
input         VICFIQ;         // Non inverted FIQ
input         VICIRQACK;      // Acknowledge signal

// Outputs
output [31:0] VICINTSOURCE;   // Interrupt source
output        VICFIQINREG;    // Register enable signal for FIQ
output        VICIRQINREG;    // Register enable signal for IRQ

// Inputs
wire   [31:0] VICVECTADDROUT; // Address out line
wire          VICIRQ;         // Non inverted IRQ
wire          VICFIQ;         // Non inverted FIQ
wire          VICIRQACK;      // Acknowledge signal
 
// Outputs
wire   [31:0] VICINTSOURCE;   // Interrupt source
wire          VICFIQINREG;    // Register enable signal for FIQ
wire          VICIRQINREG;    // Register enable signal for IRQ

// -----------------------------------------------------------------------------
//
//                              VicTrick
//                              ========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// It has the following functionality
//  It drives the VICINTSOURCE in the integration world. It is the inverted
//  version of VICVECTADDROUT.
//  It also generates VICFIQINREG and VICIRQINREG using VICFIQ and VICIRQ
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

assign VICINTSOURCE = VICVECTADDROUT ^ {32{1'b1}};
assign VICFIQINREG = VICFIQ ^ 1'b1;
assign VICIRQINREG = VICIRQ ^ 1'b1;

endmodule
// --================================== End ==================================--
