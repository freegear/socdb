/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: sdmmc_post_drv.c
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/


/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include <stdio.h>
//#include "../../../api/filesystem/sw_fs_typedefs.h"
#include "sw_fs_typedefs.h"
#include "sdmmc_pre_drv.h"
#include "sdmmc_post_drv.h"
#include "commonmacro.h"
#include "lib.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	normal command
-----------------------------------------------------------*/
#define	SDMMC_GO_IDLE_STATE			(0 )
#define	SDMMC_SEND_CID				(2 )
#define	SDMMC_SEND_RELATIVE_ADDR	(3 )
#define	SDMMC_SELECT				(7 )
#define	SDMMC_APP_CMD				(55)
#define	SDMMC_READ_MULTIPLE_BLOCK	(18)
#define	SDMMC_WRITE_MULTIPLE_BLOCK	(25)
#define	SDMMC_STOP_TRANSMISSION		(12)
/*----------------------------------------------------------
	application command
-----------------------------------------------------------*/
#define	SDMMC_SET_BUS_WIDTH			(6)
#define	SDMMC_SD_SEND_OP_COND		(41)
#define	SDMMC_SET_CLR_CARD_DETECT	(42)
/*----------------------------------------------------------
	wait type
-----------------------------------------------------------*/
#define	SDMMC_WAIT_CMDSENT			(0)
#define	SDMMC_WAIT_RSPFIN			(1)
#define	SDMMC_WAIT_TXDATFIN			(2)
#define	SDMMC_WAIT_RXDATFIN			(4)
#define	SDMMC_WAIT_BUSYFIN			(5)
/*----------------------------------------------------------
	etc
-----------------------------------------------------------*/
#define SDMMC_MAX_RETRY 			(100)
#define	SDMMC_DBGPrintf				printf
/*/////////////////////////////////////////////////////////
        VARIABLE
///////////////////////////////////////////////////////////*/
static smtUint16 	identify_info[512];
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////*/
/*----------------------------------------------------------
	SDMMCWait
-----------------------------------------------------------*/
static smtUint32 SDMMCWait(smtUint32 waitIdx, smtUint32 cmdIdx)
{
	smtInt32		count = 0x7FFFF;
	SDMMC_CMD_STA	sdmmcCmdStatus;
	SDMMC_DAT_STA	sdmmcDatStatus;
	
	
	while(1) {
		
		switch(waitIdx) 
		{
			case SDMMC_WAIT_CMDSENT:

				smtSDMMCCmdGetStatus(&sdmmcCmdStatus);
				if(sdmmcCmdStatus.CmdSent) 
				{
					smtSDMMCCmdSetStatus(&sdmmcCmdStatus);
					return 0;
				}
		
				if(sdmmcCmdStatus.CmdTout) 
				{
					smtSDMMCCmdSetStatus(&sdmmcCmdStatus);
					return 1;
				}			
				break;	
				
			
			case SDMMC_WAIT_RSPFIN:
				
				smtSDMMCCmdGetStatus(&sdmmcCmdStatus);
				if(sdmmcCmdStatus.RspFin) 
				{
					smtSDMMCCmdSetStatus(&sdmmcCmdStatus);
					return 0;
				}
				
				if(sdmmcCmdStatus.CmdTout) 
				{
					smtSDMMCCmdSetStatus(&sdmmcCmdStatus);
					return 1;
				}		
				break;
				
				
			case SDMMC_WAIT_TXDATFIN:
				
				smtSDMMCGetStatus(&sdmmcDatStatus);
				if(sdmmcDatStatus.DatFin
				&&(!sdmmcDatStatus.RxDatOn)) 
				{
					return 0;
				}				
				
				if(sdmmcDatStatus.DatTOut) 
				{	
					smtSDMMCSetStatus(&sdmmcDatStatus);
					return 1;
				}
				
			case SDMMC_WAIT_RXDATFIN:
				
				smtSDMMCGetStatus(&sdmmcDatStatus);
				if(sdmmcDatStatus.DatFin
				&&(!sdmmcDatStatus.TxDatOn)) 
				{
					return 0;
				}				
				
				if(sdmmcDatStatus.DatTOut) 
				{	
					smtSDMMCSetStatus(&sdmmcDatStatus);
					return 1;
				}
				break;
				
			case SDMMC_WAIT_BUSYFIN:
				
				smtSDMMCGetStatus(&sdmmcDatStatus);
				if(sdmmcDatStatus.BusyFin) {
					smtSDMMCSetStatus(&sdmmcDatStatus);
					return 0;
				}
		
				if(sdmmcDatStatus.DatTOut) {
					smtSDMMCSetStatus(&sdmmcDatStatus);
					return 1;
				}
				break;
		}
		
		if(!count--) {
			return 2;
		}		
		
	}
}
/*----------------------------------------------------------
	smt2SDMMCSpinDown
-----------------------------------------------------------*/
void smt2SDMMCSpinDown(smtInt32 seconds)
{

    // no operation
}
/*----------------------------------------------------------
	smt2SDMMCSleep
-----------------------------------------------------------*/
void smt2SDMMCSleep(void)
{
	// no operation
}
/*----------------------------------------------------------
	smt2SDMMCSpin
-----------------------------------------------------------*/
void smt2SDMMCSpin(void)
{
	// no operation
}
/*----------------------------------------------------------
	smt2SDMMCEnable
-----------------------------------------------------------*/
void smt2SDMMCEnable(smtBoolean on)
{
	smtSDMMCTopEnableClk(on);
}
/*----------------------------------------------------------
	smt2SDMMCHardReset
-----------------------------------------------------------*/
smtInt32 smt2SDMMCHardReset(void)
{
	SDMMC_INT_ENABLE	sdmmcIntEnb;
	SDMMC_INT_STA		sdmmcStatus;
	
	// disable clock
	smt2SDMMCEnable(0);
	
	
	// set clock
	smtSDMMCTopSetPreScaler(0xFF);	
	smtSDMMCDatSetTimer(0xFFFFFFFF);
	
	
	// interrupt enable
	smtSDMMCIntGetStatus(&sdmmcStatus);
	smtSDMMCIntSetStatus(&sdmmcStatus);
	memset(&sdmmcIntEnb, 0, sizeof(SDMMC_INT_ENABLE));	
	smtSDMMCIntSet(&sdmmcIntEnb);
	
	// SD/MMC on
	smtSDMMCTopReset();
	
	return 0;    
}
/*----------------------------------------------------------
	smt2SDMMCSoftReset
-----------------------------------------------------------*/
smtInt32 smt2SDMMCSoftReset(void)
{

	SDMMC_INT_ENABLE	sdmmcIntEnb;
	SDMMC_INT_STA		sdmmcStatus;
	
	// disable clock
	smt2SDMMCEnable(0);
	
	
	// set clock
	smtSDMMCTopSetPreScaler(0xFF);	
	smtSDMMCDatSetTimer(0xFFFFFFFF);
	
	
	// interrupt enable
	smtSDMMCIntGetStatus(&sdmmcStatus);
	smtSDMMCIntSetStatus(&sdmmcStatus);
	memset(&sdmmcIntEnb, 0, sizeof(SDMMC_INT_ENABLE));	
	smtSDMMCIntSet(&sdmmcIntEnb);
	
	// SD/MMC on
	smtSDMMCTopReset();
		
    return 0;
}
/*----------------------------------------------------------
	smt2SDMMCGetIdentify
-----------------------------------------------------------*/
smtUint16* smt2SDMMCGetIdentify(void)
{
    return identify_info;
}
/*----------------------------------------------------------
	smt2SDMMCPowerOff
-----------------------------------------------------------*/
void smt2SDMMCPowerOff(smtBoolean enable)
{
	// no operation

}
/*----------------------------------------------------------
	smt2SDMMCActive
-----------------------------------------------------------*/
smtBoolean smt2SDMMCActive(void)
{

	
	return 0;
	
}
/*----------------------------------------------------------
	SDMMCDectectCard
-----------------------------------------------------------*/
smtInt32 smt2SDMMCInit(void)
{
	SDMMC_INT_ENABLE	sdmmcIntEnb;
	SDMMC_INT_STA		sdmmcStatus;
	SDMMC_CMD_CTRL		sdmmcCtrl;
	SDMMC_CMD_RSP		sdmmcRsp;
	smtUint32		result;
	smtUint32		retryCount	= 0x0;
	smtUint32		ACMD41Arg  	= 0x0;
	smtUint32 		RCA;
	
	//-------------------------------------------------------
	// SD/MMC init
	//-------------------------------------------------------
	
	SDMMC_DBGPrintf("%s:%s  !!!\n",
					"SDMMCDectectCard", 
					"SD/MMC init");
	
	
	smt2SDMMCHardReset();
	smt2SDMMCEnable(1);
	
	//-------------------------------------------------------
	//	Send commond GO_IDLE_STATE: CMD0(--)
	//-------------------------------------------------------
	retryCount = 0;
SDMMC_CMD0_RETRY:
	
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCDectectCard", 
						"GO_IDLE_STATE");
		return -1;
	}
			
	SDMMC_DBGPrintf("%s:%s  !!!\n",
					"SDMMCDectectCard", 
					"GO_IDLE_STATE");
	
	// send command
	smtSDMMCCmdSet(0x0);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_GO_IDLE_STATE;
	smtSDMMCCmdSetCtrl(sdmmcCtrl);	
	
	// wait command sent
	result	= SDMMCWait(SDMMC_WAIT_CMDSENT, SDMMC_GO_IDLE_STATE);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - GO_IDLE_STATE FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"GO_IDLE_STATE",
					retryCount);
					
		goto SDMMC_CMD0_RETRY;
	}
	

	//-------------------------------------------------------
	//	Send command SD_SEND_OP_COND CMD55/ACMD41(R3)
	//-------------------------------------------------------
	retryCount = 0;
SDMMC_ACMD41_RETRY:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCDectectCard", 
						"SD_SEND_OP_COND");
		return -2;
	}
	
	SDMMC_DBGPrintf("%s:%s !!!\n",
					"SDMMCDectectCard", 
					"SD_SEND_OP_COND");	
	
	
	// send command
	smtSDMMCCmdSet(0x0);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_APP_CMD;	
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		

	// wait reponse
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_APP_CMD);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - CMD55 FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"SD_SEND_OP_COND",
					retryCount);
					
		goto SDMMC_ACMD41_RETRY;
	}	
	

		
	// send command
	smtSDMMCCmdSet(ACMD41Arg);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	sdmmcCtrl.noCRCRsp	= 1;
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_SD_SEND_OP_COND;	
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		

	// wait reponse
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, 
				SDMMC_APP_CMD|SDMMC_SD_SEND_OP_COND);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - ACMD41 FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"SD_SEND_OP_COND",
					retryCount);
					
		goto SDMMC_ACMD41_RETRY;
	}	
	
	// get response
	smtSDMMCGetResponse(&sdmmcRsp);	
	
	SDMMC_DBGPrintf("%s:%s - OCR 0x%08X!!!\n",
					"SDMMCDectectCard", 
					"SD_SEND_OP_COND",
					sdmmcRsp.response0);
	
	
	// check SD busy status
	if(!(sdmmcRsp.response0&(1<<31))) 
	{
		ACMD41Arg = sdmmcRsp.response0;
		goto SDMMC_ACMD41_RETRY;
	}
			
	// check SD power status
	if(!(sdmmcRsp.response0&0x80)) 
	{
		SDMMC_DBGPrintf("%s:%s - High voltage!!!\n",
					"SDMMCDectectCard", 
					"SD_SEND_OP_COND",
					sdmmcRsp.response0);
	}
	else
	{
		SDMMC_DBGPrintf("%s:%s - Dual voltage!!!\n",
					"SDMMCDectectCard", 
					"SD_SEND_OP_COND",
					sdmmcRsp.response0);
	}	
	
	
	//-------------------------------------------------------
	// Send command ALL_SEND_CID CMD2(R2)
	//-------------------------------------------------------
	retryCount = 0;
SDMMC_CMD2_RETRY:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCDectectCard", 
						"ALL_SEND_CID");
		return -3;
	}
		
	SDMMC_DBGPrintf("%s:%s  !!!\n",
					"SDMMCDectectCard", 
					"ALL_SEND_CID");		
		
	
	// send command	
	smtSDMMCCmdSet(0x0);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	sdmmcCtrl.noCRCRsp	= 1;
	sdmmcCtrl.LongRsp	= 1;
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_SEND_CID;	
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_SEND_CID);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - CMD2 FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"ALL_SEND_CID",
					retryCount);
					
		goto SDMMC_CMD2_RETRY;
	}	
	
	// get response
	smtSDMMCGetResponse(&sdmmcRsp);		

		
	//-------------------------------------------------------
	// Send command SEND_RELATIVE_ADDR CMD3(R6)
	//-------------------------------------------------------
	retryCount = 0;
SDMMC_CMD3_RETRY:				
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCDectectCard", 
						"SEND_RELATIVE_ADDR");
		return -4;
	}	
	
	
	SDMMC_DBGPrintf("%s:%s !!!\n",
					"SDMMCDectectCard", 
					"SEND_RELATIVE_ADDR");		
	
	
	// send command
	smtSDMMCCmdSet(0x0);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));	
	sdmmcCtrl.noCRCRsp	= 1;
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_SEND_RELATIVE_ADDR;		
	smtSDMMCCmdSetCtrl(sdmmcCtrl);			
	
	// wait reponse
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_SEND_RELATIVE_ADDR);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - SEND_RELATIVE_ADDR FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"SEND_RELATIVE_ADDR",
					retryCount);
					
		goto SDMMC_CMD3_RETRY;
	}	
	
	// get response
	smtSDMMCGetResponse(&sdmmcRsp);		
	RCA = sdmmcRsp.response0;
	SDMMC_DBGPrintf("%s:%s - RCA:0x%08X!!!\n",
					"SDMMCDectectCard", 
					"SEND_RELATIVE_ADDR",
					RCA);
	//-------------------------------------------------------
	// Send command SELECT CMD7(R1bsd)
	//-------------------------------------------------------
	retryCount = 0;
SDMMC_CMD7_RETRY:				
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCDectectCard", 
						"SELECT");
		return -4;
	}	
	
	
	SDMMC_DBGPrintf("%s:%s !!!\n",
					"SDMMCDectectCard", 
					"SELECT");		
	
	

	// send command	
	smtSDMMCCmdSet(RCA);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));	
	sdmmcCtrl.noCRCRsp	= 1;
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_SELECT;		
	smtSDMMCCmdSetCtrl(sdmmcCtrl);			
	
	// wait reponse
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_SELECT);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - SEND_RELATIVE_ADDR FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"SELECT",
					retryCount);
					
		goto SDMMC_CMD7_RETRY;
	}	
	
	//-------------------------------------------------------
	//	Send command SET_CLR_CARD_DETECT CMD55/ACMD42(R1)
	//-------------------------------------------------------
	retryCount = 0;
SDMMC_ACMD42_RETRY:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCDectectCard", 
						"SET_CLR_CARD_DETECT");
		return -2;
	}
	
	SDMMC_DBGPrintf("%s:%s !!!\n",
					"SDMMCDectectCard", 
					"SET_CLR_CARD_DETECT");	
	
	
	// send command
	smtSDMMCCmdSet(RCA);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));		
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_APP_CMD;	
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_APP_CMD);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - CMD55 FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"SET_CLR_CARD_DETECT",
					retryCount);
					
		goto SDMMC_ACMD42_RETRY;
	}	
	
	smtSDMMCGetResponse(&sdmmcRsp);
	
	
		
	// send command
	smtSDMMCCmdSet(0x0);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));		
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_SET_CLR_CARD_DETECT;	
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_SET_CLR_CARD_DETECT);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - ACMD41 FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"SD_SEND_OP_COND",
					retryCount);
					
		goto SDMMC_ACMD42_RETRY;
	}	
	

	smtSDMMCGetResponse(&sdmmcRsp);	
	
	//-------------------------------------------------------
	//	Send command SET_BUS_WIDTH CMD55/ACMD6(R1)
	//-------------------------------------------------------
	retryCount = 0;
SDMMC_ACMD6_RETRY:
	if(retryCount++ > SDMMC_MAX_RETRY) {
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCDectectCard", 
						"SET_BUS_WIDTH");
		return -2;
	}
	
	SDMMC_DBGPrintf("%s:%s !!!\n",
					"SDMMCDectectCard", 
					"SET_BUS_WIDTH");	
	
	
	// set parameter
	smtSDMMCCmdSet(RCA);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));		
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_APP_CMD;	
	
	// send command
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	//result = SDMMCWaitResponse();
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_APP_CMD);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - CMD55 FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"SET_BUS_WIDTH",
					retryCount);
					
		goto SDMMC_ACMD6_RETRY;
	}	
	
	smtSDMMCGetResponse(&sdmmcRsp);
	
	
		
	// set parameter
	smtSDMMCCmdSet(0x2);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));		
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_SET_BUS_WIDTH;	
	
	// send command
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	//result = SDMMCWaitResponse();
	result	= SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_SET_BUS_WIDTH);
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - ACMD42 FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"SET_BUS_WIDTH",
					retryCount);
					
		goto SDMMC_ACMD6_RETRY;
	}	
	

	smtSDMMCGetResponse(&sdmmcRsp);	
			
		
			
	
	// set clock
	smtSDMMCTopSetPreScaler(0x2);	
	
	SDMMC_DBGPrintf("End Detect card!!!\n");
	
}
/*----------------------------------------------------------
	smt2SDMMCReadSectors
-----------------------------------------------------------*/
smtInt32 smt2SDMMCReadSectors(smtInt32 drive,smtUint32 sector,  
							smtUint32 count, void *target)
{
	
	smtInt32 retryCount =0x30;

	SDMMC_CMD_CTRL	sdmmcCtrl;	
	SDMMC_DAT_CTRL	sdmmcDatCtrl;
	SDMMC_FIFO_STA	sdmmcFIFOStatus;
	smtUint32	result;

	retryCount = 0;
SDMMC_CMD18:
	if(retryCount++ > SDMMC_MAX_RETRY) 
	{
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCSRead", 
						"READ_MULTIPLE_BLOCK");
		return -1;
	}
		
	//-------------------------------------------------------
	// Block size & FIFO reset
	//-------------------------------------------------------
	smtSDMMCDatSetDBSize(512-1);
	smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
	sdmmcFIFOStatus.Reset = 1;
	smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);
	
	//-------------------------------------------------------
	//	Set Data control config
	//-------------------------------------------------------
	{	

		sdmmcDatCtrl.DMASize		= 0x08;
		sdmmcDatCtrl.MMCPlus		= 0;
		sdmmcDatCtrl.TARSP			= 1;
		sdmmcDatCtrl.RACMD			= 1;
		sdmmcDatCtrl.ByteOrder		= 0;
		sdmmcDatCtrl.BlkMode		= 1;
		sdmmcDatCtrl.WideBusEnable	= 1;
		sdmmcDatCtrl.DMAEnable		= 1;
		sdmmcDatCtrl.TransStart		= 1;
		sdmmcDatCtrl.TransMode		= 2;
		sdmmcDatCtrl.BlkNum			= (count-1);
		smtSDMMCDatSetCtrl(&sdmmcDatCtrl);		

	}

	
	//-------------------------------------------------------
	// Send command CMD18 
	//
	//			continuously transfers data blocks from
	//			card to host until interrupted by a
	//			STOP_TRANSMISSION command.
	//-------------------------------------------------------

		
	// set parameter
	smtSDMMCCmdSet(sector*512);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_READ_MULTIPLE_BLOCK;	
	
	// send command
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	result = SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_READ_MULTIPLE_BLOCK);	
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - READ_MULTIPLE_BLOCK FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"READ_MULTIPLE_BLOCK",
					retryCount);
					
		smtSDMMCDatSetDBSize(512-1);
		smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
		sdmmcFIFOStatus.Reset = 1;
		smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);					
					
		goto SDMMC_CMD18;
	}
	
	
	
	//-------------------------------------------------------
	// DMA non descriptor
	//-------------------------------------------------------
	smtDMACNoDescrp(
		0, 								// [CH ]: Using DMA channel
		(MMC_BASEADDR+0x44), 			// [SRC]: Source address
		0,			 					// [SRC]: Non increament
		0x2, 							// [SRC]: Word data width 
		(smtUint32) target, 			// [TRG]: Target address
		0x1, 							// [TRG]: auto increamnet
		0x2, 							// [TRG]: Word data width
		0x5, 							// [BS ]: Burst size
		count*512						// [LEN]: Total transfered size
	);
	
	
	//
	// wait DMA end
	//
	while(1) 
	{
		if(SMT_READ(DMACSta(0))&0x08) 
		{
			UART_printf("wait DMA end!!!\n");
			break;
		}
	}
	SMT_WRITE(DMACSta(0), SMT_READ(DMACSta(0))&(~0x08));
	//-------------------------------------------------------
	// wait data finish and wait not progress RX
	//-------------------------------------------------------
	result = SDMMCWait(SDMMC_WAIT_RXDATFIN, SDMMC_STOP_TRANSMISSION);	
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - Data finish FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"STOP_TRANSMISSION",
					retryCount);
					
		smtSDMMCDatSetDBSize(512-1);
		smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
		sdmmcFIFOStatus.Reset = 1;
		smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);					
					
		goto SDMMC_CMD18;
	}	
		
	//-------------------------------------------------------
	//	SDMMC_CMD12
	//-------------------------------------------------------
	
	// send command
	smtSDMMCCmdSet(0x0);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	sdmmcCtrl.BusyRsp	= 1;	
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_STOP_TRANSMISSION;		
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	result = SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_STOP_TRANSMISSION);	
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - command end FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"STOP_TRANSMISSION",
					retryCount);
					
		smtSDMMCDatSetDBSize(512-1);
		smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
		sdmmcFIFOStatus.Reset = 1;
		smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);					
					
		goto SDMMC_CMD18;
	}
		


	
	return 0;

}
/*----------------------------------------------------------
	smt2SDMMCWriteSectors
-----------------------------------------------------------*/
smtInt32 smt2SDMMCWriteSectors(smtInt32	drive, smtUint32 sector, 
							smtUint32 count, void *source)
{
	
	smtInt32 retryCount =0x30;

	SDMMC_CMD_CTRL	sdmmcCtrl;	
	SDMMC_DAT_CTRL	sdmmcDatCtrl;
	SDMMC_FIFO_STA	sdmmcFIFOStatus;
	smtUint32	result;


	retryCount = 0;
SDMMC_CMD25:
	if(retryCount++ > SDMMC_MAX_RETRY)
	{
		
		SDMMC_DBGPrintf("%s:%s - over max retry!!!\n", 
						"SDMMCSRead", 
						"WRITE_MULTIPLE_BLOCK");
		return -1;
	}
	
	//-------------------------------------------------------
	// Block size & FIFO reset
	//-------------------------------------------------------
	smtSDMMCDatSetDBSize(512-1);
	smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
	sdmmcFIFOStatus.Reset = 1;
	smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);
	
	//-------------------------------------------------------
	//	Set Data control config
	//-------------------------------------------------------
	{	

		sdmmcDatCtrl.DMASize		= 0x08;
		sdmmcDatCtrl.MMCPlus		= 0x0;
		sdmmcDatCtrl.TARSP			= 0x1;
		sdmmcDatCtrl.RACMD			= 0x1;
		sdmmcDatCtrl.ByteOrder		= 0x0;
		sdmmcDatCtrl.BlkMode		= 0x1;
		sdmmcDatCtrl.WideBusEnable	= 0x1;
		sdmmcDatCtrl.DMAEnable		= 0x1;
		sdmmcDatCtrl.TransStart		= 0x1;
		sdmmcDatCtrl.TransMode		= 0x3;
		sdmmcDatCtrl.BlkNum			= (count-1);
		smtSDMMCDatSetCtrl(&sdmmcDatCtrl);		

	}

	
	//-------------------------------------------------------
	// Send command CMD25
	//
	//			continuously transfers data blocks from
	//			card to host until interrupted by a
	//			STOP_TRANSMISSION command.
	//-------------------------------------------------------

		 
		
	// send command
	smtSDMMCCmdSet(sector*512);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_WRITE_MULTIPLE_BLOCK;	
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	result = SDMMCWait(SDMMC_WAIT_RSPFIN, SDMMC_WRITE_MULTIPLE_BLOCK);	
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - READ_MULTIPLE_BLOCK FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"WRITE_MULTIPLE_BLOCK",
					retryCount);
					
		smtSDMMCDatSetDBSize(512-1);
		smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
		sdmmcFIFOStatus.Reset = 1;
		smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);					
					
		goto SDMMC_CMD25;
	}
	
	
	
	//-------------------------------------------------------
	// DMA non descriptor
	//-------------------------------------------------------
	smtDMACNoDescrp(
		0, 								// [CH ]: Using DMA channel
		(smtUint32)source,  			// [SRC]: Source address
		0x1,			 				// [SRC]: Non increament
		0x2, 							// [SRC]: Word data width 
		(MMC_BASEADDR+0x44), 			// [TRG]: Target address
		0X0, 							// [TRG]: auto increamnet
		0x2, 							// [TRG]: Word data width
		0x5, 							// [BS ]: Burst size
		count*512						// [LEN]: Total transfered size
	);
	
	
	//
	// wait DMA end
	//
	while(1) 
	{
		if(SMT_READ(DMACSta(0))&0x08) 
		{
			UART_printf("wait DMA end!!!\n");
			break;
		}
	}
	
	SMT_WRITE(DMACSta(0), SMT_READ(DMACSta(0))&(~0x08));
	
	//result = SDMMCWaitDataFin0();
	result = SDMMCWait(SDMMC_WAIT_TXDATFIN, SDMMC_WRITE_MULTIPLE_BLOCK);	
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - Data Fin FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"STOP_TRANSMISSION",
					retryCount);
					
		smtSDMMCDatSetDBSize(512-1);
		smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
		sdmmcFIFOStatus.Reset = 1;
		smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);					
					
		goto SDMMC_CMD25;
	}	

	//-------------------------------------------------------
	//	SDMMC_CMD12
	//-------------------------------------------------------

	// send command
	smtSDMMCCmdSet(0x0);
	memset(&sdmmcCtrl, 0, sizeof(sdmmcCtrl));
	sdmmcCtrl.BusyRsp	= 1;
	sdmmcCtrl.WaitRsp	= 1;
	sdmmcCtrl.CmdStart	= 1;
	sdmmcCtrl.CmdIdx	= 0x40|SDMMC_STOP_TRANSMISSION;		
	smtSDMMCCmdSetCtrl(sdmmcCtrl);		
	
	// wait reponse
	result = SDMMCWait(SDMMC_WAIT_BUSYFIN, SDMMC_STOP_TRANSMISSION);	
	if(result) 
	{
		
		SDMMC_DBGPrintf("%s:%s - command end FAIL %d!!!\n",
					"SDMMCDectectCard", 
					"STOP_TRANSMISSION",
					retryCount);
					
		smtSDMMCDatSetDBSize(512-1);
		smtSDMMCFIFOGetStatus(&sdmmcFIFOStatus);
		sdmmcFIFOStatus.Reset = 1;
		smtSDMMCFIFOSetStatus(&sdmmcFIFOStatus);					
					
		goto SDMMC_CMD25;
	}
		

	
	return 0;

}       


/*----------------------------------------------------------
	ATAGetSDMMCFunction
-----------------------------------------------------------*/
ATAFunction* ATAGetSDMMCFunction(void)
{
	
	static ATAFunction function;
	
	function.ATAEnable 			= smt2SDMMCEnable;
	function.ATASpinDown 		= smt2SDMMCSpinDown;
	function.ATAPowerOff 		= smt2SDMMCPowerOff;
	function.ATASleep 			= smt2SDMMCSleep;
	function.ATADiskIsActive 	= smt2SDMMCActive;
	function.ATAHardReset 		= smt2SDMMCHardReset;
	function.ATASoftReset 		= smt2SDMMCSoftReset;
	function.ATAInit 			= smt2SDMMCInit;
	function.ATAReadSectors 	= smt2SDMMCReadSectors;
	function.ATAWriteSectors 	= smt2SDMMCWriteSectors;
	function.ATASpin 			= smt2SDMMCSpin;
	function.ATAGetIdentify 	= smt2SDMMCGetIdentify;
	
	return &function;
}

