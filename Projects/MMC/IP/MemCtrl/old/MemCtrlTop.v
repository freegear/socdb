module MemCtrlTop(
	RESETn,
	CLK,
	be_b,
	size,
	abort,
	mmc_rdy_b,
	xram_addr,
	xram_we_b,
	xram_ce_b,
	//NMOE,
	MD	,
	FA	 	,  
	FO	   	,
	NSFRWE	,
	NSFROE	,
	MEM_FI	,

	MMCRAM_DATAi,
	MMCRAM_DATAo,


	NandREQ0,
	NandREQ1,
	RSEn_Start0,
	RSEn_Start1,
	RSEn_Wait0,
	RSEn_Wait1,
	RSDe_Start0,
	RSDe_Start1,
	RSDe_Wait0,
	RSDe_Wait1,

	NandF_WEn0,
	NandF_OEn0,
	NandF_WEn1,
	NandF_OEn1,
	
	NandRAM0_DATAo,
	NandRAM0_DATAi,
	NandRAM1_DATAo,
	NandRAM1_DATAi
);


input	RESETn;
input	CLK;

input	[3:0]	be_b;
input	[9:0]	size;
input			abort;
output			mmc_rdy_b;
// 8051 interfaces
input	[15:0]	xram_addr;
input			xram_we_b;
input			xram_ce_b;
//input			NMOE	;
output	[7:0]	MD		;
input	[7:0]	FA		;  
input	[7:0]	FO	   	;
input			NSFRWE	;
input			NSFROE	;
output	[7:0]	MEM_FI	;

input	[31:0]	MMCRAM_DATAi;
output	[31:0]	MMCRAM_DATAo;
input			NandREQ0;
input			NandREQ1;
output			RSEn_Start0;
output			RSEn_Start1;
output			RSEn_Wait0;
output			RSEn_Wait1;
output			RSDe_Start0;
output			RSDe_Start1;
output			RSDe_Wait0;
output			RSDe_Wait1;
output			NandF_WEn0;
output			NandF_OEn0;
output			NandF_WEn1;
output			NandF_OEn1;
output	[7:0]	NandRAM0_DATAo;
input	[7:0]	NandRAM0_DATAi;
output	[7:0]	NandRAM1_DATAo;
input	[7:0]	NandRAM1_DATAi;
	
wire	[5:0]	CpuRAM_Sel;
wire	[5:0]	NandRAM_Sel;
wire	[5:0]	SplitSize;
wire	[10:0]  NandRAM_Addr;
wire	[10:0]	MMCRAM_Addr;
wire	[9:0]	Cpu_Size;

wire	[5:0]	SplitSize0;
wire	[5:0]	SplitSize1;
wire	[10:0]	NandRAM_Addr0;
wire	[10:0]	NandRAM_Addr1;


memregif MemRegIF
(
	.RESETn				(RESETn			),
	.CLK				(CLK			),
	.FA					(FA				),
	.FO					(FO				),
	.NSFRWE				(NSFRWE			),
	.NSFROE				(NSFROE			),
	.MEM_FI				(MEM_FI			),
	
	.NandRAM_Sel		(NandRAM_Sel	),
	.MMCRAM_Sel0		(MMCRAM_Sel0	),
	.MMCRAM_Sel1		(MMCRAM_Sel1	),
	.MMCReadStart		(MMCReadStart	),
	.MMCWriteStart		(MMCWriteStart	),
	.MMCTransferEnd		(MMCTransferEnd	),
	.MMCBLKSIZE			(MMCBLKSIZE		),
	.NandStart0			(NandStart0		),
	.NandStart1			(NandStart1		),
	.NandReadWrite0		(NandReadWrite0	),
	.NandReadWrite1		(NandReadWrite1	),

	.Bypass0			(Bypass0	),
	.Bypass1			(Bypass1	),
	.RSMode0			(RSMode0	),
	.RSMode1			(RSMode1	),
	.NandTransferEnd0	(NandTransferEnd0),
	.NandTransferEnd1	(NandTransferEnd1),
	.NandReqSplitSize0	(SplitSize0		),
	.NandReqSplitSize1	(SplitSize1		)
);
/*
nandrsif	NandRsif_ch0
(
	.RESETn				(RESETn			),
	.CLK				(CLK			),
	
	.BlkSize			(NandBlkSize0	),
	.NandStart			(NandStart0		),
	.NandReadWrite		(NandReadWrite0	),

	.Bypass				(Bypass0		),
	.RSMode				(RSMode0		),
	                                    
	.NandREQ			(NandREQ0		),
	.SplitSize			(SplitSize0		),
	                                    
	.NandRAM_Addr		(NandRAM_Addr0	),
	.NandRAM_Wen		(NandRAM_Wen0	),
	.NandRAM_Oen		(NandRAM_Oen0	),
	                                    
	.NandF_WEn			(NandF_WEn0),
	.NandF_OEn			(NandF_OEn0),
	                                    
	.RSEn_Start			(RSEn_Start0	),
	.RSEn_Wait			(RSEn_Wait0		),
	.RSDe_Start			(RSDe_Start0	),
	.RSDe_Wait			(RSDe_Wait0		),
	.TransferEnd		(NandTransferEnd0)
);

nandrsif	NandRsif_ch1
(
	.RESETn				(RESETn			),
	.CLK				(CLK			),
	
	.BlkSize			(NandBlkSize1	),
	.NandStart			(NandStart1		),
	.NandReadWrite		(NandReadWrite1	),
	.Bypass				(Bypass1		),
	.RSMode				(RSMode1		),
	                                    
	.NandREQ			(NandREQ1		),
	.SplitSize			(SplitSize1		),
	                                    
	.NandRAM_Addr		(NandRAM_Addr1	),
	.NandRAM_Wen		(NandRAM_Wen1	),
	.NandRAM_Oen		(NandRAM_Oen1	),

	.NandF_WEn			(NandF_WEn1),
	.NandF_OEn			(NandF_OEn1),
	                                    
	.RSEn_Start			(RSEn_Start1	),
	.RSEn_Wait			(RSEn_Wait1		),
	.RSDe_Start			(RSDe_Start1	),
	.RSDe_Wait			(RSDe_Wait1		),
	.TransferEnd		(NandTransferEnd1)
);
*/


mmcramif MMCRamIF
(
	.CLK				(CLK),
	.RESETn				(RESETn),
	
	.mmc_rdy_b			(mmc_rdy_b),	
	.size				(size),

	.abort				(abort),
	.ReadStart			(MMCReadStart),
	.WriteStart			(MMCWriteStart),
	.TransferEnd		(MMCTransferEnd),
	
	.MMCRAM_Addr		(MMCRAM_Addr),
	.MMC_Wen			(MMC_Wen)
);


memchblk MemChBlk
(
	.CLK				(CLK),
	
	.MMC_CEn0			(be_b[0]),
	.MMC_CEn1			(be_b[1]),
	.MMC_CEn2			(be_b[2]),
	.MMC_CEn3			(be_b[3]),
	
	.xram_ce_b			(xram_ce_b),
	
	.NandRAM_Sel0		(NandRAM_Sel[0]),
	.NandRAM_Sel1		(NandRAM_Sel[1]),
	.NandRAM_Sel2		(NandRAM_Sel[2]),
	.NandRAM_Sel3		(NandRAM_Sel[3]),
	.NandRAM_Sel4		(NandRAM_Sel[4]),
	.NandRAM_Sel5		(NandRAM_Sel[5]),
	
	.CpuRAM_Addr		(xram_addr), // From Cpu
	.Cpu_Wen			(~xram_we_b),
	
	.NandRAM_Addr0		(NandRAM_Addr0), // From RS block
	.NandRAM_Addr1		(NandRAM_Addr1), // From RS block
	.NandRAM_Wen0		(NandRAM_Wen0),
	.NandRAM_Wen1		(NandRAM_Wen1),
	
	.CpuRAM_DATAo		(MD),
	.CpuRAM_DATAi		(FO),
	
	.NandRAM0_DATAo		(NandRAM0_DATAo),
	.NandRAM0_DATAi		(NandRAM0_DATAi),
	.NandRAM1_DATAo		(NandRAM1_DATAo),
	.NandRAM1_DATAi		(NandRAM1_DATAi),
	
	
	.MMCRAM_Addr		(MMCRAM_Addr),
	.MMC_Wen			(MMC_Wen	),
	.MMCRAM_DATAi		(MMCRAM_DATAi), 
	.MMCRAM_Sel0		(MMCRAM_Sel0),
	.MMCRAM_Sel1		(MMCRAM_Sel1),
	.MMCRAM_DATAo 		(MMCRAM_DATAo)// Dedicate MMC RAM Data
);

endmodule
