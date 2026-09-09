// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech          
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// File Name           : MMCTop.v
// File Revision       : Ver 3.0 - CT2000 (TSMC)
// Revision History    : 
// 
// 2008.4.23 // SDDataTimer Register & Prescaler Register Bit Width Resizing
//  -----------------------------------------------------------------------------
// Description         : TOP module of mmc/sd 
//  ----------------------------------------------------------------

`timescale 1ns/1ps


`define CHIP
`define HSMMC

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

`ifdef	CHIP
		TESTMODE, // for Scan insertion
`endif
		MMC_INT,
		MMC_DMAREQ,
		MMC_CLKOUT,
		MMC_CMDOUT,
		MMC_DATOUT,
		MMC_nCMDEN,
		MMC_nDATEN
	
		);

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

`ifdef CHIP
input			TESTMODE;
`endif
output			MMC_INT;
output			MMC_DMAREQ;
output			MMC_CLKOUT;
output			MMC_CMDOUT;
output	[AW-1:0]	MMC_DATOUT;
output			MMC_nCMDEN;
output			MMC_nDATEN;


wire	[2:0]	DelaySel;
wire			InvSel;

wire	[31:0]	CmdArg;
wire	[15:0]	iSDIPRE;	// Revision
wire	[31:0]	iDataTimer; // revision
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

wire	CKPulse;
wire	neg_CKPulse;
wire	nCMDEN;
wire	CMSTClr;
wire	RspCrcSet;
wire	CmdSentSet;
wire	CmdToutSet;
wire	RspFinSet;
wire	CmdOn;
wire	DTST;
wire	NoBusySet;
wire	CrcStaSet;
wire	DatCrcSet;
wire	DatToutSet;
wire	DatFinSet;
wire	BusyFinSet;
wire	TxDatOn;
wire	RxDatOn;
wire	DTSTClr;
wire	TxActive;
wire	TxRdPtrInc;
wire	RxActive;
wire	RxWriteEn;
wire	TFREmpty;
wire	RFFull;
wire	nDATEN;
wire	CMST;
wire	FRST;
wire	RxUnderrun;
wire	TxOverrun;
wire	TFDET;
wire	RFDET;
wire	TFHalf;
wire	TFEmpty;
wire	RFHalf;
wire	TxWriteEn;
wire	RxRdPtrInc;
wire	RCmdStart;
wire	RCmdStartClr;
wire	AutoReadComplete;


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
	
	.DelaySel		(DelaySel),
	.InvSel			(InvSel),


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

`ifdef CHIP
wire		MMC_FBCLK_DLY0;
wire		MMC_FBCLK_DLY1;
wire		MMC_FBCLK_DLY2;
wire		MMC_FBCLK_DLY3;
wire		MMC_FBCLK_DLY4;
wire		MMC_FBCLK_DLY_C;
wire		iMMC_FBCLK;
wire		iFBCLK_BUF;
wire		iFBCLK;

assign 	iMMC_FBCLK = (InvSel== 1'b0)? MMC_FBCLK : ~MMC_FBCLK; // Clock Invert Select
DLY3ns	FBCLKBUF0(	.Y(MMC_FBCLK_DLY0),	.A(iMMC_FBCLK));
DLY3ns	FBCLKBUF1(	.Y(MMC_FBCLK_DLY1),	.A(MMC_FBCLK_DLY0));
DLY3ns	FBCLKBUF2(	.Y(MMC_FBCLK_DLY2),	.A(MMC_FBCLK_DLY1));
DLY3ns	FBCLKBUF3(	.Y(MMC_FBCLK_DLY3),	.A(MMC_FBCLK_DLY2));
DLY3ns	FBCLKBUF4(	.Y(MMC_FBCLK_DLY4),	.A(MMC_FBCLK_DLY3));

// synopsys dc_script_begin
// set_dont_touch {FBCLKBUF0, FBCLKBUF1, FBCLKBUF2, FBCLKBUF3, FBCLKBUF4}
// synopsys dc_script_end

assign 	MMC_FBCLK_DLY_C = 	
					(DelaySel==3'b000)?	iMMC_FBCLK: 		// Bypass
					(DelaySel==3'b001)?	MMC_FBCLK_DLY0:	
					(DelaySel==3'b010)?	MMC_FBCLK_DLY1:	
					(DelaySel==3'b011)?	MMC_FBCLK_DLY2:	
					(DelaySel==3'b100)?	MMC_FBCLK_DLY3:	
					(DelaySel==3'b101)?	MMC_FBCLK_DLY4:	iMMC_FBCLK;

assign iFBCLK = (TESTMODE==1'b1)? PCLK: MMC_FBCLK_DLY_C;

BUFX2	FBCLK_BUF(.Y(iFBCLK_BUF),.A(iFBCLK));

// synopsys dc_script_begin
// set_dont_touch {FBCLK_BUF}
// synopsys dc_script_end


`endif
assign MMC_CMDOUT = CMDOUT;
assign MMC_nCMDEN = nCMDEN;
assign MMC_DATOUT = DATOUT;
assign MMC_nDATEN = nDATEN;

mmc_FeedBackSync FeedBackSync(
	.nRst			(PRESETn),
	.SDreset		(SDreset),
	`ifdef CHIP
	.MMC_FBCLK		(iFBCLK_BUF),
	`else
	.MMC_FBCLK		(MMC_FBCLK),
	`endif
	.MMC_CMDIN		(MMC_CMDIN),
	.MMC_DATIN		(MMC_DATIN),
	.CMDIN			(CMDIN),
	.DATIN			(DATIN)
	);

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

module DLY3ns(Y,A);

input	A;
output  Y;

wire A1,A2,A3,A4,A5,A6;
DLY3X1 DLY1  (.Y(A1), .A(A));
DLY3X1 DLY2  (.Y(A2), .A(A1));
DLY3X1 DLY3  (.Y(A3), .A(A2));
DLY3X1 DLY4  (.Y(A4), .A(A3));
DLY3X1 DLY5  (.Y(A5), .A(A4));
DLY3X1 DLY6  (.Y(A6), .A(A5));
DLY3X1 DLY7  (.Y(Y), .A(A6));
endmodule
