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
//  File Name           :dmac.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : DMA controller registers 
//
//--========================================================================--


#ifndef DMAC_H
#define DMAC_H

#include "globals.h"

typedef struct
{ 
  volatile Word DMACIntStat   ;
  volatile Word DMACIntTCStat ;
  volatile Word DMACIntTCClr  ;
  volatile Word DMACIntErrStat; 
  volatile Word DMACIntErrClr ; 
  volatile Word DMACRawIntTC  ;  
  volatile Word DMACRawIntErr ;     
  volatile Word DMACEnbldChns ;
  volatile Word DMACSoftBReq  ;
  volatile Word DMACSoftSReq  ; 
  volatile Word DMACSoftLBReq ;     
  volatile Word DMACSoftLSReq ;      
  volatile Word DMACConfig    ;
  volatile Word DMACSync      ;      
  const    Word fill1[50];
  volatile Word DMACC0SrcAddr ;      
  volatile Word DMACC0DestAddr;
  volatile Word DMACC0LLIReg  ;      
  volatile Word DMACC0Control ;
  volatile Word DMACC0Config  ;
  const    Word fill2[3];
  volatile Word DMACC1SrcAddr ;      
  volatile Word DMACC1DestAddr;
  volatile Word DMACC1LLIReg  ;      
  volatile Word DMACC1Control ;
  volatile Word DMACC1Config  ;
  const    Word fill3[3];
  volatile Word DMACC2SrcAddr ;      
  volatile Word DMACC2DestAddr;
  volatile Word DMACC2LLIReg  ;      
  volatile Word DMACC2Control ;
  volatile Word DMACC2Config  ;
  const    Word fill4[3];
  volatile Word DMACC3SrcAddr ;      
  volatile Word DMACC3DestAddr;
  volatile Word DMACC3LLIReg  ;      
  volatile Word DMACC3Control ;
  volatile Word DMACC3Config  ;
  const    Word fill5[3];
  volatile Word DMACC4SrcAddr ;      
  volatile Word DMACC4DestAddr;
  volatile Word DMACC4LLIReg  ;      
  volatile Word DMACC4Control ;
  volatile Word DMACC4Config  ;
  const    Word fill6[3];
  volatile Word DMACC5SrcAddr ;      
  volatile Word DMACC5DestAddr;
  volatile Word DMACC5LLIReg  ;      
  volatile Word DMACC5Control ;
  volatile Word DMACC5Config  ;
  const    Word fill7[3];
  volatile Word DMACC6SrcAddr ;      
  volatile Word DMACC6DestAddr;
  volatile Word DMACC6LLIReg  ;      
  volatile Word DMACC6Control ;
  volatile Word DMACC6Config  ;
  const    Word fill8[3];
  volatile Word DMACC7SrcAddr ;      
  volatile Word DMACC7DestAddr;
  volatile Word DMACC7LLIReg  ;      
  volatile Word DMACC7Control ;
  volatile Word DMACC7Config  ;
  const    Word fill9[195];
  volatile Word DMACTCR       ;
  volatile Word DMACITOP1     ;  
  volatile Word DMACITOP2     ;  
  volatile Word DMACITOP3     ;
  const    Word fill10[692];
  volatile Word DMACPeriphId0 ;
  volatile Word DMACPeriphId1 ;
  volatile Word DMACPeriphId2 ;
  volatile Word DMACPeriphId3 ;
  volatile Word DMACPCellId0  ;
  volatile Word DMACPCellId1  ;
  volatile Word DMACPCellId2  ;
  volatile Word DMACPCellId3  ;

} Dmac;
extern Dmac dmac;

// Peripheral ID
#define DMAC_ID_VALUE  0x00041081
#define DMAC_ID_MASK   0xFFFFFFFF

#endif // defined( DMAC_H )

// end of file dmac.h
