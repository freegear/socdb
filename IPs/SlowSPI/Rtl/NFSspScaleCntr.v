// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : SspScaleCntr.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL022-REL1v2
//  
// -----------------------------------------------------------------------------
  
// -----------------------------------------------------------------------------

// Purpose      : This module divides the input PCLK by a programmable
//                prescale factor. It also implements the PCLK-domain 
//                buffers of the 2-buffer synchronisation mechanism.

// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module NFSspScaleCntr (
// Inputs
                     PCLK, 
                     PRESETn, 
                     SSESync, 
                     SSPCPSR, 
// Outputs
                     SSPCLKDIV,
                     SSPCPSC
                    );
// Inputs
input        PCLK;         // Main SSP clock
input        PRESETn;        // Muxed reset (from PRESETn)
input        SSESync;        // SSP enable
input  [7:1] SSPCPSR;        // 2nd buffer
// Outputs
output       SSPCLKDIV;      // Prescaled output
output [6:0] SSPCPSC;        // Counter read

// -----------------------------------------------------------------------------
//
//                            SspScaleCntr
//                            ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
//  The prescaling counter provides flexibility to accomodate different input
// clock frequencies in order to provide the same range of baud rates. A 
// programmable internal counter generates the SSPCLKDIV signal. This counter
// has one half of the value written into the SSCPSR register as its reload
// value and counts down upto 1.
//  This module also contains the PCLK domain buffers of the SSP control
// registers. The distinct bit information from these buffers is separated out
// and driven as individual outputs.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg  [6:0] SSPCPSC;          
// SSP Clock Pre-Scale Counter

reg  [6:0] NextSSPCPSC;        
// D-input of SSPCPSC

wire	[7:1] CPSR;


// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Prescaler to divide PCLK by the value programmed in SSCPSR register
// -----------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin : p_CntSeq
  if (PRESETn == 1'b0)  
    SSPCPSC   <= 7'b0000000; 
  else 
    SSPCPSC <= NextSSPCPSC;
end //  p_CntSeq

always @(SSPCPSC or  CPSR or SSESync)
begin : p_CntComb
  if ((SSESync == 1'b0) || (SSPCPSC == 7'b0000001)) 
    NextSSPCPSC = CPSR;
  else 
      NextSSPCPSC = (SSPCPSC - 7'b0000001);
end // p_CntComb

// -----------------------------------------------------------------------------
// When the SSPCPSC counter reaches 1, assert the SSPCLKDIV signal.
// -----------------------------------------------------------------------------
assign SSPCLKDIV = (SSPCPSC == 7'b0000001);

assign CPSR[7:1] = SSPCPSR;

endmodule

//================================= End ======================================--
