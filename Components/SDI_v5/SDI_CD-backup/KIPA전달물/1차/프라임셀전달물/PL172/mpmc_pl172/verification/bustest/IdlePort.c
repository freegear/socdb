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
-- File Name              : IdlePort.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function is used to keep the unused Port in Idle state.
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* IdlePort ***********************************/
/******************************************************************************/
IdlePort()
{
  /* 
    Summary: IdlePort
    =================

    o  This function polls for the trick box register to keep the unused port
       in idle state.

  */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x0000000F, ,0x0000000F, , ,Idle_Poll); 
}
/*-- --================================ End ================================--*/
