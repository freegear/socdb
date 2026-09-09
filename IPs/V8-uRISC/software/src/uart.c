#include "vauto.h"
#include "uart.h"

volatile BYTE UART_BASE_0		@0x240;
volatile UART_STATUS uartStatus	@0x241;
volatile BYTE UART_BASE_2		@0x242;
volatile BYTE UART_BASE_3		@0x243;


// the following hard-coded locations MUST be editted
// if your memory map is not the vautomation default


volatile WORD LastHexWord = 0x0410;	// the most recent word read, used for future defaults
BYTE linebuf[32] = {0xee};

void PutOnion(void);
void PutOnionSpace(void);


BYTE UartReadHex()	// read two hex chars and create a byte from them
{
	static BYTE	c1, c2;

	c1 = Ascii2Hex(UartReadChar());
	c1 <<= 4;
	c2 = Ascii2Hex(UartReadChar());

	return c1 | c2;
}

WORD UartReadHexWord()	// read up to four hex chars and create a word from them
{
	static BYTE	c, c2;

	c = UartReadString(linebuf, 32);
	if (!c)					// only a CR was entered
		return LastHexWord;	// use last value

	LastHexWord = 0;

	for (c2=0; c2<c; c2++)
		{
		if (!IsHex(linebuf[c2]))	// end of hex chars
			break;					// return what we've got

		LastHexWord <<= 4;
		LastHexWord += Ascii2Hex(linebuf[c2]);
		}

	return LastHexWord;
}

BYTE IsHex(BYTE c)
{

	if (c < '0')
		return 0;	// less than '0' so not hex
	if (c <= '9')
		return 1;	// less than or equal '9' so hex
	c |= 0x20;		// tolower
	if (c < 'a')	// less than 'a' so not hex
		return 0;
	if (c <= 'f')	// less than or equal 'f' so hex
		return 1;
	return 0;		// greated than 'f' so not hex
}

BYTE Ascii2Hex(BYTE c)	// convert 0-9 or a-f in acsii to hex
{

	c &= 0x5f;				// to lower
	if (c < 0x40)			// if 0-9
		return c & 0x0f;	// mask off all but low 4 bits
	return c - 0x37;		// a-f, subtract 'a' and add 10
}

BYTE UartReadString(PBYTE p, BYTE len)	// read chars and build string until len
{										// or \r reached.  Not null terminated.
	static BYTE	l;
	static BYTE	c;

	l = 0;
	for (;;)
		{
		c = UartReadChar();
		putc(c);
		if (c == '\r')
			return l;
		if (c == '\b' || c == 0x7f)	// if backspace or delete
			{
			if (l)					// if char has been typed
				l--;				// delete most recent
			continue;
			}
		p[l++] = c;					// add char to buffer
		if (l == len)
			return l;				// we've reached length limit
		}
}

#if 0
#if WANT_HARDWARE && !WANT_LITE
void putl(unsigned long l)	// output a 32 bit value in base 10
{
	static char	buff[12];
	static BYTE	i;
	static long l2, r;

	l2 = l;
	for (i=0; !i || (i<12 && l2); i++)	// generate chars in reverse order
		{
		r = l % 10;		// remainder
		l2 = l / 10;	// quotient
		buff[i] = '0' + (char)r;
		l = l2;
		}

	while (i)	// now reverse the reverse order
		putc(buff[--i]);

	return;
}
#endif // WANT_HARDWARE && !WANT_LITE
#endif

PBYTE PutString_string;

void puts(PBYTE pb)		// output each char in a string until a null is reached
{
// This code is not re-entrant.  If an interrupt fires while we're in this routine
// pb will get hosed.

//	disableInterrupts();
	PutString_string = pb;
	while (*PutString_string)
		{
		putc(*PutString_string++);
		}
	if (*pb == '~')
		putc('~');
//	enableInterrupts();
}

void putSpace()		// output a space
{
	putc(' ');
	return;
}
void putCrlf()		// output a CR and LF
{
	putc('\r');
	putc('\n');
	return;
}

BYTE PutByte_byte;
BYTE PutByte_nibble;

void putb(register const BYTE b)	// output a byte in hex
{
	PutByte_byte=b;
	PutByte_nibble = PutByte_byte>>4;
	putc(Hex2Ascii(PutByte_nibble));
	PutByte_nibble = PutByte_byte & 0x0f;
	putc(Hex2Ascii(PutByte_nibble));
}

void putbs(register const BYTE b)	// output a byte in hex followed by a space
{
	putb(b);
	putSpace();
}

ONION PutOnion_onion;

void putw(register const WORD w)	// output a word in hex
{
	PutOnion_onion.w = w;
	PutOnion();
}

void putws(register const WORD w)	// output a word in hex followed by a space
{
	PutOnion_onion.w = w;
	PutOnion();
	putSpace();
}

void puto(register const ONION o)	// output an onion in hex
{
	PutOnion_onion = o;
	PutOnion();
}

void putos(register const ONION o)	// output an onion in hex followed by a space
{
	PutOnion_onion = o;
	PutOnion();
	putSpace();
}

void PutOnion()
{
	putb(PutOnion_onion.b.h);
	putb(PutOnion_onion.b.l);
	return;
}

BYTE UartGetAndEchoChar()
{
	static BYTE	c;

#if !WANT_HARDWARE
	c = 0;
#endif

	do	{
		putFlushOneIfReady();
		} while (!UartCharWaiting());

	c = UartReadChar();
	putc(c);
	return c;
}

void putUnknown(BYTE b)
{

	putb(b);
	puts(" = Unknown Command\r\n");
	return;
}

static BYTE	uart_pch, uart_pcl;

void putReturnAddress()
{

#asm
	pop r0
	pop r1
	pop r2
	pop r3
	psh r3
	psh r2
	psh r1
	psh r0
	sta r0,_uart_pcl
	sta r1,_uart_pch
#endasm
	putb(uart_pch);
	putb(uart_pcl);

	return;
}

