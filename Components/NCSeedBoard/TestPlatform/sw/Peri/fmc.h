/*----------------------------------------------------------
    File Name   : fmc.h
    Description : FMC header file
-----------------------------------------------------------*/
#ifndef	__FMC_H__
#define	__FMC_H__

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

smtUint32 RegisterChk(void);
smtUint32 ProgNormalTest(void);
smtUint32 Prog2Page(void);
smtUint32 ProgOptionTest(void);
smtUint32 EraseSectorTest(void);
smtUint32 EraseChipTest(void);
void FlashMemWrite(FM_STRUCT flashWrite);
smtUint32 FlashMemRead(smtUint32 addr);

static void OutErrCode(smtUint32 errCode);

#endif /* __FMC_H__ */
