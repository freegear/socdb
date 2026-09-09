/***************************************************************************
 * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 * Copyright © ARM Limited 1998, 1999.  All rights reserved.
 ***************************************************************************/
/***************************************************************************

   This file contains the routines to enable & disable the intsrution & data
   caches and the write-back buffer.

****************************************************************************/


#include	"uhal.h"
#include	"mmu_h.h"

/* Enable all caching */
void uHALr_EnableCache(void)
{
int	mode = uHALir_ReadCacheMode() ;

	uHALir_WriteCacheMode(mode | (IC_ON + DC_ON + WB_ON)) ;
}

/* Enable instruction cache */
void uHALir_EnableICache(void)
{
int	mode = uHALir_ReadCacheMode() ;

        uHALir_WriteCacheMode(mode | IC_ON) ;
}

/* Enable data cache */
void uHALir_EnableDCache(void)
{
int	mode = uHALir_ReadCacheMode() ;

        uHALir_WriteCacheMode(mode | DC_ON) ;
}

/* Enable write buffer */
void uHALir_EnableWriteBuffer(void)
{
        int mode = uHALir_ReadCacheMode() ;

        uHALir_WriteCacheMode(mode | WB_ON) ;
}

/* Disable all caching */
void uHALr_DisableCache(void)
{
        uHALir_DisableICache() ;
	uHALir_DisableDCache() ;
	uHALir_DisableWriteBuffer() ;
}

