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
--  File Name              : EndiannessTests.c.rca
--  File Revision          : 1.7
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routine to verify the endian block.
--
--           TEST ID : MPMC_Endian_1
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** Endianness Tests ******************************/
/******************************************************************************/

void EndiannessTests()
{
  /*
     Summary: Endianness Tests
     =========================
     This function performs the following:

     o  Does the following sequence of tests for Little and Big Endian mode
        of operation:
        - Memory configured as 32 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values with LITTLE endian. Read
          the data with BIG endian mode.
        - Memory configured as 16 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values with LITTLE endian. Read
          the data with BIG endian mode.
        - Memory configured as 8 bits. Transactions are initiated from the
          AHB with different HSIZE and HBURST values with LITTLE endian. Read
          the data with BIG endian mode.
        - Perform the write operation with BIG Endian mode and read the data
          back by LITTLE Endian mode.
        - Finally perform write and read operations in BIG Endian mode.
  */
  char debugstr[100];
  int hsize, BankNo, Burst,TmpBurst,Tmphsize;
  int msize;
  int32 TestData[8] = {0x11221122, 0x22112211, 0x33443344, 0x33443344,
                       0x55AA55AA, 0x5AA55AA5, 0xAA77AA77, 0x81188118};

  int32 Addr,OrgAddr;
  C("TEST ID : MPMC_Endian_1");
  WriteData(MPMCControl, 0x00000001, "WRD");
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
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

  WriteData(MPMCTrTES, 0x00000008, "WRD");
  WriteData(MPMCConfig, 0x00000000, "WRD");

  /* Initialize controller as well as trickmemory */
   MPMCTrMEMBData[0] = 0x00000000;
  /* Set Bank 0 Memory Type as SRAM (32 bits width) */
  StInitProc(0,0,0,0,0,0,0,0,0,0x2,0x4,0x5,0x6,0x4,0x1,0x2);
  TrickMemInit(0,0,0,0,0,0,0,0,0,0x2,0x4,0x5,0x6,0x4,0x1,MPMCTrMEMBData[0],
               0x0);

  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,1,0,0,1,0,0,0,0,0x1,0x3,0x4,0x5,0x3,0x1,0x1);
  TrickMemInit(1,1,0,0,1,0,0,0,0,0x1,0x3,0x4,0x5,0x3,0x1,MPMCTrMEMBData[1],
               0x0);

  /* Set Bank 2 Memory Type as SRAM (8 bits width) */
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,2,0,0,1,0,0,0,0,0x1,0x3,0x4,0x5,0x3,0x3,0x1);
  TrickMemInit(2,2,0,0,1,0,0,0,0,0x1,0x3,0x4,0x5,0x3,0x3,MPMCTrMEMBData[2],
               0x0);

  /* Set Bank 3 Memory Type as SRAM (32 bits width) with buffers disabled */
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,0,0,0,0,0,0,0,0,0x1,0x3,0x4,0x5,0x3,0x5,0x1);
  TrickMemInit(3,0,0,0,0,0,0,0,0,0x1,0x3,0x4,0x5,0x2,0x5,MPMCTrMEMBData[3],
               0x0);
  debug_info("Switch off Protocol checker");
  /* When busy bit is low for 1 or 2 clocks poll command polls the bit and
     enable bit is pulled low after 2 clocks.But if bufflush happens during
     disabled mode(which cannot be avoided any way) signals become active and
     hence protocol checker flags the message */
  WriteData(MPMCTrCR, 0x00000010, "WRD");
  /** Does the write in LITTLE ENDIAN and Read back by BIG ENDIAN **/
  ENDIANNESS = 0;
  HSEN(LITTLE); 
 C("Does the write in LITTLE ENDIAN and read the data back in BIG ENDIAN Mode");
  for (BankNo=0; BankNo<8; BankNo++)
  {
    for (hsize=0; hsize<3; hsize++)
    {
      for (Burst = 0; Burst < 4; Burst++)
      {
        WaitLoop(1);
        MPMCDisable();
        WriteData(MPMCConfig, 0x00000000, "WRD");
        MPMCEnable();
        WaitLoop(0x2);
        HSEN(LITTLE);
        msize = BankNo % 3;  
        if(BankNo == 4)
          msize = 1;
        else if(BankNo == 5)
          msize = 2;
        else if(BankNo == 6)
          msize = 1;
        else if(BankNo == 7)
          msize = 1; 
        ENDIANNESS = 0;
        Addr = 0x100;
        if(BankNo > 3)
          Addr = Addr | (BankNo << 28);
         
        C("Write the data in Little endian mode");
        BurstWrite(BankNo, Burst, Addr, hsize, msize, TestData[Burst]);
        WaitLoop(1);
        MPMCDisable();
        WriteData(MPMCConfig, 0x00000001, "WRD");
        MPMCEnable();
        ENDIANNESS = 1;
        HSEN(DISABLE);
        WaitLoop(0x2);
        C("Read the data in Big endian mode");
        Addr = 0x100;
        if(BankNo > 3)
          Addr = Addr | (BankNo << 28);
        if (BankNo == 1 && hsize == 0)
        {
          WaitLoop(0x3);
          HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
          HPO(,0x00000000, ,0x00000003);
          WaitLoop(0x3);
          WriteData(MPMCTrMEMT_1, 0x51, "WRD");  
          BurstRead(BankNo, Burst, Addr, hsize, msize, TestData[Burst]);
          WaitLoop(0x3);
          HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
          HPO(,0x00000000, ,0x00000003);
          WaitLoop(0x3);
          WriteData(MPMCTrMEMT_1, 0x41, "WRD");
        }
        else
         BurstRead(BankNo, Burst, Addr, hsize, msize, TestData[Burst]);
      }
    }
  } 
  /* Does the write in BIG ENDIAN Mode and LITTLE ENDIAN Mode */
  C("Does the write in BIG Endian Mode and read back in LITTLE ENDIAN Mode");
  for (BankNo=0; BankNo<8; BankNo++)
  {
    for (hsize=0; hsize<3; hsize++)
    {
      for (Burst = 0; Burst < 3; Burst++)
      {
        TmpBurst = Burst;
        Tmphsize = hsize;
        HSEN(DISABLE);
        msize = BankNo % 3;
        ENDIANNESS = 1;
        WaitLoop(1);
        MPMCDisable();
        if(BankNo == 4)
          msize = 1;
        else if(BankNo == 5)
          msize = 2;
        else if(BankNo == 6)
          msize = 1;
        else if(BankNo == 7)
          msize = 1;
        WriteData(MPMCConfig, 0x00000001, "WRD");
        MPMCEnable();
        WaitLoop(0x2);
        C("Write data in BIG Endian mode");
        if(msize == 1)
        {
          if(hsize == 0)
            Tmphsize = 2;
        }
        if(msize == 2)
        {
         if(hsize == 0 || hsize == 1)
           Tmphsize = 2;
        }
        Addr = 0xC0;
        if(BankNo > 3)
          Addr = Addr | (BankNo << 28);
        BurstWrite(BankNo, TmpBurst, Addr, Tmphsize, msize, TestData[Burst]);
        WaitLoop(0x2);
        MPMCDisable();
        WriteData(MPMCConfig, 0x00000000, "WRD");
        MPMCEnable();
        WaitLoop(0x2);
        ENDIANNESS = 0;
        HSEN(LITTLE);
        C("Read data in Little Endian mode");
        if(msize == 1)
        {
          if(hsize == 0)
            Tmphsize = 2;
        }
        else if(msize == 2)
        {
         if(hsize == 0 || hsize == 1)
           Tmphsize = 2;
        }
        Addr = 0xC0;
        if(BankNo > 3)
          Addr = Addr | (BankNo << 28); 
        BurstRead(BankNo, TmpBurst, Addr, Tmphsize, msize, TestData[Burst]);
      }
    }
  }
  Addr = MEM1_BASE + 0x0C0;
  OrgAddr = Addr;
  HSEN(DISABLE);
  ENDIANNESS = 1;
  WaitLoop(1);
  MPMCDisable();
  WriteData(MPMCConfig, 0x00000001, "WRD");
  MPMCEnable();
  WaitLoop(0x2);
  C("Write data in BIG Endian mode");  
  WriteData(Addr, 0x22000000, "BYTE");
  Addr = Addr + 1;
  WriteData(Addr, 0x00230000, "BYTE");
  Addr = Addr + 1;
  WriteData(Addr, 0x00002400, "BYTE");
  Addr = Addr + 1;
  WriteData(Addr, 0x00000025, "BYTE");
  C("Read data back with little endian");
  WaitLoop(1);
  MPMCDisable();
  WriteData(MPMCConfig, 0x00000000, "WRD");
  MPMCEnable();
  WaitLoop(0x2);
  ENDIANNESS = 0;
  HSEN(LITTLE); 
  Addr = OrgAddr;
  Addr = Addr + 1;
  ReadData(Addr, 0x00002200,0x0000FF00, "BYTE");
  Addr = Addr - 1;
  ReadData(Addr, 0x00000023,0x000000FF, "BYTE");
  Addr = Addr + 3;
  ReadData(Addr, 0x24000000,0xFF000000, "BYTE");
  Addr = Addr - 1;
  ReadData(Addr, 0x00250000,0x00FF0000, "BYTE");
  C("Write data in BIG Endian");
  HSEN(DISABLE);
  ENDIANNESS = 1;
  WaitLoop(1);
  MPMCDisable();
  WriteData(MPMCConfig, 0x00000001, "WRD");
  MPMCEnable();
  WaitLoop(0x2);
  Addr = MEM2_BASE + 0xD0;
  OrgAddr = Addr;
  WriteData(Addr, 0x22000000, "BYTE");
  Addr = Addr + 1;
  WriteData(Addr, 0x00230000, "BYTE");
  Addr = Addr + 1;
  WriteData(Addr, 0x00002400, "BYTE");
  Addr = Addr + 1;
  WriteData(Addr, 0x00000025, "BYTE");

  C("Read in Little Endian");
  WaitLoop(1);
  MPMCDisable();
  WriteData(MPMCConfig, 0x00000000, "WRD"); 
  MPMCEnable();
  WaitLoop(0x2);
  ENDIANNESS = 0;
  HSEN(LITTLE);   
  Addr = OrgAddr;
  ReadData(Addr, 0x00000025,0x000000FF, "BYTE");
  Addr = Addr + 1;
  ReadData(Addr, 0x00002400,0x0000FF00, "BYTE");
  Addr = Addr + 1;
  ReadData(Addr, 0x00230000,0x00FF0000, "BYTE");
  Addr = Addr + 1;
  ReadData(Addr, 0x22000000,0xFF000000, "BYTE");
  C("Write in BIG Endian");
  HSEN(DISABLE);
  ENDIANNESS = 1;
  WaitLoop(1);
  MPMCDisable();
  WriteData(MPMCConfig, 0x00000001, "WRD");
  MPMCEnable();

  Addr = OrgAddr;
  WriteData(Addr, 0x22220000, "HWRD");
  Addr = Addr + 2;
  WriteData(Addr, 0x00003333, "HWRD");
  C("Read data back in LITTLE Endian");
  Addr = OrgAddr;
  WaitLoop(1);
  MPMCDisable();
  WriteData(MPMCConfig, 0x00000000, "WRD");
  MPMCEnable();
  WaitLoop(0x2);
  ENDIANNESS = 0;
  HSEN(LITTLE);
  ReadData(Addr, 0x00003333,0x0000FFFF, "HWRD");
  Addr = Addr + 2;
  ReadData(Addr, 0x22220000,0xFFFF0000, "HWRD");
  C("Does the write in BIG Endian Mode and read back in BIG ENDIAN Mode");
  for (BankNo=0; BankNo<8; BankNo++)
  {
    for (hsize=0; hsize<2; hsize++)
    {
      for (Burst = 0; Burst < 3; Burst++)
      {
        TmpBurst = Burst;
        Tmphsize = hsize;
        HSEN(DISABLE);
        msize = BankNo % 3;
        ENDIANNESS = 1;
        WaitLoop(1);
        MPMCDisable();
        WriteData(MPMCConfig, 0x00000001, "WRD");
        MPMCEnable();
        if(BankNo == 4)
          msize = 1;
        else if(BankNo == 5)
          msize = 2;
        else if(BankNo == 6)
          msize = 1;
        else if(BankNo == 7)
          msize = 1;
        WaitLoop(0x2);
        if(msize == 1)
        {
          if(hsize == 0)
            (Tmphsize = 2);
        } 
        else if(msize == 2)
        {
         if(hsize == 0 || hsize == 1)
           Tmphsize = 2;
        }
        Addr = 0xD0;
        if(BankNo > 3)
          Addr = Addr | (BankNo << 28);
        BurstWrite(BankNo, TmpBurst, Addr, Tmphsize, msize,TestData[Burst]);
        WaitLoop(1);
        MPMCDisable();
        WriteData(MPMCConfig, 0x00000001, "WRD");
        MPMCEnable();
        WaitLoop(0x2);
        ENDIANNESS = 1;
        if(msize == 1 || msize == 2)
        {
          if(hsize == 0)
            (Tmphsize = 2);
        }
        Addr = 0xD0;
        if(BankNo > 3)
          Addr = Addr | (BankNo << 28); 
        BurstRead(BankNo, TmpBurst, Addr, Tmphsize, msize,TestData[Burst]);
      }
    }
  }
  /* Changing back the ENDIANNESS to LITTLE (default) */
  WaitLoop(1);
  MPMCDisable();
  HSEN(LITTLE);
  WriteData(MPMCConfig, 0x00000000, "WRD");
  MPMCEnable();
  WaitLoop(0x2);
  ENDIANNESS = 0;
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  debug_info("Switch on Protocol checker");
  WriteData(MPMCTrCR, 0x00000000, "WRD");
}
/************************************ End *************************************/
