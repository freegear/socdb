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
#define MAX_BLOCK_AVAILABLE				(8192)				
#define MAX_PAGE_PER_BLOCK_AVAILABLE	(300)//(128)//(64)				
#define MAX_FREE_BLOCK_AVAILABLE		(40)			
#define MAX_LOG_BLOCK_AVAILABLE			(2)					
#define	FTL_MAPBLOCK_NUM				(4)
#define	FTL_MAPBLOCK_DEPTH				(3)	
#define MAX_CACHEFRAG					(1)			

//-----------------------------------------------------------
// make Size define
//-----------------------------------------------------------

#define MAX_DATA_SIZE   				(2048)
#define MAX_SPARE_SIZE  				(16*4)
#define MAX_PAGE_SIZE	 				(MAX_DATA_SIZE + MAX_SPARE_SIZE)
//-----------------------------------------------------------
// make Fragment size
//-----------------------------------------------------------
#define MAX_FRAGSIZE 					((gDevInfo.pageSize/2)/sizeof (smtBlkAddr))
#define MAX_FRAGNUM_AVAILABLE  			(MAX_BLOCK_AVAILABLE/(2048/2/sizeof (smtBlkAddr)))
#endif	//_FTL_C_CONFIG_H_