/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: i2c.h
	Description	: i2c header file of SDI v5
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef	__I2C_H__
#define	__I2C_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
static void I2C0Isr(smtUint32 IRQ);
static void I2C0_AASIsr(smtUint32 IRQ);
static void I2C1Isr(smtUint32 IRQ);
static void I2C1_AASIsr(smtUint32 IRQ);
void I2C1AASHandler(void);
void I2C0_AASTest(void);

#endif /* __I2C_H__ */
