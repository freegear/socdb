/*****************************************************************
		         Part of I2S Controller testbench
*****************************************************************/
`timescale 1 ns/ 100ps
module I2S_DAC
(
		ENABLE,		// 1 when active
		MASTER,		// 1 when Master
		WORD_LEN,	// 00 : 8bit, 01 : 16bit, 10 : 24 bit, 11 : 32 bit
		LJUST,		// l : Left Justfied Mode, 0 : I2S Mode

		MCLK,		// 256*Fs
		BCLK,
		LRCLK,
		SDIN
);

input         ENABLE;
input         MASTER;
input  [ 1:0] WORD_LEN;
input         LJUST; 

input         MCLK;
inout         BCLK;
inout         LRCLK;
input         SDIN;


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

assign #1 BCLK = (MASTER)  ? BCLKInt : 1'bz;
assign #1 LRCLK = (MASTER) ? LRCLKInt : 1'bz;

reg  LRCLK1d;
always @(posedge BCLK) LRCLK1d <= LRCLK;

reg [31:0] LeftData;
reg [31:0] RightData;

wire SDINMux;
reg LeftRight;
initial LeftData = 0;
initial RightData = 0;
initial LeftRight = 0;
reg [6:0] BitCounter;
reg [31:0] LeftDataTemp;
always @(posedge BCLK)
begin
	if(LRCLK1d == 1 && LRCLK == 0)	// Left Start case
	begin
		LeftDataTemp <= LeftData;
		LeftData <= 0;
		RightData[BitCounter] <= SDINMux;
		BitCounter <= 31;
		LeftRight <= 0;
	end
	else if(LRCLK1d == 0 && LRCLK == 1)		// Right Start
	begin
		RightData <= 0;
		LeftData[BitCounter] <= SDINMux;
		BitCounter <= 31;
		LeftRight <= 1;
	end
	else if(BitCounter != 0)
	begin
		BitCounter <= BitCounter - 1;
		if(LeftRight == 0)
			LeftData[BitCounter] <= SDINMux;
		else
			RightData[BitCounter] <= SDINMux;
	end
end

reg SDIN1d;
always @(posedge BCLK) SDIN1d <= SDIN;
assign SDINMux = (LJUST) ? SDIN1d : SDIN;

reg Report;
initial Report = 0;
always @(posedge BCLK)
	if(LRCLK1d == 1 && LRCLK == 0) Report <= 1;
	else Report <= 0;

integer i;
integer j;
always @(posedge ENABLE) i = 0;
always @(posedge ENABLE) j = 0;
always @(posedge ENABLE) LeftDataTemp = 0;
always @(posedge BCLK)
	if(Report == 1 && ENABLE)
	begin
		case(WORD_LEN)
		2'b00:
		begin
			if(j == 1)
			begin
				if(i < 64)
				begin
					if(RightData[31:24] !== 0 || LeftDataTemp[31:24] !== 0)
					begin
						$display($time, "DAC Checking data");
						if(RightData[31:24] !== (255-i) || LeftDataTemp[31:24] !== i)
						begin
							$display($time, "DAC Error ");
							$stop;
						end
					end
				end
				j = 0;
				if((RightData[31:24] !== 0 || LeftDataTemp[31:24] !== 0))
					i = i + 1;
			end
			else
			begin
				if(i < 64)
				begin
					if(i != 0 || RightData[31:24] !== 0 || LeftDataTemp[31:24] !== 0)
					begin
						$display($time, "DAC Checking data");
						if(RightData[31:24] !== i || LeftDataTemp[31:24] !== (255-i))
						begin
							$display($time, "DAC Error ");
							$stop;
						end
						j = 1;
					end
				end
			end
		end
		2'b01:
		begin
			if(i < 64)
			begin
				if(i != 0 || RightData[31:16] !== 0 || LeftDataTemp[31:16] !== 0)
				begin
					$display($time, "DAC Checking data");
					if(LeftDataTemp[31:24] !== i || LeftDataTemp[23:16] !== (255-i)
						|| RightData[31:24] !== (255-i) || RightData[23:16] !== i)
					begin
						$display($time, "DAC Error ");
						$stop;
					end
					i = i + 1;
				end
			end
		end
		2'b10:
		begin
			if(i < 64)
			begin
				if(i != 0 || RightData[31:8] !== 0 || LeftDataTemp[31:8] !== 0)
				begin
					$display($time, "DAC Checking data");
					if(LeftDataTemp[31:24] !== i || LeftDataTemp[23:16] !== i
						|| LeftDataTemp[15:8] !== (255-i))
					begin
						$display($time, "DAC Error ");
						$stop;
					end
					i = i + 1;
					if(RightData[31:24] !== i || RightData[23:16] !== i
						|| RightData[15:8] !== (255-i))
					begin
						$display($time, "DAC Error ");
						$stop;
					end
					i = i + 1;
				end
			end
		end
		2'b11:
		begin
			if(i < 64)
			begin
				if(i != 0 || RightData[31:0] !== 0 || LeftDataTemp[31:0] !== 0)
				begin
					$display($time, "DAC Checking data");
					if(LeftDataTemp[31:24] !== (255-i) || LeftDataTemp[23:16] !== i
						|| LeftDataTemp[15:8] !== i || LeftDataTemp[7:0] !== (255-i))
					begin
						$display($time, "DAC Error ");
						$stop;
					end
					i = i + 1;
					if(RightData[31:24] !== (255-i) || RightData[23:16] !== i
						|| RightData[15:8] !== i || RightData[7:0] !== (255-i))
					begin
						$display($time, "DAC Error ");
						$stop;
					end
					i = i + 1;
				end
			end
		end
		endcase
	end

always @(posedge BCLK)
	if(Report == 1 && ENABLE)
	begin
		case(WORD_LEN)
		2'b00:
			$display($time, "DAC received data [%h]", {RightData[31:24], LeftDataTemp[31:24]});
		2'b01:
			$display($time, "DAC received data [%h]", {RightData[31:16], LeftDataTemp[31:16]});
		2'b10:
			$display($time, "DAC received data [%h, %h]", LeftDataTemp[31:8], RightData[31:8]);
		2'b11:
			$display($time, "DAC received data [%h, %h]", LeftDataTemp[31:0], RightData[31:0]);
		endcase
	end
endmodule

