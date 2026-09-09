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
--  File Name              : Uart_loopbackTest.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function loopback_mode which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/*************************** loopback_mode ************************************/
/******************************************************************************/

void loopback_mode(void)
{
  /*
    Summary: Loop Back Mode Tests
    =============================
  
    This is to test the UART in the loop back mode. In this UART is enabled in
    the loopback mode. TrickBox is disabled. Now data is written to the Tx fifo
    and after complete transmission, data is read from the Rx fifo and checked 
    for correct transmission.

  */
 
  int hword;
  unsigned int divisor;

  int i = 0,j, reg_val;
  int wlength;
  int32 bit_cycles, byte_cycles;
  int32 some_cycles = 10;
  int cword = 0x00;
  unsigned long bit_width;
 
  C("Loop Back Mode test with fifo enabled");
  divisor = 0x03;
  hword = 0x7e;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
  cword = 0x381;

  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);

  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_p);
 
  PSW(cword, UARTCR_new);
  
  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4); 
      PSW(reg_val, UARTDR);
      PI(0x05);
    }

  PO( 0x0 , UART_UBUSY, UARTFR, 16 * wait_factor * byte_cycles,poll11);

  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,utdrlast);
      PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast);
    }

  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_q);
  
  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x05);
    }
  
  PO( 0 , UART_UBUSY, UARTFR,(byte_cycles*15),poll11);
 
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xff, UARTDR,utdrlast1);
      PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast2);
    }


  /* This tests the modem signals in the loopback mode. Data is written to the modem
     signals nUARTRTS, nUARTDTR, nUARTOut2 and nUARTOut1 and the signals nUARTCTS,
     nUARTDSR, nUARTRI and nUARTDCD are checked for correct transmission of the data. */

  /* Disable loopback mode */

  PSW(0x301, UARTCR_new);
  PI(2);

  /* Write to the output modem signals */
  PSW(0x2B01, UARTCR_new);
  PI(2);
  PSR(0x00,masks[3],UARTFR,uartfr_lb);
  PSR(0x14,0x3C,UT_CHECK_PINS,utcheckpins_lb1); 
  PI(2);
   
  PSW(0x1401, UARTCR_new);
  PI(2); 
  
   
  PSR(0x28,0x3C,UT_CHECK_PINS,utcheckpins_lb2); 
  PSR(0x00,UARTFR_MOD,UARTFR,uartfr_lb2a);

  /* Enable loopback mode */

  PSW(cword, UARTCR_new);
  PI(2);

  PSR(0x3C,0x3C,UT_CHECK_PINS,utcheckpins_lb3);
  PSR(0x00,UARTFR_MOD,UARTFR,uartfr_lb0);
 
  /* bit 0 */
  PSW(0x781, UARTCR_new);
  PI(2);
  PSR(0x38,0x3C,UT_CHECK_PINS,utcheckpins_lb4);
  PSR(0x92,UARTFR_MOD,UARTFR,uartfr_lb1);
 

  PSW(0x381, UARTCR_new);
  PI(2);
  PSR(0x3C,0x3C,UT_CHECK_PINS,utcheckpins_lb5);
  PSR(0x00,masks[3],UARTFR,uartfr_lb2);

  
  /* bit 1 */
  PSW(0xB81, UARTCR_new);
  PI(2);
  PSR(0x34,0x3C,UT_CHECK_PINS,utcheckpins_lb6);
  PSR(0x91,UARTFR_MOD,UARTFR,uartfr_lb3);
  
  PSW(0x381, UARTCR_new);
  PI(2);
  PSR(0x3C,0x3C,UT_CHECK_PINS,utcheckpins_lb7);
  PSR(0x00,masks[3],UARTFR,uartfr_lb4);

  /* bit 2 */
  PSW(0x1381, UARTCR_new);
  PI(2);
  PSR(0x2C,0x3C,UT_CHECK_PINS,utcheckpins_lb8);
  PSR(0x94,masks[3],UARTFR,uartfr_lb5);
  
  PSW(0x381, UARTCR_new);
  PI(2);
  PSR(0x3C,0x3C,UT_CHECK_PINS,utcheckpins_lb9);
  PSR(0x00,masks[3],UARTFR,uartfr_lb6);

  /* bit 3 */
  PSW(0x2381, UARTCR_new);
  PI(2);
  PSR(0x1C,0x3C,UT_CHECK_PINS,utcheckpins_lb10);
  PSR(0x100,UARTFR_MOD,UARTFR,uartfr_lb7);
  
  PSW(0x381, UARTCR_new);
  PI(2);
  PSR(0x3C,0x3C,UT_CHECK_PINS,utcheckpins_lb11);
  PSR(0x00,UARTFR_MOD,UARTFR,uartfr_lb8);
 
}
