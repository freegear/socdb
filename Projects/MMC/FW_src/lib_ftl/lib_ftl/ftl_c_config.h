#ifndef _FTL_C_CONFIG_H_
#define	_FTL_C_CONFIG_H_


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
/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/
/*
/////////////////////////////////////////////////////////
        GLOBAL VARIABLE  
///////////////////////////////////////////////////////// 
*/
/*
/////////////////////////////////////////////////////////
        FUNCTIONS 
///////////////////////////////////////////////////////// 
*/


/*
/////////////////////////////////////////////////////////
		MACRO DEFINITION
/////////////////////////////////////////////////////////
*/								
//-----------------------------------------------------------
// FTL define
//-----------------------------------------------------------
#define FTL_BLOCK_MAXNUM				(8192)		// FTL max block avail
#define FTL_PAGEPERBLOCK_MAXNUM			(64)		// FTL max Page/block
#define FTL_FREEBLK_MAXNUM				(30)		// FTL max free block
#define FTL_LOG_MAXNUM					(3)			// FTL max log block available
#define	FTL_MAPBLOCK_NUM				(4)			// FTL max mapblock number
#define	FTL_MAPBLOCK_DEPTH				(2)			// FTL max depth 
//-----------------------------------------------------------
// Size define
//-----------------------------------------------------------
#define FTL_DATA_MAXSIZE   				(2048)
#define FTL_SPARE_MAXSIZE  				(sizeof(ST_SPARE))
#define FTL_PAGE_MAXSIZE	 			(FTL_DATA_MAXSIZE + FTL_SPARE_MAXSIZE)
//-----------------------------------------------------------
// Fragment size define
//-----------------------------------------------------------
#define	FTL_FRAG_POOLSIZE				(256)
#define FTL_FRAG_POOLPERNUM 			(FTL_FRAG_POOLSIZE/sizeof (smtBlkAddr))
#define	FTL_FRAG_MAXNUM					(FTL_BLOCK_MAXNUM/(FTL_FRAG_POOLSIZE/sizeof(smtBlkAddr)))


#endif	//_FTL_C_CONFIG_H_