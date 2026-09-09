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
// File Name              : SsmcTrMemArray.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Serve as Memory array
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SsmcTrParams.v"

// -----------------------------------------------------------------------------

module SsmcTrMemArray (
// Inputs
                       HCLK,
                       HRESETn,
                       nCS,
                       nSMBLS,
                       SMFBCLK,
                       SMCLK,
                       SSMCTrMEMARRAYWr,
                       LatchHADDR,
                       LatchSMADDR,
                       HWDATA,
                       MemWrDatab,
                       SMMemClkRatio,
// Outputs
                       AhbRdDatab,
                       MemRdDatab
                       );

parameter  Tclk = 10.56;         // HCLK Period
      
// Inputs
input         HCLK;             // AHB clock input
input         HRESETn;          // Bus Reset
input         nCS;              // Chip select
input         nSMBLS;           // SMC Write enable
input         SMFBCLK;          // SSMC feedback clock
input         SMCLK;            // Clock from SSMS  for synchronous memory 
                                // accesses 
input         SSMCTrMEMARRAYWr; // AHB Write enable
input  [10:0] LatchHADDR;       // Latched AHB Address
input  [10:0] LatchSMADDR;      // Latched Memory Address
input   [7:0] HWDATA;           // AHB Write data
input   [7:0] MemWrDatab;       // Mem Write data
input   [1:0] SMMemClkRatio;    // Clock Ratio



// Outputs
output  [7:0] AhbRdDatab;       // AHB read data
output  [7:0] MemRdDatab;       // Mem Read Data




// Inputs
  wire        HCLK;             // AHB clock input
  wire        HRESETn;          // Bus Reset
  wire        nCS;              // Chip select
  wire        nSMBLS;           // SMC Write enable
  wire        SMFBCLK;          // SSMC feedback clock
  wire        SMCLK;            // Clock from SSMS  for synchronous memory 
                                // accesses 
  wire        SSMCTrMEMARRAYWr; // AHB Write enable
  wire [10:0] LatchHADDR;       // Latched AHB Address
  wire [10:0] LatchSMADDR;      // Latched Memory Address
  wire  [7:0] HWDATA;           // AHB Write data
  wire  [7:0] MemWrDatab;       // Mem Write data
  wire  [1:0] SMMemClkRatio;    // Clock Ratio 



// Outputs
  wire  [7:0] AhbRdDatab;       // AHB read data
  wire  [7:0] MemRdDatab;       // Mem Read Data


// -----------------------------------------------------------------------------
//
//                                SsmcTrMemArray
//                                ==============
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

wire    DelWriteOK43;
// Delayed version of WriteOK43; 

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

reg [7:0] MemFile[`MemDeep:0];
// Memory Array

integer i;
// FOR LOOP variable

integer up;
// Counter for WriteOK43 to remain high

integer down; 
// Counter for WriteOK43 to remain low
reg     WriteOK;
// To consider the clock ratio

reg     SampSMCLK;
// SMCLK sample on HCLK 

reg     WriteOK43;
// WriteOK signal for clock ratio 1:3 

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

assign #2 DelWriteOK43  = WriteOK43;  

// -----------------------------------------------------------------------------
// Write Ok signal for Clock ration 1:3 generation logic
// -----------------------------------------------------------------------------
initial
begin
  WriteOK43               <= 1'b1;
end
always @ (posedge HCLK)
begin
 if(SMCLK == 1'b1)
   SampSMCLK <= 1'b1;
 else
   SampSMCLK <= 1'b0;
end

always @(posedge HCLK)
begin
  if (SMMemClkRatio == 2'b10)
      begin
        WriteOK43 <= SampSMCLK;
      end 
  else    
   WriteOK43 <= 1'b1;
end

// -----------------------------------------------------------------------------
// Clk Ratio consideration
// -----------------------------------------------------------------------------
always @(SMMemClkRatio or SMFBCLK or DelWriteOK43)
begin : p_ClkConsdrComb
  case (SMMemClkRatio)
     2'b00   : WriteOK <= 1'b1;
     2'b01   : WriteOK <= ~(SMFBCLK);
     2'b10   : WriteOK <= DelWriteOK43;
     default : WriteOK <= 1'b1;
  endcase
end // p_ClkConsdrComb

// -----------------------------------------------------------------------------
// This process performing two functions.
// Initialise the all memory with '0' at the starting.
// Perform write operation both from the AHB and the Smc side. If both AHB
// and Smc try to write at the same location, preference is given to Smc.
// -----------------------------------------------------------------------------
always @(posedge SMFBCLK or posedge HCLK or nCS or WriteOK)
begin : p_MemWriteComb
  if (LatchSMADDR != LatchHADDR)
    begin
      if ((SMFBCLK == 1'b1) && (nSMBLS == 1'b0) && (nCS == 1'b0)
                            && (WriteOK == 1'b1))
         MemFile[LatchSMADDR] <= MemWrDatab;

      if ((HCLK == 1'b1) && (SSMCTrMEMARRAYWr == 1'b1))
         MemFile[LatchHADDR] <= HWDATA;
    end
  else
    begin
      if ((SMFBCLK == 1'b1) && (nSMBLS == 1'b0) && (nCS == 1'b0)
                            && (WriteOK == 1'b1))
         MemFile[LatchSMADDR] = MemWrDatab;
      else if ((HCLK == 1'b1) && (SSMCTrMEMARRAYWr == 1'b1))
        MemFile[LatchHADDR] = HWDATA;
    end
end // p_MemWriteComb

endmodule
// --================================== End ==================================--
