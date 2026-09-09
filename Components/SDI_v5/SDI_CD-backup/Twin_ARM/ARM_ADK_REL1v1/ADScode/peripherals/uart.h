//--========================================================================--
// This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT  2001 ARM Limited
//       ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           :uart.h,v
//  File Revision       :1.5
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Uart registers
//
//--========================================================================--

#ifndef UART_H
#define UART_H

#include "globals.h"

typedef struct
{ 
  volatile Word     UARTDR;           
  volatile Word     UARTECR_RSR;   
  volatile Word     UARTLCR_H;     
  volatile Word     UARTLCR_M;     
  volatile Word     UARTLCR_L;     
  volatile Word     UARTCR;        
  volatile Word     UARTFR;        
  volatile Word     tmp1;          
  volatile Word     UARTILPR;      
  volatile Word     UARTIBRD;      
  volatile Word     UARTFBRD;      
  volatile Word     UARTLCR_H_new; 
  volatile Word     UARTCR_new;    
  volatile Word     UARTIFLS;      
  volatile Word     UARTIMSC;      
  volatile Word     UARTRIS;       
  volatile Word     UARTMIS;       
  volatile Word     UARTICR;       
  volatile Word     UARTDMACR;     
} Uart;
extern Uart uart;

/*
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

#define UART_BASE 0XC9000000
#define UART_DR       0x00
#define UARTECR_RSR   0x04

//(volatile u8* )(UART_BASE+UART_DR)     = 0x55; @0X00   HSIZE = 000
  (volatile u16*)(UART_BASE+UART_DR)     = 0x55;         HSIZE = 001 
//(volatile u32*)(UART_BASE+UART_DR)     = 0x55;         HSIZE = 010
  (volatile u32*)(UART_BASE+UARTECR_RSR) = 0x15; @0X04

*/

// Peripheral ID
#define UART_ID_VALUE  0x00241011
#define UART_ID_MASK   0xFFFFFFFF

//Byte TXdata[6] = {0x30, 0x31, 0x32, 0x33, 0x34, 0x35}; 

#endif // defined( UART_H )

