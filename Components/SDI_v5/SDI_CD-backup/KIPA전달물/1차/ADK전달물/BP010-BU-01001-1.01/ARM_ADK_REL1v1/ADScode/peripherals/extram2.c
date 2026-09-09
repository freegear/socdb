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
//  File Name           :extram2.c,v
//  File Revision       :1.7
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Declaration of Data areas for External Ram2 Test
//
//--========================================================================--

#include "memory.h"

MemUnion ExtRam2;
Word ExtRam2Array[BURST_ARRAY_SIZE];

// end of file extram2.c