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
--  File Name              : Uart_BreakTest.c.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function BreakTest which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/*************************** BreakTest ****************************************/
/******************************************************************************/

void BreakTest(void)
{
  /* 
     Summary: Break Error Tests
     ==========================
  
     The break error tests checks the transmit break function. Two bytes are
     written into the UART FIFO. After the UART just starts transmitting the 
     first byte, the break bit is set in the register UARTLCR_H of the UART.
     This will force LOW on the UARTTXD pin. The trickbox is disabled and
     UART break is released. And then Trickbox is enabled. The UART is allowed 
     to run till it stop transmitting. The data byte is then read from the 
     TrickBox data register. The transmission of first data byte should have been
     aborted and only the second byte in the fifo should have been transmitted
     after break is released

  */ 
 
  int i;
  int hword = 0x00,wlength;
  int32 some_cycles = 10;
  int32 byte_cycles ,bit_cycles,irda_bit_cycles, irda_lp_bit_cycles;
  unsigned int divisor = 0x01;
  unsigned long bit_width;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
 
  irda_bit_cycles = (unsigned long)(3 * (float)(bit_cycles / 16));
  irda_lp_bit_cycles = (unsigned long)((3 * (IRLP_DIV) * UARTCLK_PERIOD) / PCLK_PERIOD);


  if (PCLK_PERIOD > UARTCLK_PERIOD)
    wait_factor = (PCLK_PERIOD/UARTCLK_PERIOD); 
  else
    {
      if( UARTCLK_PERIOD > PCLK_PERIOD)
	wait_factor = (UARTCLK_PERIOD/PCLK_PERIOD) ;
      else
	wait_factor  = 1;
    }
  
  C("Break Tests : NORMAL MODE");

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
  PSW(0x00, UARTFBRD);
  PSW(0x00, UTFBRD);

  /* Write Some data to the uart data register */
  PSW(0xff , UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr1);

  /* Enable the trick box and the uart */
  PSW(0x01, UTCR); 
  PSW(0x301, UARTCR_new);
 
  Idle(bit_cycles * 2);

  PSW(DATA_As , UARTDR);

  /* Send Break character */
  PSW(0x01, UARTLCR_H_new);

  /* Wait for the character to finish being transmitted */
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,poll1);
  
/* Disable the Trickbox */
  PSW(0x00, UTCR);
  
  /* wait for the TXD line to go low, it should stay low while the break is asserted */
  PO(0x00, 0x01, UT_CHECK_PINS, wait_factor * some_cycles,poll1);

  for(i=0; i< 50; i++)
    {
      PSR(0x00, 0x01, UT_CHECK_PINS,utpin1a);
      PI(0x02);
    }
  
  PSR(0xff & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr);

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);
  PI(2);
 
  /* Release break */
  PSW(0x00, UARTLCR_H_new);

  /* Enable the Uart */
  PSW(0x301, UARTCR_new);
  
 /*  P_IDLE( wait_factor * 4);  */
 PI(2);
 
  /* Enable the Trickbox */
  PSW(0x01, UTCR); 

  /* Check the value of TX pins - it shoudl go high as soon as break is deasserted */
  PO(0x01, 0x01, UT_CHECK_PINS, bit_cycles,poll2);

  PI(2);

  /* Wait till the byte is received by trickbox */
  PO(0x00, UTRXFIFO_EMPTY, UTFR, byte_cycles,uartfr3);


  PSR(DATA_As & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr);

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);


  C("Break Tests : IRDA Mode");

  PSW(0x33 , UARTDR);

  /* Enable the trick box and the uart in irda mode*/
  PSW(0x03, UTCR); 

  PSW(0x303, UARTCR_new);
  
  Idle(bit_cycles * 2);

  PSW(0x77, UARTDR);


  /* Send Break character */
  PSW(0x01, UARTLCR_H_new);

  /* Wait for the character to finish being transmitted */
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,poll1);

  /* Disable the Trickbox */
  PSW(0x00, UTCR);

  PO(0x02, 0x02, UT_CHECK_PINS, bit_cycles,poll1);
  Idle(irda_bit_cycles + 1);
  PSR(0x00, 0x02, UT_CHECK_PINS,utpin1b);

  for(i=0; i< 50; i++)
    {
      Idle(bit_cycles);
    }

  PSR(0x33 & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr);

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);
  PI(2);
 
  /* Release break */
  PSW(0x00, UARTLCR_H_new);

  /* Enable the Uart */
  PSW(0x303, UARTCR_new);

  PI(0x2);
  
  /* Enable the Trickbox */
  PSW(0x03, UTCR);

  PO(0x00, UTRXFIFO_EMPTY, UTFR, byte_cycles,uartfr3);

  PSR(0x77 & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr);

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);

  C("Break Tests : IRDA LP Mode");

  PSW(0x33 , UARTDR);

  /* Enable the trick box and the uart in irda mode*/
  PSW(0x07, UTCR); 

  PSW(0x307, UARTCR_new);
   
  Idle(bit_cycles);

  PSW(DATA_5s , UARTDR);

  /* Send Break character */
  PSW(0x01, UARTLCR_H_new);

  /* Wait for the character to finish being transmitted */
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,poll1);

  /* Disable the Trickbox */
  PSW(0x00, UTCR);

  PO(0x02, 0x02, UT_CHECK_PINS, bit_cycles,poll1);
  Idle(irda_bit_cycles + 1);
  PSR(0x00, 0x02, UT_CHECK_PINS,utpin1b);

  for(i=0; i< 50; i++)
    {
      Idle(bit_cycles);
    }

  PSR(0x33 & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr1);

  /* Disable the Uart */
  PSW(0x00, UARTCR_new);
  PI(2);

  /* Release break */
  PSW(0x00, UARTLCR_H_new);

  /* Enable the Uart */
  PSW(0x307, UARTCR_new);
  PI(4);

  /* Enable the Trickbox */ 
  PSW(0x07, UTCR);
  PI(2);
  
  PO(0x00, UTRXFIFO_EMPTY, UTFR, byte_cycles,uartfr3);

  PSR(DATA_5s & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr2);

  /* Disable the uart and the trick box */
  PSW(0x00, UTCR);
  PSW(0x00, UARTCR_new);


  C("Break tests : Normal mode in loopback");

  /* This test begins transmitting one word and then causes a break condition.
     The word is received, a break error detected and cleared. */

  /* Disable the uart */
  PSW(0, UARTCR_new);

  /* Write Some data to the uart data register */
  PSW(0xff, UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr1);

  /* Enable the uart */
  PSW(0x381, UARTCR_new);
 
  Idle(bit_cycles * 2);

  PSW(0x77 , UARTDR);

  /* Send Break character */
  PSW(0x01, UARTLCR_H_new);
  P_IDLE(byte_cycles*2);

  /* Check for Break error interrupt */
  PO(UART_BERINT, UART_BERINT, UARTRIS, byte_cycles,waitforint);
  PSR(UART_BERINT, UART_BERINT, UARTRIS,breakerror1);
  PSR(0x00, UART_BEMINT, UARTMIS,breakerror2);

  /* enable the break interrupt */
  PSW(0x200, UARTIMSC);
  PI(4);
  PSR(UART_BEMINT, UART_BEMINT, UARTMIS,breakerror2);
  PI(2);

  PSR(0xff & masks[wlength], 0xff, UARTDR,uartdr);
  
  /* Disable Uart */
  PSW(0x00, UARTCR_new);
  PI(2);
  
  /* Release break */
  PSW(0x00, UARTLCR_H_new);

  /* Enable Uart */
  PSW(0x381, UARTCR_new);
  PI(2);
  
  P_IDLE(byte_cycles);
  PO(UART_RXFF,UART_RXFF,UARTFR,byte_cycles,full);

/*   PSR(0x101, 0x1f, UARTDR,readdata); */
  PSR(0x77, 0x1f, UARTDR,readdata);
  PI(2);
  PSR(UART_RXFE|UART_TXFE, UART_RXFE|UART_TXFE,UARTFR,empty);
  
  /* Clear the interrupt */
  PSW(0x200, UARTICR);
  PI(2);

  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x7ff, UARTICR);


  
}

