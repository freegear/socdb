// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SsmcTrProtChkr.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module does the protocol checks on the SSMC.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------

module SsmcTrProtChkr (
// Inputs
                      HCLK,
                      HRESETn,
                      SMDATAOUT,
                      SMADDR,
                      nSSMCS,
                      SSMCS,
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
input   [7:0] nSSMCS;      // Active low Memory Bank Select
input   [7:0] SSMCS;       // Memory Bank Select signals from the SSMC
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
  wire  [7:0] nSSMCS;      // Active low Memory Bank Select
  wire  [7:0] SSMCS;       // Memory Bank Select signals from the SMC
  wire  [3:0] nSMDATAEN;   // Data Bus enable signal
  wire        nSMWEN;      // Memory Write enable
  wire  [3:0] nSMBLS;      // Data Bus Lane Enable signal
  wire        nSMOEN;      // Memory read enable


// -----------------------------------------------------------------------------
//
//                                SsmcTrProtChkr
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// SSMC Tricbox is an AHB slave. This block performs the following operations:
//   - Captures non-AMBA, non-memory related signals from the SSMC.
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
wire  [7:0] DelnSSMCS;
// Delayed version of the nSSMCS

wire  [7:0] DelSSMCS;
// Delayed version of the SSMCS 

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
assign # 3 DelnSSMCS        = nSSMCS;
assign # 3 DelSSMCS         = SSMCS;
assign # 2 DelnSMWEN	    = nSMWEN;
assign # 2 DelnSMOEN        = nSMOEN;
assign     nSMBLSWR	    = nSMBLS[0] & nSMBLS[1] & nSMBLS[2] & nSMBLS[3];
assign # 2 DelnSMBLSWR	    = nSMBLSWR;

// -----------------------------------------------------------------------------
// Check for multiple Chip Select assertion (active low)
// -----------------------------------------------------------------------------
always @(DelnSSMCS)
begin : p_MChipSelAlowComb
  if (ResetOver == `TRUE)
    begin
      if (DelnSSMCS == nSSMCS)
        begin
          if ((nSSMCS !== 8'hFE) && (nSSMCS !== 8'hFD) &&
              (nSSMCS !== 8'hFB) && (nSSMCS !== 8'hF7) &&
              (nSSMCS !== 8'hEF) && (nSSMCS !== 8'hDF) &&
              (nSSMCS !== 8'hBF) && (nSSMCS !== 8'h7F) &&
              (nSSMCS !== 8'hFF))
            $display("Time %t SSMCTB1: Multiple Chip Selects are asserted",
                      " simultaneously", $time);
        end
    end
end // p_MChipSelAlowComb

// -----------------------------------------------------------------------------
// Check for multiple Chip Select assertion (active high)
// -----------------------------------------------------------------------------
always @(DelSSMCS)
begin : p_MChipSelAhiComb
  if (ResetOver == `TRUE)
    begin
      if (DelSSMCS == SSMCS)
        begin
          if ((SSMCS !== 8'h01) && (SSMCS !== 8'h02) && 
              (SSMCS !== 8'h04) && (SSMCS !== 8'h08) && 
              (SSMCS !== 8'h10) && (SSMCS !== 8'h20) && 
              (SSMCS !== 8'h40) && (SSMCS !== 8'h80) && 
              (SSMCS !== 8'h00))
            $display("Time %t SSMCTB2: Multiple Chip Selects are asserted",
                     " simultaneously", $time);
        end
    end
end // p_MChipSelAhiComb

// -----------------------------------------------------------------------------
// Check for the assertion of OE or WE when Chip Select is deasserted
// -----------------------------------------------------------------------------
//always @(DelnSSMCS or nSSMCS or DelSSMCS or SSMCS or nSMOEN
//                                         or nSMWEN or nSMBLSWR)
//begin : p_OeWeChkComb
//  if (ResetOver == `TRUE) 
//    begin
//      if ((DelSSMCS == SSMCS) && (DelnSSMCS == nSSMCS)) 
//        begin
//          if ((nSSMCS == 8'hff && DelSSMCS == 8'hff) 
 //             && (SSMCS == 8'h00 && DelSSMCS == 8'h00))
//	    begin
//           if (DelnSMOEN == 1'b0 || DelnSMWEN == 1'b0 || DelnSMBLSWR == 1'b0)
//             $display("Time %t SMCTB3: OEN/WEN is asserted when Chip Select",
//                       " is deasserted" ,$time);
//    end
//        end
//    end
//end // p_OeWeChkComb

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
always @(SMDATAOUT or SMADDR or nSSMCS or SSMCS or nSMDATAEN or nSMWEN
        or nSMBLS or nSMOEN)
begin : p_DATAXChkComb
  if (ResetOver == `TRUE)
    begin
      if ((SMDATAOUT == 32'h00000000) === 1'bx)
        $display("Time %t SMCTB4: X(es) found in SMDATAOUT", $time);

      if ((SMADDR == 26'b00000000000000000000000000) === 1'bx)
        $display("Time %t SMCTB5: X(es) found in SMADDR", $time);

      if ((nSSMCS == 8'h00) === 1'bx)
        $display("Time %t SMCTB6(a): X(es) found in nSSMCS", $time);

      if ((SSMCS == 8'hff) === 1'bx)
        $display("Time %t SMCTB6(b): X(es) found in SSMCS", $time);

      if ((nSMDATAEN == 4'h0) === 1'bx)
        $display("Time %t SMCTB7: X(es) found in nSMDATAEN", $time);

      if (nSMWEN === 1'bx)
        $display("Time %t SMCTB8: X found in nSMWEN", $time);

      if ((nSMBLS == 4'h0) === 1'bx)
        $display("Time %t SMCTB9: X(es) found in nSMBLS", $time);

      if (nSMOEN === 1'bx)
        $display("Time %t SMCTB10: X found in nSMOEN", $time);
    end
end // p_XCheckComb

endmodule
// --================================== End ==================================--
