/*-----------------------------------------------------------
	 SkyWalker for Navigation
	 Developed by S/W Team, SHMT.Co
	 Copyright @ 2006 SHMT. Co
	 All Rights Reserved.
-----------------------------------------------------------*/
/*----------------------------------------------------------
	File name	: ucos_main.c 
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
#include "lib.h"
#include "irq.h"
#include "mmu.h"
#include "uart_post_drv.h"
#include "includes.h"						/*for uc/os-II			*/
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

//--------------------------------------------------
// for uC/OS-II
//--------------------------------------------------
//
// task functions
//
        void  TaskStart(void *pdata);
static  void  TaskStartCreateTasks(void);

static 	void InitSystem(void);
static	void initUartDefault(void);
static	void initTimerTick(void);
static 	void initKeypad(void);
static 	void GPIOEdgeIRQ(smtUint32  GPIOPin);
/*
/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// 
*/

static unsigned int mboot[] = 								/* interrupt vector				*/	
{
	0xe59ff018,0xe59ff018,0xe59ff018,0xe59ff018,
	0xe59ff018,0x00000014,0xe59ff018,0xe59ff010,

	0x60100000,0x60100004,0x60100008,0x6010000C,
	0x60100014,0x6010001C,0x60100018
};
static UartConfig uartBasicCfg;

OS_STK		TaskStartStk[TASK_STK_SIZE];					/* stacks for tasks				*/
OS_STK		Task1Stk[TASK_STK_SIZE];
OS_STK		Task2Stk[TASK_STK_SIZE];
OS_STK		Task4Stk[TASK_STK_SIZE];

INT8U		msgStrPart[60][8]={0,};							/* Memory Partition				*/
INT8U 		userMsgPart[60][32]={0,};						
OS_MEM		*msgStrBuf;										
OS_MEM		*userMsgBuf;									

OS_EVENT	*uart0Sem;										/* Semaphore for UART CH0		*/

/*
/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// 
*/
/*----------------------------------------------------------
	Function name	: ucos_main
	Prototype		: void ucos_main(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void ucos_main(void)
{	
	INT8U err;
	OSInit();  													/* Init uC/OS-II				*/

	msgStrBuf	= OSMemCreate((void*)msgStrPart, 60,  8,&err);				/* create memory partition		*/
	userMsgBuf	= OSMemCreate((void*)userMsgBuf, 60, 32,&err);
	OSTaskCreateExt(TaskStart,
                   (void *)0,
                   &TaskStartStk[TASK_STK_SIZE-1],
                   TASK_START_PRIO,
                   TASK_START_ID,
                   &TaskStartStk[0],
                   TASK_STK_SIZE,
                   (void*)0,
                   OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
  	OSTaskNameSet(TASK_START_PRIO, (INT8U*)"StartTask", &err);
    OSStart(); 													/*uC/OS-II start			*/
	//never be reached
}

/*----------------------------------------------------------
	Function name	: TaskStart
	Prototype		: void  TaskStart (void *pdata)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void  TaskStart (void *pdata)
{
	smtUint32 i = 0;
    pdata = pdata;                                         	/* Prevent compiler warning                 */

	InitSystem();	
    OSStatInit();                                          	/* Initialize uC/OS-II's statistics         */
	InitTasksMsgQ();										/* Create the msg queue for tasks			*/
	uart0Sem = OSSemCreate(1);
    TaskStartCreateTasks();                                	/* Create all the application tasks         */
    for (; ;)
	{
       OSCtxSwCtr = 0;                                    	/* Clear the context switch counter         */
       OSTimeDly(OS_TICKS_PER_SEC);                       	/* Wait one second                			*/
       UCOSAPPDPRINTF(11,"TASK START [%d]\n",i++);
    }
}

/*----------------------------------------------------------
	Function name	: timer0ISR
	Prototype		: void timer0ISR(smtUint32 irq)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
void timer0ISR(smtUint32 irq)
{
	  OSTimeTick();
}
/*----------------------------------------------------------
	Function name	: InitSystem
	Prototype		: static void InitSystem(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void InitSystem(void)
{
	smtInt32		i;
	smtUint32		*s_addr = (smtUint32 *)0x60000000;

	for(i=0;i<36;i++)										/* copy vector table to virtual addr(0x0)*/
		*s_addr++ = mboot[i];
	Disable_IRQ();											
	MMU_Init();
	Enable_IRQ();

	initUartDefault();										/*init Uart*/
	EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	initTimerTick();										/*init timer0 for ucos timetick*/
	initKeypad();											/*init Keypad*/
	return;
}

/*----------------------------------------------------------
	Function name	: TaskStartCreateTasks
	Prototype		: static void TaskStartCreateTasks (void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void TaskStartCreateTasks (void)
{
	INT8U err = 0;
    OSTaskCreateExt(Task1Menu,
                    (void *)0,
                    &Task1Stk[TASK_STK_SIZE - 1],
                    TASK_1_PRIO,
                    TASK_1_ID,
                    &Task1Stk[0],
                    TASK_STK_SIZE,
                    (void*)0,
                    0);
	OSTaskNameSet(TASK_1_PRIO, (INT8U*)"MENU TASK", &err);

    OSTaskCreateExt(Task2Display,
                    (void *)0,
                    &Task2Stk[TASK_STK_SIZE - 1],
                    TASK_2_PRIO,
                    TASK_2_ID,
                    &Task2Stk[0],
                    TASK_STK_SIZE,
                    (void*)0,
                    0);
	OSTaskNameSet(TASK_2_PRIO, (INT8U*)"DISPLAY TASK", &err);
    
}


/*----------------------------------------------------------
	Function name	: initUartDefault
	Prototype		: void initUartDefault(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void initUartDefault(void)
{
	uartBasicCfg.baudrate		= 38400;						
	uartBasicCfg.enInt			= 0x0;
	uartBasicCfg.enRxTimeout	= 0x0;
	uartBasicCfg.swReset		= 0x0;
	uartBasicCfg.enDmaReq		= 0x0;
	uartBasicCfg.parity			= 0x0;
	uartBasicCfg.dataBit		= 0x1;
	uartBasicCfg.stopBit		= 0x0;
	uartBasicCfg.enLoopBack		= 0x0;
	uartBasicCfg.txWaterLev		= 0x8;
	uartBasicCfg.rxWaterLev		= 0x8;
	uartBasicCfg.uartCh			= 0;
	smt2UartInit(uartBasicCfg);								/*Uart init*/
}

/*----------------------------------------------------------
	Function name	: initTimerTick
	Prototype		: static void initTimerTick(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void initTimerTick(void)
{
	smtUint32 		tickFreq;
	smtUint32 		prescalerVal = 4;
	TIMER_STRUCT	timer;

	Disable_IRQ();											/*set Timer ISR*/
	//EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	RequestIRQ(IRQ_TIMER0, timer0ISR);
	Enable_IRQ();
	
	tickFreq = APB1_CLK / (prescalerVal + 1);				/*Enable Timer*/
	timer.data			= tickFreq/OS_TICKS_PER_SEC;
	timer.prescale		= prescalerVal;
	timer.opMode		= TIMER_INTERVAL;
	timer.timerClear	= 0;
	timer.timerEn		= 1;
	smtTIMERSetMode(timer, TIMER_SEL0);
}

/*----------------------------------------------------------
	Function name	: initKeypad
	Prototype		: static void initKeypad(void)
	Return			: void
	Argument		: 
	Comments		: 
-----------------------------------------------------------*/
static void initKeypad(void)
{
	GPIO_STRUCT gpio;
	smtUint32 i = 0;
		
	Disable_IRQ();
	//EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);
	GpioInitInterrupt(gpio);
	Enable_IRQ();

	gpio.intStatus	 = ~0;

	gpio.intLevel 	 = 0;
	gpio.intPolarity = 1;
	gpio.intBothEdge = 0; 	

	for(i = 24; i < 32; i++)
	{
		// keypad Edge,Acitve high
		gpio.gpioNum	 = i;
		smtGPIOSetIntProperty(GPIO0_TYPE, gpio);
		RequestGpioIRQ(i, GPIOEdgeIRQ);
	}

}

/*----------------------------------------------------------
    Function name   : GPIOLevelIRQ
    Prototype       : void GPIOLevelIRQ(smtUint32  GPIOPin)
    Return          : void
	Argument        :
    Comments        : 
-----------------------------------------------------------*/
static void GPIOEdgeIRQ(smtUint32  GPIOPin)
{
	MSGSTRUCT	*msgStruct;
	INT8U		err;
	msgStruct 	= (MSGSTRUCT*)OSMemGet(msgStrBuf, &err);

	if(err != OS_NO_ERR)									/* error				*/
			return;

	msgStruct->primitive	= HWMENUKeypadInd;
	msgStruct->msg		= (void*)GPIOPin;
	
	OSQPost(gMainMsgQ,(void*)msgStruct);
}

