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
#include "tasks_queue.h"
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

/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/
OS_EVENT       *gMainMsgQ;
void           *MainMsgQTbl[MSG_QUEUE_SIZE];

OS_EVENT       *gDispMsgQ;
void           *DispMsgTbl[MSG_QUEUE_SIZE];

OS_EVENT       *gJpegDecMsgQ;
void           *JpegDecMsgQTbl[MSG_QUEUE_SIZE];

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: InitTasksMsgQ
	Prototype		: smtUint32 InitTasksMsgQ(void)
	Return			: error code
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
smtUint32 InitTasksMsgQ(void)
{

	gMainMsgQ		= OSQCreate(&MainMsgQTbl[0], MSG_QUEUE_SIZE); 			/* Create a message queue for main tasks		*/
	gDispMsgQ		= OSQCreate(&DispMsgTbl[0], MSG_QUEUE_SIZE); 			/* Create a message queue for main tasks		*/
	gJpegDecMsgQ	= OSQCreate(&JpegDecMsgQTbl[0], MSG_QUEUE_SIZE); 		/* Create a message queue for main tasks		*/

	if(!gMainMsgQ && !gDispMsgQ && !gJpegDecMsgQ)								/* Failed to create a msg queue					*/
		return SMT_ERROR;
	
	return SMT_SUCCESS;
}

