/*----------------------------------------------------------
	File Name   : dmac.h
	Description : DMA controller API code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/
#ifndef _DMAC_H_
#define _DMAC_H_

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void DMACEnable(smtUint8 channel);
void DMACDisable(smtUint8 channel);
void DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth, smtUint32 DestAddr,  smtBoolean DstIncrease, smtUint8 DWidth, smtUint8 TransSize, smtUint16 TotalSize);
void DMACUseDescrp(smtUint8 channel, smtUint32 FirstDescAddr);
void DMACMemCopy(smtUint8 channel, unsigned char *dest, unsigned char *src, unsigned nbytes);
/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
#endif
