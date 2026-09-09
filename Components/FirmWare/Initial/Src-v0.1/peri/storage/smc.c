/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: smc.c 
	Description	: static memory test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
//#include "irq.h"
#include "smc_pre_drv.h"
#include "memory_test.h"
/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// */
#define	SMCT_TESTMEM_START			(0x43000000)
#define	SMCT_TESTMEM_SIZEINBYTE		(0x00001000)
#define	SMCT_DEFAULT_SEED			(0x00000000)
/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
/*----------------------------------------------------------
	Function name	: DMC_Main()
	Prototype		: void DMC_Main(void)
	Return			:
	Argument		:
	Comments		:
		SD/MMC Test main function
-----------------------------------------------------------*/
void SMCTest(void)
{
	/* only memory test */
	smtUint32	testIdx = 0;
	MEM_TEST testInfo[] = 
	{
		{AT_08BITS, {AM_SEQ, 	AM_NONSEQ, 	AM_NULL		}},
		{AT_16BITS, {AM_SEQ, 	AM_NONSEQ, 	AM_NULL		}},
		{AT_32BITS, {AM_SEQ, 	AM_NONSEQ, 	AM_BURST	}},
		{AT_NULL, 	{AM_NULL, 	AM_NULL, 	AM_NULL		}}
	};	
	

	testIdx = 0;
	while(testInfo[testIdx++].type != AT_NULL) 
	{
		
		if(MemRWTest(
			SMCT_TESTMEM_START, 
			SMCT_TESTMEM_SIZEINBYTE, 
			&testInfo, 
			SMCT_DEFAULT_SEED
		))
		{
			//printf("memory test ok!!!\n");
		}
		else
		{
			//printf("memory test fail!!!\n");
		}
	}
	
	
}
