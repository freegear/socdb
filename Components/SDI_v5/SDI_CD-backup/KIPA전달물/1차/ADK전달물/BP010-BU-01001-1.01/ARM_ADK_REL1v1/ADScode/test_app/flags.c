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
//  File Name           :flags.c,v
//  File Revision       :1.7
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Flags that need to be uninitialised.
//                        Note: By default, the __main() function will zero
//                        all ZI regions.
//
//--========================================================================--


#include "globals.h"

// This flag is set or cleared by code in init.s
// before __main() is called
volatile TestStatus remapTestFlag;

// This is the top-level test status flag
// It must not be initialised by __main()
// so that its value is preserved after Watchdog Reset
TestStatus testStatus;

// end of file flags.c