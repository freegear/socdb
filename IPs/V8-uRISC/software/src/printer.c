// printer.c

#include "vauto.h"
#include "printer.h"
#include "uart.h"

#define DEBUG_ID		0
#define DEBUG_VERBOSE	0

#if DEBUG_VERBOSE
void spew(char *p);
#else // !DEBUG_VERBOSE
#define spew(p)
#endif // !DEBUG_VERBOSE

// the following hard-coded locations MUST be editted
// if your memory map is not the vautomation default

volatile BYTE		PP_DATA @0x220;	// External PP data register
volatile CTRS_1284	PP_CTRS @0x221;	// External PP 
volatile CTRH_1284	PP_CTRH @0x222;	// External PP 
volatile CTL_1284	PP_CTL  @0x223;	// External PP control signal register
volatile CTL_1284	PP_CTLZ @0x224;	// External PP control signal direction register

BYTE USB_PRINTER_MODE = 0;
CTL_1284	newCtl1284;

void Init1284()
{
#if WANT_HARDWARE
	BYTE		b;
	CTL_1284	newCtlz1284;

	spew("Init1284-start");

							// init the parallel printer by doing a hard reset
							// setup the V1284 registers
	PP_CTRS.Tsetup = 11;	// 12 clocks = 1us setup width
	PP_CTRS.Tstrobe = 11;	// 12 clocks = 1us strobe width
	*(PBYTE)&PP_CTRH = 0;
	PP_CTRH.Thold = 11;		// 12 clocks = 1us hold width

	*(PBYTE)&newCtl1284 = 0;
	newCtl1284.autofeed_n = 1;
	PP_CTL = newCtl1284;

	*(PBYTE)&newCtlz1284 = 0;
	newCtlz1284.init_n = 1;
	newCtlz1284.autofeed_n = 1;
	newCtlz1284.selectin_n = 1;
	PP_CTLZ = newCtlz1284;	// drive the upper 3 control signals to cause a reset

	for (b=0x60; b; b++)	// loop for about 50us
		;

	PP_CTL.init_n = 1;		// end the reset

	for (b=0x60; b; b++)	// loop for about 50us
		;

	if (!PP_CTL.select)
		{
		puts("\r\n\aNo printer found\r\n");
		}

	spew("Init1284-end");
#endif // WANT_HARDWARE

	USB_PRINTER_MODE = 0;
	return;
}

BYTE DEVICE_ID_1284[255];	// dunno max size yet
BYTE DEVICE_ID_LENGTH = 0;

void get1284id()
{
#if WANT_HARDWARE
	BYTE	b;

	DEVICE_ID_LENGTH = 0;
// 0) Initialize the V1284 core 
	Init1284();
// 1) STDIS=1 - Disable automatic STROBE_N generation
	PP_CTRH.STDIS = 1;
	spew("1");
// 2) DOUT=0x05 - Byte mode extensibility request value=DEVICE_ID
	PP_DATA = 0x05;
	spew("2");
// 3) DRVDO=1 - drive the DOUT bus (1284 event 0)
	PP_CTRH.DRVDO = 1;
	spew("3");
// 4) SELECTIN_N=1, AUTOFD_N=0 - Ask the peripheral if it is 1284 compliant (1)
	PP_CTL.selectin_n = 1;
	PP_CTL.autofeed_n = 0;
	spew("4");
// 5) Wait for ACK_N going low, Timeout after 50us. (2)
//	If we timeout, the printer is not 1284 compliant.
	for (b=0x60; b; b++)	// loop for about 50us
		{
		if (!PP_CTL.ack_n)
			break;
		}

	for (b=4; b; b--)	// loop for about 1us
		;

	spew("5");
// 6) Verify that FAULT_N, PERROR and SELECT are all 1. If not, the printer is not
//	1284 compliant.
	if (PP_CTL.ack_n || !PP_CTL.fault_n || !PP_CTL.perror || !PP_CTL.select)
		{
		putbs(*(PBYTE)&PP_CTRS);
		putbs(*(PBYTE)&PP_CTRH);
		putbs(*(PBYTE)&PP_CTL);
		putb(*(PBYTE)&PP_CTLZ);
		puts(" \aget1284id: Printer is not 1284 compliant\r\n");

{
WORD	w;

for (w=1; w; w++)
	;

putbs(*(PBYTE)&PP_CTRS);
putbs(*(PBYTE)&PP_CTRH);
putbs(*(PBYTE)&PP_CTL);
putb(*(PBYTE)&PP_CTLZ);
putCrlf();
}
		return;
		}

	spew("6");
// 7) STROBE_N=0 (STLOW=1), then wait 1 us. Latch the Extensibility value. (3)
	PP_CTRH.STLOW = 1;
	for (b=4; b; b--)	// loop for about 1us
		;
	spew("7");
// 8) STROBE_N=1 (STLOW=0), AUTOFD_N=1. Acknowledge 1284 compliance (4)
	PP_CTRH.STLOW = 0;
	PP_CTL.autofeed_n = 1;
	spew("8");
// 9) Wait for ACK_N=1, Timeout after 50 us. (6)
	for (b=0x60; b; b++)	// loop for about 50us
		{
		if (PP_CTL.ack_n)
			break;
		}
	spew("9");
// 10) Verify that FAULT_N=0. Printer has data to send. (5)
	if (PP_CTL.fault_n)
		{
		putbs(*(PBYTE)&PP_CTRS);
		putbs(*(PBYTE)&PP_CTRH);
		putb(*(PBYTE)&PP_CTL);

		puts("\r\n\aget1284id: Printer has no data (1)\r\n");
		return;
		}
	spew("10");
// 11) DRVDO=0. tristate the data bus (14)
	PP_CTRH.DRVDO = 0;
	spew("11");
// 12) Wait 1 us.
step_12:
	for (b=4; b; b--)	// loop for about 1us
		;
// 13) AUTOFD_N=1, request data (7)
	PP_CTL.autofeed_n = 1;
	spew("13");
// 14) Wait for ACK_N=0, Timeout after 50 us. (10)
	for (b=0x60; b; b++)	// loop for about 50us
		{
		if (!PP_CTL.ack_n)
			break;
		}
	if (b)
		{
		puts("\r\n\aget1284id: Printer has no data (2)\r\n");
		return;
		}
	spew("14");
// 15) Read DIN which is a byte of data from the printer.
	DEVICE_ID_1284[DEVICE_ID_LENGTH] = PP_DATA;
#if DEBUG_ID
	putbs(DEVICE_ID_1284[DEVICE_ID_LENGTH]);
#endif // DEBUG_ID
	DEVICE_ID_LENGTH++;
	spew("15");
// 16) AUTOFD_N=1. (10)
	PP_CTL.autofeed_n = 1;
	spew("16");
// 17) STROBE_N=0. (16)
	PP_CTRH.STLOW = 1;
	spew("17");
// 18) Wait for ACK_N=1, timeout after 50 us. (11)
	for (b=0x60; b; b++)	// loop for about 50us
		{
		if (PP_CTL.ack_n)
			break;
		}
	spew("18");
// 19) STROBE_N=1. (17) end of this transfer
	PP_CTRH.STLOW = 0;
	spew("19");
// 20) If FAULT_N=1, then there is no more data, else, go step 12.
	if (DEVICE_ID_LENGTH == 255)
		{
		puts("\r\n\aget1284id: too long\r\n");
		}
	else if (!PP_CTL.fault_n)
		goto step_12;

	spew("20");
// 21) STDIS=0, DRVDO=0 - disable manual control of STROBE and DOUT bus.
	PP_CTRH.STDIS = 0;
	PP_CTRH.DRVDO = 0;
	spew("21");
// 22) SELECTIN_N=0,AUTOFD_N=1 - exit 1284 extensibility mode (22)
	PP_CTL.selectin_n = 0;
	PP_CTL.autofeed_n = 1;
	spew("22");
// 23) Wait for ACK_N=0, timeout after 50 us (24)
	for (b=0x60; b; b++)	// loop for about 50us
		{
		if (!PP_CTL.ack_n)
			break;
		}
	spew("23");
// 24) AUTOFD_N=0  - acknowledge the exit (25)
	PP_CTL.autofeed_n = 0;
	spew("24");
// 25) Wait for ACK_N=1	- acknowledge (27)
	for (b=0x60; b; b++)	// loop for about 50us
		{
		if (PP_CTL.ack_n)
			break;
		}
	spew("25");
// 26) AUTOFD_N=1 - exit complete (28)
	PP_CTL.autofeed_n = 1;
	spew("get1284id-done");
// 1284 port is now ready for normal operation again.
#endif // WANT_HARDWARE

	return;
}

#if DEBUG_VERBOSE
void spew(char *p)
{
	CTRS_1284	CTRS;	// External PP 
	CTRH_1284	CTRH;	// External PP 
	CTL_1284	CTL;	// External PP control signal register
	CTL_1284	CTLZ;	// External PP control signal direction register

	CTRS = PP_CTRS;
	CTRH = PP_CTRH;
	CTL = PP_CTL;
	CTLZ = PP_CTLZ;

	putbs(*(PBYTE)&CTRS);
	putbs(*(PBYTE)&CTRH);
	putbs(*(PBYTE)&CTL);
	putbs(*(PBYTE)&CTLZ);
	puts(p);
	if (CTRH.DRVDO)
		puts(" DRVDO");
	if (CTRH.STLOW)
		puts(" STLOW");
	if (CTRH.STDIS)
		puts(" STDIS");

	puts(" CTL:");
	if (CTL.init_n)
		puts("init_n ");
	if (CTL.autofeed_n)
		puts("autofeed_n ");
	if (CTL.selectin_n)
		puts("selectin_n ");
	if (CTL.ack_n)
		puts("ack_n ");
	if (CTL.busy)
		puts("busy ");
	if (CTL.perror)
		puts("perror ");
	if (CTL.select)
		puts("select ");
	if (CTL.fault_n)
		puts("fault_n ");

	puts("CTLZ:");
	if (CTLZ.init_n)
		puts("init_n ");
	if (CTLZ.autofeed_n)
		puts("autofeed_n ");
	if (CTLZ.selectin_n)
		puts("selectin_n ");
	if (CTLZ.ack_n)
		puts("ack_n ");
	if (CTLZ.busy)
		puts("busy ");
	if (CTLZ.perror)
		puts("perror ");
	if (CTLZ.select)
		puts("select ");
	if (CTLZ.fault_n)
		puts("fault_n ");

	putCrlf();
	return;
}
#endif // WANT_VERBOSE

