/*----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
----------------------------------------------------------*/
/*----------------------------------------------------------
	File name		: tasks.h
	Description	: 
----------------------------------------------------------*/
#ifndef __TASKS_QUEUE_H__
#define __TASKS_QUEUE_H__
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

#define          MSG_QUEUE_SIZE     20			/*Size of message queue 					*/

extern OS_EVENT	*gMainMsgQ;
extern OS_EVENT	*gDispMsgQ;
extern OS_EVENT	*gJpegDecMsgQ;
/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
extern smtUint32 InitTasksMsgQ(void);
#endif/*__TASKS_QUEUE_H__*/
