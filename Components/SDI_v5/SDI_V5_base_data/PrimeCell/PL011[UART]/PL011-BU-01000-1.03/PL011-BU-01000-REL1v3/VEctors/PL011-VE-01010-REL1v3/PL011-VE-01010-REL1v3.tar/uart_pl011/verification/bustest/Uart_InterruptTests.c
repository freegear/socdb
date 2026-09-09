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
--  File Name              : Uart_InterruptTests.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function InterruptTests which is called in
   the main file Uart.c
 ******************************************************************************/

/******************************************************************************/
/*************************InterruptTests **************************************/
/******************************************************************************/

void InterruptTests(unsigned int divisor, enum op_mode mode)
{
  /* 
     Summary: Interrupt Tests
     ========================
  
     These tests check the generation of Tx and Rx interrupts. The values
     of UARTTXINTR, UARTRXINTR and UARTINTR are checked through the Raw
     Interrupt status and Masked Interrupt status registers. These tests
     are being conducted in both modes
     i.e. Fifo enabled mode and Fifo disabled mode.

  */

  int i,j,wlength;
  int hword = 0x00, cword;
  int32 byte_cycles,bit_cycles, some_cycles = 10;
  unsigned long bit_width;

  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;  
   bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
   wlength = ((hword & 0x60) >> 5) + 5;
   byte_cycles = (wlength + 6)  * bit_cycles;

  if (PCLK_PERIOD > UARTCLK_PERIOD)
    wait_factor = (PCLK_PERIOD/UARTCLK_PERIOD); 
  else
    {
      if( UARTCLK_PERIOD > PCLK_PERIOD)
	wait_factor = (UARTCLK_PERIOD/PCLK_PERIOD) ;
      else
	wait_factor  = 1;
    }

  C("Fifo Disabled : TXINT");

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;
	
  /* Disable the Uart, interrupts and the TrickBox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UTCR);

  /* Clear any interrupts that are already set */
  PSW(0x7ff, UARTICR);

  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Check interrupts at the half full fifo level */
  PSW(UART_RXFHALF|UART_TXFHALF, UARTIFLS);
  PI(2);

  /* Check Masked Interrupts */
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis1);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir11);
 
  /* Enable the uart interrupts alone */
  PSW(0x30, UARTIMSC);
  
  /* Check Interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris60);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis60);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir12);

  /* Write one word */
  PSW(0xff, UARTDR);

  /* Check Masked and Raw Interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris61);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis61);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir13);

  /* Enable the uart also */
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);

  /* Check Interrupts - first with the interrupts disabled to check that the masked
     value is 0, then with the interrupts enabled */
  PSW(0x00, UARTIMSC);
  PO(UART_TXRINT, UARTRIS_MASK, UARTRIS, byte_cycles,uartris62);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis62);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir14);
  
  PSW(0x30, UARTIMSC);
  PO(UART_TXRINT, UARTRIS_MASK, UARTRIS, byte_cycles,uartris62);
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmis62);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir14);
  
/* wait for word to be transmitted and read it out of trickbox */
  P_IDLE(2*bit_cycles);
  PO(0,UTRXBUSY,UTFR,byte_cycles,wait2);
  PSR(0xff & masks[wlength],0x1f, UTDR,read);

  /* Clear interrupt by writing to bit 5 of the interrupt clear register */
  PSW(0x20, UARTICR);
  PI(1); 

  /* Check interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris611);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis612);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir13);


  /* Disable Uart so data goes into holding buffer */
  PSW(0, UARTCR_new);
  PI(2);

  /* Write one word */
  PSW(0x66, UARTDR);
  PI(2);

  /* Enable Uart */
  PSW(cword, UARTCR_new);
  PI(2);

  
  /* wait for word to be transmitted and read it out of trickbox */
  P_IDLE(byte_cycles);
  PO(0,UTRXBUSY,UTFR,byte_cycles,wait4);
  PSR(0x66 & masks[wlength],0x1f, UTDR,read);

  /* Check Masked and Raw Interrupts */
  PO(UART_TXMINT, UARTRIS_MASK, UARTRIS, some_cycles,uartris613);
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmis614);
  PSR(UT_TXINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utiir13);


 /* Disable Uart so data goes into holding buffer */
  PSW(0, UARTCR_new);
  PI(2);

  /* Write another word and enable the interrupts */
  PSW(0x99, UARTDR);
  PI(2);
  PSW(0x30, UARTIMSC);

  /* Enable Uart */
  PSW(cword, UARTCR_new);
  PI(2);
  
  /* wait for a few cycles and then check that the interrupt is set */
  P_IDLE(10);
  PO(UART_TXMINT, UARTRIS_MASK, UARTMIS, some_cycles,uartris614);

  /* Now write a word and check that that interrupt gets cleared */
  PSW(0xAA, UARTDR);
  P_IDLE(5);
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris615);

  PI(2);
  PO(0,UTRXBUSY,UTFR,byte_cycles,wait);
  PSR(0x99 & masks[wlength],0x1f, UTDR,read99);

  /* Check Masked and Raw Interrupts */
  PO(UART_TXMINT, UARTRIS_MASK, UARTRIS, some_cycles,uartris613);
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmis614);
  PSR(UT_TXINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utiir13);

  /* wait for the current word to be transmitted and read it out of trickbox */
  P_IDLE(10);
  P_IDLE(10);
  PO(0,UTRXBUSY,UTFR,byte_cycles*2,wait);
  PSR(0xAA & masks[wlength],0x1f, UTDR,readAA);

  /* Clear Interrupts, Stay in Idle mode for sometime and then write a
     character to the FIFO, when it starts transmitting, the interrupt
     should get asserted again */
  PSW(0x20, UARTICR);
  PI(1); 

  /* Check interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris611);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis612);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir13);

  P_IDLE(1000);

  /* Check interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartrisIDLE);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmisIDLE);
  PSR(0x00, UTIIR_MASK, UTIIR,utiirIDLE);
  
  PSW(0xCC, UARTDR);
  PI(2);

  /* Check Masked and Raw Interrupts and Clear It */
  PO(UART_TXRINT, UARTRIS_MASK, UARTRIS, byte_cycles,uartrisIDLE);
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmisIDLE);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiirIDLE);
  PSW(0x20, UARTICR);

  /* wait for the current word to be transmitted and read it out of
     trickbox, clear interrupts and repeat process after another IDLE
     period */
  P_IDLE(10);
  PO(0,UTRXBUSY,UTFR,byte_cycles*2,wait);
  PSR(0xCC & masks[wlength],0x1f, UTDR,readCC);
  
  /* Check Masked and Raw Interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartrisIDLE);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmisIDLE);
  PSR(0x00, UTIIR_MASK, UTIIR,utiirIDLE);

  P_IDLE(1000);

  /* Check interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartrisIDLE);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmisIDLE);
  PSR(0x00, UTIIR_MASK, UTIIR,utiirIDLE);
  
  PSW(0xEE, UARTDR);
  PI(2);

  /* Check Masked and Raw Interrupts and Clear It by writing another byte */
  PO(UART_TXRINT, UARTRIS_MASK, UARTRIS, byte_cycles,uartrisIDLE2);
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmisIDLE);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiirIDLE2);

  PSW(0x33, UARTDR);
  P_IDLE(4);

  /* Check Masked and Raw Interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartrisIDLE2);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmisIDLE2);
  PSR(0x00, UTIIR_MASK, UTIIR,utiirIDLE2);

  /* disable the UART and wait for the current word to be transmitted
     and read it out of trickbox */
  PSW(0, UARTCR_new);

  /* wait for the current word to be transmitted and read it out of
     trickbox, clear interrupts and repeat process after another IDLE
     period */
  P_IDLE(10);
  PO(0,UTRXBUSY,UTFR,byte_cycles*2,wait);
  PSR(0xEE & masks[wlength],0x1f, UTDR,readEE);
  
  /* Check Masked and Raw Interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartrisIDLE2);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmisIDLE2);
  PSR(0x00, UTIIR_MASK, UTIIR,utiirIDLE2);

  /* Enable Uart to transmit last word */
  PSW(cword, UARTCR_new);
  PI(2);

  /* Check Masked and Raw Interrupts and Clear It */
  PO(UART_TXRINT, UARTRIS_MASK, UARTRIS, byte_cycles,uartris33);
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmis33);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir33);
  PSW(0x20, UARTICR);
  
  P_IDLE(2*byte_cycles);

  /* disable the UART and wait for the current word to be transmitted
     and read it out of trickbox */
  PSW(0, UARTCR_new);

  /* wait for the current word to be transmitted and read it out of
     trickbox, clear interrupts and repeat process after another IDLE
     period */
  P_IDLE(10);
  PO(0,UTRXBUSY,UTFR,byte_cycles*2,wait);
  PSR(0x33 & masks[wlength],0x1f, UTDR,read33);

  C("Fifo Disabled : RXINT");  
 
  /* Disable Uart so data goes into holding buffer */
  PSW(0, UARTCR_new);
  PI(2);

  /* Now enable it again */
  PSW(cword, UARTCR_new);
  PI(2);
  
   /* Check Interrupts */
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis63);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir21);

   /* Write a Data byte to the Trick box */ 
  PSW(DATA_5s,UTDR);
  
  P_IDLE(wait_factor * 2);
  PSR(UTTXBUSY, UTTXBUSY, UTFR,utfr1a);

  /* Wait till the transmission is over */
  PO( 0x00, UTTXBUSY, UTFR, byte_cycles,utfr1);

  /* Check Interrupts */
  PO(UART_RXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis64);
  PSR(UT_UARTINTR | UT_RXINT, UTIIR_MASK, UTIIR,utiir22);

  /* Disable the uart alone , not the RX interrupt */
  PSW(0x00, UARTCR_new);
   
  /* Check Interrupts */
  PSR(UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis65);
  PSR(UT_UARTINTR | UT_RXINT, UTIIR_MASK, UTIIR,utiir23);

  /* Read the byte out of the Rxfifo */
  PSR(DATA_5s & masks[wlength], 0xff, UARTDR,uartdr1);

  /* Check Interrupts */
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir24);


  if ( mode == NORMAL_MODE)
    {
      C("Fifo Disabled :  TXINT and RXINT");
  
      /* Disable the Uart and Trick box and interrupts */
      PSW(0x00, UARTCR_new);
      PSW(0x00, UTCR);
  
      /* Enable the   TX RX interrupt alone */
      PSW(0x30, UARTIMSC);
  
      /* Check Interrupts */
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis66);
      PSR(0x00, UTIIR_MASK, UTIIR,utiir31);
  
      /* Write a Data byte to the Trick box and Uart */
      PSW(DATA_5s,UARTDR);

      /* Check Interrupts */
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis67);
      PSR(0x00 , UTIIR_MASK, UTIIR,utiir32);
  
      /* Enable the Trickbox first and then the Uart */
      PSW(cword, UTCR);
      PSW(cword, UARTCR_new);

      /* Write some data to the Trickbox */
      PSW(DATA_5s,UTDR);

      /* Wait till the transmission is over */
      PO(0x00, UART_UBUSY, UARTFR, byte_cycles,uartfr1);
      PI(0x02);
      PO( 0x00, UTTXBUSY | UTRXBUSY, UTFR, wait_factor * byte_cycles,utfr1);
  
      /* Check Interrupts */
      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis68);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir33);
  
      /* Disable the uart alone , not the RX interrupt */
      PSW(0x00, UARTCR_new);
  
      /* Check Interrupts */
      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis69);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir34);

      /* Clear Rx interrupt by writing to bit 4 of the interrupt clear register */
      PSW(0x10, UARTICR);
      PI(2);
      
      PO(UART_TXMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis70);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir35);
      
      /* Read the byte out of the Rx fifo */
      PSR(DATA_5s & masks[wlength], 0xff, UARTDR,uartdr1);
      PSR(DATA_5s & masks[wlength], 0xff, UTDR,utdr1);

      /* Write some data to the Trickbox */
      PSW(DATA_5s,UTDR);

      /* Enable Uart */
      PSW(cword, UARTCR_new);

      /* Wait till the transmission is over */
      PO(0x00, UART_UBUSY, UARTFR, byte_cycles,uartfr1a);
      PI(0x02);
      PO( 0x00, UTTXBUSY | UTRXBUSY, UTFR, wait_factor * byte_cycles,utfr1a);
  
      /* Check Interrupts */
      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis68a);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir33a);
      
      /* Read the byte out of the Rxfifo */
      PSR(DATA_5s & masks[wlength], 0xff, UARTDR,uartdr1);
 
      /* Check Interrupts */
      PO(UART_TXMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis70a);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir35a);
     
      /* Clear TX Interrupt before next test */
      PSW(0x20, UARTICR);

      /* Disable the Trick Box and the Uart */
      PSW(0x00, UARTCR_new);
      PSW(0x00, UTCR);
    }

  C("Fifo Enabled : TXINT");

  /* Disable the Uart, Interrupts and the TrickBox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UTCR);

  /* Configure the uart and the trick box */
  /* Enable the fifos also */
  hword |= 0x10;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Check Interrupts */
  PSR(0x00, UARTRIS_MASK, UARTRIS,uartris71);
  PSR(0, UARTMIS_MASK, UARTMIS,uartmis71);
  PSR(0, UTIIR_MASK, UTIIR,utiir41);
 
  /* Enable the interrupts alone */
  PSW(0x30, UARTIMSC);

  /* Check Interrupts */
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis73);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir42);

  /* Write Data bytes into the Transmit fifo one by one */
  for(i=0; i < (UARTFIFO_SIZE/2) + 1; i++)
    {
      PSW(i,UARTDR);
      /* Check Interrupts */
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmisWrites);
      PSR(0, UTIIR_MASK, UTIIR,utiirWrites);
    }


  /* Enable the uart also  so that it will start transmitting */
  PSW(cword, UARTCR_new);

  /* Check Interrupts */
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis75);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir45);

  /* Write one more word */
  PSW(i++,UARTDR);

  /* Check Interrupts */
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis76);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir46);

  /* Check interrupts again */
  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, byte_cycles,uartmis77);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir47);

  /* Disable the Uart  */
  PSW(0x00, UARTCR_new);

  /* Configure the uart and the Trick Box with fifo disabled to clear fifos */
  hword &= 0xef;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr12_d);

  C("Fifo Enabled : RXINT");

  /* Disable the Uart, interrupts and the TrickBox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UTCR);

  /* Configure the uart and the trick box */
  /* Enable the fifos also */
  hword |= 0x10;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Check Interrupts */
  PSR(0, UARTMIS_MASK, UARTMIS,uartmis78);
  PSR(0, UTIIR_MASK, UTIIR,utiir51);
 
  /* Enable the uart and interrupts */
  PSW(cword, UARTCR_new);
  PSW(0x30, UARTIMSC);

  /* Check interrupts again */
  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis79);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir52);

  /* Write 8 bytes to the Trick box */
  for(i=0; i< 8; i++)
    {
      PSW(i,UTDR);
    }

  /* Enable the Trickbox */
  PSW(cword, UTCR);
  
  P_IDLE(wait_factor * 2);
  
  /* Allow it to run till all bytes have been transmitted */
  PO(0x00, UTTXBUSY, UTFR, byte_cycles * 8,utfr51);
  

  /* Check interrupts */
  PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis80);
  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir53);

  /* Read one byte out of the Rxfifo */
  j=0;
  PSR(j & masks[wlength], 0xff, UARTDR,uartdr0);
  j++;

  /* Check interrupts again */
  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis81);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir54);

  i = 8;
  /* Write another byte to the Trick box */
  PSW(i, UTDR);
  i++;

  /* Allow it to run till this byte has been transmitted */
  PO(0x00, UTTXBUSY, UTFR, byte_cycles,utfr55);
  PI(2);

  /* Check interrupts */
  PO(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS, byte_cycles,uartmis82);
  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir56);

  /* Write another 8 bytes to the Trick box */
  for(; i< UARTFIFO_SIZE + 1; i++)
    {
      PSW(i,UTDR);
    }

  /* Allow it to run till all bytes have been transmitted */
  PO(UTTXBUSY, UTTXBUSY, UTFR, byte_cycles * 8,utfr57);
  PI(2);
  PO(0x00, UTTXBUSY, UTFR, byte_cycles * 8,utfr57);
  PI(2);

  /* Check interrupts */
  PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS, uartmis83);
  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir53a);

  /* j = 00 has already been read out */
  for(j=1; j< (UARTFIFO_SIZE + 1); j++)
    {
      /* Read from the Uart Rx fifo */
      PSR(j & masks[wlength], 0xff,UARTDR,uartdr);

    /* Check interrupts */
      if (j <= (UARTFIFO_SIZE/2))
	{
	  PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,some_cycles,uartmis84);
	  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir53b);
	}
      else
	{
	  PO(UART_TXMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis85);
	  PSR(UT_UARTINTR | UT_TXINT , UTIIR_MASK, UTIIR,utiir54);
	}
    }

  /* Disable the Trickbox, Interrupts & uart */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UTCR);

  C("Fifo Enabled : TXINT & RXINT");

  if (mode == NORMAL_MODE)
    {
      /* Disable the Uart and the TrickBox */
      PSW(0x00, UARTCR_new);
      PSW(0x00, UTCR);
  
      /* Configure the uart and the trick box */
      /* Enable the fifos also */
      hword |= 0x10;  
      ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
      ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
  
    /* Check Interrupts */
      PSR(0, UARTMIS_MASK, UARTMIS,uartmis86);
      PSR(0, UTIIR_MASK, UTIIR,utiir61);
   
    /* Enable the interrupts alone */
      PSW(0x30, UARTIMSC);
  
      /* Check Interrupts */
      PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis87);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir62);
  
    /* Write Data bytes into the Transmit fifo one by one */
      for(i=0; i < (UARTFIFO_SIZE/2) + 1; i++)
	{
	  PSW(i,UARTDR);
	  PSW(i,UTDR);
  
	  /* Check Interrupts */
	  if (i < (UARTFIFO_SIZE/2))
	    {
	      PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis88);
	      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir63);
	    }
	  else
	    {
	      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis89);
	      PSR(0x00, UTIIR_MASK, UTIIR,utiir64);
	    }
	}
  
      /* Enable the Uart and Trickbox */
      PSW(cword,UARTCR_new);
      PSW(cword,UTCR);
  
    /* Poll for transmit interrupt */
      PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis90);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir65);
  
    /* Poll for receive interrupt now */
      PO(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS, byte_cycles * 8,uartmis91);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir66);
  
    /* Wait till transmission is over */
      PO(0x00, UTTXBUSY, UTFR, byte_cycles,utfr);
  
      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis92);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir67);
  
      /* Read the bytes one by one */
      for(i=0; i< 9; i++)
	{
	  PSR(i & masks[wlength], 0xff, UARTDR,uartdr);
	  PSR(i & masks[wlength], MaskAll, UTDR,utdr);
	  if (i < 1)
	    {
	      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis92);
	      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir68);
	    }
	  else
	    {
	      PSR(UART_TXMINT , UARTMIS_MASK, UARTMIS,uartmis93);
	      PSR(UT_UARTINTR | UT_TXINT , UTIIR_MASK, UTIIR,utiir69);
	    }
	}
      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr12_d);
      PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,uartfr13_d);
    }

  /* Clear and disable interrupts and Uart */
  PSW(0x3ff, UARTICR);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);
}
