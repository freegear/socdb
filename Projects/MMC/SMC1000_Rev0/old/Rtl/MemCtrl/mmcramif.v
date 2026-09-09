module mmcramif
(
	CLK,
	RESETn,

	TransferBlkAddr, // mmc ram address
	TransferSize,
	TransferStart,
	TransferAbort,
	TransferEnd,
	
	si_wrb,
	si_rdb,
	mmc_rdy_b,
	MMCRAM_Addr,
	MMC_Wen_b
);

input			CLK;
input			RESETn;

input	[10:0]	TransferBlkAddr;
input	[9:0]	TransferSize;
input			TransferStart;
input			TransferAbort;
output			TransferEnd;

input			si_wrb;
input			si_rdb;

output			mmc_rdy_b;

// MMC RAM Address Generation
output	[10:0]	MMCRAM_Addr;
output			MMC_Wen_b;

`define IDLE	 	2'b01
`define TRANSFER	2'b10

// MMC RAM Selecti & Flow Control State Machine

reg 	[1:0]	NextMRAMState;
reg 	[1:0]	MRAMState;
reg 			NextReady;
reg 			Ready;

reg		[10:0]	MMCRAM_Addr;
reg		[10:0]	NextMMCRAM_Addr;

reg 	[11:0]	NextBlkDatCnt;
reg 	[11:0]	BlkDatCnt;

wire			TransferEnd;

assign 			TransferEnd =(BlkDatCnt == 0) & MRAMState[1] ;
//assign			MMC_Wen_b= (si_wrb |~(MRAMState==`TRANSFER));
assign			MMC_Wen_b= (si_wrb |~(MRAMState[1]));

always @(MMCRAM_Addr or BlkDatCnt or TransferStart or TransferBlkAddr or TransferSize or MRAMState or si_wrb or si_rdb)
begin
	NextMMCRAM_Addr= MMCRAM_Addr;
	NextBlkDatCnt = BlkDatCnt;
	if (TransferStart)
	begin
	NextMMCRAM_Addr = TransferBlkAddr;
	NextBlkDatCnt = TransferSize;
	end
//	else if ( (MRAMState==`TRANSFER)&& ((~si_wrb)|(~si_rdb)) )
	else if ( (MRAMState[1])&& ((~si_wrb)|(~si_rdb)) )
	begin
	NextMMCRAM_Addr = MMCRAM_Addr + 1;
	NextBlkDatCnt = BlkDatCnt - 1;
	end
end

always @(posedge CLK or negedge RESETn)
begin
	if(!RESETn)
	MMCRAM_Addr <= 0;
	else
	MMCRAM_Addr <= NextMMCRAM_Addr;
end


always @(MRAMState or TransferStart or TransferAbort or TransferEnd)
begin
	NextMRAMState = MRAMState;
	case (1'b1)
	MRAMState[0]:	begin
					if (TransferStart)
					NextMRAMState = `TRANSFER;
					end 
	MRAMState[1]:	begin
					if (TransferAbort | TransferEnd)
					NextMRAMState = `IDLE;
					end
	default 	: 	NextMRAMState = `IDLE; 
	endcase
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	MRAMState <= `IDLE; 
	else
	MRAMState <= NextMRAMState; 
end

always @(Ready or NextMRAMState[1])
begin
	NextReady = Ready;
//	if (NextMRAMState == `TRANSFER)
	if (NextMRAMState[1])
		NextReady = 1'b0;
	else
		NextReady = 1'b1;
end

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	Ready <= 1'b1;
	else
	Ready <= NextReady;
end

assign mmc_rdy_b = Ready;

always @(posedge CLK or negedge RESETn)
begin
	if (!RESETn)
	BlkDatCnt <=0;
	else
	BlkDatCnt <= NextBlkDatCnt;
end

endmodule
