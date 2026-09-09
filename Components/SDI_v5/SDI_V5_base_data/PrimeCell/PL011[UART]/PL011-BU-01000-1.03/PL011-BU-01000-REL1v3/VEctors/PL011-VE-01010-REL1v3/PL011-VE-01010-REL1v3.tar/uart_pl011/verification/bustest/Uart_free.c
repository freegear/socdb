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
--  File Name              : Uart_free.c.rca
--  File Revision          : 1.2
--  
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.                 
--                                                                   
--   Files required for compilation:                                
--     makefile, busheader.h, busmacros.h, busmacros.c,            
--     config.h, addargs_script,                                  
--     Uart_free.h, Uart_free.c                                  
--                                                              
--   Usage: make <testname> e.g. make Uart_free                
--                                                            
--   To create .bif formatted vectors from the BusTalk code (default)  
--     make <testname> e.g. make Uart_free                            
--   This will create testname.bif in the ./invec directory          
--                                                                  
------------------------------------------------------------------------------*/

/******************************************************************************/
/*** For more information on the Uart, please refer to PL010 AMBA UART      ***/
/*** Block Specification                                                    ***/
/******************************************************************************/

/******************************************************************************/
/*** Include common BusTalk files                                           ***/
/******************************************************************************/
#include "busmacros.h"
#include "busheader.h"
#include "config.h"
#include <stdio.h> 

/******************************************************************************/
/*** Include UART header file                                               ***/
/*** for register offset definitions and mask values                        ***/
/******************************************************************************/
#include "Uart_free.h"

/******************************************************************************/
/***************** System Clock Defines ***************************************/
/******************************************************************************/


#define UARTCLK_PERIOD     20 
#define PCLK_PERIOD        20

/******************************************************************************/
/************************* Function declarations ******************************/
/******************************************************************************/

void RegisterTests(void);
void FifoDisabledTests(void);
void FifoEnabledTests(unsigned int divisor, enum op_mode mode);
void IndependentTXRXTests(unsigned int divisor, enum op_mode mode);
void OverrunTests(unsigned int divisor, enum op_mode mode);
void BaudTests(enum op_mode mode);
void TestModem(unsigned int divisor, enum op_mode mode);
void TestParityError(unsigned int divisor, enum op_mode mode);
void TestFramingError(unsigned int divisor, enum op_mode mode);
void TestJitter(unsigned int divisor, enum op_mode mode);
void InterruptTests(unsigned int divisor, enum op_mode mode);
void IrdaTests(void);
void BreakTest(void);
void RTISTest(unsigned int divisor, enum op_mode mode);
void AnotherRTISTest(unsigned int divisor, enum op_mode mode);
void FifoUartDisableTest(unsigned int divisor,enum op_mode mode);
void HalfDuplexTest(unsigned int divisor,enum op_mode mode);
void TestWithConfiguration(unsigned int divisor, int hword, enum op_mode mode);
void ScanModeTest(void);
void ConfigureUbrlcr(unsigned int divisor, int hword, unsigned hword_address);
void ConfigureUbrlcrTr(unsigned int divisor, int hword, unsigned hword_address);
void Idle(unsigned long time);
void TestWithConfiguration_Irda(unsigned int divisor, int hword, int lpr_width, 
				enum op_mode mode, int shift_en, int from, int tobit,int shift_factor);
void loopback_mode(void);
void BoundaryTests(void);
void FifoTests(void);
/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/
unsigned int wait_factor;
unsigned int divisor;

int main()
{

  C("---------------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 1998 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("---------------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Uart_free.c.rca",header);
  C("File Revision          : 1.2",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL011-REL1v3",header);
  C("---------------------------------------------------------------------------",header);

  /* Start of Compliance test program */

  TestStart();
 
  /* Reset the Uart and TrickBox */ 
  RES(LOW,0x1,0x1);
  PI(0x02);
  
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

  RegisterTests();
    
  /* Resetting the Uart and Asserting nUARTRST Pin  */
  
  RES(LOW,0x1,0x1);
  PI(0x02);
  PSW(0x08 , RSTMODE_REG);
  PSW(0x09, RSTMODE_REG);

  /* Writing the Clock Timings to the TrickBox */ 
  PSW(UARTCLK_PERIOD, UTCLKREG);

  /* Programming the Low Power Divisor Value */
  PSW(IRLP_DIV, UARTILPR);
  PSW(IRLP_DIV, UTILPR);

  /* Clear Interrupts */
  PSW(0x7ff, UARTICR);
  
  /* LoopBack Mode Tests */ 
  loopback_mode();
  
  /*   Boundary Tests: Only When Frequencies Are Same */
  if( PCLK_PERIOD == UARTCLK_PERIOD )   
    {   
      BoundaryTests();   
    }   
  
  /* Fifo Disabled Tests*/     
  FifoDisabledTests ();
    
  /*   Fifo Enabled Tests */
  C("Fifo Enabled  : NORMAL MODE");
  divisor = 0x02; 
  FifoEnabledTests(divisor,NORMAL_MODE);

  C("Fifo Enabled  : IRDA MODE"); 
  divisor = 0x01; 
  FifoEnabledTests(divisor,IRDA_MODE); 

  C("Fifo Enabled  : IRDA LP MODE"); 
  divisor = 0x01; 
  FifoEnabledTests(divisor,IRDA_LP_MODE);
 
  /* Independent TX and RX Tests */
  C("Independent TX/RX  : NORMAL MODE"); 
  divisor = 0x02;  
  IndependentTXRXTests(divisor,NORMAL_MODE); 

  C("Independent TX/RX  : IRDA MODE");  
  divisor = 0x01;  
  IndependentTXRXTests(divisor,IRDA_MODE);  

  C("Independent TX/RX : IRDA LP MODE");  
  divisor = 0x01; 
  IndependentTXRXTests(divisor,IRDA_LP_MODE); 
    
  /* Fifo Uart Diasbaled Tests */
  C("FifoUartDisable : NORMAL MODE"); 
  divisor = 0x03; 
  FifoUartDisableTest(divisor,NORMAL_MODE); 
  
  C("FifoUartDisable : IRDA MODE"); 
  divisor = 0x02; 
  FifoUartDisableTest(divisor,IRDA_MODE); 

  C("FifoUartDisable : IRDA LP MODE"); 
  divisor = 0x04; 
  FifoUartDisableTest(divisor,IRDA_LP_MODE);
   
  /* Interrupt Tests */
  C("Interrupt Tests : NORMAL MODE");
  divisor = 0x01; 
  InterruptTests(divisor,NORMAL_MODE); 

  C("Interrupt Tests : IRDA MODE"); 
  divisor = 0x01; 
  InterruptTests(divisor,IRDA_MODE); 
 
  C("Interrupt Tests : IRDA LP MODE"); 
  divisor = 0x01; 
  InterruptTests(divisor,IRDA_LP_MODE);
  
  /*  IrDA Tests */  
  IrdaTests();
  
  /* Overrun Tests */ 
  C("Overrun Test Normal Mode");
  divisor = 0x02;
  OverrunTests(divisor,NORMAL_MODE);

  C("Overrun Test IRDA Mode");
  divisor = 0x03;
  OverrunTests(divisor,IRDA_MODE);

  C("Overrun Test IRDA LOW POWER Mode");
  divisor = 0x01;
  OverrunTests(divisor,IRDA_LP_MODE);

  /* Baud Tests */
  C("Baud Tests Normal Mode"); 
  BaudTests(NORMAL_MODE); 

  C("Baud Tests IRDA Mode");  
  BaudTests(IRDA_MODE); 

  C("Baud Tests IRDA Low Power Mode");  
  BaudTests(IRDA_LP_MODE); 
  
  /* Modem Tests */ 
  C("Modem Tests NORMAL Mode");   
  divisor = 0x02;  
  TestModem(divisor,NORMAL_MODE); 
  
  
  C("Modem Tests IRDA Mode");  
  divisor = 0x01;  
  TestModem(divisor,IRDA_MODE);  

  C("Modem Tests IRDA LP Mode"); 
  divisor = 0x03; 
  TestModem(divisor,IRDA_LP_MODE); 

  /*  Parity Error Tests */ 
  C("Parity Error Test");
  divisor = 0x04;
  TestParityError(divisor, NORMAL_MODE);
 
  C("IRDA Parity Error Test");
  divisor = 0x08;
  TestParityError(divisor, IRDA_MODE);

  C("IRDA LP: Parity Error Test");
  divisor = 0x03;
  TestParityError(divisor, IRDA_LP_MODE);
  
 
  /* Framing Error Test */
  C("Framing Error Test");
  divisor = 0x02;
  TestFramingError(divisor, NORMAL_MODE);

  C("IRDA Framing Error Test");
  divisor = 0x01;
  TestFramingError(divisor, IRDA_MODE);

  C("IRDA LOW POWER Framing Error Test");
  divisor = 0x02;
  TestFramingError(divisor, IRDA_LP_MODE);
 
  /* Tolerance Tests */  
  C("NORMAL : Jitter"); 
  divisor = 0x02; 
  TestJitter(divisor,NORMAL_MODE); 
 
  C("IRDA : Jitter"); 
  divisor = 0x01; 
  TestJitter(divisor,IRDA_MODE); 
  
  C("IRDA LP: Jitter"); 
  divisor = 0x03; 
  TestJitter(divisor,IRDA_LP_MODE); 

  /* Break Error Tests */  
  BreakTest();
   
  /* Recieve Timeout Interrupt Tests */
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
  
  /* Half Duplex Tests */ 
  C("Half Duplex Test : IRDA");
  divisor = 0x01;
  HalfDuplexTest(divisor, IRDA_MODE);

  C("Half Duplex Test : IRDA LOW POWER");
  divisor = 0x02;
  HalfDuplexTest(divisor, IRDA_LP_MODE);

  /* Scan Mode Tests */ 
  C("ScanMode Pin Test");
  ScanModeTest();

  /* Fifo Tests */
  C("Fifo Tests");
  FifoTests();
     
  /* The end of the Compliance test program */

  TestEnd();
  return 0;
}

/******************************************************************************/
/************************** RegisterTests *************************************/
/******************************************************************************/

void RegisterTests(void)
{
  /*
    Summary: Register Test
    ======================
    This test checks the following functionalities :
 
    o  All UART registers are read immediately after reset to verify
    that they initialise to values mentioned in the specification.
 
    o  The Read/Writeable registers are written with patterns of 0x55
    and 0xAA. Data is read back and compared with the expected pattern.
   */

  C("Reset Test");
  PSR(0x00, UARTRSR_MASK, UARTRSR,uartrsr);
  PSR(0x00, UARTLCR_H_MASK, UARTLCR_H,uartlcr_h);
  PSR(0x00, UARTLCR_H_new_MASK, UARTLCR_H_new,uartlcr_h);/
    PSR(0x300, UARTCR_MASK, UARTCR,uartcr);
    PSR(0x300, UARTCR_newMASK, UARTCR_new,uartcr_new);
    PSR(0x90, masks[8], UARTFR,uartfr); 
    PSR(0x00, UARTILPR_MASK, UARTILPR,uartilpr);
    PSR(0x00, UARTBRD_MASK, UARTBRD,uartbrd);  
    PSR(0x12, UARTIFLS_MASK, UARTIFLS, uartifls);
    PSR(0x00, UARTIMSC_MASK, UARTIMSC, uartimsc);
    PSR(0x00, UARTRIS_MASK, UARTRIS, uartris);
    PSR(0x00, UARTMIS_MASK, UARTMIS, uartmis);


    /* Test Registers */
    PSR(0x79 , UARTTOCR_MASK,  UARTTOCR,uarttocr);
    PSR(0x00 , UARTTBCR_H_MASK,  UARTTBCR_H,uarttbcr_h);
    PSR(0x00 , UARTTBCR_L_MASK,  UARTTBCR_L,uarttbcr_l);
    PSR(0x00 , UARTTLPR_MASK,  UARTTLPR,uarttlpr);

    C("UART Register Test");

    PSW(DATA_As, UARTBRD,uartlbrd);
    PSW(DATA_As, UARTLCR_H,uartlcr_h);
    PSW(DATA_As, UARTLCR_H_new,uartlcr_h_new);

    PSR(DATA_As & UARTLCR_H_MASK, UARTLCR_H_MASK, UARTLCR_H,uartlcr_h);
    PSR(DATA_As & UARTLCR_H_new_MASK, UARTLCR_H_new_MASK, UARTLCR_H_new,uartlcr_h_new); 
    PSR(DATA_As & UARTBRD_MASK, UARTBRD_MASK, UARTBRD,uartbrd);
 
    PSW(DATA_5s, UARTBRD,uartlbrd);
    PSW(DATA_5s, UARTLCR_H,uartlcr_h);
    PSW(DATA_5s, UARTLCR_H_new,uartlcr_h_new);
  
    PSR(DATA_5s & UARTLCR_H_MASK, UARTLCR_H_MASK, UARTLCR_H,uartlcr_h);
    PSR(DATA_5s & UARTBRD_MASK, UARTBRD_MASK, UARTBRD,uartbrd);
    PSR(DATA_5s & UARTLCR_H_new_MASK, UARTLCR_H_new_MASK, UARTLCR_H_new,uartlcr_h_new);

    PSW(DATA_As, UARTCR,uartcr);
    PSR(DATA_As & UARTCR_MASK, UARTCR_MASK,  UARTCR,uartcr);
    PSW(DATA_5s, UARTCR,uartcr);
    PSR(DATA_5s & UARTCR_MASK, UARTCR_MASK,  UARTCR,uartcr);

    PSW(DATA_As, UARTCR_new,uartcr_new);
    PSR(DATA_As & UARTCR_newMASK, UARTCR_newMASK,  UARTCR_new,uartcr_new);
    PSW(DATA_5s, UARTCR_new,uartcr_new);
    PSR(DATA_5s & UARTCR_newMASK, UARTCR_newMASK,  UARTCR_new,uartcr_new);

    PSW(DATA_As, UARTILPR,uartilpr);
    PSR(DATA_As & UARTILPR_MASK, UARTILPR_MASK, UARTILPR,uartilpr);
    PSW(DATA_5s, UARTILPR,uartilpr);
    PSR(DATA_5s & UARTILPR_MASK, UARTILPR_MASK, UARTILPR,uartilpr);

    PSW(DATA_As, UARTIFLS,uartifls);
    PSR(DATA_As & UARTIFLS_MASK, UARTIFLS_MASK, UARTIFLS,uartifls);
    PSW(DATA_5s, UARTIFLS,uartifls);
    PSR(DATA_5s & UARTIFLS_MASK, UARTIFLS_MASK, UARTIFLS,uartifls);

    /*  Test Registers */

    PSW(DATA_As, UARTTCR,uarttcr);
    PSR(DATA_As & UARTTCR_MASK, UARTTCR_MASK,  UARTTCR,uarttcr);
    PSW(DATA_5s, UARTTCR,uarttcr);
    PSR(DATA_5s & UARTTCR_MASK, UARTTCR_MASK,  UARTTCR,uarttcr);

    PSW(DATA_As, UARTTMR,uarttmr);
    PSR(DATA_As & UARTTMR_MASK, UARTTMR_MASK,  UARTTMR,uarttmr);
    PSW(DATA_5s, UARTTMR,uarttmr);
    PSR(DATA_5s & UARTTMR_MASK, UARTTMR_MASK,  UARTTMR,uarttmr);

    PSW(DATA_As, UARTTISR,uarttisr);
    PSR(DATA_As & UARTTISR_MASK, UARTTISR_MASK,  UARTTISR,uarttisr);
    PSW(DATA_5s, UARTTISR,uarttisr);
    PSR(DATA_5s & UARTTISR_MASK, UARTTISR_MASK,  UARTTISR,uarttisr);
  

}


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
   */
 
  int hword;
  enum op_mode mode = NORMAL_MODE;
  unsigned int divisor;
  int expected_value;

  C("Fifo Tests : Word Length 8, No Parity, No Extra Stop Bit");
  hword = 0x60;
  divisor = 0x02;
  TestWithConfiguration(divisor,hword,mode);

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

}


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

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
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
  PSW(cword, UTCR);
  
  /* Now read each byte from the Rx fifo as it arrives */
  for(i=0; i<16; i++)
    {
      PO(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,(wait_factor+1) * byte_cycles,uartfr22);
      reg_val = i | (i << 4);
      expected_value = 0 |(reg_val & masks[wlength]);
      PSR(expected_value,0xfff,UARTDR,uartdrlast);   
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
      PI(wait_factor * 2);
    
      /* wait till the last byte has been received by trickbox */
      PO(0x00, UTRXBUSY | UTTXBUSY, UTFR, wait_factor * byte_cycles,fifoloop);

      /* Read the data */
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
/*************************** FifoEnabledTests *********************************/
/******************************************************************************/

void FifoEnabledTests(unsigned int divisor,enum op_mode mode)
{
  /*
    Summary: Fifo Enabled Tests
    ===========================
 
    The purpose of these tests is to check the FIFO operations as well as
    bursts of back to back transmission and reception of data by the UART.
    A configuration of different divisor value, word length 5, no parity 
    and no extra stop bit has been selected for this test. The FIFOs are 
    enabled for this tests. Initially One byte is transmitted and the number
    of bytes increase with each iteration and after 16 bytes are transmitted 
    at one shot, then the number of bytes transmitted reduces to one.
    A total of 200 bytes are transmitted this way to check the stability of 
    the FIFOs. 
  
  */
  

#define MAX_WORDS 200
  int hword = 0x10;
  int wlength = 5;
  int buffer[MAX_WORDS];
  int i,j,k,tx_ctr, rx_ctr;
  int32 some_cycles = 10;
  int32 bit_cycles, byte_cycles;
  unsigned long bit_width;
  int cword;
  int expected_value;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  if (mode == NORMAL_MODE)
    cword = 0x01;
  else if (mode == IRDA_MODE)
    cword = 0x03;
  else if (mode == IRDA_LP_MODE)
    cword = 0x07;
 
  for(i=0; i < MAX_WORDS; i++)
    buffer[i] = (i%16) | ((i%16) << 4);

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  PSW(0x7ff, UARTICR);
  PSW(0x00, UARTECR);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_b);

  C("Fifo Enable Tests - Tx");

  if (mode == NORMAL_MODE)
    cword = 0x101;
  else if (mode == IRDA_MODE)
    cword = 0x103;
  else if (mode == IRDA_LP_MODE)
    cword = 0x107;

  tx_ctr = rx_ctr = 0;
  j = 1;
  while (tx_ctr < MAX_WORDS)
    {
      for( i = 0; (i < j) && (tx_ctr < MAX_WORDS); i++)
	{
	  PSW(buffer[tx_ctr], UARTDR);
	  tx_ctr++;

	  if (i < (UARTFIFO_SIZE - 1) )
	    {
	      PO( UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr14);
	    }
	  else
	    {
	      PO(UART_TXFF|UART_RXFE|UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr13);
	    }
	}

      /* make ready for the next iteration */
      j++;
      if (j == (UARTFIFO_SIZE + 1))
	j = 1;

      /* Enable the uart and the trick box */
      PSW(cword, UTCR);
    
      PSW(cword, UARTCR_new); 
    
   
 
      PO( UART_UBUSY , UART_UBUSY, UARTFR, bit_cycles,busy_high);
      PI(2);

      /* Wait till all the bytes have been transmitted by the Trick Box */
      PO(  0 , UART_UBUSY, UARTFR, (byte_cycles * i),busy_low);
      PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr16);

      for(k=0; k < i; k++)
	{
	  PSR(buffer[rx_ctr++] & masks[wlength], 0xff, UTDR,utdrloop);
	  PSR(0, UTRSR_MASK, UTRSR,utrsrloop);
	}

      /* Disable the uart and the trick box */
      PSW(0, UTCR);
      PSW(0, UARTCR_new);
    }

  C("Fifo Enable Tests - Rx");

  if (mode == NORMAL_MODE)
    cword = 0x201;
  else if (mode == IRDA_MODE)
    cword = 0x203;
  else if (mode == IRDA_LP_MODE)
    cword = 0x207;
  
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);

  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr21);
  PSR( UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr21);

  tx_ctr = rx_ctr = 0;
  j = 1;
  while (tx_ctr < MAX_WORDS)
    {
      for( i = 0; (i < j) && (tx_ctr < MAX_WORDS); i++)
	{
	  PSW(buffer[tx_ctr++], UTDR);
	}
      j++;

      PI(bit_cycles);
    
      if (j == (UARTFIFO_SIZE + 1))
	j = 1;
      PO(UTTXBUSY, UTTXBUSY, UTFR, 2 *byte_cycles * i,pollloop1);
      PO(0, UTTXBUSY, UTFR, 2 *byte_cycles * i,pollloop2);
      Idle(2 * byte_cycles);
      if (i >= UARTFIFO_SIZE)
	{
	  PSR( UART_TXFE | UART_RXFF , UARTFR_MASK, UARTFR,uartfr22);
	}
      else
	{
	  PSR( UART_TXFE, UARTFR_MASK, UARTFR,uartfr23);
	}

      for(k=0; k< i; k++)
	{
      
	  expected_value = 0 | (buffer[rx_ctr++] & masks[wlength]);
	  PSR(expected_value, 0xfff, UARTDR,uartdrloop);
         
	  if (k < (i-1))
	    {
	      PSR(UART_TXFE, UARTFR_MASK, UARTFR,uartfr24);
	    }
	  else
	    {
	      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr25);
	    }
	}
    }

  PSW(0, UTCR);
  PSW(0, UARTCR_new);

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;
  
  if (mode == NORMAL_MODE)
    {
      /* Enable the uart and trickbox */
      PSW(cword, UTCR);
      PSW(cword, UARTCR_new);
  
      C("Fifo Enable Tests - Tx & Rx");

      PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr31);
  
      tx_ctr = rx_ctr = 0;
      j = 1;
      while (tx_ctr < MAX_WORDS)
	{
	  for( i = 0; (i < j) && (tx_ctr < MAX_WORDS); i++)
	    {
	      PSW(buffer[tx_ctr], UTDR);
	      PSW(buffer[tx_ctr], UARTDR);
	      tx_ctr++;
	    }
	  j++;
	  PI(0x10);
	  if (j == (UARTFIFO_SIZE + 1))
	    j = 1;
  
	  /* Then wait for UBUSY to go low */
	  PO(0x00, UART_RXFE | UART_UBUSY, UARTFR, wait_factor * 2 *byte_cycles * i,uartfr34);
  
	  /* At this time all the bytes in the Tx & Rx fifos ought to have 
	     been transmitted */
  
	  if (i == UARTFIFO_SIZE)
	    {
	      PSR( UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,uartfr35);
	    }
	  else
	    {
	      PSR( UART_TXFE , UARTFR_MASK, UARTFR,uartfr36);
	    }
  
	  for(k=0; k < i; k++)
	    {
	      PSR(buffer[rx_ctr] & masks[wlength], 0xff, UTDR,utdrloop);
	      PSR(0, UTRSR_MASK, UTRSR,utrsrloop);

	      expected_value = 0 |(buffer[rx_ctr] & masks[wlength]);
	      PSR(expected_value, 0xfff, UARTDR,uartdrloop1);
  
	      rx_ctr++;
	      if (k < (i-1))
		{
		  PSR( UART_TXFE , UARTFR_MASK, UARTFR,uartfr37);
		}
	      else
		{
		  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr38);
		}
	    }
	}
    }
}

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

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
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
    PSR(UART_UBUSY | UART_TXFF | UART_RXFF,UARTFR_MASK,UARTFR,uartfrrx3);
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


/******************************************************************************/
/*************************** FifoUartDisableTest ******************************/
/******************************************************************************/

void FifoUartDisableTest(unsigned int divisor,enum op_mode mode)
{
  /* 
     Summary: Uart Disable Tests
     ===========================

     This is a FIFO enabled test case where the Tx FIFO is filled, UART is 
     enabled and allowed to run till it starts transmitting. The UART is then
     disabled and then enabled. This time it is allowed to run till all the 
     remaining bytes have been transmitted. The data is then read out from the 
     TrickBox to check if the Tx FIFO of the UART retained the bytes during its
     temporary disabling.  The TX fifo is then written to, the Uart enabled,
     allowed to run til it starts transmitting and then disabled. One byte of
     data is read out of the Trickbox and the rest of the data should not be
     transmitted. In the receive test the trickbox is written to, then the Uart
     is disabled when data starts to be transmitted and only one word is received
     in the uart.

  */

  
  int i, wlength;
  int hword = 0x10, cword = 0x00;
  int32 byte_cycles,bit_cycles,some_cycles = 10;
  unsigned long bit_width;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;

  /* Disable the UART & trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
 
  for(i=1; i< 5; i++)
    {
      PSW(i, UARTDR);
    }

  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr1);

  /* Enable the UART and Trickbox */
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);
  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, byte_cycles*16,uartfr2);

  /* Disable the UART */
  PSW(0x00, UARTCR_new);

  PI(some_cycles);

  /* Enable uart */
  PSW(cword, UARTCR_new);
  PI(2);
  PSR(UART_RXFE | UART_UBUSY , UARTFR_MASK, UARTFR,uartfr3);

  PO(UART_TXFE | UART_RXFE , UARTFR_MASK, UARTFR, byte_cycles *5,uartfr3);
  PSR(0x00, UTRXFIFO_EMPTY, UTFR,utfifo);

  if (mode == NORMAL_MODE)
    {
      for(i=1; i< 5; i++)
	{
	  PSR(i, 0x1f, UTDR,utdrloop);
	  PSR(0x00, UTRSR_MASK, UTRSR,utrsrloop);
	  if (i < 4)
	    {
	      PSR(0x00, UTRXFIFO_EMPTY, UTFR,utfifoloop1);
	    }
	  else
	    {
	      PSR(0x01, UTRXFIFO_EMPTY, UTFR,utfifoloop2);
	    }
	}
    }
  else if (mode == IRDA_MODE)
    {
      PSR(0, 0x00, UTDR,utdrirda1);
      for(i=2; i< 5; i++)
	{
	  PSR(i, 0x1f, UTDR,utdrirda2);
	  PSR(0x00, UTRSR_MASK, UTRSR,utrsrirda3);
	  if (i < 4)
	    {
	      PSR(0x00, UTRXFIFO_EMPTY, UTFR,utfifoirda4);
	    }
	  else
	    {
	      PSR(0x01, UTRXFIFO_EMPTY, UTFR,utfifoirda5);
	    }
	}
    }
  else if (mode == IRDA_LP_MODE)
    {
      for(i=1; i<3; i++)
	{	 
	  PSR(0, 0x00, UTDR,utdrirda6);
	}
      for(i=3; i< 5; i++)
	{
	  PSR(i, 0x1f, UTDR,utdrirda7);
	  PSR(0x00, UTRSR_MASK, UTRSR,utrsrirda8);
	  if (i < 4)
	    {
	      PSR(0x00, UTRXFIFO_EMPTY, UTFR,utfifoirda9);
	    }
	  else
	    {
	      PSR(0x01, UTRXFIFO_EMPTY, UTFR,utfifoirda10);
	    }
	}
    }

  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr2a);


  /* Disable the UART & trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR); 

  for(i=2; i< 5; i++)
    {
      PSW(i, UARTDR);
    }

  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr1);

  /* Enable the UART and Trickbox */
  PSW(cword, UTCR);
  PSW(cword, UARTCR_new);

  PI(2*bit_cycles);
  PSR(UART_RXFE | UART_UBUSY,UARTFR_MASK,UARTFR,DisableTx);

  /* Disable the UART */
  PSW(0x00, UARTCR_new);

  PO(0x00, UTRXBUSY, UTFR, byte_cycles*2,uartfr2);
  PI(some_cycles);
  PSR(0, UTRXBUSY, UTFR,uartfr4);

  i=2;
  if (mode != NORMAL_MODE)
    {
      /* The following must be changed later when the TrickBox is fixed
	 for IrDA and LP IrDA modes */
      PSR(i & masks[wlength], 0x00, UTDR,DisableTx5Ir);
      PSR(0x00, UTRSR_MASK, UTRSR,utrsrloop);
    }
  else
    {
      PSR(i & masks[wlength], 0xff, UTDR,DisableTx5);
      PSR(0x00, UTRSR_MASK, UTRSR,utrsrloop);
    }
     
  /* Enable test fifo mode */
  PSW(0x20, UARTTCR);
  PI(2);

  /* Empty the Uart TX fifo */
  i = 3;
  PSR(i & masks[wlength], 0xff, UARTTDR,uartdr1);
  i++;
  PSR(i & masks[wlength], 0xff, UARTTDR,uartdr2);
  PI(2);
  
  PSW(0x00, UARTTCR);
      
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr2); 
  PSR(UART_TXFE | UART_RXFE ,UART_TXFE | UART_RXFE, UARTFR,uartfr4);

  C("Uart disabled Rx");
  
  PSW(cword, UARTCR_new);

  for(i=1; i< 5; i++)
    {
      PSW(i, UTDR);
    }

    
  /* Wait til the trickbox starts transmitting and the Uart starts
     receiving and then disable Uart */
    
  PI(2*bit_cycles);

  PSR(UTTXBUSY, UTTXBUSY, UTFR,utfr2);  

  PSW(0, UARTCR_new);
  PI(2*bit_cycles);
  PSR(0,0x00,UARTFR,uarttfr6);
  PI(2*bit_cycles);
  PSR(0,0x00,UARTFR,uarttfr6);
  PI(2*bit_cycles);
  PSR(0,0x00,UARTFR,uarttfr6);
  PI(2*bit_cycles);
    
  PSR(0,UART_RXFE,UARTFR,uarttfr6);
  i=1;
  PSR(i & masks[wlength], 0xff, UARTDR,uartdr3);
  PSR(UART_RXFE,UART_RXFE,UARTFR,uarttfr6);

  PO(UTTXFIFO_EMPTY,UTTXFIFO_EMPTY,UTFR,6*byte_cycles,utfr_endTx);     
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,utfr4); 

  PSW(0, UARTCR_new);
  PSW(0, UTCR);
  
} 

/******************************************************************************/
/*************************InterruptTests **************************************/
/******************************************************************************/

void InterruptTests(unsigned int divisor, enum op_mode mode)
{
  /* 
     Summary: Interrupt Tests
     ========================
  
     These tests check the generation of Tx and Rx interrupts. The values
     of UARTTXINTR, UARTRXINTR and UARTINTR are checked through the Raw
     Interrupt status and Masked Interrupt status registers. These tests
     are being conducted in both modes
     i.e. Fifo enabled mode and Fifo disabled mode.

  */

  int i,j,wlength;
  int hword = 0x00, cword;
  int32 byte_cycles,bit_cycles, some_cycles = 10;
  unsigned long bit_width;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  C("Fifo Disabled : TXINT");

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;

  /* Disable the Uart, interrupts and the TrickBox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UTCR);

  /* Clear any interrupts that are already set */
  PSW(0x7ff, UARTICR);

  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Check interrupts at the half full fifo level*/
  PSW(UART_RXFHALF|UART_TXFHALF, UARTIFLS);
  PI(2);

  /* Check Masked Interrupts */
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis1);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir11);
 
  /* Enable the uart interrupts alone */
  PSW(0x30, UARTIMSC);
  
  /* Check Interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris60);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis60);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir12);

  /* Write one word */
  PSW(0xff, UARTDR);

  /* Check Masked and Raw Interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris61);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis61);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir13);

  /* Enable the uart also */
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);

  /* Check Interrupts - first with the interrupts disabled to check that the masked
     value is 0, then with the interrupts enabled */
  PSW(0x00, UARTIMSC);
  PO(UART_TXRINT, UARTRIS_MASK, UARTRIS, byte_cycles,uartris62);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis62);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir14);
  
  PSW(0x30, UARTIMSC);
  PO(UART_TXRINT, UARTRIS_MASK, UARTRIS, byte_cycles,uartris62);
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmis62);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir14);
  
/* wait for word to be transmitted and read it out of trickbox */
  PI(2*bit_cycles);
  PO(0,UTRXBUSY,UTFR,byte_cycles,wait);
  PSR(0xff & masks[wlength],0x1f, UTDR,read);

  /* Clear interrupt by writing to bit 5 of the interrupt clear register */
  PSW(0x20, UARTICR);
  PI(1); 

  /* Check interrupts */
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris611);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis612);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir13);


  /* Disable Uart so data goes into holding buffer */
  PSW(0, UARTCR_new);
  PI(2);

  /* Write one word */
  PSW(0x66, UARTDR);
  PI(2);

  /* Enable Uart */
  PSW(cword, UARTCR_new);
  PI(2);

  
  /* wait for word to be transmitted and read it out of trickbox */
  PI(byte_cycles);
  PO(0,UTRXBUSY,UTFR,byte_cycles,wait);
  PSR(0x66 & masks[wlength],0x1f, UTDR,read);

  /* Check Masked and Raw Interrupts */
  PO(UART_TXMINT, UARTRIS_MASK, UARTRIS, some_cycles,uartris613);
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmis614);
  PSR(UT_TXINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utiir13);

  C("Fifo Disabled : RXINT");  
 
  /* Check Interrupts */
  PSR(UART_TXMINT, UARTMIS_MASK, UARTMIS,uartmis63);
  PSR(UT_TXINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utiir21);

   /* Write a Data byte to the Trick box */ 
  PSW(DATA_5s,UTDR);
  
  PI(wait_factor * 2);
  PSR(UTTXBUSY, UTTXBUSY, UTFR,utfr1a);

  /* Wait till the transmission is over */
  PO( 0x00, UTTXBUSY, UTFR, byte_cycles,utfr1);

  /* Check Interrupts */
  PO(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis64);
  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir22);

  /* Disable the uart alone , not the RX interrupt */
  PSW(0x00, UARTCR_new);
   
  /* Check Interrupts */
  PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis65);
  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir23);

  /* Read the byte out of the Rxfifo */
  PSR(DATA_5s & masks[wlength], 0xff, UARTDR,uartdr1);

  /* Check Interrupts */
  PO(UART_TXMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir24);


  if ( mode == NORMAL_MODE)
    {
      C("Fifo Disabled :  TXINT and RXINT");
  
      /* Disable the Uart and Trick box and interrupts */
      PSW(0x00, UARTCR_new);
      PSW(0x00, UTCR);
  
      /* Enable the   TX RX interrupt alone */
      PSW(0x30, UARTIMSC);
  
      /* Check Interrupts */
      PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis66);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir31);
  
      /* Write a Data byte to the Trick box and Uart*/
      PSW(DATA_5s,UARTDR);

      /* Check Interrupts */
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis67);
      PSR(0x00 , UTIIR_MASK, UTIIR,utiir32);
  
      /* Enable the Trickbox first and then the Uart */
      PSW(cword, UTCR);
      PSW(cword, UARTCR_new);

      /* Write some data to the Trickbox */
      PSW(DATA_5s,UTDR);

      /* Wait till the transmission is over */
      PO(0x00, UART_UBUSY, UARTFR, byte_cycles,uartfr1);
      PI(0x02);
      PO( 0x00, UTTXBUSY | UTRXBUSY, UTFR, wait_factor * byte_cycles,utfr1);
  
      /* Check Interrupts */
      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis68);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir33);
  
      /* Disable the uart alone , not the RX interrupt */
      PSW(0x00, UARTCR_new);
  
      /* Check Interrupts */
      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis69);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir34);

      /* Clear Rx interrupt by writing to bit 4 of the interrupt clear register */
      PSW(0x10, UARTICR);
      PI(2);
      
      PO(UART_TXMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis70);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir35);
      
      /* Read the byte out of the Rx fifo */
      PSR(DATA_5s & masks[wlength], 0xff, UARTDR,uartdr1);
      PSR(DATA_5s & masks[wlength], 0xff, UTDR,utdr1);

      /* Write some data to the Trickbox */
      PSW(DATA_5s,UTDR);

      /* Enable Uart */
      PSW(cword, UARTCR_new);

      /* Wait till the transmission is over */
      PO(0x00, UART_UBUSY, UARTFR, byte_cycles,uartfr1a);
      PI(0x02);
      PO( 0x00, UTTXBUSY | UTRXBUSY, UTFR, wait_factor * byte_cycles,utfr1a);
  
      /* Check Interrupts */
      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis68a);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir33a);
      
      /* Read the byte out of the Rxfifo */
      PSR(DATA_5s & masks[wlength], 0xff, UARTDR,uartdr1);
 
      /* Check Interrupts */
      PO(UART_TXMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis70a);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir35a);
     

      /* Disable the Trick Box and the Uart */
      PSW(0x00, UARTCR_new);
      PSW(0x00, UTCR);
    }

  C("Fifo Enabled : TXINT");

  /* Disable the Uart, Interrupts and the TrickBox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UTCR);

  /* Configure the uart and the trick box */
  /* Enable the fifos also */
  hword |= 0x10;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Check Interrupts */
  PSR(UART_TXRINT, UARTRIS_MASK, UARTRIS,uartris71);
  PSR(0, UARTMIS_MASK, UARTMIS,uartmis71);
  PSR(0, UTIIR_MASK, UTIIR,utiir41);
 
  /* Enable the interrupts alone */
  PSW(0x30, UARTIMSC);

  /* Check Interrupts */
  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis73);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir42);

  /* Write Data bytes into the Transmit fifo one by one */
  for(i=0; i < (UARTFIFO_SIZE/2) + 1; i++)
    {
      PSW(i,UARTDR);

      /* Check Interrupts */
      if (i < (UARTFIFO_SIZE/2))
	{
	  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis74);
	  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir43);
	}
      else
	{
	  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartiir44);
	  PSR(0x00, UTIIR_MASK, UTIIR,utiir44);
	}
    }

  /* Enable the uart also  so that it will start transmitting */
  PSW(cword, UARTCR_new);

  /* Check Interrupts */
  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis75);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir45);

  /* Write one more word */
  PSW(i++,UARTDR);

  /* Check Interrupts */
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis76);
  PSR(0x00, UTIIR_MASK, UTIIR,utiir46);

  /* Check interrupts again */
  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, byte_cycles,uartmis77);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir47);

  /* Disable the Uart  */
  PSW(0x00, UARTCR_new);

  /* Configure the uart and the Trick Box with fifo disabled to clear fifos */
  hword &= 0xef;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr12_d);


  C("Fifo Enabled : RXINT");

  /* Disable the Uart, interrupts and the TrickBox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UTCR);

  /* Configure the uart and the trick box */
  /* Enable the fifos also */
  hword |= 0x10;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Check Interrupts */
  PSR(0, UARTMIS_MASK, UARTMIS,uartmis78);
  PSR(0, UTIIR_MASK, UTIIR,utiir51);
 
  /* Enable the uart and interrupts */
  PSW(cword, UARTCR_new);
  PSW(0x30, UARTIMSC);

  /* Check interrupts again */
  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis79);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir52);

  /* Write 8 bytes to the Trick box */
  for(i=0; i< (UARTFIFO_SIZE/2); i++)
    {
      PSW(i,UTDR);
    }

  /* Enable the Trickbox */
  PSW(cword, UTCR);
  
  PI(wait_factor * 2);
  
  /* Allow it to run till all bytes have been transmitted */
  PO(0x00, UTTXBUSY, UTFR, byte_cycles * 8,utfr51);

  /* Check interrupts */
  PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis80);
  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir53);

  /* Read one byte out of the Rxfifo */
  j=0;
  PSR(j & masks[wlength], 0xff, UARTDR,uartdr0);
  j++;

  /* Check interrupts again */
  PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis81);
  PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir54);

  /* Write another byte to the Trick box */
  PSW(i, UTDR);
  i++;

  /* Allow it to run till this byte has been transmitted */
  PO(0x00, UTTXBUSY, UTFR, byte_cycles,utfr55);
  PI(2);

  /* Check interrupts */
  PO(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS, byte_cycles,uartmis82);
  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir56);

  /* Write another 8 bytes to the Trick box */
  for(; i< UARTFIFO_SIZE + 1; i++)
    {
      PSW(i,UTDR);
    }

  /* Allow it to run till all bytes have been transmitted */
  PO(UTTXBUSY, UTTXBUSY, UTFR, byte_cycles * 8,utfr57);
  PI(2);
  PO(0x00, UTTXBUSY, UTFR, byte_cycles * 8,utfr57);
  PI(2);

  /* Check interrupts */
  PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS, uartmis83);
  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir53a);

  /* j = 00 has already been read out */
  for(j=1; j< (UARTFIFO_SIZE + 1); j++)
    {
      /* Read from the Uart Rx fifo */
      PSR(j & masks[wlength], 0xff,UARTDR,uartdr);

    /* Check interrupts */
      if (j <= (UARTFIFO_SIZE/2))
	{
	  PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,some_cycles,uartmis84);
	  PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir53b);
	}
      else
	{
	  PO(UART_TXMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis85);
	  PSR(UT_UARTINTR | UT_TXINT , UTIIR_MASK, UTIIR,utiir54);
	}
    }

  /* Disable the Trickbox, Interrupts & uart */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UTCR);

  C("Fifo Enabled : TXINT & RXINT");

  if (mode == NORMAL_MODE)
    {
      /* Disable the Uart and the TrickBox */
      PSW(0x00, UARTCR_new);
      PSW(0x00, UTCR);
  
      /* Configure the uart and the trick box */
      /* Enable the fifos also */
      hword |= 0x10;  
      ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
      ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
  
    /* Check Interrupts */
      PSR(0, UARTMIS_MASK, UARTMIS,uartmis86);
      PSR(0, UTIIR_MASK, UTIIR,utiir61);
   
    /* Enable the interrupts alone */
      PSW(0x30, UARTIMSC);
  
      /* Check Interrupts */
      PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis87);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir62);
  
    /* Write Data bytes into the Transmit fifo one by one */
      for(i=0; i < (UARTFIFO_SIZE/2) + 1; i++)
	{
	  PSW(i,UARTDR);
	  PSW(i,UTDR);
  
	  /* Check Interrupts */
	  if (i < (UARTFIFO_SIZE/2))
	    {
	      PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis88);
	      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir63);
	    }
	  else
	    {
	      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis89);
	      PSR(0x00, UTIIR_MASK, UTIIR,utiir64);
	    }
	}
  
      /* Enable the Uart and Trickbox */
      PSW(cword,UARTCR_new);
      PSW(cword,UTCR);
  
    /* Poll for transmit interrupt */
      PO(UART_TXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis90);
      PSR(UT_UARTINTR | UT_TXINT, UTIIR_MASK, UTIIR,utiir65);
  
    /* Poll for receive interrupt now */
      PO(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS, byte_cycles * 8,uartmis91);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir66);
  
    /* Wait till transmission is over */
      PO(0x00, UTTXBUSY, UTFR, byte_cycles,utfr);
  
      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis92);
      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir67);
  
      /* Read the bytes one by one */
      for(i=0; i< 9; i++)
	{
	  PSR(i & masks[wlength], 0xff, UARTDR,uartdr);
	  PSR(i & masks[wlength], MaskAll, UTDR,utdr);
	  if (i < 1)
	    {
	      PSR(UART_TXMINT | UART_RXMINT, UARTMIS_MASK, UARTMIS,uartmis92);
	      PSR(UT_UARTINTR | UT_TXINT | UT_RXINT, UTIIR_MASK, UTIIR,utiir68);
	    }
	  else
	    {
	      PSR(UART_TXMINT , UARTMIS_MASK, UARTMIS,uartmis93);
	      PSR(UT_UARTINTR | UT_TXINT , UTIIR_MASK, UTIIR,utiir69);
	    }
	}
      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr12_d);
      PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR,uartfr13_d);
    }

  /* Clear and disable interrupts and Uart */
  PSW(0x3ff, UARTICR);
  PSW(0x00, UARTIMSC);
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);
}

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

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
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
  
  PI(0x10);
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
  PI(0x10);
  PO(0, UTTXBUSY, UTFR, byte_cycles,fifo11);


  PSR(UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,uartfr14);

  /* check rxfifo data and that overrun flag has not been set  */
  expected_value = (0x00 << 8) | (0x22 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,dr2nd);

  /* Write the 4th word to the Trick box to be transmitted -
     this will cause the overrun to be copied into the FIFO */
  PSW(0x44,UTDR);
  PI(0x10);
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
  PI(0x10);

  PO(0,UTTXBUSY , UTFR, byte_cycles,poll22);

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

  PO(0,UTTXBUSY , UTFR, byte_cycles,polldrrd1);

  /* Check interrupt is set */
  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint15);  

  /* Read word out to make space in the fifo */
  expected_value = 0 | (0x00 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,drrd1);

  /* clear interrupt */
  PSW(0x400, UARTICR);

  /* write word into fifo which will have the overrun error bit set */
  PSW(0x77,UTDR);
  PI(0x10);
    
  PO(0,UTTXBUSY , UTFR, byte_cycles,polldrrd2);


  /* write word to cause 2nd overun*/
  PSW(0x44,UTDR);
  PI(0x10);
   
  PO(0,UTTXBUSY , UTFR, byte_cycles,polldrrd2);

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
  PI(0x10);
    
  PO(0,UTTXBUSY , UTFR, byte_cycles,polldrrd3);
    
  /* write to cause 3rd overrun*/ 
  PSW(0x33,UTDR);
  PI(0x10);
    
  PO(0,UTTXBUSY , UTFR, byte_cycles,polldrrd3);

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

  PO(0,UTTXBUSY , UTFR, byte_cycles,polldrrd4);

  /* Cause another error to check that a 2nd interrupt won't clear the 1st */
  PSW(0x44,UTDR);
  PI(0x10);
    
  PO(0,UTTXBUSY , UTFR, byte_cycles,polldrrd3);

  PSR(0x400, UARTMIS_MASK, UARTMIS,oeint19);  
  
  /* read word out to make space in the fifo */
  expected_value = 0 | (0x03 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR,drrd4);

  /* write word which will have overrun error set*/ 
  PSW(0x55,UTDR);
  PI(0x10);

  PO(0,UTTXBUSY , UTFR, byte_cycles,polldrrd4);

  /* Read out the data without overrun errors */
  for(i=4; i<16;i++)
    {
      expected_value = 0 | (i & masks[wlength]);
      PSR(expected_value, 0x8ff, UARTDR, lastovrd1);
    }

  /* Check overrun errors have been set */
  expected_value = (0x08 << 8) | (0x77 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR, lastovrd2);

  expected_value = (0x08 << 8) | (0x99 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR, lastovrd3);
    
  expected_value = (0x08 << 8) | (0x22 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR, lastovrd4);

  expected_value = (0x08 << 8) | (0x55 & masks[wlength]);
  PSR(expected_value, 0x8ff, UARTDR, lastovrd5);

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

/******************************************************************************/
/***************************** BaudTests **************************************/
/******************************************************************************/

void BaudTests(enum op_mode mode)
{
  /*
    Summary: Baud Tests
    ===================
 
    These tests use the frequency measurement and frequency error detection 
    capabilities of the Trick Box. The UART and the Trick Box are disabled,
    configured for a buad rate and then enabled. The Trick Box is enabled 
    with the frequency measurement bit in its control register enabled. if
    any of the bit widths in the entire data frame fall outside the range, 
    the error bit is set in the trickbox register UT_FREQ_ERR. This test is 
    conducted for eight different divisor values 0,1,3,5,11,19,29,39.

  */

  int i = 0, reg_val;
  int hword = 0x00;
  int wlength=5;
  int32 some_cycles = 10;
  unsigned int cword = 0x00, data_byte = 0x55;
  unsigned long measured_width, byte_cycles;
  unsigned int divisor[8] = {0x00, 0x01, 0x03, 0x05, 0x11, 0x19, 0x29, 0x39};
  unsigned long bit_width;
 
  if (mode == NORMAL_MODE)
    {
      cword = 0x301;
      data_byte = 0x55;
    }
  else if (mode == IRDA_MODE)
    {
      cword = 0x303;
      data_byte = 0x00;
    }
  else if (mode == IRDA_LP_MODE)
    {
      cword = 0x307;
      data_byte = 0x00;
    }

  for( i = 0; i < 8; i++)
    {
      /* Disable the uart and the trick box */
      PSW(0, UTCR);
      PSW(0, UARTCR_new);
 
      /* Configure the uart and the trick box */
      bit_width = 16 * (divisor[i] + 1) * UARTCLK_PERIOD;
      ConfigureUbrlcr(divisor[i],hword,UARTLCR_H_new);
      ConfigureUbrlcrTr(divisor[i],hword,UTLCR_H);

      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13);

    /* Write Some data to the uart and trick box data registers */
      PSW(data_byte , UARTDR);

      PO(UART_UBUSY, UART_UBUSY, UARTFR, some_cycles,uarfr1); 

    /* Enable the trick box and the uart */
    /* along with frequency measurement */
      PSW(0x80 | cword, UTCR); 
      PSW(cword, UARTCR_new);

      PO(UART_UBUSY, UART_UBUSY, UARTFR, some_cycles,uartfr2);

      PI(2);
  
      byte_cycles = (bit_width / PCLK_PERIOD) * 14; 
      PO(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr3);
      PSR(UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr4);

      PSR(data_byte & masks[wlength], 0xff, UTDR,utdr);
      PSR(0, UTRSR_MASK, UTRSR,utrsr);

      /* check bit width */
      PSR(0x00, 0x01, UT_FREQ_ERR,freq_ctr_err);

      /* Disable the uart and the trick box */
      PSW(0, UTCR);
      PSW(0, UARTCR_new);
      PSW(0, UT_FREQ_ERR);
    }
}


/******************************************************************************/
/**************************** TestModem  **************************************/
/******************************************************************************/

void TestModem(unsigned int divisor,enum op_mode mode)
{
  /*
    Summary: Modem Tests
    ====================

    These tests check the modem status flags and the interrupt UARTMSINTR.
    The Modem lines are driven through the UT_SET_PINS register in TrickBox.
    The modem pin values are checked in the UART flag register UARTFR and the
    modem interrupts are checked in the Raw Interrupt status and the Masked
    Interrupt status registers. 
    Another test checks the assertion and deassertion of modem status flags 
    and pins during reception and transmission in various modes.

  */
   

  int i,some_cycles = 10;
  int hword = 0x10,wlength;
  unsigned int cword=0;
  int32 byte_cycles,bit_cycles;
  unsigned long bit_width;
  int expected_value;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;
  
  C("MSINT  & MODEM line flags test");

  /* This statement is read if test is conducted after reset */
  PI(0x10);
  
  /* Enable Modem Interrupts */
  PSW(0x0f, UARTIMSC);

  /* Set all Modem pins to value one */
  PSW(UT_SET_DSR | UT_SET_DCD | UT_SET_CTS | UT_SET_RI,UT_SET_PINS);
  
  PO(0x00, UARTFR_MOD, UARTFR, some_cycles,uartfr11_e);
  PSR(0x00, UARTFR_MOD, UARTFR, some_cycles,uartfr13);
  
  /* Clear modem interrupts incase any have been asserted */
  PSW(0x0f, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris1);  
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis1);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr1);

  PSR(0x00, UARTFR_MOD, UARTFR,uartfr14); 

  /* Assert DCD  */
  PSW(UT_RESET_DCD, UT_SET_PINS);
  PI(0x2);

  PO(UART_DCD, UARTFR_MOD, UARTFR, some_cycles,uartfr16);
  PI(2);
  PO(UART_DCDRINT, 0x0f, UARTRIS, some_cycles,uartris2);
  PSR(UART_DCDMINT, UARTMIS_MASK, UARTMIS,uartmis2); 
  PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr2);

  /* Clear interrupts */
  PSW(0x04, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris3);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis3);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr3);
  
  PSR(UART_DCD, UARTFR_MOD, UARTFR,uartfr17); 
 
  /* Assert DSR */
  PSW(UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);
  PI(2);

  PO(UART_DCD | UART_DSR, UARTFR_MOD, UARTFR, some_cycles,uartfr19);
  PI(2);
  PO(UART_DSRRINT , 0x0f, UARTRIS, some_cycles,uartris4);
  PSR(UART_DSRMINT , UARTMIS_MASK, UARTMIS,uartmis4);
  PSR(UT_UARTINTR | UT_MSINT , UTIIR_MASK, UTIIR,utintr4);

  /* Clear interrupts */
  PSW(0x0C, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris5);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis5);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr5);
  
  PSR(UART_DCD | UART_DSR, UARTFR_MOD, UARTFR,uartfr20);
  
  /* Assert CTS */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);

  PO(UART_DCD | UART_DSR | UART_CTS, UARTFR_MOD, UARTFR, some_cycles,uartfr22);
  PI(2);
  PO(UART_CTSRINT, 0x0f, UARTRIS, some_cycles,uartris6);
  PSR(UART_CTSMINT, UARTMIS_MASK, UARTMIS,uartmis6);
  PSR(UT_UARTINTR | UT_MSINT , UTIIR_MASK, UTIIR,utintr6);

  /* Clear interrupts */
  PSW(0x0E, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris7);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis7);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr7);

  PSR(UART_DCD | UART_DSR | UART_CTS, UARTFR_MOD, UARTFR,uartfr23);

  /* Assert RI */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);
  
  PO(UART_DCD | UART_DSR | UART_CTS | UART_RI, UARTFR_MOD, UARTFR, some_cycles,uartfr25);

  PI(2);
  PO(UART_RIRINT, 0x0f, UARTRIS, some_cycles,uartris6);
  PSR(UART_RIMINT, UARTMIS_MASK, UARTMIS,uartmis6);
  PSR(UT_UARTINTR | UT_MSINT , UTIIR_MASK, UTIIR,utintr6);

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris7);
  PSR(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis7);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr7);
 
  PSR(UART_DCD | UART_DSR | UART_CTS | UART_RI, UARTFR_MOD, UARTFR,uartfr27);
 
  /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);

  PO(0x00, UARTFR_MOD, UARTFR, some_cycles,uartfr28);
  PI(2);
 
  PO(UART_DSRRINT|UART_DCDRINT| UART_CTSRINT|UART_RIRINT , 0x0f, UARTRIS, some_cycles,uartris8);
  PSR(UART_DSRMINT|UART_DCDMINT| UART_CTSMINT|UART_RIMINT , UARTMIS_MASK, UARTMIS,uartmis8);
  PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr8);

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, 0x0f, UARTRIS, some_cycles,uartris9); 
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis9); 
  PSR(0x00, UTIIR_MASK, UTIIR,utintr9);

  PSR(0x00, UARTFR_MOD, UARTFR, some_cycles,uartfr30); 

  /* Disable UART and interrupts */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);
  PSW(0x00, UARTIMSC);
  
  PSR(0x00, UARTFR_MOD, UARTFR,uartfr32);


  C("MSINT during xmission");

  ConfigureUbrlcr(divisor,hword,UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword,UTLCR_H);
  for(i=0; i< 8; i++)
    {
      PSW(i, UARTDR);
    }
   
  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr34);

  /* Enable UART & Trickbox  & RX , TX & MSINT Interrupts */
  PSW(cword, UTCR);
  PSW(cword, UARTCR_new);
  PSW(0x3F, UARTIMSC);

  /* Set all Modem pins to value one */
  PSW(UT_SET_DSR | UT_SET_DCD | UT_SET_CTS | UT_SET_RI,UT_SET_PINS);
 
  PO(UART_RXFE | UART_UBUSY,0x1FF, UARTFR, some_cycles,uartfr35);

  /* Clear  interrupts incase any have been asserted */
  PSW(0x3f, UARTICR);
  PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris10);
  PSR(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis10);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr1);

  /* Check only the modem pin values */
  PSR(0x00 , UARTFR_MOD, UARTFR,uartfr36);
 
  /* Assert DCD  */
  PSW(UT_RESET_DCD, UT_SET_PINS);

  PO(UART_DCD, UARTFR_MOD, UARTFR, some_cycles,uartfr38);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis11);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr2);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis12);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr2);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PI(2);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis13);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr3);

  PSR(UART_DCD, UARTFR_MOD, UARTFR,uartfr39);
 
  /* Assert DSR */
  PSW(UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);

  PO(UART_DCD | UART_DSR , UARTFR_MOD, UARTFR, some_cycles,uartfr41);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DSRMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis14);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr4);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis15);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr4);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis16);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr5);

  PSR(UART_DCD | UART_DSR , UARTFR_MOD, UARTFR,uartfr42);
  
  /* Assert CTS */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);

  PO(UART_DCD | UART_DSR | UART_CTS , UARTFR_MOD, UARTFR, some_cycles,uartfr44); 
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_CTSMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis16);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr6);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis17);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr6);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis18);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr7);

  PSR(UART_DCD | UART_DSR | UART_CTS , UARTFR_MOD, UARTFR,uartfr45);

  /* Assert RI */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);

  PO(UART_DCD | UART_DSR | UART_CTS | UART_RI , UARTFR_MOD, UARTFR, some_cycles,uartfr47);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis19);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr6);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis20);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr6);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis21);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr7);

  PSR(UART_DCD | UART_DSR | UART_CTS | UART_RI, UARTFR_MOD, UARTFR,uartfr48);
 
   /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);
 
  PO(0x00 , UARTFR_MOD, UARTFR, some_cycles,uartfr50);
  PI(2);

  PI(2); 
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT|UART_CTSMINT|UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis22);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr8);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis23);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr8);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis24);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr9);

  PSR(0x00 , UARTFR_MOD, UARTFR, some_cycles,uartfr52);
  
  /* Disable MSINT alone */
  PSW(0x30, UARTIMSC);
  
  PSR(0x00, UARTFR_MOD, UARTFR,uartfr54); 
 
  /* Assert CTS */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);

  PO(UART_DCD | UART_DSR | UART_CTS | UART_RI , UARTFR_MOD, UARTFR, some_cycles,uartfr56);
  PI(2);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis25);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr6);

  /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);
  
  PO(0x00 , UARTFR_MOD, UARTFR, some_cycles,uartfr57);

  PI(2); 
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis26);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr8);

  PO(UART_UBUSY, UART_UBUSY,UARTFR,byte_cycles*8,busy);
  PI(5);
  PO(0, UART_UBUSY,UARTFR,byte_cycles*8,busy2);
  
 
  for(i=0; i<8; i++)
    {
      PSR(i,0x1f,UTDR,read);
    }
 
  /* Disable UART and all Interrupts */ 

  PSW(0x00, UARTCR_new);
  PSR(0x00 , UARTFR_MOD, UARTFR,uartfr59);
  PSW(0x00, UARTIMSC);

  /* To discard contents of fifo */
  ConfigureUbrlcr(divisor,0x00,UARTLCR_H_new);
  PI(5);
  
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTTXFIFO_EMPTY | UTRXFIFO_EMPTY, UTFR, empty);
  PO(UART_RXFE, UART_RXFE, UARTFR,some_cycles,wait);
  
  C("MSINT during reception");

  /* Disable UART  and Trickbox*/
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(divisor,hword,UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword,UTLCR_H);

  /* Enable UART  & RX , TX & MSINT Interrupts */
  PSW(cword, UTCR);
  PI(wait_factor * 2);
  PSW( cword, UARTCR_new);
  PSW(0x3F, UARTIMSC);
  for(i=0; i< 8; i++)
    {
      PSW(i, UTDR);
    }
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr61);

  /* Wait till there is something in the rx fifo */
  PO(UART_TXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr62);

  /* Set all Modem pins to value one */
  PSW(UT_SET_DSR | UT_SET_DCD | UT_SET_CTS | UT_SET_RI,UT_SET_PINS);
  PO(UART_TXFE, NoMask, UARTFR, some_cycles,uartfr63);

  /* Clear modem interrupts incase any have been asserted */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis27);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr31);

  PSR(UART_TXFE, NoMask, UARTFR,uartfr64);
  
  /* Assert DCD  */
  PSW(UT_RESET_DCD, UT_SET_PINS);
  PO(UART_TXFE | UART_DCD, NoMask, UARTFR, some_cycles,uartfr66);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis28);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr32);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis29);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr33);
    }
  
  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis30);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr34);
  PSR(UART_TXFE | UART_DCD, NoMask, UARTFR,uartfr67);
 
  /* Assert DSR */
  PSW(UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);
  PO(UART_TXFE | UART_DCD | UART_DSR , NoMask, UARTFR, some_cycles,uartfr69);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DSRMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis31);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr35);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis32);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr36);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis33);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr37);
  PSR(UART_DCD | UART_DSR | UART_TXFE , NoMask, UARTFR,uartfr70);

  /* Assert CTS */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD, UT_SET_PINS);
  PO(UART_DCD | UART_DSR | UART_CTS | UART_TXFE , NoMask, UARTFR, some_cycles,uartfr72);
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_CTSMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis34);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr38);
    }
  else
    {
      PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis35);
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr37);
    }
  
  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis36);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr38);
  PSR(UART_DCD | UART_DSR | UART_CTS | UART_TXFE , NoMask, UARTFR,uartfr73);
 
  /* Assert RI */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);
 
  PO(UART_DCD | UART_DSR | UART_CTS | UART_TXFE | UART_RI , NoMask , UARTFR, some_cycles,uartfr77);
  
  PI(2);
  if (mode == NORMAL_MODE)
    {
      PO(UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis37);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr38a_RI);
    }
  else
    {
      PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis38);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr37c_RI);
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis39);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr38d_RI);
  
  PSR(UART_DCD | UART_DSR | UART_CTS | UART_TXFE | UART_RI, NoMask, UARTFR,uartfr78);  
  
  PO(UART_RXMINT, UARTMIS_MASK, UARTMIS, (byte_cycles * 7),uartmis40);

  PSR(UART_TXFE | UART_DCD | UART_DSR | UART_CTS | UART_RI, NoMask, UARTFR,uartfr80);
 
  
  /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);
  PO(UART_TXFE , NoMask, UARTFR, some_cycles,uartfr82);
  PI(2);  
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT|UART_CTSMINT|UART_RIMINT| UART_RXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis41);
      PSR(UT_UARTINTR | UT_MSINT | UT_RXINT, UTIIR_MASK, UTIIR,utintr310);
    }
  else
    {
      PO(UART_RXMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis42);
      PSR(UT_UARTINTR| UT_RXINT, UTIIR_MASK, UTIIR,utintr311);
    }
  /* Read out all the data from the uart to empty the fifo */
  for(i=0; i < 8; i++)
    {
      expected_value = 0 | (i & masks[wlength]);
      PSR(expected_value, 0xfff, UARTDR,uartdr);
      if ( i < 7)
	{
	  PSR(UART_TXFE, NoMask, UARTFR,uartfr84);
	}
      else
	{
	  PSR(UART_TXFE | UART_RXFE, NoMask, UARTFR,uartfr85);
	}
      if (mode == NORMAL_MODE)
	{
	  PO(UART_DCDMINT|UART_DSRMINT|UART_CTSMINT|UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis43);
	  PSR(UT_UARTINTR | UT_MSINT , UTIIR_MASK, UTIIR,utintr311);
	}
      else
	{
	  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis44);
	  PSR(0x00 , UTIIR_MASK, UTIIR,utintr312);
	}
    }

  /* Clear interrupts */
  PSW(0x0f, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis45);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr313);
  PSR(UART_TXFE | UART_RXFE, NoMask, UARTFR,uartfr86);

  

  /* Check that writing '1' to the UARTICR Modem status bits doesn't set the interrupts */
  PSW(0x01, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis46);
  PSW(0x02, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis46);
  PSW(0x04, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis46);
  PSW(0x08, UARTICR);
  PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis46);

  
  PSR(UART_TXFE | UART_RXFE, NoMask, UARTFR,uartfr86a);

  /* Assert all modem lines */
  PSW(UT_RESET_CTS & UT_RESET_DSR & UT_RESET_DCD & UT_RESET_RI, UT_SET_PINS);
  
  PO(UART_DCD | UART_DSR | UART_CTS | UART_RI | UART_TXFE | UART_RXFE , NoMask, UARTFR, some_cycles,uartfr88);
  
  PI(2);
 
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT| UART_CTSMINT|UART_RIMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis50);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr314);
    }
  else
    {
      PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis51);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr315);
    }

  /* Check that writing '0' to the UARTICR doesn't clear the interrupts */

  PSW(0x00, UARTICR);
  PI(2);

  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT| UART_CTSMINT|UART_RIMINT , UARTMIS_MASK, UARTMIS, some_cycles,uartmis52);
      PSR(UART_DCDRINT|UART_DSRRINT| UART_CTSRINT|UART_RIRINT , UARTRIS_MASK, UARTRIS, some_cycles,uartris52);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr314a);
    }
  else
    {
      PO(0x00 , UARTMIS_MASK, UARTMIS, some_cycles,uartmis53);
      PSR(0x00 , UARTRIS_MASK, UARTRIS, some_cycles,uartris53);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr315a);
    }
        
    
  /* Disable TX & RX interrupts alone */
  PSW(0x0f, UARTIMSC);
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDMINT|UART_DSRMINT| UART_CTSMINT|UART_RIMINT, UARTMIS_MASK, UARTMIS, some_cycles,uartmis316);
      PSR(UT_UARTINTR | UT_MSINT, UTIIR_MASK, UTIIR,utintr316);
    }
  else
    {
      PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartmis317);
      PSR(0x00, UTIIR_MASK, UTIIR,utintr317);
    }

  /* Disable the MSINT */
  PSW(0x00,UARTIMSC);
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,uartiir318);
  PSR(0x00, UTIIR_MASK, UTIIR_MASK,utintr318);

  /* Set All Modem lines */
  PSW(UT_SET_CTS | UT_SET_DSR | UT_SET_DCD | UT_SET_RI, UT_SET_PINS);
  PO(UART_TXFE | UART_RXFE , NoMask, UARTFR, some_cycles,uartfr90);
  
  if (mode == NORMAL_MODE)
    {
      PO(UART_DCDRINT|UART_DSRRINT| UART_CTSRINT|UART_RIRINT, UARTRIS_MASK, UARTRIS, some_cycles,uartris316);
    }
  else
    {
      PO(0x00, UARTRIS_MASK, UARTRIS, some_cycles,uartris316);
    }
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis319);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr319);

  /* Disable UART and all Interrupts */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);
  PSW(0x00, UARTIMSC);

  /* Clear any modem Interrupts that are set */
  PSW(0x0f, UARTICR);
  PI(2);
  
  PSR(UART_TXFE | UART_RXFE, NoMask, UARTFR,uartfr92);

  PSW(0x18, UT_SET_PINS);
  
  PSR(UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTTXFIFO_EMPTY | UTRXFIFO_EMPTY,UTFR,test);
}


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
  int hword = 0x62,wlength;
  unsigned int cword=0;
  int32 byte_cycles,bit_cycles;
  unsigned long bit_width;
  int expected_value;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
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
  /* PI(10);  */

  /* Wait till the byte is fully transmitted and check for parity error */
  PO(UTTXBUSY, UTTXBUSY, UTFR, 32  *byte_cycles,poll1);
  PI(2);
  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrpe1);

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
  PSR(expected_value, 0xfff, UARTDR,uartdrpe2);

  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp6);

  /* Send character without a parity error, interrupt should still be set  */
  PSW(0, UT_FORCED_ERRS);
  PI(2);

  PSW(0x33, UTDR);
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x00 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrpe4);

  PSR(UART_PEMINT, UARTMIS_MASK, UARTMIS,peint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utp7);
 
  
  /* Send character with a parity error, interrupt should still be set */
  PSW(FORCED_PARITY_ERR, UT_FORCED_ERRS);

  PSW(0x77, UTDR);
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x77 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrpe5);

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
  PSR(expected_value, 0xfff, UARTDR,uartdrpe2);

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
  PSR(expected_value, 0xfff, UARTDR,uartdrpe4);
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,peint9);
  PSR(0x00, UTIIR_MASK,UTIIR,utp11);

  /* Character with parity error, interrupt should be set */
  PSW(FORCED_PARITY_ERR, UT_FORCED_ERRS);

  PSW(0x33, UTDR);
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x02 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrpe5);

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

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
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
  PI(0x10);
  
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
  PI(10); 

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
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x00 << 8) | (0x33 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrfe4);

  PSR(UART_FEMINT, UARTMIS_MASK, UARTMIS,feint4);
  PSR(UT_UARTEINTR|UT_UARTINTR, UTIIR_MASK,UTIIR,utf7);
 
  
  /* Send character with a framing error, interrupt should still be set */
  PSW(FORCED_FRAMING_ERR, UT_FORCED_ERRS);

  PSW(0x77, UTDR);
  PI(10);

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
  PI(10); 

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
  PI(10);

  PO(0x00 , UTTXBUSY, UTFR, 32  *byte_cycles,poll1);

  expected_value = (0x00 << 8) | (0x22 & masks[wlength]);
  PSR(expected_value, 0xfff, UARTDR,uartdrfe4);
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,peint9);
  PSR(0x00, UTIIR_MASK,UTIIR,utf11);

  /* Character with framing error, interrupt should be set */
  PSW(FORCED_FRAMING_ERR, UT_FORCED_ERRS);

  PSW(0x33, UTDR);
  PI(10);

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

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
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

/******************************************************************************/
/*************************** BreakTest ****************************************/
/******************************************************************************/

void BreakTest(void)
{
  /* 
     Summary: Break Error Tests
     ==========================
  
     The break error tests checks the transmit break function. Two bytes are
     written into the UART FIFO. After the UART just starts transmitting the 
     first byte, the break bit is set in the register UARTLCR_H of the UART.
     This will force LOW on the UARTTXD pin. The trickbox is disabled and
     UART break is released. And then Trickbox is enabled. The UART is allowed 
     to run till it stop transmitting. The data byte is then read from the 
     TrickBox data register. The transmission of first data byte should have been
     aborted and only the second byte in the fifo should have been transmitted
     after break is released

  */ 
 
  int i;
  int hword = 0x00,wlength;
  int32 some_cycles = 10;
  int32 byte_cycles ,bit_cycles,irda_bit_cycles, irda_lp_bit_cycles;
  unsigned int divisor = 0x01;
  unsigned long bit_width;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
 
  irda_bit_cycles = (unsigned long)(3 * (float)(bit_cycles / 16));
  irda_lp_bit_cycles = (unsigned long)((3 * (IRLP_DIV + 1) * UARTCLK_PERIOD) / PCLK_PERIOD);

  C("Break Tests : NORMAL MODE");

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Write Some data to the uart data register */
  PSW(0xff , UARTDR);

  PO(UART_TXFF | UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr1);

  /* Enable the trick box and the uart */
  PSW(0x01, UTCR); 
  PSW(0x301, UARTCR_new);
 
  Idle(bit_cycles * 2);

  PSW(DATA_As , UARTDR);

  /* Send Break character */
  PSW(0x01, UARTLCR_H);

  /* Disable the Trickbox */
  PSW(0x00, UTCR);
  
  PO(0x00, 0x01, UT_CHECK_PINS, wait_factor * some_cycles,poll1);

  for(i=0; i< 50; i++)
    {
      PSR(0x00, 0x01, UT_CHECK_PINS,utpin1);
      PI(0x02);
    }

  /* Release break */
  PSW(0x00, UARTLCR_H);

  PI( wait_factor * 4); 

  /* Enable the Trickbox */
  PSW(0x01, UTCR); 

  /* Check the value of TX pins */
  PO(0x01, 0x01, UT_CHECK_PINS, bit_cycles,poll2);

  PI(2);

  /* Wait till the byte is received by trickbox */
  PO(0x00, UTRXFIFO_EMPTY, UTFR, byte_cycles,uartfr3);


  PSR(DATA_As & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr);

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);


  C("Break Tests : IRDA Mode");

  PSW(0x33 , UARTDR);

  /* Enable the trick box and the uart in irda mode*/
  PSW(0x03, UTCR); 

  PSW(0x303, UARTCR_new);
  
  Idle(bit_cycles * 2);

  PSW(DATA_5s , UARTDR);

  /* Send Break character */
  PSW(0x01, UARTLCR_H);

  /* Disable the Trickbox */
  PSW(0x00, UTCR);

  PO(0x02, 0x02, UT_CHECK_PINS, bit_cycles,poll1);
  Idle(irda_bit_cycles + 1);
  PSR(0x00, 0x02, UT_CHECK_PINS,utpin1);

  for(i=0; i< 50; i++)
    {
      Idle(bit_cycles);
    }

  /* Release break */
  PSW(0x00, UARTLCR_H);

  Idle(bit_cycles);
  PI(0x2)
  
    /* Enable the Trickbox */
    PSW(0x03, UTCR);

  PO(0x00, UTRXFIFO_EMPTY, UTFR, byte_cycles,uartfr3);

  PSR(DATA_5s & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr);

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);

  C("Break Tests : IRDA LP Mode");

  PSW(0x33 , UARTDR);

  /* Enable the trick box and the uart in irda mode*/
  PSW(0x07, UTCR); 

  PSW(0x307, UARTCR_new);
   
  Idle(bit_cycles);

  PSW(DATA_5s , UARTDR);

  /* Send Break character */
  PSW(0x01, UARTLCR_H);

  /* Disable the Trickbox */
  PSW(0x00, UTCR);

  for(i=0; i< 50; i++)
    {
      Idle(bit_cycles);
    }

  /* Release break */
  PSW(0x00, UARTLCR_H);

  Idle(bit_cycles);

  /* Enable the Trickbox */
  PSW(0x07, UTCR);

  PO(0x00, UTRXFIFO_EMPTY, UTFR, byte_cycles,uartfr3);

  PSR(DATA_5s & masks[wlength], 0xff, UTDR,utdr);
  PSR(0, UTRSR_MASK, UTRSR,utrsr);

  /* Disable the uart and the trick box */
  PSW(0, UTCR);
  PSW(0, UARTCR_new);
}



/******************************************************************************/
/************************** AnotherRTISTest ***********************************/
/******************************************************************************/

void AnotherRTISTest(unsigned int divisor, enum op_mode mode)
{
  /*
    Summary: Receive Timeout Interrupt Tests
    ========================================
  
    The Uart and TrickBox are configured and enabled. As soon as Uart is enabled
    the data pin is driven low from the trickbox. The Recieve Timeout interrupt
    is checked after 32 bit period. It should has been asserted.

  */   
  
  int hword = 0x00,cword;
  int wlength;
  unsigned long bit_cycles,some_cycles = 10;
  unsigned long bit_width;
  int expected_value;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
 
  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    cword = 0x303;
  else if (mode == IRDA_LP_MODE)
    cword = 0x307; 
  
   /* Disable the uart and the trick box */
  PSW(0, UARTCR_new);
  PI(2);
  PSW(0, UTCR);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Enable the uart & RTIS interrupt - keep the trickbox disabled */
  PSW(0x40, UARTIMSC);
  PSW(cword, UARTCR_new);

  PI(20);

  /* Drive a low value on the RX/SIRIN line to make the uart believe it
     has started receiving data */
  if (mode == NORMAL_MODE)
    {
      PSW(0x07,UT_SET_PINS);
    }
  else
    {
      PSW(0x1f,UT_SET_PINS);
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, 20 * bit_cycles,poll1);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr);
 
  expected_value = (0x05 << 8) | (0x00);
  PSR(expected_value, 0xf00, UARTDR,uartdr1);

  PSW(0x40, UARTICR);

  expected_value = (0x05 << 8) | (0x00);
  PSR(expected_value, 0xf00, UARTDR,uartdr2);

  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,poll1);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr);

  /* Clean up the mess */
  PSW(0x0f,UT_SET_PINS);
  PI(3);

  /* Disable the uart */
  PSW(0x00, UARTCR_new);
  PSW(0X00, UARTIMSC);
}



/******************************************************************************/
/**************************** RTISTest ****************************************/
/******************************************************************************/

void RTISTest(unsigned int divisor, enum op_mode mode)
{
  /* 
     Summary: Recieve Time Out Interrupt Tests
     =========================================
  
     One Byte of data is transmitted from the trickbox to the UART. After this 
     byte has been completelely transmitted, the devices are kept enabled and 
     idle for 32 bit periods. The recieve time out must be get asserted only 
     after 32 bit periods, not before.

  */
 
  int i;
  int hword = 0x00,cword;
  int wlength;
  unsigned long bit_cycles, byte_cycles,some_cycles = 10;
  unsigned long bit_width;
  int expected_value;
  int value;
  
  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
 
  if (mode == NORMAL_MODE)
    cword = 0x301;
  else if (mode == IRDA_MODE)
    {
      cword = 0x303;
      PSW(0x1f, UT_SET_PINS);
    }
  else if (mode == IRDA_LP_MODE)
    cword = 0x307;

  /* Disable the uart and the trick box */
  PSW(0, UARTCR_new);
  PI(2);
  PSW(0, UTCR);
  PSW(0, UARTIMSC);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Clear any interrupts that have already been set */
  PSW(0x7ff, UARTICR);
  PI(2);
  
  /* Enable the uart, interrupts and trickbox */
  PSW(cword, UARTCR_new);
  PSW(0x40,UARTIMSC);
  PSW(cword, UTCR);

  PSW(0x66, UTDR);
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr11_f);

  PO(UART_RXFF | UART_TXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr12);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartiir11);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr,utintr11);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, bit_cycles,poll1a);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr);

  expected_value = 0 | (0x66 & masks[wlength]);
  PSR(expected_value, 0xf00, UARTDR,uartdr1);

  PSW(0x00, UARTECR); 
  
  expected_value = 0 | (0x00);
  PSR(expected_value, 0xf00, UARTDR,uartdr2);

  
  PO(0x00, UARTMIS_MASK, UARTMIS, some_cycles,poll1b);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr);

  /* Check interrupt is not set when Rx fifo is empty */
  PO(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR, byte_cycles,uartfr12_a);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartiir11_a);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr,utintr11_a);
      i += 2;
    }
  
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartintr12);
 
  PSR(0x00, UTIIR_MASK, UTIIR,utintr12);

  /* Generate interrupt, send more data and check that interrupt is not cleared */

   /* Disable the uart, interrupts and the trick box */
  hword = 0x70;
  PSW(0, UARTCR_new);
  PI(2);
  PSW(0, UTCR);
  PSW(0, UARTIMSC);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

    /* Enable the uart, interrupts and trickbox */
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);
  PSW(0x40,UARTIMSC);
  
  PSW(0x88, UTDR);
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr11_f);
  PI(2); 
     
  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartiir11_b);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr11_b);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll1_b);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr_b);

  PI(0x10);
  PSW(0x33, UTDR);
  PI(2);
  PO(UTTXFIFO_EMPTY,UTTXBUSY,UTFR,byte_cycles,utfr1);
  PI(100);
  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS,bit_cycles,uartintr13);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr13);
  PI(2);
  
  /* Write a 1 to bit 6 of UARTICR and check that interrupt is cleared */

  PSW(0x40, UARTICR);
  PI(10);
  PO(0x00,UARTMIS_MASK, UARTMIS, byte_cycles,poll3);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr3); 

  expected_value = 0 | (0x88 & masks[wlength]);
  PSR(expected_value, 0xf00, UARTDR,uartdr_3);
  expected_value = 0 | (0x33 & masks[wlength]);
  PSR(expected_value, 0xf00, UARTDR,uartdr_4);

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr12_g);

  PSR(0x00, UARTMIS_MASK, UARTMIS,uartdr_7);
  PSR(0x00, UTIIR_MASK, UTIIR,utdr_7);

  /* Transmit 16 words, cause interrupt and then read out 16 and check interrupt has cleared */

  for(i = 0; i < 16 ; i++)
    {
      value = i | (i << 4);
      PSW(value, UTDR);
    }

  PO(UART_RXFF | UART_TXFE, UARTFR_MASK, UARTFR,byte_cycles*16,uartdr_a); 
  
  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartiir11_b2);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr11_b2);
      i += 2;
    }
    
  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll1_b);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr_b);

  for(i = 0; i < 16 ; i++)
    {
      value = i | (i << 4);
      PSR(value, 0xff, UARTDR,uartdr_5);
      PI(2);
    }

  PI(2);

  PSR(0x00, UARTMIS_MASK, UARTMIS,uartdr_6);
  PSR(0x00, UTIIR_MASK, UTIIR,utdr_6);

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartdr_f);

  /* Check consecutive timeout errors being set */
  hword = 0x70;
  
  /* Disable the uart and the trick box */
  PSW(0, UARTCR_new);
  PI(2);
  PSW(0, UARTIMSC);

  /* Make sure everything inside UART will be disabled (due to
     synchronisation delays */
  PI(2);
  PSW(0, UTCR);
 
  /* Configure the uart and the trick box */
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);
  
  /* Enable the uart, interrupts and trickbox */
  PSW( cword, UARTCR_new);
  PSW(cword, UTCR);
  PSW(0x40, UARTIMSC);

  PSW(0x99, UTDR);
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr15_f);

  PO(0, UTTXBUSY, UTFR, byte_cycles,uartfr15);
  PI(2);
  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis12);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr,utintr12);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, bit_cycles,poll1);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr);

  PSW(0x40, UARTICR);
  PI(4);

  PO(0x00, UARTMIS_MASK, UARTMIS, bit_cycles,poll1);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr);

  /* generate 2nd interrupt */
  PSW(0x88, UTDR);

  PO(0, UTTXBUSY, UTFR, byte_cycles,uartfr16);
  PI(4);
    
  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis13);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr,utintr13);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll13);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr);

  PSW(0x40, UARTICR);
  PI(2);

  PSR(0x99, UARTDR_MASK, UARTDR,uartdr13);
  PI(2);
  PSR(0x88, UARTDR_MASK, UARTDR,uartdr13a);
  PI(2);


  /* Check that writing '0' to the UARTICR doesn't clear the interrupts */
  PSW(0x22, UTDR);
  PI(2);
  PSW(0x44, UTDR);
  PI(2);
      
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr17_f);

  PO(0, UTTXBUSY, UTFR, byte_cycles,uartfr16);
  PI(2);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis14);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr,utintr14);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll14);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr);

  PSW(0x00, UARTICR);
  PI(2);
  PSR(UART_RTMINT, UARTMIS_MASK, UARTMIS,poll15b);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr15b);

  /* Check that disabling the interrupt clears the interrupt signal */

  PSW(0, UARTIMSC);
  PI(4);
  PSR(0, UARTMIS_MASK, UARTMIS,poll15b);

  PSW(0x40, UARTIMSC);
 
  /* Empty fifo */
  PSR(0x22, UARTDR_MASK, UARTDR,uartdr15);
  PSR(0x44, UARTDR_MASK, UARTDR,uartdr15a);
 
  PI(4); 
  PSR(0x00 , UARTMIS_MASK, UARTMIS,poll15);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr15);
  
  /* generate and clear again */
  PSW(0x22, UTDR);
  PI(2);
  PSW(0x44, UTDR);
  PI(2);
      
  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,uartfr17_f);

  PO(0, UTTXBUSY, UTFR, byte_cycles,uartfr16);
  PI(2);

  for(i = 0; i < (31 * bit_cycles); )
    {
      PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis14);
      i += 2;
      PSR(0x00 , UTIIR_MASK, UTIIR,utintr,utintr14);
      i += 2;
    }

  PO(UART_RTMINT, UARTMIS_MASK, UARTMIS, byte_cycles,poll14);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr);

  PSW(0x00, UARTICR);
  PI(2);
  PSR(UART_RTMINT, UARTMIS_MASK, UARTMIS,poll15b1);
  PSR(UT_RTISINT | UT_UARTINTR, UTIIR_MASK, UTIIR,utintr15b);

  /* Clear interrupts */
  PSR(0x22, UARTDR_MASK, UARTDR,uartdr15);
  PSR(0x44, UARTDR_MASK, UARTDR,uartdr15a);
 
  PI(4); 
  PSR(0x00 , UARTMIS_MASK, UARTMIS,poll15);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr15);

  /* Check that writing a '1' to the UARTICR Rx timeout bit doesn't set the interrupt */
  PSW(0x40, UARTICR);
  PI(4);
  PSR(0x00 , UARTMIS_MASK, UARTMIS,poll15c);
  PSR(0x00, UTIIR_MASK, UTIIR,utintr15c);

  
 /* Clean up the mess */
  PI(4);
   
  PSW(0x00, UTCR);
  PSW(0x00, UARTCR_new);

  PSW(0x0f,UT_SET_PINS);
  PI(3);

  /* Disable the uart */
  PSW(0x00, UARTCR_new);
  PSW(0,UARTIMSC);
}




/******************************************************************************/
/****************************** HalfDuplexTest ********************************/
/******************************************************************************/

void HalfDuplexTest(unsigned int divisor,enum op_mode mode)
{
  /*
    Summary: Half Duplex Tests
    ==========================
  
    These tests check the Half Duplex property of the UART in the IrDA mode.
    Some data bytes are written into the UART's Tx Fifo and UART is enabled
    to start transmission. After some time, data bytes are written into
    trickbox Tx fifo to cause serial data transfer over the RXD line. The
    UART should ignore all these bytes as long as transmission is active.
    This is done by checking the RXFE flag of the UART. It must remain set 
    throughout the test.

  */

  int i,j,reg_val, wlength;
  int hword = 0x10, cword = 0x00;
  int32 byte_cycles,bit_cycles,some_cycles = 10;
  unsigned long bit_width;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX((int32)(bit_width / PCLK_PERIOD),1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;

  if (mode == IRDA_MODE)
    cword = 0x303;

  else if (mode == IRDA_LP_MODE)
    cword = 0x307;

  /* Disable the UART & trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  ConfigureUbrlcrTr(divisor,hword, UTLCR_H);

  /* Enable the UART & trickbox*/
  PSW(cword, UARTCR_new);
  PSW(cword, UTCR);

  /* Write some data to the uart to start transmitting */
  for(i=0; i< 5; i++)
    {
      reg_val = (i | (i << 4));
      PSW(reg_val, UARTDR);
    }

  /* Check flags  to make sure that transmission is going on */
  PO(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR, some_cycles,uartfr1);

  /* Now write some data to the trickbox to wiggle the RX line */
  PSW(DATA_As, UTDR);

  for(i=0; i< byte_cycles; i++)
    {
      PSR(UART_RXFE | UART_UBUSY, UARTFR_MASK, UARTFR,uartfrloop);
    }

  PO(0x0, UART_UBUSY, UARTFR, 4*byte_cycles,halfdup1); 

  /* Disable the UART & trickbox */
  PSW(0x00, UARTCR_new);
  PSW(0x00, UTCR);

}

/******************************************************************************/
/*************************** ScanModeTest *************************************/
/******************************************************************************/

void ScanModeTest(void)
{
  /*
    Summary: Scan Mode Test
    =======================

    This test is for validating the UART scan test hold input. In this, Two
    known data patterns are written into two writable register. A test reset 
    is asserted by setting and clearing the TESTRST bit in the UARTTCR of the
    UART. After this test reset, the two writable registers should be reset to
    their reset values. Now the same test is conducted with SCANMODE pin, 
    driven HIGH. This time the two register should retain the two known data
    patterns.
  
  */

  /* Write some data to two r/w registers */
  PSW(DATA_As, UARTCR_new);
  PSW(DATA_5s, UARTILPR);

  /* Assert Test reset */
  PSW(UART_TESTRST, UARTTCR);

  /* Deassert Test reset in next cycle */
  PSW(0x00, UARTTCR);

  PSR(0x300, UARTCR_newMASK, UARTCR_new,uartcr_new1);
  PSR(0x00, UARTILPR_MASK, UARTILPR,uartilpr1);

  /* Now conduct the same test with scanmode asserted */

  /* Assert Scanmode pin */
  PSW(UT_SET_SCANMODE , UT_SET_PINS);

  /* Write some data to two r/w registers */
  PSW(DATA_As, UARTCR_new);
  PSW(DATA_5s, UARTILPR);

  /* Assert Test reset */
  PSW(UART_TESTRST, UARTTCR);

  /* Deassert Test reset in next cycle */
  PSW(0x00, UARTTCR);

  PSR(DATA_As & UARTCR_newMASK, UARTCR_newMASK, UARTCR_new,uartcr_new2);
  PSR(DATA_5s & UARTILPR_MASK, UARTILPR_MASK, UARTILPR,uartilpr2);

  /* Clean up */

  PSW(IRLP_DIV, UARTILPR);
  PSW(IRLP_DIV, UTILPR);
  PSW(0x00, UARTCR_new);
  PSW(0x0f, UT_SET_PINS);

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

  PSW(word,hword_address - 4);
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
 
  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
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

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
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
  PSR(0x28, UARTTOCRmodem_MASK,UARTTOCR,uarttocr_lb1);
  PSR(0x00,masks[3],UARTFR,uartfr_lb);
  PSR(0x14,0x3C,UT_CHECK_PINS,utcheckpins_lb1); 
  PI(2);
   
  PSW(0x1401, UARTCR_new);
  PI(2); 
  PSR(0x50,UARTTOCRmodem_MASK,UARTTOCR,uarttocr_lb2); 
  
  PSR(0x00,UARTFR_MOD,UARTFR,uartfr_lb2);
   
  PSR(0x28,0x3C,UT_CHECK_PINS,utcheckpins_lb2); 

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

/******************************************************************************/
/************************* BoundaryTests **************************************/
/******************************************************************************/

void BoundaryTests(void)
{
  /*
    Summary: BoundaryTests
    ======================

    It contains the test for some boundary conditions which are very unlikely 
    to occur. These tests are frequency dependent so are being disabled in case
    of different UARTCLK and PCLK.
    The first test is to read and write the UART FIFO at the same time. This 
    is being done by manually counting the PCLK cycles between one write and 
    subsequent read. Thus, this is frequency dependent test.
    Another test is conducted for abort operation at different phases of 
    transmission and reception. All these tests are being conducted in 
    loopback mode.
  
  */ 
  int hword;
  unsigned int divisor;

  int i = 0,j, reg_val;
  int wlength;
  int32 bit_cycles, byte_cycles;
  int32 some_cycles = 10;
  int cword = 0x00;
  unsigned long bit_width;
 
  divisor = 0x03;
  hword = 0x7e;

  bit_width = 16 * (divisor + 1) * UARTCLK_PERIOD;
  bit_cycles = MAX(bit_width / PCLK_PERIOD,1);
  wlength = ((hword & 0x60) >> 5) + 5;
  byte_cycles = (wlength + 6)  * bit_cycles;
  cword = 0x381;

  PSW(0, UTCR);
  PSW(0, UARTCR_new);
  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);

  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_r);
 
  PSW(cword, UARTCR_new);
  
  C("Boundary Condition Test: Read And Write At Same Time In FIFO");

  for(i = 0; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
    }
 
  PO( 0 , UART_UBUSY, UARTFR,(byte_cycles*i),poll11);
 
  for(i=0; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xff, UARTDR,utdrlast);
      PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast);
    }

  PSW(0xff, UARTDR);
  P_IDLE(710); 
  PSW(0xff, UARTDR);
  PO( 0 , UART_UBUSY, UARTFR,(byte_cycles*2),poll11);
  PSR(0xff, 0xff, UARTDR,utdrlast);
  PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast);
  PSR(0xff, 0xff, UARTDR,utdrlast);
  PSR(0x00,UTRSR_MASK,UTRSR,utrsrlast);
  
  PSW(0x0, UARTCR_new); 
  hword = 0x6e;
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(cword, UARTCR_new);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_s);

  PSR(0xff, 0xfff, UARTDR, uartbound);
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_z);
  

  cword = 0x381;
  C("Abort Transmit And Recieve Test: At Start Bit:Illegal Baud");

  /* Disable Uart */
  PSW(0, UARTCR_new);
  
  /* check Tx and Rx fifos are empty */
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_zb);
  
  /* Enable UArt */
  PSW(cword, UARTCR_new);

  /* configure Uart to cause a break condition */
  hword = 0x6f;
  ConfigureUbrlcr(0x0,hword, UARTLCR_H_new);
  P_IDLE(byte_cycles*2);

  /* write data to tx fifo */
  PSW(0x99, UARTDR);

  /* data is not transmitted but kept in Tx fifo */
  PSR(UART_UBUSY |  UART_TXFF | UART_RXFF, UARTFR_MASK, UARTFR,uartzc);

  /* reconfigure uart to remove break condition */
  hword = 0x6e;
  ConfigureUbrlcr(0x0,hword, UARTLCR_H_new);
  P_IDLE(byte_cycles*2);

  /* make sure that data was not transmitted */
  PSR(0x00, 0xff, UARTDR,uartdra1);

  /* write word to tx fifo */
  PSW(0x66, UARTDR);

  PO(0,UART_UBUSY,UARTFR,byte_cycles,uartfrzd);
  
  PSR( UART_TXFE | UART_RXFF, UARTFR_MASK, UARTFR,uartze);

  /* read transmitted data */
  PSR(0x66, 0xff, UARTDR,uartdra);

  
  C("Abort Transmit And Recieve Test: At Stop Bit:Illegal Baud");
  /* Disable Uart */
  PSW(0, UARTCR_new);
  
  /* check Tx and Rx fifos are empty */
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr11_zb);
  
  /* Enable Uart */
  PSW(cword, UARTCR_new);

  PSW(0x99, UARTDR);
  PI(0x0a);
  P_IDLE(10*bit_cycles);
  
  /* configure Uart to cause a break condition */
  hword = 0x6f;
  ConfigureUbrlcr(0x0,hword, UARTLCR_H_new);
  P_IDLE(byte_cycles*2);

  /* data word will continue to be transmitted */
  PSR(0x99, 0xff, UARTDR,uartfr12_zb);

  /* write 2nd word to tx fifo - this should not be transmitted */
  PSW(0x44, UARTDR);
  PI(0x0a);

  PO(0, UART_UBUSY, UARTFR_MASK, byte_cycles,stopbit);
  PSR(0x99, 0xff, UARTDR,uartfr12_zc);

  /* configure uart to remove break bit */
  hword = 0x6e;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  
  PO(0,UART_UBUSY, UARTFR,byte_cycles,stopbit2);
  PSR(0x44, 0xff, UARTDR,uartfr12_zd);


  C("Abort Transmit And Recieve Test:At Extra Stop Bit:Illegal Baud");
  /* Disable Uart */
  PSW(0, UARTCR_new);
  
  /* check Tx and Rx fifos are empty */
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13_zb);
  
  /* Enable Uart */
  PSW(cword, UARTCR_new);

  PSW(0x55, UARTDR);
  PI(0x0a);

  P_IDLE(bit_cycles*11);
  
  /* configure Uart to cause a break condition */
  hword = 0x6f;
  ConfigureUbrlcr(0x0,hword, UARTLCR_H_new);
  P_IDLE(byte_cycles*2);

  /* data word will continue to be transmitted */
  PSR(0x55, 0xff, UARTDR,uartfr13_zb);

  /* write 2nd word to tx fifo - this should not be transmitted */
  PSW(0x77, UARTDR);
  PI(0x0a);

  PO(0, UART_UBUSY, UARTFR_MASK, byte_cycles,stopbit);
  PSR(0x55, 0xff, UARTDR,uartfr13_zc);

  /* configure uart to remove break bit */
  hword = 0x6e;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  
  PO(0,UART_UBUSY, UARTFR,byte_cycles,stopbit2);
  PSR(0x77, 0xff, UARTDR,uartfr13_zd);


  C("Abort Transmit And Recieve Test: At Parity Bit:Illegal Baud");
  /* Disable Uart */
  PSW(0, UARTCR_new);
  
  /* check Tx and Rx fifos are empty */
  PSR( UART_TXFE | UART_RXFE, UARTFR_MASK, UARTFR,uartfr13_zb);
  
  /* Enable Uart */
  PSW(cword, UARTCR_new);

  PSW(0x11, UARTDR);
  PI(0x0a);

  P_IDLE(bit_cycles*9);
  
  /* configure Uart to cause a break condition */
  hword = 0x6f;
  ConfigureUbrlcr(0x0,hword, UARTLCR_H_new);
  P_IDLE(byte_cycles*2);

  /* data word will continue to be transmitted */
  PSR(0x11, 0xff, UARTDR,uartfr13_zb);

  /* write 2nd word to tx fifo - this should not be transmitted */
  PSW(0x22, UARTDR);
  PI(0x0a);

  PO(0, UART_UBUSY, UARTFR_MASK, byte_cycles,stopbit);
  PSR(0x11, 0xff, UARTDR,uartfr13_zc);

  /* configure uart to remove break bit */
  hword = 0x6e;  
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  
  PO(0,UART_UBUSY, UARTFR,byte_cycles,stopbit2);
  PSR(0x22, 0xff, UARTDR,uartfr13_zd);


  PSW(0, UARTCR_new);
  PSW(0, UTCR);
}


/******************************************************************************/
/************************* FIFO Tests ** **************************************/
/******************************************************************************/

void FifoTests(void)
{
  /*
  Summary: Fifo Tests
  ======================

  These tests check the extra test functionality that allows data to be read from
  the Tx fifo and to be written to the Rx fifo. Data is written to the Tx fifo and
  then read from UARTTDR, then data is written to UARTTDR and read out of the Rx
  fifo.
  The fifo interrupt level tests check the Rx and Tx interrupts by setting the
  watermark to be all the different levels for both the Tx and Rx.
  The clearing of the Transmit and Receive interrupts is also tested by writing to
  the relevant bit in the Interrupt Clear register.
   */

  int i = 0,j, reg_val;
  int32 some_cycles = 10;
  int cword = 0x301;
  int hword = 0x10;
  
  C("FIFO Test");

  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);

  C("RX Fifo Test");

  PSW(cword,UARTCR_new);

    /* Enable test fifo mode */
  PSW(0x20, UARTTCR);
  PI(2);

   /* Write 16 words into Rx fifo, check that the fifo is full, then read them back
      out and check that the Rx fifo is empty and that the Tx fifo remains empty */
   
  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PI(0x05);
  PSR(UART_RXFF | UART_TXFE, UARTFR_MASK, UARTFR, uarttdr5);  
    
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,uarttdr4);
      PI(0x03);
    }
  PSR(UART_TXFE | UART_RXFE,UARTFR_MASK,UARTFR, uarttdr6);


   /* Disable Test fifo mode and check that data is not written to fifo */
  PSW(0x0, UARTTCR);
  PI(0x05);
  PSW(0x33, UARTTDR,uarttdr3);
  PI(0x02);
  PSR(0x00, 0xfff,UARTDR,uarttdr4);
  PI(0x02);
   
  C("RX Fifo Interrupt level Test");
  
  /* RX Fifo level 1/8th */
  cword = 0x201;
   
  /* Disable, configure and enable Uart */
  PSW(0,UARTCR_new);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(cword,UARTCR_new);
  PSW(0x20, UARTTCR);

  /* Keep Interrupts Disabled */
  PSW(0, UARTIMSC);

  /* Program the Rx fifo interrupt to be 1/8th full */
  PSW(UART_RXFEIGHT, UARTIFLS);
  PI(0x05);

  /* Both interrupts will not be set */
  PSR(0x00, UART_RXRINT, UARTRIS,rxlevel01);
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel0);
  
  /* Write 1 word into the Rx fifo and interrupt will still not be set */
  PSW(0x22, UARTTDR);
  PI(2);
  PSR(0x00, UART_RXRINT, UARTRIS,rxlevel01a);
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel0b);

  /* Write 1 more word and the raw interrupt will be set but the masked interrupt
     will not until the interrupt is enabled */
  PSW(0x33, UARTTDR);
  PI(2);
  PSR(UART_RXRINT, UART_RXRINT, UARTRIS,rxlevel01b);
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel0b);
  PSW(0x3f, UARTIMSC);
  PSR(UART_RXRINT, UART_RXRINT, UARTRIS,rxlevel02);  
  PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel0a);
  
   /* Read out a  word and check that Rx interrupt is cleared */
  PSR(0x22, 0xfff, UARTDR, rxlevel3);
  PI(0x02); 
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel03);

  /* Write a word to set it again */
  PSW(0x55, UARTTDR);
  PI(2);
  PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel0ac);
  
  /* Write to bit 4 of the interrupt clear reg to clear it */
  PSW(0x10, UARTICR);
  PI(2);
  PSR(0, UART_RXMINT, UARTMIS,rxlevel04);

  /* Read 2 words out to empty the fifo */
  PSR(0x33, 0xfff, UARTDR, rxlevel3a);
  PI(0x02); 
  PSR(0x55, 0xfff, UARTDR, rxlevel3b);
  PI(0x02); 
  PSR(0x00, UART_RXMINT, UARTMIS,rxlevel0b);

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR, rxlevel5a);

   
   /* RX Fifo level Quarter */
   
  /* Program the Rx fifo interrupt to be set when the fifo is quarter full */
  PSW(UART_RXFQUART, UARTIFLS);
  PI(0x05);

   /* Write 3 words into Rx fifo, RXINTR should not be set */
  for(i = 0; i < 3; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(0, UART_RXMINT, UARTMIS,rxlevel6);
    }
 
  PI(0x02);

    /* Write another word which should set interrupt, and fill fifo checking that
       the interrupt remains set */
  for(i = 3; i< 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel7);
    }

  /* Read out 12  words  which should keep interrupt set */
  for(i=0; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel8);
      PI(0x03);
      PSR(UART_RXMINT,UART_RXMINT,UARTMIS,rxlevel9);
    }
      
  /* Read out 1 word to clear the interrupt and then empty fifo with no interrupt
	 being set */
  for(i=12; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel8);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxlevel9);
    }
      
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel12);


  /* RX Fifo level Half */
   
  /* Program the Rx fifo interrupt to be set when the fifo is half full */
  PSW(UART_RXFHALF, UARTIFLS);
  PI(0x05);

   /* Write 7 words into Rx fifo, RXINTR should not be set */
  for(i = 0; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PSR(0, UART_RXMINT, UARTMIS,rxlevel13);
  PI(0x02);

  /* Write another word which should set interrupt, and 2 more words whch should
       keep interrupt set */
  for(i = 7; i< 10; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel14);
    }

  /* Read out 2  words  which should keep interrupt set */
  for(i=0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel15);
      PI(0x03);
      PSR(UART_RXMINT,UART_RXMINT,UARTMIS,rxlevel16);
    }

  /* Read out 1  word  which should remove interrupt, and empty fifo - interrupt should
       stay low */
  for(i=2; i < 10; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel15);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxlevel16);
    }
      
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel19);


/* RX Fifo level Three quarters */
   
  /* Program the Rx fifo interrupt to be set when the fifo is three quarters full */
  PSW(UART_RXF3QUART, UARTIFLS);
  PI(0x05);

   /* Write 11 words into Rx fifo, RXINTR should not be set */
  for(i = 0; i < 11; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PSR(0, UART_RXMINT, UARTMIS,rxlevel20);
  PI(0x02);

  /* Write another word which should set interrupt, and 3 more words whch should
       keep interrupt set */
  for(i = 11; i< 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel21);
    }

  /* Read out 3 words which should keep interrupt set */
  for(i=0; i < 3; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel22);
      PI(0x03);
      PSR(UART_RXMINT,UART_RXMINT,UARTMIS,rxlevel23);
    }
  

  /* Read out 1 word which should remove interrupt, then empty fifo which should
       keep it low */
  for(i=3; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel24);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxlevel25);
    }

  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel26);
     

/* RX Fifo level seven eighths full */
   
  /* Program the Rx fifo interrupt to be set when the fifo is seven eighths
     full */
  PSW(UART_RXF7EIGHT, UARTIFLS);
  PI(0x05);

   /* Write 13 words into Rx fifo, RXINTR should not be set */
  for(i = 0; i < 13; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PSR(0, UART_RXMINT, UARTMIS,rxlevel20);
  PI(0x02);

  /* Write another word which should set interrupt */
  for(i = 13; i< 14; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel21);
    }

  /* Write 2 more to fill fifo and interrupt should remain */
  for(i = 14; i< 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
      PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxlevel21);
    }

   PSR(UART_RXFF | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel26);
 
  /* Read out 3 words  which should remove interrupt, and empty fifo which should
       keep it low */
  for(i=0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel22);
      PI(0x03);
      PSR(UART_RXMINT,UART_RXMINT,UARTMIS,rxlevel23);
    }

  for(i=2; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxlevel22);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxlevel23);
    }

  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxlevel26);
 
  C("TX Fifo Test");

  cword = 0x201; 
  PSW(0, UARTCR_new);
    
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);

  PSW(cword,UARTCR_new);

  /* Enable Test fifo mode */
  PSW(0x20, UARTTCR);


  /* Write 16 words into Tx fifo, check that the fifo is full, then read them back out
     and check that the Tx fifo is empty and that the Rx fifo remains empty */
   
  for(i = 0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
    }
 
  PI(0x05);
  PSR(UART_RXFE | UART_TXFF | UART_UBUSY, UARTFR_MASK, UARTFR, uartdrt5);  
    
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,uarttdr4);
      PI(0x01);
    }
  PSR(UART_TXFE | UART_RXFE,UARTFR_MASK,UARTFR, uartdrt6);
   

   /* Disable Test fifo mode and check that data is not read out of fifo */
  PSW(0x0, UARTTCR);
  PSW(0x88, UARTDR,uartdrt3);

  PSR(0x00, UARTTDR_MASK, UARTTDR,uartdrt2a);
  PSW(0x00,UARTCR_new);

   /* empty fifo */
  PSW(0x20, UARTTCR);
  PI(0x02);
  PSR(0x88, UARTTDR_MASK, UARTTDR,uartdrt2b);
  PI(0x02);
  PSR(UART_TXFE | UART_RXFE,UARTFR_MASK,UARTFR, uartdrt6a);


  C("TX Fifo Interrupt level Test");
  
   /* Tx Fifo level one eighth */

  cword = 0x201;
   
  /* Disable, configure and enable Uart */
  PSW(0,UARTCR_new);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(cword,UARTCR_new);
  PSW(0x20, UARTTCR);

   /* Program the Tx fifo interrupt to set when the fifo is one eighth full,
      first with the interrupt disabled and then enable the interrupt */

  PSW(0x00, UARTIMSC);
  PSW(UART_TXFEIGHT, UARTIFLS);
  PI(0x05);
  PSR(UART_TXRINT , UART_TXRINT, UARTRIS,txlevel0a);  
  PSR(0, UART_TXMINT, UARTMIS,txlevel0);

  PSW(0x3f, UARTIMSC);
  PSR(UART_TXRINT , UART_TXRINT, UARTRIS,txlevel0b);  
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel0c);
  
 
  /* Write 4 words of data into Tx fifo and see that Tx interrupt is not set
     on or after the 2nd word */
  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(2);
      if (i<2)
	{
	  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel1);
	}
      else
	{
	  PSR(0, UART_TXMINT, UARTMIS,txlevel1);
	}
    }
  /*  Read out 2 words, then the interrupt should be set */
  for(i=0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,uarttdr2);
      PI(2);
    }
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel3);

  /* Read out the last 2 words and check that Tx interrupt is  set */
  for(i=2; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,uarttdr4);
      PI(2);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel5);
    }

  PSR(UART_RXFE | UART_TXFE, UARTFR_MASK, UARTFR,txlevel6);


     /* TX Fifo level Quarter */
   
  /* Program the Tx fifo interrupt to be set when the fifo is quarter full or less */
  PSW(UART_TXFQUART, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel7);

  /* Write 4 words into Tx fifo, TXINTR should still be set */
  for(i = 0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel8);
      PI(0x02);
    }

  /* Write in 5 words to remove interrupt and keep it removed */ 
  for(i=4; i < 9; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(0,UART_TXMINT,UARTMIS,txlevel9);
    }
      
  /* Read out 4 words and interrupt will remain low */
  for(i=0; i < 4; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel10);
      PI(0x03);
      PSR(0, UART_TXMINT, UARTMIS,txlevel11);
    }
      
  /* Read out 1 word to set interrupt, then empty fifo and interrupt will remain set */
  for(i=4; i < 9; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel12);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel13);
    }
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,txlevel14);
      

     /* TX Fifo level Half */
   
  /* Program the Tx fifo interrupt to be set when the fifo is half full or less */
  PSW(UART_TXFHALF, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel15);

  /* Write 8 words into Tx fifo, TXINTR should still be set */
  for(i = 0; i < 8; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel16);
      PI(0x02);
    }

  /* Write in 8 words to remove interrupt and keep it removed */ 
  for(i=8; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(0,UART_TXMINT,UARTMIS,txlevel17);
    }
      
  /* Read out 7 words and interrupt will remain low */
  for(i=0; i < 7; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel18);
      PI(0x03);
      PSR(0, UART_TXMINT, UARTMIS,txlevel19);
    }
  /* Read out 1 word to set interrupt, then empty fifo and interrupt will remain set */
  for(i=7; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel20);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel21);
    }
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,txlevel22);


     /* TX Fifo level three quarters */
   
  /* Program the Tx fifo interrupt to be set when the fifo is three quarters full or less */
  PSW(UART_TXF3QUART, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel23);

  /* Write 12 words into Tx fifo, TXINTR should still be set */
  for(i = 0; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel24);
      PI(0x02);
    }

  /* Write in 3 words to remove interrupt amd keep it removed */ 
  for(i=12; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(0,UART_TXMINT,UARTMIS,txlevel25);
    }
      
  /* Read out 2 words and interrupt will remain low */
  for(i=0; i < 2; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel26);
      PI(0x03);
      PSR(0, UART_TXMINT, UARTMIS,txlevel27);
    }
  
  /* Read out 1 words to set interrupt, then empty fifo and interrupt will remain set */
  for(i=2; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,txlevel28);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel29);
    }
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,txlevel30);


   /* TX Fifo level seven eighth full */
   
  /* Program the Tx fifo interrupt to be set when the fifo is seven eighth full */
  PSW(UART_TXF7EIGHT, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel20);
 
  /* Write 14 words into Tx fifo, TXINTR will be set */
  for(i = 0; i < 14; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel21);
      PI(0x02);
    }

  /* Write in 1 word to clear interrupt */ 
  for(i=14; i < 15; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(2);
      PSR(0,UART_TXMINT,UARTMIS,txlevel22);
    }

  /* Read out 1 word to set interrupt */
  i = 0;
  reg_val = i | (i << 4);
  PSR(reg_val, 0xfff, UARTTDR,txlevel23);
  PI(2);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel24);

  /* Write to bit 5 of the interrupt clear reg to clear it */

  PSW(0x20, UARTICR);
  PI(2);
  PSR(0,UART_TXMINT,UARTMIS,txlevel22a);
 
  /* Check still clear */
  PI(4);
  PSR(0,UART_TXMINT,UARTMIS,txlevel22b);


  /* set interrupt again by writing  and reading another word */

  i = 15;
  reg_val = i | (i << 4);
  PSW(reg_val, UARTDR);
  PI(0x03);
  PSR(0,UART_TXMINT,UARTMIS,txlevel22a);

  i = 1;
  reg_val = i | (i << 4);
  PSR(reg_val, 0xfff, UARTTDR,txlevel23);
  PI(2);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel24a);
  
  /* fill fifo and check interrupt still cleared */
   for(i=16; i < 18; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
      PSR(0,UART_TXMINT,UARTMIS,txlevel25);
    }

  PI(0x03);
  PSR(0,UART_TXMINT,UARTMIS,txlevel22a);
 
  PSR(UART_RXFE | UART_TXFF| UART_UBUSY,UARTFR_MASK,UARTFR,txlevel25b);

  
  /* Read out 2 word to set interrupt, then empty fifo */
  for(i=2; i <18; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xff, UARTTDR,txlevel23);
      PI(2);
      if (i<3)
	{
	  PSR(0, UART_TXMINT, UARTMIS,txlevel24b);
	}
      else
	 {
	   PSR(UART_TXMINT, UART_TXMINT, UARTMIS,txlevel24b);
	 }
    }
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,txlevel25);


  C("RX and TX Fifo Interrupt level Test");

  /* Program the Tx fifo interrupt to be set when the fifo is quarter full and the
      Rx fifo interrupt to be set when the fifo is three quarters full  */
  PSW(UART_TXFQUART | UART_RXF3QUART, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,rxtx1);

  /* Write 5 words into Tx fifo, TXINTR should still be removed */
  for(i = 0; i < 5; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
    }
  PSR(0, UART_TXMINT, UARTMIS,rxtx2);

   /* Write 12 words into Rx fifo, RXINTR should be set */
  for(i = 0; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTTDR);
      PI(0x03);
    }
 
  PSR(UART_RXMINT, UART_RXMINT, UARTMIS,rxtx3);
  PI(0x02);

    
  /* Read out 1 word to set interrupt, then empty Tx fifo and interrupt will remain set */
  for(i=0; i < 5; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTTDR,rxtx4);
      PI(0x03);
      PSR(UART_TXMINT, UART_TXMINT, UARTMIS,rxtx5);
    }
      
  /* Read out 1 words which should clear interrupt, and empty fifo keeping it low  */
  for(i=0; i < 12; i++)
    {
      reg_val = i | (i << 4);
      PSR(reg_val, 0xfff, UARTDR,rxtx6);
      PI(0x03);
      PSR(0,UART_RXMINT,UARTMIS,rxtx7);
    }

  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,rxtx8);


  C("RX and TX Fifo Interrupt level Test with xmission");

  cword = 0x3B1;
  divisor = 0x03;
  hword = 0x7e;
  PSW(0,UARTCR_new);
  ConfigureUbrlcr(divisor,hword, UARTLCR_H_new);
  PSW(0x00, UARTTCR);
  PSW(cword,UARTCR_new);

   /* Program the Tx fifo interrupt to be set when the fifo is quarter full and the
      Rx fifo interrupt to be set when the fifo is three quarters full  */
  PSW(UART_TXFQUART | UART_RXF3QUART, UARTIFLS);
  PI(0x05);
  PSR(UART_TXMINT, UART_TXMINT, UARTMIS,lb1);
   
  PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,lb5a);

      /* Write 16 words into Tx fifo  */ 
  for(i=0; i < 16; i++)
    {
      reg_val = i | (i << 4);
      PSW(reg_val, UARTDR);
      PI(0x03);
    } 

  PO(UART_TXMINT,UART_TXMINT | UART_RXMINT ,UARTMIS,(byte_cycles*11),lb2);
  PO(UART_TXMINT | UART_RXMINT,UART_TXMINT | UART_RXMINT ,UARTMIS,(byte_cycles*1),lb3);

  /* Check that writing '0' to the UARTICR register doesn't clear the interrupts */
  PSW(0x00, UARTICR);
  PI(2);
  PSR(UART_TXMINT | UART_RXMINT,UART_TXMINT | UART_RXMINT ,UARTMIS,lb3);

  PO(0,UART_UBUSY, UARTFR,(byte_cycles*12,lb6);
       
     /* Read out the received data */
     for(i=0; i < 16; i++)
     {
       reg_val = i | (i << 4);
       PSR(reg_val, 0xfff, UARTDR,lb4);
       PI(0x03);
     }
    
     PSR(UART_RXFE | UART_TXFE,UARTFR_MASK,UARTFR,lb5);

     /* Clear any interrupts that have been set */

     PSW(0x7ff, UARTICR);
     PI(4);
     PSR(0, UARTMIS_MASK, UARTMIS,read);
     PSW(0x00, UARTIMSC);
     }

  
  
