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
	 I2sClkMode
-----------------------------------------------------------*/
typedef struct
{
	smtUint16	DTORatio;			// 
	smtBoolean	ClkMaster;			// 
	smtBoolean	LRClkInv;			// 
	smtBoolean	MClkOn;				// 
	smtBoolean	MClkOE;				// 
} I2sClkMode;
/*----------------------------------------------------------
	 I2sTransDir
-----------------------------------------------------------*/
typedef enum
{
	I2S_DIR_RX,
	I2S_DIR_TX,
	I2S_DIR_32B	= 0xFFFF
} I2sTransDir;
/*----------------------------------------------------------
	 I2sDataWidth
-----------------------------------------------------------*/
typedef enum
{
	I2S_DW_08BIT,
	I2S_DW_16BIT,
	I2S_DW_24BIT,
	I2S_DW_32BIT,
	I2S_DW_32B	= 0xFFFF
} I2sDataWidth;
/*----------------------------------------------------------
	 I2sFifoThresh
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
} I2sFifoThresh;
/*----------------------------------------------------------
	 I2sCtrl
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
} I2sCtrl;
/*----------------------------------------------------------
	 I2sStatusDat
-----------------------------------------------------------*/
typedef struct
{
	smtBoolean	DMAInt;
	smtBoolean	FIFOURInt;
	smtUint8	FIFODepth;
	smtBoolean	FIFOL;
} I2sStatusDat;
/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/
extern void 		smtI2SSetClockMode(I2sClkMode *pclkMode);
extern void 		smtI2SGetClockMode(I2sClkMode *pclkMode);
extern void 		smtI2SClearFIFO(I2sTransDir dir);
extern void 		smtI2SResetFIFO(I2sTransDir dir);
extern void 		smtI2SSetMode(I2sTransDir dir, I2sCtrl *pcontrol);
extern void 		smtI2SGetMode(I2sTransDir dir, I2sCtrl *pControl);
extern void 		smtI2SEnable(I2sTransDir dir, smtUint32 enable);
extern void 		smtI2SGetStatus(I2sTransDir dir, I2sStatusDat *pstatus);
extern void		 	smtI2SGetData(smtUint32 *pdata);
extern void			smtI2SSetData(smtUint32 *pdata);
#endif
