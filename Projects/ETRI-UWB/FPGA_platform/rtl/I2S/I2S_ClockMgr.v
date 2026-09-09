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

		LRCLK_I,		// LRCLK Input : connect to tristate port(LRCLK)
		BCLK_I,			// BCLK Input : connect to tristate port(BCLK)
		SDIN,			// SD Input : connect to SDIN input port

		LeftStart,		// LeftStart   : Connect to other part of I2S Contrroler.
		RightStart,		// RightStart  : Connect to other part of I2S Contrroler.
		BCLKRise,		// BCLKRise  : Connect to other part of I2S Controller.
		BCLKFall,		// BCLKFall : Connect to other part of I2S Controller.
		SDInput,		// SDInput     : Connect to I2S Deserializer
		LRCLK,			// LRCLK Internal use

		// Control
		Master,			// 1 when Master mode, 0 when slave mode
		LRCLKInvert		// 1 when Left(0), Right(1), 0 when Left(1), Right(0)
);

//
// input/output port
//
input  CLK;
input  RESETn;

input  LRCLK_I;
input  BCLK_I;
input  SDIN;

output LeftStart;
output RightStart;
output BCLKRise;
output BCLKFall;
output SDInput;
output LRCLK;

input  Master;
input  LRCLKInvert;

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

assign LRCLK      = (LRCLKInvert) ? ~LRCLKIn2d : LRCLKIn2d;

assign BCLKRise   = (BCLKIn3d == 0 && BCLKIn2d == 1);
assign BCLKFall   = (BCLKIn3d == 1 && BCLKIn2d == 0);

assign SDInput = SDIN3d;	// You Can latch SDInput when BCLKRise == 1

endmodule
