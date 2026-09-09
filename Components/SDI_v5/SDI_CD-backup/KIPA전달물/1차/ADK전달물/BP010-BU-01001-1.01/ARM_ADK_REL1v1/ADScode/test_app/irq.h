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
//  File Name           :irq.h,v
//  File Revision       :1.3
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Include file for irq vector and handler
//
//--========================================================================--


#ifndef IRQ_H
#define IRQ_H

#include "globals.h"

extern void __irq irq_Handler(void);

extern Word irq_Addr;


#endif // defined( IRQ_H )

// end of file irq.h
