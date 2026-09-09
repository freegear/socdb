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
--  File Name              : Arb2HMastLockTest.c.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It performs the Multiple port access. 
--           
--           TEST ID : MPMC_Arb2HMastLockTest
--
-- --=======================================================================--*/
/******************************************************************************/
/***************************** Arb2HMastLockTest ******************************/
/******************************************************************************/
void Arb2HMastLockTest()
{ 
  /*
     Summary: Arb2HMastLockTest
     ==========================
     This function tests the following functionality

     o  It does the initialization of the registers and trick memory.

     o  Port3 performs memory access to the dynamic memory with HMASTLOCK
        enabled. And Port2 attempts to write into static memory(trickmemory).
        Since AHB is locked to Port3, Port2 is not supposed to write into 
        static memory. At the end of the test read the static memory from Port3
        whether the data has been altered or not.
        
  */
  int i,k;
  int Data,size,chip, msize,csel, LoBits,Bound;
  int burst;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  unsigned long Addr;
  char debugstr[100];

  #if (INFILE == 3) 
  C("TEST ID : MPMC_Arb2HMastLockTest");
  /* Disable address mirror */
  WriteData(MPMCControl, 0x00000001, "WRD");
  SyncInitializeProc(3, 0, 2, 3, 0, 0,
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

  WriteData(MPMCTrExBkOff, 0x00000006, "WRD");

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

  Data = 0xAAAAAAAA; 
  C("Initialise the trickmemory:CS2");
  AHBWriteMem(2, 0x0, 200, Data);
  WaitLoop(0x5);
  WriteData(MPMCTrTES, 0x00000008, "WRD");
  /* selection of chip */
  for(csel = 4; csel < 8; csel++)
  {
     if(csel == 4)
       msize = 1;
     else if(csel == 5)
       msize = 2;
     else if(csel == 6)
       msize = 1;
     else if(csel == 7)
       msize = 1;
     i = 0;
     /* indicates type of burst*/
     for (burst = 0; burst < 8; burst++)
     {
        /* selection of size */
        for(size = 0;size < 3; size++)
        {
          C("Access from Port3 which has locked the bus");
          chip = csel;
          Addr = rand() & 0x000003FC;
          i = i + 1;
          LoBits = Addr & 0x03FF;
          Bound  = LoBits + 400;
          if (Bound > 1024)
            Addr = Addr - 400;
          Addr = Addr | (chip << 28);
          Data = 0x11111111;
          if( sizetype[size]== "BYTE")
          {
            debug_info(" Byte Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "HWRD")
          {
            debug_info(" Halfword Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "WRD")
          {
            debug_info(" Word Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data);
          }
        } /* end of size*/
      } /* end of csel*/
    }  /*end of burst */
    C("Perform Idle and Busy transfers with HMASTLOCK high");
    HSA(0x40000000, NSEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x22222222);
    HSA(0x40000004, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x22222223);
    HSA(0x40000008, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x22222224);
    HSA(0x4000000C, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x22222225);
    HSA(0x40000010, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x22222226);
    HSA(0x40000014, IDLE, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x11111111);
    HSA(0x40000014, NSEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x22222227);
    HSA(0x40000018, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x22222228);
    HSA(0x4000001C, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x22222229);
    HSA(0x40000020, IDLE, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x11111111);
    HSA(0x40000020, NSEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x2222222A);
    HSA(0x40000024, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSW(,0x2222222B);
    C("Read data back with IDLE inserted");
    HSA(0x40000000, NSEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x22222222, ,0xFFFFFFFF);
    HSA(0x40000004, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x22222223, ,0xFFFFFFFF);
    HSA(0x40000008, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x22222224, ,0xFFFFFFFF);
    HSA(0x4000000C, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x22222225, ,0xFFFFFFFF);
    HSA(0x40000010, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x22222226, ,0xFFFFFFFF);
    HSA(0x40000014, IDLE, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x11111111, ,0xFFFFFFFF);
    HSA(0x40000014, NSEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x22222227, ,0xFFFFFFFF);
    HSA(0x40000018, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x22222228, ,0xFFFFFFFF);
    HSA(0x4000001C, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x22222229, ,0xFFFFFFFF);
    HSA(0x40000020, IDLE, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x11111111, ,0xFFFFFFFF);
    HSA(0x40000020, NSEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x2222222A, ,0xFFFFFFFF);
    HSA(0x40000024, SEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,);
    HSR(,0x2222222B, ,0xFFFFFFFF);

  Data = 0xAAAAAAAB;
  C("Read the data from the st mem to verify that Port2 has not done any access");
  HSA(0x20000000, NSEQ, INCR,OK,WRD, , 0x1,0x1 , , , ,); 
  HSR(,0xAAAAAAAA, ,0xFFFFFFFF);
  for(i = 0; i < 199; i++)
  {
     HSR(,Data, , 0xFFFFFFFF);
     Data = Data + 1;
  }
  
  WriteData(MPMCTrTES, 0x00000008, "WRD");
  #elif(INFILE == 2)
  Data = 0xBBBBBBBB;
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x10);
  for (burst = 0; burst < 8; burst++)
  {
     msize = 2;
       /* selection of size */
     for(size = 0;size < 3; size++)
     {
       C("Access from Port2 which is trying to perform memory write to CS2");
       chip = 2;
       Addr = 0x0000000;
       i = i + 1;
       LoBits = Addr & 0x01FF;
       Bound  = LoBits + 400;
       if (Bound > 1024)
         Addr = Addr - 400;
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
     } /*  end of size */
   } /*  end of burst */
  WaitLoop(3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);

  #endif;
}
/*-- --=============================== End =================================--*/
