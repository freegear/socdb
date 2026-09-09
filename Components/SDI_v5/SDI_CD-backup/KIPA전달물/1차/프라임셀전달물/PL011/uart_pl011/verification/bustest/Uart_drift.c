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
--  File Name              : Uart_drift.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/
/* ------------------------------------------------------------ */

void DriftTest(unsigned int divisor,int hword,enum op_mode mode)
{
  /*
    Summary: Drift Test
    ===================
    This test is conducted in loopback mode. 16 words are written to the Uart, and
    these are transmitted. The Tx and Rx interrupts are set at 1/8 and 7/8 respectively.
    16 more words are written to the Uart and then the Uart waits for the Tx interrupts
    indicating 14 empty spaces. The Rx interrupt is waited for indicating 14 words can be
    read out.  14 words are written in and read out of the Uart. The interrupts are again
    waited for and more data written. This continues until 58 words have been transmitted
    and received.  Correct reception (ie no drift) is checked for.
 
   
  */
  

#define MAX_WORDS 200
  int wlength;
  int buffer[MAX_WORDS];
  int i,j,k,tx_ctr, rx_ctr;
  int32 some_cycles = 10;
  int32 bit_cycles, byte_cycles;
  unsigned long bit_width;
  int cword;
  int expected_value;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  if (mode == NORMAL_MODE)
    cword = 0x381;
  else if (mode == IRDA_MODE)
    {
      cword = 0x383;
      PSW(0x04, UARTTCR);
    }
  else if (mode == IRDA_LP_MODE)
    {
      cword = 0x387;
      PSW(0x04,UARTTCR);
    }
  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  PSW(0x7ff, UARTICR);
  PSW(0x00, UARTECR);
  
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
  
 PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_b);

 PSW(cword, UARTCR_new);
 PSW(cword, UTCR);

 for (i=0; i<16; i++)
   {
     PSW(i,UARTDR);
   }

  PO(UART_TXFE|UART_RXFF,UART_TXFE|UART_RXFF,UARTFR,17*byte_cycles,wait);
  PI(2);

 for (i=0; i<16; i++)
   {
     PSR(i,0xFFF,UARTDR,readDrift);
   }

 PSR(0x00,UARTRSR_MASK, UARTRSR,status);
 PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_b);

  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  PSW(0x7ff, UARTICR);

  /* Do more than 16 now */
  for (i=0; i<16; i++)
   {
     PSW(i,UARTDR);
   }
 
  /* Program interrupts to go off at 1/8 for TX and 7/8 for RX */
  PSW(UART_RXF7EIGHT|UART_TXFEIGHT,UARTIFLS);
  PSW(0x030, UARTIMSC); /* Enable Interrupts */

  PI(2);
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);

  /* Wait for TX Interrupt so more words can be written because there
     will be 14 empty spaces available - clear interrupts */
  PO(0x20,UARTMIS_MASK,UARTMIS,17*byte_cycles,TXIntWait);
  PSW(0x20,UARTICR);
  
  /* Wait for RX Interrupt so we know there will be at least 14 words
     available to be read out  - clear interrupts */
  PO(0x10,UARTMIS_MASK,UARTMIS,17*byte_cycles,RXIntWait);
  PSW(0x10,UARTICR);
  
  /* Write More Words and Read received Words as well */
  for (i=0; i<14; i++)
   {
     PSW(i,UARTDR);
     PSR(i,0xFFF,UARTDR,readDriftOrig16_1);
   }

  /* wait for RX Interrupt to go off again so we know there will be at
     least 14 empty spaces - clear interrupts */
  PO(0x20,UARTMIS_MASK,UARTMIS,17*byte_cycles,TXIntWait);
  PSW(0x20,UARTICR);
  
 /* Wait for RX Interrupt again  so we know there will be at least 14 words
     available to be read out  - clear interrupts */  
  PO(0x10,UARTMIS_MASK,UARTMIS,17*byte_cycles,RXIntWait);
  PSW(0x10,UARTICR);
  
  /* Write More Words */
  for (i=0; i<14; i++)
   {
     PSW(i,UARTDR);
   }

  /* Read out 14 words - 2 from the previous 14 */
  for (i=14; i<16; i++)
    {
      PSR(i,0xFFF,UARTDR,readDriftOrig16_2);
    }
  
  for (i=0; i<12; i++)
    {
      PSR(i,0xFFF,UARTDR,readDriftOrig16_2);
    }


  /* Wait for TX Interrupt so more words can be written because there
     will be 14 empty spaces available - clear interrupts */  
  PO(0x20,UARTMIS_MASK,UARTMIS,17*byte_cycles,TXIntWait);
  PSW(0x20,UARTICR);
  
 /* Wait for RX Interrupt again  so we know there will be at least 14 words
     available to be read out  - clear interrupts */  
  PO(0x10,UARTMIS_MASK,UARTMIS,17*byte_cycles,RXIntWait);
  PSW(0x10,UARTICR);
  
  /* Write More Words */
  for (i=0; i<14; i++)
   {
     PSW(i,UARTDR);
   }
  
  /* Read out 14 words - 2 from the previous 14 */
  for (i=12; i<14; i++)
    {
      PSR(i,0xFFF,UARTDR,readDriftOrig16_2);
    }
  
  for (i=0; i<12; i++)
    {
      PSR(i,0xFFF,UARTDR,readDriftOrig16_2);
    }

  
  /* Now wait until transmission complete */
  PO(UART_TXFE|UART_RXFF,UART_TXFE|UART_RXFF,UARTFR,17*byte_cycles,wait);
  PI(2);
  
  for (i=12; i<14; i++)
    {
      PSR(i,0xFFF,UARTDR,readDriftOrig16_2);
    }
  
  /* Now read out the other 14 */
  for (i=0; i<14; i++)
   {
     PSR(i,0xFFF,UARTDR,readDriftNew14);
   }
  
  PSR(0x00,UARTRSR_MASK, UARTRSR,status);
  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_b);

  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  PSW(0x7ff, UARTICR);
  PSW(0x00, UARTTCR);

}
