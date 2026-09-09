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
/***                                                                        ***/
/*** To create .bif formatted vectors from the BusTalk code                 ***/
/***   make <testname> e.g. make Gpio_Integ                                 ***/
/*** This will create testname.bif in the ./invec directory                 ***/
/***                                                                        ***/
/******************************************************************************/

/******************************************************************************/
/*** For more information on the Gpio, please refer to the                  ***/
/*** ARM PrimeCell General Purpose I/O PL061 Technical Reference Manual     ***/
/******************************************************************************/

/******************************************************************************/
/*** Include GPIO header file                                               ***/
/*** for register offset definitions and mask values                        ***/
/******************************************************************************/
#include "Gpio.h"

/******************************************************************************/
/************************* Function declarations ******************************/
/******************************************************************************/

void RstTest(void);
void Gpio_Integ(void);

#if defined(Integ)
#include "RstTest.c"
#include "Gpio_Integ.c"
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

#if defined(Integ)
C("RESET VALUE TEST");
RstTest();
C("RESET VALUE TEST DONE!");

C("INTEGRATION TEST");
Gpio_Integ();
C("INTEGRATION TEST DONE!");
#endif

TestEnd();
return 0;
}
