/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : SmcCommon.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains global variables and common functions
--           used by other tests.
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Global Variables *******************************/
/******************************************************************************/

/******************************************************************************/
/***************************** Common Functions *******************************/
/******************************************************************************/

void WriteReadTests(int32 TestData, int32 Mask, int Beats, int hsize)
{
  /*
     Summary: Write-Read Tests
     =========================
     This performs performs the following:

     o  Writes and expects the same data in case of the R/W registers.

     o  Writes and expects the default data in case of the Read-only
        registers.
  */
  
  int i;
  int Shift[3] = {8, 16, 32};
  int32 TempData, Data, TempMask, Addr;
  char size[3] = {'b', 'h', 'w'};

  TempData = TestData;
  Data = TempData++ & Mask;
  /** Performing Writes on the Generic Slave **/
  HSA(GS_ARRAY1, NSEQ, INCR, , size[hsize], , 0x1, , , , ,);
  HSW( , Data);
  for (i=1; i<Beats; i++, TempData++)
  {
    TempMask = Mask << i*Shift[hsize];
    Data = (TempData << i*Shift[hsize]) & TempMask;
    HSW( , Data);
  }

  TempData = TestData;
  Data = TempData++ & Mask;
  /** Reading back the data from the Generic Slave **/
  HSA(GS_ARRAY1, NSEQ, INCR, , size[hsize], , 0x1, , , , ,);
  HSR( , Data, , Mask, ,WriteReadTests_1);
  for (i=1; i<Beats; i++, TempData++)
  {
    TempMask = Mask << i*Shift[hsize];
    Data = (TempData << i*Shift[hsize]) & TempMask;
    HSR( , Data, , TempMask, ,WriteReadTests_1);
  }

}

/************************************ End *************************************/
