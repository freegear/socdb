/*------------------------------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	File Name   : video_input_8.c 
	Description : video input test functions
	Created by  : SHMT SOC Team
------------------------------------------------------------------------------*/
/*
//////////////////////////////////////////////////////////////////////////////
        INCLUDE
//////////////////////////////////////////////////////////////////////////////
*/
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "global.h"
#include "display_test_utils.h"
#include "uart_post_drv.h"
#include "lcd_pre_drv.h"
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"
#include "vif_pre_drv.h"
/*
//////////////////////////////////////////////////////////////////////////////
        DEFINITIOIN
//////////////////////////////////////////////////////////////////////////////
*/

void ISRDMVideoInTest(smtUint32 irq);
void ISRVIFVideoInTest(smtUint32 irq);
/*
//////////////////////////////////////////////////////////////////////////////
        FUNCTION
//////////////////////////////////////////////////////////////////////////////
*/
/*------------------------------------------------------------------------------
	Function name	: VideoInTest()
	Prototype		: smtUint32 VideoInTest(void)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
smtUint32 VideoInTest(void)
{
	DMVIFEnable();
	DMVEncEnable();
	RequestIRQ(IRQ_DM, ISRDMVideoInTest);
	RequestIRQ(IRQ_VIF, ISRVIFVideoInTest);

	DMEnable();

//	smtDelay1ms(100);
	
	DMSyncEnable();
	DMVideoOn((smtUint32)VIDEO_BASEADDR,VIDEO_WIDTH >> 1,0x2);

	smt2UartPrint(11,"press '0' to exit video input test\n");
	while(1)
	{
		smtUint8 uart_input = 0;

		if(UARTDataAvailable())
		{
			uart_input = smt2UartGetCh(0);
			if(uart_input == '0')
			{
				break;
			}
		}
	}
	DMDisable(VIDEO_PLANE_DISABLE);
	DMVEncDisable();
	DMVIFDisable();
	ReleaseIRQ(IRQ_DM);
	ReleaseIRQ(IRQ_VIF);
	return SMT_SUCCESS;
}
/*------------------------------------------------------------------------------
	Function name	: ISRDMVideoInTest()
	Prototype		: void ISRDMVideoInTest(smtUint32 irq)
	Return			: 
	Argument		:
	Comments		:
------------------------------------------------------------------------------*/
void ISRDMVideoInTest(smtUint32 irq)
{
	// Already VIC DM interrupt bit is cleared by AckIRQ(irq).
	DMStatus dmSts;
	smtDMGetMasterStatus(&dmSts);
	if(dmSts.mixFifoErr == 1)
	{
		smt2UartPrint(11,"Mixer FIFO Error \n");
	}
	if(dmSts.vDmaFifoErr == 1)
	{
		smt2UartPrint(11,"Video DMA FIFO Error \n");
	}
	if(dmSts.vFifoErr == 1)
	{
		smt2UartPrint(11,"Video FIFO Error \n");
	}	

	if(dmSts.startFrame == 1)
	{
		if(dmSts.evenFieldInt == 1)
			smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_WIDTH*2)));
		else
			smtDMSetVAddr((smtUint32)VIDEO_BASEADDR);
	}
}

void ISRVIFVideoInTest(smtUint32 irq)
{
	smtUint32 regData;
	
	regData = SMT_READ(VIFSTS);
	if(regData & 0x4)	// Video Buffer Error
	{
		smt2UartPrint(11,"External Video Buffer Error\n");
	}
}

