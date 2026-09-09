/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : RegisterTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Register Tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                                      Located in          ***/
/*** ---------------------------------------------------------------------- ***/
/*** WriteReadTests()                                   SmcCommon.c         ***/
/******************************************************************************/

/******************************************************************************/
/******************************* RegisterTests ********************************/
/******************************************************************************/

void RegisterTests()
{
  /*
     Summary: Register Tests
     =======================
     This function performs the following:

     o  Write-Read tests are done on the registers of the SMC.
  */

  int32 TestData;

  TestData = Data5;
  C("Pattern Write-Read Tests -> 0x55555555");
  WriteReadTests(TestData);

  TestData = Data0;
  C("Pattern Write-Read Tests -> 0x00000000");
  WriteReadTests(TestData);

  TestData = DataF;
  C("Pattern Write-Read Tests -> 0xFFFFFFFF");
  WriteReadTests(TestData);

  TestData = DataA;
  C("Pattern Write-Read Tests -> 0xAAAAAAAA");
  WriteReadTests(TestData);
}

/************************************ End *************************************/
