/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Ssp_Idle.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Idle
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

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
    if ((unsigned long)time % 2)
    {
      PI(0x03);
    }
    else
    {
      PI(0x02);
    }
  }
}/* End Function */
