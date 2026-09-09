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
//  File Name           :aaci.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Aaic registers
//
//--========================================================================--

#ifndef AAIC_H
#define AAIC_H

#include "globals.h"

typedef struct
{ 
  volatile Word  AACIRXCR1    ; 
  volatile Word  AACITXCR1    ; 
  volatile Word  AACISR1      ; 
  volatile Word  AACIISR1     ; 
  volatile Word  AACIIE1      ; 
  volatile Word  AACIRXCR2    ; 
  volatile Word  AACITXCR2    ; 
  volatile Word  AACISR2      ; 
  volatile Word  AACIISR2     ; 
  volatile Word  AACIIE2      ; 
  volatile Word  AACIRXCR3    ; 
  volatile Word  AACITXCR3    ; 
  volatile Word  AACISR3      ; 
  volatile Word  AACIISR3     ; 
  volatile Word  AACIIE3      ; 
  volatile Word  AACIRXCR4    ; 
  volatile Word  AACITXCR4    ; 
  volatile Word  AACISR4      ; 
  volatile Word  AACIISR4     ; 
  volatile Word  AACIIE4      ; 
  volatile Word  AACISL1RX    ; 
  volatile Word  AACISL1TX    ; 
  volatile Word  AACISL2RX    ; 
  volatile Word  AACISL2TX    ; 
  volatile Word  AACISL12RX   ; 
  volatile Word  AACISL12TX   ; 
  volatile Word  AACISLFR     ; 
  volatile Word  AACISLISTAT  ; 
  volatile Word  AACISLIEN    ; 
  volatile Word  AACIINTCLR   ; 
  volatile Word  AACIMAINCR   ; 
  volatile Word  AACIRESET    ; 
  volatile Word  AACISYNC     ; 
  volatile Word  AACIALLINTS  ; 
  volatile Word  AACIMAINFR   ; 

  volatile const fill1 	      ; 
 
  volatile Word  AACIDR1      ; 

  volatile const fill2[7]     ; 
  
  volatile Word  AACIDR2      ; 
  volatile Word  AACIDR3      ; 
  volatile Word  AACIDR4      ; 

  volatile const fill3[35]    ; 
  
  volatile Word  AACITCR      ; 
  volatile Word  AACIITIP     ; 
  volatile Word  AACIITOP0    ; 
  volatile Word  AACIITOP1    ; 

  volatile const fill4[916]; 
 
  volatile const AAICPeriphID0; 
  volatile const AAICPeriphID1; 
  volatile const AAICPeriphID2; 
  volatile const AAICPeriphID3; 
                                
  volatile const AAICPCellID0;  
  volatile const AAICPCellID1;  
  volatile const AAICPCellID2;  
  volatile const AAICPCellID3;  
} Aaci;          
extern Aaci aaci;

#define AAIC_ID_MASK   0xFFFFFFFF
#define AAIC_ID_VALUE  0x00041181

#endif // defined( AAIC_H )

