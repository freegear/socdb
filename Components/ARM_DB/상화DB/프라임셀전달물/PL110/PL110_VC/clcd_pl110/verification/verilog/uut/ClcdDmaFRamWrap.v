//--=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//-----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdDmaFRamWrap.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
// ----------------------------------------------------------------------------
//  Purpose                : Wrapper for the DMA Fifo RAM
// --=========================================================================--

`timescale 1ns/1ps
`include "ClcdConfig.v"
// ----------------------------------------------------------------------------

module ClcdDmaFRamWrap (
                       // inputs
                       HCLK,
                       UFifoWrEn,
                       LFifoWrEn,
                       UFWrPtr,
                       LFWrPtr,
                       LcdFifoRamREB,
                       FRdPtr,
                       FifoWData,
 
                      // Outputs
                       FifoRData
                      );
 
input  HCLK;                           // Clock input
input  UFifoWrEn;                      // Upper Fifo Write request
input  LFifoWrEn;                      // Lower Fifo Write request
input  LcdFifoRamREB;                  // TPRAM read port enable
input  [`PTR_SIZE-1:0] UFWrPtr;        // Upper Fifo Write address
input  [`PTR_SIZE-1:0] LFWrPtr;        // Lower Fifo Write address
input  [`PTR_SIZE-1:0] FRdPtr;         // DMA Fifo Read address 
input  [31:0]          FifoWData;      // Data to be written into the REG/TPRAM

output [63:0]          FifoRData;      // DMA Fifo Read data out

// ----------------------------------------------------------------------------
// Overview
// ========
// This module instantiates the TPRAM for the upper and lower fifo.
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire declarations
// ----------------------------------------------------------------------------
wire                   UFifoWrEn;
// Data is written into the selected memory element on the rising edge of 
// UFifoWrEn                                           (Module input)

wire                   LFifoWrEn;
// Data is written into the selected memory element on the rising edge of 
// LFifoWrEn                                            (Module input)

wire  [`PTR_SIZE-1:0]   UFWrPtr;
// Address to which WrData is to be written when
// UFifoWrEn is asserted.                               (Module input)

wire  [`PTR_SIZE-1:0]   LFWrPtr;
// Address to which WrData is to be written when
// LFifoWrEn is asserted.                               (Module input)

wire                   LcdFifoRamREB;
// TPRAM read enable. read port is enabled only when the timing generator
// goes out of SYNC state. This is necessary to prevent address contention
// of TPRAM when ReadAddr = WriteAddr = 00.             (Module input)

wire  [31:0]           FifoWData;
// Data to be written into the register elements        (Module input)

wire  [`PTR_SIZE-1:0]   FRdPtr;
// Address from which data is driven out to UFRdData.   (Module input)

wire [31:0]        TpramUFRdata;
// TPRAM output data corresponding to the UFRdPtr

wire [31:0]        TpramLFRdata;
// TPRAM output data corresponding to the LFRdPtr

wire [`PTR_SIZE+1:0] TPRamRdAddr;
// Two port ram final Read Address width (depth of 64)

wire [`PTR_SIZE+1:0] TPRamLFAddr;
// Two port ram final lower fifo address width (depth of 64)

wire [`PTR_SIZE+1:0] TPRamUFAddr;
// Two port ram final upper fifo address width (depth of 64)

wire   TpramOEn;
// TPRAM read port output enable

wire   TpramRCSB;
// TPRAM read chip select (active low) 

wire   TpramWCSB;
// TPRAM write chip select (active low)

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// TPRAM read and write port enabled
//------------------------------------------------------------------------------
assign TpramOEn  = 1'b0;
assign TpramRCSB = 1'b0;
assign TpramWCSB = 1'b0;

// -----------------------------------------------------------------------------
// TPRAM Address extension
// -----------------------------------------------------------------------------

assign TPRamRdAddr = {2'b00, FRdPtr};
assign TPRamLFAddr = {2'b00, LFWrPtr};
assign TPRamUFAddr = {2'b00, UFWrPtr};

// -----------------------------------------------------------------------------
// Instantiation of TPRAM for upper panel fifo
// -----------------------------------------------------------------------------
tpram64x32 uTPRAM1(
                   .RCSB  (TpramRCSB),
                   .WCSB  (TpramWCSB),
                   .WA    (TPRamUFAddr),
                   .RA    (TPRamRdAddr),
                   .WEB   (UFifoWrEn),
                   .REB   (LcdFifoRamREB),
                   .OEB   (TpramOEn),
                   .DO    (TpramUFRdata),
                   .DI    (FifoWData)
                   );

// -----------------------------------------------------------------------------
// Instantiation of TPRAM for lower panel fifo
// -----------------------------------------------------------------------------

tpram64x32 uTPRAM2(
                   .RCSB  (TpramRCSB),
                   .WCSB  (TpramWCSB),
                   .WA    (TPRamLFAddr),
                   .RA    (TPRamRdAddr),
                   .WEB   (LFifoWrEn),
                   .REB   (LcdFifoRamREB),
                   .OEB   (TpramOEn),
                   .DO    (TpramLFRdata),
                   .DI    (FifoWData)
                   );

//------------------------------------------------------------------------------
// Combine Lower and Upper Fifo Read data
//------------------------------------------------------------------------------
assign FifoRData[63:0] = {TpramLFRdata,TpramUFRdata};


endmodule
// --================================== End ==================================--
