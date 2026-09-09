/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001-2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : MpmcCommon.c.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains global variables and common functions
--           used by other tests.
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Global Variables *******************************/
/******************************************************************************/
char retstr[100];
/******************************************************************************/
/***************************** Common Functions *******************************/
/******************************************************************************/

/******************************************************************************/
/******************************* WriteReadTests *******************************/
/******************************************************************************/
void WriteReadTests(int32 TestData, int32 Mask, int Beats, int hsize)
{
  /*
     Summary: Write-Read Tests
     =========================
     This performs performs the following:

     o  Write data to registers according to the parameters passed to the
        function.
 
     o  Read data back and check the data integrity.
  */
  
  int i;
  int Shift[3] = {8, 16, 32};
  int32 TempData, Data, TempMask, Addr;
  char size[3] = {'b', 'h', 'w'};

  TempData = TestData;
  Data = TempData++ & Mask;
  /** Performing Writes on the Generic Slave **/
  HSA(GS_ARRAY1, NSEQ, INCR, , size[hsize], , 0x1, , , , ,);
  HSW( , Data);
  for (i=1; i<Beats; i++, TempData++)
  {
    TempMask = Mask << i*Shift[hsize];
    Data = (TempData << i*Shift[hsize]) & TempMask;
    HSW( , Data);
  }

  TempData = TestData;
  Data = TempData++ & Mask;
  /** Reading back the data from the Generic Slave **/
  HSA(GS_ARRAY1, NSEQ, INCR, , size[hsize], , 0x1, , , , ,);
  HSR( , Data, , Mask, ,WriteReadTests_1);
  for (i=1; i<Beats; i++, TempData++)
  {
    TempMask = Mask << i*Shift[hsize];
    Data = (TempData << i*Shift[hsize]) & TempMask;
    HSR( , Data, , TempMask, ,WriteReadTests_1);
  }
}

/******************************************************************************/
/********************************* String Concatenation ***********************/
/******************************************************************************/
char *stringcat(char *string1, char *string2)
{
  /*
     Summary:
     ========
     o This will combine the given two strings, first string followed by the
       second one.
  */
  int i;
  int j=0;

  for (i = 0; i < strlen(string1); i++)
  {
    retstr[j] = string1[i];
    j++;
  }

  for (i = 0; i < strlen(string2); i++)
  {
    retstr[j] = string2[i];
    j++;
  }

  retstr[j] = '\0';
  return (retstr);
}
/******************************************************************************/
/************************************ End *************************************/
