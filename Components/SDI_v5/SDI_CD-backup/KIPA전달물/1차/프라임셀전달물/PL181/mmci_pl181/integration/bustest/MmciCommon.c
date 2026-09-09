/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : MmciCommon.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : Function to insert variable IDLE cycles
--
-- --=========================================================================*/

void Idle(unsigned long time)
{
  /*
  Summary: Idle function
  ======================

  This is to create the delay of time, passed as the argument to this
  function.

  */

  unsigned long i;

  if (time <= 2)
  {
    PI(0x02);
  }
  else
  {
    for(i=0; i< ((unsigned long)(time/2) - 1); i++)
    {
      PI(0x02);
    }
  }
}

/* --================================== End ==================================*/
