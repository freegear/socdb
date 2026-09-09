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
--  File Name              : Rtc_RstTest.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL031-REL1v0
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function RstTest
             which are called in the main file Rtc.c                          */
/******************************************************************************/

/******************************************************************************/
/************************** Reset Tests ***************************************/
/******************************************************************************/

void RstTest()

{
  /*
   Summary: Reset Test
   ===================
   This test checks the following functionalities :

   o  All RTC registers are read immediately after reset to verify
    that they initialise to values mentioned in the specification.
  */


  /* First, clear the RTC interrupt line */
  PSW(0x00000001, RTCICR,rtcicr);

  /* RTC normal mode registers */
  PSR(0x00000000, NoMask, RTCDR,rtcdr);
  PSR(0x00000000, NoMask, RTCMR,rtcmr);
  PSR(0x00000000, NoMask, RTCLR,rtclr);
  PSR(0x00000000, 0x00000001, RTCCR,rtccr);
  PSR(0x00000000, 0x00000001, RTCIMSC,rtcimsc);
  PSR(0x00000000, 0x00000001, RTCRIS,rtcris);
  PSR(0x00000000, 0x00000001, RTCMIS,rtcmis);
 

  /* RTC test registers */
  PSR(0x00000000, 0x00000001, RTCITCR,rtcitcr); 
  PSR(0x00000000, 0x00000001, RTCITIP,rtcitip); 
  PSR(0x00000000, 0x00000001, RTCITOP,rtcitop); 
  PSR(0x00000000, NoMask, RTCTOFFSET,rtctoffset);
  PSR(0x00000000, NoMask, RTCTCOUNT,rtctcount); 


  /* RTC identification registers */
  PSR(0x31, MASK_IDREG, PeripheralID0,pid0);
  PSR(0x10, MASK_IDREG, PeripheralID1,pid1);
  PSR(0x04, MASK_IDREG, PeripheralID2,pid2);
  PSR(0x00, MASK_IDREG, PeripheralID3,pid3);
  PSR(0x0D, MASK_IDREG, PrimeCellID0,pcid0);
  PSR(0xF0, MASK_IDREG, PrimeCellID1,pcid1);
  PSR(0x05, MASK_IDREG, PrimeCellID2,pcid2);
  PSR(0xB1, MASK_IDREG, PrimeCellID3,pcid3);

}
