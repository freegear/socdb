// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : ClcdSerialiser.v.rca
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//
// -----------------------------------------------------------------------------
//   Purpose               : Instantiates Unpack and Palette modules.
//     
// --=========================================================================--


`timescale 1ns/1ps
`include "ClcdConfig.v"
// -----------------------------------------------------------------------------

module ClcdSerialiser (
//Inputs
                       CLCDCLK, 
                       nCLCLKRESET, 
                       FrameRst, 
                       FifoRData, 
                       LcdBPP,
                       LcdDualLclk,
                       BGR,
                       BEBO,
                       BEPO,
                       PixelEn, 
                       Toggle, 
                       UnpackEn, 
                       PalLcdRData,
//Outputs
                       PalLcdAddr,
                       FRdPtr,
                       FRPInc,
                       PixelValid,
                       PixelRed,
                       PixelGreen,
                       PixelBlue,
                       Brightbit
                      );

//Inputs
input        CLCDCLK;          // LCD Controller Clock input
input        nCLCLKRESET;      // Reset signal - LCLK domain
input        FrameRst;         // End of frame (Reset DMA Fifo/Unpacker)
input [63:0] FifoRData;        // Read out data from upper/lower FifoREG/RAM
input [2:0]  LcdBPP;           // Number of bits per pixel
input        LcdDualLclk;      // enable dual panel mode
input        BGR;              // Enable Blue and Red pixel swapping
input        BEBO;             // Enable big-endian byte ordering
input        BEPO;             // Enable big-endian pixel ordering
                               // with in a byte
input        PixelEn;          // Take current pixel from palette
input        Toggle;           // Dual mode toggle signal
input        UnpackEn;         // Enable for unpacker state machine
input [31:0] PalLcdRData;      // Palette RAM read data from port2

//Outputs
output [6:0] PalLcdAddr;       // Palette Index - Port2(Lcd side)
output [`PTR_SIZE-1:0] FRdPtr; // Upper/Lower Fifo read addres
output       FRPInc;           // Upper-lower fifo read pointer increment
output       PixelValid;       // Out going pixel is valid
output [7:0] PixelRed;         // Red pixel data out
output [7:0] PixelGreen;       // Green pixel data out
output [7:0] PixelBlue;        // Blue pixel data out
output       Brightbit;        // Intensity bit

//Inputs
wire         CLCDCLK;          
// LCD Controller Clock input

wire         nCLCLKRESET;      
// Reset signal - LCLK domain

wire         FrameRst;         
// End of frame (Reset DMA Fifo/Unpacker)

wire  [63:0] FifoRData;        
// Read out data from upper/lower FifoREG/RAM

wire  [2:0]  LcdBPP;           
// Number of bits per pixel

wire         LcdDualLclk;      
// enable dual panel mode

wire         BGR;              
// Enable Blue and Red pixel swapping

wire         BEBO;             
// Enable big-endian byte ordering

wire         BEPO;             
// Enable big-endian pixel ordering with in a byte
wire         PixelEn;          
// Take current pixel from palette

wire         Toggle;           
// Dual mode toggle signal

wire         UnpackEn;         
// Enable for unpacker state machine

wire  [31:0] PalLcdRData;      
// Palette RAM read data from port2


// -----------------------------------------------------------------------------
//
//                            ClcdSerialiser
//                            =============
//
// -----------------------------------------------------------------------------
//
// Overview
// ====
// This module contains logic 
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Wire declarations
// ----------------------------------------------------------------------------

wire PixelEnOut;
// Data path enable for Unpacker

wire [23:0] PixelIndex;
// Pixel data from the unpacker

wire PixelValidIn;
// Incoming pixel is valid

// ----------------------------------------------------------------------------
// Main body of code
// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Palette RAM index. Bit zero is used to select between the upper and lower
// half word of the palette Data.
// -----------------------------------------------------------------------------

assign PalLcdAddr[6:0] = PixelIndex[7:1];

ClcdUnpack uClcdUnpack (
       .CLCDCLK       (CLCDCLK),  
       .nCLCLKRESET   (nCLCLKRESET),  
       .FrameRst      (FrameRst),  
       .FifoDataIn    (FifoRData),  
       .LcdBPP        (LcdBPP),   
       .LcdDual       (LcdDualLclk),  
       .BEBO          (BEBO),  
       .BEPO          (BEPO),  
       .Toggle        (Toggle),  
       .UnpackEn      (UnpackEn),  
       .PixelEn       (PixelEnOut),  

       .PixelIndex    (PixelIndex), 
       .PixelValid    (PixelValidIn), 
       .FRdPtrInc     (FRPInc),
       .FRdPtr        (FRdPtr)
       );

ClcdPalette uClcdPalette (
       .CLCDCLK        (CLCDCLK), 
       .nCLCLKRESET    (nCLCLKRESET), 
       .FrameRst       (FrameRst), 
       .PixelIndex     (PixelIndex), 
       .PaletteData    (PalLcdRData), 
       .PixelValidIn   (PixelValidIn), 
       .PixelEnIn      (PixelEn), 
       .BGR            (BGR), 
       .BEBO           (BEBO), 
       .LcdBPP         (LcdBPP),

       .PixelRed       (PixelRed), 
       .PixelGreen     (PixelGreen), 
       .PixelBlue      (PixelBlue), 
       .Brightbit      (Brightbit), 
       .PixelEnOut     (PixelEnOut), 
       .PixelValid     (PixelValid)
       );
  
endmodule
// --================================== End ==================================--
