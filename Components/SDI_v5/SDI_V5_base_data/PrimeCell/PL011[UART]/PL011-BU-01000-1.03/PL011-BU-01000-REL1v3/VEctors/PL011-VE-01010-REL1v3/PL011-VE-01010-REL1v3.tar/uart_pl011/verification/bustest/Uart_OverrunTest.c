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
--  File Name              : Uart_OverrunTest.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function OverrunTests which is called in
   the main file Uart.c
/******************************************************************************/


/******************************************************************************/
/***************************** OverrunTests ***********************************/
/******************************************************************************/

void OverrunTests(unsigned int  divisor, enum op_mode mode)
{
  /* 
     Summary: Overrun Error Tests
     ============================

     o   Fifo Disabled Test
     In this case two bytes are transmitted to UART from the TrickBox.
     The data is then read out followed by the status register. It should 
     return an error status with the overrun bit is set. The data byte
     value should be the first data byte transmitted.

     o   Fifo Enabled Tests
     In this case 17 bytes are transmitted to UART from the trickbox
     Status register must contain the error status as above. The first 
     16 bytes should have been recieved error free. The 17th byte will not
     get written into the Rx Fifo at all.

     The overrun interrupt is also tested.

  */ 

  int i, wlength;
  int hword = 0x00, cword = 0x00;
  int32 byte_cycles,bit_cycles;
  unsigned long bit_width;
  int expected_value;

  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  C(" Overrun Test - Fifo Disabled ");

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;

  /* Disable the uart and the trick box,clear any interrupt that are already set, and clear any error status bits that are set */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  PSW(0x7ff, UARTICR);
  PSW(0x00,UARTECR);

  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword,UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword,UTLCR_H);
  
  P_IDLE(0x10);
  /* Enable the trick box and the uart, and the Overrun error interrupt */
  PSW(cword, UTCR);
  PSW(cword, UARTCR_new);
  PSW(0x400, UARTIMSC);
  
  /* Write the 1st word to the Trick box to be transmitted */
  PSW(0x11,UTDR);
  PI(0x4);

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_d);

  PO(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR, byte_cycles,poll11);
  
  /* check rxfifo data and make sure that there is no overrun  */

  expected_value = 0 | (0x11 & masks[wlength]); 
  PSR(expected_value, 0x8ff, UARTDR,dr1st);
  

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr12);

  /* Write the 2nd word to the Trick box to be transmitted */
  PSW(0x22,UTDR);

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13);

  PO(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR, byte_cycles,poll12);

  /* Write the 3rd word to the Trick box to be transmitted */
  PSW(0x33,UTDR);
  P_IDLE(0x10);
  PO(0, UTTXBUSY, UTFR, byte_cycles,fifo11);


  PSR(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,uartfr14);

  /* check rxfifo data and that overrun flag has not been set  */
  expected_value = (0x00 << 8) | (0x22 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,dr2nd);

  /* Write the 4th word to the Trick box to be transmitted -
     this will cause the overrun to be copied into the FIFO */
  PSW(0x44,UTDR);
  P_IDLE(0x10);
  PO(0, UTTXBUSY, UTFR, byte_cycles,fifo11);

  PSR(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,uartfr14);

  /* check rxfifo data and that overrun flag has been set  */
  expected_value = (0x08 << 8) | (0x44 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,dr4th);

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr15);

  /* Check that the Overrun Error Interrupt has also been set */
  PSR(0x400, UARTRIS_MASK, UARTRIS,oeint1);
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint2);

  /* Disable the interrupt to check that the masking of it works */
  PSW(0x00, UARTIMSC);
  PI(2);
  PSR(0x400, UARTRIS_MASK, UARTRIS,oeint3);
  PSR(0x00, UARTMIS_MASK, UARTMIS,oeint4);

  /* Enable Interrupt and check it is still set */
  PSW(0x400, UARTIMSC);
  PI(2);
  PSR(0x400, UARTRIS_MASK, UARTRIS,oeint5);
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint6);

  /* Clear overrun flag */
  PSW(0x00,UARTECR);  

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr16);

  /* Overrun flag should have been cleared */
  PSR(0x00, 0x08, UARTRSR,rsrend);  

  /* Check that Interrupt error wasn't cleared */
  PSR(0x400, UARTRIS_MASK, UARTRIS,oeint7);
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint8);

  /* Check that writing a '0' to the interrupt clear register doesn't clear
     the interrupt */
  PSW(0x00, UARTICR);
  PI(2);
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint9);
  
  /* Write a '1' to the interrupt clear register to clear the interrupt */
  PSW(0x400, UARTICR);
  PI(2);
  PSR(0x00, UARTRIS_MASK, UARTRIS,oeint10);
  PSR(0x00, UARTMIS_MASK, UARTMIS,oeint11);
  
  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr17);

  C(" Overrun Test - Fifo Enabled ");

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);

  /* Enable the Fifos */
  hword = hword | 0x10; 

  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword,UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword,UTLCR_H);

  /* Enable the trick box and the uart */
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);

  /* Write the 1st 16 words to the Trick box to be transmitted */
  for(i=0; i<16; i++)
    {
      PSW(i,UTDR);
    }

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr21);

  PO(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR, byte_cycles * 16,poll21);

  /* Write 1 extra word(17th) to the Trick box to be transmitted */
  PSW(0x22,UTDR);
  P_IDLE(0x10);

  PO(0x400, UARTMIS_MASK, UARTMIS,byte_cycles,oeint12);
  
  PSR(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,uartfr22);

  i = 0;
  
  /* check rxfifo data and that overrun flag has not been set*/
  expected_value = 0 | (i & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,dr17th);
  i++;

  expected_value = 0 | (i & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,dr17ath);
  i++;

  /* Check that the Overrun error Interrupt has been set (the overrun
     error and interrupt is set as soon as there is another write to
     the already full fifo, this error does not appear in the fifo until
     the next successful write to it */
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint12);
  PI(2);

  /* Clear interrupt so that it can be set again */
     
   /* write 18th word */
  PSW(0x88,UTDR);
  PI(0x10);

  PO(0,UTTXBUSY , UTFR, byte_cycles,poll22);

  /* write 19th word */
  PSW(0x99,UTDR);
  PI(0x10);

  PO(0,UTTXBUSY , UTFR, byte_cycles,poll19th);

  /* Check interrupt is set */

  expected_value = 0 | (i & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,dr19th);
  i++;

  for(i = 3; i<16; i++)
    {
      expected_value =  0 | (i & masks[wlength]);
      PSR(expected_value, 0x8ff, UARTDR,drloop1);

      if (i < 15)
	{
	  PSR(UART_TXFE , UARTFR_MASK, UARTFR,uartfr24);
	}
    }
  
  i = 0;

  expected_value = (0x08 << 8) | (0x88 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,drflag);
  i++;

  /* Check that interrupt is set */
  
  /* error has cleared */
  expected_value = (0x00 << 8) | (0x99 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,drflag2);

  /* Check interrupt is still set even when the error on the new data is cleared */
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint13);
  
  /* Clear overrun flag */
  PSW(0x00, UARTECR);  
  
  /* Overrun flag should have been cleared */
  PSR(0x00, 0x08, UARTRSR,rsrend);

  /* Check interrupt is still set even when the error is cleared in status reg */
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint14);

  /* Clear the interrupt */
  PSW(0x400, UARTICR);
  PI(2);
  PSR(0x00, UARTMIS_MASK, UARTMIS,oeint15);
  

  for(i=0; i<16; i++)
    {
      PSW(i,UTDR);
    }
    
  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13);
  
  PO(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR, byte_cycles * 16,poll22);

  /* Write word to cause overrun */
  PSW(0x55,UTDR);
  PI(0x10);

  PO(0x400, UARTMIS_MASK, UARTMIS,byte_cycles,oeint15);  

  /* Check interrupt is set */
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint15);  

  /* Read word out to make space in the fifo */
  expected_value = 0 | (0x00 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,drrd1);

  /* clear interrupt */
  PSW(0x400, UARTICR);

  /* write word into fifo which will have the overrun error bit set */
  PSW(0x77,UTDR);
    
 P_IDLE(byte_cycles);    


  /* write word to cause 2nd overun*/
  PSW(0x44,UTDR);
   
 P_IDLE(byte_cycles);    

  /* Interrupt will not be set as the error bit is still set ie. there has not
     been a write to the error clear register */
  PSR(0x00, UARTMIS_MASK, UARTMIS,oeint16);

  /* Clear the error bit */
  PSW(0x00, UARTECR);

  /* Set interrupt again */
  
  /* read word out to make space in the fifo */
  expected_value = 0 | (0x01 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,drrd2);

    /* write word into fifo which will have error bit set */ 
  PSW(0x99,UTDR);
    
 P_IDLE(byte_cycles);
 
  /* write to cause 3rd overrun*/ 
  PSW(0x33,UTDR);
  PI(0x10);
    
  
  PO(0x400, UARTMIS_MASK, UARTMIS,byte_cycles,oeint18);  

  /* check interrupt is set */
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint18);  
  

  /* read word out to make space in the fifo */
  expected_value = 0 | (0x02 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,drrd3);

  /* Clear error Bit */
  PSW(0x00, UARTECR);

  /* write word which will have overrun error set*/ 
  PSW(0x22,UTDR);
  PI(0x10);

 P_IDLE(byte_cycles);
  /* Cause another error to check that a 2nd interrupt won't clear the 1st */
  PSW(0x44,UTDR);
    
  P_IDLE(byte_cycles);
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint19);  
  
  /* read word out to make space in the fifo */
  expected_value = 0 | (0x03 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,drrd4);

  /* write word which will have overrun error set*/ 
  PSW(0x55,UTDR);

  P_IDLE(byte_cycles);
  /* Read out the data without overrun errors */
  for(i=4; i<16;i++)
    {
      expected_value = 0 | (i & masks[wlength]);
      PSR(expected_value, 0x8ff, UARTDR,lastovrd1);
    }

  /* Check overrun errors have been set */
  expected_value = (0x08 << 8) | (0x77 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,lastovrd2);

  expected_value = (0x08 << 8) | (0x99 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,lastovrd3);
    
  expected_value = (0x08 << 8) | (0x22 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,lastovrd4);

  expected_value = (0x08 << 8) | (0x55 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,lastovrd5);

  /* Check that interrupt is still set */
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint17);

  /* Clear interrupt */
  PSW(0x400, UARTICR);
  PSW(0x00, UARTECR);
  PI(2);
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,oeint20);
  PSR(0x00, 0x08, UARTRSR,rsrend);
 
  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13);
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTTXFIFO_EMPTY | UTRXFIFO_EMPTY , UTFR,utfr14);
}
