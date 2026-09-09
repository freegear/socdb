/***************************************************************************
 * Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
 * Copyright © ARM Limited 1998.  All rights reserved.
 ***************************************************************************/
/*****************************************************************************

  Define 'C' types used in uHAL library.

******************************************************************************/

#ifndef __cdefs_h	/* Only include stuff once */
#define __cdefs_h

#define U8    unsigned char
#define PU8   unsigned char *
#define U16   unsigned short
#define PU16  unsigned short *
#define S8    short
#define PS8   short *
#define U32   unsigned int
#define PU32  unsigned int *
#define S32   int 
#define PS32  int *

#if 0
typedef unsigned char   U8,  *PU8;
typedef unsigned short  U16, *PU16;
typedef char            S8,  *PS8;
typedef short           S16, *PS16;

typedef unsigned int    U32, *PU32;
typedef int             S32, *PS32;
#endif

#define PPB_VERBOSE 1                   /* this determines printing */

#endif
 

