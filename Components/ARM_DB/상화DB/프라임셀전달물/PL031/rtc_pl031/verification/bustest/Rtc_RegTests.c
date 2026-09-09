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
--  File Name              : Rtc_RegTests.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL031-REL1v0
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function RegTests                              */
/*             which are called in the main file Rtc.c                        */
/******************************************************************************/

/******************************************************************************/
/******************************** Register Tests ******************************/
/******************************************************************************/



void RegTests()
 
{


  /*
   Summary: Register Tests
   =======================
   This test checks the following functionalities 
 
    o  The Read/Writeable registers are written with patterns of 0x55
    and 0xAA. Data is read back and compared with the expected pattern.
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
  /* Clear RTC integration test control register (RTCITCR) */
  PSW(0x00000000, RTCITCR,rtcitcr);
  /* Clear RTCITOP register */
  PSW(0x00000000, RTCITOP,rtcitop);
  C("End of Initialisation");



  PSW(DATA_As, RTCLR,rtclr);
  PSR(DATA_As, NoMask, RTCLR,rtclr);
  PSW(DATA_5s, RTCLR,rtclr);
  PSR(DATA_5s, NoMask, RTCLR,rtclr);

  PSW(DATA_As, RTCMR,rtcmr);
  PSR(DATA_As, NoMask, RTCMR,rtcmr);
  PSW(DATA_5s, RTCMR,rtcmr);
  PSR(DATA_5s, NoMask, RTCMR,rtcmr);


  /* Peripheral ID registers */
  PSW(DATA_As, PeripheralID0);
  PSR(0x31, MASK_IDREG, PeripheralID0);
  PSW(DATA_5s, PeripheralID0);
  PSR(0x31, MASK_IDREG, PeripheralID0);
  
  PSW(DATA_As, PeripheralID1);
  PSR(0x10, MASK_IDREG, PeripheralID1);
  PSW(DATA_5s, PeripheralID1);
  PSR(0x10, MASK_IDREG, PeripheralID1);
  
  PSW(DATA_As, PeripheralID2);
  PSR(0x04, MASK_IDREG, PeripheralID2);
  PSW(DATA_5s, PeripheralID2);
  PSR(0x04, MASK_IDREG, PeripheralID2);
  
  PSW(DATA_As, PeripheralID3);
  PSR(0x00, MASK_IDREG, PeripheralID3);
  PSW(DATA_5s, PeripheralID3);
  PSR(0x00, MASK_IDREG, PeripheralID3);
  
  PSW(DATA_As, PrimeCellID0);
  PSR(0x0D, MASK_IDREG, PrimeCellID0);
  PSW(DATA_5s, PrimeCellID0);
  PSR(0x0D, MASK_IDREG, PrimeCellID0);
  
  PSW(DATA_As, PrimeCellID1);
  PSR(0xF0, MASK_IDREG, PrimeCellID1);
  PSW(DATA_5s, PrimeCellID1);
  PSR(0xF0, MASK_IDREG, PrimeCellID1);
  
  PSW(DATA_As, PrimeCellID2);
  PSR(0x05, MASK_IDREG, PrimeCellID2);
  PSW(DATA_5s, PrimeCellID2);
  PSR(0x05, MASK_IDREG, PrimeCellID2);
  
  PSW(DATA_As, PrimeCellID3);
  PSR(0xB1, MASK_IDREG, PrimeCellID3);
  PSW(DATA_5s, PrimeCellID3);
  PSR(0xB1, MASK_IDREG, PrimeCellID3);

  /* Test Registers */
  PSW(DATA_As, RTCITCR,rtcitcr);
  PSR(0x00000000, 0x00000001, RTCITCR,rtcitcr);
  PSW(DATA_5s, RTCITCR,rtcitcr);
  PSR(0x00000001, 0x00000001, RTCITCR,rtcitcr);
 
  PSW(DATA_As, RTCITOP,rtcitop);
  PSR(0x00000000, 0x00000001, RTCITOP,rtcitop);
  PSW(DATA_5s, RTCITOP,rtcitop);
  PSR(0x00000001, 0x00000001, RTCITOP,rtcitop);
  C("End of Register Pattern Tests");
 
}
