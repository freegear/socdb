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
--  File Name              : TransferTests.c.rca
--  File Revision          : 1.12
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Transfer Tests on the TIC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                                      Located in          ***/
/*** ---------------------------------------------------------------------- ***/
/*** WriteReadTests()                                   SmcCommon.c         ***/
/******************************************************************************/

/******************************************************************************/
/******************************* TransferTests ********************************/
/******************************************************************************/

void TransferTests()
{
  /*
     Summary: Transfer Tests
     =======================
     This function performs the following:

     o  Different possible vectors are applied to the TIC and the
        behaviour at the AHB side is monitored
  */

  int i;
  int Shift[3] = {8, 16, 32};
  int AddrIncr[3] = {1, 2, 4};
  int32 Addr, Data, ReadMask;
  int32 TestData[3] = {0x12345678, 0xAABBCCDD, 0x87654321};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  char hsize[3] = {'b', 'h', 'w'};

  for (i=0; i<3; i++)
  {
    TCV(0xF0000000, hsize[i], 1, 0, 0x2);
    WriteReadTests(TestData[i], Mask[i], 4, i);
  }

  /** Write followed by a Read - Address increment enabled **/
  Addr = GS_ARRAY1;
  TCV(0xF0000000, BYTE, 1, 0, 0x2);
  Data = TestData[2];
  HSA(Addr, NSEQ, INCR, , hsize[i], , 0x1, , , , ,);
  HSW( , ~Data);
  Data++;
  ReadMask = Mask[0] << Shift[0];
  HSR( , Data, , ReadMask, ,TransferTests_1);
  /** Verify the written data **/
  Data = TestData[2];
  HSA(Addr, NSEQ, INCR, , hsize[i], , 0x1, , , , ,);
  HSR( , ~Data, , Mask[0], ,TransferTests_2);

  /** Write followed by a Read - Address increment disabled **/
  for (i=0; i<3; i++)
  {
    TCV(0xF0000000, hsize[i], 0, 0, 0x2);
    Data = TestData[i];
    HSA(Addr, NSEQ, INCR, , hsize[i], , 0x1, , , , ,);
    HSW( , ~Data);
    HSR( , ~Data, , Mask[i], ,TransferTests_3);
  }

  /** Address boundary check **/
  TCV(0xF0000000, WRD, 1, 0, 0x2);
  Addr = GS_ARRAY1 + 0x2FC;
  Data = TestData[0];
  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ~Data);
  HSW( , Data);

  Data = ~TestData[0];
  HSA(Addr & 0xFFFFFC00, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData[0], , NoMask, ,TransferTests_4);
  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , Data, , NoMask, ,TransferTests_5);

  /** Read followed by a Write **/
  Addr = GS_ARRAY1;
  Data = ~TestData[1];
  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , Data);
  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , Data, , NoMask, ,TransferTests_6);
  HSA(Addr, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData[1]);
  HSA(Addr, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData[1]);

  /** Read followed by read with turn-arounds inserted/Verify the written **/
  /** data **/
  Data = TestData[1];
  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , Data, , NoMask, ,TransferTests_7);
  HSA(Addr, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSR( , Data, , MaskAll, ,TransferTests_8);
  HSA(Addr+4, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData[1], , NoMask, ,TransferTests_9);
}

/************************************ End *************************************/
