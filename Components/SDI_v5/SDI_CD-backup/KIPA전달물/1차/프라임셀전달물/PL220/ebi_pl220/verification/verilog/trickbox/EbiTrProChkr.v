// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : EbiTrProChkr.v.rca
// File Revision          : 1.2
//
// Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module does the protocol checks on the EBI.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "EbiTrParams.v"

module EbiTrProChkr (
// Inputs
                     EBICLK,
                     HRESETn,
                     EBIGNT1,
                     EBIGNT2,
                     EBIGNT3,
                     EBIBACKOFF1,
                     EBIBACKOFF2,
                     EBIBACKOFF3,
                     EBIDATAIN,
                     EBIEXTADDROUT,
                     EBIEXTDATAOUT,
                     nEBIEXTDATAEN
                    );

// Inputs
input         EBICLK;        // Clock Input
input         HRESETn;       // Reset from AHB
input         EBIGNT1;       // Grant to Port1
input         EBIGNT2;       // Grant to Port2
input         EBIGNT3;       // Grant to Port3
input         EBIBACKOFF1;   // Backoff signal to Port1
input         EBIBACKOFF2;   // Backoff signal to Port2
input         EBIBACKOFF3;   // Backoff signal to Port3
input  [31:0] EBIDATAIN;     // data in from EBI
input  [31:0] EBIEXTADDROUT; // Address from EBI
input  [31:0] EBIEXTDATAOUT; // Data from EBI
input   [3:0] nEBIEXTDATAEN; // DataEn from EBI

// Inputs
wire        EBICLK;        // Clock Input
wire        HRESETn;       // Reset from AHB
wire        EBIGNT1;       // Grant to Port1
wire        EBIGNT2;       // Grant to Port2
wire        EBIGNT3;       // Grant to Port3
wire        EBIBACKOFF1;   // Backoff signal to Port1
wire        EBIBACKOFF2;   // Backoff signal to Port2
wire        EBIBACKOFF3;   // Backoff signal to Port3
wire [31:0] EBIDATAIN;     // data in from EBI
wire [31:0] EBIEXTADDROUT; // Address from EBI
wire [31:0] EBIEXTDATAOUT; // Data from EBI
wire  [3:0] nEBIEXTDATAEN; // DataEn from EBI

// -----------------------------------------------------------------------------
//
//                                EbiTrProChkr
//                                ============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module does the following functionality
//    o Checks EBI signals going to 'X's
//    o Checks for multiple assertion of grant and backoff signals
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         ResetAssrtd;
// Indicates the start of checks

reg         ResetOver;
// Indicates the start of checks

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of Code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// StartCheck signal is set once the Reset is applied
// -----------------------------------------------------------------------------
always @(HRESETn or ResetAssrtd)
begin : p_ResetOverComb
  if ((ResetAssrtd) && HRESETn == 1'b1)
     ResetOver <= `TRUE;
end // p_ResetOverComb

always @(posedge EBICLK)
begin : p_ResetStrComb
  if (HRESETn == 1'b0)
    ResetAssrtd <= `TRUE;
end // p_ResetStrComb

// -----------------------------------------------------------------------------
// This combinational logic checks for X-s on EBI output lines. If there is
// 'X' on the signal lines then warning message will be displayed
// -----------------------------------------------------------------------------
always @(EBIGNT1 or EBIGNT2 or EBIGNT3 or EBIBACKOFF1 or EBIBACKOFF2 or
         EBIBACKOFF3 or EBIEXTADDROUT or EBIEXTDATAOUT or nEBIEXTDATAEN or
         EBIDATAIN)
begin : p_XCheckComb
  if (ResetOver == `TRUE)
    begin
      if (EBIGNT1 == 1'bx)
        $display("Error : Time %t : EBITR1: X(es) found in EBIGNT1", $time);

      if (EBIGNT2 == 1'bx)
        $display("Error : Time %t : EBITR2: X(es) found in EBIGNT2", $time);

      if (EBIGNT3 == 1'bx)
        $display("Error : Time %t : EBITR3: X(es) found in EBIGNT3", $time);

      if (EBIBACKOFF1 == 1'bx)
        $display("Error : Time %t : EBITR4: X(es) found in EBIBACKOFF1", $time);

      if (EBIBACKOFF2 == 1'bx)
        $display("Error : Time %t : EBITR5: X(es) found in EBIBACKOFF2", $time);

      if (EBIBACKOFF3 == 1'bx)
        $display("Error : Time %t : EBITR6: X found in EBIBACKOFF3", $time);

      if ((EBIEXTADDROUT == 32'h00000000) === 1'bx)
        $display("Error : Time %t : EBITR7: X(es) found in EBIEXTADDROUT", $time);

      if ((EBIEXTDATAOUT == 32'h00000000) === 1'bx)
        $display("Error : Time %t : EBITR8: X found in EBIEXTDATAOUT", $time);

      if ((nEBIEXTDATAEN == 4'b0000) === 1'bx)
        $display("Error : Time %t : EBITR9: X found in nEBIEXTDATAEN", $time);

      if ((EBIDATAIN == 32'h00000000) === 1'bx)
        $display("Error : Time %t : EBITR10: X(es) found in EBIDATAIN", $time);
    end
end // p_XCheckComb

// -----------------------------------------------------------------------------
// This combination logic checks for multiple assertion of grant and backoff
// signal. If there is any violation of protocol then Error message will be
// displayed.
// -----------------------------------------------------------------------------
always @(posedge EBICLK)
begin : p_MuitiAssertComb
  if ((EBIGNT1 == 1'b1 & (EBIGNT2 == 1'b1 | EBIGNT3 == 1'b1)) |
      (EBIGNT2 == 1'b1 & (EBIGNT1 == 1'b1 | EBIGNT3 == 1'b1)) |
      (EBIGNT3 == 1'b1 & (EBIGNT1 == 1'b1 | EBIGNT2 == 1'b1)))
     $display("Error : Time %t : EBITR11 : Multiple assertion of EBIGNT signal", $time);
  if ((EBIBACKOFF1 == 1'b1 & (EBIBACKOFF2 == 1'b1 | EBIBACKOFF3 == 1'b1)) |
      (EBIBACKOFF2 == 1'b1 & (EBIBACKOFF1 == 1'b1 | EBIBACKOFF3 == 1'b1)) |
      (EBIBACKOFF3 == 1'b1 & (EBIBACKOFF1 == 1'b1 | EBIBACKOFF2 == 1'b1)))
     $display("Error : Time %t : EBITR12 : Multiple assertion of EBIBACKOFF signal", $time);
end // p_MuitiAssertComb

endmodule
// --================================== End ==================================--
