// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DMAPeri.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : Test peripheral for DMA test
//  =============================================================================

`timescale 1ns/1ps

module DMAPeri
(
		// APB signals
		PCLK     , 	// APB Clock
		PRESETn  ,  // APB Reset
		PADDR    ,  // APB Address
		PWRITE   ,  // APB Write/Read
		PSEL     ,  // APB Select
		PENABLE  ,  // APB Enable
		PRDATA   ,  // APB Read Data
		PWDATA   ,  // APB Write Data

		// DMA signal
		DMA_REQ  ,  // Active High DMA Request
		DMA_ACK     // Active High DMA Acknoledge(not used)
);

// STREAM sink or source
// STREAM_SINK == 1 : DMA should transfer data from memory to peri.
// STREAM_SINK == 0 : DMA should transfer data from peri to memory.
parameter STREAM_SINK = 1;

// Processing data size : support Word Only currently.
`define WORD  2'b10
`define HWORD 2'b01
`define BYTE  2'b00
parameter DATA_SIZE = `WORD;

parameter LAST_DATA = 32'd1023;	// Test Data : 0~1023
// Data Clock rate compared with PCLK
parameter CLK_DIV = 128;

// FIFO Depth
parameter FIFO_INDEX_WIDTH = 5;
parameter FIFO_LEN = (1 << FIFO_INDEX_WIDTH);

input  PCLK;
input  PRESETn;
input  PADDR;
input  PWRITE;
input  PSEL;
input  PENABLE;
output [31:0] PRDATA;
input  [31:0] PWDATA;

output DMA_REQ;
input  DMA_ACK;

///////////////////////////////////////////////////////////////
// FIFO : implemented with Ring Buffer
///////////////////////////////////////////////////////////////
// Usage: You can read fifo data from FifoReadData
//        unless FifoEmpty is high.
//        You can flush read data with set FifoReadEnable to 1.
//        You can write data into fifo
//        with FifoWriteData/FifoWriteEnable
//        Fifo doesn't check fullness to your write request.
//        With FifoReset, You can reset fifo status.

reg [FIFO_INDEX_WIDTH-1:0] FifoReadIndex;	// fifo internal
reg [FIFO_INDEX_WIDTH-1:0] FifoWriteIndex;	// fifo internal
reg [31:0] Fifo[FIFO_LEN-1:0];				// fifo internal
wire [31:0] FifoReadData;					// output from fifo
wire FifoEmpty;				// output from fifo
reg  FifoFull;				// output form fifo
wire FifoReadEnable;		// input to fifo
wire FifoWriteEnable;		// input to fifo
wire FifoReset;				// input to fifo
wire [31:0] FifoWriteData;	// input to fifo
wire [FIFO_INDEX_WIDTH-1:0] FifoSpaceRemained;
wire FifoIsHalfFull;

assign FifoEmpty         = (FifoReadIndex == FifoWriteIndex) ? (!FifoFull) : 1'b0;
assign FifoReadData      = Fifo[FifoReadIndex];
assign FifoSpaceRemained = (FifoFull) ? 0 : (FifoReadIndex-FifoWriteIndex)-1'b1;
assign FifoIsHalfFull    = (FifoSpaceRemained <= (FIFO_LEN>>1)) ? 1'b1 : 1'b0;
assign FifoIsHalfEmpty   = (FifoSpaceRemained >= (FIFO_LEN>>1)) ? 1'b1 : 1'b0;

always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		FifoReadIndex  <= 0;
		FifoWriteIndex <= 0;
		FifoFull <= 0;
	end
	else
	begin
		if(FifoReset == 1'b1)
		begin
			FifoReadIndex <= 0;
			FifoWriteIndex <= 0;
			FifoFull <= 0;
		end
		else
		begin
			if(FifoReadIndex == (FifoWriteIndex+1'b1) && FifoWriteEnable == 1'b1 &&FifoReadEnable != 1'b1)
				FifoFull <= 1;
			else if(FifoReadEnable == 1'b1)
				FifoFull <= 0;

			if(FifoReadEnable == 1'b1)
				FifoReadIndex <= FifoReadIndex + 1'b1;

			if(FifoWriteEnable == 1'b1)
			begin
				Fifo[FifoWriteIndex] <= FifoWriteData;
				FifoWriteIndex <= FifoWriteIndex + 1'b1;
			end
		end
	end
end

///////////////////////////////////////////////////////
// APB interface
///////////////////////////////////////////////////////
wire APB_WriteEnable;
wire APB_WriteControlRegEnable;
wire APB_WriteFifoEnable;
wire APB_ReadEnable;
wire APB_ReadControlRegEnable;
wire APB_ReadFifoEnable;

assign APB_WriteEnable = PSEL & (~PENABLE) & PWRITE;
assign APB_WriteControlRegEnable = APB_WriteEnable & (PADDR == 1'b0);
assign APB_WriteFifoEnable = APB_WriteEnable & (PADDR == 1'b1);

assign APB_ReadEnable  = PSEL & (~PENABLE) & (~PWRITE);
assign APB_ReadControlRegEnable  = APB_ReadEnable & (PADDR == 1'b0);
assign APB_ReadFifoEnable        = APB_ReadEnable & (PADDR == 1'b1);

reg [31:0] ControlRegister;
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
		ControlRegister <= 0;
	else
	begin
		if(APB_WriteControlRegEnable == 1'b1)
			ControlRegister <= PWDATA;
	end
end

reg [31:0] PRDATA;
// Data Read
always @(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		PRDATA <= 0;
	end
	else
	begin
		if(APB_ReadFifoEnable == 1'b1)
			PRDATA <= FifoReadData;
		else if(APB_ReadControlRegEnable == 1'b1)
			PRDATA <= ControlRegister;
	end
end

wire OperationEnable;
assign OperationEnable = ControlRegister[0];

reg RandomBit;
always @(posedge PCLK) RandomBit <= $random/32;

// clock divider
integer clk_div_counter;
wire DataClkEn;
always @(posedge PCLK)
begin
	if((!OperationEnable) || clk_div_counter == 0)
		clk_div_counter <= CLK_DIV-1;
	else
		clk_div_counter <= clk_div_counter-1;
end
assign DataClkEn = (clk_div_counter == 0) ? 1'b1 : 1'b0;

// Reference Data Generator
wire NextDataRead;
wire NextDataWrite;
reg [1:0] SubWordState;
always @(posedge PCLK)
begin
	if(!OperationEnable)
	begin
		if(DATA_SIZE == `WORD)
			SubWordState <= 0;
		else if(DATA_SIZE == `HWORD)
			SubWordState <= 1;
		else // `BYTE
			SubWordState <= 3;
	end
	else if(NextDataRead || NextDataWrite)
	begin
		if(SubWordState == 0)
		begin
			if(DATA_SIZE == `WORD)
				SubWordState <= 0;
			else if(DATA_SIZE == `HWORD)
				SubWordState <= 1;
			else // `BYTE
				SubWordState <= 3;
		end
		else
			SubWordState <= SubWordState - 1'b1;
	end
end

reg [31:0] DataMask;
initial
begin
	if(DATA_SIZE == `WORD)
		DataMask = 32'hffffffff;
	else if(DATA_SIZE == `HWORD)
		DataMask = 32'h0000ffff;
	else // BYTE
		DataMask = 32'h000000ff;
end

reg [31:0] ReferenceData;
reg [31:0] RefReferenceData;
always @(posedge PCLK)
begin
	if(!OperationEnable)
	begin
		ReferenceData <= 0;
		RefReferenceData <= 0;
	end
	else if(NextDataRead || NextDataWrite)
	begin
		if(SubWordState == 0)
		begin
			if(RefReferenceData == LAST_DATA)
			begin
				ReferenceData <= 0;
				RefReferenceData <= 0;
			end
			else
			begin
				ReferenceData <= RefReferenceData + 1'b1;
				RefReferenceData <= RefReferenceData + 1'b1;
			end
		end
		else
		begin
			if(DATA_SIZE == `HWORD)
				ReferenceData <= ReferenceData >> 16;
			else	// BYTE
				ReferenceData <= ReferenceData >> 8;
		end
	end
end

assign NextDataRead = STREAM_SINK && OperationEnable && RandomBit && DataClkEn&& FifoEmpty == 1'b0;
assign FifoReadEnable = NextDataRead | APB_ReadFifoEnable;

// Test Data 
always @(posedge PCLK)
begin
	if(NextDataRead)
	begin
		if((FifoReadData & DataMask) !== (ReferenceData & DataMask))
		begin
			$display("Error !!!!!");
			$stop;
		end
	end
end

assign NextDataWrite   = STREAM_SINK == 0 && RandomBit && DataClkEn && FifoFull == 1'b0;
assign FifoWriteEnable = NextDataWrite  | APB_WriteFifoEnable;
assign FifoWriteData   = (APB_WriteFifoEnable) ? PWDATA : ReferenceData;

assign FifoReset = !OperationEnable;

assign DMA_REQ = (~DMA_ACK) & OperationEnable & ((STREAM_SINK == 1) ? FifoIsHalfEmpty : FifoIsHalfFull);
endmodule
