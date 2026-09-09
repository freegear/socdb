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
--  File Name              : Uart_JitterTests.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function TestJitter which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/*************************** TestJitter  **************************************/
/******************************************************************************/

void TestJitter(unsigned int divisor, enum op_mode mode)
{
  /*
    Summary: Tolerance Tests
    ========================
  
    These series of tests transmit a slightly skewed data stream. The 
    start bit of every data frame is lengthened or shortened by a jitter 
    factor programmed into the Trick Box register UT_FORCED_ERRS. The jitter
    factor can be any integer between -3 to +3. The data recieved by the UART
    must be same as the data transmitted by the trickbox. 
 
  */

#define NO_BYTES 10
  int hword = 0x10;
  int cword, wlength;
  int i,j;
  unsigned int value;
  int32 some_cycles = 10,byte_cycles,bit_cycles;
  int max_jitter;
  unsigned long bit_width;
  int jitter_bits[6] = {0x24, 0xb4, 0x48, 0xd8, 0x6c, 0xfc};
  /* +1    -1   +2     -2   +3    -3 */
  int expected_value;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
 
  if (mode == NORMAL_MODE)
    {
      max_jitter = 6;
      cword = 0x301;
    }
  else if (mode == IRDA_MODE)
    {
      max_jitter = 4;
      cword = 0x303;
    }
  else if (mode == IRDA_LP_MODE)
    {
      max_jitter = 2;
      cword = 0x307;
    }

  for(i= 0; i < 1; i++)
    {
      /* Disable the uart and the trickbox */
      PSW(0, UTCR);
      PSW(0, UARTCR_new);
         
      /* Configure the uart  & trickbox */
      ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);
      ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
      PSW(jitter_bits[i], UT_FORCED_ERRS);

      /* Enable the uart */
      PSW(cword, UARTCR_new);
      PSW(cword, UTCR);

      for(j = 0; j < NO_BYTES; j++)
	{
	  value = j | (j << 4);
	  PSW(value, UTDR);
	}

      PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr1);
   
    /* Wait long enough for the bytes to be transmitted */
      PO(0x00, UTTXBUSY, UTFR, byte_cycles * NO_BYTES,poll1);

      /* Check bytes */
      for(j=0; j < NO_BYTES; j++)
	{
	  value = j | ( j << 4);

	  expected_value = 0 | (value & masks[wlength]);
	  PSR(expected_value, 0xfff, UARTDR,uartdrloop);
 
	  if (j < (NO_BYTES-1))
	    {
	      PSR( UART_TXFE , UARTFR_MASK, UARTFR,uartfr2);
	    }
	  else
	    {
	      PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr3);
	    }
	}
    }

  /* Disable the uart and the trickbox */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  PSW(0, UT_FORCED_ERRS);
}
