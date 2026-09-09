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
//  File Name           :fiq.h,v
//  File Revision       :1.3
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Include file for fiq vector and handler
//
//--========================================================================--


#ifndef FIQ_H
#define FIQ_H

#include "globals.h"

extern void __irq fiq_Handler(void);

extern Word fiq_Addr;


#endif // defined( FIQ_H )

// end of file fiq.h
