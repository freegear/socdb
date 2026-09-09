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
-- File Name              : Vic.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : 
--           This C code file is used to generate Integration test 
--           vectors in TicTalk format. These vectors are applied
--           to the AMBA AHB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Vic.h, Vic.c, IntegrationTest.c, RegAccessTests.c
--
--   Usage: make <testname> e.g. make all
--
--   To create .tif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make all
--   This will create infile.tif and tif.sim in the ./invec directory
--
-- --=========================================================================*/
 
/******************************************************************************/
/*** For more information on the VIC, please refer to PL192 AMBA            ***/
/*** VIC Block Specification                                                ***/
/******************************************************************************/

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/
#include "VicCommon.c"

#if defined(regaccesstests) || defined(ALL_TESTS)
#include "RegAccessTests.c"
#endif

#if defined(integrationtest) || defined(ALL_TESTS)
#include "IntegrationTest.c"
#endif

/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

int main()
{

  TestStart(0);
 
  RES(LOW, , 0x2);

  /** Issue a Control Vector to configure the TIC **/
  /** HSIZE = WORD                                **/
  /** HADDR = Incrementing                        **/
  /** HLOCK = Un-Locked                           **/
  /** HPROT = User mode                           **/
  TCV(0x40000000, WRD, 1, 0, 0x0);

#if defined(regaccesstests) || defined(ALL_TESTS)
  C("AHB I/Os -> CONNECTIVITY TESTS");
  RegAccessTests();
#endif
 
#if defined(integrationtest) || defined(ALL_TESTS)
  C("INTRA-CHIP I/Os -> CONNECTIVITY TESTS");
  IntegrationTest();
#endif

  TestEnd();
  return 0;

}

/********************************* End of MAIN ********************************/
