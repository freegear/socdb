module tb_nandrsif;

reg 			RESETn;
reg 			CLK;

reg	[10:0]	BlkSize;

reg			NandStart;
reg			NandReadWrite;
reg			Bypass;
reg			RSMode;
reg 		NandREQ;
reg	[5:0]	SplitSize;

wire 	[10:0] 	NandRAM_Addr;
wire 			NandRAM_Wen; 
wire 			NandRAM_Oen; 

wire			NandF_WEn;
wire			NandF_OEn;

wire			RSEn_Start;
wire			RSEn_Wait;

wire			RSDe_Start;
wire			RSDe_Wait;
wire			TransferEnd;


initial 
begin
	RESETn = 0;
	CLK = 0;
	BlkSize = 0;
	NandStart = 0;
	NandReadWrite = 0;
	Bypass = 0;
	RSMode = 0;
	NandREQ = 0;
	SplitSize = 0;

end

always #5 CLK = ~CLK;

initial
begin
	#100 RESETn = 1;
		BlkSize = 512;
	@(posedge CLK)
		# 2	NandStart = 1;	
	@(posedge CLK)
		# 2	NandStart = 0;	
end




nandrsif rsencif( 
	.RESETn			(RESETn),
	.CLK			(CLK),
	
	.BlkSize		(BlkSize),
	.NandStart		(NandStart),
	.NandReadWrite	(NandReadWrite), // NandRead
	
	// RS Register Setting 
	
	.Bypass			(Bypass),
	.RSMode			(RSMode), // RS Encode or Decode Setting 0 :encode 1: Decode
	
	.NandREQ		(NandREQ),
	.SplitSize		(SplitSize), // Nand DMA Req 1 time Transfer Size
	
	.NandRAM_Addr	(NandRAM_Addr), // NANDRAM ADDRESS
	.NandRAM_Wen	(NandRAM_Wen), // NANDRAM Write Enable
	.NandRAM_Oen	(NandRAM_Oen), // NANDRAM Output Enable
	
	// NAND Ctrl FIFO Valid signal
	.NandF_WEn	    (NandF_WEn	),
	.NandF_OEn		(NandF_OEn	),
	                            
	.RSEn_Start		(RSEn_Start	), // RS Encoder Encoding Start
	.RSEn_Wait		(RSEn_Wait	),	// RS Encoding Wait Signal 
	.RSDe_Start		(RSDe_Start	),	// RS Decoder Decoding Start
	.RSDe_Wait		(RSDe_Wait	),	// RS Decoding Wait Signal
	.TransferEnd 	(TransferEnd)   // Assigned Size Transfer End
);

endmodule
