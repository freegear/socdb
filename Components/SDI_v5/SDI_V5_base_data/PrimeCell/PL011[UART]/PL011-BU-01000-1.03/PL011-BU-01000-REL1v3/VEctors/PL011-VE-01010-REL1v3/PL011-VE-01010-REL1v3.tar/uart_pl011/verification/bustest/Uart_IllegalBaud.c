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
--  File Name              : Uart_IllegalBaud.c.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function IllegalBaudTest which is called in
   the main file Uart.c
/******************************************************************************/
/****************************** IllegalBaudTest *******************************/
/******************************************************************************/

void IllegalBaudTest(void)
{
  /*
  Summary: Illegal Baud Tests
  ===========================

  The Illegal baud test checks the activity on the Tx line if an illegal
  divisor(0) has been programmed into the UARTLCR_L and UARTLCR_M register.
  If divisor value has been programmed 0, then Tx must remain high. After
  this, UART is configured with non-zero divisor value. The UART is then 
  enabled and allowed to run till it finishes transmitting the byte. The
  byte should be recieved correctly.

  */
  
  int i;
  unsigned int divisor = 0x02;
  unsigned long bit_width;
  int hword = 0x00,wlength;
  int32 some_cycles = 10;
  int32 byte_cycles,bit_cycles;
 
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;


  C("Illegal Baud Test");

  /* Disable the Uart & Trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(0,0, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PSW(0x00, UARTFBRD);
  PSW(0x00, UTFBRD);

  /* Write some data byte to UART */
  PSW(DATA_5s, UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr11a);

  /* Enable the UART  & Trickbox*/
  PSW(0x101, UTCR);
  PI(2);
  PSW(0x101, UARTCR_new);

  for( i=0; i< byte_cycles; i++)
  {
    PSR(0x01, 0x01, UT_CHECK_PINS,txpin1);
  }

  PSW(0x00, UARTCR_new);
  P_IDLE(byte_cycles);

  /* Configure the Uart with a legal divider value */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(0x00, UARTFBRD);

  PSW(0x101, UARTCR_new);
  PI(2);
  PO(UART_TXFE | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR,byte_cycles,uartfr11b)
  PI(2);
  PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,byte_cycles,uartfr11c);
  PSR(DATA_5s & masks[wlength], 0xff, UTDR,utdr11c);

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);

  /* Configure the Uart with the other case of invalid divisor - Ineteger all 1's and
     Fractional part greater than 0 */
  
  ConfigureUbrlcr(0xffff,0, UARTLCR_H_new);
  PSW(0x10, UARTFBRD);

  /* Write some data byte to UART */
  PSW(DATA_As, UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr11d);

  /* Enable the UART  & Trickbox*/
  PSW(0x101, UARTCR_new);

  for( i=0; i< byte_cycles; i++)
  {
    PSR(0x01, 0x01, UT_CHECK_PINS,txpin2);
  }

  PSW(0x00, UARTCR_new);
  P_IDLE(byte_cycles);

  /* Configure the Uart with a legal divider value */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(0x00, UARTFBRD);

  PSW(0x101, UARTCR_new);
  PI(2);
  PO(UART_TXFE | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR,byte_cycles,uartfr11e)
  PI(2);
  PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,byte_cycles,uartfr11f);
  PSR(DATA_As & masks[wlength], 0xff, UTDR,utdr11c);

  
  /* Disable Uart and trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTDR);

  
  C("Illegal Baud Test : IRDA MODE");

  /* Disable the Uart & Trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(0,0, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PSW(0x10, UARTFBRD);
  PSW(0x10, UTFBRD);

  /* Write some data byte to UART */
  PSW(DATA_5s, UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr11d);

  PSR(0x00, 0x02, UT_CHECK_PINS,txpin1);

  /* Enable the UART  & Trickbox*/
  PSW(0x103, UTCR);
  PI(2);
  PSW(0x103, UARTCR_new);

  for( i=0; i< byte_cycles; i++)
  {
    PSR(0x00, 0x02, UT_CHECK_PINS,txpin2);
  }

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);
  
  /* Configure the Uart with a legal divider value */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

 /* Enable the UART */
  PSW(0x103, UARTCR_new);
  PI(2);
  
  PO(UART_TXFE | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, byte_cycles,uartfr11e);
  PI(2);
  PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr11f);
  PSR(DATA_5s & masks[wlength], 0xff, UTDR,utdr11a);


  /* Disable the Uart */
  PSW(0x00, UARTCR_new);

  /* Configure the Uart with the other case of invalid divisor - Ineteger all 1's and
     Fractional part greater than 0 */
  
  ConfigureUbrlcr(0xffff,0, UARTLCR_H_new);
  PSW(0x10, UARTFBRD);
 
  /* Write some data byte to UART */
  PSW(DATA_As, UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr11d);

  PSR(0x00, 0x02, UT_CHECK_PINS,txpin1);
  
  /* Enable the UART  & Trickbox*/
  PSW(0x103, UARTCR_new);

  for( i=0; i< byte_cycles; i++)
  {
    PSR(0x00, 0x02, UT_CHECK_PINS,txpin2);
  }

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);

/*   P_IDLE(byte_cycles); */

  /* Configure the Uart with a legal divider value */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(0x10, UARTFBRD);

 /* Enable the UART */
  PSW(0x103, UARTCR_new);
  PI(2);
  
  PO(UART_TXFE | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR,byte_cycles,uartfr11e)
  PI(2);
  PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,byte_cycles,uartfr11f);
  PSR(DATA_As & masks[wlength], 0xff, UTDR,utdr11c);



  C("Illegal Baud Test : IRDA  LP MODE");

  /* Disable the Uart & Trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(0,0, UARTLCR_H_new);
  PSW(0x00, UARTFBRD);
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PSW(0x00, UTFBRD);

  /* Write some data byte to UART */
  PSW(DATA_5s, UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr11g);

  PSR(0x00, 0x02, UT_CHECK_PINS,txpin1);

  /* Enable the UART  & Trickbox*/
  PSW(0x107, UARTCR_new);
  PSW(0x107, UTCR);

  for( i=0; i< byte_cycles; i++)
  {
    PSR(0x00, 0x02, UT_CHECK_PINS,txpin2);
  }

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);
  
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);
  
 /* Enable the UART */
  PSW(0x107, UARTCR_new);
  PI(2);

  PO(UART_TXFE | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr11h)
  PI(2);
  PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr11i)
  PSR(DATA_5s & masks[wlength], 0xff, UTDR,utdr11b);

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);

  /* Configure the Uart with the other case of invalid divisor - Ineteger all 1's and
     Fractional part greater than 0 */
  
  ConfigureUbrlcr(0xffff,0, UARTLCR_H_new);
  PSW(0x25, UARTFBRD);

  /* Write some data byte to UART */
  PSW(DATA_As, UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr11d);

  PSR(0x00, 0x02, UT_CHECK_PINS,txpin1);
  
  /* Enable the UART  & Trickbox*/
  PSW(0x107, UARTCR_new);

  for( i=0; i< byte_cycles; i++)
  {
    PSR(0x00, 0x02, UT_CHECK_PINS,txpin2);
  }

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);

  /* Configure the Uart with a legal divider value */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(0x00, UARTFBRD);

 /* Enable the UART */
  PSW(0x107, UARTCR_new);
  PI(2);
  
  PO(UART_TXFE | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR,byte_cycles,uartfr11e)
  PI(2);
  PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,byte_cycles,uartfr11f);
  PSR(DATA_As & masks[wlength], 0xff, UTDR,utdr11c);

  PSW(0x00, UARTCR_new);
  PSW(0x00,UTCR);
}
