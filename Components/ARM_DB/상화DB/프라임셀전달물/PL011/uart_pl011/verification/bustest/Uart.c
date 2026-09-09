/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999-2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : Uart.c.rca
--  File Revision          : 1.21
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------


/******************************************************************************/
/* Purpose : This file verifies Uart functionality in the free-running mode.   */
/*           The tb_Uart.vhd testbench needs to be used to run this            */
/*           vector set.                                                      */
/******************************************************************************/

/******************************************************************************/
/***   Purpose : This C code file is used to generate BusTalk vectors.      ***/
/***             BusTalk vectors are applied to the AMBA APB bus.           ***/      
/***                                                                        ***/
/***   Files required for compilation:                                      ***/
/***     makefile, busheader.h, busmacros.h, busmacros.c,                   ***/
/***     config.h, addargs_script,                                          ***/
/***     Uart.h, Uart.c and:
/***
/***     Uart_BaudTests.c                                                   ***/
/***     Uart_BoundaryTests.c                                               ***/
/***     Uart_BreakTest.c                                                   ***/
/***     Uart_DMATests.c                                                    ***/
/***     Uart_DisableTests.c                                                ***/
/***     Uart_FCTests.c                                                     ***/
/***     Uart_FifoDisabledTests.c                                           ***/
/***     Uart_FifoEnabledTests.c                                            ***/
/***     Uart_FifoTests.c                                                   ***/
/***     Uart_FramingTests.c                                                ***/
/***     Uart_HalfDuplexTest.c                                              ***/
/***     Uart_IndepTXRX.c                                                   ***/
/***     Uart_InterruptTests.c                                              ***/
/***     Uart_IrdaTests.c                                                   ***/
/***     Uart_JitterTests.c                                                 ***/
/***     Uart_ModemTests.c                                                  ***/
/***     Uart_OverrunTest.c                                                 ***/
/***     Uart_ParityTests.c                                                 ***/
/***     Uart_RTISTests.c                                                   ***/
/***     Uart_Reg_Tests.c                                                   ***/
/***     Uart_loopbackTest.c                                                ***/
/*** 
/*** 
/*** 
/***   Usage: make <testname> e.g. make Uart                                ***/
/***                                                                        ***/
/***  To create .bif formatted vectors from the BusTalk code (default)      ***/
/***     make <testname> e.g. make Uart                                     ***/ 
/***   This will create testname.bif in the ./invec directory               ***/ 
                                                                  

/******************************************************************************/
/*** For more information on the Uart, please refer to PL011 AMBA UART      ***/
/*** Block Specification                                                    ***/
/******************************************************************************/

/******************************************************************************/
/*** All include files are in include.h and the makefile                    ***/
/******************************************************************************/

/******************************************************************************/
/***************** System Clock Defines ***************************************/
/******************************************************************************/


#define UARTCLK_PERIOD     10 
#define PCLK_PERIOD        10


/******************************************************************************/
/****** Function declarations for functions used in more than one test ********/
/******************************************************************************/

void TestWithConfiguration(unsigned int divisor, int hword, enum op_mode mode);
void ConfigureUbrlcr(unsigned int divisor, int hword, unsigned hword_address);
void ConfigureUbrlcrTr(unsigned int divisor, int hword, unsigned hword_address);
void Idle(unsigned long time);

unsigned int wait_factor;
unsigned int divisor;
unsigned int hword;


/******************************************************************************/
/************************ TestWithConfiguration *******************************/
/******************************************************************************/

void TestWithConfiguration(unsigned int divisor, int hword, enum op_mode mode)
{
  /*
    Summary: TestWithConfiguration
    ==============================
 
    This Function is called by function FifoDisabledTests. It does following 
    tests for different baud rate, word length, parity type and stop bits,
    passed by the calling function.
   
    o   Transmission Tests
    In this test, a byte is written to the data register of the UART.
    And after complete transmission, this byte is read from the TrickBox
    and checked for error free reception.
    o   Reception Tests
    In this test, a byte is written to the data register of the TrickBox.
    And after complete transmission, this byte is read from the UART. 
    and checked for error free reception.

    o   Simultaneous Tests
    This is similar to the transmit and receive tests except that they 
    are conducted simultaneously. 
         
   */

  int i = 0,j, reg_val;
  int wlength;
  int32 bit_cycles, byte_cycles;
  int32 some_cycles = 10;
  int cword = 0x00;
  unsigned long bit_width;
  int expected_value;
  int wait_time;
  
  bit_width = 16 * (divisor) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;
  

  C("Fifo Disabled Tests - Tx");
 
  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
 
  /* Configure the Uart */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  
  /* Configure the TrickBox with fifos enabled */
  hword |= UT_FIFO_ENABLE;
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H); 

  /* Check Uart flags before writing anything to it */
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_a);
  
  PI(0x02); 
  /* Enable the trick box and the uart */
  PSW(cword, UTCR);
  PI(0x02); 
  PI(0x02); 
  PSW(cword, UARTCR_new); 

  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x02);
    
      /* wait long enough for the byte to be shifted to holding register */
      PO(UART_TXFE | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR,4 * byte_cycles,uartfr12);
    }

  PI(0x02);
  
  /* wait till the last byte has been received by trickbox */
  PO(UTRXFIFO_FULL, UTRXFIFO_FULL, UTFR,wait_factor * byte_cycles,fifoloop); 
  PI(0x02);
  
  /* ubusy should go low after a bit period */
  PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR, 2 * bit_cycles,uartfr13);

  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val & masks[wlength],0xff,UTDR,utdrlast);
      PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast);
    }

  C("Fifo Disabled Tests - Rx");

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
 
  /* Check Uart flags before writing anything to it */
  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr21);

  /* Write some data bytes to the Tx fifo of the Trickbox */
  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UTDR);
    }

  /* Enable the trick box and the UART */
  PSW(cword, UARTCR_new); 
  PI(0x02); 
  PI(0x03);
  PSW(cword, UTCR);
  
  /* Now read each byte from the Rx fifo as it arrives */
  for(i=0; i<16; i++)
    {
      wait_time = (wait_factor+1) * byte_cycles;
      PO(UART_TXFE|UART_RXFF,UARTFR_MASK,UARTFR,wait_time,uartfr22);
      reg_val = i | (i << 4);
      expected_value = 0 |(reg_val & masks[wlength]);
      PSR(expected_value,0xfff,UARTDR,uartdrlasta);   
    }

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfrend);

  /* To complete any unfinished transmissions in the Trick Box */
  PO(0x00, UTTXBUSY, UTFR, wait_factor * bit_cycles/2,polllast);

  if (mode == NORMAL_MODE)
    {
      C("Fifo Disabled Tests - Tx & Rx");
      /* Disable the uart and the trick box */
      PSW(0, UTCR);
      PSW(0, UARTCR_new);
 
      /* Check Uart flags before writing anything to it */
      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr31);

      /* Write Some data to the uart and trick box data registers */
      i=0;
      PSW(i , UARTDR);
      PSW(i , UTDR);
      PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr32);

      /* Enable the trick box and the uart */
      PSW(cword, UTCR);
      PSW(cword, UARTCR_new);
    
      PO(UART_TXFE | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr33);

      for(i = i+1; i < 16; i++)
	{
	  reg_val = i | (i << 4);
	  PSW(reg_val, UARTDR);
	  PSW(reg_val, UTDR);

	  /* Wait till 1 byte is transmitted */ 
	  PI(0x5);
	  PO(UART_TXFE | UART_RXFF | UART_UBUSY, UARTFR_MASK, UARTFR, 4 * byte_cycles,uartfr35);

	  /* Read the data */ 
	  reg_val = (i-1) | ((i-1) << 4);

	  expected_value = 0 | (reg_val & masks[wlength]);
	  PSR(expected_value,0xfff,UARTDR,uartdrloop);
	}

      /* wait till uart finishes transmitting */
      PO(0x00, UART_UBUSY, UARTFR, wait_factor * byte_cycles,uartfrlast);
      P_IDLE(wait_factor * 2);
    
      /* wait till the last byte has been received by trickbox */
      PO(0x00, UTRXBUSY | UTTXBUSY, UTFR, wait_factor * byte_cycles,fifoloop);

      /* Read the data */
      i = 16;
      reg_val = (i-1) | ((i-1) << 4);

      expected_value = 0 | (reg_val & masks[wlength]);
      PSR(expected_value,0xfff,UARTDR,uartdrlast);
    
      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfrend);

      /* Now check all the data bytes in the Receive Fifo of the Trick Box */
      for(i=0; i<16; i++)
	{
	  reg_val = i | (i << 4);
	  PSR(reg_val & masks[wlength], 0xff, UTDR,utdrloop);
	  PSR(0x00, UTRSR_MASK, UTRSR, utrsrloop);
	}
    }
}



/******************************************************************************/
/*****************************  ConfigureUbrlcr *******************************/
/******************************************************************************/

void ConfigureUbrlcr(unsigned int divisor, int hword, unsigned hword_address)
{
  /* 
     Summary: ConfigureUbrlcr
     ========================
  
     This function is called by various function to configure the UART. 
     The values to be written, are passed as the argument to this
     function.
  */
 
  int word;
  int delay;

  word = divisor & 0xffff;
  delay = divisor + 7;

  PSW(word,hword_address - 8);
  PSW(hword, hword_address);
  Idle(delay);


  
}

/******************************************************************************/
/*****************************  ConfigureUbrlcrTr *****************************/
/******************************************************************************/

void ConfigureUbrlcrTr(unsigned int divisor, int hword, unsigned hword_address)
{
  /* 
     Summary: ConfigureUbrlcrTr
     ========================
  
     This function is called by various function to configure the  
     Trickbox. The values to be written, are passed as the argument to this
     function.

  */
  
  int lword,mword;
  int delay;

  lword = divisor & 0xff;
  mword = (divisor & 0xff00) >> 8;
  delay = divisor + 7;

  PSW(lword, hword_address + 8);
  PSW(mword, hword_address + 4);
  PSW(hword, hword_address);
  Idle(delay);
}

/******************************************************************************/
/********************************  Idle  **************************************/
/******************************************************************************/

void Idle(unsigned long time)
{
  /*
    Summary: Idle function
    ======================

    This is to create the delay of time, passed as the argument to this 
    function.

  */

  unsigned long i;

  if (time <= 2)
    {
      PI(0x02);
    }
  else
    {
      for(i=0; i< ((unsigned long)(time/2) - 1); i++)
	{
	  PI(0x02);
	}
      if ((unsigned long)time % 2)
	{
	  PI(0x03);
	}
      else
	{
	  PI(0x02);
	}
    }
}




/******************************************************************************/
/******************** Include all the Function files **************************/
/******************************************************************************/

#if defined(ALL_TESTS) || defined(REG_TESTS)
#	include "Uart_Reg_Tests.c"
#endif

#if defined(ALL_TESTS) || defined(FIFODISABLED_TESTS)
#	include "Uart_FifoDisabledTests.c"
#endif

#if defined(ALL_TESTS) || defined(FIFOENABLED_TESTS)
#	include "Uart_FifoEnabledTests.c"
#endif

#if defined(ALL_TESTS) || defined(INDEPTXRX_TESTS)
#	include "Uart_IndepTXRXTest.c"
#endif

#if defined(ALL_TESTS) || defined(OVERRUN_TESTS)
#	include "Uart_OverrunTest.c"
#endif

#if defined(ALL_TESTS) || defined(BAUD_TESTS)
#	include "Uart_BaudTests.c"
#endif

#if defined(ALL_TESTS) || defined(FRACBAUD_TESTS)
#	include "Uart_FracBaudTests.c"
#endif


#if defined(ALL_TESTS) || defined(MODEM_TESTS)
#	include "Uart_ModemTests.c"
#endif

#if defined(ALL_TESTS) || defined(PARITY_TESTS)
#	include "Uart_ParityTests.c"
#endif

#if defined(ALL_TESTS) || defined(FRAMING_TESTS)
#	include "Uart_FramingTests.c"
#endif

#if defined(ALL_TESTS) || defined(JITTER_TESTS)
#	include "Uart_JitterTests.c"
#endif

#if defined(ALL_TESTS) || defined(INTERRUPT_TESTS)
#	include "Uart_InterruptTests.c"
#endif

#if defined(ALL_TESTS) || defined(IRDA_TESTS)
#	include "Uart_IrdaTests.c"
#endif

#if defined(ALL_TESTS) || defined(BREAK_TESTS)
#	include "Uart_BreakTest.c"
#endif

#if defined(ALL_TESTS) || defined(RTIS_TESTS)
#	include "Uart_RTISTests.c"
#endif

#if defined(ALL_TESTS) || defined(DISABLE_TESTS)
#	include "Uart_DisableTests.c"
#endif

#if defined(ALL_TESTS) || defined(HALFDUPLEX_TESTS)
#	include "Uart_HalfDuplexTest.c"
#endif

#if defined(ALL_TESTS) || defined(LOOPBACK_TESTS)
#	include "Uart_loopbackTest.c"
#endif

#if defined(ALL_TESTS) || defined(FIFO_TESTS)
#	include "Uart_FifoTests.c"
#endif

#if defined(ALL_TESTS) || defined(DMA_TESTS)
#	include "Uart_DMATests.c"
#endif

#if defined(ALL_TESTS) || defined(FC_TESTS)
#	include "Uart_FCTests.c"
#endif

#if defined(ALL_TESTS) || defined(ILLEGALBAUD_TESTS)
#	include "Uart_IllegalBaud.c"
#endif


#if defined(ALL_TESTS) || defined(DRIFT_TESTS)
#	include "Uart_drift.c"
#endif


/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

int main()
{

  C("---------------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 1998-2000 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("---------------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Uart.c.rca",header);
  C("File Revision          : 1.21",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL011-REL1v3",header);
  C("---------------------------------------------------------------------------",header);

  /* Start of Compliance test program */

  TestStart();
 
  /* Reset the Uart and TrickBox */ 
  RES(LOW,0x1,0x2);
  PI(0x10);

  /* Writing the Clock Timings to the TrickBox */
  PSW(UARTCLK_PERIOD, UTCLKREG);
  
  if (PCLK_PERIOD > UARTCLK_PERIOD)
    wait_factor = (PCLK_PERIOD/UARTCLK_PERIOD); 
  else
    {
      if( UARTCLK_PERIOD > PCLK_PERIOD)
	wait_factor = (UARTCLK_PERIOD/PCLK_PERIOD) ;
      else
	wait_factor  = 1;
    }
  
  /* Setting The Synchronisation Bit and Asserting the nUARTRST Pin */
  if( PCLK_PERIOD == UARTCLK_PERIOD )
    {
      PSW(0x00,RSTMODE_REG);
      PSW(0x00,RSTMODE_REG);
      PSW(0x00,RSTMODE_REG);
      PSW(PCLKGEN, RSTMODE_REG); 
      PSW( PCLK_ENABLE , RSTMODE_REG); 
      PI(4);
      PSW( RSTMODE_ENABLE , RSTMODE_REG);
      PI(10);
      PSR(0x1, masks[5], RSTMODE_REG); 
    }
  else 
    {
      PSW( 0x00 , RSTMODE_REG); 
      PI(4);
      PSW(REFCLKGEN, RSTMODE_REG);
      PSW(0x08, RSTMODE_REG);
      PSW( RSTMODE_ENABLE , RSTMODE_REG);
      PI(10);
      PSR(0x1, masks[4], RSTMODE_REG); 
    }


  
#if defined(ALL_TESTS) || defined(REG_TESTS)
  C("RegisterTests");
  RegisterTests();
#endif

  


  /* Resetting the Uart and Asserting nUARTRST Pin  */
  
  RES(LOW,0x1,0x1);
  PI(0x02);
  PSW(0x08 , RSTMODE_REG);
  PSW(0x09, RSTMODE_REG);

  /* Writing the Clock Timings to the TrickBox */ 
  PSW(UARTCLK_PERIOD, UTCLKREG);

  /* Programming the Low Power Divisor Value */ 

  PSW(0x02, UARTILPR);
  PSW(0x02, UTILPR);


  /* Clear Interrupts */
  PSW(0x7ff, UARTICR);


#if defined(ALL_TESTS) || defined(LOOPBACK_TESTS)
  C("Loopback Tests");
  loopback_mode();
#endif

  
#if defined(ALL_TESTS) || defined(FIFODISABLED_TESTS)
  C("Fifo Disabled Tests");
  FifoDisabledTests();
#endif

  
#if defined(ALL_TESTS) || defined(FIFOENABLED_TESTS)
  C("Fifo Enabled  : NORMAL MODE");
  divisor = 0x07; 
  FifoEnabledTests(divisor,NORMAL_MODE);
 
  C("Fifo Enabled  : IRDA MODE"); 
  divisor = 0x01; 
  FifoEnabledTests(divisor,IRDA_MODE); 

  C("Fifo Enabled  : IRDA LP MODE"); 
  divisor = 0x01; 
  FifoEnabledTests(divisor,IRDA_LP_MODE);
#endif
  

#if defined(ALL_TESTS) || defined(INDEPTXRX_TESTS)
  C("Independent TX/RX  : NORMAL MODE"); 
  divisor = 0x02;  
  IndependentTXRXTests(divisor,NORMAL_MODE); 

  C("Independent TX/RX  : IRDA MODE");  
  divisor = 0x01;  
  IndependentTXRXTests(divisor,IRDA_MODE);  

  C("Independent TX/RX : IRDA LP MODE");  
  divisor = 0x01; 
  IndependentTXRXTests(divisor,IRDA_LP_MODE); 
#endif

  
#if defined(ALL_TESTS) || defined(DISABLE_TESTS)
  C("FifoUartDisable : NORMAL MODE"); 
  divisor = 0x03; 
  FifoUartDisableTest(divisor,NORMAL_MODE); 
  
  C("FifoUartDisable : IRDA MODE");
  divisor = 0x02; 
  FifoUartDisableTest(divisor,IRDA_MODE); 

  C("FifoUartDisable : IRDA LP MODE"); 
  divisor = 0x02; 
  FifoUartDisableTest(divisor,IRDA_LP_MODE);
#endif


#if defined(ALL_TESTS) || defined(INTERRUPT_TESTS)
  C("Interrupt Tests : NORMAL MODE");
  divisor = 0x01; 
  InterruptTests(divisor,NORMAL_MODE); 

  C("Interrupt Tests : IRDA MODE"); 
  divisor = 0x01; 
  InterruptTests(divisor,IRDA_MODE); 
 
  C("Interrupt Tests : IRDA LP MODE"); 
  divisor = 0x01;
  InterruptTests(divisor,IRDA_LP_MODE);
#endif


#if defined(ALL_TESTS) || defined(IRDA_TESTS)
  C("IrDa Tests");
  IrdaTests();
#endif


#if defined(ALL_TESTS) || defined(OVERRUN_TESTS)
  C("Overrun Test Normal Mode");
  divisor = 0x01;
  OverrunTests(divisor,NORMAL_MODE);

  C("Overrun Test IRDA Mode");
  divisor = 0x03;
  OverrunTests(divisor,IRDA_MODE);

  C("Overrun Test IRDA LOW POWER Mode");
  divisor = 0x01;
  OverrunTests(divisor,IRDA_LP_MODE);
#endif

  
#if defined(ALL_TESTS) || defined(BAUD_TESTS)
  C("Baud Tests Normal Mode"); 
  BaudTests(NORMAL_MODE); 

  C("Baud Tests IRDA Mode");  
  BaudTests(IRDA_MODE); 

  C("Baud Tests IRDA Low Power Mode");  
  BaudTests(IRDA_LP_MODE); 
#endif

#if defined(ALL_TESTS) || defined(FRACBAUD_TESTS)

  C("Fractional Baud Tests Normal Mode");
  FracBaudTests(NORMAL_MODE);
  
  C("Fractional Baud Tests loopback Normal Mode"); 
  FracBaudTests2(NORMAL_MODE);
  
  C("Fractional Baud Tests loopback IRDA Mode");  
  FracBaudTests2(IRDA_MODE); 

  C("/* Fractional Baud Tests loopback IRDA Low Power Mode");   
  FracBaudTests2(IRDA_LP_MODE);
  
#endif


#if defined(ALL_TESTS) || defined(MODEM_TESTS)
  C("Modem Tests NORMAL Mode");    
  divisor = 0x02;   
  TestModem(divisor,NORMAL_MODE);   
  
  C("Modem Tests IRDA Mode");   
  divisor = 0x01;   
  TestModem(divisor,IRDA_MODE);   

  C("Modem Tests IRDA LP Mode");  
  divisor = 0x03;  
  TestModem(divisor,IRDA_LP_MODE);  
#endif
  

#if defined(ALL_TESTS) || defined(PARITY_TESTS)
  C("Parity Error Test");
  divisor = 0x04;
  TestParityError(divisor, NORMAL_MODE);
 
  C("IRDA Parity Error Test");
  divisor = 0x08;
  TestParityError(divisor, IRDA_MODE);

  C("IRDA LP: Parity Error Test");
  divisor = 0x03;
  TestParityError(divisor, IRDA_LP_MODE);
  
  C("Stick Parity Test");
  divisor = 0x04;
  TestStickParity(divisor, NORMAL_MODE);
 

  
#endif
 

#if defined(ALL_TESTS) || defined(FRAMING_TESTS)
  C("Framing Error Test");
  divisor = 0x02;
  TestFramingError(divisor, NORMAL_MODE);

  C("IRDA Framing Error Test");
  divisor = 0x01;
  TestFramingError(divisor, IRDA_MODE);

  C("IRDA LOW POWER Framing Error Test");
  divisor = 0x02;
  TestFramingError(divisor, IRDA_LP_MODE);
#endif


#if defined(ALL_TESTS) || defined(JITTER_TESTS)
  C("NORMAL : Jitter"); 
  divisor = 0x02; 
  TestJitter(divisor,NORMAL_MODE); 
 
  C("IRDA : Jitter"); 
  divisor = 0x01; 
  TestJitter(divisor,IRDA_MODE); 
  
  C("IRDA LP: Jitter"); 
  divisor = 0x03; 
  TestJitter(divisor,IRDA_LP_MODE); 
#endif




#if defined(ALL_TESTS) || defined(RTIS_TESTS)
  C("Receive Timeout interrupt : Normal Mode, Divisor : 2");
  divisor = 0x02;
  RTISTest(divisor,NORMAL_MODE);

  C("Receive Timeout interrupt : IRDA Mode");
  divisor = 0x01;
  RTISTest(divisor,IRDA_MODE);

  C("Receive Timeout interrupt : IRDA LP Mode");
  divisor = 0x03;
  RTISTest(divisor,IRDA_LP_MODE);

  C("Receive Timeout interrupt : Normal Mode, Divisor : 1");
  divisor = 0x01;
  AnotherRTISTest(divisor,NORMAL_MODE);
#endif
  

#if defined(ALL_TESTS) || defined(HALFDUPLEX_TESTS)
  C("Half Duplex Test : IRDA");
  divisor = 0x01;
  HalfDuplexTest(divisor, IRDA_MODE);

  C("Half Duplex Test : IRDA LOW POWER");
  divisor = 0x02;
  HalfDuplexTest(divisor, IRDA_LP_MODE);
#endif


#if defined(ALL_TESTS) || defined(FIFO_TESTS)
  C("Fifo Tests");
  FifoTests();
#endif

  
#if defined(ALL_TESTS) || defined(DMA_TESTS)
  C("DMA Tests");
  DMATests();
#endif



#if defined(ALL_TESTS) || defined(ILLEGALBAUD_TESTS)
  C("IllegalBaud Tests");
  IllegalBaudTest();
#endif

#if defined(ALL_TESTS) || defined(DRIFT_TESTS)
  C("Drift : NORMAL MODE: word length 8, odd parity, no extra stop bit");
  hword = 0x72;
  divisor = 0x01; 
  DriftTest(divisor,hword,NORMAL_MODE);

  C("Drift : NORMAL MODE: word length 8, odd parity,  extra stop bit");
  hword = 0x7A;
  divisor = 0x01; 
  DriftTest(divisor,hword,NORMAL_MODE);

  C("Drift   : IRDA MODE: word length 8, odd parity, no extra stop bit"); 
  hword = 0x72;
  divisor = 0x01; 
  DriftTest(divisor,hword,IRDA_MODE); 

  C("Drift   : IRDA MODE: word length 8, odd parity, extra stop bit"); 
  hword = 0x7A;
  divisor = 0x01; 
  DriftTest(divisor,hword,IRDA_MODE); 

   C("Drift   : IRDA LP MODE: word length 8, odd parity, no extra stop bit"); 
  hword = 0x72;
  divisor = 0x01; 
  DriftTest(divisor,hword,IRDA_LP_MODE);
  
  C("Drift   : IRDA LP MODE: word length 8, odd parity,extra stop bit"); 
  hword = 0x7A;
  divisor = 0x01; 
  DriftTest(divisor,hword,IRDA_LP_MODE);
#endif

#if defined(ALL_TESTS) || defined(BREAK_TESTS)
  C("Break Tests"); 
  BreakTest();
#endif

#if defined(ALL_TESTS) || defined(FC_TESTS)
  C("Flow Control Tests");
  FlowControlTests();
#endif




  C("Test End"); 

  TestEnd();
  return 0;

}


/************************************ End *************************************/




  

  






  
 


