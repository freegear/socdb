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
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
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
--       OR make Vic3       
--
--   This will create infile.bif and bif.sim in the ./invec directory
--
-- --=========================================================================*/


/******************************************************************************/
/*** For more information on the VIC, please refer to PL192 AMBA            ***/
/*** VIC Block Specification                                                ***/
/******************************************************************************/

/******************************************************************************/
/*** Global Variables and common functions                                  ***/
/******************************************************************************/
#include "VicCommon.c"
/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/
#if defined(vicenuseroneinttests0) || defined(vicenuseroneinttests1) || defined(vicenuseroneinttests2) || defined(vicenuseroneinttests3) || defined(vicenuseroneinttests4) || defined(vicenuseroneinttests5) || defined(vicenuseroneinttests6) || defined(vicenuseroneinttests7) || defined(vicentwofourinttests) || defined(viceneightallinttests) || defined(vicenallinttest) || defined(clockofftest) || defined(vicsyncentest)
#include "IntRoutines.c"
#include "VicIntServ.c"
#endif

#if defined(useroneinttests0) || defined(useroneinttests1) || defined(useroneinttests2) || defined(useroneinttests3) || defined(useroneinttests4) || defined(useroneinttests5) || defined(useroneinttests6) || defined(useroneinttests7)  
#include "IntRoutines.c"
#endif

#if defined(useroneinttests) || defined(twofourinttests) || defined(eightallinttests) || defined(allinttest) || defined(Vic1) || defined(Vic2) || defined(Vic3) || defined(ALL_TESTS)
#include "IntRoutines.c"
#include "VicIntServ.c"
#endif

#if defined(stack16test) || defined(vicenstack16test) || defined(vicendaisypritest) || defined(randomtest)
#include "IntRoutines.c"
#include "VicIntServ.c"
#endif

#if defined(resettests) || defined(Vic1) || defined(ALL_TESTS)
#include "ResetTests.c"
#endif

#if defined(useroneinttests7) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests7.c"
#endif

#if defined(useroneinttests6) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests6.c"
#endif

#if defined(useroneinttests5) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests5.c"
#endif

#if defined(useroneinttests4) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests4.c"
#endif

#if defined(useroneinttests3) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests3.c"
#endif

#if defined(useroneinttests2) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests2.c"
#endif

#if defined(useroneinttests1) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests1.c"
#endif

#if defined(useroneinttests0) || defined(Vic2) || defined(ALL_TESTS) 
#include "UserOneIntTests0.c"
#endif

#if defined(twofourinttests) || defined(Vic2) || defined(ALL_TESTS)
#include "TwoFourIntTests.c"
#endif

#if defined(eightallinttests) || defined(Vic2) || defined(ALL_TESTS) 
#include "EightAllIntTests.c"
#endif
 
#if defined(allinttest) || defined(Vic2) || defined(ALL_TESTS) 
#include "AllIntTest.c"
#endif
 
#if defined(vicenuseroneinttests0) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnUserOneIntTests0.c"
#endif

#if defined(vicenuseroneinttests1) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnUserOneIntTests1.c"
#endif

#if defined(vicenuseroneinttests2) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnUserOneIntTests2.c"
#endif

#if defined(vicenuseroneinttests3) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnUserOneIntTests3.c"
#endif

#if defined(vicenuseroneinttests4) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnUserOneIntTests4.c"
#endif

#if defined(vicenuseroneinttests5) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnUserOneIntTests5.c"
#endif

#if defined(vicenuseroneinttests6) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnUserOneIntTests6.c"
#endif

#if defined(vicenuseroneinttests7) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnUserOneIntTests7.c"
#endif


#if defined(vicentwofourinttests) || defined(Vic3) || defined(ALL_TESTS)
#include "VicEnTwoFourIntTests.c"
#endif

#if defined(viceneightallinttests) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnEightAllIntTests.c"
#endif
 
#if defined(vicenallinttest) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnAllIntTest.c"
#endif
 
#if defined(stack16test) || defined(Vic2) || defined(ALL_TESTS) 
#include "Stack16Test.c"
#endif
 
#if defined(vicenstack16test) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnStack16Test.c"
#endif
 
#if defined(randomtest) || defined(Vic2) || defined(ALL_TESTS) 
#include "RandomTest.c"
#endif

#if defined(clockofftest) || defined(Vic2) || defined(ALL_TESTS) 
#include "ClockOffTest.c"
#endif

#if defined(vicsyncentest) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicSyncEnTest.c"
#endif
 
#if defined(vicendaisypritest) || defined(Vic3) || defined(ALL_TESTS) 
#include "VicEnDaisyPriTest.c"
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
 
#if defined(priconsistency) || defined(Vic2) || defined(ALL_TESTS)
#include "PriConsistency.c"
#endif

/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

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

#if defined(randomtest) || defined(Vic2) || defined(ALL_TESTS)
  C("==================");
  C("RANDOM VALUES TEST");
  C("==================");
  RandomTest();
#endif

#if defined(stack16test) || defined(Vic2) || defined(ALL_TESTS)
  C("======================================================");
  C("16 INTERRUPT STACKING TEST - TESTING 15 IRQ AND DAISY");
  C("======================================================");
  Stack16Test();
#endif

#if defined(useroneinttests7) || defined(Vic2) || defined(ALL_TESTS)
  C("============================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS - SET 7");
  C("============================================");
  UserOneIntTests7();
#endif

#if defined(priconsistency) || defined(Vic2) || defined(ALL_TESTS)
  C("===========================");
  C("PRIORITY CONSISTENCY TEST");
  C("===========================");
  PriConsistency();
#endif

#if defined(useroneinttests6) || defined(Vic2) || defined(ALL_TESTS)
  C("============================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS - SET 6");
  C("============================================");
  UserOneIntTests6();
#endif

#if defined(useroneinttests5) || defined(Vic2) || defined(ALL_TESTS)
  C("============================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS - SET 5");
  C("============================================");
  UserOneIntTests5();
#endif

#if defined(useroneinttests4) || defined(Vic2) || defined(ALL_TESTS)
  C("============================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS - SET 4");
  C("============================================");
  UserOneIntTests4();
#endif

#if defined(useroneinttests3) || defined(Vic2) || defined(ALL_TESTS)
  C("============================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS - SET 3");
  C("============================================");
  UserOneIntTests3();
#endif

#if defined(useroneinttests2) || defined(Vic2) || defined(ALL_TESTS)
  C("============================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS - SET 2");
  C("============================================");
  UserOneIntTests2();
#endif

#if defined(useroneinttests1) || defined(Vic2) || defined(ALL_TESTS)
  C("============================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS - SET 1");
  C("============================================");
  UserOneIntTests1();
#endif

#if defined(useroneinttests0) || defined(Vic2) || defined(ALL_TESTS)
  C("============================================");
  C("USER DEFINED AND ONE INTERRUPT TESTS - SET 0");
  C("============================================");
  UserOneIntTests0();
#endif

#if defined(twofourinttests) || defined(Vic2) || defined(ALL_TESTS)
  C("============================");
  C("TWO AND FOUR INTERRUPT TESTS");
  C("============================");
  TwoFourIntTests();
#endif

#if defined(eightallinttests) || defined(Vic2) || defined(ALL_TESTS)
  C("======================================");
  C("EIGHT, SIXTEEN AND ALL INTERRUPT TESTS");
  C("======================================");
  EightAllIntTests();
#endif

#if defined(allinttest) || defined(Vic2) || defined(ALL_TESTS)
  C("===================");
  C("ALL INTERRUPT TESTS");
  C("===================");
  AllIntTest();
#endif

#if defined(vicenuseroneinttests0) || defined(Vic3) || defined(ALL_TESTS)
  C("======================================================");
  C("VIC PORT - USER DEFINED AND ONE INTERRUPT TESTS - SET0");
  C("======================================================");
  VicEnUserOneIntTests0();
#endif

#if defined(vicenuseroneinttests1) || defined(Vic3) || defined(ALL_TESTS)
  C("======================================================");
  C("VIC PORT - USER DEFINED AND ONE INTERRUPT TESTS - SET1");
  C("======================================================");
  VicEnUserOneIntTests1();
#endif

#if defined(vicenuseroneinttests2) || defined(Vic3) || defined(ALL_TESTS)
  C("======================================================");
  C("VIC PORT - USER DEFINED AND ONE INTERRUPT TESTS - SET2");
  C("======================================================");
  VicEnUserOneIntTests2();
#endif

#if defined(vicenuseroneinttests3) || defined(Vic3) || defined(ALL_TESTS)
  C("======================================================");
  C("VIC PORT - USER DEFINED AND ONE INTERRUPT TESTS - SET3");
  C("======================================================");
  VicEnUserOneIntTests3();
#endif

#if defined(vicenuseroneinttests4) || defined(Vic3) || defined(ALL_TESTS)
  C("======================================================");
  C("VIC PORT - USER DEFINED AND ONE INTERRUPT TESTS - SET4");
  C("======================================================");
  VicEnUserOneIntTests4();
#endif

#if defined(vicenuseroneinttests5) || defined(Vic3) || defined(ALL_TESTS)
  C("======================================================");
  C("VIC PORT - USER DEFINED AND ONE INTERRUPT TESTS - SET5");
  C("======================================================");
  VicEnUserOneIntTests5();
#endif

#if defined(vicenuseroneinttests6) || defined(Vic3) || defined(ALL_TESTS)
  C("======================================================");
  C("VIC PORT - USER DEFINED AND ONE INTERRUPT TESTS - SET6");
  C("======================================================");
  VicEnUserOneIntTests6();
#endif

#if defined(vicenuseroneinttests7) || defined(Vic3) || defined(ALL_TESTS)
  C("======================================================");
  C("VIC PORT - USER DEFINED AND ONE INTERRUPT TESTS - SET7");
  C("======================================================");
  VicEnUserOneIntTests7();
#endif

#if defined(vicentwofourinttests) || defined(Vic3) || defined(ALL_TESTS)
  C("=======================================");
  C("VIC PORT - TWO AND FOUR INTERRUPT TESTS");
  C("=======================================");
  VicEnTwoFourIntTests();
#endif

#if defined(viceneightallinttests) || defined(Vic3) || defined(ALL_TESTS)
  C("=================================================");
  C("VIC PORT - EIGHT, SIXTEEN AND ALL INTERRUPT TESTS");
  C("=================================================");
  VicEnEightAllIntTests();
#endif

#if defined(vicenallinttest) || defined(Vic3) || defined(ALL_TESTS)
  C("==============================");
  C("VIC PORT - ALL INTERRUPT TESTS");
  C("==============================");
  VicEnAllIntTest();
#endif

#if defined(vicenstack16test) || defined(Vic3) || defined(ALL_TESTS)
  C("================================================================");
  C("VIC PORT - 16 INTERRUPT STACKING TEST - TESTING 15 IRQ AND DAISY");
  C("================================================================");
  VicEnStack16Test();
#endif

#if defined(vicendaisypritest) || defined(Vic3) || defined(ALL_TESTS)
  C("================================================================");
  C("VIC PORT - Daisy Priority TEST");
  C("================================================================");
  VicEnDaisyPriTest();
#endif

#if defined(errorresptests) || defined(Vic1) || defined(ALL_TESTS) 
  C("=========================");
  C("E R R O R  RESPONSE TESTS");
  C("=========================");
  ErrorRespTests();
#endif

#if defined(transfertests) || defined(Vic1) || defined(ALL_TESTS)
  C("===================");
  C("TRANSFER TYPE TESTS");
  C("===================");
  TransferTests();
#endif

#if defined(protmodeinttests) || defined(Vic1) || defined(ALL_TESTS) 
  C("===============================");
  C("PROTECTION MODE INTERRUPT TESTS");
  C("===============================");
  ProtModeIntTests(INT1, INT2, INT3);
#endif

#if defined(clockofftest) || defined(Vic2) || defined(ALL_TESTS)
  C("==============");
  C("CLOCK OFF TEST");
  C("==============");
  ClockOffTest();
#endif

#if defined(vicsyncentest) || defined(Vic3) || defined(ALL_TESTS)
  C("==============================");
  C("VIC PORT - SYNC ENABLE TEST");
  C("==============================");
  VicSyncEnTest();
#endif

#if defined(protectiontests) || defined(Vic1) || defined(ALL_TESTS) 
  C("=====================");
  C("PROTECTION MODE TESTS");
  C("=====================");
  ProtectionTests();
#endif

#if defined(registertests) || defined(Vic1) || defined(ALL_TESTS)
  C("==============");
  C("REGISTER TESTS");
  C("==============");
  RegisterTests();
#endif

   TestEnd();

   return 0;
}

/********************************* End of MAIN ********************************/
