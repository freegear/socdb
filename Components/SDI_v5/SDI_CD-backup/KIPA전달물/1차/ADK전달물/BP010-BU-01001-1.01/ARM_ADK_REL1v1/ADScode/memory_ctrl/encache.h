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
//  File Name           :encache.h,v
//  File Revision       :1.3
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : public funtion prototypes from encache.c 
//
//--========================================================================--


#ifndef ENCACHE_H
#define ENCACHE_H

#include "globals.h"

extern void initCache(void);
extern void disableDCacheForRomTst(void);
extern void enableDCacheAfterRomTst(void);
extern void disableICacheForPauseTst(void);
extern void enableICacheAfterPauseTst(void);

#endif // defined( ENCACHE_H )

// end of file encache.h
