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
//  File Name           :exception.h,v
//  File Revision       :1.3
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Include file for exception handlers and vectors
//                        except IRQ and FIQ
//
//--========================================================================--


#ifndef EXCEPT_H
#define EXCEPT_H

extern void undefined_Handler(void);
extern void swi_Handler(void);
extern void prefetchAbort_Handler(void);
extern void dataAbort_Handler(void);

extern void undefined (void);
extern void prefetchAbort(void);

extern Word undefined_Addr;
extern Word swi_Addr;
extern Word prefetchAbort_Addr;
extern Word dataAbort_Addr;


#endif // defined( EXCEPT_H )

// end of file exception.h
