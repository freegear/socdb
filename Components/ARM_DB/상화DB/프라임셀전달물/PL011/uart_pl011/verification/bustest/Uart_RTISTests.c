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
--  File Name              : Uart_RTISTests.c.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the functions RTISTest and AnotherRTISTest which are
   called in the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/**************************** RTISTest ****************************************/
/******************************************************************************/

void RTISTest(unsigned int divisor, enum op_mode mode)
{
  /* 
     Summary: Recieve Time Out Interrupt Tests
     =========================================
  
     One Byte of data is transmitted from the trickbox to the UART. After this 
     byte has been completelely transmitted, the devices are kept enabled and 
     idle for 32 bit periods. The recieve time out must be get asserted only 
     after 32 bit periods, not before.

  */
 
  int i;
  int hword = 0x00,cword;
  int wlength;
  unsigned long bit_cycles, byte_cycles,some_cycles = 10;
  unsigned long bit_width;
  int expected_value;
  int value;
  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

 
  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    {
      cword = 0x303;
      PSW(0x1f, UT_SET_PINS);
    }
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;
  
  
  /* Disable the uart and the trick box */
  PSW(0, UARTCR_new);
  PI(2);
  PSW(0, UTCR);
  PSW(0, UARTIMSC);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Clear any interrupts that have already been set */
  PSW(0x7ff, UARTICR);
  PI(2);
  
  /* Enable the uart, interrupts and trickbox */
  PSW(cword, UARTCR_new);
  PSW(0x40,UARTIMSC);
  PSW(cword, UTCR);

  PSW(0x66, UTDR);
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr11_f);

  PO(UART_RXFF | UART_TXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr12);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartiir11);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr11);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, bit_cycles,poll1a);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintra);

  expected_value = 0 | (0x66 & masks[wlength]);
  PSR(expected_value, 0xf00, UARTDR,uartdr1);

  PSW(0x00, UARTECR); 
  
  expected_value = 0 | (0x00);
  PSR(expected_value, 0xf00, UARTDR,uartdr2);

  
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,poll1b);
  PSR(0x00, UTIIR_MASK, UTIIR,utintrb);

  /* Check interrupt is not set when Rx fifo is empty */
  PO(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr12_a);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartiir11_a);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr11_a);
      i += 2;
    }
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartintr12);
 
  PSR(0x00, UTIIR_MASK, UTIIR,utintr12);

  /* Generate interrupt, send more data and check that interrupt is not cleared */

   /* Disable the uart, interrupts and the trick box */
  hword = 0x70;
  PSW(0, UARTCR_new);
  PI(2);
  PSW(0, UTCR);
  PSW(0, UARTIMSC);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

    /* Enable the uart, interrupts and trickbox */
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);
  PSW(0x40,UARTIMSC);
  
  PSW(0x88, UTDR);
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr11_f);
  PI(2); 
     
  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartiir11_b);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr11_b);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll1_b);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr_b);

  P_IDLE(0x10);
  PSW(0x33, UTDR);
  PI(2);
  PO(UTTXFIFO_EMPTY,UTTXBUSY,UTFR,byte_cycles,utfr1);
  P_IDLE(0x100);
  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS,bit_cycles,uartintr13);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr13);
  PI(2);
  
  /* Write a 1 to bit 6 of UARTICR and check that interrupt is cleared */

  PSW(0x40, UARTICR);
  P_IDLE(0x10);
  PO(0x00,UARTMIS_MASK, UARTMIS, byte_cycles,poll3);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr3); 

  expected_value = 0 | (0x88 & masks[wlength]);
  PSR(expected_value, 0xf00, UARTDR,uartdr_3);
  expected_value = 0 | (0x33 & masks[wlength]);
  PSR(expected_value, 0xf00, UARTDR,uartdr_4);

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr12_g);

  PSR(0x00, UARTMIS_MASK, UARTMIS,uartdr_7);
  PSR(0x00, UTIIR_MASK, UTIIR,utdr_7);

  /* Transmit 16 words, cause interrupt and then read out 16 and check interrupt has cleared */

  for(i = 0; i < 16 ; i++)
    {
      value = i | (i << 4);
      PSW(value, UTDR);
    }

  PO(UART_RXFF | UART_TXFE, UARTFR_MASK, UARTFR,byte_cycles*16,uartdr_a); 
  
  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartiir11_b2);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr11_b2);
      i += 2;
    }
    
  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll1_b);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr_b);

  for(i = 0; i < 16 ; i++)
    {
      value = i | (i << 4);
      PSR(value, 0xff, UARTDR,uartdr_5);
      PI(2);
    }

  PI(2);

  PSR(0x00, UARTMIS_MASK, UARTMIS,uartdr_6);
  PSR(0x00, UTIIR_MASK, UTIIR,utdr_6);

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartdr_f);

  /* Check consecutive timeout errors being set */
  hword = 0x70;
  
  /* Disable the uart and the trick box */
  PSW(0, UARTCR_new);
  PI(2);
  PSW(0, UARTIMSC);

  /* Make sure everything inside UART will be disabled (due to
     synchronisation delays */
  PI(2);
  PSW(0, UTCR);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
  
  /* Enable the uart, interrupts and trickbox */
  PSW( cword, UARTCR_new);
  PSW(cword, UTCR);
  PSW(0x40, UARTIMSC);

  PSW(0x99, UTDR);
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr15_f);

  PO(0, UTTXBUSY, UTFR, byte_cycles,uartfr15);
  PI(2);
  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis12);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr12);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, bit_cycles,poll1);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintrc);

  PSW(0x40, UARTICR);
  P_IDLE(0x4);

  PO(0x00, UARTMIS_MASK, UARTMIS, bit_cycles,poll1);
  PSR(0x00, UTIIR_MASK, UTIIR,utintrd);

  /* generate 2nd interrupt */
  PSW(0x88, UTDR);

  PO(0, UTTXBUSY, UTFR, byte_cycles,uartfr16);
  P_IDLE(4);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis13);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr13);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll13);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintre);

  PSW(0x40, UARTICR);
  PI(2);

  PSR(0x99, UARTDR_MASK, UARTDR,uartdr13);
  PI(2);
  PSR(0x88, UARTDR_MASK, UARTDR,uartdr13a);
  PI(2);


  /* Check that writing '0' to the UARTICR doesn't clear the interrupts */
  PSW(0x22, UTDR);
  PI(2);
  PSW(0x44, UTDR);
  PI(2);
      
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr17_f);

  PO(0, UTTXBUSY, UTFR, byte_cycles,uartfr16);
  PI(2);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis14);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr14);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll14);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintrf);

  PSW(0x00, UARTICR);
  PI(2);
  PSR(UART_RTMINT, UARTMIS_MASK, UARTMIS,poll15b);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr15b);

  /* Check that disabling the interrupt clears the interrupt signal */

  PSW(0, UARTIMSC);
  P_IDLE(4);
  PSR(0, UARTMIS_MASK, UARTMIS,poll15b);

  PSW(0x40, UARTIMSC);
 
  /* Empty fifo */
  PSR(0x22, UARTDR_MASK, UARTDR,uartdr15);
  PSR(0x44, UARTDR_MASK, UARTDR,uartdr15a);
 
  P_IDLE(4); 
  PSR(0x00 , UARTMIS_MASK, UARTMIS,poll15);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr15);
  
  /* generate and clear again */
  PSW(0x22, UTDR);
  PI(2);
  PSW(0x44, UTDR);
  PI(2);
      
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr17_f);

  PO(0, UTTXBUSY, UTFR, byte_cycles,uartfr16);
  PI(2);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis14);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr14);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll14);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintrg);

  PSW(0x00, UARTICR);
  PI(2);
  PSR(UART_RTMINT, UARTMIS_MASK, UARTMIS,poll15b1);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr15b);

  /* Clear interrupts */
  PSR(0x22, UARTDR_MASK, UARTDR,uartdr15);
  PSR(0x44, UARTDR_MASK, UARTDR,uartdr15a);
 
  P_IDLE(4); 
  PSR(0x00 , UARTMIS_MASK, UARTMIS,poll15);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr15);

  /* Check that writing a '1' to the UARTICR Rx timeout bit doesn't set the interrupt */
  PSW(0x40, UARTICR);
  P_IDLE(4);
  PSR(0x00 , UARTMIS_MASK, UARTMIS,poll15c);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr15c);

  
 /* Clean up the mess */
  P_IDLE(4);
   
  PSW(0x00, UTCR);
  PSW(0x00, UARTCR_new);

  PSW(0x0f,UT_SET_PINS);
  PI(3);

  /* Disable the uart */
  PSW(0x00, UARTCR_new);
  PSW(0,UARTIMSC);
}



/******************************************************************************/
/************************** AnotherRTISTest ***********************************/
/******************************************************************************/

void AnotherRTISTest(unsigned int divisor, enum op_mode mode)
{
  /*
    Summary: Receive Timeout Interrupt Tests
    ========================================
  
    The Uart and TrickBox are configured and enabled. As soon as Uart is enabled
    the data pin is driven low from the trickbox. The Recieve Timeout interrupt
    is checked after 32 bit period. It should has been asserted.

  */   
  
  int hword = 0x00,cword,i;
  int wlength;
  unsigned long bit_cycles,some_cycles = 10;
  unsigned long bit_width;
  unsigned long time;
  int expected_value;
  
    
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  time = 2500;
  
  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307; 
  
   /* Disable the uart and the trick box */
  PSW(0, UARTCR_new);
  PI(2);
  PSW(0, UTCR);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Enable the uart & RTIS interrupt - keep the trickbox disabled */
  PSW(0x40, UARTIMSC);
  PSW(cword, UARTCR_new)
    
    C("The polling test below - tag idle - must fail to ensure correct uart operation\n"); 
    PO(UART_RTRINT, UART_RTRINT, UARTRIS,time,idle);
 
  /* Drive a low value on the RX/SIRIN line to make the uart believe it
     has started receiving data */
  if (mode == NORMAL_MODE)
    {
      PSW(0x07,UT_SET_PINS);
    }
  else
    {
      PSW(0x1f,UT_SET_PINS);
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, 20 * bit_cycles,poll1);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintrh);
 
  expected_value = (0x05 << 8) | (0x00);
  PSR(expected_value, 0xf00, UARTDR,uartdr1);

  PSW(0x40, UARTICR);

  expected_value = (0x05 << 8) | (0x00);
  PSR(expected_value, 0xf00, UARTDR,uartdr2);

  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,poll1);
  PSR(0x00, UTIIR_MASK, UTIIR,utinti);

  /* Clean up the mess */
  PSW(0x03f,UT_SET_PINS);
  PI(3);

  /* Disable the uart */
  PSW(0x00, UARTCR_new);
  PSW(0X00, UARTIMSC);
}

