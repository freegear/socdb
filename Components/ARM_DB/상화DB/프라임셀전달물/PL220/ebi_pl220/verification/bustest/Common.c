/*-- --=======================================================================--
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
-- File Name              : Common.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL220-r0p0-00ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It is a common program which contains functions used by other test
--           cases.
--
-- --=======================================================================--*/

/******************************************************************************/
/****************************** WaitLoop **************************************/
/******************************************************************************/
void WaitLoop(int cycles)
{
  /*
    Summary : Idle cycle insertion Loop
    ===================================

    o The number of Idle cycles inserted will be determined by the
      integer 'cycles'

    o Idle cycles are inserted during read operation
  */

  int i;

  for (i = 1; i <= cycles; i++)
  {
    HSA(0x00000000, IDLE, INCR, , , , , , , , , ,idle);
    HSR(, Data_0s, , , ,idlecycle);
  }
}

/******************************************************************************/
/******************************** Write access ********************************/
/**************************************************i***************************/
void Write(int32 address, int32 data, char *size)
{
  /*
    Summary: Write()
    ====================
    This function does the write operation
  */
  char hsize;
  if(size == "WRD")
    hsize = 'w';
  else if(size == "HWRD")
    hsize = 'h';
  else if(size == "BYTE")
    hsize = 'b';
  HSA(address, NSEQ, SINGLE, OK, hsize, 0x0, 0x0, , 0x0, , , );
  HSW( , data);
}
/******************************************************************************/
/********************************** Read access *******************************/
/******************************************************************************/
void Read(int32 address, int32 data, int32 mask,char *size)
{
  /*
     Summary: Read()
     ====================
     This function does the read operation
  */
  char hsize;
  if(size == "WRD")
    hsize = 'w';
  else if(size == "HWRD")
    hsize = 'h';
  else if(size == "BYTE")
    hsize = 'b';
  HSA(address, NSEQ, SINGLE, OK, hsize, 0x0, 0x0, , 0x0, , , );
  HSR( , data, , mask, , );
}
/*-- --============================= End ================================-- --*/


