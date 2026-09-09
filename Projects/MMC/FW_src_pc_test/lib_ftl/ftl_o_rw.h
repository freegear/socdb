#ifndef _FTL_O_RW_H_
#define _FTL_O_RW_H_

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
#include "ftl_t_define.h"
#include "ftl_c_config.h"
#include "lib.h"
/*
/////////////////////////////////////////////////////////
   		DEFINITION
///////////////////////////////////////////////////////// 
*/
//-----------------------------------------------------------
// make BLK_NA define
//-----------------------------------------------------------
// if more than 16K block in the system 
#if MAX_BLOCK_AVAILABLE > 0x4000 						
// if block is not available 
#define BLK_NA         					(0xFFFFFFFFUL)  
#else
// if block is not available 
#define BLK_NA         					(0xFFFF)        
#endif
// if index is not available 
#define INDEX_NA       					(0xFF)         

//-----------------------------------------------------------
// make FT marker
//-----------------------------------------------------------
// if more than 16K block in the system 
#if MAX_BLOCK_AVAILABLE > 0x4000 						
#define	FT_ADDRMASK 					((smtBlkAddr)(0x3FFFFFFFUL))
#define	FT_MAP     						(0x80000000UL)
#define	FT_LOG      					(0x40000000UL)
#define FT_BAD	    					(FT_MAP | FT_LOG)
#else
#define	FT_ADDRMASK 					((smtBlkAddr)0x3FFF)
#define	FT_MAP      					(0x8000)
#define	FT_LOG      					(0x4000)
#define FT_BAD	    					(FT_MAP | FT_LOG)
#endif
// if more than 16K block in the system 
#if (MAX_BLOCK_AVAILABLE > 0x4000) 
	#define FRAG_NA (0xFFFF)
#else
	#define FRAG_NA (0xFF)
#endif
//-----------------------------------------------------------
// make Mlayer state
//-----------------------------------------------------------
enum 
{
	ML_CLOSE,
	ML_PENDING_READ,
	ML_PENDING_WRITE,
	ML_READ,
	ML_WRITE,
	ML_ABORT,
	ML_INIT
};
//-----------------------------------------------------------
// make block types definitions
//-----------------------------------------------------------
#define	BLK_TYPE_DAT  					(0x0F)
// this is original map block value, no ecc required 
#define BLK_TYPE_MAP_ORI 				(0x30)	
// used for masking block type 
#define BLK_TYPE_MASK 					(0xF0) 	
// block type cannot be 0xf0, in this case 2 bit error 
#define BLK_TYPE_INV  					(0xF0)	
// used for masking map block type 
#define BLK_TYPE_MAP_MASK 				(0xF7)	
//  if page contains FLT, a fragment, and other information 
#define BLK_MAPPAGE_FLAG 				(0x08)	
// its not set when page contains original fragment info only 							   					
#define GET_SPARE_AREA(_buf_) 													\
	((ST_SPARE*)(((smtUint8*)(_buf_))+gDevInfo.pageSize))
//-----------------------------------------------------------
// Range check define
//-----------------------------------------------------------
// Check MAX_FREE_BLOCK_AVAILABLE range
#if (MAX_FREE_BLOCK_AVAILABLE > 254)
	#error "MAX_FREE_BLOCK_AVAILABLE	cannot be more than 254"
#endif
// Check fragment max
#if (MAX_CACHEFRAG < 1)
	#error "MAX_CACHEFRAG cannot be less than 1"
#endif
// Check MAX_NUM_OF_DIF_MAPBLOCK range
#if ((FTL_MAPBLOCK_NUM < 1) || (FTL_MAPBLOCK_NUM > 16))
	#error "FTL_MAPBLOCK_NUM cannot be less than 1 or bigger than 16"
#endif
// Check MAX_FREE_BLOCK_AVAILABLE range
#if (																			\
	(MAX_FREE_BLOCK_AVAILABLE													\
	- (FTL_MAPBLOCK_NUM*FTL_MAPBLOCK_DEPTH+1)									\
	- MAX_LOG_BLOCK_AVAILABLE) 													\
	< 8)
	#error "MAX_FREE_BLOCK_AVAILABLE cannot hold this number of blocks"
#endif
// Check MAX_FREE_BLOCK_AVAILABLE range
#if ((MAX_FREE_BLOCK_AVAILABLE*2) > (MAX_DATA_SIZE/2))
	#error "MAX_FREE_BLOCK_AVAILABLE is to large"
#endif

/*
/////////////////////////////////////////////////////////////
	TYPE DEFINITION
/////////////////////////////////////////////////////////////
*/
#ifdef __cplusplus
extern "C" {
#endif

// if more than 16K block in the system 
#if (MAX_BLOCK_AVAILABLE > 0x4000) 
typedef smtUint32	smtBlkAddr; 	// typedef for block address 
typedef smtUint16 	smtFrag;		// fragment type 
#else
typedef smtUint16 	smtBlkAddr; 	// typedef for block address 
typedef smtUint8	smtFrag;		// fragment type 
#endif
typedef smtUint8 	t_bit;			// typedef bit
typedef smtUint8	smtPageAddr; 	// typedef for page offset 
//-----------------------------------------------------------
// ST_SPARE
//-----------------------------------------------------------
typedef struct 
{
	smtUint32	wear;					// spare area 32-bit Wear Leveling Counter 
	smtUint32	ecc;					// space for ECC for lower layer calculation 
	union {

		smtUint8 dummy[8];				// 8 bytes allocated for any structure below 

		struct {
			smtUint8		block_type;		// <must be the 1st byte!>  block type + BLK_MAPPAGE_FLAG flag 
			smtPageAddr 	lpo;			// logged page number 
			smtBlkAddr		lba;			// logged block blongs to this lba 
		} log;

		struct {
			smtUint8 		block_type;		// <must be the 1st byte!>  block type + BLK_MAPPAGE_FLAG flag 
			smtFrag 		frag;			// fragment number if mappage 
			smtUint32 		ref_count;    	// 32bit MAP block reference counter 
		} map;

	} u; // None of the unioned structure size can be bigger than 8 bytes!!
	 
} ST_SPARE;
//-----------------------------------------------------------
// ST_MAPDIR
//-----------------------------------------------------------
typedef struct 
{
	smtBlkAddr		PBA;
	smtPageAddr		PPO;
	smtUint8		index;
} ST_MAPDIR;
//-----------------------------------------------------------
// ST_MAPBLOCK
//-----------------------------------------------------------
typedef struct 
{
	smtBlkAddr 			curPBA;									// current map block address; BLK_NA if we don't have one (fatal error) 
	smtPageAddr 			curPPO;									// current page offset in map 
	smtBlkAddr 			LastPBA;
	smtPageAddr 			LastPPO;								// last good written map situated here 
	smtUint32	 	ref_count;								// last written counter in MAP block 
	smtFrag 			startFragIdx;  	 						// start fragment number in this MAP 
	smtFrag 			endFragIdx;								// end fragment number in this MAP 
	smtUint8	 	blockType;   							// type in the spare area of this block
									
	smtUint8	 	mapPageBlk[FTL_MAPBLOCK_DEPTH];  		// shadow block indexes 
	smtUint8	 	depthIdx;								// current number of MAP blocks 
	
	// only at start up 
	smtUint32	 	mapCntH;
	smtUint32		mapCntL;								// searching for the latest correct 
	
} ST_MAPBLOCK;
//-----------------------------------------------------------
// ST_MAPINFO
//-----------------------------------------------------------
typedef struct 
{
	smtBlkAddr		LastPBA;
	smtPageAddr 		LastPPO;
	smtUint32 	mapCntH;
	smtUint32 	mapCntL;	
	smtUint8 	mapPageBlk[FTL_MAPBLOCK_DEPTH]; 	

} ST_MAPINFO;
//-----------------------------------------------------------
// ST_FRAG
//-----------------------------------------------------------
typedef struct 
{
	smtFrag		num;
	smtBlkAddr		*ppba;
	
} ST_FRAG;
//-----------------------------------------------------------
// ST_LOG
//-----------------------------------------------------------
typedef struct 
{
	smtUint32	wear;
	smtBlkAddr 	lba;			
	smtBlkAddr 	pba;			
	smtUint8 	ppo[MAX_PAGE_PER_BLOCK_AVAILABLE];
	smtUint8 	lastppo;
	smtUint8 	index;
	smtUint8 	switchable;
	
} ST_LOG;
//-----------------------------------------------------------
// FTL_OP_INFO
//-----------------------------------------------------------
typedef struct
{
	smtBlkAddr		PBA;	
	smtBlkAddr		LBA;
	smtPageAddr		LPO;
	smtBoolean		SaveMapNeed;
	
} FTL_OP_INFO;
//-----------------------------------------------------------
// FTL_DEV_INFO
//-----------------------------------------------------------
typedef struct
{
	smtUint32 	blks;
	smtUint8 	pagePerBlks;
	smtUint32 	pageSize;
	smtUint32	spareSize;
	smtUint32	dataBlks;
	
} FTL_DEV_INFO;

extern FTL_OP_INFO	gOpInfo;
extern FTL_DEV_INFO	gDevInfo;
/*
/////////////////////////////////////////////////////////////
		FUNCTION DEFINITION
/////////////////////////////////////////////////////////////
*/
extern smtBoolean		FTL_O_LowInit(void);
extern smtBoolean		FTL_O_Init(void);
extern smtBoolean		FTL_O_Format(void);
extern smtBoolean		FTL_O_BuildCache(void);
extern smtUint32		FTL_O_GetRWBuffer(void);
extern smtBoolean		FTL_O_Open(smtUint32 sector, smtUint32 secnum, smtUint8 mode);
extern smtUint8			FTL_O_Write(smtUint32 sector);
extern smtUint8			FTL_O_Read(smtUint32 sector);
extern smtUint8			FTL_O_Close(void);
extern smtUint32		FTL_O_GetMaxSector(void);

#ifdef __cplusplus
}
#endif

#endif	// _FTL_O_RW_H_ 
