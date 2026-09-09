/*
*********************************************************************************************************
*                                               uC/OS-II
*                                         The Real-Time Kernel
*
*                             (c) Copyright 1998-2004, Micrium, Weston, FL
*                                          All Rights Reserved
*
*
*                                            ARM Sample code
*
* File : APP.C
* By   : Jean J. Labrosse
*********************************************************************************************************
*/

#include <includes.h>

/*
*********************************************************************************************************
*                                                CONSTANTS
*********************************************************************************************************
*/

#define  TASK_STK_SIZE    128

#define  TASK_START_PRIO    5

#define  TASK_1_PRIO       10
#define  TASK_2_PRIO       12
#define  TASK_3_PRIO       14
#define  TASK_4_PRIO       16
#define  TASK_5_PRIO       18
#define  TASK_6_PRIO       20
#define  TASK_7_PRIO       22
#define  TASK_8_PRIO       24
#define  TASK_9_PRIO       26
#define  TASK_A_PRIO       28
#define  TASK_B_PRIO       30
#define  TASK_C_PRIO       32
#define  TASK_D_PRIO       34
#define  TASK_E_PRIO       36
#define  TASK_F_PRIO       38

#define  MUTEX_PIP_1        8
#define  MUTEX_PIP_2        9

#define  EVENT_Q_1_SIZE    10
#define  EVENT_Q_2_SIZE    20

#define  MEM_BLKS_1        10
#define  MEM_BLK_SIZE_1     8
#define  MEM_BLKS_2         8
#define  MEM_BLK_SIZE_2    12

/*
*********************************************************************************************************
*                                                VARIABLES
*********************************************************************************************************
*/

OS_STK        AppStartTaskStk[TASK_STK_SIZE];
OS_STK        AppTask1Stk[TASK_STK_SIZE];
OS_STK        AppTask2Stk[TASK_STK_SIZE];
OS_STK        AppTask3Stk[TASK_STK_SIZE];
OS_STK        AppTask4Stk[TASK_STK_SIZE];
OS_STK        AppTask5Stk[TASK_STK_SIZE];
OS_STK        AppTask6Stk[TASK_STK_SIZE];
OS_STK        AppTask7Stk[TASK_STK_SIZE];
OS_STK        AppTask8Stk[TASK_STK_SIZE];
OS_STK        AppTask9Stk[TASK_STK_SIZE];
OS_STK        AppTaskAStk[TASK_STK_SIZE];
OS_STK        AppTaskBStk[TASK_STK_SIZE];
OS_STK        AppTaskCStk[TASK_STK_SIZE];
OS_STK        AppTaskDStk[TASK_STK_SIZE];
OS_STK        AppTaskEStk[TASK_STK_SIZE];
OS_STK        AppTaskFStk[TASK_STK_SIZE];

INT16U        AppTask1Ctr;
INT16U        AppTask2Ctr;
INT16U        AppTask3Ctr;
INT16U        AppTask4Ctr;
INT16U        AppTask5Ctr;
INT16U        AppTask6Ctr;
INT16U        AppTask7Ctr;
INT16U        AppTask8Ctr;
INT16U        AppTask9Ctr;
INT16U        AppTaskACtr;
INT16U        AppTaskBCtr;
INT16U        AppTaskCCtr;
INT16U        AppTaskDCtr;
INT16U        AppTaskECtr;
INT16U        AppTaskFCtr;

#if OS_SEM_EN > 0
OS_EVENT     *EventSem1;
OS_EVENT     *EventSem2;
#endif

#if OS_MBOX_EN > 0
OS_EVENT     *EventMbox1;
OS_EVENT     *EventMbox2;
#endif

#if OS_Q_EN > 0
OS_EVENT     *EventQ1;
OS_EVENT     *EventQ2;

void         *EventQTbl1[EVENT_Q_1_SIZE];
void         *EventQTbl2[EVENT_Q_2_SIZE];
#endif

#if OS_MUTEX_EN > 0
OS_EVENT     *EventMutex1;
OS_EVENT     *EventMutex2;
#endif

#if OS_FLAG_EN > 0
OS_FLAG_GRP  *FlagGrp1;
OS_FLAG_GRP  *FlagGrp2;
#endif

#if OS_MEM_EN > 0
OS_MEM       *MemPart1;
OS_MEM       *MemPart2;

INT32U        MemPart1Tbl[MEM_BLKS_1][MEM_BLK_SIZE_1/sizeof(INT32U)];
INT32U        MemPart2Tbl[MEM_BLKS_2][MEM_BLK_SIZE_2/sizeof(INT32U)];
#endif

/*
*********************************************************************************************************
*                                            FUNCTION PROTOTYPES
*********************************************************************************************************
*/

static  void  AppStartTask(void *p_arg);
static  void  AppTaskCreate(void);
static  void  AppEventCreate(void);
static  void  AppTask1(void *p_arg);
static  void  AppTask2(void *p_arg);
static  void  AppTask3(void *p_arg);
static  void  AppTask4(void *p_arg);
static  void  AppTask5(void *p_arg);
static  void  AppTask6(void *p_arg);
static  void  AppTask7(void *p_arg);
static  void  AppTask8(void *p_arg);
static  void  AppTask9(void *p_arg);
static  void  AppTaskA(void *p_arg);
static  void  AppTaskB(void *p_arg);
static  void  AppTaskC(void *p_arg);
static  void  AppTaskD(void *p_arg);
static  void  AppTaskE(void *p_arg);
static  void  AppTaskF(void *p_arg);

/*
*********************************************************************************************************
*                                                main()
*
* Description : This is the standard entry point for C code.  It is assumed that your code will call
*               main() once you have performed all necessary 68HC12 and C initialization.
* Arguments   : none
*********************************************************************************************************
*/

void main( void )
{
    INT8U  err;

    BSP_Init();

    OSInit();                               /* Initialize "uC/OS-II, The Real-Time Kernel"             */

    OSTaskCreateExt(AppStartTask, 
                    (void *)0, 
                    (OS_STK *)&AppStartTaskStk[TASK_STK_SIZE-1], 
                    TASK_START_PRIO, 
                    TASK_START_PRIO,
                    (OS_STK *)&AppStartTaskStk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);

#if OS_TASK_NAME_SIZE > 11                    
    OSTaskNameSet(TASK_START_PRIO, "Start Task", &err);
#endif

#if OS_TASK_NAME_SIZE > 14                    
    OSTaskNameSet(TASK_START_PRIO, "uC/OS-II Idle", &err);
#endif

#if (OS_TASK_NAME_SIZE > 14) && (OS_TASK_STAT_EN > 0)                    
    OSTaskNameSet(TASK_START_PRIO, "uC/OS-II Stat", &err);
#endif

    OSStart();                              /* Start multitasking (i.e. give control to uC/OS-II)      */
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                          STARTUP TASK
*
* Description : This is an example of a startup task.  As mentioned in the book's text, you MUST
*               initialize the ticker only once multitasking has started.
* Arguments   : p_arg   is the argument passed to 'AppStartTask()' by 'OSTaskCreate()'.
* Notes       : 1) The first line of code is used to prevent a compiler warning because 'p_arg' is not
*                  used.  The compiler should not generate any code for this statement.
*               2) Interrupts are enabled once the task start because the I-bit of the CCR register was
*                  set to 0 by 'OSTaskCreate()'.
*********************************************************************************************************
*/

static  void  AppStartTask (void *p_arg)
{
    p_arg = p_arg;

    BSP_Init_Interrupts();

#if OS_TASK_STAT_EN > 0
    OSStatInit();                           /* Determine CPU capacity                                  */
#endif

    AppEventCreate();                       /* Create the application's kernel objects                 */
    AppTaskCreate();                        /* Create the other application tasks                      */

    while (TRUE) {                          /* Task body, always written as an infinite loop.          */
        OSTimeDlyHMSM(0, 0, 0, 50);
    }
}

/*$PAGE*/
/*
*********************************************************************************************************
*                                     CREATE APPLICATION TASKS
*
* Description : none
* Arguments   : none
* Notes       : none
*********************************************************************************************************
*/
static  void  AppTaskCreate (void)
{
    INT8U  err;


    OSTaskCreateExt(AppTask1, 
                    (void *)0, 
                    (OS_STK *)&AppTask1Stk[TASK_STK_SIZE-1], 
                    TASK_1_PRIO,
                    TASK_1_PRIO,
                    (OS_STK *)&AppTask1Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_1_PRIO, "Serial #1", &err);

    OSTaskCreateExt(AppTask2, 
                    (void *)0, 
                    (OS_STK *)&AppTask2Stk[TASK_STK_SIZE-1], 
                    TASK_2_PRIO,
                    TASK_2_PRIO,
                    (OS_STK *)&AppTask2Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_2_PRIO, "Serial #2", &err);

    OSTaskCreateExt(AppTask3, 
                    (void *)0, 
                    (OS_STK *)&AppTask3Stk[TASK_STK_SIZE-1], 
                    TASK_3_PRIO,
                    TASK_3_PRIO,
                    (OS_STK *)&AppTask3Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_3_PRIO, "Display", &err);

    OSTaskCreateExt(AppTask4, 
                    (void *)0, 
                    (OS_STK *)&AppTask4Stk[TASK_STK_SIZE-1], 
                    TASK_4_PRIO,
                    TASK_4_PRIO,
                    (OS_STK *)&AppTask4Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_4_PRIO, "PID Control", &err);

    OSTaskCreateExt(AppTask5, 
                    (void *)0, 
                    (OS_STK *)&AppTask5Stk[TASK_STK_SIZE-1], 
                    TASK_5_PRIO,
                    TASK_5_PRIO,
                    (OS_STK *)&AppTask5Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_5_PRIO, "Network", &err);

    OSTaskCreateExt(AppTask6, 
                    (void *)0, 
                    (OS_STK *)&AppTask6Stk[TASK_STK_SIZE-1], 
                    TASK_6_PRIO,
                    TASK_6_PRIO,
                    (OS_STK *)&AppTask6Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_6_PRIO, "Keyboard", &err);

    OSTaskCreateExt(AppTask7, 
                    (void *)0, 
                    (OS_STK *)&AppTask7Stk[TASK_STK_SIZE-1], 
                    TASK_7_PRIO,
                    TASK_7_PRIO,
                    (OS_STK *)&AppTask7Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_7_PRIO, "Analog In", &err);

    OSTaskCreateExt(AppTask8, 
                    (void *)0, 
                    (OS_STK *)&AppTask8Stk[TASK_STK_SIZE-1], 
                    TASK_8_PRIO,
                    TASK_8_PRIO,
                    (OS_STK *)&AppTask8Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_8_PRIO, "Discrete I/O", &err);

    OSTaskCreateExt(AppTask9, 
                    (void *)0, 
                    (OS_STK *)&AppTask9Stk[TASK_STK_SIZE-1], 
                    TASK_9_PRIO,
                    TASK_9_PRIO,
                    (OS_STK *)&AppTask9Stk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_9_PRIO, "User #1", &err);

    OSTaskCreateExt(AppTaskA, 
                    (void *)0, 
                    (OS_STK *)&AppTaskAStk[TASK_STK_SIZE-1], 
                    TASK_A_PRIO,
                    TASK_A_PRIO,
                    (OS_STK *)&AppTaskAStk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_A_PRIO, "Modbus", &err);

    OSTaskCreateExt(AppTaskB, 
                    (void *)0, 
                    (OS_STK *)&AppTaskBStk[TASK_STK_SIZE-1], 
                    TASK_B_PRIO,
                    TASK_B_PRIO,
                    (OS_STK *)&AppTaskBStk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_B_PRIO, "GPS", &err);

    OSTaskCreateExt(AppTaskC, 
                    (void *)0, 
                    (OS_STK *)&AppTaskCStk[TASK_STK_SIZE-1], 
                    TASK_C_PRIO,
                    TASK_C_PRIO,
                    (OS_STK *)&AppTaskCStk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_C_PRIO, "Task C", &err);

    OSTaskCreateExt(AppTaskD, 
                    (void *)0, 
                    (OS_STK *)&AppTaskDStk[TASK_STK_SIZE-1], 
                    TASK_D_PRIO,
                    TASK_D_PRIO,
                    (OS_STK *)&AppTaskDStk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_D_PRIO, "Task D", &err);

    OSTaskCreateExt(AppTaskE, 
                    (void *)0, 
                    (OS_STK *)&AppTaskEStk[TASK_STK_SIZE-1], 
                    TASK_E_PRIO,
                    TASK_E_PRIO,
                    (OS_STK *)&AppTaskEStk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_E_PRIO, "Task E", &err);

    OSTaskCreateExt(AppTaskF, 
                    (void *)0, 
                    (OS_STK *)&AppTaskFStk[TASK_STK_SIZE-1], 
                    TASK_F_PRIO,
                    TASK_F_PRIO,
                    (OS_STK *)&AppTaskFStk[0],
                    TASK_STK_SIZE,
                    (void *)0,
                    OS_TASK_OPT_STK_CHK | OS_TASK_OPT_STK_CLR);
    OSTaskNameSet(TASK_F_PRIO, "Task F", &err);
}

/*
*********************************************************************************************************
*                                         CREATE EVENTS
*
* Description : This function creates semaphores, mailboxes, queues, mutexes and event flags.
* Arguments   : none
* Notes       : none
*********************************************************************************************************
*/
static  void  AppEventCreate (void)
{
    INT8U  err;


#if OS_SEM_EN > 0
    EventSem1   = OSSemCreate(1);
    OSEventNameSet(EventSem1, "Sem. #1", &err);

    EventSem2   = OSSemCreate(1);
    OSEventNameSet(EventSem2, "Sem. #2", &err);
#endif

#if OS_MBOX_EN > 0
    EventMbox1  = OSMboxCreate((void *)1);
    OSEventNameSet(EventMbox1, "Mailbox #1", &err);

    EventMbox2  = OSMboxCreate((void *)1);
    OSEventNameSet(EventMbox2, "Mailbox #2", &err);
#endif

#if OS_Q_EN > 0
    EventQ1     = OSQCreate(&EventQTbl1[0], EVENT_Q_1_SIZE);
    OSEventNameSet(EventQ1, "Queue #1", &err);

    EventQ2     = OSQCreate(&EventQTbl2[0], EVENT_Q_2_SIZE);
    OSEventNameSet(EventQ2, "Queue #2", &err);
#endif

#if OS_MUTEX_EN > 0
    EventMutex1 = OSMutexCreate(MUTEX_PIP_1, &err);
    OSEventNameSet(EventMutex1, "Mutex #1", &err);

    EventMutex2 = OSMutexCreate(MUTEX_PIP_2, &err);
    OSEventNameSet(EventMutex2, "Mutex #2", &err);
#endif

#if OS_FLAG_EN > 0
    FlagGrp1    = OSFlagCreate(0x00FF, &err);
    OSFlagNameSet(FlagGrp1, "Flag #1", &err);

    FlagGrp2    = OSFlagCreate(0xFF00, &err);
    OSFlagNameSet(FlagGrp2, "Flag #2", &err);
#endif

#if OS_MEM_EN > 0
    MemPart1    = OSMemCreate(&MemPart1Tbl[0], MEM_BLKS_1, MEM_BLK_SIZE_1, &err);
    OSMemNameSet(MemPart1, "Partition #1", &err);

    MemPart2    = OSMemCreate(&MemPart2Tbl[0], MEM_BLKS_2, MEM_BLK_SIZE_2, &err);
    OSMemNameSet(MemPart2, "Partition #2", &err);
#endif
}

/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #1
*********************************************************************************************************
*/

static  void  AppTask1 (void *p_arg)
{
    INT8U   err;
#if OS_MEM_EN > 0
    INT8U  *pblk1;
    INT8U  *pblk2;
    INT8U  *pblk3;
    INT8U  *pblk4;
    INT8U  *pblk5;
#endif


    p_arg = p_arg;
    while (TRUE) {
        AppTask1Ctr++;
#if OS_SEM_EN > 0
        OSSemPend(EventSem2, 0, &err);
        OSTimeDly(100);
        OSSemPost(EventSem2);
#endif
#if OS_MEM_EN > 0
        pblk1 = (INT8U *)OSMemGet(MemPart1, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        pblk2 = (INT8U *)OSMemGet(MemPart1, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        pblk3 = (INT8U *)OSMemGet(MemPart1, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        pblk4 = (INT8U *)OSMemGet(MemPart1, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        pblk5 = (INT8U *)OSMemGet(MemPart1, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        OSMemPut(MemPart1, (void *)pblk1);
        OSMemPut(MemPart1, (void *)pblk2);
        OSMemPut(MemPart1, (void *)pblk3);
        OSMemPut(MemPart1, (void *)pblk4);
        OSMemPut(MemPart1, (void *)pblk5);
#endif
        OSTimeDly(1);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #2
*********************************************************************************************************
*/

static  void  AppTask2 (void *p_arg)
{
    INT8U   err;
#if OS_MEM_EN > 0
    INT8U  *pblk1;
    INT8U  *pblk2;
    INT8U  *pblk3;
    INT8U  *pblk4;
    INT8U  *pblk5;
#endif


    p_arg = p_arg;
    while (TRUE) {
        AppTask2Ctr++;
#if OS_SEM_EN > 0
        OSSemPend(EventSem2, 0, &err);
        OSTimeDly(100);
        OSSemPost(EventSem2);
#endif
#if OS_MEM_EN > 0
        pblk1 = (INT8U *)OSMemGet(MemPart2, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        pblk2 = (INT8U *)OSMemGet(MemPart2, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        pblk3 = (INT8U *)OSMemGet(MemPart2, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        pblk4 = (INT8U *)OSMemGet(MemPart2, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        pblk5 = (INT8U *)OSMemGet(MemPart2, &err);
        OSTimeDly(OS_TICKS_PER_SEC);
        OSMemPut(MemPart2, (void *)pblk1);
        OSMemPut(MemPart2, (void *)pblk2);
        OSMemPut(MemPart2, (void *)pblk3);
        OSMemPut(MemPart2, (void *)pblk4);
        OSMemPut(MemPart2, (void *)pblk5);
#endif
        OSTimeDly(1);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #3
*********************************************************************************************************
*/

static  void  AppTask3 (void *p_arg)
{
    INT8U  err;


    p_arg = p_arg;
    while (TRUE) {
        AppTask3Ctr++;
#if OS_SEM_EN > 0
        OSSemPend(EventSem2, 0, &err);
        OSTimeDly(100);
        OSSemPost(EventSem2);
#endif
        OSTimeDly(1);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #4
*********************************************************************************************************
*/

static  void  AppTask4 (void *p_arg)
{
    p_arg = p_arg;
    while (TRUE) {
        AppTask4Ctr++;
#if OS_Q_EN > 0
        OSQPost(EventQ1, (void *)"Msg #1 to Q1");
        OSTimeDly(10);
        OSQPost(EventQ2, (void *)"Msg #2 to Q2");
#endif
        OSTimeDly(20);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #5
*********************************************************************************************************
*/

static  void  AppTask5 (void *p_arg)
{
    p_arg = p_arg;
    while (TRUE) {
        AppTask5Ctr++;
#if OS_Q_EN > 0
        OSQPost(EventQ1, (void *)"Msg #3 to Q1");
        OSTimeDly(20);
        OSQPost(EventQ2, (void *)"Msg #4 to Q2");
#endif
        OSTimeDly(40);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #6
*********************************************************************************************************
*/

static  void  AppTask6 (void *p_arg)
{
    INT8U   err;
    char   *pmsg;
    char    s[30];


    p_arg = p_arg;
    while (TRUE) {
        AppTask6Ctr++;
#if OS_Q_EN > 0
        pmsg = (char *)OSQPend(EventQ1, 0, &err);
        strcpy(s, pmsg);
#endif
        OSTimeDly(1);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #7
*********************************************************************************************************
*/

static  void  AppTask7 (void *p_arg)
{
    INT8U   err;
    char   *pmsg;
    char    s[30];


    p_arg = p_arg;
    while (TRUE) {
        AppTask7Ctr++;
#if OS_Q_EN > 0
        pmsg = (char *)OSQPend(EventQ2, 0, &err);
        strcpy(s, pmsg);
#endif
        OSTimeDly(1);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #8
*********************************************************************************************************
*/

static  void  AppTask8 (void *p_arg)
{
    INT8U  err;


    p_arg = p_arg;
    while (TRUE) {
        AppTask8Ctr++;
#if OS_FLAG_EN > 0
        OSFlagPost(FlagGrp1, 0x000F, OS_FLAG_SET, &err);
        OSTimeDly(100);
        OSFlagPost(FlagGrp1, 0x00F0, OS_FLAG_SET, &err);
        OSTimeDly(100);
        OSFlagPost(FlagGrp1, 0x0F00, OS_FLAG_SET, &err);
        OSTimeDly(100);
        OSFlagPost(FlagGrp1, 0xF000, OS_FLAG_SET, &err);
        OSTimeDly(100);
#endif
        OSTimeDly(1);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #9
*********************************************************************************************************
*/

static  void  AppTask9 (void *p_arg)
{
    INT8U  err;


    p_arg = p_arg;
    while (TRUE) {
        AppTask9Ctr++;
#if OS_FLAG_EN > 0
        OSFlagPend(FlagGrp1, 0x00FF, OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, 100, &err);
#endif
        OSTimeDly(100);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #A
*********************************************************************************************************
*/

static  void  AppTaskA (void *p_arg)
{
    INT8U  err;


    p_arg = p_arg;
    while (TRUE) {
        AppTaskACtr++;
#if OS_FLAG_EN > 0
        OSFlagPend(FlagGrp1, 0xFF00, OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, 100, &err);
#endif
        OSTimeDly(100);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #B
*********************************************************************************************************
*/

static  void  AppTaskB (void *p_arg)
{
    INT8U  err;


    p_arg = p_arg;
    while (TRUE) {
        AppTaskBCtr++;
#if OS_FLAG_EN > 0
        OSFlagPend(FlagGrp1, 0x0FF0, OS_FLAG_WAIT_SET_ALL + OS_FLAG_CONSUME, 100, &err);
#endif
        OSTimeDly(100);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #A
*********************************************************************************************************
*/

static  void  AppTaskC (void *p_arg)
{
    INT8U  err;


    p_arg = p_arg;
    while (TRUE) {
        AppTaskCCtr++;
#if OS_MUTEX_EN > 0
        OSMutexPend(EventMutex1, 0, &err);
        OSTimeDly(100);
        OSMutexPost(EventMutex1);
#endif
        OSTimeDly(1);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #D
*********************************************************************************************************
*/

static  void  AppTaskD (void *p_arg)
{
    INT8U  err;


    p_arg = p_arg;
    while (TRUE) {
        AppTaskDCtr++;
#if OS_MUTEX_EN > 0
        OSMutexPend(EventMutex1, 0, &err);
        OSTimeDly(100);
        OSMutexPost(EventMutex1);
#endif
        OSTimeDly(1);
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #E
*********************************************************************************************************
*/

static  void  AppTaskE (void *p_arg)
{
    p_arg = p_arg;
    while (TRUE) {
        AppTaskECtr++;
#if OS_MBOX_EN > 0
        OSMboxPost(EventMbox1, (void *)"Msg #1");
        OSTimeDly(100);
        OSMboxPost(EventMbox1, (void *)"Msg #2");
        OSTimeDly(100);
        OSMboxPost(EventMbox1, (void *)"Msg #3");
        OSTimeDly(100);
#endif
        OSTimeDly(1);
    }
}

/*$PAGE*/
/*
*********************************************************************************************************
*                                             TASK #F
*********************************************************************************************************
*/

static  void  AppTaskF (void *p_arg)
{
    INT8U  err;
    char  *pmsg;
    char   s[30];


    p_arg = p_arg;
    while (TRUE) {
        AppTaskFCtr++;
#if OS_MBOX_EN > 0
        pmsg = (char *)OSMboxPend(EventMbox1, 0, &err);
        strcpy(s, pmsg);
#endif
        OSTimeDly(1);
    }
}
