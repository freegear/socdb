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
wire	[29:0]	SDIDatCon;
wire	[29:0]	iSDIDatCon;
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
assign ENCLKAND = ENCLK2&ENCLK;

//assign Resetn= PRESETn & (~SDreset);


mmc_CommandControl CommandControl(
	.nRst		(PRESETn),
	.SDreset	(SDreset),

	.MCLK		(MCLK),
	.DIVlevelCo	(DIVlevelCo),
	.CMDIN		(CMDIN),
	.CMDOUT		(CMDOUT),
	.nCMDEN		(nCMDEN),
	
	.CPSMEn		(1'b1),
	
	// register input
	.SDICmdArg	(SDICmdArg), 	// command argument
	.NoCRCRsp	(SDICmdCon[11]),
	.WithData	(SDICmdCon[9]),
	.LongRsp	(SDICmdCon[8]),
	.WaitRsp	(SDICmdCon[7]),
	.CMSTSync	(CMSTSync),
	.CMSTClr	(CMSTClr),
	
	.CmdIndex	(SDICmdCon[6:0]),
	
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
   	
	.DIVlevelCo	(DIVlevelCo),      
    	.DPSMEn		(1'b1),
	
	// register input
	.SDIDTimer	(SDIDTimer),
	.SDIBSize	(SDIBSize),
	.TARSP		(SDIDatCon[18]),
	.RACMD		(SDIDatCon[17]),
	.BlkMode	(SDIDatCon[16]),
	.WideBus	(SDIDatCon[15]),
	.MMCPlus	(SDIDatCon[19]), // adding for MMCPlus Mode( 8bit DAT line)
	.DTST		(DTSTSync),
	.DatMode	(SDIDatCon[13:12]),
	.BlkNum		(SDIDatCon[11:0]),
	
	.BusyRsp	(SDICmdCon[12]),
	.AbortCmd	(SDICmdCon[10]),
	
	// register output
	.BlkNumCnt	(BlkNumCnt),
	.BlkCnt		(BlkCnt),
	.NoBusySet	(NoBusySet),
	.CrcStaSet	(CrcStaSet),
	.DatCrcSet	(DatCrcSet),
	.DatToutSet	(DatToutSet),
	.DatFinSet	(DatFinSet),
	.BusyFinSet	(BusyFinSet),
	.BusyFinSet2	(BusyFinSet2),

	.TxDatOn	(TxDatOn),
	.RxDatOn	(RxDatOn),
    
	.DTSTClr	(DTSTClr),
	.RspFinSet	(RspFinSet),
	.CmdSentSet	(CmdSentSet),


	.TxActive	(TxActive),
	.TxRdPtrInc	(TxRdPtrInc),
	.RxActive	(RxActive),
	.RxWriteEn	(RxWriteEn),
	.RxFWrData	(RxFWrData),

	.TFEmpty	(TFEmpty),
	.RFFull		(RFFull),
	.FRdData	(FRdData),
	
	.ENCLK2		(ENCLK2),
	.nDATEN		(nDATEN),
	.DATOUT		(DATOUT),
	.DATIN		(DATIN));

mmc_Prescaler Prescaler(
	.MCLK		(MCLK),
	.nRst		(PRESETn),
	.SDIPRE		(SDIPRE),
	.ENCLK		(ENCLKAND),
// Outputs
	.MMC_CLK	(MMC_CLKOUT),
        .DIVlevelCo	(DIVlevelCo)
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
	.NoBusy		(NoBusy),
	.NoBusySetSync	(NoBusySetSync),
	.CrcSta		(CrcSta),
	.CrcStaSetSync	(CrcStaSetSync),
	.DatCrc		(DatCrc),
	.DatCrcSetSync	(DatCrcSetSync),
	.DatTout	(DatTout),
	.DatToutSetSync	(DatToutSetSync),
	.DatFin		(DatFin),
	.DatFinSetSync	(DatFinSetSync),
	.BusyFin	(BusyFin),
	.BusyFinSetSync	(BusyFinSetSync),

	.BusyFin2	(BusyFin2),
	.BusyFinSet2Sync(BusyFinSet2Sync),
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

	.NoBusyInt	(NoBusyInt),
	.RspCrcInt	(RspCrcInt),
	.CmdSentInt	(CmdSentInt),
	.CmdToutInt	(CmdToutInt),
	.RspEndInt	(RspEndInt),
	.FFfailInt	(FFfailInt),
	.CrcStaInt	(CrcStaInt),
	.DatCrcInt	(DatCrcInt),
	.DatToutInt	(DatToutInt),
	.DatFinInt	(DatFinInt),
	.BusyFinInt	(BusyFinInt),
	.BusyFin2Int	(BusyFin2Int),
	.TFHalfInt	(TFHalfInt),
	.TFEmpInt	(TFEmpInt),
	.RFFullInt	(RFFullInt),
	.RFHalfInt	(RFHalfInt),

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
	.FIFOdata(FRdData)
	);

mmc_IntMsk  IntMsk(

	// interrupt source
	//
	.NoBusy		(NoBusy),
	.RspCrc		(RspCrc),
	.CmdSent	(CmdSent),
	.CmdTout	(CmdTout),
	.RspEnd		(RspFin),
//	.RWReq		(RWaitReq),
//	.IntDet		(IOIntDet),
	.FFfail		(FFfail),
	.CrcSta		(CrcSta),
	.DatCrc		(DatCrc),
	.DatTout	(DatTout),
	.DatFin		(DatFin),
	.BusyFin	(BusyFin),
	.BusyFin2	(BusyFin2),
	.TFHalf		(TFHalf),
	.TFEmpt		(TFEmpty),
	.RFFull		(RFFull),
	.RFHalf		(RFHalf),
	
	.IntMsk		({NoBusyInt,RspCrcInt,CmdSentInt,CmdToutInt,RspEndInt,
			FFfailInt,CrcStaInt,DatCrcInt,DatToutInt,DatFinInt,
			BusyFinInt,BusyFin2Int,TFHalfInt,TFEmpInt,RFFullInt,RFHalfInt}),

	.MMC_INT	(MMC_INT)
		);

mmc_DataFifo_DMA  DataFifo_DMA(

	.PCLK		(PCLK),
	.PRESETn	(PRESETn),
	.SDreset	(SDreset),
	.FRST		(FRST), // FIFO reset signal

	.DatMode	(SDIDatCon[13:12]),
	.DMASize	(SDIDatCon[29:23]),
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
        .BusyFinSet2	(BusyFinSet2),

	.SDIPREUpdDone	(SDIPREUpdDone),
        .SDICmdArgUpdDone(SDICmdArgUpdDone),
        .SDICmdConUpdDone(SDICmdConUpdDone),
        .SDIDatConUpdDone(SDIDatConUpdDone),
        .SDIDTimerUpdDone(SDIDTimerUpdDone),
        .SDIBSizeUpdDone(SDIBSizeUpdDone),

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
        .BusyFinSet2Sync(BusyFinSet2Sync),

	.SDIPREUpdDoneSync	(SDIPREUpdDoneSync),
        .SDICmdArgUpdDoneSync	(SDICmdArgUpdDoneSync),
        .SDICmdConUpdDoneSync	(SDICmdConUpdDoneSync),
        .SDIDatConUpdDoneSync	(SDIDatConUpdDoneSync),
        .SDIDTimerUpdDoneSync	(SDIDTimerUpdDoneSync),
        .SDIBSizeUpdDoneSync	(SDIBSizeUpdDoneSync)

	);


mmc_MCLKSync MCLKSync(
//input
	.MCLK		(MCLK),
	.nRst		(PRESETn),
	.SDreset	(SDreset),

	.CMST		(CMST),
	.DTST		(DTST),
	.SDIPREUpd	(SDIPREUpd),
	.SDICmdArgUpd	(SDICmdArgUpd),	
	.SDICmdConUpd	(SDICmdConUpd),
	.SDIDatConUpd	(SDIDatConUpd),
	.SDIDTimerUpd	(SDIDTimerUpd),
	.SDIBSizeUpd	(SDIBSizeUpd),

//output
	.CMSTSync	(CMSTSync),
	.DTSTSync	(DTSTSync),
	.SDIPREUpdSync	(SDIPREUpdSync),
	.SDICmdArgUpdSync(SDICmdArgUpdSync),
	.SDICmdConUpdSync(SDICmdConUpdSync),
	.SDIDatConUpdSync(SDIDatConUpdSync),
	.SDIDTimerUpdSync(SDIDTimerUpdSync),
	.SDIBSizeUpdSync(SDIBSizeUpdSync)
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
	.SDIBSizeUpdDone(SDIBSizeUpdDone)		
        );
endmodule
