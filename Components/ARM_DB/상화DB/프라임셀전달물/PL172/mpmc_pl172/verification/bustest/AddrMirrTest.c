/*--==========================================================================--
This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : AddrMirrTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--          This function tests the address mirror functionality
--
--          TEST ID : MPMC_AddrMirr_1
--
-- --=======================================================================--*/
/******************************************************************************/
/*************************** Address Mirror Test ******************************/
/******************************************************************************/
void AddrMirrTest(void)
{
  /*
    Summary: AddrMirrTest
    =====================
    This test verifies the functionality of addr mirror bit of MPMCControl reg
   
    o  Data is written to CS0 and CS1 and read back with AddrMirror bit as 0

    o  Data is written to CS1 and CS4 and read back with AddrMirror bit as 0

    o  Data is written to CS0 and read the same location of CS1 with
       AddrMirror bit as 1.

    o  Data is written to CS4 and read the same location of CS1 with
       AddrMirror bit as 1.
  */  

  unsigned long addr,addr1;
  int i,j;
  char debugstr[100];
  unsigned long val[4]     = {0x0000000A,0xFFFFFFFF,0x55555555,0xAAAAAAAA};
  unsigned long valdiff[4] = {0x22222222,0x66666666,0x11111111,0xDDDDDDDD};
  unsigned long CS0addr[4] = {0x00000000,0x00000100,0x000001C0,0x000001D0};
  unsigned long CS1addr[4] = {0x10000000,0x10000100,0x100001C0,0x100001D0}; 
  unsigned long CS4addr[4] = {0x40000000,0x40000100,0x400001C0,0x400001D0};
  C("Initialize controller registers as well as trick memory register");
  C("TEST ID : MPMC_AddrMirr_1");
  C(" Disable address mirror bit ");
  /* Write 0 to R bit of MPMCControl register */
  WriteData(MPMCControl, 0x00000001, "WRD"); 
 
  SyncInitializeProc(3, 0, 2, 3, 0, 0,
                     2, 0, 3, 3, 0, 0,
                     3, 0, 3, 3, 0, 0,
                     3, 0, 2, 3, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);
   /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank0 and TrickMem0");
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x6,0x7,0x7,0x9,0x3,0x3);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x6,0x7,0x7,0x9,0x3,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank1 and TrickMem1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,2,0,1,1,0,0,0,0,0x4,0x6,0x7,0x7,0x9,0x3,0x3);
  TrickMemInit(1,2,0,1,1,0,0,0,0,0x4,0x6,0x7,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);
  C("Initialize registers of bank2 and TrickMem2");
  StInitProc(2,2,0,0,1,0,0,0,0,0x4,0x6,0x7,0x7,0x9,0x3,0x3);
  TrickMemInit(2,2,0,0,1,0,0,0,0,0x4,0x6,0x7,0x7,0x9,0x3,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank3 and TrickMem3");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(3,2,0,1,1,0,0,0,0,0x4,0x6,0x7,0x7,0x9,0x3,0x3);
  TrickMemInit(3,2,0,1,1,0,0,0,0,0x4,0x6,0x7,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0); 
  addr = CS0addr[1];  

  C("Write a word to chip0");
  WriteData(addr, 0xFFFFFFFF,"WRD");
 

  debug_info("Reading the data back");
  /* Read the data back */
  ReadData(addr, 0xFFFFFFFF, MaskALL,"WRD");

  C("Write a word to to chip4");
  addr = 0x40000000;
  WriteData(addr, 0xFFFFFFFF,"WRD");
  C("Read data back");
  ReadData(addr, 0xFFFFFFFF, MaskALL,"WRD");

  /* Write 1 to R bit of MPMCControl register,now CS0 data is 
     mirrored into CS1 */
  C("Enable address mirror bit");
  WriteData(MPMCControl, 0x00000003, "WRD");
  for(j = 0; j < 4; j++)
  {
    for(i = 0; i < 4; i++) 
    {
      WaitLoop(0x2);
      C("Write data to CS0 and read it back from CS1"); 
      addr = CS0addr[i];
      addr1 = CS4addr[i];
      /* Write a word to chip1 */
      sprintf(debugstr,"Writing to address  %X", addr); 
      debug_info(debugstr);
      WriteData(addr, val[j],"WRD");

      addr = CS1addr[i];
      C("Read the same memory location of CS1");
      sprintf(debugstr,"Reading from address  %X", addr);  
      debug_info(debugstr);

      ReadData(addr, val[j],MaskALL,"WRD");

      C("Write data to CS4 and read it back from CS1");
      WriteData(addr1, valdiff[j],"WRD");

      addr1 = CS1addr[i];
      C("Read the same memory location of CS1");
      ReadData(addr1,valdiff[j],MaskALL,"WRD");
    }
  }
}
/*-- --================================ End ================================--*/
