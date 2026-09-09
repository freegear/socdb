//--========================================================================--
// This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT  2001 ARM Limited
//       ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           :easy_tst.c,v
//  File Revision       :1.12
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Example EASY world C test program that
//                       calls tests for individual blocks
//
//--========================================================================--


#define PROG_NAME "EASY test (built: "__DATE__", "__TIME__")\n"

// includes

#include "peripherals.h"
#include "globals.h"
#include "int_tst.h"
#include "wdog_tst.h"
#include "gpio_tst.h"
#include "egslave_tst.h"
#include "reset_tst.h"
#include "timer_tst.h"
#include "memory_tst.h"
#include "exception_tst.h"
#include "egmaster_tst.h"
#include "encache.h"

#include <stdio.h>
#include <stdlib.h>


// Global varibles
// Note: No global variables are initialised when declared
// so memory area may be described as UNINIT in scatter description file
// to speed up simulation

// The following Int Flags are set by the relevant Interrupt service routine
// and are read by the main program flow to detect that an interrupt
// has occurred

volatile Boolean pauseFlag;
volatile Boolean undefinedFlag;
volatile Boolean swiFlag;
volatile Boolean prefetchAbortFlag;
volatile Boolean dataAbortFlag;

volatile Boolean softIrqFlag;
volatile Boolean timer1IrqFlag;
volatile Boolean timer2IrqFlag;
volatile Boolean timersIrqFlag;
volatile Boolean wdogIrqFlag;
volatile Boolean gpio0IrqFlag;
volatile Boolean gpio1IrqFlag;
volatile Boolean gpio2IrqFlag;
volatile Boolean gpio3IrqFlag;
volatile Boolean gpio4IrqFlag;
volatile Boolean gpio5IrqFlag;
volatile Boolean gpio6IrqFlag;
volatile Boolean gpio7IrqFlag;
volatile Boolean gpioIrqFlag;

volatile Boolean softFiqFlag;
volatile Boolean timer1FiqFlag;
volatile Boolean timer2FiqFlag;
volatile Boolean timersFiqFlag;
volatile Boolean wdogFiqFlag;
volatile Boolean gpio0FiqFlag;
volatile Boolean gpio1FiqFlag;
volatile Boolean gpio2FiqFlag;
volatile Boolean gpio3FiqFlag;
volatile Boolean gpio4FiqFlag;
volatile Boolean gpio5FiqFlag;
volatile Boolean gpio6FiqFlag;
volatile Boolean gpio7FiqFlag;
volatile Boolean gpioFiqFlag;


// Used to keep track of message text level and control verbosity
int textIndent;


// Function prototypes
int main(void);
void initialise(void);
void initialise_special(void);
void doTests( void );




//----------------------------------------------------------------------------
// main ()
// Entry point for C code
// Calls initialisation code (if any)
// Checks to see if reset caused by Watchdog
// Calls test code
// Prints overall test result 
//----------------------------------------------------------------------------

int main(void)
{
  // Intialise cache if available
  initCache();

  // Perform the integration tests
  textIndent = 1;
  initialise();
  
  // check for watchdog test in progress (raw interrupt bit will be set)...
  if( (wdog.WdogRIS & WDOG_INT) == WDOG_INT )
  {
    DO_TEST(testContinueWatchdog() , "", testStatus);
  }
  // ...otherwise do main tests
  else
  {
    printf (PROG_NAME);
    initialise_special();
    doTests();
  }
  
  // report final test status
  switch( testStatus )
  {
    case PASS: 
    case UNKNOWN:
    {
      printf( "\n\n*** EASY tests: PASS ***\n\n" ); 
      exit(0);
    }
    break;

    case FAIL:
    default: 
    {
      printf( "\n\n*** EASY tests: FAIL ***\n\n" ); 
      exit(-1);
    }
    break;
  }


}
  


//----------------------------------------------------------------------------
// doTests ()
// Call individual tests and updates global test status
//----------------------------------------------------------------------------

void doTests( void )
{
  DO_TEST( testRemPause(), "Remap Pause Controller", testStatus );
  DO_TEST( testExceptions(), "Exceptions", testStatus );
  DO_TEST( testMemory(), "Memory", testStatus );
  DO_TEST( testInterrupts(), "Interrupt Controller", testStatus );
  DO_TEST( testTimer(), "Timer/Pause test", testStatus );
  DO_TEST( testEgSlave(), "Example APB Slave", testStatus );
  DO_TEST( testGpio(), "GPIO", testStatus );

// This test will be carried out if appropriate to the EASY system
#ifdef  TEST_OTHER_MASTERS
  DO_TEST( testFrbmAndEbm(), "File Reader and Example AHB Master", 
           testStatus );
#endif

  // watchdog test is last because it causes a Reset
  DO_TEST( testWatchdog(), "Watchdog", testStatus );
}


//----------------------------------------------------------------------------
// initialise ()
// Initialise the global variables, except ones which retain value after reset
//----------------------------------------------------------------------------
void initialise( void )
{
  pauseFlag = FALSE;
  undefinedFlag = FALSE;
  prefetchAbortFlag = FALSE;
  dataAbortFlag = FALSE;

  softIrqFlag = FALSE;
  timer1IrqFlag = FALSE;
  timer2IrqFlag = FALSE;
  timersIrqFlag = FALSE;
  wdogIrqFlag = FALSE;
  gpio0IrqFlag = FALSE;
  gpio1IrqFlag = FALSE;
  gpio2IrqFlag = FALSE;
  gpio3IrqFlag = FALSE;
  gpio4IrqFlag = FALSE;
  gpio5IrqFlag = FALSE;
  gpio6IrqFlag = FALSE;
  gpio7IrqFlag = FALSE;
  gpioIrqFlag = FALSE;

  softFiqFlag = FALSE;
  timer1FiqFlag = FALSE;
  timer2FiqFlag = FALSE;
  timersFiqFlag = FALSE;
  wdogFiqFlag = FALSE;
  gpio0FiqFlag = FALSE;
  gpio1FiqFlag = FALSE;
  gpio2FiqFlag = FALSE;
  gpio3FiqFlag = FALSE;
  gpio4FiqFlag = FALSE;
  gpio5FiqFlag = FALSE;
  gpio6FiqFlag = FALSE;
  gpio7FiqFlag = FALSE;
  gpioFiqFlag = FALSE;

}


//----------------------------------------------------------------------------
// initialise_special ()
// Initialise the global variables on the first run only
//----------------------------------------------------------------------------
void initialise_special( void )
{

// This is the top-level test status flag
// must not be initialised by __main()
// so that its value is preserved after Watchdog Reset
  testStatus = PASS;

}



// end of file easy_tst.c
