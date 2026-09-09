/*----------------------------------------------------------
	File Name   : uart.c 
	Description : UART API
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include <stdarg.h>
#include "Commonmacro.h"
#include "uart.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */


/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */



/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */

/*-----------------------------------------------------------------------
    Function name   : UartInit(void)
    Prototype       : void UartInit(void)
    Return          :
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void UartInit(void)
{
	SMT_WRITE(UART0_BRD, BAUDRATE_SETTING);

	SMT_WRITE(UART0_CMD, 
				(1<<31)		// enable UART
				| (0<<30)	// disable interrupt
				| (0<<29)	// disable receive timeout
				| (0<<28)	// no reset
				| (0<<27)	// disable DMA request
				| (0x00<<25)	// No parity
				| (1<<24)		// 8bit data
				| (0<<23)		// 1 stop bit
				| (0<<22)		// disable loobback
				| (1<<8)		// TX Waterlevel
				| (7)			// RX Waterlevel
	);
}

/*-----------------------------------------------------------------------
    Function name   : UartPutch(char ch)
    Prototype       : void UartPutch(char ch)
    Return          :
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
void UartPutch(char ch)
{
  
  while (1) {
    if((SMT_READ(UART0_SR) & 0x00003f00 )  != 0x00002000) // FIFO no full
//    if((SMT_READ(UART0_SR) & 0x00003f00 )  != 0x00000700) // FIFO no full
//    if((SMT_READ(UART0_SR) & 0x00003f00)  == 0x00000000) // FIFO is empty
    {
      SMT_WRITE(UART0_TX, (long)(ch & 0xff));
      return ;
    }
  }
}
/*-----------------------------------------------------------------------
    Function name   : UartPutHex(char ch)
    Prototype       : void UartPutHex(char ch)
    Return          : 
    Argument        :
    Comments        : UART to char -> ASCII hex
-----------------------------------------------------------------------*/
void UartPutHex(char ch)
{
    UartPuts("0x");
    
    if (((ch>>4)&0x0f)<=9)
    UartPutch(((ch>>4)&0x0f)+0x30);
    else
    UartPutch(((ch>>4)&0x0f)+0x37);
    
    if ((ch&0x0f)<=9)
    UartPutch((ch&0x0f)+0x30);
    else
    UartPutch((ch&0x0f)+0x37);
    
}
/*-----------------------------------------------------------------------
    Function name   : UartPutHex16(int ch)
    Prototype       : void UartPutHex16(int ch)
    Return          : 
    Argument        :
    Comments        : UART to char -> ASCII 16bit hex
-----------------------------------------------------------------------*/
void UartPutHex16(int ch)
{
    UartPuts("0x");
    
    if (((ch>>12)&0x0f)<=9)
    UartPutch(((ch>>12)&0x0f)+0x30);
    else
    UartPutch(((ch>>12)&0x0f)+0x37);
    
    if (((ch>>8)&0x0f)<=9)
    UartPutch(((ch>>8)&0x0f)+0x30);
    else
    UartPutch(((ch>>8)&0x0f)+0x37);
    
    if (((ch>>4)&0x0f)<=9)
    UartPutch(((ch>>4)&0x0f)+0x30);
    else
    UartPutch(((ch>>4)&0x0f)+0x37);
    
    if ((ch&0x0f)<=9)
    UartPutch((ch&0x0f)+0x30);
    else
    UartPutch((ch&0x0f)+0x37);
    
}



/*-----------------------------------------------------------------------
    Function name   : UartPutHex32(int ch)
    Prototype       : void UartPutHex32(int ch)
    Return          : 
    Argument        :
    Comments        : UART to char -> ASCII 32bit hex
-----------------------------------------------------------------------*/
void UartPutHex32(int ch)
{
    UartPuts("0x");
    
    if (((ch>>28)&0x0f)<=9)
    UartPutch(((ch>>28)&0x0f)+0x30);
    else
    UartPutch(((ch>>28)&0x0f)+0x37);

    if (((ch>>24)&0x0f)<=9)
    UartPutch(((ch>>24)&0x0f)+0x30);
    else
    UartPutch(((ch>>24)&0x0f)+0x37);

    if (((ch>>20)&0x0f)<=9)
    UartPutch(((ch>>20)&0x0f)+0x30);
    else
    UartPutch(((ch>>20)&0x0f)+0x37);

    if (((ch>>16)&0x0f)<=9)
    UartPutch(((ch>>16)&0x0f)+0x30);
    else
    UartPutch(((ch>>16)&0x0f)+0x37);

    if (((ch>>12)&0x0f)<=9)
    UartPutch(((ch>>12)&0x0f)+0x30);
    else
    UartPutch(((ch>>12)&0x0f)+0x37);
    
    if (((ch>>8)&0x0f)<=9)
    UartPutch(((ch>>8)&0x0f)+0x30);
    else
    UartPutch(((ch>>8)&0x0f)+0x37);
    
    if (((ch>>4)&0x0f)<=9)
    UartPutch(((ch>>4)&0x0f)+0x30);
    else
    UartPutch(((ch>>4)&0x0f)+0x37);
    
    if ((ch&0x0f)<=9)
    UartPutch((ch&0x0f)+0x30);
    else
    UartPutch((ch&0x0f)+0x37);
    
}

/*-----------------------------------------------------------------------
    Function name   : UartPuts(char *)
    Prototype       : void UartPuts(char *)
    Return          : 
    Argument        : char *
    Comments        : Tranmit String
-----------------------------------------------------------------------*/
void UartPuts(char * str)
{
	
	int index = 0 ;
	while( str[index] != '\000')  
	{      	
		UartPutch( (char) str[index] ) ;      
		if(str[index] == '\n')
			UartPutch('\r');
		index++;            
	} 
}

/*-----------------------------------------------------------------------
    Function name   : UartPrintf(const char *format, ...)
    Prototype       : void UartPrintf(const char *format, ...)
    Return          : 
    Argument        : const char *,...
    Comments        : Tranmit Formmatted String
-----------------------------------------------------------------------*/
int vsnprintf(char *str, int size, const char *fmt, va_list ap);
void UartPrintf(const char * format, ...)
{
	unsigned char str[UART_PRINTF_MAX_STRING];
	va_list ap;

	va_start(ap, format);
	vsnprintf(str, UART_PRINTF_MAX_STRING, format, ap);
	va_end(ap);

	UartPuts(str);
}

/*-----------------------------------------------------------------------
    Function name   : UartGetch()
    Prototype       : long UartGetch()
    Return          : 
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
char UartGetch()
{
    while((SMT_READ(UART0_SR) & 0x0000003f ) == 0x00000000); // FIFO no full

    return (SMT_READ(UART0_RX)& 0xff);  
}

/*-----------------------------------------------------------------------
    Function name   : UartDataAvailable()
    Prototype       : int UartDataAvailable()
    Return          : 1 when you can read Uart RX Data
    Argument        :
    Comments        :
-----------------------------------------------------------------------*/
int UartDataAvailable()
{
	return ((SMT_READ(UART0_SR) & 0x0000003f) != 0x00000000);
}

