/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : TransferTests.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Burst accesses, Busy response and
--           Idle response tests on the Vic.
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** BurstTransfer()                            VicCommon.c                 ***/
/*** BusyTransfer()                             VicCommon.c                 ***/
/*** IdleTransfer()                             VicCommon.c                 ***/
/******************************************************************************/
 
/******************************************************************************/
/*************************** Transfer Tests ***********************************/
/******************************************************************************/

void TransferTests()
{
  /*
     Summary: Transfer Tests
     =======================
     This function performs the following:

     o  Conducts Burst transfers to the control and address registers.

     o  Conducts BUSY transfers to the control and address registers.

     o  Conducts IDLE transfers to the control and address registers.

     To write into all the address and control registers, a burst
     transfer is done. In the busy transfer case, BUSY cycles are 
     included in between the burst. In the idle transfer case, IDLE 
     cycles are included in between the burst. 
  */
   
  prot = 0x0;

  C("Burst Transfers");
  BurstTransfer(prot, NoMask);

  C("BUSY Transfers");
  BusyTransfer(prot, NoMask);

  C("IDLE Transfers");
  IdleTransfer(prot, NoMask);
}

/************************************ End *************************************/
