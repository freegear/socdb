/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: init.h
	Description	: Initialize header file
	Created by	: SHMT SOC Team
----------------------------------------------------------*/
#ifndef __INIT_H_L
#define __INIT_H_L

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
//void InitUart(void); //shkim-20070109 : remove this line
void InitI2c(void);
void InitTimer(void);
void InitGpio(void);
void InitAdc(void);
void InitPower(void);

#endif /* __INIT_H_L */
