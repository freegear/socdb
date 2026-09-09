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
--  File Name              : Arb4DyWrRdClkRat.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It performs memory access with different HBURST to dynamic memory
--           from Port3.
--           
--           TEST ID : MPMC_Arb4DyClkRatio_1
--
-- --=======================================================================--*/
/******************************************************************************/
/****************************** Arb4DyWrRdClkRat ******************************/
/******************************************************************************/
void Arb4DyWrRdClkRat()
{ 
  /*
     Summary: Arb4DyWrRdClkRat
     =========================
     This function tests the following functionality
     
     o  It performs memory access to dynamic memory from different ports with
        ClkRatio 1:2.

     o  It accesses the dynamic memory arbitrarily from different ports but
        at the same time and tests the functionality of buffer, arbiter and
        mem controller.
  */
  int i,k;
  int Data,size,chip,msize;
  int Bound,burst,LoBits,ClkRatio;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  unsigned long Addr;
  char debugstr[100];

  #if(INFILE == 3)
  /* Disable address mirror */
  C("TEST ID : MPMC_Arb4DyClkRatio_1");
  WriteData(MPMCControl, 0x00000001, "WRD");
  ClkRatio = 3;
  C("initialize sdrams and registers");
  TimingInit(2,6,8,0,6,5,4,7,7,0,2,3);
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
  WriteData(MPMCTrExBkOff, 0x0000000E, "WRD");
  WriteData(MPMCTrSR, 0x00000000, "WRD");
  WriteData(MPMCTrCR, 0x00000020, "WRD");
  /*  Set Bank 0 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank0");
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of bank1");
  StInitProc(1,1,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x3,0x3);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  C("Initialize registers of bank2");
  StInitProc(2,0,0,0,0,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x5,0x3);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  C("Initialize registers of bank3");
  StInitProc(3,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x7,0x3);
  WriteData(MPMCTrTES, 0x00000008, "WRD");
  Data = 0xAAAAAAAA; 
  for(i = 0; i < 200; i++)
  {
    chip = 5;
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
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  #elif (INFILE == 2)
   Data = 0xBBBBBBBB;
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x9);
  for(i = 0; i < 200; i++)
  {
    chip = 6;
    sprintf(debugstr,"Memory access from Port2 to Bank: %X", chip);
    C(debugstr);
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
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000000, ,0x00000008);
  #elif (INFILE == 1)
   HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x5);

  Data = 0x22222222;
  for(i = 0; i < 200; i++)
  {
    chip = 7 ;
    sprintf(debugstr,"Memory access from Port1 to Bank: %X", chip);
    C(debugstr);
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
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000000, ,0x00000008);
  #elif(INFILE == 0)
   HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x5);

  Data = 0x22222222;
  for(i = 0; i < 200; i++)
  {
    chip = 4 ;
    sprintf(debugstr,"Memory access from Port1 to Bank: %X", chip);
    C(debugstr);
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
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000000, ,0x00000008);
  #endif;
}
/*-- --=============================== End =================================--*/
