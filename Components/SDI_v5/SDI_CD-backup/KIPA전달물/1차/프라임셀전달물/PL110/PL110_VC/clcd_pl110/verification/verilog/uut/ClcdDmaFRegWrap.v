// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdDmaFRegWrap.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
// ----------------------------------------------------------------------------
//  Purpose                : Wrapper for the DMA Fifo REG
// --=========================================================================--

`timescale 1ns/1ps
`include "ClcdConfig.v"
// ----------------------------------------------------------------------------

module ClcdDmaFRegWrap (
// inputs
                        HCLK,
                        UFifoWrEn,
                        LFifoWrEn,
                        UFWrPtr,
                        LFWrPtr,
                        FRdPtr,
                        FifoWData,
 
// Outputs
                        FifoRData
                       );
 
// inputs
input  HCLK;                           // Clock input
input  UFifoWrEn;                      // Upper Fifo Write request
input  LFifoWrEn;                      // Lower Fifo Write request
input  [`PTR_SIZE-1:0]UFWrPtr;         // Upper Fifo Write address
input  [`PTR_SIZE-1:0]LFWrPtr;         // Lower Fifo Write address
input  [`PTR_SIZE-1:0] FRdPtr;         // DMA Fifo Read address
input  [31:0]     FifoWData;           // Data to be written into the REG/TPRAM
 
// Outputs
output [63:0]         FifoRData;       // DMA Fifo Read data out

// ----------------------------------------------------------------------------
// Overview
// ========
// this module instantiates the REG for the DMA FIFO.
// Note : some signals which are needed for the TPRAM are not used in this 
//        module.
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// Wire declarations
// ----------------------------------------------------------------------------
wire                   HCLK;
// Clock input                                          (Module input)

wire                   UFifoWrEn;
// Data is written into the selected register element on the rising edge of 
// HCLK when this signal is high                        (Module input)

wire                   LFifoWrEn;
// Data is written into the selected register element on the rising edge of 
// HCLK when this signal is high                        (Module input)

wire  [`PTR_SIZE-1:0]   UFWrPtr;
// Address to which WrData is to be written when
// UFifoWrEn is asserted.                               (Module input)

wire  [`PTR_SIZE-1:0]   LFWrPtr;
// Address to which WrData is to be written when
// LFifoWrEn is asserted.                               (Module input)

wire  [31:0]           FifoWData;
// Data to be written into the register elements        (Module input)

wire  [`PTR_SIZE-1:0]   FRdPtr;
// Address from which data is driven out to UFRdData.   (Module input)

wire [63:0]             FifoRData;
// DMA Fifo Read data out                               (Module output)

wire [31:0]             UFRData;
// output data from upper fifo REG

wire [31:0]             LFRData;
// output data from Lower fifo REG

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Instanciation of Fifo REG for upper panel fifo 
// -----------------------------------------------------------------------------
ClcdFifoReg uClcdFifoReg1 (
                           .HCLK     (HCLK),
                           .WrAddr   (UFWrPtr),
                           .WrEnable (UFifoWrEn),
                           .WrData   (FifoWData),
                           .RdAddr   (FRdPtr),
                           
                           .RdData   (UFRData)
                          );

// -----------------------------------------------------------------------------
// Instanciation of Fifo REG for lower panel fifo
// -----------------------------------------------------------------------------
ClcdFifoReg uClcdFifoReg2 (
                           .HCLK     (HCLK),
                           .WrAddr   (LFWrPtr),
                           .WrEnable (LFifoWrEn),
                           .WrData   (FifoWData),
                           .RdAddr   (FRdPtr),
                           
                           .RdData   (LFRData)
                          );

assign FifoRData[63:0] = {LFRData[31:0],UFRData[31:0]};

endmodule
// --================================== End ==================================--
