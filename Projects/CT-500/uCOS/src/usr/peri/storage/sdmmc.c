/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: sdmmc.c 
	Description	: SD/MMC test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include "sdmmc_pre_drv.h"
//#include "sdmmc_post_drv.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"

#include "sdmmc.h"
/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARE
///////////////////////////////////////////////////////// 
*/
extern void 		HexDump(smtUint32 buffer, smtUint32 size);
extern smtBoolean 	MakePattern(smtUint32 seed, smtUint32 buffer, smtUint32 size);
extern smtBoolean 	CheckPattern(smtUint32 seed, smtUint32 buffer, smtUint32 size);
extern void 		DCacheFlushing(void);

static void 		SDMMCDMAHandler(smtUint32 irq);
static void 		SDMMCIntHandler(smtUint32 irq);
static smtUint32 	SDMMCDPRINTF(smtInt8 *format, ...);
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Card type
-----------------------------------------------------------*/
#define	SDMMC_CARDTYPE_SD_1BIT		(0)
#define	SDMMC_CARDTYPE_SD_4BIT		(1)
#define	SDMMC_CARDTYPE_SDHS_1BIT	(2)
#define	SDMMC_CARDTYPE_SDHS_4BIT	(3)
#define	SDMMC_CARDTYPE_MMC			(4)
#define	SDMMC_CARDTYPE_MMCHS_1BIT	(5)
#define	SDMMC_CARDTYPE_MMCHS_4BIT	(6)
#define	SDMMC_CARDTYPE_MMCHS_8BIT	(7)
#define	SDMMC_CARDTYPE_DEFAULT		SDMMC_CARDTYPE_SD_4BIT
/*----------------------------------------------------------
	Command type
-----------------------------------------------------------*/
#define	SDMMC_CMDC_CT_RESERVE		(0)	// Not valid command
#define	SDMMC_CMDC_CT_NORMAL		(1)	// Normal command
#define	SDMMC_CMDC_CT_ABORT			(2)	// Abort command
/*----------------------------------------------------------
	Reponse type
-----------------------------------------------------------*/
#define	SDMMC_CMDC_RT_NONE			(0)	// No reponse
#define	SDMMC_CMDC_RT_R1			(1)	// Payload 32bit
#define	SDMMC_CMDC_RT_R1B			(2)	// Payload 32bit, has Busy signal
#define	SDMMC_CMDC_RT_R2			(3)	// Payload 127bit
#define	SDMMC_CMDC_RT_R3			(4)	// Payload 32bit, no CRC filed
#define	SDMMC_CMDC_RT_R6			(5)	// Payload 32bit
/*----------------------------------------------------------
	Transfer mode
-----------------------------------------------------------*/
#define	SDMMC_DATC_DD_TX			(0)	
#define	SDMMC_DATC_DD_RX			(1)	
/*----------------------------------------------------------
	Host clock
-----------------------------------------------------------*/
#define	SDMMC_SDCLK					(50000000)	// 50Mhz
#define	SDMMC_GET_CLK(d)			(SDMMC_SDCLK/(2*((d)+1)))
#define	SDMMC_GET_DIV(c)			((SDMMC_SDCLK/(c))/2-1)

/*----------------------------------------------------------
	SD normal command
-----------------------------------------------------------*/
#define	SDMMC_GO_IDLE_STATE			( 0)
#define	SDMMC_SEND_CID				( 2)
#define	SDMMC_SEND_RELATIVE_ADDR	( 3)
#define	SDMMC_SELECT				( 7)
#define	SDMMC_APP_CMD				(55)
#define	SDMMC_READ_MULTIPLE_BLOCK	(18)
#define	SDMMC_WRITE_MULTIPLE_BLOCK	(25)
#define	SDMMC_STOP_TRANSMISSION		(12)
/*----------------------------------------------------------
	SD application command
-----------------------------------------------------------*/
#define	SDMMC_SET_BUS_WIDTH			( 6)
#define	SDMMC_SD_SEND_OP_COND		(41)
#define	SDMMC_SET_CLR_CARD_DETECT	(42)
/*----------------------------------------------------------
	MMC  command
-----------------------------------------------------------*/
#define	MMC_SEND_OP_COND			( 1)
#define	MMC_ALL_SEND_CID			( 2)
#define	MMC_SET_RELATIVE_ADDR		( 3)
#define	MMC_SEL_TOGGLE_CARD			( 7)
/*----------------------------------------------------------
	SD/MMC wait type
-----------------------------------------------------------*/
#define	SDMMC_RSP_NONE				(0)
#define	SDMMC_RSP_R1				(1)
#define	SDMMC_RSP_R1B				(2)
#define	SDMMC_RSP_R2				(3)
#define	SDMMC_RSP_R3				(4)
#define	SDMMC_RSP_R6				(5)
/*----------------------------------------------------------
	Test definition etc
-----------------------------------------------------------*/
#define SDMMC_MAX_RETRY 			(100*3)
#define SDMMC_TM_DMA				(0)
#define SDMMC_TM_INT				(1)
#define SDMMC_TM_POL				(2)
#define SDMMC_DMA_CH				(0)
#define SDMMC_DMA_INT				(IRQ_DMA0)

/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Command infomration 
-----------------------------------------------------------*/
typedef struct 
{
	smtUint32	cmdIdx;
	smtBoolean	isAppCmd;
	smtUint32	cmdType;
	smtUint32	rspType;
	
} SDMMC_CmdInfo;

/*-----------------------------------------------------------------------*/

smtUint32 raw_csd[4];
smtUint32 raw_cid[4];


/*-----------------------------------------------------------------------*/

static const unsigned int tran_exp[] = { 
	10000, 100000, 1000000, 10000000, 0, 0, 0, 0 
};

static const unsigned char tran_mant[] = {
	0, 10, 12,	13,	15,	20,	25,	30,
    35,	40,	45,	50,	55,	60,	70,	80,
};
static const unsigned int tacc_exp[] = {
	1,	10,	100,	1000,	10000,	100000,	1000000, 10000000,
};

static const unsigned int tacc_mant[] = {
	0,	10,	12,	13,	15,	20,	25,	30,
	35,	40,	45,	50,	55,	60,	70,	80,
};


struct mmc_cid 
{
	unsigned int	manfid;
	char			prod_name[8];
	unsigned int	serial;
	unsigned short	oemid;
	unsigned short	year;
	unsigned char	hwrev;
	unsigned char	fwrev;
	unsigned char	month;
};

struct mmc_csd 
{
	unsigned char	mmca_vsn;
	unsigned short	cmdclass;
	unsigned short	tacc_clks;
	unsigned int	tacc_ns;
	unsigned int	r2w_factor;
	unsigned int	max_dtr;
	unsigned int	read_blkbits;
	unsigned int	write_blkbits;
	unsigned int	capacity;
	unsigned int	read_partial:1,
					read_misalign:1,
					write_partial:1,
					write_misalign:1;
};

struct sd_scr 
{
	unsigned char		sda_vsn;
	unsigned char		bus_widths;
#define SD_SCR_BUS_WIDTH_1	(1<<0)
#define SD_SCR_BUS_WIDTH_4	(1<<2)
};

struct mmc_card {
	smtUint32			raw_cid[4];	/* raw card CID */
	smtUint32			raw_csd[4];	/* raw card CSD */
	smtUint32			raw_scr[2];	/* raw card SCR */
	struct mmc_cid		cid;		/* card identification */
	struct mmc_csd		csd;		/* card specific */
	struct sd_scr		scr;		/* extra SD information */
};


struct mmc_card card_info;


/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static volatile smtBoolean	gDMAEnd 		= 0;
static volatile smtBoolean	gTXFIFOEmpty	= 0;
static volatile smtBoolean	gRXFIFOFull		= 0;
static volatile smtBoolean	gTXDataFin		= 0;
static volatile smtBoolean	gRXDataFin		= 0;

static smtUint32 sCardType 	= SDMMC_CARDTYPE_DEFAULT;
static smtUint32 sRCA		= 0x0;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Host local function
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: GetSDCmdInfo
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: Get SD command information 
						by SDMMC_CmdInfo structure
-----------------------------------------------------------*/
static void GetSDCmdInfo(smtUint32 cmdIdx, smtBoolean isAppCmd, 
	SDMMC_CmdInfo *pcmdInfo)
{
	
	pcmdInfo->cmdIdx 	= cmdIdx;
	pcmdInfo->isAppCmd = isAppCmd;
	
	//-------------------------------------------------------
	// For SD normal command
	//-------------------------------------------------------
	if(!isAppCmd) 
	{
		
		//---------------------------------------------------
		// Check command type
		//---------------------------------------------------
		if(cmdIdx == 12)
		{
			pcmdInfo->cmdType = SDMMC_CMDC_CT_NORMAL;
		}
		else  
		{
			pcmdInfo->cmdType = SDMMC_CMDC_CT_NORMAL;
		}
		
		//---------------------------------------------------
		// Check reponse type
		//---------------------------------------------------
		switch(cmdIdx)
		{
		/* No response */
		case  0:	// fall through
		case  4:	// fall through
		case 15:	// fall through
			pcmdInfo->rspType = SDMMC_CMDC_RT_NONE;
			break;
		
		/* R1 response */
		case  6:	// fall through
		case 13:	// fall through
		case 16:	// fall through
		case 17:	// fall through
		case 18:	// fall through
		case 24:	// fall through
		case 25:	// fall through
		case 27:	// fall through
		case 30:	// fall through
		case 32:	// fall through
		case 33:	// fall through
		case 42:	// fall through
		case 55:	// fall through
		case 56:	// fall through
			pcmdInfo->rspType = SDMMC_CMDC_RT_R1;
			break;
		
		/* R1b response */	
		case  7:	// fall through
		case 12:	// fall through
		case 28:	// fall through
		case 29:	// fall through
		case 38:	// fall through
			pcmdInfo->rspType = SDMMC_CMDC_RT_R1B;
			break;
			
		/* R2 response */	
		case  2:
		case  9:	// fall through
		case 10:	// fall through
			pcmdInfo->rspType = SDMMC_CMDC_RT_R2;
			break;
		
		
		/* R6 response */
		case  3:
			pcmdInfo->rspType = SDMMC_CMDC_RT_R6;
			break;
		
		default:
			break;
		}
		
	}
	//-------------------------------------------------------
	// For SD application command
	//-------------------------------------------------------
	else
	{
		switch(cmdIdx)
		{
		/* R1 response */
		case  6:	// fall through
		case 13:	// fall through
		case 22:	// fall through
		case 23:	// fall through
			pcmdInfo->rspType = SDMMC_CMDC_RT_R1;
			break;
		
			
		/* R3 response */
		case 41:	
			pcmdInfo->rspType = SDMMC_CMDC_RT_R3;
			break;
		
		default:
			break;
		}
	}

}
/*----------------------------------------------------------
	Function name	: GetMMCCmdInfo
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: Get MMC command information 
						by SDMMC_CmdInfo structure
-----------------------------------------------------------*/
static void GetMMCCmdInfo(smtUint32 cmdIdx,SDMMC_CmdInfo *pcmdInfo)
{
	
	pcmdInfo->cmdIdx 	= cmdIdx;
	
	//---------------------------------------------------
	// Check command type
	//---------------------------------------------------
	if(cmdIdx == 12)
	{
		pcmdInfo->cmdType = SDMMC_CMDC_CT_NORMAL;
	}
	else  
	{
		pcmdInfo->cmdType = SDMMC_CMDC_CT_NORMAL;
	}
	
	//---------------------------------------------------
	// Check reponse type
	//---------------------------------------------------
	switch(cmdIdx)
	{
	/* No response */
	case  0:	// fall through
	case 15:	// fall through
		pcmdInfo->rspType = SDMMC_CMDC_RT_NONE;
		break;
	
	/* R1 response */
	case  3:	// fall through
	case  8:	// fall through
	case 13:	// fall through
	case 14:	// fall through
	case 16:	// fall through
	case 17:	// fall through
	case 18:	// fall through
	case 19:	// fall through
	case 23:	// fall through
	case 24:	// fall through
	case 25:	// fall through
	case 27:	// fall through
	case 30:	// fall through
	case 35:	// fall through
	case 36:	// fall through
		pcmdInfo->rspType = SDMMC_CMDC_RT_R1;
		break;
	
	/* R1b response */	
	case  6:	// fall through
	case  7:	// fall through
	case 12:	// fall through
	case 28:	// fall through
	case 29:	// fall through
	case 38:	// fall through
	case 42:	// fall through
		pcmdInfo->rspType = SDMMC_CMDC_RT_R1B;
		break;
		
	/* R2 response */	
	case  2:	// fall through
	case  9:	// fall through
	case 10:	// fall through
		pcmdInfo->rspType = SDMMC_CMDC_RT_R2;
		break;

	/* R3 response */	
	case  1:	// fall through
		pcmdInfo->rspType = SDMMC_CMDC_RT_R3;
		break;
		
	default:
		break;
	}

	

}
/*----------------------------------------------------------
	Function name	:	CMDFin
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
static smtUint32 CMDFin(smtUint32 rspType)
{
	smtInt32		count 	= 0x7FFFF;
	smtUint32		ret 	= 0;
	SDMMC_CMD_STA	sdmmcCmdStatus;
	SDMMC_DAT_STA	sdmmcDatStatus;
	
	
	while(1) {
		
		smtSDMMCCmdGetStatus(&sdmmcCmdStatus);
		smtSDMMCGetStatus(&sdmmcDatStatus);		
		
		switch(rspType) 
		{
		case SDMMC_CMDC_RT_NONE:
			if(sdmmcCmdStatus.CmdSent) 
			{
				ret = 0;
				goto CmdEnd;
			}
			break;
		
		case SDMMC_CMDC_RT_R1:
		case SDMMC_CMDC_RT_R2:
		case SDMMC_CMDC_RT_R6:
			if(sdmmcCmdStatus.RspFin) 
			{
				ret = 0;
				goto CmdEnd;
			}	
			break;
			
		case SDMMC_CMDC_RT_R1B:
			if(sdmmcCmdStatus.RspFin) 
			{
				if(sdmmcDatStatus.BusyFin
				|| sdmmcDatStatus.NoBusy)
				{
					ret = 0;
					goto CmdEnd;
				}
			}	
			break;
			
		case SDMMC_CMDC_RT_R3:
			if(sdmmcCmdStatus.RspFin) 
			{
				ret = 0;
				goto CmdEnd;
			}
			break;		
		}
		
		if(sdmmcCmdStatus.CmdTout) 
		{
			ret = 1;
			goto CmdEnd;
		}		
		
		if(!count--) {
			ret = 2;
			goto CmdEnd;
			
		}		
	}
	
CmdEnd:
	smtSDMMCCmdSetStatus(&sdmmcCmdStatus);
	smtSDMMCCmdSetStatus(&sdmmcCmdStatus);
	
	smtSDMMCGetStatus(&sdmmcDatStatus);
	smtSDMMCSetStatus(&sdmmcDatStatus);
	
	return ret;	
}

/*----------------------------------------------------------
	Function name	: SetCMD
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static smtBoolean	SetCMD(smtBoolean isAppCmd, 
						smtUint32 cmdIdx, smtUint32 cmdArg)
{
	SDMMC_CmdInfo 	cmdInfo;
	SDMMC_CMD_CTRL	sdmmcCtrl;
	smtUint32		rspRet;
	
	//-------------------------------------------------------
	// Get Command information
	//-------------------------------------------------------
	switch(sCardType)
	{
	case SDMMC_CARDTYPE_SD_1BIT:
	case SDMMC_CARDTYPE_SD_4BIT:
	case SDMMC_CARDTYPE_SDHS_1BIT:
	case SDMMC_CARDTYPE_SDHS_4BIT:
		GetSDCmdInfo(cmdIdx, isAppCmd, &cmdInfo);
		break;
	
	case SDMMC_CARDTYPE_MMC:
	case SDMMC_CARDTYPE_MMCHS_1BIT:
	case SDMMC_CARDTYPE_MMCHS_4BIT:		
	case SDMMC_CARDTYPE_MMCHS_8BIT:
		GetMMCCmdInfo(cmdIdx, &cmdInfo);
		break;
		
	}
	
	//-------------------------------------------------------
	// Make command parameter
	//-------------------------------------------------------
	
	// Set command argument
	smtSDMMCCmdSet(cmdArg);
	
	// Reset SDMMC control S/W field
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	
	/* Check abort command control */
	switch(cmdInfo.cmdType)
	{
	case SDMMC_CMDC_CT_NORMAL:
		sdmmcCtrl.AbortCmd	= 0;
		break;
		
	case SDMMC_CMDC_CT_ABORT:
		sdmmcCtrl.AbortCmd	= 1;
		break;
		
	default:
		break;
	}
	
	/* Check reponse type */
	switch(cmdInfo.rspType)
	{
	case SDMMC_CMDC_RT_NONE:
		sdmmcCtrl.noCRCRsp	= 0;
		sdmmcCtrl.BusyRsp	= 0;
		sdmmcCtrl.WaitRsp	= 0;
		sdmmcCtrl.LongRsp	= 0;
		break;
		
	case SDMMC_CMDC_RT_R1:
	case SDMMC_CMDC_RT_R6:
		sdmmcCtrl.noCRCRsp	= 0;
		sdmmcCtrl.BusyRsp	= 0;
		sdmmcCtrl.WaitRsp	= 1;
		sdmmcCtrl.LongRsp	= 0;
		break;
		
	case SDMMC_CMDC_RT_R2:
		sdmmcCtrl.noCRCRsp	= 0;
		sdmmcCtrl.BusyRsp	= 0;
		sdmmcCtrl.WaitRsp	= 1;
		sdmmcCtrl.LongRsp	= 1;
		break;
		
	case SDMMC_CMDC_RT_R1B:
		sdmmcCtrl.noCRCRsp	= 0;
		sdmmcCtrl.BusyRsp	= 1;
		sdmmcCtrl.WaitRsp	= 1;
		sdmmcCtrl.LongRsp	= 0;
		break;
		
	case SDMMC_CMDC_RT_R3:
		sdmmcCtrl.noCRCRsp	= 1;
		sdmmcCtrl.BusyRsp	= 0;
		sdmmcCtrl.WaitRsp	= 1;
		sdmmcCtrl.LongRsp	= 0;
		break;
		
	default:
		break;
	}
	

	/* Send command */
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|cmdIdx;	
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	/* Wait command response*/
	rspRet = CMDFin(cmdInfo.rspType);
	
	if(rspRet) 
	{
		return SMT_FALSE;
	}
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Host external function
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	:	HostSetClkDiv
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
static smtUint32 HostSetClkDiv(smtUint32 div)
{
	smtSDMMCTopSetPreScaler(div);	
	
	return SDMMC_GET_CLK(div);
}
/*----------------------------------------------------------
	Function name	:	HostDATFin
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
static smtUint32 HostDATFin(smtUint32 dir)
{
	smtInt32		count 	= 0x7FFFF;
	smtUint32		ret 	= 0;
	SDMMC_CMD_STA	sdmmcCmdStatus;
	SDMMC_DAT_STA	sdmmcDatStatus;
	
	
	while(1) 
	{
		
		smtSDMMCGetStatus(&sdmmcDatStatus);
		
		switch(dir) 
		{
		case SDMMC_DATC_DD_TX:	
			if(sdmmcDatStatus.DatFin
			&&(!sdmmcDatStatus.RxDatOn)) 
			{
				ret = 0;
				goto DatEnd;
			}				
			break;
			
		case SDMMC_DATC_DD_RX:
			if(sdmmcDatStatus.DatFin
			&&(!sdmmcDatStatus.TxDatOn)) 
			{
				ret = 0;
				goto DatEnd;
			}				
			break;
		
		}
		
		if(sdmmcDatStatus.DatTOut) 
		{	
			ret = 1;
			goto DatEnd;
		}	
		
		if(!count--) {
			ret = 2;
			goto DatEnd;
			
		}		
	}
	

DatEnd:
	smtSDMMCGetStatus(&sdmmcDatStatus);
	smtSDMMCSetStatus(&sdmmcDatStatus);
	
	return ret;		
}
/*----------------------------------------------------------
	Function name	:	HostSetDATCtrl
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
static smtUint32 HostSetDATCtrl(smtUint32 dir, smtUint32 blkSize, smtUint32 blkNum, 
	smtBoolean bDMAEnable)
{
	SDMMC_DAT_CTRL	sdmmcDatCtrl;
	SDMMC_FIFO_STA	sdmmcFIFOStatus;
	
	// Set Block size
	smtSDMMCDatSetDBSize(blkSize-1);
	
	// Set Data control parameter
	if(dir == SDMMC_DATC_DD_TX)
	{
		sdmmcDatCtrl.TransMode = 0x3;
		sdmmcDatCtrl.TARSP	   = 0x1;
		sdmmcDatCtrl.RACMD	   = 0x0;
	}
	else 
	if(dir == SDMMC_DATC_DD_RX)
	{
		sdmmcDatCtrl.TransMode = 0x2;
		sdmmcDatCtrl.TARSP	   = 0x0;
		sdmmcDatCtrl.RACMD	   = 0x1;
	}
	
	if(bDMAEnable == SMT_FALSE)
	{
		sdmmcDatCtrl.DMASize		= 0x00;
		sdmmcDatCtrl.DMAEnable		= 0;
	}
	else
	{
		sdmmcDatCtrl.DMASize		= 0x08;
		sdmmcDatCtrl.DMAEnable		= 1;	
	}
	
	switch(sCardType)
	{
	case SDMMC_CARDTYPE_MMC:
	case SDMMC_CARDTYPE_MMCHS_1BIT:
		sdmmcDatCtrl.WideBusEnable	= 0x0;
		sdmmcDatCtrl.MMCPlus		= 0x0;
		break;

	case SDMMC_CARDTYPE_MMCHS_4BIT:
		sdmmcDatCtrl.WideBusEnable	= 0x1;
		sdmmcDatCtrl.MMCPlus		= 0x0;		
		break;
		
	case SDMMC_CARDTYPE_MMCHS_8BIT:
		sdmmcDatCtrl.WideBusEnable	= 0x1;
		sdmmcDatCtrl.MMCPlus		= 0x1;		
		break;
		
	case SDMMC_CARDTYPE_SD_1BIT:
	case SDMMC_CARDTYPE_SDHS_1BIT:
		sdmmcDatCtrl.WideBusEnable	= 0x0;
		sdmmcDatCtrl.MMCPlus		= 0x0;
		break;
	
	case SDMMC_CARDTYPE_SD_4BIT:
	case SDMMC_CARDTYPE_SDHS_4BIT:
		sdmmcDatCtrl.WideBusEnable	= 0x1;
		sdmmcDatCtrl.MMCPlus		= 0x0;
		break;
	}		
	
	
	// Enable Data control
	sdmmcDatCtrl.ByteOrder		= 0;
	sdmmcDatCtrl.TransStart		= 0;
	sdmmcDatCtrl.BlkNum			= (blkNum-1);
	smtSDMMCDatSetCtrl(&sdmmcDatCtrl);	
	
	// Reset Data FIFO
	smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
	sdmmcFIFOStatus.Reset 		= 1;
	smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);

	// Run Data control
	smtSDMMCDatGetCtrl(&sdmmcDatCtrl);	
	sdmmcDatCtrl.TransStart		= 1;
	smtSDMMCDatSetCtrl(&sdmmcDatCtrl);	
	
}
/*----------------------------------------------------------
	Function name	:	HostSetData
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean HostSetData(smtUint32 buffer, smtUint32 blkSize, smtUint32 blkNum)
{
	smtUint32		bi, fi, wi;
	smtUint32		fifoCnt;
	smtUint32		*pSource;
	smtUint32		ret;
	
	pSource = (smtUint32*)buffer;
	fifoCnt	= blkSize/(sizeof(int)*32);
	
	// get data
	for(bi = 0; bi < blkNum; bi++)
	{
		for (fi = 0; fi < fifoCnt; fi++)
		{	
			while(!(SMT_READ(SDFSTA)&(1<<10)));
			for(wi = 0; wi < 32; wi++)
			{
				smtSDMMCFIFOSetData(*pSource++);
			}
		}
	}
	
	// wait tx finish
	ret = HostDATFin(SDMMC_DATC_DD_TX);
	if(ret) return SMT_FALSE;
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	HostSetDataInt
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean HostSetDataInt(smtUint32 buffer, smtUint32 blkSize, smtUint32 blkNum)
{
	smtUint32			bi, fi, wi;
	smtUint32			fifoCnt;
	smtUint32			*pSource;
	smtUint32			ret;
	SDMMC_INT_ENABLE	sdmmcIntEnable;
	
	pSource = (smtUint32*)buffer;
	fifoCnt	= blkSize/(sizeof(int)*32);

	
	// configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(IRQ_MMC, SDMMCIntHandler);
	gTXFIFOEmpty = 0;
	Enable_IRQ();
	
	// get data
	for(bi = 0; bi < blkNum; bi++)
	{
		for (fi = 0; fi < fifoCnt; fi++)
		{	
			
			EnableIRQ(IRQ_MMC);
			while(1)
			{
				/* Replase to fast rountine
				memset(&sdmmcIntEnable, 0, sizeof(sdmmcIntEnable));
				sdmmcIntEnable.TFEmpty = 1;
				smtSDMMCIntSet(&sdmmcIntEnable);
				*/
				SMT_WRITE(SDIntMsk, (1<<2));
				if(gTXFIFOEmpty)
				{
					gTXFIFOEmpty = 0;
					break;
				}
			}
			
			for(wi = 0; wi < 32; wi++)
			{
				smtSDMMCFIFOSetData(*pSource++);
			}
		}
	}
	
	//sdmmcIntEnable.TFEmpty = 0;
	memset(&sdmmcIntEnable, 0, sizeof(sdmmcIntEnable));
	smtSDMMCIntSet(&sdmmcIntEnable);
	ReleaseIRQ(IRQ_MMC);
	
	// wait tx finish
	ret = HostDATFin(SDMMC_DATC_DD_TX);
	if(ret) return SMT_FALSE;
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	HostSetDataDMA
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean HostSetDataDMA(smtUint32 buffer, smtUint32 blkSize, smtUint32 blkNum)
{
	smtUint32		ret;
	smtUint32		regValue;
	smtUint32		timeOut;
	
	// Cache flushing
	DCacheFlushing();
	
	// set TX & RX DMA
	regValue 	= SMT_READ(RS_DMAMUX);
	regValue	&= ~(0xF			<<(SDMMC_DMA_CH*4));
	regValue	|= (11<<(SDMMC_DMA_CH*4));
	regValue	&= ~(0xF			<<(SDMMC_DMA_CH*4));
	regValue	|= (11<<(SDMMC_DMA_CH*4));	
	SMT_WRITE(RS_DMAMUX, regValue);		
	
#if 0	
	// configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(SDMMC_DMA_INT, SDMMCDMAHandler);
	gDMAEnd = 0;
	Enable_IRQ();
#endif	

	//SDMMCDPRINTF("write 0x%08x:%d, %d\n", buffer, blkSize, blkNum);
		
	// disable
	SMT_WRITE(DMACSta(SDMMC_DMA_CH), 0xf);
	
	// set source address
	SMT_WRITE (DMACSAdr(SDMMC_DMA_CH), (smtUint32)buffer);
	
	// set destination address
	SMT_WRITE (DMACDAdr(SDMMC_DMA_CH), (smtUint32)&SDDAT);
	
	// set configuration 
	regValue =
	 	((0x0 << 31)				// disable start interrupt
		|(0x0 << 30)				// enable end interrupt
		|(0x0 << 29)				// no using flow control(hand shaking)
		|(0x1 << 28)				// source increasement
		|(0x2 << 26)				// source WORD width
		|(0x0 << 25)				// destination increasement
		|(0x2 << 23)				// target WORD width
		|(0x5 << 20)				// burst size 32 byte
		|(blkSize*blkNum));			// total transfer size
	SMT_WRITE (DMACCon(SDMMC_DMA_CH), regValue);
	
	// no use descriptor
	SMT_WRITE (DMACDescrp(SDMMC_DMA_CH), 0x1);
	
	// run 
	SMT_WRITE(DMACSta(SDMMC_DMA_CH), 
		DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);


#if 0
	// wait DMA end
	timeOut = 0;
	while(1) 
	{
		if(gDMAEnd) 
		{
			break;
		}
		
		if(timeOut++ == 0x7FFFF)
		{
			ReleaseIRQ(SDMMC_DMA_INT);
			return SMT_FALSE;
		}
		
	}  	

	ReleaseIRQ(SDMMC_DMA_INT);
#else
	timeOut = 0;
	while(1) 
	{
		if(SMT_READ(DMACSta(SDMMC_DMA_CH))&DMA_STOPINT_MASK) 
		{												
			SMT_WRITE(DMACSta(SDMMC_DMA_CH), 0xf);
			break;
		}
		
		/*
		if(timeOut++ == 0x7FFFF )
		{
			return SMT_FALSE;
		}
		*/
	}
#endif
	
	// wait tx finish
	ret = HostDATFin(SDMMC_DATC_DD_TX);
	if(ret) return SMT_FALSE;
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	HostGetData
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean HostGetData(smtUint32 buffer, smtUint32 blkSize, smtUint32 blkNum)
{
	smtUint32		bi, fi, wi;
	smtUint32		fifoCnt;
	smtUint32		*pTarget;
	smtUint32		ret;
	
	pTarget = (smtUint32*)buffer;
	fifoCnt	= blkSize/(sizeof(int)*32);
	
	// get data
	for(bi = 0; bi < blkNum; bi++)
	{
		for (fi = 0; fi < fifoCnt; fi++)
		{	
			while(!(SMT_READ(SDFSTA)&(1<<8)));
			for(wi = 0; wi < 32; wi++)
			{
				*pTarget++ = smtSDMMCFIFOGetData();
			}
		}
	}
	
	// wait tx finish
	ret = HostDATFin(SDMMC_DATC_DD_RX);
	if(ret) return SMT_FALSE;
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	HostGetDataInt
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean HostGetDataInt(smtUint32 buffer, smtUint32 blkSize, smtUint32 blkNum)
{
	smtUint32			bi, fi, wi;
	smtUint32			fifoCnt;
	smtUint32			*pTarget;
	smtUint32			ret;
	SDMMC_INT_ENABLE	sdmmcIntEnable;
	
	
	pTarget = (smtUint32*)buffer;
	fifoCnt	= blkSize/(sizeof(int)*32);
	
	// configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(IRQ_MMC, SDMMCIntHandler);
	gRXFIFOFull = 0;
	Enable_IRQ();
	
	// get data
	for(bi = 0; bi < blkNum; bi++)
	{
		for (fi = 0; fi < fifoCnt; fi++)
		{	
			/* Replace to fast routine
			memset(&sdmmcIntEnable, 0, sizeof(sdmmcIntEnable));
			sdmmcIntEnable.RFFull = 1;
			smtSDMMCIntSet(&sdmmcIntEnable);
			*/
			SMT_WRITE(SDIntMsk, (1<<1));
			while(1)
			{
				if(gRXFIFOFull)
				{
					gRXFIFOFull = 0;
					break;
				}
			}
			
			for(wi = 0; wi < 32; wi++)
			{
				*pTarget++ = smtSDMMCFIFOGetData();
			}
		}
	}
	
//	sdmmcIntEnable.RFFull = 0;
	memset(&sdmmcIntEnable, 0, sizeof(sdmmcIntEnable));
	smtSDMMCIntSet(&sdmmcIntEnable);
	ReleaseIRQ(IRQ_MMC);
	
	// wait tx finish
	ret = HostDATFin(SDMMC_DATC_DD_RX);
	if(ret) return SMT_FALSE;
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	HostGetDataDMA
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean HostGetDataDMA(smtUint32 buffer, smtUint32 blkSize, smtUint32 blkNum)
{
	smtUint32		ret;
	smtUint32		regValue;
	smtUint32		timeOut;
	
	
	// set TX & RX DMA
	regValue 	= SMT_READ(RS_DMAMUX);
	regValue	&= ~(0xF			<<(SDMMC_DMA_CH*4));
	regValue	|= (11<<(SDMMC_DMA_CH*4));
	regValue	&= ~(0xF			<<(SDMMC_DMA_CH*4));
	regValue	|= (11<<(SDMMC_DMA_CH*4));	
	SMT_WRITE(RS_DMAMUX, regValue);		
	
#if 0
	// configure interrupt
	Disable_IRQ();
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(SDMMC_DMA_INT, SDMMCDMAHandler);
	gDMAEnd = 0;
	Enable_IRQ();
#endif	
	
	//SDMMCDPRINTF("read 0x%08x:%d, %d\n", buffer, blkSize, blkNum);
	
	// disable
	SMT_WRITE(DMACSta(SDMMC_DMA_CH), 0xf);
	
	// set source address
	SMT_WRITE (DMACSAdr(SDMMC_DMA_CH), (smtUint32)&SDDAT);
	
	// set destination address
	SMT_WRITE (DMACDAdr(SDMMC_DMA_CH), (smtUint32)buffer);
	
	// set configuration 
	regValue =
	 	((0x0 << 31)				// disable start interrupt
		|(0x0 << 30)				// enable end interrupt
		|(0x0 << 29)				// no using flow control(hand shaking)
		|(0x0 << 28)				// source increasement
		|(0x2 << 26)				// source WORD width
		|(0x1 << 25)				// destination increasement
		|(0x2 << 23)				// target WORD width
		|(0x5 << 20)				// burst size 32 byte
		|(blkSize*blkNum));			// total transfer size
	SMT_WRITE (DMACCon(SDMMC_DMA_CH), regValue);
	
	// no use descriptor
	SMT_WRITE (DMACDescrp(SDMMC_DMA_CH), 0x1);
	
	// run 
	SMT_WRITE(DMACSta(SDMMC_DMA_CH), 
		DMA_ENABLE_MASK|DMA_ERRORINT_MASK|DMA_STOPINT_MASK);

#if 0
	// wait DMA end
	timeOut = 0;
	while(1) 
	{
		SDMMCDMAHandler(0);
		
		if(gDMAEnd) 
		{
			break;
		}
		
		if(timeOut++ == 0x7FFFF)
		{	
			ReleaseIRQ(SDMMC_DMA_INT);			
			return SMT_FALSE;
		}
		
	}  	
		
	ReleaseIRQ(SDMMC_DMA_INT);

#else

	timeOut = 0;
	while(1) 
	{
		if(SMT_READ(DMACSta(SDMMC_DMA_CH))&DMA_STOPINT_MASK) 
		{												
			SMT_WRITE(DMACSta(SDMMC_DMA_CH), 0xf);
			break;
		}
		
		/*
		if(timeOut++ == 0x7FFFF)
		{
			return SMT_FALSE;
		}
		*/
	}
#endif	
	
	// wait tx finish
	ret = HostDATFin(SDMMC_DATC_DD_RX);
	if(ret) return SMT_FALSE;
		
	// Cache flushing
	DCacheFlushing();
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	: HostSetCMD
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean	HostSetCMD(smtUint32 cmdIdx, smtUint32 cmdArg)
{
	smtBoolean ret;
	
	// Send CMD command
	ret = SetCMD(SMT_FALSE, cmdIdx, cmdArg);
	if(ret == SMT_FALSE) return ret;
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	: HostSetACMD
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtBoolean	HostSetACMD(smtUint32 cmdIdx, smtUint32 cmdArg)
{
	smtBoolean ret;
	
	// Send ACMD ready command
	ret = SetCMD(SMT_FALSE, 55, (sRCA<<16));
	if(ret == SMT_FALSE) return ret;
		
	// Send ACMD command
	ret = SetCMD(SMT_TRUE, cmdIdx, cmdArg);
	if(ret == SMT_FALSE) return ret;
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	HostSetBus
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
static smtBoolean HostSetBus(smtUint32 cardType, smtUint32 busWidth)
{
	smtUint32 	retryCount;
	smtBoolean	result;
	
	if(cardType == SDMMC_CARDTYPE_MMC)
	{
		return SMT_TRUE;
	}
	else
	if(cardType <= SDMMC_CARDTYPE_SDHS_4BIT)
	{
		retryCount = 0;
SD_ACMD6:
		if(retryCount++ > SDMMC_MAX_RETRY) 
		{
			return SMT_FALSE;
		}
    	
    	if(busWidth == 1) 
    	{
			result	= HostSetACMD(SDMMC_SET_BUS_WIDTH, 0x0);
		}
		else // buswidth == 4
    	{
			result	= HostSetACMD(SDMMC_SET_BUS_WIDTH, 0x2);
		}
		
		if(result == SMT_FALSE)
		{
			
			SDMMCDPRINTF("[SDMMC TEST] SDMMC_SET_BUS_WIDTH(%d Retry fail)\n"
				,retryCount);
						
			goto SD_ACMD6;
		}	
		else
		{
			SDMMCDPRINTF("[SDMMC TEST] SDMMC_SET_BUS_WIDTH(OK)\n");
		}			
		
	}
	else
	{
		retryCount = 0;
MMC_CMD6:	
		if(retryCount++ > SDMMC_MAX_RETRY) 
		{
			return -1;
		}	
		
		
		//result	= HostSetCMD(6, 0x03B70200);		// 8bits
		//sCardType = SDMMC_CARDTYPE_MMCHS_8BIT;
		
		//result	= HostSetCMD(6, 0x03B70100);		// 4bits
		//sCardType = SDMMC_CARDTYPE_MMCHS_4BIT;
		
		if(busWidth == 1) 
    	{
			result		= HostSetCMD(6, 0x03B70000);		// 1bit
		}
		else 
		if(busWidth == 4) 
		{
			result		= HostSetCMD(6, 0x03B70100);		// 4bits
		}
		else 
		if(busWidth == 8) 
		{
			result		= HostSetCMD(6, 0x03B70200);		// 8bits
		}
		
		if(result == SMT_FALSE)
		{
			
			SDMMCDPRINTF("[SDMMC TEST] SWITCH(%d Retry fail)\n"
				,retryCount);
			goto MMC_CMD6;
		}	
		else
		{	
			SDMMCDPRINTF("[SDMMC TEST] SWITCH(OK)\n");
		}					
	}
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Device external function
-----------------------------------------------------------*/
/*----------------------------------------------------------
	Function name	: DeviceDGetCardStatus
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 DeviceDGetCardStatus(void)
{
	smtUint32 		result;
	smtUint32 		cardStatus;
	SDMMC_CMD_RSP	sdmmcRsp;
	
	volatile smtUint32 retryCount;

	retryCount = 0;
CMD13:	
	result	= HostSetACMD(13, 0x0);
	if(result == SMT_FALSE)
	{
	
		SDMMCDPRINTF("[SDMMC TEST] SD_STATUS(%d Retry fail)\n"
			,retryCount);
					
		goto CMD13;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SD_STATUS(OK)\n");
	}	
	
	smtSDMMCGetResponse(&sdmmcRsp);	
	cardStatus = (sdmmcRsp.response0 >> 9) & 0xf;
	
	return cardStatus;
}
/*----------------------------------------------------------
	Function name	: DeviceDGetCardStatus
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
smtUint32 DeviceDGetMMCCardStatus(void)
{
	smtUint32 		result;
	smtUint32 		cardStatus;
	SDMMC_CMD_RSP	sdmmcRsp;
	
	volatile smtUint32 retryCount;

	retryCount = 0;
CMD13:	
	result	= HostSetCMD(13, (1<<16));
	if(result == SMT_FALSE)
	{
	
		SDMMCDPRINTF("[SDMMC TEST] STATUS(%d Retry fail)\n"
			,retryCount);
					
		goto CMD13;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] STATUS(OK)\n");
	}	
	
	smtSDMMCGetResponse(&sdmmcRsp);	
	cardStatus = (sdmmcRsp.response0 >> 9) & 0xf;
	
	return cardStatus;
}
/*----------------------------------------------------------
	Function name	:	DeviceWriteSectors
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtInt32 DeviceWriteSectors(smtInt32	drive, smtUint32 sector, 
							smtUint32 count, void *source, smtUint32 mode)
{	

	smtUint32		result;
	smtInt32 		retryCount;
	smtBoolean		bDMAEnable;

	//SDMMCDPRINTF("write sector %d, count: %d\n", sector, count);

	retryCount 	= 0;
SD_CMD25:
	if(retryCount++ > SDMMC_MAX_RETRY)
	{
		return -1;
	}
	
	if(mode == SDMMC_TM_DMA) 	bDMAEnable = SMT_TRUE;
	else						bDMAEnable = SMT_FALSE;
	
	//-------------------------------------------------------
	// Enable Data control and Start Data control
	//-------------------------------------------------------
	HostSetDATCtrl(
		SDMMC_DATC_DD_TX,	// RX mode
		512,				// Block size
		count,				// Block counter
		bDMAEnable);		// DMA enable
	
	//-------------------------------------------------------
	// Send command CMD25
	//
	//			continuously transfers data blocks from
	//			card to host until interrupted by a
	//			STOP_TRANSMISSION command.
	//-------------------------------------------------------
	result = HostSetCMD(25, sector*512);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] WRITE_MULTIPLE_BLOCK(%d Retry fail)\n"
			,retryCount);

			
		goto SD_CMD25;
	}
	else
	{
		//SDMMCDPRINTF("[SDMMC TEST] WRITE_MULTIPLE_BLOCK(OK)\n");
	}	
	
	//-------------------------------------------------------
	//	Set data to sdmmc's data FIFO
	//-------------------------------------------------------
	if(mode == SDMMC_TM_POL)
	{
		result = HostSetData(
			(smtUint32)source, 	// source buffer
			512, 				// block size
			count);				// block count
	} else
	if(mode == SDMMC_TM_INT)
	{
		result = HostSetDataInt(
			(smtUint32)source, 	// source buffer
			512, 				// block size
			count);				// block count
		
	} else
	if(mode == SDMMC_TM_DMA)
	{
		result = HostSetDataDMA(
			(smtUint32)source, 	// source buffer
			512, 				// block size
			count);				// block count
	}
		
	
	if(result == SMT_FALSE)
	{
		goto SD_CMD25;
	}

	
	//-------------------------------------------------------
	//	SDMMC_CMD12
	//-------------------------------------------------------
SD_CMD12:
	
	result = HostSetCMD(SDMMC_STOP_TRANSMISSION, 0x0);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] STOP_TRANSMISSION(%d Retry fail)\n"
			,retryCount);
		goto SD_CMD12;
	}
	else
	{
		//SDMMCDPRINTF("[SDMMC TEST] STOP_TRANSMISSION(OK)\n");
	}	

			
	return 0;

}       
/*----------------------------------------------------------
	Function name	:	DeviceReadSectors
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtInt32 DeviceReadSectors(smtInt32 drive,smtUint32 sector,  
							smtUint32 count, void *target ,smtUint32 mode)
{
	
	smtInt32	retryCount;
	smtUint32	result;
	smtBoolean	bDMAEnable;
	
//	SDMMCDPRINTF("read sector count: %d\n", count);

	retryCount = 0;	
SD_CMD18:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}	
	
	if(mode == SDMMC_TM_DMA) 	bDMAEnable = SMT_TRUE;
	else						bDMAEnable = SMT_FALSE;
	
	//-------------------------------------------------------
	// Enable Data control & Run Data control
	//-------------------------------------------------------
	HostSetDATCtrl(
		SDMMC_DATC_DD_RX,	// RX mode
		512,				// Block size
		count,				// Block counter
		bDMAEnable);		// DMA enable
	
	//-------------------------------------------------------
	// Send command CMD18 
	//
	//			continuously transfers data blocks from
	//			card to host until interrupted by a
	//			STOP_TRANSMISSION command.
	//-------------------------------------------------------	
	result = HostSetCMD(18, sector*512);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SDMMC_READ_MULTIPLE_BLOCK(%d Retry fail)\n"
			,retryCount);

			
		goto SD_CMD18;
	}
	else
	{
		//SDMMCDPRINTF("[SDMMC TEST] SDMMC_READ_MULTIPLE_BLOCK(OK)\n");
	}	
	
	//-------------------------------------------------------
	//	Get data to sdmmc's data FIFO
	//-------------------------------------------------------
	
	if(mode == SDMMC_TM_POL)
	{
		result = HostGetData(
			(smtUint32)target, 	// target buffer
			512, 				// block size
			count);				// block count
	} else
	if(mode == SDMMC_TM_INT)
	{
		result = HostGetDataInt(
			(smtUint32)target, 	// target buffer
			512, 				// block size
			count);		
	} else
	if(mode == SDMMC_TM_DMA)
	{
		result = HostGetDataDMA(
			(smtUint32)target, 	// target buffer
			512, 				// block size
			count);				// block count
	}
	
	
	if(result == SMT_FALSE)
	{
		goto SD_CMD18;
	}

	
	//-------------------------------------------------------
	//	SDMMC_CMD12
	//-------------------------------------------------------
SD_CMD12:
	result = HostSetCMD(SDMMC_STOP_TRANSMISSION, sector*512);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SDMMC_STOP_TRANSMISSION(%d Retry fail)\n"
			,retryCount);
			
		goto SD_CMD12;
	}
	else
	{
		//SDMMCDPRINTF("[SDMMC TEST] SDMMC_STOP_TRANSMISSION(OK)\n");
	}
	
	
	
	return 0;

}
/*----------------------------------------------------------
	Function name	:	SDMMCDPRINTF
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
static smtUint32 SDMMCDPRINTF(smtInt8 *format, ...)
{
	char str[128];
	va_list ap;
	va_start(ap, format);
	vsnprintf(str, 128, format, ap);
	va_end(ap);

	smt2UartPutStr(str);

	return SMT_SUCCESS;
}
/*----------------------------------------------------------
	Function name	: SDMMCDMAHandler
	Prototype		: static void SDMMCDMAHandler(smtUint32 irq)
	Return			: none
	Argument		: requested system interrupt number
	Comments		: NAND DMA end interrupt handler
-----------------------------------------------------------*/
static void SDMMCDMAHandler(smtUint32 irq)
{
	SMT_WRITE(DMACSta(SDMMC_DMA_CH), 0xf);
	gDMAEnd = 1;
}

/*----------------------------------------------------------
	Function name	: SDMMCDMAHandler
	Prototype		: static void SDMMCDMAHandler(smtUint32 irq)
	Return			: none
	Argument		: requested system interrupt number
	Comments		: NAND DMA end interrupt handler
-----------------------------------------------------------*/
static void SDMMCIntHandler(smtUint32 irq)
{
	SDMMC_INT_STA		sdmmcIntStatus;
	SDMMC_INT_ENABLE	sdmmcIntEnable;
	
	
	smtSDMMCIntGetStatus(&sdmmcIntStatus);
	if(sdmmcIntStatus.TFEmpty)
	{		
		gTXFIFOEmpty = 1;
	}
	
	if(sdmmcIntStatus.RFFull)
	{
		
		gRXFIFOFull	 = 1;
	}
	
	smtSDMMCIntSetStatus(&sdmmcIntStatus);
	SMT_WRITE(SDIntMsk, 0x0);
}
/*----------------------------------------------------------
	Function name	:	DeviceSDInit
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtUint32 DeviceSDInit(void)
{
	SDMMC_CMD_RSP			sdmmcRsp;
	
	smtUint32				result;
	smtUint32				ACMD41Arg  	= 0x0;
	volatile smtUint32		retryCount	= 0x0;	
	
SD_ACMD41:	
	if(retryCount++ > SDMMC_MAX_RETRY)
	{
		return -1;
	}

	//-------------------------------------------------------
	//	Send command SEND_OP_COND 
	//-------------------------------------------------------
	result = HostSetACMD(SDMMC_SD_SEND_OP_COND, ACMD41Arg);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] APP_CMD(%d Retry fail)\n"
			,retryCount);
		goto SD_ACMD41;
	}
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] APP_CMD(OK)\n");
	}

	
	//-------------------------------------------------------
	//	Check SD card power condition
	//-------------------------------------------------------
	
	// get response
	smtSDMMCGetResponse(&sdmmcRsp);	
	
	SDMMCDPRINTF("[SDMMC TEST] SD OCR Register(0x%08x)\n"
				,sdmmcRsp.response0);
	
	// check SD busy status
	if(!(sdmmcRsp.response0&0x80000000)) 
	{
		ACMD41Arg = sdmmcRsp.response0;
				
		goto SD_ACMD41;
	}
			
	SDMMCDPRINTF("[SDMMC TEST] Finish Card power condition(OK)\n");
	
	//-------------------------------------------------------
	// Send command ALL_SEND_CID 
	//-------------------------------------------------------
	retryCount = 0;
SD_CMD2:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{

		return -1;
	}		

	result	= HostSetCMD(SDMMC_SEND_CID, 0x0);
	if(result == SMT_FALSE)
	{
		
		SDMMCDPRINTF("[SDMMC TEST] ALL_SEND_CID(%d Retry fail)\n"
			,retryCount);
					
		goto SD_CMD2;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] ALL_SEND_CID(OK)\n");
	}
	
	// get response
	smtSDMMCGetResponse(&sdmmcRsp);	

	//-------------------------------------------------------
	// Send command SEND_RELATIVE_ADDR 
	//-------------------------------------------------------
	retryCount = 0;
SD_CMD3:				
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}	

	result	= HostSetCMD(SDMMC_SEND_RELATIVE_ADDR, 0x0);
	if(result == SMT_FALSE)
	{
		
		SDMMCDPRINTF("[SDMMC TEST] SDMMC_SEND_RELATIVE_ADDR(%d Retry fail)\n"
			,retryCount);
					
		goto SD_CMD3;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SDMMC_SEND_RELATIVE_ADDR(OK)\n");
	}	
	
	// get response
	smtSDMMCGetResponse(&sdmmcRsp);		
	sRCA = (sdmmcRsp.response0 & 0xFFFF0000) >> 16;
	SDMMCDPRINTF("[SDMMC TEST] SD Card RCA = 0x%04x\n", sRCA);
	

	//-------------------------------------------------------
	// SEND_CSD send command
	//-------------------------------------------------------	
	retryCount = 0;
SD_CMD9:	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}		
	result	= HostSetCMD(9, sRCA<<16);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_CSD(%d Retry fail)\n"
			,retryCount);
					
		goto SD_CMD9;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_CSD(OK)\n");
	}		
	smtSDMMCGetResponse(&sdmmcRsp);
	
	card_info.raw_csd[0] = sdmmcRsp.response0;
	card_info.raw_csd[1] = sdmmcRsp.response1;
	card_info.raw_csd[2] = sdmmcRsp.response2;
	card_info.raw_csd[3] = sdmmcRsp.response3;

	smt2UartPrint(11, "0x%08X, 0x%08X, 0x%08X, 0x%08X\n", 
		sdmmcRsp.response0, sdmmcRsp.response1,
		sdmmcRsp.response2, sdmmcRsp.response3);
	
	//-------------------------------------------------------
	// SEND_CID send command
	//-------------------------------------------------------	
	retryCount = 0;
SD_CMD10:	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}		
	result	= HostSetCMD(10, sRCA<<16);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_CSD(%d Retry fail)\n"
			,retryCount);
					
		goto SD_CMD10;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_CSD(OK)\n");
	}		
	smtSDMMCGetResponse(&sdmmcRsp);
	
/*
	SDMMCDPRINTF("C_SIZE: %x\n", 
			sdmmcRsp.response1 >> 2 & 0xfff);	
	SDMMCDPRINTF("C_SIZE_MULTI: %x\n", 
			sdmmcRsp.response2 >> 15 & 0xf);
	SDMMCDPRINTF("block size: %x\n", 
			sdmmcRsp.response0 >> 16 & 0xf);
			
	SDMMCDPRINTF(" manufacture: %c%c%c%c%c\n", 
		 (sdmmcRsp.response1 & 0xFF),
		((sdmmcRsp.response1 >>  8)& 0xFF),
		((sdmmcRsp.response1 >> 16)& 0xFF),
		((sdmmcRsp.response1 >> 24)& 0xFF),
		((sdmmcRsp.response0)& 0xFF));
*/		

	card_info.raw_cid[0] = sdmmcRsp.response0;
	card_info.raw_cid[1] = sdmmcRsp.response1;
	card_info.raw_cid[2] = sdmmcRsp.response2;
	card_info.raw_cid[3] = sdmmcRsp.response3;	

	//-------------------------------------------------------
	// Send command SELECT 
	//-------------------------------------------------------
	retryCount = 0;
SD_CMD7:				
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}		
	
	result	= HostSetCMD(SDMMC_SELECT, (sRCA<<16));
	if(result == SMT_FALSE)
	{
		
		SDMMCDPRINTF("[SDMMC TEST] SELECT(%d Retry fail)\n"
			,retryCount);
					
		goto SD_CMD7;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SELECT(OK)\n");
	}	
	
	//-------------------------------------------------------
	//	Send command SET_CLR_CARD_DETECT 
	//-------------------------------------------------------
	retryCount = 0;
SD_ACMD42:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}
	
	result	= HostSetACMD(SDMMC_SET_CLR_CARD_DETECT, 0x0);
	if(result == SMT_FALSE)
	{
		
		SDMMCDPRINTF("[SDMMC TEST] SDMMC_SET_CLR_CARD_DETECT(%d Retry fail)\n"
			,retryCount);
					
		goto SD_ACMD42;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SDMMC_SET_CLR_CARD_DETECT(OK)\n");
	}	
	smtSDMMCGetResponse(&sdmmcRsp);	
	
	//-------------------------------------------------------
	//	Send command SET_BUS_WIDTH
	//-------------------------------------------------------
	retryCount = 0;
SD_ACMD6:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}

	result	= HostSetACMD(SDMMC_SET_BUS_WIDTH, 0x2);
	if(result == SMT_FALSE)
	{
		
		SDMMCDPRINTF("[SDMMC TEST] SDMMC_SET_BUS_WIDTH(%d Retry fail)\n"
			,retryCount);
					
		goto SD_ACMD6;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SDMMC_SET_BUS_WIDTH(OK)\n");
	}	
			
	//-------------------------------------------------------
	//	Send command SET_BLOCKLEN 
	//-------------------------------------------------------	
	retryCount = 0;
CMD16:	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}

	result	= HostSetCMD(16, 512);
	if(result == SMT_FALSE)
	{
		
		SDMMCDPRINTF("[SDMMC TEST] SET_BLOCKLEN(%d Retry fail)\n"
			,retryCount);
					
		goto CMD16;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SET_BLOCKLEN(OK)\n");
	}
				
	//-------------------------------------------------------
	// Set clock
	//-------------------------------------------------------
	smtSDMMCTopSetPreScaler(0x0);	
	
	SDMMCDPRINTF("End Detect card!!!\n");
	
	
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	DeviceMMCInit
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtUint32 DeviceMMCInit(void)
{
	
	SDMMC_CMD_RSP			sdmmcRsp;
	
	smtUint32				result;
	smtUint32				SPEC_VER;
	volatile smtUint32		retryCount;
	
			
	//-------------------------------------------------------
	// MMC_SEND_OP_COND(1) send command
	//-------------------------------------------------------
	retryCount = 0;
MMC_CMD1:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}	

	result	= HostSetCMD(MMC_SEND_OP_COND, 0x00FF8000);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_OP_COND(%d Retry fail)\n"
			,retryCount);
					
		goto MMC_CMD1;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_OP_COND(OK)\n");
	}
	smtSDMMCGetResponse(&sdmmcRsp);	
	SDMMCDPRINTF("[SDMMC TEST] MMC OCR Register(0x%08x)\n"
				,sdmmcRsp.response0);
	

	// check MMC busy status
	if(!(sdmmcRsp.response0&0x80000000)) 
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_OP_COND(OK)\n");
		goto MMC_CMD1;
	}				
	

	//-------------------------------------------------------
	// MMC_ALL_SEND_CID(2) send command
	//-------------------------------------------------------
	retryCount = 0;
MMC_CMD2:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}		
	result	= HostSetCMD(MMC_ALL_SEND_CID, 0x0);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] ALL_SEND_CID(%d Retry fail)\n"
			,retryCount);
					
		goto MMC_CMD2;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] ALL_SEND_CID(OK)\n");
	}
	
	smtSDMMCGetResponse(&sdmmcRsp);		
	SDMMCDPRINTF("MMC CID 0 : 0x%08x\n", sdmmcRsp.response0);
	SDMMCDPRINTF("MMC CID 1 : 0x%08x\n", sdmmcRsp.response1);
	SDMMCDPRINTF("MMC CID 2 : 0x%08x\n", sdmmcRsp.response2);
	SDMMCDPRINTF("MMC CID 3 : 0x%08x\n", sdmmcRsp.response3);
	
	//-------------------------------------------------------
	// MMC_SET_RELATIVE_ADDR(3) send command
	//-------------------------------------------------------	
	retryCount = 0;
MMC_CMD3:	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}		
	result	= HostSetCMD(MMC_SET_RELATIVE_ADDR, 1<<16);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SET_RELATIVE_ADDR(%d Retry fail)\n"
			,retryCount);
					
		goto MMC_CMD3;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SET_RELATIVE_ADDR(OK)\n");
	}		
	
	smtSDMMCGetResponse(&sdmmcRsp);
	sRCA = 1;
	
	//-------------------------------------------------------
	// SEND_CSD send command
	//-------------------------------------------------------	
	retryCount = 0;
MMC_CMD9:	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}		
	result	= HostSetCMD(9, sRCA<<16);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_CSD(%d Retry fail)\n"
			,retryCount);
					
		goto MMC_CMD9;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SEND_CSD(OK)\n");
	}		
	smtSDMMCGetResponse(&sdmmcRsp);
	
	raw_csd[0] = sdmmcRsp.response0;
	raw_csd[1] = sdmmcRsp.response1;
	raw_csd[2] = sdmmcRsp.response2;
	raw_csd[3] = sdmmcRsp.response3;
	
	SPEC_VER = (sdmmcRsp.response0&0x3c000000)>>26;
	SDMMCDPRINTF("SPEC_VERS: 0x%08x\n", SPEC_VER);		
	
	//-------------------------------------------------------
	// SELECT/DESELECT_CARD(7) send command
	//-------------------------------------------------------	
	retryCount = 0;
MMC_CMD7:	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}		
	result	= HostSetCMD(MMC_SEL_TOGGLE_CARD, sRCA<<16);
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SEL_TOGGLE_CARD(%d Retry fail)\n"
			,retryCount);
					
		goto MMC_CMD7;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SEL_TOGGLE_CARD(OK)\n");
	}		
	smtSDMMCGetResponse(&sdmmcRsp);

	
	//-------------------------------------------------------
	//	Send command SWITCH 
	//-------------------------------------------------------	
	retryCount = 0;
MMC_CMD6_0:	
	if(retryCount++ > 3) 
	{
		goto TRANS_STATE;
	}	

	result	= HostSetCMD(6, 0x0);			
	if(result == SMT_FALSE)
	{
		SDMMCDPRINTF("[SDMMC TEST] SWITCH(%d Retry fail)\n"
			,retryCount);
		goto MMC_CMD6_0;
	}	
	else
	{			
		SDMMCDPRINTF("[SDMMC TEST] SWITCH(OK)\n");
	}			
	

	retryCount = 0;
MMC_CMD6:	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		return -1;
	}	
	
	//result	= HostSetCMD(6, 0x03B70200);		// 8bits
	//sCardType = SDMMC_CARDTYPE_MMCHS_8BIT;
	
	result	= HostSetCMD(6, 0x03B70100);		// 4bits
	sCardType = SDMMC_CARDTYPE_MMCHS_4BIT;
	
	//result	= HostSetCMD(6, 0x03B70000);			// 1bit
	//sCardType = SDMMC_CARDTYPE_MMCHS_1BIT;
	if(result == SMT_FALSE)
	{
		
		SDMMCDPRINTF("[SDMMC TEST] SWITCH(%d Retry fail)\n"
			,retryCount);
		goto MMC_CMD6;
	}	
	else
	{	
		SDMMCDPRINTF("[SDMMC TEST] SWITCH(OK)\n");
	}			
	

TRANS_STATE:

			
	//-------------------------------------------------------
	//	Send command SET_BLOCKLEN 
	//-------------------------------------------------------	
CMD16:	
	result	= HostSetCMD(16, 512);
	if(result == SMT_FALSE)
	{
		
		SDMMCDPRINTF("[SDMMC TEST] SET_BLOCKLEN(%d Retry fail)\n"
			,retryCount);
					
		goto CMD16;
	}	
	else
	{
		SDMMCDPRINTF("[SDMMC TEST] SET_BLOCKLEN(OK)\n");
	}	
					
	
	//-------------------------------------------------------
	// Set MMC clock
	//-------------------------------------------------------
	smtSDMMCTopSetPreScaler(0x1);	
	
	SDMMCDPRINTF("End Detect card!!!\n");
	
		
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	:	SDMMCIdentify
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtInt32 SDMMCIdentify(void)
{
	SDMMC_INT_ENABLE		sdmmcIntEnb;
	SDMMC_INT_STA			sdmmcStatus;
	SDMMC_CMD_CTRL			sdmmcCtrl;
	SDMMC_CMD_RSP			sdmmcRsp;
	
	smtUint32				result;
	smtUint32				ACMD41Arg  	= 0x0;
	smtUint32 				RCA;
	smtInt32				Result;
	
	volatile smtUint32		retryCount	= 0x0;
	
	//-------------------------------------------------------
	// SD/MMC init
	//-------------------------------------------------------
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	SDMMCDPRINTF("Start media card dectection!\n");
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	
	//-------------------------------------------------------
	// SD/MMC Power up
	//-------------------------------------------------------
	
	// MMC Power ON
	SMT_WRITE(GPIO0_OE, SMT_READ(GPIO0_OE)|0x80000000);
	SMT_WRITE(GPIO0_OUT, SMT_READ(GPIO0_OUT)&0xFFFFFFFF);

	SDMMCDPRINTF("[SDMMC TEST] Power off -> on!\n");
	SMT_WRITE(GPIO0_OUT, SMT_READ(GPIO0_OUT)&0x7FFFFFFF);
	
	
	//-------------------------------------------------------
	// SD/MMC reset
	//-------------------------------------------------------
	
	// disable clock
	smtSDMMCTopEnableClk(0);
	
	// SD/MMC on
	smtSDMMCTopReset();
	
	// set clock
	smtSDMMCTopSetPreScaler(0xFF);	
	smtSDMMCDatSetTimer(0xFFFFFFFF);
	
	// interrupt enable
	smtSDMMCIntGetStatus(&sdmmcStatus);
	smtSDMMCIntSetStatus(&sdmmcStatus);
	memset(&sdmmcIntEnb, 0, sizeof(SDMMC_INT_ENABLE));	
	smtSDMMCIntSet(&sdmmcIntEnb);
	smtSDMMCTopEnableClk(1);
	
	sRCA = 0x0;
	
	//-------------------------------------------------------
	//	Send commond GO_IDLE_STATE: CMD0(--)
	//-------------------------------------------------------
	retryCount = 0;
SD_CMD0:
	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		SDMMCDPRINTF("[SDMMC TEST] GO_IDLE_STATE(time out)\n");
		return -1;
	}
			
	
	// wait command sent
	result	= HostSetCMD(SDMMC_GO_IDLE_STATE, 0x0);
	if(result == SMT_FALSE) 
	{
		
		SDMMCDPRINTF("[SDMMC TEST] GO_IDLE_STATE(%d retry fail)\n"
			,retryCount);
		goto SD_CMD0;
	} 
	else
	{
	
		SDMMCDPRINTF("[SDMMC TEST] GO_IDLE_STATE(OK)\n");
	}

	//-------------------------------------------------------
	//	Check SD/MMC card
	//-------------------------------------------------------
	// wait reponse
	result	= HostSetCMD(SDMMC_APP_CMD, (sRCA<<16));
	if(result == SMT_FALSE) 
	{
	
		SDMMCDPRINTF("[SDMMC TEST] Found MMC card!\n");
		sCardType	= SDMMC_CARDTYPE_MMC;
		Result 		= DeviceMMCInit();
	}
	else
	{	
		SDMMCDPRINTF("[SDMMC TEST] Found SD card!\n");
		sCardType	= SDMMC_CARDTYPE_SD_4BIT;
		Result 		= DeviceSDInit();
		
	}
	
	return Result;
	
}
/*----------------------------------------------------------
	Function name	:	SDMMCRWTest
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean SDMMCRWTest(void)
{
	
	smtUint32	mSector, loopCnt, wi;
	smtBoolean	compareResult;
	
	static smtUint32	buffer[512];
	
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	SDMMCDPRINTF(" SDMMC TRANSFER POLLING \n");
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	for(mSector = 1; mSector < 4; mSector++)    
	{
		for(loopCnt = 0; loopCnt < 10; loopCnt++)
		{
			SDMMCDPRINTF("[SDMMC TEST] test SDMMC(s:%05d, m:%05d)...\n",
					loopCnt, mSector);
			MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
			DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_POL);
			
			memset(buffer, 0, sizeof(buffer));
			DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_POL);
			compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
			if(compareResult == false) 
			{
				SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
				return false;
			}
			//HexDump((smtUint32)buffer, 512*3);
		}
	}
	
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	SDMMCDPRINTF(" SDMMC TRANSFER INTERRUPT \n");
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	for(mSector = 1; mSector < 4; mSector++)    
	{
		for(loopCnt = 0; loopCnt < 10; loopCnt++)
		{
			SDMMCDPRINTF("[SDMMC TEST] test SDMMC(s:%05d, m:%05d)...\n",
					loopCnt, mSector);
			MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
			DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_INT);
			
			memset(buffer, 0, sizeof(buffer));
			DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_INT);
			compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
			if(compareResult == false) 
			{
				SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
				return false;
			}
			//HexDump((smtUint32)buffer, 512*3);
		}
	}
	
	
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	SDMMCDPRINTF(" SDMMC TRANSFER DMA \n");
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	for(mSector = 1; mSector < 4; mSector++)    
	{
		for(loopCnt = 0; loopCnt < 10; loopCnt++)
		{
			SDMMCDPRINTF("[SDMMC TEST] test SDMMC(s:%05d, m:%05d)...\n",
					loopCnt, mSector);
			MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
			DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_DMA);
			
			memset(buffer, 0, sizeof(buffer));
			DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_DMA);
			compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
			if(compareResult == false) 
			{
				SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
				return false;
			}
			//HexDump((smtUint32)buffer, 512*3);
		}
	}
	
	return true;	
		
}
/*----------------------------------------------------------
	Function name	:	SDMMCClkTest
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean SDMMCClkTest(void)
{
	
	smtUint32	mSector, loopCnt, wi;
	smtUint32	HostClk, clkDiv, clkDivLmt;
	smtBoolean	compareResult;
	
	static smtUint32	buffer[512];
	
	if(sCardType <= SDMMC_CARDTYPE_SDHS_4BIT)	clkDivLmt = 0;
	else if(sCardType == SDMMC_CARDTYPE_MMC)	clkDivLmt = 2;
	else										clkDivLmt = 0;
	
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	SDMMCDPRINTF(" Clock Test by CPU \n");
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	for(clkDiv = clkDivLmt; clkDiv < 30; clkDiv++)
	{
		HostClk = HostSetClkDiv(clkDiv);
		
		for(mSector = 1; mSector < 2; mSector++)    
		{
			for(loopCnt = 0; loopCnt < 1; loopCnt++)
			{
				SDMMCDPRINTF("[SDMMC TEST] test SDMMC(clk: %03d,%03d,%03dHz, s:%05d, m:%05d)...\n",
						(((HostClk/1000)/1000)%1000), ((HostClk/1000)%1000), (HostClk%1000)
						, loopCnt, mSector);
						
				MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
				DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_POL);
				
				memset(buffer, 0, sizeof(buffer));
				DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_POL);
				compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
				if(compareResult == false) 
				{
					SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
					return false;
				}
				//HexDump((smtUint32)buffer, 512*3);
			}
		}
	}

	SDMMCDPRINTF("-------------------------------------------------------------\n");
	SDMMCDPRINTF(" Clock Test by Interrupt \n");
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	for(clkDiv = clkDivLmt; clkDiv < 30; clkDiv++)
	{
		
		HostClk = HostSetClkDiv(clkDiv);
		
		for(mSector = 1; mSector < 2; mSector++)    
		{
			for(loopCnt = 0; loopCnt < 1; loopCnt++)
			{
				SDMMCDPRINTF("[SDMMC TEST] test SDMMC(clk: %03d,%03d,%03dHz, s:%05d, m:%05d)...\n",
						(((HostClk/1000)/1000)%1000), ((HostClk/1000)%1000), (HostClk%1000)
						, loopCnt, mSector);
						
				MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
				DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_INT);
				
				memset(buffer, 0, sizeof(buffer));
				DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_INT);
				compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
				if(compareResult == false) 
				{
					SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
					return false;
				}
				//HexDump((smtUint32)buffer, 512*3);
			}
		}
	}
	
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	SDMMCDPRINTF(" Clock Test by DMA \n");
	SDMMCDPRINTF("-------------------------------------------------------------\n");
	for(clkDiv = clkDivLmt; clkDiv < 30; clkDiv++)
	{
		HostClk = HostSetClkDiv(clkDiv);
		
		for(mSector = 1; mSector < 2; mSector++)    
		{
			for(loopCnt = 0; loopCnt < 1; loopCnt++)
			{
				SDMMCDPRINTF("[SDMMC TEST] test SDMMC(clk: %03d,%03d,%03dHz, s:%05d, m:%05d)...\n",
						(((HostClk/1000)/1000)%1000), ((HostClk/1000)%1000), (HostClk%1000)
						, loopCnt, mSector);
						
				MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
				DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_DMA);
				
				memset(buffer, 0, sizeof(buffer));
				DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_DMA);
				compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
				if(compareResult == false) 
				{
					SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
					return false;
				}
				//HexDump((smtUint32)buffer, 512*3);
			}
		}
	}
	
	HostClk = HostSetClkDiv(0x1);
	
	return true;	
		
}
/*----------------------------------------------------------
	Function name	:	SDMMCBusTest
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtBoolean SDMMCBusTest(void)
{
	
	
	smtUint32	mSector, loopCnt, wi;
	smtBoolean	compareResult;
	
	static smtUint32	buffer[512];
	
	smtUint32	prevCardType = sCardType;
	smtUint32	prevBusWidth;
	smtUint32	testCardType[10], testCardCnt;
	smtUint32	testBusType[10];
	smtUint32	testIdx;
	
	
	if(sCardType == SDMMC_CARDTYPE_MMC)
	{
		prevBusWidth	= 1;
		testCardType[0] = SDMMC_CARDTYPE_MMC;
		testBusType[0]	= 1;
		testCardCnt		= 1;		
	}
	else 
	if(sCardType <= SDMMC_CARDTYPE_SDHS_4BIT)
	{
		prevBusWidth	= 4;
		
		testCardType[0] = SDMMC_CARDTYPE_SD_1BIT;
		testBusType[0]	= 1;
		testCardType[1] = SDMMC_CARDTYPE_SD_4BIT;
		testBusType[1]	= 4;
		testCardCnt		= 2;
	}
	else
	{
		prevBusWidth	= 4;
		
		testCardType[0] = SDMMC_CARDTYPE_MMCHS_1BIT;
		testBusType[0]	= 1;
		testCardType[1] = SDMMC_CARDTYPE_MMCHS_4BIT;
		testBusType[1]	= 4;
		testCardType[2] = SDMMC_CARDTYPE_MMCHS_8BIT;
		testBusType[2]	= 8;
		testCardCnt		= 3;		
	}
	
	for(testIdx = 0; testIdx < testCardCnt; testIdx++)
	{
		sCardType = testCardType[testIdx];
		HostSetBus(
			testCardType[testIdx],
			testBusType[testIdx]
		);
		
		SDMMCDPRINTF("-------------------------------------------------------------\n");
		SDMMCDPRINTF(" BitWidth test by CPU \n");
		SDMMCDPRINTF("-------------------------------------------------------------\n");
		for(mSector = 1; mSector < 3; mSector++)    
		{
			for(loopCnt = 0; loopCnt < 2; loopCnt++)
			{
				SDMMCDPRINTF("[SDMMC TEST] test SDMMC(bitwidth: %dbits, s:%05d, m:%05d)...\n",
						testBusType[testIdx], loopCnt, mSector);
				MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
				DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_POL);
				
				memset(buffer, 0, sizeof(buffer));
				DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_POL);
				compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
				if(compareResult == false) 
				{
					SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
					return false;
				}
				//HexDump((smtUint32)buffer, 512*3);
			}
		}
		
		SDMMCDPRINTF("-------------------------------------------------------------\n");
		SDMMCDPRINTF(" BitWidth test by interupt \n");
		SDMMCDPRINTF("-------------------------------------------------------------\n");
		for(mSector = 1; mSector < 3; mSector++)    
		{
			for(loopCnt = 0; loopCnt < 2; loopCnt++)
			{
				SDMMCDPRINTF("[SDMMC TEST] test SDMMC(bitwidth: %dbits, s:%05d, m:%05d)...\n",
						testBusType[testIdx], loopCnt, mSector);
				MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
				DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_INT);
				
				memset(buffer, 0, sizeof(buffer));
				DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_INT);
				compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
				if(compareResult == false) 
				{
					SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
					return false;
				}
				//HexDump((smtUint32)buffer, 512*3);
			}
		}
		
		
		SDMMCDPRINTF("-------------------------------------------------------------\n");
		SDMMCDPRINTF(" BitWidth test by DMA \n");
		SDMMCDPRINTF("-------------------------------------------------------------\n");
		for(mSector = 1; mSector < 3; mSector++)    
		{
			for(loopCnt = 0; loopCnt < 2; loopCnt++)
			{
				SDMMCDPRINTF("[SDMMC TEST] test SDMMC(bitwidth: %dbits, s:%05d, m:%05d)...\n",
						testBusType[testIdx], loopCnt, mSector);
				MakePattern(loopCnt, (smtUint32)buffer, 512*mSector);
				DeviceWriteSectors(0, loopCnt, mSector, buffer, SDMMC_TM_DMA);
				
				memset(buffer, 0, sizeof(buffer));
				DeviceReadSectors(0, loopCnt, mSector, buffer, SDMMC_TM_DMA);
				compareResult = CheckPattern(loopCnt, (smtUint32)buffer, 512*mSector);
				if(compareResult == false) 
				{
					SDMMCDPRINTF("[SDMMC TEST] sector(%d) test fail!!!\n", loopCnt);
					return false;
				}
				//HexDump((smtUint32)buffer, 512*3);
			}
		}
		
	}
	
	// 변경하지마시오
	sCardType = prevCardType;
	HostSetBus(prevCardType, prevBusWidth); 
	
	return true;
	
}

/*----------------------------------------------------------
	Function name	:	SDMMCTest
	Prototype		: 
	Return			: 
	Argument		:
	Comments		:
-----------------------------------------------------------*/
smtUint32 SDMMCTest(void)
{
	smtUint32 result;
	
	//-------------------------------------------------------
	// 	0. Found SD/MMC card
	//		- Detect card
	//		- Initialize
	//-------------------------------------------------------
	if(SDMMCIdentify() == -1) 
	{
		SDMMCDPRINTF("[SDMMC TEST]: has no card... insert card\n");
		return !NO_ERROR;
	}
	
	//-------------------------------------------------------
	// 	1. SDMMC read/write
	//		- CPU read/write
	//		- DMA read/write
	//		- interrupt read/write
	//-------------------------------------------------------
	result = SDMMCRWTest();
	if(result == false)
	{
		SDMMCDPRINTF("SDMMCTest::SDMMC read/write test fail!!!\n");
		return !NO_ERROR;
	}
	SDMMCDPRINTF("SDMMCTest::SDMMC read/write test success!!!\n");

	
	//-------------------------------------------------------
	// 	3. SDMMC variable bus test 
	//		- CPU read/write
	//		- DMA read/write
	//		- interrupt read/write
	//-------------------------------------------------------
	result = SDMMCBusTest();
	if(result == false)
	{
		SDMMCDPRINTF("SDMMCTest::SDMMC variable bus test fail!!!\n");
		return !NO_ERROR;
	}
	SDMMCDPRINTF("SDMMCTest::SDMMC variable bus success!!!\n");
	
	//-------------------------------------------------------
	// 	2. SDMMC variable clock test
	//		- CPU read/write
	//		- DMA read/write
	//		- interrupt read/write
	//-------------------------------------------------------
	result = SDMMCClkTest();
	if(result == false)
	{
		SDMMCDPRINTF("SDMMCTest::SDMMC variable clock test fail!!!\n");
		return !NO_ERROR;
	}
	SDMMCDPRINTF("SDMMCTest::SDMMC variable clock success!!!\n");
	
	// print read value
	SDMMCDPRINTF("[SDMMC TEST] end test!!!\n");
	
	return NO_ERROR;
}


	
unsigned int UNSTUFF_BITS(smtUint32 *resp, smtUint32 start, smtUint32 size)
{
	unsigned int __res;
	int __size = size;
	smtUint32  __mask = (__size < 32 ? 1 << __size : 0) - 1;
	int __off = 3 - ((start) / 32);
	int __shft = (start) & 31;		

	__res = resp[__off] >> __shft;

	if (__size + __shft > 32)
		__res |= resp[__off-1] << ((32 - __shft) % 32);
		
	return (unsigned int)(__res & __mask);
}

	
/*
 * Given the decoded CSD structure, decode the raw CID to our CID structure.
 * True - SD, False - MMC
 */
void mmc_decode_cid(void) 
{
	struct mmc_card *card = &card_info;
	smtUint32 *resp = card->raw_cid;

	memset(&card->cid, 0, sizeof(struct mmc_cid));

	if(sCardType==SMT_TRUE)
	{
		/*
		 * SD doesn't currently have a version field so we will
		 * have to assume we can parse this.
		 */
		card->cid.manfid		= UNSTUFF_BITS(resp, 120, 8);
		card->cid.oemid			= UNSTUFF_BITS(resp, 104, 16);
		card->cid.prod_name[0]	= UNSTUFF_BITS(resp, 96, 8);
		card->cid.prod_name[1]	= UNSTUFF_BITS(resp, 88, 8);
		card->cid.prod_name[2]	= UNSTUFF_BITS(resp, 80, 8);
		card->cid.prod_name[3]	= UNSTUFF_BITS(resp, 72, 8);
		card->cid.prod_name[4]	= UNSTUFF_BITS(resp, 64, 8);
		card->cid.hwrev			= UNSTUFF_BITS(resp, 60, 4);
		card->cid.fwrev			= UNSTUFF_BITS(resp, 56, 4);
		card->cid.serial		= UNSTUFF_BITS(resp, 24, 32);
		card->cid.year			= UNSTUFF_BITS(resp, 12, 8);
		card->cid.month			= UNSTUFF_BITS(resp, 8, 4);

		card->cid.year += 2000; /* SD cards year offset */
	} 	
	else 
	{
		/*
		 * The selection of the format here is based upon published
		 * specs from sandisk and from what people have reported.
		 */
		switch (card->csd.mmca_vsn) 
		{
			case 0: /* MMC v1.0 - v1.2 */
			case 1: /* MMC v1.4 */
				card->cid.manfid		= UNSTUFF_BITS(resp, 104, 24);
				card->cid.prod_name[0]	= UNSTUFF_BITS(resp, 96, 8);
				card->cid.prod_name[1]	= UNSTUFF_BITS(resp, 88, 8);
				card->cid.prod_name[2]	= UNSTUFF_BITS(resp, 80, 8);
				card->cid.prod_name[3]	= UNSTUFF_BITS(resp, 72, 8);
				card->cid.prod_name[4]	= UNSTUFF_BITS(resp, 64, 8);
				card->cid.prod_name[5]	= UNSTUFF_BITS(resp, 56, 8);
				card->cid.prod_name[6]	= UNSTUFF_BITS(resp, 48, 8);
				card->cid.hwrev			= UNSTUFF_BITS(resp, 44, 4);
				card->cid.fwrev			= UNSTUFF_BITS(resp, 40, 4);
				card->cid.serial		= UNSTUFF_BITS(resp, 16, 24);
				card->cid.month			= UNSTUFF_BITS(resp, 12, 4);
				card->cid.year			= UNSTUFF_BITS(resp, 8, 4) + 1997;
				break;

			case 2: /* MMC v2.0 - v2.2 */
			case 3: /* MMC v3.1 - v3.3 */
			case 4: /* MMC v4 */
				card->cid.manfid		= UNSTUFF_BITS(resp, 120, 8);
				card->cid.oemid			= UNSTUFF_BITS(resp, 104, 16);
				card->cid.prod_name[0]	= UNSTUFF_BITS(resp, 96, 8);
				card->cid.prod_name[1]	= UNSTUFF_BITS(resp, 88, 8);
				card->cid.prod_name[2]	= UNSTUFF_BITS(resp, 80, 8);
				card->cid.prod_name[3]	= UNSTUFF_BITS(resp, 72, 8);
				card->cid.prod_name[4]	= UNSTUFF_BITS(resp, 64, 8);
				card->cid.prod_name[5]	= UNSTUFF_BITS(resp, 56, 8);
				card->cid.serial		= UNSTUFF_BITS(resp, 16, 32);
				card->cid.month			= UNSTUFF_BITS(resp, 12, 4);
				card->cid.year			= UNSTUFF_BITS(resp, 8, 4) + 1997;
				break;

			default:
				SDMMCDPRINTF("card has unknown MMCA version %d\n");
				break;
		}
	}
}

/*
 * Given a 128-bit response, decode to our card CSD structure.
 */
smtUint32 mmc_decode_csd(void)
{
	struct mmc_card *card = &card_info;
	struct mmc_csd *csd = &card->csd;
	unsigned int e, m, csd_struct;
	smtUint32 *resp = card->raw_csd;

	if(sCardType==SMT_TRUE)
	{
		csd_struct = UNSTUFF_BITS(resp, 126, 2);
 
 		switch (csd_struct) {
 		case 0:
 			m = UNSTUFF_BITS(resp, 115, 4);
 			e = UNSTUFF_BITS(resp, 112, 3);
 			csd->tacc_ns	 = (tacc_exp[e] * tacc_mant[m] + 9) / 10;
 			csd->tacc_clks	 = UNSTUFF_BITS(resp, 104, 8) * 100;
 	
 			m = UNSTUFF_BITS(resp, 99, 4);
 			e = UNSTUFF_BITS(resp, 96, 3);
 			csd->max_dtr	  = tran_exp[e] * tran_mant[m];
 			csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);
 	
 			e = UNSTUFF_BITS(resp, 47, 3);
 			m = UNSTUFF_BITS(resp, 62, 12);
 			csd->capacity	  = (1 + m) << (e + 2);
 	
 			csd->read_blkbits = UNSTUFF_BITS(resp, 80, 4);
 			csd->read_partial = UNSTUFF_BITS(resp, 79, 1);
 			csd->write_misalign = UNSTUFF_BITS(resp, 78, 1);
 			csd->read_misalign = UNSTUFF_BITS(resp, 77, 1);
 			csd->r2w_factor = UNSTUFF_BITS(resp, 26, 3);
 			csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
 			csd->write_partial = UNSTUFF_BITS(resp, 21, 1);
 			break;
 		case 1:
 			/*
 			 * This is a block-addressed SDHC card. Most
 			 * interesting fields are unused and have fixed
 			 * values. To avoid getting tripped by buggy cards,
 			 * we assume those fixed values ourselves.
 			 */

			//TODO:
 			//mmc_card_set_blockaddr(card);
 
 			csd->tacc_ns	 = 0; /* Unused */
 			csd->tacc_clks	 = 0; /* Unused */
 	
 			m = UNSTUFF_BITS(resp, 99, 4);
 			e = UNSTUFF_BITS(resp, 96, 3);
 			csd->max_dtr	  = tran_exp[e] * tran_mant[m];
 			csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);
 	
 			m = UNSTUFF_BITS(resp, 48, 22);
 			csd->capacity     = (1 + m) << 10;
 	
 			csd->read_blkbits = 9;
 			csd->read_partial = 0;
 			csd->write_misalign = 0;
 			csd->read_misalign = 0;
 			csd->r2w_factor = 4; /* Unused */
 			csd->write_blkbits = 9;
 			csd->write_partial = 0;
 			break;
 		default:
 			SDMMCDPRINTF("Unrecognised CSD structure version %d\n", csd_struct);
			break;
			
 		}

		csd->capacity = csd->capacity * (1<<(csd->read_blkbits));
	
	} 
	else 
	{
		/*
		 * We only understand CSD structure v1.1 and v1.2.
		 * v1.2 has extra information in bits 15, 11 and 10.
		 */
		csd_struct = UNSTUFF_BITS(resp, 126, 2);
		if (csd_struct != 1 && csd_struct != 2) 
		{
			SDMMCDPRINTF("unrecognised CSD structure version %d\n");
			return;
		}

		csd->mmca_vsn	 = UNSTUFF_BITS(resp, 122, 4);
		m = UNSTUFF_BITS(resp, 115, 4);
		e = UNSTUFF_BITS(resp, 112, 3);
		csd->tacc_ns	 = (tacc_exp[e] * tacc_mant[m] + 9) / 10;
		csd->tacc_clks	 = UNSTUFF_BITS(resp, 104, 8) * 100;

		m = UNSTUFF_BITS(resp, 99, 4);
		e = UNSTUFF_BITS(resp, 96, 3);
		csd->max_dtr	  = tran_exp[e] * tran_mant[m];
		csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);

		e = UNSTUFF_BITS(resp, 47, 3);
		m = UNSTUFF_BITS(resp, 62, 12);
		csd->capacity	  = (1 + m) << (e + 2);

		csd->read_blkbits = UNSTUFF_BITS(resp, 80, 4);
		csd->read_partial = UNSTUFF_BITS(resp, 79, 1);
		csd->write_misalign = UNSTUFF_BITS(resp, 78, 1);
		csd->read_misalign = UNSTUFF_BITS(resp, 77, 1);
		csd->r2w_factor = UNSTUFF_BITS(resp, 26, 3);
		csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
		csd->write_partial = UNSTUFF_BITS(resp, 21, 1);
	}
	
	return csd->capacity;
}

/*
 * Given a 64-bit response, decode to our card SCR structure.
 */
void mmc_decode_scr(void)
{
	struct mmc_card *card = &card_info;
	struct sd_scr *scr = &card->scr;
	smtUint32 scr_struct;
	smtUint32 resp[4];

	resp[3] = card->raw_scr[1];
	resp[2] = card->raw_scr[0];

	scr_struct = UNSTUFF_BITS(resp, 60, 4);
	if (scr_struct != 0) {
		SDMMCDPRINTF("unrecognised SCR structure version %d\n");
		return;
	}

	scr->sda_vsn = UNSTUFF_BITS(resp, 56, 4);
	scr->bus_widths = UNSTUFF_BITS(resp, 48, 4);
}


void print_sd_information(void)
{
	struct mmc_card *card = &card_info;
	struct mmc_csd *csd = &card->csd;
	struct mmc_cid  *cid = &card->cid;

	SDMMCDPRINTF("Manufacture	= 0x%02X\n", cid->manfid);
	SDMMCDPRINTF("Product Name	= %s\n", cid->prod_name);
	SDMMCDPRINTF("Serial Number	= 0x%08X\n", cid->serial);
	SDMMCDPRINTF("Capacity        = 0x%08X(%dMByte)\n",csd->capacity, ((csd->capacity/1024)/1024));
	
}

