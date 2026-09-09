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
--  File Name              : ROMTests.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform different types of transfers.
--
-- --=========================================================================*/

/******************************************************************************/
/********************************* ROM Tests **********************************/
/******************************************************************************/

void ROMTests()
{
  /*
     Summary: ROM Tests
     ==================
     This function performs the following:

     o  Checks the operation of the SMC with different types of ROMs connected
        to different banks
  */

  int i;
  int32 MemAddr, ReadData, ReadData1, ReadData2, ReadData3, ReadData4;

  /** Set Bank 0 Memory Type as SRAM with Write Protection (16 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x05, 0x04, 0x02, 0x00, 0x00000050, 0x000000,
               0x000000);
  ConfigureMemory(1, 0x02, 0x05, 0x04, 0x001, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as ROM (32 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  ConfigureUUT(2, 0x03, 0x07, 0x00, 0x03, 0x00, 0x00000090, 0x000000,
               0x000000);
  ConfigureMemory(2, 0x03, 0x07, 0x00, 0x006, SMCTrMEMBData[2], 0x03,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as BROM (8 bits width) **/
  SMCTrMEMBData[4] = 0x00000000;
  ConfigureUUT(4, 0x04, 0x0B, 0x07, 0x04, 0x00, 0x00000030, 0x000000,
               0x000000);
  ConfigureMemory(4, 0x04, 0x0B, 0x07, 0x038, SMCTrMEMBData[4], 0x04,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as BROM (32 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  ConfigureUUT(6, 0x02, 0x0A, 0x08, 0x05, 0x00, 0x000000B0, 0x000000,
               0x000000);
  ConfigureMemory(6, 0x02, 0x0A, 0x08, 0x03A, SMCTrMEMBData[6], 0x05,
                  0x00, 0x000000);

  /** Initialise the ROMs from AHB side **/
  AHBWriteMem(1, 0, 32, 0x00007FFF);
  AHBWriteMem(2, 0, 16, 0x7FFFFFFF);
  AHBWriteMem(4, 0, 64, 0x0000007F);
  AHBWriteMem(6, 0, 16, 0x7FFFFFFF);

  /** Reading from Bank 0 SRAM **/
  C("Reading from Bank 0 SRAM");
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  ReadData1 = 0x00007FFF;
  ReadData2 = ReadData1 + 1;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  C("HSIZE = WORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_1);
  for (i=0, ReadData1+=2, ReadData2+=2; i<3; i++, ReadData1+=2, ReadData2+=2)
  {
    ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
    HSR( , ReadData, , NoMask, ,ROMTests_2);
  }

  C("HSIZE = HWRD, HBURST = INCR4");
  ReadData1 = 0x00007FFF+2;
  ReadData = ReadData1;
  HSA(MemAddr+4, NSEQ, INCR4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_3);
  ReadData1++;
  ReadData = ReadData1 << 16;
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_4);
  ReadData1++;
  ReadData = ReadData1;
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_5);
  ReadData1++;
  ReadData = ReadData1 << 16;
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_6);

  C("HSIZE = BYTE, HBURST = INCR8");
  ReadData1 = 0x00007FFF+4;
  ReadData = ReadData1 & BUnMask0;
  HSA(MemAddr+8, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_8);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_9);
  ReadData1++;
  ReadData = (ReadData1 << 16) & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_10);
  ReadData = (ReadData1 << 16) & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_11);
  ReadData1++;
  ReadData = ReadData1 & BUnMask0;
  HSR( , ReadData, , BUnMask0, ,ROMTests_13);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_14);
  ReadData1++;
  ReadData = (ReadData1 << 16) & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_15);
  ReadData = (ReadData1 << 16) & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_16);

  C("Reading from Bank 2 ROM");
  MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
  C("HSIZE = WORD, HBURST = INCR16");
  ReadData = 0x7FFFFFFF;
  HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_17);
  for (i=0, ReadData++; i<15; i++, ReadData++)
    HSR( , ReadData, , NoMask, ,ROMTests_18);

  C("HSIZE = HWRD, HBURST = WRAP4");
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_19);
  ReadData = ReadData1 & HWUnMaskB;
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_20);
  ReadData1++;
  ReadData = ReadData1 & HWUnMaskL;
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_21);
  ReadData = ReadData1 & HWUnMaskB;
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_22);

  C("HSIZE = BYTE, HBURST = WRAP8");
  ReadData1 = 0x80000000;
  ReadData = ReadData1 & BUnMask0;
  HSA(MemAddr+4, NSEQ, WRAP8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_23);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_24);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_25);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_26);
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & BUnMask0;
  HSR( , ReadData, , BUnMask0, ,ROMTests_27);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_28);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_29);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_30);

  C("Reading from Bank 4 BROM");
  MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11);
  C("HSIZE = WORD, HBURST = WRAP16");
  ReadData1 = 0x0000007F;
  ReadData2 = ReadData1+1;
  ReadData3 = ReadData2+1;
  ReadData4 = ReadData3+1;
  ReadData = ((ReadData4 << 24) & 0xFF000000) |
             ((ReadData3 << 16) & 0x00FF0000) |
             ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);
  HSA(MemAddr, NSEQ, WRAP16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_31);
  for (i=0, ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4; i<15; i++,
       ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4)
  {
    ReadData = ((ReadData4 << 24) & 0xFF000000) |
               ((ReadData3 << 16) & 0x00FF0000) |
               ((ReadData2 << 8) & 0x0000FF00) |
               (ReadData1 & 0x000000FF);
    HSR( , ReadData, , NoMask, ,ROMTests_32);
  }

  C("HSIZE = HWRD, HBURST = INCR");
  ReadData1 = 0x0000007F;
  ReadData2 = ReadData1+1;
  ReadData = ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_33);
  ReadData1+=2; ReadData2+=2;
  ReadData = ((ReadData2 << 24) & 0xFF000000) |
             ((ReadData1 << 16) & 0x00FF0000);
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_34);
  ReadData1+=2; ReadData2+=2;
  ReadData = ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_35);
  ReadData1+=2; ReadData2+=2;
  ReadData = ((ReadData2 << 24) & 0xFF000000) |
             ((ReadData1 << 16) & 0x00FF0000);
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_36);

  C("HSIZE = BYTE, HBURST = INCR4");
  ReadData1 = 0x0000007F;
  ReadData = ReadData1;
  HSA(MemAddr, NSEQ, INCR4, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_37);
  ReadData1++;
  ReadData = ReadData1 << 8;
  HSR( , ReadData, , BUnMask1, ,ROMTests_38);
  ReadData1++;
  ReadData = ReadData1 << 16;
  HSR( , ReadData, , BUnMask2, ,ROMTests_39);
  ReadData1++;
  ReadData = ReadData1 << 24;
  HSR( , ReadData, , BUnMask3, ,ROMTests_40);

  C("Reading from Bank 6 BROM");
  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  C("HSIZE = WORD, HBURST = INCR8");
  ReadData = 0x7FFFFFFF;
  HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_41);
  for (i=0, ReadData++; i<7; i++, ReadData++)
    HSR( , ReadData, , NoMask, ,ROMTests_42);

  C("HSIZE = HWRD, HBURST = INCR16");
  HSA(MemAddr, NSEQ, INCR16, OK, HWRD, , 0x1, , , , ,);
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & HWUnMaskL;
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_43);
  for (i=0; i<7; i++)
  {
    ReadData = ReadData1 & HWUnMaskB;
    HSR( , ReadData, , HWUnMaskB, ,ROMTests_44);
    ReadData1++;
    ReadData = ReadData1 & HWUnMaskL;
    HSR( , ReadData, , HWUnMaskL, ,ROMTests_45);
  }
  ReadData = ReadData1 & HWUnMaskB;
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_46);

  C("HSIZE = BYTE, HBURST = WRAP4");
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & BUnMask0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_47);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_48);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_49);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_50);

  /* ROMWriteRead(1, 4, 4, 2, 1, 0x11223344, 0x8001); */
  ROMWriteRead(2, 1, 0, 2, 2, 0x11223344, 0x7FFFFFFF);
  ROMWriteRead(4, 3, 2, 1, 0, 0x1122, 0x81);
  ROMWriteRead(6, 2, 0, 1, 2, 0x1122, 0x7FFFFFFF);

  /** Testing the Case when IDLE transfers are introduced after **/
  /** a set of read transactions where HSIZE < MSize, where after the **/
  /** first read the remaining data is given from the Internal Buffer **/

  C("Reading from Bank 2 ROM");
  MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11);
  C("HSIZE = BYTE, HBURST = WRAP8");
  ReadData1 = 0x80000000;
  ReadData = ReadData1 & BUnMask0;
  HSA(MemAddr+4, NSEQ, WRAP8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_51);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_52);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_53);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_54);
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & BUnMask0;
  HSR( , ReadData, , BUnMask0, ,ROMTests_55);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_56);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_57);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_58);

  C("HSIZE = BYTE, HBURST = SINGLE, Testing extra")
  HSA(0x00000000, IDLE, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000001, , BUnMask0, ,ROMTests_59);
  HSA(0x00000001, IDLE, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000001, , BUnMask0, ,ROMTests_60);
  HSA(0x00000002, IDLE, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000001, , BUnMask0, ,ROMTests_61);
  HSA(0x00000003, IDLE, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000001, , BUnMask0, ,ROMTests_62);

  C("Reading from Bank 4 BROM");
  MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11);
  C("HSIZE = WORD, HBURST = WRAP16");
  ReadData1 = 0x0000007F;
  ReadData2 = ReadData1+1;
  ReadData3 = ReadData2+1;
  ReadData4 = ReadData3+1;
  ReadData = ((ReadData4 << 24) & 0xFF000000) |
             ((ReadData3 << 16) & 0x00FF0000) |
             ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);
  HSA(MemAddr, NSEQ, WRAP16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_31);
  for (i=0, ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4; i<15; i++,
       ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4)
  {
    ReadData = ((ReadData4 << 24) & 0xFF000000) |
               ((ReadData3 << 16) & 0x00FF0000) |
               ((ReadData2 << 8) & 0x0000FF00) |
               (ReadData1 & 0x000000FF);
    HSR( , ReadData, , NoMask, ,ROMTests_63);
  }

}

/************************************ End *************************************/
