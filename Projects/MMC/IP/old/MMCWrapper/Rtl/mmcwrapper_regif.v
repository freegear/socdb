module mmcwrapper_regif(
	RESETn,
	CLK,
	FA,
	FO,
	NSFRWE,
	NSFROE,
	MMC_FI,
	
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
	RW_SPECIAL_BLK
);

input			RESETn;
input			CLK;
input	[7:0]	FA;
input	[7:0]	FO;
input			NSFRWE;
input			NSFROE;
output	[7:0]	MMC_FI;
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

`define 	Fuction0_ADDR				8'b00000000
`define 	Fuction1_ADDR				8'b00000000
`define 	Fuction2_ADDR				8'b00000000

`define 	Addr31_24DDR				8'b00000000
`define 	Addr23_16_ADDR				8'b00000000
`define 	Addr15_8_ADDR				8'b00000000
`define 	Addr7_0_ADDR				8'b00000000

`define		Size_H_ADDR					8'b00000000
`define		Size_L_ADDR					8'b00000000

wire		Function0_r;
wire		Function1_r; 	
wire		Function2_r;	
wire		Addr31_24_r;
wire		Addr23_16_r;
wire		Addr15_8_r;
wire		Addr7_0_r;	
wire		Size_H_r;	
wire		Size_L_r;	

assign	Function0_r 	= (FA==`Fuction0_ADDR) & (NSFROE==0);
assign	Function1_r 	= (FA==`Fuction1_ADDR) & (NSFROE==0);
assign	Function2_r 	= (FA==`Fuction2_ADDR) & (NSFROE==0);


assign	Addr31_24_r 	= (FA==`Addr31_24DDR) & (NSFROE==0);
assign	Addr23_16_r 	= (FA==`Addr23_16_ADDR) & (NSFROE==0);
assign	Addr15_8_r	 	= (FA==`Addr15_8_ADDR) & (NSFROE==0);
assign	Addr7_0_r 		= (FA==`Addr7_0_ADDR) & (NSFROE==0);

assign 	Size_H_r		= (FA==`Size_H_ADDR) & (NSFROE==0);
assign 	Size_L_r		= (FA==`Size_L_ADDR) & (NSFROE==0);

reg [7:0] 	NextMMC_FI;
reg	[7:0]	MMC_FI;
always @(MMC_FI or Function0_r or Function0_r or Function2_r or
Addr31_24_r or Addr23_16_r or Addr15_8_r or Addr7_0_r or addr or Size_H_r or Size_L_r)
begin
	NextMMC_FI=MMC_FI;
	case(1'b1)
	Function0_r	:NextMMC_FI= {	1'b0,
								PROGRAMMING,
								ERA_EXE,
								ERA_END_ADDR,
								ERA_ST_ADDR, 	
								SDREG_READ,
								NORMAL_WRITE,
								NORMAL_READ};

	Function1_r	:NextMMC_FI= {	PWD_LENGTH,
								FORCE_ERASE,
								CID_WRITE,
								PRE_WRITE_ERASE_BLKCNT,
								READ_WR_PROTECT,
								ARG_FOR_WR_PROTECT,
								CLR_WR_PROTECT,
								SET_WR_PROTECT};

	Function2_r	:NextMMC_FI= {  3'b000,
								CARD_PWD,
								SWITCH_FUNC_ARG,
								SWITCH_FUNC_STA,
								CID_PROG,
								RW_SPECIAL_BLK};
	
	Addr31_24_r	:NextMMC_FI= addr[31:24];

	Addr23_16_r :NextMMC_FI= addr[23:16];

	Addr15_8_r	:NextMMC_FI= addr[15:8];

	Addr7_0_r 	:NextMMC_FI= addr[7:0];
	
	Size_H_r	:NextMMC_FI ={6'b000000, size[9:8]};

	Size_L_r	:NextMMC_FI = size[7:0];
	endcase
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MMC_FI <= 0;
	else
	MMC_FI <= NextMMC_FI;
end 

endmodule
