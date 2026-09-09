/*
*********************************************************************************************************
*                                                uC/OS-II
*                                          The Real-Time Kernel
*
*                        (c) Copyright 1992-1998, Jean J. Labrosse, Plantation, FL
*                                           All Rights Reserved
*
*                                                 V2.51
*
*                                               EXAMPLE #1
*********************************************************************************************************
*/
//#include "stdio.h"
#include <stdio.h>
#include "includes.h"


// Include for SDI V5
#include "sysinc.h"
#include "commonmacro.h"
#include "lib.h"
#include "irq.h"

/*
*********************************************************************************************************
*                                               CONSTANTS
*********************************************************************************************************
*/

#define  TASK_STK_SIZE                 512		// Size of each task's stacks (# of WORDs)
#define  N_TASKS                       3		// Number of identical tasks

/* When you wanna test a peri-module, define the following */
#define INTERRUPT_TEST          0
#define TIMER_PWM_TEST          0
#define WDT_TEST                0
#define UART_TEST               0
#define I2C_TEST                0
#define GPIO_TEST               0
#define ADC_TEST                0
#define SMC_TEST                0
#define FMC_TEST                0
#define PWR_TEST                0
#define REGISTER_TEST           0


/*
*********************************************************************************************************
*                                               VARIABLES
*********************************************************************************************************
*/

OS_STK		TaskStk[N_TASKS][TASK_STK_SIZE];	// Tasks stacks
OS_STK		TaskStartStk[TASK_STK_SIZE];

/*
*********************************************************************************************************
*                                           FUNCTION PROTOTYPES
*********************************************************************************************************
*/

smtUint32 VICTest(void);
smtUint32 TimerTest(void);
smtUint32 WDTTest(void);
smtUint32 UARTTest(void);
smtUint32 I2CTest(void);
smtUint32 GPIOTest(void);
smtUint32 ADCTest(void);
smtUint32 ESMCTest(void);
smtUint32 FMCTest(void);
smtUint32 PWRManageTest(void);
smtUint32 RegisterTest(void);

void   Task1(void *data);			// Function prototypes of tasks
void   Task2(void *data);			// Function prototypes of tasks
void   Task3(void *data);
void   TaskStart(void *data);		// Function prototypes of Startup task

/*$PAGE*/

/*
*********************************************************************************************************
*                                                MAIN
*********************************************************************************************************
*/

extern void SerialInit(void);
/*$PAGE*/

/*-----------------------------------------------------------------------
    Function name   : Main()
    Prototype           : void Main(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void Main(void)
{

    SerialInit();
    //printf("\nC_Entry...\n");

    //DisableInterrupt(); //Interrupt disable all
    OSInit();				// Initialize uC/OS-II
    //printf("\nOSInit...\n");

    OSTaskCreate(TaskStart, (void *)0,&TaskStartStk[TASK_STK_SIZE - 1], 7);
    //printf("\nOSTaskCreate...\n");

    OSStart();				// Start multitasking
    //printf("\nOSStart...\n");
}

/*
*********************************************************************************************************
*                                              STARTUP TASK
*********************************************************************************************************
*/
/*-----------------------------------------------------------------------
    Function name   : TaskStart()
    Prototype           : void TaskStart(void *data)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void TaskStart (void *data)
{
    //char   s[100];

    //OSTimer0_Period_Setting();
    //OSTimer0_Interrupt_Setting();	// Timer Enable

    //BoardInit();					// Board initialize

#if OS_TASK_STAT_EN>0
    OSStatInit();					// Initialize uC/OS-II's statistics
#endif

    // Application task create.
    OSTaskCreate(Task1,(void *)"Task1",&TaskStk[0][TASK_STK_SIZE - 1],8);
    OSTaskCreate(Task2,(void *)"Task2",&TaskStk[1][TASK_STK_SIZE - 1],9);

    for (;;) 
    {
        printf("\n-------------------------------");
        printf("\nRunning Task : %5d\n", OSTaskCtr);	//* Display #tasks running
        printf("Cpu Usage : %3d\n", OSCPUUsage);		//* Display CPU usage in %, Display #context switches per second
        printf("Context Switches per Sec : %5d\n",(int)OSCtxSwCtr);  
        printf("\n-------------------------------\n");
        OSCtxSwCtr = 0;
        OSTimeDlyHMSM(0, 0, 1, 0);						// Wait one second
    }
}
/*$PAGE*/
/*
*********************************************************************************************************
*                                                  TASKS
*********************************************************************************************************
*/

/*-----------------------------------------------------------------------
    Function name   : Task1()
    Prototype           : void Task1(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void Task1(void *data)
{
    for (;;)
    {
        //printf((char *)data);
        //printf("-----------------------\n");	
        OSTimeDly(50);                            
    }
}

/*-----------------------------------------------------------------------
    Function name   : Task2()
    Prototype           : void Task2(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void Task2(void *data)
{
    for (;;)
    {
        //printf((char *)data);
        //printf("-----------------------\n");	
        OSTimeDly(20);                            
    }
}



/*-----------------------------------------------------------------------
    Function name   : Task3()
    Prototype           : void Task3(void)
    Return              : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void Task3(void *data)
{
    smtUint32 errorCode = 0;	// Valid only last 4 bit

    // 1. VIC Initialization
    EnableVIC(VIC_POLARITY, VIC_LEVEL, VIC_INTMOD);

    // Other Initialization
    // GPIO & Timer/PWM & UART & ADC & WDT -> Further work (When test evaluation board)


    ///////////////////////////
    // 2. Module Test
    // Interrupt Controller Test
#if REGISTER_TEST
    errorCode = RegisterTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if INTERRUPT_TEST
    errorCode = VICTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if TIMER_PWM_TEST
    errorCode = TimerTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if WDT_TEST
    errorCode = WDTTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if UART_TEST
    errorCode = UARTTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if I2C_TEST
    errorCode = I2CTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if GPIO_TEST
    errorCode = GPIOTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if ADC_TEST
    errorCode = ADCTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if SMC_TEST
    errorCode = ESMCTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if FMC_TEST
    errorCode = FMCTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

#if PWR_TEST
    errorCode = PWRManageTest();
    if(errorCode != NO_ERROR)
        goto out;
#endif

out :
    SMT_WRITE(GPIO_CON2, 0x0000FFFF);	// GPIO2 : all push-pull output
    // Stop Simulation
    SMT_WRITE(GPIO_DAT2, 0x000000D0 | (errorCode&0x0000000F));

    // inifinte loop & never return
    while(1);
}