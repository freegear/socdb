/*
 *	serial.c
 */



#include "includes.h"
//////////////////////////////   PXA255  //////////////////////////////////////////


#define FFUART_BASE 0x40100000
#define FFRBR (*((volatile INT32U *)(FFUART_BASE+0x00)))
#define FFTHR (*((volatile INT32U *)(FFUART_BASE+0x00)))
#define FFIER (*((volatile INT32U *)(FFUART_BASE+0x04)))
#define FFIIR (*((volatile INT32U *)(FFUART_BASE+0x08)))
#define FFFCR (*((volatile INT32U *)(FFUART_BASE+0x08)))
#define FFLCR (*((volatile INT32U *)(FFUART_BASE+0x0C)))
#define FFMCR (*((volatile INT32U *)(FFUART_BASE+0x10)))
#define FFLSR (*((volatile INT32U *)(FFUART_BASE+0x14)))
#define FFMSR (*((volatile INT32U *)(FFUART_BASE+0x18)))
#define FFSPR (*((volatile INT32U *)(FFUART_BASE+0x1C)))
#define FFISR (*((volatile INT32U *)(FFUART_BASE+0x20)))
#define FFDLL (*((volatile INT32U *)(FFUART_BASE+0x00)))
#define FFDLH (*((volatile INT32U *)(FFUART_BASE+0x04)))

#define GPIO_BASE 0x40E00000
#define GAFR1_L		(*((volatile INT32U *)(GPIO_BASE+0x5c)))
#define GPDR1 		(*((volatile INT32U *)(GPIO_BASE+0x10)))


#define SERIAL_BAUD_115200 (0x00000008)

void SerialOutputByte(const char);
int SerialInputByte(char *);

unsigned long baud;
//void SerialInit(unsigned long baud)
void SerialInit(void)
{

	// GP39, GP40, GP41 UART(10) . 을 로 사용한다
        GAFR1_L |= 0x000A8000;
        GPDR1 |= 0x00000380;
	
        // 8-bit, 1 stop, no parity . 세팅
	FFLCR = 0x00000003;
	
	// Reset tx, rx FIFO. clear. FIFO enable
	FFFCR = 0x00000007;
        
	// UART Enable Interrupt
	FFIER = 0x00000040;

	// DLAB set=latch registers, DLAB clear= . 일반 포트
        FFLCR |= 0x00000080;
        
	// baud rate . 설정
        FFDLL = SERIAL_BAUD_115200;
	
	// DLAB clear, . 일반 포트로 전환
	FFLCR &= 0xFFFFFF7F;
	
        // Transmit Shift Register, Transmit Holding Register, FIFO 에
	// . 데이타가 없을때까지 기다린다
	while(! FFLSR & 0x00000040 );

	return;
}


void SerialOutputByte(const char c){

	// FIFO . 에 데이타가 없을때까지 기다린다
        while ((FFLSR & 0x00000020) == 0 );
        
	FFTHR = ((INT32U)c & 0xFF);
        
	// c=='\n' , "\n\r" . 이면 실제로는 을 출력
	if (c=='\n') SerialOutputByte('\r');
}
	
        
int SerialInputByte(char *c){
		
        	// FIFO . 에 데이타가 있을때
        	if((FFLSR & 0x00000001)==0){
		return 0;
        	} else {
	
		*(volatile char *)c = (char)FFRBR;
		return 1;
	}
}


//------------------------------------------------------------------------------
// 설명 : 시리얼 디바이스에서 한 문자를 받는다. 
// 매계 : 없음 
// 반환 : 수신된 데이타가 있으면 1 / 없으면 0
// 주의 : 없음 
//------------------------------------------------------------------------------
int SerialIsReadyChar( void )
{
        // 수신된 데이타가 있는가를 확인한다. 
	if(FFLSR & 0x00000001)
	       	return 1;
	return 0;
}

//------------------------------------------------------------------------------
// 설명 : 시리얼 디바이스에서 한 문자를 받는다. 
// 매계 : 없음 
// 반환 : 수신된 문자 
// 주의 : 없음 
//------------------------------------------------------------------------------
char SerialIsGetChar( void )
{
	// 수신된 데이타를 가져 온다. 
	return (char)FFRBR;
}












//////////////////////////////   SA1110  //////////////////////////////////////////

/*
#include "serial_sa1110.h"
//#include "serial_pxa255.h"

// 역할 : serial을 주어진 baudrate로 다시 초기화.
// 매개 : SCR : SCR에 지정할 값. Baudrate를 BaudToSCR(A)을 통해 SCR의 값으로 바꿀 수 있다.
// 반환 : 
// 주의 : 
void SerialInit(SCR scr)
{
	// 1. Flush the output buffer. serial이 동작중인 동안 기다림.
	while (UTSR1 & UTSR1_TBY);

	// 2. Rx, Tx off.
	UTCR3 = 0x00;
	UTSR0 = 0xff;	// 죄송합니다. 왜 0xff인지 이유를 모르겠습니다.

	// 3. Serial을 사용하고자 하는 방식으로 set.
	UTCR0 = (UTCR0_1StpBit | UTCR0_8BitData);

	// 4. Set Baudrate.
	UTCR1 = 0;
	UTCR2 = (INT32U)scr;

	// 5. Rx, Tx on.
	UTCR3 = (UTCR3_RXE | UTCR3_TXE);
	return;
}

// Output a single byte to the serial port.
void SerialOutputByte(const char c)
{
	// wait for room in the tx FIFO.
	while (!(UTSR0 & UTSR0_TFS));
	UTDR = c;

	// c=='\n'이면, 실제로는 "\n\r"을 출력.
	if (c=='\n') SerialOutputByte('\r');
}

// Write a null terminated string to the serial port.
void SerialOutputString(const char *s)
{
	while (*s != 0) 
	{
		SerialOutputByte(*s);
		// If \n, also do \r.
		if (*s == '\n') SerialOutputByte('\r');
		s++;	
	}


} // SerialOutputString.

// Read a single byte from the serial port. Returns 1 on success, 0
// otherwise. When the function is succesfull, the character read is
// written into its argument c.
int SerialInputByte(char *c)
{
	if(UTSR1 & UTSR1_RNE){
		int err = UTSR1 & (UTSR1_PRE | UTSR1_FRE | UTSR1_ROR);
		*c = UTDR;

		// If you're lucky, you should be able to use this as
		// debug information.
		if(err & UTSR1_PRE)
			SerialOutputByte('@');
		else if(err & UTSR1_FRE)
			SerialOutputByte('#');
		else if(err & UTSR1_ROR)
			SerialOutputByte('$');
	
		// We currently only care about framing and parity errors.
		if((err & (UTSR1_PRE | UTSR1_FRE)) != 0){
			return SerialInputByte(c);
		}
		else return 1;
	}
	else {
			// no bit ready.
			return(0);
	}
} // SerialInputByte.


//------------------------------------------------------------------------------
// 설명 : 시리얼 디바이스에서 한 문자를 받는다. 
// 매계 : 없음 
// 반환 : 수신된 데이타가 있으면 1 / 없으면 0
// 주의 : 없음 
//------------------------------------------------------------------------------
int SerialIsReadyChar( void )
{
        // 수신된 데이타가 있는가를 확인한다. 
	if(UTSR1 & UTSR1_RNE)
	       	return 1;
	return 0;
}

//------------------------------------------------------------------------------
// 설명 : 시리얼 디바이스에서 한 문자를 받는다. 
// 매계 : 없음 
// 반환 : 수신된 문자 
// 주의 : 없음 
//------------------------------------------------------------------------------
static int SerialErrorFlag = 0;
char SerialIsGetChar( void )
{
	// 에러를 가져 온다. 
	SerialErrorFlag = UTSR1 & (UTSR1_PRE | UTSR1_FRE | UTSR1_ROR);
	// 수신된 데이타를 가져 온다. 
	return (char)UTDR;
}
*/
