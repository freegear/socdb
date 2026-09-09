/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : ResponseTests.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Response Tests on the TIC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                                      Located in          ***/
/*** ---------------------------------------------------------------------- ***/
/*** WriteReadTests()                                   SsmcCommon.c        ***/
/******************************************************************************/

/******************************************************************************/
/******************************* RegisterTests ********************************/
/******************************************************************************/

void ResponseTests()
{
  /*
     Summary: Response Tests
     =======================
     This function performs the following:

     o  ERROR/RETRY/SPLIT Response tests are done on the TIC.
  */

  int32 TestData[3] = {0x12345678, 0x89ABCDEF, 0x87654321};
  int32 Addr;

  TCV(0xF0000000, WRD, 1, 0, 0xA);
  HSA(GS_WCS1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x07070707);
  HSA(GS_WCS2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x07070707);
  HSA(GS_CR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x10);
  HSA(GS_XRDLY, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00020002);
  HSA(GS_TMOUT, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00F00);

  /** Retry Response Tests **/
  TCV(0xF0000000, WRD, 1, 1, 0x5);
  Addr = GS_ARRAY2 + 0x200;
  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData[0]);
  HSW( , TestData[1]);
  HSW( , TestData[2]);

  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData[0], , MaskAll, ,ResponseTests_1);
  HSR( , TestData[1], , MaskAll, ,ResponseTests_2);
  HSR( , TestData[2], , MaskAll, ,ResponseTests_3);

  HSA(GS_XRDLY, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00010001);

  /** Split Response Tests **/
  TCV(0xF0000000, WRD, 1, 0, 0x5);
  Addr = GS_ARRAY2 + 0x300;
  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData[0]);
  HSW( , TestData[1]);
  HSW( , TestData[2]);

  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData[0], , MaskAll, ,ResponseTests_4);
  HSR( , TestData[1], , MaskAll, ,ResponseTests_5);
  HSR( , TestData[2], , MaskAll, ,ResponseTests_6);
}
