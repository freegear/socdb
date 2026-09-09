
// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : FPGATop.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : FPGA Test(4 Seven Segment Test)
//  --========================================================================--

`timescale 1ns/1ps
module FPGATop(
	Clock,
	nReset,

	Control_4x7Seg,
	Common_4x7Seg
);
input         Clock;
input         nReset;

output [7:0]  Control_4x7Seg;	// A(LSB), B, C, D, E, F, G, DP order
output [3:0]  Common_4x7Seg;		// COM0(LSB), COM1, COM2, COM3

wire Clock_7Seg;
reg  [15:0] Data;

wire [7:0]  Control_4x7Seg_t;	// A(LSB), B, C, D, E, F, G, DP order
wire [3:0]  Common_4x7Seg_t;		// COM0(LSB), COM1, COM2, COM3

assign Control_4x7Seg = ~Control_4x7Seg_t;
assign Common_4x7Seg  = ~Common_4x7Seg_t;

SevenSegment SevenSegment(
	.Clock(Clock_7Seg),
	.nReset(nReset),
	
	.DataIn(Data),
	.ControlOut(Control_4x7Seg_t),
	.CommonOut(Common_4x7Seg_t)
);

reg [31:0] counter;
always @(posedge Clock or negedge nReset)
begin
	if(!nReset)
		counter <= 32'd0;
	else
		counter <= counter + 1;
end

assign Clock_7Seg = counter[17];
wire Clock_Data = counter[22];
always @(posedge Clock_Data or negedge nReset)
begin
	if(!nReset) Data <= 0;
	else Data <= Data + 1;
end

endmodule
