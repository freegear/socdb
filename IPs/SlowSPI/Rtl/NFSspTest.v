// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  opies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  Version and Release Control Information:
//  File Name              : SspTest.v.rca
//  File Revision          : 1.6
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
// -----------------------------------------------------------------------------
 
// -----------------------------------------------------------------------------
// Purpose      : Test logic to facilitate controlled clocking of the 
//                design
// --=========================================================================--

module NFSspTest (
          
               LBM,
          
               SSPRXD,

               INTR,

               FSSOUT,
               CLKOUT,
               TXD,
               nCTLOE,
               nOE,
          
           
               IntSSPRXD,

               IntSSPINTR,

                  
               IntSSPFSSOUT,
               IntSSPCLKOUT,
               IntSSPTXD,
               IntnSSPCTLOE,
               IntnSSPOE
              );


input         LBM;               // Loopback mode

input         SSPRXD;            // Serial receive input (pad)

input         INTR;              // Combined interrupt signal

input         FSSOUT;            // Serial FrameOut signal
input         CLKOUT;            // Serial Clock signal
input         TXD;               // Serial Transmit signal
input         nCTLOE;            // SSP Control Enable signal
input         nOE;               // SSP Data Enable signal


output        IntSSPRXD;         // SSPRXD   loop back mode test mux

output        IntSSPINTR;        // INTR         test mux output ITOP(9)

output        IntSSPFSSOUT;      // FSSOUT       test mux output ITOP(4)
output        IntSSPCLKOUT;      // CLKOUT       test mux output ITOP(3)
output        IntSSPTXD;         // SSPTXD       test mux output ITOP(2)
output        IntnSSPCTLOE;      // SSPCTLOE     test mux output ITOP(1)
output        IntnSSPOE;         // SSPOE        test mux output ITOP(0)

// -----------------------------------------------------------------------------
//                               SspTest
//                               =======
// -----------------------------------------------------------------------------
// Overview
// ========
// This module contains the Test mode registers. It performs the following
// functions :

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// ITEN;
// Integration test enable. When set to 1, the SSPITIP and
// iSSPITOP registers are used to read/write values to the inputs
// and outputs.
  
// -----------------------------------------------------------------------------
// 
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// If the LBM input is asserted, IntSSPRXD is connected to TXD to
// implement loopback, else connected to SSPRXD pad input.
// -----------------------------------------------------------------------------

assign IntSSPRXD  = (LBM == 1'b1) ? TXD : SSPRXD;
               
assign IntSSPINTR      = INTR;
  

// --------------------------------------------------------------------
// Primary Output Mux
// If SSPTCR[0] ITEN (Integration test enable bit) is high,the iSSPITOP
// register value is used; else the functional mode value is driven
// on to the pin.
// --------------------------------------------------------------------


assign IntnSSPOE       = nOE;

assign IntnSSPCTLOE    = nCTLOE;

assign IntSSPCLKOUT    = CLKOUT;

assign IntSSPFSSOUT    = FSSOUT;

assign IntSSPTXD       = TXD;

endmodule

// --===================================== End ===============================--

