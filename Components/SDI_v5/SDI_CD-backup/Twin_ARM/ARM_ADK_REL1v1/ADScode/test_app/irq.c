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
//  File Name           :irq.c,v
//  File Revision       :1.14
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : IRQ handler
//
//--========================================================================--

#include <stdio.h>
#include "peripherals.h"
#include "irq.h"



//----------------------------------------------------------------------------
// irq_Handler ()
// This function handles IRQ interrupts.
// This handler simply clears the interrupt and sets corresponding flags.
// These flags are then checked by the main application.
// Checks for and, if necessary, exits Pause mode.
//
// Warning:  There is no stack overflow checking.
//
//----------------------------------------------------------------------------

void __irq irq_Handler(void)
{
  Word status;
       

//  Check to see if the processor was placed into Pause mode 
//  by reading the PauseFlag memory location and clear PauseFlag 

  if ( pauseFlag == TRUE )
  {
    pauseFlag = FALSE;    
  }

  // Read the status from the interrupt controller
  status = interrupt.ICIRQStatus;

  textIndent++;
  TEST_REPORT("IRQ (ICIRQStatus = %#08.8lx)", status);
  textIndent--;
  
  // Deal with source of interrupt
        
  // soft interrupt
  if (status & INTCNTL_SOFT)
  {
    interrupt.ICSoftIntClear =  INTCNTL_SOFT;   // clear the interrupt
    softIrqFlag = TRUE;                             // set notification flag
  } 

  // Timer 1 Interrupt
  if (status & INTCNTL_TIMER1)
  {
    timer.Timer1IntClr =  0;            // clear the interrupt
    timer.TimerITOP = 0;                // clear Timer interrupt in ITM
    timer1IrqFlag = TRUE;               // set notification flag
  } 
  
  // Timer 2 interrupt
  if (status & INTCNTL_TIMER2)
  {
    timer.Timer2IntClr =  0;            // clear the interrupt
    timer.TimerITOP = 0;                // clear Timer interrupt in ITM
    timer2IrqFlag = TRUE;               // set notification flag
  }
  
  // Timer combined interrupt
  if (status & INTCNTL_TIMERS)
  {
    timer.Timer1IntClr =  0;            // clear the interrupt
    timer.Timer2IntClr =  0;            // clear the interrupt
    timer.TimerITOP = 0;                // clear Timer interrupt in ITM
    timersIrqFlag = TRUE;               // set notification flag
  }

  
  // watchdog interrupt
  if (status & INTCNTL_WDOG)
  {
    wdog.WdogIntClr = 0;                // clear the interrupt
    wdog.WdogITOP = 0;                  // clear Watchdog interrupt in ITM
    wdogIrqFlag = TRUE;                 // set notification flag
  } 

  // GPIO individual interrupts
  if (status & INTCNTL_GPIO0)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpio0IrqFlag = TRUE;                // set notification flag
  }

  if (status & INTCNTL_GPIO1)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpio1IrqFlag = TRUE;                // set notification flag
  }

  if (status & INTCNTL_GPIO2)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpio2IrqFlag = TRUE;                // set notification flag
  }

  if (status & INTCNTL_GPIO3)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpio3IrqFlag = TRUE;                // set notification flag
  }

  if (status & INTCNTL_GPIO4)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpio4IrqFlag = TRUE;                // set notification flag
  }

  if (status & INTCNTL_GPIO5)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpio5IrqFlag = TRUE;                // set notification flag
  }

  if (status & INTCNTL_GPIO6)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpio6IrqFlag = TRUE;                // set notification flag
  }

  if (status & INTCNTL_GPIO7)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpio7IrqFlag = TRUE;                // set notification flag
  }

   // GPIO combined interrupt
  if (status & INTCNTL_GPIO)
  {
    gpio.GpioITOP1 = 0;                 // clear GPIO interrupt in ITM
    gpioIrqFlag = TRUE;                 // set notification flag
  }

  // UART combined interrupt
  if (status & INTCNTL_UART)
  {
    uart.UARTICR = 0x0020;                 // clear UART interrupt in ITM
    uartIrqFlag = TRUE;                 // set notification flag
    printf("\nUART int Handler\n");
  }

   // __irq C library function will pop registers from stack and return
}

// end of file irq.c
