/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		  : video_pre_drv.h
	Description		: 
	Created by		: SHMT SOC Team
----------------------------------------------------------*/
#ifndef __VIDEOENC_PRE_DRV_H__
#define	__VIDEOENC_PRE_DRV_H__

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
#if 0//shkim-20070604 : don't use the emuneration value below
/*----------------------------------------------------------
	 VIDEOENC_CONTROL control register bit descriptions  	
----------------------------------------------------------*/
typedef enum
{
	VENC_DAC0	= 0x01,
	VENC_DAC1	= 0x02,
	VENC_DAC2	= 0x04
} VENC_DAC_POWER;

typedef enum
{
	VENC_NORMAL_PIXEL	= 0,
	VENC_SQ_PIXEL		= 1
} VENC_PIXEL_MODE;

typedef enum
{
	VENC_INTERLACED		= 0,
	VENC_NONINTERLACED	= 1
} VENC_SCAN_MODE;

typedef enum
{
	VENC_OMODE_NTSCM	= 0x00,
	VENC_OMODE_NTSCJ	= 0x01,
	VENC_OMODE_NTSC433	= 0x02,
	VENC_OMODE_MPAL		= 0x03,
	VENC_OMODE_PAL		= 0x04,
	VENC_OMODE_PALNC	= 0x05,
	VENC_OMODE_PALN		= 0x06
} VENC_ENCODE_MODE;


/*----------------------------------------------------------
	 VIDEOENC_INTERNAL
----------------------------------------------------------*/
typedef enum
{
	VENC_LFILTER_6MHZ		= 0x00,
	VENC_LFILTER_2500KHZ	= 0x01,
	VENC_LFILTER_NTSC		= 0x02,
	VENC_LFILTER_PAL		= 0x03
} VENC_LFILTER;

typedef enum
{
	VENC_CFILTER_610KHZ		= 0x00,
	VENC_CFILTER_850KHZ		= 0x01,
	VENC_CFILTER_1240KHZ	= 0x02,
	VENC_CFILTER_1450KHZ	= 0x03
} VENC_CFILTER;

typedef enum
{
	VENC_OUT_COLOR_ENABLE	= 0x00,
	VENC_OUT_COLOR_DISABLE	= 0x01
} VENC_OUT_COLOR;

typedef enum
{
	VENC_RESET_SCH_DISABLE	= 0x00,
	VENC_RESET_SCH_ENABLE	= 0x01
} VENC_RESET_SCH;

typedef enum
{
	VENC_INTERNAL_PATTERN_DISABLE	= 0x00,
	VENC_INTERNAL_PATTERN_GEN		= 0x01
} VENC_INTERNAL_PATTERN;

typedef enum
{
	VENC_PATTERN_COLORBAR	= 0x00,
	VENC_PATTERN_RED		= 0x01,
	VENC_PATTERN_GREEN		= 0x02,
	VENC_PATTERN_BLUE		= 0x03
} VENC_PATTERN_MODE;

typedef enum
{
	VENC_CHRODELAY_NONE		= 0x00,
	VENC_CHRODELAY_1TS		= 0x01,
	VENC_CHRODELAY_2TS		= 0x02,
	VENC_CHRODELAY_3TS		= 0x03,
	VENC_CHRODELAY_4TS		= 0x04
} VENC_CDELAY;

typedef enum
{
	VENC_LDELAY_NONE	= 0x00,
	VENC_LDELAY_1TS		= 0x01,
	VENC_LDELAY_2TS		= 0x02,
	VENC_LDELAY_3TS		= 0x03,
	VENC_LDELAY_4TS		= 0x04
} VENC_LDELAY;

typedef enum
{
	VENC_BURST_WIDTH_REDUCE	= 0x00,
	VENC_BURST_WIDTH_NORMAL	= 0x01,
	VENC_BURST_WIDTH_EXPAND	= 0x02
} VENC_BURST_WIDTH;

typedef enum
{
	VENC_HSYNC_WIDTH_R2TS	= 0x00,
	VENC_HSYNC_WIDTH_R1TS	= 0x01,
	VENC_HSYNC_WIDTH_NORMAL	= 0x02,
	VENC_HSYNC_WIDTH_E1TS	= 0x03,
	VENC_HSYNC_WIDTH_E2TS	= 0x04
} VENC_HSYNC_WIDTH;

typedef enum
{
	VENC_VALUE_UNSET	= 0x00,
	VENC_VALUE_SET		= 0x0l
} VENC_SET;
#endif

typedef struct
{
	smtUint8 DAC0;
	smtUint8 DAC1;
	smtUint8 DAC2;
	smtUint8 inv_hsync;
	smtUint8 inv_blank;
	smtUint8 inv_field;
	smtUint8 inv_cbcr;
	smtUint8 SqPixel;
	smtUint8 sanning;
	smtUint8 encMode;
} VEncCtrl;

typedef struct
{
	smtUint8 lFilter;
	smtUint8 CFilter;
	smtUint8 color;
	smtUint8 resetSCH;
	smtUint8 patternMode;
	smtUint8 pattern;
	smtUint8 cDelay;
	smtUint8 lDelay;
	smtUint8 burstWidth;
	smtUint8 hSyncWidth;
} VEncInternal;

typedef struct
{
	smtUint8 fieldCount;
	smtUint16 Hcount;
	smtUint16 Vcount;
	smtUint8 outEnable;
	smtUint8 vEnable;
} VEncStatus;

typedef struct
{
	smtUint8 brightnessLev;
	smtUint8 hueLev;
	smtUint8 saturationCLev;
	smtUint8 saturationYLev;
} VEncImageCtrl;

typedef struct
{
	smtUint16 blackLev;
	smtUint16 blankLev;
}VEncOutputLev0;

typedef struct
{
	smtUint8 HSyncStep;
	smtUint8 burstCal;
	smtUint8 burstStep;
}VEncOutputLev1;

typedef struct
{
	VEncCtrl rCtrl;
	VEncInternal rInternal;
} VEncCfg;

/*
/////////////////////////////////////////////////////////
        FUNCTION
/////////////////////////////////////////////////////////
*/
smtBoolean smt2VEncInit(smtUint32 fb_addr, smtUint32 h, smtUint32 w);

void smtVENCSetCtrlNInternal(VEncCtrl *vCtrl, VEncInternal *vInternal);
void smtVENCSetStatus(VEncStatus *vStatus);
void smtVENCGetStatus(VEncStatus *vStatus);
void smtVENCSetSubCarrier(smtUint16 subPhase, smtUint32 subReq);
void smtVENCGetVideoImageCtrl(VEncImageCtrl * imageCtrl);
void smtVENCSetVideoImageCtrl(VEncImageCtrl * imageCtrl);
smtBoolean smt2VEncRun(void);
smtBoolean smt2VencSetControl(VEncCfg *vEncCfg);
#endif
