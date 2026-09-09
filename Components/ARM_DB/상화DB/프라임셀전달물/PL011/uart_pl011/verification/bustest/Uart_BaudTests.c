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
--  File Name              : Uart_BaudTests.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function BaudTests which is called in
   the main file Uart.c
/******************************************************************************/


/******************************************************************************/
/***************************** BaudTests **************************************/
/******************************************************************************/

void BaudTests(enum op_mode mode)
{
  /*
    Summary: Baud Tests
    ===================
 
    These tests use the frequency measurement and frequency error detection 
    capabilities of the Trick Box. The UART and the Trick Box are disabled,
    configured for a buad rate and then enabled. The Trick Box is enabled 
    with the frequency measurement bit in its control register enabled. if
    any of the bit widths in the entire data frame fall outside the range, 
    the error bit is set in the trickbox register UT_FREQ_ERR. This test is 
    conducted for eight different divisor values 0,1,3,5,11,19,29,39.

  */

  int i = 0, reg_val;
  int hword = 0x00;
  int wlength=5;
  int32 some_cycles = 10;
  unsigned int cword = 0x00, data_byte = 0x55;
  unsigned long measured_width, byte_cycles;
  unsigned int divisor[7] = {0x01, 0x03, 0x05, 0x11, 0x19, 0x29, 0x39};
  unsigned long bit_width;
 
  if (mode == NORMAL_MODE)
    {
      cword = 0x301;
      data_byte = 0x55;
    }
  else if (mode == IRDA_MODE)
    {
      cword = 0x303;
      data_byte = 0x00;
    }
  else if (mode == IRDA_LP_MODE)
    {
      cword = 0x307;
      data_byte = 0x00;
    }

  for( i = 0; i < 7; i++)
    {
      /* Disable the uart and the trick box */
      PSW(0, UTCR);
      PSW(0, UARTCR_new);
 
      /* Configure the uart and the trick box */
      bit_width = 16 * (divisor[i]) * UARTCLK_PERIOD;
      ConfigureUbrlcr(divisor[i],hword,UARTLCR_H_new);
      ConfigureUbrlcrTr(divisor[i],hword,UTLCR_H);

      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13);

    /* Write Some data to the uart and trick box data registers */
      PSW(data_byte , UARTDR);

      PO(UART_UBUSY, UART_UBUSY, UARTFR, some_cycles,uarfr1); 

    /* Enable the trick box and the uart */
    /* along with frequency measurement */
      PSW(0x80 | cword, UTCR); 
      PSW(cword, UARTCR_new);

      PO(UART_UBUSY, UART_UBUSY, UARTFR, some_cycles,uartfr2);

      PI(2);
  
      byte_cycles = (bit_width / PCLK_PERIOD) * 14; 
      PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr3);
      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr4);

      PSR(data_byte & masks[wlength], 0xff, UTDR,utdr);
      PSR(0, UTRSR_MASK, UTRSR,utrsr);

      /* check bit width */
      PSR(0x00, 0x01, UT_FREQ_ERR,freq_ctr_err);

      /* Disable the uart and the trick box */
      PSW(0, UTCR);
      PSW(0, UARTCR_new);
      PSW(0, UT_FREQ_ERR);
    }
}
