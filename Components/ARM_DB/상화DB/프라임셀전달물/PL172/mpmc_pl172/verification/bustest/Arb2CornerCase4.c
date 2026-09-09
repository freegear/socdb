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
-- File Name              : Arb2CornerCase4.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           Multiple port test with sync flash and sram combinations
--
--           TEST ID : MPMC_Arb2CornerCase4_1
--
-- --=======================================================================--*/
/******************************************************************************/
/***************************** Arb2CornerCase4 ********************************/
/******************************************************************************/
void Arb2CornerCase4()
{
  /*
     Summary:Arb2CornerCase4()
     =========================
     This test performs memory access to syncflash as well as to static memory
     from 2 different ports

     o Initialize sdram and sram memory models.
    
     o Perform memory access to sync flash

     o Check the data integrity
  */ 
  int Data,size,chip, msize,burst;
  unsigned long Addr;
  char debugstr[100];
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};


  int32 Mask[] = {0x0000FFFF,0xFFFF0000};
  int i,k,ClkRatio;
  ClkRatio = 0;
  Data = 0xBBBBBBBB;
  #if (INFILE== 3)
    C("TEST ID : MPMC_Arb2CornerCase4_1");
    WriteData(MPMCControl, 0x00000001, "WRD");
    WriteData(MPMCTrExBkOff, 0x00000003, "WRD");
    C("Initialize SDRAMs and configure the registers");

    StInitProc(0,1,0,0,1,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);
    StInitProc(2,1,0,0,1,0,0,0,1,0x1,0x1,0x1,0x1,0x1,0x1,0x1);
    TimingInit(2,5,8,0,5,2,0,7,7,0,2,3);
    SyncFlashSdramInitProc(3, 0, 2, 3, 0, 1,
                           2, 0, 2, 2, 0, 0,
                           3, 0, 3, 2, 0, 0,
                           2, 0, 3, 3, 0, 0,
                           2,1,1,0,0,0,0,0,2,1,1,
                           0,2,1,0,1,1,1,0,2,1,0,
                           0,0,3,0,0,1,1,0,4,1,1,
                           1,2,1,0,1,1,1,0,2,1,0,
                           11,12,13,12,
                           0,
                           ClkRatio);

    /* Set Bank 1 Memory Type as SRAM (16 bits width) */
    WriteData(MPMCTrTES, 0x00000008, "WRD");
    Addr = 0x40000420;
    Data = 0x00002222; 
    for(i = 0; i < 4; i++)
    {
       C("Perform memory access to syncflash");
       WriteData(Addr, Data++, "HWRD");
       C("Wait till ISM is ready to take next command");
       WaitLoop(500);
       Addr = Addr + 2;
    }
    C("Enable buffers before doing the read operation");
    WriteData(MPMCDyConfig0, 0x148C0290, "WRD");
    WaitLoop(0x4);
    Addr = 0x40000420;
    Data = 0x00002222;
    HSA(Addr,NSEQ,INCR, OK, HWRD);
    HSR(,Data++, ,0x0000FFFF);
    for(i = 1; i < 4; i++)
    {
      k = i % 2;
      HSR(,Data++, ,Mask[k]);
    }
  #elif (INFILE == 2)
    HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
    HPO(,0x00000008, ,0x00000008);
    WaitLoop(0x9);
    for(i = 0; i < 20; i++)
    {
      chip = 0;
      sprintf(debugstr,"Accessing Bank: %X from Port2", chip);
      C(debugstr);
      msize = 1;
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
  #endif;
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
}
/*-- --=============================== End =================================--*/
