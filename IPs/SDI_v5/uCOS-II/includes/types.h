#ifndef _TYPES_H_4782374832742374327423
#define _TYPES_H_4782374832742374327423

// MicroC/OS core가 있는 경우는 주석처리하고, 없는 경우는 주석을 푼다.
// MicroC/OS core가 없는 경우는 #include "../arch/os_cpu.h" 주석처리한다.
//#include "os_cpu.h"
/*
typedef unsigned long	ulong;
typedef unsigned short	ushort;
typedef unsigned char	uchar;
typedef unsigned int	uint;
*/

#ifndef __cplusplus
typedef int			bool;
#define	true			1
#define false			0
#endif

// print in hex value.
// type= 8 : print in format "ff".
// type=16 : print in format "ffff".
// type=32 : print in format "ffffffff".
typedef enum {
	VAR_LONG=32,
	VAR_SHORT=16,
	VAR_CHAR=8
} VAR_TYPE;

#ifndef NULL
#define NULL (void *)0
#endif

typedef char *va_list;
#define va_start(ap, p)		(ap = (char *) (&(p)+1))
#define va_arg(ap, type)	((type *) (ap += sizeof(type)))[-1]
#define va_end(ap)

#endif		// end _TYPES_H_4782374832742374327423.
