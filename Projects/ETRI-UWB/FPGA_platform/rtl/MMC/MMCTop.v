// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : MMCTop.v
// File Revision       : 0.1
//  -----------------------------------------------------------------------------
//  Purpose            : TOP module of mmc/sd 
//  =============================================================================
`timescale 1ns/1ps


`define USE_FBCLK

module MMCTop(
		PCLK,
		PRESETn,
		PSEL,
		PENABLE,
		PWRITE,
		PADDR,
		PWDATA,	
 	
		PRDATA,
		
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

`define HSMMC
`ifdef HSMMC
parameter AW=8;
`else
parameter AW=4;
`endif

//input
input         	PCLK;             // APB Bus Clock
input         	PRESETn;          // APB Bus Reset
input         	PSEL;             // APB Peripheral select
input         	PENABLE;          // APB Peripheral enable
input         	PWRITE;           // APB Peripheral write
input  	[6:2] 	PADDR;            // APB address bus
input  	[31:0] 	PWDATA;           // APB write data bus
output	[31:0] 	PRDATA;

input			MMC_FBCLK;

input			MMC_CMDIN;
input	[AW-1:0]	MMC_DATIN;

output			MMC_INT;
output			MMC_DMAREQ;
output			MMC_CLKOUT;
output			MMC_CMDOUT;
output	[AW-1:0]	MMC_DATOUT;
output			MMC_nCMDEN;
output			MMC_nDATEN;



wire	[31:0]	CmdArg;
wire	[7:0]	iSDIPRE;
wire	[22:0]	iDataTimer;
wire	[15:0]	iBlkSize;
wire	[30:0]	SDIDatCon;
wire	[31:0]	FRdData;
wire	[AW-1:0]	DATIN;
wire	[12:0]	SDICmdCon;
wire	[15:0]	BlkNumCnt;
wire	[15:0]	BlkCnt;
wire	[AW-1:0]	DATOUT;

wire	[31:0]	RxFWrData;
wire	[4:0]	FFCNT; // FIFO Size º¯°æ

wire	[7:0]	RspIndex;
wire	[31:0]	Response0;
wire	[31:0]	Response1;
wire	[31:0]	Response2;
wire	[31:0]	Response3;
wire			ENCLK;
wire			ENCLK_REG;
wire			ENCLK_FIFO;
wire			SDreset;
wire			PSAVEON;

wire			CmdStartMuxO;  
wire	[31:0]	CmdArgMuxO;
wire	[6:0]	CmdIndexMuxO;
wire			NoCRCRspMuxO;
wire			LongRspMuxO;
wire			WaitRspMuxO;
wire			BusyRspMuxO;
wire			AbortCmdMuxO;

wire	[1:0]	ErrorState;

wire	[31:0]	ResponseCMD18;

wire	[1:0]	AutoReadCon;


wire			CmdCtrlIdle;
wire			BusyChkIdle;
wire			DatCtrlIdle;


wire [5:0]		DMASize;
wire	 		TARSP;
wire	 		RACMD;
wire	 		ByteOrder; 
wire	 		BlkMode;
wire			MMCPlus;
wire	 		WideBus;
wire	 		EnDMA;
wire [1:0]		DatMode;
wire [15:0]		BlkNum;

	assign DMASize 		= SDIDatCon[30:25];
	assign TARSP		= SDIDatCon[24];
	assign RACMD		= SDIDatCon[23];
	assign ByteOrder 	= SDIDatCon[22];
	assign BlkMode		= SDIDatCon[21];
	assign MMCPlus 		= SDIDatCon[20];
	assign WideBus		= SDIDatCon[19];
	assign EnDMA		= SDIDatCon[18];
	assign DatMode		= SDIDatCon[17:16];
	assign BlkNum		= SDIDatCon[15:0];

wire	CMDIN;
wire	CMDOUT;


mmc_CommandControl CommandControl(
	.nRst			(PRESETn),
	.SDreset		(SDreset),	

	.PCLK			(PCLK),
	.CKPulse		(CKPulse),
	.neg_CKPulse	(neg_CKPulse),
	.CMDIN			(CMDIN),
	.CMDOUT			(),
	.Inv_CMDOUT		(CMDOUT),
	.nCMDEN			(),
	.Inv_nCMDEN		(nCMDEN),
	
	// register input
	.SDICmdArg		(CmdArgMuxO),
	.NoCRCRsp		(NoCRCRspMuxO),
	//.WithData		(SDICmdCon[9]), // reserved
	.LongRsp		(LongRspMuxO),
	.WaitRsp		(WaitRspMuxO),
	.CMST			(CmdStartMuxO),
	.CMSTClr		(CMSTClr),
	
	.CmdIndex		(CmdIndexMuxO),
	
	.RspCrcSet		(RspCrcSet),
	// register output
	.CmdSentSet		(CmdSentSet),
	.CmdToutSet		(CmdToutSet),
	.RspFinSet		(RspFinSet),
	.CmdOn			(CmdOn),
	.RspIndex		(RspIndex),
	.Response0		(Response0),
	.Response1		(Response1),
	.Response2		(Response2),
	.Response3		(Response3),
	.CmdCtrlIdle	(CmdCtrlIdle)

);


mmc_DataControl DataControl(
	.nRst			(PRESETn),
	.SDreset		(SDreset),
	.PCLK			(PCLK),
   	
	.neg_CKPulse	(neg_CKPulse),      
	.CKPulse		(CKPulse),      
	
	// register input
	.ByteOrder		(ByteOrder),
	.SDIDTimer		(iDataTimer),
	.SDIBSize		(iBlkSize),
	.TARSP			(TARSP),
	.RACMD			(RACMD),
	.BlkMode		(BlkMode),
	.WideBus		(WideBus),
	.MMCPlus		(MMCPlus), // adding for MMCPlus Mode( 8bit DAT line)
	.DTST			(DTST),	
	.DatMode		(DatMode),
	.BlkNum			(BlkNum),
	
	.BusyRsp		(BusyRspMuxO),
	.AbortCmd		(AbortCmdMuxO),
	//.WithData		(SDICmdCon[9]), // Reserved
	
	// register output
	.BlkNumCnt		(BlkNumCnt),
	.BlkDatCnt		(BlkCnt),
	.NoBusySet		(NoBusySet),
	.CrcStaSet		(CrcStaSet),
	.DatCrcSet		(DatCrcSet),
	.DatToutSet		(DatToutSet),
	.DatFinSet		(DatFinSet),
	.BusyFinSet		(BusyFinSet),

	.TxDatOn		(TxDatOn),
	.RxDatOn		(RxDatOn),
    
	.DTSTClr		(DTSTClr),
	.RspFinSet		(RspFinSet),
	.CmdSentSet		(CmdSentSet),


	.TxActive		(TxActive),
	.TxRdPtrInc		(TxRdPtrInc),
	.RxActive		(RxActive),
	.RxWriteEn		(RxWriteEn),
	.FIFOWriteData	(RxFWrData),

	.TFREmpty		(TFREmpty),
	.RFFull			(RFFull),
	.FIFOReadData	(FRdData),
	
	.ENCLK2			(ENCLK_FIFO),
	.nDATEN			(),
	.Inv_nDATEN		(nDATEN),
	.DATOUT			(),
	.Inv_DATOUT		(DATOUT),
	.DATIN			(DATIN),
	.BusyChkIdle	(BusyChkIdle),
	.DatCtrlIdle	(DatCtrlIdle)
	);

mmc_Prescaler Prescaler(

	.PCLK			(PCLK),
	.nRst			(PRESETn),
	.SDreset		(SDreset),  
	.SDIPRE			(iSDIPRE),
	.ENCLK			(ENCLK),
// Outputs
	.MMC_CLK		(MMC_CLKOUT),
    .neg_CKPulse	(neg_CKPulse),
    .CKPulse		(CKPulse)
        );

mmc_APBRegisterIF mmc_APBRegisterIF(
	.PCLK			(PCLK),
	.PRESETn		(PRESETn),
	.PSEL			(PSEL),
	.PENABLE		(PENABLE),
	.PWRITE			(PWRITE),
	.PADDR			(PADDR),
	.PWDATA			(PWDATA),	
	.PRDATA			(PRDATA),

	.SDreset		(SDreset),
	.ENCLK			(ENCLK_REG),
	.PSAVEON		(PSAVEON),

	.iSDIPRE		(iSDIPRE),
	.CmdArg			(CmdArg),

	.iSDICmdCon		(SDICmdCon),
	.CMST			(CMST),
	.CMSTClr		(CMSTClr),

	.RspCrcSet		(RspCrcSet),
	.CmdSentSet		(CmdSentSet),
	.CmdToutSet		(CmdToutSet),
	.RspFinSet		(RspFinSet),

	.CmdOn			(CmdOn),
	.RspIndex		(RspIndex),
	.Response0		(Response0),
	.Response1		(Response1),
	.Response2		(Response2),
	.Response3		(Response3),
		
	.iDataTimer		(iDataTimer),
	.iBlkSize		(iBlkSize),			
	
	.iSDIDatCon		(SDIDatCon),
	.DTST			(DTST),
	.DTSTClr		(DTSTClr),

	.BlkNumCnt		(BlkNumCnt),	
	.BlkCnt			(BlkCnt),
	.NoBusySet		(NoBusySet),
	.CrcStaSet		(CrcStaSet),
	.DatCrcSet		(DatCrcSet),
	.DatToutSet		(DatToutSet),
	.DatFinSet		(DatFinSet),
	.BusyFinSet		(BusyFinSet),
	.TxDatOn		(TxDatOn),
	.RxDatOn		(RxDatOn),

	.FRST			(FRST),
	.FFfailSet		(RxUnderrun | TxOverrun),

	.TFDET			(TFDET),
	.RFDET			(RFDET),
	.TFHalf			(TFHalf),
	.TFEmpty		(TFEmpty),

	.RFFull			(RFFull),
	.RFHalf			(RFHalf),
	.FFCNT			(FFCNT),
	
	.TxWriteEn		(TxWriteEn),
	.RxRdPtrInc		(RxRdPtrInc),

	.FIFOdata		(FRdData),


	.RCmdStart		(RCmdStart),
	.RCmdStartClr	(RCmdStartClr),
	.iAutoReadCon	(AutoReadCon),
    .ErrorState		(ErrorState),
	.ResponseCMD18	(ResponseCMD18),
	.AutoReadComplete (AutoReadComplete),
	
	.MMC_INT		(MMC_INT)
	);


mmc_FifoDmaCtr  DataFifo_DMA(
	.PCLK			(PCLK),
	.PRESETn		(PRESETn),
	.SDreset		(SDreset),
	.FRST			(FRST), // FIFO reset signal

	.DatMode		(DatMode),
	.DMASize		(DMASize),
	.TxActive		(TxActive), // Tx fifo enable
	.TxWriteEn		(TxWriteEn),
	.TxRdPtrInc		(TxRdPtrInc),
	.PWData			(PWDATA),

	.RxActive		(RxActive),
	.RxRdPtrInc		(RxRdPtrInc),

	.RxWriteEn		(RxWriteEn),
	.RxFWrData		(RxFWrData),

	.RxUnderrun		(RxUnderrun),
	.TxOverrun		(TxOverrun),
	.TFDET			(TFDET),
	.TFHalf			(TFHalf),
   	.TFEmpty		(TFEmpty), 
   	.TFREmpty		(TFREmpty), 


    .RFFull			(RFFull),
    .RFHalf			(RFHalf),
		      	
    .RFDET			(RFDET),

   	.FFCNT			(FFCNT),
	.FIFORdData		(FRdData),
	.EnDMA			(EnDMA),
//------------DMA request signals---------      	
	.DREQ			(MMC_DMAREQ)
	);

//--------------------------------------------------
// Power Save Control
//--------------------------------------------------
mmc_PSave mmc_PowerSave(
	.PCLK		(PCLK),
	.PRESETn	(PRESETn),
	.CKPulse	(CKPulse),	 	// Prescaled Clock
	.CMST		(CMST),			// Command Start Signal
	.ENCLK_REG	(ENCLK_REG), 		// User Clock Enable Signal
	.ENCLK_FIFO	(ENCLK_FIFO), 	// FIFO protection Clock Enable Signal
	.CmdCtrlIdle(CmdCtrlIdle),	// Present Command state
	.BusyChkIdle(BusyChkIdle),
	.DatCtrlIdle(DatCtrlIdle),	// Present Data state
	.PSAVEON	(PSAVEON),		// PowerSave On /off
	.ENCLK		(ENCLK)
);


assign MMC_CMDOUT = CMDOUT;
assign MMC_nCMDEN = nCMDEN;
assign MMC_DATOUT = DATOUT;
assign MMC_nDATEN = nDATEN;

`ifdef USE_FBCLK
mmc_FeedBackSync FeedBackSync(
	.nRst			(PRESETn),
	.SDreset		(SDreset),
	.MMC_FBCLK		(MMC_FBCLK),
	.MMC_CMDIN		(MMC_CMDIN),
	.MMC_DATIN		(MMC_DATIN),
	.CMDIN			(CMDIN),
	.DATIN			(DATIN)
	);
`else
	assign CMDIN = MMC_CMDIN;
	assign DATIN = MMC_DATIN;
`endif



//----------------------
// AUTO read module
//----------------------

AUTORead AutoRead(
	.nRst			(PRESETn),
    .SDreset		(SDreset),		
    .PCLK			(PCLK),

	// Register input
	.AutoReadEn		(AutoReadCon[1]),// Auto mode Enable	 
	.RCmdStart		(RCmdStart),// APB register setting Value
	.RCmdStartClr	(RCmdStartClr),									
	.SingleMultiRead(AutoReadCon[0]),//

	.Response0		(Response0),

	.NoBusySet		(NoBusySet),
	.BusyFinSet		(BusyFinSet),
    .RspCrcSet		(RspCrcSet),
    .RspFinSet		(RspFinSet),
    .CmdToutSet		(CmdToutSet),
    .DatCrcSet		(DatCrcSet),
    .DatFinSet		(DatFinSet),
	// for Command Control
    .CmdArg			(CmdArg[31:0]),
    .CmdIndex		(SDICmdCon[6:0]),
    .CMST			(CMST),	
 	.CMSTClr		(CMSTClr),

	.NoCRCRsp		(SDICmdCon[11]),
	.LongRsp		(SDICmdCon[8]),
	.WaitRsp		(SDICmdCon[7]),

	// for Data control
	// for Data register setting 
	.BusyRsp		(SDICmdCon[12]),	
	.AbortCmd		(SDICmdCon[10]),

	// output
	.CmdStartMuxO	(CmdStartMuxO),
	.CmdArgMuxO		(CmdArgMuxO),
	.CmdIndexMuxO	(CmdIndexMuxO),
	.NoCRCRspMuxO	(NoCRCRspMuxO),
	.LongRspMuxO	(LongRspMuxO),    
	.WaitRspMuxO	(WaitRspMuxO),    
	.BusyRspMuxO	(BusyRspMuxO),    
	.AbortCmdMuxO	(AbortCmdMuxO),   

	.ResponseCMD18	(ResponseCMD18),
	.AutoReadComplete(AutoReadComplete),
	.ErrorState		(ErrorState)
	);

endmodule
