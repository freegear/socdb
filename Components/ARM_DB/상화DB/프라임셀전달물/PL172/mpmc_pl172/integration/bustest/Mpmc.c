/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001-2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Mpmc.c.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This C code file is used to generate Integration test vectors in
--           TicTalk format. These vectors are applied to the AMBA AHB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Header files and C source files for Mpmc tests
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
/*** For more information on the MPMC, please refer to PL172 AMBA MPMC Block***/
/*** Specification                                                          ***/
/******************************************************************************/

/******************************************************************************/
/*** Global Variables and common functions                                  ***/
/******************************************************************************/
#include "MpmcCommon.c"

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/

#if defined(transfertests) || defined(ALL_TESTS)
#include "TransferTests.c"
#endif

#if defined(responsetests) || defined(ALL_TESTS)
#include "ResponseTests.c"
#endif

#if defined(integrationtest) || defined(ALL_TESTS)
#include "IntegrationTest.c"
#endif

#if defined(intregistertest) || defined(ALL_TESTS)
#include "IntRegisterTest.c"
#endif
/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{

  TestStart(ZERO);

  RES(LOW, , 2);
/******************************************************************************/
/***    Performs different types of transfers from TIC to generic slave      ***/
/***         and verify the response recieved from generic slave.           ***/
/******************************************************************************/
#if defined(transfertests) || defined(ALL_TESTS)
  C("==============");
  C("TRANSFER TESTS");
  C("==============");
  TransferTests();
#endif

/******************************************************************************/
/*** Test where ERROR/RETRY/SPLIT Response tests are done on the TIC        ***/
/******************************************************************************/
#if defined(responsetests) || defined(ALL_TESTS)
  C("==============");
  C("RESPONSE TESTS");
  C("==============");
  ResponseTests();
#endif

/******************************************************************************/
/*** Test to make sure that all the intra chips signals are correctly       ***/
/*** connected                                                              ***/
/******************************************************************************/
#if defined(integrationtest) || defined(ALL_TESTS)
  C("=================");
  C("INTEGRATION TESTS");
  C("=================");
  IntegrationTest();
#endif

/******************************************************************************/
/*** Test to make sure that all registers bits all toggled                  ***/
/******************************************************************************/
#if defined(intregistertest) || defined(ALL_TESTS)
  C("======================");
  C("INTEGRATION  REG TESTS");
  C("======================");
  IntRegisterTest();
#endif
  TestEnd();

  return 0;
}
