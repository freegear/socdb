/*-------------------------------------------------------------------
File name   : init.h

Description : middle level routines
----------------------------------------------------------------------*/
#ifndef __INIT_H_L
#define __INIT_H_L

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"
#include "structDef.h"
#include "Commonmacro.h"

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void InitUart(void);
void InitI2c(void);
void InitTimer(void);
void InitGpio(void);
void InitAdc(void);
void InitPower(void);

#endif /* __INIT_H_L */
