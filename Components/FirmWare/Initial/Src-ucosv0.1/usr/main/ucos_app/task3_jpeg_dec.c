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
#include "jpegdec.h"
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

/*
/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
static void DoDISPJPEGStartDecReq(void);
static void DoJPEGStartDecLoopReq(void);

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

extern smtUint8 PANORAMA_2[];
extern smtUint8 PANORAMA_3[];
extern OS_MEM *msgStrBuf;
extern OS_MEM *userMsgBuf;

static smtUint32 srcJpeg[2];
static smtUint32 destBuf[2];


/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: Task3JpegDec
	Prototype		: void Task3JpegDec(void *pdata)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void  Task3JpegDec (void *pdata)
{
	INT8U 		err;
	MSGSTRUCT	*msgStruct;
	PRIMITIVE 	primitive;
	void		*msg;
	
    pdata = pdata;
	
	for (;;)
	{
		msgStruct 	= (MSGSTRUCT*)OSQPend(gJpegDecMsgQ, 0, &err);
		primitive 	= msgStruct->primitive;
		msg			= msgStruct->msg;

		switch(primitive)
		{
			case DISPJPEGStartDecReq:						/* Handling the msg from Display task	*/	
				DoDISPJPEGStartDecReq();
				break;
			case JPEGStartDecLoopReq:						/* Handling the loopback msg	 		*/
				DoJPEGStartDecLoopReq();
				break;
			default:
				break;
		}

		if(msgStruct != (void*)0x0)
			OSMemPut(msgStrBuf, (void*)msgStruct);
    }
}
/*----------------------------------------------------------
	Function name	: DoDISPJPEGStartDecReq
	Prototype		: static void DoDISPJPEGStartDecReq(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void DoDISPJPEGStartDecReq(void)
{
	MSGSTRUCT	*msgStruct;
	INT8U		err;
	
	JpegDecodeInit();

	srcJpeg[0] 			= (smtUint32)&PANORAMA_2[0];
	srcJpeg[1] 			= (smtUint32)&PANORAMA_3[0];
	destBuf[0]			= VIDEO_SRC0_BASEADDR;
	destBuf[1]			= VIDEO_SRC1_BASEADDR;
	
	msgStruct	= (MSGSTRUCT*)OSMemGet(msgStrBuf,&err);
	if(err != OS_NO_ERR)
	{
		UCOSAPPDPRINTF(11,"Module=[%s]/func=[%s]/line=[%d]/OSERCD=[0x%08x]\n",\
			__MODULE__,__func__,__LINE__,err);
		
	}
	msgStruct->primitive = JPEGStartDecLoopReq;
	msgStruct->msg		= (void*)0;
	OSQPost(gJpegDecMsgQ, (void *)msgStruct);
}

/*----------------------------------------------------------
	Function name	: DoJPEGStartDecLoopReq
	Prototype		: static void DoJPEGStartDecLoopReq(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void DoJPEGStartDecLoopReq(void)
{
	static smtUint32 i = 0;
	MSGSTRUCT	*msgStruct;
	INT8U		err;
	int width,height;

	JpegDecode((JPEGBYTE*) srcJpeg[i%2], (JPEGBYTE*)destBuf[i%2],\
				&width, &height);								/* decode jpeg data		*/

	msgStruct = (MSGSTRUCT*)OSMemGet(msgStrBuf, &err);
	if(err != OS_NO_ERR)
	{
		UCOSAPPDPRINTF(11,"Module=[%s]/func=[%s]/line=[%d]/OSERCD=[0x%08x]\n",\
			__MODULE__,__func__,__LINE__,err);
		
	}
	msgStruct->primitive = JPEGDISPJpegDecInd;					/* send the msg to Display task	*/
	msgStruct->msg		= (void*)destBuf[i%2];
	OSQPost(gDispMsgQ, (void*)msgStruct);
	
	i++;														/* increase index for jpeg src/dest array	*/
	
	msgStruct = (MSGSTRUCT*)OSMemGet(msgStrBuf, &err);	
	if(err != OS_NO_ERR)
	{
		UCOSAPPDPRINTF(11,"Module=[%s]/func=[%s]/line=[%d]/OSERCD=[0x%08x]\n",\
			__MODULE__,__func__,__LINE__,err);
		
	}
	msgStruct->primitive	= JPEGStartDecLoopReq;				/* send the loopback msg to decode jpeg */
	msgStruct->msg			= (void*)0x0;
	OSQPost(gJpegDecMsgQ, (void*)msgStruct);
}
