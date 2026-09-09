
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
-- File Name              : Clcd.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
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
--     Clcd.h, Clcd.c, ClcdCommon.c, Check_Integration.c
--
--   Usage: make <testname> e.g. make all
--
--   To create .tif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make all
--   This will create infile.tif and tif.sim in the ./invec directory
--
-- --=========================================================================*/
 
/******************************************************************************/
/*** For more information on the CLCD, please refer to PL110 AMBA           ***/
/*** CLCD Block Specification                                               ***/
/******************************************************************************/

/******************************************************************************/
/*** Global Variables and common functions                                  ***/
/******************************************************************************/

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/
#if defined(INTEGRATION_TESTS) || defined(ALL_TESTS)
 #include "Check_Integration.c"
#endif


/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{

  TestStart(0);
 
  RES(LOW,0x1,0x2);


#if defined(INTEGRATION_TESTS) || defined(ALL_TESTS)
  C("=================");
  C("INTEGRATION TESTS");
  C("=================");
  
  IntegrationTests();
#endif



  TestEnd();
  return 0;

}

/********************************* End of MAIN ********************************/
