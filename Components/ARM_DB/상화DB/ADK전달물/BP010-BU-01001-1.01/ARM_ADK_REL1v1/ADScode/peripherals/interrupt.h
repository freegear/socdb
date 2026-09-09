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
//  File Name           :interrupt.h,v
//  File Revision       :1.6
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Interrupt Controller registers
//
//--========================================================================--

#ifndef INTERRUPT_H
#define INTERRUPT_H

#include "globals.h"

typedef struct 
{
  volatile Word ICIRQStatus;    // @ 0x00
  volatile Word ICFIQStatus;    // @ 0x04
  volatile Word ICRawIntr;      // @ 0x08
  volatile Word ICIntSelect;    // @ 0x0C
  volatile Word ICIntEnable;    // @ 0x10
  volatile Word ICInEnClear;    // @ 0x14
  volatile Word ICSoftInt;      // @ 0x18
  volatile Word ICSoftIntClear; // @ 0x1C
  volatile Word ICProtection;   // @ 0x20

  const Word fill0[3];

  volatile Word ICVectAddr;     // @ 0x30
  volatile Word ICDefVectAddr;  // @ 0x34

  const Word fill1[178];

  volatile Word ICITCR;         // @ 0x300
  volatile Word ICITIP1;        // @ 0x304
  volatile Word ICITIP2;        // @ 0x308
  volatile Word ICITOP1;        // @ 0x30C
  volatile Word ICITOP2;        // @ 0x310

  const Word fill2[819];

  volatile const Word ICPeriphID0;    // @ 0xFE0
  volatile const Word ICPeriphID1;
  volatile const Word ICPeriphID2;
  volatile const Word ICPeriphID3;
  volatile const Word ICPCellID0;
  volatile const Word ICPCellID1;
  volatile const Word ICPCellID2;
  volatile const Word ICPCellID3;
} Interrupt;
extern Interrupt interrupt;



#define INTCNTL_SOFT 0x02U

#define INTCNTL_COMMSRX 0x04U
#define INTCNTL_COMMSTX 0x08U

#define INTCNTL_TIMER1 0x10U
#define INTCNTL_TIMER2 0x20U
#define INTCNTL_TIMERS 0x40U

#define INTCNTL_WDOG 0x80U

#define INTCNTL_GPIO0 0x01000000U
#define INTCNTL_GPIO1 0x02000000U
#define INTCNTL_GPIO2 0x04000000U
#define INTCNTL_GPIO3 0x08000000U
#define INTCNTL_GPIO4 0x10000000U
#define INTCNTL_GPIO5 0x20000000U
#define INTCNTL_GPIO6 0x40000000U
#define INTCNTL_GPIO7 0x80000000U
#define INTCNTL_GPIO 0x0100U

#define INTCNTL_ALL (INTCNTL_SOFT | INTCNTL_COMMSRX	| \
                         INTCNTL_COMMSTX | 	INTCNTL_TIMER1 | \
						 INTCNTL_TIMER2 | INTCNTL_TIMERS | \
						 INTCNTL_WDOG | INTCNTL_GPIO0 |	\
						 INTCNTL_GPIO1 | INTCNTL_GPIO2 | \
						 INTCNTL_GPIO3 | INTCNTL_GPIO4 | \
						 INTCNTL_GPIO5 | INTCNTL_GPIO6 | \
						 INTCNTL_GPIO7 | INTCNTL_GPIO )

#define INTCNTL_SELECT_IRQ_ALL 0x00
#define INTCNTL_SELECT_FIQ_ALL INTCNTL_ALL

#define INT_ID_VALUE  0x00041808
#define INT_ID_MASK   0xFFFFFFFF

#endif // defined( INTERRUPT_H )

// end of file interrupt.h