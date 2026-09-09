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
//  File Name           :int_tst.c,v
//  File Revision       :1.15
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose           : Example EASY world C test program that
//                     tests all Interrupt Controller connections
//
//--========================================================================--

#include "peripherals.h"
#include "testutils.h"
#include "int_tst.h"
#include "irq.h"
#include "fiq.h"

#include <stdio.h>
#include <stdlib.h>

// defines
#define INT_WAIT  50  // When used in loops, will not give an accurate delay

// Function prototypes

TestStatus testSoftIrq( void );
TestStatus testGpioIrq( void );
TestStatus testTimer1Irq( void );
TestStatus testTimer2Irq( void );
TestStatus testWdogIrq( void );

TestStatus testSoftFiq( void );
TestStatus testGpioFiq( void );
TestStatus testTimer1Fiq( void );
TestStatus testTimer2Fiq( void );
TestStatus testWdogFiq( void );

TestStatus testGpioIrqX( volatile Boolean *, const Word );
TestStatus testGpioFiqX( volatile Boolean *, const Word );
//----------------------------------------------------------------------------
// testInterrupts ()
// Calls tests on interrupt controller
//----------------------------------------------------------------------------

TestStatus testInterrupts( void )
{
  TestStatus status = PASS;
  Word oldHandler;

  DO_TEST( testPeriphID( (Word *)( &interrupt ), INT_ID_VALUE, INT_ID_MASK ), 
                         "ID registers", status );
  DO_TEST( testPcellID( (Word *)( &interrupt ) ), "PrimeCell ID", status );

  // set all interrupts to be IRQ
  interrupt.ICIntSelect = INTCNTL_SELECT_IRQ_ALL;
  
  // install IRQ handler
  oldHandler = installHandler ( (Word)irq_Handler, &irq_Addr );

  // read IRQ status - none should be set
  DO_CHECK((interrupt.ICIRQStatus & INTCNTL_ALL), 0 ,
            "IRQ status before test", status);

  DO_TEST( testSoftIrq(), "Software invoked IRQ", status );
  DO_TEST( testTimer1Irq(),"Timer 1 IRQ", status );
  DO_TEST( testTimer2Irq(),"Timer 2 IRQ", status );
  DO_TEST( testWdogIrq(), "Watchdog IRQ", status );
  DO_TEST( testGpioIrq(), "GPIO IRQs", status );

  // re-install default IRQ handler
  installHandler ( oldHandler, &irq_Addr );

  // install FIQ handler
  oldHandler = installHandler ( (Word)fiq_Handler, &fiq_Addr );

  // set all interrupts to be FIQ
  interrupt.ICIntSelect = INTCNTL_SELECT_FIQ_ALL;

  // read FIQ status - none should be set
  DO_CHECK((interrupt.ICFIQStatus & INTCNTL_ALL), 0 ,
            "FIQ status before test", status);


  DO_TEST( testSoftFiq(), "Software invoked FIQ", status );
  DO_TEST( testTimer1Fiq(),"Timer 1 FIQ", status );
  DO_TEST( testTimer2Fiq(),"Timer 2 FIQ", status );
  DO_TEST( testWdogFiq(), "Watchdog FIQ", status );
  DO_TEST( testGpioFiq(), "GPIO FIQs", status ); 

  // re-install default IRQ handler
  installHandler ( oldHandler, &fiq_Addr );
      
  return status;

}    


//----------------------------------------------------------------------------
// testSoftIrq()
// Enable all interrupts in the interrupt controller and 
// then generate a programmed interrupt.
// The variable SoftIrqFlag will be changed from 0 to 1 by the 
// IRQ interrupt handler
//----------------------------------------------------------------------------

TestStatus testSoftIrq( void )
{
  Word i;

  softIrqFlag = FALSE;


  interrupt.ICIntEnable  = INTCNTL_ALL;     // Enable all interrupts
  interrupt.ICSoftInt    = INTCNTL_SOFT;    // Generate soft interrupt

  // Wait for SoftIrqFlag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  for( i = 0; ( softIrqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
    // wait loop
  }

  // clear the interrupt (in case not done in irq handler)
  interrupt.ICSoftIntClear =  INTCNTL_SOFT;
  
  interrupt.ICInEnClear  = INTCNTL_ALL;     // disable all interrupts

  if ( softIrqFlag == FALSE )
  {  
     return FAIL;
  }
  return PASS;
}

//----------------------------------------------------------------------------
// testSoftFiq()
// Enable interrupts in the interrupt controller and 
// then generate a programmed interrupt.
// The variable SoftFiqFlag will be changed from 0 to 1 by the 
// FIQ interrupt handler
//----------------------------------------------------------------------------

TestStatus testSoftFiq( void )
{
  Word i;

  softFiqFlag = FALSE;

  interrupt.ICIntEnable  = INTCNTL_ALL;     // Enable all interrupts

  interrupt.ICSoftInt    = INTCNTL_SOFT;    // Generate soft interrupt

  // Wait for SoftFiqFlag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  for( i = 0; ( softFiqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
    // wait loop
  }

  // clear the interrupt (in case not done in irq handler)
  interrupt.ICSoftIntClear =  INTCNTL_SOFT;
  
  interrupt.ICInEnClear  = INTCNTL_ALL;     // disable all interrupts

  if ( softFiqFlag == FALSE )
  {  
     return FAIL;
  }
  return PASS;
}



//----------------------------------------------------------------------------
// testGpioIrq ()
// Enable interrupts in the interrupt controller and 
// then generate GPIO interrupts.
// The relevant variables gpioxIrqFlag and gpioCIrqFlag will be changed 
// from 0 to 1 by the IRQ interrupt handler 
//----------------------------------------------------------------------------

TestStatus testGpioIrq( void )
{
  TestStatus status = PASS;
  
  // initialize IRQ flags
  gpioIrqFlag = FALSE;
  gpio0IrqFlag = FALSE;
  gpio1IrqFlag = FALSE;
  gpio2IrqFlag = FALSE;
  gpio3IrqFlag = FALSE;
  gpio4IrqFlag = FALSE;
  gpio5IrqFlag = FALSE;
  gpio6IrqFlag = FALSE;
  gpio7IrqFlag = FALSE;

  interrupt.ICIntEnable  = INTCNTL_ALL;       // Enable all interrupts

  // read IRQ status - none should be set
  DO_CHECK( (interrupt.ICIRQStatus & INTCNTL_ALL), 0, 
            "Interrupt status before test", status );

  gpio.GpioITCR = GPIO_ITM_ON;                // put GPIO in test mode

  // Test each of the individual GPIO interrupts (and the combined interrupt) in turn
  DO_TEST( testGpioIrqX( &gpio0IrqFlag, GPIO_ITM_INT0 ), "GPIO IRQ #0", status );
  DO_TEST( testGpioIrqX( &gpio1IrqFlag, GPIO_ITM_INT1 ), "GPIO IRQ #1", status );
  DO_TEST( testGpioIrqX( &gpio2IrqFlag, GPIO_ITM_INT2 ), "GPIO IRQ #2", status );
  DO_TEST( testGpioIrqX( &gpio3IrqFlag, GPIO_ITM_INT3 ), "GPIO IRQ #3", status );
  DO_TEST( testGpioIrqX( &gpio4IrqFlag, GPIO_ITM_INT4 ), "GPIO IRQ #4", status );
  DO_TEST( testGpioIrqX( &gpio5IrqFlag, GPIO_ITM_INT5 ), "GPIO IRQ #5", status );
  DO_TEST( testGpioIrqX( &gpio6IrqFlag, GPIO_ITM_INT6 ), "GPIO IRQ #6", status );
  DO_TEST( testGpioIrqX( &gpio7IrqFlag, GPIO_ITM_INT7 ), "GPIO IRQ #7", status );

  // clear GPIO interrupt in ITM (in case not done in irq handler)
  gpio.GpioITOP1 = 0;

  gpio.GpioITCR = GPIO_ITM_OFF;               // Take GPIO out of test mode
  interrupt.ICInEnClear  = INTCNTL_ALL;       // Disable all interrupts

  return status;

}

//----------------------------------------------------------------------------
// testGpioIrqX ()
// Generate GPIO interrupt X
// The variables gpioXIrqFlag and gpioIrqFlag should be changed 
// from 0 to 1 by the IRQ interrupt handler 
//----------------------------------------------------------------------------

TestStatus testGpioIrqX( volatile Boolean *pGpioXIrqFlag, const Word itmIntBit )
{

  Word i;
  TestStatus status = PASS;

  gpio.GpioITOP1 = itmIntBit;  // set GPIOMIS[n]
    
  for( i = 0; ( *pGpioXIrqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
      // wait loop
  }

  DO_CHECK( *pGpioXIrqFlag, TRUE, "Correct Irq bit set", status );
  DO_CHECK( gpioIrqFlag, TRUE, "GPIO combined Irq bit set", status );

  // Check that total number of GPIO irq bits set is equal to the expected GPIO irq bit set
  DO_CHECK( 
    ( (Word)gpio0IrqFlag + (Word)gpio1IrqFlag + (Word)gpio2IrqFlag  + (Word)gpio3IrqFlag +
      (Word)gpio4IrqFlag + (Word)gpio5IrqFlag + (Word)gpio6IrqFlag + (Word)gpio7IrqFlag ),
    (Word)*pGpioXIrqFlag, "Other GPIO Irq bits NOT set", status );

  // Reset flags changed by interrupt handler
  *pGpioXIrqFlag = FALSE;
  gpioIrqFlag = FALSE;

  return status;

}




//----------------------------------------------------------------------------
// testGpioFiq ()
// Enable interrupts in the interrupt controller and 
// then generate GPIO interrupts.
// The relevant variables gpioxFiqFlag and gpioCFiqFlag will be changed 
// from 0 to 1 by the IRQ interrupt handler 
//----------------------------------------------------------------------------

TestStatus testGpioFiq( void )
{

  TestStatus status = PASS;

  // initialize FIQ flags
  gpioFiqFlag = FALSE;
  gpio0FiqFlag = FALSE;
  gpio1FiqFlag = FALSE;
  gpio2FiqFlag = FALSE;
  gpio3FiqFlag = FALSE;
  gpio4FiqFlag = FALSE;
  gpio5FiqFlag = FALSE;
  gpio6FiqFlag = FALSE;
  gpio7FiqFlag = FALSE;

  interrupt.ICIntEnable  = INTCNTL_ALL;       // Enable all interrupts

  // read FIQ status - none should be set
  DO_CHECK( (interrupt.ICFIQStatus & INTCNTL_ALL), 0, 
            "Interrupt status before test", status );


  gpio.GpioITCR = GPIO_ITM_ON;                // put GPIO in test mode

  // Test each of the individual GPIO interrupts (and the combined interrupt) in turn
  DO_TEST( testGpioFiqX( &gpio0FiqFlag, GPIO_ITM_INT0 ), "GPIO FIQ #0", status );
  DO_TEST( testGpioFiqX( &gpio1FiqFlag, GPIO_ITM_INT1 ), "GPIO FIQ #1", status );
  DO_TEST( testGpioFiqX( &gpio2FiqFlag, GPIO_ITM_INT2 ), "GPIO FIQ #2", status );
  DO_TEST( testGpioFiqX( &gpio3FiqFlag, GPIO_ITM_INT3 ), "GPIO FIQ #3", status );
  DO_TEST( testGpioFiqX( &gpio4FiqFlag, GPIO_ITM_INT4 ), "GPIO FIQ #4", status );
  DO_TEST( testGpioFiqX( &gpio5FiqFlag, GPIO_ITM_INT5 ), "GPIO FIQ #5", status );
  DO_TEST( testGpioFiqX( &gpio6FiqFlag, GPIO_ITM_INT6 ), "GPIO FIQ #6", status );
  DO_TEST( testGpioFiqX( &gpio7FiqFlag, GPIO_ITM_INT7 ), "GPIO FIQ #7", status );

 
  // clear GPIO interrupt in ITM (in case not done in fiq handler)
  gpio.GpioITOP1 = 0;
  
  gpio.GpioITCR = GPIO_ITM_OFF;               // take GPIO out of test mode
  interrupt.ICInEnClear  = INTCNTL_ALL;       // Disable all interrupts

  return status;

}


//----------------------------------------------------------------------------
// testGpioFiqX ()
// Generate GPIO interrupt X
// The variables gpioXFiqFlag and gpioFiqFlag should be changed 
// from 0 to 1 by the IRQ interrupt handler 
//----------------------------------------------------------------------------

TestStatus testGpioFiqX( volatile Boolean *pGpioXFiqFlag, const Word itmIntBit )
{

  Word i;
  TestStatus status = PASS;

  gpio.GpioITOP1 = itmIntBit;  // set GPIOMIS[n]
    
  for( i = 0; ( *pGpioXFiqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
      // wait loop
  }

  DO_CHECK( *pGpioXFiqFlag, TRUE, "Correct Fiq bit set", status );
  DO_CHECK( gpioFiqFlag, TRUE, "GPIO combined Fiq bit set", status );

  // Check that total number of GPIO fiq bits set is equal to the expected GPIO fiq bit set
  DO_CHECK( 
    ( (Word)gpio0FiqFlag + (Word)gpio1FiqFlag + (Word)gpio2FiqFlag  + (Word)gpio3FiqFlag +
      (Word)gpio4FiqFlag + (Word)gpio5FiqFlag + (Word)gpio6FiqFlag + (Word)gpio7FiqFlag ),
    (Word)*pGpioXFiqFlag, "Other GPIO Fiq bits NOT set", status );

  // Reset flags changed by interrupt handler
  *pGpioXFiqFlag = FALSE;
  gpioFiqFlag = FALSE;

  return status;

}




//----------------------------------------------------------------------------
// testTimer1Irq ()
// Tests Timer 1 and Timer combined interrupts by putting timer into test mode
//----------------------------------------------------------------------------

TestStatus testTimer1Irq( void )
{
  Word i;
  TestStatus status = PASS;

  // initialize IRQ flags
  timer1IrqFlag = FALSE;
  timer2IrqFlag = FALSE;
  timersIrqFlag = FALSE;
   
  interrupt.ICIntEnable  = INTCNTL_ALL;       // Enable all interrupts

  // read IRQ status - none should be set
  DO_CHECK( (interrupt.ICIRQStatus & INTCNTL_ALL), 0, 
            "Interrupt status before test", status );


  timer.TimerITCR = TIMER_ITM_ON;   // put Timer in test mode
  timer.TimerITOP = T1_ITM_INT;     // set Timer interrupt 1

  // Wait for Timer 1 interrupt flag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  for( i = 0; ( timer1IrqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
    // wait loop
  }

  // clear Timer interrupt in ITM (in case not done in irq handler)
  timer.TimerITOP = 0;
  // take Timer out of test mode
  timer.TimerITCR = TIMER_ITM_OFF;
  // Disable all interrupts
  interrupt.ICInEnClear  = INTCNTL_ALL;

  DO_CHECK( timer1IrqFlag, TRUE, "Timer 1 Irq bit set", status );
  DO_CHECK( timersIrqFlag, TRUE, "Timer combined Irq bit set", status );
  DO_CHECK( timer2IrqFlag, FALSE, "Timer 2 Irq bit NOT set", status );

  return status;
}

//----------------------------------------------------------------------------
// testTimer1Fiq ()
// Tests Timer 1 and Timer combined interrupts by putting timer into test mode
//----------------------------------------------------------------------------

TestStatus testTimer1Fiq( void )
{
  Word i;
  TestStatus status = PASS;

  // initialize FIQ flags
  timer1FiqFlag = FALSE;
  timer2FiqFlag = FALSE;
  timersFiqFlag = FALSE;
   
  interrupt.ICIntEnable  = INTCNTL_ALL;       // Enable all interrupts

  // read FIQ status - none should be set
  DO_CHECK( (interrupt.ICFIQStatus & INTCNTL_ALL), 0, 
            "Interrupt status before test", status );


  timer.TimerITCR = TIMER_ITM_ON;   // put Timer in test mode
  timer.TimerITOP = T1_ITM_INT;     // set Timer interrupt 1

  // Wait for Timer 1 FIQ flag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  for( i = 0; ( timer1FiqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
    // wait loop
  }

  // clear Timer interrupt in ITM (in case not done in irq handler)
  timer.TimerITOP = 0;
  // take Timer out of test mode
  timer.TimerITCR = TIMER_ITM_OFF;
  // Disable all interrupts
  interrupt.ICInEnClear  = INTCNTL_ALL;

  DO_CHECK( timer1FiqFlag, TRUE, "Timer 1 Fiq bit set", status );
  DO_CHECK( timersFiqFlag, TRUE, "Timer combined Fiq bit set", status );
  DO_CHECK( timer2FiqFlag, FALSE, "Timer 2 Fiq bit NOT set", status );

  return status;
}


//----------------------------------------------------------------------------
// testTimer2Irq ()
// Tests Timer 2 and Timer combined interrupts by putting timer into test mode
//----------------------------------------------------------------------------

TestStatus testTimer2Irq( void )
{
  Word i;
  TestStatus status = PASS;

  // initialize IRQ flags
  timer1IrqFlag = FALSE;
  timer2IrqFlag = FALSE;
  timersIrqFlag = FALSE;
   
  interrupt.ICIntEnable  = INTCNTL_ALL;     // Enable all interrupts

  // read IRQ status - none should be set
  DO_CHECK( (interrupt.ICIRQStatus & INTCNTL_ALL), 0, 
            "Interrupt status before test", status );


  timer.TimerITCR = TIMER_ITM_ON;   // put Timer in test mode
  timer.TimerITOP = T2_ITM_INT;     // set Timer interrupt 1

  // Wait for Timer 2 interrupt flag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  for( i = 0; ( timer2IrqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
    // wait loop
  }

  // clear Timer interrupt in ITM (in case not done in irq handler)
  timer.TimerITOP = 0;
  // take Timer out of test mode
  timer.TimerITCR = TIMER_ITM_OFF;
  // Disable all interrupts
  interrupt.ICInEnClear  = INTCNTL_ALL;

  DO_CHECK( timer2IrqFlag, TRUE, "Timer 2 Irq bit set", status );
  DO_CHECK( timersIrqFlag, TRUE, "Timer combined Irq bit set", status );
  DO_CHECK( timer1IrqFlag, FALSE, "Timer 1 Irq bit NOT set", status );

  return status;

}

//----------------------------------------------------------------------------
// testTimer2Fiq ()
// Tests Timer 2 and Timer combined interrupts by putting timer into test mode
//----------------------------------------------------------------------------

TestStatus testTimer2Fiq( void )
{
  Word i;
  TestStatus status = PASS;

  // initialize FIQ flags
  timer1FiqFlag = FALSE;
  timer2FiqFlag = FALSE;
  timersFiqFlag = FALSE;
   
  interrupt.ICIntEnable  = INTCNTL_ALL;     // Enable all interrupts

  // read FIQ status - none should be set
  DO_CHECK( (interrupt.ICFIQStatus & INTCNTL_ALL), 0, 
            "Interrupt status before test", status );


  timer.TimerITCR = TIMER_ITM_ON;   // put Timer in test mode
  timer.TimerITOP = T2_ITM_INT;     // set Timer interrupt 1

  // Wait for Timer 2 interrupt flag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  for( i = 0; ( timer2FiqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
    // wait loop
  }

  // clear Timer interrupt in ITM (in case not done in irq handler)
  timer.TimerITOP = 0;
  // take Timer out of test mode
  timer.TimerITCR = TIMER_ITM_OFF;
  // Disable all interrupts
  interrupt.ICInEnClear  = INTCNTL_ALL;

  DO_CHECK( timer2FiqFlag, TRUE, "Timer 2 Fiq bit set", status );
  DO_CHECK( timersFiqFlag, TRUE, "Timer combined Fiq bit set", status );
  DO_CHECK( timer1FiqFlag, FALSE, "Timer 1 Fiq bit NOT set", status );

  return status;

}

 

//----------------------------------------------------------------------------
// testWdogIrq ()
// Tests Watchdog interrupt by putting watchdog into test mode
//----------------------------------------------------------------------------

TestStatus testWdogIrq( void )
{
  Word i;

  TestStatus status = PASS;

  wdogIrqFlag = FALSE;
   
  interrupt.ICIntEnable  = INTCNTL_ALL;     // Enable all interrupts

  // read IRQ status - none should be set
  DO_CHECK( (interrupt.ICIRQStatus & INTCNTL_ALL), 0, 
            "Interrupt status before test", status );

  wdog.WdogITCR = WDOG_ITM_ON;   // put Watchdog in test mode
  wdog.WdogITOP = WDOG_ITM_INT;  // set Watchdog interrupt

  // Wait for Watchdog interrupt flag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  for( i = 0; ( wdogIrqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
    // wait loop
  }

  // clear Watchdog interrupt in ITM (in case not done in irq handler)
  wdog.WdogITOP = 0;
  // take Watchdog out of test mode
  wdog.WdogITCR = WDOG_ITM_OFF;
  // Disable all interrupts
  interrupt.ICInEnClear  = INTCNTL_ALL;

  if ( wdogIrqFlag == FALSE )
  {  
     return FAIL;
  }
  return status;

}

//----------------------------------------------------------------------------
// testWdogIrq ()
// Tests Watchdog interrupt by putting watchdog into test mode
//----------------------------------------------------------------------------

TestStatus testWdogFiq( void )
{
  Word i;
  TestStatus status = PASS;

  wdogFiqFlag = FALSE;
   
  interrupt.ICIntEnable  = INTCNTL_ALL;     // Enable all interrupts

  // read IRQ status - none should be set
  DO_CHECK( (interrupt.ICIRQStatus & INTCNTL_ALL), 0, 
            "Interrupt status before test", status );

  wdog.WdogITCR = WDOG_ITM_ON;   // put Watchdog in test mode
  wdog.WdogITOP = WDOG_ITM_INT;  // set Watchdog interrupt

  // Wait for Watchdog interrupt flag to be altered by the interrupt handler
  // If this doesn't occur with in INT_WAIT iterations flag an error
  for( i = 0; ( wdogFiqFlag == FALSE ) && ( i < INT_WAIT ) ; i++ )
  {
    // wait loop
  }

  // clear Watchdog interrupt in ITM (in case not done in irq handler)
  wdog.WdogITOP = 0;
  // take Watchdog out of test mode
  wdog.WdogITCR = WDOG_ITM_OFF;
  // Disable all interrupts
  interrupt.ICInEnClear  = INTCNTL_ALL;

  if ( wdogFiqFlag == FALSE )
  {  
     return FAIL;
  }
  return status;

}

// end of file int_tst.c
