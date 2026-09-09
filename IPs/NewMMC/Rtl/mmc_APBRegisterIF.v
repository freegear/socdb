// =================================================================
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from RichenTech          
//  ALL RIGHTS RESERVED RichenTech                                
// -----------------------------------------------------------------
// File Name           : mmc_APBRegisterIF.v
// File Revision       : Ver 3.0 - CT2000 (TSMC)
// Revision History    : 
// 
// 2008.4.23 // SDDataTimer Register & Prescaler Register Bit Width Resizing
//  -----------------------------------------------------------------------------
// Description         : APB Register module of mmc/sd 
//  ----------------------------------------------------------------


`timescale 1ns/1ps

`define SDICONAddr              5'b00000
`define SDIPREAddr              5'b00001
`define SDICmdArgAddr           5'b00010
`define SDICmdConAddr           5'b00011
`define SDICmdStaAddr           5'b00100
`define SDIRSP0Addr             5'b00101
`define SDIRSP1Addr             5'b00110
`define SDIRSP2Addr             5'b00111
`define SDIRSP3Addr             5'b01000
`define SDIDTimerAddr           5'b01001
`define SDIBSizeAddr            5'b01010
`define SDIDatConAddr           5'b01011
`define SDIDatCntAddr           5'b01100
`define SDIDatStaAddr           5'b01101
`define SDIFSTAAddr             5'b01110
`define SDIIntMskAddr           5'b01111
`define SDIIntStaAddr           5'b10000
`define SDIDATAddr              5'b10001
`define SDIAutoReadConAddr		5'b10010
`define SDIAutoReadStaAddr		5'b10011
`define	SDIAutoReadRspAddr		5'b10100
`define SDFBCLKCONAddr			5'b10101

module mmc_APBRegisterIF (
		PCLK,
		PRESETn,
		PSEL,
		PENABLE,
		PWRITE,
		PADDR,
		PWDATA,	
		PRDATA,

		SDreset,
		ENCLK,
		PSAVEON,
	
		iSDIPRE,
		CmdArg,

		iSDICmdCon,
		CMST,
		CMSTClr,

		RspCrcSet,
		CmdSentSet,
		CmdToutSet,
		RspFinSet,

		CmdOn,
		RspIndex,
		Response0,
		Response1,
		Response2,
		Response3,
			
		iDataTimer,
		iBlkSize,			

		iSDIDatCon,
		DTST,
		DTSTClr,

		BlkNumCnt,
		BlkCnt,
		NoBusySet,
		CrcStaSet,
		DatCrcSet,
		DatToutSet,
		DatFinSet,
		BusyFinSet,
		TxDatOn,
		RxDatOn,

		FRST,
		FFfailSet,

		TFDET,
		RFDET,
		TFHalf,
		TFEmpty,

		RFFull,
		RFHalf,
		FFCNT,
		
		TxWriteEn,
		RxRdPtrInc,

		FIFOdata,


		// FBCLK contol
		DelaySel,
		InvSel,

		// Auto read signal
		RCmdStart,
		RCmdStartClr,
		iAutoReadCon,
		ErrorState,
		ResponseCMD18,
		AutoReadComplete,
		MMC_INT

		
	);

input       	PCLK;             // APB Bus Clock
input         	PRESETn;          // APB Bus Reset
input         	PSEL;             // APB Peripheral select
input         	PWRITE;           // APB Peripheral Write
input         	PENABLE;          // APB Peripheral enable
input  	[31:0] 	PWDATA;           // Write databus
input	[6:2] 	PADDR;            // APB Address

output	[31:0]	PRDATA;
output			SDreset;
output			ENCLK;
output			PSAVEON;
	
output	[15:0]	iSDIPRE;

output	[31:0]	CmdArg;
	
output	[12:0]	iSDICmdCon;
output			CMST;
input			CMSTClr;


input			RspCrcSet;
input			CmdSentSet;
input			CmdToutSet;
input			RspFinSet;
input			CmdOn;
input	[7:0]	RspIndex;

input	[31:0]	Response0;
input	[31:0]	Response1;
input	[31:0]	Response2;
input	[31:0]	Response3;
			
//output [22:0]	iDataTimer;
output [31:0]	iDataTimer; // Revision :Data Timer Increase

output [15:0]	iBlkSize;			
	
output	[30:0]	iSDIDatCon;
output			DTST;
input			DTSTClr;

input	[15:0]	BlkNumCnt;
input	[15:0]	BlkCnt;

input			NoBusySet;

input			CrcStaSet;
input			DatCrcSet;
input			DatToutSet;
input			DatFinSet;
input			BusyFinSet;
input			TxDatOn;
input			RxDatOn;

output			FRST;
input			FFfailSet;

input			TFDET;
input			RFDET;
input			TFHalf;
input			TFEmpty;

input			RFFull;
input			RFHalf;
input	[4:0]	FFCNT;
output			TxWriteEn;
output			RxRdPtrInc;


input	[31:0]	FIFOdata;

output	[2:0]	DelaySel;
output			InvSel;


output			RCmdStart;
input			RCmdStartClr;
output	[1:0]	iAutoReadCon;
input	[1:0]	ErrorState;
input	[31:0]	ResponseCMD18;
input			AutoReadComplete;

output			MMC_INT;
//--------------------------------
reg				SDreset;
reg				ENCLK;
reg				PSAVEON;

//--------------------------------
reg		[15:0]	iSDIPRE;
wire	[15:0]	NextSDIPRE;
//--------------------------------
reg		[31:0]	CmdArg;
wire	[31:0]	NextSDICmdArg;
//--------------------------------
reg				NextCMST;
reg				CMSTSet;
reg				CMST;

//--------------------------------
reg				NextRspCrc;
reg				RspCrc;

reg				NextCmdSent;
reg				CmdSent; 

reg				NextCmdTout;
reg				CmdTout;

reg				NextRspFin;
reg				RspFin;

//--------------------------------
//reg		[22:0]	iDataTimer;
reg		[31:0]	iDataTimer; //Revision
reg		[15:0]	iBlkSize;

//--------------------------------
reg				NextNoBusy;
reg				NoBusy;



reg				NextCrcSta;
reg				CrcSta;

reg				NextDatCrc;
reg				DatCrc;

reg				NextDatTout;
reg				DatTout;

reg				NextDatFin;
reg				DatFin;

reg				NextBusyFin;
reg				BusyFin;
	
reg				FRST;
reg				NextFFfail;
reg				FFfail;

reg				AutoCMDCompleteInt;
reg				R12ErrorInt;
reg				R18ErrorInt;
reg				NoBusyInt;
reg				RspCrcInt;
reg				CmdSentInt;
reg				CmdToutInt;
reg				RspFinInt;
reg				FFfailInt;
reg				CrcStaInt;
reg				DatCrcInt;
reg				DatToutInt;
reg				DatFinInt;
reg				BusyFinInt;
reg				TFHalfInt;
reg				TFEmpInt;
reg				RFFullInt;
reg				RFHalfInt;

reg		[31:0]	PRDATA;
reg		[31:0]	NextPRDATA;

reg		[2:0]	DelaySel;
reg				InvSel;



wire			SDICON_w;
wire			NextiSDIPRE_w;
wire			NextSDICmdArg_w;
wire			NextSDICmdCon_w;
wire   			SDICmdCon_w;
wire   			SDICmdSta_w;
wire   		 	NextSDIDTimer_w;
wire   	 		NextSDIBSize_w;
wire   	 		NextSDIDatCon_w;
wire    		SDIDatCon_w;
wire    		SDIDatCnt_w;
wire    		SDIDatSta_w;
wire    		SDIFSTA_w;
wire    		SDIIntMsk_w;
wire    		SDIDAT_w;
wire    		NextSDIDAT_w;
wire    		SDIIntSta_w;
wire  			NextSDICON_r;
wire   			NextiSDIPRE_r;
wire    		NextSDICmdArg_r;
wire  			NextSDICmdCon_r;
wire    		NextSDICmdSta_r;
wire    		NextSDIRSP0_r;
wire    		NextSDIRSP1_r;
wire    		NextSDIRSP2_r;
wire    		NextSDIRSP3_r;
wire    		NextSDIDTimer_r;
wire    		NextSDIBSize_r;
wire    		NextSDIDatCon_r;
wire    		NextSDIDatCnt_r;
wire    		NextSDIDatSta_r;
wire    		NextSDIFSTA_r;
wire    		NextSDIIntMsk_r;
wire    		NextSDIDAT_r;
wire    		NextSDIIntSta_r;
wire			NextSDIAutoReadCon_r;
wire			NextSDIAutoReadCon_w;
wire			SDIAutoReadCon_w;
wire			NextSDIAutoReadSta_r;
wire			NextSDIAutoReadSta_w;
wire			SDIAutoReadSta_w;
wire			NextSDIAutoReadRsp_r;
wire			SDFBCLKCON_w;
wire			NextSDFBCLKCON_r;

assign 	SDFBCLKCON_w	= ((PADDR == `SDFBCLKCONAddr) && (PSEL == 1'b1) &&
						(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	NextSDFBCLKCON_r	= ((PADDR == `SDFBCLKCONAddr) && (PSEL == 1'b1) &&
						(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign 	SDICON_w	= ((PADDR == `SDICONAddr) && (PSEL == 1'b1) &&
						(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	NextiSDIPRE_w	= ((PADDR == `SDIPREAddr) && (PSEL == 1'b1) &&
						(PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	NextSDICmdArg_w	= ((PADDR == `SDICmdArgAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	NextSDICmdCon_w	= ((PADDR == `SDICmdConAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	SDICmdCon_w	= ((PADDR == `SDICmdConAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	SDICmdSta_w	= ((PADDR == `SDICmdStaAddr) && (PSEL == 1'b1) &&
	   					(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign	NextSDIDTimer_w	= ((PADDR == `SDIDTimerAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign	NextSDIBSize_w	= ((PADDR == `SDIBSizeAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	NextSDIDatCon_w	= ((PADDR == `SDIDatConAddr) && (PSEL == 1'b1) &&
	   					(PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	SDIDatCon_w	= ((PADDR == `SDIDatConAddr) && (PSEL == 1'b1) &&
	   					(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	SDIDatCnt_w	= ((PADDR == `SDIDatCntAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	SDIDatSta_w	= ((PADDR == `SDIDatStaAddr) && (PSEL == 1'b1) &&
	   					(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	SDIFSTA_w	= ((PADDR == `SDIFSTAAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign	SDIIntMsk_w	= ((PADDR == `SDIIntMskAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign	SDIDAT_w	= ((PADDR == `SDIDATAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign	NextSDIDAT_w	= ((PADDR == `SDIDATAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign	SDIIntSta_w	= ((PADDR == `SDIIntStaAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign 	NextSDICON_r	= ((PADDR == `SDICONAddr) && (PSEL == 1'b1) &&
						(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign 	NextiSDIPRE_r	= ((PADDR == `SDIPREAddr) && (PSEL == 1'b1) &&
						(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign  NextSDICmdArg_r	= ((PADDR == `SDICmdArgAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign 	NextSDICmdCon_r	= ((PADDR == `SDICmdConAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign 	NextSDICmdSta_r	= ((PADDR == `SDICmdStaAddr) && (PSEL == 1'b1) &&
	   					(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIRSP0_r   = ((PADDR == `SDIRSP0Addr ) && (PSEL == 1'b1) && 
	   					(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIRSP1_r   = ((PADDR == `SDIRSP1Addr ) && (PSEL == 1'b1) && 
	   					(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIRSP2_r  	= ((PADDR == `SDIRSP2Addr ) && (PSEL == 1'b1) && 
	   					(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIRSP3_r  	= ((PADDR == `SDIRSP3Addr ) && (PSEL == 1'b1) && 
	   					(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIDTimer_r	= ((PADDR == `SDIDTimerAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIBSize_r	= ((PADDR == `SDIBSizeAddr) && (PSEL == 1'b1) && 
						(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign 	NextSDIDatCon_r	= ((PADDR == `SDIDatConAddr) && (PSEL == 1'b1) &&
	   					(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign 	NextSDIDatCnt_r	= ((PADDR == `SDIDatCntAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign 	NextSDIDatSta_r	= ((PADDR == `SDIDatStaAddr) && (PSEL == 1'b1) &&
	   					(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign 	NextSDIFSTA_r	= ((PADDR == `SDIFSTAAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIIntMsk_r	= ((PADDR == `SDIIntMskAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIDAT_r	= ((PADDR == `SDIDATAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIIntSta_r	= ((PADDR == `SDIIntStaAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIAutoReadCon_r	= ((PADDR == `SDIAutoReadConAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign	NextSDIAutoReadCon_w	= ((PADDR == `SDIAutoReadConAddr) && (PSEL == 1'b1) &&
					   	(PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;
					
assign	SDIAutoReadCon_w	= ((PADDR == `SDIAutoReadConAddr) && (PSEL == 1'b1) &&
						(PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign  NextSDIAutoReadSta_r= ((PADDR == `SDIAutoReadStaAddr) && (PSEL == 1'b1) &&
                                                (PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

assign  NextSDIAutoReadSta_w= ((PADDR == `SDIAutoReadStaAddr) && (PSEL == 1'b1) &&
                                                (PENABLE == 1'b0) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign  SDIAutoReadSta_w	= ((PADDR == `SDIAutoReadStaAddr) && (PSEL == 1'b1) &&
                                                (PENABLE == 1'b1) && (PWRITE == 1'b1))? 1'b1 : 1'b0;

assign  NextSDIAutoReadRsp_r	= ((PADDR == `SDIAutoReadRspAddr) && (PSEL == 1'b1) &&
                                                (PENABLE == 1'b0) && (PWRITE == 1'b0))? 1'b1 : 1'b0;

wire	AutoCMDCompleteClr;
wire	R12ErrorClr;
wire	R18ErrorClr;
wire	RspCrcClr;
wire	CmdSentClr;
wire	CmdToutClr;
wire	RspFinClr;
wire	NoBusyClr;
wire	CrcStaClr;
wire	DatCrcClr;
wire	DatToutClr;
wire	DatFinClr;
wire	BusyFinClr;
wire	FFfailClr;
wire	DTSTSet;

assign 	AutoCMDCompleteClr	= ( ((SDIAutoReadSta_w) && (PWDATA[2] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[18]==1'b1)) )? 1'b1:1'b0;
assign	R12ErrorClr	= ( ((SDIAutoReadSta_w) && (PWDATA[1] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[17]==1'b1)) )? 1'b1:1'b0;
assign	R18ErrorClr	= ( ((SDIAutoReadSta_w) && (PWDATA[0] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[16]==1'b1)) )? 1'b1:1'b0;

assign 	RspCrcClr	= ( ((SDICmdSta_w) && (PWDATA[12] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[14]==1'b1)) ) ? 1'b1:1'b0;
assign 	CmdSentClr	= ( ((SDICmdSta_w) && (PWDATA[11] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[13]==1'b1)) )? 1'b1:1'b0;
assign 	CmdToutClr	= ( ((SDICmdSta_w) && (PWDATA[10] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[12]==1'b1)) )? 1'b1:1'b0;
assign	RspFinClr	= ( ((SDICmdSta_w) && (PWDATA[9] == 1'b1))  | ((SDIIntSta_w) && (PWDATA[11]==1'b1)) )? 1'b1:1'b0;
assign	NoBusyClr	= ( ((SDIDatSta_w) && (PWDATA[11] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[15]==1'b1)) )? 1'b1:1'b0;
assign	CrcStaClr	= ( ((SDIDatSta_w) && (PWDATA[7] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[9]==1'b1)) )? 1'b1:1'b0;
assign	DatCrcClr	= ( ((SDIDatSta_w) && (PWDATA[6] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[8]==1'b1)) )? 1'b1:1'b0;
assign	DatToutClr	= ( ((SDIDatSta_w) && (PWDATA[5] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[7]==1'b1)) )? 1'b1:1'b0;
assign	DatFinClr	= ( ((SDIDatSta_w) && (PWDATA[4] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[6]==1'b1)) )? 1'b1:1'b0;
assign	BusyFinClr	= ( ((SDIDatSta_w) && (PWDATA[3] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[5]==1'b1)) )? 1'b1:1'b0;

assign	FFfailClr	= ( ((SDIFSTA_w) && (PWDATA[14] == 2'b11)) | ((SDIIntSta_w)&&(PWDATA[11]==1'b1)) )? 1'b1:1'b0;
assign	DTSTSet		= ((SDIDatCon_w) && (PWDATA[18]))? 1'b1 : 1'b0;
// SDFBCLKCON register
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
		DelaySel <= 3'b000;
		InvSel	 <=	1'b0;
	end
	else if (SDFBCLKCON_w) 
	begin
		DelaySel	<= PWDATA[2:0];	
		InvSel		<= PWDATA[3];
	end
end
		
// SDICON register
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
		begin
		ENCLK 	<= 1'b0;
		PSAVEON <= 0;
		end
	else if (SDreset)
		begin
		ENCLK 	<= 1'b0;
		PSAVEON <= 1'b0;
		end
	else if (SDICON_w)
		begin
		ENCLK 	<= PWDATA[0];
		PSAVEON <= PWDATA[1];
		end
end
// SDICON register
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	SDreset <= 1'b0;
	else 
		begin
		if (SDICON_w)
    	SDreset <=PWDATA[8];
		else
		SDreset <= 1'b0;
		end
end


//-----------------------------------------------------------------------------------------------
assign NextSDIPRE = (NextiSDIPRE_w)? PWDATA[15:0]:iSDIPRE;
// iSDIPRE register
always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	iSDIPRE <= (16'b00000001);
	else
		if (SDreset)
		iSDIPRE <= (16'b00000001);
		else
		iSDIPRE <= NextSDIPRE;
end 

//-----------------------------------------------------------------------------------------------
assign NextSDICmdArg = (NextSDICmdArg_w)? PWDATA[31:0]:CmdArg[31:0];
always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		CmdArg <= (32'h00000000);
	else 
		if (SDreset)
		CmdArg <= (32'h00000000);
		else
		CmdArg <= NextSDICmdArg;
end 

//-----------------------------------------------------------------------------------------------
reg [12:0]	iSDICmdCon ;
wire	[12:0]	NextSDICmdCon;
assign NextSDICmdCon = (NextSDICmdCon_w)?{PWDATA[14:9],PWDATA[6:0]}:iSDICmdCon;

// SDICmdCon register
always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
        iSDICmdCon <= (13'd0);
	else
    	if (SDreset)
    	iSDICmdCon <= (13'd0);
    	else
    	iSDICmdCon <= NextSDICmdCon;
end

//-----------------------------------------------------------------------------------------------
always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		CMSTSet	<= 1'b0;
	else if (SDICmdCon_w)
		CMSTSet	<= PWDATA[8];
	else 
		CMSTSet <= 1'b0;
end

always @(CMSTSet or CMSTClr or CMST)
begin
	if (CMSTSet)
		NextCMST = 1'b1;
	else if (CMSTClr)
		NextCMST = 1'b0;
	else
		NextCMST = CMST;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
		CMST <= 1'b0;
	else 
		if(SDreset)
		CMST<= 1'b0;
		else
		CMST <= NextCMST;
end

// SDICmdSta register
always @(RspCrcSet or RspCrcClr or RspCrc)
begin
	if (RspCrcSet)
		NextRspCrc = 1'b1;
	else if (RspCrcClr)
		NextRspCrc = 1'b0;
	else
		NextRspCrc = RspCrc;

end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		RspCrc <= 1'b0;
	else if (SDreset)
		RspCrc <= 1'b0;
	else
		RspCrc <= NextRspCrc;
end

// Command Sent
always @(CmdSentSet or CmdSentClr or CmdSent)
begin
	if (CmdSentSet)
		NextCmdSent = 1'b1 ;
	else if(CmdSentClr)
		NextCmdSent = 1'b0 ;
	else
		NextCmdSent = CmdSent; 
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		CmdSent<= 1'b0;
	else if (SDreset)
		CmdSent<= 1'b0;
	else
		CmdSent <= NextCmdSent;
end

// Command Time out
always @(CmdToutClr or CmdToutSet or CmdTout)
begin
	if (CmdToutSet == 1'b1)
    	NextCmdTout = 1'b1;
	else if (CmdToutClr == 1'b1)
    	NextCmdTout = 1'b0;
	else
    	NextCmdTout = CmdTout;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		CmdTout <= 1'b0;
	else
		if (SDreset)
		CmdTout <= 1'b0;
		else
		CmdTout <= NextCmdTout;
end

// Response Receive End
always @(RspFinSet or RspFinClr or RspFin)
begin
	if (RspFinSet)
		NextRspFin = 1'b1;
	else if (RspFinClr)
		NextRspFin = 1'b0;
	else
		NextRspFin = RspFin;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		RspFin <= 1'b0;
	else if (SDreset)
		RspFin <= 1'b0;
	else
		RspFin <= NextRspFin;
end

// read only register
// SDIRSP0 register
// SDIRSP1 register 
// SDIRSP2 register 
// SDIRSP3 register

wire	[31:0] NextDataTimer; // revision
assign NextDataTimer = (NextSDIDTimer_w)? PWDATA[31:0]:iDataTimer;
// SDIDTimer register
always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		iDataTimer <=32'h10000;
	else if (SDreset)
		iDataTimer <=32'h10000;
	else
		iDataTimer <= NextDataTimer;
end

wire	[15:0]	NextSDIBSize;
assign NextSDIBSize = (NextSDIBSize_w)? PWDATA[15:0]:iBlkSize;
// SDIBSize register
always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		iBlkSize <= 16'h0000;
	else if (SDreset)
		iBlkSize <= 16'h0000;
	else
		iBlkSize <= NextSDIBSize;
end

reg	[30:0]	iSDIDatCon;
wire	[30:0]	NextSDIDatCon;
assign NextSDIDatCon = (NextSDIDatCon_w)? {PWDATA[31:19], PWDATA[17:0]}:iSDIDatCon;
// SDIDatCon register

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		iSDIDatCon <=  {6'b001000, 25'd0};
	else if (SDreset)
		iSDIDatCon <=  {6'b001000, 25'd0};
	else 
		iSDIDatCon <=NextSDIDatCon;
end

reg	NextDTST;
always @(DTSTClr or DTSTSet or DTST)
begin
	if (DTSTSet)
		NextDTST = 1'b1;
	else if (DTSTClr)
		NextDTST = 1'b0;
	else
		NextDTST = DTST;
end

reg	DTST;
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
		DTST <= 1'b0;
	else if (SDreset)
		DTST <= 1'b0;
	else
		DTST <= NextDTST;
end

// read only register
// SDIDatCnt register

// SDIDatSta;
//
always @(NoBusyClr or NoBusySet or NoBusy)
begin
	if (NoBusyClr)
		NextNoBusy = 1'b0;
	else if (NoBusySet)
		NextNoBusy = 1'b1;
	else
		NextNoBusy = NoBusy;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		NoBusy <= 1'b0;
	else if (SDreset)
		NoBusy <= 1'b0;
	else	
		NoBusy <= NextNoBusy;
end


always @(CrcStaClr or CrcStaSet or CrcSta)
begin
	if (CrcStaClr)
		NextCrcSta = 1'b0;
	else if (CrcStaSet)
		NextCrcSta = 1'b1;
	else
		NextCrcSta = CrcSta;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		CrcSta <= 1'b0;
	else if (SDreset)
		CrcSta <= 1'b0;
	else
		CrcSta <= NextCrcSta;
end

always @(DatCrcClr or DatCrcSet or DatCrc)
begin
	if (DatCrcClr)
	NextDatCrc = 1'b0;
	else if (DatCrcSet)
	NextDatCrc = 1'b1;
	else
	NextDatCrc = DatCrc;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		DatCrc <= 1'b0;
	else if (SDreset)
		DatCrc <= 1'b0;
	else
		DatCrc <= NextDatCrc;
end

always @(DatToutClr or DatToutSet or DatTout)
begin
	if (DatToutClr)
		NextDatTout = 1'b0;
	else if (DatToutSet)
		NextDatTout = 1'b1;
	else
		NextDatTout = DatTout;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		DatTout <= 1'b0;
	else if (SDreset)
		DatTout <= 1'b0;
	else
		DatTout <= NextDatTout;
end

always @(DatFinClr or DatFinSet or DatFin)
begin
	if (DatFinClr)
		NextDatFin = 1'b0;
	else if (DatFinSet)
		NextDatFin = 1'b1;
	else
		NextDatFin = DatFin;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
		DatFin <= 1'b0;
	else if (SDreset)
		DatFin <= 1'b0;
	else
		DatFin <= NextDatFin;
end

always @(BusyFinClr or BusyFinSet or BusyFin)
begin
	if (BusyFinClr)
		NextBusyFin = 1'b0;
	else if (BusyFinSet)
		NextBusyFin = 1'b1;
	else
		NextBusyFin = BusyFin;
end


always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
	BusyFin <= 1'b0;
	else
		if (SDreset)
		BusyFin <= 1'b0;
		else
		BusyFin <= NextBusyFin;
end

always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn== 1'b0)
		FRST <= 1'b0;
	else if (SDIFSTA_w)
		FRST <= PWDATA[16];
	else
		FRST <= 1'b0;
end

always @(FFfailClr or FFfailSet or FFfail)
begin
	if (FFfailClr)
		NextFFfail = 1'b0;
	else if (FFfailSet)
		NextFFfail = 1'b1;
	else
        NextFFfail = FFfail;
end

always @(posedge PCLK or negedge PRESETn)
begin
        if (PRESETn == 1'b0)
        	FFfail <= 1'b0;
        else if (SDreset)
			FFfail	<= 1'b0;
		else
	        FFfail <= NextFFfail;
end

assign  TxWriteEn = NextSDIDAT_w;
assign  RxRdPtrInc = NextSDIDAT_r;
// SDIIntMsk
always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
	begin
		AutoCMDCompleteInt <= 	1'b0;
		R12ErrorInt	<=	1'b0;
		R18ErrorInt	<=	1'b0;
		NoBusyInt	<=	1'b0;
		RspCrcInt	<=	1'b0;
		CmdSentInt	<=	1'b0;
		CmdToutInt	<= 	1'b0;
		RspFinInt	<=	1'b0;
		FFfailInt	<=	1'b0;
		CrcStaInt	<=	1'b0;
		DatCrcInt	<=	1'b0;
		DatToutInt	<=	1'b0;
		DatFinInt	<=	1'b0;
		BusyFinInt	<=	1'b0;
		TFHalfInt	<= 	1'b0;
		TFEmpInt	<=	1'b0;
		RFFullInt	<=	1'b0;
		RFHalfInt	<=	1'b0;
	end
	else if (SDreset)
	     begin
                AutoCMDCompleteInt <= 	1'b0;
                R12ErrorInt     <=      1'b0;
                R18ErrorInt     <=      1'b0;
                NoBusyInt       <=      1'b0;
                RspCrcInt       <=      1'b0;
                CmdSentInt      <=      1'b0;
                CmdToutInt      <=      1'b0;
                RspFinInt       <=      1'b0;
                FFfailInt       <=      1'b0;
                CrcStaInt       <=      1'b0;
                DatCrcInt       <=      1'b0;
                DatToutInt      <=      1'b0;
                DatFinInt       <=      1'b0;
                BusyFinInt      <=      1'b0;
                TFHalfInt       <=      1'b0;
                TFEmpInt        <=      1'b0;
                RFFullInt       <=      1'b0;
                RFHalfInt       <=      1'b0;
        end
	else if (SDIIntMsk_w)
	begin
		AutoCMDCompleteInt <= PWDATA[18];
		R12ErrorInt	<=	PWDATA[17];
		R18ErrorInt	<=	PWDATA[16];
		NoBusyInt	<=	PWDATA[15];
		RspCrcInt	<=	PWDATA[14];
		CmdSentInt	<=	PWDATA[13];
		CmdToutInt	<= 	PWDATA[12];
		RspFinInt	<=	PWDATA[11];
		FFfailInt	<=	PWDATA[10];
		CrcStaInt	<=	PWDATA[9];
		DatCrcInt	<=	PWDATA[8];
		DatToutInt	<=	PWDATA[7];
		DatFinInt	<=	PWDATA[6];
		BusyFinInt	<=	PWDATA[5];
		TFHalfInt	<= 	PWDATA[3];
		TFEmpInt	<=	PWDATA[2];
		RFFullInt	<=	PWDATA[1];
		RFHalfInt	<=	PWDATA[0];
	end
end


wire	[1:0]	NextSDIAutoReadCon;
reg	[1:0]	iAutoReadCon;

assign NextSDIAutoReadCon = (NextSDIAutoReadCon_w)?	{PWDATA[2],PWDATA[0]}: iAutoReadCon;

reg	R12Error;
reg	R18Error;
reg	AutoCMDComplete;
reg	NextR18Error;

wire	ErrState0;
wire	ErrState1;
assign ErrState0	= ErrorState[0];
assign ErrState1 	= ErrorState[1];

always @(R18ErrorClr or ErrState0 or R18Error)
begin
	if (R18ErrorClr)
	NextR18Error <= 1'b0;
	else if (ErrState0)
	NextR18Error <= 1'b1;
	else
	NextR18Error <= R18Error;
end	

reg	NextR12Error;
always @(R12ErrorClr or ErrState1 or R12Error)
begin
	if (R12ErrorClr)
	NextR12Error <= 1'b0;
	else if (ErrState1)
	NextR12Error <= 1'b1;
	else
	NextR12Error <= R12Error;
end	

reg	NextAutoCMDComplete;
always @(AutoCMDCompleteClr or AutoReadComplete or AutoCMDComplete)
begin
	if (AutoCMDCompleteClr)
	NextAutoCMDComplete <= 1'b0;
	else if (AutoReadComplete)
	NextAutoCMDComplete <= 1'b1;
	else
	NextAutoCMDComplete <= AutoCMDComplete;
end	

always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn==1'b0)
	begin
	R12Error <= 1'b0;
	R18Error <= 1'b0;
	AutoCMDComplete <= 1'b0;
	end
	else
	begin
	R12Error <= NextR12Error;
	R18Error <= NextR18Error;
	AutoCMDComplete <= NextAutoCMDComplete;

	end
end

always @(posedge PCLK or negedge PRESETn)
begin
	if(PRESETn==1'b0)
	iAutoReadCon <= 0;
	else if (SDreset)
	iAutoReadCon <= 0;
	else
	iAutoReadCon 		<= NextSDIAutoReadCon;
end

reg	RCmdStartSet;
always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
	RCmdStartSet <= 1'b0;	
	else if (SDIAutoReadCon_w)
	RCmdStartSet <=  1'b1;
	else
	RCmdStartSet <= 1'b0;
end

reg	NextRCmdStart;
always @(RCmdStartSet or RCmdStartClr or RCmdStart)
begin
	if (RCmdStartSet)
	NextRCmdStart = 1'b1;
	else if (RCmdStartClr)
	NextRCmdStart = 1'b0;
	else
	NextRCmdStart = RCmdStart;
end

reg	RCmdStart;
always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
	RCmdStart <= 1'b0;
	else 
		if (SDreset)
		RCmdStart <= 1'b0;
		else
		RCmdStart <= NextRCmdStart;
end

always @(NextSDICON_r or NextiSDIPRE_r or NextSDICmdArg_r or NextSDICmdCon_r or NextSDICmdSta_r or 
	NextSDIRSP0_r or NextSDIRSP1_r or NextSDIRSP2_r or NextSDIRSP3_r or NextSDIDTimer_r or NextSDIBSize_r or
	NextSDIDatCon_r or NextSDIDatCnt_r or NextSDIDatSta_r or NextSDIFSTA_r or NextSDIIntMsk_r or NextSDIDAT_r or
	NextSDIIntSta_r or SDreset or PSAVEON or ENCLK or iSDIPRE or CmdArg or iSDICmdCon or CMST or RspCrc or CmdSent or
	CmdTout or RspFin or CmdOn or RspIndex or Response0 or Response1 or Response2 or Response3 or
	iDataTimer or iBlkSize or iSDIDatCon or DTST or BlkNumCnt or BlkCnt or NoBusy or
	CrcSta or DatCrc or DatTout or DatFin or BusyFin or TxDatOn or RxDatOn or
	FFfail or TFDET or RFDET or TFHalf or TFEmpty or RFFull or RFHalf or FFCNT or 
	NoBusyInt or RspCrcInt or CmdSentInt or CmdToutInt or RspFinInt or 
	FFfailInt or CrcStaInt or DatCrcInt or DatToutInt or DatFinInt or BusyFinInt or TFHalfInt or
	TFEmpInt or RFFullInt or RFHalfInt  or PRDATA or FIFOdata or
	NextSDIAutoReadCon_r or NextSDIAutoReadSta_r or NextSDIAutoReadRsp_r or iAutoReadCon  or RCmdStart or
	AutoCMDCompleteInt or R12ErrorInt or R18ErrorInt or  AutoCMDComplete or R12Error or R18Error or ResponseCMD18 or 
	NextSDFBCLKCON_r or InvSel or DelaySel
	)
begin
	NextPRDATA = PRDATA;
	case(1'b1) // synopsys parallel_case full_case
	NextSDICON_r 	: NextPRDATA = {23'd0, SDreset, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, PSAVEON, ENCLK};
 	NextiSDIPRE_r 	: NextPRDATA = {16'h0000,iSDIPRE};
 	NextSDICmdArg_r : NextPRDATA = {CmdArg};
 	NextSDICmdCon_r : NextPRDATA = {17'd0,iSDICmdCon[12:7],CMST,1'b0,iSDICmdCon[6:0]};
 	NextSDICmdSta_r : NextPRDATA = {19'd0, RspCrc, CmdSent, CmdTout, RspFin, CmdOn, RspIndex};
	NextSDIRSP0_r   : NextPRDATA = {Response0};
	NextSDIRSP1_r   : NextPRDATA = {Response1};
	NextSDIRSP2_r   : NextPRDATA = {Response2};
	NextSDIRSP3_r   : NextPRDATA = {Response3};
	NextSDIDTimer_r : NextPRDATA = iDataTimer;
	NextSDIBSize_r  : NextPRDATA = {16'd0, iBlkSize};
 	NextSDIDatCon_r : NextPRDATA = {iSDIDatCon[30:18],DTST,iSDIDatCon[17:0]};
 	NextSDIDatCnt_r : NextPRDATA = {BlkNumCnt, BlkCnt};
	NextSDIDatSta_r : NextPRDATA = {20'd0, NoBusy, 1'b0, 1'b0, 1'b0, CrcSta,
									DatCrc, DatTout, DatFin, BusyFin, 1'b0, TxDatOn, RxDatOn};
 	NextSDIFSTA_r   : NextPRDATA = {16'd0, 1'b0, FFfail, TFDET, RFDET, TFHalf, 
									TFEmpty, 1'b0, RFFull, RFHalf,2'b00, FFCNT}; // FIFO Sizeº¯°æ
	NextSDIIntMsk_r : NextPRDATA = {13'd0, AutoCMDCompleteInt, R12ErrorInt, R18ErrorInt, NoBusyInt, RspCrcInt,
									CmdSentInt, CmdToutInt, RspFinInt, FFfailInt, CrcStaInt, DatCrcInt, DatToutInt, 
									DatFinInt, BusyFinInt, 1'b0, TFHalfInt, TFEmpInt, RFFullInt, RFHalfInt};

	NextSDIIntSta_r	: NextPRDATA = {13'd0,
   							(AutoCMDCompleteInt & AutoCMDComplete),
                        				(R12ErrorInt & R12Error),
				                        (R18ErrorInt & R18Error),
                				        (NoBusyInt & NoBusy),
				                        (RspCrcInt & RspCrc),
                				        (CmdSentInt & CmdSent),
				                        (CmdToutInt & CmdTout),
                				        (RspFinInt & RspFin),
				                        (FFfailInt & FFfail),
                				        (CrcStaInt & CrcSta),
				                        (DatCrcInt & DatCrc),
                				        (DatToutInt & DatTout),
				                        (DatFinInt & DatFin),
                				        (BusyFinInt & BusyFin),
				                        1'b0,
    									(TFHalfInt  & TFHalf),
				                        (TFEmpInt & TFEmpty),
                				        (RFFullInt & RFFull),
				                        (RFHalfInt & RFHalf)};

	NextSDIDAT_r    		: NextPRDATA = FIFOdata;
	NextSDIAutoReadCon_r    : NextPRDATA = {iAutoReadCon[1],RCmdStart,iAutoReadCon[0]};
	NextSDIAutoReadSta_r    : NextPRDATA = {AutoCMDComplete, R12Error, R18Error};
	NextSDIAutoReadRsp_r    : NextPRDATA = ResponseCMD18;
	
	NextSDFBCLKCON_r		: NextPRDATA = {28'd0,InvSel,DelaySel};

	default : NextPRDATA = PRDATA; // AXI Bus Implementation 2007 5.3
	endcase
end



always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
	PRDATA <= 32'd0;
	else
	PRDATA <= NextPRDATA;
end

//////--------------------------------------------------------
wire	MMC_INT;
assign MMC_INT =        ((AutoCMDCompleteInt & AutoCMDComplete)|
                        (R12ErrorInt & R12Error)|
                        (R18ErrorInt & R18Error)|
                        (NoBusyInt & NoBusy)|
                        (RspCrcInt & RspCrc)|
                        (CmdSentInt & CmdSent)|
                        (CmdToutInt & CmdTout)|
                        (RspFinInt & RspFin)|
                        (FFfailInt & FFfail)|
                        (CrcStaInt & CrcSta)|
                        (DatCrcInt & DatCrc)|
                        (DatToutInt & DatTout)|
                        (DatFinInt & DatFin)|
                        (BusyFinInt & BusyFin)|
                        (TFHalfInt  & TFHalf)|
                        (TFEmpInt & TFEmpty)|
                        (RFFullInt & RFFull)|
                        (RFHalfInt & RFHalf));

// synopsys translate_off

reg	[8*10:0] MMCRegister;

wire		SDICON;
wire 		SDIPRE;
wire		SDICmdArg;
wire		SDICmdCon;
wire		SDICmdSta;
wire		SDIRSP0;
wire		SDIRSP1;
wire		SDIRSP2;
wire		SDIRSP3;
wire		SDIDTimer;
wire		SDIBSize;
wire		SDIDatCon;
wire		SDIDatCnt;
wire		SDIDatSta;
wire		SDIFSTA;
wire		SDIIntMsk;
wire		SDIDAT;

assign SDICON = ((PADDR == `SDICONAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIPRE = ((PADDR == `SDIPREAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDICmdArg = ((PADDR == `SDICmdArgAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDICmdCon = ((PADDR == `SDICmdConAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDICmdSta = ((PADDR == `SDICmdStaAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIRSP0 = ((PADDR == `SDIRSP0Addr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIRSP1 = ((PADDR == `SDIRSP1Addr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIRSP2 = ((PADDR == `SDIRSP2Addr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIRSP3 = ((PADDR == `SDIRSP3Addr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIDTimer = ((PADDR == `SDIDTimerAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIBSize = ((PADDR == `SDIBSizeAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIDatCon = ((PADDR == `SDIDatConAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIDatCnt = ((PADDR == `SDIDatCntAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIDatSta = ((PADDR == `SDIDatStaAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIFSTA = ((PADDR == `SDIFSTAAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIIntMsk = ((PADDR == `SDIIntMskAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;
assign SDIDAT = ((PADDR == `SDIDATAddr) && (PSEL == 1'b1) && (PENABLE == 1'b1))? 1'b1 : 1'b0;


always @(SDICON or SDIPRE or SDICmdArg or SDICmdCon or SDICmdSta or
	SDIRSP0 or SDIRSP1 or SDIRSP2 or SDIRSP3 or SDIDTimer or SDIBSize or
	SDIDatCon or SDIDatCnt or SDIDatSta or SDIFSTA or SDIIntMsk or SDIDAT)
begin
case(1'b1)
SDICON :
	MMCRegister = "SDICON";
SDIPRE :
	MMCRegister = "SDIPRE";
SDICmdArg:
	MMCRegister = "SDICmdArg";
SDICmdCon:
	MMCRegister = "SDICmdCon";
SDICmdSta:
	MMCRegister = "SDICmdSta";
SDIRSP0:
	MMCRegister = "SDIRSP0";
SDIRSP1:
	MMCRegister = "SDIRSP1";
SDIRSP2:
	MMCRegister = "SDIRSP2";
SDIRSP3:
	MMCRegister = "SDIRSP3";
SDIDTimer:
	MMCRegister = "SDIDTimer";
SDIBSize:
	MMCRegister = "SDIBSize";
SDIDatCon:
	MMCRegister = "SDIDatCon";
SDIDatCnt:
	MMCRegister = "SDIDatCnt";
SDIDatSta:
	MMCRegister = "SDIDatSta";
SDIFSTA:
	MMCRegister = "SDIFSTA";
SDIIntMsk:
	MMCRegister = "SDIIntMsk";
SDIDAT:
	MMCRegister = "SDIDAT";
default : 
	MMCRegister = "NO_MMC_REG";
endcase	
end
// synopsys translate_on







endmodule
