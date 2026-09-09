/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : ROMTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
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

     o  Checks the operation of the SSMC with different types of ROMs connected
        to different banks
  */

  int i;
  int32 MemAddr, ReadData, ReadData1, ReadData2, ReadData3, ReadData4;
  int32 WTCNCLData, ExtMuxData, SMBLSPOLData;

  /*
      Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
      CLKSTATUS defined in the Ssmc.h set the required  MemClkRatio and
      SMClockEn field bits.
  */
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);

  /*
      Programming the SSMCTrBurstWT register to turn the mask ON/OFF and to
      set the BeatNo and BurstWT counts. The constants BWtMask_ON/OFF,
      Beat0 to 15 and SSMCTrBurstWT0 to 15 are defined in Ssmc.h.
  */
  SSMCTrBurstWTData = BWtMask_ON | Beat15 | SSMCTrBurstWT15;
  ConfigureBurstWT(SSMCTrBurstWTData);

  /*
      Programming the SSMCTrWTCNCL register. The constant SMWTCNCLDI/EN
      disables or Enables the SMCANCELWait signal. The constant SMWAITIGNORE_0/1
      enables or disables the SMWAITIGNORE respectively and the constants
      WTCNCL0 to 63 are used to load the CANCEL WAIT count.
  */
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL10 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Configuring the system to LITTLE endian mode by setting ENDIANNESS = 0 **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);
  HSEN(LITTLE);

  /*
      Programming the SSMCTrExtMuxWT register.The constant ExtMuxDI/EN disables
      or enables the  External Mux. The constants ExtMuxAss0 to 15 and
      ExtMuxDAss0 to 15 define the Assertion and Deassertion counts.
  */
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SMBLSPOLData);

  /** Set Bank 0 Memory Type as SRAM with Write Protection (16 bits width) **/
  SSMCTrMEMBData[0] = 0x00000000;

  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY2, WSTRD5, WSTWR4, WSTOEN2, WSTWEN0, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  /** Set Bank 2 Memory Type as ROM (32 bits width) **/
  SSMCTrMEMBData[2] = 0x00000000;
  
  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |   
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY3, WSTRD7, WSTWR0, WSTOEN3, WSTWEN0, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 4 Memory Type as BROM (8 bits width) **/
  SSMCTrMEMBData[4] = 0x00000000;
  SMBCRData[4] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        | 
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW8            | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY4, WSTRD11, WSTWR7, WSTOEN4, WSTWEN0, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 6 Memory Type as BROM (32 bits width) **/
  SSMCTrMEMBData[6] = 0x00000000;

  SMBCRData[6] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   | 
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_EN          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK6, WSTIDCY2, WSTRD10, WSTWR8, WSTOEN5, WSTWEN0, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);

  /** Initialise the ROMs from AHB side **/
  AHBWriteMem(0, 0, 32, 0x00007FFF);
  AHBWriteMem(2, 0, 16, 0x7FFFFFFF);
  AHBWriteMem(4, 0, 64, 0x0000007F);
  AHBWriteMem(6, 0, 16, 0x7FFFFFFF);

  /** Reading from Bank 0 ROM **/
  MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
  ReadData1 = 0x00007FFF;
  ReadData2 = ReadData1 + 1;
  ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
  C("READ ACCESS TO ROM BANK 0: HSIZE = WORD, MSIZE = HWORD, HBURST = INCR");
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_1);
  for (i=0, ReadData1+=2, ReadData2+=2; i<3; i++, ReadData1+=2, ReadData2+=2)
  {
    ReadData = (ReadData2 << 16) | (ReadData1 & 0x0000FFFF);
    HSR( , ReadData, , NoMask, ,ROMTests_2);
  }

  C("READ ACCESS TO ROM BANK 0: HSIZE = HWRD, MSIZE = HWORD, HBURST = INCR4");
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

  C("READ ACCESS TO ROM BANK 0: HSIZE = BYTE, MSIZE = HWORD, HBURST = INCR8");
  ReadData1 = 0x00007FFF+4;
  ReadData = ReadData1 & BUnMask0;
  HSA(MemAddr+8, NSEQ, INCR8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_7);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_8);
  ReadData1++;
  ReadData = (ReadData1 << 16) & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_9);
  ReadData = (ReadData1 << 16) & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_10);
  ReadData1++;
  ReadData = ReadData1 & BUnMask0;
  HSR( , ReadData, , BUnMask0, ,ROMTests_11);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_12);
  ReadData1++;
  ReadData = (ReadData1 << 16) & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_13);
  ReadData = (ReadData1 << 16) & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_14);

  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  C("READ ACCESS TO ROM BANK 2: HSIZE = WORD, MSIZE = WORD, HBURST = INCR16");
  ReadData = 0x7FFFFFFF;
  HSA(MemAddr, NSEQ, INCR16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_15);
  for (i=0, ReadData++; i<15; i++, ReadData++)
    HSR( , ReadData, , NoMask, ,ROMTests_16);

  C("READ ACCESS TO ROM BANK 2: HSIZE = HWRD, MSIZE = WORD, HBURST = WRAP4");
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & HWUnMaskL;
  HSA(MemAddr, NSEQ, WRAP4, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_17);
  ReadData = ReadData1 & HWUnMaskB;
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_18);
  ReadData1++;
  ReadData = ReadData1 & HWUnMaskL;
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_19);
  ReadData = ReadData1 & HWUnMaskB;
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_20);

  C("READ ACCESS TO ROM BANK 2: HSIZE = BYTE, MSIZE = WORD, HBURST = WRAP8");
  ReadData1 = 0x80000000;
  ReadData = ReadData1 & BUnMask0;
  HSA(MemAddr+4, NSEQ, WRAP8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_21);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_22);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_23);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_24);
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & BUnMask0;
  HSR( , ReadData, , BUnMask0, ,ROMTests_25);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_26);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_27);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_28);

  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  C("READ ACCESS TO BROM BANK 4: HSIZE = WORD, MSIZE = BYTE, HBURST = WRAP16");
  ReadData1 = 0x0000007F;
  ReadData2 = ReadData1+1;
  ReadData3 = ReadData2+1;
  ReadData4 = ReadData3+1;
  ReadData = ((ReadData4 << 24) & 0xFF000000) |
             ((ReadData3 << 16) & 0x00FF0000) |
             ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);
  HSA(MemAddr, NSEQ, WRAP16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_29);
  for (i=0, ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4; i<15; i++,
       ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4)
  {
    ReadData = ((ReadData4 << 24) & 0xFF000000) |
               ((ReadData3 << 16) & 0x00FF0000) |
               ((ReadData2 << 8) & 0x0000FF00) |
               (ReadData1 & 0x000000FF);
    HSR( , ReadData, , NoMask, ,ROMTests_30);
  }

  C("READ ACCESS TO BROM BANK 4: HSIZE = HWRD, MSIZE = BYTE, HBURST = INCR");
  ReadData1 = 0x0000007F;
  ReadData2 = ReadData1+1;
  ReadData = ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_31);
  ReadData1+=2; ReadData2+=2;
  ReadData = ((ReadData2 << 24) & 0xFF000000) |
             ((ReadData1 << 16) & 0x00FF0000);
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_32);
  ReadData1+=2; ReadData2+=2;
  ReadData = ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_33);
  ReadData1+=2; ReadData2+=2;
  ReadData = ((ReadData2 << 24) & 0xFF000000) |
             ((ReadData1 << 16) & 0x00FF0000);
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_34);

  C("READ ACCESS TO BROM BANK 4: HSIZE = BYTE, MSIZE = BYTE, HBURST = INCR4");
  ReadData1 = 0x0000007F;
  ReadData = ReadData1;
  HSA(MemAddr, NSEQ, INCR4, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_35);
  ReadData1++;
  ReadData = ReadData1 << 8;
  HSR( , ReadData, , BUnMask1, ,ROMTests_36);
  ReadData1++;
  ReadData = ReadData1 << 16;
  HSR( , ReadData, , BUnMask2, ,ROMTests_37);
  ReadData1++;
  ReadData = ReadData1 << 24;
  HSR( , ReadData, , BUnMask3, ,ROMTests_38);

  MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
  C("READ ACCESS TO BROM BANK 6: HSIZE = WORD, MSIZE = WORD, HBURST = INCR8");
  ReadData = 0x7FFFFFFF;
  HSA(MemAddr, NSEQ, INCR8, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_39);
  for (i=0, ReadData++; i<7; i++, ReadData++)
    HSR( , ReadData, , NoMask, ,ROMTests_40);

  C("READ ACCESS TO BROM BANK 6: HSIZE = HWRD, MSIZE = WORD, HBURST = INCR16");
  HSA(MemAddr, NSEQ, INCR16, OK, HWRD, , 0x1, , , , ,);
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & HWUnMaskL;
  HSR( , ReadData, , HWUnMaskL, ,ROMTests_41);
  for (i=0; i<7; i++)
  {
    ReadData = ReadData1 & HWUnMaskB;
    HSR( , ReadData, , HWUnMaskB, ,ROMTests_42);
    ReadData1++;
    ReadData = ReadData1 & HWUnMaskL;
    HSR( , ReadData, , HWUnMaskL, ,ROMTests_43);
  }
  ReadData = ReadData1 & HWUnMaskB;
  HSR( , ReadData, , HWUnMaskB, ,ROMTests_44);

  C("READ ACCESS TO BROM BANK 6: HSIZE = BYTE, MSIZE = WORD, HBURST = WRAP4");
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & BUnMask0;
  HSA(MemAddr, NSEQ, WRAP4, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_45);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_46);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_47);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_48);

/*  ROMWriteRead(1, 4, 4, 2, 1, 0x11223344, 0x8001); */
  ROMWriteRead(2, 1, 0, 2, 2, 0x11223344, 0x7FFFFFFF);
  ROMWriteRead(4, 3, 2, 1, 0, 0x1122, 0x81);
  ROMWriteRead(6, 2, 0, 1, 2, 0x1122, 0x7FFFFFFF);

  /** Testing the Case when IDLE transfers are introduced after **/
  /** a set of read transactions where HSIZE < MSize, where after the **/
  /** first read the remaining data is given from the Internal Buffer **/

  MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
  C("READ ACCESS TO BROM BANK 2: HSIZE = BYTE, MSIZE = WORD, HBURST = WRAP8");
  ReadData1 = 0x80000000;
  ReadData = ReadData1 & BUnMask0;
  HSA(MemAddr+4, NSEQ, WRAP8, OK, BYTE, , 0x1, , , , ,);
  HSR( , ReadData, , BUnMask0, ,ROMTests_49);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_50);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_51);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_52);
  ReadData1 = 0x7FFFFFFF;
  ReadData = ReadData1 & BUnMask0;
  HSR( , ReadData, , BUnMask0, ,ROMTests_53);
  ReadData = ReadData1 & BUnMask1;
  HSR( , ReadData, , BUnMask1, ,ROMTests_54);
  ReadData = ReadData1 & BUnMask2;
  HSR( , ReadData, , BUnMask2, ,ROMTests_55);
  ReadData = ReadData1 & BUnMask3;
  HSR( , ReadData, , BUnMask3, ,ROMTests_56);

  C("READ ACCESS TO BANK 2 ROM: HSIZE = BYTE, MSIZE = WORD, HBURST = SINGLE"); 
  C("EXTRA TESTING")
  HSA(0x00000000, IDLE, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000001, , BUnMask0, ,ROMTests_57);
  HSA(0x00000001, IDLE, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000001, , BUnMask0, ,ROMTests_58);
  HSA(0x00000002, IDLE, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000001, , BUnMask0, ,ROMTests_59);
  HSA(0x00000003, IDLE, SINGLE, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x00000001, , BUnMask0, ,ROMTests_60);

  MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
  C("READ ACCESS TO BROM BANK 4: HSIZE = WORD, MSIZE = BYTE, HBURST = WRAP16");
  ReadData1 = 0x0000007F;
  ReadData2 = ReadData1+1;
  ReadData3 = ReadData2+1;
  ReadData4 = ReadData3+1;
  ReadData = ((ReadData4 << 24) & 0xFF000000) |
             ((ReadData3 << 16) & 0x00FF0000) |
             ((ReadData2 << 8) & 0x0000FF00) |
             (ReadData1 & 0x000000FF);
  HSA(MemAddr, NSEQ, WRAP16, OK, WRD, , 0x1, , , , ,);
  HSR( , ReadData, , NoMask, ,ROMTests_61);
  for (i=0, ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4; i<15; i++,
       ReadData1+=4, ReadData2+=4, ReadData3+=4, ReadData4+=4)
  {
    ReadData = ((ReadData4 << 24) & 0xFF000000) |
               ((ReadData3 << 16) & 0x00FF0000) |
               ((ReadData2 << 8) & 0x0000FF00) |
               (ReadData1 & 0x000000FF);
    HSR( , ReadData, , NoMask, ,ROMTests_62);
  }

}

/************************************ End *************************************/
