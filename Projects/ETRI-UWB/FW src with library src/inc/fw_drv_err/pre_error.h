/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name   : pre_error.h 
	Description : Firmware error return type define file
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

#ifndef __PRE_ERROR_H__
#define __PRE_ERROR_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

//#include "sysinc.h"
//#include "structdef.h"
//#include "commonmacro.h"

/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/

/*--------------------------------------------------------
        ADC
--------------------------------------------------------*/
typedef enum
{
	ADC_NO_ERR,
	ADC_CTRL_ERR
} ADC_PRE_ERR;

/*--------------------------------------------------------
        DMA
--------------------------------------------------------*/
typedef enum
{
	DMA_NO_ERR,
	DMA_CTRL_ERR,
	DMA_PARM_ERR,
	DMA_STATUS_ERR
} DMA_PRE_ERR;

/*--------------------------------------------------------
        GPIO
--------------------------------------------------------*/
typedef enum
{
	GPIO_NO_ERR,
	GPIO_CHANNEL_ERR,
	GPIO_INTNUM_ERR
} GPIO_PRE_ERR;

/*--------------------------------------------------------
        Power Management
--------------------------------------------------------*/
typedef enum
{
	PM_NO_ERR,
	PM_CTRL_ERR
} PM_PRE_ERR;

/*--------------------------------------------------------
        PLL
--------------------------------------------------------*/
typedef enum
{
	PLL_NO_ERR,
	PLL_CTRL_ERR
} PLL_PRE_ERR;

/*--------------------------------------------------------
        Timer & PWM
--------------------------------------------------------*/
typedef enum
{
	TIMER_NO_ERR,
	TIMER_CTRL_ERR
} TIMER_PRE_ERR;

/*--------------------------------------------------------
        VIC
--------------------------------------------------------*/
typedef enum
{
	VIC_NO_ERR,
	VIC_CTRL_ERR,
	VIC_PARM_ERR
} VIC_PRE_ERR;

/*--------------------------------------------------------
        WDT
--------------------------------------------------------*/
typedef enum
{
	WDT_NO_ERR,
	WDT_CTRL_ERR
} WDT_PRE_ERR;

#endif // __PRE_ERROR_H__