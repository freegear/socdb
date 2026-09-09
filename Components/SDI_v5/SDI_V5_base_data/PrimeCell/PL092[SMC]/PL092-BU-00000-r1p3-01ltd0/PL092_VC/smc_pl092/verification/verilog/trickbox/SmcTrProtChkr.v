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
// File Name              : SmcTrProtChkr.v.rca
// File Revision          : 1.14
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module does the protocol checks on the SMC.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SmcTrProtChkr (
// Inputs
                      HCLK,
                      HRESETn,
                      SMDATAOUT,
                      SMADDR,
                      SMCActLowCS,
                      SMCS,
                      nSMDATAEN,
                      nSMWEN,
                      nSMBLS,
                      nSMOEN
                     );

// Inputs
input         HCLK;        // AHB Bus Clock
input         HRESETn;     // Bus Reset
input  [31:0] SMDATAOUT;   // Memory Data Out from the SMC for
                           // checking 'X'es on it
input  [25:0] SMADDR;      // Memory Address from the SMC for checking
                           // 'X'es on it
input   [7:0] SMCActLowCS; // Active low Memory Bank Select
input   [7:0] SMCS;        // Memory Bank Select signals from the SMC
input   [3:0] nSMDATAEN;   // Data Bus enable signal
input         nSMWEN;      // Memory Write enable
input   [3:0] nSMBLS;      // Data Bus Lane Enable signal
input         nSMOEN;      // Memory read enable

// Inputs
  wire        HCLK;        // AHB Bus Clock
  wire        HRESETn;     // Bus Reset
  wire [31:0] SMDATAOUT;   // Memory Data Out from the SMC for
                           // checking 'X'es on it
  wire [25:0] SMADDR;      // Memory Address from the SMC for checking
                           // 'X'es on it
  wire  [7:0] SMCActLowCS; // Active low Memory Bank Select
  wire  [7:0] SMCS;        // Memory Bank Select signals from the SMC
  wire  [3:0] nSMDATAEN;   // Data Bus enable signal
  wire        nSMWEN;      // Memory Write enable
  wire  [3:0] nSMBLS;      // Data Bus Lane Enable signal
  wire        nSMOEN;      // Memory read enable


// -----------------------------------------------------------------------------
//
//                                SmcTrProtChkr
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SMC Tricbox is an AHB slave. This block performs the following operations:
//   - Captures non-AMBA, non-memory related signals from the SMC.
//   - Does the protocol checks on the SMC.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------
`define TRUE  1'b1

`define FALSE 1'b0

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [7:0] DelSMCS;
// Delayed version of the SMCActLowCS 

wire DelnSMWEN;
//Delayed version of nSMWEN;

wire DelnSMOEN;
//Delayed version of nSMOEN;

wire nSMBLSWR;
//Memory write enable when byte lane is using as write enable

wire DelnSMBLSWR;
// Delayed version of nSMBLSWR


integer     i;
// FOR loop variable

integer     j;
// FOR loop variable

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg         ResetAssrtd;
// Indicates that initial reset has been applied

reg         ResetOver;
// Indicates that initial reset has been applied

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial
begin
  ResetOver   = `FALSE;
  ResetAssrtd = `FALSE;
end

// -----------------------------------------------------------------------------
// Generating th Delayed SMCS
// -----------------------------------------------------------------------------
assign # 3 DelSMCS          = SMCActLowCS;
assign # 2 DelnSMWEN	    = nSMWEN;
assign # 2 DelnSMOEN        = nSMOEN;
assign nSMBLSWR		    = nSMBLS[0] & nSMBLS[1] & nSMBLS[2] & nSMBLS[3];
assign # 2 DelnSMBLSWR	    = nSMBLSWR;

// -----------------------------------------------------------------------------
// Check for multiple Chip Select assertion
// -----------------------------------------------------------------------------
always @(DelSMCS)
begin : p_MChipSelComb
  if (ResetOver == `TRUE)
    begin
      if (DelSMCS == SMCActLowCS)
        begin
          if ((SMCActLowCS !== 8'hFE) && (SMCActLowCS !== 8'hFD) &&
              (SMCActLowCS !== 8'hFB) && (SMCActLowCS !== 8'hF7) &&
              (SMCActLowCS !== 8'hEF) && (SMCActLowCS !== 8'hDF) &&
              (SMCActLowCS !== 8'hBF) && (SMCActLowCS !== 8'h7F) &&
              (SMCActLowCS !== 8'hFF))
            $display("Time %t SMCTB8: Multiple Chip Selects are asserted simultaneously", $time);
        end
    end
end // p_MChipSelComb

// -----------------------------------------------------------------------------
// Check for the assertion of OE or WE when Chip Select is deasserted
// -----------------------------------------------------------------------------
always @(DelSMCS or SMCActLowCS or nSMOEN or nSMWEN or nSMBLSWR)
begin : p_OeWeChkComb
  if (ResetOver == `TRUE) 
    begin
      if (DelSMCS == SMCActLowCS) 
        begin
          if (SMCActLowCS == 'hff && DelSMCS == 'hff) 
	   begin
             if (DelnSMOEN == 1'b0 || DelnSMWEN == 1'b0 || DelnSMBLSWR == 1'b0)
               $display("Time %t SMCTB9: OEN/WEN is asserted when Chip Select is deasserted" ,$time);
	   end
        end
    end
end // p_OeWeChkComb;

// -----------------------------------------------------------------------------
// StartCheck signal is set once the Reset is applied
// -----------------------------------------------------------------------------
always @(HRESETn or ResetAssrtd)
begin : p_ResetOverComb
  if ((ResetAssrtd) && HRESETn == 1'b1)
      ResetOver     <= `TRUE;
end // p_ResetOverComb

always @(posedge HCLK)
begin : p_ResetStrComb
  if (HRESETn == 1'b0)
    ResetAssrtd <= `TRUE;
end // p_ResetStrComb

// -----------------------------------------------------------------------------
// 'X' check on SMC related signal.
// -----------------------------------------------------------------------------
always @(SMDATAOUT or SMADDR or SMCS or nSMDATAEN or nSMWEN or nSMBLS or
         nSMOEN)
begin : p_DATAXChkComb
  if (ResetOver == `TRUE)
    begin
      if ((SMDATAOUT == 32'h00000000) === 1'bx)
        $display("Time %t SMCTB1: X(es) found in SMDATAOUT", $time);

      if ((SMADDR == 26'b00000000000000000000000000) === 1'bx)
        $display("Time %t SMCTB2: X(es) found in SMADDR", $time);

      if ((SMCS == 8'h00) === 1'bx)
        $display("Time %t SMCTB3: X(es) found in SMCS", $time);

      if ((nSMDATAEN == 4'h0) === 1'bx)
        $display("Time %t SMCTB4: X(es) found in nSMDATAEN", $time);

      if (nSMWEN === 1'bx)
        $display("Time %t SMCTB5: X found in nSMWEN", $time);

      if ((nSMBLS == 4'h0) === 1'bx)
        $display("Time %t SMCTB6: X(es) found in nSMBLS", $time);

      if (nSMOEN === 1'bx)
        $display("Time %t SMCTB7: X found in nSMOEN", $time);
    end
end // p_XCheckComb

endmodule
// --================================== End ==================================--
