// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : RSNAND_DMAregif.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : RSNAND_DMA Register Inferface
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module RSNAND_DMA_regif
(	
	CLK,
	RESETn,

	CS,
	EXT_SFR_DIN, 
	EXT_SFR_DOUT, 
	EXT_SFR_ADDR, 
	EXT_SFR_WR,
	
	Start,
	Size,
	Mode,
	Bypass,
	SplitSize,
	StartAddr

);

input			CLK;
input			RESETn;

input			CS;
output	[7:0]	EXT_SFR_DIN;
input 	[7:0]	EXT_SFR_DOUT;
input 	[2:0]	EXT_SFR_ADDR;
input		EXT_SFR_WR;

output		Start;
output		[10:0]	Size;
output		Mode;
output		Bypass;
output		[3:0]	SplitSize;
output		[10:0]	StartAddr;

reg	[7:0]	EXT_SFR_DIN;
reg		Start;
reg		[7:0]	Size_L;
reg		[2:0]	Size_H;
reg		Mode;
reg		Bypass;
reg		[3:0]	SplitSize;
reg		[7:0]	StartAddr_L;
reg		[2:0]	StartAddr_H;
wire	[10:0]	Size;
wire	[10:0]	StartAddr;

wire	DMA_CTRL_REG_W = (CS)& (EXT_SFR_WR)& (EXT_SFR_ADDR==3'b000);
wire	DMA_SIZE_L_W = (CS)& (EXT_SFR_WR)& (EXT_SFR_ADDR==3'b001);
wire	DMA_SIZE_H_W = (CS)& (EXT_SFR_WR)& (EXT_SFR_ADDR==3'b010);
wire	DMA_ST_ADDR_L_W = (CS)& (EXT_SFR_WR)& (EXT_SFR_ADDR==3'b011);
wire	DMA_ST_ADDR_H_W = (CS)& (EXT_SFR_WR)& (EXT_SFR_ADDR==3'b100);

wire	DMA_CTRL_REG_R = 	(EXT_SFR_ADDR==3'b000);
wire	DMA_SIZE_L_R = 		(EXT_SFR_ADDR==3'b001);
wire	DMA_SIZE_H_R = 		(EXT_SFR_ADDR==3'b010);
wire	DMA_ST_ADDR_L_R = 	(EXT_SFR_ADDR==3'b011);
wire	DMA_ST_ADDR_H_R = 	(EXT_SFR_ADDR==3'b100);

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	Start <= 0;
	else if (DMA_CTRL_REG_W)
	Start <= EXT_SFR_DOUT[0];
	else
	Start <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	begin
	Mode <= 0;
	Bypass <= 0;
	SplitSize <= 0;
	end
	else if (DMA_CTRL_REG_W)
	begin
	Mode <= EXT_SFR_DOUT[1];
	Bypass <= EXT_SFR_DOUT[2];
	SplitSize <= EXT_SFR_DOUT[7:4];
	end
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	Size_L <=0;
	else if (DMA_SIZE_L_W)
	Size_L <= EXT_SFR_DOUT[7:0];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	Size_H <=0;
	else if (DMA_SIZE_H_W)
	Size_H <= EXT_SFR_DOUT[7:0];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	StartAddr_L <=0;
	else if (DMA_ST_ADDR_L_W)
	StartAddr_L <= EXT_SFR_DOUT[7:0];
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	StartAddr_H <=0;
	else if (DMA_ST_ADDR_H_W)
	StartAddr_H <= EXT_SFR_DOUT[2:0];
end

assign	Size = { Size_H,Size_L};
assign	StartAddr= {StartAddr_H, StartAddr_L};

always @(DMA_CTRL_REG_R or DMA_SIZE_L_R or DMA_SIZE_H_R or 
DMA_ST_ADDR_L_R or DMA_ST_ADDR_L_R or DMA_ST_ADDR_H_R or 
SplitSize or Bypass or Mode or Size_L or Size_H or StartAddr_L or StartAddr_H)
begin
	case (1'b1)
	DMA_CTRL_REG_R	:EXT_SFR_DIN = {SplitSize,1'b0,Bypass,Mode,1'b0};
	DMA_SIZE_L_R 	:EXT_SFR_DIN = Size_L;
	DMA_SIZE_H_R 	:EXT_SFR_DIN = {6'd0,Size_H};
	DMA_ST_ADDR_L_R :EXT_SFR_DIN = StartAddr_L;
	DMA_ST_ADDR_H_R :EXT_SFR_DIN = {6'd0,StartAddr_H};
	default : EXT_SFR_DIN =	8'b00000000;
	endcase
end

endmodule

