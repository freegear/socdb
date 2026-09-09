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
-- File Name              : RandHburstTest1.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function verifies memory accesses with random types of bursts
--
--           TEST ID : MPMC_DyRandHburst1
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** RandHburstTest1 *******************************/
/******************************************************************************/
void RandHburstTest1(void)
{
  /*
    Summary: RandHburstTest1
    ========================
    This function verifies the following functionality
   
    o  This test targets dynamic memory with clk ratio as 1:1.

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

  unsigned long Addr, Addr1, Addr2; 
  int trans[128];
  char debugstr[100];
  C("TEST ID : MPMC_DyRandHburst1");
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
  for(i = 0; i < 200; i++)
  {
    sprintf(debugstr,"Iteration No: %X",i);
    C(debugstr);
    
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
      if (csel == 2)
      {
         C("Poll for busy bit");
         WaitLoop(0x3);
         HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
         HPO(,0x00000000, ,0x00000003);
         WaitLoop(0x3);
         WriteData(MPMCTrMEMT_2, 0x51, "WRD");
         BurstWrRd(chip,burst,Addr,size,msize,Data); 
         WaitLoop(0x3);
         HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
         HPO(,0x00000000, ,0x00000003);
         WaitLoop(0x3);
         WriteData(MPMCTrMEMT_2, 0x41, "WRD");
       }
       else
         BurstWrRd(chip,burst,Addr,size,msize,Data);
    } 
    else if(sizetype[size] == "HWRD")
    {
       debug_info(" Halfword Transfer ");
       if (csel == 2)
       {
         C("Poll for busy bit");
         WaitLoop(0x3);
         HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
         HPO(,0x00000000, ,0x00000003);
         WaitLoop(0x3);
         WriteData(MPMCTrMEMT_2, 0x51, "WRD");
         BurstWrRd(chip,burst,Addr,size,msize,Data);
         WaitLoop(0x3);
         HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
         HPO(,0x00000000, ,0x00000003);
         WaitLoop(0x3);
         WriteData(MPMCTrMEMT_2, 0x41, "WRD");
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
  Addr1 = 0x00000137; 
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "inc",0,0x11111111,0);
  InitTransRnd(trans,4);
  Addr2 = 0x40000231;
  Sequence('w', Addr2,trans, "in4",0,0x11111111,0); 
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",0,0x11111111,0);
  InitTransRnd(trans,4);
  Sequence('r', Addr2,trans, "in4",0,0x11111111,0);
  Addr1 = 0x00000236;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",1,0x33333333,0);
  Addr1 = 0x10000230;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",2,0x11111111,0);
  Addr1 = 0x00000236;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",1,0x33333333,0);
  Addr1 = 0x10000230;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",2,0x11111111,0);
  Addr1 = 0x00000236;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",1,0x33333333,0);
  Addr1 = 0x50000239;
  Sequence('w', Addr1,trans, "wr8",0,0x22222222,0);
  Addr1 = 0x50000F38;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "i16",1,0x33333333,0);
  Addr1 = 0x00000236;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",1,0x33333333,0);
  Addr1 = 0x50000F38;
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "i16",1,0x33333333,0);
  Addr1 = 0x00000131;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",0,0x55555555,0);
  Addr1 = 0x20000135;
  InitTransRnd(trans,4);
  Sequence('w', Addr1,trans, "wr4",0,0x55555555,0);
  Addr1 = 0x00000131;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",0,0x55555555,0);
  Addr1 = 0x20000135;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "wr4",0,0x55555555,0);
  Addr1 = 0x20000102;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "w16",1,0x55555555,0);
  Addr1 = 0x10000102;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "w16",0,0x55555555,0);
  Addr1 = 0x70000104;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "i16",2,0x55555555,0);
  Addr1 = 0x20000102;
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_2, 0x52, "WRD");
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "w16",1,0x55555555,0);
  Addr1 = 0x10000102;
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "w16",0,0x55555555,0);
  Addr1 = 0x70000104;
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "i16",2,0x55555555,0);
  Addr1 = 0x2000010B;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "i16",0,0x55555555,0);
  Addr1 = 0x10000132;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",1,0x55555555,0);
  Addr1 = 0x2000010B;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",0,0x55555555,0);
  Addr1 = 0x10000132;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "in4",1,0x55555555,0);
  Addr1 = 0x2000010B;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",0,0x55555555,0);
  
  Addr1 = 0x1000010C;
  InitTransRnd(trans,4);
  Sequence('w', Addr1,trans, "in4",1,0x55555555,0);
  Addr1 = 0x10000032;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",1,0x55555555,0);
  Addr1 = 0x1000010C;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "in4",1,0x55555555,0);
  Addr1 = 0x10000132;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",1,0x55555555,0);
  Addr1 = 0x2000010B;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",0,0x55555555,0);  
  Addr1 = 0x2000000B;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",0,0x55555555,0);
  Addr1 = 0x10000132;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",1,0x55555555,0);
  Addr1 = 0x2000010B;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",0,0x55555555,0);
  Addr1 = 0x2000000B;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",0,0x55555555,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_2, 0x42, "WRD");

  Addr1 = 0x10000100;
  InitTransRnd(trans,4);
  Sequence('w', Addr1,trans, "in4",2,0x55555555,0);
  Addr1 = 0x10000032;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",1,0x55555555,0);
  Addr1 = 0x10000100;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "in4",2,0x55555555,0);
  Addr1 = 0x10000032;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",1,0x55555555,0);

  Addr1 = 0x30000100;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "i16",2,0x55555555,0);
  Addr1 = 0x20000032;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",1,0x55555555,0);
  Addr1 = 0x30000100;
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "i16",2,0x55555555,0);
  Addr1 = 0x20000032;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",1,0x55555555,0);

  Addr1 = 0x50000100;
  InitTransRnd(trans,4);
  Sequence('w', Addr1,trans, "in4",2,0x55555555,0);
  Addr1 = 0x60000032;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",1,0x55555555,0);
  Addr1 = 0x50000100;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "in4",2,0x55555555,0);
  Addr1 = 0x60000032;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",1,0x55555555,0);

  Addr1 = 0x70000104;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "w16",2,0x55555555,0);
  Addr1 = 0x70000032;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",1,0x55555555,0);
  Addr1 = 0x70000104;
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "w16",2,0x55555555,0);
  Addr1 = 0x70000032;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",1,0x55555555,0);

  Addr1 = 0x50000100;
  InitTransRnd(trans,4);
  Sequence('w', Addr1,trans, "in4",2,0x55555555,0);
  Addr1 = 0x60000032;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "in8",0,0x55555555,0);
  Addr1 = 0x50000100;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "in4",2,0x55555555,0);
  Addr1 = 0x60000032;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "in8",0,0x55555555,0);

  Addr1 = 0x70000104;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "w16",2,0x55555555,0);
  Addr1 = 0x70000031;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",0,0x55555555,0);
  Addr1 = 0x70000104;
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "w16",2,0x55555555,0);
  Addr1 = 0x70000031;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",0,0x55555555,0);

  Addr1 = 0x60000124;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "w16",2,0x55555555,0);
  Addr1 = 0x70000232;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",0,0x55555555,0);
  Addr1 = 0x60000124;
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "w16",2,0x55555555,0);
  Addr1 = 0x70000232;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",0,0x55555555,0);

  Addr1 = 0x20000118;
  InitTransRnd(trans,16);
  Sequence('w', Addr1,trans, "i16",2,0x55555555,0);
  Addr1 = 0x10000031;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",0,0x55555555,0);
  Addr1 = 0x20000118;
  InitTransRnd(trans,16);
  Sequence('r', Addr1,trans, "i16",2,0x55555555,0);
  Addr1 = 0x10000031;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",0,0x55555555,0);

  Addr1 = 0x1000011C;
  InitTransRnd(trans,4);
  Sequence('w', Addr1,trans, "inc",2,0x55555555,0);
  Addr1 = 0x1000003E;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",0,0x55555555,0);
  Addr1 = 0x1000011C;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "inc",2,0x55555555,0);
  Addr1 = 0x1000003E;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",0,0x55555555,0);

  Addr1 = 0x20000158;
  InitTransRnd(trans,4);
  Sequence('w', Addr1,trans, "in4",2,0x55555555,0);
  Addr1 = 0x00000031;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",0,0x55555555,0);
  Addr1 = 0x20000158;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "in4",2,0x55555555,0);
  Addr1 = 0x00000031;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",0,0x55555555,0);

  Addr1 = 0x1000011A;
  InitTransRnd(trans,4);
  Sequence('w', Addr1,trans, "inc",1,0x55555555,0);
  Addr1 = 0x0000003E;
  InitTransRnd(trans,8);
  Sequence('w', Addr1,trans, "wr8",0,0x55555555,0);
  Addr1 = 0x1000011A;
  InitTransRnd(trans,4);
  Sequence('r', Addr1,trans, "in4",1,0x55555555,0);
  Addr1 = 0x0000003E;
  InitTransRnd(trans,8);
  Sequence('r', Addr1,trans, "wr8",0,0x55555555,0);

}
/*-- --================================ End ================================--*/
