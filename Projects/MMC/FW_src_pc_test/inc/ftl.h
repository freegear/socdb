/*----------------------------------------------------------
	 MMC controller SOC
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: ftl.h
	Description	: FTL header file
----------------------------------------------------------*/
#ifndef __FTL_H__
#define __FTL_H__

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/

#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

#include "sysinc.h"
#include "structdef.h"
#include "commonmacro.h"

#include "lib.h"
#include "nand.h"

#include "../lib_ftl/ftl_t_define.h"
/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/
	


/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
smtBoolean 	FTL_Format(void);
smtBoolean	FTL_Read(smtUint32 sector, smtUint32 num, smtUint32 buffer);
smtBoolean	FTL_Write(smtUint32 sector, smtUint32 num, smtUint32 buffer);
smtBoolean 	FTL_Init(void);
smtBoolean	FTL_Deinit(void);
smtUint32	FTL_GetMaxSectors(void);
#endif /* __FTL_H__ */

