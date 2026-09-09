`timescale 1ns/1ps

`define SDICONAddr              6'b000000
`define SDIPREAddr              6'b000001
`define SDICmdArgAddr           6'b000010
`define SDICmdConAddr           6'b000011
`define SDICmdStaAddr           6'b000100
`define SDIRSP0Addr             6'b000101
`define SDIRSP1Addr             6'b000110
`define SDIRSP2Addr             6'b000111
`define SDIRSP3Addr             6'b001000
`define SDIDTimerAddr           6'b001001
`define SDIBSizeAddr            6'b001010
`define SDIDatConAddr           6'b001011
`define SDIDatCntAddr           6'b001100
`define SDIDatStaAddr           6'b001101
`define SDIFSTAAddr             6'b001110
`define SDIIntMskAddr           6'b001111
`define SDIIntStaAddr           6'b010000
`define SDIDATAddr              6'b010001

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
	
		iSDIPRE,

		CmdArg,

		iSDICmdCon,
		CMST,
		CMSTClr,

		RspCrc,
		RspCrcSetSync,
		CmdSent,
		CmdSentSetSync,
		CmdTout,
		CmdToutSetSync,
		RspFin,
		RspFinSetSync,

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

		NoBusy,
		NoBusySetSync,
		CrcSta,
		CrcStaSetSync,
		DatCrc,
		DatCrcSetSync,
		DatTout,
		DatToutSetSync,
		DatFin,
		DatFinSetSync,
		BusyFin,
		BusyFin2,
		BusyFinSetSync,
		BusyFinSet2Sync,
		TxDatOn,
		RxDatOn,

		FRST,
		FFfailSet,
		FFfail,

		TFDET,
		RFDET,
		TFHalf,
		TFEmpty,

		RFFull,
		RFHalf,
		FFCNT,
		
		TxWriteEn,
		RxRdPtrInc,

		NoBusyInt,
		RspCrcInt,
		CmdSentInt,
		CmdToutInt,
		RspEndInt,
		FFfailInt,
		CrcStaInt,
		DatCrcInt,
		DatToutInt,
		DatFinInt,
		BusyFinInt,
		BusyFin2Int,
		TFHalfInt,
		TFEmpInt,
		RFFullInt,
		RFHalfInt,
		
		SDIPREUpd,
		SDICmdArgUpd,
		SDICmdConUpd,
		SDIDatConUpd,
		SDIDTimerUpd,
		SDIBSizeUpd,

		SDIPREUpdDoneSync,
		SDICmdArgUpdDoneSync,
		SDICmdConUpdDoneSync,
		SDIDatConUpdDoneSync,
		SDIDTimerUpdDoneSync,
		SDIBSizeUpdDoneSync,
		FIFOdata

		
	);

input       	PCLK;             // APB Bus Clock
input         	PRESETn;          // APB Bus Reset
input         	PSEL;             // APB Peripheral select
input         	PWRITE;           // APB Peripheral Write
input         	PENABLE;          // APB Peripheral enable
input  	[31:0] 	PWDATA;           // Write databus
input	[7:2] 	PADDR;            // APB Address

output	[31:0]	PRDATA;
output			SDreset;
output			ENCLK;
	
output	[7:0]	iSDIPRE;

output	[31:0]	CmdArg;
	
output	[12:0]	iSDICmdCon;
output			CMST;
input			CMSTClr;


output		RspCrc;
input		RspCrcSetSync;
output		CmdSent;
input		CmdSentSetSync;
output		CmdTout;
input		CmdToutSetSync;
output		RspFin;
input		RspFinSetSync;
input		CmdOn;
input	[7:0]	RspIndex;

input	[31:0]	Response0;
input	[31:0]	Response1;
input	[31:0]	Response2;
input	[31:0]	Response3;
			
output [22:0]	iDataTimer;
output [11:0]	iBlkSize;			
	
output	[29:0]	iSDIDatCon;
output		DTST;
input		DTSTClr;

input	[11:0]	BlkNumCnt;
input	[11:0]	BlkCnt;

output		NoBusy;
input		NoBusySetSync;

output		CrcSta;
input		CrcStaSetSync;
output		DatCrc;
input		DatCrcSetSync;
output		DatTout;
input		DatToutSetSync;
output		DatFin;
input		DatFinSetSync;
output		BusyFin;
output		BusyFin2;
input		BusyFinSetSync;
input		BusyFinSet2Sync;
input		TxDatOn;
input		RxDatOn;

output		FRST;
input		FFfailSet;
output		FFfail;

input		TFDET;
input		RFDET;
input		TFHalf;
input		TFEmpty;

input		RFFull;
input		RFHalf;
input	[6:0]	FFCNT;
output		TxWriteEn;
output		RxRdPtrInc;

output		NoBusyInt;
output		RspCrcInt;
output		CmdSentInt;
output		CmdToutInt;
output		RspEndInt;
output		FFfailInt;
output		CrcStaInt;
output		DatCrcInt;
output		DatToutInt;
output		DatFinInt;
output		BusyFinInt;
output		BusyFin2Int;
output		TFHalfInt;
output		TFEmpInt;
output		RFFullInt;
output		RFHalfInt;

output		SDIPREUpd;
output          SDICmdArgUpd;
output		SDICmdConUpd;
output		SDIDatConUpd;
output          SDIDTimerUpd;
output          SDIBSizeUpd;

input		SDIPREUpdDoneSync;
input		SDICmdArgUpdDoneSync;
input		SDICmdConUpdDoneSync;
input		SDIDatConUpdDoneSync;
input		SDIDTimerUpdDoneSync;
input		SDIBSizeUpdDoneSync;

input	[31:0]	FIFOdata;


//--------------------------------
reg		SDreset;
reg		ENCLK;

//--------------------------------
reg	[7:0]	iSDIPRE;
wire	[7:0]	NextSDIPRE;
//--------------------------------
reg	[31:0]	CmdArg;
wire	[31:0]	NextSDICmdArg;
//--------------------------------
reg		NextCMST;
reg		CMSTSet;
reg		CMST;

//--------------------------------
reg		NextRspCrc;
reg		RspCrc;

reg		NextCmdSent;
reg		CmdSent; 

reg		NextCmdTout;
reg		CmdTout;

reg		NextRspFin;
reg		RspFin;

//--------------------------------
reg	[22:0]	iDataTimer;
reg	[11:0]	iBlkSize;

//--------------------------------
reg		NextNoBusy;
reg		NoBusy;



reg		NextCrcSta;
reg		CrcSta;

reg		NextDatCrc;
reg		DatCrc;

reg		NextDatTout;
reg		DatTout;

reg		NextDatFin;
reg		DatFin;

reg		NextBusyFin;
reg		BusyFin;

reg		NextBusyFin2;
reg		BusyFin2;
reg		FRST;
reg		NextFFfail;
reg		FFfail;

reg		NoBusyInt;
reg		RspCrcInt;
reg		CmdSentInt;
reg		CmdToutInt;
reg		RspEndInt;
reg		FFfailInt;
reg		CrcStaInt;
reg		DatCrcInt;
reg		DatToutInt;
reg		DatFinInt;
reg		BusyFinInt;
reg		BusyFin2Int;
reg		TFHalfInt;
reg		TFEmpInt;
reg		RFFullInt;
reg		RFHalfInt;

reg	[31:0]	PRDATA;
reg	[31:0]	NextPRDATA;


reg		SDIPREUpd;
reg		SDICmdArgUpd;
reg		SDICmdConUpd;
reg		SDIDatConUpd;
reg		SDIDTimerUpd;
reg		SDIBSizeUpd;


wire	SDICON_w;
wire	NextiSDIPRE_w;
wire	NextSDICmdArg_w;
wire	NextSDICmdCon_w;
wire    SDICmdCon_w;
wire    SDICmdSta_w;
wire    NextSDIDTimer_w;
wire    NextSDIBSize_w;
wire    NextSDIDatCon_w;
wire    SDIDatCon_w;
wire    SDIDatCnt_w;
wire    SDIDatSta_w;
wire    SDIFSTA_w;
wire    SDIIntMsk_w;
wire    SDIDAT_w;
wire    NextSDIDAT_w;
wire    SDIIntSta_w;
wire    NextSDICON_r;
wire    NextiSDIPRE_r;
wire    NextSDICmdArg_r;
wire    NextSDICmdCon_r;
wire    NextSDICmdSta_r;
wire    NextSDIRSP0_r;
wire    NextSDIRSP1_r;
wire    NextSDIRSP2_r;
wire    NextSDIRSP3_r;
wire    NextSDIDTimer_r;
wire    NextSDIBSize_r;
wire    NextSDIDatCon_r;
wire    NextSDIDatCnt_r;
wire    NextSDIDatSta_r;
wire    NextSDIFSTA_r;
wire    NextSDIIntMsk_r;
wire    NextSDIDAT_r;
wire    NextSDIIntSta_r;





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
wire	BusyFin2Clr;
wire	FFfailClr;
wire	DTSTSet;


assign 	RspCrcClr	= ( ((SDICmdSta_w) && (PWDATA[12] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[17]==1'b1)) ) ? 1'b1:1'b0;
assign 	CmdSentClr	= ( ((SDICmdSta_w) && (PWDATA[11] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[16]==1'b1)) )? 1'b1:1'b0;
assign 	CmdToutClr	= ( ((SDICmdSta_w) && (PWDATA[10] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[15]==1'b1)) )? 1'b1:1'b0;
assign	RspFinClr	= ( ((SDICmdSta_w) && (PWDATA[9] == 1'b1))  | ((SDIIntSta_w) && (PWDATA[14]==1'b1)) )? 1'b1:1'b0;
assign	NoBusyClr	= ( ((SDIDatSta_w) && (PWDATA[11] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[18]==1'b1)) )? 1'b1:1'b0;
assign	CrcStaClr	= ( ((SDIDatSta_w) && (PWDATA[7] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[10]==1'b1)) )? 1'b1:1'b0;
assign	DatCrcClr	= ( ((SDIDatSta_w) && (PWDATA[6] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[9]==1'b1)) )? 1'b1:1'b0;
assign	DatToutClr	= ( ((SDIDatSta_w) && (PWDATA[5] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[8]==1'b1)) )? 1'b1:1'b0;
assign	DatFinClr	= ( ((SDIDatSta_w) && (PWDATA[4] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[7]==1'b1)) )? 1'b1:1'b0;
assign	BusyFinClr	= ( ((SDIDatSta_w) && (PWDATA[3] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[6]==1'b1)) )? 1'b1:1'b0;
assign	BusyFin2Clr	= ( ((SDIDatSta_w) && (PWDATA[2] == 1'b1)) | ((SDIIntSta_w) && (PWDATA[5]==1'b1)) )? 1'b1:1'b0;

assign	FFfailClr	= ( ((SDIFSTA_w) && (PWDATA[14] == 2'b11)) | ((SDIIntSta_w)&&(PWDATA[11]==1'b1)) )? 1'b1:1'b0;
assign	DTSTSet		= ((SDIDatCon_w) && (PWDATA[14]))? 1'b1 : 1'b0;
		
// SDICON register
always @(posedge PCLK or negedge PRESETn)
begin
	if (!PRESETn)
	begin
		ENCLK <= 1'b0;
	end
	else if (SDICON_w)
	begin
		ENCLK <= PWDATA[0];
	end	
end
// SDICON register
always @(posedge PCLK or negedge PRESETn)
begin
        if (!PRESETn)
        begin
                SDreset <= 1'b0;
        end
        else 
	begin
		if (SDICON_w)
                SDreset <=PWDATA[8];
		else
		SDreset <= 1'b0;
	end
end


//-----------------------------------------------------------------------------------------------
wire	NextSDIPREUpd;
assign NextSDIPRE = ((NextiSDIPRE_w)&&((SDIPREUpd ^ SDIPREUpdDoneSync)==1'b0))? PWDATA[7:0]:iSDIPRE;
assign NextSDIPREUpd =(NextiSDIPRE_w)?~(SDIPREUpdDoneSync) : SDIPREUpd;
// iSDIPRE register
always @(posedge PCLK or negedge PRESETn)
begin 
  if (PRESETn == 1'b0)
	begin
	iSDIPRE <= (8'b00000001);
	SDIPREUpd <= 1'b0;
	end
  else
	begin
	iSDIPRE <= NextSDIPRE;
	SDIPREUpd <= NextSDIPREUpd;
	end
end 

//-----------------------------------------------------------------------------------------------
wire	NextSDICmdArgUpd;

assign NextSDICmdArg = ((NextSDICmdArg_w)&&((SDICmdArgUpd ^ SDICmdArgUpdDoneSync)==1'b0))? PWDATA[31:0]:CmdArg[31:0];
assign NextSDICmdArgUpd = (NextSDICmdArg_w)? ~(SDICmdArgUpdDoneSync): SDICmdArgUpd ;
always @(posedge PCLK or negedge PRESETn)
begin 
  if (PRESETn == 1'b0)
	begin
	CmdArg <= (32'h00000000);
	SDICmdArgUpd <=1'b0 ;
	end
  else 
	begin
	CmdArg <= NextSDICmdArg;
	SDICmdArgUpd <= NextSDICmdArgUpd;
	end
end 

//-----------------------------------------------------------------------------------------------
reg [12:0]	iSDICmdCon ;
wire	[12:0]	NextSDICmdCon;
wire	NextSDICmdConUpd;
assign NextSDICmdCon = ((NextSDICmdCon_w)&&((SDICmdConUpd ^ SDICmdConUpdDoneSync)==1'b0))?{PWDATA[14:9],PWDATA[6:0]}:iSDICmdCon;
assign NextSDICmdConUpd = (NextSDICmdCon_w)? ~(SDICmdConUpdDoneSync) :SDICmdConUpd;

// SDICmdCon register
always @(posedge PCLK or negedge PRESETn)
begin
  if (PRESETn == 1'b0)
        begin
        iSDICmdCon <= (13'd0);
        SDICmdConUpd <=1'b0 ;
        end
  else
        begin
        iSDICmdCon <= NextSDICmdCon;
        SDICmdConUpd <= NextSDICmdConUpd;
        end
end

//************************************************************************************************

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
		CMST <= NextCMST;
end

// SDICmdSta register

always @(RspCrcSetSync or RspCrcClr or RspCrc)
begin
	if (RspCrcSetSync)
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
  else 
	RspCrc <= NextRspCrc;
end

// Command Sent
always @(CmdSentSetSync or CmdSentClr or CmdSent)
begin
	if (CmdSentSetSync)
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
  else 
	CmdSent <= NextCmdSent;
end

// Command Time out
always @(CmdToutClr or CmdToutSetSync or CmdTout)
begin
  if (CmdToutSetSync == 1'b1)
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
	CmdTout <= NextCmdTout;
end

// Response Receive End
always @(RspFinSetSync or RspFinClr or RspFin)
begin
	if (RspFinSetSync)
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
  else 
	RspFin <= NextRspFin;
end

// read only register
// SDIRSP0 register
// SDIRSP1 register 
// SDIRSP2 register 
// SDIRSP3 register

wire	[22:0] NextDataTimer;
wire	NextSDIDTimerUpd;
assign NextDataTimer = ((NextSDIDTimer_w)&&((SDIDTimerUpd ^ SDIDTimerUpdDoneSync)==1'b0))? PWDATA[22:0]:iDataTimer;
assign NextSDIDTimerUpd = (NextSDIDTimer_w)?~(SDIDTimerUpdDoneSync) :SDIDTimerUpd;
// SDIDTimer register
always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	begin
	iDataTimer <=23'h10000;
	SDIDTimerUpd <=1'b0;
	end
	else
	begin
	iDataTimer <= NextDataTimer;
	SDIDTimerUpd<= NextSDIDTimerUpd;
	end
end

wire	[11:0]	NextSDIBSize;
wire	NextSDIBSizeUpd;
assign NextSDIBSize = ((NextSDIBSize_w)&&((SDIBSizeUpd ^ SDIBSizeUpdDoneSync)==1'b0))? PWDATA[11:0]:iBlkSize;
assign NextSDIBSizeUpd = (NextSDIBSize_w)?~(SDIBSizeUpdDoneSync) :SDIBSizeUpd;
// SDIBSize register
always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	begin
	iBlkSize <= 12'h000;
	SDIBSizeUpd <= 1'b0;
	end
	else
	begin
	iBlkSize <= NextSDIBSize;
	SDIBSizeUpd <= NextSDIBSizeUpd;
	end
end

reg	[29:0]	iSDIDatCon;
wire	[29:0]	NextSDIDatCon;
wire	NextSDIDatConUpd;
assign NextSDIDatCon = ((NextSDIDatCon_w)&&((SDIDatConUpd ^ SDIDatConUpdDoneSync)==1'b0))? {PWDATA[31:19], PWDATA[17:15], PWDATA[13:0]}:iSDIDatCon;
assign NextSDIDatConUpd = (NextSDIDatCon_w)?~(SDIDatConUpdDoneSync) :SDIDatConUpd;
// SDIDatCon register

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	begin
	iSDIDatCon <=  {7'b0001000, 23'd0};
	SDIDatConUpd <= 1'b0;
	end
	else 
	begin
	iSDIDatCon <=NextSDIDatCon;
	SDIDatConUpd<= NextSDIDatConUpd;
	end
end
reg	NextDTST;
always @(DTSTClr or DTSTSet or DTST)
if (DTSTSet)
	NextDTST = 1'b1;
else if (DTSTClr)
	NextDTST = 1'b0;
else
	NextDTST = DTST;
reg	DTST;
always @(posedge PCLK or negedge PRESETn)
begin
if (!PRESETn)
	DTST <= 1'b0;
else
	DTST <= NextDTST;
end
// read only register
// SDIDatCnt register

// SDIDatSta;
//
always @(NoBusyClr or NoBusySetSync or NoBusy)
begin
	if (NoBusyClr)
	NextNoBusy = 1'b0;
	else if (NoBusySetSync)
	NextNoBusy = 1'b1;
	else
	NextNoBusy = NoBusy;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	NoBusy <= 1'b0;
	else 
	NoBusy <= NextNoBusy;
end


always @(CrcStaClr or CrcStaSetSync or CrcSta)
begin
	if (CrcStaClr)
	NextCrcSta = 1'b0;
	else if (CrcStaSetSync)
	NextCrcSta = 1'b1;
	else
	NextCrcSta = CrcSta;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	CrcSta <= 1'b0;
	else
	CrcSta <= NextCrcSta;
end

always @(DatCrcClr or DatCrcSetSync or DatCrc)
begin
	if (DatCrcClr)
	NextDatCrc = 1'b0;
	else if (DatCrcSetSync)
	NextDatCrc = 1'b1;
	else
	NextDatCrc = DatCrc;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	DatCrc <= 1'b0;
	else
	DatCrc <= NextDatCrc;
end

always @(DatToutClr or DatToutSetSync or DatTout)
begin
	if (DatToutClr)
	NextDatTout = 1'b0;
	else if (DatToutSetSync)
	NextDatTout = 1'b1;
	else
	NextDatTout = DatTout;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	DatTout <= 1'b0;
	else
	DatTout <= NextDatTout;
end

always @(DatFinClr or DatFinSetSync or DatFin)
begin
	if (DatFinClr)
	NextDatFin = 1'b0;
	else if (DatFinSetSync)
	NextDatFin = 1'b1;
	else
	NextDatFin = DatFin;
end

always @(posedge PCLK or negedge PRESETn)
begin 
	if (PRESETn == 1'b0)
	DatFin <= 1'b0;
	else 
	DatFin <= NextDatFin;
end

always @(BusyFinClr or BusyFinSetSync or BusyFin)
begin
	if (BusyFinClr)
	NextBusyFin = 1'b0;
	else if (BusyFinSetSync)
	NextBusyFin = 1'b1;
	else
	NextBusyFin = BusyFin;
end
always @(BusyFin2Clr or BusyFinSet2Sync or BusyFin2)
begin
        if (BusyFin2Clr)
        NextBusyFin2 = 1'b0;
        else if (BusyFinSet2Sync)
        NextBusyFin2 = 1'b1;
        else
        NextBusyFin2 = BusyFin2;
end


always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
	BusyFin <= 1'b0;
	else
	BusyFin <= NextBusyFin;
end
always @(posedge PCLK or negedge PRESETn)
begin
        if (PRESETn == 1'b0)
        BusyFin2 <= 1'b0;
        else
        BusyFin2 <= NextBusyFin2;
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
		NoBusyInt	<=	1'b0;
		RspCrcInt	<=	1'b0;
		CmdSentInt	<=	1'b0;
		CmdToutInt	<= 	1'b0;
		RspEndInt	<=	1'b0;
		FFfailInt	<=	1'b0;
		CrcStaInt	<=	1'b0;
		DatCrcInt	<=	1'b0;
		DatToutInt	<=	1'b0;
		DatFinInt	<=	1'b0;
		BusyFinInt	<=	1'b0;
		BusyFin2Int	<=	1'b0;
		TFHalfInt	<= 	1'b0;
		TFEmpInt	<=	1'b0;
		RFFullInt	<=	1'b0;
		RFHalfInt	<=	1'b0;
	end
	else if (SDIIntMsk_w)
	begin
		NoBusyInt	<=	PWDATA[18];
		RspCrcInt	<=	PWDATA[17];
		CmdSentInt	<=	PWDATA[16];
		CmdToutInt	<= 	PWDATA[15];
		RspEndInt	<=	PWDATA[14];
		FFfailInt	<=	PWDATA[11];
		CrcStaInt	<=	PWDATA[10];
		DatCrcInt	<=	PWDATA[9];
		DatToutInt	<=	PWDATA[8];
		DatFinInt	<=	PWDATA[7];
		BusyFinInt	<=	PWDATA[6];
		BusyFin2Int	<=	PWDATA[5];
		TFHalfInt	<= 	PWDATA[4];
		TFEmpInt	<=	PWDATA[3];
		RFFullInt	<=	PWDATA[1];
		RFHalfInt	<=	PWDATA[0];
	end
end


always @(NextSDICON_r or NextiSDIPRE_r or NextSDICmdArg_r or NextSDICmdCon_r or NextSDICmdSta_r or 
	NextSDIRSP0_r or NextSDIRSP1_r or NextSDIRSP2_r or NextSDIRSP3_r or NextSDIDTimer_r or NextSDIBSize_r or
	NextSDIDatCon_r or NextSDIDatCnt_r or NextSDIDatSta_r or NextSDIFSTA_r or NextSDIIntMsk_r or NextSDIDAT_r or
	NextSDIIntSta_r or SDreset or ENCLK or iSDIPRE or CmdArg or iSDICmdCon or CMST or RspCrc or CmdSent or
	CmdTout or RspFin or CmdOn or RspIndex or Response0 or Response1 or Response2 or Response3 or
	iDataTimer or iBlkSize or iSDIDatCon or DTST or BlkNumCnt or BlkCnt or NoBusy or
	CrcSta or DatCrc or DatTout or DatFin or BusyFin or BusyFin2 or TxDatOn or RxDatOn or
	FFfail or TFDET or RFDET or TFHalf or TFEmpty or RFFull or RFHalf or FFCNT or 
	NoBusyInt or RspCrcInt or CmdSentInt or CmdToutInt or RspEndInt or 
	FFfailInt or CrcStaInt or DatCrcInt or DatToutInt or DatFinInt or BusyFinInt or BusyFin2Int or TFHalfInt or
	TFEmpInt or RFFullInt or RFHalfInt  or PRDATA or FIFOdata)
begin
	NextPRDATA <= PRDATA;
	case(1'b1) // synopsys parallel_case full_case
	NextSDICON_r 	: NextPRDATA <= {23'd0, SDreset, 2'b00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ENCLK};
 	NextiSDIPRE_r 	: NextPRDATA <= {24'h000,iSDIPRE};
 	NextSDICmdArg_r : NextPRDATA <= {CmdArg};
 	NextSDICmdCon_r : NextPRDATA <= {17'd0,iSDICmdCon[12:7],CMST,1'b0,iSDICmdCon[6:0]};
 	NextSDICmdSta_r : NextPRDATA <= {19'd0, RspCrc, CmdSent, CmdTout, RspFin, CmdOn, RspIndex};
	NextSDIRSP0_r   : NextPRDATA <= {Response0};
	NextSDIRSP1_r   : NextPRDATA <= {Response1};
	NextSDIRSP2_r   : NextPRDATA <= {Response2};
	NextSDIRSP3_r   : NextPRDATA <= {Response3};
	NextSDIDTimer_r : NextPRDATA <= {9'd0, iDataTimer};
	NextSDIBSize_r  : NextPRDATA <= {20'd0, iBlkSize};
 	NextSDIDatCon_r : NextPRDATA <= {iSDIDatCon[29:17], 1'b0, iSDIDatCon[16:14], DTST, iSDIDatCon[13:0]};
 	NextSDIDatCnt_r : NextPRDATA <= {8'd0, BlkNumCnt, BlkCnt};
	NextSDIDatSta_r : NextPRDATA <= {20'd0, NoBusy, 1'b0, 1'b0, 1'b0, CrcSta,
					DatCrc, DatTout, DatFin, BusyFin, BusyFin2, TxDatOn, RxDatOn};
 	NextSDIFSTA_r   : NextPRDATA <= {16'd0, 1'b0, FFfail, TFDET, RFDET, TFHalf, 
					TFEmpty, 1'b0, RFFull, RFHalf, FFCNT};
	NextSDIIntMsk_r : NextPRDATA <= {13'd0, NoBusyInt, RspCrcInt, CmdSentInt, CmdToutInt,
					RspEndInt, 1'b0, 1'b0,	FFfailInt, CrcStaInt,
				   	DatCrcInt, DatToutInt, DatFinInt, BusyFinInt, BusyFin2Int, 
					TFHalfInt, TFEmpInt, 1'b0, RFFullInt, RFHalfInt};

	NextSDIIntSta_r : NextPRDATA <= {13'd0, NoBusy, RspCrc, CmdSent, CmdTout, RspFin, 1'b0, 
					1'b0, FFfail, CrcSta, DatCrc, DatTout, DatFin, 
					BusyFin, BusyFin2, TFHalf, TFEmpty, 1'b0, RFFull, RFHalf};

	NextSDIDAT_r    : NextPRDATA <= FIFOdata;

	default : NextPRDATA <= 32'd0;
	endcase
end



always @(posedge PCLK or negedge PRESETn)
begin
	if (PRESETn == 1'b0)
	PRDATA <= 32'd0;
	else
	PRDATA <= NextPRDATA;
end

// synopsys translate_off

reg	[8*10 ] MMCRegister;
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
