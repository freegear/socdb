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
//  File Name           :memory_tst.h,v
//  File Revision       :1.8
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose           : public funtion prototypes from memory_tst.c
//
//--========================================================================--

#ifndef MEMORY_TST_H
#define MEMORY_TST_H

#include "globals.h"

// Function prototypes
extern TestStatus testMemory( void );

// Extern function from burst.s
extern void BurstCopy8 (volatile const Word *from, Word *to);

#endif // defined( MEMORY_TST_H )

// end of file memory_tst.h