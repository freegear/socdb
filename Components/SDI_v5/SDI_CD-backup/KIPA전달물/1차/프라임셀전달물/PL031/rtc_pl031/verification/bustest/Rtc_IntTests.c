/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Rtc_IntTests.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL031-REL1v0
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function IntTests                              */
/*             which are called in the main file Rtc.c                        */
/******************************************************************************/

/******************************************************************************/
/******************************** Interrupt Tests *****************************/
/******************************************************************************/


void IntTests()

{
 

  /*
   Summary: Interrupt Tests
   ========================
   This function does the following :
   
   o Checks whether the RTCINTR interrupt is set when the Count
     value becomes equal to the equivalent value of the RTCMR register. 
   o It verifies that the interrupt is cleared by a write of only '1' to the 
     RTCICR register.
   o It verifies that once the interrupt is set, it remains set until cleared
     by a write of '1' to the RTCICR register.
  */ 



  C("Start of Initialisation");
  /* Assert RTC enable signal (RTCEn) by writing to RTCCR */
  PSW(0x00000001, RTCCR,rtccr);
  /* Write different values to RTCLR and RTCMR registers */
  PSW(0x00000046, RTCMR,rtcmr);
  PSW(0x00000003, RTCLR,rtclr);
  /* Poll for a Clock by first polling for a high on the single bit */
  /* register RTSR and then polling for a low.                      */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
  PI(0x02);
  /* Poll for another clock */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk,  RTSR);
  PI(0x02);
  /* Write to RTCICR to clear the raw interrupt status bit */ 
  PSW(0x00000001, RTCICR,rtcicr);
  /* Read RTCRIS to ensure that it has been cleared. */
  PSR(0x00000000, 0x00000001, RTCRIS,rtcris);
  /* Set the single bit register RTCIMSC to enable the interrupt. */ 
  PSW(0x00000001, RTCIMSC,rtcimsc);
  /* Read masked interrupt status register RTCMIS to ensure that the */
  /* interrupt has  not been set after it was enabled.         */
  PSR(0x00000000, 0x00000001, RTCMIS,rtcmis);
  /* Clear ITEN bit in RTC integration test control register (RTCITCR) */
  PSW(0x00000000, RTCITCR,rtcitcr);
  /* Clear RTCITOP register */
  PSW(0x00000000, RTCITOP,rtcitop);
  C("End of Initialisation");



  /* Poll for a Clk1HZ low. */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);

  /* Write consecutive values to RTCLR and RTCMR registers. */
  PSW(0x56734298, RTCLR,rtclr);
  PSW(0x56734299, RTCMR,rtcmr);

  /* Poll for a Clk1HZ high. */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x03);
 
  /* Read RTCRIS to ensure that the interrupt bit is set. */
  PSR(0x00000001, 0x00000001, RTCRIS,rtcris);

  /* Write a '0' to RTCICR to clear the interrupt, should not work. */
  PSW(0x00000000, RTCICR,rtcicr);
  PI(0x03);
  /* Write any value to RTCICR to clear the interrupt, should not work. */
  PSW(0xABDE0340, RTCICR,rtcicr);
  PI(0x03);
  /* Write a '1' to RTCICR to clear the interrupt */
  PSW(0x00000001, RTCICR,rtcicr);
  PI(0x03);

  /* Read the RTCRIS register to ensure that the interrupt bit is cleared. */
  PSR(0x00000000, 0x00000001, RTCRIS,rtcris);



  /* During the CLK1HZ high, write consecutive values into RTCLR and RTCMR 
     registers.
  */
  PI(0x03);
  PSW(0xAB675ABC, RTCLR,rtclr);
  PSW(0xAB675ABD, RTCMR,rtcmr);

  /* Poll for a Clk1HZ low then high */
  PO(0x00000000, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000001, MaskClk, RTSR);
  PI(0x03);

  /* Read RTCRIS to ensure that the interrupt is set */
  PSR(0x00000001, 0x00000001, RTCRIS,rtcris);

  /* Write to RTCICR to clear the interrupt */
  PSW(0x00000001, RTCICR,rtcicr);
  PI(0x03);

  /* Read RTCRIS to ensure that the interrupt has been cleared */
  PSR(0x00000000, 0x00000001, RTCRIS,rtcris);
  C("End of Interrupt Tests");

}


