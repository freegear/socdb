module tbRSEncoderTop;



reg			RESETn;
reg			CLK;
reg	[9:0]	NandRAM_DATAo;
reg			RSEn_Start;
reg			RSEn_Wait;
reg	[7:0]	FA		;
reg	[7:0]	FO		;
reg			NSFRWE	;
reg			NSFROE	;
wire	[7:0]	RSEnc_FI;
wire			RSEn_End;



initial
begin
	RESETn = 0;
	RSEn_Start = 0;
	RSEn_Wait = 0;
	FA = 0;
	FO = 0;
	NSFRWE = 1;
	NSFROE = 1;
	CLK = 0;
	NandRAM_DATAo = 0;
force RSEncoderTop.RSEncoderCtrl.NFBlockSize = 1;
end

always
	#5 CLK = ~CLK;


integer i;

initial 
begin
	#100
	RESETn = 1;
	$display ("Encoding Start");
	@(posedge CLK) #2	RSEn_Start = 1;
	@(posedge CLK) #2	RSEn_Start = 0;
//	NandRAM_DATAo = 1;
	
	for (i = 1 ; i < 513 ; i= i+1)
	begin
	@(posedge CLK) #2	NandRAM_DATAo = i;
	end

	for (i = 1 ; i < 513 ; i= i+1)
	begin
	@(posedge CLK) #2	NandRAM_DATAo = i;
	end

	for (i = 1 ; i < 513 ; i= i+1)
	begin
	@(posedge CLK) #2	NandRAM_DATAo = i;
	end

	for (i = 1 ; i < 513 ; i= i+1)
	begin
	@(posedge CLK) #2	NandRAM_DATAo = i;
	end

end



task Reg_Write;
input	[7:0]	ADDR;
input	[7:0]	DATA; 
begin

	FA	= 	ADDR;
	FO	=	DATA;
	@(posedge CLK)
	#2 NSFRWE	= 0;
	@(posedge CLK)
	#2 NSFRWE	= 1;
end
endtask

task Reg_Read;
input	[7:0]	ADDR;
begin
	FA	= ADDR;
	@(posedge CLK)
	#2 NSFROE = 0;
	@(posedge CLK)
	#2 NSFROE = 1;
end
endtask


nandrsif rsencif( 
	.RESETn			(RESETn),
	.CLK			(CLK),
	
	.BlkSize		(BlkSize),
	.NandStart		(NandStart),
	.NandReadWrite	(1'b0), // NandRead
	
	// RS Register Setting 
	
	.Bypass			(1'b0),
	.RSMode			(1'b0), // RS Encode or Decode Setting 0 :encode 1: Decode
	
	.NandREQ		(1'b1),
	.SplitSize		(6'b000010), // Nand DMA Req 1 time Transfer Size
	
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
/*
RSEncoderTop RSEncoderTop(
	.RESETn			(RESETn			),
	.CLK			(CLK			),
	.NandRAM_DATAo	(NandRAM_DATAo	),
	.RSEn_Start		(RSEn_Start		),
	.RSEn_Wait		(RSEn_Wait		),
	.FA				(FA				),
	.FO				(FO				),
	.NSFRWE			(NSFRWE			),
	.NSFROE			(NSFROE			),
	.RSEnc_FI		(RSEnc_FI		),
	.RSEn_End		(RSEn_End		)
);
*/
endmodule
