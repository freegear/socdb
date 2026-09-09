/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Cornercase3.c.rca
--  File Revision          : 1.6
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests to check the operation of the SMC with
--           write of HSIZE<MSIZE operation followed by Register accesses followed
--           by Busys inserted. This is followed by INCR write with HSIZE<MSIZE
--         
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** BURST ROM Tests *******************************/
/******************************************************************************/

void Cornercase3()
{
  /*
     Summary: BURST Mode Wait state tests
     ========================
     This function performs the following:

     o  A Wrap8 write is done with HSIZE< MSIZE combination. This is followed
        a few register reads and then a few Busys. An INCR write is done with
        HSIZE<MSIZE combination
        write and read to the different bank
     o  Performs BURST and Non-BURST reads from the memory banks through the
        SMC using different HSIZE WST1, WST2 and HBURST values

  */

  int i;
  int WST1, WST2, Burst, HSIZE, WriteData, Address;
  char HBURST;
  int32 TestData, MemAddr, ReadData, ReadMask;
  int32 TempData1, TempData2, TempData3, TempData4;
  int32 UnMask[4] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF, 0x00000000};
  int32 Offset;
  int trans[7] = {2,3,3,3,3,3,5};
  int trans11[29] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};


  /** Set Bank 1 Memory Type as SRAM (32 bits width) with burst mode enabled **/
     SMCTrMEMBData[1] = 0x00000000;
     ConfigureUUT(1, 0x01, 0x0A, 0x0A, 0x00, 0x00, 0x00000080, 0x000000,
                  0x000000);
     ConfigureUUT(0, 0x02, 0x07, 0x05, 0x00, 0x00, 0x00000000, 0x000000,
                  0x000000);

  C("WRAP8 write access with HSIZE = 8 MSIZE = 32 and WST1=WST2=0x0A");
  Address = 0x04052EC4;
  Sequence('w',Address, trans,"wr8",0,0x10023404,0);

  C("Trickmem access");
  HSA(SMCTrMEMT_1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x40000000);

  HSA(SMCTrMEMT_1, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x50000000);

  C("Register Read access");
  Address = 0x20000000 + 0xFE0;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , , , UnMask[3], ,TransferTests_34);
  Address = 0x20000000 + 0xFE4;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , , , UnMask[3], ,TransferTests_34);
  Address = 0x20000000 + 0xFE8;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , , , UnMask[3], ,TransferTests_34);
  Address = 0x20000000 + 0xFEC;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , , , UnMask[3], ,TransferTests_34);
  Address = 0x20000000 + 0xFF0;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , , , UnMask[3], ,TransferTests_34);
  Address = 0x20000000 + 0xFF0;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , , , UnMask[3], ,TransferTests_34);
  Address = 0x20000000 + 0xFF0;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , , , UnMask[3], ,TransferTests_34);
  Address = 0x20000000 + 0xFF0;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , , , UnMask[3], ,TransferTests_34);


  C("NSEQ,BUSY,BUSY,SEQ access to trickmem");
  Address = 0x44000000 + 0x8000;
  HSA(Address, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x40000000);
  Address = 0x44000000 + 0x8004;
  HSA(Address, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x50000000);
  Address = 0x44000000 + 0x8004;
  HSA(Address, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x50000000);
  Address = 0x44000000 + 0x8004;
  HSA(Address, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x50000000);
  Address = 0x44000000 + 0x8004;
  HSA(Address, BUSY, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x50000000);
  Address = 0x44000000 + 0x8004;
  HSA(Address, SEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x50000000);


  C("INCR16 write access with HSIZE = 8 MSIZE = 32 and WST1=WST2=0x0A");
  Address = 0x0407532D;
  Sequence('w',Address, trans11,"i16",0,0x10023404,0);





}


/************************************ End *************************************/
