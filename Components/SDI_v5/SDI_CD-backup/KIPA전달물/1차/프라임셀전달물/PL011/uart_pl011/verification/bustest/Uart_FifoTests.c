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
--  File Name              : Uart_FifoTests.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function FifoTests which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/************************* FIFO Tests ** **************************************/
/******************************************************************************/

void FifoTests(void)
{
  /*
  Summary: Fifo Tests
  ======================

  These tests check the extra test functionality that allows data to be read from
  the Tx fifo and to be written to the Rx fifo. Data is written to the Tx fifo and
  then read from UARTTDR, then data is written to UARTTDR and read out of the Rx
  fifo.
  The fifo interrupt level tests check the Rx and Tx interrupts by setting the
  watermark to be all the different levels for both the Tx and Rx.
  The clearing of the Transmit and Receive interrupts is also tested by writing to
  the relevant bit in the Interrupt Clear register.
   */

  int i = 0,j, reg_val;
  int32 some_cycles = 10;
  int cword = 0x301;
  int hword = 0x10;
  
  C("FIFO Test");

  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);

  C("RX Fifo Test");

  PSW(cword,UARTCR_new);

    /* Enable test fifo mode */
  PSW(TESTFIFO, UARTTCR);
  PI(2);

   /* Write 16 words into Rx fifo, check that the fifo is full, then read them back
      out and check that the Rx fifo is empty and that the Tx fifo remains empty */
   
  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PI(0x05);
  PSR(UART_RXFF | UART_TXFE, UARTFR_MASK, UARTFR, uarttdr5);  
    
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,uarttdr4);
      PI(0x03);
    }
  PSR(UART_TXFE | UART_RXFE,UARTFR_MASK,UARTFR, uarttdr6);


   /* Disable Test fifo mode and check that data is not written to fifo */
  PSW(0x00, UARTTCR);
  PI(0x05);
  PSW(0x33, UARTTDR,uarttdr3);
  PI(0x02);
  PSR(0x00, 0xfff,UARTDR,uarttdr4);
  PI(0x02);
   
  C("RX Fifo Interrupt level Test");
  
  /* RX Fifo level 1/8th */
  cword = 0x201;
   
  /* Disable, configure and enable Uart */
  PSW(0,UARTCR_new);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(cword,UARTCR_new);
  PSW(TESTFIFO, UARTTCR);

  /* Keep Interrupts Disabled */
  PSW(0, UARTIMSC);

  /* Program the Rx fifo interrupt to be 1/8th full */
  PSW(UART_RXFEIGHT, UARTIFLS);
  PI(0x05);

  /* Both interrupts will not be set */
  PSR(0x00, UART_RXRINT, UARTRIS,rxlevel01);
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel0);
  
  /* Write 1 word into the Rx fifo and interrupt will still not be set */
  PSW(0x22, UARTTDR);
  PI(2);
  PSR(0x00, UART_RXRINT, UARTRIS,rxlevel01a);
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel0b);

  /* Write 1 more word and the raw interrupt will be set but the masked interrupt
     will not until the interrupt is enabled */
  PSW(0x33, UARTTDR);
  PI(2);
  PSR(UART_RXRINT, UART_RXRINT, UARTRIS,rxlevel01b);
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel0b);
  PSW(0x3f, UARTIMSC);
  PSR(UART_RXRINT, UART_RXRINT, UARTRIS,rxlevel02);  
  PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel0a);
  
   /* Read out a  word and check that Rx interrupt is cleared */
  PSR(0x22, 0xfff, UARTDR, rxlevel3);
  PI(0x02); 
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel03);

  /* Write a word to set it again */
  PSW(0x55, UARTTDR);
  PI(2);
  PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel0ac);
  
  /* Write to bit 4 of the interrupt clear reg to clear it */
  PSW(0x10, UARTICR);
  PI(2);
  PSR(0, UART_RXMINT, UARTMIS,rxlevel04);

  /* Read 2 words out to empty the fifo */
  PSR(0x33, 0xfff, UARTDR, rxlevel3a);
  PI(0x02); 
  PSR(0x55, 0xfff, UARTDR, rxlevel3b);
  PI(0x02); 
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel0b);

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR, rxlevel5a);

   
   /* RX Fifo level Quarter */
   
  /* Program the Rx fifo interrupt to be set when the fifo is quarter full */
  PSW(UART_RXFQUART, UARTIFLS);
  PI(0x05);

   /* Write 3 words into Rx fifo, RXINTR should not be set */
  for(i = 0; i < 3; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(0, UART_RXMINT, UARTMIS,rxlevel6);
    }
 
  PI(0x02);

    /* Write another word which should set interrupt, and fill fifo checking that
       the interrupt remains set */
  for(i = 3; i< 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel7);
    }

  /* Read out 12  words  which should keep interrupt set */
  for(i=0; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel8);
      PI(0x03);
      PSR(UART_RXMINT,UART_RXMINT,UARTMIS,rxlevel9);
    }
      
  /* Read out 1 word to clear the interrupt and then empty fifo with no interrupt
	 being set */
  for(i=12; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel8);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxlevel9);
    }
      
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel12);


  /* RX Fifo level Half */
   
  /* Program the Rx fifo interrupt to be set when the fifo is half full */
  PSW(UART_RXFHALF, UARTIFLS);
  PI(0x05);

   /* Write 7 words into Rx fifo, RXINTR should not be set */
  for(i = 0; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PSR(0, UART_RXMINT, UARTMIS,rxlevel13);
  PI(0x02);

  /* Write another word which should set interrupt, and 2 more words whch should
       keep interrupt set */
  for(i = 7; i< 10; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel14);
    }

  /* Read out 2  words  which should keep interrupt set */
  for(i=0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel15);
      PI(0x03);
      PSR(UART_RXMINT,UART_RXMINT,UARTMIS,rxlevel16);
    }

  /* Read out 1  word  which should remove interrupt, and empty fifo - interrupt should
       stay low */
  for(i=2; i < 10; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel15);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxlevel16);
    }
      
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel19);


/* RX Fifo level Three quarters */
   
  /* Program the Rx fifo interrupt to be set when the fifo is three quarters full */
  PSW(UART_RXF3QUART, UARTIFLS);
  PI(0x05);

   /* Write 11 words into Rx fifo, RXINTR should not be set */
  for(i = 0; i < 11; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PSR(0, UART_RXMINT, UARTMIS,rxlevel20);
  PI(0x02);

  /* Write another word which should set interrupt, and 3 more words whch should
       keep interrupt set */
  for(i = 11; i< 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel21);
    }

  /* Read out 3 words which should keep interrupt set */
  for(i=0; i < 3; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel22);
      PI(0x03);
      PSR(UART_RXMINT,UART_RXMINT,UARTMIS,rxlevel23);
    }
  

  /* Read out 1 word which should remove interrupt, then empty fifo which should
       keep it low */
  for(i=3; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel24);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxlevel25);
    }

  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel26);
     

/* RX Fifo level seven eighths full */
   
  /* Program the Rx fifo interrupt to be set when the fifo is seven eighths
     full */
  PSW(UART_RXF7EIGHT, UARTIFLS);
  PI(0x05);

   /* Write 13 words into Rx fifo, RXINTR should not be set */
  for(i = 0; i < 13; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PSR(0, UART_RXMINT, UARTMIS,rxlevel20);
  PI(0x02);

  /* Write another word which should set interrupt */
  for(i = 13; i< 14; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel21);
    }

  /* Write 2 more to fill fifo and interrupt should remain */
  for(i = 14; i< 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel21);
    }

   PSR(UART_RXFF | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel26);
 
  /* Read out 3 words  which should remove interrupt, and empty fifo which should
       keep it low */
  for(i=0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel22);
      PI(0x03);
      PSR(UART_RXMINT,UART_RXMINT,UARTMIS,rxlevel23);
    }

  for(i=2; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel22);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxlevel23);
    }

  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel26);
 
  C("TX Fifo Test");

  cword = 0x201; 
  PSW(0, UARTCR_new);
    
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);

  PSW(cword,UARTCR_new);

  /* Enable Test fifo mode */
  PSW(TESTFIFO, UARTTCR);


  /* Write 16 words into Tx fifo, check that the fifo is full, then read them back out
     and check that the Tx fifo is empty and that the Rx fifo remains empty */
   
  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
    }
 
  PI(0x05);
  PSR(UART_RXFE | UART_TXFF | UART_UBUSY, UARTFR_MASK, UARTFR, uartdrt5);  
    
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,uarttdr4);
      PI(0x01);
    }
  PSR(UART_TXFE | UART_RXFE,UARTFR_MASK,UARTFR, uartdrt6);
   

   /* Disable Test fifo mode and check that data is not read out of fifo */
  PSW(0x00, UARTTCR);
  PSW(0x88, UARTDR,uartdrt3);

  PSR(0x00, UARTTDR_MASK, UARTTDR,uartdrt2a);
  PSW(0x00,UARTCR_new);

   /* empty fifo */
  PSW(TESTFIFO, UARTTCR);
  PI(0x02);
  PSR(0x88, UARTTDR_MASK, UARTTDR,uartdrt2b);
  PI(0x02);
  PSR(UART_TXFE | UART_RXFE,UARTFR_MASK,UARTFR, uartdrt6a);


  C("TX Fifo Interrupt level Test");
  
   /* Tx Fifo level one eighth */

  cword = 0x201;
   
  /* Disable, configure and enable Uart */
  PSW(0,UARTCR_new);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(cword,UARTCR_new);
  PSW(TESTFIFO, UARTTCR);

   /* Program the Tx fifo interrupt to set when the fifo is one eighth full,
      first with the interrupt disabled and then enable the interrupt */

  PSW(0x00, UARTIMSC);
  PSW(UART_TXFEIGHT, UARTIFLS);
  PI(0x05);
  PSR(UART_TXRINT , UART_TXRINT, UARTRIS,txlevel0a);  
  PSR(0, UART_TXMINT, UARTMIS,txlevel0);

  PSW(0x3f, UARTIMSC);
  PSR(UART_TXRINT , UART_TXRINT, UARTRIS,txlevel0b);  
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel0c);
  
 
  /* Write 4 words of data into Tx fifo and see that Tx interrupt is not set
     on or after the 2nd word */
  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(2);
      if (i<2)
	{
	  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel1);
	}
      else
	{
	  PSR(0, UART_TXMINT, UARTMIS,txlevel1);
	}
    }
  /*  Read out 2 words, then the interrupt should be set */
  for(i=0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,uarttdr2);
      PI(2);
    }
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel3);

  /* Read out the last 2 words and check that Tx interrupt is  set */
  for(i=2; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,uarttdr4);
      PI(2);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel5);
    }

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,txlevel6);


     /* TX Fifo level Quarter */
   
  /* Program the Tx fifo interrupt to be set when the fifo is quarter full or less */
  PSW(UART_TXFQUART, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel7);

  /* Write 4 words into Tx fifo, TXINTR should still be set */
  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel8);
      PI(0x02);
    }

  /* Write in 5 words to remove interrupt and keep it removed */ 
  for(i=4; i < 9; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(0,UART_TXMINT,UARTMIS,txlevel9);
    }
      
  /* Read out 4 words and interrupt will remain low */
  for(i=0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel10);
      PI(0x03);
      PSR(0, UART_TXMINT, UARTMIS,txlevel11);
    }
      
  /* Read out 1 word to set interrupt, then empty fifo and interrupt will remain set */
  for(i=4; i < 9; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel12);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel13);
    }
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,txlevel14);
      

     /* TX Fifo level Half */
   
  /* Program the Tx fifo interrupt to be set when the fifo is half full or less */
  PSW(UART_TXFHALF, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel15);

  /* Write 8 words into Tx fifo, TXINTR should still be set */
  for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel16);
      PI(0x02);
    }

  /* Write in 8 words to remove interrupt and keep it removed */ 
  for(i=8; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(0,UART_TXMINT,UARTMIS,txlevel17);
    }
      
  /* Read out 7 words and interrupt will remain low */
  for(i=0; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel18);
      PI(0x03);
      PSR(0, UART_TXMINT, UARTMIS,txlevel19);
    }
  /* Read out 1 word to set interrupt, then empty fifo and interrupt will remain set */
  for(i=7; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel20);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel21);
    }
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,txlevel22);


     /* TX Fifo level three quarters */
   
  /* Program the Tx fifo interrupt to be set when the fifo is three quarters full or less */
  PSW(UART_TXF3QUART, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel23);

  /* Write 12 words into Tx fifo, TXINTR should still be set */
  for(i = 0; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel24);
      PI(0x02);
    }

  /* Write in 3 words to remove interrupt amd keep it removed */ 
  for(i=12; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(0,UART_TXMINT,UARTMIS,txlevel25);
    }
      
  /* Read out 2 words and interrupt will remain low */
  for(i=0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel26);
      PI(0x03);
      PSR(0, UART_TXMINT, UARTMIS,txlevel27);
    }
  
  /* Read out 1 words to set interrupt, then empty fifo and interrupt will remain set */
  for(i=2; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel28);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel29);
    }
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,txlevel30);


   /* TX Fifo level seven eighth full */
   
  /* Program the Tx fifo interrupt to be set when the fifo is seven eighth full */
  PSW(UART_TXF7EIGHT, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel20);
 
  /* Write 14 words into Tx fifo, TXINTR will be set */
  for(i = 0; i < 14; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel21);
      PI(0x02);
    }

  /* Write in 1 word to clear interrupt */ 
  for(i=14; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(2);
      PSR(0,UART_TXMINT,UARTMIS,txlevel22);
    }

  /* Read out 1 word to set interrupt */
  i = 0;
  reg_val = i | (i << 4);
  PSR(reg_val, 0xfff, UARTTDR,txlevel23);
  PI(2);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel24);

  /* Write to bit 5 of the interrupt clear reg to clear it */

  PSW(0x20, UARTICR);
  PI(2);
  PSR(0,UART_TXMINT,UARTMIS,txlevel22a);
 
  /* Check still clear */
  PI(4);
  PSR(0,UART_TXMINT,UARTMIS,txlevel22b);


  /* set interrupt again by writing  and reading another word */

  i = 15;
  reg_val = i | (i << 4);
  PSW(reg_val, UARTDR);
  PI(0x03);
  PSR(0,UART_TXMINT,UARTMIS,txlevel22a);

  i = 1;
  reg_val = i | (i << 4);
  PSR(reg_val, 0xfff, UARTTDR,txlevel23);
  PI(2);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel24a);
  
  /* fill fifo and check interrupt still cleared */
   for(i=16; i < 18; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(0,UART_TXMINT,UARTMIS,txlevel25);
    }

  PI(0x03);
  PSR(0,UART_TXMINT,UARTMIS,txlevel22a);
 
  PSR(UART_RXFE | UART_TXFF| UART_UBUSY,UARTFR_MASK,UARTFR,txlevel25b);

  
  /* Read out 2 word to set interrupt, then empty fifo */
  for(i=2; i <18; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xff, UARTTDR,txlevel23);
      PI(2);
      if (i<3)
	{
	  PSR(0, UART_TXMINT, UARTMIS,txlevel24b);
	}
      else
	 {
	   PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel24b);
	 }
    }
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,txlevel25);


  C("RX and TX Fifo Interrupt level Test");

  /* Program the Tx fifo interrupt to be set when the fifo is quarter full and the
      Rx fifo interrupt to be set when the fifo is three quarters full  */
  PSW(UART_TXFQUART | UART_RXF3QUART, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,rxtx1);

  /* Write 5 words into Tx fifo, TXINTR should still be removed */
  for(i = 0; i < 5; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
    }
  PSR(0, UART_TXMINT, UARTMIS,rxtx2);

   /* Write 12 words into Rx fifo, RXINTR should be set */
  for(i = 0; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxtx3);
  PI(0x02);

    
  /* Read out 1 word to set interrupt, then empty Tx fifo and interrupt will remain set */
  for(i=0; i < 5; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,rxtx4);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,rxtx5);
    }
      
  /* Read out 1 words which should clear interrupt, and empty fifo keeping it low  */
  for(i=0; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxtx6);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxtx7);
    }

  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxtx8);


  C("RX and TX Fifo Interrupt level Test with xmission");

  cword = 0x3B1;
  divisor = 0x03;
  hword = 0x7e;
  PSW(0,UARTCR_new);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(0x00, UARTTCR);
  PSW(cword,UARTCR_new);

   /* Program the Tx fifo interrupt to be set when the fifo is quarter full and the
      Rx fifo interrupt to be set when the fifo is three quarters full  */
  PSW(UART_TXFQUART | UART_RXF3QUART, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,lb1);
   
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,lb5a);

      /* Write 16 words into Tx fifo  */ 
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
    } 

  PO(UART_TXMINT,UART_TXMINT | UART_RXMINT ,UARTMIS,(byte_cycles*11),lb2);
  PO(UART_TXMINT | UART_RXMINT,UART_TXMINT | UART_RXMINT ,UARTMIS,(byte_cycles*1),lb3);

  /* Check that writing '0' to the UARTICR register doesn't clear the interrupts */
  PSW(0x00, UARTICR);
  PI(2);
  PSR(UART_TXMINT | UART_RXMINT,UART_TXMINT | UART_RXMINT ,UARTMIS,lb3);

  PO(0,UART_UBUSY, UARTFR,(byte_cycles*12,lb6));
       
     /* Read out the received data */
     for(i=0; i < 16; i++)
     {
       reg_val = i | (i << 4);
       PSR(reg_val, 0xfff, UARTDR,lb4);
       PI(0x03);
     }
    
     PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,lb5);

     /* Clear any interrupts that have been set */

     PSW(0x7ff, UARTICR);
     PI(4);
     PSR(0, UARTMIS_MASK, UARTMIS,read);
     PSW(0x00, UARTIMSC);
     PSW(0x00,UARTTCR);

     
}

  
