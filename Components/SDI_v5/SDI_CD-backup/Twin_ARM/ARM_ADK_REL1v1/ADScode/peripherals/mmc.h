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
//  File Name           :mmc.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Mmc registers
//
//--========================================================================--

#ifndef MMC_H
#define MMC_H

#include "globals.h"

typedef struct
{ 
  volatile Word  MMCIPower       ;
  volatile Word  MMCIClock       ;
  volatile Word  MMCIArgument    ;
  volatile Word  MMCICommand     ;
  volatile Word  MMCIRespCmd     ;
  volatile Word  MMCIResponse0   ;
  volatile Word  MMCIResponse1   ;
  volatile Word  MMCIResponse2   ;
  volatile Word  MMCIResponse3   ;
  volatile Word  MMCIDataTimer   ;
  volatile Word  MMCIDataLength  ;
  volatile Word  MMCIDataCtrl    ;
  volatile Word  MMCIDataCnt     ;
  volatile Word  MMCIStatus      ;
  volatile Word  MMCIClear       ;
  volatile Word  MMCIMask0       ;
  volatile Word  MMCIMask1       ;
  volatile Word  MMCISelect      ;
  volatile Word  MMCIFifoCnt     ;

  volatile const fill1[13]; 

  volatile Word  MMCIFIFO        ;

  volatile const fill2[45]; 

  volatile Word  MMCITCR         ;
  volatile Word  MMCIITIP        ;
  volatile Word  MMCIITOP        ;

  volatile const fill3[949]; 

  volatile const MMCIPeriphID0; //
  volatile const MMCIPeriphID1; //
  volatile const MMCIPeriphID2; //
  volatile const MMCIPeriphID3; //
                       
  volatile const MMCIPCellID0;  //
  volatile const MMCIPCellID1;  //
  volatile const MMCIPCellID2;  //
  volatile const MMCIPCellID3;  //
} Mmc;          
extern Mmc mmc;

#define MMC_ID_MASK   0xFFFFFFFF
#define MMC_ID_VALUE  0x00041181

#endif // defined( MMC_H )

