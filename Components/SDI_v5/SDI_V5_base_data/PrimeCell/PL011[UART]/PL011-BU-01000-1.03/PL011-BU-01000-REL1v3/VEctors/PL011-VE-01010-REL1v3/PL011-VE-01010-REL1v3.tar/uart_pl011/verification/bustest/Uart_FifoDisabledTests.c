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
--  File Name              : Uart_FifoDisabledTests.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function FifoDisabledTests which are called in
   the main file Uart.c
/******************************************************************************/
   


/******************************************************************************/
/************************  FifoDisabledTests **********************************/
/******************************************************************************/

void FifoDisabledTests(void)
{
  /*
    Summary: FIFO Disable Tests 
    ===========================
 
    These are the series of tests which test transmission and reception of
    data by the UART through the TrickBox while FIFOs are disabled. 
    These tests are conducted for different combinations of baud rate, word 
    length, parity type and stop bits. 
    This Function calls TestWithConfiguration() function with different 
    combinations.

    Also test the case where data is written to the UART just as the shift
    register becomes empty. This depends on predicting the number of clock
    cycles between UARTCLK and PCLK for a character to be transmitted
    so will not function if either is changed
   */
 
  int hword;
  unsigned int divisor;
  enum op_mode mode = NORMAL_MODE;
  int expected_value;
  int32 bit_cycles, byte_cycles;
  int32 some_cycles = 10;
  int i = 0;
  int wlength;
  unsigned long bit_width;
  int cword = 0x00;

  C("Fifo Tests : Word Length 8, No Parity, No Extra Stop Bit");
  hword = 0x60;
  divisor = 0x02;
  TestWithConfiguration(divisor,hword,mode);
  /*
  C("Fifo Tests : Word Length 6, Odd Parity, No Extra Stop Bit");
  hword = 0x22;
  divisor = 04;
  TestWithConfiguration(divisor,hword,mode);

  C("Fifo Tests : Word Length 7, Even Parity, No Extra Stop Bit");
  hword = 0x46;
  divisor = 0x03;
  TestWithConfiguration(divisor,hword,mode);

  C("Fifo Tests : Word Length 8, No Parity,  Extra Stop Bit");
  hword = 0x68;
  divisor = 0x01;
  TestWithConfiguration(divisor,hword,mode);

  C("Fifo Tests : Word Length 5, Odd Parity,  Extra Stop Bit");
  hword = 0x0a;
  divisor = 0x02;
  TestWithConfiguration(divisor,hword,mode);

  C("Fifo Tests : Word Length 6, Even Parity,  Extra Stop Bit");
  hword = 0x2E;
  divisor = 0x02;
  TestWithConfiguration(divisor,hword,mode);
  */
  /* Write as shift register empties */
  divisor = 0x03;
  hword = 0x6e;
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
  cword = 0x381;

  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);

  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_r);
 
  PSW(cword, UARTCR_new);
  
  C("Boundary Condition Test: Read And Write At Same Time FIFO Disabled");

  /* Transmit two characters with a gap to allow for the first to be
     transmitted before reloading the holding register */
  PSW(0x05, UARTDR);
  PI(200);
  PI(200);
  PI(132);
  PSW(0x06, UARTDR);

  /* Poll the Rx Fifo empty bit to receive the first character */
  PO(0 , UART_RXFE, UARTFR , (byte_cycles*2), fifodis1);
  PSR(0x05, 0xFFF, UARTDR, fifodis2);

  /* Poll the Rx Fifo empty bit to receive the second character */
  PO(0 , UART_RXFE, UARTFR , (byte_cycles*2), fifodis1);
  PSR(0x06, 0xFFF, UARTDR, fifodis2);
  
}
