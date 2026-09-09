/*****************************************************************
		         Part of I2S Controller testbench
*****************************************************************/
`timescale 1 ns/ 100ps
module I2S_ADC
(
		MASTER,		// 1 when Master
		WORD_LEN,	// 00 : 8bit, 01 : 16bit, 10 : 24 bit, 11 : 32 bit
		LJUST,		// l : Left Justfied Mode, 0 : I2S Mode

		MCLK,		// 256*Fs
		BCLK,
		LRCLK,
		SDOUT
);

input         MASTER;
input  [ 1:0] WORD_LEN;
input         LJUST; 

input         MCLK;
inout         BCLK;
inout         LRCLK;
output        SDOUT;


reg [1:0] BCLKCounter;

initial BCLKCounter = 0;
always @(posedge MCLK)
begin
	BCLKCounter <= BCLKCounter+1;
end

assign BCLKInt = BCLKCounter[1];	// 1/4 * 256 * Fs
reg [5:0] LRCLKCounter;
initial LRCLKCounter = 0;

always @(negedge BCLKInt)
begin
	LRCLKCounter <= LRCLKCounter + 1;
end
assign LRCLKInt = LRCLKCounter[5];

tri  BCLK;
tri  LRCLK;

assign #2 BCLK = (MASTER)  ? BCLKInt : 1'bz;
assign #1 LRCLK = (MASTER) ? LRCLKInt : 1'bz;

reg  LRCLK1d;
always @(negedge BCLK) LRCLK1d <= LRCLK;

reg [31:0] LeftData;
reg [31:0] RightData;

wire SDINMux;
reg LeftRight;
initial LeftData = 0;
initial RightData = 0;
initial LeftRight = 0;
reg [6:0] BitCounter;
reg [31:0] LeftDataTemp;
always @(negedge BCLK)
begin
	if(LRCLK1d == 1 && LRCLK == 0)	// Left Start case
	begin
		LeftData <= $random;
		RightData <= $random;
		BitCounter <= 31;
		LeftRight <= 0;
	end
	else if(LRCLK1d == 0 && LRCLK == 1)		// Right Start
	begin
		BitCounter <= 31;
		LeftRight <= 1;
	end
	else if(BitCounter != 0)
	begin
		BitCounter <= BitCounter - 1;
	end
end

wire SDOUT_LJ;
assign SDOUT_LJ = (LeftRight == 0) ? LeftData[BitCounter] : RightData[BitCounter];
reg SDOUT_I2S;
always @(negedge BCLK)
	SDOUT_I2S = SDOUT_LJ;

assign SDOUT = (LJUST) ? SDOUT_LJ : SDOUT_I2S;

reg Report;
initial Report = 0;
always @(negedge BCLK)
	if(LRCLK1d == 1 && LRCLK == 0) Report <= 1;
	else Report <= 0;

always @(negedge BCLK)
	if(Report == 1)
	begin
		$display($time, "ADC transmitting data [%h, %h]", LeftData[31:0], RightData[31:0]);
	end
endmodule

