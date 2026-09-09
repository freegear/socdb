/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: i2s_pre_drv.h
	Description		: 
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __I2S_PRE_DRV_H__
#define	__I2S_PRE_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"

/*
/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	 I2S_CLOCK_MODE
-----------------------------------------------------------*/
typedef struct
{
	smtUint16	DTORatio;			// 
	smtBoolean	ClkMaster;			// 
	smtBoolean	LRClkInv;			// 
	smtBoolean	MClkOn;				// 
	smtBoolean	MClkOE;				// 
} I2S_CLOCK_MODE;
/*----------------------------------------------------------
	 I2S_TRANS_DIR
-----------------------------------------------------------*/
typedef enum
{
	I2S_DIR_RX,
	I2S_DIR_TX,
	I2S_DIR_32B	= 0xFFFF
} I2S_TRANS_DIR;
/*----------------------------------------------------------
	 I2S_DATA_WIDTH
-----------------------------------------------------------*/
typedef enum
{
	I2S_DW_08BIT,
	I2S_DW_16BIT,
	I2S_DW_24BIT,
	I2S_DW_32BIT,
	I2S_DW_32B	= 0xFFFF
} I2S_DATA_WIDTH;
/*----------------------------------------------------------
	 I2S_FIFO_TH
-----------------------------------------------------------*/
typedef enum
{
	I2S_FIFO_TH00,
	I2S_FIFO_TH01,
	I2S_FIFO_TH02,
	I2S_FIFO_TH03,
	I2S_FIFO_TH04,
	I2S_FIFO_TH05,
	I2S_FIFO_TH06,
	I2S_FIFO_TH07,
	I2S_FIFO_TH08,	
	I2S_FIFO_TH09,		
	I2S_FIFO_TH10,
	I2S_FIFO_TH11,
	I2S_FIFO_TH12,
	I2S_FIFO_TH13,
	I2S_FIFO_TH14,
	I2S_FIFO_TH15,
	I2S_FIFO_32B = 0xFFFF
} I2S_FIFO_TH;
/*----------------------------------------------------------
	 I2S_CONTROL
-----------------------------------------------------------*/
typedef struct
{
	smtUint8	WLen;
	smtUint8	FifoTH;	
	smtBoolean	Enable;
	smtBoolean	Reset;
	smtBoolean	DMAIntEn;
	smtBoolean	FifoOURIntEn;
	smtBoolean	Ljust;
} I2S_CONTROL;
/*----------------------------------------------------------
	 I2S_STATUS_DAT
-----------------------------------------------------------*/
typedef struct
{
	smtBoolean	DMAInt;
	smtBoolean	FIFOURInt;
	smtUint8	FIFODepth;
	smtBoolean	FIFOL;
} I2S_STATUS_DAT;
/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/
extern void 		smtSetClockMode(I2S_CLOCK_MODE *pclkMode);
extern void 		smtGetClockMode(I2S_CLOCK_MODE *pclkMode);
extern void 		smtI2SFIFOClear(I2S_TRANS_DIR dir);
extern void 		smtI2SFIFOReset(I2S_TRANS_DIR dir);
extern void 		smtSetI2SMode(I2S_TRANS_DIR dir, I2S_CONTROL *pcontrol);
extern void 		smtGetI2SMode(I2S_TRANS_DIR dir, I2S_CONTROL *pControl);
extern void 		smtI2SEnable(I2S_TRANS_DIR dir, smtUint32 enable);
extern void 		smtI2SGetStatus(I2S_TRANS_DIR dir, I2S_STATUS_DAT *pstatus);
extern smtUint32 	smtI2SGetData(void);
extern void			smtI2SSetData(smtUint32 data);
#endif
