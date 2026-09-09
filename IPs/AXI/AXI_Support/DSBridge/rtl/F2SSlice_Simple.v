// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : F2SSlice_Simple.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is a part of AXI Downward Synchronizing Bridge
//                     : You can use this module
//                     : with apropriate parameter(WIDTH).
//  =============================================================================

`timescale 1ns/1ps

module F2SSlice_Simple
(
		ACLK_Fast    , 	// Fast Side Clock
		ARESETn      ,  // Reset
		SlowClockEn  ,  // Signal to indicate Slow Clock rising edge
		INFORMATION_F,  // Fast Side Information(input)
		VALID_F      ,  // Fast Side VALID(input)
		READY_F      ,  // Fast Side READY(output)
		INFORMATION_S,  // Slow Side Information(output)
		VALID_S      ,  // Slow Side VALID(output)
		READY_S         // Slow Side READY(input)
);

//
// NOTE : Fast-to-Slow Slice Module(Simple Mode)
//                  +--------+
// INFORMATION_F => |        | => INFORMATION_S
// VALID_F       => |  this  | => VALID_S
//                  | module |
// READY_F       <= |        | <= READY_S
//                  +--------+
// suffix _F denotes "Fast Side"
// suffix _S denotes "Slow Side"
//
// INFORMATION_F & VALID_F are registered but READY_S is passed through comb. logic to READY_F
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
wire READY_F;
reg  VALID_S;
wire READY_S;

wire [WIDTH-1:0] INFORMATION_F;
reg  [WIDTH-1:0] INFORMATION_S;

assign READY_F = ((VALID_S == 1'b0 || READY_S == 1'b1) && SlowClockEn == 1'b1) ? 1'b1 : 1'b0;

always @(negedge ARESETn or posedge ACLK_Fast)
	if(!ARESETn)
	begin
		VALID_S <= 1'b0;	// VALID LOW when reset : one of AXI requirements.
		INFORMATION_S <= {WIDTH{1'b0}};	// don't care when VALID_S is LOW.
	end
	else
	begin
		if(VALID_F == 1'b1 && READY_F == 1'b1)	// READY_F can be high only when SlockClockEn is high
			INFORMATION_S <= INFORMATION_F;

		if (VALID_F == 1'b1 && SlowClockEn == 1'b1)
			VALID_S <= 1'b1;
		else if(READY_S == 1'b1 && SlowClockEn == 1'b1)
			VALID_S <= 1'b0;
	end

endmodule

