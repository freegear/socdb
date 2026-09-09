// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_Serializer.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module Serializer module in I2S Controller.
//  =============================================================================

`timescale 1ns/1ps

module I2S_Serializer 
(
		// System Clock & Reset
		CLK,			// Clock : connect to PCLK
		RESETn, 		// active low asynchornous reset

		// Control
		Enabled,		// 1 when Enabled 
		SyncReset,		// 1 when user reset requested
		WordLength,		// 00 : 8bit, 01 : 16bit, 10 : 24 bit, 11 : 32 bit
		LeftJust,		// 0 when I2SMode, 1 when Left Justfied mode
		
		FifoUnderRun,	// 1 when Fifo UnderRun detected.

		// I2SLINK Timing
		FrameStart,		// 1 when Left Start
		RightStart,		// 1 when Right Start
		BCLKFall,		// 1 when BCLK falling detected
		SDOUT,			// Serial Data ouptut(connect to DAC directly)

		// Fifo
		FifoData,			// 32bit Fifo Read Data
		FifoAfford2Read,	// 1 when Fifo stores at least 2 data
		FifoEmpty,			// 1 when Fifo is empty
		nFifoReadEn			// 0 when Fifo Read Enable
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

output        FifoUnderRun;

input         FrameStart;
input         RightStart;
input         BCLKFall;
output        SDOUT;

input  [31:0] FifoData;
input         FifoAfford2Read;
input         FifoEmpty;
output        nFifoReadEn;


//
// Data Loading Related Logic
//
reg [31:0] LeftData;		// Left Channel Data Register
reg [31:0] RightData;		// Right Channel Data Register

// following 2 signal exists for 8 bit/sample support
reg DataRemained;			// 2x8bit Data Remained at RemainedData
reg [15:0] RemainedData;	// 2x8bit data before a frame.

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		DataRemained <= 0;
	else
	begin
		if(SyncReset)
			DataRemained <= 0;
		else if(Enabled && FrameStart && WordLength == 2'b00)
			DataRemained <= ~DataRemained;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		RemainedData <= 0;
	else if(nFifoReadEn == 0)
		RemainedData <= FifoData[31:16];
end

// Data Loading block
reg RightLoad;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	begin
		LeftData <= 0;
		RightData <= 0;
	end
	else
	begin
		if(SyncReset)
		begin
			LeftData <= 0;
			RightData <= 0;
		end
		else
		begin
			if(Enabled && FrameStart)
			begin
				case(WordLength)
				2'b00:	// 8bit
					if(DataRemained == 1)	// Data remained @ RemainedData
					begin
						LeftData <= {RemainedData[7:0], 24'h000000};
						RightData <= {RemainedData[15:8], 24'h000000};
					end
					else if(!FifoEmpty)
					begin
						LeftData <= {FifoData[7:0], 24'h000000};
						RightData <= {FifoData[15:8], 24'h000000};
					end
				2'b01:	// 16 bit
					if(!FifoEmpty)
					begin
						LeftData <= {FifoData[15:0], 16'h0000};
						RightData <= {FifoData[31:16], 16'h0000};
					end
				2'b10:	// 24 bit
					if(FifoAfford2Read)
						LeftData <= {FifoData[23:0], 8'h00};
				2'b11:	// 32 bit
					if(FifoAfford2Read)
						LeftData <= FifoData[31:0];
				endcase
			end
			else if(RightLoad)
			begin
				if(WordLength[0] == 1'b1)	// 32bit case
					RightData <= FifoData[31:0];
				else	// 24bit
					RightData <= {FifoData[23:0], 8'h00};
			end
		end
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		RightLoad <= 0;
	else
		RightLoad <= Enabled && FrameStart && FifoAfford2Read && (WordLength[1] == 1);
end

reg nFifoReadEn;
always @(RightLoad or Enabled or FrameStart or WordLength or DataRemained or FifoAfford2Read or FifoEmpty)
begin
	nFifoReadEn = 1;
	if(RightLoad == 1)
		nFifoReadEn = 0;
	else if(Enabled && FrameStart)
	begin
		case(WordLength)
		2'b00: nFifoReadEn = DataRemained || FifoEmpty;
		2'b01: nFifoReadEn = FifoEmpty;
		2'b10: nFifoReadEn = ~FifoAfford2Read;
		2'b11: nFifoReadEn = ~FifoAfford2Read;
		endcase
	end
end

reg FifoUnderRun;
always @(Enabled or FrameStart or WordLength or DataRemained or FifoAfford2Read or FifoEmpty)
begin
	FifoUnderRun = 0;
	if(Enabled && FrameStart)
	begin
		case(WordLength)
		2'b00: FifoUnderRun = (~DataRemained && FifoEmpty);
		2'b01: FifoUnderRun = FifoEmpty;
		2'b10: FifoUnderRun = ~FifoAfford2Read;
		2'b11: FifoUnderRun = ~FifoAfford2Read;
		endcase
	end
end

// Bit Counter for Serialization
reg [4:0] BitCounter;
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		BitCounter <= 0;
	else
	begin
		if(FrameStart | RightStart)
			BitCounter <= 5'd31;
		else if(BCLKFall && (BitCounter != 0))
			BitCounter <= BitCounter - 1;
	end
end

reg LeftRight;	// 1 when Left, 0 when Right
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		LeftRight <= 1'b0;	// IDLE
	else
	begin
		if(SyncReset == 1 || Enabled == 0)
			LeftRight <= 1'b0;
		else if(FrameStart)
			LeftRight <= 1'b1;
		else if(RightStart)
			LeftRight <= 1'b0;
	end
end

// Left Justified mode output
wire SDOUTLeftJust;
assign SDOUTLeftJust = Enabled ? (LeftRight ? LeftData[BitCounter] : RightData[BitCounter]) : 1'b0;

// I2S mode output
reg SDOUT_I2S;	// 1 BCLK delayed version of SDOUTLeftJust
always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
		SDOUT_I2S <= 0;
	else if(BCLKFall)
		SDOUT_I2S <= SDOUTLeftJust;
end

// output mux
assign SDOUT = (LeftJust) ? SDOUTLeftJust : SDOUT_I2S;

endmodule
