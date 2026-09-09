/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : IntegrationTest.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the connectivity of AHB related signals and 
--           primary I/O
--
--           TEST ID : IntegrationTest_1
--
-- --=======================================================================--*/
/******************************************************************************/
/***************************** IntegrationTest ********************************/
/******************************************************************************/
IntegrationTest()
{
  /* 
     Summary: IntegrationTest()
     ==========================
     This does the following functionalities
     o Toggles all possible AHB related signals
     o Toggles all memory related signals
  */
  int i,k,j;
  int Data,size,chip,msize;
  int Bound,burst,LoBits;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"sin","inc","in4","in8","i16","wr4","wr8","w16"};
  int trans1[6]={2,2,0,2,2,5};
  int trans2[7]={2,3,1,3,3,3,5};
  int trans3[6]={2,1,3,3,3,5};
  int trans4[10]={2,3,3,3,3,3,3,3,1,5};
  int trans5[19]={2,3,3,3,3,3,3,1,0,2,3,3,3,3,3,3,3,3,5};
  char* trans[] = {"trans1", "trans2", "trans3", "trans4", "trans5"};
  unsigned long DataArr[8] = {0x01010101, 0x10101010, 0xA0A0A0A0, 0x50505050,
                              0xAAAAAAAA, 0x44444444, 0xEEEEEEEE, 0x33333333};
  unsigned long AddrArr[7] = {0x0AAAAAAC, 0x2555555C, 0x30AAAAAC,0x40555550,
                              0x50AAAAA0, 0x6A555554, 0x70AAAAAC};
  unsigned long Addr;
  char debugstr[100];

  #if (INFILE == 3) 
  C("TEST ID : MPMC_IntegrationTest_1");
  /* Disable address mirror */
  WriteData(MPMCControl,0x00000001,"WRD");

  C("initialize sdrams and registers");
  TimingInit(2,5,8,0,5,3,0,7,7,0,2,3);
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
                     0
                    );
  WriteData(MPMCControl,0x00000001,"WRD");
  MPMCTrMEMBData[0] = 0x00000000;
  C("Initialize static memory controller register");

  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  StInitProc(0,2,0,0,1,0,0,0,0,0x1,0x1,0x7,0x5,0x8,0x5,0x8);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  StInitProc(1,1,0,0,1,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  StInitProc(2,0,0,0,0,0,0,0,0,0x1,0x1,0x8,0x5,0x8,0x1,0x1);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  StInitProc(3,2,0,0,0,0,0,0,0,0x1,0x1,0x1,0x1,0x1,0x1,0x1);

  WriteData(MPMCTrTES, 0x00000008, "WRD");
 
  C("Perform memory accesses to toggle the AHB and memory signals from Port3");
  C("Perform memory write from Port3");
    Sequence('w', 0x01111110,trans1,"sin",2,0x33333333,0);
    Sequence('w', 0x10101010,trans2,"inc",2,0x55555555,0);
    Sequence('w', 0x23333334,trans3,"in4",2,0xAAAAAAAA,0);
    Sequence('w', 0x35555550,trans4,"in8",2,0x33333333,0);
    Sequence('w', 0x4AAAAAA0,trans5,"i16",2,0x00000000,0);
    Sequence('w', 0x5EEEEEE0,trans3,"wr4",2,0xFFFFFFFF,0);
    Sequence('w', 0x64444444,trans4,"wr8",2,0x33333333,0);
    Sequence('w', 0x70000000,trans5,"w16",2,0x33333333,0);
   
  C("Perform memory read from Port3");
    Sequence('r', 0x01111110,trans1,"sin",2,0x33333333,0);
    Sequence('r', 0x10101010,trans2,"inc",2,0x55555555,0);
    Sequence('r', 0x23333334,trans3,"in4",2,0xAAAAAAAA,0);
    Sequence('r', 0x35555550,trans4,"in8",2,0x33333333,0);
    Sequence('r', 0x4AAAAAA0,trans5,"i16",2,0x00000000,0);
    Sequence('r', 0x5EEEEEE0,trans3,"wr4",2,0xFFFFFFFF,0);
    Sequence('r', 0x64444444,trans4,"wr8",2,0x33333333,0);
    Sequence('r', 0x70000000,trans5,"w16",2,0x33333333,0);

  C("Perform memory write from Port3");
    Sequence('w', 0x01111112,trans1,"sin",1,0x33333333,0);
    Sequence('w', 0x10101016,trans2,"inc",1,0x55555555,0);
    Sequence('w', 0x23333332,trans3,"in4",1,0xAAAAAAAA,0);
    Sequence('w', 0x35555552,trans4,"in8",1,0x33333333,0);
    Sequence('w', 0x4AAAAAA2,trans5,"i16",1,0x00000000,0);
    Sequence('w', 0x5EEEEEE2,trans3,"wr4",1,0xFFFFFFFF,0);
    Sequence('w', 0x64444442,trans4,"wr8",1,0x33333333,0);
    Sequence('w', 0x70000002,trans5,"w16",1,0x33333333,0);
   
  C("Perform memory read from Port3");
    Sequence('r', 0x01111112,trans1,"sin",1,0x33333333,0);
    Sequence('r', 0x10101016,trans2,"inc",1,0x55555555,0);
    Sequence('r', 0x23333332,trans3,"in4",1,0xAAAAAAAA,0);
    Sequence('r', 0x35555552,trans4,"in8",1,0x33333333,0);
    Sequence('r', 0x4AAAAAA2,trans5,"i16",1,0x00000000,0);
    Sequence('r', 0x5EEEEEE2,trans3,"wr4",1,0xFFFFFFFF,0);
    Sequence('r', 0x64444442,trans4,"wr8",1,0x33333333,0);
    Sequence('r', 0x70000002,trans5,"w16",1,0x33333333,0);

  C("Perform memory write from Port3");
    Sequence('w', 0x01111111,trans1,"sin",0,0x33333333,0);
    Sequence('w', 0x10101012,trans2,"inc",0,0x55555555,0);
    Sequence('w', 0x23333333,trans3,"in4",0,0xAAAAAAAA,0);
    Sequence('w', 0x35555554,trans4,"in8",0,0x33333333,0);
    Sequence('w', 0x4AAAAAA5,trans5,"i16",0,0x00000000,0);
    Sequence('w', 0x5EEEEEE6,trans3,"wr4",0,0xFFFFFFFF,0);
    Sequence('w', 0x64444447,trans4,"wr8",0,0x33333333,0);
    Sequence('w', 0x70000008,trans5,"w16",0,0x33333333,0);
   
  C("Perform memory read from Port3");
    Sequence('r', 0x01111111,trans1,"sin",0,0x33333333,0);
    Sequence('r', 0x10101012,trans2,"inc",0,0x55555555,0);
    Sequence('r', 0x23333333,trans3,"in4",0,0xAAAAAAAA,0);
    Sequence('r', 0x35555554,trans4,"in8",0,0x33333333,0);
    Sequence('r', 0x4AAAAAA5,trans5,"i16",0,0x00000000,0);
    Sequence('r', 0x5EEEEEE6,trans3,"wr4",0,0xFFFFFFFF,0);
    Sequence('r', 0x64444447,trans4,"wr8",0,0x33333333,0);
    Sequence('r', 0x70000008,trans5,"w16",0,0x33333333,0);
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000000, ,0x0000000F);
  WaitLoop(0x3);
  #elif (INFILE == 2) 
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x3);
  C("Perform memory accesses to toggle the AHB and memory signals from Port2");
  WaitLoop(0x3);

  C("Perform memory write from Port2");
    Sequence('w', 0x01113330,trans1,"sin",2,0x33333333,0);
    Sequence('w', 0x10103330,trans2,"inc",2,0x55555555,0);
    Sequence('w', 0x23335554,trans3,"in4",2,0xAAAAAAAA,0);
    Sequence('w', 0x35557770,trans4,"in8",2,0x33333333,0);
    Sequence('w', 0x4AAA9990,trans5,"i16",2,0x00000000,0);
    Sequence('w', 0x5EEEAAA0,trans3,"wr4",2,0xFFFFFFFF,0);
    Sequence('w', 0x6444CCC4,trans4,"wr8",2,0x33333333,0);
    Sequence('w', 0x70006660,trans5,"w16",2,0x33333333,0);
   
  C("Perform memory read from Port2");
    Sequence('r', 0x01113330,trans1,"sin",2,0x33333333,0);
    Sequence('r', 0x10103330,trans2,"inc",2,0x55555555,0);
    Sequence('r', 0x23335554,trans3,"in4",2,0xAAAAAAAA,0);
    Sequence('r', 0x35557770,trans4,"in8",2,0x33333333,0);
    Sequence('r', 0x4AAA9990,trans5,"i16",2,0x00000000,0);
    Sequence('r', 0x5EEEAAA0,trans3,"wr4",2,0xFFFFFFFF,0);
    Sequence('r', 0x6444CCC4,trans4,"wr8",2,0x33333333,0);
    Sequence('r', 0x70006660,trans5,"w16",2,0x33333333,0);

  C("Perform memory write from Port2");
    Sequence('w', 0x01113332,trans1,"sin",1,0x33333333,0);
    Sequence('w', 0x10103334,trans2,"inc",1,0x55555555,0);
    Sequence('w', 0x23335556,trans3,"in4",1,0xAAAAAAAA,0);
    Sequence('w', 0x35557778,trans4,"in8",1,0x33333333,0);
    Sequence('w', 0x4AAA999A,trans5,"i16",1,0x00000000,0);
    Sequence('w', 0x5EEEAAAC,trans3,"wr4",1,0xFFFFFFFF,0);
    Sequence('w', 0x6444000E,trans4,"wr8",1,0x33333333,0);
    Sequence('w', 0x70006662,trans5,"w16",1,0x33333333,0);
   
  C("Perform memory read from Port2");
    Sequence('r', 0x01113332,trans1,"sin",1,0x33333333,0);
    Sequence('r', 0x10103334,trans2,"inc",1,0x55555555,0);
    Sequence('r', 0x23335556,trans3,"in4",1,0xAAAAAAAA,0);
    Sequence('r', 0x35557778,trans4,"in8",1,0x33333333,0);
    Sequence('r', 0x4AAA999A,trans5,"i16",1,0x00000000,0);
    Sequence('r', 0x5EEEAAAC,trans3,"wr4",1,0xFFFFFFFF,0);
    Sequence('r', 0x6444000E,trans4,"wr8",1,0x33333333,0);
    Sequence('r', 0x70006662,trans5,"w16",1,0x33333333,0);

  C("Perform memory write from Port2");
    Sequence('w', 0x0111FFF1,trans1,"sin",0,0x33333333,0);
    Sequence('w', 0x10103332,trans2,"inc",0,0x55555555,0);
    Sequence('w', 0x23335553,trans3,"in4",0,0xAAAAAAAA,0);
    Sequence('w', 0x35557774,trans4,"in8",0,0x33333333,0);
    Sequence('w', 0x4AAA9995,trans5,"i16",0,0x00000000,0);
    Sequence('w', 0x5EEEAAA6,trans3,"wr4",0,0xFFFFFFFF,0);
    Sequence('w', 0x6444CCC7,trans4,"wr8",0,0x33333333,0);
    Sequence('w', 0x70006668,trans5,"w16",0,0x33333333,0);
   
  C("Perform memory read from Port2");
    Sequence('r', 0x0111FFF1,trans1,"sin",0,0x33333333,0);
    Sequence('r', 0x10103332,trans2,"inc",0,0x55555555,0);
    Sequence('r', 0x23335553,trans3,"in4",0,0xAAAAAAAA,0);
    Sequence('r', 0x35557774,trans4,"in8",0,0x33333333,0);
    Sequence('r', 0x4AAA9995,trans5,"i16",0,0x00000000,0);
    Sequence('r', 0x5EEEAAA6,trans3,"wr4",0,0xFFFFFFFF,0);
    Sequence('r', 0x6444CCC7,trans4,"wr8",0,0x33333333,0);
    Sequence('r', 0x70006668,trans5,"w16",0,0x33333333,0);

    HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
    HSW(,0x00000000);
    WaitLoop(0x3);
    HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
    HPO(,0x00000000, ,0x0000000F);
    WaitLoop(0x3);
  #elif (INFILE == 1)
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x00000002);
  WaitLoop(0x3);

  C("Perform memory write from Port1");
    Sequence('w', 0x01115550,trans1,"sin",2,0x33333333,0);
    Sequence('w', 0x10105550,trans2,"inc",2,0x55555555,0);
    Sequence('w', 0x23338884,trans3,"in4",2,0xAAAAAAAA,0);
    Sequence('w', 0x35550000,trans4,"in8",2,0x33333333,0);
    Sequence('w', 0x4AAAEEF0,trans5,"i16",2,0x00000000,0);
    Sequence('w', 0x5EEE5550,trans3,"wr4",2,0xFFFFFFFF,0);
    Sequence('w', 0x64445554,trans4,"wr8",2,0x33333333,0);
    Sequence('w', 0x70005550,trans5,"w16",2,0x33333333,0);
   
  C("Perform memory read from Port1");
    Sequence('r', 0x01115550,trans1,"sin",2,0x33333333,0);
    Sequence('r', 0x10105550,trans2,"inc",2,0x55555555,0);
    Sequence('r', 0x23338884,trans3,"in4",2,0xAAAAAAAA,0);
    Sequence('r', 0x35550000,trans4,"in8",2,0x33333333,0);
    Sequence('r', 0x4AAAEEF0,trans5,"i16",2,0x00000000,0);
    Sequence('r', 0x5EEE5550,trans3,"wr4",2,0xFFFFFFFF,0);
    Sequence('r', 0x64445554,trans4,"wr8",2,0x33333333,0);
    Sequence('r', 0x70005550,trans5,"w16",2,0x33333333,0);

  C("Perform memory write from Port1");
    Sequence('w', 0x01115552,trans1,"sin",1,0x33333333,0);
    Sequence('w', 0x10105554,trans2,"inc",1,0x55555555,0);
    Sequence('w', 0x23338886,trans3,"in4",1,0xAAAAAAAA,0);
    Sequence('w', 0x35556668,trans4,"in8",1,0x33333333,0);
    Sequence('w', 0x4AAA555A,trans5,"i16",1,0x00000000,0);
    Sequence('w', 0x5EEE555C,trans3,"wr4",1,0xFFFFFFFF,0);
    Sequence('w', 0x6444555E,trans4,"wr8",1,0x33333333,0);
    Sequence('w', 0x70005552,trans5,"w16",1,0x33333333,0);
   
  C("Perform memory read from Port1");
    Sequence('r', 0x01115552,trans1,"sin",1,0x33333333,0);
    Sequence('r', 0x10105554,trans2,"inc",1,0x55555555,0);
    Sequence('r', 0x23338886,trans3,"in4",1,0xAAAAAAAA,0);
    Sequence('r', 0x35556668,trans4,"in8",1,0x33333333,0);
    Sequence('r', 0x4AAA555A,trans5,"i16",1,0x00000000,0);
    Sequence('r', 0x5EEE555C,trans3,"wr4",1,0xFFFFFFFF,0);
    Sequence('r', 0x6444555E,trans4,"wr8",1,0x33333333,0);
    Sequence('r', 0x70005552,trans5,"w16",1,0x33333333,0);

  C("Perform memory write from Port1");
    Sequence('w', 0x01115551,trans1,"sin",0,0x33333333,0);
    Sequence('w', 0x10105552,trans2,"inc",0,0x55555555,0);
    Sequence('w', 0x23338883,trans3,"in4",0,0xAAAAAAAA,0);
    Sequence('w', 0x35556664,trans4,"in8",0,0x33333333,0);
    Sequence('w', 0x4AAA5555,trans5,"i16",0,0x00000000,0);
    Sequence('w', 0x5EEE0006,trans3,"wr4",0,0xFFFFFFFF,0);
    Sequence('w', 0x6444EEF7,trans4,"wr8",0,0x33333333,0);
    Sequence('w', 0x70005558,trans5,"w16",0,0x33333333,0);
   
  C("Perform memory read from Port1");
    Sequence('r', 0x01115551,trans1,"sin",0,0x33333333,0);
    Sequence('r', 0x10105552,trans2,"inc",0,0x55555555,0);
    Sequence('r', 0x23338883,trans3,"in4",0,0xAAAAAAAA,0);
    Sequence('r', 0x35556664,trans4,"in8",0,0x33333333,0);
    Sequence('r', 0x4AAA5555,trans5,"i16",0,0x00000000,0);
    Sequence('r', 0x5EEE0006,trans3,"wr4",0,0xFFFFFFFF,0);
    Sequence('r', 0x6444EEF7,trans4,"wr8",0,0x33333333,0);
    Sequence('r', 0x70005558,trans5,"w16",0,0x33333333,0);

    HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
    HSW(,0x00000000);
    WaitLoop(0x3);
    HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
    HPO(,0x00000000, ,0x0000000F);
    WaitLoop(0x3);
  #elif (INFILE == 0)
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000008, ,0x00000008);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x00000001);
  C("Perform memory accesses to toggle the AHB and memory signals from Port0");

  C("Perform memory write from Port0");
    Sequence('w', 0x0111EEF0,trans1,"sin",2,0x33333333,0);
    Sequence('w', 0x1010EEF0,trans2,"inc",2,0x55555555,0);
    Sequence('w', 0x23337770,trans3,"in4",2,0xAAAAAAAA,0);
    Sequence('w', 0x35557770,trans4,"in8",2,0x33333333,0);
    Sequence('w', 0x4AAA0000,trans5,"i16",2,0x00000000,0);
    Sequence('w', 0x5EEE7770,trans3,"wr4",2,0xFFFFFFFF,0);
    Sequence('w', 0x64447770,trans4,"wr8",2,0x33333333,0);
    Sequence('w', 0x70007770,trans5,"w16",2,0x33333333,0);
   
  C("Perform memory read from Port0");
    Sequence('r', 0x0111EEF0,trans1,"sin",2,0x33333333,0);
    Sequence('r', 0x1010EEF0,trans2,"inc",2,0x55555555,0);
    Sequence('r', 0x23337770,trans3,"in4",2,0xAAAAAAAA,0);
    Sequence('r', 0x35557770,trans4,"in8",2,0x33333333,0);
    Sequence('r', 0x4AAA0000,trans5,"i16",2,0x00000000,0);
    Sequence('r', 0x5EEE7770,trans3,"wr4",2,0xFFFFFFFF,0);
    Sequence('r', 0x64447770,trans4,"wr8",2,0x33333333,0);
    Sequence('r', 0x70007770,trans5,"w16",2,0x33333333,0);

  C("Perform memory write from Port0");
    Sequence('w', 0x0111EEF2,trans1,"sin",1,0x33333333,0);
    Sequence('w', 0x1010EEF4,trans2,"inc",1,0x55555555,0);
    Sequence('w', 0x23337776,trans3,"in4",1,0xAAAAAAAA,0);
    Sequence('w', 0x35557778,trans4,"in8",1,0x33333333,0);
    Sequence('w', 0x4AAA000A,trans5,"i16",1,0x00000000,0);
    Sequence('w', 0x5EEE777C,trans3,"wr4",1,0xFFFFFFFF,0);
    Sequence('w', 0x6444777E,trans4,"wr8",1,0x33333333,0);
    Sequence('w', 0x70007770,trans5,"w16",1,0x33333333,0);
   
  C("Perform memory read from Port0");
    Sequence('r', 0x0111EEF2,trans1,"sin",1,0x33333333,0);
    Sequence('r', 0x1010EEF4,trans2,"inc",1,0x55555555,0);
    Sequence('r', 0x23337776,trans3,"in4",1,0xAAAAAAAA,0);
    Sequence('r', 0x35557778,trans4,"in8",1,0x33333333,0);
    Sequence('r', 0x4AAA000A,trans5,"i16",1,0x00000000,0);
    Sequence('r', 0x5EEE777C,trans3,"wr4",1,0xFFFFFFFF,0);
    Sequence('r', 0x6444777E,trans4,"wr8",1,0x33333333,0);
    Sequence('r', 0x70007770,trans5,"w16",1,0x33333333,0);

  C("Perform memory write from Port0");
    Sequence('w', 0x0111EEF1,trans1,"sin",0,0x33333333,0);
    Sequence('w', 0x1010EEF2,trans2,"inc",0,0x55555555,0);
    Sequence('w', 0x23337773,trans3,"in4",0,0xAAAAAAAA,0);
    Sequence('w', 0x35557774,trans4,"in8",0,0x33333333,0);
    Sequence('w', 0x4AAA0005,trans5,"i16",0,0x00000000,0);
    Sequence('w', 0x5EEE7776,trans3,"wr4",0,0xFFFFFFFF,0);
    Sequence('w', 0x64447777,trans4,"wr8",0,0x33333333,0);
    Sequence('w', 0x70007778,trans5,"w16",0,0x33333333,0);
   
  C("Perform memory read from Port0");
    Sequence('r', 0x0111EEF1,trans1,"sin",0,0x33333333,0);
    Sequence('r', 0x1010EEF2,trans2,"inc",0,0x55555555,0);
    Sequence('r', 0x23337773,trans3,"in4",0,0xAAAAAAAA,0);
    Sequence('r', 0x35557774,trans4,"in8",0,0x33333333,0);
    Sequence('r', 0x4AAA0005,trans5,"i16",0,0x00000000,0);
    Sequence('r', 0x5EEE7776,trans3,"wr4",0,0xFFFFFFFF,0);
    Sequence('r', 0x64447777,trans4,"wr8",0,0x33333333,0);
    Sequence('r', 0x70007778,trans5,"w16",0,0x33333333,0);
    WaitLoop(0x3);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(,0x00000000);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(,0x00000000, ,0x0000000F);
  WaitLoop(0x3);
  #endif; 
}    
/*-- --=========================== End ==================================-- --*/
