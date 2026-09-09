module tb_memchblk;

reg 		CLK;

reg			MMC_CEN0;
reg			MMC_CEN1;
reg			MMC_CEN2;
reg			MMC_CEN3;

reg			CpuRAM_Sel0;
reg			CpuRAM_Sel1;
reg			CpuRAM_Sel2;
reg			CpuRAM_Sel3;
reg			CpuRAM_Sel4;
reg			CpuRAM_Sel5;

reg			NandRAM_Sel0;
reg			NandRAM_Sel1;
reg			NandRAM_Sel2;
reg			NandRAM_Sel3;
reg			NandRAM_Sel4;
reg			NandRAM_Sel5;

reg [10:0]	CpuRAM_Addr;
reg			Cpu_Wen;

reg [10:0]	NandRAM_Addr; // From RS block
reg			Nand_Wen;

wire[7:0]	CpuRAM_DATAo;
reg	[7:0]	CpuRAM_DATAi; // CPU ACCESS

wire[7:0]	NandRAM_DATAo; 
reg	[7:0]	NandRAM_DATAi; 

reg	[31:0]	MMCRAM_DATAi; 
reg	[10:0]	MMCRAM_Addr;
reg			MMC_Wen;
reg			MMCRAM_Sel0;
reg			MMCRAM_Sel1;
wire[31:0]	MMCRAM_DATAo;


initial
begin
	CLK 	 = 0;
	MMC_CEN0 = 0;
	MMC_CEN1 = 0;
	MMC_CEN2 = 0;
	MMC_CEN3 = 0;

	CpuRAM_Sel0 = 0;
	CpuRAM_Sel1 = 0;
	CpuRAM_Sel2 = 0;
	CpuRAM_Sel3 = 0;
	CpuRAM_Sel4 = 0;
	CpuRAM_Sel5 = 0;

	NandRAM_Sel0 = 0;
	NandRAM_Sel1 = 0;
	NandRAM_Sel2 = 0;
	NandRAM_Sel3 = 0;
	NandRAM_Sel4 = 0;
	NandRAM_Sel5 = 0;
	CpuRAM_Addr	 = 	0;
	Cpu_Wen		 =	0;
	
	CpuRAM_DATAi = 0;
	NandRAM_DATAi = 0;
	MMCRAM_DATAi = 0;

	NandRAM_Addr = 0; // From RS block
	Nand_Wen	 = 0;
end

always 
begin
	#5	CLK = ~CLK;
end

integer i;
initial
begin
	#200
	$display ("Cpu Select RAM 0 ");
	CpuRAM_Sel0 = 1;
	#10 
	@(posedge CLK)
	Cpu_Wen = 1;
	//CpuRAM_Addr = CpuRAM_Addr+1;
	//CpuRAM_DATAi = CpuRAM_DATAi + 1;

	for (i=0; i < 2048 ; i= i+1)
	begin
	@(posedge CLK)
	CpuRAM_Addr = CpuRAM_Addr + 1;
	CpuRAM_DATAi = CpuRAM_DATAi + 1;
	end

	Cpu_Wen = 0;
	for (i=0; i < 2048 ; i= i+1)
	begin
	@(posedge CLK)
	CpuRAM_Addr = CpuRAM_Addr + 1;
	//CpuRAM_DATAi = CpuRAM_DATAi + 1;
	end

	#200
	CpuRAM_Sel0 = 0;
	$display ("Cpu Select RAM 2 ");
	CpuRAM_Sel1 = 1;
	#10 
	@(posedge CLK)
	Cpu_Wen = 1;
	//CpuRAM_Addr = CpuRAM_Addr+1;
	//CpuRAM_DATAi = CpuRAM_DATAi + 1;

	for (i=0; i < 2048 ; i= i+1)
	begin
	@(posedge CLK)
	CpuRAM_Addr = CpuRAM_Addr + 1;
	CpuRAM_DATAi = CpuRAM_DATAi + 1;
	end

	Cpu_Wen = 0;
	for (i=0; i < 2048 ; i= i+1)
	begin
	@(posedge CLK)
	CpuRAM_Addr = CpuRAM_Addr + 1;
	end

	#200
	CpuRAM_Sel1 = 0;
	$display ("Nand Select RAM 2 ");
	NandRAM_Sel0 = 1;
	#10 
	@(posedge CLK)
	Nand_Wen = 1;

	for (i=0; i < 2048 ; i= i+1)
	begin
	@(posedge CLK)
	NandRAM_Addr = NandRAM_Addr + 1;
	NandRAM_DATAi = NandRAM_DATAi + 1;
	end

	Nand_Wen = 0;
	for (i=0; i < 2048 ; i= i+1)
	begin
	@(posedge CLK)
	NandRAM_Addr = NandRAM_Addr + 1;
	end

end

memchblk memchblk
(
	.CLK			(CLK			),
	                                
	.MMC_CEN0		(MMC_CEN0		),
	.MMC_CEN1		(MMC_CEN1		),
	.MMC_CEN2		(MMC_CEN2		),
	.MMC_CEN3		(MMC_CEN3		),
	                                
	.CpuRAM_Sel0	(CpuRAM_Sel0	),
	.CpuRAM_Sel1	(CpuRAM_Sel1	),
	.CpuRAM_Sel2	(CpuRAM_Sel2	),
	.CpuRAM_Sel3	(CpuRAM_Sel3	),
	.CpuRAM_Sel4	(CpuRAM_Sel4	),
	.CpuRAM_Sel5	(CpuRAM_Sel5	),
	                                
	.NandRAM_Sel0	(NandRAM_Sel0	),
	.NandRAM_Sel1	(NandRAM_Sel1	),	
	.NandRAM_Sel2	(NandRAM_Sel2	),
	.NandRAM_Sel3	(NandRAM_Sel3	),
	.NandRAM_Sel4	(NandRAM_Sel4	),
	.NandRAM_Sel5	(NandRAM_Sel5	),
	                                
	.CpuRAM_Addr	(CpuRAM_Addr	), // From Cpu
	.Cpu_Wen		(Cpu_Wen		),
	                                
	.NandRAM_Addr	(NandRAM_Addr	), // From RS block
	.Nand_Wen		(Nand_Wen		),
	                                
	.CpuRAM_DATAo	(CpuRAM_DATAo	),
	.CpuRAM_DATAi	(CpuRAM_DATAi	),
	                                
	.NandRAM_DATAo	(NandRAM_DATAo	),
	.NandRAM_DATAi	(NandRAM_DATAi	),
	                                
	.MMCRAM_Addr	(MMCRAM_Addr	),
	.MMC_Wen		(MMC_Wen		),
	.MMCRAM_DATAi	(MMCRAM_DATAi	), 
	.MMCRAM_Sel0	(MMCRAM_Sel0	),
	.MMCRAM_Sel1	(MMCRAM_Sel1	),
	.MMCRAM_DATAo 	(MMCRAM_DATAo 	)

);




endmodule
