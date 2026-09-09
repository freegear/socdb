// host_int.c

#define HOST_INT_C	1

#include "vauto.h"
#include "host.h"
#include "host_int.h"
#include "uart.h"
#include "usb_drv.h"
#include "usb_glob.h"
#if WANT_PRINTER
#include "printer.h"
#endif

#define DEBUG_SOF_MISSES	0
#define DEBUG_REGS			0
#define DEBUG_BDT			0
#define DEBUG_OUT_TOKENS	0
#define DEBUG_SEND_TOKEN	0
#define DEBUG_ATTACH		0
#define DEBUG_DETACH		0
#define DEBUG_PULSE			0
#define DEBUG_SOF			0
#define DEBUG_ADDRESS		0
#define DEBUG_WANTED		0
#define DEBUG_TOKEN			0
#define DEBUG_HOST_STATE	0

#if DEBUG_REGS && !WANT_LITE
void HostIntDumpRegs()
#include "dumpregs.h"
#endif // DEBUG_REGS

#if DEBUG_BDT
static volatile PBDT debugPBDT @0xff00;	// copy bdt's here to see them in simulation
static volatile BDT debugBDT @0xff04;
static volatile BYTE debugDATA[8] @0xff08;
#endif

#if DEBUG_OUT_TOKENS
volatile BYTE debugTOKEN_ADDRESS2 @0xff10;
volatile BYTE debugTOKEN_TOKEN2 @0xff11;
volatile BYTE debugTOKEN_TYPE2 @0xff12;
#endif

#if DEBUG_DETACH
static BYTE USB_DETACH_LIMIT = 0;
#endif

extern BYTE USB_IN;				// next ep0 bdt to use

BOOL	bSawtooth = FALSE;
BOOL	bSawtoothOdd = 0;
BYTE	bSawtoothData = 0;

WORD USB_RX_FIRST_BYTE = 0;
extern ONION USB_IN_WANTED;

#if DEBUG_PULSE
BYTE usb_host_pcl, usb_host_pch, usb_host_psr, usb_host_new_pcl, usb_host_new_pch;

WORD	usb_host_pulse;
#endif

extern BYTE speed;

extern BYTE USB_HOST_STATE;
extern BYTE USB_META_STATE;
extern BYTE USB_CURRENT_ADDR;	// last address assigned
extern BYTE USB_NEXT_ADDR;		// next address to assign
extern BYTE USB_ARE_WE_ATTACHED;
extern BYTE USB_OUT;			// next ep0 bdt to use
extern BYTE USB_NEXT_DATA01;

extern ONION rx_buffer;

void HostError(void);
void HostAttach(void);
void HostDetach(void);

void HostTokenDone(void);
void HostStateReset(void);
void HostStateInc(void);
void HostState01(void);
void HostState02(void);
void HostState03(void);
void HostState11(void);
void HostSOF(void);
void HostSendInToken(BYTE bAddress);
PBDT HostGetCurrentInBdt(void);
PBDT HostGetNextInBdt(void);
void HostIntSetNextOutBdt(BYTE bLength, PBYTE address);
void HostIntSetCurrentAddress(BYTE bAddress);
BYTE HostIntCreateNextControlByte(void);

#if WANT_PRINTER
void PrinterTest(void);
#endif

// <<<<<<<<<<<Interrupt Service Routine Entry Point>>>>>>>>>>>>>>>>>
#pragma interrupt_level 1
void interrupt UsbHostIntService()
{
#if DEBUG_STACK
	static BYTE	b;
	static ONION	onion;
#endif //DEBUG_STACK

	asm("stp 4");
	asm("stp 5");
	asm("stp 6");
	asm("stp 7");
	asm("clp 7");
	asm("clp 6");
	asm("clp 5");
	asm("clp 4");

#asm		// save PC and PSR for later testing
#if 0
	pop r5	// **y*e-proofing
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
#endif

#if DEBUG_PULSE
	pop r0			; pcl
	pop r1			; pch
	pop r2			; psr
	sta r0,_usb_host_pcl
	sta r1,_usb_host_pch
	sta r2,_usb_host_psr
	psh r2			; psr
	psh r1			; pch
	psh r0			; pcl
#endif
#endasm

#if DEBUG_PULSE
putc('!');
putb(usb_host_pch);
putb(usb_host_pcl);
putc('!');
#endif

	usbSave = usb;
	usbSave.intStatusMasked = usbSave.intStatus & usbSave.intEnable;
	usbSave.ep = usbSave.status >> 4;	// end point
	usbSave.pBDT = (PBDT)((usbSave.bdtPage<<8)|usbSave.status);
//	USB_ERROR_STAT.b[0] |= usbSave.errorStatus;	// add error bits
	cBDT = *usbSave.pBDT;		// save copy of bdt

	if (usbSave.intStatus & INT_STAT_MASK_STALL)
		{
		puts("\r\nSTALL\r\n");
		usb.intStatus = INT_STAT_MASK_STALL;	// clear stall
		usb.control &= ~MASK_CTL_TOKEN_BUSY;
		}

#if 0
	if (usbSave.intStatus & INT_STAT_MASK_SOF) 
		{
		static BYTE	b=0;
		if (!b)
			putc('$');
		b++;
		}
#endif

#if DEBUG_REGS && !WANT_LITE
//	if (debug.UsbInt)
		if (usbSave.intStatusMasked != INT_STAT_MASK_SOF)	// ignore SOF onlys
			if (USB_DUMP_COUNT)
				{
				USB_DUMP_COUNT--;
				putb(USB_DUMP_COUNT);
				putc('#');
				HostIntDumpRegs();
				if (!USB_DUMP_COUNT)
					puts("No more interrupts will be dumped\r\n");
				}
#endif // DEBUG_REGS

// real work begins here


	if (usbSave.intStatusMasked & INT_STAT_MASK_RESET)
		{
		HostReset();
		}
	else
		{
		if (usbSave.intStatusMasked & INT_STAT_MASK_ERROR)
			HostError();
		if (usbSave.intStatusMasked & INT_STAT_MASK_TOKEN_DONE)
			HostTokenDone();
		if (usbSave.intStatusMasked & INT_STAT_MASK_SOF)
			HostSOF();
		if (usbSave.intStatusMasked & INT_STAT_MASK_ATTACH)
			{
			HostAttach();
			}
		}


	// clear handled interrupts
	usb.intStatus = usbSave.intStatusMasked;

// real work ends here


#asm
#if DEBUG_PULSE
	pop r2			; pcl
	pop r3			; pch
	pop r4			; psr
	lda r6,_usb_host_pcl
	lda r7,_usb_host_pch
	lda r4,_usb_host_psr
	psh r4			; psr
	psh r7			; pch
	psh r6			; pcl
#endif

#if DEBUG_STACK
; see if stack was hosed, r23 should == r67
	tx0 r6
	cmp r2
	brne stack_hosed
	tx0 r7
	cmp r3
	brne stack_hosed
#endif //DEBUG_STACK

#if DEBUG_PULSE
#endasm

	if (usbSave.intStatus & INT_STAT_MASK_SOF)
		usb_host_pulse++;
	if (usb_host_pulse & 0x0200)
		usb_host_psr |= 0x80;
	else
		usb_host_psr &= 0x7f;

#asm

	pop r2			; pcl
	pop r3			; pch
	pop r4			; psr
	lda r4,_usb_host_psr
	or  r4
	psh r0			; psr
	psh r3			; pch
	psh r2			; pcl
	rti		; happy
#endif

#if DEBUG_STACK
stack_hosed:
	sta r2,_usb_host_new_pcl
	sta r3,_usb_host_new_pch
#endif //DEBUG_STACK
#endasm

#if DEBUG_STACK
	puts("\r\n\aUSB rti expected ");
	putb(usb_host_pch);
	putb(usb_host_pcl);
	puts(" found ");
	putb(usb_host_new_pch);
	putb(usb_host_new_pcl);
	putCrlf();

	for (onion.w=0x300; onion.w<0x400; onion.w++)
		{
		if ((onion.w & 0x0f) == 0x00)
			{
			puto(onion);
			putc(':');
			}
		putbs(*onion.pb);
		if ((onion.w & 0x0f) == 0x0f)
			{
			putCrlf();
			}
		}

	puts("\r\nPress any key\r\n");

	for (b=0; !UartCharWaiting(); b++)
		{
		if (b & 1)
			asm("stp 7");
		else
			asm("clp 7");
		if (b & 2)
			asm("stp 6");
		else
			asm("clp 6");
		if (b & 4)
			asm("stp 5");
		else
			asm("clp 5");
		if (b & 8)
			asm("stp 4");
		else
			asm("clp 4");
		}
#endif //DEBUG_STACK

	return;
}

void HostReset(void)
{
#if WANT_SAWTOOTH
	bSawtooth = FALSE;
#endif
#if WANT_PRINTER
	USB_PRINTER_MODE = 0;
#endif
	USB_HOST_STATE = 0;
	ResetMetaStateWanted();
	usb.intStatus = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF;
	usb.intEnable = INT_STAT_MASK_ATTACH | INT_STAT_MASK_SOF;
	usb.control = MASK_CTL_HOST_MODE_EN;

	HostDebounceAttachDetach();
	HostAttach();
	return;
}

void HostError(void)
{
	puts("Err:");
	putb(usbSave.errorStatus);
	usb.errorStatus = usbSave.errorStatus;	// clear error
	putCrlf();
	USB_HOST_STATE = 0;
	return;
}

void HostAttach(void)
{
	static BYTE	b;

#if DEBUG_ATTACH
	puts("HostAttach()\r\n");
#endif

	usb.intEnable = 0;		// disable all interrupts
	usb.errorEnable = 0xff;	// enable all errors
	USB_HOST_STATE = 0;	// initialize host state

#if DEBUG_DETACH
	USB_DETACH_LIMIT = 4;
#endif // DEBUG_DETACH

	usb.bdtPage = (BYTE)(((WORD)USB_BDT_PAGE) >> 8);

	b = HostDebounceAttachDetach();

	if (b & MASK_CTL_SINGLE_ENDED_0)
		{
		HostDetach();
		return;
		}


#if 0
	usb.control = b | MASK_CTL_RESET;
puts("HostAttach: usb.control=");
putb(usb.control);
putCrlf();
	HostDelay();
	usb.control = b & ~MASK_CTL_RESET;
#else
	doAReset();
#endif

	b = HostDebounceAttachDetach();
	USB_NEXT_ADDR = 1;
	USB_OUT = 0x0c;	// addr of odd data out
	USB_IN = 0x04;	// addr of odd data in
	if (b & MASK_CTL_SINGLE_ENDED_0)
		{
		HostDetach();
		return;
		}

	if (usb.address & 0x80)	// check the low speed bit
		{ // currently low speed
		if (b & MASK_CTL_RCV)
			{
#if DEBUG_ATTACH
		puts("Host LowSpeed\r\n");
#endif
			speed = 0x80;
			USB_CURRENT_ADDR |= 0x80;
			}
		else
			{
#if DEBUG_ATTACH
		puts("Host HighSpeed\r\n");
#endif
			speed = 0x00;
			}
		}
	else
		{ // currently high speed
		if (b & MASK_CTL_RCV)
			{
#if DEBUG_ATTACH
		puts("Host HighSpeed\r\n");
#endif
			speed = 0x00;
			}
		else
			{
#if DEBUG_ATTACH
		puts("Host LowSpeed\r\n");
#endif

#if 0	// disable low speed support
			puts("Host LowSpeed NOT SUPPORTED!\r\n");
			return;
#else
			speed = 0x80;
			USB_CURRENT_ADDR |= 0x80;
#endif
			}
		}


	USB_ARE_WE_ATTACHED = 1;

// modify psr here, if you care



// enumerate the bus

#if USB_DELAY_TOKEN
	b = INT_STAT_MASK_TOKEN_DONE | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET;
#else
	b = INT_STAT_MASK_TOKEN_DONE | INT_STAT_MASK_SOF | INT_STAT_MASK_RESET;
#endif

	usb.intStatus = b;
	usb.intEnable = b;

	usb.control = MASK_CTL_HOST_MODE_EN | MASK_CTL_USB_EN;

	MetaState10();

	return;
}

void HostDetach()
{

#if DEBUG_ATTACH
	puts("HostDetach()\r\n");
#endif

	USB_DUMP_COUNT = 64;	// show next 16 ints

#if WANT_SAWTOOTH
	bSawtooth = FALSE;
#endif

#if WANT_PRINTER
	USB_PRINTER_MODE = 0;
#endif

	USB_ARE_WE_ATTACHED = 0;

// modify psr here, if you care

	USB_CURRENT_ADDR = 0;
	USB_NEXT_ADDR = 1;
	puts("DETACHED\r\n");
#if DEBUG_REGS && !WANT_LITE
	puts("Regs 2 = ");
	HostIntDumpRegs();
#endif

	usb.control = MASK_CTL_ODD_RST;
	usb.control = MASK_CTL_HOST_MODE_EN;
	usb.intStatus = INT_STAT_MASK_ATTACH;
	usb.intEnable = INT_STAT_MASK_ATTACH;
	usb.address = 0;	// causes speed bit to be cleared
	speed = 0x00;

	return;
}

void HostTokenDone(void)
{
	static ONION	onion;

#if USB_DELAY_TOKEN
	if (USB_HOST_STATE && USB_BUFFERED)
		{
		puts("HostTokenDone: token already buffered\a ");
		putbs(USB_BUFFERED_ADDRESS);
		putbs(USB_BUFFERED_TOKEN);
		putb(USB_BUFFERED_TYPE);
		putCrlf();
		}
#endif

#if WANT_PRINTER
	if (USB_PRINTER_MODE & 1)
		{
		PrinterTest();
		return;
		}
#endif

#if 0
	{
	static BYTE	b;
	onion.b.h = usbSave.bdtPage;
	onion.b.l = 0;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	b = *onion.pb++;
	}
#endif

	onion.b.h = usbSave.bdtPage;
	onion.b.l = usbSave.status;

#if 0
	if (onion.pBDT->pid & 0x80)
		{
		puts("BDT not owned\r\n");
		HostStateReset();
		return;
		}
#endif

	if (ENDPT_HOST_RG & 1)	// if not an iso endpoint
		switch (onion.pBDT->pid & 0x3c)
			{
			case 0x3c:	// error
			case 0x00:	// bus timeout
			case 0x28:	// nak
				// resend last token after resetting the bdt

				USB_OUT ^= 0x04;	// toggle odd/even and use result

				onion.pBDT = USB_BDT_PAGE;
				onion.b.l = USB_OUT;	// create pointer to current out bdt

				onion.pBDT->bc = USB_BUFFERED_BDT.bc;
				onion.pBDT->addr = USB_BUFFERED_BDT.addr;
				onion.pBDT->pid = USB_BUFFERED_BDT.pid;
				
#if DEBUG_SEND_TOKEN
				puts("HostTokenDone: SendToken(");
				putbs(USB_BUFFERED_ADDRESS);
				putbs(USB_BUFFERED_TOKEN);
				putb(USB_BUFFERED_TYPE);
				puts(")\r\n");
#endif

				SendToken(USB_BUFFERED_ADDRESS, USB_BUFFERED_TOKEN, USB_BUFFERED_TYPE);
				return;
			}

#if DEBUG_HOST_STATE
puts("HostTokenDone: state=");
putb(USB_HOST_STATE);
putCrlf();
#endif

	switch (USB_HOST_STATE)
		{
		case 0:
			return;
		case 1:
			HostState01();
			return;
		case 2:
			HostState02();
			return;
		case 3:
			HostState03();
			return;
		case 0x11:
			HostState11();
			return;
		default:
			HostStateReset();
			return;
		}
}

void HostStateReset()
{

	USB_HOST_STATE = 0;
	return;
}

void HostStateInc()
{

	USB_HOST_STATE++;
	return;
}


void HostState01()
{

	HostSendInToken(USB_CURRENT_ADDR|speed);
	USB_RX_FIRST_BYTE = rx_buffer.w;
	USB_IN_WANTED.w = 0;
	HostStateInc();
	return;
}

void HostState02()	// receive data (may loop)
{
	static ONION	onion;
	static PBDT	pBDT;

	onion.w = USB_RX_FIRST_BYTE;

	switch (USB_PACKET_LENGTH_MODE)
		{
		case USB_PACKET_LENGTH_0:
			USB_IN_WANTED.w = 0;
			break;

		case USB_PACKET_LENGTH_8:
			USB_IN_WANTED.w = 8;
			break;

		case USB_PACKET_LENGTH_BYTE0:
			USB_IN_WANTED.b.l = *onion.pb;
			USB_IN_WANTED.b.h = 0;
			break;

		case USB_PACKET_LENGTH_BYTE23:
			USB_IN_WANTED.b.l = onion.pb[2];
			USB_IN_WANTED.b.h = onion.pb[3];
			break;

		case USB_PACKET_LENGTH_STRINGINDEX:

// stringindices are wierd.
//
//	phillips returns:	04 03 04 09
//		which seems to be what the spec requires
//	konica returns:		04 09
//		the spec could be interpreted this way
//	polaroid returns:	2A 03 50 00 6F 00 6C 00 6F 00 72 00 6F 00 69 00 64 00 20 00 43 00 6F 00 72 00 70 00 6F 00 72 00 61 00 74 00 69 00 6F 00 6E 00
//		they're out to lunch.  no matter what string you ask for 0-255, you get this complete with misspelling.

			if (!USB_IN_WANTED.w)	// don't already know
				{
				USB_IN_WANTED.b.h = 0;
				onion.b.h = usbSave.bdtPage;
				onion.b.l = usbSave.status;
				if (onion.pBDT->bc == 2)
					{	// Konica
					USB_IN_WANTED.b.l = 2;
					}
				else
					{
					USB_IN_WANTED.b.l = rx_desc_string.bLength;
					}
				}
			break;

		default:
			USB_IN_WANTED.b.l = USB_PACKET_LENGTH_MODE;
			USB_IN_WANTED.b.h = 0;
			break;
		}

	pBDT = HostGetCurrentInBdt();

#if DEBUG_BDT
	{
	static PBYTE	ps;
	static BYTE	i;

	putws((WORD)pBDT);
	debugPBDT = pBDT;
	debugBDT = *pBDT;
	for (i=0, ps=pBDT->addr.pb; i<8; i++)
		{
		putbs(ps[i]);
		debugDATA[i] = ps[i];
		}
	putCrlf();
	}
#endif

	onion.b.h = pBDT->pid & 0x03;
	onion.b.l = pBDT->bc;
	USB_IN_SO_FAR += onion.w;

#if DEBUG_WANTED
	puts("Wanted ");
	puto(USB_IN_WANTED);
	puts(" Got ");
	putw(USB_IN_SO_FAR);
	putCrlf();
#endif

	if (USB_IN_WANTED.w == USB_IN_SO_FAR)
		{	// complete
		if (USB_PACKET_LENGTH_MODE == USB_PACKET_LENGTH_0)
			{
			HostIntSetCurrentAddress(tx_set_addr.wValue.b.l | speed);
			USB_META_STATE++;
			HostStateReset();
			return;
			}
		if (USB_PACKET_LENGTH_MODE == USB_PACKET_LENGTH_8)
			{
			USB_META_STATE++;
			HostStateReset();
			return;
			}
//puts(" <> ");
		HostIntSetNextOutBdt(0, 0x0000);

#if DEBUG_SEND_TOKEN
		puts("HostState02: SendToken(");
		putbs(USB_CURRENT_ADDR|speed);
		putbs(0x10);
		putb(ENDPT_CONTROL);
		puts(")\r\n");
#endif

		SendToken(USB_CURRENT_ADDR|speed, 0x10, ENDPT_CONTROL);	// OUT EP0
		HostStateInc();
		return;
		}
	else if (USB_IN_WANTED.w < USB_IN_SO_FAR)
		{	// too much
		puts("Wanted ");
		puto(USB_IN_WANTED);
		puts(" Got ");
		putw(USB_IN_SO_FAR);
		putCrlf();
		return;
		}
	else
		{	// partial
		rx_buffer.w += onion.w;
		HostSendInToken(USB_CURRENT_ADDR|speed);
		return;
		}
}

void HostState03()
{

	USB_META_STATE++;
	HostStateReset();
	return;
}



void HostState11()
{

	USB_META_STATE++;
	HostStateReset();
	return;
}

BYTE	txAudio[2][64];
BYTE	txCurrentBuffer;

void HostSOF(void)
{
	static ONION	expected;
	static ONION	got;
	static ONION	onion;

//putc('$');
	expected.w = (USB_SOF_CTR + 1) & 0x07ff;	// 11 bits

	got.b.h = usb.frameNumHi;
	got.b.l = usb.frameNumLo;
	if (got.w != expected.w)
		{
#if DEBUG_SOF_MISSES && WANT_HARDWARE
		if (debug.bits.SofErrors)
			{
			puts("SOF ");
			puto(expected);
			puts("!=");
			puto(got);
			putCrlf();
			}
#endif // DEBUG_SOF_MISSES
		expected.w = got.w;	// use actual as next expected
		}

	USB_SOF_CTR = expected.w;

#if USB_DELAY_TOKEN
	if (USB_BUFFERED)
		{
		USB_BUFFERED = FALSE;
#if 0
		puts("HostSOF: Unbuffered ");
		putbs(USB_BUFFERED_ADDRESS);
		putbs(USB_BUFFERED_TOKEN);
		putb(USB_BUFFERED_TYPE);
		putCrlf();
#endif
		ReallySendToken(USB_BUFFERED_ADDRESS, USB_BUFFERED_TOKEN, USB_BUFFERED_TYPE);
		USB_BUFFERED_ADDRESS = 0xee;
		USB_BUFFERED_TOKEN = 0xdd;
		USB_BUFFERED_TYPE = 0xcc;
		}
#endif

	if (bSawtooth)
		{
//static BYTE limit =0xff;
		BYTE	newPid;

		bSawtoothData += 16;

		memset(txAudio[bSawtoothOdd], bSawtoothData, 64);

		onion.pb = (PBYTE)USB_BDT_PAGE;
		USB_OUT ^= 0x04;				// toggle odd/even
		onion.b.l = USB_OUT;

		onion.pBDT->addr.pb = &txAudio[bSawtoothOdd][0];
		onion.pBDT->bc = 64;
//		if (bSawtoothOdd)
//			onion.pBDT->pid = 0xc0;
//		else
			newPid = 0x80;

		USB_BUFFERED_BDT.pid = newPid;
		USB_BUFFERED_BDT.bc = onion.pBDT->bc;
		USB_BUFFERED_BDT.addr = onion.pBDT->addr;

		onion.pBDT->pid = newPid;

putCrlf();
putos(onion);
putbs(onion.pBDT->pid);
putbs(onion.pBDT->bc);
putos(onion.pBDT->addr);
putCrlf();

#if DEBUG_SEND_TOKEN
		puts("HostSOF: SendToken(");
		putbs(1);
		putbs(0x12);
		putb(ENDPT_ISO_OUT);
		puts(")\r\n");
#endif

		SendToken(1, 0x12 /* OUT EP0 */, ENDPT_ISO_OUT);
		
		bSawtoothOdd = !bSawtoothOdd;

//limit++;
//if (!limit)
//	bSawtooth = FALSE;	// just send a few packets for now
		}

	return;
}

PBDT HostGetCurrentInBdt()
{
	static ONION onion;

	onion.b.h = usbSave.bdtPage;
	onion.b.l = USB_IN;
	return onion.pBDT;
}

PBDT HostGetNextInBdt()
{
	static ONION onion;
	
	onion.b.h = usbSave.bdtPage;
	USB_IN ^= 0x04;
	onion.b.l = USB_IN;
#if 0
puts(" USB_IN=");
putbs(USB_IN);
putCrlf();
#endif

	return onion.pBDT;
}

void HostSendInToken(BYTE bAddress)
{
	static PBDT	pBDT;
	BYTE	newPid;

	pBDT = HostGetNextInBdt();
	pBDT->addr.w = rx_buffer.w;

//	USB_PACKET_LENGTH_MODE = ;

	pBDT->bc = 0xff;
	newPid = HostIntCreateNextControlByte();

	USB_BUFFERED_BDT.pid = newPid;
	USB_BUFFERED_BDT.bc = pBDT->bc;
	USB_BUFFERED_BDT.addr = pBDT->addr;

	pBDT->pid = newPid;

#if DEBUG_BDT
	{
	static PBYTE	ps;
	static BYTE	i;

	debugPBDT = pBDT;
	debugBDT = *pBDT;
	for (i=0, ps=pBDT->addr.pb; i<8; i++)
		debugDATA[i] = ps[i];
	}
#endif

#if DEBUG_SEND_TOKEN
		puts("HostSendInToken: SendToken(");
		putbs(bAddress);
		putbs(0x90);
		putb(ENDPT_CONTROL);
		puts(")\r\n");
#endif

	SendToken(bAddress, 0x90, ENDPT_CONTROL);	// IN EP0
	return;
}


void PrinterTest()
{

}

void HostIntSetNextOutBdt(BYTE bLength, PBYTE address)
{
	static ONION onion;
	BYTE	newPid;

	onion.pb = (PBYTE)USB_BDT_PAGE;
	USB_OUT ^= 0x04;				// toggle odd/even
	onion.b.l = USB_OUT;
	onion.pBDT->bc = bLength;
	onion.pBDT->addr.pb = address;
	newPid = HostIntCreateNextControlByte();

	USB_BUFFERED_BDT.pid = newPid;
	USB_BUFFERED_BDT.bc = onion.pBDT->bc;
	USB_BUFFERED_BDT.addr = onion.pBDT->addr;

	onion.pBDT->pid = newPid;

#if DEBUG_BDT
	{
	static PBYTE	ps;
	static BYTE	i;

	debugPBDT = onion.pBDT;
	debugBDT = *onion.pBDT;
	for (i=0, ps=onion.pBDT->addr.pb; i<8; i++)
		debugDATA[i] = ps[i];
	}
#endif

	return;
}

void HostIntSetCurrentAddress(BYTE bAddress)
{
	USB_CURRENT_ADDR = bAddress;

#if DEBUG_ADDRESS
	puts("HostIntSetCurrentAddress: ");
	putb(bAddress);
	putCrlf();
#endif

	return;
}

BYTE HostIntCreateNextControlByte()
{

	USB_NEXT_DATA01 ^= 0x40;	// toggle data0/1
	return USB_NEXT_DATA01 | 0x80;
}

