/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
    File name	: adc.h
    Description	: adc controller header file of SDI v5
-----------------------------------------------------------*/
#ifndef	__ADC_H__
#define	__ADC_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void ReadStartSet(void);
void ADENSet(void);
void ADCReadISR(smtUint32 IRQ);
void ADCADENISR(smtUint32 IRQ);

#endif /* __ADC_H__ */
