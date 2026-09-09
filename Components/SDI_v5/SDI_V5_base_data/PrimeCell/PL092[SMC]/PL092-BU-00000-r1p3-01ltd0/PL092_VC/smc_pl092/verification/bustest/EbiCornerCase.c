/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : EbiCornerCase.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--
--          Checks Ebi of Smc
-- --=========================================================================*/

/******************************************************************************/
/****************************** Ebi Corner Case *******************************/
/******************************************************************************/

void EbiCornerCase()
{
  /*
     Summary: BURST Mode Wait state tests
     ========================
     This function performs the following:

     o  This test does the different types of Burst reads followed by a single 
        write and read to the same bank
     o  Performs BURST and Non-BURST reads from the memory banks through the
        SMC using different HSIZE WST1, WST2 and HBURST values
  */
#define SEQ1
#define SEQ2
#define EBIISSUE

  int i, HSIZE;
  int WST1, WST2, Burst;
  int Val,Val1,Val2,ExtBusMux;
  char HBURST;
  int32 TestData, MemAddr, ReadData, ReadMask, WriteData;
  int32 TempData1, TempData2, TempData3, TempData4;
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int32 Address;
  C(" Configure the memory");
  WST1 = 2;
  WST2 = 0;
  HSIZE = 1;
  Burst = 7;

  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** CSPol = 0, ExtWait disabled **/
  C("Configuring the SMC and the Memory Blocks");
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[2] = 0x00007FFF;
  ConfigureUUT(2, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00000000, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x00, 0x00, 0x00, 0x000, SMCTrMEMBData[2], 0x00,
                  0x00, 0x000000);


    ExtBusMux = 0x1;
    Val1 = 0x0;
    Val2 = 0x1;
    Val  = Val1 | (Val2 << 0x5) | (ExtBusMux << 0x0b);
    HSA(SMCTrEBICntl, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
    HSW( , Val);
#ifdef SEQ1
    C("NSEQ-SEQ-IDLE");
    Address = 0x00000000;
    HSA(Address, NSEQ, INCR, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0x55);

    Address = 0x00000001;
    HSA(Address, SEQ, INCR, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0xAA);

    Address = 0x00000002;
    HSA(Address, IDLE, INCR, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0x11);


    WaitLoop(0x15);

    Address = 0x00000000;
    HSA(Address, NSEQ, INCR,OK, WRD);
    HSR(, 0x0000AA55, ,0x0000FFFF);

    WaitLoop(0x15);
#endif

#ifdef SEQ2
    C("NSEQ-SEQ-NSEQ");
    Val1 = 0x0;
    Val2 = 0x1;
    Val  = Val1 | (Val2 << 0x5) | (ExtBusMux << 0x0b);
    HSA(SMCTrEBICntl, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
    HSW( , Val);

    Address = 0x00000000;
    HSA(Address, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0x55);

    Address = 0x00000001;
    HSA(Address, SEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0xAA);


    Address = 0x00000004;
    HSA(Address, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0xAA);


    Address = 0x00000005;
    HSA(Address, SEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0xAA);


    Address = 0x00000006;
    HSA(Address, IDLE, INCR8, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0x11);

    WaitLoop(0x15);

    Address = 0x00000000;
    HSA(Address, NSEQ, INCR,OK, WRD);
    HSR(, 0x0000AA55, ,0x0000FFFF);

    WaitLoop(0x15);
#endif
#ifdef EBIISSUE
  for (HSIZE = 0, TestData = 0xA0000000; HSIZE < 3; HSIZE++)
    for (Burst = 3; Burst >= 0; Burst--)
    {
      TestData += 0x5555;
      WriteData = TestData & UnMask[HSIZE];
      MemWriteRead(2, Burst, 0x00, HSIZE, 0, WriteData);
    }
  WaitLoop(0x55); 
#endif
}


/************************************ End *************************************/
