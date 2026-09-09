/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File Name	: main.c 
	Description	: Application Entry Point File
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
#include "irq.h"

#include "display_test_utils.h"
#include "uart_post_drv.h"
#include "lcd_pre_drv.h"
#include "videoenc_post_drv.h"
#include "videoenc_pre_drv.h"

/*
/////////////////////////////////////////////////////////
	DEFINITION
///////////////////////////////////////////////////////// 
*/
#define PAUSE		0
#define COMPLETE	1

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
void ThreePlaneOverlay(void);
void ISRDMTHREEPLANE(smtUint32 irq);
smtUint8 PlaySound(void);

/*
/////////////////////////////////////////////////////////
	VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
//cursor image
extern unsigned short cursor_buffer[];
//graphic image
extern unsigned char graphic_buffer[];
//video image
extern unsigned short video_buffer[];

extern unsigned sounddata[];

/*
/////////////////////////////////////////////////////////
	FUNCTION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: SMTTestScenario()
	Prototype		: void SMTTestScenario(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void SoundDisplay(void)
{
	smtUint32 errCode = SMT_SUCCESS;

	// DM enable
	DMEnable();
	DMSyncEnable();
	DMVEncEnable();
	RequestIRQ(IRQ_DM,ISRDMTHREEPLANE);

	// Initialize SEIP
	InitSEIP();

	// Display
	ThreePlaneOverlay();

	smt2UartPrint(11, "Press '0' key to exit\n");
	while(1)
	{
		char uart_input;

		//PlaySoundData_NotUseDMA();
		errCode = (smtUint32)PlaySound();

		if (errCode != COMPLETE)
			break;
	}

	// DM disable
	DMDisable(CURSOR_PLANE_DISABLE|GRAPHIC_PLANE_DISABLE|VIDEO_PLANE_DISABLE);
	DMVEncDisable();
	ReleaseIRQ(IRQ_DM);
}

/*----------------------------------------------------------
	Function name	: SMTTestScenario()
	Prototype		: void SMTTestScenario(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void ThreePlaneOverlay(void)
{
	DMPlaneCtrl gPlaneCfg,cPlaneCfg,vPlaneCfg;
	DMPlaneBlnd gPlaneBlnd,cPlaneBlnd,vPlaneBlnd;
	DMPlaneBlndMode gPlaneBlndMode,cPlaneBlndMode,vPlaneBlndMode;
	smtUint32 i;
	
	smtUint8  alphaVal = 0xFF, alphaValCursor = 0;
	smtUint16 *cFrame0 = (smtUint16 *)CURSOR_BASEADDR;
	smtUint32 *gFrame0 = (smtUint32 *)GRAPHIC_BASEADDR;
	smtUint16 *vFrame0 = (smtUint16 *)VIDEO_BASEADDR;
	smtUint32 wrData = 0;

	// copy cursor image to DDR
	smt2UartPrint(11,"start to copy cursor plane image !! \n");
	for(i = 0; i < CURSOR_HEIGHT*CURSOR_WIDTH*2; i++)
		*(cFrame0+i) = cursor_buffer[i];

	// copy graphic image to DDR
	smt2UartPrint(11,"start to copy graphic plane image !! \n");
	for(i = 0; i < (GRAPHIC_HEIGHT*2)*GRAPHIC_WIDTH *3 ;)
	{
		wrData = 0;
		wrData = graphic_buffer[i++];
		wrData = wrData | (graphic_buffer[i++] << 8);
		wrData = wrData | (graphic_buffer[i++] <<16);
		*(gFrame0++) = wrData;
	}
	// copy video image to DDR
	smt2UartPrint(11,"start to copy video plane image !! \n");
	for(i = 0; i < (VIDEO_HEIGHT*2)*VIDEO_WIDTH; i++)
		*(vFrame0+i) = video_buffer[i];	

	smt2UartPrint(11,"enable cursor plane !! \n");
	DMCursorOn((smtUint32)cFrame0, CURSOR_WIDTH >> 1, 0x3);

	smt2UartPrint(11,"enable graphic plane !! \n");
	gFrame0 = (smtUint32 *)(GRAPHIC_BASEADDR);
	DMGraphicOn((smtUint32)gFrame0, GRAPHIC_WIDTH, 0x4);
	smtDMGetGBlndMode(&gPlaneBlndMode);
	gPlaneBlndMode.blendMod = 0x2;
	smtDMSetGBlndMode(gPlaneBlndMode);	
	
	smt2UartPrint(11,"enable video plane !! \n");
	DMVideoOn((smtUint32) vFrame0, VIDEO_WIDTH >> 1, 0x3);
}

/*----------------------------------------------------------
	Function name: SMTTestScenario()
	Prototype	: void SMTTestScenario(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
void ISRDMTHREEPLANE(smtUint32 irq)
{
	DMStatus dmSts;

	DMPlaneBlnd gPlaneBlnd,cPlaneBlnd,vPlaneBlnd;
	static smtUint8  alphaVal = 0xFF, alphaValCursor = 0;


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
		{
			smtDMSetCAddr((smtUint32)CURSOR_BASEADDR+(CURSOR_WIDTH*2));
			smtDMSetGAddr((smtUint32)(GRAPHIC_BASEADDR+(GRAPHIC_WIDTH*4)));
			smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_WIDTH*2)));
		}
		else
		{
			smtDMSetCAddr((smtUint32)CURSOR_BASEADDR);
			smtDMSetGAddr((smtUint32)GRAPHIC_BASEADDR);
			smtDMSetVAddr((smtUint32)VIDEO_BASEADDR);
		}

		gPlaneBlnd.alpha	= alphaVal--;
		gPlaneBlnd.colKey	= 0xFFFFFF;
		smtDMSetGBlnd(gPlaneBlnd);

		cPlaneBlnd.alpha	= alphaValCursor++;
		cPlaneBlnd.colKey	= 0x000000;
		smtDMSetCBlnd(cPlaneBlnd);
	}

}

/*----------------------------------------------------------
	Function name: PlaySound()
	Prototype	: void PlaySound(void)
	Return		: void
	Argument	:
	Comments	:
----------------------------------------------------------*/
smtUint8 PlaySound(void)
{
    int i;
    char uart_input;

    for( i=0; i<262120; i++ )
	{

        while( (SMT_READ(SEIP_RXSTS) & 0x00000200) ){;}
        SMT_WRITE(SEIP_RXDAT, sounddata[i] );
        if(smtUartDataAvailable())
        {
            uart_input = smt2UartGetCh(0);
            if(uart_input == '0')
            {
				return PAUSE;
            }
        }
    }

	return COMPLETE;
}
