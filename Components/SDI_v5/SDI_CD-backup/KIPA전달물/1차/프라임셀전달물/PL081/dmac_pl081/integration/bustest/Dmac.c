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
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
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
--     Dmac.h, Dmac.c, DmacCommon.c, DmacIntegTests.c, DmacRegisterTests.c
--
--   Usage: make <testname> e.g. make all
--
--   To create .tif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make all
--   This will create infile.tif and tif.sim in the ./invec directory
--
-- --=========================================================================*/
 
/******************************************************************************/
/*** For more information on the DMAC, please refer to PL080 AMBA           ***/
/*** DMAC Block Specification                                               ***/
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

#if defined(intm2mtests) || defined(ALL_TESTS)
#include "DmacIntM2MTests.c"
#endif

#if defined(integrationtest) || defined(ALL_TESTS)
#include "DmacIntegTests.c"
#endif

/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{

  TestStart(0);
 
  RES(LOW,0x1,0x2);

  /** Issue a Control Vector to configure the TIC **/
  /** HSIZE = WORD                                **/
  /** HADDR = Incrementing                        **/
  /** HLOCK = Un-Locked                           **/
  /** HPROT = User mode                           **/
  TCV(DMACTR_BASE, WRD, 1, 0, 0x0);

#if defined(resettests) || defined(ALL_TESTS)
  C("==============");
  C("RESET TESTS");
  C("==============");
  ResetTests();
#endif

#if defined(registertests) || defined(ALL_TESTS)
  C("====================================");
  C("AHB I/O PORTS -> CONNECTIVITY TESTS");
  C("====================================");
  RegisterTests();

  WaitLoop(5);
#endif

#if defined(intm2mtests) || defined(ALL_TESTS)
  C("=======================");
  C("INTRA-CHIP AHB MASTER I/O PORTS -> CONNECTIVITY TESTS");
  C("MEMORY-MEMORY DMA TRANSFER TESTS");
  C("================================");

  DmacIntM2MTests();
  WaitLoop(5);
#endif

#if defined(integrationtest) || defined(ALL_TESTS)
  C("INTRA-CHIP I/O PORTS -> CONNECTIVITY TESTS");
  C("==========================================");
  DmacIntegTests();
#endif

  TestEnd();
  return 0;

}

/********************************* End of MAIN ********************************/
