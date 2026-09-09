/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : RefFreqChk.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It tests the refresh frequency
--
--           TEST ID : MPMC_RefFreq_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************** RefFreqChk **********************************/
/******************************************************************************/
void RefFreqChk(void)
{
  /*
    Summary: Refresh Frequency Check
    ================================

    This test verifies that the refreshes are separated by the same number of
    clocks that is written into the Refresh register of the controller.

    o A value, say 0x18 is written into the Refresh register. Poll for the
      RefErrSt bit of the MPMCTrSR register to be cleared. This
      bit being low indicates that the refreshes are separated by the expected
      number of clocks. Repeat the same for different values written into the
      Refresh register.
  */
  int RefreshVal[] = {5, 7, 13, 24, 50};
  int i, ExpectedVal, Data;
 
  C("TEST ID : MPMC_RefFreq_1");
  /* Disable Address Mirror bit */
  WriteData(MPMCControl, 0x00000001, "WRD");
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
  SyncInitializeProc(2, 0, 2, 2, 0, 0, 
                     3, 0, 2, 2, 0, 0, 
                     3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0, 
                     0,2,1,0,1,1,1,0,2,1,1,
                     0,1,2,0,0,1,1,0,3,1,1,
                     0,0,0,0,0,1,1,0,3,0,0,
                     0,2,2,0,1,1,1,0,2,1,2, 
                     12,12,11,12,
                     0,
                     0);
  for (i = 0; i < 5; i++)
  {
    C("Programming the refresh counter");
    WriteData(MPMCDyRef, RefreshVal[i], "WRD");

    /* Writing the same value into MPMCTrSR register */
    WriteData(MPMCTrSR, 0x00000100,"WRD");

    WaitLoop((32*RefreshVal[i]) + 5 );

    /* Read the Signal Status Register to verify that the RefErrSt bit is low */
    C("Check the refresh count is same as programmed one");
    ReadData(MPMCTrSR, 0x00000000, 0x00000400, "WRD");
  }
}
/*-- --================================ End ================================--*/
