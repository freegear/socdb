/*----------------------------------------------------------
    File Name   : apilcd.h
    Description : lcd header file of SDI v5
-----------------------------------------------------------*/
#ifndef	__LCD_H__
#define	__LCD_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"

typedef struct {
	//smtUint8 plane;
	//smtUint8 alpha;

	smtUint8 pixelFMT;
	smtUint16 width;
	smtUint16 height;

	//smtUint32 position;
	smtUint32 frameAddr;
} LCDSTRUCT;
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

void LCDEnable(smtUint32 enablePlane);
void LCDDisable(smtUint32 disablePlane);
void LCDInitialize(void);
void LCDSetMode(LCDSTRUCT lcdMode);

#endif /* __LCD_H__ */
