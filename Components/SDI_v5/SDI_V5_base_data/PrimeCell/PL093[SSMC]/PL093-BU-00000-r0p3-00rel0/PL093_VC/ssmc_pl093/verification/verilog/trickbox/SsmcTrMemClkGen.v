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
// File Name           : SsmcTrMemClkGen.v.rca
// File Revision       : 1.8
//
// Release Information : PrimeCell(TM)-PL093-r0p1-00ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This module generates the Memory clock SMMemCLK
//
// --=========================================================================--

`timescale 1ns/1ps
`include "../tbench/timing.v"

// -----------------------------------------------------------------------------
module SsmcTrMemClkGen (
// Input
                SMMemClkRatio,
// Output
                SMMemCLK
                
                );


parameter Tclkl = 20;            // HCLK low time
parameter Tclkh = 20;            // HCLK high time
parameter Tclks = 10;            // SMMemCLK start delay

// Input
input  [1:0] SMMemClkRatio;    // Memory clock to HCLk ratio

// Output
output       SMMemCLK;         // Memory Clock


// Input
wire [1:0] SMMemClkRatio;    // Memory clock to HCLk ratio

// Output
reg       SMMemCLK;         // Memory Clock
    

// -----------------------------------------------------------------------------
//
//                             MemClkGen
//                             =========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This module generates the Memory clock SMMemCLK, by toggling the MemCLK
// line after a time periods tclkl(denoting low phase) and
// tclkh (denoting high phase). The values of tclkl and tclkh are
// passed as generic parameters.
// The frequency of the memory clock will be dependent on SMMemClkRatio.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Signal declarations
// -----------------------------------------------------------------------------
reg        StartSMMemCLK;
// Indicates that SMMemCLK can start toggling

//reg        iSMMemCLK;
// internal copy of the SMMemCLK signal

//time       Tsclkh;
real       Tsclkh;
// SMMemCLK high time

//time       Tsclkl;
real       Tsclkl;
// SMMemCLK low time

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

initial
begin
  SMMemCLK = 1'b0;
  Tsclkh   = (Tclkl + Tclkh)/2;
  Tsclkl   = (Tclkl + Tclkh)/2;
end

// -----------------------------------------------------------------------------
// SMMemCLK generation
// -----------------------------------------------------------------------------
 
initial
begin
  SMMemCLK               <= 1'b0;
  StartSMMemCLK         <= 1'b0;
  # Tclks StartSMMemCLK <= 1'b1;
end

always @(StartSMMemCLK)
begin
  if (StartSMMemCLK  == 1'b1)
  forever
  begin
    # Tsclkl SMMemCLK =  1'b1;
    # Tsclkh SMMemCLK =  1'b0;
  end
end

// -----------------------------------------------------------------------------
// Determine the SMMemCLK frequency
// -----------------------------------------------------------------------------

always @(negedge SMMemCLK)
begin : p_ClkRatSeq
  if (SMMemClkRatio == 2'b01)
    begin
      Tsclkh     <= (((Tclkl + Tclkh)/2) * 2);
      Tsclkl     <= (((Tclkl + Tclkh)/2) * 2);
    end
  else if (SMMemClkRatio == 2'b10)
    begin
      Tsclkh      <= (((Tclkl + Tclkh)/2) * 3);
      Tsclkl      <= (((Tclkl + Tclkh)/2) * 3);
    end
  else
    begin
      Tsclkh      <= (((Tclkl + Tclkh)/2) * 1);
      Tsclkl      <= (((Tclkl + Tclkh)/2) * 1);
    end 
end // p_ClkRatSeq
  
endmodule

// --=============================== End =====================================--

