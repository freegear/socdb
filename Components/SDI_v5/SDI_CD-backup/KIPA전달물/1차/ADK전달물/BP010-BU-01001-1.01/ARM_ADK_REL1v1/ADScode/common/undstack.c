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
//  File Name           :undstack.c,v
//  File Revision       :1.3
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Address of top of UND stack
//
//--========================================================================--

#include "globals.h"

// The stack will grow down from this location
// The available length of the stack is determined by the amount of 
// memory space allocated in the scatterfile

Word topOfUndStack;

// end of file undstack.c
