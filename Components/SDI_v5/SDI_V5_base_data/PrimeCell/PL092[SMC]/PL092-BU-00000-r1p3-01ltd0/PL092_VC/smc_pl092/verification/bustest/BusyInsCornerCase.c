/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : BusyInsCornerCase.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           To check busy insertion at various points in a transfer.
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** BURST ROM Tests *******************************/
/******************************************************************************/

void BusyInsCornerCase()
{
  /*
     Summary: Busy Insertion Corner Case.
     ====================================
     This function performs the following:

     o  Write/ Read transactions with Busy inserted in between.
  */

  int Address;
  int trans5[5] = {2,1,1,0,5};
  int trans4[5] = {2,1,1,1,5};
 /* int trans5[9] = {2,1,0,0,2,3,1,3,5}; */
  int trans6[5] = {2,3,3,3,5};
  char PrintStr[128];
  char* SizeStr[7] = {"WRD","HWRD", "BYTE","HWRD", "WRD","HWRD","HWRD"};


C(" Configure the memory");

  /** Set Bank 1 Memory Type as SRAM (32 bits width) with 
   ** burst mode not enabled Cr value = 0x80
   ** burst mode enabled  Cr Value    = 0xA0
   **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00000080, 0x000000,
                  0x000000);

  C("Write without busy");
  Address = SMCMEM_1 + 0x420 * 0x00;
  Sequence('w',Address, trans6,"wr4",2,0x55555555,0);
   
  C("Insert Busy for 32 bit Memory device");

  Sequence('w',Address, trans5,"wr4",2,0x46222246,0);
  Sequence('r',Address, trans4,"wr4",2,0x46222246,0);

}


/************************************ End *************************************/
