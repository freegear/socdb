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
-- File Name              : Mpmc.c.rca
-- File Revision          : 1.12
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA AHB bus.
-- 
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c, config.h,
--     addargs_script, Header files and C source files for Mpmc tests.
--
--   Usage: make <testname> e.g. make ResetTests
--
--
--   This will create infile.bif and bif.sim in the ./invec directory
--
-- --=========================================================================*/

/******************************************************************************/
/*** For more information on the MPMC, please refer to PL172 AMBA MPMC      ***/
/*** Block Specification.                                                   ***/
/******************************************************************************/

/******************************************************************************/
/*** Global Variables and common functions                                  ***/
/******************************************************************************/
#include "Common.c"
#include "StCommon.c"
/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/
 
#if defined(poresettest)
#include "POResetTest.c"
#endif

#if defined(hresettest)
#include "HResetTest.c"
#endif
 
#if defined(mpmcregistertests)
#include "MpmcRegisterTests.c"
#endif

#if defined(mpmcenabletest)
#include "MPMCEnableTest.c"
#endif

#if defined(controllerbusytest)
#include "ControllerBusyTest.c"
#endif

#if defined(lowpwrmodetest)
#include "LowPwrModeTest.c"
#endif

#if defined(addrtoggletest)
#include "AddrToggleTest.c"
#endif

#if defined(addrmirrtest)
#include "AddrMirrTest.c"
#endif

#if defined(cspolaritytest)
#include "CSPolarityTest.c"
#endif

#if defined(sdraminitrtnchk)
#include "SdramInitRtnChk.c"
#endif

#if defined(clkctrltest)
#include "ClkCtrlTest.c"
#endif

#if defined(clkenabletest)
#include "ClkEnableTest.c"
#endif 

#if defined(romtest)
#include "ROMTest.c"
#endif

#if defined(delayvaluetests)
#include "DelayValueTests.c"
#endif

#if defined(stwtpgtest)
#include "StWtPgTest.c"
#endif

#if defined(stwtpgbufentest)
#include "StWtPgBufEnTest.c"
#endif

#if defined(blsdelayvaluetests)
#include "BLSDelayValueTests.c"
#endif

#if defined(exdwaitdeltest)
#include "ExdWaitDelTest.c"
#endif
     
#if defined(endiannesstests)
#include "EndiannessTests.c"
#endif

#if defined(bigendianpintest)
#include "BigEndianPinTest.c"
#endif

#if defined(busyinsertiontest)
#include "BusyInsertionTest.c"
#endif

#if defined(busdegranttest)
#include "BusDegrantTest.c"
#endif

#if defined(lowpwrsdramfuntest)
#include "LowPwrSdramFunTest.c"
#endif

#if defined(reffreqchk)
#include "RefFreqChk.c"
#endif

#if defined(selfrefchk)
#include "SelfRefChk.c"
#endif

#if defined(selrefprioritytest)
#include "SelRefPriorityTest.c"
#endif

#if defined(wrprottest)
#include "WrProtTest.c"
#endif

#if defined(rdrefalntest)
#include "RdRefAlnTest.c"
#endif

#if defined(syncflashtest)
#include "SyncFlashTest.c"
#endif

#if defined(hbursttest)
#include "HburstTest.c"
#endif

#if defined(bigendhbursttest)
#include "BigEndHburstTest.c"
#endif

#if defined(dyhbursttest1)
#include "DyHburstTest1.c"
#endif

#if defined(dyhbursttest2)
#include "DyHburstTest2.c"
#endif

#if defined(dyhbursttesttb5)
#include "DyHburstTestTB5.c"
#endif

#if defined(dyhbursttesttb7)
#include "DyHburstTestTB7.c"
#endif

#if defined(dyhbursttesttb8)
#include "DyHburstTestTB8.c"
#endif

#if defined(dyhbursttesttb9)
#include "DyHburstTestTB9.c"
#endif

#if defined(dyhbursttesttb10)
#include "DyHburstTestTB10.c"
#endif

#if defined(dyhburstclkrattb7test)
#include "DyHburstClkRatTB7Test.c"
#endif

#if defined(dyhburstclkrattb8test)
#include "DyHburstClkRatTB8Test.c"
#endif

#if defined(dyhburstclkrattb9test)
#include "DyHburstClkRatTB9Test.c"
#endif

#if defined(randhbursttest)
#include "RandHburstTest.c"
#endif

#if defined(randhbursttest1)
#include "RandHburstTest1.c"
#endif

#if defined(randhbursttest2)
#include "RandHburstTest2.c"
#endif

#if defined(transfertest)
#include "TransferTest.c"
#endif

#if defined(idleport)
#include "IdlePort.c"
#endif

#if defined(idleport1)
#include "IdlePort1.c"
#endif

#if defined(cornercases1)
#include "CornerCases1.c"
#endif

#if defined(cornercases2)
#include "CornerCases2.c"
#endif

#if defined(cornercases3)
#include "CornerCases3.c"
#endif

#if defined(cornercases4)
#include "CornerCases4.c"
#endif

#if defined(cornercases5)
#include "CornerCases5.c"
#endif

#if defined(cornercases6)
#include "CornerCases6.c"
#endif

#if defined(cornercases7)
#include "CornerCases7.c"
#endif

#if defined(cornercases8)
#include "CornerCases8.c"
#endif

#if defined(arb2stwrrd)
#include "Arb2StWrRd.c"
#endif

#if defined(arb2dywrrd)
#include "Arb2DyWrRd.c"
#endif

#if defined(arb4idlebusy)
#include "Arb4IdleBusy.c"
#endif

#if defined(arb4dywrrdclkrat)
#include "Arb4DyWrRdClkRat.c"
#endif

#if defined(arb3dystwrrd)
#include "Arb3DyStWrRd.c"
#endif

#if defined(randomtest1)
#include "RandomTest1.c"
#endif

#if defined(arb3stwrrd)
#include "Arb3StWrRd.c"
#endif

#if defined(arb3dywrrd)
#include "Arb3DyWrRd.c"
#endif

#if defined(arb4dywrrd)
#include "Arb4DyWrRd.c"
#endif

#if defined(arb4stwrrd)
#include "Arb4StWrRd.c"
#endif

#if defined(arb4dystwrrd)
#include "Arb4DyStWrRd.c"
#endif

#if defined(arb2dystwrrd)
#include "Arb2DyStWrRd.c"
#endif

#if defined(memmodelhbursttest)
#include "MemModelHburstTest.c"
#endif

#if defined(arb2cornercase4)
#include "Arb2CornerCase4.c"
#endif

#if defined(memmodelstpgmodetest)
#include "MemModelStPgModeTest.c"
#endif

#if defined(memmodelpgromtest)
#include "MemModelPgROMTest.c"
#endif

#if defined(memmodelromtest)
#include "MemModelROMTest.c"
#endif

#if defined(integrationtest)
#include "IntegrationTest.c"
#endif

#if defined(dyhburstcmddeltest1)
#include "DyHburstCmdDelTest1.c"
#endif

#if defined(rel1hbursttest)
#include "Rel1HburstTest.c"
#endif

#if defined(syncflashcmddeltest)
#include "SyncFlashCmdDelTest.c"
#endif

#if defined(arb2hmastlocktest)
#include "Arb2HMastLockTest.c"
#endif

#if defined(directdydtftchtest)
#include "DirectDyDtFtchTest.c"
#endif

#if defined(wrmissonerrtest)
#include "WrMissOnErrTest.c"
#endif

#if defined(refreshmisstest)
#include "RefreshMissTest.c"
#endif

#if defined(multiportwrprottest)
#include "MultiPortWrProtTest.c"
#endif

#if defined(multiportpgaccesstest)
#include "MultiPortPgAccessTest.c"
#endif

#if defined(multiportpgaccesstest1)
#include "MultiPortPgAccessTest1.c"
#endif

#if defined(multiportpgaccesstest2)
#include "MultiPortPgAccessTest2.c"
#endif

#if defined(multiportpgaccesstest3)
#include "MultiPortPgAccessTest3.c"
#endif

#if defined(multiportpgaccesstest4)
#include "MultiPortPgAccessTest4.c"
#endif

#if defined(multiportpgaccesstest5)
#include "MultiPortPgAccessTest5.c"
#endif

#if defined(multiportdiffcomb1)
#include "MultiPortDiffComb1.c"
#endif

#if defined(multiportdiffcomb2)
#include "MultiPortDiffComb2.c"
#endif

#if defined(multiportrandomtest2)
#include "MultiPortRandomTest2.c"
#endif

#if defined(membgnttest)
#include "MemBGntTest.c"
#endif

#if defined(latencytest1)
#include "LatencyTest1.c"
#endif

#if defined(latencytest10)
#include "LatencyTest10.c"
#endif

#if defined(latencytest2)
#include "LatencyTest2.c"
#endif

#if defined(latencytest3_1)
#include "LatencyTest3_1.c"
#endif

#if defined(latencytest3_2)
#include "LatencyTest3_2.c"
#endif

#if defined(latencytest4_1)
#include "LatencyTest4_1.c"
#endif

#if defined(latencytest4_2)
#include "LatencyTest4_2.c"
#endif

#if defined(latencytest5_1)
#include "LatencyTest5_1.c"
#endif

#if defined(latencytest5_2)
#include "LatencyTest5_2.c"
#endif

#if defined(latencytest6_1)
#include "LatencyTest6_1.c"
#endif

#if defined(latencytest6_2)
#include "LatencyTest6_2.c"
#endif

#if defined(latencytest7)
#include "LatencyTest7.c"
#endif

#if defined(latencytest8)
#include "LatencyTest8.c"
#endif

#if defined(latencytest9)
#include "LatencyTest9.c"
#endif

#if defined(multiportdiffcomb3)
#include "MultiPortDiffComb3.c"
#endif

#if defined(multiportdiffcomb4)
#include "MultiPortDiffComb4.c"
#endif

#if defined(multiportdiffcomb5)
#include "MultiPortDiffComb5.c"
#endif

#if defined(multiportdiffcomb6)
#include "MultiPortDiffComb6.c"
#endif

#if defined(multiportdiffcomb7)
#include "MultiPortDiffComb7.c"
#endif

#if defined(multiportdiffcomb8)
#include "MultiPortDiffComb8.c"
#endif

#if defined(ahblockidleinserttest1)
#include "AHBLockIdleInsertTest1.c"
#endif

#if defined(ahblockidleinserttest2)
#include "AHBLockIdleInsertTest2.c"
#endif

#if defined(coherencydifbnkrowtest)
#include "CoherencyDifBnkRowTest.c"
#endif

#if defined(coherencydifbnksamerowtest)
#include "CoherencyDifBnkSameRowTest.c"
#endif

#if defined(coherencydifbnktest)
#include "CoherencyDifBnkTest.c"
#endif

#if defined(coherencysmebnkdifrowtest1)
#include "CoherencySmeBnkDifRowTest1.c"
#endif

#if defined(coherencysmebnkdifrowtest2)
#include "CoherencySmeBnkDifRowTest2.c"
#endif

#if defined(coherencysmebnktest)
#include "CoherencySmeBnkTest.c"
#endif

#if defined(coherencytest)
#include "CoherencyTest.c"
#endif

/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/
int main()
{ 

  C("------------------------------------------------------------------ ---",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2001-2002 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("------------------------------------------------------------------ ---",header);

  TestStart(0x00000000);

  RES(LOW, , 2);

  WaitLoop(5);

/******************************************************************************/
/*** The reset value of the registers are tested here.                      ***/
/******************************************************************************/
#if defined(poresettest)
  C("=========");
  C("POR TESTS");
  C("=========");
  POResetTest();
#endif

#if defined(hresettest)
  C("============");
  C("HRESET TESTS");
  C("============");
  HResetTest();
#endif

#if defined(mpmcregistertests)
/******************************************************************************/
/*** Different values are written and read from the registers to verify     ***/
/*** that the register under test is a read-only/read-write/write-only      ***/
/******************************************************************************/
 /* Disable the trickbox to avoid spurious warnings during register test */

  C("===================");
  C("MPMC REGISTER TESTS");
  C("===================");
  MpmcRegisterTests();
#endif

#if defined(mpmcenabletest)
/******************************************************************************/
/*** This test verifies the functionality of MPMCEnable bit                 ***/
/******************************************************************************/
  C("================");
  C("MPMC ENABLE TEST");
  C("================");
  MPMCEnableTest();
#endif

#if defined(controllerbusytest)
/******************************************************************************/
/*** This test verifies whether the busy bit is set or not when controller  ***/
/*** is in busy state                                                       ***/
/******************************************************************************/
  C("====================");
  C("CONTROLLER BUSY TEST");
  C("====================");
  ControllerBusyTest();
#endif

#if defined(lowpwrmodetest)
/******************************************************************************/
/*** It verifes the functionality of controller when it undergoes low power ***/
/*** mode                                                                   ***/
/******************************************************************************/
  C("===================");
  C("LOW POWER MODE TEST");
  C("===================");
  LowPwrModeTest();
#endif

#if defined(addrtoggletest)
/******************************************************************************/
/*** Toggle all memory related addresses and verify that proper locations   ***/
/*** are addressed or not                                                   ***/
/******************************************************************************/
  C("===================");
  C("ADDRESS TOGGLE TEST");
  C("===================");
  AddrToggleTest();
#endif

#if defined(addrmirrtest)
/******************************************************************************/
/*** Checks the Address Mirror bit of MPMCControl register                  ***/
/******************************************************************************/
  C("===================");
  C("ADDRESS MIRROR TEST ");
  C("===================");
  AddrMirrTest();
#endif

#if defined(cspolaritytest)
/******************************************************************************/
/*** This test verifies the polarity of ChipSelect when CS bit is toggled   ***/
/******************************************************************************/
  C("================");
  C("CS POLARITY TEST");
  C("================");
  CSPolarityTest();
#endif

#if defined(sdraminitrtnchk)
/******************************************************************************/
/*** This test verifies whether proper initialization sequence for sync     ***/
/*** memories are followed or not                                           ***/
/******************************************************************************/
  C("==============================");
  C("SDRAM INITIALISATION RTN CHECK");
  C("==============================");
  SdramInitRtnChk();
#endif

#if defined(clkctrltest)
/******************************************************************************/
/*** This test tests the clock controllability feature                      ***/
/******************************************************************************/
  C("================");
  C("CLK CONTROL TEST");
  C("================");
  ClkCtrlTest();
#endif

#if defined(clkenabletest)
/******************************************************************************/
/*** This test tests the clock enable feature                               ***/
/******************************************************************************/
  C("===============");
  C("CLK ENABLE TEST");
  C("===============");
  ClkEnableTest();
#endif

#if defined(romtest)
/******************************************************************************/
/*** Verifies functionality of controller with ROM as memory                ***/
/******************************************************************************/
  C("========");
  C("ROM TEST");
  C("========");
  ROMTest();
#endif

#if defined(delayvaluetests)
/******************************************************************************/
/*** Verifies delay value registers                                         ***/
/******************************************************************************/
  C("=================");
  C("DELAY VALUE TESTS ");
  C("=================");
  DelayValueTests();
#endif;

#if defined(stwtpgtest)
/******************************************************************************/
/*** Verifies page mode access of Page mode ROM                             ***/
/******************************************************************************/
  C("==============");
  C("WAIT PAGE TEST");
  C("==============");
  StWtPgTest();
#endif

#if defined(stwtpgbufentest)
/******************************************************************************/
/***  Verifies page mode access of burst ROM with buffers enabled           ***/
/******************************************************************************/
  C("==========================");
  C("WAIT PAGE BUF ENABLED TEST");
  C("==========================");
  StWtPgBufEnTest();
#endif

#if defined(blsdelayvaluetests)
/******************************************************************************/
/*** Verifies byte lane select                                              ***/
/******************************************************************************/
  C("====================");
  C("BLS DELAY VALUE TEST");
  C("====================");
  BLSDelayValueTests();
#endif

#if defined(exdwaitdeltest)
/******************************************************************************/
/*** Verifies extended wait register functionality                          ***/
/******************************************************************************/
  C("===================");
  C("EXD WAIT DELAY TEST");
  C("===================");
  ExdWaitDelTest();
#endif

#if defined(endiannesstests)
/******************************************************************************/
/*** Verifies endianisation logic                                           ***/
/******************************************************************************/
  C("===================");
  C("ENDIANISATION TESTS");
  C("===================");
  EndiannessTests();
#endif

#if defined(bigendianpintest)
/******************************************************************************/
/*** Verifies endianisation logic with bigendian pin                        ***/
/******************************************************************************/
  C("==================");
  C("BIG ENDIANPIN TEST");
  C("==================");
  BigEndianPinTest();
#endif

#if defined(busyinsertiontest)
/******************************************************************************/
/*** MPMC is tested when a bus degrant occurs during a busy transfer in a   ***/
/*** burst transfer                                                         ***/
/******************************************************************************/
  C("===================");
  C("BUSY INSERTION TEST");
  C("===================");
  BusyInsertionTest(0);
#endif

#if defined(busdegranttest)
/******************************************************************************/
/*** MPMC is tested when a bus degrant occurs during a busy transfer in a   ***/
/*** burst transfer                                                         ***/
/******************************************************************************/
  C("=================");
  C("BUS DEGRANT TEST");
  C("=================");
  BusDegrantTest(1);
#endif

#if defined(lowpwrsdramfuntest)
/******************************************************************************/
/*** This test verifies whether proper initialization sequence and          ***/
/*** functionality of LPSDRAM                                               ***/
/******************************************************************************/
  C("==============================");
  C("LOW PWR SDRAM FUNCTIONAL CHECK");
  C("==============================");
  LowPwrSdramFunTest();
#endif

#if defined(reffreqchk)
/******************************************************************************/
/*** It verifies that the refreshes are seperated by approximately the same ***/
/*** number of clocks as the value that is written into the refresh         ***/
/*** register of the controller                                             ***/
/******************************************************************************/
  C("============================");
  C("REFRESH FREQUENCY CHECK TEST");
  C("============================");
  RefFreqChk();
#endif

#if defined(selfrefchk)
/******************************************************************************/
/*** Tests whether acknowledge is given for SRefreshReq. When self refresh  ***/
/*** is applied externally it checks acknowledge is given or not            ***/
/******************************************************************************/
  C("==================");
  C("SELF REFRESH CHECK");
  C("==================");
  SelfRefChk();
#endif

#if defined(selrefprioritytest)
/******************************************************************************/
/*** This test verifies  that when REFRESH and SREFREQ are applied same     ***/
/*** time then REFRESH is applied first and then SREFREQ applied            ***/
/******************************************************************************/
  C("======================");
  C("SELF REF PRIORITY TEST");
  C("======================");
  SelRefPriorityTest();
#endif

#if defined(wrprottest)
/******************************************************************************/
/*** This test verifies the WP field of MPMCWrProtect register              ***/
/******************************************************************************/
  C("==================");
  C("WRITE PROTECT TEST");
  C("==================");
  WrProtTest();
#endif

#if defined(rdrefalntest)
/******************************************************************************/
/*** This test verifies that refresh has highest priority over memory       ***/
/*** access when they are applied simultaneously                            ***/
/******************************************************************************/
  C("===========================");
  C("READ REFRESH ALIGNMENT TEST");
  C("===========================");
  RdRefAlnTest();
#endif

#if defined(syncflashtest)
/******************************************************************************/
/*** Write data with little endian and read it back with big endian         ***/
/******************************************************************************/
  C("===============");
  C("SYNC FLASH TEST");
  C("===============");
  SyncFlashTest();
#endif

#if defined(hbursttest)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/******************************************************************************/
  C("===========");
  C("HBURST TEST"); 
  C("===========");
  HburstTest();
#endif

#if defined(dyhbursttest1)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** for dynamic memory                                                     ***/
/******************************************************************************/
  C("==============");
  C("DYHBURST TEST1");
  C("==============");
  DyHburstTest1();
#endif

#if defined(dyhbursttest2)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** for dynamic memory                                                     ***/
/******************************************************************************/
  C("==============");
  C("DYHBURST TEST2");
  C("==============");
  DyHburstTest2();
#endif

#if defined(dyhbursttesttb5)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** to tbench5                                                             ***/
/******************************************************************************/
  C("=================");
  C("DYHBURST TEST TB5");
  C("=================");
  DyHburstTestTB5();
#endif

#if defined(dyhbursttesttb7)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** to tbench7                                                             ***/
/******************************************************************************/
  C("=================");
  C("DYHBURST TEST TB7");
  C("=================");
  DyHburstTestTB7();
#endif

#if defined(dyhbursttesttb8)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** to tbench8                                                             ***/
/******************************************************************************/
  C("=================");
  C("DYHBURST TEST TB8");
  C("=================");
  DyHburstTestTB8();
#endif

#if defined(dyhbursttesttb9)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** to tbench9                                                             ***/
/******************************************************************************/
  C("=================");
  C("DYHBURST TEST TB9");
  C("=================");
  DyHburstTestTB9();
#endif

#if defined(dyhbursttesttb10)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** to tbench10                                                            ***/
/******************************************************************************/
  C("==================");
  C("DYHBURST TEST TB10");
  C("==================");
  DyHburstTestTB10();
#endif

#if defined(dyhburstclkrattb7test)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** to tbench7 with clock ratio as 1:2                                     ***/
/******************************************************************************/
  C("===========================");
  C("DYHBURST TEST CLK RATIO TB7");
  C("===========================");
  DyHburstClkRatTB7Test();
#endif

#if defined(dyhburstclkrattb8test)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** to tbench8 with clock ratio as 1:2                                     ***/
/******************************************************************************/
  C("===========================");
  C("DYHBURST TEST CLK RATIO TB8");
  C("===========================");
  DyHburstClkRatTB8Test();
#endif

#if defined(dyhburstclkrattb9test)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** to tbench9 with clock ratio as 1:2                                     ***/
/******************************************************************************/
  C("===========================");
  C("DYHBURST TEST CLK RATIO TB9");
  C("===========================");
  DyHburstClkRatTB9Test();
#endif

#if defined(randhbursttest)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/******************************************************************************/
  C("===================");
  C("RANDOM HBURST TEST");
  C("===================");
  RandHburstTest();
#endif

#if defined(bigendhbursttest)
/******************************************************************************/
/*** Memory accesses are done with BigEndian                                ***/
/******************************************************************************/
  C("================");
  C("BIGENDHBURSTTEST");
  C("================");
  BigEndHburstTest();
#endif

#if defined(randhbursttest1)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/*** randomly                                                               ***/
/******************************************************************************/
  C("===================");
  C("RANDOM HBURST TEST1");
  C("===================");
  RandHburstTest1();
#endif

#if defined(randhbursttest2)
/******************************************************************************/
/*** Memory accesses are done with different types of BURST operation       ***/
/******************************************************************************/
  C("===================");
  C("RANDOM HBURST TEST2");
  C("===================");
  RandHburstTest2();
#endif

#if defined(transfertest)
/******************************************************************************/
/*** Different types of HTRANS are applied at quad word boundary and        ***/
/*** verify the functionality                                               ***/
/******************************************************************************/
  C("=============");
  C("TRANSFER TEST");
  C("=============");
  TransferTest();
#endif

#if defined(idleport)
/******************************************************************************/
/*** Idle port                                                              ***/
/******************************************************************************/
  C("========");
  C("IdlePort ");
  C("========");
  IdlePort();
#endif;

#if defined(idleport1)
/******************************************************************************/
/*** Idle port1                                                             ***/
/******************************************************************************/
  C("=========");
  C("IdlePort1 ");
  C("=========");
  IdlePort1();
#endif;

#if defined(cornercases1)
/******************************************************************************/
/*** Static accesses are done with zero wait states                         ***/
/******************************************************************************/
  C("============");
  C("CornerCases1");
  C("============");
  CornerCases1();
#endif;

#if defined(cornercases2)
/******************************************************************************/
/*** 512Mb dynamic memory accesses                                          ***/
/******************************************************************************/
  C("============");
  C("CornerCases2");
  C("============");
  CornerCases2();
#endif;

#if defined(cornercases3)
/******************************************************************************/
/*** Dynamic memory accesses with BUSY transfers                            ***/
/******************************************************************************/
  C("============");
  C("CornerCases3");
  C("============");
  CornerCases3();
#endif;

#if defined(cornercases4)
/******************************************************************************/
/*** Dynamic access to the unity cas latency device                         ***/
/******************************************************************************/
  C("============");
  C("CornerCases4");
  C("============");
  CornerCases4();
#endif;

#if defined(cornercases5)
/******************************************************************************/
/*** Test to perform sync flash access with ClockEnable low                 ***/
/******************************************************************************/
  C("============");
  C("CornerCases5");
  C("============");
  CornerCases5();
#endif;

#if defined(cornercases6)
/******************************************************************************/
/*** Test to perform sync flash access with ClockEnable low                 ***/
/******************************************************************************/
  C("============");
  C("CornerCases6");
  C("============");
  CornerCases6();
#endif;

#if defined(cornercases7)
/******************************************************************************/
/*** Test to perform sync flash access with ClockEnable low                 ***/
/******************************************************************************/
  C("============");
  C("CornerCases7");
  C("============");
  CornerCases7();
#endif;

#if defined(cornercases8)
/******************************************************************************/
/*** Test to perform sync flash access with ClockEnable low                 ***/
/******************************************************************************/
  C("============");
  C("CornerCases8");
  C("============");
  CornerCases8();
#endif;

#if defined(arb2dywrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing dynamic memory from two       ***/
/*** ports                                                                  ***/
/******************************************************************************/
  C("==========");
  C("Arb2DyWrRd");
  C("==========");
  Arb2DyWrRd();
#endif;

#if defined(randomtest1)
/******************************************************************************/
/*** Random Test                                                            ***/
/******************************************************************************/
  C("===========");
  C("RandomTest1");
  C("===========");
  RandomTest1();
#endif;

#if defined(memmodelhbursttest)
/******************************************************************************/
/*** Memory accesses for denali memory models                               ***/
/******************************************************************************/
  C("==================");
  C("MemModelHburstTest");
  C("==================");
  MemModelHburstTest();
#endif;

#if defined(arb2cornercase4)
/******************************************************************************/
/*** Two Port accesses of sync flash and static memory                      ***/
/******************************************************************************/
  C("===============");
  C("Arb2CornerCase4");
  C("===============");
  Arb2CornerCase4();
#endif;

#if defined(arb2dystwrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing both dynamic and static       ***/
/**  memory from two ports                                                  ***/
/******************************************************************************/
  C("============");
  C("Arb2DyStWrRd");
  C("============");
  Arb2DyStWrRd();
#endif;

#if defined(arb3dystwrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing both dynamic and static       ***/
/**  memory from three ports                                                ***/
/******************************************************************************/
  C("============");
  C("Arb3DyStWrRd");
  C("============");
  Arb3DyStWrRd();
#endif;

#if defined(arb2stwrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing static memory from two ports  ***/
/******************************************************************************/
  C("==========");
  C("Arb2StWrRd");
  C("==========");
  Arb2StWrRd();
#endif;

#if defined(arb3dywrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing dy memory from three ports    ***/
/******************************************************************************/
  C("==========");
  C("Arb3DyWrRd");
  C("==========");
  Arb3DyWrRd();
#endif;

#if defined(arb3stwrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing static memory from three      ***/
/*** ports                                                                  ***/
/******************************************************************************/
  C("==========");
  C("Arb3StWrRd");
  C("==========");
  Arb3StWrRd();
#endif;

#if defined(arb4dystwrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing both dynamic and static       ***/
/**  memory from four ports                                                 ***/
/******************************************************************************/
  C("============");
  C("Arb4DyStWrRd");
  C("============");
  Arb4DyStWrRd();
#endif;

#if defined(arb4dywrrdclkrat)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing dynamic memory from four ***/
/***  ports with clock ratio as 1:2                                         ***/
/******************************************************************************/
  C("================");
  C("Arb4DyWrRdClkRat");
  C("================");
  Arb4DyWrRdClkRat();
#endif;

#if defined(arb4dywrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing dynamic memory from four      ***/
/***  ports                                                                 ***/
/******************************************************************************/
  C("==========");
  C("Arb4DyWrRd");
  C("==========");
  Arb4DyWrRd();
#endif;

#if defined(arb4idlebusy)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing both dynamic and static       ***/
/*** memory from four ports with IDLE and BUSY are inserted randomly        ***/
/*** during memory accesses                                                 ***/
/******************************************************************************/
  C("============");
  C("Arb4IdleBusy");
  C("============");
  Arb4IdleBusy();
#endif;

#if defined(arb4stwrrd)
/******************************************************************************/
/*** Vectors to test the arbiter by accessing static memory from four       ***/
/*** ports                                                                  ***/
/******************************************************************************/
  C("==========");
  C("Arb4StWrRd");
  C("==========");
  Arb4StWrRd();
#endif;

#if defined(memmodelstpgmodetest)
/******************************************************************************/
/*** Verifies the controller for SRAM page mode memory accesses             ***/
/******************************************************************************/
  C("====================");
  C("MemModelStPgModeTest");
  C("====================");
  MemModelStPgModeTest();
#endif;

#if defined(memmodelpgromtest)
/******************************************************************************/
/***  Verifies the controller for page mode flash memory accesses           ***/
/******************************************************************************/
  C("=================");
  C("MemModelPgROMTest");
  C("=================");
  MemModelPgROMTest();
#endif;

#if defined(memmodelromtest)
/******************************************************************************/
/*** Verifies the controller for ROM accesses with denali memory model      ***/
/******************************************************************************/
  C("===============");
  C("MemModelROMTest");
  C("===============");
  MemModelROMTest();
#endif;

#if defined(integrationtest)
/******************************************************************************/
/*** Integration test to be run on bustest world                            ***/
/******************************************************************************/
  C("===============");
  C("IntegrationTest");
  C("===============");
  IntegrationTest();
#endif;

#if defined(dyhburstcmddeltest1)
/******************************************************************************/
/*** Hburst test with command delayed mode                                  ***/
/******************************************************************************/
  C("===================");
  C("DyHburstCmdDelTest1");
  C("===================");
  DyHburstCmdDelTest1();
#endif;

#if defined(rel1hbursttest)
/******************************************************************************/
/*** Hburst test with address connection similar to Rel1                    ***/
/******************************************************************************/
  C("==============");
  C("Rel1HburstTest");
  C("==============");
  Rel1HburstTest();
#endif;

#if defined(syncflashcmddeltest)
/******************************************************************************/
/*** Sync flash test with command delayed mode                              ***/
/******************************************************************************/
  C("===================");
  C("SyncFlashCmdDelTest");
  C("===================");
  SyncFlashCmdDelTest();
#endif;

#if defined(arb2hmastlocktest)
/******************************************************************************/
/*** This test does the access from port3 with master locked and another    ***/
/*** port tries to access the controller                                    ***/
/******************************************************************************/
  C("=================");
  C("Arb2HMastLockTest");
  C("=================");
  Arb2HMastLockTest();
#endif;

#if defined(wrmissonerrtest)
/******************************************************************************/
/*** This test does the access from port3 with master locked and another    ***/
/*** port tries to access the controller                                    ***/
/******************************************************************************/
  C("=================");
  C("WrMissOnErrTest");
  C("=================");
  WrMissOnErrTest();
#endif;

#if defined(refreshmisstest)
  C("=================");
  C("RefreshMissTest");
  C("=================");
  RefreshMissTest();
#endif;

#if defined(directdydtftchtest)
  C("==================");
  C("DirectDyDtFtchTest");
  C("==================");
  DirectDyDtFtchTest();
#endif;

#if defined(multiportwrprottest)
/******************************************************************************/
/*** Checks write protect feature with multiport access.                    ***/
/******************************************************************************/
  C("==================");
  C("MultiPortWrProtTest");
  C("==================");
  MultiPortWrProtTest();
#endif;

#if defined(multiportpgaccesstest)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("=====================");
  C("MultiPortPgAccessTest");
  C("=====================");
  MultiPortPgAccessTest();
#endif;

#if defined(multiportpgaccesstest1)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("======================");
  C("MultiPortPgAccessTest1");
  C("======================");
  MultiPortPgAccessTest1();
#endif;

#if defined(multiportpgaccesstest2)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("======================");
  C("MultiPortPgAccessTest2");
  C("======================");
  MultiPortPgAccessTest2();
#endif;

#if defined(multiportpgaccesstest3)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("======================");
  C("MultiPortPgAccessTest3");
  C("======================");
  MultiPortPgAccessTest3();
#endif;

#if defined(multiportpgaccesstest4)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("======================");
  C("MultiPortPgAccessTest4");
  C("======================");
  MultiPortPgAccessTest4();
#endif;

#if defined(multiportpgaccesstest5)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("======================");
  C("MultiPortPgAccessTest5");
  C("======================");
  MultiPortPgAccessTest5();
#endif;

#if defined(multiportdiffcomb1)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("==================");
  C("MultiPortDiffComb1");
  C("==================");
  MultiPortDiffComb1();
#endif;

#if defined(multiportdiffcomb2)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("==================");
  C("MultiPortDiffComb2");
  C("==================");
  MultiPortDiffComb2();
#endif;

#if defined(multiportrandomtest2)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("==================");
  C("MultiPortRandomTest2");
  C("==================");
  MultiPortRandomTest2();
#endif;

#if defined(membgnttest)
/******************************************************************************/
/*** Checks the latency of AHB0 by performing different set of              ***/
/*** operation                                                              ***/
/******************************************************************************/
  C("==================");
  C("MemBGntTest");
  C("==================");
  MemBGntTest();
#endif;

#if defined(latencytest1)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("============");
  C("LatencyTest1");
  C("============");
  LatencyTest1();
#endif;

#if defined(latencytest2)
/******************************************************************************/
/*** Checks the latency of AHB1                                             ***/
/******************************************************************************/
  C("============");
  C("LatencyTest2");
  C("============");
  LatencyTest2();
#endif;

#if defined(latencytest3_1)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==============");
  C("LatencyTest3_1");
  C("==============");
  LatencyTest3_1();
#endif;

#if defined(latencytest3_2)
/******************************************************************************/
/*** Checks the latency of AHB0 and AHB1                                    ***/
/******************************************************************************/
  C("==============");
  C("LatencyTest3_2");
  C("==============");
  LatencyTest3_2();
#endif;

#if defined(latencytest4_1)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==============");
  C("LatencyTest4_1");
  C("==============");
  LatencyTest4_1();
#endif;

#if defined(latencytest4_2)
/******************************************************************************/
/*** Checks the latency of AHB0 and AHB1                                    ***/
/******************************************************************************/
  C("==============");
  C("LatencyTest4_2");
  C("==============");
  LatencyTest4_2();
#endif;

#if defined(latencytest5_1)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==============");
  C("LatencyTest5_1");
  C("==============");
  LatencyTest5_1();
#endif;

#if defined(latencytest5_2)
/******************************************************************************/
/*** Checks the latency of AHB0 and AHB1                                    ***/
/******************************************************************************/
  C("==============");
  C("LatencyTest5_2");
  C("==============");
  LatencyTest5_2();
#endif

#if defined(latencytest6_1)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==============");
  C("LatencyTest6_1");
  C("==============");
  LatencyTest6_1();
#endif;

#if defined(latencytest6_2)
/******************************************************************************/
/*** Checks the latency of AHB0 and AHB1                                    ***/
/******************************************************************************/
  C("==============");
  C("LatencyTest6_2");
  C("==============");
  LatencyTest6_2();
#endif;

#if defined(latencytest7)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("============");
  C("LatencyTest7");
  C("============");
  LatencyTest7();
#endif;

#if defined(latencytest8)
/******************************************************************************/
/*** Checks the latency of AHB1                                             ***/
/******************************************************************************/
  C("============");
  C("LatencyTest8");
  C("============");
  LatencyTest8();
#endif;

#if defined(latencytest9)
/******************************************************************************/
/*** Checks the latency of AHB0 and AHB1                                    ***/
/******************************************************************************/
  C("============");
  C("LatencyTest9");
  C("============");
  LatencyTest9();
#endif;

#if defined(latencytest10)
/******************************************************************************/
/*** Checks the latency of AHB0 and AHB1                                    ***/
/******************************************************************************/
  C("=============");
  C("LatencyTest10");
  C("=============");
  LatencyTest10();
#endif;

#if defined(multiportdiffcomb3)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==================");
  C("MultiPortDiffComb3");
  C("==================");
  MultiPortDiffComb3();
#endif;

#if defined(multiportdiffcomb4)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==================");
  C("MultiPortDiffComb4");
  C("==================");
  MultiPortDiffComb4();
#endif;

#if defined(multiportdiffcomb5)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==================");
  C("MultiPortDiffComb5");
  C("==================");
  MultiPortDiffComb5();
#endif;

#if defined(multiportdiffcomb6)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==================");
  C("MultiPortDiffComb6");
  C("==================");
  MultiPortDiffComb6();
#endif;

#if defined(multiportdiffcomb7)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==================");
  C("MultiPortDiffComb7");
  C("==================");
  MultiPortDiffComb7();
#endif;

#if defined(multiportdiffcomb8)
/******************************************************************************/
/*** Checks the latency of AHB0                                             ***/
/******************************************************************************/
  C("==================");
  C("MultiPortDiffComb8");
  C("==================");
  MultiPortDiffComb8();
#endif;

#if defined(ahblockidleinserttest1)
/******************************************************************************/
/*** Checks the lock transfers                                              ***/
/******************************************************************************/
  C("==================");
  C("AHBLockIdleInsertTest1");
  C("==================");
  AHBLockIdleInsertTest1();
#endif;

#if defined(ahblockidleinserttest2)
/******************************************************************************/
/*** Checks the lock transfers                                              ***/
/******************************************************************************/
  C("==================");
  C("AHBLockIdleInsertTest2");
  C("==================");
  AHBLockIdleInsertTest2();
#endif;

#if defined(coherencydifbnkrowtest)
/******************************************************************************/
/*** Checks the coherency issue of MPMC                                     ***/
/******************************************************************************/
  C("======================");
  C("CoherencyDifBnkRowTest");
  C("======================");
  CoherencyDifBnkRowTest();
#endif;

#if defined(coherencydifbnksamerowtest)
/******************************************************************************/
/*** Checks the coherency issue of MPMC                                     ***/
/******************************************************************************/
  C("==========================");
  C("CoherencyDifBnkSameRowTest");
  C("==========================");
  CoherencyDifBnkSameRowTest();
#endif;

#if defined(coherencydifbnktest)
/******************************************************************************/
/*** Checks the coherency issue of MPMC                                     ***/
/******************************************************************************/
  C("===================");
  C("CoherencyDifBnkTest");
  C("===================");
  CoherencyDifBnkTest();
#endif;

#if defined(coherencysmebnkdifrowtest1)
/******************************************************************************/
/*** Checks the coherency issue of MPMC                                     ***/
/******************************************************************************/
  C("==========================");
  C("CoherencySmeBnkDifRowTest1");
  C("==========================");
  CoherencySmeBnkDifRowTest1();
#endif;

#if defined(coherencysmebnkdifrowtest2)
/******************************************************************************/
/*** Checks the coherency issue of MPMC                                     ***/
/******************************************************************************/
  C("==========================");
  C("CoherencySmeBnkDifRowTest2");
  C("==========================");
  CoherencySmeBnkDifRowTest2();
#endif;

#if defined(coherencysmebnktest)
/******************************************************************************/
/*** Checks the coherency issue of MPMC                                     ***/
/******************************************************************************/
  C("===================");
  C("CoherencySmeBnkTest");
  C("===================");
  CoherencySmeBnkTest();
#endif;

#if defined(coherencytest)
/******************************************************************************/
/*** Checks the coherency issue of MPMC                                     ***/
/******************************************************************************/
  C("===================");
  C("CoherencyTest");
  C("===================");
  CoherencyTest();
#endif;

if (INFILE == 3)
 TestEnd();
  return 0;
}
/********************************* End of MAIN ********************************/
