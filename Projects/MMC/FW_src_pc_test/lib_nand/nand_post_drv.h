/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: nand_post_drv.h
	Description		: nand post driver header file
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __NAND_POST_DRV_H__
#define __NAND_POST_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "sysinc.h"
#include "../lib_nand/ftl_l_layer.h"
#include "nand_pre_drv.h"
/*
/////////////////////////////////////////////////////////
        TYPEDEF
///////////////////////////////////////////////////////// 
*/
#if 0
typedef enum
{
	DATA_7BIT,
	DATA_8BIT
} UartDataBit;
#endif
#if 0
typedef struct
{
	smtUint32	pba;	// block addr
	smtUint8	ppa;	// page addr in block
	smtUint16	col;	// col addr in page
	smtUint16	size; 	// size to read/write
	void *		buffer;
}NandRWInfo;
#endif

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/

void smt2NANDInit(void);
smtBoolean smt2NANDDeInit(void);
smtBoolean smt2NANDEraseMul(smtBlkAddr pba);
smtBoolean smt2NANDWriteMul(smtBlkAddr pba, smtPageAddr ppo, smtUint8 *buffer);
smtBoolean smt2NANDReadMul(smtBlkAddr pba, smtPageAddr ppo, smtUint8 *buffer);
smtBoolean smt2NANDReadPartMul(smtBlkAddr pba, smtPageAddr ppo, smtUint8 *buffer, smtUint8 index);

#endif //__NAND_POST_DRV_H__



