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
-- File Name              : VicCommon.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains global variables and common functions
--           used by other tests.
--
-- --=======================================================================--*/
/******************************************************************************/
/***************************** Common Functions *******************************/
/******************************************************************************/

/******************************************************************************/
/********************************* Wait Loop **********************************/
/******************************************************************************/

void WaitLoop(int cyc)
{
  /*
     Summary: Inserts Wait Loops
     ===========================
     This function performs the following:

     o  Inserts programmed number of idle cycles.
  */

  int i;

  for (i = 0; i < cyc; i++)
  {
    HSA(ZERO, IDLE, INCR, , WRD);
    HSR( , ZERO, , 0x00000000);
  }
}

/*********************************** End **************************************/

