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
//  File Name           :uart.h,v
//  File Revision       :1.6
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : GPIO registers
//
//--========================================================================--


#ifndef GPIO_H
#define GPIO_H

#include "globals.h"

typedef struct
{ 
  volatile Word GpioDATA[256];       // @0x00-0x3FC
  volatile Word GpioDIR;             // @0x400
  volatile Word GpioIS;              // @0x404
  volatile Word GpioIBE;             // @0x408
  volatile Word GpioIEv;             // @0x40C
  volatile Word GpioIE;              // @0x410
  volatile const Word GpioRIS;       // @0x414
  volatile const Word GpioMIS;       // @0x418
  volatile Word GpioIC;              // @0x41C
  volatile Word GpioAFSEL;           // @0x420
  
  const Word fill0[119];       // @0x424-0x5FC

  volatile Word GpioITCR;            // @0x600
  volatile Word GpioITIP1;           // @0x604
  volatile Word GpioITIP2;           // @0x608
  volatile Word GpioITOP1;           // @0x60C
  volatile const Word GpioITOP2;     // @0x610
  volatile Word GpioITOP3;           // @0x614
  
  const Word fill1[622];       // @0x618-0xFCC
  
  
  volatile const Word reservedID[4]; // @0xFD0-0xFDC

  volatile const Word GpioPeriphID0; // @ 0xFE0
  volatile const Word GpioPeriphID1;
  volatile const Word GpioPeriphID2;
  volatile const Word GpioPeriphID3;
  volatile const Word GpioPCellID0;
  volatile const Word GpioPCellID1;
  volatile const Word GpioPCellID2;
  volatile const Word GpioPCellID3;
}  Gpio;

extern Gpio gpio;

// Peripheral ID
#define GPIO_ID_VALUE  0x00041061
#define GPIO_ID_MASK   0xFFFFFFFF

// Mode Control 
#define GPIO_AFSEL_ALL_SW 0x00U
#define GPIO_AFSEL_ALL_HW 0xFFU

// Integration test mode
#define GPIO_ITM_ON 0x01U
#define GPIO_ITM_OFF 0x00U

#define GPIO_ITM_INT0 0x01U
#define GPIO_ITM_INT1 0x02U
#define GPIO_ITM_INT2 0x04U
#define GPIO_ITM_INT3 0x08U
#define GPIO_ITM_INT4 0x10U
#define GPIO_ITM_INT5 0x20U
#define GPIO_ITM_INT6 0x40U
#define GPIO_ITM_INT7 0x80U


// Data Register

#define GPIO_DATA_ALL 0xFFU



#endif // defined( GPIO_H )

// end of file uart.h
