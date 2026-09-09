/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2001-2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Arb2DyStWrRd.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It tests the functionality of controller when there is
--           memory accesses from multiple ports.            
--
--           TEST ID : MPMC_Arb2DySt_1
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* Arb2DyStWrRd *******************************/
/******************************************************************************/
void Arb2DyStWrRd()
{
  /*
     Summary: Arb2DyStWrRd
     =====================
     It performs the following functionality
 
     o  It performs memory access to dynamic as well as static memory from 
        different ports.

     o This test performs single data write with different types of size
       and read the data back to check the data integrity from different ports.

     o It also does the multiple data write with different size depending on the
       the burst type and reads the data back from different ports.
  */
  int i,k,temp;
  int Data,size,csel,chip, msize;
  int Bound,burst,LoBits;
  int caslat0,caslat1,caslat2,caslat3;
  int raslat0,raslat1,raslat2,raslat3;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  int trans[128];
  unsigned long Addr;
  char debugstr[100];

  #if (INFILE == 3)
    C("TEST ID : MPMC_Arb2DyStWrRd_1");
    WriteData(MPMCControl, 0x00000001, "WRD");
    C("Initialize SDRAM");
    TimingInit(2,5,8,0,5,2,0,7,7,0,2,3);
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

    SyncInitializeProc(3, 0, 2, 3, 0, 0,
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
    WriteData(MPMCTrExBkOff, 0x00000004, "WRD");

    C("Program Bank0");
    MPMCTrMEMBData[0] = 0x00000000;
    StInitProc(0,0,0,0,0,0,0,0,0,0x1,0x1,0x1,0x5,0x3,0x3,0x1);
    TrickMemInit(0,0,0,0,0,0,0,0,0,0x1,0x1,0x1,0x5,0x3,0x3,MPMCTrMEMBData[0],
                 0x0);
    /* Set Bank 1 Memory Type as SRAM (16 bits width) */
    C("Program Bank1");
    MPMCTrMEMBData[1] = 0x00000000;
    StInitProc(1,1,0,0,1,0,0,1,0,0x2,0x3,0x3,0x5,0x7,0x1,0x1);
    TrickMemInit(1,1,0,0,1,0,0,1,0,0x2,0x3,0x3,0x5,0x7,0x1,MPMCTrMEMBData[1],
                 0x0);

    /* Set Bank 2 Memory Type as SRAM (32 bits width) */
    C("Program Bank2");
    MPMCTrMEMBData[2] = 0x00000000;
    StInitProc(2,2,0,0,1,0,1,0,0,0x2,0x3,0x3,0x5,0x7,0x0,0x1);
    TrickMemInit(2,2,0,0,1,0,1,0,0,0x2,0x3,0x3,0x5,0x7,0x0,MPMCTrMEMBData[2],
                 0x0);

    /* Set Bank 3 Memory Type as SRAM (16 bits width) */
    C("Program Bank3");
    MPMCTrMEMBData[3] = 0x00000000;
    StInitProc(3,1,0,0,1,0,1,1,0,0x2,0x3,0x3,0x5,0x7,0x5,0x1);
    TrickMemInit(3,1,0,0,1,0,1,1,0,0x2,0x3,0x3,0x5,0x7,0x5,MPMCTrMEMBData[3],
                 0x0);

    WriteData(MPMCTrMEMT_2, 0x52, "WRD");
    C("Reprogram the refresh counter");
    WriteData(MPMCDyRef, 0x4, "WRD");
    WaitLoop(0x5);
    WriteData(MPMCTrTES, 0x00000008, "WRD");
    C("Access from port3 to bank0 of chip select6");
    for(i = 0; i < 100; i++)
    {
      Addr = rand() & 0x0000FFFC;   
      Addr = Addr | 0x40000000;
      Addr = Addr & 0xFFFFFDFF;
      ReadData(Addr, 0x00000000, 0x00000000, "WRD");
    }
    for(i = 0; i < 150; i++)
    {
      sprintf(debugstr,"Iteration No:%X from Port3",i);
      C(debugstr);
      chip = rand() % 7;
      /* If chip selected is even then select the odd chip select */
      if((chip % 2)==0)
        chip = chip + 1; 
      sprintf(debugstr,"Bank: %X", chip);
      C(debugstr);
      if(chip == 1)
        msize = 0;
      else if(chip == 3)
        msize = 1;
      else if(chip == 5)
        msize = 2; 
      else if(chip == 7)
        msize = 1;
      if(chip < 4)
        Addr = rand() & 0x000001FC;
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
   for(csel = 1; csel < 8; csel=csel+2)
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
  }
    WriteData(MPMCTrTES, 0x00000000, "WRD");
  #elif (INFILE == 1)
    WaitLoop(0x10);
  /* Wait till MPMCTrTES[3] is set */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008, , ,Poll_TES);
  WaitLoop(0x8);
  C("Access from port2 to bank1 of chip select6");
  for(i = 0; i < 50; i++)
  {
    Addr = rand() & 0x0000FFFC;
    Addr = Addr | 0x40000200;
    ReadData(Addr, 0x00000000, 0x00000000, "WRD");
  }

  Data = 0x22222222;
  for(i = 0; i < 150; i++)
  {
    sprintf(debugstr,"Iteration No:%X from Port2",i);
    C(debugstr);
    chip = rand() % 7;
    if((chip % 2) == 1)
      chip = chip + 1;
    sprintf(debugstr,"Bank: %X", chip);
    C(debugstr);
    if(chip == 0)
      msize = 0;
    else if(chip == 2)
      msize = 2;
    else if(chip == 4)
      msize = 1;
    else if(chip == 6)
      msize = 1;
    if(chip < 4)
      Addr = rand() & 0x000001FC;
    else
    {
      Addr = rand() & 0x00FFFFFC;
      LoBits = Addr & 0x03FF;
      Bound  = LoBits + 400;
      if (Bound > 1024)
        Addr = Addr - 400;
      Addr = Addr | (chip << 28);
    }
    burst = rand() % 8;
    size = rand() % 3;
    if(sizetype[size] == "BYTE")
    {
      debug_info(" Byte Transfer ");
      WaitLoop(0x3);
      BurstWrRd(chip,burst,Addr,size,msize,Data);
      WaitLoop(0x3);
    }
    else if(sizetype[size] == "HWRD")
    {
      debug_info(" Halfword Transfer ");
      if (chip == 2)
      {
         C("Poll for busy bit");
         WaitLoop(0x3);
         BurstWrRd(chip,burst,Addr,size,msize,Data);
         C("Poll for busy bit");
         WaitLoop(0x3);
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
  for(csel = 0; csel < 7; csel= csel+2)
  {
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
 }
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000000, , 0x00000008);
  #endif;
}
/*-- --=============================== End =================================--*/
