module tb_nandrs;

reg 		CLK;
reg			RESETn;

//reg	[10:0]	BlkSize;
reg			BlkSize;
reg			NandStart;
reg			NandRead;
reg			NandWrite;
reg			RSEn_Enable;
reg			RSDe_Enable;
reg			NandREQ;
reg [5:0]	SplitSize;
wire[10:0]	NandRAM_Addr;
wire		Nand_Wen;
wire		Nand_Oen;
wire[7:0]	NandRAM_DATAi;
reg	[7:0]	NandRAM_DATAo;
reg	[7:0]	NandReadData;
wire[7:0]	NandWriteData;
wire		NandRW;
wire		NandEnable;
wire		RSEn_Start;
wire		RSEn_Wait;
wire		RSDe_Start;
wire		RSDe_Wait;


initial
begin
	CLK = 0;
	RESETn=0;
	BlkSize 	= 1;
	NandStart 	= 0;
	NandRead	= 0;
	NandWrite	= 1;
	RSEn_Enable = 0;
	RSDe_Enable = 0;
	NandREQ		= 1;
	SplitSize	= 6;
	NandRAM_DATAo= 1;
	NandReadData = 1;
end

always 
begin
	#5	CLK = ~CLK;
end

initial
begin
	#200
	RESETn = 1;
	#100
	@(posedge CLK)
	#1 NandStart = 1;
	@(posedge CLK)
	#1 NandStart = 0;

end

nandrsif nandrsif(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
                                    
	.BlkSize		(BlkSize		),
	.NandStart		(NandStart		),
	.NandRead		(NandRead		),
	.NandWrite		(NandWrite		),
	.RSEn_Enable	(RSEn_Enable	),
	.RSDe_Enable	(RSDe_Enable	),
                                    
	.NandREQ		(NandREQ		),
	.SplitSize		(SplitSize		),
                                    
	.NandRAM_Addr	(NandRAM_Addr	),
	.Nand_Wen		(Nand_Wen		),
	.Nand_Oen		(Nand_Oen		),
	.NandRAM_DATAi	(NandRAM_DATAi	),
	.NandRAM_DATAo	(NandRAM_DATAo	),
                                    
	.NandReadData	(NandReadData	),
	.NandWriteData	(NandWriteData	),
	.NandRW			(NandRW			),
	.NandEnable		(NandEnable		),
                                    
	.RSEn_Start		(RSEn_Start		),
	.RSEn_Wait		(RSEn_Wait		),
	.RSDe_Start		(RSDe_Start		),
	.RSDe_Wait		(RSDe_Wait		)
);

endmodule
