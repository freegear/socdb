//  ----------------------------------------------------------------------------
//
//  Purpose                : MUX logic for LCD panel data and Panel clock.
//
// --=========================================================================--

`timescale 1ns/1ps
// ----------------------------------------------------------------------------

module LcdOutMux (
// Inputs
			LCDCLK,
			LcdBPP,
			LcdBGR,
			TFTPDEn,
			CLPOWERint,
			LcdEn,
			PixelRed,
			PixelGreen,
			PixelBlue,
// Outputs
			LCDLDint
);

// Inputs
input         LCDCLK;     // Lcd controller clock. 
input [1:0]   LcdBPP;      // number of bits per pixel
input		  LcdBGR;
input         TFTPDEn;     // Enable for TFT panel data. 
input         CLPOWERint;  // Lcd panel power enable.
input         LcdEn;       // Lcd Controller enable bit
input [7:0]   PixelRed;    // Red pixel data from Palette.
input [7:0]   PixelGreen;  // Green pixel data from Palette.
input [7:0]   PixelBlue;   // Blue pixel data from Palette.

// Outputs
output [23:0] LCDLDint;      // LCD panel data - MUX output.

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire         LCDCLK;   
wire  [1:0]  LcdBPP;      
wire         TFTPDEn;   
wire         CLPOWERint;
wire         LcdEn;

wire  [7:0]  PixelRed;  
wire  [7:0]  PixelGreen;  
wire  [7:0]  PixelBlue;  

wire [7:0]   PixelRedSw;
wire [7:0]   PixelBlueSw;

wire [7:0]   TFTRed;
wire [7:0]   TFTGrn;
wire [7:0]   TFTBlu;

wire [23:0] LCDLDint;
wire [23:0] TFTData;

wire [23:0] CLPOWERVect;

// -----------------------------------------------------------------------------
// Gating of TFT panel data with PDEn
// -----------------------------------------------------------------------------
assign PixelRedSw  = ~LcdBGR ? PixelRed  : PixelBlue;
assign PixelBlueSw = ~LcdBGR ? PixelBlue : PixelRed;

assign TFTRed  = PixelRedSw[7:0]  & {8{TFTPDEn}};
assign TFTGrn  = PixelGreen[7:0]  & {8{TFTPDEn}};
assign TFTBlu  = PixelBlueSw[7:0] & {8{TFTPDEn}};

// -----------------------------------------------------------------------------
// select between TFT and STN data depending on the setting of TFT bit.
// drive zero on the unused data lines.
// -----------------------------------------------------------------------------
assign TFTData[23:0] = (LcdBPP == 2'b10) ? {TFTRed[7:0]      , TFTGrn[7:0],       TFTBlu[7:0]      } : 
					   (LcdBPP == 2'b01) ? {TFTRed[7:2], 2'b0, TFTGrn[7:2], 2'b0, TFTBlu[7:2], 2'b0} : 
					  					   {TFTRed[7:3], 3'b0, TFTGrn[7:2], 2'b0, TFTBlu[7:3], 3'b0};

assign LCDLDint        = (TFTData & CLPOWERVect);

assign CLPOWERVect = {24{CLPOWERint}};

endmodule

// --=========================================================================--
