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
--  File Name              : Smc.c.rca
--  File Revision          : 1.19
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This C code file is used to generate BusTalk vectors.
--           BusTalk vectors are applied to the AMBA AHB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Header files and C source files for Smc tests
--
--   Usage: make <testname> e.g. make RegisterTests
--       OR make all        - to compile all tests
--
--       OR make Smc1      |   to compile selectively so as to avoid
--       OR make Smc2      |   loading problems during simulation
--       OR make Smc3      |
--          make Smc4      |   to compile Denali Tests
--          make Smc5
--          make Smc6
--             
--   This will create infile.bif and bif.sim in the ./invec directory
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
#include "RandomRoutines.c"

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/

#if defined(resettests) || defined(Smc1) || defined(ALL_TESTS)
#include "ResetTests.c"
#endif

#if defined(registertests) || defined(Smc1) || defined(ALL_TESTS)
#include "RegisterTests.c"
#endif

#if defined(mixedaccesstests) || defined(Smc1) || defined(ALL_TESTS)
#include "MixedAccessTests.c"
#endif

#if defined(delayvalueromtests) || defined(Smc1) || defined(ALL_TESTS)
#include "DelayValueROMTests.c"
#endif

#if defined(addrtoggletests) || defined(Smc2) || defined(ALL_TESTS)
#include "AddrToggleTests.c"
#endif

#if defined(transfertests) || defined(Smc3) || defined(ALL_TESTS)
#include "TransferTests.c"
#endif

#if defined(bankcrossingtests) || defined(Smc2) || defined(ALL_TESTS)
#include "BankCrossingTests.c"
#endif

#if defined(busaccesstests) || defined(Smc2) || defined(ALL_TESTS)
#include "BusAccessTests.c"
#endif

#if defined(romtests) || defined(Smc1) || defined(ALL_TESTS)
#include "ROMTests.c"
#endif

#if defined(cornercase2) || defined(Smc4) || defined(ALL_TESTS)
#include "Cornercase2.c"
#endif

#if defined(cornercase3) || defined(Smc4) || defined(ALL_TESTS)
#include "Cornercase3.c"
#endif

#if defined(cornercase4) || defined(Smc4) || defined(ALL_TESTS)
#include "Cornercase4.c"
#endif

#if defined(cornercase1) || defined(Smc4) || defined(ALL_TESTS)
#include "Cornercase1.c"
#endif

#if defined(bromdelaytest) || defined(Smc5) || defined(ALL_TESTS)
#include "BROMDelayTest.c"
#endif

#if defined(ebicornercase) || defined(Smc6) || defined(ALL_TESTS)
#include "EbiCornerCase.c"
#endif

#if defined(bromtests) || defined(Smc1) || defined(ALL_TESTS)
#include "BROMTests.c"
#endif

#if defined(brombusyinsertiontest) || defined(Smc4) || defined(ALL_TESTS)
#include "BROMBusyInsertionTest.c"
#endif

#if defined(rbletests) || defined(Smc1) || defined(ALL_TESTS)
#include "RBLETests.c"
#endif

#if defined(cstests) || defined(Smc2) || defined(ALL_TESTS)
#include "CSTests.c"
#endif

#if defined(endiannesstests) || defined(Smc1) || defined(ALL_TESTS)
#include "EndiannessTests.c"
#endif

#if defined(remaptests) || defined(Smc1) || defined(ALL_TESTS)
#include "RemapTests.c"
#endif

#if defined(protectiontests) || defined(Smc2) || defined(ALL_TESTS)
#include "ProtectionTests.c"
#endif

#if defined(smwaittests) || defined(Smc1) || defined(ALL_TESTS)
#include "SMWAITTests.c"
#endif

#if defined(smwaitflagtests) || defined(Smc2) || defined(ALL_TESTS)
#include "SMWAITFlagTests.c"
#endif

#if defined(delayvaluetests) || defined(Smc2) || defined(ALL_TESTS)
#include "DelayValueTests.c"
#endif

#if defined(memorybanktests) || defined(Smc2) || defined(ALL_TESTS)
#include "MemoryBankTests.c"
#endif

#if defined(performancetests) || defined(Smc2) || defined(ALL_TESTS)
#include "PerformanceTests.c"
#endif

#if defined(randomtests) || defined(Smc1) || defined(ALL_TESTS)
#include "RandomTests.c"
#endif

#if defined(mcreqgnttests) || defined(Smc1) || defined(ALL_TESTS)
#include "MCReqGntTests.c"
#endif

#if defined(denalitests) || defined(Smc4)
#include "DenaliTests.c"
#endif

#if defined(bigendhbursttest) || defined(Smc1) || defined(ALL_TESTS)
#include "BigEndHburstTest.c"
#endif

#if defined(oneclkafterreset) || defined(Smc1) || defined(ALL_TESTS)
#include "OneClkAfterReset.c"
#endif

#if defined(bromcornercase) || defined(Smc1) || defined(ALL_TESTS)
#include "BROMCornerCase.c"
#endif

#if defined(wperrortest) || defined(Smc1) || defined(ALL_TESTS)
#include "WPErrorTest.c"
#endif

#if defined(cornercase6) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase6.c"
#endif

#if defined(cornercase7) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase7.c"
#endif

#if defined(cornercase8) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase8.c"
#endif


#if defined(cornercase9) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase9.c"
#endif


#if defined(cornercase10) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase10.c"
#endif


#if defined(cornercase11) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase11.c"
#endif


#if defined(cornercase12) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase12.c"
#endif

#if defined(cornercase14) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase14.c"
#endif

#if defined(cornercase5) || defined(Smc1) || defined(ALL_TESTS)
#include "Cornercase5.c"
#endif

#if defined(busyinscornercase) || defined(Smc4) || defined(ALL_TESTS)
#include "BusyInsCornerCase.c"
#endif

#if defined(newrandomtest) || defined(Smc6) || defined(ALL_TESTS)
#include "NewRandomTest.c"
#endif
/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{

  TestStart(ZERO);

  RES(LOW, , 2);

#if defined(resettests) || defined(Smc1) || defined(ALL_TESTS)
  C("===========");
  C("RESET TESTS");
  C("===========");
  ResetTests();
#endif

#if defined(registertests) || defined(Smc1) || defined(ALL_TESTS)
  C("=========================");
  C("REGISTER READ/WRITE TESTS");
  C("=========================");
  RegisterTests();
#endif

#if defined(mixedaccesstests) || defined(Smc1) || defined(ALL_TESTS)
  C("==================");
  C("MIXED ACCESS TESTS");
  C("==================");
  MixedAccessTests();
#endif

#if defined(delayvalueromtests) || defined(Smc1) || defined(ALL_TESTS)
  C("=====================");
  C("DELAY VALUE ROM TESTS");
  C("=====================");
  DelayValueROMTests();
#endif

#if defined(endiannesstests) || defined(Smc1) || defined(ALL_TESTS)
  C("================");
  C("ENDIANNESS TESTS");
  C("================");
  EndiannessTests();
#endif

#if defined(addrtoggletests) || defined(Smc2) || defined(ALL_TESTS)
  C("====================");
  C("ADDRESS TOGGLE TESTS");
  C("====================");
  AddrToggleTests();
#endif

#if defined(bankcrossingtests) || defined(Smc2) || defined(ALL_TESTS)
  C("===================");
  C("BANK CROSSING TESTS");
  C("===================");
  BankCrossingTests();
#endif

#if defined(transfertests) || defined(Smc3) || defined(ALL_TESTS)
  C("==============");
  C("TRANSFER TESTS");
  C("==============");
  TransferTests();
#endif

#if defined(busaccesstests) || defined(Smc2) || defined(ALL_TESTS)
  C("================");
  C("BUS ACCESS TESTS");
  C("================");
  BusAccessTests();
#endif

#if defined(romtests) || defined(Smc1) || defined(ALL_TESTS)
  C("=========");
  C("ROM TESTS");
  C("=========");
  ROMTests();
#endif

#if defined(cornercase2) || defined(Smc4) || defined(ALL_TESTS)
  C("=========");
  C("Cornercase2 ");
  C("=========");
  Cornercase2();
#endif

#if defined(cornercase3) || defined(Smc4) || defined(ALL_TESTS)
  C("=========");
  C("Cornercase3 ");
  C("=========");
  Cornercase3();
#endif

#if defined(cornercase4) || defined(Smc4) || defined(ALL_TESTS)
  C("=========");
  C("Cornercase4 ");
  C("=========");
  Cornercase4();
#endif

#if defined(cornercase1) || defined(Smc4) || defined(ALL_TESTS)
  C("=========");
  C("Cornercase1 ");
  C("=========");
  Cornercase1();
#endif

#if defined(bromdelaytest) || defined(Smc5) || defined(ALL_TESTS)
  C("=========");
  C("BROMDelayTest ");
  C("=========");
  BROMDelayTest();
#endif

#if defined(ebicornercase) || defined(Smc6) || defined(ALL_TESTS)
  C("=========");
  C("EbiCornerCase ");
  C("=========");
  EbiCornerCase();
#endif

#if defined(bromtests) || defined(Smc1) || defined(ALL_TESTS)
  C("==========");
  C("BROM TESTS");
  C("==========");
  BROMTests();
#endif

#if defined(brombusyinsertiontest) || defined(Smc4) || defined(ALL_TESTS)
  C("==========");
  C("BROM TESTS");
  C("==========");
  BROMBusyInsertionTest();
#endif

#if defined(rbletests) || defined(Smc1) || defined(ALL_TESTS)
  C("==========");
  C("RBLE TESTS");
  C("==========");
  RBLETests();
#endif

#if defined(cstests) || defined(Smc2) || defined(ALL_TESTS)
  C("=================");
  C("CHIP SELECT TESTS");
  C("=================");
  CSTests();
#endif

#if defined(remaptests) || defined(Smc1) || defined(ALL_TESTS)
  C("=======================");
  C("REMAP and SMMWCS7 TESTS");
  C("=======================");
  RemapTests();
#endif

#if defined(protectiontests) || defined(Smc2) || defined(ALL_TESTS)
  C("================");
  C("PROTECTION TESTS");
  C("================");
  ProtectionTests();
#endif

#if defined(smwaittests) || defined(Smc1) || defined(ALL_TESTS)
  C("============");
  C("SMWAIT TESTS");
  C("============");
  SMWAITTests();
#endif

#if defined(smwaitflagtests) || defined(Smc2) || defined(ALL_TESTS)
  C("=================");
  C("SMWAIT FLAG TESTS");
  C("=================");
  SMWAITFlagTests();
#endif

#if defined(delayvaluetests) || defined(Smc2) || defined(ALL_TESTS)
  C("=================");
  C("DELAY VALUE TESTS");
  C("=================");
  DelayValueTests();
#endif

#if defined(memorybanktests) || defined(Smc2) || defined(ALL_TESTS)
  C("=================");
  C("MEMORY BANK TESTS");
  C("=================");
  MemoryBankTests();
#endif

#if defined(performancetests) || defined(Smc2) || defined(ALL_TESTS)
  C("=================");
  C("PERFORMANCE TESTS");
  C("=================");
  PerformanceTests();
#endif

#if defined(mcreqgnttests) || defined(Smc1) || defined(ALL_TESTS)
  C("=========================");
  C("MCBUS REQUEST-GRANT TESTS");
  C("=========================");
  MCReqGntTests();
#endif

#if defined(randomtests) || defined(Smc1) || defined(ALL_TESTS)
  C("============");
  C("RANDOM TESTS");
  C("============");
  RandomTests();
#endif

#if defined(denalitests) || defined(Smc4)
  C("===============================");
  C("DENALI MEMORY MODEL BASED TESTS");
  C("===============================");
  DenaliTests();
#endif

#if defined(bigendhbursttest) || defined(Smc1) || defined(ALL_TESTS)
  C("===========================================");
  C("BIG ENDIAN TEST FOR ALL BURST & TRANS TYPES");
  C("===========================================");
  BigEndHburstTest();
#endif

#if defined(oneclkafterreset) || defined(Smc1) || defined(ALL_TESTS)
  C("========================");
  C("ONE CLK AFTER RESET TEST");
  C("========================");
  OneClkAfterReset();
#endif

#if defined(bromcornercase) || defined(Smc1) || defined(ALL_TESTS)
  C("================");
  C("BROM CORNER CASE");
  C("================");
  BROMCornerCase();
#endif

#if defined(wperrortest) || defined(Smc1) || defined(ALL_TESTS)
  C("===================================");
  C("WRITE PROTECT ERROR GENERATION TEST");
  C("===================================");
  WPErrorTest();
#endif

#if defined(cornercase6) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 6");
  C("=============");
  Cornercase6();
#endif

#if defined(cornercase7) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 7");
  C("=============");
  Cornercase7();
#endif


#if defined(cornercase8) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 8");
  C("=============");
  Cornercase8();
#endif


#if defined(cornercase9) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 9");
  C("=============");
  Cornercase9();
#endif


#if defined(cornercase10) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 10");
  C("=============");
  Cornercase10();
#endif


#if defined(cornercase11) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 11");
  C("=============");
  Cornercase11();
#endif


#if defined(cornercase12) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 12");
  C("=============");
  Cornercase12();
#endif


#if defined(cornercase14) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 14");
  C("=============");
  Cornercase14();
#endif


#if defined(cornercase5) || defined(Smc1) || defined(ALL_TESTS)
  C("=============");
  C("CORNER CASE 5");
  C("=============");
  Cornercase5();
#endif

#if defined(busyinscornercase) || defined(Smc4) || defined(ALL_TESTS)
  C("==========================");
  C("BUSY INSERTION CORNER CASE");
  C("==========================");
  BusyInsCornerCase();
#endif

#if defined(newrandomtest) || defined(Smc6) || defined(ALL_TESTS)
  C("================");
  C("NEW RANDOM TESTS");
  C("================");
  NewRandomTest();
#endif
  TestEnd();

  return 0;
}

/************************************ End *************************************/
