// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : I2S_FIFO.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : This module FIFO module in I2S Controller.
//  =============================================================================

`timescale 1ns/1ps

module I2S_FIFO 
(
		CLK,			// Clock : connect to PCLK
		RESETn, 		// active low asynchornous reset

		nReadEnable,	// active low Read Enable
		ReadData,		// 32bit Read Data

		nWriteEnable,	// active low Write Enable
		WriteData,		// 32bit Write Data

		SyncReset,		// active high synchronous reset
		Full,			// Fifo Full output
		Empty,			// Fifo Empty output
		Afford2Write,	// indicate 2 write possible
		Afford2Read,	// indicate 2 read possible

		FillLevel		// Fill Level of FIFO
);

//
// Usage
//  : You can always read First-In Data from ReadData port(except Empty).
//    You can read next data a clock after nReadEnable is low.
//    You can insert data form WriteData port to FIFO when nWriteEnable is low.
//    FillLevel is zero at both conditions which Fifo is full and empty.
//    You cannot insert more data into FIFO when FIFO is full.
//    You cannot request next data when FIFO is empty.
//
// Real implementation is using Ring-buffer.

//
// module parameter
//
parameter DATA_WIDTH = 32;	// only support 32 bit now
parameter FIFO_DEPTH = 6;	// 2^FIFO_DEPTH entry in fifo

//
// input/output port
//
input  CLK;
input  RESETn;

input                   nReadEnable;
output [DATA_WIDTH-1:0] ReadData;

input                   nWriteEnable;
input  [DATA_WIDTH-1:0] WriteData;

input                   SyncReset;
output                  Full;
output                  Empty;
output                  Afford2Write;
output                  Afford2Read;

output [FIFO_DEPTH-1:0] FillLevel;


reg [DATA_WIDTH-1:0] FifoData[{(FIFO_DEPTH){1'b1}}:0];
reg                  Full;
reg [FIFO_DEPTH-1:0] WriteIndex;
reg [FIFO_DEPTH-1:0] ReadIndex;

wire [FIFO_DEPTH-1:0] nextReadIndex = ReadIndex + 1;
wire [FIFO_DEPTH-1:0] nextWriteIndex = WriteIndex + 1;

wire DoWrite = (nWriteEnable == 0) && !Full;
wire DoRead  = (nReadEnable == 0) && !Empty;

integer i;
always @(negedge RESETn or posedge CLK)
begin
	if(!RESETn)
	begin
		Full       <= 1'b0;
		ReadIndex  <= 0;
		WriteIndex <= 0;
		for(i = 0; i <= {(FIFO_DEPTH){1'b1}}; i = i + 1)
			FifoData[i] <= 0;
	end
	else
	begin
		if(SyncReset)
		begin
			Full       <= 1'b0;
			ReadIndex  <= 0;
			WriteIndex <= 0;
			for(i = 0; i <= {(FIFO_DEPTH){1'b1}}; i = i + 1)
				FifoData[i] <= 0;
		end
		else
		begin
			if(DoRead)
			begin
				ReadIndex <= nextReadIndex;
				Full      <= 1'b0;
			end

			if(DoWrite)
			begin
				FifoData[WriteIndex] <= WriteData;
				WriteIndex           <= nextWriteIndex;
			end

			if(DoWrite && !DoRead && (nextWriteIndex == ReadIndex))
				Full <= 1'b1;
		end
	end
end

assign Empty     = (!Full) && (ReadIndex == WriteIndex);
assign FillLevel = WriteIndex-ReadIndex;
assign Afford2Write = (!Full) && (!(&(FillLevel[FIFO_DEPTH-1:1])));
assign Afford2Read  = (Full) || (|(FillLevel[FIFO_DEPTH-1:1]));

assign ReadData = FifoData[ReadIndex];

endmodule
