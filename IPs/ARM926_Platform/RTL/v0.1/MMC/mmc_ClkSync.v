`timescale 1ns/10ps
module mmc_PCLKSync (
//input
	PCLK,
	nRst,
	SDreset,

	TxActive,
	TxRdPtrInc,
	RxActive,
	RxWriteEn,
	RxFWrData,

	RspCrcSet,
	CmdSentSet,
	CmdToutSet,
	RspFinSet,

	NoBusySet,
	CrcStaSet,
	DatCrcSet,
	DatToutSet,
	DatFinSet,
	BusyFinSet,

	SDIPREUpdDone,  
	SDICmdArgUpdDone,
	SDICmdConUpdDone,
	SDIDatConUpdDone,
	SDIDTimerUpdDone,
	SDIBSizeUpdDone,
	SDIAutoReadConUpdDone,	
	ErrorState,
	AutoReadComplete,

//output
	TxActiveSync,
	TxRdPtrIncSync,
	RxActiveSync,
	RxWriteEnSync,
	RxFWrDataSync,

	RspCrcSetSync,
	CmdSentSetSync,
	CmdToutSetSync,
	RspFinSetSync,
	
	NoBusySetSync,
	CrcStaSetSync,
	DatCrcSetSync,
	DatToutSetSync,
	DatFinSetSync,
	BusyFinSetSync,

	SDIPREUpdDoneSync,
        SDICmdArgUpdDoneSync,
        SDICmdConUpdDoneSync,
        SDIDatConUpdDoneSync,
        SDIDTimerUpdDoneSync,
        SDIBSizeUpdDoneSync,
	SDIAutoReadConUpdDoneSync,
	ErrorStateSync,
	AutoReadCompleteSync
	);

input	PCLK;
input	nRst;
input	SDreset;

input	TxActive;
input	TxRdPtrInc;
input	RxActive;
input	RxWriteEn;
input	[31:0]	RxFWrData;

input	RspCrcSet;
input	CmdSentSet;
input	CmdToutSet;
input	RspFinSet;

input   NoBusySet;
input	CrcStaSet;
input	DatCrcSet;
input	DatToutSet;
input   DatFinSet;
input	BusyFinSet;

input	SDIPREUpdDone;
input   SDICmdArgUpdDone;
input   SDICmdConUpdDone;
input	SDIDatConUpdDone;
input	SDIDTimerUpdDone;
input	SDIBSizeUpdDone;
input	SDIAutoReadConUpdDone;
input	[1:0]	ErrorState;
input	AutoReadComplete;

output	TxActiveSync;
output	TxRdPtrIncSync;
output	RxActiveSync;
output	RxWriteEnSync;
output	[31:0]	RxFWrDataSync;

output	RspCrcSetSync;
output	CmdSentSetSync;
output	CmdToutSetSync;
output	RspFinSetSync;

output  NoBusySetSync;
output	CrcStaSetSync;
output	DatCrcSetSync;
output	DatToutSetSync;
output	DatFinSetSync;
output	BusyFinSetSync;

output	SDIPREUpdDoneSync;
output  SDICmdArgUpdDoneSync;
output  SDICmdConUpdDoneSync;
output	SDIDatConUpdDoneSync;
output  SDIDTimerUpdDoneSync;
output	SDIBSizeUpdDoneSync;
output	SDIAutoReadConUpdDoneSync;
output	[1:0] ErrorStateSync;
output	AutoReadCompleteSync;

reg	TxActiveSync1;
reg	TxRdPtrIncSync1;
reg	RxActiveSync1;
reg	RxWriteEnSync1;
reg	[31:0]	RxFWrDataSync1;
reg	TxActiveSync;
reg	TxRdPtrIncSync;
reg	RxActiveSync;
reg	RxWriteEnSync;
reg	[31:0]	RxFWrDataSync;


reg	RspCrcSetSync;
reg	CmdSentSetSync;
reg	CmdToutSetSync;
reg	RspFinSetSync;

reg	NoBusySetSync;
reg	CrcStaSetSync;
reg	DatCrcSetSync;
reg	DatToutSetSync;
reg	DatFinSetSync;
reg	BusyFinSetSync;


reg     RspCrcSetSync1;
reg     CmdSentSetSync1;
reg     CmdToutSetSync1;
reg     RspFinSetSync1;

reg     NoBusySetSync1;
reg     CrcStaSetSync1;
reg     DatCrcSetSync1;
reg     DatToutSetSync1;
reg     DatFinSetSync1;
reg     BusyFinSetSync1;

reg	SDIPREUpdDoneSync1;
reg	SDIPREUpdDoneSync;
reg	SDICmdArgUpdDoneSync1;
reg	SDICmdArgUpdDoneSync;
reg	SDICmdConUpdDoneSync1;
reg	SDICmdConUpdDoneSync;
reg	SDIDatConUpdDoneSync1;
reg	SDIDatConUpdDoneSync;
reg	SDIDTimerUpdDoneSync1;
reg	SDIDTimerUpdDoneSync;
reg	SDIBSizeUpdDoneSync1;
reg	SDIBSizeUpdDoneSync;
reg	SDIAutoReadConUpdDoneSync1;
reg	SDIAutoReadConUpdDoneSync;

reg	[1:0]	ErrorStateSync1;
reg	[1:0]	ErrorStateSync;

reg	AutoReadCompleteSync1;
reg	AutoReadCompleteSync;


always @(posedge PCLK or negedge nRst)
begin
	if (!nRst)
	begin
	TxActiveSync1	<= 1'b0;
	TxActiveSync	<= 1'b0;
	TxRdPtrIncSync1	<= 1'b0;
	TxRdPtrIncSync	<= 1'b0;
	RxActiveSync1	<= 1'b0;
	RxActiveSync	<= 1'b0;
	RxWriteEnSync1	<= 1'b0;
	RxWriteEnSync	<= 1'b0;
	RxFWrDataSync1	<= 32'd0;
	RxFWrDataSync	<= 32'd0;

	RspCrcSetSync1	<= 1'b0;
	RspCrcSetSync	<= 1'b0;
	CmdSentSetSync1	<= 1'b0;
	CmdSentSetSync	<= 1'b0;
	CmdToutSetSync1	<= 1'b0;
	CmdToutSetSync	<= 1'b0;

	RspFinSetSync1  <= 1'b0;
    	RspFinSetSync   <= 1'b0;
    	NoBusySetSync1  <= 1'b0;
    	NoBusySetSync   <= 1'b0;
    	CrcStaSetSync1  <= 1'b0;
    	CrcStaSetSync  	<= 1'b0;
   	DatCrcSetSync1  <= 1'b0;
    	DatCrcSetSync   <= 1'b0;
    	DatToutSetSync1 <= 1'b0;
    	DatToutSetSync  <= 1'b0;
    	DatFinSetSync1  <= 1'b0;
    	DatFinSetSync   <= 1'b0;
    	BusyFinSetSync1 <= 1'b0;
    	BusyFinSetSync  <= 1'b0;
	SDIPREUpdDoneSync1<= 1'b0;
	SDIPREUpdDoneSync <= 1'b0;
	SDICmdArgUpdDoneSync1<= 1'b0;
	SDICmdArgUpdDoneSync<= 1'b0;
	SDICmdConUpdDoneSync1<= 1'b0;
	SDICmdConUpdDoneSync<= 1'b0;
	SDIDatConUpdDoneSync1<= 1'b0;
	SDIDatConUpdDoneSync<= 1'b0;
	SDIDTimerUpdDoneSync1<=1'b0;
	SDIDTimerUpdDoneSync<= 1'b0;
	SDIBSizeUpdDoneSync1<=1'b0;
	SDIBSizeUpdDoneSync<= 1'b0;
	SDIAutoReadConUpdDoneSync1 <= 1'b0;
	SDIAutoReadConUpdDoneSync <= 1'b0;
	ErrorStateSync1	<=2'b00;
	ErrorStateSync	<= 2'b00;

	AutoReadCompleteSync1 <= 1'b0;
	AutoReadCompleteSync	<= 1'b0;
	end
	else
	begin
	if (SDreset)
	begin
	TxActiveSync1	<= 1'b0;
	TxActiveSync	<= 1'b0;
	TxRdPtrIncSync1	<= 1'b0;
	TxRdPtrIncSync	<= 1'b0;
	RxActiveSync1	<= 1'b0;
	RxActiveSync	<= 1'b0;
	RxWriteEnSync1	<= 1'b0;
	RxWriteEnSync	<= 1'b0;
	RxFWrDataSync1	<= 32'd0;
	RxFWrDataSync	<= 32'd0;

	RspCrcSetSync1	<= 1'b0;
	RspCrcSetSync	<= 1'b0;
	CmdSentSetSync1	<= 1'b0;
	CmdSentSetSync	<= 1'b0;
	CmdToutSetSync1	<= 1'b0;
	CmdToutSetSync	<= 1'b0;

	RspFinSetSync1  <= 1'b0;
    	RspFinSetSync   <= 1'b0;
    	NoBusySetSync1  <= 1'b0;
    	NoBusySetSync   <= 1'b0;
    	CrcStaSetSync1  <= 1'b0;
    	CrcStaSetSync  	<= 1'b0;
   	DatCrcSetSync1  <= 1'b0;
    	DatCrcSetSync   <= 1'b0;
    	DatToutSetSync1 <= 1'b0;
    	DatToutSetSync  <= 1'b0;
    	DatFinSetSync1  <= 1'b0;
    	DatFinSetSync   <= 1'b0;
    	BusyFinSetSync1 <= 1'b0;
    	BusyFinSetSync  <= 1'b0;
	SDIPREUpdDoneSync1<= 1'b0;
	SDIPREUpdDoneSync <= 1'b0;
	SDICmdArgUpdDoneSync1<= 1'b0;
	SDICmdArgUpdDoneSync<= 1'b0;
	SDICmdConUpdDoneSync1<= 1'b0;
	SDICmdConUpdDoneSync<= 1'b0;
	SDIDatConUpdDoneSync1<= 1'b0;
	SDIDatConUpdDoneSync<= 1'b0;
	SDIDTimerUpdDoneSync1<=1'b0;
	SDIDTimerUpdDoneSync<= 1'b0;
	SDIBSizeUpdDoneSync1<=1'b0;
	SDIBSizeUpdDoneSync<= 1'b0;
	SDIAutoReadConUpdDoneSync1 <= 1'b0;
	SDIAutoReadConUpdDoneSync <= 1'b0;
	ErrorStateSync1<= 2'b00;
	ErrorStateSync	<= 2'b00;
	AutoReadCompleteSync1	<= 1'b0;
	AutoReadCompleteSync	<= 1'b0;
	end
	else
	begin
	TxActiveSync1	<= TxActive;
	TxActiveSync	<= TxActiveSync1;
	TxRdPtrIncSync1	<= TxRdPtrInc;
	TxRdPtrIncSync	<= TxRdPtrIncSync1;
	RxActiveSync1	<= RxActive;
	RxActiveSync	<= RxActiveSync1;
	RxWriteEnSync1	<= RxWriteEn;
	RxWriteEnSync	<= RxWriteEnSync1;
	RxFWrDataSync1	<= RxFWrData;
	RxFWrDataSync	<= RxFWrDataSync1;

	RspCrcSetSync1 	<= RspCrcSet;
	RspCrcSetSync	<= RspCrcSetSync1;
	CmdSentSetSync1	<=CmdSentSet;
	CmdSentSetSync <= CmdSentSetSync1;
	CmdToutSetSync1	<=CmdToutSet;
	CmdToutSetSync	<=CmdToutSetSync1;
	RspFinSetSync1	<=RspFinSet;
	RspFinSetSync	<=RspFinSetSync1;
	NoBusySetSync1	<=NoBusySet;
	NoBusySetSync	<= NoBusySetSync1;
	CrcStaSetSync1	<= CrcStaSet;
	CrcStaSetSync  <= CrcStaSetSync1;
	DatCrcSetSync1	<= DatCrcSet;
	DatCrcSetSync	<= DatCrcSetSync1;
	DatToutSetSync1	<= DatToutSet;
	DatToutSetSync	<= DatToutSetSync1;
	DatFinSetSync1	<=DatFinSet;
	DatFinSetSync	<= DatFinSetSync1;
	BusyFinSetSync1 <= BusyFinSet;
	BusyFinSetSync	<= BusyFinSetSync1;
 	SDIPREUpdDoneSync1<= SDIPREUpdDone;
	SDIPREUpdDoneSync <= SDIPREUpdDoneSync1;
	SDICmdArgUpdDoneSync1<= SDICmdArgUpdDone;
	SDICmdArgUpdDoneSync<= SDICmdArgUpdDoneSync1;
	SDICmdConUpdDoneSync1<= SDICmdConUpdDone;
	SDICmdConUpdDoneSync<= SDICmdConUpdDoneSync1;
	SDIDatConUpdDoneSync1<= SDIDatConUpdDone;
	SDIDatConUpdDoneSync<= SDIDatConUpdDoneSync1;
	SDIDTimerUpdDoneSync1<= SDIDTimerUpdDone;
	SDIDTimerUpdDoneSync<= SDIDTimerUpdDoneSync1;
	SDIBSizeUpdDoneSync1<=SDIBSizeUpdDone;
	SDIBSizeUpdDoneSync<= SDIBSizeUpdDoneSync1;
	SDIAutoReadConUpdDoneSync1 <= SDIAutoReadConUpdDone;
	SDIAutoReadConUpdDoneSync <= SDIAutoReadConUpdDoneSync1;
	ErrorStateSync1<= ErrorState;
	ErrorStateSync	<= ErrorStateSync1;
	AutoReadCompleteSync1	<= AutoReadComplete;
	AutoReadCompleteSync	<= AutoReadCompleteSync1;
	end
	end
end
endmodule


module mmc_MCLKSync (
//input
	MCLK,
	nRst,
	SDreset,
	CMST,
	DTST,
	RCmdStart,
	SDIPREUpd,
	SDICmdArgUpd,
	SDICmdConUpd,
	SDIDatConUpd,
	SDIDTimerUpd,
	SDIBSizeUpd,
	SDIAutoReadConUpd,

//output
	CMSTSync,
	DTSTSync,
	RCmdStartSync,
	SDIPREUpdSync,
	SDICmdArgUpdSync,
	SDICmdConUpdSync,
	SDIDatConUpdSync,
	SDIDTimerUpdSync,
	SDIBSizeUpdSync,
	SDIAutoReadConUpdSync
	);

input	MCLK;
input	nRst;
input	SDreset;
input	CMST;
input	DTST;
input	RCmdStart;
input	SDIPREUpd;
input   SDICmdArgUpd;
input   SDICmdConUpd;
input   SDIDatConUpd;
input	SDIDTimerUpd;
input	SDIBSizeUpd;
input	SDIAutoReadConUpd;

output	CMSTSync;
output	DTSTSync;
output	RCmdStartSync;
output  SDIPREUpdSync;
output  SDICmdArgUpdSync;
output  SDICmdConUpdSync;
output  SDIDatConUpdSync;
output	SDIDTimerUpdSync;
output	SDIBSizeUpdSync;
output	SDIAutoReadConUpdSync;

reg	CMSTSync1;
reg	DTSTSync1;
reg	RCmdStartSync1;
reg	SDIPREUpdSync1;
reg	SDICmdArgUpdSync1;
reg	SDICmdConUpdSync1;
reg	SDIDatConUpdSync1;
reg	SDIDTimerUpdSync1;
reg	SDIBSizeUpdSync1;
reg	SDIAutoReadConUpdSync1;

reg	CMSTSync;
reg	DTSTSync;
reg	RCmdStartSync;
reg	SDIPREUpdSync;
reg	SDICmdArgUpdSync;
reg	SDICmdConUpdSync;
reg	SDIDatConUpdSync;
reg	SDIDTimerUpdSync;
reg	SDIBSizeUpdSync;
reg	SDIAutoReadConUpdSync;
		
always @(posedge MCLK or negedge nRst)
begin
	if (!nRst)
	begin
	CMSTSync1	<=	1'b0;
	CMSTSync	<=	1'b0;
	DTSTSync1	<=	1'b0;
	DTSTSync	<= 	1'b0;
	RCmdStartSync1	<=	1'b0;
	RCmdStartSync	<=	1'b0;
	SDIPREUpdSync1	<=	1'b0;
	SDIPREUpdSync	<=	1'b0;
	SDICmdArgUpdSync1<=	1'b0;
	SDICmdArgUpdSync<= 	1'b0;
	SDICmdConUpdSync1<= 	1'b0;
	SDICmdConUpdSync <= 	1'b0;
	SDIDatConUpdSync1<= 	1'b0;
	SDIDatConUpdSync <= 	1'b0;
	SDIDTimerUpdSync1<= 	1'b0;
	SDIDTimerUpdSync<= 	1'b0;
	SDIBSizeUpdSync1<= 	1'b0;
	SDIBSizeUpdSync	<= 	1'b0;
	SDIAutoReadConUpdSync1 <= 1'b0;
	SDIAutoReadConUpdSync <= 1'b0;
	end
	else
	begin
	if (SDreset)
	begin
	CMSTSync1	<=	1'b0;
	CMSTSync	<=	1'b0;
	DTSTSync1	<=	1'b0;
	DTSTSync	<= 	1'b0;
	RCmdStartSync1	<=	1'b0;
	RCmdStartSync	<=	1'b0;
	SDIPREUpdSync1	<=	1'b0;
	SDIPREUpdSync	<=	1'b0;
	SDICmdArgUpdSync1<=	1'b0;
	SDICmdArgUpdSync<= 	1'b0;
	SDICmdConUpdSync1<= 	1'b0;
	SDICmdConUpdSync <= 	1'b0;
	SDIDatConUpdSync1<= 	1'b0;
	SDIDatConUpdSync <= 	1'b0;
	SDIDTimerUpdSync1<= 	1'b0;
	SDIDTimerUpdSync<= 	1'b0;
	SDIBSizeUpdSync1<= 	1'b0;
	SDIBSizeUpdSync	<= 	1'b0;
	SDIAutoReadConUpdSync1 <= 1'b0;
	SDIAutoReadConUpdSync <= 1'b0;
	end
	else
	begin
	CMSTSync1		<= CMST;
	CMSTSync		<= CMSTSync1;
	DTSTSync1		<= DTST;
	DTSTSync		<= DTSTSync1;
	RCmdStartSync1		<= RCmdStart;
	RCmdStartSync		<= RCmdStartSync1;
	SDIPREUpdSync1		<= SDIPREUpd;
	SDIPREUpdSync		<= SDIPREUpdSync1;
    	SDICmdArgUpdSync1	<= SDICmdArgUpd;
    	SDICmdArgUpdSync 	<= SDICmdArgUpdSync1;
    	SDICmdConUpdSync1	<= SDICmdConUpd;
	SDICmdConUpdSync 	<= SDICmdConUpdSync1;
    	SDIDatConUpdSync1	<= SDIDatConUpd;
    	SDIDatConUpdSync 	<= SDIDatConUpdSync1;
	SDIDTimerUpdSync1	<= SDIDTimerUpd;
	SDIDTimerUpdSync	<= SDIDTimerUpdSync1;
    	SDIBSizeUpdSync1	<= SDIBSizeUpd;
    	SDIBSizeUpdSync 	<= SDIBSizeUpdSync1;
	SDIAutoReadConUpdSync1 	<= SDIAutoReadConUpd;
	SDIAutoReadConUpdSync	<= SDIAutoReadConUpdSync1;
	end
	end
end
endmodule
