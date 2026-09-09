/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: dma.c 
	Description	: DMA test code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/

#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "dma.h"
#include "global.h" 

#include "uart_pre_drv.h"
#include "uart_post_drv.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/

#define IMAGE_DNBASE_ADDR	(DDR_STARTADDR+0x500000)
#define DMA_TEST_SIZE		0x100000

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/

void DmaIRQHandler(unsigned irq);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

//smtUint8 *src_addr = (smtUint8 *)0x60600000;
//smtUint8 *dst_addr = (smtUint8 *)0x60800000;
volatile smtUint8 *src_addr = (smtUint8 *)0x61000000;
volatile smtUint8 *dst_addr = (smtUint8 *)0x61200000;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: GDMAHandler()
	Prototype		: void GDMAHandler(smtUint32 irq)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void GDMAHandler(smtUint32 irq)
{
	;
}

/*----------------------------------------------------------
	Function name	: DCacheFlushing
	Prototype		: void DCacheFlushing(void)
	Return			: 
	Argument		:
	Comments		: 
----------------------------------------------------------*/
void DCacheFlushing(void)
{
	smtUint32  i, j;
	
	for(i = 0; i < 4; i++)
	{
		for(j=0;j<128;j++)
		{
			MMU_CleanInvalidateDCacheSET((i<<30)|(j<<5));	
		}
	}
}

/*----------------------------------------------------------
	Function name	: DMATest()
	Prototype		: smtUint32 DMATest(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
smtUint32 DMATest(void)
{
	smtUint32 errCode;	
	
	EDMA_STRUCT edma;	
	GDMA_STRUCT gdma;
	#define BUF_SZ	4
		
	for(errCode=0;errCode<DMA_TEST_SIZE;errCode++)
	{
		src_addr[errCode] = (errCode + 1)%256;
		dst_addr[errCode] = 0;//errCode + BUF_SZ + 1;
	}

#if 1

	DMA2Init(SMT_TRUE);

	DCacheFlushing();
	smt2DMAMemCopy(src_addr, dst_addr, DMA_TEST_SIZE);

	for(errCode=0;errCode<DMA_TEST_SIZE;errCode++)
	{
		//if(src_addr[errCode]!=dst_addr[errCode])
		if(*src_addr++!=*dst_addr++)
		{
			//while(1);
			smt2UartPrint(11, "E-DMA test error");
			return SMT_FALSE;
		}
	}
#endif

	smt2UartPrint(11, "E-DMA test success\n");
	return SMT_SUCCESS;
}

