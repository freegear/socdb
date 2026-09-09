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
--  File Name              : BROMCornerCase.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests on external wait functionality of the
--           SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/******************************** BROM Corner Case ****************************/
/******************************************************************************/

void BROMCornerCase()
{
  /*
     Summary: BROMCornerCase
     =======================
     This function performs the following:

     1. Reads from Burst Mode device with HSIZE < MSIZE with all types of bursts. 
        All HSIZE-MSIZE combinations with all the burst types, with WSTOEN = 0 
        and non zero values.
     2. Reads from Burst Mode device with Busys and idles inserted at various 
        positions.
  */
  FILE *Log;
  int  i, j;
  int  Address, OffSet;
  int  WrData[8], ReadData, ReadData0, ReadData1, ReadData2, ReadData3;
  char PrntStr[120];
  int  RandTrans[80], TempTrans[2];
  int  HSize, HBurst, BurstSize;
  char* BurstString[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};

  ApplyReset();

  Log = fopen("Log", "w");

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

/* Initialise the memory */
  WrData[0] = 0x00;
  WrData[1] = 0x11;
  WrData[2] = 0x22;
  WrData[3] = 0x33;
  WrData[4] = 0x44;
  WrData[5] = 0x55;
  WrData[6] = 0x66;
  WrData[7] = 0x77;
  
  RandTrans[0] = 2;
  for(i=1; i<78; RandTrans[i++]=3);
  RandTrans[i] = 5;

  Sequence('w', SMCMEM_0, RandTrans, "incr", 0, WrData[0], 0);
  Sequence('w', SMCMEM_1, RandTrans, "incr", 0, WrData[1], 0);
  Sequence('w', SMCMEM_2, RandTrans, "incr", 0, WrData[2], 0);
  Sequence('w', SMCMEM_3, RandTrans, "incr", 0, WrData[3], 0);
  Sequence('w', SMCMEM_4, RandTrans, "incr", 0, WrData[4], 0);
  Sequence('w', SMCMEM_5, RandTrans, "incr", 0, WrData[5], 0);
/*Sequence('w', SMCMEM_6, RandTrans, "incr", 0, WrData[6], 0);
*/Sequence('w', SMCMEM_7, RandTrans, "incr", 0, WrData[7], 0);


/* Now set the BM / WP bits of selected memories. */
/* Bank 0 - BM, RBLE */
  HSA(SMBCR0, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x21);
  HSA(SMCTrMEMT_0, NSEQ, INCR, OK, WRD);
  HSW(, 0x48);
/* Bank 1 - BM, RBLE, WP, 16 bit */
  HSA(SMBCR1, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x71);
  HSA(SMCTrMEMT_1, NSEQ, INCR, OK, WRD);
  HSW(, 0x4D);
/* Bank 2 - BM, RBLE, WP, 32 bit */
  HSA(SMBCR2, NSEQ, SINGLE, OK, WRD);
  HSW(, 0xB1);
  HSA(SMCTrMEMT_2, NSEQ, INCR, OK, WRD);
  HSW(, 0x4E);
/* Bank 5 - RBLE, WP, 32bit */
  HSA(SMBCR5, NSEQ, SINGLE, OK, WRD);
  HSW(, 0x91);
  HSA(SMCTrMEMT_5, NSEQ, INCR, OK, WRD);
  HSW(, 0x46);

/* OffSet is 2 for byte transactions, 4 for hwrd and 8 for wrd */
  OffSet = 2;

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
        /* Read the memory */
        if(HSize==0)
        {
          ReadData = (WrData[i]+OffSet) & 0xFF;
          Sequence('r', Address, RandTrans, BurstString[HBurst], HSize, ReadData, 0);
        }
        if(HSize == 1)
        {
          /* Cread the read expected data */
          /* we have written 0x14131211 and so on so if the OffSet is 2 we have
           * to read 0x1413 */
          ReadData0 = (WrData[i]+OffSet) & 0xFF;
          for(j=0; RandTrans[j]<5; j++)
          {
            /* Generate new expected data */
            if(RandTrans[j] > 1)
            {
              ReadData1 = ReadData0+1;
              ReadData = (ReadData0 | ReadData1<<8);
            }
            TempTrans[0] = RandTrans[j];
            TempTrans[1] = 5;
            /* File printing for debugging - remove it after the test passes. */
            /*TODO*/
            fprintf(Log, "Address = %x, ReadData = %x, HTrans = %x\n", 
                          Address, ReadData, RandTrans[j]);
            Sequence('r', Address, TempTrans, BurstString[HBurst], HSize,
            ReadData, 0);

            /* Generate the new address */
            if(RandTrans[j] > 1)
            {
              Address   = Address   + 2;
              ReadData0 = ReadData1 + 1;
            }
          }
        }
        if(HSize == 2)
        {
          /* Cread the read expected data */
          /* we have written 0x14131211 and so on so if the OffSet is 1 we have
           * to read 0x18171615 */
          ReadData0 = (WrData[i]+OffSet) & 0xFF;
          for(j=0; RandTrans[j]<5; j++)
          {
            /* Generate new expected data */
            if(RandTrans[j] > 1)
            {
              ReadData1 = ReadData0+1;
              ReadData2 = ReadData0+2;
              ReadData3 = ReadData0+3;
              ReadData = ReadData0 | (ReadData1<<8) | (ReadData2<<16) |
                         (ReadData3<<24);
            }
            TempTrans[0] = RandTrans[j];
            TempTrans[1] = 5;

            Sequence('r', Address, TempTrans, BurstString[HBurst], HSize,
            ReadData, 0);

            /* Generate the new address */
            if(RandTrans[j] > 1)
            {
              Address   = Address   + 4;
              ReadData0 = ReadData3 + 1;
            }
          }
        }
      }
    }
  }
  fclose(Log);
}

