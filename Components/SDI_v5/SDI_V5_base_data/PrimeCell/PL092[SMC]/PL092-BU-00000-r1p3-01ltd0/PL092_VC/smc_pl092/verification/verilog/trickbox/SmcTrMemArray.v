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
// File Name              : SmcTrMemArray.v.rca
// File Revision          : 1.14
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Serve as Memory array
//
// --=========================================================================--

`timescale 1ns/1ps

// Include Parameter File
`include "SmcTrParams.v"

// -----------------------------------------------------------------------------

module SmcTrMemArray (
// Inputs
                      HCLK,
                      HRESETn,
                      nCS,
                      CANCELSMWAIT,
                      nSMWAIT,
                      nSMBLS,
                      SMCTrMEMRWr,
                      LatchHADDR,
                      LatchSMADDR,
                      HWDATA,
                      MemWrDatab,

// Outputs
                      AhbRdDatab,
                      MemRdDatab
                     );

// Inputs
input         HCLK;        // AHB clock input
input         HRESETn;     // Bus Reset
input         nCS;         // Chip select
input         CANCELSMWAIT;// Cancel SMWAIT signal 
input         nSMWAIT;     // Wait signal for SMC transfers 
input         nSMBLS;      // SMC Write enable
input         SMCTrMEMRWr; // AHB Write enable
input  [10:0] LatchHADDR;  // Latched AHB Address
input  [10:0] LatchSMADDR; // Latched Memory Address
input   [7:0] HWDATA;      // AHB Write data
input   [7:0] MemWrDatab;  // Mem Write data



// Outputs
output  [7:0] AhbRdDatab;  // AHB read data
output  [7:0] MemRdDatab;  // Mem Read Data




// Inputs
  wire        HCLK;        // AHB clock input
  wire        HRESETn;     // Bus Reset
  wire        nCS;         // Chip select
  wire        CANCELSMWAIT;// Cancel SMWAIT signal 
  wire        nSMWAIT;     // Wait Signal fo SMC transfers
  wire        nSMBLS;      // SMC Write enable
  wire        SMCTrMEMRWr; // AHB Write enable
  wire [10:0] LatchHADDR;  // Latched AHB Address
  wire [10:0] LatchSMADDR; // Latched Memory Address
  wire  [7:0] HWDATA;      // AHB Write data
  wire  [7:0] MemWrDatab;  // Mem Write data



// Outputs
  wire  [7:0] AhbRdDatab;  // AHB read data
  wire  [7:0] MemRdDatab;  // Mem Read Data


// -----------------------------------------------------------------------------
//
//                                SmcTrMemArray
//                                =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
// This block contains an array of memory of width 8-bit. Its depth depends
// on the parameter MemDeep in the SmcTrConst file. It is possible to access
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
reg  [7:0]  MemFile[`MemDeep:0];
// Memory Array

reg  CancelCame;

wire nSMBLSDel;
wire SMCTrMEMRWrDel;
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
assign MemRdDatab       = MemFile[LatchSMADDR];

// -----------------------------------------------------------------------------
// This process performing two functions.
// Initialise the all memory with '0' at the starting.
// Perform write operation both from the AHB and the Smc side. If both AHB
// and Smc try to write at the same location, preference is given to Smc.
// -----------------------------------------------------------------------------
always @(posedge CANCELSMWAIT or posedge nCS)
begin : p_CancelCameComb
  if (nCS == 1'b1)
    CancelCame = 1'b0;

  if ((CANCELSMWAIT == 1'b1) && (nCS == 1'b0) && (nSMWAIT == 1'b0))
    CancelCame = 1'b1;
end // p_CancelCameComb

assign #1 nSMBLSDel = nSMBLS;
assign #1 SMCTrMEMRWrDel  = SMCTrMEMRWr;

always @(LatchHADDR or HWDATA or SMCTrMEMRWrDel)
begin : p_MemSMCWriteComb
  if ((SMCTrMEMRWrDel == 1'b1) && (SMCTrMEMRWr == 1'b1))
    MemFile[LatchHADDR]      = HWDATA;
end // p_MemSMCWriteComb

always @(nSMBLSDel)
begin : p_SMWrComb
  if ((nCS == 1'b0) && (CancelCame == 1'b0) && (nSMBLS == 1'b1) 
      && (nSMBLSDel == 1'b1))
  begin
      MemFile[LatchSMADDR] = MemWrDatab;
  end
end // p_SMWrComb


always @(negedge HRESETn)
begin : p_ResetArrayComb
  if (HRESETn == 1'b0)
   for (i = 0; i <= `MemDeep; i = i + 1)
     MemFile[i] = 8'h00;
end // p_ResetArrayComb

endmodule
// --================================== End ==================================--
