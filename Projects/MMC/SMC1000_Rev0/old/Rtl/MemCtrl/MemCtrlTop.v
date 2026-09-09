module MemCtrlTop(
	RESETn,
	CLK,
	be_b,
	size,
	abort,
	rdyb,
	si_wrb,
	si_rdb,
	xram_addr,
	xram_we_b,
	xram_ce_b,

	err,
	MD	,
	FO	,

	CS	,
	EXT_SFR_DOUT,
	EXT_SFR_WR,
	EXT_SFR_DIN,
	
	NandMode,

	MMCRAM_DATAi,
	MMCRAM_DATAo,


	NandRAM_Addr0, // From RS block
	NandRAM_Addr1, // From RS block
	NandRAM_Wen0,
	NandRAM_Wen1,
	
	NandRAM0_DATAo,
	NandRAM0_DATAi,
	NandRAM1_DATAo,
	NandRAM1_DATAi,
	// to register inferface	
	MMCTransferEnd // Interrupt input
);


input	RESETn;
input	CLK;

input	[3:0]	be_b;
input	[9:0]	size;
input			abort;
output			rdyb;
input			si_wrb;
input			si_rdb;
// 8051 interfaces
input	[15:0]	xram_addr;
input			xram_we_b;
input			xram_ce_b;

output			err;
output	[7:0]	MD		;
input	[7:0]	FO		;

input	[6:0]	CS;
input	[7:0]	EXT_SFR_DOUT;
input			EXT_SFR_WR;
output	[7:0]	EXT_SFR_DIN;

output			NandMode;

input	[31:0]	MMCRAM_DATAi;
output	[31:0]	MMCRAM_DATAo;

input	[10:0]	NandRAM_Addr0;
input	[10:0]	NandRAM_Addr1;

input			NandRAM_Wen0;
input			NandRAM_Wen1;

output	[7:0]	NandRAM0_DATAo;
input	[7:0]	NandRAM0_DATAi;
output	[7:0]	NandRAM1_DATAo;
input	[7:0]	NandRAM1_DATAi;
	
output			MMCTransferEnd;	

wire	[5:0]	NandRAM0_Sel;
wire	[5:0]	NandRAM1_Sel;
wire	[10:0]  NandRAM_Addr;
wire	[10:0]	MMCRAM_Addr;

wire	[10:0]	TransferBlkAddr;
wire			TransferStart;
wire	[9:0]	TransferSize;
wire	[9:0]	RegSize;
//wire			TransferEnd;

memregif mmcregif(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.CS				(CS				),

	.EXT_SFR_DOUT	(EXT_SFR_DOUT	),
	.EXT_SFR_WR		(EXT_SFR_WR		),
	.EXT_SFR_DIN	(EXT_SFR_DIN	),
	// Register Output
	.Cpu_Rdy		(Cpu_Rdy		),
	.Cpu_err		(Cpu_err		),
	.Rdy_sel		(Rdy_sel		),
	.NandMode		(NandMode		),
	.NandRAM0_Sel	(NandRAM0_Sel	),
	.NandRAM1_Sel	(NandRAM1_Sel	),
	.MMCRAM_Sel0	(MMCRAM_Sel0	),
	.MMCRAM_Sel1	(MMCRAM_Sel1	),
	
	.TransferBlkAddr(TransferBlkAddr),
	.TransferSize	(RegSize		),//register setting size
	.TransferStart	(TransferStart	),
	.TransferEnd	(MMCTransferEnd	)

 );
wire	mmc_rdy_b;
assign 	rdyb	= (Rdy_sel)? mmc_rdy_b :~Cpu_Rdy;
assign 	err = Cpu_err;

assign 	TransferSize = (Rdy_sel) ? size: RegSize; // auto setting size or cpu setting size

// assign rdyb = (~mmc_rdy_b)? 1'b0: ~Cpu_Rdy;

mmcramif MMCRamIF
(
	.CLK				(CLK),
	.RESETn				(RESETn),

	.TransferBlkAddr	(TransferBlkAddr),
	.TransferSize		(TransferSize	),
	.TransferStart		(TransferStart	),
	.TransferAbort		(abort	),
	.TransferEnd		(MMCTransferEnd	),

	.si_wrb				(si_wrb),
	.si_rdb				(si_rdb),
	.mmc_rdy_b			(mmc_rdy_b),
	.MMCRAM_Addr		(MMCRAM_Addr),
	.MMC_Wen_b			(MMCRAM_Wen_b)
);


memchblk MemChBlk
(
	.CLK				(CLK),
	
	.MMC_CEn0			(be_b[0]),
	.MMC_CEn1			(be_b[1]),
	.MMC_CEn2			(be_b[2]),
	.MMC_CEn3			(be_b[3]),
	
	.xram_ce_b			(xram_ce_b),
	
	.NandRAM0_Sel0		(NandRAM0_Sel[0]),
	.NandRAM0_Sel1		(NandRAM0_Sel[1]),
	.NandRAM0_Sel2		(NandRAM0_Sel[2]),
	.NandRAM0_Sel3		(NandRAM0_Sel[3]),
	.NandRAM0_Sel4		(NandRAM0_Sel[4]),
	.NandRAM0_Sel5		(NandRAM0_Sel[5]),

	.NandRAM1_Sel0		(NandRAM1_Sel[0]),
	.NandRAM1_Sel1		(NandRAM1_Sel[1]),
	.NandRAM1_Sel2		(NandRAM1_Sel[2]),
	.NandRAM1_Sel3		(NandRAM1_Sel[3]),
	.NandRAM1_Sel4		(NandRAM1_Sel[4]),
	.NandRAM1_Sel5		(NandRAM1_Sel[5]),
	
	
	.CpuRAM_Addr		(xram_addr[15:0]), // From Cpu
	.Cpu_Wen			(xram_we_b),
	
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
	.MMC_Wen			(MMCRAM_Wen_b),
	.MMCRAM_DATAi		(MMCRAM_DATAi), 
	.MMCRAM_Sel0		(MMCRAM_Sel0),
	.MMCRAM_Sel1		(MMCRAM_Sel1),
	.MMCRAM_DATAo 		(MMCRAM_DATAo)// Dedicate MMC RAM Data
);

endmodule
