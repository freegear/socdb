/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : $RCSfile : Gpio.c.rca $
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
------------------------------------------------------------------------------*/
                                                                   
/******************************************************************************/
/*** Files required for compilation:                                        ***/
/***   makefile, busheader.h, busmacros.h, busmacros.c,                     ***/
/***   config.h, addargs_script,                                            ***/
/***   Gpio_free.h, Gpio_free.c                                             ***/
/***                                                                        ***/
/*** Usage: make <testname> e.g. make Gpio_free                             ***/
/***                                                                        ***/
/*** To create .bif formatted vectors from the BusTalk code                 ***/
/***   make <testname> e.g. make Gpio_free                                  ***/
/*** This will create testname.bif in the ./invec directory                 ***/
/***                                                                        ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the Gpio, please refer to the                  ***/
/*** ARM PrimeCell General Purpose I/O PL061 Technical Reference Manual     ***/
/******************************************************************************/
 
/******************************************************************************/
/*** Include common BusTalk files                                           ***/
/******************************************************************************/
/* #include "busmacros.h" */
/* #include "busheader.h" */
/* #include "config.h"    */
/******************************************************************************/
/*** Include GPIO header file                                               ***/
/*** for register offset definitions and mask values                        ***/
/******************************************************************************/
#include "Gpio.h"

/******************************************************************************/
/************************* Function declarations ******************************/
/******************************************************************************/

void RstTest(void);
void TestGPIOReg(void);
void TestGPIODATARegMasking(void);
void IntTests(void);
void AltFunctTests(void);
void IntVectors(void);

#if defined (ALL_TESTS) || defined(IncRstTest)
#include "RstTest.c"
#endif

#if defined (ALL_TESTS) || defined(IncTestGPIOReg)
#include "TestGPIOReg.c"
#endif

#if defined (ALL_TESTS) || defined(IncTestGPIODATARegMasking )
#include "TestGPIODATARegMasking.c"
#endif

#if defined (ALL_TESTS) || defined(IncIntTests)
#include "IntTests.c"
#endif

#if defined (ALL_TESTS) || defined(IncAltFunctTests)
#include "AltFunctTests.c"
#endif

#if defined (ALL_TESTS) || defined(IncIntVectors)
#include "IntVectors.c"
#endif

/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

int main()
{
     /**********************************************************************/
  C("------------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2000 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("------------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : $RCSfile : Gpio.c.rca $",header);
  C("File Revision          : $Revision : 1.1 $",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL061-REL1v0",header);
  C("------------------------------------------------------------------------",header);

TestStart();

RES(LOW,0x01,0x01);
PI(0x02);

#if defined (ALL_TESTS) || defined(IncRstTest)
C("RESET VALUE TEST");
RstTest();
C("RESET VALUE TEST DONE!");
#endif

#if defined (ALL_TESTS) || defined(IncTestGPIOReg)
C("REGISTER ACCESS")
TestGPIOReg();
C("REGISTER ACCESS DONE!")
#endif

#if defined (ALL_TESTS) || defined(IncTestGPIODATARegMasking)
C("REGISTER ACCESS GPIODATA ADDRESS MASKING");
TestGPIODATARegMasking();
C("REGISTER ACCESS GPIODATA ADDRESS MASKING DONE!");
#endif

#if defined (ALL_TESTS) || defined(IncIntTests)
C("INTERRUPT CONTROL");
IntTests();
C("INTERRUPT CONTROL DONE!");
#endif

#if defined (ALL_TESTS) || defined(IncAltFunctTests)
C("ALTERNATE FUNCTIONALITY");
AltFunctTests();
C("ALTERNATE FUNCTIONALITY DONE!");
#endif

#if defined (ALL_TESTS) || defined(IncIntVectors)
C("INTEGRATION VECTORS FUNCTIONALITY");
IntVectors();
C("INTEGRATION VECTORS FUNCTIONALITY DONE!");
#endif

TestEnd();
return 0;
}
