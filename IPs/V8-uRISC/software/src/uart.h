// uart.h

typedef struct
	{
		BYTE	rxFrameError:1,
				rxOverFlow:1,
				rxEnable:1,
				rxFull:1,
				:2,
				txEnable:1,
				txEmpty:1;
	} UART_STATUS;

extern volatile BYTE UART_BASE_0;
extern volatile UART_STATUS uartStatus;
extern volatile BYTE UART_BASE_2;
extern volatile BYTE UART_BASE_3;

BYTE UartReadChar(void);
WORD UartReadHexWord(void);
BYTE Ascii2Hex(BYTE c);
BYTE UartCharWaiting(void);
BYTE IsHex(BYTE c);
BYTE UartReadString(PBYTE p, BYTE len);
void UartInit(BYTE speed);
void UartBufferInit(void);
BYTE Ascii2Hex(BYTE c);
void UartWait(void);
BYTE UartGetAndEchoChar(void);
void putReturnAddress(void);


void puts(PBYTE pb);

void putc(register const BYTE b);
void putSpace(void);
void putCrlf(void);

void putb(register const BYTE b);
void putbs(register const BYTE b);

void putw(register const WORD w);
void putws(register const WORD w);

void puto(register const ONION o);
void putos(register const ONION o);

#if !WANT_LITE
void putl(unsigned long l);
#endif // !WANT_LITE

void putFlush(void);
void putFlushOneIfReady(void);

void putUnknown(BYTE b);

#define Hex2Ascii(hhh) ((hhh < 10) ? '0' + hhh: 55 + hhh)


