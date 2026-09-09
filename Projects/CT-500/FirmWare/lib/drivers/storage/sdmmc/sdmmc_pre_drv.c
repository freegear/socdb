/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: sdmmc_pre_drv.c
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sdmmc_pre_drv.h"
#include "commonmacro.h"

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/

/*----------------------------------------------------------
	SD/MMC host controller
	
	# top function
		- smtSDMMCTopReset	
	
	# clock functions  
		- smtSDMMCTopEnableClk
		- smtSDMMCTopSetPreScaler/smtSDMMCTopGetPreScaler
	
	# command function
		- smtSDMMCCmdSet/smtSDMMCCmdGet
		- smtSDMMCCmdSetCtrl/smtSDMMCCmdGetCtrl
		- smtSDMMCCmdGetResponse
		- smtSDMMCCmdSetStatus/smtSDMMCCmdGetStatus
	
	currently not implemented 
	{
		- smtSDMMCAutoReadSetCtrl/smtSDMMCAutoReadGetCtrl
		- smtSDMMCAutoReadSetStatus/smtSDMMCAutoReadGetStatus
		- smtSDMMCAutoReadGetResponse
	}
	
	
	# data function
		- smtSDMMCDatSetCtrl/smtSDMMCDatGetCtrl
		- smtSDMMCDatSetDBSize/smtSDMMCDatGetDBSize
		- smtSDMMCDatSetTimer/smtSDMMCDatGetTimer
		- smtSDMMCDatGetCnt
		- smtSDMMCDatSetStatus/smtSDMMCDatGetStatus 	
	
	# fifo function
		- smtSDMMCFIFOSetData/smtSDMMCFIFOGetData
		- smtSDMMCFIFOSetStatus/smtSDMMCFIFOGetStatus
	
	
	# interrupt function
		- smtSDMMCIntSet/smtSDMMCIntGet
		- smtSDMMCIntGetStatus/smtSDMMCIntSetStatus
-----------------------------------------------------------*/


/*----------------------------------------------------------
	Function name	: smtSDMMCTopReset
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
		2006-12-11 4:38오후 register bit check
-----------------------------------------------------------*/
void smtSDMMCTopReset(void)  
{
	// reset SD/MMC INF, reset bit [8] auto cleared.
	SMT_WRITE(SDCON,(1<<8));
}

/*----------------------------------------------------------
	Function name	: smtSDMMCTopEnableClk
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
		2006-12-11 4:38오후 register bit check
-----------------------------------------------------------*/
smtUint32 smtSDMMCTopEnableClk(smtUint32 enable)
{
	SMT_WRITE(SDCON, (enable&0x1));
	
	return SMT_TRUE;
}
/*----------------------------------------------------------
	Function name	: smtSDMMCTopSetPreScaler
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
		2006-12-11 4:38오후 register bit check
-----------------------------------------------------------*/
void smtSDMMCTopSetPreScaler(smtUint32 *ppreScaler)
{
	// SDMMCINF_OUTCLK = (SDMMCINF_INCLK/2X(SDPRE+1))
	SMT_WRITE(SDPRE, ((*ppreScaler)&0xFF));

}

/*----------------------------------------------------------
	Function name	: smtSDMMCTopGetPreScaler
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
		2006-12-11 4:38오후 register bit check
-----------------------------------------------------------*/
void smtSDMMCTopGetPreScaler(smtUint32 *ppreScaler)
{
	// SDMMCINF_OUTCLK = (SDMMCINF_INCLK/2X(SDPRE+1))
	*ppreScaler =  (SMT_READ(SDPRE)&0xFF);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
		2006-12-11 4:38오후 register bit check
-----------------------------------------------------------*/
void smtSDMMCCmdSet(smtUint32 *pcmd) 
{
	SMT_WRITE(SDCmdArg, ((*pcmd)&0xFFFFFFFF));
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
		2006-12-11 4:38오후 register bit check
-----------------------------------------------------------*/
void smtSDMMCCmdGet(smtUint32 *pcmd) 
{
	*pcmd =  (smtUint32)SDCmdArg;
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
		2006-12-11 4:38오후 register bit check
-----------------------------------------------------------*/
void smtSDMMCCmdSetCtrl(SdmmcCmdCtrl *pcmdCtrl)
{
	//UART_printf("command idx: %d\n", cmdCtrl.CmdIdx&(~0x40));
	SMT_WRITE(SDCmdCon,
		 ( (pcmdCtrl->BusyRsp   & 0x1 ) << 14 )	// 0/1(Normal/R1b)
		|( (pcmdCtrl->noCRCRsp  & 0x1 ) << 13 )	// 0/1(Normal/R3)
		|( (pcmdCtrl->AbortCmd  & 0x1 ) << 12 )	// 0/1(Normal/CMD12)
		|( (pcmdCtrl->WidthData & 0x1 ) << 11 )	// 
		|( (pcmdCtrl->LongRsp   & 0x1 ) << 10 )	// 
		|( (pcmdCtrl->WaitRsp   & 0x1 ) <<  9 )	// 
		|( (pcmdCtrl->CmdStart  & 0x1 ) <<  8 )	// 
		|( (pcmdCtrl->CmdIdx	  & 0x7F) <<  0 )	// 
	);
	
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCCmdGetCtrl(SdmmcCmdCtrl *pcmdCtrl)
{
	smtUint32 Register;
	
	Register = SMT_READ(SDCmdCon);
	
	pcmdCtrl->BusyRsp 	= 	( (Register >> 14) & 0x1 );
	pcmdCtrl->noCRCRsp	= 	( (Register >> 13) & 0x1 );
	pcmdCtrl->AbortCmd	=	( (Register >> 12) & 0x1 );
	pcmdCtrl->WidthData	=	( (Register >> 11) & 0x1 );
	pcmdCtrl->LongRsp	=	( (Register >> 10) & 0x1 );
	pcmdCtrl->WaitRsp	=	( (Register >>  9) & 0x1 );
	pcmdCtrl->CmdStart	=	( (Register >>  8) & 0x1 );
	pcmdCtrl->CmdIdx	=	( (Register >>  0) & 0x7F);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCGetResponse(SdmmcCmdRsp *presponse)
{
	presponse->response0 =  SMT_READ(SDRSP0);
	presponse->response1 =  SMT_READ(SDRSP1);
	presponse->response2 =  SMT_READ(SDRSP2);
	presponse->response3 =  SMT_READ(SDRSP3);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCCmdSetStatus(SdmmcCmdSta *pcmdStatus) 
{
	
	
	SMT_WRITE(SDCmdSta, 
		 ( (pcmdStatus->RspCRC 	& 0x1 ) << 12 )
		|( (pcmdStatus->CmdSent & 0x1 ) << 11 )
		|( (pcmdStatus->CmdTout & 0x1 ) << 10 )
		|( (pcmdStatus->RspFin 	& 0x1 ) <<  9 )
		|( (pcmdStatus->CmdOn 	& 0x1 ) <<  8 ) // need clear or maintain value ?? 
		|( (pcmdStatus->RspIdx 	& 0xFF) <<  0 ) // need clear or maintain value ?? 
	);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCCmdGetStatus(SdmmcCmdSta *pcmdStatus) 
{
	smtUint32 Register = SMT_READ(SDCmdSta);
	
	pcmdStatus->RspCRC 	= ( (Register >> 12) & 0x1  );
	pcmdStatus->CmdSent = ( (Register >> 11) & 0x1  );
	pcmdStatus->CmdTout = ( (Register >> 10) & 0x1  );
	pcmdStatus->RspFin 	= ( (Register >>  9) & 0x1  );
	pcmdStatus->CmdOn 	= ( (Register >>  8) & 0x1  );
	pcmdStatus->RspIdx 	= ( (Register >>  0) & 0xFF );
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: change to new bit postion 2007-03-21 2:03오후
-----------------------------------------------------------*/
void smtSDMMCDatSetCtrl(SdmmcDatCtrl *pdatCtrl)
{
	/* old 
	SMT_WRITE(SDDatCon,(
		 ( (pdatCtrl->DMASize       & 0x07F)<<25)
		|( (pdatCtrl->MMCPlus		& 0x1)	<<21)
		|( (pdatCtrl->TARSP		    & 0x001)<<20)
		|( (pdatCtrl->RACMD			& 0x1)	<<19)
		|( (pdatCtrl->ByteOrder	    & 0x001)<<18)
		|( (pdatCtrl->BlkMode		& 0x1)	<<17)
		|( (pdatCtrl->WideBusEnable & 0x001)<<16)
		|( (pdatCtrl->DMAEnable		& 0x1)	<<15)
		|( (pdatCtrl->TransStart	& 0x001)<<14)
		|( (pdatCtrl->TransMode		& 0x3)	<<12)
		|( (pdatCtrl->BlkNum		& 0xFFF)<<0 ))		
		);
	*/
	SMT_WRITE(SDDatCon,(
		 ( (pdatCtrl->DMASize       & 0x07F)	<<26)
		|( (pdatCtrl->TARSP		    & 0x001)	<<25)		 
		|( (pdatCtrl->RACMD			& 0x1)		<<24)
		|( (pdatCtrl->ByteOrder	    & 0x001)	<<23)
		//|( (pdatCtrl->BlkMode		& 0x1)		<<22)
		|( (pdatCtrl->MMCPlus		& 0x1)		<<21)
		|( (pdatCtrl->WideBusEnable & 0x001)	<<20)
		|( (pdatCtrl->DMAEnable		& 0x1)		<<19)		
		|( (pdatCtrl->TransStart	& 0x001)	<<18)
		|( (pdatCtrl->TransMode		& 0x3)		<<16)
		|( (pdatCtrl->BlkNum		& 0xFFFF)	<<0 ))		
		);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: change to new bit postion 2007-03-21 2:03오후
-----------------------------------------------------------*/
void smtSDMMCDatGetCtrl(SdmmcDatCtrl *pdatCtrl)
{
	smtUint32 Register = SMT_READ(SDDatCon);
	
	/*
	pdatCtrl->DMASize 		= ( (Register >> 25) & 0x7F );
	pdatCtrl->MMCPlus 		= ( (Register >> 21) & 0x1  );
	pdatCtrl->TARSP 		= ( (Register >> 20) & 0x1  );
	pdatCtrl->RACMD 		= ( (Register >> 19) & 0x1  );
	pdatCtrl->ByteOrder 	= ( (Register >> 18) & 0x1  );
	pdatCtrl->BlkMode 		= ( (Register >> 17) & 0x1  );
	pdatCtrl->WideBusEnable = ( (Register >> 16) & 0x1  );
	pdatCtrl->DMAEnable 	= ( (Register >> 15) & 0x1  );
	pdatCtrl->TransStart 	= ( (Register >> 14) & 0x1  );
	pdatCtrl->TransMode 	= ( (Register >> 12) & 0x3  );
	pdatCtrl->BlkNum 		= ( (Register >> 0 ) & 0xFFF);
	*/
	pdatCtrl->DMASize 		= ( (Register >> 26) & 0x7F );
	pdatCtrl->TARSP 		= ( (Register >> 25) & 0x1  );
	pdatCtrl->RACMD 		= ( (Register >> 24) & 0x1  );
	pdatCtrl->ByteOrder 	= ( (Register >> 23) & 0x1  );	
	pdatCtrl->MMCPlus 		= ( (Register >> 21) & 0x1  );
	pdatCtrl->WideBusEnable = ( (Register >> 20) & 0x1  );
	pdatCtrl->DMAEnable 	= ( (Register >> 19) & 0x1  );
	pdatCtrl->TransStart 	= ( (Register >> 18) & 0x1  );
	pdatCtrl->TransMode 	= ( (Register >> 16) & 0x3  );
	pdatCtrl->BlkNum 		= ( (Register >> 0 ) & 0xFFFF);
	
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: change to new bit postion 2007-03-21 2:03오후
-----------------------------------------------------------*/
void smtSDMMCDatSetDBSize(smtUint32 *pblkSize)
{
	//SMT_WRITE(SDBSize, (blkSize & 0x7FF));
	SMT_WRITE(SDBSize, (*pblkSize & 0xFFFF));
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCDatGetDBSize(smtUint32 *pblkSize)
{
	*pblkSize = (smtUint32)SMT_READ(SDBSize);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCDatSetTimer(smtUint32 *ptimerValue)
{
	SMT_WRITE(SDDTimer, (*ptimerValue & 0x3FFFFF));
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCDatGetTimer(smtUint32 *ptimerValue)
{
	*ptimerValue = (smtUint32)SMT_READ(SDDTimer);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMDatGetBlockCnt(SdmmcDatCnt *pdataCnt)
{
	smtUint32 Register = SMT_READ(SDDatCnt);
	
	/*
	pdataCnt->BlkNumCnt	= ( (Register >> 12) & 0xFFFF );
	pdataCnt->BlkCnt	= ( (Register >> 0 ) & 0x7FFF );
	*/
	
	pdataCnt->BlkNumCnt	= ( (Register >> 16) & 0xFFFF );
	pdataCnt->BlkCnt	= ( (Register >> 0 ) & 0xFFFF );
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCSetStatus(SdmmcDatSta *pdataStatus)
{
	SMT_WRITE(SDDatSta,
		 ((pdataStatus->NoBusy 	& 0x1) << 11)
		|((pdataStatus->CRCSta 	& 0x1) << 7 )
		|((pdataStatus->DatCRC 	& 0x1) << 6 )
		|((pdataStatus->DatTOut & 0x1) << 5 )
		|((pdataStatus->DatFin 	& 0x1) << 4 )
		|((pdataStatus->BusyFin & 0x1) << 3 )
		|((pdataStatus->TxDatOn & 0x1) << 1 )	// need clear or maintain value ?? 
		|((pdataStatus->RxDatOn & 0x1) << 0 )	// need clear or maintain value ?? 
	);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCGetStatus(SdmmcDatSta *pdataStatus)
{
	smtUint32 Register = SMT_READ(SDDatSta);
	
	pdataStatus->NoBusy		= ( (Register >> 11) & 0x1 );
	pdataStatus->CRCSta		= ( (Register >> 7 ) & 0x1 );
	pdataStatus->DatCRC		= ( (Register >> 6 ) & 0x1 );
	pdataStatus->DatTOut	= ( (Register >> 5 ) & 0x1 );
	pdataStatus->DatFin		= ( (Register >> 4 ) & 0x1 );
	pdataStatus->BusyFin	= ( (Register >> 3 ) & 0x1 );
	pdataStatus->TxDatOn	= ( (Register >> 1 ) & 0x1 );
	pdataStatus->RxDatOn	= ( (Register >> 0 ) & 0x1 );
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCFIFOSetData(smtUint32 *pdata)
{
	SMT_WRITE(SDDAT, *pdata);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCFIFOGetData(smtUint32 *pdata)
{
	*pdata = (smtUint32)SMT_READ(SDDAT);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCFIFOSetStatus(SdmmcFIFOSta *pFIFOStatus)
{
	SMT_WRITE(SDFSTA,(\
		 ((pFIFOStatus->Reset 	   &0x01)<<16)|((pFIFOStatus->FIFOError &0x1)<<14)\
		|((pFIFOStatus->TXAvail    &0x01)<<13)|((pFIFOStatus->RXAvail 	&0x1)<<12)\
		|((pFIFOStatus->TXHalfFull &0x01)<<11)|((pFIFOStatus->TXEmpty	&0x1)<<10)\
		|((pFIFOStatus->RXFull	   &0x01)<<8 )|((pFIFOStatus->RXHalfFull&0x1)<<7 )\
		|((pFIFOStatus->Count 	   &0x7F)<<0 ))
	);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCFIFOGetStatus(SdmmcFIFOSta *pFIFOStatus)
{
	smtUint32 Register = SMT_READ(SDFSTA);
	
	pFIFOStatus->Reset	 		= ( (Register >> 16) & 0x1 );
	pFIFOStatus->FIFOError	 	= ( (Register >> 14) & 0x1 );
	pFIFOStatus->TXAvail	 	= ( (Register >> 13) & 0x1 );
	pFIFOStatus->RXAvail	 	= ( (Register >> 12) & 0x1 );
	pFIFOStatus->TXHalfFull	 	= ( (Register >> 11) & 0x1 );
	pFIFOStatus->TXEmpty	 	= ( (Register >> 10) & 0x1 );
	pFIFOStatus->RXFull	 		= ( (Register >> 8 ) & 0x1 );
	pFIFOStatus->RXHalfFull	 	= ( (Register >> 7 ) & 0x1 );
	pFIFOStatus->Count	 		= ( (Register >> 0 ) & 0x7F);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCIntSet(SdmmcIntEnable * pIntMask)
{
	SMT_WRITE(SDIntMsk,(((pIntMask->AutoReadComplete&0x1)<<18)|((pIntMask->AutoReadCMD12Error&0x1)<<17)
		|((pIntMask->AutoReadCMD18Error&0x1)<<16) |((pIntMask->NoBusy 			&0x1)<<15)
		|((pIntMask->RspCRC 			&0x1)<<14)|((pIntMask->CmdSent 			&0x1)<<13)
		|((pIntMask->CmdTout 			&0x1)<<12)|((pIntMask->RspEnd 			&0x1)<<11)
		|((pIntMask->FIFOFail 			&0x1)<<10)|((pIntMask->CRCSta 			&0x1)<<9 )
		|((pIntMask->DatCRC 			&0x1)<<8 )|((pIntMask->DatTOut 			&0x1)<<7 )
		|((pIntMask->DatFin 			&0x1)<<6 )|((pIntMask->BusyFin 			&0x1)<<5 )
		|((pIntMask->TFHalf 			&0x1)<<3 )|((pIntMask->TFEmpty	 		&0x1)<<2 )
		|((pIntMask->RFFull 			&0x1)<<1 )|((pIntMask->RFHalf 			&0x1)<<0 ))
	);
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCIntGet(SdmmcIntEnable * pIntMask)
{
	smtUint32 Register	= SMT_READ(SDIntMsk);
	
	pIntMask->AutoReadComplete		= ( (Register >> 18) & 0x1 );
	pIntMask->AutoReadCMD12Error	= ( (Register >> 17) & 0x1 );
	pIntMask->AutoReadCMD18Error	= ( (Register >> 16) & 0x1 );
	pIntMask->NoBusy 				= ( (Register >> 15) & 0x1 );
	pIntMask->RspCRC 				= ( (Register >> 14) & 0x1 );
	pIntMask->CmdSent 				= ( (Register >> 13) & 0x1 );
	pIntMask->CmdTout 				= ( (Register >> 12) & 0x1 );
	pIntMask->RspEnd 				= ( (Register >> 11) & 0x1 );
	pIntMask->FIFOFail 				= ( (Register >> 10) & 0x1 );
	pIntMask->CRCSta 				= ( (Register >> 9 ) & 0x1 );
	pIntMask->DatCRC 				= ( (Register >> 8 ) & 0x1 );
	pIntMask->DatTOut 				= ( (Register >> 7 ) & 0x1 );
	pIntMask->DatFin 				= ( (Register >> 6 ) & 0x1 );
	pIntMask->BusyFin 				= ( (Register >> 5 ) & 0x1 );
	pIntMask->TFHalf 				= ( (Register >> 3 ) & 0x1 );
	pIntMask->TFEmpty	 			= ( (Register >> 2 ) & 0x1 );
	pIntMask->RFFull 				= ( (Register >> 1 ) & 0x1 );
	pIntMask->RFHalf 				= ( (Register >> 0 ) & 0x1 );
}	

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCIntSetStatus(SdmmcIntSta *pIntStatus) 
{
	SMT_WRITE(SDIntSta,
		(
			 ((pIntStatus->AutoReadComplete		& 0x1) <<18)
			|((pIntStatus->AutoReadCMD12Error 	& 0x1) <<17)
			|((pIntStatus->AutoReadCMD18Error 	& 0x1) <<16)
			|((pIntStatus->NoBusy 				& 0x1) <<15)
			|((pIntStatus->RspCRC  				& 0x1) <<14)
			|((pIntStatus->CmdSent 				& 0x1) <<13)
			|((pIntStatus->CmdTout 				& 0x1) <<12)
			|((pIntStatus->RspEnd 				& 0x1) <<11)
			|((pIntStatus->FIFOFail				& 0x1) <<10)
			|((pIntStatus->CRCSta 				& 0x1) << 9)
			|((pIntStatus->DatCRC  				& 0x1) << 8)
			|((pIntStatus->DatTOut 				& 0x1) << 7)
			|((pIntStatus->DatFin  				& 0x1) << 6)
			|((pIntStatus->BusyFin 				& 0x1) << 5)
			|((pIntStatus->TFHalf  				& 0x1) << 3)
			|((pIntStatus->TFEmpty				& 0x1) << 2)
			|((pIntStatus->RFFull  				& 0x1) << 1)
			|((pIntStatus->RFHalf 				& 0x1) << 0)
		)
	);	
}

/*----------------------------------------------------------
	Function name	: 
	Prototype		: 
	Return			: 
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
void smtSDMMCIntGetStatus(SdmmcIntSta *pIntStatus)
{
	smtUint32 Register	= SMT_READ(SDIntSta);
	
	pIntStatus->AutoReadComplete	= ( (Register >> 18) & 0x1 );
	pIntStatus->AutoReadCMD12Error	= ( (Register >> 17) & 0x1 );
	pIntStatus->AutoReadCMD18Error	= ( (Register >> 16) & 0x1 );
	pIntStatus->NoBusy 				= ( (Register >> 15) & 0x1 );
	pIntStatus->RspCRC 				= ( (Register >> 14) & 0x1 );
	pIntStatus->CmdSent 			= ( (Register >> 13) & 0x1 );
	pIntStatus->CmdTout 			= ( (Register >> 12) & 0x1 );
	pIntStatus->RspEnd 				= ( (Register >> 11) & 0x1 );
	pIntStatus->FIFOFail 			= ( (Register >> 10) & 0x1 );
	pIntStatus->CRCSta 				= ( (Register >> 9 ) & 0x1 );
	pIntStatus->DatCRC 				= ( (Register >> 8 ) & 0x1 );
	pIntStatus->DatTOut 			= ( (Register >> 7 ) & 0x1 );
	pIntStatus->DatFin 				= ( (Register >> 6 ) & 0x1 );
	pIntStatus->BusyFin 			= ( (Register >> 5 ) & 0x1 );
	pIntStatus->TFHalf 				= ( (Register >> 3 ) & 0x1 );
	pIntStatus->TFEmpty	 			= ( (Register >> 2 ) & 0x1 );
	pIntStatus->RFFull 				= ( (Register >> 1 ) & 0x1 );
	pIntStatus->RFHalf 				= ( (Register >> 0 ) & 0x1 );
}	
