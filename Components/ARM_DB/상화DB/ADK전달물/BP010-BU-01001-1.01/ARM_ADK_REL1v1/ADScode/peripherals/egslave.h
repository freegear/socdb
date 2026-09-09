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
//  File Name           :egslave.h,v
//  File Revision       :1.7
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Example APB Slave registers
//
//--========================================================================--

#ifndef EGSLAVE_H
#define EGSLAVE_H

#include "globals.h"

typedef struct xEgSlave
{ 
  volatile Word R0;
  volatile Word R1;
  volatile Word R2;
  volatile Word R3;
  volatile const Word read10;
  volatile const Word read14;
  volatile const Word read18;
  volatile const Word read1C;
  volatile const Word read20;
  volatile const Word read24;
  volatile const Word read28;

  const Word fill[1005];

  volatile const Word PeriphID0;  // @ 0xFE0
  volatile const Word PeriphID1;
  volatile const Word PeriphID2;
  volatile const Word PeriphID3;
  volatile const Word PCellID0;
  volatile const Word PCellID1;
  volatile const Word PCellID2;
  volatile const Word PCellID3;

} EgSlave;

extern EgSlave egSlave;


// Peripheral IDs
#define EGSLAVE_ID_VALUE  0x00041806
#define EGSLAVE_ID_MASK   0xFFFFFFFF


#endif // defined( EGSLAVE_H )

// end of file egslave.h
