/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Ssmc.c.rca
--  File Revision          : 1.11
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This C code file is used to generate BusTalk vectors.
--           BusTalk vectors are applied to the AMBA AHB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Header files and C source files for Ssmc tests
--
--   Usage: make <testname> e.g. make RegisterTests
--       OR make all        - to compile all tests
--
--       OR make Ssmc1      |   to compile selectively so as to avoid
--       OR make Ssmc2      |   loading problems during simulation
--       OR make Ssmc3      |
--          make Ssmc4          to compile Denali Tests
--
--   This will create infile.bif and bif.sim in the ./invec directory
--
-- --=========================================================================*/

/******************************************************************************/
/*** For more information on the SSMC, please refer to PL092 AMBA SSMC Block***/
/*** Specification                                                          ***/
/******************************************************************************/

/******************************************************************************/
/*** Global Variables and common functions                                  ***/
/******************************************************************************/
#include "SsmcCommon.c"

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/

#if defined(resettests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "ResetTests.c"
#endif

#if defined(registertests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "RegisterTests.c"
#endif

#if defined(sywrrdtests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyWRRDTests.c"
#endif

#if defined(asywrrdtests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "AsyWRRDTests.c"
#endif

#if defined(asybankcrossingtests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "AsyBankCrossingTests.c"
#endif

#if defined(sybankcrossingtests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyBankCrossingTests.c"
#endif

#if defined(bankcrossingtests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "BankCrossingTests.c"
#endif

#if defined(ssmcendiantests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "SsmcEndianTests.c"
#endif

#if defined(addrtoggletests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "AddrToggleTests.c"
#endif

#if defined(addradvancetests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "AddrAdvanceTests.c"
#endif

#if defined(addrvalidtests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "AddrValidTests.c"
#endif

#if defined(transfertests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "TransferTests.c"
#endif

#if defined(smwaitflagtests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "SMWAITFlagTests.c"
#endif

#if defined(ssmctranseqtests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SsmcTranSeqTests.c"
#endif

#if defined(syburstwaittests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyBurstWaitTests.c"
#endif

#if defined(syaddrtoggletests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyAddrToggleTests.c"
#endif

#if defined(sycstests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyCSTests.c"
#endif

#if defined(sybromtests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyBROMTests.c"
#endif

#if defined(sybusaccesstests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyBusAccessTests.c"
#endif

#if defined(syendiantests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyEndianTests.c"
#endif

#if defined(symemorybanktests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyMemoryBankTests.c"
#endif

#if defined(busaccesstests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "BusAccessTests.c"
#endif

#if defined(syromtests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyROMTests.c"
#endif

#if defined(romtests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "ROMTests.c"
#endif

#if defined(busgnttests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "BusGntTests.c"
#endif

#if defined(bromtests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "BROMTests.c"
#endif

#if defined(rbletests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "RBLETests.c"
#endif

#if defined(cstests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "CSTests.c"
#endif

#if defined(wrapreadtests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "WrapReadTests.c"
#endif

#if defined(protectiontests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "ProtectionTests.c"
#endif

#if defined(ssmcsmwaittests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "SsmcSMWAITTests.c"
#endif

#if defined(performancetests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "PerformanceTests.c"
#endif

#if defined(delayvaluetests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "DelayValueTests.c"
#endif

#if defined(memorybanktests) || defined(Ssmc3) || defined(ALL_TESTS)
#include "MemoryBankTests.c"
#endif

#if defined(syrandomtests) || defined(Ssmc2) || defined(ALL_TESTS)
#include "SyRandomTests.c"
#endif

#if defined(randomtests) || defined(Ssmc1) || defined(ALL_TESTS)
#include "RandomTests.c"
#endif

#if defined(denalitests) || defined(Ssmc4)
#include "DenaliTests.c"
#endif

#if defined(denalitests1) || defined(Ssmc4)
#include "DenaliTests1.c"
#endif

#if defined(denalitests3) || defined(Ssmc4)
#include "DenaliTests3.c"
#endif

/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{

  TestStart(ZERO);

  RES(LOW, , 3);
  WaitLoop(8);
#if defined(resettests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("===========");
  C("RESET TESTS");
  C("===========");
  ResetTests();
#endif

#if defined(registertests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("=========================");
  C("REGISTER READ/WRITE TESTS");
  C("=========================");
  RegisterTests();
#endif

#if defined(addrtoggletests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("====================");
  C("ADDRESS TOGGLE TESTS");
  C("====================");
  AddrToggleTests();
#endif

#if defined(addrvalidtests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("====================");
  C("ADDRESS VALID TESTS");
  C("====================");
  AddrValidTests();
#endif

#if defined(addradvancetests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("====================");
  C("ADDRESS ADVANCE TESTS");
  C("====================");
  AddrAdvanceTests();
#endif

#if defined(asybankcrossingtests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("================================");
  C("ASYNCHRONOUS BANK CROSSING TESTS");
  C("================================");
  AsyBankCrossingTests();
#endif

#if defined(sybankcrossingtests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("===============================");
  C("SYNCHRONOUS BANK CROSSING TESTS");
  C("===============================");
  SyBankCrossingTests();
#endif

#if defined(bankcrossingtests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("=========================");
  C("MIXED BANK CROSSING TESTS");
  C("=========================");
  BankCrossingTests();
#endif

#if defined(transfertests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("==============");
  C("TRANSFER TESTS");
  C("==============");
  TransferTests();
#endif

#if defined(smwaitflagtests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("=================");
  C("SMWAIT FLAG TESTS");
  C("=================");
  SMWAITFlagTests();
#endif

#if defined(ssmctranseqtests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("============================");
  C("SSMC TRANSFER SEQUENCE TESTS");
  C("============================");
  SsmcTranSeqTests();
#endif

#if defined(syburstwaittests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("============================");
  C("SYNCHRONOUS BURST WAIT TESTS");
  C("============================");
  SyBurstWaitTests();
#endif

#if defined(sywrrdtests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("=============================");
  C("SYNCHRONOUS WRITE READ TESTS");
  C("=============================");
  SyWrRdTests();
#endif

#if defined(asywrrdtests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("=============================");
  C("ASYNCHRONOUS WRITE READ TESTS");
  C("=============================");
  AsyWrRdTests();
#endif

#if defined(ssmcendiantests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("=================");
  C("SSMC ENDIAN TESTS");
  C("=================");
  SsmcEndianTests();
#endif

#if defined(busaccesstests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("================");
  C("BUS ACCESS TESTS");
  C("================");
  BusAccessTests();
#endif

#if defined(syromtests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("======================");
  C("SYNCHRONOUS ROM TESTS");
  C("======================");
  SyROMTests();
#endif

#if defined(romtests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("=========");
  C("ROM TESTS");
  C("=========");
  ROMTests();
#endif

#if defined(busgnttests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("=======================");
  C("BUS GRANT/DEGRANT TESTS");
  C("=======================");
  BusGntTests();
#endif

#if defined(bromtests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("==========");
  C("BROM TESTS");
  C("==========");
  BROMTests();
#endif

#if defined(rbletests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("==========");
  C("RBLE TESTS");
  C("==========");
  RBLETests();
#endif

#if defined(cstests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("=================");
  C("CHIP SELECT TESTS");
  C("=================");
  CSTests();
#endif

#if defined(wrapreadtests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("=================");
  C("WRAP READ TESTS");
  C("=================");
  WrapReadTests();
#endif

#if defined(protectiontests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("================");
  C("PROTECTION TESTS");
  C("================");
  ProtectionTests();
#endif

#if defined(ssmcsmwaittests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("=================");
  C("SSMC SMWAIT TESTS");
  C("=================");
  SsmcSMWAITTests();
#endif

#if defined(performancetests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("=================");
  C("PERFORMANCE TESTS");
  C("=================");
  PerformanceTests();
#endif

#if defined(delayvaluetests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("=================");
  C("DELAY VALUE TESTS");
  C("=================");
  DelayValueTests();
#endif

#if defined(memorybanktests) || defined(Ssmc3) || defined(ALL_TESTS)
  C("=================");
  C("MEMORY BANK TESTS");
  C("=================");
  MemoryBankTests();
#endif

#if defined(syaddrtoggletests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("================================");
  C("SYNCHRONOUS ADDRESS TOGGLE TESTS");
  C("================================");
  SyAddrToggleTests();
#endif

#if defined(sycstests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("=============================");
  C("SYNCHRONOUS CHIP SELECT TESTS");
  C("=============================");
  SyCSTests(); 
#endif

#if defined(syendiantests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("===========================");
  C("SYNCHRONOUS ENDIANESS TESTS");
  C("===========================");
  SyEndianTests(); 
#endif

#if defined(sybromtests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("===========================");
  C("SYNCHRONOUS BURST ROM TESTS");
  C("===========================");
  SyBROMTests(); 
#endif

#if defined(symemorybanktests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("=============================");
  C("SYNCHRONOUS MEMORY BANK TESTS");
  C("===========i=================");
  SyMemoryBankTests();
#endif

#if defined(sybusaccesstests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("===========================");
  C("SYNCHRONOUS BUSACCESS TESTS");
  C("===========================");
  SyBusAccessTests();
#endif

#if defined(syrandomtests) || defined(Ssmc2) || defined(ALL_TESTS)
  C("========================");
  C("SYNCHRONOUS RANDOM TESTS");
  C("========================");
  SyRandomTests();
#endif

#if defined(randomtests) || defined(Ssmc1) || defined(ALL_TESTS)
  C("============");
  C("RANDOM TESTS");
  C("============");
  RandomTests();
#endif

#if defined(denalitests) || defined(Ssmc4)
  C("===============================");
  C("DENALI MEMORY MODEL BASED TESTS");
  C("===============================");
  DenaliTests();
#endif

#if defined(denalitests1) || defined(Ssmc4)
  C("===============================");
  C("DENALI1 MEMORY MODEL BASED TESTS");
  C("===============================");
  DenaliTests1();
#endif

#if defined(denalitests3) || defined(Ssmc4)
  C("===========================================");
  C("SYNCHRONOUS DENALI MEMORY MODEL BASED TESTS");
  C("===========================================");
  DenaliTests3();
#endif


  TestEnd();

  return 0;
}

/************************************ End *************************************/
