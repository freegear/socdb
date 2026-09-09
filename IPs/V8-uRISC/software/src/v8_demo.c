// v8_demo.c

#include <intrpt.h>

#if WANT_USB && WANT_HARDWARE
#define DEBUG_FLAG		1
#else
#define DEBUG_FLAG		0
#endif

#include "vauto.h"

#if WANT_SOUND
#include "ad1848.h"
#endif

#include "uart.h"

#if WANT_JTAG
#include "jtag.h"
#endif

#if WANT_USB
#include "host.h"
#include "usb_drv.h"
#endif

#if WANT_MONITOR
#include "v8_mon.h"
#endif

#if WANT_PRINTER
#include "printer.h"
#endif

#include "i2c.h"	// eeprom routines

#if WANT_TIMER
#include "timer.h"
#endif // WANT_TIMER

#if WANT_HARDWARE && DEBUG_FLAG
DEBUG	debug = {1};	// most bits off by default
void DebugFlag(void);
#endif

#if !WANT_JTAG
char MainMenuString[] =
#if WANT_HARDWARE
			"\r\n"
#if WANT_SOUND
			"a = Audio demo Menu\r\n"
#endif	// WANT_SOUND
			"c = Clear LEDs\r\n"
#if DEBUG_FLAG
			"d = Debug flags\r\n"
#endif // DEBUG_FLAG
#if WANT_MONITOR
			"j = Jump to the debugger\r\n"
#endif // WANT_MONITOR
			"m = Modify RAM\r\n"
#if WANT_PRINTER
			"p = Print a test page to 1284 port\r\n"
			"P = read Printer registers\r\n"
#endif	// WANT_PRINTER
#if WANT_REGRESS
			"r = Regression test\r\n"
#endif	// WANT_REGRESS
			"s = Show Stack\r\n"
#if WANT_USB
			"u = USB Menu\r\n"
#endif	// WANT_USB
			"w = write SRAM to EEPROM\r\n"
			": = Download HEX File\r\n"
			"? = Help - Rev "
#else	// !WANT_HARDWARE
			"Main Menu "	// we're simulating, use a short string
#endif	// WANT_HARDWARE
			__DATE__
			" "
			__TIME__
			"\r\n";
#endif

void interrupt main2(void);
void interrupt Interrupt0Stub(void);
void interrupt Interrupt1Stub(void);
void interrupt Interrupt2Stub(void);
#if !WANT_TIMER
void interrupt Interrupt3Stub(void);
#endif // !WANT_TIMER
void interrupt Interrupt4Stub(void);
//void interrupt Interrupt5Stub(void);
void interrupt Interrupt6Stub(void);
void interrupt Interrupt7Stub(void);
void InterruptStub(PSTR p);
void modify(void);


void main()
{

	asm("global _main2");
	asm("jmp _main2");
}



#pragma interrupt_level 1
void interrupt main2()
{
	static ONION	onion, onion2;
#if !WANT_JTAG
	static BYTE	c;
#endif // !WANT_JTAG


	CONTROL_REG = 0x00;
	asm("stp 3");	// set interrupt flag to keep interrupts from distracting us

	UartInit(0);

	onion.w = 0x7f00;	// now and then a spurious error appears where anything
	onion2.w = 0xff00;	// read from the upper 32k is really fetched from the
test_high_bit:			// lower 32k.  This test warns us if it happens.
	*onion.pb = 0xaa;
	*onion2.pb = 0x55;
	if (*onion.pb == *onion2.pb)
		{
		puts("\aHigh bit stuck\r\n");
		putFlush();
		goto test_high_bit;
		}

#if WANT_JTAG	// these are some handy jtag testing instructions
#asm
	ldi r0,0x01
	ldi r1,0x23
	ldi r2,0x45
	ldi r3,0x67
	ldi r4,0x89
	ldi r5,0xab
	ldi r6,0xcd
	ldi r7,0xef
	stp 0
	stp 1
	stp 2
	clp 0
	clp 1
	clp 2
#endasm
#endif

	asm("clp 4");	// clear the 4 user definable LEDs
	asm("clp 5");
	asm("clp 6");
	asm("clp 7");

// trap all interrupts
	Interrupt0 = (WORD)Interrupt0Stub;
	Interrupt1 = (WORD)Interrupt1Stub;
	Interrupt2 = (WORD)Interrupt2Stub;
#if WANT_TIMER
	TimerDisable();
#else	// don't trap int3 if we're using a timer
	Interrupt3 = (WORD)Interrupt3Stub;
#endif // !WANT_TIMER
	Interrupt4 = (WORD)Interrupt4Stub;
//	Interrupt5 = (WORD)Interrupt5Stub;
	Interrupt6 = (WORD)Interrupt6Stub;
	Interrupt7 = (WORD)Interrupt7Stub;

	asm("clp 3");	// clear interrupt flag, we're ready to handle interrupts now
#if WANT_TIMER
//	TimerWaitAMs(1);
#endif

#if WANT_HARDWARE	// initialize the stack
	for (onion.w=0x300; onion.w<0x400; onion.w++)
		*onion.pb = 0x22;
#endif	// WANT_HARDWARE

#if WANT_SOUND	// if we want an 1848, we need to init it
	AudioInit();
#endif	// WANT_PRINTER

#if WANT_PRINTER	// if we want a PRINTER, we need to init it
	get1284id();
#endif	// WANT_PRINTER

#if WANT_MONITOR	// the debug monitor uses int0
// insert the interrupt service routine into the proper vector
	Interrupt0 = (WORD)Int0Service;
#endif	// WANT_MONITOR

	putFlush();

#if WANT_USB	// if we want usb, we need to init it
	UsbInit();
	UsbInit();
	UsbEnableReset();
#endif	// WANT_USB

	CONTROL_REG = 0xc8;
	asm("clp 3");	// clear interrupt flag

#if WANT_HARDWARE
#if 0
	if (!Regress())
		puts("\r\n\aRegression test FAILED!\r\n");
#else	// !0
	puts("\r\nRegression test SKIPPED\r\n");
#endif	// 0
#endif	// WANT_HARDWARE

#if WANT_JTAG
	JTAG();
#else
	for (;;)
		{
		puts(MainMenuString);
		putFlush();

REPOLL:
	//	USB_PRINTER();
		c = UartGetAndEchoChar();
		putCrlf();

		switch (c)
			{
#if WANT_SOUND
			case 'a':
				AudioMenu();
				continue;
#endif

#if WANT_HARDWARE
			case 'c':
				asm("stp 4");	// set hi 4 psr bits
				asm("stp 5");
				asm("stp 6");
				asm("stp 7");
				asm("clp 4");	// clear hi 4 psr bits
				asm("clp 5");
				asm("clp 6");
				asm("clp 7");
				puts(" done\r\n");
				goto REPOLL;
#endif // WANT_HARDWARE

#if DEBUG_FLAG
			case 'd':
				DebugFlag();
				goto REPOLL;
#endif // DEBUG_FLAG

#if WANT_MONITOR
			case 'j':
				asm("int 0");
				goto REPOLL;
#endif // WANT_MONITOR

#if WANT_HARDWARE
			case 'm':
				modify();
				goto REPOLL;
#endif // WANT_HARDWARE

#if WANT_PRINTER
			case 'p':
				puts(" not implemented");
				continue;

			case 'P':
				puts(" not implemented");
				continue;
#endif	// WANT_PRINTER

#if WANT_REGRESS
			case 'r':
				puts(" not implemented");
				continue;
#endif

			case 's':
				for (onion.w=0x300; onion.w<0x400; onion.w++)
					{
					putbs(*onion.pb);
					if ((onion.w & 0x0f) == 0x0f)
						{
						putCrlf();
						}
					}
puto(onion);
putCrlf();
				goto REPOLL;

#if WANT_USB
			case 'u':
				UsbMenu();
				continue;
#endif

#if WANT_HARDWARE
#if EEPROM_WRITE
			case 'w':
				RAM2EEPROM();
				goto REPOLL;
#endif // EEPROM_WRITE

			case ':':
				DOWNLOAD();		// won't return
				continue;

			case '?':
				continue;
#endif // WANT_HARDWARE

			case '\r':
			case '\n':
				goto REPOLL;

			default:
				putUnknown(c);
				continue;
			}
		}
#endif // !JTAG
}


#pragma interrupt_level 1
void interrupt Interrupt0Stub()	// dummy handler, calls InterruptStub and whines
{
	InterruptStub("\r\nInt0 ");
}
#pragma interrupt_level 1
void interrupt Interrupt1Stub()	// dummy handler, calls InterruptStub and whines
{
	InterruptStub("\r\nInt1 ");
}
#pragma interrupt_level 1
void interrupt Interrupt2Stub()	// dummy handler, calls InterruptStub and whines
{
	InterruptStub("\r\nInt2 ");
}
#if !WANT_TIMER
static volatile BYTE	TIMER_CTL			@0x0262;
#pragma interrupt_level 1
void interrupt Interrupt3Stub()	// dummy handler, calls InterruptStub and whines
{
	TIMER_CTL = 0;
	InterruptStub("\r\nInt3 ");
}
#endif
#pragma interrupt_level 1
void interrupt Interrupt4Stub()	// dummy handler, calls InterruptStub and whines
{
	InterruptStub("\r\nInt4 ");
}
//#pragma interrupt_level 1
//void interrupt Interrupt5Stub()	// dummy handler, calls InterruptStub and whines
//{
//	InterruptStub("\r\nInt5 ");
//}
#pragma interrupt_level 1
void interrupt Interrupt6Stub()	// dummy handler, calls InterruptStub and whines
{
	InterruptStub("\r\nInt6 ");
}
#pragma interrupt_level 1
void interrupt Interrupt7Stub()	// dummy handler, calls InterruptStub and whines
{
	InterruptStub("\r\nInt7 ");
}

BYTE	psr, pch, pcl;

void InterruptStub(PSTR p)	// an unsupported interrupt fired, display it
{
	puts(p);
#asm
	pop r0	; pcl of stub
	pop r1	; pch of stub

	pop	r2	; PCL
	pop	r3	; PCH
	pop	r4	; PSR
	sta r4,_psr
	sta r3,_pch
	sta r2,_pcl

	psh r4
	psh r3
	psh r2
	psh r1
	psh r0
#endasm
	putbs(psr);
	putb(pch);
	putb(pcl);
	putCrlf();
	putFlush();

//dot:	goto dot;	// we could halt here
	// or just return for more
}

#if !WANT_JTAG && WANT_HARDWARE
ONION examineAddress = {0x300};

void modify(void)	// modify contents of specified location
{
	static BYTE	bGotOne = 0;
	static BYTE	i, c, c2, cNew;
	static ONION	onion;

	puts("Addr:");
	examineAddress.w = UartReadHexWord();	// accept address from user
	putCrlf();

modify2:
	puto(examineAddress);
	putc('=');
modify3:
	putbs(*examineAddress.pb);	// display contants of specified location
modify4:
	c = UartReadChar();
	switch (c)
		{
		case '\r':
		case '\n':	goto done;	// all pone

		case '+':	examineAddress.w++;	// increment address and repaet
					putCrlf();
					goto modify2;

		case '-':	examineAddress.w--;	// decrement address and repeat
					putCrlf();
					goto modify2;

		case 'a':
		case 'b':
		case 'c':
		case 'd':
		case 'e':
		case 'f':
		case 'A':
		case 'B':
		case 'C':
		case 'D':
		case 'E':
		case 'F':	c2 = (c & 0x0f) + 9;	// convert a-f to hex
					break;

		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':	c2 = (c & 0x0f);		// convert 0-9 to hex
					break;

		case 'x':	onion = examineAddress;	// dump 64 bytes starting at address
					for (i=0; i<64; i++)
						{
						if ((i & 0x0f) == 0)
							{
							putCrlf();
							putw(onion.w + i);
							putc('>');
							}
						putbs(onion.pb[i]);
						}
					putCrlf();
					goto modify2;

		default:							// not a key we understand
					//putc('\a');
					goto modify3;	// just redraw value
		}

	putc(c);
	if (!bGotOne)	// first nibble
		{
		cNew = c2 << 4;
		bGotOne = 1;
		}
	else			// second nibble
		{
		bGotOne = 0;
		cNew |= c2;
		*examineAddress.pb = cNew;	// write new value
		putSpace();
		}
	goto modify4;

done:
	putCrlf();
	return;
}
#endif

#if DEBUG_FLAG
void DebugBit(PBYTE p, BYTE b)
{
	if (b)
		p[3] = 'Y';
	else
		p[3] = 'N';
	puts(p);
	return;
}

void DebugFlag(void)	// prompt user to specify some interactive debug settings
{
	static BYTE	c;
	static PBYTE	p;

	p = "NY";

	for (;;)
		{
		DebugBit("0> N = interrupts\r\n", debug.bits.UsbInt);
		DebugBit("1> N = send\r\n", debug.bits.UsbSend);
		DebugBit("2> N = Host State\r\n", debug.bits.HostState);
		DebugBit("3> N = Hub State\r\n", debug.bits.HubState);
		DebugBit("4> N = SOF Errors\r\n", debug.bits.SofErrors);

		puts("x>     Exit\r\n");

		do	{
			putFlushOneIfReady();
			} while (!UartCharWaiting());

		c = UartReadChar();
		putc(c);
		putCrlf();
		switch (c)
			{
			case 'x':	return;
			case '0':	debug.bits.UsbInt = !debug.bits.UsbInt;			break;
			case '1':	debug.bits.UsbSend = !debug.bits.UsbSend;		break;
			case '2':	debug.bits.HostState = !debug.bits.HostState;	break;
			case '3':	debug.bits.HubState = !debug.bits.HubState;		break;
			case '4':	debug.bits.SofErrors = !debug.bits.SofErrors;	break;
			case ':':	DOWNLOAD(); /* won't return */					break;
			}
		}
}
#endif
