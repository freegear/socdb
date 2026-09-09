/*----======================================================================----
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : EbiRandom.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--         
--          Request are raised randomly.
--
-- --=======================================================================--*/

/******************************************************************************/
/****************************** EbiRandom *************************************/
/******************************************************************************/
void EbiRandom()
{
 /*
   Summary: EbiRandom
   ==================
   This test performs the following functionalities:

   o Request are raised randomly.

   o Wait cycles are inserted randomly.

   o Counter registers are loaded randomly.

   o EbiReqPos bits are set randomly.

   o Memory clock is set randomly.
  
  */
int RandReq;
int i;
int RandWait;
int Counter1,Counter2,Counter3;
int RandPosition;
int RandMemClk;

for(i = 0; i <= 3; i++);
 {
   RandMemClk = rand() & 0x7;
   RandPosition = rand() & 0x38;
   Counter1 = rand() & 0x3FF;
   Counter2 = rand() & 0xFF;
   Counter3 = rand() & 0x8F;
   C("Counter value are loaded randomly");
   Write(EbiTrTimeOut1, Counter1, "WRD");
   Write(EbiTrTimeOut2, Counter2, "WRD");
   Write(EbiTrTimeOut3, Counter3, "WRD");
   C("EbiReqPosition bit is set randomly");
   Write(EbiTrCntl,  RandPosition, "WRD");
   C("Randomly changing the clock ratio");
   Write(EbiTrClk, RandMemClk, "WRD");
   for(i=0; i<=100; i++)
   {
    C("Request are raised randomly");
    RandReq = rand();
    RandWait = rand() & 0xF;
    WaitLoop(RandWait);
    Write(EbiTrCntl, RandReq, "WRD");
    if (i%10)
     Write(EbiTrCntl, RandReq & 0xFFFFFFF8, "WRD");
    
   }
 }
}

/*------===============================END================================----*/
