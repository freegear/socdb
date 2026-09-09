/*----------------------------------------------------------
	 MMC controller SOC
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2007 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: k9lag08u0m.h
	Description	: K9LAG08U0M configration file
----------------------------------------------------------*/
#ifndef __K9LAG08U0M_H__
#define __K9LAG08U0M_H__

/*
/////////////////////////////////////////////////////////
	INCLUDE
///////////////////////////////////////////////////////// 
*/
/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/

//
// LLD Configuration
//
#define LLD_BLOK_SIZE		(4096)//(4096)
#define LLD_PAGE_PER_BLOCK	(255)//(128)//(64)
#define LLD_PAGE_SIZE		(2048)
#define LLD_SPARE_SIZE		(64)

//
// miscellaneous definition
//
#define __LLD_FTL_SIM__
#define __LLD_MULTI_RW_SIM__
#define LLDDPRINTF printf
//#define __DEBUG_DMA_ERROR__
extern void HexDump(void * , smtUint32 );
#endif //__K9LAG08U0M_H__

