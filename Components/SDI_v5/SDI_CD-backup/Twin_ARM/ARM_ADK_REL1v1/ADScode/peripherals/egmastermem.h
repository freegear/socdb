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
//  File Name           :egmastermem.h,v
//  File Revision       :1.1
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Definitions for tests on Example AHB Master and 
//                        File Reader
//  
//--========================================================================--

#ifndef EGM_H
#define EGM_H

#include "globals.h"

#define EGMASTER_ARRAY_SIZE 4

typedef volatile Word EgMasterInMem[EGMASTER_ARRAY_SIZE];
typedef volatile Byte EgMasterOutMem;

extern EgMasterInMem egMasterInMem;
extern EgMasterOutMem egMasterOutMem;

#endif // defined( EGM_H )

// end of file ehmastermem.h
