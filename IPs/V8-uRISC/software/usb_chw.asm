;CodeStart 0410
;17 Nov 1999 12:01:58
.equ Z 0
.equ C 1
.equ N 2
.equ I 3


.org 0x0000
__Lreset:
		JMP powerup

.org 0x0088 ; skip 0085

	.org 0x0088
__Lreset+0x88:

.org 0x0202 ; skip 0179

	.org 0x0202
_CONTROL_REG:

.org 0x0210 ; skip 000d

	.org 0x0210
_AUDIO_ADDR:
	.org 0x0211
_AUDIO_DATA:
	.org 0x0212
_AUDIO_STAT:
	.org 0x0213
_AUDIO_PIO:

.org 0x0220 ; skip 000c

	.org 0x0220
_PP_DATA:
	.org 0x0221
_PP_CTRS:
	.org 0x0222
_PP_CTRH:
	.org 0x0223
_PP_CTL:
	.org 0x0224
_PP_CTLZ:

.org 0x0230 ; skip 000b

	.org 0x0230
_pwr_save_control:
	.org 0x0231
_pwr_save_status:
	.org 0x0232
_pwr_save_polarity:
	.org 0x0233
_pwr_save_enable:

.org 0x0240 ; skip 000c

	.org 0x0240
_UART_BASE_0:
	.org 0x0241
_uartStatus:
	.org 0x0242
_UART_BASE_2:
	.org 0x0243
_UART_BASE_3:

.org 0x0260 ; skip 001c

	.org 0x0260
_TIMER_COUNT_LO:
	.org 0x0261
_TIMER_COUNT_HI:
	.org 0x0262
_TIMER_CTL:
	.org 0x0263
_TIMER_PRESCALE:
	.org 0x0264
_TIMER_MAXAL:
	.org 0x0265
_TIMER_MAXAH:
	.org 0x0266
_TIMER_MAXBL:
	.org 0x0267
_TIMER_MAXBH:

.org 0x0280 ; skip 0018

	.org 0x0280
_usb:
	.org 0x0281
_usb+0x1:
	.org 0x0282
_usb+0x2:
	.org 0x0283
_usb+0x3:
	.org 0x0284
_usb+0x4:
	.org 0x0285
_usb+0x5:
	.org 0x0286
_usb+0x6:
	.org 0x0287
_usb+0x7:
	.org 0x0288
_usb+0x8:
	.org 0x0289
_usb+0x9:
	.org 0x028a
_usb+0xa:

.org 0x028d ; skip 0002

	.org 0x028d
_USB_FIFO_TX:
	.org 0x028e
_USB_FIFO_RX:
	.org 0x028f
_USB_FIFO_TEST:
	.org 0x0290
_ENDPT_HOST_RG:
	.org 0x0291
_ENDPT_HOST_RG+0x1:
	.org 0x0292
_ENDPT_HOST_RG+0x2:
	.org 0x0293
_ENDPT_HOST_RG+0x3:

.org 0x0300 ; skip 006c

	.org 0x0300
_stack:

.org 0x0400 ; skip 00ff

	.org 0x0400
_Interrupt0:
	.org 0x0401
_Interrupt0+0x1:
	.org 0x0402
_Interrupt1:
	.org 0x0403
_Interrupt1+0x1:
	.org 0x0404
_Interrupt2:
	.org 0x0405
_Interrupt2+0x1:
	.org 0x0406
_Interrupt3:
	.org 0x0407
_Interrupt3+0x1:
	.org 0x0408
_Interrupt4:
	.org 0x0409
_Interrupt4+0x1:
	.org 0x040a
_Interrupt5:
	.org 0x040b
_Interrupt5+0x1:
	.org 0x040c
_Interrupt6:
	.org 0x040d
_Interrupt6+0x1:
	.org 0x040e
_Interrupt7:
	.org 0x040f
_Interrupt7+0x1:

.org 0x0410
start:
		LDI r4,0x24 ;__Lbss
		LDI r5,0x4a ;__Lbss>>8
		LDI r2,0x8f ;main__168
		LDI r3,0x05 ;main__168>>8
		XOR r0
start__9:
		DEC r2
		BRCS start__f ;(+03)
		DEC r3
		BRCC __Lend_init ;(+05)
start__f:
		STX r4
		UPP r4
		JMP start__9
__Lend_init:
		JMP main
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\V8_DEMO.C
;// v8_demo.c
;
;#include <intrpt.h>
;
;#if WANT_USB && WANT_HARDWARE
;#define DEBUG_FLAG		1
;#else
;#define DEBUG_FLAG		0
;#endif
;
;#include "vauto.h"
;
;#if WANT_SOUND
;#include "ad1848.h"
;#endif
;
;#include "uart.h"
;
;#if WANT_JTAG
;#include "jtag.h"
;#endif
;
;#if WANT_USB
;#include "host.h"
;#include "usb_drv.h"
;#endif
;
;#if WANT_MONITOR
;#include "v8_mon.h"
;#endif
;
;#if WANT_PRINTER
;#include "printer.h"
;#endif
;
;#include "i2c.h"	// eeprom routines
;
;#if WANT_TIMER
;#include "timer.h"
;#endif // WANT_TIMER
;
;#if WANT_HARDWARE && DEBUG_FLAG
;DEBUG	debug = {1};	// most bits off by default
;void DebugFlag(void);
;#endif
;
;#if !WANT_JTAG
;char MainMenuString[] =
;#if WANT_HARDWARE
;			"\r\n"
;#if WANT_SOUND
;			"a = Audio demo Menu\r\n"
;#endif	// WANT_SOUND
;			"c = Clear LEDs\r\n"
;#if DEBUG_FLAG
;			"d = Debug flags\r\n"
;#endif // DEBUG_FLAG
;#if WANT_MONITOR
;			"j = Jump to the debugger\r\n"
;#endif // WANT_MONITOR
;			"m = Modify RAM\r\n"
;#if WANT_PRINTER
;			"p = Print a test page to 1284 port\r\n"
;			"P = read Printer registers\r\n"
;#endif	// WANT_PRINTER
;#if WANT_REGRESS
;			"r = Regression test\r\n"
;#endif	// WANT_REGRESS
;			"s = Show Stack\r\n"
;#if WANT_USB
;			"u = USB Menu\r\n"
;#endif	// WANT_USB
;			"w = write SRAM to EEPROM\r\n"
;			": = Download HEX File\r\n"
;			"? = Help - Rev "
;#else	// !WANT_HARDWARE
;			"Main Menu "	// we're simulating, use a short string
;#endif	// WANT_HARDWARE
;			__DATE__
;			" "
;			__TIME__
;			"\r\n";
;#endif
;
;void interrupt main2(void);
;void interrupt Interrupt0Stub(void);
;void interrupt Interrupt1Stub(void);
;void interrupt Interrupt2Stub(void);
;#if !WANT_TIMER
;void interrupt Interrupt3Stub(void);
;#endif // !WANT_TIMER
;void interrupt Interrupt4Stub(void);
;//void interrupt Interrupt5Stub(void);
;void interrupt Interrupt6Stub(void);
;void interrupt Interrupt7Stub(void);
;void InterruptStub(PSTR p);
;void modify(void);
;
;
;void main()
;{
;
;	asm("global _main2");
;	asm("jmp _main2");
;}
;
;
;
;#pragma interrupt_level 1
;void interrupt main2()
;{
main:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;	static ONION	onion, onion2;
;#if !WANT_JTAG
;	static BYTE	c;
;#endif // !WANT_JTAG
;
;
;	CONTROL_REG = 0x00;
		XOR r0
		STA r0,_CONTROL_REG
;	asm("stp 3");	// set interrupt flag to keep interrupts from distracting us
		STP I
;
;	UartInit(0);
		T0X r4
		JSR _UartInit
;
;	onion.w = 0x7f00;	// now and then a spurious error appears where anything
		LDI r0,0x7f
		STA r0,_psr+0x2
		XOR r0
		STA r0,_psr+0x1
;	onion2.w = 0xff00;	// read from the upper 32k is really fetched from the
		LDI r0,0xff
		STA r0,_psr+0x4
		XOR r0
		STA r0,_psr+0x3
;test_high_bit:			// lower 32k.  This test warns us if it happens.
;	*onion.pb = 0xaa;
main__21:
		LDI r0,0xaa
		LDA r2,_psr+0x1
		LDA r3,_psr+0x2
		STX r2
;	*onion2.pb = 0x55;
		LDI r0,0x55
		LDA r2,_psr+0x3
		LDA r3,_psr+0x4
		STX r2
;	if (*onion.pb == *onion2.pb)
		LDX r2
		T0X r2
		LDA r4,_psr+0x1
		LDA r5,_psr+0x2
		LDX r4
		CMP r2
		BRNE main__4c ;(+0d)
;		{
;		puts("\aHigh bit stuck\r\n");
		LDI r4,0x11 ;__Lstrings+0x88
		LDI r5,0x3c ;__Lstrings+0x88>>8
		JSR _puts
;		putFlush();
		JSR _putFlush
;		goto test_high_bit;
		JMP main__21
;		}
;
;#if WANT_JTAG	// these are some handy jtag testing instructions
;#asm
;	ldi r0,0x01
;	ldi r1,0x23
;	ldi r2,0x45
;	ldi r3,0x67
;	ldi r4,0x89
;	ldi r5,0xab
;	ldi r6,0xcd
;	ldi r7,0xef
;	stp 0
;	stp 1
;	stp 2
;	clp 0
;	clp 1
;	clp 2
;#endasm
;#endif
;
;	asm("clp 4");	// clear the 4 user definable LEDs
main__4c:
		CLP 4
;	asm("clp 5");
		CLP 5
;	asm("clp 6");
		CLP 6
;	asm("clp 7");
		CLP 7
;
;// trap all interrupts
;	Interrupt0 = (WORD)Interrupt0Stub;
		LDI r0,0x06
		STA r0,_Interrupt0+0x1
		LDI r0,0x22
		STA r0,_Interrupt0
;	Interrupt1 = (WORD)Interrupt1Stub;
		LDI r0,0x06
		STA r0,_Interrupt1+0x1
		LDI r0,0x2f
		STA r0,_Interrupt1
;	Interrupt2 = (WORD)Interrupt2Stub;
		LDI r0,0x06
		STA r0,_Interrupt2+0x1
		LDI r0,0x3c
		STA r0,_Interrupt2
;#if WANT_TIMER
;	TimerDisable();
;#else	// don't trap int3 if we're using a timer
;	Interrupt3 = (WORD)Interrupt3Stub;
		LDI r0,0x06
		STA r0,_Interrupt3+0x1
		LDI r0,0x49
		STA r0,_Interrupt3
;#endif // !WANT_TIMER
;	Interrupt4 = (WORD)Interrupt4Stub;
		LDI r0,0x06
		STA r0,_Interrupt4+0x1
		LDI r0,0x5a
		STA r0,_Interrupt4
;//	Interrupt5 = (WORD)Interrupt5Stub;
;	Interrupt6 = (WORD)Interrupt6Stub;
		LDI r0,0x06
		STA r0,_Interrupt6+0x1
		LDI r0,0x67
		STA r0,_Interrupt6
;	Interrupt7 = (WORD)Interrupt7Stub;
		LDI r0,0x06
		STA r0,_Interrupt7+0x1
		LDI r0,0x74
		STA r0,_Interrupt7
;
;	asm("clp 3");	// clear interrupt flag, we're ready to handle interrupts now
		CLP I
;#if WANT_TIMER
;//	TimerWaitAMs(1);
;#endif
;
;#if WANT_HARDWARE	// initialize the stack
;	for (onion.w=0x300; onion.w<0x400; onion.w++)
		LDI r0,0x03
		STA r0,_psr+0x2
		XOR r0
		STA r0,_psr+0x1
		T0X r1
		CMP r1
		LDI r1,0x04
		LDA r0,_psr+0x2
		SBC r1
		BRCS main__c9 ;(+1f)
;		*onion.pb = 0x22;
main__aa:
		LDI r0,0x22
		LDA r2,_psr+0x1
		LDA r3,_psr+0x2
		STX r2
		TX0 r2
		LDA r1,_psr+0x2
		UPP r0
		STA r0,_psr+0x1
		STA r1,_psr+0x2
		LDI r1,0x00
		CMP r1
		LDI r1,0x04
		LDA r0,_psr+0x2
		SBC r1
		BRCC main__aa ;(-1f)
;#endif	// WANT_HARDWARE
;
;#if WANT_SOUND	// if we want an 1848, we need to init it
;	AudioInit();
main__c9:
		JSR _AudioInit
;#endif	// WANT_PRINTER
;
;#if WANT_PRINTER	// if we want a PRINTER, we need to init it
;	get1284id();
		JSR _get1284id
;#endif	// WANT_PRINTER
;
;#if WANT_MONITOR	// the debug monitor uses int0
;// insert the interrupt service routine into the proper vector
;	Interrupt0 = (WORD)Int0Service;
;#endif	// WANT_MONITOR
;
;	putFlush();
		JSR _putFlush
;
;#if WANT_USB	// if we want usb, we need to init it
;	UsbInit();
		JSR _UsbInit
;	UsbInit();
		JSR _UsbInit
;	UsbEnableReset();
		JSR _UsbEnableReset
;#endif	// WANT_USB
;
;	CONTROL_REG = 0xc8;
		LDI r0,0xc8
		STA r0,_CONTROL_REG
;	asm("clp 3");	// clear interrupt flag
		CLP I
;
;#if WANT_HARDWARE
;#if 0
;	if (!Regress())
;		puts("\r\n\aRegression test FAILED!\r\n");
;#else	// !0
;	puts("\r\nRegression test SKIPPED\r\n");
		LDI r4,0x60 ;__Lstrings+0xd7
		LDI r5,0x3c ;__Lstrings+0xd7>>8
main__e5:
		JSR _puts
;#endif	// 0
;#endif	// WANT_HARDWARE
;
;#if WANT_JTAG
;	JTAG();
;#else
;	for (;;)
;		{
;		puts(MainMenuString);
;		putFlush();
;
;REPOLL:
;	//	USB_PRINTER();
;		c = UartGetAndEchoChar();
;		putCrlf();
;
;		switch (c)
		JMP main__191
;			{
;#if WANT_SOUND
;			case 'a':
;				AudioMenu();
main__eb:
		JSR _AudioMenu
;				continue;
		JMP main__191
;#endif
;
;#if WANT_HARDWARE
;			case 'c':
;				asm("stp 4");	// set hi 4 psr bits
main__f1:
		STP 4
;				asm("stp 5");
		STP 5
;				asm("stp 6");
		STP 6
;				asm("stp 7");
		STP 7
;				asm("clp 4");	// clear hi 4 psr bits
		CLP 4
;				asm("clp 5");
		CLP 5
;				asm("clp 6");
		CLP 6
;				asm("clp 7");
		CLP 7
;				puts(" done\r\n");
		LDI r4,0x4a ;__Lstrings+0xc1
		LDI r5,0x3c ;__Lstrings+0xc1>>8
		JSR _puts
;				goto REPOLL;
		JMP main__19b
;#endif // WANT_HARDWARE
;
;#if DEBUG_FLAG
;			case 'd':
;				DebugFlag();
main__103:
		JSR _DebugFlag
;				goto REPOLL;
		JMP main__19b
;#endif // DEBUG_FLAG
;
;#if WANT_MONITOR
;			case 'j':
;				asm("int 0");
;				goto REPOLL;
;#endif // WANT_MONITOR
;
;#if WANT_HARDWARE
;			case 'm':
;				modify();
main__109:
		JSR _modify
;				goto REPOLL;
		JMP main__19b
;#endif // WANT_HARDWARE
;
;#if WANT_PRINTER
;			case 'p':
;				puts(" not implemented");
main__10f:
		LDI r4,0x89 ;__Lstrings
		LDI r5,0x3b ;__Lstrings>>8
		JMP main__e5
;				continue;
;
;			case 'P':
;				puts(" not implemented");
main__116:
		LDI r4,0x89 ;__Lstrings
		LDI r5,0x3b ;__Lstrings>>8
		JMP main__e5
;				continue;
;#endif	// WANT_PRINTER
;
;#if WANT_REGRESS
;			case 'r':
;				puts(" not implemented");
;				continue;
;#endif
;
;			case 's':
;				for (onion.w=0x300; onion.w<0x400; onion.w++)
main__11d:
		LDI r0,0x03
		STA r0,_psr+0x2
		XOR r0
		STA r0,_psr+0x1
		T0X r1
		CMP r1
		LDI r1,0x04
		LDA r0,_psr+0x2
		SBC r1
		BRCS main__16a ;(+3a)
;					{
;					putbs(*onion.pb);
main__130:
		LDA r2,_psr+0x1
		LDA r3,_psr+0x2
		LDX r2
		T0X r4
		JSR _putbs
;					if ((onion.w & 0x0f) == 0x0f)
		LDA r0,_psr+0x1
		LDA r1,_psr+0x2
		LDI r4,0x0f
		AND r4
		T0X r4
		XOR r0
		AND r1
		T0X r1
		TX0 r4
		LDI r2,0x0f
		XOR r2
		OR  r1
		BRNE main__152 ;(+03)
;						{
;						putCrlf();
		JSR _putCrlf
main__152:
		LDA r0,_psr+0x1
		LDA r1,_psr+0x2
		UPP r0
		STA r0,_psr+0x1
		STA r1,_psr+0x2
		LDI r1,0x00
		CMP r1
		LDI r1,0x04
		LDA r0,_psr+0x2
		SBC r1
		BRCC main__130 ;(-3a)
;						}
;					}
;puto(onion);
main__16a:
		LDA r4,_psr+0x1
		LDA r5,_psr+0x2
		JSR _puto
;putCrlf();
		JSR _putCrlf
;				goto REPOLL;
		JMP main__19b
;
;#if WANT_USB
;			case 'u':
;				UsbMenu();
main__179:
		JSR _UsbMenu
;				continue;
		JMP main__191
;#endif
;
;#if WANT_HARDWARE
;#if EEPROM_WRITE
;			case 'w':
;				RAM2EEPROM();
main__17f:
		JSR _RAM2EEPROM
;				goto REPOLL;
		JMP main__19b
;#endif // EEPROM_WRITE
;
;			case ':':
;				DOWNLOAD();		// won't return
main__185:
		JSR _DOWNLOAD
;				continue;
;
;			case '?':
;				continue;
		JMP main__191
;#endif // WANT_HARDWARE
;
;			case '\r':
;			case '\n':
;				goto REPOLL;
;
;			default:
;				putUnknown(c);
main__18b:
		LDA r4,__Lbss
		JSR _putUnknown
main__191:
		LDI r4,0xb1 ;_MainMenuString
		LDI r5,0x45 ;_MainMenuString>>8
		JSR _puts
		JSR _putFlush
main__19b:
		JSR _UartGetAndEchoChar
		STA r0,__Lbss
		JSR _putCrlf
		LDA r0,__Lbss
		LDI r4,0xf6
		ADD r4
		BREQ main__19b ;(-11)
		LDI r4,0xfd
		ADD r4
		BREQ main__19b ;(-16)
		LDI r4,0xd3
		ADD r4
		BREQ main__185 ;(-31)
		LDI r4,0xfb
		ADD r4
		BREQ main__191 ;(-2a)
		LDI r4,0xef
		ADD r4
		BRNE main__1c3 ;(+03)
		JMP main__116
main__1c3:
		LDI r4,0xef
		ADD r4
		BRNE main__1cb ;(+03)
		JMP main__eb
main__1cb:
		DEC r0
		DEC r0
		BRNE main__1d2 ;(+03)
		JMP main__f1
main__1d2:
		DEC r0
		BRNE main__1d8 ;(+03)
		JMP main__103
main__1d8:
		LDI r4,0xf7
		ADD r4
		BRNE main__1e0 ;(+03)
		JMP main__109
main__1e0:
		LDI r4,0xfd
		ADD r4
		BRNE main__1e8 ;(+03)
		JMP main__10f
main__1e8:
		LDI r4,0xfd
		ADD r4
		BRNE main__1f0 ;(+03)
		JMP main__11d
main__1f0:
		DEC r0
		DEC r0
		BREQ main__179 ;(-7b)
		DEC r0
		DEC r0
		BREQ main__17f ;(-79)
		JMP main__18b
;				continue;
;			}
;		}
;#endif // !JTAG
;}
;
;
;#pragma interrupt_level 1
;void interrupt Interrupt0Stub()	// dummy handler, calls InterruptStub and whines
;{
_Interrupt0Stub:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;	InterruptStub("\r\nInt0 ");
		LDI r4,0xd3 ;__Lstrings+0x4a
		LDI r5,0x3b ;__Lstrings+0x4a>>8
		JMP _Interrupt7Stub__a
;}
;#pragma interrupt_level 1
;void interrupt Interrupt1Stub()	// dummy handler, calls InterruptStub and whines
;{
_Interrupt1Stub:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;	InterruptStub("\r\nInt1 ");
		LDI r4,0xcb ;__Lstrings+0x42
		LDI r5,0x3b ;__Lstrings+0x42>>8
		JMP _Interrupt7Stub__a
;}
;#pragma interrupt_level 1
;void interrupt Interrupt2Stub()	// dummy handler, calls InterruptStub and whines
;{
_Interrupt2Stub:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;	InterruptStub("\r\nInt2 ");
		LDI r4,0xc3 ;__Lstrings+0x3a
		LDI r5,0x3b ;__Lstrings+0x3a>>8
		JMP _Interrupt7Stub__a
;}
;#if !WANT_TIMER
;static volatile BYTE	TIMER_CTL			@0x0262;
;#pragma interrupt_level 1
;void interrupt Interrupt3Stub()	// dummy handler, calls InterruptStub and whines
;{
_Interrupt3Stub:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;	TIMER_CTL = 0;
		XOR r0
		STA r0,_TIMER_CTL
;	InterruptStub("\r\nInt3 ");
		LDI r4,0xbb ;__Lstrings+0x32
		LDI r5,0x3b ;__Lstrings+0x32>>8
		JMP _Interrupt7Stub__a
;}
;#endif
;#pragma interrupt_level 1
;void interrupt Interrupt4Stub()	// dummy handler, calls InterruptStub and whines
;{
_Interrupt4Stub:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;	InterruptStub("\r\nInt4 ");
		LDI r4,0xb3 ;__Lstrings+0x2a
		LDI r5,0x3b ;__Lstrings+0x2a>>8
		JMP _Interrupt7Stub__a
;}
;//#pragma interrupt_level 1
;//void interrupt Interrupt5Stub()	// dummy handler, calls InterruptStub and whines
;//{
;//	InterruptStub("\r\nInt5 ");
;//}
;#pragma interrupt_level 1
;void interrupt Interrupt6Stub()	// dummy handler, calls InterruptStub and whines
;{
_Interrupt6Stub:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;	InterruptStub("\r\nInt6 ");
		LDI r4,0xab ;__Lstrings+0x22
		LDI r5,0x3b ;__Lstrings+0x22>>8
		JMP _Interrupt7Stub__a
;}
;#pragma interrupt_level 1
;void interrupt Interrupt7Stub()	// dummy handler, calls InterruptStub and whines
;{
_Interrupt7Stub:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;	InterruptStub("\r\nInt7 ");
		LDI r4,0xa3 ;__Lstrings+0x1a
		LDI r5,0x3b ;__Lstrings+0x1a>>8
_Interrupt7Stub__a:
		JSR _InterruptStub
;}
		POP r5
		POP r4
		POP r3
		POP r2
		POP r1
		POP r0
		RTI
;
;BYTE	psr, pch, pcl;
;
;void InterruptStub(PSTR p)	// an unsupported interrupt fired, display it
;{
_InterruptStub:
		STA r4,Aa_UsbVendSetEndPoint
		STA r5,Aa_UsbVendSetEndPoint+0x1
;	puts(p);
		LDA r5,Aa_UsbVendSetEndPoint+0x1
		JSR _puts
;#asm
;	pop r0	; pcl of stub
		POP r0
;	pop r1	; pch of stub
		POP r1
;
;	pop	r2	; PCL
		POP r2
;	pop	r3	; PCH
		POP r3
;	pop	r4	; PSR
		POP r4
;	sta r4,_psr
		STA r4,_psr
;	sta r3,_pch
		STA r3,_pch
;	sta r2,_pcl
		STA r2,_pcl
;
;	psh r4
		PSH r4
;	psh r3
		PSH r3
;	psh r2
		PSH r2
;	psh r1
		PSH r1
;	psh r0
		PSH r0
;#endasm
;	putbs(psr);
		LDA r4,_psr
		JSR _putbs
;	putb(pch);
		LDA r4,_pch
		JSR _putb
;	putb(pcl);
		LDA r4,_pcl
		JSR _putb
;	putCrlf();
		JSR _putCrlf
;	putFlush();
		JMP _putFlush
;
;//dot:	goto dot;	// we could halt here
;	// or just return for more
;}
;
;#if !WANT_JTAG && WANT_HARDWARE
;ONION examineAddress = {0x300};
;
;void modify(void)	// modify contents of specified location
;{
;	static BYTE	bGotOne = 0;
;	static BYTE	i, c, c2, cNew;
;	static ONION	onion;
;
;	puts("Addr:");
_modify:
		LDI r4,0x9d ;__Lstrings+0x14
		LDI r5,0x3b ;__Lstrings+0x14>>8
		JSR _puts
;	examineAddress.w = UartReadHexWord();	// accept address from user
		JSR _UartReadHexWord
		STA r1,_examineAddress+0x1
		STA r0,_examineAddress
;	putCrlf();
;
;modify2:
;	puto(examineAddress);
;	putc('=');
;modify3:
;	putbs(*examineAddress.pb);	// display contants of specified location
;modify4:
;	c = UartReadChar();
;	switch (c)
		JMP _modify__b3
;		{
;		case '\r':
;		case '\n':	goto done;	// all pone
;
;		case '+':	examineAddress.w++;	// increment address and repaet
_modify__13:
		LDA r0,_examineAddress
		LDA r1,_examineAddress+0x1
		UPP r0
		STA r0,_examineAddress
		STA r1,_examineAddress+0x1
		JMP _modify__b3
;					putCrlf();
;					goto modify2;
;
;		case '-':	examineAddress.w--;	// decrement address and repeat
_modify__23:
		LDA r0,_examineAddress
		DEC r0
		STA r0,_examineAddress
		BRCC _modify__2f ;(+03)
		JMP _modify__b3
_modify__2f:
		LDA r0,_examineAddress+0x1
		DEC r0
		STA r0,_examineAddress+0x1
		JMP _modify__b3
;					putCrlf();
;					goto modify2;
;
;		case 'a':
;		case 'b':
;		case 'c':
;		case 'd':
;		case 'e':
;		case 'f':
;		case 'A':
;		case 'B':
;		case 'C':
;		case 'D':
;		case 'E':
;		case 'F':	c2 = (c & 0x0f) + 9;	// convert a-f to hex
_modify__39:
		LDI r1,0x0f
		LDA r0,__Lbss+0x3
		AND r1
		LDI r1,0x09
		ADD r1
		STA r0,__Lbss+0x4
;					break;
		JMP _modify__189
;
;		case '0':
;		case '1':
;		case '2':
;		case '3':
;		case '4':
;		case '5':
;		case '6':
;		case '7':
;		case '8':
;		case '9':	c2 = (c & 0x0f);		// convert 0-9 to hex
_modify__48:
		LDI r1,0x0f
		LDA r0,__Lbss+0x3
		AND r1
		STA r0,__Lbss+0x4
;					break;
		JMP _modify__189
;
;		case 'x':	onion = examineAddress;	// dump 64 bytes starting at address
_modify__54:
		LDA r0,_examineAddress+0x1
		STA r0,_psr+0x6
		LDA r0,_examineAddress
		STA r0,_psr+0x5
;					for (i=0; i<64; i++)
		XOR r0
		STA r0,__Lbss+0x2
		LDI r1,0x40
		LDA r0,__Lbss+0x2
		CMP r1
		BRCS _modify__b3 ;(+47)
;						{
;						if ((i & 0x0f) == 0)
_modify__6c:
		LDI r1,0x0f
		LDA r0,__Lbss+0x2
		AND r1
		BRNE _modify__8f ;(+1b)
;							{
;							putCrlf();
		JSR _putCrlf
;							putw(onion.w + i);
		LDA r4,_psr+0x5
		LDA r5,_psr+0x6
		LDA r0,__Lbss+0x2
		LDI r1,0x00
		ADD r4
		T0X r4
		TX0 r1
		ADC r5
		T0X r5
		JSR _putw
;							putc('>');
		LDI r4,0x3e
		JSR _putc
;							}
;						putbs(onion.pb[i]);
_modify__8f:
		LDA r2,_psr+0x5
		LDA r3,_psr+0x6
		LDA r0,__Lbss+0x2
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		T0X r4
		JSR _putbs
		LDA r0,__Lbss+0x2
		INC r0
		STA r0,__Lbss+0x2
		LDI r1,0x40
		LDA r0,__Lbss+0x2
		CMP r1
		BRCC _modify__6c ;(-47)
_modify__b3:
		JSR _putCrlf
		LDA r4,_examineAddress
		LDA r5,_examineAddress+0x1
		JSR _puto
		LDI r4,0x3d
		JSR _putc
_modify__c4:
		LDA r2,_examineAddress
		LDA r3,_examineAddress+0x1
		LDX r2
		T0X r4
		JSR _putbs
_modify__cf:
		JSR _UartReadChar
		STA r0,__Lbss+0x3
		LDI r4,0xf6
		ADD r4
		BRNE _modify__dd ;(+03)
		JMP _putCrlf
_modify__dd:
		LDI r4,0xfd
		ADD r4
		BRNE _modify__e5 ;(+03)
		JMP _putCrlf
_modify__e5:
		LDI r4,0xe2
		ADD r4
		BRNE _modify__ed ;(+03)
		JMP _modify__13
_modify__ed:
		DEC r0
		DEC r0
		BRNE _modify__f4 ;(+03)
		JMP _modify__23
_modify__f4:
		LDI r4,0xfd
		ADD r4
		BRNE _modify__fc ;(+03)
		JMP _modify__48
_modify__fc:
		DEC r0
		BRNE _modify__102 ;(+03)
		JMP _modify__48
_modify__102:
		DEC r0
		BRNE _modify__108 ;(+03)
		JMP _modify__48
_modify__108:
		DEC r0
		BRNE _modify__10e ;(+03)
		JMP _modify__48
_modify__10e:
		DEC r0
		BRNE _modify__114 ;(+03)
		JMP _modify__48
_modify__114:
		DEC r0
		BRNE _modify__11a ;(+03)
		JMP _modify__48
_modify__11a:
		DEC r0
		BRNE _modify__120 ;(+03)
		JMP _modify__48
_modify__120:
		DEC r0
		BRNE _modify__126 ;(+03)
		JMP _modify__48
_modify__126:
		DEC r0
		BRNE _modify__12c ;(+03)
		JMP _modify__48
_modify__12c:
		DEC r0
		BRNE _modify__132 ;(+03)
		JMP _modify__48
_modify__132:
		LDI r4,0xf8
		ADD r4
		BRNE _modify__13a ;(+03)
		JMP _modify__39
_modify__13a:
		DEC r0
		BRNE _modify__140 ;(+03)
		JMP _modify__39
_modify__140:
		DEC r0
		BRNE _modify__146 ;(+03)
		JMP _modify__39
_modify__146:
		DEC r0
		BRNE _modify__14c ;(+03)
		JMP _modify__39
_modify__14c:
		DEC r0
		BRNE _modify__152 ;(+03)
		JMP _modify__39
_modify__152:
		DEC r0
		BRNE _modify__158 ;(+03)
		JMP _modify__39
_modify__158:
		LDI r4,0xe5
		ADD r4
		BRNE _modify__160 ;(+03)
		JMP _modify__39
_modify__160:
		DEC r0
		BRNE _modify__166 ;(+03)
		JMP _modify__39
_modify__166:
		DEC r0
		BRNE _modify__16c ;(+03)
		JMP _modify__39
_modify__16c:
		DEC r0
		BRNE _modify__172 ;(+03)
		JMP _modify__39
_modify__172:
		DEC r0
		BRNE _modify__178 ;(+03)
		JMP _modify__39
_modify__178:
		DEC r0
		BRNE _modify__17e ;(+03)
		JMP _modify__39
_modify__17e:
		LDI r4,0xee
		ADD r4
		BRNE _modify__186 ;(+03)
		JMP _modify__54
_modify__186:
		JMP _modify__c4
;						}
;					putCrlf();
;					goto modify2;
;
;		default:							// not a key we understand
;					//putc('\a');
;					goto modify3;	// just redraw value
;		}
;
;	putc(c);
_modify__189:
		LDA r4,__Lbss+0x3
		JSR _putc
;	if (!bGotOne)	// first nibble
		LDA r0,__Lbss+0x1
		BRNE _modify__1a6 ;(+12)
;		{
;		cNew = c2 << 4;
		LDA r0,__Lbss+0x4
		ADD r0
		ADD r0
		ADD r0
		ADD r0
		STA r0,__Lbss+0x5
;		bGotOne = 1;
		LDI r0,0x01
		STA r0,__Lbss+0x1
;		}
		JMP _modify__cf
;	else			// second nibble
;		{
;		bGotOne = 0;
_modify__1a6:
		XOR r0
		STA r0,__Lbss+0x1
;		cNew |= c2;
		LDA r1,__Lbss+0x4
		LDA r0,__Lbss+0x5
		OR  r1
		STA r0,__Lbss+0x5
;		*examineAddress.pb = cNew;	// write new value
		LDA r2,_examineAddress
		LDA r3,_examineAddress+0x1
		STX r2
;		putSpace();
		JSR _putSpace
;		}
;	goto modify4;
		JMP _modify__cf
;
;done:
;	putCrlf();
;	return;
;}
;#endif
;
;#if DEBUG_FLAG
;void DebugBit(PBYTE p, BYTE b)
;{
_DebugBit:
		STA r4,Aa_UsbVendSetEndPoint
		STA r5,Aa_UsbVendSetEndPoint+0x1
;	if (b)
		TX0 r2
		BREQ _DebugBit__d ;(+04)
;		p[3] = 'Y';
		LDI r0,0x59
		BRNE _DebugBit__f ;(+02)
;	else
;		p[3] = 'N';
_DebugBit__d:
		LDI r0,0x4e
_DebugBit__f:
		LDA r2,Aa_UsbVendSetEndPoint
		LDA r3,Aa_UsbVendSetEndPoint+0x1
		STO r2,0x03
;	puts(p);
		LDA r4,Aa_UsbVendSetEndPoint
		LDA r5,Aa_UsbVendSetEndPoint+0x1
		JMP _puts
;	return;
;}
;
;void DebugFlag(void)	// prompt user to specify some interactive debug settings
;{
;	static BYTE	c;
;	static PBYTE	p;
;
;	p = "NY";
_DebugFlag:
		LDI r0,0x3b
		STA r0,_psr+0x8
		LDI r0,0x9a
		STA r0,_psr+0x7
;
;	for (;;)
;		{
;		DebugBit("0> N = interrupts\r\n", debug.bits.UsbInt);
_DebugFlag__a:
		LDA r0,_debug
		LDI r4,0x01
		AND r4
		T0X r2
		LDI r4,0xe9 ;__Lstrings+0x60
		LDI r5,0x3b ;__Lstrings+0x60>>8
		JSR _DebugBit
;		DebugBit("1> N = send\r\n", debug.bits.UsbSend);
		LDA r0,_debug
		ROR r0
		LDI r4,0x01
		AND r4
		T0X r2
		LDI r4,0x52 ;__Lstrings+0xc9
		LDI r5,0x3c ;__Lstrings+0xc9>>8
		JSR _DebugBit
;		DebugBit("2> N = Host State\r\n", debug.bits.HostState);
		LDA r0,_debug
		ROR r0
		ROR r0
		LDI r4,0x01
		AND r4
		T0X r2
		LDI r4,0x23 ;__Lstrings+0x9a
		LDI r5,0x3c ;__Lstrings+0x9a>>8
		JSR _DebugBit
;		DebugBit("3> N = Hub State\r\n", debug.bits.HubState);
		LDA r0,_debug
		ROR r0
		ROR r0
		ROR r0
		LDI r4,0x01
		AND r4
		T0X r2
		LDI r4,0x37 ;__Lstrings+0xae
		LDI r5,0x3c ;__Lstrings+0xae>>8
		JSR _DebugBit
;		DebugBit("4> N = SOF Errors\r\n", debug.bits.SofErrors);
		LDA r0,_debug
		ROR r0
		ROR r0
		ROR r0
		ROR r0
		LDI r4,0x01
		AND r4
		T0X r2
		LDI r4,0xfd ;__Lstrings+0x74
		LDI r5,0x3b ;__Lstrings+0x74>>8
		JSR _DebugBit
;
;		puts("x>     Exit\r\n");
		LDI r4,0xdb ;__Lstrings+0x52
		LDI r5,0x3b ;__Lstrings+0x52>>8
		JSR _puts
;
;		do	{
;			putFlushOneIfReady();
_DebugFlag__61:
		JSR _putFlushOneIfReady
;			} while (!UartCharWaiting());
		JSR _UartCharWaiting
		T0X r1
		BREQ _DebugFlag__61 ;(-09)
;
;		c = UartReadChar();
		JSR _UartReadChar
		STA r0,__Lbss+0x6
;		putc(c);
		T0X r4
		JSR _putc
;		putCrlf();
		JSR _putCrlf
;		switch (c)
		JMP _DebugFlag__108
;			{
;			case 'x':	return;
_DebugFlag__7a:
		RTS
;			case '0':	debug.bits.UsbInt = !debug.bits.UsbInt;			break;
_DebugFlag__7b:
		LDA r0,_debug
		BTT Z
		BRNE _DebugFlag__85 ;(+04)
		LDI r0,0x01
		BRNE _DebugFlag__86 ;(+01)
_DebugFlag__85:
		XOR r0
_DebugFlag__86:
		ROR r0
		LDA r0,_debug
		LDI r1,0x01
		OR  r1
		BRCS _DebugFlag__90 ;(+01)
		XOR r1
_DebugFlag__90:
		STA r0,_debug
		JMP _DebugFlag__a
;			case '1':	debug.bits.UsbSend = !debug.bits.UsbSend;		break;
_DebugFlag__96:
		LDA r0,_debug
		BTT C
		BRNE _DebugFlag__a0 ;(+04)
		LDI r0,0x01
		BRNE _DebugFlag__a1 ;(+01)
_DebugFlag__a0:
		XOR r0
_DebugFlag__a1:
		ROR r0
		LDA r0,_debug
		LDI r1,0x02
		OR  r1
		BRCS _DebugFlag__ab ;(+01)
		XOR r1
_DebugFlag__ab:
		STA r0,_debug
		JMP _DebugFlag__a
;			case '2':	debug.bits.HostState = !debug.bits.HostState;	break;
_DebugFlag__b1:
		LDA r0,_debug
		BTT N
		BRNE _DebugFlag__bb ;(+04)
		LDI r0,0x01
		BRNE _DebugFlag__bc ;(+01)
_DebugFlag__bb:
		XOR r0
_DebugFlag__bc:
		ROR r0
		LDA r0,_debug
		LDI r1,0x04
		OR  r1
		BRCS _DebugFlag__c6 ;(+01)
		XOR r1
_DebugFlag__c6:
		STA r0,_debug
		JMP _DebugFlag__a
;			case '3':	debug.bits.HubState = !debug.bits.HubState;		break;
_DebugFlag__cc:
		LDA r0,_debug
		BTT I
		BRNE _DebugFlag__d6 ;(+04)
		LDI r0,0x01
		BRNE _DebugFlag__d7 ;(+01)
_DebugFlag__d6:
		XOR r0
_DebugFlag__d7:
		ROR r0
		LDA r0,_debug
		LDI r1,0x08
		OR  r1
		BRCS _DebugFlag__e1 ;(+01)
		XOR r1
_DebugFlag__e1:
		STA r0,_debug
		JMP _DebugFlag__a
;			case '4':	debug.bits.SofErrors = !debug.bits.SofErrors;	break;
_DebugFlag__e7:
		LDA r0,_debug
		BTT 4
		BRNE _DebugFlag__f1 ;(+04)
		LDI r0,0x01
		BRNE _DebugFlag__f2 ;(+01)
_DebugFlag__f1:
		XOR r0
_DebugFlag__f2:
		ROR r0
		LDA r0,_debug
		LDI r1,0x10
		OR  r1
		BRCS _DebugFlag__fc ;(+01)
		XOR r1
_DebugFlag__fc:
		STA r0,_debug
		JMP _DebugFlag__a
;			case ':':	DOWNLOAD(); /* won't return */					break;
_DebugFlag__102:
		JSR _DOWNLOAD
		JMP _DebugFlag__a
_DebugFlag__108:
		LDA r0,__Lbss+0x6
		LDI r4,0xd0
		ADD r4
		BRNE _DebugFlag__113 ;(+03)
		JMP _DebugFlag__7b
_DebugFlag__113:
		DEC r0
		BREQ _DebugFlag__96 ;(-80)
		DEC r0
		BREQ _DebugFlag__b1 ;(-68)
		DEC r0
		BREQ _DebugFlag__cc ;(-50)
		DEC r0
		BREQ _DebugFlag__e7 ;(-38)
		LDI r4,0xfa
		ADD r4
		BREQ _DebugFlag__102 ;(-22)
		LDI r4,0xc2
		ADD r4
		BRNE _DebugFlag__12c ;(+03)
		JMP _DebugFlag__7a
_DebugFlag__12c:
		JMP _DebugFlag__a
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\AD1848.C
;// ad1848.c
;
;#include "vauto.h"
;#include "ad1848.h"
;#include "uart.h"
;
;// the following hard-coded locations MUST be editted
;// if your memory map is not the vautomation default
;
;//volatile BYTE	AUDIO_BASE		@0x210;	// External AUDIO BASE address
;volatile BYTE	AUDIO_ADDR		@0x210;	// External AUDIO index address register
;volatile BYTE	AUDIO_DATA		@0x211;	// External AUDIO index data register
;volatile BYTE	AUDIO_STAT		@0x212;	// External AUDIO status register
;volatile BYTE	AUDIO_PIO		@0x213;	// External AUDIO pio data register
;
;void AudioRegs(void);
;void AudioSawtooth(void);
;void AudioCapture(void);
;void AudioPlayback(void);
;
;void AudioMenu()
;{
_AudioMenu:
		JMP _AudioMenu__77
;	static BYTE	c;
;	static ONION	onion;
;
;prompt:
;	puts(	"\r\nAUDIO DEMO MENU\r\n"
;			"c = Capture 32kb\r\n"
;			"i = Init ad1845\r\n"
;			"p = Playback 32kb\r\n"
;			"r = Register read\r\n"
;			"s = Sawtooth playback data\r\n"
;			"+ = Inc freq\r\n"
;			"- = Dec freq\r\n"
;			"= = Show Freq\r\n"
;			"x = Exit");
;
;	while (1)
;		{
;		putCrlf();
;		putc('&');
;		c = UartReadChar();
;		putc(c);
;		putFlush();		// echo immediately
;		switch (c)
;			{
;			case 'i':
;				AudioInit();
_AudioMenu__3:
		JSR _AudioInit
;				break;
		JMP _AudioMenu__7e
;
;			case 'x':
;				return;	// to main menu
_AudioMenu__9:
		RTS
;
;			case 'r':
;				putCrlf();
_AudioMenu__a:
		JSR _putCrlf
;				AudioRegs();
		JSR _AudioRegs
;				break;
		JMP _AudioMenu__7e
;
;			case 's':
;				AudioSawtooth();
_AudioMenu__13:
		JSR _AudioSawtooth
;				break;
		JMP _AudioMenu__7e
;
;			case 'c':
;				AudioCapture();
_AudioMenu__19:
		JSR _AudioCapture
;				break;
		JMP _AudioMenu__7e
;
;			case 'p':
;				AudioPlayback();
_AudioMenu__1f:
		JSR _AudioPlayback
;				break;
		JMP _AudioMenu__7e
;
;			case ':':
;				DOWNLOAD();		// won't return
_AudioMenu__25:
		JSR _DOWNLOAD
;				continue;
		JMP _AudioMenu__7e
;
;			case '+':
;			AUDIO_ADDR = 22;
_AudioMenu__2b:
		LDI r0,0x16
		STA r0,_AUDIO_ADDR
;			AUDIO_DATA = AUDIO_DATA + 1;
		LDA r0,_AUDIO_DATA
		INC r0
		JMP _AudioMenu__42
;			AUDIO_ADDR = 23;
;			AUDIO_DATA = AUDIO_DATA;
;			goto show_regs;
;
;			case '-':
;			AUDIO_ADDR = 22;
_AudioMenu__37:
		LDI r0,0x16
		STA r0,_AUDIO_ADDR
;			AUDIO_DATA = AUDIO_DATA - 1;
		LDI r1,0xff
		LDA r0,_AUDIO_DATA
		ADD r1
_AudioMenu__42:
		STA r0,_AUDIO_DATA
;			AUDIO_ADDR = 23;
		LDI r0,0x17
		STA r0,_AUDIO_ADDR
;			AUDIO_DATA = AUDIO_DATA;
		LDA r0,_AUDIO_DATA
		STA r0,_AUDIO_DATA
;			goto show_regs;
;
;			case '=':
;show_regs:
;			AUDIO_ADDR = 22;
_AudioMenu__50:
		LDI r0,0x16
		STA r0,_AUDIO_ADDR
;			onion.b.h = AUDIO_DATA;
		LDA r0,_AUDIO_DATA
		STA r0,_psr+0x14
;			AUDIO_ADDR = 23;
		LDI r0,0x17
		STA r0,_AUDIO_ADDR
;			onion.b.l = AUDIO_DATA;
		LDA r0,_AUDIO_DATA
		STA r0,_psr+0x13
;			puto(onion);
		T0X r4
		LDA r5,_psr+0x14
		JSR _puto
;			continue;
		JMP _AudioMenu__7e
;
;			default:
;				puts("?\r\n\r\n");
_AudioMenu__70:
		LDI r4,0x6c ;__Lstrings+0x1e3
		LDI r5,0x3d ;__Lstrings+0x1e3>>8
		JSR _puts
_AudioMenu__77:
		LDI r4,0x7c ;__Lstrings+0xf3
		LDI r5,0x3c ;__Lstrings+0xf3>>8
		JSR _puts
_AudioMenu__7e:
		JSR _putCrlf
		LDI r4,0x26
		JSR _putc
		JSR _UartReadChar
		STA r0,_psr+0x9
		T0X r4
		JSR _putc
		JSR _putFlush
		LDA r0,_psr+0x9
		LDI r4,0xd5
		ADD r4
		BREQ _AudioMenu__2b ;(-70)
		DEC r0
		DEC r0
		BREQ _AudioMenu__37 ;(-68)
		LDI r4,0xf3
		ADD r4
		BREQ _AudioMenu__25 ;(-7f)
		LDI r4,0xfd
		ADD r4
		BREQ _AudioMenu__50 ;(-59)
		LDI r4,0xda
		ADD r4
		BRNE _AudioMenu__b1 ;(+03)
		JMP _AudioMenu__19
_AudioMenu__b1:
		LDI r4,0xfa
		ADD r4
		BRNE _AudioMenu__b9 ;(+03)
		JMP _AudioMenu__3
_AudioMenu__b9:
		LDI r4,0xf9
		ADD r4
		BRNE _AudioMenu__c1 ;(+03)
		JMP _AudioMenu__1f
_AudioMenu__c1:
		DEC r0
		DEC r0
		BRNE _AudioMenu__c8 ;(+03)
		JMP _AudioMenu__a
_AudioMenu__c8:
		DEC r0
		BRNE _AudioMenu__ce ;(+03)
		JMP _AudioMenu__13
_AudioMenu__ce:
		LDI r4,0xfb
		ADD r4
		BRNE _AudioMenu__d6 ;(+03)
		JMP _AudioMenu__9
_AudioMenu__d6:
		JMP _AudioMenu__70
;				goto prompt;
;			}
;		}
;}
;
;BYTE A_TABLE[] =	// AD1845 register init table
;	{
;	0xa0,	//  0 Left  Input Control - select MIC, +20db gain
;	0xa0,	//  1 Right Input Control - select MIC, +20db gain
;	0x9f,	//  2 Left  Aux1 in ctl - Mute
;	0x9f,	//  3 Right Aux1 in ctl - Mute
;	0x9f,	//  4 Left  Aux2 in ctl - Mute
;	0x9f,	//  5 Right Aux2 in ctl - Mute
;	0x00,	//  6 Left  DAC ctl - enable
;	0x00,	//  7 Right DAC ctl - enable
;	0x53,	//  8 CLK/data Format - 11Khz, 16 bit stereo, linear PCM
;	0xc9,	//  9 Interface Config - enable PIO mode,ACAL, playback
;	0x00,	// 10 Pin control - disable interrupts
;	0x00,	// 11 Test and Init - read only
;	0x40,	// 12 Misc CTL - MODE2 (bit6=1) MUST be enabled!
;	0x00,	// 13 Digital Mix - disabled
;	0x00,	// 14 Upper Base Count - not used
;	0x00,	// 15 Lower Base Count - not used
;	// the following register ARE ONLY accessable if MODE2=1!
;	// DAC=0 on underrun makes PUR more obvious!
;	0x91,	// 16 Alternate feature - DAC=0 on UR, 0L=0db,+12db gain
;	0x10,	// 17 MIC Mix enable - diabled
;	0x9f,	// 18 Left Line GAM - mute
;	0x9f,	// 19 Right Line GAM - mute
;	0x00,	// 20 Lo timer - don't care
;	0x00,	// 21 Hi timer - don't care
;	11000 >> 8,		// 23 Upper Freq - 11 Khz
;	11000 & 0xff,	// 22 lower Freq - 11 Khz
;	0x00,	// 24 Cap/play timer - don't care
;	0x00,	// 25 Rev - read only
;	0x11,	// 26 Mono CTL - mute
;	0x08,	// 27 Power-Down CTL - enable freq regs
;	0x50,	// 28 Capture Format - 16 bit linear stereo
;	0x00,	// 29 Crystal select - 24.5 Mhz
;	0x00,	// 30 CAP upper base - don't care
;	0x00	// 31 CAP lower base - don't care
;	};
;
;void AudioInit()
;{
;	static BYTE	b, c;
;
;	for (c=2; c; c--)	// takes two tries to succeed
_AudioInit:
		LDI r0,0x02
		BRNE _AudioInit__69 ;(+65)
;		{
;		for (b = 0; b < 16; b++)
_AudioInit__4:
		XOR r0
		STA r0,_psr+0xa
		LDI r1,0x10
		LDA r0,_psr+0xa
		CMP r1
		BRCS _AudioInit__2b ;(+1b)
;			if ((AUDIO_ADDR & 0x80) == 0)	// test init bit
_AudioInit__10:
		LDA r0,_AUDIO_ADDR
		BRPL _AudioInit__2b ;(+16)
;				break;				// set, init is over
;			else
;				{
;#if WANT_HARDWARE
;				puts("AUDIO CHIP still initing\r\n");
		LDI r4,0x28 ;__Lstrings+0x19f
		LDI r5,0x3d ;__Lstrings+0x19f>>8
		JSR _puts
		LDA r0,_psr+0xa
		INC r0
		STA r0,_psr+0xa
		LDI r1,0x10
		LDA r0,_psr+0xa
		CMP r1
		BRCC _AudioInit__10 ;(-1b)
;#endif	// WANT_HARDWARE
;				}
;
;	// init audio from table
;		for (b=0; b<32; b++)
_AudioInit__2b:
		XOR r0
		STA r0,_psr+0xa
		LDI r1,0x20
		LDA r0,_psr+0xa
		CMP r1
		BRCS _AudioInit__61 ;(+2a)
;			{
;			// add MCE bit (6) to allow write to all registers.
;			AUDIO_ADDR = 0x40 + b;
_AudioInit__37:
		LDI r1,0x40
		LDA r0,_psr+0xa
		ADD r1
		STA r0,_AUDIO_ADDR
;			AUDIO_DATA = A_TABLE[b];
		LDI r2,0xb0 ;_A_TABLE
		LDI r3,0x46 ;_A_TABLE>>8
		LDA r0,_psr+0xa
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		STA r0,_AUDIO_DATA
		LDA r0,_psr+0xa
		INC r0
		STA r0,_psr+0xa
		LDI r1,0x20
		LDA r0,_psr+0xa
		CMP r1
		BRCC _AudioInit__37 ;(-2a)
;			}
;
;	// release MCE and the chip should begin running in about 128 samples...
;		AUDIO_ADDR = 0;
_AudioInit__61:
		XOR r0
		STA r0,_AUDIO_ADDR
		LDA r0,_psr+0xb
		DEC r0
_AudioInit__69:
		STA r0,_psr+0xb
		LDA r0,_psr+0xb
		BRNE _AudioInit__4 ;(-6d)
;		}
;
;#if WANT_HARDWARE
;	puts("AUDIO CHIP inited\r\n");
		LDI r4,0x58 ;__Lstrings+0x1cf
		LDI r5,0x3d ;__Lstrings+0x1cf>>8
		JMP _puts
;#endif	// WANT_HARDWARE
;
;	return;
;}
;
;void AudioRegs()
;{
;	static BYTE	i, j;
;
;	for (i=0; i<32; i++)
_AudioRegs:
		XOR r0
		BREQ _AudioRegs__25 ;(+22)
;		{
;		AUDIO_ADDR = i;
_AudioRegs__3:
		LDA r0,_psr+0xc
		STA r0,_AUDIO_ADDR
;		j = AUDIO_DATA;
		LDA r0,_AUDIO_DATA
		STA r0,_psr+0xd
;		putbs(j);
		T0X r4
		JSR _putbs
;		if ((i & 0x0f) == 0x0f)
		LDI r1,0x0f
		LDA r0,_psr+0xc
		AND r1
		LDI r1,0x0f
		CMP r1
		BRNE _AudioRegs__21 ;(+03)
;			{
;			putCrlf();
		JSR _putCrlf
_AudioRegs__21:
		LDA r0,_psr+0xc
		INC r0
_AudioRegs__25:
		STA r0,_psr+0xc
		LDI r1,0x20
		LDA r0,_psr+0xc
		CMP r1
		BRCC _AudioRegs__3 ;(-2d)
		RTS
;			}
;		}
;
;	return;
;}
;
;void AudioSawtooth()
;{
;	static BYTE	b, l, r;
;
;	AUDIO_ADDR = 9;
_AudioSawtooth:
		LDI r0,0x09
		STA r0,_AUDIO_ADDR
;	AUDIO_DATA = 0xc1;		// enable PIO playback
		LDI r0,0xc1
		STA r0,_AUDIO_DATA
;	l = 0;
		XOR r0
		STA r0,_psr+0xf
;	r = 0;
		STA r0,_psr+0x10
;
;	while(1)
;		{
;		if (UartCharWaiting())	// if char has been typed
_AudioSawtooth__11:
		JSR _UartCharWaiting
		T0X r1
		BREQ _AudioSawtooth__1e ;(+07)
;			{
;			b = UartReadChar();	// eat it
		JSR _UartReadChar
		STA r0,_psr+0xe
;			return;				// we are done
		RTS
;			}
;
;		if ((AUDIO_STAT & 0x02) == 0)
_AudioSawtooth__1e:
		LDA r0,_AUDIO_STAT
		BTT C
		BREQ _AudioSawtooth__11 ;(-13)
;			{						// uart not ready
;			continue;
;			}
;
;		if (AUDIO_STAT & 0x04)	// is left channel ready
		LDA r0,_AUDIO_STAT
		BTT N
		BREQ _AudioSawtooth__3d ;(+13)
;			{				// yes
;			l--;
		LDA r0,_psr+0xf
		DEC r0
		STA r0,_psr+0xf
;			AUDIO_PIO = l;	// 2 bytes for 16 bit data
		STA r0,_AUDIO_PIO
;			AUDIO_PIO = l;
		LDA r0,_psr+0xf
		STA r0,_AUDIO_PIO
;			}
		JMP _AudioSawtooth__11
;		else
;			{
;			r++;
_AudioSawtooth__3d:
		LDA r0,_psr+0x10
		INC r0
		STA r0,_psr+0x10
;			AUDIO_PIO = r;	// 2 bytes for 16 bit data
		STA r0,_AUDIO_PIO
;			AUDIO_PIO = r;
		LDA r0,_psr+0x10
		STA r0,_AUDIO_PIO
		JMP _AudioSawtooth__11
;			}
;		}
;}
;
;void AudioCapture()
;{
;	static BYTE	b, max;
;	static PBYTE	p;
;	static ONION	pMax;
;
;	p = (PBYTE)0x8000;
_AudioCapture:
		LDI r0,0x80
		STA r0,_psr+0x16
		XOR r0
		STA r0,_psr+0x15
;	max = 0;
		STA r0,_psr+0x12
;	pMax.pb = NULL;
		STA r0,_psr+0x18
		STA r0,_psr+0x17
;
;	AUDIO_ADDR = 9;
		LDI r0,0x09
		STA r0,_AUDIO_ADDR
;	AUDIO_DATA = 0xc2;		// enable capture
		LDI r0,0xc2
		STA r0,_AUDIO_DATA
;	AUDIO_ADDR = 0;
		XOR r0
		STA r0,_AUDIO_ADDR
;
;	while (1)
;		{
;		if ((AUDIO_STAT & 0x20) == 0)
_AudioCapture__20:
		LDA r0,_AUDIO_STAT
		BTT 5
		BREQ _AudioCapture__20 ;(-06)
;			continue;		// wait for data to become available
;		b = AUDIO_PIO;
		LDA r0,_AUDIO_PIO
		STA r0,_psr+0x11
;		if (b > max)		// save max value address
		T0X r1
		LDA r0,_psr+0x12
		CMP r1
		BRCS _AudioCapture__42 ;(+0f)
;			{
;			max = b;
		STA r1,_psr+0x12
;			pMax.pb = p;
		LDA r0,_psr+0x16
		STA r0,_psr+0x18
		LDA r0,_psr+0x15
		STA r0,_psr+0x17
;			}
;		*p++ = b;			// write data to buffer
_AudioCapture__42:
		LDA r0,_psr+0x11
		LDA r2,_psr+0x15
		LDA r3,_psr+0x16
		STX r2
		TX0 r2
		LDA r1,_psr+0x16
		UPP r0
		STA r0,_psr+0x15
		STA r1,_psr+0x16
;		if (!p)
		LDA r1,_psr+0x16
		OR  r1
		BRNE _AudioCapture__20 ;(-3d)
;			break;
;		}
;
;	putb(max);
		LDA r4,_psr+0x12
		JSR _putb
;	putc('@');
		LDI r4,0x40
		JSR _putc
;	puto(pMax);
		LDA r4,_psr+0x17
		LDA r5,_psr+0x18
		JSR _puto
;	puts("=Max, Capture done\r\n");
		LDI r4,0x43 ;__Lstrings+0x1ba
		LDI r5,0x3d ;__Lstrings+0x1ba>>8
		JMP _puts
;	return;
;}
;
;void AudioPlayback()
;{
;	static PBYTE	p;
;
;	p = (PBYTE)0x8000;
_AudioPlayback:
		LDI r0,0x80
		STA r0,_psr+0x1a
		XOR r0
		STA r0,_psr+0x19
;	AUDIO_ADDR = 9;
		LDI r0,0x09
		STA r0,_AUDIO_ADDR
;	AUDIO_DATA = 0xc1;		// enable PIO playback
		LDI r0,0xc1
		STA r0,_AUDIO_DATA
;
;	while (1)
;		{
;		if ((AUDIO_STAT & 0x02) == 0)
_AudioPlayback__13:
		LDA r0,_AUDIO_STAT
		BTT C
		BREQ _AudioPlayback__13 ;(-06)
;			continue;
;
;		AUDIO_PIO = *p++;
		LDA r2,_psr+0x19
		LDA r3,_psr+0x1a
		LDX r2
		STA r0,_AUDIO_PIO
		TX0 r2
		LDA r1,_psr+0x1a
		UPP r0
		STA r0,_psr+0x19
		STA r1,_psr+0x1a
;		if (!p)
		LDA r1,_psr+0x1a
		OR  r1
		BRNE _AudioPlayback__13 ;(-21)
		RTS
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\dumpregs.h
;// DumpRegs.h
;
;{
;	ONION	o, o2, o3;
;
;#if DEBUG_REGS_VERBOSE
;	UsbDumpByte(usbSave.intStatus, usbSave.intEnable, pStatus);
;	UsbDumpByte(usbSave.errorStatus, usbSave.errorEnable, pError);
;#endif
;
;#if 0
;	putc('$');
;	putb(USB_HOST_STATE);
;	putSpace();
;#endif
;
;#if 1
;	putb(usbSave.intStatus);
_HostDumpRegs:
		LDA r4,_usbSave
		JSR _putb
;	putSpace();
		JSR _putSpace
;
;	putb(usbSave.intEnable);
		LDA r4,_usbSave+0x1
		JSR _putb
;	putSpace();
		JSR _putSpace
;
;	putb(usbSave.errorStatus);
		LDA r4,_usbSave+0x2
		JSR _putb
;	putSpace();
		JSR _putSpace
;
;	putb(usbSave.errorEnable);
		LDA r4,_usbSave+0x3
		JSR _putb
;	putSpace();
		JSR _putSpace
;
;	o.b.l = usbSave.status;
		LDA r0,_usbSave+0x4
		STA r0,Aa_HostSetNextInBdt
;	putb(usbSave.status);
		LDA r4,_usbSave+0x4
		JSR _putb
;	putSpace();
		JSR _putSpace
;
;	putb(usbSave.control);
		LDA r4,_usbSave+0x5
		JSR _putb
;	putSpace();
		JSR _putSpace
;
;	putb(usbSave.address);
		LDA r4,_usbSave+0x6
		JSR _putb
;	putSpace();
		JSR _putSpace
;
;	o.b.h = usbSave.bdtPage;
		LDA r0,_usbSave+0x7
		STA r0,A_UsbSendIn
;	putb(usbSave.bdtPage);
		LDA r4,_usbSave+0x7
		JSR _putb
;#else
;	o.b.l = usbSave.status;
;	o.b.h = usbSave.bdtPage;
;#endif
;
;	if (usbSave.intStatus & INT_STAT_MASK_TOKEN_DONE)
		LDA r0,_usbSave
		BTT I
		BRNE _HostDumpRegs__5a ;(+03)
		JMP _HostDumpRegs__2a6
;		{
;		putc('>');
_HostDumpRegs__5a:
		LDI r4,0x3e
		JSR _putc
;		putb(o.pb[0]);
		LDA r2,Aa_HostSetNextInBdt
		LDA r3,A_UsbSendIn
		LDX r2
		T0X r4
		JSR _putb
;		putb(o.pb[1]);
		LDA r2,Aa_HostSetNextInBdt
		LDA r3,A_UsbSendIn
		LDO r2,0x01
		T0X r4
		JSR _putb
;
;		if ((o.pb[0] & 0x03) || o.pb[1])	// if bch or bcl, dump buffer
		LDI r1,0x03
		LDA r2,Aa_HostSetNextInBdt
		LDA r3,A_UsbSendIn
		LDX r2
		AND r1
		BRNE _HostDumpRegs__89 ;(+07)
		LDO r2,0x01
		BRNE _HostDumpRegs__89 ;(+03)
		JMP _HostDumpRegs__2a6
;			{
;			putb(o.pb[2]);
_HostDumpRegs__89:
		LDA r2,Aa_HostSetNextInBdt
		LDA r3,A_UsbSendIn
		LDO r2,0x02
		T0X r4
		JSR _putb
;			putb(o.pb[3]);
		LDA r2,Aa_HostSetNextInBdt
		LDA r3,A_UsbSendIn
		LDO r2,0x03
		T0X r4
		JSR _putb
;			putc('>');
		LDI r4,0x3e
		JSR _putc
;
;			o2.b.l = o.pb[2];
		LDA r2,Aa_HostSetNextInBdt
		LDA r3,A_UsbSendIn
		LDO r2,0x02
		STA r0,Aa_UartReadString
;			o2.b.h = o.pb[3];
		LDO r2,0x03
		STA r0,Aa_UartReadString+0x1
;
;			o3.b.l = o.pb[1];
		LDO r2,0x01
		STA r0,Aa_UsbVendSetEndPoint
;			o3.b.h = o.pb[0] & 0x03;
		LDI r1,0x03
		LDX r2
		AND r1
		STA r0,Aa_UsbVendSetEndPoint+0x1
;
;			if (((o.pb[0] & 0x3c) == 0x34) && (o3.w >= 2))
		LDI r1,0x3c
		LDX r2
		AND r1
		LDI r1,0x34
		XOR r1
		BREQ _HostDumpRegs__ce ;(+03)
		JMP _HostDumpRegs__290
_HostDumpRegs__ce:
		LDI r1,0x02
		LDA r0,Aa_UsbVendSetEndPoint
		CMP r1
		LDI r1,0x00
		LDA r0,Aa_UsbVendSetEndPoint+0x1
		SBC r1
		BRCS _HostDumpRegs__df ;(+03)
		JMP _HostDumpRegs__290
;				{	// if setup and packet length >= 2 show type
;				puts(o2.pb[0] & 0x80 ? "H>D " : "D>H ");
_HostDumpRegs__df:
		LDA r2,Aa_UartReadString
		LDA r3,Aa_UartReadString+0x1
		LDX r2
		BRMI _HostDumpRegs__ef ;(+07)
		LDI r0,0x5e ;__Lstrings+0x2d5
		LDI r1,0x3e ;__Lstrings+0x2d5>>8
		JMP _HostDumpRegs__f3
_HostDumpRegs__ef:
		LDI r0,0x77 ;__Lstrings+0x2ee
		LDI r1,0x3e ;__Lstrings+0x2ee>>8
_HostDumpRegs__f3:
		T0X r2
		PSH r1
		POP r3
		TX0 r2
		T0X r4
		TX0 r3
		T0X r5
		JSR _puts
;				switch (o2.pb[0] & 0x60)
		JMP _HostDumpRegs__128
;					{
;					case 0x00: puts("Std ");	break;
_HostDumpRegs__100:
		LDI r4,0x13 ;__Lstrings+0x28a
		LDI r5,0x3e ;__Lstrings+0x28a>>8
		JSR _puts
		JMP _HostDumpRegs__186
;					case 0x20: puts("Cls ");	break;
_HostDumpRegs__10a:
		LDI r4,0xf1 ;__Lstrings+0x268
		LDI r5,0x3d ;__Lstrings+0x268>>8
		JSR _puts
		JMP _HostDumpRegs__186
;					case 0x40: puts("Vnd ");	break;
_HostDumpRegs__114:
		LDI r4,0x18 ;__Lstrings+0x28f
		LDI r5,0x3e ;__Lstrings+0x28f>>8
		JSR _puts
		JMP _HostDumpRegs__186
;					case 0x60: puts("Rsv ");	break;
_HostDumpRegs__11e:
		LDI r4,0xd8 ;__Lstrings+0x24f
		LDI r5,0x3d ;__Lstrings+0x24f>>8
		JSR _puts
		JMP _HostDumpRegs__186
_HostDumpRegs__128:
		LDI r1,0x60
		LDA r2,Aa_UartReadString
		LDA r3,Aa_UartReadString+0x1
		LDX r2
		AND r1
		LDI r1,0x00
		BREQ _HostDumpRegs__14c ;(+16)
_HostDumpRegs__136:
		TX0 r1
		OR  r1
		BREQ _HostDumpRegs__100 ;(-3a)
		LDI r4,0xe0
		ADD r4
		BREQ _HostDumpRegs__10a ;(-35)
		LDI r4,0xe0
		ADD r4
		BREQ _HostDumpRegs__114 ;(-30)
		LDI r4,0xe0
		ADD r4
		BREQ _HostDumpRegs__11e ;(-2b)
		JMP _HostDumpRegs__186
_HostDumpRegs__14c:
		PSH r0
		TX0 r1
		POP r1
		BREQ _HostDumpRegs__136 ;(-1b)
		JMP _HostDumpRegs__186
;					}
;				switch (o2.pb[0] & 0x1f)
;					{
;					case 0x00: puts("Dev ");	break;
_HostDumpRegs__154:
		LDI r4,0xdd ;__Lstrings+0x254
		LDI r5,0x3d ;__Lstrings+0x254>>8
		JSR _puts
		JMP _HostDumpRegs__238
;					case 0x01: puts("Int ");	break;
_HostDumpRegs__15e:
		LDI r4,0xe2 ;__Lstrings+0x259
		LDI r5,0x3d ;__Lstrings+0x259>>8
		JSR _puts
		JMP _HostDumpRegs__238
;					case 0x02: puts("End ");	break;
_HostDumpRegs__168:
		LDI r4,0x1d ;__Lstrings+0x294
		LDI r5,0x3e ;__Lstrings+0x294>>8
		JSR _puts
		JMP _HostDumpRegs__238
;					case 0x03: puts("Oth ");	break;
_HostDumpRegs__172:
		LDI r4,0x0e ;__Lstrings+0x285
		LDI r5,0x3e ;__Lstrings+0x285>>8
		JSR _puts
		JMP _HostDumpRegs__238
;					default:   puts("Rsv ");	break;
_HostDumpRegs__17c:
		LDI r4,0xd8 ;__Lstrings+0x24f
		LDI r5,0x3d ;__Lstrings+0x24f>>8
		JSR _puts
		JMP _HostDumpRegs__238
_HostDumpRegs__186:
		LDI r1,0x1f
		LDA r2,Aa_UartReadString
		LDA r3,Aa_UartReadString+0x1
		LDX r2
		AND r1
		LDI r1,0x00
		BREQ _HostDumpRegs__1a4 ;(+10)
_HostDumpRegs__194:
		TX0 r1
		OR  r1
		BREQ _HostDumpRegs__154 ;(-44)
		DEC r0
		BREQ _HostDumpRegs__15e ;(-3d)
		DEC r0
		BREQ _HostDumpRegs__168 ;(-36)
		DEC r0
		BREQ _HostDumpRegs__172 ;(-2f)
		JMP _HostDumpRegs__17c
_HostDumpRegs__1a4:
		PSH r0
		TX0 r1
		POP r1
		BREQ _HostDumpRegs__194 ;(-15)
		JMP _HostDumpRegs__17c
;					}
;				switch (o2.pb[1])
;					{
;					case 0: puts("GET_STAT ");	break;
_HostDumpRegs__1ac:
		LDI r4,0x2c ;__Lstrings+0x2a3
		LDI r5,0x3e ;__Lstrings+0x2a3>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 1: puts("CLR_FEAT ");	break;
_HostDumpRegs__1b6:
		LDI r4,0x40 ;__Lstrings+0x2b7
		LDI r5,0x3e ;__Lstrings+0x2b7>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 2: puts("reserved ");	break;
_HostDumpRegs__1c0:
		LDI r4,0x22 ;__Lstrings+0x299
		LDI r5,0x3e ;__Lstrings+0x299>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 3: puts("SET_FEAT ");	break;
_HostDumpRegs__1ca:
		LDI r4,0x36 ;__Lstrings+0x2ad
		LDI r5,0x3e ;__Lstrings+0x2ad>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 4: puts("reserved ");	break;
_HostDumpRegs__1d4:
		LDI r4,0x22 ;__Lstrings+0x299
		LDI r5,0x3e ;__Lstrings+0x299>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 5: puts("SET_ADDR ");	break;
_HostDumpRegs__1de:
		LDI r4,0x54 ;__Lstrings+0x2cb
		LDI r5,0x3e ;__Lstrings+0x2cb>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 6: puts("GET_DESC ");	break;
_HostDumpRegs__1e8:
		LDI r4,0x86 ;__Lstrings+0x2fd
		LDI r5,0x3e ;__Lstrings+0x2fd>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 7: puts("SET_DESC ");	break;
_HostDumpRegs__1f2:
		LDI r4,0x7c ;__Lstrings+0x2f3
		LDI r5,0x3e ;__Lstrings+0x2f3>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 8: puts("GET_CONF ");	break;
_HostDumpRegs__1fc:
		LDI r4,0x6d ;__Lstrings+0x2e4
		LDI r5,0x3e ;__Lstrings+0x2e4>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 9: puts("SET_CONF ");	break;
_HostDumpRegs__206:
		LDI r4,0x63 ;__Lstrings+0x2da
		LDI r5,0x3e ;__Lstrings+0x2da>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 10: puts("GET_IFC  ");	break;
_HostDumpRegs__210:
		LDI r4,0xef ;__Lstrings+0x366
		LDI r5,0x3e ;__Lstrings+0x366>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 11: puts("SET_IFC  ");	break;
_HostDumpRegs__21a:
		LDI r4,0xe5 ;__Lstrings+0x35c
		LDI r5,0x3e ;__Lstrings+0x35c>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					case 12: puts("SYNCH_FR ");	break;
_HostDumpRegs__224:
		LDI r4,0x4a ;__Lstrings+0x2c1
		LDI r5,0x3e ;__Lstrings+0x2c1>>8
		JSR _puts
		JMP _HostDumpRegs__290
;					default: puts("unknown  ");	break;
_HostDumpRegs__22e:
		LDI r4,0xdb ;__Lstrings+0x352
		LDI r5,0x3e ;__Lstrings+0x352>>8
		JSR _puts
		JMP _HostDumpRegs__290
_HostDumpRegs__238:
		LDA r2,Aa_UartReadString
		LDA r3,Aa_UartReadString+0x1
		LDO r2,0x01
		BRNE _HostDumpRegs__245 ;(+03)
		JMP _HostDumpRegs__1ac
_HostDumpRegs__245:
		DEC r0
		BRNE _HostDumpRegs__24b ;(+03)
		JMP _HostDumpRegs__1b6
_HostDumpRegs__24b:
		DEC r0
		BRNE _HostDumpRegs__251 ;(+03)
		JMP _HostDumpRegs__1c0
_HostDumpRegs__251:
		DEC r0
		BRNE _HostDumpRegs__257 ;(+03)
		JMP _HostDumpRegs__1ca
_HostDumpRegs__257:
		DEC r0
		BRNE _HostDumpRegs__25d ;(+03)
		JMP _HostDumpRegs__1d4
_HostDumpRegs__25d:
		DEC r0
		BRNE _HostDumpRegs__263 ;(+03)
		JMP _HostDumpRegs__1de
_HostDumpRegs__263:
		DEC r0
		BREQ _HostDumpRegs__1e8 ;(-7e)
		DEC r0
		BREQ _HostDumpRegs__1f2 ;(-77)
		DEC r0
		BREQ _HostDumpRegs__1fc ;(-70)
		DEC r0
		BREQ _HostDumpRegs__206 ;(-69)
		DEC r0
		BREQ _HostDumpRegs__210 ;(-62)
		DEC r0
		BREQ _HostDumpRegs__21a ;(-5b)
		DEC r0
		BREQ _HostDumpRegs__224 ;(-54)
		JMP _HostDumpRegs__22e
;					}
;				}
;
;			while (o3.w--)
;				{
;				putb(*o2.pb++);
_HostDumpRegs__27b:
		LDA r0,Aa_UartReadString+0x1
		T0X r3
		T0X r1
		LDA r0,Aa_UartReadString
		T0X r2
		UPP r0
		STA r0,Aa_UartReadString
		STA r1,Aa_UartReadString+0x1
		LDX r2
		T0X r4
		JSR _putb
_HostDumpRegs__290:
		LDA r0,Aa_UsbVendSetEndPoint
		PSH r0
		DEC r0
		STA r0,Aa_UsbVendSetEndPoint
		LDA r0,Aa_UsbVendSetEndPoint+0x1
		T0X r1
		BRCS _HostDumpRegs__2a2 ;(+04)
		DEC r0
		STA r0,Aa_UsbVendSetEndPoint+0x1
_HostDumpRegs__2a2:
		POP r0
		OR  r1
		BRNE _HostDumpRegs__27b ;(-2b)
;				}
;			}
;		}
;
;	putCrlf();
_HostDumpRegs__2a6:
		JSR _putCrlf
;
;#if DEBUG_ENDPOINTS
;	{
;	BYTE	b;
;	
;	puts("Endpt regs:");
;	for (b=0; b<4; b++)
;		{
;		putSpace();
;		putb(ENDPT_RG[b]);
;		}
;	putCrlf();
;	}
;#endif
;
;	putFlush();
		JMP _putFlush
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\HOST.C
;// host.c
;
;#define HOST_C		1
;
;#include "vauto.h"
;#include "uart.h"
;#include "host.h"
;#if WANT_HOST
;#include "host_int.h"
;#endif // WANT_HOST
;#include "usb_drv.h"
;#include "usb_glob.h"
;#if WANT_PRINTER
;#include "printer.h"
;#endif
;
;#define DEBUG_DESCRIPTOR		0
;#define DEBUG_DEVICE_DESC		0
;#define DEBUG_BDT				0
;#define DEBUG_OUT_TOKENS		0
;#define DEBUG_SEND_TOKEN		0
;#define DEBUG_USB				0
;#define DEBUG_USB_ATTACH		0
;#define DEBUG_ADDRESS			0
;#define DEBUG_IN_SO_FAR			0
;#define USB_CHAPTER9			0
;#define DEBUG_CONFIG			0
;#define DEBUG_PARTIAL			0
;#define DEBUG_USB_STRINGS		0
;#define DEBUG_META_STATES		0
;#define DEBUG_TOKEN				0
;//#define DEBUG_REGISTERS			0
;
;#if WANT_HARDWARE
;ONION	HOST_WAIT = {250};
;#else
;ONION	HOST_WAIT = {1};
;#endif
;
;
;BYTE speed = 0x00;
;
;BYTE USB_IN;		// next ep0 bdt to use
;extern BYTE USB_OUT;			// next ep0 bdt to use
;
;#if DEBUG_BDT
;static volatile PBDT debugPBDT @0xff00;	// copy bdt's here to see them in simulation
;static volatile BDT debugBDT @0xff04;
;static volatile BYTE debugDATA[8] @0xff08;
;#endif
;
;#if DEBUG_OUT_TOKENS
;volatile BYTE debugTOKEN_ADDRESS @0xff10;
;volatile BYTE debugTOKEN_TOKEN @0xff11;
;volatile BYTE debugTOKEN_TYPE @0xff12;
;#endif
;
;#if !WANT_LITE
;void HostDumpRegs()
;#include "dumpregs.h"
;#endif //!WANT_LITE
;
;#define HERTZ_DONUT				8
;
;#if DEBUG_DESCRIPTOR
;volatile DESCRIPTOR debugDESCRIPTOR @0xff10;	// copy DESCRIPTOR's here to see them in simulation
;#endif
;
;#if !WANT_LITE
;typedef struct
;	{
;	WORD	wLength;
;	PBYTE	pBuffer;
;	BYTE	bReserved;
;	BYTE	bEndpointControl;
;	BYTE	bAddress;
;	BYTE	bTokenAndEndpoint;
;	WORD	wReserved;
;	WORD	wBC;
;	} TODO;
;
;TODO	todo;
;BYTE	bSomethingTodo = 0;	// 0 = nothing, 1 = something, 2 = in progress
;BYTE	todoBuffer[64];
;#endif
;
;// we now use these even when we aren't buffering tokens for xmit on the next token_done
;// this is so we can re-xmit if an error is returned
;BYTE	USB_BUFFERED=0, USB_BUFFERED_TOKEN, USB_BUFFERED_ADDRESS, USB_BUFFERED_TYPE;
;BDT		USB_BUFFERED_BDT = {0};
;
;BYTE USB_HOST_STATE;
;
;BYTE USB_CURRENT_ADDR;	// last address assigned
;BYTE USB_NEXT_ADDR;	// next address to assign
;BYTE USB_ARE_WE_ATTACHED;
;BYTE USB_OUT;		// next ep0 bdt to use
;
;BYTE USB_CURRENT_CONFIG;	// used for looping
;BYTE USB_NUM_CONFIGS;
;//static ONION USB_POLL_COUNT;
;ONION rx_buffer;
;ONION USB_IN_WANTED = {0};
;
;BYTE USB_NEXT_DATA01;
;BYTE USB_META_STATE_WANTED;
;BYTE USB_META_STATE;
;
;WORD USB_PACKET_LENGTH_MODE;
;
;BYTE USB_DUMP_bIfaceClass;
;BYTE USB_DUMP_bIfaceSubClass;
;BYTE USB_DUMP_bNumEndPoints;
;#if WANT_SAWTOOTH
;BYTE USB_SPEAKER_ENDPOINT = 0xff;	// parse config will set this
;#endif //WANT_SAWTOOTH
;#if WANT_CAMERA
;BYTE USB_CAMERA_ENDPOINT = 2;		// parse config will set this someday
;#endif //WANT_CAMERA
;#if WANT_PRINTER
;BYTE USB_PRINTER_ENDPOINT = 0x03;	// parse config will set this someday,
;									// currently we use class 0xff so 
;									// there's no point looking
;//BYTE USB_PRINTER_BUFFER_SIZE:	.rword 64	; ditto
;#endif //WANT_PRINTER
;
;BOOL	bItsAHub = FALSE;
;
;typedef struct
;	{
;	BYTE bLength;			// 00
;	BYTE bDescriptorType;	// 01
;	WORD bcdUSB;			// 02-03
;	BYTE bDeviceClass;		// 04
;	BYTE bDeviceSubClass;	// 05
;	BYTE bDeviceProtocol;	// 06
;	BYTE bMaxPacketSize0;	// 07
;	WORD idVendor;			// 08-09
;	WORD idProduct;			// 0a-0b
;	WORD bcdDevice;			// 0c-0d
;	BYTE iManufacturer;		// 0e
;	BYTE iProduct;			// 0f
;	BYTE iSerialNumber;		// 10
;	BYTE bNumConfigurations;// 11
;	} DEVICE_DESCRIPTOR, *PDEVICE_DESCRIPTOR;
;
;DEVICE_DESCRIPTOR rx_desc_device;
;
;DESCRIPTOR tx_get_desc_device =
;	{
;	0x80,		// device-to-host, standard, device
;	0x06,		// Get Descriptor
;	{0x0100},	// wValue: HiByte type = 1 - Device, LoByte index = 0
;	{0},		// wIndex: 0 (or language ID)
;	{0x0012}	// wLength: 0x12 bytes
;	};
;
;DESCRIPTOR tx_get_desc_config =
;	{
;	0x80,		// device-to-host, standard, device
;	0x06,		// Get Descriptor
;	{0x0200},	// wValue: HiByte type = 2 - Config, LoByte index = 0
;	{0},		// wIndex: 0 (or language ID)
;	{0x01ff}	// wLength: 0x1ff bytes
;	};
;
;DESCRIPTOR tx_get_desc_string =
;	{
;	0x80,		// device-to-host, standard, device
;	0x06,		// Get Descriptor
;	{0x0300},	// wValue: HiByte type = 3 - String, LoByte index = 0
;	{0},		// wIndex: 0 (or language ID)
;	{0x00ff}	// wLength: 0xff bytes
;	};
;
;DESCRIPTOR tx_set_config =
;	{
;	0,			// host-to-device, standard, device
;	9,			// Set Config
;	{0x0001},	// wValue: HiByte 0 = default, LoByte 1 = Configuration value
;	{0},		// wIndex: 0 = Default
;	{0}			// wLength: 0 = Default
;	};
;
;DESCRIPTOR tx_get_config =
;	{
;	0x80,		// device-to-host, standard, device
;	0x08,		// Get Config
;	{0},		// wValue: 0 = Default
;	{0},		// wIndex: 0 = Default
;	{1}			// wLength: 1 = Default
;	};
;
;DESCRIPTOR tx_set_port_feature =
;	{
;	0x23,		// host-to-device, class, other
;	0x03,		// Set Feature
;	{0},		// wValue: Feature selector (set at run time)
;	{0},		// wIndex: Zero or Interface or Endpoint (1 for port 1)
;	{0},		// wLength: 0 bytes
;	};
;
;#define SET_PORT_FEATURE_POWER	0x08	// wValue.b.l
;#define SET_PORT_FEATURE_RESET	0x04	// wValue.b.l
;
;DESCRIPTOR tx_get_port_status =
;	{
;	0xa3,		// device-to-host, class, other
;	0x00,		// Get Status
;	{0},		// wValue: 0 = Default
;	{0},		// wIndex: Zero or Interface or Endpoint (1 for port 1)
;	{0x0004}	// wLength: 4 bytes
;	};
;
;DESCRIPTOR tx_enable_echo =
;	{
;	0x40,		// 
;	0x02,		// 
;	{0x001d},	// wValue: 
;	{0x0002},	// wIndex: 
;	{0x0000}	// wLength: 0 bytes
;	};
;
;
;typedef struct
;	{
;	BYTE	b[4];
;	} PORT_STATUS;
;
;PORT_STATUS	rx_port_status;
;
;BYTE rx_get_config;
;
;typedef struct
;	{
;	BYTE	bLength;
;	BYTE	bDescriptorType;
;	ONION	wTotalLength;
;	BYTE	bNumInterfaces;
;	BYTE	bConfigurationValue;
;	BYTE	iConfiguration;
;	BYTE	bmAttributes;
;	BYTE	bMaxPower;
;	BYTE	data[512]; //256 - 9];	// philips speakers need 183 bytes
;	} DESCRIPTION_CONFIG, *PDESCRIPTION_CONFIG;
;
;DESCRIPTION_CONFIG rx_desc_config;
;
;BYTE rx_null_packet[4] = {0x12,0x34,0x56,0x78};
;
;char UsbMenuString[] =
;			"\r\nUSB Menu\r\n"
;#if WANT_HARDWARE
;#if WANT_HOST
;			"a = Attach device at address 0 (10)\r\n"
;#endif // WANT_HOST
;			"c = Clear Int Stat\r\n"
;#if !WANT_LITE
;			"e = Enable echo test (50)\r\n"
;			"g = Get EP2 data\r\n"
;#endif
;#if WANT_HOST
;			"h = Host mode\r\n"
;#endif // WANT_HOST
;			"i = Init\r\n"
;			"l = Show last 16 packets\r\n"
;#if WANT_HOST
;			"p = Send test to printer\r\n"
;#endif // WANT_HOST
;#if !WANT_LITE
;			"q = Queue EP2 data\r\n"
;#endif
;//#if !WANT_LITE
;			"r = Register dump\r\n"
;//#endif //!WANT_LITE
;#if WANT_HOST
;			"s = read strings (30)\r\n"
;//			"s = Send sound\r\n"
;#if !WANT_LITE
;			"S = get port status\r\n"
;#endif
;			"t = Chapter 9 test (20)\r\n"
;#if !WANT_LITE
;			"T = Hub test (40)\r\n"
;#endif
;#endif // WANT_HOST
;			"v = Show internal variables\r\n"
;#if WANT_HOST
;			"w#### = number of ms to wait when resetting\r\n"
;#endif // WANT_HOST
;			"x = Return to top level menu\r\n"
;#if WANT_HOST
;			"z = Reset USB\r\n"
;#endif // WANT_HOST
;			"! = Dump next 16 interrupts\r\n"
;#endif
;			;
;
;
;void UsbCheckPrinter(void);
;#if WANT_HOST
;void UsbHost(void);
;void UsbHost2(void);
;#endif // WANT_HOST
;void UsbLast16(void);
;#if WANT_HOST
;void UsbPrint(void);
;void UsbSound(void);
;#endif
;void UsbVariables(void);
;
;void SetMetaStateWanted(BYTE s);
;void IncMetaStateWanted(void);
;void MetaState(void);
;void MetaState11(void);
;void MetaState12(void);
;void MetaState13(BYTE bJmp);
;void MetaState14(void);
;void MetaState15(void);
;void MetaState20(void);
;void MetaState21(BOOL bJmp);
;void MetaState22(void);
;void MetaState23(void);
;void MetaState24(void);
;void MetaState25(void);
;void MetaState26(void);
;void MetaState27(void);
;#if DEBUG_USB_STRINGS
;void MetaState30(void);
;void MetaState31(BOOL bJmp);
;void MetaState32(void);
;void UsbDumpString(PDESC_STRING pds);
;#endif // DEBUG_USB_STRINGS
;#if !WANT_LITE
;void MetaState40(void);
;void MetaState41(void);
;void MetaState42(void);
;void MetaState43(void);
;void MetaState44(void);
;void MetaState50(void);
;void MetaState51(void);
;void MetaState60(void);
;void MetaState61(void);
;#endif
;
;BYTE HostCreateNextControlByte(PBDT pBDT);
;void ParseConfig(void);
;void HostSetCurrentAddress(BYTE bAddress);
;#if DEBUG_USB_STRINGS
;BYTE USB_STRINGS_USED[32];
;void UseString(BYTE bString);
;#endif // DEBUG_USB_STRINGS
;void SendSetup(BYTE bAddr, PBYTE pTx, PBYTE pRx, WORD wLength);
;void HostSetNextOutBdt(WORD wLength, PBYTE p);
;void HostSetNextInBdt(WORD wLength, PBYTE p);
;
;
;void UsbMenu()
;{
;	static BYTE	c;
;	static WORD	w;
;
;	for (;;)
;		{
;		puts(UsbMenuString);
_UsbMenu:
		LDI r4,0x1b ;_UsbMenuString
		LDI r5,0x47 ;_UsbMenuString>>8
		JSR _puts
;		putFlush();
		JSR _putFlush
;input:
;		putc('$');
_UsbMenu__a:
		LDI r4,0x24
		JSR _putc
;
;		do	{
;			// check to see if we need to send more chars to the printer.
;			UsbCheckPrinter();
_UsbMenu__f:
		JSR _UsbLast16
;			
;			// send a character to the UART if there is one.
;			putFlushOneIfReady();
		JSR _putFlushOneIfReady
;
;			// check meta-state for something to do
;			if (USB_META_STATE)
		LDA r0,_USB_META_STATE
		BREQ _UsbMenu__24 ;(+0a)
;				if (USB_META_STATE_WANTED == USB_META_STATE)
		T0X r1
		LDA r0,_USB_META_STATE_WANTED
		CMP r1
		BRNE _UsbMenu__24 ;(+03)
;					MetaState();
		JSR _MetaState
;
;#if !WANT_LITE
;			if (bSomethingTodo == 1)
_UsbMenu__24:
		LDI r1,0x01
		LDA r0,_bSomethingTodo
		CMP r1
		BRNE _UsbMenu__36 ;(+0a)
;				{
;				bSomethingTodo++;
		LDA r0,_bSomethingTodo
		INC r0
		STA r0,_bSomethingTodo
;				MetaState60();
		JSR _MetaState60
;				}
;#endif
;
;			} while (!UartCharWaiting());
_UsbMenu__36:
		JSR _UartCharWaiting
		T0X r1
		BREQ _UsbMenu__f ;(-2d)
;
;		c = UartReadChar();
		JSR _UartReadChar
		STA r0,_psr+0x1b
;		putc(c);
		T0X r4
		JSR _putc
;		putCrlf();
		JSR _putCrlf
;
;		switch (c)
		JMP _UsbMenu__1ae
;			{
;#if WANT_HOST
;			case 'a':
;{
;ONION	o;
;
;putFlush();
;for (o.w=0x6000; o.w<0x7000; o.w++)
;	*o.pb = 'i';
;}	
;
;				USB_CURRENT_ADDR = 0;
;				MetaState10();
;				goto input;
;
;#endif // WANT_HOST
;
;			case 'c':
;				usb.intStatus = 0xff;
_UsbMenu__4c:
		LDI r0,0xff
		STA r0,_usb
;				putCrlf();
		JSR _putCrlf
;				goto input;
		JMP _UsbMenu__a
;
;#if !WANT_LITE
;			case 'e':
;				MetaState50();
_UsbMenu__57:
		JSR _MetaState50
;				goto input;
		JMP _UsbMenu__a
;
;			case 'g':
;			case 'q':
;				if (bSomethingTodo)
_UsbMenu__5d:
		LDA r0,_bSomethingTodo
		BREQ _UsbMenu__a3 ;(+41)
;					{
;					puts("todo ");
		LDI r4,0xf6 ;__Lstrings+0x26d
		LDI r5,0x3d ;__Lstrings+0x26d>>8
		JSR _puts
;					puts("contains ");
		LDI r4,0xe7 ;__Lstrings+0x25e
		LDI r5,0x3d ;__Lstrings+0x25e>>8
		JSR _puts
;					putws(todo.wLength);
		LDA r4,_todo
		LDA r5,_todo+0x1
		JSR _putws
;					putws((WORD)todo.pBuffer);
		LDA r4,_todo+0x2
		LDA r5,_todo+0x3
		JSR _putws
;					putbs(todo.bEndpointControl);
		LDA r4,_todo+0x5
		JSR _putbs
;					putbs(todo.bAddress);
		LDA r4,_todo+0x6
		JSR _putbs
;					putbs(todo.bTokenAndEndpoint);
		LDA r4,_todo+0x7
		JSR _putbs
;					putw(todo.wBC);
		LDA r4,_todo+0xa
		LDA r5,_todo+0xb
		JSR _putw
;					putCrlf();
		JSR _putCrlf
;					goto input;
		JMP _UsbMenu__a
;					}
;				
;				todo.wLength = sizeof(todoBuffer);
_UsbMenu__a3:
		STA r0,_todo+0x1
		LDI r0,0x40
		STA r0,_todo
;				todo.pBuffer = todoBuffer;
		LDI r0,0x4a
		STA r0,_todo+0x3
		LDI r0,0xa0
		STA r0,_todo+0x2
;				if (c == 'g')
		LDI r1,0x67
		LDA r0,_psr+0x1b
		XOR r1
		BRNE _UsbMenu__10b ;(+4e)
;					{
;					for (w=0; w<todo.wLength; w++)	// clear buffer so it will be obvious if we get what we want
		STA r0,_speed+0x2
		STA r0,_speed+0x1
		LDA r1,_todo
		CMP r1
		LDA r1,_todo+0x1
		LDA r0,_speed+0x2
		SBC r1
		BRCS _UsbMenu__fd ;(+2d)
;						todo.pBuffer[w] = 0;
_UsbMenu__d0:
		LDA r2,_speed+0x1
		LDA r3,_speed+0x2
		LDA r0,_todo+0x2
		LDA r1,_todo+0x3
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		XOR r0
		STX r2
		LDA r0,_speed+0x1
		LDA r1,_speed+0x2
		UPP r0
		STA r0,_speed+0x1
		STA r1,_speed+0x2
		LDA r1,_todo
		CMP r1
		LDA r1,_todo+0x1
		LDA r0,_speed+0x2
		SBC r1
		BRCC _UsbMenu__d0 ;(-2d)
;					todo.bEndpointControl = 0x0d;
_UsbMenu__fd:
		LDI r0,0x0d
		STA r0,_todo+0x5
;					todo.bAddress = 1;
		LDI r0,0x01
		STA r0,_todo+0x6
;					todo.bTokenAndEndpoint = 0x92;	// IN from EP2
		LDI r0,0x92
		BRNE _UsbMenu__15a ;(+4f)
;					todo.wBC = 0x20;
;					}
;				else
;					{
;					for (w=0; w<todo.wLength; w++)	// initialize buffer with ascending bytes
_UsbMenu__10b:
		XOR r0
		STA r0,_speed+0x2
		STA r0,_speed+0x1
		LDA r1,_todo
		CMP r1
		LDA r1,_todo+0x1
		LDA r0,_speed+0x2
		SBC r1
		BRCS _UsbMenu__14e ;(+2f)
;						todo.pBuffer[w] = (BYTE)w;
_UsbMenu__11f:
		LDA r2,_speed+0x1
		LDA r3,_speed+0x2
		LDA r0,_todo+0x2
		LDA r1,_todo+0x3
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDA r0,_speed+0x1
		STX r2
		LDA r0,_speed+0x1
		LDA r1,_speed+0x2
		UPP r0
		STA r0,_speed+0x1
		STA r1,_speed+0x2
		LDA r1,_todo
		CMP r1
		LDA r1,_todo+0x1
		LDA r0,_speed+0x2
		SBC r1
		BRCC _UsbMenu__11f ;(-2f)
;					todo.bEndpointControl = 0x0d;
_UsbMenu__14e:
		LDI r0,0x0d
		STA r0,_todo+0x5
;					todo.bAddress = 1;
		LDI r0,0x01
		STA r0,_todo+0x6
;					todo.bTokenAndEndpoint = 0x12;	// OUT to EP2
		LDI r0,0x12
_UsbMenu__15a:
		STA r0,_todo+0x7
;					todo.wBC = 0x20;
		XOR r0
		STA r0,_todo+0xb
		LDI r0,0x20
		STA r0,_todo+0xa
;					}
;
;				bSomethingTodo = 1;
		LDI r0,0x01
		STA r0,_bSomethingTodo
;				goto input;
		JMP _UsbMenu__a
;#endif
;
;#if WANT_HOST
;			case 'H':
;				UsbHost2();
;				goto input;
;
;			case 'h':
;				UsbHost();
;				goto input;
;#endif // WANT_HOST
;
;			case 'i':
;				UsbInit();
_UsbMenu__16e:
		JSR _UsbInit
;				usb.intEnable = 1;				// enable only bus reset
		LDI r0,0x01
		STA r0,_usb+0x1
;
;				goto input;
		JMP _UsbMenu__a
;
;			case 'l':
;				UsbLast16();
_UsbMenu__179:
		JSR _UsbLast16
;				goto input;
		JMP _UsbMenu__a
;
;#if WANT_HOST
;			case 'p':
;				UsbPrint();
;				goto input;
;#endif // WANT_HOST
;
;			case 'r':
;#if WANT_LITE
;				putbs(usb.intStatus);
;				putbs(usb.intEnable);
;				putbs(usb.errorStatus);
;				putbs(usb.errorEnable);
;				putbs(usb.status);
;				putbs(usb.control);
;				putbs(usb.address);
;				putb(usb.bdtPage);
;				putCrlf();
;#else
;				HostDumpRegs();
_UsbMenu__17f:
		JSR _HostDumpRegs
;#endif //!WANT_LITE
;				goto input;
		JMP _UsbMenu__a
;
;#if DEBUG_USB_STRINGS
;			case 's':
;				MetaState30();
;				goto input;
;#endif
;
;#if WANT_HOST
;//			case 's':
;//				UsbSound();
;//				goto input;
;				
;
;#if !WANT_LITE
;			case 'S':
;				SetMetaStateWanted(0x43);
;				MetaState43();
;				goto input;
;#endif
;
;			case 't':
;				MetaState20();
;				goto input;
;
;#if !WANT_LITE
;			case 'T':
;				MetaState40();
;				goto input;
;#endif
;
;#endif // WANT_HOST
;
;			case 'v':
;				UsbVariables();
_UsbMenu__185:
		JSR _UsbVariables
;				goto input;
		JMP _UsbMenu__a
;
;#if WANT_HOST
;			case 'w':
;				puts("\r\nWait was ");
;				puto(HOST_WAIT);
;				putc('>');
;				if (w = UartReadHexWord())
;					HOST_WAIT.w = w;
;				goto input;
;#endif // WANT_HOST
;
;
;			case 'x':
;				return;
_UsbMenu__18b:
		RTS
;
;#if WANT_HOST
;			case 'z':
;
;				usb.control = MASK_CTL_HOST_MODE_EN;
;// delay while hardware state machines complete
;				for (w=0; w<100; w++)
;					w=w;
;
;				usb.control =0;
;				usb.intEnable = 0;
;				usb.intStatus = 0xff;
;
;				UsbInit();
;
;				USB_OUT = 0x0c;	// addr of odd data out
;				USB_IN = 0x04;	// addr of odd data in
;
;//				usb.intStatus = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF;
;//				usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF;
;//				usb.control = MASK_CTL_HOST_MODE_EN;
;
;				usb.errorEnable = 0xff;	// enable all errors
;
;				usb.bdtPage = (BYTE)(((WORD)USB_BDT_PAGE) >> 8);
;
;			// now reset the USB\
;#if DEBUG_USB_ATTACH
;	puts("INIT RST");
;	putCrlf();
;	putFlush();
;#endif
;
;				usb.control = MASK_CTL_RESET | MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN;
;				HostDelay(); // Wait for some ms
;#if DEBUG_USB_ATTACH
;	puts("END RESET");
;	putCrlf();
;	putFlush();
;#endif
;	UsbHost();
;
;//  				usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN; // Send SOF's 
;//  				HostDelay();  // For some ms 
;//  #if DEBUG_USB_ATTACH 
;//  	puts("START ENUM"); 
;//  	putCrlf(); 
;//  	putFlush(); 
;//  #endif 
;//  				USB_ARE_WE_ATTACHED = 1; 
;
;//  			// enumerate the bus 
;
;//  				usb.intStatus = INT_STAT_MASK_TOKEN_DONE | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET; 
;//  				usb.intEnable = INT_STAT_MASK_TOKEN_DONE | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET; 
;
;//  				MetaState10(); 
;				goto input;
;#endif // WANT_HOST
;
;#if USB_DELAY_TOKEN && 0
;			case 'z':
;				if (USB_BUFFERED)
;					{
;					USB_BUFFERED = FALSE;
;					puts("z: ");
;					putbs(USB_BUFFERED_ADDRESS);
;					putbs(USB_BUFFERED_TOKEN);
;					putb(USB_BUFFERED_TYPE);
;					putCrlf();
;					ReallySendToken(USB_BUFFERED_ADDRESS, USB_BUFFERED_TOKEN, USB_BUFFERED_TYPE);
;					USB_BUFFERED_ADDRESS = 0xee;
;					USB_BUFFERED_TOKEN = 0xdd;
;					USB_BUFFERED_TYPE = 0xcc;
;					}
;				else
;					putc('\a');
;				goto input;
;#endif
;
;			case '!':
;				USB_DUMP_COUNT += 16;
_UsbMenu__18c:
		LDI r1,0x10
		LDA r0,_USB_DUMP_COUNT
		ADD r1
		STA r0,_USB_DUMP_COUNT
;				putb(USB_DUMP_COUNT);
		T0X r4
		JSR _putb
;				putCrlf();
		JSR _putCrlf
;				goto input;
		JMP _UsbMenu__a
;
;			case ':':
;				DOWNLOAD();		// won't return
_UsbMenu__19f:
		JSR _DOWNLOAD
;				continue;
		JMP _UsbMenu
;
;			default:
;				putUnknown(c);
_UsbMenu__1a5:
		LDA r4,_psr+0x1b
		JSR _putUnknown
;				continue;
		JMP _UsbMenu
_UsbMenu__1ae:
		LDA r0,_psr+0x1b
		LDI r4,0xdf
		ADD r4
		BREQ _UsbMenu__18c ;(-2a)
		LDI r4,0xe7
		ADD r4
		BREQ _UsbMenu__19f ;(-1c)
		LDI r4,0xd7
		ADD r4
		BRNE _UsbMenu__1c3 ;(+03)
		JMP _UsbMenu__4c
_UsbMenu__1c3:
		DEC r0
		DEC r0
		BRNE _UsbMenu__1ca ;(+03)
		JMP _UsbMenu__57
_UsbMenu__1ca:
		DEC r0
		DEC r0
		BRNE _UsbMenu__1d1 ;(+03)
		JMP _UsbMenu__5d
_UsbMenu__1d1:
		DEC r0
		DEC r0
		BREQ _UsbMenu__16e ;(-67)
		LDI r4,0xfd
		ADD r4
		BREQ _UsbMenu__179 ;(-61)
		LDI r4,0xfb
		ADD r4
		BRNE _UsbMenu__1e2 ;(+03)
		JMP _UsbMenu__5d
_UsbMenu__1e2:
		DEC r0
		BREQ _UsbMenu__17f ;(-66)
		LDI r4,0xfc
		ADD r4
		BREQ _UsbMenu__185 ;(-65)
		DEC r0
		DEC r0
		BREQ _UsbMenu__18b ;(-63)
		JMP _UsbMenu__1a5
;			}
;
;		}
;}
;
;void UsbCheckPrinter(void)
;{
;
;}
;
;#if WANT_HOST
;void UsbHost(void)
;{
;
;	USB_HOST_STATE =		0;
;	USB_CURRENT_ADDR =		0;	// last address assigned
;	USB_NEXT_ADDR =			1;	// next address to assign
;	USB_CURRENT_CONFIG =	0;	// used for looping
;	USB_NUM_CONFIGS =		0;
;	USB_ARE_WE_ATTACHED =	0;
;//	USB_POLL_COUNT.w =		0;
;	rx_buffer.w =			0;
;	USB_IN_SO_FAR =			0;
;	USB_NEXT_DATA01 =		0;
;	USB_META_STATE_WANTED =	0;
;	USB_META_STATE =		0;
;
;// insert the interrupt service routine into the proper vector
;	Interrupt1 = (WORD)UsbHostIntService;
;
;	usb.intEnable = 0x00;		// disable all interrupts for now
;	usb.intStatus = 0xff;		// clear previous interrupts
;
;	usb.control = MASK_CTL_ODD_RST;
;	usb.control = MASK_CTL_EN_HOST;
;
;	ENDPT_HOST_RG = ENDPT_CONTROL;	// enable ep0
;
;	usb.sofThresholdLo = 0xff;
;
;#if DEBUG_USB_ATTACH
;	puts("");	// fixes overlapping interrupt problem
;	puts("Enabling Attach interrupt");
;	putCrlf();
;	putFlush();
;#endif
;
;#if USB_DELAY_TOKEN
;	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET;
;#else
;	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_RESET;
;#endif
;
;	return;
;}
;
;void UsbHost2(void)
;{
;	usb.control = MASK_CTL_ODD_RST;
;	usb.control = MASK_CTL_EN_HOST;
;
;#if USB_DELAY_TOKEN
;	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET;
;#else
;	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_RESET;
;#endif
;
;	return;
;}
;#endif // WANT_HOST
;
;
;void UsbLast16(void)
;{
_UsbLast16:
		RTS
;
;}
;
;#if WANT_HOST
;void UsbPrint(void)
;{
;
;}
;
;void UsbSound(void)
;{
;
;	bSawtooth = !bSawtooth;
;
;	if (bSawtooth)
;		puts(" ON\r\n");
;	else
;		puts(" OFF\r\n");
;}
;#endif // WANT_HOST
;
;void UsbVariables(void)
;{
;	static BYTE	i, j;
;	static PBDT	pBDT;
;
;	pBDT = (PBDT)USB_BDT_PAGE;
_UsbVariables:
		LDI r0,0x70
		STA r0,_speed+0x4
		LDI r0,0x00
		STA r0,_speed+0x3
;	for (i=0; i<4; i++)
		XOR r0
		STA r0,_psr+0x1c
		LDI r1,0x04
		LDA r0,_psr+0x1c
		CMP r1
		BRCS _UsbVariables__89 ;(+73)
;		{
;		for (j=0; j<4; j++)
_UsbVariables__16:
		XOR r0
		STA r0,_psr+0x1d
		LDI r1,0x04
		LDA r0,_psr+0x1d
		CMP r1
		BRCS _UsbVariables__77 ;(+55)
;			{
;			putw((WORD)pBDT);
_UsbVariables__22:
		LDA r4,_speed+0x3
		LDA r5,_speed+0x4
		JSR _putw
;			putc('>');
		LDI r4,0x3e
		JSR _putc
;			putbs(pBDT->pid);
		LDA r2,_speed+0x3
		LDA r3,_speed+0x4
		LDX r2
		T0X r4
		JSR _putbs
;			putbs(pBDT->bc);
		LDA r2,_speed+0x3
		LDA r3,_speed+0x4
		LDO r2,0x01
		T0X r4
		JSR _putbs
;			putos(pBDT->addr);
		LDA r2,_speed+0x3
		LDA r3,_speed+0x4
		LDO r2,0x02
		T0X r4
		LDO r2,0x03
		T0X r5
		JSR _putos
;			pBDT++;
		LDA r0,_speed+0x3
		LDI r1,0x04
		ADD r1
		STA r0,_speed+0x3
		LDA r0,_speed+0x4
		LDI r1,0x00
		ADC r1
		STA r0,_speed+0x4
		LDA r0,_psr+0x1d
		INC r0
		STA r0,_psr+0x1d
		LDI r1,0x04
		LDA r0,_psr+0x1d
		CMP r1
		BRCC _UsbVariables__22 ;(-55)
;			}
;		putCrlf();
_UsbVariables__77:
		JSR _putCrlf
		LDA r0,_psr+0x1c
		INC r0
		STA r0,_psr+0x1c
		LDI r1,0x04
		LDA r0,_psr+0x1c
		CMP r1
		BRCC _UsbVariables__16 ;(-73)
;		}
;
;	puts("USB_HOST_STATE = ");
_UsbVariables__89:
		LDI r4,0x90 ;__Lstrings+0x307
		LDI r5,0x3e ;__Lstrings+0x307>>8
		JSR _puts
;	putb(USB_HOST_STATE);
		LDA r4,_USB_HOST_STATE
		JSR _putb
;	putCrlf();
		JSR _putCrlf
;	puts("USB_META_STATE_WANTED = ");
		LDI r4,0xb4 ;__Lstrings+0x32b
		LDI r5,0x3e ;__Lstrings+0x32b>>8
		JSR _puts
;	putb(USB_META_STATE_WANTED);
		LDA r4,_USB_META_STATE_WANTED
		JSR _putb
;	putCrlf();
		JSR _putCrlf
;	puts("USB_META_STATE = ");
		LDI r4,0xa2 ;__Lstrings+0x319
		LDI r5,0x3e ;__Lstrings+0x319>>8
		JSR _puts
;	putb(USB_META_STATE);
		LDA r4,_USB_META_STATE
		JSR _putb
;	putCrlf();
		JMP _putCrlf
;
;	return;
;}
;
;
;BYTE HostCreateNextControlByte(PBDT pBDT)
;{
;	static BYTE	b;
;
;	b = USB_NEXT_DATA01 | 0x80;
_HostCreateNextControlByte:
		LDI r1,0x80
		LDA r0,_USB_NEXT_DATA01
		OR  r1
		STA r0,_psr+0x1e
;	USB_NEXT_DATA01 ^= 0x40;
		LDI r1,0x40
		LDA r0,_USB_NEXT_DATA01
		XOR r1
		STA r0,_USB_NEXT_DATA01
;
;	return b;
		LDA r0,_psr+0x1e
		RTS
;}
;
;void SetMetaStateWanted(BYTE s)
;{
;
;	USB_META_STATE_WANTED = s;
_SetMetaStateWanted:
		STA r4,_USB_META_STATE_WANTED
;	if (s)
		TX0 r4
		BREQ _SetMetaStateWanted__7 ;(+01)
;		s--;
		DEC r4
;	USB_META_STATE = s;
_SetMetaStateWanted__7:
		STA r4,_USB_META_STATE
;	return;
		RTS
;}
;
;void IncMetaStateWanted()
;{
;
;	SetMetaStateWanted(USB_META_STATE_WANTED+1);
_IncMetaStateWanted:
		LDA r4,_USB_META_STATE_WANTED
		INC r4
		JMP _SetMetaStateWanted
;	return;
;}
;
;void ResetMetaStateWanted()
;{
;
;	SetMetaStateWanted(0);
_ResetMetaStateWanted:
		LDI r4,0x00
		BREQ _SetMetaStateWanted ;(-16)
;	return;
		RTS
;}
;
;void MetaState(void)
;{
_MetaState:
		JMP _MetaState__2a
;
;#if DEBUG_META_STATES
;//	if (debug.bits.HostState)
;		{
;		puts("MetaState:");
;		putb(USB_META_STATE);
;		putCrlf();
;		putFlush();
;		}
;#endif
;
;	switch (USB_META_STATE)
;		{
;		case 0x11:	MetaState11();	break; // send get_desc_device (entire structure)
;		case 0x12:	MetaState12();	break; // set address
;		case 0x13:	MetaState13(FALSE);	break;// send get_desc_config
_MetaState__3:
		T0X r4
		JMP _MetaState13
;		case 0x14:	MetaState14();	break; // set configuration value
;		case 0x15:	MetaState15();	break; // enumeration complete
;
;		case 0x21:	MetaState21(FALSE);	break;// send get_desc_config
_MetaState__7:
		T0X r4
		JMP _MetaState21
;		case 0x22:	MetaState22();	break; // set configuration value
;		case 0x23:	MetaState23();	break; // set configuration value to 0
;		case 0x24:	MetaState24();	break; // get configuration value
;		case 0x25:	MetaState25();	break; // check value and set configuation
;		case 0x26:	MetaState26();	break; // get configuration value
;		case 0x27:	MetaState27();	break; // check value and complete test
;
;#if DEBUG_USB_STRINGS
;		case 0x31:	MetaState31(FALSE);	break;
;		case 0x32:	MetaState32();	break;
;#endif // DEBUG_USB_STRINGS
;
;#if !WANT_LITE
;		case 0x41:	MetaState41();	break; // send get_status, port
;		case 0x42:	MetaState42();	break; // show port status, then send set_feature, port 1, reset
;		case 0x43:	MetaState43();	break; // send get_status, port
;		case 0x44:	MetaState44();	break; // show port status
;
;		case 0x51:	MetaState51();	break; // 
;
;		case 0x61:	MetaState61();	break; // 
;#endif
;
;		default:
;			puts("Invalid meta state:");
_MetaState__b:
		LDI r4,0xb1 ;__Lstrings+0x228
		LDI r5,0x3d ;__Lstrings+0x228>>8
		JSR _puts
;			putb(USB_META_STATE);
		LDA r4,_USB_META_STATE
		JSR _putb
;			putc('/');
		LDI r4,0x2f
		JSR _putc
;			putb(USB_META_STATE_WANTED);
		LDA r4,_USB_META_STATE_WANTED
		JSR _putb
;			puts("\r\n\a");
		LDI r4,0xde ;__Lstrings+0x455
		LDI r5,0x3f ;__Lstrings+0x455>>8
		JMP _puts
_MetaState__2a:
		LDA r0,_USB_META_STATE
		LDI r4,0xef
		ADD r4
		BRNE _MetaState__35 ;(+03)
		JMP _MetaState11
_MetaState__35:
		DEC r0
		BRNE _MetaState__3b ;(+03)
		JMP _MetaState12
_MetaState__3b:
		DEC r0
		BREQ _MetaState__3 ;(-3b)
		DEC r0
		BRNE _MetaState__44 ;(+03)
		JMP _MetaState14
_MetaState__44:
		DEC r0
		BRNE _MetaState__4a ;(+03)
		JMP _MetaState15
_MetaState__4a:
		LDI r4,0xf4
		ADD r4
		BREQ _MetaState__7 ;(-48)
		DEC r0
		BRNE _MetaState__55 ;(+03)
		JMP _MetaState22
_MetaState__55:
		DEC r0
		BRNE _MetaState__5b ;(+03)
		JMP _MetaState23
_MetaState__5b:
		DEC r0
		BRNE _MetaState__61 ;(+03)
		JMP _MetaState26
_MetaState__61:
		DEC r0
		BRNE _MetaState__67 ;(+03)
		JMP _MetaState25
_MetaState__67:
		DEC r0
		BRNE _MetaState__6d ;(+03)
		JMP _MetaState26
_MetaState__6d:
		DEC r0
		BRNE _MetaState__73 ;(+03)
		JMP _MetaState27
_MetaState__73:
		LDI r4,0xe6
		ADD r4
		BRNE _MetaState__7b ;(+03)
		JMP _MetaState43
_MetaState__7b:
		DEC r0
		BRNE _MetaState__81 ;(+03)
		JMP _MetaState42
_MetaState__81:
		DEC r0
		BRNE _MetaState__87 ;(+03)
		JMP _MetaState43
_MetaState__87:
		DEC r0
		BRNE _MetaState__8d ;(+03)
		JMP _MetaState44
_MetaState__8d:
		LDI r4,0xf3
		ADD r4
		BRNE _MetaState__95 ;(+03)
		JMP _MetaState51
_MetaState__95:
		LDI r4,0xf0
		ADD r4
		BRNE _MetaState__9d ;(+03)
		JMP _MetaState61
_MetaState__9d:
		JMP _MetaState__b
;			return;
;		}
;
;	return;
;}
;
;void MetaState10(void)	// send get_desc_device (first 8 bytes)
;{
;
;	SetMetaStateWanted(0x10);
_MetaState10:
		LDI r4,0x10
		JSR _SetMetaStateWanted
;	tx_get_desc_device.wLength.w = 8;
		XOR r0
		STA r0,_tx_get_desc_device+0x7
		LDI r0,0x08
		STA r0,_tx_get_desc_device+0x6
;	SendSetup(0|speed, (PBYTE)&tx_get_desc_device, (PBYTE)&rx_desc_device, USB_PACKET_LENGTH_8);
		LDI r0,0x4a
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x8e
		STA r0,Aa_UsbVendSetEndPoint
		LDI r0,0xff
		STA r0,Aa_UartReadString+0x1
		LDI r0,0xf8
		BRNE _MetaState11__2c ;(+2c)
;	return;
;}
;
;void MetaState11(void)	// send get_desc_device (entire structure)
;{
;#if WANT_HARDWARE
;putFlush();
_MetaState11:
		JSR _putFlush
;puts("\r\nMetaState11: about to doAReset()\r\n");
		LDI r4,0x8f ;__Lstrings+0x406
		LDI r5,0x3f ;__Lstrings+0x406>>8
		JSR _puts
;putFlush();
		JSR _putFlush
;	doAReset();
		JSR _doAReset
;#endif // WANT_HARDWARE
;
;// now get the whole descriptor.
;
;	tx_get_desc_device.wLength.w = rx_desc_device.bLength;
		LDA r0,_rx_desc_device
		LDI r1,0x00
		STA r1,_tx_get_desc_device+0x7
		STA r0,_tx_get_desc_device+0x6
;	SendSetup(0|speed, (PBYTE)&tx_get_desc_device, (PBYTE)&rx_desc_device, USB_PACKET_LENGTH_BYTE0);
		LDI r0,0x4a
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x8e
		STA r0,Aa_UsbVendSetEndPoint
		LDI r0,0xff
		STA r0,Aa_UartReadString+0x1
		LDI r0,0xf1
_MetaState11__2c:
		STA r0,Aa_UartReadString
		LDI r2,0xd7 ;_tx_get_desc_device
		LDI r3,0x46 ;_tx_get_desc_device>>8
		LDA r4,_speed
		JMP _SendSetup
;	return;
;}
;
;void MetaState12(void)	// set address
;{
;
;	USB_NUM_CONFIGS = rx_desc_device.bNumConfigurations;
_MetaState12:
		LDA r0,_rx_desc_device+0x11
		STA r0,_USB_NUM_CONFIGS
;
;	if (tx_set_addr.bRequest != 5)
		LDI r1,0x05
		LDA r0,_tx_set_addr+0x1
		CMP r1
		BREQ _MetaState12__1a ;(+0c)
;		{
;		puts("Value hosed\r\n");
		LDI r4,0x81 ;__Lstrings+0x3f8
		LDI r5,0x3f ;__Lstrings+0x3f8>>8
		JSR _puts
;		tx_set_addr.bRequest = 5;
		LDI r0,0x05
		STA r0,_tx_set_addr+0x1
;		}
;
;	tx_set_addr.wValue.b.l = USB_NEXT_ADDR++;
_MetaState12__1a:
		LDA r0,_USB_NEXT_ADDR
		STA r0,_tx_set_addr+0x2
		LDA r0,_USB_NEXT_ADDR
		INC r0
		STA r0,_USB_NEXT_ADDR
;
;	SendSetup(0|speed, (PBYTE)&tx_set_addr, (PBYTE)&rx_desc_device, USB_PACKET_LENGTH_0);
		LDI r0,0x4a
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x8e
		STA r0,Aa_UsbVendSetEndPoint
		LDI r0,0xff
		STA r0,Aa_UartReadString+0x1
		LDI r0,0xf0
		STA r0,Aa_UartReadString
		LDI r2,0x14 ;_tx_set_addr
		LDI r3,0x4a ;_tx_set_addr>>8
		LDA r4,_speed
		JMP _SendSetup
;
;	return;
;}
;
;void MetaState13(BYTE bJmp)	// send get_desc_config
;{
;
;	if (!bJmp)
_MetaState13:
		TX0 r4
		BRNE _MetaState13__9 ;(+06)
;		{
;		USB_CURRENT_CONFIG = 0;
		STA r0,_USB_CURRENT_CONFIG
;		}
		JMP _MetaState21__24
;	else
;		{
;		SetMetaStateWanted(0x13);
_MetaState13__9:
		LDI r4,0x13
		JMP _MetaState21__21
;		}
;
;	tx_get_desc_config.wIndex.b.l = USB_CURRENT_CONFIG;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_desc_config, (PBYTE)&rx_desc_config, USB_PACKET_LENGTH_BYTE23);
;	return;
;}
;
;void MetaState14(void) // set configuration value
;{
;
;	ParseConfig();
_MetaState14:
		JSR _ParseConfig
;
;	puts("Configured device:");
		LDI r4,0xc5 ;__Lstrings+0x23c
		LDI r5,0x3d ;__Lstrings+0x23c>>8
		JSR _puts
;	putb(USB_CURRENT_CONFIG);
		LDA r4,_USB_CURRENT_CONFIG
		JSR _putb
;	putc('-');
		LDI r4,0x2d
		JSR _putc
;	putb(rx_desc_device.bNumConfigurations);
		LDA r4,_rx_desc_device+0x11
		JSR _putb
;	putCrlf();
		JSR _putCrlf
;	putFlush();
		JSR _putFlush
;
;	if ((USB_CURRENT_CONFIG+1) < rx_desc_device.bNumConfigurations)
		LDA r2,_rx_desc_device+0x11
		LDA r0,_USB_CURRENT_CONFIG
		LDI r1,0x00
		UPP r0
		CMP r2
		LDI r0,0x80
		T0X r3
		XOR r1
		SBC r3
		BRCC _MetaState14__35 ;(+03)
		JMP _MetaState22__3e
;		{
;		USB_CURRENT_CONFIG++;
_MetaState14__35:
		LDA r0,_USB_CURRENT_CONFIG
		INC r0
		STA r0,_USB_CURRENT_CONFIG
;		MetaState13(TRUE);
		LDI r4,0x01
		BRNE _MetaState13 ;(-4e)
;		return;
		RTS
;		}
;
;	tx_set_config.wValue.b.l = 1;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_config, rx_null_packet, USB_PACKET_LENGTH_0);
;
;	return;
;}
;
;void MetaState15(void)
;{
;
;	puts("Host mode init is done\r\n");
_MetaState15:
		LDI r4,0x59 ;__Lstrings+0x3d0
		LDI r5,0x3f ;__Lstrings+0x3d0>>8
		JSR _puts
;	ResetMetaStateWanted();
		JMP _ResetMetaStateWanted
;
;	return;
;}
;
;void MetaState20(void)
;{
;
;//	USB_DUMP_COUNT = 0x40;
;
;	puts("\r\nStarting Chapter 9 test on address 1!\r\n");
_MetaState20:
		LDI r4,0xb4 ;__Lstrings+0x42b
		LDI r5,0x3f ;__Lstrings+0x42b>>8
		JSR _puts
;	SetMetaStateWanted(0x20);
		LDI r4,0x20
		JSR _SetMetaStateWanted
;	HostSetCurrentAddress(1|speed);
		LDI r1,0x01
		LDA r0,_speed
		OR  r1
		T0X r4
		JSR _HostSetCurrentAddress
;
;#if 0
;	// there, we've now added the low speed bit (if needed) to the address.
;	// speed should not be used again until another attach sets it.
;	// I've set it to 0xaa to hopefully make it obvious if it gets used again.
;//	speed = 0xaa;
;//#else
;//	speed = 0x80;
;#endif
;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_desc_device, (PBYTE)&rx_desc_device, USB_PACKET_LENGTH_BYTE0);
		LDI r0,0x4a
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x8e
		STA r0,Aa_UsbVendSetEndPoint
		LDI r0,0xff
		STA r0,Aa_UartReadString+0x1
		LDI r0,0xf1
		STA r0,Aa_UartReadString
		LDI r2,0xd7 ;_tx_get_desc_device
		LDI r3,0x46 ;_tx_get_desc_device>>8
		LDA r4,_USB_CURRENT_ADDR
		JMP _SendSetup
;	return;
;}
;
;void MetaState21(BOOL bJmp)
;{
;
;	if (!bJmp)
_MetaState21:
		TX0 r4
		BRNE _MetaState21__1f ;(+1c)
;		{
;		USB_NUM_CONFIGS = rx_desc_device.bNumConfigurations;
		LDA r0,_rx_desc_device+0x11
		STA r0,_USB_NUM_CONFIGS
;
;#if DEBUG_DEVICE_DESC
;	puts("\r\nDEVICE DESCRIPTOR\r\nbLength=");
;	putb(rx_desc_device.bLength);
;	puts("\r\nbDescriptorType=");
;	putb(rx_desc_device.bDescriptorType);
;	puts("\r\nbcdUSB=");
;	putw(rx_desc_device.bcdUSB);
;	puts("\r\nbDeviceClass=");
;	putb(rx_desc_device.bDeviceClass);
;	puts("\r\nbDeviceSubClass=");
;	putb(rx_desc_device.bDeviceSubClass);
;	puts("\r\nbDeviceProtocol=");
;	putb(rx_desc_device.bDeviceProtocol);
;	puts("\r\nbMaxPacketSize0=");
;	putb(rx_desc_device.bMaxPacketSize0);
;	puts("\r\nidVendor=");
;	putw(rx_desc_device.idVendor);
;	puts("\r\nidProduct=");
;	putw(rx_desc_device.idProduct);
;	puts("\r\nbcdDevice=");
;	putb(rx_desc_device.bcdDevice);
;	puts("\r\niManufacturer=");
;	putb(rx_desc_device.iManufacturer);
;	puts("\r\niProduct=");
;	putb(rx_desc_device.iProduct);
;	puts("\r\niSerialNumber=");
;	putb(rx_desc_device.iSerialNumber);
;	puts("\r\nbNumConfigurations=");
;	putb(rx_desc_device.bNumConfigurations);
;	putCrlf();
;	putCrlf();
;#endif
;
;	bItsAHub = (rx_desc_device.bDeviceClass == 0x09);
		LDI r1,0x09
		LDA r0,_rx_desc_device+0x4
		XOR r1
		BRNE _MetaState21__15 ;(+04)
		LDI r0,0x01
		BRNE _MetaState21__16 ;(+01)
_MetaState21__15:
		XOR r0
_MetaState21__16:
		STA r0,_bItsAHub
;
;#if DEBUG_USB_STRINGS
;		UseString(rx_desc_device.iManufacturer);
;		UseString(rx_desc_device.iProduct);
;		UseString(rx_desc_device.iSerialNumber);
;#endif
;
;		USB_CURRENT_CONFIG = 0;
		XOR r0
		STA r0,_USB_CURRENT_CONFIG
;		}
		BREQ _MetaState21__24 ;(+05)
;	else
;		{
;		SetMetaStateWanted(0x21);
_MetaState21__1f:
		LDI r4,0x21
_MetaState21__21:
		JSR _SetMetaStateWanted
;		}
;
;	tx_get_desc_config.wIndex.b.l = USB_CURRENT_CONFIG;
_MetaState21__24:
		LDA r0,_USB_CURRENT_CONFIG
		STA r0,_tx_get_desc_config+0x4
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_desc_config, (PBYTE)&rx_desc_config, USB_PACKET_LENGTH_BYTE23);
		LDI r0,0x4a
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0xe0
		STA r0,Aa_UsbVendSetEndPoint
		LDI r0,0xff
		STA r0,Aa_UartReadString+0x1
		LDI r0,0xf2
		STA r0,Aa_UartReadString
		LDI r2,0xdf ;_tx_get_desc_config
		LDI r3,0x46 ;_tx_get_desc_config>>8
		LDA r4,_USB_CURRENT_ADDR
		JMP _SendSetup
;	return;
;}
;
;void MetaState22(void)     // send get_desc_config
;{
;
;	ParseConfig();
_MetaState22:
		JSR _ParseConfig
;
;	puts("Configured device:");
		LDI r4,0xc5 ;__Lstrings+0x23c
		LDI r5,0x3d ;__Lstrings+0x23c>>8
		JSR _puts
;	putb(USB_CURRENT_CONFIG);
		LDA r4,_USB_CURRENT_CONFIG
		JSR _putb
;	putc('-');
		LDI r4,0x2d
		JSR _putc
;	putb(rx_desc_device.bNumConfigurations);
		LDA r4,_rx_desc_device+0x11
		JSR _putb
;	putCrlf();
		JSR _putCrlf
;	putFlush();
		JSR _putFlush
;
;	if ((USB_CURRENT_CONFIG+1) < rx_desc_device.bNumConfigurations)
		LDA r2,_rx_desc_device+0x11
		LDA r0,_USB_CURRENT_CONFIG
		LDI r1,0x00
		UPP r0
		CMP r2
		LDI r0,0x80
		T0X r3
		XOR r1
		SBC r3
		BRCS _MetaState22__3e ;(+0c)
;		{
;		USB_CURRENT_CONFIG++;
		LDA r0,_USB_CURRENT_CONFIG
		INC r0
		STA r0,_USB_CURRENT_CONFIG
;		MetaState21(TRUE);
		LDI r4,0x01
		JMP _MetaState21
;		return;
;		}
;
;	tx_set_config.wValue.b.l = 1;
_MetaState22__3e:
		LDI r0,0x01
		BRNE _MetaState25__22 ;(+28)
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_config, rx_null_packet, USB_PACKET_LENGTH_0);
;	return;
;}
;
;void MetaState23(void)   // set configuration value to 0
;{
;
;	tx_set_config.wValue.b.l = 0;
_MetaState23:
		XOR r0
		BREQ _MetaState25__22 ;(+25)
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_config, rx_null_packet, USB_PACKET_LENGTH_0);
;	return;
;}
;
;void MetaState24(void) // get configuration value
;{
_MetaState24:
		JMP _MetaState26
;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_config, &rx_get_config, 1);
;	return;
;}
;
;void MetaState25(void) // check value and set configuation
;{
;
;	puts("Configured device:");
_MetaState25:
		LDI r4,0xc5 ;__Lstrings+0x23c
		LDI r5,0x3d ;__Lstrings+0x23c>>8
		JSR _puts
;	putb(rx_get_config);
		LDA r4,_rx_get_config
		JSR _putb
;	putCrlf();
		JSR _putCrlf
;
;	if (rx_get_config)
		LDA r0,_rx_get_config
		BREQ _MetaState25__1c ;(+07)
;		puts("Should have been zero\r\n");
		LDI r4,0x41 ;__Lstrings+0x3b8
		LDI r5,0x3f ;__Lstrings+0x3b8>>8
		JSR _puts
;
;	putFlush();
_MetaState25__1c:
		JSR _putFlush
;	tx_set_config.wValue.b.l = USB_CURRENT_CONFIG;
		LDA r0,_USB_CURRENT_CONFIG
_MetaState25__22:
		STA r0,_tx_set_config+0x2
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_config, rx_null_packet, USB_PACKET_LENGTH_0);
		LDI r0,0x47
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x17
		STA r0,Aa_UsbVendSetEndPoint
		LDI r0,0xff
		STA r0,Aa_UartReadString+0x1
		LDI r0,0xf0
		STA r0,Aa_UartReadString
		LDI r2,0xef ;_tx_set_config
		LDI r3,0x46 ;_tx_set_config>>8
		LDA r4,_USB_CURRENT_ADDR
		JMP _SendSetup
;
;	return;
;}
;
;void MetaState26(void)  // get configuration value
;{
;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_config, &rx_get_config, 1);
_MetaState26:
		LDI r0,0x4a
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x66
		STA r0,Aa_UsbVendSetEndPoint
		XOR r0
		STA r0,Aa_UartReadString+0x1
		INC r0
		STA r0,Aa_UartReadString
		LDI r2,0xf7 ;_tx_get_config
		LDI r3,0x46 ;_tx_get_config>>8
		LDA r4,_USB_CURRENT_ADDR
		JMP _SendSetup
;	return;
;}
;
;void MetaState27(void)
;{
;
;	puts("Configured device:");
_MetaState27:
		LDI r4,0xc5 ;__Lstrings+0x23c
		LDI r5,0x3d ;__Lstrings+0x23c>>8
		JSR _puts
;	putb(rx_get_config);
		LDA r4,_rx_get_config
		JSR _putb
;	putCrlf();
		JSR _putCrlf
;
;	if (rx_get_config != USB_CURRENT_CONFIG)
		LDA r1,_USB_CURRENT_CONFIG
		LDA r0,_rx_get_config
		CMP r1
		BREQ _MetaState27__29 ;(+10)
;		{
;		puts("Should have been ");
		LDI r4,0xfc ;__Lstrings+0x273
		LDI r5,0x3d ;__Lstrings+0x273>>8
		JSR _puts
;		putb(USB_CURRENT_CONFIG);
		LDA r4,_USB_CURRENT_CONFIG
		JSR _putb
;		putCrlf();
		JSR _putCrlf
;		}
;
;	puts("End of Chapter 9 test\r\n");
_MetaState27__29:
		LDI r4,0x0d ;__Lstrings+0x384
		LDI r5,0x3f ;__Lstrings+0x384>>8
		JSR _puts
;
;//#if DEBUG_USB_STRINGS
;//	MetaState30();
;//#else
;	ResetMetaStateWanted();
		JMP _ResetMetaStateWanted
;//#endif
;
;	return;
;}
;
;#if DEBUG_USB_STRINGS
;
;ONION USB_STRING_DESC_NUM;
;BYTE	bCurrentString;
;
;void MetaState30(void)
;{
;//	static BYTE	b;
;
;//	for (b=0; b<32; b++)
;//		USB_STRINGS_USED[b] = 0;
;
;
;//USB_DUMP_COUNT =64;
;
;	SetMetaStateWanted(0x30);
;	bCurrentString = 0;
;	tx_get_desc_string.wValue.b.h = 3;
;	tx_get_desc_string.wValue.b.l = 0;
;	tx_get_desc_string.wIndex.w = 0;
;
;	SendSetup(USB_CURRENT_ADDR, &tx_get_desc_string, (PBYTE)&rx_desc_string, USB_PACKET_LENGTH_STRINGINDEX);
;	return;
;}
;
;void MetaState31(BOOL bJmp)
;{
;
;	if (bCurrentString == 0)
;		{
;		if (tx_get_desc_string.wValue.b.h == 0)
;			if (USB_IN_WANTED.w == 2)	// konica
;				{
;				USB_STRING_DESC_NUM.b.h = rx_desc_string.bLength;
;				USB_STRING_DESC_NUM.b.l = rx_desc_string.bDescriptorType;
;				}
;			else
;				{
;				USB_STRING_DESC_NUM.b.h = rx_desc_string.bString[0];
;				USB_STRING_DESC_NUM.b.l = rx_desc_string.bString[1];
;
;				if (rx_desc_string.bLength != 4)
;					UsbDumpString(&rx_desc_string);
;				}
;		}
;	else
;		{
;		SetMetaStateWanted(0x31);
;		UsbDumpString(&rx_desc_string);
;		}
;
;	for (bCurrentString++; bCurrentString; bCurrentString++)
;		{
;		if (USB_STRINGS_USED[bCurrentString>>3] & shift[bCurrentString&7])
;			{
;			USB_STRINGS_USED[bCurrentString>>3] -= shift[bCurrentString&7];
;
;			SetMetaStateWanted(0x30);
;			tx_get_desc_string.wValue.b.h = 3;
;			tx_get_desc_string.wValue.b.l = bCurrentString;
;			tx_get_desc_string.wIndex.w = 0;
;
;			SendSetup(USB_CURRENT_ADDR, &tx_get_desc_string, (PBYTE)&rx_desc_string, USB_PACKET_LENGTH_STRINGINDEX);
;
;			break;
;			}
;		}
;
;	if (!bCurrentString)
;		{
;		ResetMetaStateWanted();
;		}
;
;	return;
;}
;
;void MetaState32(void)
;{
;
;	return;
;}
;#endif // DEBUG_USB_STRINGS
;
;void ParseConfig(void)
;{
;	static PBYTE	p;
;	static BYTE	b;
;	static WORD	wLen;
;
;	USB_DUMP_bIfaceClass = 0xff;
_ParseConfig:
		LDI r0,0xff
		STA r0,_USB_DUMP_bIfaceClass
;	USB_DUMP_bIfaceSubClass = 0xff;
		STA r0,_USB_DUMP_bIfaceSubClass
;	USB_DUMP_bNumEndPoints = 0xff;
		STA r0,_USB_DUMP_bNumEndPoints
;#if WANT_SAWTOOTH
;	USB_SPEAKER_ENDPOINT = 0xff;
;#endif
;
;	p = (PBYTE)&rx_desc_config;
		LDI r0,0x4a
		STA r0,_speed+0x6
		LDI r0,0xe0
		STA r0,_speed+0x5
;	wLen = rx_desc_config.wTotalLength.w;
		LDA r0,_rx_desc_config+0x3
		STA r0,_speed+0x8
		LDA r0,_rx_desc_config+0x2
		STA r0,_speed+0x7
;
;	while (wLen)
		JMP _ParseConfig__cf
;		{
;		if (p[1] == 2)
_ParseConfig__24:
		LDI r1,0x02
		LDA r2,_speed+0x5
		LDA r3,_speed+0x6
		LDO r2,0x01
		XOR r1
		BREQ _ParseConfig__8d ;(+5c)
;			{
;#if DEBUG_CONFIG
;			puts("          Configuration:");
;#endif
;#if DEBUG_USB_STRINGS
;			UseString(p[6]);
;#endif
;			}
;		else if (p[1] == 4)
		LDI r1,0x04
		LDO r2,0x01
		XOR r1
		BRNE _ParseConfig__4a ;(+12)
;			{
;#if DEBUG_CONFIG
;			puts("              Interface:");
;#endif
;			USB_DUMP_bNumEndPoints = p[4];
		LDO r2,0x04
		STA r0,_USB_DUMP_bNumEndPoints
;			USB_DUMP_bIfaceClass = p[5];
		LDO r2,0x05
		STA r0,_USB_DUMP_bIfaceClass
;			USB_DUMP_bIfaceSubClass = p[6];
		LDO r2,0x06
		STA r0,_USB_DUMP_bIfaceSubClass
;#if DEBUG_USB_STRINGS
;			UseString(p[8]);
;#endif
;			}
		JMP _ParseConfig__8d
;		else if (p[1] == 5)
_ParseConfig__4a:
		LDI r1,0x05
		LDA r2,_speed+0x5
		LDA r3,_speed+0x6
		LDO r2,0x01
		XOR r1
		BRNE _ParseConfig__7b ;(+24)
;			{
;#if DEBUG_CONFIG
;			puts("               EndPoint:");
;#endif
;			if (USB_DUMP_bNumEndPoints == 0)
		LDA r0,_USB_DUMP_bNumEndPoints
		BREQ _ParseConfig__8d ;(+31)
;				;
;			else
;				{
;				if (USB_DUMP_bIfaceClass-1)
		LDA r0,_USB_DUMP_bIfaceClass
		LDI r1,0x00
		LDI r4,0xff
		ADD r4
		BRCS _ParseConfig__67 ;(+01)
		DEC r1
_ParseConfig__67:
		OR  r1
		BRNE _ParseConfig__8d ;(+23)
;					;
;				else
;					{
;					if (USB_DUMP_bIfaceSubClass-2)
		LDA r0,_USB_DUMP_bIfaceSubClass
		LDI r1,0x00
		LDI r4,0xfe
		ADD r4
		BRCS _ParseConfig__75 ;(+01)
		DEC r1
_ParseConfig__75:
		OR  r1
		BREQ _ParseConfig__8d ;(+15)
		JMP _ParseConfig__8d
;						;
;						{
;#if WANT_SAWTOOTH
;						USB_SPEAKER_ENDPOINT = 2;
;#endif
;						}
;					}
;				}
;			}
;		else if (p[1] == 0x24)
_ParseConfig__7b:
		LDI r1,0x24
		LDA r2,_speed+0x5
		LDA r3,_speed+0x6
		LDO r2,0x01
		XOR r1
		BREQ _ParseConfig__8d ;(+05)
;			{
;#if DEBUG_CONFIG
;			puts("ClassSpecific Interface:");
;#endif
;			}
;		else if (p[1] == 0x25)
		LDI r1,0x25
		LDO r2,0x01
		CMP r1
;			{
;#if DEBUG_CONFIG
;			puts(" ClassSpecific Endpoint:");
;#endif
;			}
;
;		b = p[0];
_ParseConfig__8d:
		LDA r2,_speed+0x5
		LDA r3,_speed+0x6
		LDX r2
		STA r0,_psr+0x1f
;#if DEBUG_CONFIG
;		{
;		BYTE	i;
;		for (i=0; i<b; i++)
;			{
;			putbs(p[i]);
;			}
;		}
;		putCrlf();
;#endif // DEBUG_CONFIG
;
;		wLen -= b;
		LDI r1,0x00
		STA r0,Aa_UsbVendSetEndPoint
		STA r1,Aa_UsbVendSetEndPoint+0x1
		LDA r0,_speed+0x7
		LDA r1,Aa_UsbVendSetEndPoint
		STP C
		SBC r1
		STA r0,_speed+0x7
		LDA r0,_speed+0x8
		LDA r1,Aa_UsbVendSetEndPoint+0x1
		SBC r1
		STA r0,_speed+0x8
;		p += b;
		LDA r0,_psr+0x1f
		LDI r1,0x00
		STA r0,Aa_UsbVendSetEndPoint
		STA r1,Aa_UsbVendSetEndPoint+0x1
		TX0 r2
		LDA r1,Aa_UsbVendSetEndPoint
		ADD r1
		STA r0,_speed+0x5
		TX0 r3
		LDA r1,Aa_UsbVendSetEndPoint+0x1
		ADC r1
		STA r0,_speed+0x6
_ParseConfig__cf:
		LDA r0,_speed+0x7
		LDA r1,_speed+0x8
		OR  r1
		BREQ _ParseConfig__db ;(+03)
		JMP _ParseConfig__24
_ParseConfig__db:
		RTS
;		}
;}
;
;#if !WANT_LITE
;void MetaState40(void)	// send set_feature, port 1, power
;{
;
;	SetMetaStateWanted(0x40);
_MetaState40:
		LDI r4,0x40
		JSR _SetMetaStateWanted
;	tx_set_port_feature.wValue.b.l = SET_PORT_FEATURE_POWER;
		LDI r0,0x08
		BRNE _MetaState42__27 ;(+2a)
;	tx_set_port_feature.wIndex.b.l = 1;	// port #1
;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_port_feature, rx_null_packet, USB_PACKET_LENGTH_0);
;	return;
;}
;
;void MetaState41(void)	// send get_status, port
;{
_MetaState41:
		JMP _MetaState43
;	tx_get_port_status.wIndex.b.l = 1;	// port #1
;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_port_status, (PBYTE)&rx_port_status, 4);
;	return;
;}
;
;void MetaState42(void) // show port status, then send set_feature, port 1, reset
;{
;
;	puts("Got port status:");
_MetaState42:
		LDI r4,0xa0 ;__Lstrings+0x217
		LDI r5,0x3d ;__Lstrings+0x217>>8
		JSR _puts
;	putbs(rx_port_status.b[0]);
		LDA r4,_rx_port_status
		JSR _putbs
;	putbs(rx_port_status.b[1]);
		LDA r4,_rx_port_status+0x1
		JSR _putbs
;	putbs(rx_port_status.b[2]);
		LDA r4,_rx_port_status+0x2
		JSR _putbs
;	putbs(rx_port_status.b[3]);
		LDA r4,_rx_port_status+0x3
		JSR _putbs
;	putCrlf();
		JSR _putCrlf
;	putFlush();
		JSR _putFlush
;
;	tx_set_port_feature.wValue.b.l = SET_PORT_FEATURE_RESET;
		LDI r0,0x04
_MetaState42__27:
		STA r0,_tx_set_port_feature+0x2
;	tx_set_port_feature.wIndex.b.l = 1;	// port #1
		LDI r0,0x01
		STA r0,_tx_set_port_feature+0x4
;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_set_port_feature, rx_null_packet, USB_PACKET_LENGTH_0);
		LDI r0,0x47
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x17
		STA r0,Aa_UsbVendSetEndPoint
		LDI r0,0xff
		STA r0,Aa_UartReadString+0x1
		LDI r0,0xf0
		STA r0,Aa_UartReadString
		LDI r2,0xff ;_tx_set_port_feature
		LDI r3,0x46 ;_tx_set_port_feature>>8
		LDA r4,_USB_CURRENT_ADDR
		JMP _SendSetup
;	return;
;}
;
;void MetaState43(void)	// send get_status, port
;{
;
;	tx_get_port_status.wIndex.b.l = 1;	// port #1
_MetaState43:
		LDI r0,0x01
		STA r0,_tx_get_port_status+0x4
;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_get_port_status, (PBYTE)&rx_port_status, 4);
		LDI r0,0x4a
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x7e
		STA r0,Aa_UsbVendSetEndPoint
		XOR r0
		STA r0,Aa_UartReadString+0x1
		LDI r0,0x04
		STA r0,Aa_UartReadString
		LDI r2,0x07 ;_tx_get_port_status
		LDI r3,0x47 ;_tx_get_port_status>>8
		LDA r4,_USB_CURRENT_ADDR
		JMP _SendSetup
;	return;
;}
;
;void MetaState44(void) // show port status, 
;{
;
;	puts("Got port status:");
_MetaState44:
		LDI r4,0xa0 ;__Lstrings+0x217
		LDI r5,0x3d ;__Lstrings+0x217>>8
		JSR _puts
;	putbs(rx_port_status.b[0]);
		LDA r4,_rx_port_status
		JSR _putbs
;	putbs(rx_port_status.b[1]);
		LDA r4,_rx_port_status+0x1
		JSR _putbs
;	putbs(rx_port_status.b[2]);
		LDA r4,_rx_port_status+0x2
		JSR _putbs
;	putbs(rx_port_status.b[3]);
		LDA r4,_rx_port_status+0x3
		JSR _putbs
;	putCrlf();
		JSR _putCrlf
;	putFlush();
		JSR _putFlush
;
;	if ((rx_port_status.b[0] & 0x03) == 0x01)	// connected but not ready
		LDI r1,0x03
		LDA r0,_rx_port_status
		AND r1
		LDI r1,0x01
		CMP r1
		BRNE _MetaState44__38 ;(+08)
;		{
;		SetMetaStateWanted(0x43);	// lather, rinse, repeat
		LDI r4,0x43
		JSR _SetMetaStateWanted
;		MetaState43();
		JMP _MetaState43
;		return;
;		}
;
;// if bit 1 of the second byte (bit 9 overall) is set, it's a low speed device
;	speed = (rx_port_status.b[1] & 0x02) ? 0x80 : 0x00;
_MetaState44__38:
		LDA r0,_rx_port_status+0x1
		BTT C
		BRNE _MetaState44__41 ;(+03)
		XOR r0
		BREQ _MetaState44__43 ;(+02)
_MetaState44__41:
		LDI r0,0x80
_MetaState44__43:
		STA r0,_speed
;
;	ResetMetaStateWanted();
		JMP _ResetMetaStateWanted
;	return;
;}
;
;void MetaState50(void)	// send enable echo
;{
;
;	SetMetaStateWanted(0x50);
_MetaState50:
		LDI r4,0x50
		JSR _SetMetaStateWanted
;
;	SendSetup(USB_CURRENT_ADDR, (PBYTE)&tx_enable_echo, rx_null_packet, USB_PACKET_LENGTH_0);	// expect 0 bytes returned
		LDI r0,0x47
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0x17
		STA r0,Aa_UsbVendSetEndPoint
		LDI r0,0xff
		STA r0,Aa_UartReadString+0x1
		LDI r0,0xf0
		STA r0,Aa_UartReadString
		LDI r2,0x0f ;_tx_enable_echo
		LDI r3,0x47 ;_tx_enable_echo>>8
		LDA r4,_USB_CURRENT_ADDR
		JMP _SendSetup
;	return;
;}
;
;void MetaState51(void) // 
;{
;
;	puts("Enable echo has been sent\r\n");
_MetaState51:
		LDI r4,0x25 ;__Lstrings+0x39c
		LDI r5,0x3f ;__Lstrings+0x39c>>8
		JSR _puts
;
;	ResetMetaStateWanted();
		JMP _ResetMetaStateWanted
;	return;
;}
;
;
;void MetaState60(void)	// send enable echo
;{
;	WORD	wBufferSize;
;
;	puts("MetaState60: ");
_MetaState60:
		LDI r4,0xcd ;__Lstrings+0x344
		LDI r5,0x3e ;__Lstrings+0x344>>8
		JSR _puts
;	puts("todo ");
		LDI r4,0xf6 ;__Lstrings+0x26d
		LDI r5,0x3d ;__Lstrings+0x26d>>8
		JSR _puts
;	puts("contains ");
		LDI r4,0xe7 ;__Lstrings+0x25e
		LDI r5,0x3d ;__Lstrings+0x25e>>8
		JSR _puts
;	putws(todo.wLength);
		LDA r4,_todo
		LDA r5,_todo+0x1
		JSR _putws
;	putws((WORD)todo.pBuffer);
		LDA r4,_todo+0x2
		LDA r5,_todo+0x3
		JSR _putws
;	putbs(todo.bEndpointControl);
		LDA r4,_todo+0x5
		JSR _putbs
;	putbs(todo.bAddress);
		LDA r4,_todo+0x6
		JSR _putbs
;	putbs(todo.bTokenAndEndpoint);
		LDA r4,_todo+0x7
		JSR _putbs
;	putw(todo.wBC);
		LDA r4,_todo+0xa
		LDA r5,_todo+0xb
		JSR _putw
;	putCrlf();
		JSR _putCrlf
;
;	SetMetaStateWanted(0x60);
		LDI r4,0x60
		JSR _SetMetaStateWanted
;
;	wBufferSize = todo.wBC & 0x03ff;
		LDI r2,0xff ;_stack+0xff
		LDI r3,0x03 ;_stack+0xff>>8
		LDA r0,_todo+0xa
		AND r2
		T0X r2
		LDA r0,_todo+0xb
		AND r3
		T0X r3
		PSH r2
		POP r4
		PSH r3
		POP r5
;
;	if (wBufferSize > todo.wLength)
		LDA r0,_todo
		CMP r4
		LDA r0,_todo+0x1
		SBC r5
		BRCS _MetaState60__6c ;(+06)
;		wBufferSize = todo.wLength;
		LDA r4,_todo
		LDA r5,_todo+0x1
_MetaState60__6c:
		STA r4,Aa_UsbVendSetEndPoint
		STA r5,Aa_UsbVendSetEndPoint+0x1
;
;	USB_HOST_STATE = 0x11;
		LDI r0,0x11
		STA r0,_USB_HOST_STATE
;	IncMetaStateWanted();
		JSR _IncMetaStateWanted
;	USB_NEXT_DATA01 = 0;		// reset DATA0/1 flag
		XOR r0
		STA r0,_USB_NEXT_DATA01
;	USB_PACKET_LENGTH_MODE = todo.wLength;
		LDA r0,_todo+0x1
		STA r0,_USB_PACKET_LENGTH_MODE+0x1
		LDA r0,_todo
		STA r0,_USB_PACKET_LENGTH_MODE
;	USB_IN_SO_FAR = 0;
		XOR r0
		STA r0,_USB_IN_SO_FAR+0x1
		STA r0,_USB_IN_SO_FAR
;	rx_buffer.pb = todo.pBuffer;
		LDA r0,_todo+0x3
		STA r0,_rx_buffer+0x1
		LDA r0,_todo+0x2
		STA r0,_rx_buffer
;
;//puts("Sending ");putw(wBufferSize);puts(" bytes to ");putb(todo.bTokenAndEndpoint);putCrlf();
;
;	if (todo.bTokenAndEndpoint & 0x80)
		LDA r0,_todo+0x7
		BRPL _MetaState60__b4 ;(+12)
;		{	// receiving data
;		HostSetNextInBdt(wBufferSize, todo.pBuffer);
		LDA r2,_todo+0x2
		LDA r3,_todo+0x3
		LDA r4,Aa_UsbVendSetEndPoint
		LDA r5,Aa_UsbVendSetEndPoint+0x1
		JSR _HostSetNextInBdt
;		}
		JMP _MetaState60__c3
;	else
;		{	// sending data
;		HostSetNextOutBdt(wBufferSize, todo.pBuffer);
_MetaState60__b4:
		LDA r2,_todo+0x2
		LDA r3,_todo+0x3
		LDA r4,Aa_UsbVendSetEndPoint
		LDA r5,Aa_UsbVendSetEndPoint+0x1
		JSR _HostSetNextOutBdt
;		}
;
;#if DEBUG_SEND_TOKEN
;	puts("MetaState60: SendToken(");
;	putbs(todo.bAddress);
;	putbs(todo.bTokenAndEndpoint);
;	putb(ENDPT_CONTROL);
;	puts(")\r\n");
;#endif
;
;	SendToken(todo.bAddress, todo.bTokenAndEndpoint, ENDPT_CONTROL);
_MetaState60__c3:
		LDI r0,0x0d
		STA r0,Aa_HostSetNextOutBdt
		LDA r2,_todo+0x7
		LDA r4,_todo+0x6
		JSR _SendToken
;
;	todo.pBuffer += wBufferSize;
		LDA r2,Aa_UsbVendSetEndPoint
		LDA r3,Aa_UsbVendSetEndPoint+0x1
		TX0 r3
		T0X r1
		STA r2,Aa_UartReadString
		STA r1,Aa_UartReadString+0x1
		LDA r0,_todo+0x2
		LDA r1,Aa_UartReadString
		ADD r1
		STA r0,_todo+0x2
		LDA r0,_todo+0x3
		LDA r1,Aa_UartReadString+0x1
		ADC r1
		STA r0,_todo+0x3
;	todo.wLength -= wBufferSize;
		TX0 r3
		T0X r1
		STA r1,Aa_UartReadString+0x1
		LDA r0,_todo
		LDA r1,Aa_UartReadString
		STP C
		SBC r1
		STA r0,_todo
		LDA r0,_todo+0x1
		LDA r1,Aa_UartReadString+0x1
		SBC r1
		STA r0,_todo+0x1
;
;	return;
		RTS
;}
;
;void MetaState61(void) // 
;{
;
;puts("MetaState61: todo.wLength=");
_MetaState61:
		LDI r4,0x85 ;__Lstrings+0x1fc
		LDI r5,0x3d ;__Lstrings+0x1fc>>8
		JSR _puts
;putw(todo.wLength);
		LDA r4,_todo
		LDA r5,_todo+0x1
		JSR _putw
;putCrlf();
		JSR _putCrlf
;
;	if (todo.wLength)	// still more to do
		LDA r0,_todo
		LDA r1,_todo+0x1
		OR  r1
;		{
;		MetaState60();
		BREQ _MetaState61__1f ;(+03)
		JMP _MetaState60
;		return;
;		}
;
;	puts("todo is done\r\n");
_MetaState61__1f:
		LDI r4,0x72 ;__Lstrings+0x3e9
		LDI r5,0x3f ;__Lstrings+0x3e9>>8
		JSR _puts
;	bSomethingTodo = 0;
		XOR r0
		STA r0,_bSomethingTodo
;
;	ResetMetaStateWanted();
		JMP _ResetMetaStateWanted
;	return;
;}
;#endif //!WANT_LITE
;
;
;
;
;void HostSetCurrentAddress(BYTE bAddress)
;{
;
;	USB_CURRENT_ADDR = bAddress;
_HostSetCurrentAddress:
		STA r4,_USB_CURRENT_ADDR
;	return;
		RTS
		.byte 0xa6
		.byte 0x4f
;}
;
;#if DEBUG_USB_STRINGS
;
;void UseString(BYTE bString)
;{
;	static BYTE	m;
;
;//	m = 1 << (bString & 7);
;	m = shift[bString & 7];
;	USB_STRINGS_USED[bString>>3] |= m;
;	return;
;}
;#endif // DEBUG_USB_STRINGS
;
;void SendSetup(BYTE bAddr, PBYTE pTx, PBYTE pRx, WORD wLength)
;{
;
;#if DEBUG_DESCRIPTOR
;	{
;	static PBYTE	pd;
;	static BYTE	i;
;	
;	puts("Setup:");
;	for (pd=(PBYTE)&debugDESCRIPTOR, i=0; i<8; i++)
;		{
;		pd[i] = pTx[i];
;		putbs(pTx[i]);
;		}
;	putCrlf();
;	}
;#endif
;
;	USB_HOST_STATE = 1;
_SendSetup:
		STA r2,A_UsbSendIn
		STA r3,A_UsbSendIn+0x1
		STA r4,Aa_HostSetNextInBdt
		LDI r0,0x01
		STA r0,_USB_HOST_STATE
;	IncMetaStateWanted();
		JSR _IncMetaStateWanted
;	USB_NEXT_DATA01 = 0;		// reset DATA0/1 flag
		XOR r0
		STA r0,_USB_NEXT_DATA01
;
;	rx_buffer.pb = (PBYTE)pRx;
		LDA r0,Aa_UsbVendSetEndPoint+0x1
		STA r0,_rx_buffer+0x1
		LDA r0,Aa_UsbVendSetEndPoint
		STA r0,_rx_buffer
;	HostSetNextOutBdt(0x08, pTx);
		LDA r2,A_UsbSendIn
		LDA r3,A_UsbSendIn+0x1
		LDI r4,0x08 ;__Lreset+0x8
		LDI r5,0x00 ;__Lreset+0x8>>8
		JSR _HostSetNextOutBdt
;
;	USB_PACKET_LENGTH_MODE = wLength;
		LDA r0,Aa_UartReadString+0x1
		STA r0,_USB_PACKET_LENGTH_MODE+0x1
		LDA r0,Aa_UartReadString
		STA r0,_USB_PACKET_LENGTH_MODE
;	USB_IN_SO_FAR = 0;
		XOR r0
		STA r0,_USB_IN_SO_FAR+0x1
		STA r0,_USB_IN_SO_FAR
;
;#if DEBUG_SEND_TOKEN
;	puts("SendSetup: SendToken(");
;	putbs(bAddr);
;	putbs(0xd0);
;	putb(ENDPT_CONTROL);
;	puts(")\r\n");
;#endif
;
;	SendToken(bAddr, 0xd0, ENDPT_CONTROL);	// setup ep0
		LDI r0,0x0d
		STA r0,Aa_HostSetNextOutBdt
		LDI r2,0xd0
		LDA r4,Aa_HostSetNextInBdt
		JMP _SendToken
;	return;
;}
;
;void HostSetNextOutBdt(WORD wLength, PBYTE p)
;{
;	static ONION	onion;
;	BYTE	newPid;
;
;	USB_OUT ^= 0x04;	// toggle odd/even and use result
_HostSetNextOutBdt:
		STA r2,Aa_SendToken
		STA r3,Aa_SendToken+0x1
		LDI r1,0x04
		LDA r0,_USB_OUT
		XOR r1
		STA r0,_USB_OUT
;
;	onion.pBDT = USB_BDT_PAGE;
		LDI r0,0x70
		STA r0,_speed+0xa
		LDI r0,0x00
		STA r0,_speed+0x9
;	onion.b.l = USB_OUT;	// create pointer to current out bdt
		LDA r0,_USB_OUT
		STA r0,_speed+0x9
;
;	onion.pBDT->bc = (BYTE)wLength;
		TX0 r4
		LDA r2,_speed+0x9
		LDA r3,_speed+0xa
		STO r2,0x01
		STA r4,A_ReallySendToken
		STA r5,Aa_ReallySendToken
;	onion.pBDT->addr.pb = p;
		LDA r0,Aa_SendToken+0x1
		STO r2,0x03
		LDA r0,Aa_SendToken
		STO r2,0x02
;	newPid = HostCreateNextControlByte(onion.pBDT);
		LDA r4,_speed+0x9
		LDA r5,_speed+0xa
		JSR _HostCreateNextControlByte
		T0X r2
;	newPid |= wLength >> 8;
		LDA r0,Aa_ReallySendToken
		T0X r1
		TX0 r2
		OR  r1
		T0X r2
;
;	USB_BUFFERED_BDT.pid = newPid;
		STA r2,_USB_BUFFERED_BDT
		STA r2,Aa_HostSetNextOutBdt
;	USB_BUFFERED_BDT.bc = onion.pBDT->bc;
		LDA r2,_speed+0x9
		LDA r3,_speed+0xa
		LDO r2,0x01
		STA r0,_USB_BUFFERED_BDT+0x1
;	USB_BUFFERED_BDT.addr = onion.pBDT->addr;
		LDO r2,0x03
		STA r0,_USB_BUFFERED_BDT+0x3
		LDO r2,0x02
		STA r0,_USB_BUFFERED_BDT+0x2
;
;	onion.pBDT->pid = newPid;
		LDA r0,Aa_HostSetNextOutBdt
		STX r2
;
;#if DEBUG_BDT
;	{
;	static PBYTE	ps;
;	static BYTE	i;
;
;	putos(onion);
;	debugPBDT = onion.pBDT;
;	debugBDT = *onion.pBDT;
;	for (i=0, ps=onion.pBDT->addr.pb; i<8; i++)
;		{
;		putbs(ps[i]);
;		debugDATA[i] = ps[i];
;		}
;	putCrlf();
;	}
;#endif
;
;	return;
		RTS
;}
;
;void HostSetNextInBdt(WORD wLength, PBYTE p)
;{
;	static ONION	onion;
;	BYTE	newPid;
;
;	USB_IN ^= 0x04;	// toggle odd/even and use result
_HostSetNextInBdt:
		STA r2,A_UsbSendIn
		STA r3,A_UsbSendIn+0x1
		LDI r1,0x04
		LDA r0,_USB_IN
		XOR r1
		STA r0,_USB_IN
;
;	onion.pBDT = USB_BDT_PAGE;
		LDI r0,0x70
		STA r0,_speed+0xc
		LDI r0,0x00
		STA r0,_speed+0xb
;	onion.b.l = USB_IN;	// create pointer to current in bdt
		LDA r0,_USB_IN
		STA r0,_speed+0xb
;
;	onion.pBDT->bc = (BYTE)wLength;
		TX0 r4
		LDA r2,_speed+0xb
		LDA r3,_speed+0xc
		STO r2,0x01
		STA r4,Aa_HostSetNextOutBdt
		STA r5,Aa_SendToken
;	onion.pBDT->addr.pb = p;
		LDA r0,A_UsbSendIn+0x1
		STO r2,0x03
		LDA r0,A_UsbSendIn
		STO r2,0x02
;	newPid = HostCreateNextControlByte(onion.pBDT);
		LDA r4,_speed+0xb
		LDA r5,_speed+0xc
		JSR _HostCreateNextControlByte
		T0X r2
;	newPid |= wLength >> 8;
		LDA r0,Aa_SendToken
		T0X r1
		TX0 r2
		OR  r1
		T0X r2
;
;	USB_BUFFERED_BDT.pid = newPid;
		STA r2,_USB_BUFFERED_BDT
		STA r2,Aa_HostSetNextInBdt
;	USB_BUFFERED_BDT.bc = onion.pBDT->bc;
		LDA r2,_speed+0xb
		LDA r3,_speed+0xc
		LDO r2,0x01
		STA r0,_USB_BUFFERED_BDT+0x1
;	USB_BUFFERED_BDT.addr = onion.pBDT->addr;
		LDO r2,0x03
		STA r0,_USB_BUFFERED_BDT+0x3
		LDO r2,0x02
		STA r0,_USB_BUFFERED_BDT+0x2
;
;	onion.pBDT->pid = newPid;
		LDA r0,Aa_HostSetNextInBdt
		STX r2
;
;#if DEBUG_BDT
;	{
;	static PBYTE	ps;
;	static BYTE	i;
;
;	putos(onion);
;	debugPBDT = onion.pBDT;
;	debugBDT = *onion.pBDT;
;	for (i=0, ps=onion.pBDT->addr.pb; i<8; i++)
;		{
;		putbs(ps[i]);
;		debugDATA[i] = ps[i];
;		}
;	putCrlf();
;	}
;#endif
;
;	return;
		RTS
		.byte 0xad
		.byte 0x4f
;}
;
;void SendToken(BYTE bAddress, BYTE bToken, BYTE bType)
;{
;#if DEBUG_TOKEN
;	puts("SendToken(");
;	putbs(bAddress);
;	putbs(bToken);
;	putb(bType);
;	puts(")\r\n");
;#endif
;
;#if USB_DELAY_TOKEN && 0
;	if (USB_BUFFERED)
;		{
;		puts("SendToken: already buffered\a ");
;		putbs(USB_BUFFERED_ADDRESS);
;		putbs(USB_BUFFERED_TOKEN);
;		putb(USB_BUFFERED_TYPE);
;		putCrlf();
;		}
;	USB_BUFFERED = TRUE;
;#endif
;
;	USB_BUFFERED_ADDRESS = bAddress;
_SendToken:
		STA r4,_USB_BUFFERED_ADDRESS
		STA r4,Aa_SendToken+0x1
;	USB_BUFFERED_TOKEN = bToken;
		STA r2,_USB_BUFFERED_TOKEN
		STA r2,Aa_SendToken
;	USB_BUFFERED_TYPE = bType;
		LDA r1,Aa_HostSetNextOutBdt
		STA r1,_USB_BUFFERED_TYPE
;
;#if USB_DELAY_TOKEN && 0
;	puts("SendToken: queueing ");
;	putbs(USB_BUFFERED_ADDRESS);
;	putbs(USB_BUFFERED_TOKEN);
;	putb(USB_BUFFERED_TYPE);
;	putCrlf();
;#else
;	USB_BUFFERED = FALSE;
		XOR r0
		STA r0,_USB_BUFFERED
;	ReallySendToken(bAddress, bToken, bType);
		STA r1,A_ReallySendToken
		BREQ _ReallySendToken ;(+03)
;#endif
;
;	return;
		RTS
		.byte 0xb0
		.byte 0x4f
;}
;
;
;
;
;
;
;void ReallySendToken(BYTE bAddress, BYTE bToken, BYTE bType)
;{
;
;#if USB_DELAY_TOKEN && 0
;	puts("ReallySendToken: ");
;	putbs(bAddress);
;	putbs(bToken);
;	putb(bType);
;	putCrlf();
;#endif
;
;	while (usb.control & MASK_CTL_TOKEN_BUSY)
_ReallySendToken:
		STA r2,Aa_ReallySendToken+0x1
		STA r4,Aa_ReallySendToken
		JMP _ReallySendToken__c
;		{
;		putFlush();
_ReallySendToken__9:
		JSR _putFlush
_ReallySendToken__c:
		LDA r0,_usb+0x5
		BTT 5
		BRNE _ReallySendToken__9 ;(-09)
;		}
;
;#if DEBUG_OUT_TOKENS
;	debugTOKEN_ADDRESS = bAddress;
;	debugTOKEN_TOKEN = bToken;
;	debugTOKEN_TYPE = bType;
;
;	puts("-> ");
;	putbs(bAddress);
;	putbs(bToken);
;	putb(bType);
;	putCrlf();
;#endif
;
;	ENDPT_HOST_RG = bType;
		LDA r0,A_ReallySendToken
		STA r0,_ENDPT_HOST_RG
;	usb.address = bAddress;
		LDA r0,Aa_ReallySendToken
		STA r0,_usb+0x6
;	usb.token = bToken;
		LDA r0,Aa_ReallySendToken+0x1
		STA r0,_usb+0xa
;	return;
		RTS
;}
;
;#if DEBUG_USB_STRINGS
;
;
;
;
;void UsbDumpString(PDESC_STRING pds)
;{
;	BYTE	j;
;
;	putCrlf();
;	putc('#');
;	putbs(bCurrentString);
;	putb(pds->bLength);
;	putc('=');
;	for (j=0; j<(pds->bLength-2); j+=2)
;		if (pds->bString[j])
;			putc(pds->bString[j]);
;		else
;			puts("<NULL>");
;	putCrlf();
;
;
;}
;#endif // DEBUG_USB_STRINGS
;
;#if 0
;BYTE HostDebounceAttachDetach(void)
;{
;	static BYTE	b, b2, i, j;
;
;#if WANT_HARDWARE
;#if USB_LONG_RESET
;#define LOOPS 255
;#else
;#define LOOPS 48
;#endif // USB_LONG_RESET
;#else
;#define LOOPS 1
;#endif
;
;try_again:
;	b = usb.control;	// get current value
;
;	for (i=LOOPS; i; i--)
;		{
;		for (j=160; j; j--)
;			{
;			}
;		b2 = usb.control;
;		if (b != b2)
;			goto try_again;
;		}
;
;	return b;
;}
;#endif
;
;BYTE HostDebounceAttachDetach(void)
;{
;	static BYTE	b, b2, j, equal, try;
;
;puts("HDAD: usb.control=");
_HostDebounceAttachDetach:
		LDI r4,0x72 ;__Lstrings+0x1e9
		LDI r5,0x3d ;__Lstrings+0x1e9>>8
		JSR _puts
;putb(usb.control);
		LDA r4,_usb+0x5
		JSR _putb
;putCrlf();
		JSR _putCrlf
;
;	for (try=15; try; try--)
		LDI r0,0x0f
		BRNE _HostDebounceAttachDetach__4d ;(+39)
;		{
;		equal = 1;			// initialize comparitor
_HostDebounceAttachDetach__14:
		LDI r0,0x01
		STA r0,_psr+0x23
;		b = usb.control;	// get current value
		LDA r0,_usb+0x5
		STA r0,_psr+0x20
;		for (j=160; j; j--)
		LDI r0,0xa0
		BRNE _HostDebounceAttachDetach__38 ;(+15)
;			{
;			b2 = usb.control;
_HostDebounceAttachDetach__23:
		LDA r0,_usb+0x5
		STA r0,_psr+0x21
;			if (b != b2) 
		T0X r1
		LDA r0,_psr+0x20
		XOR r1
		BREQ _HostDebounceAttachDetach__34 ;(+04)
;				equal = 0;
		XOR r0
		STA r0,_psr+0x23
_HostDebounceAttachDetach__34:
		LDA r0,_psr+0x22
		DEC r0
_HostDebounceAttachDetach__38:
		STA r0,_psr+0x22
		LDA r0,_psr+0x22
		BRNE _HostDebounceAttachDetach__23 ;(-1d)
;			}
;		if (equal)
		LDA r0,_psr+0x23
		BREQ _HostDebounceAttachDetach__49 ;(+04)
;			return b;
		LDA r0,_psr+0x20
		RTS
_HostDebounceAttachDetach__49:
		LDA r0,_psr+0x24
		DEC r0
_HostDebounceAttachDetach__4d:
		STA r0,_psr+0x24
		LDA r0,_psr+0x24
		BRNE _HostDebounceAttachDetach__14 ;(-41)
;		}
;
;	return usb.control | 0x40;
		LDI r1,0x40
		LDA r0,_usb+0x5
		OR  r1
		RTS
;}
;
;#if !WANT_LITE
;void HostIntDumpRegs();
;#endif //!WANT_LITE
;
;void HostDelay(void)
;{
;	static ONION	o1, o2;
;	long delay;
;
;#if 0
;#if !WANT_LITE
;puts("\r\nRegs 1 = ");
;HostIntDumpRegs();
;#endif //!WANT_LITE
;
;putc('<');
;puts("usb.intEnable=");
;putbs(usb.intEnable);
;puts("usb.control=");
;putbs(usb.control);
;putFlush();
;#endif
;	usb.intEnable |= INT_STAT_MASK_SOF;
_HostDelay:
		LDI r1,0x04
		LDA r0,_usb+0x1
		OR  r1
		STA r0,_usb+0x1
;#if 0
;puts("usb.intEnable=");
;putbs(usb.intEnable);
;putFlush();
;putCrlf();
;#endif
;	o1.b.l = usb.frameNumLo;
		LDA r0,_usb+0x8
		STA r0,_speed+0xd
;	o1.b.h = usb.frameNumHi;
		LDA r0,_usb+0x9
		STA r0,_speed+0xe
;	o1.w = (o1.w + HOST_WAIT.w) & 0x7ff;
		LDI r2,0xff ;_modify__140
		LDI r3,0x07 ;_modify__140>>8
		LDA r4,_HOST_WAIT
		LDA r5,_HOST_WAIT+0x1
		LDA r0,_speed+0xd
		LDA r1,_speed+0xe
		ADD r4
		T0X r4
		TX0 r1
		ADC r5
		T0X r5
		TX0 r4
		AND r2
		T0X r2
		TX0 r5
		AND r3
		T0X r3
		STA r3,_speed+0xe
		STA r2,_speed+0xd
;
;//putw(o1.w);	putCrlf();	putFlush();	// dump SOF number that we're waiting for
;
;	delay = 0xffff0000;
		XOR r0
		STA r0,Aa_UsbVendSetEndPoint
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r0,0xff
		STA r0,Aa_UartReadString
		STA r0,Aa_UartReadString+0x1
;
;	do	{
;		o2.b.l = usb.frameNumLo;
_HostDelay__45:
		LDA r0,_usb+0x8
		STA r0,_speed+0xf
;		o2.b.h = usb.frameNumHi;
		LDA r0,_usb+0x9
		STA r0,_speed+0x10
;        if (o2.b.l & 1) asm ("stp 4"); else asm ("clp 4");
		LDA r0,_speed+0xf
		BTT Z
		BREQ _HostDelay__5b ;(+04)
		STP 4
		JMP _HostDelay__5c
_HostDelay__5b:
		CLP 4
;        if (o2.b.l & 2) asm ("stp 5"); else asm ("clp 5");
_HostDelay__5c:
		LDA r0,_speed+0xf
		BTT C
		BREQ _HostDelay__66 ;(+04)
		STP 5
		JMP _HostDelay__67
_HostDelay__66:
		CLP 5
;        if (o2.b.l & 4) asm ("stp 6"); else asm ("clp 6");
_HostDelay__67:
		LDA r0,_speed+0xf
		BTT N
		BREQ _HostDelay__71 ;(+04)
		STP 6
		JMP _HostDelay__72
_HostDelay__71:
		CLP 6
;        if (o2.b.l & 8) asm ("stp 7"); else asm ("clp 7");
_HostDelay__72:
		LDA r0,_speed+0xf
		BTT I
		BREQ _HostDelay__7c ;(+04)
		STP 7
		JMP _HostDelay__7d
_HostDelay__7c:
		CLP 7
;
;		// send a character to the UART if there is one.
;		putFlushOneIfReady();
_HostDelay__7d:
		JSR _putFlushOneIfReady
;
;		delay++;
		LDA r0,Aa_UsbVendSetEndPoint
		LDI r1,0x01
		ADD r1
		STA r0,Aa_UsbVendSetEndPoint
		LDA r0,Aa_UsbVendSetEndPoint+0x1
		LDI r1,0x00
		ADC r1
		STA r0,Aa_UsbVendSetEndPoint+0x1
		LDA r0,Aa_UartReadString
		ADC r1
		STA r0,Aa_UartReadString
		LDA r0,Aa_UartReadString+0x1
		ADC r1
		STA r0,Aa_UartReadString+0x1
;		} while ((o1.w != o2.w) && delay);
		LDA r0,_speed+0xd
		LDA r1,_speed+0xe
		LDA r2,_speed+0xf
		XOR r2
		BRNE _HostDelay__b2 ;(+06)
		LDA r0,_speed+0x10
		XOR r1
		BREQ _HostDelay__c3 ;(+11)
_HostDelay__b2:
		LDA r0,Aa_UartReadString+0x1
		LDA r1,Aa_UsbVendSetEndPoint
		OR  r1
		LDA r1,Aa_UsbVendSetEndPoint+0x1
		OR  r1
		LDA r1,Aa_UartReadString
		OR  r1
		BRNE _HostDelay__45 ;(-7e)
;
;if (!delay)
_HostDelay__c3:
		LDA r0,Aa_UartReadString+0x1
		LDA r1,Aa_UsbVendSetEndPoint
		OR  r1
		LDA r1,Aa_UsbVendSetEndPoint+0x1
		OR  r1
		LDA r1,Aa_UartReadString
		OR  r1
		BRNE _HostDelay__de ;(+0a)
;	{
;	puts("\r\ndelay timed out\r\n");
		LDI r4,0xf9 ;__Lstrings+0x370
		LDI r5,0x3e ;__Lstrings+0x370>>8
		JSR _puts
;	putFlush();
		JMP _putFlush
;	}
;
;#if 0
;putc('>');
;putCrlf();
;putFlush();
;#endif
;}
_HostDelay__de:
		RTS
;
;void doAReset()
;{
;
;#if 1
;// Be like Microsoft and reset the device between the initial 8 byte get desctiptor 
;// and the full get descriptor.
;// just shut up for a while but send SOF's to keep the device awake
;	usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN;
_doAReset:
		LDI r0,0x09
		STA r0,_usb+0x5
;	HostDelay();
		JSR _HostDelay
;// now reset the USB
;	usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN | MASK_CTL_RESET;
		LDI r0,0x19
		STA r0,_usb+0x5
;	HostDelay();
		JSR _HostDelay
;// end the reset and start the SOFs
;	usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN;
		LDI r0,0x09
		STA r0,_usb+0x5
;	HostDelay();
		JMP _HostDelay
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\I2C.C
;// i2c.c
;
;#include "vauto.h"
;#include "i2c.h"
;#include "uart.h"
;
;#define DISABLE_I2C	CONTROL_REG = 0xc8;
;#define ENABLE_I2C	CONTROL_REG = 0x01;
;
;
;//	if EEPROM_WRITE is defined,
;//		 you can call RAM2EEPROM
;//	if EEPROM_READ is defined as not 0,
;//		you can call EEPROM2RAM
;//	if EEPROM_READ is defined as 0,
;//		you can call EEPROM2RAM but it won't modify RAM
;//	if EEPROM_DEBUG is defined as not 0,
;//		checksums will be displayed every 256 bytes during read/write
;//	if EEPROM_WRITE_ONCE is defined as not 0,
;//		RAM2EEPROM will modify itself so it can't be called again.
;//		(this is useful if the code if loaded above 0x43ff and won't survive
;//		a p-fail)
;
;#if	!defined(EEPROM_DEBUG)
;#define EEPROM_DEBUG 0			// if 1, show checksum every 256 bytes
;#endif
;
;#if !defined(EEPROM_WRITE_ONCE)
;#define EEPROM_WRITE_ONCE 1		// if 1, disable self after writing
;#endif
;
;// The I2C bus control lines are muxed into the upper 4 bits of
;// the PSR when the I2C bus is enabled in the control register.
;
;//#define SET_SDA_IN	asm("stp 7")
;//#define CLR_SDA_IN	asm("clp 7")
;#define SET_SDA_OUT	asm("stp 6")
;#define CLR_SDA_OUT	asm("clp 6")
;//#define SET_SCL_IN	asm("stp 5")
;//#define CLR_SCL_IN	asm("clp 5")
;#define SET_SCL_OUT	asm("stp 4")
;#define CLR_SCL_OUT	asm("clp 4")
;
;void EepromAck(void);
;
;//	RRRR    AAA   M   M   222   EEEEE  EEEEE  PPPP   RRRR    OOO   M   M
;//	R   R  A   A  MM MM  2   2  E      E      P   P  R   R  O   O  MM MM
;//	RRRR   AAAAA  M M M     2   EEE    EEE    PPPP   RRRR   O   O  M M M
;//	R  R   A   A  M   M   22    E      E      P      R  R   O   O  M   M
;//	R   R  A   A  M   M  22222  EEEEE  EEEEE  P      R   R   OOO   M   M
;
;#if defined(EEPROM_WRITE)
;BOOL RAM2EEPROM()
;{
;	static BOOL	bRetCode = FALSE;
;	static BYTE	b, i;
;	static BYTE	RAM2E_CHIP;	// this value toggles between 0xa0 and 0xa2 which
;						// selects the first or the second EEPROM chip.
;	static ONION	checkSum;
;	static WORD	wByteCount;
;	static ONION	pSRAM;
;#if EEPROM_DEBUG
;	static BYTE	bDump32 = 32;
;#endif
;
;	puts("\r\nCopying SRAM to EEPROM\r\n");
_RAM2EEPROM:
		LDI r4,0xf5 ;__Lstrings+0x46c
		LDI r5,0x3f ;__Lstrings+0x46c>>8
		JSR _puts
;	putFlush();
		JSR _putFlush
;
;// This routine copies the contents of the RAM into the EEPROM.
;// The flow of this routine is ...
;// Enable I2C bus
;// send control word (random write)
;// IF ack, continue, else error
;// write data until done, compute 16 bit checksum (crc?).
;// write the checksum bytes
;// Disable I2C bus
;
;	// Enable the I2C Bus
;	SET_SDA_OUT;
		STP 6
;	SET_SCL_OUT;
		STP 4
;	ENABLE_I2C;
		LDI r0,0x01
		STA r0,_CONTROL_REG
;	RAM2E_CHIP = 0xa0;		// the control word for the first EEPROM=a0
		LDI r0,0xa0
		STA r0,_rx_desc_config+0x20c
;	checkSum.w = 0;			// init for the write loop
		XOR r0
		STA r0,_rx_desc_config+0x210
		STA r0,_rx_desc_config+0x20f
;
;	pSRAM.w = 0x0400;		// Load the EEPROM starting at address 0x400 (int vector table and up)
		LDI r0,0x04
		STA r0,_rx_desc_config+0x214
		XOR r0
		STA r0,_rx_desc_config+0x213
;	wByteCount = 0x2000;	// bytes in first block
		LDI r0,0x20
		STA r0,_rx_desc_config+0x212
		XOR r0
		STA r0,_rx_desc_config+0x211
;
;// We write the EEPROM in 64 byte pages.
;// The EEPROM has a limit of one page maximum for each write.
;nextPage:
;	i2cQbit();		// wait for a quarter of a bit
_RAM2EEPROM__2f:
		JSR _i2cHbit
;	CLR_SDA_OUT;	// I2C START Condition
		CLP 6
;	i2cQbit();				// wait for a quarter of a bit
		JSR _i2cHbit
;	if (!i2cWrite(RAM2E_CHIP))	// control word indicates a Write (bit0=0)
		LDA r4,_rx_desc_config+0x20c
		JSR _i2cWrite
		T0X r1
		BRNE _RAM2EEPROM__42 ;(+03)
		JMP _RAM2EEPROM__e5
;		goto prestop;		// No ACK
;	// If we don't get an ACK, then the write is still in progress
;	// so just try again by jumping to PRESTOP
;
;	// send the start address for this page (SRAM location - 0x400)
;	if (!i2cWrite(pSRAM.b.h - 4))
_RAM2EEPROM__42:
		LDI r1,0xfc
		LDA r0,_rx_desc_config+0x214
		ADD r1
		T0X r4
		JSR _i2cWrite
		T0X r1
		BRNE _RAM2EEPROM__52 ;(+03)
		JMP _RAM2EEPROM__139
;		goto error;			// Fail if we don't get an ACK bit
;	if (!i2cWrite(pSRAM.b.l))
_RAM2EEPROM__52:
		LDA r4,_rx_desc_config+0x213
		JSR _i2cWrite
		T0X r1
		BRNE _RAM2EEPROM__5e ;(+03)
		JMP _RAM2EEPROM__139
;		goto error;			// Fail if we don't get an ACK bit
;
;	for (i=0; i<64; i++)
_RAM2EEPROM__5e:
		XOR r0
		STA r0,_rx_desc_config+0x20b
		LDI r1,0x40
		LDA r0,_rx_desc_config+0x20b
		CMP r1
		BRCS _RAM2EEPROM__d2 ;(+68)
;		{
;		b = *pSRAM.pb++;	// get next byte
_RAM2EEPROM__6a:
		LDA r2,_rx_desc_config+0x213
		LDA r3,_rx_desc_config+0x214
		LDX r2
		STA r0,_rx_desc_config+0x20a
		TX0 r2
		LDA r1,_rx_desc_config+0x214
		UPP r0
		STA r0,_rx_desc_config+0x213
		STA r1,_rx_desc_config+0x214
;
;#if EEPROM_DEBUG
;		if (bDump32)
;			{
;			putbs(b);
;			bDump32--;
;			}
;#endif
;		if (!i2cWrite(b))	// write it out
		LDA r4,_rx_desc_config+0x20a
		JSR _i2cWrite
		T0X r1
		BRNE _RAM2EEPROM__8b ;(+03)
		JMP _RAM2EEPROM__139
;			goto error;		// Fail if we don't get an ACK bit
;		checkSum.w += b;	// add to check sum
_RAM2EEPROM__8b:
		LDA r0,_rx_desc_config+0x20a
		LDI r1,0x00
		STA r0,Aa_UsbVendSetEndPoint
		STA r1,Aa_UsbVendSetEndPoint+0x1
		LDA r0,_rx_desc_config+0x20f
		LDA r1,Aa_UsbVendSetEndPoint
		ADD r1
		STA r0,_rx_desc_config+0x20f
		LDA r0,_rx_desc_config+0x210
		LDA r1,Aa_UsbVendSetEndPoint+0x1
		ADC r1
		STA r0,_rx_desc_config+0x210
;
;#if EEPROM_DEBUG
;		if (pSRAM.b.l == 0)
;			{
;			putw(pSRAM);
;			putc('=');
;			putws(checkSum);
;			putFlush();
;			}
;#endif
;
;		wByteCount--;
		LDA r0,_rx_desc_config+0x211
		DEC r0
		STA r0,_rx_desc_config+0x211
		BRCS _RAM2EEPROM__ba ;(+07)
		LDA r0,_rx_desc_config+0x212
		DEC r0
		STA r0,_rx_desc_config+0x212
;		if (!wByteCount)
_RAM2EEPROM__ba:
		LDA r0,_rx_desc_config+0x211
		LDA r1,_rx_desc_config+0x212
		OR  r1
		BREQ _RAM2EEPROM__eb ;(+28)
		LDA r0,_rx_desc_config+0x20b
		INC r0
		STA r0,_rx_desc_config+0x20b
		LDI r1,0x40
		LDA r0,_rx_desc_config+0x20b
		CMP r1
		BRCC _RAM2EEPROM__6a ;(-68)
;			goto done;
;		}
;
;	CLR_SCL_OUT;
_RAM2EEPROM__d2:
		CLP 4
;	i2cQbit();
		JSR _i2cHbit
;	CLR_SDA_OUT;
		CLP 6
;	i2cQbit();
		JSR _i2cHbit
;
;stop:
;	SET_SCL_OUT;
_RAM2EEPROM__da:
		STP 4
;	i2cHbit();
		JSR _i2cHbit
;	SET_SDA_OUT;
		STP 6
;	i2cHbit();
		JSR _i2cHbit
;	goto nextPage;
		JMP _RAM2EEPROM__2f
;
;prestop:
;asm("prestop:");
;	EepromAck();
_RAM2EEPROM__e5:
		JSR _EepromAck
;	goto stop;
		JMP _RAM2EEPROM__da
;
;done:
;	if (RAM2E_CHIP != 0xa2)
_RAM2EEPROM__eb:
		LDI r1,0xa2
		LDA r0,_rx_desc_config+0x20c
		CMP r1
		BREQ _RAM2EEPROM__102 ;(+0f)
;		{
;		RAM2E_CHIP = 0xa2;
		STA r1,_rx_desc_config+0x20c
;		wByteCount = 0x1ffe;	// bytes in second block
		LDI r0,0x1f
		STA r0,_rx_desc_config+0x212
		LDI r0,0xfe
		STA r0,_rx_desc_config+0x211
;		goto prestop;
		BRNE _RAM2EEPROM__e5 ;(-1d)
;		}
;
;	if (!i2cWrite(checkSum.b.l))
_RAM2EEPROM__102:
		LDA r4,_rx_desc_config+0x20f
		JSR _i2cWrite
		T0X r1
		BREQ _RAM2EEPROM__139 ;(+2e)
;		goto error;		// Fail if we don't get an ACK bit
;	if (!i2cWrite(checkSum.b.h))
		LDA r4,_rx_desc_config+0x210
		JSR _i2cWrite
		T0X r1
		BREQ _RAM2EEPROM__139 ;(+25)
;		goto error;		// Fail if we don't get an ACK bit
;	bRetCode = TRUE;
		LDI r0,0x01
		STA r0,_rx_desc_config+0x209
;	puto(checkSum);
		LDA r4,_rx_desc_config+0x20f
		LDA r5,_rx_desc_config+0x210
		JSR _puto
;	puts(" \aEEPROM written\r\n");
		LDI r4,0xe2 ;__Lstrings+0x459
		LDI r5,0x3f ;__Lstrings+0x459>>8
_RAM2EEPROM__126:
		JSR _puts
;
;exit:
;	EepromAck();
		JSR _EepromAck
;	DISABLE_I2C;
		LDI r0,0xc8
		STA r0,_CONTROL_REG
;	asm("clp 7");
		CLP 7
;	asm("clp 6");
		CLP 6
;	asm("clp 5");
		CLP 5
;	asm("clp 4");
		CLP 4
;	return bRetCode;
		LDA r0,_rx_desc_config+0x209
		RTS
;
;error:
;	puto(pSRAM);
_RAM2EEPROM__139:
		LDA r4,_rx_desc_config+0x213
		LDA r5,_rx_desc_config+0x214
		JSR _puto
;	puts(" \aEEPROM write FAILED\r\n");
		LDI r4,0x10 ;__Lstrings+0x487
		LDI r5,0x40 ;__Lstrings+0x487>>8
		JMP _RAM2EEPROM__126
;	goto exit;
;}
;#endif
;
;#if defined(EEPROM_READ)
;BOOL EEPROM2RAM()
;{
;	static BYTE	b, i;
;	static ONION	pSRAM;
;	static BYTE	RAM2E_CHIP;	// this value toggles between 0xa0 and 0xa2 which
;						// selects the first or the second EEPROM chip.
;	static ONION	checkSum, ckRead;
;	static WORD	wByteCount;
;#if EEPROM_DEBUG
;	static BYTE	bDump32 = 32;
;#endif
;
;	putsNow("Reading EEPROM\r\n");
;	// Enable the I2C Bus
;	SET_SDA_OUT;
;	SET_SCL_OUT;
;	ENABLE_I2C;
;	checkSum.w = 0;
;	RAM2E_CHIP = 0xa0;		// the control word for the first EEPROM=a0
;	pSRAM.w = 0x0400;		// Load the EEPROM starting at address 0x400 (int vector table and up)
;	wByteCount = 0x2000;	// bytes in first block
;
;nextPage:
;	i2cQbit();		// wait for a quarter of a bit
;	CLR_SDA_OUT;	// I2C START Condition
;	i2cQbit();				// wait for a quarter of a bit
;	if (!i2cWrite(RAM2E_CHIP))	// control word indicates a Write (bit0=0)
;		{
;		puts("i2cWrite 1 failed");		// No ACK
;		goto done;
;		}
;	// If we don't get an ACK, then the write is still in progress
;	// so just try again by jumping to PRESTOP
;
;	// send the start address for this page (SRAM location - 0x400)
;	b = (pSRAM.b.h & 0x7f) - 0x04;
;	if (!i2cWrite(b))
;		{
;		puts("i2cWrite 2 failed");		// No ACK
;		goto done;
;		}
;	if (!i2cWrite(pSRAM.b.l))
;		{
;		puts("i2cWrite 3 failed");		// No ACK
;		goto done;
;		}
;
;	CLR_SCL_OUT;
;	i2cHbit();
;	SET_SCL_OUT;
;	i2cHbit();
;	CLR_SDA_OUT;
;	i2cQbit();
;
;	if (!i2cWrite(RAM2E_CHIP | 1))	// control word indicates a Read (bit0=1)
;		{
;		puts("i2cWrite 4 failed");		// No ACK
;		goto done;
;		}
;
;	for (i=0; i<64; i++)
;		{
;		b = i2cRead();		// get next byte
;		EepromAck();
;#if EEPROM_DEBUG
;		if (bDump32)
;			{
;			putbs(b);
;			bDump32--;
;			}
;#endif
;		checkSum.w += b;	// add to check sum
;		*pSRAM.pb++ = b;	// save byte
;
;#if EEPROM_DEBUG
;		if (pSRAM.b.l == 0)
;			{
;			putw(pSRAM);
;			putc('=');
;			putws(checkSum);
;			putFlush();
;			}
;#endif
;
;		wByteCount--;
;		if (!wByteCount)
;			goto done;
;		}
;
;stop:
;	SET_SCL_OUT;
;	i2cHbit();
;	SET_SDA_OUT;
;	i2cHbit();
;	goto nextPage;
;
;prestop:
;	EepromAck();
;	goto stop;
;
;done:
;	if (RAM2E_CHIP != 0xa2)
;		{
;		RAM2E_CHIP = 0xa2;
;		wByteCount = 0x1ffe;	// bytes in second block
;		goto prestop;
;		}
;
;	ckRead.b.h = i2cRead();		// get next byte
;	ckRead.b.l = i2cRead();		// get next byte
;
;	EepromAck();
;	SET_SDA_OUT;	// and high again
;	DISABLE_I2C;
;
;#if EEPROM_DEBUG
;	putw(pSRAM);
;	putc('=');
;	putw(checkSum);
;	puts(" read ");
;	putw(ckRead);
;#endif
;
;
;	asm("clp 7");
;	asm("clp 6");
;	asm("clp 5");
;	asm("clp 4");
;
;#if EEPROM_DEBUG
;	putFlush();
;#endif
;
;	return TRUE;
;}
;#endif
;
;BOOL i2cWrite(BYTE b)
;{
;	static BYTE	i;
;	static BYTE	bRetCode;
;
;	bRetCode = FALSE;
_i2cWrite:
		XOR r0
		STA r0,_rx_desc_config+0x20e
;	for (i=0; i<9; i++)	// for 9 bits
		STA r0,_rx_desc_config+0x20d
		LDI r1,0x09
		LDA r0,_rx_desc_config+0x20d
		CMP r1
		BRCS _i2cWrite__3e ;(+2f)
;		{
_i2cWrite__f:
		STA r4,Aa_UartReadString
;		CLR_SCL_OUT;
		CLP 4
;		i2cQbit();
		JSR _i2cHbit
;		SET_SDA_OUT;
		STP 6
;		if ((b & 0x80) == 0)	// test hi bit
		LDA r0,Aa_UartReadString
		BRMI _i2cWrite__1d ;(+01)
;			CLR_SDA_OUT;
		CLP 6
;
;		i2cQbit();
_i2cWrite__1d:
		JSR _i2cHbit
;		SET_SCL_OUT;
		STP 4
;		i2cHbit();
		JSR _i2cHbit
;
;		b += b;		// shift left without regard to carry
		LDA r4,Aa_UartReadString
		TX0 r4
		ADD r4
		T0X r4
;		b |= 1;		// make ninth bit a 1
		LDI r1,0x01
		TX0 r4
		OR  r1
		T0X r4
		LDA r0,_rx_desc_config+0x20d
		INC r0
		STA r0,_rx_desc_config+0x20d
		LDI r1,0x09
		LDA r0,_rx_desc_config+0x20d
		CMP r1
		BRCC _i2cWrite__f ;(-2f)
;// This will be the ACK bit which is sent by the other chip. By sending a ninth
;// bit of 1, we will tristate the SDA pin during the ACK bit.
;		}
;
;	asm("br1 7,error");	// Fail if we don't get an ACK bit
_i2cWrite__3e:
		BR1 7,_i2cWrite__45 ;(+05)
;	bRetCode = TRUE;
		LDI r0,0x01
		STA r0,_rx_desc_config+0x20e
;
;asm("error:");
;
;	return bRetCode;
_i2cWrite__45:
		LDA r0,_rx_desc_config+0x20e
;}
;
;#if defined(EEPROM_READ)
;BYTE i2cRead()
;{
;	static BYTE	b, i;
;
;	for (i=0; i<8; i++)
;		{
;		CLR_SCL_OUT;
;		i2cQbit();
;		SET_SDA_OUT;		// Insures we've removed the ACK bit
;		i2cQbit();
;		SET_SCL_OUT;
;		i2cQbit();
;		b += b;					// shift left
;		asm("br0 7,zero");
;		b |= 1;					// set low bit
;		asm("zero:");
;		i2cQbit();
;		}
;	return b;
;}
;#endif
;
;void i2cHbit()	// Wait for 1/2 of a I2C bit.
;{
;	i2cQbit();
;}
;
;void i2cQbit()	// Wait for 1/4 of a I2C bit.
;{
_i2cHbit:
		RTS
;// One I2C bit = 400Khz = 30 clocks @ 12Mhz. So, we need to wait for 8 clocks.
;// It takes 5 clocks to execute the JSR and 5 more to execute the rts
;// so we don't actully have to do any waiting in this routine, just getting
;// here and returning takes more than enough time.
;// the JSR into this routine takes 5 clocks.
;
;	return;			// 5 clocks, total=10 clocks.
;}
;
;#if EEPROM_DEBUG
;void EepromSecure()
;{
;	static BYTE	RAM2E_CHIP;	// this value toggles between 0xa0 and 0xa2 which
;						// selects the first or the second EEPROM chip.
;
;	RAM2E_CHIP = 0xa0;
;
;nextChip:
;	SET_SDA_OUT;
;	SET_SCL_OUT;
;	ENABLE_I2C;
;
;	i2cQbit();			// wait for a quarter of a bit
;	CLR_SDA_OUT;		// I2C START Condition
;	i2cQbit();				// wait for a quarter of a bit
;	i2cWrite(RAM2E_CHIP);	// control word indicates a Write (bit0=0)
;
;	i2cWrite(0x80);		// 1xx0000x = starting block 0
;	i2cWrite(0x00);		// xxxxxxxx = don't care
;	i2cWrite(0xc0);		// 11xx0000 = set, read, 0 blocks
;
;	puts("\r\nStart block:");
;	putb(i2cRead());	// get a byte
;	EepromAck();		// send the ACK bit
;
;	puts(", Block Length:");
;	putb(i2cRead());	// get a byte
;	EepromAck();
;	SET_SDA_OUT;
;
;	DISABLE_I2C;
;
;	if (RAM2E_CHIP == 0xa2)
;		return;
;	
;	RAM2E_CHIP = 0xa2;
;	goto nextChip;
;}
;
;void EepromUnsecure()
;{
;	static BYTE	RAM2E_CHIP;	// this value toggles between 0xa0 and 0xa2 which
;						// selects the first or the second EEPROM chip.
;
;	RAM2E_CHIP = 0xa0;
;
;nextChip:
;	SET_SDA_OUT;
;	SET_SCL_OUT;
;	ENABLE_I2C;
;
;	i2cQbit();		// wait for a quarter of a bit
;	CLR_SDA_OUT;	// I2C START Condition
;	i2cQbit();				// wait for a quarter of a bit
;	i2cWrite(RAM2E_CHIP);	// control word indicates a Write (bit0=0)
;
;	i2cWrite(0x90);		// 1xx1000x = starting block 0
;	i2cWrite(0x00);		// xxxxxxxx = don't care
;	i2cWrite(0x80);		// 10xx0000 = set, write, 0 blocks
;	EepromAck();
;	SET_SDA_OUT;
;
;	DISABLE_I2C;
;
;	if (RAM2E_CHIP == 0xa2)
;		return;
;
;	RAM2E_CHIP = 0xa2;
;	goto nextChip;
;}
;
;#endif
;
;void EepromAck()
;{
;	CLR_SCL_OUT;	// SCL goes low to complete the ACK bit.
_EepromAck:
		CLP 4
;	i2cQbit();
		JSR _i2cHbit
;	CLR_SDA_OUT;	// SDA goes low in preparation for a STOP
		CLP 6
;	i2cQbit();
		JSR _i2cHbit
;	SET_SCL_OUT;	// and high again
		STP 4
;	i2cHbit();
		RTS
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\PRINTER.C
;// printer.c
;
;#include "vauto.h"
;#include "printer.h"
;#include "uart.h"
;
;#define DEBUG_ID		0
;#define DEBUG_VERBOSE	0
;
;#if DEBUG_VERBOSE
;void spew(char *p);
;#else // !DEBUG_VERBOSE
;#define spew(p)
;#endif // !DEBUG_VERBOSE
;
;// the following hard-coded locations MUST be editted
;// if your memory map is not the vautomation default
;
;volatile BYTE		PP_DATA @0x220;	// External PP data register
;volatile CTRS_1284	PP_CTRS @0x221;	// External PP 
;volatile CTRH_1284	PP_CTRH @0x222;	// External PP 
;volatile CTL_1284	PP_CTL  @0x223;	// External PP control signal register
;volatile CTL_1284	PP_CTLZ @0x224;	// External PP control signal direction register
;
;BYTE USB_PRINTER_MODE = 0;
;CTL_1284	newCtl1284;
;
;void Init1284()
;{
;#if WANT_HARDWARE
;	BYTE		b;
;	CTL_1284	newCtlz1284;
;
;	spew("Init1284-start");
;
;							// init the parallel printer by doing a hard reset
;							// setup the V1284 registers
;	PP_CTRS.Tsetup = 11;	// 12 clocks = 1us setup width
_Init1284:
		LDA r0,_PP_CTRS
		LDI r1,0x0f
		AND r1
		LDI r1,0xb0
		OR  r1
		STA r0,_PP_CTRS
;	PP_CTRS.Tstrobe = 11;	// 12 clocks = 1us strobe width
		LDA r0,_PP_CTRS
		LDI r1,0xf0
		AND r1
		LDI r1,0x0b
		OR  r1
		STA r0,_PP_CTRS
;	*(PBYTE)&PP_CTRH = 0;
		XOR r0
		STA r0,_PP_CTRH
;	PP_CTRH.Thold = 11;		// 12 clocks = 1us hold width
		LDA r0,_PP_CTRH
		LDI r1,0x0f
		AND r1
		LDI r1,0xb0
		OR  r1
		STA r0,_PP_CTRH
;
;	*(PBYTE)&newCtl1284 = 0;
		XOR r0
		STA r0,_newCtl1284
;	newCtl1284.autofeed_n = 1;
		LDI r1,0x40
		OR  r1
		STA r0,_newCtl1284
;	PP_CTL = newCtl1284;
		STA r0,_PP_CTL
;
;	*(PBYTE)&newCtlz1284 = 0;
		LDI r2,0x00
;	newCtlz1284.init_n = 1;
		TX0 r2
		LDI r1,0x80
		OR  r1
;	newCtlz1284.autofeed_n = 1;
		LDI r1,0x40
		OR  r1
;	newCtlz1284.selectin_n = 1;
		LDI r1,0x20
		OR  r1
		T0X r2
;	PP_CTLZ = newCtlz1284;	// drive the upper 3 control signals to cause a reset
		STA r2,_PP_CTLZ
;
;	for (b=0x60; b; b++)	// loop for about 50us
		LDI r1,0x60
		BRNE _Init1284__4a ;(+01)
_Init1284__49:
		INC r1
_Init1284__4a:
		TX0 r1
		BRNE _Init1284__49 ;(-04)
;		;
;
;	PP_CTL.init_n = 1;		// end the reset
		LDA r0,_PP_CTL
		LDI r1,0x80
		OR  r1
		STA r0,_PP_CTL
;
;	for (b=0x60; b; b++)	// loop for about 50us
		LDI r1,0x60
		BRNE _Init1284__5b ;(+01)
_Init1284__5a:
		INC r1
_Init1284__5b:
		TX0 r1
		BRNE _Init1284__5a ;(-04)
;		;
;
;	if (!PP_CTL.select)
		LDA r0,_PP_CTL
		BTT C
		BRNE _Init1284__6b ;(+07)
;		{
;		puts("\r\n\aNo printer found\r\n");
		LDI r4,0x6e ;__Lstrings+0x4e5
		LDI r5,0x40 ;__Lstrings+0x4e5>>8
		JSR _puts
;		}
;
;	spew("Init1284-end");
;#endif // WANT_HARDWARE
;
;	USB_PRINTER_MODE = 0;
_Init1284__6b:
		XOR r0
		STA r0,_USB_PRINTER_MODE
;	return;
		RTS
;}
;
;BYTE DEVICE_ID_1284[255];	// dunno max size yet
;BYTE DEVICE_ID_LENGTH = 0;
;
;void get1284id()
;{
;#if WANT_HARDWARE
;	BYTE	b;
;
;	DEVICE_ID_LENGTH = 0;
_get1284id:
		XOR r0
		STA r0,_DEVICE_ID_LENGTH
;// 0) Initialize the V1284 core 
;	Init1284();
		JSR _Init1284
;// 1) STDIS=1 - Disable automatic STROBE_N generation
;	PP_CTRH.STDIS = 1;
		LDA r0,_PP_CTRH
		LDI r1,0x01
		OR  r1
		STA r0,_PP_CTRH
;	spew("1");
;// 2) DOUT=0x05 - Byte mode extensibility request value=DEVICE_ID
;	PP_DATA = 0x05;
		LDI r0,0x05
		STA r0,_PP_DATA
;	spew("2");
;// 3) DRVDO=1 - drive the DOUT bus (1284 event 0)
;	PP_CTRH.DRVDO = 1;
		LDA r0,_PP_CTRH
		LDI r1,0x04
		OR  r1
		STA r0,_PP_CTRH
;	spew("3");
;// 4) SELECTIN_N=1, AUTOFD_N=0 - Ask the peripheral if it is 1284 compliant (1)
;	PP_CTL.selectin_n = 1;
		LDA r0,_PP_CTL
		LDI r1,0x20
		OR  r1
		STA r0,_PP_CTL
;	PP_CTL.autofeed_n = 0;
		LDA r0,_PP_CTL
		LDI r1,0xbf
		AND r1
		STA r0,_PP_CTL
;	spew("4");
;// 5) Wait for ACK_N going low, Timeout after 50us. (2)
;//	If we timeout, the printer is not 1284 compliant.
;	for (b=0x60; b; b++)	// loop for about 50us
		LDI r1,0x60
		BRNE _get1284id__3b ;(+07)
;		{
;		if (!PP_CTL.ack_n)
_get1284id__34:
		LDA r0,_PP_CTL
		BTT 4
		BREQ _get1284id__3e ;(+04)
		INC r1
_get1284id__3b:
		TX0 r1
		BRNE _get1284id__34 ;(-0a)
;			break;
;		}
;
;	for (b=4; b; b--)	// loop for about 1us
_get1284id__3e:
		LDI r1,0x04
		BRNE _get1284id__43 ;(+01)
_get1284id__42:
		DEC r1
_get1284id__43:
		TX0 r1
		BRNE _get1284id__42 ;(-04)
;		;
;
;	spew("5");
;// 6) Verify that FAULT_N, PERROR and SELECT are all 1. If not, the printer is not
;//	1284 compliant.
;	if (PP_CTL.ack_n || !PP_CTL.fault_n || !PP_CTL.perror || !PP_CTL.select)
		LDA r0,_PP_CTL
		BTT 4
		BRNE _get1284id__5e ;(+12)
		LDA r0,_PP_CTL
		BTT Z
		BREQ _get1284id__5e ;(+0c)
		LDA r0,_PP_CTL
		BTT N
		BREQ _get1284id__5e ;(+06)
		LDA r0,_PP_CTL
		BTT C
		BRNE _get1284id__a5 ;(+47)
;		{
;		putbs(*(PBYTE)&PP_CTRS);
_get1284id__5e:
		LDA r4,_PP_CTRS
		JSR _putbs
;		putbs(*(PBYTE)&PP_CTRH);
		LDA r4,_PP_CTRH
		JSR _putbs
;		putbs(*(PBYTE)&PP_CTL);
		LDA r4,_PP_CTL
		JSR _putbs
;		putb(*(PBYTE)&PP_CTLZ);
		LDA r4,_PP_CTLZ
		JSR _putb
;		puts(" \aget1284id: Printer is not 1284 compliant\r\n");
		LDI r4,0x28 ;__Lstrings+0x49f
		LDI r5,0x40 ;__Lstrings+0x49f>>8
		JSR _puts
;
;{
;WORD	w;
;
;for (w=1; w; w++)
		LDI r2,0x01 ;__Lreset+0x1
		LDI r3,0x00 ;__Lreset+0x1>>8
		BREQ _get1284id__84 ;(+01)
_get1284id__83:
		UPP r2
_get1284id__84:
		TX0 r3
		T0X r1
		TX0 r2
		OR  r1
		BRNE _get1284id__83 ;(-07)
;	;
;
;putbs(*(PBYTE)&PP_CTRS);
		LDA r4,_PP_CTRS
		JSR _putbs
;putbs(*(PBYTE)&PP_CTRH);
		LDA r4,_PP_CTRH
		JSR _putbs
;putbs(*(PBYTE)&PP_CTL);
		LDA r4,_PP_CTL
		JSR _putbs
;putb(*(PBYTE)&PP_CTLZ);
		LDA r4,_PP_CTLZ
		JSR _putb
;putCrlf();
		JMP _putCrlf
;}
;		return;
;		}
;
;	spew("6");
;// 7) STROBE_N=0 (STLOW=1), then wait 1 us. Latch the Extensibility value. (3)
;	PP_CTRH.STLOW = 1;
_get1284id__a5:
		LDA r0,_PP_CTRH
		LDI r1,0x02
		OR  r1
		STA r0,_PP_CTRH
;	for (b=4; b; b--)	// loop for about 1us
		LDI r1,0x04
		BRNE _get1284id__b3 ;(+01)
_get1284id__b2:
		DEC r1
_get1284id__b3:
		TX0 r1
		BRNE _get1284id__b2 ;(-04)
;		;
;	spew("7");
;// 8) STROBE_N=1 (STLOW=0), AUTOFD_N=1. Acknowledge 1284 compliance (4)
;	PP_CTRH.STLOW = 0;
		LDA r0,_PP_CTRH
		LDI r1,0xfd
		AND r1
		STA r0,_PP_CTRH
;	PP_CTL.autofeed_n = 1;
		LDA r0,_PP_CTL
		LDI r1,0x40
		OR  r1
		STA r0,_PP_CTL
;	spew("8");
;// 9) Wait for ACK_N=1, Timeout after 50 us. (6)
;	for (b=0x60; b; b++)	// loop for about 50us
		LDI r1,0x60
		BRNE _get1284id__d3 ;(+07)
;		{
;		if (PP_CTL.ack_n)
_get1284id__cc:
		LDA r0,_PP_CTL
		BTT 4
		BRNE _get1284id__d6 ;(+04)
		INC r1
_get1284id__d3:
		TX0 r1
		BRNE _get1284id__cc ;(-0a)
;			break;
;		}
;	spew("9");
;// 10) Verify that FAULT_N=0. Printer has data to send. (5)
;	if (PP_CTL.fault_n)
_get1284id__d6:
		LDA r0,_PP_CTL
		BTT Z
		BREQ _get1284id__f5 ;(+19)
;		{
;		putbs(*(PBYTE)&PP_CTRS);
		LDA r4,_PP_CTRS
		JSR _putbs
;		putbs(*(PBYTE)&PP_CTRH);
		LDA r4,_PP_CTRH
		JSR _putbs
;		putb(*(PBYTE)&PP_CTL);
		LDA r4,_PP_CTL
		JSR _putb
;
;		puts("\r\n\aget1284id: Printer has no data (1)\r\n");
		LDI r4,0xac ;__Lstrings+0x523
		LDI r5,0x40 ;__Lstrings+0x523>>8
		JMP _puts
;		return;
;		}
;	spew("10");
;// 11) DRVDO=0. tristate the data bus (14)
;	PP_CTRH.DRVDO = 0;
_get1284id__f5:
		LDA r0,_PP_CTRH
		LDI r1,0xfb
		AND r1
		STA r0,_PP_CTRH
;	spew("11");
;// 12) Wait 1 us.
;step_12:
;	for (b=4; b; b--)	// loop for about 1us
_get1284id__fe:
		LDI r1,0x04
		BRNE _get1284id__103 ;(+01)
_get1284id__102:
		DEC r1
_get1284id__103:
		TX0 r1
		BRNE _get1284id__102 ;(-04)
;		;
;// 13) AUTOFD_N=1, request data (7)
;	PP_CTL.autofeed_n = 1;
		LDA r0,_PP_CTL
		LDI r1,0x40
		OR  r1
		STA r0,_PP_CTL
;	spew("13");
;// 14) Wait for ACK_N=0, Timeout after 50 us. (10)
;	for (b=0x60; b; b++)	// loop for about 50us
		LDI r1,0x60
		BRNE _get1284id__11a ;(+07)
;		{
;		if (!PP_CTL.ack_n)
_get1284id__113:
		LDA r0,_PP_CTL
		BTT 4
		BREQ _get1284id__11d ;(+04)
		INC r1
_get1284id__11a:
		TX0 r1
		BRNE _get1284id__113 ;(-0a)
;			break;
;		}
;	if (b)
_get1284id__11d:
		TX0 r1
		BREQ _get1284id__127 ;(+07)
;		{
;		puts("\r\n\aget1284id: Printer has no data (2)\r\n");
		LDI r4,0x84 ;__Lstrings+0x4fb
		LDI r5,0x40 ;__Lstrings+0x4fb>>8
		JMP _puts
;		return;
;		}
;	spew("14");
;// 15) Read DIN which is a byte of data from the printer.
;	DEVICE_ID_1284[DEVICE_ID_LENGTH] = PP_DATA;
_get1284id__127:
		LDI r2,0xf8 ;_DEVICE_ID_1284
		LDI r3,0x4c ;_DEVICE_ID_1284>>8
		LDA r0,_DEVICE_ID_LENGTH
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDA r0,_PP_DATA
		STX r2
;#if DEBUG_ID
;	putbs(DEVICE_ID_1284[DEVICE_ID_LENGTH]);
;#endif // DEBUG_ID
;	DEVICE_ID_LENGTH++;
		LDA r0,_DEVICE_ID_LENGTH
		INC r0
		STA r0,_DEVICE_ID_LENGTH
;	spew("15");
;// 16) AUTOFD_N=1. (10)
;	PP_CTL.autofeed_n = 1;
		LDA r0,_PP_CTL
		LDI r1,0x40
		OR  r1
		STA r0,_PP_CTL
;	spew("16");
;// 17) STROBE_N=0. (16)
;	PP_CTRH.STLOW = 1;
		LDA r0,_PP_CTRH
		LDI r1,0x02
		OR  r1
		STA r0,_PP_CTRH
;	spew("17");
;// 18) Wait for ACK_N=1, timeout after 50 us. (11)
;	for (b=0x60; b; b++)	// loop for about 50us
		LDI r1,0x60
		BRNE _get1284id__15d ;(+07)
;		{
;		if (PP_CTL.ack_n)
_get1284id__156:
		LDA r0,_PP_CTL
		BTT 4
		BRNE _get1284id__160 ;(+04)
		INC r1
_get1284id__15d:
		TX0 r1
		BRNE _get1284id__156 ;(-0a)
;			break;
;		}
;	spew("18");
;// 19) STROBE_N=1. (17) end of this transfer
;	PP_CTRH.STLOW = 0;
_get1284id__160:
		LDA r0,_PP_CTRH
		LDI r1,0xfd
		AND r1
		STA r0,_PP_CTRH
;	spew("19");
;// 20) If FAULT_N=1, then there is no more data, else, go step 12.
;	if (DEVICE_ID_LENGTH == 255)
		LDI r1,0xff
		LDA r0,_DEVICE_ID_LENGTH
		CMP r1
		BRNE _get1284id__17b ;(+0a)
;		{
;		puts("\r\n\aget1284id: too long\r\n");
		LDI r4,0x55 ;__Lstrings+0x4cc
		LDI r5,0x40 ;__Lstrings+0x4cc>>8
		JSR _puts
;		}
		JMP _get1284id__184
;	else if (!PP_CTL.fault_n)
_get1284id__17b:
		LDA r0,_PP_CTL
		BTT Z
		BRNE _get1284id__184 ;(+03)
		JMP _get1284id__fe
;		goto step_12;
;
;	spew("20");
;// 21) STDIS=0, DRVDO=0 - disable manual control of STROBE and DOUT bus.
;	PP_CTRH.STDIS = 0;
_get1284id__184:
		LDA r0,_PP_CTRH
		LDI r1,0xfe
		AND r1
		STA r0,_PP_CTRH
;	PP_CTRH.DRVDO = 0;
		LDA r0,_PP_CTRH
		LDI r1,0xfb
		AND r1
		STA r0,_PP_CTRH
;	spew("21");
;// 22) SELECTIN_N=0,AUTOFD_N=1 - exit 1284 extensibility mode (22)
;	PP_CTL.selectin_n = 0;
		LDA r0,_PP_CTL
		LDI r1,0xdf
		AND r1
		STA r0,_PP_CTL
;	PP_CTL.autofeed_n = 1;
		LDA r0,_PP_CTL
		LDI r1,0x40
		OR  r1
		STA r0,_PP_CTL
;	spew("22");
;// 23) Wait for ACK_N=0, timeout after 50 us (24)
;	for (b=0x60; b; b++)	// loop for about 50us
		LDI r1,0x60
		BRNE _get1284id__1b3 ;(+07)
;		{
;		if (!PP_CTL.ack_n)
_get1284id__1ac:
		LDA r0,_PP_CTL
		BTT 4
		BREQ _get1284id__1b6 ;(+04)
		INC r1
_get1284id__1b3:
		TX0 r1
		BRNE _get1284id__1ac ;(-0a)
;			break;
;		}
;	spew("23");
;// 24) AUTOFD_N=0  - acknowledge the exit (25)
;	PP_CTL.autofeed_n = 0;
_get1284id__1b6:
		LDA r0,_PP_CTL
		LDI r1,0xbf
		AND r1
		STA r0,_PP_CTL
;	spew("24");
;// 25) Wait for ACK_N=1	- acknowledge (27)
;	for (b=0x60; b; b++)	// loop for about 50us
		LDI r1,0x60
		BRNE _get1284id__1ca ;(+07)
;		{
;		if (PP_CTL.ack_n)
_get1284id__1c3:
		LDA r0,_PP_CTL
		BTT 4
		BRNE _get1284id__1cd ;(+04)
		INC r1
_get1284id__1ca:
		TX0 r1
		BRNE _get1284id__1c3 ;(-0a)
;			break;
;		}
;	spew("25");
;// 26) AUTOFD_N=1 - exit complete (28)
;	PP_CTL.autofeed_n = 1;
_get1284id__1cd:
		LDA r0,_PP_CTL
		LDI r1,0x40
		OR  r1
		STA r0,_PP_CTL
;	spew("get1284id-done");
;// 1284 port is now ready for normal operation again.
;#endif // WANT_HARDWARE
;
;	return;
		RTS
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\TIMER.C
;// timer.c
;#include <intrpt.h>
;
;#include "vauto.h"
;#include "timer.h"
;#include "uart.h"
;
;#define DEBUG_IT		0
;
;#if !defined(CLOCK_RATE)
;#define CLOCK_RATE		12	// !!! IF YOU'RE NOT RUNNING AT 12MHZ CHANGE THIS !!!
;#endif
;
;typedef struct
;	{
;	BYTE	run:1,
;			ext:1,
;			spare:1,
;			mxb:1,
;			ret:1,
;			pwm:1,
;			enable:1,
;			done:1;
;	} TIMER_CTL_REG;
;
;volatile BYTE			TIMER_COUNT_LO		@0x0260;
;volatile BYTE			TIMER_COUNT_HI		@0x0261;
;volatile TIMER_CTL_REG	TIMER_CTL			@0x0262;
;volatile BYTE			TIMER_PRESCALE		@0x0263;
;volatile BYTE			TIMER_MAXAL			@0x0264;
;volatile BYTE			TIMER_MAXAH			@0x0265;
;volatile BYTE			TIMER_MAXBL			@0x0266;
;volatile BYTE			TIMER_MAXBH			@0x0267;
;
;void interrupt InterruptTimer(void);
;
;
;void TimerDisable()
;{
;
;	TIMER_CTL.run = 0;
_TimerDisable:
		LDA r0,_TIMER_CTL
		LDI r1,0xfe
		BRNE _TimerWaitAMicroSecond__48 ;(+48)
;	return;
;}
;
;volatile BOOL	bTimesUp;
;
;void TimerWaitAMicroSecond(WORD wMicroSecond)
;{
;	ONION	oMicroSecond;
;
;#if DEBUG_IT
;puts("Timer waiting ");
;putw(wMicroSecond);
;putCrlf();
;putFlush();
;#endif
;
;	oMicroSecond.w = wMicroSecond;
_TimerWaitAMicroSecond:
		STA r4,Aa_UsbVendSetEndPoint
		STA r5,Aa_UsbVendSetEndPoint+0x1
;	bTimesUp = FALSE;
		XOR r0
		STA r0,_bTimesUp
;	Interrupt3 = (WORD)InterruptTimer;
		LDI r0,0x1e
		STA r0,_Interrupt3+0x1
		LDI r0,0xbd
		STA r0,_Interrupt3
;	*(PBYTE)&TIMER_CTL = 0;		// clear everything
		XOR r0
		STA r0,_TIMER_CTL
;	TIMER_PRESCALE = CLOCK_RATE-1;
		LDI r0,0x0b
		STA r0,_TIMER_PRESCALE
;
;	TIMER_MAXAL = oMicroSecond.b.l;
		STA r4,_TIMER_MAXAL
;	TIMER_MAXAH = oMicroSecond.b.h;
		STA r5,_TIMER_MAXAH
;	TIMER_CTL.done = 1;		// clear done bit
		LDA r0,_TIMER_CTL
		LDI r1,0x80
		OR  r1
		STA r0,_TIMER_CTL
;	TIMER_CTL.enable = 1;	// enable timer
		LDA r0,_TIMER_CTL
		LDI r1,0x40
		OR  r1
		STA r0,_TIMER_CTL
;	TIMER_CTL.run = 1;		// go do it
		LDA r0,_TIMER_CTL
		LDI r1,0x01
		OR  r1
		STA r0,_TIMER_CTL
;
;	while (!TIMER_CTL.done)
_TimerWaitAMicroSecond__3e:
		LDA r0,_TIMER_CTL
		BRPL _TimerWaitAMicroSecond__3e ;(-05)
;		{
;		}
;
;	TIMER_CTL.enable = 0;	// disable
		LDA r0,_TIMER_CTL
		LDI r1,0xbf
_TimerWaitAMicroSecond__48:
		AND r1
		STA r0,_TIMER_CTL
;
;#if DEBUG_IT
;puts("Timer done\r\n");
;putFlush();
;#endif
;
;	return;
		RTS
;}
;
;#pragma interrupt_level 1
;void interrupt InterruptTimer()
;{
_InterruptTimer:
		PSH r0
		PSH r1
;
;	TIMER_CTL.enable = 0;	// disable
		LDA r0,_TIMER_CTL
		LDI r1,0xbf
		AND r1
		STA r0,_TIMER_CTL
;	bTimesUp = TRUE;
		LDI r0,0x01
		STA r0,_bTimesUp
;}
		POP r1
		POP r0
		RTI
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\UART.C
;#include "vauto.h"
;#include "uart.h"
;
;volatile BYTE UART_BASE_0		@0x240;
;volatile UART_STATUS uartStatus	@0x241;
;volatile BYTE UART_BASE_2		@0x242;
;volatile BYTE UART_BASE_3		@0x243;
;
;
;// the following hard-coded locations MUST be editted
;// if your memory map is not the vautomation default
;
;
;volatile WORD LastHexWord = 0x0410;	// the most recent word read, used for future defaults
;BYTE linebuf[32] = {0xee};
;
;void PutOnion(void);
;void PutOnionSpace(void);
;
;
;BYTE UartReadHex()	// read two hex chars and create a byte from them
;{
;	static BYTE	c1, c2;
;
;	c1 = Ascii2Hex(UartReadChar());
_UartReadHex:
		JSR _UartReadChar
		PSH r0
		POP r4
		JSR _Ascii2Hex
		STA r0,_bTimesUp+0x1
;	c1 <<= 4;
		ADD r0
		ADD r0
		ADD r0
		ADD r0
		STA r0,_bTimesUp+0x1
;	c2 = Ascii2Hex(UartReadChar());
		JSR _UartReadChar
		PSH r0
		POP r4
		JSR _Ascii2Hex
		STA r0,_bTimesUp+0x2
;
;	return c1 | c2;
		T0X r1
		LDA r0,_bTimesUp+0x1
		OR  r1
		RTS
;}
;
;WORD UartReadHexWord()	// read up to four hex chars and create a word from them
;{
;	static BYTE	c, c2;
;
;	c = UartReadString(linebuf, 32);
_UartReadHexWord:
		LDI r2,0x20
		LDI r4,0x0e ;_linebuf
		LDI r5,0x48 ;_linebuf>>8
		JSR _UartReadString
		STA r0,_bTimesUp+0x3
;	if (!c)					// only a CR was entered
		LDA r0,_bTimesUp+0x3
		BREQ _UartReadHexWord__8c ;(+7b)
;		return LastHexWord;	// use last value
;
;	LastHexWord = 0;
		XOR r0
		STA r0,_LastHexWord+0x1
		STA r0,_LastHexWord
;
;	for (c2=0; c2<c; c2++)
		STA r0,_bTimesUp+0x4
		LDA r1,_bTimesUp+0x3
		LDA r0,_bTimesUp+0x4
		CMP r1
		BRCS _UartReadHexWord__8c ;(+68)
;		{
;		if (!IsHex(linebuf[c2]))	// end of hex chars
_UartReadHexWord__24:
		LDI r2,0x0e ;_linebuf
		LDI r3,0x48 ;_linebuf>>8
		LDA r0,_bTimesUp+0x4
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		T0X r4
		JSR _IsHex
		T0X r1
		BREQ _UartReadHexWord__8c ;(+52)
;			break;					// return what we've got
;
;		LastHexWord <<= 4;
		LDI r1,0x03
_UartReadHexWord__3c:
		LDA r0,_LastHexWord
		ADD r0
		STA r0,_LastHexWord
		LDA r0,_LastHexWord+0x1
		ROL r0
		STA r0,_LastHexWord+0x1
		DEC r1
		BRCS _UartReadHexWord__3c ;(-11)
;		LastHexWord += Ascii2Hex(linebuf[c2]);
		LDI r2,0x0e ;_linebuf
		LDI r3,0x48 ;_linebuf>>8
		LDA r0,_bTimesUp+0x4
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		T0X r4
		JSR _Ascii2Hex
		LDI r1,0x00
		STA r0,Aa_UsbVendSetEndPoint
		STA r1,Aa_UsbVendSetEndPoint+0x1
		LDA r0,_LastHexWord
		LDA r1,Aa_UsbVendSetEndPoint
		ADD r1
		STA r0,_LastHexWord
		LDA r0,_LastHexWord+0x1
		LDA r1,Aa_UsbVendSetEndPoint+0x1
		ADC r1
		STA r0,_LastHexWord+0x1
		LDA r0,_bTimesUp+0x4
		INC r0
		STA r0,_bTimesUp+0x4
		LDA r1,_bTimesUp+0x3
		LDA r0,_bTimesUp+0x4
		CMP r1
		BRCC _UartReadHexWord__24 ;(-68)
;		}
;
;	return LastHexWord;
_UartReadHexWord__8c:
		LDA r0,_LastHexWord
		LDA r1,_LastHexWord+0x1
		RTS
;}
;
;BYTE IsHex(BYTE c)
;{
;
;	if (c < '0')
_IsHex:
		LDI r1,0x30
		TX0 r4
		CMP r1
		BRCS _IsHex__8 ;(+02)
;		return 0;	// less than '0' so not hex
		XOR r0
		RTS
;	if (c <= '9')
_IsHex__8:
		LDI r1,0x3a
		TX0 r4
		CMP r1
		BRCS _IsHex__11 ;(+03)
;		return 1;	// less than or equal '9' so hex
		LDI r0,0x01
		RTS
;	c |= 0x20;		// tolower
_IsHex__11:
		LDI r1,0x20
		TX0 r4
		OR  r1
		T0X r4
;	if (c < 'a')	// less than 'a' so not hex
		LDI r1,0x61
		TX0 r4
		CMP r1
		BRCS _IsHex__1e ;(+02)
;		return 0;
		XOR r0
		RTS
;	if (c <= 'f')	// less than or equal 'f' so hex
_IsHex__1e:
		LDI r1,0x67
		TX0 r4
		CMP r1
		BRCS _IsHex__27 ;(+03)
;		return 1;
		LDI r0,0x01
		RTS
;	return 0;		// greated than 'f' so not hex
_IsHex__27:
		XOR r0
		RTS
;}
;
;BYTE Ascii2Hex(BYTE c)	// convert 0-9 or a-f in acsii to hex
;{
;
;	c &= 0x5f;				// to lower
_Ascii2Hex:
		LDI r1,0x5f
		TX0 r4
		AND r1
		T0X r4
;	if (c < 0x40)			// if 0-9
		LDI r1,0x40
		TX0 r4
		CMP r1
		BRCS _Ascii2Hex__10 ;(+05)
;		return c & 0x0f;	// mask off all but low 4 bits
		LDI r1,0x0f
		TX0 r4
		AND r1
		RTS
;	return c - 0x37;		// a-f, subtract 'a' and add 10
_Ascii2Hex__10:
		LDI r1,0xc9
		TX0 r4
		ADD r1
		RTS
;}
;
;BYTE UartReadString(PBYTE p, BYTE len)	// read chars and build string until len
;{										// or \r reached.  Not null terminated.
;	static BYTE	l;
;	static BYTE	c;
;
;	l = 0;
_UartReadString:
		STA r2,Aa_UartReadString
		STA r4,Aa_UartReadString+0x1
		STA r5,Aa_HostSetNextInBdt
		XOR r0
_UartReadString__a:
		STA r0,_bTimesUp+0x5
;	for (;;)
;		{
;		c = UartReadChar();
_UartReadString__d:
		JSR _UartReadChar
		STA r0,_bTimesUp+0x6
;		putc(c);
		T0X r4
		JSR _putc
;		if (c == '\r')
		LDI r1,0x0d
		LDA r0,_bTimesUp+0x6
		XOR r1
		BRNE _UartReadString__23 ;(+04)
;			return l;
		LDA r0,_bTimesUp+0x5
		RTS
;		if (c == '\b' || c == 0x7f)	// if backspace or delete
_UartReadString__23:
		LDI r1,0x08
		LDA r0,_bTimesUp+0x6
		XOR r1
		BREQ _UartReadString__33 ;(+08)
		LDI r1,0x7f
		LDA r0,_bTimesUp+0x6
		XOR r1
		BRNE _UartReadString__3f ;(+0c)
;			{
;			if (l)					// if char has been typed
_UartReadString__33:
		LDA r0,_bTimesUp+0x5
		BREQ _UartReadString__d ;(-2b)
;				l--;				// delete most recent
		LDA r0,_bTimesUp+0x5
		DEC r0
		JMP _UartReadString__a
;			continue;
;			}
;		p[l++] = c;					// add char to buffer
_UartReadString__3f:
		LDA r2,Aa_UartReadString+0x1
		LDA r3,Aa_HostSetNextInBdt
		LDA r0,_bTimesUp+0x5
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDA r0,_bTimesUp+0x6
		STX r2
		LDA r0,_bTimesUp+0x5
		INC r0
		STA r0,_bTimesUp+0x5
;		if (l == len)
		LDA r1,Aa_UartReadString
		LDA r0,_bTimesUp+0x5
		CMP r1
		BRNE _UartReadString__d ;(-56)
;			return l;				// we've reached length limit
		RTS
;		}
;}
;
;#if 0
;#if WANT_HARDWARE && !WANT_LITE
;void putl(unsigned long l)	// output a 32 bit value in base 10
;{
;	static char	buff[12];
;	static BYTE	i;
;	static long l2, r;
;
;	l2 = l;
;	for (i=0; !i || (i<12 && l2); i++)	// generate chars in reverse order
;		{
;		r = l % 10;		// remainder
;		l2 = l / 10;	// quotient
;		buff[i] = '0' + (char)r;
;		l = l2;
;		}
;
;	while (i)	// now reverse the reverse order
;		putc(buff[--i]);
;
;	return;
;}
;#endif // WANT_HARDWARE && !WANT_LITE
;#endif
;
;PBYTE PutString_string;
;
;void puts(PBYTE pb)		// output each char in a string until a null is reached
;{
;// This code is not re-entrant.  If an interrupt fires while we're in this routine
;// pb will get hosed.
;
;//	disableInterrupts();
;	PutString_string = pb;
_puts:
		STA r4,_PutString_string
		STA r5,_PutString_string+0x1
		STA r4,A_ReallySendToken
		STA r5,Aa_ReallySendToken
;	while (*PutString_string)
		JMP _puts__24
;		{
;		putc(*PutString_string++);
_puts__f:
		LDA r0,_PutString_string+0x1
		T0X r3
		T0X r1
		LDA r0,_PutString_string
		T0X r2
		UPP r0
		STA r0,_PutString_string
		STA r1,_PutString_string+0x1
		LDX r2
		T0X r4
		JSR _putc
_puts__24:
		LDA r2,_PutString_string
		LDA r3,_PutString_string+0x1
		LDX r2
		BRNE _puts__f ;(-1e)
;		}
;	if (*pb == '~')
		LDI r1,0x7e
		LDA r2,A_ReallySendToken
		LDA r3,Aa_ReallySendToken
		LDX r2
		CMP r1
		BRNE _puts__3e ;(+05)
;		putc('~');
		LDI r4,0x7e
		JMP _putc
;//	enableInterrupts();
;}
_puts__3e:
		RTS
;
;void putSpace()		// output a space
;{
;	putc(' ');
_putSpace:
		LDI r4,0x20
		JMP _putc
;	return;
;}
;void putCrlf()		// output a CR and LF
;{
;	putc('\r');
_putCrlf:
		LDI r4,0x0d
		JSR _putc
;	putc('\n');
		LDI r4,0x0a
		JMP _putc
;	return;
;}
;
;BYTE PutByte_byte;
;BYTE PutByte_nibble;
;
;void putb(register const BYTE b)	// output a byte in hex
;{
;	PutByte_byte=b;
_putb:
		STA r4,_PutByte_byte
;	PutByte_nibble = PutByte_byte>>4;
		TX0 r4
		CLP C
		ROR r0
		CLP C
		ROR r0
		CLP C
		ROR r0
		CLP C
		ROR r0
		STA r0,_PutByte_nibble
;	putc(Hex2Ascii(PutByte_nibble));
		LDI r1,0x0a
		LDA r0,_PutByte_nibble
		CMP r1
		BRCC _putb__1d ;(+06)
		LDI r1,0x00
		LDI r4,0x37
		BRNE _putb__24 ;(+07)
_putb__1d:
		LDA r0,_PutByte_nibble
		LDI r1,0x00
		LDI r4,0x30
_putb__24:
		ADD r4
		BRCC _putb__28 ;(+01)
		INC r1
_putb__28:
		T0X r4
		JSR _putc
;	PutByte_nibble = PutByte_byte & 0x0f;
		LDI r1,0x0f
		LDA r0,_PutByte_byte
		AND r1
		STA r0,_PutByte_nibble
;	putc(Hex2Ascii(PutByte_nibble));
		LDI r1,0x0a
		LDA r0,_PutByte_nibble
		CMP r1
		BRCC _putb__43 ;(+06)
		LDI r1,0x00
		LDI r4,0x37
		BRNE _putb__4a ;(+07)
_putb__43:
		LDA r0,_PutByte_nibble
		LDI r1,0x00
		LDI r4,0x30
_putb__4a:
		ADD r4
		BRCC _putb__4e ;(+01)
		INC r1
_putb__4e:
		T0X r4
		JMP _putc
;}
;
;void putbs(register const BYTE b)	// output a byte in hex followed by a space
;{
_putbs:
		STA r4,Aa_HostSetNextInBdt
;	putb(b);
		LDA r4,Aa_HostSetNextInBdt
		JSR _putb
;	putSpace();
		JMP _putSpace
;}
;
;ONION PutOnion_onion;
;
;void putw(register const WORD w)	// output a word in hex
;{
_putw:
		JMP _puto
;	PutOnion_onion.w = w;
;	PutOnion();
;}
;
;void putws(register const WORD w)	// output a word in hex followed by a space
;{
_putws:
		JMP _putos
;	PutOnion_onion.w = w;
;	PutOnion();
;	putSpace();
;}
;
;void puto(register const ONION o)	// output an onion in hex
;{
;	PutOnion_onion = o;
_puto:
		STA r4,_PutOnion_onion
		STA r5,_PutOnion_onion+0x1
;	PutOnion();
		JMP _PutOnion
;}
;
;void putos(register const ONION o)	// output an onion in hex followed by a space
;{
;	PutOnion_onion = o;
_putos:
		STA r4,_PutOnion_onion
		STA r5,_PutOnion_onion+0x1
;	PutOnion();
		JSR _PutOnion
;	putSpace();
		JMP _putSpace
;}
;
;void PutOnion()
;{
;	putb(PutOnion_onion.b.h);
_PutOnion:
		LDA r4,_PutOnion_onion+0x1
		JSR _putb
;	putb(PutOnion_onion.b.l);
		LDA r4,_PutOnion_onion
		JMP _putb
;	return;
;}
;
;BYTE UartGetAndEchoChar()
;{
;	static BYTE	c;
;
;#if !WANT_HARDWARE
;	c = 0;
;#endif
;
;	do	{
;		putFlushOneIfReady();
_UartGetAndEchoChar:
		JSR _putFlushOneIfReady
;		} while (!UartCharWaiting());
		JSR _UartCharWaiting
		T0X r1
		BREQ _UartGetAndEchoChar ;(-09)
;
;	c = UartReadChar();
		JSR _UartReadChar
		STA r0,_bTimesUp+0x7
;	putc(c);
		T0X r4
		JSR _putc
;	return c;
		LDA r0,_bTimesUp+0x7
		RTS
;}
;
;void putUnknown(BYTE b)
;{
;
;	putb(b);
_putUnknown:
		STA r4,Aa_UsbVendSetEndPoint
		LDA r4,Aa_UsbVendSetEndPoint
		JSR _putb
;	puts(" = Unknown Command\r\n");
		LDI r4,0xd4 ;__Lstrings+0x54b
		LDI r5,0x40 ;__Lstrings+0x54b>>8
		JMP _puts
;	return;
;}
;
;static BYTE	uart_pch, uart_pcl;
;
;void putReturnAddress()
;{
;
;#asm
;	pop r0
_putReturnAddress:
		POP r0
;	pop r1
		POP r1
;	pop r2
		POP r2
;	pop r3
		POP r3
;	psh r3
		PSH r3
;	psh r2
		PSH r2
;	psh r1
		PSH r1
;	psh r0
		PSH r0
;	sta r0,_uart_pcl
		STA r0,_PutByte_nibble+0x2
;	sta r1,_uart_pch
		STA r1,_PutByte_nibble+0x1
;#endasm
;	putb(uart_pch);
		LDA r4,_PutByte_nibble+0x1
		JSR _putb
;	putb(uart_pcl);
		LDA r4,_PutByte_nibble+0x2
		JMP _putb
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\UARTDULL.C
;#include "vauto.h"
;#include "uart.h"
;
;#define UART_MIN 0x60	// locations 6000 - 6fff are used as an output buffer
;#define UART_MAX 0x6f
;
;
;volatile ONION UART_NEXT;		// where to put next outgoing char
;volatile ONION UART_CURRENT;	// where go get oldest outgoing char which hasn't been sent
;
;volatile BYTE UART_SOMETHING_TO_DO;	// TRUE if NEXT != CURRENT
;
;#define INIT_CURRENT	(UART_CURRENT.b.h = UART_MIN, UART_CURRENT.b.l = 0)
;#define INIT_NEXT		(UART_NEXT.b.h = UART_MIN, UART_NEXT.b.l = 0)
;
;void actuallyWriteCharToUart(void);
;
;
;void UartInit(BYTE speed)
;{
;#if WANT_HARDWARE
;	UART_BASE_2 = 0x19;		// 115.2k baud
_UartInit:
		LDI r0,0x19
		STA r0,_UART_BASE_2
;#else
;	UART_BASE_2 = 1;		// use maximum divisor for simulations
;#endif
;
;	UART_BASE_3 = 0x00;
		XOR r0
		STA r0,_UART_BASE_3
;
;	*(PBYTE)&uartStatus = 0x00;
		STA r0,_uartStatus
;
;	UartBufferInit();
		JSR _UartBufferInit
;	UART_BASE_0 = 'U';	// 01010101 - let's the uart get synch'd
		LDI r0,0x55
		STA r0,_UART_BASE_0
;
;	puts("Up\r\n");
		LDI r4,0xe9 ;__Lstrings+0x560
		LDI r5,0x40 ;__Lstrings+0x560>>8
		JMP _puts
;
;	return;
;}
;
;
;void UartBufferInit()
;{
;
;//	if ((UART_CURRENT.b.h < UART_MIN) || (UART_CURRENT.b.h > UART_MAX) || !UART_SOMETHING_TO_DO)
;		{
;#if 0
;		INIT_CURRENT;
;
;		while (UART_CURRENT.b.h <= UART_MAX)	// initialize entire buffer
;			{
;			*UART_CURRENT.pb++ = 0xcc;
;			}
;#endif
;		INIT_CURRENT;
_UartBufferInit:
		LDI r0,0x60
		STA r0,_UART_CURRENT+0x1
		XOR r0
		STA r0,_UART_CURRENT
;		INIT_NEXT;
		LDI r0,0x60
		STA r0,_UART_NEXT+0x1
		XOR r0
		STA r0,_UART_NEXT
;		UART_SOMETHING_TO_DO = FALSE;
		STA r0,_UART_SOMETHING_TO_DO
;		}
;	return;
		RTS
;}
;
;BYTE UartReadChar()		// read a char, wait for it if necessary
;{
_UartReadChar:
		JMP _UartReadChar__6
;	while (!UartCharWaiting())	// until there's an incoming char
;		putFlushOneIfReady();	// flush another outgoing char
_UartReadChar__3:
		JSR _putFlushOneIfReady
_UartReadChar__6:
		JSR _UartCharWaiting
		T0X r1
		BREQ _UartReadChar__3 ;(-09)
;
;	return UART_BASE_0;
		LDA r0,_UART_BASE_0
		RTS
;}
;
;
;
;BYTE UartCharWaiting()	// return non-zero if an incoming char is waiting to be read
;{
;#if 1
;	static WORD w=0;
;	w++;
_UartCharWaiting:
		LDA r0,_UART_SOMETHING_TO_DO+0x1
		LDA r1,_UART_SOMETHING_TO_DO+0x2
		UPP r0
		STA r0,_UART_SOMETHING_TO_DO+0x1
		STA r1,_UART_SOMETHING_TO_DO+0x2
;	if (w & 0x8000)
		TX0 r1
		BTT 7
		BREQ _UartCharWaiting__15 ;(+04)
;		asm("stp 7");
		STP 7
		JMP _UartCharWaiting__16
;	else
;		asm("clp 7");
_UartCharWaiting__15:
		CLP 7
;#endif
;	return uartStatus.rxFull;
_UartCharWaiting__16:
		LDA r0,_uartStatus
		ROR r0
		ROR r0
		ROR r0
		LDI r4,0x01
		AND r4
		RTS
;}
;
;
;void putc(register const BYTE b)	// output an ascii char
;{
;
;#if WANT_SIMULATOR
;	*(PBYTE)0x300 = b;		// simulating, just write byte to loc 300 for ease of monitoring
;	return;
;#else
;	// b is in r4
;
;asm("br1 3,already_in_int1");
_putc:
		BR1 I,_putc__32 ;(+30)
;asm("psh r4");	// save b (r4)
		PSH r4
;asm("stp 3");	// set I bit
		STP I
;asm("pop r4");	// restore b
		POP r4
;
;	*UART_NEXT.pb++ = b;
		TX0 r4
		LDA r2,_UART_NEXT
		LDA r3,_UART_NEXT+0x1
		STX r2
		LDA r0,_UART_NEXT
		LDA r1,_UART_NEXT+0x1
		UPP r0
		STA r0,_UART_NEXT
		STA r1,_UART_NEXT+0x1
;	if (UART_NEXT.b.h > UART_MAX)
		LDI r1,0x70
		LDA r0,_UART_NEXT+0x1
		CMP r1
		BRCC _putc__2b ;(+09)
;		INIT_NEXT;
		LDI r0,0x60
		STA r0,_UART_NEXT+0x1
		XOR r0
		STA r0,_UART_NEXT
;	UART_SOMETHING_TO_DO = TRUE;
_putc__2b:
		LDI r0,0x01
		STA r0,_UART_SOMETHING_TO_DO
;
;asm("clp 3");	// clear I bit
		CLP I
;asm("rts");
		RTS
;
;asm("already_in_int1:");
;
;	*UART_NEXT.pb++ = b;
_putc__32:
		TX0 r4
		LDA r2,_UART_NEXT
		LDA r3,_UART_NEXT+0x1
		STX r2
		LDA r0,_UART_NEXT
		LDA r1,_UART_NEXT+0x1
		UPP r0
		STA r0,_UART_NEXT
		STA r1,_UART_NEXT+0x1
;	if (UART_NEXT.b.h > UART_MAX)
		LDI r1,0x70
		LDA r0,_UART_NEXT+0x1
		CMP r1
		BRCC _putc__58 ;(+09)
;		INIT_NEXT;
		LDI r0,0x60
		STA r0,_UART_NEXT+0x1
		XOR r0
		STA r0,_UART_NEXT
;	UART_SOMETHING_TO_DO = TRUE;
_putc__58:
		LDI r0,0x01
		STA r0,_UART_SOMETHING_TO_DO
;	return;
		RTS
;#endif
;}
;
;void putFlush()		// flush all chars waiting to be sent
;{
;
;#if !WANT_SIMULATOR
;	if (UART_SOMETHING_TO_DO)
_putFlush:
		LDA r0,_UART_SOMETHING_TO_DO
		BREQ _putFlush__2f ;(+2a)
		JMP _putFlush__1a
;		{
;		while (UART_CURRENT.w != UART_NEXT.w)
;			if (uartStatus.txEmpty)
_putFlush__8:
		LDA r0,_uartStatus
		BRPL _putFlush__1a ;(+0d)
;				{
;asm("br1 3,already_in_int2");
		BR1 I,_putFlush__17 ;(+08)
;asm("stp 3");	// set I bit
		STP I
;				actuallyWriteCharToUart();
		JSR _actuallyWriteCharToUart
;asm("clp 3");	// clear I bit
		CLP I
;asm("jmp not_in_int2");
		JMP _putFlush__1a
;
;asm("already_in_int2:");
;				actuallyWriteCharToUart();
_putFlush__17:
		JSR _actuallyWriteCharToUart
_putFlush__1a:
		LDA r0,_UART_CURRENT
		LDA r1,_UART_CURRENT+0x1
		LDA r2,_UART_NEXT
		XOR r2
		BRNE _putFlush__8 ;(-1e)
		LDA r0,_UART_NEXT+0x1
		XOR r1
		BRNE _putFlush__8 ;(-24)
;asm("not_in_int2:");
;				}
;		UART_SOMETHING_TO_DO = FALSE;
		STA r0,_UART_SOMETHING_TO_DO
;		}
;#endif // !WANT_SIMULATOR
;
;	return;
_putFlush__2f:
		RTS
;}
;void putFlushOneIfReady()	// flush next char waiting to be sent
;{
;#if !WANT_SIMULATOR
;	if (UART_SOMETHING_TO_DO)
_putFlushOneIfReady:
		LDA r0,_UART_SOMETHING_TO_DO
		BREQ _putFlushOneIfReady__5d ;(+58)
;		if (UART_CURRENT.w != UART_NEXT.w)
		LDA r0,_UART_CURRENT
		LDA r1,_UART_CURRENT+0x1
		LDA r2,_UART_NEXT
		XOR r2
		BRNE _putFlushOneIfReady__17 ;(+06)
		LDA r0,_UART_NEXT+0x1
		XOR r1
		BREQ _putFlushOneIfReady__5d ;(+46)
;			if (uartStatus.txEmpty)
_putFlushOneIfReady__17:
		LDA r0,_uartStatus
		BRPL _putFlushOneIfReady__5d ;(+41)
;				{
;asm("br1 3,already_in_int3");
		BR1 I,_putFlushOneIfReady__40 ;(+22)
;asm("stp 3");	// set I bit
		STP I
;				actuallyWriteCharToUart();
		JSR _actuallyWriteCharToUart
;				UART_SOMETHING_TO_DO = (UART_CURRENT.w != UART_NEXT.w);
		LDA r0,_UART_CURRENT
		LDA r1,_UART_CURRENT+0x1
		LDA r2,_UART_NEXT
		XOR r2
		BRNE _putFlushOneIfReady__34 ;(+06)
		LDA r0,_UART_NEXT+0x1
		XOR r1
		BREQ _putFlushOneIfReady__38 ;(+04)
_putFlushOneIfReady__34:
		LDI r0,0x01
		BRNE _putFlushOneIfReady__39 ;(+01)
_putFlushOneIfReady__38:
		XOR r0
_putFlushOneIfReady__39:
		STA r0,_UART_SOMETHING_TO_DO
;asm("clp 3");	// clear I bit
		CLP I
;asm("jmp not_in_int3");
		JMP _putFlushOneIfReady__5d
;
;asm("already_in_int3:");
;				actuallyWriteCharToUart();
_putFlushOneIfReady__40:
		JSR _actuallyWriteCharToUart
;				UART_SOMETHING_TO_DO = (UART_CURRENT.w != UART_NEXT.w);
		LDA r0,_UART_CURRENT
		LDA r1,_UART_CURRENT+0x1
		LDA r2,_UART_NEXT
		XOR r2
		BRNE _putFlushOneIfReady__55 ;(+06)
		LDA r0,_UART_NEXT+0x1
		XOR r1
		BREQ _putFlushOneIfReady__59 ;(+04)
_putFlushOneIfReady__55:
		LDI r0,0x01
		BRNE _putFlushOneIfReady__5a ;(+01)
_putFlushOneIfReady__59:
		XOR r0
_putFlushOneIfReady__5a:
		STA r0,_UART_SOMETHING_TO_DO
;asm("not_in_int3:");
;
;				}
;
;	UART_SOMETHING_TO_DO = UART_SOMETHING_TO_DO;
_putFlushOneIfReady__5d:
		LDA r0,_UART_SOMETHING_TO_DO
		STA r0,_UART_SOMETHING_TO_DO
;#endif // !WANT_SIMULATOR
;
;	return;
		RTS
;}
;
;void actuallyWriteCharToUart()
;{
;	BYTE	b;
;
;	b = *UART_CURRENT.pb++;
_actuallyWriteCharToUart:
		LDA r2,_UART_CURRENT
		LDA r3,_UART_CURRENT+0x1
		LDX r2
		T0X r4
		LDA r0,_UART_CURRENT
		LDA r1,_UART_CURRENT+0x1
		UPP r0
		STA r0,_UART_CURRENT
		STA r1,_UART_CURRENT+0x1
;	if ((b & 0x80) == 0)
		TX0 r4
		BRMI _actuallyWriteCharToUart__1b ;(+03)
;		UART_BASE_0 = b;
		STA r4,_UART_BASE_0
;
;	if (UART_CURRENT.b.h > UART_MAX)	// wrap current if it exceeded max
_actuallyWriteCharToUart__1b:
		LDI r1,0x70
		LDA r0,_UART_CURRENT+0x1
		CMP r1
		BRCC _actuallyWriteCharToUart__2c ;(+09)
;		INIT_CURRENT;
		LDI r0,0x60
		STA r0,_UART_CURRENT+0x1
		XOR r0
		STA r0,_UART_CURRENT
;
;	return;
_actuallyWriteCharToUart__2c:
		RTS
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\USB_DRV.C
;// usb_drv.c
;//
;// rev 1 5/26/98 russell
;
;#define USB_DRV_C	1
;
;#include "vauto.h"
;#include "ad1848.h"
;#if WANT_PRINTER
;#include "printer.h"
;#endif
;#include "host.h"
;#include "uart.h"
;#include "usb_drv.h"
;#include "usb_glob.h"
;#if WANT_HUB
;#include "hub.h"
;#endif
;
;//#if WANT_HUB
;//#if WANT_SOUND | WANT_PRINTER
;//	"Error: mutex";	// can't have hub with sound or printer
;//#endif
;//#endif
;
;#if WANT_HUB
;
;#if WANT_HARDWARE && !WANT_LITE
;#define DEBUG_EXTRA_NULL	0
;#define DEBUG_SOF_MISSES	0
;#define DEBUG_GETDESC	0
;#define DEBUG_GETDESC2	0
;#define DEBUG_EP0		0
;#define DEBUG_REGS		0
;#define DEBUG_REGS_VERBOSE	0
;#define DEBUG_SEND_IN	0
;#define DEBUG_SEND_IN2	0
;#define DEBUG_STATE		0
;#define DEBUG_CONFIG	0
;#define DEBUG_STACK		0	// save return address on entry and validate it on rti
;#define DEBUG_PORT_STATE	0
;#define DEBUG_PULSE		0
;#define DEBUG_TRUNCATE	0
;#define DEBUG_DEQUEUE	0
;#define DEBUG_STALL		0
;#define DEBUG_PBDT		0
;#define DEBUG_CLASS_SETUP	0
;#define DEBUG_SLEEP		0
;#define DEBUG_USB_STATUS_DEVICE 0
;#else // !WANT_HARDWARE
;#define DEBUG_EXTRA_NULL	0
;#define DEBUG_SOF_MISSES	0
;#define DEBUG_GETDESC	0
;#define DEBUG_GETDESC2	0
;#define DEBUG_EP0		0
;#define DEBUG_REGS		0
;#define DEBUG_REGS_VERBOSE	0
;#define DEBUG_SEND_IN	0
;#define DEBUG_SEND_IN2	0
;#define DEBUG_STATE		0
;#define DEBUG_CONFIG	0
;#define DEBUG_STACK		0	// save return address on entry and validate it on rti
;#define DEBUG_PORT_STATE	0
;#define DEBUG_PULSE		0
;#define DEBUG_TRUNCATE	0
;#define DEBUG_DEQUEUE	0
;#define DEBUG_STALL		0
;#define DEBUG_PBDT		0
;#define DEBUG_CLASS_SETUP	0
;#define DEBUG_SLEEP		0
;#define DEBUG_USB_STATUS_DEVICE 0
;#endif
;
;#else // !WANT_HUB
;
;#define DEBUG_EXTRA_NULL	0
;#define DEBUG_SOF_MISSES	0
;#define DEBUG_GETDESC	0
;#define DEBUG_GETDESC2	0
;#define DEBUG_EP0		0
;#define DEBUG_REGS		0
;#define DEBUG_REGS_VERBOSE	0
;#define DEBUG_SEND_IN	0
;#define DEBUG_SEND_IN2	0
;#define DEBUG_STATE		0
;#define DEBUG_CONFIG	0
;#define DEBUG_STACK		0	// save return address on entry and validate it on rti
;#define DEBUG_PORT_STATE	0
;#define DEBUG_PULSE		0
;#define DEBUG_TRUNCATE	0
;#define DEBUG_DEQUEUE	0
;#define DEBUG_STALL		0
;#define DEBUG_PBDT		0
;#define DEBUG_CLASS_SETUP	0
;#define DEBUG_SLEEP		0
;#define DEBUG_USB_STATUS_DEVICE 0
;#endif // !WANT_HUB
;
;#if DEBUG_REGS
;#if DEBUG_REGS_VERBOSE
;PBYTE	pStatus[8] = {"Stl","Att","Res","Slp","Tok","Sof","Err","Rst"};
;PBYTE	pError[8]  = {"BTS","Own","DMA","BTO","DFN","CRC","EOF","Pid"};
;
;void UsbDumpByte(BYTE bStat, BYTE bEnable, PBYTE *p);
;#endif
;void UsbDrvDumpRegs()
;#include "dumpregs.h"
;#endif
;
;#if WANT_LITE
;#define STALL(lite,full) UsbStall(lite)
;#define PUTS(lite,full) puts(lite)
;#else
;#define STALL(lite,full) UsbStall(full)
;#define PUTS(lite,full) puts(full)
;#endif
;
;
;#define INIT_ONION_WITH_BDT_FOR_EP(o,e) {o.b.h = ((WORD)USB_BDT_PAGE) >> 8; o.b.l = ep << 4;}
;
;
;// Define the states that the USB interface can be in
;#define	POWERED_STATE	0x03
;#define	DEFAULT_STATE	0x02
;#define	ADDRESS_STATE	0x01
;#define	CONFIG_STATE	0x00
;#define	SUSPEND_STATE	0x80	// Bit 7 indicates suspend, [6:4] indicate state
;// Define the states for Control EndPoints
;#define	EP_IDLE_STATE	0x00
;#define	EP_SETUP_STATE	0x01
;#define	EP_DISABLED_STATE	0xff
;// define various variables for USB
;
;#define USB_DEFAULT_BUFFER_SIZE 8	// valid values are 8,16,32,64 per USB spec.
;#define	USB_NUM_IFACES_9 0			// number of interfaces in the configuration
;#define CONFIG_SIZE_9 0x09
;#define USB_DEVICE_CLASS 0			// bDeviceClass	zero means each interface operates independently
;#define USB_PRODUCT 0x02			// string number of product string
;#define USB_SERIAL_NUMBER 0x03		// string number of serial number
;
;
;#if WANT_HUB
;#define USB_NUM_IFACES_8 (USB_NUM_IFACES_9+1)
;#define CONFIG_SIZE_8 (CONFIG_SIZE_9+0x10)
;#undef USB_DEVICE_CLASS
;#define USB_DEVICE_CLASS 9			// bDeviceClass 9=HUB
;#undef USB_PRODUCT
;#define USB_PRODUCT 0x07			// string number of product string
;#undef USB_SERIAL_NUMBER
;#define USB_SERIAL_NUMBER 0x00		// string number of serial number (none, 
;									// a hub with a serial number breaks things)
;#else // !WANT_HUB
;#define USB_NUM_IFACES_8 (USB_NUM_IFACES_9)
;#define CONFIG_SIZE_8 (CONFIG_SIZE_9)
;#endif // WANT_HUB
;
;#if WANT_SOUND
;#undef USB_DEFAULT_BUFFER_SIZE
;#define USB_DEFAULT_BUFFER_SIZE 64	// valid values are 8,16,32,64 per USB spec.
;#define USB_NUM_IFACES_7 (USB_NUM_IFACES_8+2)
;#define CONFIG_SIZE_7 (CONFIG_SIZE_8+0x7d)
;#undef USB_DEVICE_CLASS
;#define USB_DEVICE_CLASS 0			// bDeviceClass	zero means each interface operates independently
;#else // !WANT_SOUND
;#define USB_NUM_IFACES_7 (USB_NUM_IFACES_8)
;#define CONFIG_SIZE_7 (CONFIG_SIZE_8)
;#endif // WANT_SOUND
;
;#if WANT_PRINTER
;#define USB_NUM_IFACES_6 (USB_NUM_IFACES_7+1)
;#define CONFIG_SIZE_6 (CONFIG_SIZE_7+0x17)
;#undef USB_DEVICE_CLASS
;#define USB_DEVICE_CLASS 0			// bDeviceClass	zero means each interface operates independently
;#else // !WANT_PRINTER
;#define USB_NUM_IFACES_6 (USB_NUM_IFACES_7)
;#define CONFIG_SIZE_6 (CONFIG_SIZE_7)
;#endif // WANT_PRINTER
;
;#define USB_NUM_IFACES (USB_NUM_IFACES_6)
;#define CONFIG_SIZE CONFIG_SIZE_6
;
;BYTE USB_BUFFER_SIZE = USB_DEFAULT_BUFFER_SIZE;	// valid values are 8,16,32,64 per USB spec.
;
;
;#if !USB_NUM_IFACES && !WANT_LITE
;Hey, you don't have any interfaces;
;#endif
;
;
;BOOL bExtraRxBDT[ENDPOINTS] = {FALSE};
;
;WORD USB_MAX_PACKET[ENDPOINTS] = 	// max packet size per ep
;	{
;	0 /* inited at runtime*/, 0x30, 1023, 0x40
;#if 0
;	, 
;	1023, 1023, 1023, 1023, 
;	1023, 1023, 1023, 1023, 
;	1023, 1023, 1023, 8
;#endif
;	};
;
;BYTE USB_DEBUG = 1;			// 0=debug messages off, 1=on
;BYTE USB_DUMP;
;BYTE USB_STATE;			// Current USB state (POWERED,DEFAULT,ADDRESS,CONFIG,SUSPEND)
;BYTE USB_CURR_CONFIG;	// Current USB configuration selected
;BYTE SEND_DATA01[ENDPOINTS];	// stores the Data1/0 PID for each endpoint
;BYTE RECV_DATA01[ENDPOINTS];	// stores the Data1/0 PID for each endpoint
;
;typedef union
;	{
;	WORD	w;
;	BYTE	b[2];
;	struct
;		{
;		WORD	pid:1,		// from VUSB ERR_STAT Reg
;				crc5:1,		// from VUSB ERR_STAT Reg
;				crc16:1,	// from VUSB ERR_STAT Reg
;				dfn8:1,		// from VUSB ERR_STAT Reg
;				bto:1,		// from VUSB ERR_STAT Reg
;				dma:1,		// from VUSB ERR_STAT Reg
;				own:1,		// from VUSB ERR_STAT Reg
;				bitstuff:1,	// from VUSB ERR_STAT Reg
;				sleep:1,	// Set when USB idle for more than 3ms
;				reset:1,	// Set when USB Reset condition detected. Note that 
;							// this value cannot be "reset" by the USB reset.
;				non0st:1,	// Set if a non zero length data packet is received 
;							// during the status phase of a setup transaction.
;				stall:1,
;				spare:4;
;		} bits;
;	} USB_ERROR;			// Writing a 0 to this register has no effect, 
;							// writting a 1 to any bit will cause that bit in 
;							// the register to be cleared to 0.
;
;USB_ERROR USB_ERROR_STAT;	// error status
;
;
;WORD AUDIO_BC;			// 16 bit counter of the number of bytes sent down
;BYTE USB_BYTES;
;BYTE USB_BREAK_OWNS;	// 1 if non-EP0's should not set owns bit
;BYTE USB_ENDPOINT_CONTROL;	// value returned from GetEndpoint
;
;	// EP2 to the AUDIO speaker outputs Currently selected 
;	// alternate settings for up to USB_NUM_IFACES interfaces
;static BYTE USB_IF_ALT[3];
;
;// USB_PRINTER variables
;static BYTE USB_PRN_RUN = 0xee;	// 0=no buffer actively printing
;static PBYTE USB_PRN_READ = (PBYTE)0xeeee;	// current position in the buffer
;static PBYTE USB_PRN_END = (PBYTE)0xeeee;	// last position in the buffer
;static PBDT USB_PRN_PTR = (PBDT)0xeeee;	// Pointer to the USB BDT in use
;
;// The SETUP Device Request is copied here until it has been
;// processed. After processing, bRequestType is set to 0xff which will
;// let us know if we get an erroneous IN or OUT token.
;// See page 172, section 9.3 rev 1.0 USB spec
;
;WORD USB_ERROR_CTR[8];
;	// 16 bit count of the number of PID errors
;	// 16 bit count of the number of CRC5 errors
;	// 16 bit count of the number of CRC16 errors
;	// 16 bit count of the number of DFN8 errors
;	// 16 bit count of the number of Bus Time Outs
;	// 16 bit count of the number of DMA errors
;	// 16 bit count of the number of OWN bit BDT errors
;	// 16 bit count of the number of Bit Stuff Error
;
;#define USB_LED_ERROR_ON		asm("stp 7")
;#define USB_LED_ERROR_OFF		asm("clp 7")
;#define USB_LED_INT_ON			asm("stp 6")	// 1<<USB_LED_INT
;#define USB_LED_INT_OFF			asm("clp 6")	// 0xff-USB_LED_INT_ON
;#define USB_LED_ATTACH_ON		asm("stp 5")	// 1<<USB_LED_ATTACH
;#define USB_LED_ATTACH_OFF		asm("clp 5")	// 0xff-USB_LED_ATTACH_ON
;#define USB_LED_SEND_ON			asm("stp 4")	// 1<<USB_LED_SEND
;#define USB_LED_SEND_OFF		asm("clp 4")	// 0xff-USB_LED_SEND_ON
;
;static WORD USB_STATUS_DEVICE = 0xeeee;		// Device status = self-powered.
;static WORD USB_STATUS_INTERFACE = 0xeeee;		// used for interface status requests
;static WORD USB_STATUS_ENDPOINT = 0xeeee;		// used for EP status requests
;BYTE bRemoteWakeupEnabled = FALSE;
;
;#define USB_STR_NUM 8	// number of strings in the table not including 0 or n.
;
;// if the number of strings changes, look for USB_STR_0 everywhere and make 
;// the obvious changes.  It should be found in 3 places.
;
;static BYTE USB_STR_0[] = "\000\003\x09\x04";
;static BYTE USB_STR_1[] = "\000\003V\000A\000u\000t\000o\000m\000a\000t\000i\000o\000n\000 \000I\000n\000c\000";
;static BYTE USB_STR_2[] = "\000\003V\000U\000S\000B\000 \000S\000y\000n\000t\000h\000e\000s\000i\000z\000a\000b\000l\000e\000 \000C\000o\000r\000e\000 \000D\000e\000m\000o\000";
;static BYTE USB_STR_3[] = "\000\003B\000E\000T\000A\000";
;static BYTE USB_STR_4[] = "\000\003#\0000\0002\000";
;static BYTE USB_STR_5[] = "\000\003_\000A\0001\000";
;static BYTE USB_STR_6[] = "\000\003P\0001\0002\0008\0004\000 \000P\000r\000i\000n\000t\000e\000r\000";
;#if WANT_PRINTER || WANT_SOUND
;static BYTE USB_STR_7[] = "\000\003C\000o\000m\000p\000o\000s\000i\000t\000e\000 \000H\000u\000b\000";
;#else
;static BYTE USB_STR_7[] = "\000\003H\000u\000b\000";
;#endif
;static BYTE USB_STR_8[] = "\000\003V\000A\000u\000t\000o\000 \000P\000r\000i\000n\000t\000e\000r\000 \000D\000o\000n\000g\000l\000e\000";
;static BYTE USB_STR_n[] = "\000\003B\000A\000D\000 \000S\000T\000R\000I\000N\000G\000 \000I\000n\000d\000e\000x\000";
;
;
;static PBYTE USB_STRING_DESC[USB_STR_NUM+2] =
;	{
;	USB_STR_0,
;	USB_STR_1,
;	USB_STR_2,
;	USB_STR_3,
;	USB_STR_4,
;	USB_STR_5,
;	USB_STR_6,
;	USB_STR_7,
;	USB_STR_8,
;	USB_STR_n
;	};
;
;// any words are stored low byte first then high byte
;
;BYTE USB_DEVICE_DESC[] =	// table for the USB Device Descriptor
;	{
;	// This table is polled by the host immediately after USB Reset has been released.
;	// This table defines the maximum packet size EP0 can take.
;	// See section 9.6.1 of the Rev 1.0 USB specification.
;	// These fields are application DEPENDENT. Be sure to modify these to meet
;	// your specifications.
;	18,					// bLength	Length of this descriptor
;	1,					// bDescType 	This is a DEVICE descriptor
;	0,1,				// bcdUSB	USB revision 1.00
;	USB_DEVICE_CLASS,	// bDeviceClass
;	0,					// bDeviceSubClass
;	0,					// bDeviceProtocol
;	0xff,				// bMaxPacketSize0 - inited in UsbInit()
;	0xa3,0x05,			// idVendor	0x05a3 is VAutomation Vendor ID
;	0x01,0x01,			// idProduct
;	0,0,				// bcdDevice
;	0x01,				// iManufacturer
;	USB_PRODUCT,		// iProduct
;	USB_SERIAL_NUMBER,	// iSerialNumber
;	0x01				// bNumConfigurations
;	};
;
;BYTE USB_CONFIG_DESC[CONFIG_SIZE] =// table for the USB Configuration Descriptor
;	{
;	// This table is retrieved by the host after the address has been set.
;	// This table defines the configurations available for the device.
;	// See section 9.6.2 of the Rev 1.0 USB specification (page 184).
;	// These fields are application DEPENDENT. 
;	// Be sure to modify these to meet your specifications.
;	9,		// bLength	Length of this descriptor
;	2,		// bDescType	2=CONFIGURATION
;
;	CONFIG_SIZE & 0xff, CONFIG_SIZE >> 8, 
;	USB_NUM_IFACES,		// bNumInterfaces	Number of interfaces
;
;//USB_CONFIG_VAL:
;	0x01,	// bConfigValue	Configuration Value
;	0x04,	// iConfig	String Index for this config = #01
;#if WANT_HUB
;	0xe0,	// bmAttributes	attributes - self powered, remote wakeup,
;#else
;	0xc0,	// bmAttributes	attributes - self powered
;#endif
;
;	0		// MaxPower	self-powered draws 0 mA from the bus.
;
;#if WANT_SOUND
;	,
;#if 1	// commented out since we can't prove wether it works or not
;//	IIIII  FFFFF   CCCC   000 
;//	  I    F      C      0   0
;//	  I    FFF    C      0   0
;//	  I    F      C      0   0
;//	IIIII  F       CCCC   000 
;
;//// AUDIO CONTROL	// See section 9.6.3 of the Rev 1.0 USB spec (page 185)
;
;	0x09,	// blength	Length of this desriptor
;	4,		// bDescriptorType	4=INTERFACE
;	0,		// bIfaceNum	interface number
;	0,		// bAltSetting	Alternate setting 0 (no others)
;	0,		// bNumEndpoints	Number of endpoints= use EP0 only
;	0x01,	// bIfaceClass	Interface class 01=AUDIO
;	0x01,	// bIfaceSubClass	Audio COntrol
;	0x00,	// bIfaceProtocol	none
;	0,	// iInterface
;
;//USB_AC_IFACE:		// Audio Class Specific Audio Control (AC) Interface desc
;	0x09,		// bLength
;	0x24,		// Audio class specific interface descriptor
;	0x01,		// HEADER type
;	0x09,0x00,	// spec rev = 0009
;	0x1e,0x00,	// total length=001e
;	0x01,		// number of streaming interfaces=1
;	0x01,		// Interface number=1
;
;	0x0c,		// bLength
;	0x24,		//Audio class specific interface desc
;	0x02,		//Input Terminal
;	0x01,		//TerminalID
;	0x01,0x01,	//TerminalType=0101=Audio Streaming
;	0x00,		//output AssocTerminal
;	0x02,		//Number of Channels=2
;	0x03,0x00,	//wChannelConfig=L,R
;	0x00,		//iChannelNames=none
;	0x00,		//iTerminal
;
;	0x09,		//bLength
;	0x24,		//Type=Audio class specific interface desc
;	0x03,		//Output Terminal
;	0x02,		//TerminalID
;	0x01,0x03,	//TerminalType=0301=Generic Speakers
;	0x00,		//bAssocTerminal=terminalID connect to=0?
;	0x01,		//bSourceID=TerminalID which is the source for this terminal=feature unit
;	0x00,		//iTerminal=string
;#endif
;
;//	IIIII  FFFFF   CCCC    1  
;//	  I    F      C       11  
;//	  I    FFF    C        1  
;//	  I    F      C        1  
;//	IIIII  F       CCCC  11111
;
;//// AUDIO STREAM			// See section 9.6.3 of the Rev 1.0 USB spec (page 185)
;
;//		 AAA   L      TTTTT   000 
;//		A   A  L        T    0   0
;//		AAAAA  L        T    0   0
;//		A   A  L        T    0   0
;//		A   A  LLLLL    T     000 
;
;	0x09,	// blength	Length of this desriptor
;	4,		// bDescriptorType	4=INTERFACE
;	1,		// bIfaceNum	interface number #1
;	0,		// bAltSetting	Alternate setting 0 Zero ISO Bandwidth version which is required by Win98
;	1,		// bNumEndpoints	Number of endpoints= use EP0 only
;	0x01,	// bIfaceClass	Interface class 01=AUDIO
;	0x02,	// bIfaceSubClass	Audio Streaming
;	0x00,	// bIfaceProtocol	none
;	4,		// iInterface	String=#01
;
;	0x07,	// bLength
;	0x24,	// Audio Class Specific AS Interface Desc.
;	0x01,	// AS_GENERAL
;	0x01,	// TermLink connected to terminal #1
;	0x00,	// Delay=0
;	0x00,0x01,	// FormatTag=PCM
;
;	0x0b,		//bLength	// Format Specification
;	0x24,		//Audio Class Specific AS Interface Desc.
;	0x02,		//FORMAT_TYPE
;	0x01,		//formatType
;	0x02,		//NrChannels=2
;	0x02,		//SubFrameSize=2 byte
;	16,			//BitResolution=16 bits
;	0x01,		//SamFreqType=1 type
;	0x00,0x00,	// ZERO BANDWIDTH
;	0x00,		// SamFreq MSB (it's a 24 bit number in HZ)
;
;	9,			// bLength	Length of this descriptor
;	5,			// bDescType	5=ENDPOINT
;	ENDPOINT_SPEAKER,	// bEndpntAddr	End Point address (EP2=out)
;	0x09,		// bmAttr	ISO adaptive rate
;	0x00,0x00,	// wMaxPktSize	Max Packet Size
;	1,			// bInterval	
;	0,			// bRefresh
;	0,			// SyncAddr	None
;
;////USB_AS_DESC1:		// Class Specific Audio AS EP descriptor
;	7,			// bLength	Length of this descriptor
;	0x25,		// bDescType	Class specific ENDPOINT
;	1,			// SubType	GENERAL
;	0,			// bmAttr	none
;	2,			// bDelayUnits	PCM samples
;	0x01,0x00,	// bLockDelay	1 sample delay
;
;//		 AAA   L      TTTTT    1  
;//		A   A  L        T     11  
;//		AAAAA  L        T      1  
;//		A   A  L        T      1  
;//		A   A  LLLLL    T    11111
;
;	0x09,		// blength	Length of this desriptor
;	4,			// bDescriptorType	4=INTERFACE
;	1,			// bIfaceNum	interface number #1
;	1,			// bAltSetting	Alternate setting #1
;	1,			// bNumEndpoints	Number of endpoints=1
;	0x01,		// bIfaceClass	Interface class 01=AUDIO
;	0x02,		// bIfaceSubClass	Subclass 02=AUDIO_STREAMING
;	0x00,		// bIfaceProtocol	protocol
;	05,			// iInterface	String Index
;
;//USB_AS_IFACE:	// Audio Class Specific Audio Streaming (AS) Interface desc
;	0x07,		// bLength
;	0x24,		// Audio Class Specific AS Interface Desc.
;	0x01,		// AS_GENERAL
;	0x01,		// TermLink connected to terminal #1
;	0x00,		// Delay=0
;	0x01,0x00,	// FormatTag=PCM
;
;	0x0b,		//bLength	// Format Specification
;	0x24,		//Audio Class Specific AS Interface Desc.
;	0x02,		//FORMAT_TYPE
;	0x01,		//formatType
;	0x02,		//NrChannels=2
;	0x02,		//SubFrameSize=2 byte
;	16,			//BitResolution=16 bits
;	0x01,		//SamFreqType=1 type
;	0x11,0x2b,	// SamFreq=11.025Khz
;	0x00,		// SamFreq MSB (it's a 24 bit number in HZ)
;
;//USB_EP_DESC1:	// table for the USB ENDPOINT Descriptor
;	// See section 9.6.4 of the Rev 1.0 USB spec (page 187)
;	9,			// bLength	Length of this descriptor
;	5,			// bDescType	5=ENDPOINT
;	ENDPOINT_SPEAKER,			// bEndpntAddr	End Point address (EP2=out)
;	0x09,		// bmAttr	ISO adaptive rate
;	0x30,0x00,	// wMaxPktSize	Max Packet Size
;	1,			// bInterval	
;	0,			// bRefresh
;	0,			// SyncAddr	None
;
;//USB_AS_DESC1:	// Class Specific Audio AS EP descriptor
;	7,			// bLength	Length of this descriptor
;	0x25,		// bDescType	Class specific ENDPOINT
;	1,			// SubType	GENERAL
;	0,			// bmAttr	none
;	2,			// bDelayUnits	PCM samples
;	0x01,0x00	// bLockDelay	1 sample delay
;
;//	IIIII  FFFFF   CCCC   222 
;//	  I    F      C      2   2
;//	  I    FFF    C        22 
;//	  I    F      C       2   
;//	IIIII  F       CCCC  22222
;#endif
;
;#if WANT_PRINTER
;	,
;//// PRINTER		// See section 9.6.3 of the Rev 1.0 USB spec (page 185)
;	0x09,	// blength	Length of this desriptor
;	4,		// bDescriptorType	4=INTERFACE
;	2,		// bIfaceNum	interface number
;	0,		// bAltSetting	Alternate setting 0=none
;	2,		// bNumEndpoints	Number of endpoints=2
;7,//0xff,	// bIfaceClass	Interface class ff=Vendor Specific
;1,//0xff,	// bIfaceSubClass	
;	2,		// bIfaceProtocol, 2=bidirectional
;	8,		// iInterface, string number 8
;
;// table for the USB ENDPOINT Descriptor
;// See section 9.6.4 of the Rev 1.0 USB spec (page 187)
;	7,			// bLength       Length of this descriptor
;	5,			// bDescType     5=ENDPOINT
;	ENDPOINT_PRINTER,			// bEndpntAddr   End Point address (EP3=out)
;	0x02,		// bmAttr        Attributes 02=BULK
;	0x40,0x00,	// wMaxPktSizeL  Max Packet Size
;	0,			// bInterval
;
;	7,			// bLength       Length of this descriptor
;	5,			// bDescType     5=ENDPOINT
;	0x83,		// bEndpntAddr   End Point address (EP3=in)
;	0x02,		// bmAttr        Attributes 02=BULK
;	0x40,0x00,	// wMaxPktSizeL  Max Packet Size
;	0			// bInterval
;#endif
;
;#if WANT_HUB
;	,
;//// HUB
;	0x09,	// blength	Length of this desriptor
;	4,		// bDescriptorType	4=INTERFACE
;	0,		// bIfaceNum	interface number
;	0,		// bAltSetting	Alternate setting 0 (no others)
;	1,		// bNumEndpoints
;	0x09,	// bIfaceClass	Interface class 09=HUB
;	0x00,	// bIfaceSubClass
;	0x00,	// bIfaceProtocol	none
;0,//	7,		// iInterface = string 7
;
;// table for the USB ENDPOINT Descriptor
;// See section 9.6.4 of the Rev 1.0 USB spec (page 187)
;	7,			// bLength       Length of this descriptor
;	5,			// bDescType     5=ENDPOINT
;	0x80 + ENDPOINT_HUB,	// bEndpntAddr   End Point address (EP_,in)
;
;// 3 or 7 who knows???
;// dec likes 3
;// peracom likes 7
;	0x03,		// bmAttr        Attributes 03=Interrupt
;
;	PORT_BYTES,0x00,	// wMaxPktSizeL  Max Packet Size
;	0xff		// bInterval
;#endif //WANT_HUB
;	};
;
;void interrupt UsbTargetIntService(void);
;BOOL UsbRegRW(BYTE b);
;void UsbSuspend(void);
;void UsbConfig(void);
;void UsbAddress(void);
;void UsbDefault(void);
;void UsbPowered(void);
;void UsbStall(PBYTE p);
;void UsbTokenDoneEP0(void);
;#if DEBUG_EP0
;void UsbTokenDoneEP0setup(void);
;void UsbTokenDoneEP0in(void);
;void UsbTokenDoneEP0out(void);
;void UsbTokenDoneEP0other(void);
;#endif // DEBUG_EP0
;#if WANT_SOUND
;void UsbTokenDoneEP1_Speaker(void);
;void UsbChangeFreq(WORD wDelta);
;#endif // WANT_SOUND
;#if WANT_PRINTER
;void UsbTokenDoneEP3(void);
;void UsbPrinter(void);
;void PrinterClassSetup(void);
;void InitPrinterEndpoints(void);
;#endif
;void UsbTokenDoneEPn(void);
;void UsbProvideRxBDT(BOOL bOther);
;void UsbSofDet(void);
;void UsbSleep(void);
;void UsbResume(void);
;void UsbError(void);
;void UsbEchoEP(void);
;void UsbVendor(void);
;void UsbVendSetStatus(void);
;void UsbVendGetStatus(void);
;void UsbVendSetEndPoint(void);
;void UsbVendGetEndPoint(void);
;void UsbVendSetMemory(void);
;void UsbVendGetMemory(void);
;void UsbVendBreakOwns(void);
;
;void UsbReleaseTx(void);
;
;void UsbGetStatus(void);
;void UsbClearFeature(void);
;void UsbSetFeature(void);
;void UsbSetAddress(void);
;void UsbGetDescription(void);
;void UsbSetDescription(void);
;void UsbGetConfig(void);
;void UsbSetConfig(void);
;void UsbGetInterface(void);
;void UsbSetInterface(void);
;void UsbSynchFrame(void);
;void UsbDequeue(void);
;
;BDT		cBDT;	// copy of current BDT.  All work should be done on this
;
;#if !WANT_LITE
;BYTE usb_target_pcl, usb_target_pch, usb_target_psr, usb_target_new_pcl, usb_target_new_pch;
;#endif
;
;#if DEBUG_PULSE
;WORD usb_target_pulse;
;#endif
;
;// <<<<<<<<<<<Interrupt Service Routine Entry Point>>>>>>>>>>>>>>>>>
;#pragma interrupt_level 1
;void interrupt UsbTargetIntService()
;{
_UsbTargetIntService:
		PSH r0
		PSH r1
		PSH r2
		PSH r3
		PSH r4
		PSH r5
;#if DEBUG_STACK
;	static BYTE	b;
;	static ONION	onion;
;#endif //DEBUG_STACK
;
;#if WANT_SIMULATOR
;	asm("stp 6");
;	asm("stp 7");
;	asm("clp 7");
;	asm("clp 6");
;#endif
;
;#if !WANT_LITE
;	USB_LED_INT_ON;
		STP 6
;#asm		// save PC and PSR for later testing
;	pop r0			; pcl
		POP r0
;	pop r1			; pch
		POP r1
;	pop r2			; psr
		POP r2
;	sta r0,_usb_target_pcl
		STA r0,_usb_target_pcl
;	sta r1,_usb_target_pch
		STA r1,_usb_target_pch
;	sta r2,_usb_target_psr
		STA r2,_usb_target_psr
;	psh r2			; psr
		PSH r2
;	psh r1			; pch
		PSH r1
;	psh r0			; pcl
		PSH r0
;#endasm
;#endif
;
;	usbSave = usb;
		LDI r2,0x80 ;_usb
		LDI r3,0x02 ;_usb>>8
		LDI r4,0x92 ;_usbSave
		LDI r5,0x4e ;_usbSave>>8
		LDI r1,0x11
_UsbTargetIntService__20:
		LDX r2
		STX r4
		UPP r2
		UPP r4
		DEC r1
		BRNE _UsbTargetIntService__20 ;(-07)
;	usbSave.intStatusMasked = usbSave.intStatus & usbSave.intEnable;
		LDA r1,_usbSave
		LDA r0,_usbSave+0x1
		AND r1
		STA r0,_usbSave+0xd
;	usbSave.ep = usbSave.status >> 4;	// end point
		LDA r0,_usbSave+0x4
		CLP C
		ROR r0
		CLP C
		ROR r0
		CLP C
		ROR r0
		CLP C
		ROR r0
		STA r0,_usbSave+0xe
;	usbSave.pBDT = (PBDT)((usbSave.bdtPage<<8)|usbSave.status);
		LDA r2,_usbSave+0x4
		LDA r4,_usbSave+0x7
		TX0 r4
		T0X r5
		LDI r4,0x00
		TX0 r4
		OR  r2
		T0X r2
		TX0 r5
		T0X r3
		STA r3,_usbSave+0x10
		STA r2,_usbSave+0xf
;	USB_ERROR_STAT.b[0] |= usbSave.errorStatus;	// add error bits
		LDA r1,_usbSave+0x2
		LDA r0,_USB_ERROR_STAT
		OR  r1
		STA r0,_USB_ERROR_STAT
;	cBDT = *usbSave.pBDT;		// save copy of bdt
		LDX r2
		STA r0,_cBDT
		LDO r2,0x01
		STA r0,_cBDT+0x1
		LDO r2,0x02
		STA r0,_cBDT+0x2
		LDO r2,0x03
		STA r0,_cBDT+0x3
;
;	if ((usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE) && (usbSave.status & 0x08))	// out token
		LDA r0,_usbSave+0xd
		BTT I
		BREQ _UsbTargetIntService__96 ;(+1f)
		LDA r0,_usbSave+0x4
		BTT I
		BREQ _UsbTargetIntService__96 ;(+19)
;		USB_LAST_OUT[usbSave.ep] = (usbSave.status >> 2) & 1;
		LDI r2,0x7e ;_USB_LAST_OUT
		LDI r3,0x4e ;_USB_LAST_OUT>>8
		LDA r0,_usbSave+0xe
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r1,0x01
		LDA r0,_usbSave+0x4
		CLP C
		ROR r0
		CLP C
		ROR r0
		AND r1
		STX r2
;
;#if DEBUG_SLEEP
;	if (usbSave.intStatus & INT_STAT_MASK_SLEEP)
;		{
;		puts("UsbTargetIntService: ");
;		putb(*(PBYTE)&usbSave.intStatus);
;		puts(", ");
;		putb(*(PBYTE)&usbSave.intEnable);
;		putCrlf();
;		}
;#endif
;
;#if WANT_HUB
;	if (usbSave.intStatusMasked == INT_STAT_MASK_SLEEP)
;		{	// Sleep and only sleep is set
;		HubSleep();
;		usb.intStatus = INT_STAT_MASK_SLEEP;	// clear sleep
;		return;
;		}
;#endif // WANT_HUB
;
;#if DEBUG_REGS && WANT_HARDWARE && !WANT_LITE
;//	if (debug.bits.UsbInt)
;//		if (usbSave.intStatusMasked != INT_STAT_MASK_SOF)	// ignore SOF onlys
;			{
;			if (USB_DUMP_COUNT)
;				{
;				USB_DUMP_COUNT--;
;				putb(USB_DUMP_COUNT);
;				putc('#');
;				UsbDrvDumpRegs();
;				if (!USB_DUMP_COUNT)
;					puts("No more interrupts will be dumped\r\n");
;				}
;			}
;#endif // DEBUG_REGS
;
;#if 0
;	putc('$');
;	putb(USB_STATE);
;#endif
;
;	if (usbSave.control & MASK_CTL_HOST_MODE_EN)
_UsbTargetIntService__96:
		LDA r0,_usbSave+0x5
		BTT I
		BREQ _UsbTargetIntService__a2 ;(+06)
;		USB_STATE = 0;
		XOR r0
		STA r0,_USB_STATE
		BREQ _UsbTargetIntService__ff ;(+5d)
;	else
;		{
;		if (USB_STATE & 0x80)
_UsbTargetIntService__a2:
		LDA r0,_USB_STATE
		BRPL _UsbTargetIntService__ad ;(+06)
;			{
;			UsbSuspend();
		JSR _UsbSuspend
;			}
		JMP _UsbTargetIntService__ff
;		else if (USB_STATE == CONFIG_STATE)
_UsbTargetIntService__ad:
		LDA r0,_USB_STATE
		BRNE _UsbTargetIntService__bb ;(+09)
;			{
;			UsbCheckForSuspend();
		JSR _UsbCheckForSuspend
;
;			UsbConfig();
		JSR _UsbConfig
;			}
		JMP _UsbTargetIntService__ff
;		else if (USB_STATE == ADDRESS_STATE)
_UsbTargetIntService__bb:
		LDI r1,0x01
		LDA r0,_USB_STATE
		CMP r1
		BRNE _UsbTargetIntService__c9 ;(+06)
;			{
;			UsbAddress();
		JSR _UsbAddress
;			}
		JMP _UsbTargetIntService__ff
;		else if (USB_STATE == DEFAULT_STATE)
_UsbTargetIntService__c9:
		LDI r1,0x02
		LDA r0,_USB_STATE
		CMP r1
		BRNE _UsbTargetIntService__d7 ;(+06)
;			{
;			UsbDefault();
		JSR _UsbDefault
;			}
		JMP _UsbTargetIntService__ff
;		else if (USB_STATE == POWERED_STATE)
_UsbTargetIntService__d7:
		LDI r1,0x03
		LDA r0,_USB_STATE
		CMP r1
		BRNE _UsbTargetIntService__e5 ;(+06)
;			{
;			UsbPowered();
		JSR _UsbPowered
;			}
		JMP _UsbTargetIntService__ff
;		// The only interrupt that should be enabled at this point is the USB_RST.
;	//	else if (usbSave.intStatusMasked & (1 << INT_STAT_USB_RST))
;	//		{
;	//		UsbPowered();
;	//		}
;		else if (usbSave.intStatusMasked & INT_STAT_MASK_ATTACH)
_UsbTargetIntService__e5:
		LDA r0,_usbSave+0xd
		BTT 6
		BREQ _UsbTargetIntService__f8 ;(+0d)
;			{
;			PUTS("~42", "Attach ignored\r\n");
		LDI r4,0x41 ;__Lstrings+0x9b8
		LDI r5,0x45 ;__Lstrings+0x9b8>>8
		JSR _puts
;			putFlush();
		JSR _putFlush
;			}
		JMP _UsbTargetIntService__ff
;		else
;			STALL("~39", "UNEXPECTED BIT IN INT_STAT");
_UsbTargetIntService__f8:
		LDI r4,0xe1 ;__Lstrings+0x858
		LDI r5,0x43 ;__Lstrings+0x858>>8
		JSR _UsbStall
;		}
;
;// by writting the value we previously read, all 
;// bits that were set and enabled are cleared by hardware.
;
;	usb.intStatus = usbSave.intStatusMasked;
_UsbTargetIntService__ff:
		LDA r0,_usbSave+0xd
		STA r0,_usb
;
;#if !WANT_LITE
;	usb_target_psr &= 0x4F;
		LDI r1,0x4f
		LDA r0,_usb_target_psr
		AND r1
		STA r0,_usb_target_psr
;#endif
;
;//	usb.errorStatus = 0xff;		// clear error bits
;	usb.errorStatus = usbSave.errorStatus;	// clear error bits that we've seen
		LDA r0,_usbSave+0x2
		STA r0,_usb+0x2
;
;	USB_LED_INT_OFF;
		CLP 6
;
;#if DEBUG_PULSE
;	if (usbSave.intStatus & INT_STAT_MASK_SOF)
;		usb_target_pulse++;
;	if (usb_target_pulse & 0x0200)
;		usb_target_psr |= 0x80;
;	else
;		usb_target_psr &= 0x7f;
;
;#endif
;
;#if !WANT_LITE
;#asm
;	pop r2			; pcl
		POP r2
;	pop r3			; pch
		POP r3
;	pop r4			; psr
		POP r4
;	lda r6,_usb_target_pcl
		LDA r6,_usb_target_pcl
;	lda r7,_usb_target_pch
		LDA r7,_usb_target_pch
;	lda r4,_usb_target_psr
		LDA r4,_usb_target_psr
;	psh r4			; psr
		PSH r4
;	psh r7			; pch
		PSH r7
;	psh r6			; pcl
		PSH r6
;
;#if DEBUG_STACK
;; see if stack was hosed, r23 should == r67
;	tx0 r6
;	cmp r2
;	brne stack_hosed
;	tx0 r7
;	cmp r3
;	brne stack_hosed
;#endif //DEBUG_STACK
;
;#endasm
;	goto the_end;	//	rti		; happy
;#asm
;
;#if DEBUG_STACK
;stack_hosed:
;	sta r2,_usb_target_new_pcl
;	sta r3,_usb_target_new_pch
;#endif //DEBUG_STACK
;#endasm
;
;#if DEBUG_STACK
;	puts("\r\n\aUSB rti expected ");
;	putb(usb_target_pch);
;	putb(usb_target_pcl);
;	puts(" found ");
;	putb(usb_target_new_pch);
;	putb(usb_target_new_pcl);
;	putCrlf();
;
;	for (onion.w=0x300; onion.w<0x400; onion.w++)
;		{
;		if ((onion.w & 0x0f) == 0x00)
;		puto(onion);
;		putc(':');
;		putbs(*onion.pb);
;		if ((onion.w & 0x0f) == 0x0f)
;			{
;			putCrlf();
;			}
;		}
;
;	puts("\r\nPress any key\r\n");
;
;	for (b=0; !UartCharWaiting(); b++)
;		{
;		if (b & 1)
;			asm("stp 7");
;		else
;			asm("clp 7");
;		if (b & 2)
;			asm("stp 6");
;		else
;			asm("clp 6");
;		if (b & 4)
;			asm("stp 5");
;		else
;			asm("clp 5");
;		if (b & 8)
;			asm("stp 4");
;		else
;			asm("clp 4");
;		}
;#endif //DEBUG_STACK
;
;//	asm("rti");
;the_end:
;#endif // !WANT_LITE
;
;	return;
;}
		POP r5
		POP r4
		POP r3
		POP r2
		POP r1
		POP r0
		RTI
;
;void UsbPowered()
;{
;	static PBDT	pBDT;
;	// we got the USB RESET indication. We simply need to go to the
;	// DEFAULT state and enable endpoint 0 at addr 0.
;	// First, assign EP0 an RX buffer
;
;	if (bFirstDeviceDescriptorGets8Bytes)
_UsbPowered:
		LDA r0,_bFirstDeviceDescriptorGets8Byte
		BREQ _UsbPowered__a ;(+05)
;		{
;#if DEBUG_TRUNCATE
;		puts("UsbPowered: will truncate next device descriptor\r\n");
;#endif
;		bTruncateNextDeviceDescriptor = TRUE;
		LDI r0,0x01
		STA r0,_bTruncateNextDeviceDescriptor
;		}
;
;	memset(USB_NEXT_OUT, 0, ENDPOINTS);
_UsbPowered__a:
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x86 ;_USB_NEXT_OUT
		LDI r5,0x4e ;_USB_NEXT_OUT>>8
		JSR _memset
;	memset(USB_LAST_OUT, 0xff, ENDPOINTS);
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0xff
		LDI r4,0x7e ;_USB_LAST_OUT
		LDI r5,0x4e ;_USB_LAST_OUT>>8
		JSR _memset
;	memset(USB_NEXT_IN, 0, ENDPOINTS);
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x82 ;_USB_NEXT_IN
		LDI r5,0x4e ;_USB_NEXT_IN>>8
		JSR _memset
;
;	usb.intStatus = INT_STAT_MASK_TOKEN_DONE;	// clear pending token done
		LDI r0,0x08
		STA r0,_usb
;	usb.intStatus = INT_STAT_MASK_TOKEN_DONE;	// clear pending token done
		STA r0,_usb
;	usb.intStatus = INT_STAT_MASK_TOKEN_DONE;	// clear pending token done
		LDI r0,0x08
		STA r0,_usb
;	usb.intStatus = INT_STAT_MASK_TOKEN_DONE;	// clear pending token done
		STA r0,_usb
;
;// using subscripts is faster than pBDT++
;
;	pBDT = USB_BDT_PAGE;	// pBDT points to EP0 even in buffer
		LDI r0,0x70
		STA r0,_usb_target_psr+0x2
		LDI r0,0x00
		STA r0,_usb_target_psr+0x1
;	pBDT[0].addr.pb = (PBYTE)USB_BUFFER;
		T0X r2
		LDA r3,_usb_target_psr+0x2
		LDI r0,0x74
		STO r2,0x03
		LDI r0,0x00
		STO r2,0x02
;	pBDT[1].addr.pb = ((PBYTE)USB_BUFFER) + 64;
		LDI r0,0x74
		STO r2,0x07
		LDI r0,0x40
		STO r2,0x06
;	pBDT[0].bc = pBDT[1].bc = 64;			// buffer size is 64 bytes even though we only need 8 now
		LDI r0,0x40
		STO r2,0x05
		LDO r2,0x05
		STO r2,0x01
;	pBDT[0].pid = 0x80;		// own bit of EP0 RX=SIE (always change the OWN bit last!)
		LDI r0,0x80
		STX r2
;#if 0	// don't release it anymore
;	pBDT[1].pid = 0x80;		// own bit of EP0 RX=SIE (always change the OWN bit last!)
;#endif
;	pBDT[2].addr.w = pBDT[3].addr.w = 0;
		LDA r4,_usb_target_psr+0x1
		LDA r5,_usb_target_psr+0x2
		XOR r0
		STO r4,0x0f
		XOR r0
		STO r4,0x0e
		LDO r4,0x0f
		STO r2,0x0b
		LDO r4,0x0e
		STO r2,0x0a
;	pBDT[2].bc = pBDT[3].bc = 0;
		XOR r0
		STO r2,0x0d
		LDO r2,0x0d
		STO r2,0x09
;	pBDT[2].pid = pBDT[3].pid = 0x00;
		XOR r0
		STO r2,0x0c
		LDO r2,0x0c
		STO r2,0x08
;
;	setup.bRequestType = 0xff;	// invalidate bmRequestType
		LDI r0,0xff
		STA r0,_setup
;
;	USB_STATE = DEFAULT_STATE;	// change the state to be DEFAULT
		LDI r0,0x02
		STA r0,_USB_STATE
;
;#if DEBUG_STATE
;	puts("Usb:DEFAULT_STATE\r\n");
;#endif
;	USB_CURR_CONFIG = 0;		// reset the current configuration to none
		XOR r0
		STA r0,_USB_CURR_CONFIG
;
;	usb.address = 0;				// USB addr=0 (default)
		STA r0,_usb+0x6
;	usb.control = 0x03;				// clear the BDT ODD bits in the VUSB
		LDI r0,0x03
		STA r0,_usb+0x5
;	usb.control = 0x01;				// enable the VUSB
		LDI r0,0x01
		STA r0,_usb+0x5
;	ENDPT_RG[0] = ENDPT_CONTROL;	// endpoint 0 is a control pipe and requires an ACK
		LDI r0,0x0d
		STA r0,_ENDPT_HOST_RG
;	usb.intEnable = 0xfd;			// enable all ints but ERROR
		LDI r0,0xfd
		STA r0,_usb+0x1
;	usb.intStatus = usbSave.intStatus; // clear whatever interupts were set
		LDA r0,_usbSave
		STA r0,_usb
;	USB_ERROR_STAT.bits.reset = 1;	// set the bit in the diagnostic status register
		LDA r0,_USB_ERROR_STAT+0x1
		LDI r1,0x02
		OR  r1
		STA r0,_USB_ERROR_STAT+0x1
;
;#if WANT_HUB
;	HubReset(0);		/* Warm reset the Hub (CEK 3/3/99) */
;#endif
;
;//	all done... return from interrupt!   <<<<<<EXIT>>>>>
;
;	return;
		RTS
;}
;
;void UsbSuspend()
;{
;
;	STALL("~40", "SUSPEND not supported");
_UsbSuspend:
		LDI r4,0x66 ;__Lstrings+0x7dd
		LDI r5,0x43 ;__Lstrings+0x7dd>>8
;	return;
;}
;
;void UsbStall(PBYTE p)
;{
;
;	puts("\a\r\nError:");
_UsbStall:
		STA r4,A_UsbSendIn
		STA r5,A_UsbSendIn+0x1
		LDI r4,0xb6 ;__Lstrings+0x92d
		LDI r5,0x44 ;__Lstrings+0x92d>>8
		JSR _puts
;	puts(p);
		LDA r4,A_UsbSendIn
		LDA r5,A_UsbSendIn+0x1
		JSR _puts
;	puts(" - stalling\r\n");
		LDI r4,0x33 ;__Lstrings+0x9aa
		LDI r5,0x45 ;__Lstrings+0x9aa>>8
		JSR _puts
;	putFlush();
		JSR _putFlush
;
;	ENDPT_RG[usbSave.ep] |= ENDPT_STALL_BIT;	// stall endpoint zero on error condition
		LDI r1,0x02
		LDA r2,_usbSave+0xe
		LDI r3,0x00
		LDI r0,0x90
		ADD r2
		T0X r2
		LDI r0,0x02
		ADC r3
		T0X r3
		LDX r2
		OR  r1
		STX r2
;
;	return;
		RTS
;}
;
;void UsbDefault()
;{
;	UsbCheckForSuspend();
_UsbDefault:
		JSR _UsbCheckForSuspend
;
;	UsbConfig();
		JMP _UsbConfig
;}
;
;void UsbAddress()
;{
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
_UsbAddress:
		LDA r0,_usbSave+0xd
		BTT I
		BREQ _UsbAddress__23 ;(+1d)
;		{
;		if (IS_TOKEN_SETUP)
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		CMP r1
		BRNE _UsbAddress__23 ;(+12)
;			{	// copy the 8 byte Device Request so we don't lose it.
;			memcpy((PBYTE)&setup, cBDT.addr.pb, 8);
		LDI r0,0x08
		STA r0,Aa_UsbVendSetEndPoint
		LDA r2,_cBDT+0x2
		LDA r3,_cBDT+0x3
		LDI r4,0x8a ;_setup
		LDI r5,0x4e ;_setup>>8
		JSR _memcpy
;			}
;		}
;
;	UsbCheckForSuspend();
_UsbAddress__23:
		JSR _UsbCheckForSuspend
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
		LDA r0,_usbSave+0xd
		BTT I
		BREQ _UsbConfig ;(+50)
		JMP _UsbAddress__66
;		{
;		switch (setup.bRequestType & 0x60)
;			{
;			case 0x00:
;				switch (setup.bRequest)
;					{
;					case  0:	//UsbGetStatus();		// ep0 only
;					case  1:	//UsbClearFeature();	// ep0 only
;					case  3:	//UsbSetFeature();	// ep0 only
;								if (usbSave.ep)
_UsbAddress__2f:
		LDA r0,_usbSave+0xe
		BREQ _UsbConfig ;(+48)
;									{
;									STALL("~1", "UsbAddress: EP not 0");
		LDI r4,0x1e ;__Lstrings+0x995
		LDI r5,0x45 ;__Lstrings+0x995>>8
		JMP _UsbAddress__3f
;									UsbProvideRxBDT(TRUE);			// release the RX BDT again now that we're done
;									return;
;									}
;								break;
;
;					case  7:	//UsbSetDescription();
;					case 10:	//UsbGetInterface();
;					case 11:	//UsbSetInterface();
;					case 12:	//UsbSynchFrame();
;								STALL("~2", "UsbAddress: bad request");
_UsbAddress__3b:
		LDI r4,0xee ;__Lstrings+0x565
		LDI r5,0x40 ;__Lstrings+0x565>>8
_UsbAddress__3f:
		JSR _UsbStall
;								UsbProvideRxBDT(TRUE);			// release the RX BDT again now that we're done
		LDI r4,0x01
		JMP _UsbProvideRxBDT
_UsbAddress__47:
		LDA r0,_setup+0x1
		BREQ _UsbAddress__2f ;(-1d)
		DEC r0
		BREQ _UsbAddress__2f ;(-20)
		DEC r0
		DEC r0
		BREQ _UsbAddress__2f ;(-24)
		LDI r4,0xfc
		ADD r4
		BREQ _UsbAddress__3b ;(-1d)
		LDI r4,0xfd
		ADD r4
		BREQ _UsbAddress__3b ;(-22)
		DEC r0
		BREQ _UsbAddress__3b ;(-25)
		DEC r0
		BREQ _UsbAddress__3b ;(-28)
		JMP _UsbConfig
_UsbAddress__66:
		LDI r1,0x60
		LDA r0,_setup
		AND r1
		LDI r1,0x00
		BREQ _UsbAddress__77 ;(+07)
_UsbAddress__70:
		TX0 r1
		OR  r1
		BREQ _UsbAddress__47 ;(-2d)
		JMP _UsbConfig
_UsbAddress__77:
		PSH r0
		TX0 r1
		POP r1
		BREQ _UsbAddress__70 ;(-0c)
;								return;
;					}
;			}
;		}
;
;	UsbConfig();
;	return;
;}
;
;void UsbConfig()
;{
;	// In all cases we have to basically fully respond to all packet types
;	// at least on EP0.
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_RESET)
_UsbConfig:
		LDA r0,_usbSave+0xd
		BTT Z
		BREQ _UsbConfig__f ;(+09)
;		{	// Bus reset, we don't process any of the other
;			// interrupts, just reset the interface!
;		UsbPowered();
		JSR _UsbPowered
;		usb.intStatus = 0xff;	// clear all interrupts
		LDI r0,0xff
		STA r0,_usb
;		return;
		RTS
;		}
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
_UsbConfig__f:
		LDA r0,_usbSave+0xd
		BTT I
		BREQ _UsbConfig__6b ;(+56)
;		{
;#if DEBUG_PBDT
;puts("UsbConfig: usbSave.pBDT=");
;putw((WORD)usbSave.pBDT);
;puts("->");
;putbs(cBDT.pid);
;putbs(cBDT.bc);
;puto(cBDT.addr);
;putCrlf();
;#endif
;
;		if (cBDT.pid & 0x80)	// you don't own me, i'm not one of your pretty toys
		LDA r0,_cBDT
		BRPL _UsbConfig__46 ;(+2c)
;			{
;			PUTS("~3", "UsbConfig: BDT owned by host\r\n\a");
		LDI r4,0x6c ;__Lstrings+0x9e3
		LDI r5,0x45 ;__Lstrings+0x9e3>>8
		JSR _puts
;			}
;
;		switch (usbSave.status >> 4)	// switch based on endpoint number
		JMP _UsbConfig__46
;			{
;			case 0:
;						{
;						if (!IS_TOKEN_IN)
_UsbConfig__24:
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x24
		CMP r1
		BREQ _UsbConfig__34 ;(+05)
;							UsbProvideRxBDT(TRUE);			// release the RX BDT again now that we're done
		LDI r4,0x01
		JSR _UsbProvideRxBDT
;
;#if DEBUG_EP0
;		// verbose for simulator/v8time
;						if (IS_TOKEN_IN)
;							UsbTokenDoneEP0in();
;						else if (IS_TOKEN_SETUP)
;							UsbTokenDoneEP0setup();
;						else if (IS_TOKEN_OUT)
;							UsbTokenDoneEP0out();
;						else
;							UsbTokenDoneEP0other();
;#else
;						UsbTokenDoneEP0();
_UsbConfig__34:
		JSR _UsbTokenDoneEP0
;#endif
;						}
;						break;
		JMP _UsbConfig__6b
;
;#if WANT_SOUND
;			case ENDPOINT_SPEAKER:
;						UsbTokenDoneEP1_Speaker();
_UsbConfig__3a:
		JSR _UsbTokenDoneEP1_Speaker
;						break;
		JMP _UsbConfig__6b
;#endif // WANT_SOUND
;#if WANT_PRINTER
;			case ENDPOINT_PRINTER:
;						UsbTokenDoneEP3();
_UsbConfig__40:
		JSR _UsbTokenDoneEP3
;						break;
		JMP _UsbConfig__6b
_UsbConfig__46:
		LDA r0,_usbSave+0x4
		CLP C
		ROR r0
		CLP C
		ROR r0
		CLP C
		ROR r0
		CLP C
		ROR r0
		LDI r1,0x00
		BREQ _UsbConfig__63 ;(+0e)
_UsbConfig__55:
		TX0 r1
		OR  r1
		BREQ _UsbConfig__24 ;(-35)
		DEC r0
		BREQ _UsbConfig__3a ;(-22)
		DEC r0
		DEC r0
		BREQ _UsbConfig__40 ;(-20)
		JMP _UsbConfig__68
_UsbConfig__63:
		PSH r0
		TX0 r1
		POP r1
		BREQ _UsbConfig__55 ;(-13)
;#endif
;#if WANT_HUB
;			case ENDPOINT_HUB:
;						HubTokenDoneEPhub();
;						break;
;#endif
;			default:	UsbTokenDoneEPn();
_UsbConfig__68:
		JSR _UsbTokenDoneEPn
;						break;
;			}
;		}
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_STALL)
_UsbConfig__6b:
		LDA r0,_usbSave+0xd
		BRPL _UsbConfig__79 ;(+09)
;		USB_ERROR_STAT.bits.stall = 1;
		LDA r0,_USB_ERROR_STAT+0x1
		LDI r1,0x08
		OR  r1
		STA r0,_USB_ERROR_STAT+0x1
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_SOF)
_UsbConfig__79:
		LDA r0,_usbSave+0xd
		BTT N
		BREQ _UsbConfig__82 ;(+03)
;		UsbSofDet();
		JSR _UsbSofDet
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_SLEEP)
_UsbConfig__82:
		LDA r0,_usbSave+0xd
		BTT 4
		BREQ _UsbConfig__8b ;(+03)
;		UsbSleep();
		JSR _UsbSleep
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_RESUME)
_UsbConfig__8b:
		LDA r0,_usbSave+0xd
		BTT 5
		BREQ _UsbConfig__94 ;(+03)
;		UsbResume();
		JSR _UsbResume
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_ERROR)
_UsbConfig__94:
		LDA r0,_usbSave+0xd
		BTT C
;		UsbError();
		BREQ _UsbConfig__9d ;(+03)
		JMP _UsbError
;
;// <<<<<<<<<<Primary EXIT point for the USB Interrupt Service>>>>>>>>>
;	return;
_UsbConfig__9d:
		RTS
;}
;
;void UsbProvideRxBDT(BOOL bOther)
;{
;	static ONION	onion;
;	BYTE			ep;
;
;	onion.pBDT = usbSave.pBDT;		// get current BDT into onion
_UsbProvideRxBDT:
		LDA r0,_usbSave+0x10
		STA r0,_usb_target_psr+0x4
		LDA r0,_usbSave+0xf
		STA r0,_usb_target_psr+0x3
;	ep = usbSave.ep;
		LDA r5,_usbSave+0xe
;
;	// if this BDT belongs to a control endpoint, provide the other BDT.
;	if (ENDPT_RG[ep] == ENDPT_CONTROL)
		LDI r2,0x90 ;_ENDPT_HOST_RG
		LDI r3,0x02 ;_ENDPT_HOST_RG>>8
		TX0 r5
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		LDI r1,0x0d
		XOR r1
		BRNE _UsbProvideRxBDT__45 ;(+24)
;		{
;		if (!bExtraRxBDT[ep])
		LDI r2,0x2f ;_bExtraRxBDT
		LDI r3,0x48 ;_bExtraRxBDT>>8
		TX0 r5
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		BRNE _UsbProvideRxBDT__39 ;(+09)
;			onion.b.l ^= 0x04;	// point to other BDT
		LDI r1,0x04
		LDA r0,_usb_target_psr+0x3
		XOR r1
		STA r0,_usb_target_psr+0x3
;
;		if (onion.pBDT->pid & 0x80)
_UsbProvideRxBDT__39:
		LDA r2,_usb_target_psr+0x3
		LDA r3,_usb_target_psr+0x4
		LDX r2
		BRPL _UsbProvideRxBDT__4b ;(+09)
		JMP _UsbProvideRxBDT__7d
;			goto please_sir_may_i_have_another;	// been there done that
;		}
;	else
;		{
;		if (cBDT.pid & 0x80)
_UsbProvideRxBDT__45:
		LDA r0,_cBDT
		BRPL _UsbProvideRxBDT__4b ;(+01)
		RTS
;			return;	// been there done that
;		}
;
;//	onion.pBDT->addr.w ^= 0x0040;
;	onion.pBDT->bc = 64;			// reset the byte count to 64 bytes
_UsbProvideRxBDT__4b:
		LDI r0,0x40
		LDA r2,_usb_target_psr+0x3
		LDA r3,_usb_target_psr+0x4
		STO r2,0x01
;	onion.pBDT->pid = 0x88 | RECV_DATA01[ep];	// change OWN back to the VUSB (provide it)
		LDI r2,0x59 ;_RECV_DATA01
		LDI r3,0x4e ;_RECV_DATA01>>8
		TX0 r5
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		LDI r1,0x88
		OR  r1
		LDA r2,_usb_target_psr+0x3
		LDA r3,_usb_target_psr+0x4
		STX r2
;	RECV_DATA01[ep] ^= 0x40;
		LDI r1,0x40
		PSH r5
		POP r2
		LDI r3,0x00
		LDI r0,0x59
		ADD r2
		T0X r2
		LDI r0,0x4e
		ADC r3
		T0X r3
		LDX r2
		XOR r1
		STX r2
;
;please_sir_may_i_have_another:
;
;	if (bOther && !bExtraRxBDT[ep])
_UsbProvideRxBDT__7d:
		TX0 r4
		BREQ _UsbProvideRxBDT__df ;(+5f)
		LDI r2,0x2f ;_bExtraRxBDT
		LDI r3,0x48 ;_bExtraRxBDT>>8
		TX0 r5
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		BRNE _UsbProvideRxBDT__df ;(+50)
;		{
;		bExtraRxBDT[ep] = TRUE;	// make note that we've provided an extra rx BDT
		LDI r2,0x2f ;_bExtraRxBDT
		LDI r3,0x48 ;_bExtraRxBDT>>8
		TX0 r5
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r0,0x01
		STX r2
;
;		onion.b.l ^= 0x04;	// point to other BDT
		LDI r1,0x04
		LDA r0,_usb_target_psr+0x3
		XOR r1
		STA r0,_usb_target_psr+0x3
;
;		if (onion.pBDT->pid & 0x80)
		T0X r2
		LDA r3,_usb_target_psr+0x4
		LDX r2
		BRPL _UsbProvideRxBDT__ad ;(+01)
		RTS
;			return;	// we've already provided this buffer... we're done
;
;//		onion.pBDT->addr.w ^= 0x0040;
;		onion.pBDT->bc = 64;			// reset the byte count to 64 bytes
_UsbProvideRxBDT__ad:
		LDI r0,0x40
		LDA r2,_usb_target_psr+0x3
		LDA r3,_usb_target_psr+0x4
		STO r2,0x01
;		onion.pBDT->pid = 0x88 | RECV_DATA01[ep];	// change OWN back to the VUSB (provide it)
		LDI r2,0x59 ;_RECV_DATA01
		LDI r3,0x4e ;_RECV_DATA01>>8
		TX0 r5
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		LDI r1,0x88
		OR  r1
		LDA r2,_usb_target_psr+0x3
		LDA r3,_usb_target_psr+0x4
		STX r2
;		RECV_DATA01[ep] ^= 0x40;
		LDI r1,0x40
		PSH r5
		POP r2
		LDI r3,0x00
		LDI r0,0x59
		ADD r2
		T0X r2
		LDI r0,0x4e
		ADC r3
		T0X r3
		LDX r2
		XOR r1
		STX r2
;		}
;
;	return;
;}
_UsbProvideRxBDT__df:
		RTS
;
;void UsbSofDet()
;{
;	static ONION	expected;
;	static ONION	got;
;
;//putc('$');
;	expected.w = (USB_SOF_CTR + 1) & 0x07ff;	// 11 bits
_UsbSofDet:
		LDI r2,0xff ;_modify__140
		LDI r3,0x07 ;_modify__140>>8
		LDA r4,_USB_SOF_CTR
		LDA r5,_USB_SOF_CTR+0x1
		UPP r4
		TX0 r4
		AND r2
		T0X r2
		TX0 r5
		AND r3
		T0X r3
		STA r3,_usb_target_psr+0x6
		STA r2,_usb_target_psr+0x5
;
;	got.b.h = usbSave.frameNumHi;
		LDA r0,_usbSave+0x9
		STA r0,_usb_target_psr+0x8
;	got.b.l = usbSave.frameNumLo;
		LDA r0,_usbSave+0x8
		STA r0,_usb_target_psr+0x7
;	if (got.w != expected.w)
		LDA r1,_usb_target_psr+0x8
		XOR r2
		BRNE _UsbSofDet__2d ;(+04)
		TX0 r3
		XOR r1
		BREQ _UsbSofDet__39 ;(+0c)
;		{
;#if DEBUG_SOF_MISSES
;#if WANT_HARDWARE && !WANT_LITE
;		if (debug.bits.SofErrors)
;#endif
;			{
;			puts("SOF ");
;			puto(expected);
;			puts("!=");
;			puto(got);
;			putCrlf();
;			}
;#endif // DEBUG_SOF_MISSES
;		expected.w = got.w;	// use actual as next expected
_UsbSofDet__2d:
		LDA r0,_usb_target_psr+0x8
		STA r0,_usb_target_psr+0x6
		LDA r0,_usb_target_psr+0x7
		STA r0,_usb_target_psr+0x5
;		}
;	USB_SOF_CTR = expected.w;
_UsbSofDet__39:
		LDA r0,_usb_target_psr+0x6
		STA r0,_USB_SOF_CTR+0x1
		LDA r0,_usb_target_psr+0x5
		STA r0,_USB_SOF_CTR
;	return;
		RTS
;}
;
;void UsbSleep()
;{
;	// not entirely implemented
;	
;	USB_ERROR_STAT.bits.sleep = 1;
_UsbSleep:
		LDA r0,_USB_ERROR_STAT+0x1
		LDI r1,0x01
		OR  r1
		STA r0,_USB_ERROR_STAT+0x1
;
;	if (!(usbSave.intStatus & INT_STAT_MASK_RESUME))
		LDA r0,_usbSave
		BTT 5
		BRNE _UsbResume ;(+19)
;		{
;		current_pwr_save_status = pwr_save_status;
		LDA r0,_pwr_save_status
		STA r0,_current_pwr_save_status
;		if (current_pwr_save_status.asleep)
		BTT Z
		BREQ _UsbResume ;(+10)
;			{
;			pwr_save_polarity = pwr_save_status;
		LDA r0,_pwr_save_status
		STA r0,_pwr_save_polarity
;			*(PBYTE)&pwr_save_enable = 0x41;	// tms, hub_asleep
		LDI r0,0x41
		STA r0,_pwr_save_enable
;			*(PBYTE)&pwr_save_control = 0x02;	// sleep
		LDI r0,0x02
		STA r0,_pwr_save_control
;
;			asm("or r0");	// NOP
;			asm("or r0");	// NOP
;			}
;		}
;
;}
;
;void UsbResume()
;{
_UsbResume:
		RTS
;	// not implemented
;}
;
;void UsbError()
;{
;	static BYTE	b, bError;
;	static BYTE	bm;
;	static PWORD	pw;
;
;	bError = usbSave.errorStatus;
_UsbError:
		LDA r0,_usbSave+0x2
		STA r0,_UART_NEXT+0x3
;	usb.errorStatus = bError;	// clear error bits
		STA r0,_usb+0x2
;	bError &= usb.errorEnable;	// mask off ones we are ignoring
		LDA r1,_usb+0x3
		LDA r0,_UART_NEXT+0x3
		AND r1
		STA r0,_UART_NEXT+0x3
;
;#if 1
;putc('*');
		LDI r4,0x2a
		JSR _putc
;putb(bError);
		LDA r4,_UART_NEXT+0x3
		JSR _putb
;#endif
;
;	USB_ERROR_STAT.b[0] |= bError;	// add bits
		LDA r1,_UART_NEXT+0x3
		LDA r0,_USB_ERROR_STAT
		OR  r1
		STA r0,_USB_ERROR_STAT
;
;	pw = USB_ERROR_CTR;
		LDI r0,0x4e
		STA r0,_usb_target_psr+0xa
		LDI r0,0x65
		STA r0,_usb_target_psr+0x9
;	for (b=0, bm=1; b<8; b++, bm<<=1)
		XOR r0
		STA r0,_UART_NEXT+0x2
		LDI r0,0x01
		STA r0,_UART_NEXT+0x4
		LDI r1,0x08
		LDA r0,_UART_NEXT+0x2
		CMP r1
		BRCS _UsbError__80 ;(+3d)
;		{
;		if (bError & bm)
_UsbError__43:
		LDA r1,_UART_NEXT+0x4
		LDA r0,_UART_NEXT+0x3
		AND r1
		BREQ _UsbError__5c ;(+10)
;			pw[0]++;
		LDA r2,_usb_target_psr+0x9
		LDA r3,_usb_target_psr+0xa
		LDX r2
		INC r0
		STX r2
		BRCC _UsbError__5c ;(+05)
		LDO r2,0x01
		INC r0
		STO r2,0x01
;		pw++;
_UsbError__5c:
		LDA r0,_usb_target_psr+0x9
		LDA r1,_usb_target_psr+0xa
		UPP r0
		UPP r0
		STA r0,_usb_target_psr+0x9
		STA r1,_usb_target_psr+0xa
		LDA r0,_UART_NEXT+0x2
		INC r0
		STA r0,_UART_NEXT+0x2
		LDA r0,_UART_NEXT+0x4
		ADD r0
		STA r0,_UART_NEXT+0x4
		LDI r1,0x08
		LDA r0,_UART_NEXT+0x2
		CMP r1
		BRCC _UsbError__43 ;(-3d)
;		}
;
;	if (USB_DEBUG & 0x80)
_UsbError__80:
		LDA r0,_USB_DEBUG
		BRPL _UsbError__95 ;(+10)
;		{
;		puts("\aError:");
		LDI r4,0xc0 ;__Lstrings+0x937
		LDI r5,0x44 ;__Lstrings+0x937>>8
		JSR _puts
;		putb(bError);
		LDA r4,_UART_NEXT+0x3
		JSR _putb
;		putCrlf();
		JMP _putCrlf
;		}
;
;	return;
_UsbError__95:
		RTS
;}
;
;
;#if DEBUG_REGS_VERBOSE
;void UsbDumpByte(BYTE bStat, BYTE bEnable, PBYTE *p)
;{
;	static BYTE	b, i;
;
;	for (i=0, b=0x80; i<8; i++, b>>=1)
;		{
;		if (bStat & b)
;			{
;			if (bEnable & b)
;				putc('+');
;			else
;				putc('-');
;			puts(p[i]);
;			putSpace();
;			}
;		}
;
;	if (bStat)
;		putCrlf();
;
;	return;
;}
;#endif
;
;#if DEBUG_EP0
;void UsbTokenDoneEP0setup(void)
;{
;	UsbTokenDoneEP0();
;}
;void UsbTokenDoneEP0in(void)
;{
;	UsbTokenDoneEP0();
;}
;void UsbTokenDoneEP0out(void)
;{
;	UsbTokenDoneEP0();
;}
;void UsbTokenDoneEP0other(void)
;{
;	UsbTokenDoneEP0();
;}
;#endif // DEBUG_EP0
;
;void UsbTokenDoneEP0(void)
;{
;
;	if (IS_TOKEN_SETUP)
_UsbTokenDoneEP0:
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbTokenDoneEP0__1d ;(+12)
;		{	// copy the 8 byte Device Request so we don't lose it.
;		memcpy((PBYTE)&setup, cBDT.addr.pb, 8);
		LDI r0,0x08
		STA r0,Aa_UsbVendSetEndPoint
		LDA r2,_cBDT+0x2
		LDA r3,_cBDT+0x3
		LDI r4,0x8a ;_setup
		LDI r5,0x4e ;_setup>>8
		JSR _memcpy
;		}
;
;	if (setup.bRequestType == 0xff)
_UsbTokenDoneEP0__1d:
		LDI r1,0xff
		LDA r0,_setup
		XOR r1
		BRNE _UsbTokenDoneEP0__75 ;(+50)
;		{
;		UsbEchoEP();
		JMP _UsbEchoEP
;		return;
;		}
;
;	switch (setup.bRequestType & 0x60)
;		{
;		case 0x00:
;			switch (setup.bRequest)
_UsbTokenDoneEP0__28:
		LDA r0,_setup+0x1
		BRNE _UsbTokenDoneEP0__30 ;(+03)
		JMP _UsbGetStatus__9c
_UsbTokenDoneEP0__30:
		DEC r0
		BRNE _UsbTokenDoneEP0__36 ;(+03)
		JMP _UsbClearFeature
_UsbTokenDoneEP0__36:
		DEC r0
		DEC r0
		BRNE _UsbTokenDoneEP0__3d ;(+03)
		JMP _UsbSetFeature
_UsbTokenDoneEP0__3d:
		DEC r0
		DEC r0
		BRNE _UsbTokenDoneEP0__44 ;(+03)
		JMP _UsbSetAddress
_UsbTokenDoneEP0__44:
		DEC r0
		BRNE _UsbTokenDoneEP0__4a ;(+03)
		JMP _UsbGetDescription
_UsbTokenDoneEP0__4a:
		DEC r0
		BRNE _UsbTokenDoneEP0__50 ;(+03)
		JMP _UsbSetDescription
_UsbTokenDoneEP0__50:
		DEC r0
		BRNE _UsbTokenDoneEP0__56 ;(+03)
		JMP _UsbGetConfig
_UsbTokenDoneEP0__56:
		DEC r0
		BRNE _UsbTokenDoneEP0__5c ;(+03)
		JMP _UsbSetConfig
_UsbTokenDoneEP0__5c:
		DEC r0
		BRNE _UsbTokenDoneEP0__62 ;(+03)
		JMP _UsbGetInterface
_UsbTokenDoneEP0__62:
		DEC r0
		BRNE _UsbTokenDoneEP0__68 ;(+03)
		JMP _UsbSetInterface
_UsbTokenDoneEP0__68:
		DEC r0
		BRNE _UsbTokenDoneEP0__6e ;(+03)
		JMP _UsbSynchFrame
;				{
;				case  0:	UsbGetStatus();		return;
;				case  1:	UsbClearFeature();	return;
;				case  3:	UsbSetFeature();		return;
;				case  5:	UsbSetAddress();		return;
;				case  6:	UsbGetDescription();	return;
;				case  7:	UsbSetDescription();	return;
;				case  8:	UsbGetConfig();		return;
;				case  9:	UsbSetConfig();		return;
;				case 10:	UsbGetInterface();	return;
;				case 11:	UsbSetInterface();	return;
;				case 12:	UsbSynchFrame();		return;
;				}
;
;			STALL("~36", "UsbTokenDoneEP0: bad bRequest");
_UsbTokenDoneEP0__6e:
		LDI r4,0x1e ;__Lstrings+0x595
		LDI r5,0x41 ;__Lstrings+0x595>>8
		JMP _UsbStall
_UsbTokenDoneEP0__75:
		LDI r1,0x60
		LDA r0,_setup
		AND r1
		LDI r1,0x00
		BREQ _UsbTokenDoneEP0__96 ;(+17)
_UsbTokenDoneEP0__7f:
		TX0 r1
		OR  r1
		BREQ _UsbTokenDoneEP0__28 ;(-5b)
		LDI r4,0xe0
		ADD r4
		BRNE _UsbTokenDoneEP0__8b ;(+03)
		JMP _PrinterClassSetup
_UsbTokenDoneEP0__8b:
		LDI r4,0xe0
		ADD r4
		BRNE _UsbTokenDoneEP0__93 ;(+03)
		JMP _UsbVendor__4
_UsbTokenDoneEP0__93:
		JMP _UsbTokenDoneEP0__9b
_UsbTokenDoneEP0__96:
		PSH r0
		TX0 r1
		POP r1
		BREQ _UsbTokenDoneEP0__7f ;(-1c)
;			return;
;		case 0x20:
;#if WANT_HUB
;			HubClassSetup();
;#endif
;#if WANT_PRINTER
;			PrinterClassSetup();
;#endif
;			return;
;		case 0x40:
;			UsbVendor();
;			return;
;		}
;
;	STALL("~37", "UsbTokenDoneEP0: bad bRequestType");
_UsbTokenDoneEP0__9b:
		LDI r4,0x54 ;__Lstrings+0x6cb
		LDI r5,0x42 ;__Lstrings+0x6cb>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbGetStatus(void)
;{
_UsbGetStatus:
		JMP _UsbGetStatus__9c
;//	wValue=Zero
;//	wIndex=Zero
;//	wLength=1
;//	DATA=bmERR_STAT
;//	The GET_STATUS command is used to read the bmERR_STAT register.
;
;// Return the status based on the bRrequestType bits:
;// device (0) = bit 0 = 1 = self powered
;//              bit 1 = 0 = DEVICE_REMOTE_WAKEUP which can be modified
;//			with a SET_FEATURE/CLEAR_FEATURE command.
;// interface(1) = 0000.
;// endpoint(2) = bit 0 = stall.
;	static PBYTE	pData;
;
;	switch (cBDT.pid & 0x7c)
;		{
;		case 0x34:	// SETUP
;			if (setup.bRequestType == 0x80)			// device req
_UsbGetStatus__3:
		LDI r1,0x80
		LDA r0,_setup
		XOR r1
		BRNE _UsbGetStatus__18 ;(+0d)
;				{
;				pData = (PBYTE)&USB_STATUS_DEVICE;
		LDI r0,0x48
		STA r0,_usb_target_psr+0xc
		LDI r0,0x43
		STA r0,_usb_target_psr+0xb
;#if DEBUG_USB_STATUS_DEVICE
;	puts("UsbGetStatus: USB_STATUS_DEVICE=");
;	putb(USB_STATUS_DEVICE);
;	putCrlf();
;#endif //DEBUG_USB_STATUS_DEVICE
;				}
		JMP _UsbGetStatus__72
;			else if (setup.bRequestType == 0x81)	// interface req
_UsbGetStatus__18:
		LDI r1,0x81
		LDA r0,_setup
		XOR r1
		BRNE _UsbGetStatus__33 ;(+13)
;				{
;				USB_STATUS_INTERFACE = 0;
		STA r0,_USB_DEBUG+0xb
		STA r0,_USB_DEBUG+0xa
;				pData = (PBYTE)&USB_STATUS_INTERFACE;
		LDI r0,0x48
		STA r0,_usb_target_psr+0xc
		LDI r0,0x45
		STA r0,_usb_target_psr+0xb
;				}
		JMP _UsbGetStatus__72
;			else if (setup.bRequestType == 0x82)	// endpoint req
_UsbGetStatus__33:
		LDI r1,0x82
		LDA r0,_setup
		CMP r1
		BRNE _UsbGetStatus__6b ;(+30)
;				{
;				if (ENDPT_RG[setup.wIndex.b.l & 0x0f] & ENDPT_STALL_BIT)
		LDI r2,0x90 ;_ENDPT_HOST_RG
		LDI r3,0x02 ;_ENDPT_HOST_RG>>8
		LDI r1,0x0f
		LDA r0,_setup+0x4
		AND r1
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		BTT C
		BREQ _UsbGetStatus__57 ;(+07)
;					{
;					USB_STATUS_ENDPOINT = 1;
		XOR r0
		STA r0,_USB_DEBUG+0xd
		INC r0
		BRNE _UsbGetStatus__5b ;(+04)
;					}
;				else
;					USB_STATUS_ENDPOINT = 0;
_UsbGetStatus__57:
		XOR r0
		STA r0,_USB_DEBUG+0xd
_UsbGetStatus__5b:
		STA r0,_USB_DEBUG+0xc
;				pData = (PBYTE)&USB_STATUS_ENDPOINT;
		LDI r0,0x48
		STA r0,_usb_target_psr+0xc
		LDI r0,0x47
		STA r0,_usb_target_psr+0xb
;				}
		JMP _UsbGetStatus__72
;			else							// unknown req
;				{
;				STALL("~38", "UsbGetStatus BAD own");
_UsbGetStatus__6b:
		LDI r4,0x6c ;__Lstrings+0x5e3
		LDI r5,0x41 ;__Lstrings+0x5e3>>8
		JMP _UsbStall
;				return;
;				}
;
;			UsbSendIn(0xc0, 2, pData, TRUE);
_UsbGetStatus__72:
		LDA r0,_usb_target_psr+0xc
		STA r0,A_UsbSendIn+0x1
		LDA r0,_usb_target_psr+0xb
		JMP _UsbVendGetStatus__1c
;			break;
;
;		case 0x64:	// IN
;			return;
_UsbGetStatus__7e:
		RTS
_UsbGetStatus__7f:
		TX0 r1
		LDI r4,0xcc
		ADD r4
		BRNE _UsbGetStatus__88 ;(+03)
		JMP _UsbGetStatus__3
_UsbGetStatus__88:
		LDI r4,0xf0
		ADD r4
		BRNE _UsbGetStatus__90 ;(+03)
		JMP _PrinterClassSetup__ef
_UsbGetStatus__90:
		LDI r4,0xe0
		ADD r4
		BREQ _UsbGetStatus__7e ;(-17)
;
;		case 0x44:	// OUT
;			// invalidate bReqestType so we know we are done
;			setup.bRequestType = 0xff;
;			break;
;
;		default:
;			STALL("~4", "UsbGetStatus: Bad PID");
_UsbGetStatus__95:
		LDI r4,0x11 ;__Lstrings+0x888
		LDI r5,0x44 ;__Lstrings+0x888>>8
		JMP _UsbStall
_UsbGetStatus__9c:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x00
		PSH r0
		TX0 r1
		POP r1
		BREQ _UsbGetStatus__7f ;(-2a)
		JMP _UsbGetStatus__95
;			return;
;		}
;
;}
;
;void UsbClearFeature(void)
;{
;	BYTE	ep, i;
;	ONION	onion;
;	PBDT	pBDT;
;
;	if (IS_TOKEN_SETUP_DATA0)
_UsbClearFeature:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BREQ _UsbClearFeature__e ;(+03)
		JMP _UsbClearFeature__1a4
;		{
;		if (setup.bRequestType == 0)	// DEVICE
_UsbClearFeature__e:
		LDA r0,_setup
		BRNE _UsbClearFeature__38 ;(+25)
;			{
;			if (setup.wValue.w == 1)	// REMOTE WAKEUP
		LDA r0,_setup+0x3
		LDA r1,_setup+0x2
		DEC r1
		OR  r1
		BREQ _UsbClearFeature__20 ;(+03)
		JMP _UsbSendInZero
;				{
;				bRemoteWakeupEnabled = FALSE;
_UsbClearFeature__20:
		STA r0,_bRemoteWakeupEnabled
;	#if WANT_HUB
;				HubClearDeviceFeature();
;	#endif
;
;				USB_STATUS_DEVICE &= 0xfd;	// clear bit 1 - REMOTE WAKEUP
		LDA r0,_USB_DEBUG+0x8
		LDI r1,0xfd
		AND r1
		STA r0,_USB_DEBUG+0x8
		LDA r0,_USB_DEBUG+0x9
		LDI r1,0x00
		XOR r0
		STA r0,_USB_DEBUG+0x9
;	#if DEBUG_USB_STATUS_DEVICE
;		puts("UsbClearFeature: USB_STATUS_DEVICE=");
;		putb(USB_STATUS_DEVICE);
;		putCrlf();
;	#endif //DEBUG_USB_STATUS_DEVICE
;				}
;			}
		JMP _UsbSendInZero
;		else							// NOT DEVICE
;			{
;			if (setup.bRequestType != 2)
_UsbClearFeature__38:
		LDI r1,0x02
		LDA r0,_setup
		CMP r1
		BREQ _UsbClearFeature__47 ;(+07)
;				{
;				STALL("~6", "UsbClearFeature: not CLR_ENDPOINT");
		LDI r4,0xbf ;__Lstrings+0x836
		LDI r5,0x43 ;__Lstrings+0x836>>8
		JMP _UsbStall
;				return;
;				}
;			if (setup.wValue.w)
_UsbClearFeature__47:
		LDA r0,_setup+0x2
		LDA r1,_setup+0x3
		OR  r1
		BREQ _UsbClearFeature__57 ;(+07)
;				{
;				STALL("~7", "UsbClearFeature: wValue not 0");
		LDI r4,0x00 ;__Lstrings+0x977
		LDI r5,0x45 ;__Lstrings+0x977>>8
		JMP _UsbStall
;				return;
;				}
;
;			ep = setup.wIndex.b.l & 0x0f;
_UsbClearFeature__57:
		LDI r1,0x0f
		LDA r0,_setup+0x4
		AND r1
		T0X r5
;
;			onion.bdt.page = usbSave.bdtPage;
		LDA r1,_usbSave+0x7
		LDI r0,0xff
		AND r1
		T0X r2
		LDA r0,Aa_HostSetNextInBdt
		XOR r0
		OR  r2
		STA r0,Aa_HostSetNextInBdt
;			onion.b.l = 0;	// clear zero, odd, out
		XOR r0
		STA r0,Aa_UartReadString+0x1
;			onion.bdt.ep = ep;
		TX0 r5
		T0X r2
		LDI r0,0x0f
		AND r2
		T0X r2
		LDA r0,Aa_UartReadString+0x1
		ROR r0
		ROR r0
		ROR r0
		ROR r0
		LDI r1,0xf0
		AND r1
		OR  r2
		ROL r0
		ROL r0
		ROL r0
		ROL r0
		STA r0,Aa_UartReadString+0x1
;
;			bExtraRxBDT[ep] = FALSE;	// there is no longer an extra RX BDT
		LDI r2,0x2f ;_bExtraRxBDT
		LDI r3,0x48 ;_bExtraRxBDT>>8
		TX0 r5
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		XOR r0
		STX r2
		STA r5,Aa_UsbVendSetEndPoint
;
;			for (i=0; i<4; i++)
		LDI r4,0x00
;				{
;	#if DEBUG_DEQUEUE
;				if (onion.pBDT->pid & 0x80)
;					{
;					puto(onion);
;					puts(" - dequeueing\r\n");
;					}
;	#endif // DEBUG_DEQUEUE
;				onion.pBDT->pid = 0x00;
_UsbClearFeature__9c:
		XOR r0
		LDA r2,Aa_UartReadString+0x1
		LDA r3,Aa_HostSetNextInBdt
		STX r2
;				onion.pBDT->bc = 0;
		XOR r0
		STO r2,0x01
;
;		// there's no point in clearing the address, provideRxBDT would just have to set it again
;		//		onion.pBDT->addr.w = 0;
;				onion.pBDT++;
		TX0 r2
		LDI r1,0x04
		ADD r1
		STA r0,Aa_UartReadString+0x1
		TX0 r3
		LDI r1,0x00
		ADC r1
		STA r0,Aa_HostSetNextInBdt
		INC r4
		LDI r1,0x04
		TX0 r4
		CMP r1
		BRCC _UsbClearFeature__9c ;(-20)
;				}
;
;			USB_NEXT_OUT[ep] = USB_LAST_OUT[ep] + 1;
		LDI r2,0x86 ;_USB_NEXT_OUT
		LDI r3,0x4e ;_USB_NEXT_OUT>>8
		LDA r0,Aa_UsbVendSetEndPoint
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r4,0x7e ;_USB_LAST_OUT
		LDI r5,0x4e ;_USB_LAST_OUT>>8
		LDA r0,Aa_UsbVendSetEndPoint
		ADD r4
		T0X r4
		TX0 r1
		ADC r5
		T0X r5
		LDX r4
		INC r0
		STX r2
;
;			onion.bdt.page = usbSave.bdtPage;
		LDA r1,_usbSave+0x7
		LDI r0,0xff
		AND r1
		T0X r2
		LDA r0,Aa_HostSetNextInBdt
		XOR r0
		OR  r2
		STA r0,Aa_HostSetNextInBdt
;			onion.b.l = 0;	// clear zero, odd, out
		XOR r0
		STA r0,Aa_UartReadString+0x1
;			onion.bdt.ep = ep;
		LDA r2,Aa_UsbVendSetEndPoint
		LDI r0,0x0f
		AND r2
		T0X r2
		LDA r0,Aa_UartReadString+0x1
		ROR r0
		ROR r0
		ROR r0
		ROR r0
		LDI r1,0xf0
		AND r1
		OR  r2
		ROL r0
		ROL r0
		ROL r0
		ROL r0
		STA r0,Aa_UartReadString+0x1
;			pBDT = &onion.pBDT[0];
		T0X r4
		LDA r5,Aa_HostSetNextInBdt
;
;			pBDT[0].bc = 0xff;
		LDI r0,0xff
		STO r4,0x01
;			pBDT[1].bc = 0xff;
		LDI r0,0xff
		STO r4,0x05
;			pBDT[0].addr.w = (WORD)USB_EPn_BUFFER0;
		LDI r0,0x78
		STO r4,0x03
		LDI r0,0x00
		STO r4,0x02
;			pBDT[1].addr.w = (WORD)USB_EPn_BUFFER1;
		LDI r0,0x7c
		STO r4,0x07
		LDI r0,0x00
		STO r4,0x06
		STA r4,Aa_UsbVendSetEndPoint+0x1
		STA r5,Aa_UartReadString
;
;			pBDT[USB_NEXT_OUT[ep]&1].pid = 0x8b;		// OWN=1, DTS=1, BCH=3
		LDA r2,Aa_UsbVendSetEndPoint+0x1
		LDA r3,Aa_UartReadString
		LDI r4,0x86 ;_USB_NEXT_OUT
		LDI r5,0x4e ;_USB_NEXT_OUT>>8
		LDA r0,Aa_UsbVendSetEndPoint
		LDI r1,0x00
		ADD r4
		T0X r4
		TX0 r1
		ADC r5
		T0X r5
		LDX r4
		LDI r1,0x01
		AND r1
		LDI r1,0x00
		ADD r0
		ROL r1
		ADD r0
		ROL r1
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r0,0x8b
		STX r2
;			pBDT[!(USB_NEXT_OUT[ep]&1)].pid = 0xcb;	// OWN=1, DATA01=1, DTS=1, BCH=3
		LDA r2,Aa_UsbVendSetEndPoint+0x1
		LDA r3,Aa_UartReadString
		LDI r4,0x86 ;_USB_NEXT_OUT
		LDI r5,0x4e ;_USB_NEXT_OUT>>8
		LDA r0,Aa_UsbVendSetEndPoint
		LDI r1,0x00
		ADD r4
		T0X r4
		TX0 r1
		ADC r5
		T0X r5
		LDX r4
		BTT Z
		BRNE _UsbClearFeature__169 ;(+04)
		LDI r0,0x01
		BRNE _UsbClearFeature__16a ;(+01)
_UsbClearFeature__169:
		XOR r0
_UsbClearFeature__16a:
		LDI r1,0x00
		ADD r0
		ROL r1
		ADD r0
		ROL r1
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r0,0xcb
		STX r2
;
;			RECV_DATA01[ep] = 0x00;
		LDA r4,Aa_UsbVendSetEndPoint
		LDI r2,0x59 ;_RECV_DATA01
		LDI r3,0x4e ;_RECV_DATA01>>8
		TX0 r4
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		XOR r0
		STX r2
;
;			ENDPT_RG[ep] &= ~ENDPT_STALL_BIT;	// clear stall bit
		LDI r1,0xfd
		PSH r4
		POP r2
		LDI r3,0x00
		LDI r0,0x90
		ADD r2
		T0X r2
		LDI r0,0x02
		ADC r3
		T0X r3
		LDX r2
		AND r1
		STX r2
;
;			SEND_DATA01[ep] = 0x00;	// next in token from this ep will use data0
		LDI r2,0x5d ;_SEND_DATA01
		LDI r3,0x4e ;_SEND_DATA01>>8
		TX0 r4
		LDI r1,0x00
		JMP _UsbVendSetEndPoint__cc
;			}
;
;		UsbSendInZero();	// ack
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbClearFeature__1a4:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbClearFeature__1b2 ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;
;	STALL("~5", "UsbClearFeature: bad own");
_UsbClearFeature__1b2:
		LDI r4,0x53 ;__Lstrings+0x5ca
		LDI r5,0x41 ;__Lstrings+0x5ca>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbSetFeature(void)
;{
;	static PBDT pTxBDT;
;
;	if (!IS_TOKEN_SETUP_DATA0)	// !SETUP DATA0
_UsbSetFeature:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BREQ _UsbSetFeature__1e ;(+13)
;		{
;		if (!IS_TOKEN_IN_DATA1)	// !IN DATA1
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BREQ _UsbSetFeature__1d ;(+07)
;			{
;			STALL("~8", "UsbSetFeature: bad own");
		LDI r4,0x3c ;__Lstrings+0x5b3
		LDI r5,0x41 ;__Lstrings+0x5b3>>8
		JMP _UsbStall
;			return;
;			}
;		return;
_UsbSetFeature__1d:
		RTS
;		}
;
;	if (setup.bRequestType == 0)	// DEVICE
_UsbSetFeature__1e:
		LDA r0,_setup
		BRNE _UsbSetFeature__47 ;(+24)
;		{
;		if (setup.wValue.w == 1)	// REMOTE WAKEUP
		LDA r0,_setup+0x3
		LDA r1,_setup+0x2
		DEC r1
		OR  r1
		BRNE _UsbSetFeature__7c ;(+4f)
;			{
;			bRemoteWakeupEnabled = TRUE;
		LDI r0,0x01
		STA r0,_bRemoteWakeupEnabled
;#if WANT_HUB
;			HubSetDeviceFeature();
;#endif
;
;			USB_STATUS_DEVICE |= 0x02;	// set bit 1 - Remote Wakeup
		LDA r0,_USB_DEBUG+0x8
		LDI r1,0x02
		OR  r1
		STA r0,_USB_DEBUG+0x8
		LDA r0,_USB_DEBUG+0x9
		LDI r1,0x00
		OR  r1
		STA r0,_USB_DEBUG+0x9
;#if DEBUG_USB_STATUS_DEVICE
;	puts("UsbSetFeature: USB_STATUS_DEVICE=");
;	putb(USB_STATUS_DEVICE);
;	putCrlf();
;#endif //DEBUG_USB_STATUS_DEVICE
;			}
;		}
		JMP _UsbSetFeature__7c
;	else							// NOT DEVICE
;		{
;		if (setup.bRequestType != 2)
_UsbSetFeature__47:
		LDI r1,0x02
		LDA r0,_setup
		CMP r1
		BREQ _UsbSetFeature__56 ;(+07)
;			{
;			STALL("~9", "UsbSetFeature: not CLR_ENDPOINT");
		LDI r4,0x9f ;__Lstrings+0x816
		LDI r5,0x43 ;__Lstrings+0x816>>8
		JMP _UsbStall
;			return;
;			}
;		if (setup.wValue.w)
_UsbSetFeature__56:
		LDA r0,_setup+0x2
		LDA r1,_setup+0x3
		OR  r1
		BREQ _UsbSetFeature__66 ;(+07)
;			{
;			STALL("~10", "UsbSetFeature: wValue not 0");
		LDI r4,0xe4 ;__Lstrings+0x95b
		LDI r5,0x44 ;__Lstrings+0x95b>>8
		JMP _UsbStall
;			return;
;			}
;		ENDPT_RG[setup.wIndex.b.l & 0x0f] |= ENDPT_STALL_BIT;	// set stall bit
_UsbSetFeature__66:
		LDI r1,0x02
		LDI r2,0x0f
		LDA r0,_setup+0x4
		AND r2
		T0X r2
		LDI r3,0x00
		LDI r0,0x90
		ADD r2
		T0X r2
		LDI r0,0x02
		ADC r3
		T0X r3
		LDX r2
		OR  r1
		STX r2
;#if DEBUG_STALL
;		puts("Stalling EP");
;		putb(setup.wIndex.b.l & 0x0f);
;		putCrlf();
;#endif
;		}
;
;	pTxBDT = UsbSendInZero();
_UsbSetFeature__7c:
		JSR _UsbSendInZero
		STA r1,_usb_target_psr+0xe
		STA r0,_usb_target_psr+0xd
;
;	if (setup.bRequestType)	// wait if not 0
		LDA r0,_setup
		BREQ _UsbSetFeature__93 ;(+09)
;		while (pTxBDT->pid & 0x80)
_UsbSetFeature__8a:
		LDA r2,_usb_target_psr+0xd
		LDA r3,_usb_target_psr+0xe
		LDX r2
		BRMI _UsbSetFeature__8a ;(-09)
;			;	// wait for own bit to clear
;
;	return;
_UsbSetFeature__93:
		RTS
;}
;
;void UsbSetAddress(void)
;{
;	static PBDT pTxBDT, pRxBDT;
;	
;// We setup a TX packet of 0 length ready for the IN token
;// Once we get the TOK_DNE interrupt for the IN token, then
;// we change the ADDR register and go to the ADDRESS state.
;// See section 9.4.6 rev 1.0 page 179 3rd paragraph of the USB Spec.
;
;	if (bTruncateNextDeviceDescriptor)
_UsbSetAddress:
		LDA r0,_bTruncateNextDeviceDescriptor
		BREQ _UsbSetAddress__9 ;(+04)
;		{
;#if DEBUG_TRUNCATE
;		puts("UsbSetAddress: will NOT truncate next device descriptor\r\n");
;#endif
;		bTruncateNextDeviceDescriptor = FALSE;
		XOR r0
		STA r0,_bTruncateNextDeviceDescriptor
;		}
;
;	if (IS_TOKEN_SETUP_DATA0)
_UsbSetAddress__9:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbSetAddress__61 ;(+4d)
;		{
;		pTxBDT = UsbSendIn(0xc0, 0, 0, TRUE);
		STA r0,A_UsbSendIn+0x1
		STA r0,A_UsbSendIn
		LDI r0,0x01
		STA r0,Aa_HostSetNextOutBdt
		LDI r2,0x00
		LDI r4,0xc0
		JSR _UsbSendIn
		STA r1,_usb_target_psr+0x10
		STA r0,_usb_target_psr+0xf
;		pRxBDT = (PBDT)(((WORD)pTxBDT) & 0xfff3);	// mask off direction and parity
		LDI r2,0xf3 ;_WANT_USB_YES+0xe3
		LDI r3,0xff ;_WANT_USB_YES+0xe3>>8
		AND r2
		T0X r2
		TX0 r1
		AND r3
		T0X r3
		STA r3,_usb_target_psr+0x12
		STA r2,_usb_target_psr+0x11
;
;		while ((pTxBDT->pid & 0x80) && (pRxBDT[0].pid & 0x80) && (pRxBDT[1].pid & 0x80))
_UsbSetAddress__3b:
		LDA r2,_usb_target_psr+0xf
		LDA r3,_usb_target_psr+0x10
		LDX r2
		BRPL _UsbSetAddress__51 ;(+0d)
		LDA r2,_usb_target_psr+0x11
		LDA r3,_usb_target_psr+0x12
		LDX r2
		BRPL _UsbSetAddress__51 ;(+04)
		LDO r2,0x04
		BRMI _UsbSetAddress__3b ;(-16)
;			;	// wait for own bit to clear
;
;		if ((pTxBDT->pid & 0x80) == 0x00)			// got in token
_UsbSetAddress__51:
		LDA r2,_usb_target_psr+0xf
		LDA r3,_usb_target_psr+0x10
		LDX r2
		BRMI _UsbSetAddress__60 ;(+06)
;			usb.address = setup.wValue.b.l;			// set new address
		LDA r0,_setup+0x2
		STA r0,_usb+0x6
;		return;							// now wait for the IN to complete.
_UsbSetAddress__60:
		RTS
;		}
;// ;;;; the following several lines keep the V8 in the interrupt 
;// service routine to set the address VERY quickly.
;
;// STATUS phase of the SET_ADDR transaction (there is no data phase)
;
;	if (!IS_TOKEN_IN_DATA1)
_UsbSetAddress__61:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BREQ _UsbSetAddress__73 ;(+07)
;		{
;		STALL("~11", "UsbSetAddress: not In Data1");
		LDI r4,0xc8 ;__Lstrings+0x93f
		LDI r5,0x44 ;__Lstrings+0x93f>>8
		JSR _UsbStall
;//		return;
;		}
;
;	usb.address = setup.wValue.b.l;			// set new address
_UsbSetAddress__73:
		LDA r0,_setup+0x2
		STA r0,_usb+0x6
;	USB_STATE = ADDRESS_STATE;
		LDI r0,0x01
		STA r0,_USB_STATE
;#if DEBUG_STATE
;	puts("Usb:ADDRESS_STATE ");
;	putb(usb.address);
;	putCrlf();
;#endif
;	return;
		RTS
;}
;
;PBYTE	pDataOut = NULL;
;ONION	wDataOut = {0xee};
;BOOL	bSendExtraNullPacket = FALSE;	// if descriptor size is a multiple of 
;										// the packet size, send an extra null
;										// packet
;
;void UsbGetDescription(void)
;{
;	static WORD	wMax;
;	static ONION	bytes;
;// The Device Request can ask for Device/Config/string/interface/endpoint
;// descriptors (via wValue). We then post an IN response to return the
;// requested descriptor.
;// And then wait for the OUT which terminates the control transfer.
;
;	wMax = USB_MAX_PACKET[usbSave.ep];
_UsbGetDescription:
		LDI r2,0x33 ;_USB_MAX_PACKET
		LDI r3,0x48 ;_USB_MAX_PACKET>>8
		LDA r0,_usbSave+0xe
		LDI r1,0x00
		ADD r0
		ROL r1
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDO r2,0x01
		STA r0,_usb_target_psr+0x14
		LDX r2
		STA r0,_usb_target_psr+0x13
;
;	if (IS_TOKEN_SETUP)
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BREQ _UsbGetDescription__27 ;(+03)
		JMP _UsbGetDescription__1a9
_UsbGetDescription__27:
		JMP _UsbGetDescription__10b
;		{
;		// Load the appropriate string depending on the descriptor requested.
;
;		switch (setup.wValue.b.h)
;			{
;			case 1:
;				pDataOut = USB_DEVICE_DESC;
_UsbGetDescription__2a:
		LDI r0,0x49
		STA r0,_pDataOut+0x1
		LDI r0,0x63
		STA r0,_pDataOut
;				// the first get device descriptor after a reset
;				// should only return 8 bytes
;				if (bTruncateNextDeviceDescriptor)
		LDA r0,_bTruncateNextDeviceDescriptor
		BREQ _UsbGetDescription__44 ;(+0b)
;					{
;					bTruncateNextDeviceDescriptor = FALSE;
		XOR r0
		STA r0,_bTruncateNextDeviceDescriptor
;					wDataOut.w = 8;
		STA r0,_wDataOut+0x1
		LDI r0,0x08
		BRNE _UsbGetDescription__83 ;(+3f)
;					}
;				else // get size from bytes 7-8 of incoming token
;					{
;					if (setup.wLength.w > sizeof(USB_DEVICE_DESC))
_UsbGetDescription__44:
		LDI r1,0x13
		LDA r0,_setup+0x6
		CMP r1
		LDI r1,0x00
		LDA r0,_setup+0x7
		SBC r1
		BRCC _UsbGetDescription__7a ;(+28)
;						wDataOut.w = sizeof(USB_DEVICE_DESC);
		XOR r0
		STA r0,_wDataOut+0x1
		LDI r0,0x12
		BRNE _UsbGetDescription__83 ;(+29)
;					else
;						wDataOut = setup.wLength;
;					}
;asm("stp 5");
;				break;
;			case 2:
;				pDataOut = USB_CONFIG_DESC;
_UsbGetDescription__5a:
		LDI r0,0x49
		STA r0,_pDataOut+0x1
		LDI r0,0x75
		STA r0,_pDataOut
;				if (setup.wLength.w > sizeof(USB_CONFIG_DESC))
		LDI r1,0x9e
		LDA r0,_setup+0x6
		CMP r1
		LDI r1,0x00
		LDA r0,_setup+0x7
		SBC r1
		BRCC _UsbGetDescription__7a ;(+08)
;					wDataOut.w = sizeof(USB_CONFIG_DESC);
		XOR r0
		STA r0,_wDataOut+0x1
		LDI r0,0x9d
		BRNE _UsbGetDescription__83 ;(+09)
;				else
;					wDataOut = setup.wLength;
_UsbGetDescription__7a:
		LDA r0,_setup+0x7
		STA r0,_wDataOut+0x1
		LDA r0,_setup+0x6
_UsbGetDescription__83:
		STA r0,_wDataOut
;asm("stp 5");
		STP 5
;				break;
		JMP _UsbGetDescription__123
;			case 3:
;				USB_STR_0[0] = sizeof(USB_STR_0) - 1;
_UsbGetDescription__8a:
		LDI r0,0x04
		STA r0,_USB_DEBUG+0xe
;				USB_STR_1[0] = sizeof(USB_STR_1) - 1;
		LDI r0,0x20
		STA r0,_USB_DEBUG+0x13
;				USB_STR_2[0] = sizeof(USB_STR_2) - 1;
		LDI r0,0x3a
		STA r0,_USB_DEBUG+0x34
;				USB_STR_3[0] = sizeof(USB_STR_3) - 1;
		LDI r0,0x0a
		STA r0,_USB_DEBUG+0x6f
;				USB_STR_4[0] = sizeof(USB_STR_4) - 1;
		LDI r0,0x08
		STA r0,_USB_DEBUG+0x7a
;				USB_STR_5[0] = sizeof(USB_STR_5) - 1;
		STA r0,_USB_DEBUG+0x83
;				USB_STR_6[0] = sizeof(USB_STR_6) - 1;
		LDI r0,0x1c
		STA r0,_USB_DEBUG+0x8c
;				USB_STR_7[0] = sizeof(USB_STR_7) - 1;
		STA r0,_USB_DEBUG+0xa9
;				USB_STR_8[0] = sizeof(USB_STR_8) - 1;
		LDI r0,0x2a
		STA r0,_USB_DEBUG+0xc6
;				USB_STR_n[0] = sizeof(USB_STR_n) - 1;
		LDI r0,0x22
		STA r0,_USB_DEBUG+0xf1
;
;				if (setup.wValue.b.l > USB_STR_NUM)
		LDI r1,0x09
		LDA r0,_setup+0x2
		CMP r1
		BRCC _UsbGetDescription__cc ;(+0c)
;					pDataOut = USB_STRING_DESC[USB_STR_NUM+1];
		LDA r0,_USB_DEBUG+0x127
		STA r0,_pDataOut+0x1
		LDA r0,_USB_DEBUG+0x126
		JMP _UsbGetDescription__e2
;				else
;					pDataOut = USB_STRING_DESC[setup.wValue.b.l];
_UsbGetDescription__cc:
		LDI r2,0x4f ;_USB_DEBUG+0x114
		LDI r3,0x49 ;_USB_DEBUG+0x114>>8
		LDA r0,_setup+0x2
		LDI r1,0x00
		ADD r0
		ROL r1
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDO r2,0x01
		STA r0,_pDataOut+0x1
		LDX r2
_UsbGetDescription__e2:
		STA r0,_pDataOut
;				if (setup.wLength.b.l < pDataOut[0])
		T0X r2
		LDA r3,_pDataOut+0x1
		LDX r2
		T0X r2
		LDA r0,_setup+0x6
		CMP r2
;					wDataOut.b.l = setup.wLength.b.l;
		BRCC _UsbGetDescription__f5 ;(+04)
;				else
;					wDataOut.b.l = pDataOut[0];
		LDA r2,_pDataOut
		LDX r2
_UsbGetDescription__f5:
		STA r0,_wDataOut
;				wDataOut.b.h = 0;
		XOR r0
		STA r0,_wDataOut+0x1
;				break;
		BREQ _UsbGetDescription__123 ;(+25)
;			default:
;				putb(setup.wValue.b.h);
_UsbGetDescription__fe:
		LDA r4,_setup+0x3
		JSR _putb
;				STALL("~12", " - UsbGetDescription: bad wValue");
		LDI r4,0x8e ;__Lstrings+0x605
		LDI r5,0x41 ;__Lstrings+0x605>>8
		JMP _UsbStall
_UsbGetDescription__10b:
		LDA r0,_setup+0x3
		DEC r0
		BRNE _UsbGetDescription__114 ;(+03)
		JMP _UsbGetDescription__2a
_UsbGetDescription__114:
		DEC r0
		BRNE _UsbGetDescription__11a ;(+03)
		JMP _UsbGetDescription__5a
_UsbGetDescription__11a:
		DEC r0
		BRNE _UsbGetDescription__120 ;(+03)
		JMP _UsbGetDescription__8a
_UsbGetDescription__120:
		JMP _UsbGetDescription__fe
;				return;
;			}
;		// send the descriptor
;		// first check to see how much the host wants and if it wants less than
;		// we have, then only send it what it wants.
;		// Then post buffers until all the data has been queued.
;
;#if 0
;		if (setup.wLength.w > wDataOut.w)	// host wants more than we have to send
;			setup.wLength.w = wDataOut.w;	// so change wLength to the size we want to send.
;
;		if (setup.wLength.w > wMax)	// more than a buffer's worth to send?
;			bytes.w =  wMax;
;		else
;			bytes = setup.wLength;
;#else
;		if (wDataOut.w >  wMax)	// more than a buffer's worth to send?
_UsbGetDescription__123:
		LDA r1,_wDataOut
		LDA r0,_usb_target_psr+0x13
		CMP r1
		LDA r1,_wDataOut+0x1
		LDA r0,_usb_target_psr+0x14
		SBC r1
		BRCS _UsbGetDescription__13f ;(+0c)
;			bytes.w =  wMax;
		LDA r0,_usb_target_psr+0x14
		STA r0,_usb_target_psr+0x16
		LDA r0,_usb_target_psr+0x13
		JMP _UsbGetDescription__148
;		else
;			bytes = wDataOut;
_UsbGetDescription__13f:
		LDA r0,_wDataOut+0x1
		STA r0,_usb_target_psr+0x16
		LDA r0,_wDataOut
_UsbGetDescription__148:
		STA r0,_usb_target_psr+0x15
;#endif
;asm("clp 5");
		CLP 5
;
;#if DEBUG_GETDESC
;puts("wDataOut=");
;putos(wDataOut);
;puts("bytes=");
;puto(bytes);
;putCrlf();
;putFlush();
;#endif // DEBUG_GETDESC
;
;
;		// DATA1 for first packet
;		UsbSendIn(0xc0 | bytes.b.h, bytes.b.l, pDataOut, wDataOut.w == bytes.w);
		LDA r0,_pDataOut+0x1
		STA r0,A_UsbSendIn+0x1
		LDA r0,_pDataOut
		STA r0,A_UsbSendIn
		LDA r0,_wDataOut
		LDA r1,_wDataOut+0x1
		LDA r2,_usb_target_psr+0x15
		XOR r2
		BRNE _UsbGetDescription__16e ;(+0a)
		LDA r0,_usb_target_psr+0x16
		XOR r1
		BRNE _UsbGetDescription__16e ;(+04)
		LDI r0,0x01
		BRNE _UsbGetDescription__16f ;(+01)
_UsbGetDescription__16e:
		XOR r0
_UsbGetDescription__16f:
		STA r0,Aa_HostSetNextOutBdt
		LDA r2,_usb_target_psr+0x15
		LDI r1,0xc0
		LDA r0,_usb_target_psr+0x16
		OR  r1
		T0X r4
		JSR _UsbSendIn
;		// SEND_DATA01 is now set to DATA0 for next packet
;
;		wDataOut.w -= bytes.w;		// decrease count of bytes remaining
		LDA r0,_wDataOut
		LDA r1,_usb_target_psr+0x15
		STP C
		SBC r1
		STA r0,_wDataOut
		LDA r0,_wDataOut+0x1
		LDA r1,_usb_target_psr+0x16
		SBC r1
		STA r0,_wDataOut+0x1
;		pDataOut += bytes.w;		// increase pointer to output buffer
		LDA r0,_pDataOut
		LDA r1,_usb_target_psr+0x15
		ADD r1
		STA r0,_pDataOut
		LDA r0,_pDataOut+0x1
		LDA r1,_usb_target_psr+0x16
		ADC r1
		STA r0,_pDataOut+0x1
;
;//	If you want to send a second buffer now, just remove the following return
;		return;
		RTS
;
;//		// instead of returning at this point, we'll try to post another
;//		// buffer if we have more data than fits in a buffer.
;		}
;	else if (IS_TOKEN_IN)
_UsbGetDescription__1a9:
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x24
		XOR r1
		BREQ _UsbGetDescription__1d9 ;(+25)
;		{
;		}
;	else if (IS_TOKEN_OUT)
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x04
		CMP r1
		BRNE _UsbGetDescription__1c2 ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;	else
;		{
;#if !WANT_LITE
;		puts("pid=");
_UsbGetDescription__1c2:
		LDI r4,0x86 ;__Lstrings+0x8fd
		LDI r5,0x44 ;__Lstrings+0x8fd>>8
		JSR _puts
;		putb(cBDT.pid);
		LDA r4,_cBDT
		JSR _putb
;		putCrlf();
		JSR _putCrlf
;#endif // !WANT_LITE
;		STALL("~13", "UsbGetDescription: Bad PID");
		LDI r4,0x42 ;__Lstrings+0x8b9
		LDI r5,0x44 ;__Lstrings+0x8b9>>8
		JMP _UsbStall
;		return;
;		}
;
;// SETUP and IN tokens fall into this
;
;	if (!wDataOut.w)
_UsbGetDescription__1d9:
		LDA r0,_wDataOut
		LDA r1,_wDataOut+0x1
		OR  r1
		BRNE _UsbGetDescription__1ec ;(+0a)
;		{
;		if (!bSendExtraNullPacket)
		LDA r0,_bSendExtraNullPacket
		BRNE _UsbGetDescription__1e8 ;(+01)
		RTS
;			return;			// all done
;		bSendExtraNullPacket = FALSE;
_UsbGetDescription__1e8:
		XOR r0
		STA r0,_bSendExtraNullPacket
;#if DEBUG_EXTRA_NULL
;		puts("UsbGetDescription: sending extra null packet\r\n");
;#endif
;		}
;
;// I don't trust this - Russell
;
;#if DEBUG_GETDESC2
;puts("wDataOut=");
;puto(wDataOut);
;putCrlf();
;putFlush();
;#endif // DEBUG_GETDESC
;
;#if 0
;	if (setup.wLength.w > wMax)	// more than a buffer's worth to send?
;		bytes.w =  wMax;	// only send  wMax bytes
;	else
;		bytes = setup.wLength;	// send all bytes
;#else
;	if (wDataOut.w > wMax)	// more than a buffer's worth to send?
_UsbGetDescription__1ec:
		LDA r1,_wDataOut
		LDA r0,_usb_target_psr+0x13
		CMP r1
		LDA r1,_wDataOut+0x1
		LDA r0,_usb_target_psr+0x14
		SBC r1
		BRCS _UsbGetDescription__208 ;(+0c)
;		bytes.w =  wMax;
		LDA r0,_usb_target_psr+0x14
		STA r0,_usb_target_psr+0x16
		LDA r0,_usb_target_psr+0x13
		JMP _UsbGetDescription__211
;	else
;		bytes = wDataOut;
_UsbGetDescription__208:
		LDA r0,_wDataOut+0x1
		STA r0,_usb_target_psr+0x16
		LDA r0,_wDataOut
_UsbGetDescription__211:
		STA r0,_usb_target_psr+0x15
;#endif
;
;// if this is the last packet
;//    then (wDataOut.w <= wMax) && !bSendExtraNullPacket
;// we want to stall the other in bdt
;
;	UsbSendIn(0x80 | bytes.b.h, bytes.b.l, pDataOut, (wDataOut.w <= wMax) && !bSendExtraNullPacket);
		LDA r0,_pDataOut+0x1
		STA r0,A_UsbSendIn+0x1
		LDA r0,_pDataOut
		STA r0,A_UsbSendIn
		LDA r1,_wDataOut
		LDA r0,_usb_target_psr+0x13
		CMP r1
		LDA r1,_wDataOut+0x1
		LDA r0,_usb_target_psr+0x14
		SBC r1
		BRCC _UsbGetDescription__239 ;(+09)
		LDA r0,_bSendExtraNullPacket
		BRNE _UsbGetDescription__239 ;(+04)
		LDI r0,0x01
		BRNE _UsbGetDescription__23a ;(+01)
_UsbGetDescription__239:
		XOR r0
_UsbGetDescription__23a:
		STA r0,Aa_HostSetNextOutBdt
		LDA r2,_usb_target_psr+0x15
		LDI r1,0x80
		LDA r0,_usb_target_psr+0x16
		OR  r1
		T0X r4
		JSR _UsbSendIn
;	// DATA01 is now toggled
;
;	wDataOut.w -= bytes.w;	// decrease count of bytes remaining
		LDA r0,_wDataOut
		LDA r1,_usb_target_psr+0x15
		STP C
		SBC r1
		STA r0,_wDataOut
		LDA r0,_wDataOut+0x1
		LDA r1,_usb_target_psr+0x16
		SBC r1
		STA r0,_wDataOut+0x1
;	pDataOut += bytes.w;	// increase pointer to output buffer
		LDA r0,_pDataOut
		LDA r1,_usb_target_psr+0x15
		ADD r1
		STA r0,_pDataOut
		LDA r0,_pDataOut+0x1
		LDA r1,_usb_target_psr+0x16
		ADC r1
		STA r0,_pDataOut+0x1
;
;// HACK alert
;// we shouldn't do this at all.
;// if we do do it the test should be (bytes.w == wMax)
;// as it currently stands, it will send an extra null packet after every request
;
;//	if (bytes.w <= wMax)
;	if (bytes.w == wMax)
		LDA r0,_usb_target_psr+0x15
		LDA r2,_usb_target_psr+0x13
		CMP r2
		BRNE _UsbGetDescription__287 ;(+0b)
		LDA r0,_usb_target_psr+0x14
		CMP r1
		BRNE _UsbGetDescription__287 ;(+05)
;		bSendExtraNullPacket = TRUE;	// note to myself, send extra null packet
		LDI r0,0x01
		STA r0,_bSendExtraNullPacket
;
;	return;
;}
_UsbGetDescription__287:
		RTS
;
;void UsbSetDescription(void)
;{
;	STALL("~14", "UsbSetDescription: not implemented");
_UsbSetDescription:
		LDI r4,0x7c ;__Lstrings+0x7f3
		LDI r5,0x43 ;__Lstrings+0x7f3>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbGetConfig(void)
;{
;// Return the currently selected configuration
;
;#if DEBUG_CONFIG
;puts("UsbGetConfig: ");
;putw((WORD)pBDT);
;puts("->");
;putb(cBDT.pid);
;putCrlf();
;#endif
;	if (IS_TOKEN_SETUP_DATA0)
_UsbGetConfig:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbGetConfig__24 ;(+19)
;		{
;		if (setup.bRequestType != 0x80)
		LDI r1,0x80
		LDA r0,_setup
		CMP r1
		BREQ _UsbGetConfig__1a ;(+07)
;			{
;			STALL("~15", "UsbGetConfig: bad bRequestType");
		LDI r4,0xd1 ;__Lstrings+0x648
		LDI r5,0x41 ;__Lstrings+0x648>>8
		JMP _UsbStall
;			return;
;			}
;		UsbSendIn(0xc0, 1, &USB_CURR_CONFIG, TRUE);
_UsbGetConfig__1a:
		LDI r0,0x4e
		STA r0,A_UsbSendIn+0x1
		LDI r0,0x1a
		JMP _UsbVendGetEndPoint__27
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbGetConfig__24:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbGetConfig__30 ;(+01)
		RTS
;		{
;		return;
;		}
;
;	if (IS_TOKEN_OUT_DATA1)
_UsbGetConfig__30:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x44
		CMP r1
		BRNE _UsbGetConfig__3e ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;
;	puts("pid=");
_UsbGetConfig__3e:
		LDI r4,0x86 ;__Lstrings+0x8fd
		LDI r5,0x44 ;__Lstrings+0x8fd>>8
		JSR _puts
;	putb(cBDT.pid);
		LDA r4,_cBDT
		JSR _putb
;	putCrlf();
		JSR _putCrlf
;	STALL("~3", "UsbGetConfig Bad PID");
		LDI r4,0xfc ;__Lstrings+0x873
		LDI r5,0x43 ;__Lstrings+0x873>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbSetConfig()
;{
;#if DEBUG_CONFIG
;puts("UsbSetConfig: ");
;putw((WORD)pBDT);
;putb(cBDT.pid);
;putCrlf();
;#endif
;
;//	USB_DUMP_COUNT = 0x40;		// number of ints to dump
;
;	memset(SEND_DATA01, 0x00, ENDPOINTS);	// stores the Data1/0 PID
_UsbSetConfig:
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x5d ;_SEND_DATA01
		LDI r5,0x4e ;_SEND_DATA01>>8
		JSR _memset
;	memset(RECV_DATA01, 0x00, ENDPOINTS);	// stores the Data1/0 PID
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x59 ;_RECV_DATA01
		LDI r5,0x4e ;_RECV_DATA01>>8
		JSR _memset
;
;	if (IS_TOKEN_SETUP_DATA0)
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BREQ _UsbSetConfig__2a ;(+03)
		JMP _UsbSetConfig__c6
;		{
;		USB_CURR_CONFIG = setup.wValue.b.l;	// save the currently selected config value
_UsbSetConfig__2a:
		LDA r0,_setup+0x2
		STA r0,_USB_CURR_CONFIG
;		
;		// config=0 indicates return to unconfig'd state
;		if (!USB_CURR_CONFIG)
		LDA r0,_USB_CURR_CONFIG
		BRNE _UsbSetConfig__4d ;(+18)
;			{
;			USB_STATE = ADDRESS_STATE;
		LDI r0,0x01
		STA r0,_USB_STATE
;			puts("USC:Addr=");
		LDI r4,0x73 ;__Lstrings+0x8ea
		LDI r5,0x44 ;__Lstrings+0x8ea>>8
		JSR _puts
;			putb(usbSave.address);
		LDA r4,_usbSave+0x6
		JSR _putb
;			putCrlf();
		JSR _putCrlf
;			UsbSendInZero();	// ack
		JMP _UsbSendInZero
;			return;
;			}
;
;#if WANT_HUB
;		HubSetConfiguration();
;#endif
;
;		if (USB_CURR_CONFIG != USB_CONFIG_DESC[5])
_UsbSetConfig__4d:
		LDA r1,_USB_CURR_CONFIG
		LDA r0,_USB_CONFIG_DESC+0x5
		CMP r1
		BREQ _UsbSetConfig__70 ;(+1a)
;			{
;			putb(USB_CURR_CONFIG);
		LDA r4,_USB_CURR_CONFIG
		JSR _putb
;			puts("!=");
		LDI r4,0xb3 ;__Lstrings+0x92a
		LDI r5,0x44 ;__Lstrings+0x92a>>8
		JSR _puts
;			putb(USB_CONFIG_DESC[5]);
		LDA r4,_USB_CONFIG_DESC+0x5
		JSR _putb
;			UsbStall("UsbSetConfig");
		LDI r4,0x81 ;__Lstrings+0x5f8
		LDI r5,0x41 ;__Lstrings+0x5f8>>8
		JMP _UsbStall
;			return;
;			}
;
;		USB_STATE = CONFIG_STATE;
_UsbSetConfig__70:
		XOR r0
		STA r0,_USB_STATE
;
;#if WANT_SOUND
;		{
;static PBDT	pBDT;
;		// init BDT for EP2
;		pBDT = (PBDT)&USB_BDT_PAGE[ENDPOINT_SPEAKER*4+0];	// EP1 out even
		LDI r0,0x70
		STA r0,_usb_target_psr+0x18
		LDI r0,0x10
		STA r0,_usb_target_psr+0x17
;		pBDT[0].pid = pBDT[1].pid = 0x80;
		LDI r0,0x80
		LDA r2,_usb_target_psr+0x17
		LDA r3,_usb_target_psr+0x18
		STO r2,0x04
		LDO r2,0x04
		STX r2
;		pBDT[0].bc = pBDT[1].bc = 64;		// BC=64 (even though we only need 32)
		LDI r0,0x40
		STO r2,0x05
		LDO r2,0x05
		STO r2,0x01
;		pBDT[0].addr.w = (WORD)&USB_SPEAKER_BUFF[0x000];
		LDI r0,0x71
		STO r2,0x03
		LDI r0,0x00
		STO r2,0x02
;		pBDT[1].addr.w = (WORD)&USB_SPEAKER_BUFF[0x100];
		LDI r0,0x72
		STO r2,0x07
		LDI r0,0x00
		STO r2,0x06
;		memset((PBYTE)&USB_BDT_PAGE[ENDPOINT_SPEAKER*4+2], 0, 8);	// clear in bdts
		LDI r0,0x08
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x18 ;_USB_BDT_PAGE+0x18
		LDI r5,0x70 ;_USB_BDT_PAGE+0x18>>8
		JSR _memset
;		ENDPT_RG[ENDPOINT_SPEAKER] = ENDPT_ISO_OUT;
		LDI r0,0x08
		STA r0,_ENDPT_HOST_RG+0x1
;		}
;#endif
;
;#if WANT_HUB
;		{
;static PBDT	pBDT;
;		// init BDT for EP1
;		pBDT = (PBDT)&USB_BDT_PAGE[ENDPOINT_HUB*4];		// EP1 out even
;		memset((PBYTE)pBDT, 0, sizeof(BDT) * 4);
;		pBDT->bc = PORT_BYTES;
;		pBDT->addr.w = (WORD)ChangeSummary;
;
;		pBDT++;											// EP1 out odd
;		pBDT->bc = PORT_BYTES;
;		pBDT->addr.w = (WORD)ChangeSummary;
;
;		ENDPT_RG[ENDPOINT_HUB] = ENDPT_BULK_IN;
;		}
;#endif
;
;#if WANT_PRINTER
;		InitPrinterEndpoints();
		JSR _InitPrinterEndpoints
;#endif
;		
;		USB_IF_ALT[0] = USB_IF_ALT[1] = USB_IF_ALT[2] = 0;
		XOR r0
		STA r0,_pDataOut+0x4
		STA r0,_pDataOut+0x3
		STA r0,_pDataOut+0x2
;		UsbSendInZero();	// ack
		JMP _UsbSendInZero
;
;		return;
;		}
;
;	if (!IS_TOKEN_IN_DATA1)
_UsbSetConfig__c6:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BREQ _UsbSetConfig__e7 ;(+16)
;		{
;		putws((WORD)usbSave.pBDT);
		LDA r4,_usbSave+0xf
		LDA r5,_usbSave+0x10
		JSR _putws
;		putb(cBDT.pid);
		LDA r4,_cBDT
		JSR _putb
;		STALL("~16", "UsbSetConfig: Bad PID");
		LDI r4,0x5d ;__Lstrings+0x8d4
		LDI r5,0x44 ;__Lstrings+0x8d4>>8
		JMP _UsbStall
;		return;
;		}
;
;	// just return once the IN token has been acked
;	return;
_UsbSetConfig__e7:
		RTS
;}
;
;void UsbGetInterface(void)
;{
;	if (IS_TOKEN_SETUP_DATA0)
_UsbGetInterface:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbGetInterface__2e ;(+23)
;		{
;		if (setup.bRequestType != 0x81)
		LDI r1,0x81
		LDA r0,_setup
		CMP r1
		BREQ _UsbGetInterface__1a ;(+07)
;			{
;			STALL("~17", "UsbGetInterface: bad bRequestType");
		LDI r4,0x32 ;__Lstrings+0x6a9
		LDI r5,0x42 ;__Lstrings+0x6a9>>8
		JMP _UsbStall
;			return;
;			}
;
;#if 0 && USB_NUM_IFACES
;		if (setup.wIndex.b.l >= USB_NUM_IFACES)
;			{
;			STALL("~18", "UsbGetInterface: bad wIndex");
;			return;
;			}
;#endif
;
;		UsbSendIn(0xc0, 1, &USB_IF_ALT[setup.wIndex.b.l], TRUE);
_UsbGetInterface__1a:
		LDA r0,_setup+0x4
		LDI r1,0x00
		LDI r4,0x56
		ADD r4
		T0X r4
		LDI r0,0x4e
		ADC r1
		T0X r1
		TX0 r4
		STA r1,A_UsbSendIn+0x1
		JMP _UsbVendGetEndPoint__27
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbGetInterface__2e:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbGetInterface__3a ;(+01)
		RTS
;		return;
;
;	if (IS_TOKEN_OUT_DATA1)
_UsbGetInterface__3a:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x44
		CMP r1
		BRNE _UsbGetInterface__48 ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;
;	STALL("~19", "UsbGetInterface: bad pid");
_UsbGetInterface__48:
		LDI r4,0x4d ;__Lstrings+0x7c4
		LDI r5,0x43 ;__Lstrings+0x7c4>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbSetInterface(void)
;{
;// we only have 1 setting and we allow the host to set it to the same value
;
;	if (USB_DEBUG)
_UsbSetInterface:
		LDA r0,_USB_DEBUG
		BREQ _UsbSetInterface__36 ;(+31)
;		{
;		puts("I=");
		LDI r4,0xb0 ;__Lstrings+0x927
		LDI r5,0x44 ;__Lstrings+0x927>>8
		JSR _puts
;		putbs(setup.bRequestType);
		LDA r4,_setup
		JSR _putbs
;		putbs(setup.bRequest);
		LDA r4,_setup+0x1
		JSR _putbs
;		putos(setup.wValue);
		LDA r4,_setup+0x2
		LDA r5,_setup+0x3
		JSR _putos
;		putos(setup.wIndex);
		LDA r4,_setup+0x4
		LDA r5,_setup+0x5
		JSR _putos
;		puto(setup.wLength);
		LDA r4,_setup+0x6
		LDA r5,_setup+0x7
		JSR _puto
;		putCrlf();
		JSR _putCrlf
;		}
;
;	if (IS_TOKEN_SETUP_DATA0)
_UsbSetInterface__36:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbSetInterface__65 ;(+24)
;		{
;		if (setup.bRequestType != 0x01)
		LDI r1,0x01
		LDA r0,_setup
		CMP r1
		BREQ _UsbSetInterface__50 ;(+07)
;			{
;			STALL("~20", "UsbSetInterface: bad bRequestType");
		LDI r4,0x10 ;__Lstrings+0x687
		LDI r5,0x42 ;__Lstrings+0x687>>8
		JMP _UsbStall
;			return;
;			}
;		
;#if 0 && USB_NUM_IFACES
;		if (setup.wIndex.b.l >= USB_NUM_IFACES)
;			{
;			STALL("~21", "UsbSetInterface: bad wIndex");
;			return;
;			}
;#endif
;
;		// save new setting
;		USB_IF_ALT[setup.wIndex.b.l] = setup.wValue.b.l;
_UsbSetInterface__50:
		LDI r2,0x56 ;_pDataOut+0x2
		LDI r3,0x4e ;_pDataOut+0x2>>8
		LDA r0,_setup+0x4
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDA r0,_setup+0x2
		STX r2
;		UsbSendInZero();	// ack
		JMP _UsbSendInZero
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbSetInterface__65:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbSetInterface__71 ;(+01)
		RTS
;		return;
;
;	if (IS_TOKEN_OUT_DATA1)
_UsbSetInterface__71:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x44
		CMP r1
		BRNE _UsbSetInterface__7f ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;
;	STALL("~22", "UsbSetInterface: bad pid");
_UsbSetInterface__7f:
		LDI r4,0x34 ;__Lstrings+0x7ab
		LDI r5,0x43 ;__Lstrings+0x7ab>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbSynchFrame(void)
;{
;	if (IS_TOKEN_SETUP_DATA0)
_UsbSynchFrame:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbSynchFrame__24 ;(+19)
;		{
;		if (setup.bRequestType != 0x02)
		LDI r1,0x02
		LDA r0,_setup
		CMP r1
		BREQ _UsbSynchFrame__1a ;(+07)
;			{
;			STALL("~23", "UsbSynchFrame: bad bRequestType");
		LDI r4,0xf0 ;__Lstrings+0x667
		LDI r5,0x41 ;__Lstrings+0x667>>8
		JMP _UsbStall
;			return;
;			}
;		
;#if 0 && USB_NUM_IFACES
;		if (setup.wIndex.b.l >= USB_NUM_IFACES)
;			{
;			STALL("~24", "UsbSynchFrame: bad wIndex");
;			return;
;			}
;#endif
;
;		UsbSendIn(0xc0, 2, (PBYTE)&USB_SOF_CTR, TRUE);
_UsbSynchFrame__1a:
		LDI r0,0x4e
		STA r0,A_UsbSendIn+0x1
		LDI r0,0x7c
		JMP _UsbVendGetStatus__1c
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbSynchFrame__24:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbSynchFrame__30 ;(+01)
		RTS
;		return;
;
;	if (IS_TOKEN_OUT_DATA1)
_UsbSynchFrame__30:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x44
		CMP r1
		BRNE _UsbSynchFrame__3e ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;
;	STALL("~25", "UsbSynchFrame: bad pid");
_UsbSynchFrame__3e:
		LDI r4,0x1d ;__Lstrings+0x794
		LDI r5,0x43 ;__Lstrings+0x794>>8
		JMP _UsbStall
;	return;
;}
;
;#if WANT_SOUND
;void UsbTokenDoneEP1_Speaker(void)
;{
;// We assume that EP2 is an ISO OUT EP to the AD1845 audio chip.
;// Data is buffered in the packet buffer and copied to the AD1845 fifos
;// immediately. Ideally, we really should wait until the SOF to copy the
;// data so it aligns perfectly. For 3D audio this would be required but
;// our application does not need that level of accuracy so we simply
;// copy as soon as the packet is received.
;
;	static PBYTE	ps;
;	static BYTE	b, USB_SR11;
;
;	if (!IS_TOKEN_OUT)
_UsbTokenDoneEP1_Speaker:
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x04
		CMP r1
		BREQ _UsbTokenDoneEP1_Speaker__12 ;(+07)
;		{
;		STALL("~26", "UsbTokenDoneEP1_Speaker: bad pid");
		LDI r4,0xfc ;__Lstrings+0x773
		LDI r5,0x42 ;__Lstrings+0x773>>8
		JMP _UsbStall
;		return;
;		}
;
;//putc('$');
;//putw((WORD)pBDT);
;
;	ps = (PBYTE)cBDT.addr.w;
_UsbTokenDoneEP1_Speaker__12:
		LDA r0,_cBDT+0x3
		STA r0,_usb_target_psr+0x1a
		LDA r0,_cBDT+0x2
		STA r0,_usb_target_psr+0x19
;	USB_BYTES = cBDT.bc;
		LDA r0,_cBDT+0x1
		STA r0,_USB_BYTES
;	AUDIO_BC++;
		LDA r0,_AUDIO_BC
		LDA r1,_AUDIO_BC+0x1
		UPP r0
		STA r0,_AUDIO_BC
		STA r1,_AUDIO_BC+0x1
;
;#if WANT_1394
;	FWSendUsbAudio( xxx );
;#endif
;
;	AUDIO_ADDR = 11;	// underran the audio chip?
		LDI r0,0x0b
		STA r0,_AUDIO_ADDR
;	USB_SR11 = AUDIO_DATA;		// read reg 11
		LDA r0,_AUDIO_DATA
		STA r0,_UART_NEXT+0x6
;	if ((AUDIO_STAT & 0x02) == 0)	// test PRDY
		LDA r0,_AUDIO_STAT
		BTT C
		BRNE _UsbTokenDoneEP1_Speaker__5a ;(+18)
;		{						// NOT PRDY
;		if (USB_DEBUG)
		LDA r0,_USB_DEBUG
		BREQ _UsbTokenDoneEP1_Speaker__4c ;(+05)
;			putc('~');
		LDI r4,0x7e
		JSR _putc
;		AUDIO_ADDR = 9;			// make sure playback is enabled.
_UsbTokenDoneEP1_Speaker__4c:
		LDI r0,0x09
		STA r0,_AUDIO_ADDR
;		b = AUDIO_DATA;
		LDA r0,_AUDIO_DATA
		STA r0,_UART_NEXT+0x5
;		if ((b & 0x01) == 0)	// if PEN not set
		BTT Z
		BREQ _UsbTokenDoneEP1_Speaker__ab ;(+51)
;			goto EP2_drop_done;	// re-init it
;		}
;
;	if (AUDIO_STAT & 0x10)				// SOUR?
_UsbTokenDoneEP1_Speaker__5a:
		LDA r0,_AUDIO_STAT
		BTT 4
		BREQ _UsbTokenDoneEP1_Speaker__a6 ;(+46)
;		{
;		if (USB_DEBUG)
		LDA r0,_USB_DEBUG
		BREQ _UsbTokenDoneEP1_Speaker__6a ;(+05)
;			putc('$');
		LDI r4,0x24
		JSR _putc
;		if (USB_SR11 & 0x40)			// underrun
_UsbTokenDoneEP1_Speaker__6a:
		LDA r0,_UART_NEXT+0x6
		BTT 6
		BREQ _UsbTokenDoneEP1_Speaker__a6 ;(+36)
;			UsbChangeFreq(0xffff);
		LDI r4,0xff ;_WANT_USB_YES+0xef
		LDI r5,0xff ;_WANT_USB_YES+0xef>>8
		JSR _UsbChangeFreq
;		}
;
;	while (USB_BYTES)
		JMP _UsbTokenDoneEP1_Speaker__a6
;		{
;		if ((AUDIO_STAT & 0x02) == 0)	// test PRDY
_UsbTokenDoneEP1_Speaker__7a:
		LDA r0,_AUDIO_STAT
		BTT C
		BRNE _UsbTokenDoneEP1_Speaker__8a ;(+0a)
;			{
;			UsbChangeFreq(0x0001);
		LDI r4,0x01 ;__Lreset+0x1
		LDI r5,0x00 ;__Lreset+0x1>>8
		JSR _UsbChangeFreq
;			break;
		JMP _UsbTokenDoneEP1_Speaker__ab
;			}
;
;		AUDIO_PIO = *ps++;		// send next byte out
_UsbTokenDoneEP1_Speaker__8a:
		LDA r2,_usb_target_psr+0x19
		LDA r3,_usb_target_psr+0x1a
		LDX r2
		STA r0,_AUDIO_PIO
		TX0 r2
		LDA r1,_usb_target_psr+0x1a
		UPP r0
		STA r0,_usb_target_psr+0x19
		STA r1,_usb_target_psr+0x1a
;		USB_BYTES--;
		LDA r0,_USB_BYTES
		DEC r0
		STA r0,_USB_BYTES
_UsbTokenDoneEP1_Speaker__a6:
		LDA r0,_USB_BYTES
		BRNE _UsbTokenDoneEP1_Speaker__7a ;(-31)
;		}
;
;EP2_drop_done:
;	cBDT.bc = 0xff;	// set byte count to 0x3ff
_UsbTokenDoneEP1_Speaker__ab:
		LDI r0,0xff
		STA r0,_cBDT+0x1
;
;//BREAK_OWNS here
;
;	cBDT.pid = 0x83;	// set OWNs bit
		LDI r0,0x83
		STA r0,_cBDT
;	*usbSave.pBDT = cBDT;	// copy local copy back to BDT
		LDA r2,_usbSave+0xf
		LDA r3,_usbSave+0x10
		STX r2
		LDA r0,_cBDT+0x1
		STO r2,0x01
		LDA r0,_cBDT+0x2
		STO r2,0x02
		LDA r0,_cBDT+0x3
		STO r2,0x03
;
;#if DEBUG_PBDT
;puts("UsbTokenDoneEP1_Speaker: usbSave.pBDT=");
;putw((WORD)usbSave.pBDT);
;puts("->");
;putbs(cBDT.pid);
;putbs(cBDT.bc);
;puto(cBDT.addr);
;putCrlf();
;#endif
;}
		RTS
;
;void UsbChangeFreq(WORD wDelta)
;{
;	static ONION	onion;
;
;	if (USB_DEBUG)
_UsbChangeFreq:
		STA r4,Aa_UsbVendSetEndPoint
		STA r5,Aa_UsbVendSetEndPoint+0x1
		LDA r0,_USB_DEBUG
		BREQ _UsbChangeFreq__1a ;(+0f)
;		{
;		putc(wDelta & 0x8000 ? '-' : '+');
		TX0 r5
		BTT 7
		BRNE _UsbChangeFreq__13 ;(+04)
		LDI r0,0x2b
		BRNE _UsbChangeFreq__15 ;(+02)
_UsbChangeFreq__13:
		LDI r0,0x2d
_UsbChangeFreq__15:
		PSH r0
		POP r4
		JSR _putc
;		}
;
;	AUDIO_ADDR = 23;
_UsbChangeFreq__1a:
		LDI r0,0x17
		STA r0,_AUDIO_ADDR
;	onion.b.l = AUDIO_DATA;
		LDA r0,_AUDIO_DATA
		STA r0,_usb_target_psr+0x1b
;	AUDIO_ADDR = 22;
		LDI r0,0x16
		STA r0,_AUDIO_ADDR
;	onion.b.h = AUDIO_DATA;
		LDA r0,_AUDIO_DATA
		STA r0,_usb_target_psr+0x1c
;	onion.w += wDelta;
		LDA r0,_usb_target_psr+0x1b
		LDA r1,Aa_UsbVendSetEndPoint
		ADD r1
		STA r0,_usb_target_psr+0x1b
		LDA r0,_usb_target_psr+0x1c
		LDA r1,Aa_UsbVendSetEndPoint+0x1
		ADC r1
		STA r0,_usb_target_psr+0x1c
;	AUDIO_DATA = onion.b.h;
		STA r0,_AUDIO_DATA
;	AUDIO_ADDR = 23;
		LDI r0,0x17
		STA r0,_AUDIO_ADDR
;	AUDIO_DATA = onion.b.l;
		LDA r0,_usb_target_psr+0x1b
		STA r0,_AUDIO_DATA
;
;	return;
;}
;#endif // WANT_SOUND
;
;#if WANT_PRINTER
;void UsbTokenDoneEP3(void)
;{
_UsbTokenDoneEP3:
		RTS
;// EP3 is a BULK in/out port that just sends/receives the data to/from the P1284 port.
;// All actual processing is done in the IDLE loop with calls the
;// USB_PRINTER routine once each time thru the idle loop. Data is sent
;// to the printer in this way so that we don't slow down interrupt proccesing.
;// In effect, EP3 is polled instead of interrupt driven. Being a bulk
;// device with an unknown amount of delay from the printer after sending
;// each byte made interrupt processing impractical as all other processing
;// would stop until the printer finally became ready again.
;
;	return;
;}
;
;void UsbPrinter()
;{
;// This is the routine that actually does all of the work!
;	static ONION	onion;
;
;	while (1)
;		{
;		if (USB_PRN_RUN)
_UsbPrinter:
		LDA r0,_USB_DEBUG+0x1
		BREQ _UsbPrinter__49 ;(+44)
;			{
;			if (PP_CTL.busy)	// printer busy
		LDA r0,_PP_CTL
		BTT I
		BREQ _UsbPrinter__c ;(+01)
		RTS
;				return;			// YES, do nothing more
;
;			// printer is ready for another byte
;			PP_DATA = *USB_PRN_READ++;
_UsbPrinter__c:
		LDA r2,_USB_DEBUG+0x2
		LDA r3,_USB_DEBUG+0x3
		LDX r2
		STA r0,_PP_DATA
		TX0 r2
		LDA r1,_USB_DEBUG+0x3
		UPP r0
		STA r0,_USB_DEBUG+0x2
		STA r1,_USB_DEBUG+0x3
;			if (USB_PRN_END == USB_PRN_READ)	// EOB?
		LDA r0,_USB_DEBUG+0x4
		LDA r1,_USB_DEBUG+0x5
		LDA r2,_USB_DEBUG+0x2
		XOR r2
		BRNE _UsbPrinter__49 ;(+1c)
		LDA r0,_USB_DEBUG+0x3
		XOR r1
		BRNE _UsbPrinter__49 ;(+16)
;				{
;				USB_PRN_PTR->bc = 64;	// reset the byte count to 64 bytes
		LDI r0,0x40
		LDA r2,_USB_DEBUG+0x6
		LDA r3,_USB_DEBUG+0x7
		STO r2,0x01
;// BREAK_OWNS
;				USB_PRN_PTR->pid = 0x80;	// release this buffer
		LDI r0,0x80
		STX r2
;				USB_PRN_PTR = (PBDT)((WORD)USB_PRN_PTR ^ 0x04);	// point to other buffer
		TX0 r2
		LDI r1,0x04
		XOR r1
		STA r0,_USB_DEBUG+0x6
		LDI r1,0x00
;				}
;			}
;
;		// Check if the current buffer has data in it
;		if (USB_PRN_PTR->pid & 0x80)	// no longer ours
_UsbPrinter__49:
		LDA r2,_USB_DEBUG+0x6
		LDA r3,_USB_DEBUG+0x7
		LDX r2
		BRPL _UsbPrinter__55 ;(+03)
		JMP _InitPrinterEndpoints__42
;			{							// nothing to do, clear the RUN flag
;			USB_PRN_RUN = 0;
;			return;
;			}
;
;		USB_PRN_READ = (PBYTE)USB_PRN_PTR->addr.w;	// start of buffer
_UsbPrinter__55:
		LDO r2,0x03
		STA r0,_USB_DEBUG+0x3
		LDO r2,0x02
		STA r0,_USB_DEBUG+0x2
;		onion.b.l = USB_PRN_PTR->bc;
		LDO r2,0x01
		STA r0,_usb_target_psr+0x1d
;		onion.b.h = USB_PRN_PTR->pid & 0x03;
		LDI r1,0x03
		LDX r2
		AND r1
		STA r0,_usb_target_psr+0x1e
;		USB_PRN_END = USB_PRN_READ + onion.w;	// end of buffer
		LDA r0,_usb_target_psr+0x1d
		LDA r1,_usb_target_psr+0x1e
		LDA r4,_USB_DEBUG+0x2
		ADD r4
		T0X r4
		LDA r0,_USB_DEBUG+0x3
		ADC r1
		T0X r1
		TX0 r4
		STA r1,_USB_DEBUG+0x5
		STA r0,_USB_DEBUG+0x4
		JMP _UsbPrinter
;		}
;}
;#endif // WANT_PRINTER
;
;void UsbTokenDoneEPn(void)
;{
;// All other endpoints function in the diagnostic mode.
;// If an OUT token is received, the data is posted to the IN BDT of the
;// EP with EP_ADDR[0]=NOT EP_ADDR[0].
;
;	putc('%');
_UsbTokenDoneEPn:
		LDI r4,0x25
		JSR _putc
;
;	if (setup.bRequestType != 0xff)
		LDI r1,0xff
		LDA r0,_setup
		CMP r1
		BREQ _UsbEchoEP ;(+07)
;		{
;		STALL("~27", "UsbTokenDoneEPn: bad bRequestType");
		LDI r4,0xaf ;__Lstrings+0x626
		LDI r5,0x41 ;__Lstrings+0x626>>8
		JMP _UsbStall
;		return;
;		}
;
;// if the bmRequestType=ff then we are not currently processing a SETUP 
;// transaction.  We will just echo any OUT data to the IN and drop anything we 
;// don't understand or if we don't have a buffer. This should only be used 
;// during diagnostic testing.
;
;	UsbEchoEP();
;	return;
;}
;
;void UsbEchoEP(void)
;{
;	if (!IS_TOKEN_OUT)
_UsbEchoEP:
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x04
		CMP r1
		BREQ _UsbEchoEP__c ;(+01)
		RTS
;		return;
;
;	UsbProvideRxBDT(TRUE);			// release the RX BDT again now that we're done
_UsbEchoEP__c:
		LDI r4,0x01
		JSR _UsbProvideRxBDT
;
;	UsbSendIn(0x80 | (cBDT.pid & 0x03), cBDT.bc, (PBYTE)cBDT.addr.w, FALSE);
		LDA r0,_cBDT+0x3
		STA r0,A_UsbSendIn+0x1
		LDA r0,_cBDT+0x2
		STA r0,A_UsbSendIn
		XOR r0
		STA r0,Aa_HostSetNextOutBdt
		LDA r2,_cBDT+0x1
		LDI r1,0x03
		LDA r0,_cBDT
		AND r1
		LDI r1,0x80
		OR  r1
		T0X r4
		JMP _UsbSendIn
;}
;
;PBDT UsbSendInZero()	// ack
;{
;
;	return UsbSendIn(0xc0, 0, 0x0000, TRUE);
_UsbSendInZero:
		XOR r0
		STA r0,A_UsbSendIn+0x1
		STA r0,A_UsbSendIn
		LDI r0,0x01
		STA r0,Aa_HostSetNextOutBdt
		LDI r2,0x00
		LDI r4,0xc0
		BRNE _UsbSendIn ;(+03)
		RTS
		.byte 0xab
		.byte 0x4f
;}
;
;PBDT UsbSendIn(BYTE pid, BYTE bc, PBYTE pData, BOOL bStall)
;{
;//	This routine is THE ONLY routine allowed to post packets for
;//	transmission on EP0. It keeps track of which buffer to use (even or
;//	or odd) and which one is to be used next. RESET must initialzize it's
;//	state variable USB_NEXT_OUT to 0x01.
;//	R0=OWN byte (80 or c0), R1=BC, R3/R2=addr of buffer to send.
;
;	static ONION	onion;
;	static PBDT		pTxBDT;
;#if DEBUG_SEND_IN
;	static BYTE	skip = 0;
;#endif
;
;	USB_LED_SEND_ON;
_UsbSendIn:
		STA r2,Aa_SendToken
		STA r4,Aa_SendToken+0x1
		STP 4
;
;#if DEBUG_SEND_IN && !WANT_LITE
;	if (debug.bits.UsbSend)
;		{
;		if (skip)
;			skip--;
;		if (!skip)
;			{
;			puts("UsbSendIn:");
;			putbs(usbSave.ep);
;			putb(pid);
;			putb(bc);
;			putw((WORD)pData);
;			puts(" In:");
;			putw((WORD)pBDT);
;			puts("->");
;			putb(cBDT.pid);
;			putb(cBDT.bc);
;			putos(cBDT.addr);
;			putbs(USB_NEXT_OUT[usbSave.ep]);
;			}
;		}
;#endif
;
;	onion.pBDT = usbSave.pBDT;
		LDA r0,_usbSave+0x10
		STA r0,_usb_target_psr+0x20
		LDA r0,_usbSave+0xf
		STA r0,_usb_target_psr+0x1f
;	onion.bdt.out = 1;
		LDI r1,0x08
		OR  r1
		STA r0,_usb_target_psr+0x1f
;	onion.bdt.odd = USB_NEXT_OUT[usbSave.ep]++;
		LDI r2,0x86 ;_USB_NEXT_OUT
		LDI r3,0x4e ;_USB_NEXT_OUT>>8
		LDA r0,_usbSave+0xe
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		INC r0
		STX r2
		DEC r0
		ROR r0
		LDA r0,_usb_target_psr+0x1f
		LDI r1,0x04
		OR  r1
		BRCS _UsbSendIn__35 ;(+01)
		XOR r1
_UsbSendIn__35:
		STA r0,_usb_target_psr+0x1f
;	pTxBDT = onion.pBDT;
		LDA r0,_usb_target_psr+0x20
		STA r0,_usb_target_psr+0x22
		LDA r0,_usb_target_psr+0x1f
		STA r0,_usb_target_psr+0x21
;
;#if DEBUG_SEND_IN2 && !WANT_LITE
;	if (debug.bits.UsbSend)
;		{
;		static BYTE	b;
;
;		for (b=0; b<4; b++)
;			{
;			putw((WORD)&USB_BDT_PAGE[b]);
;			putc('>');
;			putbs(USB_BDT_PAGE[b].pid);
;			putbs(USB_BDT_PAGE[b].bc);
;			putos(USB_BDT_PAGE[b].addr);
;			}
;		putCrlf();
;		putFlush();
;		}
;#endif
;
;	if (pTxBDT->pid & 0x80)
		T0X r2
		LDA r3,_usb_target_psr+0x22
		LDX r2
		BRPL _UsbSendIn__5e ;(+13)
;		{	// we don't own the buffer
;		putw((WORD)pTxBDT);
		LDA r4,_usb_target_psr+0x21
		LDA r5,_usb_target_psr+0x22
		JSR _putw
;		PUTS("~41", " - USB Buffer not OWNed\r\n");
		LDI r4,0x52 ;__Lstrings+0x9c9
		LDI r5,0x45 ;__Lstrings+0x9c9>>8
		JSR _puts
;		return NULL;
		XOR r0
		T0X r1
		RTS
;		}
;
;	pTxBDT->bc = bc;
_UsbSendIn__5e:
		LDA r0,Aa_SendToken
		LDA r2,_usb_target_psr+0x21
		LDA r3,_usb_target_psr+0x22
		STO r2,0x01
;	pTxBDT->addr.w = (WORD)pData;
		LDA r0,A_UsbSendIn+0x1
		STO r2,0x03
		LDA r0,A_UsbSendIn
		STO r2,0x02
;
;	if ((pid & 0x40) == 0)	// if DATA1 is clear
		LDA r0,Aa_SendToken+0x1
		BTT 6
		BRNE _UsbSendIn__90 ;(+17)
;		pid |= SEND_DATA01[usbSave.ep];	// get value from SEND_DATA01
		LDI r2,0x5d ;_SEND_DATA01
		LDI r3,0x4e ;_SEND_DATA01>>8
		LDA r0,_usbSave+0xe
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		T0X r2
		LDA r0,Aa_SendToken+0x1
		OR  r2
		STA r0,Aa_SendToken+0x1
;
;	SEND_DATA01[usbSave.ep] = (pid & 0x40) ^ 0x40;	// toggle bit for next packet
_UsbSendIn__90:
		LDA r4,Aa_SendToken+0x1
		LDI r2,0x5d ;_SEND_DATA01
		LDI r3,0x4e ;_SEND_DATA01>>8
		LDA r0,_usbSave+0xe
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r1,0x40
		TX0 r4
		AND r1
		XOR r1
		STX r2
;
;	pTxBDT->pid = pid;
		TX0 r4
		LDA r2,_usb_target_psr+0x21
		LDA r3,_usb_target_psr+0x22
		STX r2
;
;//if (pid & 0x04)
;//	puts("\r\n\apid & 0x04\r\n");
;
;#if DEBUG_SEND_IN && !WANT_LITE
;	if (debug.bits.UsbSend)
;		if (!skip)
;			{
;			puts("Out:");
;			putw((WORD)pTxBDT);
;			puts("->");
;			putb(pTxBDT->pid);
;			putb(pTxBDT->bc);
;			puto(pTxBDT->addr);
;			putCrlf();
;			putFlush();
;			}
;#endif
;
;	if (bStall)	// set stall bit on other out bdt
		LDA r0,Aa_HostSetNextOutBdt
		BREQ _UsbSendIn__c7 ;(+13)
;		{
;		onion.pBDT = pTxBDT;
		STA r3,_usb_target_psr+0x20
		STA r2,_usb_target_psr+0x1f
;		onion.b.l ^= 0x04;
		LDI r1,0x04
		TX0 r2
		XOR r1
		STA r0,_usb_target_psr+0x1f
;		onion.pBDT->pid = 0xc4;		// owns and stall and data1
		LDI r0,0xc4
		LDA r2,_usb_target_psr+0x1f
		STX r2
;		}
;
;	USB_LED_SEND_OFF;
_UsbSendIn__c7:
		CLP 4
;
;	return pTxBDT;
		LDA r0,_usb_target_psr+0x21
		LDA r1,_usb_target_psr+0x22
		RTS
;}
;
;
;// Two types of accesses will be supported by the diagnostic endpoint:
;//	Status transactions and Loop-back requests.
;//
;// Status transactions make use of the vendor specific device requests.
;// These transactions use the same format as specified in section 9.3 of the
;// USB rev1.0 specification.
;// The bmRequestType values for these Device Requests should be of TYPE=Vendor
;// D6..5=2 or in binary=x1000000. Bit 7 should reflect the direction of the
;// transaction.
;// Status transactions are only supported on EP0.
;//
;// The new bmRequest values are:
;//		bRequest	Action
;//			0		SET_STATUS
;//			1		GET_STATUS
;//			2		SET_EP_CTL
;//			3		GET_EP_CTL
;//			4		SET_MEM
;//			5		GET_MEM
;//			6		BREAK_OWNS
;// 
;//		wValue - for set status and set endpoint ctl the wValue contains the data
;//			to be writen to the register.
;//		wIndex - contains address information for endpoint and memory operatons.
;//		wLength - set the length of the data packet that follows the get or set
;//			descriptor packet.
;//SET_STATUS:
;//	wValue=value to set the bmERR_STAT register to.
;//	wIndex=Zero
;//	wLength=Zero
;//	DATA=none.
;//	The SET_STATUS command is used to write the bmERR_STAT register.
;//GET_STATUS:
;//	wValue=Zero
;//	wIndex=Zero
;//	wLength=1
;//	DATA=bmERR_STAT
;//	The GET_STATUS command is used to read the bmERR_STAT register.
;//SET_EP_CTL:
;//	wValue=value to set the bmEP_n_CTL register to.
;//	wIndex=EP number to be set (0-15)
;//	wLength=Zero
;//	DATA=none.
;//	The SET_EP_CTL command is used to write the bmEP_n_CTL register.
;//GET_EP_CTL:
;//	wValue=Zero
;//	wIndex=EP number to be read (0-15)
;//	wLength=2
;//	DATA=bmEP_n_CTL
;//	The GET_EP_CTL command is used to read the bmEP_n_CTL register.
;//SET_MEM:
;//	wValue=Zero
;//	wIndex=Address in memory
;//	wLength=number of bytes to write
;//	DATA=Data to be written to memory
;//	The SET_MEM command is used to write anywhere in the V8 address space.
;//GET_MEM:
;//	wValue=Zero
;//	wIndex=Address in memory
;//	wLength=number of bytes to read
;//	DATA=Data read from memory
;//	The GET_MEM command is used to read from anywhere in the V8 address space.
;//BREAK_OWNS:
;//	wValue=0 or 1
;//	wIndex = 0
;//	wLength = 0
;//	DATA = None
;//	if wValue = 1, all non-ep0 owns bits won't be set (ask Chris)
;//
;// LoopBack requests are handled by simply echoing any OUT packets on EP0 to
;// the EP0 IN Queue. The Host can then retrieve the echoed data by sending
;// and IN PID. If the V8 does not have a BDT to echo the packet to, the packet
;// is simply dropped. In normal operation, the Host should never do IN or OUT
;// tokens to EP0 without a SETUP token. Remember, this feature is meant to
;// be used ONLY for diagnostic purposes and you may want to remove this code for
;// production devices. This code will HAVE to be removed if you wish to transfer
;// data on EP0 via IN ot OUT transactions.
;
;void UsbVendor(void)
;{
_UsbVendor:
		JMP _UsbVendor__4
;	switch (setup.bRequest)
;		{
;		case 0:	UsbVendSetStatus();		return;
;		case 1:	UsbVendGetStatus();		return;
;		case 2:	UsbVendSetEndPoint();	return;
;		case 3:	UsbVendGetEndPoint();	return;
;		case 4:	UsbVendSetMemory();		return;
;		case 5:	UsbVendGetMemory();		return;
_UsbVendor__3:
		RTS
_UsbVendor__4:
		LDA r0,_setup+0x1
		BREQ _UsbVendSetStatus ;(+25)
		DEC r0
		BREQ _UsbVendGetStatus ;(+6d)
		DEC r0
		BRNE _UsbVendor__12 ;(+03)
		JMP _UsbVendSetEndPoint
_UsbVendor__12:
		DEC r0
		BRNE _UsbVendor__18 ;(+03)
		JMP _UsbVendGetEndPoint
_UsbVendor__18:
		DEC r0
		BRNE _UsbVendor__1e ;(+03)
		JMP _UsbVendSetMemory
_UsbVendor__1e:
		DEC r0
		BREQ _UsbVendor__3 ;(-1e)
		DEC r0
		BRNE _UsbVendor__27 ;(+03)
		JMP _UsbVendBreakOwns
;		case 6:	UsbVendBreakOwns();		return;
;		}
;
;	STALL("~28", "UsbVendor: bad bRequest");
_UsbVendor__27:
		LDI r4,0x06 ;__Lstrings+0x57d
		LDI r5,0x41 ;__Lstrings+0x57d>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbVendSetStatus(void)
;{
;	static BYTE	b;
;
;	if (IS_TOKEN_SETUP_DATA0)
_UsbVendSetStatus:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbVendSetStatus__36 ;(+2b)
;		{
;		usb.errorStatus = setup.wValue.b.l;	// immeadiately clear bits no longer wanted
		LDA r0,_setup+0x2
		STA r0,_usb+0x2
;		b = setup.wValue.b.l ^ 0xff;
		LDA r1,_setup+0x2
		LDI r0,0xff
		XOR r1
		STA r0,_UART_NEXT+0x7
;		USB_ERROR_STAT.b[0] &= b;
		T0X r1
		LDA r0,_USB_ERROR_STAT
		AND r1
		STA r0,_USB_ERROR_STAT
;		b = setup.wValue.b.h ^ 0xff;
		LDA r1,_setup+0x3
		LDI r0,0xff
		XOR r1
		STA r0,_UART_NEXT+0x7
;		USB_ERROR_STAT.b[1] &= b;
		T0X r1
		LDA r0,_USB_ERROR_STAT+0x1
		AND r1
		STA r0,_USB_ERROR_STAT+0x1
;		UsbSendInZero();
		JMP _UsbSendInZero
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbVendSetStatus__36:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbVendSetStatus__44 ;(+03)
		JMP _PrinterClassSetup__ef
;		{								// we're done
;		setup.bRequestType = 0xff;
;		return;
;		}
;	
;	STALL("~29", "UsbVendSetStatus: bad pid");
_UsbVendSetStatus__44:
		LDI r4,0xae ;__Lstrings+0x725
		LDI r5,0x42 ;__Lstrings+0x725>>8
		JMP _UsbStall
;
;	return;
;}
;
;void UsbVendGetStatus(void)
;{
;	if (IS_TOKEN_SETUP_DATA0)
_UsbVendGetStatus:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbVendGetStatus__2b ;(+20)
;		{
;		USB_ERROR_STAT.b[0] |= usb.errorStatus;	// add current error bits
		LDA r1,_usb+0x2
		LDA r0,_USB_ERROR_STAT
		OR  r1
		STA r0,_USB_ERROR_STAT
;		UsbSendIn(0xc0, 2, (PBYTE)&USB_ERROR_STAT, TRUE);
		LDI r0,0x4e
		STA r0,A_UsbSendIn+0x1
		LDI r0,0x52
_UsbVendGetStatus__1c:
		STA r0,A_UsbSendIn
		LDI r0,0x01
		STA r0,Aa_HostSetNextOutBdt
		LDI r2,0x02
		LDI r4,0xc0
		JMP _UsbSendIn
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbVendGetStatus__2b:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbVendGetStatus__37 ;(+01)
		RTS
;		return;							// we're done
;
;	if (IS_TOKEN_OUT_DATA1)
_UsbVendGetStatus__37:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x44
		CMP r1
		BRNE _UsbVendGetStatus__43 ;(+01)
		RTS
;		return;							// we're done
;
;	STALL("~30", "UsbVendGetStatus: bad pid");
_UsbVendGetStatus__43:
		LDI r4,0xc8 ;__Lstrings+0x73f
		LDI r5,0x42 ;__Lstrings+0x73f>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbVendSetEndPoint(void)
;{
;//	static PBDT	pBDT;
;	ONION	onion;
;	BYTE	ep;
;
;	if (IS_TOKEN_SETUP_DATA0)
_UsbVendSetEndPoint:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BREQ _UsbVendSetEndPoint__e ;(+03)
		JMP _UsbVendSetEndPoint__d6
;		{
;		ep = setup.wIndex.b.l & 0x0f;
_UsbVendSetEndPoint__e:
		LDI r1,0x0f
		LDA r0,_setup+0x4
		AND r1
		T0X r4
;		ENDPT_RG[ep] = setup.wValue.b.l;
		LDI r2,0x90 ;_ENDPT_HOST_RG
		LDI r3,0x02 ;_ENDPT_HOST_RG>>8
		TX0 r4
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDA r0,_setup+0x2
		STX r2
;#if DEBUG_STALL
;		puts("EP");
;		putb(ep);
;		putc('=');
;		putb(ENDPT_RG[ep]);
;		putCrlf();
;#endif
;
;// if the Rx enable bit was set then set the owns bit and length fields of the Rx BDT
;// So the endpoint will be ready to receive data.  If not clear the owns bits.
;
;
;#if 1
;		INIT_ONION_WITH_BDT_FOR_EP(onion,ep);	// point to BDT for specified EP
		LDI r1,0x70
		STA r1,Aa_UartReadString
		TX0 r4
		ADD r4
		ADD r0
		ADD r0
		ADD r0
		STA r0,Aa_UsbVendSetEndPoint+0x1
;
;		if (setup.wValue.b.l & 0x08)
		LDA r0,_setup+0x2
		BTT I
		BREQ _UsbVendSetEndPoint__44 ;(+0c)
;			{
;			onion.pBDT[2].pid = 0;	// clear OWNs bit in IN 0
		XOR r0
		LDA r2,Aa_UsbVendSetEndPoint+0x1
		LDA r3,Aa_UartReadString
		STO r2,0x08
;			onion.pBDT[3].pid = 0;	// clear OWNs bit in IN 1
		XOR r0
		STO r2,0x0c
_UsbVendSetEndPoint__44:
		STA r4,Aa_UsbVendSetEndPoint
;			}
;
;		if (setup.wValue.b.l & 0x04)
		LDA r0,_setup+0x2
		BTT N
		BREQ _UsbVendSetEndPoint__b6 ;(+69)
;			{
;			onion.pBDT[0].bc = 0xff;
		LDI r0,0xff
		LDA r2,Aa_UsbVendSetEndPoint+0x1
		LDA r3,Aa_UartReadString
		STO r2,0x01
;			onion.pBDT[1].bc = 0xff;
		LDI r0,0xff
		STO r2,0x05
;			onion.pBDT[0].addr.w = (WORD)USB_EPn_BUFFER0;
		LDI r0,0x78
		STO r2,0x03
		LDI r0,0x00
		STO r2,0x02
;			onion.pBDT[1].addr.w = (WORD)USB_EPn_BUFFER1;
		LDI r0,0x7c
		STO r2,0x07
		LDI r0,0x00
		STO r2,0x06
;
;			onion.pBDT[USB_NEXT_OUT[ep]&1].pid = 0x8b;		// OWN=1, DTS=1, BCH=3
		LDI r4,0x86 ;_USB_NEXT_OUT
		LDI r5,0x4e ;_USB_NEXT_OUT>>8
		LDA r0,Aa_UsbVendSetEndPoint
		LDI r1,0x00
		ADD r4
		T0X r4
		TX0 r1
		ADC r5
		T0X r5
		LDX r4
		LDI r1,0x01
		AND r1
		LDI r1,0x00
		ADD r0
		ROL r1
		ADD r0
		ROL r1
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r0,0x8b
		STX r2
;			onion.pBDT[!(USB_NEXT_OUT[ep]&1)].pid = 0xcb;	// OWN=1, DATA01=1, DTS=1, BCH=3
		LDA r2,Aa_UsbVendSetEndPoint+0x1
		LDA r3,Aa_UartReadString
		LDI r4,0x86 ;_USB_NEXT_OUT
		LDI r5,0x4e ;_USB_NEXT_OUT>>8
		LDA r0,Aa_UsbVendSetEndPoint
		LDI r1,0x00
		ADD r4
		T0X r4
		TX0 r1
		ADC r5
		T0X r5
		LDX r4
		BTT Z
		BRNE _UsbVendSetEndPoint__a7 ;(+04)
		LDI r0,0x01
		BRNE _UsbVendSetEndPoint__a8 ;(+01)
_UsbVendSetEndPoint__a7:
		XOR r0
_UsbVendSetEndPoint__a8:
		LDI r1,0x00
		ADD r0
		ROL r1
		ADD r0
		ROL r1
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r0,0xcb
		STX r2
;			}
;#else
;		pBDT = &USB_BDT_PAGE[(BYTE)(ep << 2)];	// point to BDT for specified EP
;
;		if (setup.wValue.b.l & 0x08)
;			{
;			pBDT[2].pid = 0;	// clear OWNs bit in IN 0
;			pBDT[3].pid = 0;	// clear OWNs bit in IN 1
;			}
;
;		if (setup.wValue.b.l & 0x04)
;			{
;			pBDT[0].bc = 0xff;
;			pBDT[1].bc = 0xff;
;			pBDT[0].addr.w = (WORD)USB_EPn_BUFFER0;
;			pBDT[1].addr.w = (WORD)USB_EPn_BUFFER1;
;
;			pBDT[USB_NEXT_OUT[ep]&1].pid = 0x8b;		// OWN=1, DTS=1, BCH=3
;			pBDT[!(USB_NEXT_OUT[ep]&1)].pid = 0xcb;	// OWN=1, DATA01=1, DTS=1, BCH=3
;			}
;#endif
;                SEND_DATA01[ep] = 0;  // clear the data toggle bit for data TX
_UsbVendSetEndPoint__b6:
		LDA r4,Aa_UsbVendSetEndPoint
		LDI r2,0x5d ;_SEND_DATA01
		LDI r3,0x4e ;_SEND_DATA01>>8
		TX0 r4
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		XOR r0
		STX r2
;                RECV_DATA01[ep] = 0;  // clear the data toggle bit for data RX
		LDI r2,0x59 ;_RECV_DATA01
		LDI r3,0x4e ;_RECV_DATA01>>8
		TX0 r4
_UsbVendSetEndPoint__cc:
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		XOR r0
		STX r2
;
;
;		UsbSendInZero();			// ack
		JMP _UsbSendInZero
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbVendSetEndPoint__d6:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbVendSetEndPoint__e4 ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;
;	STALL("~31", "UsbVendSetEndPoint: bad pid");
_UsbVendSetEndPoint__e4:
		LDI r4,0x76 ;__Lstrings+0x6ed
		LDI r5,0x42 ;__Lstrings+0x6ed>>8
		JMP _UsbStall
;
;	return;
;}
;
;void UsbVendGetEndPoint(void)
;{
;
;	if (IS_TOKEN_SETUP_DATA0)
_UsbVendGetEndPoint:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbVendGetEndPoint__35 ;(+2a)
;		{
;		USB_ENDPOINT_CONTROL = ENDPT_RG[setup.wIndex.b.l & 0x0f];
		LDI r2,0x90 ;_ENDPT_HOST_RG
		LDI r3,0x02 ;_ENDPT_HOST_RG>>8
		LDI r1,0x0f
		LDA r0,_setup+0x4
		AND r1
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDX r2
		STA r0,_USB_ENDPOINT_CONTROL
;		UsbSendIn(0xc0, 1, &USB_ENDPOINT_CONTROL, TRUE);
		LDI r0,0x4e
		STA r0,A_UsbSendIn+0x1
		LDI r0,0x1c
_UsbVendGetEndPoint__27:
		STA r0,A_UsbSendIn
		LDI r0,0x01
		STA r0,Aa_HostSetNextOutBdt
		T0X r2
		LDI r4,0xc0
		JMP _UsbSendIn
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbVendGetEndPoint__35:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbVendGetEndPoint__41 ;(+01)
		RTS
;		return;
;
;	if (IS_TOKEN_OUT_DATA1)
_UsbVendGetEndPoint__41:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x44
		CMP r1
		BRNE _UsbVendGetEndPoint__4d ;(+01)
		RTS
;		return;
;
;	STALL("~32", "UsbVendGetEndPoint: bad pid");
_UsbVendGetEndPoint__4d:
		LDI r4,0x92 ;__Lstrings+0x709
		LDI r5,0x42 ;__Lstrings+0x709>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbVendSetMemory(void)
;{
;// Have a problem here... since we've posted 2 buffers already, we may have 
;// already put data in buffer space and not where we really want it. It either 
;// has to be copied (slow and not a great thing to do in an interrupt routine) 
;// or we have to copy this one only and then post others to memory or never 
;// release more than 1 RX buffer. hmmm....
;// The best thing is to release only 1 RX buffer at a time. Shouldn't have an 
;// impact since we really need to know what we're doing before releasing 
;// double buffers. And we need to know how many buffers to release all together
;
;// If the PID=setup, then set the DATA1/0 bit,
;// If wLength=0, we're done so do nothing,
;// subtract 64 from wLength and post the new packet
;// and store the new wLength and wIndex out.
;// we can send.
;
;	static BYTE	b;
;
;	if (IS_TOKEN_SETUP)
_UsbVendSetMemory:
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BRNE _UsbVendSetMemory__1b ;(+10)
;		SEND_DATA01[usbSave.ep] = 0x00;
		LDI r2,0x5d ;_SEND_DATA01
		LDI r3,0x4e ;_SEND_DATA01>>8
		LDA r0,_usbSave+0xe
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		XOR r0
		STX r2
;
;	if (IS_TOKEN_IN_DATA1)
_UsbVendSetMemory__1b:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		XOR r1
		BRNE _UsbVendSetMemory__29 ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;
;	if (!setup.wLength.w)
_UsbVendSetMemory__29:
		LDA r0,_setup+0x6
		LDA r1,_setup+0x7
		OR  r1
		BRNE _UsbVendSetMemory__33 ;(+01)
		RTS
;		return;			// wlength is zero, just return.
;
;// 64 should match descriptor???
;
;	if (setup.wLength.w > 64)
_UsbVendSetMemory__33:
		LDI r1,0x41
		LDA r0,_setup+0x6
		CMP r1
		LDI r1,0x00
		LDA r0,_setup+0x7
		SBC r1
		BRCC _UsbVendSetMemory__45 ;(+04)
;		b = 64;
		LDI r0,0x40
		BRNE _UsbVendSetMemory__48 ;(+03)
;	else
;		b = setup.wLength.b.l;
_UsbVendSetMemory__45:
		LDA r0,_setup+0x6
_UsbVendSetMemory__48:
		STA r0,_UART_NEXT+0x8
;
;// need to write current buffer somewhere
;
;	setup.wLength.w -= b;
		LDI r1,0x00
		STA r0,Aa_UsbVendSetEndPoint
		STA r1,Aa_UsbVendSetEndPoint+0x1
		LDA r0,_setup+0x6
		LDA r1,Aa_UsbVendSetEndPoint
		STP C
		SBC r1
		STA r0,_setup+0x6
		LDA r0,_setup+0x7
		LDA r1,Aa_UsbVendSetEndPoint+0x1
		SBC r1
		STA r0,_setup+0x7
;	
;	return;
;}
;
;void UsbReleaseTx()
;{
;// NOT IMPLEMENTED
;	return;
;}
;
;void UsbVendGetMemory(void)
;{
_UsbReleaseTx:
		RTS
;// NOT IMPLEMENTED
;	return;
;}
;
;void UsbVendBreakOwns(void)
;{
;	static BYTE	i;
;	static PBDT	pBreakBDT;
;
;	if (IS_TOKEN_SETUP_DATA0)
_UsbVendBreakOwns:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		XOR r1
		BREQ _UsbVendBreakOwns__e ;(+03)
		JMP _UsbVendBreakOwns__9d
;		{
;		USB_BREAK_OWNS = setup.wValue.b.l;
_UsbVendBreakOwns__e:
		LDA r0,_setup+0x2
		STA r0,_USB_BREAK_OWNS
;		pBreakBDT = (PBDT)USB_BDT_PAGE;
		LDI r0,0x70
		STA r0,_usb_target_psr+0x24
		LDI r0,0x00
		STA r0,_usb_target_psr+0x23
;		pBreakBDT += 4;
		LDI r1,0x10
		ADD r1
		STA r0,_usb_target_psr+0x23
		LDA r0,_usb_target_psr+0x24
		LDI r1,0x00
		ADC r1
		STA r0,_usb_target_psr+0x24
;		for (i=ENDPOINTS; i; i--)
		LDI r0,0x04
		BRNE _UsbVendBreakOwns__92 ;(+61)
;			{
;			if (USB_BREAK_OWNS)
_UsbVendBreakOwns__31:
		LDA r0,_USB_BREAK_OWNS
		BREQ _UsbVendBreakOwns__5a ;(+24)
;				{
;				pBreakBDT->pid &= 0x7f;
		LDI r1,0x7f
		LDA r2,_usb_target_psr+0x23
		LDA r3,_usb_target_psr+0x24
		LDX r2
		AND r1
		STX r2
;				pBreakBDT++;
		TX0 r2
		LDI r1,0x04
		ADD r1
		STA r0,_usb_target_psr+0x23
		TX0 r3
		LDI r1,0x00
		ADC r1
		STA r0,_usb_target_psr+0x24
;				pBreakBDT->pid &= 0x7f;
		LDI r1,0x7f
		LDA r2,_usb_target_psr+0x23
		T0X r3
		LDX r2
		AND r1
		JMP _UsbVendBreakOwns__7b
;				}
;			else
;				{
;				pBreakBDT->pid |= 0x80;
_UsbVendBreakOwns__5a:
		LDI r1,0x80
		LDA r2,_usb_target_psr+0x23
		LDA r3,_usb_target_psr+0x24
		LDX r2
		OR  r1
		STX r2
;				pBreakBDT++;
		TX0 r2
		LDI r1,0x04
		ADD r1
		STA r0,_usb_target_psr+0x23
		TX0 r3
		LDI r1,0x00
		ADC r1
		STA r0,_usb_target_psr+0x24
;				pBreakBDT->pid |= 0x80;
		LDI r1,0x80
		LDA r2,_usb_target_psr+0x23
		T0X r3
		LDX r2
		OR  r1
_UsbVendBreakOwns__7b:
		STX r2
;				}
;			pBreakBDT += 3;
		LDA r0,_usb_target_psr+0x23
		LDI r1,0x0c
		ADD r1
		STA r0,_usb_target_psr+0x23
		LDA r0,_usb_target_psr+0x24
		LDI r1,0x00
		ADC r1
		STA r0,_usb_target_psr+0x24
		LDA r0,_UART_NEXT+0x9
		DEC r0
_UsbVendBreakOwns__92:
		STA r0,_UART_NEXT+0x9
		LDA r0,_UART_NEXT+0x9
		BRNE _UsbVendBreakOwns__31 ;(-69)
;			}
;		UsbSendInZero();			// ack
		JMP _UsbSendInZero
;		return;
;		}
;
;	if (IS_TOKEN_IN_DATA1)
_UsbVendBreakOwns__9d:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x64
		CMP r1
		BRNE _UsbVendBreakOwns__ab ;(+03)
		JMP _PrinterClassSetup__ef
;		{
;		setup.bRequestType = 0xff;
;		return;
;		}
;
;	STALL("~33", "UsbVendBreakOwns: bad pid");
_UsbVendBreakOwns__ab:
		LDI r4,0xe2 ;__Lstrings+0x759
		LDI r5,0x42 ;__Lstrings+0x759>>8
		JMP _UsbStall
;	return;
;}
;
;void UsbEnableReset()
;{
;	usb.intEnable = 1;				// enable only bus reset
_UsbEnableReset:
		LDI r0,0x01
		STA r0,_usb+0x1
;}
		RTS
;
;//////// the following are not called from the usb int service vector ////////
;
;void UsbInit()
;{
;// USBInit initializes the USB interface.
;// the BDTs are NOT intialized here! They are initialized as they are enabled.
;	static ONION	onion;
;
;#if WANT_HARDWARE
;#if DEBUG_STATE
;	puts("UsbInit:\r\n");
;#endif	// DEBUG_STATE
;#endif	// WANT_HARDWARE
;
;	usb.control = 0;		// disable the VUSB
_UsbInit:
		XOR r0
		STA r0,_usb+0x5
;	usb.intEnable = 0;		// mask all interupts
		STA r0,_usb+0x1
;
;	usbSave.ep = 0;
		STA r0,_usbSave+0xe
;
;	USB_MAX_PACKET[0] = USB_BUFFER_SIZE;
		LDA r0,_USB_BUFFER_SIZE
		LDI r1,0x00
		STA r1,_USB_MAX_PACKET+0x1
		STA r0,_USB_MAX_PACKET
;	USB_DEVICE_DESC[7] = USB_BUFFER_SIZE;
		LDA r0,_USB_BUFFER_SIZE
		STA r0,_USB_DEVICE_DESC+0x7
;
;//	USB_HUB_CONFIG_DESC[2] = sizeof(USB_HUB_CONFIG_DESC) & 0xff;
;//	USB_HUB_CONFIG_DESC[3] = sizeof(USB_HUB_CONFIG_DESC) >> 8;
;
;//	USB_DEBUG = 1;			// 0=debug messages off, 1=on
;	USB_DUMP = 0;
		XOR r0
		STA r0,_USB_DUMP
;	USB_STATE = 0;			// Current USB state (POWERED,DEFAULT,ADDRESS,CONFIG,SUSPEND)
		STA r0,_USB_STATE
;	USB_CURR_CONFIG = 0;	// Current USB configuration selected
		STA r0,_USB_CURR_CONFIG
;	USB_SOF_CTR = 0xffff;	// reserve 2 bytes for a frame counter
		LDI r0,0xff
		STA r0,_USB_SOF_CTR+0x1
		STA r0,_USB_SOF_CTR
;	USB_SOF_ENB = 0;		// SOF checking is enabled when non zero
		XOR r0
		STA r0,_USB_SOF_ENB
;
;	memset(SEND_DATA01, 0x00, ENDPOINTS);	// stores the Data1/0 PID
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x5d ;_SEND_DATA01
		LDI r5,0x4e ;_SEND_DATA01>>8
		JSR _memset
;	memset(RECV_DATA01, 0x00, ENDPOINTS);	// stores the Data1/0 PID
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x59 ;_RECV_DATA01
		LDI r5,0x4e ;_RECV_DATA01>>8
		JSR _memset
;	USB_ERROR_STAT.w = 0;	// error status
		XOR r0
		STA r0,_USB_ERROR_STAT+0x1
		STA r0,_USB_ERROR_STAT
;	AUDIO_BC = 0;			// 16 bit counter of the number of bytes sent down
		STA r0,_AUDIO_BC+0x1
		STA r0,_AUDIO_BC
;	USB_BYTES = 0;
		STA r0,_USB_BYTES
;	USB_BREAK_OWNS = 0;		// 1 if non-EP0's should not set owns bit
		STA r0,_USB_BREAK_OWNS
;	USB_ENDPOINT_CONTROL = 0;	// value returned from GetEndpoint
		STA r0,_USB_ENDPOINT_CONTROL
;
;	memset(USB_NEXT_OUT, 0, ENDPOINTS);
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x86 ;_USB_NEXT_OUT
		LDI r5,0x4e ;_USB_NEXT_OUT>>8
		JSR _memset
;	memset(USB_LAST_OUT, 0xff, ENDPOINTS);
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0xff
		LDI r4,0x7e ;_USB_LAST_OUT
		LDI r5,0x4e ;_USB_LAST_OUT>>8
		JSR _memset
;	memset(USB_NEXT_IN, 0, ENDPOINTS);
		LDI r0,0x04
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x82 ;_USB_NEXT_IN
		LDI r5,0x4e ;_USB_NEXT_IN>>8
		JSR _memset
;
;	// alternate settings for up to USB_NUM_IFACES interfaces
;	USB_IF_ALT[0] = USB_IF_ALT[1] = USB_IF_ALT[2] = 0;
		XOR r0
		STA r0,_pDataOut+0x4
		STA r0,_pDataOut+0x3
		STA r0,_pDataOut+0x2
;
;	// USB_PRINTER variables
;	USB_PRN_RUN = 0;	// 0=no buffer actively printing
		STA r0,_USB_DEBUG+0x1
;	USB_PRN_READ = NULL;	// current position in the buffer
		STA r0,_USB_DEBUG+0x3
		STA r0,_USB_DEBUG+0x2
;	USB_PRN_END = NULL;	// last position in the buffer
		STA r0,_USB_DEBUG+0x5
		STA r0,_USB_DEBUG+0x4
;	USB_PRN_PTR = 0;	// Pointer to the USB BDT in use
		STA r0,_USB_DEBUG+0x7
		STA r0,_USB_DEBUG+0x6
;
;	setup.bRequestType = 0xff;
		LDI r0,0xff
		STA r0,_setup
;	USB_ERROR_CTR[0] = USB_ERROR_CTR[1] = USB_ERROR_CTR[2] = USB_ERROR_CTR[3] = 
;	USB_ERROR_CTR[4] = USB_ERROR_CTR[5] = USB_ERROR_CTR[6] = USB_ERROR_CTR[7] = 0;
		XOR r0
		STA r0,_USB_ERROR_CTR+0xf
		STA r0,_USB_ERROR_CTR+0xe
		LDA r0,_USB_ERROR_CTR+0xf
		STA r0,_USB_ERROR_CTR+0xd
		LDA r0,_USB_ERROR_CTR+0xe
		STA r0,_USB_ERROR_CTR+0xc
		LDA r0,_USB_ERROR_CTR+0xd
		STA r0,_USB_ERROR_CTR+0xb
		LDA r0,_USB_ERROR_CTR+0xc
		STA r0,_USB_ERROR_CTR+0xa
		LDA r0,_USB_ERROR_CTR+0xb
		STA r0,_USB_ERROR_CTR+0x9
		LDA r0,_USB_ERROR_CTR+0xa
		STA r0,_USB_ERROR_CTR+0x8
		LDA r0,_USB_ERROR_CTR+0x9
		STA r0,_USB_ERROR_CTR+0x7
		LDA r0,_USB_ERROR_CTR+0x8
		STA r0,_USB_ERROR_CTR+0x6
		LDA r0,_USB_ERROR_CTR+0x7
		STA r0,_USB_ERROR_CTR+0x5
		LDA r0,_USB_ERROR_CTR+0x6
		STA r0,_USB_ERROR_CTR+0x4
		LDA r0,_USB_ERROR_CTR+0x5
		STA r0,_USB_ERROR_CTR+0x3
		LDA r0,_USB_ERROR_CTR+0x4
		STA r0,_USB_ERROR_CTR+0x2
		LDA r0,_USB_ERROR_CTR+0x3
		STA r0,_USB_ERROR_CTR+0x1
		LDA r0,_USB_ERROR_CTR+0x2
		STA r0,_USB_ERROR_CTR
;	USB_DUMP_COUNT = 0xf0;		// number of ints to dump
		LDI r0,0xf0
		STA r0,_USB_DUMP_COUNT
;	USB_STATUS_DEVICE = 1;		// Device status = self-powered.
		XOR r0
		STA r0,_USB_DEBUG+0x9
		INC r0
		STA r0,_USB_DEBUG+0x8
;#if DEBUG_USB_STATUS_DEVICE
;	puts("UsbInit: USB_STATUS_DEVICE=");
;	putb(USB_STATUS_DEVICE);
;	putCrlf();
;#endif //DEBUG_USB_STATUS_DEVICE
;	USB_STATUS_INTERFACE = 0;	// interface status
		XOR r0
		STA r0,_USB_DEBUG+0xb
		STA r0,_USB_DEBUG+0xa
;	USB_STATUS_ENDPOINT = 0;	// EP status
		STA r0,_USB_DEBUG+0xd
		STA r0,_USB_DEBUG+0xc
;
;
;// Quickly do a register read/write test to the 8 bit ErrorEnable register.
;// If its fully read/write we know the interface works.
;
;#if WANT_HARDWARE
;	if (!UsbRegRW(0xaa))
		LDI r4,0xaa
		JSR _UsbRegRW
		T0X r1
		BRNE _UsbInit__12f ;(+01)
		RTS
;		return;
;	if (!UsbRegRW(0x55))
_UsbInit__12f:
		LDI r4,0x55
		JSR _UsbRegRW
		T0X r1
		BRNE _UsbInit__138 ;(+01)
		RTS
;		return;
;	if (!UsbRegRW(0xf0))
_UsbInit__138:
		LDI r4,0xf0
		JSR _UsbRegRW
		T0X r1
		BRNE _UsbInit__141 ;(+01)
		RTS
;		return;
;	if (!UsbRegRW(0x0f))
_UsbInit__141:
		LDI r4,0x0f
		JSR _UsbRegRW
		T0X r1
		BRNE _UsbInit__14a ;(+01)
		RTS
;		return;
;#endif
;
;	if (!UsbRegRW(0x7f))
_UsbInit__14a:
		LDI r4,0x7f
		JSR _UsbRegRW
		T0X r1
		BRNE _UsbInit__153 ;(+01)
		RTS
;		return;
;
;#if WANT_FIFO_TEST
;	{
;	BYTE	b;
;	// test FIFO
;	USB_FIFO_TEST = 1;
;// test RX
;	USB_FIFO_RX = 0xaa;
;	USB_FIFO_RX = 0x55;
;	USB_FIFO_RX = 0x1;
;	USB_FIFO_RX = 0x2;
;	b = USB_FIFO_RX;
;	if (b != 0xaa)
;		{
;		puts("rxFifo expected aa, got ");
;		putb(b);
;		putCrlf();
;		}
;	b = USB_FIFO_RX;
;	if (b != 0x55)
;		{
;		puts("rxFifo expected 55, got ");
;		putb(b);
;		putCrlf();
;		}
;	b = USB_FIFO_RX;
;	if (b != 0x01)
;		{
;		puts("rxFifo expected 01, got ");
;		putb(b);
;		putCrlf();
;		}
;	b = USB_FIFO_RX;
;	if (b != 0x02)
;		{
;		puts("rxFifo expected 02, got ");
;		putb(b);
;		putCrlf();
;		}
;// test TX
;	USB_FIFO_TX = 0xaa;
;	USB_FIFO_TX = 0x55;
;	USB_FIFO_TX = 0x1;
;	USB_FIFO_TX = 0x2;
;	b = USB_FIFO_TX;
;	if (b != 0xaa)
;		{
;		puts("txFifo expected aa, got ");
;		putb(b);
;		putCrlf();
;		}
;	b = USB_FIFO_TX;
;	if (b != 0x55)
;		{
;		puts("txFifo expected 55, got ");
;		putb(b);
;		putCrlf();
;		}
;	b = USB_FIFO_TX;
;	if (b != 0x01)
;		{
;		puts("txFifo expected 01, got ");
;		putb(b);
;		putCrlf();
;		}
;	b = USB_FIFO_TX;
;	if (b != 0x02)
;		{
;		puts("txFifo expected 02, got ");
;		putb(b);
;		putCrlf();
;		}
;
;	USB_FIFO_TEST = 0;
;	}
;#endif
;
;// OK, assume the USB SIE is functional... and leave 0x7f in usb.errorEnable
;
;// clear the USB buffer memory - OPTIONAL!
;#if WANT_HARDWARE
;	memset((PBYTE)USB_BUFFER, 0x90, 0xa8);
_UsbInit__153:
		LDI r0,0xa8
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x90
		LDI r4,0x00 ;_USB_BUFFER
		LDI r5,0x74 ;_USB_BUFFER>>8
		JSR _memset
;#endif
;
;// insert the interrupt service routine into the proper vector
;	Interrupt1 = (WORD)UsbTargetIntService;
		LDI r0,0x22
		STA r0,_Interrupt1+0x1
		LDI r0,0xbc
		STA r0,_Interrupt1
;
;#if WANT_HUB
;	Interrupt2 = (WORD)HubFrameIntService;
;#endif
;
;	usb.address = 0;
		XOR r0
		STA r0,_usb+0x6
;	speed = 0;
		STA r0,_speed
;//	usb.bdtPage = ((WORD)USB_BDT_PAGE) >> 8;
;	onion.pBDT = USB_BDT_PAGE;
		LDI r0,0x70
		STA r0,_usb_target_psr+0x26
		LDI r0,0x00
		STA r0,_usb_target_psr+0x25
;	usb.bdtPage = onion.b.h;
		LDA r0,_usb_target_psr+0x26
		STA r0,_usb+0x7
;
;// disable all endpoints
;	memset((PBYTE)&ENDPT_RG[0], ENDPOINTS, ENDPT_DISABLE);
		XOR r0
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x04
		LDI r4,0x90 ;_ENDPT_HOST_RG
		LDI r5,0x02 ;_ENDPT_HOST_RG>>8
		JSR _memset
;
;	USB_STATE = POWERED_STATE;	// we are now in the powered state
		LDI r0,0x03
		STA r0,_USB_STATE
;#if WANT_HARDWARE
;#if DEBUG_STATE
;	puts("Usb:POWERED_STATE\r\n");
;#endif	// DEBUG_STATE
;#endif	// WANT_HARDWARE
;
;	usb.intStatus = 0xfe;			// Clear all interrupts except RESET
		LDI r0,0xfe
		STA r0,_usb
;
;// init some BDTs
;	memset((PBYTE)USB_BDT_PAGE, 128, 0);
		XOR r0
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x80
		LDI r4,0x00 ;_USB_BDT_PAGE
		LDI r5,0x70 ;_USB_BDT_PAGE>>8
		JSR _memset
;
;	USB_SOF_ENB = 1;			// enable SOF checking to start with...
		LDI r0,0x01
		STA r0,_USB_SOF_ENB
;	USB_PRN_RUN = 0;			// clear printer buffer operation
		XOR r0
		STA r0,_USB_DEBUG+0x1
;	*(PBYTE)0x7d30 = 0;			// clear printer buffers
		STA r0,_USB_EPn_BUFFER1+0x130
;	*(PBYTE)0x7d34 = 0;			// clear printer buffers
		STA r0,_USB_EPn_BUFFER1+0x134
;	usb.control = 1;					//WORD  =the//VUSB
		LDI r0,0x01
		STA r0,_usb+0x5
;
;// All done... We're now in POWERED state and ready to go to DEFAULT.
;// if debug mode, send a message
;#if WANT_HARDWARE
;	if (USB_DEBUG)
		LDA r0,_USB_DEBUG
		BREQ _UsbInit__1c6 ;(+07)
;		puts("USB Enabled\r\n\a");
		LDI r4,0x8c ;__Lstrings+0xa03
		LDI r5,0x45 ;__Lstrings+0xa03>>8
		JMP _puts
;#endif	// WANT_HARDWARE
;	//moved outside usbInit
;	// 	usb.intEnable = 1;				// enable only bus reset
;
;#if WANT_HUB
;	HubReset(1);
;#endif
;
;	return;
_UsbInit__1c6:
		RTS
;}
;
;BOOL UsbRegRW(BYTE b)
;{
;// Very quick register READ/WRITE test of the 8 bit R/W USB registers.
;// write R0+reg offset to 6 registers, then read it.
;	static BYTE b2;
;#if !WANT_LITE
;	int iFailCount = 0;
_UsbRegRW:
		STA r4,Aa_UsbVendSetEndPoint
		XOR r0
		STA r0,Aa_UartReadString
		STA r0,Aa_UsbVendSetEndPoint+0x1
;
;repeat:
;#endif
;	usb.errorEnable = b;	//save the expected value
_UsbRegRW__a:
		LDA r0,Aa_UsbVendSetEndPoint
		STA r0,_usb+0x3
;	b2 = usb.errorEnable;
		LDA r0,_usb+0x3
		STA r0,_UART_NEXT+0xa
;	if (b == b2)
		T0X r1
		LDA r0,Aa_UsbVendSetEndPoint
		XOR r1
		BRNE _UsbRegRW__20 ;(+03)
;		return TRUE;
		LDI r0,0x01
		RTS
;#if WANT_LITE
;	puts(" \aUSB Failed BIST\r\n");
;	return FALSE;
;#else
;	iFailCount++;
_UsbRegRW__20:
		LDA r2,Aa_UsbVendSetEndPoint+0x1
		LDA r3,Aa_UartReadString
		UPP r2
;	if (iFailCount == 1)
		STA r2,Aa_UsbVendSetEndPoint+0x1
		STA r3,Aa_UartReadString
		TX0 r2
		DEC r0
		OR  r3
		BRNE _UsbRegRW__52 ;(+20)
;		{
;		puts("\r\n\aERROR:USB Failed BIST\r\n\aExpected=");
		LDI r4,0x8b ;__Lstrings+0x902
		LDI r5,0x44 ;__Lstrings+0x902>>8
		JSR _puts
;		putb(b);
		LDA r4,Aa_UsbVendSetEndPoint
		JSR _putb
;		puts(" Actual=");
		LDI r4,0x7d ;__Lstrings+0x8f4
		LDI r5,0x44 ;__Lstrings+0x8f4>>8
		JSR _puts
;		putb(b2);
		LDA r4,_UART_NEXT+0xa
		JSR _putb
;		putFlush();
		JSR _putFlush
;		}
		JMP _UsbRegRW__70
;	else
;		{
;		putw(iFailCount);
_UsbRegRW__52:
		LDA r4,Aa_UsbVendSetEndPoint+0x1
		LDA r5,Aa_UartReadString
		JSR _putw
;		iFailCount++;
		LDA r0,Aa_UsbVendSetEndPoint+0x1
		LDA r1,Aa_UartReadString
		UPP r0
		STA r0,Aa_UsbVendSetEndPoint+0x1
		STA r1,Aa_UartReadString
;		if (UartCharWaiting())
		JSR _UartCharWaiting
		T0X r1
		BREQ _UsbRegRW__70 ;(+02)
;			return FALSE;
		XOR r0
		RTS
;		}
;	putCrlf();
_UsbRegRW__70:
		JSR _putCrlf
;	goto repeat;
		JMP _UsbRegRW__a
;#endif
;}
;
;void UsbCheckForSuspend(void)
;{
;//	static ONION tx;
;
;	if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
_UsbCheckForSuspend:
		LDA r0,_usbSave+0xd
		BTT I
		BREQ _UsbCheckForSuspend__17 ;(+11)
;		if (IS_TOKEN_SETUP)		// if it is a setup token
		LDI r1,0x3c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x34
		CMP r1
		BRNE _UsbCheckForSuspend__17 ;(+06)
;			if (usbSave.control & MASK_CTL_TXD_SUSPEND)	// and the txd_suspend bit is set
		LDA r0,_usbSave+0x5
		BTT 5
;				{								// dequeue any pending packets
;//				tx.b.h = usbSave.bdtPage;
;//				tx.b.l = (usbSave.status & 0xf8) | 0x08;	// even tx bdt
;				UsbDequeue();
		BRNE _UsbDequeue ;(+01)
;				}
;}
_UsbCheckForSuspend__17:
		RTS
;
;void UsbDequeue()
;{
;	static ONION	onion;
;	static BYTE		i;
;
;	onion.bdt.page = usbSave.bdtPage;
_UsbDequeue:
		LDA r1,_usbSave+0x7
		LDI r0,0xff
		AND r1
		T0X r2
		LDA r0,_usb_target_psr+0x28
		XOR r0
		OR  r2
		STA r0,_usb_target_psr+0x28
;	onion.b.l = 0;	// clear zero, odd, out
		XOR r0
		STA r0,_usb_target_psr+0x27
;	onion.bdt.ep = usbSave.ep;
		LDA r2,_usbSave+0xe
		LDI r0,0x0f
		AND r2
		T0X r2
		LDA r0,_usb_target_psr+0x27
		ROR r0
		ROR r0
		ROR r0
		ROR r0
		LDI r1,0xf0
		AND r1
		OR  r2
		ROL r0
		ROL r0
		ROL r0
		ROL r0
		STA r0,_usb_target_psr+0x27
;
;	bExtraRxBDT[usbSave.ep] = FALSE;	// there is no longer an extra RX BDT
		LDI r2,0x2f ;_bExtraRxBDT
		LDI r3,0x48 ;_bExtraRxBDT>>8
		LDA r0,_usbSave+0xe
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		XOR r0
		STX r2
;
;	for (i=0; i<4; i++)
		XOR r0
		STA r0,_UART_NEXT+0xb
		LDI r1,0x04
		LDA r0,_UART_NEXT+0xb
		CMP r1
		BRCS _UsbDequeue__70 ;(+28)
;		{
;#if DEBUG_DEQUEUE
;		if (onion.pBDT->pid & 0x80)
;			{
;			puto(onion);
;			puts(" - dequeueing\r\n");
;			}
;#endif // DEBUG_DEQUEUE
;		onion.pBDT->pid = 0x00;
_UsbDequeue__48:
		XOR r0
		LDA r2,_usb_target_psr+0x27
		LDA r3,_usb_target_psr+0x28
		STX r2
;		onion.pBDT->bc = 0;
		XOR r0
		STO r2,0x01
;
;// there's no point in clearing the address, provideRxBDT would just have to set it again
;//		onion.pBDT->addr.w = 0;
;		onion.pBDT++;
		TX0 r2
		LDI r1,0x04
		ADD r1
		STA r0,_usb_target_psr+0x27
		TX0 r3
		LDI r1,0x00
		ADC r1
		STA r0,_usb_target_psr+0x28
		LDA r0,_UART_NEXT+0xb
		INC r0
		STA r0,_UART_NEXT+0xb
		LDI r1,0x04
		LDA r0,_UART_NEXT+0xb
		CMP r1
		BRCC _UsbDequeue__48 ;(-28)
;		}
;
;// clear endpoint stall bit here
;
;	usb.control &= ~MASK_CTL_TXD_SUSPEND;	// clear the txd_suspend bit
_UsbDequeue__70:
		LDI r1,0xdf
		LDA r0,_usb+0x5
		AND r1
		STA r0,_usb+0x5
;	usbSave.control = usb.control;
		LDA r0,_usb+0x5
		STA r0,_usbSave+0x5
;
;	USB_NEXT_OUT[usbSave.ep] = USB_LAST_OUT[usbSave.ep] + 1;
		LDI r2,0x86 ;_USB_NEXT_OUT
		LDI r3,0x4e ;_USB_NEXT_OUT>>8
		LDA r0,_usbSave+0xe
		LDI r1,0x00
		ADD r2
		T0X r2
		TX0 r1
		ADC r3
		T0X r3
		LDI r4,0x7e ;_USB_LAST_OUT
		LDI r5,0x4e ;_USB_LAST_OUT>>8
		LDA r0,_usbSave+0xe
		ADD r4
		T0X r4
		TX0 r1
		ADC r5
		T0X r5
		LDX r4
		INC r0
		STX r2
;
;	return;
		RTS
;}
;
;#if WANT_PRINTER
;typedef struct
;	{
;	BYTE	spare:3,	// 0-2
;			fault_n:1,	// 3
;			select:1,	// 4
;			perror:1;	// 5
;	} PRINTER_CLASS_PORT_STATUS;
;
;PRINTER_CLASS_PORT_STATUS printerClassPortStatus;
;
;void PrinterClassSetup()
;{
;// process class specific SETUP transactions on EP0.
;#if DEBUG_CLASS_SETUP
;	puts("PrinterClassSetup: rt=");
;	putb(setup.bRequestType);
;	puts(" r=");
;	putbs(setup.bRequest);
;	putws(setup.wValue.w);
;	putws(setup.wIndex.w);
;	putw(setup.wLength.w);
;	putCrlf();
;#endif
;
;	if (setup.bRequestType == 0x23 && setup.bRequest == 0x02)
_PrinterClassSetup:
		LDI r1,0x23
		LDA r0,_setup
		XOR r1
		BRNE _PrinterClassSetup__39 ;(+31)
		LDI r1,0x02
		LDA r0,_setup+0x1
		XOR r1
		BRNE _PrinterClassSetup__39 ;(+29)
		JMP _PrinterClassSetup__1c
;		{	// SoftReset(0,      interface, 0,       none)
;			//           wValue, wIndex,    wLength, Data
;		switch (cBDT.pid & 0x7c)
;			{
;			case 0x34:	// SETUP
;				Init1284();
_PrinterClassSetup__13:
		JSR _Init1284
;				InitPrinterEndpoints();
		JSR _InitPrinterEndpoints
;
;				UsbSendInZero();
		JMP _UsbSendInZero
_PrinterClassSetup__1c:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x00
		BREQ _PrinterClassSetup__31 ;(+0b)
_PrinterClassSetup__26:
		TX0 r1
		LDI r4,0xcc
		ADD r4
		BREQ _PrinterClassSetup__13 ;(-19)
		LDI r4,0xd0
		JMP _PrinterClassSetup__111
_PrinterClassSetup__31:
		PSH r0
		TX0 r1
		POP r1
		BREQ _PrinterClassSetup__26 ;(-10)
		JMP _PrinterClassSetup__11c
;				goto done;
;
;			case 0x64:		// In token, DATA phase
;				goto done;
;			}
;		goto booboo;
;		}
;
;	if (setup.bRequestType == 0xa1 && setup.bRequest == 0x00)
_PrinterClassSetup__39:
		LDI r1,0xa1
		LDA r0,_setup
		XOR r1
		BRNE _PrinterClassSetup__82 ;(+41)
		LDA r0,_setup+0x1
		BRNE _PrinterClassSetup__82 ;(+3c)
		JMP _PrinterClassSetup__5f
;		{	// GetDeviceID(config index, ifc & alt, Max length, 1284 device id string)
;			//             wValue,       wIndex,    wLength,    Data
;		switch (cBDT.pid & 0x7c)
;			{
;			case 0x34:		// SETUP token,send the data packet
;				UsbSendIn(0xc0, DEVICE_ID_LENGTH, DEVICE_ID_1284, FALSE);
_PrinterClassSetup__49:
		LDI r0,0x4c
		STA r0,A_UsbSendIn+0x1
		LDI r0,0xf8
		STA r0,A_UsbSendIn
		XOR r0
		STA r0,Aa_HostSetNextOutBdt
		LDA r2,_DEVICE_ID_LENGTH
		LDI r4,0xc0
		JMP _UsbSendIn
_PrinterClassSetup__5f:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x00
		BREQ _PrinterClassSetup__7a ;(+11)
_PrinterClassSetup__69:
		TX0 r1
		LDI r4,0xdc
		ADD r4
		BRNE _PrinterClassSetup__72 ;(+03)
		JMP _PrinterClassSetup__135
_PrinterClassSetup__72:
		LDI r4,0xf0
		ADD r4
		BREQ _PrinterClassSetup__49 ;(-2e)
		JMP _PrinterClassSetup__10a
_PrinterClassSetup__7a:
		PSH r0
		TX0 r1
		POP r1
		BREQ _PrinterClassSetup__69 ;(-16)
		JMP _PrinterClassSetup__11c
;				break;
;			case 0x64:		// In token, DATA phase
;			case 0x24:		// In token, DATA phase
;				break;
;			case 0x44:		// OUT token, Status phase, we're done
;				setup.bRequestType = 0xff;
;				break;
;			default:
;				goto booboo;
;			}
;		goto done;
;		}
;
;	if (setup.bRequestType == 0xa1 && setup.bRequest == 0x01)
_PrinterClassSetup__82:
		LDI r1,0xa1
		LDA r0,_setup
		CMP r1
		BREQ _PrinterClassSetup__8d ;(+03)
		JMP _PrinterClassSetup__11c
_PrinterClassSetup__8d:
		LDI r1,0x01
		LDA r0,_setup+0x1
		CMP r1
		BREQ _PrinterClassSetup__98 ;(+03)
		JMP _PrinterClassSetup__11c
_PrinterClassSetup__98:
		JMP _PrinterClassSetup__f5
;		{	// GetPortStatus(0, ifc,    1,       byte)
;			//                  wIndex, wLength, Data
;		switch (cBDT.pid & 0x7c)
;			{
;			case 0x34:		// SETUP token,send the data packet
;				*(PBYTE)&printerClassPortStatus = 0;
_PrinterClassSetup__9b:
		STA r0,_printerClassPortStatus
;				printerClassPortStatus.perror = PP_CTL.perror;
		LDA r0,_PP_CTL
		ROR r0
		ROR r0
		LDI r4,0x01
		AND r4
		ROR r0
		LDA r0,_printerClassPortStatus
		LDI r1,0x20
		OR  r1
		BRCS _PrinterClassSetup__b0 ;(+01)
		XOR r1
_PrinterClassSetup__b0:
		STA r0,_printerClassPortStatus
;				printerClassPortStatus.select = PP_CTL.select;
		LDA r0,_PP_CTL
		ROR r0
		LDI r4,0x01
		AND r4
		ROR r0
		LDA r0,_printerClassPortStatus
		LDI r1,0x10
		OR  r1
		BRCS _PrinterClassSetup__c4 ;(+01)
		XOR r1
_PrinterClassSetup__c4:
		STA r0,_printerClassPortStatus
;				printerClassPortStatus.fault_n = PP_CTL.fault_n;
		LDA r0,_PP_CTL
		LDI r4,0x01
		AND r4
		ROR r0
		LDA r0,_printerClassPortStatus
		LDI r1,0x08
		OR  r1
		BRCS _PrinterClassSetup__d7 ;(+01)
		XOR r1
_PrinterClassSetup__d7:
		STA r0,_printerClassPortStatus
;				UsbSendIn(0xc0, 1, (PBYTE)&printerClassPortStatus, FALSE);
		LDI r0,0x4e
		STA r0,A_UsbSendIn+0x1
		LDI r0,0x20
		STA r0,A_UsbSendIn
		XOR r0
		STA r0,Aa_HostSetNextOutBdt
		LDI r2,0x01
		LDI r4,0xc0
		JMP _UsbSendIn
;				break;
;			case 0x64:		// In token, DATA phase
;			case 0x24:		// In token, DATA phase
;				break;
;			case 0x44:		// OUT token, Status phase, we're done
;				setup.bRequestType = 0xff;
_PrinterClassSetup__ef:
		LDI r0,0xff
		STA r0,_setup
;				break;
		RTS
_PrinterClassSetup__f5:
		LDI r1,0x7c
		LDA r0,_cBDT
		AND r1
		LDI r1,0x00
		BREQ _PrinterClassSetup__117 ;(+18)
_PrinterClassSetup__ff:
		TX0 r1
		LDI r4,0xdc
		ADD r4
		BREQ _PrinterClassSetup__135 ;(+30)
		LDI r4,0xf0
		ADD r4
		BREQ _PrinterClassSetup__9b ;(-6f)
_PrinterClassSetup__10a:
		LDI r4,0xf0
		ADD r4
		BREQ _PrinterClassSetup__ef ;(-20)
		LDI r4,0xe0
_PrinterClassSetup__111:
		ADD r4
		BREQ _PrinterClassSetup__135 ;(+21)
		JMP _PrinterClassSetup__11c
_PrinterClassSetup__117:
		PSH r0
		TX0 r1
		POP r1
		BREQ _PrinterClassSetup__ff ;(-1d)
;			default:
;				goto booboo;
;			}
;		goto done;
;		}
;
;
;booboo:
;	putbs(cBDT.pid);
_PrinterClassSetup__11c:
		LDA r4,_cBDT
		JSR _putbs
;	putbs(setup.bRequestType);
		LDA r4,_setup
		JSR _putbs
;	putbs(setup.bRequest);
		LDA r4,_setup+0x1
		JSR _putbs
;	PUTS("~35", "PrinterClassSetup: Bad PID");
		LDI r4,0x27 ;__Lstrings+0x89e
		LDI r5,0x44 ;__Lstrings+0x89e>>8
		JMP _puts
;	goto done;
;
;done:
;	return;
;}
_PrinterClassSetup__135:
		RTS
;
;void InitPrinterEndpoints()
;{
;static PBDT	pBDT;
;
;	// init BDT for EP3
;	pBDT = (PBDT)&USB_BDT_PAGE[ENDPOINT_PRINTER*4+0];	// EP3 out even
_InitPrinterEndpoints:
		LDI r0,0x70
		STA r0,_usb_target_psr+0x2a
		LDI r0,0x30
		STA r0,_usb_target_psr+0x29
;	pBDT[0].pid = pBDT[1].pid = 0x80;
		LDI r0,0x80
		LDA r2,_usb_target_psr+0x29
		LDA r3,_usb_target_psr+0x2a
		STO r2,0x04
		LDO r2,0x04
		STX r2
;	pBDT[0].bc = pBDT[1].bc = 64;		// BC=64
		LDI r0,0x40
		STO r2,0x05
		LDO r2,0x05
		STO r2,0x01
;	pBDT[0].addr.pb = USB_PRINTER_BUFF;
		LDI r0,0x73
		STO r2,0x03
		LDI r0,0x00
		STO r2,0x02
;	pBDT[1].addr.pb = USB_PRINTER_BUFF + 0x40;
		LDI r0,0x73
		STO r2,0x07
		LDI r0,0x40
		STO r2,0x06
;	memset((PBYTE)&USB_BDT_PAGE[ENDPOINT_PRINTER*4+2], 0, 8);	// clear in bdts
		LDI r0,0x08
		STA r0,Aa_UsbVendSetEndPoint
		LDI r2,0x00
		LDI r4,0x38 ;_USB_BDT_PAGE+0x38
		LDI r5,0x70 ;_USB_BDT_PAGE+0x38>>8
		JSR _memset
;	ENDPT_RG[ENDPOINT_PRINTER] = ENDPT_BULK_BIDIR;
		LDI r0,0x0d
		STA r0,_ENDPT_HOST_RG+0x3
;	USB_PRN_RUN = 0;
_InitPrinterEndpoints__42:
		XOR r0
		STA r0,_USB_DEBUG+0x1
;	return;
		RTS
;From-C:\HOME\MARK\C_VUSB\SOFTWARE\SRC\VAUTO.C
;// vauto.c
;
;#include "vauto.h"
;#include "uart.h"
;
;// The following hard-coded locations MUST be editted
;// if your memory map is not the vautomation default.
;// To find all such locations in the c source code, grep for '@'.
;
;volatile BYTE	CONTROL_REG			@0x0202;
;
;volatile WORD	Interrupt0			@0x0400;	// interupt vector 0
;volatile WORD	Interrupt1			@0x0402;	// interupt vector 1
;volatile WORD	Interrupt2			@0x0404;	// interupt vector 2
;volatile WORD	Interrupt3			@0x0406;	// interupt vector 3
;volatile WORD	Interrupt4			@0x0408;	// interupt vector 4
;volatile WORD	Interrupt5			@0x040a;	// interupt vector 5
;volatile WORD	Interrupt6			@0x040c;	// interupt vector 6
;volatile WORD	Interrupt7			@0x040e;	// interupt vector 7
;
;BYTE stack @0x300; // put a label at the base of the stack
;
;WORD	start;
;
;BYTE shift[8] = {0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80};
;
;// various helper functions
;
;void DOWNLOAD()
;{
;#if 0
;{
;	int		i=0;
;	char	c;
;	
;	while (UartCharWaiting())
;		{
;		i++;
;		c = UartReadChar();
;		}
;
;	putws(i);
;}
;#endif
;
;	puts("Ready to download\r\n");
_DOWNLOAD:
		LDI r4,0x9b ;__Lstrings+0xa12
		LDI r5,0x45 ;__Lstrings+0xa12>>8
		JSR _puts
;	putFlush();
		JSR _putFlush
;	
;
;	asm("stp 3");	// turn off interrupts
		STP I
;	CONTROL_REG = 0;
		XOR r0
		STA r0,_CONTROL_REG
;{
;//	int i;
;//	for (i=0; i<10000; i++)
;		*(PBYTE)&uartStatus = 0;	// disable uart interrupts
		STA r0,_uartStatus
;}
;
;#asm
;	jmp 0x0088	; Jump to the ROM download routine.
		JMP __Lreset+0x88
;#endasm
;	// note that we never come back here as we are probably
;	// overwritting this code which is in SRAM. (And it's a JMP)
;}
;
;// init p[0] - p[len-1] with val
;
;// p = r45, val=r2, len=?_memset
;void memset(PBYTE p, BYTE val, BYTE len)
;{
;#if 0
;	while (len--)
;		*p++ = val;
;#else
;#asm
;		tx0 r2			; r0 = val
_memset:
		TX0 r2
;		lda r1,?_memset	; r1 = len
		LDA r1,Aa_UsbVendSetEndPoint
;		breq memset2
		BREQ _memset__b ;(+05)
;memset1:
;		stx r4
_memset__6:
		STX r4
;		upp r4
		UPP r4
;		dec r1
		DEC r1
;		brne memset1
		BRNE _memset__6 ;(-05)
;memset2:
;#endasm
;#endif
;	return;
;}
_memset__b:
		RTS
		.byte 0xa6
		.byte 0x4f
;
;// pd = r45, ps = r23, len=?_memcpy
;void memcpy(PBYTE pd, PBYTE ps, BYTE len)
;{
;#if 0
;	while (len--)
;		{
;		*pd++ = *ps++;
;		}
;#else
;#asm
;		lda r1,?_memcpy	; r1 = len
_memcpy:
		LDA r1,Aa_UsbVendSetEndPoint
;		breq memcpy2
		BREQ _memcpy__c ;(+07)
;memcpy1:
;		ldx r2			; r0 = *ps
_memcpy__5:
		LDX r2
;		upp r2
		UPP r2
;		stx r4
		STX r4
;		upp r4
		UPP r4
;		dec r1
		DEC r1
;		brne memcpy1
		BRNE _memcpy__5 ;(-07)
;memcpy2:
;#endasm
;#endif
;	return;
;}
_memcpy__c:
		RTS
;
;BYTE	disabledCount = 0;
;
;void disableInterrupts()
;{
;
;//	CONTROL_REG = 0xc0;		// disable interrupts
;	disabledCount++;
_disableInterrupts:
		LDA r0,_disabledCount
		INC r0
		STA r0,_disabledCount
;	return;
		RTS
;}
;
;void enableInterrupts()
;{
;// we can AssUMe that interrupts are currently disabled.
;// the programmer is REQUIRED to call disable before enable.
;	disabledCount--;
_enableInterrupts:
		LDA r0,_disabledCount
		DEC r0
		STA r0,_disabledCount
;//	if (!disabledCount)
;//		CONTROL_REG = 0xc8;		// enable interrupts
;	return;
;}
;
;
;void stuff()
;{
_stuff:
		RTS
powerup:
		JMP start
__Lstrings:	.byte 0x20
__Lstrings+0x1:	.string "not implemented\0"
__Lstrings+0x11:	.string "NY\0"
__Lstrings+0x14:	.string "Addr:\0"
__Lstrings+0x1a:	.string "\r\n"
		.string "Int7 \0"
__Lstrings+0x22:	.string "\r\n"
		.string "Int6 \0"
__Lstrings+0x2a:	.string "\r\n"
		.string "Int4 \0"
__Lstrings+0x32:	.string "\r\n"
		.string "Int3 \0"
__Lstrings+0x3a:	.string "\r\n"
		.string "Int2 \0"
__Lstrings+0x42:	.string "\r\n"
		.string "Int1 \0"
__Lstrings+0x4a:	.string "\r\n"
		.string "Int0 \0"
__Lstrings+0x52:	.string "x>     Exit\r\n\0"
__Lstrings+0x60:	.string "0> N = interrupts\r\n\0"
__Lstrings+0x74:	.string "4> N = SOF Errors\r\n\0"
__Lstrings+0x88:	.string "\aHigh bit stuck\r\n\0"
__Lstrings+0x9a:	.string "2> N = Host State\r\n\0"
__Lstrings+0xae:	.string "3> N = Hub State\r\n\0"
__Lstrings+0xc1:	.string " done\r\n\0"
__Lstrings+0xc9:	.string "1> N = send\r\n\0"
__Lstrings+0xd7:	.string "\r\n"
		.string "Regression test SKIPPED\r\n\0"
__Lstrings+0xf3:	.string "\r\n"
		.string "AUDIO DEMO MENU\r\n"
		.string "c = Capture 32kb\r\n"
		.string "i = Init ad1845\r\n"
		.string "p = Playback 32kb\r\n"
		.string "r = Register read\r\n"
		.string "s = Sawtooth playback data\r\n"
		.string "+ = Inc freq\r\n"
		.string "- = Dec freq\r\n"
		.string "= = Show Freq\r\n"
		.string "x = Exit\0"
__Lstrings+0x19f:	.string "AUDIO CHIP still initing\r\n\0"
__Lstrings+0x1ba:	.string "=Max, Capture done\r\n\0"
__Lstrings+0x1cf:	.string "AUDIO CHIP inited\r\n\0"
__Lstrings+0x1e3:	.string "?\r\n"
		.string "\r\n\0"
__Lstrings+0x1e9:	.string "HDAD: usb.control=\0"
__Lstrings+0x1fc:	.string "MetaState61: todo.wLength=\0"
__Lstrings+0x217:	.string "Got port status:\0"
__Lstrings+0x228:	.string "Invalid meta state:\0"
__Lstrings+0x23c:	.string "Configured device:\0"
__Lstrings+0x24f:	.string "Rsv \0"
__Lstrings+0x254:	.string "Dev \0"
__Lstrings+0x259:	.string "Int \0"
__Lstrings+0x25e:	.string "contains \0"
__Lstrings+0x268:	.string "Cls \0"
__Lstrings+0x26d:	.string "todo \0"
__Lstrings+0x273:	.string "Should have been \0"
__Lstrings+0x285:	.string "Oth \0"
__Lstrings+0x28a:	.string "Std \0"
__Lstrings+0x28f:	.string "Vnd \0"
__Lstrings+0x294:	.string "End \0"
__Lstrings+0x299:	.string "reserved \0"
__Lstrings+0x2a3:	.string "GET_STAT \0"
__Lstrings+0x2ad:	.string "SET_FEAT \0"
__Lstrings+0x2b7:	.string "CLR_FEAT \0"
__Lstrings+0x2c1:	.string "SYNCH_FR \0"
__Lstrings+0x2cb:	.string "SET_ADDR \0"
__Lstrings+0x2d5:	.string "D>H \0"
__Lstrings+0x2da:	.string "SET_CONF \0"
__Lstrings+0x2e4:	.string "GET_CONF \0"
__Lstrings+0x2ee:	.string "H>D \0"
__Lstrings+0x2f3:	.string "SET_DESC \0"
__Lstrings+0x2fd:	.string "GET_DESC \0"
__Lstrings+0x307:	.string "USB_HOST_STATE = \0"
__Lstrings+0x319:	.string "USB_META_STATE = \0"
__Lstrings+0x32b:	.string "USB_META_STATE_WANTED = \0"
__Lstrings+0x344:	.string "MetaState60: \0"
__Lstrings+0x352:	.string "unknown  \0"
__Lstrings+0x35c:	.string "SET_IFC  \0"
__Lstrings+0x366:	.string "GET_IFC  \0"
__Lstrings+0x370:	.string "\r\n"
		.string "delay timed out\r\n\0"
__Lstrings+0x384:	.string "End of Chapter 9 test\r\n\0"
__Lstrings+0x39c:	.string "Enable echo has been sent\r\n\0"
__Lstrings+0x3b8:	.string "Should have been zero\r\n\0"
__Lstrings+0x3d0:	.string "Host mode init is done\r\n\0"
__Lstrings+0x3e9:	.string "todo is done\r\n\0"
__Lstrings+0x3f8:	.string "Value hosed\r\n\0"
__Lstrings+0x406:	.string "\r\n"
		.string "MetaState11: about to doAReset()\r\n\0"
__Lstrings+0x42b:	.string "\r\n"
		.string "Starting Chapter 9 test on address 1!\r\n\0"
__Lstrings+0x455:	.string "\r\n"
		.string "\a\0"
__Lstrings+0x459:	.string " \aEEPROM written\r\n\0"
__Lstrings+0x46c:	.string "\r\n"
		.string "Copying SRAM to EEPROM\r\n\0"
__Lstrings+0x487:	.string " \aEEPROM write FAILED\r\n\0"
__Lstrings+0x49f:	.string " \aget1284id: Printer is not 1284 compliant\r\n\0"
__Lstrings+0x4cc:	.string "\r\n"
		.string "\aget1284id: too long\r\n\0"
__Lstrings+0x4e5:	.string "\r\n"
		.string "\aNo printer found\r\n\0"
__Lstrings+0x4fb:	.string "\r\n"
		.string "\aget1284id: Printer has no data (2)\r\n\0"
__Lstrings+0x523:	.string "\r\n"
		.string "\aget1284id: Printer has no data (1)\r\n\0"
__Lstrings+0x54b:	.string " = Unknown Command\r\n\0"
__Lstrings+0x560:	.string "Up\r\n\0"
__Lstrings+0x565:	.string "UsbAddress: bad request\0"
__Lstrings+0x57d:	.string "UsbVendor: bad bRequest\0"
__Lstrings+0x595:	.string "UsbTokenDoneEP0: bad bRequest\0"
__Lstrings+0x5b3:	.string "UsbSetFeature: bad own\0"
__Lstrings+0x5ca:	.string "UsbClearFeature: bad own\0"
__Lstrings+0x5e3:	.string "UsbGetStatus BAD own\0"
__Lstrings+0x5f8:	.string "UsbSetConfig\0"
__Lstrings+0x605:	.string " - UsbGetDescription: bad wValue\0"
__Lstrings+0x626:	.string "UsbTokenDoneEPn: bad bRequestType\0"
__Lstrings+0x648:	.string "UsbGetConfig: bad bRequestType\0"
__Lstrings+0x667:	.string "UsbSynchFrame: bad bRequestType\0"
__Lstrings+0x687:	.string "UsbSetInterface: bad bRequestType\0"
__Lstrings+0x6a9:	.string "UsbGetInterface: bad bRequestType\0"
__Lstrings+0x6cb:	.string "UsbTokenDoneEP0: bad bRequestType\0"
__Lstrings+0x6ed:	.string "UsbVendSetEndPoint: bad pid\0"
__Lstrings+0x709:	.string "UsbVendGetEndPoint: bad pid\0"
__Lstrings+0x725:	.string "UsbVendSetStatus: bad pid\0"
__Lstrings+0x73f:	.string "UsbVendGetStatus: bad pid\0"
__Lstrings+0x759:	.string "UsbVendBreakOwns: bad pid\0"
__Lstrings+0x773:	.string "UsbTokenDoneEP1_Speaker: bad pid\0"
__Lstrings+0x794:	.string "UsbSynchFrame: bad pid\0"
__Lstrings+0x7ab:	.string "UsbSetInterface: bad pid\0"
__Lstrings+0x7c4:	.string "UsbGetInterface: bad pid\0"
__Lstrings+0x7dd:	.string "SUSPEND not supported\0"
__Lstrings+0x7f3:	.string "UsbSetDescription: not implemented\0"
__Lstrings+0x816:	.string "UsbSetFeature: not CLR_ENDPOINT\0"
__Lstrings+0x836:	.string "UsbClearFeature: not CLR_ENDPOINT\0"
__Lstrings+0x858:	.string "UNEXPECTED BIT IN INT_STAT\0"
__Lstrings+0x873:	.string "UsbGetConfig Bad PID\0"
__Lstrings+0x888:	.string "UsbGetStatus: Bad PID\0"
__Lstrings+0x89e:	.string "PrinterClassSetup: Bad PID\0"
__Lstrings+0x8b9:	.string "UsbGetDescription: Bad PID\0"
__Lstrings+0x8d4:	.string "UsbSetConfig: Bad PID\0"
__Lstrings+0x8ea:	.string "USC:Addr=\0"
__Lstrings+0x8f4:	.string " Actual=\0"
__Lstrings+0x8fd:	.string "pid=\0"
__Lstrings+0x902:	.string "\r\n"
		.string "\aERROR:USB Failed BIST\r\n"
		.string "\aExpected=\0"
__Lstrings+0x927:	.string "I=\0"
__Lstrings+0x92a:	.string "!=\0"
__Lstrings+0x92d:	.string "\a\r\n"
		.string "Error:\0"
__Lstrings+0x937:	.string "\aError:\0"
__Lstrings+0x93f:	.string "UsbSetAddress: not In Data1\0"
__Lstrings+0x95b:	.string "UsbSetFeature: wValue not 0\0"
__Lstrings+0x977:	.string "UsbClearFeature: wValue not 0\0"
__Lstrings+0x995:	.string "UsbAddress: EP not 0\0"
__Lstrings+0x9aa:	.string " - stalling\r\n\0"
__Lstrings+0x9b8:	.string "Attach ignored\r\n\0"
__Lstrings+0x9c9:	.string " - USB Buffer not OWNed\r\n\0"
__Lstrings+0x9e3:	.string "UsbConfig: BDT owned by host\r\n"
		.string "\a\0"
__Lstrings+0xa03:	.string "USB Enabled\r\n"
		.string "\a\0"
__Lstrings+0xa12:	.string "Ready to download\r\n\0"
_debug:	.byte 0x01
		.byte 0x00
_MainMenuString:	.byte 0x0d
_MainMenuString+0x1:	.string "\n"
		.string "a = Audio demo Menu\r\n"
		.string "c = Clear LEDs\r\n"
		.string "d = Debug flags\r\n"
		.string "m = Modify RAM\r\n"
		.string "p = Print a test page to 1284 port\r\n"
		.string "P = read Printer registers\r\n"
		.string "s = Show Stack\r\n"
		.string "u = USB Menu\r\n"
		.string "w = write SRAM to EEPROM\r\n"
		.string ": = Download HEX File\r\n"
		.string "? = Help - Rev Nov 17 1999 12:01:51\r\n\0"
_examineAddress:	.byte 0x00
_examineAddress+0x1:	.byte 0x03
_A_TABLE:	.byte 0xa0
		.byte 0xa0
		.byte 0x9f
		.byte 0x9f
		.byte 0x9f
		.byte 0x9f
		.byte 0x00
		.byte 0x00
		.byte 0x53
		.byte 0xc9
		.byte 0x00
		.byte 0x00
		.byte 0x40
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x91
		.byte 0x10
		.byte 0x9f
		.byte 0x9f
		.byte 0x00
		.byte 0x00
		.byte 0x2a
		.byte 0xf8
		.byte 0x00
		.byte 0x00
		.byte 0x11
		.byte 0x08
		.byte 0x50
		.byte 0x00
		.byte 0x00
_A_TABLE+0x1f:	.byte 0x00
_HOST_WAIT:	.byte 0xfa
_HOST_WAIT+0x1:	.byte 0x00
_USB_BUFFERED_BDT:	.byte 0x00
_USB_BUFFERED_BDT+0x1:	.byte 0x00
_USB_BUFFERED_BDT+0x2:	.byte 0x00
_USB_BUFFERED_BDT+0x3:	.byte 0x00
_USB_PRINTER_ENDPOINT:	.byte 0x03
_tx_get_desc_device:	.byte 0x80
		.byte 0x06
		.byte 0x00
		.byte 0x01
		.byte 0x00
_tx_get_desc_device+0x5:	.byte 0x00
_tx_get_desc_device+0x6:	.byte 0x12
_tx_get_desc_device+0x7:	.byte 0x00
_tx_get_desc_config:	.byte 0x80
		.byte 0x06
		.byte 0x00
		.byte 0x02
_tx_get_desc_config+0x4:	.byte 0x00
		.byte 0x00
		.byte 0xff
		.byte 0x01
_tx_get_desc_string:	.byte 0x80
		.byte 0x06
		.byte 0x00
		.byte 0x03
		.byte 0x00
		.byte 0x00
		.byte 0xff
		.byte 0x00
_tx_set_config:	.byte 0x00
_tx_set_config+0x1:	.byte 0x09
_tx_set_config+0x2:	.byte 0x01
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
_tx_get_config:	.byte 0x80
		.byte 0x08
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x01
		.byte 0x00
_tx_set_port_feature:	.byte 0x23
		.byte 0x03
_tx_set_port_feature+0x2:	.byte 0x00
_tx_set_port_feature+0x3:	.byte 0x00
_tx_set_port_feature+0x4:	.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
_tx_get_port_status:	.byte 0xa3
		.byte 0x00
		.byte 0x00
_tx_get_port_status+0x3:	.byte 0x00
_tx_get_port_status+0x4:	.byte 0x00
		.byte 0x00
		.byte 0x04
		.byte 0x00
_tx_enable_echo:	.byte 0x40
		.byte 0x02
		.byte 0x1d
		.byte 0x00
		.byte 0x02
		.byte 0x00
		.byte 0x00
		.byte 0x00
_rx_null_packet:	.byte 0x12
_rx_null_packet+0x1:	.string "4Vx"
_UsbMenuString:	.byte 0x0d
_UsbMenuString+0x1:	.string "\n"
		.string "USB Menu\r\n"
		.string "c = Clear Int Stat\r\n"
		.string "e = Enable echo test (50)\r\n"
		.string "g = Get EP2 data\r\n"
		.string "i = Init\r\n"
		.string "l = Show last 16 packets\r\n"
		.string "q = Queue EP2 data\r\n"
		.string "r = Register dump\r\n"
		.string "v = Show internal variables\r\n"
		.string "x = Return to top level menu\r\n"
		.string "! = Dump next 16 interrupts\r\n\0"
_LastHexWord:	.byte 0x10
_LastHexWord+0x1:	.byte 0x04
_linebuf:	.byte 0xee
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
_linebuf+0x1f:	.byte 0x00
_USB_BUFFER_SIZE:	.byte 0x40
_bExtraRxBDT:	.byte 0x00
		.byte 0x00
		.byte 0x00
_bExtraRxBDT+0x3:	.byte 0x00
_USB_MAX_PACKET:	.byte 0x00
_USB_MAX_PACKET+0x1:	.byte 0x00
		.byte 0x30
		.byte 0x00
		.byte 0xff
		.byte 0x03
_USB_MAX_PACKET+0x6:	.byte 0x40
_USB_MAX_PACKET+0x7:	.byte 0x00
_USB_DEBUG:	.byte 0x01
_USB_DEBUG+0x1:	.byte 0xee
_USB_DEBUG+0x2:	.byte 0xee
_USB_DEBUG+0x3:	.byte 0xee
_USB_DEBUG+0x4:	.byte 0xee
_USB_DEBUG+0x5:	.byte 0xee
_USB_DEBUG+0x6:	.byte 0xee
_USB_DEBUG+0x7:	.byte 0xee
_USB_DEBUG+0x8:	.byte 0xee
_USB_DEBUG+0x9:	.byte 0xee
_USB_DEBUG+0xa:	.byte 0xee
_USB_DEBUG+0xb:	.byte 0xee
_USB_DEBUG+0xc:	.byte 0xee
_USB_DEBUG+0xd:	.byte 0xee
_USB_DEBUG+0xe:	.byte 0x00
		.byte 0x03
		.byte 0x09
		.byte 0x04
_USB_DEBUG+0x12:	.byte 0x00
_USB_DEBUG+0x13:	.byte 0x00
		.byte 0x03
		.byte 0x56
		.byte 0x00
		.byte 0x41
		.byte 0x00
		.byte 0x75
		.byte 0x00
		.byte 0x74
		.byte 0x00
		.byte 0x6f
		.byte 0x00
		.byte 0x6d
		.byte 0x00
		.byte 0x61
		.byte 0x00
		.byte 0x74
		.byte 0x00
		.byte 0x69
		.byte 0x00
		.byte 0x6f
		.byte 0x00
		.byte 0x6e
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x49
		.byte 0x00
		.byte 0x6e
		.byte 0x00
		.byte 0x63
		.byte 0x00
_USB_DEBUG+0x33:	.byte 0x00
_USB_DEBUG+0x34:	.byte 0x00
		.byte 0x03
		.byte 0x56
		.byte 0x00
		.byte 0x55
		.byte 0x00
		.byte 0x53
		.byte 0x00
		.byte 0x42
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x53
		.byte 0x00
		.byte 0x79
		.byte 0x00
		.byte 0x6e
		.byte 0x00
		.byte 0x74
		.byte 0x00
		.byte 0x68
		.byte 0x00
		.byte 0x65
		.byte 0x00
		.byte 0x73
		.byte 0x00
		.byte 0x69
		.byte 0x00
		.byte 0x7a
		.byte 0x00
		.byte 0x61
		.byte 0x00
		.byte 0x62
		.byte 0x00
		.byte 0x6c
		.byte 0x00
		.byte 0x65
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x43
		.byte 0x00
		.byte 0x6f
		.byte 0x00
		.byte 0x72
		.byte 0x00
		.byte 0x65
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x44
		.byte 0x00
		.byte 0x65
		.byte 0x00
		.byte 0x6d
		.byte 0x00
		.byte 0x6f
		.byte 0x00
_USB_DEBUG+0x6e:	.byte 0x00
_USB_DEBUG+0x6f:	.byte 0x00
		.byte 0x03
		.byte 0x42
		.byte 0x00
		.byte 0x45
		.byte 0x00
		.byte 0x54
		.byte 0x00
		.byte 0x41
		.byte 0x00
_USB_DEBUG+0x79:	.byte 0x00
_USB_DEBUG+0x7a:	.byte 0x00
		.byte 0x03
		.byte 0x23
		.byte 0x00
		.byte 0x30
		.byte 0x00
		.byte 0x32
		.byte 0x00
_USB_DEBUG+0x82:	.byte 0x00
_USB_DEBUG+0x83:	.byte 0x00
		.byte 0x03
		.byte 0x5f
		.byte 0x00
		.byte 0x41
		.byte 0x00
		.byte 0x31
		.byte 0x00
_USB_DEBUG+0x8b:	.byte 0x00
_USB_DEBUG+0x8c:	.byte 0x00
		.byte 0x03
		.byte 0x50
		.byte 0x00
		.byte 0x31
		.byte 0x00
		.byte 0x32
		.byte 0x00
		.byte 0x38
		.byte 0x00
		.byte 0x34
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x50
		.byte 0x00
		.byte 0x72
		.byte 0x00
		.byte 0x69
		.byte 0x00
		.byte 0x6e
		.byte 0x00
		.byte 0x74
		.byte 0x00
		.byte 0x65
		.byte 0x00
		.byte 0x72
		.byte 0x00
_USB_DEBUG+0xa8:	.byte 0x00
_USB_DEBUG+0xa9:	.byte 0x00
		.byte 0x03
		.byte 0x43
		.byte 0x00
		.byte 0x6f
		.byte 0x00
		.byte 0x6d
		.byte 0x00
		.byte 0x70
		.byte 0x00
		.byte 0x6f
		.byte 0x00
		.byte 0x73
		.byte 0x00
		.byte 0x69
		.byte 0x00
		.byte 0x74
		.byte 0x00
		.byte 0x65
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x48
		.byte 0x00
		.byte 0x75
		.byte 0x00
		.byte 0x62
		.byte 0x00
_USB_DEBUG+0xc5:	.byte 0x00
_USB_DEBUG+0xc6:	.byte 0x00
		.byte 0x03
		.byte 0x56
		.byte 0x00
		.byte 0x41
		.byte 0x00
		.byte 0x75
		.byte 0x00
		.byte 0x74
		.byte 0x00
		.byte 0x6f
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x50
		.byte 0x00
		.byte 0x72
		.byte 0x00
		.byte 0x69
		.byte 0x00
		.byte 0x6e
		.byte 0x00
		.byte 0x74
		.byte 0x00
		.byte 0x65
		.byte 0x00
		.byte 0x72
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x44
		.byte 0x00
		.byte 0x6f
		.byte 0x00
		.byte 0x6e
		.byte 0x00
		.byte 0x67
		.byte 0x00
		.byte 0x6c
		.byte 0x00
		.byte 0x65
		.byte 0x00
_USB_DEBUG+0xf0:	.byte 0x00
_USB_DEBUG+0xf1:	.byte 0x00
		.byte 0x03
		.byte 0x42
		.byte 0x00
		.byte 0x41
		.byte 0x00
		.byte 0x44
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x53
		.byte 0x00
		.byte 0x54
		.byte 0x00
		.byte 0x52
		.byte 0x00
		.byte 0x49
		.byte 0x00
		.byte 0x4e
		.byte 0x00
		.byte 0x47
		.byte 0x00
		.byte 0x20
		.byte 0x00
		.byte 0x49
		.byte 0x00
		.byte 0x6e
		.byte 0x00
		.byte 0x64
		.byte 0x00
		.byte 0x65
		.byte 0x00
		.byte 0x78
		.byte 0x00
		.byte 0x00
_USB_DEBUG+0x114:	.string "IHNHoH"
		.byte 0xaa
		.byte 0x48
		.byte 0xb5
		.byte 0x48
		.byte 0xbe
		.byte 0x48
		.byte 0xc7
		.byte 0x48
		.byte 0xe4
		.byte 0x48
		.byte 0x01
_USB_DEBUG+0x125:	.byte 0x49
_USB_DEBUG+0x126:	.byte 0x2c
_USB_DEBUG+0x127:	.byte 0x49
_USB_DEVICE_DESC:	.byte 0x12
		.byte 0x01
		.byte 0x00
		.byte 0x01
		.byte 0x00
		.byte 0x00
_USB_DEVICE_DESC+0x6:	.byte 0x00
_USB_DEVICE_DESC+0x7:	.byte 0xff
		.byte 0xa3
		.byte 0x05
		.byte 0x01
		.byte 0x01
		.byte 0x00
		.byte 0x00
		.byte 0x01
		.byte 0x02
		.byte 0x03
		.byte 0x01
_USB_CONFIG_DESC:	.byte 0x09
		.byte 0x02
		.byte 0x9d
		.byte 0x00
		.byte 0x03
_USB_CONFIG_DESC+0x5:	.byte 0x01
		.byte 0x04
		.byte 0xc0
		.byte 0x00
		.byte 0x09
		.byte 0x04
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x01
		.byte 0x01
		.byte 0x00
		.byte 0x00
		.byte 0x09
		.byte 0x24
		.byte 0x01
		.byte 0x09
		.byte 0x00
		.byte 0x1e
		.byte 0x00
		.byte 0x01
		.byte 0x01
		.byte 0x0c
		.byte 0x24
		.byte 0x02
		.byte 0x01
		.byte 0x01
		.byte 0x01
		.byte 0x00
		.byte 0x02
		.byte 0x03
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x09
		.byte 0x24
		.byte 0x03
		.byte 0x02
		.byte 0x01
		.byte 0x03
		.byte 0x00
		.byte 0x01
		.byte 0x00
		.byte 0x09
		.byte 0x04
		.byte 0x01
		.byte 0x00
		.byte 0x01
		.byte 0x01
		.byte 0x02
		.byte 0x00
		.byte 0x04
		.byte 0x07
		.byte 0x24
		.byte 0x01
		.byte 0x01
		.byte 0x00
		.byte 0x00
		.byte 0x01
		.byte 0x0b
		.byte 0x24
		.byte 0x02
		.byte 0x01
		.byte 0x02
		.byte 0x02
		.byte 0x10
		.byte 0x01
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x09
		.byte 0x05
		.byte 0x01
		.byte 0x09
		.byte 0x00
		.byte 0x00
		.byte 0x01
		.byte 0x00
		.byte 0x00
		.byte 0x07
		.byte 0x25
		.byte 0x01
		.byte 0x00
		.byte 0x02
		.byte 0x01
		.byte 0x00
		.byte 0x09
		.byte 0x04
		.byte 0x01
		.byte 0x01
		.byte 0x01
		.byte 0x01
		.byte 0x02
		.byte 0x00
		.byte 0x05
		.byte 0x07
		.byte 0x24
		.byte 0x01
		.byte 0x01
		.byte 0x00
		.byte 0x01
		.byte 0x00
		.byte 0x0b
		.byte 0x24
		.byte 0x02
		.byte 0x01
		.byte 0x02
		.byte 0x02
		.byte 0x10
		.byte 0x01
		.byte 0x11
		.byte 0x2b
		.byte 0x00
		.byte 0x09
		.byte 0x05
		.byte 0x01
_USB_CONFIG_DESC+0x79:	.string "\t0\0"
		.byte 0x01
		.byte 0x00
		.byte 0x00
		.byte 0x07
		.byte 0x25
		.byte 0x01
		.byte 0x00
		.byte 0x02
		.byte 0x01
		.byte 0x00
		.byte 0x09
		.byte 0x04
		.byte 0x02
		.byte 0x00
		.byte 0x02
		.byte 0x07
		.byte 0x01
		.byte 0x02
		.byte 0x08
		.byte 0x07
		.byte 0x05
		.byte 0x03
		.byte 0x02
		.byte 0x40
		.byte 0x00
		.byte 0x00
		.byte 0x07
		.byte 0x05
		.byte 0x83
		.byte 0x02
		.byte 0x40
		.byte 0x00
_USB_CONFIG_DESC+0x9c:	.byte 0x00
_wDataOut:	.byte 0xee
_wDataOut+0x1:	.byte 0x00
_tx_set_addr:	.byte 0x00
_tx_set_addr+0x1:	.byte 0x05
_tx_set_addr+0x2:	.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
		.byte 0x00
_shift:	.byte 0x01
		.byte 0x02
		.byte 0x04
		.byte 0x08
		.byte 0x10
		.byte 0x20
		.byte 0x40
		.byte 0x80
	.org 0x4a24
__Lbss:
	.org 0x4a25
__Lbss+0x1:
	.org 0x4a26
__Lbss+0x2:
	.org 0x4a27
__Lbss+0x3:
	.org 0x4a28
__Lbss+0x4:
	.org 0x4a29
__Lbss+0x5:
	.org 0x4a2a
__Lbss+0x6:
	.org 0x4a2b
_pch:
	.org 0x4a2c
_pcl:
	.org 0x4a2d
_psr:
	.org 0x4a2e
_psr+0x1:
	.org 0x4a2f
_psr+0x2:
	.org 0x4a30
_psr+0x3:
	.org 0x4a31
_psr+0x4:
	.org 0x4a32
_psr+0x5:
	.org 0x4a33
_psr+0x6:
	.org 0x4a34
_psr+0x7:
	.org 0x4a35
_psr+0x8:
	.org 0x4a36
_psr+0x9:
	.org 0x4a37
_psr+0xa:
	.org 0x4a38
_psr+0xb:
	.org 0x4a39
_psr+0xc:
	.org 0x4a3a
_psr+0xd:
	.org 0x4a3b
_psr+0xe:
	.org 0x4a3c
_psr+0xf:
	.org 0x4a3d
_psr+0x10:
	.org 0x4a3e
_psr+0x11:
	.org 0x4a3f
_psr+0x12:
	.org 0x4a40
_psr+0x13:
	.org 0x4a41
_psr+0x14:
	.org 0x4a42
_psr+0x15:
	.org 0x4a43
_psr+0x16:
	.org 0x4a44
_psr+0x17:
	.org 0x4a45
_psr+0x18:
	.org 0x4a46
_psr+0x19:
	.org 0x4a47
_psr+0x1a:
	.org 0x4a48
_psr+0x1b:
	.org 0x4a49
_psr+0x1c:
	.org 0x4a4a
_psr+0x1d:
	.org 0x4a4b
_psr+0x1e:
	.org 0x4a4c
_psr+0x1f:
	.org 0x4a4d
_psr+0x20:
	.org 0x4a4e
_psr+0x21:
	.org 0x4a4f
_psr+0x22:
	.org 0x4a50
_psr+0x23:
	.org 0x4a51
_psr+0x24:
	.org 0x4a52
_USB_ARE_WE_ATTACHED:
	.org 0x4a53
_USB_BUFFERED:
	.org 0x4a54
_USB_BUFFERED_ADDRESS:
	.org 0x4a55
_USB_BUFFERED_TOKEN:
	.org 0x4a56
_USB_BUFFERED_TYPE:
	.org 0x4a57
_USB_CURRENT_ADDR:
	.org 0x4a58
_USB_CURRENT_CONFIG:
	.org 0x4a59
_USB_DUMP_bIfaceClass:
	.org 0x4a5a
_USB_DUMP_bIfaceSubClass:
	.org 0x4a5b
_USB_DUMP_bNumEndPoints:
	.org 0x4a5c
_USB_HOST_STATE:
	.org 0x4a5d
_USB_IN:
	.org 0x4a5e
_USB_META_STATE:
	.org 0x4a5f
_USB_META_STATE_WANTED:
	.org 0x4a60
_USB_NEXT_ADDR:
	.org 0x4a61
_USB_NEXT_DATA01:
	.org 0x4a62
_USB_NUM_CONFIGS:
	.org 0x4a63
_USB_OUT:
	.org 0x4a64
_bItsAHub:
	.org 0x4a65
_bSomethingTodo:
	.org 0x4a66
_rx_get_config:
	.org 0x4a67
_speed:
	.org 0x4a68
_speed+0x1:
	.org 0x4a69
_speed+0x2:
	.org 0x4a6a
_speed+0x3:
	.org 0x4a6b
_speed+0x4:
	.org 0x4a6c
_speed+0x5:
	.org 0x4a6d
_speed+0x6:
	.org 0x4a6e
_speed+0x7:
	.org 0x4a6f
_speed+0x8:
	.org 0x4a70
_speed+0x9:
	.org 0x4a71
_speed+0xa:
	.org 0x4a72
_speed+0xb:
	.org 0x4a73
_speed+0xc:
	.org 0x4a74
_speed+0xd:
	.org 0x4a75
_speed+0xe:
	.org 0x4a76
_speed+0xf:
	.org 0x4a77
_speed+0x10:
	.org 0x4a78
_USB_IN_WANTED:
	.org 0x4a7a
_USB_PACKET_LENGTH_MODE:
	.org 0x4a7b
_USB_PACKET_LENGTH_MODE+0x1:
	.org 0x4a7c
_rx_buffer:
	.org 0x4a7d
_rx_buffer+0x1:
	.org 0x4a7e
_rx_port_status:
	.org 0x4a7f
_rx_port_status+0x1:
	.org 0x4a80
_rx_port_status+0x2:
	.org 0x4a81
_rx_port_status+0x3:
	.org 0x4a82
_todo:
	.org 0x4a83
_todo+0x1:
	.org 0x4a84
_todo+0x2:
	.org 0x4a85
_todo+0x3:
	.org 0x4a87
_todo+0x5:
	.org 0x4a88
_todo+0x6:
	.org 0x4a89
_todo+0x7:
	.org 0x4a8c
_todo+0xa:
	.org 0x4a8d
_todo+0xb:
	.org 0x4a8e
_rx_desc_device:
	.org 0x4a92
_rx_desc_device+0x4:
	.org 0x4a9f
_rx_desc_device+0x11:
	.org 0x4aa0
_todoBuffer:
	.org 0x4ae0
_rx_desc_config:
	.org 0x4ae2
_rx_desc_config+0x2:
	.org 0x4ae3
_rx_desc_config+0x3:
	.org 0x4ce9
_rx_desc_config+0x209:
	.org 0x4cea
_rx_desc_config+0x20a:
	.org 0x4ceb
_rx_desc_config+0x20b:
	.org 0x4cec
_rx_desc_config+0x20c:
	.org 0x4ced
_rx_desc_config+0x20d:
	.org 0x4cee
_rx_desc_config+0x20e:
	.org 0x4cef
_rx_desc_config+0x20f:
	.org 0x4cf0
_rx_desc_config+0x210:
	.org 0x4cf1
_rx_desc_config+0x211:
	.org 0x4cf2
_rx_desc_config+0x212:
	.org 0x4cf3
_rx_desc_config+0x213:
	.org 0x4cf4
_rx_desc_config+0x214:
	.org 0x4cf5
_DEVICE_ID_LENGTH:
	.org 0x4cf6
_USB_PRINTER_MODE:
	.org 0x4cf7
_newCtl1284:
	.org 0x4cf8
_DEVICE_ID_1284:
	.org 0x4df7
_bTimesUp:
	.org 0x4df8
_bTimesUp+0x1:
	.org 0x4df9
_bTimesUp+0x2:
	.org 0x4dfa
_bTimesUp+0x3:
	.org 0x4dfb
_bTimesUp+0x4:
	.org 0x4dfc
_bTimesUp+0x5:
	.org 0x4dfd
_bTimesUp+0x6:
	.org 0x4dfe
_bTimesUp+0x7:
	.org 0x4dff
_PutByte_byte:
	.org 0x4e00
_PutByte_nibble:
	.org 0x4e01
_PutByte_nibble+0x1:
	.org 0x4e02
_PutByte_nibble+0x2:
	.org 0x4e03
_PutOnion_onion:
	.org 0x4e04
_PutOnion_onion+0x1:
	.org 0x4e05
_PutString_string:
	.org 0x4e06
_PutString_string+0x1:
	.org 0x4e07
_UART_SOMETHING_TO_DO:
	.org 0x4e08
_UART_SOMETHING_TO_DO+0x1:
	.org 0x4e09
_UART_SOMETHING_TO_DO+0x2:
	.org 0x4e0a
_UART_CURRENT:
	.org 0x4e0b
_UART_CURRENT+0x1:
	.org 0x4e0c
_UART_NEXT:
	.org 0x4e0d
_UART_NEXT+0x1:
	.org 0x4e0e
_UART_NEXT+0x2:
	.org 0x4e0f
_UART_NEXT+0x3:
	.org 0x4e10
_UART_NEXT+0x4:
	.org 0x4e11
_UART_NEXT+0x5:
	.org 0x4e12
_UART_NEXT+0x6:
	.org 0x4e13
_UART_NEXT+0x7:
	.org 0x4e14
_UART_NEXT+0x8:
	.org 0x4e15
_UART_NEXT+0x9:
	.org 0x4e16
_UART_NEXT+0xa:
	.org 0x4e17
_UART_NEXT+0xb:
	.org 0x4e18
_USB_BREAK_OWNS:
	.org 0x4e19
_USB_BYTES:
	.org 0x4e1a
_USB_CURR_CONFIG:
	.org 0x4e1b
_USB_DUMP:
	.org 0x4e1c
_USB_ENDPOINT_CONTROL:
	.org 0x4e1d
_USB_STATE:
	.org 0x4e1e
_bRemoteWakeupEnabled:
	.org 0x4e1f
_bSendExtraNullPacket:
	.org 0x4e20
_printerClassPortStatus:
	.org 0x4e21
_usb_target_new_pch:
	.org 0x4e22
_usb_target_new_pcl:
	.org 0x4e23
_usb_target_pch:
	.org 0x4e24
_usb_target_pcl:
	.org 0x4e25
_usb_target_psr:
	.org 0x4e26
_usb_target_psr+0x1:
	.org 0x4e27
_usb_target_psr+0x2:
	.org 0x4e28
_usb_target_psr+0x3:
	.org 0x4e29
_usb_target_psr+0x4:
	.org 0x4e2a
_usb_target_psr+0x5:
	.org 0x4e2b
_usb_target_psr+0x6:
	.org 0x4e2c
_usb_target_psr+0x7:
	.org 0x4e2d
_usb_target_psr+0x8:
	.org 0x4e2e
_usb_target_psr+0x9:
	.org 0x4e2f
_usb_target_psr+0xa:
	.org 0x4e30
_usb_target_psr+0xb:
	.org 0x4e31
_usb_target_psr+0xc:
	.org 0x4e32
_usb_target_psr+0xd:
	.org 0x4e33
_usb_target_psr+0xe:
	.org 0x4e34
_usb_target_psr+0xf:
	.org 0x4e35
_usb_target_psr+0x10:
	.org 0x4e36
_usb_target_psr+0x11:
	.org 0x4e37
_usb_target_psr+0x12:
	.org 0x4e38
_usb_target_psr+0x13:
	.org 0x4e39
_usb_target_psr+0x14:
	.org 0x4e3a
_usb_target_psr+0x15:
	.org 0x4e3b
_usb_target_psr+0x16:
	.org 0x4e3c
_usb_target_psr+0x17:
	.org 0x4e3d
_usb_target_psr+0x18:
	.org 0x4e3e
_usb_target_psr+0x19:
	.org 0x4e3f
_usb_target_psr+0x1a:
	.org 0x4e40
_usb_target_psr+0x1b:
	.org 0x4e41
_usb_target_psr+0x1c:
	.org 0x4e42
_usb_target_psr+0x1d:
	.org 0x4e43
_usb_target_psr+0x1e:
	.org 0x4e44
_usb_target_psr+0x1f:
	.org 0x4e45
_usb_target_psr+0x20:
	.org 0x4e46
_usb_target_psr+0x21:
	.org 0x4e47
_usb_target_psr+0x22:
	.org 0x4e48
_usb_target_psr+0x23:
	.org 0x4e49
_usb_target_psr+0x24:
	.org 0x4e4a
_usb_target_psr+0x25:
	.org 0x4e4b
_usb_target_psr+0x26:
	.org 0x4e4c
_usb_target_psr+0x27:
	.org 0x4e4d
_usb_target_psr+0x28:
	.org 0x4e4e
_usb_target_psr+0x29:
	.org 0x4e4f
_usb_target_psr+0x2a:
	.org 0x4e50
_AUDIO_BC:
	.org 0x4e51
_AUDIO_BC+0x1:
	.org 0x4e52
_USB_ERROR_STAT:
	.org 0x4e53
_USB_ERROR_STAT+0x1:
	.org 0x4e54
_pDataOut:
	.org 0x4e55
_pDataOut+0x1:
	.org 0x4e56
_pDataOut+0x2:
	.org 0x4e57
_pDataOut+0x3:
	.org 0x4e58
_pDataOut+0x4:
	.org 0x4e59
_RECV_DATA01:
	.org 0x4e5d
_SEND_DATA01:
	.org 0x4e61
_cBDT:
	.org 0x4e62
_cBDT+0x1:
	.org 0x4e63
_cBDT+0x2:
	.org 0x4e64
_cBDT+0x3:
	.org 0x4e65
_USB_ERROR_CTR:
	.org 0x4e66
_USB_ERROR_CTR+0x1:
	.org 0x4e67
_USB_ERROR_CTR+0x2:
	.org 0x4e68
_USB_ERROR_CTR+0x3:
	.org 0x4e69
_USB_ERROR_CTR+0x4:
	.org 0x4e6a
_USB_ERROR_CTR+0x5:
	.org 0x4e6b
_USB_ERROR_CTR+0x6:
	.org 0x4e6c
_USB_ERROR_CTR+0x7:
	.org 0x4e6d
_USB_ERROR_CTR+0x8:
	.org 0x4e6e
_USB_ERROR_CTR+0x9:
	.org 0x4e6f
_USB_ERROR_CTR+0xa:
	.org 0x4e70
_USB_ERROR_CTR+0xb:
	.org 0x4e71
_USB_ERROR_CTR+0xc:
	.org 0x4e72
_USB_ERROR_CTR+0xd:
	.org 0x4e73
_USB_ERROR_CTR+0xe:
	.org 0x4e74
_USB_ERROR_CTR+0xf:
	.org 0x4e75
_USB_DUMP_COUNT:
	.org 0x4e76
_USB_SOF_ENB:
	.org 0x4e77
_bFirstDeviceDescriptorGets8Byte:
	.org 0x4e78
_bTruncateNextDeviceDescriptor:
	.org 0x4e79
_current_pwr_save_status:
	.org 0x4e7a
_USB_IN_SO_FAR:
	.org 0x4e7b
_USB_IN_SO_FAR+0x1:
	.org 0x4e7c
_USB_SOF_CTR:
	.org 0x4e7d
_USB_SOF_CTR+0x1:
	.org 0x4e7e
_USB_LAST_OUT:
	.org 0x4e82
_USB_NEXT_IN:
	.org 0x4e86
_USB_NEXT_OUT:
	.org 0x4e8a
_setup:
	.org 0x4e8b
_setup+0x1:
	.org 0x4e8c
_setup+0x2:
	.org 0x4e8d
_setup+0x3:
	.org 0x4e8e
_setup+0x4:
	.org 0x4e8f
_setup+0x5:
	.org 0x4e90
_setup+0x6:
	.org 0x4e91
_setup+0x7:
	.org 0x4e92
_usbSave:
	.org 0x4e93
_usbSave+0x1:
	.org 0x4e94
_usbSave+0x2:
	.org 0x4e95
_usbSave+0x3:
	.org 0x4e96
_usbSave+0x4:
	.org 0x4e97
_usbSave+0x5:
	.org 0x4e98
_usbSave+0x6:
	.org 0x4e99
_usbSave+0x7:
	.org 0x4e9a
_usbSave+0x8:
	.org 0x4e9b
_usbSave+0x9:
	.org 0x4e9f
_usbSave+0xd:
	.org 0x4ea0
_usbSave+0xe:
	.org 0x4ea1
_usbSave+0xf:
	.org 0x4ea2
_usbSave+0x10:
	.org 0x4ea3
_rx_desc_string:
	.org 0x4fa3
_disabledCount:
	.org 0x4fa4
_start:
	.org 0x4fa6
Aa_UsbVendSetEndPoint:
	.org 0x4fa7
Aa_UsbVendSetEndPoint+0x1:
	.org 0x4fa8
Aa_UartReadString:
	.org 0x4fa9
Aa_UartReadString+0x1:
	.org 0x4faa
Aa_HostSetNextInBdt:
	.org 0x4fab
A_UsbSendIn:
	.org 0x4fac
A_UsbSendIn+0x1:
	.org 0x4fad
Aa_HostSetNextOutBdt:
	.org 0x4fae
Aa_SendToken:
	.org 0x4faf
Aa_SendToken+0x1:
	.org 0x4fb0
A_ReallySendToken:
	.org 0x4fb1
Aa_ReallySendToken:
	.org 0x4fb2
Aa_ReallySendToken+0x1:

.org 0xffff
	.org 0x7000
_USB_BDT_PAGE:
	.org 0x7100
_USB_SPEAKER_BUFF:
	.org 0x7300
_USB_PRINTER_BUFF:
	.org 0x7400
_USB_BUFFER:
	.org 0x7800
_USB_EPn_BUFFER0:
	.org 0x7c00
_USB_EPn_BUFFER1:
	.org 0xff00
_WANT_1394_NO:
	.org 0xff02
_WANT_CAMERA_NO:
	.org 0xff03
_WANT_HANDSHAKE_NO:
	.org 0xff04
_WANT_HARDWARE_YES:
	.org 0xff05
_WANT_HOST_NO:
	.org 0xff06
_WANT_HUB_NO:
	.org 0xff07
_WANT_JTAG_NO:
	.org 0xff08
_WANT_LITE_NO:
	.org 0xff09
_WANT_MONITOR_NO:
	.org 0xff0a
_WANT_PRINTER_YES:
	.org 0xff0b
_WANT_REGRESS_NO:
	.org 0xff0c
_WANT_SAWTOOTH_NO:
	.org 0xff0d
_WANT_SIMULATOR_NO:
	.org 0xff0e
_WANT_SOUND_YES:
	.org 0xff0f
_WANT_TIMER_NO:
	.org 0xff10
_WANT_USB_YES:
