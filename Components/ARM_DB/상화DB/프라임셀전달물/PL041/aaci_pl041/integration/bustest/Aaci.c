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
-- File Name              : Aaci.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL041-REL1v0
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--           BusTalk vectors are converted to TICTalk and applied to 
--           the AMBA ASB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Aaci.h, Aaci.c, IntegrationTest.c, AddrRangeTest.c
--
--   Usage: make all 
--          make IntegrationTest
--          make AddrRangeTest
--          make RegisterTest
--
--   This will create infile.tif and tif.sim in the ./invec directory
--
-- --=================================================================*/

/**********************************************************************/
/*** For more information on the AACI,please refer to PL041 AMBA    ***/
/*** AACI Block Specification                                       ***/
/**********************************************************************/

/**********************************************************************/
/*** Include the files required for the selected test               ***/
/**********************************************************************/
#if defined(integrationtest)  ||  defined(ALL_TESTS)
#include "IntegrationTest.c"
#endif

#if defined(addrrangetest)  ||  defined(ALL_TESTS)
#include "AddrRangeTest.c"
#endif

#if defined(registertest) || defined(ALL_TESTS)
#include "RegisterTest.c"
#endif

/**********************************************************************/
/********************************  MAIN  ******************************/
/**********************************************************************/
int main()
{
 
  C("------------------------------------------------------------------ ---",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2000 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("------------------------------------------------------------------ ---",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Aaci.c.rca",header);
  C("File Revision          : 1.4",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL041-REL1v0",header);
  C("------------------------------------------------------------------ ---",header);
 
  TestStart();
  printf("-- -----------------------------------------------------------\n");
  printf("-- ** TESTS FOR AACI WITH THE AACIBITCLK PERIOD = %d ns \n",AACIBITCLK_PERIOD);
  printf("-- ** TESTS FOR AACI WITH THE PCLK PERIOD   = %d ns \n",PCLK_PERIOD);
  printf("-- ** Ensure the PCLK period in the tbench/timing.v  \n");
  printf("-- ** or timing.vhd file ..... Tclkl + Tclkh = %d ns \n",PCLK_PERIOD);
  printf("-- -----------------------------------------------------------\n");
 
  RES(LOW,0x1,0x2);
  PI(0x03);

  #if defined(registertest) || defined(ALL_TESTS)
  RegisterTest();
  #endif

  #if defined(addrrangetest) ||  defined(ALL_TESTS)
  AddrRangeTest();
  #endif

  #if defined(integrationtest) ||  defined(ALL_TESTS)
  IntegrationTest();
  #endif

  TestEnd();
  return 0;
}
 
/**********************************************************************/
/***************************** End of MAIN ****************************/
/**********************************************************************/

