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
--  File Name              : Rtc_InitReg.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL031-REL1v0
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function InitReg                               */
/*             which are called in the main file Rtc.c                        */
/******************************************************************************/


/******************************************************************************/
/************************* Register Initialisations ***************************/
/******************************************************************************/

void InitReg()

{
  /*
   Summary : Register Initialisations
   ==================================
   This function does the following :
   
   o  Asserts the RTCEn signal by writing to RTC Control Register (RTCCR)
   
   o  The internal registers of the RTC are initialised by writing different
      values into RTCLR and RTCMR and polling for clocks so that the contents 
      of RTCDR are first initialised and then incremented. 
   
   o  Clears the Interrupt status bit by writing to the RTCICR register.

   o  The single bit register RTCIMSC is set to enable futher interrupts. 

   o  Clears ITEN bit in the RTC test control register (RTCITCR).

   o  Clears RTCITOP register.
  */                        


  /* Assert RTC enable signal (RTCEn) by writing to RTCCR                     */
  
  PSW(0x00000001, RTCCR,rtccr);
  
  /* Write different values to RTCLR and RTCMR registers                      */
  PSW(0x00000046, RTCMR,rtcmr);
  PSW(0x00000008, RTCLR,rtclr);

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
  C("End of Register Initialisations");
}
