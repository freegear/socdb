/*----------------------------------------------------------
	File Name   : timerpwm.c 
	Description : Timer & PWM test routine
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */

#include "sysinc.h"
#include "Commonmacro.h"
#include "irq.h"
#include "lib.h"
#include "timerpwm.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define TIMER0_DAT      0x10 
#define TIMER1_DAT      0x8 
#define TIMER2_DAT      0x5 
#define TIMER3_DAT      0x5 
#define TIMER4_DAT      0x3 
#define TIMER5_DAT      0x3 
#define TIMER6_DAT      0x4 
#define TIMER7_DAT      0x5 

#define TIMER4_IntervalDAT      0x170 
#define TIMER5_IntervalDAT      0x140 
#define TIMER6_IntervalDAT      0x130 
#define TIMER7_IntervalDAT      0x110 

#define TIMER4_IntervalPRE      0x2
#define TIMER5_IntervalPRE      0x2
#define TIMER6_IntervalPRE      0x2
#define TIMER7_IntervalPRE      0x2

#define TIMER0_PRE      0x1
#define TIMER1_PRE      0x1
#define TIMER2_PRE      0x1
#define TIMER3_PRE      0x1
#define TIMER4_PRE      0x0
#define TIMER5_PRE      0x0
#define TIMER6_PRE      0x0
#define TIMER7_PRE      0x0

#define TIMER0_CAPPRE      0x10
#define TIMER1_CAPPRE      0x20
#define TIMER2_CAPPRE      0x10
#define TIMER3_CAPPRE      0x30

#define TIMER4_CAPPRE      0x5
#define TIMER5_CAPPRE      0x10
#define TIMER6_CAPPRE      0x5
#define TIMER7_CAPPRE      0x10

#define PWM0_PRE        0x5
#define PWM1_PRE        0x5
#define PWM2_PRE        0x5
#define PWM3_PRE        0x5
#define PWM4_PRE        0x5
#define PWM5_PRE        0x5
#define PWM6_PRE        0x5
#define PWM7_PRE        0x5

#define PWM0_DAT        0x1100 
#define PWM1_DAT        0x500 
#define PWM2_DAT        0x4000 
#define PWM3_DAT        0x3000 
#define PWM4_DAT        0x1010 
#define PWM5_DAT        0x600 
#define PWM6_DAT        0x400 
#define PWM7_DAT        0x600 

#define PWM0_END        0x2000
#define PWM1_END        0x1600
#define PWM2_END        0x6000
#define PWM3_END        0x4300
#define PWM4_END        0x1880
#define PWM5_END        0x2000
#define PWM6_END        0x3000
#define PWM7_END        0x1000

#define INTERRUPT_COUNT     0x8
#define TINTERRUPT_COUNT    0x10
#define TIMERPWM_MASK       0xff
#define TIMER_READ_OK       0x1
#define TIMER_FAIL          0x0

/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

smtUint32 TimerTest(void);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */

volatile static smtInt32 interruptCountMatch = 0;
volatile static smtInt32 interruptCountOver = 0;

volatile static smtInt32 interruptCountCap0 = 0;
volatile static smtInt32 interruptCountCap1 = 0;
volatile static smtInt32 interruptCountCap2 = 0;
volatile static smtInt32 interruptCountCap3 = 0;

volatile static smtInt32 interruptCountVIC0 = 0;
volatile static smtInt32 interruptCountVIC1 = 0;
volatile static smtInt32 interruptCountVIC2 = 0;
volatile static smtInt32 interruptCountVIC3 = 0;

volatile static smtInt32 matchMask = 0x0000;
volatile static smtInt32 overMask  = 0x0000;

/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : TimerTest()
    Prototype       : void TimerTest(void)
    Return          : void
    Argument        :
    Comments        :
            Timer & PWM test function
-----------------------------------------------------------------------*/
smtUint32 TimerTest(void)
{
    //Gpio setting
    TimerPwmGpioSet();


    //SMT_WRITE(PWMCON, (0x01<<SHIFT_DN_FROM_MASK(STOP_CTL)));


    //Timer setting for testing Interval mode
    TimerSetTestInterval();

    // PWM setting
    PwmSet0();
    PwmSet1();
    PwmSet2();
    PwmSet3();

    // Delay to be occured interrupt
    smtDelay100us(3);

    //if((interruptCountMatch) == INTERRUPT_COUNT && 
       //(matchMask == TIMERPWM_MASK))
    if((interruptCountMatch) == INTERRUPT_COUNT && 
       (matchMask == TIMERPWM_MASK))
    {
        interruptCountMatch = 0;
        interruptCountOver  = 0;
        matchMask   = 0x0000;
        overMask    = 0x0000;

        //Timer setting for testing MatchOver mode
        TimerSetTestMatchOver();

        // Delay to be occured interrupt
        smtDelay100us(4);
        smtDelay100us(4);
        smtDelay100us(4);
        smtDelay100us(4);

        if((interruptCountMatch + interruptCountOver) == TINTERRUPT_COUNT &&
            matchMask == TIMERPWM_MASK &&
            overMask  == TIMERPWM_MASK)
        {
            interruptCountMatch = 0;
            interruptCountOver  = 0;
            interruptCountCap0  = 0;
            interruptCountCap1  = 0;
            interruptCountCap2  = 0;
            interruptCountCap3  = 0;
            matchMask   = 0x0000;
            overMask    = 0x0000;

            //Timer setting for testing capture mode
            TimerSetTestCapture();

            // Delay to be occured interrupt
            smtDelay100us(4);
            smtDelay100us(4);

            if(matchMask == 0xff)
                return NO_ERROR;
            else
            {

                return TIMER_PWM_ERROR;
            }
            //return NO_ERROR;
        }
        else
        {

            
            return TIMER_PWM_ERROR;
        }
        //return NO_ERROR;
    }
    else
    {
        // GPIO2 : all push-pull output
        SMT_WRITE(GPIO_CON0, 0x0000FFFF);	
	    // Stop Simulation
	    SMT_WRITE(GPIO_DAT0, 0xF1);
	    SMT_WRITE(GPIO_DAT0, (matchMask & 0x000000FF));
	    SMT_WRITE(GPIO_DAT0, (0x1 & 0x0000000F));
	    SMT_WRITE(GPIO_DAT0, (interruptCountMatch & 0x000000FF));

        return TIMER_PWM_ERROR;
    }
}


/*-----------------------------------------------------------------------
    Function name   : ReadTDAT()
    Prototype       : smtUint32 ReadTDAT(smtUint32)
    Return          : smtUint32
    Argument        : IRQ number
    Comments        : Read from Timer for checking data
-----------------------------------------------------------------------*/

smtUint32 ReadTDAT(smtUint32 IRQ)
{
    switch(IRQ)
    {

        case IRQ_TIMER0_TMC:
            if(SMT_READ(TDAT0) >= TIMER0_DAT)
                return TIMER_READ_OK;
            break;

        case IRQ_TIMER1_TMC:
            if(SMT_READ(TDAT1) >= TIMER1_DAT)
                return TIMER_READ_OK;
            break;

        case IRQ_TIMER2_TMC:
            if(SMT_READ(TDAT2) >= TIMER2_DAT)
                return TIMER_READ_OK;
            break;

        case IRQ_TIMER3_TMC:
            if(SMT_READ(TDAT3) >= TIMER3_DAT)
                return TIMER_READ_OK;
            break;

        case IRQ_TIMER4_TMC:
            if(SMT_READ(TDAT4) >= TIMER4_DAT)
                return TIMER_READ_OK;
            break;

        case IRQ_TIMER5_TMC:
            if(SMT_READ(TDAT5) >= TIMER5_DAT)
                return TIMER_READ_OK;
            break;

        case IRQ_TIMER6_TMC:
            if(SMT_READ(TDAT6) >= TIMER6_DAT)
                return TIMER_READ_OK;
            break;

        case IRQ_TIMER7_TMC:
            if(SMT_READ(TDAT7) >= TIMER7_DAT)
                return TIMER_READ_OK;
            break;
            
        default:
            return TIMER_FAIL;
    }

    return TIMER_FAIL;
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatch0()
    Prototype       : void TimerISRMatch0()
    Return          : void
    Argument        :
    Comments        : Timer Match ISR
-----------------------------------------------------------------------*/
void TimerISRMatch0(smtUint32 IRQ)
{
    interruptCountMatch++;

    // Read TDATA form timer for checking timer counter
    if(ReadTDAT(IRQ))
    {
        matchMask = 0x1 | matchMask;
    }
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatch1()
    Prototype       : void TimerISRMatch1()
    Return          : void
    Argument        :
    Comments        : Timer Match ISR
-----------------------------------------------------------------------*/
void TimerISRMatch1(smtUint32 IRQ)
{
    interruptCountMatch++;

    // Read TDATA form timer for checking timer counter
    if(ReadTDAT(IRQ))
    {
        matchMask = 0x2 | matchMask;
    }
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatch2()
    Prototype       : void TimerISRMatch2()
    Return          : void
    Argument        :
    Comments        : Timer Match ISR
-----------------------------------------------------------------------*/
void TimerISRMatch2(smtUint32 IRQ)
{
    interruptCountMatch++;

    // Read TDATA form timer for checking timer counter
    if(ReadTDAT(IRQ))
    {
        matchMask = 0x4 | matchMask;
    }

    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatch3()
    Prototype       : void TimerISRMatch3()
    Return          : void
    Argument        :
    Comments        : Timer Match ISR
-----------------------------------------------------------------------*/
void TimerISRMatch3(smtUint32 IRQ)
{
    interruptCountMatch++;
    matchMask = 0x8 | matchMask;

    // Read TDATA form timer for checking timer counter
    if(ReadTDAT(IRQ))
    {
        matchMask = 0x8 | matchMask;
    }
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatch4()
    Prototype       : void TimerISRMatch4()
    Return          : void
    Argument        :
    Comments        : Timer Match ISR
-----------------------------------------------------------------------*/
void TimerISRMatch4(smtUint32 IRQ)
{
    interruptCountMatch++;
    // Read TDATA form timer for checking timer counter
    if(ReadTDAT(IRQ))
    {
        matchMask = 0x10 | matchMask;
    }

    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatch5()
    Prototype       : void TimerISRMatch5()
    Return          : void
    Argument        :
    Comments        : Timer Match ISR
-----------------------------------------------------------------------*/
void TimerISRMatch5(smtUint32 IRQ)
{
    interruptCountMatch++;

    // Read TDATA form timer for checking timer counter
    if(ReadTDAT(IRQ))
    {
        matchMask = 0x20 | matchMask;
    }
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatch6()
    Prototype       : void TimerISRMatch6()
    Return          : void
    Argument        :
    Comments        : Timer Match ISR
-----------------------------------------------------------------------*/
void TimerISRMatch6(smtUint32 IRQ)
{
    interruptCountMatch++;

    // Read TDATA form timer for checking timer counter
    if(ReadTDAT(IRQ))
    {
        matchMask = 0x40 | matchMask;
    }
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatch7()
    Prototype       : void TimerISRMatch7()
    Return          : void
    Argument        :
    Comments        : Timer Match ISR
-----------------------------------------------------------------------*/
void TimerISRMatch7(smtUint32 IRQ)
{
    interruptCountMatch++;

    // Read TDATA form timer for checking timer counter
    if(ReadTDAT(IRQ))
    {
        matchMask = 0x80 | matchMask;
    }
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISROver0()
    Prototype       : void TimerISROver0()
    Return          : void
    Argument        :
    Comments        : Timer Overflow ISR
-----------------------------------------------------------------------*/
void TimerISROver0(smtUint32 IRQ)
{
    interruptCountOver++;
    //check over interrupt
    overMask = 0x01 | overMask;
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}


/*-----------------------------------------------------------------------
    Function name   : TimerISROver1()
    Prototype       : void TimerISROver1()
    Return          : void
    Argument        :
    Comments        : Timer Overflow ISR
-----------------------------------------------------------------------*/
void TimerISROver1(smtUint32 IRQ)
{
    interruptCountOver++;
    //check over interrupt
    overMask = 0x02 | overMask;
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISROver2()
    Prototype       : void TimerISROver2()
    Return          : void
    Argument        :
    Comments        : Timer Overflow ISR
-----------------------------------------------------------------------*/
void TimerISROver2(smtUint32 IRQ)
{
    interruptCountOver++;
    //check over interrupt
    overMask = 0x04 | overMask;
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISROver3()
    Prototype       : void TimerISROver3()
    Return          : void
    Argument        :
    Comments        : Timer Overflow ISR
-----------------------------------------------------------------------*/
void TimerISROver3(smtUint32 IRQ)
{
    interruptCountOver++;
    //check over interrupt
    overMask = 0x08 | overMask;
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISROver4()
    Prototype       : void TimerISROver4()
    Return          : void
    Argument        :
    Comments        : Timer Overflow ISR
-----------------------------------------------------------------------*/
void TimerISROver4(smtUint32 IRQ)
{
    interruptCountOver++;
    //check over interrupt
    overMask = 0x10 | overMask;
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISROver5()
    Prototype       : void TimerISROver5()
    Return          : void
    Argument        :
    Comments        : Timer Overflow ISR
-----------------------------------------------------------------------*/
void TimerISROver5(smtUint32 IRQ)
{
    interruptCountOver++;
    //check over interrupt
    overMask = 0x20 | overMask;
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISROver6()
    Prototype       : void TimerISROver6()
    Return          : void
    Argument        :
    Comments        : Timer Overflow ISR
-----------------------------------------------------------------------*/
void TimerISROver6(smtUint32 IRQ)
{
    interruptCountOver++;
    //check over interrupt
    overMask = 0x40 | overMask;
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISROver7()
    Prototype       : void TimerISROver7()
    Return          : void
    Argument        :
    Comments        : Timer Overflow ISR
-----------------------------------------------------------------------*/
void TimerISROver7(smtUint32 IRQ)
{
    interruptCountOver++;
    //check over interrupt
    overMask = 0x80 | overMask;
    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}


/*-----------------------------------------------------------------------
    Function name   : TimerPwmGpioSet()
    Prototype       : void TimerPwmGpioSet()
    Return          : void
    Argument        :
    Comments        : GPIO setting for timer
-----------------------------------------------------------------------*/
void TimerPwmGpioSet(void)
{
    //GPIO0 setting (Timer output 2'b11)
    SMT_WRITE(GPIO_CON0,
                         (0x3<<SHIFT_DN_FROM_MASK(GPIO_0)   
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_1)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_2)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_3)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_4)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_5)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_6)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_7)));

    //GPIO1 setting (input TCAP 2'b10) 
    SMT_WRITE(GPIO_CON1,
                         (0x2<<SHIFT_DN_FROM_MASK(GPIO_0)     
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_1)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_2)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_3)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_4)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_5)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_6)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_7)));


    //GPIO2 setting (Timer output  2'b01) 
    //GPIO2 setting (PWM output    2'b00) 
    //GPIO2 setting (push-puu output    2'b11) 
    SMT_WRITE(GPIO_CON2, 
                         (0x3<<SHIFT_DN_FROM_MASK(GPIO_0)   
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_1)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_2)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_3)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_4)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_5)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_6)
                        | 0x3<<SHIFT_DN_FROM_MASK(GPIO_7)));

    /*
    SMT_WRITE(GPIO_CON2, 
                         (0x0<<SHIFT_DN_FROM_MASK(GPIO_0)   
                        | 0x1<<SHIFT_DN_FROM_MASK(GPIO_1)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_2)
                        | 0x1<<SHIFT_DN_FROM_MASK(GPIO_3)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_4)
                        | 0x1<<SHIFT_DN_FROM_MASK(GPIO_5)
                        | 0x0<<SHIFT_DN_FROM_MASK(GPIO_6)
                        | 0x1<<SHIFT_DN_FROM_MASK(GPIO_7)));
                        */

    //GPIO03 setting ( External timer clcok 2'b10 )
    SMT_WRITE(GPIO_CON3, 
                         (0x2<<SHIFT_DN_FROM_MASK(GPIO_0) 
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_1)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_2)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_3)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_4)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_5)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_6)
                        | 0x2<<SHIFT_DN_FROM_MASK(GPIO_7)));
}


/*-----------------------------------------------------------------------
    Function name   : TimerSetTestInterval()
    Prototype       : void TimerSetTestInterval()
    Return          : void
    Argument        :
    Comments        : for checking the interval mode in timer function
-----------------------------------------------------------------------*/
void TimerSetTestInterval(void) 
{

    SMT_WRITE(TPRE0, TIMER0_PRE);   // Prescaler selection
    SMT_WRITE(TPRE1, TIMER1_PRE);
    SMT_WRITE(TPRE2, TIMER2_PRE);
    SMT_WRITE(TPRE3, TIMER3_PRE);

    SMT_WRITE(TPRE4, TIMER4_IntervalPRE);
    SMT_WRITE(TPRE5, TIMER5_IntervalPRE);
    SMT_WRITE(TPRE6, TIMER6_IntervalPRE);
    SMT_WRITE(TPRE7, TIMER7_IntervalPRE);

    SMT_WRITE(TDAT0, TIMER0_DAT);
    SMT_WRITE(TDAT1, TIMER1_DAT);
    SMT_WRITE(TDAT2, TIMER2_DAT);
    SMT_WRITE(TDAT3, TIMER3_DAT);

    SMT_WRITE(TDAT4, TIMER4_IntervalDAT);
    SMT_WRITE(TDAT5, TIMER5_IntervalDAT);
    SMT_WRITE(TDAT6, TIMER6_IntervalDAT);
    SMT_WRITE(TDAT7, TIMER7_IntervalDAT);

    //External clock used
    SMT_WRITE(TCON0, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //External clock 
                   );

    SMT_WRITE(TCON1, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //External clock
                   );

    SMT_WRITE(TCON2, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //External clock
                   );

    SMT_WRITE(TCON3, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //External clock
                   );


    //Internal clcok used
    //Gpio 2 port shared to used checking Error
    SMT_WRITE(TCON4, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  
                   );
  
    SMT_WRITE(TCON5, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) 
                   );

    SMT_WRITE(TCON6, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)
                   );

    //Gpio 2 port shared to used checking Error
    SMT_WRITE(TCON7, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)          |
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)
                   );
    
    // Register IRQ routine
    RequestIRQ(IRQ_TIMER0_TMC, TimerISRMatch0);
    RequestIRQ(IRQ_TIMER1_TMC, TimerISRMatch1);
    RequestIRQ(IRQ_TIMER2_TMC, TimerISRMatch2);
    RequestIRQ(IRQ_TIMER3_TMC, TimerISRMatch3);

    // VIC testing
    RequestIRQ(IRQ_TIMER4_TMC, TimerISRMatchVIC0);
    RequestIRQ(IRQ_TIMER5_TMC, TimerISRMatchVIC1);
    RequestIRQ(IRQ_TIMER6_TMC, TimerISRMatchVIC2);
    RequestIRQ(IRQ_TIMER7_TMC, TimerISRMatchVIC3);
}

/*-----------------------------------------------------------------------
    Function name   : TimerSetTestCapture
    Prototype       : void TimerSetTestCapture()
    Return          : void
    Argument        :
    Comments        : for checking the Capture mode in timer function
-----------------------------------------------------------------------*/
void TimerSetTestCapture(void)
{

    SMT_WRITE(TPRE0, TIMER0_CAPPRE); //Prescaler selection
    SMT_WRITE(TPRE1, TIMER1_CAPPRE);
    SMT_WRITE(TPRE2, TIMER2_CAPPRE);
    SMT_WRITE(TPRE3, TIMER3_CAPPRE);
    SMT_WRITE(TPRE4, TIMER4_CAPPRE);
    SMT_WRITE(TPRE5, TIMER5_CAPPRE);
    SMT_WRITE(TPRE6, TIMER6_CAPPRE);
    SMT_WRITE(TPRE7, TIMER7_CAPPRE);

    //clear counter
    SMT_WRITE(TCON0, 0x1<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR));
    SMT_WRITE(TCON1, 0x1<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR));
    SMT_WRITE(TCON2, 0x1<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR));
    SMT_WRITE(TCON3, 0x1<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR));
    SMT_WRITE(TCON4, 0x1<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR));
    SMT_WRITE(TCON5, 0x1<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR));
    SMT_WRITE(TCON6, 0x1<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR));
    SMT_WRITE(TCON7, 0x1<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR));


    //posedge
    SMT_WRITE(TCON0, 0x5<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR)     |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clcok
                   );

    SMT_WRITE(TCON1, 0x5<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR)     |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock
                   );

    //negedge
    SMT_WRITE(TCON2, 0x4<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR)     |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock
                   );

    SMT_WRITE(TCON3, 0x4<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR)     |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock
                   );

    //both edge
    SMT_WRITE(TCON4, 0x6<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR)     |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock
                   );
  
    SMT_WRITE(TCON5, 0x6<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR)     |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock
                   );

    SMT_WRITE(TCON6, 0x6<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR)     |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock
                   );

    SMT_WRITE(TCON7, 0x6<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_CNT_CLR)     |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)    //internal clock
                   );
    
    RequestIRQ(IRQ_TIMER0_TMC, TimerISRMatchTCAP0);
    RequestIRQ(IRQ_TIMER1_TMC, TimerISRMatchTCAP1);
    RequestIRQ(IRQ_TIMER2_TMC, TimerISRMatchTCAP2);
    RequestIRQ(IRQ_TIMER3_TMC, TimerISRMatchTCAP3);
    RequestIRQ(IRQ_TIMER4_TMC, TimerISRMatchTCAP4);
    RequestIRQ(IRQ_TIMER5_TMC, TimerISRMatchTCAP5);
    RequestIRQ(IRQ_TIMER6_TMC, TimerISRMatchTCAP6);
    RequestIRQ(IRQ_TIMER7_TMC, TimerISRMatchTCAP7);
}


/*-----------------------------------------------------------------------
    Function name   : TimerSetTestMatchOver
    Prototype       : void TimerSetTestMatchOver()
    Return          : void
    Argument        :
    Comments        : for testing the Match&overflow mode 
-----------------------------------------------------------------------*/
void TimerSetTestMatchOver(void)
{
    SMT_WRITE(TPRE0, TIMER0_PRE);   // Prescaler selection
    SMT_WRITE(TPRE1, TIMER1_PRE);
    SMT_WRITE(TPRE2, TIMER2_PRE);
    SMT_WRITE(TPRE3, TIMER3_PRE);
    SMT_WRITE(TPRE4, TIMER4_PRE);
    SMT_WRITE(TPRE5, TIMER5_PRE);
    SMT_WRITE(TPRE6, TIMER6_PRE);
    SMT_WRITE(TPRE7, TIMER7_PRE);

    SMT_WRITE(TDAT0, TIMER0_DAT);
    SMT_WRITE(TDAT1, TIMER1_DAT);
    SMT_WRITE(TDAT2, TIMER2_DAT);
    SMT_WRITE(TDAT3, TIMER3_DAT);
    SMT_WRITE(TDAT4, TIMER4_DAT);
    SMT_WRITE(TDAT5, TIMER5_DAT);
    SMT_WRITE(TDAT6, TIMER6_DAT);
    SMT_WRITE(TDAT7, TIMER7_DAT);

    SMT_WRITE(TCON0, 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  // Internal clcok

    SMT_WRITE(TCON1, 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  // Internal clcok

    SMT_WRITE(TCON2, 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  // Internal clcok

    SMT_WRITE(TCON3, 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  // Internal clcok

    SMT_WRITE(TCON4, 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  // Internal clcok

    SMT_WRITE(TCON5, 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  // Internal clcok

    SMT_WRITE(TCON6, 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  // Internal clcok

    SMT_WRITE(TCON7, 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  // Internal clcok


    //IRQ setting 
    RequestIRQ(IRQ_TIMER0_TMC, TimerISRMatch0);
    RequestIRQ(IRQ_TIMER1_TMC, TimerISRMatch1);
    RequestIRQ(IRQ_TIMER2_TMC, TimerISRMatch2);
    RequestIRQ(IRQ_TIMER3_TMC, TimerISRMatch3);
    RequestIRQ(IRQ_TIMER4_TMC, TimerISRMatch4);
    RequestIRQ(IRQ_TIMER5_TMC, TimerISRMatch5);
    RequestIRQ(IRQ_TIMER6_TMC, TimerISRMatch6);
    RequestIRQ(IRQ_TIMER7_TMC, TimerISRMatch7);

    RequestIRQ(IRQ_TIMER0_TOF, TimerISROver0);
    RequestIRQ(IRQ_TIMER1_TOF, TimerISROver1);
    RequestIRQ(IRQ_TIMER2_TOF, TimerISROver2);
    RequestIRQ(IRQ_TIMER3_TOF, TimerISROver3);
    RequestIRQ(IRQ_TIMER4_TOF, TimerISROver4);
    RequestIRQ(IRQ_TIMER5_TOF, TimerISROver5);
    RequestIRQ(IRQ_TIMER6_TOF, TimerISROver6);
    RequestIRQ(IRQ_TIMER7_TOF, TimerISROver7);

}


/*-----------------------------------------------------------------------
    Function name   : PwmSet0
    Prototype       : void PwmSe()
    Return          : void
    Argument        :
    Comments        : for checking PWM mode
-----------------------------------------------------------------------*/
void PwmSet0(void)
{
    SMT_WRITE(PPRE0_0, PWM0_PRE);   // Prescaler selection
    SMT_WRITE(PPRE0_1, PWM1_PRE);
    SMT_WRITE(PPRE0_2, PWM2_PRE);
    SMT_WRITE(PPRE0_3, PWM3_PRE);
    SMT_WRITE(PPRE0_4, PWM4_PRE);
    SMT_WRITE(PPRE0_5, PWM5_PRE);
    SMT_WRITE(PPRE0_6, PWM6_PRE);
    SMT_WRITE(PPRE0_7, PWM7_PRE);

    SMT_WRITE(PDAT0_0, PWM0_DAT);
    SMT_WRITE(PDAT0_1, PWM1_DAT);
    SMT_WRITE(PDAT0_2, PWM2_DAT);
    SMT_WRITE(PDAT0_3, PWM3_DAT);
    SMT_WRITE(PDAT0_4, PWM4_DAT);
    SMT_WRITE(PDAT0_5, PWM5_DAT);
    SMT_WRITE(PDAT0_6, PWM6_DAT);
    SMT_WRITE(PDAT0_7, PWM7_DAT);

    SMT_WRITE(PPWM0_0, PWM0_END);
    SMT_WRITE(PPWM0_1, PWM1_END);
    SMT_WRITE(PPWM0_2, PWM2_END);
    SMT_WRITE(PPWM0_3, PWM3_END);
    SMT_WRITE(PPWM0_4, PWM4_END);
    SMT_WRITE(PPWM0_5, PWM5_END);
    SMT_WRITE(PPWM0_6, PWM6_END);
    SMT_WRITE(PPWM0_7, PWM7_END);


    SMT_WRITE(PCON0_0, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  

    SMT_WRITE(PCON0_1, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) ); 

    SMT_WRITE(PCON0_2, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );

    SMT_WRITE(PCON0_3, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );

    SMT_WRITE(PCON0_4, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );

    SMT_WRITE(PCON0_5, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );  

    SMT_WRITE(PCON0_6, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) ); 

    SMT_WRITE(PCON0_7, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );

}


/*-----------------------------------------------------------------------
    Function name   : PwmSet1
    Prototype       : void PwmSe()
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void PwmSet1(void)
{
    SMT_WRITE(PPRE1_0, PWM0_PRE);   // Prescaler selection
    SMT_WRITE(PPRE1_1, PWM1_PRE);
    SMT_WRITE(PPRE1_2, PWM2_PRE);
    SMT_WRITE(PPRE1_3, PWM3_PRE);
    SMT_WRITE(PPRE1_4, PWM4_PRE);
    SMT_WRITE(PPRE1_5, PWM5_PRE);
    SMT_WRITE(PPRE1_6, PWM6_PRE);
    SMT_WRITE(PPRE1_7, PWM7_PRE);

    SMT_WRITE(PDAT1_0, PWM0_DAT);
    SMT_WRITE(PDAT1_1, PWM1_DAT);
    SMT_WRITE(PDAT1_2, PWM2_DAT);
    SMT_WRITE(PDAT1_3, PWM3_DAT);
    SMT_WRITE(PDAT1_4, PWM4_DAT);
    SMT_WRITE(PDAT1_5, PWM5_DAT);
    SMT_WRITE(PDAT1_6, PWM6_DAT);
    SMT_WRITE(PDAT1_7, PWM7_DAT);

    //PWM end data setting
    SMT_WRITE(PPWM1_0, PWM0_END);
    SMT_WRITE(PPWM1_1, PWM1_END);
    SMT_WRITE(PPWM1_2, PWM2_END);
    SMT_WRITE(PPWM1_3, PWM3_END);
    SMT_WRITE(PPWM1_4, PWM4_END);
    SMT_WRITE(PPWM1_5, PWM5_END);
    SMT_WRITE(PPWM1_6, PWM6_END);
    SMT_WRITE(PPWM1_7, PWM7_END);

    SMT_WRITE(PCON1_0, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)
                );  // Invert clock

    SMT_WRITE(PCON1_1, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)
                );  // Invert clock

    SMT_WRITE(PCON1_2, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)
                );  //Invert clock

    SMT_WRITE(PCON1_3, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)
                );  // Invert clock

    SMT_WRITE(PCON1_4, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)
                );  // Invert clock

    SMT_WRITE(PCON1_5, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)
                );  // Invert clock

    SMT_WRITE(PCON1_6, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)
                );  // Invert clock

    SMT_WRITE(PCON1_7, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)
                );  // Invert clock
  
}

/*-----------------------------------------------------------------------
    Function name   : PwmSet2
    Prototype       : void PwmSet2()
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void PwmSet2(void)
{
    SMT_WRITE(PPRE2_0, PWM0_PRE);   // Prescaler selection
    SMT_WRITE(PPRE2_1, PWM1_PRE);
    SMT_WRITE(PPRE2_2, PWM2_PRE);
    SMT_WRITE(PPRE2_3, PWM3_PRE);
    SMT_WRITE(PPRE2_4, PWM4_PRE);
    SMT_WRITE(PPRE2_5, PWM5_PRE);
    SMT_WRITE(PPRE2_6, PWM6_PRE);
    SMT_WRITE(PPRE2_7, PWM7_PRE);

    SMT_WRITE(PDAT2_0, PWM0_DAT);
    SMT_WRITE(PDAT2_1, PWM1_DAT);
    SMT_WRITE(PDAT2_2, PWM2_DAT);
    SMT_WRITE(PDAT2_3, PWM3_DAT);
    SMT_WRITE(PDAT2_4, PWM4_DAT);
    SMT_WRITE(PDAT2_5, PWM5_DAT);
    SMT_WRITE(PDAT2_6, PWM6_DAT);
    SMT_WRITE(PDAT2_7, PWM7_DAT);

    //PWM end data setting
    SMT_WRITE(PPWM2_0, PWM0_END);
    SMT_WRITE(PPWM2_1, PWM1_END);
    SMT_WRITE(PPWM2_2, PWM2_END);
    SMT_WRITE(PPWM2_3, PWM3_END);
    SMT_WRITE(PPWM2_4, PWM4_END);
    SMT_WRITE(PPWM2_5, PWM5_END);
    SMT_WRITE(PPWM2_6, PWM6_END);
    SMT_WRITE(PPWM2_7, PWM7_END);

    SMT_WRITE(PCON2_0, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );   // Internal clock

    SMT_WRITE(PCON2_1, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );   // Internal clock

    SMT_WRITE(PCON2_2, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );   // Internal clock

    SMT_WRITE(PCON2_3, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );   // Internal clock

    SMT_WRITE(PCON2_4, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );   // Internal clock

    SMT_WRITE(PCON2_5, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );   // Internal clock

    SMT_WRITE(PCON2_6, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );   // Internal clock

    SMT_WRITE(PCON2_7, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL) );   // Internal clock
}

/*-----------------------------------------------------------------------
    Function name   : PwmSet3
    Prototype       : void PwmSet3()
    Return          : void
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void PwmSet3(void)
{
    SMT_WRITE(PPRE3_0, PWM0_PRE); //Prescaler selection
    SMT_WRITE(PPRE3_1, PWM1_PRE);
    SMT_WRITE(PPRE3_2, PWM2_PRE);
    SMT_WRITE(PPRE3_3, PWM3_PRE);
    SMT_WRITE(PPRE3_4, PWM4_PRE);
    SMT_WRITE(PPRE3_5, PWM5_PRE);
    SMT_WRITE(PPRE3_6, PWM6_PRE);
    SMT_WRITE(PPRE3_7, PWM7_PRE);

    SMT_WRITE(PDAT3_0, PWM0_DAT);
    SMT_WRITE(PDAT3_1, PWM1_DAT);
    SMT_WRITE(PDAT3_2, PWM2_DAT);
    SMT_WRITE(PDAT3_3, PWM3_DAT);
    SMT_WRITE(PDAT3_4, PWM4_DAT);
    SMT_WRITE(PDAT3_5, PWM5_DAT);
    SMT_WRITE(PDAT3_6, PWM6_DAT);
    SMT_WRITE(PDAT3_7, PWM7_DAT);

    //PWM end data setting
    SMT_WRITE(PPWM3_0, PWM0_END);
    SMT_WRITE(PPWM3_1, PWM1_END);
    SMT_WRITE(PPWM3_2, PWM2_END);
    SMT_WRITE(PPWM3_3, PWM3_END);
    SMT_WRITE(PPWM3_4, PWM4_END);
    SMT_WRITE(PPWM3_5, PWM5_END);
    SMT_WRITE(PPWM3_6, PWM6_END);
    SMT_WRITE(PPWM3_7, PWM7_END);

    SMT_WRITE(PCON3_0, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  // Internal clock

    SMT_WRITE(PCON3_1, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  // Internal clock

    SMT_WRITE(PCON3_2, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  // Internal clock

    SMT_WRITE(PCON3_3, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  // Internal clock

    SMT_WRITE(PCON3_4, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  // Internal clock

    SMT_WRITE(PCON3_5, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  // Internal clock

    SMT_WRITE(PCON3_6, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  // Internal clock

    SMT_WRITE(PCON3_7, 
                0x2<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                0x1<<SHIFT_DN_FROM_MASK(TIMER_EN) |
                0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  |
                0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL) );  // Internal clock
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchTCAP0()
    Prototype       : void TimerISRMatchTCAP0(smtUint32 IRQ)
    Return          : smtUint32 IRQ
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchTCAP0(smtUint32 IRQ)
{
    // Read TDATA form timer for checking timer counter
    matchMask = 0x1 | matchMask;

    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchTCAP1()
    Prototype       : void TimerISRMatchTCAP1(smtUint32 IRQ)
    Return          : smtUint32 IRQ
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchTCAP1(smtUint32 IRQ)
{
    // Read TDATA form timer for checking timer counter
    matchMask = 0x2 | matchMask;

    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}


/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchTCAP2()
    Prototype       : void TimerISRMatchTCAP2(smtUint32 IRQ)
    Return          : smtUint32 IRQ
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchTCAP2(smtUint32 IRQ)
{
    // Read TDATA form timer for checking timer counter
    matchMask = 0x4 | matchMask;

    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchTCAP3()
    Prototype       : void TimerISRMatchTCAP3(smtUint32 IRQ)
    Return          : smtUint32 IRQ
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchTCAP3(smtUint32 IRQ)
{
    // Read TDATA form timer for checking timer counter
    matchMask = 0x8 | matchMask;

    // Release a registered IRQ routine
    ReleaseIRQ(IRQ);
}


/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchTCAP4()
    Prototype       : void TimerISRMatchTCAP4(smtUint32 IRQ)
    Return          : smtUint32 IRQ
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchTCAP4(smtUint32 IRQ)
{
    // Read TDATA form timer for checking timer counter
    interruptCountCap0++;
    if(interruptCountCap0 >= 2)
    {
        matchMask = 0x10 | matchMask;
        // Release a registered IRQ routine
        ReleaseIRQ(IRQ);
    }

}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchTCAP5()
    Prototype       : void TimerISRMatchTCAP5(smtUint32 IRQ)
    Return          : smtUint32 IRQ
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchTCAP5(smtUint32 IRQ)
{
    // Read TDATA form timer for checking timer counter
    interruptCountCap1++;
    if(interruptCountCap1 >= 2)
    {
        matchMask = 0x20 | matchMask;
        // Release a registered IRQ routine
        ReleaseIRQ(IRQ);
    }

}



/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchTCAP4()
    Prototype       : void TimerISRMatchTCAP4(smtUint32 IRQ)
    Return          : smtUint32 IRQ
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchTCAP6(smtUint32 IRQ)
{
    // Read TDATA form timer for checking timer counter
    interruptCountCap2++;
    if(interruptCountCap2 >= 2)
    {
        matchMask = 0x40 | matchMask;
        // Release a registered IRQ routine
        ReleaseIRQ(IRQ);
    }

}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchTCAP7()
    Prototype       : void TimerISRMatchTCAP7(smtUint32 IRQ)
    Return          : smtUint32 IRQ
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchTCAP7(smtUint32 IRQ)
{
    // Read TDATA form timer for checking timer counter
    interruptCountCap3++;
    if(interruptCountCap3 >= 2)
    {
        matchMask = 0x80 | matchMask;
        // Release a registered IRQ routine
        ReleaseIRQ(IRQ);
    }
}

/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchVIC0()
    Prototype       : void TimerISRMatchVIC0(smtUint32 IRQ)
    Return          :
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchVIC0(smtUint32 IRQ)
{
    interruptCountVIC0++;
    if(interruptCountVIC0 == 30)
    {
        interruptCountMatch++;
        matchMask = 0x10 | matchMask;

        //Disable timer4
        SMT_WRITE(TCON4, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  
                   );

        ReleaseIRQ(IRQ);
    }
}


/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchVIC1()
    Prototype       : void TimerISRMatchVIC0(smtUint32 IRQ)
    Return          : 
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchVIC1(smtUint32 IRQ)
{
    interruptCountVIC1++;
    if(interruptCountVIC1 == 60)
    {
        ReleaseIRQ(IRQ);
        interruptCountMatch++;
        matchMask = 0x20 | matchMask;

        //Disable timer5
        SMT_WRITE(TCON5, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  );
    }
}


/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchVIC2()
    Prototype       : void TimerISRMatchVIC2(smtUint32 IRQ)
    Return          : 
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchVIC2(smtUint32 IRQ)
{
    interruptCountVIC2++;
    if(interruptCountVIC2 == 90)
    {
        ReleaseIRQ(IRQ);
        interruptCountMatch++;
        matchMask = 0x40 | matchMask;

        //Disable timer6
        SMT_WRITE(TCON6, 0x0<<SHIFT_DN_FROM_MASK(TIMER_OP_MODE_SEL) | 
                   0x1<<SHIFT_DN_FROM_MASK(TIMER_PHASE_INVERT_SEL)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_EN)          |
                   0x0<<SHIFT_DN_FROM_MASK(TIMER_IN_CLK_SEL)  );
    }
}


/*-----------------------------------------------------------------------
    Function name   : TimerISRMatchVIC3()
    Prototype       : void TimerISRMatchVIC3(smtUint32 IRQ)
    Return          : 
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/

void TimerISRMatchVIC3(smtUint32 IRQ)
{
    interruptCountVIC3++;
    if(interruptCountVIC3 == 30)
    {
        ReleaseIRQ(IRQ);
        interruptCountMatch++;
        matchMask = 0x80 | matchMask;
    }
}
