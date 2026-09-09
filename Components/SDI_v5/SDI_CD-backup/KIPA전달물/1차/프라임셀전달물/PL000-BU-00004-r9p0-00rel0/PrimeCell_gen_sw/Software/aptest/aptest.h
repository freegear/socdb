/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     aptest.h,v
 * Revision: 1.44
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : aptest.h.rca
 *  File Revision          : 1.9
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Public header file for the Primecell test code.  This should be
 * included in the module test files.
 */

#ifndef aptest_h
#define aptest_h

#ifdef	__cplusplus
extern "C" {	/* allow C++ to use these headers */
#endif	/* __cplusplus */

#include "../apcommon/aptypes.h"
#include "../apos/apos.h"

/*
 * Description:
 * apTEST_END_ON_FIRST_FAILURE - if TRUE, the test will terminate when any
 *      module returns a failure result.
 */
#ifndef apTEST_END_ON_FIRST_FAILURE

#define apTEST_END_ON_FIRST_FAILURE       FALSE

#endif

/*
 * Description:
 * apTEST_VERBOSE - if TRUE, any messages will be shown, even if they do
 *                  not terminate the test;
 *                  Behaviour is modified by configuration flag apOS_CONFIG_USE_NO_CLIB,
 *                  which, if defined and TRUE, means there is no C Library support,
 *                  and hence no printing available
 */
#ifndef apTEST_VERBOSE
#if defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB)

    #define apTEST_VERBOSE                FALSE
#else    

    #define apTEST_VERBOSE                TRUE
#endif 
#endif   
    

/*
 * Description:
 * apTEST_INTERACTIVE - if TRUE, the user is present during testing and can 
 *                      press a key to continue a test after a pause
 *                  Behaviour is modified by configuration flag apOS_CONFIG_USE_NO_CLIB,
 *                  which, if defined and TRUE, means there is no C Library support,
 */
#ifndef apTEST_INTERACTIVE
#if defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB)

    #define apTEST_INTERACTIVE            FALSE
#else

    #define apTEST_INTERACTIVE            TRUE
#endif
#endif   

/*
 * Description:
 * When testing with a timeout handler, apTEST_TestInProgress is set to FALSE by the
 * ISR which is being tested.  This indicates that the test is complete 
 */
extern volatile BOOL apTEST_TestInProgress; 

/*
 * Description:
 * When testing with a timeout handler, apTEST_Timeout is set to TRUE by the
 * timeout handler.  This indicates that the test timed out 
 */
extern volatile BOOL apTEST_Timeout; 

/*
 * Description:
 * Macro for testing peripherals with a timeout handler
 *
 * Implementation
 * apTEST_TIMEOUT(__testFunc, __oId, __ntimer, __period, __msg, __result)
 * + __testFunc is the function to set up the test
 *              (takes one parameter - the peripheral identifier)
 * + __oId      is the peripheral identifier 
 *              (leave blank if __testFunc takes no parameter)
 * + __ntimer   is the Id of the timer to use
 * + __period   is the timeout period in seconds
 * + __msg      is the message to return on timeout
 * + __result   is the apTEST_eResult to return on timeout
 *
 * __testFunc should set up the registers and return so that the test is controlled 
 * by interrupts. If it is necessary to keep program flow inside __testFunc, then 
 * it can contain a while(apTEST_TestInProgress) loop. When the test is over, the 
 * ISR should set apTEST_TestInProgress to false.
 */
#define apTEST_TIMEOUT(__testFunc, __oId, __ntimer, __period, __msg, __result)        \
    apTEST_TestInProgress = TRUE;                                                   \
    apTEST_Timeout = FALSE;                                                         \
    apTEST_Report("(timeout after ", (__period), apTEST_FORMAT_LONG_DEC);           \
    apTEST_Remove_CR();                                                             \
    apTEST_Report(" seconds)\n", 0, apTEST_FORMAT_NO_NUMBER);                       \
    apOS_TIMER_TimeoutEnable(__ntimer,(__period)*1000000UL,&apTEST_GenericTimeout,0);   \
    (__testFunc)(__oId);                                                            \
    while(apTEST_TestInProgress);                                                   \
    apOS_TIMER_TimeoutDisable(__ntimer);                                             \
    if (apTEST_Timeout)                                                             \
    {                                                                               \
        apTEST_Print((__result), (__msg));                                          \
        return (__result);                                                          \
    }



#if apOS_NO_STATIC_STATE
/*
 * Description:
 * This macro allows the PrimeCell instance to be switched according to the state
 * of apOS_NO_STATIC_STATE.
 *
 * + If apOS_NO_STATIC_STATE=FALSE, apOS_INSTANCE(MOD,0) will resolve to enumeration
 *   apOS_MOD_0.
 * + If apOS_NO_STATIC_STATE=TRUE, apOS_INSTANCE(MOD,0) will resolve to a malloc of the
 *   appropriate size, using apMOD_StateSizeGet()
 */ 
#define apOS_INSTANCE(_mod,_inst) malloc((HWD16)ap ## _mod ##_## StateSizeGet())
#else
#define apOS_INSTANCE(_mod,_inst) apOS_ ## _mod ##_## _inst
#endif

/*
 * Description:
 * This macro is used to specify a set of interrupt sources to be passed to TEST_MODULE
 */
#define TEST_LIST(_int1,_int2) (CONST apOS_INT_oInterruptSource) (_int1),(CONST apOS_INT_oInterruptSource) (_int2)

/*
 * Description:
 * This macro is used to specify that there are no interrupts used.
 * It must be a value which does not represent any real interrupt source.
 */
#define TEST_NOINT (CONST apOS_INT_oInterruptSource) 0xFF000000

/*
 * Description:
 * This macro is used to specify a test on a module when the Primecell identifier
 * is known
 *
 * Implementation:
 * _mod - name of module (e.g. MMC).
 * _id - Primecell number (e.g. 180)
 * _inst - the instance of the driver to be initialised (e.g. apOS_MOD_0 for the first instance of module MOD)
 * _base - base address of registers (e.g. 0x1234578)
 * _int - set of identifiers of interrupts.  There may be any number of
 *        these, but they must be specified using the TEST_LIST macro
 *        e.g. TEST_LIST(LIST(apOS_INT_ID1,apOS_INT_ID2),apOS_INT_ID3)
 */
#define TEST_MODULE(_mod,_id,_inst,_base,_int) \
       {extern apTEST_rRoutine ap ## _mod ## _SelfTest;\
        __weak UWORD32 ap ## _mod ##_##StateSizeGet(void);\
        CONST apOS_INT_oInterruptSource IntArray[]={_int};\
        TestFlag= (apTEST_eResult) (TestFlag & TEST_Module( # _mod,ap ## _mod ## _SelfTest,_id,(UWORD32)_inst,_base, \
                                                           (IntArray[0]==TEST_NOINT)?0:sizeof(IntArray)/sizeof(IntArray[0]), \
                                                           &IntArray[0]));\
        IGNORE(ap ## _mod ##_##StateSizeGet);}

/*
 * Description:
 * Test result states
 */
typedef enum apTEST_xResult
{
    apTEST_FAIL=0x0,               /*failure of test*/
    apTEST_PASS                    /*test passes*/
} apTEST_eResult;

/*
 * Description:
 * Allowed formats for test diagnostics
 */
typedef enum apTEST_xFormat
{
    apTEST_FORMAT_NO_NUMBER,                  /*do not report parameter*/
    apTEST_FORMAT_LONG_DEC,                   /*long integer in decimal*/
    apTEST_FORMAT_LONG_HEX                    /*long integer in hex*/
} apTEST_eFormat;

/*
 * Description:
 * Format for a test routine
 *
 * Implementation:
 * oId - the identifier for the peripheral instance to use
 * RegBase - base address for registers.
 * NumSources - Number of interrupt sources used
 * pInt - pointer to a list of identifiers for interrupts used.
 */
typedef apTEST_eResult apTEST_rRoutine(UWORD32 oId, UWORD32 RegBase,UWORD32 NumSources,
                    CONST apOS_INT_oInterruptSource * CONST pInt);

/*
 * Description:
 * This routine tests the specified module and reports on the result.
 *
 * Inputs:
 * pModuleName - the name of the module under test.
 * rModTest - the module test routine.
 * DevId - the Primecell number for the device (to be checked against the Primecell
 *           registers) - pass as zero for no checking
 * oId - the peripheral instance to be used
 * RegBase - base address for registers
 * NumSources - number of interrupt sources
 * pInt - array of interrupt IDs
 *
 * Outputs:
 * none
 *
 * Return Value:
 * This routine returns the result of the test (pass/fail) 
 */
PROTECTED apTEST_eResult TEST_Module(char * CONST pModuleName,
                                  apTEST_rRoutine *rModTest,
                                  UWORD32 DevId,
                                  UWORD32 oId,
                                  UWORD32 RegBase,
                                  UWORD32 NumSources,
                                  CONST apOS_INT_oInterruptSource * CONST pInt);

/*
 * Description:
 * This routine enables the necessary interrupt controllers.
 *
 * Implementation:
 * This code will enable an INT and/or VIC interrupt controller according to the setting of
 * apINT_VERSION in apos/apintcfg.h.
 *
 * Inputs:
 * none.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * + apTEST_PASS - if the interrupts are successfully enabled
 * + apTEST_FAIL - otherwise
 */
PUBLIC apTEST_eResult apTEST_EnableInterrupts(void);

/*
 * Description:
 * This routine enables system timers.
 *
 * Implementation:
 * If the code is compiled with apOS_NO_STATIC_STATE = FALSE and apOS_PLATFORM_HAS_TIMERS=TRUE,
 * this function will initialise one system timer (apOS_TIMER_0) for use with timeouts.
 *
 * Inputs:
 * none.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apTEST_EnableTimers(void);

/*
 * Description:
 * This routine prints a test message and is used by the module
 * test routines for reporting
 *
 * Implementation:
 * Where possible in a debug environment, this routine will print
 * the message, which is the name of the test being undertaken,
 * followed by 'Pass' or 'Fail' according to the result parameter.
 *
 * This routine should be customised if a modified data output
 * method is required.  In extreme cases, the result might be
 * implemented only by displaying a red or green light according
 * to the Result parameter
 *
 * Inputs:
 * eItemResult - specifies whether the test passed (in which case the
 *          message is informational only) or failed.  Displaying
 *          a failure message does not terminate the test.
 * pTestName - a string message to be displayed.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apTEST_Print(apTEST_eResult eItemResult,
                          char * CONST pTestName);


/*
 * Description:
 * This routine prints a diagnostic message followed by a value.
 *
 * Implementation:
 * The value may be one of several data types which should be specified
 * as one of the constants TEST_FORMAT_*. 
 * If the apTEST_FORMAT_NO_NUMBER parameter is specified, no terminating
 * carriage return is generated.
 *
 * Inputs:
 * pTestName - a string message to be displayed.
 * DataValue - the variable to be displayed
 * eDataFormat - the format to be used
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apTEST_Report(char * CONST pTestName,
                          UWORD32 DataValue,
                          apTEST_eFormat eDataFormat);


/*
 * Description:
 * This routine suppresses the carriage return generated by the previous 
 * call to a test output routine
 *
 * Implementation:
 * Discards the buffered carriage return in memory
 *
 * Inputs:
 * none
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apTEST_Remove_CR(void);


/*
 * Description:
 * This routine prints a text message and then waits for a keypress
 * from the user.
 *
 * Inputs:
 * pMessage - a string message to be displayed.
 * wWaitTime - this is ignored unless the test is non-interactive.  In
 *             that case, the code will delay for this many seconds,
 *             rather than waiting for a keypress.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apTEST_WaitKey(char * CONST pMessage,
                            UWORD32 WaitTime);

/*
 * Description:
 * This routine returns a clock value in ms.  It may be used for timing.
 *
 * Implementation:
 * Implemented using clock() unless apOS_CONFIG_USE_NO_CLIB is defined non-zero, in which case zero is
 * always returned.
 *
 * Inputs:
 * none.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * Time in milliseconds
 */
PUBLIC UWORD32 apTEST_TimeGet(void);

/*
 * Description:
 * This routine performs some basic system tests.
 *
 * Implementation:
 * Currently this performs word, halfword and byte write/read cycles.
 * Further tests can be added. 
 *
 * Inputs:
 * none.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * + apTEST_PASS if test is successful
 * + apTEST_FAIL if test is unsuccessful
 */
PUBLIC apTEST_eResult apTEST_ImplementBasicTests(void);

/*
 * Description:
 * This routine writes a message, preceded by any buffered carriage return.
 * Carriage returns are buffered to allow messages to be joined.
 *
 * Inputs:
 * pMessage - a string message to be displayed.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apTEST_BufferedPrint(char * CONST pMessage);

/*
 * Description:
 * This routine provides a general test time out function.
 *
 * Inputs:
 * Param - user parameter.
 *
 * Outputs:
 * none
 *
 * Return Value:
 * none
 */
PUBLIC void apTEST_GenericTimeout(UWORD32 Param);

#ifdef __cplusplus
} /* allow C++ to use these headers */
#endif	/* __cplusplus */

#endif

