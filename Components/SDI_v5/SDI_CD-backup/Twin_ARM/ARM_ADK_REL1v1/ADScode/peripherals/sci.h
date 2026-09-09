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
//  File Name           :sci.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Sci registers
//
//--========================================================================--

#ifndef SCI_H
#define SCI_H

#include "globals.h"

typedef struct
{ 
  volatile Word  SCIDATA      ; 
  volatile Word  SCICR0       ; 
  volatile Word  SCICR1       ; 
  volatile Word  SCICR2       ; 
  volatile Word  SCICLKICC    ; 
  volatile Word  SCIVALUE     ; 
  volatile Word  SCIBAUD      ; 
  volatile Word  SCITIDE      ; 
  volatile Word  SCIDMACR     ; 
  volatile Word  SCISTABLE    ; 
  volatile Word  SCIATIME     ; 
  volatile Word  SCIDTIME     ; 
  volatile Word  SCIATRSTIME  ; 
  volatile Word  SCIATRDTIME  ; 
  volatile Word  SCISTOPTIME  ; 
  volatile Word  SCISTARTTIME ; 
  volatile Word  SCIRETRY     ; 
  volatile Word  SCICHTIMELS  ; 
  volatile Word  SCICHTIMEMS  ; 
  volatile Word  SCIBLKTIMELS ; 
  volatile Word  SCIBLKTIMEMS ; 
  volatile Word  SCICHGUARD   ; 
  volatile Word  SCIBLKGUARD  ; 
  volatile Word  SCIRXTIME    ; 
  volatile Word  SCIFIFOSTATUS; 
  volatile Word  SCITXCOUNT   ; 
  volatile Word  SCIRXCOUNT   ; 
  volatile Word  SCIIMSC      ; 
  volatile Word  SCIRIS       ; 
  volatile Word  SCIMIS       ; 
  volatile Word  SCIICR       ; 
  volatile Word  SCISYNCACT   ; 
  volatile Word  SCISYNCTX    ; 
  volatile Word  SCISYNCRX    ; 

  volatile const fill1[982]; 

  volatile const SCIPeriphID0;  
  volatile const SCIPeriphID1;  
  volatile const SCIPeriphID2;  
  volatile const SCIPeriphID3;  
                                
  volatile const SCIPCellID0;   
  volatile const SCIPCellID1;   
  volatile const SCIPCellID2;   
  volatile const SCIPCellID3;   
} Sci;          
extern Sci sci;

#define SCI_ID_MASK   0xFFFFFFFF
#define SCI_ID_VALUE  0x00041181

#endif // defined( SCI_H )

