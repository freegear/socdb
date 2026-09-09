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
//  File Name           :reset_tst.h,v
//  File Revision       :1.4
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose           : public funtion prototypes from reset_tst.c
//
//--========================================================================--

#ifndef RESET_TST_H
#define RESET_TST_H

#include "globals.h"

// function prototypes
extern TestStatus testRemPause( void );
//extern Boolean powerOnReset( void );
extern TestStatus testPowerOnReset( void );

#endif // defined( RESET_TST_H )

// end of file reset_tst.h