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
--  File Name              : Rtc_CountTests.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL031-REL1v0
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function CountTests                            */
/*             which are called in the main file Rtc.c                        */
/******************************************************************************/

/******************************************************************************/
/******************************** Counter Tests *******************************/
/******************************************************************************/



void CountTests()


{

  /*
   Summary: Counter Tests
   ======================
   This function verifies the correct operation of the counter.
   
   % Data patterns of AAAAAAAA and 55555555 are loaded into the Counter via the
     test count register and read back for correctness. THis ensures that all 
     the bits of the counter are toggled at least once.

   % Overflow test - The counter is loaded with its maximum value and after an 
     increment, the test control register is read back to verify that the 
     counter rolls over correctly.
  */
   
  C("Start of Initialisation");
  /* Assert RTC enable signal (RTCEn) by writing to RTCCR                     */
  PSW(0x00000001, RTCCR,rtccr);
  /* Write different values to RTCLR and RTCMR registers                      */
  PSW(0x00000046, RTCMR,rtcmr);
  PSW(0x00000003, RTCLR,rtclr);
  /* Poll for a Clock by first polling for a high on the single bit           */
  /* register RTSR and then polling for a low.                                */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
  PI(0x02);
  /* Poll for another clock                                                   */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk,  RTSR);
  PI(0x02);
  /* Write to RTCICR to clear the raw interrupt status bit                    */
  PSW(0x00000001, RTCICR,rtcicr);
  /* Read RTCRIS to ensure that it has been cleared.                          */
  PSR(0x00000000, 0x00000001, RTCRIS,rtcris);
  /* Set the single bit register RTCIMSC to enable the interrupt.             */
  PSW(0x00000001, RTCIMSC,rtcimsc);
  /* Read masked interrupt status register RTCMIS to ensure that the          */
  /* interrupt has  not been set after it was enabled.                        */
  PSR(0x00000000, 0x00000001, RTCMIS,rtcmis);
  /* Clear ITEN bit in RTC test control register (RTCITCR)                    */
  PSW(0x00000000, RTCITCR,rtcitcr);
  /* Clear RTCITOP register                                                   */
  PSW(0x00000000, RTCITOP,rtcitop);
  C("End of Initialisation");


  /***************************** Counter Tests ********************************/

   /* Poll for a Clk1HZ falling edge to ensure that the next write occurs on  */
   /* the low phase of the clock.                                             */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x02);
   PO(0x00000000, MaskClk, RTSR);
 
   /* Set the TESTCOUNT bit in the RTC test control register RTCITCR[2]       */
   PSW(0x00000002, RTCITCR,rtcitcr);
   /* Write the test data pattern to the RTCTCOUNT register                   */
   PSW(DATA_5s, RTCTCOUNT,rtctcount);

   /* Poll for a Clk1HZ high to ensure the written value is loaded into the   */
   /* counter before a read of RTCTCOUNT register                             */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x05); /* Wait for 5 PCLK cycles to allow time for Count synchronisation*/
   PSR(DATA_5s, NoMask, RTCTCOUNT,rtctcount);

   /* Poll for a Clk1HZ falling edge to ensure that the next write occurs on  */
   /* the low phase of the clock.                                             */
   PO(0x00000000, MaskClk, RTSR);
   
   /* Write the test data pattern to the RTCTCOUNT register                   */
   PSW(DATA_As, RTCTCOUNT,rtctcount);

   /* Poll for a Clk1HZ high to ensure the written value is loaded into the   */
   /* counter before a read of RTCTCOUNT register                             */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x05); /* Wait for 5 PCLK cycles to allow time for Count synchronisation*/
   PSR(DATA_As, NoMask, RTCTCOUNT,rtctcount);



   /************************* Overflow Test ***********************************/

   /* Poll for a Clk1HZ falling edge to ensure that the next write occurs on  */
   /* the low phase of the clock.                                             */
   PO(0x00000000, MaskClk, RTSR);
   /* Write to the RTCTCOUNT register                                         */
   PSW(0xFFFFFFFF, RTCTCOUNT,rtctcount);
   
   /* Poll for a clock to ensure that the written value is loaded into the    */
   /* counter on the rising edge of CLK1HZ                                    */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x02);
   PO(0x00000000, MaskClk, RTSR);
   
   /* Clear the TESTCOUNT bit in the RTC test control register (RTCITCR)      */
   PSW(0x00000000, RTCITCR,rtcitcr);
   
   /* Poll for another clock                                                  */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x02);
   PO(0x00000000, MaskClk, RTSR); 
   
   /* Set the TESTCOUNT bit                                                   */
   PSW(0x00000002, RTCITCR,rtcitcr);
   /* Read RTCTCOUNT to verify if the counter has been loaded with the value  */
   /* written to RTCTCOUNT                                                    */
   PI(0x05);
   PSR(0xFFFFFFFF, NoMask, RTCTCOUNT,rtctcount);
   /* Clear the TESTCOUNT bit in the RTC test control register (RTCITCR)      */
   PSW(0x00000000, RTCITCR,rtcitcr);

   /* Poll for a clock                                                        */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x02);
   PO(0x00000000, MaskClk, RTSR); 

   /* Set the TESTCOUNT bit                                                   */
   PSW(0x00000002, RTCITCR,rtcitcr); 
   /* Read RTCTCOUNT to verify if the counter has rolled over to its minimum  */
   /* value 0x00000000                                                        */
   PI(0x02);                         
   PSR(0x00000000, NoMask, RTCTCOUNT,rtctcount);
   /* Clear the TESTCOUNT bit in the RTC test control register (RTCITCR)      */
   PSW(0x00000000, RTCITCR,rtcitcr);

   /* Poll for a clock                                                        */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x02);
   PO(0x00000000, MaskClk, RTSR);

   /* Set the TESTCOUNT bit                                                   */
   PSW(0x00000002, RTCITCR,rtcitcr);
   /* Read RTCTCOUNT to check if the counter has incremented after a rollover */
   PI(0x02);
   PSR(0x00000001, NoMask, RTCTCOUNT,rtctcount);
   /* Clear the TESTCOUNT bit in the RTC test control register (RTCITCR)      */
   PSW(0x00000000, RTCITCR,rtcitcr);
   
   /***************************************************************************/
   /* Read counter value for 2 subsequent increments to verify correct        */
   /* operation after overflow test                                           */
   /***************************************************************************/
   
   /* Poll for a clock                                                        */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x02);
   PO(0x00000000, MaskClk, RTSR);
   
   /* Set the TESTCOUNT bit                                                   */
   PSW(0x00000002, RTCITCR,rtcitcr);
   /* Read RTCTCOUNT register to check if the counter has incremented         */
   PI(0x02);
   PSR(0x00000002, NoMask, RTCTCOUNT,rtctcount);
   /* Clear the TESTCOUNT bit in the RTC test control register (RTCITCR)      */
   PSW(0x00000000, RTCITCR,rtcitcr);

   /* Poll for a clock                                                        */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x02);
   PO(0x00000000, MaskClk, RTSR);
   
   /* Set the TESTCOUNT bit                                                   */
   PSW(00000002, RTCITCR,rtcitcr);
   /* Read RTCTCOUNT register to check if the counter has incremented         */
   PI(0x02);
   PSR(0x00000003, NoMask, RTCTCOUNT,rtctcount);
   /* Clear the TESTCOUNT bit in the RTC test control register (RTCITCR)      */
   PSW(0x00000000, RTCITCR,rtcitcr);

   /***************************************************************************/
   /* Write to the Load register to verify normal operation after testing     */
   /***************************************************************************/

   /* Write to the Load register                                              */
   PSW(0x00000000, RTCLR);
   /* Wait for 3 PCLK cycles                                                  */
   PI(0x03);
   /* Read the RTCDR register to check if the RTC value is updated by the     */
   /* write to the RTCLR register                                             */
   PSR(0x00000000, NoMask, RTCDR);
   /* Poll for a Clk1HZ high                                                  */
   PO(0x00000001, MaskClk, RTSR);
   PI(0x02);
   /* Read the RTCDR register to check if the RTC value increments after      */
   /* the CLK1HZ high                                                         */
   PSR(0x00000001, NoMask, RTCDR);
   /* Poll for the low phase of Clk1HZ                                        */
   PO(0x00000000, MaskClk, RTSR);
   /* Read the RTCDR twice to ensure stability of RTC value                   */
   PSR(0x00000001, NoMask, RTCDR);
   PSR(0x00000001, NoMask, RTCDR);
   C("End of Counter Tests");
}
