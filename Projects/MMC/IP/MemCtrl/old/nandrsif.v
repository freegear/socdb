module nandrsif(
/*	RESETn			,
	CLK				,

	BlkSize			,
	NandStart		,
	NandReadWrite	,
	// RS Register Setting 

	Bypass			,
	RSMode			, // RS Encode or Decode Setting 0 :encode 1: Decode

	NandREQ			,
	SplitSize		, // Nand DMA Req 1 time Transfer Size
*/
	NandRAM_Addr	, // NANDRAM ADDRESS
	NandRAM_Wen		, // NANDRAM Write Enable
	NandRAM_Oen		, // NANDRAM Output Enable
/*
	// NAND Ctrl FIFO Valid signal
	NandF_WEn		,
	NandF_OEn		,

	RSEn_Start		, // RS Encoder Encoding Start
	RSEn_Wait		,	// RS Encoding Wait Signal 
	RSDe_Start		,	// RS Decoder Decoding Start
	RSDe_Wait		,	// RS Decoding Wait Signal
	TransferEnd 		// Assigned Size Transfer End
*/
);

input 			RESETn;
input 			CLK;

input	[10:0]	BlkSize;

input			NandStart;
input			NandReadWrite;
input			Bypass;
input			RSMode;

input 			NandREQ;
input	[5:0]	SplitSize;

output 	[10:0] 	NandRAM_Addr;
output 			NandRAM_Wen; 
output 			NandRAM_Oen; 

output			NandF_WEn;
output			NandF_OEn;

output			RSEn_Start;
output			RSEn_Wait;

output			RSDe_Start;
output			RSDe_Wait;
output			TransferEnd;

wire			NandReadStart;
wire			NandWriteStart;
wire			NandWait;
wire			TransferError;
assign 			NandReadStart 	= NandStart & ~NandReadWrite ; 
assign 			NandWriteStart	= NandStart & NandReadWrite;

`define NAND_IDLE 		5'b00001
`define NAND_READ	 	5'b00010
`define NAND_WRITE	 	5'b00100
`define NAND_WAIT		5'b01000
`define NAND_INITWAIT	5'b10000

reg 	[4:0]	NextNandState;
reg		[4:0]	NandState;
reg 			NextNandRAM_Wen;
reg				NandRAM_Wen;
reg 			NextNandRAM_Oen;
reg				NandRAM_Oen;
reg	[10:0]	NextDatCnt;
reg [10:0]	DatCnt;
wire	[10:0]	NandRAM_Addr;

wire	BlkEnd;
wire	RSdisableTransferEnd;
wire	RSTransferEnd;
wire	RSWait;
wire	TransferEnd2;
wire	BigBlockNand;
wire	SmallBlockNand;

reg		[10:0]NextBlkDatCnt;
reg 	[10:0] BlkDatCnt;
reg 	[3:0]	BlkCnt;
reg 	[3:0]	NextBlkCnt;

wire 	BlkDatCnt0;


always @(NandState or NandReadStart or NandWriteStart or NandReadWrite or TransferEnd or TransferError or BlkEnd)
begin
	NextNandState = NandState;
	case (NandState)
	`NAND_IDLE	:
		begin
		if (NandReadStart)
		NextNandState = `NAND_READ;
		else if(NandWriteStart)
		NextNandState = `NAND_WRITE;
		end
	`NAND_READ:	
		begin
		if (BlkEnd & ~Bypass)
		NextNandState = `NAND_INITWAIT;
		else if (NandWait)
		NextNandState = `NAND_WAIT;
		else if (TransferError|RSdisableTransferEnd)
		NextNandState = `NAND_IDLE;
		end
	`NAND_WRITE:
		begin
		if (BlkEnd & ~Bypass)
		NextNandState = `NAND_INITWAIT;
		else if (NandWait)
		NextNandState = `NAND_WAIT;
		else if (TransferError|RSdisableTransferEnd)
		NextNandState = `NAND_IDLE;
		end
	`NAND_WAIT	:	
		begin
		if (~NandReadWrite&~NandWait)
		NextNandState = `NAND_READ;
		else if (NandReadWrite & ~NandWait)
		NextNandState = `NAND_WRITE;
		else if (TransferError)
		NextNandState = `NAND_IDLE;
		end
	`NAND_INITWAIT	:	
		begin
		if (~RSTransferEnd&~NandReadWrite)
		NextNandState = `NAND_READ;
		else if (~RSTransferEnd&NandReadWrite)
		NextNandState = `NAND_WRITE;
		else if (RSTransferEnd | TransferError)
		NextNandState = `NAND_IDLE;
		else if (NandWait)
		NextNandState = `NAND_WAIT;
		end
	endcase
end

wire	SplitCnt0;
reg		[5:0]	SplitCnt;
reg		[5:0]	NextSplitCnt;
assign SplitCnt0 = (SplitCnt == 0);
// 1 request transfer Size
always @(SplitCnt or SplitCnt0 or NandState or NandREQ)
begin
	NextSplitCnt = SplitCnt;
	if (SplitCnt0 & NandREQ)
	NextSplitCnt = SplitSize;
	else if ((NandState==`NAND_READ)|(NandState==`NAND_WRITE))
	NextSplitCnt = SplitCnt -1 ;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	SplitCnt = 0;
	else
	SplitCnt = NextSplitCnt;
end


assign RSWait  =(NandReadWrite)? (~Bypass&RSEn_Wait) : (~Bypass&RSDe_Wait) ;
assign NandWait 	= (((~NandREQ) & SplitCnt0) |(RSWait)) ;
//assign TransferError= (~(NandState==`NAND_IDLE))&&NandStart;
assign TransferError= 0;

assign TransferEnd	= (BlkDatCnt==0)&&(BlkCnt == 0)&&
					((NandState==`NAND_READ)|(NandState==`NAND_WRITE));

assign TransferEnd2 = (DatCnt == BlkSize);
assign RSdisableTransferEnd = TransferEnd2 & Bypass;
assign RSTransferEnd = (TransferEnd)&~(Bypass) ;

assign BlkEnd = (BlkDatCnt==0);

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandState <= `NAND_IDLE;
	else
	NandState <= NextNandState;
end

always @(DatCnt or NandStart or NandState)
begin
	NextDatCnt = DatCnt;
	if (NandStart)
	NextDatCnt = 0;
	else if ((NandState== `NAND_READ) | (NandState== `NAND_WRITE))
	NextDatCnt = DatCnt +1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	DatCnt <= 0 ;
	else
	DatCnt <= NextDatCnt;
end

assign NandRAM_Addr = DatCnt;

assign BigBlockNand = (BlkSize == 2048);
assign SmallBlockNand = (BlkSize == 512);
assign BlkDatCnt0 = (BlkDatCnt==0);

always @(NandStart or BlkDatCnt0 or BigBlockNand or SmallBlockNand)
begin
	if (NandStart & (BigBlockNand | SmallBlockNand))
	NextBlkDatCnt =  512;
	else if (BlkDatCnt0 & (BigBlockNand|SmallBlockNand))
	NextBlkDatCnt =  512;
	else if ((NandState == `NAND_READ)|(NandState == `NAND_WRITE))
	NextBlkDatCnt = BlkDatCnt - 1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	BlkDatCnt <= 0;
	else
	BlkDatCnt <= NextBlkDatCnt;
end

always @(NandStart or BigBlockNand or SmallBlockNand)
begin
	NextBlkCnt = BlkCnt;
	if (NandStart & BigBlockNand)
	NextBlkCnt	= 4;
	else if (NandStart & SmallBlockNand)
	NextBlkCnt  = 1;
	else if (NandStart)
	NextBlkCnt  = 0;
	else if (BlkDatCnt == 0)
	NextBlkCnt = BlkCnt - 1;
end


always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	BlkCnt <= 0;
	else
	BlkCnt <= NextBlkCnt;
end

always @(NextNandState)
begin
	NextNandRAM_Wen = NandRAM_Wen;
	if (NextNandState == `NAND_WRITE)
	NextNandRAM_Wen = 1'b1;
	else
	NextNandRAM_Wen = 1'b0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandRAM_Wen <= 1'b0;
	else
	NandRAM_Wen <= NextNandRAM_Wen;
end


always @(NextNandState)
begin
	NextNandRAM_Oen = NandRAM_Oen;
	if (NextNandState == `NAND_READ)
	NextNandRAM_Oen = 1'b1;
	else
	NextNandRAM_Oen = 1'b0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandRAM_Oen <= 1'b0;
	else
	NandRAM_Oen <= NextNandRAM_Oen;
end

wire	RSEn_Wait;
wire	RSDe_Wait;
wire	RSEn_Start;
wire	RSDe_Start;
wire	NandF_WEn;
wire	NandF_OEn;

assign	RSEn_Wait = (NandState==`NAND_WAIT);
assign 	RSDe_Wait = (NandState==`NAND_WAIT);
assign 	RSEn_Start = ~RSMode & NandWriteStart & ~Bypass; 
assign 	RSDe_Start = RSMode & NandReadStart & ~Bypass; 

assign 	NandF_WEn = NandRAM_Oen;

assign 	NandF_OEn = NandRAM_Wen;



endmodule
