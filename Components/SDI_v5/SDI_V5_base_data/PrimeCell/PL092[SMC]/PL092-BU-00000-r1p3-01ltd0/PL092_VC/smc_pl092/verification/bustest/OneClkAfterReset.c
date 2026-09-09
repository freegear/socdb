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
--  File Name              : OneClkAfterReset.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to test the behaviour of SMC in the first clk after Reset.
--
-- --=========================================================================*/

/******************************************************************************/
/******************************** OneClkAfterReset ****************************/
/******************************************************************************/

void OneClkAfterReset()
{
  /*
     Summary: OneClkAfterReset
     =========================
     This function performs the following:

     1. Register write on the clock after reset followed immediately by
        a) memory write
        b) memory read
     2. Register read on the clock after reset followed immediately by
        a) memory write
        b) memory read
     3. Memory write on the clock after reset
     4. Memory read on the clock after reset

  */

  int  i, j;
  int  Address, OffSet;
  char PrntStr[120];
  int  HSize, HBurst, BurstSize;

/* 1 */
  ApplyReset();
/* Register Write */
  HSA(SMBCR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x21);
/* Memory write */
  HSA(SMCMEM_1, NSEQ, SINGLE, OK, WRD);
  HSW( , 0x11223344);
/* Memory Read */
  HSA(SMCMEM_1, NSEQ, SINGLE, OK, HWRD);
  HSR( , 0x3344, , HWUnMaskL, ,OneClkAfterReset_0);
  

/* 2 */
  ApplyReset();
  WaitLoop(1);
/* Register Read */
  HSA(SMBWST1R0, NSEQ, SINGLE, OK, WRD);
  HSR(, RST_SMBWST1R, ,RST_SMBWST1R, ,OneClkAfterReset_1);
/* Memory write */
  HSA(SMCMEM_1, NSEQ, SINGLE, OK, HWRD);
  HSW( , 0x3344);
/* Memory Read */
  HSA(SMCMEM_1, NSEQ, SINGLE, OK, HWRD);
  HSR( , 0x3344, , HWUnMaskL, ,OneClkAfterReset_2);

/* 3 */
  ApplyReset();
  WaitLoop(1);
/* Memory write */
  HSA(SMCMEM_3, NSEQ, SINGLE, OK, WRD);
  HSW( , 0xAABB1122);
/* Memory Read */
  HSA(SMCMEM_3, NSEQ, INCR4, OK, BYTE);
  HSR( , 0x22, , BUnMask0, ,OneClkAfterReset_3);
  HSR( , 0x1100, , BUnMask1, ,OneClkAfterReset_4);
  HSR( , 0xBB0000, , BUnMask2, ,OneClkAfterReset_5);
  HSR( , 0xAA000000, , BUnMask3, ,OneClkAfterReset_6);

/* 4 */
  ApplyReset();
  WaitLoop(1);
/* Memory Read */
  HSA(SMCMEM_3, NSEQ, SINGLE, OK, WRD);
  HSR( , 0x0, , NoMask);
}
