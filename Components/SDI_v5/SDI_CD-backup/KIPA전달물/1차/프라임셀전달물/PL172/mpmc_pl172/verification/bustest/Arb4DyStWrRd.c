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
--  File Name              : Arb4DyStWrRd.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It performs the Multiple port access to both static and dynamic
--           memory. 
--           
--           TEST ID : MPMC_Arb4DyStWrRd_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* Arb4DyStWrRd *********************************/
/******************************************************************************/
void Arb4DyStWrRd()
{ 
  /*
     Summary: Arb4DyStWrRd
     =====================
     This function tests the following functionality
   
     o  It performs memory access to dynamic as well as static memory from
        different ports.

     o  This test case accesses the static and dynamic memory arbitrarily
        from different ports but at the same time and tests the functionality
        of buffer and arbiter and mem controller.

     o  It performs memory access from all ports and tests the functionality of
        buffer, arbiter and mem controller.
  */
  int i,k;
  int Data,size,chip,msize,temp;
  int Bound,burst,LoBits,ClkRatio;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  unsigned long Addr;
  char debugstr[100];

  #if (INFILE == 3)
  C("TEST ID : MPMC_Arb4DySt_1");
  /* Disable address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  ClkRatio = 0;
  C("initialize sdrams and registers");
  TimingInit(2,6,8,0,6,5,0,7,7,0,2,3);
  SyncInitializeProc(
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     0,1,0,0,1,1,1,0,2,0,0,
                     0,0,0,0,0,1,1,0,3,0,0,
                     0,0,1,0,0,1,1,0,3,1,1,
                     0,0,2,0,1,1,1,0,4,1,1,
                     11,11,12,14,
                     0,
                     ClkRatio
                    ); 
  WriteData(MPMCTrExBkOff, 0x0000000A, "WRD");
  /*  Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank0");
  StInitProc(0,2,0,0,1,0,1,1,0,0x1,0x1,0x7,0x5,0x8,0x5,0x8);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of bank1");
  StInitProc(1,1,0,0,1,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Initialize registers of bank2");
  StInitProc(2,0,0,0,0,0,1,1,0,0x1,0x1,0x8,0x5,0x8,0x1,0x1);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  C("Initialize registers of bank3");
  StInitProc(3,2,0,0,0,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);

  WriteData(MPMCTrTES, 0x00000008, "WRD");
  Data = 0xAAAAAAAA; 
  for(i = 0; i < 100; i++)
  {
    chip = (rand() % 2) + 6;
    if(chip == 6)
      msize = 1;
    else
      msize = 2;
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
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  #elif(INFILE == 2)
   Data = 0xBBBBBBBB;
  WaitLoop(0x9);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WriteData(0x7FFFF00C, 0x11111111, "WRD");
  ReadData(0x7FFFF00C, 0x11111111, MaskALL, "WRD");
  for(i = 0; i < 100; i++)
  {
    temp = (rand() % 2) + 4;
    sprintf(debugstr,"Memory access from Port2 to Bank: %X", chip);
    C(debugstr);
    if(temp == 4)
    {
      Addr = rand() & 0x00FFFFFC;
      msize = 2;
      LoBits = Addr & 0x03FF;
      Bound  = LoBits + 400;
      if (Bound > 1024)
        Addr = Addr - 400;
      Addr = Addr | 0x40000000;
      chip = 4;
    }
    else
    {
      Addr = rand() & 0x000000FC;
      msize = 2;
      chip = 3;
    }
    msize = 1;
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
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000000, ,0x00000008);
  #elif(INFILE == 1)
  WaitLoop(0x5);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);

  WaitLoop(0x3);
  WriteData(0x4FFFFFFC, 0x44444444, "WRD");
  ReadData(0x4FFFFFFC, 0x44444444,MaskALL, "WRD");

  Data = 0x22222222;
  for(i = 0; i < 100; i++)
  {
    temp = rand() % 2;
    if(temp == 0)
    {
      chip = 2;
      Addr = rand() & 0x000001FC;
      msize = 0;
    }
    else
    {
      chip = 5;
      Addr = rand() & 0x00FFFFFC;
      msize = 1;
      LoBits = Addr & 0x03FF;
      Bound  = LoBits + 400;
      if (Bound > 1024)
        Addr = Addr - 400;
      Addr = Addr | 0x50000000;
    }
    sprintf(debugstr,"Memory access from Port1 to Bank: %X", chip);
    C(debugstr);
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
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000000, ,0x00000008);
  #elif(INFILE == 0)
   WaitLoop(0x6);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);

  WriteData(0x20352130, 0x22222222, "WRD");
  ReadData(0x20352130, 0x22222222,MaskALL, "WRD");
  WriteData(0x30352130, 0x33333333, "WRD");
  ReadData(0x30352130, 0x33333333,MaskALL, "WRD");
  WriteData(0x4FFFFFFC, 0x44444444, "WRD");
  ReadData(0x4FFFFFFC, 0x44444444,MaskALL, "WRD");
  WriteData(0x50000000, 0x55555555, "WRD");
  ReadData(0x50000000, 0x55555555,MaskALL, "WRD");
  Data = 0x22222222;
  for(i = 0; i < 100; i++)
  {
    chip = rand() % 2;
    if(chip == 0)
      msize = 2;
    else
      msize = 1;
    sprintf(debugstr,"Memory access from Port0 to Bank: %X", chip);
    C(debugstr);
    msize = 2;
    Addr = rand() & 0x000000FC;
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
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000000, ,0x00000008);
  #endif; 
}
/*-- --=============================== End =================================--*/
