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
--  File Name              : Uart_ModemTests.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function TestModem which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/**************************** TestModem  **************************************/
/******************************************************************************/

void TestModem(unsigned int divisor,enum op_mode mode)
{
  /*
    Summary: Modem Tests
    ====================

    These tests check the modem status flags and the interrupt UARTMSINTR.
    The Modem lines are driven through the UT_SET_PINS register in TrickBox.
    The modem pin values are checked in the UART flag register UARTFR and the
    modem interrupts are checked in the Raw Interrupt status and the Masked
    Interrupt status registers. 
    Another test checks the assertion and deassertion of modem status flags 
    and pins during reception and transmission in various modes.

  */
   

  int i,some_cycles = 10;
  int hword = 0x10,wlength;
  unsigned int cword=0;
  int32 byte_cycles,bit_cycles;
  unsigned long bit_width;
  int expected_value;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;
  
  C("MSINT  & MODEM line flags test");

  /* This statement is read if test is conducted after reset */
  PI(0x10);
  
  /* Enable Modem Interrupts */
  PSW(0x0f, UARTIMSC);

  /* Set all Modem pins to value one */
  PSW(UT_SET_DSR | UT_SET_DCD | UT_SET_CTS | UT_SET_RI,UT_SET_PINS);
  
  PO(0x00, UARTFR_MOD, UARTFR, some_cycles,uartfr11_e);
  PSR(0x00, UARTFR_MOD, UARTFR, some_cycles,uartfr13);
  
  /* Clear modem interrupts incase any have been asserted */
  PSW(0x0f, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris1);  
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis1);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr1);

  PSR(0x00, UARTFR_MOD, UARTFR,uartfr14); 

  /* Assert DCD  */
  PSW(UT_RESET_DCD, UT_SET_PINS);
  PI(0x2);

  PO(UART_DCD, UARTFR_MOD, UARTFR, some_cycles,uartfr16);
  PI(2);
  PO(UART_DCDRINT, 0x0f, UARTRIS, some_cycles,uartris2);
  PSR(UART_DCDMINT, UARTMIS_MASK, UARTMIS,uartmis2); 
  PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr2);

  /* Clear interrupts */
  PSW(0x04, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris3);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis3);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr3);
  
  PSR(UART_DCD, UARTFR_MOD, UARTFR,uartfr17); 
 
  /* Assert DSR */
  PSW(UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);
  PI(2);

  PO(UART_DCD | UART_DSR, UARTFR_MOD, UARTFR, some_cycles,uartfr19);
  PI(2);
  PO(UART_DSRRINT , 0x0f, UARTRIS, some_cycles,uartris4);
  PSR(UART_DSRMINT , UARTMIS_MASK, UARTMIS,uartmis4);
  PSR(UT_UARTINTR | UT_MSINT , UTIIR_MASK, UTIIR,utintr4);

  /* Clear interrupts */
  PSW(0x0C, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris5);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis5);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr5);
  
  PSR(UART_DCD | UART_DSR, UARTFR_MOD, UARTFR,uartfr20);
  
  /* Assert CTS */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);

  PO(UART_DCD | UART_DSR | UART_CTS, UARTFR_MOD, UARTFR, some_cycles,uartfr22);
  PI(2);
  PO(UART_CTSRINT, 0x0f, UARTRIS, some_cycles,uartris6);
  PSR(UART_CTSMINT, UARTMIS_MASK, UARTMIS,uartmis6);
  PSR(UT_UARTINTR | UT_MSINT , UTIIR_MASK, UTIIR,utintr6);

  /* Clear interrupts */
  PSW(0x0E, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris7);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis7);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr7);

  PSR(UART_DCD | UART_DSR | UART_CTS, UARTFR_MOD, UARTFR,uartfr23);

  /* Assert RI */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);
  
  PO(UART_DCD | UART_DSR | UART_CTS | UART_RI, UARTFR_MOD, UARTFR, some_cycles,uartfr25);

  PI(2);
  PO(UART_RIRINT, 0x0f, UARTRIS, some_cycles,uartris6);
  PSR(UART_RIMINT, UARTMIS_MASK, UARTMIS,uartmis6);
  PSR(UT_UARTINTR | UT_MSINT , UTIIR_MASK, UTIIR,utintr6);

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris7);
  PSR(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis7);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr7);
 
  PSR(UART_DCD | UART_DSR | UART_CTS | UART_RI, UARTFR_MOD, UARTFR,uartfr27);
 
  /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);

  PO(0x00, UARTFR_MOD, UARTFR, some_cycles,uartfr28);
  PI(2);
 
  PO(UART_DSRRINT|UART_DCDRINT| UART_CTSRINT|UART_RIRINT , 0x0f, UARTRIS, some_cycles,uartris8);
  PSR(UART_DSRMINT|UART_DCDMINT| UART_CTSMINT|UART_RIMINT , UARTMIS_MASK, UARTMIS,uartmis8);
  PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr8);

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris9); 
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis9); 
  PSR(0x00, UTIIR_MASK, UTIIR,utintr9);

  PSR(0x00, UARTFR_MOD, UARTFR, some_cycles,uartfr30); 

  /* Disable UART and interrupts */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);
  PSW(0x00, UARTIMSC);
  
  PSR(0x00, UARTFR_MOD, UARTFR,uartfr32);


  C("MSINT during xmission");

  ConfigureUbrlcr(divisor,hword,UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword,UTLCR_H);
  for(i=0; i< 8; i++)
    {
      PSW(i, UARTDR);
    }
   
  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr34);

  /* Enable UART & Trickbox  & RX , TX & MSINT Interrupts */
  PSW(cword, UTCR);
  PSW(cword, UARTCR_new);
  PSW(0x3F, UARTIMSC);

  /* Set all Modem pins to value one */
  PSW(UT_SET_DSR | UT_SET_DCD | UT_SET_CTS | UT_SET_RI,UT_SET_PINS);
 
  PO(UART_RXFE | UART_UBUSY,0x1FF, UARTFR, some_cycles,uartfr35);

  /* Clear  interrupts incase any have been asserted */
  PSW(0x3f, UARTICR);
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris10);
  PSR(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis10);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr1);

  /* Check only the modem pin values */
  PSR(0x00 , UARTFR_MOD, UARTFR,uartfr36);
 
  /* Assert DCD  */
  PSW(UT_RESET_DCD, UT_SET_PINS);

  PO(UART_DCD, UARTFR_MOD, UARTFR, some_cycles,uartfr38);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis11);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr2);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis12);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr2);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PI(2);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis13);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr3);

  PSR(UART_DCD, UARTFR_MOD, UARTFR,uartfr39);
 
  /* Assert DSR */
  PSW(UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);

  PO(UART_DCD | UART_DSR , UARTFR_MOD, UARTFR, some_cycles,uartfr41);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DSRMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis14);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr4);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis15);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr4);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis16);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr5);

  PSR(UART_DCD | UART_DSR , UARTFR_MOD, UARTFR,uartfr42);
  
  /* Assert CTS */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);

  PO(UART_DCD | UART_DSR | UART_CTS , UARTFR_MOD, UARTFR, some_cycles,uartfr44); 
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_CTSMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis16);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr6);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis17);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr6);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis18);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr7);

  PSR(UART_DCD | UART_DSR | UART_CTS , UARTFR_MOD, UARTFR,uartfr45);

  /* Assert RI */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);

  PO(UART_DCD | UART_DSR | UART_CTS | UART_RI , UARTFR_MOD, UARTFR, some_cycles,uartfr47);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis19);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr6);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis20);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr6);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis21);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr7);

  PSR(UART_DCD | UART_DSR | UART_CTS | UART_RI, UARTFR_MOD, UARTFR,uartfr48);
 
   /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);
 
  PO(0x00 , UARTFR_MOD, UARTFR, some_cycles,uartfr50);
  PI(2);

  PI(2); 
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT|UART_CTSMINT|UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis22);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr8);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis23);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr8);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis24);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr9);

  PSR(0x00 , UARTFR_MOD, UARTFR, some_cycles,uartfr52);
  
  /* Disable MSINT alone */
  PSW(0x30, UARTIMSC);
  
  PSR(0x00, UARTFR_MOD, UARTFR,uartfr54); 
 
  /* Assert CTS */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);

  PO(UART_DCD | UART_DSR | UART_CTS | UART_RI , UARTFR_MOD, UARTFR, some_cycles,uartfr56);
  PI(2);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis25);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr6);

  /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);
  
  PO(0x00 , UARTFR_MOD, UARTFR, some_cycles,uartfr57);

  PI(2); 
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis26);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr8);

  PO(UART_UBUSY, UART_UBUSY,UARTFR,byte_cycles*8,busy);
  PI(5);
  PO(0, UART_UBUSY,UARTFR,byte_cycles*8,busy2);
  
 
  for(i=0; i<8; i++)
    {
      PSR(i,0x1f,UTDR,read);
    }
 
  /* Disable UART and all Interrupts */ 

  PSW(0x00, UARTCR_new);
  PSR(0x00 , UARTFR_MOD, UARTFR,uartfr59);
  PSW(0x00, UARTIMSC);

  /* To discard contents of fifo */
  ConfigureUbrlcr(divisor,0x00,UARTLCR_H_new);
  PI(5);
  
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR, empty);
  PO(UART_RXFE, UART_RXFE, UARTFR,some_cycles,wait);
  
  C("MSINT during reception");

  /* Disable UART  and Trickbox*/
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(divisor,hword,UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword,UTLCR_H);

  /* Enable UART  & RX , TX & MSINT Interrupts */
  PSW(cword, UTCR);
  PI(wait_factor * 2);
  PSW( cword, UARTCR_new);
  PSW(0x3F, UARTIMSC);
  for(i=0; i< 8; i++)
    {
      PSW(i, UTDR);
    }
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr61);

  /* Wait till there is something in the rx fifo */
  PO(UART_TXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr62);

  /* Set all Modem pins to value one */
  PSW(UT_SET_DSR | UT_SET_DCD | UT_SET_CTS | UT_SET_RI,UT_SET_PINS);
  PO(UART_TXFE, NoMask, UARTFR, some_cycles,uartfr63);

  /* Clear modem interrupts incase any have been asserted */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis27);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr31);

  PSR(UART_TXFE, NoMask, UARTFR,uartfr64);
  
  /* Assert DCD  */
  PSW(UT_RESET_DCD, UT_SET_PINS);
  PO(UART_TXFE | UART_DCD, NoMask, UARTFR, some_cycles,uartfr66);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis28);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr32);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis29);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr33);
    }
  
  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis30);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr34);
  PSR(UART_TXFE | UART_DCD, NoMask, UARTFR,uartfr67);
 
  /* Assert DSR */
  PSW(UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);
  PO(UART_TXFE | UART_DCD | UART_DSR , NoMask, UARTFR, some_cycles,uartfr69);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DSRMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis31);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr35);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis32);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr36);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis33);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr37);
  PSR(UART_DCD | UART_DSR | UART_TXFE , NoMask, UARTFR,uartfr70);

  /* Assert CTS */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);
  PO(UART_DCD | UART_DSR | UART_CTS | UART_TXFE , NoMask, UARTFR, some_cycles,uartfr72);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_CTSMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis34);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr38);
    }
  else
    {
      PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis35);
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr37);
    }
  
  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis36);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr38);
  PSR(UART_DCD | UART_DSR | UART_CTS | UART_TXFE , NoMask, UARTFR,uartfr73);
 
  /* Assert RI */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);
 
  PO(UART_DCD | UART_DSR | UART_CTS | UART_TXFE | UART_RI , NoMask , UARTFR, some_cycles,uartfr77);
  
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis37);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr38a_RI);
    }
  else
    {
      PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis38);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr37c_RI);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis39);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr38d_RI);
  
  PSR(UART_DCD | UART_DSR | UART_CTS | UART_TXFE | UART_RI, NoMask, UARTFR,uartfr78);  
  
  PO(UART_RXMINT, UARTMIS_MASK, UARTMIS, (byte_cycles * 7),uartmis40);

  PSR(UART_TXFE | UART_DCD | UART_DSR | UART_CTS | UART_RI, NoMask, UARTFR,uartfr80);
 
  
  /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);
  PO(UART_TXFE , NoMask, UARTFR, some_cycles,uartfr82);
  PI(2);  
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT|UART_CTSMINT|UART_RIMINT| UART_RXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis41);
      PSR(UT_UARTINTR | UT_MSINT | UT_RXINT, UTIIR_MASK, UTIIR,utintr310);
    }
  else
    {
      PO(UART_RXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis42);
      PSR(UT_UARTINTR| UT_RXINT, UTIIR_MASK, UTIIR,utintr311);
    }
  /* Read out all the data from the uart to empty the fifo */
  for(i=0; i < 8; i++)
    {
      expected_value = 0 | (i & masks[wlength]);
      PSR(expected_value, 0xfff, UARTDR,uartdr);
      if ( i < 7)
	{
	  PSR(UART_TXFE, NoMask, UARTFR,uartfr84);
	}
      else
	{
	  PSR(UART_TXFE | UART_RXFE, NoMask, UARTFR,uartfr85);
	}
      if (mode == NORMAL_MODE)
	{
	  PO(UART_DCDMINT|UART_DSRMINT|UART_CTSMINT|UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis43);
	  PSR(UT_UARTINTR | UT_MSINT , UTIIR_MASK, UTIIR,utintr311);
	}
      else
	{
	  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis44);
	  PSR(0x00 , UTIIR_MASK, UTIIR,utintr312);
	}
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis45);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr313);
  PSR(UART_TXFE | UART_RXFE, NoMask, UARTFR,uartfr86);

  

  /* Check that writing '1' to the UARTICR Modem status bits doesn't set the interrupts */
  PSW(0x01, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis46);
  PSW(0x02, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis46);
  PSW(0x04, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis46);
  PSW(0x08, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis46);

  
  PSR(UART_TXFE | UART_RXFE, NoMask, UARTFR,uartfr86a);

  /* Assert all modem lines */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);
  
  PO(UART_DCD | UART_DSR | UART_CTS | UART_RI | UART_TXFE | UART_RXFE , NoMask, UARTFR, some_cycles,uartfr88);
  
  PI(2);
 
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT| UART_CTSMINT|UART_RIMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis50);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr314);
    }
  else
    {
      PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis51);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr315);
    }

  /* Check that writing '0' to the UARTICR doesn't clear the interrupts */

  PSW(0x00, UARTICR);
  PI(2);

  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT| UART_CTSMINT|UART_RIMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis52);
      PSR(UART_DCDRINT|UART_DSRRINT| UART_CTSRINT|UART_RIRINT , UARTRIS_MASK, UARTRIS, some_cycles,uartris52);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr314a);
    }
  else
    {
      PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis53);
      PSR(0x00 , UARTRIS_MASK, UARTRIS, some_cycles,uartris53);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr315a);
    }
        
    
  /* Disable TX & RX interrupts alone */
  PSW(0x0f, UARTIMSC);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT| UART_CTSMINT|UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis316);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr316);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis317);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr317);
    }

  /* Disable the MSINT */
  PSW(0x00,UARTIMSC);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartiir318);
  PSR(0x00, UTIIR_MASK, UTIIR_MASK,utintr318);

  /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);
  PO(UART_TXFE | UART_RXFE , NoMask, UARTFR, some_cycles,uartfr90);
  
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDRINT|UART_DSRRINT| UART_CTSRINT|UART_RIRINT, UARTRIS_MASK, UARTRIS, some_cycles,uartris316);
    }
  else
    {
      PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris316);
    }
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis319);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr319);

  /* Disable UART and all Interrupts */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);
  PSW(0x00, UARTIMSC);

  /* Clear any modem Interrupts that are set */
  PSW(0x0f, UARTICR);
  PI(2);
  
  PSR(UART_TXFE | UART_RXFE, NoMask, UARTFR,uartfr92);

  PSW(0x18, UT_SET_PINS);
  
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTFR,test);
}
