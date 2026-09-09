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
//  File Name           :rtc.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Rtc registers
//
//--========================================================================--

#ifndef RTC_H
#define RTC_H

#include "globals.h"

typedef struct
{ 
  volatile Word  RTCDR       ;  
  volatile Word  RTCMR       ;  
  volatile Word  RTCLR       ;  
  volatile Word  RTCCR       ;  
  volatile Word  RTCIMSC     ;  
  volatile Word  RTCRIS      ;  
  volatile Word  RTCMIS      ;  
  volatile Word  RTCICR      ;  

  volatile const fill1[1008]; 

  volatile const RTCPeriphID0;  
  volatile const RTCPeriphID1;  
  volatile const RTCPeriphID2;  
  volatile const RTCPeriphID3;  
                                
  volatile const RTCPCellID0;   
  volatile const RTCPCellID1;   
  volatile const RTCPCellID2;   
  volatile const RTCPCellID3;   
} Rtc;          
extern Rtc rtc;

#define RTC_ID_MASK   0xFFFFFFFF
#define RTC_ID_VALUE  0x00041181

#endif // defined( RTC_H )

