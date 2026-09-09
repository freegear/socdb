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
#ifndef __TASKS_H__
#define __TASKS_H__
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

#define  		 TASK_STK_SIZE     1024      	/*Size of each task's stacks (# of WORDs)	*/

#define          TASK_START_ID       0			/*Application tasks IDs						*/
#define          TASK_1_ID           1
#define          TASK_2_ID           2
#define          TASK_3_ID           4

#define          TASK_START_PRIO    10			/*Application tasks priorities				*/
#define          TASK_1_PRIO        11
#define          TASK_2_PRIO        12
#define          TASK_3_PRIO        13

extern smtUint32 smt2UartPrint(int dispLvl, char *fmt, ...);
#define UCOSAPPDPRINTF	smt2UartPrint

/*
/////////////////////////////////////////////////////////
	FUNCTION DECLARATION
///////////////////////////////////////////////////////// 
*/
extern void Task1Menu(void*);
extern void Task2Display(void*);
extern void Task3JpegDec(void*);

#endif/*__TASKS_H__*/
