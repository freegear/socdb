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
-- File Name              : CornerCases6.c.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests all HBURST accesses on the dynamic memory
--           This test uses tbench
--
--           TEST ID : MPMC_CornerCases6
--
-- --=======================================================================--*/
/******************************************************************************/
/***************************** CornerCases6 **********************************/
/******************************************************************************/
void CornerCases6(void)
{
  /*
    Summary: CornerCases6
    ======================
    This test performs the following functionalities:
   
    o Do a Read -Modify - Write sequence when all buffers are occupied and one
      of them to which the particular read and write is routed, has part
      filled data. e.g. : Write to Addr0, Read to Addr0, Write to Addr0. 

    o Read Addr0 + 7, to prevent the Write from actually coming
      on to the bus until the last data item is read from memory into
      MPMC buffer and the same returned to the core through the cache
      controller. Thus only after last data from the INCR8 is returned does
      the new Write request come from the Core.
      Sequence required.(core)
         Write Addr0
         Read Addr0
         Read Addr0 + 7
         Wait 40-50 clocks.(if a refresh interrupts the data fetch from memory)
        Write Addr0

    o Read Addr0 + 40 (something outside the QQwords already present in buffers.
      This will force one of the buffers to flush, mostly the LRU which will be
      different from the buffer allocated to Addr0. This will happen only
      after the current flush completes and hence we prevent a buffer hit write
      from happening to a buffer locked by a read.)
      Follow this by the write back to Addr0.
      Sequence Required.(core)
         Write Addr0
         Read Addr0
         Read Addr0 + 40
         Write Addr0.
  */

  int i,size,csel,chip,burst;
  char debugstr[100];
  int caslat0,caslat1,caslat2,caslat3;
  int raslat0,raslat1,raslat2,raslat3;
  int ClkRatio,msize;
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;
 
  int32 AddrArr[] = {0x00000004,0x00000208,0x00020000,0x00030034,0x00040000,
                     0x00050010,0x000600A8,0x00070034,0x000800C0,0x00090064,
                     0x000A0014,0x000B0060,0x000EE004,0x00011008,0x00022000,
                     0x00055000,0x0006601C,0x00077000,0x00088034,0x00099048,
                     0x000AA020,0x000BB014,0x000CC06C,0x000DD060};
  int32 MemAddr, MemAddr1, TestData;
                     
  C("TEST ID : MPMC_CornerCases6");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  C("Disable Address mirror");
  WriteData(MPMCControl, 0x00000001, "WRD");
  ClkRatio = 0;
  C("Initialize SDRAMs and configure the registers");
  TimingInit(2,0xF,0xF,0xF,0xF,0xF,0xF,0x1F,0x1F,0x1F,0xF,0xF);
  SyncInitializeProc(3, 0, 2, 3, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 3, 2, 0, 0,
                     3, 0, 2, 3, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     ClkRatio);
  WriteData(MPMCTrSR, 0x00000000, "WRD");
  C("Reprogram the refresh counter");
  WriteData(MPMCDyRef, 0x4, "WRD");

  for (burst = 1; burst < 8; burst++)
  {
  /****************************************************************************/
  /*
     Do a Read -Modify - Write sequence when all buffers are occupied and one
     of them to which the particular read and write is routed, has part
     filled data. e.g. : Write to Addr0, Read to Addr0, Write to Addr0. 
  */
  /****************************************************************************/
  MemAddr = 0x40000000;
  TestData = 0x11111111;

  /* EBI back off will be asserted two clock after receiving the grant */
  WriteData(MPMCTrExBkOff, 0x00000020, "WRD");

  C("Fill on First  block");
  /* Fill on First  block */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;

  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;

  /* Fill on Second  block */
  C("Fill on Second  block");
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  /* Fill on third  block */
  C("Fill on third  block");
  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }
  MemAddr =  0x400000C0;

  C("Fill on Fourth  block");
  /* Write to Addr0 (QWORD Boundry) */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /* EBI back off will be asserted two clock after receiving the grant  */
  WriteData(MPMCTrExBkOff, 0x00000023, "WRD");

  if (burst == 1)
  {
    /* Read Addr0 */
    C("Do read with INCR4");
    HSA(MemAddr, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  }

  if (burst == 2)
  {
    /* Read Addr0 */
    C("Do read with WRAP4");
    HSA(MemAddr, NSEQ, WRAP4, , WRD, , 0x1, , , , ,);
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  }

  if (burst == 3)
  {
    /* Read Addr0 */
    C("Do read with INCR8");
    HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  }

  if (burst == 4)
  {
    /* Read Addr0 */
    C("Do read with WRAP8");
    HSA(MemAddr, NSEQ, WRAP8, , WRD, , 0x1, , , , ,);
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);

  }

  if (burst == 5)
  {
    /* Read Addr0 */
    C("Do read with INCR16");
    HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  }

  if (burst == 6)
  {
    /* Read Addr0 */
    C("Do read with WRAP16");
    HSA(MemAddr, NSEQ, WRAP16, , WRD, , 0x1, , , , ,);
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);

    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);

  }

  if (burst == 7)
  {
    /* Read Addr0 */
    C("Do read with INCR");
    HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
    HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  }

  TestData = TestData + 1;

  /* Write to Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /* Read Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);

  TestData = TestData + 1;
  MemAddr =  MemAddr + 0x40;

  /* Write to Addr0 + 0x40 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /* Read Addr0 + 0x40 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);

  /* Readback the data */
  MemAddr = 0x40000000;
  TestData = 0x11111111;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x40;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x40;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  WaitLoop(500);
}

  /****************************************************************************/
  /*
    o Read Addr0 + 7, to prevent the Write from actually coming
      on to the bus until the last data item is read from memory into
      MPMC buffer and the same returned to the core through the cache
      controller. Thus only after last data from the INCR8 is returned does
      the new Write request come from the Core.
      Sequence required.(core)
         Write Addr0
         Read Addr0
         Read Addr0 + 7
         Wait 40-50 clocks.(if a refresh interrupts the data fetch from memory)
        Write Addr0

  */
  /****************************************************************************/
  MemAddr = 0x40000000;
  TestData = 0x11111111;

  /* EBI back off will be asserted two clock after receiving the grant */
  WriteData(MPMCTrExBkOff, 0x00000020, "WRD");

  C("Fill on First  block");
  /* Fill on First  block */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;

  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;

  /* Fill on Second  block */
  C("Fill on Second  block");
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  /* Fill on third  block */
  C("Fill on third  block");
  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }
  MemAddr =  0x400000C0;

  C("Fill on Fourth  block");
  /* Write Addr0 (Q-WORD boundry) */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /* EBI back off will be asserted two clock after receiving the grant  */
  WriteData(MPMCTrExBkOff, 0x00000023, "WRD");

  /* Read Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);

  /* Read Addr0 + 7 * 4 */
  HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);
  HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);

  WaitLoop(50);

  TestData = TestData + 1;
  MemAddr =  0x400000C0;

  /* Write Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /* Read Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);

  /* Readback the data */
  MemAddr = 0x40000000;
  TestData = 0x11111111;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x40;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x40;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  WaitLoop(500);

 /*****************************************************************************/
 /*
    o Read Addr0 + 40 (something outside the QQwords already present in buffers.
      This will force one of the buffers to flush, mostly the LRU which will be
      different from the buffer allocated to Addr0. This will happen only
      after the current flush completes and hence we prevent a buffer hit write
      from happening to a buffer locked by a read.)
      Follow this by the write back to Addr0.
      Sequence Required.(core)
         Write Addr0
         Read Addr0
         Read Addr0 + 40
         Write Addr0.
 */
 /*****************************************************************************/

  MemAddr = 0x40000000;
  TestData = 0x22222222;

  /* EBI back off will be asserted two clock after receiving the grant */
  WriteData(MPMCTrExBkOff, 0x00000020, "WRD");

  C("Fill on First  block");
  /* Fill on First  block */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;

  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;

  /* Fill on Second  block */
  C("Fill on Second  block");
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  /* Fill on third  block */
  C("Fill on third  block");
  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x20;
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  TestData = TestData + 1;
  for (i = 2; i <= 8; i++)
  {
    HSW( , TestData);
    TestData = TestData + 1;
  }
  MemAddr =  0x400000C0;

  C("Fill on Fourth  block");
  /* Write Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /* EBI back off will be asserted two clock after receiving the grant  */
  WriteData(MPMCTrExBkOff, 0x00000023, "WRD");

  /* Read Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);

  C("Read something outside previous QQWord");
  /* Read Addr0 + 0x40 */
  MemAddr1 = MemAddr + 0x40;
  HSA(MemAddr1, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0x00000000, ,BurstWriteRead_1);

  TestData = TestData + 1;
  MemAddr =  0x400000C0;

  /* Write Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /* Read Addr0 */
  HSA(MemAddr, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);

  /* Readback the data */
  MemAddr = 0x40000000;
  TestData = 0x22222222;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x40;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  MemAddr =  MemAddr + 0x40;

  HSA(MemAddr, NSEQ, INCR16, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
  TestData = TestData + 1;
  for (i = 2; i <= 16; i++)
  {
    HSR( , TestData, , 0xFFFFFFFF, ,BurstWriteRead_1);
    TestData = TestData + 1;
  }

  WaitLoop(500);

} /* end of main */
/*-- --================================ End ================================--*/
