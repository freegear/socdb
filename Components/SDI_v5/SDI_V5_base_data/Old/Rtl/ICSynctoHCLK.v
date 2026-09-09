// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name             : ICSynctoHCLK.v,v
// File Revision         : 1.3
//
// Release Information   : ADK_REL1v1
//
// ---------------------------------------------------------------------
// Purpose :
//           This module synchronises signals ICRawIntrCo, ICIRQStatusCo,
//           ICFIQStatus to the HCLK domain to remove metastability problems.
//
// --=================================================================--
//
//                            ICSynctoHCLK
//                           =============
//
// ---------------------------------------------------------------------
//
// Overview
// ========
//   This block synchronises the asynchronous input signals
// ICRawIntrCo, ICIRQStatusCo and ICFIQStatusCo to the HCLK domain.
// Synchronisation is achieved by passing each bit of the input signals
// through 2 D-types clocked by HCLK.
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Component declaration
// ---------------------------------------------------------------------

`timescale 1ns/1ps

module ICSynctoHCLK (HCLK, HRESETn, ICRawIntrCo, ICIRQStatusCo, ICFIQStatusCo,
                     ICRawIntrSync, ICIRQStatusSync, ICFIQStatusSync);

  input          HCLK;              // AHB Bus Clock
  input          HRESETn;           // AHB Bus Reset
  input  [31:0]  ICRawIntrCo;       // IC Raw Interrupt
  input  [31:0]  ICIRQStatusCo;     // IRQ Status
  input  [31:0]  ICFIQStatusCo;     // FIQ Status

  output [31:0]  ICRawIntrSync;     // Synced ICRawIntr
  output [31:0]  ICIRQStatusSync;   // Synced ICIRQStatus
  output [31:0]  ICFIQStatusSync;   // Synced ICFIQStatus


// ---------------------------------------------------------------------
// Signal declarations
// ---------------------------------------------------------------------

// Input/Output Signals
  wire         HCLK;
  wire         HRESETn;
  wire [31:0]  ICRawIntrCo;
  wire [31:0]  ICIRQStatusCo;
  wire [31:0]  ICFIQStatusCo;

// Internal Signals
  // Synchronised versions of inputs
  reg  [31:0]  ICRawIntrSync;
  reg  [31:0]  ICIRQStatusSync;
  reg  [31:0]  ICFIQStatusSync;

  // 1st stage synchronised versions of inputs
  reg  [31:0]  ICRawIntrSync1;
  reg  [31:0]  ICIRQStatSync1;
  reg  [31:0]  ICFIQStatSync1;

// ---------------------------------------------------------------------
// Constant declarations
// ---------------------------------------------------------------------

  `define ZEROFILL {32{1'b0}}

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
// Double-synchronisers for ICRawIntr, ICIRQStatus, ICFIQStatus.
// ---------------------------------------------------------------------
  always @ (posedge HCLK or negedge HRESETn)
  begin : p_SyncHCLKSeq
    if (!HRESETn)
      begin
        ICRawIntrSync1  <= `ZEROFILL;
        ICRawIntrSync   <= `ZEROFILL;
        ICIRQStatSync1  <= `ZEROFILL;
        ICIRQStatusSync <= `ZEROFILL;
        ICFIQStatSync1  <= `ZEROFILL;
        ICFIQStatusSync <= `ZEROFILL;
      end
    else
      begin
        ICRawIntrSync1  <= ICRawIntrCo;
        ICRawIntrSync   <= ICRawIntrSync1;
        ICIRQStatSync1  <= ICIRQStatusCo;
        ICIRQStatusSync <= ICIRQStatSync1;
        ICFIQStatSync1  <= ICFIQStatusCo;
        ICFIQStatusSync <= ICFIQStatSync1;
      end
  end

endmodule
