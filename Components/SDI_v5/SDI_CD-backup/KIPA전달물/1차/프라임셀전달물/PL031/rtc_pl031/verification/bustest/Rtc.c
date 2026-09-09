/*------------------------------------------------------------------------------
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
-- Version and Release Control Information:
--
-- File Name              : Rtc.c.rca
-- File Revision          : 1.10
--
-- Release Information    : PrimeCell(TM)-PL031-REL1v0
--
------------------------------------------------------------------------------*/
 
/******************************************************************************/
/* Purpose : This file verifies Rtc functionality in the free-running mode.   */
/*           The tbench.vhd testbench needs to be used to run this            */
/*           vector set.                                                      */
/******************************************************************************/

/******************************************************************************/
/***   Purpose : This C code file is used to generate BusTalk vectors.      ***/
/***             BusTalk vectors are applied to the AMBA APB bus.           ***/
/***                                                                        ***/
/*** Files required for compilation:                                        ***/
/***   makefile, busheader.h, busmacros.h, busmacros.c,                     ***/
/***   config.h, addargs_script,                                            ***/
/***   Rtc.h, Rtc.c and:                                                    ***/
/***                                                                        ***/
/***     Rtc_RstTest.c                                                      ***/
/***     Rtc_InitReg.c                                                      ***/
/***     Rtc_RegTests.c                                                     ***/
/***     Rtc_IntTests.c                                                     ***/
/***     Rtc_CountTests.c                                                   ***/
/***     Rtc_ScanTest.c                                                     ***/
/***                                                                        ***/
/***   Usage: make <testname> e.g. make Rtc                                 ***/
/***                                                                        ***/
/*** To create .bif formatted vectors from the BusTalk code (default)       ***/
/***   make <testname> e.g. make Rtc                                        ***/
/*** This will create testname.bif in the ./invec directory                 ***/
/***                                                                        ***/
/******************************************************************************/
 
/******************************************************************************/
/*** For more information on the Rtc, please refer to the                   ***/
/*** ARM PrimeCell Real Time Clock PL030 Technical Reference Manual         ***/
/******************************************************************************/

/******************************************************************************/
/************************ Clock Defines ***************************************/
/******************************************************************************/
 
/* This value has to be changed to set the CLK1HZ high phase width in ns      */
#define CLK1HZ_H     0x000001F4

/* This value has to be changed to set the CLK1HZ low phase width in ns       */
#define CLK1HZ_L     0x000001F4

/* Constant value equal to a phase width of 500 ns, do not change             */
#define CLK1HZ_PHASE 0x000001F4

/* Explanatory note:
   -----------------
   CLK1HZ_H and CLK1HZ_L need modifying to set the phase and period
   of the RTC CLK1HZ, and normally (but not necessarily) the high and
   low phases will be the same value.

   CLK1HZ_PHASE is a constant set at 1E4 i.e. 500 ns,
   and it must not be changed.

   The constant CLK1HZ_PHASE is used for a special test which forces
   the condition when the Safe1Hz pulse occurs simultaneously with
   a write to the RTCLR register. The special test is only run when
   CLK1HZ_H and CLK1HZ_L have been set to the CLK1HZ_PHASE value 1E4.         */



/******************************************************************************/
/******************** Include all the Function files **************************/
/******************************************************************************/

#if defined(ALL_TESTS) || defined(RST_TESTS)
#	include "Rtc_RstTest.c"
#endif

#if defined(ALL_TESTS) || defined(INITREG_TESTS)
#	include "Rtc_InitReg.c"
#endif 

#if defined(ALL_TESTS) || defined(REG_TESTS)
#	include "Rtc_RegTests.c"
#endif

#if defined(ALL_TESTS) || defined(UPDATE_TESTS)
#	include "Rtc_UpdateTests.c"
#endif

#if defined(ALL_TESTS) || defined(INT_TESTS)
#	include "Rtc_IntTests.c"
#endif

#if defined(ALL_TESTS) || defined(COUNT_TESTS)
#	include "Rtc_CountTests.c"
#endif

/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

int main()

{
C("-----------------------------------------------------------------------------",header);
C("  This confidential and proprietary software may be used only",header);
C("  as authorised by a licensing agreement from ARM Limited",header);
C("    (C) COPYRIGHT 2001 ARM Limited",header);
C("        ALL RIGHTS RESERVED",header);
C("  The entire notice above must be reproduced on all authorised copies",header);
C("  and copies may only be made to the extent permitted by a",header);
C("  licensing agreement from ARM Limited.",header);
C("-----------------------------------------------------------------------------",header);
C(" ",header);
C("Version and Release Control Information:",header);
C(" ",header);
C("File Name              : Rtc.c.rca",header);
C("File Revision          : 1.10",header);
C(" ",header);
C("Release Information    : PrimeCell(TM)-PL031-REL1v0",header);
C("-----------------------------------------------------------------------------",header);
  

/* Start of Compliance test program                                           */

TestStart();

/* Reset the Rtc and TrickBox                                                 */
RES(LOW,0x1,0x1);
PI(0x02);

/* Writing the clock timings to the Trickbox                                  */
C("TRICKBOX INITIALISATIONS");
PSW(CLK1HZ_H, RTCLK1HZH);
PSW(CLK1HZ_L, RTCLK1HZL);
PSW(0x00000002,RTCR);

/* Delay start of tests for 2 CLK1HZ cycles - which is time taken for a CLK1HZ*/
/* reset                                                                      */
  PO(0x00000001, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000000, MaskClk, RTSR);
  PI(0x02);
  PO(0x00000001, MaskClk, RTSR);

#if defined(ALL_TESTS) || defined(RST_TESTS)
  C("RESET TESTS");
  RstTest();
#endif

#if defined(ALL_TESTS) || defined(INITREG_TESTS)
  C("REGISTER INITIALISATIONS");
  InitReg();
#endif   
     
#if defined(ALL_TESTS) || defined(REG_TESTS)
  C("REGISTER PATTERN TESTS");
  RegTests();
#endif

#if defined(ALL_TESTS) || defined(UPDATE_TESTS)
  C("UPDATE TESTS");
  UpdateTests();
#endif

#if defined(ALL_TESTS) || defined(INT_TESTS)
  C("INTERRUPT TESTS");
  IntTests();
#endif

#if defined(ALL_TESTS) || defined(COUNT_TESTS)
  C("COUNTER TESTS");
  CountTests();
#endif

C("Test End");

TestEnd();

return 0;

}

