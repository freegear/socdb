/*-----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
-----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: task1_menu.c 
	Description	: 
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
static smtUint32 DoKeypadInd(void* pKeyNum);
/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

extern OS_MEM *msgStrBuf;
extern OS_MEM *userMsgBuf;

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/

/*----------------------------------------------------------
	Function name	: Task1Menu
	Prototype		: void Task1Menu(void *pdata)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void Task1Menu(void *pdata)
{
    MSGSTRUCT *msgStruct;
	PRIMITIVE primitive;
	void *msg;
	
    INT8U  err;
	
    pdata = pdata;
    for(;;)
	{
        msgStruct	= (MSGSTRUCT*)OSQPend(gMainMsgQ, 0, &err);
		primitive	= msgStruct->primitive;
		msg			= msgStruct->msg;

		switch(primitive)
		{
			case HWMENUKeypadInd:
				DoKeypadInd((void*) msg);
				break;
				
			//
			// add case here
			//

			default:
				break;
		}

		if(msgStruct != (void*)0x0)
			OSMemPut(msgStrBuf, (void*)msgStruct);
    }
}

/*----------------------------------------------------------
	Function name	: DoKeypadInd
	Prototype		: static smtUint32 DoKeypadInd(void* pKeyNum)
	Return			: error code
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static smtUint32 DoKeypadInd(void* pKeyNum)
{
	smtUint32	keyNum;
	MSGSTRUCT	*msgStruct;
	INT8U		err;
	
	keyNum 		= (smtUint32)pKeyNum;
	
	msgStruct	= (MSGSTRUCT*)OSMemGet(msgStrBuf,&err);
	if(err != OS_NO_ERR)
	{
		UCOSAPPDPRINTF(11,"Module=[%s]/func=[%s]/line=[%d]/OSERCD=[0x%08x]\n",\
			__MODULE__,__func__,__LINE__,err);
		return SMT_ERROR;
	}
	switch(keyNum)
	{
		case 24:
			msgStruct->primitive	= MENUDISPStartOverlayReq;	/*send msg to display overlay			*/
			msgStruct->msg			= (void*)0;
			OSQPost(gDispMsgQ,(void*)msgStruct);
			break;
		case 25:
			msgStruct->primitive	= MENUDISPStartDecJpegReq;	/*send msg to display jpeg				*/
			msgStruct->msg			= (void*)0;
			OSQPost(gDispMsgQ,(void*)msgStruct);
			break;
		case 26:
			msgStruct->primitive	= MENUDISPStopDisplayReq;	/*send msg to stop display				*/
			msgStruct->msg			= (void*)0;
			OSQPost(gDispMsgQ,(void*)msgStruct);
			break;
			
		default:
			break;
	}
	
	return SMT_SUCCESS;
}
