module tb_mmcramif;

reg				sdclk;
reg				hreset_b;

reg	[3:0]		be_b; //from MMC ip
reg				blast_b;
wire			rdy_b;

reg				Cpu_ABORT;
reg	[9:0]		Cpu_Size;
reg				ERROR;
reg				ReadStart;
reg				WriteStart;
wire			TransferEnd;

wire	[10:0]	MMCRAM_Addr;
wire			MMC_Wen;




initial 
begin
	Cpu_ABORT =0;
	ERROR =0;
	hreset_b=0;
	sdclk = 0;
	be_b=0;
	blast_b=1;
	Cpu_Size = 10;
	blast_b = 1;
	be_b = 4'b0000;
	ReadStart = 0;
	WriteStart = 0;
	
end

always 
begin
	#5 sdclk = ~sdclk;
end

initial
begin
	#200
	hreset_b = 1;
	#10
	ReadStart = 1;
	#10
	ReadStart = 0;

end

mmcramif ramif
( 
	.sdclk		(sdclk		),
	.hreset_b	(hreset_b	),                        
	
	.be_b		(be_b		),
	.blast_b	(blast_b	),
	.rdy_b		(rdy_b		),
                            
//CPU INPUT       INPUT
	.Cpu_ABORT	(Cpu_ABORT	),
	.Cpu_Size	(Cpu_Size	),
	.ERROR		(ERROR		),
	.ReadStart	(ReadStart	),
	.WriteStart	(WriteStart	),
	.TransferEnd(TransferEnd),
                            
	.MMCRAM_Addr(MMCRAM_Addr),
	.MMC_Wen	(MMC_Wen	)

);

endmodule
