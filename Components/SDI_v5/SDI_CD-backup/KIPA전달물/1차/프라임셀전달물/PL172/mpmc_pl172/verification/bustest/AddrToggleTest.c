/* -- --======================================================================--
-- This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001-2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : AddrToggleTest.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
     Purpose :
--           This routine toggles all bits of memory-related address bits 
--
--           TEST ID : MPMC_AddrToggle_1
--
-- --======================================================================--*/
/*****************************************************************************/
/******************************* AddressToggleTest ***************************/
/*****************************************************************************/
void AddrToggleTest()
{
  /*
    Summary: Address Toggle Tests
    =============================
    This function performs the following:

    o  Toggles all memory related address bits in the MPMC.
  */

  int i,j,chip;
  char debugstr[100];
  unsigned long DataArr[8] = {0x01010101, 0x10101010, 0xA0A0A0A0, 0x50505050,
                              0xAAAAAAAA, 0x44444444, 0xEEEEEEEE, 0x33333333};
  unsigned long Addr,Data;
  unsigned long AddrArr[8] = {0x0AAAAAAC, 0x2555555C, 0x2FFFFFFC,0x30000000,
                              0x40000000, 0x5AAAAAA4, 0x6555555C,0x7EFFFFF0};
  C("TEST ID : MPMC_AddrToggle_1");
  C("Initialize dynamic memory controller register");
  C("Initialize Sync Memory");
  WriteData(MPMCControl, 0x00000001, "WRD");
  TimingInit(2,6,8,0,6,5,0,7,7,0,2,3);
  SyncInitializeProc(2, 0, 2, 3, 0, 0,
                     3, 0, 3, 2, 0, 0,
                     3, 0, 3, 3, 0, 0,
                     2, 0, 3, 3, 0, 0,
                     0,1,0,0,1,1,1,0,2,0,0,
                     0,0,0,0,0,1,1,0,3,0,0,
                     0,0,1,0,0,1,1,0,3,1,1,
                     0,0,2,0,1,1,1,0,4,1,1,
                     11,11,12,14,
                     0,
                     0);
  C("Initialize static memory controller register");
  
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  StInitProc(0,2,0,0,1,0,0,0,0,0x1,0x1,0x1,0x2,0x1,0x1,0x3);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  StInitProc(1,1,0,0,1,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x3,0x3);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  StInitProc(2,0,0,0,0,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x3);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  StInitProc(3,2,0,0,0,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x3);

  C("Toggle all address lines");
  for (j = 0; j < 8; j++)
  {
    Addr = AddrArr[j];
    Data = DataArr[j];
    sprintf(debugstr,"Address is %X",Addr);
    debug_info(debugstr);
    sprintf(debugstr,"Data is %X",Data);
    debug_info(debugstr);
    ReadData(Addr, Data, 0x00000000, "BYTE");
  }
  for (j = 0; j < 8; j++)
  {  
    Addr = 0x00000000 | j << 28;
    ReadData(Addr, Data, 0x00000000, "BYTE");
  }

}
/*-- --=========================== END ====================================-- */
