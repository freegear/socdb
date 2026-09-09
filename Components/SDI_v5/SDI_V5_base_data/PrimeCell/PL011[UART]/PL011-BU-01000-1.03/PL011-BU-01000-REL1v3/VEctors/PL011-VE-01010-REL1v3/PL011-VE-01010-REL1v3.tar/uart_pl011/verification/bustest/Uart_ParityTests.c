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
--  File Name              : Uart_ParityTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function TestParityError which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/*************************** TestParityError **********************************/
/******************************************************************************/

void TestParityError(unsigned int divisor, enum op_mode mode)
{
  /*
    Summary: Parity Error Check tests
    =================================

    In this a data frame with a parity error is sent to the UART from the 
    TrickBox. The parity error can be introduced by setting the PARITY_ERROR 
    bit in the UT_FORCED_ERR register of the trickbox.
    Then Status register  is checked to see if the parity error bit is set 
    or not. If not, then tests fails.  It also checks the setting and clearing
    of the parity error interrupt.

  */
  int hword = 0x42,wlength;
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
  
  /* Disable the uart and clear any interrupts that are set */
  PSW(0, UARTCR_new);
  PSW(0x7ff, UARTICR);

  /* Configure the uart */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Disable the trickbox */
  PSW(0, UTCR);
  PI(2);
  
   /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2); 
  /* Enable the uart  */
  PSW(cword, UARTCR_new);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PSW(FORCED_PARITY_ERR, UT_FORCED_ERRS);
  PI(2);

  PSW(0x33, UTDR);

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
  PI(2);
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xf7f, UARTDR,uartdrpe1);

  /* Check for parity error interrupt, the masked interrupt should not be set until
     the interrupt is enabled */
  PSR(UART_PERINT| UART_RXRINT, UARTRIS_MASK, UARTRIS,peint1);
  PSR(0x00,UARTMIS_MASK, UARTMIS,peint2);
  PSR(0x00,UTIIR_MASK,UTIIR,utp1);

  /* Enable interrupt and check again */
  PSW(0x100, UARTIMSC);
  PI(2);
  PSR(UART_PERINT, UARTRIS_MASK, UARTRIS,peint3);
  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp2);
  
  /* Check writing 0 to the interrupt clear reg does not clear interrupt */
  PSW(0x00, UARTICR);
  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp3);

  /* Check that writing a 1 to the error clear register doesn't clear the interrupt */
  PSW(0x100, UARTECR);
  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp4);

  /* Clear the interrupt */
  PSW(0x100, UARTICR);
  PI(4);
  PSR(0x00, UARTMIS_MASK, UARTMIS,peint4);
  
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr3);
  PSR(0x00,UTIIR_MASK,UTIIR,utp5);

  /* generate the interrupt again */
  PSW(0x55, UTDR);
  PI(10); 

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x55 & masks[wlength]);
  PSR(expected_value, 0xf7f, UARTDR,uartdrpe2);

  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp6);

  /* Send character without a parity error, interrupt should still be set  */
  PSW(0, UT_FORCED_ERRS);
  PI(2);

  PSW(0x33, UTDR);
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x00 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xf7f, UARTDR,uartdrpe4);

  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp7);
 
  
  /* Send character with a parity error, interrupt should still be set */
  PSW(FORCED_PARITY_ERR, UT_FORCED_ERRS);

  PSW(0x77, UTDR);
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x77 & masks[wlength]);
  PSR(expected_value, 0xf7f, UARTDR,uartdrpe5);

  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint9);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp8);

  /* Clear interrupt */
  PSW(0x100, UARTICR);
  PI(4);
  PSR(0x00, UARTMIS_MASK, UARTMIS,peint6);
  PSR(0x00, UTIIR_MASK,UTIIR,utp9);

   /* Generate interrupt, then clear it, then send no error and then an error.
      The interrupt should be set after the last word is sent. */
  PSW(0x11, UTDR);
  PI(10); 

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x11 & masks[wlength]);
  PSR(expected_value, 0xf7f, UARTDR,uartdrpe2);

  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp10);

  PSW(0x100, UARTICR);
  PI(2);

  /* Character with no error, interrupt should not be set */
  PSW(0, UT_FORCED_ERRS);
  PI(2);

  PSW(0x22, UTDR);
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x00 << 8) | (0x22 & masks[wlength]);
  PSR(expected_value, 0xf7f, UARTDR,uartdrpe4);
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,peint9);
  PSR(0x00, UTIIR_MASK,UTIIR,utp11);

  /* Character with parity error, interrupt should be set */
  PSW(FORCED_PARITY_ERR, UT_FORCED_ERRS);

  PSW(0x33, UTDR);
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xf7f, UARTDR,uartdrpe5);

  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint9);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp12);

  PSW(0x100, UARTICR);
  
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


void TestStickParity(unsigned int divisor, enum op_mode mode)
{
  /*
    Summary: Stick Parity tests
    ===========================
    This test checks the stick parity function. Data is transmitted form the Uart
    to the trickbox and is checked for correct parity bit generation.
    Data is transmitted from the trickbox to the Uart with and without an error
    and the data is checked for correct reception and correct error generation.
  */
  
  int hword = 0xA2,wlength;
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

  C("Stick Parity Tx - parity bit 1");
  
  /* This test transmits a word from the Uart to the trickbox. The Even Parity
     Select bit is first disabled and then enabled for the second transmission.
     The data is checked in the trickbox for correct data and correct parity bit
     and no errors should be generated. */

  /* Configure the uart with stick parity */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart  */
  PSW(cword, UARTCR_new);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);

  /* Set Stick Parity in the trickbox */
  PSW(hword, UTSTPARITY);
  PI(2);

  PSW(0x33, UARTDR);
  PI(2);
  
  /* Wait till the byte is fully transmitted and check for parity error */
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,poll1);
  PI(2);

  PSR(0x33, 0xf2f, UTDR,uartdrpe1);
  PI(2);
  PSR(0x00, UTIIR_MASK, UTIIR,sp2);

  /* disable Uart and trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  
  C("Stick Parity Tx - parity bit 0");

  hword = 0xA6,wlength;
  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  /* Configure the uart with stick parity */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart  */
  PSW(cword, UARTCR_new);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);

  /* Set Stick Parity in the trickbox */
  PSW(hword, UTSTPARITY);
  PI(2);

  PSW(0x77, UARTDR);
  PI(2);
  
  /* Wait till the byte is fully transmitted and check for parity error */
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR, byte_cycles,poll1);
  PI(2);

  PSR(0x77, 0xf2f, UTDR,uartdrpe1);
  PI(2);
  PSR(0x00, UTIIR_MASK, UTIIR,sp3);

  /* disable Uart and trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);


  C("Stick Parity Rx - parity bit 1, no error");

  /* This test checks the parity bit which is received by the Uart.  A word will
     be transmitted from the trickbox, and the data and parity bit checked. */

  
  hword = 0xA2,wlength;
  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  /* Configure the uart with stick parity */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart  */
  PSW(cword, UARTCR_new);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);

  /* Set Stick Parity in the trickbox */
  PSW(hword, UTSTPARITY);
  PI(2);

  PSW(0x11, UTDR);
  PI(2);

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
  PI(2);
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  PSR(0x11, 0xf2f, UARTDR,uartdrpe1);
  PI(2);
  PSR(0x00, UART_PERINT, UARTRIS,sp5);

 C("Stick Parity Rx - parity bit 0, no error");

  /* This test checks the parity bit which is received by the Uart.  A word will
     be transmitted from the trickbox, and the data and parity bit checked. */

  
  hword = 0xA6,wlength;
  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  /* Configure the uart with stick parity */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart  */
  PSW(cword, UARTCR_new);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);

  /* Set Stick Parity in the trickbox */
  PSW(hword, UTSTPARITY);
  PI(2);
  
  /* Enable interrupt and check again */
  PSW(0x100, UARTIMSC);
  PI(2);
  
  PSW(0x22, UTDR);
  PI(2);

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
  PI(2);
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  PSR(0x22, 0xf2f, UARTDR,uartdrpe1);
  PI(2);
  PSR(0x00, UART_PERINT, UARTRIS,sp5);
  PSR(0X00, UTIIR_MASK, UTIIR, SP6);

  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  C("Stick Parity Rx - parity bit 1, parity error");

  /* This test checks the parity error generation of the Uart. A word is
     transmitted from the trickbox with a parity error, and the data is checked
     and that an error has been generated. */

  hword = 0xA2,wlength;
  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  /* Configure the uart with stick parity */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart  */
  PSW(cword, UARTCR_new);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PSW(FORCED_PARITY_ERR, UT_FORCED_ERRS);

  /* Set Stick Parity in the trickbox */
  PSW(hword, UTSTPARITY);
  PI(2);

  PSW(0x88, UTDR);
  PI(2);

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
  PI(2);
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x88 & masks[wlength]);
  PSR(expected_value, 0xf2f, UARTDR,uartdrpe1);
  PI(2);
  PSR(UART_PEMINT, UART_PEMINT, UARTMIS,sp5);
  PSR(UT_UARTINTR|UT_UARTEINTR, UTIIR_MASK, UTIIR,sp7);

  PSW(0x00, UARTCR_new);
  PSW(0x00,UTCR);
  
  C("Stick Parity Rx - parity bit 0, parity error");

  /* This test checks the parity error generation of the Uart. A word is
     transmitted from the trickbox with a parity error, and the data is checked
     and that an error has been generated. */

  hword = 0xA6,wlength;
  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  /* Configure the uart with stick parity */
  ConfigureUbrlcr(divisor, hword, UARTLCR_H_new);

  /* Enable the trickbox */
  PSW(cword, UTCR);
  PI(2);
  
  /* Enable the uart  */
  PSW(cword, UARTCR_new);
       
  /* Configure the trickbox */
  ConfigureUbrlcrTr(divisor, hword, UTLCR_H);
  PSW(FORCED_PARITY_ERR, UT_FORCED_ERRS);

  /* Set Stick Parity in the trickbox */
  PSW(hword, UTSTPARITY);
  PI(2);

  PSW(0x99, UTDR);
  PI(2);

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
  PI(2);
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x99 & masks[wlength]);
  PSR(expected_value, 0xf2f, UARTDR,uartdrpe1);
  PI(2);
  PSR(UART_PEMINT, UART_PEMINT, UARTMIS,sp5);
  PSR(UT_UARTINTR|UT_UARTEINTR, UTIIR_MASK, UTIIR,sp7);

  PSW(0x00, UARTCR_new);
  PSW(0x00,UTCR);
  PSW(0x00, UTSTPARITY);
  PSW(0x00, UARTIMSC);

}
