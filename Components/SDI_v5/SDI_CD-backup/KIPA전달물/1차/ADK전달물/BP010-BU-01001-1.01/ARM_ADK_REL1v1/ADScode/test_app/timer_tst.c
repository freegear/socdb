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
//  File Name           :timer_tst.c,v
//  File Revision       :1.13
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Example EASY world C test program that              
//                        performs integration tests on timers                
//                       and wake from pause on interrupt function
//
//--========================================================================--


#include "peripherals.h"
#include "testutils.h"
#include "timer_tst.h"
#include "pause.h"
#include "irq.h"

#include <stdio.h>
#include <stdlib.h>

// defines
#define TIMER1_TEST_LOAD_VALUE 0x200
#define TIMER2_TEST_LOAD_VALUE 0x100


// Function Prototypes
TestStatus testTimer1Pause( void );
TestStatus testTimer2Pause( void );
TestStatus testTimer( void );


//----------------------------------------------------------------------------
// testTimer ()
// Setup timer 1 followed by timer 2 to count down to 0 in 
// periodic mode. Generating an interrupt when the timer reaches
// 0. The processor is halted while the timer counts down and is
// woken by the timer interrupt.
//----------------------------------------------------------------------------
TestStatus testTimer()
{
  TestStatus status = PASS;

  DO_TEST( testPeriphID( (Word *)( &timer ), TIMER_ID_VALUE, TIMER_ID_MASK ), 
                         "ID registers", status );
  DO_TEST( testPcellID( (Word *)( &timer ) ), "PrimeCell ID", status );
  DO_TEST( testTimer1Pause(), "Timer1-pause", status );
  DO_TEST( testTimer2Pause(), "Timer2-pause", status );

  return status; 

}


//----------------------------------------------------------------------------
// testTimer1Pause()
//
// Setup timer 1 to count down from 0x200 in oneshot mode
// with no prescale. An interrupt should be generated when the 
// timer reaches 0.
// The processor is halted after the timer has been programmed
// and will be woken up by the interrupt from the timer.
//----------------------------------------------------------------------------

TestStatus testTimer1Pause( void )
{

  TestStatus status = PASS;
  Word oldHandler;

  // Initialise timer interrupt flag
  timer1IrqFlag = FALSE;

  // set timer 1 interrupt to be IRQ
  interrupt.ICIntSelect &= !INTCNTL_TIMER1;
  
  // install IRQ handler
  oldHandler = installHandler ( (Word)irq_Handler, &irq_Addr );

  // Clear timer timer interrupt
  timer.Timer1IntClr = 0;

  // Enable timer interrupt in interrupt controller
  interrupt.ICIntEnable = (INTCNTL_TIMER1 );
  
  // Load and start the timer
  timer.Timer1Load = TIMER1_TEST_LOAD_VALUE;
  timer.Timer1Ctrl = 
    (T1_CTRL_ENABLE |
     T1_CTRL_IE | 
     T1_CTRL_ONESHOT | 
     T1_CTRL_PRESCALE0);

  // Halt processor
  enterPauseMode();

  // Disable timer
  timer.Timer1Ctrl = T1_CTRL_DISABLE;

  // re-install default IRQ handler
  installHandler ( oldHandler, &irq_Addr );
  
  // confirm that Timer 1 interrupt occurred
  DO_CHECK( timer1IrqFlag, TRUE, "Timer interrupt", status ); 
  
  // confirm that pauseFlag is clear
  DO_CHECK( pauseFlag, FALSE, "Pause test", status ); 

  return status; // default return value if not already failed
}


//----------------------------------------------------------------------------
// testTimer2Pause()
//
// Setup timer 2 to count down from 0x200 in oneshot mode
// with no prescale. An interrupt should be generated when the 
// timer reaches 0.
// The processor is halted after the timer has been programmed
// and will be woken up by the interrupt from the timer.
//----------------------------------------------------------------------------
TestStatus testTimer2Pause( void )
{

  TestStatus status = PASS;
  Word oldHandler;

  // Initialise timer interrupt flag
  timer2IrqFlag = FALSE;

  // set timer 2 interrupt to be IRQ
  interrupt.ICIntSelect &= !INTCNTL_TIMER2;
  
  // install IRQ handler
  oldHandler = installHandler ( (Word)irq_Handler, &irq_Addr );

  // Clear timer timer interrupt
  timer.Timer2IntClr = 0;

  // Enable timer interrupt in interrupt controller
  interrupt.ICIntEnable = (INTCNTL_TIMER2 );

  // Load and start the timer
  timer.Timer2Load = TIMER2_TEST_LOAD_VALUE;
  timer.Timer2Ctrl =    
    (T2_CTRL_ENABLE |
     T2_CTRL_IE | 
     T2_CTRL_ONESHOT | 
     T2_CTRL_PRESCALE0);

  // Halt processor
  enterPauseMode();

  // Disable timer
  timer.Timer2Ctrl = T2_CTRL_DISABLE;

  // re-install default IRQ handler
  installHandler ( oldHandler, &irq_Addr );

  // confirm that Timer 2 interrupt occurred
  DO_CHECK( timer2IrqFlag, TRUE, "Timer interrupt", status ); 
  
  // confirm that pauseFlag is clear
  DO_CHECK( pauseFlag, FALSE, "Pause test", status ); 

  return status; // default return value if not already failed

}

// end of file timer_tst.c