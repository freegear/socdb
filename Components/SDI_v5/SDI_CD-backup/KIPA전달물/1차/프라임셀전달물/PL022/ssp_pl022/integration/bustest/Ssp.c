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
-- File Name              : Ssp.c.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL022-REL1v2
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Ssp.h, Ssp.c, Ssp_Integ.c
--
--   Usage: make <testname> e.g. make Ssp_Integ
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Ssp_Integ
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/
 
/**********************************************************************/
/*** For more information on the SSP, please refer to PL011 AMBA    ***/
/*** SSP Block Specification                                        ***/
/**********************************************************************/

/******************************************************************************/
/***************** System Clock Defines ***************************************/
/******************************************************************************/


#define SSPCLK_PERIOD     10 
#define PCLK_PERIOD       10

unsigned int wait_factor;

#if defined(INTEGRATION_TESTS) || defined(ALL_TESTS) 
#include "SspCommon.c"
#include "Ssp_Integ.c"
#endif


/**********************************************************************/
/********************************  MAIN  ******************************/
/**********************************************************************/

int main()
{

  int32 expr; 

  C("---------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2000-2001 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C(" and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("---------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Ssp.c.rca",header);
  C("File Revision          : 1.1",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL022-REL1v2",header);
  C("---------------------------------------------------------------------",header);
   TestStart();
 
   RES(LOW,0x1,0x2);
   PI(0x02);
   PI(10);
   
   
#if defined(INTEGRATION_TESTS) || defined(ALL_TESTS)   
   C("Integration Tests");
   ResetRead();
   IntegrationTest();
#endif
   
   C("Test End"); 

   TestEnd();
   return 0;

}


/************************************ End *************************************/

