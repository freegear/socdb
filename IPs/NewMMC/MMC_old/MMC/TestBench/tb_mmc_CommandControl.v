module tb_mmc_CommandControl();

reg	nRst;
reg	Clk;
//reg	CMDIN;
wire	CMDIN;
wire	CMDOUT;
wire 	nCMDEN;

reg	Pending;
reg	PendPulse;
reg	PendLatch;

reg	CPSMEn;
// register input
reg	[31:0]	CmdArg; 	// command argument
reg	AbortCmd;
reg	WithData;
reg	LongRsp;
reg	WaitRsp;
reg	CMST;
reg	[7:0]	CmdIndex;
// register Clear signal
/*	RspClrPulse;
	CmdSentClrPulse;
	CmdToutClrPulse;
	RspFinClrPulse;
*/
// register output



wire 	DIVlevelCo;
wire	RspCrcSet;
wire	CmdSentSet; 
wire	CmdToutSet;
wire	RspFinSet;
wire	CmdOn;
wire	[7:0]	RspIndex;
wire	[31:0]	Response0;
wire	[31:0]	Response1;
wire	[31:0]	Response2;
wire	[31:0]	Response3;

reg	CMDINPUT;
reg	SELCMD;
assign CMDIN = (SELCMD == 1'b1)? CMDOUT:CMDINPUT;

reg [7:0] SDIPRE;
reg	ENCLK;

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
	SELCMD	= 1'b1;

	CmdArg = 32'h0000;
	PendLatch = 1'b1;
	LongRsp = 1'b1;
	WaitRsp = 1'b1; // no wait response
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


	#500
	@(negedge CmdSentSet);
		CMDINPUT = 1'b0;
		SELCMD = 1'b0;
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[7];
	@(negedge DIVlevelCo)
		CMDINPUT = 1'b0;
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[5];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[4];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[3];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[2];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[1];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[0];

	@(negedge DIVlevelCo)
		CMDINPUT = 1'b1;
	@(negedge DIVlevelCo)
		CMDINPUT = 1'b0;
	@(negedge DIVlevelCo)
		CMDINPUT = 1'b1;
	@(negedge DIVlevelCo)
		CMDINPUT = 1'b0;
	@(negedge DIVlevelCo)
		CMDINPUT = 1'b0;
	@(negedge DIVlevelCo)
		CMDINPUT = 1'b0;
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[0];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[0];
	@(negedge DIVlevelCo)
		CMDINPUT= CmdIndex[0];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[0];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[0];
	@(negedge DIVlevelCo)
		CMDINPUT = CmdIndex[0];

end




mmc_Prescaler Prescaler(
	.nRst	(nRst),
	.Clk	(Clk),
	.SDIPRE	(SDIPRE),
	.ENCLK	(ENCLK),
// Outputs
	.MMC_CLK(MMCICLK),
        .DIVlevelCo(DIVlevelCo)
	);


mmc_CommandControl controltest(
	.nRst		(nRst),
	.Clk		(Clk),
	.DIVlevelCo	(DIVlevelCo),

	.CMDIN		(CMDIN),
	.CMDOUT		(CMDOUT),
	.nCMDEN		(nCMDEN),

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
	.RspCrcSet	(),
	.RspCrc		(),
	
	.CmdSentSet	(CmdSentSet),
	.CmdToutSet	(CmdToutSet),
	.RspFinSet	(RspFinSet),
	.CmdOn		(CmdOn)	,
	.RspIndex	(RspIndex),
	.Response0	(Response0),
	.Response1	(Response1),
	.Response2	(Response2),
	.Response3	(Response3)

// interrupt signal output	

);



endmodule

