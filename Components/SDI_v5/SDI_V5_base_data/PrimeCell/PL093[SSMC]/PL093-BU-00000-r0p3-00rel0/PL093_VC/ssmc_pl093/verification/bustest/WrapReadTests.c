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
--  File Name              : WrapReadTests.c.rca
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform transfers such that they cross banks
--
-- --=========================================================================*/

/******************************************************************************/
/******************************** Wrap Read Tests *****************************/
/******************************************************************************/

void WrapReadTests()
{
  /*
     Summary: Wrap Read Tests
     ========================
     This function performs the following:
     o  Bank0 & Bank1 are programmed as Synchronous banks.
     o  Memory widths of Bank0 & Bank1 are 32 bits and 16 bits respectively.
     o  Write transfers are done to the Bank0 and Bank1 with HBURST = Wrap8
        and Wrap16 respectively.
     o  The WRAPREAD bit is kept disabled durin the writes.
     o  The WRAPREAD bit is enabled and Read accesses are done to Bank0 and
        Bank1 with HBURST = Wrap8 and Wrap16 respectively.
     o  Eight such sets of Write Read transfers are carried out with different 
        aligned starting adderesses. The starting addresses used cause the 
        address to wrap whenever necessary. 
  */

  int   HSIZE0, HSIZE1, BURST0, BURST1, offset0, offset1, i;
  int32 MemAddr, TestData, WTCNCLData, ExtMuxData, SMBLSPOLData, SMBCRData0,
        SMBCRData1, TestData0, TestData1;
  int32 AddrMask[3] = {0x3, 0x2, 0x0};
  char report[75];
  char* SBurst[8] = {"SINGLE", "INCR", "INCR4", "INCR8",
                          "INCR16", "WRAP4", "WRAP8", "WRAP16"};
  char* SSize[3] = {"BYTE", "HALFWORD", "WORD"};


  /*  Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and */
  /*  CLKSTATUS defined in the Ssmc.h set the required  MemClkRatio and     */ 
  /*  SMClockEn field bits.                                                 */

  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);

  /*  Programming the SSMCTrBurstWT register to turn the mask ON/OFF and to */
  /*  set the BeatNo and BurstWT counts. The constants BWtMask_ON/OFF,      */
  /*  Beat0 to 15 and SSMCTrBurstWT0 to 15 are defined in Ssmc.h.           */
  
  SSMCTrBurstWTData = BWtMask_ON | Beat15 | SSMCTrBurstWT15;
  ConfigureBurstWT(SSMCTrBurstWTData);

 
  /*  Programming the SSMCTrWTCNCL register. The constant SMWTCNCLDI/EN       */
  /*  disables or Enables the SMCANCELWait signal. The constant               */ 
  /*  SMWAITIGNORE_0/1 enables or disables the SMWAITIGNORE respectively      */ 
  /*  and the constants WTCNCL0 to 63 are used to load the CANCEL WAIT count. */
  
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL10 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Configuring the system to LITTLE endian mode by setting ENDIANNESS = 0 **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);
  HSEN(LITTLE);

  
  /*  Programming the SSMCTrExtMuxWT register.The constant ExtMuxDI/EN       */
  /*  disables or enables the  External Mux. The constants ExtMuxAss0 to 15  */
  /*   and ExtMuxDAss0 to 15 define the Assertion and Deassertion counts.    */
  
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SMBLSPOLData);

  /** Set Bank 0 Memory Type as Synchronous SRAM (32 bits width) **/
  SSMCTrMEMBData[0] = 0x00000000;

  SMBCRData[0] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN |
                 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR8    | CRBURSTLENRD8    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD2);

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);


  /** Set Bank 1 Memory Type as AsSynchronous SRAM (16 bits width) **/
  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4   | CRBURSTLENRD16   |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW16           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK1, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD2);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Initialising the different parameters **/ 
  HSIZE0 = 2;
  HSIZE1 = 1;
  BURST0 = 6;
  BURST1 = 7;
  offset0 = 0x0;
  offset1 = 0x0;
  TestData0 = 0x11111110;
  TestData1 = 0x22222220;

  /** Performing WrapReadTests on Bank0 with HBURST= Wrap8  **/ 
  /** with starting address starting with different offsets **/
  
  /** Performing Wrap Read Test with starting Address offset of
      8 from Base Adress **/
  /** Disabling the WRAPREAD bit of Bank0 **/
  SMBCRData0 = SMBCRData[0] & 0xFFFFBFFF;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData0);

  /** Writing the data into Bank0 : WRAPREAD bit disabled **/
  sprintf(report,"WRITES ON BANK 0: MSIZE = WORD, HSIZE = %s,
          HBURST = INCR", SSize[HSIZE0]);
  C(report);

  MemAddr = SSMCMEM_0 ;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111116);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111117);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111110);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111111);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111112);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111113);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111114);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111115);

  /** Enabling the WRAPREAD bit of Bank0 **/
  SMBCRData0 = SMBCRData[0] | WRAPRD_EN;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData0);

  /** Performing Burst Wrap reads to Bank0 : WRAPREAD bit enabled **/
  offset0 = offset0 + 8;
  sprintf(report,"BURST READS ON BANK 0: MSIZE = WORD, HSIZE = %s,
          HBURST = %s", SSize[HSIZE0], SBurst[BURST0]);
  C(report);
  MemRead(0, BURST0, offset0, HSIZE0, 0x2, TestData0);

  
  /** Performing Wrap Read Test with starting Address offset of
      16 from Base Adress **/
  /** Disabling the WRAPREAD bit of Bank0 **/
  SMBCRData0 = SMBCRData[0] & 0xFFFFBFFF;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData0);

  /** Writing the data into Bank0 : WRAPREAD bit disabled **/
  sprintf(report,"WRITES ON BANK 0: MSIZE = WORD, HSIZE = %s,
          HBURST = INCR", SSize[HSIZE0]);
  C(report);

  MemAddr = SSMCMEM_0 ;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111114);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111115);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111116);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111117);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111110);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111111);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111112);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111113);

  /** Enabling the WRAPREAD bit of Bank0 **/
  SMBCRData0 = SMBCRData[0] | WRAPRD_EN;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData0);

  /** Performing Burst Wrap reads to Bank0 : WRAPREAD bit enabled **/
  offset0 = offset0 + 8;
  sprintf(report,"BURST READS ON BANK 0: MSIZE = WORD, HSIZE = %s,
          HBURST = %s", SSize[HSIZE0], SBurst[BURST0]);
  C(report);
  MemRead(0, BURST0, offset0, HSIZE0, 0x2, TestData0);


  /** Performing Wrap Read Test with starting Address offset of
      24 from Base Adress **/
  /** Disabling the WRAPREAD bit of Bank0 **/
  SMBCRData0 = SMBCRData[0] & 0xFFFFBFFF;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData0);

  /** Writing the data into Bank0 : WRAPREAD bit disabled **/
  sprintf(report,"WRITES ON BANK 0: MSIZE = WORD, HSIZE = %s,
          HBURST = INCR", SSize[HSIZE0]);
  C(report);

  MemAddr = SSMCMEM_0 ;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111112);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111113);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111114);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111115);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111116);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111117);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111110);

  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x11111111);

  /** Enabling the WRAPREAD bit of Bank0 **/
  SMBCRData0 = SMBCRData[0] | WRAPRD_EN;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData0);

  /** Performing Burst Wrap reads to Bank0 : WRAPREAD bit enabled **/
  offset0 = offset0 + 8;
  sprintf(report,"BURST READS ON BANK 0: MSIZE = WORD, HSIZE = %s,
          HBURST = %s", SSize[HSIZE0], SBurst[BURST0]);
  C(report);
  MemRead(0, BURST0, offset0, HSIZE0, 0x2, TestData0);


  /** Performing WrapReadTests on Bank1 with HBURST= Wrap16 **/ 
  /** with starting address starting with different offsets **/ 
  
  /** Performing Wrap Read Test with starting Address offset of
      8 from Base Adress **/
  /** Disabling the WRAPREAD bit of Bank1 **/
  SMBCRData1 = SMBCRData[1] & 0xFFFFBFFF;
  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData1);

  /** Writing the data into Bank1: WRAPREAD bit disabled **/
  sprintf(report,"WRITES ON BANK 1: MSIZE = HWORD, HSIZE = %s,
          HBURST = INCR", SSize[HSIZE0]);
  C(report);

  MemAddr = SSMCMEM_1 ;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222D222C);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222F222E);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22212220);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22232222);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22252224);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22272226);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22292228);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222B222A);
  
  /** Enabling the WRAPREAD bit of Bank1 **/
  SMBCRData1 = SMBCRData[1] | WRAPRD_EN;
  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData1);

  /** Performing Burst Wrap reads to Bank1: WRAPREAD bit enabled **/
  offset1 = offset1 + 8;
  sprintf(report,"BURST READS ON BANK 1: MSIZE = HALFWORD, HSIZE = %s,
          HBURST = %s", SSize[HSIZE1], SBurst[BURST1]);
  C(report);
  MemRead(1, BURST1, offset1, HSIZE1, 0x1, TestData1);
   


  /** Performing Wrap Read Test with starting Address offset of
      16 from Base Adress **/
  /** Disabling the WRAPREAD bit of Bank1 **/
  SMBCRData1 = SMBCRData[1] & 0xFFFFBFFF;
  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData1);

  /** Writing the data into Bank1: WRAPREAD bit disabled **/
  MemAddr = SSMCMEM_1 ;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22292228);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222B222A);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222D222C);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222F222E);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22212220);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22232222);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22252224);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22272226);
  
  /** Enabling the WRAPREAD bit of Bank1 **/
  SMBCRData1 = SMBCRData[1] | WRAPRD_EN;
  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData1);

  /** Performing Burst Wrap reads to Bank1: WRAPREAD bit enabled **/
  offset1 = offset1 + 8;
  sprintf(report,"BURST READS ON BANK 1: MSIZE = HALFWORD, HSIZE = %s,
          HBURST = %s", SSize[HSIZE1], SBurst[BURST1]);
  C(report);
  MemRead(1, BURST1, offset1, HSIZE1, 0x1, TestData1);
   

  /** Performing Wrap Read Test with starting Address offset of
      24 from Base Adress **/
  /** Disabling the WRAPREAD bit of Bank1 **/
  SMBCRData1 = SMBCRData[1] & 0xFFFFBFFF;
  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData1);

  /** Writing the data into Bank1: WRAPREAD bit disabled **/
  MemAddr = SSMCMEM_1 ;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22252224);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22272226);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22292228);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222B222A);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222D222C);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x222F222E);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22212220);
  
  MemAddr = MemAddr + 4;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,0x22232222);
  
  /** Enabling the WRAPREAD bit of Bank1 **/
  SMBCRData1 = SMBCRData[1] | WRAPRD_EN;
  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData1);

  /** Performing Burst Wrap reads to Bank1: WRAPREAD bit enabled **/
  offset1 = offset1 + 8;
  sprintf(report,"BURST READS ON BANK 1: MSIZE = HALFWORD, HSIZE = %s,
          HBURST = %s", SSize[HSIZE1], SBurst[BURST1]);
  C(report);
  MemRead(1, BURST1, offset1, HSIZE1, 0x1, TestData1);
   
}

/************************************ End *************************************/
