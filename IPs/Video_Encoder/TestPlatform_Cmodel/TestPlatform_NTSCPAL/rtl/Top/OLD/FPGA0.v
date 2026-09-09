// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : FPGA0.v
// File Revision       : 1.0
// ----------------------------------------------------------------------------
// Purpose            : FPGA0 for LCD signa routing
// --========================================================================--

`timescale 1ns/1ps
module FPGA0 (
		RESETn,
		// from FPGA1
		LCDClk,
		LCDHSync,
		LCDVSync,
		LCDDataEn,
		LCDData,

		// To LCD
		LCDClkOut,
		LCDHSyncOut,
		LCDVSyncOut,
		LCDDataEnOut,
		LCDDataOut,
		LCDDISP
);

input          RESETn;
input          LCDClk;
input          LCDHSync;
input          LCDVSync;
input          LCDDataEn;
input  [23:0]  LCDData;

output         LCDClkOut;
output         LCDHSyncOut;
output         LCDVSyncOut;
output         LCDDataEnOut;
output [23:0]  LCDDataOut;
output         LCDDISP;

reg         LCDHSyncOut;
reg         LCDVSyncOut;
reg         LCDDataEnOut;
reg [23:0]  LCDDataOut;
always @(negedge LCDClk)
begin
	LCDHSyncOut <= LCDHSync;
	LCDVSyncOut <= LCDVSync;
	LCDDataEnOut <= LCDDataEn;
	LCDDataOut <= LCDData;
end

assign LCDDISP = 1;
assign LCDClkOut = ~LCDClk;

endmodule
