//----------------------------------------------------------------------------
// This confidential and proprietary software may be used only as             
// authorised by a licensing agreement from ARM Limited                       
//   (C) COPYRIGHT 2001 ARM Limited                                           
//       ALL RIGHTS RESERVED                                                  
// The entire notice above must be reproduced on all authorised               
// copies and copies may only be made to the extent permitted                 
// by a licensing agreement from ARM Limited.                                 
//                                                                            
//----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           :testutils.h,v
//  File Revision       :1.6
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
// Purpose           : Header file for testutils.c                            
//                     Contains extern function prototypes that may be        
//                     included by other modules                              
//                                                                            
//----------------------------------------------------------------------------

#ifndef TESTUTILS_H
#define TESTUTILS_H

#include "globals.h"

// Locations of the Primecell identifier registers

#define TEST_PCELL_ID 0xFF0       //primecell id register at this address
#define TEST_PER_ID   0xFE0       //peripheral id register at this address
#define TEST_IS_PCELL 0xB105F00D  //device is a primecell
//#define TEST_IS_PCELL 0xb105f00d  //device is a primecell


// function predefinitions

extern Word installHandler ( Word routine, Word *vector );
extern TestStatus testPeriphID( Word *, Word, Word );
extern TestStatus testPcellID( Word * );

#endif // defined( TESTUTILS_H )

// end of file testutils.h
