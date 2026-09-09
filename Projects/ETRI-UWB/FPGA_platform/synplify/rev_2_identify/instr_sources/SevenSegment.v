// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : SevenSegment.v
// File Revision       : 1.0
//  ----------------------------------------------------------------------------
//  Purpose            : 4 Seven Segment Control
//  --========================================================================--

`timescale 1ns/1ps
`define NEGATIVE 1
module SevenSegment (
	Clock,
	nReset,
	
	DataIn,
	DotIn,
	ControlOut,
	CommonOut
);

input         Clock;
input         nReset;

input  [15:0] DataIn;
input  [3:0]  DotIn;
output [7:0]  ControlOut;	// A(LSB), B, C, D, E, F, G, DP order
output [3:0]  CommonOut;		// COM0(LSB), COM1, COM2, COM3

wire   [31:0] Data;
SevenSegmentCode bit0_3(
		.DataIn(DataIn[3:0]),
		.DataOut(Data[7:0])
);

SevenSegmentCode bit4_7(
		.DataIn(DataIn[7:4]),
		.DataOut(Data[15:8])
);

SevenSegmentCode bit11_8(
		.DataIn(DataIn[11:8]),
		.DataOut(Data[23:16])
);

SevenSegmentCode bit15_12(
		.DataIn(DataIn[15:12]),
		.DataOut(Data[31:24])
);

reg    [31:0] Data_temp;
always @(posedge Clock)	Data_temp <= Data;

reg    [31:0] Data_reg;
always @(posedge Clock)	Data_reg <= Data_temp;

reg    [7:0] ControlOut_Temp;
reg    [3:0] CommonOut_Temp;

always @(posedge Clock or negedge nReset)
begin
	if(!nReset)
	begin
		ControlOut_Temp <= 8'b00001011;	// should be "h. X X X"
		CommonOut_Temp  <= 4'b0001;
	end
	else
	begin
		case(1'b1)	// synopsys parallel_case full_case
		CommonOut_Temp[0]:
			begin
//				ControlOut_Temp <= Data_reg[15:8];
				ControlOut_Temp <= {DotIn[1], Data_reg[14:8]};
				CommonOut_Temp  <= 4'b0010;
			end
		CommonOut_Temp[1]:
			begin
//				ControlOut_Temp <= Data_reg[23:16];
				ControlOut_Temp <= {DotIn[2], Data_reg[22:16]};
				CommonOut_Temp  <= 4'b0100;
			end
		CommonOut_Temp[2]:
			begin
//				ControlOut_Temp <= Data_reg[31:24];
				ControlOut_Temp <= {DotIn[3], Data_reg[30:24]};
				CommonOut_Temp  <= 4'b1000;
			end
		CommonOut_Temp[3]:
			begin
//				ControlOut_Temp <= Data_reg[7:0];
				ControlOut_Temp <= {DotIn[0], Data_reg[6:0]};
				CommonOut_Temp  <= 4'b0001;
			end
		endcase
	end
end

`ifdef NEGATIVE
assign ControlOut = ~ControlOut_Temp;
assign CommonOut  = ~CommonOut_Temp;
`else
assign ControlOut = ControlOut_Temp;
assign CommonOut  = CommonOut_Temp;
`endif
endmodule

module SevenSegmentCode (
	DataIn,
	DataOut
);

input  [3:0] DataIn;
output [7:0] DataOut;

reg    [7:0] DataOut_temp;
always @(DataIn)
begin
	case(DataIn)
	4'b0000: DataOut_temp = 8'b11000000;
	4'b0001: DataOut_temp = 8'b11111001;
	4'b0010: DataOut_temp = 8'b10100100;
	4'b0011: DataOut_temp = 8'b10110000;
	4'b0100: DataOut_temp = 8'b10011001;
	4'b0101: DataOut_temp = 8'b10010010;
	4'b0110: DataOut_temp = 8'b10000010;
	4'b0111: DataOut_temp = 8'b11111000;
	4'b1000: DataOut_temp = 8'b10000000;
	4'b1001: DataOut_temp = 8'b10011000;
	4'b1010: DataOut_temp = 8'b10001000;
	4'b1011: DataOut_temp = 8'b10000011;
	4'b1100: DataOut_temp = 8'b11000110;
	4'b1101: DataOut_temp = 8'b10100001;
	4'b1110: DataOut_temp = 8'b10000110;
	4'b1111: DataOut_temp = 8'b10001110;
	endcase
end 
assign DataOut = DataOut_temp;
endmodule
