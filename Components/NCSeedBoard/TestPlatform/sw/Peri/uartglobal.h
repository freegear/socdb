#ifndef UART_GLOBAL_H
#define UART_GLOBAL_H

typedef unsigned int UWORD32;
typedef int WORD32;
typedef unsigned char UBYTE8;

typedef enum { apERR_NONE = 0, apERR_UNSUPPORTED = 1 }  apError;

#define apERR_UART_START	0
#define PUBLIC	extern
#define PRIVATE	static
#define CONST	const
typedef unsigned int apOS_INT_oInterruptSource;
typedef unsigned int apOS_UART_oId;
typedef unsigned int apOS_System_eBaseAddress;

typedef enum { FALSE = 0, TRUE = 1 } BOOL;
typedef enum { apTEST_PASS = 0, apTEST_FAIL = 1 } apTEST_eResult;

#define apOS_UART_MAXIMUM 1
#define apOS_NO_STATIC_STATE	0

#define apSTATE_GET(x, y)	UART_sState
#define aRNULL	((void *)0)
#define aNULL	((void *)0)

//#define MAKE_BITMASK(pos, width) ((((unsigned)(0xFFFFFFFF<<(31-((pos)+(width)-1))))>>(31-((pos)+(width)-1)+(pos)))<<(pos))
#define MAKE_BITMASK(pos, width) ((((unsigned)(((signed)0xFFFFFFFF)<<(31-((pos)+(width)-1))))>>(31-((pos)+(width)-1)+(pos)))<<(pos))
#define apBIT_MASK(x) MAKE_BITMASK(bs##x, bw##x)
#define apBIT_GET(x, y) (((x) & apBIT_MASK(y))>>(bs##y))

#define apBIT_SET(x, y, z) ((x) = (((x) & ~apBIT_MASK(y)) | (((z)<<(bs##y)) & apBIT_MASK(y))))
#define apBIT_CLEAR(x, y) ((x) = ((x) & ~apBIT_MASK(y)))

#define IGNORE(x)	/* nothing */

#define apASSERT(x)	/* nothing */
#define apTEST_Print(x, y)	/* nothing */
#define apTEST_Report(x, y, z)	/* nothing */

#define apOS_ISR_InterruptDisable(x)	/* nothing */
#define apOS_INT_InterruptClear(x)		/* nothing */
#define apOS_ISR_InterruptEnable(x)		/* nothing */
#define apOS_INT_InstanceGet()		0
#define apOS_INT_SourceGet()		0

#define apBIND_ALL_INTERRUPTS(x, y) \
	do { \
		extern void UARTISRConnect(void (*)(void));	\
		UARTISRConnect(y);		\
	} while(0)

#define UART_TEST_DEBUG	0
// At address 0x01ff8a04, there is GPIO_DAT1.
// I don't want to include sysreg.h here
#if UART_TEST_DEBUG
#define UART_TEST_PROGRESS_CHECK()	\
	do { \
		extern unsigned UARTProgressCount;	\
		*((volatile unsigned *)(0x01ff8a04)) = UARTProgressCount++;	\
	} while(0)

#define UART_TEST_PROGRESS_CHECK2(x)					\
	do { 												\
		unsigned temp;									\
		temp = *((volatile unsigned *)(0x01ff8a04));	\
		*((volatile unsigned *)(0x01ff8a04)) = x;		\
		*((volatile unsigned *)(0x01ff8a04)) = temp;	\
	} while(0)
#else
#define UART_TEST_PROGRESS_CHECK()	/* nothing */
#define UART_TEST_PROGRESS_CHECK2(x)	/* nothing */
#endif

#define	UART_CLOCK_DIVIDER	1	/* 1, 2, 4, 8 allowed */
#define UCLKDIV_VALUE	\
	((UART_CLOCK_DIVIDER == 1) ? 0x0 :	\
	((UART_CLOCK_DIVIDER == 2) ? 0x1 : \
	((UART_CLOCK_DIVIDER == 4) ? 0x2 : \
	0x3)))
#endif
