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
//  File Name           :encache.c,v
//  File Revision       :1.4
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
// Purpose              : Cache Enable utility
//
// 
// Ref                  : ARM ARM "The System Control Coprocessor"
//
//--========================================================================--


// includes

#include "encache.h"

#include <stdio.h>

// Definitions for the Core Part Number contained in the ID register of the
// System Control Coprocessor

typedef enum 
{
  ARM92X = 0x9200,
  CORE_ID_MASK = 0x0000FF00,
  
  COREID_USE32BIT = 0x7FFFFFFF // forces compiler to use Word
} CoreID;

// Bit definitions for the System Control Coprocessor Control register

typedef enum 
{
  CTRL_L4 = 0x8000,
  CTRL_RR = 0x4000,
  CTRL_V  = 0x2000,
  CTRL_I  = 0x1000,         // Instruction cache enable/disable 
  CTRL_Z  = 0x0800,
  CTRL_F  = 0x0400,
  CTRL_R  = 0x0200,
  CTRL_S  = 0x0100,
  CTRL_B  = 0x0080,
  CTRL_L  = 0x0040,
  CTRL_D  = 0x0020,
  CTRL_P  = 0x0010,
  CTRL_W  = 0x0008,
  CTRL_C  = 0x0004,         // Data cache enable/disable
  CTRL_A  = 0x0002,
  CTRL_M  = 0x0001,         // MMU/MPU enable/disable

  CRM_USE32BIT = 0x7FFFFFFF // forces compiler to use Word
} ControlRegisterMask;


// Function prototypes
__inline void disableCache(Word caches);
__inline void enableCache(Word caches);
__inline void flushCache(Word caches);
__inline Word getCoreID(void);
__inline Boolean mmuEnabled(void);


//----------------------------------------------------------------------------
// As not all processor models allow access to the System Control 
// Coprocessor (CP15), two variants of each cache related function exist in 
// this file.
//
// One set of functions accesses CP15 to control the caches, the other set
// simply returns.
//
// The predefined value indicating the processor type (__TARGET_CPU_XXX) 
// determines which set of functions are compiled. 
//
// __TARGET_CPU_XXX is determined by the -cpu command line option.
//
//----------------------------------------------------------------------------
#ifdef __TARGET_CPU_ARM922T
#define USE_CACHE
#endif

#ifdef __TARGET_CPU_ARM920T
#define USE_CACHE
#endif


#ifdef  USE_CACHE

//----------------------------------------------------------------------------
// initCache() - determines the EASY core type and enables the appropriate
//               cache(s) if the MMU/PU is already enabled. 
//----------------------------------------------------------------------------

void initCache(void)
{
  switch (getCoreID())
  {
    case ARM92X:
    {
      // Only enable the cache(s) if the MMU/PU is enabled
      if (mmuEnabled())
      {
        flushCache(CTRL_I + CTRL_C);     // Instruction and Data caches used
        enableCache(CTRL_I + CTRL_C);
        printf("MMU and Cache Enabled\n\n");
      }
    }
    break;

    default:
    break;
  }
}


//----------------------------------------------------------------------------
// disableCache() - reads the System Control Coprocessor Control register,
//                  clears the requested cache enable bits and writes back
//                  to the Control Register
//----------------------------------------------------------------------------

__inline void disableCache(Word caches)
{
  Word ctrlReg; 

  // Read Control Register
  __asm { MRC p15, 0, ctrlReg, c1, c0, 0 }

  ctrlReg = (ctrlReg & ~caches);

  // Program  Control register
  __asm { MCR P15, 0, ctrlReg, c1, c0, 0 }

}


//----------------------------------------------------------------------------
// enableCache() - reads the System Control Coprocessor Control register,
//                 sets the requested cache enable bits and writes back
//                 to the Control Register
//----------------------------------------------------------------------------

__inline void enableCache(Word caches)
{
  Word ctrlReg; 

  // Read Control Register
  __asm { MRC p15, 0, ctrlReg, c1, c0, 0 }

  ctrlReg = (ctrlReg | caches);

  // Program  Control register
  __asm { MCR P15, 0, ctrlReg, c1, c0, 0 }

}

//----------------------------------------------------------------------------
// flushCache() - writes to the appropriate System Control Coprocessor 
//                register to flush the requested cache(s)
//----------------------------------------------------------------------------

__inline void flushCache(Word caches)
{
  Word dummy;

  switch (caches) 
  {
    case CTRL_C:
      __asm { MCR  p15, 0, dummy, c7, c6, 0 }
      break;

    case CTRL_I:
      __asm { MCR  p15, 0, dummy, c7, c5, 0 }
      break;

    case (CTRL_I + CTRL_C):
      __asm { MCR  p15, 0, dummy, c7, c7, 0 }
      break;

    default:
    break;
  }
}

//----------------------------------------------------------------------------
// getCoreID() - reads the System Control Coprocessor ID register and 
//               extracts the part number of the core
//----------------------------------------------------------------------------

__inline Word getCoreID(void)
{
  Word id;

  // read the system ID register
  __asm { MRC p15, 0, id, c0, c0, 0 }

  // mask the core part number  
  return (id & CORE_ID_MASK);
}

//----------------------------------------------------------------------------
// mmuEnabled() - reads the System Control Coprocessor Control register and 
//                determines whether the MMU/PU is enabled
//----------------------------------------------------------------------------

__inline Boolean mmuEnabled(void)
{
  Word controlReg;

  // read the system Control register
  __asm { MRC p15, 0, controlReg, c1, c0, 0 }

  // MMU/PU enabled if M bit is 1
  if (controlReg & CTRL_M)
  {
    return(TRUE);
  }
  else
  {
    return(FALSE);
  }
}

//----------------------------------------------------------------------------
// disableDCacheForRomTst() - determines the EASY core type and disables the 
//                            Data cache during the integration testing of the 
//                            ROM.
//
// NOTE: this function has been written to disable the Data cache in a 
//       specific senario. 
//
//       In this instance, only the read-only ROM is cached, so it is  
//       possible to disable and re-enable the Data cache without cleaning or 
//       invalidating it.
//
//       When creating a more generic function to disable
//       a cache, consideration must be given to cache coherency.
//       Cache coherency is achieved by cleaning and invalidating a cache.
//
//----------------------------------------------------------------------------

void disableDCacheForRomTst(void)
{
  switch (getCoreID())
  {
    case ARM92X:
    {
      // Only disable the cache if the MMU/PU is enabled
      if (mmuEnabled())
      {
        disableCache(CTRL_C);
      }
    }
    break;

    default:
    break;
  }
}

//----------------------------------------------------------------------------
// enableDCacheAfterRomTst() - determines the EASY core type and enables the 
//                             Data cache after the integration testing of the 
//                             ROM.
//
// NOTE: this function has been written to enable the Data cache in a 
//       specific senario. 
//
//       In this instance, only the read-only ROM is cached, so it is  
//       possible to disable and re-enable the Data cache without cleaning or 
//       invalidating it.
//
//       When creating a more generic function to disable
//       a cache, consideration must be given to cache coherency.
//       Cache coherency is achieved by cleaning and invalidating a cache.
//
//
//----------------------------------------------------------------------------

void enableDCacheAfterRomTst(void)
{
  switch (getCoreID())
  {
    case ARM92X:
    {
      // Only enable the cache if the MMU/PU is enabled
      if (mmuEnabled())
      {
        enableCache(CTRL_C);
      }
    }
    break;

    default:
    break;
  }
}

//----------------------------------------------------------------------------
// disableICacheForPauseTst() - determines the EASY core type and disables the 
//                              Instruction cache during the integration  
//                              testing of the timers/pause mode.
//
// NOTE: this function has been written to disable the Instruction cache in a 
//       specific senario. 
//
//       In this instance, only the read-only ROM is cached, so it is  
//       possible to disable and re-enable the Data cache without cleaning or 
//       invalidating it.
//
//       When creating a more generic function to disable
//       a cache, consideration must be given to cache coherency.
//       Cache coherency is achieved by cleaning and invalidating a cache.
//
//----------------------------------------------------------------------------

void disableICacheForPauseTst(void)
{
  switch (getCoreID())
  {
    case ARM92X:
    {
      // Only disable the cache if the MMU/PU is enabled
      if (mmuEnabled())
      {
        disableCache(CTRL_I);
      }
    }
    break;

    default:
    break;
  }
}

//----------------------------------------------------------------------------
// enableICacheAfterPauseTst() - determines the EASY core type and enables the 
//                              Instruction cache after the integration  
//                              testing of the timers/pause mode.
//
// NOTE: this function has been written to enable the instruction cache in a 
//       specific senario. 
//
//       In this instance, only the read-only ROM is cached, so it is  
//       possible to disable and re-enable the Instruction cache without  
//       cleaning or invalidating it.
//
//       When creating a more generic function to disable
//       a cache, consideration must be given to cache coherency.
//       Cache coherency is achieved by cleaning and invalidating a cache.
//
//----------------------------------------------------------------------------

void enableICacheAfterPauseTst(void)
{
  switch (getCoreID())
  {
    case ARM92X:
    {
      // Only enable the cache if the MMU/PU is enabled
      if (mmuEnabled())
      {
        enableCache(CTRL_I);
      }
    }
    break;

    default:
    break;
  }
}

#else  // #ifdef USE_CACHE

void initCache(void){}
__inline void disableCache(Word caches){}
__inline void enableCache(Word caches){}
__inline void flushCache(Word caches){}
__inline Word getCoreID(void){}
__inline Boolean mmuEnabled(void){}
void disableDCacheForRomTst(void){}
void enableDCacheAfterRomTst(void){}
void disableICacheForPauseTst(void){}
void enableICacheAfterPauseTst(void){}

#endif  // #ifdef USE_CACHE

// end of file encache.c
