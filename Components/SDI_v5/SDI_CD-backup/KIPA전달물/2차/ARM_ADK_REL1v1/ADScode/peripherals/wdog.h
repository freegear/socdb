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
//  File Name           :wdog.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Watchdog registers 
//
//--========================================================================--


#ifndef WDOG_H
#define WDOG_H

#include "globals.h"

typedef struct
{ 
  volatile Word WdogLoad;   // @0x00
  volatile Word WdogValue;
  volatile Word WdogControl;
  volatile Word WdogIntClr;
  volatile Word WdogRIS;
  volatile Word WdogMIS;    // @ 0x14

  const Word fill1[762];
  
  volatile Word WdogLock;   // @ 0xC00

  const Word fill2[191];
  
  volatile Word WdogITCR;   // @ 0xF00
  volatile Word WdogITOP;   // @ 0xF04
  
  const Word fill3[54];

  volatile const Word WdogPeriphID0;  // @ 0xFE0
  volatile const Word WdogPeriphID1;
  volatile const Word WdogPeriphID2;
  volatile const Word WdogPeriphID3;
  volatile const Word WdogPCellID0;
  volatile const Word WdogPCellID1;
  volatile const Word WdogPCellID2;
  volatile const Word WdogPCellID3;
}  Wdog;

extern Wdog wdog;


// Watchdog control register flags
#define WDOG_CTRL_INTEN 0x01U
#define WDOG_CTRL_RESEN 0x02U

// Watchdog interrupt clear
#define WDOG_INT_CLR 0x0U

// Integration test mode
#define WDOG_ITM_ON 0x01U
#define WDOG_ITM_OFF 0x0U

#define WDOG_ITM_RES 0x01U
#define WDOG_ITM_INT 0x02U

// Peripheral ID
#define WDOG_ID_VALUE  0x00041805
#define WDOG_ID_MASK   0xFFFFFFFF

// Interrupt bits
#define WDOG_INT  0x01U

#endif // defined( WDOG_H )

// end of file wdog.h