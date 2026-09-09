module tbRSNAND_DMA;

reg 		RESETn;
reg			CLK;

reg 		Start;
reg	[10:0]	Size;
reg			Mode; // Mode 0 : Encoder 1: Decoder
reg			Bypass;
reg			DecodeEnd;
wire		RSDe_Wait; // Previous Decoding Not Complete

reg			NandREQ;

reg	[3:0]	SplitSize;

reg	[10:0]	StartAddr;
wire		TransferEnd;

wire		Nand_WEn;
wire		Nand_REn;

wire [10:0]	RAM_ADDR;

wire 		RAM_WEn;
wire		RAM_REn;

wire		RSEn_Start;
wire		RSDe_Start;



initial 
begin
	RESETn = 0;
	CLK = 0;
	Start = 0;
	Size = 0;
	Mode = 0;
	Bypass = 0;
	DecodeEnd = 0;
	NandREQ = 0;
	SplitSize = 0;
	StartAddr = 0;

end

always #5 CLK = ~CLK;

initial
begin
	#100
	// Encoding Test
	Size = 2047;
	SplitSize = 4;
	NandREQ= 1;
	#50 
	RESETn = 1;
	StartAddr = 100;
	@(posedge CLK)
	#2 Start = 1;
	@(posedge CLK)
	#2 Start = 0;
	@(negedge TransferEnd);
	// Encode With NandREQ
	
	#10
	@(posedge CLK)
	#2 Start = 1;
	@(posedge CLK)
	#2 Start = 0;
	#1000 NandREQ = 0;
	#1002 NandREQ = 1;
	@(negedge TransferEnd);

	// Decoding Test
	#10
	Mode = 1;
	@(posedge CLK)
	#2 Start = 1;
	@(posedge CLK)
	#2 Start = 0;

	#5400
	@(posedge CLK)
	#2 DecodeEnd = 1;
	@(posedge CLK)
	#2 DecodeEnd = 0;

	#5400
	@(posedge CLK)
	#2 DecodeEnd = 1;
	@(posedge CLK)
	#2 DecodeEnd = 0;

	#5400
	@(posedge CLK)
	#2 DecodeEnd = 1;
	@(posedge CLK)
	#2 DecodeEnd = 0;

	#5400
	@(posedge CLK)
	#2 DecodeEnd = 1;
	@(posedge CLK)
	#2 DecodeEnd = 0;

	
/*	
	@(negedge TransferEnd);

	// Decode With NandREQ
	#10

	@(negedge TransferEnd);

	// Decode With NandREQ with DecodeEnd
	#10

	@(negedge TransferEnd);

	// Bypass Mode Read
	#10

	@(negedge TransferEnd);

	// Bypass Mode Write
*/
	
end

RSNAND_DMA DMA
(	
	.RESETn		(RESETn	   ),
	.CLK		(CLK	   ),
	                       
	.Start		(Start	   ),
	.Size		(Size	   ),
	.Mode		(Mode	   ),
	.Bypass		(Bypass	   ),
	.DecodeEnd	(DecodeEnd ),
	.RSDe_Wait	(RSDe_Wait ),
	                       
	.NandREQ	(NandREQ   ), 
	.SplitSize	(SplitSize ), 
	.StartAddr	(StartAddr),
	.TransferEnd(TransferEnd),
	                       
	.Nand_WEn	(Nand_WEn  ),
	.Nand_REn	(Nand_REn  ),
	                       
	.RAM_ADDR	(RAM_ADDR  ),
	                       
	.RAM_WEn	(RAM_WEn   ),
	.RAM_REn	(RAM_REn   ),
	                       
	.RSEn_Start	(RSEn_Start),
	.RSDe_Start	(RSDe_Start)
);

endmodule
