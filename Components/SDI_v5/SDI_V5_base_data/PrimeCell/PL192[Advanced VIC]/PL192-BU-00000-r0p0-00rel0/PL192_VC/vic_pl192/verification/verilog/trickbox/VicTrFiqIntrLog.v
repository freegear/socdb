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
// File Name              : VicTrFiqIntrLog.v.rca
// File Revision          : 1.6
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose : The module generates the FIQ Interrupt.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module VicTrFiqIntrLog (
// Inputs
                    HCLK,
                    HRESETn,
                    TrFiqStatus,
                    nVicTrFiqIn,
                    VicTrFiqInReg,

// Outputs
                    nVicTrFiq
                    );

// Inputs
input         HCLK;            // AHB Clock
input         HRESETn;         // AHB Reset
input  [31:0] TrFiqStatus;     // Fiq Status from Interrupt request block 
input         nVicTrFiqIn;     // Fiq Interrupt from daisy chain
input         VicTrFiqInReg;   // Enable bit to latch Fiq Interrupt
                               // from Daisy chain 

// Outputs
output        nVicTrFiq;       // FIQ Interrupt output

// Inputs
wire          HCLK;            // AHB Clock
wire          HRESETn;         // AHB Reset
wire   [31:0] TrFiqStatus;     // Fiq Status  
wire          nVicTrFiqIn;     // Fiq Interrupt from daisy chain
wire          VicTrFiqInReg;   // Enable bit to latch Fiq Interrupt
                               // from Daisy chain 
// Outputs
wire          nVicTrFiq;       // FIQ Interrupt output 

// -----------------------------------------------------------------------------
//
//                             VicTrFiqIntrLog
//                             ===============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module receives the TrFiqStatus and the Daisy FIQ Interrupt from the 
// Interrupt Request block and generates the FIQ Interrupt nVicTrFiq.
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire       InvnVicTrFiqIn;
// Inverted version of VicTrFiqIn

wire       DaisyFiqIn;
// Daisy Fiq output 

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg       RegnVicTrFiq;
// Registered Daisy chain Fiq Interrupt

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
// nVicTrFiq generation
// -----------------------------------------------------------------------------
assign InvnVicTrFiqIn  = ~nVicTrFiqIn;

// -----------------------------------------------------------------------------
// Registering the FIQ Interrupt from Daisy chain if VicTrFiqInReg is
// enabled.
// -----------------------------------------------------------------------------
always@(posedge HCLK or negedge HRESETn)
begin : p_FiqDaisy
  if(HRESETn == 1'b0)
    RegnVicTrFiq <= 1'b0;
  else
    RegnVicTrFiq <= InvnVicTrFiqIn;
end //p_FiqDaisy

assign DaisyFiqIn = (VicTrFiqInReg == 1'b1) ? 
                     RegnVicTrFiq : InvnVicTrFiqIn; 

assign nVicTrFiq = ~(DaisyFiqIn | (|TrFiqStatus));

endmodule

// --============================== End ======================================--
