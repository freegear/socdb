//START
// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : fully_registered.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is a part of Register Slice in AXI
//                     : You can use this module
//                     : as a Fully Registered Register Slice
//                     : with apropriate parameter(WIDTH).
//  =============================================================================

`timescale 1ns/1ps

module ARM_AWSIsi2mi_registered 
(
		ACLK         , 
		ARESETn      , 
		INFORMATION_S,
		VALID_S      ,
		READY_S      ,
		INFORMATION_R,
		VALID_R      ,
		READY_R
);

//
// NOTE : Fully Registered Module.
//                  +--------+
// INFORMATION_S => |        | => INFORMATION_R
// VALID_S       => |  this  | => VALID_R
//                  | module |
// READY_S       <= |        | <= READY_R
//                  +--------+
// suffix _S denotes "Sender"
// suffix _R denotes "Receiver"
//
// INFORMATION_S & VALID_S & READY_R are registered.
//
//

parameter WIDTH  = 44;

input  ACLK;
input  ARESETn;
input  [WIDTH-1:0] INFORMATION_S;
input  VALID_S;
output READY_S;
output [WIDTH-1:0] INFORMATION_R;
output VALID_R;
input  READY_R;

wire ACLK;
wire ARESETn;
wire VALID_S;
wire READY_S;
reg  VALID_R;
wire READY_R;

wire [WIDTH-1:0] INFORMATION_S;
wire [WIDTH-1:0] INFORMATION_R;

reg  [WIDTH-1:0] INFORMATION_0;
reg  [WIDTH-1:0] INFORMATION_1;
reg  que_len;
reg  ready_r_ff;

assign INFORMATION_R = INFORMATION_0;

assign READY_S = (ready_r_ff == 1'b1 || que_len == 1'b0) ? 1'b1 : 1'b0;

always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
	begin
		VALID_R <= 1'b0;	// VALID LOW when reset : one of AXI requirements.
		INFORMATION_0 <= {WIDTH{1'b0}};	// don't care when VALID is LOW.
		INFORMATION_1 <= {WIDTH{1'b0}};	// don't care when VALID is LOW.
		que_len <= 1'b0;
		ready_r_ff <= 1'b1;
	end
	else
	begin
		if(que_len == 1'b0 && !(VALID_R == 1'b1 && READY_R == 1'b0))
			INFORMATION_0 <= INFORMATION_S;		// latch INFORMATION_S @ INFORMATION_0 when que is empty
		else if(que_len == 1'b1 && READY_R == 1'b1)
			INFORMATION_0 <= INFORMATION_1;		// Shift previous received information

		if(VALID_S == 1'b1 && READY_S == 1'b1)
			INFORMATION_1 <= INFORMATION_S;		// always latch INFORMATION_S @ INFORMATION_1 for later use


		if(VALID_S == 1'b1 && VALID_R == 1'b1 && READY_R == 1'b0)	// Receiver doesn't accept
		begin
			// increase que_len
			que_len <= 1'b1;
		end
		else if(que_len == 1'b1 && READY_R == 1'b1) // Receiver accept
		begin
			// decrease que_len
			que_len <= 1'b0;
		end

		ready_r_ff <= READY_R;

		if (VALID_S == 1'b1)
			VALID_R <= 1'b1;
		else if(que_len == 1'b0 && READY_R == 1'b1)	// no valid data on que and get ready from receiver
			VALID_R <= 1'b0;
	end

endmodule
