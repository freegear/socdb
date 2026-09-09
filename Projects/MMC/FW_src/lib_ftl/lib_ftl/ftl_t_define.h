#ifndef _FTL_T_DEFINE_H_
#define	_FTL_T_DEFINE_H_

#include <assert.h>

//#define	SMT_ASSERT(e)		assert((e))
#define	SMT_ASSERT(e)
#define	SMT_NEVERGETHERE(e)	assert((e)&&0)
#define	SMT_FTL_DPRINTF		printf
/*
#define	SMT_TRUE			(1)
#define	SMT_FALSE			(0)
typedef unsigned int	smtUint32;	
typedef unsigned short	smtUint16;	
typedef unsigned char	smtUint8;	
typedef int				smtInt32;	
typedef short			smtInt16;	
typedef char			smtInt8;
typedef unsigned int	smtBoolean;
*/


#endif	//_FTL_T_DEFINE_H_