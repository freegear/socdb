// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_ClockMgr.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module Clock Manager in I2S Controller.
//  =============================================================================

`timescale 1ns/1ps

module I2S_ClockMgr 
(
		CLK,			// CLK : Connect to PCLK
		RESETn, 		// active low asynchornous reset

		BCLKInt,		// BCLK : Connect to DTO/Audio PLL Clock divider

		LRCLK_O,		// LRCLK Output : connect to tristate buffer port(LRCLK)
		BCLK_O,			// BCLK Output : connect to tristate buffer port(BCLK)

		LRCLK_I,		// LRCLK Input : connect to tristate port(LRCLK)
		BCLK_I,			// BCLK Input : connect to tristate port(BCLK)
		SDIN,			// SD Input : connect to SDIN input port

		LeftStart,		// LeftStart   : Connect to other part of I2S Contrroler.
		RightStart,		// RightStart  : Connect to other part of I2S Contrroler.
		BCLKRise,		// BCLKRise  : Connect to other part of I2S Controller.
		BCLKFall,		// BCLKFall : Connect to other part of I2S Controller.
		SDInput,		// SDInput     : Connect to I2S Deserializer

		// Control
		Master,			// 1 when Master mode, 0 when slave mode
		LRCLKInvert		// 1 when Left(0), Right(1), 0 when Left(1), Right(0)
);

//
// input/output port
//
input  CLK;
input  RESETn;

input  BCLKInt;

output LRCLK_O;

output BCLK_O;

input  LRCLK_I;
input  BCLK_I;
input  SDIN;

output LeftStart;
output RightStart;
output BCLKRise;
output BCLKFall;
output SDInput;

input  Master;
input  LRCLKInvert;

//
// LRCLK generation from BCLKInt
//
reg BCLK1d;
reg BCLK2d;
reg BCLK3d;

reg [5:0] BCLKCounter;
reg       LRCLKTemp;
reg       BCLK_O;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		BCLK1d <= 0;
		BCLK2d <= 0;
		BCLK3d <= 0;
		BCLKCounter <= 0;
		LRCLKTemp  <= 1;
		BCLK_O <= 0;
	end
	else
	begin
		// Flip-flop for avoding metastability
		BCLK1d <= BCLKInt;
		BCLK2d <= BCLK1d;
		BCLK3d <= BCLK2d;

		if(BCLK3d == 1'b1 && BCLK2d == 1'b0 && Master == 1)	// falling edge
			BCLKCounter <= BCLKCounter + 1'b1;

		LRCLKTemp <= BCLKCounter[5];
		BCLK_O    <= BCLK3d;
	end
end

assign LRCLK_O   = LRCLKInvert ? ~LRCLKTemp : LRCLKTemp;


//
// Generate LRCLKRising/BCLKRise form LRCLK/BCLK port input
//
reg BCLKIn1d;
reg BCLKIn2d;
reg BCLKIn3d;
reg LRCLKIn1d;
reg LRCLKIn2d;
reg LRCLKIn3d;
reg SDIN1d;
reg SDIN2d;
reg SDIN3d;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		BCLKIn1d <= 1'b1;
		BCLKIn2d <= 1'b1;
		BCLKIn3d <= 1'b1;
		LRCLKIn1d <= 1'b1;
		LRCLKIn2d <= 1'b1;
		LRCLKIn3d <= 1'b1;
		SDIN1d <= 1'b1;
		SDIN2d <= 1'b1;
		SDIN3d <= 1'b1;
	end
	else
	begin
		BCLKIn1d <= BCLK_I;
		BCLKIn2d <= BCLKIn1d;
		BCLKIn3d <= BCLKIn2d;
		LRCLKIn1d <= LRCLK_I;
		LRCLKIn2d <= LRCLKIn1d;
		LRCLKIn3d <= LRCLKIn2d;
		SDIN1d <= SDIN;
		SDIN2d <= SDIN1d;
		SDIN3d <= SDIN2d;
	end
end
wire LRCLKRise    = (LRCLKIn3d == 0 && LRCLKIn2d == 1);
wire LRCLKFall    = (LRCLKIn3d == 1 && LRCLKIn2d == 0);

assign LeftStart  = (LRCLKInvert) ? LRCLKRise : LRCLKFall;
assign RightStart = (LRCLKInvert) ? LRCLKFall : LRCLKRise;

assign BCLKRise   = (BCLK3d == 0 && BCLK2d == 1);
assign BCLKFall   = (BCLK3d == 1 && BCLK2d == 0);

assign SDInput = SDIN3d;	// You Can latch SDInput when BCLKRise == 1

endmodule
