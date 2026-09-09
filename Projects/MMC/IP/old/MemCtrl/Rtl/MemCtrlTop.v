module MemCtrlTop(
	RESETn,
	CLK,
	sdclk,
	hreset_b,
	blast_b,
	be_b,
	size,
	mmc_rdy_b,
	M,
	NMWE,
	//NMOE,
	MD	,
	FA	 	,  
	FO	   	,
	NSFRWE	,
	NSFROE	,
	MEM_FI	,

	MMCRAM_DATAi,
	MMCRAM_DATAo,


	NandREQ	,
	NandRW,
	NandEnable,
	RSEn_Start,
	RSEn_Wait,
	RSDe_Start,
	RSDe_Wait,
	
	NandWriteData,
	NandReadData

);


input	RESETn;
input	CLK;

input	sdclk;
input	hreset_b;
input	blast_b;
input	[3:0]	be_b;
input	[9:0]	size;
output			mmc_rdy_b;
// 8051 interfaces
input	[15:0]	M		;
input			NMWE	;
//input			NMOE	;
output	[7:0]	MD		;
input	[7:0]	FA		;  
input	[7:0]	FO	   	;
input			NSFRWE	;
input			NSFROE	;
output	[7:0]	MEM_FI	;

input	[31:0]	MMCRAM_DATAi;
output	[31:0]	MMCRAM_DATAo;
input			NandREQ;
output			NandRW;
output			NandEnable;
output			RSEn_Start;
output			RSEn_Wait;
output			RSDe_Start;
output			RSDe_Wait;
	
input	[7:0]	NandReadData;
output	[7:0]	NandWriteData;


wire	[5:0]	CpuRAM_Sel;
wire	[5:0]	NandRAM_Sel;
wire	[5:0]	SplitSize;
wire	[10:0] NandRAM_Addr;
wire	[7:0]	NandRAM_DATAi;
wire	[7:0]	NandRAM_DATAo;
wire	[7:0]	NandReadData;
wire	[7:0]	NandWriteData;
wire	[10:0]	MMCRAM_Addr;
wire	[10:0]	CpuRAM_Addr;
wire	[9:0]	Cpu_Size;

memregif MemRegIF
(
	.RESETn				(RESETn			),
	.CLK				(CLK			),
	.FA					(FA				),
	.FO					(FO				),
	.NSFRWE				(NSFRWE			),
	.NSFROE				(NSFROE			),
	.MEM_FI				(MEM_FI			),
	
	.CpuRAM_Sel			(CpuRAM_Sel		),
	.NandRAM_Sel		(NandRAM_Sel	),
	.MMCRAM_Sel0		(MMCRAM_Sel0	),
	.MMCRAM_Sel1		(MMCRAM_Sel1	),
	.CpuSize			(size		),
	.MMCReadStart		(MMCReadStart	),
	.MMCWriteStart		(MMCWriteStart	),
	.MMCStartClr		(MMCStartClr	),
	.MMCTransferEnd		(MMCTransferEnd	),
	.MMCBLKSIZE			(MMCBLKSIZE		),
	.NandStart			(NandStart		),
	.NandRead			(NandRead		),
	.NandWrite			(NandWrite		),
	.RSEn_Enable		(RSEn_Enable	),
	.RSDe_Enable		(RSDe_Enable	),
	.NandTransferEnd	(NandTransferEnd),
	.NandReqSplitSize	(SplitSize		)
);

nandrsif	NandRsIF
(
	.RESETn				(RESETn			),
	.CLK				(CLK			),
	
	.BlkSize			(MMCBLKSIZE		),
	.NandStart			(NandStart		),
	.NandRead			(NandRead		),
	.NandWrite			(NandWrite		),
	.RSEn_Enable		(RSEn_Enable	),
	.RSDe_Enable		(RSDe_Enable	),
	                                    
	.NandREQ			(NandREQ		),
	.SplitSize			(SplitSize		),
	                                    
	.NandRAM_Addr		(NandRAM_Addr	),
	.Nand_Wen			(Nand_Wen		),
	.NandRAM_DATAi		(NandRAM_DATAi	),
	.NandRAM_DATAo		(NandRAM_DATAo	),
	                                    
	.NandReadData		(NandReadData	),
	.NandWriteData		(NandWriteData	),
	.NandRW				(NandRW			),
	.NandEnable			(NandEnable		),
	                                    
	.RSEn_Start			(RSEn_Start		),
	.RSEn_Wait			(RSEn_Wait		),
	.RSDe_Start			(RSDe_Start		),
	.RSDe_Wait			(RSDe_Wait		),
	.TransferEnd		(NandTransferEnd)
);

mmcramif MMCRamIF
(
	.sdclk				(sdclk),
	.hreset_b			(hreset_b),
	
	.be_b				(be_b),
	.blast_b			(blast_b),
	.mmc_rdy_b			(mmc_rdy_b),	

	.Cpu_ABORT			(Cpu_ABORT),
	.Cpu_Size			(size),
	.ERROR				(ERROR),
	.ReadStart			(MMCReadStart),
	.WriteStart			(MMCWriteStart),
	.MMCStartClr		(MMCStartClr),
	.TransferEnd		(MMCTransferEnd),
	
	.MMCRAM_Addr		(MMCRAM_Addr),
	.MMC_Wen			(MMC_Wen)
);


memchblk MemChBlk
(
	.CLK				(CLK),
	.sdclk				(sdclk),
	
	.MMC_CEN0			(~be_b[0]),
	.MMC_CEN1			(~be_b[1]),
	.MMC_CEN2			(~be_b[2]),
	.MMC_CEN3			(~be_b[3]),
	
	.CpuRAM_Sel0		(CpuRAM_Sel[0]),
	.CpuRAM_Sel1		(CpuRAM_Sel[1]),
	.CpuRAM_Sel2		(CpuRAM_Sel[2]),
	.CpuRAM_Sel3		(CpuRAM_Sel[3]),
	.CpuRAM_Sel4		(CpuRAM_Sel[4]),
	.CpuRAM_Sel5		(CpuRAM_Sel[5]),
	
	.NandRAM_Sel0		(NandRAM_Sel[0]),
	.NandRAM_Sel1		(NandRAM_Sel[1]),
	.NandRAM_Sel2		(NandRAM_Sel[2]),
	.NandRAM_Sel3		(NandRAM_Sel[3]),
	.NandRAM_Sel4		(NandRAM_Sel[4]),
	.NandRAM_Sel5		(NandRAM_Sel[5]),
	
	.CpuRAM_Addr		(M[10:0]), // From Cpu
	.Cpu_Wen			(~NMWE),
	
	.NandRAM_Addr		(NandRAM_Addr), // From RS block
	.Nand_Wen			(Nand_Wen),
	
	.CpuRAM_DATAo		(MD),
	.CpuRAM_DATAi		(FO),
	
	.NandRAM_DATAo		(NandRAM_DATAo),
	.NandRAM_DATAi		(NandRAM_DATAi),
	
	.MMCRAM_Addr		(MMCRAM_Addr),
	.MMC_Wen			(MMC_Wen	),
	.MMCRAM_DATAi		(MMCRAM_DATAi), 
	.MMCRAM_Sel0		(MMCRAM_Sel0),
	.MMCRAM_Sel1		(MMCRAM_Sel1),
	.MMCRAM_DATAo 		(MMCRAM_DATAo)// Dedicate MMC RAM Data
);

endmodule
