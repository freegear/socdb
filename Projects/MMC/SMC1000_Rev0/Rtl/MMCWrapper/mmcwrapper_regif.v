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
	EXT_SFR_DOUT,
	EXT_SFR_WR,
	EXT_SFR_DIN,
	
	si_newopb, // New Operation signal
	NewOpInt,
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
	rdata_regval3,
	SDDatCnt
);

input			RESETn;
input			CLK;
input	[14:0]	CS;
input	[7:0]	EXT_SFR_DOUT;
input			EXT_SFR_WR;
output	[7:0]	EXT_SFR_DIN;

input			si_newopb;
output			NewOpInt;
output			int_clr;

input	[40:0]	addr;
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
input	[11:0]	SDDatCnt;

wire		Function0_r;
wire		Function0_w;
wire		Function1_r; 	
wire		Function2_r;	
wire		Addr39_32_r;
wire		Addr31_24_r;
wire		Addr23_16_r;
wire		Addr15_8_r;
wire		Addr7_0_r;	
//wire		Size_H_r;	
wire		Size_L_r;	
wire		rdata_regval0_r;
wire		rdata_regval1_r;
wire		rdata_regval2_r;
wire		rdata_regval3_r;
wire		rdata_regval0_w;
wire		rdata_regval1_w;
wire		rdata_regval2_w;
wire		rdata_regval3_w;

assign	Function0_r 	= CS[0];
assign	Function0_w 	= CS[0] & (EXT_SFR_WR);
assign	Function1_r 	= CS[1];
assign	Function2_r 	= CS[2];


assign	Addr39_32_r 	= CS[3];
assign	Addr31_24_r 	= CS[4];
assign	Addr23_16_r 	= CS[5];
assign	Addr15_8_r	 	= CS[6];
assign	Addr7_0_r 		= CS[7];

assign 	Size_L_r		= CS[8];

assign 	rdata_regval0_r	= CS[9];
assign 	rdata_regval1_r	= CS[10];
assign 	rdata_regval2_r	= CS[11];
assign 	rdata_regval3_r	= CS[12];

assign 	rdata_regval0_w	= CS[9]  & (EXT_SFR_WR);
assign 	rdata_regval1_w	= CS[10] & (EXT_SFR_WR);
assign 	rdata_regval2_w	= CS[11] & (EXT_SFR_WR);
assign 	rdata_regval3_w	= CS[12] & (EXT_SFR_WR);

assign 	SDDatCnt0_r	= CS[13];
assign 	SDDatCnt1_r	= CS[14];

reg	[7:0]	EXT_SFR_DIN;
reg [7:0]	rdata_regval0;
reg	[7:0]	rdata_regval1;
reg	[7:0]	rdata_regval2;
reg	[7:0]	rdata_regval3;
//reg			newop_int_clr;
reg			NewOpInt;

assign int_clr = (Function0_w & EXT_SFR_DOUT[7]);
/*
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	newop_int_clr <= 0;
	else if (Function0_w)
	newop_int_clr <= EXT_SFR_DOUT[7];
	else 
	newop_int_clr <= 0;
end
*/
// for level interrupt 

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NewOpInt <= 0;
	else if (~si_newopb)
	NewOpInt <= 1;
//	else if (newop_int_clr)
	else if (Function0_w & EXT_SFR_DOUT[7])
	NewOpInt <= 0;
end

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


always @(	Function0_r or 
			Function1_r or 
			Function2_r or
			Addr39_32_r or 
			Addr31_24_r or 
			Addr23_16_r or 
			Addr15_8_r or 
			Addr7_0_r or 
			Size_L_r or 
			rdata_regval0_r or 
			rdata_regval1_r or
			rdata_regval2_r or 
			rdata_regval3_r or
			NewOpInt or
			PROGRAMMING or
			ERA_EXE or
			ERA_END_ADDR or
			ERA_ST_ADDR or 
			SDREG_READ or
			NORMAL_WRITE or
			NORMAL_READ or 
			PWD_LENGTH or
			FORCE_ERASE or
			CID_WRITE or
			PRE_WRITE_ERASE_BLKCNT or
			READ_WR_PROTECT or
			ARG_FOR_WR_PROTECT or
			CLR_WR_PROTECT or
			SET_WR_PROTECT or
			size or
			CARD_PWD or
			SWITCH_FUNC_ARG or
			SWITCH_FUNC_STA or
			CID_PROG or
			RW_SPECIAL_BLK or
			addr or
			rdata_regval0 or
			rdata_regval1 or
			rdata_regval2 or
			rdata_regval3 or 
			SDDatCnt0_r	or
			SDDatCnt1_r	or
			SDDatCnt
)
begin
	case(1'b1)
	Function0_r	:EXT_SFR_DIN <= {	NewOpInt,
								PROGRAMMING,
								ERA_EXE,
								ERA_END_ADDR,
								ERA_ST_ADDR, 	
								SDREG_READ,
								NORMAL_WRITE,
								NORMAL_READ};

	Function1_r	:EXT_SFR_DIN <= {	PWD_LENGTH,
								FORCE_ERASE,
								CID_WRITE,
								PRE_WRITE_ERASE_BLKCNT,
								READ_WR_PROTECT,
								ARG_FOR_WR_PROTECT,
								CLR_WR_PROTECT,
								SET_WR_PROTECT};

	Function2_r	:EXT_SFR_DIN <= {  addr[40],size[9:8],
								CARD_PWD,
								SWITCH_FUNC_ARG,
								SWITCH_FUNC_STA,
								CID_PROG,
								RW_SPECIAL_BLK};
	
	Addr39_32_r	:EXT_SFR_DIN <= addr[39:32];
	Addr31_24_r	:EXT_SFR_DIN <= addr[31:24];
	Addr23_16_r :EXT_SFR_DIN <= addr[23:16];
	Addr15_8_r	:EXT_SFR_DIN <= addr[15:8];
	Addr7_0_r 	:EXT_SFR_DIN <= addr[7:0];
	Size_L_r	:EXT_SFR_DIN <= size[7:0];

	rdata_regval0_r :EXT_SFR_DIN <= rdata_regval0;
	rdata_regval1_r :EXT_SFR_DIN <= rdata_regval1;
	rdata_regval2_r :EXT_SFR_DIN <= rdata_regval2;
	rdata_regval3_r :EXT_SFR_DIN <= rdata_regval3;
	SDDatCnt0_r		:EXT_SFR_DIN <= SDDatCnt[7:0];
	SDDatCnt1_r		:EXT_SFR_DIN <= SDDatCnt[11:8];
	default 		:EXT_SFR_DIN <= 8'h00;
	endcase
end

endmodule
