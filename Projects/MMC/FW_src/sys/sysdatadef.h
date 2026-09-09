/*----------------------------------------------------------
    File Name   : sysdatadef.h
    Description : Data type definition 
-----------------------------------------------------------*/

#ifndef	__DEF_H__
#define	__DEF_H__

typedef float				smtFloat;

typedef unsigned long		smtUint32;
typedef unsigned int		smtUint16;
typedef unsigned char		smtUint8;

typedef long				smtInt32;
typedef int				smtInt16;		
typedef char				smtInt8;

typedef bit				smtBit;		// Only data type for internal RAM bit accessable area (Just 16Bytes)

typedef long				smtStatus;
typedef unsigned char		smtBoolean;


#ifndef false
#define	false	0
#endif

#ifndef true
#define	true	1
#endif

#endif /* __DEF_H__ */
