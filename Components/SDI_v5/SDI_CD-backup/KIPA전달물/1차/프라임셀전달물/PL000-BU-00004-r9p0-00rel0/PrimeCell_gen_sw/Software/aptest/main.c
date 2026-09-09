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
 * File:     main.c,v
 * Revision: 1.17
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : main.c.rca
 *  File Revision          : 1.9
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Source code file for Main routine for the Primecell test code.
 */

/*
 * --------Included Headers--------
 */
#include "../apcommon/aptypes.h"
#include "../apos/apos.h"            /* Operating system calls*/
#include "aptest.h"                  /* Public header*/
#include "../apcommon/cmacros.h"

/*Standard I/O headers - not included if the C Library is not desired*/
#if !(defined(apOS_CONFIG_USE_NO_CLIB) && (apOS_CONFIG_USE_NO_CLIB))
    #include <stdio.h>
#endif

/*include malloc if no static state*/
#if apOS_NO_STATIC_STATE
    #include <stdlib.h>
#endif

/*
 * Description:
 * This is the main test application routine.  It will set up the system interrupt controller
 * and perform the basic system tests
 */
int main(int argc, char *argv[])
{
    /*
     *TestFlag maintains a record of the overall test results.
     *It is set to apTEST_FAIL if any test fails
     */
    apTEST_eResult TestFlag = apTEST_PASS;                

    IGNORE(argc);
    IGNORE(argv);
    /*
     *Perform the basic system tests.  These will do some simple reads and writes to memory
     *to ensure that this is possible, and only proceed if successful
     */
    TestFlag = apTEST_ImplementBasicTests();
    if (TestFlag==apTEST_PASS)
    {
    
        /*
         *Enable the system interrupts.
         */
        TestFlag = apTEST_EnableInterrupts();
    
        if (TestFlag==apTEST_PASS)
        {
    
            /*
             *Enable a timer to allow timeouts etc.
             */
            apTEST_EnableTimers();
    
/*
* Module tests are implemented in applatfm.h using TEST_ALL_MODULES
* NOTE - this should NOT repeat the test on the interrupt handler
*/
#ifdef TEST_ALL_MODULES
            TEST_ALL_MODULES
            /*report results*/
            apTEST_BufferedPrint("\n-------------\n*** Overall System:  ");
            if (TestFlag)
            {
                apTEST_BufferedPrint("PASS ***\n");
            }
            else
            {
                apTEST_BufferedPrint("FAIL ***\n");
            }
#else
            apTEST_BufferedPrint("\n*** No module tests ***\n");
#endif
        }

/*
* The code coverage macro is added here for test purposes only
*/
#ifdef _CC
        CC_Coverage
#endif
    }
    
    /*returns 0 for success and 1 for failure*/
    return !TestFlag;                    
}


