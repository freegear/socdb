/***************************************************************************
   Copyright © Intel Corporation, March 18th 1998.  All rights reserved.
   Copyright ARM Limited 1998 - 2000.  All rights reserved.
****************************************************************************
  								      
   Defines, Structures, Routines used & defined in the uHAL library
  
  	$Id: uhal.h,v 1.35.2.3 2000/02/02 12:56:56 mquinn Exp $
  
****************************************************************************/

#ifndef __uhal_h                /* Only include stuff once */
#define __uhal_h

#ifndef __cdefs_h               /* uHAL 'C' type definitions */
#include "cdefs.h"
#endif

#ifndef __address_map_h         /* platform specific stuff (address maps etc) */
#include "platform.h"
#endif

#ifndef __bits_h
#include "bits.h"
#endif

#ifndef __sizes_h
#include "sizes.h"
#endif

/* The current version of uHAL */
#define uHAL_VERSION_STRING "uHAL v1.1"

/* These defines are in a common coding practices header file */
#ifndef	ERROR
#define ERROR		-1               /* -MAX_INT would be better?? (or errno.h) */
#endif
#ifndef	OK
#define OK		0                   /* Can never work out should this be 1 or 0? */
#endif
#ifndef	FALSE
#define FALSE		0
#endif
#ifndef	TRUE
#define TRUE		1
#endif
#ifndef	NULL
#define	NULL	0
#endif

/* General ERROR/SUCCESSFUL returns */
#define MSG_FAILURE                -1
#define MSG_SUCCESS                 0

#define	RESETV		0
#define	UNDV		1
#define	SWIV		2
#define	IABTV		3
#define	DABTV		4
#define	IRQV		6
#define	FIQV		7

/* A function with no argument returning pointer to a void function */
typedef void (*PrVoid) (void);
typedef void (*PrHandler) (unsigned int);  /* As PrVoid with one parameter */

/* A function with no argument returning PrVoid */
typedef PrVoid(*PrPrVoid) (void);

struct uHALis_IRQ
{
    PrHandler handler;          /* Routine for specific interrupt */
    unsigned int flags;
    unsigned int mask;
    const U8 *name;             /* Debug, owner id */
    struct uHALis_IRQ *next;    /* Handy for shared interrupts */
};


/* Enum to describe timer: free, one-shot, on-going interval or locked-out */
enum uHALe_TimerState
{
    T_FREE, T_ONESHOT, T_INTERVAL, T_LOCKED
};

struct uHALis_Timer
{
    unsigned int irq;           /* IRQ number */
    enum uHALe_TimerState state;
    unsigned int period;        /* Period between triggers */
    PrHandler handler;          /* User Routine */
    const U8 *name;             /* Debug, owner id */
    struct uHALis_Timer *next;
    PrHandler ClearInterruptRtn;
    int hw_interval:1;          /* HW does not need restarting for interval timers */
};

typedef struct
{
    unsigned int memSize;
    unsigned int memType;
    unsigned int cpuId;
    unsigned int platformId;
    unsigned char res[4];
}
infoType, *pInfoType;

/* ****************************************************************
 * Function declarations 
 * ****************************************************************/
/* defined in support.s */
extern void *uHALr_StartOfRam(void);
extern void *uHALr_StartOfFreeRam(void);
extern void *uHALr_EndOfFreeRam(void);
extern void *uHALr_EndOfRam(void);
extern int uHALr_SizeOfFreeRam(void);

/* defined in boot.s */
extern void uHALir_TrapSWI(void);
extern void uHALr_InitBSSMemory(void);

/* defined in external.s */
extern void *lib_support_malloc(unsigned int);
extern int lib_support_free(void *);
extern int lib_support_printf(char *,...);
extern int lib_support_getchar(void);
extern int lib_support_putchar(char);
extern void lib_flush_buffer( void );

/* defined in irq.c */
extern void uHALr_InitInterrupts(void);
extern int uHALr_RequestInterrupt(unsigned int, PrHandler, const unsigned char *);
extern int uHALr_FreeInterrupt(unsigned int);
extern void uHALr_EnableInterrupt(unsigned int);
extern void uHALr_DisableInterrupt(unsigned int);

extern void uHALir_DefineIRQ(PrVoid, PrPrVoid, PrVoid);
extern void uHALir_DispatchIRQ(unsigned int flags);
extern void uHALir_UnexpectedIRQ(unsigned int);


/* defined in <blah>/board.c */
extern int uHALr_WriteLED(unsigned int, unsigned int);
extern void uHALir_MaskIrq(unsigned int irq);
extern void uHALir_UnmaskIrq(unsigned int irq);
extern void uHALr_GetPlatformInfo(pInfoType p);
extern void uHALir_PlatformDisableTimer(unsigned int timer);
extern void uHALir_PlatformEnableTimer(unsigned int timer);
extern void uHALir_PlatformInit(void);

/* defined in <blah>/driver.s */
extern void *uHALir_InitTargetMem(void *);
extern void uHALir_SetLEDs(unsigned int value);

/* defined in irqtrap.s */
extern void uHALir_TrapIRQ(void);

/* defined in control.s */
extern void uHALir_CpuControlWrite(unsigned int);
extern unsigned int uHALir_CpuControlRead(void);
extern unsigned int uHALir_CpuIdRead(void);

/* defined in irqlib.s */
extern unsigned int uHALir_NewVector(PrVoid, PrHandler);
extern PrVoid uHALir_NewIRQ(PrHandler, PrVoid);
extern void uHALir_DisableInt(void);
extern void uHALir_EnableInt(void);
extern unsigned int uHALir_DoSWI(unsigned int, unsigned int);

/* defined in cpumode.s */
extern unsigned int uHALir_EnterSvcMode(void);
extern unsigned int uHALir_EnterLockedSvcMode(void);
extern void uHALir_ExitSvcMode(unsigned int spsr);
extern unsigned int uHALir_ReadMode(void);
extern void uHALir_WriteMode(unsigned int);


/* defined in crt.c */
extern void uHALr_printf(char *,...);  /* Variable args */
extern void uHALr_LibraryInit(void);


extern void *uHALr_memset(char *s, int c, int n);
extern void *uHALr_memcpy(char *s, char *ct, int n);
extern int uHALr_memcmp(char *cs, char *ct, int n);
extern int uHALr_strlen(const char *s);

/* defined in led.c */
extern void uHALr_SetLED(unsigned int);
extern void uHALr_ResetLED(unsigned int);
extern int uHALr_ReadLED(unsigned int);
extern unsigned int uHALr_CountLEDs(void);
extern unsigned int uHALr_InitLEDs(void);

/* defined in timer.c */
extern void uHALr_InitTimers(void);
extern int uHALr_RequestTimer(PrHandler, const unsigned char *);
extern void uHALr_InstallTimer(unsigned int);
extern int uHALr_RequestSystemTimer(PrHandler, const unsigned char *);
extern void uHALr_EnableTimer(unsigned int);
extern int uHALr_FreeTimer(unsigned int);
extern void uHALir_TimeHandler(unsigned int intNum);

extern int uHALr_GetTimerState(unsigned int);
extern int uHALr_SetTimerState(unsigned int, enum uHALe_TimerState);
extern int uHALr_GetTimerInterval(unsigned int);
extern int uHALr_SetTimerInterval(unsigned int, unsigned int);

extern unsigned int uHALir_GetSystemTimer(void);
extern unsigned int uHALir_CountTimers(void);
extern void uHALir_DisableTimer(unsigned int);
extern int uHALir_GetTimerInterrupt(unsigned int);

#define uHALr_CountTimers()	uHALir_CountTimers()

/* defined in heap.c */
#if uHAL_HEAP != 0
extern void uHALr_InitHeap(void);
extern void *uHALr_malloc(unsigned int);
extern void uHALr_free(void *);

#endif
extern int uHALr_HeapAvailable(void);

/* Aliases for direct system access */
#define uHALr_InstallSystemTimer()	uHALr_InstallTimer(OS_TIMER)
#define uHALir_GetSystemTimerState()	uHALr_GetTimerState(OS_TIMER)
#define uHALir_SetSystemTimerState(state) uHALr_SetTimerState(OS_TIMER, state)
#define uHALir_GetSystemTimerInterval()	uHALr_GetTimerInterval(OS_TIMER)
#define uHALir_SetSystemTimerInterval(time) uHALr_SetTimerInterval(OS_TIMER, time)
#define uHALir_GetSystemTimerInterrupt() uHALir_GetTimerInterrupt(OS_TIMER)
#define uHALir_EnableSystemTimer()	uHALr_EnableTimer(OS_TIMER)

/* defined in iolib.c */
extern void outb(unsigned char b, void *p);
extern unsigned int inb(void *p);
extern void outw(unsigned short w, void *p);
extern unsigned int inw(void *p);
extern void outl(unsigned int l, void *p);
extern unsigned int inl(void *p);

extern void uHALir_FloatInit( void );
extern void uHALr_putchar(char);
extern int uHALr_getchar(void);
extern int uHALr_CharAvailable(void);
extern void PutString(char *);
extern void uHALir_InitSerial(unsigned int port, unsigned int baudRate);

#define uHALr_ResetPort()	uHALir_InitSerial(OS_COMPORT, DEFAULT_OS_BAUD)

/* defined in cache.c */
extern void uHALr_EnableCache(void);
extern void uHALr_DisableCache(void);

extern void uHALir_EnableICache(void);
extern void uHALir_EnableDCache(void);
extern void uHALir_EnableWriteBuffer(void);

/* defined in mmu.s */
extern void uHALr_InitMMU(int mode);
extern void uHALr_ResetMMU(void);

extern int uHALir_MMUSupported(void);
extern int uHALir_MPUSupported(void);
extern int uHALir_CacheSupported(void);
extern int uHALir_CheckUnifiedCache(void);

extern void uHALir_WriteCacheMode(unsigned int);
extern unsigned int uHALir_ReadCacheMode(void);

extern void uHALir_DisableICache(void);
extern void uHALir_DisableDCache(void);
extern void uHALir_DisableWriteBuffer(void);

/* PCI routines */
/* ...this one's platform/host specific (board.c) */
extern unsigned int uHALr_PCIHost(void);

#if uHAL_PCI != 0
/* board specific interrupt mapping code */
extern U8 uHALir_PCIMapInterrupt(U8 pin, U8 slot);

/* PCI configuration space access routines */
extern U8 uHALr_PCICfgRead8(U32 bus, U32 device, U32 function, U32 offset);
extern U16 uHALr_PCICfgRead16(U32 bus, U32 device, U32 function, U32 offset);
extern U32 uHALr_PCICfgRead32(U32 bus, U32 device, U32 function, U32 offset);
extern void uHALr_PCICfgWrite8(U32 bus, U32 device, U32 function, U32 offset, U32 data);
extern void uHALr_PCICfgWrite16(U32 bus, U32 device, U32 function, U32 offset, U32 data);
extern void uHALr_PCICfgWrite32(U32 bus, U32 device, U32 function, U32 offset, U32 data);

/* pci I/O space access macros */
#define uHALr_PCIIORead32(offset)    *(volatile U32 *)(_MapIOAddress(offset))
#define uHALr_PCIIORead16(offset)    *(volatile U16 *)(_MapIOAddress(offset))
#define uHALr_PCIIORead8(offset)     *(volatile U8 *)(_MapIOAddress(offset))
#define uHALr_PCIIOWrite32(offset,data)    *(volatile U32 *)(_MapIOAddress(offset)) = (data)
#define uHALr_PCIIOWrite16(offset,data)    *(volatile U16 *)(_MapIOAddress(offset)) = (data)
#define uHALr_PCIIOWrite8(offset,data)     *(volatile U8 *)(_MapIOAddress(offset)) = (data)

/* pci memory space access macros */
#define uHALr_PCIMemRead32(offset)    *(volatile U32 *)(_MapMemAddress(offset))
#define uHALr_PCIMemRead16(offset)    *(volatile U16 *)(_MapMemAddress(offset))
#define uHALr_PCIMemRead8(offset)     *(volatile U8 *)(_MapMemAddress(offset))
#define uHALr_PCIMemWrite32(offset,data)    *(volatile U32 *)(_MapMemAddress(offset)) = (data)
#define uHALr_PCIMemWrite16(offset,data)    *(volatile U16 *)(_MapMemAddress(offset)) = (data)
#define uHALr_PCIMemWrite8(offset,data)     *(volatile U8 *)(_MapMemAddress(offset)) = (data)

#else
/* no PCI on this system, just null out the routines */
#define uHALir_PCIMapInterrupt(pin, slot) ;

#define uHALr_PCICfgRead8(bus, device, function, offset) ;
#define uHALr_PCICfgRead16(bus, device, function, offset) ;
#define uHALr_PCICfgRead32(bus, device, function, offset) ;
#define uHALr_PCICfgWrite8(bus,device,function,offset,data)  ;
#define uHALr_PCICfgWrite16(bus,device,function,offset,data)  ;
#define uHALr_PCICfgWrite32(bus,device,function,offset,data)  ;

#define uHALr_PCIIORead32(offset)    (0)
#define uHALr_PCIIORead16(offset)    (0)
#define uHALr_PCIIORead8(offset)     (0)
#define uHALr_PCIIOWrite32(offset,data)    ;
#define uHALr_PCIIOWrite16(offset,data)    ;
#define uHALr_PCIIOWrite8(offset,data)     ;

#define uHALr_PCIMemRead32(offset)    (0)
#define uHALr_PCIMemRead16(offset)    (0)
#define uHALr_PCIMemRead8(offset)     (0)
#define uHALr_PCIMemWrite32(offset,data)    ;
#define uHALr_PCIMemWrite16(offset,data)    ;
#define uHALr_PCIMemWrite8(offset,data)     ;

#endif /* uHAL_PCI */

#endif /* __uhal_h define if */
