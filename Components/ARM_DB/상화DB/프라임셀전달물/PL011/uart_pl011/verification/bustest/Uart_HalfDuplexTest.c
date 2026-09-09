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
--  File Name              : Uart_HalfDuplexTest.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function HalfDuplexTest which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/****************************** HalfDuplexTest ********************************/
/******************************************************************************/

void HalfDuplexTest(unsigned int divisor,enum op_mode mode)
{
  /*
    Summary: Half Duplex Tests
    ==========================
  
    These tests check the Half Duplex property of the UART in the IrDA mode.
    Some data bytes are written into the UART's Tx Fifo and UART is enabled
    to start transmission. After some time, data bytes are written into
    trickbox Tx fifo to cause serial data transfer over the RXD line. The
    UART should ignore all these bytes as long as transmission is active.
    This is done by checking the RXFE flag of the UART. It must remain set 
    throughout the test.

  */

  int i,j,reg_val, wlength;
  int hword = 0x10, cword = 0x00;
  int32 byte_cycles,bit_cycles,some_cycles = 10;
  unsigned long bit_width;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  if (mode == IRDA_MODE)
    cword = 0x303;

  else if (mode == IRDA_LP_MODE)
    cword = 0x307;

  /* Disable the UART & trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Enable the UART & trickbox*/
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);

  /* Write some data to the uart to start transmitting */
  for(i=0; i< 5; i++)
    {
      reg_val = (i | (i << 4));
      PSW(reg_val, UARTDR);
    }

  /* Check flags  to make sure that transmission is going on */
  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr1);

  /* Now write some data to the trickbox to wiggle the RX line */
  PSW(DATA_As, UTDR);

  for(i=0; i< byte_cycles; i++)
    {
      PSR(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR,uartfrloop);
    }

  PO(0x0, UART_UBUSY, UARTFR, 4*byte_cycles,halfdup1); 

  /* Disable the UART & trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

}
