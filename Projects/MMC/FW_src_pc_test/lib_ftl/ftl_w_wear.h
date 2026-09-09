#ifndef _FTL_W_WEAR_H_
#define _FTL_W_WEAR_H_

/****************************************************************************
 *
 *            Copyright (c) 2005 by HCC Embedded
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
#ifdef __cplusplus
extern "C" {
#endif
/*
/////////////////////////////////////////////////////////
        DEFINE
///////////////////////////////////////////////////////// 
*/
#define WEAR_STATIC_LIMIT  	1024       	// minimum limit in static wear checking 
#define WEAR_STATIC_COUNT  	1023       	// number of allocation when to check static 
#define MAXSTATICWEAR 		8			// maximum deep of static wear leveling 

#define WEAR_NA        0xfffffffeUL  /* if entry is not available */

/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/
typedef struct 
{
	unsigned char free_index;        /* zero based index in freeblock table */
	unsigned long free_wear;         /* free block wear info */
	smtBlkAddr static_lba;				 /* logical block address */
	unsigned long static_wear;       /* static block wear info */
} WEAR_ALLOCSTRUCT;

typedef struct 
{
	smtBlkAddr lba;
	unsigned long wear;
} STATIC_WEAR_INFO;

typedef struct 
{
	smtUint32			cnt;		// counter for static wearing */
	smtBlkAddr 				lba;		   /* current lba for static wear */
	STATIC_WEAR_INFO	wear_info[MAXSTATICWEAR];
	smtUint8			dynamic_index; /* dynamic wear alloc index */
} ST_STATIC;

/*
/////////////////////////////////////////////////////////
        GLOBAL VARIABLE  
///////////////////////////////////////////////////////// 
*/
extern WEAR_ALLOCSTRUCT gWearAllocInfo;
/*
/////////////////////////////////////////////////////////
        FUNCTIONS 
///////////////////////////////////////////////////////// 
*/
extern void			FTL_W_Init(ST_STATIC *ptr);
extern smtBoolean	FTL_W_ChkStatic(void);
extern void			FTL_W_AllocWear(void);
extern void			FTL_W_UpdateDInfo(smtUint8 index, smtUint32 wear);
extern void			FTL_W_ReleaseDLock(void);
extern void			FTL_W_UpdateSInfo(smtBlkAddr lba, smtUint32 wear);

extern smtBlkAddr	FTL_W_GetStaticLBA(void);
extern void			FTL_W_SetStaticLBA(smtBlkAddr lba);

#ifdef __cplusplus
}
#endif

#endif	// _FTL_W_WEAR_H_
