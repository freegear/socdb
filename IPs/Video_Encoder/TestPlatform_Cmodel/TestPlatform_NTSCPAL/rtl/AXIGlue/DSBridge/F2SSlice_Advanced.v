// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : F2SSlice_Advanced.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is a part of AXI Downward Synch. Bridge
//                     : You can use this module
//                     : with apropriate parameter(WIDTH).
//  =============================================================================

`timescale 1ns/1ps

module F2SSlice_Advanced 
(
		ACLK_Fast    , // Fast Side Clock
		ARESETn      , // Reset
		SlowClockEn  , // Signal to indicate Slow Clock rising edge
		INFORMATION_F, // Fast Side Information(input)
		VALID_F      , // Fast Side VALID(input)
		READY_F      , // Fast Side READY(output)
		INFORMATION_S, // Slow Side Information(output)
		VALID_S      , // Slow Side VALID(output)
		READY_S        // Slow Side READY(input)
);

//
// NOTE : Fast-to-Slow Slice Module(Advanced Mode)
//                  +--------+
// INFORMATION_F => |        | => INFORMATION_S
// VALID_F       => |  this  | => VALID_S
//                  | module |
// READY_F       <= |        | <= READY_S
//                  +--------+
// suffix _F denotes "Fast Side"
// suffix _S denotes "Slow Side"
//
// INFORMATION_F & VALID_F & READY_S are registered.
//
//

parameter WIDTH  = 15;

input  ACLK_Fast;
input  ARESETn;
input  SlowClockEn;
input  [WIDTH-1:0] INFORMATION_F;
input  VALID_F;
output READY_F;
output [WIDTH-1:0] INFORMATION_S;
output VALID_S;
input  READY_S;

wire ACLK_Fast;
wire ARESETn;
wire SlowClockEn;
wire VALID_F;
reg  READY_F;
reg  VALID_S;
wire READY_S;

wire [WIDTH-1:0] INFORMATION_F;
wire [WIDTH-1:0] INFORMATION_S;

reg  [WIDTH-1:0] INFORMATION_0;
reg  [WIDTH-1:0] INFORMATION_1;
reg  [1:0] que_len;
reg  [1:0] next_que_len;

assign INFORMATION_S = INFORMATION_0;

always @(negedge ARESETn or posedge ACLK_Fast)
	if(!ARESETn)
	begin
		VALID_S <= 1'b0;	// VALID LOW when reset : one of AXI requirements.
		INFORMATION_0 <= {WIDTH{1'b0}};	// don't care when VALID is LOW.
		INFORMATION_1 <= {WIDTH{1'b0}};	// don't care when VALID is LOW.
		que_len <= 2'b00;
	end
	else
	begin
		que_len <= next_que_len;

		if((que_len[0] == 1'b0 || (que_len == 2'b01 && VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1)) && VALID_F == 1'b1 && READY_F == 1'b1)
			INFORMATION_0 <= INFORMATION_F;		// latch INFORMATION_F @ INFORMATION_0 when que is empty
		else if(VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1)
			INFORMATION_0 <= INFORMATION_1;		// Shift previous received information

		if(VALID_F == 1'b1 && READY_F == 1'b1)
			INFORMATION_1 <= INFORMATION_F;		// latch INFORMATION_F @ INFORMATION_1 for later use

		if(next_que_len[1] == 1'b1)
			READY_F <= 1'b0;
		else
			READY_F <= 1'b1;

		if (next_que_len != 0 && SlowClockEn == 1'b1)
			VALID_S <= 1'b1;
		else if(SlowClockEn == 1'b1)
			VALID_S <= 1'b0;
	end

always @(que_len, SlowClockEn, READY_S, VALID_F, READY_F)
begin
	next_que_len = que_len;
	case(que_len)
	2'b00:
		if(VALID_F == 1'b1 && READY_F == 1'b1)
			next_que_len = 2'b01;
	2'b01:
		if(VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1 && (VALID_F != 1'b1 || READY_F != 1'b1))
			next_que_len = 2'b00;
		else if(VALID_F == 1'b1 && READY_F == 1'b1 && !(VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1))
			next_que_len = 2'b10;
	2'b10:
		if(VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1)
			next_que_len = 2'b01;
	endcase
end
endmodule
