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
--  File Name              : Uart_FracBaudTests.c.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function FracBaudTests which is called in
   the main file Uart.c
/******************************************************************************/


/******************************************************************************/
/***************************** BaudTests **************************************/
/******************************************************************************/

void FracBaudTests(enum op_mode mode)
{
  /*
    Summary: FracBaud Tests
    ===================
 
    The first test uses the frequency measurement and frequency error detection 
    capabilities of the Trick Box. The UART and the Trick Box are disabled,
    configured for a buad rate and then enabled. The Trick Box is enabled 
    with the frequency measurement bit in its control register enabled. if
    any of the bit widths in the entire data frame fall outside the range, 
    the error bit is set in the trickbox register UT_FREQ_ERR.

  */

  
  int i = 0,j = 0,k=0, reg_val, div_all;
  int hword = 0x10;
  int wlength=5;
  int32 some_cycles = 10;
  unsigned int cword = 0x00, data_byte = 0x55;
  unsigned long measured_width, byte_cycles, bit_cycles;
  unsigned int divisor[3] = {0x01, 0x14, 0x1C};
  unsigned int fracdiv[3] = {0x01, 0x17, 0x3E};
  unsigned long bit_width;
 cword = 0x301;
 
  C("Normal mode Tx only");

  for( i = 0; i < 3; i++)
    {
      for( j = 0; j < 3; j++)      /* Disable the uart and the trick box */
	{
	  PSW(0, UTCR);
	  PSW(0, UARTCR_new);
      
	  /* Configure the uart and the trick box */
	  div_all = divisor[i] + ((fracdiv[j])/64);
	  bit_width = 16 * (div_all) * UARTCLK_PERIOD;
      
	  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
	  wlength = ((hword & 0x60) >> 5) + 5;
	  byte_cycles = (wlength + 6)  * bit_cycles;

	  ConfigureUbrlcr(divisor[i],hword,UARTLCR_H_new);
	  ConfigureUbrlcrTr(divisor[i],hword,UTLCR_H);
	  PSW(fracdiv[j], UARTFBRD);
	  PSW(fracdiv[j], UTFBRD);
	  PI(0x02);
	  PSR(fracdiv[j],0x3f,UARTFBRD,readfbrd);
      
	  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13);

	  /* Write Some data to the uart and trick box data registers */
	  for(k = 0; k < 16; k++)
	    {
	      reg_val = k | (k << 4);
	      PSW(reg_val, UARTDR);
	      PI(2);
	    }
 
	  PO(UART_UBUSY, UART_UBUSY, UARTFR, some_cycles,uarfr1); 

	  /* Enable the trick box and the uart */
	  /* along with frequency measurement */
	  PSW(0x80 | cword, UTCR);
	  PI(2);
	  PSW(cword, UARTCR_new);

	  PO(UART_UBUSY, UART_UBUSY, UARTFR, some_cycles,uartfr2);

	  PI(2);
  
      
	  PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR, byte_cycles*16,uartfr3);
	  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr4);

      
	  for(k=0; k < 16; k++)
	    {
	      reg_val = k | (k << 4);
	      PSR(reg_val, 0x1f, UTDR,utdrloop);
	      PSR(0, UTRSR_MASK, UTRSR,utrsr);

	      /* check bit width */
	      PSR(0x00, 0x01, UT_FREQ_ERR,freq_ctr_err);
	      PI(2);
	    }
      
	  /* Disable the uart and the trick box */
	  PSW(0, UTCR);
	  PSW(0, UARTCR_new);
	  PSW(0, UT_FREQ_ERR);
	}
    }


}

void FracBaudTests2(enum op_mode mode)
{
  /*
    Summary: Baud Tests
    ===================
 
    This test runs in loopback mode. The Uart is enabled with different baud rates
    and the received data is checked for correct reception.
 
  */

  
  int i = 0,j = 0,k=0, reg_val, div_all, div;
  int hword = 0x10;
  int wlength=5;
  int32 some_cycles, byte_cycles, bit_cycles, bit_width = 10;
  unsigned int cword = 0x00, data_byte = 0x55;
  unsigned long measured_width;
  unsigned int divisor[4] = {0x1, 0x16, 0x37, 0x1C};
  unsigned int fracdiv[10] = {0x17, 0x06, 0x07, 0x0B, 0x10, 0x18, 0x23, 0x2E, 0x37, 0x3E};
  
 
  C("Normal and Irda modes in loopback");
 
  if (mode == NORMAL_MODE)
    {
      cword = 0x381;
    }
  else if (mode == IRDA_MODE)
    {
      cword = 0x383;
      PSW(0x04, UARTTCR);
    }
  else if (mode == IRDA_LP_MODE)
    {
      cword = 0x387;
      PSW(0x04, UARTTCR);
    }

  for( i = 0; i < 4; i++)
    {
      for(j = 0; j < 10; j++)
	{
	  /* Disable the uart */
	  PSW(0, UARTCR_new);
      
	  /* Configure the uart */
	  div =  divisor[i] + ((fracdiv[j])/64);
	  div_all = div + 1;
	  	  
	  bit_cycles = (16 * (div_all)) * UARTCLK_PERIOD;
	  byte_cycles = (wlength + 6) * bit_cycles;

	  ConfigureUbrlcr(divisor[i],hword,UARTLCR_H_new);
	  ConfigureUbrlcrTr(divisor[i],hword,UTLCR_H);
	  PSW(fracdiv[j], UARTFBRD);
	  PSW(fracdiv[j], UTFBRD);
	  PI(0x02);
	  

	  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13);

	  /* Write Some data to the uart data register */
	  for(k = 0; k < 16; k++)
	    {
	      reg_val = k | (k << 4);
	      PSW(reg_val, UARTDR);
	      PI(2);
	    }
 
	  PO(UART_UBUSY, UART_UBUSY, UARTFR, some_cycles,uarfr1); 

	  /* Enable the uart */
	  PI(2);
	  PSW(cword, UARTCR_new);

	  PO(UART_UBUSY, UART_UBUSY, UARTFR, some_cycles,uartfr2);

	  PI(2);
	  PO(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR, byte_cycles*17,uartfr3);
	  PSR(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,uartfr4);

      
	  for(k=0; k < 16; k++)
	    {
	      reg_val = k | (k << 4);
	      PSR(reg_val, 0x1f, UARTDR,utdrloop);

	      PI(2);
	    }
      
	  /* Disable the uart */
	  PSW(0, UARTCR_new);
	}
    }

  
  PSW(0x00, UARTTCR);
  PSW(0x00, UARTFBRD);
  PSW(0x00, UTFBRD);


} 

