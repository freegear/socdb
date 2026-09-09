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
//  Purpose             : MPMC registers
//
//--========================================================================--


#ifndef MPMC_H
#define MPMC_H

#include "globals.h"

typedef struct
{ 
 volatile Word MPMCControl;   
 volatile Word MPMCStatus;    
 volatile Word MPMCConfig;    

 const Word fill0[5];         

 volatile Word MPMCDyCntl;    
 volatile Word MPMCDyRef;     
 volatile Word MPMCDyRdCfg;   

 const Word fill1;            

 volatile Word MPMCDytRP;     
 volatile Word MPMCDytRAS;    
 volatile Word MPMCDytSREX;   
 volatile Word MPMCDytAPR;    
 volatile Word MPMCDytDAL;    
 volatile Word MPMCDytWR;     
 volatile Word MPMCDytRC;     
 volatile Word MPMCDytRFC;    
 volatile Word MPMCDytXSR;    
 volatile Word MPMCDytRRD;    
 volatile Word MPMCDytMRD;    

 const Word fill2[9];         

 volatile Word MPMCStExdWt;   

 const Word fill3[31];        
 
 volatile Word MPMCDyConfig0; 
 volatile Word MPMCDyRasCas0; 

 const Word fill4[6];         

 volatile Word MPMCDyConfig1; 
 volatile Word MPMCDyRasCas1; 

 const Word fill5[6];         

 volatile Word MPMCDyConfig2; 
 volatile Word MPMCDyRasCas2; 

 const Word fill6[6];         

 volatile Word MPMCDyConfig3; 
 volatile Word MPMCDyRasCas3; 

 const Word fill7[38];        

 volatile Word MPMCStConfig0; 
 volatile Word MPMCStWtWen0;  
 volatile Word MPMCStWtOen0;  
 volatile Word MPMCStWtRd0;   
 volatile Word MPMCStWtPg0;   
 volatile Word MPMCStWtWr0;   
 volatile Word MPMCStWtTurn0; 

 const Word fill8;            

 volatile Word MPMCStConfig1; 
 volatile Word MPMCStWtWen1;  
 volatile Word MPMCStWtOen1;  
 volatile Word MPMCStWtRd1;   
 volatile Word MPMCStWtPg1;   
 volatile Word MPMCStWtWr1;   
 volatile Word MPMCStWtTurn1; 

 const Word fill9;            

 volatile Word MPMCStConfig2; 
 volatile Word MPMCStWtWen2;  
 volatile Word MPMCStWtOen2;  
 volatile Word MPMCStWtRd2;   
 volatile Word MPMCStWtPg2;   
 volatile Word MPMCStWtWr2;   
 volatile Word MPMCStWtTurn2; 

 const Word fill10;           

 volatile Word MPMCStConfig3; 
 volatile Word MPMCStWtWen3;  
 volatile Word MPMCStWtOen3;  
 volatile Word MPMCStWtRd3;   
 volatile Word MPMCStWtPg3;   
 volatile Word MPMCStWtWr3;   
 volatile Word MPMCStWtTurn3; 

 const Word fill11[801];      

 volatile Word MPMCITCR;      

 const Word fill12[7];        

 volatile Word MPMCITIP;      

 const Word fill13[7];        

 volatile Word MPMCITOP;      

 const Word fill14[35];       

 volatile Word MPMCPeriphId4; 
 volatile Word MPMCPeriphId5; 
 volatile Word MPMCPeriphId6; 
 volatile Word MPMCPeriphId7; 
 volatile Word MPMCPeriphId0; 
 volatile Word MPMCPeriphId1; 
 volatile Word MPMCPeriphId2; 
 volatile Word MPMCPeriphId3; 

 volatile Word MPMCPCellId0;  
 volatile Word MPMCPCellId1;  
 volatile Word MPMCPCellId2;  
 volatile Word MPMCPCellId3;  
 }  Mpmc;

extern Mpmc mpmc;

// Peripheral ID

#endif // defined( MPMC_H )

// end of file mpmc.h
