#include "vauto.h"
#include "uart.h"

#define UART_MIN 0x60	// locations 6000 - 6fff are used as an output buffer
#define UART_MAX 0x6f


volatile ONION UART_NEXT;		// where to put next outgoing char
volatile ONION UART_CURRENT;	// where go get oldest outgoing char which hasn't been sent

volatile BYTE UART_SOMETHING_TO_DO;	// TRUE if NEXT != CURRENT

#define INIT_CURRENT	(UART_CURRENT.b.h = UART_MIN, UART_CURRENT.b.l = 0)
#define INIT_NEXT		(UART_NEXT.b.h = UART_MIN, UART_NEXT.b.l = 0)

void actuallyWriteCharToUart(void);


void UartInit(BYTE speed)
{
#if WANT_HARDWARE
	UART_BASE_2 = 0x19;		// 115.2k baud
#else
	UART_BASE_2 = 1;		// use maximum divisor for simulations
#endif

	UART_BASE_3 = 0x00;

	*(PBYTE)&uartStatus = 0x00;

	UartBufferInit();
	UART_BASE_0 = 'U';	// 01010101 - let's the uart get synch'd

	puts("Up\r\n");

	return;
}


void UartBufferInit()
{

//	if ((UART_CURRENT.b.h < UART_MIN) || (UART_CURRENT.b.h > UART_MAX) || !UART_SOMETHING_TO_DO)
		{
#if 0
		INIT_CURRENT;

		while (UART_CURRENT.b.h <= UART_MAX)	// initialize entire buffer
			{
			*UART_CURRENT.pb++ = 0xcc;
			}
#endif
		INIT_CURRENT;
		INIT_NEXT;
		UART_SOMETHING_TO_DO = FALSE;
		}
	return;
}

BYTE UartReadChar()		// read a char, wait for it if necessary
{
	while (!UartCharWaiting())	// until there's an incoming char
		putFlushOneIfReady();	// flush another outgoing char

	return UART_BASE_0;
}



BYTE UartCharWaiting()	// return non-zero if an incoming char is waiting to be read
{
#if 1
	static WORD w=0;
	w++;
	if (w & 0x8000)
		asm("stp 7");
	else
		asm("clp 7");
#endif
	return uartStatus.rxFull;
}


void putc(register const BYTE b)	// output an ascii char
{

#if WANT_SIMULATOR
	*(PBYTE)0x300 = b;		// simulating, just write byte to loc 300 for ease of monitoring
	return;
#else
	// b is in r4

asm("br1 3,already_in_int1");
asm("psh r4");	// save b (r4)
asm("stp 3");	// set I bit
asm("pop r4");	// restore b

	*UART_NEXT.pb++ = b;
	if (UART_NEXT.b.h > UART_MAX)
		INIT_NEXT;
	UART_SOMETHING_TO_DO = TRUE;

asm("clp 3");	// clear I bit
asm("rts");

asm("already_in_int1:");

	*UART_NEXT.pb++ = b;
	if (UART_NEXT.b.h > UART_MAX)
		INIT_NEXT;
	UART_SOMETHING_TO_DO = TRUE;
	return;
#endif
}

void putFlush()		// flush all chars waiting to be sent
{

#if !WANT_SIMULATOR
	if (UART_SOMETHING_TO_DO)
		{
		while (UART_CURRENT.w != UART_NEXT.w)
			if (uartStatus.txEmpty)
				{
asm("br1 3,already_in_int2");
asm("stp 3");	// set I bit
				actuallyWriteCharToUart();
asm("clp 3");	// clear I bit
asm("jmp not_in_int2");

asm("already_in_int2:");
				actuallyWriteCharToUart();
asm("not_in_int2:");
				}
		UART_SOMETHING_TO_DO = FALSE;
		}
#endif // !WANT_SIMULATOR

	return;
}
void putFlushOneIfReady()	// flush next char waiting to be sent
{
#if !WANT_SIMULATOR
	if (UART_SOMETHING_TO_DO)
		if (UART_CURRENT.w != UART_NEXT.w)
			if (uartStatus.txEmpty)
				{
asm("br1 3,already_in_int3");
asm("stp 3");	// set I bit
				actuallyWriteCharToUart();
				UART_SOMETHING_TO_DO = (UART_CURRENT.w != UART_NEXT.w);
asm("clp 3");	// clear I bit
asm("jmp not_in_int3");

asm("already_in_int3:");
				actuallyWriteCharToUart();
				UART_SOMETHING_TO_DO = (UART_CURRENT.w != UART_NEXT.w);
asm("not_in_int3:");

				}

	UART_SOMETHING_TO_DO = UART_SOMETHING_TO_DO;
#endif // !WANT_SIMULATOR

	return;
}

void actuallyWriteCharToUart()
{
	BYTE	b;

	b = *UART_CURRENT.pb++;
	if ((b & 0x80) == 0)
		UART_BASE_0 = b;

	if (UART_CURRENT.b.h > UART_MAX)	// wrap current if it exceeded max
		INIT_CURRENT;

	return;
}

