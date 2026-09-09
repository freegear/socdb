module tb_mmc_parser;

 // MMC Side
reg			sdclk;
reg			hreset_b;
reg 	[40:0] 	addr;	// CPU Register
reg 			ads_b;
reg 	[1:0]	cs_b;
reg			wr;
reg			int_clr;// Interrupt terminate


wire		NORMAL_READ;
wire		NORMAL_WRITE;
wire		SDREG_READ 			;
wire		ERA_ST_ADDR	 		;
wire		ERA_END_ADDR		;
wire		ERA_EXE				;
wire		PROGRAMMING			;
wire		SET_WR_PROTECT		;
wire		CLR_WR_PROTECT		;
wire		ARG_FOR_WR_PROTECT	;
wire		READ_WR_PROTECT		;
wire		PRE_WRITE_ERASE_BLKCNT;
wire		CID_WRITE			;
wire		FORCE_ERASE			;
wire		PWD_LENGTH			;
wire		CARD_PWD			;
wire		SWITCH_FUNC_ARG		;
wire		SWITCH_FUNC_STA		;
wire		CID_PROG			;
wire		RW_SPECIAL_BLK		;

initial
begin
	sdclk = 0;
	hreset_b =0;
	addr = 0;
	ads_b = 1;
	cs_b	= 00;
	wr	 = 0;
	int_clr	= 0;
end

always  #5 sdclk = ~sdclk;

initial
begin
	#200 hreset_b = 1;
	
	cs_b = 2'b10;
	@(posedge sdclk)
	#2 addr = 32'h08000000;
		ads_b =	0;
	@(posedge sdclk)
	#2 ads_b =1;

	#20
	cs_b = 2'b01;
	ACCESS (32'h08000000);
	ACCESS (32'h08008000);
	ACCESS (32'h08008010);
	ACCESS (32'h08008020);
	ACCESS (32'h08008030);
	ACCESS (32'h08008040);
	ACCESS (32'h08008050);
	ACCESS (32'h08008060);
	ACCESS (32'h08008070);
	ACCESS (32'h08008080);
	ACCESS (32'h08008090);
	ACCESS (32'h08008100);
	ACCESS (32'h08008110);
	ACCESS (32'h08008200);
	ACCESS (32'h08008300);
	ACCESS (32'h08008400);
	ACCESS (32'h08100000);
	ACCESS (32'h08101000);
	ACCESS (32'h88101000);
end

task ACCESS;
input	[31:0]	ADDR;
begin
	@(posedge sdclk)
	#2 addr = ADDR;
		ads_b =	0;
	@(posedge sdclk)
	#2 ads_b =1;
	@(posedge sdclk)
	#2 int_clr =1;
	@(posedge sdclk)
	#2 int_clr =0;
end
endtask

always @(posedge NORMAL_READ) 			$display ("NORMAL_READ");
always @(posedge NORMAL_WRITE)			$display ("NORMAL_WRITE");
always @(posedge SDREG_READ )			$display ("SDREG_READ");
always @(posedge ERA_ST_ADDR)			$display ("ERA_ST_ADDR");
always @(posedge ERA_END_ADDR)			$display ("ERA_END_ADDR");
always @(posedge ERA_EXE)				$display ("ERA_EXE");
always @(posedge PROGRAMMING)			$display ("PROGRAMMING");
always @(posedge SET_WR_PROTECT)		$display ("SET_WR_PROTECT");
always @(posedge CLR_WR_PROTECT)		$display ("CLR_WR_PROTECT");
always @(posedge ARG_FOR_WR_PROTECT)	$display ("ARG_FOR_WR_PROTECT");
always @(posedge READ_WR_PROTECT)		$display ("READ_WR_PROTECT");
always @(posedge PRE_WRITE_ERASE_BLKCNT)$display ("PRE_WRITE_ERASE_BLKCNT");
always @(posedge CID_WRITE)				$display ("CID_WRITE");
always @(posedge FORCE_ERASE)			$display ("FORCE_ERASE");
always @(posedge PWD_LENGTH)			$display ("PWD_LENGTH");
always @(posedge CARD_PWD)				$display ("CARD_PWD");
always @(posedge SWITCH_FUNC_ARG)		$display ("SWITCH_FUNC_ARG");
always @(posedge SWITCH_FUNC_STA)		$display ("SWITCH_FUNC_STA");
always @(posedge CID_PROG)				$display ("CID_PROG");
always @(posedge RW_SPECIAL_BLK)		$display ("RW_SPECIAL_BLK");

mmc_parser mmc_parser(
	// MMC Side
	sdclk,
	hreset_b,
	addr,
	ads_b,
	cs_b,
	wr,
	int_clr,

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
endmodule
