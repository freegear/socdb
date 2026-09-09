// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from RichenTech
// ALL RIGHTS RESERVED RichenTech 
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : registered_forward.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module is a part of Register Slice in AXI
//                     : You can use this module
//                     : as a Registered Forword Register Slice
//                     : with apropriate parameter(WIDTH).
//  =============================================================================

`timescale 1ns/1ps

module ?NAME?_?NUM?_registered
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
// NOTE : Registered Forward Module.
//                  +--------+
// INFORMATION_S => |        | => INFORMATION_R
// VALID_S       => |  this  | => VALID_R
//                  | module |
// READY_S       <= |        | <= READY_R
//                  +--------+
// suffix _S denotes "Sender"
// suffix _R denotes "Receiver"
//
// INFORMATION_S & VALID_S are registered but READY_R is passed through comb. logic to READY_S
//
//

parameter WIDTH  = ?WID?;

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
reg  [WIDTH-1:0] INFORMATION_R;

assign READY_S = (VALID_R == 1'b0 || READY_R == 1'b1) ? 1'b1 : 1'b0;

always @(negedge ARESETn or posedge ACLK)
	if(!ARESETn)
	begin
		VALID_R <= 1'b0;	// VALID LOW when reset : one of AXI requirements.
		INFORMATION_R <= {WIDTH{1'b0}};	// don't care when VALID_R is LOW.
	end
	else
	begin
		if(VALID_S == 1'b1 && READY_S == 1'b1)
			INFORMATION_R <= INFORMATION_S;

		if (VALID_S == 1'b1)
			VALID_R <= 1'b1;
		else if(READY_R == 1'b1)
			VALID_R <= 1'b0;
	end

endmodule
//Code_END
