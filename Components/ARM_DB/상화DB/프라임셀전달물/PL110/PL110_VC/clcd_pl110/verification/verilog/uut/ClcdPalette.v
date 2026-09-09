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
//  File Name              : ClcdPalette.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//   Purpose               : This module takes Palette data from Palette RAM and
//                           Pixel index from the Unpacker; extracts R,G,B, 
//                           Brightbit data from them.  RED and BLUE pixel data
//                           is swapped if BGR is "1".
//
// *****************************************************************************
//  PixelRed/Blue/Green output register moved to PixelIndex, to accomodate 
//  Synchronous Palette RAM 
// *****************************************************************************
// --=========================================================================--

`timescale 1ns/1ps
// -----------------------------------------------------------------------------

module ClcdPalette (
// inputs
                    CLCDCLK, 
                    nCLCLKRESET,
                    FrameRst,
                    PixelIndex,
                    PaletteData,
                    PixelValidIn,
                    PixelEnIn,
                    BGR, 
                    BEBO,
                    LcdBPP,
    
// Outputs
                    PixelRed,
                    PixelGreen,
                    PixelBlue,
                    Brightbit,
                    PixelEnOut,
                    PixelValid
                   );

// inputs
input          CLCDCLK;      // Clock input
input          nCLCLKRESET;  // System reset input
input          FrameRst;     // flush pipeline at end of frame
input [23:0]   PixelIndex;   // Pixel index: unpacker output
input [31:0]   PaletteData;  // Looked up pixel data from the palette RAM
input          PixelValidIn; // Pixel data coming in is valid
input          PixelEnIn;    // enable (take) pixel going out: 
                             // output of greyscaler
input          BGR;          // swap red & blue
input          BEBO;         // Big-Endian byte ordering
input [2:0]    LcdBPP;       // bits per pixel 

// Outputs
output [7:0]   PixelRed;     // Red pixel data going out
output [7:0]   PixelGreen;   // Green pixel data going out
output [7:0]   PixelBlue;    // Blue pixel data going out
output         Brightbit;    // Brightness control bit
output         PixelValid;   // indicates pixel going out is valid
output         PixelEnOut;   // enable to back end of video pipeline

// -----------------------------------------------------------------------------
//
// Overview
// ========
// This module contains logic to generate enable for the unpacker, Pixel valid 
// signal for the Greyscaler and to extract R,G,B,Brightbit from the looked up
// palette data/Palette index.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire           CLCDCLK;         
// Clock input                                          (Module input) 

wire           nCLCLKRESET;  
// System reset input                                   (Module input)

wire           FrameRst;     
// flush pipeline at end of frame                       (Module input)

wire  [23:0]   PixelIndex;   
// Pixel index: unpacker output                         (Module input)

wire  [31:0]   PaletteData;  
// Looked up pixel data from the palette RAM            (Module input)

wire           PixelValidIn; 
// Pixel data coming in is valid                        (Module input)

wire           PixelEnIn; 
// enable (take) pixel going out: output of greyscaler  (Module input)

wire           BGR;      
// swap red & blue                                      (Module input)

wire           BEBO;     
// Big-Endian byte ordering                             (Module input)

wire [2:0]     LcdBPP;      
// bits per pixel                                       (Module input)

wire           PixelEnOut;                              
// Pixel Enable for Unpacker/DMA Fifo                   (Module output)

wire [15:0]    PixelDataInt;
// Internal version of Pixel data

wire [7:0]     PixelRedInt;
// Internal version of Pixel data(Red)

wire [7:0]     PixelGreen;
// Pixel Green output

wire [7:0]     PixelBlueInt;
// Internal version of Pixel data(Blue)

wire           Brightbit;
// Brightbit output                                     (Module output)

wire [7:0]     PixelRed;
// Pixel Red output                                     (Module output)

wire [7:0]     PixelBlue;
// Pixel Blue output                                    (Module output)


// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg            PixelValid;
// Outgoing pixel is valid : input to greyscaler        (Module output)

reg            NextPixelValid;
// D-input of PixelValid

reg [23:0]     DelPixelIndex;
// Delayed Pixel Index to match delayed Palette Data from synchronous RAM

//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Enable back when no valid pixels, to prime pipeline(Unpacker)
// -----------------------------------------------------------------------------
assign PixelEnOut = PixelEnIn | ~PixelValidIn;

// -----------------------------------------------------------------------------
// Combinational process for PixelValid signal
// -----------------------------------------------------------------------------
always @(FrameRst or PixelValidIn)
begin : p_PixValComb
  if (FrameRst == 1'b1)
    NextPixelValid =  1'b0;
  else
    NextPixelValid   =  PixelValidIn;
end // p_PixValComb

// -----------------------------------------------------------------------------
// Pixel Valid out register output
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_PixValSeq
  if (nCLCLKRESET == 1'b0)
    PixelValid <=  1'b0;
  else
    PixelValid <=  NextPixelValid;
end // p_PixValSeq

// -----------------------------------------------------------------------------
// Select Lower half word or upper half word as pixel data depending on the
// Byte ordering mode(BEBO) and the LSB of PixelIndex
// -----------------------------------------------------------------------------
assign PixelDataInt[15:0] = ((BEBO ^ DelPixelIndex[0]) == 1'b1) ? 
                            PaletteData[31:16] : PaletteData[15:0] ; 

// -----------------------------------------------------------------------------
// Select between Palettised pixel data and non-palettised pixel data. In 16 bpp
// and 24bpp mode pass non palettised data
// -----------------------------------------------------------------------------
assign PixelRedInt[7:0]   = (LcdBPP == 3'b101) ? DelPixelIndex[7:0]
                          : (LcdBPP == 3'b100) ? {3'b0,DelPixelIndex[4:0]}
                          : {3'b0,PixelDataInt[4:0]};

assign PixelGreen[7:0]    = (LcdBPP == 3'b101) ? DelPixelIndex[15:8] 
                          : (LcdBPP == 3'b100) ? {3'b0,DelPixelIndex[9:5]}
                          : {3'b0,PixelDataInt[9:5]};

assign PixelBlueInt[7:0]  = (LcdBPP == 3'b101) ? DelPixelIndex[23:16] 
                          : (LcdBPP == 3'b100) ? {3'b0,DelPixelIndex[14:10]}
                          : {3'b0,PixelDataInt[14:10]};

assign Brightbit          = (LcdBPP == 3'b100) ? DelPixelIndex[15] 
                                                : PixelDataInt[15];

// -----------------------------------------------------------------------------
// swap red & blue pixel if BGR is "1"
// -----------------------------------------------------------------------------

assign PixelRed   = (BGR == 1'b1) ? PixelBlueInt : PixelRedInt;
assign PixelBlue  = (BGR == 1'b1) ? PixelRedInt  : PixelBlueInt;

// -----------------------------------------------------------------------------
// synchronise the out going pixels to CLCDCLK
// -----------------------------------------------------------------------------
always @(posedge CLCDCLK or negedge nCLCLKRESET)
begin : p_PixDataSeq
  if (nCLCLKRESET == 1'b0)
    DelPixelIndex   <= 24'h000000;
  else
    DelPixelIndex   <= PixelIndex;
end // p_PixDataSeq

endmodule

// --================================== End ==================================--

