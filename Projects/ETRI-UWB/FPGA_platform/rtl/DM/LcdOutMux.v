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
			nRST,
			LcdBPP,
			LcdBGR,
			CLPOWERint,
			PixelRed,
			PixelGreen,
			PixelBlue,
// Outputs
			LCDLDint
);

// Inputs
input         LCDCLK;     // Lcd controller clock. 
input		  nRST;
input [2:0]   LcdBPP;      // number of bits per pixel
input		  LcdBGR;
input         CLPOWERint;  // Lcd panel power enable.
input [7:0]   PixelRed;    // Red pixel data from Palette.
input [7:0]   PixelGreen;  // Green pixel data from Palette.
input [7:0]   PixelBlue;   // Blue pixel data from Palette.

// Outputs
output [23:0] LCDLDint;      // LCD panel data - MUX output.

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire  [2:0]  LcdBPP;      
wire         CLPOWERint;

wire  [7:0]  PixelRed;  
wire  [7:0]  PixelGreen;  
wire  [7:0]  PixelBlue;  

wire [7:0]   PixelRedSw;
wire [7:0]   PixelBlueSw;

wire [7:0]   TFTRed;
wire [7:0]   TFTGrn;
wire [7:0]   TFTBlu;

reg  [23:0]  LCDLDint;
wire [23:0]  iLCDLDint;
wire [23:0]  TFTData;

wire [23:0] CLPOWERVect;

// -----------------------------------------------------------------------------
// Gating of TFT panel data with PDEn
// -----------------------------------------------------------------------------
assign PixelRedSw  = ~LcdBGR ? PixelRed  : PixelBlue;
assign PixelBlueSw = ~LcdBGR ? PixelBlue : PixelRed;

assign TFTRed  = PixelRedSw[7:0];
assign TFTGrn  = PixelGreen[7:0];
assign TFTBlu  = PixelBlueSw[7:0];

// -----------------------------------------------------------------------------
// select between TFT and STN data depending on the setting of TFT bit.
// drive zero on the unused data lines.
// -----------------------------------------------------------------------------
assign TFTData[23:0] = (LcdBPP[2] == 1'b0) ?
					   (LcdBPP[1:0] == 2'b10) ? {TFTRed[7:0]      , TFTGrn[7:0],       TFTBlu[7:0]      } : 
					   (LcdBPP[1:0] == 2'b01) ? {TFTRed[7:2], 2'b0, TFTGrn[7:2], 2'b0, TFTBlu[7:2], 2'b0} : 
					  				   		    {TFTRed[7:3], 3'b0, TFTGrn[7:2], 2'b0, TFTBlu[7:3], 3'b0} : 
					  				   		    {TFTRed[7:0]      , TFTGrn[7:0],       TFTBlu[7:0]      } ;

assign CLPOWERVect   = {24{CLPOWERint}};

assign iLCDLDint     = (TFTData & CLPOWERVect);

always @(negedge nRST or posedge LCDCLK)
	if (!nRST)  LCDLDint <= 0;
	else		LCDLDint <= iLCDLDint;

endmodule

// --=========================================================================--
