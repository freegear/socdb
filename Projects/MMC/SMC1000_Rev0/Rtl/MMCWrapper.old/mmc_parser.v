// =================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology
// -----------------------------------------------------------------
// Version and Release information: 
// File Name           : mmc_parser.v 
// File Revision       : 0.1 
//  ----------------------------------------------------------------
//  Purpose            : mmc_parser block
//  ----------------------------------------------------------------
`timescale 1 ns/ 10ps

// Special Function Number Parsing Block

module mmc_parser(
	// MMC Side
	CLK,
	RESETn,
	addr,
	NewOp,
	cs_b,
	wr,
	int_clr,

	//mmc_tsize,
	si_rdata,
	si_wdata,

	MMCRAM_DATAi,
	MMCRAM_DATAo,

	rdata_regval,

	NORMAL_READ			,
	NORMAL_WRITE		,
	SDREG_READ 			,
	ERA_ST_ADDR	 		,
	ERA_END_ADDR		,
	ERA_EXE				,
	PROGRAMMING			,
	SET_WR_PROTECT		,
	CLR_WR_PROTECT		,
	ARG_FOR_WR_PROTECT	,
	READ_WR_PROTECT		,
	PRE_WRITE_ERASE_BLKCNT,
	CID_WRITE			,
	FORCE_ERASE			,
	PWD_LENGTH			,
	CARD_PWD			,
	SWITCH_FUNC_ARG		,
	SWITCH_FUNC_STA		,
	CID_PROG			,
	RW_SPECIAL_BLK		
);
 // MMC Side
input			CLK;
input			RESETn;
input 	[40:0] 	addr;	// CPU Register
input 			NewOp;
input 	[1:0]	cs_b;
input			wr;
input			int_clr;// Interrupt terminate

//output	[9:0]	mmc_tsize;
output	[31:0]	si_rdata;
input	[31:0]	si_wdata;

output [31:0]	MMCRAM_DATAi;
input	[31:0]	MMCRAM_DATAo;

input	[31:0]	rdata_regval;

output		NORMAL_READ;
output		NORMAL_WRITE;
output		SDREG_READ 			;
output		ERA_ST_ADDR	 		;
output		ERA_END_ADDR		;
output		ERA_EXE				;
output		PROGRAMMING			;
output		SET_WR_PROTECT		;
output		CLR_WR_PROTECT		;
output		ARG_FOR_WR_PROTECT	;
output		READ_WR_PROTECT		;
output		PRE_WRITE_ERASE_BLKCNT;
output		CID_WRITE			;
output		FORCE_ERASE			;
output		PWD_LENGTH			;
output		CARD_PWD			;
output		SWITCH_FUNC_ARG		;
output		SWITCH_FUNC_STA		;
output		CID_PROG			;
output		RW_SPECIAL_BLK		;

wire		normal_read;
wire		normal_write;
wire		sdreg_read 			;
wire		era_st_addr	 		;
wire		era_end_addr		;
wire		era_exe				;
wire		programming			;
wire		set_wr_protect		;
wire		clr_wr_protect		;
wire		arg_for_wr_protect	;
wire		read_wr_protect		;
wire		pre_write_erase_blkcnt;
wire		cid_write			;
wire		force_erase			;
wire		pwd_length			;
wire		card_pwd			;
wire		switch_func_arg		;
wire		switch_func_sta		;
wire		cid_prog			;
wire		rw_special_blk		;

reg			NORMAL_READ;
reg			NORMAL_WRITE;
reg			SDREG_READ 			;
reg			ERA_ST_ADDR	 		;
reg			ERA_END_ADDR		;
reg			ERA_EXE				;
reg			PROGRAMMING			;
reg			SET_WR_PROTECT		;
reg			CLR_WR_PROTECT		;
reg			ARG_FOR_WR_PROTECT	;
reg			READ_WR_PROTECT		;
reg			PRE_WRITE_ERASE_BLKCNT;
reg			CID_WRITE			;
reg			FORCE_ERASE			;
reg			PWD_LENGTH			;
reg			CARD_PWD			;
reg			SWITCH_FUNC_ARG		;
reg			SWITCH_FUNC_STA		;
reg			CID_PROG			;
reg			RW_SPECIAL_BLK		;
wire		cs10_op;
reg			cs10sel;
reg	[31:0]	DWR_reg;


assign	normal_read				= (wr==0)&(cs_b==2'b10)&(NewOp==1);
assign	normal_write			= (wr==1)&(cs_b==2'b10)&(NewOp==1);
assign 	sdreg_read 				= (addr[31:0]==32'h08000000)&(cs_b==2'b01)&(NewOp==1);
assign 	era_st_addr	 			= (addr[31:0]==32'h08008000)&(cs_b==2'b01)&(NewOp==1);
assign 	era_end_addr			= (addr[31:0]==32'h08008010)&(cs_b==2'b01)&(NewOp==1);
assign 	era_exe					= (addr[31:0]==32'h08008020)&(cs_b==2'b01)&(NewOp==1);
assign 	programming				= (addr[31:0]==32'h08008030)&(cs_b==2'b01)&(NewOp==1);
assign 	set_wr_protect			= (addr[31:0]==32'h08008040)&(cs_b==2'b01)&(NewOp==1);
assign 	clr_wr_protect			= (addr[31:0]==32'h08008050)&(cs_b==2'b01)&(NewOp==1);
assign 	arg_for_wr_protect		= (addr[31:0]==32'h08008060)&(cs_b==2'b01)&(NewOp==1);
assign 	read_wr_protect			= (addr[31:0]==32'h08008070)&(cs_b==2'b01)&(NewOp==1);
assign 	pre_write_erase_blkcnt	= (addr[31:0]==32'h08008080)&(cs_b==2'b01)&(NewOp==1);
assign 	cid_write				= (addr[31:0]==32'h08008090)&(cs_b==2'b01)&(NewOp==1);
assign 	force_erase				= (addr[31:0]==32'h08008100)&(cs_b==2'b01)&(NewOp==1);
assign 	pwd_length				= (addr[31:0]==32'h08008110)&(cs_b==2'b01)&(NewOp==1);
assign 	card_pwd				= (addr[31:0]==32'h08008200)&(cs_b==2'b01)&(NewOp==1);
assign 	switch_func_arg			= (addr[31:0]==32'h08008300)&(cs_b==2'b01)&(NewOp==1);
assign 	switch_func_sta			= (addr[31:0]==32'h08008400)&(cs_b==2'b01)&(NewOp==1);
assign 	cid_prog				= (addr[31:0]==32'h08100000)&(cs_b==2'b01)&(NewOp==1);
assign 	rw_special_blk			= (addr[31])&(cs_b==2'b01)&(NewOp==1);


assign	cs10_op					= (cs_b==2'b10)&(NewOp==1);

// Normal Read Write 일 때는 메모리에 직접 연결
// 그렇지 않을 경우 레지스터 output
assign si_rdata = (cs10sel)? MMCRAM_DATAo : rdata_regval;

assign MMCRAM_DATAi = si_wdata ;

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	DWR_reg <= 0;
	else if (NewOp)
//	else if (cs10_op) // Normal Read Write Operation
	DWR_reg <= si_wdata ;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	cs10sel <= 0;
	else if (cs10_op)
	cs10sel <= 1 ;
	else if (NewOp)
	cs10sel <= 0;
end

/*
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	mmc_tsize <= 0;
	else if (NewOp)
	mmc_tsize <= size;
end
*/

// Register 
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NORMAL_READ <= 0;
//	else if (normal_read)
	else if (NewOp & normal_read)
	NORMAL_READ <= 1;
	else if (int_clr)
	NORMAL_READ <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NORMAL_WRITE <= 0;
//	else if (normal_write)
	else if (NewOp & normal_write)
	NORMAL_WRITE <= 1;
	else if (int_clr)
	NORMAL_WRITE <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	SDREG_READ <= 0;
//	else if (sdreg_read)
	else if (NewOp & sdreg_read)
	SDREG_READ <= 1;
	else if (int_clr)
	SDREG_READ <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ERA_ST_ADDR <= 0;
//	else if (era_st_addr)
	else if (NewOp & era_st_addr)
	ERA_ST_ADDR <= 1;
	else if (int_clr)
	ERA_ST_ADDR <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ERA_END_ADDR <= 0;
//	else if (era_end_addr)
	else if (NewOp & era_end_addr)
	ERA_END_ADDR <= 1;
	else if (int_clr)
	ERA_END_ADDR <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ERA_EXE <= 0;
//	else if (era_exe)
	else if (NewOp & era_exe)
	ERA_EXE <= 1;
	else if (int_clr)
	ERA_EXE <= 0;
end
always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	PROGRAMMING <= 0;
//	else if (programming)
	else if (NewOp & programming)
	PROGRAMMING <= 1;
	else if (int_clr)
	PROGRAMMING <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	SET_WR_PROTECT <= 0;
//	else if (set_wr_protect)
	else if (NewOp & set_wr_protect)
	SET_WR_PROTECT <= 1;
	else if (int_clr)
	SET_WR_PROTECT <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CLR_WR_PROTECT <= 0;
//	else if (clr_wr_protect)
	else if (NewOp & clr_wr_protect)
	CLR_WR_PROTECT <= 1;
	else if (int_clr)
	CLR_WR_PROTECT <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	ARG_FOR_WR_PROTECT <= 0;
//	else if (arg_for_wr_protect)
	else if (NewOp & arg_for_wr_protect)
	ARG_FOR_WR_PROTECT <= 1;
	else if (int_clr)
	ARG_FOR_WR_PROTECT <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	READ_WR_PROTECT <= 0;
//	else if (read_wr_protect)
	else if (NewOp & read_wr_protect)
	READ_WR_PROTECT <= 1;
	else if (int_clr)
	READ_WR_PROTECT <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	PRE_WRITE_ERASE_BLKCNT <= 0;
//	else if (pre_write_erase_blkcnt)
	else if (NewOp & pre_write_erase_blkcnt)
	PRE_WRITE_ERASE_BLKCNT <= 1;
	else if (int_clr)
	PRE_WRITE_ERASE_BLKCNT <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CID_WRITE <= 0;
//	else if (cid_write)
	else if (NewOp & cid_write)
	CID_WRITE <= 1;
	else if (int_clr)
	CID_WRITE <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	FORCE_ERASE <= 0;
//	else if (force_erase)
	else if (NewOp & force_erase)
	FORCE_ERASE <= 1;
	else if (int_clr)
	FORCE_ERASE <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	PWD_LENGTH <= 0;
//	else if (pwd_length)
	else if (NewOp & pwd_length)
	PWD_LENGTH <= 1;
	else if (int_clr)
	PWD_LENGTH <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CARD_PWD <= 0;
//	else if (card_pwd)
	else if (NewOp & card_pwd)
	CARD_PWD <= 1;
	else if (int_clr)
	CARD_PWD <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	SWITCH_FUNC_ARG <= 0;
//	else if (switch_func_arg)
	else if (NewOp & switch_func_arg)
	SWITCH_FUNC_ARG <= 1;
	else if (int_clr)
	SWITCH_FUNC_ARG <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	SWITCH_FUNC_STA <= 0;
//	else if (switch_func_arg)
	else if (NewOp & switch_func_arg)
	SWITCH_FUNC_STA <= 1;
	else if (int_clr)
	SWITCH_FUNC_STA <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	CID_PROG <= 0;
//	else if (cid_prog)
	else if (NewOp & cid_prog)
	CID_PROG <= 1;
	else if (int_clr)
	CID_PROG <= 0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	RW_SPECIAL_BLK <= 0;
//	else if (rw_special_blk)
	else if (NewOp & rw_special_blk)
	RW_SPECIAL_BLK <= 1;
	else if (int_clr)
	RW_SPECIAL_BLK <= 0;
end

endmodule
