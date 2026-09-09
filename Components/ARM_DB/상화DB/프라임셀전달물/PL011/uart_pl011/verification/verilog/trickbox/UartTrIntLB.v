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
// File Name              : UartTrIntLB.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL011-REL1v3
//
// ---------------------------------------------------------------------
// Purpose :
//           Trickbox to check the integration of UART in a larger chip.
//
// --=================================================================--
 
`timescale 1ns/1ps
 
// --------------------------------------------------------------------
module UartTrIntLB (
// Inputs
                    UARTTXD,
                    nSIROUT,
                    nUARTOut2,
                    nUARTOut1,
                    nUARTRTS,
                    nUARTDTR,

// Outputs
                    UARTRXD,
                    SIRIN,
                    nUARTCTS,
                    nUARTDCD,
                    nUARTDSR,
                    nUARTRI
                   );

// Inputs
input         UARTTXD; 	        // UART Transmit line
input         nSIROUT;          // SiR Transmit line
input         nUARTOut2;        // Modem Out2
input         nUARTOut1;        // Modem Out1
input         nUARTRTS;         // Modem RTS
input         nUARTDTR;         // Modem DTR

// Outputs
output        UARTRXD;          // UART Receive input
output        SIRIN;            // SiR receive input
output        nUARTCTS;         // Modem CTS
output        nUARTDCD;         // Modem DCD
output        nUARTDSR;         // Modem DSR
output        nUARTRI;          // Modem RI

// Inputs
wire          UARTTXD; 	        // UART Transmit line
wire          nSIROUT;          // SiR Transmit line
wire          nUARTOut2;        // Modem Out2
wire          nUARTOut1;        // Modem Out1
wire          nUARTRTS;         // Modem RTS
wire          nUARTDTR;         // Modem DTR

// Outputs
wire          UARTRXD;          // UART Receive input
wire          SIRIN;            // SiR receive input
wire          nUARTCTS;         // Modem CTS
wire          nUARTDCD;         // Modem DCD
wire          nUARTDSR;         // Modem DSR
wire          nUARTRI;          // Modem RI

// ---------------------------------------------------------------------
//
//                             UartTrIntLB
//                             ===========
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//
//    This module is a simple trickbox used for integrating the UART on
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
  
assign UARTRXD          = UARTTXD;
assign SIRIN            = nSIROUT;
assign nUARTCTS         = nUARTRTS;
assign nUARTDCD         = nUARTOut1;
assign nUARTDSR         = nUARTDTR;
assign nUARTRI          = nUARTOut2;
        	
endmodule
 
// --============================== End ==============================--
