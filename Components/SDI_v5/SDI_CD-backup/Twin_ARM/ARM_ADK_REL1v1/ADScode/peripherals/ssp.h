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
//  File Name           :ssp.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Ssp registers
//
//--========================================================================--

#ifndef SSP_H
#define SSP_H

#include "globals.h"

typedef struct
{ 
  volatile Word  SSPCR0      ; 
  volatile Word  SSPCR1      ; 
  volatile Word  SSPDR       ; 
  volatile Word  SSPSR       ; 
  volatile Word  SSPCPSR     ; 
  volatile Word  SSPIMSC     ; 
  volatile Word  SSPRIS      ; 
  volatile Word  SSPMIS      ; 
  volatile Word  SSPICR      ; 
  volatile Word  SSPDMACR    ; 
 
  volatile const fill1[21]; 
 
  volatile Word  SSPTCR      ; 
  volatile Word  SSPITIP     ; 
  volatile Word  SSPITOP     ; 
  volatile Word  SSPTDR      ; 

  volatile const fill2[980]; 

  volatile const SSPPeriphID0; 
  volatile const SSPPeriphID1; 
  volatile const SSPPeriphID2; 
  volatile const SSPPeriphID3; 
                               
  volatile const SSPPCellID0;  
  volatile const SSPPCellID1;  
  volatile const SSPPCellID2;  
  volatile const SSPPCellID3;  
} Ssp;          
extern Ssp ssp;

#define SSP_ID_MASK   0xFFFFFFFF
#define SSP_ID_VALUE  0x00041181

#endif // defined( SSP_H )

