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
//  File Name           :extrom.c,v
//  File Revision       :1.8
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Declaration of Data areas for External Rom Test
//
//--========================================================================--

#include "memory.h"

volatile const Word ExtRom = TEST_VAL_1;
volatile const Word ExtRomArray[BURST_ARRAY_SIZE] = { BURST_VAL_7,
                                                      BURST_VAL_6,
                                                      BURST_VAL_5,
                                                      BURST_VAL_4,
                                                      BURST_VAL_3,
                                                      BURST_VAL_2,
                                                      BURST_VAL_1,
                                                      BURST_VAL_0   };

// end of file extrom.c