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
//  File Name           :default_handler.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Include file for default exception handler
//
//--========================================================================--


#ifndef DF_HAND_H
#define DF_HAND_H

#include "globals.h"

extern void default_reset_Handler(void);
extern void default_undefined_Handler(void);
extern void default_swi_Handler(void);
extern void default_prefetchAbort_Handler(void);
extern void default_dataAbort_Handler(void);
extern void default_irq_Handler(void);
extern void default_fiq_Handler(void);

#endif // defined( DF_HAND_H )

// end of file default_handler.h
