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
--  File Name              : Arb2StWrRd.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It performs the Multiple port access. 
--           
--           TEST ID : MPMC_Arb2St_1
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************** Arb2StWrRd **********************************/
/******************************************************************************/
void Arb2StWrRd()
{ 
  /*
     Summary: Arb2StWrRd
     ===================
     This function tests the following functionality

     o  It does the initialization of the registers and trick memory.

     o This test performs single data write with different types of size
       and read the data back to check the data integrity from Port3 and Port2.

     o It also does the multiple data write with different size depending on the
       the burst type and reads the data back from Port3 and Port2.

  */
  int i,k;
  int Data,size,chip, msize;
  int burst;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  unsigned long Addr;
  char debugstr[100];

  #if (INFILE == 3)
  C("TEST ID : MPMC_Arb2St_1");
  /* Disable address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrExBkOff, 0x00000007, "WRD");
  
  /* Write from Port0 to all memory chips with diff sizes and read it back */

  C("Initialize registers of bank0 and TrickMem0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,0,0,0,0x1,0x1,0x2,0x3,0x4,0x2,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x1,0x1,0x2,0x3,0x4,0x2,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of bank1 and TrickMem1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x1,0x1,0x2,0x3,0x4,0x1,0x2);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x1,0x1,0x2,0x3,0x4,0x1,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of bank2 and TrickMem2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,0,0,0x1,0x1,0x2,0x2,0x3,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x1,0x1,0x2,0x2,0x3,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of bank3 and TrickMem3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,1,0,1,1,0,0x1,0x2,0x2,0x2,0x3,0x2,0x3);
  TrickMemInit(3,1,0,0,1,0,1,1,0,0x1,0x2,0x2,0x2,0x3,0x2,MPMCTrMEMBData[3],
               0x0);

  WriteData(MPMCTrTES, 0x00000008, "WRD");
  Data = 0xAAAAAAAA; 
  for(i = 0; i < 200; i++)
  {
    chip = rand() % 2;
    msize = 1;
    Addr = rand() & 0x000000FC;
    chip = chip << 28;
    Addr = Addr | chip;
    burst = rand() % 8;
    size = rand() % 3;
    if(sizetype[size] == "BYTE")
    {
      C("Memory access from Port3");
      debug_info(" Byte Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
     else if(sizetype[size] == "HWRD")
    {
      C("Memory access from Port3");
      debug_info(" Halfword Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
    else if(sizetype[size] == "WRD")
    {
      C("Memory access from Port3");
      debug_info(" Word Transfer ");
      BurstWrRd(chip,burst,Addr,size,msize,Data);
    }
  }
  WriteData(MPMCTrTES, 0x00000008, "WRD");
  #elif(INFILE == 2)
  Data = 0xBBBBBBBB;
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x9);
   for(i = 0; i < 200; i++)
   {
    chip = rand() % 2;
    chip = chip + 2;
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
       if (chip == 2)
       {
         C("Poll for busy bit");
         HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
         HPO(,0x00000000, ,0x00000003);
         WaitLoop(0x3);
         WriteData(MPMCTrMEMT_2, 0x51, "WRD");
         BurstWrRd(chip,burst,Addr,size,msize,Data);
         C("Poll for busy bit");
         HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
         HPO(,0x00000000, ,0x00000003);
         WaitLoop(0x3);
         WriteData(MPMCTrMEMT_2, 0x41,"WRD");
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
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  #endif;
}
/*-- --=============================== End =================================--*/
