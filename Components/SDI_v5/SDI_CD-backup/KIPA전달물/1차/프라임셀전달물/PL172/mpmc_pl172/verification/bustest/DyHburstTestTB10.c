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
-- File Name              : DyHburstTestTB10.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the HBURST accesses on the dynamic memory.
--           This test uses tbench10.
--
--           TEST ID : MPMC_DyHburstTestTB10_1
--
-- --=======================================================================--*/
/******************************************************************************/
/***************************** DyHburstTestTB10 *******************************/
/******************************************************************************/
void DyHburstTestTB10(void)
{
  /*
    Summary: DyHburstTestTB10
    =========================
    This test performs the following functionalities:
   
    o This test performs single data write with different types of size 
      and read the data back to check the data integrity.
 
    o It also does the multiple data write with different size depending on the 
       the burst type and reads the data back.

  */
  int i,k,size,csel,chip,burst,msize;
  char debugstr[100];
  unsigned long chpsel[8] = {0,1,2,3,4,5,6,7};
  int caslat0, caslat1, caslat2, caslat3;
  int raslat0, raslat1,raslat2, raslat3;
  int ClkRatio;
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  int32 Mask[] = {0x0000FFFF,0xFFFF0000};
  unsigned long Addr, Data,LoBits,Bound;
 
  C("TEST ID : MPMC_DyHburstTestTB10_1");
  WriteData(MPMCTrTES, 0x00000000, "WRD");

  C("Disable Address mirror");
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

  ClkRatio = 0;
  C("Initialize SDRAMs and configure the registers");
  TimingInit(2,5,8,0,5,2,0,7,7,0,2,3);
  SyncFlashSdramInitProc(3, 0, caslat0, raslat0, 0, 1,
                         2, 0, caslat1, raslat1, 0, 0,
                         3, 0, caslat2, raslat2, 0, 0,
                         2, 0, 3, 3, 0, 0,
                         2,1,1,0,0,0,0,0,2,1,1,
                         0,2,1,0,1,1,1,0,2,1,0,
                         0,0,3,0,0,1,1,0,4,1,1,
                         1,2,1,0,1,1,1,0,2,1,0,
                         11,12,13,12,
                         0,
                         ClkRatio);
  Addr = 0x40000420;
  Data = 0x00002222;
  C("Disable Clock Enable and keep the Clock Control high");
  WriteData(MPMCDyCntl,0x00004002, "WRD");
  for(i = 0; i < 8; i++)
  {
     C("Perform memory access to syncflash");
     WriteData(Addr, Data++, "HWRD");
     C("Wait till ISM is ready to take next command");
     WaitLoop(500);
     Addr = Addr + 2;
  }
  C("Enable buffers before doing the read operation");
  MPMCDisable();
  WriteData(MPMCDyConfig0, 0x148C0290, "WRD");
  MPMCEnable();
  Addr = 0x40000420;
  Data = 0x00002222;
  HSA(Addr,NSEQ,INCR, OK, HWRD);
  HSR(,Data++, ,0x0000FFFF);
  for(i = 1; i < 8; i++)
  {
    k = i % 2;
    HSR(,Data++, ,Mask[k]);
  }
  WaitLoop(500);
  /* indicates type of burst */ 
  for (burst = 0; burst < 8; burst++)   
  {
    /* selection of chip */ 
    for(csel = 5; csel < 8; csel++)  
    {
      if(csel == 4)
        msize = 1;
      else if(csel == 5)
        msize = 2;
      else if(csel == 6)
        msize = 1;
      else if(csel == 7)
        msize = 1;

     /* selection of size */
     for(size = 0;size < 3; size++)
     {
       chip = csel;
       Addr = rand() & 0x0FFFFFFC;
       LoBits = Addr & 0x03FF;
       Bound  = LoBits + 400;
       if (Bound > 1024)
         Addr = Addr - 400;
       Addr = Addr | (chip << 28);  
       Data = 0x11111111;
       if( sizetype[size]== "BYTE")           
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
     } /* end of size */
   } /* end of csel */
 }  /*end of burst */
} /* end of main */
/*-- --================================ End ================================--*/
