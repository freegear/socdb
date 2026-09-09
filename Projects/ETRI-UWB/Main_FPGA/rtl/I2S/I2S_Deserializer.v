// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_Deserializer.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module Deserializer module in I2S Controller.
//  =============================================================================

`timescale 1ns/1ps

module I2S_Deserializer 
(
		// System Clock & Reset
		CLK,			// Clock : connect to PCLK
		RESETn, 		// active low asynchornous reset

		// Control
		Enabled,		// 1 when enabled
		SyncReset,		// 1 when user reset requested
		WordLength,		// 00 : 8bit, 01 : 16bit, 10 : 24bit, 11 : 32bit
		LeftJust,		// 0 when I2SMode, 1 when Left Justified mode

		FifoOverRun,	// 1 when Fifo OverRun detected

		// I2SLINK Clock
		LRCLK,			// 0 when Left , 1 when Right
		BCLKRise,		// 1 when BCLK Rising detected
		SDIN,			// Serial Data Input(Do not connect ADC directly : should consider Metastability)

		// Fifo
		FifoWData,			// 32bit Fifo Write Data
		FifoAfford2Write,	// 1 when Fifo can store more than 2 data
		FifoFull,			// 1 when Fifo is full
		nFifoWriteEn		// 0 when Fifo Write Enable
);

//
// input/output port
//
input         CLK;
input         RESETn;

input         Enabled;
input         SyncReset;
input  [1:0]  WordLength;
input         LeftJust;

output        FifoOverRun;

input         LRCLK;
input         BCLKRise;
input         SDIN;

output [31:0] FifoWData;
input         FifoAfford2Write;
input         FifoFull;
output        nFifoWriteEn;

// Input mux : I2S or Left-Justififed mode selection
// Remained logic operates assuming I2S Mode.
wire SDIN_I2S;
reg  SDIN1d;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		SDIN1d <= 0;
	else if(BCLKRise)
			SDIN1d <= SDIN;
end
assign SDIN_I2S = (LeftJust) ? SDIN1d : SDIN;

// Channel detect
wire LRCLK1d;
reg LeftRight;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		LeftRight <= 0;
	else if(BCLKRise)
		LeftRight <= LRCLK;
end
assign LRCLK1d = LeftRight;

// LRCLK inverting detect
reg NewChannelStart;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		NewChannelStart <= 0;
	else
	begin
		if(BCLKRise)
			NewChannelStart <= LRCLK1d^LRCLK;
		else
			NewChannelStart <= 0;
	end
end

wire FrameStart;
assign FrameStart = NewChannelStart && LRCLK == 0;
reg RealEnabled;	// really enabled when Enabled=1 & FrameStart detected
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		RealEnabled <= 0;
	else
	begin
		if(!Enabled)
			RealEnabled <= 0;
		else if(Enabled && FrameStart)
			RealEnabled <= 1;
	end
end

// Bit Counter manipulation
reg [4:0] BitCounter;
reg       BitCounterValid;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		BitCounter <= 5'd31;
		BitCounterValid <= 1;
	end
	else
	begin
		if(NewChannelStart)
		begin
			BitCounter <= 5'd31;
			BitCounterValid <= 1;
		end
		else if(BCLKRise)
		begin
			if(BitCounter == 0)
				BitCounterValid <= 0;
			else
			begin
				BitCounter <= BitCounter - 1;
				BitCounterValid <= 1;
			end
		end
	end
end

// Data Latching
reg [31:0] LeftData;
reg [31:0] RightData;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		LeftData <= 0;
		RightData <= 0;
	end
	else
	begin
		if(LeftRight == 0 && BCLKRise && BitCounterValid)
			LeftData[BitCounter] <= SDIN_I2S;
		if(LeftRight == 1 && BCLKRise && BitCounterValid)
			RightData[BitCounter] <= SDIN_I2S;
	end
end

// FIFO Writing
reg [31:0] FifoWData;
reg        RightSave;
reg        DataState;		// for 8bit for sample
reg        FifoWriteEn;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		DataState <= 0;
	else
	begin
		if(SyncReset == 1)
			DataState <= 0;
		else if(RealEnabled == 1 && FrameStart == 1)
			DataState <= ~DataState;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		FifoWData <= 0;
		RightSave <= 0;
		FifoWriteEn <= 0;
	end
	else if(RealEnabled == 1)
	begin
		if(FrameStart)	// Frame Start Condition
		begin
			case(WordLength)
			2'b00:
			begin
				RightSave <= 0;
				if(DataState == 0) FifoWData[15:0] <= { RightData[31:24], LeftData[31:24]};
				else FifoWData[31:16] <= { RightData[31:24], LeftData[31:24]};
				if(DataState == 1)
					FifoWriteEn <= 1;
				else
					FifoWriteEn <= 0;
			end
			2'b01:
			begin
				RightSave <= 0;
				FifoWData <= {RightData[31:16], LeftData[31:16]};
				FifoWriteEn <= 1;
			end
			2'b10:
			begin
				RightSave <= 1;
				FifoWData <= {{8{LeftData[31]}}, LeftData[31:8]};		// sign extension
				if(FifoAfford2Write)
					FifoWriteEn <= 1;
				else
					FifoWriteEn <= 0;
			
			end
			2'b11:
			begin
				RightSave <= 1;
				FifoWData <= LeftData[31:0];
				if(FifoAfford2Write)
					FifoWriteEn <= 1;
				else
					FifoWriteEn <= 0;
			end
			endcase
		end
		else if(RightSave)
		begin
			RightSave <= 0;
			if(WordLength[0] == 0)	// 24 bit case
				FifoWData <= {{8{RightData[31]}}, RightData[31:8]};
			else
				FifoWData <= RightData[31:0];

			if(FifoWriteEn == 1)
				FifoWriteEn <= 1;
			else
				FifoWriteEn <= 0;
		end
		else
			FifoWriteEn <= 0;
	end
	else
	begin
		FifoWriteEn <= 0;
		RightSave   <= 0;
	end
end

assign nFifoWriteEn = (FifoFull) ? 1'b1 : ~FifoWriteEn;
assign FifoOverRun  = RealEnabled && ((FifoWriteEn == 1 && FifoFull) | (RightSave == 1 && FifoWriteEn == 0));

// synopsys translate_off
`ifdef NEVER_DEFINE_THIS
always @(posedge CLK)
begin
	if(RESETn && nFifoWriteEn == 0)
		$display($time, "Writing Data[%h] into FIFO", FifoWData);
end
`endif
// synopsys translate_on
endmodule
