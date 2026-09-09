// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tb_F2SSlice_Simple.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : testbench for F2SSlice_Simple.v
//  =============================================================================

`timescale 1ns/1ps

module tb_F2SSlice_Simple;
parameter FAST_CLK_HPERIOD = 5;		// ACLK_Fast clock half period
parameter SLOW_CLK_MULTIPLIER=2;	// ACLK_Slow is slower than ACLK_Fast by this factor
parameter COMB_DELAY = 1;
parameter RANDOMIZE = 0;

reg  ACLK_Fast;
wire ACLK_Slow;
reg  ARESETn;

reg  [7:0] INFORMATION_F;
reg  VALID_F;
wire READY_F;
wire [7:0] INFORMATION_S;
wire VALID_S;
reg  READY_S;

// Generate Clock & Reset
always #FAST_CLK_HPERIOD ACLK_Fast = ~ACLK_Fast;
initial
begin
	ACLK_Fast = 0;
	ARESETn = 0;
	repeat(20) @(posedge ACLK_Fast);
	ARESETn = 1;
end

reg [31:0] CLK_cnt;
reg        CLK_div;
reg        SlowClockEn;

initial CLK_cnt = 0;
always @(posedge ACLK_Fast)
begin
	if(CLK_cnt == 0) CLK_cnt <= #1 SLOW_CLK_MULTIPLIER-1;
	else CLK_cnt <= #1 CLK_cnt - 1;
	
	if(CLK_cnt < (SLOW_CLK_MULTIPLIER>>1)) CLK_div = 1'b0;
	else CLK_div = 1'b1;
end

always @(posedge ACLK_Fast)
	SlowClockEn <= #COMB_DELAY (CLK_cnt == 0);

assign ACLK_Slow = (SLOW_CLK_MULTIPLIER == 1) ? ACLK_Fast : CLK_div;

// Sender signals generation
reg [7:0] Info_array[65535:0];
integer i;
initial
begin
	for(i = 0; i <= 65535; i = i + 1)
		Info_array[i] = $random;
end

reg [15:0] sender_addr;
reg send_random;
always @(negedge ARESETn or posedge ACLK_Fast)
begin
	if(!ARESETn)
	begin
		VALID_F <= 1'b0;
		sender_addr <= 0;
	end
	else
	begin
		send_random = $random/16;
		if(VALID_F == 1'b0 && (RANDOMIZE == 0 || send_random == 1'b1))
		begin
			VALID_F <= 1'b1;
			INFORMATION_F <= Info_array[sender_addr];
			sender_addr <= sender_addr + 1'b1;
		end
		else
		begin
			if(VALID_F == 1'b1 && READY_F == 1'b1)
			begin
				if(RANDOMIZE == 0 || send_random == 1'b1)
				begin
					VALID_F <= 1'b1;
					INFORMATION_F <= Info_array[sender_addr];
					sender_addr <= sender_addr + 1'b1;
				end
				else
					VALID_F <= 1'b0;
			end
		end
	end
end

// Receiver signals generation
// Random READY generator
always @(negedge ARESETn or posedge ACLK_Slow)
begin
	if(!ARESETn)
		READY_S <= 1'b0;
	else
	begin
		if(RANDOMIZE == 1)
			READY_S = #COMB_DELAY $random/16;
		else
			READY_S = 1'b1;
	end
end

// Data check on receiver
reg [15:0] receiver_addr;
always @(negedge ARESETn or posedge ACLK_Slow)
begin
	if(!ARESETn)
	begin
		receiver_addr <= 0;
	end
	else
	begin
		if(READY_S == 1'b1 && VALID_S == 1'b1)
		begin
			if(Info_array[receiver_addr] != INFORMATION_S)
			begin
				$display($time, " Error: Received %h when %h expected", INFORMATION_S, Info_array[receiver_addr]);
				$stop;
			end

			if(receiver_addr == 16'hFFFF)
			begin
				$display($time, " Simulation ended without error");
				$finish;
			end
			receiver_addr <= receiver_addr + 1'b1;
		end
	end
end

// Register slice instance
F2SSlice_Simple #(8) F2SSlice_Simple(
	.ACLK_Fast	(ACLK_Fast),
	.ARESETn	(ARESETn),
	.SlowClockEn(SlowClockEn),
	.INFORMATION_F	(INFORMATION_F),
	.VALID_F		(VALID_F),
	.READY_F		(READY_F),
	.INFORMATION_S	(INFORMATION_S),
	.VALID_S		(VALID_S),
	.READY_S		(READY_S)
);


endmodule
