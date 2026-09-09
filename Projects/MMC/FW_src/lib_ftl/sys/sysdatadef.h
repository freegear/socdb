/*----------------------------------------------------------
    File Name   : sysdatadef.h
    Description : Data type definition 
-----------------------------------------------------------*/

#ifndef	__DEF_H__
#define	__DEF_H__

typedef float				smtFloat;


#ifdef WIN32
typedef unsigned long		smtUint32;
typedef unsigned short		smtUint16;
typedef unsigned char		smtUint8;

typedef long				smtInt32;
typedef short				smtInt16;		
typedef char				smtInt8;

typedef int					smtStatus;
typedef unsigned char		bit;

#else

typedef unsigned int		smtUint32;
typedef unsigned short		smtUint16;
typedef unsigned char		smtUint8;

typedef int					smtInt32;
typedef	short				smtInt16;
typedef char				smtInt8;

typedef long				smtStatus;
typedef bit					smtBit;		// Only data type for internal RAM bit accessable area (Just 16Bytes)

#endif



typedef unsigned char		smtBoolean;


#ifndef false
#define	false	0
#endif

#ifndef true
#define	true	1
#endif

#endif /* __DEF_H__ */
