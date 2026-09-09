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
-- File Name              : BusyInsertionTest.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This progam is to check the functionality of the controller when
--           busy and idle states are inserted during burst transfer 
--
--           TEST ID : MPMC_BusyInsertion_1
--
-- --=======================================================================--*/
/******************************************************************************/
/**************************** Busy Insertion Test *****************************/
/******************************************************************************/
void BusyInsertionTest(int Busy)
{
  /*
     Summary : Busy Insertion Test
     =============================
     This function verifies the following functionalities

     o  In this test, a sequence of Busy cycles and Idle are inserted in 
        a burst write of each burst type in any position.

     o  After the Busy cycles, the burst is rebuilt by using 
        suitable number of transfers with the same burst type. When the
        writes are completed the data is read back using the same type of burst.

  */

  int i, j, k, Address, BusyCnt, temp, csel;
  int LoBits, Bound, QWStart;
  int idlest;
  int32 Addr;
  unsigned byteset1[65536];
  unsigned byteset2[65536];
  char debugstr[100];
  int chip, bank, AddrMap, Row, Col, BankSel;

  int trans1[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans2[7] = {2,1,3,3,3,1,5};
  int trans3[12] = {2,3,3,1,1,3,3,3,1,3,0,5};
  int trans4[7] = {2,0,2,3,3,1,5};
  int trans5[10] = {2,1,2,1,1,3,1,3,1,5};
  int trans6[17] = {2,0,0,2,1,0,2,1,2,1,3,3,1,3,2,1,5};
  int trans7[29] = {2,3,0,2,3,3,1,3,1,3,3,3,3,1,1,1,1,3,1,3,1,3,3,3,1,1,3,1,5};
  int trans[128];
  int trans8[29] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans9[5] = {2,3,3,3,5};

  char PrintStr[128];
  char* SizeStr[7] = {"WRD","HWRD", "BYTE","HWRD", "WRD","HWRD","HWRD"};
  int32 data;
  C("TEST ID : MPMC_BusyInsertion_1");
  WriteData(MPMCControl, 0x00000001, "WRD");
  idlest = 0;
  C("Initialize SDRAMs");
  TimingInit(2,5,8,0,5,5,0,7,7,0,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initialize Bank0 registers and TrickMem0");
  StInitProc(0,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize Bank1 registers and TrickMem1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Initialize Bank2 registers and TrickMem2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,0,0,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  C("Initialize Bank3 registers and TrickMem3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  data = 0x44444444;

  C("INCR4 burst termination and rebuild");

  for (k = 0; k < 2; k ++) 
  {
    for (i = 1; i < 4; i ++)
    {
      
      C("INCR4 Burst termination due to degranting");

      /* Generate a random address and align it with a QW address */
      chip = rand() % 8;
      if(chip > 3)
      {
        Address = rand() & 0x0FFFFFFC;
        Address = Address | chip << 28; 
      }
      else 
      {
        Address = rand() & 0x000000FC;
        Address = Address | chip << 28;
      }

      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 16;
      if (Bound > 1024)
        Address = Address - 16;

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, INCR4, data, BusyCnt, i-1, 1, 0, 0,0);
      data = data + i;
      /* Rebuild of the burst after getting grant again */
      WordTrans(Address + (4*i), 4 - i, INCR4, data, 0, 0, 0, 0, 0,1);

      data = 0x44444444;
      /* Check data through reads */
      WordRd(Address, 4, INCR4, data,idlest);
    }
  }

  C("INCR burst termination and rebuild");

  for (k = 0; k < 2; k++) 
  {
    for (i = 1; i < 6; i ++)
    {
      C("INCR burst termination due to degranting"); 

      /* Generate a random address and align it with a QW address */
      chip = rand() % 8;
      if(chip > 3)
      {
        Address = rand() & 0x0FFFFFFC;
        Address = Address | chip << 28;
      }
      else 
      {
        Address = rand() & 0x000000FC;
        Address = Address | chip << 28; 
      }
      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 24;
      if (Bound > 1024)
        Address = Address - 24;

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, INCR, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      WordTrans(Address + (4*i), 6 - i, INCR, data, 0, 0, 0, 0, 0,1);

      data = 0x44444444;
      /* Check data through reads */
      WordRd(Address, 6, INCR, data,idlest);
    }
  }

  C("INCR8 burst termination and rebuild");

  for (k = 0; k < 2; k++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("INCR8 burst termination due to degranting");
      data = 0x55555555;
      /* Generate a random address and align it with a QW address */
      chip = rand() % 8;
      if(chip > 3)
      {
        Address = rand() & 0x0FFFFFFC;
        Address = Address | chip << 28;
      }
      else 
      {
        Address = rand() & 0x000000FC;
        Address = Address | chip << 28;
      }

      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 32;
      if (Bound > 1024)
        Address = Address - 32;

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;
      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, INCR8, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      WordTrans(Address + (4*i), 8 - i, INCR8, data, 0, 0, 0, 0, 0,1);
      data = 0x55555555;
      /* Check data through reads */
      WordRd(Address, 8, INCR8, data,idlest);
    }
  }

  C("INCR16 burst termination and rebuild");

  data = 0x66666666;
  for (k = 0; k < 2; k++)
  {
    for (i = 1; i < 3; i ++)
    {
      C("INCR16 burst termination due to degranting"); 

      /* Generate a random address and align it with a QW address */
      chip = rand() % 8;
      if(chip > 3)
      {
        Address = rand() & 0x0FFFFFFC;
        Address = Address | chip << 28;
      }
      else 
      {
        Address = rand() & 0x000000FC;
        Address = Address | chip << 28;
      }

      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = rand() % 4;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 64;
      if (Bound > 1024)
        Address = Address - 64;

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, INCR16, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      WordTrans(Address + (4*i), 16 - i, INCR16, data, 0, 0, 0, 0, 0,1);

      data = 0x66666666;
      /* Check data through reads */
      WordRd(Address, 16, INCR16, data,idlest);
    }
  }

  C("WRAP4 burst termination and rebuild");

  for (k = 0; k < 2; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("WRAP4 Burst termination due to degranting of the master");

      /* Generate a random address and align it with a QW address */
      chip = rand() % 8;
      Address =  0x00000000;
      Address = Address | chip << 28;
      QWStart   = Address;

      /* Starting address is W0, W1 or W2 depending on random value */
      temp = 0;
      Address = Address + (4*temp);

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, WRAP4, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if ((temp + i ) <= 4)
      {
        /* Burst was interrupted before the address wrapped around */

        WordTrans(Address + (4*i), 4-temp-i, WRAP4, data, 0, 0, 0, 0, 0,1);
        WordTrans(Address - (4*temp), temp, WRAP4, data, 0, 0, 0, 0, 0,1);
      }
      else
      {
        /* Burst was interrupted after the address wrapped around */
        WordTrans(QWStart + 4*(temp+i-4),(4 - i),WRAP4,data, 0, 0, 0,0,0,1);
      }

      data = 0x66666666;
      /* Check data through reads */
      WordRd(Address, 4, WRAP4, data,idlest);
    }
  }

  C("WRAP8 burst termination and rebuild");

  data = 0x77777777;
  for (k = 0; k < 2; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("WRAP8 burst termination due to degranting"); 

      /* Generate a random address and align it with a QW address */
      chip = rand() % 8;
      Address = 0x00000000;
      Address = Address | chip << 28;
      QWStart   = Address;

      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = 0;
      Address = Address + (4*temp);

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, WRAP8, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if ((temp + i ) <= 8)
      {
        /* Burst was interrupted before the address wrapped around */
        WordTrans(Address + (4*i), 8-temp-i, WRAP8, data, 0, 0, 0, 0, 0,1);
        WordTrans(Address - (4*temp), temp, WRAP8, data, 0, 0, 0, 0, 0,1);
      }
      else
      {
        /* Burst was interrupted after the address wrapped around */
        WordTrans(QWStart + 4*(temp+i-8),(8 - i),WRAP8,data, 0, 0, 0,0,0,1);
      }

      data = 0x77777777;
      /* Check data through reads */
      WordRd(Address, 8, WRAP8, data,idlest);
    }
  }

  C("WRAP16 burst termination and rebuild");

  for (k = 0; k < 2; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("WRAP16 burst termination due to degranting");

      /* Generate a random address and align it with a QW address */
      chip = rand() % 8;
      Address = 0x00000000;
      Address = Address | chip << 28;
      QWStart   = Address;

      /* Starting address is W0, W1, W2 or W3 depending on random value */
      temp = 0;
      Address = Address + (4*temp);

      /* Random number of BUSY transfers */
      BusyCnt = (rand() % 30) + 1;

      /* NSEQ-SEQ-BUSY sequence */
      WordTrans(Address, i, WRAP16, data, BusyCnt, i-1, 1, 0, 0,0);

      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if (temp + i <= 16)
      {
        /* Burst was interrupted before the address wrapped around */
        WordTrans(Address + (4*i), 16-temp-i,WRAP16, data, 0, 0, 0, 0, 0,1);
        WordTrans(Address - (4*temp), temp, WRAP16, data, 0, 0, 0, 0, 0,1);
      }
      else
      {
       /* Burst was interrupted after the address wrapped around */
     WordTrans(QWStart+4*(temp+i-16), (16 - i),WRAP16, data, 0, 0,0, 0,0,1);
      }

      data = 0x77777777;
      /* Check data through reads */
      WordRd(Address, 16, WRAP16, data,idlest);
    }
  }
  Address = MEM1_BASE + 0x1EE;
  C("Insert Busy for CS1");
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSW(,0x22222222);
  HSA(Address+1, BUSY, INCR, OK, BYTE);
  HSW(,0x33333333);
  HSA(Address+1, SEQ, INCR, OK, BYTE);
  HSW(,0x44444444);
  HSA(Address, NSEQ, INCR, OK, BYTE);
  HSR(, 0x22222222, ,0x00FF0000);
  HSA(Address+1, SEQ, INCR, OK, BYTE);
  HSR(,0x44444444, ,0xFF000000);

  Sequence('w',0x00000060, trans8,"inc",2,0x66666666,0);
  Sequence('r',0x00000060, trans8,"in4",2,0x66666666,0);
  Sequence('w',0x60000064, trans8,"inc",2,0x44444444,0);
  Sequence('w',0x00000062, trans8,"in4",1,0x55555555,0);
  Sequence('r',0x60000064, trans8,"in4",2,0x44444444,0);
  Sequence('r',0x00000062, trans8,"in4",1,0x55555555,0);

  InitTransRnd(trans,8);
  Sequence('w',0x000000AC, trans,"wr8",0,0xAAAAAAAA,0);
  Sequence('r',0x000000AC, trans,"wr8",0,0xAAAAAAAA,0);

  for (csel = 0; csel < 6; csel++)
  {
    sprintf(PrintStr,"MSIZE is  = %s",SizeStr[csel]);
  C(PrintStr); 
  for(i = 0; i < 10; i++)
  {
     C("Test1");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     if (csel == 3)
     {
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x52, "WRD");
       InitTransRnd(trans, 16);
       Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,0);

       InitTransRnd(trans, 16);
       Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,0);
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x42, "WRD");
     }
     else
     {
       InitTransRnd(trans, 16);
       Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,0);

       InitTransRnd(trans, 16);
       Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,0);
     }
  }

  for(i = 0; i < 10; i++)
  {
     C("Test2");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     if (csel == 3)
     {
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x52, "WRD");
       InitTransRnd(trans, 16);
       Sequence('w',Addr,trans,"i16",1,0x77777777,0);

       InitTransRnd(trans, 16);
       Sequence('r',Addr,trans,"i16",1,0x77777777,0);
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x42, "WRD");
     }
     else
     {
       InitTransRnd(trans, 16);
       Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,0);

       InitTransRnd(trans, 16);
       Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,0);
     }
  }

  for(i = 0; i < 10; i++)
  {
     C("Test3");
     Addr = rand() & 0x000001FC;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",2,0x33333333,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",2,0x33333333,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test4");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     if (csel == 3)
     {
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x52, "WRD");
       InitTransRnd(trans, 16);
       Sequence('w',Addr,trans,"w16",0,0x22222222,0);

       InitTransRnd(trans, 16);
       Sequence('r',Addr,trans,"w16",0,0x22222222,0);
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x42, "WRD");
     }
     else
     {
       InitTransRnd(trans, 16);
       Sequence('w',Addr,trans,"w16",0,0x22222222,0);

       InitTransRnd(trans, 16);
       Sequence('r',Addr,trans,"w16",0,0x22222222,0);
     }
  }

  for(i = 0; i < 10; i++)
  {
     C("Test5");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     if (csel == 3)
     {
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x52, "WRD");

       InitTransRnd(trans, 16);
       Sequence('w',Addr,trans,"w16",1,0x11111111,0);

       InitTransRnd(trans, 16);
       Sequence('r',Addr,trans,"w16",1,0x11111111,0);
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x42, "WRD");
    }
    else
    {
       InitTransRnd(trans, 16);
       Sequence('w',Addr,trans,"w16",1,0x11111111,0);

       InitTransRnd(trans, 16);
       Sequence('r',Addr,trans,"w16",1,0x11111111,0);
    }
  }

  for(i = 0; i < 10; i++)
  {
     C("Test6");
     Addr = rand() & 0x000001FC;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",2,0x33333333,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",2,0x33333333,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test7");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     if (csel == 3) 
     {
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x52, "WRD"); 

       InitTransRnd(trans, 8);
       Sequence('w',Addr,trans,"wr8",0,0xBBBBBBBB,0);

       InitTransRnd(trans, 8);
       Sequence('r',Addr,trans,"wr8",0,0xBBBBBBBB,0);
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x42, "WRD");
    }
    else
    {
       InitTransRnd(trans, 8);
       Sequence('w',Addr,trans,"wr8",0,0xBBBBBBBB,0);

       InitTransRnd(trans, 8);
       Sequence('r',Addr,trans,"wr8",0,0xBBBBBBBB,0);
    }
  }

  for(i = 0; i < 10; i++)
  {
     C("Test8");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     if (csel == 3)
     {
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x52, "WRD");
       InitTransRnd(trans, 8);
       Sequence('w',Addr,trans,"wr8",1,0x99999999,0);

       InitTransRnd(trans, 8);
       Sequence('r',Addr,trans,"wr8",1,0x99999999,0);
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x42, "WRD");
    }
    else
    {
       InitTransRnd(trans, 8);
       Sequence('w',Addr,trans,"wr8",1,0x99999999,0);

       InitTransRnd(trans, 8);
       Sequence('r',Addr,trans,"wr8",1,0x99999999,0);
    }
  }

  for(i = 0; i < 10; i++)
  {
     C("Test9");
     Addr = rand() & 0x000001FC;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",2,0xEEEEEEEE,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",2,0xEEEEEEEE,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("TestA");
     Addr = rand() & 0x000001FC;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",2,0xBBBBBBBB,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",2,0xBBBBBBBB,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("TestB");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     if (csel == 3)
     {
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x52, "WRD"); 
       InitTransRnd(trans, 4);
       Sequence('w',Addr,trans,"wr4",1,0xAAAAAAAA,0);

       InitTransRnd(trans, 4);
       Sequence('r',Addr,trans,"wr4",1,0xAAAAAAAA,0);
       WaitLoop(0x3);
       HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
       HPO(,0x00000000, ,0x00000003);
       WaitLoop(0x3);
       WriteData(MPMCTrMEMT_3, 0x42, "WRD");
     }
     else
     {
       InitTransRnd(trans, 4);
       Sequence('w',Addr,trans,"wr4",1,0xAAAAAAAA,0);

       InitTransRnd(trans, 4);
       Sequence('r',Addr,trans,"wr4",1,0xAAAAAAAA,0);
     }
  }

  for(i = 0; i < 10; i++)
  {
     C("TestC");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",0,0x11111111,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",0,0x11111111,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("TestD");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",0,0x33333333,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",0,0x33333333,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("TestE");
     Addr = rand() & 0x000001FE;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",1,0x22222222,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",1,0x22222222,0);
  }


  for(i = 0; i < 10; i++)
  {
     C("TestF");
     Addr = rand() & 0x000001FC;
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",2,0x88888888,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",2,0x88888888,0);
  }


  for(i = 0; i < 10; i++)
  {
     C("Test10");
     Addr = rand() & 0x000001FC;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",2,0x77777777,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",2,0x77777777,0);
  }


  for(i = 0; i < 10; i++)
  {
     C("Test11");
     Addr = rand() & 0x000001FE;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",1,0xCCCCCCCC,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",1,0xCCCCCCCC,0);
  }


  for(i = 0; i < 10; i++)
  {
     C("Test12");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",0,0xFFFFFFFF,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",0,0xFFFFFFFF,0);
  }
} 
  InitTransRnd(trans, 16);
  Sequence('w',0x1000011E,trans,"i16",0,0xBBBBBBBB,0);
  InitTransRnd(trans, 16);
  Sequence('r',0x1000011E,trans,"i16",0,0xBBBBBBBB,0);
  InitTransRnd(trans, 20);
  Sequence('w',0x60000002,trans,"inc",1,0x22222222,0);
  InitTransRnd(trans, 10);
  Sequence('r',0x60000002,trans,"inc",1,0x22222222,0);
  InitTransRnd(trans, 4);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x52, "WRD");
  Sequence('w',0x30000001,trans,"in4",0,0x33333333,0);
  InitTransRnd(trans, 4);
  Sequence('r',0x30000001,trans,"inc",0,0x33333333,0);
  InitTransRnd(trans, 4);
  Sequence('r',0x30000001,trans,"in4",0,0x33333333,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x42, "WRD");
  InitTransRnd(trans, 13);
  Sequence('w',0x40000004,trans,"inc",2,0x55555555,0);
  InitTransRnd(trans, 10);
  Sequence('r',0x40000004,trans,"in8",2,0x55555555,0);
  InitTransRnd(trans, 8);
  Sequence('w',0x5000000B,trans,"wr8",0,0x11111111,0);
  InitTransRnd(trans, 8);
  Sequence('r',0x5000000B,trans,"wr8",0,0x11111111,0);
  InitTransRnd(trans, 16);
  Sequence('w',0x00000008,trans,"w16",2,0x55555555,0);
  InitTransRnd(trans, 16);
  Sequence('r',0x00000008,trans,"w16",2,0x55555555,0);
  InitTransRnd(trans, 4);
  Sequence('w',0x10000004,trans,"wr4",2,0x55555555,0);
  InitTransRnd(trans, 4);
  Sequence('r',0x10000004,trans,"wr4",2,0x55555555,0);
  InitTransRnd(trans, 11);
  Sequence('w',0x00000011,trans,"inc",0,0xAAAAAAAA,0);
  InitTransRnd(trans, 11);
  Sequence('w',0x10000021,trans,"inc",0,0xAAAAAAAA,0);
  InitTransRnd(trans, 11);
  Sequence('w',0x40000021,trans,"inc",0,0xAAAAAAAA,0);
  InitTransRnd(trans, 11);
  Sequence('w',0x30000021,trans,"inc",0,0xAAAAAAAA,0);
  InitTransRnd(trans, 11);
  Sequence('r',0x00000011,trans,"inc",0,0xAAAAAAAA,0);
  InitTransRnd(trans, 11);
  Sequence('r',0x10000021,trans,"inc",0,0xAAAAAAAA,0);
  InitTransRnd(trans, 11);
  Sequence('r',0x40000021,trans,"inc",0,0xAAAAAAAA,0);
  InitTransRnd(trans, 10);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x52, "WRD"); 
  Sequence('r',0x30000021,trans,"inc",0,0xAAAAAAAA,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x42, "WRD");
  Sequence('w',0x50000022,trans5,"in4",1,0xBBBBBBBB,0);
  Sequence('w',0x10000022,trans4,"in4",1,0xBBBBBBBB,0);
  Sequence('w',0x20000022,trans5,"wr4",1,0xBBBBBBBB,0);
  Sequence('w',0x30000022,trans6,"in8",1,0xBBBBBBBB,0);
  Sequence('r',0x50000022,trans4,"in4",1,0xBBBBBBBB,0);
  Sequence('r',0x10000022,trans5,"in4",1,0xBBBBBBBB,0);
  Sequence('r',0x20000022,trans5,"wr4",1,0xBBBBBBBB,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x52, "WRD");
  Sequence('r',0x30000022,trans6,"in8",1,0xBBBBBBBB,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x42, "WRD");
  Sequence('w',0x40000024,trans5,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x10000020,trans5,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x50000028,trans5,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x3000002C,trans5,"inc",2,0xAAAAAAAA,0);
  Sequence('r',0x40000024,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('r',0x10000020,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('r',0x50000028,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('r',0x3000002C,trans4,"inc",2,0xAAAAAAAA,0);
  
  Sequence('w',0x70000021,trans1,"i16",0,0xAAAAAAAA,0);
  Sequence('w',0x10000022,trans1,"i16",1,0xAAAAAAAA,0);
  Sequence('w',0x60000023,trans1,"w16",0,0xAAAAAAAA,0);
  Sequence('w',0x30000020,trans1,"w16",0,0xAAAAAAAA,0);
  Sequence('r',0x70000021,trans2,"i16",0,0xAAAAAAAA,0);
  Sequence('r',0x10000022,trans1,"i16",1,0xAAAAAAAA,0);
  Sequence('r',0x60000023,trans2,"w16",0,0xAAAAAAAA,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x52, "WRD");
  Sequence('r',0x30000020,trans1,"w16",0,0xAAAAAAAA,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x42, "WRD");

  Sequence('w',0x00000022,trans2,"in4",1,0xCCCCCCCC,0);
  Sequence('w',0x10000022,trans2,"wr4",0,0xCCCCCCCC,0);
  Sequence('w',0x60000022,trans5,"inc",1,0xCCCCCCCC,0);
  Sequence('w',0x30000022,trans4,"in4",0,0xCCCCCCCC,0);
  Sequence('r',0x00000022,trans2,"in4",1,0xCCCCCCCC,0);
  Sequence('r',0x10000022,trans5,"wr4",0,0xCCCCCCCC,0);
  Sequence('r',0x60000022,trans5,"in4",1,0xCCCCCCCC,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x52, "WRD");
  Sequence('r',0x30000022,trans2,"inc",0,0xCCCCCCCC,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x42, "WRD");

  Sequence('w',0x70000022,trans7,"i16",1,0x11111111,0);
  Sequence('w',0x10000024,trans6,"in8",1,0x11111111,0);
  Sequence('w',0x20000022,trans5,"wr4",1,0x11111111,0);
  Sequence('w',0x30000028,trans8,"inc",0,0x11111111,0);
  Sequence('r',0x70000022,trans7,"i16",1,0x11111111,0);
  Sequence('r',0x10000024,trans6,"in8",1,0x11111111,0);
  Sequence('r',0x20000022,trans4,"wr4",1,0x11111111,0);
  Sequence('r',0x30000028,trans8,"inc",0,0x11111111,0);

  Sequence('w',0x30000027,trans9,"wr4",0,0x22222222,0);
  Sequence('r',0x40000024,trans4,"in4",2,0xAAAAAAAA,0);
  Sequence('w',0x30000027,trans7,"inc",0,0x22222222,0);
  Sequence('r',0x70000022,trans7,"i16",1,0x11111111,0);

  Sequence('w',0x00000026,trans7,"i16",1,0x44444444,0);
  Sequence('w',0x2000005C,trans6,"inc",1,0x44444444,0);
  Sequence('r',0x00000026,trans7,"i16",1,0x44444444,0);
  Sequence('r',0x2000005C,trans6,"in8",1,0x44444444,0);

  Sequence('w',0x10000027,trans6,"inc",0,0x22222222,0);
  Sequence('r',0x10000027,trans6,"in8",0,0x22222222,0);
  Sequence('w',0x6000005D,trans6,"wr8",0,0x22222222,0);
  Sequence('r',0x6000005D,trans6,"wr8",0,0x22222222,0);

  Sequence('w',0x50000027,trans2,"in4",0,0x22222222,0);
  Sequence('w',0x3000005C,trans6,"wr8",1,0x22222222,0);
  Sequence('r',0x50000027,trans2,"inc",0,0x22222222,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x52, "WRD");
  Sequence('r',0x3000005C,trans6,"wr8",1,0x22222222,0);
  WaitLoop(0x3);
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);
  WriteData(MPMCTrMEMT_3, 0x42, "WRD");
  Sequence('w',0x60000028,trans7,"inc",2,0x22222222,0);
  Sequence('w',0x30000059,trans8,"inc",0,0x22222222,0);
  Sequence('r',0x60000028,trans7,"inc",2,0x22222222,0);
  Sequence('r',0x30000059,trans8,"inc",0,0x22222222,0);

  Sequence('w',0x20000028,trans4,"in4",1,0x22222222,0);
  Sequence('w',0x3000005C,trans5,"wr4",2,0x22222222,0);
  Sequence('r',0x20000028,trans4,"in4",1,0x22222222,0);
  Sequence('r',0x3000005C,trans5,"wr4",2,0x22222222,0);

}
/*-- --================================ End ================================--*/
