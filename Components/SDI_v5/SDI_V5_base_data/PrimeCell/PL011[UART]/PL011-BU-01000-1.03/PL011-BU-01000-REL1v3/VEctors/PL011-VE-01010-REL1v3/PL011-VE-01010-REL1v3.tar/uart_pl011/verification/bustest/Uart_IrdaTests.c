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
--  File Name              : Uart_IrdaTests.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the functions  TestWithConfiguration_IrDa
   and  IrdaTests which are called in the main file Uart.c
/******************************************************************************/



/******************************************************************************/
/************************ TestWithConfiguration_Irda ***************************/
/******************************************************************************/

void TestWithConfiguration_Irda(unsigned int divisor, int hword,int lpr_width, 
				enum op_mode mode, int shift_en,int from,int tobit,int shift_factor)
{
  /* 
     Summary: TestWithConfiguration_Irda
     ===================================

     This function is same as TestWithConfiguration except that it is used to 
     program the trickbox in the IrDA mode only with individual bits are being 
     shifted by factor from 0.5 to 1.5 baud clocks. For this, there are four 
     parameters passed by the calling function. These are:
     o   shift_en : enable the Bit Shift Mode of the trickbox. 
     o   from     : indicates the bit number from where shifting is allowed.
     valid no. are from 0 to 7.
     o   tobit    : indicates the bit number till the shifting is allowed.
     valid no. are from 0 to 7.
     o   shift_factor: Valid from 0 to 3.
     0: no shifting
     1: 0.5 baud cycle shifting
     2: 1 baud cycle shifting
     3: 1.5 baud cycle shifting
  
  */ 
  
  int i = 0,j, reg_val;
  int wlength;
  int32 bit_cycles, byte_cycles;
  int32 some_cycles = 10;
  int cword;
  unsigned long bit_width;
  int data_val;
  int expected_value;
 
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
  
  if (mode == IRDA_LP_MODE)
    cword = 0x307;
  else 
    cword = 0x303;

 
  data_val = (from << 5) + (tobit << 2) + shift_factor;
 
  C("Fifo Disabled Tests - Rx");
 
  PSW(0, UTCR);
  PSW(0, UARTCR_new);

  PSW(data_val,UTBITSFT_DATA);
  
  /* Configure the uart and Trick Box */ 
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
 
  /* with Fifo Enable */ 
  if(shift_en) hword|=0x80;
  hword |= UT_FIFO_ENABLE;
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
 
  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr21);
 
  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UTDR);
      PI(0x03);
    }
 
  PSW(cword, UARTCR_new);
  PI(4);
  cword |= (lpr_width << 3);
  PSW(cword, UTCR);

  if(lpr_width != 5)
    { 
      for(i=0; i<16; i++)
	{
	  PO(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,byte_cycles,uartfr22);
	  reg_val = i | (i << 4);

	  expected_value = 0 | (reg_val & masks[wlength]);
	  PSR(expected_value,0xfff,UARTDR,uartdrlast);
	}
    } 
  else 
    P_IDLE(32 *byte_cycles); 

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfrend);
   
  /* To complete any unfinished transmissions in the Trick Box */ 
  PO(0x00, UTTXBUSY, UTFR, bit_cycles/2,polllast);
 
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);
}



/******************************************************************************/
/***************************** IrdaTests **************************************/
/******************************************************************************/

void IrdaTests(void)
{
  /* 
     Summary: IrDA Tests
     ===================

     These tests are identical to the FIFO enabled and FIFO disabled tests of
     the Normal Mode except that the Simultaneous transmission and reception 
     test cases were omitted because only Half Duplex transmission is allowed.
  
  */

  
  int hword; 
  unsigned int divisor;
  enum op_mode mode;

  mode = IRDA_MODE;


  C("Irda Tests : Word Length 8, No Parity, No Extra Stop Bit");
  hword = 0x60; 
  divisor = 0x03;
  TestWithConfiguration(divisor,hword,mode);

  C("Irda Tests : Word Length 6, Odd Parity, No Extra Stop Bit");
  hword = 0x22;
  divisor = 0x02;
  TestWithConfiguration(divisor,hword,mode);

  C("Irda Tests : Word Length 7, Even Parity, No Extra Stop Bit");
  hword = 0x46;
  divisor = 0x04;
  TestWithConfiguration(divisor,hword,mode);

  C("Irda Tests : Word Length 8, No Parity,  Extra Stop Bit");
  hword = 0x68;
  divisor = 0x01;
  TestWithConfiguration(divisor,hword,mode);

  C("Irda Tests : Word Length 5, Odd Parity,  Extra Stop Bit");
  hword = 0x0a;
  divisor = 0x02;
  TestWithConfiguration(divisor,hword,mode);

  mode = IRDA_LP_MODE;
  C("Irda LOW POWER Tests: Word Length 5, Odd Parity,  Extra Stop Bit");
  hword = 0x0a;
  divisor = 0x02;
  TestWithConfiguration(divisor,hword,mode);


  C("Irda LOW POWER : Word Length 6, Odd Parity, No Extra Stop Bit");
  hword = 0x22;
  divisor = 0x03;
  TestWithConfiguration(divisor,hword,mode);

  C("Irda LOW POWER : Word Length 7, Even Parity, No Extra Stop Bit");
  hword = 0x46;
  divisor = 0x04;
  TestWithConfiguration(divisor,hword,mode);

  C("Irda LOW POWER : Word Length 8, No Parity,  Extra Stop Bit");
  hword = 0x68;
  divisor = 0x01;
  TestWithConfiguration(divisor,hword,mode);

  C("Irda LOW POWER : Word Length 5, Odd Parity,  Extra Stop Bit");
  hword = 0x0a;
  divisor = 0x03;
  TestWithConfiguration(divisor,hword,mode);

  /* Irda Bit Jittered Tests */
  
  C("Irda Tests : Word Length 8, No Parity, No Extra Stop Bit");
  hword = 0x60;
  divisor = 0x03;
  TestWithConfiguration_Irda(divisor,hword,0, IRDA_MODE,1,0,7,1);

  C("Irda low power Tests : Word Length 8, No Parity, No Extra Stop Bit");
  hword = 0x60;
  divisor = 0x03;
  TestWithConfiguration_Irda(divisor,hword,0, IRDA_LP_MODE,1,0,7,1);

  C("Irda Tests : Word Length 8, even Parity,  Extra Stop Bit");
  PSW(0x09,UTBITSFT_DATA_2);
  hword = 0x6e;
  divisor = 0x03;
  TestWithConfiguration_Irda(divisor,hword,0, IRDA_MODE,1,0,3,1);
 
  C("Irda low power Tests : Word Length 8, even Parity,  Extra Stop Bit");
  hword = 0x6e;
  divisor = 0x03;
  TestWithConfiguration_Irda(divisor,hword,0, IRDA_LP_MODE,1,0,3,1);

  /* Irda Pulse Rejection Test */
  C("Irda Tests : Word Length 8, even Parity,  Extra Stop Bit, Pulse Width 1");
  PSW(0x00, UTBITSFT_DATA_2);
  hword = 0x6e;
  divisor = 0x01;
  TestWithConfiguration_Irda(divisor,hword,5, IRDA_MODE,0,0,0,0);

}
