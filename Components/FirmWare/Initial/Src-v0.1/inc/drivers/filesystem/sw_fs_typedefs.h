#ifndef __TYPEDEFS_H__
#define	__TYPEDEFS_H__

#include <stdarg.h>

#define	false			(0)
#define	true			(1)

typedef int 			bool;

#if 0
#ifndef linux
typedef	int 			ssize_t;
typedef	unsigned int	mode_t;
#endif
#endif


#define MIN(x,y)   				(((x) < (y)) ? (x) : (y))
#define MAX(x,y)   				(((x) > (y)) ? (x) : (y))
#define MID(x,y,z) 				MAX((x), MIN((y), (z)))
#define ABS(x) (((x) >= 0) ? 	(x) : (-(x)))


#if defined(__arm)
__inline	void FSDBGPrintf(char *szFormat, ...) {}
__inline	void FSAssert(int assert) {}

#elif defined(WIN32)

__inline	void FSDBGPrintf(char *szFormat, ...) {}
__inline	void FSAssert(int assert) {}

#elif defined(linux)

inline	void FSDBGPrintf(char *szFormat, ...) {}
inline	void FSAssert(int assert) {}

#endif




#define MAX_STACK_CHECK()									
/*
		{													\
			extern int MinValue;							\
			int StackAddr;									\
			if(&StackAddr <= MinValue)						\
			{												\
				MinValue = &StackAddr;						\
			}												\
															\
			printf("end stack: 0x%08X - Min 0x%08X\n", &StackAddr, MinValue);	\
		}
*/
#endif
