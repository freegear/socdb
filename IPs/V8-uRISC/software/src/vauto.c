// vauto.c

#include "vauto.h"
#include "uart.h"

// The following hard-coded locations MUST be editted
// if your memory map is not the vautomation default.
// To find all such locations in the c source code, grep for '@'.

volatile BYTE	CONTROL_REG			@0x0202;

volatile WORD	Interrupt0			@0x0400;	// interupt vector 0
volatile WORD	Interrupt1			@0x0402;	// interupt vector 1
volatile WORD	Interrupt2			@0x0404;	// interupt vector 2
volatile WORD	Interrupt3			@0x0406;	// interupt vector 3
volatile WORD	Interrupt4			@0x0408;	// interupt vector 4
volatile WORD	Interrupt5			@0x040a;	// interupt vector 5
volatile WORD	Interrupt6			@0x040c;	// interupt vector 6
volatile WORD	Interrupt7			@0x040e;	// interupt vector 7

BYTE stack @0x300; // put a label at the base of the stack

WORD	start;

BYTE shift[8] = {0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80};

// various helper functions

void DOWNLOAD()
{
#if 0
{
	int		i=0;
	char	c;
	
	while (UartCharWaiting())
		{
		i++;
		c = UartReadChar();
		}

	putws(i);
}
#endif

	puts("Ready to download\r\n");
	putFlush();
	

	asm("stp 3");	// turn off interrupts
	CONTROL_REG = 0;
{
//	int i;
//	for (i=0; i<10000; i++)
		*(PBYTE)&uartStatus = 0;	// disable uart interrupts
}

#asm
	jmp 0x0088	; Jump to the ROM download routine.
#endasm
	// note that we never come back here as we are probably
	// overwritting this code which is in SRAM. (And it's a JMP)
}

// init p[0] - p[len-1] with val

// p = r45, val=r2, len=?_memset
void memset(PBYTE p, BYTE val, BYTE len)
{
#if 0
	while (len--)
		*p++ = val;
#else
#asm
		tx0 r2			; r0 = val
		lda r1,?_memset	; r1 = len
		breq memset2
memset1:
		stx r4
		upp r4
		dec r1
		brne memset1
memset2:
#endasm
#endif
	return;
}

// pd = r45, ps = r23, len=?_memcpy
void memcpy(PBYTE pd, PBYTE ps, BYTE len)
{
#if 0
	while (len--)
		{
		*pd++ = *ps++;
		}
#else
#asm
		lda r1,?_memcpy	; r1 = len
		breq memcpy2
memcpy1:
		ldx r2			; r0 = *ps
		upp r2
		stx r4
		upp r4
		dec r1
		brne memcpy1
memcpy2:
#endasm
#endif
	return;
}

BYTE	disabledCount = 0;

void disableInterrupts()
{

//	CONTROL_REG = 0xc0;		// disable interrupts
	disabledCount++;
	return;
}

void enableInterrupts()
{
// we can AssUMe that interrupts are currently disabled.
// the programmer is REQUIRED to call disable before enable.
	disabledCount--;
//	if (!disabledCount)
//		CONTROL_REG = 0xc8;		// enable interrupts
	return;
}


void stuff()
{
}

#if WANT_1394
	char WANT_1394_YES @0xff00;
#else // !WANT_1394
	char WANT_1394_NO @0xff00;
#endif

#if WANT_CAMERA
	char WANT_CAMERA_YES @0xff02;
#else // !WANT_CAMERA
	char WANT_CAMERA_NO @0xff02;
#endif

#if WANT_HANDSHAKE
	char WANT_HANDSHAKE_YES @0xff03;
#else // !WANT_HANDSHAKE
	char WANT_HANDSHAKE_NO @0xff03;
#endif

#if WANT_HARDWARE
	char WANT_HARDWARE_YES @0xff04;
#else // !WANT_HARDWARE
	char WANT_HARDWARE_NO @0xff04;
#endif

#if WANT_HOST
	char WANT_HOST_YES @0xff05;
#else // !WANT_HOST
	char WANT_HOST_NO @0xff05;
#endif

#if WANT_HUB
	char WANT_HUB_YES @0xff06;
#else // !WANT_HUB
	char WANT_HUB_NO @0xff06;
#endif

#if WANT_JTAG
	char WANT_JTAG_YES @0xff07;
#else // !WANT_JTAG
	char WANT_JTAG_NO @0xff07;
#endif

#if WANT_LITE
	char WANT_LITE_YES @0xff08;
#else // !WANT_LITE
	char WANT_LITE_NO @0xff08;
#endif

#if WANT_MONITOR
	char WANT_MONITOR_YES @0xff09;
#else // !WANT_MONITOR
	char WANT_MONITOR_NO @0xff09;
#endif

#if WANT_PRINTER
	char WANT_PRINTER_YES @0xff0a;
#else // !WANT_PRINTER
	char WANT_PRINTER_NO @0xff0a;
#endif

#if WANT_REGRESS
	char WANT_REGRESS_YES @0xff0b;
#else // !WANT_REGRESS
	char WANT_REGRESS_NO @0xff0b;
#endif

#if WANT_SAWTOOTH
	char WANT_SAWTOOTH_YES @0xff0c;
#else // !WANT_SAWTOOTH
	char WANT_SAWTOOTH_NO @0xff0c;
#endif

#if WANT_SIMULATOR
	char WANT_SIMULATOR_YES @0xff0d;
#else // !WANT_SIMULATOR
	char WANT_SIMULATOR_NO @0xff0d;
#endif

#if WANT_SOUND
	char WANT_SOUND_YES @0xff0e;
#else // !WANT_SOUND
	char WANT_SOUND_NO @0xff0e;
#endif

#if WANT_TIMER
	char WANT_TIMER_YES @0xff0f;
#else // !WANT_TIMER
	char WANT_TIMER_NO @0xff0f;
#endif

#if WANT_USB
	char WANT_USB_YES @0xff10;
#else // !WANT_USB
	char WANT_USB_NO @0xff10;
#endif

