/* --=========================================================================--
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
-- File Name              : Ebi.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--
--   Files required for compilation:
--
--   This will create infile.bif and bif.sim in the ./invec directory
--
-- --=========================================================================*/

/******************************************************************************/
/***** Global Variable and Common functions                                ****/
/******************************************************************************/
#include "Common.c"

/******************************************************************************/
/****** Include the files required for the selected test                  *****/
/******************************************************************************/
#if defined(ebimclkeqhclk) || defined(ALL_TESTS)
#include "EbiMclkEqHclk.c"
#endif

#if defined(ebim1m2m3eq2hck) || defined(ALL_TESTS)
#include "EbiM1M2M3Eq2Hck.c"
#endif

#if defined(ebimck1mck2eq2hck) || defined(ALL_TESTS)
#include "EbiMck1Mck2Eq2Hck.c"
#endif

#if defined(ebimck1mck3eq2hck) || defined(ALL_TESTS)
#include "EbiMck1Mck3Eq2Hck.c"
#endif

#if defined(ebimck2mck3eq2hck) || defined(ALL_TESTS)
#include "EbiMck2Mck3Eq2Hck.c"
#endif

#if defined(ebimclk1eq2hclk) || defined(ALL_TESTS)
#include "EbiMclk1Eq2Hclk.c"
#endif

#if defined(ebimclk2eq2hclk) || defined(ALL_TESTS)
#include "EbiMclk2Eq2Hclk.c"
#endif

#if defined(ebimclk3eq2hclk) || defined(ALL_TESTS)
#include "EbiMclk3Eq2Hclk.c"
#endif

#if defined(ebirandom) || defined(ALL_TESTS)
#include "EbiRandom.c"
#endif

/******************************************************************************/
/****************************** MAIN ******************************************/
/******************************************************************************/
int main()
{
  TestStart(ZERO);

  RES(LOW, ,2);

  WaitLoop(5);

#if defined(ebimclkeqhclk)      || defined(ALL_TESTS)
      C("====================");
      C("EbiMclkEqHclk");
      C("====================");
      EbiMclkEqHclk();
#endif;

#if defined(ebim1m2m3eq2hck)      || defined(ALL_TESTS)
      C("====================");
      C("EbiM1M2M3Eq2Hck");
      C("====================");
      EbiM1M2M3Eq2Hck();
#endif;

#if defined(ebimck1mck2eq2hck)      || defined(ALL_TESTS)
      C("====================");
      C("EbiMck1Mck2Eq2Hck");
      C("====================");
      EbiMck1Mck2Eq2Hck();
#endif;

#if defined(ebimck1mck3eq2hck)      || defined(ALL_TESTS)
      C("====================");
      C("EbiMck1Mck3Eq2Hck");
      C("====================");
      EbiMck1Mck3Eq2Hck();
#endif;

#if defined(ebimck2mck3eq2hck)      || defined(ALL_TESTS)
      C("====================");
      C("EbiMck2Mck3Eq2Hck");
      C("====================");
      EbiMck2Mck3Eq2Hck();
#endif;

#if defined(ebimclk1eq2hclk)      || defined(ALL_TESTS)
      C("====================");
      C("EbiMclk1Eq2Hclk");
      C("====================");
      EbiMclk1Eq2Hclk();
#endif;

#if defined(ebimclk2eq2hclk)      || defined(ALL_TESTS)
      C("====================");
      C("EbiMclk2Eq2Hclk");
      C("====================");
      EbiMclk2Eq2Hclk();
#endif;

#if defined(ebimclk3eq2hclk)      || defined(ALL_TESTS)
      C("====================");
      C("EbiMclk3Eq2Hclk");
      C("====================");
      EbiMclk3Eq2Hclk();
#endif;

#if defined(ebirandom)      || defined(ALL_TESTS)
      C("====================");
      C("EbiRandom");
      C("====================");
      EbiRandom();
#endif;

 TestEnd();
 return 0;

}
/*********************************** End **************************************/
