module tb_mmc_DataControl;
reg 		nRst;
reg		Clk;
reg		DPSMEn;
reg		ByteOrder;
reg	[22:0]	DataTimer;
reg 	[11:0]	BlkSize;
reg 		Burst4;
reg 	[1:0]	DataSize;
reg 		PrdType;
reg 		TARSP;
reg 		RACMD;
reg 		BACMD;
reg 		BlkMode;
reg 		WideBus;
reg 		MMCPlus;
reg		EnDMA;
reg 		DTST;
reg	[1:0] 	DatMode;
reg 	[11:0]	BlkNum;
reg			RxOverrun;
reg			TFDET;


wire	[11:0]	BlkNumCnt;
wire	[11:0]	BlkCnt;
wire		NoBusySet;
wire		RWaitReqSet;
wire		IOIntDetSet;
wire		CrcStaSeT;
wire		DatCrcSet;
wire		DatToutSet;
wire		DatFinSet;
wire		BusyFinSet;
wire		TxDatOn;
wire		RxDatOn;


wire		DTSTClr;
wire		RspFinSet;
wire		CmdSentSet;

wire		TxActive;
wire		TxWriteEn;
wire		TxRdPtrInc;
wire		RxActive;
wire		RxWriteEn;
wire		RxRdPtrInc;
wire	[31:0]	RxWrData;

wire		nDATEN;

wire		MMCICLK;
wire		DIVlevelCo;


reg	[31:0]	FIFODATA;

wire	[7:0]	DATOUT	;
wire	[7:0]	DATIN	;

reg		SELDAT;



reg	[7:0] 	SDIPRE;
reg		ENCLK;
reg	[7:0]	DATINPUT;

assign DATIN = (SELDAT == 1'b1)? DATOUT:DATINPUT;

initial 
begin
	Clk = 1'b0;
	nRst = 1'b0 ;
	SDIPRE = 8'h10;
	ENCLK = 1'b1;
	#50 nRst = 1'b1;
end
always #5 Clk = ~Clk ;


initial
begin
	SELDAT = 1'b1;
	ByteOrder = 1'b1 ;
	DataTimer = 23'd200;
	BlkSize	= 12'd511;
	
	Burst4 = 1'b1;
	DataSize = 2'b10;
//	PrdType = ;
	TARSP = 1'b0;
	RACMD = 1'b0;
	BACMD = 1'b0;

	BlkMode = 1'b1;
	
	WideBus = 1'b1;
	MMCPlus = 1'b1;
	EnDMA = 1'b1;

 	DatMode = 2'b11;
	BlkNum = 12'd90;
	FIFODATA = 32'h04030201;
	DTST = 1'b1;
	#100 DTST = 1'b0;

//---------------crc check bit transmit--------------
// 010 : no error condition
// 101 : error condition

	@(negedge TxDatOn);
	@(posedge DIVlevelCo);
	
	@(posedge DIVlevelCo);
	#10 DATINPUT = 1'b0; // start bit
	SELDAT = 1'b0;
	@(posedge DIVlevelCo);
	#10 DATINPUT = 1'b0; // 101
	@(posedge DIVlevelCo);
	#10 DATINPUT = 1'b1; // 101
	@(posedge DIVlevelCo);
	#10 DATINPUT = 1'b0; // 101
	@(posedge DIVlevelCo);
	#10 DATINPUT = 1'b1; // endbit
		
	repeat(100)begin
		@(negedge TxDatOn);
		@(posedge DIVlevelCo);
		#10 DATINPUT = 1'b0; // start bit
		   SELDAT = 1'b0;
		@(posedge DIVlevelCo);
		#10 DATINPUT = 1'b0; // 101
		@(posedge DIVlevelCo);
		#10 DATINPUT = 1'b1; // 101
		@(posedge DIVlevelCo);
		#10 DATINPUT = 1'b0; // 101
		@(posedge DIVlevelCo);
		#10 DATINPUT = 1'b1; // endbit
	end


end


mmc_Prescaler Prescaler(
	.nRst		(nRst),
	.Clk		(Clk),
	.SDIPRE		(SDIPRE),
	.ENCLK		(ENCLK),
// Outputs
	.MMC_CLK	(MMCICLK),
    	.DIVlevelCo	(DIVlevelCo)
	);

mmc_DataControl DataControl(
	.nRst		(nRst),
	.Clk		(Clk),
	.DIVlevelCo	(DIVlevelCo),      
   	.DPSMEn		(1'b1),

	// register input
	.ByteOrder	(ByteOrder),
	.DataTimer	(DataTimer),
	.BlkSize	(BlkSize),
	.Burst4		(Burst4),
	.DataSize	(DataSize),	
	.PrdType	(PrdType),
	.TARSP		(TARSP),
	.RACMD		(RACMD),
	.BACMD		(BACMD),
	.BlkMode	(BlkMode),
	.WideBus	(WideBus),
	.MMCPlus	(MMCPlus), // adding for MMCPlus Mode( 8bit DAT line)
	.EnDMA		(EnDMA),
	.DTST		(DTST),
	.DatMode	(DatMode),
	.BlkNum		(BlkNum),

	.AbortCmdComp	(), // CMD12,CMD52등의 command가 완료되었는지를 나타내는 입력 
	// register output
	.BlkNumCnt	(BlkNumCnt),
	.BlkCnt		(BlkCnt),
	.NoBusySet	(NoBusySet),
	.RWaitReqSet(RWaitReq),
	.IOIntDetSet(IOIntDet),
	.CrcStaSet	(CrcStaSet),
	.DatCrcSet	(DatCrcSet),
	.DatToutSet	(DatToutSet),
	.DatFinSet	(DatFin),
	.BusyFinSet	(BusyFin),


	.TxDatOn	(TxDatOn),
	.RxDatOn	(RxDatOn),
    

    .DTSTClr	(DTSTClr),	
	.RspFinSet	(RspFinSet),
	.CmdSentSet	(CmdSentSet),

	.TxActive	(TxActive),
	.TxRdPtrInc	(TxRdPtrInc),
	.RxActive	(RxActive),
	.RxWriteEn	(RxWriteEn),
	.RxWrData	(RxWrData),

	.RxOverrun	(RxOverrun),
	.TFDET		(TFDET),
	.FRdDataCo	(FIFODATA),

	.nDATEN		(nDATEN),
	.DATOUT		(DATOUT),
	.DATIN		(DATIN) );


endmodule
