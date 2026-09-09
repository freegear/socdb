/*
*********************************************************************************************************
*                                               Philips LPC210x
*                                  LPC210x Kick Start Card Board Support Package
*
*                                    (c) Copyright 2004, Micrium, Weston, FL
*                                              All Rights Reserved
*
*
* File : BSP.C
* By   : Jean J. Labrosse
*********************************************************************************************************
*/

#include <includes.h>

/*
*********************************************************************************************************
*                                              CONSTANTS
*********************************************************************************************************
*/

#define  BSP_UNDEF_INSTRUCTION_VECTOR_ADDR   (*(INT32U *)0x00000004L)
#define  BSP_SWI_VECTOR_ADDR                 (*(INT32U *)0x00000008L)
#define  BSP_PREFETCH_ABORT_VECTOR_ADDR      (*(INT32U *)0x0000000CL)
#define  BSP_DATA_ABORT_VECTOR_ADDR          (*(INT32U *)0x00000010L)
#define  BSP_IRQ_VECTOR_ADDR                 (*(INT32U *)0x00000018L)
#define  BSP_FIQ_VECTOR_ADDR                 (*(INT32U *)0x0000001CL)

#define  BSP_IRQ_ISR_ADDR                    (*(INT32U *)0x00000038L)
#define  BSP_FIQ_ISR_ADDR                    (*(INT32U *)0x0000003CL)

#define NUM_INTERRUPTS    33     /* 32 interrupt priorities + non-interrupt level. */
#define HARDWARE_INT_PRIO 0x0    /* The default hardware interrupt priority */
#define TIMER_PRESCALE    0x0    /* 0 = do not use the timer pre-scaler */ 

/* Timer control registers */
#define EN_TIMER_INT      0x4
#define CLEAR_INT         0x8
#define START_TIMER       0x10
#define SYSTEM_TICK       100
#define TIMER_INT_BIT     8

#define BIT( NO )          ( 0x1 << ( NO ) ) /* Sets bit number x */

/* Offset from register base address for system configuration registers */
#define INT_CONT_OFFSET   0xC00 /* Offset for interrupt control registers */
#define TIMER0_OFFSET     0x200 /* Offset for timer 0 control registers */

/* Pointer to interrupt control registers */
#define INT_CONT ( ( volatile struct IntContReg * ) ( EXC_REGISTERS_BASE + INT_CONT_OFFSET ) )

#define TIMER    ( ( volatile struct TimerReg * ) ( EXC_REGISTERS_BASE + TIMER0_OFFSET ) )
#define TIMER0_INT_PRIO  0x1

/*
*********************************************************************************************************
*                                               DATA TYPES
*********************************************************************************************************
*/

typedef enum int_sources {
    INT_PRIORITY_PLD0       = 0,
    INT_PRIORITY_PLD1       = 1,
    INT_PRIORITY_PLD2       = 2,
    INT_PRIORITY_PLD3       = 3,
    INT_PRIORITY_PLD4       = 4,
    INT_PRIORITY_PLD5       = 5,
    INT_PRIORITY_EXTPIN     = 6,
    INT_PRIORITY_UART       = 7,
    INT_PRIORITY_TIMER0     = 8,
    INT_PRIORITY_TIMER1     = 9,
    INT_PRIORITY_PLL        = 10,
    INT_PRIORITY_EBI        = 11,
    INT_PRIORITY_STRIPE_PLD = 12,
    INT_PRIORITY_AHB1_2     = 13,
    INT_PRIORITY_TX         = 14,
    INT_PRIORITY_RX         = 15,
    INT_PRIORITY_FASTCOMMS  = 16,
    NUM_INT_PRIORITIES      = 17
} int_sources_E;

struct IntContReg
{
    unsigned int maskSet;            /* Enable interrupt sources */
    unsigned int maskClear;          /* Disable interrupt sources */
    unsigned int sourceStatus;       /* Interrupt sources currently active */
    unsigned int requestStatus;      /* Interrupt sources enabled and currently active */
    unsigned int id;                 /* Id of the highest-priority interrupt that is enabled and active */
    unsigned int pldPriority;        /* Priority of the PLD interrupt */
    unsigned int mode;               /* PLD interrupt operating mode */ 
    unsigned int aDummy[25];         /* Not used */
    unsigned int aIntPriority[ NUM_INT_PRIORITIES ];   /* HW interrupt priority registers */
};

struct TimerReg
{
    unsigned int csr;                /* Timer 0 control and status register */
    unsigned int aDummy1[3];         /* Not used */
    unsigned int pre;                /* Timer 0 pre-scaler register */
    unsigned int aDummy2[3];         /* Not used */
    unsigned int limit;              /* Timer 0 limit register */
    unsigned int aDummy3[3];         /* Not used */
    unsigned int read;               /* Timer 0 read register */
};

/*
*********************************************************************************************************
*                                              VARIABLES
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*                                              PROTOTYPES
*********************************************************************************************************
*/

#include <rt_misc.h>

#pragma import(__use_no_semihosting_swi)

extern unsigned int Image$$SVC_STACK$$ZI$$Limit[];

__value_in_regs struct __initial_stackheap 
__user_initial_stackheap( unsigned R0, 
                          unsigned SP, 
                          unsigned R2, 
                          unsigned SL )
{
    struct __initial_stackheap config;
    unsigned int zi_end = ( unsigned int ) Image$$SVC_STACK$$ZI$$Limit;

    config.heap_base   = zi_end;
    config.stack_base  = zi_end - 0x200;
    config.heap_limit  = 0x200;
    config.stack_limit = 0x200;

    return config;
}

/*
*********************************************************************************************************
*                                         TIMER #0 IRQ HANDLER
*
* Description : This function handles the timer interrupt that is used to generate TICKs for uC/OS-II.
*               
* Arguments   : none
*********************************************************************************************************
*/

static void 
Tmr_TickISR_Handler( void )
{
    TIMER->csr |= CLEAR_INT;

    OSTimeTick();                       /* If the interrupt is from the tick source, call OSTimeTick() */
}

/*
*********************************************************************************************************
*                                       TICKER INITIALIZATION
*
* Description : This function is called to initialize uC/OS-II's tick source (typically a timer generating
*               interrupts every 1 to 100 mS).
*               
* Arguments   : none
*********************************************************************************************************
*/

static void 
Tmr_TickInit( void )
{
    unsigned int timer_limit;

    /* Set the timer mode to free-running heartbeat mode (bit 1..0 = 00) */
    TIMER->csr = 0x0; 

    /* Enable timer interrupt by setting bit 2 */
    TIMER->csr |= EN_TIMER_INT;

    /* Clear pending interrupt for timer by setting bit 3 */
    TIMER->csr |= CLEAR_INT;

    /* Calc timer limit */
    timer_limit = EXC_AHB2_CLK_FREQUENCY / SYSTEM_TICK;

    /* Initialize the timer pre-scaler with TIMER_PRESCALE */
    TIMER->pre = TIMER_PRESCALE;

    /* Set the timer limit register */
    TIMER->limit = timer_limit;

    /* Start the timer by setting bit 4 */
    TIMER->csr |= START_TIMER;
}

static void
int_ctrl_init( void )
{
   int i;

   /* Disable all interrupts */
   INT_CONT->maskClear = 0xFFFFFFFF;

   /* Set the operating mode of the int controller to six individual PLD interrupts */
   INT_CONT->mode = 0x3;

   /* Set hardware priority for all interrupt sources to 0x1 */
   for ( i = 0; i < NUM_INT_PRIORITIES; i++ )
   {
      INT_CONT->aIntPriority[ i ] = HARDWARE_INT_PRIO;
   }
}

static void
int_ctrl_set( unsigned int set_mask )
{
   INT_CONT->maskSet = set_mask;
   INT_CONT->aIntPriority[ INT_PRIORITY_TIMER0 ] = TIMER0_INT_PRIO;
}

/*
*********************************************************************************************************
*                                         BSP INITIALIZATION
*
* Description : This function should be called by your application code before you make use of any of the
*               functions found in this module.
*               
* Arguments   : none
*********************************************************************************************************
*/

void 
BSP_Init( void )
{
    BSP_IRQ_VECTOR_ADDR               = 0xE59FF018;             /* LDR PC,[PC,#0x18] instruction       */
    BSP_IRQ_ISR_ADDR                  = (INT32U)OS_CPU_IRQ_ISR; /* IRQ exception vector address        */

    BSP_FIQ_VECTOR_ADDR               = 0xE59FF018;             /* LDR PC,[PC,#0x18] instruction       */
    BSP_FIQ_ISR_ADDR                  = (INT32U)OS_CPU_FIQ_ISR; /* FIQ exception vector address        */

    BSP_UNDEF_INSTRUCTION_VECTOR_ADDR = 0xEAFFFFFE;             /* Jump to itself                      */
    BSP_SWI_VECTOR_ADDR               = 0xEAFFFFFE;
    BSP_PREFETCH_ABORT_VECTOR_ADDR    = 0xEAFFFFFE;
    BSP_DATA_ABORT_VECTOR_ADDR        = 0xEAFFFFFE;
    BSP_FIQ_VECTOR_ADDR               = 0xEAFFFFFE;

    int_ctrl_init( );
}

void
BSP_Init_Interrupts( void )
{
    Tmr_TickInit( );
    int_ctrl_set( BIT( TIMER_INT_BIT ) );
}

/*
*********************************************************************************************************
*                                           IRQ ISR HANDLER
*
* Description : This function is called by OS_CPU_IRQ_ISR() to determine the source of the interrupt
*               and process it accordingly.
*
* Arguments   : none
*********************************************************************************************************
*/

void 
OS_CPU_IRQ_ISR_Handler( void )
{
    unsigned int int_bits_set = INT_CONT->requestStatus;

    while ( int_bits_set )
    {
        if ( int_bits_set & BIT( TIMER_INT_BIT ) )
        {
            int_bits_set &= ~BIT( TIMER_INT_BIT );
            Tmr_TickISR_Handler();
        }
    }
}


/*
*********************************************************************************************************
*                                           FIQ ISR HANDLER
*
* Description : This function is called by OS_CPU_FIQ_ISR() to determine the source of the interrupt
*               and process it accordingly.
*
* Arguments   : none
*********************************************************************************************************
*/

void 
OS_CPU_FIQ_ISR_Handler( void )
{
    unsigned int int_bits_set = INT_CONT->requestStatus;

    while ( int_bits_set )
    {
    }
}


