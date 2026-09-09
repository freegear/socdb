/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: nand_pre_drv.h
	Description		: nand pre driver header file
	Created by		: SHMT SOC Team
-----------------------------------------------------------*/
#ifndef __NAND_PRE_DRV_H__
#define __NAND_PRE_DRV_H__

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "sysinc.h"
#include "../lib_nand/ftl_l_layer.h"
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

typedef struct
{
	smtBlkAddr	pba;	// block addr
	smtPageAddr	ppa;	// page addr in block
	smtUint16	col;	// col addr in page
	smtUint16	size; 	// size to read/write
	void *		buffer;
}NandRWInfo;

//
//	address define
//
#define	ADDRESS0(c)						((c) & 0xFF)					// A00 ~ A07
#define	ADDRESS1(c)                 	(((c) >> 8) & 0xF)				// A08 ~ A11
#define	ADDRESS2(p, b)                 	((((b) & 0x3)<<6)|((p) & 0x3F))	// A12 ~ a19 
#define	ADDRESS3(b)                 	(((b) >> 2) & 0xFF)				// A20 ~ A27
#define	ADDRESS4(b)                 	(((b) >> 10) & 0x3)				// A28 ~ A29

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////////
*/

void		smtNANDInit(void);
smtBoolean	smtNANDDeinit(void);
smtBoolean	smtNANDErase(smtUint8 bank, smtUint16 pba);
smtBoolean	smtNANDWrite(smtUint8 bank, NandRWInfo *pMain, NandRWInfo *pSpare);
smtBoolean	smtNANDRead(smtUint8 bank, NandRWInfo *pMain, NandRWInfo *pSpare);

void		smtNAND1Init(void);
smtBoolean	smtNAND1Deinit(void);
smtBoolean	smtNAND1Erase(smtUint8 bank, smtUint16 pba);
smtBoolean	smtNAND1Write(smtUint8 bank, NandRWInfo *pMain, NandRWInfo *pSpare);
smtBoolean	smtNAND1Read(smtUint8 bank, NandRWInfo *pMain, NandRWInfo *pSpare);
#endif //__NAND_PRE_DRV_H__


