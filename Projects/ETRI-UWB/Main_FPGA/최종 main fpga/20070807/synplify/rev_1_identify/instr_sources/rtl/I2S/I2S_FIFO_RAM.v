// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_FIFO_RAM.v
// File Revision       : 0.1
// -----------------------------------------------------------------------------
// Purpose            : This module is a part of I2S_FIFO in I2S Controller.
// =============================================================================

`timescale 1ns/1ps

// This module is modeling dual port SRAM
module I2S_FIFO_RAM
(
		CLK,
		WE,			// active high Write Enable
		WData,		// Write Data
		WA,			// Write Address
	
		RE,			// active high Read Enable
		RData,		// Read Data
		RA			// Read Address
);
//
// module parameter
//
parameter DEPTH = 6;		// 2^DEPTH entry
parameter DATA_WIDTH = 32;	// DATA bit-width

// in/out port
input                   CLK;
input                   WE;
input  [DEPTH-1:0]      WA;
input  [DATA_WIDTH-1:0] WData;
input                   RE;
input  [DEPTH-1:0]      RA;
output [DATA_WIDTH-1:0] RData;

reg [DATA_WIDTH-1:0] mem[{(DEPTH){1'b1}}:0];
reg [DATA_WIDTH-1:0] RData;
always @(posedge CLK)
begin
	if(WE)
		mem[WA] <= WData;

	RData <= mem[RA];
end

endmodule

