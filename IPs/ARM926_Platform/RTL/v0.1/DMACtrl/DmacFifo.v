// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : DmacFifo.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : This module is a part of AXI DMA Controller
//                     : Fifo & pack/unpack routine
//                     : Only support little endian.
// ==============================================================================


// ==============================================================================
// Theory of Operation
// ==============================================================================
//
// This module is a part of AXI DMA Controller
// This module has Fifo which can store chunk(a burst) of data.
//
// This module has no ARESETn port.
// You must set FifoReset high at least for a clock before using this module.
//
// SrcAddr/DstAddr/NumByte are latched only when FifoReset is high.
//
// SrcWidth/DstWidth must not be changed during usage of this module.
//
// SrcWidth/DstWidth has the following encoding.
//   When 2'b00, it means BYTE.
//   When 2'b01, it means HalfWord.
//   When 2'b10, it means Word.
//   The value, 2'b11, is reserved.
//
// SrcAddr/DstAddr are required for alignment adjustment.
//
// NumByte is the number of bytes which you want to store in the FIFO.
// NumByte=0 means 1 byte.
//
// You can use this module as following sequence.
// (a) FifoReset high
// (b) FifoReset low & Write data(WriteEn, DataIn)
// (c) When you finished writing, You can read data from DataOut & DataMask.
// (d) When you want to get another data, set ReadEn high.
// Once you set ReadEn high, Don't write any more data into Fifo before resetting Fifo.
//
// DataMask indicate which byte lane is valid.
// You can use DataMask signal for WSTRB in AXI with apropriate shift & mask.
//
// SrcWidth/DstWidth is BYTE, Use only DataIn[7:0]/DataOut[7:0]/DataMask[0]. 
// SrcWidth/DstWidth is HWORD, Use only DataIn[15:0]/DataOut[15:0]/DataMask[1:0]. 
// SrcWidth/DstWidth is WORD, Use only DataIn[31:0]/DataOut[3115:0]/DataMask[3:0]. 
//
// You can give different width at Source and Destintaion.
// All the alignment adjustment is done in this module.
//
// When DstAddr is not aligned with DstWidth,
// You must connect destination port which support Write Byte Lane.
// Otherwise, data is written at consecutive address.
//

`timescale 1ns/1ps

module DmacFifo 
(
		//	CLK
		ACLK     , 

		// Synchronous Reset
		FifoReset,
		NumByte,

		// Write Interface
		SrcWidth ,
		DataIn   ,
		WriteEn  ,
		SrcAddr  ,

		// Read Interface
		DstWidth ,
		DataOut  ,
		DataMask ,
		ReadEn   ,
		DstAddr
);

parameter FIFO_INDEX_WIDTH=3;	// FIFO_DEPTH = 2^(FIFO_INDEX_WIDTH)

//
// input/output port
//
input  ACLK;

input  FifoReset;			// active high soft reset
input  [FIFO_INDEX_WIDTH+2-1:0] NumByte;			// Number of Byte

input  [1:0]  SrcWidth;		// width of data
input  [31:0] DataIn;		// write data
input         WriteEn;		// active high write enable
input  [1:0]  SrcAddr;      // Lower 2 bit of source address : DO NOT UPDATE until whole fifo gets empty

input  [1:0]  DstWidth;		// width of data
output [31:0] DataOut;		// read data
output [3:0]  DataMask;		// data mask for read data : you can use it as WSTRB in AXI.
input         ReadEn;		// active high read enable(not actually read enable : read data is available on DataOut already. when this signal gets high, address of fifo update. 
input  [1:0]  DstAddr;		// Lower 2 bit of destination address	: DO NOT UPDATE until whole fifo gets empty.

parameter FIFO_DEPTH={FIFO_INDEX_WIDTH{1'b1}}+1;	// FIFO_DEPTH = 2^(FIFO_INDEX_WIDTH)
reg [31:0] FifoData[FIFO_DEPTH-1:0];	// Total 16 x 32bit data

reg [FIFO_INDEX_WIDTH-1:0] WriteIndex;
reg [1:0] WriteSubIndex;
reg [FIFO_INDEX_WIDTH-1:0] ReadIndex;
reg [1:0] ReadSubIndex;

reg [1:0] DstAddrInt;
reg [1:0] SrcAddrInt;

// Latch SrcAddr/DstAddr
always @(posedge ACLK)
begin
	if(FifoReset)
	begin
		DstAddrInt <= DstAddr;
		SrcAddrInt <= SrcAddr;
	end
end

//
// Source Packing
// Current data is written next cycle with next data.
//
reg [31:0] WriteData;
reg [3:0]  WriteMask;
reg [31:0] NextRemData;
reg [3:0]  NextWMask;

always @(SrcWidth or SrcAddrInt or DataIn or WriteSubIndex)
begin
	case(SrcWidth)
	2'b10: // WORD
	begin
		case(SrcAddrInt)
		2'b00: // WORD aligned
		begin
			WriteData = 32'hxxxxxxxx;
			WriteMask = 4'b1111;
			NextRemData = DataIn;
			NextWMask = 4'b0000;
		end
		2'b01: // 3 byte write & 1 byte remain
		begin
			WriteData = {DataIn[7:0], 24'hxxxxxx};
			WriteMask = 4'b0111;
			NextRemData = {8'hxx, DataIn[31:8]};
			NextWMask = 4'b1000;
		end
		2'b10: // 2 byte write & 2 byte remain
		begin
			WriteData = {DataIn[15:0], 16'hxxxx};
			WriteMask = 4'b0011;
			NextRemData = {16'hxxxx, DataIn[31:16]};
			NextWMask = 4'b1100;
		end
		2'b11: // 1 byte write & 3 byte remain
		begin
			WriteData = {DataIn[23:0], 8'hxx};
			WriteMask = 4'b0001;
			NextRemData = {24'hxxxxxx, DataIn[31:24]};
			NextWMask = 4'b1110;
		end
		endcase
	end
	2'b01:	// HWORD
	begin
		if(SrcAddrInt[0] == 0)
		begin
			if(WriteSubIndex[0] == 0)
			begin
				NextRemData = {16'h0000, DataIn[15:0]};
				NextWMask = 4'b1100;
			end
			else
			begin
				NextRemData = {DataIn[15:0], 16'h0000};
				NextWMask = 4'b0011;
			end
			WriteData = 32'hxxxxxxxx;
			WriteMask = 4'b1111;
		end
		else
		begin
			if(WriteSubIndex[0] == 0)
			begin
				WriteData = {DataIn[7:0], 16'hxxxx, 8'hxx};
				WriteMask = 4'b0111;
				NextRemData = {16'hxxxx, 8'hxx, DataIn[15:8]};
				NextWMask = 4'b1110;
			end
			else
			begin
				WriteData = {8'hxx, DataIn[15:0], 8'hxx};
				WriteMask = 4'b1001;
				NextRemData = {8'hxx, 8'hxx, 16'hxxxx};
				NextWMask = 4'b1111;
			end
		end
	end
	2'b00: // BYTE
	begin
		WriteData = 32'hxxxxxxxx;
		WriteMask = 4'b1111;
		case(WriteSubIndex)
		2'b00:
		begin
			NextRemData = {24'hxxxxxx, DataIn[7:0]};
			NextWMask = 4'b1110;
		end
		2'b01:
		begin
			NextRemData = {16'hxxxx, DataIn[7:0], 8'hxx};
			NextWMask = 4'b1101;
		end
		2'b10:
		begin
			NextRemData = {8'hxx, DataIn[7:0], 16'hxxxx};
			NextWMask = 4'b1011;
		end
		2'b11:
		begin
			NextRemData = {DataIn[7:0], 24'hxxxxxx};
			NextWMask = 4'b0111;
		end
		endcase
	end
	default:
	begin
		WriteData = 32'hxxxxxxxx;
		WriteMask = 4'b1111;
		NextRemData = 32'hxxxxxxxx;
		NextWMask = 4'b1111;
	end
	endcase
end

reg FirstWriteCycle;			// First Write Cycle Detector
always @(posedge ACLK)
begin
	if(FifoReset)
		FirstWriteCycle <= 1;
	else if(WriteEn)
		FirstWriteCycle <= 0;
end

reg PrevWriteEn;
always @(posedge ACLK)
begin
	if(FifoReset)
		PrevWriteEn <= 0;
	else if(WriteEn)
		PrevWriteEn <= 1;
	else
		PrevWriteEn <= 0;
end

reg  [31:0] RemData;
reg  [ 3:0] RemMask;
always @(posedge ACLK)
begin
	if(WriteEn)
	begin
		RemData <= NextRemData;
		RemMask <= NextWMask;
	end
	else
		RemMask <= 4'b1111;
end

always @(posedge ACLK)
begin
	if(FifoReset)
		WriteSubIndex <= 2'b00;
	else if(WriteEn)
		WriteSubIndex <= WriteSubIndex + 1'b1;
end

reg LastWrite;
always @(posedge ACLK)
begin
	if(FifoReset)
	begin
		WriteIndex <= 0;
		LastWrite <= 0;
	end
	else if(WriteEn & (~FirstWriteCycle))
	begin
		if(SrcWidth == 2'b10)	// WORD
		begin
			if(WriteIndex == FIFO_DEPTH-1)
				LastWrite <= 1;
			WriteIndex <= WriteIndex + 1'b1;
		end
		else if(SrcWidth == 2'b01) // HWORD
		begin
			if(WriteSubIndex[0] == 0)
			begin
				WriteIndex <= WriteIndex + 1'b1;
				if(WriteIndex == FIFO_DEPTH-1)
					LastWrite <= 1;
			end
		end
		else	// BYTE
		begin
			if(WriteSubIndex == 2'b00)
			begin
				WriteIndex <= WriteIndex + 1'b1;
				if(WriteIndex == FIFO_DEPTH-1)
					LastWrite <= 1;
			end
		end
	end
end

wire [31:0] RemBitMask;
wire [31:0] WriteBitMask;
wire [31:0] FifoWriteData;
wire [31:0] FifoWriteMask;

assign RemBitMask = {{8{RemMask[3]}}, {8{RemMask[2]}}, {8{RemMask[1]}}, {8{RemMask[0]}}};
assign WriteBitMask = (WriteEn == 1) ? {{8{WriteMask[3]}}, {8{WriteMask[2]}}, {8{WriteMask[1]}}, {8{WriteMask[0]}}} : 32'hffffffff;

assign FifoWriteData = (RemData & (~RemBitMask)) | (WriteData & (~WriteBitMask));
assign FifoWriteMask = RemBitMask & WriteBitMask;

// Real Fifo Write
always @(posedge ACLK)
begin
	if(((WriteEn & (~FirstWriteCycle)) | PrevWriteEn) & (~LastWrite))
		FifoData[WriteIndex] <= (FifoData[WriteIndex] & FifoWriteMask) | (FifoWriteData & (~FifoWriteMask));
end

reg FirstReadCycle;
reg [FIFO_INDEX_WIDTH+2-1:0] NumberOfByteInFifo;
reg [FIFO_INDEX_WIDTH+2-1:0] NextNumberOfByteInFifo;
function [2:0] WidthToSize;
	input [1:0] Width;
	case(Width)
	2'b10: WidthToSize = 3'b100;	// WORD
	2'b01: WidthToSize = 3'b010;	// HWORD
	default : WidthToSize = 3'b001;	// BYTE
	endcase
endfunction

always @(FifoReset or WriteEn or SrcWidth or ReadEn or FirstReadCycle or DstWidth or DstAddrInt or NumberOfByteInFifo or NumByte)
begin
	if(FifoReset)
		NextNumberOfByteInFifo = NumByte;
	else
	begin
		// We don't consider when both WriteEn & ReadEn are high.
//		if(WriteEn == 1'b1)
//			NextNumberOfByteInFifo = NumberOfByteInFifo + WidthToSize(SrcWidth);
//		else if(ReadEn == 1'b1)
		if(ReadEn == 1'b1)
		begin
			if(FirstReadCycle == 1'b1)
			begin
				if(DstWidth == 2'b10)	// WORD
				begin
					case(DstAddrInt[1:0])
					2'b00: NextNumberOfByteInFifo = NumberOfByteInFifo - 4;
					2'b01: NextNumberOfByteInFifo = NumberOfByteInFifo - 3;
					2'b10: NextNumberOfByteInFifo = NumberOfByteInFifo - 2;
					2'b11: NextNumberOfByteInFifo = NumberOfByteInFifo - 1;
					endcase
				end
				else if(DstWidth == 2'b01) // HWORD
				begin
					if(DstAddrInt[0] == 0)
						NextNumberOfByteInFifo = NumberOfByteInFifo - 2;
					else
						NextNumberOfByteInFifo = NumberOfByteInFifo - 1;
				end
				else // BYTE
					NextNumberOfByteInFifo = NumberOfByteInFifo - 1;
			end
			else
				NextNumberOfByteInFifo = NumberOfByteInFifo - WidthToSize(DstWidth);
		end
		else
			NextNumberOfByteInFifo = NumberOfByteInFifo;
	end
end

always @(posedge ACLK) NumberOfByteInFifo <= NextNumberOfByteInFifo;

wire [31:0] ReadData;
assign ReadData = FifoData[ReadIndex];

reg  [31:0] PrevReadData;
always @(posedge ACLK)
begin
	if(ReadEn) PrevReadData <= ReadData;
end

reg [3:0]  DataOutMaskTemp;
always @(NumberOfByteInFifo)
begin
	if(|NumberOfByteInFifo[FIFO_INDEX_WIDTH+2-1:2])	// NumberOfByteInFifo > 4
		DataOutMaskTemp = 4'b1111;
	else
	begin
		case(NumberOfByteInFifo[1:0])
		2'b00: DataOutMaskTemp = 4'b0001;	// 1 byte remains
		2'b01: DataOutMaskTemp = 4'b0011;	// 2 byte remains
		2'b10: DataOutMaskTemp = 4'b0111;	// 3 byte remains
		2'b11: DataOutMaskTemp = 4'b1111;	// 4 byte remains
		endcase
	end
end

always @(posedge ACLK)
begin
	if(FifoReset)
		FirstReadCycle <= 1;
	else if(ReadEn)
		FirstReadCycle <= 0;
end

reg [31:0] DataOutTemp;
reg [3:0]  DataOutMask;
always @(DstWidth or DstAddrInt or ReadData or PrevReadData or ReadSubIndex or FirstReadCycle or DataOutMaskTemp or NumberOfByteInFifo)
begin
	case(DstWidth)
	2'b00: // BYTE
	begin
		DataOutMask = 4'b0001;
		case(ReadSubIndex)
		2'b00: DataOutTemp = {24'hxxxxxx, ReadData[7:0]};
		2'b01: DataOutTemp = {24'hxxxxxx, ReadData[15:8]};
		2'b10: DataOutTemp = {24'hxxxxxx, ReadData[23:16]};
		2'b11: DataOutTemp = {24'hxxxxxx, ReadData[31:24]};
		endcase
	end
	2'b01: // HWORD
	begin
		// Consider First Read Cycle
		if(FirstReadCycle == 1 && DstAddrInt[0] == 1)
			DataOutMask = 4'b0010;
		else if(NumberOfByteInFifo == 0)
			DataOutMask = 4'b0001;
		else
			DataOutMask = 4'b0011;

		if(DstAddrInt[0] == 0)
		begin
			if(ReadSubIndex[0] == 0)
				DataOutTemp = {16'hxxxx, ReadData[15:0]};
			else
				DataOutTemp = {16'hxxxx, ReadData[31:16]};
		end
		else 
		begin
			if(ReadSubIndex[0] == 0)
				DataOutTemp = {16'hxxxx, ReadData[7:0], PrevReadData[31:24]};
			else
				DataOutTemp = {16'hxxxx, ReadData[23:8]};
		end
	end
	2'b10: // WORD
	begin
		if(FirstReadCycle == 1)
		begin
			case(DstAddrInt[1:0])
			2'b00: DataOutMask = DataOutMaskTemp;
			2'b01: DataOutMask = {DataOutMaskTemp[2:0], 1'b0};
			2'b10: DataOutMask = {DataOutMaskTemp[1:0], 2'b00};
			2'b11: DataOutMask = {DataOutMaskTemp[0], 3'b000};
			endcase
		end
		else
		begin
			DataOutMask = DataOutMaskTemp;
		end

		case(DstAddrInt[1:0])
		2'b00: DataOutTemp = ReadData;
		2'b01: DataOutTemp = {ReadData[23:0], PrevReadData[31:24]};
		2'b10: DataOutTemp = {ReadData[15:0], PrevReadData[31:16]};
		2'b11: DataOutTemp = {ReadData[7:0],  PrevReadData[31:8]};
		endcase
	end
	default:
	begin
		DataOutMask = 4'b0000;
		DataOutTemp = 32'hxxxxxxxx;
	end
	endcase
end

assign DataOut = DataOutTemp;
assign DataMask = DataOutMask;

always @(posedge ACLK)
begin
	if(FifoReset)
		ReadSubIndex <= 2'b00;
	else if(ReadEn)
		ReadSubIndex <= ReadSubIndex + 1'b1;
end

always @(posedge ACLK)
begin
	if(FifoReset)
		ReadIndex <= 0;
	else if(ReadEn)
	begin
		if(DstWidth == 2'b10)	// WORD
			ReadIndex <= ReadIndex + 1'b1;
		else if(DstWidth == 2'b01) // HWORD
		begin
			if(ReadSubIndex[0] == 1)
				ReadIndex <= ReadIndex + 1'b1;
		end
		else	// BYTE
		begin
			if(ReadSubIndex == 2'b11)
				ReadIndex <= ReadIndex + 1'b1;
		end
	end
end

endmodule
