// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : tb_fully_registered.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : testbench for fully_registered.v
//  =============================================================================

`timescale 1ns/1ps

module tb_fully_registered;
`define PERIOD 13.88 //72Mhz[13.89]
`define PHASETIME (`PERIOD/2) 

reg  ACLK;
reg  ARESETn;

reg  [7:0] INFORMATION_S;
reg  VALID_S;
wire READY_S;
wire [7:0] INFORMATION_R;
wire VALID_R;
reg  READY_R;

// Generate Clock & Reset
initial
begin
	ACLK = 0;
	ARESETn = 0;
	repeat(20) @(posedge ACLK);
	ARESETn = 1;
end

always #`PHASETIME ACLK = ~ACLK;

// Sender signals generation
reg [7:0] sender_counter;	// counter to force empty cycle
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
		sender_counter <= 0;
	else
		sender_counter <= sender_counter + 1'b1;
end

reg [7:0] Info_array[65535:0];
integer i;
initial
begin
	for(i = 0; i <= 65535; i = i + 1)
		Info_array[i] = $random;
end

reg [15:0] sender_addr;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		VALID_S <= 1'b0;
		sender_addr <= 0;
	end
	else
	begin
		if(VALID_S == 1'b0 && sender_counter > 8'h10)
		begin
			VALID_S <= 1'b1;
			INFORMATION_S <= Info_array[sender_addr];
			sender_addr <= sender_addr + 1'b1;
		end
		else
		begin
			if(VALID_S == 1'b1 && READY_S == 1'b1 && sender_counter > 8'h10)
//			if(VALID_S == 1'b1 && READY_S == 1'b1 && sender_counter <= 8'h10)
			begin
				VALID_S <= 1'b1;
				INFORMATION_S <= Info_array[sender_addr];
				sender_addr <= sender_addr + 1'b1;
			end
			else if(VALID_S == 1'b1 && READY_S == 1'b1 && sender_counter <= 8'h10)
//			else if(VALID_S == 1'b1 && READY_S == 1'b1 && sender_counter > 8'h10)
				VALID_S <= 1'b0;
		end
	end
end

// Receiver signals generation
reg [15:0] temp_addr;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		READY_R <= 1'b0;
		temp_addr <= 0;
	end
	else
	begin
		if(Info_array[temp_addr] > 8'h80)
			READY_R <= 1'b1;
		else
			READY_R <= 1'b0;

		temp_addr <= temp_addr + 1'b1;
	end
end

// Data check on receiver
reg [15:0] receiver_addr;
always @(negedge ARESETn or posedge ACLK)
begin
	if(!ARESETn)
	begin
		receiver_addr <= 0;
	end
	else
	begin
		if(READY_R == 1'b1 && VALID_R == 1'b1)
		begin
			if(Info_array[receiver_addr] != INFORMATION_R)
			begin
				$display($time, " Error: Received %h when %h expected", INFORMATION_R, Info_array[receiver_addr]);
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
fully_registered #(8) register_slice(
	.ACLK		(ACLK),
	.ARESETn	(ARESETn),
	.INFORMATION_S	(INFORMATION_S),
	.VALID_S		(VALID_S),
	.READY_S		(READY_S),
	.INFORMATION_R	(INFORMATION_R),
	.VALID_R		(VALID_R),
	.READY_R		(READY_R)
);


endmodule
