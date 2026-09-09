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
//  File Name           :timer.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Timer registers
//
//--========================================================================--

#ifndef TIMER_H
#define TIMER_H

#include "globals.h"

typedef struct
{ 
  volatile Word Timer1Load;  // @ 0x00
  volatile Word Timer1Value; // @ 0x04
  volatile Word Timer1Ctrl;  // @ 0x08
  volatile Word Timer1IntClr;// @ 0x0C
  volatile Word Timer1RIS;   // @ 0x10
  volatile Word Timer1MIS;   // @ 0x14
  volatile Word Timer1BGL;   // @ 0x18

  const Word fill1[1];
  
  volatile Word Timer2Load;  // @ 0x20
  volatile Word Timer2Value; // @ 0x24
  volatile Word Timer2Ctrl;  // @ 0x28
  volatile Word Timer2IntClr;// @ 0x2C
  volatile Word Timer2RIS;   // @ 0x30
  volatile Word Timer2MIS;   // @ 0x34
  volatile Word Timer2BGL;   // @ 0x38
  
  const Word fill2[945];
  
  volatile Word TimerITCR;   // @ 0xF00
  volatile Word TimerITOP;   // @ 0xF04
  
  const Word fill3[54];

  volatile const Word TimerPeriphID0;  // @ 0xFE0
  volatile const Word TimerPeriphID1;
  volatile const Word TimerPeriphID2;
  volatile const Word TimerPeriphID3;
  volatile const Word TimerPCellID0;
  volatile const Word TimerPCellID1;
  volatile const Word TimerPCellID2;
  volatile const Word TimerPCellID3;

} Timer;
extern Timer timer;

// T1Clear

// T1Ctrl
#define T1_CTRL_MASK 3084U
#define T1_CTRL_DISABLE 0x00U
#define T1_CTRL_ENABLE 0x80U
#define T1_CTRL_PERIODIC 0x40U
#define T1_CTRL_IE 0x20U
#define T1_CTRL_PRESCALE8 0x08U
#define T1_CTRL_PRESCALE4 0x04U
#define T1_CTRL_PRESCALE0 0x00U
#define T1_CTRL_ONESHOT 0x01U


// T1Load
#define T1_LOAD_MASK 65535U

// T1test
#define T1_TEST_MASK 15U
#define T1_TEST_TESTCLOCK 0x02U
#define T1_TEST_TESTMODE 0x01US

// T1Value
#define T1_VALUE_MASK 65535U

// T2Clear

// T2Ctrl
#define T2_CTRL_MASK 3084U
#define T2_CTRL_DISABLE 0x00U
#define T2_CTRL_ENABLE 0x80U
#define T2_CTRL_PERIODIC 0x40U
#define T2_CTRL_IE 0x20U
#define T2_CTRL_PRESCALE8 0x08U
#define T2_CTRL_PRESCALE4 0x04U
#define T2_CTRL_PRESCALE0 0x00U
#define T2_CTRL_ONESHOT 0x01U

// T2Load
#define T2_LOAD_MASK 65535U

// T2Test
#define T2_TEST_MASK 15U
#define T2_TEST_TESTCLOCK 0x02U
#define T2_TEST_TESTMODE 0x01U

// T2Value
#define T2_VALUE_MASK 65535U

// Integration test mode
#define TIMER_ITM_ON 0x01U
#define TIMER_ITM_OFF 0x0U

#define T1_ITM_INT 0x01U
#define T2_ITM_INT 0x02U

// Peripheral ID
#define TIMER_ID_VALUE  0x00041804
#define TIMER_ID_MASK   0xFFFFFFFF


#endif // defined( TIMER_H )

// end of file timer.h