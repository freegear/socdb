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
--  File Name              : Uart_FramingTests.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function TestFramingError which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/***************************** TestFramingError *******************************/
/******************************************************************************/

void TestFramingError(unsigned int divisor, enum op_mode mode)
{
  /*
    Summary: Framing Error Check tests
    ==================================
 
    A low value is driven on the UARTRXD line instead of the stop bit by 
    setting the FRAMING_ERROR  bit in the UT_FORCED_ERR register in the 
    TrickBox. Then Status register  is checked to see if the Framing error 
    bit is set or not. If not, then tests fails. It also checks the setting and
    clearing of the framing error interrupt 
 
  */

  int hword = 0x60;
  int cword,wlength;
  int i,j;
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

  /* Disable the uart and clear any interrupts that are set */
  PSW(0, UARTCR_new);
  PSW(0x7ff, UARTICR);

  /* Configure the uart */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);
 
  /* Disable the trickbox */
  PSW(0, UTCR);

  /* Enable the uart */
  PSW(cword, UARTCR_new);

  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PSW(FORCED_FRAMING_ERR, UT_FORCED_ERRS);

  /* Enable the trickbox */
  PSW(cword, UTCR);

  PSW(0x33, UTDR);
  P_IDLE(0x10);
  
  /* Wait long enough for one byte to be transmitted and check for framing error */
  PO(0x00, UTTXBUSY, UTFR, byte_cycles,poll1);

  expected_value = (0x01 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdr);  

  /* Check for framing error interrupt, the masked interrupt should not be set until
     the interrupt is enabled */
  PSR(UART_FERINT | UART_RXRINT, UARTRIS_MASK, UARTRIS,feint1);
  PSR(0x00,UARTMIS_MASK, UARTMIS,feint2);
  PSR(0x00, UTIIR_MASK,UTIIR,utf1);
  
  /* Enable interrupt and check again */
  PSW(0x80, UARTIMSC);
  PI(2);
  PSR(UART_FERINT, UARTRIS_MASK, UARTRIS,feint3);
  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf2);
  
  /* Check writing 0 to the interrupt clear reg does not clear interrupt */
  PSW(0x00, UARTICR);
  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf3);

  /* Check that writing a 1 to the error clear register doesn't clear the interrupt */
  PSW(0x100, UARTECR);
  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf4);

  /* Clear the interrupt */
  PSW(0x80, UARTICR);
  PI(4);
  PSR(0x00, UARTMIS_MASK, UARTMIS,feint4);
  PSR(0x00, UTIIR_MASK,UTIIR,utf5);
  
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr3);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr3);

   /* generate the interrupt again */
  PSW(0x55, UTDR);
  P_IDLE(0x10); 

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x01 << 8) | (0x55 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrfe2);

  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf6);

  
  /* Send character without a framing error, interrupt should still be set  */
  PSW(0, UT_FORCED_ERRS);
  PI(2);

  PSW(0x33, UTDR);
  P_IDLE(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x00 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrfe4);

  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf7);
 
  
  /* Send character with a framing error, interrupt should still be set */
  PSW(FORCED_FRAMING_ERR, UT_FORCED_ERRS);

  PSW(0x77, UTDR);
  P_IDLE(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x01 << 8) | (0x77 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrfe5);

  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint9);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf8);

  /* Clear interrupt */
  PSW(0x80, UARTICR);
  PI(4);
  PSR(0x00, UARTMIS_MASK, UARTMIS,feint6);
  PSR(0x00, UTIIR_MASK,UTIIR,utf9);

   /* Generate interrupt, then clear it, then send no error and then an error.
      The interrupt should be set after the last word is sent. */
  PSW(0x11, UTDR);
  P_IDLE(0x10); 

  /* Wait till the byte is fully transmitted and check for framing error */
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x01 << 8) | (0x11 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrfe2);

  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf10);

  PSW(0x80, UARTICR);
  PI(2);

  /* Character with no error, interrupt should not be set */
  PSW(0, UT_FORCED_ERRS);
  PI(2);

  PSW(0x22, UTDR);
  P_IDLE(0x10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x00 << 8) | (0x22 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrfe4);
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,peint9);
  PSR(0x00, UTIIR_MASK,UTIIR,utf11);

  /* Character with framing error, interrupt should be set */
  PSW(FORCED_FRAMING_ERR, UT_FORCED_ERRS);

  PSW(0x33, UTDR);
  P_IDLE(0x10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x01 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrfe5);

  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint9);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf12);

  PSW(0x80, UARTICR);
  
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr3);

   /* Clear error status bit, and interrupt and disable interrupts */
  PSW(0x00, UARTECR);
  PSW(0x00, UARTIMSC);
  PSW(0x00,UT_FORCED_ERRS); 
  
  /* Disable the uart and the trickbox */
  PI(2);
  PSW(0, UTCR);
  PI(2);
  PSW(0, UARTCR_new);

}
