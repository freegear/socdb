/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Uart_BoundaryTests.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function BoundaryTests which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/************************* BoundaryTests **************************************/
/******************************************************************************/

void BoundaryTests(void)
{
  /*
    Summary: BoundaryTests
    ======================

    It contains the test for some boundary conditions which are very unlikely 
    to occur. These tests are frequency dependent so are being disabled in case
    of different UARTCLK and PCLK.
    The first test is to read and write the UART FIFO at the same time. This 
    is being done by manually counting the PCLK cycles between one write and 
    subsequent read. Thus, this is frequency dependent test.
    Another test is conducted for abort operation at different phases of 
    transmission and reception. All these tests are being conducted in 
    loopback mode.
  
  */ 
  int hword;
  unsigned int divisor;

  int i = 0,j, reg_val;
  int wlength;
  int32 bit_cycles, byte_cycles;
  int32 some_cycles = 10;
  int cword = 0x00;
  unsigned long bit_width;
 
  divisor = 0x03;
  hword = 0x7e;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
  cword = 0x381;

  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);

  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_r);
 
  PSW(cword, UARTCR_new);
  
  C("Boundary Condition Test: Read And Write At Same Time In FIFO");

  for(i = 0; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
    }
 
  PO( 0 , UART_UBUSY, UARTFR,(byte_cycles*i),poll11);
 
  for(i=0; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xff, UARTDR,utdrlast);
      PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast);
    }

  PSW(0xff, UARTDR);
  P_IDLE(710); 
  PSW(0xff, UARTDR);
  PO( 0 , UART_UBUSY, UARTFR,(byte_cycles*2),poll11);
  PSR(0xff, 0xff, UARTDR,utdrlast);
  PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast);
  PSR(0xff, 0xff, UARTDR,utdrlast);
  PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast);
  
  PSW(0x0, UARTCR_new); 
  hword = 0x6e;
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(cword, UARTCR_new);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_s);

  PSR(0xff, 0xfff, UARTDR, uartbound);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_z);
  

  cword = 0x381;
  C("Abort Transmit And Recieve Test: At Start Bit:Illegal Baud"); 
  PSW(0x99, UARTDR);
  PI(0x0a);
    
  ConfigureUbrlcr(0x0,hword, UARTLCR_H_new);
  P_IDLE(byte_cycles*2);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11);
  


  C("Abort Transmit And Recieve Test: At Stop Bit:Illegal Baud");
  PSW(0x99, UARTDR);
  PI(0x0a);
 
  P_IDLE(10*bit_cycles);
  
  ConfigureUbrlcr(0x0,hword,UARTLCR_H_new);
  P_IDLE(byte_cycles*2); 
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11);


  C("Abort Transmit And Recieve Test:At Extra Stop Bit:Illegal Baud");
  PSW(0x99, UARTDR);
  PI(0x0a);

  P_IDLE(bit_cycles*11);

  ConfigureUbrlcr(0x0,hword,UARTLCR_H_new);
  P_IDLE(byte_cycles*2);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11);


  C("Abort Transmit And Recieve Test: At Parity Bit:Illegal Baud");
  PSW(0x99, UARTDR);
  PI(0x0a);

  P_IDLE(bit_cycles*9);

  ConfigureUbrlcr(0x0,hword | 0x01,UARTLCR_H_new);
  P_IDLE(byte_cycles*2);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11);
  
} 
