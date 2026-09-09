#ifndef __SDMMC_PRE_DRV_H__
#define	__SDMMC_PRE_DRV_H__

#include "sysinc.h"

/*----------------------------------------------------------
	SDMMC Host controller
	
		SDMMC_CMD_CTRL
		SDMMC_CMD_RSP
		SDMMC_CMD_STA
		SDMMC_DAT_CTRL
		SDMMC_DAT_CNT
		SDMMC_DAT_STA
		SDMMC_FIFO_STA
		SDMMC_INT_ENABLE
		SDMMC_INT_STA
	
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
} SDMMC_CMD_CTRL;

typedef struct
{
	smtUint32	response0;
	smtUint32	response1;
	smtUint32	response2;
	smtUint32	response3;
} SDMMC_CMD_RSP;

typedef struct
{
	smtUint32	RspIdx;
	smtBoolean	RspCRC;
	smtBoolean	CmdSent;
	smtBoolean	CmdTout;
	smtBoolean	RspFin;
	smtBoolean	CmdOn;
	/* need padding */
} SDMMC_CMD_STA;

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

} SDMMC_DAT_CTRL;


typedef struct
{
	smtUint32	BlkNumCnt;
	smtUint32	BlkCnt;
} SDMMC_DAT_CNT;

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
} SDMMC_DAT_STA;

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
} SDMMC_FIFO_STA;

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
} SDMMC_INT_ENABLE;

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
} SDMMC_INT_STA;

#endif
