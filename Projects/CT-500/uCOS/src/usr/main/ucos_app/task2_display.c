/*-----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
-----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: tasks_queue.c 
	Description	: ct500 uc/os-II version main code
	Created by	: SHMT SOC Team
-----------------------------------------------------------*/

/*
/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// 
*/
#include "sysinc.h"
#include "commonmacro.h"
#include "includes.h"
#include "tasks.h"
#include "tasks_queue.h"
#include "primitive.h"

#include "irq.h"
#include "lcd_pre_drv.h"
#include "display_test_utils.h"
#include "jpeg_logo.h"
/*
/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// 
*/


/*
/////////////////////////////////////////////////////////
        TYPE DEFINITION
///////////////////////////////////////////////////////// 
*/
#define VIDEO_PANO_WIDTH		(1440UL)
#define CURSOR_PALETTE_ALPHA 	(0x80UL)
#define GRAPHIC_PALETTE_ALPHA 	(0x80UL)

#define BLACK					(0xff000000UL)
#define RED						(0xffff0000UL)
#define GREEN					(0xff00ff00UL)
#define YELLOW					(0xffffff00UL)
#define BLUE					(0xff0000ffUL)
#define CYAN					(0xffff00ffUL)
#define MAGENTA					(0xff00ffffUL)
#define WHITE					(0xffffffffUL)

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
static void DoMENUDISPStartOverlayReq(void);
static void DoISRDISPOverlay(void);
static void DoISRDISPJpegDec(void);
static void DoMENUDISPStartDecJpegReq(void);
static void DoJPEGDISPJpegDecInd(void*);
static void DoMENUDISPStopDisplayReq(void);
static void ISRUCOSOverlay(smtUint32 irq);
static void ISRUCOSJpegDec(smtUint32 irq);

static smtUint32 CreatePalettFrame(void);
static smtUint32 CGVOverlay(void);
static void CreateCursorPalett(void);
static void CreateGraphicPalett(void);

extern smtUint32 smt2GDMACopy(GDMA_STRUCT *gdma, smtBoolean polling);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
static smtUint32 colorTable[8] = 
{
	BLACK,
	BLUE,
	GREEN,
	CYAN,
	RED,
	MAGENTA,
	YELLOW,
	WHITE
};

		OS_STK		Task3Stk[TASK_STK_SIZE];
static 	smtBoolean	flagDpOn = SMT_FALSE;

extern 	OS_MEM *msgStrBuf;
extern 	OS_MEM *userMsgBuf;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: Task2Display
	Prototype		: void Task2Display(void *pdata)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void Task2Display(void *pdata)
{
	MSGSTRUCT	*msgStruct;
	INT8U 		err;
	PRIMITIVE	primitive;
    pdata = pdata;
	
    for (;;) 
	{
		msgStruct = (MSGSTRUCT*)OSQPend(gDispMsgQ, 0, &err);/* Get msg from Queue						*/
		primitive = msgStruct->primitive;

		switch(primitive)
		{
			case MENUDISPStartOverlayReq:					/* Handling the msg from Menu task			*/					
				DoMENUDISPStartOverlayReq();				
				break;
			case MENUDISPStartDecJpegReq:
				DoMENUDISPStartDecJpegReq();
				break;
			case MENUDISPStopDisplayReq:
				DoMENUDISPStopDisplayReq();
				break;
			case JPEGDISPJpegDecInd:						/* Handling the msg from Jpeg decoding task	*/
				DoJPEGDISPJpegDecInd(msgStruct->msg);
				break;
			case ISRDISPOverlay:							/* Handling the msg from DM ISR				*/
				DoISRDISPOverlay();
				break;
			case ISRDISPJpegDec:
				DoISRDISPJpegDec();
				break;
			default:
				break;
		}
		if(msgStruct != (void*)0x0)
			OSMemPut(msgStrBuf, (void*)msgStruct);
    }

}

/*----------------------------------------------------------
	Function name	: DoMENUDISPStartOverlayReq
	Prototype		: static void DoDispOverlayReq(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void DoMENUDISPStartOverlayReq(void)
{
	if(flagDpOn)
		return;
	flagDpOn = SMT_TRUE;
	
	DMEnable();												/* Enable Display Module		*/
	DMSyncEnable();
	DMVEncEnable();
	CGVOverlay();
	RequestIRQ(IRQ_DM, ISRUCOSOverlay);
}

/*----------------------------------------------------------
	Function name	: DoMENUDISPStartDecJpegReq
	Prototype		: static void DoMENUDISPStartDecJpegReq(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void DoMENUDISPStartDecJpegReq(void)
{
	smtUint32	i;
	smtUint16	*vFrame0 = (smtUint16 *)VIDEO_BASEADDR;
	MSGSTRUCT 	*msgStruct;
	INT8U		err;

	if(flagDpOn)
		return;
	flagDpOn = SMT_TRUE;

    OSTaskCreateExt(Task3JpegDec,							/* create jpeg decoding task		*/
                (void *)0,
                &Task3Stk[TASK_STK_SIZE - 1],
                TASK_3_PRIO,
                TASK_3_ID,
                &Task3Stk[0],
                TASK_STK_SIZE,
                (void*)0,
                0);
	OSTaskNameSet(TASK_3_PRIO, (INT8U*)"JPEGDEC TASK", &err);
	
	msgStruct = (MSGSTRUCT*)OSMemGet(msgStrBuf,&err);		/* send msg to jpeg decode task		*/
	if(err != OS_NO_ERR)
		UCOSAPPDPRINTF(11,"Module=[%s]/func=[%s]/line=[%d]/OSERCD=[0x%08x]\n",\
			__MODULE__,__func__,__LINE__,err);
	msgStruct->primitive	= DISPJPEGStartDecReq;
	msgStruct->msg			= (void*)0;
	OSQPost(gJpegDecMsgQ,(void*)msgStruct);

	DMEnable();												/* Enable Display Module			*/
	DMSyncEnable();
	DMVEncEnable();
	for(i = 0; i < (VIDEO_HEIGHT*2)*VIDEO_PANO_WIDTH; i++)
		*(vFrame0+i) = jpeg_logo[i];	
	DMVideoOn((smtUint32) vFrame0, (VIDEO_PANO_WIDTH+VIDEO_WIDTH) >> 1, 0x3);
	RequestIRQ(IRQ_DM, ISRUCOSJpegDec);
	
}

/*----------------------------------------------------------
	Function name	: DoMENUDISPStopDisplayReq
	Prototype		: static void DoMENUDISPStopDisplayReq(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void DoMENUDISPStopDisplayReq(void)
{
	
	OSTaskDel(TASK_3_PRIO);									/* Delete Jpeg Decoding Task		*/

	DMVEncDisable();
	DMDisable(0xF);
	ReleaseIRQ(IRQ_DM);
	
	flagDpOn = SMT_FALSE;
}
/*----------------------------------------------------------
	Function name	: CGVOverlay()
	Prototype		: static smtUint32 CGVOverlay(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 CGVOverlay(void)
{
	smtUint32 i;
	DMPlaneBlndMode blndMode;
	smtUint16 *vFrame0 = (smtUint16 *)VIDEO_BASEADDR;
	extern unsigned short video_buffer[];

	// copy video image to DDR
	for(i = 0; i < (VIDEO_HEIGHT*2)*VIDEO_WIDTH; i++)
		*(vFrame0+i) = video_buffer[i];	

	CreatePalettFrame();
	
	memset((void*)&blndMode, 0x0,sizeof(blndMode));
	blndMode.blendMod = 2;
	smtDMSetCBlndMode(blndMode);
	smtDMSetGBlndMode(blndMode);
	DMVideoOn((smtUint32) vFrame0, VIDEO_WIDTH >> 1, 0x3);

	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: CreatePalettFrame()
	Prototype		: static smtUint32 CreatePalettFrame(void)
	Return			: error code
	Argument		:
	Comments		: Return a error-code
-----------------------------------------------------------*/
static smtUint32 CreatePalettFrame(void)
{
	CreateCursorPalett();
	DMCursorOn(CURSOR_BASEADDR, 0, 0x0);

	CreateGraphicPalett();
	DMGraphicOn(GRAPHIC_BASEADDR, 0, 0x0);
	
	return SMT_SUCCESS;
}

/*----------------------------------------------------------
	Function name	: CreateGraphicPalett()
	Prototype		: static void CreateCursorPalett(void)
	Return			: error code
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void CreateCursorPalett(void)
{
	smtInt32 i;
	smtUint32 *frame = (smtUint32 *)CURSOR_BASEADDR;

	DMPlanePalette palette;
	for(i = 0 ; i < 8 ; i++)								
	{
		palette.palAddr = i;
		palette.palData = colorTable[i] & 0x00ffffff;
		palette.palData |= (CURSOR_PALETTE_ALPHA << 24);
		smtDMSetCPalette(palette);
	}
	// prepare indexed bmp
	for(i = 0; i < FRAME_HEIGHT*FRAME_WIDTH/4; i++)
	{
		*frame++ = 0x01010101;
	}
}
/*----------------------------------------------------------
	Function name	: CreateGraphicPalett()
	Prototype		: static void CreateGraphicPalett(void)
	Return			: error code
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void CreateGraphicPalett(void)
{
	smtInt32 i;
	smtUint32 *frame = (smtUint32 *)GRAPHIC_BASEADDR;

	DMPlanePalette palette;

	for(i = 0 ; i < 8 ; i++)								
	{
		palette.palAddr = i;
		palette.palData = colorTable[i] & 0x00ffffff;
		palette.palData |= (GRAPHIC_PALETTE_ALPHA << 24);
		smtDMSetGPalette(palette);
	}

	// prepare indexed bmp
	for(i = 0; i < FRAME_HEIGHT*FRAME_WIDTH/4; i++)
	{
		*frame++ = 0x05050505;
	}
}

/*----------------------------------------------------------
	Function name	: DoISRDISPOverlay()
	Prototype		: static void DoISRDISPOverlay(void)
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void DoISRDISPOverlay(void)
{
	DMPlaneBlnd gPlaneBlnd,cPlaneBlnd;
	DMStatus dmSts;
	static smtUint8 cAlphaVal 		= 0x0;
	static smtUint8 gAlphaVal 		= 0xFF;

	smtDMGetMasterStatus(&dmSts);
	
	if(dmSts.mixFifoErr == 1)
	{
		UCOSAPPDPRINTF(11,"Mixer FIFO Error \n");
	}
	if(dmSts.vDmaFifoErr == 1)
	{
		UCOSAPPDPRINTF(11,"Video DMA FIFO Error \n");
	}
	if(dmSts.vFifoErr == 1)
	{
		UCOSAPPDPRINTF(11,"Video FIFO Error \n");
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
			gPlaneBlnd.alpha	= gAlphaVal--;
			smtDMSetGBlnd(gPlaneBlnd);

			cPlaneBlnd.alpha	= cAlphaVal++;
			smtDMSetCBlnd(cPlaneBlnd);
		}
	}
	return ;
}

/*----------------------------------------------------------
	Function name	: DoISRDISPJpegDec()
	Prototype		: static void DoISRDISPJpegDec(void)
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void DoISRDISPJpegDec(void)
{
	DMStatus dmSts;

	smtDMGetMasterStatus(&dmSts);
	
	if(dmSts.mixFifoErr == 1)
	{
		UCOSAPPDPRINTF(11,"Mixer FIFO Error \n");
	}
	if(dmSts.vDmaFifoErr == 1)
	{
		UCOSAPPDPRINTF(11,"Video DMA FIFO Error \n");
	}
	if(dmSts.vFifoErr == 1)
	{
		UCOSAPPDPRINTF(11,"Video FIFO Error \n");
	}
	if(dmSts.startFrame == 1)
	{
		if(dmSts.evenFieldInt == 1)
		{
			smtDMSetVAddr((smtUint32)(VIDEO_BASEADDR+(VIDEO_PANO_WIDTH*2)));
		}
		else
		{
			smtDMSetVAddr((smtUint32)VIDEO_BASEADDR);
		}
	}
	return ;
}

/*----------------------------------------------------------
	Function name	: DoJPEGDISPJpegDecInd()
	Prototype		: static void DoJPEGDISPJpegDecInd(void *msg)
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void DoJPEGDISPJpegDecInd(void *msg)
{
	GDMA_STRUCT gdma;
	smtUint32 errCode;
	
	gdma.src 		= (smtUint32)msg;						/*Copy to Frame Buffer*/
	gdma.sWidth 	= 1440;
	gdma.sHeight 	= 480;

	gdma.sClipX 	= 0;
	gdma.sClipY 	= 0;

	gdma.dst 		= (smtUint32)VIDEO_BASEADDR;//dst_addr;
	gdma.dWidth 	= 1440;
	gdma.dHeight	= 480;

	gdma.dClipX 	= 0;
	gdma.dClipY 	= 0;

	gdma.clipWidth 	= 1440;
	gdma.clipHeight = 480;
	
	gdma.bpp 		= 2;
	gdma.intFunction= 0;
	
	errCode = smt2GDMACopy(&gdma, SMT_TRUE);	

}

/*----------------------------------------------------------
	Function name	: ISRUCOSOverlay()
	Prototype		: static smtUint32 ISRUCOSOverlay(void)
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void ISRUCOSOverlay(smtUint32 irq)
{
	MSGSTRUCT	*isrMsgStr;
	INT8U 		err;
		
	isrMsgStr = (MSGSTRUCT*)OSMemGet(msgStrBuf,&err);
	
	if(err != OS_NO_ERR)
	{
		UCOSAPPDPRINTF(11,"Module=[%s]/func=[%s]/line=[%d]/OSERCD=[0x%08x]\n",\
			__MODULE__,__func__,__LINE__,err);
		
	}
	
	isrMsgStr->primitive	= ISRDISPOverlay;
	isrMsgStr->msg	 		= (void*)0x0;
	
	OSQPost(gDispMsgQ, (void *)isrMsgStr);
}
/*----------------------------------------------------------
	Function name	: ISRUCOSOverlay()
	Prototype		: static smtUint32 ISRUCOSOverlay(void)
	Return			: void
	Argument		:
	Comments		: 
-----------------------------------------------------------*/
static void ISRUCOSJpegDec(smtUint32 irq)
{
	MSGSTRUCT	*isrMsgStr;
	INT8U 		err;

	isrMsgStr = (MSGSTRUCT*)OSMemGet(msgStrBuf,&err);
	if(err != OS_NO_ERR)
	{
		UCOSAPPDPRINTF(11,"Module=[%s]/func=[%s]/line=[%d]/OSERCD=[0x%08x]\n",\
			__MODULE__,__func__,__LINE__,err);
		
	}
	isrMsgStr->primitive	= ISRDISPJpegDec;
	isrMsgStr->msg	 		= (void*)0x0;

	OSQPost(gDispMsgQ, (void *)isrMsgStr);
}

