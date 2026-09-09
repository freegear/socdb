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
--  File Name              : Uart_IndepTXRXTest.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function IndependentTXRXTests which is called in
   the main file Uart.c
/******************************************************************************/
   
/******************************************************************************/
/*************************** IndependentTXRXTests ******************************/
/******************************************************************************/

void IndependentTXRXTests(unsigned int divisor,enum op_mode mode)
{
  /*
    Summary:IndependentTXRXTest
    ===========================
 
    The purpose of these tests is to check the independent enabling and disabling
    of the Uart Transmitter and Receiver.  
    A configuration of different divisor value, word length 5, no parity 
    and no extra stop bit has been selected for this test. The FIFOs are 
    enabled for this test. 
  
  */
  
#define WORDS 20
  int hword = 0x10;
  int wlength = 5;
  int buffer[WORDS];
  int i,j,k,tx_ctr, rx_ctr;
  int32 some_cycles = 10;
  int32 bit_cycles, byte_cycles;
  unsigned long bit_width;
  int cword;
  int expected_value;
  int reg_val;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  C("Independent TX Test");

  if (mode == NORMAL_MODE)
    cword = 0x101;
  else if (mode == IRDA_MODE)
    cword = 0x103;
  else if (mode == IRDA_LP_MODE)
    cword = 0x107;
 
    /* Enable the uart and the independent TX (ie RX disabled) and trickbox */
  PSW(cword, UTCR);
  PSW(cword, UARTCR_new);
     
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfrtx1);

  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PSW(reg_val, UTDR);
      PI(0x02);
    }
     
  /* Then wait for UBUSY to go low */
  PO(0x10, UART_RXFE | UART_UBUSY, UARTFR, wait_factor * 2 *byte_cycles * i,uartfrtx2);
        
  if(i >= UARTFIFO_SIZE)
    PSR(UART_TXFE | UART_RXFE,UARTFR_MASK,UARTFR,uartfrtx3);
  else
    PSR(UART_UBUSY | UART_RXFE,UARTFR_MASK,UARTFR,uartfrtx4);
      
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val & masks[wlength],0xff,UTDR,uarttxdr);
    }

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK,UARTFR,utfrtx5);

    /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);

    
  C("Independent RX Test");

  if (mode == NORMAL_MODE)
    cword = 0x201;
  else if (mode == IRDA_MODE)
    cword = 0x203;
  else if (mode == IRDA_LP_MODE)
    cword = 0x207;
 
    /* Enable the uart and the independent RX (ie TX disabled) and trickbox */
  PSW(cword, UTCR);
  PSW(cword, UARTCR_new);
     
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfrrx1);

  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PSW(reg_val, UTDR);
      PI(0x02);
    }
     
  PO(0, UTTXBUSY, UTFR, 2 *byte_cycles * i,pollloop);
  Idle(2 * byte_cycles);
     
  if(i == 0)
    PSR(UART_TXFE,UARTFR_MASK,UARTFR,uartfrrx2);
  else if(i >= 15)
    PSR(UART_UBUSY | UART_TXFF | UART_RXFF,UARTFR_MASK,UARTFR,uartfrrx3a);
  else
    PSR(UART_UBUSY,UARTFR_MASK,UARTFR,uartfrrx4);
      
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val & masks[wlength],0xfff,UARTDR,uartrxdr);
    }

  PSR(UTRXFIFO_EMPTY,0x01,UTFR,utfrrxen);
     
  /* Empty the Uart TX fifo and then read out data from Trickbox Rx fifo */
    
  if(mode == NORMAL_MODE)
    PSW(0x101, UARTCR_new);
  else if(mode == IRDA_MODE)
    PSW(0x103, UARTCR_new);
  else if(mode == IRDA_LP_MODE)
    PSW(0x107, UARTCR_new);

  PO(0x10, UART_RXFE | UART_UBUSY, UARTFR, wait_factor * 2 *byte_cycles * i,uartfrtx2);

  PO(0, UART_UBUSY, UARTFR, byte_cycles*16,uartfrrx3);

  PO(0, UTRXBUSY, UTFR, byte_cycles*16,uartfrrx7);
  
  for(i=0; i<16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val & masks[wlength],0xff,UTDR,utfrrx8);
      PI(2);
    }

  PSR(UTRXFIFO_EMPTY,0x01,UTFR,utfrrxen2);
    
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfrrx5);
     
  PSW(0, UTCR);
  PSW(0, UARTCR_new);    
}
