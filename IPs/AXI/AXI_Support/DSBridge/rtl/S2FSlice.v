// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : S2FSlice.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is a part of AXI Downward Synchronizing Bridge
//                     : You can use this module
//                     : with apropriate parameter(WIDTH).
//  =============================================================================

`timescale 1ns/1ps

module S2FSlice
(
		ACLK_Fast    , 	// Fast Side Clock
		ARESETn      ,  // Reset
		SlowClockEn  ,  // Signal to indicate Slow Clock rising edge
		INFORMATION_F,  // Fast Side Information(output)
		VALID_F      ,  // Fast Side VALID(output)
		READY_F      ,  // Fast Side READY(input)
		INFORMATION_S,  // Slow Side Information(input)
		VALID_S      ,  // Slow Side VALID(input)
		READY_S         // Slow Side READY(output)
);

//
// NOTE : Slow-to-Fast Slice Module
//                  +--------+
// INFORMATION_S => |        | => INFORMATION_F
// VALID_S       => |  this  | => VALID_F
//                  | module |
// READY_S       <= |        | <= READY_F
//                  +--------+
// suffix _F denotes "Fast Side"
// suffix _S denotes "Slow Side"
//
// INFORMATION_S & VALID_S & READ_F are registered.
//
//

parameter WIDTH  = 15;

input  ACLK_Fast;
input  ARESETn;
input  SlowClockEn;
output [WIDTH-1:0] INFORMATION_F;
output VALID_F;
input  READY_F;
input  [WIDTH-1:0] INFORMATION_S;
input  VALID_S;
output READY_S;

wire ACLK_Fast;
wire ARESETn;
wire SlowClockEn;
wire VALID_S;
reg  READY_S;
reg  VALID_F;
wire READY_F;

wire [WIDTH-1:0] INFORMATION_S;
wire [WIDTH-1:0] INFORMATION_F;


reg  [WIDTH-1:0] INFORMATION_0;
reg  [WIDTH-1:0] INFORMATION_1;
reg [1:0] que_len;
reg [1:0] next_que_len;
assign INFORMATION_F = INFORMATION_0;
always @(negedge ARESETn or posedge ACLK_Fast)
	if(!ARESETn)
	begin
		VALID_F <= 1'b0;	// VALID LOW when reset : one of AXI requirements.
		INFORMATION_0 <= {WIDTH{1'b0}};	// don't care when VALID is LOW.
		INFORMATION_1 <= {WIDTH{1'b0}};	// don't care when VALID is LOW.
		que_len <= 2'b0;
		READY_S <= 0;
	end
	else
	begin
		que_len <= next_que_len;

		if(VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1 && (que_len[0] == 1'b0 || READY_F == 1'b1))
			INFORMATION_0 <= INFORMATION_S;
		else if(READY_F == 1'b1)
			INFORMATION_0 <= INFORMATION_1;

		if(VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1)
			INFORMATION_1 <= INFORMATION_S;

		if(SlowClockEn == 1'b1 && next_que_len == 2'b10)
			READY_S <= 1'b0;
		else if(SlowClockEn == 1'b1)
			READY_S <= 1'b1;

		if (next_que_len != 2'b00)
			VALID_F <= 1'b1;
		else
			VALID_F <= 1'b0;
	end

always @(que_len, SlowClockEn, VALID_S, READY_S, READY_F)
begin
	next_que_len = que_len;
	case (que_len)
	2'b00:
		if(VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1)
			next_que_len = 2'b01;
	2'b01:
		if(READY_F == 1'b1 && (VALID_S != 1'b1 || READY_S != 1'b1 || SlowClockEn != 1'b1))
			next_que_len = 2'b00;
		else if(VALID_S == 1'b1 && READY_S == 1'b1 && SlowClockEn == 1'b1 && READY_F != 1'b1)
			next_que_len = 2'b10;
	default:	// 2'b10
		if(READY_F == 1'b1)
			next_que_len = 2'b01;
	endcase
end
endmodule
