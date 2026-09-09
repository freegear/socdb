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
--  File Name              : Uart_DisableTests.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function FifoUartDisableTest which is called in
   the main file Uart.c
/******************************************************************************/




/******************************************************************************/
/*************************** FifoUartDisableTest ******************************/
/******************************************************************************/

void FifoUartDisableTest(unsigned int divisor,enum op_mode mode)
{
  /* 
     Summary: Uart Disable Tests
     ===========================

     This is a FIFO enabled test case where the Tx FIFO is filled, UART is 
     enabled and allowed to run till it starts transmitting. The UART is then
     disabled and then enabled. This tests a disable cycle within a single
     character. 
     
     Next it is enabled for a single character duration, and
     disabled for a character duration. This tests that the character completes
     and then transmission resumes correctly. 
     
     Next it is allowed to run till all the remaining bytes have been transmitted. 
     The data is then read out from the TrickBox to check if the Tx FIFO of the 
     UART retained the bytes during its temporary disabling.  The TX fifo is then 
     written to, the Uart enabled, allowed to run til it starts transmitting and then 
     disabled. One byte of data is read out of the Trickbox and the rest of the data 
     should not be transmitted. 
     
     With single byte in the Tx fifo, UART is disabled during its transmission. 
     After the expected cycles a character takes to be transmitted, the UART is 
     enabled. This tests that the character completes and when the UART is enabled, 
     UART transmits nothing or the new byte if a new byte is sent.
     
     In the receive test the trickbox is written to, then the Uart
     is disabled when data starts to be transmitted and only one word is received
     in the uart.
    
     In the hardware flow control test, hardware flow control is enabled
     & Uart TxFifo is filled - then the UART is disabled during the transmission 
     of the first byte. The UART is then reenabled and allowed to run till transmission 
     completes. This tests that the character completes after UART disabled and 
     transmission resumes correctly after re-enabling, under hardware flow control.
    

  */

  
  int i, wlength;
  int hword = 0x10, cword = 0x00;
  int32 byte_cycles,bit_cycles,some_cycles = 10;
  unsigned long bit_width;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  /* hardware flow control disabled in all modes*/
  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;

  C("Fifo Disable Tests - Tx");
 
   /* Disable the UART & trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
 
  for(i=1; i< 5; i++)
    {
      PSW(i, UARTDR);
    }

  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr1);

  /* Enable the UART and Trickbox*/
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);
  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, byte_cycles*16,uartfr2); 

  /* Disable the UART*/
  PSW(0x00, UARTCR_new); 

  /*Allow enough delay to upset reception-
    Intra character delay */
  PI(bit_cycles*2);

  /* Enable uart */
  PSW(cword, UARTCR_new);
  PI(2);
  PSR(UART_RXFE | UART_UBUSY , UARTFR_MASK, UARTFR,uartfr3);

  PI(byte_cycles/4);
  PI(byte_cycles/4);
  PI(byte_cycles/4);
  PI(byte_cycles/4);
  
  /* Disable the UART */
  PSW(0x00, UARTCR_new);

  /* UART disabled after stop bit of last character transmitted- 
     Inter character delay */
  PI(byte_cycles/4);
  PI(byte_cycles/4);
  PI(byte_cycles/4);
  PI(byte_cycles/4);
  
  /* Enable uart */
  PSW(cword, UARTCR_new);

  PO(UART_TXFE | UART_RXFE , UARTFR_MASK, UARTFR, byte_cycles *3,uartfr3);
  PSR(0x00, UTRXFIFO_EMPTY, UTFR,utfifo);

  if (mode == NORMAL_MODE)
    {
      for(i=1; i< 5; i++)
	{
	  PSR(i, 0x1f, UTDR,utdrloop);
	  PSR(0x00, UTRSR_MASK, UTRSR,utrsrloop);
	  if (i < 4)
	    {
	      PSR(0x00, UTRXFIFO_EMPTY, UTFR,utfifoloop1);
	    }
	  else
	    {
	      PSR(0x01, UTRXFIFO_EMPTY, UTFR,utfifoloop2);
	    }
	}
    }
  else if (mode == IRDA_MODE)
    {
      PSR(0, 0x00, UTDR,utdrirda1);
      for(i=2; i< 5; i++)
	{
	  PSR(i, 0x1f, UTDR,utdrirda2);
	  PSR(0x00, UTRSR_MASK, UTRSR,utrsrirda3);
	  if (i < 4)
	    {
	      PSR(0x00, UTRXFIFO_EMPTY, UTFR,utfifoirda4);
	    }
	  else
	    {
	      PSR(0x01, UTRXFIFO_EMPTY, UTFR,utfifoirda5);
	    }
	}
    }
  else if (mode == IRDA_LP_MODE)
    {
      for(i=1; i<3; i++)
	{	 
	  PSR(0, 0x00, UTDR,utdrirda6);
	}
      for(i=3; i< 5; i++)
	{
	  PSR(i, 0x1f, UTDR,utdrirda7);
	  PSR(0x00, UTRSR_MASK, UTRSR,utrsrirda8);
	  if (i < 4)
	    {
	      PSR(0x00, UTRXFIFO_EMPTY, UTFR,utfifoirda9);
	    }
	  else
	    {
	      PSR(0x01, UTRXFIFO_EMPTY, UTFR,utfifoirda10);
	    }
	}
    }

  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr2a);


  /* Disable the UART & trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR); 

  for(i=2; i< 5; i++)
    {
      PSW(i, UARTDR);
    }

  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr4);

  /* Enable the UART and Trickbox */
  PSW(cword, UTCR);
  PSW(cword, UARTCR_new);

  PI(2*bit_cycles);
  PSR(UART_RXFE | UART_UBUSY,UARTFR_MASK,UARTFR,DisableTx);

  /* Disable the UART */
  PSW(0x00, UARTCR_new);

  PO(0x00, UTRXBUSY, UTFR, byte_cycles*2,uartfr2);
  P_IDLE(some_cycles);
  PSR(0, UTRXBUSY, UTFR,uartfr4);

  i=2;
  if (mode != NORMAL_MODE)
    {
      /* The following must be changed later when the TrickBox is fixed
	 for IrDA and LP IrDA modes */
      PSR(i & masks[wlength], 0x00, UTDR,DisableTx5Ir);
      PSR(0x00, UTRSR_MASK, UTRSR,utrsrloop);
    }
  else
    {
      PSR(i & masks[wlength], 0xff, UTDR,DisableTx5);
      PSR(0x00, UTRSR_MASK, UTRSR,utrsrloop);
    }
     
  /* Enable test fifo mode */
  PSW(TESTFIFO, UARTTCR);
  PI(2);

  /* Empty the Uart TX fifo */
  i = 3;
  PSR(i & masks[wlength], 0xff, UARTTDR,uartdr1);
  i++;
  PSR(i & masks[wlength], 0xff, UARTTDR,uartdr2);
  PI(2);
  
  PSW(0x00, UARTTCR);
      
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr1); 
  PSR(UART_TXFE | UART_RXFE ,UART_TXFE | UART_RXFE, UARTFR,uartfr5);

  /*Transmit a single byte*/

  PSW(cword, UARTCR_new);      /* Enable Uart */
     
  PSW(0x03, UARTDR);
  Idle(400);
  PSW(0x00, UARTCR_new);      /* Disable Uart */ 
  Idle(7000);

  PSW(cword, UARTCR_new);     /* Enable Uart */ 
  Idle(10000);

  PSW(0x05,UARTDR);
  Idle(10000);
  PSR(0x03,0xFF,UTDR,utdr6);
  PSR(0x05,0xFF,UTDR,utdr7);
  Idle(200);
  
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr2); 
  PSR(UART_TXFE | UART_RXFE ,UART_TXFE | UART_RXFE, UARTFR,uartfr6);
  
  PSW(0, UARTCR_new);       /* Disable Uart. */
  
  C("Fifo Disable Tests - Rx");

  PSW(cword, UARTCR_new);

  for(i=1; i< 5; i++)
    {
      PSW(i, UTDR);
    }

    
  /* Wait till the trickbox starts transmitting and the Uart starts
     receiving and then disable Uart */
    
  PI(2*bit_cycles);

  PSR(UTTXBUSY, UTTXBUSY, UTFR,utfr3);  

  PSW(0, UARTCR_new);
  PI(2*bit_cycles);
  PSR(0,0x00,UARTFR,uarttfr6a);
  PI(2*bit_cycles);
  PSR(0,0x00,UARTFR,uarttfr6b);
  PI(2*bit_cycles);
  PSR(0,0x00,UARTFR,uarttfr6c);
  PI(2*bit_cycles);
    
  PSR(0,UART_RXFE,UARTFR,uarttfr6d);
  i=1;
  PSR(i & masks[wlength], 0xff, UARTDR,uartdr3);
  PSR(UART_RXFE,UART_RXFE,UARTFR,uarttfr6e);
  
  PO(UTTXFIFO_EMPTY,UTTXFIFO_EMPTY,UTFR,6*byte_cycles,utfr_endTx);     
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr4); 

  /* Tests under hardware flow control enabled */
  C("Fifo Disable Tests - RTSEn & CTSEn");

  hword = 0x72;  /* wlength increased to 8 bits */
 
  /* configure line control registers with new hword */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
 
  /* hardware flow control enabled in all modes */
  if (mode == NORMAL_MODE)
    cword = 0xC101;
  else if (mode == IRDA_MODE)
    cword = 0xC103;
  else if (mode == IRDA_LP_MODE)
    cword = 0xC107;



  PSW(0x33, UARTDR);       /* write to transmit register */
  PSW(0x55, UARTDR);
  PSW(0xAA, UARTDR);
  PSW(0x99, UARTDR);
  PSW(0x81, UARTDR);

  PSW(cword, UTCR);            /* Enable trick box */
  PSW(cword, UARTCR_new);      /* Enable uart, transmit. */
  Idle(400);

  PSW(0x3E, UT_SET_PINS);      /* Force Uart CTS = '0' */
  Idle(440);
  
  PSW(0xC001, UARTCR_new);     /* Disable transmit. */ 
  Idle(7000);

  PSW(cword, UARTCR_new);      /* Enable Transmit */ 
  Idle(10000);

  /* Wait for Uart Tx Fifo Empty*/
  PO(0,UART_UBUSY,UARTFR,byte_cycles*5,ubusy);
  
  /* Check data read back correctly from trickbox */
  PSR(0x33,0xFF, UTDR,utdr1);
  PSR(0x55,0xFF, UTDR,utdr2);
  PSR(0xAA,0xFF, UTDR,utdr3);
  PSR(0x99,0xFF, UTDR,utdr4);
  PSR(0x81,0xFF, UTDR,utdr5);
  PI(2);

  /* make sure Tx & Rx Fifos of uart & trickbox empty at end of test */
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr5); 
  PSR(UART_TXFE | UART_RXFE ,UART_TXFE | UART_RXFE, UARTFR,uartfr7);
  
  PSW(0, UARTCR_new);
  PSW(0, UTCR);
 
} 
