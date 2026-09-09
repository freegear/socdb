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
//  File Name              : ClcdOutMux.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : MUX logic for LCD panel data and Panel clock.
//
// --=========================================================================--

`timescale 1ns/1ps
// ----------------------------------------------------------------------------

module ClcdOutMux (
// Inputs
                   CLCDCLK,
                   IPC,
                   BCD,
                   LcdTFT,
                   LcdDual,
                   LcdBPP,
                   TFTPDEn,
                   CLPOWERint,
                   LcdEn,
                   LcdCP,
                   PixelRed,
                   PixelGreen,
                   PixelBlue,
                   Brightbit,
                   UpSTNData,
                   LpSTNData,
                   
// Outputs
                   CLCPint,
                   CLDint
                  );

// Inputs
input         CLCDCLK;     // Lcd controller clock. 
input         IPC;         // Invert panel clock.
input         BCD;         // bypass panel clock divider - use CLCDCLK as CLCP.
input         LcdTFT;      // TFT enable.
input         LcdDual;     // dual mode enable
input [2:0]   LcdBPP;      // number of bits per pixel
input         TFTPDEn;     // Enable for TFT panel data. 
input         CLPOWERint;  // Lcd panel power enable.
input         LcdEn;       // Lcd Controller enable bit
input         LcdCP;       // Lcd panel clock from clock divider. 
input [7:0]   PixelRed;    // Red pixel data from Palette.
input [7:0]   PixelGreen;  // Green pixel data from Palette.
input [7:0]   PixelBlue;   // Blue pixel data from Palette.
input         Brightbit;   // TFT bright/intensity bit.
input [7:0]   UpSTNData;   // STN upper panel data.
input [7:0]   LpSTNData;   // STN lower panel data.

// Outputs
output        CLCPint;     // LCD panel clock - MUX output.
output [23:0] CLDint;      // LCD panel data - MUX output.

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire         CLCDCLK;   
// Lcd controller clock.                              (Module input)

wire         IPC;       
// Invert panel clock.                                (Module input)

wire         BCD;       
// bypass panel clock divider - use CLCDCLK as CLCP.  (Module input)

wire         LcdTFT;       
// TFT enable.                                        (Module input)

wire         LcdDual;      
// Dual mode enable.                                  (Module input)

wire  [2:0]  LcdBPP;      
// number of bits per pixel                           (Module input)

wire         TFTPDEn;   
// Enable for TFT panel data.                         (Module input)

wire         CLPOWERint;
// Lcd Panel power enable                             (Module input)

wire         LcdEn;
// Lcd Controller enable bit                          (Module input)

wire         LcdCP;     
// Lcd panel clock from clock divider.                (Module input)

wire  [7:0]  PixelRed;  
// Red pixel data from Palette.                       (Module input)

wire  [7:0]  PixelGreen;  
// Green pixel data from Palette.                     (Module input)

wire  [7:0]  PixelBlue;  
// Blue pixel data from Palette.                      (Module input)

wire         Brightbit; 
// TFT bright/intensity bit.                          (Module input)

wire  [7:0]  UpSTNData; 
// STN upper panel data.                              (Module input)

wire  [7:0]  LpSTNData;           
// STN lower panel data.                              (Module input)

wire [7:0]   TFTRed;
// Internal version of TFT data.

wire [7:0]   TFTGrn;
// Internal version of TFT data.

wire [7:0]   TFTBlu;
// Internal version of TFT data.

wire         TFTBrightBit;
// Internal version of Bright bit.

wire         iCLCPInt;
// Internal version of CLCP.

wire         CLCPint;
// Lcd panel clock output.                            (Module output)

wire [23:0] CLDint;
// Lcd panel data out                                 (Module output)

wire [23:0] TFTData;
// TFT Panel data

wire [23:0] STNData;
// STN Panel data

wire [23:0] CLPOWERVect;
// Internal signal

// -----------------------------------------------------------------------------
// Gating of TFT panel data with PDEn
// this will drive "0" on the Panel data bus during the inactive period
// of display in TFT mode
// -----------------------------------------------------------------------------
assign TFTRed[7:0]  = PixelRed[7:0] & {8{TFTPDEn}};
assign TFTGrn[7:0]  = PixelGreen[7:0] & {8{TFTPDEn}};
assign TFTBlu[7:0]  = PixelBlue[7:0] & {8{TFTPDEn}};
assign TFTBrightBit = Brightbit & TFTPDEn;

// -----------------------------------------------------------------------------
// select between TFT and STN data depending on the setting of TFT bit.
// drive zero on the unused data lines.
// -----------------------------------------------------------------------------
assign STNData[23:0] = (LcdDual == 1'b0) ? {16'b0,UpSTNData[7:0]}
                       : {8'b0, LpSTNData[7:0], UpSTNData[7:0]};

assign TFTData[23:0] = (LcdBPP == 3'b101) ? {TFTBlu[7:0], TFTGrn[7:0],
                        TFTRed[7:0]} 
                       : {TFTBlu[4:0], TFTBrightBit, TFTGrn[4:0],
                          TFTBrightBit, TFTRed[4:0], TFTBrightBit};

assign CLDint        = (LcdTFT == 1'b1) ? (TFTData & CLPOWERVect)
                       : (STNData & CLPOWERVect);

// -----------------------------------------------------------------------------
// Bypass panel clock from the clock divider if BCD bit is set.
// -----------------------------------------------------------------------------
assign iCLCPInt = (BCD == 1'b1) ? CLCDCLK : LcdCP;
 
// -----------------------------------------------------------------------------
// Invert Panel Clock if IPC bit is set and disable panel clock if Lcd 
// enable signal is LOW.
// -----------------------------------------------------------------------------
assign CLCPint = (IPC == 1'b1) ? (~iCLCPInt & LcdEn) : (iCLCPInt & LcdEn);

assign CLPOWERVect = {24{CLPOWERint}};

endmodule

// --=========================================================================--
