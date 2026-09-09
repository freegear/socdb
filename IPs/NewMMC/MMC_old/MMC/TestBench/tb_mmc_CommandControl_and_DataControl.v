module tb_mmc_CommandControl_and_DataControl;
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



reg	CMDIN;
wire	CMDOUT;

reg	Pending;
reg	PendPulse;
reg	PendLatch;

reg	CPSMEn;

// register input
reg	[31:0]	CmdArg; 	// command argument
reg		AbortCmd;
reg		WithData;
reg		LongRsp;
reg		WaitRsp;
reg		CMST;
reg	[7:0]	CmdIndex;


wire	CmdSentSet;
wire	CmdToutSet;
wire	RspFinSet;
wire	CmdOn;
wire	[7:0]	RspIndex;
wire	[31:0]	Response0;
wire	[31:0]	Response1;
wire	[31:0]	Response2;
wire	[31:0]	Response3;


wire	[11:0]	BlkNumCnt;
wire	[11:0]	BlkCnt;
wire		NoBusy;
wire		RWaitReq;
wire		IOIntDet;
wire		CrcSta;
wire		DatCrc;
wire		DatTout;
wire		DatFin;
wire		BusyFin;
wire		TxDatOn;
wire		RxDatOn;
    
reg		ResponseComplete;
reg	[31:0]	FIFODATA;

wire	[7:0]	DATOUT	;
reg	[7:0]	DATIN	;




reg	 [7:0] 	SDIPRE;
reg		ENCLK;

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
	CMST	= 1'b0;
	CmdArg = 32'h0000;
	PendLatch = 1'b1;
	LongRsp = 1'b1;
	WaitRsp = 1'b0; // no wait response
	CmdIndex = 8'b01000001;
	#200
	CMST= 1'b1;
	#200
	CMST = 1'b0;

	#500000
	WaitRsp = 1'b1;
	CmdIndex = 8'b01000101;
	#200
	CMST= 1'b1;
	#200
	CMST = 1'b0;

end

initial
begin
//	ByteOrder = 1'b1 ;
	DataTimer = 23'd200;
	BlkSize	= 12'd511;

//	Burst4 = 1'b1;
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
	BlkNum = 12'd2;	
	FIFODATA = 32'h04030201;
	DTST = 1'b1;
	#100 DTST = 1'b0;


end


mmc_Prescaler Prescaler(
	.nRst	(nRst),
	.Clk	(Clk),
	.SDIPRE	(SDIPRE),
	.ENCLK	(ENCLK),
// Outputs
	.MMCICLK(MMCICLK),
        .DIVlevelCo(DIVlevelCo)
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

	// register output
	.BlkNumCnt	(BlkNumCnt),
	.BlkCnt		(BlkCnt),
	.NoBusy		(NoBusy),
	.RWaitReq	(RWaitReq),
	.IOIntDet	(IOIntDet),
	.CrcStaSet	(CrcStaSet),
	.DatCrcSet	(DatCrcSet),
	.DatToutSet	(DatToutSet),
	.DatFin		(DatFin),
	.BusyFin	(BusyFin),


	.TxDatOn	(TxDatOn),
	.RxDatOn	(RxDatOn),
    
	.RspFinSet	(RspFinSet),
	.CmdSentSet	(CmdSentSet),
	.FRdDataCo	(FIFODATA),

	.DATOUT		(DATOUT),
	.DATIN		(DATOUT) );

mmc_CommandControl controltest(
	.nRst		(nRst),
	.Clk		(Clk),
	.DIVlevelCo	(DIVlevelCo),

	.CMDIN		(CMDOUT),
	.CMDOUT		(CMDOUT),

	.Pending	(),
	.PendPulse	(),
	.PendLatch	(PendLatch),

	.CPSMEn		(CPSMEn),

// register input
	.CmdArg		(CmdArg), 	// command argument
	.AbortCmd	(),		// Support for SDIO 
	.WithData	(),		// Support for SDIO
	.LongRsp	(LongRsp),
	.WaitRsp	(WaitRsp),
	.CMSTSync	(CMST),
	.CMSTClr	(),
	.CmdIndex(CmdIndex),
// register Clear signal
	.RspClrPulse	()	,


// register output
	.RspCrc	(RspCrc),
	.CmdSentSet(CmdSentSet), // register와 data block에서 필요
	.CmdToutSet(CmdToutSet),
	.RspFinSet(RspFinSet),// register 와 data block에서 필요
	.CmdOn	(CmdOn)	,
	.RspIndex(RspIndex),
	.Response0(Response0),
	.Response1(Response1),
	.Response2(Response2),
	.Response3(Response3)

// interrupt signal output	

);


endmodule

