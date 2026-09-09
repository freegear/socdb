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
--  File Name              : BigEndHburstTest.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           To test functionality of SMC in BIGENDIAN mode.
--
-- --=========================================================================*/

/******************************************************************************/
/******************************** BIG ENDIAN CASE *****************************/
/******************************************************************************/

void BigEndHburstTest()
{
  /*
     Summary: BigEndHburstTest
     =========================
     This function performs the following:

     1. Configures different memory banks.
     2. Sets the BIGENDIAN pin input to 1.
     3. Perform write read sequences will all HBURST types with all combinations
        of HSIZE, MSIZE.
     4. Common Function Sequence is made use of and thus randomness in HTRANS is
        achieved.
     5. Finally make the BIGENDIAN pin zero.
  */
  int  i;
  int  Address, OffSet, OffSetEff;
  int  ReadData;
  char PrntStr[120];
  int  RandTrans[80];
  int  HSize, HBurst, BurstSize;
  char* BurstString[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};

  C("Configuring the SMC and the Memory banks.");
  HSA(SMCTrMWCS, NSEQ, INCR, OK, WRD);
  HSW(, 0x00);
  /** Apply Reset **/
  HSA(SMCTrREMAP, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x0);
  HSA(SMCTrREMAP, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x0);
  HSA(SMCTrREMAP, IDLE, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x0);
  C("Applying RESET");
  RES(LOW, , 1);
  /** Set Bank 0 Memory Type as BROM (8 bits width)   **/
  /** ExtWait disabled, RBLE set, Burst Mode set      **/
  /** Write protect NOT set, BM is not set for write. **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x7, 0x0, 0x00, 0x00, 0x00000001, 0x000000,
               0x000000);
  ConfigureMemory(0, 0x02, 0x7, 0x0, 0x40, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as BROM (16 bits width) **/
  /** ExtWait disabled, RBLE set, Burst mode set     **/
  /** Write Protect Bit and BM not set for write.    **/
  ConfigureUUT(1, 0x01, 0x05, 0x05, 0x00, 0x00, 0x00000041, 0x000000,
                  0x000000);
  ConfigureMemory(1, 0x01, 0x5, 0x5, 0x41, SMCTrMEMBData[0], 0x00,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as BROM (32 bits width) **/
  /** ExtWait disabled, RBLE set, Burst mode set     **/
  /** Write Protect Bit and BM is not set for write  **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x03, 0x0C, 0x00, 0x00, 0x01, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x03, 0x0C, 0x00, 0x42, SMCTrMEMBData[2], 0x00,
                  0x01, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (08 bits width) **/
  /** ExtWait disabled, RBLE set, Burst mode not set **/
  /** Write Protect Bit not set                      **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x01, 0x09, 0x03, 0x00, 0x03, 0x00000001, 0x000000,
               0x000000);
  ConfigureMemory(3, 0x01, 0x09, 0x03, 0x40, SMCTrMEMBData[2], 0x00,
                  0x03, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  /** ExtWait disabled, RBLE set, Burst mode not set **/
  /** Write Protect Bit not set                      **/
  SMCTrMEMBData[4] = 0x00000000;
  ConfigureUUT(4, 0x02, 0x08, 0x01, 0x00, 0x03, 0x00000041, 0x000000,
               0x000000);
  ConfigureMemory(4, 0x02, 0x08, 0x01, 0x41, SMCTrMEMBData[2], 0x00,
                  0x03, 0x000000);

  /** Set Bank 5 Memory Type as ROM  (32 bits width) **/
  /** ExtWait disabled, RBLE set, Burst mode not set **/
  /** Write Protect Bit not set to enable writes     **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x09, 0x04, 0x04, 0x00, 0x03, 0x00000081, 0x000000,
               0x000000);
  ConfigureMemory(5, 0x09, 0x04, 0x04, 0x42, SMCTrMEMBData[2], 0x00,
                  0x03, 0x000000);

  C("Configuring the System to BIG ENDIAN Mode");
  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x1);
  HSEN(DISABLE);

  for(OffSetEff=0; OffSetEff<4; OffSetEff++)
  {
  /* OffSet varies with the width of transactions. eg when OffSetEff is 2, */
  /* OffSet is 2 for byte transactions, 4 for hwrd and 8 for wrd */
    OffSet = OffSetEff;

  /* For all the HSize values read and write BROMs and other memories. */
    for(HSize=0; HSize<1; HSize++, OffSet=OffSet*2)
    {
    /* Loop of HBURST types, should vary from i=0 to i<8 */
      for(HBurst=0; HBurst<5; HBurst++)
      {
      /* Loop of Bank numbers, should vary from i=0 to i<6 */
        for(i=0; i<6; i++)
        {
          sprintf(PrntStr, "Reading from Bank %d, with HSize %d and HBurst %s", i,
                   HSize, BurstString[HBurst]);
          C(PrntStr);
          /* Generate an address at quadword boundary */
          Address=Memory_BASE+0x04000000*i + OffSet;
          /* Find out the burst size */
          BurstSize = GetBurstSize(HBurst);
          /* Generate a random sequnce */
          InitTransRnd(RandTrans, BurstSize);
          /* Write Read the memory */
          ReadData = random();
          Sequence('w', Address, RandTrans, BurstString[HBurst], HSize, ReadData, 1);
          Sequence('r', Address, RandTrans, BurstString[HBurst], HSize, ReadData, 1);
        } /* Bank */
      } /* HBurst */
    } /* HSize */
  } /* OffSetEff */
  C("Configuring the System to LITTLE ENDIAN Mode");
  HSEN(LITTLE);
  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x0);
}

