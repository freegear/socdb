module nandrsif(
	RESETn,
	CLK,

	BlkSize,
	NandStart,
	NandRead,
	NandWrite,
	RSEn_Enable,
	RSDe_Enable,

	NandREQ,
	SplitSize,

	NandRAM_Addr,
	Nand_Wen,
	NandRAM_DATAi,
	NandRAM_DATAo,

	NandReadData,
	NandWriteData,
	NandRW,
	NandEnable,

	RSEn_Start,
	RSEn_Wait,
	RSDe_Start,
	RSDe_Wait,
	TransferEnd

);

input 			RESETn;
input 			CLK;

input			BlkSize;
input			NandStart;
input			NandRead;
input			NandWrite;
input			RSEn_Enable;
input			RSDe_Enable;

input 			NandREQ;
input	[5:0]	SplitSize;

output 	[10:0] 	NandRAM_Addr;
output 			Nand_Wen; 
output 	[7:0]	NandRAM_DATAi; 
input 	[7:0] 	NandRAM_DATAo; 
input	[7:0]	NandReadData;
output	[7:0]	NandWriteData;
output			NandRW;
output			NandEnable;

output			RSEn_Start;
output			RSEn_Wait;

output			RSDe_Start;
output			RSDe_Wait;
output			TransferEnd;

wire			NandReadStart;
wire			NandWriteStart;
wire			NandWait;
wire			TransferError;
assign 			NandReadStart 	= NandStart & NandRead ; 
assign 			NandWriteStart	= NandStart & NandWrite;

`define NAND_IDLE 		5'b00001
`define NAND_READ	 	5'b00010
`define NAND_WRITE	 	5'b00100
`define NAND_WAIT		5'b01000
`define NAND_END		5'b10000

reg 	[4:0]	NextNandState;
reg		[4:0]	NandState;
reg 			NextNand_Wen;
reg				Nand_Wen;
reg	[10:0]	NextDatCnt;
reg [10:0]	DatCnt;
reg	[10:0]	NextNandRAM_Addr;
reg	[10:0]	NandRAM_Addr;

always @(NandState or NandReadStart or NandWriteStart or NandWait or NandRead or NandWrite or TransferEnd or TransferError)
begin
	NextNandState = NandState;
	case (NandState)
	`NAND_IDLE	:
		begin
		if (NandWait)
		NextNandState = `NAND_WAIT;
		else if (NandReadStart)
		NextNandState = `NAND_READ;
		else if(NandWriteStart)
		NextNandState = `NAND_WRITE;
		end
	`NAND_READ:	
		begin
		if (NandWait)
		NextNandState = `NAND_WAIT;
		else if (TransferError|TransferEnd)
		NextNandState = `NAND_END;
		end
	`NAND_WRITE:
		begin
		if (NandWait)
		NextNandState = `NAND_WAIT;
		else if (TransferError|TransferEnd)
		NextNandState = `NAND_END;
		end
	`NAND_WAIT	:	
		begin
		if (NandRead&~NandWait)
		NextNandState = `NAND_READ;
		else if (NandWrite & ~NandWait)
		NextNandState = `NAND_WRITE;
		else if (TransferError)
		NextNandState = `NAND_IDLE;
		end
	`NAND_END	:	
		begin
		NextNandState = `NAND_IDLE;
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

assign NandWait 	= (~NandREQ) & SplitCnt0 ;
assign TransferError= (~(NandState==`NAND_IDLE))&&NandStart;
assign TransferEnd	= (DatCnt==0)&&((NandState==`NAND_READ)|(NandState==`NAND_WRITE));

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandState <= `NAND_IDLE;
	else
	NandState <= NextNandState;
end

always @(DatCnt or BlkSize or NandStart)
begin
	NextDatCnt = DatCnt;
	if (BlkSize & NandStart)
	NextDatCnt = 2047;
	else if (BlkSize & NandStart)
	NextDatCnt = 511;
	else if ((NandState== `NAND_READ) | (NandState== `NAND_WRITE))
	NextDatCnt = DatCnt -1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	DatCnt <= 1 ;
	else
	DatCnt <= NextDatCnt;
end


always @(NandRAM_Addr or NandStart or NandState)
begin
	NextNandRAM_Addr = NandRAM_Addr;
	if (NandStart)
	NextNandRAM_Addr = 0;
	else if ((NandState==`NAND_READ)|(NandState==`NAND_WRITE))
	NextNandRAM_Addr = NandRAM_Addr + 1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	NandRAM_Addr <= 0;
	else
	NandRAM_Addr <= NextNandRAM_Addr;
end

always @(NextNandState)
begin
	NextNand_Wen = Nand_Wen;
	if (NextNandState == `NAND_WRITE)
	NextNand_Wen = 1'b1;
	else
	NextNand_Wen = 1'b0;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	Nand_Wen <= 1'b0;
	else
	Nand_Wen <= NextNand_Wen;
end

assign 	NandRAM_DATAi = NandReadData; // from Nand to RAM
assign	NandWriteData = NandRAM_DATAo; //from RAM to Nand
assign	RSEn_Wait = (NandState==`NAND_WAIT);
assign 	RSDe_Wait = (NandState==`NAND_WAIT);
assign 	RSEn_Start = NandWriteStart & RSEn_Enable; 
assign 	RSDe_Start = NandReadStart & RSDe_Enable; 



endmodule
