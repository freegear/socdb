/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Smc.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This C code file is used to generate Integration test vectors in
--           TicTalk format. These vectors are applied to the AMBA AHB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Header files and C source files for Smc tests
--
--   Usage: make <testname> e.g. make RegisterTests
--       OR make all        - to compile all tests
--
-- To create .tif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make all
--   This will create infile.tif and tif.sim in the ./invec directory
--
-- --=========================================================================*/

/******************************************************************************/
/*** For more information on the SMC, please refer to PL092 AMBA SMC Block  ***/
/*** Specification                                                          ***/
/******************************************************************************/

/******************************************************************************/
/*** Global Variables and common functions                                  ***/
/******************************************************************************/
#include "SmcCommon.c"

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/

#if defined(transfertests) || defined(ALL_TESTS)
#include "TransferTests.c"
#endif

#if defined(responsetests) || defined(ALL_TESTS)
#include "ResponseTests.c"
#endif

/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{

  TestStart(ZERO);

  RES(LOW, , 2);

#if defined(transfertests) || defined(ALL_TESTS)
  C("==============");
  C("TRANSFER TESTS");
  C("==============");
  TransferTests();
#endif

#if defined(responsetests) || defined(ALL_TESTS)
  C("==============");
  C("RESPONSE TESTS");
  C("==============");
  ResponseTests();
#endif

  TestEnd();

  return 0;
}
