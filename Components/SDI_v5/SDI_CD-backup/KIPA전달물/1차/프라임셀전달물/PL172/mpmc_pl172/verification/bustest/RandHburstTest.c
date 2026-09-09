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
-- File Name              : RandHburstTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function verifies memory accesses with random types of bursts
--
--           TEST ID : MPMC_RandHburst_1
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** RandHburstTest ********************************/
/******************************************************************************/
void RandHburstTest(void)
{
  /*
    Summary: RandHburstTest
    =======================
    This function does the following functionality

    o  This test targets static memory and selects the chip selects randomly.
    
    o  Memory is accessed with different types of bursts applied randomly
       and data integrity is checked by reading it back. 
  */
  int i;
  int Data,size,csel,chip, msize;
  int Bound,burst,LoBits;

  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] = 
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  unsigned long Addr; 
  char debugstr[100];
  C("TEST ID : MPMC_RandHburst_1");
  /* Disable the addres mirror bit */
  WriteData(MPMCControl, 0x00000001, "WRD");
  
  C("Program Bank0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,0,0,0,0x3,0x3,0x4,0x7,0x5,0x5,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x3,0x3,0x4,0x7,0x5,0x5,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Program Bank1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
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
  StInitProc(3,1,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,1,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  Data = 0x22222222;
  for(i = 0; i < 80; i++)
  {
    chip = rand() % 4;
    sprintf(debugstr,"Bank: %X", chip);
    C(debugstr);
    if(chip == 0)
      msize = 0;
    else if(chip == 1)
      msize == 1;
    else if(chip == 2)
      msize = 2;
    else if(chip == 3)
      msize = 1;
    Addr = rand() & 0x000001FC; 
    burst = rand() % 8;
    size = rand() % 3;
    if(sizetype[size] == "BYTE")
    { 
      debug_info(" Byte Transfer ");
      if (chip == 2)
      {
        WaitLoop(0x3);
        HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
        HPO(,0x00000000, ,0x00000003);
        WaitLoop(0x3);
        WriteData(MPMCTrMEMT_2, 0x52, "WRD");
        BurstWrRd(chip,burst,Addr,size,msize,Data); 
        WaitLoop(0x3);
        HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
        HPO(,0x00000000, ,0x00000003);
        WaitLoop(0x3);
        WriteData(MPMCTrMEMT_2, 0x42, "WRD");
      }
      else
        BurstWrRd(chip,burst,Addr,size,msize,Data);
    } 
    else if(sizetype[size] == "HWRD")
    {
      debug_info(" Halfword Transfer ");
      if (chip == 2)
      {
        WaitLoop(0x3);
        HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
        HPO(,0x00000000, ,0x00000003);
        WaitLoop(0x3);
        WriteData(MPMCTrMEMT_2, 0x52, "WRD");
        BurstWrRd(chip,burst,Addr,size,msize,Data);
        WaitLoop(0x3);
        HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
        HPO(,0x00000000, ,0x00000003);
        WaitLoop(0x3);
        WriteData(MPMCTrMEMT_2, 0x42, "WRD");
      }
      else
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
    else if(sizetype[size] == "WRD")
    {
      debug_info(" Word Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }  
  }
}
/*-- --================================ End ================================--*/
