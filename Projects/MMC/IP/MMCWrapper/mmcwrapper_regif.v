// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : mmcwrapper_regif.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : mmc wrapper register interface
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

module mmcwrapper_regif(
	RESETn,
	CLK,
	CS,
	EXT_SFR_ADDR,
	EXT_SFR_DOUT,
	EXT_SFR_WR,
	EXT_SFR_DIN,
	
	int_clr,
	addr,
	size,
	NORMAL_READ,
	NORMAL_WRITE,
	SDREG_READ,
	ERA_ST_ADDR, 	
	ERA_END_ADDR,
	ERA_EXE,
	PROGRAMMING,
	SET_WR_PROTECT,
	CLR_WR_PROTECT,
	ARG_FOR_WR_PROTECT,
	READ_WR_PROTECT,
	PRE_WRITE_ERASE_BLKCNT,
	CID_WRITE,
	FORCE_ERASE,
	PWD_LENGTH,
	CARD_PWD,
	SWITCH_FUNC_ARG,
	SWITCH_FUNC_STA,
	CID_PROG		,
	RW_SPECIAL_BLK	,
	rdata_regval0,
	rdata_regval1,
	rdata_regval2,
	rdata_regval3
);

input			RESETn;
input			CLK;
input			CS;
input	[7:0]	EXT_SFR_ADDR;
input	[7:0]	EXT_SFR_DOUT;
input			EXT_SFR_WR;
output	[7:0]	EXT_SFR_DIN;
output			int_clr;

input	[31:0]	addr;
input	[9:0]	size;
input			NORMAL_READ;
input			NORMAL_WRITE;
input			SDREG_READ;
input			ERA_ST_ADDR; 	
input			ERA_END_ADDR;
input			ERA_EXE;
input			PROGRAMMING;
input			SET_WR_PROTECT;
input			CLR_WR_PROTECT;
input			ARG_FOR_WR_PROTECT;
input			READ_WR_PROTECT;
input			PRE_WRITE_ERASE_BLKCNT;
input			CID_WRITE;
input			FORCE_ERASE;
input			PWD_LENGTH;
input			CARD_PWD;
input			SWITCH_FUNC_ARG;
input			SWITCH_FUNC_STA;
input			CID_PROG;		
input			RW_SPECIAL_BLK;
output	[7:0]	rdata_regval0;
output	[7:0]	rdata_regval1;
output	[7:0]	rdata_regval2;
output	[7:0]	rdata_regval3;

`define 	Fuction0_ADDR				4'h0
`define 	Fuction1_ADDR				4'h1
`define 	Fuction2_ADDR				4'h2

`define 	Addr31_24DDR				4'h3
`define 	Addr23_16_ADDR				4'h4
`define 	Addr15_8_ADDR				4'h5
`define 	Addr7_0_ADDR				4'h6

`define		Size_H_ADDR					4'h7
`define		Size_L_ADDR					4'h8

`define 	rdata_regval0_ADDR			4'h9
`define 	rdata_regval1_ADDR			4'hA
`define 	rdata_regval2_ADDR			4'hB
`define 	rdata_regval3_ADDR			4'hC

wire		Function0_r;
wire		Function1_r; 	
wire		Function2_r;	
wire		Addr31_24_r;
wire		Addr23_16_r;
wire		Addr15_8_r;
wire		Addr7_0_r;	
wire		Size_H_r;	
wire		Size_L_r;	
wire		rdata_regval0_r;
wire		rdata_regval1_r;
wire		rdata_regval2_r;
wire		rdata_regval3_r;
wire		rdata_regval0_w;
wire		rdata_regval1_w;
wire		rdata_regval2_w;
wire		rdata_regval3_w;

assign	Function0_r 	= (EXT_SFR_ADDR==`Fuction0_ADDR);
assign	Function1_r 	= (EXT_SFR_ADDR==`Fuction1_ADDR);
assign	Function2_r 	= (EXT_SFR_ADDR==`Fuction2_ADDR);


assign	Addr31_24_r 	= (EXT_SFR_ADDR==`Addr31_24DDR);
assign	Addr23_16_r 	= (EXT_SFR_ADDR==`Addr23_16_ADDR);
assign	Addr15_8_r	 	= (EXT_SFR_ADDR==`Addr15_8_ADDR); 
assign	Addr7_0_r 		= (EXT_SFR_ADDR==`Addr7_0_ADDR); 

assign 	Size_H_r		= (EXT_SFR_ADDR==`Size_H_ADDR); 
assign 	Size_L_r		= (EXT_SFR_ADDR==`Size_L_ADDR);

assign 	rdata_regval0_r	= (EXT_SFR_ADDR	== `rdata_regval0_ADDR);
assign 	rdata_regval1_r	= (EXT_SFR_ADDR	== `rdata_regval1_ADDR);
assign 	rdata_regval2_r	= (EXT_SFR_ADDR	== `rdata_regval2_ADDR);
assign 	rdata_regval3_r	= (EXT_SFR_ADDR	== `rdata_regval3_ADDR);

assign 	rdata_regval0_w	= (EXT_SFR_ADDR	== `rdata_regval0_ADDR)& (CS) & (EXT_SFR_WR);
assign 	rdata_regval1_w	= (EXT_SFR_ADDR	== `rdata_regval1_ADDR)& (CS) & (EXT_SFR_WR);
assign 	rdata_regval2_w	= (EXT_SFR_ADDR	== `rdata_regval2_ADDR)& (CS) & (EXT_SFR_WR);
assign 	rdata_regval3_w	= (EXT_SFR_ADDR	== `rdata_regval3_ADDR)& (CS) & (EXT_SFR_WR);


reg	[7:0]	EXT_SFR_DIN;
reg [7:0]	rdata_regval0;
reg	[7:0]	rdata_regval1;
reg	[7:0]	rdata_regval2;
reg	[7:0]	rdata_regval3;

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	rdata_regval0 <= 0;
	else if (rdata_regval0_w)
	rdata_regval0 <= EXT_SFR_DOUT;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	rdata_regval1 <= 0;
	else if (rdata_regval1_w)
	rdata_regval1 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	rdata_regval2 <= 0;
	else if (rdata_regval2_w)
	rdata_regval2 <= EXT_SFR_DOUT;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	rdata_regval3 <= 0;
	else if (rdata_regval3_w)
	rdata_regval3 <= EXT_SFR_DOUT;
end


always @(Function0_r or Function0_r or Function2_r or
Addr31_24_r or Addr23_16_r or Addr15_8_r or Addr7_0_r or addr or Size_H_r or Size_L_r or rdata_regval0_r or rdata_regval1_r or rdata_regval2_r or rdata_regval3_r)
begin
	case(1'b1)
	Function0_r	:EXT_SFR_DIN= {	1'b0,
								PROGRAMMING,
								ERA_EXE,
								ERA_END_ADDR,
								ERA_ST_ADDR, 	
								SDREG_READ,
								NORMAL_WRITE,
								NORMAL_READ};

	Function1_r	:EXT_SFR_DIN= {	PWD_LENGTH,
								FORCE_ERASE,
								CID_WRITE,
								PRE_WRITE_ERASE_BLKCNT,
								READ_WR_PROTECT,
								ARG_FOR_WR_PROTECT,
								CLR_WR_PROTECT,
								SET_WR_PROTECT};

	Function2_r	:EXT_SFR_DIN= {  3'b000,
								CARD_PWD,
								SWITCH_FUNC_ARG,
								SWITCH_FUNC_STA,
								CID_PROG,
								RW_SPECIAL_BLK};
	
	Addr31_24_r	:EXT_SFR_DIN= addr[31:24];

	Addr23_16_r :EXT_SFR_DIN= addr[23:16];

	Addr15_8_r	:EXT_SFR_DIN= addr[15:8];

	Addr7_0_r 	:EXT_SFR_DIN= addr[7:0];
	
	Size_H_r	:EXT_SFR_DIN ={6'b000000, size[9:8]};

	Size_L_r	:EXT_SFR_DIN = size[7:0];

	rdata_regval0_r :EXT_SFR_DIN = rdata_regval0;
	rdata_regval1_r :EXT_SFR_DIN = rdata_regval1;
	rdata_regval2_r :EXT_SFR_DIN = rdata_regval2;
	rdata_regval3_r :EXT_SFR_DIN = rdata_regval3;
	endcase
end

endmodule
