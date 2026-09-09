/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001,2002 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     test.c,v
 * Revision: 1.64
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : test.c.rca
 *  File Revision          : 1.11
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Source code file for the Primecell test code.
 */

/*
 * --------Included Headers--------
 */
#include "../apcommon/aptypes.h"
#include "../apos/apos.h"            /* Operating system calls*/
#include "aptest.h"                  /* Public header*/
#include "test.h"                    /* Private header*/

/*Standard I/O headers - not included if the C Library is not desired*/
#if !(defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB))
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <time.h>                   /*required for test timing*/
#endif

/*include the header for the desired interrupt controller*/
#if apINT_VERSION & (apVERSION_INTEGRATOR | apVERSION_ARMULATOR)
    #include "../apint/apint.h"          /* Interrupts public header */
#endif

#if apINT_VERSION & apVERSION_VECTORED

#if (apINT_VERSION == apVERSION_VECTORED_PL192)|(apINT_VERSION == apVERSION_VIC_PL192_ON_LM)
    #include "../appl192/appl192.h"     /* VIC PL192 public header */
#else
    #include "../apvic/apvic.h"         /* VIC PL190 public header */
#endif

#endif

/*if built with timers, we can access the timer functions*/
#if !defined(apOS_PLATFORM_HAS_TIMERS) || (apOS_PLATFORM_HAS_TIMERS)
#include "../aptimer/aptimer.h"
#endif

/*
 * --------Variables--------
 */
PRIVATE BOOL buffered_cr = FALSE;          //set when a C/R is pending
PRIVATE WORD32 TEST_Aborted=FALSE;          //set when test is aborted


/************************************************************
 ************** TIMEOUT HANDLER AND VARIABLES ***************
 ************************************************************/

PUBLIC volatile BOOL apTEST_TestInProgress = TRUE, apTEST_Timeout = FALSE;

PUBLIC void apTEST_GenericTimeout(UWORD32 Param)
{
    IGNORE(Param);                          //timeout device parameter ignored
    apTEST_TestInProgress = FALSE;
    apTEST_Timeout = TRUE;
}


/************************************************************
 *************GENERAL IMPLEMENTATION ROUTINES***************
 ************************************************************/

/*====================================================================*/
PUBLIC apTEST_eResult apTEST_EnableInterrupts(void)
{
    apTEST_eResult TestFlag=apTEST_PASS;                       /*used within TEST_MODULE*/
    /*
     *Initialise and test the main interrupt controller if an INT type
     * Note that the test routine performs the code below.  If the test is not used, this code is
     * required.
     *-----------------------------------------------------------------------------------
     *  sInitial.eSense   = apINT_DEFAULT_SENSE;
     *  sInitial.Priority = 16;
     *  apINT_Initialize(apOS_INT_0, (apOS_System_eBaseAddress)RegBase, 0, 0, &sInitial);
     *  apOS_CoreIRQEnable();
     *  apOS_CoreFIQEnable();
     *-----------------------------------------------------------------------------------
     */
#if (apINT_VERSION != apVERSION_VIC_PL192_ON_LM)

#if apINT_VERSION & (apVERSION_INTEGRATOR | apVERSION_ARMULATOR)
    TEST_MODULE(INT, 0, apOS_INT_0, apOS_SYSTEM_BASE_INT, TEST_NOINT);  
#endif

#endif

    /*
     *If we are running on an Integrator platform, we have a separate interrupt controller
     * for the Logic Module.  We have the following options currently supported here:
     * - Main controller must be an INT
     * - Secondary controller can be an INT or a VIC 
     */
#if apOS_PLATFORM_INTEGRATOR && (apINT_VERSION & apVERSION_INTEGRATOR)
    /*
     *Check that there is a logic module connected.
     */
    if (*(UWORD32*) (TEST_SC_DEC) & TEST_SC_DEC_LM0)
    {
    /*if we are using a second INT interrupt controller*/
#if (apINT_VERSION & apVERSION_INTEGRATOR)  && \
    !(apINT_VERSION & apVERSION_VECTORED)   && \
    (apINT_VERSION != apVERSION_NONE_ON_LM) && \
       !(apOS_NO_STATIC_STATE)
        if (apOS_INT_MAXIMUM > 1)
        {
        /*
         *Set the initial conditions for the interrupt controller
         */
        apINT_sInitialData IntInitial;
        IntInitial.Priority = 0;
        IntInitial.eSense = apINT_ACTIVE_LOW;
        apTEST_BufferedPrint("Logic module 0 located\n");

                /*
                 *Initialise and chain the controller.
                 */
                apINT_Initialize(apOS_INT_LM, apOS_SYSTEM_BASE_INTLM,0,0,&IntInitial);
                apINT_HandlerChain(apOS_INT_EXP0, apOS_INT_LM);
                apINT_InterruptEnable(apOS_INT_EXP0);
                apTEST_BufferedPrint("LM0 interrupt handler chained\n");
        }
#else
#if (apINT_VERSION == apVERSION_VIC_PL192_ON_LM)

    /*if we are using a VIC PL192 on LM then the VIC links to the FIQ and IRQ*/
        {
            *((UWORD32 *) apOS_SYSTEM_BASE_INT + 2 ) = (1 << apOS_INT_EXP0);
            *((UWORD32 *) apOS_SYSTEM_BASE_FIQ + 2 ) = (1 << apOS_INT_EXP1);
        } 

#else

    /*if we are using a VIC interrupt controller on LM then the VIC links to the FIQ*/
        {
            *((UWORD32 *) apOS_SYSTEM_BASE_FIQ + 2 ) = (1 << apOS_INT_EXP0);
        } 
#endif  /* (apINT_VERSION == apVERSION_VIC_PL192_ON_LM) */

#endif

    }
    else
    {
        apTEST_BufferedPrint("No Logic Module Present\n");
    }
#endif  /* apOS_PLATFORM_INTEGRATOR && (apINT_VERSION & apVERSION_INTEGRATOR) */

    /*
     *Initialise and test the main interrupt controller if a VIC type
     */

#if (apINT_VERSION & apVERSION_VECTORED)
    TEST_MODULE(VIC, 0, apOS_VIC_0, apOS_SYSTEM_BASE_VIC, TEST_NOINT);  
#endif
    return (apTEST_eResult) TestFlag;
}

/*====================================================================*/
PUBLIC void apTEST_EnableTimers(void)
{
/* Initialise a timer if available to allow timeout calls.
 * This may be overridden if a timer test is performed.
 */
#if (!apOS_NO_STATIC_STATE) && (!defined(apOS_PLATFORM_HAS_TIMERS) || (apOS_PLATFORM_HAS_TIMERS))
    apTIMER_sInitialData sTimerData; 
    apOS_INT_oInterruptSource TimerInterrupt = apOS_INT_TIMER0;
    
        
#if (defined(apTIMER_VERSION) && (apTIMER_VERSION ==  apVERSION_ARMULATOR))
    sTimerData.Clock = 2000UL;
#else
    sTimerData.Clock =20000000UL; //Based on system bus clock of 20MHz
#endif

	sTimerData.eReserve = apTIMER_NO_RESERVE_ON_INIT;

	apTIMER_Initialize(apOS_TIMER_0, apOS_SYSTEM_BASE_TIMER0,1,&TimerInterrupt, &sTimerData);
    
#endif 
}


/************************************************************
 **********USER INTERFACE IMPLEMENTATION ROUTINES************
 ************************************************************/

/*====================================================================*/
PUBLIC apTEST_eResult apTEST_ImplementBasicTests(void)
{
    apTEST_eResult BasicResult=apTEST_PASS;

    /*report on stack and heap setup*/
    typedef struct __initial_stackheap{UWORD32 heap_base, stack_base, heap_limit, stack_limit;} R0_R3;
    extern R0_R3 apOS_StackAndHeap;
    apTEST_Report("Base of heap at   ",apOS_StackAndHeap.heap_base,apTEST_FORMAT_LONG_HEX);
    apTEST_Report("Top of stack at   ",apOS_StackAndHeap.stack_base,apTEST_FORMAT_LONG_HEX);
    apTEST_Report("Limit of stack at ",apOS_StackAndHeap.stack_limit,apTEST_FORMAT_LONG_HEX);

    /*memory cycle for word access*/
    TEST_MEMCYCLE(UWORD32,0xFFFFFFFF,BasicResult)
    TEST_MEMCYCLE(UWORD32,0x12345678,BasicResult)
    TEST_MEMCYCLE(UWORD32,0x00000000,BasicResult)
    apTEST_Print(BasicResult,"Memory Word Access");

    /*memory cycle for half word access*/
    if (BasicResult)
    {
        TEST_MEMCYCLE(UHWD16,0xFFFF,BasicResult)
        TEST_MEMCYCLE(UHWD16,0x147A,BasicResult)
        TEST_MEMCYCLE(UHWD16,0x0000,BasicResult)
        apTEST_Print(BasicResult,"Memory Halfword Access");
    }

    /*memory cycle for byte access*/
    if (BasicResult)
    {
        TEST_MEMCYCLE(UBYTE8,0xFF,BasicResult)
        TEST_MEMCYCLE(UBYTE8,0x5A,BasicResult)
        TEST_MEMCYCLE(UBYTE8,0x00,BasicResult)
        apTEST_Print(BasicResult,"Memory Byte Access");
    }
    
    /*check that endian-ness matches __BIG_ENDIAN constant*/
    if (BasicResult)
    {
    UWORD32 EndCheck=0;
        *(UBYTE8*) &EndCheck=0xFF;          /*set the lowest byte*/
#ifdef __BIG_ENDIAN
        BasicResult = (apTEST_eResult) (EndCheck==0xFF000000);
#else
        BasicResult = (apTEST_eResult) (EndCheck==0x000000FF);
#endif     
        apTEST_Print(BasicResult,"Compiled for correct endian-ness");
    }   
    
    /*must use BufferedPrint here to ensure it's displayed
      even if not verbose*/
    apTEST_BufferedPrint("Memory Tests: ");
    if (BasicResult)
    {
        apTEST_BufferedPrint("Pass\n");
    }
    else
    {
        apTEST_BufferedPrint("Fail\n");
    }
    return BasicResult;
}

/*
* This routine tests a single module by calling the module's routine apMOD_SelfTest()
*/
/*====================================================================*/
PROTECTED apTEST_eResult TEST_Module(char * CONST pModuleName,
                                  apTEST_rRoutine * rModTest,
                                  UWORD32 DevId,
                                  UWORD32 oId,
                                  UWORD32 RegBase,
                                  UWORD32 NumSources,
                                  CONST apOS_INT_oInterruptSource * CONST pInt)
{
    apTEST_eResult eRetValue;                   /*PASS/FAIL value returned by test*/

/*
* Once the test has been aborted, no more tests occur
* Testing is aborted if a test fails and apTEST_END_ON_FIRST_FAILURE is set
*/
    if (TEST_Aborted)
    {
        return apTEST_FAIL;
    }

    apTEST_BufferedPrint("\n---------------\nTesting module ");
    apTEST_BufferedPrint(pModuleName);
    apTEST_Report(" at ",RegBase,apTEST_FORMAT_LONG_HEX);
    
/*
* On the Integrator platform, we check that the Logic Module is present if the device is
* declared as being on the logic module
*/
#if (defined(apOS_INTCTL_LM) && defined(apOS_PLATFORM_INTEGRATOR) && (apOS_PLATFORM_INTEGRATOR))
    if ((*pInt & apOS_INTCTL_LM) && !(*(UWORD32*) (TEST_SC_DEC) & TEST_SC_DEC_LM0))
    {
        apTEST_BufferedPrint("    ***NO LOGIC MODULE***\n");
        if (apTEST_END_ON_FIRST_FAILURE)
        {
            apTEST_BufferedPrint("\nTerminating testing\n");
            TEST_Aborted=TRUE;                        /*terminate the test*/
        }
        return apTEST_FAIL;
    }
#endif    
    
/*
* Check the Primecell ID registers - these identify the Primecell present at the stated address
* and this can be compared with the expected value
*/
    if (DevId)
    {
    UWORD32 PcellId;
        PcellId=(*(UWORD32*)(RegBase+TEST_PCELL_ID) & 0xFF) |
                 (*(UWORD32*)(RegBase+TEST_PCELL_ID+4) & 0xFF)<<8 |
                 (*(UWORD32*)(RegBase+TEST_PCELL_ID+8) & 0xFF)<<16 |
                 (*(UWORD32*)(RegBase+TEST_PCELL_ID+12) & 0xFF)<<24;
        if (PcellId!=TEST_IS_PCELL)
        {
            apTEST_Report("    *** WARN *** No Primecell identifier at ",RegBase+TEST_PCELL_ID,apTEST_FORMAT_LONG_HEX);
        }
        PcellId=*(UWORD32*)(RegBase+TEST_PER_ID);
        PcellId=(PcellId & 0xF) +
                (((PcellId>>4) & 0x0F) * 10) +
                ((*(UWORD32*)(RegBase+TEST_PER_ID+4) & 0xF)*100);
        apTEST_Print((apTEST_eResult)(PcellId==DevId),"Primecell ID Registers");
    }
    
/*
* Now execute the stated test routine if present in the build
*/
    if (rModTest)
    {
        apTEST_BufferedPrint("");             /*flush the carriage return*/
        eRetValue=rModTest(oId,RegBase,NumSources,pInt);     /*perform the test*/
        if (eRetValue)
        {
            apTEST_BufferedPrint("    *** PASS ***\n");
        }
        else
        {
            apTEST_BufferedPrint("    *** FAIL ***\n");
            if (apTEST_END_ON_FIRST_FAILURE)
            {
                apTEST_BufferedPrint("\nTerminating testing\n");
                TEST_Aborted=TRUE;                        /*terminate the test*/
            }
        }
    }
    else
    {
        apTEST_BufferedPrint("=> Module: Absent\n");
        eRetValue=apTEST_FAIL;
    }

    return eRetValue;
}

/************************************************************
 **************PUBLIC USER INTERFACE ROUTINES****************
 ************************************************************/

PUBLIC void apTEST_Print(apTEST_eResult eItemResult,
                          char * CONST pTestName)
{
#if apTEST_VERBOSE
    apTEST_BufferedPrint(pTestName);
    if (eItemResult)
    {
        apTEST_BufferedPrint(": Pass\n");
    }
    else
    {
        apTEST_BufferedPrint(": Fail\n");
    }
#else
  IGNORE(eItemResult);
  IGNORE(pTestName);
#endif
}

/*====================================================================*/
PUBLIC void apTEST_BufferedPrint(char * CONST pMessage)
{
    /*flush the Carriage Return buffer*/
    if (buffered_cr)
    {
        TEST_ImplementPrint("\n");
        buffered_cr = FALSE;
    }
    TEST_ImplementPrint(pMessage);
}

/*====================================================================*/
PUBLIC void apTEST_Report(char * CONST pTestName,
                          UWORD32 DataValue,
                          apTEST_eFormat eDataFormat)
{
#if apTEST_VERBOSE
    char ReportValue[20];           /*Stores the converted value*/

#if !(defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB))
        switch (eDataFormat)
        {
            case apTEST_FORMAT_LONG_DEC:
            {
                sprintf(ReportValue,"%lu",DataValue);
                break;
            }
            case apTEST_FORMAT_LONG_HEX:
            {
                sprintf(ReportValue,"%#lx",DataValue);
                break;
            }
        }
#else
        IGNORE(DataValue);
        ReportValue="[]";
#endif
    apTEST_BufferedPrint(pTestName);
    if (eDataFormat != apTEST_FORMAT_NO_NUMBER)
    {        
        apTEST_BufferedPrint(ReportValue);
        buffered_cr = TRUE;
    }
#else
  IGNORE(pTestName);
  IGNORE(DataValue);
  IGNORE(eDataFormat);
#endif
}

/*====================================================================*/
PUBLIC void apTEST_Remove_CR()
{
    buffered_cr = FALSE;
}

/*====================================================================*/
PUBLIC void apTEST_WaitKey(char * CONST pMessage,
                            UWORD32 WaitTime)
{
UWORD32 ubyCount,ubyProgressSteps;

    apTEST_BufferedPrint(pMessage);
    if (apTEST_INTERACTIVE)
    {
        apTEST_BufferedPrint(" - Press return to proceed ... \n");
        TEST_ImplementWaitKey();
    }
    else
    {
        /*number of steps shown, no more than one per second*/
        ubyProgressSteps=(UBYTE8)MIN(TEST_PROGRESS_STEPS, WaitTime);
        apTEST_BufferedPrint("\n** Waiting: ");
        /*perform the wait in steps to give a count-down*/
        for (ubyCount=ubyProgressSteps;ubyCount>0;ubyCount--)
        {
            apTEST_BufferedPrint("*");
            apOS_TIMER_Wait(WaitTime * (UWORD32) 1E6 / ubyProgressSteps);
        }
    }
    apTEST_BufferedPrint(" ... Continuing\n");
}

/*====================================================================*/
PUBLIC UWORD32 apTEST_TimeGet(void)
{
#if !(defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB))
    clock_t TimeNow;
    
    TimeNow = clock();
    return (UWORD32)TimeNow * 1000U /(UWORD32)CLOCKS_PER_SEC;
#else
    return 0;
#endif
}


/************************************************************
 **********USER INTERFACE IMPLEMENTATION ROUTINES************
 ************************************************************/

PRIVATE void TEST_ImplementPrint(char * CONST pMessage)
{
    /*implement the print function*/
#if !(defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB))
    printf ("%s",pMessage);
    fflush(stdout);
#else
    IGNORE(pMessage);
#endif
}

/*====================================================================*/
PRIVATE void TEST_ImplementWaitKey(void)
{
#if !(defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB))
    getc(stdin);
#endif
}


