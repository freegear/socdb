/*----------------------------------------------------------
	File Name   : uart.h
	Description : UART API
	Created by  : SHMT SOC Team
-----------------------------------------------------------*/

#ifndef _UART_H_
#define _UART_H_
/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"

/*/////////////////////////////////////////////////////////
        DEFINITION
///////////////////////////////////////////////////////// */

#define BAUDRATE		38400				// 38400 bps
#define BAUDRATE_SETTING	(unsigned)(((float)(BAUDRATE*16))*65536.0/((float)APB1_CLK) + 0.5)
//#define BAUDRATE_SETTING	(unsigned)(65536/4)

#define UART_PRINTF_MAX_STRING 128
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */

void UartPutch(char ch);
void UartPuts(char *str);
void UartPrintf(const char * format, ...);
void UartInit(void);
void UartPutHex(char ch);
void UartPutHex16(int ch);
void UartPutHex32(int ch);
char UartGetch(void);
int  UartDataAvailable(void);


// Debug Related
//#define SIMUL
#ifdef SIMUL
#define DPRINTF(fmt, args...)		/* NULL */
#else
#define DPRINTF(fmt, args...)	UartPrintf(fmt, ##args)
#endif

#endif
