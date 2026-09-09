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
--  File Name              : Uart_DMATests.c.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function DMATests which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/************************* DMA Tests ** **************************************/
/******************************************************************************/

void DMATests(void)
{
  /*
  Summary: DMA Tests
  ===================
  These tests test the DMA logic in both Fifo enabled and fifo disabled modes.
  The initial state of the requests are checked, then some data written to the
  fifos.
  The requests are checked for correct setting and clearing for single data
  transfers
  and burst transfers. The DMACLR signal is checked by writing to the tricbox.
  The DMAONERR logic is checked by genreating an error via the trickbox and
  checking that the requests are not set.
  */
  

  int i = 0,j, reg_val;
  int32 some_cycles = 10;
  int cword = 0x301;
  int hword = 0x00;
  int32 bit_cycles, byte_cycles;
  unsigned long bit_width;
  int wlength;

  divisor = 0x1;
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
  
  C("DMA Test");
  
  C("DMA: Fifo disabled, Tx");
  
  cword = 0x101;
  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
 
  /* Configure the Uart with Fifo's disabled */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  
  /* Configure the TrickBox with fifos enabled */
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H); 
  
  PI(0x02);
  
  /* Enable the Transmit DMA */
  PSW(UART_TXDMAE,UARTDMACR)
  
  /* Enable the trick box and the uart */
  PSW(cword, UTCR);
  PSW(cword, UARTCR_new);
  PI(2);

  /* The DMA transmit single request should be asserted as there is space in the
     fifo but the burst request should not be asserted in fifo disabled mode. */

  PSR(TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr);
  PSR(0x00, TXDMABREQ, UTDMACR,utdmacrb);
  PI(2);

  /* A word is written to the Tx fifo which can then transmitted. The request is
     cleared by writing to the trickbox and then after the word has been completely
     transmitted the request will be reasserted. */

 PSW(0x99, UARTDR);
 PSW(0x01, UTDMACR);
 PO(TXDMASREQ, UTDMACR_MASK, UTDMACR, byte_cycles,utdmacr2);
 PSR(0x00, TXDMABREQ, UTDMACR,utdmacrb);
 PI(2);

 /* Disable Uart and the request should be deasserted. enable it and it should be
    reasserted */
 PSW(0x00, UARTCR_new);
 PI(2);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr3);
 PI(2);

 PSW(cword, UARTCR_new);
 PI(2);
 PSR(TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4);
 PI(2);

 /* Disable the Tx DMA and the request should be deasserted, enable the transmit
    DMA and the request will be reasserted */

 PSW(0x00, UARTDMACR);
 PI(2);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr5);
 PI(2);

 PSW(UART_TXDMAE, UARTDMACR);
 PI(2);
 PSR(TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr6);
 PI(2);

 /* Disable the TX Enable signal only and the request should be deasserted, enable the transmit
    Enable and the request will be reasserted */
 
 PSW(0x201, UARTCR_new);
 PI(2);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr3);
 PI(2);

 PSW(cword, UARTCR_new);
 PI(2);
 PSR(TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4a);
 PI(2);

 /* Disable the Uart Enable signal only and the request should be deasserted, enable the Uart
    Enable and the request will be reasserted */
 
 PSW(0x300, UARTCR_new);
 PI(2);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr3);
 PI(2);

 PSW(cword, UARTCR_new);
 PI(2);
 PSR(TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4b);
 PI(2);
 PSW(0x00,UARTDMACR);

 

 P_IDLE(byte_cycles);

  C("DMA: Fifo disabled, Rx");

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);

  cword = 0x301;
  /* Configure the Uart with Fifo's disabled */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  
  /* Configure the TrickBox with fifos disabled */
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H); 
  
  PI(0x02);

  /* Enable the Receive DMA */
  PSW(UART_RXDMAE,UARTDMACR)
   
  /* Enable the trick box and the uart */
  PSW(cword, UARTCR_new);
  PI(2);
  PSW(cword, UTCR);
  PI(2);

  /* The DMA receive single request should not be asserted as the fifo is empty */

 PSR(UART_RXFE, UART_RXFE, UARTFR,byte_cycles,dmafr1);
  
  PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr7);
  PI(2);

  /* A word is written to the Rx fifo and the single request is set. The word is
     read out and  The request is cleared by writing to the trickbox  */

 PSW(0x77, UTDR);
 PI(2);
 PO(UART_RXFF, UART_RXFF, UARTFR,byte_cycles,dmafr);
 PI(2);
 PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr8);
 PSR(0x00, RXDMABREQ, UTDMACR,utdmacrb);
 PI(2);

 PSR(0x77, 0x1f, UARTDR,uartdr2);
 PSW(0x02, UTDMACR);
 PI(4);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr9);
 

 /* Set the request, disable Uart and the request should be deasserted. enable it
    and it should be reasserted */
 PSW(0x33, UTDR);
 PO(UART_RXFF, UART_RXFF, UARTFR,byte_cycles,dmafr2);
 PI(2);
 PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr10);
 PI(2);
 
 PSW(0x00, UARTCR_new);
 PI(2);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr11);
 PI(2);

 PSW(cword, UARTCR_new);
 PI(2);
 PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr12);
 PI(2);

 /* Disable the Rx DMA and the request should be deasserted, enable the transmit
    DMA and the request will be reasserted */

 PSW(0x00, UARTDMACR);
 PI(2);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr13);
 PI(2);

 PSW(UART_RXDMAE, UARTDMACR);
 PI(2);
 PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr14);
 PI(2);

 /* Disable the RX Enable signal only and the request should be deasserted, enable the transmit
    Enable and the request will be reasserted */
 
 PSW(0x101, UARTCR_new);
 PI(2);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr3);
 PI(2);

 PSW(cword, UARTCR_new);
 PI(2);
 PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4a);
 PI(2);

 /* Disable the Uart Enable signal only and the request should be deasserted, enable the Uart
    Enable and the request will be reasserted */
 
 PSW(0x300, UARTCR_new);
 PI(2);
 PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr3);
 PI(2);

 PSW(cword, UARTCR_new);
 PI(2);
 PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4b);
 PI(2);

 PSR(0x33, 0x1f, UARTDR,uartdr2);

 /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);

 C("DMA: Fifo enabled, Tx - burst mode");

   cword = 0x301;
   hword = 0x70;
  /* Configure the Uart with Fifo's enabled */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  
  /* Configure the TrickBox with fifos enabled */
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H); 
  
  PI(0x02);

  /* Set the watermark level to be 3/4 full */
  PSW(UART_TXF3QUART, UARTIFLS);
  
  /* Enable Test FIFO mode */
  PSW(TESTFIFO, UARTTCR);
  
  /* Enable the Transmit DMA  */
  PSW(UART_TXDMAE,UARTDMACR);
  PI(2);

  PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4a);
  PI(2);

  /* Write 15 words to the transmit fifo. This is done in 3 bursts and 3 single
     transfers. The requests are cleared after each burst and while there is
     still at least one burst length or more space in the fifo both requests are
     reasserted, then just the single request is reasserted. */

 for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      if (i == 3)
	{
	  PSW(0x01,UTDMACR);
	  PI(0x04);
	  PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb6a);
	  PI(0x04);
	  PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb7);	  
	}  
	else
	  { 
	    PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb8);
	  }	
    }

 for(i = 4; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      if (i == 7)
	{
	  PSW(0x01,UTDMACR);
	  PI(0x04);
	  PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb9);
	  PI(0x04);
	  PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb10);	  
	}  
	else
	  { 
	    PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb11);
	  }	
    }

 for(i = 8; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      if (i == 11)
	{
	  PSW(0x01,UTDMACR);
	  PI(0x04);
	  PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb12);
	  PI(0x04);
	  PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb13);	  
	}  
	else
	  { 
	    PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb14);
	  }	
    }

 for(i = 12; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PSW(0x01,UTDMACR);
      PI(0x04);
      PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb15);
      PI(0x04);
      PSR(TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb16);	  

    }


   /* Enable Test FIFO mode */
  PSW(TESTFIFO, UARTTCR);
  PI(2);
  
  /* Read out 1 word at a time and check that the burst request is only set after 3
     words have been read out. Then disable DMA and check it is cleared. Enable
     it again and check it is reasserted. then empty fifo and check requests are
     set.*/
    
   for(i = 0; i < 10; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTTDR_MASK, UARTTDR,readtx);
      PI(0x05);
      if (i < 2)
	{
	  PSR(TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb7);
	}
      else
	{
	  PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb8);
	}  
    }


  PSW(0x00,UARTDMACR);
  PI(2)
  PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr4e);
  PI(2);

  PSW(UART_TXDMAE,UARTDMACR);
  PI(2)
  PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4f);
  PI(2);  

  for(i = 10; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTTDR_MASK, UARTTDR,readtx);
      PI(0x02);
      PSR(TXDMABREQ|TXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4g);
      PI(2);
    }

  /* Disable the uart and the trick box */
   PSW(0, UTCR);
   PSW(0, UARTCR_new);
   PSW(0x00, UARTTCR);

 C("DMA: Fifo enabled, Rx - burst mode");

   cword = 0x301;
   hword = 0x70;
   
   /* Configure the Uart with Fifo's enabled */ 
   ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  
   /* Configure the TrickBox with fifos enabled */ 
   ConfigureUbrlcrTr(divisor,hword, UTLCR_H); 
  
   PI(0x02);

   /* Enable the Receive DMA */
   PSW(UART_RXDMAE,UARTDMACR);  
   PI(2);

   /* Set the watermark level to be 1/4 full */
   PSW(UART_RXFQUART, UARTIFLS);
   PI(2);

   /* Enable Test FIFO mode */
   PSW(TESTFIFO, UARTTCR);
   PI(2);

   /* Check that the DMA requests are deasserted to begin with */ 
   PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr4a);
   PSR(UART_TXFE|UART_RXFE, UART_TXFE|UART_RXFE, UARTFR,empty);
  
  /* Write 15 words to the Rx Fifo. When there are less than 4 words in the FIFO
   only the single request will be set. After that, both requests will be set. */ 
  for(i = 0; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x04);
      if (i < 3)
      {
	PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb5);	  
      }
      else
	{
	  PSR(RXDMASREQ|RXDMABREQ, UTDMACR_MASK, UTDMACR,utdmacrb6);	  
	}
    }

  /* The DMA controller would service the burst request - the data is read out 4
     words at a time until there are less than 4 left and then it is read out in
     single transfers */
  
  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,dmaread1);
      PI(0x04);
      if (i == 3)
      {
	PSW(0x02, UTDMACR);
	PI(4);
	PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb5);
	PI(4);
	PSR(RXDMASREQ|RXDMABREQ, UTDMACR_MASK, UTDMACR,utdmacrb5);	  
      }
      else
	{
	  PSR(RXDMASREQ|RXDMABREQ, UTDMACR_MASK, UTDMACR,utdmacr6);
	}
    }
 
  for(i = 4; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,dmaread2);
      PI(0x04);
      if (i == 7)
      {
	PSW(0x02, UTDMACR);
	PI(4);
	PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb5);
	PI(4);
	PSR(RXDMASREQ|RXDMABREQ, UTDMACR_MASK, UTDMACR,utdmacrb7);	  
      }
      else
	{
	  PSR(RXDMASREQ|RXDMABREQ, UTDMACR_MASK, UTDMACR,utdmacr8);
	}
    }
  
   for(i = 8; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,dmaread3);
      PI(0x02);
      if (i == 11)
      {
	PSW(0x02, UTDMACR);
	PI(4);
	PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb5);
	PI(4);
	PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb9);	  
      }
      else
	{
	  PSR(RXDMASREQ|RXDMABREQ, UTDMACR_MASK, UTDMACR,utdmacr10);
	}
    }
       
   for(i = 12; i < 14; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,dmaread4);
      PI(0x02);
      PSW(0x02, UTDMACR);
      PI(4);
      PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb11);
      PI(4);
      PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb12);	  
    }

   for(i = 14; i < 15; i++)   
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,dmaread4a);
      PI(0x02);
      PSW(0x02, UTDMACR);
      PI(4);
      PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb11b);
      PI(4);
      PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacrb12c);	  
    }
/*  Write 4 words in to cause burst request. Disable DMA and check that the
    requests are cleared. Enable it again and check they are reasserted. then
    empty fifo  */ 
 
   for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x04);
      if(i ==3)
	{
	  PSR(RXDMASREQ|RXDMABREQ, UTDMACR_MASK, UTDMACR,utdmacrb5a);
	}
      else
	{
	  PSR(RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacrb5a);
	}
    }
   
   PSW(0x00,UARTDMACR);  
   PI(2);
   PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr4e);
   PI(2);

   PSW(UART_RXDMAE,UARTDMACR); 
   PI(2);
   PSR(RXDMABREQ|RXDMASREQ, UTDMACR_MASK, UTDMACR,utdmacr4f);
   PI(2);

   PSW(0x02,UTDMACR);
   PI(2);

   /* Empty Fifo */
   for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,dmaread6);
      PI(0x02);
      PSW(0x02,UTDMACR);
      PI(4);    
      PSR(0x00, UTDMACR_MASK, UTDMACR,utdmacr4f);
    }


   /* Disable the uart and the trick box */ 
   PSW(0, UTCR);
   PSW(0, UARTCR_new);
   PSW(0x00, UARTTCR);
   PSW(UART_RXFHALF,UARTIFLS);


 C("DMA on Error - burst mode");

  /* The following test checks the DMA on Error function.  The DMAONERR bit is set
     and an error is generated. The request lines are checked to be deasserted.
     Then a request condition is generated and the request lines again checked to
     be deasserted. The error is removed and the request lines become asserted. */ 

  cword = 0x301;
  hword = 0x72;

  /* Configure the uart */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */ 
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart */  
  PSW(cword, UARTCR_new);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PI(2);

  /* Enable the Receive DMA with DMAONERR set */ 
  PSW(UART_RXDMAE|DMAONERR,UARTDMACR); 
  PI(2);
  PSW(FORCED_PARITY_ERR,UT_FORCED_ERRS);
  PI(2);

  /* Write 8 words to the Rx Fifo and the request should be asserted after the
     8th write */ 
  for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UTDR);
      PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
      PI(2);
      PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
    }
  
  PSR(0x00, UTDMACR_MASK, UTDMACR,dmaonerr1);
  PI(2);

  /* Disable DMAONERR while there is an error condition and check that the
     request is asserted. Then enable DMAONERR and the request should disappear */
  PSW(UART_RXDMAE,UARTDMACR); 
  PI(2);
  PSR(RXDMABREQ|RXDMASREQ, UTDMACR_MASK, UTDMACR,dmaonerr2a);
  PI(2);
  PSW(UART_RXDMAE|DMAONERR,UARTDMACR); 
  PI(2);
  PSR(0x00, UTDMACR_MASK, UTDMACR,dmaonerr1);
  PI(2);
  

  PSW(0x00,UT_FORCED_ERRS); 
  PSW(0x7ff, UARTICR);
  PI(0x10);

  PSR(RXDMABREQ|RXDMASREQ, UTDMACR_MASK, UTDMACR,dmaonerr2);


  /* Read 8 words to empty the fifo */ 
  for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,read);
      PI(2);
      PSW(0x02, UTDMACR);
      PI(4);
      PSR(0x00, UTDMACR_MASK, UTDMACR,dmaonerr2);
    }  

  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);
  PSW(0x00, UARTTCR);

   C("DMA on Error test2 - burst mode");

  /* The following test checks the DMA on Error function. This test writes 8 words
     into the receive fifo and checks for the requests to be set.  An error is
     generated and another word is sent and then requests should be deasserted.
     8 more words are trnasmitted to check that no requests are set, and then the
     error is cleared and the requests asserted. */

   cword = 0x301;
   hword = 0x72;

   /* Configure the uart */
   ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

   /* Enable the uart  */
   PSW(cword, UARTCR_new);

   /* Enable the trickbox */
   PSW(cword, UTCR);
   PI(2); 
       
   /* Configure the trickbox */
   ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
   PI(2);

   /* Set watermark level to be 1/2 */
   PSW(UART_RXFHALF, UARTIFLS);
  
   /* Enable the Receive DMA with DMAONERR set */
   PSW(UART_RXDMAE|DMAONERR,UARTDMACR);
   PI(2);

   /* Write 8 words to the Rx Fifo and the request should be asserted after the
       8th write */
  for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UTDR);
      PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
      PI(2);
      PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
    }
 
  PSR(RXDMABREQ|RXDMASREQ, UTDMACR_MASK, UTDMACR,dmaonerr1);
  PI(2);

  PSW(FORCED_PARITY_ERR,UT_FORCED_ERRS);
  PI(2);
  PSW(0x55, UTDR);
  PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
  PI(2);
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
  
  PSR(0x00, UTDMACR_MASK, UTDMACR,dmaerr);
  PI(2);

  for(i = 0; i < 8; i++)
     { 
       reg_val = i | (i << 4);
       PSR(reg_val, UARTDR_MASK, UARTDR,dmaread);
       PI(2);
       PSR(0x00, UTDMACR_MASK, UTDMACR,utrxba); 
     }

  PSW(0x00,UT_FORCED_ERRS);
  PI(2);
  
   for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UTDR);
      PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
      PI(2);
      PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
      PSR(0x00, UTDMACR_MASK, UTDMACR,utrxb); 
    } 

   PSR(0x55, UARTDR_MASK, UARTDR,dmaread2);
   PI(2);
   PSW(0x7ff, UARTICR);
   PI(7);

   PSR(RXDMABREQ|RXDMASREQ, UTDMACR_MASK, UTDMACR,dmaonerr2);
   

   for(i = 0; i < 8; i++)
     { 
       reg_val = i | (i << 4);
       PSR(reg_val, UARTDR_MASK, UARTDR,dmaread);
       PI(2);
       PSW(0x02,UTDMACR);
       PI(4);
       PSR(0x00, UTDMACR_MASK, UTDMACR,utrxbc); 
     }

  PSR(UART_RXFE|UART_TXFE,UART_RXFE|UART_TXFE, UARTFR,fr1);
  PSR(UTTXFIFO_EMPTY|UTRXFIFO_EMPTY,UTTXFIFO_EMPTY|UTRXFIFO_EMPTY,UTFR,ut1);
  
  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  PSW(0x00, UARTTCR);

}


