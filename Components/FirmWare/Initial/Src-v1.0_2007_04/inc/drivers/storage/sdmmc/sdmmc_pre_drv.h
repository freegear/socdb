#ifndef __SDMMC_PRE_DRV_H__
#define	__SDMMC_PRE_DRV_H__

#include "sysinc.h"

/*----------------------------------------------------------
	SDMMC Host controller
	
		SdmmcCmdCtrl
		SdmmcCmdRsp
		SdmmcCmdSta
		SdmmcDatCtrl
		SdmmcDatCnt
		SdmmcDatSta
		SdmmcFIFOSta
		SdmmcIntEnable
		SdmmcIntSta
	
-----------------------------------------------------------*/

typedef struct
{
	smtUint32	CmdIdx;
	smtBoolean	BusyRsp;
	smtBoolean	noCRCRsp;
	smtBoolean	AbortCmd;
	smtBoolean	WidthData;
	smtBoolean	LongRsp;
	smtBoolean	WaitRsp;
	smtBoolean 	CmdStart;
	/* need padding */
} SdmmcCmdCtrl;

typedef struct
{
	smtUint32	response0;
	smtUint32	response1;
	smtUint32	response2;
	smtUint32	response3;
} SdmmcCmdRsp;

typedef struct
{
	smtUint32	RspIdx;
	smtBoolean	RspCRC;
	smtBoolean	CmdSent;
	smtBoolean	CmdTout;
	smtBoolean	RspFin;
	smtBoolean	CmdOn;
	/* need padding */
} SdmmcCmdSta;

typedef struct
{
	smtUint32	DMASize;
	smtUint32	TransMode;
	smtUint32	BlkNum;	
	smtBoolean	MMCPlus;
	smtBoolean	TARSP;
	smtBoolean	RACMD;
	smtBoolean	ByteOrder;
	smtBoolean	BlkMode;
	smtBoolean	WideBusEnable;
	smtBoolean	DMAEnable;
	smtBoolean	TransStart;

} SdmmcDatCtrl;


typedef struct
{
	smtUint32	BlkNumCnt;
	smtUint32	BlkCnt;
} SdmmcDatCnt;

typedef struct
{
	smtBoolean	NoBusy;
	smtBoolean	CRCSta;
	smtBoolean	DatCRC;
	smtBoolean	DatTOut;
	smtBoolean	DatFin;
	smtBoolean	BusyFin;
	smtBoolean	TxDatOn;
	smtBoolean	RxDatOn;
} SdmmcDatSta;

typedef struct
{
	smtBoolean	Reset;
	smtBoolean	FIFOError;
	smtBoolean	TXAvail;
	smtBoolean	RXAvail;
	smtBoolean	TXHalfFull;
	smtBoolean	TXEmpty;
	smtBoolean	RXFull;
	smtBoolean	RXHalfFull;
	smtBoolean	Count;
} SdmmcFIFOSta;

typedef struct
{
	smtBoolean	AutoReadComplete;
	smtBoolean	AutoReadCMD12Error;
	smtBoolean	AutoReadCMD18Error;
	smtBoolean	NoBusy;
	smtBoolean	RspCRC;
	smtBoolean	CmdSent;
	smtBoolean	CmdTout;
	smtBoolean	RspEnd;
	smtBoolean	FIFOFail;
	smtBoolean	CRCSta;
	smtBoolean	DatCRC;
	smtBoolean	DatTOut;
	smtBoolean	DatFin;
	smtBoolean	BusyFin;
	smtBoolean	TFHalf;
	smtBoolean	TFEmpty;
	smtBoolean	RFFull;
	smtBoolean	RFHalf;
	/* need check padding */
} SdmmcIntEnable;

typedef struct
{
	smtBoolean	AutoReadComplete;
	smtBoolean	AutoReadCMD12Error;
	smtBoolean	AutoReadCMD18Error;
	smtBoolean	NoBusy;
	smtBoolean	RspCRC;
	smtBoolean	CmdSent;
	smtBoolean	CmdTout;
	smtBoolean	RspEnd;
	smtBoolean	FIFOFail;
	smtBoolean	CRCSta;
	smtBoolean	DatCRC;
	smtBoolean	DatTOut;
	smtBoolean	DatFin;
	smtBoolean	BusyFin;
	smtBoolean	TFHalf;
	smtBoolean	TFEmpty;
	smtBoolean	RFFull;
	smtBoolean	RFHalf;
	/* need check padding */
} SdmmcIntSta;


void smtSDMMCTopReset(void);
smtUint32 smtSDMMCTopEnableClk(smtUint32 enable);
void smtSDMMCTopSetPreScaler(smtUint32 *ppreScaler);
void smtSDMMCTopGetPreScaler(smtUint32 *ppreScaler);
void smtSDMMCCmdSet(smtUint32 *pcmd);
void smtSDMMCCmdGet(smtUint32 *pcmd);
void smtSDMMCCmdSetCtrl(SdmmcCmdCtrl *pcmdCtrl);
void smtSDMMCCmdGetCtrl(SdmmcCmdCtrl *pcmdCtrl);
void smtSDMMCGetResponse(SdmmcCmdRsp *presponse);
void smtSDMMCCmdSetStatus(SdmmcCmdSta *pcmdStatus);
void smtSDMMCCmdGetStatus(SdmmcCmdSta *pcmdStatus);
void smtSDMMCDatSetCtrl(SdmmcDatCtrl *pdatCtrl);
void smtSDMMCDatGetCtrl(SdmmcDatCtrl *pdatCtrl);
void smtSDMMCDatSetDBSize(smtUint32 *pblkSize);
void smtSDMMCDatGetDBSize(smtUint32 *pblkSize);
void smtSDMMCDatSetTimer(smtUint32 *ptimerValue);
void smtSDMMCDatGetTimer(smtUint32 *ptimerValue);
void smtSDMMDatGetBlockCnt(SdmmcDatCnt *pdataCnt);
void smtSDMMCSetStatus(SdmmcDatSta *pdataStatus);
void smtSDMMCGetStatus(SdmmcDatSta *pdataStatus);
void smtSDMMCFIFOSetData(smtUint32 *pdata);
void smtSDMMCFIFOGetData(smtUint32 *pdata);
void smtSDMMCFIFOSetStatus(SdmmcFIFOSta *pFIFOStatus);
void smtSDMMCFIFOGetStatus(SdmmcFIFOSta *pFIFOStatus);
void smtSDMMCIntSet(SdmmcIntEnable * pIntMask);
void smtSDMMCIntGet(SdmmcIntEnable * pIntMask);
void smtSDMMCIntSetStatus(SdmmcIntSta *pIntStatus);
void smtSDMMCIntGetStatus(SdmmcIntSta *pIntStatus);



#endif
