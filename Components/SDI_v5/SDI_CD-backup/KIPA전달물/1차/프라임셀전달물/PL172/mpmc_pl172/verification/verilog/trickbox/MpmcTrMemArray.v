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
// File Name              : MpmcTrMemArray.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block serves as Memory array for the Trickmem memory model
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "MpmcTrParams.v"

// -----------------------------------------------------------------------------

module MpmcTrMemArray (
// Inputs
                       HCLK,
                       HRESETn,
                       nCS,
                       nMPMCBLS,
                       MPMCTrMEMRWr,
                       LatchHADDR,
                       LatchMCADDR,
                       HWDATA,
                       MemWrDatab,

// Outputs
                       AhbRdDatab,
                       MemRdDatab
                      );

// Inputs
input         HCLK;             // AHB clock input
input         HRESETn;          // Bus Reset
input         nCS;              // Chip select
input         nMPMCBLS;         // MPMC Write enable
input         MPMCTrMEMRWr;     // AHB Write enable
input  [10:0] LatchHADDR;       // Latched AHB Address
input  [10:0] LatchMCADDR;      // Latched Memory Address
input   [7:0] HWDATA;           // AHB Write data
input   [7:0] MemWrDatab;       // Mem Write data

// Outputs
output  [7:0] AhbRdDatab;       // AHB read data
output  [7:0] MemRdDatab;       // Mem Read Data

// Inputs
wire          HCLK;             // AHB clock input
wire          HRESETn;          // Bus Reset
wire          nCS;              // Chip select
wire          nMPMCBLS;         // MPMC Write enable
wire          MPMCTrMEMRWr;     // AHB Write enable
wire   [10:0] LatchHADDR;       // Latched AHB Address
wire   [10:0] LatchMCADDR;      // Latched Memory Address
wire    [7:0] HWDATA;           // AHB Write data
wire    [7:0] MemWrDatab;       // Mem Write data

// Outputs
wire    [7:0] AhbRdDatab;       // AHB read data
wire    [7:0] MemRdDatab;       // Mem Read Data

// -----------------------------------------------------------------------------
//
//                               MpmcTrMemArray
//                               ==============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This block contains an array of memory of width 8-bit. Its depth depends
// on the parameter MemDeep in the MpmcTrParams file. It is possible to access
// this memory array both from the AHB and the memory side.
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
reg     [7:0] MemFile[`MemDeep:0];
// Memory Array

integer i;
// FOR LOOP variable

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of Code
// =================
//
// -----------------------------------------------------------------------------

initial
begin
  for (i = 0; i <= `MemDeep; i = i + 1)
    MemFile[i] = 8'h00;
end

// -----------------------------------------------------------------------------
// The contents of the location pointed to by the current value of
// the pointer IntLatchHADDR and IntLatchXADDR are driven to the AhbRdDatab
// and MemRdDatab.
// -----------------------------------------------------------------------------
assign AhbRdDatab       = MemFile[LatchHADDR];
assign MemRdDatab       = MemFile[LatchMCADDR];

// -----------------------------------------------------------------------------
// This process performing two functions.
// Initialise the all memory with '0' at the starting.
// Perform write operation both from the AHB and the Mpmc side. If both AHB
// and Mpmc try to write at the same location, preference is given to Mpmc.
// -----------------------------------------------------------------------------
always @(nMPMCBLS or HCLK or LatchMCADDR or nCS)
begin : p_MemWriteComb
  if (LatchMCADDR != LatchHADDR)
    begin
      if ((nMPMCBLS == 1'b0) && (nCS == 1'b0))
        MemFile[LatchMCADDR] <= MemWrDatab;

      if ((HCLK == 1'b1) && (MPMCTrMEMRWr == 1'b1))
        MemFile[LatchHADDR] <= HWDATA;
    end
  else
    begin
      if ((nMPMCBLS == 1'b0) && (nCS == 1'b0))
        MemFile[LatchMCADDR] = MemWrDatab;
      else if ((HCLK == 1'b1) && (MPMCTrMEMRWr == 1'b1))
        MemFile[LatchHADDR] = HWDATA;
    end
end // p_MemWriteComb

endmodule

// --================================== End ==================================--
