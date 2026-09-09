// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacTrAhbArb.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL081-REL1v0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is responsible for generating HGRANT to AHB Master
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module DmacTrAhbArb (
// Inputs
                     HCLK,
                     HRESETn,
                     HREADYINM,
                     HBUSREQDMAM,
                     HBURSTM,
                     HLOCKDMAM,
                     HGRANTDMAM
                     );

// Inputs
input        HCLK;        // AHB clock
input        HRESETn;     // AHB reset
input        HREADYINM;   // Transfer done response on AHB
input        HBUSREQDMAM; // Bus request signal from AHB
input  [2:0] HBURSTM;     // Burst length on AHB
input        HLOCKDMAM;   // Requesting locked transfers
output       HGRANTDMAM;  // AHB bus grant for master




// Inputs
  wire       HCLK;        // AHB clock
  wire       HRESETn;     // AHB reset
  wire       HREADYINM;   // Transfer done response on AHB
  wire       HBUSREQDMAM; // Bus request signal from AHB
  wire [2:0] HBURSTM;     // Burst length on AHB
  wire       HLOCKDMAM;   // Requesting locked transfers
  wire       HGRANTDMAM;  // AHB bus grant for master

// -----------------------------------------------------------------------------
//
//                              DmacTrAhbArb
//                              ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block is responsible for driving out HGRANT for Master module.
//
// -----------------------------------------------------------------------------


// ---------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg      iHGRANTDMAM;
// The internal version of the Grant to the master logic

reg      NxtHGRANTDMAM;
// The D input of HGRANTDMAM  register

//---------------------------------------------------------------------------
// ---------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// Cobinational assignments
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Sequential processes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Grant Signal Generation
// -----------------------------------------------------------------------------
always @(HREADYINM or HBUSREQDMAM or iHGRANTDMAM)
begin : p_GrantGenComb
  if (HREADYINM == 1'b1)
    begin
      if (HBUSREQDMAM == 1'b1)
        NxtHGRANTDMAM    = HBUSREQDMAM;
      else
        NxtHGRANTDMAM    = 1'b1;
    end
  else
    NxtHGRANTDMAM    = iHGRANTDMAM;
end // p_GrantGenComb

// -----------------------------------------------------------------------------
// Grant Signal Generation sequntial block
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_GrantGenSeq
  if (HRESETn == 1'b0)
    iHGRANTDMAM      <= 1'b0;
  else
    iHGRANTDMAM      <= NxtHGRANTDMAM;
end // p_GrantGenSeq

assign HGRANTDMAM       = iHGRANTDMAM;

endmodule
// --================================== End ==================================--
