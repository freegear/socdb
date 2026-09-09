/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Vic.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA AHB bus.
-- 
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Header files and C source files for Vic tests 
--
--   Usage: make <testname> e.g. make RegisterTests
--       OR make all        - to compile all tests
--
--       OR make Vic1      |   to compile selectively so as to avoid
--       OR make Vic2      |   loading problems during simulation
--
--   This will create infile.bif and bif.sim in the ./invec directory
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the VIC, please refer to PL190 AMBA    ***/
/*** VIC Block Specification                                        ***/
/**********************************************************************/

/**********************************************************************/
/*** Global Variables and common functions                          ***/
/**********************************************************************/
#include "VicCommon.c"

/**********************************************************************/
/*** Include the files required for the selected test               ***/
/**********************************************************************/
#if defined(useroneinttests) || defined(twofourinttests) ||                 defined(eightallinttests) || defined(Vic1) || defined(Vic2) ||          defined(ALL_TESTS)
#include "IntRoutines.c"
#endif

#if defined(resettests) || defined(Vic1) || defined(ALL_TESTS)
#include "ResetTests.c"
#endif

#if defined(registertests) || defined(Vic1) || defined(ALL_TESTS)
#include "RegisterTests.c"
#endif
 
#if defined(protectiontests) || defined(Vic1) || defined(ALL_TESTS)
#include "ProtectionTests.c"
#endif

#if defined(protmodeinttests) || defined(Vic1) || defined(ALL_TESTS)
#include "ProtModeIntTests.c"
#endif

#if defined(errorresptests) || defined(Vic1) || defined(ALL_TESTS)
#include "ErrorRespTests.c"
#endif

#if defined(transfertests) || defined(Vic1) || defined(ALL_TESTS)
#include "TransferTests.c"
#endif
 
#if defined(useroneinttests) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests.c"
#endif

#if defined(twofourinttests) || defined(Vic1) || defined(ALL_TESTS)
#include "TwoFourIntTests.c"
#endif

#if defined(csrtests) || defined(Vic1) || defined(ALL_TESTS)
#include "CSRTests.c"
#endif

#if defined(eightallinttests) || defined(Vic1) || defined(ALL_TESTS) 
#include "EightAllIntTests.c"
#endif
 
/**********************************************************************/
/********************************  MAIN  ******************************/
/**********************************************************************/

int main()
{ 

  TestStart(ZERO);

  RES(LOW, , 2);

  WaitLoop(5);

#if defined(resettests) || defined(Vic1) || defined(ALL_TESTS)
  C("===========");
  C("RESET TESTS");
  C("===========");
  ResetTests();
#endif

#if defined(registertests) || defined(Vic1) || defined(ALL_TESTS)
  C("==============");
  C("REGISTER TESTS");
  C("==============");
  RegisterTests();
#endif
 
#if defined(protectiontests) || defined(Vic1) || defined(ALL_TESTS) 
  C("=====================");
  C("PROTECTION MODE TESTS");
  C("=====================");
  ProtectionTests();
#endif

#if defined(csrtests) || defined(Vic1) || defined(ALL_TESTS) 
  C("===============================");
  C("CURRENT SERVICE REGISTER TESTS");
  C("===============================");
  CSRTests(0, 1, 2);
#endif

#if defined(protmodeinttests) || defined(Vic1) || defined(ALL_TESTS) 
  C("===============================");
  C("PROTECTION MODE INTERRUPT TESTS");
  C("===============================");
  ProtModeIntTests(INT1, INT2, INT3);
#endif

#if defined(errorresptests) || defined(Vic1) || defined(ALL_TESTS) 
  C("====================");
  C("ERROR RESPONSE TESTS");
  C("====================");
  ErrorRespTests();
#endif

#if defined(transfertests) || defined(Vic1) || defined(ALL_TESTS)
  C("===================");
  C("TRANSFER TYPE TESTS");
  C("===================");
  TransferTests();
#endif

#if defined(useroneinttests) || defined(Vic2) || defined(ALL_TESTS) 
  C("====================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS");
  C("====================================");
  UserOneIntTests();
#endif

#if defined(twofourinttests) || defined(Vic1) || defined(ALL_TESTS)
  C("============================");
  C("TWO AND FOUR INTERRUPT TESTS");
  C("============================");
  TwoFourIntTests();
#endif

#if defined(eightallinttests) || defined(Vic1) || defined(ALL_TESTS)
  C("======================================");
  C("EIGHT, SIXTEEN AND ALL INTERRUPT TESTS");
  C("======================================");
  EightAllIntTests();
#endif

   TestEnd();

   return 0;
}

/***************************** End of MAIN ****************************/
