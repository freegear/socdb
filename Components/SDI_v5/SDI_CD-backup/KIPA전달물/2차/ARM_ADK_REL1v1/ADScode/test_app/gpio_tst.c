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
//  File Name           :gpio_tst.c,v
//  File Revision       :1.16
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose              : Example EASY world C test program that
//                        performs integration tests on GPIO
//
//--========================================================================--



#include "peripherals.h"
#include "testutils.h"
#include "gpio_tst.h"

#include <stdio.h>
#include <stdlib.h>


// Function prototypes

TestStatus testGpio( void );
static TestStatus testGpioIO(void);
static TestStatus chkPI(volatile Word *, Word);

// Macros
#define GPIO_WAIT  50  // When used in loops, will not give an accurate delay

// SHIFTL shifts left and keeps only 8 low-order bits
#define SHIFTL(x) x = ((x<<1)&0xFFU)


//----------------------------------------------------------------------------
// testGpio ()
// Verifies GPIO PCellID and PeriphID
// Verifies operation of GPIO Primary I/O 
//----------------------------------------------------------------------------

TestStatus testGpio( void )
{
  TestStatus status = PASS;

  DO_TEST( testPeriphID( (Word *)( &gpio ), GPIO_ID_VALUE, GPIO_ID_MASK ), 
                         "ID registers", status );
  DO_TEST( testPcellID( (Word *)( &gpio ) ), "PrimeCell ID", status );

  DO_TEST( testGpioIO(), "Integration Tests", status);

  return status;

}

//----------------------------------------------------------------------------
// testGpioIO ()
//
// Verifies operation of GPIO Primary I/O
//
// Ref: ARM PrimeCell General Prupose Input/Output (PL061)
//     Technical Reference Manual
//
// The Primary inputs and outputs are tested using a trickbox, which loops 
// back the primary outputs to the primary inputs:
//
//       GPIN[7:0] = GPOUT[7:0] XOR nGPEN[7:0]
//
//
// The GPIO is put in Integration Test Mode, which allows the simulation  
// of output signals via Integration Test Registers GPIOITIP1 and GPIOITIP2.
//
// The GPIO must be configured for Hardware control. 
//
// This enables GPOUT[7:0]/nGPEN[7:0] to be driven from 
// GPAFOUT[7:0]/nGPAFEN[7:0], which in turn are driven from GPIOITIP1[7:0]/
// GPIOITIP2[7:0].
//
//----------------------------------------------------------------------------

static TestStatus testGpioIO(void)
{
  TestStatus status = PASS;

  gpio.GpioITCR =  GPIO_ITM_ON;           // put GPIO in ITM
  gpio.GpioAFSEL = GPIO_AFSEL_ALL_HW;     // select hardware control

  // Set up nGPEN[7:0] to be all 0's, then call chkPI()
  // to drive GPOUT[7:0] with walking 1 pattern
  gpio.GpioITIP2 = 0x00;    // drives nGPEN[7:0]
  if (chkPI(&gpio.GpioITIP1, 0x00) == FAIL)
  {
    status = FAIL;
  }

  // Set up GPOUT[7:0] to be all 1's, then call chkPI()
  // to drive nGPEN[7:0] with walking 1 pattern
  gpio.GpioITIP1 = 0xff;	// GPOUT[7:0]
  if (chkPI(&gpio.GpioITIP2, 0xff) == FAIL)
  {
    status = FAIL;
  }

  gpio.GpioAFSEL = GPIO_AFSEL_ALL_SW;     // select software control
  gpio.GpioITCR =  GPIO_ITM_OFF;          // exit GPIO ITM

 
  return status;
}


//----------------------------------------------------------------------------
// chkPI ()
//
// Performs a walking 1 test on GPIO Primary I/O
//
// The GPIO output pointed to by address is driven with a walking 1 test 
// pattern (testData).
//
// To test whether:
//       GPIN[7:0] == GPOUT[7:0] XOR nGPEN[7:0]
//
//
// the GPIO input is read and compared to the expected value. The expected
// value is: testData XOR xorVal 
//
// GPIN[7:0] is read via the GpioDATA[] register
//
// Note: a period of twice PCLK is required for the data to go through the
// synchronization stage of the GPIO input before reading GpioDATA
//
//----------------------------------------------------------------------------

static TestStatus chkPI(volatile Word *address, Word xorVal)
{
  Word i, j;
  Word testData = 0x01;
  Word gpioData;

  // Write 1 to each bit in turn and test XOR result 
  // Note: Last write is 0x00, hence loop upper limit is 9 rather than 8
  for (i = 0; i < 9; i++, SHIFTL(testData))
  {
    *address = testData;    // drive output

    // Wait for GPIO data to change to expected value.
    j = 0;
    do {
      gpioData = gpio.GpioDATA[GPIO_DATA_ALL];  // read the GPIO input
      j++;  
    } while( ( ( gpioData & GPIO_DATA_ALL ) != 
             ( (testData ^ xorVal) & GPIO_DATA_ALL )
           ) && ( j < GPIO_WAIT ) );

    // Check to see if test timed out
    if ( ( gpioData & GPIO_DATA_ALL ) != 
          ( (testData ^ xorVal) & GPIO_DATA_ALL ) )
  	{
  	  return FAIL;
  	}
  }

  return PASS;
}


// end of file gpio_tst.c