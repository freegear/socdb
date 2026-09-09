// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : mmc.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : TOP module of mmc/sd 
//  =============================================================================
`timescale 1ns/1ps

//`include "./mmcParams.v"

module MMCTop(
		PCLK,
		PRESETn,
		PSEL,
		PENABLE,
		PWRITE,
		PADDR,
		PWDATA,	
 	
		PRDATA,
		
		MCLK,
		MMC_FBCLK,
		MMC_CMDIN,
		MMC_DATIN,

		MMC_INT,
		MMC_DMAREQ,
		MMC_CLKOUT,
		MMC_CMDOUT,
		MMC_DATOUT,
		MMC_nCMDEN,
		MMC_nDATEN
	
		);

//input
input         	PCLK;             // APB Bus Clock
input         	PRESETn;          // APB Bus Reset
input         	PSEL;             // APB Peripheral select
input         	PENABLE;          // APB Peripheral enable
input         	PWRITE;           // APB Peripheral write
input  [7:2] 	PADDR;            // APB address bus
input  [31:0] 	PWDATA;           // APB write data bus
output	[31:0] 	PRDATA;

input		MCLK;
input		MMC_FBCLK;

input		MMC_CMDIN;
input	[7:0]	MMC_DATIN;

output		MMC_INT;
output		MMC_DMAREQ;
output		MMC_CLKOUT;
output		MMC_CMDOUT;
output	[7:0]	MMC_DATOUT;
output		MMC_nCMDEN;
output		MMC_nDATEN;



wire	[31:0]	CmdArg;
wire	[31:0]	SDICmdArg;
wire	[7:0]	iSDIPRE;
wire	[7:0]	SDIPRE;
wire	[22:0]	iDataTimer;
wire	[22:0]	SDIDTimer;
wire	[11:0]	iBlkSize;
wire	[11:0]	SDIBSize;
wire	[30:0]	SDIDatCon;
wire	[30:0]	iSDIDatCon;
wire	[31:0]	FRdData;
wire	[7:0]	DATIN;
wire	[12:0]	SDICmdCon;
wire	[12:0]	iSDICmdCon;
wire	[11:0]	BlkNumCnt;
wire	[11:0]	BlkCnt;
wire	[7:0]	DATOUT;

wire	[31:0]	RxFWrData;
wire	[31:0]	RxFWrDataSync;
wire	[6:0]	FFCNT;
wire		FFfail;

wire	[7:0]	RspIndex;
wire	[31:0]	Response0;
wire	[31:0]	Response1;
wire	[31:0]	Response2;
wire	[31:0]	Response3;
wire		ENCLK;
wire		SDreset;

wire	ENCLKAND;
wire	ENCLK2;
assign 	ENCLKAND = ENCLK2&ENCLK;

wire		CmdStartMuxO;  
wire	[31:0]	CmdArgMuxO;
wire	[6:0]	CmdIndexMuxO;
wire		NoCRCRspMuxO;
wire		LongRspMuxO;
wire		WaitRspMuxO;
wire		BusyRspMuxO;
wire		AbortCmdMuxO;

wire	[1:0]	ErrorState;
wire	[1:0]	ErrorStateSync;

wire	[31:0]	ResponseCMD18;

wire	[1:0]	iAutoReadCon;
wire	[1:0]	SDIAutoReadCon;

mmc_CommandControl CommandControl(
	.nRst		(PRESETn),
	.SDreset	(SDreset),

	.MCLK		(MCLK),
	.CKPulse	(CKPulse),
	.neg_CKPulse	(neg_CKPulse),
	.CMDIN		(CMDIN),
	.CMDOUT		(),
	.Inv_CMDOUT	(CMDOUT),
	.nCMDEN		(),
	.Inv_nCMDEN	(nCMDEN),
	
	// register input
	.SDICmdArg	(CmdArgMuxO),
	.NoCRCRsp	(NoCRCRspMuxO),
	//.WithData	(SDICmdCon[9]),
	.LongRsp	(LongRspMuxO),
	.WaitRsp	(WaitRspMuxO),
	.CMSTSync	(CmdStartMuxO),
	.CMSTClr	(CMSTClr),
	
	.CmdIndex	(CmdIndexMuxO),
	
	.RspCrcSet	(RspCrcSet),
	// register output
	.CmdSentSet	(CmdSentSet),
	.CmdToutSet	(CmdToutSet),
	.RspFinSet	(RspFinSet),
	.CmdOn		(CmdOn),
	.RspIndex	(RspIndex),
	.Response0	(Response0),
	.Response1	(Response1),
	.Response2	(Response2),
	.Response3	(Response3)

);

mmc_DataControl DataControl(
	.nRst		(PRESETn),
	.SDreset	(SDreset),
	.MCLK		(MCLK),
   	
	.neg_CKPulse	(neg_CKPulse),      
	.CKPulse	(CKPulse),      
	
	// register input
	.ByteOrder	(SDIDatCon[17]),
	.SDIDTimer	(SDIDTimer),
	.SDIBSize	(SDIBSize),
	.TARSP		(SDIDatCon[19]),
	.RACMD		(SDIDatCon[18]),
	.BlkMode	(SDIDatCon[16]),
	.WideBus	(SDIDatCon[15]),
	.MMCPlus	(SDIDatCon[20]), // adding for MMCPlus Mode( 8bit DAT line)
	.DTST		(DTSTSync),
	.DatMode	(SDIDatCon[13:12]),
	.BlkNum		(SDIDatCon[11:0]),
	
	.BusyRsp	(BusyRspMuxO),
	.AbortCmd	(AbortCmdMuxO),
	//.WithData	(SDICmdCon[9]),
	
	// register output
	.BlkNumCnt	(BlkNumCnt),
	.BlkDatCnt	(BlkCnt),
	.NoBusySet	(NoBusySet),
	.CrcStaSet	(CrcStaSet),
	.DatCrcSet	(DatCrcSet),
	.DatToutSet	(DatToutSet),
	.DatFinSet	(DatFinSet),
	.BusyFinSet	(BusyFinSet),

	.TxDatOn	(TxDatOn),
	.RxDatOn	(RxDatOn),
    
	.DTSTClr	(DTSTClr),
	.RspFinSet	(RspFinSet),
	.CmdSentSet	(CmdSentSet),


	.TxActive	(TxActive),
	.TxRdPtrInc	(TxRdPtrInc),
	.RxActive	(RxActive),
	.RxWriteEn	(RxWriteEn),
	.FIFOWriteData	(RxFWrData),

	//.TFEmpty	(TFEmpty),
	.TFREmpty	(TFREmpty),
	.RFFull		(RFFull),
	.FIFOReadData	(FRdData),
	
	.ENCLK2		(ENCLK2),
	.nDATEN		(),
	.Inv_nDATEN	(nDATEN),
	.DATOUT		(),
	.Inv_DATOUT	(DATOUT),
	.DATIN		(DATIN)
	);

mmc_Prescaler Prescaler(
	.MCLK		(MCLK),
	.nRst		(PRESETn),
	.SDreset	(SDreset),
	.SDIPRE		(SDIPRE),
	.ENCLK		(ENCLKAND),
// Outputs
	.MMC_CLK	(MMC_CLKOUT),
        .neg_CKPulse	(neg_CKPulse),
        .CKPulse	(CKPulse)
        );

mmc_APBRegisterIF mmc_APBRegisterIF(
	.PCLK		(PCLK),
	.PRESETn	(PRESETn),
	.PSEL		(PSEL),
	.PENABLE	(PENABLE),
	.PWRITE		(PWRITE),
	.PADDR		(PADDR),
	.PWDATA		(PWDATA),	
	.PRDATA		(PRDATA),

	.SDreset	(SDreset),
	.ENCLK		(ENCLK),

	.iSDIPRE	(iSDIPRE),
	.CmdArg		(CmdArg),

	.iSDICmdCon	(iSDICmdCon),
	.CMST		(CMST),
	.CMSTClr	(CMSTClr),

	.RspCrc		(RspCrc),
	.RspCrcSetSync	(RspCrcSetSync),
	.CmdSent	(CmdSent),
	.CmdSentSetSync	(CmdSentSetSync),
	.CmdTout	(CmdTout),
	.CmdToutSetSync	(CmdToutSetSync),
	.RspFin		(RspFin),
	.RspFinSetSync	(RspFinSetSync),

	.CmdOn		(CmdOn),
	.RspIndex	(RspIndex),
	.Response0	(Response0),
	.Response1	(Response1),
	.Response2	(Response2),
	.Response3	(Response3),
		
	.iDataTimer	(iDataTimer),
	.iBlkSize	(iBlkSize),			
	
	.iSDIDatCon	(iSDIDatCon),
	.DTST		(DTST),
	.DTSTClr	(DTSTClr),

	.BlkNumCnt	(BlkNumCnt),	
	.BlkCnt		(BlkCnt),
	.NoBusySetSync	(NoBusySetSync),
	.CrcStaSetSync	(CrcStaSetSync),
	.DatCrcSetSync	(DatCrcSetSync),
	.DatToutSetSync	(DatToutSetSync),
	.DatFinSetSync	(DatFinSetSync),
	.BusyFinSetSync	(BusyFinSetSync),
	.TxDatOn	(TxDatOn),
	.RxDatOn	(RxDatOn),

	.FRST		(FRST),
	.FFfailSet	(RxUnderrun | TxOverrun),
	.FFfail		(FFfail),

	.TFDET		(TFDET),
	.RFDET		(RFDET),
	.TFHalf		(TFHalf),
	.TFEmpty	(TFEmpty),

	.RFFull		(RFFull),
	.RFHalf		(RFHalf),
	.FFCNT		(FFCNT),
	
	.TxWriteEn	(TxWriteEn),
	.RxRdPtrInc	(RxRdPtrInc),

	.SDIPREUpd	(SDIPREUpd),
	.SDICmdArgUpd	(SDICmdArgUpd),
	.SDICmdConUpd	(SDICmdConUpd),
	.SDIDatConUpd	(SDIDatConUpd),
	.SDIDTimerUpd	(SDIDTimerUpd),
	.SDIBSizeUpd	(SDIBSizeUpd),
	
	.SDIPREUpdDoneSync(SDIPREUpdDoneSync),
	.SDICmdArgUpdDoneSync(SDICmdArgUpdDoneSync),
	.SDICmdConUpdDoneSync(SDICmdConUpdDoneSync),
	.SDIDatConUpdDoneSync(SDIDatConUpdDoneSync),
	.SDIDTimerUpdDoneSync(SDIDTimerUpdDoneSync),
	.SDIBSizeUpdDoneSync(SDIBSizeUpdDoneSync),
	.FIFOdata(FRdData),


	.RCmdStart	(RCmdStart),
	.RCmdStartClr	(RCmdStartClr),
	.iAutoReadCon	(iAutoReadCon),
        .ErrorState	(ErrorStateSync),
	.ResponseCMD18	(ResponseCMD18),
	.AutoReadComplete (AutoReadCompleteSync),
        .SDIAutoReadConUpd	(SDIAutoReadConUpd),
        .SDIAutoReadConUpdDoneSync(SDIAutoReadConUpdDoneSync),
	
	.MMC_INT	(MMC_INT)
	);

mmc_DataFifo_DMA  DataFifo_DMA(

	.PCLK		(PCLK),
	.PRESETn	(PRESETn),
	.SDreset	(SDreset),
	.FRST		(FRST), // FIFO reset signal

	.DatMode	(SDIDatCon[13:12]),
	.DMASize	(SDIDatCon[30:24]),
	.TxActiveSync	(TxActiveSync), // Tx fifo enable
	.TxWriteEnSync	(TxWriteEn),
	.TxRdPtrIncSync	(TxRdPtrIncSync),
	.PWData		(PWDATA),

	.RxActiveSync	(RxActiveSync),
	.RxRdPtrInc	(RxRdPtrInc),

	.RxWriteEnSync	(RxWriteEnSync),
	.RxFWrData	(RxFWrDataSync),

	.RxUnderrun	(RxUnderrun),
	.TxOverrun	(TxOverrun),
	.TFDET		(TFDET),
	.TFHalf		(TFHalf),
       	.TFEmpty	(TFEmpty), 
       	.TFREmpty	(TFREmpty), 


      	.RFFull		(RFFull),
       	.RFHalf		(RFHalf),
		      	
       	.RFDET		(RFDET),

       	.FFCNT		(FFCNT),
	.FIFORdData	(FRdData),
	.EnDMA		(SDIDatCon[14]),
//------------DMA request signals---------      	
	.DREQ		(MMC_DMAREQ)
	);



mmc_FeedBackSync FeedBackSync(
	.nRst		(PRESETn),
	.SDreset	(SDreset),
	.MMC_FBCLK	(MMC_FBCLK), 
	.MMC_CMDIN	(MMC_CMDIN),
	.MMC_DATIN	(MMC_DATIN),
	.CMDOUT		(CMDOUT),
	.DATOUT		(DATOUT),
	.nCMDEN		(nCMDEN),
	.nDATEN		(nDATEN),
	.MMC_CMDOUT	(MMC_CMDOUT),
	.MMC_DATOUT	(MMC_DATOUT),
	.CMDIN		(CMDIN),
	.DATIN		(DATIN),
	.MMC_nCMDEN	(MMC_nCMDEN),
	.MMC_nDATEN	(MMC_nDATEN));



mmc_PCLKSync PCLKSync(
//input
	.PCLK		(PCLK),
	.nRst		(PRESETn),
	.SDreset	(SDreset),

	.TxActive	(TxActive),
	.TxRdPtrInc	(TxRdPtrInc),
	.RxActive	(RxActive),
	.RxWriteEn	(RxWriteEn),
	.RxFWrData	(RxFWrData),

	.RspCrcSet	(RspCrcSet),
        .CmdSentSet	(CmdSentSet),
        .CmdToutSet	(CmdToutSet),
        .RspFinSet	(RspFinSet),

        .NoBusySet	(NoBusySet),
        .CrcStaSet	(CrcStaSet),
        .DatCrcSet	(DatCrcSet),
        .DatToutSet	(DatToutSet),
        .DatFinSet	(DatFinSet),
        .BusyFinSet	(BusyFinSet),

	.SDIPREUpdDone	(SDIPREUpdDone),
        .SDICmdArgUpdDone(SDICmdArgUpdDone),
        .SDICmdConUpdDone(SDICmdConUpdDone),
        .SDIDatConUpdDone(SDIDatConUpdDone),
        .SDIDTimerUpdDone(SDIDTimerUpdDone),
        .SDIBSizeUpdDone(SDIBSizeUpdDone),
	.SDIAutoReadConUpdDone(SDIAutoReadConUpdDone),
	.ErrorState	(ErrorState),
	.AutoReadComplete(AutoReadComplete),

//output
	.TxActiveSync	(TxActiveSync),
	.TxRdPtrIncSync	(TxRdPtrIncSync),
	.RxActiveSync	(RxActiveSync),
	.RxWriteEnSync	(RxWriteEnSync),
	.RxFWrDataSync	(RxFWrDataSync),

        .RspCrcSetSync	(RspCrcSetSync),
        .CmdSentSetSync	(CmdSentSetSync),
        .CmdToutSetSync	(CmdToutSetSync),
        .RspFinSetSync	(RspFinSetSync),

        .NoBusySetSync	(NoBusySetSync),
        .CrcStaSetSync	(CrcStaSetSync),
        .DatCrcSetSync	(DatCrcSetSync),
        .DatToutSetSync	(DatToutSetSync),
        .DatFinSetSync	(DatFinSetSync),
        .BusyFinSetSync	(BusyFinSetSync),

	.SDIPREUpdDoneSync	(SDIPREUpdDoneSync),
        .SDICmdArgUpdDoneSync	(SDICmdArgUpdDoneSync),
        .SDICmdConUpdDoneSync	(SDICmdConUpdDoneSync),
        .SDIDatConUpdDoneSync	(SDIDatConUpdDoneSync),
        .SDIDTimerUpdDoneSync	(SDIDTimerUpdDoneSync),
        .SDIBSizeUpdDoneSync	(SDIBSizeUpdDoneSync),
	.SDIAutoReadConUpdDoneSync(SDIAutoReadConUpdDoneSync),
	.ErrorStateSync		(ErrorStateSync),
	.AutoReadCompleteSync(AutoReadCompleteSync)
	);


mmc_MCLKSync MCLKSync(
//input
	.MCLK		(MCLK),
	.nRst		(PRESETn),
	.SDreset	(SDreset),

	.CMST		(CMST),
	.DTST		(DTST),
	.RCmdStart	(RCmdStart),
	.SDIPREUpd	(SDIPREUpd),
	.SDICmdArgUpd	(SDICmdArgUpd),	
	.SDICmdConUpd	(SDICmdConUpd),
	.SDIDatConUpd	(SDIDatConUpd),
	.SDIDTimerUpd	(SDIDTimerUpd),
	.SDIBSizeUpd	(SDIBSizeUpd),
	.SDIAutoReadConUpd (SDIAutoReadConUpd),


//output
	.CMSTSync	(CMSTSync),
	.DTSTSync	(DTSTSync),
	.RCmdStartSync	(RCmdStartSync),
	.SDIPREUpdSync	(SDIPREUpdSync),
	.SDICmdArgUpdSync(SDICmdArgUpdSync),
	.SDICmdConUpdSync(SDICmdConUpdSync),
	.SDIDatConUpdSync(SDIDatConUpdSync),
	.SDIDTimerUpdSync(SDIDTimerUpdSync),
	.SDIBSizeUpdSync(SDIBSizeUpdSync),
	.SDIAutoReadConUpdSync (SDIAutoReadConUpdSync)
	);


mmc_RegUpd mmc_RegUpd (
// Inputs
	.MCLK		(MCLK),
	.nRst		(PRESETn),
	.SDreset	(SDreset),

	.iSDIPRE	(iSDIPRE),	
	.SDIPREUpdSync	(SDIPREUpdSync),

	.CmdArg		(CmdArg),
	.SDICmdArgUpdSync(SDICmdArgUpdSync),

	.iSDICmdCon	(iSDICmdCon),
	.SDICmdConUpdSync(SDICmdConUpdSync),
	
	.iSDIDatCon	(iSDIDatCon),
	.SDIDatConUpdSync(SDIDatConUpdSync),

	.iDataTimer	(iDataTimer),
	.SDIDTimerUpdSync(SDIDTimerUpdSync),
	.iBlkSize	(iBlkSize),
	.SDIBSizeUpdSync(SDIBSizeUpdSync),

	.iAutoReadCon	(iAutoReadCon),
	.SDIAutoReadConUpdSync(SDIAutoReadConUpdSync),
                   
// Outputs
	.SDIPRE		(SDIPRE),
	.SDIPREUpdDone	(SDIPREUpdDone),
	.SDICmdArg	(SDICmdArg),
	.SDICmdArgUpdDone(SDICmdArgUpdDone),
	.SDICmdCon	(SDICmdCon),
	.SDICmdConUpdDone(SDICmdConUpdDone),
	.SDIDatCon	(SDIDatCon),
	.SDIDatConUpdDone(SDIDatConUpdDone),
	.SDIDTimer	(SDIDTimer),
	.SDIDTimerUpdDone(SDIDTimerUpdDone),
	.SDIBSize	(SDIBSize),
	.SDIBSizeUpdDone(SDIBSizeUpdDone),		
    	.SDIAutoReadCon (SDIAutoReadCon),
        .SDIAutoReadConUpdDone(SDIAutoReadConUpdDone)
        );

//----------------------
// AUTO read module
//----------------------

AUTORead AutoRead(
        .nRst		(PRESETn),
        .SDreset	(SDreset),
        .MCLK		(MCLK),

        // Register inputo
        .AutoReadEn	(SDIAutoReadCon[1]),// Auto mode Enable 
        .RCmdStart	(RCmdStartSync),// APB register setting Value
	.RCmdStartClr	(RCmdStartClr),
        .SingleMultiRead(SDIAutoReadCon[0]),

	.Response0	(Response0),

	.NoBusySet	(NoBusySet),
	.BusyFinSet	(BusyFinSet),
        .RspCrcSet	(RspCrcSet),
        .RspFinSet	(RspFinSet),
        .CmdToutSet	(CmdToutSet),
        .DatCrcSet	(DatCrcSet),
        .DatFinSet	(DatFinSet),
	// for Command Control
        .CmdArg		(SDICmdArg[31:0]),
        .CmdIndex	(SDICmdCon[6:0]),
        .CMSTSync	(CMSTSync),
 	.CMSTClr	(CMSTClr),

	.NoCRCRsp	(SDICmdCon[11]),
	.LongRsp	(SDICmdCon[8]),
	.WaitRsp	(SDICmdCon[7]),

	// for Data control
 // for Data register setting 
	.BusyRsp	(SDICmdCon[12]),
	.AbortCmd	(SDICmdCon[10]),

        // output
        .CmdStartMuxO	(CmdStartMuxO),
        .CmdArgMuxO	(CmdArgMuxO),
        .CmdIndexMuxO	(CmdIndexMuxO),
        .NoCRCRspMuxO	(NoCRCRspMuxO),
        .LongRspMuxO	(LongRspMuxO),    
        .WaitRspMuxO	(WaitRspMuxO),    
        .BusyRspMuxO	(BusyRspMuxO),    
        .AbortCmdMuxO	(AbortCmdMuxO),   

	.ResponseCMD18	(ResponseCMD18),
	.AutoReadComplete(AutoReadComplete),
        .ErrorState	(ErrorState)
        );

endmodule
