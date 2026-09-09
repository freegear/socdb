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
#include <string.h>
#include "../lib_nand/ftl_l_layer.h"
#include "ftl_t_define.h"
#include "ftl_o_rw.h"
#include "ftl_w_wear.h"
#include "ftl_c_core.h"
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/
#define	FTL_WEARDATA_OFFSET		(256)
#define	FTL_FRAGCACHE_OFFSET	((1024+256))
#define	FTL_LOGCACHE_OFFSET		(FTL_FRAGCACHE_OFFSET+sizeof(ST_FRAG))
#define	FTL_FLUSHDATA_OFFSET	(FTL_LOGCACHE_OFFSET+sizeof(ST_LOG_CACHE))
#define	FTL_MAPBLOCK_OFFSET		(FTL_FLUSHDATA_OFFSET+sizeof(ST_MAP_BLOCKS))
#define	FTL_MAPDIR_OFFSET		(FTL_MAPBLOCK_OFFSET+sizeof(ST_MAP_BLOCKS))

/*
/////////////////////////////////////////////////////////
        GLOBAL VARIABLE
///////////////////////////////////////////////////////// 
*/
// NAND device information
smtUint8 			ml_basebuff[FTL_DATA_MAXSIZE+FTL_SPARE_MAXSIZE];
smtUint8 			ml_buffer[FTL_PAGE_MAXSIZE]; 
FTL_DEV_INFO		gDevInfo;	
smtBoolean 			gfSaveMapNeed;
WEAR_ALLOCSTRUCT	*gpWearAllocData	= (WEAR_ALLOCSTRUCT*)&ml_basebuff[FTL_WEARDATA_OFFSET];
ST_FRAG 			*gpFragCache		= (ST_FRAG*)&ml_basebuff[FTL_FRAGCACHE_OFFSET];
ST_LOG_CACHE		*gpLogCache			= (ST_LOG_CACHE*)&ml_basebuff[FTL_LOGCACHE_OFFSET];
ST_FLUSH_DATA		*gpFlush			= (ST_FLUSH_DATA*)&ml_basebuff[FTL_FLUSHDATA_OFFSET];
ST_MAP_BLOCKS		*gpMapBlocks		= (ST_MAP_BLOCKS*)&ml_basebuff[FTL_MAPBLOCK_OFFSET];
ST_MAPDIR			*gpMapDir			= (ST_MAPDIR*)&ml_basebuff[FTL_MAPDIR_OFFSET];

/*
/////////////////////////////////////////////////////////
        STATIC VARIABLE
///////////////////////////////////////////////////////// 
*/
/*
/////////////////////////////////////////////////////////
        FUNCTIONS 
///////////////////////////////////////////////////////// 
*/

