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
//  File Name           :heap.c,v
//  File Revision       :1.1
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Address of bottom of heap
//
//--========================================================================--

#include "globals.h"

// The heap will grow up from this location
// The available length of the heap is determined by the amount of 
// memory space allocated in the scatterfile


Word startOfHeap;

// end of file heap.c
