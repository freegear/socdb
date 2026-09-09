/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name   : post_error.h 
	Description : Firmware error return type define file
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

#ifndef __POST_ERROR_H__
#define __POST_ERROR_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

//#include "sysinc.h"
//#include "structdef.h"
//#include "commonmacro.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*
Refer to global.h for GLOBAL_VAR define

GLOBAL_VAR smtUint32 gFWError;
*/

/*--------------------------------------------------------
        ADC
--------------------------------------------------------*/
typedef enum
{
	ADC_NO_ERR,
	// Pre-driver func error
	ADC_SETMODE_ERR,
	ADC_DATAREAD_ERR
	// Post-driver func error
} ADC_POST_ERR;

/*--------------------------------------------------------
        DMA
--------------------------------------------------------*/
typedef enum
{
	DMA_NO_ERR,
	// Pre-driver func error
	DMA_ENABLE_ERR,
	DMA_DISABLE_ERR,
	DMA_NODESCRP_ERR,
	DMA_USEDECRP_ERR
	// Post-driver func error
} DMA_POST_ERR;

/*--------------------------------------------------------
        GPIO
--------------------------------------------------------*/
typedef enum
{
	GPIO_NO_ERR,
	// Pre-driver func error
	GPIO_SET_ERR,
	GPIO_GET_ERR,
	GPIO_SETDATA_ERR
	// Post-driver func error
} GPIO_POST_ERR;

/*--------------------------------------------------------
        Power Management
--------------------------------------------------------*/
typedef enum
{
	PM_NO_ERR,
	// Pre-driver func error
	PM_POWER_ERR,
	PM_SETCLK_ERR,
	PM_GETCLK_ERR
	// Post-driver func error
} PM_POST_ERR;

/*--------------------------------------------------------
        PLL
--------------------------------------------------------*/
typedef enum
{
	PLL_NO_ERR
	// Pre-driver func error
	// Post-driver func error
} PLL_POST_ERR;

/*--------------------------------------------------------
        Timer & PWM
--------------------------------------------------------*/
typedef enum
{
	TIMER_NO_ERR,
	// Pre-driver func error
	TIMER_SETMODE_ERR,
	TIMER_OPER_ERR
	// Post-driver func error
} TIMER_POST_ERR;

/*--------------------------------------------------------
        VIC
--------------------------------------------------------*/
typedef enum
{
	VIC_NO_ERR,
	// Pre-driver func error
	VIC_IRQ_ENABLE_ERR,
	VIC_IRQ_DISABLE_ERR,
	VIC_IRQ_CLR_ERR,
	VIC_INT_ENABLE_ERR,
	VIC_INT_DISABLE_ERR,
	// Post-driver func error
	VIC_ENABLE_ERR,
	VIC_DISABLE_ERR,
	VIC_REQUSET_ERR,
	VIC_RELEASE_ERR,
	VIC_ISR_REGIST_ERR
} VIC_POST_ERR;

/*--------------------------------------------------------
        WDT
--------------------------------------------------------*/
typedef enum
{
	WDT_NO_ERR,
	// Pre-driver func error
	WDT_SETMODE_ERR,
	WDT_OPER_ERR
	// Post-driver func error
} WDT_POST_ERR;

#endif // __POST_ERROR_H__