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
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA AHB bus.
-- 
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c, config.h,
--     addargs_script, Header files and C source files for Clcd tests.
--
--   Usage: make <testname> e.g. make RegisterTests
--       OR make all        - to compile all tests
--
--       OR make            |   to compile selectively so as to avoid
--       OR make            |   loading problems during simulation
--
--   This will create infile.bif and bif.sim in the ./invec directory
--
-- --=========================================================================*/

/******************************************************************************/
/*** For more information on the Clcd, please refer to:                     ***/
/*** ARM PrimeCell Colour LCD Controller (PL110) Technical Reference Manual ***/
/******************************************************************************/

/******************************************************************************/
/*** Global Variables and common functions                                  ***/
/******************************************************************************/

void Display_mode(int32 control_Data);
void Check_IntrTest();
void Check_PwrSeq();
void Check_Retry();
void Check_FreqTest();
void Check_STNDualCLR();
void Check_STNDualM();
void Check_STNSingleCLR();
void Check_STNSingleM();
void Check_TFT();
void Check_TFT_1();
void Check_Flat();
void Check_Vertical();
void Check_Large();

int PixelsPerLine;
int LinesPerPanel;
int HSyncWidth;
int HBPvalue;
int HFPvalue;
int VSyncWidth;
int VBPvalue;
int VFPvalue;
int PCDvalue;
int cSELv;
int ACBvalue;
int IVSv;
int IHSv;
int IPCv;
int IEOv;
int BCDv;
int LEDvalue;
int LEEv;

/******************************************************************************/
/*** Include the files required for the selected test                       ***/
/******************************************************************************/
#if defined(CHECK_INTRTEST) || defined(ALL_TESTS)
#include "Check_IntrTest.c"
#endif

#if defined(CHECK_PWRSEQ) || defined(ALL_TESTS)
#include "Check_PwrSeq.c"
#endif
 
#if defined(CHECK_RETRY) || defined(ALL_TESTS)
#include "Check_Retry.c"
#endif

#if defined(CHECK_FREQTEST) || defined(ALL_TESTS)
#include "Check_FreqTest.c"
#endif

#if defined(CHECK_STNDUALCLR) || defined(ALL_TESTS)
#include "Check_STNDualCLR.c"
#endif

#if defined(CHECK_STNDUALM) || defined(ALL_TESTS)
#include "Check_STNDualM.c"
#endif

#if defined(CHECK_STNSINGLECLR) || defined(ALL_TESTS)
#include "Check_STNSingleCLR.c"
#endif

#if defined(CHECK_STNSINGLEM) || defined(ALL_TESTS)
#include "Check_STNSingleM.c" 
#endif

#if defined(CHECK_TFT) || defined(ALL_TESTS)
#include "Check_TFT.c"
#endif
 
#if defined(CHECK_TFT_1) || defined(ALL_TESTS)
#include "Check_TFT_1.c"
#endif
 
#if defined(CHECK_FLAT) || defined(ALL_TESTS)
#include "Check_Flat.c"
#endif
 
#if defined(CHECK_VERTICAL) || defined(ALL_TESTS)
#include "Check_Vertical.c"
#endif

#if defined(CHECK_LARGE) || defined(ALL_TESTS)
#include "Check_Large.c"
#endif
 
/******************************************************************************/
/************************************  MAIN  **********************************/
/******************************************************************************/

int main()
{ 

  C("------------------------------------------------------------------------- ---",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2002 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C("  and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("------------------------------------------------------------------------- ---",header);

  TestStart(ZERO);

  RES(LOW, , 2);

#if defined(CHECK_INTRTEST) || defined(ALL_TESTS)
  C("INTERRUPT TESTS");
  Check_IntrTest();
#endif

#if defined(CHECK_PWRSEQ) || defined(ALL_TESTS)
  C("CHECK POWER SEQUENCE TESTS");
  Check_PwrSeq();
#endif
 
#if defined(CHECK_RETRY) || defined(ALL_TESTS)
  C("CHECK RETRY TESTS");
  Check_Retry();
#endif

#if defined(CHECK_FREQTEST) || defined(ALL_TESTS)
  C("FREQUENCY TESTS");
  Check_FreqTest();
#endif

#if defined(CHECK_STNDUALCLR) || defined(ALL_TESTS)
  C("STN DUAL PANEL COLOUR TESTS");
  Check_STNDualCLR();
#endif

#if defined(CHECK_STNDUALM) || defined(ALL_TESTS)
  C("STN DUAL PANEL MONO TESTS");
  Check_STNDualM();
#endif

#if defined(CHECK_STNSINGLECLR) || defined(ALL_TESTS)
  C("CHECK STN SINGLE COLOUR DISPLAY TESTS");
  Check_STNSingleCLR ();
#endif

#if defined(CHECK_STNSINGLEM) || defined(ALL_TESTS)
  C("CHECK STN SINGLE MONO DISPLAY TESTS");
  Check_STNSingleM(); 
#endif

#if defined(CHECK_TFT) || defined(ALL_TESTS)
  C("CHECK TFT TESTS");
  Check_TFT();
#endif
 
#if defined(CHECK_TFT_1) || defined(ALL_TESTS)
  C("CHECK TFT_1 TESTS");
  Check_TFT_1();
#endif
 
#if defined(CHECK_FLAT) || defined(ALL_TESTS)
  C("CHECK FLAT PANEL TESTS");
  Check_Flat();
#endif
 
#if defined(CHECK_VERTICAL) || defined(ALL_TESTS)
  C("CHECK VERTICAL TESTS");
  Check_Vertical();
#endif

#if defined(CHECK_LARGE) || defined(ALL_TESTS)
  C("CHECK LARGE PANEL TESTS");
  Check_Large();
#endif
 
  TestEnd();
  return 0;
}

/*-------------------------------------------------------------------------
   This function displays the mode of the CLCD controller
  ------------------------------------------------------------------------*/
void Display_mode(int32 control_Data)
{
if((control_Data & 0x00000020)==0x00000020)
  {
  C("THIS IS TFT MODE ");
  switch(control_Data & 0x0000000E)
    {     
    case 0x00: C("ONE BPP");
               break; 
    case 0x02: C("TWO BPP");
               break; 
    case 0x04: C("FOUR BPP");
               break;
    case 0x06: C("EIGHT BPP");
               break;
    case 0x08: C("16 BPP");
               break;
    case 0x0A: C("24 BPP");
               break;
    default  : C("INVALID BPP");
    }
  if((control_Data & 0x00000200)==0x00000200)
    {
    C(" BIG ENDIAN B O");
    }
  else
    {
     C("LITTLE ENDIAN B O");
    }
  if((control_Data & 0x00000400)==0x00000400)
    {
    C("BIG ENDIAN P O"); 
    } 
  else 
    { 
    C("LITTLE ENDIAN P O");
    }
  if((control_Data & 0x00000100)==0x00000100)
    {
    C(" BGR MODE");
    }
  else
    { 
    C("RGB MODE");
    }
  }
else
  {
  C("  STN MODE ");
  switch(control_Data & 0x0000000E)
    {
    case 0x00: C("ONE BPP");
               break; 
    case 0x02: C("TWO BPP");
               break; 
    case 0x04: C("FOUR BPP");
               break;
    case 0x06: C("EIGHT BPP");
               break;
    case 0x08: C("16 BPP");
               break;
    default  : C("INVALID BPP");
    }
  if((control_Data & 0x00000200)==0x00000200)
    {
    C(" BIG ENDIAN B O");
    }
  else
    {
    C("LITTLE ENDIAN B O");
    }
  if((control_Data & 0x00000400))
    {
    C("BIG ENDIAN P O"); 
    } 
  else
    {
    C("LITTLE ENDIAN P O");
    }   
  if((control_Data & 0x00000100)==0x00000100)
    {
    C(" BGR MODE");
    }
  else
    {
    C("RGB MODE");
    }
  if((control_Data & 0x00000010)==0x00000010)
    {
    C("MONOCHROME MODE");
    }
  else
    {
    C("COLOUR MODE ");
    }
  if((control_Data & 0x00000040)==0x00000040)
    {
    C("8 BIT INTERFACE ");
    }
  else
    {
    C("4 BIT INTERFACE ");
    }
  if((control_Data & 0x00000080)==0x00000080)
    {
    C(" DUAL PANEL ");
    }
  else
    {
    C("SINGLE PANEL");
    }
  } 
}


/********************************* End of MAIN ********************************/
