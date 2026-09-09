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
-- File Name              : Arb4IdleBusy.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--         This test performs the memory access with different types of HTRANS  
--         from port3.
--
--         TEST ID : MPMC_Arb4IdleBusy_1
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* Arb4IdleBusy *******************************/
/******************************************************************************/
void Arb4IdleBusy()
{
  /* 
    Summary: Arb4IdleBusy
    =====================
    This test performs the following functionality
   
    o  It generates vectors  with different HTRANS to access memory from all
       ports.

    o  It accesses the static and dynamic memory arbitrarily from different
       ports and with different HTRANS type but at the same time and tests the
       functionality of buffer and arbiter and mem controller.
  */
  int i, j, k, Address, BusyCnt, temp,chip, csel;
  int32 Addr;
  int trans[128];
  char PrintStr[128];
  char* SizeStr[5] = {"WRD","HWRD", "BYTE","HWRD", "WRD"};
  int32 QWStart;
  int LoBits, Bound,Busy,idlest=1;
  int32 data;

  #if(INFILE == 3)
  C("TEST ID : MPMC_Arb4IdleBusy_1");
  /* Disable address mirror bit */
  WriteData(MPMCControl, 0x00000001, "WRD");
  TimingInit(2,5,8,0,5,3,0,7,7,0,2,3);
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
  WriteData(MPMCTrExBkOff, 0x0000000F, "WRD");
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank0 and TrickMem0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of bank1 and TrickMem1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x4,0x5,0x6,0x7,0x9,0x3,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Initialize registers of bank2 and TrickMem2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,0,0,0,0,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);
  TrickMemInit(2,0,0,0,0,0,1,0,0,0x4,0x5,0x6,0x7,0x9,0x5,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  C("Initialize registers of bank3 and TrickMem3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  TrickMemInit(3,2,0,0,1,0,1,1,0,0x4,0x5,0x6,0x7,0x9,0x7,MPMCTrMEMBData[3],
               0x0);

  /* Set MPMCTrTES[3] */
  WriteData(MPMCTrTES, 0x00000008, "WRD");
  data = 0x33333333;
  C("INCR4 burst termination and rebuild");

  for (k = 0; k < 3; k ++)
  {
    for (i = 1; i < 4; i ++)
    {
      C("Memory access from Port3");
      /* INCR4 Burst termination due to degranting */
      chip = rand() % 2;
      chip = chip + 6;
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
      temp = 0;
      Address = Address + (4*temp);

      /* Check whether the burst will cross a 1KB boundary */
      /* Change the address if it crosses a 1KB boundary */
      LoBits = Address & 0x03FF;
      Bound  = LoBits + 16;
      if (Bound > 1024)
        Address = Address - 16;

      if (Busy == 1)
      {
        /* Random number of BUSY transfers */
        BusyCnt = (rand() % 30) + 1;

        /* NSEQ-SEQ-BUSY sequence */
        WordTrans(Address, i, INCR4, data, BusyCnt, i-1, 1, 0, 0,0);
      }
      else
      {
        /* NSEQ-SEQ sequence */
        WordTrans(Address, i, INCR4, data, 0, 0, 0, 0, 0,0);
      }
      /* Random number of idle cycles during degranting */
      j = (rand() % 16) + 1;
      WrWaitLoop(j);
      data = data + i;
      if (Busy == 1)
      {
        /* Rebuild of the burst after getting grant again */
        WordTrans(Address + (4*i), 4 - i, INCR4, data, 0, 0, 0, 0, 0,0);
      }
      else
        WordTrans(Address + (4*i), 4 - i, INCR, data, 0, 0, 0, 0, 0,0);
      data = 0x33333333;
      /* Check data through reads */
      WordRd(Address, 4, INCR4, data,idlest);
    }
  }
  for (csel = 6; csel < 8; csel++)
  {
  for(i = 0; i < 10; i++)
  {
     C("Test1");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test2");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",1,0x77777777,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",1,0x77777777,0);
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
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",0,0x22222222,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",0,0x22222222,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test5");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",1,0x11111111,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",1,0x11111111,0);
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
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",0,0xBBBBBBBB,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",0,0xBBBBBBBB,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test8");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",1,0x99999999,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",1,0x99999999,0);
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
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",1,0xAAAAAAAA,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",1,0xAAAAAAAA,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("TestC");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"inc",0,0x11111111,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"inc",0,0x11111111,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("TestD");
     Addr = rand() & 0x000001FF;
     InitTransRnd(trans, 4);
     Addr = Addr | (csel << 28);
     Sequence('w',Addr,trans,"in4",0,0x33333333,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",0,0x33333333,0);
  }
}
  
  /* Reset MPMCTrTES[3] */
 HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
 HPO(,0x00000000, ,0x00000000);
 #elif(INFILE == 2)
  /*  Poll the Idle bits to know the status of the ports */
  HSA(MPMCTrTES,NSEQ,INCR,OK,WRD, , , , , ,);
  HPO(,0x00000008, ,0x00000008);

  C("Access CS4 with BUSY insertion and with BYTE");
  HSA(0x400001F1, NSEQ, INCR4, OK, BYTE);
  HSW(,0x22222222);
  HSA(0x400001F2, BUSY, INCR4, OK, BYTE);
  HSW(,0x222222AA);
  HSA(0x400001F2, SEQ, INCR4, OK, BYTE);
  HSW(,0x22222223);
  HSA(0x400001F3, SEQ, INCR4, OK, BYTE);
  HSW(,0x22222224);
  HSA(0x400001F4, SEQ, INCR4, OK, BYTE);
  HSW(,0x22222225);

  HSA(0x400001F1, NSEQ, INCR4, OK, BYTE);
  HSR(,0x22222222, ,0x0000FF00);
  HSA(0x400001F2, SEQ, INCR4, OK, BYTE);
  HSR(,0x22232222, ,0x00FF0000);
  HSA(0x400001F3, SEQ, INCR4, OK, BYTE);
  HSR(,0x24222222, ,0xFF000000);
  HSA(0x400001F4, BUSY, INCR4, OK, BYTE);
  HSR(,0x24222222, ,0x000000FF);
  HSA(0x400001F4, SEQ, INCR4, OK, BYTE);
  HSR(,0x22222225, ,0x000000FF);

  C("Access CS4 with BUSY insertion and with HWRD");
  HSA(0x400001A2, NSEQ, INCR, OK, HWRD);
  HSW(,0x22222222);
  HSA(0x400001A4, SEQ, INCR, OK, HWRD);
  HSW(,0x22222223);
  HSA(0x400001A6, SEQ, INCR, OK, HWRD);
  HSW(,0x22222224);
  HSA(0x400001A8, BUSY, INCR, OK, HWRD);
  HSW(,0xAAAAAAAA);
  HSA(0x400001A8, SEQ, INCR, OK, HWRD);
  HSW(,0x22222225);
  HSA(0x400001AA, SEQ, INCR, OK, HWRD);
  HSW(,0x22222226);
  HSA(0x400001AC, SEQ, INCR, OK, HWRD);
  HSW(,0x22222227);

  HSA(0x400001A2, NSEQ, INCR, OK, HWRD);
  HSR(,0x22222222, ,0xFFFF0000);
  HSA(0x400001A4, BUSY, INCR, OK, HWRD);
  HSR(,0x222A2222, ,0x0000FFFF);
  HSA(0x400001A4, SEQ, INCR, OK, HWRD);
  HSR(,0x22222223, ,0x0000FFFF);
  HSA(0x400001A6, SEQ, INCR, OK, HWRD);
  HSR(,0x22242222, ,0xFFFF0000);
  HSA(0x400001A8, SEQ, INCR, OK, HWRD);
  HSR(,0x22222225, ,0x0000FFFF);
  HSA(0x400001AA, SEQ, INCR, OK, HWRD);
  HSR(,0x22262222, ,0xFFFF0000);
  HSA(0x400001AC, SEQ, INCR, OK, HWRD);
  HSR(,0x22222227, ,0x0000FFFF);

  data =0x44444444;
  C("INCR8 burst termination and rebuild");

  for (k = 0; k < 3; k++)
  {
     for (i = 1; i < 5; i ++)
     {
        /* INCR8 burst termination due to degranting */

        C("Memory access from Port2");
        chip = rand() % 2;
        chip = chip + 4;
        if(chip < 4)
        {
           Address = rand() & 0x000000FC;
           Address = Address | chip << 28;
        }
        else
        {
          Address = rand() & 0x0FFFFFFC;
          Address = Address | chip << 28;
        }
        temp = 0;
        Address = Address + (4*temp);

        /* Check whether the burst will cross a 1KB boundary */
        /* Change the address if it crosses a 1KB boundary */
        LoBits = Address & 0x03FF;
        Bound  = LoBits + 32;
        if (Bound > 1024)
          Address = Address - 32;

        if (Busy == 1)
        {
           /* Random number of BUSY transfers */
           BusyCnt = (rand() % 30) + 1;

           /* NSEQ-SEQ-BUSY sequence */
           WordTrans(Address, i, INCR8, data, BusyCnt, i-1, 1, 0, 0,0);
        }
        else
         {
           /* NSEQ-SEQ sequence */
           WordTrans(Address, i, INCR8, data, 0, 0, 0, 0, 0,0);
        }
        /* Random number of idle cycles during degranting */
        j = (rand() % 16) + 1;
        WrWaitLoop(j);
        data = data + i;
        if (Busy == 1)
        {
           /* Rebuild of the burst after getting grant again */
           WordTrans(Address + (4*i), 8 - i, INCR8, data, 0, 0, 0, 0, 0,0);
        }
        else
           WordTrans(Address + (4*i), 8 - i, INCR, data, 0, 0, 0, 0, 0,0);

        data = 0x44444444;
        /* Check data through reads */
        WordRd(Address, 8, INCR8, data,idlest);
     }
  }
  C("Access CS4 with BUSY insertion and with BYTE");
  HSA(0x400001F1, NSEQ, INCR4, OK, BYTE);
  HSW(,0x22222222);
  HSA(0x400001F2, BUSY, INCR4, OK, BYTE);
  HSW(,0x222222AA);
  HSA(0x400001F2, SEQ, INCR4, OK, BYTE);
  HSW(,0x22222223);
  HSA(0x400001F3, SEQ, INCR4, OK, BYTE);
  HSW(,0x22222224);
  HSA(0x400001F4, SEQ, INCR4, OK, BYTE);
  HSW(,0x22222225);

  HSA(0x400001F1, NSEQ, INCR4, OK, BYTE);
  HSR(,0x22222222, ,0x0000FF00);
  HSA(0x400001F2, SEQ, INCR4, OK, BYTE);
  HSR(,0x22232222, ,0x00FF0000);
  HSA(0x400001F3, SEQ, INCR4, OK, BYTE);
  HSR(,0x24222222, ,0xFF000000);
  HSA(0x400001F4, BUSY, INCR4, OK, BYTE);
  HSR(,0x24222222, ,0x000000FF);
  HSA(0x400001F4, SEQ, INCR4, OK, BYTE);
  HSR(,0x22222225, ,0x000000FF);

  C("Access CS4 with BUSY insertion and with HWRD");
  HSA(0x400001A2, NSEQ, INCR, OK, HWRD);
  HSW(,0x22222222);
  HSA(0x400001A4, SEQ, INCR, OK, HWRD);
  HSW(,0x22222223);
  HSA(0x400001A6, SEQ, INCR, OK, HWRD);
  HSW(,0x22222224);
  HSA(0x400001A8, BUSY, INCR, OK, HWRD);
  HSW(,0xAAAAAAAA);
  HSA(0x400001A8, SEQ, INCR, OK, HWRD);
  HSW(,0x22222225);
  HSA(0x400001AA, SEQ, INCR, OK, HWRD);
  HSW(,0x22222226);
  HSA(0x400001AC, SEQ, INCR, OK, HWRD);
  HSW(,0x22222227);

  HSA(0x400001A2, NSEQ, INCR, OK, HWRD);
  HSR(,0x22222222, ,0xFFFF0000);
  HSA(0x400001A4, BUSY, INCR, OK, HWRD);
  HSR(,0x222A2222, ,0x0000FFFF);
  HSA(0x400001A4, SEQ, INCR, OK, HWRD);
  HSR(,0x22222223, ,0x0000FFFF);
  HSA(0x400001A6, SEQ, INCR, OK, HWRD);
  HSR(,0x22242222, ,0xFFFF0000);
  HSA(0x400001A8, SEQ, INCR, OK, HWRD);
  HSR(,0x22222225, ,0x0000FFFF);
  HSA(0x400001AA, SEQ, INCR, OK, HWRD);
  HSR(,0x22262222, ,0xFFFF0000);
  HSA(0x400001AC, SEQ, INCR, OK, HWRD);
  HSR(,0x22222227, ,0x0000FFFF);
  WaitLoop(3);

  
  for (csel = 4; csel < 5; csel++)
  {
    sprintf(PrintStr,"MSIZE is  = %s",SizeStr[csel]);
  C(PrintStr);
  for(i = 0; i < 10; i++)
  {
     C("Test1");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test2");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",1,0x77777777,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",1,0x77777777,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test3");
     Addr = rand() & 0x000001FC;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"inc",2,0x33333333,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"inc",2,0x33333333,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test4");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",0,0x22222222,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",0,0x22222222,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test5");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",1,0x11111111,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",1,0x11111111,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test6");
     Addr = rand() & 0x000001FC;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",2,0x33333333,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",2,0x33333333,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test7");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"in8",0,0xBBBBBBBB,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"in8",0,0xBBBBBBBB,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test8");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",1,0x99999999,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",1,0x99999999,0);
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
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",1,0xAAAAAAAA,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",1,0xAAAAAAAA,0);
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
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",0,0x33333333,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",0,0x33333333,0);
  }
 }
  /* Reset MPMCTrTES[2] */
  WriteData(MPMCTrTES, 0x00000000, "WRD");

  #elif (INFILE == 1)
    HSA(MPMCTrTES,NSEQ,INCR,OK,WRD);
    HPO(,0x00000008, ,0x00000008);

      data = 0x55555555;
  for (k = 0; k < 3; k ++)
  {
    for (i = 1; i < 3; i ++)
    {
      /* WRAP16 burst termination due to degranting */

      C("Memory access from Port1");
      chip = rand() % 2;
      chip = chip + 2;
      Address = 0x00000000;
      Address = Address | chip << 28;
      QWStart   = Address;
      temp = 0;
      Address = Address + (4*temp);

      if (Busy == 1)
      {
        /* Random number of BUSY transfers */
        BusyCnt = (rand() % 30) + 1;

        /* NSEQ-SEQ-BUSY sequence */
        WordTrans(Address, i, WRAP16, data, BusyCnt, i-1, 1, 0, 0,0);
      }
      else
      {
        /* NSEQ-SEQ sequence */
        WordTrans(Address, i, WRAP16, data, 0, 0, 0, 0, 0,0);
      }

      /* Random number of idle cycles during degranting */
      j = (rand() % 16) + 1;
      WrWaitLoop(j);
      data = data + i;
      /* Rebuild of the burst after getting grant again */
      if (temp + i <= 16)
      {
        /* Burst was interrupted before the address wrapped around */
        WordTrans(Address + (4*i), 16-temp-i, WRAP16, data,0,0, 0, 0, 0,0);
        WordTrans(Address - (4*temp), temp, WRAP16, data, 0, 0, 0, 0, 0,0);
      }
      else
       {
        /* Burst was interrupted after the address wrapped around */
        WordTrans(QWStart+4*(temp+i-16), (16 - i),WRAP16, data, 0, 0, 0,0,0,0);
      }
      data = 0x55555555;
      /* Check data through reads */
      WordRd(Address, 16, WRAP16, data,idlest);
    }
  }
  WaitLoop(3);

  
  for (csel = 2; csel < 4; csel++)
  {
    sprintf(PrintStr,"MSIZE is  = %s",SizeStr[csel]);
  C(PrintStr);
  for(i = 0; i < 10; i++)
  {
     C("Test1");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test2");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",1,0x77777777,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",1,0x77777777,0);
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
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",0,0x22222222,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",0,0x22222222,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test5");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",1,0x11111111,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",1,0x11111111,0);
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
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",0,0xBBBBBBBB,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",0,0xBBBBBBBB,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test8");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",1,0x99999999,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",1,0x99999999,0);
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
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",1,0xAAAAAAAA,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",1,0xAAAAAAAA,0);
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
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",0,0x33333333,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",0,0x33333333,0);
  }
}
  
  C("Access CS3 with BUSY insertion and with BYTE");
  HSA(0x300001F1, NSEQ, INCR, OK, BYTE);
  HSW(,0x22222222);
  HSA(0x300001F2, BUSY, INCR, OK, BYTE);
  HSW(,0x222222AA);
  HSA(0x300001F2, SEQ, INCR, OK, BYTE);
  HSW(,0x22222223);
  HSA(0x300001F3, SEQ, INCR, OK, BYTE);
  HSW(,0x22222224);
  HSA(0x300001F4, SEQ, INCR, OK, BYTE);
  HSW(,0x22222225);
  HSA(0x300001F5, SEQ, INCR, OK, BYTE);
  HSW(,0x22222226);
  HSA(0x300001F6, SEQ, INCR, OK, BYTE);
  HSW(,0x22222227);
  
  HSA(0x300001F1, NSEQ, INCR, OK, BYTE);
  HSR(,0x22222222, ,0x0000FF00);
  HSA(0x300001F2, SEQ, INCR, OK, BYTE);
  HSR(,0x22232222, ,0x00FF0000);
  HSA(0x300001F3, SEQ, INCR, OK, BYTE);
  HSR(,0x24222222, ,0xFF000000);
  HSA(0x300001F4, SEQ, INCR, OK, BYTE);
  HSR(,0x22222225, ,0x000000FF);
  HSA(0x300001F5, SEQ, INCR, OK, BYTE);
  HSR(,0x22222622, ,0x0000FF00);
  HSA(0x300001F6, BUSY, INCR, OK, BYTE);
  HSR(,0x22BB0000, ,0x00FF0000);
  HSA(0x300001F6, SEQ, INCR, OK, BYTE);
  HSR(,0x22272222, ,0x00FF0000);

  C("Access CS3 with BUSY insertion and with HWRD");
  HSA(0x300001A2, NSEQ, INCR, OK, HWRD);
  HSW(,0x22222222);
  HSA(0x300001A4, SEQ, INCR, OK, HWRD);
  HSW(,0x22222223);
  HSA(0x300001A6, SEQ, INCR, OK, HWRD);
  HSW(,0x22222224);
  HSA(0x300001A8, BUSY, INCR, OK, HWRD);
  HSW(,0xAAAAAAAA);
  HSA(0x300001A8, SEQ, INCR, OK, HWRD);
  HSW(,0x22222225);
  HSA(0x300001AA, SEQ, INCR, OK, HWRD);
  HSW(,0x22222226);
  HSA(0x300001AC, SEQ, INCR, OK, HWRD);
  HSW(,0x22222227);
  
  HSA(0x300001A2, NSEQ, INCR, OK, HWRD);
  HSR(,0x22222222, ,0xFFFF0000);
  HSA(0x300001A4, BUSY, INCR, OK, HWRD);
  HSR(,0x222A2222, ,0x0000FFFF);
  HSA(0x300001A4, SEQ, INCR, OK, HWRD);
  HSR(,0x22222223, ,0x0000FFFF);
  HSA(0x300001A6, SEQ, INCR, OK, HWRD);
  HSR(,0x22242222, ,0xFFFF0000);
  HSA(0x300001A8, SEQ, INCR, OK, HWRD);
  HSR(,0x22222225, ,0x0000FFFF);
  HSA(0x300001AA, SEQ, INCR, OK, HWRD);
  HSR(,0x22262222, ,0xFFFF0000);
  HSA(0x300001AC, SEQ, INCR, OK, HWRD);
  HSR(,0x22222227, ,0x0000FFFF);

  /* Reset MPMCTrTES[1] */
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  #elif(INFILE == 0)
   /* Poll the Idle bits to know the status of the ports */
  HSA(MPMCTrTES,NSEQ,INCR,OK,WRD, , , , , ,);
  HPO(,0x00000008, ,0x00000008);

  data = 0x66666666;
  C("INCR16 burst termination and rebuild");
  Busy = 1;
  for (k = 0; k < 3; k++)
  {
    for (i = 1; i < 5; i ++)
    {
      /* INCR16 burst termination due to degranting */

      C("Memory access from Port0");
      chip = rand() % 2;
      Address = rand() & 0x000000FC;
      Address = Address | chip << 28;
      temp = 0;
      Address = Address + (4*temp);

      if (Busy == 1)
      {
        /* Random number of BUSY transfers */
        BusyCnt = (rand() % 30) + 1;

        /* NSEQ-SEQ-BUSY sequence */
        WordTrans(Address, i, INCR16, data, BusyCnt, i-1, 1, 0, 0,0);
      }
      else
      {
        /* NSEQ-SEQ sequence */
        WordTrans(Address, i, INCR16, data, 0, 0, 0, 0, 0,0);
      }

      /* Random number of idle cycles during degranting */
      j = (rand() % 16) + 1;
      WrWaitLoop(j);
      data = data + i;
       if (Busy == 1)
      {
        /* Rebuild of the burst after getting grant again */
        WordTrans(Address + (4*i), 16 - i, INCR16, data, 0, 0, 0, 0, 0,0);
      }
      else
        WordTrans(Address + (4*i), 16 - i, INCR, data, 0, 0, 0, 0, 0,0);

      data = 0x66666666;
      /* Check data through reads */
      WordRd(Address, 16, INCR16, data,idlest);
    }
  }
  WaitLoop(3);
  
  for (csel = 0; csel < 2; csel++)
  {
    sprintf(PrintStr,"MSIZE is  = %s",SizeStr[csel]);
  C(PrintStr);
  for(i = 0; i < 10; i++)
  {
     C("Test1");
     Addr = rand() & 0x000001FF;
     Addr = Addr | (csel << 28);
     if (chip == 0)
     {              
        C("Poll for busy bit");
        WaitLoop(0x3);
        HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
        HPO(,0x00000000, ,0x00000003);
        WaitLoop(0x3);
        WriteData(MPMCTrMEMT_0, 0x51, "WRD");
        InitTransRnd(trans, 16);
        Sequence('w',Addr,trans,"i16",0,0xBBBBBBBB,0);

        InitTransRnd(trans, 16);
        Sequence('r',Addr,trans,"i16",0,0xBBBBBBBB,0);
        C("Poll for busy bit");
        WaitLoop(0x3);
        HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
        HPO(,0x00000000, ,0x00000003); 
        WaitLoop(0x3);
        WriteData(MPMCTrMEMT_0, 0x41,"WRD");
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
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"i16",1,0x77777777,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"i16",1,0x77777777,0);
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
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",0,0x22222222,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",0,0x22222222,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test5");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 16);
     Sequence('w',Addr,trans,"w16",1,0x11111111,0);

     InitTransRnd(trans, 16);
     Sequence('r',Addr,trans,"w16",1,0x11111111,0);
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
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",0,0xBBBBBBBB,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",0,0xBBBBBBBB,0);
  }

  for(i = 0; i < 10; i++)
  {
     C("Test8");
     Addr = rand() & 0x000001FE;
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 8);
     Sequence('w',Addr,trans,"wr8",1,0x99999999,0);

     InitTransRnd(trans, 8);
     Sequence('r',Addr,trans,"wr8",1,0x99999999,0);
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
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"wr4",1,0xAAAAAAAA,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"wr4",1,0xAAAAAAAA,0);
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
     Addr = Addr | (csel << 28);
     InitTransRnd(trans, 4);
     Sequence('w',Addr,trans,"in4",0,0x33333333,0);

     InitTransRnd(trans, 4);
     Sequence('r',Addr,trans,"in4",0,0x33333333,0);
  }
}
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  #endif;
}
/*-- --================================ End ================================--*/
