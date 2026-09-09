module mmcramif
(
	sdclk,
	hreset_b,
	
	be_b,
	blast_b,
	mmc_rdy_b,

//CPU INPUT
	Cpu_ABORT,
	Cpu_Size,
	ERROR,
	ReadStart,
	WriteStart,
	MMCStartClr,
	TransferEnd,

	MMCRAM_Addr,
	MMC_Wen

);

input			sdclk;
input			hreset_b;

input	[3:0]	be_b; //from MMC ip
input			blast_b;
output			mmc_rdy_b;

input			Cpu_ABORT;
input	[9:0]	Cpu_Size;
input			ERROR;
input			ReadStart;
input			WriteStart;
output			MMCStartClr;
output			TransferEnd;

// MMC RAM Address Generation
output	[10:0]	MMCRAM_Addr;
output			MMC_Wen;

`define IDLE 	3'b001
`define READ 	3'b010
`define WRITE 	3'b100

// MMC RAM Selecti & Flow Control State Machine
// BE [3:0] = > CEN3~0

// IDLE
// READ
// WRITE

reg 	[2:0]	NextMDataState;
reg 	[2:0]	MDataState;
reg 			NextReady;
reg 			Ready;

wire			TransferEnd;

reg		[10:0]	MMCRAM_Addr;
reg		[10:0]	NextMMCRAM_Addr;

reg				NextMMC_Wen;
reg				MMC_Wen;

always @(MMCRAM_Addr or ReadStart or WriteStart or MDataState)
begin
	NextMMCRAM_Addr= MMCRAM_Addr;
	if (ReadStart|WriteStart)
	NextMMCRAM_Addr = 0;
	else if ((MDataState==`READ)|(MDataState==`WRITE))
	NextMMCRAM_Addr = MMCRAM_Addr +1;
end

always @(posedge sdclk or negedge hreset_b)
begin
	if(!hreset_b)
	MMCRAM_Addr <= 0;
	else
	MMCRAM_Addr <= NextMMCRAM_Addr;
end

reg MMCStartClr;
always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	MMCStartClr <= 0;
	else if (ReadStart|WriteStart)
	MMCStartClr <= 1;
	else
	MMCStartClr <= 0;
end



always @(MDataState or Cpu_ABORT or ERROR or ReadStart or WriteStart or TransferEnd)
begin
	NextMDataState = MDataState;
	case (MDataState)
	`IDLE :
		begin
		if (ReadStart)
		NextMDataState = `READ;
		else if (WriteStart)
		NextMDataState = `WRITE;
		end 
	`READ : 
		begin
		if (WriteStart)
		NextMDataState = `WRITE;
		else if (Cpu_ABORT | TransferEnd | ERROR)
		NextMDataState = `IDLE;
		end
	`WRITE :
		begin
		if (ReadStart)
		NextMDataState = `READ;
		else if (Cpu_ABORT | TransferEnd | ERROR)
		NextMDataState = `IDLE;
		end
	default : NextMDataState = `IDLE; 
	endcase
end

always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	MDataState <= `IDLE; 
	else
	MDataState <= NextMDataState; 
end

//always @(Ready or MDataState)
always @(Ready or NextMDataState)
begin
	NextReady = Ready;
	if ((NextMDataState == `READ)|(NextMDataState == `WRITE))
		NextReady = 1'b0;
	else
		NextReady = 1'b1;
end

always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	Ready <= 1'b1;
	else
	Ready <= NextReady;
end

assign mmc_rdy_b = Ready;

reg [11:0]	NextBlkDatCnt;
reg [11:0]	BlkDatCnt;

assign TransferEnd =(BlkDatCnt == 0) | ((blast_b==0)&(mmc_rdy_b==0));

always @(BlkDatCnt or ReadStart or WriteStart)
begin
	NextBlkDatCnt = BlkDatCnt;
	if (ReadStart | WriteStart)
	NextBlkDatCnt = Cpu_Size;
	else if ((MDataState == `READ)|(MDataState == `WRITE))
//	NextBlkDatCnt = BlkDatCnt - 4;
	NextBlkDatCnt = BlkDatCnt - 1;
end

always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	BlkDatCnt <=0;
	else
	BlkDatCnt <= NextBlkDatCnt;
end

always @(MMC_Wen or NextMDataState)
begin
	NextMMC_Wen = MMC_Wen;
	if (NextMDataState == `WRITE )
		MMC_Wen = 1'b1;
	else
		MMC_Wen = 1'b0;
end

always @(posedge sdclk or negedge hreset_b)
begin
	if (!hreset_b)
	MMC_Wen <=0;
	else
	MMC_Wen <= NextMMC_Wen;
end

endmodule
