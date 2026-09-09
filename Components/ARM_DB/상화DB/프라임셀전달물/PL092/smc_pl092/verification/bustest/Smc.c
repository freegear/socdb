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
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
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
--          make Smc4          to compile Denali Tests
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

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/

#if defined(resettests) || defined(Smc1) || defined(ALL_TESTS)
#include "ResetTests.c"
#endif

#if defined(registertests) || defined(Smc1) || defined(ALL_TESTS)
#include "RegisterTests.c"
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

#if defined(bromtests) || defined(Smc1) || defined(ALL_TESTS)
#include "BROMTests.c"
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

#if defined(bromtests) || defined(Smc1) || defined(ALL_TESTS)
  C("==========");
  C("BROM TESTS");
  C("==========");
  BROMTests();
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

  TestEnd();

  return 0;
}

/************************************ End *************************************/
