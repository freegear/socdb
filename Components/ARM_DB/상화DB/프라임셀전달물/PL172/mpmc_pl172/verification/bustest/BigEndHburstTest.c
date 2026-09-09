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
-- File Name              : BigEndHburstTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           It tests the functionality of controller for big endian.
--
--           TEST ID : MPMC_BigEndHburst_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* BigEndHburstTest *****************************/
/******************************************************************************/
void BigEndHburstTest()
{
  /* 
     Summary : BigEndHburstTest
     ==========================
     It does the following functionality,

     o  This test performs all types of memory accesses with big endian and 
        checks the data integrity.

     o  It also inserts busy and idle cycles in between the burst and verifies
        for the data integrity.
  */
  int i,size,csel,chip,burst;
  char debugstr[100];
  int ClkRatio,msize;
  int trans[128];
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;

  C("TEST ID : MPMC_BigEndHburst_1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");

  C("Disable Address mirror");
  WriteData(MPMCControl, 0x00000001, "WRD");
  ClkRatio = 0;
  C("Initialize SDRAMs and configure the registers");
  TimingInit(2,5,8,0,5,2,0,7,0,0,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     1,
                     ClkRatio);
  C("Configuring the Memory Banks and the MPMC");
  WriteData(MPMCTrExBkOff, 0x00000010, "WRD");
  MPMCTrMEMBData[0] = 0x00000000;
  C("Set Bank 0 Memory Type as SRAM (32 bits width)");
  StInitProc(0,2,0,0,1,0,1,1,0,0x1,0x2,0x3,0x4,0x6,0x0,0x1);
  TrickMemInit(0,2,0,0,1,0,1,1,0,0x1,0x2,0x3,0x4,0x6,0x0,MPMCTrMEMBData[0],
               0x0);

  C("Set Bank 1 Memory Type as SRAM (16 bits width)");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x1,0x2,0x3,0x4,0x6,0x1,0x1);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x1,0x2,0x3,0x4,0x6,0x1,MPMCTrMEMBData[1],
               0x0);

  C("Set Bank 2 Memory Type as SRAM (8 bits width)");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,1,1,0,0x1,0x2,0x3,0x4,0x6,0x2,0x0);
  TrickMemInit(2,0,0,0,0,0,1,1,0,0x1,0x2,0x3,0x4,0x6,0x2,MPMCTrMEMBData[2],
               0x0);

  C("Set Bank 3 Memory Type as SRAM (32 bits width)");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,0,0,0,0x1,0x2,0x3,0x4,0x6,0x4,0x0);
  TrickMemInit(3,2,0,0,1,0,0,0,0,0x1,0x2,0x3,0x4,0x6,0x4,MPMCTrMEMBData[3],
               0x0);
  Data = 0x33333333;
  ENDIANNESS = 1;
  HSEN(DISABLE);
  for(chip = 0; chip < 8; chip++)
  {
    for(burst = 0; burst < 8; burst++)
    {
      for(size = 0; size < 3; size++)
      {
        if(chip == 0)
          msize = 2;
        else if(chip == 1)
          msize = 1;
        else if(chip == 2)
          msize = 0;
        else if(chip == 3)
          msize = 2;
        else if(chip == 4)
          msize = 1;
        else if(chip == 5)
          msize = 2;
        else if(chip == 6)
          msize = 1;
        else
          msize = 1;
        Addr = rand() & 0x000000FC; 
        if (chip == 1 && size == 0)
        {
           C("Poll for busy bit");
           WaitLoop(0x3);
           HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
           HPO(,0x00000000, ,0x00000003);
           WaitLoop(0x3);
           WriteData(MPMCTrMEMT_1, 0x51, "WRD");
           BigBurstWrRd(chip,burst,Addr,size,msize,Data);
           C("Poll for busy bit");
           WaitLoop(0x3);
           HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
           HPO(,0x00000000, ,0x00000003);
           WaitLoop(0x3);
           WriteData(MPMCTrMEMT_1, 0x41,"WRD");
         }
        else if (chip == 3 && (size == 1 || size == 0))
        {
           C("Poll for busy bit");
           WaitLoop(0x3);
           HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
           HPO(,0x00000000, ,0x00000003);
           WaitLoop(0x3);
           WriteData(MPMCTrMEMT_3, 0x52, "WRD");
           BigBurstWrRd(chip,burst,Addr,size,msize,Data);
           C("Poll for busy bit");
           WaitLoop(0x3);
           HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
           HPO(,0x00000000, ,0x00000003);
           WaitLoop(0x3);
           WriteData(MPMCTrMEMT_3, 0x42,"WRD");
         }
         else
           BigBurstWrRd(chip,burst,Addr,size,msize,Data);
      }
    }
  }

  C("INCR16, MW=32,HSIZE=BYTE");
  for(i = 0; i < 10; i++)
  {
     C("Test1");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,1);
  }
  C("INCR16, MW=32,HSIZE=HWRD");

  for(i = 0; i < 10; i++)
  {
     C("Test2");
     Addr = rand() & 0x000001FE;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",1,0x77777777,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",1,0x77777777,1);
  }

  C("INCR16, MW=32,HSIZE=WRD");

  for(i = 0; i < 10; i++)
  {
     C("Test3");
     Addr = rand() & 0x000001FC;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",2,0x33333333,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",2,0x33333333,1);
  }

  C("WRAP16, MW=32,HSIZE=BYTE");

  for(i = 0; i < 10; i++)
  {
     C("Test4");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",0,0x22222222,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",0,0x22222222,1);
  }

  C("WRAP16, MW=32,HSIZE=HWRD");

  for(i = 0; i < 10; i++)
  {
     C("Test5");
     Addr = rand() & 0x000001FE;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",1,0x11111111,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",1,0x11111111,1);
  }

  C("WRAP16, MW=32,HSIZE=WRD");

  for(i = 0; i < 10; i++)
  {
     C("Test6");
     Addr = rand() & 0x000001FC;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",2,0x33333333,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",2,0x33333333,1);
  }

  C("WRAP8, MW=32,HSIZE=BYTE");

  for(i = 0; i < 10; i++)
  {
     C("Test7");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",0,0xBBBBBBBB,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",0,0xBBBBBBBB,1);
  }

  C("WRAP8, MW=32,HSIZE=HWRD");

  for(i = 0; i < 10; i++)
  {
     C("Test8");
     Addr = rand() & 0x000001FE;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",1,0x99999999,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",1,0x99999999,1);
  }

  C("WRAP8, MW=32,HSIZE=WRD");

  for(i = 0; i < 10; i++)
  {
     C("Test9");
     Addr = rand() & 0x000001FC;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",2,0xEEEEEEEE,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",2,0xEEEEEEEE,1);
  }

  C("WRAP4, MW=32,HSIZE=WRD");

  for(i = 0; i < 10; i++)
  {
     C("TestA");
     Addr = rand() & 0x000001FC;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",2,0xBBBBBBBB,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",2,0xBBBBBBBB,1);
  }

  C("WRAP4, MW=32,HSIZE=HWRD");

  for(i = 0; i < 10; i++)
  {
     C("TestB");
     Addr = rand() & 0x000001FE;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",1,0xAAAAAAAA,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",1,0xAAAAAAAA,1);
  }

  C("WRAP4, MW=32,HSIZE=BYTE");

  for(i = 0; i < 10; i++)
  {
     C("TestC");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",0,0x11111111,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",0,0x11111111,1);
  }

  C("INCR4, MW=32,HSIZE=BYTE");

  for(i = 0; i < 10; i++)
  {
     C("TestD");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",0,0x33333333,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",0,0x33333333,1);
  }

  C("INCR4, MW=32,HSIZE=HWRD");

  for(i = 0; i < 10; i++)
  {
     C("TestE");
     Addr = rand() & 0x000001FE;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",1,0x22222222,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",1,0x22222222,1);
  }

  C("INCR4, MW=32,HSIZE=WRD");

  for(i = 0; i < 10; i++)
  {
     C("TestF");
     Addr = rand() & 0x000001FC;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",2,0x88888888,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",2,0x88888888,1);
  }

  C("INCR8, MW=32,HSIZE=WRD");

  for(i = 0; i < 10; i++)
  {
     C("Test10");
     Addr = rand() & 0x000001FC;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",2,0x77777777,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",2,0x77777777,1);
  }

  C("INCR8, MW=32,HSIZE=HWRD");

  for(i = 0; i < 10; i++)
  {
     C("Test11");
     Addr = rand() & 0x000001FE;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",1,0xCCCCCCCC,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",1,0xCCCCCCCC,1);
  }

  C("INCR8, MW=32,HSIZE=BYTE");

  for(i = 0; i < 10; i++)
  {
     C("Test12");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",0,0xFFFFFFFF,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",0,0xFFFFFFFF,1);
  }
  C("INCR16, MW=16,HSIZE=BYTE");

  for(i = 0; i < 10; i++)
  {
     C("Test13");
     Addr = rand() & 0x000001FF;
     Addr = Addr | 0x10000000;
     C("Poll for busy bit");
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x51, "WRD");
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,1);
     C("Poll for busy bit");
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x41,"WRD");
  }
  C("INCR16, MW=16,HSIZE=HWRD");
  for(i = 0; i < 10; i++)
  {
     C("Test14");
     Addr = rand() & 0x000001FE;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",1,0x77777777,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",1,0x77777777,1);
  }

  C("INCR16, MW=16,HSIZE=WRD");
  for(i = 0; i < 10; i++)
  {
     C("Test15");
     Addr = rand() & 0x000001FC;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",2,0x33333333,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",2,0x33333333,1);
  }

  C("WRAP16, MW=16,HSIZE=BYTE");
  for(i = 0; i < 10; i++)
  {
     C("Test16");
     Addr = rand() & 0x000001FF;
     Addr = Addr | 0x10000000;
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x51, "WRD");
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",0,0x22222222,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",0,0x22222222,1);
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x41,"WRD");
  }

  C("WRAP16, MW=16,HSIZE=HWRD");
  for(i = 0; i < 10; i++)
  {
     C("Test17");
     Addr = rand() & 0x000001FE;
     Addr = Addr | 0x10000000;
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x51, "WRD");
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",1,0x11111111,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",1,0x11111111,1);
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x41,"WRD");
  }

  C("WRAP16, MW=16,HSIZE=WRD");
  for(i = 0; i < 10; i++)
  {
     C("Test18");
     Addr = rand() & 0x000001FC;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",2,0x33333333,1);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",2,0x33333333,1);
  }

  C("WRAP8, MW=16,HSIZE=BYTE");
  for(i = 0; i < 10; i++)
  {
     C("Test19");
     Addr = rand() & 0x000001FF;
     Addr = Addr | 0x10000000;
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x51, "WRD");
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",0,0xBBBBBBBB,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",0,0xBBBBBBBB,1);
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x41,"WRD");
  }

  C("WRAP8, MW=16,HSIZE=HWRD");
  for(i = 0; i < 10; i++)
  {
     C("Test1A");
     Addr = rand() & 0x000001FE;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",1,0x99999999,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",1,0x99999999,1);
  }

  C("WRAP8, MW=16,HSIZE=WRD");
  for(i = 0; i < 10; i++)
  {
     C("Test1B");
     Addr = rand() & 0x000001FC;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",2,0xEEEEEEEE,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",2,0xEEEEEEEE,1);
  }

  C("WRAP4, MW=16,HSIZE=WRD");
  for(i = 0; i < 10; i++)
  {
     C("Test1C");
     Addr = rand() & 0x000001FC;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",2,0xBBBBBBBB,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",2,0xBBBBBBBB,1);
  }

  C("WRAP4, MW=16,HSIZE=HWRD");
  for(i = 0; i < 10; i++)
  {
     C("Test1D");
     Addr = rand() & 0x000001FE;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",1,0xAAAAAAAA,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",1,0xAAAAAAAA,1);
  }

  C("WRAP4, MW=16,HSIZE=BYTE");
  for(i = 0; i < 10; i++)
  {
     C("Test1E");
     Addr = rand() & 0x000001FF;
     Addr = Addr | 0x10000000;
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x51, "WRD");
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",0,0x11111111,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",0,0x11111111,1);
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x41, "WRD");
  }

  C("INCR4, MW=16,HSIZE=BYTE");
  for(i = 0; i < 10; i++)
  {
     C("Test1F");
     Addr = rand() & 0x000001FF;
     Addr = Addr | 0x10000000;
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x51, "WRD");
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",0,0x33333333,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",0,0x33333333,1);
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x41, "WRD");
  }

  C("INCR4, MW=16,HSIZE=HWRD");
  for(i = 0; i < 10; i++)
  {
     C("Test20");
     Addr = rand() & 0x000001FE;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",1,0x22222222,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",1,0x22222222,1);
  }

  C("INCR4, MW=16,HSIZE=WRD");
  for(i = 0; i < 10; i++)
  {
     C("Test21");
     Addr = rand() & 0x000001FC;
     Addr = Addr | 0x10000000;
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x51, "WRD");
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",2,0x88888888,1);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",2,0x88888888,1);
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x41, "WRD");
  }

  C("INCR8, MW=16,HSIZE=WRD");
  for(i = 0; i < 10; i++)
  {
     C("Test22");
     Addr = rand() & 0x000001FC;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",2,0x77777777,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",2,0x77777777,1);
  }

  C("INCR8, MW=16,HSIZE=HWRD");
  for(i = 0; i < 10; i++)
  {
     C("Test23");
     Addr = rand() & 0x000001FE;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",1,0xCCCCCCCC,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",1,0xCCCCCCCC,1);
  }

  C("INCR8, MW=16,HSIZE=BYTE");
  for(i = 0; i < 10; i++)
  {
     C("Test24");
     Addr = rand() & 0x000001FF;
     Addr = Addr | 0x10000000;
     InitTransRnd(trans, 8);
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x51, "WRD");
     Sequence('w',Addr,trans,"in8",0,0xFFFFFFFF,1);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",0,0xFFFFFFFF,1);
     WaitLoop(0x3);
     HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
     HPO(,0x00000000, ,0x00000003);
     WaitLoop(0x3);
     WriteData(MPMCTrMEMT_1, 0x41, "WRD");
  } 
  WriteData(MPMCTrTES, 0x00000008, "WRD");
}
/*-- --============================== End ==================================--*/
