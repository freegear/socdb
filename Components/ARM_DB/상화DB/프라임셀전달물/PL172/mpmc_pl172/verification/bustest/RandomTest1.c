/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
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
-- File Name              : RandomTest1.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function verifies memory accesses with random types of bursts
--
--           TEST ID : MPMC_RandomTest1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************** RandomTest1 *********************************/
/******************************************************************************/
void RandomTest1(void)
{
  /*
    Summary: RandomTest1
    ====================
    This function verifies the following functionality

    o  Memory is accessed with different types of bursts applied randomly
 
    o  Banks are selected randomly.

    o  Data integrity is checked by reading the data back. 
  */

  int i;
  int Data,size,csel,chip, msize;
  int Bound,burst,LoBits;
  int trans[128];
  int bursttrans;
  char* BurstStr[] = {"sin", "inc","wr4", "in4", "wr8", "in8", "w16", "i16"};
  int caslat0,caslat1,caslat2,caslat3;
  int raslat0,raslat1,raslat2,raslat3;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] = 
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  unsigned long Addr; 
  char debugstr[100];
  C("TEST ID : MPMC_RandomTest1");
  /* Disable the addres mirror bit */
  WriteData(MPMCControl, 0x00000001, "WRD");
  caslat0 = rand() % 1;
  raslat0 = rand() % 1;
  caslat0 = caslat0 + 2;
  raslat0 = raslat0 + 2;

  caslat1 = rand() % 1;
  raslat1 = rand() % 1;
  caslat1 = caslat1 + 2;
  raslat1 = raslat1 + 2;

  caslat2 = rand() % 1;
  raslat2 = rand() % 1;
  caslat2 = caslat2 + 2;
  raslat2 = raslat2 + 2;

  caslat3 = rand() % 1;
  raslat3 = rand() % 1;
  caslat3 = caslat3 + 2;
  raslat3 = raslat3 + 2;

  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
  SyncInitializeProc(3, 0, caslat0, raslat0, 0, 0,
                     2, 0, caslat1, raslat1, 0, 0,
                     3, 0, caslat2, raslat2, 0, 0,
                     3, 0, caslat3, raslat3, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);

  MPMCTrMEMBData[0] = 0x00000000;
  C("Program Bank0");
  StInitProc(0,0,0,0,0,0,0,0,0,0x2,0x2,0x2,0x2,0x2,0x5,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x2,0x2,0x2,0x2,0x2,0x5,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Program Bank1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x3,0x3,0x3,0x3,0x3,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x3,0x3,0x3,0x3,0x3,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Program Bank2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,0,0,0x1,0x1,0x1,0x1,0x1,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x1,0x1,0x1,0x1,0x1,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Program Bank3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,1,1,1,0x4,0x4,0x4,0x4,0x4,0x7,0x3);
  TrickMemInit(3,2,0,0,1,0,1,1,1,0x4,0x4,0x4,0x4,0x4,0x7,MPMCTrMEMBData[3],
               0x0);
  Data = 0x22222222;
  for(i = 0; i < 100; i++)
  {
    sprintf(debugstr,"Iteration No: %X",i);
    C(debugstr);
   /* Check only dynamic memory controller */
    chip = rand() % 7;
    /* If chip connected is ROM don't write to the memory */
    if(chip == 3)
      chip = chip-1; 
    sprintf(debugstr,"Bank: %X", chip);
    C(debugstr);
    if(chip == 0)
      msize = 0;
    else if(chip == 1)
      msize = 1;
    else if(chip == 2)
      msize = 2;
    else if(chip == 3)
      msize = 0;
    else if(chip == 4)
      msize = 1;
    else if(chip == 5)
      msize = 2;
    else if(chip == 6)
      msize = 1;
    else 
      msize = 1;
    if(chip < 4)
      Addr = rand() & 0x000000FC;
    else
    {
      Addr = rand() & 0x0FFFFFFC;
      LoBits = Addr & 0x03FF;
      Bound  = LoBits + 400;
      if (Bound > 1024)
        Addr = Addr - 400;
      chip = chip << 28;
      Addr = Addr | chip;
    }
      burst = rand() % 8;
      if (burst == 0 | burst == 1)
        bursttrans = (rand() & 0x16) + 1;      
      else if(burst == 2 | burst == 3) 
        bursttrans = 4;
      else if(burst == 4 | burst == 5)
        bursttrans = 8;
      else
        bursttrans = 16;
      size = rand() % 3;
    if(sizetype[size] == "BYTE")
    { 
      debug_info(" Byte Transfer ");
      InitTransRnd(trans, bursttrans);
      Sequence('w', Addr,trans, BurstStr[burst],size,0x11111111,0);
      InitTransRnd(trans, bursttrans);
      Sequence('r', Addr,trans, BurstStr[burst],size,0x11111111,0);
      } 
     else if(sizetype[size] == "HWRD")
    {
      InitTransRnd(trans, bursttrans);
      Sequence('w', Addr,trans, BurstStr[burst],size,0x33333333,0);
      InitTransRnd(trans, bursttrans);
      Sequence('r', Addr,trans, BurstStr[burst],size,0x33333333,0);
    }
    else if(sizetype[size] == "WRD")
    {
      InitTransRnd(trans, bursttrans);
      Sequence('w', Addr,trans, BurstStr[burst],size,0x55555555,0);
      InitTransRnd(trans, bursttrans);
      Sequence('r', Addr,trans, BurstStr[burst],size,0x55555555,0);
    }  
  }
  C("Test for ROM with minimum delay values");
  AHBWriteMem(3, 0xA0, 0x30, 0x00000022);
  AHBWriteMem(3, 0x80, 0x8, 0x0000002A);
  Addr = MEM3_BASE + 0xA0;
  Data = 0x00000022;
  HSA(Addr, NSEQ, INCR4, OK, WRD);
  HSR(, Data++, ,MaskALL);
  for(i = 0; i < 3; i++)
    HSR(, Data++, ,MaskALL);

  Data = 0x00000022;
  HSA(Addr, NSEQ, INCR8, OK, WRD);
  HSR(, Data++, ,MaskALL);
  for(i = 0; i < 7; i++)
    HSR(, Data++, ,MaskALL);

  Data = 0x00000022;
  HSA(Addr, NSEQ, INCR16, OK, WRD);
  HSR(, Data++, ,MaskALL);
  for(i = 0; i < 15; i++)
    HSR(, Data++, ,MaskALL);

  Data = 0x00000022;
  HSA(Addr, NSEQ, WRAP4, OK, WRD);
  HSR(, Data++, ,MaskALL);
  for(i = 0; i < 3; i++)
    HSR(, Data++, ,MaskALL);

  Data = 0x00000022;
  HSA(Addr, NSEQ, WRAP8, OK, WRD);
  HSR(, Data++, ,MaskALL);
  for(i = 0; i < 7; i++)
    HSR(, Data++, ,MaskALL);

  Data = 0x00000022;
  HSA(Addr, NSEQ, WRAP16, OK, WRD);
  HSR(, Data++, ,MaskALL);
  for(i = 0; i < 15; i++)
    HSR(, Data++, ,MaskALL);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x00000008);

}
/*-- --================================ End ================================--*/
