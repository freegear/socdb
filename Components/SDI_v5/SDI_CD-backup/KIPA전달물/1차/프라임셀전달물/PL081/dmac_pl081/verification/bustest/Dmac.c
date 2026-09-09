/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Dmac.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA AHB bus.
-- 
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c, config.h,
--     addargs_script, Header files and C source files for Dmac tests.
--
--   Usage: make <testname> e.g. make RegisterTests
--       OR make all        - to compile all tests
--
--       OR make Dmac1      |   to compile selectively so as to avoid
--       OR make Dmac2      |   loading problems during simulation
--
--   This will create infile.bif and bif.sim in the ./invec directory
--
-- --=========================================================================*/

/******************************************************************************/
/*** For more information on the DMAC, please refer to PL080 AMBA DMAC      ***/
/*** Block Specification.                                                   ***/
/******************************************************************************/

/******************************************************************************/
/*** Global Variables and common functions                                  ***/
/******************************************************************************/
#include "DmacCommon.c"

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/
#if defined(resettests) || defined(ALL_TESTS)
#include "DmacResetTests.c"
#endif
 
#if defined(registertests) || defined(ALL_TESTS)
#include "DmacRegisterTests.c"
#endif
 
#if defined(enabledchanneltests) || defined(ALL_TESTS)
#include "DmacEnabledChannelTests.c"
#endif
 
#if defined(m2mtests) || defined(ALL_TESTS)
#include "DmacM2MTests.c"
#endif

#if defined(p2mtests) || defined(ALL_TESTS)
#include "DmacP2MTests.c"
#endif

#if defined(m2ptests) || defined(ALL_TESTS)
#include "DmacM2PTests.c"
#endif

#if defined(p2ptests) || defined(ALL_TESTS)
#include "DmacP2PTests.c"
#endif

#if defined(twochtests) || defined(ALL_TESTS)
#include "Dmac2ChannelTests.c" 
#endif

#if MORETHAN2CHNS
#if defined(fourchtests) || defined(ALL_TESTS)
#include "Dmac4ChannelTests.c" 
#endif
#endif

#if MORETHAN4CHNS
#if defined(eightchtests) || defined(ALL_TESTS)
#include "Dmac8ChannelTests.c" 
#endif
#endif

#if defined(dmacllitests) || defined(ALL_TESTS)
#include "DmacLLITests.c"
#endif

#if defined(dmachaltdistests) || defined(ALL_TESTS)
#include "DmacHaltDisTests.c"
#endif

#if defined(inttests) || defined(ALL_TESTS)
#include "DmacIntrTests.c"
#endif

#if defined(mastest) || defined(ALL_TESTS)
#include "DmacMasTest.c"
#endif


#if defined(cornertests) || defined(ALL_TESTS)
#include "DmacCornerTests.c"
#endif

#if defined(cornertests2)
#include "DmacCornerTests2.c"
#endif

/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{ 

  C("------------------------------------------------------------------------- ---",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2000-2001 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("------------------------------------------------------------------------- ---",header);

  TestStart(ZERO);

  RES(LOW, , 2);

  WaitLoop(5);

/******************************************************************************/
/*** The reset value of the registers are tested here.                      ***/
/******************************************************************************/
#if defined(resettests) || defined(ALL_TESTS)
  C("==============");
  C("RESET TESTS");
  C("==============");
  ResetTests();
#endif

#if defined(registertests) || defined(ALL_TESTS)
/******************************************************************************/
/*** Different values are written and read from the registers to verify     ***/
/*** that the register under test is a read-only/read-write/write-only      ***/
/******************************************************************************/
 /* Disable the trickbox to avoid spurious warnings during register test */
 Write(DMACTRICKEN, 0x00000000);

  C("==============");
  C("REGISTER TESTS");
  C("==============");
  RegisterTests();
  RES(LOW, , 2);

  WaitLoop(5);

  Write(DMACTRICKEN, 0x00000001);
#endif

  /* Enable the DMA Controller */

  Write(DMACConfig, DMACENABLE);

#if defined(enabledchanneltests) || defined(ALL_TESTS)
  C("=====================");
  C("ENABLED CHANNEL TESTS");
  C("=====================");
  EnabledChannelTests();
  WaitLoop(5);
#endif

  /* Enable the DMA Controller */

  Write(DMACConfig, DMACENABLE);

  srand(10);

#if defined(m2mtests) || defined(ALL_TESTS)
  C("=======================");
  C("MEMORY-MEMORY DMA TESTS");
  C("=======================");
 
  M2MTests();
  WaitLoop(5);
#endif

#if defined(p2mtests) || defined(ALL_TESTS)
  C("===========================");
  C("PERIPHERAL-MEMORY DMA TESTS");
  C("===========================");
 
  P2MTests();
  WaitLoop(5);
#endif

#if defined(m2ptests) || defined(ALL_TESTS)
  C("===========================");
  C("MEMORY-PERIPHERAL DMA TESTS");
  C("===========================");
 
  M2PTests();
  WaitLoop(5);
#endif

#if defined(p2ptests) || defined(ALL_TESTS)
  C("===============================");
  C("PERIPHERAL-PERIPHERAL DMA TESTS");
  C("===============================");
 
  P2PTests();
  WaitLoop(5);
#endif

#if defined(twochtests) || defined(ALL_TESTS)
  C("===============================");
  C("TWO CHANNEL TESTS");
  C("===============================");

  Dmac2ChannelTests();
  WaitLoop(5);
#endif

#if MORETHAN2CHNS
#if defined(fourchtests) || defined(ALL_TESTS)
  C("===============================");
  C("FOUR CHANNEL TESTS");
  C("===============================");

  Dmac4ChannelTests();
  WaitLoop(5);
#endif
#endif MORETHAN2CHNS

#if MORETHAN4CHNS
#if defined(eightchtests) || defined(ALL_TESTS)
  C("===============================");
  C("EIGHT CHANNEL TESTS");
  C("===============================");

  Dmac8ChannelTests();
  WaitLoop(5);
#endif
#endif MORETHAN4CHNS

#if defined(dmacllitests) || defined(ALL_TESTS)
  C("===============================");
  C(" LLI TESTS");
  C("===============================");

  DmacLLITests();
  WaitLoop(5);
#endif

#if defined(dmachaltdistests) || defined(ALL_TESTS)
  C("===============================");
  C(" DMAC HALT-DISABLE TESTS");
  C("===============================");

  DMACHaltDisTests();
  WaitLoop(5);
#endif

#if defined(inttests) || defined(ALL_TESTS)
  C("===============================");
  C(" DMAC INTERRUPT TESTS");
  C("===============================");

  DMACIntTests();
  WaitLoop(5);
#endif

#if defined(mastest) || defined(ALL_TESTS)
  C("===============================");
  C(" DMAC MASTER TESTS");
  C("===============================");

  DmacMasTest();
  WaitLoop(5);
#endif

#if defined(cornertests) || defined(ALL_TESTS)
  C("===============================");
  C(" DMAC CORNER TESTS");
  C("===============================");

  DmacCornerTests();
  WaitLoop(5);
#endif

#if defined(cornertests2)
  C("===============================");
  C(" DMAC CORNER TESTS2");
  C("===============================");

  DmacCornerTests2();
  WaitLoop(5);
#endif

  TestEnd();
  return 0;
}

/********************************* End of MAIN ********************************/
