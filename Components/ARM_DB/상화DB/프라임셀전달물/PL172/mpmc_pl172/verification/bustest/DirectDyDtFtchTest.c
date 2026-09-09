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
-- File Name              : DirectDyDtFtchTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function tests the data integrity in certain cases, where the
--           MPMC directly passess the dynamic-memory data to the AHB, instead
--           of routing it through buffer.
--
--           TEST ID : MPMC_DIRECTDYDATA
--
-- --=======================================================================--*/
/******************************************************************************/
/******************************* DirectDyDtFtchTest ***************************/
/******************************************************************************/
void DirectDyDtFtchTest(void)
{
  /*
    Testbench used:
    ===============
      tbench.v

    Summary: DirectDyDtFtchTest
    ===========================
    o The normal flow of dynamic-memory-read-data is
      Pad interface --> Buffer --> AHB.
      For improving the AHB read latency, sometimes the Buffer is bypassed and
      data directly passed from pad-interface to AHB.
      The above mentioned bypass is done only in certain conditions.
      This test checks for the bypass happening in proper conditions.
  */
  int i,size,csel,chip,burst,msize;
  char debugstr[100];
  char *sizetype[] = {"BYTE", "HWRD","WRD"};
  unsigned long Addr, Data,LoBits,Bound;
 
  int trans0[6] = {2,2,2,2,2,5};
  int trans1[10] = {2,3,3,3,3,3,3,3,3,5};
  int trans2[5] = {2,3,3,3,5};
  int trans3[9] = {2,3,3,3,3,3,3,3,5};
  int trans4[17]= {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans5[2] = {2,5};
  int trans[500];
  C("TEST ID : MPMC_DIRECTDYDATA");

  /* Enable the MPMC */
  WriteData(MPMCControl, 0x00000001, "WRD");

  /* EBI back off will be asserted two clock after receiving the grant */
  WriteData(MPMCTrExBkOff, 0x00000002, "WRD");

  /****************************************************************************/
  /* Configuring the memory controller and the trickbox for static memory     */
  /* chip selects.                                                            */
  /* All the write protect bits are programmed as '1'.                        */
  /****************************************************************************/
  C("Initialize Bank0 registers");
  MPMCTrMEMBData[0] = 0x00000000;
  StInitProc(0,   /* chip-select number */
             0,   /* External memory data bus width */
             0,   /* Asynchronous page mode enable */
             0,   /* Chip select polarity */
             0,   /* Byte lane state */
             0,   /* Extended wait enable */
             1,   /* Read buffer enable */
             1,   /* Write buffer enable */
             1,   /* Write protect */
             0x3, /* StWtEn */
             0x3, /* StWtOen */
             0x4, /* StWtRd */
             0x7, /* StWtPg */
             0x5, /* StWtWr */
             0x5, /* StWtTurn */
             0x3);/* StExdDel */

  TrickMemInit(0,   /* chip-select number */
               0,   /* External memory data bus width */
               0,   /* Asynchronous page mode enable */
               0,   /* Chip select polarity */
               0,   /* Byte lane state */
               0,   /* Extended wait enable */
               1,   /* Read buffer enable */
               1,   /* Write buffer enable */
               1,   /* Write protect */
               0x3, /* StWtWen */
               0x3, /* StWtOen */
               0x4, /* StWtRd */
               0x7, /* StWtPg */
               0x5, /* StWtWr */
               0x5, /* StWtTurn */
               MPMCTrMEMBData[0], /* StMemb */
               0x0); /* cspol */

  C("Initialize Bank1 registers");
  /* Set Bank 1 Memory Type as SRAM (16 bits width) */
  MPMCTrMEMBData[1] = 0x00000000;
  StInitProc(1,   /* chip-select number */
             1,   /* External memory data bus width */
             0,   /* Asynchronous page mode enable */
             0,   /* Chip select polarity */
             1,   /* Byte lane state */
             0,   /* Extended wait enable */
             0,   /* Read buffer enable */
             0,   /* Write buffer enable */
             1,   /* Write protect */
             0x4, /* StWtEn */
             0x5, /* StWtOen */
             0x6, /* StWtRd */
             0x7, /* StWtPg */
             0x9, /* StWtWr */
             0x3, /* StWtTurn */
             0x3);/* StExdDel */
  TrickMemInit(1,   /* chip-select number */
               1,   /* External memory data bus width */
               0,   /* Asynchronous page mode enable */
               0,   /* Chip select polarity */
               1,   /* Byte lane state */
               0,   /* Extended wait enable */
               0,   /* Read buffer enable */
               0,   /* Write buffer enable */
               1,   /* Write protect */
               0x4, /* StWtWen */
               0x5, /* StWtOen */
               0x6, /* StWtRd */
               0x7, /* StWtPg */
               0x9, /* StWtWr */
               0x3, /* StWtTurn */
               MPMCTrMEMBData[1], /* StMemb */
               0x0); /* cspol */

  /* Set Bank 2 Memory Type as SRAM (32 bits width) */
  C("Initialize Bank2 registers");
  MPMCTrMEMBData[2] = 0x00000000;
  StInitProc(2,   /* chip-select number */
             2,   /* External memory data bus width */
             0,   /* Asynchronous page mode enable */
             0,   /* Chip select polarity */
             1,   /* Byte lane state */
             0,   /* Extended wait enable */
             1,   /* Read buffer enable */
             1,   /* Write buffer enable */
             1,   /* Write protect */
             0x4, /* StWtEn */
             0x5, /* StWtOen */
             0x6, /* StWtRd */
             0x7, /* StWtPg */
             0x9, /* StWtWr */
             0x0, /* StWtTurn */
             0x3);/* StExdDel */
  TrickMemInit(2,   /* chip-select number */
               2,   /* External memory data bus width */
               0,   /* Asynchronous page mode enable */
               0,   /* Chip select polarity */
               1,   /* Byte lane state */
               0,   /* Extended wait enable */
               1,   /* Read buffer enable */
               1,   /* Write buffer enable */
               1,   /* Write protect */
               0x4, /* StWtWen */
               0x5, /* StWtOen */
               0x6, /* StWtRd */
               0x7, /* StWtPg */
               0x9, /* StWtWr */
               0x0, /* StWtTurn */
               MPMCTrMEMBData[2], /* StMemb */
               0x0); /* cspol */

  /* Set Bank 3 Memory Type as SRAM (16 bits width) */
  C("Initialize Bank3 registers");
  MPMCTrMEMBData[3] = 0x00000000;
  StInitProc(3,   /* chip-select number */
             1,   /* External memory data bus width */
             0,   /* Asynchronous page mode enable */
             0,   /* Chip select polarity */
             1,   /* Byte lane state */
             0,   /* Extended wait enable */
             0,   /* Read buffer enable */
             0,   /* Write buffer enable */
             1,   /* Write protect */
             0x4, /* StWtEn */
             0x5, /* StWtOen */
             0x6, /* StWtRd */
             0x7, /* StWtPg */
             0x9, /* StWtWr */
             0x7, /* StWtTurn */
             0x3);/* StExdDel */
  TrickMemInit(3,   /* chip-select number */
               1,   /* External memory data bus width */
               0,   /* Asynchronous page mode enable */
               0,   /* Chip select polarity */
               1,   /* Byte lane state */
               0,   /* Extended wait enable */
               0,   /* Read buffer enable */
               0,   /* Write buffer enable */
               1,   /* Write protect */
               0x4, /* StWtWen */
               0x5, /* StWtOen */
               0x6, /* StWtRd */
               0x7, /* StWtPg */
               0x9, /* StWtWr */
               0x7, /* StWtTurn */
               MPMCTrMEMBData[3], /* StMemb */
               0x0); /* cspol */

  /****************************************************************************/
  /* Configuring the memory controller and mode initializing the memory for   */
  /* dynamic memory chip selects.                                             */
  /****************************************************************************/
  TimingInit(2,  /* tRP */
             6,  /* tRAS */
             8,  /* tSREX */
             5,  /* tAPR */
             6,  /* tDAL */
             2,  /* tWR */
             4,  /* tRDL */
             7,  /* tRC */
             7,  /* tRFC */
             4,  /* tXSR */
             2,  /* tRRD */
             3); /* tMRD */

  SyncInitializeProc(
  /* mode register parameters for dynamic-chip-select 4-7 */
  /* BrstLen BrstTyp CAS      RAS      Opmode WrBrstMod */
     3,      0,      2,       2,       0,     0,
     2,      0,      2,       2,       0,     0,
     3,      0,      2,       2,       0,     0,
     3,      0,      3,       3,       0,     0,
  /* memory controller parameters for dynamic-chip-select 4-7                 */
  /* Memory   Address map   Read    Write   Write   Col   Number   Row        */
  /* type     information   buffer  buffer  protect width of banks width      */
     0,       1,3,0,0,      1,      1,      0,      3,    1,       2,
     0,       2,2,0,1,      1,      1,      0,      2,    1,       1,
     0,       1,0,0,0,      1,      1,      0,      2,    0,       0,
     0,       1,1,0,0,      1,      1,      0,      2,    1,       1,
  /* others */
     12, /* no. of bits, by which LSB of Row Addr is offset, as per Addrmap */
     12, /* no. of bits, by which LSB of Row Addr is offset, as per Addrmap */
     10, /* no. of bits, by which LSB of Row Addr is offset, as per Addrmap */
     11, /* no. of bits, by which LSB of Row Addr is offset, as per Addrmap */
     0,  /* Big Endian */
     0); /* 1:2 clock ratio */

  /* Writing a number of data into dynamic memory chip-select-5 so that if    */
  /* read is initiated to the first address i.e. 0x50000000, the controller   */
  /* should not be able to fetch the data from the buffer.                    */
  Sequence('w',0x50000000,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x50000100,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x50000200,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x50000300,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x50000400,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x50000500,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x50000600,trans4,"inc",2,0xAAAAAAAA,0);
  Sequence('w',0x50000700,trans4,"inc",2,0xAAAAAAAA,0);

  /* Giving idle cycles, so that when the next dynamic request is raised,     */
  /* the timing of the request is immediately after the NSEQ phase.           */
  WaitLoop(0x1A);

  /* A static memory access is being done. It is expected that this will      */
  /* elicit an error response as all the banks are write protected.           */
  HSA(0x20000000, NSEQ, INCR4, ERROR, WRD);
  HSW(,0x0);

  /* Starting access to dynamic memory immediately after the error response   */
  /* is encountered because of previous static memory write.                  */
  HSA(0x50000000, NSEQ, INCR8, OK, HWRD);
  HSR(,0x0000AAAA, ,0x0000FFFF);
  HSR(,0xAAAA0000, ,0xFFFF0000);
  HSR(,0x0000AAAB, ,0x0000FFFF);
  HSR(,0xAAAA0000, ,0xFFFF0000);
  HSR(,0x0000AAAC, ,0x0000FFFF);
  HSR(,0xAAAA0000, ,0xFFFF0000);
  HSR(,0x0000AAAD, ,0x0000FFFF);
  HSR(,0xAAAA0000, ,0xFFFF0000);

} /* end of main */
/*-- --================================ End ================================--*/
