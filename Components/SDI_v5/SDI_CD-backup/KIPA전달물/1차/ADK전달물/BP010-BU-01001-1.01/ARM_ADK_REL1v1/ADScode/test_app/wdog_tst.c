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
//  File Name           :wdog_tst.c,v
//  File Revision       :1.15
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Example EASY world C test program that
//                        performs integration tests on Watchdog
//
//--========================================================================--

#include "peripherals.h"
#include "testutils.h"
#include "wdog_tst.h"
#include "reset_tst.h"

#include <stdio.h>
#include <stdlib.h>

// defines
#define WDOG_WAIT  50  // When used in loops, will not give an accurate delay
#define LOAD_VALUE_WDOG 0x0FU // Counter initial value for watchdog test

// Function prototypes
TestStatus testWatchdog( void );
TestStatus watchdogReset( void );
TestStatus testContinueWatchdog( void );



//----------------------------------------------------------------------------
// testWatchdog ()
// Verifies Watchdog PCellID and PeriphID
// Tests Watchdog reset
//----------------------------------------------------------------------------
TestStatus testWatchdog( void )
{

  TestStatus status = PASS;

  DO_TEST( testPeriphID( (Word *)( &wdog ), WDOG_ID_VALUE, WDOG_ID_MASK ),
                         "ID registers", status );
  DO_TEST( testPcellID( (Word *)( &wdog ) ), "PrimeCell ID", status );

  DO_TEST( watchdogReset(), "Watchdog reset", status );
  
  // program flow should never reach here  
  return status;
 
}

//----------------------------------------------------------------------------
// watchdogReset ()
// Starts watchdog with interrupt and reset enabled
// Waits for watchdog reset
// Returns FAIL if reset does not occur.
//----------------------------------------------------------------------------
TestStatus watchdogReset( void )
{
  
  Word i;

  // load the counter
  wdog.WdogLoad = LOAD_VALUE_WDOG;
  
  // enable watchdog reset and interrupts and starts the counter
  wdog.WdogControl = ( WDOG_CTRL_RESEN | WDOG_CTRL_INTEN );   

  // Note: An interrupt will not occur because watchdog interrupt is not
  // enabled in interrupt controller.
  
  // Wait to allow watchdog reset to occur
  // If this doesn't occur with in WDOG_WAIT iterations flag an error
  for( i = 0; i < WDOG_WAIT; i++ )
  {
    // wait loop
  }

  // program flow now jumps to Reset handler, and so should never reach here  
  TEST_MSG( "ERROR: No Watchdog reset occurred" );

  return FAIL;
}


//----------------------------------------------------------------------------
// testContinueWatchdog ()
// Continuation of Watchdog Reset test after watchdog reset
//----------------------------------------------------------------------------
TestStatus testContinueWatchdog( void )
{
  TestStatus status = PASS;

  // Clear Watchdog interrupt
  wdog.WdogIntClr = WDOG_INT_CLR;

  // Test that Power-on Reset bit is set
  DO_TEST( testPowerOnReset() , "Power-on reset", status );

  return status;
}

// end of file wdog_tst.c