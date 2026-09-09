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
//  File Name           :pause.c,v
//  File Revision       :1.3
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose:            Enters pause mode
//
//--========================================================================--

#include "rempause.h"
#include "pause.h"
#include "encache.h"

//----------------------------------------------------------------------------
// enterPauseMode ()
//
// Set pauseFlag then halt processor by writing to the remap pause controller.
// 
// The ARM processor is halted by preventing it from fetching further 
// instructions from the bus, until an interrupt occurs.
// (An IRQ service routine should clear pauseFlag on exit from pause)
//
// In a cached core, there can already be instructions in the cache which may
// not need bus accesses in oder to execute. Thus to ensure that execution
// really does stop, the Instruction cache is disabled prior to entering 
// pause mode and re-enabled once out of pause mode.
//
//
// Assumptions:  
// This code is an example and isn't robust enough for a real system. 
// Consider what would happen if an interrupt occurred between setting
// pauseFlag and programming the pause register.
// Consideration of the FIQ interrupt, if enabled, is also required.
//----------------------------------------------------------------------------
void enterPauseMode(void)
{
  // set flag to indicate pause mode
  pauseFlag = TRUE;

  // could have problems if an interrupt occurred here

  // Disable the Instruction cache to ensure that execution does not
  // continue from cache after pause mode entered 
  disableICacheForPauseTst();

  // halt the processor
  remPause.Pause = RPCPauseHALT;

  // Re-enable the Instruction cache
  enableICacheAfterPauseTst();
  
}  

// end of file pause.c  