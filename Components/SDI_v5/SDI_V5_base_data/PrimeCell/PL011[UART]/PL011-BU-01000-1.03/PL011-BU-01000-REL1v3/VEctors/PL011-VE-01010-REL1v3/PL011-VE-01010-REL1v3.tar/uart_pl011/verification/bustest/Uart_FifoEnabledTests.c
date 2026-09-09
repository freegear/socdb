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
--  File Name              : Uart_FifoEnabledTests.c.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function FifoEnabledTests which is called in the
   main file Uart.c
/******************************************************************************/
   
/******************************************************************************/
/*************************** FifoEnabledTests *********************************/
/******************************************************************************/

void FifoEnabledTests(unsigned int divisor,enum op_mode mode)
{
  /*
    Summary: Fifo Enabled Tests
    ===========================
 
    The purpose of these tests is to check the FIFO operations as well as
    bursts of back to back transmission and reception of data by the UART.
    A configuration of different divisor value, word length 5, no parity 
    and no extra stop bit has been selected for this test. The FIFOs are 
    enabled for this tests. Initially One byte is transmitted and the number
    of bytes increase with each iteration and after 16 bytes are transmitted 
    at one shot, then the number of bytes transmitted reduces to one.
    A total of 200 bytes are transmitted this way to check the stability of 
    the FIFOs.

    An additional test is performed to ensure that writes to an empty
    fifo that coincide with a read from the fifo are correctly handled
  
  */
  

#define MAX_WORDS 200
  int hword = 0x72;
  int wlength;
  int buffer[MAX_WORDS];
  int i,j,k,tx_ctr, rx_ctr;
  int32 some_cycles = 10;
  int32 bit_cycles, byte_cycles;
  unsigned long bit_width;
  int cword;
  int expected_value;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;


  
  if (mode == NORMAL_MODE)
    cword = 0x01;
  else if (mode == IRDA_MODE)
    cword = 0x03;
  else if (mode == IRDA_LP_MODE)
    cword = 0x07;
 
  for(i=0; i < MAX_WORDS; i++)
    buffer[i] = (i%16) | ((i%16) << 4);

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  PSW(0x7ff, UARTICR);
  PSW(0x00, UARTECR);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_b);

  C("Fifo Enable Tests - Tx");

  if (mode == NORMAL_MODE)
    cword = 0x101;
  else if (mode == IRDA_MODE)
    cword = 0x103;
  else if (mode == IRDA_LP_MODE)
    cword = 0x107;
  

  tx_ctr = rx_ctr = 0;
  j = 1;
  while (tx_ctr < MAX_WORDS)
    {
      for( i = 0; (i < j) && (tx_ctr < MAX_WORDS); i++)
	{
	  PSW(buffer[tx_ctr], UARTDR);
	  tx_ctr++;

	  if (i < (UARTFIFO_SIZE - 1) )
	    {
	      PO( UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr14);
	    }
	  else
	    {
	      PO(UART_TXFF|UART_RXFE|UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr13e);
	    }
	}

      /* make ready for the next iteration */
      j++;
      if (j == (UARTFIFO_SIZE + 1))
	j = 1;

      /* Enable the uart and the trick box */
      PSW(cword, UTCR);

      PSW(cword, UARTCR_new); 
    
      PO( UART_UBUSY , UART_UBUSY, UARTFR, bit_cycles,busy_high);
      PI(2);

      /* Wait till all the bytes have been transmitted by the Trick Box */
      PO(  0 , UART_UBUSY, UARTFR, (byte_cycles * i),busy_low);
      PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr16);
      
      for(k=0; k < i; k++)
	{
	  PSR(buffer[rx_ctr++] & masks[wlength], 0xff, UTDR,utdrloop);
	  PSR(0, UTRSR_MASK, UTRSR,utrsrloop);
	}

      /* Disable the uart and the trick box */
      PSW(0, UTCR);
      PSW(0, UARTCR_new);
    }

  

  C("Fifo Enable Tests - Rx");

  if (mode == NORMAL_MODE)
    cword = 0x201;
  else if (mode == IRDA_MODE)
    cword = 0x203;
  else if (mode == IRDA_LP_MODE)
    cword = 0x207;
  
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);

  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr21);
  PSR( UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr21);

  tx_ctr = rx_ctr = 0;
  j = 1;
  while (tx_ctr < MAX_WORDS)
    {
      for( i = 0; (i < j) && (tx_ctr < MAX_WORDS); i++)
	{
	  PSW(buffer[tx_ctr++], UTDR);
	}
      j++;

      PI(bit_cycles);
    
      if (j == (UARTFIFO_SIZE + 1))
	j = 1;
      PO(UTTXBUSY, UTTXBUSY, UTFR, 2 *byte_cycles * i,pollloop1);
      PO(0, UTTXBUSY, UTFR, 2 *byte_cycles * i,pollloop2);
      Idle(2 * byte_cycles);
      if (i >= UARTFIFO_SIZE)
	{
	  PSR( UART_TXFE | UART_RXFF , UARTFR_MASK, UARTFR,uartfr22);
	}
      else
	{
	  PSR( UART_TXFE, UARTFR_MASK, UARTFR,uartfr23);
	}

      for(k=0; k< i; k++)
	{
      
	  expected_value = 0 | (buffer[rx_ctr++] & masks[wlength]);
	  PSR(expected_value, 0xfff, UARTDR,uartdrloop);
         
	  if (k < (i-1))
	    {
	      PSR(UART_TXFE, UARTFR_MASK, UARTFR,uartfr24);
	    }
	  else
	    {
	      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr25);
	    }
	}
    }

  PSW(0, UTCR);
  PSW(0, UARTCR_new);

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;
  
  if (mode == NORMAL_MODE)
    {
      /* Enable the uart and trickbox */
      PSW(cword, UTCR);
      PSW(cword, UARTCR_new);
  
      C("Fifo Enable Tests - Tx & Rx");

      PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr31);
  
      tx_ctr = rx_ctr = 0;
      j = 1;
      while (tx_ctr < MAX_WORDS)
	{
	  for( i = 0; (i < j) && (tx_ctr < MAX_WORDS); i++)
	    {
	      PSW(buffer[tx_ctr], UTDR);
	      PSW(buffer[tx_ctr], UARTDR);
	      tx_ctr++;
	    }
	  j++;
	  PI(0x10);
	  if (j == (UARTFIFO_SIZE + 1))
	    j = 1;
  
	  /* Then wait for UBUSY to go low */
	  PO(0x00, UART_RXFE | UART_UBUSY, UARTFR, wait_factor * 2 *byte_cycles * i,uartfr34);
	  PI(2);
	  /* At this time all the bytes in the Tx & Rx fifos ought to have 
	     been transmitted */
  
	  if (i == UARTFIFO_SIZE)
	    {
	      PO(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,byte_cycles*16,uartfr35);
	    }
	  else
	    {
	      PSR( UART_TXFE , UARTFR_MASK, UARTFR,uartfr36);
	    }
  
	  for(k=0; k < i; k++)
	    {
	      PSR(buffer[rx_ctr] & masks[wlength], 0xff, UTDR,utdrloop);
	      PSR(0, UTRSR_MASK, UTRSR,utrsrloop);

	      expected_value = 0 |(buffer[rx_ctr] & masks[wlength]);
	      PSR(expected_value, 0xfff, UARTDR,uartdrloop1);
  
	      rx_ctr++;
	      if (k < (i-1))
		{
		  PSR( UART_TXFE , UARTFR_MASK, UARTFR,uartfr37);
		}
	      else
		{
		  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr38);
		}
	    }
	}
    }
  /* Write as shift register empties */
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
  
  C("Boundary Condition Test: Read And Write At Same Time FIFO Enabled");

  /* Transmit two characters with a gap to allow for the first to be
     transmitted before reloading the holding register */
  PSW(0x05, UARTDR);
  PI(200);
  PI(200);
  PI(132);
  PSW(0x06, UARTDR);

  /* Poll the Rx Fifo empty bit to receive the first character */
  PO(0 , UART_RXFE, UARTFR , (byte_cycles*2), fifodis1);
  PSR(0x05, 0xFFF, UARTDR, fifodis2);

  /* Poll the Rx Fifo empty bit to receive the second character */
  PO(0 , UART_RXFE, UARTFR , (byte_cycles*2), fifodis1);
  PSR(0x06, 0xFFF, UARTDR, fifodis2);


  
}
