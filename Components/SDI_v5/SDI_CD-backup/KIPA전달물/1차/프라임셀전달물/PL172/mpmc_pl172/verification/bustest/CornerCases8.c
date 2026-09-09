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
--  File Name              : CornerCases8.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           It performs the Multiple port access. 
--           
--           TEST ID : MPMC_CornerCases8
--
-- --=======================================================================--*/
/******************************************************************************/
/********************************* CornerCases8 *******************************/
/******************************************************************************/
void CornerCases8()
{ 
  /*
     Summary: CornerCases8
    ======================
     This function tests doing following steps
     Two AHB's doing operations like semaphore updates.
     Both AHBS' keep reading the same address and keep testing the read data.
     If the Read Data is '1 AHB0 will write 2 into the address.
     SImilarly when AHB# finds the read data is 2 it writes 1.
     This way the tgwo AHB's keep the handshake with each other through a memory
     location. the operation is repeated for around 300 cycles.

  */
  int i,k, csel;
  int Data,size,chip,msize;
  int Bound,burst,LoBits;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};
  char* bursttype[] =
        {"SINGLE","INCR","INCR4","INCR8","INCR16","WRAP4","WRAP8","WRAP16"};

  int trans0[6] = {2,2,2,2,2,5};
  int trans1[10] = {2,3,3,3,3,3,3,3,3,5};
  int trans2[5] = {2,3,3,3,5};
  int trans3[9] = {2,3,3,3,3,3,3,3,5};
  int trans4[17]= {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  unsigned long Addr;
  char debugstr[100];
  int32 MemAddr, MemAddr1, TestData;

  #if (INFILE== 3)
  C("TEST ID : MPMC_CornerCases8");
  /* Disable address mirror */
  WriteData(MPMCControl,0x00000001,"WRD");

  C("initialize sdrams and registers");
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
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
  WriteData(MPMCTrExBkOff, 0x00000005, "WRD");

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
  WriteData(MPMCTrCR, 0x00000020, "WRD");
  WriteData(MPMCTrTES, 0x00000008, "WRD");
    C("Access from port3 to bank0 of chip select6");
    for(i = 0; i < 300; i++)
    {
    HSA(0x4000001C, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
    HSW( , 0x00000001);
    WaitLoop(0x3);
    HSA(0x4000001C, NSEQ, INCR, OK, WRD);
    HPO(, 0x00000002, , 0xFFFFFFFF);
    WaitLoop(0x3);

    }
    /* Wait till MPMCTrTES[3] is set */
    WaitLoop(0x3);
    HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
    HPO(, 0x00000009, ,0x00000009, , ,Poll_TES);
    WaitLoop(0x3);

    #elif (INFILE == 0)
    /* Wait till MPMCTrTES[3] is set */
    WaitLoop(0x3);
    HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
    HPO(, 0x00000008, ,0x00000008, , ,Poll_TES);
    WaitLoop(0x3);

    C("Access from port0 to bank1 of chip select6");
    for(i = 0; i < 300; i++)
    {
    WaitLoop(0x3);
    HSA(0x4000001C, NSEQ, INCR, OK, WRD);
    HPO(, 0x00000001, , 0xFFFFFFFF);
    WaitLoop(0x3);

    HSA(0x4000001C, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
    HSW( , 0x00000002);
    }
    WriteData(MPMCTrTES, 0x00000001, "WRD");
    #endif;
}
/*-- --=============================== End =================================--*/
