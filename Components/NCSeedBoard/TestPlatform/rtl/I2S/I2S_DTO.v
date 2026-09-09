// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_DTO.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module DTO module in I2S Controller.
//  =============================================================================

`timescale 1ns/1ps

module I2S_DTO 
(
		SYS_CLK,		// SYS_CLK : System Clock(should be faster 5(11) times more than MCLK)
		RESETn, 		// active low asynchornous reset

		MCLK,			// MCLK : 258^Fs(sampling frequency)
		BCLK,			// BCLK : 64*Fs

		Enable,			// enable
		DTORatio		// DTO ratio
);

//
// module parameter
//
parameter WIDTH = 28;	// DTORatio bit width

//
// input/output port
//
input              SYS_CLK;
input              RESETn;

output             MCLK;
output             BCLK;
input              Enable;
input  [WIDTH-1:0] DTORatio;

//
// Signals
//
reg [WIDTH+1:0] DTORegister;
reg Enable1d;
reg [WIDTH-1:0]   DTORatio1d;

// BCLK/MCLK generation
always @(posedge SYS_CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		DTORatio1d <= 0;
		Enable1d   <= 0;
		DTORegister <= 0;
	end
	else
	begin
		// Flip-flop for avoding metastability
		DTORatio1d <= DTORatio;
		Enable1d   <= Enable;

		if(Enable1d)
			DTORegister <= DTORegister + DTORatio1d;
		else
			DTORegister <= 0;
	end
end

assign MCLK = DTORegister[WIDTH-1];
assign BCLK = DTORegister[WIDTH+1];

endmodule
