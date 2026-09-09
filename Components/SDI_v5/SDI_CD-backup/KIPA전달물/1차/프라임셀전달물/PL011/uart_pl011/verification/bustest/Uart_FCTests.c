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
--  File Name              : Uart_FCTests.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function FlowControlTests which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/******************** Flow Control Tests **************************************/
/******************************************************************************/

void FlowControlTests(void)
{
  /*
  Summary: Flow Control Tests
  ===========================
  
  */
  

  int i = 0,j, reg_val;
  int32 some_cycles = 10;
  int cword = 0x301;
  int hword = 0x60;
  int32 bit_cycles, byte_cycles;
  unsigned long bit_width;
  int wlength;

  divisor = 0x2;
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
  
  C("FC: RTS Test");
  
  C("FC: Fifo disabled");

  /* Configure the uart */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

   /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart  */
   PSW(cword, UARTCR_new); 
  PI(2);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PI(2);

  /* Check the initial state of nUARTRTS, it should not be set - should
     be logic 1 as it is active low */
  PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts1);

  /* Enable RTS flow control and nUARTRTS should be asserted (logic 0) */
  PSW(RTSEn|cword, UARTCR_new);
  PI(4);
  PSR(0x00, UT_RTS, UT_CHECK_PINS,rts2);

  /* The receive fifo is written to and nUARTRTS should be logic 1 to
     indicate no more room for data */
  PSW(0x44, UTDR);
  PO(UART_RXFF, UART_RXFF, UARTFR,byte_cycles,fr1);
  PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts3);

  /* The data is read out and nUARTRTS should be reasserted (logic 0) */
  PSR(0x44, UARTDR_MASK,UARTDR,dr1);
  PI(4);
  PSR(0x00, UT_RTS, UT_CHECK_PINS,rts4);
  
  /* Disable RTS flow control and send a word - there should be no
     effect on nUARTRTS */
  PSW(cword, UARTCR_new); 
  PI(4);
  PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts5);
  PI(2);
  PSW(0x66, UTDR);
  PO(UART_RXFF, UART_RXFF, UARTFR,byte_cycles,fr2);
  PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts6);

  /* Check that when RTS flow is disabled the value written to bit 11
     of UARTCR is assigned to nUARTRTS */

  PSW(cword|nUARTRTS, UARTCR_new);
  PI(4);
  PSR(0x00, UT_RTS, UT_CHECK_PINS,rts7);

  PSR(0x66, UARTDR_MASK, UARTDR,read2);
  PSR(UART_RXFE|UART_TXFE, UART_RXFE|UART_TXFE, UARTFR,fr3);
  
  /* Disable trickbox and fifo */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);


  C("FC: Fifo enabled"); 
  hword = 0x70;
 /* Configure the uart */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart  */
/*   PSW(cword, UARTCR_new);  */
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PI(2);

  /* Set watermark level to 1/2 full and set TESTFIFO mode */
  PSW(0x12, UARTIFLS);
  PI(2);
  PSW(TESTFIFO, UARTTCR);

  PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts8);

  /* Enable RTS flow control and check that nUARTRTS is set (logic 0) */
  PSW(RTSEn, UARTCR_new);
  PI(2);
  PSR(0x00, UT_RTS, UT_CHECK_PINS,rts9);

  /* Write 8 words to the fifo and check that nUARTRTS is set(0) and
     on the 9th and  10th it will not be set(1) */

    
  for(i = 0; i < 10; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(2);
      if (i < 8)
	{
	  PSR(0x00, UT_RTS, UT_CHECK_PINS,rts10);
	}
      else
	{
	  PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts11);
	}
    }

  /* Read out 3 words and then nUARTRTS should be set(0) as the fifo
     will be filled to below the watermark level */

   for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,read1);
      PI(2);
      if (i < 3)
	{
	  PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts12);
	}
      else
	{
	  PSR(0x00, UT_RTS, UT_CHECK_PINS,rts13);
	}
    }  

   /* Disable the RTS flow control and write another 2 words into
      the Rx fifo and nUARTRTS should be the value on bit 11 of UARTCR */
   PSW(0x00, UARTCR_new);
   PI(2);
   PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts14);
   
   for(i = 10; i < 12; i++)
     {
       reg_val = i | (i << 4);
       PSW(reg_val, UARTTDR);
       PI(2);
       PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts15);
     }

   /* Read out the data and check that there is no activity on nUARTRTS */
   for(i = 4; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR,read1);
      PI(2);
      PSR(UT_RTS, UT_RTS, UT_CHECK_PINS,rts15);
    }    

   /* Disable trickbox and fifo */
   PSW(0x00, UARTTCR);
   PSW(0x00, UARTCR_new);
   PSW(0x00, UTCR);
   
   C("FC: CTS Test");
   C("FC: Fifo disabled");
   
   hword = 0x60;
   divisor = 0x3;
   bit_width = 16 * (divisor) * UARTCLK_PERIOD;
   bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
   wlength = ((hword & 0x60) >> 5) + 5;
   byte_cycles = (wlength + 6)  * bit_cycles;

   /* Configure the uart */
   ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

   /* Enable the trickbox */
   PSW(cword, UTCR);
   PI(2);
         
   /* Configure the trickbox */
   ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
   PI(2);
  
   /* Check that nUARTCTS is set to it's inactive state */
   PSR(nUARTCTS, nUARTCTS, UT_SET_PINS,reset);
 
   /* A word of data is written to the Tx Fifo  */
   PSW(0x55, UARTDR);

   /* Enable CTS Flow Control */
   PSW(CTSEn|cword, UARTCR_new);
   PI(4);

  /* Check it is not transmitted */  
  PSR(UART_TXD,UART_TXD, UT_CHECK_PINS,transmit);
/*   P_IDLE(byte_cycles); */
  
  PSR(UTRXFIFO_EMPTY,UTRXFIFO_EMPTY , UTFR,notrans1);
  

  /* Assert nUARTCTS (0) and check data is transmitted */
  PSW(0x00, UT_SET_PINS);
  PSR(0x00, UART_TXD, UARTFR,rx1);
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,DataRxed55);
  PI(2);
  PSR(0x55, 0xff,UTDR,data);
  PI(2);
  PSR(UTRXFIFO_EMPTY,UTRXFIFO_EMPTY , UTFR,notrans2);
  
  /* Begin transmitting data and deassert nUARTCTS during transmission, check
     that current character received correctly */

  PSW(0x99, UARTDR);
  P_IDLE(bit_cycles);
  PSW(nUARTCTS,UT_SET_PINS);
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,DataRxed99);
  P_IDLE(bit_cycles);
  PSR(0x99,0xff,UTDR,data2);

  /* Disable CTS flow control and check that nUARTCTS has no effect on
     transmission */

  PSW(cword, UARTCR_new);
  PI(2);

  PSW(0x33, UARTDR);
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,DataRxed33);
  P_IDLE(bit_cycles);
  PSR(0x33,0xff,UTDR,data2);

  PSW(0x00, UT_SET_PINS);
  PI(2);

  PSW(0x77, UARTDR);
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,DataRxed77);
  P_IDLE(2*bit_cycles);
  PSR(0x77,0xff,UTDR,data2);
  P_IDLE(2);

  PSR(UTRXFIFO_EMPTY,UTRXFIFO_EMPTY , UTFR,empty);

  PSW(0x00,UARTCR_new);
  PSW(0x00,UTCR);
  PSW(nUARTCTS,UT_SET_PINS);
  
  C("FC: CTS Test");
  C("FC: Fifo enabled");
 
  hword = 0x70;
  
  /* Configure the uart */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
         
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PI(2);
  
  /* Check that nUARTCTS is set to it's inactive state */
  PSR(nUARTCTS, nUARTCTS, UT_SET_PINS,reset);

  /* 8 words of data are written to the Tx Fifo */
  for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(2);
    }
  
  /* Enable CTS Flow Control */

  PSW(CTSEn|cword, UARTCR_new);
  PI(5);

  /* Check it is not transmitted */
  
  PSR(UART_TXD,UART_TXD, UT_CHECK_PINS,transmit);
/*   P_IDLE(byte_cycles); */
  
  PSR(UTRXFIFO_EMPTY,UTRXFIFO_EMPTY , UTFR,notrans3);
  

  /* Assert nUARTCTS (0) and check data is transmitted */
  PSW(0x00, UT_SET_PINS);
  PSR(0x00, UART_TXD, UARTFR,rx1);
  PO(0x00, UART_UBUSY, UARTFR,byte_cycles*8,wait);
 

  for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,0xfff,UTDR,data3);
      PI(2);
    }

  PSR(UTRXFIFO_EMPTY,UTRXFIFO_EMPTY , UTFR,notrans4);

  /* Deassert nUARTCTS before next transmission */
  PSW(nUARTCTS, UT_SET_PINS);

  P_IDLE(20); /* wait */
  
  /* Begin transmitting data and deassert nUARTCTS during transmission, check
     that current character received correctly */

  for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);	  
      PSW(reg_val, UARTDR);
      PI(2);
    }

  PSW(0x00, UT_SET_PINS);

  /* Wait for 6 characters to be transmitted before taking CTS high */
  P_IDLE(byte_cycles*4);
  PSW(nUARTCTS, UT_SET_PINS);
  
  PO(0x00,UTRXBUSY,UTFR,byte_cycles,stop);
  PI(2);
  
  /* 6 words should have been received correctly */
  for(i = 0; i < 6; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,0xfff,UTDR,data4);
    }     

  /* Transmit the rest of the words out of the TX FIFO */
  PSW(0x00, UT_SET_PINS);
  
  PO(0x00, UART_UBUSY,UARTFR,byte_cycles*3,wait2);
  
  for(i = 6; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,0xfff,UTDR,data5);
    }

  /* Disable CTS flow control and check that nUARTCTS has no effect on
     transmission */

  PSW(cword, UARTCR_new);
  PI(2);

  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);	  
      PSW(reg_val, UARTDR);
      PI(2);
      if(i == 2)
	{
	   PSW(nUARTCTS, UT_SET_PINS);
	   PI(2);
	}
      else
	 {
	   PI(2);
	 }
    }

  PO(0x00,UART_UBUSY,UARTFR,byte_cycles*4,stop);

  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,0xff,UTDR,data6);
    }      


  PSR(UART_TXFE|UART_RXFE,UART_TXFE|UART_RXFE,UARTFR,empty3);
  
  PSW(0x00,UARTCR_new);
  PSW(0x00,UTCR);


  C("FC: CTS and RTS Test");
  
  /*This test tests the CTS and RTS flow control. The Tx fifo is
    filled with the watermark level set to 1/2.  The UART is enabled
    and a check is made that transmission stops when the receive fifo
    is half full.  A word is read out and a check made that
    transmission restarts.  The words are read out of the rx fifo
    checking for correct transmission */
  
  hword = 0x70;
  cword = 0x381;
  divisor = 0x01;
  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  /* Configure the uart */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);
  PI(2);

  /* Set the watermark level to be 1/2 full */
  PSW(UART_RXFHALF|UART_TXFHALF,UARTIFLS);
  PI(2);

  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);	  
      PSW(reg_val, UARTDR);
      PI(2);
    }

  PSR(UART_TXFF|UART_RXFE, UART_TXFF|UART_RXFF, UARTFR,fifofull);

  /* Enable the UART in loopback mode with CTS and RTS flow control enabled */
  PSW(cword|CTSEn|RTSEn,UARTCR_new);
  PI(5);

  /* Wait for Rx fifo to be half full */
  PO(UART_RXRINT,UART_RXRINT, UARTRIS,byte_cycles*8,rxint);
  P_IDLE(9*bit_cycles);

  /* Check for inactive level on UARTTXD */
  PSR(UART_TXD, UART_TXD, UT_CHECK_PINS,inactive1);
  P_IDLE(byte_cycles*8);
  PSR(UART_TXD, UART_TXD, UT_CHECK_PINS,inactive2);
  P_IDLE(2*bit_cycles);

  /* Read 2 words out of the Rx fifo and then check that transmission
     restarts */
  for(i = 0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, UARTDR_MASK, UARTDR, data9);
      PI(2);
    }
  
  PSR(0x00,UART_RXRINT, UARTRIS,rxint1);
  PI(3);	  
  PSR(0x00,UART_TXD,UT_CHECK_PINS,tx1);

  /* When transmission begins, a word is transmitted which triggers
     the watermark level but by the time nUARTRTS signal is deasserted
     another word has begun to be transmitted.  Hence, 2 words are
     read out each time but transmission only begins after the 2nd
     word has been read out */

     
 PO(UART_RXRINT,UART_RXRINT, UARTRIS,byte_cycles,rxint2);
 P_IDLE(bit_cycles*18);

  /*  Check that TXD line is inactive */
 PSR(UART_TXD,UART_TXD,UT_CHECK_PINS,tx2);
 
  for(i = 2; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,UARTDR_MASK,UARTDR,data10);
    }

  /* Now Check that lines are active again */
  PI(3);
  PSR(0x00,UART_RXRINT, UARTRIS,rxint3);
  PI(4);	  
  PSR(0x00,UART_TXD,UT_CHECK_PINS,tx22);

 PO(UART_RXRINT,UART_RXRINT, UARTRIS,byte_cycles,rxint41);
 P_IDLE(bit_cycles*18);

 /*  Check that TXD line is inactive */
 PSR(UART_TXD,UART_TXD,UT_CHECK_PINS,tx3);

 for(i = 4; i < 6; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,UARTDR_MASK,UARTDR,data9);
    }

  /* Now Check that lines are active again */
  PI(3);
  PSR(0x00,UART_RXRINT, UARTRIS,rxint42);
  PI(4);	  
  PSR(0x00,UART_TXD,UT_CHECK_PINS,tx33);
 
 PO(UART_RXRINT,UART_RXRINT, UARTRIS,byte_cycles,rxint51);
 P_IDLE(bit_cycles*18);

 /*  Check that TXD line is inactive */
 PSR(UART_TXD,UART_TXD,UT_CHECK_PINS,tx4);

  for(i = 6; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,UARTDR_MASK,UARTDR,data9);
    }

  /* Now Check that lines are active again */
  PI(3);
  PSR(0x00,UART_RXRINT, UARTRIS,rxint52);
  PI(4);	  
  PSR(0x00,UART_TXD,UT_CHECK_PINS,tx52);
  
 PO(UART_RXRINT,UART_RXRINT, UARTRIS,byte_cycles,rxint61);
 P_IDLE(bit_cycles*18);

 /*  Check that TXD line is inactive */
 PSR(UART_TXD,UART_TXD,UT_CHECK_PINS,tx5);

  for(i = 8; i < 10; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,UARTDR_MASK,UARTDR,data9);
    }

  /* Should have finished all data transmission by now */
  PSR(UART_TXFE,UART_TXFE,UARTFR,Complete);
  
  for(i = 10; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val,0xfff,UARTDR,data9);
      PI(6);
      PSR(UART_TXD,UART_TXD,UT_CHECK_PINS,tx6);
    }
  
  PSR(UART_TXFE|UART_RXFE,UART_TXFE|UART_RXFE,UARTFR,empty);

  
  PSW(0x000,UARTCR_new);
  PSW(0x7ff, UARTICR);
  PSW(0x00, UTCR);
           
}

