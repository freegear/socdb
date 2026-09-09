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
-- File Name              : RandHburstTest2.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function verifies memory accesses with random types of bursts
--
--           TEST ID : MPMC_DyRandHburst2
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** RandHburstTest2 *******************************/
/******************************************************************************/
void RandHburstTest2(void)
{
  /*
    Summary: RandHburstTest2
    ========================
    This function does the following functionality

    o  This test targets dynamic memory with clk ratio as 1:2.

    o  Memory is accessed with different types of bursts applied randomly
       and data integrity is checked by reading it back. 
  */

  int i;
  int Data,size,csel,chip, msize;
  int Bound,burst,LoBits;
  int caslat0,caslat1,caslat2,caslat3;
  int raslat0,raslat1,raslat2,raslat3;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] = 
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  int trans0[7] = {2,3,3,3,3,3,5};
  int trans4[5] = {2,3,3,3,5};
  int trans8[9] = {2,3,3,3,3,3,3,3,5};
  int trans16[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int32 Addr1,Addr2;
  unsigned long Addr; 
  char debugstr[100];
  C("TEST ID : MPMC_DyRandHburst2");
  /* Disable the addres mirror bit */
  WriteData(MPMCControl, 0x00000001, "WRD");
  
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
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
                     3);
  WriteData(MPMCTrSR, 0x00000000, "WRD");

  C("Program Bank0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,0,0,0,0x3,0x3,0x4,0x7,0x5,0x5,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x3,0x3,0x4,0x7,0x5,0x5,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Program Bank1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,0,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,0,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Program Bank2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Program Bank3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,0,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,1,0,0,0,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  Data = 0x22222222;
  for(i = 0; i < 100; i++)
  {
    chip = rand() % 4;
    chip = chip + 4;
    sprintf(debugstr,"Bank: %X", chip);
    C(debugstr);
    if(chip == 4)
      msize = 1;
    else if(chip == 5)
      msize = 2;
    else if(chip == 6)
      msize = 1;
    else 
      msize = 1;
    Addr = rand() & 0x0FFFFFFC;
    LoBits = Addr & 0x03FF;
    Bound  = LoBits + 400;
    if (Bound > 1024)
      Addr = Addr - 400;
    chip = chip << 28;
    Addr = Addr | chip;
    burst = rand() % 8;
    size = rand() % 3;
    if(sizetype[size] == "BYTE")
    { 
      debug_info(" Byte Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data); 
    } 
    else if(sizetype[size] == "HWRD")
    {
      debug_info(" Halfword Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
    else if(sizetype[size] == "WRD")
    {
      debug_info(" Word Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }  
  }
  Addr1 = rand() & 0x000001FF;
  Addr2 = rand() & 0x000001FF;
  Addr2 = Addr2 | 0x40000000;
  Sequence('w', Addr1,trans8, "inc",0,0x11111111,0);
  Sequence('w', Addr2,trans4, "in4",0,0x11111111,0);
  Sequence('r', Addr1,trans8, "in8",0,0x11111111,0);
  Sequence('r', Addr2,trans4, "in4",0,0x11111111,0);

  Addr1 = rand() & 0x000001FE;
  Addr2 = rand() & 0x000001FC;
  Addr2 = Addr2 | 0x10000000;
  Sequence('w', Addr1,trans8, "wr8",1,0x33333333,0);
  Sequence('w', Addr2,trans8, "in8",2,0x11111111,0);
  Sequence('r', Addr1,trans8, "wr8",1,0x33333333,0);
  Sequence('r', Addr2,trans8, "in8",2,0x11111111,0);
  Sequence('r', Addr1,trans8, "wr8",1,0x33333333,0);

  Addr1 = rand() & 0x00000FFF;
  Addr1 = Addr1 | 0x50000000;
  Sequence('w', Addr1,trans8, "wr8",0,0x22222222,0);
  Addr2 = rand() & 0x00000F0E;
  Addr2 = Addr2 | 0x50000000; 
  Sequence('w', Addr2,trans16, "i16",1,0x33333333,0);
  Sequence('r', Addr1,trans8, "wr8",0,0x22222222,0);
  Sequence('r', Addr2,trans16, "i16",1,0x33333333,0);

  Addr1 = rand() & 0x000001FF;
  Addr2 = rand() & 0x000001FF;
  Addr2 = Addr2 | 0x20000000;
  Sequence('w', Addr1,trans8, "in8",0,0x55555555,0);
  Sequence('w', Addr2,trans4, "wr4",0,0xEEEEEEEE,0);
  Sequence('r', Addr1,trans8, "in8",0,0x55555555,0);
  Sequence('r', Addr2,trans4, "wr4",0,0xEEEEEEEE,0);
  Addr2 = rand() & 0x000001FE;
  Addr2 = Addr2 | 0x40000000;
  Sequence('w', Addr2,trans16, "w16",1,0x44444444,0);
  Sequence('w', Addr1,trans16, "w16",0,0x99999999,0);
  Sequence('r', Addr2,trans16, "w16",1,0x44444444,0);
  Sequence('r', Addr1,trans16, "w16",0,0x99999999,0);

  Addr1 = rand() & 0x00000FFC;
  Addr1 = Addr1 | 0x70000000;
  Addr2 = rand() & 0x00000FFF;
  Addr2 = Addr2 | 0x10000000;
  Sequence('w', Addr1,trans16, "i16",2,0x11111111,0);
  Sequence('w', Addr2,trans16, "w16",0,0x55555555,0);
  Sequence('r', Addr2,trans16, "w16",0,0x55555555,0);
  Sequence('r', Addr1,trans16, "i16",2,0x11111111,0);

  Addr2 = rand() & 0x00000FFF;
  Addr2 = Addr2 | 0x20000000;
  Addr1 = rand() & 0x00000FFE;
  Addr1 = Addr1 | 0x10000000;
  Sequence('w', Addr2,trans16, "i16",0,0x55555555,0);
  Sequence('w', Addr1,trans8, "in8",1,0x55555555,0);
  Sequence('r', Addr1,trans4, "in4",1,0x55555555,0);
  Sequence('r', Addr2,trans8, "in8",0,0x55555555,0);
  
  Addr1 = rand() & 0x000000FE;
  Addr1 = Addr1 | 0x10000000;
  Addr2 = rand() & 0x000007CE;
  Addr2 = Addr2 | 0x10000000;
  Sequence('w', Addr1,trans4, "in4",0,0x55555555,0);
  Sequence('w', Addr2,trans8, "in8",1,0x77777777,0);
  Sequence('r', Addr1,trans4, "in4",0,0x55555555,0);
  Sequence('r', Addr2,trans8, "in8",1,0x77777777,0);

  Addr1 = rand() & 0x000FF7CF;
  Addr1 = Addr1 | 0x50000000;
  Addr2 = rand() & 0x000000CF;
  Sequence('w', Addr1,trans8, "wr8",0,0x55555555,0);
  Sequence('w', Addr2,trans8, "in8",0,0x44444444,0);
  Sequence('r', Addr2,trans8, "in8",0,0x44444444,0);
  Sequence('r', Addr1,trans8, "wr8",0,0x55555555,0);
  Sequence('r', Addr2,trans8, "in8",0,0x44444444,0);

  Addr1 = rand() & 0x000003FC;
  Addr1 = Addr1 | 0x10000000;
  Addr2 = rand() & 0x0000010E;
  Addr2 = Addr2 | 0x10000000;
  Sequence('w', Addr1,trans4, "in4",2,0x11111111,0);
  Sequence('w', Addr2,trans8, "in8",1,0x77777777,0);
  Sequence('r', Addr1,trans4, "in4",2,0x11111111,0);
  Sequence('r', Addr2,trans8, "in8",1,0x77777777,0);

  Addr1 = rand() & 0x000FF1FC;
  Addr1 = Addr1 | 0x40000000;
  Addr2 = rand() & 0x000000FE;
  Addr2 = Addr2 | 0x30000000;
  
  Sequence('w', Addr1,trans16, "i16",2,0x66666666,0);
  Sequence('w', Addr2,trans8, "wr8",1,0x55555555,0);
  Sequence('r', Addr1,trans16, "i16",2,0x66666666,0);
  Sequence('r', Addr2,trans8, "wr8",1,0x55555555,0);

  Addr1 = rand() & 0x000FF1FC;
  Addr1 = Addr1 | 0x50000000;
  Addr2 = rand() & 0x000000FE;
  Addr2 = Addr2 | 0x60000000;

  Sequence('w', Addr1,trans4, "in4",2,0xAAAAAAAA,0);
  Sequence('w', Addr2,trans8, "in8",1,0xBBBBBBBB,0);
  Sequence('r', Addr1,trans4, "in4",2,0xAAAAAAAA,0);
  Sequence('r', Addr2,trans8, "in8",1,0xBBBBBBBB,0);

  Addr2 = rand() & 0x000FF1FC;
  Addr2 = Addr2 | 0x70000000;
  Addr1 = rand() & 0x000000FE;
  Addr1 = Addr1 | 0x60000000;
  Sequence('w', Addr2,trans16, "w16",2,0xCCCCCCCC,0);
  Sequence('w', Addr1,trans8, "wr8",1,0xDDDDDDDD,0);
  Sequence('r', Addr2,trans16, "w16",2,0xCCCCCCCC,0);
  Sequence('r', Addr1,trans8, "wr8",1,0xDDDDDDDD,0);

  Addr1 = rand() & 0x000001FC;
  Addr1 = Addr1 | 0x50000000;
  Addr2 = rand() & 0x000000FF;
  Addr2 = Addr2 | 0x60000000;
  Sequence('w', Addr1,trans4, "in4",2,0xEEEEEEEE,0);
  Sequence('w', Addr2,trans8, "in8",0,0x11111111,0);
  Sequence('r', Addr1,trans4, "in4",2,0xEEEEEEEE,0);
  Sequence('r', Addr2,trans8, "in8",0,0x11111111,0);

  Addr1 = rand() & 0x000FFFFC;
  Addr1 = Addr1 | 0x70000000;
  Addr2 = rand() & 0x000000FF;
  Addr2 = Addr2 | 0x70000000;
  Sequence('w', Addr1,trans16, "w16",2,0x88888888,0);
  Sequence('w', Addr2,trans8, "wr8",0,0xAAAAAAAA,0);
  Sequence('r', Addr1,trans16, "w16",2,0x88888888,0);
  Sequence('r', Addr2,trans8, "wr8",0,0xAAAAAAAA,0);

  Addr1 = rand() & 0x00000FFC;
  Addr1 = Addr1 | 0x20000000;
  Addr2 = rand() & 0x000000FF;
  Addr2 = Addr2 | 0x10000000;
  Sequence('w', Addr1,trans16, "i16",2,0x55555555,0);
  Sequence('w', Addr2,trans8, "wr8",0,0x33333333,0);
  Sequence('r', Addr1,trans16, "i16",2,0x55555555,0);
  Sequence('r', Addr2,trans8, "wr8",0,0x33333333,0);

  Addr1 = rand() & 0x00000FFC;
  Addr1 = Addr1 | 0x40000000;
  Addr2 = rand() & 0x000000FF;
  Addr2 = Addr2 | 0x30000000;

  Sequence('w', Addr1,trans0, "inc",2,0x66666666,0);
  Sequence('w', Addr2,trans8, "wr8",0,0x99999999,0);
  Sequence('r', Addr1,trans0, "inc",2,0x66666666,0);
  Sequence('r', Addr2,trans8, "wr8",0,0x99999999,0);

  Addr1 = rand() & 0x00000FFC;
  Addr1 = Addr1 | 0x20000000;
  Addr2 = rand() & 0x000000FF;

  Sequence('w', Addr1,trans4, "in4",2,0x55555555,0);
  Sequence('w', Addr2,trans8, "wr8",0,0x22222222,0);
  Sequence('r', Addr1,trans4, "in4",2,0x55555555,0);
  Sequence('r', Addr2,trans8, "wr8",0,0x22222222,0);

  Addr1 = rand() & 0x00000FFE;
  Addr1 = Addr1 | 0x10000000;
  Addr2 = rand() & 0x000000FF;

  Sequence('w', Addr1,trans4, "inc",1,0x88888888,0);
  Sequence('w', Addr2,trans8, "wr8",0,0x55555555,0);
  Sequence('r', Addr1,trans4, "in4",1,0x88888888,0);
  Sequence('r', Addr2,trans8, "wr8",0,0x55555555,0);

}
/*-- --================================ End ================================--*/
