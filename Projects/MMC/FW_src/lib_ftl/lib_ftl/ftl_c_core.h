#ifndef _FTL_C_CORE_H_
#define	_FTL_C_CORE_H_


/****************************************************************************
 *
 *            Copyright (c) 2005-2006 by HCC Embedded
 *
 * This software is copyrighted by and is the sole property of
 * HCC.  All rights, title, ownership, or other interests
 * in the software remain the property of HCC.  This
 * software may only be used in accordance with the corresponding
 * license agreement.  Any unauthorized use, duplication, transmission,
 * distribution, or disclosure of this software is expressly forbidden.
 *
 * This Copyright notice may not be removed or modified without prior
 * written consent of HCC.
 *
 * HCC reserves the right to modify this software without notice.
 *
 * HCC Embedded
 * Budapest 1132
 * Victor Hugo Utca 11-15
 * Hungary
 *
 * Tel:  +36 (1) 450 1302
 * Fax:  +36 (1) 450 1303
 * http: www.hcc-embedded.com
 * email: info@hcc-embedded.com
 *
 ***************************************************************************/
 /*----------------------------------------------------------
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "../lib_nand/ftl_l_layer.h"
#include "ftl_t_define.h"
#include "ftl_o_rw.h"
#include "ftl_w_wear.h"

/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/

typedef struct
{
	smtUint8 	num;
	smtUint8	nextIdx;
	smtUint8 	lockedCnt;
	ST_LOG 		*curLog;
	ST_LOG 		logs[FTL_LOG_MAXNUM];
	
} ST_LOG_CACHE;


typedef struct
{
	smtUint8		freeBlkNum;
	smtBlkAddr		*freeBlks;
	smtBlkAddr		*fragBuf;
	ST_MAPINFO		*mapInfo;
	ST_STATIC		*staticInfo;
	
} ST_FLUSH_DATA;


typedef struct
{
	smtUint32 		maxMapCntL;
	smtUint32		maxMapCntH;
	smtFrag			maxFragPerMapBlk;
	ST_MAPBLOCK		*stepback;
	ST_MAPBLOCK		mapBlks[FTL_MAPBLOCK_NUM];
	
} ST_MAP_BLOCKS;

/*
/////////////////////////////////////////////////////////
        GLOBAL VARIABLE  
///////////////////////////////////////////////////////// 
*/

extern smtBoolean 		gfSaveMapNeed;

extern unsigned char 	ml_basebuff[FTL_DATA_MAXSIZE + FTL_SPARE_MAXSIZE];
extern unsigned char 	ml_buffer[FTL_PAGE_MAXSIZE]; 

//extern ST_MAPDIR 		gpMapDir[FTL_FRAG_MAXNUM];
extern ST_MAPDIR 		*gpMapDir;
extern ST_FRAG 			*gpFragCache;
extern ST_LOG_CACHE		*gpLogCache;
extern ST_FLUSH_DATA	*gpFlush;
extern ST_MAP_BLOCKS	*gpMapBlocks;
/*
/////////////////////////////////////////////////////////
        FUNCTIONS 
///////////////////////////////////////////////////////// 
*/
extern smtBoolean	FTL_C_LoadFrag		(smtFrag frag);
extern smtBoolean	FTL_C_WriteFrag		(smtFrag frag, smtUint8 *buff);
extern void 		FTL_C_GetFrag		(smtFrag frag, smtUint8 *dest);
extern smtBoolean	FTL_C_CollectFrag	(ST_MAPBLOCK *mapblock);

extern smtBlkAddr	FTL_C_GetPhy		(smtBlkAddr lba);
extern smtBlkAddr 	FTL_C_SetPhy		(smtBlkAddr lba,smtBlkAddr pba);

extern smtUint8		FTL_C_AllocBlk		(void);
extern void 		FTL_C_AllocLog		(ST_LOG *log,smtBlkAddr lba);
extern void	 		FTL_C_AllocMapBlk	(ST_MAPBLOCK *mapblock);
extern ST_MAPBLOCK *FTL_C_GetfMapBlk	(smtFrag frag);
extern ST_LOG* 		FTL_C_FindLog		(smtBlkAddr lba);
extern t_bit 		FTL_C_StoreMappage	(ST_MAPBLOCK *mapblock);
extern t_bit 		FTL_C_SaveMap		(void);

#endif	// _FTL_C_CORE_H_