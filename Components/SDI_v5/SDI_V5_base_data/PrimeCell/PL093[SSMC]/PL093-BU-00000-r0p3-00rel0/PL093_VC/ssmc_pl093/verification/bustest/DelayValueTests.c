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
--  File Name              : DelayValueTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Chip Select to Output Enable assertion and
--           Chip Select to Write Enable assertion Tests on the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/****************** CS to OEN and CS to WEN assertion Tests *******************/
/******************************************************************************/

void DelayValueTests()
{
  /*
     Summary: CS to OEN and CS to WEN assertion Tests
     ================================================
     This function performs the following:

     o  Programs CS2OEN and CS2WEN registers of Memory banks with different
        values
     o  Does all combinations of BURST reads, Non-BURST reads and writes as
        mentioned below:
        - Read followed by BURST reads to same and different banks
        - Read followed by writes to same and different banks
        - BURST read followed by reads to same and different banks
        - BURST read followed by writes to same and different banks
        - Write followed by reads to same and different banks
        - Write followed by BURST reads to same and different banks
  */

  int i, j, k, x;
  int32 TestCS2OEN[4] = {0x00, 0x05, 0x09, 0x0B};
  int32 TestCS2WEN[4] = {0x00, 0x05, 0x09, 0x0B};
  int32 TestRead, TestWrite, MemAddr, MemAddr1,
        TestData, WTCNCLData, ExtMuxData, SMBLSPOLData;
  char Message[100];


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

  /** Configuring the Memory Banks and the SSMC **/
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[0] = 0x00007FFF;

  SMBCRData[0] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | CRSYNCENWR_ASY |
                 CRSYNCENRD_ASY   | CRBURSTLENWR4    | CRBURSTLENRD4  |
                 CRBMWRITE_EN     | CRBMREAD_EN      | CRMW32         |
                 CRWP_DI          | CRWAITEN_DI      | CRWAITPOL_0    |
                 BIWRITE_DI       | BIREAD_DI        | RBLE_1;

  SSMCTrCS2WTRData[0] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  /** Set Bank 1 Memory Type as SRAM (16 bits width) **/
  SSMCTrMEMBData[1] = 0x00000000;
  
  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | CRSYNCENWR_ASY |
                 CRSYNCENRD_ASY   | CRBURSTLENWR4    | CRBURSTLENRD4  |
                 CRBMWRITE_EN     | CRBMREAD_EN      | CRMW16         |
                 CRWP_DI          | CRWAITEN_EN      | CRWAITPOL_0    |
                 BIWRITE_DI       | BIREAD_DI        | RBLE_1;

  SSMCTrCS2WTRData[1] = TRWAITEN_EN | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);


  /** Set Bank 2 Memory Type as SRAM (8 bits width) **/
  SSMCTrMEMBData[2] = 0x00007FFF;

  SMBCRData[2] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | CRSYNCENWR_ASY |
                 CRSYNCENRD_ASY   | CRBURSTLENWR4    | CRBURSTLENRD4  |
                 CRBMWRITE_EN     | CRBMREAD_EN      | CRMW8          |
                 CRWP_DI          | CRWAITEN_DI      | CRWAITPOL_1    |
                 BIWRITE_DI       | BIREAD_DI        | RBLE_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);
  
  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI | CRSYNCENWR_ASY |
                 CRSYNCENRD_ASY   | CRBURSTLENWR4    | CRBURSTLENRD4  |
                 CRBMWRITE_EN     | CRBMREAD_EN      | CRMW32         |
                 CRWP_DI          | CRWAITEN_EN      | CRWAITPOL_1    |
                 BIWRITE_DI       | BIREAD_DI        | RBLE_1;

  SSMCTrCS2WTRData[3] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);


  TestRead = 0x00111111;
  TestWrite = 0x00222222;
  x = 1;
  for (i=0; i<4; i++)
  {
    /** Reconfiguring the CS2OEN Register **/
    /** Reconfiguring SMBWSTOENR0 & SMBWSTRDR0 **/
    HSA(SMBWSTOENR0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestCS2OEN[i]);
    HSA(SMBWSTRDR0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestCS2OEN[i]);

    k = (i+1)%4;
    /** Reconfiguring SMBWSTOENR1 & SMBWSTRDR1 **/
    HSA(SMBWSTOENR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestCS2OEN[k]);
    HSA(SMBWSTRDR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestCS2OEN[k]);

    k = (i+2)%4;
    /** Reconfiguring SMBWSTOENR2 & SMBWSTRDR2 **/
    HSA(SMBWSTOENR2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestCS2OEN[k]);
    HSA(SMBWSTRDR2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestCS2OEN[k]);

    k = (i+3)%4;
    /** Reconfiguring SMBWSTOENR3 & SMBWSTRDR3 **/
    HSA(SMBWSTOENR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestCS2OEN[k]);
    HSA(SMBWSTRDR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( ,TestCS2OEN[k]);
  
    for (j=0; j<4; j++)
    {

      sprintf(Message,"               TESTCASE SET = %d ", x);
      C(Message);

      /** Reconfiguring the CS2WEN Register **/ 
      /** Reconfiguring SMBWSTWENR0 & SMBWSTWRR0 **/
      HSA(SMBWSTWENR0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestCS2OEN[j]);
      HSA(SMBWSTWRR0, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestCS2WEN[j]);
  
      k = (j+1)%4;
      /** Reconfiguring SMBWSTWENR1 & SMBWSTWRR1 **/
      HSA(SMBWSTWENR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestCS2WEN[k]);
      HSA(SMBWSTWRR1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestCS2WEN[k]);
  
      k = (j+2)%4;
      /** Reconfiguring SMBWSTWENR2 & SMBWSTWRR2 **/
      HSA(SMBWSTWENR2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestCS2WEN[k]);
      HSA(SMBWSTWRR2, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestCS2WEN[k]);
  
      k = (j+3)%4;
      /** Reconfiguring SMBWSTWENR3 & SMBWSTWRR3 **/
      HSA(SMBWSTWENR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestCS2WEN[k]);
      HSA(SMBWSTWRR3, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestCS2WEN[k]);
  
      /** Does BURST Transfers **/
      sprintf(Message,"BURST WRITES FOLLOWED BY BURST READS TO THE SAME BANK");
      msg_info(Message);
      AHBWriteMem(0, 0x1FE0, 8, TestRead);
      TestData = TestWrite;
      MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 0x7C0;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestData++);
      for (k=0; k<7; k++)
        HSW( ,TestData++);

      TestData = TestRead;
      HSA(MemAddr+32, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_1);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_2);

      sprintf(Message,"BURST READS FOLLOWED BY BURST WRITES TO THE SAME BANK");
      msg_info(Message);
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_3);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_4);

      TestWrite+= 0x00111111;
      TestData = TestWrite;
      MemAddr+= 32;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestData++);
      for (k=0; k<7; k++)
        HSW( ,TestData++);
   
      sprintf(Message,"BURST READS FOLLOWED BY BURST WRITES TO 
              DIFFERENT BANKS");
      msg_info(Message);
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_5);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_6);

      TestWrite+= 0x00111111;
      TestData = TestWrite;
      MemAddr1 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
      HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestData++);
      for (k=0; k<7; k++)
        HSW( ,TestData++);

      sprintf(Message,"BURST WRITES FOLLOWED BY BURST READS TO 
              DIFFERENT BANKS");
      msg_info(Message);
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestData++);
      for (k=0; k<7; k++)
        HSW( ,TestData++);
      
      TestData = TestWrite;
      MemAddr1 = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
      HSA(MemAddr1, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_7);
      for (k=0; k<7; k++)
      HSR( , TestData++, , NoMask, ,DelayValueTests_8);

      /** Verify the previously written data **/
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_9);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_10);

      sprintf(Message,"BURST WRITES FOLLOWED BY BURST WRITES TO THE 
              SAME BANK");
      msg_info(Message);
      MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 0x7C0;
      TestWrite+= 0x00111111;
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestData++);
      for (k=0; k<7; k++)
        HSW( ,TestData++);

      HSA(MemAddr+32, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestData++);
      for (k=0; k<7; k++)
        HSW( ,TestData++);

      sprintf(Message,"BURST READS FOLLOWED BY BURST READS TO THE SAME BANK");
      msg_info(Message);
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_11);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_12);

      HSA(MemAddr+32, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_13);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_14);

      sprintf(Message,"BURST WRITES FOLLOWED BY BURST WRITES TO 
              DIFFERENT BANKS");
      msg_info(Message);
      MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + 0x7E0;
      TestWrite+= 0x00111111;
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestData++);
      for (k=0; k<7; k++)
        HSW( ,TestData++);

      MemAddr1= SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);        
      HSA(MemAddr1,NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestData++);
      for (k=0; k<7; k++)
        HSW( ,TestData++);

      sprintf(Message,"BURST READS FOLLOWED BY BURST READS TO DIFFERENT BANKS");
      msg_info(Message);
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_15);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_16);

      HSA(MemAddr1,NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,DelayValueTests_17);
      for (k=0; k<7; k++)
        HSR( , TestData++, , NoMask, ,DelayValueTests_18);
    
      /** Does Non-BURST Transfers **/
        sprintf(Message,"WRITE FOLLOWED BY READ TO THE SAME BANK");
        msg_info(Message);
      AHBWriteMem(2, 16, 4, TestRead);
      MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestWrite);

      TestData = (TestRead & BUnMask0) |
                 ((TestRead+1 << 8) & BUnMask1) |
                 ((TestRead+2 << 16) & BUnMask2) |
                 ((TestRead+3 << 24) & BUnMask3);
      HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData, , NoMask, ,DelayValueTests_19);

      sprintf(Message,"READ FOLLOWED BY WRITE TO THE SAME BANK");
      msg_info(Message);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_20);

      TestWrite+= 0x00111111;
      MemAddr+= 4;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestWrite);

      sprintf(Message,"READ FOLLOWED BY WRITE TO DIFFERENT BANKS");
      msg_info(Message);
      TestData = TestWrite;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_21);

      MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,~TestWrite);

      sprintf(Message,"WRITE FOLLOWED BY READ TO DIFFERENT BANKS");
      msg_info(Message);
      MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestWrite);

      MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , ~TestWrite, , NoMask, ,DelayValueTests_22);
    
      /** Verify the previously written data **/
        MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_23);

      sprintf(Message,"WRITE FOLLOWED BY WRITE TO THE SAME BANK");
      msg_info(Message);
      MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
      TestWrite+= 0x00111111;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestWrite);

      HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,~TestWrite);

      sprintf(Message,"READ FOLLOWED BY READ TO THE SAME BANK");
      msg_info(Message);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_24);

      HSA(MemAddr+4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , ~TestWrite, , NoMask, ,DelayValueTests_25);

      sprintf(Message,"WRITE FOLLOWED BY WRITE TO DIFFERENT BANKS");
      msg_info(Message);
      MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
      TestWrite+= 0x00111111;
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,TestWrite);

      MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( ,~TestWrite);

      sprintf(Message,"READ FOLLOWED BY READ TO DIFFERENT BANKS");
      msg_info(Message);
      msg_info(Message);
      MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestWrite, , NoMask, ,DelayValueTests_26);

      MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , ~TestWrite, , NoMask, ,DelayValueTests_27);
    
      x++;
    }
  }
}

/************************************ End *************************************/
