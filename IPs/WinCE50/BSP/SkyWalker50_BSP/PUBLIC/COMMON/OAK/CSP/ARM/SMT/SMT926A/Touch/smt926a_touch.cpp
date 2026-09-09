//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
/*++
THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
PARTICULAR PURPOSE.
Copyright (c) 2002. Samsung Electronics, co. ltd  All rights reserved.

Module Name:  

Abstract:

    Platform dependent TOUCH initialization functions

rev:
	2002.4.27	: smt926 port (Hoyjoon Kim)

Notes: 
--*/


#include <windows.h>
#include <types.h>
#include <memory.h>
#include <nkintr.h>
#include <tchddsi.h>
#include <nkintr.h>

#include <smt926a.h>

#define PUBLIC		
#define PRIVATE							static

#define TSP_SAMPLE_RATE_LOW				50
#define TSP_SAMPLE_RATE_HIGH			100
#define TSP_SAMPLETICK_LOW					(17 * 1000 / TSP_SAMPLE_RATE_LOW)
#define TSP_SAMPLETICK_HIGH					(17 * 1000 / TSP_SAMPLE_RATE_HIGH)

#define ADCPRS							49 // 200

#define TSP_MINX						85
#define TSP_MINY						105

#define TSP_MAXX						965
#define TSP_MAXY						980

#define TSP_CHANGE						15
#define TSP_INVALIDLIMIT				40


#define TSP_LCDX						(LCD_XSIZE_TFT * 4)
#define TSP_LCDY						(LCD_YSIZE_TFT * 4)

#define	TSP_SAMPLE_NUM					4 

#define OAL_INTR_FORCE_STATIC       (1 << 2)

DWORD gIntrTouch        = SYSINTR_NOP;
DWORD gIntrTouchChanged = SYSINTR_NOP;

extern "C" const int MIN_CAL_COUNT   = 1;

PRIVATE INT TSP_CurRate = 1;

PRIVATE volatile SMT926A_IOPORT_REG * v_pIOPregs;
PRIVATE volatile SMT926A_ADC_REG * v_pADCregs;
PRIVATE volatile SMT926A_INTR_REG * v_pINTregs;
PRIVATE volatile SMT926A_PWM_REG * v_pPWMregs;

PRIVATE BOOL	 bTSP_DownFlag;

VOID	TSP_VirtualFree(VOID);
BOOL	TSP_VirtualAlloc(VOID);

PRIVATE PVOID
TSP_RegAlloc(PVOID addr, INT sz)
{
	PVOID reg;

	reg = (PVOID)VirtualAlloc(0, sz, MEM_RESERVE, PAGE_NOACCESS);

	if (reg)
	{
		if (!VirtualCopy(reg, (PVOID)((UINT32)addr >> 8), sz, PAGE_PHYSICAL | PAGE_READWRITE | PAGE_NOCACHE )) 
		{
			VirtualFree(reg, sz, MEM_RELEASE);
			reg = NULL;
		}
	}

	return reg;
}


PRIVATE BOOL
TSP_VirtualAlloc(VOID)
{
	BOOL r = FALSE;

    RETAILMSG(0,(TEXT("::: TSP_VirtualAlloc()\r\n")));

	do
	{
		v_pIOPregs = (volatile SMT926A_IOPORT_REG *)TSP_RegAlloc((PVOID)SMT926A_BASE_REG_PA_IOPORT, sizeof(SMT926A_IOPORT_REG));
		if (v_pIOPregs == NULL) 
		{
			ERRORMSG(1,(TEXT("For IOPreg: VirtualAlloc failed!\r\n")));
			break;
		}
	
		v_pADCregs = (volatile SMT926A_ADC_REG *)TSP_RegAlloc((PVOID)SMT926A_BASE_REG_PA_ADC, sizeof(SMT926A_ADC_REG));
		if (v_pADCregs == NULL) 
		{
	    	ERRORMSG(1,(TEXT("For ADCreg: VirtualAlloc failed!\r\n")));
		    break;
		}

		v_pINTregs = (volatile SMT926A_INTR_REG *)TSP_RegAlloc((PVOID)SMT926A_BASE_REG_PA_INTR, sizeof(SMT926A_INTR_REG));
		if (v_pADCregs == NULL) 
		{
	    	ERRORMSG(1,(TEXT("For INTregs: VirtualAlloc failed!\r\n")));
		    break;
		}

		v_pPWMregs = (volatile SMT926A_PWM_REG *)TSP_RegAlloc((PVOID)SMT926A_BASE_REG_PA_PWM, sizeof(SMT926A_PWM_REG));
		if (v_pPWMregs == NULL) 
		{
	    	ERRORMSG(1,(TEXT("For PWMregs: VirtualAlloc failed!\r\n")));
		    break;
		}
		
		r = TRUE;
	} while (0);

	if (!r)
	{
		TSP_VirtualFree();

		RETAILMSG(0,(TEXT("::: TSP_VirtualAlloc() - Fail\r\n")));
	}
	else
	{
		RETAILMSG(0,(TEXT("::: TSP_VirtualAlloc() - Success\r\n")));
	}


	return r;
}

PRIVATE void
TSP_VirtualFree(VOID)
{
    RETAILMSG(0,(TEXT("::: TSP_VirtualFree()\r\n")));

	if (v_pIOPregs)
    {
        VirtualFree((PVOID)v_pIOPregs, sizeof(SMT926A_IOPORT_REG), MEM_RELEASE);
        v_pIOPregs = NULL;
    }
    if (v_pADCregs)
    {   
        VirtualFree((PVOID)v_pADCregs, sizeof(SMT926A_ADC_REG), MEM_RELEASE);
        v_pADCregs = NULL;
    } 
    if (v_pINTregs)
    {   
        VirtualFree((PVOID)v_pINTregs, sizeof(SMT926A_INTR_REG), MEM_RELEASE);
        v_pINTregs = NULL;
    } 
    if (v_pPWMregs)
    {   
        VirtualFree((PVOID)v_pPWMregs, sizeof(SMT926A_PWM_REG), MEM_RELEASE);
        v_pPWMregs = NULL;
    } 
}

PRIVATE VOID
TSP_SampleStart(VOID)
{
	DWORD tmp;

	tmp = v_pPWMregs->TCON & (~(0xf << 16));

	v_pPWMregs->TCON = tmp | (2 << 16);		/* update TCVNTB3, stop					*/
	v_pPWMregs->TCON = tmp | (9 << 16);		/* interval mode,  start				*/
//	v_pPWMregs->TCON = tmp | (1 << 16);		/* one-shot mode,  start				*/
}

PRIVATE VOID
TSP_SampleStop(VOID)
{
	v_pPWMregs->TCON &= ~(1 << 16);			/* Timer3, stop							*/
}


PRIVATE VOID
TSP_PowerOn(VOID)
{
    RETAILMSG(0,(TEXT("::: TSP_PowerOn()\r\n")));


	v_pADCregs->ADCDLY = 40000;	
    v_pADCregs->ADCCON = (1<<14) | (ADCPRS<< 6) | (7<<3);	

	v_pADCregs->ADCTSC = (0<<8)|(1<<7)|(1<<6)|(0<<5)|(1<<4)|(0<<3)|(0<<2)|(3);	

	v_pINTregs->INTSUBMSK  &= ~(1<<IRQ_SUB_TC);
    
  	v_pPWMregs->TCFG1  &= ~(0xf << 12);		/* Timer3's Divider Value				*/
  	v_pPWMregs->TCFG1  |=  (3   << 12);		/* 1/16									*/
    v_pPWMregs->TCNTB3  = TSP_SAMPLETICK_HIGH;	/* Interrupt Frequency					*/
	// v_pPWMregs->TCMPB3  = 0;		/**/
}

PRIVATE VOID
TSP_PowerOff(VOID)
{
    RETAILMSG(0,(TEXT("::: TSP_PowerOff()\r\n")));

    v_pINTregs->INTSUBMSK |= (1<<IRQ_SUB_TC);
}

PRIVATE BOOL
TSP_CalibrationPointGet(TPDC_CALIBRATION_POINT *pTCP)
{
    
	INT32	cDisplayWidth  = pTCP->cDisplayWidth;
	INT32	cDisplayHeight = pTCP->cDisplayHeight;

	int	CalibrationRadiusX = cDisplayWidth  / 20;
	int	CalibrationRadiusY = cDisplayHeight / 20;

	switch (pTCP -> PointNumber)
	{
	case	0:
		pTCP->CalibrationX = cDisplayWidth  / 2;
		pTCP->CalibrationY = cDisplayHeight / 2;
		break;

	case	1:
		pTCP->CalibrationX = CalibrationRadiusX * 2;
		pTCP->CalibrationY = CalibrationRadiusY * 2;
		break;

	case	2:
		pTCP->CalibrationX = CalibrationRadiusX * 2;
		pTCP->CalibrationY = cDisplayHeight - CalibrationRadiusY * 2;
		break;

	case	3:
		pTCP->CalibrationX = cDisplayWidth  - CalibrationRadiusX * 2;
		pTCP->CalibrationY = cDisplayHeight - CalibrationRadiusY * 2;
		break;

	case	4:
		pTCP->CalibrationX = cDisplayWidth - CalibrationRadiusX * 2;
		pTCP->CalibrationY = CalibrationRadiusY * 2;
		break;

	default:
		pTCP->CalibrationX = cDisplayWidth  / 2;
		pTCP->CalibrationY = cDisplayHeight / 2;

		SetLastError(ERROR_INVALID_PARAMETER);
		return FALSE;
	}

	return TRUE;
}

PRIVATE void
TSP_TransXY(INT *px, INT *py)
{
	*px = (*px - TSP_MINX) * TSP_LCDX / (TSP_MAXX - TSP_MINX);
	*py = (*py - TSP_MINY) * TSP_LCDY / (TSP_MAXY - TSP_MINY);

	if (*px  <        0) *px = 0;
	if (*px >= TSP_LCDX) *px = TSP_LCDX - 1;

	if (*py  <        0) *py = 0;
	if (*py >= TSP_LCDY) *py = TSP_LCDY - 1;
}

PRIVATE BOOL
TSP_GetXY(INT *px, INT *py)
{
	INT i;
	INT xsum, ysum;
	INT x, y;
	INT dx, dy;

	xsum = ysum = 0;

	for (i = 0; i < TSP_SAMPLE_NUM; i++)
	{
		v_pADCregs->ADCTSC = (0<<8)|(1<<7)|(1<<6)|(0<<5)|(1<<4)|(1<<3)|(1<<2)|(0);			
		v_pADCregs->ADCCON |= (1 << 0);				/* Start Auto conversion				*/

		while (v_pADCregs->ADCCON & 0x1);				/* check if Enable_start is low			*/
		while (!(v_pADCregs->ADCCON & (1 << 15)));		/* Check ECFLG							*/

		x = (0x3ff & v_pADCregs->ADCDAT1);
		y = 0x3ff - (0x3ff & v_pADCregs->ADCDAT0);
		xsum += x;
		ysum += y;
	}
	
	*px = xsum / TSP_SAMPLE_NUM;
	*py = ysum / TSP_SAMPLE_NUM;

	v_pADCregs->ADCTSC = (1<<8)|(1<<7)|(1<<6)|(0<<5)|(1<< 4)|(0<<3)|(0<<2)|(3);				
	dx = (*px > x) ? (*px - x) : (x - *px);
	dy = (*py > y) ? (*py - y) : (y - *py);

	return ((dx > TSP_INVALIDLIMIT || dy > TSP_INVALIDLIMIT) ? FALSE : TRUE);
}

/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */

PUBLIC BOOL
DdsiTouchPanelGetDeviceCaps(INT	iIndex, LPVOID  lpOutput)
{

	if ( lpOutput == NULL )
	{
		ERRORMSG(1, (__TEXT("TouchPanelGetDeviceCaps: invalid parameter.\r\n")));
		SetLastError(ERROR_INVALID_PARAMETER);
		DebugBreak();
		return FALSE;
	}

	switch	( iIndex )
	{
	case TPDC_SAMPLE_RATE_ID:
		{
			TPDC_SAMPLE_RATE	*pTSR = (TPDC_SAMPLE_RATE*)lpOutput;
			RETAILMSG(0, (TEXT("TouchPanelGetDeviceCaps::TPDC_SAMPLE_RATE_ID\r\n")));

			pTSR->SamplesPerSecondLow      = TSP_SAMPLE_RATE_LOW;
			pTSR->SamplesPerSecondHigh     = TSP_SAMPLE_RATE_HIGH;
			pTSR->CurrentSampleRateSetting = TSP_CurRate;
		}
		break;

	case TPDC_CALIBRATION_POINT_COUNT_ID:
		{
			TPDC_CALIBRATION_POINT_COUNT *pTCPC = (TPDC_CALIBRATION_POINT_COUNT*)lpOutput;
			RETAILMSG(0, (TEXT("TouchPanelGetDeviceCaps::TPDC_CALIBRATION_POINT_COUNT_ID\r\n")));

			pTCPC->flags              = 0;
			pTCPC->cCalibrationPoints = 5;
		}
		break;

	case TPDC_CALIBRATION_POINT_ID:
		RETAILMSG(0, (TEXT("TouchPanelGetDeviceCaps::TPDC_CALIBRATION_POINT_ID\r\n")));
		return(TSP_CalibrationPointGet((TPDC_CALIBRATION_POINT*)lpOutput));

	default:
		ERRORMSG(1, (__TEXT("TouchPanelGetDeviceCaps: invalid parameter.\r\n")));
		SetLastError(ERROR_INVALID_PARAMETER);
		DebugBreak();
		return FALSE;

	}

	return TRUE;
}

/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
PUBLIC BOOL
DdsiTouchPanelSetMode(INT iIndex, LPVOID  lpInput)
{
    BOOL  ReturnCode = FALSE;

	RETAILMSG(0, (TEXT("::: DdsiTouchPanelSetMode()\r\n")));

    switch ( iIndex )
    {
	case TPSM_SAMPLERATE_LOW_ID:
		TSP_CurRate = 0;
		v_pPWMregs->TCNTB3  = TSP_SAMPLETICK_LOW;
		SetLastError( ERROR_SUCCESS );
		ReturnCode = TRUE;
		break;
	case TPSM_SAMPLERATE_HIGH_ID:
		TSP_CurRate = 1;
		v_pPWMregs->TCNTB3  = TSP_SAMPLETICK_HIGH;
		SetLastError( ERROR_SUCCESS );
		ReturnCode = TRUE;
		break;

	default:
		SetLastError( ERROR_INVALID_PARAMETER );
		break;
    }


    return ( ReturnCode );
}

/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */

PUBLIC BOOL
DdsiTouchPanelEnable(VOID)
{
    BOOL r;
    UINT32 Irq[3]={-1,OAL_INTR_FORCE_STATIC,0};

	r = TSP_VirtualAlloc();

	if (r) 
	{
		TSP_PowerOn();
	}

    // Obtain sysintr values from the OAL for the touch and touch changed interrupts.
    //
	RETAILMSG(0, (TEXT("enable touch sysintr.\r\n")));
    Irq[0]=-1;Irq[1]=OAL_INTR_FORCE_STATIC;Irq[2]=IRQ_ADC;
    if (!KernelIoControl(IOCTL_HAL_REQUEST_SYSINTR, &Irq, sizeof(Irq), &gIntrTouch, sizeof(UINT32), NULL))
    {
        RETAILMSG(1, (TEXT("ERROR: Failed to request the touch sysintr.\r\n")));
        gIntrTouch = SYSINTR_UNDEFINED;
        return(FALSE);
    }
    Irq[0]=-1;Irq[1]=OAL_INTR_FORCE_STATIC;Irq[2]=IRQ_TIMER3;
    if (!KernelIoControl(IOCTL_HAL_REQUEST_SYSINTR, &Irq, sizeof(Irq), &gIntrTouchChanged, sizeof(UINT32), NULL))
    {
        RETAILMSG(1, (TEXT("ERROR: Failed to request the touch changed sysintr.\r\n")));
        gIntrTouchChanged = SYSINTR_UNDEFINED;
        return(FALSE);
    }


    return r;
}



/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */

PUBLIC VOID
DdsiTouchPanelDisable(VOID)
{
    if (v_pADCregs) 
	{
	    TSP_PowerOff();
		TSP_VirtualFree();
	}
}

/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */

LONG
DdsiTouchPanelAttach(VOID)
{
    return (1);
}


LONG
DdsiTouchPanelDetach(VOID)
{
    return (0);
}


/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
PUBLIC VOID
DdsiTouchPanelPowerHandler(BOOL	bOff)
{
	RETAILMSG(0, (TEXT("::: DdsiTouchPanelPowerHandler()\r\n")));
    if (bOff)
	{
        TSP_PowerOff();
    }
    else
	{
        TSP_PowerOn();
    }
}


/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */
/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: */



PUBLIC VOID
DdsiTouchPanelGetPoint(TOUCH_PANEL_SAMPLE_FLAGS	* pTipStateFlags,
					   INT	* pUncalX,
					   INT	* pUncalY)
{
	static INT x, y;

	if (v_pINTregs->SUBSRCPND & (1<<IRQ_SUB_TC))		/* SYSINTR_TOUCH Interrupt Case				*/
	{
		*pTipStateFlags = TouchSampleValidFlag;

		if ( (v_pADCregs->ADCDAT0 & (1 << 15)) |
			 (v_pADCregs->ADCDAT1 & (1 << 15)) )
		{
			bTSP_DownFlag = FALSE;

			DEBUGMSG(ZONE_TIPSTATE, (TEXT("up\r\n")));

			v_pADCregs->ADCTSC &= 0xff;

			*pUncalX = x;
			*pUncalY = y;

			TSP_SampleStop();
		}
		else 
		{
			bTSP_DownFlag = TRUE;

			if (!TSP_GetXY(&x, &y)) 
				*pTipStateFlags = TouchSampleIgnore;

			TSP_TransXY(&x, &y);

			*pUncalX = x;
			*pUncalY = y;

			*pTipStateFlags |= TouchSampleDownFlag;

			//DEBUGMSG(ZONE_TIPSTATE, (TEXT("down %x %x\r\n"), x, y));

			TSP_SampleStart();
		}

		v_pINTregs->SUBSRCPND  =  (1<<IRQ_SUB_TC);
		v_pINTregs->INTSUBMSK &= ~(1<<IRQ_SUB_TC);

		InterruptDone(gIntrTouch);
	}
	else		/* SYSINTR_TOUCH_CHANGED Interrupt Case		*/
	{
//		TSP_SampleStart();
		
		if (bTSP_DownFlag)
		{
			INT  tx, ty;
			INT  dx, dy;

			if (!TSP_GetXY(&tx, &ty)) 
				*pTipStateFlags = TouchSampleIgnore;
			else 
			{
				TSP_TransXY(&tx, &ty);
// insert by mostek@dstcorp.com
#define X_ERRV	0x3bf
#define Y_ERRV	0x4ff

				if ((tx == X_ERRV) && (ty == Y_ERRV))
				{
					tx = x;
					ty = y;
				} 
// =================== mostek
				dx = (tx > x) ? (tx - x) : (x - tx);
				dy = (ty > y) ? (ty - y) : (y - ty);

				if (dx > TSP_CHANGE || dy > TSP_CHANGE)
				{
					*pUncalX = x = tx;
					*pUncalY = y = ty;

					//DEBUGMSG(ZONE_TIPSTATE, (TEXT("down-c-v %x %x\r\n"), x, y));
					*pTipStateFlags = TouchSampleValidFlag | TouchSampleDownFlag;
				}
				else
				{
					*pUncalX = x;
					*pUncalY = y;

					DEBUGMSG(ZONE_TIPSTATE, (TEXT("down-c %x %x\r\n"), x, y));

					*pTipStateFlags = TouchSampleIgnore;
				}
			}
		}
		else
		{
			*pTipStateFlags = TouchSampleIgnore;

			TSP_SampleStop();
		}

		InterruptDone(gIntrTouchChanged);
	}
}

