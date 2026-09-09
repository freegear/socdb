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
//  File Name           :smc.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Smc registers
//
//--========================================================================--

#ifndef SMC_H
#define SMC_H

#include "globals.h"

typedef struct
{ 
  volatile Word SMBIDCYR0;       
  volatile Word SMBWST1R0;     
  volatile Word SMBWST2R0;     
  volatile Word SMBWSTOENR0;   
  volatile Word SMBWSTWENR0;   
  volatile Word SMBCR0;        
  volatile Word SMBSR0;        
  volatile Word SMBIDCYR1;     
  volatile Word SMBWST1R1;     
  volatile Word SMBWST2R1;     
  volatile Word SMBWSTOENR1;   
  volatile Word SMBWSTWENR1;   
  volatile Word SMBCR1;        
  volatile Word SMBSR1;        
  volatile Word SMBIDCYR2;     
  volatile Word SMBWST1R2;     
  volatile Word SMBWST2R2;     
  volatile Word SMBWSTOENR2;   
  volatile Word SMBWSTWENR2;   
  volatile Word SMBCR2;        
  volatile Word SMBSR2;        
  volatile Word SMBIDCYR3;     
  volatile Word SMBWST1R3;     
  volatile Word SMBWST2R3;     
  volatile Word SMBWSTOENR3;   
  volatile Word SMBWSTWENR3;   
  volatile Word SMBCR3;        
  volatile Word SMBSR3;        
  volatile Word SMBIDCYR4;     
  volatile Word SMBWST1R4;     
  volatile Word SMBWST2R4;     
  volatile Word SMBWSTOENR4;   
  volatile Word SMBWSTWENR4;   
  volatile Word SMBCR4;        
  volatile Word SMBSR4;        
  volatile Word SMBIDCYR5;     
  volatile Word SMBWST1R5;     
  volatile Word SMBWST2R5;     
  volatile Word SMBWSTOENR5;   
  volatile Word SMBWSTWENR5;   
  volatile Word SMBCR5;        
  volatile Word SMBSR5;        
  volatile Word SMBIDCYR6;     
  volatile Word SMBWST1R6;     
  volatile Word SMBWST2R6;     
  volatile Word SMBWSTOENR6;   
  volatile Word SMBWSTWENR6;   
  volatile Word SMBCR6;        
  volatile Word SMBSR6;        
  volatile Word SMBIDCYR7;     
  volatile Word SMBWST1R7;     
  volatile Word SMBWST2R7;     
  volatile Word SMBWSTOENR7;   
  volatile Word SMBWSTWENR7;   
  volatile Word SMBCR7;        
  volatile Word SMBSR7;        
  volatile Word SMBEWS;        

  volatile const fill[959]; 

  volatile const SMCPeriphID0; 
  volatile const SMCPeriphID1; 
  volatile const SMCPeriphID2; 
  volatile const SMCPeriphID3; 
                       
  volatile const SMCPCellID0;  
  volatile const SMCPCellID1;  
  volatile const SMCPCellID2;  
  volatile const SMCPCellID3;  
} Smc;          
extern Smc smc;

#define SMC_ID_MASK   0xFFFFFFFF
#define SMC_ID_VALUE  0x00041092

#endif // defined( SMC_H )

