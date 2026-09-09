///////////////////////////////////////////////////////////////////
// This header file includes type definition used in other files
// This header file should be included in all c files
///////////////////////////////////////////////////////////////////

// This Definition Is Used To Select Test Type
#ifndef __MOON_TYPE_H__
#define __MOON_TYPE_H__

//#define		STATION_A				0

#define		UINT		unsigned int
#define		USHORT		unsigned short
#define		UCHAR		unsigned char
#define		uint		unsigned int
#define		ushort		unsigned short
#define		uchar		unsigned char

#define		PUINT		unsigned int *
#define		PUSHORT		unsigned short *
#define		PUCHAR		unsigned char *
#define		puint		unsigned int *
#define		pushort		unsigned short *
#define		puchar		unsigned char *

#define		EXTERN_INTR3	0x0c
#define		EXTREN_INTR2	0x0b
#define		EXTERN_INTR1	0x0a
#define		MOON_INTR		0x09
#define		RTC_INTR		0x08
#define		TIMER_INTR2		0x07
#define		TIMER_INTR1		0x06
#define		TIMER_INTR0		0x05
#define		MOUSE_INTR		0x04
#define		KBD_INTR		0x03
#define		UART_INTR1		0x02
#define		UART_INTR0		0x01
#define		SOFT_INTR		0x00

typedef	uint(*PrFunc)	(unsigned int);

#endif