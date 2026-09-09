//  ---------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : $RCS: $
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
//  ----------------------------------------------------------------------------
//
//  ----------------------------------------------------------------------------
//  Purpose                : This module generates the ExtBusGnt Signal to the
//                           UUT 
//  ----------------------------------------------------------------------------
//
`timescale 1ns/1ps

module SdramTrBusGnt (
                       HCLK,
                       nReset,
                       ExtBusReq,
                       BusGntMode,
                       BusGntClk,
                       BusGntHigh,
                       ExtBusGnt
                     ); 

input       HCLK;          // AHB Clock Input
input       nReset;        // Trickbox Reset
input       ExtBusReq;     // Bus Request driven by the UUT
input       BusGntMode;    // Selects Deterministic/Random ExtBusGntDelay
input       BusGntHigh;    // Bit to pull the ExtBusGnt High
input [4:0] BusGntClk;     // Delay between ExtBusGnt Assertion and Request.

output      ExtBusGnt;     // Bus Grant Output to the UUT

// ----------------------------------------------------------------------------
//
//                              SdramTrBusGnt 
//                              =============
//
// ----------------------------------------------------------------------------
//  Overview
//  ========
// 
// This module implements the following ExtBusGnt generation modes:
// - ExtBusGnt high at the start  
// - Deterministic, programmable delay between ExtBusReq and ExtBusGnt  
// - Random delay between ExtBusReq and ExtBusGnt  
// ----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------------
wire       HCLK;
wire       nReset;
wire       ExtBusReq;
wire       BusGntMode;
wire [4:0] BusGntClk;

// ---------------------------------------------------------------------------
// Register declarations 
// ---------------------------------------------------------------------------
reg        ExtBusGnt;
reg  [2:0] LstCount;
reg  [2:0] NextLstCount;
reg  [4:0] DetCount;
reg  [4:0] NextDetCount;
reg  [4:0] RandCount;
reg  [4:0] NextRandCount;

// ---------------------------------------------------------------------------
// Constant Declaration 
// ---------------------------------------------------------------------------
`define BUSGNTDELAYHIG 5'b11000
`define BUSGNTDELAYLOW 3'b000

// ----------------------------------------------------------------------------
//
//  Main body of code
//
// ----------------------------------------------------------------------------

always @(DetCount or RandCount or BusGntMode or ExtBusReq or BusGntClk or 
         LstCount or BusGntHigh)
begin : p_BusGntModeComb
  if (BusGntHigh)
    ExtBusGnt = 1'b1;
  else if (~BusGntMode)
  begin          // Deterministic Mode
    if ((DetCount == BusGntClk) && ExtBusReq)
      ExtBusGnt = 1'b1;
    else if (~ExtBusReq && (LstCount == `BUSGNTDELAYLOW)) 
      ExtBusGnt = 1'b0;
  end 
  else
  begin        // Random Mode
    if ((RandCount == `BUSGNTDELAYHIG) && ExtBusReq)
      ExtBusGnt = 1'b1;
    else if (~ExtBusReq && (LstCount == `BUSGNTDELAYLOW)) 
      ExtBusGnt = 1'b0;
  end
end // p_BusGntModeComb

// ---------------------------------------------------------------------------
// ExtBusGntLst Counter
// ---------------------------------------------------------------------------
always @(LstCount or ExtBusReq or ExtBusGnt) 
begin : p_LstCountComb
  if ((ExtBusReq && ExtBusGnt) || ~ExtBusGnt)
    NextLstCount = 3'b000;
  else if (~ExtBusReq && ExtBusGnt)
    NextLstCount = LstCount + 1'b1;
  else
    NextLstCount = LstCount;
end // p_LstCountComb

always @(posedge HCLK or negedge nReset)
begin : p_LstCountSeq
  if (~nReset)
    LstCount <= 3'b000;
  else
    LstCount <= NextLstCount;
end // p_LstCountSeq

// ---------------------------------------------------------------------------
// Sequential Counter
// ---------------------------------------------------------------------------
always @(DetCount or ExtBusReq or BusGntMode or ExtBusGnt)
begin : p_DetCountComb
  if (BusGntMode | ~(ExtBusReq ^ ExtBusGnt))
    NextDetCount = 5'b00000;
  else if (ExtBusReq && ~ExtBusGnt)
    NextDetCount = DetCount + 1'b1;
  else
    NextDetCount = DetCount;
end // p_DetCountComb

always @(posedge HCLK or negedge nReset)
begin : p_DetCountSeq
  if (~nReset)
    DetCount <= 5'h00;
  else
    DetCount <= NextDetCount;
end // p_DetCountSeq

// ---------------------------------------------------------------------------
// Random Counter
// ---------------------------------------------------------------------------
always @(RandCount)
begin : p_RandCountComb
  NextRandCount[4]   = RandCount[0] ^ RandCount[1];
  NextRandCount[3:0] = RandCount[4:1];
end // p_RandCountComb

always @(posedge HCLK or negedge nReset)
begin : p_RandCountSeq
  if (~nReset)
    RandCount <= 5'h01;
  else
    RandCount <= NextRandCount;
end // p_RandCountSeq

endmodule

// --================================== End =================================--
