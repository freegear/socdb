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
--  File Name              : Arb3StWrRd.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It performs the Multiple port access. 
--           
--           TEST ID : MPMC_Arb3StWrRd_1
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* Arb3StWrRd *********************************/
/******************************************************************************/
void Arb3StWrRd()
{ 
  /*
     Summary: Arb3StWrRd
     ===================
     This function tests the following functionality
     
     o This test case accesses static memory arbitrarily from different ports 
       but at the same and tests the functionality of buffer and arbiter
       and mem controller.

     o This test performs single data write with different types of size
       and read the data back to check the data integrity from different ports.

     o It also does the multiple data write with different size depending on the
       the burst type and reads the data back from different ports.
  */
  int i,k;
  int Data,size,chip, msize,burst, Addr1, Addr2;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  int caslat0, caslat1, caslat2, caslat3;
  int raslat0, raslat1, raslat2, raslat3;
  int trans0[7] = {2,3,3,3,3,3,5};
  int trans4[5] = {2,3,3,3,5};
  int trans8[9] = {2,3,3,3,3,3,3,3,5};
  int trans16[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  unsigned long Addr;
  char debugstr[100];

  #if (INFILE == 3)
  C("TEST ID : MPMC_Arb3StWrRd_1");
  /* Disable address mirror */
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
    WriteData(MPMCTrSR, 0x00000000, "WRD");
    /* Program the REFRESH field */
    HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
    HSW(,0x00000005); 
  C("Initialize registers");
  /* Write from Port0 to all memory chips with diff sizes and read it back */

  C("Initialize registers of Bank0 and TrickMem0");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,0,0,0,0,0,0,0,0,0x1,0x1,0x2,0x3,0x4,0x2,0x3);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x1,0x1,0x2,0x3,0x4,0x2,MPMCTrMEMBData[0],
               0x0);
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of Bank1 and TrickMem1");
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,1,0,0x1,0x1,0x2,0x2,0x3,0x1,0x3);
  TrickMemInit(1,1,0,0,1,0,0,1,0,0x1,0x1,0x2,0x2,0x3,0x1,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Initialize registers of Bank2 and TrickMem2");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,1,0,0,0x1,0x2,0x2,0x3,0x2,0x0,0x3);
  TrickMemInit(2,2,0,0,1,0,1,0,0,0x1,0x2,0x2,0x3,0x2,0x0,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Initialize registers of Bank3 and TrickMem3");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,1,0,0,1,0,1,1,0,0x1,0x2,0x2,0x3,0x4,0x5,0x3);
  TrickMemInit(3,1,0,0,1,0,1,1,0,0x1,0x2,0x2,0x3,0x4,0x5,MPMCTrMEMBData[3],
               0x0);

  WriteData(MPMCTrTES, 0x00000008, "WRD");
  Data = 0xAAAAAAAA; 
  for(i = 0; i < 70; i++)
  {
    chip = 0;
    msize = 1;
    Addr = rand() & 0x000001FC;
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
  Addr1 = 0x00000137;
  Sequence('w', Addr1,trans8, "inc",0,0x11111111,0);
  Addr2 = 0x10000231;
  Sequence('w', Addr2,trans4, "in4",0,0x11111111,0);
  Sequence('r', Addr1,trans8, "in8",0,0x11111111,0);
  Sequence('r', Addr2,trans4, "in4",0,0x11111111,0);
  Addr1 = 0x00000236;
  Sequence('w', Addr1,trans8, "wr8",1,0x33333333,0);
  Addr1 = 0x10000230;
  Sequence('w', Addr1,trans8, "in8",2,0x11111111,0);
  Addr1 = 0x00000236;
  Sequence('r', Addr1,trans4, "in4",1,0x33333333,0);
  Addr1 = 0x10000230;
  Sequence('r', Addr1,trans8, "in8",2,0x11111111,0);
  Addr1 = 0x00000236;
  Sequence('r', Addr1,trans8, "wr8",1,0x33333333,0);
  Addr1 = 0x10000239;
  Sequence('w', Addr1,trans8, "wr8",0,0x22222222,0);
  Addr1 = 0x10000F38;
  Sequence('w', Addr1,trans16, "i16",1,0x33333333,0);
  Addr1 = 0x00000236;
  Sequence('r', Addr1,trans8, "wr8",1,0x33333333,0);
  Addr1 = 0x10000F38;
  Sequence('r', Addr1,trans16, "i16",1,0x33333333,0);
  Addr1 = 0x00000131;
  Sequence('w', Addr1,trans8, "in8",0,0x55555555,0);
  Addr1 = 0x10000135;
  Sequence('w', Addr1,trans4, "wr4",0,0x55555555,0);
  Addr1 = 0x00000131;
  Sequence('r', Addr1,trans8, "in8",0,0x55555555,0);
  Addr1 = 0x10000135;
  Sequence('r', Addr1,trans4, "wr4",0,0x55555555,0);
  Addr1 = 0x00000102;
  Sequence('w', Addr1,trans16, "w16",1,0x55555555,0);
  Addr1 = 0x30000102;
  Sequence('w', Addr1,trans16, "w16",0,0x55555555,0);
  Addr1 = 0x00000102;
  Sequence('r', Addr1,trans16, "w16",1,0x55555555,0);
  Addr1 = 0x30000102;
  Sequence('r', Addr1,trans16, "w16",0,0x55555555,0);
  Addr1 = 0x10000135;
  Sequence('r', Addr1,trans4, "wr4",0,0x55555555,0);
  Addr1 = 0x1000010B;
  Sequence('w', Addr1,trans16, "i16",0,0x55555555,0);
  Addr1 = 0x00000102;
  Sequence('r', Addr1,trans16, "w16",1,0x55555555,0);

  Addr1 = 0x1000010B;
  Sequence('w', Addr1,trans4, "in4",0,0x55555555,0);
  Addr1 = 0x10000032;
  Sequence('w', Addr1,trans8, "in8",1,0x55555555,0);
  Addr1 = 0x1000010B;
  Sequence('r', Addr1,trans4, "in4",0,0x55555555,0);
  Addr1 = 0x10000032;
  Sequence('r', Addr1,trans8, "in8",1,0x55555555,0);
  Addr1 = 0x0000010B;
  Sequence('w', Addr1,trans8, "wr8",0,0x55555555,0);
  Addr1 = 0x0000000B;
  Sequence('w', Addr1,trans8, "in8",0,0x55555555,0);
  Addr1 = 0x10000032;
  Sequence('r', Addr1,trans8, "in8",1,0x55555555,0);
  Addr1 = 0x0000010B;
  Sequence('r', Addr1,trans8, "wr8",0,0x55555555,0);
  Addr1 = 0x0000000B;
  Sequence('r', Addr1,trans8, "in8",0,0x55555555,0);

  Addr1 = 0x10000100;
  Sequence('w', Addr1,trans4, "in4",2,0x55555555,0);
  Addr1 = 0x10000032;
  Sequence('w', Addr1,trans8, "in8",1,0x55555555,0);
  Addr1 = 0x10000100;
  Sequence('r', Addr1,trans4, "in4",2,0x55555555,0);
  Addr1 = 0x10000032;
  Sequence('r', Addr1,trans8, "in8",1,0x55555555,0);

  WriteData(MPMCTrTES, 0x00000008, "WRD");
  #elif (INFILE == 2)
  WaitLoop(0x6);
  Data = 0xBBBBBBBB;
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x9);
  for(i = 0; i < 70; i++)
  {
    chip = 2;
    sprintf(debugstr,"Memory access from Port2 to Bank: %X", chip);
    C(debugstr);
    msize = 1;
    Addr = rand() & 0x000000FC;
    burst = rand() % 8;
    size = rand() % 3;
    if(sizetype[size] == "BYTE")
    {
      debug_info(" Byte Transfer ");
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
  WaitLoop(0xA);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008, , ,Poll_Port2);
  #elif (INFILE == 1) 
  WaitLoop(0x2);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x5);


  Data = 0x22222222;
  for(i = 0; i < 70; i++)
  {
    chip = 3 ;
    sprintf(debugstr,"Bank: %X", chip);
    C(debugstr);
    msize = 1;
    Addr = rand() & 0x000002FC;
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
  
  Addr1 = 0x30000001; 
  Sequence('w', Addr1,trans8, "inc",0,0x11111111,0);
  Addr2 = 0x30000231;
  Sequence('w', Addr2,trans4, "in4",0,0x11111111,0);
  Sequence('r', Addr1,trans8, "in8",0,0x11111111,0);
  Sequence('r', Addr2,trans4, "in4",0,0x11111111,0);
  Addr1 = 0x30000236;
  Sequence('w', Addr1,trans8, "wr8",1,0x33333333,0);
  Addr1 = 0x30000030;
  Sequence('w', Addr1,trans8, "in8",2,0x11111111,0);
  Addr1 = 0x30000236;
  Sequence('r', Addr1,trans4, "in4",1,0x33333333,0);
  Addr1 = 0x30000030;
  Sequence('r', Addr1,trans8, "in8",2,0x11111111,0);
  Addr1 = 0x30000236;
  Sequence('r', Addr1,trans8, "wr8",1,0x33333333,0);
  Addr1 = 0x30000239;
  Sequence('w', Addr1,trans8, "wr8",0,0x22222222,0);
  Addr1 = 0x30000F38;
  Sequence('w', Addr1,trans16, "i16",1,0x33333333,0);
  Addr1 = 0x30000239;
  Sequence('r', Addr1,trans8, "wr8",0,0x22222222,0);
  Addr1 = 0x30000F38;
  Sequence('r', Addr1,trans16, "i16",1,0x33333333,0);
  Addr1 = 0x30000131;
  Sequence('w', Addr1,trans8, "in8",0,0x55555555,0);
  Addr1 = 0x30000035;
  Sequence('w', Addr1,trans4, "wr4",0,0x55555555,0);
  Addr1 = 0x30000131;
  Sequence('r', Addr1,trans8, "in8",0,0x55555555,0);
  Addr1 = 0x30000035;
  Sequence('r', Addr1,trans4, "wr4",0,0x55555555,0);
  Addr1 = 0x30000152;
  Sequence('w', Addr1,trans16, "w16",1,0x55555555,0);
  Addr1 = 0x30000102;
  Sequence('w', Addr1,trans16, "w16",0,0x55555555,0);
  Sequence('r', Addr1,trans16, "w16",0,0x55555555,0);
  Addr1 = 0x30000035;
  Sequence('r', Addr1,trans4, "wr4",0,0x55555555,0);
  Addr1 = 0x30000152;
  Sequence('r', Addr1,trans16, "w16",1,0x55555555,0);
  Addr1 = 0x3000010B;
  Sequence('w', Addr1,trans16, "i16",0,0x55555555,0);
  Addr1 = 0x3000010B;
  Sequence('r', Addr1,trans16, "i16",0,0x55555555,0);

  Addr1 = 0x3000010B;
  Sequence('w', Addr1,trans4, "in4",0,0x55555555,0);
  Addr1 = 0x30000032;
  Sequence('w', Addr1,trans8, "in8",1,0x55555555,0);
  Addr1 = 0x3000010B;
  Sequence('r', Addr1,trans4, "in4",0,0x55555555,0);
  Addr1 = 0x30000032;
  Sequence('r', Addr1,trans8, "in8",1,0x55555555,0);
  Addr1 = 0x3000010B;
  Sequence('w', Addr1,trans4, "in4",0,0x55555555,0);
  Addr1 = 0x30000032;
  Sequence('r', Addr1,trans8, "in8",1,0x55555555,0);
  Addr1 = 0x3000010B;
  Sequence('r', Addr1,trans8, "in4",0,0x55555555,0);

  Addr1 = 0x30000100;
  Sequence('w', Addr1,trans4, "in4",2,0x55555555,0);
  Addr1 = 0x30000032;
  Sequence('w', Addr1,trans8, "in8",1,0x55555555,0);
  Addr1 = 0x30000100;
  Sequence('r', Addr1,trans4, "in4",2,0x55555555,0);
  Addr1 = 0x30000032;
  Sequence('r', Addr1,trans8, "in8",1,0x55555555,0);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008, , ,Poll_Port1);
  #endif;
}
/*-- --=============================== End =================================--*/
