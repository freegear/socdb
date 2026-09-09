/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Rtc_ResetRead.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL031-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Rtc.h, Rtc.c, Rtc_ResetRead.c
--
--   Usage: make <testname> e.g. make Rtc_ResetRead
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Rtc_Integ
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the RTC, please refer to PL031 AMBA    ***/
/*** RTC Block Specification                                        ***/
/**********************************************************************/

void ResetRead(void)
{
 C("Reset Test");
  PSR(0x00000000, NoMask, RTCDR,rtcdr);
  PSR(0x00000000, NoMask, RTCMR,rtcmr);
  PSR(0x00000000, NoMask, RTCLR,rtclr);
  PSR(0x00000000, 0x00000001, RTCCR,rtccr);
  PSR(0x00000000, 0x00000001, RTCMIS,rtcmis);
  PSR(0x00000000, 0x00000001, RTCIMSC,rtcimsc);

  PSR(0x31, MASK_IDREG, PeripheralID0,pid0);
  PSR(0x10, MASK_IDREG, PeripheralID1,pid1);
  PSR(0x04, MASK_IDREG, PeripheralID2,pid2);
  PSR(0x00, MASK_IDREG, PeripheralID3,pid3);
  PSR(0x0D, MASK_IDREG, PrimeCellID0,pcid0);
  PSR(0xF0, MASK_IDREG, PrimeCellID1,pcid1);
  PSR(0x05, MASK_IDREG, PrimeCellID2,pcid2);
  PSR(0xB1, MASK_IDREG, PrimeCellID3,pcid3);

 C("End of Reset Test");
}
