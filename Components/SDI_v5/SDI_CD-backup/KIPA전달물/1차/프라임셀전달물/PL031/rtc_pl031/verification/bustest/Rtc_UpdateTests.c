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
--  File Name              : Rtc_UpdateTests.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL031-REL1v0
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function UpdateTests                           */
/*             which are called in the main file Rtc.c                        */
/******************************************************************************/

/******************************************************************************/
/******************************** Update Tests ********************************/
/******************************************************************************/

void UpdateTests()

{


/*
   Summary: Update Tests
   ======================
   This function checks the following functionalities of the update logic block
 
   o  A value is written into the RTCLR register. The RTCDR register is read 
      after 2 rising edges of PCLK to verify that the update logic updates the 
      RTC value with the new update value written to the RTCLR register. 
      To check the stability of the counter, the RTCDR register is read again 
      twice to verify an increment after a rising edge of CLK1HZ.

   o  Various values are written to the RTCLR and RTCMR registers during the 
      low and high phase of the clock to check the correct operation of the 
      update block state machine.
   
   o  The RTCDR register is read after every clock to verify that the counter
      increments after every clock.

   o  Three different values are written into the RTCLR register during the low
      phase of the CLK1HZ signal. The RTCDR register is read after 2 rising 
      edges of the clock to verify that the update block updates the RTC value
      with the last written value.
*/
    

  /* Test for correct operation of the update logic - which updates the value */
  /* of the RTC                                                               */


  C("Start of Initialisation");
/* Assert RTC enable signal (RTCEn) by writing to RTCCR                       */
  PSW(0x00000001, RTCCR,rtccr);
/* Write different values to RTCLR and RTCMR registers                        */
  PSW(0x00000046, RTCMR,rtcmr);
  PSW(0x00000003, RTCLR,rtclr);
/* Poll for a Clock by first polling for a high on the single bit             */
/* register RTSR and then polling for a low.                                  */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
  PI(0x02);
/* Poll for another clock                                                     */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk,  RTSR);
  PI(0x02);
/* Write to RTCICR to clear the raw interrupt status bit                      */
  PSW(0x00000001, RTCICR,rtcicr);
/* Wait for 1 PCLK cycle - the time it takes for an interrupt clear           */
  PI(0x01);
/* Read RTCRIS to ensure that it has been cleared.                            */
  PSR(0x00000000, 0x00000001, RTCRIS,rtcris);
/* Set the single bit register RTCIMSC to enable the interrupt.               */
  PSW(0x00000001, RTCIMSC,rtcimsc);
/* Read masked interrupt status register RTCMIS to ensure that the            */
/* interrupt has  not been set after it was enabled.                          */
  PSR(0x00000000, 0x00000001, RTCMIS,rtcmis);
/* Clear ITEN bit in RTC test control register (RTCITCR)                      */
  PSW(0x00000000, RTCITCR,rtcitcr);
/* Clear RTCITOP register                                                     */
  PSW(0x00000000, RTCITOP,rtcitop);
  C("End of Initialisation");


/* Poll for a Clk1HZ falling edge to ensure that the next write occurs on     */
/* the low phase of the clock.                                                */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
/* Write to the Load register                                                 */
  PSW(0x00000000, RTCLR);
/* Wait for 3 PCLK cycles                                                     */
  PI(0x03);
/* Read the RTCDR register to check if the RTC value is updated by the        */
/* write to the RTCLR register                                                */
  PSR(0x00000000, NoMask, RTCDR,rtcdr);
/* Poll for a Clk1HZ high                                                     */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
/* Read the RTCDR register to check if the RTC value increments after         */
/* the CLK1HZ high                                                            */
  PSR(0x00000001, NoMask, RTCDR,rtcdr);
/* Poll for the low phase of Clk1HZ                                           */
  PO(0x00000000, MaskClk, RTSR);
/* Read the RTCDR twice to ensure stability of RTC value                      */
  PSR(0x00000001, NoMask, RTCDR,rtcdr);
  PSR(0x00000001, NoMask, RTCDR,rtcdr);


/* Write various values to the RTCMR & RTCLR register back to back to check   */
/* for the correct operation of the Update state machine                      */   
  PSW(0x00000024, RTCLR,rtclr);
  PSW(0x000000AA, RTCMR,rtcmr);
/* Poll for the high phase of the clock and immediately write to the RTCLR    */  
/* to verify the correct operation of the state machine                       */  
  PO(0x00000001, MaskClk, RTSR);
  PSW(0x0000002A, RTCLR,rtclr);
  PSW(0x00000001, RTCLR,rtclr);
/* Poll for the low phase of Clk1HZ                                           */
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);

/* Write a value into the Offset register via the RTCTOFFSET test register by */
/* asserting the TESTOFFSET bit in the RTCITCR register                       */
  PSW(0x00000004, RTCITCR,rtcitcr);
  PSW(0xAAAA5555, RTCTOFFSET,rtctoffset);
  PI(0x02);
/* Read the Offset register via RTCTOFFSET to verify the written value        */
  PSR(0xAAAA5555, NoMask, RTCTOFFSET,rtctoffset);
  PSW(0x00000000, RTCITCR,rtcitcr);
/* Write various values to the RTCMR & RTCLR register back to back to check   */
/* for the correct operation of the Update state machine                      */
  PSW(0x00000001, RTCLR,rtclr);
  PSW(0x000000FF, RTCMR,rtcmr);


/* Poll for a clock                                                           */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
/* Read RTCDR to check if the RTC value has incremented showing that the      */
/* counter has incremented.                                                   */
  PSR(0x00000002, NoMask, RTCDR,rtcdr);

/* Poll for a clock                                                           */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
/* Read RTCDR to check if the RTC value has incremented showing that the      */
/* counter has incremented.                                                   */
  PSR(0x00000003, NoMask, RTCDR,rtcdr);

/* Poll for a clock                                                           */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
/* Read RTCDR to check if the RTC value has incremented showing that the      */
/* counter has incremented.                                                   */
  PSR(0x00000004, NoMask, RTCDR,rtcdr);

/* Poll for a clock                                                           */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
/* Read RTCDR to check if the RTC value has incremented showing that the      */
/* counter has incremented.                                                   */
  PSR(0x00000005, NoMask, RTCDR,rtcdr);


/* Test to ensure that the last of three written values to RTCLR updates the  */
/* RTC value and that the updated RTC value increments after the next CLK1HZ  */
/* rising edge.                                                               */
 
/* Poll for a Clk1HZ low                                                      */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
/* Write three different values into RTCLR                                    */
  PSW(0xAB094565, RTCLR);
  PSW(0x00567921, RTCLR);
  PSW(0x34567890, RTCLR);
/* Wait for 3 PCLK cycles                                                     */
  PI(0x03);
/* Read RTCDR to check if the last written value updated the RTC value        */
  PSR(0x34567890, NoMask, RTCDR,rtcdr);
/* Poll for a Clk1HZ high                                                     */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
/* Read RTCDR to check if the updated value increments                        */
  PSR(0x34567891, NoMask, RTCDR,rtcdr);
  C("End of Update Tests");
}
